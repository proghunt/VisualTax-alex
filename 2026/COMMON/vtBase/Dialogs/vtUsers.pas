unit vtUsers;

interface

uses System.SysUtils, Winapi.Messages, System.Classes, VCL.Forms, Vcl.Dialogs,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, Vcl.ComCtrls, Vcl.ExtCtrls, Data.DB,
  uADCompDataSet, uADCompClient, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Controls, UserAppSettingsFrame, Vcl.Grids,
  Vcl.DBGrids;

type
  TTabSheetEx = class(TTabSheet)
    FFrame: TframeUserAppSettings;
  end;

  TfrmvtUsers = class(TForm)
    dsUsers: TDataSource;
    pnlFooter: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    gbCommonSettings: TGroupBox;
    Label4: TLabel;
    edtLOGIN_ID: TDBEdit;
    Label5: TLabel;
    edtPSWD: TDBEdit;
    Label6: TLabel;
    edtAUTH_LEVEL: TDBEdit;
    Label3: TLabel;
    edtPREP_INTLS: TDBEdit;
    Label7: TLabel;
    edtINV_NO: TDBEdit;
    gbLocations: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtM_OFFICE: TDBEdit;
    edtBRANCH: TDBEdit;
    Label8: TLabel;
    edtPREP_NAME: TDBEdit;
    Label12: TLabel;
    edtCODE: TDBEdit;
    gbUserList: TGroupBox;
    AddBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    conUsers: TADConnection;
    tblUsers: TADTable;
    pnlTools: TPanel;
    Splitter1: TSplitter;
    pnlUserSettings: TPanel;
    Splitter2: TSplitter;
    pgcMulti: TPageControl;
    gbMultiSettings: TGroupBox;
    grUsers: TDBGrid;
    btnCopyUser: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tblUsersAfterInsert(DataSet: TDataSet);
    procedure tblUsersBeforeDelete(DataSet: TDataSet);
    procedure tblUsersAfterScroll(DataSet: TDataSet);
    procedure tblUsersBeforeInsert(DataSet: TDataSet);
    procedure tblUsersBeforeScroll(DataSet: TDataSet);
  private
    { private declarations }
    FNewUserName: string;
    function CheckEdit(const AAsk: Boolean = False): Boolean;
    procedure initMultiOfficeSettings;
  public
    { public declarations }
  end;

var
  frmvtUsers: TfrmvtUsers;

implementation

{$R *.DFM}

uses vtDataBase, vtShared, vtMulti;

procedure TfrmvtUsers.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckEdit(ModalResult <> mrOk);
end;

procedure TfrmvtUsers.FormCreate(Sender: TObject);
begin
  SetTableName(ConUsers, tblUsers, IncludeTrailingPathDelimiter(ExeDir) + UserDBLite, UserTableLite, '');
  initMultiOfficeSettings;
end;

procedure TfrmvtUsers.initMultiOfficeSettings;
var
  I: Integer;
  ts: TTabSheetEx;
  frm: TframeUserAppSettings;
begin
  for I := 0 to AppList.Count - 1 do
  begin
    if AppList.GetApp(I).LicenseLevel in anyMulti then
    begin
      ts := TTabSheetEx.Create(Self);
      ts.Parent := pgcMulti;
      ts.PageControl := pgcMulti;
      ts.Caption := AppList.GetApp(I).AppId + ' ('+AppList.GetApp(I).ProductName+')';
      frm := TframeUserAppSettings.Create(Self);
      frm.Name := 'frameUserAppSettings'+IntToStr(I);
      frm.Parent := ts;
      frm.Init(conUsers, AppList.GetApp(I).AppId, tblUsers.FieldByName('Login_id').AsString, CheckEdit);
      ts.FFrame := frm;
    end;
  end;
end;

procedure TfrmvtUsers.tblUsersAfterInsert(DataSet: TDataSet);
begin
  tblUsers.FieldByName('Login_Id').AsString := UpperCase(FNewUserName);
  tblUsers.FieldByName('M_Office').AsString := 'MAIN';
  tblUsers.FieldByName('Branch').AsString := '00';
  tblUsers.FieldByName('Inv_No').AsString := '000';
end;

procedure TfrmvtUsers.tblUsersAfterScroll(DataSet: TDataSet);
var
  I: Integer;
begin
  for I := 0 to pgcMulti.PageCount - 1 do
    if (pgcMulti.Pages[I] is TTabSheetEx) and
        assigned(TTabSheetEx(pgcMulti.Pages[I]).FFrame) then
      TTabSheetEx(pgcMulti.Pages[I]).FFrame.User := tblUsers.FieldByName('Login_id').AsString;
end;

