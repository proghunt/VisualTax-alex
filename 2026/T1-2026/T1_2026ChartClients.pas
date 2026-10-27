unit T1_2026chartclients;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons,DB,OleCtrls,// 20150727 chartfx3,
  VclTee.TeeProcs,VclTee.TeEngine,VclTee.Chart,VclTee.Series, VclTee.TeeGDIPlus,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TChartClientsT1_2026 = class(TForm)
    ChartGroup: TRadioGroup;
    DataDirBox: TEdit;
    DataSource1: TDataSource;
    Label2: TLabel;
    Chart1: TChart;
    Series1: TPieSeries;
    CancelBtn: TBitBtn;
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
  ChartClients: TChartClientsT1_2026;
  HWnd :THandle;

  MaritalCnt    : Array[0..5] of integer;
  EfStatusCnt   : Array[0..4] of integer;
  PrepStatusCnt : Array[0..7] of integer;
  AgeCnt        : Array[0..4] of integer; //20170409 Igor
  PrintedCnt    :  Array[0..1] of integer;

  ChartColor:Array[0..20] of TColor;

implementation

{$R *.DFM}

uses T1_2026,T1_2026Declare,T1_2026Trimstr,vtTrimStr,vtShared, vtDataBase;

Procedure TChartClientsT1_2026.InitCounters;
Var i:integer;
begin
 For i:=Low(MaritalCnt) to High(MaritalCnt) do MaritalCnt[i] :=0;
 For i:=Low(EfStatusCnt) to High(EfStatusCnt) do EfStatusCnt[i] :=0;
 For i:=Low(PrepStatusCnt) to High(PrepStatusCnt) do PrepStatusCnt[i] :=0;
 For i:=Low(AgeCnt) to High(AgeCnt) do AgeCnt[i] :=0;
 For i:=Low(PrintedCnt) to High(PrintedCnt) do PrintedCnt[i] :=0;
end;

Procedure TChartClientsT1_2026.AnalyseDB;
Var ApplYear,Birthyear,HisAge :Integer;
begin
 If not FileExists(DataDirBox.text+'\'+ClientsDbLite) then
 begin
  showMessage('There is no data base on the specified directory');
  DataDirBox.text:=OptRec.Dir_Cur;
 end;
 ApplYear := StrToInt(AppYear);

 //20150925 Igor
 SetTableName(FDConnection, Table1, DataDirBox.Text + '\' + ClientsDBLite, ClientsTableLite, '');

 Table1.First;
 Repeat
  Inc(MaritalCnt[Table1.FieldByName('MarStatus').AsInteger-1]);
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

procedure TChartClientsT1_2026.FormCreate(Sender: TObject);
Var i:Integer;
begin
  ChartGroup.ItemIndex :=0;
  DataDirBox.text:=OptRec.Dir_Cur;
  InitCounters;
  For i:= Low(ChartColor) to High(ChartColor) do ChartColor[i] := clSilver;
   GetChartColors(ChartColor);
  AnalyseDb;
  ChartGroupClick(Application);
end;

procedure TChartClientsT1_2026.ChartMarStatus;
Var i,r:Integer;
Captions :Array[0..5] of string; //[10];
begin
 With Chart1.Title.Text do
 begin  Clear;  Add('Marital Status'); end;

Captions[0]:= 'Married';
Captions[1]:= 'Common-Law';
Captions[2]:= 'Widowed';
Captions[3]:= 'Divorced';
Captions[4]:= 'Separated';
Captions[5]:= 'Single';


 With Chart1 do
 begin
  Series1.Clear;
  For i:=Low(MaritalCnt) to High(MaritalCnt) do Series1.AddPie(MaritalCnt[i],Captions[i], ChartColor[i]);
 end;
end;


procedure TChartClientsT1_2026.ChartAge;
Var i,r:Integer;
Captions :Array[0..4] of string; //[10];
begin
 With Chart1.Title.Text do
 begin  Clear;  Add('Age'); end;

Captions[0]:= '   <= 18   ';
Captions[1]:= '  (19 - 30)';
Captions[2]:= '  (31-49)  ';
Captions[3]:= '  (50-64)  ';
Captions[4]:= '   >= 65';


 With Chart1 do
 begin
  Series1.Clear;
  For i:=Low(AgeCnt) to High(AgeCnt) do Series1.AddPie(AgeCnt[i],Captions[i], ChartColor[i]);
 end;
end;


procedure TChartClientsT1_2026.ChartEFStatus;
Var i,r:Integer;
Captions :Array[0..5] of string; //[14];
begin
 With Chart1.Title.Text do
 begin  Clear;  Add('EFile Status'); end;

Captions[0]:= 'Not Started';
Captions[1]:= 'Ready for RTU';
Captions[2]:= 'Accepted';
Captions[3]:= 'Rejected';
Captions[4]:= 'Waiting ACK';
Captions[5]:= 'Ready for SEND';
 With Chart1 do
 begin
  Series1.Clear;
  For i:=Low(EfStatusCnt) to High(EfStatusCnt) do
    Series1.AddPie(EfStatusCnt[i],Captions[i], ChartColor[i]);
 end;
end;


procedure TChartClientsT1_2026.ChartPrepStatus;
Var i,r:Integer;
Captions :Array[0..7] of string; //[14];
begin
 With Chart1.Title.Text do
 begin  Clear;  Add('Preparation Status'); end;

 Captions[0]:= 'W.I.P';
 Captions[1]:= 'Not Started';
 Captions[2]:= 'Missing Data';
 Captions[3]:= 'Printed';
 Captions[4]:= 'Ready to Print';
 Captions[5]:= 'In Review';
 Captions[6]:= 'Finished';
 Captions[7]:= 'Re-assessed';

 With Chart1 do
 begin
  Series1.Clear;
  For i:=Low(PrepStatusCnt) to High(PrepStatusCnt) do
    Series1.AddPie(PrepStatusCnt[i],Captions[i], ChartColor[i]);
 end;
end;



procedure TChartClientsT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TChartClientsT1_2026.ChartGroupClick(Sender: TObject);
begin
 Case ChartGroup.ItemIndex of
 0: ChartEFStatus;
 1: ChartPrepStatus;
 2: ChartAge;
 3: ChartMarStatus;
 else
 end;

end;

procedure TChartClientsT1_2026.DataDirBoxExit(Sender: TObject);
begin
 InitCounters;
 AnalyseDb;
 ChartGroupClick(Application);
end;

procedure TChartClientsT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then
 begin
  InitCounters;
  AnalyseDb;
  ChartGroupClick(Application);
 end;
end;

end.
