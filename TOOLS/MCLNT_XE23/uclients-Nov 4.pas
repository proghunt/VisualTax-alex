unit uclients;
//20191101 CON made some changes: The clients.dbf has all data needed so thre is no need to
//use calculated fields. The CloudDadaDir was renamed to CloudDataD to comply with dbf namining limits
interface

{$I ZEOS.inc} //20190111 Igor

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DB, DBTables, StdCtrls, Buttons,
  ExtCtrls, DBCtrls,Printers,FileCtrl,MAPI,
  UDeclare,UPopList,TrimStr,UKeys, Mask, ComCtrls, Psock, NMsmtp, Menus,
  UReadEMail,ShellAPI,Clipbrd,UGst,NMHttp; //20180917 Igor

  Const    MaxBccGroup = 2;  {30}
  Const    SaveToSubFolder = 'ActivationKeys';

type
  TClients = class(TForm)
    PrintDialog1: TPrintDialog;
    Mail: TNMSMTP;
    Panel1: TPanel;
    LblCount: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBCountLbl: TLabel;
    Label4: TLabel;
    ExitBtn: TBitBtn;
    DBNavigator1: TDBNavigator;
    PrintLabelsBtn: TBitBtn;
    FilterBtn: TBitBtn;
    WhereBox: TEdit;
    CopyAllBtn: TBitBtn;
    StoreAKey: TBitBtn;
    StoreAllKeys: TBitBtn;
    EraseAllKeysBtn: TBitBtn;
    PrintClientKeysBtn: TBitBtn;
    Query1: TQuery;
    DataSource1: TDataSource;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    Panel4: TPanel;
    Panel2: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    eSubject: TEdit;
    eFrom: TEdit;
    eServer: TEdit;
    BtnSendAll: TButton;
    ListAddr: TListBox;
    reMessageText: TRichEdit;
    ListBox1: TListBox;
    EmailAddressBox: TEdit;
    Label8: TLabel;
    MsgOptionBox: TRadioGroup;
    Label9: TLabel;
    MsgFileBox: TEdit;
    SearchBtn: TBitBtn;
    SumBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    GetMsgFileBtn: TBitBtn;
    ClearIndicatorsBtn: TButton;
    BccList: TListBox;
    AddBccBtn: TBitBtn;
    MainMenu1: TMainMenu;
    ReadEmail1: TMenuItem;
    SendBccBtn: TBitBtn;
    Label10: TLabel;
    ClearBccBtnBcc: TBitBtn;
    CopyAllToBccBtn: TBitBtn;
    Label11: TLabel;
    PrintLitingBtn: TBitBtn;
    Button1: TButton;
    Label12: TLabel;
    Compare1: TMenuItem;
    InitializeBtn: TBitBtn;
    BuildOutLookBtn: TBitBtn;
    CalcInvoiceBtn: TBitBtn;
    AcknowledgeBtn: TButton;
    EfileLogsBtn: TMenuItem;
    SENDKEYSTOALL1: TMenuItem;
    GENTKEYFORALL1: TMenuItem;
    LastYr1: TMenuItem;
    BatchKeySEND: TBitBtn;
    EFCOUNT1: TMenuItem;
    InitEFCount: TBitBtn;
    RichEdit1: TRichEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    BreakListBtn: TBitBtn;
    Label16: TLabel;
    EFILINGLOGS1: TMenuItem;
    AllLogs1: TMenuItem;
    EfileLogsT21: TMenuItem;
    EfileLogs1: TMenuItem;
    AllLogs2: TMenuItem;
    SEndMapiAckBTN: TButton;
    SendMapiEmailBtn: TButton;
    ClearBtn: TBitBtn;
    LastYRDueBtn: TBitBtn;
    AddressVerificationBtn: TButton;
    GSTHST1: TMenuItem;
    DuplicateBtn: TBitBtn;
    GenCustomerNoBtn: TBitBtn;
    GenPasswordBtn: TBitBtn;
    GenALLaccountAndPswBTN: TBitBtn;
    FillHstBtn: TBitBtn;
    IndexByGroup: TRadioGroup;
    FillMissingHSTBtn: TBitBtn;
    //20180917 Igor >>>
    ExportToSiteBtn: TBitBtn;
    NMHTTPForExport: TNMHTTP;
    //20180917 Igor <<<
    //20190111 Igor >>>
    ExportToKeysDbBtn: TBitBtn;
    SaveKeysDialog: TSaveDialog;
    //20191015 Igor >>>
    btnGenerateLimitedBN: TBitBtn;
    SaveDialog1: TSaveDialog;
    SaveLVerfDialog: TSaveDialog;
    btnGenerateLVerfEx_: TBitBtn;
    SaveLimitedBNDialog: TSaveDialog;
    //20191015 Igor <<<
    //20190111 Igor <<<

    //20200918
    procedure GenSalDivKeyBtnClick(Sender: TObject);
    Function  GenSalDivKey:String;  //20200902
    //---
    Function ValidateProductVersion:Boolean;
    procedure StoreAKeyForBatch;
    procedure PrepareMsgWithKeysToSent;
   // procedure MergeFiles(FirstSplitFileName, OutFileName : TFileName) ;
    function  SendMAPIMail(const Subject, Body, FileNames,SenderName, SenderEMail,RecipientName, RecipientEMail: Ansistring): Integer;
    procedure ExitBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure PrintLabelsBtnClick(Sender: TObject);
    procedure FilterBtnClick(Sender: TObject);
    Procedure ShowCount;
    procedure OpenClientsQ;
    procedure CopyAllBtnClick(Sender: TObject);
    procedure StoreAKeyClick(Sender: TObject);
    procedure StoreT1Key;
    procedure StoreT2Key;
    procedure StoreT3Key;
    procedure StoreTFKey;
    procedure StoreT4Key;
    procedure StoreFPKey;
    procedure StoreTRKey;
    procedure StoreS1Key;
    procedure StoreS2Key;
    procedure StoreCloudKey; //20180917 Igor
    procedure StoreDropBoxKey; //20190306 Igor
    procedure StoreAllKeysClick(Sender: TObject);
    procedure EraseAllKeysBtnClick(Sender: TObject);
    procedure EraseAllKeys;
    procedure PrintClientKeysBtnClick(Sender: TObject);
    Function PrintKeyLabels(DataDir,FileNm:String):boolean;
    Procedure PrintAKeyLabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
    procedure BtnSendAllClick(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure SumBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure GetMsgFileBtnClick(Sender: TObject);
    procedure ClearIndicatorsBtnClick(Sender: TObject);
    procedure AddBccBtnClick(Sender: TObject);
    procedure ReadEmail1Click(Sender: TObject);
    procedure SendBccBtnClick(Sender: TObject);
    procedure MailRecipientNotFound(Recipient: String);
    procedure MailFailure(Sender: TObject);
    procedure ClearBccBtnBccClick(Sender: TObject);
    procedure CopyAllToBccBtnClick(Sender: TObject);
    procedure BccListDblClick(Sender: TObject);
    Procedure UpdateQueryMsgSent(EmailAddr:String);
    procedure PrintLitingBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Compare1Click(Sender: TObject);
    procedure InitializeBtnClick(Sender: TObject);
    procedure BuildOutLookBtnClick(Sender: TObject);
    procedure CalcInvoiceBtnClick(Sender: TObject);
    Function  GetPrice(ProductId:String;Version:String;Bundled:Boolean;HowPaid:String):Real;
   // Function  GetInternetPrice(ProductId:String;Version:String;Bundled:Boolean;HowPaid:String):Real;

    Function CalcInvoiceTotalPrice(BundleIndicator,T1version,T2version,T3version,TfVersion,T4version,FPversion,ARVersion,TRVersion,HowPaid:String;NumbCds:Real;S1Version:String;S2Version:String):Real; //20171025

    //Function CalcInvoiceTotalPrice(T1version,T2version,T3version,T4version,FPversion,ARVersion,TRVersion,HowPaid:String;NumbCds:Real):Real;
    //Function  CalcInvoiceTotalPrice(T1version,T2version,T3version,T4version,FPversion,ARVersion,TRVersion,HowPaid:String):Real;
    procedure createHTMLinvoice(cdCharge,EFDiscount,Discount,PayPalCharge,tax,taxRate,TotalPrice,Paid,AmountDue:Real;HowPaid:String;adjustmentAmount:real);
    procedure AcknowledgeBtnClick(Sender: TObject);
    procedure EfileLogsBtnClick(Sender: TObject);
    procedure SENDKEYSTOALL1Click(Sender: TObject);
    procedure GENTKEYFORALL1Click(Sender: TObject);
    procedure LastYr1Click(Sender: TObject);
    procedure BatchKeySENDClick(Sender: TObject);
    procedure EFCOUNT1Click(Sender: TObject);
    procedure InitEFCountClick(Sender: TObject);
    procedure SEndMapiAckBTNClick(Sender: TObject);
    procedure SendMapiEmailBtnClick(Sender: TObject);
    procedure BreakListBtnClick(Sender: TObject);
    procedure AllLogs1Click(Sender: TObject);
    procedure EfileLogs1Click(Sender: TObject);
    procedure AllLogs2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LastYRDueBtnClick(Sender: TObject);
    procedure AddressVerificationBtnClick(Sender: TObject);
    procedure GSTHST1Click(Sender: TObject);
    procedure DuplicateBtnClick(Sender: TObject);
    procedure GenCustomerNoBtnClick(Sender: TObject);
    procedure GenPasswordBtnClick(Sender: TObject);
    procedure GenALLaccountAndPswBTNClick(Sender: TObject);
    procedure IndexByGroupClick(Sender: TObject);
    procedure FillMissingHSTBtnClick(Sender: TObject);
    procedure FillHst(ReplaceSw:Boolean);
    procedure FillHstBtnClick(Sender: TObject);
    procedure ExportToSiteBtnClick(Sender: TObject); //20180917 Igor
    procedure Query1BeforePost(DataSet: TDataSet); //20181108 Igor
    procedure ExportToKeysDbBtnClick(Sender: TObject); //20190111 Igor
    procedure btnGenerateLimitedBNClick(Sender: TObject);
    procedure btnGenerateLVerfEx_Click(Sender: TObject);

  private
    { Private declarations }
    //function GenerateKeysXML(AFileName: string): boolean; //20180917 Igor //20181108 Igor
    //20200615 Igor >>>
    function GenerateLimitedBN(AFileName: string; ASilent: boolean = true): boolean;
    function GenerateLVerf(AFileName: string; ASilent: boolean = true): boolean;
    //20200615 Igor <<<
  public
    itemInfo: array[1..14,1..2] of string;
    { Public declarations }
  end;

var
  Clients: TClients;
  WhereClause:String;

  {for keys}
  PgmNames,ProductIds, PgmFactors:Tstringlist;
  Pgm:String;
  PgmId:String;
  TheKey :String;


implementation

uses ZConnection, ZDataSet; //20190111 Igor

{$R *.DFM}

procedure TClients.ExitBtnClick(Sender: TObject);
begin
If Query1.Active then Query1.Close;
If Mail.Connected then Mail.Disconnect;

Close;
end;

procedure TClients.DBGrid1DblClick(Sender: TObject);
Var Postal:String;
    //20191015 Igor >>>
    I: integer;
    BN: TBNList;
    //20191015 Igor <<<
begin
(*
 //temporary before issuing the program keys  //20191105
 ListAddr.items.clear;
 ListAddr.Items.Add(Query1.FieldByName('EMail').AsString);
 EmailAddressBox.Text:=AllTrim(Query1.FieldByName('EMail').AsString);
 ReMessageText.Lines.clear;

 reMessageText.Lines.Add('Thank you for your Order.');
 reMessageText.Lines.Add('   ');
 reMessageText.Lines.Add('Estimated product Release Dates can be found on our web site, by clicking Products -> Release Dates');
 reMessageText.Lines.Add('   ');

 reMessageText.Lines.Add('Program keys will be sent to your Email Address around November 17, 2019');

 reMessageText.Lines.Add('   ');
// reMessageText.Lines.Add('Attached please find the Invoice/Receipt of your purchase.');

 reMessageText.Lines.Add('   ');
 reMessageText.Lines.Add('Sincerely');
 reMessageText.Lines.Add('VisualTax');
 Exit;
 *)
 //-----------------------------------------------
 try
 MsgOptionBox.ItemIndex :=-1;

 If MsgOptionBox.ItemIndex =-1 then
 begin
   If UpperCase(AllTrim(Query1.FieldByName('CD_NUM').AsString)) = 'Y' then
    MsgOptionBox.ItemIndex :=1
   else
    MsgOptionBox.ItemIndex :=0;
 end;

 If MsgOptionBox.itemIndex<0 then
 begin
  ShowMessage('You must select a Message Option');
  exit;
 end;

 If (MsgOptionBox.ItemIndex=2) and (MsgFileBox.Text='') then
  MsgFileBox.Text:=AppDir+'\'+'BroadCastMsg\FeDUMMY.TXT';

 ListBox1.Items.Add(Query1.FieldByName('Name').AsString);

 ListAddr.items.clear;
 ListAddr.Items.Add(Query1.FieldByName('EMail').AsString);
 EmailAddressBox.Text:=AllTrim(Query1.FieldByName('EMail').AsString);

 ReMessageText.Lines.clear;


 Case MsgOptionBox.ItemIndex of
  0,1:
   begin {Non CD users}

      reMessageText.Lines.Add('Thank you for your VisualTax Order.');
      reMessageText.Lines.Add('  ');
      //reMessageText.Lines.Add('The Program keys will be emailed out towards the end of November.'); //20201130

      reMessageText.Lines.Add('*** Please keep A PAPER COPY OF THESE PROGRAM KEYS in a safe place ***');
      reMessageText.Lines.Add('(outside your computer) AND do not disclose them to third parties.');


     reMessageText.Lines.Add('Most of the tax modules for the new tax season will be released between Dec 15 and the end of 2023.');
     reMessageText.Lines.Add('as shown on the following link that shows the expected Release dates');
     reMessageText.Lines.Add('http://www.visualtax.com/release.php');

     reMessageText.Lines.Add('The composite VT-2023 program is not yet posted on the Downloads page of our web site.');
     reMessageText.Lines.Add('The first tax module to be released will be the T2-2024 by Dec 15.');
     reMessageText.Lines.Add('It is currently being reviewed by CRA as part of its annual Certification.');

     reMessageText.Lines.Add(' ');
     reMessageText.Lines.Add('****   NOTE  ***** ');
     reMessageText.Lines.Add('The first time you run the VT program, it will give you the About window to enter your keys.');
      //reMessageText.Lines.Add('DO NOT enter the keys for Tax modules not released yet. They have a N/A version on the About window'); //20200120

      reMessageText.Lines.Add(' ');
      reMessageText.Lines.Add('Your production VisualTax program key(s) are:');
      reMessageText.Lines.Add(' ');

      // 20180904 Igor >>>
      If AllTrim(Query1.FieldByName('T1Key').AsString)>'' then
        reMessageText.Lines.Add('T1-2020:      '+Query1.FieldByName('T1Key').AsString);
      If AllTrim(Query1.FieldByName('T2Key').AsString)>'' then
        reMessageText.Lines.Add('T2-2021:      '+Query1.FieldByName('T2Key').AsString);
      If AllTrim(Query1.FieldByName('T3Key').AsString)>'' then
        reMessageText.Lines.Add('T3-2020:      '+Query1.FieldByName('T3Key').AsString);
      If AllTrim(Query1.FieldByName('TFKey').AsString)>'' then   //20171025
        reMessageText.Lines.Add('TF-2020:      '+Query1.FieldByName('TFKey').AsString);
      If AllTrim(Query1.FieldByName('T4Key').AsString)>'' then
        reMessageText.Lines.Add('T4T5-2020: '+Query1.FieldByName('T4Key').AsString);  //20171025
      If AllTrim(Query1.FieldByName('FPKey').AsString)>'' then
        reMessageText.Lines.Add('FP-2021:      '+Query1.FieldByName('FPKey').AsString);

      If AllTrim(Query1.FieldByName('TRKey').AsString)>'' then
      Begin
        reMessageText.Lines.Add('TR-2020:      '+Query1.FieldByName('TRKey').AsString);
      end;
      //20190102
      If AllTrim(Query1.FieldByName('TRKey').AsString)>'' then
       reMessageText.Lines.Add('Enter the TR key by clicking Help -> TrLoad');

      If AllTrim(Query1.FieldByName('S1Key').AsString)>'' then
        reMessageText.Lines.Add('vtScan for T1-2020:      '+Query1.FieldByName('S1Key').AsString);

      If AllTrim(Query1.FieldByName('S2Key').AsString)>'' then
        reMessageText.Lines.Add('vtScan for T2-2021:      '+Query1.FieldByName('S2Key').AsString);

      //20180917 Igor >>>
      If AllTrim(Query1.FieldByName('CLOUDKEY').AsString)>'' then
        reMessageText.Lines.Add('Cloud Key:      '+Query1.FieldByName('CLOUDKEY').AsString);
      //20180917 Igor <<<

      //20191015 Igor >>>
      BN := TBNList.Create;
      try
        for I := 1 to 6 do
        begin
          if (Query1.FieldByName('LimBN' + IntToStr(I)).AsString = '') then continue;
          BN.Add(Query1.FieldByName('LimBN' + IntToStr(I)).AsString + '=' + Query1.FieldByName('LimYE' + IntToStr(I)).AsString);
        end;
        BN.SaveToFile(SaveLimitedBNDialog.FileName);

        If AllTrim(BN.EncryptedText)>'' then
        Begin
          reMessageText.Lines.Add(' ');
          reMessageText.Lines.Add('Limited BNs:      '+ #13#10 +BN.EncryptedText);
          reMessageText.Lines.Add(' ');
          reMessageText.Lines.Add('You must enter the T2 key and the Limited BN key as well by clicking the SetBN button.');
          reMessageText.Lines.Add(' ');
          reMessageText.Lines.Add(' When you do the tax returns, ensure the BN and the Year End match what you ordered,');
          reMessageText.Lines.Add(' otherwise change them to match your order.');
         end;
      finally
        BN.Free;
      end;

      //20191015 Igor <<<


      reMessageText.Lines.Add(' ');
      reMessageText.Lines.Add('Please do not hesitate to contact us if you have any questions.');
      reMessageText.Lines.Add(' ');
      reMessageText.Lines.Add('Thanks');
      reMessageText.Lines.Add('Microsophic Inc.');
     end;

  2: begin  {external msg file}
      If Not FileExists(MsgFileBox.Text) then
      begin
       ShowMessage('Msg File does not exist');
       MsgOptionBox.ItemIndex:=-1;
       exit;
      end;
      reMessageText.Lines.LoadFromFile(MsgFilebox.text);
     end;
  3: begin   {typed in msg}
      If reMessageText.Lines.Count = 0 then
      begin
       ShowMessage('Msg text is required');
       MsgOptionBox.ItemIndex:=-1;
       exit;
      end;
     end;
  (*
  4:  //address verification
     Begin
      With Query1 do
      Begin
       Postal:=RemoveChar(FieldByName('POSTAL').AsString,' ');
       RemessageText.Lines.add(FieldByName('NAME').AsString);
       RemessageText.Lines.add(RemoveChar(UpperCase(FieldByName('STREET').AsString),'#'));
       RemessageText.Lines.add(Uppercase(FieldByName('CITY').AsString));
       RemessageText.Lines.add(UpperCase(FieldByName('PROVINCE').AsString));
       RemessageText.Lines.add(RemoveChar(FieldByName('POSTAL').AsString,' '));
       RemessageText.Lines.add(FieldByName('NAME').AsString);
       RemessageText.Lines.add(FieldByName('Contact').AsString);
       RemessageText.Lines.add(RemoveChar(FieldByName('POSTAL').AsString,' '));
       RemessageText.Lines.add(MidStr(postal,4,5));
      End;
     end;
   *)  
  end; {case}
 ShowCount;
 except on E: Exception do
   ShowMessage(E.Message);
 end;
end;


procedure TClients.PrepareMsgWithKeysToSent;
begin
(*
 ListBox1.Items.Add(Query1.FieldByName('Name').AsString);
 ListAddr.items.clear;
 ListAddr.Items.Add(Query1.FieldByName('EMail').AsString);
 EmailAddressBox.Text:=AllTrim(Query1.FieldByName('EMail').AsString);

 ReMessageText.Lines.clear;

 Case MsgOptionBox.ItemIndex of
  0,1:
   begin {Non CD users}
      reMessageText.Lines.Add('PLEASE KEEP THESE PROGRAM KEYS IN A SAFE PLACE');
      reMessageText.Lines.Add('AND DO NOT DISCLOSE THEM TO THIRD PARTIES.');
      reMessageText.Lines.Add(' ');
      reMessageText.Lines.Add('Your VisualTax program key(s) are:');
      reMessageText.Lines.Add(' ');
      If AllTrim(Query1.FieldByName('T1Key').AsString)>'' then
        reMessageText.Lines.Add('T1-2010:     '+Query1.FieldByName('T1Key').AsString);
      If AllTrim(Query1.FieldByName('T2Key').AsString)>'' then
        reMessageText.Lines.Add('T2-2011:     '+Query1.FieldByName('T2Key').AsString);
      If AllTrim(Query1.FieldByName('TFKey').AsString)>'' then
        reMessageText.Lines.Add('TF-2010:     '+Query1.FieldByName('TFKey').AsString);
      If AllTrim(Query1.FieldByName('T4Key').AsString)>'' then
        reMessageText.Lines.Add('T4-2010:     '+Query1.FieldByName('T4Key').AsString);
      If AllTrim(Query1.FieldByName('FPKey').AsString)>'' then
        reMessageText.Lines.Add('FP-2011:     '+Query1.FieldByName('FPKey').AsString);

      If AllTrim(Query1.FieldByName('TRKey').AsString)>'' then
        reMessageText.Lines.Add('TR-2010:     '+Query1.FieldByName('TRKey').AsString);

      reMessageText.Lines.Add(' ');
      reMessageText.Lines.Add('Keys are required the first time you run the program.');

      reMessageText.Lines.Add(' ');
      reMessageText.Lines.Add('Programs can be downloaded from the');
      reMessageText.Lines.Add('Downloads page of www.visualtax.com web site.');

      reMessageText.Lines.Add(' ');
      reMessageText.Lines.Add('Please do not hesitate to contact us if you have any questions.');
      reMessageText.Lines.Add(' ');
      reMessageText.Lines.Add('Thanks');
      reMessageText.Lines.Add('Microsophic Inc.');
     end;
  end; {case}
 ShowCount;
*)
end;


Procedure TClients.ShowCount;
begin
 LblCount.Caption := IntToStr(ListBox1.Items.Count);
 LblCount.Refresh;
end;

procedure TClients.FormCreate(Sender: TObject);
begin

T1LogsDir:='C:\MCLNT\EfileLogs-2020\';   //20161102  //20191101 CON
//T1LogsDir:='C:\MCLNT\EfileLogs-2016\';   //20161102
T2LogsDir:='C:\MCLNT\EfileLogsT2-2017-2021\'; //20161102 //20150223  //20191101 CON
//T2LogsDir:='C:\MCLNT\EfileLogsT2-2011-2016\'; //20161102 //20150223
eSubject.Text := 'VisualTax';
eFrom.Text := 'sales@visualtax.com'; // GetDefaultEmailAddress; //20111121  //20202202
//'visualtax@sympatico.ca';
eServer.Text:= 'SMTP1.sympatico.ca';
//eServer.Text:= 'smtphm.sympatico.ca';
MsgOptionBox.ItemIndex:=-1;
reMessageText.Lines.Clear;
ListBox1.Clear;
//20200611 Igor >>>
ForceDirectories(ExtractFilePath(ParamStr(0)) + SaveToSubFolder);
SaveLimitedBNDialog.FileName := ExtractFilePath(ParamStr(0)) + SaveToSubFolder + '\LimitedBN.D';
SaveLVerfDialog.FileName := ExtractFilePath(ParamStr(0)) + SaveToSubFolder + '\LVerf.EX_';
//20200611 Igor <<<

try
 WhereClause:='';
 OpenClientsQ;
except
 ShowMessage('cannot open data base');
end;
end;

procedure TClients.ClearBtnClick(Sender: TObject);
begin
ListBox1.Clear;
ShowCount;
end;

procedure TClients.PrintLabelsBtnClick(Sender: TObject);
Var i,ndx,FNo:Integer; Tbl:TTable;FlName,FName :String;
  FileNm:String;F1:textFile; S:string;
  KeysForLabels: TStringList;
begin
 {
 if MessageDlg('If you print labels from the 1996 data base,'+Chr(13)
      + 'you must re-build the Client Data Base at least once'+
      + Chr(13)+'using Utilities|Re-Build or Recalculate and Save'+
        Chr(13)+'Have you done it?',
        mtInformation, [mbYes, mbNo], 0) = mrNo then
        exit;
 }
 if MessageDlg('Load laser printer label sheets (2 5/8" X 1" (3 columns)'+
        Chr(13)+'Ready?',
        mtInformation, [mbYes, mbNo], 0) = mrNo then
        exit;

 If ListBox1.Items.Count =0 then
 begin
  ShowMessage('No client selected. Double click it');
  exit;
 end;
 KeysForLabels := TstringList.Create;
 For i := 0 to ListBox1.Items.Count-1 do
  KeysForLabels.Add(LeftStr(ListBox1.Items[i],54));
 FileNm:=AppDir+'\'+'TempFile';
 KeysForLabels.SaveToFile(FileNm);
 KeysForLabels.Free;
 If PrintDialog1.Execute then PrintLabels(AppDir,FileNm);
 exit;
end;


procedure TClients.FilterBtnClick(Sender: TObject);
begin
If AllTrim(Wherebox.Text) = '' then
  WhereClause:=''
else
 WhereClause:='WHERE ' +WhereBox.Text;
 OpenClientsQ;
(*
 ListBox1.Clear;
{this is a comment line....  }
 With table1 do
 begin
   First;
   Repeat
    If FieldByName('OrDate').AsString > ' ' then
    begin
     If (FieldByName('T2').AsString = '2')
     or (FieldByName('T3').AsString = '3')
     or (FieldByName('FP').AsString = 'F')
     then
      ListBox1.Items.Add(FieldByName('NAME').AsString);
    end;
     ShowCount;
    Next;
   until Eof;
 end;
*)
end;



procedure TClients.OpenClientsQ;
Const Star='*';
//20180917 Igor >>>
Var TempList, SQLList: TStringList;
    I, J: integer; //20191015 Igor
//20180917 Igor <<<    
begin
 If FileExists(AppDir+'\'+'DbInUse') and (AlreadyLogged = false) then
 Begin
  //ShowMessage('Data Base in use');
  if MessageDlg('DB IN USE- Terminate)?', mtWarning, [mbNo, mbYes], 0) = mrYes then
    Application.Terminate;
 End;
 AlreadyLogged:=True;  //20110212
 Try
 Query1.Close;
 Query1.SQL.Clear;
 {------------}
 With Query1 do
 begin
 SQL.Add('Select * ');
 SQL.Add('from Clients');
 If AllTrim(WhereClause) <> '' then SQL.Add(WhereClause);
 SQL.Add( 'ORDER BY Name');
 Prepare;

 open;
 //20191101

 //20180917 Igor >>>
 SQLList := TStringList.Create;

 try
   // add new fields for cloud
   if not Assigned(FindField('CLOUD')) then
   begin
     SQLList.Text := SQL.Text;
     Close;
     SQL.Text := 'ALTER TABLE "Clients.DBF" ADD CLOUD VARCHAR(1)';
     ExecSQL;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD CLOUDKEY VARCHAR(25)';
     ExecSQL;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD CLOUDDIR VARCHAR(50)';
     ExecSQL;
     SQL.Text := SQLList.Text;
     Open;
   end;

   //20181108 Igor >>>
   if not Assigned(FindField('ModifiedForExport')) then
   begin
     SQLList.Text := SQL.Text;
     Close;
     SQL.Text := 'ALTER TABLE "Clients.DBF" ADD ModifiedForExport VARCHAR(1)';
     ExecSQL;
     SQL.Text := SQLList.Text;
     Open;
   end;
   //20181108 Igor <<<

   //20190213 Igor >>>
   if not Assigned(FindField('CLOUDDATAD')) then
   begin
     SQLList.Text := SQL.Text;
     Close;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD CLOUDDATAD VARCHAR(200)';
     ExecSQL;
     SQL.Text := SQLList.Text;
     Open;
   end;
   //20190213 Igor <<<

   //20190306 Igor >>>
   if not Assigned(FindField('DROPBOX')) then
   begin
     SQLList.Text := SQL.Text;
     Close;
     SQL.Text := 'ALTER TABLE "Clients.DBF" ADD DROPBOX VARCHAR(1)';
     ExecSQL;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD DROPBOXKEY VARCHAR(25)';
     ExecSQL;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD T1CLOUD VARCHAR(1)';
     ExecSQL;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD T2CLOUD VARCHAR(1)';
     ExecSQL;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD T3CLOUD VARCHAR(1)';
     ExecSQL;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD T4CLOUD VARCHAR(1)';
     ExecSQL;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD TFCLOUD VARCHAR(1)';
     ExecSQL;
     SQL.Text := ' ALTER TABLE "Clients.DBF" ADD FPCLOUD VARCHAR(1)';
     ExecSQL;
     SQL.Text := SQLList.Text;
     Open;
   end;
   //20190306 Igor <<<

   //20191015 Igor >>>
   if not Assigned(FindField('LimBN1')) then
   begin
     SQLList.Text := SQL.Text;
     Close;
     for I := 1 to 6 do
     begin
      SQL.Text := 'ALTER TABLE "Clients.DBF" ADD LimBN'+ IntToStr(I) +' VARCHAR(4)';
      ExecSQL;
      SQL.Text := ' ALTER TABLE "Clients.DBF" ADD LimYE'+ IntToStr(I) +' VARCHAR(10)';
      ExecSQL;
     end;
     SQL.Text := SQLList.Text;
     Open;
   end;
   //20191015 Igor <<<

   (*// create sql so that cloud fields won't be at the end
   SQLList.Text := '';
   for I := 0 to FieldCount - 1 do
   begin
     if (Fields.Fields[I].FieldName = 'CLOUD') or
        (Fields.Fields[I].FieldName = 'CLOUDKEY') or
        (Fields.Fields[I].FieldName = 'CLOUDDIR') or
        (Fields.Fields[I].FieldName = 'CLOUDDATADIR') or //20190213 Igor
        //20190306 Igor >>>
        (Fields.Fields[I].FieldName = 'DROPBOX') or
        (Fields.Fields[I].FieldName = 'DROPBOXKEY') or
        (Fields.Fields[I].FieldName = 'T1CLOUD') or
        (Fields.Fields[I].FieldName = 'T2CLOUD') or
        (Fields.Fields[I].FieldName = 'T3CLOUD') or
        (Fields.Fields[I].FieldName = 'T4CLOUD') or
        (Fields.Fields[I].FieldName = 'TFCLOUD') or
        (Fields.Fields[I].FieldName = 'FPCLOUD') or
        //20191015 Igor >>>
        (UpperCase(Copy(Fields.Fields[I].FieldName, 1, 5)) = 'LIMBN') or
        (UpperCase(Copy(Fields.Fields[I].FieldName, 1, 5)) = 'LIMYE') then
        //20191015 Igor <<<
        //20190306 Igor <<<
       continue;

     if SQLList.Text = '' then
       SQLList.Add('SELECT '+ Fields.Fields[I].FieldName)
     else
       SQLList.Add('  ,'+ Fields.Fields[I].FieldName);
     //20191015 Igor >>>
     if (Fields.Fields[I].FieldName = 'S2') then
     begin
       SQLList.Add('  ,CLOUD,DROPBOX,T1CLOUD,T2CLOUD,T3CLOUD,T4CLOUD,TFCLOUD,FPCLOUD'); //20190306 Igor
       for J := 1 to 6 do
         SQLList.Add('  ,LimBN'+ IntToStr(J) +',LimYE'+ IntToStr(J)); //20190306 Igor
     end;
     //20191015 Igor <<<
     if (Fields.Fields[I].FieldName = 'S2KEY') then
       SQLList.Add('  ,CLOUDKEY,CLOUDDIR,CLOUDDATADIR,DROPBOXKEY'); //20190213 Igor //20190306 Igor
   end;
   SQLList.Add('FROM Clients');
   if AllTrim(WhereClause) <> '' then
     SQLList.Add(WhereClause);
   SQLList.Add('ORDER BY Name');
   SQL.Text := SQLList.Text;
   Open;   *)
 finally
   SQLList.Free;
 end;
 //20180917 Igor <<<
 //20191101
 DbCountLbl.Caption := IntToStr(Query1.RecordCount);
 {good only for local db and SELECT statement on Client server}
 {Query1.ExecSql;}  {good for INSERT, UPDATE, DELETE, and CREATE TABLE and client server db as well}
 end;
 Except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
 TempList:=TStringList.Create;
 TempList.Add('In use');
 TempList.SaveToFile(AppDir+'\'+'DbInUse');
end;

procedure TClients.CopyAllBtnClick(Sender: TObject);
begin
 Query1.First;
 Repeat
  ListBox1.Items.Add(Query1.FieldByName('Name').AsString);
  Query1.Next;
 until Query1.EOF;
 ShowCount;
end;


(*
procedure TAuthorFrm.PrintKeyBtnClick(Sender: TObject);
begin
 {PrintLabels;}
end;
*)

procedure TClients.StoreAKeyClick(Sender: TObject);
Var Version:String;
begin

 //temporary
 ReMessageText.Lines.clear;
 reMessageText.Lines.Add('   ');
 //reMessageText.Lines.Add('Program keys will be Emailed before Dec 15, 2015');
 //reMessageText.Lines.Add('   ');
 reMessageText.Lines.Add('Attached please find the Invoice/Receipt');

 reMessageText.Lines.Add('   ');
 reMessageText.Lines.Add('Thank you');
 reMessageText.Lines.Add('VisualTax');

 //EXIT;


 //---------------------------------------
 If Length(AllTrim(Query1.FieldByName('ACCOUNT').AsString))<7 then
 begin
  ShowMessage('Click button to Generate the Account Number first 7 digits needed)');
  Exit;
 end;

 If Length(AllTrim(Query1.FieldByName('PSW').AsString))<8 then
 begin
  ShowMessage('Click button to Generate the Password first (8 chars needed)');
  Exit;
 end;

 If ValidateProductVersion=false then exit;

 If ABS(Query1.FieldByName('BAL_DUE').AsFloat) >5 then
   ShowMessage('Watch Balance due of $'+ FormatFloat('###,###.##',Query1.FieldByName('BAL_DUE').AsFloat)); LoadProducts;

 If AllTrim(Query1.FieldByName('T1').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('T1Key').AsString)>'' then
    ShowMessage('T1 Key already in Data Base-NOT CHANGED')
  else
    StoreT1Key;
 end;

 If AllTrim(Query1.FieldByName('T2').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('T2Key').AsString)>'' then
   ShowMessage('T2 Key already in Data Base-NOT CHANGED')
  else
   StoreT2Key;
 end;

 If AllTrim(Query1.FieldByName('T3').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('T3Key').AsString)>'' then
    ShowMessage('T3 Key already in Data Base-NOT CHANGED')
  else
    StoreT3Key;
 end;

 //20171025 validations etc
 If AllTrim(Query1.FieldByName('TF').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('TFKey').AsString)>'' then
    ShowMessage('TF Key already in Data Base-NOT CHANGED')
  else
   StoreTFKey;
 end;


 If AllTrim(Query1.FieldByName('T4').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('T4Key').AsString)>'' then
    ShowMessage('T4T5 Key already in Data Base-NOT CHANGED')          //20171025
  else
   StoreT4Key;
 end;

 If AllTrim(Query1.FieldByName('FP').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('FPKey').AsString)>'' then
   ShowMessage('FP Key already in Data Base-NOT CHANGED')
  else
   StoreFPKey;
 end;

 If AllTrim(Query1.FieldByName('TR').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('TRKey').AsString)>'' then
   ShowMessage('TR Key already in Data Base-NOT CHANGED')
  else
   StoreTRKey;
 end;

 If AllTrim(Query1.FieldByName('S1').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('S1Key').AsString)>'' then
   ShowMessage('S1 Key already in Data Base-NOT CHANGED')
  else
   StoreS1Key;
 end;

 If AllTrim(Query1.FieldByName('S2').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('S2Key').AsString)>'' then
   ShowMessage('S2 Key already in Data Base-NOT CHANGED')
  else
   StoreS2Key;
 end;

 //20180917 Igor >>>
 If AllTrim(Query1.FieldByName('CLOUD').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('CLOUDKEY').AsString)>'' then
   ShowMessage('Cloud Key already in Data Base-NOT CHANGED')
  else
   StoreCloudKey;
 end;
 //20180917 Igor <<<

 //20190306 Igor >>>
 If AllTrim(Query1.FieldByName('DROPBOX').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('DROPBOXKEY').AsString)>'' then
   ShowMessage('DropBox Key already in Data Base-NOT CHANGED')
  else
   StoreDropBoxKey;
 end;
 //201306 Igor <<<
end;

procedure TClients.StoreAKeyForBatch;
begin
 LoadProducts;
 If AllTrim(Query1.FieldByName('T1Key').AsString)>'' then
   ShowMessage('T1 Key already in Data Base-NOT CHANGED')
 else
  StoreT1Key;

 If AllTrim(Query1.FieldByName('T2').AsString)>'' then
 begin
  If AllTrim(Query1.FieldByName('T2Key').AsString)>'' then
   ShowMessage('T2 Key already in Data Base-NOT CHANGED')
  else
   StoreT2Key;
 end;

 If AllTrim(Query1.FieldByName('T3Key').AsString)>'' then
   ShowMessage('T3 Key already in Data Base-NOT CHANGED')
 else
  StoreT3Key;

 If AllTrim(Query1.FieldByName('T4Key').AsString)>'' then
   ShowMessage('T4 Key already in Data Base-NOT CHANGED')
 else
  StoreT4Key;

 If AllTrim(Query1.FieldByName('TFKey').AsString)>'' then
   ShowMessage('TF Key already in Data Base-NOT CHANGED')
 else
  StoreTFKey;

 If AllTrim(Query1.FieldByName('FPKey').AsString)>'' then
  ShowMessage('FP Key already in Data Base-NOT CHANGED')
 else
  StoreFPKey;

 If AllTrim(Query1.FieldByName('TRKey').AsString)>'' then
  ShowMessage('TR Key already in Data Base-NOT CHANGED')
 else
  StoreTRKey;

 //20180917 Igor >>>
 If AllTrim(Query1.FieldByName('CLOUDKEY').AsString)>'' then
  ShowMessage('Cloud Key already in Data Base-NOT CHANGED')
 else
  StoreCloudKey;
 //20180917 Igor <<<

 //20190306 Igor >>>
 If AllTrim(Query1.FieldByName('DROPBOXKEY').AsString)>'' then
  ShowMessage('DropBox Key already in Data Base-NOT CHANGED')
 else
  StoreDropBoxKey;
 //20190306 Igor <<<
end;


procedure TClients.StoreAllKeysClick(Sender: TObject);
begin
 LoadProducts;
 Query1.First;
 Repeat
 If AllTrim(Query1.FieldByName('T1Key').AsString)='' then StoreT1Key;
 Delay(50);

 If AllTrim(Query1.FieldByName('T2Key').AsString)='' then StoreT2Key;
 Delay(50);

 If AllTrim(Query1.FieldByName('T3Key').AsString)='' then StoreT3Key;  //20171025
 Delay(50);

 If AllTrim(Query1.FieldByName('TFKey').AsString)='' then StoreTFKey;  //20171025
 Delay(50);

 If AllTrim(Query1.FieldByName('T4Key').AsString)='' then StoreT4Key;
 Delay(50);

 If AllTrim(Query1.FieldByName('FPKey').AsString)='' then StoreFPKey;
 Delay(50);

 If AllTrim(Query1.FieldByName('S1Key').AsString)='' then StoreS1Key;
 Delay(50);

 If AllTrim(Query1.FieldByName('S2Key').AsString)='' then StoreS2Key;
 Delay(50);

 //20180917 Igor >>>
 If AllTrim(Query1.FieldByName('CLOUDKEY').AsString)='' then StoreCloudKey;
 Delay(50);
 //20180917 Igor <<<

 //20190306 Igor >>>
 If AllTrim(Query1.FieldByName('DROPBOXKEY').AsString)='' then StoreDropBoxKey;
 Delay(50);
 //20190306 Igor <<<

 Query1.Next;
 until Query1.Eof;
end;

procedure TClients.EraseAllKeys;
begin
 Query1.First;
 Repeat
  Query1.Edit;
  Query1.FieldByName('T1Key').AsString:='';
  Query1.FieldByName('T2Key').AsString:='';
  Query1.FieldByName('T3Key').AsString:='';
  Query1.FieldByName('TFKey').AsString:='';
  Query1.FieldByName('T4Key').AsString:='';
  Query1.FieldByName('FPKey').AsString:='';
  Query1.FieldByName('TRKey').AsString:='';
  Query1.FieldByName('CLOUDKEY').AsString:=''; //20180917 Igor
  Query1.FieldByName('DROPBOXKEY').AsString:=''; //20190306 Igor
  Query1.Post;
  Query1.Next;
 until Query1.Eof;
 ShowMessage('Done');
end;


procedure TClients.StoreT1Key; // 20180904 Igor
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('T1').AsString) = 'X' then Pgm:= 'T1 Demo';
 If UpperCase(Query1.FieldByName('T1').AsString) = 'L' then Pgm:= 'T1 Limited';
 If UpperCase(Query1.FieldByName('T1').AsString) = 'E' then Pgm:= 'T1 Limited Efile';
 If UpperCase(Query1.FieldByName('T1').AsString) = 'N' then Pgm:= 'T1 Netfile';
 If UpperCase(Query1.FieldByName('T1').AsString) = 'S' then Pgm:= 'T1 Standard';
 If UpperCase(Query1.FieldByName('T1').AsString) = 'A' then Pgm:= 'T1 PaperFile';
 If UpperCase(Query1.FieldByName('T1').AsString) = 'P' then Pgm:= 'T1 Power';
 If UpperCase(Query1.FieldByName('T1').AsString) = 'M' then Pgm:= 'T1 MultiOffice';
 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  if UpperCase(Query1.FieldByName('T1').AsString) = 'X' then
    AKey:=MakeADemoKey(ProductId, Date + 14)
  else
    AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('T1Key').AsString:=AKey;
  Query1.Post;
 end;
end;


procedure TClients.StoreT2Key; // 20180904 Igor
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('T2').AsString) = 'X' then Pgm:= 'T2 Demo';
 If UpperCase(Query1.FieldByName('T2').AsString) = 'L' then Pgm:= 'T2 Limited';
 If UpperCase(Query1.FieldByName('T2').AsString) = 'F' then Pgm:= 'T2 Limited With Efile';
 If UpperCase(Query1.FieldByName('T2').AsString) = 'S' then Pgm:= 'T2 Standard';
 If UpperCase(Query1.FieldByName('T2').AsString) = 'P' then Pgm:= 'T2 Power';
 If UpperCase(Query1.FieldByName('T2').AsString) = 'M' then Pgm:= 'T2 MultiOffice';
 If UpperCase(Query1.FieldByName('T2').AsString) = 'E' then Pgm:= 'T2 Enterprise'; //20200916 Igor
 //20170628
 If UpperCase(Query1.FieldByName('T2').AsString) = '1' then Pgm:= 'T2 - Limited to 1 return';
 If UpperCase(Query1.FieldByName('T2').AsString) = '2' then Pgm:= 'T2 - Limited to 2 returns';
 If UpperCase(Query1.FieldByName('T2').AsString) = '3' then Pgm:= 'T2 - Limited to 3 returns';
 If UpperCase(Query1.FieldByName('T2').AsString) = '4' then Pgm:= 'T2 - Limited to 4 returns';
 If UpperCase(Query1.FieldByName('T2').AsString) = '5' then Pgm:= 'T2 - Limited to 5 returns';
 If UpperCase(Query1.FieldByName('T2').AsString) = '6' then Pgm:= 'T2 - Limited to 6 returns'; //20180829 CON

 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  if UpperCase(Query1.FieldByName('T2').AsString) = 'X' then
    AKey:=MakeADemoKey(ProductId, Date + 14)
  else
    AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('T2Key').AsString:=AKey;
  Query1.Post;
 end;
end;

procedure TClients.StoreT3Key; // 20180904 Igor
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('T3').AsString) = 'X' then Pgm:= 'T3 Demo';
 If UpperCase(Query1.FieldByName('T3').AsString) = 'S' then Pgm:= 'T3 Standard';
 If UpperCase(Query1.FieldByName('T3').AsString) = 'P' then Pgm:= 'T3 Power';
 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  if UpperCase(Query1.FieldByName('T3').AsString) = 'X' then
    AKey:=MakeADemoKey(ProductId, Date + 14)
  else
    AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('T3Key').AsString:=AKey;
  Query1.Post;
 end;
end;

procedure TClients.StoreTFKey; // 20180904 Igor
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('TF').AsString) = 'X' then Pgm:= 'TF Demo';
 If UpperCase(Query1.FieldByName('TF').AsString) = 'S' then Pgm:= 'TF Standard';
 If UpperCase(Query1.FieldByName('TF').AsString) = 'P' then Pgm:= 'TF Power';
 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  if UpperCase(Query1.FieldByName('TF').AsString) = 'X' then
    AKey:=MakeADemoKey(ProductId, Date + 14)
  else
    AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('TFKey').AsString:=AKey;
  Query1.Post;
 end;
