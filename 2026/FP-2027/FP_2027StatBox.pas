unit FP_2027StatBox;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  ExtCtrls,Forms;

type
  TStatusBoxFP_2012 = class(TForm)
    MsgLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  StatusBox: TStatusBoxFP_2012;

implementation

{$R *.DFM}

uses FP_2027Common,FP_2027Declare,vtTrimStr,vtShared;

procedure TStatusBoxFP_2012.FormCreate(Sender: TObject);
begin
MsgLabel.Caption := SomeCaption;
MsgLabel.Refresh;
end;

procedure TStatusBoxFP_2012.FormActivate(Sender: TObject);
begin
{MsgLabel.Caption := SomeCaption;}
end;

end.
