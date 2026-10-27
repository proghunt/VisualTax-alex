unit TF_2026ChildWinNew;
(* see vtChild for documentation
*)

interface

uses SysUtils,WinTypes,WinProcs,Classes,Graphics,Forms,Controls,TabNotBk,
  StdCtrls,ExtCtrls,Tabs,Menus,Grids,Dialogs,ColorGrd,ClipBrd,Gauges,Mask,
  DBCtrls,Printers,Messages,shellApi,Buttons,ComCtrls,vtEditBox,vtLabel,vtShape,
  vtChild,vtForm,  TF_2026HeaderFrame,
  TF_2026MonitorFrame,
  TypInfo,
  TF_2026CalcT5013,  //202600908
  rxRichEd; //20160819 Igor (Must be last)

type
  TFormTF_2026 = class(TvtScrollBox)
  private
    function PopulatePickList(FieldId: Integer{;
      SomeList: TStrings}): String;
    function CleanUpPickedListValue(FieldId: Integer;
      SelectedString: String): string;
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
      //Procedure ShowInterpretedRichData(ARichEdit:TwwDbRichEdit;FName:String;FNo:Integer);
    //Procedure ShowFormData(FName:String;FNo:Integer); override;
    //procedure ShowOther(cmp: TComponent); override;
    function ValidateField(FieldId: integer; OldValue: string; var Value: string): boolean; override; //20260704 Alex
  protected //handlers
    procedure FormButtonClick(Sender: TObject); override;
    procedure EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
    procedure OnVtEditDblClick(MyEditBox:TvtEdit); override;
  end;

  TMyChildTF_2026 = class(TMyChild)
  public
    procedure FormPaint(Sender: TObject);

    procedure CloseActiveForm(Sender: TObject); override;
  private
    FMyFormHeaderFrame: THeaderFrameTF_2026;
    FMyMonitorFrame: TMonitorFrameTF_2026;
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
    property MyMonitorFrame:TMonitorFrameTF_2026 read FMyMonitorFrame;
    property MyFormHeaderFrame:THeaderFrameTF_2026 read FMyFormHeaderFrame;
  end;

  //known to all
  function InDateOnly(Value: string; MxYear: Integer): Boolean; // 20250812 Igor
  function IsPartnershipACCValid(Value: string): Boolean; // 20250812 Igor
  function InDateYYYYMMDDonly(Value:string;MxYear: integer):Boolean;
  //Function InT5013DateYYYYMMDDonly(Value:string;MxYear:integer):Boolean;

  function BeforeOpenForm(RetNo: Integer;var FName: string; var FNo: integer): string;
  function GetDFMFileName(FName:String):String;
  function GetLastYearDFMFileName(FName:String):String; //20160321 Igor
  function GetReturnCaption(RetNo:Integer):String;
  function SubstituteLastYearForm(FName: String): String; //20160629 Igor

var //force compiler errors
  MyChildTF_2026: boolean; //TMyChild;
  RetNo:boolean;

implementation
{--- $R *.DFM}

uses
  vtCommon, vtDialogs, vtMain, TF_2026, TF_2026Common, TF_2026Common2,
  TF_2026TrimStr, TF_2026Calc, TF_2026SaveAs, TF_2026Declare, TF_2026SearchList,
  TF_2026RichForm, TF_2026CntErr, TF_2026main, TF_2026Print, TF_2026SIC, vtDynData, TF_2026EfileT1134, //20260817 Alex
  vtTrimStr, vtShared, vtMulti, TF_2026internetfrm, TF_2026SERS; //20240703 Igor

//keep (here, local)
procedure ShowMessage(msg: string);
begin
  UserMsg(msg);
end;

Procedure TMyChildTF_2026.ChildMsgHandler(var Msg: TMsg; Var Handled:Boolean);
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

// 20250812 Igor >>>
function InDateOnly(Value: string; MxYear: Integer): Boolean;
begin
  Result:= EditT3Date(Value, MxYear);

  if not Result then
     ShowMessage('Invalid Date (YYYY-MM-DD) or out of range');
end;

function IsPartnershipACCValid(Value: string): Boolean;
begin
  if (Length(Value) > 0) then
  begin
    Result:= False;

    if Length(Value) < 15 then
    begin
      ShowMessage('Invalid Business number or partnership account number length. Format NNNNNNNNNRZNNNN or NNNNNNNNNRCNNNN.');
      Exit;
    end;

    Result:= (Value[10] = 'R') and ((Value[11] = 'Z') or (Value[11] = 'C'));

    if not Result then
      ShowMessage('Invalid Business number or partnership account number. Format NNNNNNNNNRZNNNN or NNNNNNNNNRCNNNN.');
  end else
    Result:= True;
end;
// 20250812 Igor <<<

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

//20260220 Igor >>>
function InT5013FINDateYYYYMMDDonly(aValue: string; aMxYear, aRetNo: Integer; aFormName: string; aFieldId: Integer): Boolean;
var
  i: Integer;
  s: string;
begin
  Result:= true;
  s:= aValue;

  if s.IsEmpty then Exit;

  if (s[5] <> '-') or (s[8] <> '-') or (not InNumRange(RightStr(s, 2), 01, 31)) or not InNumRange(MidStr(s, 6, 2), 01, 12) or not InNumRange(LeftStr(s, 4), 1880, aMxYear) or (Vl(LeftStr(s, 4)) > aMxYear) then
  begin
    ShowMessage('Invalid Date or out of range');
    Result:= False;
  end;
end;
//20260220 Igor <<<

procedure TMyChildTF_2026.addPropertiesAndEvents;
begin
  inherited;
 VertScrollBar.Tracking := True;
 HorzScrollBar.Tracking := True;
 VertScrollBar.Position:=0;
 KeyPreview:=True;
 OnKeyDown := FormKeyDown;
 OnKeyPress := FormKeyPress;
//install for use by vtScrollBox
  PopupMenu := MainFormTF.FormPopup;
  OnContextPopup := FormContextPopup;
end;


Function BeforeOpenForm(RetNo: Integer;var FName: string; var FNo: integer): string;
//Function OpenForm(RetNo: Integer;FNo: integer;Elm:Integer): boolean;
Var
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
    FName := AppTF_2026.FirstForm; //'T3'
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

  //20260816cz
  if IsEnterPriseForm(Fname) =True then //special Ekections) then
  Begin
   // ShowMessage('This form is available only on the Enterprise version of the program');
   // If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'B0865' then exit;     //20260821
  End;


  //Result := True;
  If Ret[RetNo].Frm[FNo].count =0 then InitFormData(RetNo,FNo); //here?
end;

procedure TFormTF_2026.PopulateFormWithData;
begin
  If IsFormAClientLetter(FormName) then
    Color:=clWhite;
  inherited;
end;

