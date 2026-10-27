unit T2_2027ARsiFrm;
//revision 2014-07-29

interface


uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,Printers,FileCtrl,ShellApi,
  ExtCtrls,ComObj,ShlObj,
  MsXml2_TLB, vtShape; //20160405 Igor

Const   //in number of characters
  ScheduleIndentation=10;
  ElmIndentation=15;

type
  TARsiFrmT2_2027 = class(TForm)
    PrintBtn: TBitBtn;
    CancelBtn: TBitBtn;
    RsiFrmList: TListBox;
    PrintAllBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    ValidateBtn: TBitBtn;
    FontId: TLabel;
    RunOption: TRadioGroup;
    ListBox2: TListBox;
    PreviewBtn: TBitBtn;
    EfileBtn: TBitBtn;
    testingMode: TCheckBox;
    ShowSubmittedBtn: TBitBtn;
    ThirdPartyIndicatorBox: TCheckBox;
    Label1: TLabel;
    vtShape5: TvtShape;
    Label2: TLabel;
    vtShape1: TvtShape;
    BitBtn4: TBitBtn;
    testResponse: TBitBtn;

    Function IncludeAs3ElmInRsi(FNo:Integer;Elm:Integer):Boolean;  //20170625
    Function ExceedsLoopCnt(k:Integer;MaxLoopCounter:Integer;Fname:String):Boolean;
    Function GetSkipIndicator(RetNo:Integer;FName:String;LineNo:String):Boolean;
    //efile
    Function  MkSubmittedFileName(RetNo:Integer):String;
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure PrepareAlbEfile;
    procedure PrepareSingleEfileSchedule(RsiForm:String);
    procedure PrepareDetailEfileSchedule(RetNo:Integer;RsiForm:String;RsiSpecs:TStringList;Inst:Integer);
    Procedure PrepareEfileElement(ScheduleId,LineNo,OccurSeq:String;Valu:String);{X,Y in inches}

    Function ReplacePredefinedXMLEntities(info:String):String;

    Procedure CreateSoapHeader(Var TempSoapList:TStringList);
    Procedure CreateSoapFooter(Var TempSoapList:TStringList);

    Function GetConfirmation(ResponseXmlString:String): String; //20150701
    Procedure SaveResultCodes(ResponseXmlString:String); //20150701


    Function isReturnAccepted(ResponseXmlString:String):boolean; //20150701

    Function ARSIFormatAmount(FrmNm:String;s: string;How:Integer): string;
    {Function IsMandatory(S:String;FName:String;ElmNo:Integer):Boolean;}
    Function InsertAnotherSpace(Valu:String):String;
    Procedure SplitLongValu(Valu:string;MaxLength:Integer;Var Part1:String;Var Part2:string;Var Part3:string);
    procedure CancelBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RsiFrmListDblClick(Sender: TObject);
    procedure PRINTRsiForm(RetNo:Integer;RsiForm:String;RsiSpecs:TStringList;Inst:integer);
    procedure ValidateBtnClick(Sender: TObject);
    Procedure PrintAnElement(ScheduleId,LineNo,OccurSeq:String;X:Real;Var Y:real;Valu:String;Elm:Integer);{X,Y in inches}//2015052=09
   // Procedure PrintAnElement(ScheduleId,LineNo,OccurSeq:String;X:Real;Var Y:real;Valu:String);{X,Y in inches}
    Function GetLineNo(LineCommand:String):String;
    Procedure PrintHeader(ScheduleId:String);
    Procedure PrintFooter(ScheduleId:String;PageCnt:Integer);
    Function GetLoopIndic(LineCommand:String):Boolean;
    Function GetAddressIndic(LineCommand:String):Boolean;
    Function GetLargeFontIndic(LineCommand:String):Boolean;
    Function GetUnderLineIndic(DataType:String):Boolean;
    procedure DrawBox(BoxRect:TRect; PenWidth: Integer;Shading:Boolean);
    Function ConvertYToPixels(Y:Real):Integer;
    Function ConvertXToPixels(X:Real):Integer;
    Function NextLineY(Y:Real):Real;
    Function GetSkipIndic(LineCommand:String):Boolean;
    Function FormatRSIAmount(Valu:String;NegativeIndic:Boolean):String;
    procedure RsiFrmListClick(Sender: TObject);
    Function formatYesOrNoValu(Valu:String):String;
    Function formatOneOrTwoValu(Valu:String):String;
    Function FormatDateValu(Valu:String):String;
    Function GetMaxLoopCnt(LoopRefName:String):Integer;
    Function GetLoopRefName(s:String):String;
    Function GetActualText(S:String):String;
    Procedure PrintFooterAndHeader(ScheduleId:String);
    Function GetNumbOfEmptyLines(S:String):Integer;
    Function FormatPercent(ScheduleId:String;LineNo:String;Valu:String):String;
    Function GetTextX(s:String):real;
    Function CalcPages(ScheduleId:String):integer;
    Function GetColumnX(S:String):Real;
    Function GetColumnY(S:String):Real;
    Procedure InitColumnPositions;
    procedure ValidateSpecs(RetNo:Integer;RsiForm:String;RsiSpecs:TStringList);
    Function LineNoNumeric(S:string):Boolean;
    Function RoundPages(NumbLines:Integer):Integer;
    Function GetNegativeIndic(DataType:String;Valu:String):Boolean;
    Function GetValueFromForm(RetNo:Integer;FName:String;Elm:Integer;Inst:Integer):String;
    procedure RsiFrmListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    Function RsiHasData(RetNo:Integer;RsiNm:String):Boolean;
    procedure PrintSingleRSI(RsiForm:String);
    procedure PrintAllBtnClick(Sender: TObject);
    procedure PrintErrorList(ErrorList:TstringList);
    procedure RunOptionClick(Sender: TObject);
    procedure PreviewBtnClick(Sender: TObject);
    procedure CountTotPages;
    Function ReformatTelephone(s:String):String;
    procedure EfileBtnClick(Sender: TObject);
    procedure ShowSubmittedBtnClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure testResponseClick(Sender: TObject);
 //   procedure PreProcessForms(RetNo:Integer);
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

var
 // SkipIt:Boolean;  //20140524
  Amended:Boolean;
  ARsiFrmT2_2027: TARsiFrmT2_2027;
  AlbertaEfileDir:String;
  CanEfileAlb:Boolean;
  RunMode :String[1];
  PixPerInX, PixPerInY :Integer;
  VertIncr,LeftMargin,TopMargin,BottomY : real;
  LoopRef : TStringList;
  PageCnt : Integer;
  X,Y: real;
  OccurSeq:String;
  As21OccurSeq1:Integer;  //20150509
  PaddLChars:Integer;
  MaxWidth, charWidth,SpaceWidth:real;
  NumbOfPages:Integer;
  ColumnNo:Integer;
  ColumnX: Array[1..3] of real;
  ColumnY: Array[1..3] of real;
  Inst : Integer;
  ErrorList:TstringList;  {to list errors}
  OutputList : TStringList;  {RSI on a string list, no Print}
  WList :TStringList;  {words of alphanumeric element}
  FontSize:Integer;

  SoapMsg: String; //20150701
  ConfirmationNumber: String;
  Timestamp: String;

implementation

uses
  vtMulti,vtCommon,
  T2_2027,T2_2027Multi,T2_2027Declare,T2_2027TrimStr,T2_2027Common,T2_2027Common2,
  T2_2027CntErr,
  T2_2027main,
  T2_2027CALC,
//ChildWinNew;
  vtTrimStr, vtShared;

{$R *.DFM}

procedure TARsiFrmT2_2027.RsiFrmListDblClick(Sender: TObject);
begin
 PreviewBtnClick(Sender);
 {PrintBtnClick(Sender);}
end;

procedure TARsiFrmT2_2027.FormCreate(Sender: TObject);
Var i:Integer;Templist:TStringList;
begin
 FRetNo := GetCurrentRetNo;
 RunOption.ItemIndex :=0;
 AlbertaEfileDir:=AppDir+'\'+'AlbertaEfile';
 ConfirmationNumber:='';
 TimeStamp:='';
 If SysUtils.DirectoryExists(AlbertaEfileDir) = false then SysUtils.ForceDirectories(AlbertaEfileDir);
 ErrorList := Tstringlist.Create;
 OutputList := Tstringlist.Create;
 WList :=  Tstringlist.Create;
 LeftMargin :=0.50;
 TopMargin  :=0.50;
 BottomY    := 9.85; {10.00;}
 VertIncr   := 1/7; {1/8;}
 PaddLChars := 25;
 MaxWidth   := 1.50;
 CharWidth  := 1.25/15; {15 chars in 1.25 inches}
 SpaceWidth := 0.75/14;  {15 in 0.75 inches}
 NumbOfPages:=0;
 ColumnNo :=1;
 Inst :=1;
 InitColumnPositions;

 ThirdPartyIndicatorBox.checked:=OptRec.Ef_ThirdParty;


