unit T4T5_2026ChildWinNew;
(* see vtChild for documentation
*)

interface

uses SysUtils,WinTypes,WinProcs,Classes,Graphics,Forms,Controls,TabNotBk,
  StdCtrls,ExtCtrls,Tabs,Menus,Grids,Dialogs,ColorGrd,ClipBrd,Gauges,Mask,
  DBCtrls,Printers,Messages,shellApi,Buttons,ComCtrls,vtEditBox,vtLabel,vtShape,
  vtChild,vtForm,  T4T5_2026HeaderFrame,
  T4T5_2026MonitorFrame,//wwriched,
  TypInfo,

  rxRichEd; //20160819 Igor (Must be last)

type
  TFormT4T5_2026 = class(TvtScrollBox)
  private
    function PopulatePickList(FieldId: Integer): String;
    function CleanUpPickedListValue(FieldId: Integer;SelectedString: String): string;  //20170903 CON WHY???
    procedure GetSICCode(FieldId: Integer);
  protected  //required overrides
    procedure DataChangeRtn; override;
    procedure FormatDollar(MyEditBox: TvtEdit; str: string); override;
    procedure FormatEditBoxText(MyEditBox: TvtEdit; str: string); override;
    function GetLinkedForm(FieldId: Integer; var TargetLinkedField: Integer): String; override;
    Procedure PopulateFormWithData; override;
    Procedure ShowRichData(ARichEdit:TRichEdit;Fld:Integer); override;
    Procedure ShowFieldData(MyEditBox:TvtEdit); override;
    Function GetValueFromList(MyEditBox:TvtEdit;FieldId:Integer):String; override;
    function ValidateField(FieldId: integer; OldValue: string; var Value: string): boolean; override; //20260704 Alex
    function AllowEditVertSeparator: Boolean; override; //20171226 Igor
  protected //handlers
    procedure FormButtonClick(Sender: TObject); override;
    procedure EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
    procedure OnVtEditDblClick(MyEditBox:TvtEdit); override;
  end;

  TMyChildT4T5_2026 = class(TMyChild)
  public
    procedure FormPaint(Sender: TObject);

    procedure CloseActiveForm(Sender: TObject); override;
  private
    FMyFormHeaderFrame: THeaderFrameT4T5_2026;
    FMyMonitorFrame: TMonitorFrameT4T5_2026;
    Procedure ChildMsgHandler(var Msg: TMsg; Var Handled:Boolean);
  protected
    function GetHeaderFrame: TFrame; override; //20160227 Igor
    function GetMonitorFrame: TFrame; override; //20160227 Igor
  public  //protected  //required overrides
    procedure AddPropertiesAndEvents; override;
  public //overrides
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    Procedure Keys(Var Key: Word; Shift: TShiftState); override;

    procedure UpdateChildTaxPanel; override;
    Procedure UpdateFormHeaderFrame; override;
  public
    constructor CreateNew(AOwner: TComponent; RNo: Integer); override;
    property MyMonitorFrame:TMonitorFrameT4T5_2026 read FMyMonitorFrame;
    property MyFormHeaderFrame:THeaderFrameT4T5_2026 read FMyFormHeaderFrame;
  end;

//known to all
Function InDateYYYYMMDDonly(Value:string;MxYear: integer):Boolean;
//Function InT5013DateYYYYMMDDonly(Value:string;MxYear:integer):Boolean;

Function BeforeOpenForm(RetNo: Integer;var FName: string; var FNo: integer): string;
Function GetDFMFileName(FName:String):String;
Function GetLastYearDFMFileName(FName:String):String; //20160321 Igor
Function GetReturnCaption(RetNo:Integer):String;
Function SubstituteLastYearForm(FName: String): String; //20160629 Igor


var //force compiler errors
 MyChildT4T5_2026:boolean; //TMyChild;
 RetNo:boolean;

implementation
{--- $R *.DFM}

uses
  vtCommon,vtDialogs,vtMain,
  T4T5_2026,T4T5_2026Common,T4T5_2026Common2,
  T4T5_2026TrimStr,T4T5_2026Calc,
//T4T5_2026PopList,T4T5_2026PopComboList,
  T4T5_2026SaveAs,
  T4T5_2026Declare,T4T5_2026SearchList,
  T4T5_2026RichForm,T4T5_2026CntErr,T4T5_2026main,T4T5_2026Print,T4T5_2026SIC,
  vtTrimStr,vtShared, vtMulti;

//keep (here, local)
procedure ShowMessage(msg: string);
begin
  UserMsg(msg);
end;

Procedure TMyChildT4T5_2026.ChildMsgHandler(var Msg: TMsg; Var Handled:Boolean);
begin
  if (Msg.Message = WM_SysKeyDown) and (Msg.WParam = VK_F4) then
   begin
    Handled := True;
    exit;
   end;

  if (Msg.Message = WM_SysKeyDown) and (Msg.WParam = VK_F6) then
   begin
    Handled := True;
    exit;
   end;
end;

