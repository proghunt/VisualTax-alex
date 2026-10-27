unit T2_2027SetFilePsw;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons,T2_2027TrimStr,T2_2027Declare,T2_2027ChildWinNew;

type
  TSetFilePswT2_2027 = class(TForm)
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
    RetNo:Integer;
  public
    { Public declarations }
  end;

var
  SetFilePsw: TSetFilePswT2_2027;

implementation

{$R *.DFM}

uses vtMulti,vtCommon,vtDialogs;

procedure TSetFilePswT2_2027.BitBtn1Click(Sender: TObject);
begin
Close;
end;

procedure TSetFilePswT2_2027.Button1Click(Sender: TObject);
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
