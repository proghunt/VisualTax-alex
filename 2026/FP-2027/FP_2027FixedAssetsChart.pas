unit FP_2027FixedAssetsChart;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,
  ExtCtrls,StdCtrls,Buttons,ComCtrls,Grids, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart;
  //20150817 igor

type
  TFixedAssetsChartFP_2012 = class(TForm)
    Panel2: TPanel;
    ByYearOrAge: TRadioGroup;
    CancelBtn: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Chart1: TChart;
    Series1: TBarSeries;
    StringGrid1: TStringGrid;
    PrintBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ByYearOrAgeClick(Sender: TObject);
    procedure ShowChart;
    procedure CancelBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    {Procedure ShowTotDetailSchedule;}
    Procedure ShowBalances;
    procedure PrintBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    RetNo: integer;
  end;

var
  FixedAssetsChart: TFixedAssetsChartFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027Declare,FP_2027Trimstr,vtTrimStr,vtShared;

procedure TFixedAssetsChartFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
 PageControl1.ActivePage := Tabsheet1;
 ByYearOrAge.ItemIndex :=1;
 BuildFixedAssetsProjection(RetNo);
 StringGrid1.RowCount := FixedAssetsProjectionList.Count+2;
 ShowChart;
end;

procedure TFixedAssetsChartFP_2012.ShowChart;
Var i,Density:Integer;
begin
  If FixedAssetsProjectionList.Count <20 then density :=1
  else if FixedAssetsProjectionList.count<40  then density:=2
  else density :=3;

 i:=0;
 Repeat
  FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[i];
  If ByYearOrAge.ItemIndex = 0 then
    Series1.Add(Round(FixedAssetsProjectionRec.Total),IntToStr(FixedAssetsProjectionRec.Year),clTeeColor)
  else
    Series1.Add(Round(FixedAssetsProjectionRec.Total),IntToStr(FixedAssetsProjectionRec.Age),clTeeColor);
  Inc(i,Density); {every  1,2 or 3years}
  until i>FixedAssetsProjectionList.Count-1;
end;


procedure TFixedAssetsChartFP_2012.ByYearOrAgeClick(Sender: TObject);
begin
 Series1.Clear;
 ShowChart;
end;

procedure TFixedAssetsChartFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TFixedAssetsChartFP_2012.PageControl1Change(Sender: TObject);
begin
 If PageControl1.ActivePage = TaBsheet2 then
   ShowBalances;
end;

Procedure TFixedAssetsChartFP_2012.ShowBalances;
Var  i,aRow:Integer; //PrevRow,PrevCol:integer;
   Year,Age: string; //[5];
   Autos,Homes,VacationPr,IncomeProp,BusNonIncorp,BusIncorp,Other,Total:string; //[15];
   AutosCapGain,HomesCapGain,VacationPrCapGain,IncomePropCapGain,
   BusNonIncorpCapGain,BusIncorpCapGain,OtherCapGain:string; //[15];
Begin
 With StringGrid1 do
 begin
   //PrevCol := Col;
   //PrevRow:=Row;
   For i:=0 to 1 do ColWidths[i]:= 40;
   For i:=2 to 5 do ColWidths[i]:= 80;
   Cells[0,0]:='Age';
   Cells[1,0]:='Year';
   Cells[2,0]:='Automobiles';
   Cells[3,0]:='Homes';
   Cells[4,0]:='Vacation Properties';
   Cells[5,0]:='Income Properties';
   Cells[6,0]:='Business-Non Incorp';
   Cells[7,0]:='Business-Incorp.';
   Cells[8,0]:='Other';
   Cells[9,0]:='Total';

   For i:=0 to FixedAssetsProjectionList.Count-1 do
   begin
    aRow := i+1;
    FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[i];
    Age:=IntToStr(FixedAssetsProjectionRec.Age);
    Year:=IntToStr(FixedAssetsProjectionRec.Year);
    Str(FixedAssetsProjectionRec.Autos:15, Autos);
    Str(FixedAssetsProjectionRec.Homes:15, Homes);
    Str(FixedAssetsProjectionRec.VacationPr:15, VacationPr);
    Str(FixedAssetsProjectionRec.IncomeProp:15, IncomeProp);
    Str(FixedAssetsProjectionRec.BusNonIncorp:15, BusNonIncorp);
    Str(FixedAssetsProjectionRec.BusIncorp:15, BusIncorp);
    Str(FixedAssetsProjectionRec.Other+FixedAssetsProjectionRec.OtherFixed:15, Other);
    Str(FixedAssetsProjectionRec.Total:15, Total);

    Cells[0,aRow] := Age;
    Cells[1,aRow] := Year;
    Cells[2,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(Autos)),12);
    Cells[3,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(Homes)),12);
    Cells[4,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(VacationPr)),12);
    Cells[5,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(IncomeProp)),12);
    Cells[6,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(BusNonIncorp)),12);
    Cells[7,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(BusIncorp)),12);
    Cells[8,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(Other)),12);
    Cells[9,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(Total)),12);

   end; {i}
 end; {stringgrid1}
end;



procedure TFixedAssetsChartFP_2012.PrintBtnClick(Sender: TObject);
begin
PrintAChart(Chart1,ClientLastName(RetNo)+', '+ClientFirstName(RetNo)
  + '    Prepared '+FormatDateTime('yyyy-mm-dd',Date));
end;

procedure TFixedAssetsChartFP_2012.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;

end.
