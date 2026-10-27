unit DummyMDIChild;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, vtChild, Vcl.StdCtrls;

type
  TfrmDummyMDIChild = class(TMyChild)
    procedure FormActivate(Sender: TObject);  //20161128 Igor
  private
    { Private declarations }
  public
    { Public declarations }
    function GetHeaderFrame: TFrame; override; //20170606 Igor
    function GetMonitorFrame: TFrame; override; //20170606 Igor
  end;

var
  frmDummyMDIChild: TfrmDummyMDIChild;

implementation

{$R *.dfm}

procedure TfrmDummyMDIChild.FormActivate(Sender: TObject); //20161128 Igor
begin
  WindowState := wsMaximized;
end;

function TfrmDummyMDIChild.GetHeaderFrame: TFrame;  //20170606 Igor
begin
  Result := nil;
end;

function TfrmDummyMDIChild.GetMonitorFrame: TFrame; //20170606 Igor
begin
  Result := nil;
end;

end.
