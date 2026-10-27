unit FP_2027selectfundtype;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,ExtCtrls, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TSelectFundTypeFP_2012 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    SelectedItem: TEdit;
    FDConnection: TADConnection;
    Query1: TADQuery;
    procedure FormCreate(Sender: TObject);
    procedure OpenQuery;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectFundType: TSelectFundTypeFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027TrimStr,FP_2027Declare,vtTrimStr,vtShared;

procedure TSelectFundTypeFP_2012.FormCreate(Sender: TObject);
begin
 OpenQuery;
end;

procedure TSelectFundTypeFP_2012.OpenQuery;
Var WhereClause:String; AVariable:string; //[20];
begin
 FDConnection.Params.Values['DataBase']:=FundsDBLite; // 20150922 Igor
 Query1.Close;
 Query1.SQL.Clear;
 {Build where clause}
 WhereClause := '';
 {------------}
 With Query1 do
 begin
  SQL.Add('Select ');
  SQL.Add('Name');
  SQL.Add(',FundType');
  SQL.Add(' from FundType');
  SQL.Add(' Order by Name');
  Prepare;
  Try
   open;
  Except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;{try}
 end; {with}
end;

procedure TSelectFundTypeFP_2012.CancelBtnClick(Sender: TObject);
begin
SelectedItem.Text :='';
If Query1.Active Then Query1.Close;
Close;
end;

procedure TSelectFundTypeFP_2012.OKBtnClick(Sender: TObject);
begin
 SelectedItem.Text := PaddR(Query1.FieldByName('FundType').AsString,2)
  +' '+PaddR(Query1.FieldByName('Name').AsString,30);
 If Query1.Active Then Query1.Close;
 Close;
end;

procedure TSelectFundTypeFP_2012.DBGrid1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;

end.
