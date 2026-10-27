unit T1_2026Tips;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,DBCtrls,ExtCtrls,DB,Grids,DBGrids,
  T1_2026Declare,T1_2026Common,T1_2026Common2,T1_2026TrimStr,DBLookup,FileCtrl,
  uADStanIntf, uADStanOption, uADStanParam, uADStanError, uADDatSManager,
  uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf,
  uADStanDef, uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet;

type
  TTipT1_2026 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    DBMemo1: TDBMemo;
    SaveBtn: TBitBtn;
    Label3: TLabel;
    Image1: TImage;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    Table1: TADTable;
    FDConnection: TADConnection;

    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

//Var Tip : TTip;

implementation
uses vtShared, vtDataBase;//20150916 Igor
{$R *.DFM}

procedure TTipT1_2026.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TTipT1_2026.FormCreate(Sender: TObject);
var i : integer;
begin
  //20150916 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + TipsDBLite, TipsTableLite, '');

  {Table1.IndexName := 'Tip_Type';}
  Table1.Open;
  Table1.Edit;
end;

procedure TTipT1_2026.SaveBtnClick(Sender: TObject);
begin
Table1.Edit;
Table1.Post;
ShowMessage('Tip Saved');
end;



end.