// PreprocessForms(RetNo);  //20140523

 TempList:=TstringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'AlbRSI.d');
 For i:=0 to TempList.Count-1 do
  If UpperCase(LeftStr(TempList[i],8)) ='SCHEDULE' then
    RsiFrmList.Items.Add(TempList[i]);
 Templist.Free;

 LoopRef:=TstringList.Create;
 LoopRef.LoadFromFile(AppDir+'\'+'ALoopRef.D');
 RsiFrmList.ItemIndex :=-1;
end;

procedure TARsiFrmT2_2027.ValidateBtnClick(Sender: TObject);
Var
  i,j,K:Integer;
  RsiForm: string;//[13]; //20150701
  TempList,RsiSpec:TStringList;
//  RetNo: Integer; //20160405 Igor
begin
  Screen.Cursor := crHourGlass;
  ErrorList.Clear;
  For k:=0 to RsiFrmList.Items.Count-1 do
  begin
    TempList:= TstringList.Create;
    RsiSpec := TstringList.Create;
    RsiForm := AllTrim(
        LeftStr(RsiFrmList.Items[k],13));
    TempList.LoadFromFile(AppDir+'\'+'AlbRSI.d');
    {Locate form specs}
    i:=0;
    j:=-1;
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
      Break; {Exit;}
    end;
   {get the specs}
    i:=j;   {j=location of specs in AlbRSI.D}
    RsiSpec.Add(TempList[i]);
    i := i+1;
    Repeat
      RsiSpec.Add(TempList[i]);
      Inc(i);
    until (UpperCase(LeftStr(TempList[i],8)) = 'SCHEDULE')
       or (i>TempList.Count-2);  {until new schedule or end of list}

    TempList.Free;
    If RsiSpec.Count =0 then begin RsiSpec.Free;exit;end;
//    RetNo:=GetCurrentRetNo; //20160405 Igor
    ValidateSpecs(RetNo,RsiForm,RsiSpec);
    RsiSpec.Free;
  end;

  Screen.Cursor := crDefault;
  ShowMessage('Completed');
end;

procedure TARsiFrmT2_2027.CancelBtnClick(Sender: TObject);
Var i:Integer;
begin
ErrorList.Free;
LoopRef.Free;
OutputList.Free;
WList.Free;
Close;
end;

procedure TARsiFrmT2_2027.PrintBtnClick(Sender: TObject);
Var
  i,j:Integer;
  RsiForm :string;//[13]; //20150701
begin
 If RsiFrmList.ItemIndex <0 then
 begin
  ShowMessage('Please select a form');
  Exit;
 end;

 OutPutList.Clear;
 ListBox2.Clear;

 If RsiFrmList.ItemIndex <0 then
   exit;
 RsiForm := AllTrim(
   LeftStr(RsiFrmList.Items[RsiFrmList.ItemIndex],13));

 CountTotPages; {calcs NumbOfPages}
 NumbOfPages:=1;  //if single form
 PageCnt:= StrToInt(InputBox('Input Box', 'Enter starting page', '0'));
 PageCnt:=PageCnt-1;
 {PageCnt :=0;}
 RunMode := 'P';
 If not PrintDialog1.Execute then exit;
 PrintSingleRSI(RsiForm);
end;

procedure TARsiFrmT2_2027.PrintSingleRSI(RsiForm:String);
Var i,j:Integer;TempList,RsiSpec:TStringList;
begin
 TempList:=TstringList.Create;
 RsiSpec := TstringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'AlbRSI.d');
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
 Printer.Orientation := poPortrait;   //20160623
 If RunMode='P' then
 begin
   Printer.BeginDoc;
   //20101121
   Printer.Canvas.Font.Name:='Arial';
   //Printer.Canvas.Font.Assign(FontId.Font);
   FontSize:=12; Printer.Canvas.Font.Size :=FontSize;
   PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
   PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
   PrintRsiForm(RetNo,RsiForm,RsiSpec,Inst);
  Printer.EndDoc;
 end
 else
 begin
   PrintRsiForm(RetNo,RsiForm,RsiSpec,Inst);
   For i:=0 to OutputList.Count-1 do
     ListBox2.Items.Add(OutputList[i]);
 end;

 RsiSpec.Free;
 Screen.Cursor := crDefault;
end;



Function TARsiFrmT2_2027.InsertAnotherSpace(Valu:String):String;
Var i:Integer;
begin
 Result := '';
 For i:=1 to Length(Valu) do
 begin
  If Valu[i] > ' ' then
   result := Result+Valu[i]
  else
   result := Result+'  '; {twospaces}
 end;
end;

Procedure TARsiFrmT2_2027.SplitLongValu(Valu:string;MaxLength:Integer;Var Part1:String;Var Part2:string;Var Part3:string);
Var I:integer;WList:TStringList;
begin
 Valu:=InsertAnotherSpace(Valu);
 If Length(Valu) <= MaxLength then
 begin
  Part1:=Valu;
  Part2:='';
  Part3:='';
  exit;
 end;

 WList := TstringList.Create;
 Part1:='';Part2:='';Part3:='';
 ParseWords(Valu,' ',WList);
 For i:=0 to WList.Count-1 do
 begin
  If Length(Part1+Wlist[i]) < MaxLength then
     Part1 := Part1+' '+Wlist[i];
 end;
 Part2 := MidStr(Valu,Length(Part1),MaxLength);
 Part3 := MidStr(Valu,Length(Part1)+Length(Part2),255);

 Part1:=AllTrim(Part1);
 Part2 := AllTrim(Part2);
 Part3:=AllTrim(Part3);

 WList.Free;
end;


Function TARsiFrmT2_2027.GetLineNo(LineCommand:String):String;
Var i:Integer;
begin
 result:='';
 If (UpperCase(LineCommand) = 'BOX') or
    (UpperCase(LineCommand) = 'HEADER') or
    (UpperCase(LineCommand) = 'TEXT') or
    (UpperCase(LineCommand) = 'FOOTER') or
    (UpperCase(LineCommand) = 'EMPTY') or
    (GetSkipIndic(LineCommand) = True)
 then exit;

 For i :=1 to Length(LineCommand) do
  If LineNoNumeric(LineCommand[i]) then result:=result+LineCommand[i];

 If      Length(Result) = 0 then result:=''
 else If Length(result) = 1 then result:='00'+result
 else if Length(result) = 2 then result:='0'+result;

 If Length(result) < 3 then result :='';
end;

Procedure TARsiFrmT2_2027.PrintHeader(ScheduleId:String);
Var BoldIndic,UnderlineIndic :Boolean; Valu :String;
begin
 InitColumnPositions;
 Inc(PageCnt);
 ColumnNo :=1;
 x:= LeftMargin;
 Y:=TopMargin;
 PrintAnElement('','AT1  RETURN  AND  SCHEDULE  INFORMATION','',X,Y,'',0);  //20150509
 //PrintAnElement('','AT1  RETURN  AND  SCHEDULE  INFORMATION','',X,Y,'');

 Y:=NextLineY(Y);
 PrintAnElement('','CAN','',X,Y,GetAlbAccNo(RetNo),0);
 Y:=NextLineY(Y);

 PrintAnElement('','TYE','',X,Y,FormatDateValu(FetchElm(RetNo,'AT1',14)),0);
 Y:=NextLineY(Y);

PrintAnElement('','PAGE','',X,Y,IntToStr(PageCnt)+'  '+'of'
                +'  '+IntToStr(NumbOfPages)
                +Space(2)   //+LeftStr(GetCorpName(RetNo),40)
                +DoubleWordSeparators(LeftStr(FetchElm(RetNo,'AT1',1),40)),0);  //20120506
 Y:=NextLineY(Y);
end;

Function TARsiFrmT2_2027.GetAddressIndic(LineCommand:String):Boolean;
Var i:Integer;
begin
 Result := False;
 For i :=1 to Length(LineCommand) do //20160405 Igor
  If LineCommand[i]= '@' then begin result :=True;exit;end;
end;

Function TARsiFrmT2_2027.GetLoopIndic(LineCommand:String):Boolean;
Var i:Integer;
begin
 Result := False;
 For i :=1 to Length(LineCommand) do //20160405 Igor
  If LineCommand[i]= '*' then begin result :=True;exit;end;
end;

Function TARsiFrmT2_2027.GetTextX(s:String):real;
Var i:Integer;
begin
 result:=Vl(AllTrim(MidStr(s,14,3)));
end;


Function TARsiFrmT2_2027.GetNumbOfEmptyLines(S:String):Integer;
Var i:Integer;
begin
 Result := 0;
 Result := MyStrToInt(AllTrim(MidStr(s,14,2)));
end;

Function TARsiFrmT2_2027.GetColumnX(S:String):Real;
Var i:Integer;
begin
 Result := Vl(AllTrim(MidStr(s,14,5)));
end;

Function TARsiFrmT2_2027.GetColumnY(S:String):Real;
Var i:Integer;
begin
 Result := Vl(AllTrim(MidStr(s,22,4)));
end;


Function TARsiFrmT2_2027.GetActualText(S:String):String;
begin
 Result := MidStr(s,20,255);
end;

Function TARsiFrmT2_2027.GetSkipIndic(LineCommand:String):Boolean;
Var i:Integer;
begin
 Result := False;
 For i :=1 to Length(LineCommand) do //20160405 Igor
  If LineCommand[i]= '^' then begin result :=True;exit;end;
end;


Function TARsiFrmT2_2027.GetLargeFontIndic(LineCommand:String):Boolean;
Var i:Integer;
begin
 Result := False;
 For i :=1 to Length(LineCommand) do //20160405 Igor
  If LineCommand[i]= 'F' then begin result :=True;exit;end;
end;


procedure TARsiFrmT2_2027.DrawBox(BoxRect:TRect; PenWidth: Integer;Shading:Boolean);
begin
  with Printer.Canvas do
  begin
    Pen.Width := PenWidth;
    Brush.Style := bsClear;
    Rectangle(BoxRect.Left,BoxRect.Top,BoxRect.Right,BoxRect.Bottom);
    If Shading then
    begin
     Brush.Color := RGB(239,239,239); {clBtnFace;}
     FillRect(BoxRect);
    end;
  end;
end;


Function TARsiFrmT2_2027.NextLineY(Y:Real):Real;
begin
 Result := Y+2*VertIncr;
end;


Function TARsiFrmT2_2027.ConvertXToPixels(X:Real):Integer;
Begin
 result := Trunc(X *PixPerInX);
end;

Function TARsiFrmT2_2027.ConvertYToPixels(Y:Real):Integer;
Begin
 result := Trunc(Y *PixPerInY);
end;

Function TARsiFrmT2_2027.GetMaxLoopCnt(LoopRefName:String):Integer;
Var i,j,Cnt,FromElm, ToElm,ByIncr:Integer;FName:String;
//max number of rows to be used?
begin
 Result:=-1;
 Cnt:=0;
 If LoopRefName = '' then exit;
 For I:=0 to LoopRef.Count-1 do
 begin
   If LoopRefName = AllTrim(UpperCase(LeftStr(LoopRef[i],10))) then
   begin
    Fname   := UpperCase(AllTrim(MidStr(LoopRef[i],11,10)));
    If GetFormNo(FName) =0 then exit;
    FromElm := MyStrToInt(AllTrim(MidStr(LoopRef[i],21,3)));
    ToElm   := MyStrToInt(AllTrim(MidStr(LoopRef[i],25,3)));
    ByIncr  := MyStrToInt(AllTrim(MidStr(LoopRef[i],29,3)));

    j:=FromElm;
    Repeat
     If GetValueFromForm(RetNo,FName,j,Inst) >'' then inc(Cnt);
     Inc(j,ByIncr);
    until j>ToElm;
    break;
   end;
 end; {loop i}
 If Cnt=0 then cnt:=1;
 result := Cnt;

end;

Function TARsiFrmT2_2027.FormatRSIAmount(Valu:String;NegativeIndic:Boolean):String;
begin
 Valu:=ARSIFormatAmount('',Valu,0);  {no decimals}
 valu:=ReplaceChar(Valu,',' , ''); {replace commas with nil}
 If NegativeIndic then
   result:='**'+ReplaceChar(Valu,'-' , '')
 else
   result := valu;
end;

Function TARsiFrmT2_2027.ARSIFormatAmount(FrmNm:String;s: string;How:Integer): string;
var x:real;
begin
Try
 s := LTrim(s);
 x := Vl(S);

 If FrmNm = 'INVOICE' then//If LeftStr(FrmNm,3) = 'INV' then   //20160417
 begin
  result:=FormatFloat('###,###,###.00',x);
  exit;
 end;

 If How =2 then
 begin
  x := Vl(S);
  result := FormatFloat('###,###,###',x)+'.00'
 end
 else
 begin
  x := Round(Vl(S));
  result := FormatFloat('###,###,###',x);
 end;
except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
end;

end;


procedure TARsiFrmT2_2027.RsiFrmListClick(Sender: TObject);
Var
  i,j:Integer;
  RsiForm :string;//[13]; //20150701
  TempList,RsiSpec:TStringList;
begin
 If RsiFrmList.ItemIndex <0 then exit;
 TempList:=TstringList.Create;
 RsiSpec := TstringList.Create;
 RsiForm := AllTrim(
   LeftStr(RsiFrmList.Items[RsiFrmList.ItemIndex],13));
 TempList.LoadFromFile(AppDir+'\'+'AlbRSI.d');
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

Function TARsiFrmT2_2027.GetUnderLineIndic(DataType:String):Boolean;
begin
  If (DataType = 'AN') or (DataType = 'A') then
       result := False
  else
       Result := True;
end;

Function TARsiFrmT2_2027.FormatYesOrNoValu(Valu:String):String;
begin
  If UpperCase(Valu) = 'X' then result:='1' else result :='2';
end;

Function TARsiFrmT2_2027.FormatOneOrTwoValu(Valu:String):String;
begin
  If UpperCase(Valu) = 'X' then result:='1' else result :='2';
end;


Function TARsiFrmT2_2027.FormatDateValu(Valu:String):String;
begin
  result := ReplaceChar(Valu,'/', '');
end;

Function TARsiFrmT2_2027.FormatPercent(ScheduleId:String;LineNo:String;Valu:String):String;
Var
  x:real;
  Fmt:string;//[15]; //20150701
begin
 valu := AllTrim(valu);
 If Vl(Valu)=1 then begin  result := '1';  exit; end;
 {
 If (ScheduleId = '000') and (LineNo='065') and (Vl(Valu)=1)
 then begin  result := '1';  exit; end;
 }
 x := Vl(valu);
 Fmt := '###.000000';
 If (ScheduleId='006') or (ScheduleId='007') then fmt:= '###.0000';
 result := FormatFloat(Fmt,x);
 If Vl(result)=0 then result :='';
end;


Procedure TARsiFrmT2_2027.PrintFooter(ScheduleId:String;PageCnt:Integer);
begin
 x:=LeftMargin;
 Y:=TopMargin;
 Inc(PageCnt);
end;

Function TARsiFrmT2_2027.GetLoopRefName(s:String):String;
begin
 result := AllTrim(MidStr(S,34,9));
end;

Procedure TARsiFrmT2_2027.PrintFooterAndHeader(ScheduleId:String);
begin
 PrintFooter(ScheduleId,PageCnt);
 If RunMode = 'P' then Printer.NewPage;
 PrintHeader(ScheduleId);
 Y := NextLineY(Y);
end;


Function TARsiFrmT2_2027.LineNoNumeric(S:string):Boolean;
Var i:integer;
begin
 If s ='' then //20150701
 begin
   Result := false;
   exit;
 end
 else
   result := true;

 For i:= 1 to Length(S) do
   If CharInSet(S[i], ['0','1','2','3','4','5','6','7','8','9']) then //20150701
     Result := True
   else
   begin
     Result := False;
     break; //20150701
   end;
end;

Procedure TARsiFrmT2_2027.InitColumnPositions;
 begin
 ColumnX[1] := LeftMargin;
 ColumnX[2] := 3.00;
 ColumnX[3] := 5.50;

 ColumnY[1] := 1.00;
 ColumnY[2] := 1.00;
 ColumnY[3] := 1.00;
 end;

Function TARsiFrmT2_2027.CalcPages(ScheduleId:String):integer;
Var i:Integer;NumbLines:Integer;
begin
end;

Function TARsiFrmT2_2027.RoundPages(NumbLines:Integer):Integer;
begin
 result :=Trunc(NumbLines/30)+1;
end;

Function TARsiFrmT2_2027.GetValueFromForm(RetNo:Integer;FName:String;Elm:Integer;Inst:Integer):String;
Var i,FNo:Integer;j,k:Integer;
begin
  result := FetchElm(RetNo,FName,Elm);
  {reformat valu}


  If LeftStr(FName,4) = 'AS13' then  //Get CCA rate if class 13 remove rate s/b blank //20210615
  begin
    Case elm of 17,33,49,65,81,97,113,129,145,161,177,193,209:
       if FetchElm(RetNo,FName,elm-11)='13' then //if cls-13 the value =blank;
        begin result :='';Exit;End;
    end; //case
  end;


  If FName = 'AT1' then
  begin
    If Elm=1 then result:=LeftStr(FetchElm(RetNo,'AT1',1),70); //20141121
    If Elm = 47 then result := RSIAPPROVALCode; //FetchElm(RetNo,FName,2)+ ' '+ FetchElm(RetNo,FName,12);
    If Elm = 2 then result := LeftStr(FetchElm(RetNo,FName,2)+ ' '+ FetchElm(RetNo,FName,12),70);  //20141121
    //If Elm = 2 then result := FetchElm(RetNo,FName,2)+ ' '+ FetchElm(RetNo,FName,12);

    If Elm = 19 then
    begin
      result := '';
      if UpperCase(FetchElm(RetNo,FName,19)) = 'X' then result :='1'
      else if UpperCase(FetchElm(RetNo,FName,20)) = 'X' then result :='2'
      else if UpperCase(FetchElm(RetNo,FName,21)) = 'X' then result :='3';
      If FetchElm(RetNo,'AT1',17) ='' then result :='';
    end;

    If (Elm=22) and (FetchElm(RetNo,FName,Elm)>'') then
      result :=FetchElm(RetNo,FName,Elm);

    If Elm = 32 then {corpTYpe field 29}
    begin
      result := '';
      if UpperCase(FetchElm(RetNo,FName,32)) = 'X' then result :='1'
      else if UpperCase(FetchElm(RetNo,FName,33)) = 'X' then result :='2'
      else if UpperCase(FetchElm(RetNo,FName,34)) = 'X' then result :='3'
      else if UpperCase(FetchElm(RetNo,FName,35)) = 'X' then result :='4'
      else if UpperCase(FetchElm(RetNo,FName,36)) = 'X' then result :='5';
    end;

    If Elm = 38 then {spec corp status field 30}
    begin
      result := '';
      if UpperCase(FetchElm(RetNo,FName,38)) = 'X'      then result :='1'
      else if UpperCase(FetchElm(RetNo,FName,39)) = 'X' then result :='2'
      else if UpperCase(FetchElm(RetNo,FName,13)) = 'X' then result :='3'
      else if UpperCase(FetchElm(RetNo,FName,15)) = 'X' then result :='4'
      else if UpperCase(FetchElm(RetNo,FName,16)) = 'X' then result :='5'
    end;

    If Elm = 49 then {reason final return field 51}
    begin
      result := '';
      if UpperCase(FetchElm(RetNo,FName,49)) = 'X' then result :='1'
      else if UpperCase(FetchElm(RetNo,FName,50)) = 'X' then result :='2'
      else if UpperCase(FetchElm(RetNo,FName,51)) = 'X' then result :='3'
      else if UpperCase(FetchElm(RetNo,FName,52)) = 'X' then result :='4'
      else if UpperCase(FetchElm(RetNo,FName,53)) = 'X' then result :='5';
    end;

    If Elm = 60 then     //functional currency
    begin
      result := '';
      if UpperCase(FetchElm(RetNo,FName,60)) = 'X' then result :='1'
      else if UpperCase(FetchElm(RetNo,FName,59)) = 'X' then result :='2'
      else if UpperCase(FetchElm(RetNo,FName,56)) = 'X' then result :='3'
      else if UpperCase(FetchElm(RetNo,FName,61)) = 'X' then result :='4';
    end;
  end;

  If FName = 'AT1' then    {add area to Telephone}
  begin
    If Elm = 128 then
      result :=FetchElm(RetNo,FName,128)+FetchElm(RetNo,FName,129);
  end;

  //20170625
  If FName = 'AS3' then //20170625 //if no values on the row, do not generate the elm on the rsi
  begin
    FNo:=GetFormNo('AS3');
    if IncludeAs3ElmInRsi(FNo,Elm)=False then
      result:=''
    Else
     Result:=FetchElmFno(Retno,Fno,elm);
  end;

  If FName = 'AS10' then    {add area to Telephone}
  begin
    If Elm = 34 then  result :=ReformatTelephone(FetchElm(RetNo,FName,34));
   // If Elm = 36 then  result :=ReformatTelephone(FetchElm(RetNo,FName,36)); //20221119
    If (Elm = 10)
    and (Vl(FetchElm(RetNo,FName,elm+1))
    +Vl(FetchElm(RetNo,FName,Elm+2))
    +Vl(FetchElm(RetNo,FName,Elm+3))
    +Vl(FetchElm(RetNo,FName,Elm+4))=0)  //cap loss  //20151118
     then  result :='';  //no date if no c/b
    If (Elm = 15)
    and (Vl(FetchElm(RetNo,FName,elm+1))
    +Vl(FetchElm(RetNo,FName,Elm+2))
    +Vl(FetchElm(RetNo,FName,Elm+3))
    +Vl(FetchElm(RetNo,FName,Elm+4))=0)  //cap loss  //20151118
     then  result :='';  //no date if no c/b

   If (Elm = 20)
    and (Vl(FetchElm(RetNo,FName,elm+1))
    +Vl(FetchElm(RetNo,FName,Elm+2))
    +Vl(FetchElm(RetNo,FName,Elm+3))
    +Vl(FetchElm(RetNo,FName,Elm+4))=0)  //cap loss  //20151118
     then  result :='';  //no date if no c/b
  end;


  If FName = 'AS12' then {if same with fed then skip}
  begin
    i:=5;
    Repeat
    If (i = Elm)
    and (Vl(FetchElm(RetNo,FName,Elm)) = Vl(FetchElm(RetNo,FName,Elm-1)))
    then result :='';
    Inc(i,2);
   until i>39;
   If (Elm=37) then result :=FetchElm(RetNo,FName,Elm);
  end;

  If FName = 'AS12' then
  begin
    If (Elm =115) or (Elm=123) or (Elm=124) then
    begin
     If UpperCase(FetchElm(RetNo,FName,121)) = 'X' then result :='';
    end;

    If (Elm =127) or (Elm=128) or (Elm=129) then
    begin
     If UpperCase(FetchElm(RetNo,FName,126)) = 'X' then result :='';
    end;
  end;


  If FName = 'AS20' then //20140524 //if no values on the row, do not generate the elm on the rsi
  begin
   Case Elm of
    27,33,39,45,51,57:
      If vl(FetchElm(RetNo,FName,Elm+1))+vl(FetchElm(RetNo,FName,Elm+2))
       +vl(FetchElm(RetNo,FName,Elm+3))+vl(FetchElm(RetNo,FName,Elm+4))
       +vl(FetchElm(RetNo,FName,Elm+5))=0 then begin result :='';Exit;End;
   end; //case
  end;

  If FName = 'AS21' then //20140524 //if no values on the row, do not generate the elm on the rsi
  begin
   (*  20210616
   If (Elm =170) then
   begin
     If vl(FetchElm(RetNo,FName,173))+vl(FetchElm(RetNo,FName,174))=0 then result :='';
   end;
   If (Elm =171) then
   begin
     If vl(FetchElm(RetNo,FName,173))+vl(FetchElm(RetNo,FName,174))=0 then result :='';
   end;
  *)
   Case Elm of
    178,186,194,202,210,218,226,234,242,250,258,266,274,282,290,298,306,314,322,330:
       If vl(FetchElm(RetNo,FName,Elm+2))+vl(FetchElm(RetNo,FName,Elm+4))=0 then begin result :='';Exit;End;
    end; //case

   Case Elm of
    179,187,195,203,211,219,227,235,243,251,259,267,275,283,291,299,307,315,323,331:
       If vl(FetchElm(RetNo,FName,Elm+1))+vl(FetchElm(RetNo,FName,Elm+3))=0 then begin result :='';Exit;End;
    end; //case

   Case Elm of
    346,351,356,361,366,371,376,381,386,391,396,401,406,411,416,421,426,431,436,441,446:
       If vl(FetchElm(RetNo,FName,Elm+2))+vl(FetchElm(RetNo,FName,Elm+3))+vl(FetchElm(RetNo,FName,Elm+4))=0 then begin result :='';Exit;End;
    end; //case

  end;

end;


Function TARsiFrmT2_2027.GetNegativeIndic(DataType:String;Valu:String):Boolean;
begin
 Result := False;
 If (DataType = '$') and (Vl(AllTrim(Valu)) <0) then result := True;
end;


procedure TARsiFrmT2_2027.ValidateSpecs(RetNo:Integer;RsiForm:String;RsiSpecs:TStringList);
Var
  i,j,k,FNo,ElmNo,FromElm,ToElm,ByIncr,
  NumbOfEmptyLines: integer;
  LineCommand,s:String;
  FName:String;//[10]; //20150701
  ElmString:String;//[6]; //20150701
  Mandatory:String[1];
  DataType:String;//[4]; //20150701
  LineNo:String;//[5]; //20150701
  DataLengthString:String;//[5]; //20150701
  LineValu,valu:String;
  BoldIndic,UnderlineIndic:Boolean;
  AddressIndic, LoopIndic, LargeFontIndic:Boolean;
  ScheduleId :String;//[10]; //20150701
  BoxRect :TRect;
  LeftOfBox,TopOfBox,RightOfBox,BottomOfBox:real;
  BoxShading:Boolean;
  LoopRefName  : String;//[12]; //20150701
  MaxLoopCounter:Integer;

begin
 If RsiSpecs.Count <=0 then exit;
 S:= RsiSpecs[0];
 ScheduleId := AllTrim(MidStr(s,10,5));
 PageCnt :=0;

 ColumnNo :=1;
 X := LeftMargin;
 y := 1.00; {default after header if column 1 mising};

 {BODY OF RSI FORM}
 If RsiSpecs.count <2 then exit;

 i:=1;
 Repeat
  S            := RsiSpecs[i];
  LineCommand  := AllTrim(MidStr(S,1,10));
  FName        := AllTrim(MidStr(S,14,8));
  ElmString    := Alltrim(MidStr(s,22,4));
  ElmNo        := MyStrToInt(AllTrim(ElmString));
  DataType     := AllTrim(MidStr(S,59,5));
  LineNo       := GetLineNo(LineCommand);
  LoopIndic    := GetLoopIndic(LineCommand);
  AddressIndic := GetAddressIndic(LineCommand);
  LoopRefName  := GetLoopRefName(S);

  {validate}
  If (LoopIndic =true) and (GetMaxLoopCnt(LoopRefName) = -1) then
  begin
    {ShowMessage('Loop incorrect in: '+s);}
    ErrorList.Add('Loop incorrect in: '+s);
  end;

  If (LeftStr(LineCommand,8) = 'COLUMN 1')
  or (LeftStr(LineCommand,8) = 'COLUMN 2')
  or (LeftStr(LineCommand,8) = 'COLUMN 3') then
  begin
   If (GetColumnX(S) = 0) or (GetColumnY(S) = 0) then
   begin
     {ShowMessage('Column position incorrect in Schedule: '+ScheduleId);}
     ErrorList.Add('Column position incorrect in Schedule: '+ScheduleId);
   end;
  end;

  If LineNo >'' then
  begin
   If (DataType = '$')
   or (DataType = 'AN')
   or (DataType = 'A')
   or (DataType = 'N')
   or (DataType = 'D')
   or (DataType = 'D/T')
   or (DataType = 'Y/N')
   or (DataType = '1/2')
   or (DataType = '%') then
   {ok}
   else
    begin
    {ShowMessage('Datatype incorrect in '+s);}
    ErrorList.Add('Datatype incorrect in: '+s);
    end;
  end;
  Inc(i);
 until i > RsiSpecs.Count-1;

 PrintErrorList(ErrorList);
 ErrorList.Clear;
end;

procedure TARsiFrmT2_2027.PrintErrorList(ErrorList:TstringList);
Var
  FileNm:String;
  Hdr1,Hdr2,Hdr3:String;//[80]; //20150701
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

procedure TARsiFrmT2_2027.PrintRsiForm(RetNo:Integer;RsiForm:String;RsiSpecs:TStringList;Inst:Integer);
Var i,j,jj,k,FNo,ElmNo,FromElm,ToElm,ByIncr,
    NumbOfEmptyLines:integer;
    LineCommand,s:String;
    FName:String;//[10]; //20150701
    ElmString:String;//[6]; //20150701
    Mandatory:String;//[1]; //20150701
    DataType:String;//[4];  //20150701
    LineNo:String;//[5];
    DataLengthString:String;//[5];
    LineValu,valu:String;
    BoldIndic,UnderlineIndic,NegativeIndic:Boolean;
    AddressIndic, LoopIndic, LargeFontIndic:Boolean;
    ScheduleId :String;//[10]; //20150701
    BoxRect :TRect;
    LeftOfBox,TopOfBox,RightOfBox,BottomOfBox:real;
    BoxShading:Boolean;
    LoopRefName  : String;//[12]; //20150701
    MaxLoopCounter:Integer;
    ExceedsCnt:Boolean;

    OccurSeqCount:Integer;
begin
 {ShowMessage(RsiForm);exit;}
 If RsiSpecs.Count <=0 then exit;
 S:= RsiSpecs[0];
 ScheduleId := AllTrim(MidStr(s,10,4));
 PrintHeader(ScheduleId);
 ColumnNo :=1;
 X := LeftMargin;
 {y := TopMargin;} {1.00;} {default after header if column 1 mising};
 {BODY OF RSI FORM}
 If RsiSpecs.count <2 then exit;

 i:=1;
 Repeat
  S            := RsiSpecs[i];
  {ShowMessage(S);}
  LineCommand  := AllTrim(MidStr(S,1,10));
  FName        := AllTrim(MidStr(S,14,8));
  ElmString    := Alltrim(MidStr(s,22,3));
  DataType     := AllTrim(MidStr(S,59,5));
  Mandatory    := Alltrim(MidStr(s,73,1));
  ElmNo        := MyStrToInt(AllTrim(ElmString));
  LineNo       := GetLineNo(LineCommand);
  LoopIndic    := GetLoopIndic(LineCommand);
  AddressIndic := GetAddressIndic(LineCommand);
  LoopRefName  := GetLoopRefName(S);

  {validate}
  If (LoopIndic =true) and (GetMaxLoopCnt(LoopRefName) = -1) then
  begin
    ShowMessage('Loop incorrect in: '+s);
    exit;
  end;

  //OccurSeqCount := 1; //20140621

  ExceedsCnt:=False;
  If LoopIndic then   {Loop}
   begin
     {data loop}
    // SkipIt:=GetSkipIndicator(RetNo,FName,LineNo); //20140524
     FromElm := MyStrToInt(AllTrim(MidStr(S,22,3)));
     ToElm   := MyStrToInt(AllTrim(MidStr(S,26,3)));
     ByIncr  := MyStrToInt(AllTrim(MidStr(S,30,3)));
     LoopRefName := AllTrim(MidStr(S,34,8));
     MaxLoopCounter := GetMaxLoopCnt(LoopRefName);
     jj:=0;      //20150511
     j:=FromElm;K:=1;
     Repeat
      FNo := GetFormNo(FName);

      //20150910
      If ScheduleId='020' then Begin If (j=27) or (j=28) or (j=29) or (j=30) or (j=31) or (j=32) then jj:=71;end;  //last invisible column of AS21 which shows seq
      If ScheduleId='021' then
      Begin
       If (j=178) or (j=179) or (j=180) or (j=182) or (j=184) or (j=185) then jj:=471;
       If (j=346) or (j=347) or (j=348) or (j=349) or (j=350) then jj:=491;  //20150520
      end;  //last invisible column of AS21 which shows seq



      If (FNo =0) or (FromElm =0) or (ToElm =0) or (ByIncr=0) then
        valu := ''
      else
        Valu := GetValueFromForm(RetNo,FName,j,Inst);
      If ((DataType = 'AN') or (DataType = 'A')) and (Valu >'') then
        Valu := DoubleWordSeparators(Valu);

      If FName = 'AS1' then
      begin
       Case j of
         106,109,112,115,118,121,124,127,130,133,136,139:
         if AllTrim(FetchElmFNo(RetNo,FNo,j-2)) >'' then
            Mandatory:='M';
       end;
      end;

      If FName = 'AS12_2' then //???
      begin
       If ElmNo=15 then
         If FetchElmFNo(RetNo,FNo,20) >'' then  Mandatory:='M';
      end;

      If (Valu ='') and (Mandatory = 'M') then
      begin
       If DataType='$' then valu := '0';
      end;

     // if RsiForm='AS29' then ShowMessage('AS29');      //20211028

      If DataType = 'Y/N' then Valu := FormatYesOrNoValu(Valu);
      If DataType = '1/2' then Valu := FormatOneOrTwoValu(Valu);
      If DataType = 'N' then  valu := RemoveNonNumericChars(Valu);
      If DataType = '%' then valu := FormatPercent(ScheduleId,LineNo,Valu);
      If (DataType = 'D') or (DataType = 'D/T') then Valu := FormatDateValu(Valu);
      NegativeIndic:= GetNegativeIndic(DataType,Valu);
      If DataType = '$' then  valu := FormatRSIAmount(Valu,NegativeIndic);
      If (Valu ='') and (Mandatory = 'M') then
      begin
       If DataType='$' then valu := '0';
      end;

      OccurSeq:=PaddZero(IntToStr(k),3); //20140621 moved so to only update OccurSeq when there is a value

      If ScheduleId='020' then //20150509  //AS20 special
      begin
       If (j>=27) and (j<=62) then
        OccurSeq:=Paddzero(FetchElmFNo(RetNo,FNo,jj),3);  //jj last invisible column index
      end;
      If ScheduleId='021' then //20150509  As21  special
      begin
       If (j>=170) and (j<=177) then OccurSeq:='000';  //first line current year
       If (j>=178) and (j<=337) then OccurSeq:=Paddzero(FetchElmFNo(RetNo,FNo,jj),3);  //jj last invisible column index
       If (j>=346) and (j<=449) then OccurSeq:=Paddzero(FetchElmFNo(RetNo,FNo,jj),3);  //jj last invisible column index  //20150520
      end;


      Valu:=AllTrim(Valu);
      If (Length(Valu) >0) or (Mandatory = 'M') then
      begin
       Y:=NextLineY(Y);
       If Y>BottomY then PrintFooterAndHeader(ScheduleId);

       //20140621 only update OccurSeq when there is a value
       //OccurSeq:=PaddZero(IntToStr(OccurSeqCount),3);
       //Inc(OccurSeqCount,1);

       PrintAnElement(ScheduleId,LineNo,OccurSeq,X,Y,Valu,j);  {Row}  //j is the Elm  //20150509
       //PrintAnElement(ScheduleId,LineNo,OccurSeq,X,Y,Valu);  {Row}
      end;
      Inc(J,ByIncr);
      Inc(jj,1);  //20150510
      Inc(k,1);
      ExceedsCnt:=ExceedsLoopCnt(k,MaxLoopCounter,Fname);
     until  (j>ToElm) or (ExceedsCnt);  // or (k>MaxLoopCounter);  20140524
  end

  {lines and data}
  else If LineNo > '' then   {Line Number}
   begin
    {constant}
    If LeftStr(FName,1) = '=' then {Constants}
      begin
       Y:=NextLineY(Y);
       If Y>BottomY then PrintFooterAndHeader(ScheduleId);
       PrintAnElement('','','',X,Y,MidStr(S,15,40),0); //PrintAnElement('','','',X,Y,MidStr(S,15,40))
      end
     {Line valu}
    else If (FName >'') and (ElmNo >0) then
    begin
      FNo := GetFormNo(FName);
      If ElmNo >0 then
      begin
       If ElmNo=999 then valu :='' else Valu := GetValueFromForm(RetNo,FName,ElmNo,Inst);
      end
      else
       Valu := '';
      If ((DataType = 'AN') or (DataType = 'A')) and (Valu >'') then
        Valu := DoubleWordSeparators(Valu);
      If DataType = 'Y/N' then Valu := FormatYesOrNoValu(Valu);
      If DataType = '1/2' then Valu := FormatOneOrTwoValu(Valu);
      If DataType = 'N' then  valu := RemoveNonNumericChars(Valu);
      If DataType = '%' then  valu := FormatPercent(ScheduleId,LineNo,Valu);
      If (DataType = 'D') or (DataType = 'D/T') then Valu := FormatDateValu(Valu);
      NegativeIndic:= GetNegativeIndic(DataType,Valu);
      If DataType = '$' then valu := FormatRSIAmount(Valu,NegativeIndic);
      Valu:=AllTrim(Valu);

      If (FName = 'AT1') and (ElmNo=1) then   //20120525
      begin
       If Length(FetchElm(RetNo,FName,ElmNo)) >60  then  //corp name)
       BottomY:=BottomY-2*VertIncr;
      end;

      If (FName = 'AS21') and (ElmNo=22) then
      begin
       If (Vl(FetchElm(RetNo,'AS21',14)) <> 0)
       or (Vl(FetchElm(RetNo,'AS21',24)) <> 0)
       then Mandatory := 'M';
      end;

      If FName = 'AS12_2' then //???
      begin
       If ElmNo=15 then
         If FetchElmFNo(RetNo,FNo,20) >'' then  Mandatory:='M';
      end;
      If (Valu ='') and (Mandatory = 'M') then
      begin
       If DataType='$' then valu := '0';
      end;
      OccurSeq:='001';
      If (Length(Valu) >0) or (Mandatory = 'M') then
      begin
        Y:=NextLineY(Y);
        If Y>BottomY then PrintFooterAndHeader(ScheduleId);
        PrintAnElement(ScheduleId,LineNo,OccurSeq,X,Y,Valu,0);
      end;
    end;  {Fname andElmNo}
  end; {end lineno}
 Inc(i);
 until i > RsiSpecs.Count-1;
 If RunMode = 'D' then NumbOfPages := PageCnt;
end; {procedure}

Function TARsiFrmT2_2027.ExceedsLoopCnt(k:Integer;MaxLoopCounter:Integer;Fname:String):Boolean;
Begin
 Result:=False;
 If k>MaxLoopCounter then result:=true;
 If (Fname='AS20') or (Fname='AS21') then result:=false;  //means do not test it at all. I do not know why
end;

procedure TARsiFrmT2_2027.RsiFrmListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  Offset: Integer;	{ text offset width }
  //FName :String[10]; FNo :integer;
  RsiNm : String;//[14]; //20150701
begin
  with (Control as TListBox).Canvas do	{ draw on the control canvas, not on the form }
  begin
   FillRect(Rect); {clear the rectangle }
   Offset := 1;	{ provide default offset }
   RsiNm := AllTrim(LeftStr((Control as TListBox).Items[Index],13));
   Font.color := clBlack;
   If RsiHasData(RetNo,RsiNm) then Font.color := clBlue; //WHAT can GO to EFILE
   TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

Function TARsiFrmT2_2027.RsiHasData(RetNo:Integer;RsiNm:String):Boolean;
Var
  FName:String;//[10]; //20150701
  FNo:Integer;
begin
 Result := false;
 Fname := GetAlbertaFormNameFromRsi(RsiNm);   //DEFINES what has data for EFILING
 FNo := GetFormNo(FName);
 If (FNo =0) or (FName ='') then exit;
 If Ret[RetNo].FrmHasData[FNo] then result := true;

If RsiNm = 'Schedule 001' then
 begin
  If (Vl(FetchElm(RetNo,'AT1',112)) >0)
    then Result := True else Result := False;
 end;

If RsiNm = 'Schedule 002' then
 begin
  If (Vl(FetchElm(RetNo,'AT1',109)) >0)
  and (Vl(FetchElm(RetNo,'AT1',109)) <1)
    then Result := True else Result := False;
 end;

 If RsiNm = 'Schedule OS5' then //old S5
 begin
  If Ret[RetNo].FrmHasData[GetFormNo('AS5')]
    then Result := True else Result := False;
 end;

 If RsiNm = 'Schedule 005' then
 begin
  If Ret[RetNo].FrmHasData[GetFormNo('AS5')]
    then Result := True else Result := False;
 end;

 {figure out sch 11 to 21}

 If RsiNm = 'Schedule 011' then
 begin
  If (Vl(FetchElm(RetNo,'AS11',14)) >0) then
    Result := True else Result := False;
 end;

 If RsiNm = 'Schedule 012' then
 begin
  If (UpperCase(FetchElm(RetNo,'AT1',104)) = 'X')
  or (UpperCase(FetchElm(RetNo,'AT1',105)) = 'X')
  then Result := True else Result := False;
 end;

 If RsiNm = 'Schedule 013' then
 begin
  If AlbDiffCCA(RetNo) then  Result := True else Result := False;
 end;

 If RsiNm = 'Schedule 014' then
 begin
  If AlbDiffCEC(RetNo) then  Result := True else Result := False;
 // If Result=True then CanEfileAlb:=False;
 end;

 If RsiNm = 'Schedule 015' then
 begin
  If AlbDiffResDed(RetNo) then  Result := True else Result := False;
 end;

 If RsiNm = 'Schedule 016' then
 begin
  If AlbDiffSRD(RetNo) then  Result := True else Result := False;
 end;

 If RsiNm = 'Schedule 017' then
 begin
  If AlbDiffReserves(RetNo) then  Result := True else Result := False;
 end;

 If RsiNm = 'Schedule 018' then
 begin
  If AlbDiffCapDisp(RetNo) then  Result := True else Result := False;
 end;

 If RsiNm = 'Schedule 020' then
 begin
   If Ret[RetNo].FrmHasData[GetFormNo('AS20')] then
     result :=True
   else
     result:=false;
   If AlbDiffDon(RetNo) =False then  Result := False; {test case 4}
 end;

 If RsiNm = 'Schedule 021' then
 begin
  Result := False;
  If AlbDiffLoss(RetNo) then Result := True;
  //20110621
  If (Vl(FetchElm(RetNo,'AS21',12)) <> Vl(FetchElm(RetNo,'S4',14))) //current year loss
  or (Vl(FetchElm(RetNo,'AS21',20)) <> Vl(FetchElm(RetNo,'S4',17))) //open balance
  then result := True;
 end;

 //20210712
 If RsiNm = 'Schedule 029' then
 Begin
  If Ret[RetNo].FrmHasData[GetFormNo('AS29')] then
     result :=True
   else
     result:=false;

 end;


 if RsiNm = 'Schedule 09L' then
 Begin
   If Ret[RetNo].FrmHasData[GetFormNo('AS9L')] then
     result :=True
   else
     result:=false;
 end;

 if RsiNm = 'Schedule 29L' then
 Begin
   If Ret[RetNo].FrmHasData[GetFormNo('AS29L')] then
     result :=True
   else
     result:=false;
 end;

end;

procedure TARsiFrmT2_2027.CountTotPages;
Var
  i:integer;
  RsiForm:String;//[13]; //20150701
begin
 OutPutList.Clear;
 ListBox2.Clear;
 {countPages}
 PageCnt :=0;
 RunMode:='D';
 For i:=0 to RsiFrmList.Items.count-1 do
 begin
   Inst :=1;
   RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i],13));
   If RsiHasData(RetNo,RsiForm) then
       PrintSingleRSI(RsiForm);
 end;

