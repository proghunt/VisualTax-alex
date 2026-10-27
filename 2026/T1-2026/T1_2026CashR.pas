unit T1_2026cashr;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,DB,Printers,Grids,DBGrids,ComCtrls,ekrtf,ekfunc,
  ekbasereport,vtCommon,T1_2026main, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TCashRepT1_2026 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Panel1: TPanel;
    PrintBtn: TBitBtn;
    CancelBtm: TBitBtn;
    PrintDialog1: TPrintDialog;
    FontDialog1: TFontDialog;
    FromDt: TEdit;
    DBGrid1: TDBGrid;
    Label3: TLabel;
    DataDirBox: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    DataSource1: TDataSource;
    InvoiceReportBtn: TBitBtn;
    ToDt: TEdit;
    Label2: TLabel;
    FDConnection: TADConnection;
    Table1: TADTable;
    EnhancedInvoiceReportBtn: TBitBtn; //20180402 Igor
    procedure FormCreate(Sender: TObject);
   { procedure PreviewBtnClick(Sender: TObject);}
    procedure PrintBtnClick(Sender: TObject);
    procedure PrintHeader;
    procedure PrintColumnNames;
    procedure PrintLine(Items: TStringList);
    Procedure PrintFooter;
    {procedure HdrFontBtnClick(Sender: TObject);}
    procedure CancelBtmClick(Sender: TObject);
    {procedure ReportGroupClick(Sender: TObject);}
    procedure DataDirBoxExit(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure ShowReturns;
    procedure InvoiceReportBtnClick(Sender: TObject);
    procedure EnhancedInvoiceReportBtnClick(Sender: TObject); //20180402 Igor
  private
    { Private declarations }
     PixelsInInchx: integer;       { Stores Pixels per inch }
    LineHeight: Integer;          { Stores the line height }
    TenthsOfInchPixelsY: integer; { Pixels in 1/10 of an inch used for line spacing }
  public
    { Public declarations }
  end;

var
  CashRep: TCashRepT1_2026;
  TotInvAmount,
  ToteTransfer,TotCash,TotCreditCard, TotVisa, TotCheque, TotCharge,TotDebitCard, TotDebit, TotJoint : Real; //20210305

  AmountPrinted: integer;       { Stores amount, in pixels, printed on a page }

procedure BuildEnhancedInvoiceReport(ABeginningDate, AEndingDate: TDateTime; ADir_Cur: string); //20180402 Igor

implementation

{$R *.DFM}

uses vtMulti,T1_2026,T1_2026Common,T1_2026InvoiceRep,T1_2026Declare,
  T1_2026TrimStr,vtTrimStr,vtShared, {T2_2015TrimStr,} //20150826 igor
  //20180402 Igor >>>
  vtPrints, vtDataBase, System.Types, System.IOUtils, Variants, Winapi.ShlObj,
  Winapi.ActiveX, ComObj, vtReportBuilderExport, ShellApi, T1_2026Common2; //20180412 Igor
  //20180402 Igor <<<

(*
{-----------------External DLL Functions----------}
Function PeOpenEngine: Bool; Far; External 'CRPE';
Function PeCloseEngine: Bool; Far; External 'CRPE';
Function PePrintReport
(ReportFilePath: PChar;
 toDefaultPrinter: Boolean;
 toWindow:Boolean;
 Title: PChar;
 left,top,width,height:integer;
 style: longint;
 ParentWindow: Word): Integer; Far; External 'CRPE';
*)
procedure TCashRepT1_2026.FormCreate(Sender: TObject);
begin
    //20150904 igor
  FDConnection.Params.Values['Password'] := OptRec.SQLLitePassword.CurrentPassword; //20160226 Igor
DataDirBox.Text :=OptRec.Dir_Cur;
FromDt.Text :=  FormatDateTime('yyyy-mm-dd',Now);
If ToDt.Text='' then ToDt.Text:=FormatDateTime('yyyy-mm-dd',Now);
ShowReturns;
end;

procedure TCashRepT1_2026.ShowReturns;
begin
  // 20150820 igor
  SetTableName(FDConnection, Table1,
               IncludeTrailingPathDelimiter(DataDirBox.Text) + ClientsDbLite, ClientsTableLite, 'UPDATED_DT')
end;

procedure TCashRepT1_2026.PrintBtnClick(Sender: TObject);
var
  Items: TStringList;
  S : string;
  x : Real;

begin
  If Not PrintDialog1.Execute then exit;
  Screen.Cursor := crHourGlass;
  TotCash := 0; TotVisa := 0;TotCheque := 0;TotInvAmount := 0; TotCharge:=0;TotDebit:=0;

  Items := TStringList.Create;              { Create a new TStringList }
  PixelsInInchx := GetDeviceCaps(Printer.Handle, LOGPIXELSX); { Get Pixels per inch horizonally}
  TenthsOfInchPixelsY := GetDeviceCaps(Printer.Handle, LOGPIXELSY) div 10;

  AmountPrinted := 0;                            { Set to zero }
  try
    CashRep.Enabled := false;                           { Disable the parent Form }
    Printer.BeginDoc;                                  { Initiate a print job }
    Application.ProcessMessages;                       { Allow Drawing of abort box }
    { Calculate a arbitrary line height }
    LineHeight := Printer.Canvas.TextHeight('X')+TenthsOfInchPixelsY;
    PrintHeader;                                     { Print the header }
    PrintColumnNames;                                  { Print the column Names }
    Table1.First;                                      { Go to the first record }
    { Add the data in the fields into a TStringList in the order that they are }
    { Going to be printed }
    while (not Table1.Eof) or Printer.Aborted do begin
      Application.ProcessMessages;
     If (AllTrim(Table1.FieldByName('PAY_Dt').AsString) >= AllTrim(FromDt.text))
     and (AllTrim(Table1.FieldByName('PAY_Dt').AsString) <= AllTrim(ToDt.text))
     and ((Table1.FieldByName('Pay_AMOUNT').AsFloat > 0)
           or (Table1.FieldByName('Inv_AMOUNT').AsFloat > 0))
     then
     begin
      TotInvAmount := TotInvAmount +Table1.FieldByName('Inv_AMOUNT').AsFloat;

      x := Table1.FieldByName('Inv_AMOUNT').AsFloat;
      //20210305
      If Rtrim(Table1.FieldByName('PAY_TYPE').AsString)      = 'eTrans'  then ToteTransfer := ToteTransfer +x
      Else If Rtrim(Table1.FieldByName('PAY_TYPE').AsString) = 'Cash'    then TotCash := TotCash +x
      Else If RTrim(Table1.FieldByName('PAY_TYPE').AsString) = 'Visa'    then TotCreditCard := TotCreditCard +x
      Else If RTrim(Table1.FieldByName('PAY_TYPE').AsString) = 'Credit'  then TotCreditCard := TotCreditCard +x
      Else If Rtrim(Table1.FieldByName('PAY_TYPE').AsString) = 'Debit'   then TotDebitCard := TotDebitCard +x
      Else If Rtrim(Table1.FieldByName('PAY_TYPE').AsString) = 'DebitC'  then TotDebitCard := TotDebitCard +x
      Else If Rtrim(Table1.FieldByName('PAY_TYPE').AsString) = 'Cheque'  then TotCheque := TotCheque +x
      Else If Rtrim(Table1.FieldByName('PAY_TYPE').AsString) = 'Charge'  then TotCharge := TotCharge +x
      Else If Rtrim(Table1.FieldByName('PAY_TYPE').AsString) = 'Joint'   then TotJoint := TotJoint +x;   //needed?

      with Items do begin
        AddObject(Table1.FieldByName('LAST_NAME').AsString+
            '. '+LeftStr(Table1.FieldByName('FIRST_NAME').AsString,1),
            Pointer(14));
        AddObject(Table1.FieldByName('FILE_NAME').AsString,Pointer(8));
        {Convert Prp status}
        S := Table1.FieldByName('PRP_STATUS').AsString;
        S := PrpStatusDescr[StrToInt(Rtrim(Rtrim(s)))];
        AddObject(s,Pointer(10));
       {Convert EF status}
        s := Table1.FieldByName('EF_STATUS').AsString;
        S := EfStatusDescr[StrToInt(Rtrim(Rtrim(s)))];
        AddObject(s,Pointer(10));

        AddObject(Table1.FieldByName('UPDATED_DT').AsString,Pointer(8));
        AddObject(Table1.FieldByName('PAY_INVNO').AsString,Pointer(10));
        AddObject(Table1.FieldByName('PAY_TYPE').AsString,Pointer(8));
       {Convert amount}
        x := Table1.FieldByName('Inv_AMOUNT').AsFloat;
        //x := Table1.FieldByName('PAY_AMOUNT').AsFloat;
        s := JustRight(FormatFloat('###,###.00',x),12);
        AddObject(s,Pointer(10));
      end;
      Printer.Canvas.Font.Name := 'Arial';
      Printer.Canvas.Font.Style := [];
      Printer.Canvas.Font.Size := 8;
      PrintLine(Items);   { Print the line }
      { Force printjob to begin a new page if printed output has exceeded the }
      { Page height }
      if AmountPrinted + LineHeight > Printer.PageHeight then
      begin
        AmountPrinted := 0;         { Reset to zero }
        if not Printer.Aborted then
          Printer.NewPage;          { Force page eject }
        PrintHeader;                { Print the header again }
        PrintColumnNames;           { Print the column names again }
      end;
      Items.Clear;                  { Clear this record from the TStringList }
     end; {end of equal dates block}
     Table1.Next;                  { Go to the next record }
    end;
    PrintFooter;

    {AbortForm.Hide;}                 { Hide the abort form, no longer needed }
    if not Printer.Aborted then
      Printer.EndDoc;               { End the print job }
    CashRep.Enabled := true;
  except
    on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
  Items.Free;                       { Free the TStringList }
  {Table1.Close;}
  ShowMessage('Report Completed');
  Screen.Cursor := crDefault;
end;

procedure TCashRepT1_2026.PrintHeader;
var
 {SaveFont: TFont;}
 s : string;
begin
{ Print out the Header }
 Printer.Canvas.Font.Name := 'Arial';
 Printer.Canvas.Font.Style := [fsBold];
 Printer.Canvas.Font.Size := 14;
  with Printer do begin
    if not Printer.Aborted then
      begin
      Canvas.TextOut((PageWidth div 2)-
         (Canvas.TextWidth('T1-'+AppYear+' TAX CONSULTANT CASH REPORT') div 2)
         ,0,'T1-'+AppYear+' TAX CONSULTANT CASH REPORT');
      Printer.Canvas.Font.Size := 12;
      s := User.M_Office + '-'+ User.Branch + '   '+User.Prep_Name;
      Canvas.TextOut((PageWidth div 2)-
         (Canvas.TextWidth(s) div 2),LineHeight,s);
      s := FromDt.Text + ' to ' + ToDt.Text;
      Canvas.TextOut((PageWidth div 2)-
         (Canvas.TextWidth(s) div 2),LineHeight*2,s);
      Canvas.TextOut(0,LineHeight,' ');  {Empty line}
      AmountPrinted := AmountPrinted + LineHeight * 3+TenthsOfInchPixelsY;
      end;
  end;
end;

procedure TCashRepT1_2026.PrintColumnNames;
var
  ColNames: TStringList;
begin
  ColNames := TStringList.Create;                     { Create the string list }
  Printer.Canvas.Font.Name := 'Arial';
  Printer.Canvas.Font.Size := 8;
  Printer.Canvas.Font.Style := [fsBold, fsUnderline]; { Use a Bold/underline style }
  with ColNames do begin
    { Create the column headers }
    AddObject('Name',        Pointer(14));
    AddObject('File/SIN',    Pointer(8));
    AddObject('Prep Status', Pointer(10));
    AddObject('EFile Status',Pointer(10));
    AddObject('Last Update', Pointer(8));
    AddObject('Invoice No',  Pointer(10));
    AddObject('Paid by',     Pointer(8));
    AddObject('Amount Paid',Pointer(10));
  end;
  PrintLine(ColNames);                 { Print the line }
  Printer.Canvas.Font.Style := [];     { Set to normal style }
  ColNames.Free;                       { Free the string list }
  {Table1.Close;}
end;

procedure TCashRepT1_2026.PrintLine(Items: TStringList);
var
  OutRect: TRect;
  Inches: double;
  i: integer;
begin
  OutRect.Left := 0;                           { left position is zero }
  OutRect.Top := AmountPrinted;                { Set Top to Amount printed }
  OutRect.Bottom := OutRect.Top + LineHeight;  { Set bottom position }
  With Printer.Canvas do
    for i := 0 to Items.Count - 1 do begin
      Inches := longint(Items.Objects[i]) * 0.1;                     { Get inches }
      OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);   { Determine Right position }
      if not Printer.Aborted then
        TextRect(OutRect, OutRect.Left, OutRect.Top, Items[i]);      { Print the line }
      OutRect.Left := OutRect.Right;                                 { Set left to Right }
    end;
  { Increment the amount printed }
  AmountPrinted := AmountPrinted + TenthsOfInchPixelsY*2;
