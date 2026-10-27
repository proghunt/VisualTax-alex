unit FP_2027updateschedule;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,FP_2027Declare;

type
  TUpdateScheduleFP_2012 = class(TForm)
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
  UpdateSchedule: TUpdateScheduleFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,vtTrimStr,vtShared;
  
procedure TUpdateScheduleFP_2012.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TUpdateScheduleFP_2012.OKBtnClick(Sender: TObject);
Var TempList:TStringList;
begin
 TempList:=TstringList.Create;
 If Vl(Edit1.Text)>365 then Edit1.Text:='365';
 TempList.Add(Edit1.text);
 TempList.SaveToFile(AppDir+'\'+'UpdSch.txt');
 TempList.Free;
end;

procedure TUpdateScheduleFP_2012.FormCreate(Sender: TObject);
Var TempList:TstringList;
begin
 Edit1.Text:=IntToStr(GetUpdateFrequency);

end;

end.