end;

procedure TARsiFrmT2_2027.PrintAllBtnClick(Sender: TObject);
Var
  i:integer;
  RsiForm:String;//[13]; //20150701
begin
 (*
  //20181126
  if MessageDlg(
     'Alberta has not completed program Certification yet.'
     + Chr(13)+' Proceed any way?',
     mtWarning, [mbNo, mbYes], 0) = mrYes then
     //ok
     Else
     Exit;
 *)
 {If BeyondMaxYearEnd(RetNo) then exit;}
 OutPutList.Clear;
 ListBox2.Clear;

 {countPages}
 PageCnt :=0;
 RunMode:='D';
 For i:=0 to RsiFrmList.Items.count-1 do
 begin
   Inst :=1;
   RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i],13));
   If RsiHasData(RetNo,RsiForm) then
   begin
    RsiFrmList.ItemIndex :=i;
    PrintSingleRSI(RsiForm);
   end;
 end;

 //number of pages incorrect on print out header
 If GetCorpBusNo(RetNo)='599996790RC0001' then  //'599996790RC0001'   //20150524
   NumbOfPages:=NumbOfPages;   //20131123 Temporary for Case 9
 {
 If GetCorpBusNo(RetNo)='599996790RC0001' then
   NumbOfPages:=NumbOfPages+1;   //20131123 Temporary for Case 9
   }
 //If GetCorpBusNo(RetNo)='599997392RC0001' then
 //  NumbOfPages:=NumbOfPages+1;   //20140623 Temporary for Case 10


 PageCnt :=0;
 RunMode := 'P';
 If RunMode = 'P' then
 begin
  If not PrintDialog1.Execute then exit;
 end;


 (* 20210714 put it back?
 If Ret[RetNo].FrmHasData[GetFormNo('AS9L')] then
 begin
   If PrintDialog1.Execute then
   begin
     MainFormT2.StartPrintForm(Retno,'AS9L',99);
     if Printer.Printing then //20160905 Igor
       Printer.EndDoc;        //20160905 Igor
   end;
 end;
 *)
 For i:=0 to RsiFrmList.Items.count-1 do
 begin
   Inst :=1;
   RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i],13));
   If RsiHasData(RetNo,RsiForm) then PrintSingleRSI(RsiForm);
 end;

 (* 20210714   put it back?
 If Ret[RetNo].FrmHasData[GetFormNo('ACAPD')] then
 begin
 ShowMessage('Details of Cap. Dispositions should be filed with the RSI');
 If PrintDialog1.Execute then
 begin
     MainFormT2.StartPrintForm(Retno,'ACAPD',99);
     if Printer.Printing then //20160905 Igor
       Printer.EndDoc;        //20160905 Igor
 end;
 end;
 *)

 If AlbDiffResourceData(RetNo) = True then
 begin
  ShowMessage('The Alberta Resource schedule 51 should be filed with the RSI');
  If PrintDialog1.Execute then
  begin
    MainFormT2.StartPrintForm(Retno,'AS51',1); //pg1
    if Printer.Printing then //20160905 Igor
      Printer.EndDoc;        //20160905 Igor
  end;
 end;


 ShowMessage('Done');
