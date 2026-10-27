unit T1_2015SlipsFrame;
//converted 07-21

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,vtLabel,ExtCtrls,vtShape;

type
  TSlipsFrameT1_2015 = class(TFrame) //20160216 Igor
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
    procedure ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  SlipsFrameT1_2015= TSlipsFrameT1_2015;
const
  //20160316 Igor
  FormName: Array [0..18] of String =
  ('RC62#1','T3MULT#1','T4#1','T4A#1','T4AOAS#1','T4ARCA#1','T4AP#1','T4E#1',
   'T4PS#1','T4RIF#1','T4RSP#1','T5004','T5MULT#1','T5007#1','T5008#1',
   'T5013#1','T5006','T101#1','T2202');
implementation

{$R *.DFM}

uses vtCommon, vtMulti, vtChild;

procedure TSlipsFrameT1_2015.ButtonClick(Sender: TObject);
var
  RetNo: Integer;
Begin
  RetNo := (Self.Parent as TvtScrollBox).RetNo;
  if not Assigned(RetList[RetNo]) then exit;
  if RetList[RetNo].IsLastYearReturn or
     RetList[RetNo].isAppendix then exit;
  OpenForm(RetNo,FormName[(Sender as TBitBtn).Tag],0);
End;

end.
