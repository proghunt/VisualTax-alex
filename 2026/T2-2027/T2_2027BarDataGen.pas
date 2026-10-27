Unit T2_2027BarDataGen;
// main routine PrepareRsiForm with logic
interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Printers,
  ExtCtrls, Math, ComObj, MsXml2_TLB, ShellApi,
  vtLabel, vtShape, Vcl.OleCtrls, SHDocVw,
  vtDynData, Vcl.DBCtrls, DelphiZXIngQRCode; // 20160401  //20221010 Igor

type
  TSplitBarDataArray = Array of Array oF String;
  TSourceTypeAddr = record    //20160422 Igor
    stStart,stLength: Integer;
  end;

type
  TBarDataGenT2_2027 = class(TForm)
    RsiFrmList: TListBox;
    PrintDialog1: TPrintDialog;
    HeaderBox: TPanel;
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    ShowBarCodeDataBtn: TBitBtn;
    Label1: TLabel;
    FileNameBox: TEdit;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    WebServiceEfileBtn: TBitBtn;
    // testingIndicator: TPanel; //20171225 igor
    URLForWebServices: TEdit;
    BitBtn5: TBitBtn;
    BitBtn4: TBitBtn;
    WebBrowser1: TWebBrowser;
    ProductionOrTestGroup: TRadioGroup;
    corFileClickLbl: TvtLabel;
    Label6: TLabel;

    procedure CheckSecurity(Sender: TObject);
    procedure PrepareData(Sender: TObject);
    Function GetSkipIndicator(RetNo: Integer; FName: String;
      LineNo: String): Boolean;
    Procedure PrepareAddressLoop(RetNo: Integer; FName: String; j: Integer;
      Valu: String; ScheduleId: String; ToElm: Integer; K: Integer;
      MaxLoopCounter: Integer; LineNo: String);
    Procedure PrepareAnElement(ScheduleId, FName, LineNo, Valu, Inst: String);
    Function GetNumberOfRsiWithData(RetNo: Integer): Integer;

    procedure PrintBarCodePages(BarDataArray: Array of String);
    procedure CreateBarCode(SplitBarDataArray: TSplitBarDataArray;
      Var BarCodeImageArray: Array of TImage);
    procedure PrintBarCode(Var BarCodeImageArray: Array of TImage);
    procedure addToPage(RetNo: Integer; PageCount: Integer; TotalPages: Integer;
      ACanvas: TCanvas);
    procedure PrintBCRcertifPage(RetNo: Integer; PageCount: Integer;
      TotalPages: Integer; ACanvas: TCanvas);

    Procedure PrepareAmendedNotes(RetNo: Integer);
    function IncMinute(const AValue: TDateTime; const ANumberOfMinutes: Int64)
      : TDateTime;

    Function SkipThisOne(RetNo: Integer; FName: String; ElmNo: Integer;
      Valu: String): Boolean;
    Function GetSpecialSchedulesString(RetNo: Integer): String;
    Function DateForRSIPage5(s: String): String;
    Function GetMaxColumns(s: String): Integer;
    Function ChangeColumnNo(ColumnNo: Integer; ScheduleId: String): Integer;
    Function ReformatPostal(s: String): String;
    Function ReformatBNForBarCode(bn: String): String;
    Function ReformatSIN(s: String): String;
    Procedure CreateRSI100;
    Procedure CreateRSI101;
    Procedure CreateRSI125(Inst: Integer);
    Function IsBsLineMandatory(Ln: String): Boolean;
    Function IsIsLineMandatory(Ln: String): Boolean;
    Procedure ShowImage;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrepareRsiForm(RetNo: Integer; RsiForm: String;
      RsiSpecs: TStringList; Inst: Integer; ASourceTypeAddr: TSourceTypeAddr); //20160422 Igor
    procedure ValidateBtnClick(Sender: TObject);
    Function ReformatPhoneNo(s: String): String;
    Function ReformatTrustNo(s: String): String;
    Function GetLineNo(LineCommand: String): String;
    Function GetLoopIndic(LineCommand: String; FName: String): Boolean;
    Function GetAddressIndic(LineCommand: String): Boolean;
    Function GetLargeFontIndic(LineCommand: String): Boolean;
    Function GetUnderLineIndic(DataType: String; Valu: String;
      LineNo: String): Boolean;
    procedure DrawBox(BoxRect: TRect; PenWidth: Integer; Shading: Boolean);
    procedure ShowBox(BoxRect: TRect; PenWidth: Integer; Shading: Boolean);
    Function ConvertYToPixels(Y: Real): Integer;
    Function ConvertXToPixels(X: Real): Integer;
    Function NextLineY(Y: Real): Real;
    Function GetSkipIndic(LineCommand: String): Boolean;
    Function FormatBarCodeAmount(Valu: String; NegativeIndic: Boolean): String;
    Function FormatStandardAmount(Valu: String; NegativeIndic: Boolean): String;
    procedure RsiFrmListClick(Sender: TObject);
    Function formatYesOrNoValu(Valu: String; FName: String;
      Elm: Integer): String;
    Function formatOneOrTwoValu(Valu: String): String;
    Function FormatOneOrTwoOrBlank(RetNo: Integer; FName: String;
      ElmNo: Integer; Valu: String): String;
    Function FormatOneOrBlank(Valu: String): String;
    Function FormatYesOrBlank(Valu: String; FName: String;
      Elm: Integer): String;
    Function FormatDateValu(Valu: String): String;
    Function GetMaxLoopCnt(LoopRefName: String): Integer;
    Function GetLoopRefName(s: String): String;
    Function GetActualText(s: String): String;
    Function PaddLUnderlined(Valu: String): String;
    Function GetNumbOfEmptyLines(s: String): Integer;
    Function FormatPercent(Valu: String): String;
    Function GetTextX(s: String): Real;
    Function CalcPages(ScheduleId: String): Integer;
    Function GetColumnX(s: String): Real;
    Function GetColumnY(s: String): Real;
    Procedure InitColumnPositions;
    Function LineNoNumeric(s: string): Boolean;
    Function RoundPages(NumbLines: Integer): Integer;
    Function GetNegativeIndic(DataType: String; Valu: String): Boolean;
    Function GetValueFromForm(RetNo: Integer; FName: String; Elm: Integer;
      Inst: Integer): String;
    Function GetValuWidth(Valu: String): Real;
    procedure RsiFrmListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    Function RsiHasData(RetNo: Integer; RsiNm: String): Boolean;
    procedure PrepareSingleRSI(RsiForm: String);
    Function IsItAGifiForm(RsiNm: String): Boolean;
    procedure PrintErrorList(ErrorList: TStringList);
    Function IsFormTheIsGIFI(RsiForm: String): Boolean;
    Procedure PrepareMoreGifiIs(RsiForm: string);
    Procedure CheckColumnsRSI125(MaxPerColumn: Integer; Var Cnt: Integer;
      TempSpecs: TStringList);
    Procedure CheckColumnsRSI100(MaxPerColumn: Integer; Var Cnt: Integer;
      TempSpecs: TStringList);
    Procedure CheckColumnsRSI101(MaxPerColumn: Integer; Var Cnt: Integer;
      TempSpecs: TStringList);
    procedure PrntBarCodedBtnClick(Sender: TObject);
    procedure ShowBarCodeDataBtnClick(Sender: TObject);

    Function ExcludeInvalidCharacters(s: string): string;

    Procedure GetGifiLinesList(FormName: String; ExplodedList: TStringList);
    // 20160401


    // procedure EFileClick(Sender: TObject);

    // ______________________________________________________________________________
    // WEBSERVICES BEGIN
    // ------------------------------------------------------------------------------

    procedure WebServiceEfileBtnClick(Sender: TObject);
    procedure WebServiceEfile();

    function CanEfileValidation: Boolean;

    procedure setwebServiceUserNamePassword(var webServiceUserName: string;
      var webServicePassword: string);

    procedure CreateSoapMessage(var SoapMsg: String; multiPartName: String);
    Function CreateSoapEnvelope(): string;
    Function CreateSoapContent(): string;
    Function combineSoapEnvelopeContent(SoapE: String; CorData: String;
      multiPartName: String): string;

    Procedure SubmitSoapMsg(SoapMsg: String; multiPartName: String);

    Procedure parseXmlResponse(rString: string);

    Function ReplacePredefinedXMLEntities(info: String): String;
    procedure corFileClickLblClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure ProductionOrTestGroupChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ProductionOrTestGroupClick(Sender: TObject);

    // ______________________________________________________________________________
    // WEBSERVICES END
    // ------------------------------------------------------------------------------

  private
    { Private declarations }
    FRetNo: Integer;
    property RetNo: Integer read FRetNo;
  public
    { Public declarations }
  end;

var
  // AcceptedSecurity:Boolean;
  sURL: string; // 20130530
  InvalidCharactersList: TStringList; // 20140706
  Efiling: Boolean;
  SkipIt: Boolean;
  BarDataArray: array of String;
  BarDataGen: TBarDataGenT2_2027;
  FieldDelim: String;
  RecordDelim: String;

  AddressIndic: Boolean;
  OutFileList: TStringList;
  InCol: Integer; { which column is being printed }
  PixPerInX, PixPerInY: Integer;
  VertIncr, LeftMargin, TopMargin, BottomY: Real;
  LoopRef: TStringList;
  PageCnt: Integer;
  X, Y: Real;
  PaddLChars: Integer;
  MaxWidth, charWidth, SpaceWidth: Real;
  NumbOfPages: Integer;
  ColumnNo: Integer;
  ColumnX: Array [1 .. 3] of Real;
  ColumnY: Array [1 .. 3] of Real;
  MaxColumns: Integer; { mx columns in page. To contimue unless hard break }
  Inst: Integer;
  ErrorList: TStringList;
  TempCanvas: TBitMap;
  PrintLastLoopIndicator: Boolean;
  NoLineIndic: Boolean;
  FontType: Integer;
  WList: TStringList;
  CountingPagesSw: Boolean;
  bardata: String; //20220526 Igor //bardata: AnsiString;

procedure DrawQRCode(AData: string; ACanvas: TCanvas; ARect: TRect); //20221010 Igor

implementation

uses vtMulti, vtCommon, vtMain, vtPrints, vtDialogs,
  T2_2027, T2_2027Multi, T2_2027main, T2_2027common,
  T2_2027Declare, T2_2027TrimStr,
  T2_2027ImageForm, T2_2027ChildWinNew, T2_2027pdf417,
  T2_2027print,
  T2_2027HtmlEol, T2_2027Common2,
  T2_2027Calc, T2_2027EFSECURE,
  vtTrimStr, vtShared; // 20160329 con

{$R *.DFM}

Function TBarDataGenT2_2027.GetUnderLineIndic(DataType: String; Valu: String;
  LineNo: String): Boolean;
begin
  If Valu > '' then
    result := False
  else
    result := True;
end;

Function TBarDataGenT2_2027.IsBsLineMandatory(Ln: String): Boolean;
begin
  result := False;
  If (Ln = '1000') or (Ln = '2600') or (Ln = '3500') or (Ln = '3660') then
    result := True;
end;

Function TBarDataGenT2_2027.IsIsLineMandatory(Ln: String): Boolean;
begin
  result := False;
  If (Ln = '8000') or (Ln = '8300') or (Ln = '8519') or (Ln = '9369')

    or (Ln = '9370') or (Ln = '9660') or (Ln = '9899') or (Ln = '9970') or
    (Ln = '9975') or (Ln = '9976')

    or (Ln = '9980') or (Ln = '9985') or (Ln = '9990') or (Ln = '9995') then
    result := True;
end;

procedure TBarDataGenT2_2027.FormCreate(Sender: TObject);
Var
  i: Integer;
  Templist, TempDirty: TStringList;
  s: String;
