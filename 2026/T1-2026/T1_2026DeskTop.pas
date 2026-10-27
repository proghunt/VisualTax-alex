unit T1_2026DESKTOP;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  Dialogs,Forms,DBCtrls,DB,Mask,Buttons,T1_2026Declare,ExtCtrls,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TDeskTopT1_2026 = class(TForm)
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
    DBCheckBox5: TDBCheckBox;
    DBCheckBox8: TDBCheckBox;
    DBCheckBox9: TDBCheckBox;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    FDConnection: TADConnection;
    Table1: TADTable;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DeskTop: TDeskTopT1_2026;

implementation
{$R *.DFM}
uses vtCommon,T1_2026Common,T1_2026TrimStr
    ,vtTrimStr, vtShared, vtDataBase;

procedure TDeskTopT1_2026.FormCreate(Sender: TObject);
begin
 If Table1.State = DsInactive then
 begin
  //20150916 IGOR
  if not SetTableName(FDConnection, Table1, AppDir + '\' + FormsCfgDBLite, FormsCfgTableLite, '')
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

procedure TDeskTopT1_2026.SaveBtnClick(Sender: TObject);
begin
Table1.Post;
InitOptions;
CancelBtnClick(Sender);
end;

procedure TDeskTopT1_2026.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TDeskTopT1_2026.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T1Help','Operational_options');
end;

end.
