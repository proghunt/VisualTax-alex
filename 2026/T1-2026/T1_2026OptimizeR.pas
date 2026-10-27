unit T1_2026optimizer;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,vtLabel,vtShape,ExtCtrls;

type
  TOptimizeRT1_2026 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    vtShape6: TvtShape;
    vtLabel1: TvtLabel;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    PayBefore: TEdit;
    PayAfter: TEdit;
    TaxSavings: TEdit;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptimizeR: TOptimizeRT1_2026;

implementation

{$R *.DFM}

uses vtCommon,vtTrimStr,T1_2026TrimStr,T1_2026Declare,T1_2026ChildWinNew;

procedure TOptimizeRT1_2026.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TOptimizeRT1_2026.FormCreate(Sender: TObject);
Var RetNo,FNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 FNo:=GetFormNo('OPTIMIZE');
 FormatSettings.DecimalSeparator:='.'; // 20150727
 PayBefore.Text:=JustRight(FormatFloat('###,###,###.00',Vl(FetchElmFNo(RetNo,FNo,22))),10);
 PayAfter.Text:=JustRight(FormatFloat('###,###,###.00',Vl(FetchElmFNo(RetNo,FNo,25))),10);
 TaxSavings.Text:=JustRight(FormatFloat('###,###,###.00',Vl(FetchElmFNo(RetNo,FNo,26))),10);
end;

end.
