unit TF_2026DICT;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,ExtCtrls,DBCtrls,DB,Grids,DBGrids,StdCtrls,Buttons,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TDataDictTF_2026 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataDict: TDataDictTF_2026;

implementation

{$R *.DFM}

uses TF_2026Common,TF_2026Declare,
     vtTrimStr, vtShared , vtDataBase;

procedure TDataDictTF_2026.FormCreate(Sender: TObject);
begin
If Table1.Active = false then
 begin
 //20150919 Igor
 SetTableName(FDConnection, Table1, AppDir + '\' + DictDBLite, DictTableLite, 'Name');
 end;
end;

procedure TDataDictTF_2026.SaveBtnClick(Sender: TObject);
begin
Table1.Edit;
Table1.Post;
Close;

end;

procedure TDataDictTF_2026.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

end.
