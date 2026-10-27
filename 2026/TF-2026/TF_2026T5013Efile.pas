Unit TF_2026T5013Efile;

interface
uses
  SysUtils,FileCtrl,WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,Printers,
  TF_2026Declare,TF_2026TrimStr, ExtCtrls,
  //UImageForm,ChildWinNew,pdf417,vtLabel,vtShape,uprint,
  {UPopList,}Math,
  //URsiFrm,
  //UHtmlEol,Common2,
  TF_2026Calc, vtLabel //UEFSECURE,//20130622
  //webservices
  //ComObj,MsXml2_TLB,ShellApi, OleCtrls, SHDocVw, vtLabel;
  ;


type
  TSplitBarDataArray = Array of Array oF AnsiString;

type
  TT5013Efle = class(TForm)
    RsiFrmList: TListBox;
    PrintDialog1: TPrintDialog;
    HeaderBox: TPanel;
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    ShowBarCodeDataBtn: TBitBtn;
    WebServiceEfileBtn: TBitBtn;
    testingIndicator: TPanel;
    corFileClickLbl: TvtLabel;
    Label6: TLabel;
    URLForWebServices: TEdit;
    FileNameBox: TEdit;

    procedure CheckSecurity(Sender: TObject);
    Procedure fillEditFromMemo(RetNo:Integer);
    procedure PrepareData(Sender: TObject);
    Function GetSkipIndicator(RetNo:Integer;FName:String;LineNo:String):Boolean;
    Procedure PrepareAddressLoop(RetNo:Integer;FName:String;j:integer;Valu:String;ScheduleId:String;ToElm:Integer;K:Integer;MaxLoopCounter:Integer;LineNo:String);
    Procedure PrepareAnElement(ScheduleId,FName,LineNo,Valu,Inst:String);
    Function GetNumberOfRsiWithData(RetNo:Integer):Integer;

    procedure PrintBarCodePages(BarDataArray:Array of AnsiString);
    procedure CreateBarCode(SplitBarDataArray:TSplitBarDataArray;Var BarCodeImageArray:Array of TImage);
    procedure PrintBarCode(Var BarCodeImageArray:Array of TImage);
    procedure addToPage(RetNo:Integer;PageCount:Integer;TotalPages:Integer;ACanvas:TCanvas);
    procedure PrintBCRcertifPage(RetNo:Integer;PageCount:Integer;TotalPages:Integer;ACanvas:TCanvas);

    Procedure PrepareAmendedNotes(RetNo:Integer);
    function IncMinute(const AValue: TDateTime;const ANumberOfMinutes: Int64): TDateTime;

    Function SkipThisOne(RetNo:Integer;FName:String;ElmNo:Integer;valu:String):Boolean;
    Function GetSpecialSchedulesString(RetNo:Integer):String;
    Function DateForRSIPage5(s:String):String;
    Function GetMaxColumns(s:String):Integer;
    Function ChangeColumnNo(ColumnNo:Integer;ScheduleId:String):Integer;
    Function ReformatPostal(S:String):String;
    Function ReformatBNForBarCode(bn:String):String;
    Function ReformatSIN(S:String):String;
    Procedure CreateRSI100;
    Procedure CreateRSI101;
    Procedure CreateRSI125(Inst:Integer);
    Function  IsBsLineMandatory(Ln:String):Boolean;
    Function  IsIsLineMandatory(Ln:String):Boolean;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrepareRsiForm(RetNo:Integer;RsiForm:String;RsiSpecs:TStringList;Inst:integer);
    procedure ValidateBtnClick(Sender: TObject);
    Function ReformatPhoneNo(S:String):String;
    Function ReformatTrustNo(S:String):String;
    Function GetLineNo(LineCommand:String):String;
    Function GetLoopIndic(LineCommand:String;FName:String):Boolean;
    Function GetAddressIndic(LineCommand:String):Boolean;
    Function GetLargeFontIndic(LineCommand:String):Boolean;
    Function GetUnderLineIndic(DataType:String;Valu:String;LineNo:String):Boolean;
    procedure DrawBox(BoxRect:TRect; PenWidth: Integer;Shading:Boolean);
    procedure ShowBox(BoxRect:TRect; PenWidth: Integer;Shading:Boolean);
    Function ConvertYToPixels(Y:Real):Integer;
    Function ConvertXToPixels(X:Real):Integer;
    Function NextLineY(Y:Real):Real;
    Function GetSkipIndic(LineCommand:String):Boolean;
    Function FormatBarCodeAmount(Valu:String;NegativeIndic:Boolean):String;
    Function FormatStandardAmount(Valu:String;NegativeIndic:Boolean):String;
    procedure RsiFrmListClick(Sender: TObject);
    Function formatYesOrNoValu(Valu:String;FName:String;Elm:Integer):String;
    Function formatOneOrTwoValu(Valu:String):String;
    Function FormatOneOrTwoOrBlank(RetNo:Integer;FName:String;ElmNo:Integer;Valu:String):String;
    Function FormatOneOrBlank(Valu:String):String;
    Function FormatYesOrBlank(Valu:String;FName:String;Elm:Integer):String;
    Function FormatDateValu(Valu:String):String;
    Function GetMaxLoopCnt(LoopRefName:String):Integer;
    Function GetLoopRefName(s:String):String;
    Function GetActualText(S:String):String;
    Function PaddLUnderlined(valu:String):String;
    Function GetNumbOfEmptyLines(S:String):Integer;
    Function FormatPercent(Valu:String):String;
    Function GetTextX(s:String):real;
    Function CalcPages(ScheduleId:String):integer;
    Function GetColumnX(S:String):Real;
    Function GetColumnY(S:String):Real;
    Procedure InitColumnPositions;
    Function LineNoNumeric(S:string):Boolean;
    Function RoundPages(NumbLines:Integer):Integer;
    Function GetNegativeIndic(DataType:String;Valu:String):Boolean;
    Function GetValueFromForm(RetNo:Integer;FName:String;Elm:Integer;Inst:Integer):String;
    Function GetValuWidth(valu:String):real;
    procedure RsiFrmListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    Function RsiHasData(RetNo:Integer;RsiNm:String):Boolean;
    procedure PrepareSingleRSI(RsiForm:String);
    Function IsItAGifiForm(RsiNm:String):Boolean;
    procedure PrintErrorList(ErrorList:TstringList);
    Function IsFormTheIsGIFI(RsiForm:String):Boolean;
    Procedure PrepareMoreGifiIs(RsiForm:string);
    Procedure CheckColumnsRSI125(MaxPerColumn:Integer;Var Cnt:Integer;TempSpecs:TStringList);
    Procedure CheckColumnsRSI100(MaxPerColumn:Integer;Var Cnt:Integer;TempSpecs:TStringList);
    Procedure CheckColumnsRSI101(MaxPerColumn:Integer;Var Cnt:Integer;TempSpecs:TStringList);
    procedure PrntBarCodedBtnClick(Sender: TObject);
    procedure ShowBarCodeDataBtnClick(Sender: TObject);

    Function ExcludeInvalidCharacters(s:string):string;

    procedure WebServiceEfileBtnClick(Sender: TObject);
    procedure WebServiceEfile();

    function CanEfileValidation:boolean;

    procedure setwebServiceUserNamePassword(var webServiceUserName:string;var webServicePassword:string);

    procedure CreateSoapMessage(var SoapMsg:AnsiString;multiPartName:String);
    Function CreateSoapEnvelope() :ansistring;
    Function CreateSoapContent():ansistring;
    Function combineSoapEnvelopeContent(SoapE:AnsiString;CorData:AnsiString;multiPartName:String):ansistring;

    Procedure SubmitSoapMsg(SoapMsg:AnsiString;multiPartName:String);

    Procedure parseXmlResponse(rString:ansistring);

    Function ReplacePredefinedXMLEntities(info:String):String;
    procedure corFileClickLblClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);

