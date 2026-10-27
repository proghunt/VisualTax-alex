unit FP_2027DealerBackOffice;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,Menus,ShellApi,ComCtrls,FP_2027Declare,FileCtrl,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart;


type
  TDealerBackOfficeFP_2012 = class(TForm)
    MainMenu: TMainMenu;
    EditUndoItem: TMenuItem;
    EditCutItem: TMenuItem;
    EditCopyItem: TMenuItem;
    EditPasteItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpContentsItem: TMenuItem;
    HelpSearchItem: TMenuItem;
    HelpHowToUseItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    PrintSetupDialog: TPrinterSetupDialog;
    ImportFundServe72: TMenuItem;
    TransmitToFundServ1: TMenuItem;
    PrepareEMail1: TMenuItem;
    CommissionStatements1: TMenuItem;
    SetUp1: TMenuItem;
    Email1: TMenuItem;
    TrustAccountReconciliationRec1: TMenuItem;
    Exit1: TMenuItem;
    ClientStatementDetail1: TMenuItem;
    DownLoad1: TMenuItem;
    Upload1: TMenuItem;
    Import1: TMenuItem;
    ImportFromBranches: TMenuItem;
    FromBank1: TMenuItem;
    FromMicrosophic1: TMenuItem;
    ToFundServe1: TMenuItem;
    Transactions1: TMenuItem;
    Posttransactions1: TMenuItem;
    MFCurrentBalances1: TMenuItem;
    Accounts1: TMenuItem;
    PostLatestPrices1: TMenuItem;
    BackUp1: TMenuItem;
    Prepareordersfortransmission1: TMenuItem;
    ExportClientdatatobranches1: TMenuItem;
    Import2: TMenuItem;
    Export1: TMenuItem;
    N1: TMenuItem;
    N4: TMenuItem;
    ReviewClients1: TMenuItem;
    Suppliers1: TMenuItem;
    Funds1: TMenuItem;
    MutualFundsManualupdate1: TMenuItem;
    DealerButtons: TChart;
    ExportToFundServeBtn: TChart;
    ImportFromFundServBtn: TChart;
    ImportFromBranchesBtn: TChart;
    ExportToBranchesBtn: TChart;
    Chart2: TChart;
    Label2: TLabel;
    Chart6: TChart;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image6: TImage;
    Image1: TImage;
    Chart7: TChart;
    WEBBtn: TImage;
    ReceiveBtn: TChart;
    Image7: TImage;
    Label3: TLabel;
    Bevel1: TBevel;
    Label4: TLabel;
    Bevel2: TBevel;
    ESG71: TMenuItem;
    ImportFsFiles1: TMenuItem;
    N5: TMenuItem;
    FundServErrorCodes1: TMenuItem;
    N7: TMenuItem;
    ReconcileTrustBtn: TChart;
    Label6: TLabel;
    Label9: TLabel;
    Chart3: TChart;
    Chart4: TChart;
    Image5: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    N8: TMenuItem;
    Splitter1: TSplitter;
    Organization1: TMenuItem;
    ExportOrganizationstructure1: TMenuItem;
    Exportotherfiles1: TMenuItem;
    TransmitBtn: TChart;
    Image11: TImage;
    UploadToBranches1: TMenuItem;
    FromBranches1: TMenuItem;
    N10: TMenuItem;
    N6: TMenuItem;
    FileListBox1: TFileListBox;
    ImportFromBranchesFlag: TImage;
    ImportFromFsFlag: TImage;
    DBViewer1: TMenuItem;
    Utilities1: TMenuItem;
    FSResponsefilesTRN1: TMenuItem;
    {
    procedure SetModuleColorOff(Sender: TObject);
    procedure SetSubModuleColorOff(Sender: TObject);
    procedure SetFormsButtonsOff(Sender: TObject);
    procedure SetSubModuleButtonsOff(Sender: TObject);
    }

    procedure FormCreate(Sender: TObject);
    procedure FileNew(Sender: TObject);
    procedure FileOpen(Sender: TObject);
    procedure FileSave(Sender: TObject);
    procedure FileSaveAs(Sender: TObject);
    procedure FilePrint(Sender: TObject);
    procedure FilePrintSetup(Sender: TObject);
    procedure FileExit(Sender: TObject);
    procedure EditUndo(Sender: TObject);
    procedure EditCut(Sender: TObject);
    procedure EditCopy(Sender: TObject);
    procedure EditPaste(Sender: TObject);
    procedure WindowTile(Sender: TObject);
    procedure WindowCascade(Sender: TObject);
    procedure WindowArrange(Sender: TObject);
    procedure HelpContents(Sender: TObject);
    procedure HelpSearch(Sender: TObject);
    procedure HelpHowToUse(Sender: TObject);
    procedure HelpAbout(Sender: TObject);
    procedure ImportFundServe72Click(Sender: TObject);
    procedure Layouts1Click(Sender: TObject);
    procedure FundServeFileNames1Click(Sender: TObject);
    procedure CreateOrder1Click(Sender: TObject);
    procedure BackOffice1Click(Sender: TObject);
    procedure TransmitToFundServ1Click(Sender: TObject);
    procedure ProcessFundServAcknowledgements1Click(Sender: TObject);
    {procedure SetupDealernetwork1Click(Sender: TObject);}
    procedure PrepareEMail1Click(Sender: TObject);
    procedure EMailBtnClick(Sender: TObject);
    procedure FsOutBtnClick(Sender: TObject);
    procedure ProcessFieldOrdersBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure FSConnectBtnClick(Sender: TObject);
    procedure HeadOffice1Click(Sender: TObject);
    procedure DealerInformation1Click(Sender: TObject);
    {
    procedure Chart2Click(Sender: TObject);
    procedure Chart10Click(Sender: TObject);
    procedure Chart3Click(Sender: TObject);
    procedure Chart13Click(Sender: TObject);
    procedure Chart4Click(Sender: TObject);
    procedure I(Sender: TObject);
    }
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AutoConnectBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ExportToFundServeBtnClick(Sender: TObject);
    procedure ImportFromFundServBtnClick(Sender: TObject);
    procedure ReconcileTrustBtnClick(Sender: TObject);
    procedure ReconcileFundCoBtnClick(Sender: TObject);
    procedure StatementsBtnClick(Sender: TObject);
    procedure CommissionsStatementsBtnClick(Sender: TObject);
    procedure TrustAccountReconciliationRec1Click(Sender: TObject);
    procedure ViewTransactions1Click(Sender: TObject);
    procedure Transactions1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ClientStatementDetail1Click(Sender: TObject);
    procedure CommissionStatements1Click(Sender: TObject);
    procedure ImportFromBranchesClick(Sender: TObject);
    procedure FromMicrosophic1Click(Sender: TObject);
    procedure ToFundServe1Click(Sender: TObject);
    procedure Orders2Click(Sender: TObject);
    procedure MutualFundsDataBase1Click(Sender: TObject);
    procedure Posttransactions1Click(Sender: TObject);
    procedure MFCurrentBalances1Click(Sender: TObject);
    procedure Chart1Click(Sender: TObject);
    procedure Accounts1Click(Sender: TObject);
    procedure FromBank1Click(Sender: TObject);
    procedure PostLatestPrices1Click(Sender: TObject);
    procedure BackUp1Click(Sender: TObject);
    procedure Prepareordersfortransmission1Click(Sender: TObject);
    procedure ExportClientdatatobranches1Click(Sender: TObject);
    procedure ReviewClients1Click(Sender: TObject);
    procedure SupplierList1Click(Sender: TObject);
    procedure Funds1Click(Sender: TObject);
    procedure MutualFundsManualupdate1Click(Sender: TObject);
    procedure WEBBtnClick(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Chart3Click(Sender: TObject);
    procedure Chart4Click(Sender: TObject);
    procedure Chart5Click(Sender: TObject);
    procedure ExportToBranchesBtnClick(Sender: TObject);
    procedure ExportClientDataBtnClick(Sender: TObject);
    procedure Chart6Click(Sender: TObject);
    procedure ReceiveBtnClick(Sender: TObject);
    procedure Chart7Click(Sender: TObject);
    procedure ESG71Click(Sender: TObject);
    procedure ImportFsFiles1Click(Sender: TObject);
    procedure FundServErrorCodes1Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Organization1Click(Sender: TObject);
    procedure ExportOrganizationstructure1Click(Sender: TObject);
    procedure Exportotherfiles1Click(Sender: TObject);
    procedure UploadToBranches1Click(Sender: TObject);
    procedure FromBranches1Click(Sender: TObject);
    procedure TransmitBtnClick(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure ExportFundServresponsestobranches1Click(Sender: TObject);
    procedure ImportFromBranchesBtnClick(Sender: TObject);
    Function  CountFiles(Dir:String):Integer;
    Procedure PaintMailFlags;
    procedure ImportFromBranchesFlagClick(Sender: TObject);
    procedure ImportFromFsFlagClick(Sender: TObject);
    procedure DBViewer1Click(Sender: TObject);
    procedure FSResponsefilesTRN1Click(Sender: TObject);
    {procedure ExporttheMFdatabase1Click(Sender: TObject);}
  end;

var
  DealerBackOffice: TDealerBackOfficeFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027TrimStr,FP_2027TrustReconciliation,
{$IFDEF ADO}
  FP_2012Transactions,FP_2012ImportFSFiles,FP_2012StatementsForm,
  FP_2012FundBase,FP_2012Accounts,FP_2012Organization,FP_2027TablesF,
{$ELSE}
{$ENDIF}
  FP_2027PopList,FP_2027ImportFSFiles72,FP_2027FsOutFiles,FP_2027Commissions,
  FP_2027PostTransactions,FP_2027PostPrices,FP_2027CurrentPortfolio,
  FP_2027ImportIncomingFiles,FP_2027ExportClient,FP_2027exportToFS,
  FP_2027ClientBook,FP_2027FundAnalyser,FP_2027FsErrors,FP_2027CommissionsMenu,
  FP_2027ExportOrganization,FP_2027ExportOther,FP_2027ExportTRN,FP_2027Main,
  vtTrimStr,vtShared;

procedure TDealerBackOfficeFP_2012.FormCreate(Sender: TObject);
begin
  PaintMailFlags;
  ThisFilesInDir := HoRec.FilesInDir;
  ThisArchiveDir := HoRec.FilesInArchives;
  WhichModule := 'D';
  Client:='';
  {Application.OnHint := ShowHint;}
end;

procedure TDealerBackOfficeFP_2012.FileNew(Sender: TObject);
begin
  { Add code to create a new file }
end;

procedure TDealerBackOfficeFP_2012.FileOpen(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    { Add code to open OpenDialog.FileName }
  end;
end;

procedure TDealerBackOfficeFP_2012.FileSave(Sender: TObject);
begin
   { Add code to save current file under current name }
end;

procedure TDealerBackOfficeFP_2012.FileSaveAs(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    { Add code to save current file under SaveDialog.FileName }
  end;
end;

procedure TDealerBackOfficeFP_2012.FilePrint(Sender: TObject);
begin
  if PrintDialog.Execute then
  begin
    { Add code to print current file }
  end;
end;

procedure TDealerBackOfficeFP_2012.FilePrintSetup(Sender: TObject);
begin
  PrintSetupDialog.Execute;
end;

procedure TDealerBackOfficeFP_2012.FileExit(Sender: TObject);
begin
  Close;
end;

procedure TDealerBackOfficeFP_2012.EditUndo(Sender: TObject);
begin
  { Add code to perform Edit Undo }
end;

procedure TDealerBackOfficeFP_2012.EditCut(Sender: TObject);
begin
  { Add code to perform Edit Cut }
end;

procedure TDealerBackOfficeFP_2012.EditCopy(Sender: TObject);
begin
  { Add code to perform Edit Copy }
end;

procedure TDealerBackOfficeFP_2012.EditPaste(Sender: TObject);
begin
  { Add code to perform Edit Paste }
end;

procedure TDealerBackOfficeFP_2012.WindowTile(Sender: TObject);
begin
  Tile;
end;

procedure TDealerBackOfficeFP_2012.WindowCascade(Sender: TObject);
begin
  Cascade;
end;

procedure TDealerBackOfficeFP_2012.WindowArrange(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TDealerBackOfficeFP_2012.HelpContents(Sender: TObject);
begin
 Application.HelpFile := AppDir+'\'+'FPHelp.CHM';
 Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TDealerBackOfficeFP_2012.HelpSearch(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

procedure TDealerBackOfficeFP_2012.HelpHowToUse(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TDealerBackOfficeFP_2012.HelpAbout(Sender: TObject);
begin
  { Add code to show program's About Box }
end;

procedure TDealerBackOfficeFP_2012.ImportFundServe72Click(Sender: TObject);
begin
Application.CreateForm(TImportFsFiles72FP_2012,ImportFsFiles72);
ImportFsFiles72.ShowModal;
ImportFsFiles72.Free;
end;

procedure TDealerBackOfficeFP_2012.Layouts1Click(Sender: TObject);
begin
{
Application.CreateForm(TLayouts,Layouts);
Layouts.ShowModal;
Layouts.Free;
}
end;

procedure TDealerBackOfficeFP_2012.FundServeFileNames1Click(Sender: TObject);
begin
{
Application.CreateForm(TFSFileTypes,FSFileTypes);
FSFileTypes.ShowModal;
FSFileTypes.Free;
}
end;

procedure TDealerBackOfficeFP_2012.CreateOrder1Click(Sender: TObject);
begin
{
Application.CreateForm(TOrderSetUp,OrderSetUp);
OrderSetUp.ShowModal;
OrderSetUp.Free;
}
end;


procedure TDealerBackOfficeFP_2012.BackOffice1Click(Sender: TObject);
Var h:THandle;
begin
 (*
 h := ShellExecute(MdiHandle, Nil, 'HoAdmin.EXE', Nil,
  Nil, SW_RESTORE);
  If H<=32 then
  Begin
   ShowMessage('Program cannot execute. Error Code = '+IntToStr(h));
   SomeList := TStringList.Create;
   SomeCaption := 'Error codes';
   SomeList.LoadFromFile(AppDir+'\'+'SHELLERR.D');

   ExecuteForm(TPopList);
   SomeList.Free;
  end;
 *)
end;

procedure TDealerBackOfficeFP_2012.TransmitToFundServ1Click(Sender: TObject);
begin
 ConnectToFundServ(Self.handle);
 {OneStepCom;}
end;

procedure TDealerBackOfficeFP_2012.ProcessFundServAcknowledgements1Click(Sender: TObject);
begin
{$IFDEF ADO}
 ExecuteForm(TImportFsFiles);
{$ELSE}
  ADOMsg('ImportFsFiles');
{$ENDIF}
end;

procedure TDealerBackOfficeFP_2012.PrepareEMail1Click(Sender: TObject);
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

procedure TDealerBackOfficeFP_2012.EMailBtnClick(Sender: TObject);
begin
 PrepareEMail1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.FsOutBtnClick(Sender: TObject);
begin
Application.CreateForm(TFsOutFiles,FSOutFiles);
FSOutFiles.ShowModal;
FSOutFiles.Free;
end;


procedure TDealerBackOfficeFP_2012.ProcessFieldOrdersBtnClick(Sender: TObject);
begin
  //NOP!
end;

procedure TDealerBackOfficeFP_2012.ExitBtnClick(Sender: TObject);
begin

Close;
end;

procedure TDealerBackOfficeFP_2012.FSConnectBtnClick(Sender: TObject);
begin
 ConnectToFundServ(Self.Handle);
end;

procedure TDealerBackOfficeFP_2012.HeadOffice1Click(Sender: TObject);
begin
 {ExecuteForm(THOSetUp);}
end;

procedure TDealerBackOfficeFP_2012.DealerInformation1Click(Sender: TObject);
begin
{$IFDEF ADO}
 ExecuteForm(TOrganization);
{$ELSE}
  ADOMsg('TOrganization');
{$ENDIF}
end;

procedure TDealerBackOfficeFP_2012.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caFree;
DealerBackoffice := Nil;
end;

procedure TDealerBackOfficeFP_2012.AutoConnectBtnClick(Sender: TObject);
begin
 OneStepCom;
end;

procedure TDealerBackOfficeFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TDealerBackOfficeFP_2012.ExportToFundServeBtnClick(Sender: TObject);
begin
  //NOP
end;

procedure TDealerBackOfficeFP_2012.ImportFromFundServBtnClick(Sender: TObject);
begin
ImportFsFiles1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.ReconcileTrustBtnClick(Sender: TObject);
begin
 TrustAccountReconciliationRec1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.ReconcileFundCoBtnClick(Sender: TObject);
begin
ShowMessage('Feature not released yet');
exit;
end;

procedure TDealerBackOfficeFP_2012.StatementsBtnClick(Sender: TObject);
begin
 ClientStatementDetail1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.CommissionsStatementsBtnClick(Sender: TObject);
begin
 CommissionStatements1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.TrustAccountReconciliationRec1Click(
  Sender: TObject);
begin
 ExecuteForm(TTrustReconciliation);
end;

procedure TDealerBackOfficeFP_2012.ViewTransactions1Click(Sender: TObject);
begin
{$IFDEF ADO}
 ExecuteForm(TTransactions);
{$ELSE}
  ADOMsg('TTransactions');
{$ENDIF}
end;

procedure TDealerBackOfficeFP_2012.Transactions1Click(Sender: TObject);
begin
 //ExecuteForm(TTransactions);
 ViewTransactions1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.Exit1Click(Sender: TObject);
begin
WhichModule := 'F';
Close;
end;

procedure TDealerBackOfficeFP_2012.ClientStatementDetail1Click(Sender: TObject);
begin
{$IFDEF ADO}
 ExecuteForm(TStatementsForm);
{$ELSE}
  ADOMsg('StatementsForm');
{$ENDIF}
end;

procedure TDealerBackOfficeFP_2012.CommissionStatements1Click(Sender: TObject);
begin
 {If YouKnowTheAdminPassword = false then exit;}
 ExecuteForm(TCommissionsMenu);
end;

procedure TDealerBackOfficeFP_2012.ImportFromBranchesClick(Sender: TObject);
begin
 ThisFilesInDir := HoRec.FilesInDir;
 ThisArchiveDir := HoRec.FilesInArchives;
 ExecuteForm(TImportIncomingFiles);
 PaintMailFlags;
end;

procedure TDealerBackOfficeFP_2012.FromMicrosophic1Click(Sender: TObject);
Var h:THandle;
begin
  h :=ShellExecute(Self.Handle, Nil, 'WebSites.exe', Nil,
  Nil, SW_RESTORE);
  if h <=32 then
   ShowMessage('Cannot execute. Error '+IntToStr(h));
end;

procedure TDealerBackOfficeFP_2012.ToFundServe1Click(Sender: TObject);
begin
 Application.CreateForm(TFsOutFiles,FSOutFiles);
 FSOutFiles.ShowModal;
 FSOutFiles.Free;
end;

procedure TDealerBackOfficeFP_2012.Orders2Click(Sender: TObject);
begin
  //NOP
end;

procedure TDealerBackOfficeFP_2012.MutualFundsDataBase1Click(Sender: TObject);
begin
{$IFDEF ADO}
  ExecuteForm(TFundBase);
{$ELSE}
  ADOMsg('TFundBase');
{$ENDIF}
end;

procedure TDealerBackOfficeFP_2012.Posttransactions1Click(Sender: TObject);
begin
 Screen.Cursor := crHourglass;
 ExecuteForm(TPostTransactions);
end;

procedure TDealerBackOfficeFP_2012.MFCurrentBalances1Click(Sender: TObject);
begin
ExecuteForm(TCurrentPortfolioFP_2012);
end;

procedure TDealerBackOfficeFP_2012.Chart1Click(Sender: TObject);
begin
 ReviewClients1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.Accounts1Click(Sender: TObject);
begin
{$IFDEF ADO}
  ExecuteForm(TAccounts);
{$ELSE}
  ADOMsg('TAccounts');
{$ENDIF}
end;

procedure TDealerBackOfficeFP_2012.FromBank1Click(Sender: TObject);
begin
 ShowMessage('File not found');
 {OneStepCom;}
end;

procedure TDealerBackOfficeFP_2012.PostLatestPrices1Click(Sender: TObject);
begin
 ExecuteForm(TPostPrices);
end;

procedure TDealerBackOfficeFP_2012.BackUp1Click(Sender: TObject);
begin
 BackUpFpClients;
end;

procedure TDealerBackOfficeFP_2012.Prepareordersfortransmission1Click(
  Sender: TObject);
begin
 ExecuteForm(TExportToFs);
end;

procedure TDealerBackOfficeFP_2012.ExportClientdatatobranches1Click(
  Sender: TObject);
begin
 ExecuteForm(TExportClient);
end;

procedure TDealerBackOfficeFP_2012.ReviewClients1Click(Sender: TObject);
begin
 ExecuteForm(TClientBookFP_2012);
end;

procedure TDealerBackOfficeFP_2012.SupplierList1Click(Sender: TObject);
begin
 //ExecuteForm(TEditSuppliers);
end;


procedure TDealerBackOfficeFP_2012.Funds1Click(Sender: TObject);
begin
 ExecuteForm(TFundAnalyserFP_2012); //wwSelectFund);
end;

procedure TDealerBackOfficeFP_2012.MutualFundsManualupdate1Click(Sender: TObject);
begin
{$IFDEF ADO}
 ExecuteForm(TFundBase);
{$ELSE}
  ADOMsg('TFundBase');
{$ENDIF}
end;

procedure TDealerBackOfficeFP_2012.WEBBtnClick(Sender: TObject);
Var h : Thandle;
begin
  h :=ShellExecute(MainFormFP.Handle, Nil, 'WebSites.exe', Nil,
  Nil, SW_RESTORE);
  if h <=32 then
   ShowMessage('Cannot execute. Error '+IntToStr(h));

 (*
  h :=ShellExecute(Self.Handle, Nil, 'TelNet', 'FundServ',
  Nil, SW_RESTORE);
  If H<=32 then
  Begin
   ShowMessage('Program cannot execute. Error Code = '+IntToStr(h));
   SomeList := TStringList.Create;
   SomeCaption := 'Error codes';
   SomeList.LoadFromFile(AppDir+'\'+'SHELLERR.D');
   ExecuteForm(TPopList);
   SomeList.Free;
  end;
  *)
  {ShowMessage('Cannot execute. Error '+IntToStr(h));}
  {TransmitToFundServ1Click(Sender);}
end;

procedure TDealerBackOfficeFP_2012.Label10Click(Sender: TObject);
begin
WebBtnClick(Sender);
end;

(*
procedure TDealerBackOffice.SetModuleColorOff(Sender: TObject);
begin
  {menu buttons}
  DealerBtn.Gradient.StartColor := ModuleOffColor;
  BranchBtn.Gradient.StartColor := ModuleOffColor;
end;

procedure TDealerBackOffice.SetSubModuleColorOff(Sender: TObject);
begin
  {menu buttons}
 { CashBtn.Gradient.StartColor := SubModuleOffColor;}
end;


procedure TDealerBackOffice.DealerBtnClick(Sender: TObject);
begin
 SetModuleColorOff(Sender);
 SetFormsButtonsOff(Sender);
 SubModulePanel.Visible := False;
 SubModulePanel.Height :=0;
 FormsButtonsPanel.Height := LeftPanel.Height;

 DealerButtons.Left := FormsButtonsPanel.Left;
 DealerButtons.Top := FormsButtonsPanel.Top;
 DealerButtons.Width := FormsButtonsPanel.Width;
 DealerButtons.Height := FormsButtonsPanel.Height;

 {DealerBtn.Gradient.StartColor := ModuleOnColor;}
 DealerBtn.Title.Font.Color := ModuleOnColor;
 DealerButtons.Visible := True;
end;

procedure TDealerBackOffice.BranchBtnClick(Sender: TObject);
begin
 SetModuleColorOff(Sender);
 SetFormsButtonsOff(Sender);
 SubModulePanel.Visible := False;
 SubModulePanel.Height :=0;
 FormsButtonsPanel.Height := LeftPanel.Height;

 BranchButtons.Left := FormsButtonsPanel.Left;
 BranchButtons.Top := FormsButtonsPanel.Top;
 BranchButtons.Width := FormsButtonsPanel.Width;
 BranchButtons.Height := FormsButtonsPanel.Height;

 {BranchBtn.Gradient.StartColor := ModuleOnColor;}
 BranchBtn.Title.Font.Color := ModuleOnColor;
 BranchButtons.Visible := True;
end;

procedure TDealerBackOffice.SetFormsButtonsOff(Sender: TObject);
begin
 DealerButtons.Visible := False;
 BranchButtons.Visible := False;
 SubModulePanel.Visible := False;
end;

procedure TDealerBackOffice.SetSubModuleButtonsOff(Sender: TObject);
begin
 {}
end;
*)

procedure TDealerBackOfficeFP_2012.Chart3Click(Sender: TObject);
begin
Posttransactions1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.Chart4Click(Sender: TObject);
begin
PostLatestPrices1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.Chart5Click(Sender: TObject);
begin
MutualFundsDataBase1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.ExportToBranchesBtnClick(Sender: TObject);
begin
 ThisFilesOutDir := HoRec.FilesOutDir;
 ThisArchiveDir := HoRec.FilesOutArchives;
 SomeList.Clear;  // := TStringList.Create;
 SomeCaption  := 'What to export...';
 SomeList.Add('Fund Co. Responses (TRN file)');
 SomeList.Add('Organization Structure');
 SomeList.Add('Full Client Data');
 SomeList.Add('The Mutual Funds Data Base');
 SomeList.Add('Other Files');
 ExecuteForm(TPopListFP_2012);
 //SomeList.Free; //20160704 Igor

 If SelectedString > '' then
 begin
   If SelectedString = 'Fund Co. Responses (TRN file)' then
     FSResponsefilesTRN1Click(Sender);

   If SelectedString = 'Organization Structure' then
     ExportOrganizationstructure1Click(Sender);

   If SelectedString = 'Full Client Data' then
     ExportClientdatatobranches1Click(Sender);

   {
   If SelectedString = 'The Mutual Funds Data Base' then
     ExporttheMFdatabase1Click(Sender);
   }
   If SelectedString = 'Other Files' then
    Exportotherfiles1Click(Sender);
 end;

end;

procedure TDealerBackOfficeFP_2012.ExportClientDataBtnClick(Sender: TObject);
begin
ExportClientdatatobranches1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.Chart6Click(Sender: TObject);
begin
FromBank1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.ReceiveBtnClick(Sender: TObject);
begin
 FromBranches1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.Chart7Click(Sender: TObject);
begin
WebBtnClick(Sender);
end;

procedure TDealerBackOfficeFP_2012.ESG71Click(Sender: TObject);
begin
 If (IsDealerversion) or (IsAgentVersion) then
 begin
  Application.HelpFile := AppDir+'\'+'ESG_7.HLP';
  Application.HelpCommand(HELP_CONTENTS, 0);
 end;
end;

procedure TDealerBackOfficeFP_2012.ImportFsFiles1Click(Sender: TObject);
begin
  ThisFilesInDir := HoRec.FsInDir;
  ThisFilesOutDir := HoRec.FilesOutDir; {for copying to branches}
  ThisArchiveDir := HoRec.FsInArchive;
{$IFDEF ADO}
  Application.CreateForm(TImportFsFiles,ImportFsFiles);
  ImportFsFiles.ShowModal;
  ImportFsFiles.Free;
{$ELSE}
  ADOMsg('ImportFsFiles');
{$ENDIF}
  PaintMailFlags;
end;

procedure TDealerBackOfficeFP_2012.FundServErrorCodes1Click(Sender: TObject);
begin
  ExecuteForm(TFsErrors);
end;

procedure TDealerBackOfficeFP_2012.Image7Click(Sender: TObject);
begin
 FromBranches1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.Organization1Click(Sender: TObject);
begin
{If YouKnowTheAdminPassword = False then exit;}
{$IFDEF ADO}
  ExecuteForm(TOrganization);
{$ELSE}
  ADOMsg('TOrganization');
{$ENDIF}
end;

procedure TDealerBackOfficeFP_2012.ExportOrganizationstructure1Click(
  Sender: TObject);
begin
ThisFilesOutDir := HoRec.FilesOutDir;
ThisArchiveDir := HoRec.FilesOutArchives;
ExecuteForm(TExportOrganizationFP_2012);
end;

procedure TDealerBackOfficeFP_2012.Exportotherfiles1Click(Sender: TObject);
begin
ThisFilesOutDir := HoRec.FilesOutDir;
ThisArchiveDir := HoRec.FilesOutArchives;
ExecuteForm(TExportOtherFP_2012);
end;

procedure TDealerBackOfficeFP_2012.UploadToBranches1Click(Sender: TObject);
begin
OneStepCom;
end;

procedure TDealerBackOfficeFP_2012.FromBranches1Click(Sender: TObject);
begin
 ShowMessage('In the following window:'+
     Chr(13)+'Check box ANSWER INCOMING CALLS'+
     Chr(13)+'and minimize/resize/drag window out of view');
 OneStepCom;
end;

procedure TDealerBackOfficeFP_2012.TransmitBtnClick(Sender: TObject);
begin
 UploadToBranches1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.Image11Click(Sender: TObject);
begin
 UploadToBranches1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.ExportFundServresponsestobranches1Click(
  Sender: TObject);
begin

{ThisFilesOutDir := HoRec.FilesOutDir;
ThisArchiveDir := HoRec.FilesOutArchives;
}
end;

procedure TDealerBackOfficeFP_2012.ImportFromBranchesBtnClick(Sender: TObject);
begin
ImportFromBranchesClick(Sender);
end;

Function TDealerBackOfficeFP_2012.CountFiles(Dir:String):Integer;
begin
 FileListBox1.Directory := Dir;
 FileListBox1.Mask := '*.*';

 Result :=FileListBox1.Items.Count;
end;

Procedure TDealerBackOfficeFP_2012.PaintMailFlags;
begin

 ImportFromBranchesFlag.Visible := CountFiles(ThisFilesInDir)>0;
 ImportFromFsFlag.Visible := CountFiles(HoRec.FsInDir)>0;

end;
procedure TDealerBackOfficeFP_2012.ImportFromBranchesFlagClick(Sender: TObject);
begin
ImportFromBranchesClick(Sender);
end;

procedure TDealerBackOfficeFP_2012.ImportFromFsFlagClick(Sender: TObject);
begin
ImportFsFiles1Click(Sender);
end;

procedure TDealerBackOfficeFP_2012.DBViewer1Click(Sender: TObject);
begin
 {If IsStandardVersion = True then exit;}
// If YouKnowTheAdminPassword = false then Exit;
{$IFDEF ADO}
 ExecuteForm(TTablesF);
{$ELSE}
  ADOMsg('TTablesF');
{$ENDIF}
end;

procedure TDealerBackOfficeFP_2012.FSResponsefilesTRN1Click(Sender: TObject);
begin
 ExecuteForm(TExportTRNFP_2012);
{
 ShowMessage('Exporting is done via the Transaction Log');
 ExecuteForm(TTransactions);
}
end;

(*
procedure TDealerBackOffice.ExporttheMFdatabase1Click(Sender: TObject);
begin
 ExecuteForm(TExportMF);
end;
*)
end.
