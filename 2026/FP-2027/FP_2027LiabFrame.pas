unit FP_2027LiabFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,vtLabel,vtShape,FP_2027Declare;

type
  TLiabFrameFP_2012 = class(TFrame)
    UnPaidBills: TBitBtn;
    CreditCards: TBitBtn;
    Mortgages: TBitBtn;
    BankAdv: TBitBtn;
    TaxPayable: TBitBtn;
    CarLoans: TBitBtn;
    OthLongTerm: TBitBtn;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtShape6: TvtShape;
    vtLabel3: TvtLabel;
    procedure UnPaidBillsClick(Sender: TObject);
    procedure BankAdvClick(Sender: TObject);
    procedure CreditCardsClick(Sender: TObject);
    procedure TaxPayableClick(Sender: TObject);
    procedure CarLoansClick(Sender: TObject);
    procedure MortgagesClick(Sender: TObject);
    procedure OthLongTermClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}


uses vtCommon,FP_2027ChildWinNew,FP_2027TrimStr,vtTrimStr,vtShared;
  
procedure TLiabFrameFP_2012.UnPaidBillsClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('UNPAIDBILLS#1'),0);
end;

procedure TLiabFrameFP_2012.BankAdvClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('BANKADV#1'),0);
end;

procedure TLiabFrameFP_2012.CreditCardsClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('CREDITCARDS#1'),0);
end;

procedure TLiabFrameFP_2012.TaxPayableClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('TAXPAYABLE#1'),0);
end;

procedure TLiabFrameFP_2012.CarLoansClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('CARLOANS#1'),0);
end;

procedure TLiabFrameFP_2012.MortgagesClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('MORTGAGES#1'),0);
end;

procedure TLiabFrameFP_2012.OthLongTermClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('OTHERLTL#1'),0);
end;

end.
