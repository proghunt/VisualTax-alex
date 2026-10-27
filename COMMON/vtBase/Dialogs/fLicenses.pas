unit fLicenses;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, //20160222 Igor
  //UDeclare,TrimStr,
  vtAuthorization;

type
  TAbout = class(TForm)
    Copyright: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label7: TLabel;
    AppReleaseLbl: TLabel;
    TaxYearLbl: TLabel;
    Bevel1: TBevel;
    Label16: TLabel;
    Label21: TLabel;
    ProgramIcon: TImage;
    Label1: TLabel;
    Label26: TLabel;
    Shape1: TShape;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    buSave: TBitBtn;
    buExit: TBitBtn;
    Label44: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    CheckBox7: TCheckBox;
    Label9: TLabel;
    Label50: TLabel;
    sbLics: TScrollBox;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure buSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction); //20190307 Igor
  private

  public

  end;

implementation

{$R *.DFM}

uses
  SysUtils,
  AboutFrame,
  vtMulti, vtCommon, fSplash, //20160222 Igor
  vtDialogs, vtHelperManager; //20180113 Igor

procedure TAbout.FormClose(Sender: TObject; var Action: TCloseAction); //20190307 Igor
begin
  if not LicenseList.Changed then Exit;
  if MessageDlg('Keys are not saved. Are you sure you want to exit?', mtWarning, mbYesNo, 0) <> mrYes then
    Action := caNone
  else
    LicenseList.Load;
end;

procedure TAbout.OKButtonClick(Sender: TObject);
begin
  Release;
end;

procedure TAbout.FormCreate(Sender: TObject);
var
  i: integer;
  s, id, key: string;
  f: TAboutLine;
  lst: TStringList;
  app: TApp;
begin
  TaxYearLbl.Caption := 'Tax Year: ' + ExeYear; //- what?

  //AppReleaseLbl.Caption := 'Release: '+AppRelease; - below
  //AppUpdateDateLbl.Caption := 'Your current update is: '+AppUpdateDate;
  //LastUpdateDoneLbl.Caption:=GetLastUpdCheck;
  s := AppUpdateDate; // GetLastUpdCheck; //20160527 Igor
  if s = '' then
    s := 'Never';
  //LastUpdateDoneLbl.Caption:='Never';
  AppReleaseLbl.Caption := 'Last update Date:  ' + s;

  //LicenseLevelLbl.Caption:=LicenseLevel;
  //AuthorizationKeyLbl.Caption:=LeftStr(GetAuthorizationKey,40);
//now add the apps
  lst := TStringList.Create;
  ReadPgmFile(InstallFile, lst);
  for i := 0 to lst.Count - 1 do
  begin
    id := lst[i];
    if id < 'A' then
      continue; //skip empty lines
    f := TAboutLine.Create(sbLics);
    f.AboutType := taApp; //20180113 Igor
    f.Align := alTop;
    f.Parent := sbLics;
    f.Name := StringReplace(id, '-', '_', []);
    f.lbAppName.Caption := id;
    app := AppList.AppFromID(id);
    f.MyApp := app;
    if app <> nil then
    begin
      f.lbVersion.Caption := app.AppRelease;
      f.swReleased.Checked := True;
      if app.AppUpdateDate = '' then
        f.lbLastUpdate.Caption := 'Never'
      else
        f.lbLastUpdate.Caption := app.AppUpdateDate;
      //do not assume that the app already knows its key!
    end
    else
    begin
      //f.swReleased.Checked := ???;
    end;
    key := LicenseList.Keys[id];
    if key <> '' then
    begin
      f.edKey.Text := key; //trigger change?
      {
        if assigned(app) and app.ValidateKey(key) then begin
        //set the license, to obtain the product name
          app.SetLicense(key);
          f.lbLevel.Caption := app.ProductName;
        end;
      }
    end;
  end;
  lst.Free;
  //20180113 Igor >>>
  // Helpers
  //20191015 Igor >>>
  {
  with HelperManager do
  begin
    for I := 0 to HelperClassList.Count - 1 do
    begin
      id := HelperClassList.Values.ToArray[I];
      if id < 'A' then
        continue; //skip empty lines
      f := TAboutLine.Create(sbLics);
      f.AboutType := taHelper;
      f.HelperID := I;
      f.Align := alTop;
      f.Parent := sbLics;
      f.Name := id;
      f.lbAppName.Caption := id;
      f.lbVersion.Caption := '';
      f.swReleased.Checked := True;
      f.lbLastUpdate.Caption := '';
      key := LicenseList.Keys[id];
      if key <> '' then
        f.edKey.Text := key;
    end;
  end;
  }
  //20191015 Igor <<<
  //20180113 Igor <<<
end;

procedure TAbout.buSaveClick(Sender: TObject);
var I: Integer;
    A: string; //20180113 Igor
    SaveApp: TApp; //20190307 Igor
begin
  //this also happens at program end?
  try
    LicenseList.Save; //20180503 Igor
    ShowTimedMsg('Saved',1800); //20160222 Igor
  except ON E: Exception do
    Begin
      MessageDlg('Error saving data!'+#13#13+
                 E.Message, mtError, [mbOk], 0); //20160222 Igor
    End;
  end;
  //20180113 Igor >>>
  //20190307 Igor >>>
  SaveApp := CurrentApp;
  try
    for A in AppList do
    begin
      CurrentApp := AppList.AppFromID(A);
      CurrentApp.ReloadMainMenu;
    end;
  finally
    CurrentApp := SaveApp;
  end;
  //20190307 Igor <<<
  //20180113 Igor <<<
  Splash.Configure(Splash); //20160222 Igor
end;

end.