begin
  S88Cnt := 0;
  AcceptedSecurity := False;
  InvalidCharactersList := TStringList.Create; // 20140706

  ProductionOrTestGroup.itemindex:=0; //20171129   //????MUST BE CHANGED

  // t2 production
  UrlForWebServices.text:=sUrl;   //20171117
  UrlForWebServices.Update;      //20171117

  SysUtils.DeleteFile(AppDir + '\' + 'BarData.txt');
  FRetNo := GetCurrentRetNo;
  FileNameBox.Text := MkCorEFileName(RetNo);
  BarCodePrinted := False;
  FieldDelim := Chr(29);
  RecordDelim := Chr(13);
  ShowBarCodeDataBtn.Enabled := True; // False;  20090417
  OutFileList := TStringList.Create;
  CountingPagesSw := False;
  WList := TStringList.Create; { to break strings with commas }
  PrintLastLoopIndicator := True;
  ErrorList := TStringList.Create;
  LeftMargin := 0.3;
  TopMargin := 0.4;
  BottomY := 9.50;
  VertIncr := 1 / 8;
  PaddLChars := 25;
  MaxWidth := 1.50;
  charWidth := 1.25 / 15; { 15 chars in 1.25 inches }
  SpaceWidth := 0.75 / 14; { 15 in 0.75 inches }
  NumbOfPages := 1;
  ColumnNo := 1;
  Inst := 1; // 2008/11/11
  InitColumnPositions;


  Templist := TStringList.Create;
  Templist.LoadFromFile(AppDir + '\' + 'RSI.D');

  For i := 0 to Templist.Count - 1 do
    If UpperCase(LeftStr(Templist[i], 8)) = 'SCHEDULE' then
    Begin
      if (UpperCase(LeftStr(Templist[i], 11)) <> 'SCHEDULE S8') then //20180607 disallow the dummy S8 only for Autofill
       RsiFrmList.Items.Add(Templist[i]);
    End;
  Templist.Free;

  LoopRef := TStringList.Create;
  LoopRef.LoadFromFile(AppDir + '\' + 'LoopRef.D');

  PrepareData(Sender);
  RsiFrmList.ItemIndex := 0;
  RsiFrmList.ItemIndex := -1;

  ProductionOrTestGroupClick(Sender); //20171119
  URLForWebServices.Text := sURL; // 20130530
end;

procedure TBarDataGenT2_2027.FormPaint(Sender: TObject);
begin
 //20171117
 if ProductionOrTestGroup.itemindex=1 then     // t2 testing
 begin
   sURL := 'https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl';
   UrlForWebServices.Text:=sUrl;
   //TestingIndicator.visible:=True;  //20171225 igor
 end
 else //production
 begin
    ProductionOrTestGroup.itemindex:=0;
    sURL := 'https://apps.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl';
    UrlForWebServices.Text:=sUrl;
 end;
end;

Function TBarDataGenT2_2027.ExcludeInvalidCharacters(s: string): string;
begin
  s := StringReplace(s, '°', '', [rfReplaceAll, rfIgnoreCase]);                               s := StringReplace(s, '¢', '', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '-', '', [rfReplaceAll, rfIgnoreCase]);
  s := StringReplace(s, '¦', '', [rfReplaceAll, rfIgnoreCase]);

  result := s;
end;

Function TBarDataGenT2_2027.GetValueFromForm(RetNo: Integer; FName: String; Elm: Integer; Inst: Integer): String;
Var
  i, TempFNo: Integer;
  buttonSelected: Integer;
begin
  If (Elm = 0) or (Elm = 999) then
  begin
    result := '';
    exit;
  end;
  result := AllTrim(FetchElm(RetNo, FName, Elm));  //default for all data?

  If FName = 'T2' then
  begin
    if elm=338 then  //bfr Apr 7, 2022  //20221130
    Begin
     if FetchElm(RetNo,'T2',89)>=result then result:=FetchElm(RetNo,'T2',89);
    End;

    If Elm = 338 then  //code 415  2 of them  //20230606
    begin
       If Vl(FetchElm(RetNo, 'T2', 338))>0 then
         result := FetchElm(RetNo, 'T2', 338)
       else
         result := FetchElm(RetNo, 'T2', 122);  //FetchElm(RetNo, 'T2', 85); //20231019
    end;


    If Elm = 1 then
      result := ReformatBNForBarCode(result);

    //20221116
    if Elm=81 then //T183 completed
    begin
     if UpperCase(FetchElm(RetNo, FName, Elm))='Y' then
      result:='1'
     Else
      result:='';
    end;
    if Elm=82 then result:=ReplaceChar(FetchElm(RetNo, FName, Elm),'/',''); //T183 date
    if Elm=80 then result:=ReplaceChar(FetchElm(RetNo, FName, Elm),':',''); //T183 time

    If Elm = 51 then
      result := GetEfT2CorpType(RetNo);
    // for barcode only  send CA if blank country
    If (FetchElm(RetNo, 'T2', 8) > '') and (Elm = 19) then
    begin
      If result = '' then
        result := 'CA';
    end;
    If (FetchElm(RetNo, 'T2', 21) > '') and (Elm = 34) then
    begin
      If result = '' then
        result := 'CA';
    end;
    If (FetchElm(RetNo, 'T2', 67) > '') and (Elm = 46) then
    begin
      If result = '' then
        result := 'CA';
    end;
    If (FetchElm(RetNo, 'T2', 72) > '') and (Elm = 72) then
    begin
      result := LeftStr(FetchElm(RetNo, 'T2', 72), 2);
    end;

    // ---

    If (FetchElm(RetNo, 'T2', 19) = '') and (Elm = 20) then
      result := ReformatPostal(result);
    If (FetchElm(RetNo, 'T2', 34) = '') and (Elm = 35) then
      result := ReformatPostal(result);
    If (FetchElm(RetNo, 'T2', 46) = '') and (Elm = 47) then
      result := ReformatPostal(result);

    If UpperCase(FetchElm(RetNo, 'T2', 9)) = 'X' then // chg ho address = no
    begin
      If (Elm = 12) OR (Elm = 13) OR (Elm = 16) OR (Elm = 17) OR (Elm = 19) OR
        (Elm = 20) then
      begin
        result := '';
        exit;
      end;
    end;

    If Elm = 53 then
    begin
      If UpperCase(FetchElm(RetNo, 'T2', 53)) = 'X' then
        result := '1'
      else If UpperCase(FetchElm(RetNo, 'T2', 54)) = 'X' then
        result := '2'
      else If UpperCase(FetchElm(RetNo, 'T2', 55)) = 'X' then
        result := '3'
      else If UpperCase(FetchElm(RetNo, 'T2', 58)) = 'X' then
        result := '4';
    end;

    If UpperCase(FetchElm(RetNo, 'T2', 22)) = 'X' then // chg mailing address=no
    begin
      If (Elm = 23) OR (Elm = 26) OR (Elm = 27) OR (Elm = 32) OR (Elm = 33) OR
        (Elm = 34) OR (Elm = 35) then
      begin
        result := '';
        exit;
      end;
    end;

    If UpperCase(FetchElm(RetNo, 'T2', 68)) = 'X' then // chg loc books=no
    begin
      If (Elm = 38) OR (Elm = 41) OR (Elm = 44) OR (Elm = 45) OR (Elm = 46) OR
        (Elm = 47) then
      begin
        result := '';
        exit;
      end;
    end;


    //20160605  Email related
    If Elm = 6 then
    begin
     If (FetchElm(RetNo, 'T2', 6) + FetchElm(RetNo, 'T2', 5) = '') then   //20160601 Email related
        result := '2'             //20160630
     else
     begin
        If FetchElm(RetNo, 'T2', 6) > '' then
          result := '1'
        else
          result := '2';
     end;
     if (Efiling=False) or (IsAmendedReturn(RetNo)) then result:='';  //20191008

     if Efiling=True then   //20160605
      //20161214
      begin
      if UpperCase(FetchElm(RetNo, 'T2', 6))='Y' then //no Email
        Result:='1'
      Else
        Result:='2';
     end
     Else
       result:='';  //not allowed in paper returns
     if IsAmendedReturn(RetNo) then result:='';  //20160605
    end; //elm 6 088

    //20160605  Email related
    If Elm = 5 then  //email text
    begin
     //20161214
     if Efiling=True then   //20160605
       //ok
     Else
       result:='';  //not allowed in paper returns
     if IsAmendedReturn(RetNo) then result:='';  //20160605
    end; //elm 6 088


  end; { T2 page 1 }


  // T2 pg3 questionnaire
  If FName = 'T2' then
  begin
    If (Elm = 239) or (Elm = 240) or (Elm = 241) or (Elm = 242) or (Elm = 243)
      or (Elm = 245) or (Elm = 246) or (Elm = 247) then
    begin
      If result = 'N' then
        result := '';
    end;
  end;

  If FName = 'T2' then // T2 pg3
  begin
    If (Elm = 205) or (Elm = 208) or (Elm = 210) or (Elm = 212) then
      result := AllTrim(LeftStr(result, 60));
  end;

  // pg8
  If FName = 'T2' then { add area to Telephone }
  begin
    If Elm = 745 then
    begin
      If PageCnt = 5 then
        result := DateForRSIPage5(FetchElm(RetNo, 'T2', 745))
      else
        result := FetchElm(RetNo, 'T2', 745);
    end;

    If Elm = 746 then
    begin
      result := AllTrim(FetchElm(RetNo, FName, 755) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 746)));
    end;

    If Elm = 750 then
    begin
      result := AllTrim(FetchElm(RetNo, FName, 756) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 750)));
    end;

   If result = '()' then
     result := '';
  end; // t2 pg8

  If (LeftStr(FName, 6) = 'GIFIIS') and (Elm = 01) then
  begin
    result := '';
  end;

  If (FName = 'AMEND') and (Elm >= 11) and (Elm <= 71) then
  begin
    TempFNo := GetFormNo('AMEND');
    If AllTrim(FetchElmFNo(RetNo, TempFNo, Elm)) > '' then
    begin
      amendCnt := amendCnt + 1;
      result := LeftStr(FetchElmFNo(RetNo, TempFNo, Elm), 78) + FieldDelim +
        inttostr(amendCnt); // 20121128
    end;
  end;

  //20180105
  If FName = 'S10' then
  begin
    if GetTaxationYearEnd(RetNo) <'2017/01/01' then
    Begin
     if Elm=70 then result:='';
     if Elm=71 then result:='';
     if Elm=82 then result:='';
    End;
  end;


  //20160511   change global FNOTE1 to S141
  If FName = 'S141' then
  begin
    Case Elm of
      6: { practintioner }
        If FetchElm(RetNo, 'S141', 6) > '' then
          result := '1'
        else
          result := '2';
      32: { connection }
        begin
          If FetchElm(RetNo, 'S141', 32) > '' then
            result := '1'
          else
            result := '2';
        end;
      34: { involv }
        begin
          If FetchElm(RetNo, 'S141', 34) > '' then
            result := '1'
          else If FetchElm(RetNo, 'S141', 35) > '' then
            result := '2'
          else If FetchElm(RetNo, 'S141', 36) > '' then
            result := '3'
          else If FetchElm(RetNo, 'S141', 37) > '' then  //20220927
            result := '4';

        end;
      38: { reservation }
        begin
          If FetchElm(RetNo, 'S141', 38) > '' then
            result := '1'
          else If FetchElm(RetNo, 'S141', 39) > '' then
            result := '2';
        end;

      8:
        begin
          If FetchElm(RetNo, 'S141', 8) > '' then
            result := '1';
          If FetchElm(RetNo, 'S141', 5) > '' then
            result := '2';
        end;
    end; // case
  end; // fnote pg1

  If FName = 'S3' then
  begin
    Case Elm of
      6, 15, 24, 33, 42, 51, 60, 69, 78, 87:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If FName = 'S3' then
  begin
    Case Elm of
      211, 215, 219, 223, 227, 231, 235, 239, 243, 247:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If FName = 'S5' then // jurisdiction
  begin
    // check txbl income
    Case Elm of
      109, 252, 120, 131, 241, 142, 153, 164, 175, 186, 197, 208, 219,
        230, 281, 263:
        If vl(FetchElm(RetNo, FName, Elm - 4)) +
          vl(FetchElm(RetNo, FName, Elm - 2)) = 0 then
          result := ''
        else
          result := '1';
    end;
  end;

  //jz//202605//vt52 v1 - not sure what it was doing before but now with the new form is seems to not be correct
  {
  If FName = 'S8ALL' then
  begin
    i := 12;
    Repeat
      If (i = Elm) and (vl(result) = 0) then
        result := 'NA';
      Inc(i, 11);
    until i > 397;
  end;
  }

  If FName = 'S9' then
  begin
    Case Elm of
      6, 15, 24, 33, 42, 51, 60, 69, 78, 87, 96, 105, 114, 123, 132, 141, 150,
        159, 168, 177:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If FName = 'S14' then
  begin
    Case Elm of
      10, 22, 34, 46, 58, 70, 82, 94, 106, 118:
        If (FetchElm(RetNo, FName, Elm - 1) = '') and (result > '') then
          result := ReformatPostal(result);
    end;
  end;

  If FName = 'S15' then
  begin
    Case Elm of
      12, 22, 32, 42, 52, 62, 72, 82, 92, 102, 112, 122, 132, 142, 152:
      // 20140608
        If (FetchElm(RetNo, FName, Elm - 1) = '') and (result > '') then
          result := ReformatPostal(result);
    end;
  end;

  If FName = 'S22' then
  begin
    Case Elm of
      9, 16, 23, 30, 37, 44, 51, 58:
        If (FetchElm(RetNo, FName, Elm - 1) = '') and (result > '') then
          result := ReformatPostal(result);
    end;
  end;

  If FName = 'S6RE' then
  begin
    Case Elm of
      5, 16, 27, 38, 49, 60, 71, 82, 93, 104, 115, 126, 137, 148, 159, 170, 181,
        192, 203, 214, 225, 236, 247, 258, 269, 280, 291, 302:
        If (FetchElm(RetNo, FName, Elm - 1) = '') and (result > '') then
          result := ReformatPostal(result);
    end;
  end;

  If FName = 'S23' then
  begin
    Case Elm of
      6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 96, 102,
        108, 114, 120:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If FName = 'S24' then
  begin
    Case Elm of
      23, 25, 27, 29, 31, 33:
        result := ReformatBNForBarCode(result);
      35, 39, 43, 47, 51, 55, 59, 63:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If FName = 'S28' then
  begin
    Case Elm of
      50, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If FName = 'S29' then
  begin
    Case Elm of
      9, 17, 25, 33, 41, 49, 57, 65, 73, 81:
        begin
          If (FetchElm(RetNo, FName, Elm - 1) = '') and (result > '') then
            result := ReformatPostal(result);
        end;
      10, 18, 26, 34, 42, 50, 58, 66, 74, 82:
        result := FillLeftZeros(result, 2);
    end;
  end;

  If LeftStr(FName, 4) = 'S30#' then
  begin
    Case Elm of
      35: result := ReformatPostal(result);
      //20170810
      15:Result:=LeftStr(FetchElm(RetNo,FName,15)+' '+FetchElm(RetNo,FName,16)+' '+FetchElm(RetNo,FName,17),175);
      19:Result:=LeftStr(FetchElm(RetNo,FName,19)+' '+FetchElm(RetNo,FName,20)+' '+FetchElm(RetNo,FName,21),175);
      23:Result:=LeftStr(FetchElm(RetNo,FName,23)+' '+FetchElm(RetNo,FName,24)+' '+FetchElm(RetNo,FName,25)+FetchElm(RetNo,FName,26),225);
    end;

  end;


  If FName = 'S39' then
  begin
    Case Elm of
      5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77,
        81, 85, 89, 93:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If LeftStr(FName, 4) = 'S48#' then
  begin
    If Elm = 4 then // telephone
    begin
      result := AllTrim(FetchElm(RetNo, FName, 4) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 15)));
    end;
  end;

  If LeftStr(FName, 4) = 'S58#' then     //20200608
  begin
   If Elm=4 then
   Begin
    If UpperCase(FetchElm(RetNo, Fname, 4))='X' then result := '1' else result:='2';
   End;

   If Elm=6 then
   Begin
    If UpperCase(FetchElm(RetNo, Fname, 6))='X' then result := '1' else result:='2';
   End;

   If Elm=8 then
   Begin
     If UpperCase(FetchElm(RetNo, Fname, 8))+FetchElm(RetNo, Fname, 9)='' then  result :=''
    Else
     If UpperCase(FetchElm(RetNo, Fname, 8))='X' then result := '1' else result:='2';
   end;
  end;

  If LeftStr(FName, 5) = 'T1131' then
  begin
    If Elm = 4 then // telephone
    begin
      result := FetchElm(RetNo, FName, 4) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 6));
    end;
  end;

  If FName = 'S49' then
  begin
    Case Elm of
      6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 96, 102,
        108, 114, 120:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If FName = 'S50' then
  begin
    Case Elm of
      5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95,
        100, 105, 110, 115, 120, 125:
        result := ReformatBNForBarCode(result);

      6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91, 96,
        101, 106, 111, 116, 121, 126:
        result := ReformatSIN(result);

      132 .. 156:
        If Length(result) = 9 then
          result := ReformatTrustNo(result);
    end;
  end;

  If (FName = 'S75') then
  begin
   if Elm=174 then //phone
   Begin
    result:=ReformatPhoneNo(Result);
   End;
  end;
  // 20140423
  If (FName = 'S88') and (Elm >= 4) and (Elm <= 8) then
  begin
    TempFNo := GetFormNo('S88');
    If AllTrim(FetchElmFNo(RetNo, TempFNo, Elm)) > '' then
    begin
      Case Elm of
        4:
          S88Cnt := 1;
        5:
          S88Cnt := 2;
        6:
          S88Cnt := 3;
        7:
          S88Cnt := 4;
        8:
          S88Cnt := 5;
      end;
      // S88Cnt:=S88Cnt+1;  //20141011
      result := 'http://' + AllTrim(LeftStr(FetchElmFNo(RetNo, TempFNo, Elm),
        128)) + FieldDelim + inttostr(S88Cnt); // 20140423
      exit;
    end;
  end;


  If FName = 'S97' then
  begin
    Case Elm of
      05:
        Begin
          result := '';
          If FetchElm(RetNo, FName, 05) > '' then
            result := '1';
          If FetchElm(RetNo, FName, 06) > '' then
            result := '2';
        end;
    end; { Case }
  end;

  If FName = 'S91' then
  begin
    If (Elm = 19) then
    begin
      If (FetchElm(RetNo, 'S91', 19) + FetchElm(RetNo, 'S91', 20) = '') then
        result := ''
      else
      begin
        If FetchElm(RetNo, 'S91', 19) > '' then
          result := '1'
        else
          result := '2';
      end;
    end;
  end;

  If FName = 'S97' then
  begin
    If Elm = 7 then
    begin
      If (FetchElm(RetNo, 'S97', 7) > '') then
        result := '01'
      else if (FetchElm(RetNo, 'S97', 8) > '') then
        result := '02'
      else if (FetchElm(RetNo, 'S97', 9) > '') then
        result := '03'
      else if (FetchElm(RetNo, 'S97', 10) > '') then
        result := '04'
      else if (FetchElm(RetNo, 'S97', 11) > '') then
        result := '05'
      else if (FetchElm(RetNo, 'S97', 12) > '') then
        result := '06'
      else if (FetchElm(RetNo, 'S97', 13) > '') then
        result := '07'
      else if (FetchElm(RetNo, 'S97', 14) > '') then
        result := '08'
      else if (FetchElm(RetNo, 'S97', 15) > '') then
        result := '09';
    end;
  end;

  If FName = 'T661' then
  begin
    //20231204
    if Elm=125 then result:=Formatfloat('#########',Vl(FetchElm(RetNo,'T661',125))+Vl(FetchElm(RetNo,'T661',122))); //addd the separtely Alberta IAG
    if Elm=147 then result:=Formatfloat('#########',Vl(FetchElm(RetNo,'T661',147))+Vl(FetchElm(RetNo,'T661',123))); //addd the separtely Alberta IAG

    If Elm = 324 then
      result := ReformatBNForBarCode(result);
    If Elm = 329 then
      result := AllTrim(FetchElm(RetNo, FName, 329) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 310)));
    If Elm = 331 then
      result := AllTrim(FetchElm(RetNo, FName, 331) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 311)));
    If Elm = 334 then
      result := AllTrim(FetchElm(RetNo, FName, 334) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 312)));
    If Elm = 336 then
      result := AllTrim(FetchElm(RetNo, FName, 336) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 313)));
  end;

  If FName = 'T661SB' then
  begin
    Case Elm of
      5, 12, 19, 26, 33, 43, 50, 57, 64, 71:
        If result > '' then
          result := '1'
        else
        begin
          If FetchElm(RetNo, FName, Elm + 1) > '' then
            result := '2'
          else
            result := '';
        end;
    end; { case }
  end;

  If LeftStr(FName, 4) = 'S388' then
  begin
    If Elm = 5 then
    begin
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
    end;
  end;

  //20180509
  If LeftStr(FName, 4) = 'S389' then
  begin
    If (Elm = 15)
    or (Elm = 23)
    or (Elm = 31)
    or (Elm = 39)
    or (Elm = 47)
    then
    begin
      result := RemoveChar(FetchElm(RetNo, FName, Elm),'-');
    end;
  end;



  If LeftStr(FName, 5) = 'S422#' then
  begin
    If Elm = 5 then // phone no
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 8)));
  end;

  If LeftStr(FName, 5) = 'S423#' then
  begin
    If Elm = 7 then
    begin
      result := AllTrim(FetchElm(RetNo, FName, 492) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 7)));
    end;
  end;

  If FName = 'S429' then // 20110427
  begin
    If Elm = 5 then // phone no
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 7)));
  end;

  If FName = 'S423#1' then
  begin
    If Elm = 7 then
      result := ReplaceChar(result, '-', ' '); { tel }
  end;

  If LeftStr(FName, 4) = 'S506' then
  begin
    If Elm = 74 then
    begin
      If FetchElm(RetNo, FName, 74) > '' then
        result := '1';
      If FetchElm(RetNo, FName, 75) > '' then
        result := '2';
      If FetchElm(RetNo, FName, 76) > '' then
        result := '3';
      If FetchElm(RetNo, FName, 77) > '' then
        result := '4';
    end;
  end;

  If LeftStr(FName, 4) = 'S511' then
  begin
    Case Elm of
      5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69,
        73, 77, 81:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If LeftStr(FName, 4) = 'S512' then
  begin
    Case Elm of
      43:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If LeftStr(FName, 4) = 'S513' then
  begin
    Case Elm of
      5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 38, 41, 44, 47, 50, 53,
        56, 59, 62:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If LeftStr(FName, 4) = 'S516' then
  begin
    Case Elm of
      5, 11, 17, 23, 29, 35, 41, 47, 53, 59, 65, 71, 77, 83, 89, 95, 101,
        107, 113, 119:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If LeftStr(FName, 4) = 'S550' then
  begin
    If Elm = 5 then // telephone
    begin
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
    end;
  end;

  If LeftStr(FName, 4) = 'S552' then
  begin
    If Elm = 5 then // telephone
    begin
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
    end;
  end;

  If LeftStr(FName, 4) = 'S554' then
  begin
    If Elm = 5 then // telephone
    begin
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
    end;
    If Elm = 27 then
      result := ReformatBNForBarCode(result);
  end;

  If LeftStr(FName, 4) = 'S556' then
  begin
    Case Elm of
      42:
        result := ReformatBNForBarCode(result);
      5:
        result := AllTrim(FetchElm(RetNo, FName, 5) +
          ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
    end;
  end;

  If LeftStr(FName, 4) = 'S558' then
  begin
    Case Elm of
      5:
        result := AllTrim(FetchElm(RetNo, FName, 5) +
          ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
      31:
        result := ReformatBNForBarCode(result);
    end; // case
  end;

  If LeftStr(FName, 4) = 'S560' then
  begin
    If Elm = 5 then // telephone
    begin
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
    end;
  end;

  If LeftStr(FName, 4) = 'S562' then
  begin
    If Elm = 5 then // telephone
    begin
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
    end;
  end;

  If LeftStr(FName, 4) = 'S564' then
  begin
    If Elm = 5 then // telephone
    begin
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
    end;
  end;

  If LeftStr(FName, 4) = 'S566' then
  begin
    Case Elm of
      49, 52, 55, 58, 61, 64, 67, 70, 73, 76, 79, 82, 85, 88, 91, 94, 97,
        100, 103, 106:
        result := ReformatBNForBarCode(result);
      110, 113, 116, 119, 122, 125, 128, 131, 134, 137, 140, 143, 146, 149, 152,
        155, 158, 161, 164, 167:
        result := ReformatBNForBarCode(result);
    end; // case
  end;

  If LeftStr(FName, 4) = 'S568' then
  begin
    Case Elm of
      16, 19, 22, 25, 28, 31, 34, 37, 40, 43, 46, 49, 52, 55:
        result := ReformatBNForBarCode(result);
    end;
  end;

  If LeftStr(FName, 4) = 'S569' then
  begin
    If Elm = 5 then // telephone
    begin
      result := AllTrim(FetchElm(RetNo, FName, 5) +
        ReformatPhoneNo(FetchElm(RetNo, FName, 6)));
    end;
  end;

end;

procedure TBarDataGenT2_2027.ValidateBtnClick(Sender: TObject);
Var
  i, j, K: Integer;
  RsiForm: string[13];
  Templist, RsiSpec: TStringList;
begin
end;

procedure TBarDataGenT2_2027.CancelBtnClick(Sender: TObject);
Var
  FlName: String;
begin
  BarDataArray := nil;
  ErrorList.Free;

  OutFileList.Free;
  InvalidCharactersList.Free;
  LoopRef.Free;
  TempCanvas.Free;
  WList.Free;
  Close;  //20171119
end;

Procedure TBarDataGenT2_2027.ShowImage;
begin
  If CountingPagesSw = True then
  begin
    exit;
  end;

  Application.CreateForm(TImageFormT2_2027, ImageForm);
  ImageForm.ShowModal;
  ImageForm.Free;
end;

Function TBarDataGenT2_2027.IsFormTheIsGIFI(RsiForm: String): Boolean;
begin
  result := False;
  If LeftStr(RsiForm, 12) = 'Schedule 125' then
    result := True;
end;

procedure TBarDataGenT2_2027.PrepareSingleRSI(RsiForm: String);
//RSI form is in format Scheduke 007   instead of S7  and T2 is Schedule 200
Var
  i, j, Cnt: Integer;
  Templist, RsiSpec: TStringList;
  SourceTypeAddr: TSourceTypeAddr; //20160422 Igor
begin
  If IncludeGifiSchedules(RetNo, RsiForm) = False then exit;
  Templist := TStringList.Create;
  RsiSpec := TStringList.Create;
  SourceTypeAddr.stStart := -1;
  SourceTypeAddr.stLength := -1;
  If AllTrim(RsiForm) = 'Schedule 100' then
  begin
    CreateRSI100;  //this automatially prepars an external file with the specs like rhe SRI.d
    Templist.LoadFromFile(AppDir + '\' + 'RSI100.D');
  end

  Else If AllTrim(RsiForm) = 'Schedule 101' then
  begin
    CreateRSI101;
    TempList.LoadFromFile(AppDir+'\'+'RSI101.D');
  end

  Else If AllTrim(RsiForm) = 'Schedule 125' then
  begin
    CreateRSI125(Inst);
    TempList.LoadFromFile(AppDir+'\'+'RSI125.D');
  end

  else
  Begin
    Templist.LoadFromFile(AppDir + '\' + 'RSI.D');
    SourceTypeAddr.stStart := 28;
    SourceTypeAddr.stLength := 5;
  End;

  { Locate form specs }
  i := 0;
  j := -1;
  Repeat
    If AllTrim(LeftStr(Templist[i], 13)) = RsiForm then
    begin
      j := i;
      break;
    end;
    Inc(i);
  until (i > Templist.Count);

  If j = -1 then
  begin
    ShowMessage('RSI specifications not found');
    exit;
  end;

  { get the specs }
  i := j;
  RsiSpec.Add(Templist[i]);
  i := i + 1;
  Repeat
    RsiSpec.Add(Templist[i]);
    Inc(i);
  until (UpperCase(LeftStr(Templist[i], 6)) = 'RSIEND') or   //6 instad of 8  20170529
    (UpperCase(LeftStr(Templist[i], 8)) = 'SCHEDULE') or (i > Templist.Count);

  Templist.Free;
  If RsiSpec.Count = 0 then
  begin
    RsiSpec.Free;
    exit;
  end;

  Screen.Cursor := crHourGlass;
  // ShowMessage(RsiForm);
  PrepareRsiForm(RetNo, RsiForm, RsiSpec, Inst, SourceTypeAddr); //20160422 Igor
  RsiSpec.Free;
  Screen.Cursor := crDefault;
end;

Procedure TBarDataGenT2_2027.PrepareAnElement(ScheduleId, FName, LineNo, Valu,
  Inst: String);
Var
  XPos, YPos: Integer;
  Hdc: Thandle;
  NullString: Array [0 .. 150] of Char;
  s, FdelimAndInst: string;
  sl: TStringList;
  K, J: Integer;
begin
 // if Fname='S8ALL' then ShowMessage('S8All');

  If SkipIt = True then  exit;
  If (Valu > '') then
  begin
    if Inst = 'M' then
    Begin
      sl := TStringList.Create;
      try
        sl.text := Valu;
        K := 1;
        for J := 0 to sl.count - 1 do
        Begin
          s := sl[J];
          while S <> '' do
          begin
            PrepareAnElement(ScheduleId, FName, LineNo, copy(S,1,78), IntToStr(K));
            Delete(S,1,78);
            inc(K);
          end;
        end;
      finally
        sl.free;
      end;
    End
    else
    begin
      if Inst = '' then
      Begin
        FdelimAndInst := ''; //20221106
        if (FName='S8ALL') and (LineNo.Empty='200') then FdelimAndInst := FieldDelim + Inst; //20221106
      End
      else
        FdelimAndInst := FieldDelim + Inst;


      bardata := bardata + LineNo + Valu + FdelimAndInst + RecordDelim;

      // ShowMessage(FName);

      if Inst = '' then
        FdelimAndInst := ''
      else
        FdelimAndInst := '+' + Inst;

      OutFileList.Add(LineNo + Valu + FdelimAndInst + '*');
    end;
  end;

end;

Function TBarDataGenT2_2027.GetLineNo(LineCommand: String): String;
Var
  i: Integer;
begin
  result := '';
  If (UpperCase(LineCommand) = 'COLUMN 1') or
    (UpperCase(LineCommand) = 'COLUMN 2') or
    (UpperCase(LineCommand) = 'COLUMN 3') or
  { (UpperCase(LineCommand) = 'PAGES')    or }
    (UpperCase(LineCommand) = 'BOX') or (UpperCase(LineCommand) = 'HEADER') or
    (UpperCase(LineCommand) = 'TEXT') or (UpperCase(LineCommand) = 'FOOTER') or
    (UpperCase(LineCommand) = 'EMPTY') or (UpperCase(LineCommand) = 'BOLD') or
    (UpperCase(LineCommand) = 'UNDERL') or (UpperCase(LineCommand) = 'MAXCOLS')
    or (GetSkipIndic(LineCommand) = True) then
    exit;

  For i := 1 to Length(LineCommand) do // 20160225 Igor
    If LineNoNumeric(LineCommand[i]) then
      result := result + LineCommand[i];

  If Length(result) = 0 then
    result := ''
  else If Length(result) = 1 then
    result := '00' + result
  else if Length(result) = 2 then
    result := '0' + result;

  If Length(result) < 3 then
    result := '';
end;

Function TBarDataGenT2_2027.GetAddressIndic(LineCommand: String): Boolean;
Var
  i: Integer;
begin
  result := False;
  For i := 1 to Length(LineCommand) do // 20160225 Igor
    If LineCommand[i] = '@' then
    begin
      result := True;
      exit;
    end;
end;

Function TBarDataGenT2_2027.GetLoopIndic(LineCommand: String;
  FName: String): Boolean;
Var
  i: Integer;
begin
  result := False;
  For i := 1 to Length(LineCommand) do // 20160225 Igor
  begin
    // should not be a RecordDelim delim...is part of the specs
    If LineCommand[i] = '*' then
    begin
      result := True;
      exit;
    end;
  end;
end;

Function TBarDataGenT2_2027.GetTextX(s: String): Real;
Var
  i: Integer;
begin
  result := vl(AllTrim(MidStr(s, 14, 3)));
end;

Function TBarDataGenT2_2027.GetNumbOfEmptyLines(s: String): Integer;
Var
  i: Integer;
begin
  result := 0;
  result := MyStrToInt(AllTrim(MidStr(s, 14, 2)));
end;

Function TBarDataGenT2_2027.GetColumnX(s: String): Real;
Var
  i: Integer;
begin
  result := vl(AllTrim(MidStr(s, 14, 5)));
end;

Function TBarDataGenT2_2027.GetColumnY(s: String): Real;
Var
  i: Integer;
begin
  result := vl(AllTrim(MidStr(s, 22, 4)));
end;

Function TBarDataGenT2_2027.GetActualText(s: String): String;
begin
  result := MidStr(s, 20, 255);
end;

Function TBarDataGenT2_2027.GetSkipIndic(LineCommand: String): Boolean;
Var
  i: Integer;
begin
  result := False;
  For i := 1 to Length(LineCommand) do // 20160225 Igor
    If LineCommand[i] = '' then
    begin
      result := True;
      exit;
    end;
end;

Function TBarDataGenT2_2027.GetLargeFontIndic(LineCommand: String): Boolean;
Var
  i: Integer;
begin
  result := False;
  For i := 1 to Length(LineCommand) do // 20160225 Igor
    If LineCommand[i] = 'F' then
    begin
      result := True;
      exit;
    end;
end;

procedure TBarDataGenT2_2027.DrawBox(BoxRect: TRect; PenWidth: Integer;
  Shading: Boolean);
begin
  with Printer.Canvas do
  begin
    Pen.Width := PenWidth;
    Brush.Style := bsClear;
    If Shading then
      Brush.Color := RGB(239, 239, 239); { clBtnFace; }
    Polygon([Point(BoxRect.Left, BoxRect.Top), Point(BoxRect.Right,
      BoxRect.Top), Point(BoxRect.Right, BoxRect.Bottom), Point(BoxRect.Left,
      BoxRect.Bottom)]);
  end;
end;

procedure TBarDataGenT2_2027.ShowBox(BoxRect: TRect; PenWidth: Integer;
  Shading: Boolean);
begin
  with TempCanvas.Canvas do
  begin
    Pen.Width := PenWidth;
    Brush.Style := bsClear;
    If Shading then
      Brush.Color := RGB(239, 239, 239); { clBtnFace; }

    { Brush.Color := RGB(239,239,239); }
    Polygon([Point(BoxRect.Left, BoxRect.Top), Point(BoxRect.Right,
      BoxRect.Top), Point(BoxRect.Right, BoxRect.Bottom), Point(BoxRect.Left,
      BoxRect.Bottom)]);

  end;
end;

Function TBarDataGenT2_2027.NextLineY(Y: Real): Real;
begin
  result := Y + 2 * VertIncr;
end;

Function TBarDataGenT2_2027.ConvertXToPixels(X: Real): Integer;
Begin
  result := Trunc(X * PixPerInX);
end;

Function TBarDataGenT2_2027.ConvertYToPixels(Y: Real): Integer;
Begin
  result := Trunc(Y * PixPerInY);
end;

Function TBarDataGenT2_2027.GetMaxLoopCnt(LoopRefName: String): Integer;
Var
  i, j, Cnt, FromElm, ToElm, ByIncr: Integer;
  FName: String;
  LoopRefLine: TArray<string>; //20251118 Igor
begin
  { check first column of table, if empty stop }
  result := -1;
  Cnt := 0;
  If LoopRefName = '' then
    exit;
  For i := 0 to LoopRef.Count - 1 do
  begin
    If LoopRefName = AllTrim(UpperCase(LeftStr(LoopRef[i], 10))) then
    begin
      FName := UpperCase(AllTrim(MidStr(LoopRef[i], 11, 10)));
      If Inst > 1 then
        FName := ExtractNonInstFormName(FName) + '#' + AllTrim(inttostr(Inst));
      // 2008/10/21 i.e dealing with S60#2
      If GetFormNo(FName) = 0 then
        exit;
      //20251118 Igor >>>
      if LoopRefName.Equals('S74L100') or LoopRefName.Equals('S74L300') or LoopRefName.Equals('S74L400') then
      begin
        LoopRefLine:= LoopRef[i].Split([' ']);
        FromElm:= MyStrToInt(AllTrim(LoopRefLine[8]));
        ToElm:= MyStrToInt(AllTrim(LoopRefLine[9]));
        ByIncr:= MyStrToInt(AllTrim(LoopRefLine[10]));
      end else
      begin
        FromElm:= MyStrToInt(AllTrim(MidStr(LoopRef[i], 21, 4)));
        ToElm:= MyStrToInt(AllTrim(MidStr(LoopRef[i], 25, 4)));
        ByIncr:= MyStrToInt(AllTrim(MidStr(LoopRef[i], 29, 3)));
      end;
      //20251118 Igor <<<

      j := FromElm;
      Repeat
        If GetValueFromForm(RetNo, FName, j, Inst) > '' then
          Inc(Cnt);
        Inc(j, ByIncr);
      until j > ToElm;
      break;
    end;
  end; { loop i }
  If Cnt = 0 then Cnt := 1;
  result := Cnt;

end;

Function TBarDataGenT2_2027.FormatBarCodeAmount(Valu: String;
  NegativeIndic: Boolean): String;
begin
  Valu := FormatRSIDollarAmount('', Valu, 0); { no decimals }
  Valu := ReplaceChar(Valu, ',', ''); { replace commas with nil }
  result := Valu;
end;

Function TBarDataGenT2_2027.FormatStandardAmount(Valu: String;
  NegativeIndic: Boolean): String;
begin
  result := FormatRSIDollarAmount('', Valu, 0);
end;

procedure TBarDataGenT2_2027.RsiFrmListClick(Sender: TObject);
Var
  i, j: Integer;
  RsiForm: string[13];
  Templist, RsiSpec: TStringList;
begin
  If RsiFrmList.ItemIndex < 0 then
    exit;
  Templist := TStringList.Create;
  RsiSpec := TStringList.Create;
  RsiForm := AllTrim(LeftStr(RsiFrmList.Items[RsiFrmList.ItemIndex], 13));
  Templist.LoadFromFile(AppDir + '\' + 'RSI.D');
  { Locate form specs }
  i := 0;
  j := -1;
  Repeat
    If AllTrim(LeftStr(Templist[i], 13)) = RsiForm then
    begin
      j := i;
      break;
    end;
    Inc(i);
  until (i > Templist.Count);

  If j = -1 then
  begin
    ShowMessage('RSI specifications not found');
    exit;
  end;

  { get the specs }
  i := j;
  RsiSpec.Add(Templist[i]);
  i := i + 1;
  Repeat
    RsiSpec.Add(Templist[i]);
    Inc(i);
  until (UpperCase(LeftStr(Templist[i], 6)) = 'RSIEND') or   //6 insted of 8  //20170529
    (UpperCase(LeftStr(Templist[i], 8)) = 'SCHEDULE') or
    (i > Templist.Count - 1);

  Templist.Free;
  RsiSpec.Free;
end;

Function TBarDataGenT2_2027.FormatYesOrBlank(Valu: String; FName: String;
  Elm: Integer): String;
begin
  If UpperCase(Valu) = 'Y' then
    result := '1'
  else
    result := '';
end;

Function TBarDataGenT2_2027.formatYesOrNoValu(Valu: String; FName: String;
  Elm: Integer): String;
begin
  If (UpperCase(Valu) = 'X') or (UpperCase(Valu) = 'Y') then
    result := '1'
  else
    result := '2';

  (* replaced by 1/b
    If (Fname = 'PAGE_2') and (Result = '2') then result :='';
    If (Fname = 'PAGE_3') and (Result = '2') then
    begin
    If (Elm>=39) and (Elm<=47) then result :='';
    end;
    If (Fname = 'PAGE_1') and (Elm = 6) and (Result='2') then result :='';
  *)
  If (FName = 'FNOTE_1') and (Elm = 28) and
    (UpperCase(FetchElm(RetNo, 'FNOTE_1', 27)) = 'X') then
    result := '';

end;

Function TBarDataGenT2_2027.formatOneOrTwoValu(Valu: String): String;
begin
  If UpperCase(Valu) = 'X' then
    result := '1'
  else
    result := '2';
end;

Function TBarDataGenT2_2027.FormatOneOrBlank(Valu: String): String;
begin
  If UpperCase(Valu) = 'X' then
    result := '1'
  else
    result := '';
end;

Function TBarDataGenT2_2027.FormatOneOrTwoOrBlank(RetNo: Integer; FName: String;
  ElmNo: Integer; Valu: String): String;
begin
  If UpperCase(Valu) = 'X' then
    result := '1'
  else
  begin
    If AllTrim(FetchElm(RetNo, FName, ElmNo + 1)) = '' then
      result := ''
    else
      result := '2';
  end;
end;

//jz//202605//vt52 v1
Function TBarDataGenT2_2027.FormatDateValu(Valu: String): String;
begin
  Valu := ReplaceChar(Valu, '/', '');
  Valu := ReplaceChar(Valu, '-', '');
  Valu := ReplaceChar(Valu, '.', '');  //jz//20250527

  result := Valu;
end;

Function TBarDataGenT2_2027.FormatPercent(Valu: String): String;
Var
  X: Real;
begin
  If Valu = 'NA' then
    exit;
  Valu := AllTrim(Valu);
  X := vl(Valu);
  result := FormatFloat('#0.###', X);
  If (result = '0') or (result = '0.00') or (result = '.00') then
    result := '';
end;

Function TBarDataGenT2_2027.GetLoopRefName(s: String): String;
begin
  // 20160331
  result := AllTrim(MidStr(s, 37, 9));
  // result := AllTrim(MidStr(S,34,9));
end;

Function TBarDataGenT2_2027.PaddLUnderlined(Valu: String): String;
Var
  i, NumbSpaces, NumbChars: Integer;
  MaxLength: Integer;
  ValuWidth, PaddRWidth: Real;
  PaddRChars: Integer;
  PaddLWidth: Real;
  PaddLChars: Integer;
  CWidth, SWidth: Real;
begin
  result := Valu;
  If FontType = 1 then
  begin
    CWidth := charWidth;
    SWidth := SpaceWidth;
  end
  else
  begin
    CWidth := charWidth * 1.50;
    SWidth := SpaceWidth * 1.50;
  end;
  ValuWidth := Length(Valu) * CWidth;
  PaddRWidth := MaxR(0, MaxWidth - ValuWidth);
  PaddRChars := Trunc(PaddRWidth / SWidth);
  If ValuWidth > 0 then
    result := Valu + Space(PaddRChars) { -1 }
  else
    result := Valu + Space(PaddRChars);
end;

Function TBarDataGenT2_2027.GetValuWidth(Valu: String): Real;
Var
  i, NumbSpaces, NumbChars: Integer;
  MaxLength: Integer;
  ValuWidth, PaddLWidth: Real;
  PaddLChars: Integer;
begin
  NumbChars := Length(AllTrim(Valu));
  NumbSpaces := CountSpacesInString(Valu);
  // =0;{Length(PaddLUnderlined(Valu))-NumbChars;}
  result := NumbChars * charWidth + NumbSpaces * SpaceWidth;
end;

Function TBarDataGenT2_2027.LineNoNumeric(s: string): Boolean;
Var
  i: Integer;
begin
  If s = '' then
  begin
    result := False;
    exit;
  end;
  For i := 1 to Length(s) do
    If s[i] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then
      result := True
    else
    begin
      result := False;
      exit;
    end;
end;

Procedure TBarDataGenT2_2027.InitColumnPositions;
begin
  ColumnX[1] := LeftMargin;
  ColumnX[2] := 3.00;
  ColumnX[3] := 5.50;

  ColumnY[1] := 1.30;
  ColumnY[2] := 1.30;
  ColumnY[3] := 1.30;
end;

Function TBarDataGenT2_2027.CalcPages(ScheduleId: String): Integer;
Var
  i: Integer;
  NumbLines: Integer;
begin
  // minimum default, revised via countingpages
  NumbLines := 0;
  result := 1;
  If ScheduleId = '200' then
  begin
    result := 5;
    exit;
  end;
  If ScheduleId = '125' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '100' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '101' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '140' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '141' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '001' then
  begin
    result := 2;
    exit;
  end;
  If ScheduleId = '002' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '003' then
  begin
    result := 2;
    exit;
  end;
  If ScheduleId = '004' then
  begin
    result := 3;
    exit;
  end;
  If ScheduleId = '005' then
  begin
    result := 2;
    exit;
  end;
  If ScheduleId = '006' then
  begin
    result := 3;
    exit;
  end;
  If ScheduleId = '007' then
  begin
    result := 2;
    exit;
  end;

  If ScheduleId = '008' then
  begin
    NumbLines := GetMaxLoopCnt('S8L200') * 11 Div 2;
    { 2 columns, 11 per column }
    result := RoundPages(NumbLines);
    exit;
  end;

  If ScheduleId = '009' then
  begin
    NumbLines := GetMaxLoopCnt('S9L100') * 9 + 5;
    result := RoundPages(NumbLines);
    exit;
  end;

  If ScheduleId = '010' then
  begin
    result := 1;
    exit;
  end;

  If ScheduleId = '011' then
  begin
    NumbLines := GetMaxLoopCnt('S11L100') * 6 div 2;
    result := RoundPages(NumbLines);
    exit;
  end;

  If ScheduleId = '012' then
  begin
    result := 3;
    If GetMaxLoopCnt('S12L601') > 1 then
      result := result + 1;
    // If GetMaxLoopCnt('S12L701') >1 then result :=Result+1;
    exit;
  end;

  If ScheduleId = '013' then
  begin
    result := 2;
    If GetMaxLoopCnt('S13L001') > 5 then
      result := 3;
    exit;
  end;
  If ScheduleId = '014' then
  begin
    NumbLines := GetMaxLoopCnt('S14L100') * 7; // ??
    result := RoundPages(NumbLines);
    exit;
  end;

  If ScheduleId = '015' then
  begin
    NumbLines := GetMaxLoopCnt('S15L100') * 6;
    result := RoundPages(NumbLines);
    exit;
  end;

  If ScheduleId = '018' then
  begin
    result := 1;
    exit;
  end;

  If ScheduleId = '019' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '020' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '021' then
  begin
    result := 1;
    exit;
  end;

  If ScheduleId = '023' then
  begin
    NumbLines := GetMaxLoopCnt('S23L100') * 5;
    result := RoundPages(NumbLines);
    exit;
  end;

  If ScheduleId = '024' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '027' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '031' then
  begin
    result := 4;
    exit;
  end;
  If ScheduleId = '032' then
  begin
    result := 5;
    exit;
  end; { T661 }
  If ScheduleId = '033' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '036' then
  begin
    result := 1;
    exit;
  end;
  If ScheduleId = '043' then
  begin
    result := 2;
    exit;
  end;
  If ScheduleId = '049' then
  begin
    result := 1;
    exit;
  end;

  If ScheduleId = '050' then
  begin
    NumbLines := GetMaxLoopCnt('S50L100') * 5;
    result := RoundPages(NumbLines);
    exit;
  end;

  If ScheduleId = '080' then
  begin
    result := 2;
    exit;
  end;
  If ScheduleId = '081' then
  begin
    result := 2;
    exit;
  end;
  If ScheduleId = '091' then
  begin
    result := 3;
    exit;
  end;
  If ScheduleId = '342' then
  begin
    result := 1;
    exit;
  end;
  (*
    If ScheduleId = '361' then begin result := 1;exit; end;
    If ScheduleId = '362' then
    begin
    NumbLines := GetMaxLoopCnt('S362L200')* 4;
    Result := RoundPages(NumbLines);
    exit;
    end;
  *)
  If ScheduleId = '423' then
  begin
    result := 2;
    exit;
  end;
  If ScheduleId = '441' then
  begin
    result := 2;
    exit;
  end;
  If ScheduleId = '421' then
  begin
    result := 1;
    NumbLines := GetMaxLoopCnt('S421L070') + GetMaxLoopCnt('S421L135');
    If NumbLines > 4 then
      result := 2;
    exit;
  end;

end;

Function TBarDataGenT2_2027.RoundPages(NumbLines: Integer): Integer;
begin
  result := Trunc(NumbLines / 30) + 1;
end;

Function TBarDataGenT2_2027.GetNegativeIndic(DataType: String;
  Valu: String): Boolean;
begin
  result := False;
  If (LeftStr(DataType, 1) = '$') and (vl(AllTrim(Valu)) < 0) then
    result := True;
end;

procedure TBarDataGenT2_2027.PrintErrorList(ErrorList: TStringList);
Var
  FileNm: String;
  Hdr1, Hdr2, Hdr3: String[80];
begin
  FileNm := AppDir + '\' + 'Temp';
  ErrorList.SaveToFile(FileNm);
  Hdr1 := 'RSI SPECS - ERROR LIST';
  Hdr2 := FilledStr(80, '=');
  Hdr3 := FilledStr(80, '=');

  If PrintDialog1.Execute then
  begin
    If PrintAListing(FileNm, Hdr1, Hdr2, Hdr3) = True then
      ShowMessage('Printing Completed');
  end;
end;

Function TBarDataGenT2_2027.ChangeColumnNo(ColumnNo: Integer;
  ScheduleId: String): Integer;
begin
  If ColumnNo < MaxColumns then
  begin
    ColumnNo := ColumnNo + 1;
    ColumnX[ColumnNo] := ColumnX[ColumnNo];
    ColumnY[ColumnNo] := ColumnY[ColumnNo];
    If (ColumnNo = 2) and (MaxColumns = 2) then
      ColumnX[ColumnNo] := ColumnX[ColumnNo] + 1;

    X := ColumnX[ColumnNo];
    Y := ColumnY[ColumnNo] + 2 * VertIncr;
  end;
  result := ColumnNo;
end;

procedure TBarDataGenT2_2027.PrepareRsiForm(RetNo: Integer; RsiForm: String;
  RsiSpecs: TStringList; Inst: Integer; ASourceTypeAddr: TSourceTypeAddr); //20160422 Igor
Var
  i, ii, j, K, Ndx, FNo, ElmNo, FromElm, ToElm, ByIncr, FontSize,
    NumbOfEmptyLines: Integer;
  LineCommand, s, ss: String;
  FName: String[10];
  ElmString: String[6];
  DataType: String[4];
  LineNo: String[5];
  DataLengthString: String[5];
  LineValu, Valu: String;
  BoldIndic, UnderlineIndic, NegativeIndic: Boolean;
  LoopIndic, LargeFontIndic: Boolean;
  ScheduleId: String[10];
  BoxRect: TRect;
  LeftOfBox, TopOfBox, RightOfBox, BottomOfBox: Real;
  BoxShading: Boolean;
  LoopRefName: String[12];
  MaxLoopCounter: Integer;
  SourceType: String;
  function AllowedSourceType(ASourceType: String) : Boolean; //20160422 Igor
  Begin
    result := (ASourceType = 'M');
  End;
begin
  //If RsiForm='Schedule 073' then Showmessage('RSIFORM=Schedule073');
  if (IsLifeInsuranceCorp(RetNo)) and (RsiForm='Schedule 001') then Exit;  //20161206
  SkipIt := False;
  PrintLastLoopIndicator := True;
  AddressIndic := False;
  If RsiSpecs.Count <= 0 then
    exit;
  s := RsiSpecs[0];
  ScheduleId := AllTrim(MidStr(s, 10, 4));
  { BODY OF RSI FORM }
  If RsiSpecs.Count < 2 then
    exit;
  bardata := bardata + ScheduleId + FieldDelim + AllTrim(inttostr(Inst)) +
    RecordDelim;
  OutFileList.Add(ScheduleId + '+' + AllTrim(inttostr(Inst)) + '*');
  i := 1;
  Repeat
    s := RsiSpecs[i];

    { ShowMessage(S); }
    LineCommand := AllTrim(MidStr(s, 1, 10));
    FName := AllTrim(MidStr(s, 13, 8)); // 20160331
    // FName        := AllTrim(MidStr(S,14,8));

   // if LeftStr(Fname,4)='S422'  then ShowMessage(FName);  //20170601

    FName := AttachInstToFNameForRsi(FName, Inst);
    ElmString := AllTrim(MidStr(s, 22, 5)); // 20160402 Alltrim(MidStr(s,22,4));
    ElmNo := MyStrToInt(AllTrim(ElmString));

    DataType := AllTrim(MidStr(s, 61, 5)); //20160511 //AllTrim(MidStr(s, 62, 5)); //20160402 AllTrim(MidStr(s, 63, 5));

    // 20160402    AllTrim(MidStr(S,59,5));
    LineNo := GetLineNo(LineCommand);
    LoopIndic := GetLoopIndic(LineCommand, FName);
    AddressIndic := GetAddressIndic(LineCommand);
    LoopRefName := GetLoopRefName(s);
    //20160422 Igor >>>
    if LineNoNumeric(AllTrim(MidStr(s,28,5))) then
      ToElm := MyStrToInt(AllTrim(MidStr(s,28,5))) // 20121003
    else
      ToElm := 0;
    if ASourceTypeAddr.stStart > 0 then
    Begin
      SourceType := AllTrim(MidStr(s, ASourceTypeAddr.stStart, ASourceTypeAddr.stLength));
      if not AllowedSourceType(SourceType) then
        SourceType := '';
    End
    else
      SourceType := '';
    //20160422 Igor <<<

    { validate }
    If (LoopIndic = True) and (GetMaxLoopCnt(LoopRefName) = -1) then
    begin
      ShowMessage('Loop incorrect in: ' + s);
      exit;
    end;

    If (UpperCase(LineCommand) = 'COLUMN 1') or
      (UpperCase(LineCommand) = 'COLUMN 2') or
      (UpperCase(LineCommand) = 'COLUMN 3') or (UpperCase(LineCommand) = 'BOX')
      or (UpperCase(LineCommand) = 'HEADER') or
      (UpperCase(LineCommand) = 'TEXT') or (UpperCase(LineCommand) = 'FOOTER')
      or (UpperCase(LineCommand) = 'EMPTY') or (UpperCase(LineCommand) = 'BOLD')
      or (UpperCase(LineCommand) = 'UNDERL') or
      (UpperCase(LineCommand) = 'MAXCOLS') or (GetSkipIndic(LineCommand) = True)
    then
      // do nothing

    else If LoopIndic then { Loop }
    begin
      SkipIt := GetSkipIndicator(RetNo, FName, LineNo);
      // 20160331
      FromElm := MyStrToInt(AllTrim(MidStr(s, 22, 5))); // 20121003
      ByIncr := MyStrToInt(AllTrim(MidStr(s, 34, 3)));
      LoopRefName := AllTrim(MidStr(s, 37, 8));

      (*
      //20211025
      if LoopRefName='S1L605' then
      Begin
       if Vl(FetchElm(RetNo,'S1',152))=0 then  FromElm:=138  Else FromElm:=136;  //if 0 it skips the rest
      End;
      *)

      MaxLoopCounter := GetMaxLoopCnt(LoopRefName);
      if FName='73' then MaxLoopCounter:=20;  //20230113 ????
      j := FromElm;
      K := 1; // row


     // if (LoopRefName='S1L605') and  (Vl(FetchElm(RetNo,'S1',152))=0) then k:=2; //20211025
      Repeat


        FNo := GetFormNo(FName);
        If (FNo = 0) or (FromElm = 0) or (ToElm = 0) or (ByIncr = 0) then
          Valu := ''
        else if SourceType = 'M' then   //20160421 Igor
          Valu := FetchMemoData(RetNo, FNo, j) //20160421 Igor
        else
          Valu := GetValueFromForm(RetNo, FName, j, Inst);



        //JZ 06262023
        //moved from below and added the 'else if' to to change data type back to $ as it was when not blank
        //it doesnt make sense or work to have it below where it was as changes the datatype for the next value causing error since the datatype is not reset datatype for the next line in the loop
        //same with the others as well but won't change them for now, but is unreliable code possibly causing errors
        If (FName = 'S353') then  //20221107
        begin
          // 20220616
           If (LineNo = '400') and (Valu = '') then
           begin
                 DataType := 'A/N';
                 Valu := '0';
           end
           else if LineNo = '400' then
                    DataType := '$';
        end;


        If DataType = 'Y/N' then
          Valu := formatYesOrNoValu(Valu, FName, ElmNo);
        If DataType = 'Y/b' then
          Valu := FormatYesOrBlank(Valu, FName, ElmNo);
        If DataType = '1/2' then
          Valu := formatOneOrTwoValu(Valu);
        If DataType = '1/b' then
          Valu := FormatOneOrBlank(Valu);
        If DataType = '1/' then
          Valu := FormatOneOrTwoOrBlank(RetNo, FName, ElmNo, Valu);
        NegativeIndic := GetNegativeIndic(DataType, Valu);
        If DataType = '$' then
          Valu := FormatBarCodeAmount(Valu, NegativeIndic)
        else if DataType = '$$' then
          Valu := JustRight(FormatStandardAmount(Valu, NegativeIndic), 13);
        If DataType = '%' then
          Valu := FormatPercent(Valu);
        If (FName = 'T2') and (ElmNo = 65) then
          UnderlineIndic := False;
        If (FName = 'FNOTE2') and (ElmNo >= 1) then
          UnderlineIndic := False;
        If (DataType = 'D/T') or (DataType = 'D') then
          Valu := FormatDateValu(Valu);


        if (Fname='S1') and (LineNo='295') // and (Valu>'')
        and (UpperCase(LeftStr(FetchElm(RetNo,FName,j-1),4))='CEWS')
        then  //if there is CEWS
        Begin
            Valu:='0';  //transmit 0
        End;

        //20180105
        If (FName = 'S10') then
        Begin
         If GetTaxationYearEnd(RetNo)<'2017/01/01' then
         begin
          if LineNo = '101' then
             Valu:='';
          if LineNo = '475' then Valu:='';
         end;
        End;

        //20221129
        If (FName = 'S39') and (LineNo = '450') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
        end;

        // 20131021
        If (FName = 'S510') then
        begin
          // 20220616
           If LineNo = '112' then
           If Valu = '' then
           begin
                 DataType := 'A/N';
                 Valu := '0';
           end;
          If LineNo = '142' then
          If Valu = '' then
          begin
            DataType := 'A/N';
            Valu := '0';
          end;
          //-------------

          If IsAssociated(RetNo) then // 20131211
          Begin
            If LineNo = '116' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;
            If LineNo = '146' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;

            If LineNo = '114' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;

            If LineNo = '144' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;
          end;
        end;

        If (FName = 'S511') then
        begin
          If LineNo = '400' then
            If Valu = '' then
            begin
              DataType := 'A/N';
              Valu := '0';
            end;
          If LineNo = '500' then
            If Valu = '' then
            begin
              DataType := 'A/N';
              Valu := '0';
            end;
        end;
        // ----

        If AddressIndic then
        begin
          If InFormsWithSpecialAddress(FName) then
            PrepareAddressLoop(RetNo, FName, j, Valu, ScheduleId, ToElm, K,MaxLoopCounter, LineNo);
        end
        else
        Begin
          PrepareAnElement(ScheduleId, FName, LineNo, Valu, inttostr(K)); { Row }
          //20180516
          if (Fname='S18') and (LineNo='210') and (Valu>'') then  //if there is 210 then prepare line 200 also
            PrepareAnElement(ScheduleId, FName, '200', FetchElm(RetNo,'S18',j-4),inttostr(K)); { Row }
      end;
        Inc(j, ByIncr);
        Inc(K, 1);
      until (j > ToElm) or (K > MaxLoopCounter);
    end

    { lines and data }
    else If LineNo > '' then { Line Number }
    begin
      If LeftStr(FName, 1) = '=' then
        { Constants }
        // PrintAnElement(ScheduleId,X+(2/7),Y,12,True,False,MidStr(S,15,40))
        { Line valu }

      else If (FName > '') and (ElmNo >= 0) then
      begin
        FNo := GetFormNo(FName);
        If ElmNo > 0 then
        begin
          If ElmNo = 999 then
            Valu := ''
          else
          begin
            if SourceType = 'M' then
              Valu :=  FetchMemoData(RetNo, FNo, ElmNo)
            else
              Valu := GetValueFromForm(RetNo, FName, ElmNo, Inst);
            If (AddressIndic) and (InFormsWithSpecialAddress(FName)) then
              Valu := GetSpecialAddressValu(RetNo, FName, ElmNo, Valu);
          end;
        end
        else
          Valu := '';

        //20221114
       // If (ScheduleId = '200') and (LineNo = '060') then Valu := Valu+RemoveChar(FetchElm(RetNo,'T2',177),':'); //20170608
       // If (ScheduleId = '200') and (LineNo = '061') then Valu := Valu+RemoveChar(FetchElm(RetNo,'T2',207),':'); //20170608
        //20221115  //put back
        //20170606
        If FiscalTimeRequired(RetNo) then
        begin
          If (ScheduleId = '200') and (LineNo = '060') then Valu := Valu+RemoveChar(FetchElm(RetNo,'T2',177),':'); //20170608
          If (ScheduleId = '200') and (LineNo = '061') then Valu := Valu+RemoveChar(FetchElm(RetNo,'T2',207),':'); //20170608
        end;

        //20211010
        if FetchElm(RetNo,'T2',18)>'' then //change of control
        Begin
         If (ScheduleId = '200') and (LineNo = '065') then Valu := Valu+RemoveChar(FetchElm(RetNo,'T2',79),':');
        End;

        (*
        //20230605
        if (ScheduleId='200') and (Vl(FetchElm(RetNo,'T2',85))>Vl(FetchElm(RetNo,'T2',338))) then //change of control
        Begin
         Valu := FetchElm(RetNo,'T2',338);
        End;
       *)

        If (ScheduleId = '200') and (LineNo = '425') and (GetBegYearEnd(RetNo)>'2018/12/31') then Valu := '';  //20191008
        If (ScheduleId = '200') and (LineNo = '427') and (GetBegYearEnd(RetNo)>'2018/12/31') then Valu := '';  //20191008

        If ((ScheduleId = '200') and (LineNo = '896') and
          (Ret[RetNo].CorpType <> CCPC)) then
        begin
          DataType := 'A/N';
          Valu := '';
        end;


        //20171118
        If (ScheduleId = '010') and (LineNo = '475') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
          if GetTaxationYearEnd(RetNo)<'2017/01/01' then valu:=''; //20180104
        end;

        //20171115
        If (ScheduleId = '010') and (LineNo = '480') and (vl(Valu) = 0)
        and (FetchElm(RetNo,'S10',79)>'') then  //said NO to income meaning complete 480    //20171118
        begin
          DataType := 'A/N';
          Valu := '0';
          if GetTaxationYearEnd(RetNo)<'2017/01/01' then valu:=''; //20180104
        end;

        //20221129
        If (ScheduleId = '39') and (LineNo = '450') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
        end;

        If (ScheduleId = '200') and (LineNo = '300') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
        end;

        //20160601
        If (LineNo = '8299') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
          if Vl(FetchElm(RetNo,'S125#1',29))>0 then Valu:='';  //if thre is Farming income //20221106
        end;


          //20161115
        If (LineNo = '9999') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
        end;


        //20161115
        If (LineNo = '2599') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
        end;

        //20161115
        If (LineNo = '3499') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
        end;

        If (LineNo = '3620') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
        end;


        //20161115
        If (LineNo = '3849') and (vl(Valu) = 0) then
        begin
          DataType := 'A/N';
          Valu := '0';
        end;

       //20170621
        If (FName = 'S31') then
        begin
          If LineNo = '398' then
          Begin
           If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;
          end;
        end;

        // 20131021
        If (FName = 'S510') then
        begin
          // 20220616
           If LineNo = '112' then
           If Valu = '' then
           begin
                 DataType := 'A/N';
                 Valu := '0';
           end;
          If LineNo = '142' then
          If Valu = '' then
          begin
            DataType := 'A/N';
            Valu := '0';
          end;
          //----

          If IsAssociated(RetNo) then // 20131211
          Begin
            If LineNo = '116' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;
            If LineNo = '146' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;
            {//20220616
            // 20151028
            If LineNo = '112' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;
            }
            If LineNo = '114' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;
            { //20220616
            If LineNo = '142' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;
             }
            If LineNo = '144' then
              If Valu = '' then
              begin
                DataType := 'A/N';
                Valu := '0';
              end;
          end;
        end;
        // 20111130
        If (ScheduleId = 'S511') then
        begin
          If (LineNo = '400') and (vl(Valu) = 0) then
          begin
            DataType := 'A/N';
            Valu := '0';
          end;
          If (LineNo = '500') and (vl(Valu) = 0) then
          begin
            DataType := 'A/N';
            Valu := '0';
          end;
        end;
        If (ScheduleId = '125') and (CountIncStatements(RetNo) > 1) then
        begin
          If (LineNo = '9975') or (LineNo = '9976') or (LineNo = '9980') or
            (LineNo = '9985') or (LineNo = '9990') or (LineNo = '9995') or
            (LineNo = '9999') then
          begin
            DataType := 'A/N';
            Valu := '';
          end;
        end;

        If (ScheduleId = '508') and (LineNo = '320') then
        begin
          If FetchElm(RetNo, 'S508', 27) > '' then
          begin
            If Valu = '' then
            begin
              DataType := 'A/N';
              Valu := '0';
            end;
          end;
        end;

        If (ScheduleId = '566') and (LineNo = '720') then
        Begin
          If FetchElm(RetNo, 'S566', 177) > '' then
          begin
            If Valu = '' then
            begin
              DataType := 'A/N';
              Valu := '0';
            end;
          end;
        end;

        If (ScheduleId = '027') and (LineNo = '105') then
        begin
          If vl(FetchElm(RetNo, 'S27', 5)) = 0 then
          begin
            If ((Ret[RetNo].Ln[616] > 0) and (vl(FetchElm(RetNo, 'S27', 4)) > 0)
              ) or (vl(FetchElm(RetNo, 'S27', 6)) <= 200000) and
              (IsAssociated(RetNo)) then
            begin
              DataType := 'A/N';
              Valu := '0';
            end;
          end;
        end;

        If DataType = 'Y/N' then
          Valu := formatYesOrNoValu(Valu, FName, ElmNo);

        // 20151025
        If FName = 'S31' then
        begin
          If Ret[RetNo].CorpType <> CCPC then // only on ccpc
          Begin
            If LineNo = '385' then
              Valu := '';
          End;
        end;

        If DataType = 'Y/b' then
          Valu := FormatYesOrBlank(Valu, FName, ElmNo);
        If DataType = '1/2' then
          Valu := formatOneOrTwoValu(Valu);
        If DataType = '1/b' then
          Valu := FormatOneOrBlank(Valu);
        If DataType = '1/' then
          Valu := FormatOneOrTwoOrBlank(RetNo, FName, ElmNo, Valu);
        NegativeIndic := GetNegativeIndic(DataType, Valu);
        If DataType = '$' then
          Valu := FormatBarCodeAmount(Valu, NegativeIndic)
        else If DataType = '$$' then
        begin
          Valu := JustRight(FormatStandardAmount(Valu, NegativeIndic), 13);
          If AllTrim(Valu) = '' then
            Valu := JustRight('0', 13);
        end;
        If DataType = '%' then
          Valu := FormatPercent(Valu);
        If (DataType = 'D') or (DataType = 'D/T') then
          Valu := FormatDateValu(Valu);

        // 2008-01-22
        if (FName = 'T2') and (ElmNo = 3) then
          bardata := bardata + LineNo + Valu + ' '
          // first line with out instance or Delim
        else if (FName = 'T2') and (ElmNo = 65) then
          bardata := bardata + Valu + RecordDelim
          // second line done to "combine the two lines"
        else
          PrepareAnElement(ScheduleId, FName, LineNo, Valu, SourceType);
      end; { Fname andElmNo }
    end; { end lineno }

    Inc(i);
    PrintLastLoopIndicator := True;
  until i > RsiSpecs.Count - 1;
end; { procedure }

procedure TBarDataGenT2_2027.RsiFrmListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
Var
  Offset: Integer; { text offset width }
  FName: String[10];
  FNo: Integer;
  RsiNm: String[14];
begin
  with (Control as TListBox)
    .Canvas do { draw on the control canvas, not on the form }
  begin
    FillRect(Rect); { clear the rectangle }
    Offset := 1; { provide default offset }
    RsiNm := AllTrim(LeftStr((Control as TListBox).Items[Index], 13));

    Font.Color := clBlack;
    If RsiHasData(RetNo, RsiNm) then Font.Color := clBlue;
    //20210516
    // 20090906
    //If ((RsiNm = 'Schedule 546') and (FetchElm(RetNo, 'S546', 68) = '')) then  Font.Color := clBlack;
    //If ((RsiNm = 'Schedule 547') and (FetchElm(RetNo, 'S546', 68) = '')) then  Font.Color := clBlack;
    TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

Function TBarDataGenT2_2027.RsiHasData(RetNo: Integer; RsiNm: String): Boolean;
Var
  FName: String[10];
  FNo: Integer;
begin

  result := False;

  If (RsiNm = 'Schedule 8') then //20180529  This is diffrent than RsiNm = 'Schedule 008')
  begin
    If ProductionOrTestGroup.itemindex=0 then result:=False; //Skip S8 if Production, allow only in testing
    exit;
  end;

  If (RsiNm = 'Schedule 005') then // 20121027  //20130515
  begin
    result := ShouldFileS5(RetNo);
    exit;
  end;

  If RsiNm = 'Schedule 001' then
  begin
    FNo := GetFormNo('S1');
    If (vl(FetchElmFNo(RetNo, FNo, 34)) = 0) and
      (vl(FetchElmFNo(RetNo, FNo, 53)) = 0) and
      (vl(FetchElmFNo(RetNo, FNo, 4)) = vl(FetchElmFNo(RetNo, FNo, 54))) then
    begin
      result := False;
      exit;
    end;
  end;

  //20250524
  If RsiNm = 'Schedule 007' then
  begin
    FNo := GetFormNo('S7');
    If (Ret[RetNo].FrmhasData[FNo])
    {
    if (Ret[RetNo].CorpType=CCPC)
    Or (Ret[RetNo].CorpType=OtherPrivate)
    }
    then
    //ok
    Else
    begin
      result := False;
      exit;
    end;
  end;

  If RsiNm = 'Schedule 023' then
  begin
    If IsNonResidentCorp(RetNo) then
    begin
      result := False;
      exit;
    end;
  end;

  // 20130516
  If RsiNm = 'Schedule 033' then
  begin
    If UpperCase(FetchElm(RetNo, 'S33', 25)) <> 'Y' then
    begin
      result := False;
      exit;
    end;
  end;

  If RsiNm = 'Schedule 042' then
  begin
    If FetchElm(RetNo, 'T2', 181) = '' then
    begin
      result := False;
      exit;
    end;
  end;

  If RsiNm = 'Schedule 047' then
  begin
    If (Ret[RetNo].FrmHasData[GetFormNo('T1131#1')]) or (Ret[RetNo].Ln[796] > 0)
    then
    begin
      result := True;
      exit;
    end;
  end;

  If RsiNm = 'Schedule 049' then
  begin
    If vl(FetchElm(RetNo, 'S49', 127)) = 0 then
    begin
      result := False;
      exit;
    end;
  end;

  // 20100408
  If RsiNm = 'Schedule 055' then
  begin
    If FetchElm(RetNo, 'T2', 227) > '' then
      result := True
    else
      result := False;
    exit;
  end;

  If RsiNm = 'Schedule 061' then
  begin
    // 20090426
    If Ret[RetNo].FrmHasData[GetFormNo('T1145#1')] then
      result := True
    else
      result := False;
    exit;
  end;

  If RsiNm = 'Schedule 062' then
  begin
    // 20090426
    If Ret[RetNo].FrmHasData[GetFormNo('T1146#1')] then
      result := True
    else
      result := False;
    exit;
  end;

  //20230609
  If RsiNm = 'Schedule 067' then
  begin
    If Ret[RetNo].FrmHasData[GetFormNo('S67')] then
      result := True
    else
      result := False;
    exit;
  end;

  //20230609
  If RsiNm = 'Schedule 068' then
  begin
    If Ret[RetNo].FrmHasData[GetFormNo('S68')] then
      result := True
    else
      result := False;
    exit;
  end;



  If RsiNm = 'Schedule 140' then
  begin
    if CountMultipleInstances(RetNo,'S125') >1 then   //20160506
   // If CountIncStatements(RetNo) > 1 then
      result := True
    else
      result := False;
    exit;
  end;

  If RsiNm = 'Schedule 101' then
  begin
    If (FetchElm(RetNo, 'T2', 28) > '') or (FetchElm(RetNo, 'T2', 30) > '') then
      result := True;
    exit;
  end;

  If RsiNm = 'Schedule 013' then
  begin
    If RsiS13HasData(RetNo) then
      result := True;
    exit;
  end;

  // 20130518
  If RsiNm = 'Schedule 342' then
  begin
    If vl(FetchElm(RetNo, 'S432', 112)) = 0 then
      result := False;
    exit;
  end;

  //20171106
  If RsiNm = 'Schedule 403' then
  begin
    If (Ret[RetNo].FrmHasData[GetFormNo('S403')]) = True then
      result := True;
    exit;
  end;


  If RsiNm = 'Schedule 510' then
  begin
    If IncludeS510InFiling(RetNo) then
      result := True;
    exit;
  end;

  // 20111130
  If RsiNm = 'Schedule 511' then
  begin
    If (IncludeS510InFiling(RetNo)) and (IsAssociated(RetNo)) then
      result := True; // 20120604
    exit;
  end;


  If (RsiNm = 'Schedule 075') then //jz 20241203
  begin
    //just used as a stop for now
    If ProductionOrTestGroup.itemindex=0 then result:=False;
    //exit;
  end;


  FName := GetFormNameFromRsi(RsiNm, 'F');
  FNo := GetFormNo(FName);
  If (FNo = 0) or (FName = '') then
    exit;
  If Ret[RetNo].FrmHasData[FNo] then
    result := True;


end;

Function TBarDataGenT2_2027.GetNumberOfRsiWithData(RetNo: Integer): Integer;
var
  i: Integer;
  RsiForm: String;
begin
  result := 0;
  For i := 0 to RsiFrmList.Items.Count - 1 do
  begin
    RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i], 13));
    If RsiHasData(RetNo, RsiForm) then
    begin
      result := result + 1;
    end;
  end;
end;

//20160503
procedure TBarDataGenT2_2027.PrntBarCodedBtnClick(Sender: TObject);
begin
 // If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit; //20201229
  {//20201229
  //20170628
  if NotPaidFor2018(RetNo) then
  Begin
    ShowMessage('Your T2 program license does not cover year ends beyond 2016/12/31. Please renew your license');
    Exit;
  end;
 }
  // 20150316 removethe If
  If TotMultiple(RetNo, 'S125', 14) + TotMultiple(RetNo, 'S125',89) > 1000000 then
  begin
    ShowMessage('Gross Revenue exceeds $1 Million.' + Chr(13) +
      'You must Efile this return' + Chr(13) +
      'CRA may impose penalties');
  end;
  //20201015
  If MessageDlg('Please File your return electronically by clicking the EFILE NOW button.'
    +Chr(13)+'It is secure, convenient and faster than mailing a bar code return.'
    +Chr(13)+'95% of corporation returns filed electronically are processed within 6 weeks.'
    +Chr(13)+' '
    +Chr(13)+'Allow bar code printing this time?',
     mtInformation, [mbYes, mbNo], 0) = mrYes then
    // Ok
  Else
  Exit;

  Efiling := False;
  PrintBarCodePages(BarDataArray);
  // UpdatePrintDate(RetNo,OptRec.Dir_Cur,Ret[RetNo].SourceFlName);  //20101128 did not work
  Screen.Cursor := crDefault;
end;

procedure TBarDataGenT2_2027.ProductionOrTestGroupChange(Sender: TObject);
begin
(*
 //20171117
 if ProductionOrTestGroup.itemindex=1 then     // t2 testing
 begin
   sURL := 'https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl';
   UrlForWebServices.Text:=sUrl;
   TestingIndicator.visible:=True;
 end
 else //production
 begin
    ProductionOrTestGroup.itemindex:=0;
    sURL := 'https://apps.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl';
    TestingIndicator.visible:=False;
    UrlForWebServices.Text:=sUrl;
 end;
 *)
end;

procedure TBarDataGenT2_2027.ProductionOrTestGroupClick(Sender: TObject);
begin

//20171118
 if ProductionOrTestGroup.itemindex=1 then     // t2 testing
 begin
   sURL := 'https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl';
   UrlForWebServices.Text:=sUrl;
   corFileClickLbl.Visible:=True;
  // TestingIndicator.visible:=True;
 end
 else //production
 begin
    ProductionOrTestGroup.itemindex:=0;
    sURL := 'https://apps.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl';
    corFileClickLbl.Visible:=False;
    UrlForWebServices.Text:=sUrl;
 end;
end;


procedure TBarDataGenT2_2027.PrepareData(Sender: TObject);
var
  s, RsiForm: String;
  LineCommand, FName, ElmString, LineNo: String;
  Templist, RsiSpec: TStringList;
  i, K, n, j, jj, TotalRsiWithData: Integer;

  MaxArrayLengthPos, MaxArrayLength: Integer;
  tempAnsiArray: Array of AnsiString;
  tempAnsiString: AnsiString;

begin
  Screen.Cursor := crHourGlass;
  OutFileList.Clear;
  // FRetNo := GetCurrentRetNo;
  RsiFrmList.ItemIndex := 0;
  Inst := 1;
  TotalRsiWithData := 1;
  SetLength(BarDataArray, TotalRsiWithData);
  BarDataArray[TotalRsiWithData - 1] := '';

  For i := 0 to RsiFrmList.Items.Count - 1 do
  begin
    Inst := 1; // 2008/11/11
    RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i], 13));
    If RsiHasData(RetNo, RsiForm) then
    begin
      RsiFrmList.ItemIndex := i;
      //if (RsiForm = 'Schedule 007') and (Ret[RetNo].FrmHasData[GetFormNo('S7')]=false) then
      OutFileList.Add('---- ' + RsiForm + ' ----');
      PrepareSingleRSI(RsiForm);


      K := GetMultipleRSICount(RetNo, RsiForm);
      jj := 2;
      For j := jj to K do
      begin
        Inst := j;
        PrepareSingleRSI(RsiForm);
      end;

      // put all data onto one string in first array location (array not really necessary)
      BarDataArray[TotalRsiWithData - 1] := BarDataArray[TotalRsiWithData - 1]
        + bardata;
      bardata := '';

    end; // end of schedule has data
  end; // end for loop

  OutFileList.Add('EOD');
  OutFileList.SaveToFile(AppDir + '\' + 'BarData.txt');
  // capture generated data
  // ShowBarCodeDataBtn.Enabled:=True;
  BarDataArray[high(BarDataArray)] := BarDataArray[high(BarDataArray)] + 'EOD';
end;

procedure TBarDataGenT2_2027.PrintBarCodePages(BarDataArray: Array of String);
var
  i, j, maxBarDataElements, TotalBarCodeCount: Integer;
  SplitBarDataArray: TSplitBarDataArray;
  MergedBarDataArray: array of String;
  BarCodeImageArray: Array of TImage;
  bardata: string;
begin
  Screen.Cursor := crHourGlass;
  maxBarDataElements := 735; // 20130522  //range error for test2
  TotalBarCodeCount := 0;

  for i := low(BarDataArray) to High(BarDataArray) do
  begin
    SetLength(SplitBarDataArray, i + 1);
    bardata := BarDataArray[i];
    j := 1;
    while bardata > '' do
    begin
      SetLength(SplitBarDataArray[i], j);
      SplitBarDataArray[i][j - 1] := leftAnsiStr(bardata, maxBarDataElements);
      bardata := midAnsiStr(bardata, maxBarDataElements + 1,
        Length(bardata) - maxBarDataElements);
      Inc(j, 1);
      Inc(TotalBarCodeCount, 1);
    end;
  end;

  SetLength(BarCodeImageArray, TotalBarCodeCount);

  CreateBarCode(SplitBarDataArray, BarCodeImageArray);
  PrintBarCode(BarCodeImageArray);

  Screen.Cursor := crDefault;

end;

procedure TBarDataGenT2_2027.CreateBarCode(SplitBarDataArray
  : TSplitBarDataArray; var BarCodeImageArray: Array of TImage);
var
  i, j, n, codeLength, ImageArrayPos: Integer;
  FileIDFieldVar, TempFileIDFieldVar: String;
  MyPDF: TPDF417;
  myDateTime: TDateTime;
  myHour, myMin, mySec, myMilli: Word;
begin
  myDateTime := now;
  ImageArrayPos := 0;
  for i := low(SplitBarDataArray) to High(SplitBarDataArray) do
  begin
    DecodeTime(myDateTime, myHour, myMin, mySec, myMilli);
    FileIDFieldVar := Format('%.2d', [myHour]) + Format('%.2d', [myMin]);
    TempFileIDFieldVar := Format('%.2d', [myMin]);
    // showmessage(FileIDFieldVar);
    // showmessage(TempFileIDFieldVar);
    myDateTime := IncMinute(myDateTime, 1);

    for j := High(SplitBarDataArray[i]) downto low(SplitBarDataArray[i]) do
    begin
      BarCodeImageArray[ImageArrayPos] := TImage.Create(Application);

      BarCodeImageArray[ImageArrayPos].Height := 200;
      BarCodeImageArray[ImageArrayPos].Width := 400;

      BarCodeImageArray[ImageArrayPos].Transparent := True;
      BarCodeImageArray[ImageArrayPos].AutoSize := False;

      MyPDF := TPDF417.Create(nil);
      MyPDF.resetMacroPDF();

      MyPDF.PDFMode := PDF_BINARY;

      MyPDF.Width := BarCodeImageArray[ImageArrayPos].Width;
      MyPDF.Height := BarCodeImageArray[ImageArrayPos].Height;

      MyPDF.BarWidthPixels := 1;
      MyPDF.BarHeightPixels := 3;

      MyPDF.TopMargin := 0; // 10;
      MyPDF.LeftMargin := 0; // 10;

      MyPDF.AutoFit := True;

      MyPDF.PDFECLevel := 5; // error checking

      MyPDF.code := '';
      MyPDF.code := SplitBarDataArray[i][j];

      if High(SplitBarDataArray[i]) > 0 then
      begin
        if j = High(SplitBarDataArray[i]) then
        begin
          MyPDF.MacroPDFLastSegment := True;
        end
        else
        begin
          MyPDF.MacroPDFLastSegment := False;
        end;

        MyPDF.PDFMacroFileId := LeftStr('1' + LeftStr(RSIApprovalCode, 2) +
          FileIDFieldVar, 7);

        MyPDF.PDFMacroSegmentCount := High(SplitBarDataArray[i]) + 1;
        MyPDF.PDFMacroSegment := j;
      end;

      codeLength := Length(MyPDF.code);

      MyPDF.PDFColumns := 14; // 12;  //10;
      MyPDF.PDFRows := 50; // 60; //30;

      MyPDF.paintBarcode(BarCodeImageArray[ImageArrayPos].Canvas);
      MyPDF.Free;

      Inc(ImageArrayPos, 1);
    end;
  end;
end;

function TBarDataGenT2_2027.IncMinute(const AValue: TDateTime;
  const ANumberOfMinutes: Int64): TDateTime;
begin
  result := ((AValue * 1440 { MinsPerDay } ) + ANumberOfMinutes) /
    1440 { MinsPerDay };
end;

procedure TBarDataGenT2_2027.PrintBarCode(Var BarCodeImageArray
  : Array of TImage);
const // 640     450     260
  BarCodeTopArray: array [1 .. 8] of Integer = (830, 830, 650, 650, 470,
    470, 290, 290);
  BarCodeLeftArray: array [1 .. 8] of Integer = (435, 65, 435, 65, 435,
    65, 435, 65);
var
  i, dpiAdjustment, barscaleWidthAdjustment, barscaleHeightAdjustment: Integer;
  PageX, PageY: LongInt;
  R: TRect;
  Hdc: Thandle;
  RetNo, barCodePos, PageCount, TotalPageCount: Integer;
  ACanvas: TCanvas;

  xExtraDPIAdjustment, yExtraDPIAdjustment, BarCodeTopDPIAdjustment: Integer;
begin
  If not PrintDialog1.Execute then
    exit;

  OldModeScale := True; //20170223 Igor
  try                   //20170223 Igor
    If (UpperCase(LeftStr(GetDefaultPrinterName, 5)) = 'ADOBE') or
      (UpperCase(LeftStr(GetDefaultPrinterName, 10)) = 'PDFFACTORY') then
    begin
      ShowMessage('You must not print the Bar Code on a PDF printer' + Chr(13) +
        'It may distort the Bar Code. Please use a normal printer');
      // Exit;
    end;

    RetNo := GetCurrentRetNo;

    TotalPageCount := ceil((high(BarCodeImageArray) - 5 + 1) / 8) + 2; // + 1;

    barCodePos := 1;
    PageCount := 0;

    // set printer attributes
    Printer.Orientation := poPortrait;
    Printer.Title := GetCorpName(RetNo);

    Printer.BeginDoc;
    try  //20170223 Igor
      Hdc := Printer.Canvas.Handle;
      ACanvas := Printer.Canvas;

      // get scaling info
      PageX := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH); // Printer.PageWidth;
      PageY := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT); // Printer.PageHeight;
      dpiAdjustment := (GetWindowsFontSize(MainForm.Handle) * 100)
        div DesignPixelsPerInch;

      for i := low(BarCodeImageArray) to high(BarCodeImageArray) do
      begin
        if (barCodePos = 1) then
        begin
          Inc(PageCount, 1);

          xExtraDPIAdjustment := 0;
          yExtraDPIAdjustment := 0;

          if dpiAdjustment >= 150 then
          begin
            xExtraDPIAdjustment := -48;
            yExtraDPIAdjustment := -45;
          end
          else if dpiAdjustment >= 120 then
          begin
            xExtraDPIAdjustment := -24;
            yExtraDPIAdjustment := -25;
          end;

          // set normal scaling
          ScaleX := (PageX * ScMult)
            div ((MxFrmWidth * (dpiAdjustment + xExtraDPIAdjustment)) div 100);
          // to get the decimals
          ScaleY := (PageY * ScMult)
            div ((777 * (dpiAdjustment + yExtraDPIAdjustment)) div 100);
          // to get the decimals

          addToPage(RetNo, PageCount, TotalPageCount, ACanvas);
        end;

        if BarCodeImageArray[i] <> nil then
        begin
          // set special scaling for barcode...........
          barscaleWidthAdjustment := 200;
          barscaleHeightAdjustment := 340;

          xExtraDPIAdjustment := 0;
          yExtraDPIAdjustment := 0;
          BarCodeTopDPIAdjustment := 0;

          if dpiAdjustment >= 150 then
          begin
            xExtraDPIAdjustment := -200;
            yExtraDPIAdjustment := -200;
            BarCodeTopDPIAdjustment := 175;
          end
          else if dpiAdjustment >= 120 then
          begin
            xExtraDPIAdjustment := -25;
            yExtraDPIAdjustment := -25;
            BarCodeTopDPIAdjustment := 190;
          end;

          ScaleX := (PageX * ScMult)
            div (((MxFrmWidth + barscaleWidthAdjustment + xExtraDPIAdjustment) *
            dpiAdjustment) div 100); // to get the decimals
          ScaleY := (PageY * ScMult)
            div (((777 + barscaleHeightAdjustment + yExtraDPIAdjustment) *
            dpiAdjustment) div 100); // to get the decimals

          BarCodeImageArray[i].Top := BarCodeTopArray[barCodePos] +
            BarCodeTopDPIAdjustment;
          BarCodeImageArray[i].Left := BarCodeLeftArray[barCodePos];
          R.Left := ScalePrX(BarCodeImageArray[i].Left);
          R.Top := ScalePrY(BarCodeImageArray[i].Top);
          R.Right := ScalePrX(BarCodeImageArray[i].Left + BarCodeImageArray
            [i].Width);
          R.Bottom := ScalePrY(BarCodeImageArray[i].Top + BarCodeImageArray
            [i].Height);

          ACanvas.StretchDraw(R, BarCodeImageArray[i].Picture.Graphic);

          // number of barcode on first and subsequent pages...
          if ((barCodePos = 5) and (PageCount = 1)) or (barCodePos = 8) then
          begin
            barCodePos := 1;
            if PageCount <> TotalPageCount - 1 then
              Printer.NewPage;
          end
          else
          begin
            Inc(barCodePos, 1);
          end;
        end // end if nil
        else
          Inc(barCodePos, 1);
      end; // end for

      BarCodePrinted := True; // not sure what this does.....

      Printer.NewPage;

      xExtraDPIAdjustment := 0;
      yExtraDPIAdjustment := 0;

      if dpiAdjustment >= 150 then
      begin
        xExtraDPIAdjustment := -48;
        yExtraDPIAdjustment := -45;
      end
      else if dpiAdjustment >= 120 then
      begin
        xExtraDPIAdjustment := -25;
        yExtraDPIAdjustment := -25;
      end;

      // set scaling for BCRCertifPage
      ScaleX := (PageX * ScMult)
        div ((MxFrmWidth * (dpiAdjustment + xExtraDPIAdjustment)) div 100);
      // to get the decimals
      ScaleY := (PageY * ScMult) div ((777 * (dpiAdjustment + yExtraDPIAdjustment))
        div 100); // to get the decimals

      Inc(PageCount, 1);
      addToPage(RetNo, PageCount, TotalPageCount, ACanvas);
      PrintBCRcertifPage(RetNo, PageCount, TotalPageCount, ACanvas);
  //20170223 Igor>>>
    finally
      Printer.endDoc;
    end;
  finally
    OldModeScale := False;
  end;
  //20170223 Igor<<<

