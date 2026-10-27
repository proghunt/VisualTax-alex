unit T2_2027UpdateSchedule;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,T2_2027Declare,T2_2027TrimStr;

type
  TUpdateScheduleT2_2027 = class(TForm)
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
  UpdateSchedule: TUpdateScheduleT2_2027;

implementation

{$R *.DFM}

procedure TUpdateScheduleT2_2027.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TUpdateScheduleT2_2027.OKBtnClick(Sender: TObject);
Var TempList:TStringList;
begin
 TempList:=TstringList.Create;
 If Vl(Edit1.Text)>365 then Edit1.Text:='365';
 TempList.Add(Edit1.text);
 TempList.SaveToFile(AppDir+'\'+'UpdSch.txt');
 TempList.Free;
end;

procedure TUpdateScheduleT2_2027.FormCreate(Sender: TObject);
Var TempList:TstringList;
begin
 Edit1.Text:=IntToStr(GetUpdateFrequency);

end;

end.
