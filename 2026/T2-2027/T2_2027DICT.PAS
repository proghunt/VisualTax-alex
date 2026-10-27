unit T2_2027DICT;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,ExtCtrls,DBCtrls,DB,Grids,DBGrids,StdCtrls,Buttons,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TDataDictT2_2027 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    BitBtn1: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Const HelpTopic='Data_Dictionary';
var
  DataDictT2_2027: TDataDictT2_2027;

implementation

{$R *.DFM}

uses T2_2027Common,T2_2027TrimStr,T2_2027Declare, vtTrimStr, vtShared, vtDataBase;

procedure TDataDictT2_2027.FormCreate(Sender: TObject);
begin
If Table1.Active = false then
 begin
  //20150920 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + DictDBLite, DictTableLite, 'Name');
 end;
end;

procedure TDataDictT2_2027.SaveBtnClick(Sender: TObject);
begin
Table1.Edit;
Table1.Post;
Close;

end;

procedure TDataDictT2_2027.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TDataDictT2_2027.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T2Help',HelpTopic);
end;

end.
