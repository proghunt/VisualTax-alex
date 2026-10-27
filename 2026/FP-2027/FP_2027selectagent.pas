unit FP_2027selectagent;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,ExtCtrls, uADStanIntf, uADStanOption,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf,
  uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef, uADStanPool,
  uADPhysManager, uADCompClient, uADCompDataSet;

type
  TSelectAgentFP_2012 = class(TForm)
    DataSource1: TDataSource;
    GroupBox1: TGroupBox;
    AgentNameBox: TEdit;
    Label1: TLabel;
    SearchBtn: TBitBtn;
    FundTypeBox: TEdit;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    CancelBtn: TBitBtn;
    SelectedItem: TEdit;
    OkBtn: TBitBtn;
    DBGrid1: TDBGrid;
    AgentsQ: TADQuery;
    FDConnection: TADConnection;
    procedure FormCreate(Sender: TObject);
    procedure OpenAgentsQ;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
   { procedure PortFChartBtnClick(Sender: TObject);}
    procedure SearchBtnClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure AgentNameBoxKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectAgent: TSelectAgentFP_2012;
  FundType :string; //[2];

implementation

{$R *.DFM}

uses FP_2027TrimStr,FP_2027Declare, vtTrimStr, vtShared, vtDataBase;

procedure TSelectAgentFP_2012.FormCreate(Sender: TObject);
begin
 OpenAgentsQ;
end;

procedure TSelectAgentFP_2012.OpenAgentsQ;
Var WhereClause:String;
begin
  //20150922 Igor
  SqlLoadDBFromFile(FDConnection, AgentsQ, cfgClientsDbLite_noUse, '');

 AgentsQ.SQL.Clear;
 {Build where clause}
 WhereClause := '';

 If AgentNameBox.text >'' then
 begin
  If RightStr(AgentNameBox.text,1) <> '*' then
  AgentNameBox.text:=AgentNameBox.text+'*';
  WhereClause := ' Where '
  +'('
  + 'Trim(LastName) LIKE ' + '"' +  AgentNameBox.Text + '"'
  +')';
 end;

 With  AgentsQ do
 begin
 SQL.Add('Select * from Agents');
 SQL.Add( WhereClause);
 SQL.Add( 'ORDER BY LastName');
 Prepare;
 open; {good only for local db and SELECT statement on Client server}
 {Query1.ExecSql;}  {good for INSERT, UPDATE, DELETE, and CREATE TABLE and client server db as well}
 end;
end;


procedure TSelectAgentFP_2012.OKBtnClick(Sender: TObject);
begin
 {SelectedItem.Text :=AgentsQ.FieldByName('AgentCode').AsString;}
 SelectedItem.Text :=AgentsQ.FieldByName('UserId').AsString;
 AgentsQ.Close;
 Close;
end;

procedure TSelectAgentFP_2012.CancelBtnClick(Sender: TObject);
begin
 SelectedItem.Text :='';
 AgentsQ.Close;
 Close;
end;

procedure TSelectAgentFP_2012.DBGrid1DblClick(Sender: TObject);
begin
OKBtnClick(Sender);
end;


procedure TSelectAgentFP_2012.SearchBtnClick(Sender: TObject);
begin
 OpenAgentsQ;
end;


procedure TSelectAgentFP_2012.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
If Key = Char(13) then OKBtnClick(Sender);
end;

procedure TSelectAgentFP_2012.AgentNameBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then SearchBtnClick(Sender);
end;

end.
