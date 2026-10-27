unit FP_2027shortfall;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons,DB,Math,FP_2027Declare,VCLTee.TeEngine,  //20150819  Igor
  VCLTee.Series,VCLTee.TeeProcs,VCLTee.Chart,Grids,ComCtrls,Spin;                    //20150819  Igor
  {UChart,USpevent,UChartAl,URetStrg;}

type
  TShortFallFrmFP_2012 = class(TForm)
    ShortFallImage: TImage;
    CapShortFallBox: TEdit;
    Label45: TLabel;
    Label10: TLabel;
    ShFallDiscountBox: TEdit;
    Label16: TLabel;
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    IncShortFallBox: TEdit;
    Label2: TLabel;
    YearsPayoutBox: TEdit;
    Label3: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure Recalc;
    Procedure ShowChartShortFall;
    procedure FormPaint(Sender: TObject);

  private

    { Private declarations }
  public
    RetNo: integer;
  end;

var
  ShortFallFrm: TShortFallFrmFP_2012;
  TempCanvas :TBitMap;

implementation

{$R *.DFM}

uses
  vtCommon,
  FP_2027,FP_2027Trimstr,FP_2027Calc,FP_2027childwinNew,vtTrimStr,vtShared;

procedure TShortFallFrmFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
   Caption :=Caption +ClientForCaption(RetNo);
   Recalc;
end;

Procedure TShortFallFrmFP_2012.ShowChartShortFall;
Var r:Trect;
begin
 R := ShortFallImage.BoundsRect;
 TempCanvas := TBitMap.Create;
 TempCanvas.Width := Width;
 TempCanvas.Height :=Height;
 TempCanvas.Canvas.Pen.Width := 1;
 TempCanvas.Canvas.Brush.Color := clBtnShadow;
 ChartShortFall(RetNo,GetDesiredRetirementIncome(RetNo),GetRetirementAfterTaxIncome(RetNo),TempCanvas,R);
 Canvas.CopyMode := cmSrcCopy;
 Canvas.CopyRect(R,TempCanvas.Canvas,R);
 TempCanvas.Free;
end;


procedure TShortFallFrmFP_2012.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TShortFallFrmFP_2012.Recalc;
Var i,FNo,MxPgNo:Integer;RetAge:Integer;

begin
 Screen.Cursor := crHourGlass;
 Calc(RetNo,'RETPLAN');
 BuildInvDetailProjection(RetNo);  //why??
 FNo:= GetFormNo('RETPLAN');
 RetAge:=MyStrToInt(FetchElmFNo(RetNo,FNo,6));
 IncShortFallBox.Text:=FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,52)));
 CapShortFallBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,44)));
 ShFallDiscountBox.Text := FetchElmFNo(RetNo,FNo,53);
 YearsPayoutBox.Text:= FetchElmFNo(RetNo,FNo,54);
 Screen.Cursor := crDefault;
end;

procedure TShortFallFrmFP_2012.FormPaint(Sender: TObject);
begin
 If vl(CapShortFallBox.Text) >0 then
 begin
  CapShortFallBox.Font.Color := clRed;
  IncShortFallBox.Font.Color := clRed;
 end
 else
 begin
  CapShortFallBox.Font.Color := clBlack;
  IncShortFallBox.Font.Color := clBlack;
  ShFallDiscountBox.Text:='';
  YearsPayoutBox.Text:='';
 end;
 ShowChartShortFall;
end;

end.