end;


// 2002 T4
procedure TClients.StoreT4Key; // 20180904 Igor
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('T4').AsString) = 'X' then Pgm:= 'T4 Demo';
 If UpperCase(Query1.FieldByName('T4').AsString) = 'S' then Pgm:= 'T4 Standard';
 If UpperCase(Query1.FieldByName('T4').AsString) = 'P' then Pgm:= 'T4 Power';
 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  if UpperCase(Query1.FieldByName('T4').AsString) = 'X' then
    AKey:=MakeADemoKey(ProductId, Date + 14)
  else
    AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('T4Key').AsString:=AKey;
  Query1.Post;
 end;
end;

procedure TClients.StoreFPKey; // 20180904 Igor
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('FP').AsString) = 'X' then Pgm:= 'FP Demo';
 If UpperCase(Query1.FieldByName('FP').AsString) = 'L' then Pgm:= 'FP Limited';
 If UpperCase(Query1.FieldByName('FP').AsString) = 'S' then Pgm:= 'FP Standard';
 If UpperCase(Query1.FieldByName('FP').AsString) = 'P' then Pgm:= 'FP Power';
 If UpperCase(Query1.FieldByName('FP').AsString) = 'A' then Pgm:= 'FP Agent';
 If UpperCase(Query1.FieldByName('FP').AsString) = 'M' then Pgm:= 'FP Multi-Agent';
 If UpperCase(Query1.FieldByName('FP').AsString) = 'D' then Pgm:= 'FP Dealer';
 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  if UpperCase(Query1.FieldByName('FP').AsString) = 'X' then
    AKey:=MakeADemoKey(ProductId, Date + 14)
  else
    AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('FPKey').AsString:=AKey;
  Query1.Post;
 end;
