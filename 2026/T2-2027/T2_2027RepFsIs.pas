unit T2_2027RepFsIs;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  QuickRpt,Qrctrls,Db,T2_2027trimStr,T2_2027Declare,T2_2027ChildWinNew,
  uADStanIntf, uADStanOption, uADStanParam, uADStanError, uADDatSManager,
  uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf,
  uADStanDef, uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet;

type
  TRepFSIST2_2027 = class(TForm)
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    QRLabel2: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel4: TQRLabel;
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
    QRBand4: TQRBand;
    QRExpr1: TQRExpr;
    QRLabel3: TQRLabel;
    QRLabel7: TQRLabel;
    QRvtcertification: TQRLabel;
    QRShape2: TQRShape;
    QRLabel28: TQRLabel;
    QrLine0002: TQRLabel;
    QrOperName: TQRLabel;
    QrAppVersion: TQRLabel;
    QRLabel9: TQRLabel;
    Table1: TADTable;
    FDConnection: TADConnection;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QRBand3BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    Procedure GetExtraLines(RetNo:Integer);
  private
    StatementNo: String;
    IsFormNm : String;
    Line9970:Real;
  public
    RetNo: integer;
  end;

//var  RepFSIS: TRepFSIST2_2013;

procedure RepFSIS(RNo: integer; SeqNo: string);

implementation

{$R *.DFM}
uses vtTrimStr,vtMain,vtMulti,T2_2027GifiIsEdit,vtCommon,T2_2027main,vtShared,vtDataBase;

procedure RepFSIS(RNo: integer; SeqNo: string);
begin
  with TRepFSIST2_2027.Create(Application) do
  begin
    RetNo := RNo;
    //StatementNo := RmvLeadingZeros(AllTrim(GifiIsEdit.SeqNoBox.Text));  //20111128
    StatementNo := RmvLeadingZeros(AllTrim(SeqNo));  //20111128
    ShowModal;
    Free;
  end;
end;

