unit USlipsFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, vtLabel, ExtCtrls, vtShape;

type
  TSlipsFrame = class(TFrame)
    T3Btn: TBitBtn;
    T4Btn: TBitBtn;
    T4AOSBtn: TBitBtn;
    T4ABtn: TBitBtn;
    T4APBtn: TBitBtn;
    T4EBtn: TBitBtn;
    T4PSBtn: TBitBtn;
    T4RIFBtn: TBitBtn;
    T4RSPBtn: TBitBtn;
    T5004Btn: TBitBtn;
    T5007Btn: TBitBtn;
    T5008Btn: TBitBtn;
    T5013Btn: TBitBtn;
    T5MultBtn: TBitBtn;
    LaborSPBtn: TBitBtn;
    T101Btn: TBitBtn;
    T2202Btn: TBitBtn;
    RC52Btn: TBitBtn;
    T4ARcaBtn: TBitBtn;
    procedure RC62BtnClick(Sender: TObject);
    procedure T3BtnClick(Sender: TObject);
    procedure T4BtnClick(Sender: TObject);
    procedure T4ABtnClick(Sender: TObject);
    procedure T4AOSBtnClick(Sender: TObject);
    procedure T4APBtnClick(Sender: TObject);
    procedure T4EBtnClick(Sender: TObject);
    //procedure T4FBtnClick(Sender: TObject);
    procedure T4PSBtnClick(Sender: TObject);
    procedure T4RIFBtnClick(Sender: TObject);
    procedure T4RSPBtnClick(Sender: TObject);
    procedure T5004BtnClick(Sender: TObject);
    procedure T5007BtnClick(Sender: TObject);
    procedure T5008BtnClick(Sender: TObject);
    procedure T5013BtnClick(Sender: TObject);
    procedure T5MultBtnClick(Sender: TObject);
    procedure LaborSPBtnClick(Sender: TObject);
    procedure T101BtnClick(Sender: TObject);
    procedure T2202BtnClick(Sender: TObject);
    procedure T4ARcaBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}
Uses
{$IF CompilerVersion >= 18.0}
  vtCommon;
{$ELSE}
  ChildWinNew;
{$ENDIF}

procedure MyOpenForm(AFormName: String);
Var RetNo:Integer;
Begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,{$IF CompilerVersion < 18.0}GetFormNo({$ENDIF}AFormName{$IF CompilerVersion < 18.0}){$ENDIF},0);
End;

procedure TSlipsFrame.T3BtnClick(Sender: TObject);
begin
 MyOpenForm('T3MULT#1');
end;

procedure TSlipsFrame.RC62BtnClick(Sender: TObject);
begin
 MyOpenForm('RC62#1');
end;


procedure TSlipsFrame.T4BtnClick(Sender: TObject);
begin
 MyOpenForm('T4#1');
end;

procedure TSlipsFrame.T4ABtnClick(Sender: TObject);
begin
 MyOpenForm('T4A#1');
end;

procedure TSlipsFrame.T4AOSBtnClick(Sender: TObject);
begin
 MyOpenForm('T4AOAS#1');
end;

procedure TSlipsFrame.T4APBtnClick(Sender: TObject);
begin
 MyOpenForm('T4AP#1');
end;

procedure TSlipsFrame.T4EBtnClick(Sender: TObject);
begin
 MyOpenForm('T4E#1');
end;

(*
procedure TSlipsFrame.T4FBtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,GetFormNo('T4F#1'),0);
end;
*)
procedure TSlipsFrame.T4PSBtnClick(Sender: TObject);
begin
 MyOpenForm('T4PS#1');
end;

procedure TSlipsFrame.T4RIFBtnClick(Sender: TObject);
begin
 MyOpenForm('T4RIF#1');
end;

procedure TSlipsFrame.T4RSPBtnClick(Sender: TObject);
begin
 MyOpenForm('T4RSP#1');
end;

procedure TSlipsFrame.T5004BtnClick(Sender: TObject);
begin
 MyOpenForm('T5004');
end;

procedure TSlipsFrame.T5007BtnClick(Sender: TObject);
begin
 MyOpenForm('T5007#1');
end;

procedure TSlipsFrame.T5008BtnClick(Sender: TObject);
begin
 MyOpenForm('T5008#1');
end;

procedure TSlipsFrame.T5013BtnClick(Sender: TObject);
begin
 MyOpenForm('T5013#1');
end;

procedure TSlipsFrame.T5MultBtnClick(Sender: TObject);
begin
 MyOpenForm('T5MULT#1');
end;

procedure TSlipsFrame.LaborSPBtnClick(Sender: TObject);
begin
 MyOpenForm('T5006');
end;

procedure TSlipsFrame.T101BtnClick(Sender: TObject);
begin
 MyOpenForm('T101#1');
end;

procedure TSlipsFrame.T2202BtnClick(Sender: TObject);
begin
 MyOpenForm('T2202');
end;

procedure TSlipsFrame.T4ARcaBtnClick(Sender: TObject);
begin
 MyOpenForm('T4ARCA#1');
end;

end.
