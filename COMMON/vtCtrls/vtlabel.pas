unit vtLabel;

interface

uses
  WinAPI.Windows, WinAPI.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  {Vcl.comctrls,} WinAPI.richedit, Vcl.StdCtrls, rxRichEd, vtControlIntf, //20160901 Igor //20170127 Igor
  AnsiStrings, System.UITypes; //20170612 Igor

type
  TBorderType = (vtlblNoBorder, vtlblFull, vtlblUnderline);
type
  TRichText = AnsiString; //20151105 Igor // 16/09/2015 igor

  TvtLabel = class(TLabel, IvtControl) //20170127 Igor
  private
    FRichedit: TRichEdit;
    FRichtext: TRichText;
    Fupdatecount: integer;
    FisSelectionLabel: boolean;
    FisPrintable: boolean;
    FTrans: boolean;
    FBlackBox: boolean;
    FCraCertifCode: boolean;
    FBorderType: TBorderType;
    FPainting: boolean;
    FScaleKoeff: Extended;
    FPrintEveryPage: Boolean; //20160404 Igor
    FPrintEveryPageText: String;
    FRotated: boolean; // 20180605 Igor
    procedure SetBorderType(const Value: TBorderType);
    procedure SetBlackBox(const Value: boolean);
    procedure SetCraCertifCode(const Value: boolean);
    procedure SetRichText(const Value: TRichText);
    function GetRichEdit:TRichEdit;
    procedure RTFPaint(Canvas: TCanvas; ARect: TRect);

    procedure SetTop(Value: integer); //20160204 Igor
    function GetTop:Integer;          //20160204 Igor
    procedure SetLeft(Value: integer);//20160204 Igor
    function GetLeft:Integer;         //20160204 Igor
    function GetPrintEveryPageText: String; //20160404 Igor
    procedure SetPrintEveryPageText(Value: String); //20160404 Igor
    function GetvtIsPrintable: boolean;     //20170127 Igor
    procedure SetRotated(Value: boolean); // 20180605 Igor Igor
    { Private declarations }
  protected
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure Paint; override;
    procedure ChangeScale(M, D: Integer); override;
    procedure SetAutoSize(Value: Boolean); override; // 20180605 Igor
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    property RTF: TRichEdit read GetRichEdit;
    procedure ShowRTF;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure CopyFromRichEdit(richedit:TRichEdit);
    procedure CopyToRichEdit(richedit:TRichEdit);
//    procedure Print(Caption:string);
    procedure PaintTo(ACanvas: TCanvas);
    procedure DrawRotatedText(ACanvas: TCanvas; ARect: TRect; ALabel: TLabel; AAngle: integer = 90); // 20180605 Igor
  published
    property RichText: TRichText read FRichText write SetRichText;
    property vtisSelectionLabel: boolean read FisSelectionLabel write FisSelectionLabel default False;
    property vtIsPrintable: boolean read GetvtIsPrintable write FisPrintable default True; //20170127 Igor
    property vtTransparent: boolean read FTrans write FTrans default True;
    property vtBorderType: TBorderType read FBorderType write SetBorderType;
    property vtBlackBox: boolean read FBlackBox write SetBlackBox default False;
    property vtCraCertifCode: boolean read FCraCertifCode write SetCraCertifCode default False;
    property Transparent default False; //20160122 Igor
    property Top: Integer read GetTop write SetTop; //20160204 Igor
    property Left: Integer read GetLeft write SetLeft; //20160204 Igor
    property PrintEveryPage: Boolean Read FPrintEveryPage Write FPrintEveryPage Default False; //20160404 Igor
    property PrintEveryPageText: String read GetPrintEveryPageText write SetPrintEveryPageText; //20160404 Igor
    property vtRotated: boolean read FRotated write SetRotated default false; // 20180605 Igor
    { Published declarations }
  end;


procedure Register;

implementation

procedure TvtLabel.BeginUpdate;
begin
  inc(FUpdateCount);
end;

