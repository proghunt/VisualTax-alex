{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryContentStreamProcessor.pas             }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryContentStreamProcessor;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, DebenuPDFLibraryImageDecoder, DebenuPDFLibraryExtra;

type
  TPDFProcessTokenEvent = procedure(const Tok: AnsiString) of object;

  TPDFContentStreamProcessor = class
  private
    TokPos: Integer;
    MaxLen: Integer;
    S: AnsiString;
    FOnProcessToken: TPDFProcessTokenEvent;
    FOptions: Integer;
    function NextToken: AnsiString;
  protected
    procedure ProcessTok(const Tok: AnsiString); virtual;
  public
    constructor Create(AOptions: Integer); virtual;
    procedure Process(const Source: AnsiString);
    property OnProcessToken: TPDFProcessTokenEvent read FOnProcessToken write FOnProcessToken;
  end;

  TPDFContentStreamTextSplitter = class(TPDFContentStreamProcessor)
  private
    FTextStream: AnsiString;
    FGraphicsStream: AnsiString;
    FInTextObject: Boolean;
    FLastTextPos: Integer;
    FTextSkipNext: Boolean;
    FLastNamePos: Integer;
  protected
    procedure ProcessTok(const Tok: AnsiString); override;
  public
    constructor Create(AOptions: Integer); override;
    property TextStream: AnsiString read FTextStream;
    property GraphicsStream: AnsiString read FGraphicsStream;
  end;

  TPDFContentStreamResourceReplacer = class(TPDFContentStreamProcessor)
  private
    FNewStream: AnsiString;
    FOldToks: TQuickPDFStringList;
    FNewToks: array of AnsiString;
  protected
    procedure ProcessTok(const Tok: AnsiString); override;
  public
    constructor Create(AOptions: Integer); override;
    destructor Destroy; override;
    procedure AddReplacePair(const OldTok, NewTok: AnsiString);
    property NewStream: AnsiString read FNewStream;
  end;

  TPDFContentStreamStackBalancer = class(TPDFContentStreamProcessor)
  private
    FSaveStateCount: Integer;
    FRestoreStateCount: Integer;
  protected
    procedure ProcessTok(const Tok: AnsiString); override;
  public
    constructor Create(AOptions: Integer); override;
    function GetBalancingSuffix: AnsiString;
  end;

implementation

{ TPDFContentStreamProcessor }

constructor TPDFContentStreamProcessor.Create(AOptions: Integer);
begin
  FOptions := AOptions;
end;

function TPDFContentStreamProcessor.NextToken: AnsiString;
var
  InWhitespace: Boolean;
  TokStart: Integer;
  TokEnd: Integer;
  InStr: Integer;
  InSlash: Boolean;