end;

procedure TBarDataGenT2_2027.PrintBCRcertifPage(RetNo: Integer;
  PageCount: Integer; TotalPages: Integer; ACanvas: TCanvas);
var
  MyLabel: TvtLabel;
  MyShape: TvtShape;
  i, singleSpace, doubleSpace, padding: Integer;
  Frmt: String;
  textFontSize,titleFontSize: Integer;
  AmountsStartLocation, AmountsEndLocation: Integer;
begin
  padding := 3;
  singleSpace := 13;
  doubleSpace := 20;

  Frmt := '#,###,###,##0';

  //20180509   Subtract 1 then during VTLabel printing it adds 1
  titleFontSize     := 14-1;  //13; //20171120
  textFontSize      := 12-1;


  MyLabel := TvtLabel.Create(Application);

  MyLabel.Font.Name := 'Times New Roman';

  MyLabel.vtTransparent := True;
  MyLabel.Transparent := True;
  MyLabel.Font.Size := textFontSize;
  MyLabel.Font.Style := [];
  MyLabel.Top := 155;
  MyLabel.Left := 7;

  MyLabel.Caption := 'Under the ';
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Left := 60;
  MyLabel.Font.Style := [fsItalic];
  MyLabel.Caption := 'Income Tax Act,';
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Left := 145;
  MyLabel.Font.Style := [];
  MyLabel.Caption :=
    'you must keep all records used to prepare your corporation income tax return, and ';
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'provide this information to us upon request.';
  MyLabel.Left := 7;
  MyLabel.Top := MyLabel.Top + singleSpace;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Top := 220;
  MyLabel.Left := 21;

  MyLabel.Caption := 'I, ';
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Left := 40;
  MyLabel.vtBorderType := vtlblUnderline;
  MyLabel.Width := 150; // 250;  20110411
  MyLabel.Height := 14;
  MyLabel.Alignment := taCenter;
  MyLabel.AutoSize := False;
  MyLabel.Caption := AllTrim(FetchElm(RetNo, 'T2', 743)) + ' ' +
    AllTrim(FetchElm(RetNo, 'T2', 742));
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Left := 200; // 300;  20110411
  MyLabel.vtBorderType := vtlblNoBorder;
  MyLabel.Alignment := taLeftJustify;
  MyLabel.AutoSize := True;
  MyLabel.Caption :=
    ' am an authorized signing officer of the corporation. I certify that I have';
  // 20110411
  PrintLabel(MyLabel, ACanvas, DefBarFontName);
  // 20110411
  MyLabel.Top := MyLabel.Top + singleSpace;
  MyLabel.Left := 21; // 20110411
  MyLabel.Caption :=
    'examined the corporation''s income tax return, including accompanying schedules and statements, for the tax';
  PrintLabel(MyLabel, ACanvas, DefBarFontName);
  MyLabel.Top := MyLabel.Top + singleSpace;
  MyLabel.Left := 21; // 20110411
  MyLabel.Caption := 'year noted on this return.';
  PrintLabel(MyLabel, ACanvas, DefBarFontName);
  //
  MyLabel.Caption :=
    'I certify that the following amounts are, to the best of my knowledge, correct and complete, and fully disclose ';
  MyLabel.Top := MyLabel.Top + doubleSpace + 10;
  MyLabel.Left := 21;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption :=
    'the corporation''s income tax payable.  These amounts also reflect the information given on the corporation''s ';
  MyLabel.Top := MyLabel.Top + singleSpace;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'income tax return for the tax year noted on this return.';
  MyLabel.Top := MyLabel.Top + singleSpace;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  // add indent to labels ---------------------------------------------------
  MyLabel.Left := 28;
  MyLabel.AutoSize := False;
  MyLabel.Width := 455;

  MyLabel.Caption := 'Net income or (loss) for income tax purposes';
  MyLabel.Top := MyLabel.Top + doubleSpace + 10;
  AmountsStartLocation := MyLabel.Top;

  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  // add underlines ---------------------------------------------------------
  MyLabel.Layout := tlBottom;
  // tlTop; tlCenter;  //helps to align underlines when large dpi 06132012
  MyLabel.vtBorderType := vtlblUnderline;

  MyLabel.Caption := 'from Schedule 001, financial statements or GIFI';
  // [line 200300]
  MyLabel.Top := MyLabel.Top + singleSpace;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Part I tax payable'; // [line 200700]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);
  { //removed??
    MyLabel.Caption := 'Part I.3 tax payable'; //[line 200704]
    MyLabel.Top := MyLabel.Top + singleSpace + padding;
    PrintLabel(MyLabel,ACanvas,DefBarFontName);
  }

  {//20220607
  MyLabel.Caption := 'Part II surtax payable'; // [line 200708]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);
  }


  MyLabel.Caption := 'Part II.2 tax payable'; // [line 200705] //jz 20240617
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);


  MyLabel.Caption := 'Part III.1 tax payable'; // [line 200710]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Part IV tax payable'; // [line 200712]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Part IV.1 tax payable'; // [line 200716]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Part VI tax payable'; // [line 200720]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Part VI.1 tax payable'; // [line 200724]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Part VI.2 tax payable'; // [line 200725] //20231020
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Part XII.7 tax payable'; // [line 200726] Elm:138 //220250530
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Part XIII.1 tax payable'; // [line 200727]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Part XIV tax payable'; // [line 200728]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Net provincial and territorial tax payable(except Quebec and Alberta)'; //20190428
  // [line 200760]
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  // remove underlines, indent ----------------------------------------------
  MyLabel.Layout := tlTop; // tlBottom; tlCenter; //return to default, for dpi
  MyLabel.vtBorderType := vtlblNoBorder;
  MyLabel.Left := 21;
  MyLabel.AutoSize := True;

  MyLabel.Caption :=
    'I further certify that the method of calculating income for this tax year is consistent with that of the previous ';
  MyLabel.Top := MyLabel.Top + doubleSpace + 10;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption :=
    'year except as specifically disclosed in a statement attached to this return.';
  MyLabel.Top := MyLabel.Top + singleSpace;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  AmountsEndLocation := MyLabel.Top + doubleSpace;

  MyLabel.Layout := tlBottom; // tlTop; tlCenter; //for dpi
  MyLabel.Left := 490; // 450; //385;
  // MyLabel.Top := 300 + padding;
  MyLabel.Top := AmountsStartLocation;
  for i := 0 to 10 do //jz 20240617 //9 do //JZ 06272023 //i := 0 to 10 do // 20150421 for i:=0 to 12 do
  begin
    MyLabel.Caption := '$';
    MyLabel.Top := MyLabel.Top + singleSpace + padding;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);
  end;

  MyLabel.Alignment := taRightJustify;
  MyLabel.vtBorderType := vtlblUnderline;
  MyLabel.AutoSize := False;
  MyLabel.Width := 85; // 190;
  MyLabel.Left := MyLabel.Left + 5; // 390;
  MyLabel.Top := AmountsStartLocation;
  MyLabel.Top := MyLabel.Top + singleSpace; // + (padding * 2);
  // MyLabel.Top := 300 + singleSpace + (padding * 2);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 214))));  //net income / loss
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 701))));  //part I
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 126)))); //part II.2 //jz 20240617
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 722)))); //part III.1
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 704)))); //part IV
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 705)))); //part IV.1
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 706)))); //part VI
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 707)))); //part VI.1
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //jz 20231020 added
  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 118)))); //part VI.2
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //20250530
  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 138)))); //part XII.7
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 759)))); //part XIII.1
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 708)))); //part XIV
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := FormatFloat(Frmt, vl(AllTrim(FetchElm(RetNo, 'T2', 711)))); //net prov or territorial tax
  MyLabel.Top := MyLabel.Top + singleSpace + padding;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  // --------------------------------------------------------------------------------
  MyLabel.Layout := tlTop; // tlBottom; tlCenter; //for dpi
  MyLabel.vtBorderType := vtlblNoBorder;
  MyLabel.Alignment := taLeftJustify;

  MyLabel.Top := AmountsEndLocation + padding;

  MyLabel.Caption := '(' + AllTrim(FetchElm(RetNo, 'T2', 755)) + ') ' +
    AllTrim(FetchElm(RetNo, 'T2', 746)); // auth person phone
  If AllTrim(MyLabel.Caption) = '()' then
    MyLabel.Caption := '';
  MyLabel.Left := 355;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := AllTrim(FetchElm(RetNo, 'T2', 744)); // position
  MyLabel.Left := 455;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Top := MyLabel.Top + doubleSpace;

  MyLabel.Caption := 'Signature of the authorized signing officer of the';
  // corporation';  //20110411
  MyLabel.Left := 25; // 115;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Phone';
  MyLabel.Left := 355;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Position, office or';
  MyLabel.Left := 455;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Top := MyLabel.Top + singleSpace;
  MyLabel.Caption := 'corporation'; // corporation';  //20110411
  MyLabel.Left := 25; // 20110411
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'rank'; // 20110411
  MyLabel.Left := 455; // 20110411
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Top := MyLabel.Top + doubleSpace + padding * 2;

  MyLabel.Caption := AllTrim(FetchElm(RetNo, 'T2', 749));
  // different auth person name
  MyLabel.Left := 25;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := '(' + AllTrim(FetchElm(RetNo, 'T2', 756)) + ') ' +
    AllTrim(FetchElm(RetNo, 'T2', 750)); // different auth person phone
  If AllTrim(MyLabel.Caption) = '()' then
    MyLabel.Caption := '';
  MyLabel.Left := 355;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := AllTrim(FetchElm(RetNo, 'T2', 745)); // date
  MyLabel.Left := 455;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Top := MyLabel.Top + singleSpace; // doubleSpace;

  MyLabel.Caption := 'Contact person, if different to authorized signing';
  MyLabel.Left := 25;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Phone';
  MyLabel.Left := 355;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Date';
  MyLabel.Left := 455;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Top := MyLabel.Top + singleSpace;
  MyLabel.Caption := 'officer';
  MyLabel.Left := 25;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  MyLabel.Caption := 'Certification';
  MyLabel.Font.Size := titleFontSize;
  MyLabel.Font.Style := [fsBold];
  MyLabel.Top := 190;
  MyLabel.Left := 255;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  // main box
  MyShape := TvtShape.Create(Application);
  MyShape.Top := 190;
  MyShape.Left := 7;
  MyShape.Height := AmountsEndLocation - MyShape.Top; // 385;
  MyShape.Width := 600;
  PrintVtShape(MyShape, ACanvas);

  // lower box
  MyShape.Top := MyShape.Top + MyShape.Height;
  MyShape.Left := 7;
  MyShape.Height := doubleSpace * 2 + singleSpace + padding; // 50;
  MyShape.Width := 600;
  PrintVtShape(MyShape, ACanvas);

  // 2nd lower box
  MyShape.Top := MyShape.Top + MyShape.Height;
  MyShape.Left := 7;
  MyShape.Height := doubleSpace * 2 + singleSpace; // 60; //50;  //20110411
  MyShape.Width := 600;
  PrintVtShape(MyShape, ACanvas);

  MyLabel.Free;
  MyShape.Free;

