unit ULiabFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, vtLabel, vtShape,
  UDeclare;
type
  TLiabFrame = class(TFrame)
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

Uses ChildWinNew,TrimStr;
procedure TLiabFrame.UnPaidBillsClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('UNPAIDBILLS#1'),0);
end;

procedure TLiabFrame.BankAdvClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('BANKADV#1'),0);
end;

procedure TLiabFrame.CreditCardsClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('CREDITCARDS#1'),0);
end;

procedure TLiabFrame.TaxPayableClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('TAXPAYABLE#1'),0);
end;

procedure TLiabFrame.CarLoansClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('CARLOANS#1'),0);
end;

procedure TLiabFrame.MortgagesClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('MORTGAGES#1'),0);
end;

procedure TLiabFrame.OthLongTermClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('OTHLONGTERM#1'),0);
end;

end.
