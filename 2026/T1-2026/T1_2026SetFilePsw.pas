unit T1_2026SetFilePsw;
//converted 07-21

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons;

type
  TSetFilePswT1_2026 = class(TForm)
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
  SetFilePsw: TSetFilePswT1_2026;
  RetNo:Integer;

implementation

{$R *.DFM}

uses vtCommon,vtDialogs,T1_2026TrimStr,T1_2026Declare,T1_2026ChildWinNew;

procedure TSetFilePswT1_2026.BitBtn1Click(Sender: TObject);
begin
Close;
end;

procedure TSetFilePswT1_2026.Button1Click(Sender: TObject);
Var Psw:String;
begin
 RetNo:=GetCurrentRetNo;
 If Edit1.Text = Edit2.text then
 begin
  Psw:=Edit1.text;
  If ReturnPswHasEof(EncryptPsw(Psw,9999)) then  //20100619
  begin
   ShowMessage('The password entered is not acceptable. You may try another good master password');
   Exit;
  end;
  StoreReturnPsw(RetNo,Psw);
  ShowTimedMsg('Done. Click Exit', 1500);
 end
 Else
  ShowTimedMsg('The confirmation is invalid', 1500);
end;

end.