end;

procedure TCashRepT1_2026.CancelBtmClick(Sender: TObject);
begin
 Table1.Close;
 Close;
end;

procedure TCashRepT1_2026.PrintFooter;
var
  OutRect: TRect;
  Inches: double;
  i: integer;
begin
  With Printer.Canvas do
   begin
     if not Printer.Aborted then
        begin
         Inches := 1;  OutRect.Left := round(PixelsInInchx*6.8);
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         OutRect.Top := AmountPrinted;
         OutRect.Bottom := OutRect.Top + LineHeight;
         Printer.Canvas.TextRect(OutRect, OutRect.Left, OutRect.Top,
                '--------------');
         AmountPrinted := AmountPrinted + TenthsOfInchPixelsY;

         Inches := 1;
         OutRect.Left := round(PixelsInInchx*5);
         OutRect.Top := AmountPrinted;
         OutRect.Bottom := OutRect.Top + LineHeight;
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect,
             OutRect.Left, OutRect.Top, 'Invoice Total');
         Inches := 1;  OutRect.Left := round(PixelsInInchx*6.8);
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect, OutRect.Left, OutRect.Top,
                  JustRight(FormatFloat('###,###.00',TotInvAmount),12));
                {JustRight(FormatAmount(FloatToStr(TotInvAmount)),12));}

         AmountPrinted := AmountPrinted + TenthsOfInchPixelsY*3;

         Inches := 1;
         OutRect.Left := round(PixelsInInchx*5); OutRect.Top := AmountPrinted;
         OutRect.Bottom := OutRect.Top + LineHeight;
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect,
             OutRect.Left, OutRect.Top, 'Cash Deposit');
         Inches := 1;  OutRect.Left := round(PixelsInInchx*6.8);
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect, OutRect.Left, OutRect.Top,
                JustRight(FormatFloat('###,###.00',TotCash),12));
               { JustRight(FormatAmount(FloatToStr(TotCash)),12));}
         AmountPrinted := AmountPrinted + TenthsOfInchPixelsY *2;

         Inches := 1;
         OutRect.Left := round(PixelsInInchx*5); OutRect.Top := AmountPrinted;
         OutRect.Bottom := OutRect.Top + LineHeight;
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect,
             OutRect.Left, OutRect.Top, 'Cheque Deposit');
         Inches := 1;  OutRect.Left := round(PixelsInInchx*6.8);
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect, OutRect.Left, OutRect.Top,
              JustRight(FormatFloat('###,###.00',TotCheque),12));
                {JustRight(FormatAmount(FloatToStr(TotCheque)),12));}

         AmountPrinted := AmountPrinted + TenthsOfInchPixelsY*2;

         Inches := 1;
         OutRect.Left :=round(PixelsInInchx*5); OutRect.Top := AmountPrinted;
         OutRect.Bottom := OutRect.Top + LineHeight;
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect,
             OutRect.Left, OutRect.Top, 'Visa Deposit');
         Inches := 1;  OutRect.Left := round(PixelsInInchx*6.8);
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect, OutRect.Left, OutRect.Top,
               JustRight(FormatFloat('###,###.00',TotVisa),12));
               {JustRight(FormatAmount(FloatToStr(TotVisa)),12));}

         AmountPrinted := AmountPrinted + TenthsOfInchPixelsY *2;
         Inches := 1;
         OutRect.Left := round(PixelsInInchx*5); OutRect.Top := AmountPrinted;
         OutRect.Bottom := OutRect.Top + LineHeight;
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect,
             OutRect.Left, OutRect.Top, 'Charge');
         Inches := 1;  OutRect.Left := round(PixelsInInchx*6.8);
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect, OutRect.Left, OutRect.Top,
              JustRight(FormatFloat('###,###.00',TotCharge),12));

         AmountPrinted := AmountPrinted + TenthsOfInchPixelsY *2;
         Inches := 1;
         OutRect.Left := round(PixelsInInchx*5); OutRect.Top := AmountPrinted;
         OutRect.Bottom := OutRect.Top + LineHeight;
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect,
             OutRect.Left, OutRect.Top, 'Debit');
         Inches := 1;  OutRect.Left := round(PixelsInInchx*6.8);
         OutRect.Right := OutRect.Left + round(PixelsInInchx*Inches);
         Printer.Canvas.TextRect(OutRect, OutRect.Left, OutRect.Top,
              JustRight(FormatFloat('###,###.00',TotDebit),12));

        end;
   end;

