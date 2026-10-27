unit vtRichText;
(* Support for RTF files, client letters...
*)

interface

uses
  Classes, ComCtrls,
  vtMulti,

  RxRichEd; //20160819 Igor (It must be the last)

function GetRichElms(FrmNm: string): string;
//Procedure GetInterpetedRichEdit(RetNo:Integer;LetterName:String;ARichEdit:TRichEdit);
function GetInterpetedRichEdit(RetNo: Integer; LetterName: string; ARichEdit: TRichEdit): boolean;
procedure InsertBackFunction(ARichEdit: TRichEdit; InSearch, InSecondSearch, InReplace: string);
function GetLetterFileName(RetNo: Integer; FName: string): string;
function IsAcceptableGraphicsFile(FlName: string): Boolean;
function IsFormAClientLetter(FName: string): Boolean;
function RTFToPlainText(ARichEdit: TRichEdit): String;
procedure ReplaceRtfText(ARichEdit: TRichEdit; InSearch, InReplace: string);
//Function  GetKeyWListFromRichEdit(ARichEdit:TRichEdit;KeyWList:TStringList):Boolean;
function GetKeyWListFromRichEdit(DataDict: TDataDictList; ARichEdit: TRichEdit; KeyWList: TStringList): Boolean;
function CleanUpKeyW(KeyW: string): string;
procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string; DelimList: TStringList);
function IsKeyWInRtf(ARichEdit: TRichEdit; InSearch: string): Boolean;
procedure ConvertOldLetter(ARichEdit: TRichEdit);
procedure ReplaceRtfDelimiters(ARichEdit: TRichEdit; FromDelim, ToDelim: string);

function GetClientLettersDir(OptRec: TApp): string;
function MkClientLetterName(RetNo: Integer; fFullName: boolean = False): string;

implementation

uses
  SysUtils, FileCtrl, Windows, Messages,
  ekbasereport, ekfunc, EkRtf,
  vtCommon, vtMain,
  vtTrimStr, vtShared;

procedure AddDisplayFormatToRtf(ARichEdit: TCustomRichEdit; KeyWList: TStrings);
// i.e. [Taxable_amount] s/b FNum(Taxable_amount)
begin
  //
end;

function GetClientLettersDir(OptRec: TApp): string;
var
  Dir: string;
begin
  Dir := OptRec.Dir_Cur + '\' + 'ClientLetters';
  if not SysUtils.DirectoryExists(Dir) then //20150701
  begin
    if not CreateDir(Dir) then
      raise Exception.Create('Cannot create letters directory ' + Dir);
  end;
  Result := Dir;
end;

function MkClientLetterName(RetNo: Integer; fFullName: boolean): string;
begin
  Result := GetLastName(RetNo) + '-' + LeftStr(GetFirstName(RetNo), 1) + '.' + 'RTF';
  if fFullName then
    Result := GetClientLettersDir(RetList[RetNo].MyApp) + '\' + Result;
end;

function GetRichElms(FrmNm: string): string;
var
  i: Integer;
  TempList: TStringList;