procedure TFormTF_2026.FormButtonClick(Sender: TObject);
Var Nm:String;ARichEdit:TRichEdit;FirstFieldId:Integer;
begin
 Nm:=UpperCase((Sender as TbitBtn).Name);  //button name

 If LeftStr(FormName,5)='PS50#' then  //20120303
 begin
  MainFormTF.T5013PartnersS501Click(Sender);
 end;

 //20240703 Igor >>
 If LeftStr(FormName, 5) = 'T2057' then
 begin
   if nm = UpperCase('T2057EfileBtn') then
   begin
     with TfrmSERS2023.Create(Self, FormName) do
     try
       ShowModal;
     finally
       Free;
     end;
   end;
 end;
 //20240703 Igor <<

 If FormName='TESTFRM' then
 begin
 {$IFDEF dynamic}
  If Nm='ADDROWBTN' then
  begin
   MyScrollbox:=GetScrollbox(FormName);
   FirstFieldId:=10001;
   PushComponentsUpOrDown(MyScrollBox,GetYPosOfFirstDynamicRow(MyScrollBox,Formname,FirstFieldId),14);
  end;
  If Nm='REMOVEROWBTN' then
  begin
   MyScrollbox:=GetScrollbox(FormName);
   PushComponentsUpOrDown(MyScrollBox,GetYPosOfFirstDynamicRow(MyScrollBox,Formname,10001),-14);
  end;
 {$ELSE}
 {$ENDIF}
 end;

 If LeftStr(FormName,5)='PS50#' then  //20260908
 Begin
  If Nm='PREPARET5013SLIPSBTN' then
  begin
    PrepareAllT5013Slips(RetNo);
    Exit;
  end;
 end;



 //20170623
 If FormName='T1OVP' then
 begin
  If nm='RRSPGUIDEBTN' then
  begin
     //20170305
     ConnectToWeb('http://www.cra-arc.gc.ca/E/pub/tg/t4040/t4040-16e.pdf');
     Exit;
  end;
 end;

 If (FormName='T106') //20240314
 Or (leftStr(Formname,7)='T106SL#')
 then  //20170728
 Begin
  If Nm='T106INSTRUCTIONSBTN' then ShowPdf(AppDir, 'T106SLIPI.pdf'); // 20240314
 end;

 //20180210
 If LeftStr(FormName,5)='T1135' then
 begin
  If nm='T1135IBTN' then
  begin
   ShowPdf(AppDir,'t1135i.pdf');  //20150105
  end;

  //20180422
  If Nm='T1135EFILEBTN' then
  begin
   ShowMessage('Currently available only for Paper-Filing');
  end;

 end;

 //20170325
 If FormName='T3DON' then
 begin
  If nm='S11ABTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('S11A'),0);
     Exit;
  end;
 end;


 If FormName='GST20' then
 begin
  If nm='GST20IBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('GST20I'),1);
     Exit;
  end;
 end;

//20210110
 If LeftStr(FormName,7)='NR4DET#' then
 begin
  If nm='NR4CRAGUIDEBTN' then
  begin
    //ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/forms-publications/publications/t4061.html');
    ConnectToWeb('https://www.canada.ca/content/dam/cra-arc/formspubs/pub/t4061/t4061-21e.pdf'); //20200112
    Exit;
  end;
  If nm='NR4SUMBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('NR4SUM'),1);
     Exit;
  end;
 end;

 If FormName='NR4SUM' then
 begin
  If nm='NR4CRAGUIDEBTN' then
  begin
   // ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/forms-publications/publications/t4061.html');
   ConnectToWeb('https://www.canada.ca/content/dam/cra-arc/formspubs/pub/t4061/t4061-21e.pdf'); //20200112
     Exit;
  end;
  If nm='NR4BTN' then  //20180210
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('NR4DET#1'),1);
     Exit;
  end;
 end;

 If LeftStr(FormName,6)='T1013#' then
 begin
  If nm='T1013IBTN' then
  begin
     ShowPdf(AppDir,'T1013I.pdf');
   //  OpenForm(GetCurrentRetNo,GetFormNo('T1013I'),1);   //20150205
     Exit;
  end;
 end;

 If FormName='T5018S' then  //20150228
  begin
     If nm='T5018IBTN' then ShowPdf(AppDir,'T5018I.pdf');
     Exit;
  end;

 If LeftStr(FormName,7)='T5018L#' then
  begin
     If nm='T5018SBTN' then OpenForm(GetCurrentRetNo,GetFormNo('T5018S'),1);
     Exit;
  end;

 If LeftStr(FormName,4)='NR6#' then
 begin
  If Nm='NR6INSTRBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('NR6INSTR'),0);
     Exit;
   end;
 end;

 If FormName='S11' then
 begin
  If Nm='T3DONBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('T3DON'),0);
     Exit;
   end;
 end;

 If LeftStr(FormName,7)='INVSTM#' then
 begin
  If Nm='FINVSTMBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('FINVSTM'),1);
     Exit;
   end;
  If nm='T3INCOMEBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T3INCOME#1'),1);
     Exit;
   end;
  If nm='T5INCOMEBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T5INCOME#1'),1);
     Exit;
  end;
  If nm='T5013INCBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T5013INC#1'),1);
     Exit;
   end;
 end;

 If LeftStr(FormName,7)='FINVSTM' then
 begin
  If nm='T3INCOMEBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T3INCOME#1'),1);
     Exit;
   end;

  If nm='T5INCOMEBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T5INCOME#1'),1);
     Exit;
  end;

  If nm='T5013INCBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T5013INC#1'),1);
     Exit;
   end;

 end;

 If LeftStr(FormName,9)='T5013INC#' then
 begin
  If Nm='POLITBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('POLIT'),1);
     Exit;
   end;

   If Nm='T2038BTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('T2038'),1);
     Exit;
   end;

 end;


 If LeftStr(FormName,7)='T3SUPL#' then
 begin
  If Nm='AVLBLEBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('AVLBLE'),1);
     Exit;
   end;
 end;

 If (LeftStr(FormName,6)='T5013#') then
 begin
  If Nm='PRINTT5013BTN' then
  begin
     MainFormTF.T5013Slips1Click(Application);
     Exit;
  end;

  If Nm='PS50BTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('PS50#1'),1);
     Exit;
  end;

  If Nm='T5013WSBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T5013WS'),1);
     Exit;
  end;

  If Nm='T5013FINBTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('T5013FIN'),1);
     Exit;
  end;


  If Nm='T5013INSTBTN' then
  begin
     ShowPdf(AppDir,'T5013-inst-20e.pdf');  //20210326
     Exit;
  end;

 end;

 If LeftStr(FormName,6)='T5015#' then
 begin
  If Nm='PS50BTN' then
  begin
     OpenForm(GetCurrentRetNo,GetFormNo('PS50#1'),1);
     Exit;
  end;
 end;

 If FormName='T5013WS' then
 begin
  If Nm='T5013INSTBTN' then
   begin
     ShowPdf(AppDir,'T5013-inst-13e.pdf');
     Exit;
   end;
 end;


 If (LeftStr(FormName,5)='PS100')
 Or (LeftStr(FormName,6)='PS125#') then
 begin
  If Nm='GIFIGUIDEBTN' then
   begin
     ShowPdf(AppDir,'RC4088-15e.pdf');
     Exit;
   end;
 end;


 If FormName='T3SUM' then
 begin
  If Nm='T3SUM2BTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('T3SUM2'),1);
     Exit;
   end;
 end;


 If FormName='S9' then
 begin
  If Nm='BENEFICIARIESBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('T3SUPL#1'),1);
     Exit;
   end;
 end;

 If FormName='T5013SUM' then
 begin
  {
  If Nm='POTHINFOBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('POTHINFO'),0);
     Exit;
   end;
  }
 If Nm='PS2BTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('PS2#1'),0);
     Exit;
   end;

  If Nm='PS6BTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('PS6'),0);
     Exit;
   end;
  If Nm='PS8BTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('PS8#1'),0);
     Exit;
   end;
  If Nm='PS12BTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('PS12'),0);
     Exit;
   end;
  {
  If Nm='POTHINFOBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('POTHINFO'),0);
     Exit;
   end;
   }
 end;

 If FormName='T661' then
 begin
  If Nm='T661FBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('T661F#1'),0);
     Exit;
   end;
 end;

 If IsFormAClientLetter(FormName) then
 begin
  If Nm='LETTERDESIGNBTN' then
  begin
   MainFormTF.ClientLetter1Click(Sender);
   OpenForm(GetCurrentRetNo,GetFormNo(FormName),1);
  end;
  If Nm='PRINTLETTERBTN' then MainFormTF.CurrentPage1Click(Sender);
 end;

 If FormName='COMPSUM' then
 begin
  If Nm='BUILDCOMPSUMBTN' then
  begin
   //MainForm.Builda5yearsummaryFromVisualTax1Click(Application);
   Exit;
  end;
 end;

 If FormName='T661' then
 begin
  If Nm='S30BTN' then
   begin
     OpenForm(RetNo,GetFormNo('S30#1'),0);
     Exit;
   end;
 end;

 If FormName='T661' then
 begin
  If Nm='T661FBTN' then
   begin
     OpenForm(RetNo,GetFormNo('T661F#1'),0);
     Exit;
   end;
 end;

  //20250603 Igor >>>
  if FormName.Equals('T3010') then
  begin
    if Nm.Equals('T3010EFILEBTN') then
    begin
      Application.CreateForm(TInternetFrmTF_2026, InternetFrm);
      InternetFrm.TypeOfReturnBtn.ItemIndex:= 3;
      InternetFrm.ShowModal;
      InternetFrm.Free;
      OpenForm(RetNo, GetFormNo('T3010'), 0);
    end;
  end;
  //20250603 Igor <<<

  //20260817 Alex >>>
  if ExtractNonInstFormName(FormName).Equals('T1134') then
  begin
    if Nm.Equals('T1134EFILEBTN') then
    begin
      if not FetchElm(RetNo, 'T1134', 26).IsEmpty  then
      Begin
        ShowMessage('This form has been already Efiled. To do it again, you must erase the Efile Confirmation Number from this form');
        Exit;
      End;

      ExecuteForm(TEfileT1134TF_2026); //20260817 Alex. TODO Nead add after efiling will be done
      Exit;
    end;
    if Nm.Equals('T1134FILLBTN') then
    begin
      ConnectToWeb('https://www.canada.ca/content/dam/cra-arc/migration/cra-arc/E/pbg/tf/t1134/t1134-fill-17e.pdf');
      Exit;
    end;
    if Nm.Equals('T1134IBTN') then
    begin
      ShowPdf(AppDir, 'T1134I.pdf');
      Exit;
    end;
    if Nm.Equals('FILLABLET1134BTN') then
    begin
      ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/forms-publications/forms/t1134.html');
      Exit;
    end;
    if Nm.Equals('T1134SLBTN') then
    begin
      OpenForm(RetNo, GetFormNo('T1134S#1'), 1);
      Exit;
    end;
  end;
  //20260817 Alex <<<
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

