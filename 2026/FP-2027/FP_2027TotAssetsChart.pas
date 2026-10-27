unit FP_2027TotAssetsChart;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,VCLTee.TeEngine,
  VCLTee.Series,ExtCtrls,VCLTee.TeeProcs,VCLTee.Chart,StdCtrls,Buttons,ComCtrls,Grids; //20150819 Igor

type
  TTotAssetsChartFP_2027 = class(TForm)
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
  TotAssetsChart: TTotAssetsChartFP_2027;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027Declare,FP_2027Trimstr,vtTrimStr,vtShared;

procedure TTotAssetsChartFP_2027.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
 PageControl1.ActivePage := Tabsheet1;
 ByYearOrAge.ItemIndex :=1;
 BuildAssetsProjection(RetNo);
 StringGrid1.RowCount := TotInvestmProjectionList.Count+2;
 ShowChart;
end;

procedure TTotAssetsChartFP_2027.ShowChart;
Var i,Density:Integer;
begin
  If TotInvestmProjectionList.Count <20 then density :=1
  else if TotInvestmProjectionList.count<40  then density:=2
  else density :=3;

 i:=0;
 Repeat
  TotInvestmProjectionRec := TotInvestmProjectionList.Items[i];
  If ByYearOrAge.ItemIndex = 0 then
    Series1.Add(Round(TotInvestmProjectionRec.TotEndBalance),IntToStr(TotInvestmProjectionRec.Year),clTeeColor)
  else
    Series1.Add(Round(TotInvestmProjectionRec.TotEndBalance),IntToStr(TotInvestmProjectionRec.Age),clTeeColor);
  Inc(i,Density); {every  1,2 or 3years}
  until i>TotInvestmProjectionList.Count-1;
end;


procedure TTotAssetsChartFP_2027.ByYearOrAgeClick(Sender: TObject);
begin
 Series1.Clear;
 ShowChart;
end;

procedure TTotAssetsChartFP_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TTotAssetsChartFP_2027.PageControl1Change(Sender: TObject);
begin
 If PageControl1.ActivePage = TaBsheet2 then
   ShowBalances;
end;

Procedure TTotAssetsChartFP_2027.ShowBalances;
Var  i,aRow,PrevRow,PrevCol:integer;
   Year,Age: string; //[5];
   BegBal,RegContr,RegWithDr,LumpSumContr,LumpSumWithDr,EndBal:string; //[15];
   Notes :string; //[40];
begin
 With StringGrid1 do
 begin
   PrevCol := Col;
   PrevRow:=Row;
   ColWidths[0]:= 40;
   Cells[0,0]:='Age';
   Cells[1,0]:='Year';
   Cells[2,0]:='Beg-Bal';
   Cells[3,0]:='End-Bal';
  For i:=0 to RetirementParms.NumbPeriods do //TotInvestmProjectionList.Count-1 do
   begin
    aRow := i+1;
    TotInvestmProjectionRec := TotInvestmProjectionList.Items[i];
    Age:=IntToStr(TotInvestmProjectionRec.Age);
    Year:=IntToStr(TotInvestmProjectionRec.Year);
    Cells[0,aRow] := Age;
    Cells[1,aRow] := Year;
    Str(TotInvestmProjectionRec.TotBegBalance:15, BegBal);
    Str(TotInvestmProjectionRec.TotEndBalance:15, EndBal);

    Cells[2,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(BegBal)),12);
    Cells[3,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(EndBal)),12);
   end; {i}
   Row:=PrevRow;
   Col:=PrevCol;
 end; {stringgrid1}
end;



procedure TTotAssetsChartFP_2027.PrintBtnClick(Sender: TObject);
begin
PrintAChart(Chart1,ClientLastName(RetNo)+', '+ClientFirstName(RetNo)
  + '    Prepared '+FormatDateTime('yyyy-mm-dd',Date));
end;

procedure TTotAssetsChartFP_2027.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;

end.