//______________________________________________________________________________
//WEBSERVICES END
//------------------------------------------------------------------------------



  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RetNo:Integer; //??
 // AcceptedSecurity:Boolean;
  sURL:string;   //20130530
  InvalidCharactersList:TStringList;   //20140706
  Efiling:Boolean;
  SkipIt:Boolean;
  BarDataArray: array of AnsiString;
  T5013Efle: TT5013Efle;
  FieldDelim: String;
  RecordDelim: String;

  AddressIndic:Boolean;
  OutFileList:TStringList;
  InCol:Integer; {which column is being printed}
  PixPerInX, PixPerInY :Integer;
  VertIncr,LeftMargin,TopMargin,BottomY : real;
  LoopRef : TStringList;
  PageCnt : Integer;
  X,Y: real;
  PaddLChars:Integer;
  MaxWidth, charWidth,SpaceWidth:real;
  NumbOfPages:Integer;
  ColumnNo:Integer;
  ColumnX: Array[1..3] of real;
  ColumnY: Array[1..3] of real;
  MaxColumns:Integer; {mx columns in page. To contimue unless hard break}
  Inst : Integer;
  ErrorList:TstringList;
  TempCanvas :TBitMap;
  PrintLastLoopIndicator: Boolean;
  NoLineIndic:Boolean;
  FontType: Integer;
  WList :TStringList;
  CountingPagesSw : Boolean;
  bardata:ansiString;




implementation

uses TF_2026main, vtTrimStr, vtMain, vtMulti, vtCommon, TF_2026Declare;

{$R *.DFM}

Function TT5013Efle.GetUnderLineIndic(DataType:String;Valu:String;LineNo:String):Boolean;
begin
 If Valu >'' then result := False else result := True;
end;

Function TT5013Efle.IsBsLineMandatory(Ln:String):Boolean;
begin
  Result := False;
  If (Ln = '1000')
  or (Ln = '2600')
  or (Ln = '3500')
  or (Ln = '3660')  then
    result := True;
end;

Function TT5013Efle.IsIsLineMandatory(Ln:String):Boolean;
begin
  Result := False;
  If (Ln = '8000')
  or (Ln = '8300')
  or (Ln = '8519')
  or (Ln = '9369')

  or (Ln = '9370')
  or (Ln = '9660')
  or (Ln = '9899')
  or (Ln = '9970')
  or (Ln = '9975')
  or (Ln = '9976')

  or (Ln = '9980')
  or (Ln = '9985')
  or (Ln = '9990')
  or (Ln = '9995')
    then result := True;
end;

