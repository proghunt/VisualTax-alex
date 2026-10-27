{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{            FireDAC FireMonkey Login dialog            }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFMXfLogin"'}

unit uADGUIxFMXfLogin;

interface

uses
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes, IniFiles, 
{$IFDEF AnyDAC_FPC}
  FMX_Forms, FMX_Dialogs, FMX_Edit, FMX_ListBox, FMX_Controls, FMX_Objects, 
    FMX_Types, FMX_Effects,
{$ELSE}
  FMX.Forms, FMX.Dialogs, FMX.Edit, FMX.ListBox, FMX.Controls, FMX.Objects, 
    FMX.Types, FMX.Effects,
  {$IFDEF AnyDAC_D18}
    FMX.StdCtrls,
  {$ENDIF}
{$ENDIF}
  uADStanIntf,
  uADGUIxIntf, uADGUIxManager, uADGUIxFMXfOptsBase;

type
  TfrmADGUIxFMXLogin = class(TfrmADGUIxFMXOptsBase)
    pnlLogin: TPanel;
    pnlControls: TPanel;
    pnlHistory: TPanel;
    Label1: TLabel;
    cbxProfiles: TComboBox;
    pnlChngPwd: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    edtNewPassword: TEdit;
    edtNewPassword2: TEdit;
    OpenDialog1: TOpenDialog;
    Line5: TLine;
    Line6: TLine;
    imgEnabled: TImage;
    imgDisabled: TImage;
    imgOpen: TImage;
    pnlButton: TPanel;
    pnlCombo: TPanel;
    ShadowEffect1: TShadowEffect;
    procedure FormCreate(Sender: TObject);
    procedure cbxProfilesClick(Sender: TObject);
    procedure edtNewPasswordChange(Sender: TObject);
    procedure cbxProfilesChange(Sender: TObject);
    procedure FileEditClick(Sender: TObject);
    procedure imgEnabledClick(Sender: TObject);
  private
    { Private declarations }
    FAddToOptionsHeight: Integer;
    FParams: array of TADLoginItem;
    FConnectionDef: IADStanConnectionDef;
    FVisibleItems: Classes.TStrings;
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
  frmADGUIxFormsLogin: TfrmADGUIxFMXLogin;

implementation

uses
{$IFDEF MSWINDOWS}
  Registry,
{$ENDIF}
  UITypes,
  uADStanConst, uADStanError, uADStanUtil, uADStanFactory, uADStanResStrs,
  uADPhysIntf;

{$IFNDEF AnyDAC_FPC}
{$R *.fmx}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TfrmADGUIxFMXLogin                                                            }
{-------------------------------------------------------------------------------}
function TfrmADGUIxFMXLogin.ExecuteLogin: Boolean;
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
  oChk: TSwitch;
  oBEdit: TEdit;
  oImg: TImage;
  oEff: TShadowEffect;
  oStream: TMemoryStream;
  oComp: TComponent;
  oActiveCtrl: TStyledControl;
  oList: TADStringList;
  oWait: IADGUIxWaitCursor;
  pParam: PADLoginItem;
  oIni: TCustomIniFile;

  procedure AddItem(const AName, AType, ACaption: String; AOrder: Integer;
    const AValue: String);
  var
    i: Integer;
    s, sCaption: String;
    lOk: Boolean;
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
      pParam := @FParams[Length(FParams) - 1];
      pParam^.FParam := AName;
      pParam^.FType := AType;
      pParam^.FCaption := sCaption;
      pParam^.FOrder := AOrder;
      pParam^.FValue := AValue;
    end;
  end;