end;

procedure TBarDataGenT2_2027.addToPage(RetNo: Integer; PageCount: Integer;
  TotalPages: Integer; ACanvas: TCanvas);
const
  padding = 3;
  singleSpace = 13;
  doubleSpace = 20;
var
  MyLabel: TvtLabel;
  MyShape: TvtShape;
  textFontSize, nameFontSize, versionFontSize, pageFontSize,
    titleFontSize, yearFontSize, craFooterFontSize: Integer;
  leftPos, topPos: Integer;
begin
  //20180509 subtract 1 then when it prints it addes 1 as per config
  titleFontSize     := 14-1;  //13;  // 14; //to spec but still to big?
  nameFontSize      := 12-1;   //11;  // 12; //to spec but still to big?
  yearFontSize      := 12-1;  //new

  versionFontSize   := 9-1;   //8;   // 9;   //to spec but still to big?
  pageFontSize      := 10-1;  //9;   // 10;  //to spec but still to big?
  craFooterFontSize := 12-1;  //new

  textFontSize      := 12-1; //11;  // 12;  //to spec but still to big?

  MyLabel := TvtLabel.Create(Application);

  MyLabel.Font.Name := 'Times New Roman';

  //-----------------------

  MyLabel.Caption := 'T2 BAR CODE RETURN';
  MyLabel.vtTransparent := True;
  MyLabel.Transparent := True;
  MyLabel.Font.Size := titleFontSize;
  MyLabel.Font.Style := [fsBold];
  MyLabel.Top := 15;
  MyLabel.Left := 215;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //-----------------------

  MyLabel.Caption := 'This page must be sent to the Canada Revenue Agency';
  MyLabel.Font.Style := [];
  MyLabel.Font.Size := craFooterFontSize;
  MyLabel.Top := doubleSpace * 34 + singleSpace;
  // 20150421; //doubleSpace*35 + singleSpace;//712;
  MyLabel.Left := 190;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //-----------------------

  MyLabel.Caption := 'Version ' + RsiVersion;
  MyLabel.Font.Size := versionFontSize;
  MyLabel.Top := MyLabel.Top + singleSpace;
  MyLabel.Left := 280;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //-----------------------

  MyLabel.Caption := RSIApprovalCode + ' Page ' + inttostr(PageCount) + ' of ' + inttostr(TotalPages);
  MyLabel.Font.Size := pageFontSize;
  // MyLabel.Top := 725;
  MyLabel.Left := 520;
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //-----------------------

  // name, bn tax year start/end
  leftPos := 85;

  MyLabel.Caption := 'Name: ';
  MyLabel.Top := 40;
  MyLabel.Left := leftPos; // 7;
  MyLabel.Font.Name := 'Times New Roman';
  MyLabel.Font.Size := nameFontSize;
  MyLabel.Font.Style := [fsBold];
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //-----------------------

  MyLabel.Caption := LeftStr(FetchElm(RetNo, 'T2', 3), 60);
  MyLabel.Top := MyLabel.Top;
  MyLabel.Left := MyLabel.Left + 40;
  MyLabel.Font.Name := 'Times New Roman';
  MyLabel.Font.Size := nameFontSize;
  MyLabel.Font.Style := [fsBold];
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //-----------------------

  MyLabel.Caption := LeftStr(FetchElm(RetNo, 'T2', 65), 60);
  MyLabel.Top := MyLabel.Top + 20;
  MyLabel.Left := MyLabel.Left;
  MyLabel.Font.Name := 'Times New Roman';
  MyLabel.Font.Size := nameFontSize;
  MyLabel.Font.Style := [fsBold];
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //-----------------------

  MyLabel.Caption := 'BN: ' + ReformatBN(GetValueFromForm(RetNo, 'T2', 1, 1));
  MyLabel.Top := MyLabel.Top + 20 + 10;
  MyLabel.Left := leftPos;
  MyLabel.Font.Style := [fsBold];
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //-----------------------

  MyLabel.Caption := 'Tax Year Start: ' +
    ReplaceChar(FetchElm(RetNo, 'T2', 10),'/','-')
    + ' '+FetchElm(RetNo,'T2',177) ; //20190428
   // ReplaceChar(FetchElm(RetNo, 'T2', 10), '/', '-') +RemoveChar(FetchElm(RetNo,'T2',177),':') ; //20170601
  MyLabel.Top := MyLabel.Top + 20;
  MyLabel.Left := MyLabel.Left;
  MyLabel.Font.Size := yearFontSize;
  MyLabel.Font.Style := [fsBold];
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  //-----------------------

  MyLabel.Caption := 'Tax Year End: ' +
   ReplaceChar(GetTaxationYearEnd(RetNo),'/','-')
   +' '+FetchElm(RetNo,'T2',207) ; //20190428
    //ReplaceChar(GetTaxationYearEnd(RetNo), '/', '-')+RemoveChar(FetchElm(RetNo,'T2',207),':') ; //20170601;
  MyLabel.Top := MyLabel.Top + 20;
  MyLabel.Left := MyLabel.Left;
  MyLabel.Font.Size := yearFontSize;
  MyLabel.Font.Style := [fsBold];
  PrintLabel(MyLabel, ACanvas, DefBarFontName);

  // end name, bn tax year start/end ---------------------------------------

  MyLabel.Font.Style := [];

  if (PageCount = 1) then
  begin
    MyShape := TvtShape.Create(Application);

    leftPos := 475;
    // create 055 box---------------------------------------------------------
    MyShape.Top := 40;
    MyShape.Left := leftPos;
    MyShape.Height := 91; // 71;
    MyShape.Width := 141;
    MyShape.Brush.Color := clBtnFace;
    PrintVtShape(MyShape, ACanvas);
    // MyShape.free;

    MyLabel.Caption := 'For Agency Use';
    MyLabel.Font.Size := textFontSize;
    MyLabel.Font.Style := [];
    MyLabel.Top := MyShape.Top;
    MyLabel.Left := MyShape.Left + 35; // 465;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);

    MyLabel.Caption := '[055]';
    MyLabel.Font.Size := nameFontSize;
    MyLabel.Font.Style := [fsBold];
    MyLabel.Top := MyShape.Top + 10; // 50;
    MyLabel.Left := MyShape.Left + 5; // 460;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);
    // end create 055 box-----------------------------------------------------

    // create 095 / 096 998 box---------------------------------------------------
    MyShape.Top := 151;
    MyShape.Left := leftPos;
    MyShape.Height := 75; // 55;   20150316
    MyShape.Width := 141;
    MyShape.Brush.Color := clBtnFace;
    PrintVtShape(MyShape, ACanvas);

    MyLabel.Caption := 'For Agency Use';
    MyLabel.Font.Size := textFontSize;
    MyLabel.Font.Style := [];
    MyLabel.Top := MyShape.Top; // 151;
    MyLabel.Left := MyShape.Left + 35; // 490; //465;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);

    MyLabel.Caption := '[095]';
    MyLabel.Font.Size := nameFontSize;
    MyLabel.Font.Style := [fsBold];
    MyLabel.Top := MyShape.Top + 10; // 161;
    MyLabel.Left := MyShape.Left + 5; // 460;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);

    MyLabel.Caption := '[096]';
    MyLabel.Font.Size := nameFontSize;
    MyLabel.Font.Style := [fsBold];
    MyLabel.Top := MyShape.Top + 30; // 181;
    MyLabel.Left := MyShape.Left + 5; // 460;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);

    // 20150316
    MyLabel.Caption := '[898]';
    MyLabel.Font.Size := nameFontSize;
    MyLabel.Font.Style := [fsBold];
    MyLabel.Top := MyShape.Top + 50;
    MyLabel.Left := MyShape.Left + 5;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);

    // draw line beside [095]
    MyLabel.Left := MyShape.Left + 40;
    MyLabel.Top := MyShape.Top + 10;
    MyLabel.Width := 90;
    MyLabel.vtBorderType := vtlblUnderline;
    MyLabel.AutoSize := False;
    MyLabel.Font.Style := [];
    MyLabel.Caption := '';
    PrintLabel(MyLabel, ACanvas, DefBarFontName);
    // draw line beside [096]
    MyLabel.Top := MyShape.Top + 30;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);

    // draw line beside [898]
    MyLabel.Top := MyShape.Top + 50;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);

    // end create 095 / 096  / 898 box-----------------------------------------------

    // create 032 425 N box---------------------------------------------------
    MyShape.Top := 246; // 226;  //20150315
    MyShape.Left := leftPos - 70;
    MyShape.Height := 30;
    MyShape.Width := 210;
    MyShape.Brush.Color := clBtnFace;
    PrintVtShape(MyShape, ACanvas);

    MyLabel.vtBorderType := vtlblNoBorder;
    MyLabel.Alignment := taLeftJustify;
    MyLabel.AutoSize := True;

    MyLabel.Caption := GetSpecialSchedulesString(RetNo);
    MyLabel.Font.Size := textFontSize;
    MyLabel.Font.Style := [];
    MyLabel.Top := 246; // 20150316
    MyLabel.Left := MyShape.Left + 5;
    PrintLabel(MyLabel, ACanvas, DefBarFontName);
    // create 032 425 N box---------------------------------------------------

    MyShape.Free;

  end;
  MyLabel.Free;