Function TFormTF_2026.ValidateField(FieldId: integer; OldValue: string; Var Value : string):boolean; //20260704 Alex
Var I : integer;SelectedString :string;
begin
 Result := True;
 If FormName = 'T3' then
    begin
     case FieldId of
      2:
      begin
      Result :=ValidAccount(Value);
      If result = False then ShowMessage('Invalid Account. Enter 8 digits');
      exit;
      end;

     14,17,20,54:     //20161227  //69?
      begin
       AutoFormatDate(Value);
       Result := InDateYYYYMMDDonly(Value,AppYearInt+1);
       exit;
      end;


     22,52,51:
      begin
       AutoFormatDate(Value);
       Result := InDateYYYYMMDDonly(Value,AppYearInt+1);
       exit;
      end;

     //41: begin Result :=XOnly(Value);exit;end;
     56: begin Result :=XOnly(Value);exit;end;
     end; {Case}
    end

  else if ExtractNonInstFormName(FormName) = 'T2054' then
  begin
     case FieldId of
      15,16,17:begin AutoFormatDate(Value);Result := InDateYYYYMMDDonly(Value,AppYearInt+4);exit;end;
      26,29,32,35,38:begin AutoFormatDate(Value);Result := InDateYYYYMMDDonly(Value,AppYearInt+4);exit;end;
     end; {case}
  end

  else if ExtractNonInstFormName(FormName) = 'T2057' then // 20240603
  begin
    case FieldId of
      6, 7, 35, 34, 38, 44, 39:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
          exit;
        end;
    end;
  end

  else if ExtractNonInstFormName(FormName) = 'T2059' then
  begin
    case FieldId of
      6, 7, 35, 34, 39, 44, 52, 60:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
        end;
    end;
  end


  else if ExtractNonInstFormName(FormName) = 'T1013' then
  begin
     case FieldId of
      106,112,118,124: begin Result :=InValuesOnly('1,2',Value);exit;end;
      108,114,120,126: begin Result :=InValuesOnly('1,2',Value);exit;end;
      110,116: begin Result :=InValuesOnly('1,2',Value);exit;end;
      129,131:begin AutoFormatDate(Value);Result := InDateYYYYMMDDonly(Value,AppYearInt+4);exit;end;
     end; {case}
  end

  else if ExtractNonInstFormName(FormName) = 'NR4SUM' then
  Begin
    case FieldId of
     2,24:
      Begin AutoFormatDate(Value); Result:= InDateYYYYMMDDonly(Value,AppYearInt+1);end;
    end;
  end

  else if ExtractNonInstFormName(FormName) = 'NR6' then
  begin
     case FieldId of
      15,31,78:begin AutoFormatDate(Value);Result := InDateYYYYMMDDonly(Value,AppYearInt+4);exit;end;
     end; {case}
  end

  else if ExtractNonInstFormName(FormName) = 'PS6' then  //20140101
  begin
     case FieldId of
      4,12,20,28,36:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
      46,52,58,64,70:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
      81,88,95,102,109:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
      121,129,137,145,153:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
      163,169,175,181,187:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
      197,205,213,221,229:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+30,RetNo,FormName,FieldId);exit;end;
      199,207,215,223,231:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
      241,247,253,259,265:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
      275,281,287,293,299:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
      309,315,321,327,333:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
      343,349,355,361,367:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+30,RetNo,FormName,FieldId);exit;end;
      372,380,388,396,404:begin AutoFormatT5013Date(Value);Result := InT5013DateYYYYMMDDonly(Value,AppYearInt+4,RetNo,FormName,FieldId);exit;end;
     end; {case}
  end
  // 20250812 Igor >>>
  else
  if (LeftStr(FormName, 4) = 'PS75') then
  begin
    case FieldId of
      23, 29, 35, 41, 47, 53, 173:
        begin
          AutoFormatDate(Value);
          Result:= InDateOnly(Value, AppYearInt + 10);
          exit;
        end;
      19, 59, 63, 67, 71,
      75, 151, 155, 159, 163,
      167, 190, 194, 198, 202:
        begin
          if (Length(Value) > 0) and (Length(Value) <> 9) and (Length(Value) <> 15) then
          begin
            ShowMessage('Business number, trust account number, or partnership account number should have length 9 or 15.');
            Exit;
          end;
        end;
    end;
  end else
  if (LeftStr(FormName, 4) = 'PS78') then
  begin
    case FieldId of
      6, 8, 158:
        begin
          AutoFormatDate(Value);
          Result:= InDateOnly(Value, AppYearInt + 10);
          exit;
        end;
      26, 82, 138, 257, 261,
      265, 269, 273, 277, 281,
      285, 289, 293, 297, 301:
        begin
          Result:= IsPartnershipACCValid(Value);
          Exit;
        end;
    end;
  end
  // 20250812 Igor <<<

   (*
    else if ExtractNonInstFormName(FormName) = 'ASSETSB' then
    begin
     case FieldId of
     137:
      begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(
       Value,AppYearInt+30);exit;end;
     end; {case}
    end

    else if ExtractNonInstFormName(FormName) = 'AUTOS' then
    begin
     case FieldId of
     57,60,137:
      begin AutoFormatDate(Value);
        Result := InDateYYYYMMDDOnly(Value,AppYearInt+30);exit;end;
     end; {case}
    end
   *)


  else if FormName = 'T1OVP' then
  begin
    case FieldId of
      525:begin AutoFormatDate(Value);Result := InDateYYYYMMDDonly(Value,AppYearInt+3);exit;end;
    end; {case}
  end

  else if FormName = 'T5011' then
    begin
     case FieldId of
       14,15:begin AutoFormatDate(Value);Result := InDateYYYYMMDDonly(Value,AppYearInt+3);exit;end;
     end; {case}
    end

  else if FormName = 'S5' then
    begin
     case FieldId of
       6:begin AutoFormatDate(Value);Result := InDateYYYYMMDDonly(Value,AppYearInt+3);exit;end;
     end; {case}
    end

  else if FormName = 'T2047' then
    begin
     case FieldId of
       11,12:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+10);exit;end;
     end; {Case}
    end

  else if LeftStr(FormName,6) = 'T2121#' then
    begin
     case FieldId of
       657,658,659,660,661,662:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+10);exit;end;
     end; {Case}
    end

  else if LeftStr(FormName,6) = 'T2042#' then
    begin
     case FieldId of
       757,758,759,760,761,762:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+10);exit;end;
     end; {Case}
    end

  else if FormName = 'RC145' then
    begin
     case FieldId of
       17,25,33,36,56:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'GST20' then //20140101
    begin
     case FieldId of
       15,16,24,27:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'GST25' then
    begin
     case FieldId of
       26,32:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
       101,105,107:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'GST70' then
    begin
     case FieldId of
       19,21,23:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'GST71' then
    begin
     case FieldId of
       12,13,53:
        begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
       14,15,16,17,18,19,20,21:
        begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
       22,23,24,25,26,27,28,29,30,31,32,33,34,35:
        begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
       36,37,38,39,40,41,42,43,44,45,46,47,48,49:
       begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'GST74' then
    begin
     case FieldId of
       13,15,16,19:Begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'GS176' then
    begin
     case FieldId of
       8,9,28:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'GS303' then
    begin
     case FieldId of
       116:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if LeftStr(FormName,7) = 'T5018L#' then
    begin
     case FieldId of
       1,31:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'T5018S' then
    begin
     case FieldId of
       1,19:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'T2054' then
    begin
     case FieldId of
       15,16:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'T2054' then
    begin
     case FieldId of
       122,114:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'T1OVP' then
    begin
     case FieldId of
       19:begin AutoFormatDate(Value);Result := InDateYYYYMMDDOnly(Value,AppYearInt+2);exit;end;
     end; {Case}
    end

  else if FormName = 'T3010' then
    begin
     case FieldId of
        1,112: begin AutoFormatDate(Value);
          Result := InDateYYYYMMDDOnly(Value,AppYearInt+1);exit;end;
     end; {Case}
    end

  else if FormName = 'T3010' then
    begin
     case FieldId of
        1,112: begin AutoFormatDate(Value);
          Result := InDateYYYYMMDDOnly(Value,AppYearInt+1);exit;end;
     end; {Case}
    end

  else if LeftStr(FormName,6) = 'T1235#' then
    begin
     case FieldId of
        86..99: begin AutoFormatDate(Value);
          Result := InDateYYYYMMDDOnly(Value,AppYearInt+20);exit;end;
        4,16,28,40,52,64,76:begin AutoFormatDate(Value);
          Result := InDateYYYYMMDDOnly(Value,AppYearInt+1);exit;end;
     end; {Case}
    end

  else if LeftStr(FormName,6) = 'T1235#' then
    begin
     case FieldId of
        86..99: begin AutoFormatDate(Value);
          Result := InDateYYYYMMDDOnly(Value,AppYearInt+20);exit;end;
        4,16,28,40,52,64,76:begin AutoFormatDate(Value);
          Result := InDateYYYYMMDDOnly(Value,AppYearInt+1);exit;end;
     end; {Case}
    end

  else if ExtractNonInstFormName(FormName) = 'T1044' then
    begin
     case FieldId of
      1,2:begin AutoFormatDate(Value);
        Result := InDateYYYYMMDDOnly(Value,AppYearInt+1);exit;end;
     end; {Case}
    end

   else if ExtractNonInstFormName(FormName) = 'TX19' then
    begin
     case FieldId of
      4,18,20:begin AutoFormatDate(Value);
        Result := InDateYYYYMMDDOnly(Value,AppYearInt+1);exit;end;
     end; {Case}
    end
  else if ExtractNonInstFormName(FormName) = 'T5013FIN' then
    begin
     case FieldId of
      38,39,44,145:
      begin
       AutoFormatT5013Date(Value);
       //Result := InT5013DateYYYYMMDDOnly(Value,AppYearInt+1);exit;
       if (Value[5] <> '-') or (Value[8] <> '-') then Value:= ReplaceStr(Value, '/', '-');
       Result:= InT5013FINDateYYYYMMDDOnly(Value, succ(AppYearInt), RetNo, FormName, FieldId); //20260220 Igor
       exit; //20260220 Igor
      end;
     end; {Case}
    end
  //20260817 Alex >>>
  else if ExtractNonInstFormName(FormName) = 'T1134' then
  begin
    case FieldId of
      19, 20:
      begin
        AutoFormatDate(Value);
        Result:= InDateYYYYMMDDonly(Value, AppYearInt + 1);
      end;
      147, 34, 62, 63:
      begin
        AutoFormatDate(Value);
        Result:= InDateYYYYMMDDonly(Value, AppYearInt + 1);
      end;
    end;
  end
  else if ExtractNonInstFormName(FormName) = 'T1134S' then
  begin
    case FieldId of
      62, 63:
      begin
        AutoFormatDate(Value);
        Result:= InDateYYYYMMDDonly(Value, AppYearInt + 2);
        exit;
      end;
    end;
  end
  //20260817 Alex <<<
