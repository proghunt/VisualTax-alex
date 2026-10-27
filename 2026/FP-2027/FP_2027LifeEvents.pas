unit FP_2027LifeEvents;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons,DB,VCLTee.TeEngine,VCLTee.Series,
  VCLTee.TeeProcs,VCLTee.Chart,Grids,ComCtrls,Spin; //20150819 Igor
  {UChart,USpevent,UChartAl,URetStrg;}
type
  TLifeEventsFP_2012 = class(TForm)
    Panel1: TPanel;
    PrintDialog1: TPrintDialog;
    Panel3: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    CancelBtn: TBitBtn;
    Print: TBitBtn;
    Panel2: TPanel;
    ListBox1: TListBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    ChartsBtn: TBitBtn;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label11: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure StoreData(RetNo:Integer);
    procedure FetchData(RetNo:Integer);
    Procedure InitStringGrid;
    Procedure EditGrid;
    {procedure EditPercentages;}
    {procedure EditYears;}
    procedure PrintClick(Sender: TObject);
    //procedure RecalcBtnClick(Sender: TObject);
    //Procedure ShowBalances;
    procedure FillToYear;
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ChartsBtnClick(Sender: TObject);
    procedure Label15Click(Sender: TObject);
    procedure Label17Click(Sender: TObject);
  private

    { Private declarations }
  public
    RetNo: integer;
  end;

var
  LifeEvents: TLifeEventsFP_2012;
  TempCanvas :TBitMap;
  TotValAtRetirement,ValRequired,ShortFall :real;
  YearOrAge:Boolean;

implementation

{$R *.DFM}
uses vtCommon,FP_2027,FP_2027Declare,FP_2027Trimstr,FP_2027Calc,
  FP_2027childwinNew,FP_2027Common2,FP_2027Print,FP_2027Main,
  FP_2027RetirementCharts,vtTrimStr,vtShared;

procedure TLifeEventsFP_2012.FormCreate(Sender: TObject);
Var FNo:Integer;
begin
  RetNo := GetCurrentRetNo;
 Caption :=Caption +ClientForCaption(RetNo);
 InitStringGrid;
 FetchData(RetNo);
 EditGrid;
end;


procedure TLifeEventsFP_2012.CancelBtnClick(Sender: TObject);
begin
 StoreData(RetNo);
 CalcAll(RetNo);
 Close;
end;

Procedure TLifeEventsFP_2012.InitStringGrid;
Var RowNo:Integer;
begin
   If RetNo<1 then exit;
   With StringGrid1 do
   begin
    EditorMode := True;
    Cells[0,0] := 'Description';
    Cells[1,0] := 'From Year';
    Cells[2,0] := 'To Year';
    Cells[3,0] := 'Code C or W';
    Cells[4,0] := '$ Amount';
    Cells[5,0] := 'NonSh %';
    Cells[6,0] := 'SemiSh %';
    Cells[7,0] := 'Shelt %';
    Cells[8,0] := 'Other %';
   end;
end;


procedure TLifeEventsFP_2012.EditGrid;
Var RowNo:Integer;
begin
With StringGrid1 do
  begin
     For RowNo:=1 to RowCount-1 do
     begin
      If Cells[0,RowNo] >'' then
       Cells[5,RowNo] := FormatFloat('###.00',
                   100
                   -Vl(Cells[6,RowNo])
                   -Vl(Cells[7,RowNo])
                   -Vl(Cells[8,RowNo]));
      If (Vl(Cells[6,RowNo]) >100) then Cells[6,RowNo] :='100';
      If (Vl(Cells[7,RowNo]) >100) then Cells[7,RowNo] :='100';
      If (Vl(Cells[8,RowNo]) >100) then Cells[8,RowNo] :='100';
      {
      If (Cells[1,RowNo] >'') and (Length(Cells[2,RowNo]) <>4)
       then Cells[2,RowNo] := Cells[1,RowNo]
      }
     end;
     StringGrid1.Refresh;
  end;
end;

procedure TLifeEventsFP_2012.FillToYear;
Var RowNo:Integer;
begin
With StringGrid1 do
  begin
     For RowNo:=1 to RowCount-1 do
     begin
      If Cells[0,RowNo] >'' then
      begin
       If (Cells[2,RowNo] ='')
       or (Cells[2,RowNo] <Cells[1,RowNo]) then
        Cells[2,RowNo] :=Cells[1,RowNo];
      end;
     end;
     StringGrid1.Refresh;
  end;
