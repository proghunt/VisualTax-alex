unit FP_2027SetFilePsw;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons;

type
  TSetFilePswFP_2012 = class(TForm)
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
    RetNo:Integer;
  end;

var
  SetFilePsw: TSetFilePswFP_2012;

implementation

{$R *.DFM}

uses vtCommon,vtDialogs,FP_2027TrimStr,FP_2027Declare,FP_2027ChildWinNew,
  vtTrimStr,vtShared;

procedure TSetFilePswFP_2012.BitBtn1Click(Sender: TObject);
begin
Close;
end;

procedure TSetFilePswFP_2012.Button1Click(Sender: TObject);
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