procedure TfrmvtUsers.tblUsersBeforeDelete(DataSet: TDataSet);
begin
  if UpperCase(tblUsers.FieldByName('Login_id').AsString) = 'ADMIN' then
  begin
    ShowMessage('You cannot delete the ADMIN user'+Chr(13)+
                'You should only change the password');
    abort;
  end;
  if MessageDlg('Delete this user?', mtConfirmation, [mbYes, mbCancel], 0) = mrYes then
    TAppProfiles.DeleteAllApp(conUsers, tblUsers.FieldByName('Login_id').AsString)
  else
    abort;
end;

procedure TfrmvtUsers.tblUsersBeforeInsert(DataSet: TDataSet);
var
  V: Array of string;
begin
  SetLength(V, 1);
  V[0] := '<New User>';
  if not InputQuery('Create New User', ['Enter unique user name'], V,
     function(const Values: array of string): Boolean
     begin
       if Trim(V[0]) = '' then
       begin
         MessageDlg('Login is required!', mtWarning, [mbOk], 0);
         Exit(False);
       end
       else if tblUsers.Locate('Login_id', Trim(V[0]), [loCaseInsensitive]) then
       begin
         MessageDlg('This name is Used!', mtWarning, [mbOk], 0);
         Exit(False);
       end;
       Result := True;
     end) then
    Abort
  else
    FNewUserName := V[0];
end;

procedure TfrmvtUsers.tblUsersBeforeScroll(DataSet: TDataSet);
var
  I: Integer;
begin
  for I := 0 to pgcMulti.PageCount - 1 do
    if not TTabSheetEx(pgcMulti.Pages[i]).FFrame.Save then
      Abort;
end;

function TfrmvtUsers.CheckEdit(const AAsk: Boolean = False): Boolean;
var
  N: TModalResult;
  C: TWinControl;
  ListChanged, CurrentUserChanged: Boolean;
  I: Integer;
begin
  ListChanged := False;
  for I := 0 to pgcMulti.PageCount - 1 do
    if TTabSheetEx(pgcMulti.Pages[i]).FFrame.Changed then
    begin
      ListChanged := True;
      Break;
    end;
  if not (tblUsers.State in dsEditModes) and
     not ListChanged then
    Exit(true);
  C := ActiveControl;
  ActiveControl := nil;
  if (C <> nil) and C.CanFocus then
  try
    C.SetFocus;
  except
  end;
  if AAsk then
    N := MessageDlg('Save changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0)
  else
    N := mrYes;
  case N of
    mrYes:
      Begin
        Result := False;
        if tblUsers.State in dsEditModes then
        begin
          If Trim(tblUsers.FieldByName('Login_id').AsString) = '' then
          begin
            ShowMessage ('Login Id required');
            edtLogin_id.SetFocus;
          end
          else
          If Trim(tblUsers.FieldByName('PSWD').AsString) = '' then
          begin
            ShowMessage ('Password required');
            edtPswd.SetFocus;
          end;
          If Trim(tblUsers.FieldByName('Prep_Name').AsString) = '' then
          begin
            ShowMessage('Full name required');
            edtPrep_Name.SetFocus;
          end
          else
          begin
            try
              tblUsers.Post;
              Result := True;
            except on E: Exception do
              Begin
                MessageDlg(E.Message, mtError, [mbOk], 0);
              End;
            end;
          end;
        end
        else
          Result := True;
        if ListChanged and Result then
        begin
          for I := 0 to pgcMulti.PageCount - 1 do
            if not TTabSheetEx(pgcMulti.Pages[i]).FFrame.Save then
            begin
              Result := False;
              Break;
            end;
        end;
        if Result and (User.UserName = tblUsers.FieldByName('Login_id').AsString) then
          User.LoadUserProfile(tblUsers.FieldByName('Login_id').AsString, True);//20170115 Igor
      End;
    mrNo:
      Begin
        tblUsers.Cancel;
        Result := True;
      End;
    mrCancel:
      Begin
        tblUsers.Cancel;
        Result := False;
      End;
  end;
end;

procedure TfrmvtUsers.AddBtnClick(Sender: TObject);
var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    if Sender = btnCopyUser then
      for I := 0 to tblUsers.FieldCount - 1 do
        SL.Values[tblUsers.Fields[I].FieldName] := tblUsers.Fields[I].AsString;
    tblUsers.Append;
    if Sender = btnCopyUser then
    Begin
      for I := 0 to tblUsers.FieldCount - 1 do
        if not SameText(tblUsers.Fields[I].FieldName, 'Login_Id') then
          tblUsers.Fields[I].Value := SL.Values[tblUsers.Fields[I].FieldName];
      TAppProfiles.CloneSettings(conUsers, SL.Values['Login_Id'], tblUsers.FieldByName('Login_Id').AsString);
    end;
    EdtPREP_NAME.SetFocus;
  finally
    SL.Free;
  end;
end;

procedure TfrmvtUsers.DeleteBtnClick(Sender: TObject);
begin
  tblUsers.Delete;
end;

end.
