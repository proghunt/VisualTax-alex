unit HelperAppUserSettingsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  vtHelperManager, Vcl.ExtCtrls, StrUtils, vtCommon; //20190222 Igor

type
  TframeHelperAppUserSettings = class(TFrame)
    lblUserName: TLabel;
    edtUserName: TEdit;
    Label1: TLabel;
    edtToken: TEdit;
    chbSaveConnectionSettings: TCheckBox;
    Label2: TLabel;
    edtPath: TEdit;
    chbSaveReturnToCloud: TCheckBox;
    grpAdvanced: TGroupBox;
    lblClientIDHelp: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    pnl1: TPanel;
    pnl2: TPanel;
    procedure chbSaveConnectionSettingsClick(Sender: TObject);
    procedure chbSaveReturnToCloudClick(Sender: TObject);
    procedure edtTokenChange(Sender: TObject);
    procedure edtPathChange(Sender: TObject);
    procedure FrameResize(Sender: TObject); //20190222 Igor
  private
    { Private declarations }
    FConfig: THelperAppUserConfig;
    FAdvanced: Boolean;
    procedure SetAdvanced(const Value: Boolean);
  public
    { Public declarations }
    procedure Init(AConfig: THelperAppUserConfig);
    property ShowAdvanced: Boolean read FAdvanced write SetAdvanced;

  end;

implementation

{$R *.dfm}

{ TframeHelperAppUserSettings }

procedure TframeHelperAppUserSettings.chbSaveConnectionSettingsClick(
  Sender: TObject);
begin
  if assigned(FConfig) then
    FConfig.SaveToken := (Sender as TCheckBox).Checked;
end;

procedure TframeHelperAppUserSettings.chbSaveReturnToCloudClick(
  Sender: TObject);
begin
  if assigned(FConfig) then
    FConfig.SaveReturnToCloud := (Sender as TCheckBox).Checked;
end;

procedure TframeHelperAppUserSettings.edtPathChange(Sender: TObject);
begin
  if assigned(FConfig) then
    FConfig.Path := (Sender as TEdit).Text;
end;

procedure TframeHelperAppUserSettings.edtTokenChange(Sender: TObject);
begin
  if assigned(FConfig) then
    FConfig.Token := (Sender as TEdit).Text;
end;

procedure TframeHelperAppUserSettings.FrameResize(Sender: TObject); //20190222 Igor
begin
  AdjustLabelHeight(lbl1);
  AdjustLabelHeight(lbl2);
  AdjustLabelHeight(lblClientIDHelp);
  AdjustLabelHeight(lbl3);
end;

procedure TframeHelperAppUserSettings.Init(AConfig: THelperAppUserConfig);
begin
  edtUserName.Text := AConfig.UserName;
  edtToken.Text := AConfig.Token;
  edtPath.Text := AConfig.Path;
//20190506 Alex >>>
  if edtPath.Text = '' then begin
    edtPath.Text := AConfig.AppId;
  end;
//20190506 Alex <<<
  chbSaveConnectionSettings.Checked := AConfig.SaveToken;
  chbSaveReturnToCloud.Checked := AConfig.SaveReturnToCloud;
  FConfig := AConfig;
  //20190222 Igor >>>
  lbl1.Caption := ReplaceStr(lbl1.Caption, '%APPID%', AConfig.AppId);
  FrameResize(nil);
  //20190222 Igor <<<
end;

procedure TframeHelperAppUserSettings.SetAdvanced(const Value: Boolean);
begin
  FAdvanced := Value;
  grpAdvanced.Visible := FAdvanced;
  FrameResize(nil); //20190222 Igor
end;

end.

