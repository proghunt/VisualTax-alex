unit TF_2026STATBOX;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  ExtCtrls,Forms;

type
  TStatusBoxTF_2026 = class(TForm)
    MsgLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  StatusBox: TStatusBoxTF_2026;

implementation

{$R *.DFM}

uses TF_2026Common,TF_2026Declare,vtTrimStr,vtShared;

procedure TStatusBoxTF_2026.FormCreate(Sender: TObject);
begin
MsgLabel.Caption := SomeCaption;
MsgLabel.Refresh;
end;

procedure TStatusBoxTF_2026.FormActivate(Sender: TObject);
begin
{MsgLabel.Caption := SomeCaption;}
end;

end.