Function InDateYYYYMMDDonly(Value:string;MxYear: integer):Boolean;
begin
//  Result := InDateYMDonly(Value,1880,MxYear,'/'); //20160310 Igor
  Result := InDateYMDonly(Value,1880,MxYear,'-'); //20160310 Igor
end;
{$IFDEF old}
Function InT5013DateYYYYMMDDonly(Value:string;MxYear:integer):Boolean;
begin
  Result := InDateYMDonly(Value,1880,MxYear,'/');
end;
{$ELSE}

//Function InT5013DateYYYYMMDDonly(Value:string;MxYear:String;RetNo: integer; FormName: string;FieldId: integer):Boolean;
Function InT5013DateYYYYMMDDonly(Value:string;MxYear:integer;RetNo: integer; FormName: string;FieldId: integer):Boolean;
 var i: Integer;s:String;
begin
 Result := true;
 s:=Value;
 If s ='' then exit;

 If (s[5] <>'/') or (S[8] <> '/')
 or (not InNumRange(RightStr(s,2),01,31))
 or (not InNumRange(MidStr(s,6,2),01,12))
 //or (not InNumRange(LeftStr(s,4),1880,StrToInt(MxYear)))
 or (not InNumRange(LeftStr(s,4),1880,MxYear))
 //or (Vl(LeftStr(s,4)) > Vl(MxYear)) then
 or (Vl(LeftStr(s,4)) > MxYear) then
 begin
  ShowMessage('Invalid Date or out of range');
  Result := False;
 end;
end;
{$ENDIF}

procedure TMyChildT4T5_2026.addPropertiesAndEvents;
begin
  inherited;
 VertScrollBar.Tracking := True;
 HorzScrollBar.Tracking := True;
 VertScrollBar.Position:=0;
 KeyPreview:=True;
 OnKeyDown := FormKeyDown;
 OnKeyPress := FormKeyPress;
//install for use by vtScrollBox
  PopupMenu := MainFormT4T5.FormPopup;
  OnContextPopup := FormContextPopup;
end;


Function BeforeOpenForm(RetNo: Integer;var FName: string; var FNo: integer): string;
//Function OpenForm(RetNo: Integer;FNo: integer;Elm:Integer): boolean;
Var
{
  i,j,startPos,ActiveNdx:Integer;hwnd : Thandle; FName : string; //[15];
  TheEnterKey:Char;DfmFileName:String;
  FullFlname:String;
  FormsDir:String;
  ElmName:String;
  MyPanel1,MyPanel2:TPanel;MyBevel1:TBevel;
  MyEditBox:TvtEdit;
  NeedToCreateTabSheet:Boolean;
}
  DfmFileName:String absolute Result;
begin
   Result := '';
  If (RetNo < 1)
{$IFDEF ReturnsLimit}
  or (RetNo > ReturnsLimit)
{$ELSE}
{$ENDIF}
  then exit;
  If FNo = 0 then begin
   ShowMessage('Form No '+IntToStr(FNo)+' not found');
   exit;
  end;

  if FName = '' then
    FName := AppT4T5_2026.FirstForm; //'T3'
  //20160629 Igor >>>
  if FNo = 0 then
  begin
    If Ret[Retno].IsLastYearReturn = false then
      FNo:=GetFormNo(FName)
    Else
      FNo:=GetLastYearFormNo(FName);
  end;
  If ShowUnconvertedLastYear(RetNo) = False then
    DfmFileName:=GetDfmFileName(FName)
  else
    DfmFileName:=GetLastYearDfmFileName(FName);
  //20160629 Igor <<<
  If FileExists(DfmFileName) = False then
  begin
   ShowMessage('Form '+FName+' not found');
   Result := '';
   Exit;
  End;

  //Result := True;
  If Ret[RetNo].Frm[FNo].count =0 then InitFormData(RetNo,FNo); //here?
end;

procedure TFormT4T5_2026.PopulateFormWithData;
//Procedure TMyChildT4T5_2026.ShowFormData(FName:String;FNo:Integer);
begin
  If IsFormAClientLetter(FormName) then
    Color:=clWhite;
  inherited;
end;

