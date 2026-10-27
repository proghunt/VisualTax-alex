unit fYearCalendar;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Spin, Grids, Calendar,
  //UDeclare,TrimStr,
  Buttons, ExtCtrls;

type
  TYearCalendar = class(TForm)
    Calendar1: TCalendar;
    MonthList: TListBox;
    YearList: TListBox;
    SpinButton1: TSpinButton;
    OkBtn: TButton;
    PickedDate: TEdit;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure MonthListClick(Sender: TObject);
    procedure YearListClick(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetPickedDate;
    procedure Calendar1Click(Sender: TObject);
    procedure Calendar1Change(Sender: TObject);
  private

  public
    Picked: string;
  end;

  //var  YearCalendar: TYearCalendar;

implementation

{$R *.DFM}

uses
  vtTrimStr, //CommonRtns,
  vtDialogs;

procedure TYearCalendar.FormCreate(Sender: TObject);
var
  i: Integer;
  CurDate: string;//[10]; //20150701
begin
  CurDate := FormatDateTime('yyyy-mm-dd', Now);
  YearList.Items.Clear;
  for i := 1890 to 2100 do
    YearList.Items.Add(IntToStr(i));

  Calendar1.Year := StrToInt(LeftStr(CurDate, 4));
  Calendar1.Month := StrToInt(MidStr(CurDate, 6, 2));
  Calendar1.Day := StrToInt(MidStr(CurDate, 9, 2));
  {put index}
  YearList.ItemIndex := 2110 - Calendar1.Year + 2;
  MonthList.ItemIndex := Calendar1.Month - 1;
  SetPickedDate;
end;

procedure TYearCalendar.MonthListClick(Sender: TObject);
begin
  Calendar1.Month := MonthList.ItemIndex + 1;
  Calendar1.Year := StrToInt(YearList.Items[0]) + YearList.ItemIndex; {YearList.ItemIndex+1960;}
  Calendar1.Refresh;
  SetPickedDate;
end;

procedure TYearCalendar.SetPickedDate;
begin
  DD := Calendar1.Day;
  MM := Calendar1.Month;
  {YYYY := StrToInt(YearList.Items[0])+ YearList.ItemIndex;}
  YYYY := Calendar1.Year;
  PickedDate.Text := IntToStr(YYYY)
    + '-' + PaddZero(IntToStr(mm), 2)
    + '-' + PaddZero(IntToStr(DD), 2);
end;

procedure TYearCalendar.YearListClick(Sender: TObject);
begin
  Calendar1.Month := MonthList.ItemIndex + 1;
  Calendar1.Year := StrToInt(YearList.Items[0]) + YearList.ItemIndex;
  Calendar1.Refresh;
  SetPickedDate;
end;

procedure TYearCalendar.SpinButton1DownClick(Sender: TObject);
var
  i, j: integer;
begin
  for i := 0 to YearList.Items.Count - 1 do
  begin
    j := StrToInt(YearList.Items[i]);
    inc(j, 10);
    YearList.Items[i] := IntToStr(j);
  end;
  YearList.ItemIndex := 0;
  Calendar1.Year := StrToInt(YearList.Items[0]) + YearList.ItemIndex;
  MonthList.Refresh;
  Calendar1.Refresh;
end;

procedure TYearCalendar.SpinButton1UpClick(Sender: TObject);
var
  i, j: integer;
begin
  for i := 0 to YearList.Items.Count - 1 do
  begin
    j := StrToInt(YearList.Items[i]);
    dec(j, 10);
    YearList.Items[i] := IntToStr(j);
  end;
  YearList.ItemIndex := 0;
  Calendar1.Year := StrToInt(YearList.Items[0]) + YearList.ItemIndex;
  MonthList.Refresh;
  Calendar1.Refresh;
end;

procedure TYearCalendar.CancelBtnClick(Sender: TObject);
begin
  PickedDate.Text := '';
  Picked := '';
  ModalResult := mrCancel; // Close;
end;

procedure TYearCalendar.OkBtnClick(Sender: TObject);
begin
  DD := Calendar1.Day;
  MM := Calendar1.Month;
  YYYY := StrToInt(YearList.Items[0]) + YearList.ItemIndex;
  YYYY := Calendar1.Year;
  PickedDate.Text := IntToStr(YYYY)
    + '-' + PaddZero(IntToStr(mm), 2)
    + '-' + PaddZero(IntToStr(DD), 2);
  Picked := PickedDate.Text;
  ModalResult := mrOK; // Close;
end;

procedure TYearCalendar.Calendar1Click(Sender: TObject);
begin
  SetPickedDate;
end;

procedure TYearCalendar.Calendar1Change(Sender: TObject);
begin
  SetPickedDate;
end;

end.