end;

procedure TClients.StoreTRKey; // 20180904 Igor
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('TR').AsString) = 'X' then Pgm:= 'TR Demo';
 If UpperCase(Query1.FieldByName('TR').AsString) = 'S' then Pgm:= 'TR Standard';
 If UpperCase(Query1.FieldByName('TR').AsString) = 'P' then Pgm:= 'TR Power';
 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  if UpperCase(Query1.FieldByName('TR').AsString) = 'X' then
    AKey:=MakeADemoKey(ProductId, Date + 14)
  else
    AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('TRKEY').AsString:=AKey;
  Query1.Post;
  Delay(100);
 end;
end;

procedure TClients.StoreS1Key;
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('S1').AsString) >'' then Pgm:= 'S1 Standard';
 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('S1KEY').AsString:=AKey;
  Query1.Post;
  Delay(100);
 end;
end;

procedure TClients.StoreS2Key;
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('S2').AsString) >'' then Pgm:= 'S2 Standard';
 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('S2KEY').AsString:=AKey;
  Query1.Post;
  Delay(100);
 end;
end;

procedure TClients.EraseAllKeysBtnClick(Sender: TObject);
begin
EraseAllKeys;
end;

procedure TClients.PrintClientKeysBtnClick(Sender: TObject);
Var i,ndx,FNo:Integer; Tbl:TTable;FlName,FName :String;
  FileNm:String;F1:textFile; S:string;
  KeysForLabels: TStringList;
begin
 if MessageDlg('Load laser printer label sheets (2 5/8" X 1" (3 columns)'+
        Chr(13)+'Ready?',
        mtInformation, [mbYes, mbNo], 0) = mrNo then exit;


 If ListBox1.Items.Count =0 then exit;
 KeysForLabels := TstringList.Create;
 For i := 0 to ListBox1.Items.Count-1 do
  KeysForLabels.Add(LeftStr(ListBox1.Items[i],34));
 FileNm:=AppDir+'\'+'TempFile';
 KeysForLabels.SaveToFile(FileNm);
 KeysForLabels.Free;
 If PrintDialog1.Execute then PrintKeyLabels(AppDir,FileNm);
 exit;
end;

Function TClients.PrintKeyLabels(DataDir,FileNm:String):boolean;
var
  Tbl:TTable;
  i,RecNo,LineCnt,MxLinesPerPage,PageCnt:integer;
  PrnFile: TextFile;
  XPos :LongInt;YPos : LongInt;
  InpFile :TextFile;InpKey:String;
  PixPerInX, PixPerInY : Integer;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap: Integer;
  column1, column2, column3 : integer;
  Line1,Line2,Line3,Line4,Line5:String;
  WhichKey:String;
begin
 {Set up label parameters}
  WhichKey:= InputBox('Input Box', 'Enter T1, T2, TF, T4, TR, FP, S1, S2, CLOUD, DROPBOX', 'T1'); //20180917 Igor //20190306 Igor





  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);

  TopMargin  := Trunc(0.5 *  PixPerInY);
  LabelHeight:= Trunc(1   * PixPerInY);  {1 inch}
  VertIncr :=  Trunc(PixPerInY * (1/6));   {6 lines per inch}

  //LeftMargin := Trunc(1/8 *  PixPerInY);
  //LabelWidth := Trunc(2.5 * PixPerInX);    {2.5 inches}
  //HorizLabelGap := Trunc(1/8 *  PixPerInX);

  //use fixed columns instead
  column1 := Trunc(0.128 * PixPerInY);
  column2 := Trunc(2.945 * PixPerInY);
  column3 := Trunc(5.655 * PixPerInY);


  {open the input file of keys}
  AssignFile(InpFile, FileNm);
  Reset(InpFile);
  {start printer}
  Printer.BeginDoc;
  { Get data from data base}
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := DataDir;
  Tbl.TableName := 'CLIENTS.DBF';
  Tbl.IndexName := 'NAME';
  If Tbl.Active then Tbl.Close;
  Tbl.Open;

  RecNo :=0;
  while not Eof(InpFile) do
  begin
    ReadLn(InpFile, InpKey);
    if Tbl.FindKey([InpKey]) then
     begin
      Inc(RecNo);
      If RecNo >30 then begin RecNo :=1; Printer.NewPage; end;

      //20171025  Changed years
     // 20180904 Igor >>>
     If UpperCase(WhichKey) = 'T1' then
     begin
      {T1 key only}
      Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
      Line2 := 'Your T1-2020 key is:';
      Line3 := Tbl.FieldByName('T1Key').AsString;
      Line4 := '';
      Line5 := '';
     end;

     If UpperCase(WhichKey) = 'T2' then
     begin
      {T2 key only}
      Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
      Line2 := 'Your T2-2021 key is:';
      Line3 :=Tbl.FieldByName('T2Key').AsString;
      Line4 := '';
      Line5 := '';
      end;

     If UpperCase(WhichKey) = 'T3' then
     begin
      Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
      Line2 := 'Your T3-2020 key is:';
      Line3 := Tbl.FieldByName('T3Key').AsString;
      Line4 := '';
      Line5 := '';
      end;


     If UpperCase(WhichKey) = 'TF' then
     begin
      Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
      Line2 := 'Your TF-2020 key is:';
      Line3 := Tbl.FieldByName('TFKey').AsString;
      Line4 := '';
      Line5 := '';
      end;

     If UpperCase(WhichKey) = 'T4' then
     begin
      Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
      Line2 := 'Your T4T4AT5-2020 key is:';
      Line3 := Tbl.FieldByName('T4Key').AsString;
      Line4 := ' ';
      Line5 := '';
      end;


     If UpperCase(WhichKey) = 'FP' then
     begin
      {T2 key only}
      Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
      Line2 := 'Your FP-2021 key is:';
      Line3 := Tbl.FieldByName('FPKey').AsString;
      Line4 := ' ';
      Line5 := '';
      end;

     If UpperCase(WhichKey) = 'TR' then
     begin
      {T2 key only}
      Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
      Line2 := 'Your TR-2020 key is:';
      Line3 := Tbl.FieldByName('TRKey').AsString;
      Line4 := ' ';
      Line5 := ' ';
      end;

     If UpperCase(WhichKey) = 'S1' then
     begin
       {S1 key only}
       Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
       Line2 := 'Your VtScan for T1-2020 key is:';
       Line3 := Tbl.FieldByName('S1Key').AsString;
       Line4 := ' ';
       Line5 := ' ';
      end;

    If UpperCase(WhichKey) = 'S2' then
     begin
       {S1 key only}
       Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
       Line2 := 'Your VtScan for T2-2021 key is:';
       Line3 := Tbl.FieldByName('S2Key').AsString;
       Line4 := ' ';
       Line5 := ' ';
      end;

    //20180917 Igor >>>
    If UpperCase(WhichKey) = 'CLOUD' then
     begin
       {Cloud key only}
       Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
       Line2 := 'Your Cloud key is:';
       Line3 := Tbl.FieldByName('CLOUDKEY').AsString;
       Line4 := ' ';
       Line5 := ' ';
      end;
    //20180917 Igor <<<

    //20190306 Igor >>>
    If UpperCase(WhichKey) = 'DROPBOX' then
     begin
       {DropBox key only}
       Line1 := LeftStr(AllTrim(Tbl.FieldByName('NAME').AsString),40);
       Line2 := 'Your DropBox key is:';
       Line3 := Tbl.FieldByName('DROPBOXKEY').AsString;
       Line4 := ' ';
       Line5 := ' ';
      end;
    //20190306 Igor <<<

      // 20180904 Igor <<<

      If RecNo < 11 then  {left label}
        begin
         LabelPosX := column1; //LeftMargin;
         LabelPosY := TopMargin+(RecNo-1)*LabelHeight;
        end;
      If (RecNo >10) and (RecNo < 21) then  {Midle label}
         begin
         LabelPosX := column2; //LeftMargin+LabelWidth+HorizLabelGap;
         LabelPosY := TopMargin+(RecNo-11)*LabelHeight;
         end;
      If (RecNo >20) then  {right label}
          begin
          LabelPosX := column3; //LeftMargin+2 *LabelWidth+3 * HorizLabelGap;
          LabelPosY := TopMargin+(RecNo-21)*LabelHeight;
          end;
      PrintAKeyLabel(LabelPosX,LabelPosY,Line1,Line2,Line3,Line4,Line5);
     end;
  end; {end while}

  CloseFile(InpFile);
  Tbl.Free;
  Printer.EndDoc;
  Result := True;
end;

Procedure TClients.PrintAKeyLabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
{pos in pixels}
Var
XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
begin
  Printer.Canvas.Font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 8;
  XPos := LabelPosX +2;
  YPos := LabelPosY+2;
  VertIncr := Trunc(PixPerInY * (1/6));
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(XPos,YPos,Line1);
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.TextOut(XPos,YPos+1 * VertIncr,Line2);
  Printer.Canvas.TextOut(XPos,YPos+2 * VertIncr,Line3);
  Printer.Canvas.TextOut(XPos,YPos+3 * VertIncr,Line4);
  Printer.Canvas.TextOut(XPos,YPos+4 * VertIncr,Line5);
end;

procedure TClients.BtnSendAllClick(Sender: TObject);
var
  nItem, nBcc: Integer;
  Res: Word;
begin
 MsgOptionBox.ItemIndex :=-1;

 If MsgOptionBox.ItemIndex =-1 then
 begin
   If UpperCase(AllTrim(Query1.FieldByName('CD_NUM').AsString)) > '' then
    MsgOptionBox.ItemIndex :=1
   else
    MsgOptionBox.ItemIndex :=0;
 end;


  If MsgOptionBox.ItemIndex<0 then
  begin
   ShowMessage('You must select a Message Option');
   exit;
  end;

  nItem:=0;

  If EFrom.Text='' then
  begin
   ShowMessage('Enter From mail address');
   Efrom.setFocus;
   exit;
  end;
  If EServer.Text='' then
  begin
   ShowMessage('Enter Mail Server name');
   EServer.SetFocus;
   exit;
  end;

  If ListAddr.items.Count =0 then
  begin
  ShowMessage('The Recipient list is empty');
  exit;
  end;

  // connect
  Mail.Host := eServer.Text;
  Mail.UserID := eFrom.Text;
  If not Mail.Connected then
  begin
   Mail.Connect;
  end;


  // set the fixed part of the header
  Mail.PostMessage.FromAddress := eFrom.Text;
  Mail.PostMessage.ToAddress.Clear;
  Mail.PostMessage.ToAddress.Add (ListAddr.items[nItem]);
  Mail.PostMessage.Subject := eSubject.Text;
  Mail.PostMessage.Body.SetText (
    reMessageText.Lines.GetText);

  // send to list, in groups
  while nItem < ListAddr.Items.Count do
  begin
    ListAddr.ItemIndex := nItem;
    Application.ProcessMessages;
    // fill the bcc list
    Mail.PostMessage.ToBlindCarbonCopy.Clear;
    nBcc := 1;
    while (nBcc < MaxBccGroup) and (nBcc + nItem < ListAddr.Items.Count) do
    begin
      {NO BBC Here: Mail.PostMessage.ToBlindCarbonCopy.Add (ListAddr.Items [nItem + nBcc]);}
      Inc (nBcc);
    end;
    // send the message
    Mail.SendMail;
    Inc (nItem, nBcc);
  end;

  // we're done
  Mail.Disconnect;
  If MsgOptionBox.ItemIndex=2 then
  begin
   Query1.Edit;
   Query1.FieldByName('ACKN_sent').AsString:='Y';
  end;

  If (MsgOptionBox.ItemIndex=0)
  or (MsgOptionBox.ItemIndex=1) then
  begin
  //update keys sent
    Query1.Edit;
    Query1.FieldByName('Keys_sent').AsString:='Y';
    Query1.Refresh;
  end;
  ShowMessage('done');
  ClearBtnClick(Sender);
end;

procedure TClients.SearchBtnClick(Sender: TObject);
Var S,Rec:String;
begin
 s:= InputBox('Input Box', 'Enter string', '');
 DbGrid1.DataSource:=Nil; {avoid scrolling and flickering}
 Query1.First;
 Repeat
  Rec:=  Query1.FieldByName('Name').AsString+' '
        +Query1.FieldByName('Phone').AsString+' '
        +Query1.FieldByName('Contact').AsString+' '
        +Query1.FieldByName('EMail').AsString+' '
        +Query1.FieldByName('ChequeName').AsString+' ';

  If FindWord(S,Rec)>0 then
  begin
    DbGrid1.DataSource:=DataSource1;
    if MessageDlg(
     Query1.FieldByName('Name').AsString
     +Chr(13)+Query1.FieldByName('AreaP').AsString+' '
     +Query1.FieldByName('Phone').AsString
     +Chr(13)+Query1.FieldByName('Contact').AsString
     +Chr(13)+Query1.FieldByName('EMail').AsString
     +Chr(13)+Query1.FieldByName('ChequeName').AsString
     +Chr(13)+'Continue?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      begin
       DbGrid1.DataSource:=DataSource1;
       exit;
      end;
  end;
  DbGrid1.DataSource:=Nil; {avoid scrolling and flickering}
  Query1.Next;
 until Query1.EOF;
 Query1.First;
 DbGrid1.DataSource:=DataSource1;
 ShowMessage('Not found');
end;

procedure TClients.SumBtnClick(Sender: TObject);
Var TotalPaid:Real;BalDue,Overpayment:Real;
 TotSale1,TotHst1,TotSale2,TotHst2,TotSale3,TotHst3,TotSale4,TotHst4:Real;
begin
 TotalPaid:=0;
 BalDue:=0;
 Overpayment:=0;
 //20150728
 TotSale1:=0;
 TotHst1:=0;
 TotSale2:=0;
 TotHst2:=0;
 TotSale3:=0;
 TotHst3:=0;
 TotSale4:=0;
 TotHst4:=0;

 DbGrid1.DataSource:=Nil;
 Query1.First;
 Repeat
  TotalPaid:=TotalPaid+Query1.FieldByName('PAID').AsFloat;
  {
  //20150728
  TotSale1:=TotSale1+Query1.FieldByName('Sale1').AsFloat;
  TotHst1:=TotHst1+Query1.FieldByName('Hst1').AsFloat;
  TotSale2:=TotSale2+Query1.FieldByName('Sale2').AsFloat;
  TotHst2:=TotHst2+Query1.FieldByName('Hst2').AsFloat;
  TotSale3:=TotSale3+Query1.FieldByName('Sale3').AsFloat;
  TotHst3:=TotHst3+Query1.FieldByName('Hst3').AsFloat;
  TotSale4:=TotSale4+Query1.FieldByName('Sale4').AsFloat;
  TotHst4:=TotHst4+Query1.FieldByName('Hst4').AsFloat;
  }
  If Query1.FieldByName('BAL_DUE').AsFloat >0 then
    BalDue:=BalDue+Query1.FieldByName('BAL_DUE').AsFloat
  else
    Overpayment:=Overpayment+Query1.FieldByName('BAL_DUE').AsFloat;
  Query1.Next;
 until Query1.EOF;

 Query1.First;
 DbGrid1.DataSource:=DataSource1;
 //20150728
 ShowMessage('Total Paid $'+FormatFloat('##,###,###.##',TotalPaid)
            +Chr(13)+'Balance Due $'+FormatFloat('##,###,###.##',BalDue)
            +Chr(13)+'Overpayment $'+FormatFloat('##,###,###.##',Overpayment));
            {
            +Chr(13)+'Sale1 $'+FormatFloat('##,###,###.##',TotSale1)+'     Hst1 $'+FormatFloat('##,###,###.##',TotHst1)
            +Chr(13)+'Sale2 $'+FormatFloat('##,###,###.##',TotSale2)+'     Hst2 $'+FormatFloat('##,###,###.##',TotHst2)
            +Chr(13)+'Sale3 $'+FormatFloat('##,###,###.##',TotSale3)+'     Hst3 $'+FormatFloat('##,###,###.##',TotHst3)
            +Chr(13)+'Sale4 $'+FormatFloat('##,###,###.##',TotSale4)+'     Hst4 $'+FormatFloat('##,###,###.##',TotHst4)
            );
            }
end;

procedure TClients.ListBox1DblClick(Sender: TObject);
begin
ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TClients.GetMsgFileBtnClick(Sender: TObject);
begin
 OpenDialog1.InitialDir:=AppDir+'\'+'BroadCastMsg';
 If OpenDialog1.Execute then
 begin
  MsgFileBox.Text:=OpenDialog1.FileName;
  reMessageText.Clear;
  reMessageText.Lines.LoadFromFile(MsgFilebox.text);
 end;
end;