begin
  Result := '';
  FrmNm := UpperCase(ExtractNonInstFormName(FrmNm));
  TempList := TStringList.Create;
  TempList.LoadFromFile(CurrentApp.AppDir + '\' + 'Rich.d');
  for i := 0 to TempList.Count - 1 do
  begin
    if FrmNm = UpperCase(RTrim(LeftStr(TemplIst[i], 10))) then
    begin
      Result := AllTrim(MidStr(TempList[i], 11, 15));
      Exit;
    end; //found form
  end; //i
end;

function GetInterpetedRichEdit(RetNo: Integer; LetterName: string; ARichEdit: TRichEdit): boolean;
//Procedure GetInterpetedRichEdit(RetNo:Integer;LetterName:String;Var ARichEdit:TwwDbRichEdit);
begin
  Result := RetList[RetNo].GetInterpetedRichEdit(LetterName, ARichEdit);
end;

procedure InsertBackFunction(ARichEdit: TRichEdit; InSearch, InSecondSearch, InReplace: string);
var
  X, Y, ToEnd: integer;
  OldVisible: Boolean; //20170410 Iogor
begin
  with ARichEdit do
  begin
    //20170410 Iogor >>>
    OldVisible := Visible;
    if not OldVisible then
    //20170410 Iogor <<<
      Visible := False;
    X := 0;
    ToEnd := length(ARichEdit.Text);
    X := FindText(inSearch, X, ToEnd, []);
    while X <> -1 do
    begin
      Y := X;
      Y := FindText(inSecondSearch, Y, ToEnd, []);
      SelStart := Y;
      SelLength := length(inSecondSearch);
      SelText := InReplace;
      X := FindText(inSearch, Y + length(InReplace), ToEnd, []);
    end;
    if OldVisible then  //20170410 Iogor
      Visible := True;
  end; //with
end;

function GetLetterFileName(RetNo: Integer; FName: string): string;
var
  OptRec: TApp;
  AppDir: string;
begin
  OptRec := RetList[RetNo].MyApp;
  AppDir := OptRec.AppDir;

  if FName = 'CLETTER' then
  begin
    Result := GetClientLettersDir(OptRec) + '\' + MkClientLetterName(RetNo);
    if FileExists(Result) then
      exit; //special letter
    if UpperCase(FetchElm(RetNo, 'INFO', 46)) = 'X' then {Efiled}
      Result := AppDir + '\' + 'EfiledLetter.RTF'
    else
      Result := AppDir + '\' + 'PaperFiledLetter.RTF';
  end;
  if FName = 'PIPEDA' then
    Result := AppDir + '\' + 'PIPEDALetter.RTF';
  if FName = 'ENGAGE' then
    Result := AppDir + '\' + 'EngagementLetter.RTF';
  if FName = 'CUSTINV' then
    Result := AppDir + '\' + 'CustInvLetter.RTF';
  if FName = 'ALETTER' then
    Result := AppDir + '\' + SomeLetterName; //global variable
end;

function IsAcceptableGraphicsFile(FlName: string): Boolean;
var
  Ext: string;
begin
  Result := False;
  Ext := UpperCase(ExtractFileExt(FlName));
  if (Ext = '.BMP')
    or (Ext = '.WMF')
    or (Ext = '.JPG')
    or (Ext = '.ICO') then
    result := true;
end;

function IsFormAClientLetter(FName: string): Boolean;
begin
  Result := False;
  if (FName = 'CLETTER')
    or (FName = 'PIPEDA')
    or (FName = 'ENGAGE')
    or (FName = 'CUSTINV')
    or (FName = 'ALETTER') {//for miscellaneous letters} then
    result := True;
end;

function RTFToPlainText(ARichEdit: TRichEdit): String;
var
  strStream: TStringStream;
begin
  strStream := TStringStream.Create('');
  try
    ARichEdit.PlainText := True;
    ARichEdit.Lines.SaveToStream(strStream);
    Result := strStream.DataString;
  finally
    strStream.Free;
  end;
end;

procedure ReplaceRtfText(ARichEdit: TRichEdit; InSearch, InReplace: string);
var
  X, ToEnd: integer;
  OldVisible: Boolean; //20170410 Iogor
begin
  with ARichEdit do
  begin
    //20170410 Iogor>>>
    OldVisible := Visible;
    if not OldVisible then
    //20170410 Iogor<<<
      Visible := False;
    X := 0;
    ToEnd := length(ARichEdit.Text);
    X := FindText(inSearch, X, ToEnd, []);
    while X <> -1 do
    begin
      SelStart := X;
      SelLength := length(inSearch);
      SelText := InReplace;
      X := FindText(inSearch, X + length(InReplace), ToEnd, []);
    end;
    if OldVisible then //20170410 Iogor
      Visible := True;
  end; //with
end;

function GetKeyWListFromRichEdit(DataDict: TDataDictList; ARichEdit: TRichEdit; KeyWList: TStringList): Boolean;
var
  Delim1List, Delim2List: TStringList;
  KeyW, tempKeyWFull: string;
  StartPos: Integer;
var
  i: integer;
begin
  Delim1List := TStringList.Create;
  Delim2List := TStringList.Create;
  GetDelimiterPositionsInRTf(ARichEdit, '[', Delim1List);
  GetDelimiterPositionsInRTf(ARichEdit, ']', Delim2List);
  Result := Delim1List.Count = Delim2List.Count;
  if Result then
  begin

    for i := 0 to Delim1List.count - 1 do
    begin
      with ARichEdit do
      begin
        SelStart := MyStrToInt(Delim1List[i]) + 1;
        SelLength := MyStrToInt(Delim2List[i]) - MyStrToInt(Delim1List[i]) - 1;
        KeyW := SelText;
        KeyW := CleanUpKeyW(KeyW);

        tempKeyWFull := KeyW;
        while (tempKeyWFull > '') do
        begin
          StartPos := Pos(' ', tempKeyWFull);
          if StartPos > 0 then
          begin
            KeyW := alltrim(LeftStr(tempKeyWFull, StartPos));
            tempKeyWFull := alltrim(RightStr(tempKeyWFull, Length(tempKeyWFull) - StartPos));
          end
          else
          begin
            KeyW := tempKeyWFull;
            tempKeyWFull := '';
          end;
          if (IsInList(KeyW, KeyWList) = -1) and (datadict.InDataDict(KeyW)) then
          begin
            if KeyW > '' then
              KeyWList.Add(KeyW);
          end;
        end;

      end;
    end;
    with ARichEdit do
    begin
      SelStart := Perform(EM_LINEINDEX, 0, 0);
      SelLength := 0;
    end;
  end;

  Delim1List.Free;
  Delim2List.Free;
end;

function CleanUpKeyW(KeyW: string): string;
//comes as If (keywxxx > 0)  etc > < || ! && etc
// also Need Ffix in front of dollar variables
begin
  Result := KeyW;

  KeyW := StringReplace(KeyW, 'IF (', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, 'IF(', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, 'ELSIF (', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, 'ELSIF(', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, 'ELSIF(', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, ')', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '''', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '"', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '=', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '>', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '<', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '||', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '&&', ' ', [rfReplaceAll, rfIgnoreCase]);
  KeyW := StringReplace(KeyW, '!', ' ', [rfReplaceAll, rfIgnoreCase]);

  Result := alltrim(KeyW);
end;

procedure GetDelimiterPositionsInRtf(ARichEdit: TRichEdit; SearchText: string; DelimList: TStringList);
var
  k, Endpos: Integer;
begin
  ARichEdit.HideScrollbars := True;
  ARichEdit.SelStart := 0;
  ARichEdit.SelLength := 0;
  with ARichEdit do
  begin
    k := 0;
    EndPos := length(ARichEdit.Text);
    k := FindText(SearchText, k, EndPos, []);
    while k <> -1 do
    begin
      if k <> -1 then
        DelimList.Add(IntToStr(k));
      k := FindText(SearchText, k + length(SearchText), EndPos, []);
    end;
  end; //with
  //ARichEdit.SelStart := 0;
  with ARichEdit do
  begin
    //SetFocus;
    SelStart := Perform(EM_LINEINDEX, 0, 0);
    SelLength := 0;
  end;

  // ARichEdit.HideScrollbars:=False;
end;

function IsKeyWInRtf(ARichEdit: TRichEdit; InSearch: string): Boolean;
var
  X, ToEnd: integer;
begin
  Result := False;
  with ARichEdit do
  begin
    X := 0;
    ToEnd := length(ARichEdit.Text);
    X := FindText(inSearch, X, ToEnd, []);
    if X <> -1 then
    begin Result := True;
      exit;
    end;
  end; //with

end;

procedure ConvertOldLetter(ARichEdit: TRichEdit);
begin
  ARichEdit.SelStart := 0;
  ARichEdit.SelectAll;
  //ARichEdit.Paragraph.Alignment := taLeftJustify;
  ReplaceRtfText(ARichEdit, '[If]', '[If (');
  ReplaceRtfText(ARichEdit, '[If ([', '[If (');
  ReplaceRtfText(ARichEdit, '[If ( [', '[If (');
  ReplaceRtfText(ARichEdit, '[Nested_If]', '[If (');
  ReplaceRtfText(ARichEdit, '[Nested_If ([', '[If (');
  ReplaceRtfText(ARichEdit, '[Nested_If ( [', '[If (');
  ReplaceRtfText(ARichEdit, '[Nested_Endif]', '[Endif');

  ReplaceRtfText(ARichEdit, ']>', ')>])');
  ReplaceRtfText(ARichEdit, '] >', ')>])');
  ReplaceRtfText(ARichEdit, ']<', ')<])');
  ReplaceRtfText(ARichEdit, '] <', ')<])');

  //ReplaceRtfText(ARichEdit,#$D, '');  //never ending loop
  //ReplaceRtfText(ARichEdit,'tab', ''); //nothing
  //remove tabs
  //CellText := StringReplace(CellText,#$D, '', [rfReplaceAll]);
  // Remove linebreaks
  //CellText := StringReplace(CellText, #$7, '', [rfReplaceAll]);
end;

procedure ReplaceRtfDelimiters(ARichEdit: TRichEdit; FromDelim, ToDelim: string);
begin
  ARichEdit.SelStart := 0;
  ARichEdit.SelectAll;
  ARichEdit.Paragraph.Alignment := paLeftJustify; //20160819 Igor
  ReplaceRtfText(ARichEdit, FromDelim, ToDelim);
end;


end.

