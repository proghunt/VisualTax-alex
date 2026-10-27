unit FP_2027desktop;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  Dialogs,Forms,DBCtrls,DB,Mask,Buttons,FP_2027Common,FP_2027Declare,
  ExtCtrls, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager, uADCompClient,
  uADCompDataSet;

type
  TDeskTopFP_2012 = class(TForm)
    DataSource1: TDataSource;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    DBEdit2: TDBEdit;
    GroupBox2: TGroupBox;
    DBCheckBox6: TDBCheckBox;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Table1: TADTable;
    FDConnection: TADConnection;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DeskTop: TDeskTopFP_2012;

implementation
{$R *.DFM}
uses vtDataBase; // 20150921 Igor

procedure TDeskTopFP_2012.FormCreate(Sender: TObject);
begin
 If Table1.State = DsInactive then
 begin
   //20150921 IGOR
   if not SetTableName(FDConnection, Table1, cfgClientsDbLite_noUse, FormsCfgTableLite, '') {AppDir;}
   then exit;
   {try
     Table1.Open;
   Except
     on EDataBaseError do
        ShowMessage(Table1.TableName + ' can not be opened');
     end;}
 end;
 Table1.Edit;
end;

procedure TDeskTopFP_2012.SaveBtnClick(Sender: TObject);
begin
Table1.Post;
{InitCfgOptions;}
CancelBtnClick(Sender);
end;

procedure TDeskTopFP_2012.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TDeskTopFP_2012.FormClick(Sender: TObject);
begin
CancelBtnClick(Sender);
end;

end.