procedure TFormT4T5_2026.FormButtonClick(Sender: TObject);
Var FNo:Integer;Nm:String;ARichEdit:TRichEdit;FirstFieldId:Integer;x:Real;
begin
 Nm:=UpperCase((Sender as TbitBtn).Name);  //button name

 If FormName='EMPL' then
 begin
  If Nm='T4SLIPSBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T4#1'),1);
     Exit;
  end;
  If Nm='T4ASLIPSBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T4A#1'),1);
     Exit;
  end;
  If Nm='T5SLIPSBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T5#1'),1);
     Exit;
  end;
  //20171223
  If Nm='EMPLOYERSLISTBTN' then
  begin
     MainFormT4T5.sbPreparationStatusClick(Sender);
     Exit;
  end;
 end; //empl

 If LeftStr(FormName,3)='T4#' then
 begin
  If Nm='T4CRAGUIDEBTN' then
   ShowPdf(AppDir,'RC4120-25e.pdf');  //20260107

   If Nm='APPLYTOTAXBTN' then
   Begin
    ShowMessage('You may want to manually add the difference in calculated adjustments to the Tax box 22'); //20250123
   End;
  {
  If Nm='APPLYTOTAXBTN' then
  Begin
    FNo:=GetFormNo(FormName);
    x:=Vl(FetchElm(RetNo,FormName,24));
    If UpperCase(FetchElmFNo(RetNo,FNo,111))<>'Y' then x:=X+Vl(FetchElmFNo(RetNo,FNo,107));
    If UpperCase(FetchElmFNo(RetNo,FNo,112))<>'Y' then x:=X+Vl(FetchElmFNo(RetNo,Fno,110));
    StoreElm(RetNo,FNo,24,FormatFloat('#######.##',x));
    //20180224
    If UpperCase(FetchElmFNo(RetNo,Fno,50))='Y' then
    Begin
     StoreElm(RetNo,FNo,19,FetchElmFNo(RetNo,Fno,106));
     StoreElm(RetNo,FNo,21,FetchElmFNo(RetNo,Fno,109));
    End;
    OpenForm(RetNo,FormName,0);
  End;
  }
 end;

 If LeftStr(FormName,4)='T4A#' then
 begin
  If Nm='T4ACRAGUIDEBTN' then ShowPdf(AppDir,'RC4157-25e.pdf');  //20260114
 end;

 If LeftStr(FormName,3)='T5#' then
 begin
  If Nm='T5CRAGUIDEBTN' then ShowPdf(AppDir,'T4015-25e.pdf');  //20260107
 end;

 //20181220
 If FormName='T4SUM' then
 begin
  If Nm='T4SUMIBTN' then OpenForm(GetCurrentRetNo,GetFormNo('T4SUMI'),1) //20181220
 end;

 If FormName='T4ASUM' then
 begin
  If Nm='T4ASUMIBTN' then OpenForm(GetCurrentRetNo,GetFormNo('T4ASUMI'),1) //20181220
 end;


 If FormName='T5SUM' then
 begin
  If Nm='T5SUMIBTN' then OpenForm(GetCurrentRetNo,GetFormNo('T5SUMI'),1) //20181220
 end;



 If IsFormAClientLetter(FormName) then
 begin
  If Nm='LETTERDESIGNBTN' then
  begin
   MainFormT4T5.ClientLetter1Click(Sender);
   OpenForm(GetCurrentRetNo,GetFormNo(FormName),1);
  end;
  If Nm='PRINTLETTERBTN' then MainFormT4T5.CurrentPage1Click(Sender);
 end;
end;

Function GetDFMFileName(FName:String):String;
Var FormsDir:String;
begin
 FormsDir:= GetDfmFormsDir;
 Result:= FormsDir+'\'+'u'+ExtractNonInstFormName(FName)+'.DFM';
end;

Function GetLastYearDFMFileName(FName:String):String; //20160321 Igor
Var
  FormsDir:String;
begin
  Result:='';
  FormsDir:=OptRec.Dir_PgmLastYr;
  if FormsDir = '' then exit;
  FName := ExtractNonInstFormName(FName);
  Result:= FormsDir+'\'+'u'+FName+'.DFM';
end;

Function TFormT4T5_2026.ValidateField(FieldId: integer; OldValue: string; Var Value : string):boolean; //20260704 Alex
Var I : integer;SelectedString :string;
begin
 Result := True;
  (* 20140101
    else if ExtractNonInstFormName(FormName) = 'PS50' then
    begin
     case FieldId of
     41:
      begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+1);exit;end;
     end; {case}
    end
  *)
  //20180424 Igor >>>
  if (ExtractNonInstFormName(FormName) = 'T4')
     or
     (ExtractNonInstFormName(FormName) = 'T4A')
     or
     (ExtractNonInstFormName(FormName) = 'T5') then
  begin
    if not CheckSINforDuplicates(RetNo, FormNo, ExtractNonInstFormName(FormName), Value) then
    begin
      {201200113
      Result := false;
      Value := '';
      }
      ShowMessage('SIN already exists for this employer');
    end;
  end;
  //20180424 Igor <<<
end;

constructor TMyChildT4T5_2026.CreateNew(AOwner: TComponent; RNo: Integer);
Var {MyPanel1,MyPanel2:TPanel;}MyBevel1:TBevel;
  j: Integer; //20160519 Igor
