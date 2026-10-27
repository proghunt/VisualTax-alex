unit TR_2026About;

interface

uses
  WinProcs, Forms, Controls, StdCtrls, Buttons, ExtCtrls, ShellApi,
  TR_2026Declare, System.Classes;

type
  TAboutTR_2026 = class(TForm)
    Panel1: TPanel;
    OKButton: TBitBtn;
    Copyright: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    AppReleaseLbl: TLabel;
    AppUpdateDateLbl: TLabel;
    TaxYearLbl: TLabel;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    AuthorizationKeyLbl: TLabel;
    Label8: TLabel;
    LicenseLevelLbl: TLabel;
    Bevel1: TBevel;
    webLink: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure webLinkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutTR_2026: TAboutTR_2026;

implementation

{$R *.DFM}

procedure TAboutTR_2026.OKButtonClick(Sender: TObject);
begin
  Release;
end;

procedure TAboutTR_2026.FormCreate(Sender: TObject);
begin
  TaxYearLbl.Caption := AppYear;
  AppReleaseLbl.Caption := 'Release: ' + AppRelease;
  AppUpdateDateLbl.Caption := 'Updated: ' + AppUpdateDate;
  LicenseLevelLbl.Caption := License.Name;
end;

procedure TAboutTR_2026.webLinkClick(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', PChar(webLink.Caption), '', '', SW_SHOWNORMAL);
end;

end.

