unit FP_2027assetprojectioncharts;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons,DB,VCLTee.TeEngine,VCLTee.Series,
  VCLTee.TeeProcs,VCLTee.Chart,Grids,ComCtrls,Spin,Printers; //20150819 Igor

type
  TAssetProjectionChartsFP_2027 = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    Tabsheet1: TTabSheet;
    TabSheet2: TTabSheet;
    StringGrid2: TStringGrid;
    InvestmentTypeBox: TRadioGroup;
    ByYearOrAge: TRadioGroup;
    ChartAllBtn: TBitBtn;
    Chart1: TChart;
    Series1: TBarSeries;
    Panel3: TPanel;
    CancelBtn: TBitBtn;
    GridTitleLbl: TLabel;
    PrintBtn: TBitBtn;

    {Procedure ShowIt(RetNo:Integer;ThisStream:String;YearOrAge:Boolean);}
    {procedure PrintAChart;}
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);

    Procedure ShowCharts;

    Procedure CalcCurrentInvestmentsMix;

    Procedure CalcProposedInvestmentsMix;
    procedure FormPaint(Sender: TObject);
    procedure InvestmentTypeBoxClick(Sender: TObject);
    procedure ByYearOrAgeClick(Sender: TObject);
    Procedure ShowBalances(StreamId:Integer);
    Procedure ShowChart(RetNo:Integer;ThisStream:String;YearOrAge:Boolean);
    procedure AllBtnClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure ChartAllBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    //procedure LifeEventsBtnClick(Sender: TObject);
  private

    { Private declarations }
  public
    RetNo: integer;
  end;

var
  AssetProjectionCharts: TAssetProjectionChartsFP_2027;
  TempCanvas :TBitMap;
  TotValAtRetirement,ValRequired,ShortFall :real;
  YearOrAge:Boolean;

implementation

{$R *.DFM}

uses vtMulti,vtCommon,FP_2027Common,FP_2027childwinNew,FP_2027TotAssetsChart,
  FP_2027LifeEvents,FP_2027Declare,FP_2027Trimstr,FP_2027Calc,vtTrimStr,
  vtShared;

procedure TAssetProjectionChartsFP_2027.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
   If LicenseLevel = llDemo then PrintBtn.Enabled :=False;
   PageControl1.Align := alClient;
   PageControl1.ActivePage := Tabsheet1;
   InvestmentTypeBox.ItemIndex:=0;
   ByYearOrAge.ItemIndex :=1;
   StringGrid2.RowCount := BalanceList.Count+2;

   ShowCharts;

end;

Procedure TAssetProjectionChartsFP_2027.ShowCharts;
Var StreamId:Integer;
begin
 If ByYearOrAge.ItemIndex =0 then YearOrAge :=True else YearOrAge:=False;
 Case InvestmentTypeBox.ItemIndex of
  0: Begin StreamId :=GetStreamId('PNONSH');ShowChart(RetNo,'PNONSH',YearOrAge);end;
  1: Begin StreamId :=GetStreamId('PSHELT');ShowChart(RetNo,'PSHELT',YearOrAge);End;
  2: Begin StreamId :=GetStreamId('PSEMSH');ShowChart(RetNo,'PSEMSH',YearOrAge);end;
  3: Begin StreamId :=GetStreamId('POTHER');ShowChart(RetNo,'POTHER',YearOrAge);end;
 end;
 StringGrid2.RowCount :=BalanceList.Count+2;

end;


Procedure TAssetProjectionChartsFP_2027.CalcCurrentInvestmentsMix;
Var r:Trect;
begin
 (*
 R := CurrentInvestmentsImage.BoundsRect; {SheltImage.BoundsRect;}
 TempCanvas := TBitMap.Create;
 TempCanvas.Width := Width;{R.Right - R.Left;}
 TempCanvas.Height :=Height; { R.Bottom - R.Top;}
 TempCanvas.Canvas.Pen.Width := 1;
 TempCanvas.Canvas.Brush.Color := clBtnShadow;
 ChartInvestmentsMix(RetNo,TempCanvas,R,'Current Investments Mix',
   Vl(FetchElm(RetNo,'BALSHT',4))+ Vl(FetchElm(RetNo,'BALSHT',5)),
    Vl(FetchElm(RetNo,'BALSHT',6)),
     Vl(FetchElm(RetNo,'BALSHT',7)),
      Vl(FetchElm(RetNo,'BALSHT',12)));

 Canvas.CopyMode := cmSrcCopy;
 Canvas.CopyRect(R,TempCanvas.Canvas,R);
 TempCanvas.Free;
 *)
end;