end;

Procedure TBarDataGenT2_2027.PrepareMoreGifiIs(RsiForm: string);
Var
  i, K: Integer;
begin
(*
  If IsFormTheIsGIFI(RsiForm) = False then
    exit;
  K := CountS125IncStatements(RetNo);   //20160503
  For i := 2 to K do
  begin
    Inst := i;
    PrepareSingleRSI(RsiForm);
  end;
*)
end;

Function TBarDataGenT2_2027.IsItAGifiForm(RsiNm: String): Boolean;
begin
  result := False;
  If (UpperCase(RsiNm) = 'SCHEDULE 100') or (UpperCase(RsiNm) = 'SCHEDULE 101')
    or (UpperCase(RsiNm) = 'SCHEDULE 125') or
    (UpperCase(RsiNm) = 'SCHEDULE 140') or (UpperCase(RsiNm) = 'SCHEDULE 141')
  then
    result := True;
end;

Procedure TBarDataGenT2_2027.CheckColumnsRSI100(MaxPerColumn: Integer;
  Var Cnt: Integer; TempSpecs: TStringList);
begin
  If Cnt > MaxPerColumn then
  begin
    If InCol = 2 then
    begin
      TempSpecs.Add('COLUMN 3     5.50    1.00');
      InCol := 3;
      Cnt := 0;
    end
    else If InCol = 1 then
    begin
      TempSpecs.Add('COLUMN 2     3.0     1.00');
      InCol := 2;
      Cnt := 0;
    end;
  end;
