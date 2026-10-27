unit AboutFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Vcl.Buttons, fSetBN, //20191015 Igor
  vtMulti, Vcl.ExtCtrls, vtHelperManager; //20180113 Igor

type
  TAboutType = (taApp, taHelper); //20180113 Igor

  TAboutLine = class(TFrame)
    lbAppName: TLabel;
    swReleased: TCheckBox;
    lbVersion: TLabel;
    lbLastUpdate: TLabel;
    edKey: TEdit;
    lbLevel: TLabel;
    imgNo: TImage; //20170209 Igor
    imgOk: TImage; //20170209 Igor
    btnSetBN: TSpeedButton; //20191015 Igor
    procedure edKeyChange(Sender: TObject);
    procedure edKeyEnter(Sender: TObject); //20181210 Igor
    procedure edKeyExit(Sender: TObject); //20181210 Igor
    procedure btnSetBNClick(Sender: TObject); //20191015 Igor
  private

  public
    AboutType: TAboutType; //20180113 Igor
    MyApp: TApp;
    HelperID: integer; //20180113 Igor
  end;

implementation

{$R *.DFM}

procedure TAboutLine.btnSetBNClick(Sender: TObject); //20191015 Igor
var cBN: string;
begin
  cBN := MyApp.GetBNText;
  if not DoSetBN(cBN) then Exit;
  MyApp.SetBNText(cBN);
end;

procedure TAboutLine.edKeyChange(Sender: TObject); //20180113 Igor
var
  key: string;
  dDate: TDateTime;
begin
  key := edKey.Text;

  if AboutType = taApp then
  begin
    if not assigned(myApp) then
    begin
      LicenseList.Keys[lbAppName.Caption] := key;
      exit;
    end;

    if MyApp.ValidateKey(key) then
    begin
      LicenseList.Keys[lbAppName.Caption] := key;
      MyApp.SetLicense(key);
      lbLevel.Caption := MyApp.ProductName;
      btnSetBN.Visible := MyApp.IsBNButtonVisible(); //20191015 Igor
      //20171018 Igor >>>
      if MyApp.LimitedFormList <> '' then
        lbLevel.Hint := lbLevel.Caption + '. Allowed forms: ' + MyApp.LimitedFormList
      else
        lbLevel.Hint := lbLevel.Caption;
      //20171018 Igor <<<
    //20170209 Igor >>>
      imgOk.Visible := True;
      imgNo.Visible := False;
    end
    else
    begin
      lbLevel.Caption := '';
      imgOk.Visible := False;
      imgNo.Visible := True;
    end;
  end
  else if AboutType = taHelper then
  begin
    if HelperID < 0 then
    begin
      LicenseList.Keys[lbAppName.Caption] := key;
      Exit;
    end;

    with HelperManager.HelperClassList.Keys.ToArray[HelperID].Create do
    begin
      try
        if ValidateKey(key, ProjectYear) and Assigned(GetLicenseData(key)) then //20190307 Igor //20190627 Igor
        begin
          LicenseList.Keys[lbAppName.Caption] := key;
          lbLevel.Caption := GetLicenseData(key).Name;
          dDate := GetLicenseDemoDate(key);
          if Date > dDate then
            MessageDlg(Format('The license for the demonstration version of the tax module "%s" has expired. '+
                                '"%s" module is disabled.', [Name, Name]), mtWarning, [mbOk], 0)
          else if (Date + 7) >= dDate then
            MessageDlg(Format('The license period for the demo version of the tax module "%s" expires after %d day(s).',
                              [Name, ROUND(dDate - Date)]), mtWarning, [mbOk], 0);
          lbLevel.Hint := lbLevel.Caption;
          lbVersion.Caption := 'Available in '+ GetAllowedApps(key); //20190306 Igor
          imgOk.Visible := True;
          imgNo.Visible := False;
        end
        else
        begin
          lbLevel.Caption := '';
          lbVersion.Caption := ''; //20190306 Igor
          imgOk.Visible := False;
          imgNo.Visible := True;
        end;
      finally
        free;
      end;
    end;
  end;
  //20170209 Igor <<<
end;

procedure TAboutLine.edKeyEnter(Sender: TObject); //20181210 Igor
begin
  if Pos('(enter key)', LowerCase(trim(edKey.Text))) > 0 then
    edKey.Text:= StringReplace(LowerCase(edKey.Text), '(enter key)', '', [rfReplaceAll]);
end;

procedure TAboutLine.edKeyExit(Sender: TObject);

  procedure CleanUpFields(); //20181213 Igor
  begin
    edKey.Text:= '(Enter Key)';
    lbLevel.Caption := 'N/A';
    imgNo.Visible := False;
  end;

  function CheckKey: boolean; //20181213 Igor
  begin
    Result := false;
    if AboutType = taApp then
      Result := MyApp.ValidateKey(Trim(edKey.Text))
    else if AboutType = taHelper then
    begin
      if HelperID >= 0 then
        with HelperManager.HelperClassList.Keys.ToArray[HelperID].Create do
        try
          Result := ValidateKey(Trim(edKey.Text), ProjectYear); //20190307
        finally
          Free;
        end;
    end;
  end;

begin
  if not assigned(myApp) then Exit; //20191216 Igor

  if Trim(edKey.Text) = '' then
  //20181213 Igor >>>
    CleanUpFields()
  else if not CheckKey then
  begin
    ShowMessage('Please enter a correct program key.');
    edKey.Text:= '';

    if LicenseList.Count > 0 then
      if LicenseList.Keys[lbAppName.Caption] <> '' then
        edKey.Text:= LicenseList.Keys[lbAppName.Caption];

    if edKey.Text = '' then
      CleanUpFields();
  end;
  //20181213 Igor <<<
end;

end.