Procedure TAssetProjectionChartsFP_2027.CalcProposedInvestmentsMix;
Var r:Trect;
begin
 (*

 R := ProposedInvestmentsImage.BoundsRect;
 TempCanvas := TBitMap.Create;
 TempCanvas.Width := Width;
 TempCanvas.Height :=Height;
 TempCanvas.Canvas.Pen.Width := 1;
 TempCanvas.Canvas.Brush.Color := clBtnShadow;

 ChartInvestmentsMix(RetNo,TempCanvas,R,'Proposed Investments Mix',
   Vl(NonShBalBox.Text),
    Vl(NonShBalBox.Text),
     Vl(NonShBalBox.Text),
      Vl(NonShBalBox.Text));

 Canvas.CopyMode := cmSrcCopy;
 Canvas.CopyRect(R,TempCanvas.Canvas,R);
 TempCanvas.Free;
 *)
end;

(*
Procedure TRetirementCharts.ShowChart(RetNo:Integer;ThisStream:String;YearOrAge:Boolean);
Var TempCanvas:TBitMap;r:Trect;
begin
 R := Image1.BoundsRect;
 TempCanvas := TBitMap.Create;
 TempCanvas.Width := Width;
 TempCanvas.Height :=Height;
 TempCanvas.Canvas.Pen.Width := 1;
 TempCanvas.Canvas.Brush.Color := clBtnShadow;
 ChartStream(RetNo,ThisStream,TempCanvas,R,YearOrAge);
 Try
   {copy the bitmap into the screen}
  Image1.Canvas.CopyMode := cmSrcCopy;
  Image1.Canvas.CopyRect(R,TempCanvas.Canvas,R);
 { Self.Canvas.CopyMode := cmSrcCopy;}
 { Self.Canvas.CopyRect(R,TempCanvas.Canvas,R);}
  TempCanvas.Free;
 finally
 ;
 end;
end;
*)
procedure TAssetProjectionChartsFP_2027.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TAssetProjectionChartsFP_2027.FormPaint(Sender: TObject);
begin
  {ShowCharts;}
end;

procedure TAssetProjectionChartsFP_2027.InvestmentTypeBoxClick(Sender: TObject);
Var StreamId:Integer;
begin
  If PageControl1.ActivePage = TabSheet2 then
  begin
    Case InvestmentTypeBox.ItemIndex of
    0: StreamId :=GetStreamId('PNONSH');
    1: StreamId :=GetStreamId('PSHELT');
    2: StreamId :=GetStreamId('PSEMSH');
    3: StreamId :=GetStreamId('POTHER');
    end;
    ShowBalances(StreamId);
  end
  else
  begin
   Case InvestmentTypeBox.ItemIndex of
    0: StreamId :=GetStreamId('PNONSH');
    1: StreamId :=GetStreamId('PSHELT');
    2: StreamId :=GetStreamId('PSEMSH');
    3: StreamId :=GetStreamId('POTHER');
    end;
    ShowCharts;
  end;
end;

procedure TAssetProjectionChartsFP_2027.ByYearOrAgeClick(Sender: TObject);
begin
ShowCharts;
end;

procedure TAssetProjectionChartsFP_2027.AllBtnClick(Sender: TObject);
begin

 Application.CreateForm(TTotAssetsChartFP_2027,TotAssetsChart);
 TotAssetsChart.ShowModal;
 TotAssetsChart.Free;
end;

Procedure TAssetProjectionChartsFP_2027.ShowBalances(StreamId:Integer);
Var  i,aRow,PrevRow,PrevCol:integer;
   Year,Age: string; //[5];
   BegBal,RegContr,RegWithDr,LumpSumContr,LumpSumWithDr,EndBal:string; //[15];
   Notes :string; //[40];
