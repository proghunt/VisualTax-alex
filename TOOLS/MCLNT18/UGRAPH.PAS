unit Ugraph;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, VBXCtrl, Chart2fx;

type
  TGraphFrm = class(TForm)
    ChartFX1: TChartFX;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GraphFrm: TGraphFrm;

implementation

{$R *.DFM}

procedure TGraphFrm.OKBtnClick(Sender: TObject);
begin
Close;
end;

procedure TGraphFrm.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TGraphFrm.FormCreate(Sender: TObject);
Var i: Integer;
begin
end;

end.
