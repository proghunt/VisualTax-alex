unit Ucustom;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  UMyHLine, UMyVLine;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  { newedit : TMyEdit;}
   Hline   : TMyHline;
   {VLine   : TMyVLine;}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
(*
 newedit := TMyEdit.create(Self);
 newedit.parent := Self;
 newedit.Left  := 12;
 newedit.Top  := 30;
 Hline := TMyHLine.create(Self);
 *)
 HLine := TMyHLine.create(Self);
 HLine.top := 20;
 HLine.left := 100;
 (*
 VLine := TMyVLine.create(Self);
 VLine.top := 20;
 VLine.left := 100;
 *)
 end;

end.
