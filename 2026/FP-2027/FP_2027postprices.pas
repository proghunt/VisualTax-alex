unit FP_2027postprices;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,Db,FP_2027TrimStr,FP_2027Declare;

type
  TPostPrices = class(TForm)
    Panel3: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    AssetsSrc: TDataSource;
    DataSource2: TDataSource;
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
(*
    procedure OKBtnClick(Sender: TObject);
    procedure OpenAssets;
    procedure OpenMutualFunds;
    procedure OpenTables;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PostPrices: TPostPrices;

implementation

{$R *.DFM}


(*
procedure TPostPrices.OpenTables;
begin
 OpenAssets;
 OpenMutualFunds;
 {OpenClients;}
end;

procedure TPostPrices.OpenAssets;
begin
 //AssetsTbl.DataBaseName := ClientsDb;
 AssetsTbl.ConnectionString:=FpClientsConnectionString;
 If not AssetsTbl.Active then AssetsTbl.Open;
 AssetsTbl.IndexFieldNames := 'Product';
end;

procedure TPostPrices.OpenMutualFunds;
begin
 //MutualFundsTbl.DataBaseName := FundsDb;
 MutualFundsTbl.ConnectionString:=FundBaseConnectionString;
 If not MutualFundsTbl.Active then MutualFundsTbl.Open;
 MutualFundsTbl.IndexFieldNames := 'FundCode';  //'ProductId';
end;


procedure TPostPrices.OKBtnClick(Sender: TObject);
begin
 Screen.Cursor := crHourGlass;
 Try
 If Not MutualFundsTbl.Active then MutualFundsTbl.Open;
 MutualFundsTbl.IndexFieldnames := 'FundCode';
 If AssetsTbl.Active Then AssetsTbl.Close;
 AssetsTbl.Open;
 AssetsTbl.IndexFieldNames := 'Product';
 AssetsTbl.First;
 Repeat
  If LeftStr(AssetsTbl.FieldByName('AssetType').AsString,2)= 'MF' then
  begin
   If MutualFundsTbl.Seek(AssetsTbl.FieldByName('Product').AsString,soFirstEq) then
   begin
     AssetsTbl.Edit;
     AssetsTbl.FieldByName('UnitPrice').AsFloat := MutualFundsTbl.FieldByName('UnitPrice').AsFloat;
     AssetsTbl.FieldByName('CurrentValue').AsFloat :=
            AssetsTbl.FieldByName('Units').AsFloat
            * AssetsTbl.FieldByName('UnitPrice').AsFloat;
     AssetsTbl.FieldByName('LastUpdate').AsString := FormatDateTime('yyyy-mm-dd',Now);
     AssetsTbl.FieldByName('UpdatedBy').AsString := 'FundServ';
   end
   else
    ListBox1.Items.Add('Fund '+AssetsTbl.FieldByName('Product').AsString +
      ' is not in the Mutual Funds Data Base');
  end;
 AssetsTbl.Next;
 until AssetsTbl.Eof;
 ShowMessage('Completed');
 Except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end; {try}
 Screen.Cursor := crDefault;

end;


procedure TPostPrices.FormCreate(Sender: TObject);
begin
  OpenTables;
end;

procedure TPostPrices.CancelBtnClick(Sender: TObject);
begin
If AssetsTbl.Active then AssetsTbl.Close;
{If ClientsTbl.Active then ClientsTbl.Close;}
If MutualFundsTbl.Active then MutualFundsTbl.Close;
Close;
end;

procedure TPostPrices.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;
*)
end.