begin
  inherited;
  FormClass := TFormT4T5_2026;
 Caption:= GetReturnCaption(RetNo);
 Color:=GetRetColor(RetNo); //$00AC7400; //GetRetColor(RetNo);
 Name:='R'+IntToStr(RetNo);

 FMyFormHeaderFrame := THeaderFrameT4T5_2026.Create(self);
 with MyFormHeaderFrame do
 begin
  Name:='P2';
  Parent:=self; //MyPageControl;
  MyChild := self;
  Height:=25; //30;
  Align:=alTop;
  Color:=$00AC7400; //GetRetColor(RetNo);  //$00AC7400;
  //20160519 Igor >>>
  ParentBackGround := False;
  for J := 0 to ComponentCount - 1 do
  Begin
    if Components[j] is TPanel then
      (Components[j] as TPanel).ParentBackground := False;
  End;
  //20160519 Igor <<<

  //ReturnNameLbl.Caption := '[Un-Named return]';
 end;

 FMyMonitorFrame := TMonitorFrameT4T5_2026.Create(self);
 With MyMonitorFrame do
 begin
  Parent:=self;
  Height:=23;
  Align:=alBottom;
  //20160519 Igor >>>
  ParentBackGround := False;
  for J := 0 to ComponentCount - 1 do
  Begin
    if Components[j] is TPanel then
      (Components[j] as TPanel).ParentBackground := False;
  End;
  //20160519 Igor <<<
 end;
 //UpdateChildTaxPanel; - not now
end;

procedure TMyChildT4T5_2026.FormPaint(Sender: TObject);
Var
 i:integer;
begin
  Caption:=GetReturnCaption(RetNo);
end;

function TMyChildT4T5_2026.GetHeaderFrame: TFrame; //20160227 Igor
begin
  Result := MyFormHeaderFrame;
end;

function TMyChildT4T5_2026.GetMonitorFrame: TFrame;  //20160227 Igor
begin
  Result := MyMonitorFrame;
end;

Procedure TMyChildT4T5_2026.UpdateChildTaxPanel;
begin
  if RetNo < 1 then exit; //wait for valid RetNo

 FormatSettings.DecimalSeparator:='.';  //20150805 Igor
 With MyMonitorFrame do
 begin
    BalancePanel.Color   := GetRetColor(RetNo);
{TODO -oIgor : Make Total calc}
{
    TotIncPanel.Caption  := FormatFloat('##,###,###.00',Vl(FetchElm(RetNo,'T3',126)));
    TotIncBfrPanel.Caption  := FormatFloat('##,###,###.00',Vl(FetchElm(RetNo,'T3',252)));
    NetIncAftPanel.Caption  := FormatFloat('##,###,###.00',Vl(FetchElm(RetNo,'T3',254)));
    TxblIncPanel.Caption := FormatFloat('##,###,###.00',Vl(FetchElm(RetNo,'T3',272)));

    If Vl(FetchElm(RetNo,'T3',324)) <0 then
     begin
      BalanceLbl.Caption := 'Refund';
      BalancePanel.Caption := FormatFloat('##,###,##0.00',
         ABS(Vl(FetchElm(RetNo,'T3',324))));
     end
    else
      begin
      BalanceLbl.Caption := 'Owing';
      BalancePanel.Caption := FormatFloat('##,###,##0.00',
         Vl(FetchElm(RetNo,'T3',324)));
      end;
}
 end;
end;

Procedure TMyChildT4T5_2026.Keys(Var Key: Word; Shift: TShiftState);
var
  Handled: boolean;
begin
 {PLAIN F KEYS}
  Handled := True;
  {F1, F2 are in short cut}
 // If    (Key = VK_F1) then begin MainForm.HelpBtnClick(Application);exit;end;
 // If    (Key = VK_F2) then begin MainForm.SelectFormClick(Application);exit;end;
  If    (Key = VK_F3) then MainForm.FileSaveAsItemClick(RetNo)
  else If    (Key = VK_F4) then OpenForm(RetNo,GetFormNo('TAXSUM'),0)
  else If    (Key = VK_F5) then MainForm.GuiCommand(gcToggleLeftPanel) //MainForm.LeftPanel.Visible:= Not MainForm.LeftPanel.Visible //20160222 Igor
  else If    (Key = VK_F7) then MainFormT4T5.Switchforms1Click(Application)
  else If    (Key = VK_F8) then MainFormT4T5.SwapBtnClick(Application)
  else  Handled := False;
  if Handled then begin Key := 0; exit; end;

  {CTRL 1 to 8}
  if (Shift = [ssCtrl]) then
  begin
    Handled := True;
    if      (Key = 49) then OpenForm(RetNo,GetFormNo('S1'),0)
    else if (Key = 50) then OpenForm(RetNo,GetFormNo('S2'),0)
    else if (Key = 51) then OpenForm(RetNo,GetFormNo('S3'),0)
    else if (Key = 52) then OpenForm(RetNo,GetFormNo('S4'),0)
    else if (Key = 53) then OpenForm(RetNo,GetFormNo('S5'),0)
    else if (Key = 54) then OpenForm(RetNo,GetFormNo('S6'),0)
    else if (Key = 55) then OpenForm(RetNo,GetFormNo('S7'),0)
    else if (Key = 56) then OpenForm(RetNo,GetFormNo('S8#1'),0)
    else if (Key = 57) then OpenForm(RetNo,GetFormNo('S9'),0)
    else if (Key = 89) then OpenForm(RetNo,GetFormNo('COMPSUM'),0) //Ctrl Y
    else  Handled := False;
    if Handled then begin Key := 0; exit; end;
  end; {Ctrl}

  //ALT KEYS
  If Shift = [ssAlt] then
  begin
    Handled := True;
    If Key = 83 then MainFormT4T5.SwapReturns1Click(Application) {Alt S}
    else if Key = 88 then MainFormT4T5.FileCloseItemClick(Application) {Alt x}
    else  Handled := False;
    if Handled then begin Key := 0; exit; end;
  end; {Alt keys}

  inherited;
