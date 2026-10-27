unit T3_2026STATBOX;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  ExtCtrls,Forms;

type
  TStatusBoxT3_2026 = class(TForm)
    MsgLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  StatusBox: TStatusBoxT3_2026;

implementation

{$R *.DFM}

uses T3_2026Common,T3_2026Declare,vtTrimStr,vtShared;

procedure TStatusBoxT3_2026.FormCreate(Sender: TObject);
begin
MsgLabel.Caption := SomeCaption;
MsgLabel.Refresh;
end;

procedure TStatusBoxT3_2026.FormActivate(Sender: TObject);
begin
{MsgLabel.Caption := SomeCaption;}
end;

end.