begin
  if TokPos < MaxLen then
  begin
    repeat
      InWhitespace := False;
      case S[TokPos] of
        #0,#9,#10,#12,#13,#32:
        begin
          InWhitespace := True;
          Inc(TokPos);
        end;
      end;
    until (not InWhitespace) or (TokPos > MaxLen);
    if TokPos = MaxLen then
    begin
      Result := S[TokPos];
      TokPos := MaxLen + 1;
    end else
    if TokPos < MaxLen then
    begin
      TokStart := TokPos;
      if S[TokStart] = '(' then
      begin
        InStr := 1;
        InSlash := False;
        repeat
          Inc(TokPos);
          if InSlash then
          begin
            InSlash := False;
          end else
          case S[TokPos] of
            '\': InSlash := True;
            ')': Dec(InStr);
            '(': Inc(InStr);
          end;
        until (InStr = 0) or (TokPos >= MaxLen);
        Inc(TokPos);
        Result := QPLCopy(S, TokStart, TokPos - TokStart);
      end else
      if S[TokStart] = '<' then
      begin
        if ((TokStart < Length(S)) and (S[TokStart + 1] = '<')) then
        begin
          Result := '<<';
          Inc(TokPos, 2);
        end else
        begin
          repeat
            Inc(TokPos);
          until (S[TokPos] = '>') or (TokPos >= MaxLen);
          Inc(TokPos);
          Result := QPLCopy(S, TokStart, TokPos - TokStart);
        end;
      end else
      if (S[TokStart] = '>') then
      begin
        if ((TokStart < Length(S)) and (S[TokStart + 1] = '>')) then
        begin
          Result := '>>';
          Inc(TokPos, 2);
        end;
      end else
      if (S[TokStart] = '[') or (S[TokStart] = ']') or (S[TokStart] = '''') then
      begin
        Result := S[TokStart];
        Inc(TokPos);
      end else
      begin
        repeat
          Inc(TokPos);
          InWhitespace := False;
          case S[TokPos] of
            #0,#9,#10,#12,#13,#32,#40,#47,#60,#91,#93: InWhitespace := True;
          end;
        until (InWhitespace) or (TokPos >= MaxLen);
        if (not InWhitespace) and (TokPos = MaxLen) then Inc(TokPos);
        TokEnd := TokPos - 1;
        Result := QPLCopy(S, TokStart, TokEnd - TokStart + 1);
        if InWhitespace and (TokPos = MaxLen) then Inc(TokPos);          
      end;
    end else
      Result := '';
  end else
    Result := '';
end;

procedure TPDFContentStreamProcessor.Process(const Source: AnsiString);
var
  Tok: AnsiString;
  TokStart: Integer;
  InlineImage: TPDFInlineImage;
begin
  MaxLen := Length(Source);
  if MaxLen > 0 then
  begin
    TokPos := 1;
    S := Source;
    repeat
      Tok := NextToken;
      if Tok = 'BI' then
      begin
        ProcessTok(Tok);
        TokStart := TokPos;
        DecodeInlineImage(S, TokPos, InlineImage, nil, nil);
        Tok := QPLCopy(S, TokStart, TokPos - TokStart);
      end;
      ProcessTok(Tok);
    until Tok = '';
  end;
end;

procedure TPDFContentStreamProcessor.ProcessTok(const Tok: AnsiString);
begin
  if Assigned(FOnProcessToken) then FOnProcessToken(Tok);
end;

{ TPDFContentStreamTextSplitter }

constructor TPDFContentStreamTextSplitter.Create(AOptions: Integer);
begin
  inherited Create(AOptions);
  FTextStream := '';
  FGraphicsStream := '';
  FInTextObject := False;
  FTextSkipNext := False;
end;

procedure TPDFContentStreamTextSplitter.ProcessTok(const Tok: AnsiString);
var
  GTok: AnsiString;
  TTok: AnsiString;
begin
  GTok := Tok;
  TTok := Tok;
  if Tok = 'BT' then FInTextObject := True;
  if FInTextObject then
  begin
    if (((QPLCopy(Tok, 1, 1) = '(') or (QPLCopy(Tok, 1, 1) = '<')) and
      (Tok <> '<<')) then
    begin
      GTok := '()';
    end;
  end;
  if Tok = 'ET' then FInTextObject := False;
  if QPLPos('|' + Tok + '|', '|S|s|f|F|f*|B|B*|b|b*|') > 0 then TTok := 'n';
  if Tok = 'Do' then
  begin
    Delete(FTextStream, FLastTextPos, MaxInt);
    TTok := '';
  end;
  if FTextSkipNext then
  begin
    TTok := '';
    FTextSkipNext := False;
  end;
  if Tok = 'BI' then
  begin
    TTok := '';
    FTextSkipNext := True;
  end;
  if Tok = 'EI' then
  begin
    TTok := '';
  end;

  if QPLCopy(GTok, 1, 1) = '/' then
    FLastTextPos := Length(FTextStream);

  if (Tok = 'sh') and (FLastTextPos > 0) then
  begin
    SetLength(FTextStream, FLastTextPos);
    TTok := '';
  end;

  FLastTextPos := Length(FTextStream);
  FTextStream := FTextStream + TTok + ' ';
  if FOptions = 900 then
  begin
    if GTok = 'sc' then GTok := 'rg';
    if GTok = 'scn' then GTok := 'rg';
    if GTok = 'SC' then GTok := 'RG';
    if GTok = 'SCN' then GTok := 'RG';             
    if ((GTok = 'Tf') or (GTok = 'cs') or (GTok = 'gs')) and (FLastNamePos > 0) then
    begin
      SetLength(FGraphicsStream, FLastNamePos);
      FLastNamePos := 0;
    end else
    begin
      if QPLCopy(GTok, 1, 1) = '/' then
        FLastNamePos := Length(FGraphicsStream);
      FGraphicsStream := FGraphicsStream + GTok + ' ';
    end;
  end else
    FGraphicsStream := FGraphicsStream + GTok + ' ';
end;

{ TPDFContentStreamResourceReplacer }

procedure TPDFContentStreamResourceReplacer.AddReplacePair(const OldTok,
  NewTok: AnsiString);
var
  I: Integer;
begin
  I := FOldToks.Count;
  FOldToks.AddObject('/' + OldTok, TObject(I));
  SetLength(FNewToks, I + 1);
  FNewToks[I] := '/' + NewTok;
end;

constructor TPDFContentStreamResourceReplacer.Create(AOptions: Integer);
begin
  inherited Create(AOptions);
  FNewStream := '';
  FOldToks := TQuickPDFStringList.Create;
  FOldToks.Sorted := True;
end;

destructor TPDFContentStreamResourceReplacer.Destroy;
begin
  FOldToks.Free;
  inherited;
end;

procedure TPDFContentStreamResourceReplacer.ProcessTok(const Tok: AnsiString);
var
  I: Integer;
begin
  inherited;
  if QPLCopy(Tok, 1, 1) = '/' then
  begin
    I := FOldToks.IndexOf(Tok);
    if I >= 0 then
      FNewStream := FNewStream + FNewToks[Integer(FOldToks.Objects[I])] + ' '
    else
      FNewStream := FNewStream + Tok + ' ';
  end else
    FNewStream := FNewStream + Tok + ' ';
end;

{ TPDFContentStreamStackBalancer }

constructor TPDFContentStreamStackBalancer.Create(AOptions: Integer);
begin
  inherited;
  FSaveStateCount := 0;
  FRestoreStateCount := 0;
end;

function TPDFContentStreamStackBalancer.GetBalancingSuffix: AnsiString;
var
  X: Integer;
begin
  Result := '';
  for X := 1 to FSaveStateCount - FRestoreStateCount do
  begin
    Result := Result + ' Q';
  end;
end;

procedure TPDFContentStreamStackBalancer.ProcessTok(const Tok: AnsiString);
begin
  inherited;
  if (Tok = 'q') then
  begin
    Inc(FSaveStateCount);
  end else
  if (Tok = 'Q') then
  begin
    Inc(FRestoreStateCount);
  end;
end;

end.
