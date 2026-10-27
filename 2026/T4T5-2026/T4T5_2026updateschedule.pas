unit T4T5_2026updateschedule;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls;

type
  TUpdateScheduleT4T5_2026 = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel5: TPanel;
    Panel1: TPanel;
    Label14: TLabel;
    Label18: TLabel;
    Label1: TLabel;
    Panel2: TPanel;
    Edit1: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label28: TLabel;
    Label23: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateSchedule: TUpdateScheduleT4T5_2026;

implementation

{$R *.DFM}

uses vtTrimStr,T4T5_2026Declare,T4T5_2026TrimStr;

procedure TUpdateScheduleT4T5_2026.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TUpdateScheduleT4T5_2026.OKBtnClick(Sender: TObject);
Var TempList:TStringList;
begin
 TempList:=TstringList.Create;
 If Vl(Edit1.Text)>365 then Edit1.Text:='365';
 TempList.Add(Edit1.text);
 TempList.SaveToFile(AppDir+'\'+'UpdSch.txt');
 TempList.Free;
end;

procedure TUpdateScheduleT4T5_2026.FormCreate(Sender: TObject);
Var TempList:TstringList;
begin
 Edit1.Text:=IntToStr(GetUpdateFrequency);

end;

end.