procedure TvtLabel.ChangeScale(M, D: Integer); //20230411 Igor
  function GetTextHeight(AText: string; AWidth: integer): integer;
  var
    R: TRect;
  begin
    R := Rect(0, 0, AWidth, 0);
    DrawText(Canvas.Handle, PChar(AText), Length(AText), R, DT_CENTER or DT_TOP or DT_WORDBREAK or DT_CALCRECT);
    Result := R.Height;
  end;
begin
  inherited;
  FScaleKoeff := FScaleKoeff * (M / D);
  if (FScaleKoeff <> 1.0) and not AutoSize then
    while True do
    begin
      Canvas.Font.Assign(Font);
      if Font.Size < 5 then
        break
      else if (WordWrap and (GetTextHeight(Caption, Width - 5) > Height - 1))
              or
              (not WordWrap and (Alignment = taCenter) and (Canvas.TextWidth(Caption) > Width)) then
        Font.Size := Font.Size - 1
      else
        break;
    end
end;

procedure TvtLabel.CopyFromRichEdit(richedit: TRichEdit);
var
  ss: TStringStream;
begin
  ss := TStringStream.Create('');
  try
    RichEdit.Lines.SaveToStream(ss);
    RichText := AnsiString(ss.DataString); //20170612 Igor
  finally
    ss.Free;
  end;
  Repaint;
end;

procedure TvtLabel.CopyToRichEdit(richedit: TRichEdit);
var
  ms: TStringStream;
  S,S2, dgt: TRichText; //20160331 Igor //20160329 Igor
  xPPI: Integer;     //20160331 Igor
begin
//20170612 igor >>>
  xPPI := GetDeviceCaps(self.Canvas.Handle, LOGPIXELSX);
  if xPPI <> 96 then
  Begin
    S := RichText;
    S2 := '';
    While AnsiStrings.AnsiPos('\fs', AnsiStrings.ansilowerCase(s)) > 0 do //20160329 Igor
    Begin
      S2 := S2 + copy(S, 1, AnsiStrings.AnsiPos('\fs', AnsiStrings.ansilowerCase(s)) + 2);//20160329 Igor
      Delete(S, 1, AnsiStrings.AnsiPos('\fs', AnsiStrings.ansilowerCase(s)) + 2);//20160329 Igor
      dgt := '';
      While (length(s)>0) AND (s[1] in ['0'..'9']) do
      Begin
        dgt := dgt+s[1];
        delete(s,1,1);
      end;
      if dgt <> '' then
        S2 := S2 + AnsiString(intToStr(ROUND(strToint(String(dgt))*96/xPPI)));
    end;
    S2 := S2 + s;
  end
  else
    S2 := RichText;
  //20160331 Igor <<<

  ms := TStringStream.Create('');
  try
    ms.WriteString(String(S2)); //20160331
    ms.Position := 0;
    RichEdit.PlainText := False;
    RichEdit.Lines.LoadFromStream(ms);
  finally
    ms.Free;
  end;
//20170612 igor <<<
end;

constructor TvtLabel.Create(AOwner: TComponent);
begin
  inherited;

  if (csDesigning in ComponentState) then
    FRichEdit := TRichEdit.Create(self)
  else
    FRichEdit := TRichEdit.Create(self.owner);
  FRichEdit.ScrollBars := System.UITypes.TScrollStyle.ssNone; //20170612 Igor
  FRichEdit.WordWrap := False;                 //20160901 Igor
  FRichEdit.SelectionBar := False; //20160905 Igor
  FRichEdit.Tag := Tag;//20170408 Igor
  FScaleKoeff := 1;

  FUpdateCount := 0;

  if csDesigning in ComponentState then
  begin
    AutoSize := True; //20230411 Igor
    FTrans := True; //regular transparent doesn't work for some reason.
    Height := 14;
    Width := 100;
    Font.style := [];
    Font.Name := 'Arial';
    Font.Height := -11;
    Font.Size := 8;
    FBorderType := vtlblUnderLine;
    //FisSelectionLabel := False;
  end;
  vtIsPrintable := True;
  Transparent := False; //20160122 Igor