end;


procedure TCashRepT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
If (ChangeDataDir(DataDirBox.Text) = False) then
  begin
   DataDirBox.Text := OptRec.Dir_Cur;
   DataDirBox.Refresh;
   exit;
  end
 else
   begin
     OptRec.Dir_Cur := DataDirBox.Text;
     // 20150820 igor
     SetTableName(FDConnection, Table1,
               IncludeTrailingPathDelimiter(DataDirBox.Text) + ClientsDbLite, ClientsTableLite, 'Last_Name');
     DbGrid1.Refresh;
   end;
end;

procedure TCashRepT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
     DataDirBoxExit(Application);
end;

procedure TCashRepT1_2026.EnhancedInvoiceReportBtnClick(Sender: TObject); //20180402 Igor
var FBeginningDate, FEndingDate: TDateTime;

  function GetDateTimeValue(AValue: string): TDateTime;
  var FFormatSettings: TFormatSettings;
  begin
    Result := 0;
    try
      FFormatSettings := TFormatSettings.Create;
      FFormatSettings.DateSeparator := '-';
      FFormatSettings.TimeSeparator := ':';
      FFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
      FFormatSettings.ShortTimeFormat := 'hh:nn:ss';
      Result := StrToDateTime(AValue, FFormatSettings);
    except
    end;
    if Result = 0 then
      try
        Result := VarToDateTime(AValue);
      except
      end;
    if Result = 0 then
      Result := StrToDateTime(AValue);
  end;