begin
  if FConnectionDef = nil then begin
    Result := False;
    Exit;
  end;

  pnlChngPwd.Visible := False;
  pnlLogin.Align := TAlignLayout.alClient;
  pnlLogin.Visible := True;
  lblPrompt.Text := S_AD_LoginCredentials;

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

  while pnlControls.ComponentCount > 0 do
    ADFree(pnlControls.Components[0]);

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
    oPanel.StyleLookup := 'backgroundstyle';
    oPanel.Parent := pnlControls;
    oPanel.Position.Y := i * 26;
    oPanel.Position.X := 3;
    oPanel.Height := 26;
    oPanel.Width := pnlControls.Width;

    oLabel := TLabel.Create(Self);
    oLabel.Parent := oPanel;
    oLabel.Position.Y := 5;
    oLabel.Position.X := 3;
    oLabel.Text := FParams[i].FCaption + ':';

    if (FParams[i].FType = '@L') or (FParams[i].FType = '@Y') then begin
      oChk := TSwitch.Create(Self);
      oChk.Parent := oPanel;
      oChk.Position.Y := 2;
      oChk.Position.X := 206;
      oChk.Width := 40;
      oChk.Height := 20;
      oChk.Tag := i;
      oChk.IsChecked := (CompareText(FParams[i].FValue, S_AD_True) = 0) or
        (CompareText(FParams[i].FValue, S_AD_Yes) = 0);
    end
    else if Copy(FParams[i].FType, 1, 2) = '@F' then begin
      oBEdit := TEdit.Create(Self);
      oBEdit.Parent := oPanel;
      oBEdit.Position.Y := 2;
      oBEdit.Position.X := 80;
      oBEdit.Width := 166;
      oBEdit.Tag := i;
      oImg := TImage.Create(Self);
      oImg.Parent := oBEdit;
      oImg.Width := 22;
      oImg.Align := TAlignLayout.alRight;
      oImg.OnClick := FileEditClick;
      oEff := TShadowEffect.Create(Self);
      oEff.Parent := oImg;
      oEff.Trigger := 'IsMouseOver=true';
      oStream := TMemoryStream.Create;
      try
        imgOpen.Bitmap.SaveToStream(oStream);
        oImg.Bitmap.LoadFromStream(oStream);
      finally
        ADFree(oStream);
      end;
      ADGUIxFMXSetupEditor(nil, nil, oBEdit, OpenDialog1, FParams[i].FType);
      oBEdit.Text := FParams[i].FValue;
      if (oBEdit.Text = '') and (oActiveCtrl = nil) then
        oActiveCtrl := oBEdit;
    end
    else if (FParams[i].FType <> '@S') and (FParams[i].FType <> '@I')
            {$IFNDEF AnyDAC_D12} and (Copy(FParams[i].FType, 1, 2) <> '@F') {$ENDIF} then begin
      oCombo := TComboBox.Create(Self);
      oCombo.Parent := oPanel;
      oCombo.Position.Y := 2;
      oCombo.Position.X := 80;
      oCombo.Width := 166;
      oCombo.Tag := i;
      ADGUIxFMXSetupEditor(oCombo, nil, nil, nil, FParams[i].FType);
      oCombo.ItemIndex := oCombo.Items.IndexOf(FParams[i].FValue);
      if (oCombo.ItemIndex = -1) and (FParams[i].FValue <> '') then begin
        oCombo.Items.Add(FParams[i].FValue);
        oCombo.ItemIndex := oCombo.Items.Count - 1;
      end;
      if (oCombo.ItemIndex = -1) and (oActiveCtrl = nil) then
        oActiveCtrl := oCombo;
    end
    else begin
      oEdit := TEdit.Create(Self);
      if FParams[i].FParam = S_AD_ConnParam_Common_Password then
        oEdit.Password := True;
      oEdit.Parent := oPanel;
      oEdit.Position.Y := 2;
      oEdit.Position.X := 80;
      oEdit.Width := 166;
      oEdit.Tag := i;
      oEdit.Text := FParams[i].FValue;
      if (oEdit.Text = '') and (oActiveCtrl = nil) then
        oActiveCtrl := oEdit;
    end;
  end;

  ClientHeight := FAddToOptionsHeight + Length(FParams) * 26;
  Width := 100 + 160;
  if oActiveCtrl = nil then
    ActiveControl := btnOk
  else
    ActiveControl := oActiveCtrl;

  cbxProfiles.Items.Clear;
  if FHistoryEnabled then begin
    oIni := CreateIniFile;
    try
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
        cbxProfiles.Items.Assign(oList);
        cbxProfiles.ItemIndex := cbxProfiles.Items.IndexOf(FConnectionDef.DriverID + ' - ' +
          AnsiUpperCase(FConnectionDef.Database) + ' - ' + FConnectionDef.UserName);
        cbxProfiles.OnChange(nil);
      finally
        ADFree(oList);
      end;
    finally
      ADFree(oIni);
    end
  end
  else begin
    Height := Height - Trunc(pnlHistory.Height);
    pnlHistory.Visible := False;
  end;

  ADCreateInterface(IADGUIxWaitCursor, oWait);
  try
    oWait.PopWait;
    Result := (ShowModal = mrOK);
  finally
    oWait.PushWait;
  end;

  if Result then begin
    for i := 0 to pnlControls.ComponentCount - 1 do begin
      oComp := pnlControls.Components[i];
      if oComp is TCheckBox then
        if FParams[oComp.Tag].FType = '@Y' then
          FConnectionDef.AsYesNo[FParams[oComp.Tag].FParam] := TCheckBox(oComp).IsChecked
        else
          FConnectionDef.AsBoolean[FParams[oComp.Tag].FParam] := TCheckBox(oComp).IsChecked
      else if oComp is TEdit then
        FConnectionDef.AsString[FParams[oComp.Tag].FParam] := TEdit(oComp).Text
      else if oComp is TComboBox then
        if TComboBox(oComp).ItemIndex <> -1 then
          FConnectionDef.AsString[FParams[oComp.Tag].FParam] := TComboBox(oComp).Selected.Text;
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
function TfrmADGUIxFMXLogin.ExecuteChngPwd: Boolean;
begin
  ClientHeight := Trunc(pnlButtons.Height + pnlTop.Height + pnlChngPwd.Height);
  Width := 250;

  pnlLogin.Visible := False;
  pnlChngPwd.Align := TALignLayout.alClient;
  pnlChngPwd.Visible := True;
  lblPrompt.Text := S_AD_LoginNewPassword;

  btnOk.Enabled := False;
  ActiveControl := edtNewPassword;

  Result := (ShowModal = mrOK);
  if Result then
    FConnectionDef.NewPassword := edtNewPassword.Text;
