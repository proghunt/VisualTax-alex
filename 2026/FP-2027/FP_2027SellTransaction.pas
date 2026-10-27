unit FP_2027SellTransaction;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,ExtCtrls,FP_2027Declare, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TSellTransactionFP_2012 = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    PayeeBox: TRadioGroup;
    AccountBox: TEdit;
    AmountBox: TEdit;
    Label7: TLabel;
    AmountTypeBox: TComboBox;
    Label9: TLabel;
    DataSource2: TDataSource;
    Label8: TLabel;
    ProductBox: TEdit;
    SelectBtn: TBitBtn;
    Label10: TLabel;
    ListBox1: TListBox;
    GroupBox2: TGroupBox;
    Label11: TLabel;
    CancelBtn: TBitBtn;
    SelectedItem: TEdit;
    OkBtn: TBitBtn;
    StatusBox: TComboBox;
    FDConnection: TADConnection;
    TransactionsTbl: TADTable;
    procedure FormCreate(Sender: TObject);
    {procedure OpenAssetsQ;}
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
   { procedure PortFChartBtnClick(Sender: TObject);}
    procedure SearchBtnClick(Sender: TObject);
    {procedure SelectFundTypeBtnClick(Sender: TObject);}
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FundNameBoxKeyPress(Sender: TObject; var Key: Char);
    procedure InitTransaction;
    Procedure ShowTransactiondata;
    procedure SelectBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SellTransaction: TSellTransactionFP_2012;
  FundType :string; //[2];
  TransactionNo : Integer;
  NewTransaction : Boolean;

implementation

{$R *.DFM}

uses vtCommon,vtChild,FP_2027,FP_2027TrimStr,FP_2027SelectFundType,
{$IFDEF ADO}
  FP_2012SelectACurrentFund,FP_2012Transactions,
{$ELSE}
{$ENDIF}
  vtTrimStr,vtShared,
  vtMulti; //20170112 Igor

procedure TSellTransactionFP_2012.FormCreate(Sender: TObject);
begin
 FormatSettings.DecimalSeparator:='.';
 {If FunSupplier >'' then FundNameBox.Text := Supplier;}
 If TransactionsTbl.Active then TransactionsTbl.Close;
 TransactionsTbl.Open;
 TransactionsTbl.IndexFieldNames := 'TransactionId';

 If ThisTransaction = '' then NewTransaction :=True else NewTransaction:=False;

 If NewTransaction then
 begin
 AccountBox.Text:='';
 AmountTypeBox.Text := 'A  All Shares/Units';
 AmountBox.Text := '0';
 PayeeBox.ItemIndex :=0;
 StatusBox.Text := 'HO Ready';
 end
 else
  ShowTransactionData;
end;

Procedure TSellTransactionFP_2012.ShowTransactiondata;
begin
 If not TransactionsTbl.FindKey([ThisTransaction]) then
 begin
  ShowMessage('Transaction not found. Data Integrity problem');
  exit;
 end;
 With TransactionsTbl do
  begin
   ProductBox.Text           :=FieldByName('Product').AsString;
   AccountBox.Text           :=FieldByName('Account').AsString;
   {AccountTypeBox.Text       :=FieldByName('AccountType').AsString;}
   AmountTypeBox.Text        := FieldByName('AmountType').AsString;
   AmountBox.Text            := FloatToStr(FieldByName('NetAmount').AsFloat);
   StatusBox.Text            := FieldByName('Status').AsString;
  end;
end;

procedure TSellTransactionFP_2012.OKBtnClick(Sender: TObject);
Var i:Integer;ProductSold:string; //[20];
begin
 If AllTrim(AccountBox.Text) = '' then
 Begin
  ShowMessage('Account required');
  {AccountBox.SetFocus;}
  Exit;
 end;

 If AllTrim(ProductBox.Text) = '' then
 Begin
  ShowMessage('Product required');
  ProductBox.SetFocus;
  Exit;
 end;

 If ((LeftStr(AmountTypeBox.Text,1) = 'S')
 or (LeftStr(AmountTypeBox.Text,1) = 'P')
 Or (LeftStr(AmountTypeBox.Text,1) = 'D')) then
 begin
  If (Vl(AmountBox.Text) = 0) then
  Begin
   ShowMessage('Amount greater than zero is required');
   AmountBox.SetFocus;
   Exit;
  end
 end
 else
 Begin
  If Vl(AmountBox.Text) > 0 then
  Begin
   ShowMessage('Amount must be zero for the selected amount type');
   AmountBox.SetFocus;
   Exit;
  end;
 end;

 For i:=1 to Length(AmountBox.Text) do
 begin
  If ValidateAmountField(AmountBox.Text[i]) = False then
  Begin
   ShowMessage('Amount is not numeric (0 to 9 and period allowed');
   AmountBox.SetFocus;
   Exit;
  end;
 end;

 If NewTransaction then
   InitTransaction
 else
   TransactionsTbl.Edit;
 TransactionsTbl.FieldByName('Account').AsString :=AccountBox.Text;
 TransactionsTbl.FieldByName('Product').AsString :=ProductBox.Text;
 TransactionsTbl.FieldByName('AmountType').AsString :=LeftStr(AmountTypeBox.Text,1);
 TransactionsTbl.FieldByName('NetAmount').AsFloat :=StrToFloat(AmountBox.Text);
 TransactionsTbl.FieldByName('TransactionType').AsString := '6';
 TransactionsTbl.FieldByName('Status').AsString :=StatusBox.Text;
 ProductSold:=TransactionsTbl.FieldByName('Product').AsString;
 (*  ??
 If PayeeBox.ItemIndex =0 then
  TransactionsTbl.FieldByName('PayeeIndicator').AsString :='D'
 else
  TransactionsTbl.FieldByName('PayeeIndicator').AsString :='#';
 *)
 TransactionsTbl.Edit;
 Try
 TransactionsTbl.Post;
 SaveLastTransactionNo(User.Code,TransactionNo); //20170112 Igor
 Except
  ShowMessage('Cannot save transaction');
  Exit;
 end;
 ListBox1.Items.Add(ProductSold);
 If NewTransaction then
 begin
  ThisTransaction:='';
  ShowMessage('Transaction saved. You may repeat');
  AccountBox.Text:='';
  ProductBox.Text:='';
  AmountBox.Text := '0';
 end
 else
  ShowMessage('Transaction saved');

 {
 SelectedItem.Text :=
   PaddR(AssetsQ.FieldByName('Product').AsString,6)+
   ' '+PaddR(AssetsQ.FieldByName('Supplier').AsString,3)+
  ' '+AssetsQ.FieldByName('Description').AsString;
 AssetsQ.Close;
 Close;
}
end;

