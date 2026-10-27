{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                 FireDAC Login dialog                  }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFormsfLogin"'}

unit uADGUIxFormsfLogin;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Buttons, ExtCtrls,
    IniFiles, Dialogs, ImgList,
  uADStanIntf,
  uADGUIxIntf, uADGUIxManager, uADGUIxFormsfOptsBase;

type
  TfrmADGUIxFormsLogin = class(TfrmADGUIxFormsOptsBase)
    pnlLogin: TPanel;
    pnlControls: TPanel;
    pnlHistory: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    cbxProfiles: TComboBox;
    Bevel1: TBevel;
    pnlChngPwd: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    edtNewPassword: TEdit;
    edtNewPassword2: TEdit;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure cbxProfilesClick(Sender: TObject);
    procedure edtNewPasswordChange(Sender: TObject);
    procedure cbxProfilesChange(Sender: TObject);
    procedure FileEditClick(Sender: TObject);
  private
    { Private declarations }
    FAddToOptionsHeight: Integer;
    FParams: array of TADLoginItem;
    FConnectionDef: IADStanConnectionDef;
    FVisibleItems: TStrings;
    FHistoryEnabled: Boolean;
    FHistoryWithPassword: Boolean;
    FHistoryStorage: TADGUIxLoginHistoryStorage;
    FHistoryKey: String;
    function CreateIniFile: TCustomIniFile;
  public
    { Public declarations }
    function ExecuteLogin: Boolean;
    function ExecuteChngPwd: Boolean;
  end;

var
  frmADGUIxFormsLogin: TfrmADGUIxFormsLogin;

implementation

uses
{$IFDEF MSWINDOWS}
  Registry,
{$ENDIF}
  uADStanConst, uADStanError, uADStanUtil, uADStanFactory, uADStanResStrs,
  uADPhysIntf,
  uADGUIxFormsControls;

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TfrmADGUIxFormsLogin                                                          }
{-------------------------------------------------------------------------------}
type
  __TControl = class(TControl)
  end;

{-------------------------------------------------------------------------------}
function TfrmADGUIxFormsLogin.ExecuteLogin: Boolean;
var
  oMeta: IADPhysManagerMetadata;
  oDrv: IADPhysDriverMetadata;
  i, j, iLogin: Integer;
  rTmp: TADLoginItem;
  sName, sType, sDef, sCaption: String;
  oPanel: TPanel;
  oLabel: TLabel;
  oCombo: TComboBox;
  oEdit: TEdit;
  oChk: TCheckBox;
{$IFDEF AnyDAC_D12}
  oBEdit: TButtonedEdit;
{$ENDIF}
  oCtrl: TControl;
  oActiveCtrl: TWinControl;
  oList: TADStringList;
  oIni: TCustomIniFile;

  procedure AddItem(const AName, AType, ACaption: String; AOrder: Integer;
    const AValue: String);
  var
    i: Integer;
    s, sCaption: String;
    lOk: Boolean;
    pItem: PADLoginItem;
  begin
    sCaption := ACaption;
    lOk := FVisibleItems.Count = 0;
    if not lOk then begin
      for i := 0 to FVisibleItems.Count - 1 do
        if CompareText(ADNameFromIndex(FVisibleItems, i), AName) = 0 then begin
          s := ADValueFromIndex(FVisibleItems, i);
          if s <> '' then
            sCaption := s;
          lOk := True;
          Break;
        end;
      if not lOk then begin
        s := Trim(FVisibleItems.Text);
        lOk := (s = '') or (s = '*');
      end;
    end;
    if lOk then begin
      SetLength(FParams, Length(FParams) + 1);
      pItem := @FParams[Length(FParams) - 1];
      pItem^.FParam := AName;
      pItem^.FType := AType;
      pItem^.FCaption := sCaption;
      pItem^.FOrder := AOrder;
      pItem^.FValue := AValue;
    end;
  end;

