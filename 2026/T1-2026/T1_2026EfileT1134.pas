unit T1_2026EfileT1134;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.IOUtils; // 20180731 Igor

const
  //20260221??
  SOFTRELEASEYEAR = '2026';
  SOFTRELEASEMONTH = '02';
  SOFTRELEASEDAY = '21';
  
  CrLf = Chr(13) + Chr(10);
  SoftVendor = '064Y'; //'064K';

type
  TEfileT1134T1_2026 = class(TForm)
    Panel1: TPanel;
    ProductionOrTestGroup: TRadioGroup;
    URLForWebServices: TEdit;
    T1134EfileBtn: TBitBtn;
    MemoLog: TMemo;
    MemoFile: TMemo;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    edSubmittedFile: TEdit;
    Label1: TLabel;
    Panel5: TPanel;
    Label2: TLabel;
    edReceivedFile: TEdit;
    Panel6: TPanel;
    Label3: TLabel;
    edReceivedHTMLFile: TEdit;
    btnViewHTML: TSpeedButton;
    btnManageFAList: TBitBtn;
    pnlFAList: TPanel;
    pnlButtons: TPanel;
    FAList: TListBox;
    btnUp: TSpeedButton;
    btnDown: TSpeedButton;
    procedure ProductionOrTestGroupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure T1134EfileBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnViewHTMLClick(Sender: TObject);
    //20230712 Igor >>>
    procedure btnManageFAListClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    //20230712 Igor <<<
  private
    { Private declarations }
    OnlineNo: string;
    Password: string;
    Url: string;
    NetFileDir: string;
    RetNo: integer;
    FT1134RDir: string;

    function CreateBody(ABaseIndent: integer): string;
    procedure SubmitSoapMessage(SoapMessage: string);
    function ReplacePredefinedXMLEntities(info: string): string;
    function PrepareValue(Value: string; MaxLength: integer = 0): string;
    procedure WebServiceEfile;
    function GetSubmittedFileName: string;
    function GetReceivedFileName: string;
    function GetReceivedHTMLFileName: string;
    procedure SaveToFile(AText, AFileName: string);

    //20230712 Igor >>>
    procedure ShowFAList;
    procedure SaveFAList;
    //20230712 Igor <<<
  public
    { Public declarations }
  end;

  Var SoftwareId:String;

  function GetT1EfileReturnRequestForT1134(ATaxYear: string): string; // 20180703 Igor
  function ParseXmlResponse(Response, ATitle, AFileName: string; var AConfirmNumber: string): boolean; // 20230811 Igor

implementation

uses
  T1_2026TrimStr, vtCommon, MSXML2_TLB, ComObj, System.RegularExpressions,
  Xml.XMLDoc, Xml.XMLIntf, StrUtils, vtTrimStr, T1_2026, vtMulti, vtShowMessageHTML,
  vtDynData,
  //uXMLValidator, // 20260108 Igor
  T1_2026Declare, T1_2026Common2; // 20180709 Igor  CBC used for ParseXMLResponse only?  yes

{$R *.dfm}

function ClearXML(AXML: String): string;
begin
  Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
  Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
end;

