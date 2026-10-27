unit FP_2027DICT;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,ExtCtrls,DBCtrls,DB,Grids,DBGrids,StdCtrls,Buttons,
  FP_2027Common,FP_2027Declare, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TDataDictFP_2012 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;
    {procedure FormCreate(Sender: TObject);}
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataDict: TDataDictFP_2012;

implementation

{$R *.DFM}

procedure TDataDictFP_2012.SaveBtnClick(Sender: TObject);
begin
Table1.Edit;
Try
Table1.Post;
except
 on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
end;

Close;

end;

procedure TDataDictFP_2012.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

end.
