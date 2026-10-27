unit T1_2014SlipsFrame;
//converted 07-21

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,vtLabel,ExtCtrls,vtShape;

type
  TSlipsFrameT1_2014 = class(TFrame) //20160216 Igor
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
 SlipsFrameT1_2014= TSlipsFrameT1_2014;

implementation

{$R *.DFM}

uses vtCommon;

procedure TSlipsFrameT1_2014.T3BtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T3MULT#1',0);
end;

procedure TSlipsFrameT1_2014.RC62BtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'RC62#1',0);
end;


procedure TSlipsFrameT1_2014.T4BtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T4#1',0);
end;

procedure TSlipsFrameT1_2014.T4ABtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T4A#1',0);
end;

procedure TSlipsFrameT1_2014.T4AOSBtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T4AOAS#1',0);
end;

procedure TSlipsFrameT1_2014.T4APBtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T4AP#1',0);
end;

procedure TSlipsFrameT1_2014.T4EBtnClick(Sender: TObject);
 Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T4E#1',0);
end;

(*
procedure TSlipsFrame.T4FBtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,GetFormNo('T4F#1'),0);
end;
*)
procedure TSlipsFrameT1_2014.T4PSBtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T4PS#1',0);
end;

procedure TSlipsFrameT1_2014.T4RIFBtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T4RIF#1',0);
end;

procedure TSlipsFrameT1_2014.T4RSPBtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T4RSP#1',0);
end;

procedure TSlipsFrameT1_2014.T5004BtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T5004',0);
end;

procedure TSlipsFrameT1_2014.T5007BtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T5007#1',0);
end;

procedure TSlipsFrameT1_2014.T5008BtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T5008#1',0);
end;

procedure TSlipsFrameT1_2014.T5013BtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T5013#1',0);
end;

procedure TSlipsFrameT1_2014.T5MultBtnClick(Sender: TObject);
 Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T5MULT#1',0);
end;

procedure TSlipsFrameT1_2014.LaborSPBtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T5006',0);
end;

procedure TSlipsFrameT1_2014.T101BtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T101#1',0);
end;

procedure TSlipsFrameT1_2014.T2202BtnClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T2202',0);
end;

procedure TSlipsFrameT1_2014.T4ARcaBtnClick(Sender: TObject);
 Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T4ARCA#1',0);
end;

end.
