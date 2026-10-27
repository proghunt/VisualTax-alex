unit FP_2027liabilitieschart;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,
ExtCtrls,StdCtrls,Buttons,ComCtrls,Grids, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart;
  //20150817 igor

type
  TLiabilitiesChartFP_2012 = class(TForm)
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
  LiabilitiesChart: TLiabilitiesChartFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027Declare,FP_2027Trimstr,vtTrimStr,vtShared;

procedure TLiabilitiesChartFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
 PageControl1.ActivePage := Tabsheet1;
 ByYearOrAge.ItemIndex :=1;
 BuildLiabilitiesProjection(RetNo);
 StringGrid1.RowCount := LiabilitiesProjectionList.Count+2;
 ShowChart;
end;

procedure TLiabilitiesChartFP_2012.ShowChart;
Var i,Density:Integer;
begin
  If LiabilitiesProjectionList.Count <20 then density :=1
  else if LiabilitiesProjectionList.count<40  then density:=2
  else density :=3;

 i:=0;
 Repeat
  LiabilitiesProjectionRec := LiabilitiesProjectionList.Items[i];
  If ByYearOrAge.ItemIndex = 0 then
    Series1.Add(Round(LiabilitiesProjectionRec.TotLiability),IntToStr(LiabilitiesProjectionRec.Year),clTeeColor)
  else
    Series1.Add(Round(LiabilitiesProjectionRec.TotLiability),IntToStr(LiabilitiesProjectionRec.Age),clTeeColor);
  Inc(i,Density); {every  1,2 or 3years}
  until i>LiabilitiesProjectionList.Count-1;
end;


procedure TLiabilitiesChartFP_2012.ByYearOrAgeClick(Sender: TObject);
begin
 Series1.Clear;
 ShowChart;
end;

procedure TLiabilitiesChartFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TLiabilitiesChartFP_2012.PageControl1Change(Sender: TObject);
begin
 If PageControl1.ActivePage = TaBsheet2 then
   ShowBalances;
end;

Procedure TLiabilitiesChartFP_2012.ShowBalances;
Var  i,aRow,PrevRow,PrevCol:integer;
   Year,Age: string; //[5];
   Mortgages,Automobiles,Other,TotLiability:string; //[15];
begin
 With StringGrid1 do
 begin
   PrevCol := Col;
   PrevRow:=Row;

   For i:=0 to 1 do ColWidths[i]:= 40;
   For i:=2 to 5 do ColWidths[i]:= 100;
   Cells[0,0]:='Age';
   Cells[1,0]:='Year';
   Cells[2,0]:='Mortgages';
   Cells[3,0]:='Automobiles';
   Cells[4,0]:='Other';
   Cells[5,0]:='Total Liability';
  For i:=0 to RetirementParms.NumbPeriods do  //LiabilitiesProjectionList.Count-1 do
   begin
    aRow := i+1;
    LiabilitiesProjectionRec := LiabilitiesProjectionList.Items[i];
    Age:=IntToStr(LiabilitiesProjectionRec.Age);
    Year:=IntToStr(LiabilitiesProjectionRec.Year);
    Cells[0,aRow] := Age;
    Cells[1,aRow] := Year;
    Str(LiabilitiesProjectionRec.Mortgages:15, Mortgages);
    Str(LiabilitiesProjectionRec.Automobiles:15, Automobiles);
    Str(LiabilitiesProjectionRec.Other:15, Other);
    Str(LiabilitiesProjectionRec.TotLiability:15, TotLiability);

    Cells[2,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(Mortgages)),12);
    Cells[3,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(Automobiles)),12);
    Cells[4,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(Other)),12);
    Cells[5,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(TotLiability)),12);
   end; {i}
   Row:=PrevRow;
   Col:=PrevCol;
 end; {stringgrid1}
end;



procedure TLiabilitiesChartFP_2012.PrintBtnClick(Sender: TObject);
begin
PrintAChart(Chart1,ClientLastName(RetNo)+', '+ClientFirstName(RetNo)
  + '    Prepared '+FormatDateTime('yyyy-mm-dd',Date));
end;

procedure TLiabilitiesChartFP_2012.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;

end.