begin
  If StreamId <> 2 then  {shelt}
   GridTitleLbl.Caption:='Projected growth - '+GetStreamName(StreamId)+
    ' Investments at '+ RetirementParms.IntRate[StreamId] + ' % after tax'
  else
    GridTitleLbl.Caption:='Projected growth - '+GetStreamName(StreamId)+
    ' Investments at '+ RetirementParms.IntRate[StreamId] + ' %';
 With StringGrid2 do
 begin
   PrevCol := Col;
   PrevRow:=Row;
   ColWidths[0]:= 40;
   Cells[0,0]:='Age';
   Cells[1,0]:='Year';
   Cells[2,0]:='Beg-Bal';
   Cells[3,0]:='Contributions';
   Cells[4,0]:='Withdrawals';
   Cells[5,0]:='LumpSumContr';
   Cells[6,0]:='LumpSumWithDr';
   Cells[7,0]:='End-Bal';
   Cells[8,0]:='Contribution and Withdrawal Notes';
  For i:=0 to BalanceList.Count-1 do
   begin
    aRow := i+1;
    BalanceRec := TBalanceRec(BalanceList.Items[i]);
    Age:=IntToStr(BalanceRec.Age[0]);
    Year:=IntToStr(BalanceRec.Year);
    Cells[0,aRow] := Age;
    Cells[1,aRow] := Year;
    {Notes := BalanceRec.Notes[StreamId];}

    Cells[2,aRow]:=PaddR(FormatFloat('##,###,##0',BalanceRec.BegBalance[StreamId]),12);
    Cells[3,aRow]:=PaddR(FormatFloat('##,###,##0',BalanceRec.RegContr[StreamId]),12);
    Cells[4,aRow]:=PaddR(FormatFloat('##,###,##0',BalanceRec.RegWithDr[StreamId]),12);
    Cells[5,aRow]:=PaddR(FormatFloat('##,###,##0',BalanceRec.LumpSumContr[StreamId]),12);
    Cells[6,aRow]:=PaddR(FormatFloat('##,###,##0',BalanceRec.LumpSumWithDr[StreamId]),12);
    Cells[7,aRow]:=PaddR(FormatFloat('##,###,##0',BalanceRec.EndBalance[StreamId]),12);
    Cells[8,aRow]:=BalanceRec.Notes[StreamId];
   end; {i}
   Row:=PrevRow;
   Col:=PrevCol;
 end; {tringgrid2}
end;

procedure TAssetProjectionChartsFP_2027.BitBtn2Click(Sender: TObject);
begin
 {
 Application.CreateForm(TSpEvents, SpEvents);
 SpEvents.ShowModal;
 SpEvents.Free;
} 
end;

procedure TAssetProjectionChartsFP_2027.BitBtn3Click(Sender: TObject);
begin
{ ExecuteForm(TShortFallFrm);}
 {
 Application.CreateForm(ShortFallFrm, TShortFallfrm);
 ShortFallFrm.ShowModal;
 ShortFallFrm.Free;
 }
end;

procedure TAssetProjectionChartsFP_2027.ChartAllBtnClick(Sender: TObject);
begin
ExecuteForm(TTotAssetsChartFP_2027);
end;

procedure TAssetProjectionChartsFP_2027.PageControl1Change(Sender: TObject);
begin
If PageControl1.ActivePage = TabSheet2 then
  ShowBalances(StreamId)
else
  ShowCharts;
end;


Procedure TAssetProjectionChartsFP_2027.ShowChart(RetNo:Integer;ThisStream:String;YearOrAge:Boolean);
Var Tot:Real; R1:TRect;Interest:Real;
 i,Density:Integer;
 MinBal,MaxBal:Real;
 begin
  Density:=2;
  StreamId:=GetStreamId(ThisStream);
  With Chart1 do
  begin
   Title.Font.Color := clBlack;
   Title.Font.Size := 12;
   Title.Font.Style := [fsBold];
   Title.Text.Clear;
   Title.Text.Add(GetAccumChartTitle(ThisStream,RetirementParms.IntRate[StreamId]));

   GetMinMaxEndBalance(RetNo,ThisStream,MinBal,MaxBal);
   LeftAxis.Automatic := False;
   LeftAxis.Minimum := GetMinEndBalance(RetNo,ThisStream,BalanceList);
   LeftAxis.Minimum := LeftAxis.Minimum;
   LeftAxis.Maximum := GetMaxEndBalance(RetNo,ThisStream,BalanceList);
   LeftAxis.Maximum := LeftAxis.Maximum;
   Legend.Visible := False;
   AxisVisible := True;
  end;
  {TeeEraseBack:=False;}
  With Series1 do
  Begin
   Marks.Visible := False; {no yellow boxes on top of Bar}
   BarStyle := bsRectangle; {bsRectGradient;}
   BarBrush.Color := clRed;
  end;

  If BalanceList.Count <20 then density :=1
  else if BalanceList.count<40  then density:=2
  else density :=3;

  With Series1 do
  Begin
   Clear;
   If BalanceList.Count <1 then exit;
   i:=0;
   Repeat
    BalanceRec := TBalanceRec(BalanceList.Items[i]);
    If YearOrAge = True then
     Add(Round(BalanceRec.EndBalance[StreamId]),IntToStr(BalanceRec.Year),clTeeColor)
    else
     Add(Round(BalanceRec.EndBalance[StreamId]),IntToStr(BalanceRec.Age[0]),clTeeColor);
    Inc(i,Density); {every  1,2 or 3years}
   until i>BalanceList.Count-1;
  end;
end;

procedure TAssetProjectionChartsFP_2027.PrintBtnClick(Sender: TObject);
begin
PrintAChart(Chart1,ClientLastName(RetNo)+', '+ClientFirstName(RetNo)
  + '    Prepared '+FormatDateTime('yyyy-mm-dd',Date));
end;



end.

