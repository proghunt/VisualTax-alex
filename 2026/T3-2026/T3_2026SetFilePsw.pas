unit T3_2026SetFilePsw;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons;

type
  TSetFilePswT3_2026 = class(TForm)
    HeaderPanel: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetFilePsw: TSetFilePswT3_2026;
  RetNo:Integer;

implementation

{$R *.DFM}

uses vtCommon,vtTrimStr,vtDialogs,T3_2026TrimStr,T3_2026Declare,
  T3_2026ChildWinNew;

procedure TSetFilePswT3_2026.BitBtn1Click(Sender: TObject);
begin
Close;
end;

procedure TSetFilePswT3_2026.Button1Click(Sender: TObject);
begin
 RetNo:=GetCurrentRetNo;
 If Edit1.Text = Edit2.text then
 begin
  StoreReturnPsw(RetNo,Edit1.text);
  ShowTimedMsg('Done', 1000);
 end
 Else
  ShowTimedMsg('The confirmation is invalid', 1000);
end;

end.