end;

constructor TMyChildTF_2026.CreateNew(AOwner: TComponent; RNo: Integer);
Var {MyPanel1,MyPanel2:TPanel;}MyBevel1:TBevel;
  j: Integer; //20160519 Igor
begin
  inherited;
  FormClass := TFormTF_2026;
 Caption:= GetReturnCaption(RetNo);
 Color:=GetRetColor(RetNo); //$00AC7400; //GetRetColor(RetNo);
 Name:='R'+IntToStr(RetNo);

 FMyFormHeaderFrame := THeaderFrameTF_2026.Create(self);
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

 FMyMonitorFrame := TMonitorFrameTF_2026.Create(self);
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

procedure TMyChildTF_2026.FormPaint(Sender: TObject);
Var
 i:integer;
begin
  Caption:=GetReturnCaption(RetNo);
end;

function TMyChildTF_2026.GetHeaderFrame: TFrame; //20160227 Igor
begin
  Result := MyFormHeaderFrame;
end;

function TMyChildTF_2026.GetMonitorFrame: TFrame;  //20160227 Igor
begin
  Result := MyMonitorFrame;
end;

Procedure TMyChildTF_2026.UpdateChildTaxPanel;
begin
  if RetNo < 1 then exit; //wait for valid RetNo

 FormatSettings.DecimalSeparator:='.';  //20150805 Igor
 With MyMonitorFrame do
 begin
    BalancePanel.Color   := GetRetColor(RetNo);
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
 end;
