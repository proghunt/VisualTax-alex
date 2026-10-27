unit T3_2026progres;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,T3_2026Declare,Gauges,ComCtrls;


type
  TProgressT3_2026 = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ListBox1: TListBox;
    PauseBtn: TBitBtn;
    Gauge1: TGauge;
    ProgressBar1: TProgressBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure PauseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Progress: TProgressT3_2026;

implementation

{$R *.DFM}

uses vtTrimStr,vtShared;

procedure TProgressT3_2026.BitBtn1Click(Sender: TObject);
begin
AbortSw := True;
Close;
end;

procedure TProgressT3_2026.PauseBtnClick(Sender: TObject);
begin
PauseSw := True;
end;

end.
