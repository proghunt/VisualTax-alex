unit Uprogres;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, UDeclare, {VBXCtrl, Bigauge,} Gauges;


type
  TProgress = class(TForm)
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
    procedure BitBtn1Click(Sender: TObject);
    procedure PauseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Progress: TProgress;

implementation

{$R *.DFM}

procedure TProgress.BitBtn1Click(Sender: TObject);
begin
AbortSw := True;
Close;
end;

procedure TProgress.PauseBtnClick(Sender: TObject);
begin
PauseSw := True;
end;

end.
