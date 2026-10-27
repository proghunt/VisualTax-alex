unit FP_2027BranchBackOffice;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,Menus,ShellApi,ComCtrls,FileCtrl,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart;
  //20150817 igor


type
  TBranchBackOfficeFP_2012 = class(TForm)
    MainMenu: TMainMenu;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    PrintSetupDialog: TPrinterSetupDialog;
    PrepareEMail1: TMenuItem;
    Email1: TMenuItem;
    Exit1: TMenuItem;
    DownLoad1: TMenuItem;
    Upload1: TMenuItem;
    Import1: TMenuItem;
    ImportFromHO: TMenuItem;
    FromMicrosophic1: TMenuItem;
    Transactions1: TMenuItem;
    Posttransactions1: TMenuItem;
    MFCurrentBalances1: TMenuItem;
    Accounts1: TMenuItem;
    ToDealer1: TMenuItem;
    ExportOrdersToHo: TMenuItem;
    PostLatestPrices1: TMenuItem;
    N5: TMenuItem;
    Import2: TMenuItem;
    Export1: TMenuItem;
    ReviewClients1: TMenuItem;
    DealerButtons: TChart;
    Image3: TImage;
    Image5: TImage;
    Image6: TImage;
    Image1: TImage;
    ImportFromAgentsBtn: TChart;
    ExportToAgentsBtn: TChart;
    Chart1: TChart;
    Label2: TLabel;
    UploadToDealerBtn: TChart;
    TelnetBtn: TImage;
    ReceiveFromAgentsBtn: TChart;
    Image7: TImage;
    ImportFromHOBtn: TChart;
    PrepOrdersBtn: TChart;
    Label3: TLabel;
    Bevel1: TBevel;
    Label4: TLabel;
    Bevel2: TBevel;
    Label6: TLabel;
    Label9: TLabel;
    UpdateBSBtn: TChart;
    UpdateMfPricesBtn: TChart;
    Image2: TImage;
    Image4: TImage;
    Image8: TImage;
    Image9: TImage;
    TrustReconciliationBtn: TChart;
    Splitter1: TSplitter;
    TransmitToAgentsBtn: TChart;
    Image10: TImage;
    FromAgentsOrDealer: TMenuItem;
    DownloadFromDealerBtn: TChart;
    Image11: TImage;
    ExportorganizationToAgents: TMenuItem;
    ExportotherfilesToHO: TMenuItem;
    Label1: TLabel;
    Bevel3: TBevel;
    ExportFundCoresponsesToAgents: TMenuItem;
    N4: TMenuItem;
    ExportOtherFilesToAgents: TMenuItem;
    N1: TMenuItem;
    ImportFromAgents: TMenuItem;
    ImportFromBranch: TMenuItem;
    N6: TMenuItem;
    TrustAccountReconciliation1: TMenuItem;
    ImportFromAgentsFlag: TImage;
    ImportFromHOFlag: TImage;
    FileListBox1: TFileListBox;
    N7: TMenuItem;
    ClientSatements1: TMenuItem;
    Exportfullclientdata1: TMenuItem;
    ImportFundDatafromFundserv1: TMenuItem;
    BackUp1: TMenuItem;
  end;

var
  BranchBackOffice: TBranchBackOfficeFP_2012;

implementation

uses vtCommon,FP_2027,FP_2027Declare,FP_2027TrimStr,FP_2027TrustReconciliation,
{$IFDEF ADO}
  FP_2012Transactions,FP_2012ImportFSFiles,FP_2012StatementsForm,
  FP_2012FundBase,FP_2012Accounts,FP_2012Organization,FP_2027TablesF,
{$ELSE}
{$ENDIF}
  FP_2027PopList,FP_2027FsOutFiles,FP_2027Commissions,FP_2027PostTransactions,
  FP_2027PostPrices,FP_2027CurrentPortfolio,FP_2027ExportOrders,
  FP_2027ImportIncomingFiles,FP_2027ExportClient,FP_2027ClientBook,
  FP_2027ExportOrganization,FP_2027ExportOther,FP_2027ProcessFsFunds,
  FP_2027Main;

{$R *.DFM}