end;

Procedure TMyChildT4T5_2026.UpdateFormHeaderFrame;
var
 FormInfo:String;
begin

 if not UpdateSectionButtons(MyFormHeaderFrame) then exit;
 FormInfo:=AllTrim(GetFormAbrevName(FormNo));
 //MyFormHeaderFrame.ReturnNameLbl.Caption:=NmInfo;
 MyFormHeaderFrame.FormNameLbl.Caption:=' '+FormInfo;
end;

procedure TMyChildT4T5_2026.CloseActiveForm(Sender: TObject);
Var j:Integer;
begin
  If MyPageControl.PageCount <2 then
   begin
   ShowMessage('You cannot close the last form'
    +Chr(13)+'You can close the file instead. Click the Close button');
   Exit;
  end;
  inherited;
end;


Function TFormT4T5_2026.GetValueFromList(MyEditBox:TvtEdit;FieldId:Integer):String;
Var I : integer;TempList:TStringList;FromFname:String;FromElm:Integer;
   s,TempString:String;
   //WList:TstringList;
begin
  Result :='';
 //populate the picklist
  SomeList.Clear; // := TStringList.Create;
//  SomeList := TStringList.Create;
  SomeCaption := 'Valid entries';
  Result:=PopulatePickList(FieldId{,Somelist});

 (*
  If (FormName='T5013FIN') and (FieldId=2) then exit;  //20140320

  // If ExtractNonInstFormName(FormName)='T1ADJ' then Exit;
  //nisa done another way via usearchlist
  If (ExtractNonInstFormName(FormName)='T1273_1')
  Or (ExtractNonInstFormName(FormName)='T1273_2')
  or (ExtractNonInstFormName(FormName)='NISAA_2')
  or (ExtractNonInstFormName(FormName)='T1273_3')
  or (ExtractNonInstFormName(FormName)='NISAA_3')
  or (ExtractNonInstFormName(FormName)='T1273_4')

  or (ExtractNonInstFormName(FormName)='T1273_5')
  or (ExtractNonInstFormName(FormName)='T1273_6')
  or (ExtractNonInstFormName(FormName)='T1273_7')
  or (ExtractNonInstFormName(FormName)='T1273CIV')
  or (ExtractNonInstFormName(FormName)='T1273LIV')
  or (ExtractNonInstFormName(FormName)='T1273ALI')
  or (ExtractNonInstFormName(FormName)='T1273OTH')
  then begin SelectedString:=Result;exit;end;
  *)
  SelectedString := PopSomeList(SomeList,SomeCaption, MyEditBox);
  //SomeList.Free; //abends
  result:=CleanUpPickedListValue(FieldId,SelectedString);   //20170903 CON  Why?
  SelectedString:=Result;  //??
end;


Function TFormT4T5_2026.GetLinkedForm(FieldId:Integer;Var TargetLinkedField:Integer):String;
Var
  I, j, Fld: integer;
  Frm, InFrm: string; //[10];
  LinkList: TstringList;
  Wlist: TStringList;
  s: String;
