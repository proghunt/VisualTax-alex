unit FP_2027probate;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,FP_2027Declare,VCLTee.TeEngine,VCLTee.Series,VCLTee.TeeProcs,VCLTee.Chart; //20150819  Igor

type
  TProbateFP_2012 = class(TForm)
    Memo1: TMemo;
    Panel3: TPanel;
    Chart1: TChart;
    Series1: TBarSeries;
    GroupBox1: TGroupBox;
    EstateValueBox: TEdit;
    CalcBtn: TBitBtn;
    Label2: TLabel;
    ProbateValueBox: TEdit;
    CancelBtn: TBitBtn;
    XferFeesBtn: TBitBtn;
    Label1: TLabel;
    Label4: TLabel;
    PrvBox: TComboBox;
    ShowChartBtn: TBitBtn;
    Label3: TLabel;
    Label5: TLabel;
    MinEstateAxisBox: TEdit;
    Label6: TLabel;
    MaxEstateAxisBox: TEdit;
    Label7: TLabel;
    XferProbate: TCheckBox;
    //procedure CalcBtnClick(Sender: TObject);
    {Function  CalcProbate(Estate:Real;Prv:String):Real;}
    procedure FormCreate(Sender: TObject);
    procedure ShowChart;
    procedure CalcIt;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EstateValueBoxKeyPress(Sender: TObject; var Key: Char);
    procedure CalcBtnExit(Sender: TObject);
    procedure EstateValueBoxChange(Sender: TObject);
    //procedure XferFeesBtnClick(Sender: TObject);
    procedure PrvBoxChange(Sender: TObject);
    procedure ShowChartBtnClick(Sender: TObject);
    procedure MinEstateAxisBoxExit(Sender: TObject);
    procedure GroupBox1Exit(Sender: TObject);
    procedure XferProbateFees;
  private
    { Private declarations }
  public
    RetNo : Integer;
  end;

var
  Probate: TProbateFP_2012;

implementation

{$R *.DFM}

uses Contnrs,vtCommon,FP_2027,FP_2027TrimStr,FP_2027ChildWinNew,FP_2027Common2,
  FP_2027Calc,vtTrimStr,vtShared;

procedure TProbateFP_2012.FormCreate(Sender: TObject);
Var I:integer;IncrBy:Integer;
begin
  RetNo:=GetCurrentRetNo;
  ShowChartBtnClick(Sender);
  //ShowChart;
end;


procedure TProbateFP_2012.CalcIt;
Var i:Integer;Prv :String;Estate:Real;
begin
  FormatSettings.DecimalSeparator:='.';
  Prv := PrvBox.Text;
  Estate := Vl(EstateValueBox.Text);
  ProbateValueBox.Text := FormatFloat('##,###,###.00',CalcProbate(Estate,Prv));
end;


procedure TProbateFP_2012.CancelBtnClick(Sender: TObject);
begin
If XferProbate.Checked then XferProbateFees;
ProbateList.Clear;
Close;
end;

procedure TProbateFP_2012.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 {CancelBtnClick(Sender);}
end;

procedure TProbateFP_2012.EstateValueBoxKeyPress(Sender: TObject; var Key: Char);
begin
If Key=#13 then CalcIt;
end;

procedure TProbateFP_2012.CalcBtnExit(Sender: TObject);
begin
  CalcIt;
end;

procedure TProbateFP_2012.EstateValueBoxChange(Sender: TObject);
begin
 CalcIt;
 ShowChartBtnClick(Sender);
end;

procedure TProbateFP_2012.XferProbateFees;
Var FNo : Integer;
begin
  FNo := GetFormNo('INSNEED');
  if Ret[RetNo].Frm[Fno].Count = 0 then InitFormData(RetNo,FNo);
  StoreElm(RetNo,FNo,19,ProbateValueBox.Text);
  Calc(RetNo,'INSNEED');
  //ShowMessage('Done'); ////OpenForm(RetNo,FNo);
end;

procedure TProbateFP_2012.PrvBoxChange(Sender: TObject);
Var IncrBy:Integer;
begin
  CalcIt;
  ShowChartBtnClick(Sender);
end;

procedure TProbateFP_2012.ShowChartBtnClick(Sender: TObject);
Var i:Integer;IncrBy:Integer; MinEstateAxis,MaxEstateAxis:Real;Prv:String;
begin
  Prv:=PRVBox.Text;
  If Prv='' then Exit;

  MaxEstateAxisBox.Text:=EstateValueBox.Text;
  MinEstateAxis:=Vl(MinEstateAxisBox.Text);
  MaxEstateAxis:=vl(MaxEstateAxisBox.Text); //Vl(MaxEstateAxisBox.Text);

  ProbateList.Free;
  ProbateList := TProbateList.Create;
  IncrBy:=10000; // IncrBy:=10;
  i:=0;  //Trunc(MinEstateAxis);
  Repeat
   ProbateRec := TProbateRec.Create;
   ProbateRec.Estate  := i;
   ProbateRec.Probate := CalcProbate(ProbateRec.Estate,Prv);
   ProbateList.Add(ProbateRec);
   Inc(i,IncrBy);
  until i>MaxEstateAxis;
  ShowChart;
end;

procedure TProbateFP_2012.ShowChart;
Var i,Density:Integer;
begin
// Density :=2;
 Series1.Clear;

  If ProbateList.Count <50 then density :=1
  else if ProbateList.count<100  then density:=2
  else density :=3;

  i:=0;
  Repeat
   TObject(ProbateRec) := ProbateList.Items[i];
   Series1.Add(Round(ProbateRec.Probate),'$'+FloatToStr(ProbateRec.Estate/1000)+'K',clTeeColor);
   Inc(i,Density); {every  1,2 or 3years}
  until i>ProbateList.Count-1;
end;

procedure TProbateFP_2012.MinEstateAxisBoxExit(Sender: TObject);
begin
ShowChartBtnClick(Sender);
end;

procedure TProbateFP_2012.GroupBox1Exit(Sender: TObject);
begin
ShowChartBtnClick(Sender);
end;

end.
