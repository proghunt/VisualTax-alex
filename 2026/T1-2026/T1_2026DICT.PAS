unit T1_2026DICT;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,ExtCtrls,DBCtrls,DB,Grids,DBGrids,StdCtrls,Buttons,
  T1_2026Declare, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;

type
  TDataDictT1_2026 = class(TForm)
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

var
  DataDict: TDataDictT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026Common,T1_2026TrimStr,vtTrimStr,vtShared
   , vtDataBase;//20150915 Igor

procedure TDataDictT1_2026.FormCreate(Sender: TObject);
begin
If Table1.Active = false then
 begin
 //20150915 Igor
 SetTableName(FDConnection, Table1, AppDir + '\' + DictDBLite, DictTableLite, 'Name');
 end;
end;

procedure TDataDictT1_2026.SaveBtnClick(Sender: TObject);
begin
Table1.Edit;
Table1.Post;
Close;

end;

procedure TDataDictT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;

end;

procedure TDataDictT1_2026.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T1Help','Data_Dictionary');
end;

end.