end;

destructor TvtLabel.Destroy;
begin
  //FreeAndNil(FRichEdit);
  inherited;
end;

procedure TvtLabel.DrawRotatedText(ACanvas: TCanvas; ARect: TRect; ALabel: TLabel; // 20180605 Igor
  AAngle: integer);
var Res, Words: TStringList;
    I: integer;
    R, DrawRect: TRect;
    DrawFlags: Cardinal;
    TextWidth, TextHeight, XPos, YPos, LineWidth, LineHeight: integer;
    cStr, cNewWord: string;
    lf: TLogFont;
    SaveFont: HFont;
begin
  Res := TStringList.Create();
  Words := TStringList.Create();
  ACanvas.Font.Assign(Font);
  SaveFont := ACanvas.Font.Handle;
  try
    ACanvas.FillRect(ARect);
    if not ALabel.Transparent then
    begin
      ACanvas.Brush.Color := ALabel.Color;
      ACanvas.FillRect(ARect);
    end;
    ACanvas.Brush.Style := bsClear;

    R := Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);

    DrawRect := Rect(0, 0, ARect.Bottom - ARect.Top - 2, ARect.Right - ARect.Left - 2);
    // calculating text pos
    DrawFlags := DT_END_ELLIPSIS or DT_NOPREFIX or DT_WORDBREAK or DT_NOCLIP;
    if ALabel.Alignment = taLeftJustify then
      DrawFlags := DrawFlags or DT_Left
    else if ALabel.Alignment = taRightJustify then
      DrawFlags := DrawFlags or DT_RIGHT
    else
      DrawFlags := DrawFlags or DT_CENTER;
    DrawText(ACanvas.Handle, PChar(ALabel.Caption), -1, DrawRect, DrawFlags or DT_CALCRECT);

    TextWidth := DrawRect.Right;
    TextHeight := DrawRect.Bottom;

    if Alignment = taLeftJustify then
      XPos := R.Bottom - 2
    else if Alignment = taRightJustify then
      XPos := R.Top + TextWidth
    else
      XPos := R.Top + TextWidth + (R.Bottom - R.Top - TextWidth) div 2;

    if Layout = tlTop then
      YPos := R.Left
    else if Layout = tlBottom then
      YPos := R.Right - TextHeight
    else
      YPos := R.Left + (R.Right - R.Left - TextHeight) div 2;

    DrawRect.Left := YPos;
    DrawRect.Right := YPos + TextHeight;
    DrawRect.Top := XPos - TextWidth;
    DrawRect.Bottom := XPos;

    // splitting string to print lines
    Words.Text := StringReplace(ALabel.Caption, ' ', #13, [rfReplaceAll]);
    cStr := '';
    for I := 0 to Words.Count - 1 do
    begin
      cNewWord := Trim(Words.Strings[I]);
      if ACanvas.TextWidth(cStr + cNewWord) > TextWidth then
      begin
        Res.Add(Trim(cStr));
        cStr := '';
      end;
      cStr := cStr + cNewWord + ' ';
    end;
    Res.Add(Trim(cStr));

    // creating angled font
    GetObject(Acanvas.Font.Handle, SizeOf(lf), @lf);
    lf.lfescapement := AAngle * 10; //450;
    lf.lforientation := AAngle * 10; //450;
    if fsBold in Font.Style then
      lf.lfWeight := FW_BOLD
    else
      lf.lfWeight := FW_NORMAL;
    if fsItalic in Font.Style then
      lf.lfItalic := 1
    else
      lf.lfItalic := 0;
    ACanvas.Font.Handle := CreateFontIndirect(lf);

    // drawing text
    XPos := DrawRect.Left;
    for I := 0 to Res.Count - 1 do
    begin
      cStr := Res.Strings[I];
      LineWidth := ACanvas.TextWidth(cStr);

      if Alignment = taLeftJustify then
        YPos := DrawRect.Bottom
      else if Alignment = taRightJustify then
        YPos := DrawRect.Top + LineWidth
      else
        YPos := DrawRect.Top + LineWidth + (DrawRect.Bottom - DrawRect.Top - LineWidth) div 2;
      ACanvas.TextOut(XPos, YPos, cStr);
      XPos := XPos + TextHeight div Res.Count;
    end;

  finally
    ACanvas.Font.Handle := SaveFont;
    Res.Free;
    Words.Free;
  end;
end;

procedure TvtLabel.SetRotated(Value: boolean); // 20180605 Igor
begin
  FRotated := Value;
  if FRotated then
    AutoSize := false;
  //Repaint;
  Invalidate;
end;

procedure TvtLabel.SetAutoSize(Value: Boolean); // 20180605 Igor
begin
  if vtRotated then
    Value := false;
  inherited SetAutoSize(Value);
end;

procedure TvtLabel.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    dec(FUpdateCount);
    if (FUpdateCount = 0) then
      ShowRTF;
  end;
end;

function TvtLabel.GetRichEdit: TRichEdit;
begin
  if Assigned(Parent) and Assigned(FRichEdit) then
  begin
     FRichEdit.Parent := Parent;
     Result := FRichEdit;
  end
  else
    Result := nil;
end;

procedure TvtLabel.Loaded;
var
  s: AnsiString;//20151105 Igor
  i: integer;
begin
  inherited;
  if not (csDesigning in ComponentState) then begin
    if FRichText <> '' then begin       //20151016 Igor
      Parent.InsertControl(FRichEdit);
      FRichEdit.Parent := Parent;
      FRichEdit.Visible := FRichText <> '';
      FRichEdit.Top := Top;
      FRichEdit.Left := Left;
      FRichEdit.Height := Height - 1;
      FRichEdit.wIDTH := wIDTH;
      FUpdateCount := 0;
      FRichEdit.WordWrap := False;
      FRichEdit.BorderStyle := bsNone;
      FRichEdit.ReadOnly := true;
      FRichEdit.Color := Color;
      FRichEdit.ParentColor := ParentColor; //20151014 Igor
      FRichEdit.SelectionBar := False; //20160905 Igor

      //20151014 Igor
      if FRichtext <> '' then begin
         CopyToRichEdit(FRichEdit);
      end;
    end;
  end;
  s := FRichText;

  {$IFDEF DELPHI_UNICODE}
  if (Length(s) > 0) and (ord(s[1]) > 255) then
  {$ENDIF}
  begin
    for i := 1 to length(s) do
      s[i] := AnsiChar($FF and ord(s[i])); //20151105 Igor
    FRichText := s;
  end;
  if FRichText <> '' then
     Caption := '';
end;

procedure TvtLabel.Paint;
var
  r: TRect;
  es: Integer;
begin
  if not (csDesigning in ComponentState) then begin
     inherited Paint;
     exit;
  end;


  if RichText = '' then
    inherited Paint;

  if FUpdateCount > 0 then
    Exit;

  if not Assigned(FRichEdit) then
    Exit;

  if FPainting then
    Exit;

  FPainting := true;

  FRichEdit.Parent := Parent;
  if not FRichedit.Parent.HandleAllocated then
  begin
    FPainting := false;
    Exit;
  end;

  if not (csDesigning in ComponentState) then
  begin
    es := GetWindowLong(FRichEdit.Handle, GWL_EXSTYLE);
    es := es OR WS_EX_TRANSPARENT;
    SetWindowLong(FRichEdit.Handle, GWL_EXSTYLE, es);
  end;

  frichedit.Brush.Style := bsClear;
  frichedit.Height := 0;

  r.left := 0;
  r.right := r.left + Width;
  r.top := 0;
  r.bottom := r.top + Height;

  SetBkMode(Canvas.Handle,1);
  RTFPaint(Canvas,r);
//  FRichedit.Parent := nil; //20160404 igor

  FPainting := false;
end;

procedure TvtLabel.PaintTo(ACanvas: TCanvas);
begin
  FRichEdit.Parent := Parent;
  RTFPaint(ACanvas, ClientRect);
  FRichedit.Parent := nil;
end;

procedure TvtLabel.RTFPaint(Canvas: TCanvas; ARect:TRect);
const
  RTF_OFFSET :integer = 1;
type
  rFormatRange = record
    hdcSrc: HDC;
    hdcTarget: HDC;
    rc: TRect;
    rcPage: TRect;
    chrg: TCharRange;
  end;

var
  ms: TStringStream;
  fr: rFORMATRANGE;
  nLogPixelsX,nLogPixelsY: Integer;

begin
  ms := TStringStream.Create('');
  try
    ms.WriteString(String(RichText));
    ms.position := 0;
    FRichedit.Lines.LoadFromStream(ms);
  finally
    ms.free;
  end;

  FillChar(fr, SizeOf(TFormatRange), 0);

  nLogPixelsX := GetDeviceCaps(Canvas.Handle,LOGPIXELSX);
  nLogPixelsY := GetDeviceCaps(Canvas.Handle,LOGPIXELSY);

  if nLogPixelsX = 0 then
    nLogPixelsX := 96;

  if nLogPixelsY = 0 then
    nLogPixelsY := 96;

  if Transparent then
    Sendmessage(FRichedit.Handle,EM_SETBKGNDCOLOR,0,ColorToRGB(Parent.Brush.Color))
  else
    Sendmessage(FRichedit.Handle,EM_SETBKGNDCOLOR,0,ColorToRGB(Color));

  with fr do
  begin
    fr.hdcSrc := Canvas.Handle;
    fr.hdctarget := Canvas.Handle;
    fr.rcPage.left:=round(((arect.left+RTF_OFFSET)/nLogPixelsX)*1440);
    fr.rcPage.top:=round(((arect.top+RTF_OFFSET)/nLogPixelsY)*1440);
    fr.rcPage.right:=fr.rcPage.left+round(((arect.right-arect.left-RTF_OFFSET)/nLogPixelsX) * 1440);
    fr.rcPage.bottom:=(fr.rcPage.top+round(((arect.bottom-arect.top-RTF_OFFSET)/nLogPixelsY) * 1440));
    fr.rc.left:=fr.rcPage.left;  { 1440 TWIPS = 1 inch. }
    fr.rc.top:=fr.rcPage.top;
    fr.rc.right:=fr.rcPage.right;
    fr.rc.bottom:=fr.rcPage.bottom;
    fr.chrg.cpMin := 0;
    fr.chrg.cpMax := -1;
  end;

  SendMessage(FRichEdit.Handle,EM_FORMATRANGE,1,LParam(@fr));
  //clear the richtext cache
  SendMessage(FRichEdit.Handle,EM_FORMATRANGE,0,0);
end;

{procedure TvtLabel.Print(Caption: string);
begin
  if Assigned(Parent) and Assigned(FRichEdit) then
  begin
    FRichEdit.Parent := Parent;
    if FRichEdit.Parent.Handleallocated then
    begin
      Copytorichedit(fRichEdit);
      FRichEdit.print(Caption);
    end;
    FRichEdit.Parent := nil;
  end;
end;}

procedure TvtLabel.SetBlackBox(const Value: boolean);
begin
  if FBlackBox <> Value then
  begin
    FBlackBox := Value;
    invalidate;
  end;

  if csDesigning in ComponentState then
  begin
    if FBlackBox then
    begin
      FTrans := False;
      FBorderType := vtlblNoBorder;
      FisPrintable := True;
      Visible := True;
      Transparent := False;
      Height := 14;
      Font.Size := 8;
      Font.Color := clWhite;
      Color := clBlack;
      Alignment := taCenter;
    end;
  end;
end;

procedure TvtLabel.SetCraCertifCode(const Value: boolean);
begin
  if FCraCertifCode <> Value then
  begin
    FCraCertifCode := Value;
    invalidate;
  end;

  if csDesigning in ComponentState then
  begin
    if FCraCertifCode then
    begin
      FBorderType := vtlblNoBorder;
      FisPrintable := True;
      Visible := True;
      Font.Size := 7;
      Caption := 'VT--';
      Alignment := taRightJustify;
    end;
  end;
end;

procedure TvtLabel.SetRichText(const Value: TRichText);
begin
  FRichText := Value;
  Repaint;
end;

procedure TvtLabel.ShowRTF;
var
  ms: TStringStream;
begin
  if not Assigned(Parent) then
    Exit;
  if not Assigned(FRichEdit) then
    Exit;
  if not Parent.HandleAllocated then
    Exit;

  FRichEdit.Parent := Parent;
  ms := TStringStream.Create('');

  try
    FRichEdit.Lines.SaveToStream(ms);
    RichText := AnsiString(ms.DataString);
  finally
    ms.Free;
  end;

  Repaint;
  FRichEdit.Parent := nil;
end;

procedure TvtLabel.SetBorderType(const Value: TBorderType);
begin
  if FBorderType <> Value then
  begin
    FBorderType := Value;
    invalidate;
  end;

  if csDesigning in ComponentState then
  begin
    if FRichText <> '' then exit;
    //20230411 Igor >>>
    {if (FBorderType = vtlblNoBorder) and not vtRotated then // 20180605 Igor
      AutoSize := True
    else
      AutoSize := False;}
    //20230411 Igor <<
  end;
  Repaint;
end; //FBorderType

procedure TvtLabel.WMPaint(var Message: TWMPaint);
var
  R: TRect;
begin
  // 20180605 Igor >>>
  if vtRotated then
  begin
    Canvas.Brush.Color := Color;
    DrawRotatedText(Canvas, ClientRect, Self);
  end
  else
    inherited;
  // 20180605 Igor <<<
  if not (csDesigning in ComponentState) then
  begin
    if FRichtext <> '' then begin
       CopyToRichEdit(FRichEdit);
       SendMessage(FRichEdit.Handle, WM_USER + 225, round(FScaleKoeff * 1000), 1000);
    end;
  end;

  R := ClientRect;
  if fBorderType = vtlblUnderline then
  begin
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Style := bsClear; //20161129 Igor
    Canvas.Rectangle(R.Left, R.Bottom - 1, R.Right, R.Bottom);
  end
  else if fBorderType = vtlblFull then
  begin
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Style := bsClear; //20161129 Igor
    Canvas.Rectangle(R.Left, R.Bottom, R.Right, R.Top);
  end;

  if csDesigning in ComponentState then
  begin
    if FTrans = true then
      Transparent := True
    else
      Transparent := False;
  end;
end;

function TvtLabel.GetLeft: Integer;//20160204 Igor
begin
  Result := inherited Left;
end;

function TvtLabel.GetPrintEveryPageText: String; //20160404 Igor
begin
  Result := FPrintEveryPageText;
end;

function TvtLabel.GetTop: Integer; //20160204 Igor
begin
  Result := inherited Top;
end;

function TvtLabel.GetvtIsPrintable: boolean; //20170127 Igor
begin
  Result := FisPrintable;
end;

procedure TvtLabel.SetLeft(Value: integer); //20160204 Igor
begin
  inherited Left := Value;
  if assigned(FRichedit) then
  Begin
    FRichedit.Left := Value;
    Repaint;
  end;
end;

procedure TvtLabel.SetPrintEveryPageText(Value: String); //20160404 Igor
begin
  FPrintEveryPageText := Value;
end;

procedure TvtLabel.SetTop(Value: integer); //20160204 Igor
begin
  inherited Top := Value;
  if assigned(FRichedit) then
  Begin
    FRichedit.Top := Value;
    Repaint;
  end;
end;

procedure Register;
begin
  RegisterComponents('VisualTax', [TvtLabel]);
end;

end.

