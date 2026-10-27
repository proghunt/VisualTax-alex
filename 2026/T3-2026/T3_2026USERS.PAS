unit T3_2026USERS;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  Forms,DBCtrls,DB,Buttons,Mask,ExtCtrls,Grids,DBGrids, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef,
  uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet;

type
  TUserSetupT3_2026 = class(TForm)
    Label8: TLabel;
    EditPREP_NAME: TDBEdit;
    DataSource1: TDataSource;
    EditTAX_DIR: TDBEdit;
    EditEFILE_DIR: TDBEdit;
    DBNavigator: TDBNavigator;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditM_OFFICE: TDBEdit;
    Label2: TLabel;
    EditBRANCH: TDBEdit;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    EditLOGIN_ID: TDBEdit;
    Label5: TLabel;
    EditPSWD: TDBEdit;
    Label6: TLabel;
    EditAUTH_LEVEL: TDBEdit;
    Label3: TLabel;
    EditPREP_INTLS: TDBEdit;
    Label7: TLabel;
    EditINV_NO: TDBEdit;
    DBGrid1: TDBGrid;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Table1: TADTable;
    FDConnection: TADConnection;
    Label13: TLabel;
    EditDBFData_Dir: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  UserSetup: TUserSetupT3_2026;

implementation

{$R *.DFM}

uses vtMulti,T3_2026Common,T3_2026Common2,T3_2026TrimStr,T3_2026Declare,
  vtTrimStr, vtShared, vtDataBase;

procedure TUserSetupT3_2026.FormCreate(Sender: TObject);
begin
If not (LicenseLevel in anyMulti) then
        GroupBox1.Enabled := False;  {Enterprise office}
If Table1.Active = false then
 begin
 //20150919 Igor
 SetTableName(FDConnection, Table1, AppDir + '\' + UserDBLite, UserTableLite, '');

 Table1.Edit;
 end;
end;

procedure TUserSetupT3_2026.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TUserSetupT3_2026.OKBtnClick(Sender: TObject);
begin
 Table1.Edit;
 Close;
end;

end.