begin
  try
    FBeginningDate := GetDateTimeValue(FromDt.Text);
  Except on EConvertError do
    begin
      ShowMessage('Error occured while converting FROM date. Check if date is correct');
      Exit;
    end;
  end;

  try
    FEndingDate := GetDateTimeValue(ToDt.Text);
  Except on EConvertError do
    begin
      ShowMessage('Error occured while converting TO date. Check if date is correct');
      Exit;
    end;
  end;

  BuildEnhancedInvoiceReport(FBeginningDate, FEndingDate, DataDirBox.Text);
end;

procedure TCashRepT1_2026.InvoiceReportBtnClick(Sender: TObject);//20150806 Igor

begin
  ReportInvoiceDate :=FromDt.Text;
  //20180501
  ReportInvoiceDateStart :=FromDt.Text;
  ReportInvoiceDateEnd :=ToDt.Text;
  InvoiceRep := TInvoiceRepT1_2026.Create(nil);
  try
    InvoiceRep.ReportOpen;
//    InvoiceRep.ShowModal; //for cheking
    If Not PrintDialog1.Execute then exit;
    InvoiceRep.RichEdit1.Print('Invoice');
    ShowMessage('Invoice Completed');
  finally
    InvoiceRep.Free; //20170208 Igor
  end;
