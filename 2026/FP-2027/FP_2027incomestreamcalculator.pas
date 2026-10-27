unit FP_2027incomestreamcalculator;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,Math,ExtCtrls,VCLTee.TeeProcs,VCLTee.TeEngine,VCLTee.Chart,Spin;    //20150819  Igor

type
  TIncomeStreamCalculatorFP_2012 = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    AmountBox: TEdit;
    YearsBox: TEdit;
    Label8: TLabel;
    Panel2: TPanel;
    ImageX: TImage;
    CalcBtn: TBitBtn;
    CancelBtn: TBitBtn;
    IndexByBox: TEdit;
    GrowthSpin: TSpinButton;
    Label3: TLabel;
    AmountSpinBox: TSpinButton;
    YearsSpin: TSpinButton;
    Label4: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure GrowthSpinDownClick(Sender: TObject);
    procedure GrowthSpinUpClick(Sender: TObject);
    procedure AmountSpinBoxDownClick(Sender: TObject);
    procedure AmountSpinBoxUpClick(Sender: TObject);
    procedure YearsSpinDownClick(Sender: TObject);
    procedure YearsSpinUpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IncomeStreamCalculator: TIncomeStreamCalculatorFP_2012;

implementation

{$R *.DFM}

uses FP_2027,FP_2027Declare,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TIncomeStreamCalculatorFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TIncomeStreamCalculatorFP_2012.FormCreate(Sender: TObject);
begin
AmountBox.Text := FormatFloat('##,###,###.00',30000);
YearsBox.Text := '15';
IndexByBox.Text := '5';
end;

procedure TIncomeStreamCalculatorFP_2012.CalcBtnClick(Sender: TObject);
Var i,Years:Integer;
    x,Amount,IndexBy:Real;
    StreamList:TStringList;
    //for charting
    ChartVList,ChartHList:TStringList;
    r:Trect;TempCanvas :TBitMap;
begin
 Amount := Vl(AmountBox.Text);
 Years := MyStrToInt(YearsBox.Text);
 If Years <1 then begin YearsBox.Text:='1'; Years:=1;end;
 IndexBy := Vl(IndexByBox.Text);
 {Inflation :=0;}
 {Inflation := Vl(InflationBox.Text)/100;}
 {TaxRate   := Vl(TaxRateBox.Text);}

 {EffectiveInterest := (Interest * (100-TaxRate)/100)/100;}
 //x:=Math.PresentValue(EffectiveInterest,Years,-Amount,0,PtStartofPeriod);
 //ResultBox.Text :=JustRight(FormatFloat('###,###,###.00',x),15);
 StreamList:=TStringList.create;
 GetIncomeStream(Amount,IndexBy,Years,StreamList);

 ListBox1.Items.Clear;

 ListBox1.Items.Add('Year     Amount');
 ListBox1.Items.Add('--------------------');
 For i:=0 to StreamList.Count-1 do

 ListBox1.Items.Add(PaddR(IntToStr(i+1),3)+ ' '+
    JustRight(FormatFloat('##,###,###.00',Vl(StreamList[i])),15));

{  ListBox1.Items.Add(PaddR(IntToStr(i+StrToInt(AppYear)),3)+ ' '+
    JustRight(FormatFloat('##,###,###.00',Vl(StreamList[i])),15));
 }
 //show chart:pass lists to chart routine and get a bmp
 ChartHList:=TStringList.Create;
 ChartVList:=TStringList.Create;
 For i:=0 to StreamList.count-1 do
 begin
  ChartVlist.Add(StreamList[i]);
  ChartHlist.Add(IntToStr(i+StrToInt(AppYear)));
 end;
 R:= Imagex.BoundsRect;
 TempCanvas := TBitMap.Create;
 TempCanvas.Width := Width;
 TempCanvas.Height :=Height;
 TempCanvas.Canvas.Pen.Width := 1;
 TempCanvas.Canvas.Brush.Color := clBtnShadow;
 GenChartBMP('Income growth',TempCanvas,R,ChartHList,ChartVList);
 Self.Canvas.CopyMode := cmSrcCopy;
 Self.Canvas.CopyRect(R,TempCanvas.Canvas,R);
 TempCanvas.Free;
 StreamList.Free;
 ChartHList.Free;
 ChartVList.Free;
end;

procedure TIncomeStreamCalculatorFP_2012.GrowthSpinDownClick(Sender: TObject);
begin
IndexByBox.Text := FormatFloat('###.00',(Vl(IndexByBox.Text) -1));
If Vl(IndexByBox.Text) <0 then IndexByBox.Text:='0';
CalcBtnClick(Sender);
end;


procedure TIncomeStreamCalculatorFP_2012.GrowthSpinUpClick(Sender: TObject);
begin
IndexByBox.Text := FormatFloat('###.00',(Vl(IndexByBox.Text) +1));
//If Vl(GrowthBox.Text) <0 then GrowthBox.Text:='0';
CalcBtnClick(Sender);
end;

procedure TIncomeStreamCalculatorFP_2012.AmountSpinBoxDownClick(Sender: TObject);
begin
AmountBox.Text := FormatFloat('##,###,###.00',(Vl(AmountBox.Text) -1000));
If Vl(AmountBox.Text) <0 then AmountBox.Text:='0';
CalcBtnClick(Sender);
end;

procedure TIncomeStreamCalculatorFP_2012.AmountSpinBoxUpClick(Sender: TObject);
begin
 AmountBox.Text := FormatFloat('##,###,###.00',(Vl(AmountBox.Text) +1000));
 //If Vl(AmountBox.Text) <0 then AmountBox.Text:='0';
 CalcBtnClick(Sender);

end;

procedure TIncomeStreamCalculatorFP_2012.YearsSpinDownClick(Sender: TObject);
begin
 YearsBox.Text := FormatFloat('##0',(Vl(YearsBox.Text) -1));
 If Vl(YearsBox.Text) <0 then YearsBox.Text:='0';
 CalcBtnClick(Sender);
end;

procedure TIncomeStreamCalculatorFP_2012.YearsSpinUpClick(Sender: TObject);
begin
 YearsBox.Text := FormatFloat('##0',(Vl(YearsBox.Text) +1));
// If Vl(YearsBox.Text) <0 then YearsBox.Text:='0';
 CalcBtnClick(Sender);
end;

end.