(*
procedure TBranchBackOffice.FormCreate(Sender: TObject);
begin
  WhichModule := 'B';
  PaintMailFlags;
  Application.OnHint := ShowHint;

  With Series1 do
  begin
  {Series1.FillSampleValues(30);}
   Add(0,'',clTeeColor);
   Add(2,'',clTeeColor);
   Add(3,'',clTeeColor);
   Add(5,'',clTeeColor);
   Add(7,'',clTeeColor);
   Add(6,'',clTeeColor);
   Add(9,'',clTeeColor);
   Add(8,'',clTeeColor);
   Add(9,'',clTeeColor);
   Add(11,'',clTeeColor);
   Add(8,'',clTeeColor);
   Add(12,'',clTeeColor);
  end;

  {
  FastLineSeries1.FillSampleValues(20);
  FastLineSeries2.FillSampleValues(20);
  }
end;
*)
(*
procedure TBranchBackOffice.ShowHint(Sender: TObject);
begin
  {StatusLine.Caption := Application.Hint;}
end;

procedure TBranchBackOffice.FileNew(Sender: TObject);
begin
  { Add code to create a new file }
end;

procedure TBranchBackOffice.FileOpen(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    { Add code to open OpenDialog.FileName }
  end;
end;

procedure TBranchBackOffice.FileSave(Sender: TObject);
begin
   { Add code to save current file under current name }
end;

procedure TBranchBackOffice.FileSaveAs(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    { Add code to save current file under SaveDialog.FileName }
  end;
end;

procedure TBranchBackOffice.FilePrint(Sender: TObject);
begin
  if PrintDialog.Execute then
  begin
    { Add code to print current file }
  end;
end;

procedure TBranchBackOffice.FilePrintSetup(Sender: TObject);
begin
  PrintSetupDialog.Execute;
end;

procedure TBranchBackOffice.FileExit(Sender: TObject);
begin
  Close;
end;

procedure TBranchBackOffice.EditUndo(Sender: TObject);
begin
  { Add code to perform Edit Undo }
end;

procedure TBranchBackOffice.EditCut(Sender: TObject);
begin
  { Add code to perform Edit Cut }
end;

procedure TBranchBackOffice.EditCopy(Sender: TObject);
begin
  { Add code to perform Edit Copy }
end;

procedure TBranchBackOffice.EditPaste(Sender: TObject);
begin
  { Add code to perform Edit Paste }
end;

procedure TBranchBackOffice.WindowTile(Sender: TObject);
begin
  Tile;
end;

procedure TBranchBackOffice.WindowCascade(Sender: TObject);
begin
  Cascade;
end;

procedure TBranchBackOffice.WindowArrange(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TBranchBackOffice.HelpContents(Sender: TObject);
begin
  Application.HelpFile := AppDir+'\'+'FPHelp.HLP';
 Application.HelpCommand(HELP_CONTENTS, 0);
end;


procedure TBranchBackOffice.Layouts1Click(Sender: TObject);
begin
{
Application.CreateForm(TLayouts,Layouts);
Layouts.ShowModal;
Layouts.Free;
}
end;

procedure TBranchBackOffice.FundServeFileNames1Click(Sender: TObject);
begin
{
Application.CreateForm(TFSFileTypes,FSFileTypes);
FSFileTypes.ShowModal;
FSFileTypes.Free;
}
end;

procedure TBranchBackOffice.CreateOrder1Click(Sender: TObject);
begin
{
Application.CreateForm(TOrderSetUp,OrderSetUp);
OrderSetUp.ShowModal;
OrderSetUp.Free;
}
end;


procedure TBranchBackOffice.BackOffice1Click(Sender: TObject);
Var h:THandle;
begin
end;

procedure TBranchBackOffice.ProcessFundServAcknowledgements1Click(Sender: TObject);
begin
 ExecuteForm(TImportFSFiles);
end;
*)
(*
procedure TBranchBackOffice.SetupDealernetwork1Click(Sender: TObject);
begin
If LicenseLevel <> 'FP Dealer' then
 begin
  ShowMessage('Option availably only in multi-office licenses');
  exit;
 end;
 If YouKnowTheAdminPassword = False then exit;
 ExecuteForm(TDlrNet);
end;
*)
(*
procedure TBranchBackOffice.PrepareEMail1Click(Sender: TObject);
Var h : Thandle;
 ZAppString : Array[0..80] of Char;
 PZAppString : Pchar;

begin
  PZAppString := StrPCopy(ZAppString,AppDir+'\'+'EMailGen.exe');
  h :=ShellExecute(Self.Handle, Nil, PZAppString, Nil,Nil, SW_RESTORE);
  //h :=ShellExecute(Self.Handle, Nil, AppDir+'\'+'EMailGen.exe', Nil,Nil, SW_RESTORE);
  if h <=32 then
   ShowMessage('Cannot execute. Error '+IntToStr(h));
end;

procedure TBranchBackOffice.EMailBtnClick(Sender: TObject);
begin
 PrepareEMail1Click(Sender);
end;

procedure TBranchBackOffice.FsOutBtnClick(Sender: TObject);
begin
Application.CreateForm(TFsOutFiles,FSOutFiles);
FSOutFiles.ShowModal;
FSOutFiles.Free;
end;

procedure TBranchBackOffice.ProcessFieldOrdersBtnClick(Sender: TObject);
begin
 ExecuteForm(TExportToFs);
end;

procedure TBranchBackOffice.ExitBtnClick(Sender: TObject);
begin

Close;
end;

procedure TBranchBackOffice.FSConnectBtnClick(Sender: TObject);
begin
 ConnectToFundServ(Self.Handle);
end;

procedure TBranchBackOffice.HeadOffice1Click(Sender: TObject);
begin
 {ExecuteForm(THOSetUp);}
end;
*)

(*
procedure TBackOffice.Chart2Click(Sender: TObject);
begin
 ExecuteForm(TFieldOrders);
end;

procedure TBackOffice.Chart10Click(Sender: TObject);
begin
IncomingFilesClick(Sender);
end;

procedure TBackOffice.Chart3Click(Sender: TObject);
begin
 ConnectToFundServ(Self.Handle);
end;

procedure TBackOffice.Chart13Click(Sender: TObject);
begin
Application.CreateForm(TFsOutFiles,FSOutFiles);
FSOutFiles.ShowModal;
FSOutFiles.Free;
end;

procedure TBackOffice.Chart4Click(Sender: TObject);
begin
  OneStepCom;
end;
*)
{
procedure TBackOffice.I(Sender: TObject);
begin
IncomingFilesClick(Sender);
end;
}
(*
procedure TBranchBackOffice.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
BranchBackoffice := Nil;
end;

procedure TBranchBackOffice.AutoConnectBtnClick(Sender: TObject);
begin
 OneStepCom;
end;

procedure TBranchBackOffice.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TBranchBackOffice.FieldOrdersBtnClick(Sender: TObject);
begin
 ExecuteForm(TExportToFs);
end;

procedure TBranchBackOffice.ReconcileFundCoBtnClick(Sender: TObject);
begin
ShowMessage('Feature not released yet');
exit;
end;

procedure TBranchBackOffice.ViewTransactions1Click(Sender: TObject);
begin
 ExecuteForm(TTransactions);
end;

procedure TBranchBackOffice.Transactions1Click(Sender: TObject);
begin
 ExecuteForm(TTransactions);
end;

procedure TBranchBackOffice.Exit1Click(Sender: TObject);
begin
WhichModule := 'F';
Close;
end;

procedure TBranchBackOffice.FromMicrosophic1Click(Sender: TObject);
Var h:THandle;
begin
  h :=ShellExecute(Self.Handle, Nil, 'WebSites.exe', Nil,
  Nil, SW_RESTORE);
  if h <=32 then
   ShowMessage('Cannot execute. Error '+IntToStr(h));
end;

procedure TBranchBackOffice.Orders2Click(Sender: TObject);
begin
ExecuteForm(TExportToFs);
end;


procedure TBranchBackOffice.Posttransactions1Click(Sender: TObject);
begin
 ExecuteForm(TPostTransactions);
end;

procedure TBranchBackOffice.MFCurrentBalances1Click(Sender: TObject);
begin
ExecuteForm(TCurrentPortfolio);
end;

procedure TBranchBackOffice.Chart1Click(Sender: TObject);
begin
 Transactions1Click(Sender);

end;

procedure TBranchBackOffice.Accounts1Click(Sender: TObject);
begin
ExecuteForm(TAccounts);
end;
*)

(*
procedure TBranchBackOffice.ExportOrdersToHoClick(
  Sender: TObject);
begin
 ThisFilesOutDir := GetBranchFieldValue(FpUser.Branch,'FilesOutDir');
 ThisArchiveDir := GetBranchFieldValue(FpUser.Branch,'FilesOutArchives');
 ExecuteForm(TExportOrders);
end;

procedure TBranchBackOffice.PrepOrdersBtnClick(Sender: TObject);
begin
 SomeList := TStringList.Create;
 SomeCaption  := 'What to export to H.O.';
 SomeList.Add('Orders...');
 SomeList.Add('All Client Data...');
 SomeList.Add('Other Files...');
 ExecuteForm(TPopList);
 SomeList.Free;

 If SelectedString > '' then
 begin
  If SelectedString = 'Orders...' then ExportOrdersToHoClick(Sender);
  If SelectedString = 'All Client Data...' then
    ExportClientToHOClick(Sender);
  If SelectedString = 'Other Files...' then ExportotherfilesToHOClick(Sender);
 end;
end;

procedure TBranchBackOffice.ToDealer1Click(Sender: TObject);
begin
 OneStepCom;
end;

procedure TBranchBackOffice.TransmitOrdersBtnClick(Sender: TObject);
begin
  ToDealer1Click(Sender);
end;

procedure TBranchBackOffice.UpdateBSBtnClick(Sender: TObject);
begin
Posttransactions1Click(Sender);
end;

procedure TBranchBackOffice.PostLatestPrices1Click(Sender: TObject);
begin
 ExecuteForm(TPostPrices);
end;

procedure TBranchBackOffice.UpdateMfPricesBtnClick(Sender: TObject);
begin
PostLatestPrices1Click(Sender);
end;

procedure TBranchBackOffice.ImportFromHOClick(Sender: TObject);
begin
 ThisFilesInDir := GetBranchFieldValue(FpUser.Branch,'FilesInDir');
 ThisArchiveDir := GetBranchFieldValue(FpUser.Branch,'FilesInArchives');
 ExecuteForm(TImportIncomingFiles);
 PaintMailFlags;
end;

procedure TBranchBackOffice.ExportClientToHOClick(
  Sender: TObject);
begin
 ShowMessage('N/A');
 exit;
 {
 ThisFilesOutDir := GetBranchFieldValue(User.Branch,'FilesOutDir');
 ThisArchiveDir := GetBranchFieldValue(User.Branch,'FilesOutArchives');
 ExecuteForm(TExportClient);
 }
end;
*)
(*
procedure TBranchBackOffice.ReviewClients(Sender: TObject);
begin
ExecuteForm(TClientBook);
end;

procedure TBranchBackOffice.Chart2Click(Sender: TObject);
begin
Transactions1Click(Sender);
end;

procedure TBranchBackOffice.TelnetBtnClick(Sender: TObject);
begin
OneStepCom;
end;
(*
procedure TBranchBackOffice.UploadToDealerBtnClick(Sender: TObject);
begin
TransmitOrdersBtnClick(Sender);
end;

procedure TBranchBackOffice.Image7Click(Sender: TObject);
begin
OneStepCom;
end;


procedure TBranchBackOffice.ImportFromHOBtnClick(Sender: TObject);
begin
 ImportFromHOClick(Sender);

end;
*)
(*
procedure TBranchBackOffice.TransmitToAgentsBtnClick(Sender: TObject);
begin
 ToDealer1Click(Sender);
end;

procedure TBranchBackOffice.FromAgentsOrDealerClick(Sender: TObject);
begin
 ShowMessage('In the following window:'+
     Chr(13)+'Check box ANSWER INCOMING CALLS'+
     Chr(13)+'and minimize/resize');
 OneStepCom;
end;

procedure TBranchBackOffice.DownloadFromDealerBtnClick(Sender: TObject);
begin
  FromAgentsOrDealerClick(Sender);
end;

procedure TBranchBackOffice.ReceiveFromAgentsBtnClick(Sender: TObject);
begin
FromAgentsOrDealerClick(Sender);
end;
*)
(*
procedure TBranchBackOffice.ExportorganizationToAgentsClick(
  Sender: TObject);
begin
 ThisFilesOutDir := GetBranchFieldValue(FpUser.Branch,'AgentsFilesOutDir');
 ThisArchiveDir := GetBranchFieldValue(FpUser.Branch,'AgentsFilesOutArchives');
 ExecuteForm(TExportOrganization);
end;

procedure TBranchBackOffice.ExportotherfilesToHOClick(Sender: TObject);
begin
 ThisFilesOutDir := GetBranchFieldValue(FpUser.Branch,'FilesOutDir');
 ThisArchiveDir := GetBranchFieldValue(FpUser.Branch,'FilesOutArchives');
 ExecuteForm(TExportOther);
end;

procedure TBranchBackOffice.ExportFundCoresponsesToAgentsClick(Sender: TObject);
begin
 ShowMessage('Exporting is done via the Transaction Log');
 ExecuteForm(TTransactions);
end;

procedure TBranchBackOffice.ExportOtherFilesToAgentsClick(
  Sender: TObject);
begin
 ThisFilesOutDir := GetBranchFieldValue(FpUser.Branch,'AgentsFilesOutDir');
 ThisArchiveDir := GetBranchFieldValue(FpUser.Branch,'AgentsFilesOutArchives');
 ExecuteForm(TExportOther);
end;
*)
(*
procedure TBranchBackOffice.ImportFromAgentsClick(
  Sender: TObject);
begin
 ThisFilesInDir := GetBranchFieldValue(FpUser.Branch,'AgentsFilesInDir');
 ThisArchiveDir := GetBranchFieldValue(FpUser.Branch,'AgentsFilesInArchives');
 ExecuteForm(TImportIncomingFiles);
 PaintMailFlags;
end;

procedure TBranchBackOffice.ImportFromBranchClick(
  Sender: TObject);
begin
 ThisFilesInDir := GetBranchFieldValue(FpUser.Branch,'FilesInDir');
 ThisArchiveDir := GetBranchFieldValue(FpUser.Branch,'FilesInArchives');
 ExecuteForm(TImportIncomingFiles);
end;

procedure TBranchBackOffice.ExportToAgentsBtnClick(Sender: TObject);

begin
 ThisFilesOutDir := GetBranchFieldValue(FpUser.Branch,'AgentsFilesOutDir');
 ThisArchiveDir := GetBranchFieldValue(FpUser.Branch,'AgentsFilesOutArchives');
 SomeList := TStringList.Create;
 SomeCaption  := 'What to export...';
 SomeList.Add('Fund Co. Responses (TRN file)...');
 SomeList.Add('Organization Structure...');
 SomeList.Add('All Client Data...');
 SomeList.Add('The Mutual Funds Data Base');
 SomeList.Add('Other Files...');
 ExecuteForm(TPopList);
 SomeList.Free;

 If SelectedString > '' then
 begin
  If SelectedString = 'Fund Co. Responses (TRN file)...' then
   ExportFundCoresponsesToAgentsClick(Sender);

  If SelectedString = 'Organization Structure...' then
     ExportorganizationToAgentsClick(Sender);

  If SelectedString = 'All Client Data...' then
    ExportClientToHOClick(Sender);

  {
  If SelectedString = 'The Mutual Funds Data Base' then
     ExporttheMFDataBase1Click(Sender);
  }

  If SelectedString = 'Other Files...' then
    ExportOtherFilesToAgentsClick(Sender);
 end;

end;

procedure TBranchBackOffice.ImportFromAgentsBtnClick(Sender: TObject);
begin
ImportFromAgentsClick(Sender);
end;

procedure TBranchBackOffice.TrustAccountReconciliation(Sender: TObject);
begin
 ExecuteForm(TTrustReconciliation);
end;

procedure TBranchBackOffice.TrustReconciliationBtnClick(Sender: TObject);
begin
TrustAccountReconciliation(Sender);
end;

Procedure TBranchBackOffice.PaintMailFlags;
begin
 ImportFromAgentsFlag.Visible := CountFiles(
   GetBranchFieldValue(FpUser.Branch,'AgentsFilesInDir'))>0;
 ImportFromHoFlag.Visible := CountFiles(
 GetBranchFieldValue(FpUser.Branch,'FilesInDir'))>0;

end;

Function TBranchBackOffice.CountFiles(Dir:String):Integer;
begin
 FileListBox1.Directory := Dir;
 FileListBox1.Mask := '*.*';

 Result :=FileListBox1.Items.Count;
end;


procedure TBranchBackOffice.ImportFromHOFlagClick(Sender: TObject);
begin
ImportFromHOClick(Sender);
end;

procedure TBranchBackOffice.ImportFromAgentsFlagClick(Sender: TObject);
begin
ImportFromAgentsClick(Sender);
end;

procedure TBranchBackOffice.ClientSatements1Click(Sender: TObject);
begin
ExecuteForm(TStatementsForm);
end;

procedure TBranchBackOffice.Exportfullclientdata1Click(Sender: TObject);
begin
 ExecuteForm(TExportClient);
end;
*)
(*
procedure TBranchBackOffice.ExporttheMFDataBase1Click(Sender: TObject);
begin
  ExecuteForm(TExportMF);
end;
*)
(*
procedure TBranchBackOffice.ImportFundDatafromFundserv1Click(
  Sender: TObject);
begin
ExecuteForm(TProcessFsFunds);
end;

procedure TBranchBackOffice.BackUp1Click(Sender: TObject);
begin
  BackUpFpClients;
end;
*)
end.
