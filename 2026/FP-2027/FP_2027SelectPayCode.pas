unit FP_2027SelectPayCode;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,ExtCtrls, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TSelectPayCodeFP_2012 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PickedItem: TEdit;
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
  SelectPayCode: TSelectPayCodeFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027TrimStr,FP_2027Declare,vtTrimStr,vtShared;

procedure TSelectPayCodeFP_2012.FormCreate(Sender: TObject);
begin
 OpenQuery;
end;

procedure TSelectPayCodeFP_2012.OpenQuery;
Var WhereClause:String;
begin
 Query1.Close;
 Query1.SQL.Clear;
 WhereClause := '';
 {------------}
 With Query1 do
 begin
 SQL.Add('Select * from PayCodes');
 SQL.Add(' Order by Code');
 Prepare;
 open;
 end;
end;

procedure TSelectPayCodeFP_2012.CancelBtnClick(Sender: TObject);
begin
PickedItem.Text :='';
If Query1.Active then Query1.Close;
Close;
end;

procedure TSelectPayCodeFP_2012.OKBtnClick(Sender: TObject);
begin
 PickedItem.Text := PaddR(Query1.FieldByName('Code').AsString,2)
  +' '+PaddR(Query1.FieldByName('Type').AsString,6)
  +' '+PaddR(Query1.FieldByName('Description').AsString,30);
  If Query1.Active then Query1.Close;
 Close;
end;

procedure TSelectPayCodeFP_2012.DBGrid1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;

end.
