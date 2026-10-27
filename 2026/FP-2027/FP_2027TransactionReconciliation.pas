unit FP_2027TransactionReconciliation;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,FP_2027Declare,Db,ExtCtrls,ComCtrls, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef,
  uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet;

 Const BufferSize=660;

 type
 AHdrRec = record
   RecordId           : string; //[6];
   Supplier           : string; //[3];
   DealerCode         : string; //[4];
   IntermediaryCode   : string; //[4];
   DateCreated        : string; //[8];
   EffectiveDate      : string; //[8];
   FileType           : string; //[3];
   PeriodStartDate    : string; //[8];
   PeriodEndDate      : string; //[8];
   FundCoSpecific     : string; //[3];
   Version            : string; //[6];
   {Filler             : string; //[599];}
 end;

 type
 ADtlRec = record
   RecordId                 : string; //[6];
   SeqNo                    : string; //[8];
   ProductNo                : string; //[5];
   Account                  : string; //[15];
   AgentCode                : string; //[5];
   ShareHolderRegistration  : string; //[80];
   DealerAccount            : string; //[15];
   BenefLastName            : string; //[20];
   BenefFirstName           : string; //[20];
   AccountDesignation       : string; //[1];
   AccountType              : string; //[2];
   AccountStatus            : string; //[1];
   RecordType               : string; //[3];
   TransactionType          : string; //[1];
   TransactionTypeDetail    : string; //[1];
   ProductEvent             : string; //[1];
   ContributionCode         : string; //[1];
   TradeDate                : string; //[8];
   SettlementDate           : string; //[8];
   SettlementStatus         : string; //[1];
   OrderId                  : string; //[7];
   TransactionSource {?}    : string; //[1];
   WireOrderStatus  {?}     : string; //[1];
   Certificate              : string; //[1];
   OtherDealer {?}          : string; //[4];
   OtherFundId              : string; //[5];
   OtherFundAccount         : string; //[15];
   OtherDealerAccount       : string; //[15];
   PosNegIndicator          : string; //[1];
   GrossAmount              : string; //[11];
   ClientCommission         : string; //[5];
   FundCoHoldBack           : string; //[10];
   DealerCommission {?}     : string; //[10];
   FundPaidCommission       : string; //[5];
   FundCoHoldBack2          : string; //[10];{twice as above}
   DealerCommission2        : string; //[10];{twice as above}
   Fees                     : string; //[10];
   GST                      : string; //[10];
   DSC                      : string; //[10];
   WithHoldingTax1          : string; //[10];
   WithHoldingTax2          : string; //[10];
   NetAmount                : string; //[11];
   SettlementAmount  {?}    : string; //[11];
   UnitPrice                : string; //[7];
   UnitsTransacted          : string; //[13];
   TotalIssuedAssigned      : string; //[13];
   TotalUnissuedUnassigned  : string; //[13];
   Currency                 : string; //[2];
   OriginatorTransactionId  : string; //[15];
   FundCoSpecific1          : string; //[3];
   ProspectusIndicator      : string; //[1];
   IntermediaryCode         : string; //[4];
   IntermediaryAccount      : string; //[15];
   LockedIn                 : string; //[1];
   SettlementMethod         : string; //[1];
   SettlementSource         : string; //[1];
   OrderType                : string; //[1];
   BenefSIN                 : string; //[9];
   Supplier                 : string; //[3];
   DealerCode               : string; //[4];
   FundCoSpecific           : string; //[45];
   TaxCode                  : string; //[3];

   SourceId                 : string; //[15]; {my transaction id}
   DividendOption           : string; //[1];
   GrossNetPurchase         : string; //[1];
   TaxableEvent             : string; //[1];
   CSSDilutionAmount        : string; //[11];
   CSSMMInterestCharge      : string; //[11];
   MultiLineRecordNo        : string; //[2];
   CSSTransRevisionNo       : string; //[2];
   OrderSource              : string; //[1];
   MultiLineTotRecords      : string; //[2];
   ReturnCode               : string; //[2];
   ReturnCodeDetail         : string; //[3];
   ResponseSource           : string; //[1];
   SuppressConfirmation     : string; //[1];
   AvgCostDealer            : string; //[7];
   AvgCostFundCo            : string; //[7];
   OtherAccountDesignnation : string; //[1];
   OtherAccountType         : string; //[2];
   SysPlanIndicator         : string; //[1];
   ProcessingDate           : string; //[8];
   GroupFlag                : string; //[1];
   SpousalAccountFlag       : string; //[1];
   ContributionPeriod       : string; //[1];
   AltPayee                 : string; //[1];
   AltDelivery              : string; //[1];
   OtherIntermediaryAccount : string; //[15];
   OtherSpousalAccountFlag  : string; //[1];
   OtherGroupFlag           : string; //[1];
   GrossNetRedemption       : string; //[1];
   OtherIntermediaryCode    : string; //[4];
   ExchangeRate             : string; //[8];
   Filler                   : string; //[6];
 end;

 type
 ATrlRec = record
   RecordId                 : string; //[6];
   RecordCount              : string; //[9];
   {Filler                   : string; //[645];}
 end;


type
  TTransactionReconciliationFP_2012 = class(TForm)
    CancelBtn: TBitBtn;
    OkBtn: TBitBtn;
    ListBox1: TListBox;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    Panel3: TPanel;
    Memo1: TMemo;
    Label3: TLabel;
    ProgressBar1: TProgressBar;
    DataSource4: TDataSource;
    ProcessLbl: TLabel;
    AddDealerTransBox: TCheckBox;
    Panel1: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    ThisLastNameBox: TEdit;
    ThisFirstNameBox: TEdit;
    ShowMissingAgentsBtn: TBitBtn;
    ClientsTbl: TADTable;
    FDConnection: TADConnection;
    TransactionsTbl: TADTable;
    AccountsTbl: TADTable;
    AgentsTbl: TADTable;
    procedure CancelBtnClick(Sender: TObject);
    {Procedure BreakTheRec(ARec:String);}
    Procedure PrepareHdrRec;
    Procedure PrepareDtlRec;
    Procedure PrepareTrlRec;
    procedure FormCreate(Sender: TObject);
    Procedure OpenTables;
    Procedure CloseTables;
    {Function AccountExists(ASupplier,AClientId,AnAccount:String):Boolean;}
    Function TransactionExists(ATransactionId:String):Boolean;
    Procedure AddClient;
    {Procedure AddAccount;}
    Procedure AddTransaction;
    Procedure UpdateTransaction(TransId:String);
    Procedure GetAgentsInFile(Var AgentList:TStringList);
    Procedure GetMissingAgents(Var AgentList:TStringList;Var MissingAgents:TStringList);
    procedure OkBtnClick(Sender: TObject);
    Function GetNumbRecords(FileName:String):Integer;
    Function GetLastTransactionNo(Agent:String):Integer;
    Function SaveLastTransactionNo(Agent:String;TransactionNo:Integer):Boolean;
    {Procedure AddMissingAgents(Var MissingAgents:TStringList);}
    procedure ShowMissingAgentsBtnClick(Sender: TObject);
    procedure CheckAgents;
  private
    { Private declarations }
  public
    FileName: string; //???
  end;

var
  TransactionReconciliation: TTransactionReconciliationFP_2012;
  BufferRec : AnsiString;
  HdrRec : AHdrRec;
  DtlRec : ADtlRec;
  TrlRec : ATrlRec;
  FlName : String;
  MissingAgents:TStringList;
  RecNumber:Integer;
  AddedCnt,UpdatedCnt:Integer;
  StartedProcess: Boolean;

implementation

{$R *.DFM}

uses
  FP_2027TrimStr,
{$IFDEF ADO}
  FP_2012ImportFSFiles,
{$ELSE}
{$ENDIF}
  vtTrimStr;


procedure TTransactionReconciliationFP_2012.FormCreate(Sender: TObject);
begin
   StartedProcess := False;
   OpenTables;
   CheckAgents;
end;

procedure TTransactionReconciliationFP_2012.CheckAgents;
Var
  i,K:Integer;  AFile : TextFile;
  Dt:string; //[10];
  AgentList:TstringList;
begin
  AddedCnt:=0;
  UpdatedCnt:=0;
  AgentList := TStringList.Create;
  MissingAgents := TStringList.Create;
  AgentList.Sorted := True;
  GetAgentsInFile(AgentList);
  GetMissingAgents(AgentList,MissingAgents);
  AgentList.Clear;
  If MissingAgents.Count >0 then
  begin
    ListBox1.Clear;
    ListBox1.Items.Add('The following Agent Codes must first be added to the data base');
    ListBox1.Items.Add('==============================================================');
    For i:=0 to MissingAgents.Count-1 do
      ListBox1.Items.Add(MissingAgents[i]);
   end;
  AgentList.Free;
  ListBox1.Items.Add('Click on START. Processing may take several minutes. Please wait');
  ListBox1.Refresh;
end;

(*
Procedure TTransactionReconciliation.AddMissingAgents(Var MissingAgents:TStringList);
Var i:Integer; AddedCnt:Integer;
begin
 EXIT;
 
 AddedCnt:=0;
 With AgentsTbl do
 begin
   If Active then Close;
   Open;
   IndexFieldNames := 'AgentCode';
   For i:=0 to MissingAgents.Count-1 do
   begin
    If Not FindKey([MissingAgents[i]]) then
    begin
      Insert;
      FieldByName('AgentCode').AsString :=AllTrim(MissingAgents[i]);
      FieldByName('UserId').AsString    :=AllTrim(MissingAgents[i]);
      FieldByName('Branch').AsString    :='MAIN';
      FieldByName('BranchPassword').AsString :=AllTrim(MissingAgents[i]);
      FieldByName('LastName').AsString:=AllTrim(MissingAgents[i]);
      FieldByName('FirstName').AsString:=AllTrim(MissingAgents[i]);
      Post;
      Inc(AddedCnt);
    end;
   end; {i}
 end; {end with}
 If AddedCnt = MissingAgents.Count then MissingAgents.Clear;
end;
*)
Procedure TTransactionReconciliationFP_2012.OpenTables;
begin
 If Not ClientsTbl.Active then ClientsTbl.Open;
 ClientsTbl.IndexFieldNames := 'ClientId';
 If Not AccountsTbl.Active then AccountsTbl.Open;
 AccountsTbl.IndexFieldNames := 'ClientId';
 If Not TransactionsTbl.Active then TransactionsTbl.Open;
 TransactionsTbl.IndexFieldNames := 'TransactionId';
 If Not AgentsTbl.Active then AgentsTbl.Open;
 AgentsTbl.IndexFieldNames := 'AgentCode';
end;

Procedure TTransactionReconciliationFP_2012.CloseTables;
begin
 If ClientsTbl.Active then ClientsTbl.Close;
 If AccountsTbl.Active then AccountsTbl.Close;
 If TransactionsTbl.Active then TransactionsTbl.Close;
 If AgentsTbl.Active then AgentsTbl.Close;
end;

procedure TTransactionReconciliationFP_2012.CancelBtnClick(Sender: TObject);
begin
If StartedProcess = False then FileName :=''; {to avoid archiving}
MissingAgents.Free;
CloseTables;
Close;
end;

procedure TTransactionReconciliationFP_2012.OkBtnClick(Sender: TObject);
Var AFile : TextFile;NumbRecords:Integer;
begin

  If MissingAgents.Count >0 then
  begin
   ShowMessage('Missing agents must be added before processing');
   FileName :=''; {to avoid archive after exit}
   exit;
  end;
  StartedProcess := True;
  NumbRecords:=GetNumbRecords(FileName);
  {RecNumber:=0;}
  progressbar1.Min :=0;
  progressbar1.Max :=NumbRecords;
  progressbar1.Position := 0;

  Screen.Cursor := crHourGlass;
  BufferRec := StringOfChar(' ', BufferSize);

  AssignFile(AFile,FileName);
  Reset(AFile);
  Repeat
   ReadLn(AFile,BufferRec);
   If (LeftStr(BufferRec,6) = 'SETHDR')
   OR (LeftStr(BufferRec,6) = 'COFHDR') then
      PrepareHdrRec
   Else If LeftStr(BufferRec,6) = 'SETDTL' then PrepareDtlRec
   Else If LeftStr(BufferRec,6) = 'COFDTL' then PrepareDtlRec;
  { Else If LeftStr(BufferRec,6) = '   DTL' then PrepareDtlRec;} {triH wrong}
  until Eof(AFile);
  CloseFile(AFile);
  Screen.Cursor := crDefault;

  ShowMessage('Transactions added '+IntToStr(AddedCnt)+
  Chr(13)+'Transactions updated '+IntToStr(UpdatedCnt));
  CancelBtnClick(Sender);
end;



Procedure TTransactionReconciliationFP_2012.PrepareHdrRec;
begin
 With HdrRec do
 begin
   RecordId           := BigMidStr(BufferRec,1,6);
   Supplier           := BigMidStr(BufferRec,7,3);
   DealerCode         := BigMidStr(BufferRec,10,4);
   IntermediaryCode   := BigMidStr(BufferRec,14,4);
   DateCreated        := BigMidStr(BufferRec,18,8);
   EffectiveDate      := BigMidStr(BufferRec,26,8);
   FileType           := BigMidStr(BufferRec,34,3);
   PeriodStartDate    := BigMidStr(BufferRec,37,8);
   PeriodEndDate      := BigMidStr(BufferRec,45,8);
   FundCoSpecific     := BigMidStr(BufferRec,53,3);
   Version            := BigMidStr(BufferRec,56,6);
 end;
 (*
 With HdrRec do
 begin
  FromDtBox.Text := PeriodStartDate;
  ToDtBox.Text := PeriodEndDate;
 end;
 *)
end;

Procedure TTransactionReconciliationFP_2012.PrepareDtlRec;
begin
 Progressbar1.Position := progressbar1.Position+1;
 {ProgressBar1.Refresh;}
 With DtlRec do
 begin
   RecordId                 := BigMidStr(BufferRec,1,6);
   SeqNo                    := BigMidStr(BufferRec,7,8);
   ProductNo                := BigMidStr(BufferRec,15,5);
   Account                  := BigMidStr(BufferRec,20,15);
   AgentCode                := BigMidStr(BufferRec,35,5);
   ShareHolderRegistration  := BigMidStr(BufferRec,40,80);
   DealerAccount            := BigMidStr(BufferRec,120,15);
   BenefLastName            := BigMidStr(BufferRec,135,20);
   BenefFirstName           := BigMidStr(BufferRec,155,20);
   AccountDesignation       := BigMidStr(BufferRec,175,1);
   AccountType              := BigMidStr(BufferRec,176,2);
   AccountStatus            := BigMidStr(BufferRec,178,1);
   RecordType               := BigMidStr(BufferRec,179,3);
   TransactionType          := BigMidStr(BufferRec,182,1);
   TransactionTypeDetail    := BigMidStr(BufferRec,183,1);
   ProductEvent             := BigMidStr(BufferRec,184,1);
   ContributionCode         := BigMidStr(BufferRec,185,1);
   TradeDate                := BigMidStr(BufferRec,186,8);
   SettlementDate           := BigMidStr(BufferRec,194,8);
   SettlementStatus         := BigMidStr(BufferRec,202,1);
   OrderId                  := BigMidStr(BufferRec,203,7);
   TransactionSource {?}    := BigMidStr(BufferRec,210,1);
   WireOrderStatus  {?}     := BigMidStr(BufferRec,211,1);
   Certificate              := BigMidStr(BufferRec,212,1);
   OtherDealer {?}          := BigMidStr(BufferRec,213,4);
   OtherFundId              := BigMidStr(BufferRec,217,5);
   OtherFundAccount         := BigMidStr(BufferRec,222,15);
   OtherDealerAccount       := BigMidStr(BufferRec,237,15);
   PosNegIndicator          := BigMidStr(BufferRec,252,1);
   GrossAmount              := BigMidStr(BufferRec,253,11);
   ClientCommission         := BigMidStr(BufferRec,264,5);
   FundCoHoldBack           := BigMidStr(BufferRec,269,10);
   DealerCommission {?}     := BigMidStr(BufferRec,279,10);
   FundPaidCommission       := BigMidStr(BufferRec,289,5);
   FundCoHoldBack2          := BigMidStr(BufferRec,294,10);{twice as above}
   DealerCommission2        := BigMidStr(BufferRec,304,10);{twice as above}
   Fees                     := BigMidStr(BufferRec,314,10);
   GST                      := BigMidStr(BufferRec,324,10);
   DSC                      := BigMidStr(BufferRec,334,10);
   WithHoldingTax1          := BigMidStr(BufferRec,344,10);
   WithHoldingTax2          := BigMidStr(BufferRec,354,10);
   NetAmount                := BigMidStr(BufferRec,364,11);
   SettlementAmount  {?}    := BigMidStr(BufferRec,375,11);
   UnitPrice                := BigMidStr(BufferRec,386,7);
   UnitsTransacted          := BigMidStr(BufferRec,393,13);
   TotalIssuedAssigned      := BigMidStr(BufferRec,406,13);
   TotalUnIssuedUnassigned  := BigMidStr(BufferRec,419,13);
   Currency                 := BigMidStr(BufferRec,432,2);
   OriginatorTransactionId  := BigMidStr(BufferRec,434,15);
   FundCoSpecific1          := BigMidStr(BufferRec,449,3);
   ProspectusIndicator      := BigMidStr(BufferRec,452,1);
   IntermediaryCode         := BigMidStr(BufferRec,453,4);
   IntermediaryAccount      := BigMidStr(BufferRec,457,15);
   LockedIn                 := BigMidStr(BufferRec,472,1);
   SettlementMethod         := BigMidStr(BufferRec,473,1);
   SettlementSource         := BigMidStr(BufferRec,474,1);
   OrderType                := BigMidStr(BufferRec,475,1);
   BenefSIN                 := BigMidStr(BufferRec,476,9);
   Supplier                 := BigMidStr(BufferRec,485,3);
   DealerCode               := BigMidStr(BufferRec,488,4);
   FundCoSpecific           := BigMidStr(BufferRec,492,45);
   TaxCode                  := BigMidStr(BufferRec,537,3);

   SourceId                 := BigMidStr(BufferRec,540,15);
   DividendOption           := BigMidStr(BufferRec,555,1);
   GrossNetPurchase         := BigMidStr(BufferRec,556,1);
   TaxableEvent             := BigMidStr(BufferRec,557,1);
   CSSDilutionAmount        := BigMidStr(BufferRec,558,11);
   CSSMMInterestCharge      := BigMidStr(BufferRec,569,11);
   MultiLineRecordNo        := BigMidStr(BufferRec,580,2);
   CSSTransRevisionNo       := BigMidStr(BufferRec,582,2);
   OrderSource              := BigMidStr(BufferRec,584,1);
   MultiLineTotRecords      := BigMidStr(BufferRec,585,2);
   ReturnCode               := BigMidStr(BufferRec,587,2);
   ReturnCodeDetail         := BigMidStr(BufferRec,589,3);
   ResponseSource           := BigMidStr(BufferRec,592,1);
   SuppressConfirmation     := BigMidStr(BufferRec,593,1);
   AvgCostDealer            := BigMidStr(BufferRec,594,7);
   AvgCostFundCo            := BigMidStr(BufferRec,601,7);
   OtherAccountDesignnation := BigMidStr(BufferRec,608,1);
   OtherAccountType         := BigMidStr(BufferRec,609,2);
   SysPlanIndicator         := BigMidStr(BufferRec,611,1);
   ProcessingDate           := BigMidStr(BufferRec,612,8);
   GroupFlag                := BigMidStr(BufferRec,620,1);
   SpousalAccountFlag       := BigMidStr(BufferRec,621,1);
   ContributionPeriod       := BigMidStr(BufferRec,622,1);
   AltPayee                 := BigMidStr(BufferRec,623,1);
   AltDelivery              := BigMidStr(BufferRec,624,1);
   OtherIntermediaryAccount := BigMidStr(BufferRec,625,15);
   OtherSpousalAccountFlag  := BigMidStr(BufferRec,640,1);
   OtherGroupFlag           := BigMidStr(BufferRec,641,1);
   GrossNetRedemption       := BigMidStr(BufferRec,642,1);
   OtherIntermediaryCode    := BigMidStr(BufferRec,643,4);
   ExchangeRate             := BigMidStr(BufferRec,647,8);
   Filler                   := BigMidStr(BufferRec,655,6);
 end;

 If (ThisLastNameBox.Text >'') and (ThisFirstNameBox.Text>'') then
 begin
   With DtlRec do
   begin
    If (Uppercase(AllTrim(BenefLastName)) = UpperCase(AllTrim(ThisLastNameBox.Text)))
    and (Uppercase(AllTrim(BenefFirstName)) = UpperCase(AllTrim(ThisFirstNameBox.Text)))
   then
   {}
   else
    exit;
   end;
 end;

 With DtlRec do
 begin
  ProcessLbl.Caption:='Processing '+AllTrim(BenefLastName) +','+AllTrim(BenefFirstName)
    +' - '+AllTrim(Supplier)+AllTrim(ProductNo);
  ProcessLbl.Refresh;
 end;

 FlName:= DtlRec.BenefSin+'-'+'000';

 {
 If not ClientsTbl.FindKey([FlName]) then
  ShowMessage('Client'+FlName+' must be added after processing');
 }
 
 If not ClientsTbl.FindKey([FlName]) then
    AddClient;
 {
 If not AccountExists(DtlRec.Supplier,FlName,AllTrim(DtlRec.Account)) then
    AddAccount;
 }
 If not TransactionExists(AllTrim(DtlRec.SourceId)) then
 begin
  If (AllTrim(DtlRec.SettlementSource) <> 'D')
  or (AddDealerTransBox.Checked) then AddTransaction
 end
 else
    UpdateTransaction(AllTrim(DtlRec.SourceId));
end;

(*
Function TTransactionReconciliation.AccountExists(ASupplier,AClientId,AnAccount:String):Boolean;
begin
 Result := False;
 With AccountsTbl do
 begin
  First;
  Repeat
    If (FieldByName('Supplier').AsString = ASupplier)
    and (FieldByName('ClientId').AsString = AClientId)
    and (FieldByName('Account').AsString = AnAccount) then
    begin Result := True;Exit;end;
    Next;
  until AccountsTbl.Eof;
 end;
end;
*)
Function TTransactionReconciliationFP_2012.TransactionExists(ATransactionId:String):Boolean;
begin
 Result := False;
 If TransactionsTbl.FindKey([ATransactionId]) then result := True;
end;

(*
Procedure TTransactionReconciliation.AddAccount;
begin
Try
 With AccountsTbl do
 begin
  Insert;
  FieldByName('ClientId').AsString    := FlName;
  FieldByName('Supplier').AsString    := AllTrim(DtlRec.Supplier);
  FieldByName('Account').AsString     := AllTrim(DtlRec.Account);
  FieldByName('AccountType').AsString := ConvertAccountTypeCodeToDescr(AllTrim(DtlRec.AccountType));
  FieldByName('AgentCode').AsString   := AllTrim(DtlRec.AgentCode);
  FieldByName('IntermediaryCode').AsString   := AllTrim(DtlRec.IntermediaryCode);
  FieldByName('IntermediaryAccount').AsString   := AllTrim(DtlRec.IntermediaryAccount);
  FieldByName('DateCreated').AsString  := FormatDateTime('yyyy-mm-dd',Now);
  FieldByName('LastUpdate').AsString   := FormatDateTime('yyyy-mm-dd',Now);
  Post;
 end;
 except
  on E: Exception do MessageDlg('Adding Account '+E.Message, mtError, [mbok], 0);
   {ListBox1.Items.Add('Account add problem in Record: '+ BigMidStr(BufferRec,1,150));}
 end; {Try}
end;
*)
Procedure TTransactionReconciliationFP_2012.AddClient;
begin
 With DtlRec Do
 begin
   ClientsTbl.Insert;
   Try
    ClientsTbl.FieldByName('ClientId').AsString  := FlName;
    ClientsTbl.FieldByName('LastName').AsString  := BenefLastName;
    ClientsTbl.FieldByName('FirstName').AsString := BenefFirstName;
    If (AllTrim(BenefLastName) ='')
    and (AccountDesignation = '1') then
    begin
      ClientsTbl.FieldByName('LastName').AsString  := LeftStr(ShareholderRegistration,20);
      ClientsTbl.FieldByName('FirstName').AsString  := MidStr(ShareholderRegistration,21,20);
    end;

    ClientsTbl.FieldByName('ClientStatus').AsString := 'Active';
    ClientsTbl.FieldByName('PlanStatus').AsString := 'WIP';
    {ClientsTbl.FieldByName('MarStatus').AsInteger := Ret[RetNo]^.MarStatus;}
    ClientsTbl.FieldByName('BirthDate').AsString  := '';
    ClientsTbl.FieldByName('SIN').AsString        := BenefSIN;
    {
    ClientsTbl.FieldByName('PayInvoiceNo').AsString := FetchElm(RetNo,'Inv_2',10);
    ClientsTbl.FieldByName('PayType').AsString := '';
    If FetchElm(RetNo,'Inv_2',23) > '' then
       ClientsTbl.FieldByName('PayType').AsString := 'Cash'
    else If FetchElm(RetNo,'Inv_2',24) > '' then
          ClientsTbl.FieldByName('PayType').AsString := 'Cheque'
    else If FetchElm(RetNo,'Inv_2',25) > '' then
          ClientsTbl.FieldByName('PayType').AsString := 'Visa';

     If (FetchElm(RetNo,'Inv_2',23) > '') or
    (FetchElm(RetNo,'Inv_2',24) > '') or
   (FetchElm(RetNo,'Inv_2',25) > '')  then
   ClientsTbl.FieldByName('PayAmount').AsFloat :=
     vl(FetchElm(RetNo,'Inv_2',22))
   Else
    ClientsTbl.FieldByName('PayAmount').AsFloat := 0;
    ClientsTbl.FieldByName('Street').AsString := FetchElm(RetNo,FirstFormName,5);
    ClientsTbl.FieldByName('City').AsString := FetchElm(RetNo,FirstFormName,6);
    ClientsTbl.FieldByName('Province').AsString :=
      GetShortPrv(FetchElm(RetNo,FirstFormName,8));
    ClientsTbl.FieldByName('PostalCode').AsString := RemoveChar(FetchElm(RetNo,FirstFormName,12),' ');
    ClientsTbl.FieldByName('Phone').AsString := GetPhoneNo(RetNo);
    ClientsTbl.FieldByName('Fax').AsString := GetFaxNo(RetNo);
    ClientsTbl.FieldByName('EMail').AsString := GetEmailNo(RetNo);
    ClientsTbl.FieldByName('OfficeNo').AsString := GetOfficeNo(RetNo);
    }
    ClientsTbl.FieldByName('AgentCode').AsString := AgentCode;
    {
    ClientsTbl.FieldByName('Notes').AsString := FetchElm(RetNo,'STATUS',14);
     }
    ClientsTbl.FieldByName('LastUpdate').AsString :=FormatDateTime('yyyy-mm-dd',Now);

    ClientsTbl.FieldByName('UpdatedBy').AsString  :='FundServ';
    {
    If FetchElm(RetNo,'PROFILE',95) >'' then
       ClientsTbl.FieldByName('Gender').AsString :='M'
    else
       ClientsTbl.FieldByName('Gender').AsString :='F';
   }
  Memo1.Clear;
  Memo1.Lines.Add(AppName+Delimiter+AppYear+Delimiter+AppRelease+Delimiter+'a');
  Memo1.Lines.Add('F'+Delimiter+'PROFILE'+Delimiter+''+Delimiter+'');
  Memo1.Lines.Add('D'+Delimiter+'3'+Delimiter+DtlRec.BenefSin+Delimiter+'');
  Memo1.Lines.Add('D'+Delimiter+'1'+Delimiter+DtlRec.BenefFirstName+Delimiter+'');
  Memo1.Lines.Add('D'+Delimiter+'2'+Delimiter+DtlRec.BenefLastName+Delimiter+'');
  ClientsTbl.FieldByName('OtherData').Assign(Memo1.lines);

  ClientsTbl.Post;
  except
   on E: Exception do MessageDlg('Adding Client '+E.Message, mtError, [mbok], 0);
   {ListBox1.Items.Add('Client add problem in Record: '+ BigMidStr(BufferRec,1,150));}
  end;
 end;
 ListBox1.Items.Add('Client added '+AllTrim(DtlRec.BenefLastName)+','+
              AllTrim(DtlRec.BenefFirstName));
 ListBox1.Refresh;
 Memo1.Clear;
end;

Procedure TTransactionReconciliationFP_2012.AddTransaction;
Var i,TransactionNo:Integer; TransId:String;
begin

 With TransactionsTbl do
 begin
  Try
   Insert;
   for I := 0 to TransactionsTbl.FieldCount - 1 do
   begin
     If Fields[I].DataType = ftString then  Fields[I].Value := ''
     else If Fields[I].DataType = ftFloat then  Fields[I].Value := 0.0
     else If Fields[I].DataType = ftInteger then  Fields[I].Value := 0
     else If Fields[I].DataType = ftCurrency then  Fields[I].Value := '$0';
   end;
   {Init some fields}
   FieldByName('FromFund').AsString := Space(1);
   FieldByName('FsToBranch').AsString := Space(1);
   FieldByName('DateCkSent').AsString := Space(1);
   FieldByName('DateCkReceived').AsString := Space(1);
   FieldByName('FsErrOrs').AsString := Space(1);
   {}
   TransactionNo:= GetLastTransactionNo(AllTrim(DtlRec.AgentCode))+1;
   TransId :=MakeTransactionId(GetBranchOfAgent(AllTrim(DtlRec.AgentCode)),AllTrim(DtlRec.AgentCode),TransactionNo);
   FieldByName('TransactionId').AsString :=TransId;
   FieldByName('ClientId').AsString := FlName;
   FieldByName('AgentCode').AsString := AllTrim(DtlRec.AgentCode);
   FieldByName('Supplier').AsString := DtlRec.Supplier;
   FieldByName('Account').AsString := DtlRec.Account;
   FieldByName('Product').AsString := DtlRec.Supplier+AllTrim(DtlRec.ProductNo);

   FieldByName('TransactionType').AsString := DtlRec.TransactionType;
   FieldByName('TransactionTypeDetail').AsString := DtlRec.TransactionTypeDetail;

   FieldByName('OrderSource').AsString   := DtlRec.OrderSource;
   FieldByName('OrderType').AsString     := DtlRec.OrderType;
   FieldByName('Status').AsString        := 'Settled';
   {? FieldByName('SourceOfFunds').AsString := DtlRec.SourceOfFunds;}
   {? FieldByName('ActionCode').AsString    := DtlRec.ActionCode;}
   {? FieldByName('WireOrderNo').AsString   := DtlRec.WireOrderNo;}
   FieldByName('GrossAmount').AsFloat      := Vl(DtlRec.GrossAmount)/100; {2 dec}
   FieldByName('NetAmount').AsFloat        := Vl(DtlRec.NetAmount)/100;   {2 dec}
   FieldByName('AmountType').AsString      := 'D'; {AmountType;}  {?}
   If GetTransactionSign(DtlRec.PosNegIndicator,
      DtlRec.TransactionType+DtlRec.TransactionTypeDetail) = '-' then
     FieldByName('Units').AsFloat   := -Vl(DtlRec.UnitsTransacted)/10000 {has 4 decimals}
   else
     FieldByName('Units').AsFloat   := Vl(DtlRec.UnitsTransacted)/10000; {has 4 decimals}
   FieldByName('FundPaidCommission').AsFloat := Vl(DtlRec.FundPaidCommission)/1000; {3 dec}
   {? FieldByName('Dsc_Rate').AsFloat       := Vl(DtlRec.Dsc_Rate)/100;} {2 dec}
   {? FieldByName('Fe_rate').AsFloat        := Vl(DtlRec.Fe_Rate)/100;} {2 dec}
   FieldByName('UnitPrice').AsFloat         := Vl(DtlRec.UnitPrice)/10000; {4 dec}
   FieldByName('WithHoldingTax').AsFloat    := Vl(DtlRec.WithHoldingTax1)/100; {2 dec}
   FieldByName('Fees').AsFloat              := Vl(DtlRec.Fees)/100; {2 dec}
   FieldByName('Dsc').AsFloat               := Vl(DtlRec.Dsc)/100; {2 dec}
   {? FieldByName('PaymentStatus').AsString := DtlRec.PaymentStatus;}
   {FieldByName('UserId').AsString           := DtlRec.UserId;}
   {? FieldByName('InternalExternal').AsString := DtlRec.InternalExternal;}
   FieldByName('TradeDate').AsString        := FormatFsDate(DtlRec.TradeDate);
   FieldByName('ProcessingDate').AsString   := FormatFsDate(DtlRec.ProcessingDate);
   FieldByName('ExchangeRate').AsFloat      := Vl(DtlRec.ExchangeRate)/1000000; {6 dec}
   FieldByName('ResponseSource').AsString   := DtlRec.ResponseSource;
   FieldByName('SettlementSource').AsString := DtlRec.SettlementSource;
   FieldByName('SettlementMethod').AsString := DtlRec.SettlementMethod;
   FieldByName('SettlementStatus').AsString := DtlRec.SettlementStatus;
   FieldByName('SettlementDate').AsString      := FormatFsDate(DtlRec.SettlementDate);
   FieldByName('ContributionPeriod').AsString := DtlRec.ContributionPeriod;
   FieldByName('ContributionCode').AsString := DtlRec.ContributionCode;
   FieldByName('Currency').AsString         := DtlRec.Currency;
   FieldByName('Certificate').AsString      := DtlRec.Certificate;
   FieldByName('DividendOption').AsString   := DtlRec.DividendOption;
   {??? from.... missing and others : see second page of transactions data elements}
   FieldByName('LockedIn').AsString         := DtlRec.LockedIn;
   FieldByName('ProductEvent').AsString     := DtlRec.ProductEvent;
   {? FieldByName('Confirmation').AsString  := Confirmation;}

   FieldByName('SysPlanIndicator').AsString := DtlRec.SysPlanIndicator;
   {othersysplan ?}
   {FieldByName('SysPlanAmount').AsFloat    := Vl(DtlRec.SysPlamAmount)/100;}
   {FieldByName('SysPlanComRate').AsFloat   := Vl(DtlRec.SysPlamComRate)/100;}

   FieldByName('GrossNetPurchase').AsString := DtlRec.GrossNetPurchase;
   FieldByName('GrossNetRedemption').AsString := DtlRec.GrossNetRedemption;
   FieldByName('ClientCommission').AsFloat  := Vl(DtlRec.ClientCommission)/1000; {3 dec}
   FieldByName('SourceId').AsString         := DtlRec.SourceId;
   FieldByName('OrderId').AsString          := DtlRec.OrderId;
   {? FieldByName('TransactionId').AsString    := DtlRec.TransactionId; DONE above}
   {? FieldByName('ClerkId').AsString       := DtlRec.ClerkId;}
   {? FieldByName('CSSActualDate').AsString := FormatFsDate(DtlRec.CssActualDate);}
   FieldByName('LastUpdate').AsString       := FormatDateTime('yyyy-mm-dd',Now);
   FieldByName('LastUpdateBy').AsString     := 'FUNDSERV';
   FieldByName('AccountType').AsString      := ConvertAccountTypeCodeToDescr(AllTrim(DtlRec.AccountType));
   FieldByName('DealerAccount').AsString    := DtlRec.DealerAccount;
   FieldByName('Branch').AsString           := GetBranchOfAgent(DtlRec.AgentCode);
   FieldByName('IntermediaryCode').AsString := DtlRec.IntermediaryCode;
   FieldByName('IntermediaryAccount').AsString :=DtlRec.IntermediaryAccount;
   FieldByName('OrderType').AsString        := DtlRec.OrderType;
   FieldByName('OrderDate').AsString        := FormatFsDate(DtlRec.TradeDate);

   {? FieldByName('EffectiveDate').AsString := FormatFsDate(DtlRec.EffectiveDate);}

   FieldByName('DateCreated').AsString      := FormatFsDate(DtlRec.TradeDate);
   Post;
   SaveLastTransactionNo(AllTrim(DtlRec.AgentCode),TransactionNo);
   Inc(AddedCnt);
  except
   on E: Exception do
   begin
    MessageDlg('Adding Transaction '+Chr(13)+E.Message, mtError, [mbok], 0);
    filename:='';
   end;
   {ListBox1.Items.Add('Transaction add problem in Record: '+ BigMidStr(BufferRec,1,150));}
  end; {try block}
 end; {with block}
end;


Procedure TTransactionReconciliationFP_2012.UpdateTransaction(TransId:String);
Var i,TransactionNo:Integer; {TransId:String;}
begin
 With TransactionsTbl do
 begin
  Try
   Edit;
   FieldByName('Status').AsString        := 'Settled';
   (*
   FieldByName('GrossAmount').AsFloat      := Vl(DtlRec.GrossAmount)/100; {2 dec}
   FieldByName('NetAmount').AsFloat        := Vl(DtlRec.NetAmount)/100;   {2 dec}
   FieldByName('Units').AsFloat            := Vl(DtlRec.UnitsTransacted)/10000; {has 4 decimals}
   FieldByName('UnitPrice').AsFloat         := Vl(DtlRec.UnitPrice)/10000; {4 dec}
   *)
   FieldByName('FundPaidCommission').AsFloat := Vl(DtlRec.FundPaidCommission)/1000; {3 dec}
   FieldByName('WithHoldingTax').AsFloat    := Vl(DtlRec.WithHoldingTax1)/100; {2 dec}
   FieldByName('Fees').AsFloat              := Vl(DtlRec.Fees)/100; {2 dec}
   FieldByName('Dsc').AsFloat               := Vl(DtlRec.Dsc)/100; {2 dec}
   FieldByName('TradeDate').AsString        := FormatFsDate(DtlRec.TradeDate);
   FieldByName('ProcessingDate').AsString   := FormatFsDate(DtlRec.ProcessingDate);
   FieldByName('ExchangeRate').AsFloat      := Vl(DtlRec.ExchangeRate)/1000000; {6 dec}
   FieldByName('LockedIn').AsString         := DtlRec.LockedIn;
   FieldByName('ProductEvent').AsString     := DtlRec.ProductEvent;
   FieldByName('ClientCommission').AsFloat  := Vl(DtlRec.ClientCommission)/1000; {3 dec}
   FieldByName('LastUpdate').AsString       := FormatDateTime('yyyy-mm-dd',Now);
   FieldByName('LastUpdateBy').AsString     := 'FundServ';
   FieldByName('SettlementDate').AsString   := FormatFsDate(DtlRec.SettlementDate);
   Post;
   Inc(UpdatedCnt);
  Except
   on E: Exception do MessageDlg('Updating Transaction '+E.Message, mtError, [mbok], 0);
   {ListBox1.Items.Add('Transaction update problem in Record: '+ BigMidStr(BufferRec,1,150));}
  end; {try block}
 end;  {with block}
end;

Procedure TTransactionReconciliationFP_2012.PrepareTrlRec;
begin
 With TrlRec do
 begin
  RecordId                 := MidStr(BufferRec,1,6);
  RecordCount              := MidStr(BufferRec,7,15);
 end;
end;

Procedure TTransactionReconciliationFP_2012.GetMissingAgents(Var AgentList:TStringList;Var MissingAgents:TStringList);
Var i:Integer;
begin
 MissingAgents.Clear;
 For i:=0 to AgentList.Count-1 do
  If AgentsTbl.FindKey([AllTrim(AgentList[i])]) = False then
    MissingAgents.Add(AgentList[i]);
end;

Procedure TTransactionReconciliationFP_2012.GetAgentsInFile(Var AgentList:TStringList);
Var
  AFile : TextFile;
  Agent :string; //[5];
begin
  AgentList.Clear;
  BufferRec := StringOfChar(' ', BufferSize);
  AssignFile(AFile,FileName);
  Reset(AFile);
  Repeat
   ReadLn(AFile,BufferRec);
   If (LeftStr(BufferRec,6) = 'SETDTL')
   or (LeftStr(BufferRec,6) = 'COFDTL')  then
   begin
    Agent := AllTrim(BigMidStr(BufferRec,35,5));
    If IsInList(Agent,AgentList) < 0 then  AgentList.Add(Agent);
   end;
  until Eof(AFile);
  CloseFile(AFile);
end;

Function TTransactionReconciliationFP_2012.GetNumbRecords(FileName:String):Integer;
Var Fb: File of byte;
Begin
 AssignFile(Fb, FileName);
 Reset(Fb);
 Result := FileSize(Fb) div BufferSize;
 CloseFile(Fb);
end;


Function TTransactionReconciliationFP_2012.GetLastTransactionNo(Agent:String):Integer;
begin
  Result :=-9999;
  With AgentsTbl do
  begin
    If not Active then Open;
    First;
    Repeat
     If AllTrim(FieldByName('AgentCode').AsString) = AllTrim(Agent) then
     begin
       result := FieldByName('LastTransactionNo').AsInteger;
       break;
     end;
     Next;
    until Eof;
  end;
end;

Function TTransactionReconciliationFP_2012.SaveLastTransactionNo(Agent:String;TransactionNo:Integer):Boolean;
begin
  Result := False;
  With AgentsTbl do
  begin
    If not Active then Open;
    First;
    Repeat
     If AllTrim(FieldByName('AgentCode').AsString) = Agent then
      begin
       Edit;
       FieldByName('LastTransactionNo').AsInteger:=TransactionNo;
       Post;
       Result := True;
       break;
      end;
      Next;
     until Eof;
  end;
end;

procedure TTransactionReconciliationFP_2012.ShowMissingAgentsBtnClick(Sender: TObject);
Var DefaultBranch,SelectedBranch:String;
begin
 {DefaultBranch := 'MAIN';}
 If MissingAgents.Count <1 then
 begin
  ShowMessage('The import file does not have any uknown agents');
  exit;
 end;
 (*
 SelectedBranch:= UpperCase(
   InputBox('Input Box', 'Enter branch for missing agents', DefaultBranch)
   );
 If Length(SelectedBranch) <> 4 then exit;
 {AddMissingAgents(MissingAgents);}
 ShowMessage('Done');
 *)
end;




(*
Procedure TFSReconciliation.BreakTheRec(ARec:String);
begin
{ If ARec.RecordId = 'SETHDR' then}

  {
   RecordID    :=MidStr(PriceRec,1,6);
   RecordType  :=MidStr(PriceRec,7,3);
   PriceStatus :=MidStr(PriceRec,10,1);
   Supplier    :=MidStr(PriceRec,11,3);
   FundNo      :=MidStr(PriceRec,14,5);
   PriceDate   :=MidStr(PriceRec,19,8);

   PriceRate   :=MidStr(PriceRec,27,11);
   PosNeg      :=MidStr(PriceRec,38,1);
   DistrPayDate:=MidStr(PriceRec,39,8);

   Currency    :=MidStr(PriceRec,47,2);
   If Currency='00' then Currency:='CN'
   else If Currency='01' then Currency:='US';

   CoSpecific  :=MidStr(PriceRec,49,3);
  }
end;
*)

(*
Procedure TFSReconciliation.InsertDataToBuffer(FromPos,Len:Integer; Valu:String);
Var i,j:Integer;
begin
 If Length(Valu) =0 then exit;
 If Len<256 then Valu := PaddR(Valu,Len); {else does not work}
 j:=FromPos;
 For i:= 1 to Length(Valu) do
   begin
    BufferRec[j] := Valu[i];
    Inc(j);
   end;
end;
*)




(*
Transactions data elements
==========================
TransactionId
ClientId
Account
AgentCode
Product
DateCreated
Supplier
TransactionType
TransactionTypeDetail
Status
SourceOfFunds
ActionCode
WireOrderNo
GrossAmount
NetAmount
AmountType
Units
TotalUnits
FundPaidCommission
DSC_Rate
FE_Rate
UnitPrice
WithHoldingTax
Fees
DSC
PaymentStatus
UserId
InternalExternal
TradeDate
ProcessingDate
ExchangeRate
ResponseSource
SettlementSource
SettlementDate
SettlementMethod
SettlementStatus
ContributionPeriod
ContributionCode
Currency
Certificate
DividendOption
FromFundId
FromFundAccount
FromDealer
FromDealerAccount
FromIntermediaryCode
FromIntermediaryAccount
FromAccountDesignation
FromAccountType
LockedIn
ProductEvent
Confirmation
SysPlanIndicator
SysPlanAmount
SysPlanCommRate
SysPlanFrequency
SysPlanRestartDate
SysPlanStartDate
SysPlanStopDate
SysPlanXferIndicator
GrossNetPurchase
GrossNetRedemption
ClientCommission
FundCoSpecific
SourceId
OrderId
OriginalOrderId
ClerkId
CSSActualDate
NetworkId
LastUpdate
LastUpdateBy
PercentOfTotal
AccountType
DealerAccount
Branch
IntermediaryCode
IntermediaryAccount
OrderType
OrderSource
OrderDate
OrderTime
DateAcknoweledged
SettlementDate
DateCkReceived
DateSubmitted
EffectiveDate
TotalClientAmount
AmountCkReceived
CommissionDate
CommissionPaid
*)

(*
Accounts data elements
======================
Supplier
Account
ClientId
AccountType
AgentCode
AccountDesignation
TaxCode
RecipientCode
IntermediaryCode
IntermediaryAccount
SecondType
SecondTitle
SecondLastName
SecondFirstName
SecondStreet
SecondApartment
SecondCity
SecondProvince
SecondPostalCode
SecondCountry
JointType
JointTitle
JointLastName
JointFirstName
JointBirthDate
JointSIN
JointStreet
JointApartment
JointCity
JointProvince
JointPostalCode
JointCountry
InTrustType
InTrustTitle
InTrustLastName
InTrustFirstName
InTrustBirthDate
InTrustSIN
InTrustRelationship
InTrustStreet
InTrustCity
InTrustApartment
InTrustProvince
InTrustPostalCode
InTrustCountry
BenefType
BenefRelationship
BenefIndicator
BenefTitle
BenefLastName
BenefFirstName
BenefBirthDate
BenefSIN
BenefStreet
BenefApartment
BenefCity
BenefProvince
BenefPostalCode
BenefCountry
BenefNotes
LastUpdate
PlanDescription
GRSPType
GRSPAccount
GRSPEmployer
GRSPDeductions
GRSPTelephone
AltPayee
AltDelivery
Language
ProvJurisdiction
DateCreated
*)

end.