end;

procedure TARsiFrmT2_2027.RunOptionClick(Sender: TObject);
begin
 If RunOption.ItemIndex =0 then RunMode :='P' else RunMode := 'D';
 If RunMode = 'D' then
 begin
  ListBox2.Top := RsiFrmList.Top;
  ListBox2.Left := RsiFrmList.Left;
  ListBox2.Width := RsiFrmList.Width;
  ListBox2.Height := RsiFrmList.Height;
  ListBox2.Visible := True;
 end
 else
 begin
 { ListBox2.Visible := false;}
  RsiFrmList.Visible := True;
 end;
end;



procedure TARsiFrmT2_2027.PreviewBtnClick(Sender: TObject);
Var
  i,j:Integer;
  RsiForm :string;//[13]; //20150701
begin
 If RsiFrmList.ItemIndex <0 then
 begin
  ShowMessage('Please select a form');
  Exit;
 end;
 OutPutList.Clear;
 ListBox2.Clear;

 ListBox2.Visible := True;

 If RsiFrmList.ItemIndex <0 then exit;
 RsiForm := AllTrim(
   LeftStr(RsiFrmList.Items[RsiFrmList.ItemIndex],13));

 PageCnt :=0;
 {count Pages}
 Inst :=1;
 RunMode :='D';
 PrintSingleRSI(RsiForm);