procedure TClients.ClearIndicatorsBtnClick(Sender: TObject);
begin
  if MessageDlg('Clear Msg_sent indicators?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;

 Query1.First;
 Repeat
  Query1.Edit;
  Query1.FieldByName('Msg_sent').AsString:='';
  Query1.Post;
  Query1.Next;
 until Query1.Eof;
 Query1.First;
end;

procedure TClients.AddBccBtnClick(Sender: TObject);
Var s:String;
begin
  s:= InputBox('Input Box', 'Enter Email address', 'visualtax@sympatico.ca');
  If S>'' then BccList.Items.Add(S);
end;

procedure TClients.ReadEmail1Click(Sender: TObject);
begin
 Application.CreateForm(TReadEMail,ReadEMail);
 ReadEMail.ShowModal;
 ReadEMail.Free;
end;

procedure TClients.SendBccBtnClick(Sender: TObject);
var
  nItem, nBcc: Integer;
  Res: Word;
  AllRecipients:AnsiString;
  SomeText:AnsiString;
  SomeSubject:String;
begin

  If EFrom.Text='' then begin ShowMessage('Enter From mail address'); Efrom.setFocus;exit;end;
  If EServer.Text='' then begin ShowMessage('Enter Mail Server name'); EServer.SetFocus; exit; end;
  If BccList.items.Count =0 then begin ShowMessage('The BCC list is empty'); exit; end;

  Screen.Cursor := crHourGlass;

  //create list
  AllRecipients:='';
  nItem:=0;
  // send to list, in groups
  while nItem < BccList.Items.Count do
  begin
    // show the current selection
    BccList.ItemIndex := nItem;
    nBcc := 0;
    while (nBcc < MaxBccGroup) and (nBcc + nItem < BCCList.Items.Count) do
    begin
     AllRecipients:=AllRecipients+BccList.Items [nItem + nBcc];
     Inc (nBcc);
    end;
    Inc (nItem, nBcc);
  end;
  RichEdit1.text:=AllRecipients;
  BccList.Items.SaveToFile(AppDir+'\'+'BCCList.txt');
  RichEdit1.CopyToClipboard;
  SomeSubject := eSubject.Text;
  SomeText:=reMessageText.Lines.GetText;
  SendMapiMail(esubject.text,SomeText,'','','','','visualtax@sympatico.ca');
  Screen.Cursor := crDefault;
end;

procedure TClients.MailRecipientNotFound(Recipient: String);
begin
 ShowMessage('Address' + ' not found');
end;

procedure TClients.MailFailure(Sender: TObject);
begin
 ShowMessage('Failed');
end;

procedure TClients.ClearBccBtnBccClick(Sender: TObject);
begin
BccList.Clear;
//ShowCount;
end;

procedure TClients.CopyAllToBccBtnClick(Sender: TObject);
begin
 Query1.First;
 Repeat
  If AllTrim(Query1.FieldByName('EMail').AsString) >'' then
    BccList.Items.Add(Query1.FieldByName('EMail').AsString+';');
  Query1.Next;
 until Query1.EOF;
 //ShowCount;
end;

procedure TClients.BccListDblClick(Sender: TObject);
begin
BccList.Items.Delete(BccList.ItemIndex);
end;


Procedure TClients.UpdateQueryMsgSent(EmailAddr:String);
begin
 DbGrid1.DataSource:=Nil;
 EMailAddr:=UpperCase(EMailAddr);
 Query1.First;
 Repeat
   If UpperCase(AllTrim(Query1.FieldByName('Email').AsString)) = EMailAddr then
    Begin
     Query1.Edit;
     Query1.FieldByName('ACKN_sent').AsString:='Y';
     DbGrid1.DataSource:=DataSource1;
     Exit;
    end;
    Query1.Next;
 until Query1.Eof;
 DbGrid1.DataSource:=DataSource1;
end;

procedure TClients.PrintLitingBtnClick(Sender: TObject);
Var i,ndx,FNo:Integer; Tbl:TTable;FlName,FName :String;
  FileNm:String;F1:textFile; S:string;
  KeysForLabels: TStringList;
begin
 If ListBox1.Items.Count =0 then exit;
 //LabelPosX := LeftMargin;
 KeysForLabels := TstringList.Create;
 For i := 0 to ListBox1.Items.Count-1 do
  KeysForLabels.Add(LeftStr(ListBox1.Items[i],34));
 FileNm:=AppDir+'\'+'TempFile';
 KeysForLabels.SaveToFile(FileNm);
 KeysForLabels.Free;
 If PrintDialog1.Execute then PrintListing(AppDir,FileNm);
 exit;
end;


procedure TClients.Button1Click(Sender: TObject);
begin
 if MessageDlg('INITIALIZE Data Base for new year?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;

 Query1.First;
 Repeat
  Query1.Edit;
  If UppeRcase(AllTrim(Query1.FieldByName('NC').AsString)) ='Y' then
      Query1.FieldByName('NC').AsString:='N';
  (*
  If UppeRcase(AllTrim(Query1.FieldByName('ORDATE').AsString)) ='D' then
  begin
   If Query1.FieldByName('NC').AsString <> 'D' then
           Query1.FieldByName('NC').AsString:='';
  end;
  *)
  Query1.FieldByName('CD_NUM').AsString:='';
  //Query1.FieldByName('IN').AsString:='';
  //Query1.FieldByName('PR').AsString:='';

  Query1.FieldByName('T1').AsString:='';
  Query1.FieldByName('T2').AsString:='';
  Query1.FieldByName('T3').AsString:='';
  Query1.FieldByName('T4').AsString:='';
  Query1.FieldByName('FP').AsString:='';
  Query1.FieldByName('TR').AsString:='';
  Query1.FieldByName('AR').AsString:='';
  Query1.FieldByName('CLOUD').AsString:=''; //20180917 Igor
  //20190306 Igor >>>
  Query1.FieldByName('DROPBOX').AsString:='';
  Query1.FieldByName('T1CLOUD').AsString:='';
  Query1.FieldByName('T2CLOUD').AsString:='';
  Query1.FieldByName('T3CLOUD').AsString:='';
  Query1.FieldByName('T4CLOUD').AsString:='';
  Query1.FieldByName('TFCLOUD').AsString:='';
  Query1.FieldByName('FPCLOUD').AsString:='';
  //20190306 Igor <<<
  //Query1.FieldByName('CICA_T1').AsString:='';
  //Query1.FieldByName('CICA_T2').AsString:='';
  Query1.FieldByName('T2_2004Key').AsString:='';
  Query1.FieldByName('KEYS_SENT').AsString:='';
  Query1.FieldByName('TRKey').AsString:='';
  Query1.FieldByName('HOW_ORD').AsString:='';
  //Query1.FieldByName('CICA_SENT').AsString:='';

  Query1.FieldByName('ORDATE').AsString:='';
  Query1.FieldByName('Paid').AsFloat:=0;
  Query1.FieldByName('Gst').AsFloat:=0;
  Query1.FieldByName('Pst').AsFloat:=0;
  Query1.FieldByName('Hst').AsFloat:=0;
  Query1.FieldByName('Provtax').AsFloat:=0;
  Query1.FieldByName('InvoiceNo').AsString:='';
  Query1.FieldByName('Discount').AsFloat:=0;
  Query1.FieldByName('EFDiscount').AsFloat:=0;

  Query1.FieldByName('T1Key').AsString:='';
  Query1.FieldByName('T2Key').AsString:='';
  Query1.FieldByName('T3Key').AsString:='';
  Query1.FieldByName('TFKey').AsString:='';
  Query1.FieldByName('T4Key').AsString:='';
  Query1.FieldByName('FPKey').AsString:='';
  Query1.FieldByName('CLOUDKEY').AsString:=''; //20180917 Igor
  Query1.FieldByName('DROPBOXKEY').AsString:=''; //20190306 Igor

  //20200918
  Query1.FieldByName('LIMBN1').AsString:='';
  Query1.FieldByName('LIMBN2').AsString:='';
  Query1.FieldByName('LIMBN3').AsString:='';
  Query1.FieldByName('LIMBN4').AsString:='';
  Query1.FieldByName('LIMBN5').AsString:='';
  Query1.FieldByName('LIMBN6').AsString:='';


  Query1.FieldByName('LIMEN1').AsString:='';
  Query1.FieldByName('LIMEN2').AsString:='';
  Query1.FieldByName('LIMEN3').AsString:='';
  Query1.FieldByName('LIMEN4').AsString:='';
  Query1.FieldByName('LIMEN5').AsString:='';Query1.FieldByName('Msg_sent').AsString:='';
  Query1.FieldByName('LIMEN6').AsString:='';Query1.FieldByName('Ackn_sent').AsString:='';

  //Query1.FieldByName('T2_2002key').AsString:='';
  //Query1.FieldByName('Msg_sent').AsString:='';
  Query1.Post;
  Query1.Next;
 until Query1.Eof;
 Query1.First;

 ShowMessage('Done');
end;

procedure TClients.Compare1Click(Sender: TObject);
Const FlName='Compare.txt';
 var
 FullFlname:String;
 Pgm:String;
 i,CntNotPaid : integer;
 F1 : TextFile;
 ScrRec : string;
 Table1 : TTable;
 Tbl:TTable;
 InpKey:String;
 Templist:TStringList;
 TotalPaid:Real;
 NewLastYear:Integer;
 begin
  FullFlName:=AppDir+'\'+FlName;
  CntNotPaid:=0;TotalPaid:=0;
  NewLastYear:=0;
  TempList:=TStringList.Create;
  TempList.Sorted:=True;
  //this year's DBF
  Tbl := TTable.Create(Application);
  Tbl.TableName := 'CLIENTS.DBF';
  Tbl.IndexName := 'NAME';
  If Tbl.Active then Tbl.Close;
  Tbl.Open;
  //last years
  Table1 := TTable.Create(Application);
  Table1.DataBaseName := 'C:\MCLNT'+IntToStr(StrToInt(AppYear)-2000-1); //AppDir;  //20130724
  Table1.TableName := 'Clients.DBF';
  Table1.IndexName := 'NAME';
  If Table1.Active then Table1.Close;
  Table1.Open;
  //COMPARE
    TempList.Add(PaddR('Paid previous year but not this year',20));
    Table1.First;
    while not Table1.EOF do
    begin
       // old customers only
       InpKey:=Table1.FieldByName('Name').AsString;  //last years
       if Tbl.FindKey([InpKey]) then
        begin
         If (Table1.FieldByName('Paid').AsFloat >0)
         then  //not paid this year
         begin
          If (Tbl.FieldByName('Paid').AsFloat =0) then
          begin
           TempList.Add(Table1.FieldByName('NC').AsString
             +' '+Table1.FieldByName('ORDATE').AsString
             +' '+Table1.FieldByName('NC').AsString
             +' '
             +PaddR(Table1.FieldByName('T1').AsString,1)
             +PaddR(Table1.FieldByName('T2').AsString,1)
             +PaddR(Table1.FieldByName('T3').AsString,1)
             +'  '
             +PaddR(FormatFloat('###,###.##',Table1.FieldByName('Paid').AsFloat),20)
             +Space(5)+PaddR(FormatFloat('###,###.##',Tbl.FieldByName('Paid').AsFloat),20)
             +PaddR(InpKey,40));

            TotalPaid:=TotalPaid+Table1.FieldByName('Paid').AsFloat;
            If Table1.FieldByName('NC').AsString='Y' then Inc(NewLastYear);
            Inc(CntNotPaid);
          end;
         end;
       end;

       Table1.Next;
    end;
       Table1.Close;

   TempList.Add('**** Total paid last year '+FormatFloat('###,###.##',TotalPaid));
   TempList.Add('**** Did not pay this year: '+IntToStr(CntNotPaid));
   TempList.Add('**** New last yer. Did not come back '+IntToStr(NewLastYear));
   TempList.SaveToFile(FullFlName); //'C:\mclnt\Compare.txt');
   TempList.Free;
   Pgm:='c:\windows\notepad.exe';
   ShellExecute(Handle,'open', Pchar(''+Pgm),Pchar(''+FullFlName), nil, SW_SHOWNORMAL) ;
   // ShowMessage('see C:\mclnt\Compare.txt');
 end;


procedure TClients.InitializeBtnClick(Sender: TObject);
begin
 Query1.First;
 Repeat
 Query1.Edit;
 If Query1.FieldByName('NC').AsString='Y' then
    Query1.FieldByName('NC').AsString:='N';
 Query1.FieldByName('CD_NUM').AsString:='';
 Query1.FieldByName('CD_FOR').AsString:='';
 Query1.FieldByName('T1').AsString:='';
 Query1.FieldByName('T2').AsString:='';
 Query1.FieldByName('T3').AsString:='';
 Query1.FieldByName('TF').AsString:='';  //20171025
 Query1.FieldByName('T4').AsString:='';
 Query1.FieldByName('FP').AsString:='';
 Query1.FieldByName('AR').AsString:='';
 Query1.FieldByName('TR').AsString:='';
 Query1.FieldByName('S1').AsString:='';
 Query1.FieldByName('S2').AsString:='';
 Query1.FieldByName('CLOUD').AsString:=''; //20180917 Igor
 //20190306 Igor >>>
 Query1.FieldByName('DROPBOX').AsString:='';
 Query1.FieldByName('T1CLOUD').AsString:='';
 Query1.FieldByName('T2CLOUD').AsString:='';
 Query1.FieldByName('T3CLOUD').AsString:='';
 Query1.FieldByName('T4CLOUD').AsString:='';
 Query1.FieldByName('TFCLOUD').AsString:='';
 Query1.FieldByName('FPCLOUD').AsString:='';
 //20190306 Igor <<<

 Query1.FieldByName('T1Key').AsString:='';
 Query1.FieldByName('T2Key').AsString:='';
 Query1.FieldByName('T3Key').AsString:='';
 Query1.FieldByName('TFKey').AsString:='';
 Query1.FieldByName('T4Key').AsString:='';
 Query1.FieldByName('FPKey').AsString:='';
 Query1.FieldByName('TRKey').AsString:='';
 Query1.FieldByName('S1Key').AsString:='';
 Query1.FieldByName('S2Key').AsString:='';
 Query1.FieldByName('CLOUDKEY').AsString:=''; //20180917 Igor
 Query1.FieldByName('DROPBOXKEY').AsString:=''; //20190306 Igor

 Query1.FieldByName('ORDATE').AsString:='';
 Query1.FieldByName('HOW_ORD').AsString:='';

 Query1.FieldByName('PAID').AsFloat:=0;
 Query1.FieldByName('Prior_due').AsFloat:= Query1.FieldByName('Prior_due').AsFloat+ Query1.FieldByName('LastYr_due').AsFloat;
 Query1.FieldByName('LastYr_Due').AsFloat:= Query1.FieldByName('Bal_Due').AsFloat;
 Query1.FieldByName('Bal_due').AsFloat:=0;

 Query1.FieldByName('Discount').AsFloat:=0;
 Query1.FieldByName('Adjust').AsFloat:=0;

 If AllTrim(Query1.FieldByName('Notes').AsString)>'' then
  Query1.FieldByName('Notes').AsString:='2016-'+Query1.FieldByName('Notes').AsString;
 If AllTrim(Query1.FieldByName('Notes_bfr').AsString)>'' then
 Query1.FieldByName('Notes_bfr').AsString:='BFR2016-'+Query1.FieldByName('Notes_bfr').AsString;
 Query1.FieldByName('ChequeName').AsString:='';

 Query1.FieldByName('MSG_SENT').AsString:='';
 Query1.FieldByName('ACKN_SENT').AsString:='';
 Query1.FieldByName('KEYS_SENT').AsString:='';
 Query1.FieldByName('INV_SENT').AsString:='';
 Query1.FieldByName('CONV_FROM').AsString:='';
 Query1.FieldByName('DISCOUNT').AsFloat:=0;
 Query1.FieldByName('EFCOUNT').AsFloat:=0;
 Query1.FieldByName('ModifiedForExport').AsString:='';  //20191101

 {
 Query1.FieldByName('Sale1').AsFloat:=0;
 Query1.FieldByName('Sale2').AsFloat:=0;
 Query1.FieldByName('Sale3').AsFloat:=0;
 Query1.FieldByName('Sale4').AsFloat:=0;

 Query1.FieldByName('Hst1').AsFloat:=0;
 Query1.FieldByName('Hst2').AsFloat:=0;
 Query1.FieldByName('Hst3').AsFloat:=0;
 Query1.FieldByName('Hst4').AsFloat:=0;
 }
 Query1.Next;
 until Query1.Eof;
end;

procedure TClients.BuildOutLookBtnClick(Sender: TObject);
Var i:Integer;
    TempList:TstringList;
begin
 TempList:=TStringList.Create;
 Query1.First;
 Repeat
  TempList.Add(Chr(34)+Query1.FieldByName('Name').AsString+Chr(34)+','+Query1.FieldByName('EMail').AsString);
  ListBox1.Items.Add(Query1.FieldByName('Name').AsString);
  Query1.Next;
 until Query1.EOF;
 ShowCount;
 TempList.SaveToFile(AppDir+'/'+'Contacts.csv');
 ShowMessage('Done');
 TempList.Free;
end;

procedure TClients.CalcInvoiceBtnClick(Sender: TObject);
Var
TotalPrice,EFDiscount,Discount,PayPalCharge,Paid,AmountDue:Real;TaxRate:Real;Tax:Real;
cdCharge:Real;InvoiceFile,HowPaid:String;NumbOfCDs:Real;InvoiceFileName:String;
SomeAttachment,SomeRecipientEMail:String;
AmountBeforeHST,adjustmentAmount:Real;  //20111123
begin

 If AllTrim(Query1.FieldByName('PROVINCE').AsString)='' then
 begin
  ShowMessage('Enter Province first');
  Exit;
 end;

 If ValidateProductVersion=false then exit;

 With Query1 do
 begin
  If (ABS(FieldByName('BAL_DUE').AsFloat) >3)
  Or (ABS(FieldByName('LASTYR_DUE').AsFloat) >3)
  Or (ABS(FieldByName('PRIOR_DUE').AsFloat) >5)
  then
   ShowMessage('Watch amounts due of $'+ FormatFloat('###,###.##',
    FieldByName('BAL_DUE').AsFloat+FieldByName('LASTYR_DUE').AsFloat+FieldByName('PRIOR_DUE').AsFloat));
  HowPaid := FieldByName('HOW_ORD').AsString;
  TotalPrice:=CalcInvoiceTotalPrice(
               FieldByName('BUNDLE').AsString,
               FieldByName('T1').AsString,
               FieldByName('T2').AsString,
               FieldByName('T3').AsString,
               FieldByName('TF').AsString,   //20171025
               FieldByName('T4').AsString,
               FieldByName('FP').AsString,
               FieldByName('AR').AsString,
               FieldByName('TR').AsString,
               FieldByName('HOW_ORD').AsString,
               FieldByName('CD_NUM').AsFloat,
               FieldByName('S1').AsString,
               FieldByName('S2').AsString);

  // amount to be removed as PST exempt and not discountable for Efilers
   //numberOfIndividualCDs:=FieldByName('CD').AsString;

   NumbOfCds:=FieldByName('CD_NUM').AsFloat;
   cdCharge:=NumbOfCds * 20;
   TotalPrice:=TotalPrice + cdCharge;

  //efilers discount
  If UpperCase(Query1.FieldByName('EFDiscount').AsString) = 'Y' then
  begin
   EFDiscount := (TotalPrice - cdCharge) * 5/100;
   TotalPrice:=TotalPrice-EFDiscount;
  end
  Else If FieldByName('Discount').asFloat>0 then
  begin
    Discount :=(TotalPrice - cdCharge) * FieldByName('Discount').asFloat/100;
    TotalPrice:=TotalPrice-Discount;
  end;

  //add in Paypal Fees
  PayPalCharge := TotalPrice * 5/100;
  If HowPaid = 'PAYPAL' then TotalPrice:=TotalPrice+PayPalCharge;

  //taxes HST or GST
  //20151105
  TaxRate:=GetTaxRate(UpperCase(Query1.FieldByName('PROVINCE').AsString));
  Tax := (TotalPrice) * TaxRate/100;
  AmountBeforeHst:=TotalPrice;
  TotalPrice:=TotalPrice + Tax;

  Paid:=Query1.FieldByName('Paid').AsFloat;
  adjustmentAmount:=Query1.FieldByName('ADJUST').AsFloat;
 end;

 AmountDue := TotalPrice-Paid + adjustmentAmount;
 ShowMessage('Calculated      '+FormatFloat('###,###.00',TotalPrice)+Chr(13)
            +'Paid            '+FormatFloat('###,###.00',Paid)+Chr(13)+Chr(13)
            +'SALE     '+FormatFloat('###,###.00',AmountBeforeHst)+Chr(13)  //20141217
            +'GST/HST  '+FormatFloat('###,###.00',Tax)  //20141217
            +Chr(13)+Chr(13)
            +'Adjustment '+FormatFloat('###,###.00',adjustmentAmount)+Chr(13)+Chr(13)
            +'Amount due   '+FormatFloat('###,###.00',AmountDue)+Chr(13)
            );

 createHTMLinvoice(cdCharge,EFDiscount,Discount,PayPalCharge,Tax,TaxRate,TotalPrice,Paid,AmountDue,HowPaid,adjustmentAmount); //20111123
 if MessageDlg('Email the Invoice?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    SomeAttachment:=AppDir+'\' + 'INVOICES\' + Query1.FieldByName('NAME').AsString+'.htm';
    SomeRecipientEMail:=AllTrim(Query1.FieldByName('EMAIL').AsString); //20111122
    EMailInvoice('Invoice / Receipt','',SomeAttachment,SomeRecipientEMail);
    Query1.Edit;
    Query1.FieldByName('INV_SENT').AsString:= FormatDateTime('yyyy-mm-dd',Date);
  end;
end;

Function TClients.CalcInvoiceTotalPrice(BundleIndicator,T1version,T2version,T3version,TFVersion,T4version,FPversion,ARVersion,TRVersion,HowPaid:String;NumbCds:Real;S1Version:String;S2Version:String):Real;
Var
Total:Real;Bundled:Boolean;
i,j:integer;
begin

 For i := 1 to 14 do
 for j := 1 to 2 do
  itemInfo[i][j] := '';

 Total:=0;
 If ((T1Version='P') or (T1Version='M')
 Or (BundleIndicator='Y')
 Or (BundleIndicator='y'))
  then
        Bundled:=True
 else
        Bundled :=false;
 Total:=Total+GetPrice('T1',T1Version,Bundled,HowPaid);
 Total:=Total+GetPrice('T2',T2Version,Bundled,HowPaid);
 Total:=Total+GetPrice('T3',T3Version,Bundled,HowPaid);
 Total:=Total+GetPrice('TF',TFVersion,Bundled,HowPaid);  //20171025
 Total:=Total+GetPrice('T4',T4Version,Bundled,HowPaid);
 Total:=Total+GetPrice('FP',FPVersion,Bundled,HowPaid);
 Total:=Total+GetPrice('AR',ArVersion,Bundled,HowPaid);
 Total:=Total+GetPrice('TR',TRVersion,Bundled,HowPaid);
 Total:=Total+GetPrice('S1',S1Version,Bundled,HowPaid);
 Total:=Total+GetPrice('S2',S2Version,Bundled,HowPaid);

 Result:=Total;
end;


Function TClients.GetPrice(ProductId:String;Version:String;Bundled:Boolean;HowPaid:String):Real; // 20180904 Igor
Var iVersion:Integer;
begin
 Result:=0;
 ProductId:=UpperCase(ProductId);
 Version:=UpperCase(Version);

 {
 If UpperCase(HowPaid) = 'INTERN' then
 begin
  result:=GetInternetPrice(ProductId,Version,Bundled,HowPaid);
  Exit;
 end;
 }
 If (ProductId='T1') and (version>'') then
 begin
  If Bundled=False then
  begin
   If Version='L' then
   begin
    result:=99;
    itemInfo[1][1] := 'T1-2020 - Limited-No Efile';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='E' then
   begin
    result:=169;
    itemInfo[1][1] := 'T1-2020 - Limited with Efile';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='S' then
   begin
    result:=249;
    itemInfo[1][1] := 'T1-2020 - Standard';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='P' then
   begin
    result:=379;
    itemInfo[1][1] := 'T1-2020 - Power';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='M' then
   begin
    result:=499;
    itemInfo[1][1] := 'T1-2020 - Multi-Office';      //20141116
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
  end;
 end  //single packages
  else  //bundled
   begin
    If Version='P' then
     begin
      result:=379;
      itemInfo[1][1] := 'T1-2020 - Power (Bundled)';
      itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
     end
     else If Version='M' then
     begin
      result:=499;
      itemInfo[1][1] := 'T1-2020 - Multi-Office (Bundled)';  //20141116
      itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
    end;
   end;
 end;

 //20171025  several changes
 If (ProductId='T2') and (version>'') then
 begin
  If (Bundled=False) then
  Begin
   If (Version>='1') and (Version <='6') then
   begin
    iVersion:=StrToInt(Version);
    result:=75 * iVersion;   //20171025
    itemInfo[2][1] := 'T2-2021 - Limited to '+Version +' returns';
    itemInfo[2][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='S' then
   begin
    result:=449;
    itemInfo[2][1] := 'T2-2021 - Standard';   //unlimited with no Efile
    itemInfo[2][2] := '$' + FormatFloat('###,###.00',result);
   end

   else If Version='P' then
   begin
    result:=499;    //20131030
    itemInfo[2][1] := 'T2-2021 - Power';
    itemInfo[2][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='M' then
   begin
    result:=499;  //20131030
    itemInfo[2][1] := 'T2-2021 - Multi-Office';
    itemInfo[2][2] := '$' + FormatFloat('###,###.00',result);
   end;
  end //bundled = false

  else //bundled
  If (Version>='1') and (Version <='6')     //20171218
  then
  begin
   iVersion:=StrToInt(Version);
   result:=75 * iVersion;   //20171025
   itemInfo[2][1] := 'T2-2021 - Limited to '+Version +' returns';
   itemInfo[2][2] := '$' + FormatFloat('###,###.00',result);
  end

   else If Version='S' then
   begin
    result:=349;
    itemInfo[2][1] := 'T2-2021 - Standard (Bundled)';
    itemInfo[2][2] := '$' + FormatFloat('###,###.00',result);
   end

   else If Version='P' then
   begin
    result:=399;  //20131030
    itemInfo[2][1] := 'T2-2021 - Power (Bundled)';
    itemInfo[2][2] := '$' + FormatFloat('###,###.00',result);
   end

   else If Version='M' then
   begin
    result:=399; //20131030
    itemInfo[2][1] := 'T2-2021 - Multi-Office (Bundled)';
    itemInfo[2][2] := '$' + FormatFloat('###,###.00',result);
  end;
 end;

 If (ProductId='T3') and (version>'') then
 begin
  If Bundled=False then  //no bundle
  begin
   If Version='S' then
    begin
     result:=135;   //20171115
     itemInfo[3][1] := 'T3-2020 - Standard';
     itemInfo[3][2] := '$' + FormatFloat('###,###.00',result);
    end
   else If Version='P' then  //20111116
   begin
     result:=135;   //20171115
     itemInfo[3][1] := 'T3-2020 - Power';
     itemInfo[3][2] := '$' + FormatFloat('###,###.00',result);
   end;
  end
  else  //bundle
  begin
    If Version='S' then
    begin
     result:=109;
     itemInfo[3][1] := 'T3-2020 - Standard (Bundled)';
     itemInfo[3][2] := '$' + FormatFloat('###,###.00',result);
    end;
    If Version='P' then  //20111116
    begin
      result:=109;    //20171113
      itemInfo[3][1] := 'T3-2020 - Power (Bundled)';
      itemInfo[3][2] := '$' + FormatFloat('###,###.00',result);
    end;
  end; //else bundle
 end; //If ProductId='T3'

 If (ProductId='T4') and (version>'') then
 begin
  If Bundled=False then
  begin
   If Version='S' then
    begin
     result:=99;
     itemInfo[4][1] := 'T4/T4A/T5-2020 - Standard - No Efile';
     itemInfo[4][2] := '$' + FormatFloat('###,###.00',result);
    end
   else If Version='P' then
    begin
     result:=139;
     itemInfo[4][1] := 'T4/T4A/T5-2020 - Power with Efile';
     itemInfo[4][2] := '$' + FormatFloat('###,###.00',result);
    end
  end //t4 single
  else
  begin
     result:=99;   //bundled is $99
     itemInfo[4][1] := 'T4/T4A/T5-2020 - Power (Bundled)';
     itemInfo[4][2] := '$' + FormatFloat('###,###.00',result);
  end;
 end;

 If (ProductId='FP') and (version>'') then
 begin
  If (Bundled=False) or (Version='L') then
  begin
   If Version='L' then
   begin
     result:=99;
     itemInfo[5][1] := 'FP-2021 - Limited';
     itemInfo[5][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='S' then
   begin
     result:=199;
     itemInfo[5][1] := 'FP-2021 - Power';
     itemInfo[5][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='P' then
   begin
     result:=399;
     itemInfo[5][1] := 'FP-2021 - Power';
     itemInfo[5][2] := '$' + FormatFloat('###,###.00',result);
   end;
  end //fp single
  else
  begin
  If Version='S' then
   begin
     result:=149;
     itemInfo[5][1] := 'FP-2018 - Standard (Bundled)';
     itemInfo[5][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='P' then
   begin
     result:=299;
     itemInfo[5][1] := 'FP-2018 - Power (Bundled)';
     itemInfo[5][2] := '$' + FormatFloat('###,###.00',result);
   end;
  end; //end FP bundle
 end;

 If (ProductId='AR') and (version>'') then
 begin
  If Bundled=False then
  begin
     result:=99;
     itemInfo[6][1] := 'Archives-2019';
     itemInfo[6][2] := '$' + FormatFloat('###,###.00',result);
  end
  else
  begin
     result:=79;
     itemInfo[6][1] := 'Archives-2019 (Bundled)';
     itemInfo[6][2] := '$' + FormatFloat('###,###.00',result);
  end;
end;

 If (ProductId='TR') and (version>'') then
 begin
  If Bundled=False then
  begin
   If Version='S' then
    begin
     result:=0;
     itemInfo[7][1] := 'TR Engine';
     itemInfo[7][2] := '$' + FormatFloat('###,###.00',result);
    end;
  end
  else
  begin
   If Version='S' then
   begin
     result:=0;
     itemInfo[7][1] := 'TR Engine (Bundled)';
     itemInfo[7][2] := '$' + FormatFloat('###,###.00',result);
   end;
  end;
 end;

 If (UpperCase(ProductId)='S1') and (Version>'') then
 begin
  If Bundled=False then
  begin
     result:=99;   //20141116
     itemInfo[8][1] := 'vtScan-T1';
     itemInfo[8][2] := '$' + FormatFloat('###,###.00',result);
  end
  Else
  Begin
    result:=89;   //20141116
    itemInfo[8][1] := 'vtScan-T1 Bundled';
    itemInfo[8][2] := '$' + FormatFloat('###,###.00',result);
  end;
 end;

 If (UpperCase(ProductId)='S2') and (Version>'') then
  begin
   If Bundled=False then
   begin
      result:=99;   //20141116
      itemInfo[9][1] := 'vtScan-T2';
      itemInfo[9][2] := '$' + FormatFloat('###,###.00',result);
  end
  Else
  begin
    result:=89;   //20141116
    itemInfo[9][1] := 'vtScan-T2';
    itemInfo[9][2] := '$' + FormatFloat('###,###.00',result);
  end;
 end;


 If (ProductId='TF') and (version>'') then
 begin
  If Bundled=False then  //no bundle
  begin
    If Version='P' then
    Begin
     result:=149;
     itemInfo[10][1] := 'TF-2020 - Power';
     itemInfo[10][2] := '$' + FormatFloat('###,###.00',result);
    end
  end
  else  //bundle
  begin
   If version='P' then
   Begin
      result:=119;
      itemInfo[10][1] := 'TF-2020 - Power (Bundled)';
      itemInfo[10][2] := '$' + FormatFloat('###,###.00',result);
   end;
  end; //else bundle
 end; //If ProductId='TF'

end;

(*
Function TClients.GetInternetPrice(ProductId:String;Version:String;Bundled:Boolean;HowPaid:String):Real;
begin
 Result:=0;
 ProductId:=UpperCase(ProductId);
 Version:=UpperCase(Version);

 If ProductId='T1' then
 begin
   If Version='L' then
   begin
    result:=104;
    itemInfo[1][1] := 'T1 - Limited';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='S' then
   begin
    result:=187.95;
    itemInfo[1][1] := 'T1 - Standard';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='P' then
   begin
    result:=314;
    itemInfo[1][1] := 'T1 - Power';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='M'then
   begin
    result:=524;
    itemInfo[1][1] := 'T1 - Multi-Office';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end;
 end;

 If ProductId='T2' then
 begin
   If Version='L' then
   begin
    result:=104;
    itemInfo[1][1] := 'T2 - Limited';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='F' then
   begin
    result:=210;
    itemInfo[1][1] := 'T2 - Limited with Efile';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='S' then
   begin
    result:=314;
    itemInfo[1][1] := 'T2 - Standard';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='P' then
   begin
    result:=367;
    itemInfo[1][1] := 'T2 - Power';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='M' then
   begin
    result:=367;
    itemInfo[1][1] := 'T2';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end;
 end;

 If ProductId='T3' then
 begin
   If Version='S' then
   begin
    result:=104;
    itemInfo[1][1] := 'T3 plus Tax Forms';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end;
 end;

 If ProductId='T4' then
 begin
   If Version='S' then
   begin
    result:=104;
    itemInfo[1][1] := 'T4 - Standard';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='P' then
   begin
    result:=146;
    itemInfo[1][1] := 'T4 - Power';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end;
 end;

 If ProductId='FP' then
 begin
   If Version='L' then
   begin
    result:=104;
    itemInfo[1][1] := 'FP - Limited';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='S' then
   begin
    result:=210;
    itemInfo[1][1] := 'FP - Standard';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end
   else If Version='P' then
   begin
    result:=419;
    itemInfo[1][1] := 'FP - Power';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end;
 end;

 If ProductId='AR' then
 begin
   If ((Version='M') or (version='A')) then
   begin
    result:=73;
    itemInfo[1][1] := 'Archives';
    itemInfo[1][2] := '$' + FormatFloat('###,###.00',result);
   end;
 end;
end;
*)


procedure TClients.createHTMLinvoice(cdCharge,EFDiscount,Discount,PayPalCharge,Tax,TaxRate,TotalPrice,Paid,AmountDue:Real;HowPaid:String;adjustmentAmount:real);
var
 htmlSource:TStringList;
 source,flName:string;
 customerName,customerAddress,customerCityProv,customerPostal,invoiceNum,itemNum,itemDescription,itemUnitPrice,CdDescription,cdCharges,EFdiscountDescr,EFdiscountAmount,PayPalChargesDescr,PayPalChargesAmount,invoiceTotalPrice,invoiceGST,GSTRate,invoicePST,invoiceTotalAmount,invoiceAmountPaid,invoiceAmountDue:string;
 adjustmentDescr, shownAdjustmentAmount:string;

 i,j,k,s,startPos,itemNumTemp:integer;
 Bundled:Boolean;
 itemAmount:Real;
begin
If DirectoryExists(AppDir+'\Invoices') = false then
 MkDir(AppDir+'\Invoices');

invoiceNum := midstr(DateToStr(Date),4,2) + leftstr(DateToStr(Date),2) + midstr(DateToStr(Date),7,10) + '1';
invoiceNum := StringReplace(invoiceNum, '/', '', [rfReplaceAll, rfIgnoreCase]);


if amountDue > 0 then invoiceNum := 'Invoice# ' + invoiceNum
else invoiceNum := 'Receipt# ' + invoiceNum;

customerName      := Query1.FieldByName('NAME').AsString;
customerAddress   := Query1.FieldByName('STREET').AsString;
customerCityProv  := Query1.FieldByName('CITY').AsString + ', ' + Query1.FieldByName('PROVINCE').AsString;
customerPostal    := Query1.FieldByName('POSTAL').AsString;

htmlSource:=TStringList.Create;

htmlSource.LoadFromFile(AppDir + '\InvoiceTemplate.htm');

For i := 0 to htmlSource.Count-1 do
begin

 startPos := pos('!invoiceNum!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + ' ' + invoiceNum + midstr(htmlSource[i],startPos+12,Length(htmlSource[i]));
 end;

 startPos := pos('!Date!', htmlSource[i]);
 if  startPos > 0 then
 begin
  //htmlSource[i] := leftstr(htmlSource[i],startPos-1) + DateToStr(Date) + midstr(htmlSource[i],startPos+6,Length(htmlSource[i]));
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) +
                leftstr(Query1.FieldByName('ORDATE').AsString,4) + '/' + midstr(Query1.FieldByName('ORDATE').AsString,5,2) + '/' + midstr(Query1.FieldByName('ORDATE').AsString,7,2) +
                   midstr(htmlSource[i],startPos+6,Length(htmlSource[i]));
 end;

 startPos := pos('!customerName!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + customerName + midstr(htmlSource[i],startPos+14,Length(htmlSource[i]));
 end;

 startPos := pos('!customerAddress!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + customerAddress + midstr(htmlSource[i],startPos+17,Length(htmlSource[i]));
 end;

 startPos := pos('!customerProv!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + customerCityProv + midstr(htmlSource[i],startPos+14,Length(htmlSource[i]));
 end;

 startPos := pos('!customerPostal!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + customerPostal + midstr(htmlSource[i],startPos+16,Length(htmlSource[i]));
 end;


 itemNumTemp := 0;
 For j := 1 to 14 do
 begin

 if j > 9 then s := 1 else s := 0;

 if itemInfo[j][1] = '' then
 begin
  itemNum           := '';
  itemNumTemp       := itemNumTemp + 1;   //to get the correct item number
  itemUnitPrice     := '';
 end
 else
 begin
  itemNum           := inttostr(j - itemNumTemp);
  itemUnitPrice     := '---';
 end;

 startPos := pos('!itemNum' + inttostr(j) + '!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + itemNum + midstr(htmlSource[i],startPos+10 +s,Length(htmlSource[i]));
 end;
 startPos := pos('!itemDescription' + inttostr(j) + '!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + itemInfo[j][1] + midstr(htmlSource[i],startPos+18 + s,Length(htmlSource[i]));
 end;
 startPos := pos('!itemUnitPrice' + inttostr(j) + '!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + itemUnitPrice + midstr(htmlSource[i],startPos+16 + s,Length(htmlSource[i]));
 end;
 startPos := pos('!itemAmount' + inttostr(j) + '!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + itemInfo[j][2] + midstr(htmlSource[i],startPos+13 + s,Length(htmlSource[i]));
 end;
end; //end for

 if cdCharge = 0 then
 begin
  CdDescription := '';
  cdCharges     := '';
 end
 else
 begin
  CdDescription := 'CD charges';
  cdCharges     := '$' + FormatFloat('###,###.00',cdCharge);
 end;

 startPos := pos('!CDitemNum!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + itemNum + midstr(htmlSource[i],startPos+11,Length(htmlSource[i]));
 end;
 startPos := pos('!CDDescription!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + CdDescription + midstr(htmlSource[i],startPos+15,Length(htmlSource[i]));
 end;
 startPos := pos('!cdCharges!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + cdCharges + midstr(htmlSource[i],startPos+11,Length(htmlSource[i]));
 end;
 startPos := pos('!CDUnitPrice!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + itemUnitPrice + midstr(htmlSource[i],startPos+13,Length(htmlSource[i]));
 end;

 if EFdiscount > 0 then
 begin
  EFdiscountDescr  := 'E-Filers Discount';
  EFdiscountAmount := '- $' + FormatFloat('###,###.00',EFdiscount);
 end
 else if discount > 0 then
 begin
  EFdiscountDescr  := 'Discount';
  EFdiscountAmount := '- $' + FormatFloat('###,###.00',discount);
 end
 else
 begin
  EFdiscountDescr  := '';
  EFdiscountAmount := '';
 end;

 startPos := pos('!EFdiscount!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) +   EFdiscountDescr + midstr(htmlSource[i],startPos+12,Length(htmlSource[i]));
 end;
 startPos := pos('!EFdiscountAmount!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + EFdiscountAmount + midstr(htmlSource[i],startPos+18,Length(htmlSource[i]));
 end;

 if HowPaid = 'PAYPAL' then
 begin
  PayPalChargesDescr  := 'PayPal Charges (5%)';
  PayPalChargesAmount := '$' + FormatFloat('###,###.00',PayPalCharge);
 end
 else
 begin
  PayPalChargesDescr  := '';
  PayPalChargesAmount := '';
 end;

 startPos := pos('!PayPalAmountDescr!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) +   PayPalChargesDescr + midstr(htmlSource[i],startPos+19,Length(htmlSource[i]));
 end;
 startPos := pos('!PayPalAmount!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + PayPalChargesAmount + midstr(htmlSource[i],startPos+21,Length(htmlSource[i]));
 end;

 startPos := pos('!totalPrice!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + '$' + FormatFloat('###,###.00',(TotalPrice-(Tax))) + midstr(htmlSource[i],startPos+12,Length(htmlSource[i]));
 end;

 startPos := pos('!TAXDESCR!', htmlSource[i]);
 if  startPos > 0 then
 begin
  if TaxRate = 5 then
    htmlSource[i] := leftstr(htmlSource[i],startPos-1) + 'GST (' + floattostr(TaxRate) + '%)' + midstr(htmlSource[i],startPos+10,Length(htmlSource[i]))
  else
    htmlSource[i] := leftstr(htmlSource[i],startPos-1) + 'HST ('+ floattostr(TaxRate) +'%)' + midstr(htmlSource[i],startPos+10,Length(htmlSource[i]))
 end;

 startPos := pos('!TAX!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) +  '$' +FormatFloat('###,###.00',Tax) + midstr(htmlSource[i],startPos+5,Length(htmlSource[i]));
 end;

 startPos := pos('!totalAmount!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) +  '$' +FormatFloat('###,###.00',TotalPrice) + midstr(htmlSource[i],startPos+13,Length(htmlSource[i]));
 end;



 if adjustmentAmount = 0 then
 begin
  adjustmentDescr       := '';
  shownAdjustmentAmount := '';
 end
 else
 begin
  adjustmentDescr       := 'Adjustment';
  shownAdjustmentAmount := '$' + FormatFloat('###,###.00',adjustmentAmount);
 end;

 startPos := pos('!adjustmentDescr!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) + adjustmentDescr + midstr(htmlSource[i],startPos+17,Length(htmlSource[i]));
 end;
 startPos := pos('!adjustmentAmount!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) +  shownAdjustmentAmount + midstr(htmlSource[i],startPos+18,Length(htmlSource[i]));
 end;




 startPos := pos('!amountPaid!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) +  '$' +FormatFloat('###,###.00',Paid) + midstr(htmlSource[i],startPos+12,Length(htmlSource[i]));
 end;

 startPos := pos('!amountDueOrCredit!', htmlSource[i]);
 if  startPos > 0 then
 begin
   if AmountDue >= 0 then
   begin
     htmlSource[i] := leftstr(htmlSource[i],startPos-1) +  'Amount Due' + midstr(htmlSource[i],startPos+19,Length(htmlSource[i]));
   end
   else
   begin
    htmlSource[i] := leftstr(htmlSource[i],startPos-1) +  'Credit' + midstr(htmlSource[i],startPos+19,Length(htmlSource[i]));
   end;
 end;

 startPos := pos('!amountDue!', htmlSource[i]);
 if  startPos > 0 then
 begin
  htmlSource[i] := leftstr(htmlSource[i],startPos-1) +  '$' +(FormatFloat('###,###.00',abs(AmountDue))) + midstr(htmlSource[i],startPos+11,Length(htmlSource[i]));
 end;

 startPos := pos('!CreditNote!', htmlSource[i]);
 if  startPos > 0 then
 begin
  if AmountDue = 0 then
  begin
    htmlSource[i] := leftstr(htmlSource[i],startPos-1) +  '' + midstr(htmlSource[i],startPos+12,Length(htmlSource[i]));
  end
  else if AmountDue > 0 then
  begin
    htmlSource[i] := leftstr(htmlSource[i],startPos-1) +  'Make cheques payable to Microsophic Inc.' + midstr(htmlSource[i],startPos+12,Length(htmlSource[i]));
  end
  else
  begin
    htmlSource[i] := leftstr(htmlSource[i],startPos-1) + 'An overpayment remains as a credit balance on your account. Please apply it to your next VisualTax purchase.' + midstr(htmlSource[i],startPos+12,Length(htmlSource[i]));
  end;
 end;
 end;
 flName := AppDir+'\' + 'INVOICES\' + customerName + '.htm';
 If FileExists(flName) then
 begin
   if MessageDlg('Replace existing invoice?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
       htmlSource.SaveToFile(flName)
   Else
   begin
    flName := AppDir+'\' + 'INVOICES\' + customerName+'-NewInvoice' + '.htm';  //20111122
    //AppDir+'\' + 'INVOICES\' + 'test' + '.htm';
    htmlSource.SaveToFile(flName);
  end;
 end
 else //new invoice
  htmlSource.SaveToFile(flName);

 htmlSource.Free;
// ShellExecute(Self.Handle, nil, PChar('' + flName), nil, nil, SW_SHOWMAXIMIZED);
end;






procedure TClients.AcknowledgeBtnClick(Sender: TObject);
var
  nItem, nBcc: Integer;
  Res: Word;
begin
 MsgOptionBox.ItemIndex :=-1;

 If MsgOptionBox.ItemIndex =-1 then
 begin
   If UpperCase(AllTrim(Query1.FieldByName('CD').AsString)) = 'Y' then
    MsgOptionBox.ItemIndex :=1
   else
    MsgOptionBox.ItemIndex :=0;
 end;


  If MsgOptionBox.ItemIndex<0 then
  begin
   ShowMessage('You must select a Message Option');
   exit;
  end;

  nItem:=0;

  If EFrom.Text='' then
  begin
   ShowMessage('Enter From mail address');
   Efrom.setFocus;
   exit;
  end;
  If EServer.Text='' then
  begin
   ShowMessage('Enter Mail Server name');
   EServer.SetFocus;
   exit;
  end;

  If ListAddr.items.Count =0 then
  begin
  ShowMessage('The Recepient list is empty');
  exit;
  end;

  // connect
  Mail.Host := eServer.Text;
  Mail.UserID := eFrom.Text;
  If not Mail.Connected then Mail.Connect;

  // set the fixed part of the header
  Mail.PostMessage.FromAddress := eFrom.Text;
  Mail.PostMessage.ToAddress.Clear;
  Mail.PostMessage.ToAddress.Add (ListAddr.items[nItem]);
  Mail.PostMessage.Subject := eSubject.Text;
  Mail.PostMessage.Body.SetText (
    reMessageText.Lines.GetText);

  // send to list, in groups
  while nItem < ListAddr.Items.Count do
  begin
    ListAddr.ItemIndex := nItem;
    Application.ProcessMessages;
    // fill the bcc list
    Mail.PostMessage.ToBlindCarbonCopy.Clear;
    nBcc := 1;
    while (nBcc < MaxBccGroup) and (nBcc + nItem < ListAddr.Items.Count) do
    begin
      {NO BBC Here: Mail.PostMessage.ToBlindCarbonCopy.Add (ListAddr.Items [nItem + nBcc]);}
      Inc (nBcc);
    end;
    // send the message
    Mail.SendMail;
    Inc (nItem, nBcc);
  end;

  // we're done
  Mail.Disconnect;
  Query1.Edit;
  Query1.FieldByName('ACKN_sent').AsString:='Y';

  ShowMessage('done');
  ClearBtnClick(Sender);
end;


procedure TClients.EfileLogsBtnClick(Sender: TObject);
Var i:Integer;LogsDir:String; TempList:TStringList;ToF:TextFile;Rslt:Boolean;
    ThisFileAge:Integer; Dt:String;
    FromDate,ToDate:String; yyyy,mm,dd:String;
    FlName:String;
begin

 Screen.Cursor:=CrHourGlass;
 TempList:=TStringList.Create;
 //T1LogsDir:='C:\MCLNT\EfileLogs-2016\';
 If FileExists(T1LogsDir+'AllLogs.txt') then
 begin
  Rslt:=sysUtils.DeleteFile(T1LogsDir+'AllLogs.txt');
  If Rslt=False then ShowMessage('AllLogs.txt could not be deleted');
 end;

 If FileExists(T1LogsDir+'Offenders.txt') then  sysUtils.DeleteFile(T1LogsDir+'Offenders.txt');
 //initialize file with blank record
 AssignFile(ToF,T1LogsDir+'AllLogs.txt');
 Try
 Rewrite(ToF);
 Except
 End;
 //Writeln(ToF, 'ZZZEND');
 CloseFile(ToF);

 TempList:=GetFileList(T1LogsDir, '*.*');
 //merge files

 FromDate:= InputBox('Input Box', 'Enter starting date', '2016-02-01');
 ToDate:= InputBox('Input Box', 'Enter starting date', '2016-12-31');
 For i:=0 to TempList.count-1 do
 begin
  If Numeric(LeftStr(ExtractFileName(TempList[i]),4))
  then
  begin
   FlName:=ExtractFileName(TempList[i]);
   FlName:=LeftStr(FlName,Length(FlName)-4);  //getrid of .txt
   yyyy:=LeftStr(Flname,4);
   mm:=PaddZero(AllTrim(MidStr(Flname,6,2)),2);
   dd:=PaddZero(AllTrim(MidStr(Flname,8,3)),2);
   Dt:=yyyy+'-'+mm+'-'+DD;
   If (Dt>=FromDate) and (Dt<=ToDate) then
       AppendAFile(TempList[i],T1LogsDir+'AllLogs.txt') ;  //20150223
  end;
 end;
{
 FromDate:= InputBox('Input Box', 'Enter starting date', '2013-01-01');
 For i:=0 to TempList.count-1 do
 begin
  If Numeric(LeftStr(ExtractFileName(TempList[i]),4))
  then
  begin
   ThisFileAge:=FileAge(TempList[i]);
   Dt:=FormatDateTime('yyyy-mm-dd',FileDateToDateTime(ThisFileAge));
   If Dt>=FromDate then AppendAFile(TempList[i],LogsDir+'AllLogs.txt') ;
  end;
 end;
 }

 AnalyseEfileLog(T1LogsDir+'AllLogs.txt');
 Screen.Cursor:=CrDefault;
end;


procedure TClients.SENDKEYSTOALL1Click(Sender: TObject);
Var T1Key,T2Key,T3Key,TFKey,T4Key,FPKey,TRKey,CloudKey,DropBoxKey:String; //20180917 Igor //20190306 Igor
  SomeRecipientEMail,SomeSenderEmail, SomeSubject, SomeAttachment,SomeText:String;
begin

 ShowMessage('Not available');
 EXIT;

 if MessageDlg('Are you sure send keys to all?',
     mtInformation, [mbYes, mbNo], 0) = mrYes then
   //ok
 else
 Exit;

 Query1.First;
 Repeat
  SomeRecipientEmail:=Query1.FieldByName('EMail').AsString;
  SomeSenderEmail:='';
  SomeSubject:='2020/2021 VisualTax program keys';
  SomeAttachment:='';

  // 20180904 Igor >>>
  T1Key:='T1-2020:  '+Query1.FieldByName('T1Key').AsString;
  T2Key:='T2-2021:  '+Query1.FieldByName('T2Key').AsString;
  TFKey:='T3-2020:  '+Query1.FieldByName('TFKey').AsString;
  TFKey:='TF-2020:  '+Query1.FieldByName('TFKey').AsString;
  T4Key:='T4-2018:  '+Query1.FieldByName('T4Key').AsString;
  TRKey:='TR-2020:  '+Query1.FieldByName('TRKey').AsString;
  FPKey:='FP-2021:  '+Query1.FieldByName('FPKey').AsString;
  CloudKey:='Cloud:  '+Query1.FieldByName('CLOUDKEY').AsString; //20180917 Igor
  DropBoxKey:='DropBox:  '+Query1.FieldByName('DROPBOXKEY').AsString; //20190306 Igor
  // 20180904 Igor <<<

  SomeText:='Your VisualTax program keys are listed below:'+Chr(10);
  If T1Key>'' then SomeText:=SomeText+Chr(10)+T1key;
  If T2Key>'' then SomeText:=SomeText+Chr(10)+T2key;
  If T3Key>'' then SomeText:=SomeText+Chr(10)+T3key;
  If TfKey>'' then SomeText:=SomeText+Chr(10)+TFkey;
  If T4Key>'' then SomeText:=SomeText+Chr(10)+T4key;
  If TrKey>'' then SomeText:=SomeText+Chr(10)+TRkey;
  If FPKey>'' then SomeText:=SomeText+Chr(10)+FPkey;
  If CloudKey>'' then SomeText:=SomeText+Chr(10)+Cloudkey; //20180917 Igor
  If DropBoxKey>'' then SomeText:=SomeText+Chr(10)+DropBoxkey; //20190306 Igor

  SomeText:=SomeText+Chr(10)+Chr(10)+'Yours truly,'+Chr(10)+'VisualTax';

  SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEMail);
  Query1.Next;
 until Query1.EOF;
end;

procedure TClients.GENTKEYFORALL1Click(Sender: TObject);
begin
 if MessageDlg('Are you sure to GEN keys for all?',
     mtInformation, [mbYes, mbNo], 0) = mrYes then
   //ok
 else
  Exit;

  EXIT;
  
 Query1.First;
 Repeat
   LoadProducts;

   delay(100);

   If AllTrim(Query1.FieldByName('TRKey').AsString)>'' then
     //ShowMessage('TR Key already in Data Base')
   else
     StoreTRKey;
   delay(100);

   If AllTrim(Query1.FieldByName('T1Key').AsString)>'' then
    //ShowMessage('T1 Key already in Data Base')
   else
    StoreT1Key;
   delay(100);

   If AllTrim(Query1.FieldByName('T2').AsString)>'' then
   begin
    If AllTrim(Query1.FieldByName('T2Key').AsString)>'' then
     //ShowMessage('T2 Key already in Data Base')
   else
   begin
    StoreT2Key;
    delay(100);
   end;

   If AllTrim(Query1.FieldByName('T4Key').AsString)>'' then
    //ShowMessage('T4 Key already in Data Base')
   else
    StoreT4Key;
    delay(100);

   If AllTrim(Query1.FieldByName('T3Key').AsString)>'' then
    //ShowMessage('TF Key already in Data Base')
   else
    StoreT3Key;
    delay(100);


   If AllTrim(Query1.FieldByName('TFKey').AsString)>'' then
    //ShowMessage('TF Key already in Data Base')
   else
    StoreTFKey;
    delay(100);

   //20180917 Igor >>>
   If AllTrim(Query1.FieldByName('CLOUDKEY').AsString)>'' then
    //ShowMessage('Cloud Key already in Data Base')
   else
    StoreCloudKey;
    delay(100);
   //20180917 Igor <<<

   //20190306 Igor >>>
   If AllTrim(Query1.FieldByName('DROPBOXKEY').AsString)>'' then
    //ShowMessage('Cloud Key already in Data Base')
   else
    StoreDropBoxKey;
    delay(100);
   //20190306 Igor <<<

 end;

 Query1.Next;
 until Query1.EOF;
end;

function TClients.SendMAPIMail(const Subject, Body, FileNames,SenderName, SenderEMail,RecipientName, RecipientEMail: Ansistring): Integer; //20200615 Igor
// scalabium.com/faq/dct0115.htm
var
  Message: TMapiMessage;
  lpSender, lpRecipient: TMapiRecipDesc;
  FileAttachments: Array[0..100] of TMapiFileDesc;
  AttachmentList: TStringList;
  I: integer;

  SM: TFNMapiSendMail;
  MAPIModule: HModule;
begin
  FillChar(Message, SizeOf(Message), 0);
  AttachmentList := TStringList.Create;
  try
    with Message do
    begin
      if (Subject <> '') then
        lpszSubject := PChar(''+Subject);

      if (Body <> '') then
        lpszNoteText := PChar(''+Body);

      if (SenderEmail <> '') then
      begin
        lpSender.ulRecipClass := MAPI_ORIG;
        if (SenderName = '') then
          lpSender.lpszName := PChar(''+SenderEMail)
        else
          lpSender.lpszName := PChar(''+SenderName);
        lpSender.lpszAddress := PChar(''+SenderEmail);
        lpSender.ulReserved := 0;
        lpSender.ulEIDSize := 0;
        lpSender.lpEntryID := nil;
        lpOriginator := @lpSender;
      end;

      if (RecipientEmail <> '') then
      begin
        lpRecipient.ulRecipClass := MAPI_TO;
        if (RecipientName = '') then
          lpRecipient.lpszName := PChar(''+RecipientEMail)
        else
          lpRecipient.lpszName := PChar(''+RecipientName);
        lpRecipient.lpszAddress := PChar(''+RecipientEmail);
        lpRecipient.ulReserved := 0;
        lpRecipient.ulEIDSize := 0;
        lpRecipient.lpEntryID := nil;
        nRecipCount := 1;
        lpRecips := @lpRecipient;
      end
      else
        lpRecips := nil;

      if (FileNames = '') then
      begin
        nFileCount := 0;
        lpFiles := nil;
      end
      else
      begin
        AttachmentList.Text := FileNames;
        if AttachmentList.Count > 100 then
        begin
          ShowMessage('Only 100 files allowed for attach');
          Exit;
        end;
        nFileCount := AttachmentList.Count;
        lpFiles := @FileAttachments;
        FillChar(FileAttachments, SizeOf(FileAttachments), 0);

        for I := 0 to AttachmentList.Count - 1 do
        begin
          FileAttachments[I].nPosition := Cardinal($FFFFFFFF);
          FileAttachments[I].lpszPathName := PChar(AttachmentList.Strings[I]);
        end;
      end;
    end;

    MAPIModule := LoadLibrary(PChar(MAPIDLL));
    if MAPIModule = 0 then
      Result := -1
    else
      try
        @SM := GetProcAddress(MAPIModule, 'MAPISendMail');
        if @SM <> nil then
        begin
          Result := SM(0, Application.Handle, Message, MAPI_DIALOG or MAPI_LOGON_UI, 0);
          //Result := MapiSendMail(0, Application.Handle, Message, MAPI_DIALOG or MAPI_LOGON_UI, 0);
        end
        else
          Result := 1;
      finally
        FreeLibrary(MAPIModule);
      end;

    if (Result <> 0) and (Result <> 1) then
      MessageDlg('Error sending mail (' + IntToStr(Result) + ').', mtError,[mbOK], 0);
  finally
    AttachmentList.Free;
  end;
end;

procedure TClients.LastYr1Click(Sender: TObject);
Var  Tbl,Table1 : TTable; InpKey:String;
LastyrFolder:String;
begin
  LastYrFolder:='C:\MCLNT'+IntToStr(StrToInt(AppYear)-2000-1); //'C:\MCLNT13';  //20150226
//this year's DBF
  Tbl := TTable.Create(Application);
  Tbl.TableName := 'CLIENTS.DBF';
  Tbl.IndexName := 'NAME';
  If Tbl.Active then Tbl.Close;
  Tbl.Open;
  //last years
  Table1 := TTable.Create(Application);
  Table1.DataBaseName :=LastYrFolder; // 'C:\MCLNT07'; //+IntToStr(StrToInt(RightStr(AppYear,1))-1);
  Table1.TableName := 'Clients.DBF';
  Table1.IndexName := 'NAME';
  If Table1.Active then Table1.Close;
  Table1.Open;

  InpKey:=AllTrim(Query1.FieldByName('NAME').AsString); //on screen selection
     //Tbl.FieldByName('Name').AsString;  //this year
  if Table1.FindKey([InpKey]) then
   begin
       ShowMessage(PaddR(RTrim(Table1.FieldByName('Name').AsString),40)
          +PaddR(Table1.FieldByName('T1').AsString,5)
          +PaddR(Table1.FieldByName('T2').AsString,5)
          +PaddR(Table1.FieldByName('T3').AsString,5)
          +PaddR(Table1.FieldByName('T4').AsString,5)
          +PaddR(Table1.FieldByName('TF').AsString,5)   //20171025
          +PaddR(Table1.FieldByName('FP').AsString,5));
   end
  Else
   ShowMessage('Name not found in '+LastYrFolder); //'C:\MCLNT0'+RightStr(AppYear,1));
  Tbl.Close;
  Table1.Close;
end;

procedure TClients.BatchKeySENDClick(Sender: TObject);
begin
 EXIT;
(*
 if MessageDlg('Are you sure send keys to all?',
     mtInformation, [mbYes, mbNo], 0) = mrYes then
   //ok
 else
 Exit;

 Query1.First;
 Repeat
  ListBox1.Items.Add(Query1.FieldByName('Name').AsString);
  Query1.Next;
 until Query1.EOF;
 ShowCount;

 Query1.First;
 Repeat
  StoreAKeyForBatch;
  Delay(1000)
  PrepareMsgWithKeysToSent;
  Delay(1000);
  BtnSendAllClick(Application);
  Delay(5000);
  Query1.Next;
 until Query1.EOF;
*)
end;

procedure TClients.EFCOUNT1Click(Sender: TObject);
Var i:Integer;s,T1Key:String;TempList,WList:TStringList; InpKey:String; Tbl:TTable;
begin
  InitEFCountClick(Sender);
  TempList:=TStringList.Create;
  Wlist:=TStringList.Create;
  //this year's DBF
  Tbl := TTable.Create(Application);
  Tbl.TableName := 'CLIENTS.DBF';
  Tbl.IndexName := 'T1KEY';
  If Tbl.Active then Tbl.Close;
  Tbl.Open;
  //COMPARE
  Tbl.First;

  TempList.LoadFromFile(T1LogsDir+'\'+'AllLogs.txt');
//  Try
   //first rec //not 0
   For i:=2 to TempList.Count-1 do
   begin
   //If UpperCase(s)='ZZZEND' then break;
    Wlist.Clear;
    s:=TempList[i]+'|';
    ParseWords(S,'|',WList);
    T1Key:=Wlist[0];
    // ShowTimedMsg(T1Key,10);
    if Tbl.FindKey([T1Key]) then
    begin
      Tbl.Edit;
      Tbl.FieldByName('EFCOUNT').AsFloat:=Tbl.FieldByName('EFCOUNT').AsInteger +1;
    end;
  end;
  Tbl.Close;
  TempList.Free;
  WList.Free;
  ShowMessage('Done');
end;

procedure TClients.InitEFCountClick(Sender: TObject);
begin
 Query1.First;
 Repeat
  Query1.Edit;
  Query1.FieldByName('EFCOUNT').AsFloat:=0;
  Query1.Next;
 until Query1.Eof;
 ShowMessage('InitRfcount Done');
end;

procedure TClients.SEndMapiAckBTNClick(Sender: TObject);
Var i:integer;Subject,SomeSubject:String; SomeText:AnsiString;
begin
 MsgOptionBox.ItemIndex :=-1;

 If MsgOptionBox.ItemIndex =-1 then
 begin
   If UpperCase(AllTrim(Query1.FieldByName('CD_Num').AsString)) > '' then
    MsgOptionBox.ItemIndex :=1
   else
    MsgOptionBox.ItemIndex :=0;
 end;


  If MsgOptionBox.ItemIndex<0 then
  begin
   ShowMessage('You must select a Message Option');
   exit;
  end;

  If EFrom.Text='' then
  begin
   ShowMessage('Enter From mail address');
   Efrom.setFocus;
   exit;
  end;
  If EServer.Text='' then
  begin
   ShowMessage('Enter Mail Server name');
   EServer.SetFocus;
   exit;
  end;

  If ListAddr.items.Count =0 then
  begin
  ShowMessage('The Recipient list is empty. Double click client first');
  exit;
  end;

  SomeSubject := eSubject.Text;
  SomeText:='';
  For i:=0 to ReMessageText.lines.Count-1 do
   SomeText:=SomeText+RemessageText.Lines[i]+Chr(10);
  SendMapiMail(SomeSubject,SomeText,'','','','',EmailAddressBox.text);

  // we're done
  Query1.Edit;
  Query1.FieldByName('ACKN_sent').AsString:=FormatDateTime('yyyy-mm-dd',Date); //2008-12-14
  Query1.Refresh;
  ShowMessage('done');
end;

procedure TClients.SendMapiEmailBtnClick(Sender: TObject);
Var i:integer;Subject,SomeSubject:String; SomeText:AnsiString;
    cLVerf, cLimitedBN, cAttachments: string; // 20200615 Igor
begin
  If EFrom.Text='' then
  begin
   ShowMessage('Enter From mail address');
   Efrom.setFocus;
   exit;
  end;
  If EServer.Text='' then
  begin
   ShowMessage('Enter Mail Server name');
   EServer.SetFocus;
   exit;
  end;

  If ListAddr.items.Count =0 then
  begin
  ShowMessage('The Recipient list is empty. Double click client first');
  exit;
  end;

  SomeSubject := eSubject.Text;
  // 20200615 Igor >>>
  (*
  SomeText:='';
  For i:=0 to ReMessageText.lines.Count-1 do
   SomeText:= SomeText + RemessageText.Lines[i] + '%0D%0A'; //20111108 //%0D%0A is hex for 10 (linefeed) and 13 (carriage return) //Chr(10)+Chr(13);
  *)
  
  // generate and attach files
  cLVerf := ExtractFilePath(ParamStr(0)) + SaveToSubFolder + '\LVerf.EX_';
  cLimitedBN := ExtractFilePath(ParamStr(0)) + SaveToSubFolder + '\LimitedBN.D';
  cAttachments := '';
  if GenerateLVerf(cLVerf) then
  begin
    if cAttachments <> '' then
      cAttachments := cAttachments + #13#10;
    cAttachments := cAttachments + cLVerf;
  end;
  if GenerateLimitedBN(cLimitedBN) then
  begin
    if cAttachments <> '' then
      cAttachments := cAttachments + #13#10;
    cAttachments := cAttachments + cLimitedBN;
  end;

  //20111108 //john
  //ShellExecute(Self.Handle,nil,Pchar(''+ 'mailto:'+ EmailAddressBox.text +'?Subject='+SomeSubject + '&Body=' + SomeText), nil, nil, SW_NORMAL);

  SomeText := ReMessageText.Text;
  if SendMapiMail(SomeSubject,SomeText,cAttachments,'','','',EmailAddressBox.text) <> 0 then Exit;
  // 20200615 Igor <<<

  //20151211
  // we're done
  Delay(300);
  Query1.Edit;
  Query1.FieldByName('KEYS_sent').AsString:=FormatDateTime('yyyy-mm-dd',Date);
  Query1.Post;
  Query1.Refresh;
  ShowMessage('done');


  EXIT;   //why?  Who?
//----------------------------------------

 MsgOptionBox.ItemIndex :=-1;

 If MsgOptionBox.ItemIndex =-1 then
 begin
   If UpperCase(AllTrim(Query1.FieldByName('CD_NUM').AsString)) > '' then
    MsgOptionBox.ItemIndex :=1
   else
    MsgOptionBox.ItemIndex :=0;
 end;


  If MsgOptionBox.ItemIndex<0 then
  begin
   ShowMessage('You must select a Message Option');
   exit;
  end;

  If EFrom.Text='' then
  begin
   ShowMessage('Enter From mail address');
   Efrom.setFocus;
   exit;
  end;
  If EServer.Text='' then
  begin
   ShowMessage('Enter Mail Server name');
   EServer.SetFocus;
   exit;
  end;

  If ListAddr.items.Count =0 then
  begin
  ShowMessage('The Recipient list is empty. Double click client first');
  exit;
  end;

  SomeSubject := eSubject.Text;
  SomeText:='';
  For i:=0 to ReMessageText.lines.Count-1 do
   SomeText:= SomeText + RemessageText.Lines[i] + '%0D%0A'; //20111108 //%0D%0A is hex for 10 (linefeed) and 13 (carriage return) //Chr(10)+Chr(13);

  //20111108 //john
  ShellExecute(Self.Handle,nil,Pchar(''+ 'mailto:'+ EmailAddressBox.text +'?Subject='+SomeSubject + '&Body=' + SomeText), nil, nil, SW_NORMAL);

  //SendMapiMail(SomeSubject,SomeText,'','','','',EmailAddressBox.text); //does not work, not sure why

  // we're done
  Delay(600);
  Query1.Edit;
  Query1.FieldByName('KEYS_sent').AsString:=FormatDateTime('yyyy-mm-dd',Date);
  Query1.Post;
  Query1.Refresh;
  ShowMessage('done');
end;

procedure TClients.BreakListBtnClick(Sender: TObject);
Var i,k,NumLists:Integer; TempList:TStringList;
 List1:TStringList;
 List2:TStringList;
 List3:TStringList;
 List4:TStringList;
 List5:TStringList;
 List6:TStringList;
 List7:TStringList;
 List8:TStringList;
 List9:TStringList;
 List10:TStringList;
 List11:TStringList;
 List12:TStringList;
 List13:TStringList;
 List14:TStringList;
 List15:TStringList;

 List16:TStringList;
 List17:TStringList;
 List18:TStringList;
 List19:TStringList;
 List20:TStringList;

 begin
 TempList:=TstringList.Create;

 //Delete existings lists
 For i:=1 to 20 do
 begin
  If FileExists(AppDir+'\'+'List'+AllTrim(IntToStr(i))) then
    SysUtils.DeleteFile(AppDir+'\'+'List'+AllTrim(IntToStr(i)));
 end;
 // create new lists
 List1:=TStringList.Create;
 List2:=TStringList.Create;
 List3:=TStringList.Create;
 List4:=TStringList.Create;
 List5:=TStringList.Create;;
 List6:=TStringList.Create;;
 List7:=TStringList.Create;;
 List8:=TStringList.Create;;
 List9:=TStringList.Create;;
 List10:=TStringList.Create;;
 List11:=TStringList.Create;;
 List12:=TStringList.Create;;
 List13:=TStringList.Create;;
 List14:=TStringList.Create;;
 List15:=TStringList.Create;;
 List16:=TStringList.Create;;
 List17:=TStringList.Create;;
 List18:=TStringList.Create;;
 List19:=TStringList.Create;;
 List20:=TStringList.Create;;

 //k:=100;  //100 per list
 TempList.LoadFromFile(AppDir+'\'+'BccList.txt');
 //NumLists:=TempList.count Div k;

 For i:=0 to TempList.count-1 do
 begin
  Case i of
   0..99: List1.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   100..199: List2.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   200..299: List3.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   300..399: List4.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   400..499: List5.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   500..599: List6.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   600..699: List7.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   700..799: List8.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   800..899: List9.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   900..999:List10.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1000..1099: List11.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1100..1199: List12.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1200..1299: List13.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1300..1399: List14.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1400..1499: List15.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1500..1599: List16.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1600..1699: List17.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1700..1799: List18.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1800..1899: List19.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
   1900..1999: List20.add(StringReplace(Templist[i], ';' , ',' , [rfReplaceAll, rfIgnoreCase]));
  end;
 end;
 // save lists
 If List1.count>0 then List1.SaveToFile(AppDir+'\'+'List1.txt');
 If List2.count>0 then List2.SaveToFile(AppDir+'\'+'List2.txt');
 If List3.count>0 then List3.SaveToFile(AppDir+'\'+'List3.txt');
 If List4.count>0 then List4.SaveToFile(AppDir+'\'+'List4.txt');
 If List5.count>0 then List5.SaveToFile(AppDir+'\'+'List5.txt');
 If List6.count>0 then List6.SaveToFile(AppDir+'\'+'List6.txt');
 If List7.count>0 then List7.SaveToFile(AppDir+'\'+'List7.txt');
 If List8.count>0 then List8.SaveToFile(AppDir+'\'+'List8.txt');
 If List9.count>0 then List9.SaveToFile(AppDir+'\'+'List9.txt');
 If List10.count>0 then List10.SaveToFile(AppDir+'\'+'List10.txt');
 If List11.count>0 then List11.SaveToFile(AppDir+'\'+'List11.txt');
 If List12.count>0 then List12.SaveToFile(AppDir+'\'+'List12.txt');
 If List13.count>0 then List13.SaveToFile(AppDir+'\'+'List13.txt');
 If List14.count>0 then List14.SaveToFile(AppDir+'\'+'List14.txt');
 If List15.count>0 then List15.SaveToFile(AppDir+'\'+'List15.txt');
 If List16.count>0 then List16.SaveToFile(AppDir+'\'+'List16.txt');
 If List17.count>0 then List17.SaveToFile(AppDir+'\'+'List17.txt');
 If List18.count>0 then List18.SaveToFile(AppDir+'\'+'List18.txt');
 If List19.count>0 then List19.SaveToFile(AppDir+'\'+'List19.txt');
 If List20.count>0 then List20.SaveToFile(AppDir+'\'+'List20.txt');

 //Free the lists
 List1.Free;
 List2.Free;
 List3.Free;
 List4.Free;
 List5.Free;
 List6.Free;
 List7.Free;
 List8.Free;
 List9.Free;
 List10.Free;
 List11.Free;
 List12.Free;
 List13.Free;
 List14.Free;
 List15.Free;
 List16.Free;
 List17.Free;
 List18.Free;
 List19.Free;
 List20.Free;

 ShowMessage('Done. Now BCC each list')
end;


procedure TClients.AllLogs1Click(Sender: TObject);
Var h:THandle;
begin
// SomeList:=TStringList.Create;
 h:=ShellExecute(Application.Handle,'open','c:\windows\notepad.exe',Pchar(T1LogsDir+'\'+'AllLogs.txt'),nil,SW_SHOWNORMAL);
 If h<=32 then ShowMessage('File not found: AllLogs.txt');

 {
 SomeList.LoadFromFile(T1LogsDir+'\'+'AllLogs.txt');
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 PopList.Release;
 SomeList.Free;
 }

end;

procedure TClients.EfileLogs1Click(Sender: TObject);
Var i:Integer;TempList:TStringList;ToF:TextFile;Rslt:Boolean;
    ThisFileAge:Integer; Dt:String;
    FromDate,ToDate:String; yyyy,mm,dd:String;
    FlName:String;
begin
 Screen.Cursor:=CrHourGlass;
 TempList:=TStringList.Create;
 If FileExists(T2LogsDir+'AllLogsT2.txt') then
 begin
  Rslt:=sysUtils.DeleteFile(T2LogsDir+'AllLogsT2.txt');
  If Rslt=False then ShowMessage('AllLogsT2.txt could not be deleted');
 end;

 If FileExists(T2LogsDir+'OffendersT2.txt') then  sysUtils.DeleteFile(T2LogsDir+'OffendersT2.txt');
 //initialize file with blank record
 AssignFile(ToF,T2LogsDir+'AllLogsT2.txt');
 Try
 Rewrite(ToF);
 Except
 End;
 //Writeln(ToF, 'ZZZEND');
 CloseFile(ToF);

 TempList:=GetFileList(T2LogsDir, '*.*');
 //merge files
 FromDate:= InputBox('Input Box', 'Enter starting date', '2014-02-01');
 ToDate:= InputBox('Input Box', 'Enter starting date', '2014-12-31');
 For i:=0 to TempList.count-1 do
 begin
  If Numeric(LeftStr(ExtractFileName(TempList[i]),4))
  then
  begin
   {
   ThisFileAge:=FileAge(TempList[i]);
   Dt:=FormatDateTime('yyyy-mm-dd',FileDateToDateTime(ThisFileAge));
   }
   FlName:=ExtractFileName(TempList[i]);
   FlName:=LeftStr(FlName,Length(FlName)-4);  //getrid of .txt
   yyyy:=LeftStr(Flname,4);
   mm:=PaddZero(AllTrim(MidStr(Flname,6,2)),2);
   dd:=PaddZero(AllTrim(MidStr(Flname,8,3)),2);
   Dt:=yyyy+'-'+mm+'-'+DD;
   If (Dt>=FromDate) and (Dt<=ToDate) then
       AppendAFile(TempList[i],T2LogsDir+'AllLogsT2.txt') ;  //20150223
  end;
 end;

 AnalyseEfileLogT2(T2LogsDir+'AllLogsT2.txt');
 Screen.Cursor:=CrDefault;

end;

procedure TClients.AllLogs2Click(Sender: TObject);
Var h:THandle;
begin
 h:=ShellExecute(Application.Handle,'open','c:\windows\notepad.exe',Pchar(T2LogsDir+'\'+'AllLogsT2.txt'),nil,SW_SHOWNORMAL);
 If h<=32 then ShowMessage('File not found: AllLogsT2.txt');
end;

procedure TClients.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = Ord('F')) and (ssCtrl in Shift) then
    SearchBtnClick(Sender);

end;

procedure TClients.LastYRDueBtnClick(Sender: TObject);
Var x:Real;
begin
Query1.First;
 Repeat
 Query1.Edit;
 x:=Query1.FieldByName('BAL_DUE').AsFloat;
 If X <>0 then
 begin
  Query1.FieldByName('LASTYR_DUE').AsFloat:= X;
  Query1.FieldByName('BAL_DUE').AsFloat:=0;
 end;
 Query1.Next;
 until Query1.Eof;
end;

procedure TClients.AddressVerificationBtnClick(Sender: TObject);
Var i:integer;Subject,SomeSubject:String; SomeText:AnsiString;
Postal:String;
begin
  Remessagetext.Clear;
  ListAddr.items.clear;
  ListAddr.Items.Add(Query1.FieldByName('EMail').AsString);
  EmailAddressBox.Text:=AllTrim(Query1.FieldByName('EMail').AsString);

  ReMessageText.Lines.clear;

  MsgOptionBox.ItemIndex :=4; //-1;

  If MsgOptionBox.ItemIndex<0 then
  begin
   ShowMessage('You must select a Message Option');
   exit;
  end;

  If EFrom.Text='' then
  begin
   ShowMessage('Enter From mail address');
   Efrom.setFocus;
   exit;
  end;
  If EServer.Text='' then
  begin
   ShowMessage('Enter Mail Server name');
   EServer.SetFocus;
   exit;
  end;

  If ListAddr.items.Count =0 then
  begin
  ShowMessage('The Recipient list is empty. SINGLE click client first');
  exit;
  end;

  SomeSubject := 'Address Verification'; //eSubject.Text;

  With Query1 do
  Begin
       RemessageText.Lines.add(FieldByName('NAME').AsString);
       RemessageText.Lines.add(FieldByName('Contact').AsString);
       RemessageText.Lines.add(RemoveChar(UpperCase(FieldByName('STREET').AsString),'#'));
       RemessageText.Lines.add(Uppercase(FieldByName('CITY').AsString));
       RemessageText.Lines.add(UpperCase(FieldByName('PROVINCE').AsString));
       RemessageText.Lines.add(UpperCase(FieldByName('POSTAL').AsString));
     End;
  SomeText:='';
  SomeText:=SomeText+'Please verify if the address shown below is correct for CD shipping: '+ '%0D%0A';
  SomeText:=SomeText+' '+'%0D%0A';

  For i:=0 to ReMessageText.lines.Count-1 do
  Begin
    SomeText:= SomeText + RemessageText.Lines[i] + '%0D%0A'; //20111108 //%0D%0A is hex for 10 (linefeed) and 13 (carriage return) //Chr(10)+Chr(13);
  // SomeText:= SomeText + RemessageText.Lines[i]+Chr(13);
  end;

 SomeText:= SomeText + ' '+'%0D%0A';
 SomeText:= SomeText + 'Yours truly'+ '%0D%0A';
 SomeText:= SomeText + 'VisualTax'+ '%0D%0A';

  //20111108 //john
 // SendMapiMail(SomeSubject,SomeText,'','','','',EmailAddressBox.text);
  ShellExecute(Self.Handle,nil,Pchar(''+ 'mailto:'+ EmailAddressBox.text +'?Subject='+SomeSubject + '&Body=' + SomeText), nil, nil, SW_NORMAL);

 end;

procedure TClients.GSTHST1Click(Sender: TObject);
begin
Application.CreateForm(TGST,GST);
GST.ShowModal;
GST.Free;
end;

procedure TClients.DuplicateBtnClick(Sender: TObject);
//Var sTemp:String;
var varCopyData: Variant; i: Integer;
begin
  with Query1 do
  begin
    varCopyData := VarArrayCreate([0, FieldCount-1], varVariant);
    for i := 0 to FieldCount-1 do  varCopyData[i] := Fields[i].Value;
    Insert;
    for i := 0 to FieldCount-1 do
      Fields[i].Value := varCopyData[i];
  end;
  //clear some fields
  With Query1 do
  Begin
   Query1.FieldByName('Paid').AsFloat:=0;
   Query1.FieldByName('T1').AsString:='';
   Query1.FieldByName('T2').AsString:='';
   Query1.FieldByName('T3').AsString:='';
   Query1.FieldByName('TF').AsString:='';
   Query1.FieldByName('T4').AsString:='';
   Query1.FieldByName('FP').AsString:='';
   Query1.FieldByName('TR').AsString:='';
   Query1.FieldByName('S1').AsString:='';
   Query1.FieldByName('S2').AsString:='';
   Query1.FieldByName('CLOUD').AsString:=''; //20180917 Igor
   //20190306 Igor >>>
   Query1.FieldByName('DROPBOX').AsString:='';
   Query1.FieldByName('T1CLOUD').AsString:='';
   Query1.FieldByName('T2CLOUD').AsString:='';
   Query1.FieldByName('T3CLOUD').AsString:='';
   Query1.FieldByName('T4CLOUD').AsString:='';
   Query1.FieldByName('TFCLOUD').AsString:='';
   Query1.FieldByName('FPCLOUD').AsString:='';
   //20190306 Igor <<<

   Query1.FieldByName('T1Key').AsString:='';
   Query1.FieldByName('T2Key').AsString:='';
   Query1.FieldByName('T3Key').AsString:='';
   Query1.FieldByName('TFKey').AsString:='';
   Query1.FieldByName('T4Key').AsString:='';
   Query1.FieldByName('FPKey').AsString:='';
   Query1.FieldByName('TRKey').AsString:='';
   Query1.FieldByName('S1Key').AsString:='';
   Query1.FieldByName('S2Key').AsString:='';
   Query1.FieldByName('CLOUDKEY').AsString:=''; //20180917 Igor
   Query1.FieldByName('DROPBOXKEY').AsString:=''; //20190306 Igor

   Query1.FieldByName('Inv_sent').AsString:='';
   Query1.FieldByName('KEYS_sent').AsString:='';
  end;
end;

procedure TClients.GenCustomerNoBtnClick(Sender: TObject);
Var k:LongInt;
//20140929
begin
 If AllTrim(Query1.FieldByName('Account').AsString)>'' then
  ShowMessage('Account Number already exists')
 else
 Begin
  k:=GenerateRandomNumber(9999999);
  Query1.Edit;
  Query1.FieldByName('Account').AsString:=IntToStr(k);
  Query1.Post;
 end;
end;

procedure TClients.GenPasswordBtnClick(Sender: TObject);
Var k:Integer;Str:String;
//20140929
begin
 If AllTrim(Query1.FieldByName('PSW').AsString)>'' then
  ShowMessage('Password already exists')
 else
 Begin
  k:=GenerateRandomNumber(999);
  Str:=UpperCase(GenerateRandomString(5));
  Str:=Str+IntToStr(k);
  Query1.Edit;
  Query1.FieldByName('PSW').AsString:=Str;
  Query1.Post;
 end;
end;

procedure TClients.GenALLaccountAndPswBTNClick(Sender: TObject);
Var k:LongInt;Str:String;
begin
 Query1.First;
 Repeat
  If Length(AllTrim(Query1.FieldByName('Account').AsString))<7
   then
  Begin
   k:=GenerateRandomNumber(9999999);
   Query1.Edit;
   Query1.FieldByName('Account').AsString:=IntToStr(k);
   Query1.Post;
  end;


  If Length(AllTrim(Query1.FieldByName('PSW').AsString))<8 then
  Begin
   k:=GenerateRandomNumber(999);
   Str:=UpperCase(GenerateRandomString(5));
   Str:=Str+IntToStr(k);
   Query1.Edit;
   Query1.FieldByName('PSW').AsString:=Str;
   Query1.Post;
  end;
  Query1.Next;
 until Query1.Eof;
end;

procedure TClients.FillHstBtnClick(Sender: TObject);
var MMDD:String;YYYY:String;HstRate:Real;BeforeHst:Real;
begin
 If Query1.FieldByName('Paid').AsFloat =0 then
   begin ShowMessage('Amount Paid is zero. Nothing done');Exit;end;

 If Query1.FieldByName('Province').AsString ='' then
   begin ShowMessage('Province missing');Exit;end;

  If ValidDate(Query1.FieldByName('OrDate').AsString)= false then
  begin ShowMessage('OrDate incorrect');Exit;end;

 HstRate:=GetTaxRate(UpperCase(Query1.FieldByName('PROVINCE').AsString));
 YYYY:=LeftStr(Query1.FieldByName('OrDate').AsString,4);
 MMDD:=MidStr(Query1.FieldByName('OrDate').AsString,5,4);

 FillHst(True);
// FillHst(ReplaceSw);
end;

procedure TClients.IndexByGroupClick(Sender: TObject);

begin
 Query1.Close;
 Query1.SQL.Clear;
 {------------}
 With Query1 do
 begin
  SQL.Add('Select * ');
  SQL.Add('from Clients');

  If AllTrim(WhereClause) <> '' then
  begin
   SQL.Add(WhereClause);
  // If IndexByGroup.ItemIndex=1 then WhereClause:='WHERE ' + Query1.FieldByName('OrDate').AsString; //+';>'');
  end;
  If IndexByGroup.ItemIndex=0 then
   SQL.Add( 'ORDER BY Name')
  Else
   SQL.Add( 'ORDER BY Ordate');

  Prepare;
  open;
 end;
end;


procedure TClients.FillMissingHSTBtnClick(Sender: TObject);
Var ReplaceSw:Boolean;
begin
  if MessageDlg('Replace existing values?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  begin
    ShowMessage('Left the existing values');
    Exit;
  end
  Else
   ReplaceSw:=True;

 Query1.Edit; //20170428
 Query1.First;
 Repeat

  //20160428
  If (Query1.FieldByName('Paid').AsFloat>0)
  then
  begin
    Query1.Edit;
    FillHst(ReplaceSw);
    Query1.Edit;  //20170428
    Query1.Post;
    Query1.Next;
  end
  Else
   Query1.Next;
 until Query1.Eof;
 ShowMessage('Done');
end;


Function TClients.ValidateProductVersion:Boolean; // 20180904 Igor
Begin
 Result:=True;
 Version:=AllTrim(Query1.FieldByName('T1').AsString);
 If Version>'' then
 Begin
   If ((version='L') Or (version='E') Or (version='S') or (Version='P') or (version='M') or (version='X')) then
   //ok
   Else
   Begin
    ShowMessage('T1 version can only be X=Demo L=Limited E:=Limited with Efile S=Standard, P=Power or M-MultiOffice');
    Result:=False;
    Exit;
   end;
 end;

 Version:=AllTrim(Query1.FieldByName('T2').AsString);
 If Version>'' then
 Begin
   If (version='1')
   or (version='2')
   or (version='3')
   or (version='4')
   or (version='5')
   or (version='6')  //20180829
   Or (version='S')
   or (Version='P')
   or (Version='X')
   or (Version='E') then //20200916 Igor
   //ok
   Else
   Begin
    ShowMessage('T2 version can only be X=Demo, 1 to 6, S=Standard, P=Power, E=Enterprise)'); //20200916 Igor
    Result:=False;
    Exit;
   end;
 end;

 Version:=AllTrim(Query1.FieldByName('T3').AsString);
 If Version>'' then
 Begin
   If ((version='S') Or (version='P') Or (version='X')) then
   //ok
   Else
   Begin
    ShowMessage('T3 version can only be X=Demo S=Standard/no Efile P:=Power With Efile');
    Result:=False;
    Exit;
   end;
 end;

 Version:=AllTrim(Query1.FieldByName('TF').AsString);
 If Version>'' then
 Begin
   If (version='P') or (version='X') then
   //ok
   Else
   Begin
    ShowMessage('TF version can only be X=Demo P:=Power');
    Result:=False;
    Exit;
   end;
 end;

 Version:=AllTrim(Query1.FieldByName('T4').AsString);
 If Version>'' then
 Begin
   If ((version='S') Or (version='P') Or (version='X')) then
   //ok
   Else
   Begin
    ShowMessage('T4 version can only be X=Demo S=Standard-no Efile P:=Power-With Efile');
    Result:=False;
    Exit;
   end;
 end;

 Version:=AllTrim(Query1.FieldByName('FP').AsString);
 If Version>'' then
 Begin
   If ((version='S') Or (version='P') Or (version='X')) then
   //ok
   Else
   Begin
    ShowMessage('FP version can only be X=Demo S=Standard P:=Power');
    Result:=False;
    Exit;
   end;
 end;

 Version:=AllTrim(Query1.FieldByName('AR').AsString);
 If Version>'' then
 Begin
   If version='A' then
   //ok
   Else
   Begin
    ShowMessage('Archives version can only be A=Archives');
    Result:=False;
    Exit;
   end;
 end;

 Version:=AllTrim(Query1.FieldByName('TR').AsString);
 If Version>'' then
 Begin
   If version='S' then
   //ok
   Else
   Begin
    ShowMessage('TR can only be S=Standard');
    Exit;
   end;
 end;


 Version:=AllTrim(Query1.FieldByName('S1').AsString);
 If Version<>'' then
 Begin
   If version='S' then
   //ok
   Else
   Begin
    ShowMessage('S1 version can only be S=Standard');
    Result:=False;
    Exit;
   end;
 end;

 Version:=AllTrim(Query1.FieldByName('S2').AsString);
 If Version<>'' then
 Begin
   If version='S' then
   //ok
   Else
   Begin
    ShowMessage('S2 version can only be S=Standard');
    Result:=False;
    Exit;
   end;
 end;

end;

procedure TClients.FillHst(ReplaceSw:Boolean);
var MMDD:String;YYYY:String;HstRate:Real;BeforeHst:Real;
begin
 HstRate:=GetTaxRate(UpperCase(Query1.FieldByName('PROVINCE').AsString));
 YYYY:=LeftStr(Query1.FieldByName('OrDate').AsString,4);
 MMDD:=MidStr(Query1.FieldByName('OrDate').AsString,5,4);

 If (mmdd>='0101') and (mmdd<='0331') then
 begin
  Query1.Edit;
  Beforehst:=Query1.FieldByName('Paid').AsFloat/ (1+HstRate/100);
  Query1.FieldByName('Sale1').AsFloat:=BeforeHst;
  Query1.FieldByName('Hst1').AsFloat:=(BeforeHst * HstRate)/100;
  Query1.Post;
 end;

 If (mmdd>='0401') and (mmdd<='0630') then
 begin
  Query1.Edit;
  Beforehst:=Query1.FieldByName('Paid').AsFloat/ (1+HstRate/100);
  Query1.FieldByName('Sale2').AsFloat:=BeforeHst;
  Query1.FieldByName('Hst2').AsFloat:=(BeforeHst * HstRate)/100;
  Query1.Post;
 end;

 If (mmdd>='0701') and (mmdd<='0930') then
 begin
  Query1.Edit;
  Beforehst:=Query1.FieldByName('Paid').AsFloat/ (1+HstRate/100);
  Query1.FieldByName('Sale3').AsFloat:=BeforeHst;
  Query1.FieldByName('Hst3').AsFloat:=(BeforeHst * HstRate)/100;
  Query1.Post;
 end;

 If (mmdd>='1001') and (mmdd<='1231') then
 begin
  Query1.Edit;
  Beforehst:=Query1.FieldByName('Paid').AsFloat/ (1+HstRate/100);
  Query1.FieldByName('Sale4').AsFloat:=BeforeHst;
  Query1.FieldByName('Hst4').AsFloat:=(BeforeHst * HstRate)/100;
  Query1.Post;

end;
end;


procedure TClients.StoreCloudKey; //20180917 Igor
Var ProductId:String;AKey:String;
begin
 Pgm:='';
 If UpperCase(Query1.FieldByName('CLOUD').AsString) >'' then Pgm:= 'Cloud';
 If Pgm>'' then
 begin
  ProductId:=GetProductId(Pgm);
  AKey:=MakeAKey(ProductId);
  Query1.Edit;
  Query1.FieldByName('CLOUDKEY').AsString:=AKey;
  Query1.Post;
  Delay(100);
 end;
 if (Query1.FieldByName('CLOUDKEY').AsString > '') and
    (Query1.FieldByName('CLOUDDIR').AsString = '') then
 begin
   Query1.Edit;
   Query1.FieldByName('CLOUDDIR').AsString := GenerateGUID;
   //Query1.FieldByName('CLOUDDATADIR').AsString := Query1.FieldByName('CLOUDDIR').AsString; //20190112 //20190213 Igor

   Query1.Post;
 end;
end;

procedure TClients.StoreDropBoxKey; //20190306 Igor
Var ProductId:String;AKey:String;

  function GetCloudOptions: Integer;
    procedure CheckOption(AField: string; ABit: Integer);
    begin
      if Query1.FieldByName(AField).AsString = 'Y' then
        Result := Result or (1 shl (ABit - 1));
    end;
  begin
    Result := 0;
    CheckOption('T1CLOUD', 1);
    CheckOption('T2CLOUD', 2);
    CheckOption('T3CLOUD', 3);
    CheckOption('T4CLOUD', 4);
    CheckOption('TFCLOUD', 5);
    CheckOption('FPCLOUD', 6);
  end;

begin
  Pgm:='';
  If UpperCase(Query1.FieldByName('DROPBOX').AsString) = 'X' then Pgm:= 'DropBox Demo';
  If UpperCase(Query1.FieldByName('DROPBOX').AsString) = 'S' then Pgm:= 'DropBox';
  If Pgm>'' then
  begin
    ProductId:=GetProductId(Pgm);
    if UpperCase(Query1.FieldByName('DROPBOX').AsString) = 'X' then
      AKey:=MakeHelperDemoKey(ProductId, Date + 14, GetCloudOptions)
    else
      AKey:=MakeHelperKey(ProductId, GetCloudOptions);
    Query1.Edit;
    Query1.FieldByName('DROPBOXKEY').AsString:=AKey;
    Query1.Post;
    Delay(100);
  end;
end;

//20181108 Igor >>>
{function TClients.GenerateKeysXML(AFileName: string): boolean; //20180917 Igor
var XML: TStringList;
    Q: TQuery;
    I: integer;

    function PrepareStr(AStr: string): string;
    begin
      AStr := StringReplace(AStr, '&', '&amp;', [rfReplaceAll, rfIgnoreCase]);
      AStr := StringReplace(AStr, '=', '', [rfReplaceAll, rfIgnoreCase]);
      Result := AStr;
    end;

begin
  Result := false;
  XML := TStringList.Create;
  Q := TQuery.Create(nil);
  try
    Q.SQL.Text := 'SELECT * FROM Clients';
    Q.Open;
    if Q.RecordCount = 0 then Exit;
    XML.Add('keys=');
    //XML.Add('<?xml version="1.0" encoding="UTF-8"?>');
    XML.Add('<CLIENTS YEAR="2018">');
    Q.First;
    while not Q.Eof do
    begin
      for I := 0 to 4000 do
      begin
      XML.Add('  <CLIENT>');
      XML.Add('    <NAME>'+ PrepareStr(Q.FieldByName('NAME').AsString) +'</NAME>');
      XML.Add('    <CLOUDDIR>'+ PrepareStr(Q.FieldByName('CLOUDDIR').AsString) + '</CLOUDDIR>');
      XML.Add('    <T1KEY>'+ Q.FieldByName('T1KEY').AsString +'</T1KEY>');
      XML.Add('    <T2KEY>'+ Q.FieldByName('T2KEY').AsString +'</T2KEY>');
      XML.Add('    <T3KEY>'+ Q.FieldByName('T3KEY').AsString +'</T3KEY>');
      XML.Add('    <T4KEY>'+ Q.FieldByName('T4KEY').AsString +'</T4KEY>');
      XML.Add('    <TFKEY>'+ Q.FieldByName('TFKEY').AsString +'</TFKEY>');
      XML.Add('    <FPKEY>'+ Q.FieldByName('FPKEY').AsString +'</FPKEY>');
      XML.Add('    <TRKEY>'+ Q.FieldByName('TRKEY').AsString +'</TRKEY>');
      XML.Add('    <S1KEY>'+ Q.FieldByName('S1KEY').AsString +'</S1KEY>');
      XML.Add('    <S2KEY>'+ Q.FieldByName('S2KEY').AsString +'</S2KEY>');
      XML.Add('    <CLOUDKEY>'+ Q.FieldByName('CLOUDKEY').AsString +'</CLOUDKEY>');
      XML.Add('  </CLIENT>');
      end;
      Q.Next;
    end;
    XML.Add('</CLIENTS>');
    XML.SaveToFile(AFileName);
    Result := true;
  finally
    Q.Close; Q.Free;
    XML.Free;
  end;
end;}
//20181108 Igor <<<

function GetAllowedApps(Q: TQuery): string; //20190306 Igor
  procedure AddApp(App: string);
  begin
    if Result <> '' then
      Result := Result + ', ';
    Result := Result + App;
  end;
begin
  Result := '';
  if Q.FieldByName('T1CLOUD').AsString = 'Y' THEN
    AddApp('T1');
  if Q.FieldByName('T2CLOUD').AsString = 'Y' THEN
    AddApp('T2');
  if Q.FieldByName('T3CLOUD').AsString = 'Y' THEN
    AddApp('T3');
  if Q.FieldByName('T4CLOUD').AsString = 'Y' THEN
    AddApp('T4T5');
  if Q.FieldByName('TFCLOUD').AsString = 'Y' THEN
    AddApp('TF');
  if Q.FieldByName('FPCLOUD').AsString = 'Y' THEN
    AddApp('FP');
end;

procedure TClients.ExportToSiteBtnClick(Sender: TObject); //20180917 Igor //20181108 Igor 
var cFile: AnsiString;
    XML: TStringList;
    Q: TQuery;
    I, J: integer; //20191015 Igor
    cClear: string;
    bExportModified, bSuccess: boolean;
    BN: TBNList; //20191015 Igor

  function PrepareStr(AStr: string): string;
  begin
    AStr := StringReplace(AStr, '&', '&amp;', [rfReplaceAll, rfIgnoreCase]);
    AStr := StringReplace(AStr, '=', '', [rfReplaceAll, rfIgnoreCase]);
    Result := AStr;
  end;

  function PrepareBNStr(AStr: string): string; //20191021 Igor
  begin
    AStr := StringReplace(AStr, '+', '#', [rfReplaceAll, rfIgnoreCase]);
    Result := AStr;
  end;

begin

  case MessageDlg('Ready?', mtConfirmation, mbYesNoCancel, 0) of
    mrNo : Exit;
  end;

  Screen.Cursor := crHourGlass;
  XML := TStringList.Create;
  Q := TQuery.Create(nil);
  bSuccess := false;
  cClear := '';
  cClear := 'CLEAR="TRUE"';
  try
    cFile := 'clients.txt';

 (*
  //20200307
  case MessageDlg('Export only modified? USE N for ALL (Yes - Modified, No - Export all records)', mtConfirmation, mbYesNoCancel, 0) of
    mrYes : bExportModified := true;
    mrNo : bExportModified := false
    else Exit;
  end;

  Screen.Cursor := crHourGlass;
  XML := TStringList.Create;
  Q := TQuery.Create(nil);
  bSuccess := false;
  cClear := '';
  if not bExportModified then
    cClear := 'CLEAR="TRUE"';
  try
    cFile := 'clients.txt';
    if (Query1.State = dsEdit) or (Query1.State = dsInsert) then
      Query1.Post;

    //20191101 CON
    if bExportModified then
    begin
      Q.SQL.Text := 'SELECT * FROM Clients WHERE ModifiedForExport = :Modified AND (Cloud = ''Y'' OR Cloud = ''S'')';
      Q.Params.ParamByName('Modified').Value := 'Y';
    end
    else
  *)
    Q.SQL.Text := 'SELECT * FROM Clients WHERE Cloud = ''Y'' OR Cloud = ''S''';
    Q.Open;
    if Q.RecordCount = 0 then
    begin
      ShowMessage('There is nothing to export');
      Exit;
    end;
    while True do
    begin
      XML.Clear;
      XML.Add('keys=');
      XML.Add('<CLIENTS YEAR="2020" '+ cClear +'>'); //20191015 Igor
      cClear := '';
      for I := 0 to 10 do //20190108 Igor
      begin
        if Q.Eof then break;
        XML.Add('  <CLIENT>');
        XML.Add('    <NAME>'+ PrepareStr(Q.FieldByName('NAME').AsString) +'</NAME>');
        XML.Add('    <CLOUDDIR>'+ PrepareStr(Q.FieldByName('CLOUDDIR').AsString) + '</CLOUDDIR>');
        XML.Add('    <CLOUDDATADIR>'+ PrepareStr(Q.FieldByName('CLOUDDATAD').AsString) + '</CLOUDDATADIR>'); //20190213 Igor //20191101
        //XML.Add('    <CLOUDDATADIR>'+ PrepareStr(Q.FieldByName('CLOUDDATADIR').AsString) + '</CLOUDDATADIR>'); //20190213 Igor
        XML.Add('    <T1KEY>'+ Q.FieldByName('T1KEY').AsString +'</T1KEY>');
        XML.Add('    <T2KEY>'+ Q.FieldByName('T2KEY').AsString +'</T2KEY>');
        XML.Add('    <T3KEY>'+ Q.FieldByName('T3KEY').AsString +'</T3KEY>');
        XML.Add('    <T4KEY>'+ Q.FieldByName('T4KEY').AsString +'</T4KEY>');
        XML.Add('    <TFKEY>'+ Q.FieldByName('TFKEY').AsString +'</TFKEY>');
        XML.Add('    <FPKEY>'+ Q.FieldByName('FPKEY').AsString +'</FPKEY>');
        XML.Add('    <TRKEY>'+ Q.FieldByName('TRKEY').AsString +'</TRKEY>');
        XML.Add('    <S1KEY>'+ Q.FieldByName('S1KEY').AsString +'</S1KEY>');
        XML.Add('    <S2KEY>'+ Q.FieldByName('S2KEY').AsString +'</S2KEY>');
        XML.Add('    <CLOUDKEY>'+ Q.FieldByName('CLOUDKEY').AsString +'</CLOUDKEY>');
        //20190306 Igor >>>
        XML.Add('    <DROPBOXKEY>'+ Q.FieldByName('DROPBOXKEY').AsString +'</DROPBOXKEY>');
        XML.Add('    <ALLOWEDAPPS>'+ GetAllowedApps(Q) +'</ALLOWEDAPPS>');
        //20190306 Igor <<<

        //20191015 Igor >>>
        if IsLimited(Q.FieldByName('T2').AsString) then //20191021 igor
        begin
          BN := TBNList.Create;
          try
            for J := 1 to 6 do
            begin
              if (Q.FieldByName('LimBN' + IntToStr(J)).AsString = '')
                 or
                 (Q.FieldByName('LimYE' + IntToStr(J)).AsString = '') then continue;
              BN.Add(Q.FieldByName('LimBN' + IntToStr(J)).AsString + '=' + Q.FieldByName('LimYE' + IntToStr(J)).AsString);
            end;
            XML.Add('    <BNLimited>'+ PrepareBNStr(BN.EncryptedText) +'</BNLimited>'); //20191021 igor
          finally
            BN.Free;
          end;
        end;
        //20191015 Igor <<<
        XML.Add('  </CLIENT>');
        Q.Next;
      end;

      XML.Add('</CLIENTS>');
      XML.SaveToFile(cFile);
      NMHTTPForExport.Post('http://visualtax.com/Cloud/add_keys.php', cFile);
      if NMHTTPForExport.Body <> 'OK' then
      begin
        ShowMessage('Error occured while exporting (file size - '+ IntToStr(Length(XML.Text))+'): '+ #13#10 + NMHTTPForExport.Body); //20190108 Igor
        break;
      end;
      if Q.Eof then break;
    end;
    bSuccess := NMHTTPForExport.Body = 'OK';
  finally
    Screen.Cursor := crDefault;
    if bSuccess then
    begin
      Q.Close;
      Q.SQL.Text := 'UPDATE Clients SET ModifiedForExport = :Modified';
      Q.Params.ParamByName('Modified').Value := 'N';
      Q.ExecSQL;
      ShowMessage('Keys were successfully exported!');
    end;
    Q.Close; Q.Free;
    XML.Free;
  end;
end;

procedure TClients.Query1BeforePost(DataSet: TDataSet); //20181108 Igor 
begin
  DataSet.FieldByName('ModifiedForExport').AsString := 'Y';  //20191101
end;

procedure TClients.ExportToKeysDbBtnClick(Sender: TObject);  //20190111 Igor
var cFile: string;
    ZConn: TZConnection;
    ZQuery: TZQuery;
    Q: TQuery;
    //20191015 Igor >>>
    BN: TBNList;
    I: integer;
    //20191015 Igor <<<
begin
  if not SaveKeysDialog.Execute then Exit;
  cFile := SaveKeysDialog.FileName;

  ZConn := TZConnection.Create(nil);
  ZQuery := TZQuery.Create(nil);
  Q := TQuery.Create(nil);
  try
    ZConn.Protocol := 'sqlite-3';
    ZConn.Database := cFile;
    ZConn.Connect;
    ZQuery.Connection := ZConn;

    //20190306 Igor >>>
    ZQuery.SQL.Text :=
      ' CREATE TABLE IF NOT EXISTS Keys ( '+
      '             AppYear             VARCHAR (4),   '+
      '             Name                VARCHAR (50),  '+
      '             CloudDir            VARCHAR (50),  '+
      '             CloudDataDir        VARCHAR (255), '+

      '             T1Key               VARCHAR (25),  '+
      '             T2Key               VARCHAR (25),  '+
      '             T3Key               VARCHAR (25),  '+
      '             T4Key               VARCHAR (25),  '+
      '             TFKey               VARCHAR (25),  '+
      '             FPKey               VARCHAR (25),  '+
      '             TRKey               VARCHAR (25),  '+
      '             S1Key               VARCHAR (25),  '+
      '             S2Key               VARCHAR (25),  '+
      '             CloudKey            VARCHAR (25),  '+

      '             DropBoxKey          VARCHAR (25),  '+
      '             AllowedApps         VARCHAR (255), '+

      '             PRIMARY KEY (AppYear, Name) ON CONFLICT REPLACE '+
      ' ) ';
    //20190306 Igor <<<
    ZQuery.ExecSQL;

    //20191015 Igor >>>
    ZQuery.SQL.Text :=
      ' CREATE TABLE IF NOT EXISTS BNLimited ( '+
      '             T2Key               VARCHAR (25),  '+
      '             Content             VARCHAR (1000), '+

      '             PRIMARY KEY (T2Key) ON CONFLICT REPLACE '+
      ' ) ';
    //20191015 Igor <<<
    ZQuery.ExecSQL;

    Q.SQL.Text := 'SELECT * FROM Clients WHERE Cloud = ''S'' OR Cloud = ''Y'' '; //20191015 Igor //20191021 Igor
    Q.Open;
    while not Q.Eof do
    begin
      ZQuery.Close;
      ZQuery.SQL.Text := 'SELECT * FROM Keys WHERE AppYear = :Year AND Name = :Name';
      ZQuery.ParamByName('Year').Value := '2020';
      ZQuery.ParamByName('Name').Value := Q.FieldByName('NAME').AsString;
      ZQuery.Open;
      if ZQuery.RecordCount = 0 then
      begin
         ZQuery.Append;
         ZQuery.FieldByName('AppYear').AsString := '2020';
         ZQuery.FieldByName('Name').AsString := Q.FieldByName('NAME').AsString;
      end
      else
        ZQuery.Edit;
      ZQuery.FieldByName('CloudDir').AsString := Q.FieldByName('CLOUDDIR').AsString;
      ZQuery.FieldByName('CloudDataDir').AsString :=Q.FieldByName('CLOUDDATAD').AsString; //20191101 CON  renamed the dbf CloudDataDIR to CloudDataD
      //Q.FieldByName('CLOUDDATADIR').AsString; //20190213 Igor

      ZQuery.FieldByName('T1Key').AsString := Q.FieldByName('T1KEY').AsString;
      ZQuery.FieldByName('T2Key').AsString := Q.FieldByName('T2KEY').AsString;
      ZQuery.FieldByName('T3Key').AsString := Q.FieldByName('T3KEY').AsString;
      ZQuery.FieldByName('T4Key').AsString := Q.FieldByName('T4KEY').AsString;
      ZQuery.FieldByName('TFKey').AsString := Q.FieldByName('TFKEY').AsString;
      ZQuery.FieldByName('FPKey').AsString := Q.FieldByName('FPKEY').AsString;
      ZQuery.FieldByName('TRKey').AsString := Q.FieldByName('TRKEY').AsString;
      ZQuery.FieldByName('S1Key').AsString := Q.FieldByName('S1KEY').AsString;
      ZQuery.FieldByName('S2Key').AsString := Q.FieldByName('S2KEY').AsString;
      ZQuery.FieldByName('CloudKey').AsString := Q.FieldByName('CLOUDKEY').AsString;
      //20190306 Igor >>>
      ZQuery.FieldByName('DropBoxKey').AsString := Q.FieldByName('DROPBOXKEY').AsString;
      ZQuery.FieldByName('AllowedApps').AsString := GetAllowedApps(Q);
      //20190306 Igor <<<
      //20191015 Igor >>>
      //If Q.FieldByName('Cloud').AsString='S' then   //20190112 CON
      ZQuery.Post;
      if IsLimited(Q.FieldByName('T2').AsString) then //20191021 Igor
      begin
        BN := TBNList.Create;
        try
          for I := 1 to 6 do
          begin
            if (Q.FieldByName('LimBN' + IntToStr(I)).AsString = '')
               or
               (Q.FieldByName('LimYE' + IntToStr(I)).AsString = '') then continue;
            BN.Add(Q.FieldByName('LimBN' + IntToStr(I)).AsString + '=' + Q.FieldByName('LimYE' + IntToStr(I)).AsString);
          end;
          ZQuery.Close;
          ZQuery.SQL.Text := 'SELECT * FROM BNLimited WHERE T2Key = :T2Key';
          ZQuery.ParamByName('T2Key').Value := Q.FieldByName('T2Key').AsString;
          ZQuery.Open;
          if ZQuery.RecordCount = 0 then
          begin
            ZQuery.Append;
            ZQuery.FieldByName('T2Key').AsString := Q.FieldByName('T2Key').AsString;
          end
          else
            ZQuery.Edit;
          ZQuery.FieldByName('Content').AsString := BN.EncryptedText;
          ZQuery.Post;
        finally
          BN.Free;
        end;
      end;
      //20191015 Igor <<<
      Q.Next;
    end;
  finally
    Q.Close; Q.Free;
    ZQuery.Close; ZQuery.Free;
    ZConn.Disconnect; ZConn.Free;
  end;
  ShowMessage('Keys were successfully exported!');
end;

procedure TClients.btnGenerateLimitedBNClick(Sender: TObject); //20191015 Igor
begin
  if SaveLimitedBNDialog.Execute then
    if GenerateLimitedBN(SaveLimitedBNDialog.FileName, false) then
      ShowMessage('LimitedBN.D was generated successfully');  
end;

function TClients.GenerateLVerf(AFileName: string; ASilent: boolean = true): boolean;
var LicenseList: TLicenseList;
begin
  Result := false;
  if AFileName = '' then
    AFileName := ExtractFilePath(ParamStr(0)) + SaveToSubFolder + '\LVerf.EX_';
  if Query1.RecordCount = 0 then
  begin
    if not ASilent then
      ShowMessage('There is nothing to generate');
    Exit;
  end;
  LicenseList := TLicenseList.Create;
  try
    if Query1.FieldByName('T1Key').AsString <> '' then
      LicenseList.Keys['T1-2020'] := Query1.FieldByName('T1Key').AsString;
    if Query1.FieldByName('T2Key').AsString <> '' then
      LicenseList.Keys['T2-2021'] := Query1.FieldByName('T2Key').AsString;
    if Query1.FieldByName('T3Key').AsString <> '' then
      LicenseList.Keys['T3-2020'] := Query1.FieldByName('T3Key').AsString;
    if Query1.FieldByName('T4Key').AsString <> '' then
      LicenseList.Keys['T4T5-2020'] := Query1.FieldByName('T4Key').AsString;
    if Query1.FieldByName('TFKey').AsString <> '' then
      LicenseList.Keys['TF-2020'] := Query1.FieldByName('TFKey').AsString;
    if Query1.FieldByName('FPKey').AsString <> '' then
      LicenseList.Keys['FP-2021'] := Query1.FieldByName('FPKey').AsString;
    if Query1.FieldByName('S1Key').AsString <> '' then
      LicenseList.Keys['S1-2020'] := Query1.FieldByName('S1Key').AsString;
    if Query1.FieldByName('S2Key').AsString <> '' then
      LicenseList.Keys['S2-2020'] := Query1.FieldByName('S2Key').AsString;
    LicenseList.Save;
  finally
    LicenseList.Free;
  end;
  Result := true;  
end;

procedure TClients.btnGenerateLVerfEx_Click(Sender: TObject);
begin
  if SaveLVerfDialog.Execute then
    if GenerateLVerf(SaveLVerfDialog.FileName, false) then
      ShowMessage('LVerf.EX_ was generated successfully');
end;

function TClients.GenerateLimitedBN(AFileName: string; ASilent: boolean = true): boolean;
var I: integer;
    bHasBN: boolean;
    BN: TBNList;
begin
  Result := false;
  if AFileName = '' then
    AFileName := ExtractFilePath(ParamStr(0)) + SaveToSubFolder + '\LimitedBN.D';
  if not IsLimited(Query1.FieldByName('T2').AsString) then //20191021 Igor
  begin
    if not ASilent then
      ShowMessage('LimitedBN.D file can be generated only for T2 Limited');
    Exit;
  end;
  bHasBN := false;
  for I := 1 to 6 do
  begin
    if (Query1.FieldByName('LimBN' + IntToStr(I)).AsString <> '')
       and
       (Query1.FieldByName('LimYE' + IntToStr(I)).AsString = '') then
    begin
      ShowMessage('LimYE' + IntToStr(I) + 'should not be empty');
      Exit;
    end;
    if (Query1.FieldByName('LimBN' + IntToStr(I)).AsString <> '') then
      bHasBN := true;
  end;
  if not bHasBN then
  begin
    if not ASilent then
      ShowMessage('You need to specify at least one LimBN');
    Exit;
  end;
  BN := TBNList.Create;
  try
    for I := 1 to 6 do
    begin
      if (Query1.FieldByName('LimBN' + IntToStr(I)).AsString = '') then continue;
      BN.Add(Query1.FieldByName('LimBN' + IntToStr(I)).AsString + '=' + Query1.FieldByName('LimYE' + IntToStr(I)).AsString);
    end;
    BN.SaveToFile(AFileName);
  finally
    BN.Free;
  end;
  Result := true;  
end;

procedure TClients.GenSalDivKeyBtnClick(Sender: TObject);
Var Alist:TstringList;
FlName,SalDivKey:String;
SomeSubject,SomeText:String;
SomeAttachments:String;
EmailAddress:String;
Dir:String;
begin
 EmailAddress:=Query1.FieldByName('Email').AsString;
 SalDivKey:=GenSalDivKey;
 ShowMessage('SalDiv key is '+SaldivKey);
 Alist:=TstringList.create;
 Alist.Add(SalDivKey);
 Dir:='C:/Test1';
 If Not DirectoryExists(Dir) then ForceDirectories(Dir);
 FlName:=Dir+'/'+'T2SpecialFeatures.txt';
 Alist.SavetoFile(FLName);
 AList.free;

 // generate and attach files
 //cLVerf := ExtractFilePath(ParamStr(0)) + SaveToSubFolder + '\LVerf.EX_';
 // cLimitedBN := ExtractFilePath(ParamStr(0)) + SaveToSubFolder + '\LimitedBN.D';
  SomeSubject:='Special Features (Salary-Dividends-SBD) Activation key';
  SomeAttachments:='';
  if SomeAttachments <> '' then SomeAttachments := SomeAttachments + #13#10;
  SomeAttachments := SomeAttachments + FlName;
  SomeText:='Please SAVE the attached file into your C:/VT-2019/T2-2020 Folder to activate special T2 features';
  if SendMapiMail(SomeSubject,SomeText,SomeAttachments,'','','',EmailAddress) = 0 then
   //ok
  Else
  Begin
   ShowMessage('Email Failed. Attach '+FlName
         +Chr(13)+'manually and Email it to '+EmailAddress);
    Exit;
  end;
end;


Function TClients.GenSalDivKey:String;  //20200902
Var T2LicenseKey:String; Prp_Name:String;
FirstLetter,SecondLetter,ThirdLetter:String;
Begin
 //T2LicenseKey:=Query1.FieldByName('T2Key').AsString;
 Prp_Name:=Query1.FieldByName('NAME').AsString;
 FirstLetter :=LeftStr(Prp_Name, 1);
 SecondLetter:=MidStr(Prp_Name, 2, 1);
 ThirdLetter :=MidStr(Prp_Name, 3, 1);
 Result:=UpperCase(ThirdLetter + 'SALDIV' + SecondLetter + FirstLetter);  //20200910
 //Result:=UpperCase(ThirdLetter + MidStr(T2LicenseKey,6,4) + SecondLetter + FirstLetter);
End;




end.




