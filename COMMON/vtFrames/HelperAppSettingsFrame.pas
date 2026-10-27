unit HelperAppSettingsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, vtHelperManager, HelperAppUserSettingsFrame;

type
  TTabSheetExAppUser = class(TTabSheet)
    FFrm: TframeHelperAppUserSettings;
  end;
  TframeHelperAppSettings = class(TFrame)
    Panel1: TPanel;
    Label3: TLabel;
    edtAppID: TEdit;
    pgcUser: TPageControl;
  private
    { Private declarations }
    FConfig: THelperAppConfig;
    FAdvanced: Boolean;
    procedure SetAdvanced(const Value: Boolean);
  public
    { Public declarations }
    procedure Init(AConfig: THelperAppConfig; AUserName: String);
    property ShowAdvanced: Boolean read FAdvanced write SetAdvanced;
  end;

implementation

{$R *.dfm}

{ TFrame1 }

procedure TframeHelperAppSettings.Init(AConfig: THelperAppConfig; AUserName: String);
var
  U: THelperAppUserConfig;
  ts: TTabSheetExAppUser;
  frm: TframeHelperAppUserSettings;
begin
  edtAppID.Text := AConfig.AppID;
  for U in AConfig do
  begin
    if (U.UserName = AUserName) or (AUserName = '') then
    begin
      ts := TTabSheetExAppUser.Create(Self);
      ts.PageControl := pgcUser;
      ts.Caption := U.UserName;
      frm := TframeHelperAppUserSettings.Create(self);
      frm.Name := U.GetFullName;
      frm.Parent := ts;
      frm.Init(U);
      ts.FFrm := frm;
    end;
  end;
  FConfig := AConfig;
end;

procedure TframeHelperAppSettings.SetAdvanced(const Value: Boolean);
var
  I: Integer;
  ts: TTabSheetExAppUser;
begin
  FAdvanced := Value;
  for I := 0 to pgcUser.PageCount - 1 do
  begin
    ts := TTabSheetExAppUser(pgcUser.Pages[I]);
    ts.FFrm.ShowAdvanced := FAdvanced;
  end;
end;

end.
