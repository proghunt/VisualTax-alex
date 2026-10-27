unit FP_2027USERS;

interface

uses SysUtils,WinTypes,Dialogs,WinProcs,Messages,Classes,Graphics,Controls,
  StdCtrls,Forms,DBCtrls,DB,Buttons,Mask,ExtCtrls,FileCtrl,Grids,
  DBGrids, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TUserSetup = class(TForm)
    Label8: TLabel;
    EditPREP_NAME: TDBEdit;
    DataSource1: TDataSource;
    DBNavigator: TDBNavigator;
    ButtonsPanel: TPanel;
    CancelBtn: TBitBtn;
    LocationPanel: TGroupBox;
    Label1: TLabel;
    EditM_OFFICE: TDBEdit;
    Label2: TLabel;
    EditBRANCH: TDBEdit;
    IdentPanel: TGroupBox;
    Label4: TLabel;
    EditLOGIN_ID: TDBEdit;
    Label5: TLabel;
    EditPSWD: TDBEdit;
    EditAUTH_LEVEL: TDBEdit;
    Label3: TLabel;
    EditPREP_INTLS: TDBEdit;
    Label7: TLabel;
    EditINV_NO: TDBEdit;
    DBGrid1: TDBGrid;
    Label12: TLabel;
    AgentCode: TDBEdit;
    Label13: TLabel;
    DirPanel: TGroupBox;
    Label9: TLabel;
    EditFilesDIR: TDBEdit;
    Label10: TLabel;
    EditEFILEDIR: TDBEdit;
    Label14: TLabel;
    EditSecDir: TDBEdit;
    EditTaxDir: TDBEdit;
    Label15: TLabel;
    OKBtn: TBitBtn;
    Label16: TLabel;
    BrokerCode: TDBEdit;
    Label17: TLabel;
    Label18: TLabel;
    EditSouthmDir: TDBEdit;
    FDConnection: TADConnection;
    Table1: TADTable;
    Label6: TLabel;
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
  UserSetup: TUserSetup;

implementation

{$R *.DFM}

uses vtMulti,FP_2027Common,FP_2027Common2,FP_2027TrimStr,FP_2027Declare,
     vtTrimStr, vtShared, vtDataBase;

procedure TUserSetup.FormCreate(Sender: TObject);
begin
  //If LicenseLevel <> '3' then
  If LicenseLevel <> llPower then { TODO -oCon : check }
          LocationPanel.Enabled := False;  {Enterprise office}

  //20150918 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + UserDBLite, UserTableLite, '');
  Table1.Edit;
 (*
 With table1 do
  begin
   If AllTrim(FieldByName('Files_dir').AsString)  = '' then
     EditFilesDir.text := CfgRec.Dir_Cur;
   If AllTrim(FieldByName('Tax_dir').AsString)  = '' then
    FieldByName('Tax_dir').AsString  := CfgRec.Dir_Tax;
   If AllTrim(FieldByName('Efile_dir').AsString) = '' then
    FieldByName('Efile_dir').AsString  := CfgRec.Dir_EFile;
   If AllTrim(FieldByName('Sec_dir').AsString)  = '' then
    FieldByName('Sec_dir').AsString  := CfgRec.Dir_Sec;
  end;
  *)
end;

procedure TUserSetup.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TUserSetup.OKBtnClick(Sender: TObject);
begin
 If not DirectoryExists(EditTaxDir.Text) then
 begin
  ShowMessage('Files directory does not exist. Use Config to create');
  EditTaxDir.SetFocus;
  {exit;}
 end;
 If not DirectoryExists(EditEFileDir.Text) then
 begin
  ShowMessage('EFile directory does not exist. Use Config to create');
  EditEFileDir.SetFocus;

 end;

 If not DirectoryExists(EditSecDir.Text) then
 begin
  ShowMessage('EFile directory does not exist. Use Config to create');
  EditSecDir.SetFocus;
 { exit;}
 end;
 If not DirectoryExists(EditSouthmDir.Text) then
 begin
  ShowMessage('All Funds directory does not exist. Use Config to create');
  EditSouthmDir.SetFocus;
 { exit;}
 end;

 Table1.Edit;
 Table1.Post;
 ShowMessage('Data saved');
end;



end.
