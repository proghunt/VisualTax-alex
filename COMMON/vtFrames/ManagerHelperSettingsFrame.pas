unit ManagerHelperSettingsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  vtHelperManager, HelperSettionsFrame, Vcl.StdCtrls;

type
  TTabSheetExH = class(TTabSheet)
    FFrm: TframeHelperSettings;
  end;

  TframeManagerHelperSettings = class(TFrame)
    Panel1: TPanel;
    pgcHelper: TPageControl;
    chkShowAdvanced: TCheckBox;
    procedure chkShowAdvancedClick(Sender: TObject);
  private
    { Private declarations }
    FConfig: TManagerConfig;
    FAdvanced: Boolean;
    procedure SetAdvanced(const Value: Boolean);
  public
    { Public declarations }
    procedure init(AConfig: TManagerConfig; AAppID, AUserName: String);
    property ShowAdvanced: Boolean read FAdvanced write SetAdvanced;
  end;

implementation

{$R *.dfm}

{ TframeManagerHelperSettings }

procedure TframeManagerHelperSettings.chkShowAdvancedClick(Sender: TObject);
begin
  ShowAdvanced := chkShowAdvanced.Checked;
end;

procedure TframeManagerHelperSettings.init(AConfig: TManagerConfig; AAppID, AUserName: String);
var
  H: THelperConfig;
  ts: TTabSheetExH;
  frm: TframeHelperSettings;
begin
  for H in AConfig do
  begin
    ts := TTabSheetExH.Create(Self);
    ts.PageControl := pgcHelper;
    ts.Caption := H.HelperName;
    frm := TframeHelperSettings.Create(self);
    frm.Name := 'frame_'+H.GetFullName;
    frm.Parent := ts;
    frm.Init(H, AAppID, AUserName);
    ts.FFrm := frm;
  end;
  FConfig := AConfig;
end;

procedure TframeManagerHelperSettings.SetAdvanced(const Value: Boolean);
  var
  I: Integer;
  ts: TTabSheetExH;
begin
  FAdvanced := Value;
  if FAdvanced <> chkShowAdvanced.Checked then
    chkShowAdvanced.Checked := FAdvanced;
  for I := 0 to pgcHelper.PageCount - 1 do
  begin
    ts := TTabSheetExH(pgcHelper.Pages[I]);
    ts.FFrm.ShowAdvanced := FAdvanced;
  end;
end;

end.