end;

procedure BuildEnhancedInvoiceReport(ABeginningDate, AEndingDate: TDateTime; ADir_Cur: string); //20180402 Igor

type TInvoiceRec = record
  Num: string;
  TaxYear: string;
  EFiled: string;
  LastName: string;
  FirstName: string;
  Prov: string;
  CreatedBy: string;
  TotalCharges: string;
  FeeAmount: string;
  HSTAmount: string;
  InvoiceAmount: string;
  HSTRate: string;
  PaidBy: string;
  Deposit: string;
  Settlement: string;
  Other: string;
end;

var FApp: TApp;
    FConnection: TADConnection;
    FQuery: TADQuery;
    arrInvoice: array of TInvoiceRec;
    FRetNo: integer;

    Excel, Workbook, WorkSheet: Variant;
    I, nLine, nPrevLine: integer;
    cFile, cCurrCreatedBy, cStyle,
    cTotalCount, cTotalCharges, cTotalFeeAmount, cTotalHSTAmount,
    cTotalInvoiceAmount, cTotalDeposit, cTotalSettlement, cTotalOther: string;

    function InitExcel(var AExcel: Variant): boolean;
    var ClassID: TCLSID;
    begin
      Result := false;
      if CLSIDFromProgID(PWideChar(WideString('Excel.Application')), ClassID) <> S_OK then
      begin
        MessageDlg('Excel not instaled!', mtError, [mbOk], 0);
        exit;
      end;
      try
        AExcel := GetActiveOleObject('Excel.Application');
        Result := true;
      except
        try
          AExcel := CreateOleObject('Excel.Application');
          Result := true;
        except ON E: Exception DO
          begin
            MessageDlg(E.Message, mtError, [mbOk], 0);
            exit;
          end
        end;
      end;
    end;

    function GetExcelSaveFileName(AExcelVersion: string; var AFileName: string): boolean;
    var FExt: string;
    begin
      Result := false;
      if Pos('.', AExcelVersion) > 0 then
      AExcelVersion := Copy(AExcelVersion, 1, Pos('.', AExcelVersion) - 1);
      if not TryStrToInt(AExcelVersion, I) or (I < 12) then {excel 2007 = 12}
        FExt := '.xls'
      else
        FExt := '.xlsx';

      with TSaveDialog.Create(nil) do
      begin
        try
          if FApp.Dir_ClientDocs <> '' then
            InitialDir := FApp.Dir_ClientDocs
          else
            InitialDir := MyDocument;
          FileName := 'Invoice_Report_' + FormatDateTime('YYYYMMDD_hhnnss', now) + FExt;
          Filter := 'Excel Files|*' + FExt;
          if not Execute then
            Exit(False);
          AFileName := FileName;
          if not sametext(ExtractFileExt(AFileName), FExt) then
            AFileName := AFileName + FExt;
          Result := True;
        finally
          free;
        end;
      end;
    end;

    procedure SetCell(ARow, ACol: integer; AValue: Variant; AStyle: string = '');
    var A: TArray<string>;
        I, nSize: integer;
        Range: Variant;
    begin
      WorkSheet.Cells[ARow, ACol] := AValue;
      Range := WorkSheet.Cells[ARow, ACol];
      A := AStyle.Split([',']);
      for I := 0 to Length(A) - 1 do
      begin
        if SameText(A[I], 'bold') then
          Range.Font.Bold := true
        else if SameText(A[I], 'underline') then
          Range.Font.Underline := true
        else if SameText(A[I], 'center') then
          Range.HorizontalAlignment := -4108
        else if SameText(A[I], 'right') then
          Range.HorizontalAlignment := -4152
        else if SameText(A[I], 'vcenter') then
          Range.VerticalAlignment := -4108
        else if TryStrToInt(A[I], nSize) then
          Range.Font.Size := nSize
        else if SameText(A[I], 'wrap') then
          Range.WrapText := true
        else if SameText(A[I], 'border') then
        begin
          Range.Borders.Item[7].LineStyle := 1;
          Range.Borders.Item[8].LineStyle := 1;
          Range.Borders.Item[10].LineStyle := 1;
          Range.Borders.Item[9].LineStyle := 1;
          Range.Borders.Item[11].LineStyle := 1;
          Range.Borders.Item[12].LineStyle := 1;
        end
        else if SameText(A[I], 'nf_0.00') then
        begin
          if FormatSettings.ThousandSeparator = #160 then
            Range.NumberFormat := '# ##0' + FormatSettings.DecimalSeparator + '00'
          else
            Range.NumberFormat := '#' + FormatSettings.ThousandSeparator + '##0' + FormatSettings.DecimalSeparator + '00';
        end
        else if SameText(A[I], 'nf_0%') then
          Range.NumberFormat := '0%';
      end;
    end;

    procedure SetBorder(AStartRow, AStartCol, AEndRow, AEndCol: integer);
    var Range: Variant;
    begin
      Range := WorkSheet.Range[WorkSheet.Cells[AStartRow, AStartCol], WorkSheet.Cells[AEndRow, AEndCol]];
      //Range.Borders.Item[7].LineStyle := 1;
      Range.Borders.Item[8].LineStyle := 1;
      //Range.Borders.Item[10].LineStyle := 1;
      Range.Borders.Item[9].LineStyle := 1;
    end;

    procedure AddTotal(var ATotal: string; AValue: string);
    begin
      if SameText(ATotal, '') then
        ATotal := '='
      else
        ATotal := ATotal + '+';
      ATotal := ATotal + AValue;
    end;

    procedure AddSubTotal;
    begin
      SetCell(nLine, 1, 'Tax Preparer Total', 'bold');
      SetCell(nLine, 4, 'Returns:', 'bold,right');
      SetCell(nLine, 5, '=COUNT(H'+IntToStr(nPrevLine) + ':H'+ IntToStr(nLine - 1) + ')');
      SetCell(nLine, 7, cCurrCreatedBy);
      SetCell(nLine, 8, '=SUM(H'+IntToStr(nPrevLine) + ':H'+ IntToStr(nLine - 1) + ')', 'nf_0.00');
      SetCell(nLine, 9, '=SUM(I'+IntToStr(nPrevLine) + ':I'+ IntToStr(nLine - 1) + ')', 'nf_0.00');
      SetCell(nLine, 10, '=SUM(J'+IntToStr(nPrevLine) + ':J'+ IntToStr(nLine - 1) + ')', 'nf_0.00');
      SetCell(nLine, 11, '=SUM(K'+IntToStr(nPrevLine) + ':K'+ IntToStr(nLine - 1) + ')', 'nf_0.00');
      SetCell(nLine, 14, '=SUM(N'+IntToStr(nPrevLine) + ':N'+ IntToStr(nLine - 1) + ')', 'nf_0.00');
      SetCell(nLine, 15, '=SUM(O'+IntToStr(nPrevLine) + ':O'+ IntToStr(nLine - 1) + ')', 'nf_0.00');
      SetCell(nLine, 16, '=SUM(P'+IntToStr(nPrevLine) + ':P'+ IntToStr(nLine - 1) + ')', 'nf_0.00');
      AddTotal(cTotalCount, 'E' + IntToStr(nLine));
      AddTotal(cTotalCharges, 'H' + IntToStr(nLine));
      AddTotal(cTotalFeeAmount, 'I' + IntToStr(nLine));
      AddTotal(cTotalHSTAmount, 'J' + IntToStr(nLine));
      AddTotal(cTotalInvoiceAmount, 'K' + IntToStr(nLine));
      AddTotal(cTotalDeposit, 'N' + IntToStr(nLine));
      AddTotal(cTotalSettlement, 'O' + IntToStr(nLine));
      AddTotal(cTotalOther, 'P' + IntToStr(nLine));
      SetBorder(nLine, 1, nLine, 16);
      inc(nLine, 2);
      nPrevLine := nLine;
    end;