procedure TSellTransactionFP_2012.CancelBtnClick(Sender: TObject);
begin
 SelectedItem.Text :='';
 {If AssetsQ.Active then AssetsQ.Close;}
 If TransactionsTbl.Active then TransactionsTbl.Close;
 Close;
end;

procedure TSellTransactionFP_2012.DBGrid1DblClick(Sender: TObject);
begin
 {
 AccountBox.Text := AssetsQ.FieldByName('Account').AsString;
 ProductBox.Text := AssetsQ.FieldByName('Product').AsString;
 }
{OKBtnClick(Sender);}
end;


procedure TSellTransactionFP_2012.SearchBtnClick(Sender: TObject);
begin
 {OpenAssetsQ;}
end;

(*
procedure TSelectAClientFund.SelectFundTypeBtnClick(Sender: TObject);
begin
 Application.CreateForm(TSelectFundType,SelectFundType);
 SelectFundType.ShowModal;
 If SelectAFund.SelectedItem.Text ='' then exit;
 FundTypeBox.Text :=SelectFundType.SelectedItem.Text;
 SelectFundType.Free;
 SearchBtnClick(Sender);
end;
*)

procedure TSellTransactionFP_2012.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
{If Key = Char(13) then OKBtnClick(Sender);}
end;

procedure TSellTransactionFP_2012.FundNameBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then SearchBtnClick(Sender);
end;

procedure TSellTransactionFP_2012.InitTransaction;
Var i:Integer;
begin
 With TransactionsTbl do
 begin
  TransactionsTbl.Insert;
  for I := 0 to TransactionsTbl.FieldCount - 1 do
  begin
    {Edit;}
    If Fields[I].DataType = ftString then  Fields[I].Value := ''
    else If Fields[I].DataType = ftFloat then  Fields[I].Value := 0.0
    else If Fields[I].DataType = ftInteger then  Fields[I].Value := 0
    else If Fields[I].DataType = ftCurrency then  Fields[I].Value := '$0';
  end;
  TransactionNo:= GetLastTransactionNo(User.Code)+1; //20170112 Igor
  ThisTransaction := MakeTransactionId(User.Branch,User.Code,TransactionNo); //20170112 Igor
  FieldByName('TransactionId').AsString :=ThisTransaction;
  FieldByName('AccountType').AsString := 'NEW';
  FieldByName('AccountType').AsString := 'OPEN';
  FieldByName('ActionCode').AsString := 'NEW';
  FieldByName('ClientId').AsString := Client;
  FieldByName('AgentCode').AsString := User.Code; //20170112 Igor
  FieldByName('TransactionType').AsString := '';
  FieldByName('TransactionTypeDetail').AsString := '';
  FieldByName('DealerAccount').AsString := Client;
  FieldByName('OrderSource').AsString := 'D Dealer';
  FieldByName('OrderType').AsString := 'W WireOrder';
  FieldByName('Status').AsString := 'WIP'; {StatusBox.Text;}
  FieldByName('OrderDate').AsString := FormatDateTime('yyyy-mm-dd',Now);
  FieldByName('DateCreated').AsString := FormatDateTime('yyyy-mm-dd',Now);
  FieldByName('EffectiveDate').AsString := FormatDateTime('yyyy-mm-dd',Now);

  {fund info}
  FieldByName('AmountType').AsString := 'D Dollars';
  FieldByName('DividendOption').AsString := '1 Re-invest';
  FieldByName('GrossNetPurchase').AsString := 'G Gross';
  FieldByName('Certificate').AsString := 'N';
  FieldByName('SettlementSource').AsString := 'D';
  FieldByName('SysPlanIndicator').AsString := ' ';
  FieldByName('LastUpdate').AsString := FormatDateTime('yyyy-mm-dd',Now);
  FieldByName('LastUpdateBy').AsString := User.Code; //20170112 Igor
 end;
end;

procedure TSellTransactionFP_2012.SelectBtnClick(Sender: TObject);
begin
{$IFDEF ADO}
 Application.CreateForm(TSelectACurrentFund,SelectACurrentFund);
 SelectACurrentFund.ShowModal;
 If SelectACurrentFund.SelectedItem.Text ='' then exit;

 ProductBox.Text :=LeftStr(SelectACurrentFund.SelectedItem.Text,6);
 Supplier  :=MidStr(SelectACurrentFund.SelectedItem.Text,8,3);
 {Descr  :=MidStr(SelectAFund.SelectedItem.Text,12,50);}

 SelectACurrentFund.Free;
{$ELSE}
  
{$ENDIF}
end;

end.
