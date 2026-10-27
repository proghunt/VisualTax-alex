unit T1_2026autofillLogin;

{ //20240212
Autofill:
       MfmsdsPKjOiFcZvUVFCN87WQEhgDyMxW

noa:   MfmsdsPKjOiFcZvUVFCN87WQEhgDyMxW

// secret Autofill key for test in 2019  25MRu1RrjMmGGPUjbZuUpNI4eqtNjG8M
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, vtLabel, Buttons, ExtCtrls,
  FileCtrl,  //20160121
  ShellAPI,
  T1_2026Declare, T1_2026TrimStr, vtTrimStr, T1_2026ChildWinNew, T1_2026Common2, Grids,
  CheckLst, ComCtrls{, TeeProcs, TeEngine, Chart},
  DB, DBTables,
  vtEditBox,{Poplist,}
  T1_2026Calc,
  T1_2026, Vcl.OleCtrls, SHDocVw; //20230131 Igor

type
  TAutoFillLoginT1_2026 = class(TForm)
    OpenDialog: TOpenDialog;
    GroupBox1: TGroupBox;
    AcceptanceGroup: TGroupBox;
    RadioGroup1: TRadioGroup;
    SinSelectionGroup: TGroupBox;
    TDDRetList: TCheckListBox;
    ConnectToTDDBtn: TBitBtn;
    ClearTDDRetListBtn: TBitBtn;
    ExitBtn1: TBitBtn;
    UncheckBtn: TBitBtn;
    CRAAutoFillBtn: TBitBtn;
//20170307 Igor <<<
    TestGroup: TGroupBox;
    TestLabel: TLabel;
    TestCasesReceivedBox: TEdit;
    LoadReceivedDataBtn: TBitBtn;
    VtAutofillBtn: TBitBtn;
    TestOrProductionGroup: TRadioGroup;
    wbStart: TWebBrowser;
    procedure ConnectToTDDBtnClick(Sender: TObject);
    procedure FillReturnFromFileBtnClick(Sender: TObject);
    procedure ExitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadSinDataBtnClick(Sender: TObject);

    procedure LoadReceivedDataBtnClick(Sender: TObject);

    procedure StatusBtnClick(Sender: TObject);
    procedure ClearTDDRetListBtnClick(Sender: TObject);
    procedure Exit2BtnClick(Sender: TObject);
    procedure UncheckBtnClick(Sender: TObject);
    Procedure LoadTddErrorCodes(Var TddErrorCodes:TStringList);
    Procedure ShowTddErrorCode(S:String);
    procedure CRAAutoFillBtnClick(Sender: TObject);
    procedure VtAutofillBtnClick(Sender: TObject); //20160721 Igor
    //20230131 Igor >>>
    procedure FormShow(Sender: TObject);
    procedure wbStartBeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
      const URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    //20230131 Igor <<<

  private
   { Private declarations }
   FSkipLinkIntercept: boolean; //20230131 Igor
   /// 20151225 igor
   procedure ProcessFile;


   //20151229 new routines  CON 20151229 / 30
   procedure AddPreloadedReturns;
   Function  CountReturnsToSubmit:Integer;
   Procedure GetSINSReceived(ReceivedFile:String;Var TddSinsReceived:TStringList);  //20151229
   Procedure ExtractSinData(ReceivedFile:String;SIN:String;Var ExtractedSinData:TStringList);
 //  Procedure ExtractSinSubCodeData(SubSectionCode:String;ExtractedSinData:TStringList;Var ExtractedData:TStringList); //20151230
   Procedure ExtractALLSinSubCodeData(SubSectionCode:String;ExtractedSinData:TStringList;Var ExtractedData:TStringList);
   Procedure UpdateTddStatus(Sin:String);
   Procedure SaveSinData(RNo:Integer;Sin:String;ExtractedSinData:TStringList);
   Procedure BreakReceivedDataBySIN(ReceivedFile:String);
   Procedure RemoveSinsWithNoData(Var TddSinsReceived:TStringList);   //20160123
   function SelectedSins: string;
  public
    { Public declarations }
    FileName: string;
{$IFNDEF WITH_MUTEX}
    FileDone: String; //20160221 Igor
{$ENDIF}
  end;

var
  //20151230 con
  cTDDReceivedTxtFileName:String; // = 'TddReceived-last6.txt'; //20151229 for testing TDDReceived.txt';   //20151229
  cTDDReceivedXmlFileName:String; // = 'TDDReceived.xml';


  AutoFillLogin: TAutoFillLoginT1_2026;
  TddPlainRetList:TStringList;
  //TddFilesDir:String;  //20160109
  TestOrProduction:String;
  AcceptedReturns:TStringList;
  RNo:Integer;
//  TddElmsTable:TADTable; //20160721 Igor  TddErrorCodes:TStringList;
  TddErrorCodes:TStringList;
  //20151230
  SIN:String;
 // SinsReceived:TStringList;
  ReceivedData:TStringList;
  ExtractedSinData:TStringList;
  ExtractedSinDataGroups:TStringList;
  ExtractedSinSubSectionData:TStringList;

implementation

uses T1_2026main, vtCommon, vtShared, vtMulti, vtAutofill; //20160721 Igor //20170112 Igor

{$R *.DFM}

procedure TAutoFillLoginT1_2026.ConnectToTDDBtnClick(Sender: TObject);
Var
  h:THandle;
  i:Integer;
  spaceDelimiter,quotes,params:string;
  ProgramPath:String;  //20151223
begin
 LoadTddErrorCodes(TddErrorCodes);   //20160124
 For i:=0 to TddRetList.items.count-1 do
 begin
  RNo:=GetRetNoFromSIN(LeftStr(TddRetList.items[i],9));

  If (RNo>0) and (TddRetList.checked[i]) then
  Begin
   If (isAutofilled(RNo) = True) then  //2016
   Begin
     if MessageDlg('The tax return of '+ GetLastName(RNo)+' '+ GetFirstName(RNo) +
     Chr(13) + ' has been already Auto-filled My Return.'+
      Chr(13)+'Do you wat to submit it to CRA again?',
        mtInformation, [mbYes, mbNo], 0) = mrNo then
          TddRetList.Checked[i]:=False;
    end;

  end; //Rno>0
 end; //i

  If (CountReturnsToSubmit=0) then
  begin
   ShowMessage('You must have at least one return checked for Auto-fill My Return');
   Exit;
  end;

  If (CountReturnsToSubmit>10) then
  begin
   ShowMessage('The number of selected returns exceeds 10. Please un-check some');
   Exit;
  end;

  If TestOrProductionGroup.ItemIndex=0 then
   TestOrProduction:='P'
  else
   TestOrProduction:='T';
  if RunAutofill(TestOrProduction, AppDir, OptRec.Dir_AutoFill, AppYear, SelectedSins) then
    ProcessFile;
end;


procedure TAutoFillLoginT1_2026.FillReturnFromFileBtnClick(Sender: TObject);
Begin
 //dummy to be replaced;
end;

procedure TAutoFillLoginT1_2026.ExitBtn1Click(Sender: TObject);
begin
 {
 //20160107
 If TddSinsReceived =Nil then exit;
 If TDDSinsReceived.count>0 then ShowTddStatus;
 }

// Try                          //20160125 Igor
//  TddErrorCodes.Free;  //201
//  ReceivedData.Free;
// Except
// End;


 Try                        //20160125 Igor
  freeAndNil(TddErrorCodes);
 Except
 End;
 Try
  freeAndNil(ReceivedData);
 Except
 End;

 Close;
end;

procedure TAutoFillLoginT1_2026.FormCreate(Sender: TObject);
Var i:Integer;
begin
 FSkipLinkIntercept := true; //20230131 Igor
 //20160211
// TestOrProductionBox.itemIndex:=0; //20170404  //production
 { 20170208
 If (Uppercase(User.UserName)='FREDW') then //tester //20170112 Igor
  TestGroup.Visible:=True
 Else  //production
  TestGroup.Visible:=False;
  }
 //-------------------
// TDDFilesDir:=AppDir+'\'+'TddData';      //20160109 //20170222 Igor {this is global var. filled from settings}

 If not DirectoryExists(OptRec.Dir_AutoFill) then ForceDirectories(OptRec.Dir_AutoFill);  //20151223 //20170222 Igor

 cTDDReceivedTxtFileName:='TddReceived-last6.txt'; //20151229 for testing TDDReceived.txt';   //20151229
 cTDDReceivedXmlFileName:='TDDReceived.xml';

 AddPreloadedReturns;
end;

procedure TAutoFillLoginT1_2026.FormShow(Sender: TObject); //20230131 Igor
  procedure ShowStartMessage;
  var
    Doc: Variant;
    StartMessage: String;
    //20260213 cz changed test below
  begin
    StartMessage :=
      '<html>'+
      '<head>'+
      '<style>'+
      'html'+
      '{'+
      ' position:fixed;'+
      ' overflow:hidden;'+
      ' -ms-overflow-style: none;'+
      '    border:0px;'+
      ' }</style>'+
      ' </head>'+
      '<body>'+
      '<p>You are about to be redirected to a secure Canada Revenue Agency (CRA) service that allows authorized representatives to request the electronic delivery '+
         'of available tax information to the software to complete portions of an individual’s current and prior year tax return.</p>'+
      '<p>To use this service you must have a CRA or Sign-In partner credential. To obtain online access for your client, submit an authorization request in '
        + '<a href="https://www.canada.ca/en/revenue-agency/services/e-services/cra-login-services.html">Represent a Client</a></p>'+
   //   + '<a href="https://www.canada.ca/en/revenue-agency/services/e-services/represent-a-client.html">Represent a Client</a> portal or through the EFILE software.</p>'+
      '<p>As per the CRA Terms and Conditions of Use, you are required to ensure that all applicable fields contained on the tax return that you will file with the CRA '+
         'are completed, and that the information provided is true and accurate</p>'+
      '</body>'+
      '</html>';

    if not Assigned(wbStart.Document) then
      wbStart.Navigate('about:blank');

    Doc := wbStart.Document;
    Doc.Clear;
    Doc.Write(StartMessage);
    Doc.Close;

    // remove scrollbars
    Doc.Body.Style.OverflowX := 'hidden';
    Doc.Body.Style.OverflowY := 'hidden';

    FSkipLinkIntercept := false;
  end;
begin
  ShowStartMessage;
end;

procedure TAutoFillLoginT1_2026.AddPreloadedReturns;
Var i:Integer;s:String;
  AllowIt:Boolean;
begin
  For i:=0 to Ret.Count-1 do
  Begin
    if Assigned(Ret.Items[i]) then
    Begin
      RNo:=Ret[i].RetNo;
      If GetSinNo(RNo)>'' then     //It needs some more validation checks)
      begin
        //20160204 //20160216 Igor
        If (ValidSin(GetSinNo(RNo))) and (Length(FetchElm(RNo,'INFO',9))=10) then   //birthdate correct
        Begin
          //20160211
          s:=GetSinNo(RNo)+' '+PaddR(GetLastName(RNo)+' '+LeftStr(GetFirstName(RNo),1)+'.',40);
          {          //20260321
          If isAutofilled(RNo) then s:=s+PaddR('Auto-filled My Return already',22) else s:=s+PaddR(Space(22),22);
          If isAuthRepDoneForTdd(RNo)=false then s:=s+PaddR('AuthRep not done already',25)
            else s:=s+PaddR('AuthRep done already',21);
          }

          TddRetList.Items.Add(s);
        end
        Else
        Begin
          ShowMessage('Return with missing Birthdate or missing or invalid SIN cannot be transmitted');
        end;
      end;
    End;
  end;
 (*
 //List loaded returns
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   RNo:=RetRec^.RetNo;
   AllowIt:=True;
   If GetSinNo(RNo)>'' then     //It needs some more validation checks)
   begin
    s:=GetSinNo(RNo)+' '+PaddR(GetFirstName(RNo),20)+' '+PaddR(GetLastName(RNo),35);

    {
    If (isAutofilled(RNo) = True)
    then  //2016
    Begin
     if MessageDlg('The tax return of '+ GetLastName(RNo)+' '+ GetFirstName(RNo) +
     Chr(13) + ' has been already Auto-filled My Return.'+
      Chr(13)+'Do you wat to submit it to CRA again?',
        mtInformation, [mbYes, mbNo], 0) = mrYes then
           AllowIt:=True
     Else
          AllowIt:=False;
     }
    end;

    {
    If (isT1013DoneForTdd(RNo) = False)
    then  //2016
    Begin
     If MessageDlg('The T1013 of '+ GetLastName(RNo)+' '+ GetFirstName(RNo) +
     ' does not have any indication that it has been submitted to CRA.'+
      Chr(13)+'Do you want to submit the Auto-fill My Return request to CRA anyway?',
        mtInformation, [mbYes, mbNo], 0) = mrYes then  AllowIt:=True
     Else
       AllowIt:=False;
    end;
    If Allowit=True then TddRetList.Items.Add(s);
   end;
   }
 end;
 *)
 for i :=0 to (TDDRetList.Items.Count - 1) do
   TddRetList.Checked[i]:=True;

end;


(*20151226
procedure TAutoFillFrm.FormCreate(Sender: TObject);
Var i,RNo:Integer;
begin
 FWaitingFile := false;  //20151226 as added by igor withot date/comment
 //FisWaitingFile := false;

 TDDFilesDir:=AppDir+'\'+'TddData';      //20151223
// If NOT DirectoryExists(TDDFilesDir) then ForceDirectories(TDDFilesDir);  //20151223
   //
 //List loaded returns
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   RNo:=RetRec^.RNo;
   If GetSinNo(RNo)>'' then     //It needs some more validation checks)
   begin
    TddRetList.Items.Add(GetSinNo(RNo)+' '+PaddR(GetFirstName(RNo),20)+' '+PaddR(GetLastName(RNo),35));
   end;
 end;

 for i :=0 to (TDDRetList.Items.Count - 1) do
 begin
   TddRetList.Checked[i]:=True;
 end;

 CreateTddParmsFile;

end;
*)

procedure TAutoFillLoginT1_2026.ProcessFile;
Var i:Integer;ReceivedFile,NewFileName:String;  //20151229
Msg:String; XmlFileName:String;
begin
  Application.BringToFront; //20170307 Igor
  // 20151225 igor
  cTDDReceivedTxtFileName:='TDDReceived.txt';   //20160106
  //filefound
  //20160124
  ReceivedData:=TstringList.Create;
  ReceivedFile:=OptRec.Dir_AutoFill + '\' + cTDDReceivedTxtFileName;  //'TddReceived-First10.txt'; //changed constant in the beginning to do a test //20151229 //20170222 Igor
  sleep(1000);  //20160125 Igor
  ReceivedData.LoadFromFile(ReceivedFile);
  If ReceivedData.count=1 then
  Begin
   ShowTddErrorCode(ReceivedData[0]);  //20160124
   Screen.Cursor:=crDefault;
   Close;    //20160124
   exit;
  end
  Else
  ReceivedData.clear;

  BreakReceivedDataBySIN(ReceivedFile);
  RemoveSinsWithNoData(TddSinsReceived);   //20160123

  //20160120
  Screen.cursor:=CrDefault;  //20160107

  //20160213 //20160216 Igor
  XmlFileName:=OptRec.Dir_AutoFill + '\' +'TddReceived.xml'; //20170222 Igor
  If FileExists(OptRec.Dir_AutoFill + '\' +'TddReceived.xml') then  //20160213 //20170222 Igor
  Begin
    NewFileName:=AddDateTimeSuffixToFileName(XmlFileName);  //20160213
    If RenameFile(XmlFileName,NewFileName) = false then ShowMessage('Unable to Rename the received XML file'); //20160213
  end;

  Msg:='Data received from CRA';
  If TddSinsReceived.count=1 then
  Begin
     Msg:=Msg+' for '+GetFirstName(RNo)+' '+GetLastName(RNo)
     +#13+'You can close the CRA WEB-Page.' //20170306 Igor
     +Chr(13)+' NEXT STEP: Please review and accept or decline the data received';
     ShowMessage(Msg);
     MainFormT1.AutofillfromCRABtnClick(Application);  //20160121
     Close;   //20160121
  end
  Else If TddSinsReceived.count>1 then //multiple received
  Begin
    Msg:=Msg+Chr(13)+' Data for multiple returns received.'
    +#13+'You can close the CRA WEB-Page.' //20170306 Igor
    +Chr(13)+'NEXT STEP: Select each return from the left panel'
    +Chr(13)+'and then click MainMenu Autofill(TDD) -> Review/Accept data ';
     ShowMessage(Msg);
     MainFormT1.ShowTddStatus;
     Close;   //20160121
  end
  Else
  Begin
   Msg:='No data received from CRA'
     +#13+'You can close the CRA WEB-Page.'; //20170306 Igor;
   ShowMessage(Msg);
   Close;    //20160121
  end;
 // Close;   //20160121
end;

//20151229
Procedure TAutoFillLoginT1_2026.ExtractSinData(ReceivedFile:String;SIN:String;Var ExtractedSinData:TStringList);
Var i,j,k:Integer;
     s,Section, SubSection, DataElmName,Instance,Value:String;
     A: TArray<string>; //20210208 Igor
Begin
 ReceivedData:=TStringList.Create;
 ExtractedSinData:=TStringList.Create;
 ExtractedSinDataGroups:=TStringList.Create;
 ReceivedFile:=OptRec.Dir_AutoFill + '\' + cTDDReceivedTxtFileName; //20170222 Igor
 ReceivedData.LoadFromFile(ReceivedFile);

 i:=-1;
 Repeat
  Inc(i,1);
  s:=ReceivedData[i];
  //20210208 Igor >>>
  A := S.Split([AFRStringDelimiter]);
  if Length(A) < 5 then continue;
  SubSection := A[1];

  //Section:=LeftStr(s,45]);
  //SubSection:=MidStr(S,46,35);

  //20160113  RENAME SOME FIELDS INCOMING AND ALSO TddElms.txt and DBF
  If AllTrim(subsection) ='TuitionEducationTextBookAmount' then
  begin
   //ReplaceStr(OriginalString, SubStr, NewStr: string)
   If LeftStr(Section,7)='Federal' then  Subsection:='Fed'+Subsection;
   If LeftStr(Section,10)='Provincial' then  Subsection:='Prov'+Subsection;
   s:=Section+Subsection+MidStr(s,81,200);
   ReceivedData[i]:=s;
  end;

  A := S.Split([AFRStringDelimiter]);
  if Length(A) < 5 then continue;
  DataElmName := AllTrim(A[2]);
  Instance := A[3];
  Value := A[4];

//  DataElmName:=AllTrim(MidStr(S,81,60));
//  Instance:=MidStr(S,141,2);
//  Value:=MidStr(S,144,100);   //20151230 //MidStr(S,144,9);
  If (DataElmName='IndividualTaxpayerIdentifier') and (Value=SIN) then  //sin found
  begin
   For j:=i+1 to ReceivedData.Count-1 do  //keep reading until a new sin found
   Begin
    If j>ReceivedData.Count-1 then Exit;
    s:=ReceivedData[j];
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 5 then continue;
    Section := A[0];
    SubSection := A[1];
    DataElmName := AllTrim(A[2]);
    Instance := A[3];
    Value := A[4];
//    DataElmName:=AllTrim(MidStr(S,81,60));
//    SubSection:=AllTrim(MidStr(S,46,35));
//    Instance:=MidStr(S,141,2);
//    Value:=AllTrim(MidStr(S,144,100)); //20151230 //AllTrim(MidStr(S,144,9));
   //20210208 Igor <<<

    If (DataElmName='IndividualTaxpayerIdentifier') and (Value<>SIN) then Exit;
    ExtractedSinData.Add(ReceivedData[j]);
   // Memo1.Lines.Add(ReceivedData[j]);

    If IsInList(SubSection,ExtractedSinDataGroups)=-1 then //not found in list
    begin
     ExtractedSinDataGroups.Add(AllTrim(Subsection));
    // Memo1.lines.add(subsection);
    end;
   End;
  end;
 Until (i>ReceivedData.Count-1) or (J>ReceivedData.Count-1);

 //20160109
 For i:=0 to ExtractedSinData.count-1 do
 begin
  //Memo1.Lines.add(ExtractedSinData[i]);
 end;
end;


//20151229
Procedure TAutoFillLoginT1_2026.ExtractALLSinSubCodeData(SubSectionCode:String;ExtractedSinData:TStringList;Var ExtractedData:TStringList);
Var i,j:Integer;
     s,Section, SubSection, DataElmName,Instance,Value:String;
     PrevSubSection:String;
     A: TArray<string>; //20210208 Igor
Begin
 PrevSubSection:='';
 For i:=0 to ExtractedSinData.count-1 do
 begin
  s:=ExtractedSinData[i];
  //20210208 Igor >>>
  A := S.Split([AFRStringDelimiter]);
  if Length(A) < 5 then continue;
  Section := A[0];
  SubSection := A[1];
  DataElmName := AllTrim(A[2]);
  Instance := A[3];
  Value := A[4];
  //Section:=LeftStr(s,45];
//  SubSection:=AllTrim(MidStr(S,46,35));
//  DataElmName:=AllTrim(MidStr(S,81,60));
//  Instance:=AllTrim(MidStr(S,141,2));
//  Value:=AllTrim(MidStr(S,144,100)); //AllTrim(MidStr(S,144,9)); //20160101
  If SubSection>PrevSubSection then
  Begin
   If PrevSubSection>'' then  ExtractedData.Add('            ');
   ExtractedData.Add(UpperCase(SubSection));
   PrevSubSection:=SubSection;
  end;
  ExtractedData.Add(DataElmName + AFRStringDelimiter +
                    Instance + AFRStringDelimiter +
                    Value)
  //20210208 Igor <<<
 end;
end;


//20151229   This button was added to be able to test with existing tXT file without connecting to CRA
procedure TAutoFillLoginT1_2026.LoadSinDataBtnClick(Sender: TObject);
Var i:Integer; ReceivedFile:String;SubSectionCode:String;
begin
 //LoadSindata(Sin)
end;

procedure TAutoFillLoginT1_2026.LoadReceivedDataBtnClick(Sender: TObject);
Var i:Integer; ReceivedFile:String;SubSectionCode:String;
Msg:String;
begin

 cTDDReceivedTxtFileName:=TestCasesReceivedBox.Text;  //only for test
 {
 ReceivedFile:=TddFilesDir + '\' + cTDDReceivedTxtFileName;
 ReceivedData:=TStringList.Create;
 ReceivedData.LoadFromFile(ReceivedFile);
 }
 //If ReceivedData.count<5 then Begin ShowMessage('No Data Received');Screen.Cursor:=crDefault;exit;end;   //20160107
 Screen.Cursor:=crDefault; //20170306 Igor
 BreakReceivedDataBySIN(ReceivedFile);
 Msg:='Data received from CRA'
   +#13+'You can close the CRA WEB-Page.'; //20170306 Igor

 If TddSinsReceived.count=1 then
 Begin
    Msg:=Msg+Chr(13)+'Now select the return, right click on any form and select AutoFill';
    ShowMessage(Msg);
 end
 Else  //multiple received
 Begin
    MainFormT1.ShowTddStatus;
    Msg:=' Data for multiple returns received.'
      +Chr(13)+'Now select a return, right click on any form and select AutoFill';
    ShowMessage(Msg);
 end;

 //ShowMessage('Now right click any form of a return and select AutoFill');
 //MainForm.RequestForAutofill(RNo);

 Close;  //20160110
 // LoadReceivedData;    ???
// CreateReceivedFilesBySin(SinsReceived);  //20160109
// PageControl1.ActivePage:=Tabsheet2;
end;

//20151229  NEW routines
Procedure TAutoFillLoginT1_2026.GetSINSReceived(ReceivedFile:String;Var TddSinsReceived:TStringList);
Var i:Integer;s, Sin, FoundNotFound,DataElmName, value:String;
    A: TArray<string>; //20210208 Igor
begin
 ReceivedData:=TStringList.Create;
 ReceivedData.LoadFromFile(ReceivedFile);
 i:=-1;
 DataElmName:='';
 Repeat
  Inc(i,1);
  If (i>ReceivedData.count-1) or (i>46) then begin freeAndNil(ReceivedData){ReceivedData.Free};exit;end;  //more than enough //20160125 Igor
  s:=ReceivedData[i];
  //20210208 Igor >>>
  A := S.Split([AFRStringDelimiter]);
  if Length(A) < 5 then continue;
  DataElmName := A[2];
  Value := A[4];
  If DataElmName='ReferencedIndividualTaxpayerIdentifier' then
  begin
    Sin:=Value;

    Inc(i,1);  //read next to get the Found or any other such as NO-DATA response
    s:=ReceivedData[i];
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 5 then continue;
    DataElmName := A[2];
    Value := A[4];
    FoundNotFound:=value;
    if UpperCase(FoundNotFound)='FOUND' then
    begin
      TddSinsReceived.Add(Sin+' '+PaddR(FoundNotFound,10)+' '+'TDD Received. Not Auto-filled My Return yet');
    end
    else if UpperCase(FoundNotFound)='NO_DATA' then
    begin
    //20160123
    {
    if find no_data then there is no data for that sin, need to change/ignore when processing multiple returns,
    for single return seems ok (other than error in freeing stringlist that I commented/documented) altho its by accident / not coded appropriately
    }
     TddSinsReceived.Add(Sin+' '+PaddR(FoundNotFound,10)+' '+'TDD Received. Not Auto-filled yet');  //20160123 CON
     ShowMessage('SIN '+sin+' '+GetFirstName(RNo)+' '+GetLastName(RNo)+Chr(13)+'No data found by CRA for this SIN');
    end
    else
    begin
     //ShowMessage('SIN '+sin+' maybe incorrect. No data returned by CRA');
     RNo:=GetRetNoFromSin(SIN);  //20160102
     //20160107
     If RNo>0 then
      ShowMessage('SIN '+sin+' '+GetFirstName(RNo)+' '+GetLastName(RNo)
      +Chr(13)+'maybe incorrect or not in CRA server. No data returned by CRA');
    end;
  end;

  //Section:=LeftStr(s,45];
  //SubSection:=MidStr(S,46,35);
  //DataElmName:=AllTrim(MidStr(S,81,60));
  //Instance:=MidStr(S,141,2);


  //If i>46 then begin ReceivedData.Free;exit;end;  //more than enough
 // If (i>ReceivedData.count-1) or (i>46) then begin ReceivedData.Free;exit;end;  //more than enough
  (*DataElmName:=AllTrim(MidStr(S,81,60));
  If DataElmName='ReferencedIndividualTaxpayerIdentifier' then
  begin
    Value:=MidStr(S,144,9);
    Sin:=Value;

    Inc(i,1);  //read next to get the Found or any other such as NO-DATA response
    s:=ReceivedData[i];
    DataElmName:=AllTrim(MidStr(S,81,60));
    Value:=MidStr(S,144,9);
    FoundNotFound:=value;
    if UpperCase(FoundNotFound)='FOUND' then
    begin
      TddSinsReceived.Add(Sin+' '+PaddR(FoundNotFound,10)+' '+'TDD Received. Not Auto-filled My Return yet');
    end
    else if UpperCase(FoundNotFound)='NO_DATA' then
    begin
    //20160123
    {
    if find no_data then there is no data for that sin, need to change/ignore when processing multiple returns,
    for single return seems ok (other than error in freeing stringlist that I commented/documented) altho its by accident / not coded appropriately
    }
     TddSinsReceived.Add(Sin+' '+PaddR(FoundNotFound,10)+' '+'TDD Received. Not Auto-filled My Return yet');  //20160123 CON
     ShowMessage('SIN '+sin+' '+GetFirstName(RNo)+' '+GetLastName(RNo)+Chr(13)+'No data found by CRA for this SIN');
    end
    else
    begin
     //ShowMessage('SIN '+sin+' maybe incorrect. No data returned by CRA');
     RNo:=GetRetNoFromSin(SIN);  //20160102
     //20160107
     If RNo>0 then
      ShowMessage('SIN '+sin+' '+GetFirstName(RNo)+' '+GetLastName(RNo)
      +Chr(13)+'maybe incorrect or not in CRA server. No data returned by CRA');
    end;
  end;*)
  //20210208 Igor <<<
 until (i>ReceivedData.count-1) or (i>46);
end;

//20160721 igor
//procedure TAutoFillLoginT1_2026.OpenTheTddElmsTable;
//begin
////20160721 Igor >>>
//  TddElmsConnection := TADConnection.Create(nil);
//  TddElmsTable := TADTable.Create(nil);
//  if not SetTableName(TddElmsConnection, TddElmsTable, TddElmsDBLite, TddElmsTableLite, 'FieldKey') then
//  begin
//    freeAndNil(TddElmsConnection);
//    freeAndNil(TddElmsTable);
//  end;
//
//
//// TddElmsTable := TTable.Create(Application);
//// TddElmsTable.DataBaseName := AppDir;
//// TddElmsTable.TableName := 'TddElms.dbf';
//// TddElmsTable.IndexName := 'FieldKey';      //Subsection-and-data element
//// If TddElmsTable.Active then TddElmsTable.Close;
//// If not TddElmsTable.Active then TddElmsTable.Open;
////20160721 Igor<<<
//end;






Function TAutoFillLoginT1_2026.CountReturnsToSubmit:Integer;
Var i:Integer;
Begin
 Result:=0;
 For i:=0 to TddRetList.Items.count-1 do
 begin
  If TddRetList.checked[i]=True then Result:=Result+1;
 end;
end;

Procedure TAutoFillLoginT1_2026.UpdateTddStatus(Sin:String);
Var i:Integer;s:String;
Begin
 For i:=0 to TddSinsReceived.count-1 do
 Begin
  s:=TddSinsReceived[i];
  If sin=LeftStr(s,9) then
  Begin
   s:=Leftstr(s,10)+'Auto-filled My Return. Not saved yet';
  end;
 end;
End;

(*
Procedure TAutoFillLogin.ShowTddStatus;
Var i:Integer;s:String;
Begin
 MainForm.ShowTddStatus;
End;
*)

procedure TAutoFillLoginT1_2026.StatusBtnClick(Sender: TObject);
begin
 MainFormT1.ShowTddStatus;
end;

procedure TAutoFillLoginT1_2026.ClearTDDRetListBtnClick(Sender: TObject);
begin
 If TddRetList.Items.count>0 then
 Begin
  if MessageDlg('Are you sure you want to remove them from the list?'
    +Chr(13)+'You could also un-check them to prevent submission to CRA',
     mtInformation, [mbYes, mbNo], 0) = mrYes then
        TddRetList.Items.clear;
 End;
end;

procedure TAutoFillLoginT1_2026.Exit2BtnClick(Sender: TObject);
begin
 ExitBtn1Click(Sender);  //20160107
end;

Procedure TAutoFillLoginT1_2026.SaveSinData(RNo:Integer;Sin:String;ExtractedSinData:TStringList);
Var i:Integer;FlName:String;
Begin
 If (RNo=0)then
 begin
  ShowMessage('Return number '+ IntToStr(RNo)+' not found');
  Exit;
 end;
 FlName:=MkTddFileName(RNo,Sin);
 {
 Memo1.Lines.add('-------------------------------');
 Memo1.Lines.Add(FlName+' '+GetLastName(RNo)+' '+GetFirstName(RNo));
 For i:=0 to ExtractedSinData.count-1 do Memo1.Lines.Add(ExtractedSinData[i]);
 }
 ExtractedSinData.SaveToFile(flName);
 //20220510 Igor >>>
 try
    CreateT5008Excel(flName, GenerateT5008ExcelFile(RNo));
 except on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
 end;
 //20220510 Igor <<<
end;



function TAutoFillLoginT1_2026.SelectedSins: string;
var I: integer;
    ParmsList: TStringList;
begin
  ParmsList := TStringList.Create;
  try
    for I := 0 to TDDRetList.Items.Count - 1 do
      if TddRetList.Checked[I] = True then
        ParmsList.Add(TddRetList.Items[I]);
    Result := ParmsList.Text;
  finally
    FreeAndNil(ParmsList);
  end;
end;

Procedure TAutoFillLoginT1_2026.BreakReceivedDataBySIN(ReceivedFile:String);
Var i:Integer;
FoundNotFound:String;  //20160123 Con
Begin
 //20160109
 ReceivedData:=TStringList.Create;
 TddSinsReceived.Clear;  //20160109
 ExtractedSinData:=TStringList.Create;

 ReceivedFile:=OptRec.Dir_AutoFill + '\' + cTDDReceivedTxtFileName;  //'TddReceived-First10.txt'; //changed constant in the beginning to do a test //20151229 //20170222 Igor

  //20160213 //20160216 Igor
 If FileExists(ReceivedFile)=false then
 Begin
  ShowMessage('File '+ReceivedFile+' not found');
  Exit;
 end;

 ReceivedData.LoadFromFile(ReceivedFile);


{       //20160123 this is wrong
 If ReceivedData.count<5 then
 Begin
   ShowMessage('No Data Received.'+Chr(13)+'CRA does not have data for this taxpayer');   //20160122
   Screen.Cursor:=crDefault;
   exit;
 end;   //20160107
}
 (*
//20160123 file is always returned, even when there is an error, most likely always only one line
 If ReceivedData.count=1 then
 Begin
   ShowMessage(ReceivedData[0]);   //20160122
   Screen.Cursor:=crDefault;
   exit;
 end;
*)
 GetSINSReceived(ReceivedFile,TddSinsReceived);  //sins and found codes
 RemoveSinsWithNoData(TddSinsReceived);   //20160125 CON //20160216 Igor
 For i:=0 to TddSinsReceived.count-1 do
 Begin
   SIN:=LeftStr(TddSinsReceived[i],9);
   FoundNotFound:=AllTrim(MidStr(TddSinsReceived[i],10,10)); //20160123  CON
   //20160123
   If FoundNotFound='NO_DATA' then  //20160123
    //do nothing
   Else
   Begin
    RNo:=GetRetNoFromSin(SIN);
    ExtractSinData(ReceivedFile,SIN,ExtractedSinData);  //start with first SIN/tab and also the groups of data (subsection)
    If RNo>0 then SaveSinData(RNo,Sin,ExtractedSinData);
   End;
 end;

 //ReceivedData.Free;         //20160123 fails when there is a single return response that has no data //20160125 Igor
 //ExtractedSinData.Free;
 freeAndNil(ReceivedData); //20160125 Igor
 freeAndNil(ExtractedSinData);

 (*
 //20160123  CON
 If ReceivedData<>Nil then
    ReceivedData.Free;
 If ExtractedSinData<>Nil then
    ExtractedSinData.Free;
 {
 ReceivedData.Free;         //20160123 fails when there is a single return response that has no data
 ExtractedSinData.Free;
 }
 //SinsReceived:=Free;
 //RenamedFile(ReceivedFile)  ????  20160110
 *)
end;

//20160123
Procedure TAutoFillLoginT1_2026.RemoveSinsWithNoData(Var TddSinsReceived:TStringList);
Var i:Integer; FoundNotFound:String;
TempList:TstringList;
begin
 TempList:=TStringList.create;
 for i:=0 to TddSinsReceived.Count - 1 do
 Begin
  FoundNotFound:=AllTrim(MidStr(TddSinsReceived[i],10,10));
  If FoundNotFound<>'NO_DATA' then Templist.add(TddSinsReceived[i]);
 end;

 TddSinsReceived.Clear;
 For i:=0 to TempList.count-1 do TddSinsReceived.add(Templist[i]);
 //TempList.Free;
 freeAndNil(TempList); //20160125 Igor
end;

procedure TAutoFillLoginT1_2026.UncheckBtnClick(Sender: TObject);  //20160123
Var i:Integer;
begin
  For i:=0 to TddRetList.Items.count-1 do TddRetList.checked[i]:=False;
end;

Procedure TAutoFillLoginT1_2026.LoadTddErrorCodes(Var TddErrorCodes:TStringList);
Begin
 TddErrorCodes:=TStringList.Create;
 TddErrorCodes.Add('10  NOT_READY The tax data is not ready, waiting and making another call');
 TddErrorCodes.Add('201 INVALID_REQUEST The request for tax data is not structured properly');
 TddErrorCodes.Add('202 INVALID_SP_ID The SPID provided is invalid. Currently not used');
 TddErrorCodes.Add('203 INVALID_TAX_YEAR The tax year provided is invalid');
 TddErrorCodes.Add('204 INVALID_TOKEN The token provided is invalid. The token is mandatory input');
 TddErrorCodes.Add('501 SERVICE_UNAVAILABLE The system is currently unavailable. Please refer to times of operation');
 TddErrorCodes.Add('502 SYSTEM_BUSY The system is too busy. Please retry later');
 TddErrorCodes.Add('503 SYSTEM_ERROR A system error occurred. This could be a temporary condition. A retry may be successful');
End;

Procedure TAutoFillLoginT1_2026.ShowTddErrorCode(S:String);  //20160124
Var i:Integer; ErrCode, Description:String;
Begin
 ErrCode:=PaddR(MidStr(s,144,3),3);
 For i:=0 to TddErrorCodes.count-1 do
 Begin
  If ErrCode=LeftStr(TddErrorCodes[i],3) then begin Description:=MidStr(TddErrorCodes[i],4,100);Break;end
 end;
 ShowMessage('Request for data failed with TDD Error code '+Errcode +Chr(13)+Description);
end;
 //20160216 Igor
procedure TAutoFillLoginT1_2026.CRAAutoFillBtnClick(Sender: TObject);
begin
 //20160211
  MainFormT1.IntroductionbyCRA1Click(Application);
end;


 //20160216 Igor
procedure TAutoFillLoginT1_2026.VtAutofillBtnClick(Sender: TObject);
begin
   //20160211
 MainFormT1.HelpByVisualTax1Click(Application);
 // ConnectToWeb('www.visualtax.com/Autofill-Guide.pdf/');  //20160211
end;


procedure TAutoFillLoginT1_2026.wbStartBeforeNavigate2(ASender: TObject; //20230131 Igor
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if FSkipLinkIntercept then Exit;
  Cancel := true;
  ConnectToWeb(URL);
end;

(*
procedure TAutoFillLogin.RenameTheFile(ReceivedFile:String);  //20160213
Var OldFileNameOnly,Timesuffix, Ext:String;
Begin
 DotPos:=Pos(ReceivedFile,'.');
 If DotPos<0 then
   OldFileNameOnly:=ReceivedFile
 Else
   OldFileNameOnly:=LeftStr(ReceivedFile,DotPos-1);
 Ext:=ExtractFileExt(receivedFile);

 Result:=OldFileNameOnly+'-'+GetTimeSuffix+Ext;
end;
*)
end.