end;


Function TARsiFrmT2_2027.ReformatTelephone(s:String):String;
begin
 If s='' then begin Result:='';exit;end;
 Result:=RemoveChar(s,'(');
 Result:=RemoveChar(Result,')');
 Result:=RemoveChar(Result,'-');
 Result:=RemoveChar(Result,' ');
end;

Procedure TARsiFrmT2_2027.PrintAnElement(ScheduleId,LineNo,OccurSeq:String;X:Real;Var Y:real;Valu:String;Elm:Integer);{X,Y in inches} //elm 20150509
//Procedure TARsiFrmT2_2027.PrintAnElement(ScheduleId,LineNo,OccurSeq:String;X:Real;Var Y:real;Valu:String);{X,Y in inches}
Const MaxLength=70;
Var
  XPos, YPos:Integer;
  Hdc : Thandle;
  NullString : Array [0..150] of Char;
  s,Part1,Part2,Part3: string;
begin
 // If SkipIt=true then Exit;  //20140524
  if (ScheduleId='013') and (valu='') then exit; //20171130

  If ScheduleId='OS5' then ScheduleId:='005';
  Part1:='';
  Part2:='';
  Part3:='';
  SplitLongValu(Valu,MaxLength,Part1,Part2,Part3);
  Part1 :='##'+ScheduleId+LineNo+OccurSeq+Space(5)+Part1;

  If RunMode = 'P' then
  begin
   Printer.Canvas.Font.Assign(FontId.Font);  //20090608
   Printer.Canvas.Font.Size := Fontsize;
   Printer.Canvas.Pen.Color := clBlack;
   XPos := ConvertXToPixels(X);
   YPos := ConvertYToPixels(Y);
   hdc := 0;
   SelectObject(hdc,Printer.Canvas.Font.handle);
   SetBkMode(hdc,TRANSPARENT);
   hdc := Printer.Canvas.Handle;
   TextOut(hdc,XPos,YPos,StrPCopy(NullString,Part1),LENGTH(Part1));
   If Part2>'' then
   begin
    XPos := ConvertXToPixels(X);
    Y:=NextLineY(Y);
    YPos := ConvertYToPixels(Y);
    TextOut(hdc,XPos,YPos,StrPCopy(NullString,Part2),LENGTH(Part2));
   end;
   If Part3>'' then
   begin
    XPos := ConvertXToPixels(X);
    Y:=NextLineY(Y);
    YPos := ConvertYToPixels(Y);
    TextOut(hdc,XPos,YPos,StrPCopy(NullString,Part3),LENGTH(Part3));
   end;
 end
 else
 begin
  //if ScheduleId='013' then ShowMessage('S13 starts');
  OutputList.Add(Part1);
  If Part2>'' then OutputList.Add(Part2);
  If Part3>'' then OutputList.Add(Part3);
 end;
end;

procedure TARsiFrmT2_2027.EfileBtnClick(Sender: TObject);
var
 h:THandle;
 sUrl:string;
 WString:{Ansi}String;  //wide string //20150701
 objHttp:ixmlHttpRequest;
 alist:TStringlist;

 AMsgDialog: TForm;
 ACheckBox: TCheckBox;
 declarationText:string; //20150701
 ResponseFileNm:String;
