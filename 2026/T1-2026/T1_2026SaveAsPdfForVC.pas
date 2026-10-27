Unit T1_2026SaveAsPdfForVC;

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DBCtrls,
  Printers, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, Vcl.Mask, vteditbox, vtLabel, vtShape,
  ShellApi, // 20200425
  ClipBrd, // 20200428
  Data.DBXJSON, //20210319 Igor
  //vcl.FileCtrl,   //20200429
  vtPDFPrinter, Vcl.CheckLst{, IPPeerClient, Data.Cloud.CloudAPI, Data.Cloud.AmazonAPI}; // 20200424 //20220302 Igor

 type
  TSaveAsPdfForVCT1_2026 = class(TForm)
    vtShape3: TvtShape;
    vtShape4: TvtShape;
    vtLabel42: TvtLabel;
    FolderName: TvtEdit;
    vtLabel9: TvtLabel;
    CreatePdfBtn1: TBitBtn;
    vtShape1: TvtShape;
    CancelBtn: TBitBtn;
    DocName1: TvtEdit;
    vtLabel10: TvtLabel;
    RecipientEmail: TvtEdit;
    RecipientSalutation: TvtEdit;
    vtLabel11: TvtLabel;
    vtLabel4: TvtLabel;
    MapiEmailBox: TCheckBox;
    PrintDialog1: TPrintDialog;
    FlowPanel1: TFlowPanel;
    vtShape2: TvtShape;
    vtLabel5: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel20: TvtLabel;
    ListBox2: TListBox;
    CreatePdfBtn2: TBitBtn;
    DocName2: TvtEdit;
    ListBox3: TListBox;
    EmailPdfBtn2: TButton;
    AddAllBtn: TBitBtn;
    RemoveAllbtn: TBitBtn;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    DirGroup: TRadioGroup;
    vtLabel1: TvtLabel;
    vtLabel6: TvtLabel;
    //20210201 Igor >>>
    ShowPDFBtn: TBitBtn;
    vtCourierPdfBtn: TButton;
    vtSignPDFBtn: TButton;
    rbUpload: TRadioButton;
    rbSend: TRadioButton;
    btnAction: TButton;
    //20220302 Igor >>>
    ListBox1: TCheckListBox;
    SelectAllBtn: TBitBtn;
    DeselectAllBtn: TBitBtn;
    //20220302 Igor <<<
    //20210201 Igor <<<
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CreatePdfBtn1Click(Sender: TObject);
    procedure ShowPdfBTN1Click(Sender: TObject);
    procedure ShowPdfBtN2Click(Sender: TObject);
    procedure CreatePdfBtn2Click(Sender: TObject);
    procedure SelectAllBtnClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure RemoveAllBtnoldClick(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure DirGroupClick(Sender: TObject);
    procedure ShowPdfBtn0Click(Sender: TObject);
    Procedure Printit(RetNo: Integer; FName, FullDocName: String);
    procedure FolderNameExit(Sender: TObject);
    procedure RemoveAllBtnClick(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure RemoveOneBtnClick(Sender: TObject);
    //20210201 Igor >>>
    procedure ShowPDFBtnClick(Sender: TObject);
    procedure vtCourierPdfBtnClick(Sender: TObject);
    procedure vtSignPDFBtnClick(Sender: TObject);
    //20210426 Igor >>>
    procedure rbUploadClick(Sender: TObject);
    procedure btnActionClick(Sender: TObject);
    //20210426 Igor <<<
    //20210201 Igor <<<
   // Procedure PrintWithPdfFactory(RetNo:Integer;FormsToPrint:TStrings);
  private
    { Private declarations }
    FRetNo: Integer;
    //20210419 Igor >>>
    FTaxPayerCyberId: string;
    FEmail: string;
    procedure InitTaxPayer;
    //20210419 Igor <<<
  public
    property RetNo: Integer read FRetNo;
    { Public declarations }
  end;


 var
  SaveAsPdfForVCT1_2026: TSaveAsPdfForVCT1_2026;
  PDF: TvtPDFPrinter;
  // for Email
  SomeSubject, SomeRecipientEMail, SomeSenderEMail, SomeAttachment,
    SomeText: String;
  SomeSalutation: String;
  FullDocName0, FullDocName1, FullDocName2: String;
  DocNameSuffix:String;
  DocTaxPayerId:String;
  //for sorting
  PrintSeqList:TStringList;  //20200504
  UnsortedList:TstringList;
  SortedList:TstringList;
  FormsToPrint:Tstrings;  //20200516
implementation

{$R *.dfm}

Uses
  vtMulti, vtCommon, vtDialogs, vtMain,
  T1_2026, T1_2026Declare, T1_2026Common, T1_2026Cpl,
  T1_2026Common2, T1_2026TrimStr, T1_2026GetFile, T1_2026T1Rtns, T1_2026T1Rtns2,
  T1_2026FpFind, T1_2026AdvFnd, T1_2026Calc, T1_2026Print, T1_2026ChildWinNew,
  T1_2026Main, T1_2026ChartClients,
  MAPI,T1_2026printReturnFrm,
  vtVirtualTaxOffice, //20210115 Igor
  vtTrimStr, vtShared, vtDataBase, // 20150826 IGOR
  vtCourier, //20210201 Igor
  vtEditHTML, //20220202 Igor
  vtFileStorage, Variants; // 20160422 Igor

procedure TSaveAsPdfForVCT1_2026.RemoveAllBtnClick(Sender: TObject);
begin
ListBox3.Items.Clear;
end;

procedure TSaveAsPdfForVCT1_2026.RemoveAllBtnoldClick(Sender: TObject);
begin
  ListBox3.Items.Clear;
end;

procedure TSaveAsPdfForVCT1_2026.RemoveOneBtnClick(Sender: TObject);
begin
ListBox3DblClick(Sender)
end;



procedure TSaveAsPdfForVCT1_2026.btnActionClick(Sender: TObject); //20210426 Igor
begin
  if rbUpload.Checked then
    vtSignPDFBtn.Click
  else
    vtCourierPdfBtn.Click;
end;

procedure TSaveAsPdfForVCT1_2026.CreatePdfBtn1Click(Sender: TObject);
Var
  i: Integer;
  FName: String;
  HasSelected: boolean;//20220302 Igor
begin
  //20220302 Igor >>>
  HasSelected := false;
  for i := 0 to ListBox1.Count - 1 do
    if ListBox1.Checked[i] then
      HasSelected := true;
  if not HasSelected then
  begin
    ShowMessageError('Please, select at least one form in the list');
    Exit;
  end;
  //20220302 Igor <<<
  FullDocName1 := FolderName.Text + '\' + DocName1.Text; //20210201 Igor
  {
  if PdfDriverGroup.ItemIndex=0 then
  Begin
   FormsToPrint:=ListBox1.items;
   PrintWithPdfFactory(RetNo,FormsToPrint);
   Exit;
  End;
  }
  //20210202 Igor >>>
  if FileExists(FullDocName1) then
    DeleteFile(PChar(FullDocName1));
  if FileExists(FullDocName1) then
  begin
    ShowMessageError('File '+ FullDocName1 + ' cannot be deleted. Probably, it is opened in your PDF program. Please, close it and try again');
    Exit;
  end;
  //20210202 Igor <<<
  PDF := TvtPDFPrinter.Create(AppT1_2026);
  Try
    for i := 0 to ListBox1.Items.count - 1 do
    Begin
      if not ListBox1.Checked[i] then continue; //20220302 Igor
      FName := ListBox1.Items[i];
      PDF.PrintForm(RetNo, FName, 99, T1_2026Print.AfterReadComponentForPrint,
        T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
        T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
    end;
     PDF.SaveToFile(FullDocName1, false);
     //20210201 Igor >>>
     ShowMessage('The following pdf '+ ExtractFileName(FullDocName1) +
                 ' was created and saved in the '+ ExtractFilePath(FullDocName1) +
                 ' folder. Please Review them before Emailing them');
     //20210201 Igor <<<
    {
    if FileExists(FullDocName1) then  //20200517
    Begin
      if MessageDlg(FullDocName1+' already exists. Replace it?', mtInformation, [mbYes, mbNo], 0) = mrYes then
      Begin  PDF.SaveToFile(FullDocName1, false);
         ShellExecute(Application.Handle, 'open', Pchar('' + FullDocName1), Nil, Nil, Sw_Show);
      End
      Else
     //do nothing
    End
    Else
    Begin
      PDF.SaveToFile(FullDocName1, false);
      ShellExecute(Application.Handle, 'open', Pchar('' + FullDocName1), Nil, Nil, Sw_Show);
    End;
    }
  Finally
    PDF.Free;
    //ShellExecute(Application.Handle, 'open', Pchar('' + FullDocName1), Nil, Nil, Sw_Show); //20210201 Igor
  End;

end;

procedure TSaveAsPdfForVCT1_2026.CreatePdfBtn2Click(Sender: TObject);
Var
  i: Integer;
  FName: String;
begin
  if ListBox3.Items.count <= 0 then
  Begin
    ShowMessage
      ('No forms selected.  Use Select ALL or Double click desired forms');
    Exit;
  End;
  FullDocName2 := FolderName.Text + '\' + DocName2.Text; //20210202 Igor
  {
  if PdfDriverGroup.ItemIndex=0 then
  Begin
    FormsToPrint:=ListBox3.items;
    PrintForms(RetNo,FormsToPrint);
    PrintWithPdfFactory(RetNo,FormsToPrint);
   Exit;
  End;
  }


  PDF := TvtPDFPrinter.Create(AppT1_2026);
  Screen.Cursor := CrHourGlass;
  Try
    for i := 0 to ListBox3.Items.count - 1 do
    Begin
      FName := ListBox3.Items[i];
      PDF.PrintForm(RetNo, FName, 99, T1_2026Print.AfterReadComponentForPrint,
        T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
        T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
    end;
    PDF.SaveToFile(FullDocName2, false);
  Finally
    PDF.Free;
    Screen.Cursor := CrDefault;
    ShellExecute(Application.Handle, 'open', Pchar('' + FullDocName2), Nil,Nil, Sw_Show);
  End;
end;

procedure TSaveAsPdfForVCT1_2026.DirGroupClick(Sender: TObject);
begin
  //20210202 Igor >>>
  if DirGroup.ItemIndex = 0 then
    FolderName.Text := OptRec.Dir_ClientDocs + '\' + GetLastName(RetNo) + ',' +
      GetFirstName(RetNo)
  Else
    FolderName.Text := 'C:\Downloads';
  //20210202 Igor <<<
  ForceDirectories(FolderName.Text);
end;

procedure TSaveAsPdfForVCT1_2026.FormCreate(Sender: TObject);
begin
  FRetNo := GetCurrentRetNo;
  DocTaxPayerId:=LeftStr(GetLastName(RetNo),3)+' '+LeftStr(GetFirstName(RetNo),1);
  DocNameSuffix:='.PDF'; //20200504
  PrintSeqList:=TstringList.Create;
  if FileExists(AppDir+'\'+'PrintSeq.txt') then //20210202 Igor
    PrintSeqList.LoadFromFile(AppDir+'\'+'PrintSeq.txt') //20210202 Igor
  Else
   ShowMessage('Print Sequence has not been defined. Exit and click Menu item Configure -> Print Sequence');
end;

procedure TSaveAsPdfForVCT1_2026.InitTaxPayer; //20210419 Igor
begin
  FRetNo := GetCurrentRetNo;
  If FRetNo = 0 then
  begin
    ShowMessage('Open return first');
    exit;
  end;
  FEmail := FetchElm(FRetNo,'INFO', 140);
  if FEmail.IsEmpty then
  begin
    ShowMessage('Please, enter email first in INFO form');
    exit;
  end;
  FTaxPayerCyberId := VirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(FEmail);
end;

procedure TSaveAsPdfForVCT1_2026.ListBox2Click(Sender: TObject);
begin
 ListBox2DblClick(Sender);
end;

procedure TSaveAsPdfForVCT1_2026.ListBox2DblClick(Sender: TObject);
Var
  k: Integer;
begin
  k := ListBox2.ItemIndex;
  if k >= 0 then
    ListBox3.Items.Add(ListBox2.Items[k]);
end;

procedure TSaveAsPdfForVCT1_2026.ListBox3DblClick(Sender: TObject);
Var
  k: Integer;
begin
  k := ListBox3.ItemIndex;
  if k >= 0 then
    ListBox3.Items.delete(k);
end;

procedure TSaveAsPdfForVCT1_2026.SelectAllBtnClick(Sender: TObject);
Var
  i: Integer;
begin
  //20220302 Igor >>>
  {ListBox3.Items.Clear;
  for i := 0 to ListBox2.Items.count - 1 do
  Begin
    ListBox3.Items.Add(ListBox2.Items[i]);
  End;}
  for i := 0 to ListBox1.Count - 1 do
    ListBox1.Checked[i] := Sender = SelectAllBtn;
  //20220302 Igor <<<
end;

procedure TSaveAsPdfForVCT1_2026.ShowPdfBtn0Click(Sender: TObject);
begin
  if Not DirectoryExists(FolderName.Text) then
  Begin
    ShowMessage('Folder ' + FolderName.Text + ' does not exist');
    Exit;
  end;

  if Not FileExists(FullDocName0) then
  Begin
    ShowMessage('File ' + FullDocName0 + ' does not exist');
    Exit;
  end;
  ShellExecute(Application.Handle, 'open', Pchar(FullDocName0), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TSaveAsPdfForVCT1_2026.ShowPdfBTN1Click(Sender: TObject);
begin
  if Not DirectoryExists(FolderName.Text) then
  Begin
    ShowMessage('Folder ' + FolderName.Text + ' does not exist');
    Exit;
  end;

  if Not FileExists(FullDocName1) then
  Begin
    ShowMessage('File ' + FullDocName1 + ' does not exist');
    Exit;
  end;

  ShellExecute(Application.Handle, 'open', Pchar(FullDocName1), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TSaveAsPdfForVCT1_2026.ShowPdfBtN2Click(Sender: TObject);
begin
  if Not DirectoryExists(FolderName.Text) then
  Begin
    ShowMessage('Folder ' + FolderName.Text + ' does not exist');
    Exit;
  end;

  if Not FileExists(FullDocName2) then
  Begin
    ShowMessage('File ' + FullDocName2 + ' does not exist');
    Exit;
  end;

  ShellExecute(Application.Handle, 'open', Pchar(FullDocName2), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TSaveAsPdfForVCT1_2026.ShowPDFBtnClick(Sender: TObject); //20210201 Igor
begin
  if Not DirectoryExists(FolderName.Text) then
  Begin
    ShowMessage('Folder ' + FolderName.Text + ' does not exist');
    Exit;
  end;

  if FullDocName1.IsEmpty then
  Begin
    ShowMessage('You need to create pdf');
    Exit;
  end;

  if Not FileExists(FullDocName1) then
  Begin
    ShowMessage('File ' + FullDocName1 + ' does not exist');
    Exit;
  end;

  ShowMessage('Warning! You should not use any Sign or other buttons on your default PDF viewing program'); //20210205 Igor
  ShellExecute(Application.Handle, 'open', Pchar('' + FullDocName1), Nil, Nil, Sw_Show);
end;

procedure TSaveAsPdfForVCT1_2026.vtCourierPdfBtnClick(Sender: TObject); //20210201 Igor //20210419 Igor
var FFiles: TArray<string>;
begin
  if FullDocName1.IsEmpty then
  Begin
    ShowMessage('You need to create pdf');
    Exit;
  end;

  if Not FileExists(FullDocName1) then
  Begin
    ShowMessage('File ' + FullDocName1 + ' does not exist');
    Exit;
  end;

  SetLength(FFiles, 1);
  FFiles[0] := FullDocName1;

  if VirtualTaxOfficeInfo.AccountType = vtoOffice then
  begin
    InitTaxPayer;
    if FTaxPayerCyberId.IsEmpty then Exit;
    RunCourier(FTaxPayerCyberId, FFiles);
  end
  else
    RunCourier(VirtualTaxOfficeInfo.CyberId, FFiles);
  //20210202 Igor <<<
end;

procedure TSaveAsPdfForVCT1_2026.vtSignPDFBtnClick(Sender: TObject); //20210419 Igor
var FParams, FFiles: TParamList;
    Res: TJSONObject;
    FTaxPayerInfo: TTaxPayer;
    FRequestFileCode, FRequestFileUrl, FBody: string; //20220202 Igor
begin
  if VirtualTaxOfficeInfo.AccountType = vtoNone then
  begin
    ShowMessage('You need to login first!');
    Exit;
  end
  else if VirtualTaxOfficeInfo.AccountType = vtoPayer then
  begin
    ShowMessage('This function is allowed for offices only!');
    Exit;
  end;

  if FullDocName1.IsEmpty then
  Begin
    ShowMessage('You need to create pdf');
    Exit;
  end;

  if Not FileExists(FullDocName1) then
  Begin
    ShowMessage('File ' + FullDocName1 + ' does not exist');
    Exit;
  end;

  InitTaxPayer;
  if FTaxPayerCyberId.IsEmpty then Exit;
  FTaxPayerInfo := VirtualTaxOfficeInfo.GetTaxPayerInfo(FTaxPayerCyberId);

  FParams := TParamList.Create;
  FFiles := TParamList.Create;
  try
    FParams.AddParam('action', 'REQUEST_SIGNATURE_PDF');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('TaxPayerCyberId', FTaxPayerCyberId);
    FParams.AddParam('PdfFileName', ExtractFileName(FullDocName1));
    FFiles.AddParam('PdfFile', FullDocName1);

    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtFiles,false, FFiles);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        FRequestFileCode := GetJSONValue(Res, 'RequestFileCode')
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    FFiles.Free;
    if Assigned(Res) then
      FreeAndNil(Res);
  end;
  if FRequestFileCode = '' then Exit;
  //20220202 Igor >>>
  FRequestFileUrl := 'https://www.virtualofficetower.com/vtSignPDF.php?RequestFileCode='+ FRequestFileCode;
  FBody := '<html><body>';
  FBody := FBody + 'To: '+ FTaxPayerInfo.FirstName + ' ' + FTaxPayerInfo.LastName + '<br><br>';
  FBody := FBody + 'Open this link <a href='+ FRequestFileUrl+'>'+ FRequestFileUrl + '</a> in a browser '+
                   'and sign this pdf with your signature'+ '<br><br>';
  FBody := FBody + VirtualTaxOfficeInfo.GetDoNotAnswerMessage + '<br><br>';
  FBody := FBody + 'Kind regards, '+ '<br>';
  FBody := FBody + VirtualTaxOfficeInfo.GetCurrentName;
  FBody := FBody + '</body></html>';
  if RunEditHTML(FBody) then
    if VirtualTaxOfficeInfo.SendEmail(FTaxPayerInfo.Email, 'PDF Signature Request', FBody) then
      ShowMessageInfo('Email was successfully sent');
  {VirtualTaxOfficeInfo.SendMapiMail('PDF Signature Request',
               FBody,
               '',
               '',
               VirtualTaxOfficeInfo.GetCurrentEmail,
               '',
               FTaxPayerInfo.Email);}
  //20220202 Igor <<<
end;

Procedure TSaveAsPdfForVCT1_2026.Printit(RetNo: Integer; FName, FullDocName: String);
Begin
  {
    PDF := TvtPDFPrinter.Create(AppT1_2026);
    PDF.PrintForm(RetNo,DocName, 99, T1_2026Print.AfterReadComponentForPrint,
    T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
    T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
    PDF.SaveToFile(FullDocName, false);

    //pdffactory
    MainFormT1.StartPrintForm(Retno,FName,99);  //20200428
  }
end;

procedure TSaveAsPdfForVCT1_2026.rbUploadClick(Sender: TObject); //20210426 Igor
begin
  if rbUpload.Checked then
    btnAction.Caption := 'Upload'
  else
    btnAction.Caption := 'Send';
end;

procedure TSaveAsPdfForVCT1_2026.FolderNameExit(Sender: TObject);
begin
 if DirectoryExists(FolderName.text) = false then
 Begin
   if MessageDlg('Folder '+FolderName.text+' does not exist. Create it?',
      mtInformation, [mbYes, mbNo], 0) = mrYes
   then
     FileCtrl.Forcedirectories(FolderName.text);
 End;
end;

procedure TSaveAsPdfForVCT1_2026.FormActivate(Sender: TObject);
Var
  i: Integer;
begin
  UnSortedList:=TStringList.Create;
  SortedList:=TStringList.Create;

  //20210115 Igor >>>
  if IsVtClient then
  begin
    RecipientEmail.Text := VirtualTaxOfficeInfo.TaxOffice.Email;
    if not VirtualTaxOfficeInfo.TaxOffice.Contact.IsEmpty then
      RecipientSalutation.Text := 'Dear ' + VirtualTaxOfficeInfo.TaxOffice.Contact
    else
      RecipientSalutation.Text := 'Dear ' + VirtualTaxOfficeInfo.TaxOffice.Name;
  end
  else
  begin
    RecipientEmail.Text := FetchElm(RetNo, 'INFO', 140);
    if FetchElm(RetNo, 'INFO', 80) > '' then
      RecipientSalutation.Text := 'Dear ' +
        ConvertToProper(FetchElmFNo(RetNo, InfoFNo, 33)) + ' ' +
        ConvertToProper(FetchElmFNo(RetNo, InfoFNo, 80))
    Else
      RecipientSalutation.Text := 'Dear ' +
        ConvertToProper(FetchElmFNo(RetNo, InfoFNo, 33)) + ' ' +
        ConvertToProper(GetFirstName(RetNo));
  end;
  //DirGroup.ItemIndex := 0; //20200517
  DirGroupClick(Sender);
  //20210115 Igor <<<

  DocName1.Text :=GetLastName(retNo) + ','+ GetFirstName(retNo)+' T1-'+AppYear+' (Signature Forms)'+'.PDF'; //20200517
 // DocName1.Text :='Signature Forms'+'-'+DocTaxPayerId + DocNameSuffix;

  FullDocName1 := FolderName.Text + '\' + DocName1.Text; //20210202 Igor

  DocName2.Text :='All Forms'+'-'+DocTaxPayerId+DocNameSuffix;
  FullDocName2 := FolderName.Text + '\' + DocName2.Text; //20210202 Igor

  If Ret[RetNo].FrmHasData[GetFormNo('T183')] then
  Begin
    ListBox1.Items.Add('T183');
    //ListBox1.Items.Add('T183I'); //20210201 Igor
  End;

  If Ret[RetNo].FrmHasData[GetFormNo('T1032')] then
    ListBox1.Items.Add('T1032');
  If Ret[RetNo].FrmHasData[GetFormNo('T1135')] then
    ListBox1.Items.Add('T1135');
  If Ret[RetNo].FrmHasData[GetFormNo('AUTHREP')] then
    ListBox1.Items.Add('AUTHREP');
  If Ret[RetNo].FrmHasData[GetFormNo('CONSENT')] then
    ListBox1.Items.Add('CONSENT');
  If Ret[RetNo].FrmHasData[GetFormNo('T2091')] then // 20200429
    ListBox1.Items.Add('T2091');

  for i := 0 to (FList.count - 1) do
  begin
    FRec := FList.Items[i];
    If Ret[RetNo].FrmHasData[FRec.FormNo] then
    Begin
      if FRec.FormName<>'CUSTINV' then  //should not be in the flist
        ListBox2.Items.Add(FRec.FormName + FRec.FormInst);
    End;
  end;
  // Now sort the ListBox2.items
  for i:=0 to ListBox2.Items.count-1 do UnsortedList.Add(ListBox2.Items[i]);
  SortTaxForms(UnsortedList,PrintSeqList,SortedList);
  ListBox2.items.clear;
  for i:=0 to SortedList.count-1 Do ListBox2.Items.Add(SortedList[i]);
  SelectAllBtnClick(Sender);
end;

end.
