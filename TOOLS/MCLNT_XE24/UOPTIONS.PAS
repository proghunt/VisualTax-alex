unit Uoptions;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, DB, DBTables,StdCtrls;


type
  TOptions = class(TForm)
    DirBtn: TBitBtn;
    PrpBtn: TBitBtn;
    DeskTopBtnBitBtn1: TBitBtn;
    ExitBtn: TBitBtn;
    procedure SpeedButton7Click(Sender: TObject);
    procedure PrpBtnClick(Sender: TObject);
    procedure DirBtnClick(Sender: TObject);
    procedure DeskTopBtnBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Options: TOptions;

implementation

{$R *.DFM}

procedure TOptions.SpeedButton7Click(Sender: TObject);
begin
Close;  {this quitsapplication: Release;}
end;

procedure TOptions.PrpBtnClick(Sender: TObject);
begin

Application.CreateForm(TPrpOpt,PrpOpt);
PrpOpt.ShowModal;
PrpOpt.Free;
end;

procedure TOptions.DirBtnClick(Sender: TObject);
begin
Application.CreateForm(TDirOpt,DirOpt);
DirOpt.ShowModal;
DirOpt.Free;
end;

procedure TOptions.DeskTopBtnBitBtn1Click(Sender: TObject);
begin
Application.CreateForm(TDeskTop,DeskTop);
DeskTop.ShowModal;
DeskTop.Free;
end;

end.
