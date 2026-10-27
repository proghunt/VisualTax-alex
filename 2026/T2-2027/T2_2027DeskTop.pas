unit T2_2027desktop;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  Dialogs,Forms,DBCtrls,DB,Mask,Buttons,T2_2027Common,T2_2027Declare,
  T2_2027TrimStr,ExtCtrls, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager,
  uADCompClient, uADCompDataSet;

type
  TDeskTopT2_2027 = class(TForm)
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
    Label5: TLabel;
    BitBtn1: TBitBtn;
    Table1: TADTable;
    FDConnection: TADConnection;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
Const HelpTopic='Operational_options';
var
  DeskTop: TDeskTopT2_2027;

implementation
{$R *.DFM}
uses vtDataBase; //20150922 Igor

procedure TDeskTopT2_2027.FormCreate(Sender: TObject);
begin
  //20150922 IGOR
  if not SetTableName(FDConnection, Table1, AppDir + '\' + FormsCfgDBLite, FormsCfgTableLite, '')
  then exit;

 {If Table1.State = DsInactive then
 begin
   try
     Table1.Open;
   Except
     on EDataBaseError do
        ShowMessage(Table1.TableName + ' can not be opened');
     end;
 end;}
Table1.Edit;
end;

procedure TDeskTopT2_2027.SaveBtnClick(Sender: TObject);
begin
Table1.Post;
//InitCfgOptions;
CancelBtnClick(Sender);
end;

procedure TDeskTopT2_2027.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TDeskTopT2_2027.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T2Help',HelpTopic);
end;

end.
