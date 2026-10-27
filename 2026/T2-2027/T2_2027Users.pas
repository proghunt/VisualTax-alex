unit T2_2027users;

interface

uses SysUtils,WinTypes,Dialogs,WinProcs,Messages,Classes,Graphics,Controls,
  StdCtrls,Forms,DBCtrls,DB,Buttons,Mask,ExtCtrls,Grids,DBGrids,
  FileCtrl, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TUserSetupT2_2027 = class(TForm)
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
    Label12: TLabel;
    DBEdit1: TDBEdit;
    Label13: TLabel;
    FDConnection: TADConnection;
    Table1: TADTable;
    Label14: TLabel;
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
  UserSetup: TUserSetupT2_2027;

implementation

{$R *.DFM}

uses vtMulti,T2_2027Common,T2_2027Common2,T2_2027TrimStr,T2_2027Declare,
     vtTrimStr, vtShared, vtDataBase;

procedure TUserSetupT2_2027.FormCreate(Sender: TObject);
begin
If not (LicenseLevel in anyMulti) then
        GroupBox1.Enabled := False;  {Enterprise office}
If Table1.Active = false then
 begin
 //20150920 Igor
 SetTableName(FDConnection, Table1, AppDir + '\' + UserDBLite, UserTableLite, '');
 Table1.Edit;
 end;
end;

procedure TUserSetupT2_2027.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TUserSetupT2_2027.OKBtnClick(Sender: TObject);
begin
 If Not SysUtils.DirectoryExists(Table1.FieldByName('Tax_Dir').AsString) then //20150702
 begin
  ShowMessage('Directory '+
    Table1.FieldByName('Tax_Dir').AsString+' does not exist');
  Exit;
 end;

 Table1.Edit;
 Table1.Post;
 ShowMessage('Data saved');
end;

end.