procedure TT5013Efle.FormCreate(Sender: TObject);
Var i:Integer;Templist,TempDirty:TStringList;s:String;
begin
 //20130530
 if testingIndicator.visible=True then
    sUrl:='https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl' //t2 testing
 else
    sUrl:='https://apps.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl'; //t2 production

  SysUtils.DeleteFile(AppDir+'\'+'BarData.txt');
 //RetNo := GetCurrentRetNo;                           ??
// FileNameBox.Text :=MkEFileName(RetNo);  /??
  FieldDelim:=Chr(29);
 RecordDelim:=Chr(13);
 //ShowBarCodeDataBtn.Enabled:=True; //False;  20090417
 OutFileList:=TStringList.Create;
 CountingPagesSw:=False;
 Wlist := TstringList.Create; {to break strings with commas}
 PrintLastLoopIndicator := True;
 ErrorList := Tstringlist.Create;

 LeftMargin :=0.3;
 TopMargin  :=0.4;
 BottomY    := 9.50;
 VertIncr   := 1/8;
 PaddLChars := 25;
 MaxWidth   := 1.50;
 CharWidth  := 1.25/15; {15 chars in 1.25 inches}
 SpaceWidth := 0.75/14;  {15 in 0.75 inches}
 NumbOfPages:=1;
 ColumnNo :=1;
 Inst:=1;   //2008/11/11
 InitColumnPositions;

 //fillEditFromMemo(RetNo);

 TempList:=TstringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'T5013Efile.D');

 For i:=0 to TempList.Count-1 do
  If UpperCase(LeftStr(TempList[i],8)) ='SCHEDULE' then
    RsiFrmList.Items.Add(TempList[i]);
 Templist.Free;

 LoopRef:=TstringList.Create;
 LoopRef.LoadFromFile(AppDir+'\'+'LoopRef.D');

 PrepareData(Sender);
 RsiFrmList.ItemIndex:=0;
 RsiFrmList.ItemIndex:=-1;

// UrlForWebServices.Text:=sUrl; //20130530
end;


Function TT5013Efle.excludeInvalidCharacters(s:string):string;
begin
    s := StringReplace(s, '°', '',[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s, '¢', '',[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s, '-', '',[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s, '¦', '',[rfReplaceAll, rfIgnoreCase]);

    result := s;
end;


Function TT5013Efle.GetValueFromForm(RetNo:Integer;FName:String;Elm:Integer;Inst:Integer):String;
Var i,TempFNo:Integer;
 buttonSelected : integer;
begin
  If (Elm=0) or (Elm=999) then
  begin
   Result :='';
   exit;
  end;
  //skip remaining address from certain forms
  If FName = 'T2' then    {add area to Telephone}
  begin
    If Elm = 1 then result := ReformatBnForBarCode(Result);

    If (FetchElm(RetNo,'T2',19) = '') and (Elm = 20)
       then result := ReformatPostal(Result);
  end;
  If LeftStr(FName ,4)= 'S564' then
  begin
    If Elm = 5 then  //telephone
    begin
    result :=AllTrim(FetchElm(RetNo,Fname,5)+ReformatPhoneNo(FetchElm(RetNo,FName,6)));
    end;
  end;
end;

procedure TT5013Efle.ValidateBtnClick(Sender: TObject);
Var i,j,K:Integer;RsiForm :string[13];TempList,RsiSpec:TStringList;
begin
end;

procedure TT5013Efle.CancelBtnClick(Sender: TObject);
Var FlName:String;
begin
BarDataArray :=nil;
ErrorList.Free;
OutFileList.Free;
InvalidCharactersList.free;
LoopRef.Free;
TempCanvas.Free;
WList.Free;

FlName:=FileNameBox.text;
Close;
end;


procedure TT5013Efle.PrepareSingleRSI(RsiForm:String);
Var i,j,cnt:Integer;TempList,RsiSpec:TStringList;
begin
 TempList:=TstringList.Create;
 RsiSpec := TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'RSI.D');

 {Locate form specs}
 i:=0;j:=-1;
 Repeat
 If AllTrim(LeftStr(TempList[i],13)) = RsiForm then
  begin
   j:=i;
   break;
  end;
 Inc(i);
 until (i>TempList.Count);

 If J = -1 then
 begin
  ShowMessage('RSI specifications not found');
  Exit;
 end;

 {get the specs}
 i:=j;
 RsiSpec.Add(TempList[i]);
 i:=i+1;
 Repeat
  RsiSpec.Add(TempList[i]);
  Inc(i);
 until (UpperCase(LeftStr(TempList[i],8)) = 'RSIEND')
       or (UpperCase(LeftStr(TempList[i],8)) = 'SCHEDULE')
       or (i>TempList.Count);

 TempList.Free;
 If RsiSpec.Count =0 then begin RsiSpec.Free;exit;end;

 Screen.Cursor := crHourGlass;
 PrepareRsiForm(RetNo,RsiForm,RsiSpec,Inst);
 RsiSpec.Free;
 Screen.Cursor := crDefault;
end;

Procedure TT5013Efle.PrepareAnElement(ScheduleId,FName,LineNo,Valu,Inst:String);
Var
  XPos, YPos:Integer;
  Hdc : Thandle;
  NullString : Array [0..150] of Char;
  s,FdelimAndInst: string;
begin
  If SkipIt = True then exit;
  If (Valu > '')
  then
  begin
   if inst = '' then
    FdelimAndInst := ''
   else
    FdelimAndInst := FieldDelim + Inst;

   barData := barData + LineNo + valu + FdelimAndInst + RecordDelim;

   //ShowMessage(FName);

   if inst = '' then
    FdelimAndInst := ''
   else
    FdelimAndInst := '+' + Inst;
   OutFileList.Add(LineNo + valu + FdelimAndInst + '*');
  end;

end;

Function TT5013Efle.GetLineNo(LineCommand:String):String;
Var i:Integer;
begin
 result:='';
 If (UpperCase(LineCommand) = 'COLUMN 1') or
    (UpperCase(LineCommand) = 'COLUMN 2') or
    (UpperCase(LineCommand) = 'COLUMN 3') or
    {(UpperCase(LineCommand) = 'PAGES')    or}
    (UpperCase(LineCommand) = 'BOX') or
    (UpperCase(LineCommand) = 'HEADER') or
    (UpperCase(LineCommand) = 'TEXT') or
    (UpperCase(LineCommand) = 'FOOTER') or
    (UpperCase(LineCommand) = 'EMPTY') or
    (UpperCase(LineCommand) = 'BOLD') or
    (UpperCase(LineCommand) = 'UNDERL') or
    (UpperCase(LineCommand) = 'MAXCOLS') or
    (GetSkipIndic(LineCommand) = True)
 then exit;

 For i :=0 to Length(LineCommand) do
  If LineNoNumeric(LineCommand[i]) then result:=result+LineCommand[i];

 If      Length(Result) = 0 then result:=''
 else If Length(result) = 1 then result:='00'+result
 else if Length(result) = 2 then result:='0'+result;

 If Length(result) < 3 then result :='';
end;


Function TT5013Efle.GetAddressIndic(LineCommand:String):Boolean;
Var i:Integer;
begin
 Result := False;
 For i :=0 to Length(LineCommand) do
  If LineCommand[i]= '@' then begin result :=True;exit;end;
end;

Function TT5013Efle.GetLoopIndic(LineCommand:String;FName:String):Boolean;
Var i:Integer;
begin
 Result := False;
 For i :=0 to Length(LineCommand) do
 begin
  //should not be a RecordDelim delim...is part of the specs
  If LineCommand[i] = '*' then
  begin
    result :=True;
    exit;
  end;
 end;
end;

Function TT5013Efle.GetNumbOfEmptyLines(S:String):Integer;
Var i:Integer;
begin
 Result := 0;
 Result := MyStrToInt(AllTrim(MidStr(s,14,2)));
end;

Function TT5013Efle.GetColumnX(S:String):Real;
Var i:Integer;
begin
 Result := Vl(AllTrim(MidStr(s,14,5)));
end;

Function TT5013Efle.GetColumnY(S:String):Real;
Var i:Integer;
begin
 Result := Vl(AllTrim(MidStr(s,22,4)));
end;


Function TT5013Efle.GetActualText(S:String):String;
begin
 Result := MidStr(s,20,255);
end;

Function TT5013Efle.GetSkipIndic(LineCommand:String):Boolean;
Var i:Integer;
begin
 Result := False;
 For i :=0 to Length(LineCommand) do
  If LineCommand[i]= '^' then begin result :=True;exit;end;
end;


Function TT5013Efle.GetMaxLoopCnt(LoopRefName:String):Integer;
Var i,j,Cnt,FromElm, ToElm,ByIncr:Integer;FName:String;
begin
 {check first column of table, if empty stop}
 Result:=-1;
 Cnt:=0;
 If LoopRefName = '' then exit;
 For I:=0 to LoopRef.Count-1 do
 begin
   If LoopRefName = AllTrim(UpperCase(LeftStr(LoopRef[i],10))) then
   begin
    Fname   := UpperCase(AllTrim(MidStr(LoopRef[i],11,10)));
    If Inst>1 then FName:=ExtractNonInstFormName(FName)+'#'+AllTrim(IntToStr(Inst)); //2008/10/21 i.e dealing with S60#2
    If GetFormNo(FName) =0 then exit;
    //20130522
    FromElm := MyStrToInt(AllTrim(MidStr(LoopRef[i],21,4)));
    ToElm   := MyStrToInt(AllTrim(MidStr(LoopRef[i],25,4)));
    ByIncr  := MyStrToInt(AllTrim(MidStr(LoopRef[i],29,3)));

    j:=FromElm;
    Repeat
     If GetValueFromForm(RetNo,FName,j,Inst) >'' then
      inc(Cnt);
     Inc(j,ByIncr);
    until j>ToElm;
    break;
   end;
 end; {loop i}
 If Cnt=0 then cnt:=1;
 result := Cnt;
end;

Function TT5013Efle.FormatBarCodeAmount(Valu:String;NegativeIndic:Boolean):String;
begin
 {
 Valu:=FormatRSIDollarAmount('',Valu,0);
 valu:=ReplaceChar(Valu,',' , ''); //replace commas with nil
 Result:=Valu;
 }
end;

Function TT5013Efle.FormatStandardAmount(Valu:String;NegativeIndic:Boolean):String;
begin
 //result:=FormatRSIDollarAmount('',Valu,0);
end;



procedure TT5013Efle.RsiFrmListClick(Sender: TObject);
Var i,j:Integer;RsiForm :string[13];TempList,RsiSpec:TStringList;
begin
 If RsiFrmList.ItemIndex <0 then exit;
 TempList:=TstringList.Create;
 RsiSpec := TstringList.Create;
 RsiForm := AllTrim(
   LeftStr(RsiFrmList.Items[RsiFrmList.ItemIndex],13));
 TempList.LoadFromFile(AppDir+'\'+'T1013Efile.D');
 {Locate form specs}
 i:=0;j:=-1;
 Repeat
 If AllTrim(LeftStr(TempList[i],13)) = RsiForm then
  begin
   j:=i;
   break;
  end;
 Inc(i);
 until (i>TempList.Count);

 If J = -1 then
 begin
  ShowMessage('RSI specifications not found');
  Exit;
 end;

 {get the specs}
 i:=j;
 RsiSpec.Add(TempList[i]);
 i:=i+1;
 Repeat
  RsiSpec.Add(TempList[i]);
  Inc(i);
 until (UpperCase(LeftStr(TempList[i],8)) = 'RSIEND')
       or (UpperCase(LeftStr(TempList[i],8)) = 'SCHEDULE')
       or (i>TempList.Count-1);

 TempList.Free;
 RsiSpec.Free;
end;


Function TT5013Efle.FormatYesOrBlank(Valu:String;FName:String;Elm:Integer):String;
begin
  If UpperCase(Valu) = 'Y' then
   result:='1'
  else
   result :='';
end;

Function TT5013Efle.FormatYesOrNoValu(Valu:String;FName:String;Elm:Integer):String;
begin
  If (UpperCase(Valu) = 'X') or (UpperCase(Valu) = 'Y') then result:='1' else result :='2';
 // If (Fname = 'FNOTE_1') and (Elm = 28) and (UpperCase(FetchElm(RetNo,'FNOTE_1',27)) = 'X') then result :='';

end;

Function TT5013Efle.FormatOneOrTwoValu(Valu:String):String;
begin
  If UpperCase(Valu) = 'X' then result:='1' else result :='2';
end;

Function TT5013Efle.FormatOneOrBlank(Valu:String):String;
begin
  If UpperCase(Valu) = 'X' then result:='1' else result :='';
end;

Function TT5013Efle.FormatOneOrTwoOrBlank(RetNo:Integer;FName:String;ElmNo:Integer;Valu:String):String;
begin
  If UpperCase(Valu) = 'X' then
    result:='1'
  else
  begin
   If AllTrim(FetchElm(RetNo,FName,ElmNo+1)) = '' then
    result :=''
   else
    result := '2';
  end;
end;


Function TT5013Efle.FormatDateValu(Valu:String):String;
begin
  result := ReplaceChar(Valu,'/', '');
  result := ReplaceChar(result,'-', '');
end;

Function TT5013Efle.FormatPercent(Valu:String):String;
Var x:real;
begin
 If Valu = 'NA' then exit;
 valu := AllTrim(valu);
 x := Vl(valu);
 result := FormatFloat('#0.###',x);
 If (result = '0') or (result = '0.00') or (Result = '.00') then result :='';
end;

Function TT5013Efle.GetLoopRefName(s:String):String;
begin
 result := AllTrim(MidStr(S,34,9));
end;


Function TT5013Efle.PaddLUnderlined(valu:String):String;
Var i,NumbSpaces,NumbChars:Integer;MaxLength :integer;
ValuWidth,
PaddRWidth :real;PaddRChars :integer;
PaddLWidth :real;PaddLChars :integer;
CWidth,SWidth:Real;
begin
 result     :=valu;
 If FontType = 1 then
 begin
   CWidth:= CharWidth;
   SWidth := SpaceWidth;
 end
 else
 begin
  CWidth:= CharWidth * 1.50;
  SWidth := SpaceWidth * 1.50;
 end;
 ValuWidth  := Length(valu) * CWidth;
 PaddRWidth := MaxR(0,MaxWidth -ValuWidth);
 PaddRChars := Trunc(PaddRWidth/SWidth);
 If ValuWidth>0 then
  Result := Valu+Space(PaddRChars)  {-1}
 else
  Result := Valu+Space(PaddRChars);
end;

Function TT5013Efle.GetValuWidth(valu:String):real;
Var i,NumbSpaces,NumbChars:Integer;MaxLength :integer;
ValuWidth,PaddLWidth :real;
PaddLChars :integer;
begin
 {
 NumbChars  := Length(AllTrim(Valu));
 NumbSpaces := CountSpacesInString(Valu);
 Result  := NumbChars * CharWidth + NumbSpaces * SpaceWidth;
 }
end;

Function TT5013Efle.LineNoNumeric(S:string):Boolean;
Var i:integer;
begin
 If s ='' then begin Result := false;exit;end;
 For i:= 1 to Length(S) do
 If S[i] in ['0','1','2','3','4','5','6','7','8','9'] then
   Result := True
  else
   begin Result := False;Exit; end;
end;


Function TT5013Efle.RoundPages(NumbLines:Integer):Integer;
begin
 result :=Trunc(NumbLines/30)+1;
end;


Function TT5013Efle.GetNegativeIndic(DataType:String;Valu:String):Boolean;
begin
 Result := False;
 If (LeftStr(DataType,1) = '$') and (Vl(AllTrim(Valu)) <0) then result := True;
end;

procedure TT5013Efle.PrintErrorList(ErrorList:TstringList);
Var FileNm:String;Hdr1,Hdr2,Hdr3:String[80];
begin
 FileNm := AppDir+'\'+'Temp';
 ErrorList.SaveToFile(FileNm);
 Hdr1 := 'RSI SPECS - ERROR LIST';
 Hdr2 := FilledStr(80,'=');
 Hdr3 := FilledStr(80,'=');

 If PrintDialog1.Execute then
 begin
  If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
 end;
end;

procedure TT5013Efle.PrepareRsiForm(RetNo:Integer;RsiForm:String;RsiSpecs:TStringList;Inst:Integer);
Var i,ii,j,k,Ndx,FNo,ElmNo,FromElm,ToElm,ByIncr,
    FontSize,NumbOfEmptyLines:integer;
    LineCommand,s,ss:String;FName:String[10];ElmString:String[6];
    DataType:String[4];LineNo:String[5];DataLengthString:String[5];
    LineValu,valu:String;
    BoldIndic,UnderlineIndic,NegativeIndic:Boolean;
    LoopIndic, LargeFontIndic:Boolean;
    ScheduleId :String[10];
    BoxRect :TRect;
    LeftOfBox,TopOfBox,RightOfBox,BottomOfBox:real;
    BoxShading:Boolean;
    LoopRefName  : String[12];
    MaxLoopCounter:Integer;

begin
 SkipIt:=False;
 PrintLastLoopIndicator := True;
 AddressIndic:=False;
 If RsiSpecs.Count <=0 then exit;
 S:= RsiSpecs[0];
 ScheduleId := AllTrim(MidStr(s,10,4));
 {BODY OF RSI FORM}
 If RsiSpecs.count <2 then exit;
 barData := barData + ScheduleId + FieldDelim + AllTrim(IntToStr(Inst))+ RecordDelim;
 OutFileList.Add(ScheduleId + '+' + AllTrim(IntToStr(Inst))+ '*');
 i:=1;
 Repeat
  S            := RsiSpecs[i];

  {ShowMessage(S);}
  LineCommand  := AllTrim(MidStr(S,1,10));
  FName        := AllTrim(MidStr(S,14,8));

  Fname:=AttachInstToFNameForRsi(FName,Inst);
  ElmString    := Alltrim(MidStr(s,22,4));
  ElmNo        := MyStrToInt(AllTrim(ElmString));
  DataType     := AllTrim(MidStr(S,59,5));
  LineNo       := GetLineNo(LineCommand);
  LoopIndic    := GetLoopIndic(LineCommand,FName);
  AddressIndic := GetAddressIndic(LineCommand);
  LoopRefName  := GetLoopRefName(S);

  {validate}
  If (LoopIndic =true) and (GetMaxLoopCnt(LoopRefName) = -1) then
  begin
    ShowMessage('Loop incorrect in: '+s);
    exit;
  end;

  If (UpperCase(LineCommand) = 'COLUMN 1') or
    (UpperCase(LineCommand) = 'COLUMN 2') or
    (UpperCase(LineCommand) = 'COLUMN 3') or
    (UpperCase(LineCommand) = 'BOX') or
    (UpperCase(LineCommand) = 'HEADER') or
    (UpperCase(LineCommand) = 'TEXT') or
    (UpperCase(LineCommand) = 'FOOTER') or
    (UpperCase(LineCommand) = 'EMPTY') or
    (UpperCase(LineCommand) = 'BOLD') or
    (UpperCase(LineCommand) = 'UNDERL') or
    (UpperCase(LineCommand) = 'MAXCOLS') or
    (GetSkipIndic(LineCommand) = True)
    then
    //do nothing

   else If LoopIndic then   {Loop}
   begin
     SkipIt:=GetSkipIndicator(RetNo,FName,LineNo);
     FromElm := MyStrToInt(AllTrim(MidStr(S,22,4)));  //20121003
     ToElm   := MyStrToInt(AllTrim(MidStr(S,26,4)));  //20121003
     ByIncr  := MyStrToInt(AllTrim(MidStr(S,30,3)));
     LoopRefName := AllTrim(MidStr(S,34,8));
     MaxLoopCounter := GetMaxLoopCnt(LoopRefName);
     j:=FromElm;
     K:=1; //row
     Repeat
      FNo := GetFormNo(FName);
      If (FNo =0) or (FromElm =0) or (ToElm =0) or (ByIncr=0) then
        valu := ''
      else if FNo = GetFormNo('FNOTE2') then
        Valu := FetchElm(RetNo,FName,j) //GetValueFromForm(RetNo,FName,j,Inst) //20101126
      else
        Valu := GetValueFromForm(RetNo,FName,j,Inst);


      If DataType = 'Y/N' then Valu := FormatYesOrNoValu(Valu,FName,ElmNo);
      If DataType = 'Y/b' then Valu := FormatYesOrBlank(Valu,FName,ElmNo);
      If DataType = '1/2' then Valu := FormatOneOrTwoValu(Valu);
      If DataType = '1/b' then Valu := FormatOneOrBlank(Valu);
      If DataType = '1/' then Valu := FormatOneOrTwoOrBlank(RetNo,FName,ElmNo,Valu);
      NegativeIndic := GetNegativeIndic(DataType,Valu);
      If DataType = '$' then
        valu := FormatBarCodeAmount(Valu,NegativeIndic)
      else if DataType = '$$' then
          valu := JustRight(FormatStandardAmount(Valu,NegativeIndic),13);
      If DataType = '%' then  valu := FormatPercent(Valu);
      If (DataType = 'D/T') or (DataType = 'D') then Valu := FormatDateValu(Valu);


      {
      If (Fname = 'S511') then
      begin
       If LineNo='400' then  If valu='' then begin  DataType:='A/N';valu:='0'; end;
       If LineNo='500' then  If valu='' then begin  DataType:='A/N';valu:='0'; end;
      end;
      }

      If AddressIndic then
      begin
       If InFormsWithSpecialAddress(FName) then
           PrepareAddressLoop(RetNo,FName,j,Valu,ScheduleId,ToElm,K,MaxLoopCounter,LineNo);
      end
      else
       PrepareAnElement(ScheduleId,FName,LineNo,valu,IntToStr(k));  {Row}

      Inc(J,ByIncr);
      Inc(k,1);
     until  (j>ToElm) or (k>MaxLoopCounter);
  end

  {lines and data}
  else If LineNo > '' then   {Line Number}
   begin
    If LeftStr(FName,1) = '=' then
    {Line valu}
    else If (FName >'') and (ElmNo >=0) then
    begin
      FNo := GetFormNo(FName);
      If ElmNo >0 then
      begin
       If ElmNo=999 then
        valu :=''
       else
       begin
        Valu := GetValueFromForm(RetNo,FName,ElmNo,Inst);
        If (AddressIndic) and (InFormswithSpecialAddress(Fname)) then valu:=GetSpecialAddressValu(RetNo,FName,ElmNo,Valu);
       end;
      end
      else
       Valu := '';
      {
      If (ScheduleId = '200') and (LineNo= '300') and (vl(valu) =0) then begin DataType:='A/N';valu :='0';end;
      If (LineNo= '9899') and (valu ='') then begin DataType:='A/N';valu :='';end;
      If (LineNo= '3849') and (vl(valu) =0) then begin DataType:='A/N';valu :='0';end;
      If (LineNo= '3849') and (vl(valu) =0) and (FName='GIFIBS#2') then begin DataType:='A/N';valu :='0';end;
      If (LineNo= '9999') and (Vl(valu) =0) then begin DataType:='A/N';valu :='0';end;
      If (LineNo= '2599') and (Vl(valu) =0) then
        begin DataType:='A/N';valu :='0';end;
      If (LineNo= '3499') and (Vl(valu) =0) then begin DataType:='A/N';valu :='0';end;

      If (LineNo= '9368') and (Vl(valu) =0) then
      begin
       If vl(GetGifiValFromMem(RetNo,GetFormNo('GIFIIS#1'),'9898'))=0 then   //20130515
        DataType:='A/N';valu :='0';
      end;
      }
      {
      If (ScheduleId = '125') and (CountIncStatements(RetNo) >1) then
      begin
        // replace 9970 with total of 9369 and 9899 of the inc, stm if multiple
        If LineNo = '9970' then
         Valu := FloatToStr(Vl(GetGifiValFromMem(
           RetNo,GetFormNo('GIFIIS#'+AllTrim(IntToStr(Inst))),'9369'))+
             Vl(GetGifiValFromMem(
               RetNo,GetFormNo('GIFIIS#'+AllTrim(IntToStr(Inst))),'9899')));
      end;
      }
      If DataType = 'Y/N' then Valu := FormatYesOrNoValu(Valu,FName,ElmNo);
      If DataType = 'Y/b' then Valu := FormatYesOrBlank(Valu,FName,ElmNo);
      If DataType = '1/2' then Valu := FormatOneOrTwoValu(Valu);
      If DataType = '1/b' then Valu := FormatOneOrBlank(Valu);
      If DataType = '1/' then Valu := FormatOneOrTwoOrBlank(RetNo,FName,ElmNo,Valu);
      NegativeIndic := GetNegativeIndic(DataType,Valu);
      If DataType = '$' then
       valu := FormatBarCodeAmount(Valu,NegativeIndic)
      else If DataType = '$$' then
      begin
       valu := JustRight(FormatStandardAmount(Valu,NegativeIndic),13);
       If AllTrim(valu) = '' then valu := JustRight('0',13);
      end;
      If DataType = '%' then  valu := FormatPercent(Valu);
      If (DataType = 'D') or (DataType = 'D/T') then Valu := FormatDateValu(Valu);
      if (FName = 'T2') and (ElmNo=3) then
        barData := barData + LineNo + valu + ' ' //first line with out instance or Delim
      else if (FName = 'T2') and (ElmNo=65) then
        barData := barData + valu + RecordDelim //second line done to "combine the two lines"
      else
        PrepareAnElement(ScheduleId,FName,LineNo,Valu,'');
    end;  {Fname andElmNo}
  end; {end lineno}

 Inc(i);
 PrintLastLoopIndicator := True;
 until i > RsiSpecs.Count-1;
end; {procedure}



procedure TT5013Efle.RsiFrmListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  Offset: Integer;	{ text offset width }
  FName :String[10]; FNo :integer;
  RsiNm : String[14];
begin
  with (Control as TListBox).Canvas do	{ draw on the control canvas, not on the form }
  begin
   FillRect(Rect); {clear the rectangle }
   Offset := 1;	{ provide default offset }
   RsiNm := AllTrim(LeftStr((Control as TListBox).Items[Index],13));

   Font.color := clBlack;
   If RsiHasData(RetNo,RsiNm) then Font.color := clBlue;
   //20090906
   If ((RsiNm='Schedule 546') and (FetchElm(RetNo,'S546',68)='')) then
    Font.color := clBlack;
   If ((RsiNm='Schedule 547') and (FetchElm(RetNo,'S546',68)='')) then
    Font.color := clBlack;
   TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

Function TT5013Efle.RsiHasData(RetNo:Integer;RsiNm:String):Boolean;
Var FName:String[10];FNo:Integer;
begin

 Result := false;

 If (RSINm='Schedule 005') then     //20121027  //20130515
 begin
  result:=ShouldFileS5(RetNo);
  Exit;
 end;


 //20090902
 If (RSINm='Schedule 546') then
 begin
  Result:=False;
  If FetchElm(RetNo,'S546',68)>'' then  Result:=True;
  Exit;
 end;

 Fname := GetFormNameFromRsi(RsiNm,'F');
 FNo := GetFormNo(FName);
 If (FNo =0) or (FName ='') then exit;
 If Ret[RetNo]^.FrmHasData[FNo] then result := true;
end;

Function TT5013Efle.GetNumberOfRsiWithData(RetNo:Integer):Integer;
var
 i:integer;
 RsiForm:String;
begin
 result := 0;
 For i:=0 to RsiFrmList.Items.count-1 do
 begin
   RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i],13));
   If RsiHasData(RetNo,RsiForm) then
   begin
    result := result + 1;
   end;
 end;
end;

procedure TT5013Efle.PrepareData(Sender: TObject);
var
S,RsiForm:String;
LineCommand,FName,ElmString,LineNo:String;
TempList,RsiSpec:TstringList;
i,k,n,j,jj,TotalRsiWithData:Integer;

MaxArrayLengthPos,MaxArrayLength:Integer;
tempAnsiArray:Array of AnsiString;
tempAnsiString:AnsiString;

begin
 Screen.Cursor := crHourGlass;
 OutFileList.Clear;
 RetNo := GetCurrentRetNo;
 RsiFrmList.ItemIndex :=0;
 Inst:=1;
 TotalRsiWithData := 1;
 SetLength(BarDataArray,TotalRsiWithData);
 BarDataArray[TotalRsiWithData - 1] := '';

 For i:=0 to RsiFrmList.Items.count-1 do
 begin
   Inst:=1;     //2008/11/11
   RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i],13));
   If RsiHasData(RetNo,RsiForm) then
   begin
    RsiFrmList.ItemIndex :=i;
    OutFileList.Add('---- '+RsiForm+ ' ----');
    PrepareSingleRSI(RsiForm);

    If IsFormTheIsGIFI(RsiForm)= true then
     begin PrepareMoreGifiIs(RSIForm);Inst:=1;end;

    k:=GetMultipleRSICount(RetNo,RsiForm);
    jj:=2;
    For j:=jj to k do
    begin
        Inst:=j;
        PrepareSingleRSI(RsiForm);
    end;

    // put all data onto one string in first array location (array not really necessary)
    BarDataArray[TotalRsiWithData - 1] := BarDataArray[TotalRsiWithData - 1] + BarData;
    BarData := '';

   end;  //end of schedule has data
 end;   //end for loop

 OutFileList.Add('EOD');
 OutFileList.SaveToFile(AppDir+'\'+'BarData.txt'); //capture generated data
 BarDataArray[high(BarDataArray)] := BarDataArray[high(BarDataArray)] + 'EOD';
end;



procedure TT5013Efle.PrintBarCodePages(BarDataArray:Array of AnsiString);
var
i,j,maxBarDataElements,TotalBarCodeCount:Integer;
SplitBarDataArray:TSplitBarDataArray;
MergedBarDataArray: array of AnsiString;
BarCodeImageArray:Array of TImage;
barData:ansistring;
begin
  Screen.Cursor:=crHourGlass;
  maxBarDataElements := 735;  //20130522  //range error for test2
  TotalBarCodeCount := 0;

  for i := low(BarDataArray) to High(BarDataArray) do
  begin
   setLength(SplitBarDataArray,i + 1);
   barData := BarDataArray[i];
   j := 1;
   while barData > '' do
   begin
    setLength(SplitBarDataArray[i],j);
    SplitBarDataArray[i][j - 1] := leftAnsiStr(barData,maxBarDataElements);
    barData := midAnsiStr(barData,maxBarDataElements + 1,length(barData) - maxBarDataElements);
    inc(j,1);
    inc(TotalBarCodeCount,1);
   end;
  end;

  SetLength(BarCodeImageArray, TotalBarCodeCount);
  CreateBarCode(SplitBarDataArray,BarCodeImageArray);
  PrintBarCode(BarCodeImageArray);
  Screen.Cursor:=crDefault;
end;


function TT5013Efle.IncMinute(const AValue: TDateTime;const ANumberOfMinutes: Int64): TDateTime;
begin
 Result := ((AValue * 1440{MinsPerDay}) + ANumberOfMinutes) / 1440{MinsPerDay};
end;







Procedure TT5013Efle.CheckColumnsRSI125(MaxPerColumn:Integer;Var Cnt:Integer;TempSpecs:TStringList);
begin
 If Cnt >=MaxPerColumn then
 begin
  If Incol =2 then
  begin
   TempSpecs.Add('COLUMN 3     5.45    2.78');
   InCol:=3;
   Cnt:=0;
  end
  else If Incol =1 then
  begin
   TempSpecs.Add('COLUMN 2     3.0     2.78');
   InCol:=2;
   Cnt:=0;
  end;
 end;
end;

Function TT5013Efle.ReformatPhoneNo(S:String):String;
begin
 Result:=ReplaceChar(s,' ','');
 Result:=ReplaceChar(result,'-','');
 Result := AllTrim(Result);
end;


Function TT5013Efle.ReformatSIN(S:String):String;
begin
 Result:=ReplaceChar(s,'-','');
 Result:=AllTrim(ReplaceChar(s,' ',''));
 Result:=AllTrim(Result);
end;

Function TT5013Efle.ReformatPostal(S:String):String;
begin
 Result:=ReplaceChar(s,' ','');
end;


Function TT5013Efle.GetMaxColumns(s:String):Integer;
begin
 Result := MyStrToInt(AllTrim(MidStr(s,14,3)));
end;

Function TT5013Efle.DateForRSIPage5(s:String):String;
Var yyyy,mm,dd:String;
begin
 If FillSignatureDates=True then
 begin
  yyyy := LeftStr(S,4);
  mm:=GetFullMonth(MidStr(s,6,2));
  dd := RightStr(s,2);
  Result := mm+' '+ dd+', '+yyyy;
 end;
end;


Function TT5013Efle.ReformatTrustNo(S:String):String;
begin
 Result:=s;
end;

Function TT5013Efle.ReformatBNForBarCode(bn:String):String;
Var s:String;
begin
 result:=UpperCase(Bn);
 If Length(result) <>15 then exit;
end;


Procedure TT5013Efle.PrepareAddressLoop(RetNo:Integer;FName:String;j:integer;Valu:String;ScheduleId:String;ToElm:Integer;K:Integer;MaxLoopCounter:Integer;LineNo:String);
Var FullAddress:String;Ln:string;
begin
  If InFormsWithSpecialAddress(FName) then
  begin
   FullAddress:=GetSpecialAddressValu(RetNo,FName,j,Valu);  //20081203
   PrepareAnElement(ScheduleId,FName,LineNo,FullAddress,IntToStr(K));
   Exit;
  end;
end;

Function TT5013Efle.GetSkipIndicator(RetNo:Integer;FName:String;LineNo:String):Boolean;
begin
 Result:=False;

 If FName='S6RE' then
 begin
  If (LineNo='200') and (FetchElm(RetNo,'S6RE',1)='') then result := True;
 end;

 If FName='S15' then
 begin
  If (LineNo='500') and (FetchElm(RetNo,'S15',8)='') then result := True;
 end;
end;

Function TT5013Efle.SkipThisOne(RetNo:Integer;FName:String;ElmNo:Integer;valu:String):Boolean;
Var k:Integer;
begin
 result:=False;
 {
 If ExtractNonInstFormName(FName) = 'S15' then
 begin
  k:=9;
  Repeat
   If (ElmNo=k) or (ElmNo=k+1) or (ElmNo=k+2) or (ElmNo=k+3) or (ElmNo=k+4) then
    begin Result:=True;Exit;end;
   Inc(k,10);
  until k>149; //59;
 end;
 }
end;



//______________________________________________________________________________
//WEBSERVICES BEGIN
//------------------------------------------------------------------------------

procedure TT5013Efle.WebServiceEfileBtnClick(Sender: TObject);
Var Flags: OLEVariant; //20150311
begin
 //20160130
 If (FetchElm(RetNo,'T2',74)='')
 and (FetchElm(RetNo,'T2',75)='') then
 Begin
  ShowMessage('You must enter an Efiler Number or WAC number on T2-page 1, top right hand corner');
  exit;
 end;

 //20140706
 If InvalidCharactersList.count>0 then
 begin
 end;



 //20150311  it is not working
// WebBrowser1.Navigate(WideString('http://www.visualtax.com/EfilingT2/RedirectPage.asp'+GetPreparerInfo('')),Flags, Flags, Flags, Flags);


 S88Cnt:=0;  //20141011

 CheckSecurity(Sender);
 If AcceptedSecurity=False then Exit;
 { //20160702
 Application.CreateForm(TEFSECURE,EFSECURE);
 EFSECURE.ShowModal;
 EFSECURE.Free;
 }
 //20130713
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 If DirectoryExists(NetFileDir)=false then
 begin
   ShowMessage('You need to Set up Internet Filing first'
   +Chr(13)+'Click on Fed-EFile | Set Up Internet Filing');
   Exit;
 end;

  If GetEFileConfirmationNo(RetNo) >'' then //If IsEfiled(RetNo) then  //20130530
  begin
   ShowMessage('You cannot Efile again.'+
    Chr(13)+' Return has been already Efiled and accepted by CRA');
   OpenForm(RetNo,GetFormNo('T183CP'),21);     //20130530
   Exit;
  end;
  WebServiceEfile();
end;


Procedure TT5013Efle.parseXmlResponse(rString:ansistring);
var
    sPos,ePos,i : integer;
    s,e,fCode,fString,messageString : String;
    ConfirmFNo : integer;  //form no
    TimeStamp:String;   //20130622
begin
    //server error -------------------------------------------------------------
    s     := '<faultcode>';
    sPos := ansiPos(s,rString);  //j - change pos to ansiPos 20130620
    if sPos > 0 then
    begin
        e     := '</faultcode>';
        sPos  := ansiPos(s,rString) + length(s);
        ePos  := ansiPos(e,rString);
        fCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        s       := '<faultstring>';
        e       := '</faultstring>';
        sPos    := ansiPos(s,rString) + length(s);
        ePos    := ansiPos(e,rString);
        fString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        messageString := 'Error Code: ' + fCode + chr(10) + chr(13) + fString;
        MessageDlg(messageString,mtError,[mbOK],0);
        exit;
    end;

    //file error ---------------------------------------------------------------
    s := '<tgif:ErrorCode>';
    sPos := ansiPos(s,rString);
    if sPos > 0 then
    begin
        e     := '</tgif:ErrorCode>';
        sPos  := ansiPos(s,rString) + length(s);
        ePos  := ansiPos(e,rString);
        fCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        s       := '<tgif:EnglishMessageText xml:lang="en">';
        e       := '</tgif:EnglishMessageText>';
        sPos    := ansiPos(s,rString) + length(s);
        ePos    := ansiPos(e,rString);
        fString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        messageString := 'Error Code: ' + fCode + chr(10) + chr(13) + fString;
        MessageDlg(messageString,mtError,[mbOK],0);
        exit;
    end;

    //success ------------------------------------------------------------------
    s := '<tgif:ConfirmationNumber>';
    sPos := ansiPos(s,rString);
    if sPos > 0 then
    begin
        e     := '</tgif:ConfirmationNumber>';
        sPos  := ansiPos(s,rString) + length(s);
        ePos  := ansiPos(e,rString);
        fCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
        s       := '<tgif:TimestampDateTime>';
        e       := '</tgif:TimestampDateTime>';
        sPos    := ansiPos(s,rString) + length(s);
        ePos    := ansiPos(e,rString);
        fString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

       StoreElm(RetNo,GetFormNo('T183CP'),21,fCode);   //save confirmation number to T183cp

       //complete the EFConfirm form
       ConfirmFNo:=GetFormNo('EFCONFIRM');
       //StoreElm(RetNo,ConfirmFNo,4,fCode);   //done in calc from T183CP  //20130622
       //20130622
       TimeStamp:=LeftStr(fString,10)+'  '+MidStr(Fstring,11,20);
       StoreElm(RetNo,ConfirmFNo,5,TimeStamp);
       //save info to STATUS
       StoreElm(RetNo,GetFormNo('STATUS'),24,fCode);   //save confirmation number //j - correct field id 20130620
       StoreElm(RetNo,GetFormNo('STATUS'),4,'09');     //set return as efile accepted
       StoreElm(RetNo,GetFormNo('STATUS'),28,TimeStamp);   //20130622

       Ret[RetNo]^.PrpStatus := '09';                  //set return as efile accepted

       Calc(RetNo,'EFCONFIRM'); //20130622

       SaveReturn(RetNo,Ret[RetNo]^.SourceDataDir,Ret[RetNo]^.SourceFlName,True,True);            //Save return, true = no prompt
       LockReturn(RetNo);

       messageString := GetNineDigitAccountNumber(RetNo) + ' ' + GetCorpName(RetNo) + chr(10) + chr(13) + chr(10) + chr(13) +
                         'Efile Submitted Successfully '     + chr(10) + chr(13) +
                         'Confirmation Number: ' + fCode    + chr(10) + chr(13) +
                         'Time Stamp: '          + fString    + chr(10) + chr(13) + chr(10) + chr(13) + //j - add time stamp to message 20130620
                         'Return has been saved and locked.';
                         ;

        OpenForm(RetNo,GetFormNo('EFCONFIRM'),21);   //20130530

        showmessage(messageString);

        exit;
    end;
end;

function TT5013Efle.CanEfileValidation:boolean;
begin
 result := false;

 {
 If ValidT2Date(FetchElm(RetNo,'T2',745))=False then
 begin
  ShowMessage('Invalid signature date. Enter as yyyy/mm/dd and press Enter');
  OpenForm(RetNo,GetFormNo('T2'),745);
  BarDataGen.CancelBtnClick(nil);
  Exit;
 end;
 }
 If Ret[RetNo]^.SeriousErrorCount>0 then
 begin
   ShowMessage('Errors (E-items of Audit Wizard) must be corrected before Efiling the return');
   BarDataGen.CancelBtnClick(nil);
   exit;
 end;

 If Ret[RetNo]^.EfileErrorCount>0 then
 begin
   ShowMessage('Errors (F-items of Audit Wizard) must be corrected before Efiling the return');
   BarDataGen.CancelBtnClick(nil);
   exit;
 end;
 {
 If (LicenseLevel = 'T2 Standard') then
 begin
  ShowMessage('Efile is not available in the T2 Standard version');
  Exit;
 end;

 If LicenseLevel = 'T2 Demo' then
 begin
  ShowMessage('EFile not included in the demo version');
  BarDataGen.CancelBtnClick(nil);
  exit;
 end;
 }
 If (OptRec.Prp_Name='') or (OptRec.Prp_Street='') then
 begin
  ShowMessage('Please complete the Preparer info in Configure -> General Options -> Preparer');
  BarDataGen.CancelBtnClick(nil);
  Exit;
 end;

 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 If (NetFileDir='') or (Url='') then
 begin
   ShowMessage('You need to Set up Internet Filing first'
   +Chr(13)+'Click on Fed-EFile | Set Up Internet Filing');
   BarDataGen.CancelBtnClick(nil);
   Exit;
 end;

 //20130530
 If (GetWACNumber(RetNo)='') and (OnlineNo='') then
 begin
  ShowMessage('Please complete the Fed-EFile | Set-up Internet Filing'
  +Chr(13)+'OR enter the WAC number (on page 1 of the T2 jacket)');
  BarDataGen.CancelBtnClick(nil);
  Exit;
 end;

 If IsEFiled(RetNo)=False then
 begin
  //20130525
  ShowMessage('Please indicate that Return is Efiled (on form T2)'
  +Chr(13)+ ' and Print the T183CORP');
  OpenForm(RetNo,GetFormNo('T2'),76);
  BarDataGen.CancelBtnClick(nil);
  Exit;
 end;

 If CanItBeEfiled(RetNo) = False then
 begin
  ShowMessage('You cannot EFile this return'+
    Chr(13)+'See Audit Wizard Efile Diagnostics');
  BarDataGen.CancelBtnClick(nil);
  exit;
 end;

 If IsAuthorizedPreparer=false then exit;
 //--------------------- passed validations

 result := true;

end;

Function TT5013Efle.CreateSoapContent():ansistring;
var
i,k,j,jj:integer;
TotalRsiWithData:Integer;
RsiForm:String;
begin
 Screen.Cursor := crHourGlass;
 OutFileList.Clear;
 RetNo := GetCurrentRetNo;
 RsiFrmList.ItemIndex :=0;
 Inst:=1;
 TotalRsiWithData := 1;
 SetLength(BarDataArray,TotalRsiWithData);
 BarDataArray[TotalRsiWithData - 1] := '';

 For i:=0 to RsiFrmList.Items.count-1 do
 begin
   Inst:=1;     //2008/11/11
   RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i],13));
   If RsiHasData(RetNo,RsiForm) then
   begin
    PrepareSingleRSI(RsiForm);

    If IsFormTheIsGIFI(RsiForm)= true then begin PrepareMoreGifiIs(RSIForm);Inst:=1;end;

    k:=GetMultipleRSICount(RetNo,RsiForm);
    jj:=2;
    For j:=jj to k do
    begin
        Inst:=j;
        PrepareSingleRSI(RsiForm);
    end;
    // put all data onto one string in first array location (array not really necessary)
    BarDataArray[TotalRsiWithData - 1] := BarDataArray[TotalRsiWithData - 1] + BarData;
    //?BarData := '';
   end;  //end of schedule has data
 end;   //end for loop
 BarData:=BarData+'EOD'+RecordDelim;

 result := BarData;
end;

Function TT5013Efle.ReplacePredefinedXMLEntities(info:String):String;
Begin

 info := ReplaceChar(info,'&','&amp;');
 info := ReplaceChar(info, '<' , '&lt;' );
 info := ReplaceChar(info,'"','&quot;');
 info := ReplaceChar(info,'>','&gt;');
 info := ReplaceChar(info,'''','&apos;');
 //info := ReplaceChar(info,'.','');

 result := info;

End;

procedure TT5013Efle.corFileClickLblClick(Sender: TObject);
var
 i:integer;
 F1:TextFile;
 fileNamePath:string;
 CorData:ansistring;
begin
 Efiling:=True;  //20130106
 CorData      := CreateSoapContent();

 fileNamePath := MkEFileName(RetNo);

 AssignFile(F1,fileNamePath);

 Rewrite(F1);
 For i :=1 to length(CorData) do Write(F1,CorData[i]);
 CloseFile(F1);

 showmessage('cor file created: ' + fileNamePath);
end;


procedure TT5013Efle.BitBtn5Click(Sender: TObject);
Var Url:String; h:THandle;
begin
 Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

end.
