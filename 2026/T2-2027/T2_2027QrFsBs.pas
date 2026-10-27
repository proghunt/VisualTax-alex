unit T2_2027QrFsBs;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  QuickRpt,Db,Qrctrls,T2_2027trimStr,T2_2027Declare,StdCtrls,
  T2_2027ChildWinNew, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;

type
  TQRFSBST2_2027 = class(TForm)
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRLabel2: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel4: TQRLabel;
    QRExpr1: TQRExpr;
    QRLabel3: TQRLabel;
    TitleBox: TQRShape;
    TitleLbl: TQRLabel;
    PrintDate: TQRLabel;
    QRLabel1: TQRLabel;
    AmountLbl: TQRLabel;
    QRLabel6: TQRLabel;
    ReturnName: TQRLabel;
    AccountLbl: TQRLabel;
    YearEndLbl: TQRLabel;
    QRLabel8: TQRLabel;
    QRShape1: TQRShape;
    QRShape3: TQRShape;
    QRLabel7: TQRLabel;
    QRvtcertification: TQRLabel;
    QRShape2: TQRShape;
    QrAppVersion: TQRLabel;
    FDConnection: TADConnection;
    Table1: TADTable;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QRBand3BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private
    RetNo: integer;
  public
    { Public declarations }
  end;

var
  QRFSBS: TQRFSBST2_2027;
  BsFormNm : string; //[15];
  StatementNo:string; //[1];
implementation
{$R *.DFM}
// Uses UGifiBsEdit;
uses vtMulti,vtCommon,vtTrimStr,vtShared,vtDataBase;

procedure TQRFSBST2_2027.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
  TitleBox.Brush.Color := GetRetColor(RetNo);

  //20150922 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + GiFibsDBLite, GiFibsTableLite, 'LINENO');
  // Table1.IndexName:='LINENO'; //20091129
end;

procedure TQRFSBST2_2027.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Table1.Close;
 Close;
end;

procedure TQRFSBST2_2027.QRBand3BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
Var Displ:Integer; x:real;
begin
 qrAppVersion.caption:='Version '+Appversion;
 Displ:=30;
 With Table1 do
 begin
   If AllTrim(FieldByName('Parent').AsString) = '' then
    begin
     QrDBText1.Font.Style := [fsBold];
     QrDBText4.Font.Style := [fsBold];
     AmountLbl.Font.Style := [fsBold];
     QrDBText1.Left := Displ;
    end
   else If UpperCase(AllTrim(FieldByName('Calculated').AsString)) = 'Y' then
    begin
     QrDBText1.Font.Style := [fsBold];
     QrDBText4.Font.Style := [fsBold];
     AmountLbl.Font.Style := [fsBold];
     QrDBText1.Left := Displ; //Displ+15;
    end
   else
     begin
       QrDBText1.Font.Style := [];
       QrDBText4.Font.Style := [];
       AmountLbl.Font.Style := [];
       QrDBText1.Left := Displ; //Displ+30;
     end;

 {Print amount}
    If RetNo<1 then exit;
    x:=Vl(FetchGifiElm(RetNo,BsFormNm,FieldByName('LineNo').AsString));
    If (AllTrim(FieldByName('Parent').AsString) = '')
    or (UpperCase(AllTrim(FieldByName('Calculated').AsString)) = 'Y') then
     PrintBand := True
    else
    begin
     If x=0 then
      PrintBand := False
     else
      PrintBand :=True;
    end;

    If ((FieldByName('LineNo').AsString = '2599')
    or (FieldByName('LineNo').AsString = '3499')
    or (FieldByName('LineNo').AsString = '3640')
    or (FieldByName('LineNo').AsString = '3849'))
    then
     QrBand3.height := 24
    else
     QrBand3.height := 16;


   //to stop from printing lines - 20090611
   if (FieldByName('LineNo').AsString = '9970') or
      (FieldByName('LineNo').AsString = '9975') or
      (FieldByName('LineNo').AsString = '9976') or
      (FieldByName('LineNo').AsString = '9980') or
      (FieldByName('LineNo').AsString = '9985') or
      (FieldByName('LineNo').AsString = '9990') or
      (FieldByName('LineNo').AsString = '9995') or
      (FieldByName('LineNo').AsString = '9998') or
      (FieldByName('LineNo').AsString = '9999') then
   begin
    PrintBand := false;
   end;

    If PrintBand = False then exit;
    AmountLbl.Font.Name := 'Courier New';
    AmountLbl.Caption :=
    JustRight(FormatFloat('##,###,##0',x),14);
  end; {Table1}
end;

procedure TQRFSBST2_2027.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  QRvtcertification.caption:=RSIApprovalCode;
  StatementNo := AllTrim(IntToStr(GifiStmNoToPrint));
  If StatementNo = '1' then
  begin
   BsFormNm := 'GIFIBS#1';
   TitleLbl.Caption := 'GIFI Closing Balance Sheet - Schedule 100';
   end
  else if StatementNo = '2' then
   begin
   BsFormNm := 'GIFIBS#2';
   TitleLbl.Caption := 'GIFI Opening Balance Sheet - Schedule 101';
   end;

  (*
  If GifiBsEdit.BsNoBox.ItemIndex = 0 then
  begin
   BsFormNm := 'GIFIBS#1';
   TitleLbl.Caption := 'GIFI Closing Balance Sheet - Schedule 100';
   end
 else
   begin
    BsFormNm := 'GIFIBS#2';
    TitleLbl.Caption := 'GIFI Opening Balance Sheet - Schedule 101';
   end;
 *)
  PrintDate.Caption:=FormatDateTime('yyyy/mm/dd',Date);
  TitleBox.Brush.Color:=clWhite;
  If RetNo>0 then
  begin
   ReturnName.Caption := LeftStr(GetCorpName(RetNo),58);
   AccountLbl.Caption := ReformatBn(GetAccountNumber(RetNo));
   YearEndLbl.Caption := GetTaxationYearEnd(RetNo);
  end;
end;

end.