begin
 {
 ShowMessage('Alberta Netfile is not released yet. Waiting review completion by the Alberta government'); //20191115
 If UpperCase(InputBox('Input Box', Enter Password', '')) <> 'N/A' then exit; //20181126
 }

 //ShowMessage('SUrl='+ Surl);   //20260807

 If (LicenseLevel = llStd) then
 begin
  ShowMessage('NetFile is not available in the T2 Standard version');
  Exit;
 end;

 If LicenseLevel = llDemo then
 begin
  ShowMessage('NetFile is not included in the demo version');
  exit;
 end;


 If (Length(GetAlbAccNo(RetNo))<9)
 or (Length(GetAlbAccNo(RetNo))>10)
 then
 begin
  ShowMessage('Alberta number is invalid');
  Exit;
 end;

 With OptRec do
 begin
  If (Prp_Street='') or (Prp_City='') Or (Prp_Prov='') or (Prp_Postal='') Or (Prp_Countr='')
  Or (Prp_Area='') or (Prp_Tel='') or (Prp_ContactFN='')
  Or (Prp_ContactLN='') Or (Prp_ContactPos='')
  Or (Prp_Email='')
  then
  begin  //20260709
    ShowMessage('Please enter ALL Preparer Identification data (Exit and click on Configure -> General Options ->Preparer Identification'
    +Chr(13)+'Preparer Name required if Efiling as third party transmitter'
    +Chr(13)+'Fax is not reqired');
    Exit;
  end;
 end;


 If OptRec.Prp_Countr='' then
 begin
  ShowMessage('Please provide/verify Preparer Country code (See Configure -> General Options ->Preparer');
  Exit;
 end;

 If OptRec.Prp_OrgType='' then
 begin
  ShowMessage('Please provide/verify Preparer Organization Type (See Configure -> General Options ->Organization');
  Exit;
 end;


 If ThirdPartyIndicatorBox.checked then
 begin
  If OptRec.Prp_Name='' then
  begin
   ShowMessage('Preparer Name must be entered (See Configure -> General Options ->Preparer Name');
   Exit;
  end;
 end;

 If Length(OptRec.Prp_Name)>70 then
 begin
  ShowMessage('Preparer Name exceeds 70 characters (See Configure -> General Options ->Preparer Name');
  Exit;
 end;

 If Length(OptRec.Prp_Street)>35 then
 begin
  ShowMessage('Preparer Street exceeds 35 characters (See Configure -> General Options ->Preparer Street');
  Exit;
 end;

 If Length(OptRec.Prp_City)>35 then
 begin
  ShowMessage('Preparer City exceeds 35 characters (See Configure -> General Options ->Preparer City');
  Exit;
 end;

 If Length(OptRec.Prp_Tel)>12 then
 begin
  ShowMessage('Preparer Telephone exceeds 12 characters (See Configure -> General Options ->Preparer Tel');
  Exit;
 end;

 If Length(OptRec.Prp_Fax)>12 then
 begin
  ShowMessage('Preparer Fax No. exceeds 12 characters (See Configure -> General Options ->Preparer Fax');
  Exit;
 end;

 If Length(OptRec.Prp_ContactFn)>35 then
 begin
  ShowMessage('Preparer Contact First Name exceeds 35 characters (See Configure -> General Options ->Contact First Name');
  Exit;
 end;

 If Length(OptRec.Prp_ContactLn)>35 then
 begin
  ShowMessage('Preparer Contact Last Name exceeds 35 characters (See Configure -> General Options ->Contact Last Name');
  Exit;
 end;

 If Length(OptRec.Prp_ContactPos)>40 then
 begin
  ShowMessage('Preparer Contact Position exceeds 40 characters (See Configure -> General Options ->Contact Position');
  Exit;
 end;

 If CountAlbErrors(Ret[RetNo].AuditList) >0 then
 begin
   ShowMessage('There are Alberta errors. See the Audit Wizard');
   Exit;
 end;

 declarationText:= 'This return meets Alberta Corporate Net File eligibility requirements.' + chr(13) + chr(13);
 declarationText:= declarationText + 'I will not attempt to disrupt Alberta Corporate Net File service by uploading files other than an eligible' + chr(13);
 declarationText:= declarationText + 'Alberta corporate income tax return.  If I do, Tax and Revenue Administration (TRA) may deny me' + chr(13);
 declarationText:= declarationText + 'access to electronic services.' + chr(13) + chr(13);
 declarationText:= declarationText + 'I am an authorized signing officer of the corporation, or, if I am acting on behalf of the corporation, an ' + chr(13);
 declarationText:= declarationText + 'authorized signing officer of the corporation has instructed me to file this return.' + chr(13) + chr(13);
 declarationText:= declarationText + 'I certify, or, if filing on behalf of a corporation, an authorized signing officer of the corporation has' + chr(13);
 declarationText:= declarationText + 'certified, that this electronic return, including schedules, is a true, correct and complete return and ' + chr(13);
 declarationText:= declarationText + 'that the method of computing income for this taxation year is consistent with that of the previous ' + chr(13);
 declarationText:= declarationText + 'taxation year except as specifically disclosed on the return.' + chr(13) + chr(13);
 declarationText:= declarationText + 'I have read and agree to the above.';

   AMsgDialog := CreateMessageDialog(declarationText, mtCustom, [mbYes, mbNo]) ;
   with AMsgDialog do
   try
     Caption := 'Declaration' ;
     Height := (components[1] as TControl).top + 100;
     if (ShowModal = ID_YES) then
     begin
       //continue
     end
     else
       exit;
   finally
     Free;
   end;

 PrepareAlbEFile;

// ShowMessage('soapMsg='+soapMsg);//20211103
// ShowMessage('Ready to submit but stopped for testing'); Exit;  //20211103

 ObjHTTP := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest; //define

 (*   //20260807
 //20260706
 ShowMessage('Using test environment');
 sUrl := 'https://citsoftwarecert.finance.gov.ab.ca/CITNetFile-PublicWebServices-context-root/CITReturnFilingSoap12HttpPort?WSDL'; //test url
 ShowMessage('Alb NetFile SUrl ='+Surl);  //20260706
 *)
 //------------------------------------
 //20260807
 If TestingMode.checked = True then
  sUrl := 'https://citsoftwarecert.finance.gov.ab.ca/CITNetFile-PublicWebServices-context-root/CITReturnFilingSoap12HttpPort?WSDL' //test url
 else
  sUrl := 'https://citnetfile.finance.gov.ab.ca/CITNetFile-PublicWebServices-context-root/CITReturnFilingSoap12HttpPort?WSDL'; //production
 //20260807

 ObjHTTP.open('POST', sURL, False,'','');   //open
 ObjHTTP.setRequestHeader('Accept-Encoding', 'gzip,deflate');
 ObjHTTP.setRequestHeader('Content-Type', 'application/soap+xml');
 ObjHTTP.setRequestHeader('charset', 'UTF-8');
 ObjHTTP.setRequestHeader('User-Agent', 'Jakarta Commons-HttpClient/3.1');
 ObjHTTP.setRequestHeader('Host', '111.111.111.111');
 ObjHTTP.setRequestHeader('Content-Length', inttostr(length(SoapMsg)) );

 ObjHTTP.setRequestHeader('SOAPAction', 'NA'); //set action

 //transmit
 Screen.Cursor := crHourGlass;
 ObjHTTP.send(SoapMsg);
 Screen.Cursor := crDefault;
 delay(2000);
 Screen.Cursor := crDefault;
 WString:=ObjHTTP.ResponseText;

 //Now save the WString
 AList:=TStringList.Create;
 AList.Add(WString);
 ResponseFileNm:=MkResponseFileName(RetNo);  //+'.xml'; extension added in MkResponseFileName function
 AList.SaveToFile(ResponseFileNm); //ResponseRSIwebservices.xml');
 AList.Free;

  if isReturnAccepted(WString) then
  begin
        InitFormData(RetNo,GetFormNo('AEFDONE'));
       SaveResultCodes(WString);
        //showmessage(GetConfirmation(WString) + chr(13) + chr(13) + 'A copy of this information has been saved as: ' + MkResponseFileName(RetNo));
        showmessage('Thank you. Your Alberta Corporate Income Tax Return has been filed.'+
                Chr(13)+'After clicking OK, print a copy of the confirmation form and keep it for your records.'+
                Chr(13)+
                Chr(13)+'Also Save the return to capture permanently the Confirmation number of the AT1 NetFile status form');
        OpenForm(RetNo,GetFormNo('AEFDONE'),1);

        //jz 20241221 //run form function to update it, CAN number was not refreshing after submission during certification
        AefDone(RetNo,'AEFDONE',GetFormNo('AEFDONE'));

        CLOSE;
  end
  else
        showmessage('Return Submision has been REJECTED. Please review the errors listed below.'+ chr(13) + chr(13) + GetConfirmation(WString));

end;

procedure TARsiFrmT2_2027.PrepareAlbEfile;
Const Indentation=3;
Var
  i:integer;
  valu,ThirdPartyIndicator:String;
  RsiForm:String;//[13]; //20150701

begin
 OutPutList.Clear;
 ListBox2.Clear;

 //soapheader
 CreateSoapHeader(OutputList);

 //xml header
 With OutputList do
 Begin
   add('<?xml version="1.0" encoding="ISO-8859-1"?>');
   add('<ReturnSubmission xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="AlbertaCorporateIncomeTaxReturn.xsd">');
   add(space(2)+'<Return>');
   add(space(ScheduleIndentation)+'<ProgramCode>01</ProgramCode>');

 end;

 //schedule data
 For i:=0 to RsiFrmList.Items.count-1 do
 begin
   Inst :=1;
   RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i],13));
   If RsiHasData(RetNo,RsiForm) then
   begin
    RsiFrmList.ItemIndex :=i;
    PrepareSingleEfileSchedule(RsiForm);
   end;
 end;
 With OutputList do
 Begin

   add(space(ScheduleIndentation) + '<Schedule Number="EDI">');

   if testingMode.checked then
        valu := AlbertaNetFileCode_Test  //'BY2017/declare
   else
        valu := AlbertaNetFileCode_Approval;

   add(space(ElmIndentation) + '<Value LineItemID="EDI001001">' + valu + '</Value>'); 	      //<!--SCC -->                   MANDATORY

   If TestingMode.Checked then
    add(space(ElmIndentation) + '<Value LineItemID="EDI011001">' + AppVersion + '</Value>')   //<!--WebServiceVersion -->     MANDATORY
   Else
    add(space(ElmIndentation) + '<Value LineItemID="EDI011001">' + AppVersion + '</Value>'); //20120524  //<!--WebServiceVersion -->     MANDATORY
    //add(space(ElmIndentation) + '<Value LineItemID="EDI011001">' + '1.0.1' + '</Value>');   //<!--WebServiceVersion -->     MANDATORY

   add(space(ElmIndentation) + '<Value LineItemID="EDI013001">' + AppVersion + '</Value>');                             //<!--SoftwareVersion -->       MANDATORY
   add(space(ElmIndentation) + '<Value LineItemID="EDI015001">' + AppVersion + '</Value>'); //'000000' 20120524     //<!--SerialNumber -->          MANDATORY

   valu := ReplacePredefinedXMLEntities(OptRec.Prp_ContactFn);
   add(space(ElmIndentation) + '<Value LineItemID="EDI031001">' + valu + '</Value>');                           //<!--ContactFirstName -->      MANDATORY
   valu := ReplacePredefinedXMLEntities(OptRec.Prp_ContactLn);
   add(space(ElmIndentation) + '<Value LineItemID="EDI033001">' + valu + '</Value>');                           //<!--ContactLastName -->       MANDATORY
   valu := ReplacePredefinedXMLEntities(OptRec.Prp_ContactPos);
   add(space(ElmIndentation) + '<Value LineItemID="EDI035001">' + valu + '</Value>');                           //<!--ContactPosition -->       MANDATORY

   valu := OptRec.Prp_Area + StringReplace(OptRec.Prp_Tel,'-','',[rfReplaceAll, rfIgnoreCase]);
   add(space(ElmIndentation) + '<Value LineItemID="EDI037001">' + valu + '</Value>');                           //<!--ContactPhone -->          MANDATORY
   valu := ReplacePredefinedXMLEntities(OptRec.Prp_EMail);
   add(space(ElmIndentation) + '<Value LineItemID="EDI041001">' + valu + '</Value>');                           //<!--ContactEmail -->          MANDATORY

  // If OptionsRec.Ef_ThirdParty then ThirdPartyIndicator := '1' else ThirdPartyIndicator := '2'; //1 is yes 2 is no
   If ThirdPartyIndicatorBox.Checked then ThirdPartyIndicator := '1' else ThirdPartyIndicator := '2'; //1 is yes 2 is no
   add(space(ElmIndentation) + '<Value LineItemID="EDI017001">' + ThirdPartyIndicator + '</Value>');            //<!--ThirdPartyIndicator -->   MANDATORY

   if ThirdPartyIndicator = '1' then
   begin
     valu := ReplacePredefinedXMLEntities(OptRec.Prp_Name);
     add(space(ElmIndentation) + '<Value LineItemID="EDI019001">' + valu + '</Value>');  	                //<!--LegalName -->         mandatory if ThirdPartyIndicator = 1
     valu := ReplacePredefinedXMLEntities( AllTrim(MidStr(OptRec.Prp_OrgType,2,20)) );
     add(space(ElmIndentation) + '<Value LineItemID="EDI023001">' + valu + '</Value>');  	                //<!--OrganizationType -->  mandatory if ThirdPartyIndicator = 1
     valu := ReplacePredefinedXMLEntities(OptRec.Prp_Street);
     add(space(ElmIndentation) + '<Value LineItemID="EDI051001">' + valu + '</Value>');                         //<!--ContactAddress1 -->   mandatory if ThirdPartyIndicator = 1
     //add(space(ElmIndentation) + '<Value LineItemID="EDI053001">' + OptRec. + '</Value>'); 			//<!--ContactAddress2 -->
     valu := ReplacePredefinedXMLEntities(OptRec.Prp_City);
     add(space(ElmIndentation) + '<Value LineItemID="EDI055001">' + valu + '</Value>');  	                //<!--ContactCity -->       mandatory if ThirdPartyIndicator = 1

     add(space(ElmIndentation) + '<Value LineItemID="EDI057001">' + OptRec.Prp_Prov + '</Value>');              //<!--ContactProvState -->  mandatory if ThirdPartyIndicator = 1
     add(space(ElmIndentation) + '<Value LineItemID="EDI059001">' + OptRec.Prp_Postal + '</Value>');	        //<!--ContactPostalZip -->  mandatory if ThirdPartyIndicator = 1
     add(space(ElmIndentation) + '<Value LineItemID="EDI061001">' + OptRec.Prp_Countr + '</Value>');            //<!--ContactCountry -->    mandatory if ThirdPartyIndicator = 1

     //201811
     If UpperCase(FetchElm(RetNo,'AT1',66))='Y' then amended:=True else amended:=False;
     if amended then
     Begin
       add(space(ElmIndentation) + '<Value LineItemID="EDI071001">' + '1' + '</Value>');            //<!--Amended
       valu:=LeftStr(FetchElm(RetNo,'AT1',67),100);
       add(space(ElmIndentation) + '<Value LineItemID="EDI073001">' + valu + '</Value>');            //<!--Amended
     End;



   end;

   //add(space(ElmIndentation) + '<Value LineItemID="EDI021001">Alberta Service Operator</Value>');	        //<!--OperatingName -->



   valu:=OptRec.Prp_FxArea + StringReplace(OptRec.Prp_Fax,'-','',[rfReplaceAll, rfIgnoreCase]);
   if valu > '' then
     add(space(ElmIndentation) + '<Value LineItemID="EDI039001">' + valu + '</Value>');                         //<!--ContactFax -->

   add(space(ScheduleIndentation) + '</Schedule>'); //end EDI Schedule


   add(Space(2)+'</Return>');
   add('</ReturnSubmission>');
 End;

 CreateSoapFooter(OutputList);

 SoapMsg:='';
 For i:=0 to OutPutlist.count -1 do
 begin
   // ListBox2.Items.add(OutPutlist[i]); //show the ouput on screen
    SoapMsg:= SoapMsg + OutPutlist[i]; //+Chr(13); //new line char caused error

 end;

 //for testing
 OutPutlist.savetofile(MkSubmittedFileName(RetNo)); //'testingRSIwebservices.xml');
