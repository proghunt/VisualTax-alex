unit T1_2026users;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,ShellApi,Grids,
  DBGrids,Buttons,Mask, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager, uADCompClient,
  uADCompDataSet;

type
  TUserSetupT1_2026 = class(TForm)
    DataSource1: TDataSource;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
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
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditM_OFFICE: TDBEdit;
    EditBRANCH: TDBEdit;
    Label8: TLabel;
    EditPREP_NAME: TDBEdit;
    Label12: TLabel;
    DBEdit1: TDBEdit;
    GroupBox4: TGroupBox;
    DBGrid1: TDBGrid;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    EditTAX_DIR: TDBEdit;
    EditEFILE_DIR: TDBEdit;
    CreateDataDirBtn: TBitBtn;
    AddBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    Label11: TLabel;
    EditBR_DIR: TDBEdit;
    FDConnection: TADConnection;
    Table1: TADTable;
    Label13: TLabel;
    EditDBFData_Dir: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CreateDataDirBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  UserSetup: TUserSetupT1_2026;

implementation
{$R *.DFM}

uses vtMulti,T1_2026,T1_2026Declare,T1_2026Common,T1_2026Common2,T1_2026TrimStr,
  T1_2026OptionsFrm,vtTrimStr,vtShared,
  vtDataBase, vtCommon;//20150915 Igor

procedure TUserSetupT1_2026.FormCreate(Sender: TObject);
begin
 If not(LicenseLevel in anyMulti) then
        GroupBox1.Enabled := False;  {Enterprise office}

 If Table1.Active = false then
 begin
 //20150915 Igor
 SetTableName(FDConnection, Table1, AppDir + '\' + UserDBLite, UserTableLite, ''); { TODO -oCon : use ExeDir.UserDB }
 Table1.Edit;
 end;
end;

procedure TUserSetupT1_2026.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TUserSetupT1_2026.OKBtnClick(Sender: TObject);
begin
 If AllTrim(Table1.FieldByName('Prep_Name').AsString) = '' then
 begin
  ShowMessage ('Full name required');
  EditPrep_Name.SetFocus;
  exit;
 end;


 If AllTrim(Table1.FieldByName('Login_id').AsString) = '' then
 begin
  ShowMessage ('Login Id required');
  EditLogin_id.SetFocus;
  exit;
 end;

 If AllTrim(Table1.FieldByName('PSWD').AsString) = '' then
 begin
  ShowMessage ('Password required');
  EditPswd.SetFocus;
  exit;
 end;

 If not DirectoryExists(EditTax_Dir.Text) then
 begin
  ShowMessage ('Tax directory does not exist'+chr(13)+
     'Click New and then click Data Directories');
  EditTax_Dir.SetFocus;
  exit;
 end;

 (*
 If not DirectoryExists(EditEfile_Dir.Text) then
 begin
  ShowMessage ('Efile directory does not exist'+Chr(13)+
       'Create first with Configuration');
  EditEfile_Dir.SetFocus;
  exit;
 end;
 *)
 If Not DirectoryExists(EDitBR_Dir.Text) then
 begin
  if MessageDlg('Branch Directory does not exist. Create now?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
     {$I-}   {so that the ioresult can be effective}
        MkDir(EDitBR_Dir.Text);
        if IOResult = 0 then
           MessageDlg('Directory: '+ EDitBR_Dir.Text + ' created', mtInformation, [mbOk], 0)
        else
           begin
             MessageDlg('Directory: '+ EDitBR_Dir.Text +
              chr(13)+' cannot be created', mtInformation, [mbOk], 0);
               EditBr_Dir.SetFocus;
               Exit;
           end;
    end
    Else
    begin
     EditBr_Dir.SetFocus;
     Exit;
    end;
  end;

 {
 If not DirectoryExists(EditBr_Dir.Text) then
 begin
  ShowMessage ('Branch directory does not exist');
  EditBr_Dir.SetFocus;
  exit;
 end;
 }
 Table1.Edit;
 Table1.Post;
 ShowMessage('Data saved');
end;

procedure TUserSetupT1_2026.CreateDataDirBtnClick(Sender: TObject);
begin
 ExecuteForm(TOptionsFrmT1_2026);
 EditTax_Dir.Text := OptRec.Dir_Cur;
end;



procedure TUserSetupT1_2026.AddBtnClick(Sender: TObject);
begin
 Table1.Insert;
 Table1.FieldByName('M_Office').AsString := 'MAIN';
 Table1.FieldByName('Branch').AsString := '00';
 Table1.FieldByName('Inv_No').AsString := '000';
 Table1.FieldByName('Tax_Dir').AsString := 'C:\T1-2007\Data';
 Table1.FieldByName('Efile_Dir').AsString := 'C:\T1-2007\Efile';
 Table1.FieldByName('BR_Dir').AsString := 'C:\CashDay';
 EditPREP_NAME.SetFocus;
end;

procedure TUserSetupT1_2026.DeleteBtnClick(Sender: TObject);
begin
If UpperCase(Table1.FieldByName('Login_id').AsString) = 'ADMIN' then
begin
 ShowMessage('You cannot delete the ADMIN user'+Chr(13)+
  'You should only change the password');
 exit;
end;
if MessageDlg('Delete this user?',
   mtInformation, [mbYes, mbNo], 0) = mrYes then
   begin
    Table1.Edit;
    Table1.Delete;
   end;
end;

end.
