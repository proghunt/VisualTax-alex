unit Adv1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Panel4: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
Var ADate : TDateTime;
YYYY,MM,DD,Hour,Min,Sec,Msec : word;
begin
{DateLeadZero(Date) := True;}
{ADate := Date;}
DEcodeDate(Date,Yyyy,Mm,DD);
DEcodetime(Date,Hour,Min,Sec,Msec);
Label10.Caption := 'Hour='+IntToStr(hour);
{Label10.Caption := 'yyyy='+IntToStr(yyyy);}
(*Label10.Caption := 'mm='+IntToStr(mm);

Label10.Caption := 'dd='+IntToStr(dd);
*)
{Label10.Caption := 'Day '+IntToStr(DayOfWeek(Date));}
{DateToStr(Date);}
end;

end.