end;

Procedure TMyChildTF_2026.Keys(Var Key: Word; Shift: TShiftState);
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
  else If    (Key = VK_F7) then MainFormTF.Switchforms1Click(Application)
  else If    (Key = VK_F8) then MainFormTF.SwapBtnClick(Application)
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
    If Key = 83 then MainFormTF.SwapReturns1Click(Application) {Alt S}
    else if Key = 88 then MainFormTF.FileCloseItemClick(Application) {Alt x}
    else  Handled := False;
    if Handled then begin Key := 0; exit; end;
  end; {Alt keys}

  inherited;
end;

Procedure TMyChildTF_2026.UpdateFormHeaderFrame;
var
 FormInfo:String;
begin

 if not UpdateSectionButtons(MyFormHeaderFrame) then exit;
 FormInfo:=AllTrim(GetFormAbrevName(FormNo));
 //MyFormHeaderFrame.ReturnNameLbl.Caption:=NmInfo;
 MyFormHeaderFrame.FormNameLbl.Caption:=' '+FormInfo;
end;

procedure TMyChildTF_2026.CloseActiveForm(Sender: TObject);
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


Function TFormTF_2026.GetValueFromList(MyEditBox:TvtEdit;FieldId:Integer):String;
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

  SelectedString := PopSomeList(SomeList,SomeCaption, MyEditBox);
  //SomeList.Free; //abends
  result:=CleanUpPickedListValue(FieldId,SelectedString);
  SelectedString:=Result;  //??
end;


