unit FP_2027PickADate;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ComCtrls;

type
  TPickADate = class(TForm)
    MonthCalendar1: TMonthCalendar;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure OkBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
     PickedDate:string; //[10];
  end;

var
  PickADate: TPickADate;

implementation

{$R *.DFM}

procedure TPickADate.OkBtnClick(Sender: TObject);
begin
PickedDate := FormatDateTime('yyyy-mm-dd',MonthCalendar1.Date);
Close;
end;

procedure TPickADate.CancelBtnClick(Sender: TObject);
begin
PickedDate:='';
Close;
end;

end.
