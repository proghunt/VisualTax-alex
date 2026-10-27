unit T1_2026chart;
(* This form must be refactored, because it conflicts with the TChart component.
*)

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons,DB,OleCtrls,// 20150727 chartfx3,
  VclTee.TeeProcs,VclTee.TeEngine,VclTee.Chart,VclTee.Series, VclTee.TeeGDIPlus,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TchartT1_2026 = class(TForm)
    Label1: TLabel;
    ChartGroup: TRadioGroup;
    CancelBtn: TBitBtn;
    DataDirBox: TEdit;
    DataSource1: TDataSource;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Chart1: TChart;
    Series1: TPieSeries;
    FDConnection: TADConnection;
    Table1: TADTable;

    procedure ChartMarStatus;
    procedure ChartEFStatus;
    procedure ChartPrepStatus;
    procedure ChartAge;

    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ChartGroupClick(Sender: TObject);

    Procedure AnalyseDB;
    Procedure InitCounters;
    procedure DataDirBoxExit(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  chart1: TchartT1_2026;
  HWnd :THandle;

  MaritalCnt    : Array[1..6] of integer;
  EfStatusCnt   : Array[0..4] of integer;
  PrepStatusCnt : Array[0..7] of integer;
  AgeCnt        : Array[0..7] of integer;
  PrintedCnt    :  Array[0..1] of integer;

implementation

{$R *.DFM}

uses T1_2026,T1_2026Declare,T1_2026Trimstr,vtTrimStr,vtShared, vtDataBase;

Procedure TchartT1_2026.InitCounters;
Var i:integer;
begin
 For i:=Low(MaritalCnt) to High(MaritalCnt) do MaritalCnt[i] :=0;
 For i:=Low(EfStatusCnt) to High(EfStatusCnt) do EfStatusCnt[i] :=0;
 For i:=Low(PrepStatusCnt) to High(PrepStatusCnt) do PrepStatusCnt[i] :=0;
 For i:=Low(AgeCnt) to High(AgeCnt) do AgeCnt[i] :=0;
 For i:=Low(PrintedCnt) to High(PrintedCnt) do PrintedCnt[i] :=0;
end;

Procedure TchartT1_2026.AnalyseDB;
Var ApplYear,Birthyear,HisAge :Integer;
begin
 If not FileExists(DataDirBox.text+'\'+ClientsDbLite) then
 begin
  showMessage('There is no data base on the specified directory');
  DataDirBox.text:=OptRec.Dir_Cur;
 end;
 ApplYear := StrToInt(AppYear);

 //20150925 Igor
 SetTableName(FDConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDBLite, ClientsTableLite, '');

 Table1.First;
 Repeat
  Inc(MaritalCnt[Table1.FieldByName('MarStatus').AsInteger]);
  Inc(EFStatusCnt[MyStrToInt(Table1.FieldByName('EF_Status').AsString)]);
  Inc(PrepStatusCnt[MyStrToInt(Table1.FieldByName('PRP_Status').AsString)]);
  BirthYear:= myStrToInt(LeftStr(
     Table1.FieldByName('BirthDate').AsString
     ,4));
  HisAge :=ApplYear-BirthYear;
  If HisAge <= 18                            then Inc(AgeCnt[0])
  else if ((HisAge >=19) and (HisAge <=30))  then Inc(AgeCnt[1])
  else if ((HisAge >=31) and (HisAge <=49))  then Inc(AgeCnt[2])
  else if ((HisAge >=50) and (HisAge <64))   then Inc(AgeCnt[3])
  else if (HisAge >=65)                      then Inc(AgeCnt[4]);
  Table1.Next;
 until Table1.Eof;
end;

procedure TchartT1_2026.FormCreate(Sender: TObject);
begin
 DataDirBox.text:=OptRec.Dir_Cur;
 InitCounters;
 AnalyseDb;
 ChartGroup.ItemIndex :=2;
 {Chart1.Decimals :=0;}
 ChartGroupClick(Application);
end;

procedure TchartT1_2026.ChartMarStatus;
Var i,r:Integer;
ChartColor:Array[0..20] of TColor;
Legend :Array[0..5] of string; //[10];
begin
Legend[0]:= 'Married';
Legend[1]:= 'Common-Law';
Legend[2]:= 'Widowed';
Legend[3]:= 'Divorced';
Legend[4]:= 'Separated';
Legend[5]:= 'Single';
 
 For i:= Low(ChartColor) to High(ChartColor) do ChartColor[i] := clSilver;
 GetChartColors(ChartColor);
// HoldingsChart.SeriesList[0 ] := Series1;}
 begin
 For i:=0 to 5 do
  Series1.AddPie(MaritalCnt[i],Legend[i], ClBlue);
 end;
end;

(*procedure TChart.ChartMarStatus;
Var i:integer;
XTitle,YTitle :string;
begin

xTitle := 'Marital Status - Distribution';
YTitle := 'Number of Clients';
HWnd := Chart1.Handle;
Chart1.Title[0] := YTitle;
Chart1.Title[2] := xTitle;

{open series 1}
Chart1.OpenData[1]:=1;
{get data}
Chart1.Value[0] :=MaritalCnt[1];
Chart1.Value[1] :=MaritalCnt[2];
Chart1.Value[2] :=MaritalCnt[3];
Chart1.Value[3] :=MaritalCnt[4];
Chart1.Value[4] :=MaritalCnt[5];
Chart1.Value[5] :=MaritalCnt[6];
For i:=6 to 7 do Chart1.Value[i]:=0;
{Put legends}
Chart1.XLegType := 3; {CL_NOTCLIPPED;}
Chart1.Legend[0]:= 'Married';
Chart1.Legend[1]:= 'Common-Law';
Chart1.Legend[2]:= 'Widowed';
Chart1.Legend[3]:= 'Divorced';
Chart1.Legend[4]:= 'Separated';
Chart1.Legend[5]:= 'Single';
For i:=6 to 7 do Chart1.Legend[i]:='';
Chart1.CloseData[1]:=0;

end;*)

procedure TchartT1_2026.ChartAge;
Var i:integer;
XTitle,YTitle :string;
begin

xTitle := 'Age - Distribution';
YTitle := 'Number of Clients';
HWnd := Chart1.Handle;


// 20150727
{open series 1}
//Chart1. OpenData[1]:=1;
{get data}
(*Chart1.Value[0] :=AgeCnt[0];
Chart1.Value[1] :=AgeCnt[1];
Chart1.Value[2] :=AgeCnt[2];
Chart1.Value[3] :=AgeCnt[3];
Chart1.Value[4] :=AgeCnt[4];
For i:=5 to 7 do Chart1.Value[i]:=0; *)

For i := 0 to 4 do
  Chart1.SeriesList[0].XValue[i] := AgeCnt[i];
For i:=5 to 7 do
   Chart1.SeriesList[0].XValue[i]:=0;


{Put legends}
//Chart1.XLegType := 3; {CL_NOTCLIPPED;}

Chart1.SeriesList[0].XLabel[0]:= '<= 18';
Chart1.SeriesList[0].XLabel[1]:= '19 - 30';
Chart1.SeriesList[0].XLabel[2]:= '31-49';
Chart1.SeriesList[0].XLabel[3]:= '50-64';
Chart1.SeriesList[0].XLabel[4]:= '>= 65';
For i:=5 to 7 do Chart1.SeriesList[0].XLabel[i]:='';

//Chart1.CloseData[1]:=0;

end;

procedure TchartT1_2026.ChartEFStatus;
Var i:integer;
XTitle,YTitle :string;
begin

xTitle := 'EFile Status - Distribution';
YTitle := 'Number of Clients';
HWnd := Chart1.Handle;
Chart1.Title.Caption := YTitle;
//Chart1.Title[2] := xTitle;
{open series 1}
//Chart1.OpenData[1]:=1;

{get data}
For i := 0 to 4 do
  Chart1.SeriesList[0].XValue[i] := EFStatusCnt[i];
For i:=5 to 7 do
   Chart1.SeriesList[0].XValue[i]:=0;

{Chart1.Value[0] :=EFStatusCnt[0];
Chart1.Value[1] :=EFStatusCnt[1];
Chart1.Value[2] :=EFStatusCnt[2];
Chart1.Value[3] :=EFStatusCnt[3];
Chart1.Value[4] :=EFStatusCnt[4];
For i:=5 to 7 do Chart1.Value[i]:=0;}

{Put legends}
//Chart1.XLegType := 3; {CL_NOTCLIPPED;}
Chart1.SeriesList[0].XLabel[0]:= 'NotStart';
Chart1.SeriesList[0].XLabel[1]:= 'ReadyRTU';
Chart1.SeriesList[0].XLabel[2]:= 'Accepted';
Chart1.SeriesList[0].XLabel[3]:= 'Rejected';
Chart1.SeriesList[0].XLabel[4]:= 'WaitACK';
For i:=5 to 7 do Chart1.SeriesList[0].XLabel[i]:='';

end;


procedure TchartT1_2026.ChartPrepStatus;
Var i:integer;
XTitle,YTitle :string;
begin

xTitle := 'Preparation Status - Distribution';
YTitle := 'Number of Clients';
HWnd := Chart1.Handle;

Chart1.Title.Text.Add(YTitle);
Chart1.Title.Caption := YTitle;
//Chart1.Title[2] := xTitle;
// 20150727
{open series 1}
//Chart1.OpenData[1]:=1;
{get data}
For i := 0 to 7 do
  Chart1.SeriesList[0].XValue[i] := PrepStatusCnt[i];

{Chart1.Value[0] :=PrepStatusCnt[0];
Chart1.Value[1] :=PrepStatusCnt[1];
Chart1.Value[2] :=PrepStatusCnt[2];
Chart1.Value[3] :=PrepStatusCnt[3];
Chart1.Value[4] :=PrepStatusCnt[4];
Chart1.Value[5] :=PrepStatusCnt[5];
Chart1.Value[6] :=PrepStatusCnt[6];
Chart1.Value[7] :=PrepStatusCnt[7];}
{Put legends}
//Chart1.XLegType := 3; {CL_NOTCLIPPED;}
Chart1.SeriesList[0].XLabel[0]:= 'W.I.P';
Chart1.SeriesList[0].XLabel[1]:= 'NotStart';
Chart1.SeriesList[0].XLabel[2]:= 'MissData';
Chart1.SeriesList[0].XLabel[3]:= 'Printed';
Chart1.SeriesList[0].XLabel[4]:= 'ReadyPrint';
Chart1.SeriesList[0].XLabel[5]:= 'In Review';
Chart1.SeriesList[0].XLabel[6]:= 'Finished';
Chart1.SeriesList[0].XLabel[7]:= 'Re-assessed';

end;

procedure TchartT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TchartT1_2026.ChartGroupClick(Sender: TObject);
begin

 Case ChartGroup.ItemIndex of
 0: ChartEFStatus;
 1: ChartPrepStatus;
 2: ChartMarStatus;
 3: ChartAge;
 else
 end;

end;

procedure TchartT1_2026.DataDirBoxExit(Sender: TObject);
begin
 InitCounters;
 AnalyseDb;
 ChartGroupClick(Application);
end;

procedure TchartT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then
 begin
  InitCounters;
  AnalyseDb;
  ChartGroupClick(Application);
 end;
end;

end.