begin
  if FConnectionDef = nil then begin
    Result := False;
    Exit;
  end;

  pnlChngPwd.Visible := False;
  pnlLogin.Align := alClient;
  pnlLogin.Visible := True;
  lblPrompt.Caption := S_AD_LoginCredentials;

  SetLength(FParams, 0);
  if ADPhysManager.State = dmsInactive then
    ADPhysManager.Open;
  ADPhysManager.CreateMetadata(oMeta);
  oMeta.CreateDriverMetadata(FConnectionDef.DriverID, oDrv);
  for i := 0 to oDrv.GetConnParamCount(FConnectionDef.Params) - 1 do begin
    oDrv.GetConnParams(FConnectionDef.Params, i, sName, sType, sDef, sCaption, iLogin);
    if iLogin <> -1 then
      AddItem(sName, sType, sCaption, iLogin, FConnectionDef.AsString[sName]);
  end;
  if Length(FParams) = 0 then begin
    Result := True;
    Exit;
  end;

  while pnlControls.ControlCount > 0 do
    pnlControls.Controls[0].Free;

  for i := 0 to Length(FParams) - 1 do
    for j := i to Length(FParams) - 2 do
      if FParams[j].FOrder > FParams[j + 1].FOrder then begin
        rTmp := FParams[j + 1];
        FParams[j + 1] := FParams[j];
        FParams[j] := rTmp;
      end;

  oActiveCtrl := nil;
  for i := 0 to Length(FParams) - 1 do begin
    oPanel := TPanel.Create(Self);
    oPanel.BevelInner := bvNone;
    oPanel.BevelOuter := bvNone;
    oPanel.BorderStyle := bsNone;
    oPanel.Parent := pnlControls;
    oPanel.Top := i * 26;
    oPanel.Height := 26;
    oPanel.Left := 3;
    oPanel.Width := pnlControls.ClientWidth;

    oLabel := TLabel.Create(Self);
    oLabel.Parent := oPanel;
    oLabel.Top := 5;
    oLabel.Left := 3;
    oLabel.Caption := '&' + FParams[i].FCaption + ':';

    if (FParams[i].FType = '@L') or (FParams[i].FType = '@Y') then begin
      oChk := TCheckBox.Create(Self);
      oChk.Parent := oPanel;
      oChk.Top := 4;
      oChk.Left := 70;
      oChk.Tag := i;
      oChk.Checked := (CompareText(FParams[i].FValue, S_AD_True) = 0) or
        (CompareText(FParams[i].FValue, S_AD_Yes) = 0);
      oLabel.FocusControl := oChk;
    end
{$IFDEF AnyDAC_D12}
    else if Copy(FParams[i].FType, 1, 2) = '@F' then begin
      oBEdit := TButtonedEdit.Create(Self);
      oBEdit.Parent := oPanel;
      oBEdit.Top := 2;
      oBEdit.Left := 70;
      oBEdit.Width := 166;
      oBEdit.Tag := i;
      oBEdit.Images := ImageList1;
      oBEdit.RightButton.ImageIndex := 0;
      oBEdit.RightButton.Visible := True;
      oBEdit.OnRightButtonClick := FileEditClick;
      ADGUIxSetupEditor(nil, nil, oBEdit, OpenDialog1, FParams[i].FType);
      oBEdit.Text := FParams[i].FValue;
      if (oBEdit.Text = '') and (oActiveCtrl = nil) then
        oActiveCtrl := oBEdit;
      oLabel.FocusControl := oBEdit;
    end
{$ENDIF}
    else if (FParams[i].FType <> '@S') and (FParams[i].FType <> '@I')
            {$IFNDEF AnyDAC_D12} and (Copy(FParams[i].FType, 1, 2) <> '@F') {$ENDIF} then begin
      oCombo := TComboBox.Create(Self);
      oCombo.Parent := oPanel;
      oCombo.Top := 2;
      oCombo.Left := 70;
      oCombo.Width := 166;
      oCombo.Tag := i;
      ADGUIxSetupEditor(oCombo, nil, nil, nil, FParams[i].FType);
      oCombo.Text := FParams[i].FValue;
      if (oCombo.Text = '') and (oActiveCtrl = nil) then
        oActiveCtrl := oCombo;
      oLabel.FocusControl := oCombo;
    end
    else begin
      oEdit := TEdit.Create(Self);
      if FParams[i].FParam = S_AD_ConnParam_Common_Password then
        oEdit.PasswordChar := '#';
      oEdit.Parent := oPanel;
      oEdit.Top := 2;
      oEdit.Left := 70;
      oEdit.Width := 166;
      oEdit.Tag := i;
      oEdit.Text := FParams[i].FValue;
      if (oEdit.Text = '') and (oActiveCtrl = nil) then
        oActiveCtrl := oEdit;
      oLabel.FocusControl := oEdit;
    end;
  end;

  ClientHeight := FAddToOptionsHeight + Length(FParams) * 26;
  Width := 100 + 150;
  if oActiveCtrl = nil then
    ActiveControl := btnOk
  else
    ActiveControl := oActiveCtrl;

  cbxProfiles.Items.Clear;
  if FHistoryEnabled then begin
    oIni := CreateIniFile;
    oList := TADStringList.Create;
    try
      oIni.ReadSections(oList);
      i := 0;
      while i < oList.Count do
        if Pos(FConnectionDef.DriverID + ' - ', oList[i]) = 0 then
          oList.Delete(i)
        else begin
          oList[i] := ADStrReplace(oList[i], '/', '\');
          Inc(i);
        end;
      cbxProfiles.Items := oList;
      cbxProfiles.ItemIndex := cbxProfiles.Items.IndexOf(FConnectionDef.DriverID + ' - ' +
        AnsiUpperCase(FConnectionDef.Database) + ' - ' + FConnectionDef.UserName);
{$IFDEF MSWINDOWS}
      SendMessage(cbxProfiles.Handle, CB_SETDROPPEDWIDTH, Width, 0);
{$ENDIF}
      cbxProfiles.OnChange(nil);
    finally
      ADFree(oList);
      ADFree(oIni);
    end
  end
  else begin
    Height := Height - pnlHistory.Height;
    pnlHistory.Visible := False;
  end;

  Result := (ShowModal = mrOK);

  if Result then begin
    for i := 0 to pnlControls.ControlCount - 1 do begin
      oCtrl := TPanel(pnlControls.Controls[i]).Controls[1];
      if oCtrl is TCheckBox then
        if FParams[oCtrl.Tag].FType = '@Y' then
          FConnectionDef.AsYesNo[FParams[oCtrl.Tag].FParam] := TCheckBox(oCtrl).Checked
        else
          FConnectionDef.AsBoolean[FParams[oCtrl.Tag].FParam] := TCheckBox(oCtrl).Checked
      else
        FConnectionDef.AsString[FParams[oCtrl.Tag].FParam] := __TControl(oCtrl).Caption;
    end;

    if FHistoryEnabled then begin
      oIni := CreateIniFile;
      try
        sName := FConnectionDef.DriverID + ' - ' +
          ADStrReplace(AnsiUpperCase(FConnectionDef.Database), '\', '/') + ' - ' +
          FConnectionDef.UserName;
        oIni.EraseSection(sName);
        for i := 0 to Length(FParams) - 1 do
          if FHistoryWithPassword or
             (CompareText(FParams[i].FParam, S_AD_ConnParam_Common_Password) <> 0) then
            oIni.WriteString(sName, FParams[i].FParam, FConnectionDef.AsString[FParams[i].FParam]);
      finally
        ADFree(oIni);
      end;
    end;

  end;
  SetLength(FParams, 0);
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
function TfrmADGUIxFormsLogin.ExecuteChngPwd: Boolean;
begin
  ClientHeight := pnlButtons.Height + pnlTop.Height + pnlChngPwd.Height;
  Width := 250;

  pnlLogin.Visible := False;
  pnlChngPwd.Align := alClient;
  pnlChngPwd.Visible := True;
  lblPrompt.Caption := S_AD_LoginNewPassword;

  btnOk.Enabled := False;
  ActiveControl := edtNewPassword;

  Result := (ShowModal = mrOK);
  if Result then
    FConnectionDef.NewPassword := edtNewPassword.Text;
end;

{-------------------------------------------------------------------------------}
function TfrmADGUIxFormsLogin.CreateIniFile: TCustomIniFile;
begin
  if FHistoryStorage = hsRegistry then
{$IFDEF MSWINDOWS}
    Result := TRegistryIniFile.Create(FHistoryKey)
{$ELSE}
    ADCapabilityNotSupported(nil, [S_AD_LGUIx, S_AD_LGUIx_PForms])
{$ENDIF}
  else if FHistoryStorage = hsFile then
    Result := TADIniFile.Create(FHistoryKey)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.FormCreate(Sender: TObject);
begin
  FAddToOptionsHeight := pnlButtons.Height + pnlTop.Height + pnlHistory.Height;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.SpeedButton1Click(Sender: TObject);
var
  oIni: TCustomIniFile;
begin
  oIni := CreateIniFile;
  try
    oIni.EraseSection(ADStrReplace(cbxProfiles.Text, '\', '/'));
    cbxProfiles.Items.Delete(cbxProfiles.ItemIndex);
    cbxProfiles.ItemIndex := -1;
    cbxProfiles.Text := '';
  finally
    ADFree(oIni);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.cbxProfilesClick(Sender: TObject);
var
  i: Integer;
  oCtrl: TControl;
  sName: String;
  oIni: TCustomIniFile;
begin
  oIni := CreateIniFile;
  try
    sName := ADStrReplace(cbxProfiles.Text, '\', '/');
    for i := 0 to pnlControls.ControlCount - 1 do begin
      oCtrl := TPanel(pnlControls.Controls[i]).Controls[1];
      __TControl(oCtrl).Caption := oIni.ReadString(sName, FParams[oCtrl.Tag].FParam, '');
    end;
  finally
    ADFree(oIni);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.cbxProfilesChange(Sender: TObject);
begin
  SpeedButton1.Enabled := cbxProfiles.Text <> '';
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.edtNewPasswordChange(Sender: TObject);
begin
  btnOk.Enabled := (edtNewPassword.Text = edtNewPassword2.Text);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsLogin.FileEditClick(Sender: TObject);
begin
  OpenDialog1.FileName := TCustomEdit(Sender).Text;
  if OpenDialog1.Execute then
    TCustomEdit(Sender).Text := OpenDialog1.FileName;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFormsLoginDialogImpl                                                   }
{-------------------------------------------------------------------------------}
type
  TADGUIxFormsLoginDialogImpl = class(TADGUIxLoginDialogImplBase)
  private
    function CreateDialog: TfrmADGUIxFormsLogin;
  protected
    function ExecuteLogin: Boolean; override;
    function ExecuteChngPwd: Boolean; override;
  end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.CreateDialog: TfrmADGUIxFormsLogin;
begin
  Result := TfrmADGUIxFormsLogin.Create(Application);
  Result.FConnectionDef := FConnectionDef;
  Result.Caption := FCaption;
  Result.FVisibleItems := FVisibleItems;
  Result.FHistoryEnabled := FHistoryEnabled;
  Result.FHistoryWithPassword := FHistoryWithPassword;
  Result.FHistoryStorage := FHistoryStorage;
  Result.FHistoryKey := FHistoryKey;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.ExecuteLogin: Boolean;
var
  oLogin: TfrmADGUIxFormsLogin;
begin
  oLogin := CreateDialog;
  Result := oLogin.ExecuteLogin;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsLoginDialogImpl.ExecuteChngPwd: Boolean;
var
  oLogin: TfrmADGUIxFormsLogin;
begin
  oLogin := CreateDialog;
  Result := oLogin.ExecuteChngPwd;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
{$IFDEF AnyDAC_FPC}
  {$I uADGUIxFormsfLogin.lrs}
{$ENDIF}
  oFact := TADMultyInstanceFactory.Create(TADGUIxFormsLoginDialogImpl,
    IADGUIxLoginDialog, C_AD_GUIxFormsProvider, 'uADGUIxFormsfLogin');
{$IFDEF AnyDAC_FMX}
  oFact.AddFriend(C_AD_GUIxFMXProvider + '=uADGUIxFMXfLogin');
{$ENDIF}

finalization
  ADReleaseFactory(oFact);

end.
