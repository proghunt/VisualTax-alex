unit T3_2026calndr;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Spin, Grids, Calendar,
  T3_2026Declare;

type
  TCalndr = class(TForm)
    Calendar1: TCalendar;
    MonthList: TListBox;
    YearList: TListBox;
    SpinButton1: TSpinButton;
    OkBtn: TButton;
    procedure MonthListClick(Sender: TObject);
    procedure YearListClick(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Calndr: TCalndr;

implementation

{$R *.DFM}

procedure TCalndr.MonthListClick(Sender: TObject);
begin
 Calendar1.Month := MonthList.ItemIndex+1;
 Calendar1.Year := StrToInt(YearList.Items[0])+ YearList.ItemIndex;{YearList.ItemIndex+1960;}
 Calendar1.Refresh;
 end;

procedure TCalndr.YearListClick(Sender: TObject);
begin
 Calendar1.Month := MonthList.ItemIndex+1;
 Calendar1.Year :=  StrToInt(YearList.Items[0])+ YearList.ItemIndex;
 Calendar1.Refresh;
end;

procedure TCalndr.SpinButton1DownClick(Sender: TObject);
var
i,j : integer;
begin
for i :=0 to YearList.Items.Count -1 do
 begin
  j :=StrToInt(YearList.Items[i]);
  inc(j,10);
  YearList.Items[i] := IntToStr(j);
 end;
 YearList.ItemIndex := 0;
 Calendar1.Year := StrToInt(YearList.Items[0])+ YearList.ItemIndex;
 MonthList.Refresh; Calendar1.Refresh;
end;

procedure TCalndr.SpinButton1UpClick(Sender: TObject);
var
i,j : integer;
begin
 for i :=0 to YearList.Items.Count -1 do
 begin
  j :=StrToInt(YearList.Items[i]);
  dec(j,10);
  YearList.Items[i] := IntToStr(j);
 end;
 YearList.ItemIndex := 0;
 Calendar1.Year := StrToInt(YearList.Items[0])+ YearList.ItemIndex;
 MonthList.Refresh; Calendar1.Refresh;
end;

procedure TCalndr.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TCalndr.OkBtnClick(Sender: TObject);
begin
DD := Calendar1.Day;
MM := Calendar1.Month;
YYYY := StrToInt(YearList.Items[0])+ YearList.ItemIndex;
YYYY := Calendar1.Year;
Close;
end;

procedure TCalndr.FormCreate(Sender: TObject);
begin
Calendar1.Year := 1960;
Calendar1.Month := 1;
Calendar1.Day := 1;
MonthList.ItemIndex := 0;
YearList.ItemIndex := 0;

end;

end.