end;

Procedure TBarDataGenT2_2027.CheckColumnsRSI101(MaxPerColumn: Integer;
  Var Cnt: Integer; TempSpecs: TStringList);
begin
  If Cnt > MaxPerColumn then
  begin
    If InCol = 2 then
    begin
      TempSpecs.Add('COLUMN 3     6.0     1.00');
      InCol := 3;
      Cnt := 0;
    end
    else If InCol = 1 then
    begin
      TempSpecs.Add('COLUMN 2     3.0     1.00');
      InCol := 2;
      Cnt := 0;
    end;
  end;
end;

Procedure TBarDataGenT2_2027.CreateRSI100;
Var
  ArrayNo, BoxesPerRow, MaxRowsPerArray, ArrayElm: Integer;
  FormElm: Integer;
  i, j, FNo: Integer;
  FName, Ln, Value: String;
  TempSpecs: TStringList;
begin
  // 20160402 Replaced fully due to change of Gifi100 from old GIfi form to new dynamic form
  TempSpecs := TStringList.Create;
  TempSpecs.Add('Schedule 100 GIFI-(Closing) Balance Sheet');
  FName := 'S100';
  FNo := GetFormNo(FName);
  For ArrayNo:=1 to 8 do
  Begin
   BoxesPerRow := 4;
   MaxRowsPerArray := DynamicRowCount(RetNo, FNo, ArrayNo); //80; //20160430 Igor//MaxRowsPerArray := 80;
   ArrayElm := ArrayNo * 10000 + StrToInt('1');
   For i := 0 to MaxRowsPerArray do
   begin
     Ln := AllTrim(FetchElmFNo(RetNo, FNo, ArrayElm + 1));
     FormElm := ArrayElm+2; //FetchElmFNo(RetNo, FNo, ArrayElm + 2); //
     Value:=FetchElmFNo(RetNo, FNo, ArrayElm + 2); //
     if ((Value > '') and (Ln > '')) or (IsBsLineMandatory(Ln)) then
        TempSpecs.Add(MkRsiAmountRec(RetNo, Ln, FName, FNo,FormElm));
     ArrayElm := ArrayElm + BoxesPerRow;
   end;  //i
  End;  //arrayno

  //add in between the fixed elements of each array
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,10), FName, FNo,11));    //curr assets
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,13), FName, FNo,14)); //tang assets
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,16), FName, FNo,17)); //Accum amoort tang assets
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,19), FName, FNo,20)); //intang assets
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,25), FName, FNo,26)); //Accum amort int
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,22), FName, FNo,23)); //long term
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,46), FName, FNo,47)); //i trust
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,88), FName, FNo,89)); //Tot assets
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,31), FName, FNo,32)); //Tot curr liab
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,4), FName, FNo,5)); //long term liab
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,56), FName, FNo,57)); //in trust
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,7), FName, FNo,8)); //tot Liab
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,28), FName, FNo,29)); //comm sh
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,34), FName, FNo,35)); //Ret earn
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,37), FName, FNo,38)); //Tot equ
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,40), FName, FNo,41)); //Tot equ
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,43), FName, FNo,44)); //3660
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,50), FName, FNo,51)); //Tot equ
      TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,53), FName, FNo,54)); //Tot ret earnings

  {
  ArrayNo := 1;  //description
  BoxesPerRow := 4;
  MaxRowsPerArray := 80;
  ArrayElm := ArrayNo * 10000 + StrToInt('1');
  For i := 0 to MaxRowsPerArray do
  begin
    Ln := AllTrim(FetchElmFNo(RetNo, FNo, ArrayElm + 1));
    FormElm := IntToStr(ArrayElm+2); //FetchElmFNo(RetNo, FNo, ArrayElm + 2); //
    Value:=FetchElmFNo(RetNo, FNo, ArrayElm + 2); //
    if ((Value > '') and (Ln > '')) or (IsBsLineMandatory(Ln)) then
    begin
      TempSpecs.Add(MkDynamicRsiAmountRec(RetNo, Ln, FName, FNo,FormElm));
    end;
    ArrayElm := ArrayElm + BoxesPerRow;
  End;
}
  TempSpecs.Add('FOOTER');
  TempSpecs.Add('SEND');
  TempSpecs.Add('RSIEND');
  TempSpecs.SaveToFile(AppDir + '\' + 'RSI100.d');
  TempSpecs.Free;
end;


//20160402
Procedure TBarDataGenT2_2027.CreateRSI101;
Var
  ArrayNo, BoxesPerRow, MaxRowsPerArray, ArrayElm: Integer;
  FormElm: Integer;
  i, j, FNo:Integer;
  FName, Ln, Value: String;
  TempSpecs: TStringList;
begin
  TempSpecs := TStringList.Create;
  TempSpecs.Add('Schedule 101 GIFI-(Opening) Balance Sheet');
  FName := 'S101';
  FNo := GetFormNo(FName);

  For ArrayNo:=1 to 8 do
  Begin
   BoxesPerRow := 4;
   MaxRowsPerArray := DynamicRowCount(RetNo, FNo, ArrayNo); //80; //20160430 Igor//MaxRowsPerArray := 80;
   ArrayElm := ArrayNo * 10000 + StrToInt('1');
   For i := 0 to MaxRowsPerArray do
   begin
     Ln := AllTrim(FetchElmFNo(RetNo, FNo, ArrayElm + 1));
     FormElm := ArrayElm+2;
     Value:=FetchElmFNo(RetNo, FNo, ArrayElm + 2); //
     if ((Value > '') and (Ln > '')) or (IsBsLineMandatory(Ln)) then
        TempSpecs.Add(MkRsiAmountRec(RetNo, Ln, FName, FNo,FormElm));
     ArrayElm := ArrayElm + BoxesPerRow;
   end;
  End; //arrayno

   //add in between the fixed elements of each array
  For ArrayNo:=1 to 8 do
  Begin
   case ArrayNo of
      1: TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,10), FName, FNo,11));    //curr assets
      2: TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,13), FName, FNo,14)); //tang assets
      3: TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,19), FName, FNo,20)); //intang assets
      4: TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,88), FName, FNo,89)); //long term
      //liabilities
      5: TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,31), FName, FNo,32)); //curr liab
      6: begin
          TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,4), FName, FNo,5)); //Tot liab
          TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,7), FName, FNo,8)); //Tot liab
         end;
      7: Begin   //equity         begin
          TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,28), FName, FNo,29)); //comm shares
          TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,34), FName, FNo,35)); //ret ernings
          TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,37), FName, FNo,38)); //tot equity
          TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,40), FName, FNo,41)); //Tot liab +equity
          TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,43), FName, FNo,44)); //3660   //20170601
         end;
      8: TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,53), FName, FNo,54)); //long term
   End;  //case
  End;  //arrayno

  TempSpecs.Add('FOOTER');
  TempSpecs.Add('SEND');
  TempSpecs.Add('RSIEND');
  TempSpecs.SaveToFile(AppDir + '\' + 'RSI101.d');
  TempSpecs.Free;
End;



Procedure TBarDataGenT2_2027.CheckColumnsRSI125(MaxPerColumn: Integer;
  Var Cnt: Integer; TempSpecs: TStringList);
begin
  If Cnt >= MaxPerColumn then
  begin
    If InCol = 2 then
    begin
      TempSpecs.Add('COLUMN 3     5.45    2.78');
      InCol := 3;
      Cnt := 0;
    end
    else If InCol = 1 then
    begin
      TempSpecs.Add('COLUMN 2     3.0     2.78');
      InCol := 2;
      Cnt := 0;
    end;
  end;
end;

Procedure TBarDataGenT2_2027.CreateRSI125;
Var
  ArrayNo, BoxesPerRow, MaxRowsPerArray, ArrayElm: Integer;
  FormElm: Integer;
  i, j, FNo: Integer;
  FName, Ln, Value: String;
  TempSpecs: TStringList;
begin
  // 20160402 Replaced fully due to change of Gifi125 from old GIfi form to new dynamic form
  TempSpecs := TStringList.Create;
  TempSpecs.Add('Schedule 125 GIFI- Income Statement');
  FName := 'S125#1';
  FNo := GetFormNo(FName);
  For ArrayNo:=1 to 6 do
  Begin  //description
   BoxesPerRow := 4;
   MaxRowsPerArray := DynamicRowCount(RetNo, FNo, ArrayNo); //80; //20160430 IgorMaxRowsPerArray := 80;
   ArrayElm := ArrayNo * 10000 + StrToInt('1');
   For i := 0 to MaxRowsPerArray do
   begin
     Ln := AllTrim(FetchElmFNo(RetNo, FNo, ArrayElm + 1));
     FormElm := ArrayElm+2;
     Value:=FetchElmFNo(RetNo, FNo, ArrayElm + 2); //
     if ((Value > '') and (Ln > '')) or (IsIsLineMandatory(Ln)) then
        TempSpecs.Add(MkRsiAmountRec(RetNo, Ln, FName, FNo,FormElm));
     ArrayElm := ArrayElm + BoxesPerRow;
   end;
  end;  //arrayno

  //add in between the fixed elements of each array
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,10), FName, FNo,11));    //revenue//4TempSpecs.Add(MkRsiAmountRec(RetNo,'8089',FName,FNo));   //20160512
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,13), FName, FNo,14)); //Sales of goods
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,16), FName, FNo,17)); //cost of sales
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,19), FName, FNo,20)); //gross profit
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,25), FName, FNo,26)); //Tot opr expenses
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,22), FName, FNo,23)); //Tot expenses
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,88), FName, FNo,89)); //Net non-farm income
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,28), FName, FNo,29)); //Tot farm revenue
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,31), FName, FNo,32)); //Tot farm exp
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,34), FName, FNo,35)); //Tot liab

  // other fixed comprehensive and Summary fields
  TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,37), FName, FNo,38)); //Net inc/loss bfr expta items
  i:=40; J:=41;
  Repeat
   TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,i), FName, FNo,j));
   Inc(i,3);
   Inc(j,3);
  until i>82;
  TempSpecs.Add(MkRsiAmountRec(RetNo, FetchElmFNo(RetNo,FNo,7), FName, FNo,8)); //Net inc/loss after extra items

  TempSpecs.Add('FOOTER');
  TempSpecs.Add('SEND');
  TempSpecs.Add('RSIEND');
  TempSpecs.SaveToFile(AppDir + '\' + 'RSI125.d');
  TempSpecs.Free;
End;


Function TBarDataGenT2_2027.ReformatPhoneNo(s: String): String;
begin
  result := ReplaceChar(s, ' ', '');
  result := ReplaceChar(result, '-', '');
  result := AllTrim(result);
end;

Function TBarDataGenT2_2027.ReformatSIN(s: String): String;
begin
  result := ReplaceChar(s, '-', '');
  result := AllTrim(ReplaceChar(s, ' ', ''));
  result := AllTrim(result);
end;

Function TBarDataGenT2_2027.ReformatPostal(s: String): String;
begin
  result := ReplaceChar(s, ' ', '');
end;

Function TBarDataGenT2_2027.GetMaxColumns(s: String): Integer;
begin
  result := MyStrToInt(AllTrim(MidStr(s, 14, 3)));
end;

Function TBarDataGenT2_2027.DateForRSIPage5(s: String): String;
Var
  yyyy, mm, dd: String;
begin
  If FillSignatureDates = True then
  begin
    yyyy := LeftStr(s, 4);
    mm := GetFullMonth(MidStr(s, 6, 2));
    dd := RightStr(s, 2);
    result := mm + ' ' + dd + ', ' + yyyy;
  end;
end;

Function TBarDataGenT2_2027.GetSpecialSchedulesString(RetNo: Integer): String;
Var
  s: String;
begin
  s := '';
  If IsAmendedReturn(RetNo) then
    s := s + 'A ';
  If IsNonResidentCorp(RetNo) then
    s := s + 'N ';
  If FetchElm(RetNo, 'T2', 72) > '' then
    s := s + 'FC '; // 20151012
  If (Ret[RetNo].FrmHasData[GetFormNo('S30#1')])
  // Or (Ret[RetNo].FrmHasData[GetFormNo('S30#2')])  //20130925
  // Or (Ret[RetNo].FrmHasData[GetFormNo('S30#3')])
  then
    s := s + '030 ';

  If ((vl(FetchElm(RetNo, 'S31', 503)) > 0) Or
    (vl(FetchElm(RetNo, 'S31', 508)) > 0) or (vl(FetchElm(RetNo, 'S31', 515)) >
    0) or (vl(FetchElm(RetNo, 'S31', 528)) > 0)) then
    s := s + '031 ';

  If (vl(FetchElm(RetNo, 'S31', 501)) <> 0) // ln 420
    Or (vl(FetchElm(RetNo, 'S31', 506)) <> 0) // ln 440
    Or (vl(FetchElm(RetNo, 'S31', 511)) <> 0) // ln 460
    Or (vl(FetchElm(RetNo, 'S31', 538)) <> 0) // ln 538
  then
    s := s + '031R ';

  If Ret[RetNo].FrmHasData[GetFormNo('T661')] then
    s := s + '032 ';

  If Ret[RetNo].FrmHasData[GetFormNo('T1131#1')] then
    s := s + '047 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S48#1')] then
    s := s + '048 ';

  If Ret[RetNo].FrmHasData[GetFormNo('S60#1')] then
    s := s + '060 ';
  // If Ret[RetNo].FrmHasData[GetFormNo('S382#1')]       then s := s+'382 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S388#1')] then
    s := s + '388 ';
  {//20170525
  If Ret[RetNo].FrmHasData[GetFormNo('S410')] then
    s := s + '410 ';
  }
  If (Ret[RetNo].FrmHasData[GetFormNo('S421')]) then
    s := s + '421 ';
  // Or (Ret[RetNo].FrmHasData[GetFormNo('S421_2')])

  If (Ret[RetNo].FrmHasData[GetFormNo('S422#1')]) then
    s := s + '422 ';

  If (Ret[RetNo].FrmHasData[GetFormNo('S423#1')]) then
    s := s + '423 ';

  If Ret[RetNo].FrmHasData[GetFormNo('S425')] then
    s := s + '425 ';

  If Ret[RetNo].FrmHasData[GetFormNo('S429')] then
    s := s + '429 '; // 20110427

  If Ret[RetNo].FrmHasData[GetFormNo('S508')] then
    s := s + '508 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S554#1')] then
    s := s + '554 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S556#1')] then
    s := s + '556 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S558#1')] then
    s := s + '558 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S560#1')] then
    s := s + '560 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S562#1')] then
    s := s + '562 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S564#1')] then
    s := s + '564 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S566')] then
    s := s + '566 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S568')] then
    s := s + '568 ';
  If Ret[RetNo].FrmHasData[GetFormNo('S569#1')] then
    s := s + '569 ';
  // If IsNonResidentCorp(RetNo)                            then s := s+'N ';
  result := s;