end;

{-------------------------------------------------------------------------------}
function TfrmADGUIxFMXLogin.CreateIniFile: TCustomIniFile;
begin
  Result := nil;
  if FHistoryStorage = hsRegistry then
{$IFDEF MSWINDOWS}
    Result := TRegistryIniFile.Create(FHistoryKey)
{$ELSE}
    ADCapabilityNotSupported(nil, [S_AD_LGUIx, S_AD_LGUIx_PForms])
{$ENDIF}
  else if FHistoryStorage = hsFile then
    Result := TADIniFile.Create(FHistoryKey);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXLogin.FormCreate(Sender: TObject);
begin
  FAddToOptionsHeight := Trunc(pnlButtons.Height + pnlTop.Height +
    pnlHistory.Height);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXLogin.imgEnabledClick(Sender: TObject);
var
  oIni: TCustomIniFile;
begin
  oIni := CreateIniFile;
  try
    if cbxProfiles.ItemIndex <> -1 then begin
      oIni.EraseSection(ADStrReplace(cbxProfiles.Selected.Text, '\', '/'));
      cbxProfiles.Items.Delete(cbxProfiles.ItemIndex);
      cbxProfiles.ItemIndex := -1;
    end;
  finally
    ADFree(oIni);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXLogin.cbxProfilesClick(Sender: TObject);
var
  i: Integer;
  oComp: TComponent;
  sName, sVal: String;
  oIni: TCustomIniFile;
  oCombo: TComboBox;
begin
  oIni := CreateIniFile;
  try
    if cbxProfiles.ItemIndex <> -1 then begin
      sName := ADStrReplace(cbxProfiles.Selected.Text, '\', '/');
      for i := 0 to pnlControls.ComponentCount - 1 do begin
        oComp := pnlControls.Components[i];
        if oComp is TCheckBox then
          TCheckBox(oComp).IsChecked := oIni.ReadBool(sName,
            FParams[oComp.Tag].FParam, False)
        else begin
          sVal := oIni.ReadString(sName, FParams[oComp.Tag].FParam, '');
          if oComp is TEdit then
            TEdit(oComp).Text := sVal
          else if oComp is TComboBox then begin
            oCombo := TComboBox(oComp);
            oCombo.ItemIndex := oCombo.Items.IndexOf(sVal);
          end;
        end;
      end;
    end;
  finally
    ADFree(oIni);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXLogin.cbxProfilesChange(Sender: TObject);
begin
  imgEnabled.Visible := cbxProfiles.ItemIndex <> -1;
  imgDisabled.Enabled := not imgEnabled.Visible;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXLogin.edtNewPasswordChange(Sender: TObject);
begin
  btnOk.Enabled := (edtNewPassword.Text = edtNewPassword2.Text);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXLogin.FileEditClick(Sender: TObject);
var
  oEdit: TEdit;
begin
  oEdit := TEdit(TImage(Sender).Parent);
  OpenDialog1.FileName := oEdit.Text;
  if OpenDialog1.Execute then
    TCustomEdit(Sender).Text := OpenDialog1.FileName;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFMXLoginDialogImpl                                                     }
{-------------------------------------------------------------------------------}
type
  TADGUIxFMXLoginDialogImpl = class(TADGUIxLoginDialogImplBase)
  private
    function CreateDialog: TfrmADGUIxFMXLogin;
  protected
    function ExecuteLogin: Boolean; override;
    function ExecuteChngPwd: Boolean; override;
  end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXLoginDialogImpl.CreateDialog: TfrmADGUIxFMXLogin;
begin
  Result := TfrmADGUIxFMXLogin.Create(Application);
  Result.FConnectionDef := FConnectionDef;
  Result.Caption := FCaption;
  Result.FVisibleItems := FVisibleItems;
  Result.FHistoryEnabled := FHistoryEnabled;
  Result.FHistoryWithPassword := FHistoryWithPassword;
  Result.FHistoryStorage := FHistoryStorage;
  Result.FHistoryKey := FHistoryKey;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXLoginDialogImpl.ExecuteLogin: Boolean;
var
  oLogin: TfrmADGUIxFMXLogin;
begin
  oLogin := CreateDialog;
  Result := oLogin.ExecuteLogin;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXLoginDialogImpl.ExecuteChngPwd: Boolean;
var
  oLogin: TfrmADGUIxFMXLogin;
begin
  oLogin := CreateDialog;
  Result := oLogin.ExecuteChngPwd;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  oFact := TADMultyInstanceFactory.Create(TADGUIxFMXLoginDialogImpl,
    IADGUIxLoginDialog, C_AD_GUIxFMXProvider, 'uADGUIxFMXfLogin');

finalization
  ADReleaseFactory(oFact);

end.