begin
  FApp := AppList.AppFromName('T1');
  if not Assigned(FApp) then Exit;

  // get data for report
  FConnection := TADConnection.Create(nil);
  FQuery := TADQuery.Create(nil);
  try
    FQuery.Connection := FConnection;
    SqlLoadDBFromFile(FConnection, FQuery, ADir_Cur +'\'+ ClientsDBLite, '');
    FQuery.Open(
      ' SELECT FILE_NAME, CREATED_BY, UPDATED_DT, LAST_NAME, FIRST_NAME, '+
      '   PROVINCE, PAY_TYPE '+
      ' FROM ' + ClientsTableLite +
      ' WHERE ' +
      '   UPDATED_DT >= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', ABeginningDate)) + ' AND ' +
      '   UPDATED_DT <= ' + QuotedStr(FormatDateTime('yyyy-mm-dd', AEndingDate)) + ' AND ' +
      '   INV_AMOUNT > 0 AND ' +
      '   EF_STATUS = '+ QuotedStr('02') +
      ' ORDER BY CREATED_BY, PAY_INVNO');
    FQuery.FetchAll;
    while not FQuery.Eof do
    begin
      try
        FRetNo := ReadReturn(ADir_Cur, TPath.GetFileName(FQuery.FieldByName('FILE_NAME').AsString), False, False); //20180412 Igor
      except on E: Exception do
        continue;
      end;
      if FRetNo <= 0 then
        continue;
      try
        //if (FetchElm(FRetNo, 'INVOICE', 209) <> '') then continue;
        SetLength(arrInvoice, Length(arrInvoice) + 1);
        with arrInvoice[Length(arrInvoice) - 1] do
        begin
          Num := FetchElm(FRetNo, 'INVOICE', 210);
          TaxYear := '2017';
          EFiled := FQuery.FieldByName('UPDATED_DT').AsString;
          LastName := FQuery.FieldByName('LAST_NAME').AsString;
          FirstName := FQuery.FieldByName('FIRST_NAME').AsString;
          Prov := FQuery.FieldByName('PROVINCE').AsString;
          if SameText(LastName, 'FIFTEEN') or SameText(LastName, 'FIFTYNINE') then
            CreatedBy := 'USER'
          else if SameText(LastName, 'EIGHTEEN') then
            CreatedBy := 'ANOTHER USER'
          else
            CreatedBy := FQuery.FieldByName('CREATED_BY').AsString;
          TotalCharges := FetchElm(FRetNo, 'INVOICE', 284);
          FeeAmount := '';
          HSTAmount := FetchElm(FRetNo, 'INVOICE', 221);
          InvoiceAmount := FetchElm(FRetNo, 'INVOICE', 219);
          HSTRate := FetchElm(FRetNo, 'INVOICE', 220);
          if HSTRate <> '' then
            HSTRate := FloatToStr(StrToFloat(HSTRate) / 100);
          PaidBy := FQuery.FieldByName('PAY_TYPE').AsString;
          Deposit := '';
          Settlement := '';
          Other := '';
        end;
      finally
        RetList[FRetNo].Close(true);
      end;

      FQuery.Next;
    end;
  finally
    FQuery.Close; FQuery.Free;
    FConnection.Close; FConnection.Free;
  end;

  if Length(arrInvoice) = 0 then
  begin
    ShowMessage('There are no invoices to print!');
    Exit;
  end;

  // export to Excel
  if not InitExcel(Excel) then Exit;
  try
    if not GetExcelSaveFileName(VarToStr(Excel.Application.Version), cFile) then Exit;
    Excel.Visible := False;
    Excel.Application.EnableEvents := false;
    Workbook := Excel.Workbooks.Add;
    WorkSheet := Workbook.WorkSheets[1];

    WorkSheet.Columns[1].ColumnWidth := 14;
    WorkSheet.Columns[2].ColumnWidth := 4.63;
    WorkSheet.Columns[3].ColumnWidth := 11.30;
    WorkSheet.Columns[4].ColumnWidth := 12.13;
    WorkSheet.Columns[5].ColumnWidth := 12.00;
    WorkSheet.Columns[6].ColumnWidth := 4.75;
    WorkSheet.Columns[7].ColumnWidth := 11.50;
    WorkSheet.Columns[8].ColumnWidth := 10.75;
    WorkSheet.Columns[9].ColumnWidth := 10.00;
    WorkSheet.Columns[10].ColumnWidth := 7.75;
    WorkSheet.Columns[11].ColumnWidth := 10.00;
    WorkSheet.Columns[12].ColumnWidth := 5.00;
    WorkSheet.Columns[13].ColumnWidth := 8.38;
    WorkSheet.Columns[14].ColumnWidth := 8.38;
    WorkSheet.Columns[15].ColumnWidth := 10.29;
    WorkSheet.Columns[16].ColumnWidth := 8.38;

    nLine := 1;
    SetCell(nLine, 1, 'INVOICE REPORT by eFile Date', 'bold,16');

    SetCell(nLine, 8, 'Efile Date From:', 'bold,12,right');
    SetCell(nLine, 9, FormatDateTime('yyyy-mm-dd', ABeginningDate), 'underline');
    SetCell(nLine, 10, 'To:', 'bold,12,right');
    SetCell(nLine, 11, FormatDateTime('yyyy-mm-dd', AEndingDate), 'underline');

    inc(nLine, 2);
    cStyle := 'bold,10,wrap,border,center,vcenter';
    SetCell(nLine, 1, 'Invoice #', cStyle);
    SetCell(nLine, 2, 'Tax Year', cStyle);
    SetCell(nLine, 3, 'EFiled', cStyle);
    SetCell(nLine, 4, 'Last Name', cStyle);
    SetCell(nLine, 5, 'First Name', cStyle);
    SetCell(nLine, 6, 'Prov', cStyle);
    SetCell(nLine, 7, 'Created By', cStyle);
    SetCell(nLine, 8, 'Total Form Charges', cStyle);
    SetCell(nLine, 9, 'Fee Amount', cStyle);
    SetCell(nLine, 10, 'HST Amount', cStyle);
    SetCell(nLine, 11, 'Invoice Amount', cStyle);
    SetCell(nLine, 12, 'HST Rate', cStyle);
    SetCell(nLine, 13, 'Paid By', cStyle);
    SetCell(nLine, 14, 'Deposit', cStyle);
    SetCell(nLine, 15, 'Settlement', cStyle);
    SetCell(nLine, 16, 'Other', cStyle);

    cCurrCreatedBy := arrInvoice[0].CreatedBy;
    cTotalCount := '';
    cTotalCharges := '';
    cTotalFeeAmount := '';
    cTotalHSTAmount := '';
    cTotalInvoiceAmount := '';
    cTotalDeposit := '';
    cTotalSettlement := '';
    cTotalOther := '';
    inc(nLine);
    nPrevLine := nLine;
    for I := 0 to Length(arrInvoice) - 1 do
    begin
      with arrInvoice[I] do
      begin
        if not SameText(cCurrCreatedBy, CreatedBy) then
        begin
          AddSubTotal;
          cCurrCreatedBy := CreatedBy;
        end;
        SetCell(nLine, 1, Num);
        SetCell(nLine, 2, TaxYear, 'center');
        SetCell(nLine, 3, EFiled, 'center');
        SetCell(nLine, 4, LastName);
        SetCell(nLine, 5, FirstName);
        SetCell(nLine, 6, Prov);
        SetCell(nLine, 7, CreatedBy);
        SetCell(nLine, 8, TotalCharges, 'nf_0.00');
        SetCell(nLine, 9, FeeAmount, 'nf_0.00');
        SetCell(nLine, 10, HSTAmount, 'nf_0.00');
        SetCell(nLine, 11, InvoiceAmount, 'nf_0.00');
        SetCell(nLine, 12, HSTRate, 'nf_0%');
        SetCell(nLine, 13, PaidBy);
        SetCell(nLine, 14, Deposit, 'nf_0.00');
        SetCell(nLine, 15, Settlement, 'nf_0.00');
        SetCell(nLine, 16, Other, 'nf_0.00');
      end;
      inc(nLine);
    end;
    AddSubTotal;
    inc(nLine);
    SetCell(nLine, 1, 'Report Total', 'bold');
    SetCell(nLine, 4, 'Returns:', 'bold,right');
    SetCell(nLine, 5, cTotalCount);
    SetCell(nLine, 8, cTotalCharges, 'nf_0.00');
    SetCell(nLine, 9, cTotalFeeAmount, 'nf_0.00');
    SetCell(nLine, 10, cTotalHSTAmount, 'nf_0.00');
    SetCell(nLine, 11, cTotalInvoiceAmount, 'nf_0.00');
    SetCell(nLine, 14, cTotalDeposit, 'nf_0.00');
    SetCell(nLine, 15, cTotalSettlement, 'nf_0.00');
    SetCell(nLine, 16, cTotalOther, 'nf_0.00');
    SetBorder(nLine, 1, nLine, 16);

    Workbook.SaveAs(cFile);
  finally
    Screen.Cursor := crDefault;
    if not VarIsEmpty(Excel) then
    begin
      Excel.Application.EnableEvents := true;
      Excel.DisplayAlerts := true;
      Excel.Visible := true;
      Workbook := Unassigned;
      WorkSheet := Unassigned;
      Excel := Unassigned;
    end;
  end;
end;

end.