end;

Function TBarDataGenT2_2027.ReformatTrustNo(s: String): String;
begin
  result := s;
end;

Function TBarDataGenT2_2027.ReformatBNForBarCode(bn: String): String;
Var
  s: String;
begin
  result := UpperCase(bn);
  If Length(result) <> 15 then
    exit;
end;

procedure TBarDataGenT2_2027.ShowBarCodeDataBtnClick(Sender: TObject);
begin
  if FileExists(AppDir + '\' + 'Bardata.txt') then
   PopSomeFile(AppDir + '\' + 'Bardata.txt','Efile data',false)  //201711905   //sort=false
  else
    ShowMessage('Bardata was not created. Contact vendor');

end;

Procedure TBarDataGenT2_2027.PrepareAddressLoop(RetNo: Integer; FName: String;
  j: Integer; Valu: String; ScheduleId: String; ToElm: Integer; K: Integer;
  MaxLoopCounter: Integer; LineNo: String);
Var
  FullAddress: String;
  Ln: string;
begin
  If InFormsWithSpecialAddress(FName) then
  begin
    FullAddress := GetSpecialAddressValu(RetNo, FName, j, Valu); // 20081203
    PrepareAnElement(ScheduleId, FName, LineNo, FullAddress, inttostr(K));
    exit;
  end;
end;

Function TBarDataGenT2_2027.GetSkipIndicator(RetNo: Integer; FName: String;
  LineNo: String): Boolean;
begin
  result := False;

  If FName = 'S6RE' then
  begin
    If (LineNo = '200') and (FetchElm(RetNo, 'S6RE', 1) = '') then
      result := True;
  end;

  If FName = 'S15' then
  begin
    If (LineNo = '500') and (FetchElm(RetNo, 'S15', 8) = '') then
      result := True;
  end;
end;

Function TBarDataGenT2_2027.SkipThisOne(RetNo: Integer; FName: String;
  ElmNo: Integer; Valu: String): Boolean;
Var
  K: Integer;
begin
  result := False;

  If ExtractNonInstFormName(FName) = 'S14' then // bypass the remaining address
  begin
    K := 6;
    Repeat
      If (ElmNo = K) or (ElmNo = K + 1) or (ElmNo = K + 2) or (ElmNo = K + 3) or
        (ElmNo = K + 4) then
      begin
        result := True;
        exit;
      end;
      Inc(K, 12);
    until K > 114;
  end;

  If ExtractNonInstFormName(FName) = 'S15' then
  begin
    K := 9;
    Repeat
      If (ElmNo = K) or (ElmNo = K + 1) or (ElmNo = K + 2) or (ElmNo = K + 3) or
        (ElmNo = K + 4) then
      begin
        result := True;
        exit;
      end;
      Inc(K, 10);
    until K > 149; // 59;
  end;

  If ExtractNonInstFormName(FName) = 'S22' then
  begin
    K := 6;
    Repeat
      If (ElmNo = K) or (ElmNo = K + 1) or (ElmNo = K + 2) or (ElmNo = K + 3) or
        (ElmNo = K + 4) then
      begin
        result := True;
        exit;
      end;
      Inc(K, 7);
    until K > 55;
  end;

  If ExtractNonInstFormName(FName) = 'S29' then
  begin
    K := 6;
    Repeat
      If (ElmNo = K) or (ElmNo = K + 1) or (ElmNo = K + 2) or (ElmNo = K + 3) or
        (ElmNo = K + 4) then
      begin
        result := True;
        exit;
      end;
      Inc(K, 8);
    until K > 78;
  end;

  If LeftStr(FName, 4) = 'S30#' then
  begin
    Case ElmNo of
      16, 17, 20, 21, 24, 25, 26:
        If Valu = '' then
          result := True;
      32, 33, 34, 35, 18:
        result := True;
    end; // case
  end;
end;


Procedure TBarDataGenT2_2027.PrepareAmendedNotes(RetNo: Integer);
begin
  If IsAmendedReturn(RetNo) = False then
    exit;

end;

procedure TBarDataGenT2_2027.CheckSecurity(Sender: TObject);
begin
  Application.CreateForm(TEFSECURET2_2027, EFSECURET2_2027);
  EFSECURET2_2027.ShowModal;
  EFSECURET2_2027.Free;
end;

// ______________________________________________________________________________
// WEBSERVICES BEGIN
// ------------------------------------------------------------------------------

procedure TBarDataGenT2_2027.WebServiceEfileBtnClick(Sender: TObject);
Var
  s:String;
  Flags: OLEVariant; // 20150311
begin
  Efiling:=True; //20160605
  If InvalidCharactersList.Count > 0 then
  begin
  end;

  S88Cnt := 0; // 20141011

  CheckSecurity(Sender);
  If AcceptedSecurity = False then
    exit;

  GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  {//20260612cz

  If ((UpperCase(OnLineNo)='B0864') Or (UpperCase(OnLineNo)='B0865')) then
  Begin
   s:=UpperCase(InputBox('Your Efiler Number is invalid', 'PSW', ''));
   If UpperCase(s)='N/A'  //20190226
   then
   //ok
   Else
    OnlineNo:=''
  end;
  } //jz- there was a ')' here, must be a mistake? made it a '}' to close the comment

  //20180301
  if (OnlineNo='') and (FetchElm(RetNo,'T2',75)='') then //Efiler / wac both empty
  Begin
   ShowMessage('Efiler Number or WAC is required');
   exit;
  End;


  If DirectoryExists(NetFileDir) = False then
  begin
    ShowMessage('You need to Set up Internet Filing first' + Chr(13) +
      'Click on Fed-EFile | Set Up Internet Filing');
    exit;
  end;

  If GetEFileConfirmationNo(RetNo) > '' then
  begin
    ShowMessage('You cannot Efile again.' + Chr(13) +
      ' Return has been already Efiled and accepted by CRA');
    OpenForm(RetNo, GetFormNo('T183CP'), 21); // 20130530
    exit;
  end;
  WebServiceEfile();
  AddLogAppMon(amtOnEfile, RetNo); // 20180722 Igor //20220519 Igor
end;

procedure TBarDataGenT2_2027.WebServiceEfile();
var
  SoapMsg: String;
  multiPartName, submissionDateTimeStamp: string;
begin
  Efiling := True; // not sure why necessary, probably should be changed???
  if CanEfileValidation then
  begin
    // _Part_1_29346106.1340295591232
    submissionDateTimeStamp := FormatDateTime('ddmmyyyyhhnnsszzz', now);
    multiPartName := '_multiPart_' + GetNineDigitAccountNumber(RetNo) + '.' +
      submissionDateTimeStamp;

    CreateSoapMessage(SoapMsg, multiPartName);
    SubmitSoapMsg(SoapMsg, multiPartName);
  end;
end;

Procedure TBarDataGenT2_2027.SubmitSoapMsg(SoapMsg: String;
  multiPartName: String);
Var
  objHttp: ixmlHttpRequest;
  WString: String; // wide string
  ResponseXmlFile: String;
  AList: TStringList;

  webServiceUserName, webServicePassword: String;
begin

  // define
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;

  setwebServiceUserNamePassword(webServiceUserName, webServicePassword);

  objHttp.open('POST', sURL, False, webServiceUserName, webServicePassword);

  objHttp.setRequestHeader('soapAction', 'cannotBeBlank');
  // set action, cannot be blank

  objHttp.setRequestHeader('Content-Type', 'multipart/related; boundary="=' +
    multiPartName + '"; type="text/xml"');

  // transmit it now
  Screen.Cursor := crHourGlass;
  objHttp.send(SoapMsg);

  Screen.Cursor := crDefault;
  delay(2000);
  Screen.Cursor := crDefault;
  WString := objHttp.ResponseText;

  // delay(500); //just in case??

  parseXmlResponse(WString);

  // testing------------------------------------------------------------------
  // if testingIndicator.visible then  //20130620
  // begin

  ResponseXmlFile := MkWebEFileResponseName(RetNo); //20170626
  // Now save the WString
  AList := TStringList.Create;
  AList.Add(WString);
  AList.SaveToFile(ResponseXmlFile);
  AList.Free;
end;

Procedure TBarDataGenT2_2027.parseXmlResponse(rString: string);
var
  sPos, ePos, i: Integer;
  s, e, fCode, fString, messageString: String;
  ConfirmFNo: Integer; // form no
  TimeStamp: String; // 20130622
begin
  // server error -------------------------------------------------------------
  s := '<faultcode>';
  sPos := ansiPos(s, rString); // j - change pos to ansiPos 20130620
  if sPos > 0 then
  begin
    e := '</faultcode>';
    sPos := ansiPos(s, rString) + Length(s);
    ePos := ansiPos(e, rString);
    fCode := AllTrimAnsi(midAnsiStr(rString, sPos, ePos - sPos));

    s := '<faultstring>';
    e := '</faultstring>';
    sPos := ansiPos(s, rString) + Length(s);
    ePos := ansiPos(e, rString);
    fString := AllTrimAnsi(midAnsiStr(rString, sPos, ePos - sPos));

    messageString := 'Error Code: ' + fCode + Chr(10) + Chr(13) + fString;
    MessageDlg(messageString, mtError, [mbOK], 0);
    exit;
  end;

  // file error ---------------------------------------------------------------
  s := '<tgif:ErrorCode>';
  sPos := ansiPos(s, rString);
  if sPos > 0 then
  begin
    e := '</tgif:ErrorCode>';
    sPos := ansiPos(s, rString) + Length(s);
    ePos := ansiPos(e, rString);
    fCode := AllTrimAnsi(midAnsiStr(rString, sPos, ePos - sPos));

    s := '<tgif:EnglishMessageText xml:lang="en">';
    e := '</tgif:EnglishMessageText>';
    sPos := ansiPos(s, rString) + Length(s);
    ePos := ansiPos(e, rString);
    fString := AllTrimAnsi(midAnsiStr(rString, sPos, ePos - sPos));

    messageString := 'Error Code: ' + fCode + Chr(10) + Chr(13) + fString;
    MessageDlg(messageString, mtError, [mbOK], 0);
    exit;
  end;

  // success ------------------------------------------------------------------
  s := '<tgif:ConfirmationNumber>';
  sPos := ansiPos(s, rString);
  if sPos > 0 then
  begin
    e := '</tgif:ConfirmationNumber>';
    sPos := ansiPos(s, rString) + Length(s);
    ePos := ansiPos(e, rString);
    fCode := AllTrimAnsi(midAnsiStr(rString, sPos, ePos - sPos));
    s := '<tgif:TimestampDateTime>';
    e := '</tgif:TimestampDateTime>';
    sPos := ansiPos(s, rString) + Length(s);
    ePos := ansiPos(e, rString);
    fString := AllTrimAnsi(midAnsiStr(rString, sPos, ePos - sPos));

    StoreElm(RetNo, GetFormNo('T183CP'), 21, fCode);
    // save confirmation number to T183cp

    // complete the EFConfirm form
    ConfirmFNo := GetFormNo('EFCONFIRM');
    // StoreElm(RetNo,ConfirmFNo,4,fCode);   //done in calc from T183CP  //20130622
    // 20130622
    TimeStamp := LeftStr(fString, 10) + '  ' + MidStr(fString, 11, 20);
    StoreElm(RetNo, ConfirmFNo, 5, TimeStamp);
    // save info to STATUS
    StoreElm(RetNo, GetFormNo('STATUS'), 24, fCode);
    // save confirmation number //j - correct field id 20130620
    StoreElm(RetNo, GetFormNo('STATUS'), 4, '09');
    // set return as efile accepted
    StoreElm(RetNo, GetFormNo('STATUS'), 28, TimeStamp); // 20130622

    Ret[RetNo].PrpStatus := '09'; // set return as efile accepted

    Calc(RetNo, 'EFCONFIRM'); // 20130622

    SaveReturn(RetNo, Ret[RetNo].SourceDataDir, Ret[RetNo].SourceFlName, True,
      True); // Save return, true = no prompt
    LockReturn(RetNo);

    messageString := GetNineDigitAccountNumber(RetNo) + ' ' + GetCorpName(RetNo)
      + Chr(10) + Chr(13) + Chr(10) + Chr(13) + 'Efile Submitted Successfully '
      + Chr(10) + Chr(13) + 'Confirmation Number: ' + fCode + Chr(10) + Chr(13)
      + 'Time Stamp: ' + fString + Chr(10) + Chr(13) + Chr(10) + Chr(13) +
    // j - add time stamp to message 20130620
      'Return has been saved and locked.';;

    OpenForm(RetNo, GetFormNo('EFCONFIRM'), 21); // 20130530

    ShowMessage(messageString);

    exit;
  end;
end;

function TBarDataGenT2_2027.CanEfileValidation: Boolean;
begin
  result := False;

  If ValidT2Date(FetchElm(RetNo, 'T2', 745)) = False then
  begin
    ShowMessage('Invalid signature date. Enter as yyyy/mm/dd and press Enter');
    OpenForm(RetNo, GetFormNo('T2'), 745);
    CancelBtnClick(nil); //20220526 Igor //BarDataGen.CancelBtnClick(nil);
    exit;
  end;

  (* 20140415
    If IsAmendedReturn(RetNo) then
    begin
    ShowMessage('You cannot efile an amended return. You must submit paper based BarCoded return');
    OpenForm(RetNo,GetFormNo('AMEND'),4);
      CancelBtnClick(nil); //20220526 Igor //BarDataGen.CancelBtnClick(nil);
    Exit;
    end;
  *)

  If Ret[RetNo].SeriousErrorCount > 0 then
  begin
    ShowMessage
      ('Errors (E-items of Audit Wizard) must be corrected before Efiling the return');
     CancelBtnClick(nil); //20220526 Igor //BarDataGen.CancelBtnClick(nil);   //CAUSES ERROR?
   // exit;  //20220923
  end;

  If Ret[RetNo].EfileErrorCount > 0 then
  begin
    ShowMessage
      ('Errors (F-items of Audit Wizard) must be corrected before Efiling the return');
     CancelBtnClick(nil);   //CAUSES ERROR? //20220526 Igor //BarDataGen.CancelBtnClick(nil);
    // exit;  //20220923
  end;

  // If (LicenseLevel = 'T2 Standard') then
  if LicenseLevel = llStd then
  begin
    ShowMessage('Efile is not available in the T2 Standard version');
    CancelBtnClick(nil);
    exit;
  end;

  if LicenseLevel = llDemo then
  begin
    ShowMessage('EFile not included in the demo version');
      CancelBtnClick(nil); //20220526 Igor //BarDataGen.CancelBtnClick(nil);
    exit;
  end;

  If (OptRec.Prp_Name = '') or (OptRec.Prp_Street = '') then
  begin
    ShowMessage
      ('Please complete the Preparer info in Configure -> General Options -> Preparer');
     CancelBtnClick(nil); //20220526 Igor //BarDataGen.CancelBtnClick(nil);
    exit;
  end;

  GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  If (NetFileDir = '') or (Url = '') then
  begin
    ShowMessage('You need to Set up Internet Filing first' + Chr(13) +
      'Click on Fed-EFile | Set Up Internet Filing');
     CancelBtnClick(nil); //20220526 Igor //BarDataGen.CancelBtnClick(nil);
    exit;
  end;

  // 20130530
  If (GetWACNumber(RetNo) = '') and (OnlineNo = '') then
  begin
    ShowMessage('Please complete the Fed-EFile | Set-up Internet Filing' +
      Chr(13) + 'OR enter the WAC number (on page 1 of the T2 jacket)');
     CancelBtnClick(nil); //20220526 Igor //BarDataGen.CancelBtnClick(nil);
    exit;
  end;

  If IsEFiled(RetNo) = False then
  begin
    // 20130525
    ShowMessage('Please indicate that Return is Efiled (on form T2)' + Chr(13) +
      ' and Print the T183CORP');
    OpenForm(RetNo, GetFormNo('T2'), 76);
    CancelBtnClick(nil); //20220526 Igor //BarDataGen.CancelBtnClick(nil);
    exit;
  end;

  If CanItBeEfiled(RetNo) = False then
  begin
    ShowMessage('You cannot EFile this return' + Chr(13) +
      'See Audit Wizard Efile Diagnostics');
    CancelBtnClick(nil); //20220526 Igor //BarDataGen.CancelBtnClick(nil);
    exit;
  end;

  If IsAuthorizedPreparer = False then  //20190226
    exit;
  // --------------------- passed validations

  result := True;

end;

procedure TBarDataGenT2_2027.CreateSoapMessage(var SoapMsg: String;
  multiPartName: String);
Var
  i: Integer;
  Valu, ThirdPartyIndicator: String;
  RsiForm: String[13];
  F1: TextFile;

  SoapEnvelop, CorData: String;

begin

  SoapEnvelop := CreateSoapEnvelope();

  CorData := CreateSoapContent();

  SoapMsg := combineSoapEnvelopeContent(SoapEnvelop, CorData, multiPartName);

  // testing------------------------------------------------------------------
  // if testingIndicator.visible then   //20130620
  // begin
  AssignFile(F1, MkWebEfileName(RetNo));
 // AssignFile(F1, NetFileDir + '\' + 'lastWebServiceInfoSent.xml');

  Rewrite(F1);
  For i := 1 to Length(SoapMsg) do
    Write(F1, SoapMsg[i]);
  CloseFile(F1);
  // end;
end;

procedure TBarDataGenT2_2027.setwebServiceUserNamePassword
  (var webServiceUserName: string; var webServicePassword: string);
var
  wacNumber: String;
begin
  // 20130527
  wacNumber := GetWACNumber(RetNo);
  if wacNumber > '' then
  begin
    webServiceUserName := wacNumber;
    webServicePassword := '';
  end
  else
  begin
    GetEOLParms(OnlineNo, Password, Url, NetFileDir);
    webServiceUserName := OnlineNo;
    webServicePassword := Password;
  end;

end;

Function TBarDataGenT2_2027.CreateSoapEnvelope(): string;
Var
  i: Integer;
  TempSoapList: TStringList;
  s: string;
  webServiceUserName, webServicePassword: String;
begin

  setwebServiceUserNamePassword(webServiceUserName, webServicePassword);

  TempSoapList := TStringList.Create;
  With TempSoapList do
  begin
    // empty soap envelope
    Add('<?xml version="1.0" encoding="ISO-8859-1"?>');
    Add('<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">');
    Add('<soap-env:Header>');

    Add('<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">');
    Add('<wsse:UsernameToken>');

    Add('<wsse:Username>' + webServiceUserName + '</wsse:Username>');
    Add('<wsse:Password>' + webServicePassword + '</wsse:Password>');

    Add('</wsse:UsernameToken>');
    Add('</wsse:Security>');
    Add('</soap-env:Header>');
    Add('<soap-env:Body>');
    Add('<tgif:fileReturn xmlns:tgif="http://www.cra-arc.gc.ca/xmlns/tgif">');
    Add('</tgif:fileReturn>');
    Add('</soap-env:Body>');
    Add('</soap-env:Envelope>');
  end;

  s := '';
  for i := 0 to TempSoapList.Count - 1 do
    s := s + TempSoapList[i];

  TempSoapList.Free;
  result := s;

end;

Function TBarDataGenT2_2027.combineSoapEnvelopeContent(SoapE: String;
  CorData: String; multiPartName: String): string;
var
  multiPartPrefix: string;
  multiPartMessage: string;
begin
  multiPartPrefix :=
  // '--=_Part_1_29346106.1340295591232'            + char(13) + char(10) +
    '--=' + multiPartName + Char(13) + Char(10) + 'Content-Type:text/xml;' +
    Char(13) + Char(10) + Char(13) + Char(10);

  multiPartMessage := Char(13) + Char(10) +
  // '--=_Part_1_29346106.1340295591232'            + char(13) + char(10) +
    '--=' + multiPartName + Char(13) + Char(10) + 'Content-Type:text/xml;' +
    Char(13) + Char(10) + Char(13) + Char(10) +

    CorData + Char(13) + Char(10) +

    '--=' + multiPartName + '--' + Char(13) + Char(10);
  // '--=_Part_1_29346106.1340295591232--'          + char(13) + char(10);

  result := multiPartPrefix + SoapE + multiPartMessage;

end;

Function TBarDataGenT2_2027.CreateSoapContent(): string;
var
  i, K, j, jj: Integer;
  TotalRsiWithData: Integer;
  RsiForm: String;
begin
  Screen.Cursor := crHourGlass;
  OutfileList:=TstringList.Create; //20220927 otherwise the clear below fails TEMP
  OutFileList.Clear;
  RsiFrmList.ItemIndex := 0;
  Inst := 1;
  TotalRsiWithData := 1;
  SetLength(BarDataArray, TotalRsiWithData);
  BarDataArray[TotalRsiWithData - 1] := '';

  For i := 0 to RsiFrmList.Items.Count - 1 do
  begin
    Inst := 1; // 2008/11/11
    RsiForm := AllTrim(LeftStr(RsiFrmList.Items[i], 13));

    If RsiHasData(RetNo, RsiForm) then
    begin
      PrepareSingleRSI(RsiForm);

      If IsFormTheIsGIFI(RsiForm) = True then
      begin
        PrepareMoreGifiIs(RsiForm);
        Inst := 1;
      end;

      K := GetMultipleRSICount(RetNo, RsiForm);
      jj := 2;
      For j := jj to K do
      begin
        Inst := j;
        PrepareSingleRSI(RsiForm);
      end;
      // put all data onto one string in first array location (array not really necessary)
      BarDataArray[TotalRsiWithData - 1] := BarDataArray[TotalRsiWithData - 1]
        + bardata;
    end; // end of schedule has data
  end; // end for loop
  bardata := bardata + 'EOD' + RecordDelim;

  result := bardata;
end;

Function TBarDataGenT2_2027.ReplacePredefinedXMLEntities(info: String): String;
Begin
  info := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');
  info := ReplaceChar(info, '''', '&apos;');  //20160515
  result := info;

End;

procedure TBarDataGenT2_2027.corFileClickLblClick(Sender: TObject);
var
  i: Integer;
  F1: TextFile;
  fileNamePath: string;
  CorData: string;
begin
  Efiling := True; // 20130106
  CorData := CreateSoapContent();

  fileNamePath := MkCorEFileName(RetNo);

  if DirectoryExists(ExtractFilePath(fileNamePath)) then
  begin
    AssignFile(F1, fileNamePath);

    Rewrite(F1);
    For i := 1 to Length(CorData) do
      Write(F1, CorData[i]);
    CloseFile(F1);

    ShowMessage('cor file created: ' + fileNamePath);
  end
  else
    showmessage('File Name Path: '+ fileNamePath + ' does not exist, see internet filing set up')
end;

// ______________________________________________________________________________
// WEBSERVICES END
// ------------------------------------------------------------------------------

procedure TBarDataGenT2_2027.BitBtn5Click(Sender: TObject);
Var
  Url: String;
  h: Thandle;
begin
  Url := 'http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor := crHourGlass;
  h := ShellExecute(self.Handle, 'open', Pchar('' + Url), Nil, Nil, Sw_Show);
  If h <= 32 then
    ShowMessage('Connection failed');
  Screen.Cursor := crDefault;
end;

// 20160401
Procedure TBarDataGenT2_2027.GetGifiLinesList(FormName: String;
  ExplodedList: TStringList);
Begin
  if (FormName = 'S100') or (FormName = 'S101') then
  begin
    ExplodedList.LoadFromFile(AppDir + '\' + 'GIFIBS.d');
  end

  Else if FormName = 'S101' then
  begin

  end

  Else if LeftStr(FormName, 4) = 'S125' then
  begin

  end;
End;


//20221008
procedure DrawQRCode(AData: string; ACanvas: TCanvas; ARect: TRect); //20180307 Igor
var
  QRCode: TDelphiZXingQRCode;    //WHERE IS THIS?  CON
  QRCodeBitmap, ScaleBitmap: TBitmap;
  Row, Column: Integer;
  Scale: Double;
  Width, Height: integer;
begin
  QRCode := TDelphiZXingQRCode.Create;
  QRCodeBitmap := TBitmap.Create;
  ScaleBitmap := TBitmap.Create;
  try
    QRCode.Data := AData;
    QRCode.Encoding := qrISO88591;
    QRCode.QuietZone := 2;
    QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
        end else
        begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;

    if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then
    begin
      Width := ARect.Right - ARect.Left;
      Height := ARect.Bottom - ARect.Top;
      if (Width < Height) then
      begin
        Scale := Width / QRCodeBitmap.Width;
      end else
      begin
        Scale := Height / QRCodeBitmap.Height;
      end;
      ScaleBitmap.Width := Width;
      ScaleBitmap.Height := Height;
      ScaleBitmap.Canvas.StretchDraw(Rect(0, 0, Width, Width), QRCodeBitmap);
      //ScaleBitmap.SaveToFile('QR.bmp');
      ACanvas.Draw(ARect.Left, ARect.Top, ScaleBitmap);
    end;
  finally
    QRCode.Free;
    QRCodeBitmap.Free;
    ScaleBitmap.Free;
  end;
end;

Function ReformatPhoneNo(s: String): String;  //20250924
Begin
 Result:=ReplaceChar(s,'-',' ');
End;

end.