end;

procedure TLifeEventsFP_2012.FetchData(RetNo:Integer);
Var RowNo,FNo,Elm:integer;
begin
 If RetNo<1 then exit;
 FNo := GetFormNo('PEVENTS');
 If Ret[RetNo].FrmHasData[FNo] then
 begin
  With StringGrid1 do
  begin
    Elm:=3;  {do not copy first line ie shortfall}
    For RowNo:=1 to RowCount do
    begin
     Cells[0,RowNo]:=FetchElmFNo(RetNo,FNo,Elm); {Descr}
     Cells[1,RowNo]:=FetchElmFNo(RetNo,FNo,Elm+1); {From Yr}
     Cells[2,RowNo]:=FetchElmFNo(RetNo,FNo,Elm+2); {To yr}
     Cells[3,RowNo]:=FetchElmFNo(RetNo,FNo,Elm+3); {W or C}
     Cells[4,RowNo]:=FetchElmFNo(RetNo,FNo,Elm+4); {Amount}
     Cells[5,RowNo]:=FetchElmFNo(RetNo,FNo,Elm+5); {Non sh %}
     Cells[6,RowNo]:=FetchElmFNo(RetNo,FNo,Elm+6); {Semi sh %}
     Cells[7,RowNo]:=FetchElmFNo(RetNo,FNo,Elm+7); {Shelt}
     Cells[8,RowNo]:=FetchElmFNo(RetNo,FNo,Elm+8); {othr}
     Inc(Elm,11);
    end;
  end;
 end; {end pevents}
end;

procedure TLifeEventsFP_2012.StoreData(RetNo:Integer);
Var RowNo,FNo,Elm:integer;
begin

 FNo := GetFormNo('PEVENTS');
 if Ret[RetNo].Frm[Fno].Count = 0 then InitFormData(RetNo,FNo);

 With StringGrid1 do
 begin
   Elm:=3;
   For RowNo:=1 to RowCount do
   begin
    StoreElm(RetNo,FNo,Elm,Cells[0,RowNo]); {Descr}
    StoreElm(RetNo,FNo,Elm+1,Cells[1,RowNo]); {From Yr}
    StoreElm(RetNo,FNo,Elm+2,Cells[2,RowNo]); {To yr}
    StoreElm(RetNo,FNo,Elm+3,Cells[3,RowNo]); {W or C}
    StoreElm(RetNo,FNo,Elm+4,Cells[4,RowNo]); {Amount}
    StoreElm(RetNo,FNo,Elm+5,Cells[5,RowNo]); {Non sh %}
    StoreElm(RetNo,FNo,Elm+6,Cells[6,RowNo]); {Semi sh %}
    StoreElm(RetNo,FNo,Elm+7,Cells[7,RowNo]); {Shelt}
    StoreElm(RetNo,FNo,Elm+8,Cells[8,RowNo]); {oth}
    {StoreElm(RetNo,FNo,Elm+9,'');} {begin}
    Inc(Elm,11);
   end;
 end;
 Calc(RetNo,'PEVENTS');
 Ret[RetNo].FrmHasData[FNo]:=True;
 Ret[retNo].Changed := True;
end;


procedure TLifeEventsFP_2012.PrintClick(Sender: TObject);
begin
 StoreData(RetNo);
 If PrintDialog1.Execute then PrintForm(RetNo,'PEVENTS',99);
end;

procedure TLifeEventsFP_2012.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
EditGrid;
end;

procedure TLifeEventsFP_2012.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
FillToYear;
end;

procedure TLifeEventsFP_2012.ChartsBtnClick(Sender: TObject);
begin
 StoreData(RetNo);
 CalcAll(RetNo);
 Close;
end;

procedure TLifeEventsFP_2012.Label15Click(Sender: TObject);
begin
 StoreData(RetNo);
 CalcAll(RetNo);
 Close;
 OpenForm(RetNo,GetFormNo('LIVINGEXP_1'),0);
end;

procedure TLifeEventsFP_2012.Label17Click(Sender: TObject);
begin
 StoreData(RetNo);
 CalcAll(RetNo);
 Close;
 OpenForm(RetNo,GetFormNo('ANNINC'),0);
end;

end.