end;

Function TARsiFrmT2_2027.ReplacePredefinedXMLEntities(info:String):String;
Begin

 info := ReplaceChar(info,'&','&amp;');
 info := ReplaceChar(info, '<' , '&lt;' );
 info := ReplaceChar(info,'"','&quot;');
 info := ReplaceChar(info,'>','&gt;');
 info := ReplaceChar(info,'''','&apos;');
 //info := ReplaceChar(info,'.','');

 result := info;

End;

Procedure TARsiFrmT2_2027.CreateSoapHeader(Var TempSoapList:TStringList);
Var i:Integer;
begin
 With TempSoaplist do
 begin
    add('<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:cit="http://cit.tra.fin.goa/">');
    add('<soap:Header/>');
    add('<soap:Body>');
    add('<cit:fileReturn>');
    add('<arg0>');
    add('<![CDATA[');
 end;
end;

Procedure TARsiFrmT2_2027.CreateSoapFooter(Var TempSoapList:TStringList);
Var i:Integer;
begin
 With TempSoaplist do
 begin
    add(']]>');
    add('</arg0>');
    add('</cit:fileReturn>');
    add('</soap:Body>');
    add('</soap:Envelope>');
 end;
end;

procedure TARsiFrmT2_2027.PrepareSingleEfileSchedule(RsiForm:String);
Var i,j:Integer;TempList,RsiSpec:TStringList;
begin
// SkipIt:=False;  //20140524
 TempList:=TstringList.Create;
 RsiSpec := TstringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'AlbRSI.d');
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
 OutputList.Add(Space(ScheduleIndentation)+'<Schedule Number='+Char(34)+RightStr(RsiForm,3)+Char(34)+'>');
 PrepareDetailEfileSchedule(RetNo,RsiForm,RsiSpec,Inst);
 OutputList.Add(Space(ScheduleIndentation)+'</Schedule>');
 RsiSpec.Free;
 Screen.Cursor := crDefault;
end;

Procedure TARsiFrmT2_2027.PrepareEfileElement(ScheduleId,LineNo,OccurSeq:String;Valu:String);
Var
  s:String; //,Part1,Part2,Part3: string;
  k:integer;
begin
// If SkipIt = True then exit;   //20140524

 if (ScheduleId = '000') and (LineNo = '005') then
 Begin
  if testingMode.checked then
   valu :=AlbertaNetFileCode_Test //AlbTestNetFileCode
  else
   valu:= AlbertaNetFileCode_Approval;
 end;
  valu := ReplacePredefinedXMLEntities(valu);

 //20210625
 if (ScheduleId = '021') then
 Begin
 //20211103
  if (LineNo='151') or (LineNo='153') or (LineNo='155') or (LineNo='157')
  or (LineNo='159') or (LineNo='165') or (LineNo='167') or (LineNo='169')  //2021111
  then
  begin
   k:=StrToInt(OccurSeq)+1;
   OccurSeq:=Paddzero(IntToStr(k),3);
  end;

  //if (LineNo='159') or (LineNo='165') or (LineNo='167') or (LineNo='169') then begin valu:='';exit;end; //20211103

  (* NO good
  //20211103  NO impact
  if (LineNo='151') or (LineNo='153') or (LineNo='155') or (LineNo='157')
  or (LineNo='159') or (LineNo='165') or (LineNo='167') or (LineNo='169')
  then
  begin
   k:=StrToInt(OccurSeq); //+1;
   OccurSeq:=Paddzero(IntToStr(k),3);
  end;
*)


 End;

  s:=Space(ElmIndentation)+'<Value LineItemID='+Chr(34)+ScheduleId+LineNo+OccurSeq+Chr(34)+'>'+valu+'</Value>';
  if (ScheduleId='013') and (valu='') then exit; //20171130
  OutputList.Add(S);
  //if (LineNo>='151') and (LineNo<='169')  then ShowMessage(s); //20211103

end;



procedure TARsiFrmT2_2027.PrepareDetailEfileSchedule(RetNo:Integer;RsiForm:String;RsiSpecs:TStringList;Inst:Integer);
Var i,j,jj,k,FNo,ElmNo,FromElm,ToElm,ByIncr,
    NumbOfEmptyLines:integer;
    LineCommand,s:String;
    FName:String;//[10]; //20150701
    ElmString:String;//[6]; //20150701
    Mandatory:String;//[1]; //20150701
    DataType:String;//[4]; //20150701
    LineNo:String;//[5]; //20150701
    DataLengthString:String;//[5]; //20150701
    LineValu,valu:String;
    BoldIndic,UnderlineIndic,NegativeIndic:Boolean;
    AddressIndic, LoopIndic, LargeFontIndic:Boolean;
    ScheduleId :String;//[10]; //20150701
    BoxRect :TRect;
    LeftOfBox,TopOfBox,RightOfBox,BottomOfBox:real;
    BoxShading:Boolean;
    LoopRefName  : String;//[12]; //20150701
    MaxLoopCounter:Integer;

    OccurSeqCount:Integer;
    ExceedsCnt:Boolean;   //20140630
begin
 If RsiSpecs.Count <=0 then exit;
 S:= RsiSpecs[0];


 ScheduleId := AllTrim(MidStr(s,10,4));

 //BODY OF Efile FORM}
 If RsiSpecs.count <2    then exit;

 i:=1;
 Repeat
    S            := RsiSpecs[i];
    LineCommand  := AllTrim(MidStr(S,1,10));
    FName        := AllTrim(MidStr(S,14,8));
    ElmString    := Alltrim(MidStr(s,22,3));
    DataType     := AllTrim(MidStr(S,59,5));
    Mandatory    := Alltrim(MidStr(s,73,1));
    ElmNo        := MyStrToInt(AllTrim(ElmString));
    LineNo       := GetLineNo(LineCommand);
    LoopIndic    := GetLoopIndic(LineCommand);
    AddressIndic := GetAddressIndic(LineCommand);
    LoopRefName  := GetLoopRefName(S);

    {validate}

    //jz 20241209 allow for comment line
    If pos('//',LineCommand) > 0 then
    begin
      Inc(i);
      continue;
    end;

    If (LoopIndic =true) and (GetMaxLoopCnt(LoopRefName) = -1) then
    begin
      ShowMessage('Loop incorrect in: '+s);
      exit;
    end;

    //OccurSeqCount := 1; //20140630
    If LoopIndic then   {Loop}
    begin
       {data loop}
       FromElm := MyStrToInt(AllTrim(MidStr(S,22,3)));
       ToElm   := MyStrToInt(AllTrim(MidStr(S,26,3)));
       ByIncr  := MyStrToInt(AllTrim(MidStr(S,30,3)));
       LoopRefName := AllTrim(MidStr(S,34,8));
       MaxLoopCounter := GetMaxLoopCnt(LoopRefName);
       j:=FromElm;K:=1;
       jj:=0;
       Repeat
          FNo := GetFormNo(FName);

          //20150910
          If ScheduleId='020' then Begin If (j=27) or (j=28) or (j=29) or (j=30) or (j=31) or (j=32) then jj:=71;end;  //last invisible column of AS21 which shows seq
          If ScheduleId='021' then
          Begin
           If (j=178) or (j=179) or (j=180) or (j=182) or (j=184) or (j=185) then jj:=471;
           If (j=346) or (j=347) or (j=348) or (j=349) or (j=350) then jj:=491;  //20150520
          end;  //last invisible column of AS21 which shows seq



          If (FNo =0) or (FromElm =0) or (ToElm =0) or (ByIncr=0) then
            valu := ''
          else
            Valu := GetValueFromForm(RetNo,FName,j,Inst);
          If ((DataType = 'AN') or (DataType = 'A')) and (Valu >'') then
            Valu := DoubleWordSeparators(Valu);

          If FName = 'AS1' then
          begin
           Case j of
             106,109,112,115,118,121,124,127,130,133,136,139:
             if AllTrim(FetchElmFNo(RetNo,FNo,j-2)) >'' then
                Mandatory:='M';
           end;
          end;

          If FName = 'AS12_2' then
          begin
           If ElmNo=15 then If FetchElmFNo(RetNo,FNo,20) >'' then  Mandatory:='M';
          end;

          If (Valu ='') and (Mandatory = 'M') then
          begin
           If DataType='$' then valu := '0';
          end;

          If DataType = 'Y/N' then Valu := FormatYesOrNoValu(Valu);
          If DataType = '1/2' then Valu := FormatOneOrTwoValu(Valu);
          If DataType = 'N' then  valu := RemoveNonNumericChars(Valu);
          If DataType = '%' then valu := FormatPercent(ScheduleId,LineNo,Valu);
          If (DataType = 'D') or (DataType = 'D/T') then
            Valu := FormatDateValu(Valu);

          NegativeIndic:= GetNegativeIndic(DataType,Valu);
          If DataType = '$' then  valu := FormatRSIAmount(Valu,NegativeIndic);
          If (Valu ='') and (Mandatory = 'M') then
          begin
           If DataType='$' then valu := '0';
          end;

          OccurSeq:=PaddZero(IntToStr(k),3);

           //-------------------------------------
          //20150609
          If ScheduleId='020' then //20150509  //AS20 special
          begin
           If (j>=27) and (j<=62) then
            OccurSeq:=Paddzero(FetchElmFNo(RetNo,FNo,jj),3);  //jj last invisible column index
          end;

          If ScheduleId='021' then //20150509  As21  special
          begin
           If (j>=170) and (j<=177) then OccurSeq:='000';  //first line current year    //jj= last invisible column index
           If (j>=178) and (j<=337) then OccurSeq:=Paddzero(FetchElmFNo(RetNo,FNo,jj),3);  //jj last invisible column index
           If (j>=346) and (j<=449) then OccurSeq:=Paddzero(FetchElmFNo(RetNo,FNo,jj),3);  //jj last invisible column index  //20150520
          end;

          //--------------------------------------
          Valu:=AllTrim(Valu);
          If (Length(Valu) >0) or (Mandatory = 'M') then
          begin
           PrepareEfileElement(ScheduleId,LineNo,OccurSeq,Valu);  {Row}

           //20140630
           //OccurSeq:=PaddZero(IntToStr(OccurSeqCount),3);
           //Inc(OccurSeqCount,1);

          end;
          Inc(J,ByIncr);
          Inc(k,1);
          Inc(jj,1);  //20150609
          ExceedsCnt:=ExceedsLoopCnt(k,MaxLoopCounter,Fname); //20140630
       until  (j>ToElm) or (ExceedsCnt); //20140630 //until  (j>ToElm) or (k>MaxLoopCounter);
    end //end LoopIndic then

    {lines and data}
    else If LineNo > '' then   {Line Number}
    begin
      {constant}
      If LeftStr(FName,1) = '=' then {Constants}
        begin
         PrepareEfileElement('','','',MidStr(S,15,40))
        end
       {Line valu}
      else If (FName >'') and (ElmNo >0) then
      begin
        FNo := GetFormNo(FName);
        If ElmNo >0 then
        begin
         If ElmNo=999 then valu :='' else Valu := GetValueFromForm(RetNo,FName,ElmNo,Inst);
        end
        else
         Valu := '';
        If ((DataType = 'AN') or (DataType = 'A')) and (Valu >'') then
          Valu := DoubleWordSeparators(Valu);
        If DataType = 'Y/N' then Valu := FormatYesOrNoValu(Valu);
        If DataType = '1/2' then Valu := FormatOneOrTwoValu(Valu);
        If DataType = 'N' then  valu := RemoveNonNumericChars(Valu);
        If DataType = '%' then  valu := FormatPercent(ScheduleId,LineNo,Valu);
        If (DataType = 'D') or (DataType = 'D/T') then Valu := FormatDateValu(Valu);
        NegativeIndic:= GetNegativeIndic(DataType,Valu);
        If DataType = '$' then valu := FormatRSIAmount(Valu,NegativeIndic);
        Valu:=AllTrim(Valu);

        If (FName = 'AS21') and (ElmNo=22) then
        begin
         If (Vl(FetchElm(RetNo,'AS21',14)) <> 0)
         or (Vl(FetchElm(RetNo,'AS21',24)) <> 0)
         then Mandatory := 'M';
        end;

        If FName = 'AS12_2' then //???
        begin
         If ElmNo=15 then
           If FetchElmFNo(RetNo,FNo,20) >'' then  Mandatory:='M';
        end;

        If (Valu ='') and (Mandatory = 'M') then
        begin
         If DataType='$' then valu := '0';
        end;
        OccurSeq:='001';
        If (Length(Valu) >0) or (Mandatory = 'M') then
        begin
          PrepareEfileElement(ScheduleId,LineNo,OccurSeq,Valu);
        end;
      end;  {Fname andElmNo}
    end; {end lineno}
    Inc(i);
 until i > RsiSpecs.Count-1;
end; {procedure}


Function TARsiFrmT2_2027.MkResponseFileName(RetNo:Integer):String;
Var CorpNm:String;
begin
  CorpNm:=GetCorpName(RetNo);
  CorpNm:=RemoveChar(CorpNm,'.');
  CorpNm:=ReplaceChar(CorpNm,Char(39),'');
  CorpNm:=ReplaceChar(CorpNm,Char(44),'');
  CorpNm:=ReplaceChar(CorpNm,'/','');
  CorpNm:=ReplaceChar(CorpNm,'"','');
  CorpNm:=ReplaceChar(CorpNm,':',''); //20100628
  CorpNm:=ReplaceChar(CorpNm,';','');
  result:=AlbertaEfileDir+'\'+'Response-'+CorpNm+'.xml'
end;


Function TARsiFrmT2_2027.MkSubmittedFileName(RetNo:Integer):String;
//embedded function
Function GetMinutesAndSeconds:String;  //function within function
Var
  SHours, SMinutes,SSeconds : string;//[2]; //20150701
  Hour,Min,Sec,Msec :word;
begin
  DecodeTime(Now,Hour,Min,Sec,Msec);
  sMinutes := AllTrim(IntToStr(Min));
  sSeconds := AllTrim(IntToStr(Sec));
  If Length(sMinutes) =1 then SMinutes := '0'+SMinutes;
  If Length(SSeconds) =1 then SSeconds := '0'+SSeconds;
  Result := SMinutes+SSeconds;
end; //end of embedded function
Var s:String; CorpNm:String;
begin
  CorpNm:=GetCorpName(RetNo);
  CorpNm:=RemoveChar(CorpNm,'.');
  CorpNm:=ReplaceChar(CorpNm,Char(39),'');
  CorpNm:=ReplaceChar(CorpNm,Char(44),'');
  CorpNm:=ReplaceChar(CorpNm,'/','');
  CorpNm:=ReplaceChar(CorpNm,'"','');
  CorpNm:=ReplaceChar(CorpNm,':',''); //20100628
  CorpNm:=ReplaceChar(CorpNm,';','');
  result:=AlbertaEfileDir+'\'+'ToBeSubmitted-'+CorpNm+'.xml'
end;



procedure TARsiFrmT2_2027.ShowSubmittedBtnClick(Sender: TObject);
Var FlName:String; h:Thandle;
begin
  PrepareAlbEFile;
  FLname:=MkSubmittedFileName(RetNo);
  h := ShellExecute(Self.Handle,'open',Pchar(''+FlName),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('File not found');
end;

procedure TARsiFrmT2_2027.BitBtn5Click(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

procedure TARsiFrmT2_2027.BitBtn4Click(Sender: TObject);
Var h:THandle; Pgm:String;
begin
  PGM:=AppDir+'\'+'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle,'open',Pchar(''+Pgm),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Installation interrupted or program not found');
end;


Function TARsiFrmT2_2027.isReturnAccepted(ResponseXmlString: String):boolean; //20150701
var
   rCode:string;
   sPos,ePos:integer;
begin

  result:=false;
  sPos := Pos('<return>',ResponseXmlString);
  ResponseXmlString :=MidStr(ResponseXmlString,sPos,length(ResponseXmlString));

  sPos := Pos('code>',ResponseXmlString) + 5;
  ePos := Pos('</'   ,ResponseXmlString);
  rCode:=MidAnsiStr(ResponseXmlString,sPos,ePos-sPos);

  if rCode='30001' then
  begin
   result := true;
  end;

end;

Function TARsiFrmT2_2027.GetConfirmation(ResponseXmlString: String): String; //20150701

 function interpretCode(c:string;resultString:String):String; //20150701
  begin
      if c = '30001' then
      begin
        result := resultString + chr(13) + 'Confirmation Number:' + chr(13);
       // ConfirmationNumber:=ResultString;
      end
      else if c = '30002' then
        result := resultString//do not write caption - states return successfully filed

      else if c = '30003' then
        result := resultString//do not write caption - states thanks,filed, keep a copy

      else if c = '30004' then
        result := resultString + 'Alberta Corporation Account Number:' +chr(13) //

      else if c = '30005' then
        result := resultString + 'Tax Year End:' + chr(13)

      else if c = '30006' then
        result := resultString + 'Receipt Date Timestamp:' + chr(13)
      else
        result := resultString + 'Error Code '+ c + ':' + chr(13);

  end;

Var TempList:TStringList;i,k:Integer;
   val,rCode:string;
   ElementName, ElementValue: string;
   Doc: IXMLDOMDocument;
   nlist,nodeSet:IXMLDOMNodelist;
   sPos,ePos,maxReps:integer;
   resultString:string;
Begin

 Result:='';

 resultString:='';
 i:=0;
 maxReps:=50;
 while Pos('<return>',ResponseXmlString) > 0 do
 begin

  sPos := Pos('<return>',ResponseXmlString);
  //showmessage(inttostr(length(ResponseXmlString)));
  ResponseXmlString :=MidAnsiStr(ResponseXmlString,sPos,length(ResponseXmlString));

  sPos := Pos('code>',ResponseXmlString) + 5;
  ePos := Pos('</'   ,ResponseXmlString);
  rCode:=MidAnsiStr(ResponseXmlString,sPos,ePos-sPos);

  resultString := interpretCode(rCode,resultString); //resultString + 'Error Code:'+ rCode + chr(13);

  ResponseXmlString :=MidAnsiStr(ResponseXmlString,ePos+2,length(ResponseXmlString));

  sPos := Pos('type>',ResponseXmlString) + 5;
  ePos := Pos('</'   ,ResponseXmlString);
  resultString := resultString +MidAnsiStr(ResponseXmlString,sPos,ePos-sPos) + chr(13)+chr(13);

  ResponseXmlString :=MidAnsiStr(ResponseXmlString,ePos+2,length(ResponseXmlString));

  //just in case...
  i:=i+1;
  if i >= maxReps then break;

 end;


 if (i = 0) or (i >= maxReps) then
  Result:='Error in soap message response format. Please contact VisualTax.'
  // showmessage('Error parsing response message.') //error
 else
  result:=ResultString;
  // showmessage(resultString);

end;

Procedure TARsiFrmT2_2027.SaveResultCodes(ResponseXmlString:String); //20150701

 function GetElmToSaveTo(c:string;resultString:AnsiString):integer;
  begin
      if c = '30001' then
        result := 3 //Confirmation Number
      else if c = '30002' then
        result := 5 //States return successfully filed
//      else if c = '30003' then
//        result := //states thanks,filed, keep a copy
//      else if c = '30004' then
//        result := //Alberta Corporation Account Number
//      else if c = '30005' then
//        result := //Tax Year End
      else if c = '30006' then
        result := 4//Receipt Date Timestamp
      else
        result := 0; //code not found

  end;

Var TempList:TStringList;i,k:Integer;
   val,rCode,sString:string;
   sPos,ePos,ElmToSaveTo,maxReps:integer;
   resultString:Ansistring;
Begin
 resultString:='';
 i:=0;
 maxReps:=50;
 while Pos('<return>',ResponseXmlString) > 0 do
 begin

  sPos := Pos('<return>',ResponseXmlString);
  ResponseXmlString :=MidAnsiStr(ResponseXmlString,sPos,length(ResponseXmlString));

  sPos := Pos('code>',ResponseXmlString) + 5;
  ePos := Pos('</'   ,ResponseXmlString);

  rCode:=MidAnsiStr(ResponseXmlString,sPos,ePos-sPos);

  ElmToSaveTo := GetElmToSaveTo(rCode,resultString); //resultString + 'Error Code:'+ rCode + chr(13);

  ResponseXmlString :=MidAnsiStr(ResponseXmlString,ePos+2,length(ResponseXmlString));

  sPos := Pos('type>',ResponseXmlString) + 5;
  ePos := Pos('</'   ,ResponseXmlString);

  if ElmToSaveTo > 0 then
  begin
        sString := MidAnsiStr(ResponseXmlString,sPos,ePos-sPos);
        StoreElm(RetNo,getformNo('AEFDONE'),ElmToSaveTo,sString);
  end;

  ResponseXmlString :=MidAnsiStr(ResponseXmlString,ePos+2,length(ResponseXmlString));

  //just in case...
  i:=i+1;
  if i >= maxReps then break;

 end;


 if (i = 0) or (i >= maxReps) then
  showmessage('Error saving response message.') //error

end;


procedure TARsiFrmT2_2027.testResponseClick(Sender: TObject);
var
f:    file;
filename,testString:string;
NumRead: Integer;
ansiTemp:AnsiString;
Buf: array[1..2048] of Char;
begin
  //filename:= 'C:\Delphi\T2\AlbertaEfile\Response-TEST CASE 107 INC.xml';
  //filename:= 'C:\Delphi\T2\AlbertaEfile\Response-TEST CASE 107 INC.xml.xml';
  filename:= MkResponseFileName(RetNo);
  If Not FileExists(filename) then
  begin
        showmessage('Cannot find '+filename);
        exit;
  end;

  NumRead:=0;
  assignFile(f,filename);
  reset(f,1);

  while not Eof(f) do
  begin
        BlockRead(f, Buf, SizeOf(Buf), NumRead);
  end;

  CloseFile(f);

  if isReturnAccepted(buf) then
  begin
        InitFormData(RetNo,GetFormNo('AEFDONE'));
        SaveResultCodes(buf);
        showmessage(GetConfirmation(buf) + chr(13) + chr(13) + 'A copy of this information has been saved as: ' + MkResponseFileName(RetNo));
        OpenForm(RetNo,GetFormNo('AEFDONE'),1);
        CLOSE;
  end
  else
        showmessage('Return Submision has been REJECTED. Please review the errors listed below.'+ chr(13) + chr(13) + GetConfirmation(buf));

end;


Function TARsiFrmT2_2027.GetSkipIndicator(RetNo:Integer;FName:String;LineNo:String):Boolean;
begin
 Result:=False;
end;

//20170625
Function TARsiFrmT2_2027.IncludeAs3ElmInRsi(FNo:Integer;Elm:Integer):Boolean;
// Finds the invisible k=rowused indicator depending of the row where the elm belongs to
Var i, k:Integer;
begin
 k:=0;
 Result:=True;
 Case Elm of
  120:k:=136;
  16..21:k:=136;

  121:k:=137;
  22..27:k:=137;

  122:k:=138;
  28..33:k:=138;

  123:k:=139;
  34..39:k:=139;

  124:k:=140;
  40..45:k:=140;
// ---------second table ---------------------
  125:k:=141;
  49..54:k:=141;

  126:k:=142;
  55..60:k:=142;

  127:k:=143;
  61..66:k:=143;

  128:k:=144;
  67..72:k:=144;

  129:k:=145;
  73..78:k:=145;

  130:k:=146;
  79..84:k:=146;

  131:k:=147;
  85..90:k:=147;

  132:k:=148;
  91..96:k:=148;

  133:k:=149;
  97..102:k:=149;

  134:k:=150;
  103..108:k:=150;

  135:k:=151;
  109..114:k:=151;
 End;
 if (k>0) and (FetchElmFNo(RetNo,FNo,k)='') then begin Result:=False;Exit;End; //row was not used
end;

end.