procedure TRepFSIST2_2027.FormCreate(Sender: TObject);
begin
 //StatementNo := RmvLeadingZeros(AllTrim(GifiIsEdit.SeqNoBox.Text));  //20111128
  //20111129
  IsFormNm :=  'GIFIIS#'+StatementNo;
  If StatementNo>'1' then
  begin
   QrLine0002.caption:='0002';
   QROperName.caption:=FetchElm(RetNo,IsFormNm,3);
  end
  else
  begin
   QrLine0002.caption:='';
   QROperName.caption:='';
  end;
  qrAppVersion.caption:='Version '+Appversion;
 //to relocate income summury to statement 125
 GetExtraLines(RetNo);   //20090611

 TitleBox.Brush.Color := GetRetColor(GetCurrentRetNo);

 //20150922 Igor
 SetTableName(FDConnection, Table1, AppDir + '\' + GiFiisDBLite, GiFiisTableLite, 'PRNSEQ');
 // Table1.IndexName:='LINENO';
end;

procedure TRepFSIST2_2027.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Table1.Close;
 Close;
end;

procedure TRepFSIST2_2027.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  //StatementNo := RmvLeadingZeros(AllTrim(GifiIsEdit.SeqNoBox.Text));
  IsFormNm :=  'GIFIIS#'+StatementNo;
  TitleLbl.Caption := 'GIFI Income Statement #'+StatementNo +' - Schedule 125';
  QRvtcertification.Caption:=RSIApprovalCode;
  TitleBox.Brush.Color:=clWhite;
  PrintDate.Caption:=FormatDateTime('yyyy/mm/dd',Date);
  If RetNo>0 then
  begin
   ReturnName.Caption := GetCorpName(RetNo);  //20111127
  // ReturnName.Caption := LeftStr(GetCorpName(RetNo),58);
   AccountLbl.Caption := ReformatBn(GetAccountNumber(RetNo));
   YearEndLbl.Caption := GetTaxationYearEnd(RetNo);
  end;

end;

procedure TRepFSIST2_2027.QRBand3BeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
Var
 Displ:Integer;x:Real;
 dpiAdjustment, ExtraDPIAdjustment:Integer;
begin
 Displ:=30;  //20091129
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
     QrDBText1.Left := Displ; //Displ+15;  //20091129
   end
   else
   begin
       QrDBText1.Font.Style := [];
       QrDBText4.Font.Style := [];
       AmountLbl.Font.Style := [];
       QrDBText1.Left := Displ; // Displ+15;  //20091129

   end;
    //20111128
    If ((FieldByName('LineNo').AsString = '9975')
    or (FieldByName('LineNo').AsString = '9976')
    or (FieldByName('LineNo').AsString = '9980')
    or (FieldByName('LineNo').AsString = '9985')
    or (FieldByName('LineNo').AsString = '9990')
    or (FieldByName('LineNo').AsString = '9995'))
    then
    begin
     QrDBText1.Font.Style := [];
     QrDBText4.Font.Style := [];
     AmountLbl.Font.Style := [];
    end;

    {Print amount}
    If RetNo<1 then exit;
    x:=Vl(FetchGifiElm(RetNo,IsFormNm,FieldByName('LineNo').AsString));
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

    dpiAdjustment := ( GetWindowsFontSize(MainForm.Handle) * 100) div 96; //DesignPixelsPerInch;
    ExtraDPIAdjustment := 0;
    if dpiAdjustment >= 150 then
    begin
      ExtraDPIAdjustment := 7;
    end
    else if dpiAdjustment >= 120 then
    begin
      ExtraDPIAdjustment := 5;
    end;

    If ((FieldByName('LineNo').AsString = '8299')
    or (FieldByName('LineNo').AsString = '8519')
    or (FieldByName('LineNo').AsString = '9368')
    or (FieldByName('LineNo').AsString = '9369')
    or (FieldByName('LineNo').AsString = '9999')    //20111128
    or (FieldByName('LineNo').AsString = '9970'))  //20111128
    then
     QrBand3.height := 24 + ExtraDPIAdjustment
    else
     QrBand3.height := 16 + ExtraDPIAdjustment;

    If (FieldByName('LineNo').AsString = '9659') and (x=0) then PrintBand := False;
    If (FieldByName('LineNo').AsString = '9898') and (x=0) then PrintBand := False;
    If (FieldByName('LineNo').AsString = '9899') and (x=0) then PrintBand := False;
    If (FieldByName('LineNo').AsString = '9998') and (x=0) then PrintBand := False;  //20111127

    //20111129
    If CountIncStatements(RetNo) > 1 then
    begin
     If ((FieldByName('LineNo').AsString = '9975')
     or (FieldByName('LineNo').AsString = '9976')
     or (FieldByName('LineNo').AsString = '9980')
     or (FieldByName('LineNo').AsString = '9985')
     or (FieldByName('LineNo').AsString = '9990')
     or (FieldByName('LineNo').AsString = '9995')
     or (FieldByName('LineNo').AsString = '9998')
     or (FieldByName('LineNo').AsString = '9999')
     )
     then
     PrintBand:=false;
    end;

    (* 20111130
    //20111128
    If (FieldByName('LineNo').AsString = '9999')
    or (FieldByName('LineNo').AsString = '9998')
    then
    begin
     If CountIncStatements(RetNo) >1 then QrDBText1.Left:=-200;  //do ot show it
    end;
    *)
    If PrintBand = False then exit;
    AmountLbl.Font.Name := 'Courier New';
    AmountLbl.Caption := JustRight(FormatFloat('##,###,##0',x),14);



 end; {Table1}
end;

Procedure TRepFSIST2_2027.GetExtraLines(RetNo:Integer);
Var  Tbl:TADTable;
begin
 //20111128
 (*
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := AppDir;
  Tbl.TableName := GIFIBS.DB F;
  If StatementNo='1' then  //20111127
  begin
  // Amount9970.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIBS#1','9970'))),14);   //20090611
   Amount9975.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIBS#1','9975'))),14);
   Amount9976.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIBS#1','9976'))),14);
   Amount9980.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIBS#1','9980'))),14);
   Amount9985.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIBS#1','9985'))),14);
   Amount9990.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIBS#1','9990'))),14);
   Amount9995.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIBS#1','9995'))),14);
  end;
  //20111127
 //  Amount9999.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIBS#1','9999'))),14);
  Tbl.free;
 *)
  //20111129
(*
  //20111127
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := AppDir;
  Tbl.TableName := GIFIIS.DB F;
  {
  Amount7000.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'7000'))),14);
  Amount7002.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'7002'))),14);
  Amount7004.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'7004'))),14);
  Amount7006.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'7006'))),14);
  Amount7008.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'7008'))),14);
  Amount7010.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'7010'))),14);
  Amount7020.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'7020'))),14);
  }

  //Amount9970.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'9369'))+Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'9899'))),14);   //20111128

 // Amount9998.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIIS'+StatementNo,'9998'))),14);
  Tbl.free;

  Amount9999.Caption := JustRight(FormatFloat('###,###,##0',Vl(FetchGifiElm(RetNo,'GIFIBS#1','9999'))),14);
  Tbl.free;

 *)
end;


end.