function TEfileT1134T1_2026.ReplacePredefinedXMLEntities(info: string): string;
begin
  info := Trim(info);
  info := HTMLEscape(info);
  info := ReplaceChar(info, '''', '&apos;');
  Result := info;
end;

procedure TEfileT1134T1_2026.SaveFAList; //20230712 Igor
begin
  StoreElm(RetNo, 'STATUS', T1134_FA_LIST, FAList.Items.Text);
end;

procedure TEfileT1134T1_2026.SaveToFile(AText, AFileName: string);
var L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Text := AText;
    L.SaveToFile(AFileName, TEncoding.UTF8);
  finally
    L.Free;
  end;
end;

procedure TEfileT1134T1_2026.ShowFAList; //20230712 Igor
var L: TStringList;
begin
  L := TStringList.Create;
  try
    PopulateT1134ForeignAffiliates(RetNo, L);
    FAList.Items.Text := L.Text;
  finally
    L.Free;
  end;
end;

procedure TEfileT1134T1_2026.SubmitSoapMessage(SoapMessage: string);
var
  objHttp: IXMLHTTPRequest;
  Response: String;
  ResponseXmlFile: String;
  AList: TStringList;
  ConfirmNumber: string; // 20180824 Igor
  // 20250806 Igor >>>
  lXMLValidationErrorList: TStringList;
  ifor: Integer;
  lErrorsString: string;
  lXSDFilesList: TStringList;
  // 20250806 Igor <<<
begin
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
  //objHttp.open('POST', URLForWebServices.Text, False, OnlineNo, Password);
  objHttp.open('POST', URLForWebServices.Text, False, '', '');
  objHttp.setRequestHeader('SOAPAction', 'NA');
  objHttp.setRequestHeader('Content-Type', 'text/xml;charset=UTF-8');
  SaveToFile(SoapMessage, GetSubmittedFileName);
  edSubmittedFile.Text := GetSubmittedFileName;
  Screen.Cursor := crHourGlass;
  // 20260108 Igor >>>
  {lXMLValidationErrorList:= TStringList.Create;
  lXSDFilesList:= TStringList.Create;
  try
    lXSDFilesList.Add('http://www.w3.org/XML/1998/namespace,xml.xsd');
    lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0,standarddatatypes.xsd');
    lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0,cracommonstructures.xsd');
    lXSDFilesList.Add('urn:oecd:ties:isocbctypes:v1,isocbctypes_v1.1.xsd');
    lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-0-0,CountryByCountryReport2019.xsd');
    lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/comm/2025/1-0-0,electronicfilingcommon.xsd');
    lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/ef/2025/1-0-0,efilecommon.xsd'); // 20251104 Igor
    lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0,ForeignIncomeVerificationStatement.xsd');
    lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t1134/2021/1-0-0,ControlledAndNotControlledForeignAffiliateReturn2021.xsd');
    lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t106/2025/1-0-0,NonArmsLengthTransactionWithNonResidentInformationReturn.xsd');
    lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0,t2efilefrrmsrequest.xsd');

    //TXMLValidator.XMLValidate(AppDir, lXSDFilesList, GetSubmittedFileName, lXMLValidationErrorList);
    TXMLValidator.XMLValidate(ExtractFilePath(ParamStr(0)) + 'T1' + '-' + T1_2026Declare.AppYear, lXSDFilesList, GetSubmittedFileName, lXMLValidationErrorList);

    if (lXMLValidationErrorList.Count > 0) and not lXMLValidationErrorList[0].StartsWith('XSD file not found:') then
    begin
      //TXMLValidator.ShowErrorsInHTML(lXMLValidationErrorList);
      //Exit;
    end;
  finally
    lXMLValidationErrorList.Free;
    lXSDFilesList.Free;
  end;}
  // 20260108 Igor <<<
  try
    objHttp.send(SoapMessage);
    Screen.Cursor := crDefault;
    delay(2000);
    Screen.Cursor := crDefault;
    Response := objHttp.ResponseText;
    SaveToFile(Response, GetReceivedFileName);
    edReceivedFile.Text := GetReceivedFileName;
    // 20180824 Igor >>>
    if ParseXmlResponse(Response, 'T1134 XML submission', GetReceivedHTMLFileName, ConfirmNumber) then
    begin
      // implement some logic for successful result
      StoreElm(RetNo, GetFormNo('T1134'), 26, ConfirmNumber);
      Ret[RetNo].Changed := True; //20180824 CON
      Close; //20180824 CON
    end;
    // 20180824 Igor <<<
    if FileExists(GetReceivedHTMLFileName) then
      edReceivedHTMLFile.Text := GetReceivedHTMLFileName;

    MemoLog.Clear;
    MemoLog.Text := ReplaceStr(Response, '><', '>' + #13#10 + '<');
    OpenForm(RetNo,'T1134',0);  //20180824 CON to refresh //20230619 Igor
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TEfileT1134T1_2026.PrepareValue(Value: string;
  MaxLength: integer = 0): string;
begin
  Value := ReplacePredefinedXMLEntities(Trim(Value));
  if MaxLength > 0 then
    Value := Copy(Value, 1, MaxLength);
  Result := Value;
end;

procedure TEfileT1134T1_2026.BitBtn1Click(Sender: TObject);
var SoapMessage: string;
begin
  SoapMessage := MemoFile.Text;
  SubmitSoapMessage(SoapMessage);
end;

function TEfileT1134T1_2026.CreateBody(ABaseIndent: integer): string;
const
  OPTIONAL = true;
  cBaseMovingBodyOn = '        ';
var FList: TStringList;
    FName: string;
    I, J, Suppl: integer; //20230510 Igor
    nElm: integer;
    s:String;   //20180710 CON
    //20230510 Igor >>>
    GroupList: TArray<T1134GroupItem>;
    ForeignAffiliateList: TStringList;
    FormNo, ArrayNo, BoxesPerRow, RowCount: integer;
    Value: string;
    //20230510 Igor <<<


    procedure AddBeginTag(AIndent: integer; AName: string);
    begin
      FList.Add(Space(AIndent) + '<'+ AName +'>');
    end;

    procedure AddEndTag(AIndent: integer; AName: string; AOptional: boolean = false);
    begin
      if AOptional and SameText(Trim(FList.Strings[FList.Count - 1]), '<'+ AName +'>') then
        FList.Delete(FList.Count - 1)
      else
        FList.Add(Space(AIndent) + '</'+ AName +'>');
    end;

    procedure AddTag(AIndent: integer; AName, AValue: string; AOptional: boolean = false); overload; //20230510 Igor
    begin
      if SameText(Trim(AValue), '') and AOptional then Exit;
      //if SameText(Trim(AValue), '0') and AOptional then Exit;  //20180709 CON //20230619 Igor
      AValue := ReplacePredefinedXMLEntities(AValue);
      if SameText(Trim(AValue), '') then
        FList.Add(Space(AIndent) + '<'+ AName +'/>')
      else
        FList.Add(Space(AIndent) + '<'+ AName +'>' + AValue + '</'+ AName +'>');
    end;

    procedure AddTag(AIndent: integer; AName: string; AValue: integer; AOptional: boolean = false); overload; //20230510 Igor
    begin
      AddTag(AIndent, AName, AValue.ToString, AOptional);
    end;

    function GetValue(AElm: integer): string;
    begin
      Result := FetchElm(RetNo, FName, AElm);
    end;

    function GetYesNoValue(AElm1, AElm2: integer; AValue1: string = '1'; AValue2: string = '0'): string;
    begin
      if not SameText(FetchElm(RetNo, FName, AElm1), '') then
        Result := AValue1
      else if not SameText(FetchElm(RetNo, FName, AElm2), '') then
        Result := AValue2
      else
        Result := '';
    end;

    function GetCheckedValue(AElm: integer; ACheckedValue: string = '1'; ANonCheckedValue: string = '0'): string; //20230510 Igor
    begin
      if Trim(FetchElm(RetNo, FName, AElm)).IsEmpty then
        Result := ANonCheckedValue
      else
        Result := ACheckedValue;
    end;

    function BoxChecked(AElm: integer): boolean;
    begin
      Result := not SameText(FetchElm(RetNo, FName, AElm), '');
    end;

    function GetPhoneNumber(AElm1, AElm2: integer): string;
    begin
      Result := GetValue(AElm1) + GetValue(AElm2);
    end;

    function ExtractNumbers(AValue: string): string;
    var I: integer;
    begin
      Result := '';
      for I := 1 to Length(AValue) do
        if CharInSet(AValue[I], ['0'..'9']) then
          Result := Result + AValue[I];
    end;

    function GetDateValue(AElm: integer): string;
    var cValue: string;
    begin
      cValue := ExtractNumbers(GetValue(AElm));
      Result := Copy(cValue, 1, 4) + '-' + Copy(cValue, 5, 2) + '-' + Copy(cValue, 7, 2);
    end;

    function GetAmountValue(AElm: integer): string;
    var cValue: string;
    begin
      cValue := GetValue(AElm);
      //20230619 Igor >>>
      if not SameText(cValue, '') then
        Result := IntToStr(Trunc(StrToFloatDef(cValue, 0)))
      else
        Result := '';
      //20230619 Igor <<<
    end;

    function GetValueNoSpaces(AElm: integer): string;
    begin
      Result := ReplaceStr(FetchElm(RetNo, FName, AElm), ' ', '');
    end;

    procedure AddBoxAmount(AIndent: integer; AName: string; AElm: integer);
    var cValue: string;
    begin
      if not SameText(GetValueNoSpaces(AElm), '') and not SameText(GetValueNoSpaces(AElm), '0') then
      begin
        AddTag(AIndent, AName +'Amount', GetAmountValue(AElm));
        AddTag(AIndent, AName +'CurrencyCode', GetValue(AElm + 1));
      end;
    end;

    function GetCombinedStrValue(AFromElm, AToElm: integer): string;
    var I: integer;
        cValue: string;
    begin
      Result := '';
      for I := AFromElm to AToElm do
      begin
        cValue := GetValue(I);
        if not SameText(cValue, '') then
          Result := Result + cValue + ' ';
      end;
    end;

    function GetGroupSequenceNumber(ANumber: string): integer; //20230510 Igor
    var I: integer;
    begin
      Result := 0;
      for I := 0 to Length(GroupList) - 1 do
        if SameText(GroupList[I].AccountNumber, ANumber) then
        begin
          Result := I + 1;
          break;
        end;
    end;

    function GetForeignAffiliateSequenceNumber(AName: string): integer; //20230510 Igor
    var I: integer;
    begin
      Result := 0;
      for I := 0 to ForeignAffiliateList.Count - 1 do
        if SameText(ForeignAffiliateList.Strings[I], AName) then
        begin
          Result := I + 1;
          break;
        end;
    end;

    function CheckSymbolsAfterPoint(aFloatVal: string = '0'): string;
    begin
      if (Length(aFloatVal) > 0) and (Pos('.', aFloatVal) = 0) then //20260226 Igor
        Result:= aFloatVal + '.00'
      else
      if (Pos('.', aFloatVal) > 0) then
      begin
        if ((Length(aFloatVal) - Pos('.', aFloatVal)) = 1) then
          Result:= aFloatVal + '0'
        else
          Result:= aFloatVal;
      end else
        Result:= aFloatVal;
    end;

    //20260813 Alex >>>
    function GetRoundedVal(aVal: string): string;
    var
      lCur: Currency;
      lInt: Integer;
    begin
      Result:= '';

      if not aVal.IsEmpty() then
      begin
        lCur:= Vl(aVal);
        lInt:= Round(lCur);

        Result:= IntToStr(lInt);
      end;
    end;
    //20260813 Alex <<<

begin
  //20230510 Igor >>>
  FName := 'T1134';
  FormNo := GetFormNo(FName);

  FList := TStringList.Create;
  ForeignAffiliateList := TStringList.Create;
  try
    GroupList := GetT1134GroupList(RetNo);
    PopulateT1134ForeignAffiliates(RetNo, ForeignAffiliateList);

    //20230619 Igor >>>
    FList.Text:=
      '<t1134:ControlledAndNotControlledForeignAffiliateReturn>' + #13#10 +
      '<t1134:SoftwareID>' + SoftVendor + '</t1134:SoftwareID>' + #13#10 +
      '<t1134:SoftwareRevisionDate>' + SOFTRELEASEYEAR + '-' + SOFTRELEASEMonth + '-' + SOFTRELEASEDay + '</t1134:SoftwareRevisionDate>';
//      '    xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0" '+ #13#10 +
//      '    xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0" '+ #13#10 +
//      '    xmlns:t1134="http://www.cra-arc.gc.ca/xmlns/t1134/2021/1-0-0" '+ #13#10 +
//      '    xmlns:xml="http://www.w3.org/XML/2001/namespace" '+ #13#10 +
//      '    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+ #13#10 +
//      '    xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t1134/2021/1-0-0 ControlledAndNotControlledForeignAffiliateReturn2021.xsd "> '+ #13#10;
//    AddTag(2, 't1134:SoftwareID', SoftwareId);
//    AddTag(2, 't1134:SoftwareRevisionDate', '2022-11-10'); //????
    //20230619 Igor <<<

    AddBeginTag(2, 't1134:ControlledAndNotControlledForeignAffiliateSummary');
    AddTag(4, 't1134:SummaryActionCode', Copy(GetValue(25), 1, 1));

    for I := 0 to Length(GroupList) - 1 do
    begin
      AddBeginTag(4, 't1134:GroupList');
      AddTag(6, 't1134:ReportingEntitySequenceNumber', I + 1);
      AddBeginTag(6, 't1134:ReportingEntityAccountNumber');
      case GroupList[I].AccountType of
        atIndividual: AddTag(8, 't1134:AccountSocialInsuranceNumber', GroupList[I].AccountNumber);
        atCorporation: AddTag(8, 't1134:AccountBusinessNumber', GroupList[I].AccountNumber);
        atTrust: AddTag(8, 't1134:AccountTrustNumber', GroupList[I].AccountNumber);
        atPartnership: AddTag(8, 't1134:AccountPartnershipNumber', GroupList[I].AccountNumber);
      end;
      AddEndTag(6, 't1134:ReportingEntityAccountNumber');
      AddEndTag(4, 't1134:GroupList');
    end;

    for I := 0 to ForeignAffiliateList.Count - 1 do
    begin
      AddBeginTag(4, 't1134:ForeignAffiliateList');
      AddTag(6, 't1134:ForeignAffiliateSequenceNumber', I + 1);
      AddTag(6, 't1134:ForeignAffiliateListName', ForeignAffiliateList.Strings[I]);
      AddEndTag(4, 't1134:ForeignAffiliateList');
    end;

    AddTag(4, 't1134:FunctionalCurrencyCode', GetValue(24), OPTIONAL);
    if BoxChecked(99) then AddTag(4, 't1134:AmendedReturnIndicator', '1'); //else AddTag(4, 't1134:AmendedReturnIndicator', '0'); //20260212 Igor

    if BoxChecked(32) then
      AddTag(4, 't1134:GroupReportingIndicator', '1')
    else
      AddTag(4, 't1134:GroupReportingIndicator', '0');

    AddBeginTag(4, 't1134:ReportingTaxpayerIdentification');
    AddTag(6, 't1134:ReportingTaxpayerIDCode', 2); // in T2 only corporation is allowed
    AddTag(6, 't1134:ReportingTaxpayerFirstSequenceNumber', 1); // always 1
    AddBeginTag(6, 't1134:Individual');
    AddTag(8, 't1134:IndividualFirstName', GetValue(2));
    AddTag(8, 't1134:IndividualLastName', GetValue(3));
    if not GetValue(4).IsEmpty() then //20260813 Alex    
      AddTag(8, 't1134:IndividualInitial', GetValue(4));
    AddTag(8, 't1134:IndividualSIN', GetValue(5));
    AddEndTag(6, 't1134:Individual');

    AddEndTag(4, 't1134:ReportingTaxpayerIdentification');

    AddBeginTag(4, 't1134:ReportingTaxpayerAddress');
    AddTag(6, 't1134:AddressNumber', GetValue(30));
    AddTag(6, 't1134:AddressStreetText', GetValue(15));
    AddTag(6, 't1134:AddressMunicipalityName', GetValue(16));
    AddTag(6, 't1134:GlobalProvinceTerritoryStateCode', GetValue(17));
    AddTag(6, 't1134:GlobalPostalZipCode', GetValueNoSpaces(18));
    AddTag(6, 't1134:CountryCode', GetValue(141));
    AddEndTag(4, 't1134:ReportingTaxpayerAddress');

    AddBeginTag(4, 't1134:ReportingTaxpayerNorthAmericanIndustryClassificationSystem');
    for I in [40,41,42,43] do
      AddTag(6, 't1134:NorthAmericanIndustryClassificationSystemCode', GetValue(I), OPTIONAL);
    AddEndTag(4, 't1134:ReportingTaxpayerNorthAmericanIndustryClassificationSystem');

    AddBeginTag(4, 't1134:TaxationYear');
    AddTag(6, 't1134:TaxationYearStartDate', GetDateValue(19));
    AddTag(6, 't1134:TaxationYearEndDate', GetDateValue(20));
    AddEndTag(4, 't1134:TaxationYear');

    AddTag(4, 't1134:ShortTaxationYearIndicator', GetYesNoValue(21, 22));
    AddTag(4, 't1134:DeclaredSlipCount', GetValue(142));

    AddBeginTag(4, 't1134:CertificationDetail');
    AddTag(6, 't1134:ContactPersonFirstName', GetValue(143));
    AddTag(6, 't1134:ContactPersonLastName', GetValue(144));
    AddTag(6, 't1134:ContactPersonPhoneNumber', GetValue(145) + '-' + GetValue(146)); //20260212 Igor
    AddTag(6, 't1134:CertifierName', GetValue(23));
    AddTag(6, 't1134:CertificationDate', GetDateValue(147));
    AddTag(6, 't1134:CertifierPositionTitle', GetValue(148));
    AddEndTag(4, 't1134:CertificationDetail');

    //20230619 Igor >>>
    if BoxChecked(32) then
    begin
      AddBeginTag(4, 't1134:GroupReportingRelatedEntities');
      // individual
      ArrayNo := 1;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(6, 't1134:IndividualGroup');
        AddTag(8, 't1134:IndividualReportingEntitySequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 10)));
        AddTag(8, 't1134:IndividualGroupMemberFirstName', GetValue(nElm + 1));
        AddTag(8, 't1134:IndividualGroupMemberLastName', GetValue(nElm + 3));
        if not GetValue(nElm + 2).IsEmpty then AddTag(8, 't1134:IndividualGroupMemberInitial', GetValue(nElm + 2)); //20260213 Igor
        AddBeginTag(8, 't1134:IndividualGroupMemberAddress');
        AddTag(10, 't1134:AddressNumber', GetValue(nElm + 4));
        AddTag(10, 't1134:AddressStreetText', GetValue(nElm + 5));
        AddTag(10, 't1134:AddressMunicipalityName', GetValue(nElm + 6));
        AddTag(10, 't1134:GlobalProvinceTerritoryStateCode', GetValue(nElm + 7));
        AddTag(10, 't1134:GlobalPostalZipCode', GetValue(nElm + 8));
        AddTag(10, 't1134:CountryCode', GetValue(nElm + 9));
        AddEndTag(8, 't1134:IndividualGroupMemberAddress');
        AddTag(8, 't1134:IndividualGroupMemberSIN', GetValue(nElm + 10));
        AddEndTag(6, 't1134:IndividualGroup');
        nElm := nElm + BoxesPerRow;
      end;
      // corporation
      ArrayNo := 2;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(6, 't1134:CorporationGroup');
        AddTag(8, 't1134:CorporationReportingEntitySequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 8)));
        AddTag(8, 't1134:CorporationGroupMemberName', GetValue(nElm + 1));
        AddTag(8, 't1134:CorporationGroupMemberBusinessNumber', GetValue(nElm + 8));
        AddBeginTag(8, 't1134:CorporationGroupMemberAddress');
        AddTag(10, 't1134:AddressNumber', GetValue(nElm + 2));
        AddTag(10, 't1134:AddressStreetText', GetValue(nElm + 3));
        AddTag(10, 't1134:AddressMunicipalityName', GetValue(nElm + 4));
        AddTag(10, 't1134:GlobalProvinceTerritoryStateCode', GetValue(nElm + 5));
        AddTag(10, 't1134:GlobalPostalZipCode', GetValue(nElm + 6));
        AddTag(10, 't1134:CountryCode', GetValue(nElm + 7));
        AddEndTag(8, 't1134:CorporationGroupMemberAddress');
        AddBeginTag(8, 't1134:CorporationGroupMemberNorthAmericanIndustryClassificationSystem');
        for J in [9,10,11,12] do
          AddTag(10, 't1134:NorthAmericanIndustryClassificationSystemCode', GetValue(nElm + J), OPTIONAL);
        AddEndTag(8, 't1134:CorporationGroupMemberNorthAmericanIndustryClassificationSystem');
        AddEndTag(6, 't1134:CorporationGroup');
        nElm := nElm + BoxesPerRow;
      end;
      //trust
      ArrayNo := 3;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(6, 't1134:TrustGroup');
        AddTag(8, 't1134:TrustReportingEntitySequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 8)));
        AddTag(8, 't1134:TrustGroupMemberName', GetValue(nElm + 1));
        AddTag(8, 't1134:TrustGroupMemberNumber', GetValue(nElm + 8));
        AddBeginTag(8, 't1134:TrustGroupMemberAddress');
        AddTag(10, 't1134:AddressNumber', GetValue(nElm + 2));
        AddTag(10, 't1134:AddressStreetText', GetValue(nElm + 3));
        AddTag(10, 't1134:AddressMunicipalityName', GetValue(nElm + 4));
        AddTag(10, 't1134:GlobalProvinceTerritoryStateCode', GetValue(nElm + 5));
        AddTag(10, 't1134:GlobalPostalZipCode', GetValue(nElm + 6));
        AddTag(10, 't1134:CountryCode', GetValue(nElm + 7));
        AddEndTag(8, 't1134:TrustGroupMemberAddress');
        AddBeginTag(8, 't1134:TrustGroupMemberNorthAmericanIndustryClassificationSystem');
        for J in [9,10,11,12] do
          AddTag(10, 't1134:NorthAmericanIndustryClassificationSystemCode', GetValue(nElm + J), OPTIONAL);
        AddEndTag(8, 't1134:TrustGroupMemberNorthAmericanIndustryClassificationSystem');
        AddEndTag(6, 't1134:TrustGroup');
        nElm := nElm + BoxesPerRow;
      end;
      //partnership
      ArrayNo := 4;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(6, 't1134:PartnershipGroup');
        AddTag(8, 't1134:PartnershipReportingEntitySequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 8)));
        AddTag(8, 't1134:PartnershipGroupMemberName', GetValue(nElm + 1));
        AddTag(8, 't1134:PartnershipGroupMemberNumber', GetValue(nElm + 8));
        AddTag(10, 't1134:PartnershipGroupMemberCode', GetValue(nElm + 9));
        AddBeginTag(8, 't1134:PartnershipGroupMemberAddress');
        AddTag(10, 't1134:AddressNumber', GetValue(nElm + 2));
        AddTag(10, 't1134:AddressStreetText', GetValue(nElm + 3));
        AddTag(10, 't1134:AddressMunicipalityName', GetValue(nElm + 4));
        AddTag(10, 't1134:GlobalProvinceTerritoryStateCode', GetValue(nElm + 5));
        AddTag(10, 't1134:GlobalPostalZipCode', GetValue(nElm + 6));
        AddTag(10, 't1134:CountryCode', GetValue(nElm + 7));
        AddEndTag(8, 't1134:PartnershipGroupMemberAddress');
        AddBeginTag(8, 't1134:PartnershipGroupMemberNorthAmericanIndustryClassificationSystem');
        for J in [10,11,12,13] do
          AddTag(10, 't1134:NorthAmericanIndustryClassificationSystemCode', GetValue(nElm + J), OPTIONAL);
        AddEndTag(8, 't1134:PartnershipGroupMemberNorthAmericanIndustryClassificationSystem');
        AddEndTag(6, 't1134:PartnershipGroup');
        nElm := nElm + BoxesPerRow;
      end;
      AddEndTag(4, 't1134:GroupReportingRelatedEntities');
    end;
    //20230619 Igor <<<

    //EachEntityOtherInformation
    ArrayNo := 5;
    BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    nElm := ArrayNo * 10000;
    RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      AddBeginTag(4, 't1134:EachEntityOtherInformation');
      AddTag(6, 't1134:OtherInformationReportingEntitySequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 1)));
      AddTag(6, 't1134:AccountNumber', GetValue(nElm + 1));
      AddTag(6, 't1134:Section85_Indicator', GetYesNoValue(nElm + 2, nElm + 3));
      AddTag(6, 't1134:Section85_1_3_Indicator', GetYesNoValue(nElm + 4, nElm + 5));
      AddTag(6, 't1134:Section86_1_Indicator', GetYesNoValue(nElm + 6, nElm + 7));
      AddTag(6, 't1134:Section87_Indicator', GetYesNoValue(nElm + 8, nElm + 9));
      AddTag(6, 't1134:Section88_1_Indicator', GetYesNoValue(nElm + 10, nElm + 11));
      AddEndTag(4, 't1134:EachEntityOtherInformation');
      nElm := nElm + BoxesPerRow;
    end;
    AddTag(4, 't1134:OrganizationalChartSubmittedIndicator', GetYesNoValue(28, 29));

    //RelatedCorporation
    ArrayNo := 6;
    BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    nElm := ArrayNo * 10000;
    RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      AddBeginTag(4, 't1134:RelatedCorporation');
      AddTag(6, 't1134:RelatedCorporationName', GetValue(nElm + 1));
      AddTag(6, 't1134:CorporationResidenceCountryCode', GetValue(nElm + 2));
      AddTag(6, 't1134:ForeignAffiliateCorporationSequenceNumber', GetForeignAffiliateSequenceNumber(GetValue(nElm + 3)));
      AddTag(6, 't1134:ForeignAffiliateCorporationName', GetValue(nElm + 3));
      AddTag(6, 't1134:TaxpayerIdentificationNumberforNonResident', GetValue(nElm + 4));
      AddTag(6, 't1134:ForeignAffiliateCorporationResidenceCountryCode', GetValue(nElm + 5));
      AddTag(6, 't1134:ForeignAffiliateCorporationEquityPercentage', GetValue(nElm + 6));
      AddTag(6, 't1134:ForeignAffiliateCorporationDirectEquityPercentage', GetValue(nElm + 7));
      AddTag(6, 't1134:SupplementNotFiledDueToDormancyCorporation', GetYesNoValue(nElm + 8, nElm + 9));
      AddEndTag(4, 't1134:RelatedCorporation');
      nElm := nElm + BoxesPerRow;
    end;

    //RelatedAffiliate
    ArrayNo := 7;
    BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    nElm := ArrayNo * 10000;
    RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      AddBeginTag(4, 't1134:RelatedForeignAffiliate');
      AddTag(6, 't1134:RelatedForeignAffiliateSequenceNumber', GetForeignAffiliateSequenceNumber(GetValue(nElm + 1)));
      AddTag(6, 't1134:RelatedForeignAffiliateName', GetValue(nElm + 1));
      AddTag(6, 't1134:ForeignAffiliateShareholderTaxpayerIdentificationNumber', GetValue(nElm + 2));
      AddTag(6, 't1134:ForeignAffiliateResidenceCountryCode', GetValue(nElm + 3));
      AddTag(6, 't1134:OtherForeignAffiliateSequenceNumber', GetForeignAffiliateSequenceNumber(GetValue(nElm + 4)));
      AddTag(6, 't1134:OtherForeignAffiliateName', GetValue(nElm + 4));
      AddTag(6, 't1134:OtherForeignAffiliateTaxpayerIdentificationNumber', GetValue(nElm + 5));
      AddTag(6, 't1134:OtherForeignAffiliateResidenceCountryCode', GetValue(nElm + 6));
      AddTag(6, 't1134:OtherForeignAffiliateEquityPercentage', CheckSymbolsAfterPoint(GetValue(nElm + 7))); //20260213 Igor
      AddTag(6, 't1134:OtherForeignAffiliateDirectEquityPercentage', CheckSymbolsAfterPoint(GetValue(nElm + 8))); //20260213 Igor
      AddTag(6, 't1134:SupplementNotFiledDueToDormancyForeignAffiliate', GetYesNoValue(nElm + 9, nElm + 10));
      AddEndTag(4, 't1134:RelatedForeignAffiliate');
      nElm := nElm + BoxesPerRow;
    end;

    //partner
    ArrayNo := 8;
    BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    nElm := ArrayNo * 10000;
    RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      AddBeginTag(4, 't1134:Partner');
      AddTag(6, 't1134:PartnerName', GetValue(nElm + 1));
      AddTag(6, 't1134:PartnerAddress', GetValue(nElm + 2));
      AddTag(6, 't1134:ResidencePartnerCountryCode', GetValue(nElm + 3));
      AddEndTag(4, 't1134:Partner');
      nElm := nElm + BoxesPerRow;
    end;

    //PartnershipForeignAffiliate
    ArrayNo := 9;
    BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    nElm := ArrayNo * 10000;
    RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      AddBeginTag(4, 't1134:PartnershipForeignAffiliate');
      AddTag(6, 't1134:ForeignAffiliateMemberPartnershipName', GetValue(nElm + 1));
      AddTag(6, 't1134:PartnershipAddress', GetValue(nElm + 2));
      AddTag(6, 't1134:LocationPartnershipCountryCode', GetValue(nElm + 3));
      AddTag(6, 't1134:PartnershipForeignAffiliateSequenceNumber', GetForeignAffiliateSequenceNumber(GetValue(nElm + 4)));
      AddTag(6, 't1134:PartnershipForeignAffiliateName', GetValue(nElm + 4));
      AddTag(6, 't1134:ForeignAffiliatePartnershipInterestPercentage', CheckSymbolsAfterPoint(GetValue(nElm + 5))); //20260213 Igor
      AddEndTag(4, 't1134:PartnershipForeignAffiliate');
      nElm := nElm + BoxesPerRow;
    end;

    //DormantForeignAffiliate
    ArrayNo := 10;
    BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    nElm := ArrayNo * 10000;
    RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      AddBeginTag(4, 't1134:DormantForeignAffiliate');
      AddTag(6, 't1134:DormantForeignAffiliateSequenceNumber', GetForeignAffiliateSequenceNumber(GetValue(nElm + 1)));
      AddTag(6, 't1134:DormantForeignAffiliateName', GetValue(nElm + 1));
      AddTag(6, 't1134:DormantForeignAffiliateCost', GetValue(nElm + 2));
      AddTag(6, 't1134:DormantForeignAffiliateReceipt', GetRoundedVal(GetValue(nElm + 3))); //20260813 Alex
      AddTag(6, 't1134:DormantForeignAffiliateGrossRevenue', GetRoundedVal(GetValue(nElm + 4))); //20260813 Alex
      AddBeginTag(6, 't1134:DormantForeignAffiliateHoldingAsset');
      if not GetCheckedValue(nElm + 5).Equals('0') then AddTag(6, 't1134:Funds', GetCheckedValue(nElm + 5)); //20260212 Igor
      if not GetCheckedValue(nElm + 6).Equals('0') then AddTag(6, 't1134:Shares', GetCheckedValue(nElm + 6)); //20260213 Igor
      if not GetCheckedValue(nElm + 7).Equals('0') then AddTag(6, 't1134:IndebtednessOwedByNonResident', GetCheckedValue(nElm + 7)); //20260212 Igor
      if not GetCheckedValue(nElm + 8).Equals('0') then AddTag(6, 't1134:InterestInNonResidentTrust', GetCheckedValue(nElm + 8)); //20260212 Igor
      if not GetCheckedValue(nElm + 9).Equals('0') then AddTag(6, 't1134:RealPropertyOutsideCanada', GetCheckedValue(nElm + 9)); //20260212 Igor
      if not GetCheckedValue(nElm + 10).Equals('0') then AddTag(6, 't1134:OtherPropertyOutsideCanada', GetCheckedValue(nElm + 10)); //20260212 Igor
      if not GetCheckedValue(nElm + 11).Equals('0') then AddTag(6, 't1134:PropertyHeldInAccountWithCanadianDealer', GetCheckedValue(nElm + 11)); //20260212 Igor
      AddEndTag(6, 't1134:DormantForeignAffiliateHoldingAsset');
      AddEndTag(4, 't1134:DormantForeignAffiliate');
      nElm := nElm + BoxesPerRow;
    end;

    //NonControlledForeignAffiliate
    ArrayNo := 11;
    BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
    nElm := ArrayNo * 10000;
    RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      AddBeginTag(4, 't1134:NonControlledForeignAffiliate');
      AddTag(6, 't1134:NonControlledForeignAffiliateSequenceNumber', GetForeignAffiliateSequenceNumber(GetValue(nElm + 1)));
      AddTag(6, 't1134:NonControlledForeignAffiliateName', GetValue(nElm + 1));
      AddTag(6, 't1134:NonControlledForeignAffiliateTaxpayerIdentificationNumber', GetValue(nElm + 2));
      AddTag(6, 't1134:NonControlledForeignAffiliateCountry', GetValue(nElm + 3));
      AddTag(6, 't1134:NonControlledForeignAffiliateYear', GetValue(nElm + 4));
      AddTag(6, 't1134:CeasedForeignAffiliateIndicator', GetYesNoValue(nElm + 5, nElm + 6));
      AddTag(6, 't1134:SurplusAccountImpactedIndicator', GetYesNoValue(nElm + 7, nElm + 8));
      AddTag(6, 't1134:ReportingEntityEquityChangeIndicator', GetYesNoValue(nElm + 9, nElm + 10));
      AddTag(6, 't1134:Paragraph95_2_2_a_Indicator', GetYesNoValue(nElm + 11, nElm + 12));
      AddTag(6, 't1134:IndebtedForeignAffiliateIndicator', GetYesNoValue(nElm + 13, nElm + 14));
      AddTag(6, 't1134:IndebtedReportingEntityIndicator', GetYesNoValue(nElm + 15, nElm + 16));
      AddTag(6, 't1134:Subsection212_3_2_ApplyIndicator', GetYesNoValue(nElm + 17, nElm + 18));
      AddTag(6, 't1134:DividendDistributionIssuedIndicator', GetYesNoValue(nElm + 19, nElm + 20));
      AddTag(6, 't1134:BypassElectionMadeIndicator', GetYesNoValue(nElm + 21, nElm + 22));
      AddEndTag(4, 't1134:NonControlledForeignAffiliate');
      nElm := nElm + BoxesPerRow;
    end;

    AddEndTag(2, 't1134:ControlledAndNotControlledForeignAffiliateSummary');

    // supplement section
    for Suppl := 1 to StrToIntDef(GetValue(142), 0) do
    begin
      FName := 'T1134S#'+ IntToStr(Suppl);
      FormNo := GetFormNo(FName);

      AddBeginTag(2, 't1134:ControlledAndNotControlledForeignAffiliateSupplement');

      AddTag(4, 't1134:SupplementSequenceIdentifier', IntToStr(Suppl));
      AddTag(4, 't1134:SupplementActionCode', Copy(GetValue(3), 1, 1));
      if SameText(Copy(GetValue(3), 1, 1), '4') then
        AddTag(4, 't1134:SupplementDeleteReasonCode', Copy(GetValue(175), 1, 1));

      AddBeginTag(4, 't1134:ForeignAffiliateIdentification');
      AddTag(6, 't1134:ForeignAffiliateIdentificationSequenceNumber',GetForeignAffiliateSequenceNumber(GetValue(35)));
      AddTag(6, 't1134:ForeignAffiliateIdentificationName', GetValue(35));
      AddTag(6, 't1134:HeadOfficeAddress', GetValue(36));
      if not GetValue(4).IsEmpty then AddTag(6, 't1134:ForeignAffiliateTaxpayerIdentificationNumber', GetValue(4)); //20260212 Igor

      AddBeginTag(6, 't1134:NorthAmericanIndustryClassificationSystem');
      for J in [40,41,42,43] do
        AddTag(8, 't1134:NorthAmericanIndustryClassificationSystemCode', GetValue(J), OPTIONAL);
      AddEndTag(6, 't1134:NorthAmericanIndustryClassificationSystem');

      AddBeginTag(6, 't1134:BusinessIncomeEarningCountry');
      for J in [44,45,46,47] do
        AddTag(8, 't1134:CountryCode', GetValue(J), OPTIONAL);
      AddEndTag(6, 't1134:BusinessIncomeEarningCountry');

      AddBeginTag(6, 't1134:TaxPayableCountry');
      for J in [5,6,7,8] do
        AddTag(8, 't1134:CountryCode', GetValue(J), OPTIONAL);
      AddEndTag(6, 't1134:TaxPayableCountry');

      AddTag(6, 't1134:ForeignAffiliateJurisdictionResidenceCountryCode', GetValue(48));
      AddTag(6, 't1134:ReportingEntityFirstTimeFilerIndicator', GetYesNoValue(1, 2));
      AddTag(6, 't1134:ControlledForeignAffiliateIndicator', GetYesNoValue(49, 50));
      AddTag(6, 't1134:MultiTaxYearEndingIndicator', GetYesNoValue(9, 10));
      AddEndTag(4, 't1134:ForeignAffiliateIdentification');

      AddBeginTag(4, 't1134:ForeignAffiliateCapitalStock');

      // DirectShareholders
      ArrayNo := 1;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:DirectShareholders');
        AddTag(6, 't1134:DirectShareholdersName', GetValue(nElm + 1));
        Value := '';
        for J in [2,3,4,5] do
        begin
          Value := GetValue(nElm + J);
          if not Value.IsEmpty then
            break;
        end;
        AddTag(6, 't1134:DirectShareholdersSequenceNumber', GetGroupSequenceNumber(Value));

        AddBeginTag(6, 't1134:DirectShareholdersAccountNumber');
        AddTag(8, 't1134:AccountBusinessNumber', GetValue(nElm + 2), OPTIONAL);
        AddTag(8, 't1134:AccountSocialInsuranceNumber', GetValue(nElm + 3), OPTIONAL);
        AddTag(8, 't1134:AccountTrustNumber', GetValue(nElm + 4), OPTIONAL);
        AddTag(8, 't1134:AccountPartnershipNumber', GetValue(nElm + 5), OPTIONAL);
        AddEndTag(6, 't1134:DirectShareholdersAccountNumber');

        AddTag(6, 't1134:ForeignAffiliateStartYear', GetValue(nElm + 6));
        AddTag(6, 't1134:CeaseToBeForeignAffiliateIndicator', GetYesNoValue(nElm + 7, nElm + 8));
        AddTag(6, 't1134:Subsection93_1_ElectionIndicator', GetYesNoValue(nElm + 9, nElm + 10));
        //20230619 Igor >>>
        AddTag(6, 't1134:Subsection93_1_ElectionAmount', GetValue(nElm + 11), OPTIONAL);
        AddTag(6, 't1134:Subsection93_1_ElectionCurrencyCode', GetValue(nElm + 12), OPTIONAL);
        //20230619 Igor <<<
        AddEndTag(4, 't1134:DirectShareholders');
        nElm := nElm + BoxesPerRow;
      end;

      // common shares
      ArrayNo := 2;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:CommonSharesInformation');
        AddTag(6, 't1134:CommonShareHolderSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 1)));
        AddTag(6, 't1134:CommonShareHolderAccountNumber', GetValue(nElm + 1));
        AddTag(6, 't1134:CommonShareOwnershipPercentage', GetValue(nElm + 2));
        AddTag(6, 't1134:CommonShareAdjustedCostBase', GetValue(nElm + 3));
        AddTag(6, 't1134:CommonShareAdjustedCostBaseIncreaseIndicator', GetYesNoValue(nElm + 4, nElm + 5));
        AddTag(6, 't1134:CommonShareAdjustedCostBaseDecreaseIndicator', GetYesNoValue(nElm + 6, nElm + 7));
        AddEndTag(4, 't1134:CommonSharesInformation');
        nElm := nElm + BoxesPerRow;
      end;

      // preferred shares
      ArrayNo := 3;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:PreferredSharesInformation');
        AddTag(6, 't1134:PreferredShareHolderSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 1)));
        AddTag(6, 't1134:PreferredShareHolderAccountNumber', GetValue(nElm + 1));
        AddTag(6, 't1134:PreferredShareOwnershipPercentage', GetValue(nElm + 2));
        AddTag(6, 't1134:PreferredShareAdjustedCostBase', GetValue(nElm + 3));
        AddTag(6, 't1134:PreferredShareAdjustedCostBaseIncreaseIndicator', GetYesNoValue(nElm + 4, nElm + 5));
        AddTag(6, 't1134:PreferredShareAdjustedCostBaseDecreaseIndicator', GetYesNoValue(nElm + 6, nElm + 7));
        AddEndTag(4, 't1134:PreferredSharesInformation');
        nElm := nElm + BoxesPerRow;
      end;

      // lowest tier
      ArrayNo := 4;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:LowestTierCanadianShareholder');
        AddTag(6, 't1134:LowestTierCanadianShareholderName', GetValue(nElm + 1));

        Value := '';
        for J in [2,3,4,5] do
        begin
          Value := GetValue(nElm + J);
          if not Value.IsEmpty then
            break;
        end;
        AddTag(6, 't1134:LowestTierCanadianShareholderSequenceNumber', GetGroupSequenceNumber(Value));

        AddBeginTag(6, 't1134:LowestTierCanadianShareholderAccountNumber');
        AddTag(8, 't1134:AccountBusinessNumber', GetValue(nElm + 2), OPTIONAL);
        AddTag(8, 't1134:AccountSocialInsuranceNumber', GetValue(nElm + 3), OPTIONAL);
        AddTag(8, 't1134:AccountTrustNumber', GetValue(nElm + 4), OPTIONAL);
        AddTag(8, 't1134:AccountPartnershipNumber', GetValue(nElm + 5), OPTIONAL);
        AddEndTag(6, 't1134:LowestTierCanadianShareholderAccountNumber');
        AddEndTag(4, 't1134:LowestTierCanadianShareholder');
        nElm := nElm + BoxesPerRow;
      end;

      AddEndTag(4, 't1134:ForeignAffiliateCapitalStock');

      // ForeignAffiliateOtherInformation
      ArrayNo := 5;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:ForeignAffiliateOtherInformation');
        AddTag(6, 't1134:ForeignAffiliateOtherInformationAccountSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 1)));
        AddTag(6, 't1134:ForeignAffiliateOtherInformationAccountNumber', GetValue(nElm + 1));
        AddTag(6, 't1134:ReportingEntityEquityTaxationYearStartPercentage', GetValue(nElm + 2));
        AddTag(6, 't1134:ReportingEntityEquityTaxationYearEndPercentage', GetValue(nElm + 3));
        AddTag(6, 't1134:QualifyingInterestTaxationYearStartindicator', GetYesNoValue(nElm + 4, nElm + 5));
        AddTag(6, 't1134:QualifyingInterestTaxationYearEndIndicator', GetYesNoValue(nElm + 6, nElm + 7));
        AddTag(6, 't1134:GrossDebtReportingEntityOwedToForeignAffiliateIndicator', GetYesNoValue(nElm + 8, nElm + 9));
        if GetYesNoValue(nElm + 8, nElm + 9).Equals('0') then //20260213 Igor
          AddTag(6, 't1134:GrossDebtReportingEntityOwedToForeignAffiliateAmount', IfThen(not GetValue(nElm + 10).Equals('0') and not GetValue(nElm + 10).IsEmpty, GetValue(nElm + 10), '0')); //OPTIONAL);//20260213 Igor
        AddTag(6, 't1134:GrossDebtForeignAffiliateOwedToReportingEntityIndicator', GetYesNoValue(nElm + 11, nElm + 12));
        if GetYesNoValue(nElm + 11, nElm + 12).Equals('0') then //20260213 Igor
          AddTag(6, 't1134:GrossDebtForeignAffiliateOwedToReportingEntityAmount', IfThen(not GetValue(nElm + 13).Equals('0') and not GetValue(nElm + 13).IsEmpty, GetValue(nElm + 13), '0')); //20260213 Igor
        AddTag(6, 't1134:GrossDebtForeignAffiliateOwedToReportingEntityElectionMadeIndicator', GetYesNoValue(nElm + 14, nElm + 15), OPTIONAL); //20230619 Igor
        AddTag(6, 't1134:ReportingEntityTrackingInterestExistIndicator', GetYesNoValue(nElm + 16, nElm + 17));
        AddTag(6, 't1134:ReportingEntityTrackingInterestDueTo_95_11_Indicator', GetYesNoValue(nElm + 18, nElm + 19));
        AddTag(6, 't1134:ReportingEntityTrackingInterestDueTo_95_12_Indicator', GetYesNoValue(nElm + 20, nElm + 21));
        AddTag(6, 't1134:ReportingEntityAsJointElectionPartyIndicator', GetYesNoValue(nElm + 22, nElm + 23));
        AddEndTag(4, 't1134:ForeignAffiliateOtherInformation');
        nElm := nElm + BoxesPerRow;
      end;

      // ForeignAffiliateDumpingRules
      ArrayNo := 6;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:ForeignAffiliateDumpingRules');
        AddTag(6, 't1134:ForeignAffiliateDumpingRulesAccountSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 1)));
        AddTag(6, 't1134:ForeignAffiliateDumpingRulesAccountNumber', GetValue(nElm + 1));
        //20230619 Igor >>>
        AddTag(6, 't1134:Section212_3_Indicator', GetYesNoValue(nElm + 2, nElm + 3), OPTIONAL);
        AddTag(6, 't1134:Section212_3_NotApplyDueTo_212_3_10', GetYesNoValue(nElm + 4, nElm + 5), OPTIONAL);
        AddTag(6, 't1134:Section212_3_NotApplyDueTo_212_3_16', GetYesNoValue(nElm + 6, nElm + 7), OPTIONAL);
        AddTag(6, 't1134:Section212_3_NotApplyDueTo_212_3_18', GetYesNoValue(nElm + 8, nElm + 9), OPTIONAL);
        AddTag(6, 't1134:Section212_3_7_d_i_Indicator', GetYesNoValue(nElm + 10, nElm + 11), OPTIONAL);
        AddTag(6, 't1134:Section212_3_7_d_ii_Indicator', GetYesNoValue(nElm + 12, nElm + 13), OPTIONAL);
        AddTag(6, 't1134:Section212_3_9_Indicator', GetYesNoValue(nElm + 14, nElm + 15), OPTIONAL);
        AddTag(6, 't1134:Section212_3_19_Indicator', GetYesNoValue(nElm + 16, nElm + 17), OPTIONAL);
        //20230619 Igor <<<
        AddEndTag(4, 't1134:ForeignAffiliateDumpingRules');
        nElm := nElm + BoxesPerRow;
      end;

      AddBeginTag(4, 't1134:ForeignAffiliateFinancialInformation');
      AddBeginTag(6, 't1134:ForeignAffiliateTaxationYear');
      AddTag(8, 't1134:ForeignAffiliateTaxationYearStartDate', GetDateValue(62));
      AddTag(8, 't1134:ForeignAffiliateTaxationYearEndDate', GetDateValue(63));
      AddEndTag(6, 't1134:ForeignAffiliateTaxationYear');
      AddTag(6, 't1134:VotingShareOwedByReportingEntityIndicator', GetYesNoValue(64, 65));
      AddTag(6, 't1134:UnconsolidatedFinancialStatementAvailableIndicator', GetYesNoValue(11, 12));
      AddTag(6, 't1134:UnconsolidatedFinancialStatementAttachedIndicator', GetYesNoValue(13, 14), OPTIONAL); //20230619 Igor
      AddEndTag(4, 't1134:ForeignAffiliateFinancialInformation');

      AddBeginTag(4, 't1134:ForeignAffiliateSurplusAccount');
      AddTag(6, 't1134:ReportingEntityDividendReceivedIndicator', GetYesNoValue(76, 77));

      // exempt surplus
      ArrayNo := 7;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:ExemptSurplus');
        AddTag(6, 't1134:ExemptSurplusAmount', GetValue(nElm + 1));
        AddTag(6, 't1134:ExemptSurplusAccountSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 2)));
        AddTag(6, 't1134:ExemptSurplusAccount', GetValue(nElm + 2));
        AddEndTag(4, 't1134:ExemptSurplus');
        nElm := nElm + BoxesPerRow;
      end;

      // hybrid surplus
      ArrayNo := 8;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:HybridSurplus');
        AddTag(6, 't1134:HybridSurplusAmount', GetValue(nElm + 1));
        AddTag(6, 't1134:HybridSurplusAccountSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 2)));
        AddTag(6, 't1134:HybridSurplusAccount', GetValue(nElm + 2));
        AddEndTag(4, 't1134:HybridSurplus');
        nElm := nElm + BoxesPerRow;
      end;

      // taxable surplus
      ArrayNo := 9;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:TaxableSurplus');
        AddTag(6, 't1134:TaxableSurplusAmount', GetValue(nElm + 1));
        AddTag(6, 't1134:TaxableSurplusAccountSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 2)));
        AddTag(6, 't1134:TaxableSurplusAccount', GetValue(nElm + 2));
        AddTag(6, 't1134:ElectionMadePursuantRegulation5900_2_Indicator', GetYesNoValue(nElm + 3, nElm + 4));
        AddTag(6, 't1134:ElectionMadePursuantRegulation5901_1_1_Indicator', GetYesNoValue(nElm + 5, nElm + 6));
        AddEndTag(4, 't1134:TaxableSurplus');
        nElm := nElm + BoxesPerRow;
      end;

      // preacquisition surplus
      ArrayNo := 10;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:PreAcquisitionSurplus');
        AddTag(6, 't1134:PreAcquisitionSurplusAmount', GetValue(nElm + 1));
        AddTag(6, 't1134:PreAcquisitionSurplusAccountSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 2)));
        AddTag(6, 't1134:PreAcquisitionSurplusAccount', GetValue(nElm + 2));
        AddTag(6, 't1134:ElectionMadePursuantRegulation5901_2_b_Indicator', GetYesNoValue(nElm + 3, nElm + 4));
        AddTag(6, 't1134:ElectionMadePursuantRegulation5901_2_1_Indicator', GetYesNoValue(nElm + 5, nElm + 6));
        AddTag(6, 't1134:QROCElectionMadePursuantSubsection90_3_Indicator', GetYesNoValue(nElm + 7, nElm + 8));
        AddEndTag(4, 't1134:PreAcquisitionSurplus');
        nElm := nElm + BoxesPerRow;
      end;

      //20230619 Igor >>>
      AddBeginTag(4, 't1134:ForeignAffiliateDividendPaidAmount');
      AddTag(6, 't1134:DividendInCash', GetAmountValue(15), OPTIONAL);
      AddTag(6, 't1134:DividendInCashCurrencyCode', GetValue(16), OPTIONAL);
      AddTag(6, 't1134:DividendInStock', GetAmountValue(17), OPTIONAL);
      AddTag(6, 't1134:DividendInStockCurrencyCode', GetValue(18), OPTIONAL);
      AddEndTag(4, 't1134:ForeignAffiliateDividendPaidAmount', OPTIONAL);
      //20230619 Igor <<<

      AddTag(4, 't1134:TransactionRegardingSubsection93_1_Indicator', GetYesNoValue(19, 20));

      // upstream loan rules
      ArrayNo := 11;
      BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
      nElm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        AddBeginTag(4, 't1134:UpstreamLoanRules');
        AddTag(6, 't1134:SurplusAccountSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 1)));
        AddTag(6, 't1134:SurplusAccountNumbers', GetValue(nElm + 1));
        //20230619 Igor >>>
        AddTag(6, 't1134:SpecifiedDebtorIndicator', GetYesNoValue(nElm + 2, nElm + 3), OPTIONAL);
        AddTag(6, 't1134:Subsection90_6_ApplyIndicator', GetYesNoValue(nElm + 4, nElm + 5), OPTIONAL);
        AddTag(6, 't1134:Subsection90_8_ApplyIndicator', GetYesNoValue(nElm + 6, nElm + 7), OPTIONAL);
        AddTag(6, 't1134:EligibleBankAffiliateIndicator', GetYesNoValue(nElm + 8, nElm + 9), OPTIONAL);
        AddTag(6, 't1134:LoanToReportingEntityIndicator', GetYesNoValue(nElm + 10, nElm + 11), OPTIONAL);
        AddTag(6, 't1134:DeductionClaimedIndicator', GetYesNoValue(nElm + 12, nElm + 13), OPTIONAL);
        AddTag(6, 't1134:IncomeInclusionRequiredIndicator', GetYesNoValue(nElm + 14, nElm + 15), OPTIONAL);
        //20230619 Igor <<<
        AddEndTag(4, 't1134:UpstreamLoanRules');
        nElm := nElm + BoxesPerRow;
      end;

      AddEndTag(4, 't1134:ForeignAffiliateSurplusAccount');

      if not FetchElmFNo(RetNo, FormNo, 49).IsEmpty then
      begin
        AddBeginTag(4, 't1134:ControlledForeignAffiliateSurplusAccountShareTransaction');

        AddBeginTag(4, 't1134:ReportingEntityTransaction');
        AddTag(6, 't1134:InvolveSubsection88_3_TransactionIndicator', GetYesNoValue(21,22));
        AddTag(6, 't1134:Subsection88_3_ElectionMadeIndicator', GetYesNoValue(23,24));
        AddTag(6, 't1134:InvolveSection51_TransactionIndicator', GetYesNoValue(25,26));

        // transaction involved entity
        ArrayNo := 12;
        BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
        nElm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
        For i := 0 to RowCount - 1 do
        begin
          AddBeginTag(6, 't1134:TransactionInvolvedEntity');
          AddTag(8, 't1134:InvolvedEntityName', GetValue(nElm + 1));
          AddTag(8, 't1134:InvolvedEntitySequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 2)));
          AddTag(8, 't1134:InvolvedEntityNumber', GetValue(nElm + 2));
          if not GetCheckedValue(nElm + 3).Equals('0') then AddTag(8, 't1134:Provision88_3_Indicator', GetCheckedValue(nElm + 3)); //20260213 Igor
          if not GetCheckedValue(nElm + 4).Equals('0') then AddTag(8, 't1134:Provision88_3_1_Indicator', GetCheckedValue(nElm + 4)); //20260213 Igor
          if not GetCheckedValue(nElm + 5).Equals('0') then AddTag(8, 't1134:Provision88_3_3_Indicator', GetCheckedValue(nElm + 5)); //20260212 Igor
          if not GetCheckedValue(nElm + 6).Equals('0') then AddTag(8, 't1134:Provision88_3_5_Indicator', GetCheckedValue(nElm + 6)); //20260212 Igor
          if not GetCheckedValue(nElm + 7).Equals('0') then AddTag(8, 't1134:Provision51_Indicator', GetCheckedValue(nElm + 7)); //20260212 Igor
          AddEndTag(6, 't1134:TransactionInvolvedEntity');
          nElm := nElm + BoxesPerRow;
        end;

        AddEndTag(4, 't1134:ReportingEntityTransaction');

        AddBeginTag(4, 't1134:ForeignAffiliateTransaction');
        AddTag(6, 't1134:ForeignAffiliateTransactionInvolvedIndicator', GetYesNoValue(27,28));

        // foreign affiliate transaction involved entity
        ArrayNo := 13;
        BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
        nElm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
        For i := 0 to RowCount - 1 do
        begin
          AddBeginTag(6, 't1134:ForeignAffiliateTransactionInvolvedEntity');
          AddTag(8, 't1134:ReportingEntitySequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 2)));
          AddTag(8, 't1134:ReportingEntityName', GetValue(nElm + 1));
          AddTag(8, 't1134:ReportingEntityNumber', GetValue(nElm + 2));
          AddEndTag(6, 't1134:ForeignAffiliateTransactionInvolvedEntity');
          nElm := nElm + BoxesPerRow;
        end;
        //20230619 Igor >>>
        AddTag(6, 't1134:Subsection91_1_1_ApplyIndicator', GetYesNoValue(29,30), OPTIONAL);
        AddTag(6, 't1134:Paragraph95_2_c_ApplyIndicator', GetYesNoValue(31,32), OPTIONAL);
        AddTag(6, 't1134:Paragraph95_2_d_ApplyIndicator', GetYesNoValue(33,34), OPTIONAL);
        AddTag(6, 't1134:Paragraph95_2_e_ApplyIndicator', GetYesNoValue(37,38), OPTIONAL);
        AddTag(6, 't1134:ElectionMadePursuantRegulation5911_5_Indicator', GetYesNoValue(39,51), OPTIONAL);
        //20230619 Igor <<<

        AddEndTag(4, 't1134:ForeignAffiliateTransaction');

        // changes in entity and surplus entitlement percentage
        ArrayNo := 14;
        BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
        nElm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
        For i := 0 to RowCount - 1 do
        begin
          AddBeginTag(4, 't1134:EquityAndSurplusEntitlementChange');
          AddTag(6, 't1134:EquityAndSurplusEntitlementChangeAccountSequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 1)));
          AddTag(6, 't1134:EquityAndSurplusEntitlementChangeAccount', GetValue(nElm + 1));
          AddTag(6, 't1134:SurplusEntitlementPercentageChangeIndicator', GetYesNoValue(nElm + 2, nElm + 3));
          AddTag(6, 't1134:EquityPercentageChangeThisForeignAffiliateIndicator', GetYesNoValue(nElm + 4, nElm + 5));
          AddTag(6, 't1134:EquityPercentageChangeAnotherForeignAffiliateIndicator', GetYesNoValue(nElm + 6, nElm + 7));
          AddEndTag(4, 't1134:EquityAndSurplusEntitlementChange');
          nElm := nElm + BoxesPerRow;
        end;

        AddTag(4, 't1134:ExcludedPropertyIndicator', GetYesNoValue(52,53));
        AddTag(4, 't1134:NotExcludedPropertyIndicator', GetYesNoValue(54,55));
        AddTag(4, 't1134:OtherTransactionInvolvedIndicator', GetYesNoValue(56,57));
        // other transaction entity list
        ArrayNo := 15;
        BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
        nElm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
        For i := 0 to RowCount - 1 do
        begin
          AddBeginTag(4, 't1134:OtherTransactionInvolvedEntityList');
          AddTag(6, 't1134:ReportingEntitySequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 2)));
          AddTag(6, 't1134:ReportingEntityName', GetValue(nElm + 1));
          AddTag(6, 't1134:ReportingEntityNumber', GetValue(nElm + 2));
          AddEndTag(4, 't1134:OtherTransactionInvolvedEntityList');
          nElm := nElm + BoxesPerRow;
        end;

        AddEndTag(4, 't1134:ControlledForeignAffiliateSurplusAccountShareTransaction');

        AddBeginTag(4, 't1134:Employees');
        if not GetValue(60).IsEmpty then
          Value := '0'
        else if not GetValue(61).IsEmpty then
          Value := '1'
        else if not GetValue(66).IsEmpty then
          Value := '2'
        else if not GetValue(67).IsEmpty then
          Value := '3'
        else if not GetValue(68).IsEmpty then
          Value := '4'
        else if not GetValue(69).IsEmpty then
          Value := '5';
        AddTag(6, 't1134:EmployeeCountCode', Value);
        AddTag(4, 't1134:OtherEntityEmployeeDependencyIndicator', GetYesNoValue(70,71));
        AddEndTag(4, 't1134:Employees');

        AddBeginTag(4, 't1134:ControlledForeignAffiliateRevenueComposition');
        //20230619 Igor >>>
        AddTag(6, 't1134:RevenueTypeBreakDownElectionIndicator', GetYesNoValue(72,73), OPTIONAL);
        //20260216 Igor >>>
        AddTag(6, 't1134:TotalGrossFromOtherForeignAffiliate', GetAmountValue(74), OPTIONAL);
        AddTag(6, 't1134:TotalGrossFromArmsLengthSource', GetAmountValue(75), OPTIONAL);
        AddTag(6, 't1134:TotalGrossFromAllSource', GetAmountValue(78), OPTIONAL);
        AddTag(6, 't1134:TotalGrossFromAllSourceCurrencyCode', GetValue(79), OPTIONAL);

        if (FetchElm(RetNo, 'INFO', 3).Equals('870000643')) and (Suppl = 3) then
        begin
          AddTag(6, 't1134:InterestAmountFromOtherForeignAffiliate', IfThen(not GetValue(83).IsEmpty and GetAmountValue(80).IsEmpty, '0', GetAmountValue(80)), OPTIONAL);
          AddTag(6, 't1134:InterestAmountFromArmsLengthSource', IfThen(not GetValue(83).IsEmpty and GetAmountValue(81).IsEmpty, '0', GetAmountValue(81)), OPTIONAL);
          AddTag(6, 't1134:InterestAmountFromAllSource', IfThen(not GetValue(83).IsEmpty and GetAmountValue(82).IsEmpty, '0', GetAmountValue(82)), OPTIONAL);
          AddTag(6, 't1134:InterestCurrencyCode', GetValue(83), OPTIONAL);
        end else
        begin
          AddTag(6, 't1134:InterestAmountFromOtherForeignAffiliate', GetAmountValue(80), OPTIONAL);
          AddTag(6, 't1134:InterestAmountFromArmsLengthSource', GetAmountValue(81), OPTIONAL);
          AddTag(6, 't1134:InterestAmountFromAllSource', GetAmountValue(82), OPTIONAL);
          AddTag(6, 't1134:InterestCurrencyCode', GetValue(83), OPTIONAL);
        end;

        AddTag(6, 't1134:DividendAmountFromOtherForeignAffiliate', GetAmountValue(84), OPTIONAL);
        AddTag(6, 't1134:DividendAmountFromArmsLengthSource', GetAmountValue(85), OPTIONAL);
        AddTag(6, 't1134:DividendAmountFromAllSource', GetAmountValue(86), OPTIONAL);
        AddTag(6, 't1134:DividendCurrencyCode', GetValue(87), OPTIONAL);
        AddTag(6, 't1134:RoyaltyAmountFromOtherForeignAffiliate', GetAmountValue(88), OPTIONAL);
        AddTag(6, 't1134:RoyaltyAmountFromArmsLengthSource', GetAmountValue(89), OPTIONAL);
        AddTag(6, 't1134:RoyaltyAmountFromAllSource', GetAmountValue(90), OPTIONAL);
        AddTag(6, 't1134:RoyaltyCurrencyCode', GetValue(91), OPTIONAL);

        if (FetchElm(RetNo, 'INFO', 3).Equals('870000643')) and (Suppl = 3) then
        begin
          AddTag(6, 't1134:RentalLeaseActivityAmountFromOtherForeignAffiliate', IfThen(not GetValue(95).IsEmpty and GetAmountValue(92).IsEmpty, '0', GetAmountValue(92)), OPTIONAL);
          AddTag(6, 't1134:RentalLeaseActivityAmountFromArmsLengthSource', IfThen(not GetValue(95).IsEmpty and GetAmountValue(93).IsEmpty, '0', GetAmountValue(93)), OPTIONAL);
          AddTag(6, 't1134:RentalLeaseActivityAmountFromAllSource', IfThen(not GetValue(95).IsEmpty and GetAmountValue(94).IsEmpty, '0', GetAmountValue(94)), OPTIONAL);
          AddTag(6, 't1134:RentalLeaseActivityCurrencyCode', GetValue(95), OPTIONAL);
          AddTag(6, 't1134:LoanLendingActivityAmountFromOtherForeignAffiliate', IfThen(not GetValue(99).IsEmpty and GetAmountValue(96).IsEmpty, '0', GetAmountValue(96)), OPTIONAL);
          AddTag(6, 't1134:LoanLendingActivityAmountFromArmsLengthSource', IfThen(not GetValue(99).IsEmpty and GetAmountValue(97).IsEmpty, '0', GetAmountValue(97)), OPTIONAL);
          AddTag(6, 't1134:LoanLendingActivityAmountFromAllSource', IfThen(not GetValue(99).IsEmpty and GetAmountValue(98).IsEmpty, '0', GetAmountValue(98)), OPTIONAL);
          AddTag(6, 't1134:LoanLendingActivityCurrencyCode', GetValue(99), OPTIONAL);
          AddTag(6, 't1134:InsuranceReinsuranceRiskAmountFromOtherForeignAffiliate', IfThen(not GetValue(103).IsEmpty and GetAmountValue(100).IsEmpty, '0', GetAmountValue(100)), OPTIONAL);
          AddTag(6, 't1134:InsuranceReinsuranceRiskAmountFromArmsLengthSource', IfThen(not GetValue(103).IsEmpty and GetAmountValue(101).IsEmpty, '0', GetAmountValue(101)), OPTIONAL);
          AddTag(6, 't1134:InsuranceReinsuranceRiskAmountFromAllSource', IfThen(not GetValue(103).IsEmpty and GetAmountValue(102).IsEmpty, '0', GetAmountValue(102)), OPTIONAL);
          AddTag(6, 't1134:InsuranceReinsuranceRiskCurrencyCode', GetValue(103), OPTIONAL);
        end else
        begin
          AddTag(6, 't1134:RentalLeaseActivityAmountFromOtherForeignAffiliate', GetAmountValue(92), OPTIONAL);
          AddTag(6, 't1134:RentalLeaseActivityAmountFromArmsLengthSource', GetAmountValue(93), OPTIONAL);
          AddTag(6, 't1134:RentalLeaseActivityAmountFromAllSource', GetAmountValue(94), OPTIONAL);
          AddTag(6, 't1134:RentalLeaseActivityCurrencyCode', GetValue(95), OPTIONAL);
          AddTag(6, 't1134:LoanLendingActivityAmountFromOtherForeignAffiliate', GetAmountValue(96), OPTIONAL);
          AddTag(6, 't1134:LoanLendingActivityAmountFromArmsLengthSource', GetAmountValue(97), OPTIONAL);
          AddTag(6, 't1134:LoanLendingActivityAmountFromAllSource', GetAmountValue(98), OPTIONAL);
          AddTag(6, 't1134:LoanLendingActivityCurrencyCode', GetValue(99), OPTIONAL);
          AddTag(6, 't1134:InsuranceReinsuranceRiskAmountFromOtherForeignAffiliate', GetAmountValue(100), OPTIONAL);
          AddTag(6, 't1134:InsuranceReinsuranceRiskAmountFromArmsLengthSource', GetAmountValue(101), OPTIONAL);
          AddTag(6, 't1134:InsuranceReinsuranceRiskAmountFromAllSource', GetAmountValue(102), OPTIONAL);
          AddTag(6, 't1134:InsuranceReinsuranceRiskCurrencyCode', GetValue(103), OPTIONAL);
        end;

        AddTag(6, 't1134:FactoringTradeAccountsRecievableAmountFromOtherForeignAffiliate', GetAmountValue(104), OPTIONAL);
        AddTag(6, 't1134:FactoringTradeAccountsRecievableAmountFromArmsLengthSource', GetAmountValue(105), OPTIONAL);
        AddTag(6, 't1134:FactoringTradeAccountsRecievableAmountFromAllSource', GetAmountValue(106), OPTIONAL);
        AddTag(6, 't1134:FactoringTradeAccountsRecievableCurrencyCode', GetValue(107), OPTIONAL);
        AddTag(6, 't1134:DispositionInvestmentPropertyAmountFromOtherForeignAffiliate', GetAmountValue(108), OPTIONAL);
        AddTag(6, 't1134:DispositionInvestmentPropertyAmountFromArmsLengthSource', GetAmountValue(109), OPTIONAL);
        AddTag(6, 't1134:DispositionInvestmentPropertyAmountFromAllSource', GetAmountValue(110), OPTIONAL);
        AddTag(6, 't1134:DispositionInvestmentPropertyCurrencyCode', GetValue(111), OPTIONAL);
        AddEndTag(4, 't1134:ControlledForeignAffiliateRevenueComposition', OPTIONAL);
        //20260216 Igor <<<

        AddBeginTag(4, 't1134:ForeignAccrualPropertyIncome');
        AddBeginTag(6, 't1134:ForeignAccrualPropertyIncomeGeneralInformation');
        AddTag(8, 't1134:ForeignAccrualPropertyIncomeIndicator', GetYesNoValue(250,251), OPTIONAL);
        AddTag(8, 't1134:ForeignAccrualPropertyLossIndicator', GetYesNoValue(112,113), OPTIONAL);
        AddTag(8, 't1134:ForeignAccrualPropertyIncomeCaptialGainIndicator', GetYesNoValue(114,115), OPTIONAL);
        AddTag(8, 't1134:ForeignAccrualCapitalLossesIndicator', GetYesNoValue(116,117), OPTIONAL);
        AddTag(8, 't1134:PreviousForeignAccrualPropertyLossApplyIndicator', GetYesNoValue(118,119), OPTIONAL);
        AddTag(8, 't1134:PreviousForeignAccrualCapitalLossesApplyIndicator', GetYesNoValue(120,121), OPTIONAL);
        AddTag(8, 't1134:CurrentForeignAccrualPropertyLossApplyIndicator', GetYesNoValue(122,123), OPTIONAL);
        AddTag(8, 't1134:CurrentForeignAccrualCapitalLossesApplyIndicator', GetYesNoValue(124,125), OPTIONAL);
        AddTag(8, 't1134:Subsection95_2_44_ElectionFiledIndicator', GetYesNoValue(126,127), OPTIONAL);
        //20230619 Igor <<<
        AddEndTag(6, 't1134:ForeignAccrualPropertyIncomeGeneralInformation');
        // reporting entity participation percentage
        ArrayNo := 16;
        BoxesPerRow := RetList[RetNo].Frm[FormNo].FormDataRec.BoxesPerRow[ArrayNo];
        nElm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FormNo, ArrayNo);
        For i := 0 to RowCount - 1 do
        begin
          AddBeginTag(6, 't1134:ReportingEntityParticipatingPercentage');
          AddTag(8, 't1134:ParticipatingEntitySequenceNumber', GetGroupSequenceNumber(GetValue(nElm + 1)));
          AddTag(8, 't1134:ParticipatingEntityAccountNumber', GetValue(nElm + 1));
          AddTag(8, 't1134:ParticipatingPercentage', GetValue(nElm + 2) + IfThen(Pos('.', GetValue(nElm + 2)) > 0, '', '.00')); //20260212 Igor
          AddTag(8, 't1134:ParticipatingPercentageChangeIndicator', GetYesNoValue(nElm + 3, nElm + 4));
          AddEndTag(6, 't1134:ReportingEntityParticipatingPercentage');
          nElm := nElm + BoxesPerRow;
        end;

        //20230619 Igor >>>
        AddBeginTag(6, 't1134:ForeignAccrualPropertyIncomeLossGrossAmount');
        AddTag(8, 't1134:PropertyIncomeAmountSubsection95_1', GetAmountValue(58), OPTIONAL);
        AddTag(8, 't1134:PropertyLossAmountSubsection95_1', GetAmountValue(59), OPTIONAL);
        AddTag(8, 't1134:SaleOfPropertyIncomeAmountParagraph95_2_a_1', GetAmountValue(128), OPTIONAL);
        AddTag(8, 't1134:SaleOfPropertyLossAmountParagraph95_2_a_1', GetAmountValue(129), OPTIONAL);
        AddTag(8, 't1134:RiskInsuranceReinsuranceIncomeAmountParagraph95_2_a_2', GetAmountValue(130), OPTIONAL);
        AddTag(8, 't1134:RiskInsuranceReinsuranceLossAmountParagraph95_2_a_2', GetAmountValue(131), OPTIONAL);
        AddTag(8, 't1134:CanadianIndebtednessLeaseObligationsIncomeAmountParagraph95_2_a_3', GetAmountValue(132), OPTIONAL);
        AddTag(8, 't1134:CanadianIndebtednessLeaseObligationsLossAmountParagraph95_2_a_3', GetAmountValue(133), OPTIONAL);
        AddTag(8, 't1134:PartnershipIndebtednessLeaseObligationsIncomeAmountParagraph95_2_a_4', GetAmountValue(134), OPTIONAL);
        AddTag(8, 't1134:PartnershipIndebtednessLeaseObligationsLossAmountParagraph95_2_a_4', GetAmountValue(135), OPTIONAL);
        AddTag(8, 't1134:ProvidingServicesIncomeAmountParagraph95_2_b', GetAmountValue(136), OPTIONAL);
        AddTag(8, 't1134:ProvidingServicesLossAmountParagraph95_2_b', GetAmountValue(137), OPTIONAL);
        AddTag(8, 't1134:PropertyIncomeAmountParagraph95_2_i', GetAmountValue(138), OPTIONAL);
        AddTag(8, 't1134:PropertyLossAmountParagraph95_2_i', GetAmountValue(139), OPTIONAL);
        AddTag(8, 't1134:DispositionOfCapitalPropertySharesIncomeAmount', GetAmountValue(140), OPTIONAL);
        AddTag(8, 't1134:DispositionOfCapitalPropertySharesLossAmount', GetAmountValue(141), OPTIONAL);
        AddTag(8, 't1134:DispositionOfCapitalPropertyOthersIncomeAmount', GetAmountValue(142), OPTIONAL);
        AddTag(8, 't1134:DispositionOfCapitalPropertyOthersLossAmount', GetAmountValue(143), OPTIONAL);
        AddTag(8, 't1134:DescriptionCInDefinitionAmountSubsection95_1', GetAmountValue(144), OPTIONAL);
        AddTag(8, 't1134:ForeignAccrualPropertyIncomeTotalAmount', GetAmountValue(145), OPTIONAL);
        AddTag(8, 't1134:ForeignAccrualPropertyLossTotalAmount', GetAmountValue(146), OPTIONAL);
        AddEndTag(6, 't1134:ForeignAccrualPropertyIncomeLossGrossAmount', OPTIONAL);
        //20230619 Igor <<<

        AddEndTag(4, 't1134:ForeignAccrualPropertyIncome');

        //20230619 Igor >>>
        AddBeginTag(4, 't1134:OtherActiveBusinessIncome');
        AddBeginTag(6, 't1134:IncludeIncomeFromProperty');
        AddTag(8, 't1134:IncludeIncomeFromPropertyIndicator', GetYesNoValue(147,148), OPTIONAL);
        AddTag(8, 't1134:DueToAct_95_2_a_Indicator', GetYesNoValue(149,150), OPTIONAL);
        AddTag(8, 't1134:DueToAct_95_1_Indicator', GetYesNoValue(151,152), OPTIONAL);
        AddTag(8, 't1134:DueToAct_95_2_l_Indicator', GetYesNoValue(153,154), OPTIONAL);
        AddEndTag(6, 't1134:IncludeIncomeFromProperty', OPTIONAL);
        AddBeginTag(6, 't1134:IncludeIncomeFromBusiness');
        AddTag(8, 't1134:IncludeIncomeFromBusinessIndicator', GetYesNoValue(155,156), OPTIONAL);
        AddTag(8, 't1134:DueToAct_90PercentTest_Indicator', GetYesNoValue(157,158), OPTIONAL);
        AddTag(8, 't1134:DueToAct_95_2_3_Indicator', GetYesNoValue(159,160), OPTIONAL);
        AddTag(8, 't1134:DueToAct_95_2_4_Indicator', GetYesNoValue(161,162), OPTIONAL);
        AddTag(8, 't1134:DueToAct_95_3_Indicator', GetYesNoValue(163,164), OPTIONAL);
        AddTag(8, 't1134:DueToAct_95_3_01_Indicator', GetYesNoValue(165,166), OPTIONAL);
        AddEndTag(6, 't1134:IncludeIncomeFromBusiness', OPTIONAL);
        AddEndTag(4, 't1134:OtherActiveBusinessIncome', OPTIONAL);
        //20230619 Igor <<<
      //20260213 Igor >>>
      end else
      begin
        AddBeginTag(4, 't1134:OtherActiveBusinessIncome');
        AddBeginTag(6, 't1134:IncludeIncomeFromProperty');
        AddTag(8, 't1134:IncludeIncomeFromPropertyIndicator', '0');
        AddEndTag(6, 't1134:IncludeIncomeFromProperty', OPTIONAL);
        AddBeginTag(6, 't1134:IncludeIncomeFromBusiness');
        AddTag(8, 't1134:IncludeIncomeFromBusinessIndicator', '0');
        AddEndTag(6, 't1134:IncludeIncomeFromBusiness', OPTIONAL);
        AddEndTag(4, 't1134:OtherActiveBusinessIncome', OPTIONAL);
      end;
      //20260213 Igor <<<
      AddTag(4, 't1134:InformationRequestedNotAvailableIndicator', GetYesNoValue(288,289));
      AddTag(4, 't1134:InformationRequestedNotAvailableSummaryDescription', GetCombinedStrValue(290, 293), OPTIONAL); //20230619 Igor

      AddEndTag(2, 't1134:ControlledAndNotControlledForeignAffiliateSupplement');
    end;

    AddEndTag(0, 't1134:ControlledAndNotControlledForeignAffiliateReturn');

    for I := 1 to FList.Count - 1 do
      FList.Strings[I] := Space(ABaseIndent) + FList.Strings[I];
    Result := FList.Text;
  finally
    FList.Free;
    ForeignAffiliateList.Free;
  end;
  //20230510 Igor <<<
end;

procedure TEfileT1134T1_2026.FormShow(Sender: TObject);
Var OnlineNo,Password,Url,NetFileDir,FileExt:String;
begin
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);
  ProductionOrTestGroup.ItemIndex:= 0;  //20180824 CON default to Production
  ProdOrTest:= 'P'; //20251229 Igor
  RetNo:= GetCurrentRetNo;
  SoftwareId:= 'VT51';//FRRMSsoftwareId; //'VT46'; //20260108 Igor
  FT1134RDir:= TPath.Combine(NetFileDir, 'T1134'); // 20180731 Igor
  if FileExists(GetSubmittedFileName) then
  begin
    edSubmittedFile.Text := GetSubmittedFileName;
    MemoFile.Lines.LoadFromFile(GetSubmittedFileName);
  end;
  if FileExists(GetReceivedFileName) then
  begin
    edReceivedFile.Text := GetReceivedFileName;
    MemoLog.Lines.LoadFromFile(GetReceivedFileName);
    MemoLog.Text := ReplaceStr(ClearXml(MemoLog.Text), '><', '>' + #13#10 + '<');
  end;
  if FileExists(GetReceivedHTMLFileName) then
    edReceivedHTMLFile.Text := GetReceivedHTMLFileName;
end;

function TEfileT1134T1_2026.GetReceivedFileName: string;
begin
  ForceDirectories(FT1134RDir);
  Result := TPath.Combine(FT1134RDir, RetList[RetNo].SourceFlName + '-RECEIVED.XML'); // 20180731 Igor
end;

function TEfileT1134T1_2026.GetReceivedHTMLFileName: string;
begin
  ForceDirectories(FT1134RDir);
  Result := TPath.Combine(FT1134RDir, RetList[RetNo].SourceFlName + '-RECEIVED.HTML'); // 20180731 Igor
end;

function TEfileT1134T1_2026.GetSubmittedFileName: string;
begin
  ForceDirectories(FT1134RDir);
  Result := TPath.Combine(FT1134RDir, RetList[RetNo].SourceFlName + '-SUBMITTED.XML'); // 20180731 Igor
end;

procedure TEfileT1134T1_2026.ProductionOrTestGroupClick(Sender: TObject);
begin
  // testing mode
  if ProductionOrTestGroup.ItemIndex = 1 then  //test
  begin
    UrlForWebServices.Text := 'https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';
    ProdOrTest:= 'T'; //20251229 Igor
  end
  else
  begin
    ProductionOrTestGroup.ItemIndex := 0;
    UrlForWebServices.Text := 'https://apps.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';   //20190530
    ProdOrTest:= 'P'; //20251229 Igor
  end;
end;

procedure TEfileT1134T1_2026.WebServiceEfile;
var
 SoapMessage, SoapBody: string;
begin
  SoapMessage:= GetT1EfileReturnRequestForT1134(LeftStr(FetchElm(RetNo, 'T1134', 20), 4));
  SoapBody := CreateBody(17);
  SoapMessage := ReplaceStr(SoapMessage, '%BODY%', SoapBody);
  MemoFile.Clear;
  MemoFile.Lines.Add(SoapMessage);
end;

procedure TEfileT1134T1_2026.btnDownClick(Sender: TObject); //20230712 Igor
var lTemp: string;
begin
  if (FAList.ItemIndex > -1) and (FAList.ItemIndex < FAList.Count - 1) then
  begin
    lTemp := FAList.Items[FAList.ItemIndex];
    FAList.Items[FAList.ItemIndex] := FAList.Items[FAList.ItemIndex + 1];
    FAList.Items[FAList.ItemIndex + 1] := lTemp;
    FAList.ItemIndex := FAList.ItemIndex + 1;
    SaveFAList;
  end;
end;

procedure TEfileT1134T1_2026.btnManageFAListClick(Sender: TObject); //20230712 Igor
begin
  if pnlFAList.Visible then
  begin
    pnlFAList.Visible := false;
    btnManageFAList.Caption := 'Show FA list';
  end
  else
  begin
    pnlFAList.Visible := true;
    btnManageFAList.Caption := 'Hide FA list';
    ShowFAList;
  end;
end;

procedure TEfileT1134T1_2026.btnUpClick(Sender: TObject); //20230712 Igor
var lTemp: string;
begin
  if FAList.ItemIndex > 0 then
  begin
    lTemp := FAList.Items[FAList.ItemIndex];
    FAList.Items[FAList.ItemIndex] := FAList.Items[FAList.ItemIndex - 1];
    FAList.Items[FAList.ItemIndex - 1] := lTemp;
    FAList.ItemIndex := FAList.ItemIndex - 1;
    SaveFAList;
  end;
end;

procedure TEfileT1134T1_2026.btnViewHTMLClick(Sender: TObject);
var L: TStringList;
begin
  if FileExists(edReceivedHTMLFile.Text) then
  begin
    L := TStringList.Create;
    try
      L.LoadFromFile(edReceivedHTMLFile.Text);
      ShowMessageHTML(L.Text, 600);
    finally
      L.Free;
    end;
  end;
end;

procedure TEfileT1134T1_2026.T1134EfileBtnClick(Sender: TObject);
begin
  WebServiceEfile;
end;

function GetT1EfileReturnRequestForT1134(ATaxYear: string): string; // 20180703 Igor
const
  // these are not used anywhere??
  SoftwareRevisionDate = '2018';//'2023'; //20231221
  SoftwareIDTypeCode = 'T1';
var
  OnlineNo, Password, Url, NetFileDir, s, cd: string;
  RetNo:Integer;  //20180627 con
begin
  RetNo:= GetCurrentRetNo;
  GetEOLParms(OnlineNo, Password, Url, NetFileDir);

  //20210523
  Result:= '<?xml version="1.0" encoding="ISO-8859-1"?>' + #13#10 +
    '<soapenv:Envelope' + #13#10 +
    '  xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">' + #13#10 +
    //'  xmlns:t1rq="http://www.cra-arc.gc.ca/xmlns/t1rq/t1efilerequest/1-0-0">'+ #13#10 + //20251229 Igor
    '  <soapenv:Body>'+ #13#10 +

    // from Web_sevices_guides_Finals_EAS/t2efrws_May24e.pdf
    //20251229 Igor >>>
    '    <t1rq:EfileReturnRequest' + #13#10 +
    '      xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"' + #13#10 +
    '      xmlns:comm="http://www.cra-arc.gc.ca/xmlns/comm/2026/1-0-0"' + #13#10 +
    '      xmlns:ef="http://www.cra-arc.gc.ca/xmlns/ef/2026/1-0-0"' + #13#10 +
    '      xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"' + #13#10 +
    '      xmlns:sfd="http://www.cra-arc.gc.ca/xmlns/sfd/2026/1-0-0"' + #13#10 +
    '      xmlns:t1="http://www.cra-arc.gc.ca/xmlns/t1/2026/1-0-0"' + #13#10 +
    '      xmlns:t1134="http://www.cra-arc.gc.ca/xmlns/t1134/2021/1-0-0"' + #13#10 +
    '      xmlns:t1rq="http://www.cra-arc.gc.ca/xmlns/t1rq/efilerequest/1-0-0"' + #13#10 +
    '      xmlns:tp="http://www.cra-arc.gc.ca/xmlns/tp/2026/1-0-0"' + #13#10 +
    '      xmlns:xml="http://www.w3.org/XML/1998/namespace"' + #13#10 +
    '      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' + #13#10 +
    '      xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t1rq/efilerequest/1-0-0 t1wsefilerequest.xsd ">' + #13#10 +
    '      <ef:TransmitterEfilerNumber>' + OnlineNo + '</ef:TransmitterEfilerNumber> '+ #13#10 +
    '      <ef:PasswordID>' + Password + '</ef:PasswordID> '+ #13#10;
    //20251229 Igor <<<

  Result:= Result +
    '      <tp:TaxYear>'+ ATaxYear +'</tp:TaxYear>' + #13#10 +//'      <t1rq:TaxYear>'+ ATaxYear +'</t1rq:TaxYear>' + #13#10 + //20260212 Igor

    '      <ef:EfileData>' + #13#10 +
    '        <ef:PasswordID>' + Password + '</ef:PasswordID>' + #13#10 +
    '        <ef:DocumentControlNumber>' + #13#10 +
    '          <ef:TaxPreparerEfilerNumber>' + OnlineNo + '</ef:TaxPreparerEfilerNumber>' + #13#10;

  Result:= Result +
    '          <ef:TaxPreparerReturnControlNumber>' + GetDcnSeqNoFor(RetNo, OnLineNo) + '</ef:TaxPreparerReturnControlNumber>' + #13#10 +
    '        </ef:DocumentControlNumber>' + #13#10;
//20260225 Igor >>>
  {cd:= '0'; //???? What is it?  //20210129
  Result:= Result + //Removed mandatory element: EfilerNOARetrievalAuthorizationIndicator. // T1 Electronic Filing Schema Change Log - 2025 V1.0
    '        <ef:EfilerNOARetrievalAuthorizationIndicator>' + cd + '</ef:EfilerNOARetrievalAuthorizationIndicator>' + #13#10;
  }
  //20260225 Igor <<<
  cd:= IfThen(not FetchElm(RetNo, 'INFO', 105).Equals(''), '2', IfThen(not FetchElm(RetNo, 'INFO', 106).Equals(''), '3', '0'));
  Result:= Result +
    '        <ef:TaxPreparerPreAssessmentReviewContactCode>' + cd + '</ef:TaxPreparerPreAssessmentReviewContactCode>' + #13#10;

  cd:= IfThen(not FetchElm(RetNo, 'INFO', 134).Equals(''), '2', IfThen(not FetchElm(RetNo, 'INFO', 135).Equals(''), '3', '0'));
  Result:= Result +
    '        <ef:TaxPreparerPostAssessmentReviewContactCode>' + cd + '</ef:TaxPreparerPostAssessmentReviewContactCode>' + #13#10;

  //if Strings[22]='' then Strings[22]:='N'; //do not copy from configure

  //dine in calc If OptRec.Prp_RepId>'' then Strings[16]:=OptRec.Prp_RepId;  //20221226
  //20260212 Igor >>>
  //20220209
  //if UpperCase(FetchElm(RetNo, 'INFO', 144)).Equals('Y') then //20260212 Igor
  begin
    Result:= Result +
    '        <ef:T183ElectronicSignatureData>' + #13#10 +
    //cd:='1' else cd:=''; //'0';
    '          <ef:T183ElectronicSignatureIndicator>' + IfThen(UpperCase(FetchElm(RetNo, 'INFO', 144)).Equals('Y'), '1', '0') + '</ef:T183ElectronicSignatureIndicator>' + #13#10 + //20260212 Igor
    '        </ef:T183ElectronicSignatureData>' + #13#10;
  end;

  s:= FetchElm(RetNo, 'T183', 23); //20230215
  if not s.Equals('') then Result:= Result + '        <ef:RepresentativeID>' + s + '</ef:RepresentativeID>' + #13#10;
  //20260212 Igor <<<

  Result:= Result +
    '      </ef:EfileData>' + #13#10;

  //Mandatory
  s:= IfThen(not FetchElmFNo(RetNo, InfoFNo, 139).Equals(''), '1', '0');
  Result:= Result +
    '      <comm:FirstTimeFilerIndicator>' + s + '</comm:FirstTimeFilerIndicator>' + #13#10;

  if ProdOrtest.Equals('T') then
  begin
    if (MessageDlg('Enter Test Case Identifier?', mtInformation, [mbYes, mbNo], 0) = mrYes) then //always use testcaseid
    begin
      InputQuery('testcaseId', 'enter a value', s);  //20230216
      {
      //s:=AllTrim(GetTestCaseId(RetNo,GetSinNo(RetNo)));  //20171220
      if GetSinno(RetNo)='870000460' then s:='794';  //20200213     #35
      if GetSinno(RetNo)='870000718' then s:='795';  //#57
      if GetSinno(RetNo)='870001427' then s:='796';  //90 normal    //20220210
      //***** USE 7988 for amended
      }
      //case identifiers in testing
      if not s.Equals('') then
        Result:= Result + '      <comm:TestCaseIdentifier>' + s + '</comm:TestCaseIdentifier>' + #13#10
      else
      begin
        ShowMessage('TestCase number missing on Return: ' + GetSinNo(RetNo)); //20171220
        Result:= Result + '      <comm:TestCaseIdentifier>9999</comm:TestCaseIdentifier>' + #13#10; //optional? //20171206 //20200126
      end
    end else  //no testcaseindicator
       Result:= Result + '      <comm:TestCaseIdentifier>9999</comm:TestCaseIdentifier>' + #13#10; //optional? //20171206  //20200126
  end;

  s:= '0.0.0.0'; //20200207
  //s:= GetIPAddress(); //if want to actaully get the IP address instead of just giving the default
  Result:= Result +
    '      <comm:OriginatingIP>' + s + '</comm:OriginatingIP>' + #13#10;

  Result:= Result +
    '      <t1rq:TaxReturnForm>' + #13#10 +

    '        %BODY% '+

    '      </t1rq:TaxReturnForm>' + #13#10 +
    '    </t1rq:EfileReturnRequest>' + #13#10 + //20251229 Igor
    '  </soapenv:Body>' + #13#10 +
    '</soapenv:Envelope>';
end;

function ParseXmlResponse(Response, ATitle, AFileName: string; var AConfirmNumber: string): boolean; // 20180625 Igor // 20180824 Igor
var
  X: XML.XMLDoc.TXMLDocument;
  Node, CodeNode: IXMLNode;
  ACode, ACaption, AMessage, ALines: string;
  I: integer;
  RetNo : integer;

  procedure ShowHTML(ACaption, ACode, ALines: string; AError: boolean); // 20180625 Igor
  var L: TStringList;
      A: TArray<string>;
      I: integer;
      cColor: string;
  begin
    // 20180626 Igor >>>
    ACaption := HTMLEscape(ACaption);
    ALines := HTMLEscape(ALines);
    // 20180626 Igor <<<
    if AError then
      cColor := 'red'
    else
      cColor := 'green';
    L := TStringList.Create;
    try
	  // 20180626 Igor >>>
      L.Add('<HTML><HEAD>');
      L.Add('<META CHARSET="UTF-8">');
      L.Add('<TITLE>T2 EFile Service</TITLE>');
      L.Add('</HEAD>');
      L.Add('<BODY>');
      L.Add('<DIV id="contentheader">');
      L.Add('<H1><FONT size=5><STRONG>'+ ATitle+'</STRONG></FONT></H1>');
      L.Add('<H2><FONT color='+ cColor +' size=5><STRONG>'+ ACaption +'</STRONG></FONT></H2>');
      L.Add('<P>Received: '+ DateTimeToStr(Now) +'</P>');
      L.Add('<HR>');

      L.Add('<P></P>');
      L.Add('<P><FONT size=3 face="arial, helvetica, sans-serif"><strong>Result Code:</strong> '+ ACode +'</FONT></P>');
      A := ALines.Split([#13], ExcludeEmpty);
      for i := 0 to Length(A) - 1 do
      begin
        L.Add('<P><FONT size=3 face="arial, helvetica, sans-serif">'+
          '<strong>' +
          Copy(A[i], 1, Pos(':', A[i])) +
          '</strong>'+
          Copy(A[i], Pos(':', A[i]) + 1, Length(A[i])) +
          '</FONT></P>');
      end;
      L.Add('</DIV></BODY></HTML>');
      // 20180626 Igor <<<
      L.SaveToFile(AFileName, TEncoding.UTF8);
      ShowMessageHTML(L.Text, 600);
    finally
      L.Free;
    end;
  end;

  function GetNodeValue(ANode: IXMLNode; ANodeName: string; ACaption: string = ''): string; // 20180625 Igor
  var TNode: IXMLNode;
  begin
    Result := '';
    TNode := ANode.ChildNodes.FindNode(ANodeName);
    if Assigned(TNode) then
    begin
      if not SameText(ACaption, '') then
        Result := ACaption + ': ';
      Result := Result + TNode.NodeValue;
    end;
  end;

  function GetNodeMessage(ANode: IXMLNode): string; // 20180625 Igor
  var TNode: IXMLNode;
      TNodeInner: IXMLNode;
      AMessage: string;
      i,j: integer;
  begin
    Result := '';
    TNode := Node.ChildNodes.FindNode('EnglishMessage');
    AMessage := '';
    for i := 0 to  TNode.ChildNodes.Count - 1 do
    begin
      if AMessage <> '' then
        AMessage := AMessage + '    '; //#13; //'<br>';

      //20210604 jz
      //showmessage(TNode.ChildNodes.Nodes[I].NodeName);
      if TNode.ChildNodes.Nodes[i].NodeName = 'Hyperlink' then
      begin
        TNodeInner := TNode.ChildNodes.Nodes[i];
        for j := 0 to  TNodeInner.ChildNodes.Count - 1 do
        begin
          if AMessage <> '' then
            AMessage := AMessage + ' '; //#13; //'<br>';

          //showmessage(TNode.ChildNodes.Nodes[I].NodeName);
          AMessage := AMessage + TNodeInner.ChildNodes.Nodes[j].NodeValue;
        end;
        break;
      end;

      AMessage := AMessage + TNode.ChildNodes.Nodes[I].NodeValue;

    end;
    if not SameText(AMessage, '') then
      Result := Result + 'English message: '+ AMessage + #13;

    {
    TNode := Node.ChildNodes.FindNode('FrenchMessage');
    AMessage := '';
    for I := 0 to  TNode.ChildNodes.Count - 1 do
    begin
      if AMessage <> '' then
        AMessage := AMessage + '<br>';
      AMessage := AMessage + TNode.ChildNodes.Nodes[I].NodeValue;
    end;
    if not SameText(AMessage, '') then
      Result := Result + 'French message: '+ AMessage + #13;
    }

  end; //GetNodeMessage --------------------------------------------------------

begin
  Result := false;
  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try
      X.XML.Clear;
      X.XML.Add(ClearXML(Response));
      if not(X.Active) then
        X.Active := true;
      Node := X.DocumentElement;
      if (Node = nil) or (Node.NodeName <> 'Envelope') then
        raise Exception.Create('Bad Response XML structure: ' + Response);
      Node := Node.ChildNodes.FindNode('Body');
      if (Node = nil) then
        raise Exception.Create('Bad Response XML structure: ' + Response);
      Node := Node.ChildNodes.First;
      if (Node = nil) then
        raise Exception.Create('Bad Response XML structure: ' + Response);
      if SameText(Node.NodeName, 'Fault') then
      begin
        ACaption := 'Unsuccessful Response';
        ACode := Node.ChildNodes.FindNode('faultcode').NodeValue;
        AMessage := 'Message: ' + Node.ChildNodes.FindNode('faultstring').NodeValue;
        ShowHtml(ACaption, ACode, AMessage, true); // 20180625 Igor
        Exit;
      end;
      if SameText(Node.NodeName, 'FrrmsEfileReturnResponse') or SameText(Node.NodeName, 'T1NetfileReturnResponse') then //20251229 Igor
      begin
        // 20180625 Igor >>>
        AConfirmNumber := GetNodeValue(Node, 'TransmissionNumber'); //20251229 Igor
        ACode := GetNodeValue(Node, 'ResultCode'); //20251229 Igor
        ALines := ALines + GetNodeValue(Node, 'TransmissionNumber', 'Transmission Number') + #13; //20251229 Igor
        ALines := ALines + GetNodeValue(Node, 'IndividualFirstName', 'Individual First Name') + #13;
        ALines := ALines + GetNodeValue(Node, 'IndividualLastName', 'Individual Last Name') + #13;
        ALines := ALines + GetNodeValue(Node, 'IndividualSIN', 'Individual SIN') + #13;
        ALines := ALines + GetNodeValue(Node, 'TaxYear', 'Tax Year') + #13;
        Node := Node.ChildNodes.FindNode('FileReturnResponse');
        if Assigned(Node) then
          Node := Node.ChildNodes.First;
        if Assigned(Node) then
        begin
          if SameText(Node.NodeName, 'Confirmation') then
          begin
            ACaption := Node.NodeName;
            ALines := ALines + GetNodeMessage(Node);
            ShowHTML(ACaption, ACode, ALines, false);
            Result := true;
            Exit;
          end
          else if SameText(Node.NodeName, 'Rejection') or
                  SameText(Node.NodeName, 'SystemError') then
          begin
            ACaption := Node.NodeName;

            //20180720 add info not included in cra response
            RetNo := GetCurrentRetNo;
            //ALines := ALines + 'T2 Transmission Number: ' + '???' + #13;

            ALines := ALines + 'First Name: ' +  GetFirstName(RetNo) + #13;
            ALines := ALines + 'Last Name: ' + GetLastName(RetNo) + #13;
            ALines := ALines + 'SIN: ' + GetSinNo(RetNo) + #13;

            ALines := ALines + GetNodeMessage(Node);
            ShowHTML(ACaption, ACode, ALines, true);
          end;
          // 20180625 Igor <<<
        end
        else
          ShowMessage('Invalid Response Message');
      end;
    except on E: Exception do
      begin
        ShowMessage('Error occured while processing CRA SOAP response: '+ #13 + E.Message + #13#13 + 'Response: '+ Response);
      end;
    end;
  finally
    X.Free;
  end;
end;

end.
