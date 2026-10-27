unit FP_2027SelectAnAgent;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,ExtCtrls, uADStanIntf, uADStanOption,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf,
  uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef, uADStanPool,
  uADPhysManager, uADCompClient, uADCompDataSet;

type
  TSelectAnAgentFP_2012 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PickedItem: TEdit;
    Query1: TADQuery;
    FDConnection: TADConnection;
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
  SelectAnAgent: TSelectAnAgentFP_2012;

implementation

{$R *.DFM}

uses FP_2027,FP_2027TrimStr,FP_2027Declare,vtTrimStr,vtShared;

procedure TSelectAnAgentFP_2012.FormCreate(Sender: TObject);
begin
 OpenQuery;
end;

procedure TSelectAnAgentFP_2012.OpenQuery;
Var WhereClause:String;
begin
 Query1.Close;
 Query1.SQL.Clear;
 WhereClause := '';
 {------------}
 With Query1 do
 begin
  SQL.Add('Select * from Agents');
  SQL.Add(' Order by LastName');
  Prepare;
  Try
   open;
  Except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;{try}
 end;
end;

procedure TSelectAnAgentFP_2012.CancelBtnClick(Sender: TObject);
begin
PickedItem.Text :='';
If Query1.Active then Query1.Close;
Close;
end;

procedure TSelectAnAgentFP_2012.OKBtnClick(Sender: TObject);
begin
 PickedItem.Text := AllTrim(Query1.FieldByName('AgentCode').AsString);
 If Query1.Active then Query1.Close;
 Close;
end;

procedure TSelectAnAgentFP_2012.DBGrid1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;

end.
