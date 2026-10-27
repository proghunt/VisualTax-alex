unit HelperSettionsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, vtHelperManager, HelperAppSettingsFrame, vtCommon;

type
  TTabSheetExApp = class(TTabSheet)
    FFrm: TframeHelperAppSettings;
  end;

  TframeHelperSettings = class(TFrame)
    Label1: TLabel;
    edtHelperName: TEdit;
    lblClientId: TLabel;
    edtClientID: TEdit;
    chbUseDefaultClientID: TCheckBox;
    Panel1: TPanel;
    pgcApp: TPageControl;
    lblClientIDHelp: TLabel;
    pnl1: TPanel;
    pnlClientId: TPanel;
    pnlAdvanced: TPanel;
    procedure edtClientIDChange(Sender: TObject);
    procedure chbUseDefaultClientIDClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    FConfig: THelperConfig;
    FAdvanced: Boolean;
    procedure SetAdvanced(const Value: Boolean);
  public
    { Public declarations }
    procedure init(AConfig: THelperConfig; AAppID, AUserName: String);
    property ShowAdvanced: Boolean read FAdvanced write SetAdvanced;
  end;

implementation

{$R *.dfm}

{ TframeHelperSettings }

procedure TframeHelperSettings.chbUseDefaultClientIDClick(Sender: TObject);
begin
  if assigned(FConfig) then
  begin
    FConfig.UseDefaultClientID := (Sender as TCheckBox).Checked;
    if (Sender as TCheckBox).Checked then
      edtClientID.Text := FConfig.DefaultClientID
    else
      edtClientID.Text := '';
  end;
end;

procedure TframeHelperSettings.edtClientIDChange(Sender: TObject);
begin
  if assigned(FConfig) then
    FConfig.ClientID := (Sender as TEdit).Text;
end;

procedure TframeHelperSettings.FrameResize(Sender: TObject);
begin
  AdjustLabelHeight(lblClientIDHelp);
  pnlAdvanced.Height := lblClientIDHelp.Height + pnlClientId.Height + 10;
end;

procedure TframeHelperSettings.init(AConfig: THelperConfig; AAppID, AUserName: String);
var
  A: THelperAppConfig;
  ts: TTabSheetExApp;
  frm: TframeHelperAppSettings;
begin
  edtHelperName.Text := AConfig.HelperName;
  chbUseDefaultClientID.Checked := AConfig.UseDefaultClientID;
  if AConfig.UseDefaultClientID then
    edtClientID.Text := AConfig.DefaultClientID
  else
    edtClientID.Text := AConfig.ClientID;

  for A in AConfig do
  begin
    if (A.AppID = AAppID) or (AAppId = '') then
    begin
      ts := TTabSheetExApp.Create(Self);
      ts.PageControl := pgcApp;
      ts.Caption := A.AppID;
      frm := TframeHelperAppSettings.Create(self);
      frm.Name := 'frame_'+A.GetFullName;
      frm.Parent := ts;
      frm.Init(A, AUserName);
      ts.FFrm := frm;
    end;
  end;

  FConfig := AConfig;
  FrameResize(nil);
end;

procedure TframeHelperSettings.SetAdvanced(const Value: Boolean);
var
  I: Integer;
  ts: TTabSheetExApp;
begin
  FAdvanced := Value;
  pnlAdvanced.Visible := FAdvanced;
  for I := 0 to pgcApp.PageCount - 1 do
  begin
    ts := TTabSheetExApp(pgcApp.Pages[I]);
    ts.FFrm.ShowAdvanced := FAdvanced;
  end;
  Application.ProcessMessages;
  FrameResize(nil);
end;

end.
