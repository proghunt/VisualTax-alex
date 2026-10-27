unit FP_2027riffrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Spin,Buttons,Grids,FP_2027Declare;

type
  TRIFFrmFP_2012 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RulesBtn: TRadioGroup;
    YrStart: TEdit;
    OpBalance: TEdit;
    Rte: TEdit;
    RateSpin: TSpinButton;
    ImageX: TImage;
    CancelBtn: TBitBtn;
    CalcBtn: TBitBtn;
    ByYearOrAge: TRadioGroup;
    StringGrid2: TStringGrid;
    HeaderBox: TPanel;
    Label4: TLabel;
    BirthdateBox: TEdit;
    Label5: TLabel;
    Procedure CalcRif(RetNo:Integer);
    Procedure ShowChart(RetNo:Integer);
    Procedure ShowBalances(RetNo:Integer);
    procedure FormCreate(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure RateSpinDownClick(Sender: TObject);
    procedure RateSpinUpClick(Sender: TObject);
    procedure ByYearOrAgeClick(Sender: TObject);
    procedure OpBalanceChange(Sender: TObject);
    procedure RulesBtnClick(Sender: TObject);
    Procedure BuildStream(RetNo:Integer;OpeningBalance:Real;YearRifStarted:Integer;Rules:String;Rate:Real);
    procedure YrStartExit(Sender: TObject);
    procedure BirthdateBoxExit(Sender: TObject);
    procedure OpBalanceExit(Sender: TObject);
    procedure RteExit(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    RetNo:Integer;
  end;

var
  RIFFrm: TRIFFrmFP_2012;
  OpeningBalance:Real;
  YearRIFStarted:Integer;
  Rate:Real;
  Rules:string; //[1];
  BirthDate:String;

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,FP_2027ChildWinNew,vtTrimStr,vtShared;

Procedure TRIFFrmFP_2012.CalcRif(RetNo:Integer);
begin
 If Length(BirthdateBox.text) <> 10 then
 begin
  ShowMessage('Please enter a correct BirthDate');
 // BirthDateBox.SetFocus;
 // Exit;
 end;

 If Length(YRStart.text) <> 4 then
 begin
  ShowMessage('Please enter a valid set-up year');
 // YrStart.SetFocus;
 // Exit;
 end;



  OpeningBalance := Vl(OpBalance.Text);
  Rate := Vl(Rte.Text);
  YearRifStarted := MyStrToInt(YrStart.Text);
  If RulesBtn.ItemIndex =0 then Rules:='N' else Rules := 'O';
  BuildStream(RetNo,OpeningBalance,YearRifStarted,Rules,Rate);
  ShowChart(RetNo);
  StringGrid2.RowCount := GenBalanceList.Count+2;
  ShowBalances(RetNo);
end;

Procedure TRIFFrmFP_2012.ShowChart(RetNo:Integer);
Var r:Trect;TempCanvas :TBitMap; YearOrAge:Boolean;
begin
{ exit;}
 If ByYearOrAge.ItemIndex = 0 then YearOrAge:=True else YearOrAge:=False;
 R := Imagex.BoundsRect;
 TempCanvas := TBitMap.Create;
 TempCanvas.Width := Width;
 TempCanvas.Height :=Height;
 TempCanvas.Canvas.Pen.Width := 1;
 TempCanvas.Canvas.Brush.Color := clBtnShadow;
 ChartRIF(RetNo,TempCanvas,R,YearOrAge);
 Self.Canvas.CopyMode := cmSrcCopy;
 Self.Canvas.CopyRect(R,TempCanvas.Canvas,R);
 TempCanvas.Free;

end;


procedure TRIFFrmFP_2012.FormCreate(Sender: TObject);
begin
  RetNo:=GetCurrentRetNo;
  YrStart.Text:=AppYear;
  Rte.Text:='4';
  BirthdateBox.Text:=ClientBirthDate(RetNo);
  RulesBtn.ItemIndex :=0;
  ByYearOrAge.ItemIndex :=1;
  StringGrid2.RowCount := GenBalanceList.Count+2;
end;

procedure TRIFFrmFP_2012.CalcBtnClick(Sender: TObject);
begin
 CalcRif(RetNo);
end;

procedure TRIFFrmFP_2012.RateSpinDownClick(Sender: TObject);
begin
Rte.Text := FormatFloat('###.00',(Vl(Rte.Text) -1));
If Vl(Rte.Text) <0 then Rte.Text:='0';
CalcRif(RetNo);
end;

procedure TRIFFrmFP_2012.RateSpinUpClick(Sender: TObject);
begin
Rte.Text := FormatFloat('###.00',(Vl(Rte.Text) +1));
If Vl(Rte.Text) >100 then Rte.Text:='100';
CalcRif(RetNo);
end;

Procedure TRIFFrmFP_2012.ShowBalances;
Var  i,StreamId,aRow,PrevRow,PrevCol:integer;
   Year,Age: string; //[5];
   BegBal,Contr,WithDr,EndBal:string; //[15];
begin
 With StringGrid2 do
 begin
   {PrevCol := Col;
   PrevRow:=Row;
   }
   Cells[0,0]:='Age';
   Cells[1,0]:='Year';
   Cells[2,0]:='Beg-Bal';
   Cells[3,0]:='Contributions';
   Cells[4,0]:='Withdrawals';
   Cells[5,0]:='End-Bal';
  For i:=1 to GenBalanceList.Count-1 do
   begin
    {aRow := i+1;}
    GenBalanceRec := GenBalanceList.Items[i];
    Age:=IntToStr(GenBalanceRec.Age);
    Year:=IntToStr(GenBalanceRec.Year);
    Cells[0,i] := Age;
    Cells[1,i] := Year;

    Cells[2,i]:=PaddR(FormatFloat('##,###,##0.00',GenBalanceRec.BegBalance),13);
    Cells[3,i]:=PaddR(FormatFloat('##,###,##0.00',GenBalanceRec.RegContr),13);
    Cells[4,i]:=PaddR(FormatFloat('##,###,##0.00',GenBalanceRec.RegWithDr),13);
    Cells[5,i]:=PaddR(FormatFloat('##,###,##0.00',GenBalanceRec.EndBalance),13);
   end; {i}

 end; {stringgrid2}
end;



procedure TRIFFrmFP_2012.ByYearOrAgeClick(Sender: TObject);
begin
CalcRif(RetNo);
end;

procedure TRIFFrmFP_2012.OpBalanceChange(Sender: TObject);
begin
CalcRif(RetNo);
end;

procedure TRIFFrmFP_2012.RulesBtnClick(Sender: TObject);
begin
  CalcRif(RetNo);
end;

Procedure TRIFFrmFP_2012.BuildStream(RetNo:Integer;OpeningBalance:Real;YearRifStarted:Integer;Rules:String;Rate:Real);
 Var i,PlanStartAge:Integer;InterestAmount,RunningBalance,RIFRate:Real;Sep:string; //[1];
begin
  RunningBalance :=0;
  GenBalanceList.Clear;
  BirthDate:=BirthDateBox.Text;
  PlanStartAge := CalcAgeTo(YYYYMMDDToDDMMYYYY(BirthDate),'31-12-'+AllTrim(IntToStr(YearRifStarted))); {GetPlanStartAge(RetNo);}
   // ClientAge(RetNo);
  For i:=0 to 100-PlanStartAge do {GetPlanningPeriods(RetNo) do}
  begin
   GenBalanceRec := TGenBalanceRec.Create;
   GenBalanceRec.PeriodNo      := i;
   GenBalanceRec.Year          := YearRifStarted+i;
   GenBalanceRec.Age           := CalcAgeTo(
      YYYYMMDDToDDMMYYYY(BirthDate),
      YYYYMMDDToDDMMYYYY(IntToStr(GenBalanceRec.Year)+'12-31'));
   GenBalanceRec.Notes         := '';
   GenBalanceRec.BegBalance    :=0;
   GenBalanceRec.RegContr      := 0;
   GenBalanceRec.RegWithDr     :=0;
   GenBalanceRec.LumpSumContr  := 0;
   GenBalanceRec.LumpSumWithDr := 0;
   GenBalanceRec.EndBalance := 0;

   {calc only after maturity date}
   If GenBalanceRec.periodNo = 1 then 
      GenBalanceRec.BegBalance    := OpeningBalance
   else
      GenBalanceRec.BegBalance    := RunningBalance;

    If GenBalanceRec.Year >= YearRifStarted then
    begin
     If Rules = 'O' then
      RifRate := GetOldRifRate(GenBalanceRec.Age)
     else
      RifRate := GetNewRifRate(GenBalanceRec.Age);

     If GenBalanceRec.BegBalance>0 then
     begin
      InterestAmount := GenBalanceRec.BegBalance*(Rate)/100;
      GenBalanceRec.RegWithDr :=GenBalanceRec.BegBalance * RIFRate/100;
        //(GenBalanceRec.BegBalance+InterestAmount)*RIFRate/100;
     end
     else
     begin
      InterestAmount := 0;
      GenBalanceRec.RegWithDr :=0;
     end;

     GenBalanceRec.EndBalance :=
               GenBalanceRec.BegBalance
               +GenBalanceRec.RegContr
               +GenBalanceRec.LumpSumContr
               +InterestAmount
               -GenBalanceRec.RegWithDr
               -GenBalanceRec.LumpSumWithDr;
     RunningBalance := GenBalanceRec.EndBalance;
     GenBalanceRec.EndActual    := 0;
   end; {after yr started}
   GenBalanceList.Add(GenBalanceRec);
  end;

end;


procedure TRIFFrmFP_2012.YrStartExit(Sender: TObject);
begin
If YrStart.text>'1992' then
  RulesBtn.ItemIndex:=0
 else
  RulesBtn.ItemIndex:=1;
 CalcRif(RetNo);
end;

procedure TRIFFrmFP_2012.BirthdateBoxExit(Sender: TObject);
begin
CalcRif(RetNo);
end;

procedure TRIFFrmFP_2012.OpBalanceExit(Sender: TObject);
begin
CalcRif(RetNo);
end;

procedure TRIFFrmFP_2012.RteExit(Sender: TObject);
begin
CalcRif(RetNo);
end;

procedure TRIFFrmFP_2012.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

end.
