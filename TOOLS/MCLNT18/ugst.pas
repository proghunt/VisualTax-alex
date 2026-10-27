unit UGST;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  TrimStr,UDeclare;

type
  TGST = class(TForm)
    FromDate: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ToDate: TEdit;
    Label3: TLabel;
    TotGstHst: TEdit;
    Label4: TLabel;
    OKbtn: TButton;
    CancelBtn: TButton;
    ListBox1: TListBox;
    labelx: TLabel;
    TotPayPal: TEdit;
    lblxx: TLabel;
    TotSalesWithGst: TEdit;
    Label5: TLabel;
    TotInterac: TEdit;
    Label6: TLabel;
    TotMail: TEdit;
    Label7: TLabel;
    TotAll: TEdit;
    Label8: TLabel;
    TotDiff: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    TotSalesWithoutGst: TEdit;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKbtnClick(Sender: TObject);
    Function GetPrvNdx(Prv:String):Integer;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GST: TGST;

implementation

uses uclients;

{$R *.DFM}

procedure TGST.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TGST.OKbtnClick(Sender: TObject);
var i,k:Integer;
SalesWithGst: Array [1..14] Of Real;
SalesWithoutGst: Array [1..14] Of Real;
SalesPaypal:Array [1..14] Of Real;
SalesInterac:Array [1..14] Of Real;
SalesMail:Array [1..14] Of Real;
//Rates: Array [1..14] Of Real;
GstHstCollected:Array [1..14] Of Real;
//QuickGstHstDue:Array [1..14] Of Real;
TotalGstHstCollected:Real;
//TotalGstHstDue:Real;
TotalSalesWithGst:Real;
TotalSalesWithoutGst:Real; 
TotalPaypal,TotalInterac,TotalMail:Real;

begin
 If (Length(FromDate.Text) <> 8)
 Or (Length(ToDate.Text) <> 8)
 Or (ToDate.text<ToDate.Text) then
 begin
  ShowMessage('Dates are incorrect');
  Exit;
 end;


 For i:=1 to 14 do
 begin
  SalesWithGst[i]:=0;
  SalesWithoutGst[i]:=0;
  GstHstCollected[i]:=0;
 // QuickGstHstDue[i]:=0;
  SalesPayPal[i]:=0;
  SalesInterac[i]:=0;
  SalesMail[i]:=0;
  {
  SalesPaypal[i]:=0;
  SalesInterac[i]:=0;
  SalesMail[i]:=0;
  }
 end;
 TotalGstHstCollected:=0;
// TotalGstHstDue:=0;
 TotalPaypal:=0;
 TotalInterac:=0;
 TotalMail:=0;
 TotalSalesWithGst:=0;  //20160130
 TotalSalesWithoutGst:=0;  //20160130

 clients.Query1.First;
 Repeat
  If (AllTrim(Clients.Query1.FieldByName('ORDATE').AsString)>'')
  and (AllTrim(Clients.Query1.FieldByName('ORDATE').AsString)>=FromDate.text)
  and (AllTrim(Clients.Query1.FieldByName('ORDATE').AsString)<=ToDate.text)
  then
  begin
   k:=GetPrvNdx(Clients.Query1.FieldByName('PROVINCE').AsString);
   If k>0 then
   Begin
    SalesWithGst[k]:=SalesWithGst[k]+Clients.Query1.FieldByName('PAID').AsFloat;
    If UpperCase(Clients.Query1.FieldByName('How_Ord').AsString) = 'PAYPAL' then
     SalesPayPal[k]:=SalesPayPal[k]+Clients.Query1.FieldByName('PAID').AsFloat;

    If UpperCase(Clients.Query1.FieldByName('How_Ord').AsString) = 'INTERAC' then
     SalesInterac[k]:=SalesInterac[k]+Clients.Query1.FieldByName('PAID').AsFloat;

    If UpperCase(Clients.Query1.FieldByName('How_Ord').AsString) = 'MAIL' then
     SalesMail[k]:=SalesMail[k]+Clients.Query1.FieldByName('PAID').AsFloat;
   end;
  end;
  Clients.Query1.Next;
 until Clients.Query1.EOF;
 Clients.Query1.First;
 ListBox1.Items.Clear;
 //show results

 For i:=1 to 14 do
 begin
   SalesWithoutGst[i]:=(SalesWithGst[i]/(100+vl(GstRate[i])))* 100;
   GstHstCollected[i]:=GstHstCollected[i]+SalesWithoutGst[i] *Vl(GstRate[i])/100;

   ListBox1.Items.add
    ( PrvShort[i]+
      PaddR('  SalesWithGst=',15)+PaddR(FormatFloat('####,###.#0',SalesWithGst[i]),15)
     +PaddR('  Gst/Hst collected=',15)+PaddR(FormatFloat('####,###.#0',GstHstCollected[i]),15)
     +PaddR('  SalesPaypal=',15)+PaddR(FormatFloat('####,###.#0',SalesPaypal[i]),15)
     +PaddR('  SalesInterac=',15)+PaddR(FormatFloat('####,###.#0',SalesInterac[i]),15)
     +PaddR('  SalesMail=',15)+PaddR(FormatFloat('####,###.#0',SalesMail[i]),15)
    // +'  Gst/Hst DUE='+PaddR(FormatFloat('###,###.#0',QuickGstHstDue[i]),15)
      );

   TotalSalesWithGst:=TotalSalesWithGst+SalesWithGst[i]; //SalesWithoutGst[i];   //20160130
   TotalGstHstCollected:=TotalGstHstCollected+GstHstCollected[i];
   // TotalGstHstDue:=TotalGstHstDue+QuickGstHstDue[i];
   TotalPaypal:=TotalPayPal+SalesPaypal[i];
   TotalInterac:=TotalInterac+SalesInterac[i];
   TotalMail:=TotalMail+SalesMail[i];
   TotalSalesWithoutGst:=TotalSaleswithGst-TotalGstHstCollected;
 end;

 TotSalesWithGst.text:=FormatFloat('###,###,###.#0',TotalSalesWithGst);

 TotSalesWithoutGst.text:=FormatFloat('###,###,###.#0',TotalSalesWithoutGst);  //20160130
 TotGstHst.text:=FormatFloat('###,###,###.#0',TotalGstHstCollected);

 TotMail.text:=FormatFloat('###,###,###.#0',TotalMail);
 TotPaypal.text:=FormatFloat('###,###,###.#0',TotalPayPal);
 TotInterac.text:=FormatFloat('###,###,###.#0',TotalInterac);


 TotAll.text:=FormatFloat('###,###,###.#0',TotalMail+TotalPayPal+TotalInterac);
 TotDiff.text:=FormatFloat('###,###,###.#0',TotalMail+TotalPayPal+TotalInterac-TotalSalesWithGst);


end;

Function TGST.GetPrvNdx(Prv:String):Integer;
Var i:Integer;
begin
 Result:=0;
 For i:=1 to 14 do
 begin
  If Prv=PrvShort[i] then
  begin
   Result:=i;
   Exit;
  end;
 end;

end;

procedure TGST.FormCreate(Sender: TObject);
begin
  FromDate.Text:='20161001';
  ToDate.Text:='20161231';
end;

end.