begin
  Result := '';
  TargetLinkedField:=0;
  LinkList := TStringList.Create;
  //20170515 igor >>>
  try
  //20170515 Igor <<<
    Linklist.LoadFromFile(Appdir+'\'+'LINKLIST.D');
    InFrm := Rtrim(ExtractNonInstFormName(FormName));

    //multiple linked forms
    WList:=TStringList.Create;
    //20170515 Iogr >>>
    try
    //20170515 Igor <<<
      For i :=0 to LinkList.Count -1 do
      begin
        Frm   := RTrim(ExtractNonInstFormName(LeftStr(LinkList[i],10)));
        If InFrm = Frm then
        begin
          Fld   := MyStrToInt(MidStr(LinkList[i],11,3));
          If Fld = FieldId then
          begin
            s:=AllTrim(MidStr(LinkList[i],15,80));
            ParseWords(S,',',WList);
            If Wlist.Count=1 then  {just one linked form}
            begin
              //wordformat is fffffff#n/5
              If ExtractFormInst(Rtrim(InFrm)) > '' then
                Result :=ExtractFormSlashField(WList[0],TargetLinkedField)+ExtractFormInst(Rtrim(FormName))
                      //Rtrim(ExtractNonInstFormName(LeftStr(WList[0],10)))
              else
                Result :=ExtractFormSlashField(WList[0],TargetLinkedField);
              If Result = '?PRVT3' then
                Result :=WhichTaxForm(RetNo,Ret[RetNo].Province);
              //20170515 Igor >>>
              //LinkList.Free;
              //WList.Free;
              //20170515 Igor <<<
              exit;
            end //end single link
            Else
            If Wlist.Count>1 then
            begin
              SomeList.Clear;  // := TStringList.Create;
              SomeCaption := 'Select from Linked forms';
              For j:=0 to WList.Count-1 do
                SomeList.Add(PaddR(WList[j],20)+GetFormAbrevNameWithNoInst(GetFormNo(WList[j])));
              SelectedString := PopSomeList(SomeList,SomeCaption);

              If SelectedString > '' then
              begin
                Result:=AllTrim(LeftStr(SelectedString,20));
                //20170515  Igor >>>
                //LinkList.Free;
                //WList.Free;
                //20170515 Igor <<<
                exit;
              end;
            end;
          end; //matching fieldid
        end; //found entry
      end;
    //20170515 Igore >>>
    finally
      WList.Free;
    end;
    //20170515 Igore <<<
    //nothing found
    UserMsg('nothing linked to '+InFrm+'.vtEdit'+IntToStr(FieldId));
  //20170515 Igore >>>
  finally
    LinkList.Free;
  end;
  //20170515 Igore <<<

end;

Function TFormT4T5_2026.PopulatePickList(FieldId:Integer{;SomeList:TStrings}):String; //20160227 Igor
Var i:Integer;s,FromFname:String[10];FromElm:Integer; TempList:TstringList;
begin
   Result:='';
   //20170903
   If (FormName = 'EMPL') then
   begin
    case FieldId of
      4:for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
      6:SomeList.LoadFromFile(AppDir+'\'+'FCountry.d');
      18:SomeList.LoadFromFile(AppDir+'\'+'TaxCenters.d');
      17,39,40:SomeList.LoadFromFile(AppDir+'\'+'T4Status.d');
    end; //case
   end;

   If (LeftStr(FormName,3) = 'T4#') then
   begin
    case FieldId of
      6, 17:for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
      10:SomeList.LoadFromFile(AppDir+'\'+'T4EmplCodes.d');
      30,32,34,36,38,40:SomeList.LoadFromFile(AppDir+'\'+'T4Codes.d'); //'T4Boxes.d'); //20241221
      43:SomeList.LoadFromFile(AppDir+'\'+'FCountry.d');  //20171223
      //20231217
      49:
       Begin
        SomeList.Add('1 Not eligible to access any dental care insurance');
        SomeList.Add('2 Payee only');
        SomeList.Add('3 Payee, spouse and dependent children');
        SomeList.Add('4 Payee and their spouse');
        SomeList.Add('5 Payee and their dependent children');
       End;
    end; //case
   end;
   //20170910
   If (LeftStr(FormName,4) = 'T4A#') then
   begin
    case FieldId of
      11:for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
      20,22,24,26,28,30,32,34,36,38,40,42:SomeList.LoadFromFile(AppDir+'\'+'T4ACodes.d'); //20180104
      13:SomeList.LoadFromFile(AppDir+'\'+'FCountry.d'); //20200302 relocated from 2nd position
      45:  //20231217
       Begin
        SomeList.Add('1 Not eligible to access any dental care insurance');
        SomeList.Add('2 Payee only');
        SomeList.Add('3 Payee, spouse and dependent children');
        SomeList.Add('4 Payee and their spouse');
        SomeList.Add('5 Payee and their dependent children');
       End;
    end; //case
   end;

   //20170910
   If (LeftStr(FormName,3) = 'T5#') then
   begin
    case FieldId of
      //20180103
      13,15,17:
      Begin
       SomeList.Add('14 Other income from Canadian source');
       SomeList.Add('15 Foreign income');
       SomeList.Add('16 Foreign tax paid');
       SomeList.Add('17 Royalties from Canadian sources');
       SomeList.Add('19 Accrued income:Annuities');
       SomeList.Add('30 Equity linked notes interest');
       SomeList.Add('34 Capital gains dividends Period 1-Before June 25,2024'); //20241221
       SomeList.Add('18 Capital gains dividends Period 2-After June 24, 2024'); //20241221
      End;
      22:for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
      29:  //20180103
      Begin
       SomeList.Add('USD – United States, dollar');
       SomeList.Add('JPY – Japan, yen');
       SomeList.Add('HKD – Hong Kong, dollar');
       SomeList.Add('AUD – Australia, dollar');
       SomeList.Add('NZD – New Zealand, dollar');
       SomeList.Add('DKK – Denmark, krone');
       SomeList.Add('GBP – United Kingdom, pound');
       SomeList.Add('EUR – European Union, euro');
       SomeList.Add('OTH – Other');
      End;
      32:SomeList.LoadFromFile(AppDir+'\'+'FCountry.d');
      10:
      Begin
       SomeList.Add('O Original');
       SomeList.Add('A Amended');
       SomeList.Add('C Cancelled');   //20171209  //20180322
      End;
      12: //recipient type
      Begin
       SomeList.Add('1 Individual');
       SomeList.Add('2 Joint Account');
       SomeList.Add('3 Corporation');
       SomeList.Add('4 Asociation, Trust, Other');
       SomeList.Add('5 Government');
      end;
      //13,15,17:SomeList.LoadFromFile(AppDir+'\'+'T5Codes.d');
    end; //case
   end;

  (* //20170721
   If (FormName = 'T3') then
   begin
    case FieldId of
      11:SomeList.LoadFromFile(AppDir+'\'+'Country.d');
      9: for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvLong[i]);
      81: If FetchElm(RetNo,'T3',79)>'' then SomeList.LoadFromFile(AppDir+'\'+'TrustType.d');   //20160130
    end; //case
   end;
 *)
end; //function

function TFormT4T5_2026.AllowEditVertSeparator: Boolean;//20171226 Igor
begin
  Result := True;
end;

Function TFormT4T5_2026.CleanUpPickedListValue(FieldId:Integer;SelectedString:String):string; //20160227 Igor
Var TempS:String;
Begin
  Result := SelectedString;

  If FormName = 'EMPL' then  //20170910
  Begin
   Case FieldId of 6: result := LeftStr(SelectedString,3); End;
  End;

  If LeftStr(FormName,3) = 'T4#' then
  Begin
   Case FieldId of 10,30,32,34,36,38,40:  //20231217
    Begin
     result := LeftStr(SelectedString,2);
     If Not Numeric(result) then result:='';
    End;
   End;//case end
   Case FieldId of 49:Begin result := LeftStr(SelectedString,1); End; End;//case end //20231217
   Case FieldId of 43:Begin result := LeftStr(SelectedString,3); End; End;//case end
  End;

 //20170910
 If LeftStr(FormName,4) = 'T4A#' then
  Begin
   Case FieldId of 20,22,24,26,28,30,32,34,36,38,40,42:
    Begin
     result := LeftStr(SelectedString,3);
     If Not Numeric(result) then result:='';
    End;
   End;//case end
   Case FieldId of 13:  //country
    Begin
     result := LeftStr(SelectedString,3);
     //If Not Numeric(result) then result:='';
    End;
   End;//case end
   Case FieldId of 45:Begin result := LeftStr(SelectedString,1); End; End;//case end //20231217
  End;

 //20170910
  If LeftStr(FormName,3) = 'T5#' then
  Begin
   Case FieldId of 13,15,17: result := LeftStr(SelectedString,2); End;//case end //20180103
   Case FieldId of 29,32: result := LeftStr(SelectedString,3); End;//case end //20180103
   Case FieldId of 10,12: result := LeftStr(SelectedString,1); End;
  End;

end;


procedure TMyChildT4T5_2026.FormContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  exit;
end;

procedure TFormT4T5_2026.FormatEditBoxText(MyEditBox: TvtEdit; str: string);
begin
  inherited;
  MyEditBox.Font.Name:='Arial Narrow';  //20131225
end;

Procedure TFormT4T5_2026.FormatDollar(MyEditBox: TvtEdit; str: string);
var
  HowToFormat: integer;
begin
  FormatSettings.DecimalSeparator := '.'; //20150805 Igor
  If Vl(str) = 0 then
    MyEditBox.Text := '' //20160808 Igor
     // MyEditBox.Text:='0'   //20130421
  else
  begin
    HowToFormat :=GetHowToFormat(FormName,MyEditBox.FieldId);
    MyEditBox.Text:=FormatAmount(FormName,str,HowToFormat);
  end;
  MyEditBox.Modified := True;
end;

Procedure TFormT4T5_2026.ShowFieldData(MyEditBox:TvtEdit);
Var
  fld:Integer;
  //R:TRect;FormattedAmount:string; //[15];ErrMsg:String;
  //EditBoxColr:TColor;
Begin
  inherited;
  {
  If GetFormType(FormName) ='T3' then
  begin
   If Vl(FetchElm(RetNo,'T3',201))>999999 then MyEditBox.Font.size:=8;  //20090220
  end;
  }
end;


procedure TFormT4T5_2026.EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
Var
  FieldId:Integer;
  vis: boolean;
begin
  If Button = mbLeft then
  begin
    inherited;
  End  //MbLeft
  else
  If Button = mbRight then
  begin
   //set right click focus - john 20090521
   MyEditBox.setfocus;
   MyEditBox.Refresh;
   FieldId:=MyEditBox.FieldId;

  with MainFormT4T5 do
  begin
//configure menu
    vis := FieldId >9999;
    AddRow1.Visible := vis;
    DeleteRow1.Visible := vis;  //SomeList.Add('Delete Row');
    DeleteRow2.Visible := vis;  //SomeList.Add('------------------------');
//show menu
    FieldPopup.PopupComponent := MyEditBox;
  //pos must be in screen coordinates
    FieldPopup.Popup(mouse.CursorPos.x, mouse.CursorPos.y);
  end; //with
 end;  {mbright}
end;

//keep!
Function AskingForSICCode(FormName:String;FieldId:Integer):boolean;
begin
  result := false;
  If ((ExtractNonInstFormName(FormName) = 'T2125') and (FieldId = 12))
  or
  ((ExtractNonInstFormName(FormName) = 'T2032_1') and (FieldId = 15))
  or
  ((ExtractNonInstFormName(FormName) = 'T2121') and (FieldId = 11))
  or
  ((ExtractNonInstFormName(FormName) = 'T2042') and (FieldId = 17))
  or
  ((ExtractNonInstFormName(FormName) = 'NISAA_1') and (FieldId = 34))
  or
  ((ExtractNonInstFormName(FormName) = 'T1273_1') and (FieldId = 34))
  or
  ((ExtractNonInstFormName(FormName) = 'T5011') and (FieldId = 2))
  then
  result := true;
end;

procedure TFormT4T5_2026.OnVtEditDblClick(MyEditBox:TvtEdit);
Var i:Integer;FName:string;
    NewString: String;
    FieldId, TargetLinkedField:Integer;
    P: TWinControl; //20160805 Igor
begin
  FieldId:=MyEditBox.FieldId;

  //20160710 Igor
  if MyEditBox.ReadOnly then exit;
  if not assigned(RetList[RetNo]) then exit;
  if RetList[RetNo].isLastYearReturn or
     RetList[RetNo].isAppendix then exit;

  if MyEditBox.vtDataSource = vtLinked then
  begin
    FName :=GetLinkedForm(FieldId,TargetLinkedField);
    //20170621 Igor >>>
    //if linkToSelf(FormName,FName)then
    //  ShowTimedMsg('Hit the Spacebar to link',1200)
    //else
    //20170621 Iogr <<<
    If FName > '' then
      OpenForm(RetNo,GetFormNo(Fname),TargetLinkedField);
    exit;
  end;

  if MyEditBox.vtDataSource = vtPopupList then   //pick boxes
  begin
   If AskingForSicCode(FormName,FieldId) then
    GetSicCode(FieldId)
   else
    GetValueFromList(MyEditBox,FieldId);
   //GetValueFromList(MyEditBox,FormName,FieldId);
   //GetValueFromPopUp(MyScrollBox,MyEditBox,FormName,FieldId);
   If SelectedString >'' then
   begin
     If IsReturnLocked(RetNo) = False then
     Begin
      ChangeEditBoxText(MyEditBox,SelectedString);
      //SaveEditBoxText(FormNo,FieldId,MyEditBox.Text);
      //20160805 Igor >>>
      UpdateAfterSave;
      P := Self.Parent;
      while Assigned(P) AND not(P is TForm) do
        P := P.Parent;
      if assigned(P) then
        PostMessage(P.Handle, WM_NEXTDLGCTL, 0, 0)
      else
        PostMessage(Self.Handle, WM_NEXTDLGCTL, 0, 0)
      //20160805 Igor <<<
     end
     Else
      ShowTimedMsg('Changes not allowed. Return is locked',1500);
     Exit;
   end;
  End;
end;


Procedure TFormT4T5_2026.DataChangeRtn;
begin
  Ret[RetNo].Changed := True;
  {save instance data}
  Calc(Retno,FormName);  //20150729  //Calc(Retno,FormName,FormNo);
  CalcAffectedBy(RetNo,FormName);
  If IsFormMultipage(FormName) then CalcMultiPageForm(RetNo,FormName);

  If ToolBarSw then
  begin
   CalcAll(RetNo);
   Ret[Retno].CalcStatus := True;
  end
  Else
    Ret[Retno].CalcStatus := False;
end;

Function GetReturnCaption(RetNo:Integer):String;
Var YrPrefix:String;RetName:String;
begin
  YrPrefix:='';
  RetName:=GetRetName(RetNo);
  If RetName='' then RetName:= 'Un-named';
  //Result:=PaddR(PaddZero(IntToStr(RetNo),2),2)+' '+YrPrefix+' '+CorpName;
  Result:=PaddR(PaddZero(IntToStr(RetNo),2),2)+' '+RetName;
   // +' Y/E: '+IntToStr(GetTaxationYearEndYYYY(RetNo));
end;


procedure TFormT4T5_2026.ShowRichData(ARichEdit: TRichEdit; Fld: Integer);
//Procedure TMyChildT4T5_2026.ShowInterpretedRichData(ARichEdit:TRichEdit;FName:String;FNo:Integer);
Var i:Integer; LetterName:String;
  AImage:TImage;
begin
 If IsFormAClientLetter(FormName)  AND (ARichEdit.parent <> nil) then //20160223 Igor
 begin
  LetterName:=GetLetterFileName(RetNo,FormName);
  If FileExists(LetterName) then
  begin
    GetInterpetedRichEdit(RetNo,LetterName,ARichEdit);
    exit;
  end;
 end; //CLetter
 inherited;
end;

procedure TFormT4T5_2026.GetSICCode(FieldId:Integer);
begin
  If AskingForSicCode(FormName,FieldId) then
   begin
    MainFormT4T5.NAICSCodes1Click(Application);
    If Numeric(SelectedString) then
      ReplaceString(FieldId,SelectedString);
    exit;
   end;
end;

Function SubstituteLastYearForm(FName: String): String; //20160629 Igor
Begin
  Result:=GetRenamedFName(FName);
  if Result = '' then
    Result:=Fname;
end;

end.