Function TFormTF_2026.GetLinkedForm(FieldId:Integer;Var TargetLinkedField:Integer):String;
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
  //20170515 Igor >>>
  try
  //20170515 Igor <<<
    Linklist.LoadFromFile(Appdir+'\'+'LINKLIST.D');
    InFrm := Rtrim(ExtractNonInstFormName(FormName));

    //multiple linked forms
    WList:=TStringList.Create;
    //20170515 Igor >>>
    try
    //20170515 Igor <<<
      For i :=0 to LinkList.Count -1 do
      begin
        Frm := RTrim(ExtractNonInstFormName(LeftStr(LinkList[i],10)));
        If InFrm = Frm then
        begin
          Fld := MyStrToInt(MidStr(LinkList[i],11,3));
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
                //20170515 Igor >>>
                //LinkList.Free;
                //WList.Free;
                //20170515 Igor <<<
                exit;
              end;
            end;
          end; //matching fieldid
        end; //found entry
      end;
    //20170515 igor >>>
    finally
      WList.Free;
    end;
    //20170515 Igor <<<
    //nothing found
    UserMsg('nothing linked to '+InFrm+'.vtEdit'+IntToStr(FieldId));
  //20170515 Igor >>>
  finally
    LinkList.Free;
  end;
  //20170515 Igor <<<
end;

Function TFormTF_2026.PopulatePickList(FieldId:Integer{;SomeList:TStrings}):String; //20160227 Igor
Var i:Integer;s,FromFname:String[10];FromElm:Integer; TempList:TstringList;
begin
   Result:='';
   //20130420
   If FormName = 'T5013FIN' then
   case FieldId of
     2: //naics
     begin
        Application.CreateForm(TSICTF_2026,SIC);
        SIC.ShowModal;
        SIC.Free;
        If SelectedString>'' then
          Result:=SelectedString
        Else
          Result:='';
        Exit;
     end;
  end;

  // 20240711 Igor >>>
  If FormName = 'UHT2900' then
  begin
    case FieldId of
      6, 14, 27: SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      7, 15: SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
    end;
  end;
  // 20240711 Igor <<<

  if FormName = 'T5013FIN' then
  begin
    case FieldId of
      16, 25, 33: SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      17, 26, 34: SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
    end;
  end;
  // 20250812 Igor >>>
  if FormName = 'PS75' then
  begin
    case FieldId of
      5, 7, 9, 11, 13, 101, 103, 105, 107, 109, 111: SomeList.LoadFromFile(AppDir + '\' + 'CleanTechPropertyAssets.d');
      22, 28, 34, 40, 46, 52, 114, 120, 126, 132, 138, 144: SomeList.LoadFromFile(AppDir + '\' + 'State.d');
    end;
  end;

  if (LeftStr(FormName, 4) = 'PS78') then
  begin
    case FieldId of 9, 23, 37, 51, 65, 79, 93, 107, 121, 135,
      193, 201, 209, 217, 225, 233, 241:
     begin
      Somelist.add('57 - Equioment used on CCUS project (Carbon Capture,Utilization,and Storage)');
      Somelist.add('58 - Equipment that is used solely to use carbon dioxide (CO2) in industrial production');
     end;
    end;

    case FieldId of
      10, 24, 38, 52, 66, 80, 94, 108, 122, 136,
      194, 202, 210, 218, 226, 234, 242: SomeList.LoadFromFile(AppDir + '\' + 'QualifiedCCUSExpenditure.d');
    end;
  end;
  // 20250812 Igor <<<

  //20200228
  If (ExtractNonInstFormName(FormName) = 'PS8') then    //20200228
  Begin
   case FieldId of
       6,22,38,54,70,86,102,118,134,150,166,182,198:
         for i := Low(CCARates) to High(CCARates) do
          SomeList.LoadFromFile(AppDir+'\'+'CCARates.D');
   end;
  End;

  If LeftStr(FormName,4) = 'PS9#' then
  begin
   case FieldId of
    7,15,23,31,39,47,55,63,71,79,87: SomeList.LoadFromFile(AppDir+'\'+'FCountry.d');
   end; //case
  end;


  If (LeftStr(FormName,7) = 'T3SUPL#') then
  begin
   case FieldId of
    29:SomeList.LoadFromFile(AppDir+'\'+'State.d');
    66: SomeList.LoadFromFile(AppDir+'\'+'FCountry.d');
    67: begin
            SomeList.Add('12');
            SomeList.Add('3A');
            SomeList.Add('3B');
            SomeList.Add('4B');
            SomeList.Add('11');
            SomeList.Add('07');
            SomeList.Add('13');
        end;

    3: begin
            SomeList.Add('O Original');
            SomeList.Add('A Amended');
            SomeList.Add('C Cancel');
        end;
    4: begin
            SomeList.Add('1 Individual');
            SomeList.Add('2 Joint account');
            SomeList.Add('3 Corporation');
            SomeList.Add('4 Association,trust,club,partnership');
            SomeList.Add('5 Government and others');
        end;

   end;
  end;


   If (LeftStr(FormName,5) = 'PS50#') then
   begin
    case FieldId of
       15:
       begin
            SomeList.Add('0 Limited partner');
            SomeList.Add('1 Specified member who is not a limited partner');
            SomeList.Add('2 General partner');
            SomeList.Add('3 Limited partner exempt interest');
            SomeList.Add('4 Nominee, Agent, Broker or Advisor');
       end;
      14:
       begin
            SomeList.Add('1 Individual, other than a trust');
            SomeList.Add('2 Corporation');
            SomeList.Add('3 Partnership');
            SomeList.Add('4 Trust');
            SomeList.Add('5 Non-resident Individual, other than a trust');
            SomeList.Add('6 Non-resident Corporation');
            SomeList.Add('7 Non-resident Partnership');
            SomeList.Add('8 Non-resident Trust (other than Non-res Discr trust');
            SomeList.Add('9 Non-resident Discretionary trust');
       end;
       22:SomeList.LoadFromFile(AppDir+'\'+'State.D');
       24: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
    end; //case
   end;

   //20240519
   If (LeftStr(FormName,6) = 'T2057#') then
   begin
    case FieldId of
      17,41: begin
          SomeList.LoadFromFile(AppDir+'\'+'State.d');
          end;
      end; //case
   end;

   If (LeftStr(FormName,7) = 'T5018L#') then
   begin
    case FieldId of
      13: begin
                for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvShort[i]);
          end;
      15: begin
                SomeCaption:='Country Codes';
                Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
          end;
      end; //case
   end;

   If (FormName = 'T5018S') then
   begin
    case FieldId of
      8:  begin
                for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvShort[i]);
          end;
      21: begin
            SomeList.Add('1 WIP');
            SomeList.Add('2 Ready for Print');
            SomeList.Add('3 Ready for Efile');
            //SomeList.Add('4 Ready for Print');
            //SomeList.Add('5 Ready for Efile');
            SomeList.Add('6 Printed');
            SomeList.Add('7 Printed/Mailed');
            SomeList.Add('8 Efiled');
            SomeList.Add('9 N/A');
          end;
      end; //case
   end;

  If FormName = 'T106' then
  case FieldId of
      35,36,37,38:Somelist.LoadFromFile(AppDir+'\'+'NAICS.d');
  end;

  If LeftStr(FormName,7) = 'T106SL#' then
     case FieldId of
      13:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
      19,20,21,22:Somelist.LoadFromFile(AppDir+'\'+'NAICS.d');
      33,121,37,41,45,49,53,57,61,65,69,73,77,81,85,89,
      35,123,39,43,47,51,55,59,63,67,71,75,79,83,87,91:
       begin
        SomeList.Add('1 Comparable Uncontrolled Price');
        SomeList.Add('2 Cost-Plus');
        SomeList.Add('3 Resale');
        SomeList.Add('4 Profit Split');
        SomeList.Add('5 Transactional Net Margin');
        SomeList.Add('6 Qualifing Cost Contribution Arrangement');
        SomeList.Add('7 Other');
       end;
      24,25,26,27:
       Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
      end;  //case

   //20170609
   If (ExtractNonInstFormName(FormName) = 'NR4DET') then
   begin
     case FieldId of
      2:
      begin
        SomeList.Add('1 individual');
        SomeList.Add('2 joint account');
        SomeList.Add('3 corporation');
        SomeList.Add('4 other (association, trust, etc');
        SomeList.Add('5 government, government enterprise, or international organizations');
      end;
      3:Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
      6,11:Somelist.LoadFromFile(AppDir+'\'+'NR4IncomeCd.d');
      10,15:Somelist.LoadFromFile(AppDir+'\'+'NR4ExemptCd.d');
      7,12:begin Somelist.LoadFromFile(AppDir+'\'+'CurrencyCd.d'); end;
      25,32:Somelist.LoadFromFile(AppDir+'\'+'STATE.d');
      27,34:Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
     end; //case
   end;

   //20170609
   If (ExtractNonInstFormName(FormName) = 'NR4SUM') then
   begin
     case FieldId of
       7:Somelist.LoadFromFile(AppDir+'\'+'STATE.d');
      26:Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
     end; //case
   end;

   If (LeftStr(FormName,9) = 'T5INCOME#') then
   begin
     case FieldId of
      21,43,65,87,109:
      begin
       SomeCaption:='Foreign Exchange Rates';
       Somelist.LoadFromFile(AppDir+'\'+'ExchRate.d');
      end;
      5,27,49,71,93:
      begin
        SomeList.Add('1');
        SomeList.Add('2');
        SomeList.Add('3');
      end;
      end; //case
    end;

   If (LeftStr(FormName,9) = 'T5013INC#')
   then
     case FieldId of
      1:
       begin
        SomeList.Add('1');
        SomeList.Add('2');
        SomeList.Add('3');
       end;
     end;  //case

   If (LeftStr(FormName,6) = 'T5013#') then
     case FieldId of
      8:
       begin
        SomeList.Add('0 Original slip');
        SomeList.Add('1 Amended slip');
        SomeList.Add('2 Additional slip');
        SomeList.Add('3 Cancelled slip');
        SomeList.Add('4 Duplicate slip');
       end;
     end;  //case

   If FormName = 'T5013SUM' then  //20120324
     case FieldId of
     85,88,90,92,94,98:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
      79,83:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
      102,106,110,114,118,122,126:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
      112,143,147,262:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
      269,273,277,281,285,289,293,297,301,305,309,313,317:
         Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
      321,325,329,333,337,341,345,349,353,357,361,365,369,373,377,381:
         Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
      128,137:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
      242..260:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');

   //20150705
   else If FormName = 'T1135' then   //20130720
   begin
     If FieldId>9999 then
       Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRYT1135.d');  //it includes OTH, but tbl: 1 and 5 cannot use OTH ! //20160123
     //20151212
     Case fieldId of
       28:Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRY.d');  //20160123  //it does notinclude OTH
       57,58,59: Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRYT1135.d');  //20160123
     end;
   end
   end;

   If FormName = 'T1135' then   //20160227 Igor
   begin
     If FieldId>9999 then
       Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRYT1135.d');  //it includes OTH, but tbl: 1 and 5 cannot use OTH ! //20160123
     //20151212
     Case fieldId of
       28:Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRY.d');  //20160123  //it does notinclude OTH
       57,58,59: Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRYT1135.d');  //20160123
     end;
    end;

    If LeftStr(FormName,5) = 'PS100' then
     case FieldId of
      5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55:
       SomeList.LoadFromFile(AppDir+'\'+'GIFIAssets.d');
      78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,
       118,120,122,124,126,128,130,132,134,136,138,140,142,144,146,148:
       SomeList.LoadFromFile(AppDir+'\'+'GIFILiabilities.D');

      151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185:
       SomeList.LoadFromFile(AppDir+'\'+'GIFIEquity.D');

      188,190,192,194,196,198,200,202,204,206,208:
       SomeList.LoadFromFile(AppDir+'\'+'GIFIRetEarnings.D');
     end;

    If LeftStr(FormName,6) = 'PS125#' then
     case FieldId of
      7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,
       57,59,61,63,65:
       SomeList.LoadFromFile(AppDir+'\'+'GIFINFIncome.d');
      68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,
       118,120,122,124:
       SomeList.LoadFromFile(AppDir+'\'+'GIFINFCostOfSales.D');

      128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158,
       160,162,164,168,170,172,174,176,178,180,182:
       SomeList.LoadFromFile(AppDir+'\'+'GIFINfOperExpenses.D');

      189,191,193,195,197,199,201,203:
       SomeList.LoadFromFile(AppDir+'\'+'GIFIFarmIncome.D');

      206,208,210,212,214,216,218,220,22,224,226,228,230,232,234,236,238,240,242,244,
      246,248,250,252,254,256,258,260,262,264,266,268,270,272:
       SomeList.LoadFromFile(AppDir+'\'+'GIFIFarmExpenses.D');

      277,279,281,283,285,287,289,291,293,295,297,299:
       SomeList.LoadFromFile(AppDir+'\'+'GIFIExtraItems.D');

     end;


    If ExtractNonInstFormName(FormName) = 'T3SUPL' then
    case FieldId of
     61: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
    end;


   If FormName = 'T5011' then
     case FieldId of
      7,17,22,25: SomeList.LoadFromFile(AppDir+'\'+'State.D');
      9,24: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
     end;


   If (LeftStr(FormName,4) = 'PS8#') then
   case FieldId of
      6,22,38,54,70,86,102,118,134,150,166,182,198:
        for i := Low(CCARates) to High(CCARates) do
         SomeList.LoadFromFile(AppDir+'\'+'CCARates.D');
   end;



  If (LeftStr(FormName,6) = 'T5015#') then
  begin
    case FieldId of
      11,27,43,59,75,91,107,123,139,155:
      begin
         SomeList.Add('1 Individual');
         SomeList.Add('3 Corporation');
         SomeList.Add('4 Trust or Partnership');
      end;
      12,28,44,60,76,92,108,124,140,156:
      begin
         SomeList.Add('0 Limited Partner');
         SomeList.Add('1 Specified Partner');
         SomeList.Add('2 General Partner');
      end;
      17,33,49,65,81,97,113,129,145,161: SomeList.LoadFromFile(AppDir+'\'+'State.D');
      19,35,51,67,83,99,115,131,147,163: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
    end;  //case
  end;


  If FormName = 'T3010'then  //20130225
  begin
    case FieldId of
      189,193,197,201,205: Somelist.LoadFromFile(AppDir+'\'+'CharCountry.d');
      153,156,159,162,165:Somelist.LoadFromFile(AppDir+'\'+'CharCountry.d');
      384,387,390,393,396,399,402:Somelist.LoadFromFile(AppDir+'\'+'CharCountry.d');
      167..176:Somelist.LoadFromFile(AppDir+'\'+'CharCountry.d');
    end;  //case
  end;

  //20260817 Alex >>>
  if FormName = 'T1134' then
  begin
    FieldId:= GetFirstElmId(RetNo, FormNo, FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
    case FieldId of
     40, 41, 42, 43: SomeList.LoadFromFile(AppDir + '\' + 'NAICS.d'); //20230510 Igor
     24:
     begin
       SomeList.Add('USD = US Dollar');
       SomeList.Add('GBP = GB Pound Sterling');
       SomeList.Add('AUD = AU Dollar');
       SomeList.Add('EUR = Euro');
     end;
     25:
     begin
       SomeList.Add('1   New');
       SomeList.Add('2   Unmodified');
       SomeList.Add('3   Amended');
     end;
     33:
     begin
       SomeList.Add('1   Individuals or Trusts');
       SomeList.Add('2   Corporations');
       SomeList.Add('3   Combination of Individuals, Trusts or Corporations');
     end;
     20009, 20010, 20011, 20012, 30009, 30010, 30011, 30012, 40010, 40011, 40012, 40013: SomeList.LoadFromFile(AppDir + '\' + 'NAICS.d');
     17, 10007, 20005, 30005, 40005: SomeList.LoadFromFile(AppDir + '\' + 'State.d');
     141, 10009, 20007, 30007, 40007, 60002, 60005, 70003, 70006, 80003, 90003, 110003: SomeList.LoadFromFile(AppDir + '\' + 'FCountryT1135.d');
     40009:
     begin
       SomeList.Add('1   If end partners are individuals or trusts');
       SomeList.Add('2   If end partners are corporations');
       SomeList.Add('3   If end partners are a combination of 1 and 2 mentioned above');
     end;
     60003,70001,90004,110001: PopulateT1134ForeignAffiliates(RetNo,SomeList); //20230601 Igor
    end;
  end

  else if LeftStr(FormName, 7) = 'T1134S#' then
  begin
    FieldId:= GetFirstElmId(RetNo, FormNo, FieldId); // if FieldId is dynamic, change it to the corresponding id of first row

    case FieldId of
     20001, 30001: PopulateT1134SGroupList(RetNo, FormNo, SomeList, 1);
     50001, 60001, 70002, 80002, 90002, 100002, 110001, 140001: PopulateT1134SGroupList(RetNo, FormNo, SomeList);
     10001, 40001, 120001, 130001, 150001, 160001: PopulateT1134GroupList(RetNo, SomeList);
     3:
     begin
       SomeList.Add('1   New');
       SomeList.Add('2   Unmodified');
       SomeList.Add('3   Amended');
       SomeList.Add('4   Delete (Close)');
     end;
     175:
     begin
       SomeList.Add('1   Duplicate');
       SomeList.Add('2   Filed in Error');
       SomeList.Add('3   Other');
     end;
     40, 41, 42, 43: SomeList.LoadFromFile(AppDir + '\' + 'NAICS.d');
     44, 45, 46, 47, 5, 6, 7, 8, 48: SomeList.LoadFromFile(AppDir + '\' + 'FCountryT1135.d');
     10012, 16, 18, 79, 83, 87, 91, 95, 99, 103, 107, 111: SomeList.LoadFromFile(AppDir + '\' + 'Currency.d');
    end;
  end;
  //20260817 Alex <<<

end;



Function TFormTF_2026.CleanUpPickedListValue(FieldId:Integer;SelectedString:String):string; //20160227 Igor
Var TempS:String;
Begin
  Result := SelectedString;

   if Leftstr(FormName,6)='T2057#' then result:=AllTrim(MidStr(SelectedString,3,30));  //20240519
   if Leftstr(FormName,41)='T2057#' then result:=AllTrim(MidStr(SelectedString,3,30));  //20240603

  //20160130
  If FormName = 'T3' then If FieldId=81 then  //201
  //If (LeftStr(FormName,7) = 'T3') then If FieldId=81 then
  Begin
   result := LeftStr(SelectedString,3);
   If Not Numeric(result) then result:='';
  end;

  If (LeftStr(FormName,7) = 'T3SUPL#') then
  begin
    If FieldId=29 then result := LeftStr(SelectedString,2);
    If FieldId=3 then result := LeftStr(SelectedString,1);
    If FieldId=4 then result := LeftStr(SelectedString,1);
    If FieldId=61 then result := LeftStr(SelectedString,3);   //20120416
  end;

  if FormName = 'T5013FIN' then
  begin
    case FieldId of
      16, 25, 33: Result:= LeftStr(SelectedString, 2); //20260220 Igor
      17, 26, 34: Result:= LeftStr(SelectedString, 3); //20260220 Igor
    end; // case;
  end;

  If LeftStr(FormName,4)='PS9#' then
  begin
   result := LeftStr(SelectedString,3);  //country
  end;


  If (LeftStr(FormName,8) = 'ASSETSB#') then
  begin
    If (FieldId =215) or (FieldId =221) or (FieldId =227) then result := LeftStr(SelectedString,8);
    If (FieldId =134) then result := LeftStr(SelectedString,4);
  end;

  If (LeftStr(FormName,5) = 'PS50#') then
  begin
    If FieldId=14 then  result := LeftStr(SelectedString,1);
    If FieldId=15 then  result := LeftStr(SelectedString,1);
    If FieldId=22 then  result := LeftStr(SelectedString,2);
    If FieldId=24 then  result := LeftStr(SelectedString,3);
    If FieldId=47 then  result := LeftStr(SelectedString,2);
    If FieldId=49 then  result := LeftStr(SelectedString,3);
  end;


  If (LeftStr(FormName,6) = 'AUTOS#') then
  begin
    If (FieldId =215) or (FieldId =221) or (FieldId =227) then result := LeftStr(SelectedString,8);
  end;

  If (FormName = 'T5014') then Result := LeftStr(Result,4);

  If LeftStr(FormName,6) = 'T5015#' then
  begin
    Case FieldId of
    11,27,43,59,75,91,107,123,139,155:Result:=LeftStr(Result,1);
    12,28,44,60,76,92,108,124,140,156:Result:=LeftStr(Result,1);
    else Result := LeftStr(Result,3);
    end; //case
  end;

  //20170610
  If (ExtractNonInstFormName(FormName) = 'NR4DET') then
  begin
     case FieldId of
      2:Result:=LeftStr(Result,1);
      3:Result:=LeftStr(Result,3);
      6,11:
      Begin
        Result:=LeftStr(Result,2);
        If Not Numeric(result) then
          result:='';
      end;
      7,12:Result:=LeftStr(Result,3);
      10,15:Result:=LeftStr(Result,1);
      25,32:Result:=LeftStr(Result,2);
      27,34:Result:=LeftStr(Result,3);
     end; //case
  end;

   //20170609
   If (ExtractNonInstFormName(FormName) = 'NR4SUM') then
   begin
     case FieldId of
      26:Result:=LeftStr(Result,3);
      7:Result:=LeftStr(Result,3);
     end; //case
   end;


   If (ExtractNonInstFormName(FormName) = 'T5018L') then
   begin
     case FieldId of
      15:Result:=LeftStr(Result,3);
     end; //case
   end;

   If (ExtractNonInstFormName(FormName) = 'T5018S') then
   begin
     case FieldId of
      22:Result:=LeftStr(Result,3);
     end; //case
   end;


  If (LeftStr(FormName,9) = 'T3INCOME#') and
  (FieldId = 31) then
  begin
    result := AllTrim(LeftStr(SelectedString,30));
    StoreElm(RetNo,FormNo,FieldId-27,AllTrim(MidStr(SelectedString,31,12)));
  end;


  If (LeftStr(FormName,9) = 'T5INCOME#') and
  ((FieldId = 21) or (FieldId = 43) or (FieldId = 65) or (FieldId = 87) or
     (FieldId = 109)) then
  begin
    result := AllTrim(LeftStr(SelectedString,20));
    StoreElm(RetNo,FormNo,FieldId-17,AllTrim(MidStr(SelectedString,31,12)));
  end;


  If FormName = 'T5013SUM' then
  begin
   TempS:=result;
   Result := LeftStr(Result,4);
   Case FieldId of
      97,101,105,109,113,117,121,125,142, 146,82:
      StoreElm(RetNo,FormNo,FieldId-1,MidStr(TempS,5,40));
   end; //case
  end;

  If (LeftStr(FormName,6) = 'T5013#')
  //or (LeftStr(FormName,7) = 'T5013A#')
   then Result := LeftStr(Result,1);

  If (LeftStr(FormName,5) = 'PS100') then Result := LeftStr(Result,4);
  If (LeftStr(FormName,6) = 'PS125#') then Result := LeftStr(Result,4);
  //If (FormName = 'POTHINFO') then Result := LeftStr(Result,4);

  If FormName = 'T5011' then Result := LeftStr(Result,3);

  If FormName = 'T106' then result:=LeftStr(Result,3);
  If LeftStr(FormName,7) = 'T106SL#' then
  begin
    Case FieldId of
     13:Result := LeftStr(Result,2);
     19,20,21,22: result:=LeftStr(Result,3);
     24,25,26,27: result:=LeftStr(Result,3);
     else Result := LeftStr(Result,1);
    end; //case
  end;

  If (LeftStr(FormName,4) = 'PS8#') then Result := LeftStr(Result,4);


  If FormName = 'T3010' then  //20130225
  begin
    case FieldId of
      189,193,197,201,205:Result:=LeftStr(Result,2);
      153,156,159,162,165:Result:=LeftStr(Result,2);
      167..176:Result:=LeftStr(Result,2);
      384,387,390,393,396,399,402:Result:=LeftStr(Result,2);  //20131231
    end;  //case
  end;

  If (FormName = 'T1135') then result := LeftStr(SelectedString,3);  //20160227 Igor

  //20260817 Alex >>>
  if FormName = 'T1134' then
  begin
    FieldId:= GetFirstElmId(RetNo, FormNo, FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
    case FieldId of
      33:
      begin
        Result:= LeftStr(Result, 1);
      end;
      40, 41, 42, 43, 20009, 20010, 20011, 20012, 30009, 30010, 30011, 30012, 40010, 40011, 40012, 40013: Result:= LeftStr(Result, 6);
      60003, 70001, 90004, 110001: ; //20230601 Igor do nothing
    else
      Result:= LeftStr(Result, 3);
    end;
  end;

  if ExtractNonInstFormName(FormName) = 'T1134S' then
  begin
    FieldId := GetFirstElmId(RetNo, FormNo, FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
    case FieldId of
      10001, 40001, 120001, 130001, 150001: Result:= Copy(Result, Pos(' - ', Result) + 3, Length(Result));
      20001, 30001, 50001, 60001, 70002, 80002, 90002, 100002, 110001, 140001, 160001: Result:= Copy(Result, 1, Pos(' - ', Result) - 1);
      40..43: Result:= LeftStr(Result, 6)
    else
      Result:= LeftStr(Result, 3);
    end;
  end;
  //20260817 Alex <<<

end;


procedure TMyChildTF_2026.FormContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  exit;
end;

procedure TFormTF_2026.FormatEditBoxText(MyEditBox: TvtEdit; str: string);
begin
  inherited;
  MyEditBox.Font.Name:='Arial Narrow';  //20131225

end;

Procedure TFormTF_2026.FormatDollar(MyEditBox: TvtEdit; str: string);
var
  HowToFormat: integer;
begin
  FormatSettings.DecimalSeparator := '.'; //20150805 Igor
  If Vl(str) = 0 then
    MyEditBox.Text := '' //20160808 Igor
  else
  begin
    HowToFormat :=GetHowToFormat(FormName,MyEditBox.FieldId);
    MyEditBox.Text:=FormatAmount(FormName,str,HowToFormat);
  end;
  MyEditBox.Modified := True;
end;

Procedure TFormTF_2026.ShowFieldData(MyEditBox:TvtEdit);
Var
  fld:Integer;
  //R:TRect;FormattedAmount:string; //[15];ErrMsg:String;
  //EditBoxColr:TColor;
Begin
  inherited;

end;


procedure TFormTF_2026.EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
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

  with MainFormTF do
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

procedure TFormTF_2026.OnVtEditDblClick(MyEditBox:TvtEdit);
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
    //20170628 Igor >>>
    //if linkToSelf(FormName,FName)then
    //  ShowTimedMsg('Hit the Spacebar to link',1200)
    //else
    //20170628 Iogr <<<
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


Procedure TFormTF_2026.DataChangeRtn;
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
  Result:=PaddR(PaddZero(IntToStr(RetNo),2),2)+' '+RetName;
end;


procedure TFormTF_2026.ShowRichData(ARichEdit: TRichEdit; Fld: Integer);
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

procedure TFormTF_2026.GetSICCode(FieldId:Integer);
begin
  If AskingForSicCode(FormName,FieldId) then
   begin
    MainFormTF.NAICSCodes1Click(Application);
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
