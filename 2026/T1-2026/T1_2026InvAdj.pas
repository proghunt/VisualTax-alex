unit T1_2026InvAdj;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons;

type
  TInvAdjT1_2026 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    FromInc1: TEdit;
    ToInc1: TEdit;
    Adj1: TEdit;
    FromInc2: TEdit;
    ToInc2: TEdit;
    Adj2: TEdit;
    FromInc3: TEdit;
    ToInc3: TEdit;
    Adj3: TEdit;
    FromInc4: TEdit;
    ToInc4: TEdit;
    Adj4: TEdit;
    Bevel1: TBevel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InvAdjT1_2026: TInvAdjT1_2026;

implementation

{$R *.DFM}

uses vtTrimStr,T1_2026Declare,T1_2026TrimStr;

procedure TInvAdjT1_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 TempList := TStringList.Create;
 If FileExists(AppDir+'\'+'INVADJ.D') then
 begin
  TempList.LoadFromFile(AppDir+'\'+'INVADJ.D');

  FromInc1.Text:=AllTrim(LeftStr(TempList[0],10));
  ToInc1.Text  :=AllTrim(MidStr(TempList[0],11,10));
  Adj1.Text    :=AllTrim(MidStr(TempList[0],21,10));

  FromInc2.Text:=AllTrim(LeftStr(TempList[1],10));
  ToInc2.Text  :=AllTrim(MidStr(TempList[1],11,10));
  Adj2.Text    :=AllTrim(MidStr(TempList[1],21,10));

  FromInc3.Text:=AllTrim(LeftStr(TempList[2],10));
  ToInc3.Text  :=AllTrim(MidStr(TempList[2],11,10));
  Adj3.Text    :=AllTrim(MidStr(TempList[2],21,10));

  FromInc4.Text:=AllTrim(LeftStr(TempList[3],10));
  ToInc4.Text  :=AllTrim(MidStr(TempList[3],11,10));
  Adj4.Text    :=AllTrim(MidStr(TempList[3],21,10));
 end;

TempList.Free;
end;

procedure TInvAdjT1_2026.OKBtnClick(Sender: TObject);
Var TempList:TstringList;
begin
  TempList:=TstringList.Create;

  TempList.Add(PaddR(FromInc1.Text,10)+PaddR(ToInc1.Text,10)+PaddR(Adj1.Text,10));
  TempList.Add(PaddR(FromInc2.Text,10)+PaddR(ToInc2.Text,10)+PaddR(Adj2.Text,10));
  TempList.Add(PaddR(FromInc3.Text,10)+PaddR(ToInc3.Text,10)+PaddR(Adj3.Text,10));
  TempList.Add(PaddR(FromInc4.Text,10)+PaddR(ToInc4.Text,10)+PaddR(Adj4.Text,10));
  TempList.SaveToFile(AppDir+'\'+'INVADJ.D');
  TempList.Free;
  ShowMessage('Saved');
end;

procedure TInvAdjT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
