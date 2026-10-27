unit T1_2026t1013efile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl,
  T1_2026TrimStr, T1_2026Declare, T1_2026Common, T1_2026Common2, Db, DBTables, Grids, DBGrids,//20160119 Igor
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  //MSSOAPLib30_TLB,     //does not seem to be needed for sending receiving  //20110129 it has dom
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, vtLabel, vtPanel, //20110129  NEEDED for connection and the response handler
  System.Generics.Collections; //20220113 Igor

 //20240207 dates
 Const SOFTRELEASEYEAR   = '2026'; //'2024';  //20230204
 Const SOFTRELEASEMONTH  = '02'; //'02';
 Const SOFTRELEASEDAY    = '14'; //23'; //'20'; //'15'; //20220214
 Const CrLf         =  Chr(13)+Chr(10);
 Const SoftVendor   =  '064H';

//20220113 Igor >>> 
type
  TSubmittedForm = record
    FlName: String;
  end;
//20220113 Igor <<<  

//1013 FIXED TYPE
Type
 AT1013FX   = Record
 UDN                : string[25];
 //part 1
 taxPayerFirstName  : string[30];
 taxPayerlastName   : string[30];
 SIN                : string[9];
 //part 2
 repID              : string[7];
 groupID            : string[6];
 BN                 : string[9];
 authLevel          : string[1];
 //part 3
 repFirstName       : string[30];
 repLastName        : string[30];
 repBusinessName    : string[60];
 repTelephoneNumber : string[10];
 repExt             : string[6];
 repFax             : string[10];
 allTaxYearsCB      : string[1];
 authLevelAllYears  : string[1];
 specificTaxYearsCB : string[1];
 //tables
 specificTaxYears   : array[1..10] of string[4];
 specificauthLevel  : array[1..10] of string[1];
 //part 4
 expiryDate         : string[8];
 expiryDateYear     : string[4];
 expiryDateMonth    : string[2];
 expiryDateDay      : string[2];
 //part 5
 cancelAllCB        : string[1];
 cancelSpecificCB   : string[1];
 repFirstNameCancel : string[30];
 repLastNameCancel  : string[30];
 repBusinessCancel  : string[60];
 repIDCancel        : string[7];
 groupIDCancel      : string[6];
 BNCancel           : string[9];
 //part 6
 PrintName          : string[60];
 LegalSignatureCB   : string[1];
 SignatureDate      : string[8];
 SignatureDateYear  : string[4];
 SignatureDateMonth : string[2];
 SignatureDateDay   : string[2];
 VendorCertCode     : string[4];
end;

type
  TT1013EfileT1_2026 = class(TForm)
    EfileType: TPanel;
    SubmitBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    BitBtn3: TBitBtn;
    FDConnection: TADConnection;//20160119 Igor
    Table1: TADTable;
    ConfirmDeclineGroup: TRadioGroup;
    OpenDialog1: TOpenDialog;
    pgMain: TPageControl;
    tabSingle: TTabSheet;
    tabMulti: TTabSheet;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel15: TvtLabel;
    EfileOptionGroup: TRadioGroup;
    BatchPanel: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label17: TLabel;
    ListBox1: TListBox;
    OtherBatchButtonsPanel: TPanel;
    BuildBatchBtn: TBitBtn;
    BatchButtonsPanel: TPanel;
    RemoveBtn: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DataDirBox: TEdit;
    DBGrid1: TDBGrid;
    SearchBox: TEdit;
    vtPanel1: TvtPanel;
    TimerClose: TTimer;
    testPanal: TPanel;
    Label2: TLabel;
    Label7: TLabel;
    ShowBtn: TBitBtn;
    TestOrProductionGroup: TRadioGroup;
    UrlBox: TEdit; //20240131 Igor


    procedure GetUrlBox;
    Function  MkSubmittedFileName(RetNo:Integer):String;
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure SubmitBtnClick(Sender: TObject);
    Procedure CreateSoapMessage;
    Procedure CreateSoapHeader(Var TempSoapList:TStringList);
    Procedure CreateSoapFooter(Var TempSoapList:TStringList);
//    Procedure CreateBatchXmlFile;
    Procedure PrepareT1013Rec(RetNo:Integer);
    procedure CreateBatchDetail(HF:string;Var TempSoapList:TStringList);
    procedure CreateXMLFile(RetNo:Integer);

    procedure FormCreate(Sender: TObject);

    Procedure SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);

    Function CreateT1013ResponseHtm(T1013ResponseRec:T1013AckRec;HtmTemplateFileName,ResponseXmlFileName:String):String;
    Function GetT1013ErrorDescr(ErrorCode:String):String;  //20140119 //20220110 Igor
    Function parseT1013Response(ResponseString:AnsiString):T1013AckRec;

    procedure FormActivate(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure EfileOptionGroupClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
   // procedure SelectAllBtnClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    Function  MkSelectedStr: String;
    procedure ListBox1DblClick(Sender: TObject);
    procedure BuildBatchBtnClick(Sender: TObject);
    procedure ShowFiles;
    Procedure CreateBatch;
    procedure TestOrProductionGroupClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure testResponseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject); //20220113 Igor
    procedure TimerCloseTimer(Sender: TObject); //20240131 Igor
  private
    { Private declarations }
    RetNo:Integer;//20160119 Igor
    //20220113 Igor >>>
    sBatchFileSuffix: string;
    arrValidFiles: TArray<Boolean>;
    FormIdToFlName: TDictionary<Integer, String>;
    procedure UpdateSingleOrBatch;
    //20220113 Igor <<<
  public
    { Public declarations }
  end;

var
  T1013Efile: TT1013EfileT1_2026;//20160119 Igor
  Fx1013:AT1013FX;
  userName1013,passWord1013 :string;
  SoapMsg:AnsiString;
  OnLineNo,TransmitterNo,PassWord,FileName,Url,OnlineMethod:String;
  NetFileDir:String;
  FormCnt:Integer;
  T1013EfileDir: String;
  sUrl:String;

  const
  testLastyearsXMLformat=false;

implementation

uses vtMulti,vtCommon,vtMain,T1_2026,//20160119 Igor
  T1_2026MsXml2_TLB,T1_2026main,T1_2026childwinnew,
  Xml.XMLDoc, Xml.XMLIntf, System.RegularExpressions, Variants, //20220113 Igor
  vtTrimStr,vtShared, vtDataBase;

{$R *.DFM}



{
//jz//20250211 //pre 2024
procedure TT1013EfileT1_2026.CreateBatchDetail(HF:string;Var TempSoapList:TStringList);
begin
 if uppercase(HF) = 'HEADER' then
 begin
  with TempSoaplist do
  begin

  (* changes 2013 to 2014  //20141229
http://www.cra-arc.gc.ca/xmlns/sdt/2-0-0
to
http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:tris="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0"
xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"
targetNamespace="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0"
elementFormDefault="qualified"
attributeFormDefault="unqualified"
version="tris/1-0-0">
<xsd:import namespace="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"
schemaLocation="standarddatatypes.xsd"/>
  *)


   add('<tris:BatchRequest xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0" xmlns:tris="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0"' + ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0 crat1013.xsd ">');  //20141229
   //add('<tris:BatchRequest xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-0-0" xmlns:tris="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0"' + ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0 crat1013.xsd ">');

   add('  <tris:BatchDetail>');
   add('    <tris:FormNumber>'     + 'T1013' + '</tris:FormNumber>');
   add('    <tris:BatchFormCount>' + AllTrim(IntToStr(FormCnt))    + '</tris:BatchFormCount>');
   add('    <tris:FormVersion>'+appYear+'</tris:FormVersion>');
   add('    <tris:SoftwareVendorCodeReleaseDate>');
   add('      <tris:ReleaseDate>');
   add('        <tris:FormDateYear>'  + SOFTRELEASEYEAR  + '</tris:FormDateYear>');
   add('        <tris:FormDateMonth>' + SOFTRELEASEMONTH + '</tris:FormDateMonth>');
   add('        <tris:FormDateDay>'   + SOFTRELEASEDAY   + '</tris:FormDateDay>');
   add('      </tris:ReleaseDate>');
   add('      <tris:SoftwareVendorCode>'+ FX1013.VendorCertCode +'</tris:SoftwareVendorCode>');
   add('    </tris:SoftwareVendorCodeReleaseDate>');
   add('  </tris:BatchDetail>');
  end;//END BatchDetail
 end
 else if uppercase(HF) = 'FOOTER' then
 begin
  with TempSoaplist do
  begin
   add('</tris:BatchRequest>');
  end;
 end;
end;
}

procedure TT1013EfileT1_2026.CreateBatchDetail(HF:string;Var TempSoapList:TStringList);
begin
 if uppercase(HF) = 'HEADER' then
 begin





if testLastyearsXMLformat then //just for testing previous year format
begin
  //jz//20250211 //pre 2024
  with TempSoaplist do
  begin
   add('<tris:BatchRequest xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0" xmlns:tris="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0"' + ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0 crat1013.xsd ">');  //20141229
 //add('<tris:BatchRequest xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-0-0" xmlns:tris="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0"' + ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0 crat1013.xsd ">');
   add('  <tris:BatchDetail>');
   add('    <tris:FormNumber>'     + 'T1013' + '</tris:FormNumber>');
   add('    <tris:BatchFormCount>' + AllTrim(IntToStr(FormCnt))    + '</tris:BatchFormCount>');
   add('    <tris:FormVersion>'+appYear+'</tris:FormVersion>');
   add('    <tris:SoftwareVendorCodeReleaseDate>');
   add('      <tris:ReleaseDate>');
   add('        <tris:FormDateYear>'  + SOFTRELEASEYEAR  + '</tris:FormDateYear>');
   add('        <tris:FormDateMonth>' + SOFTRELEASEMONTH + '</tris:FormDateMonth>');
   add('        <tris:FormDateDay>'   + SOFTRELEASEDAY   + '</tris:FormDateDay>');
   add('      </tris:ReleaseDate>');
   add('      <tris:SoftwareVendorCode>'+ FX1013.VendorCertCode +'</tris:SoftwareVendorCode>');
   add('    </tris:SoftwareVendorCodeReleaseDate>');
   add('  </tris:BatchDetail>');
  end;
end
else
begin

  with TempSoaplist do
  begin
   //add('<tris:BatchRequest xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0 crat1013.xsd" xmlns:tris="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0" xmlns:xsi="http://www.w3.org/2001/XMLSchemainstance">');
   add('<tris:BatchRequest xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0" xmlns:tris="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0" ');
   add('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/tris/1-0-0 crat1013.xsd ">');

   add('  <tris:BatchDetail>');
   add('    <tris:FormNumber>'     + 'T1013' + '</tris:FormNumber>');
   add('    <tris:BatchFormCount>' + AllTrim(IntToStr(FormCnt))    + '</tris:BatchFormCount>');
   add('    <tris:FormVersion>'+appYear+'</tris:FormVersion>');
   add('    <tris:SoftwareVendorCodeReleaseDate>');
   add('      <tris:ReleaseDate>');
   add('        <tris:FormDateYear>'  + SOFTRELEASEYEAR  + '</tris:FormDateYear>');
   add('        <tris:FormDateMonth>' + SOFTRELEASEMONTH + '</tris:FormDateMonth>');
   add('        <tris:FormDateDay>'   + SOFTRELEASEDAY   + '</tris:FormDateDay>');
   add('      </tris:ReleaseDate>');
   add('      <tris:SoftwareVendorCode>'+ FX1013.VendorCertCode +'</tris:SoftwareVendorCode>');
   add('    </tris:SoftwareVendorCodeReleaseDate>');
   add('  </tris:BatchDetail>');
  end;//END BatchDetail

end; //else

end
 else if uppercase(HF) = 'FOOTER' then
 begin
  with TempSoaplist do
  begin
   add('</tris:BatchRequest>');
  end;
 end;
end;

procedure TT1013EfileT1_2026.CreateXMLFile(RetNo:Integer);
Var  xmlFileList:Tstringlist;
begin
PrepareT1013Rec(RetNo);

//  userName1013 := 'B0864';
//  passWord1013 := '948789Q';

xmlFileList:=Tstringlist.create;
//XML DATA

xmlFileList.add('  <tris:BatchForms>');
//PreparerSection (Mandatory Group)
xmlFileList.add('    <tris:PreparerSection>');
xmlFileList.add('      <tris:PreparerID>'           + userName1013 + '</tris:PreparerID>');
xmlFileList.add('      <tris:SoftwareVendorCode>'   + FX1013.VendorCertCode + '</tris:SoftwareVendorCode>');
xmlFileList.add('      <tris:UniqueDocumentNumber>' + FX1013.UDN            + '</tris:UniqueDocumentNumber>');
xmlFileList.add('    </tris:PreparerSection>');

//TaxpayerSection (Mandatory Group)
xmlFileList.add('    <tris:TaxpayerSection>');
xmlFileList.add('      <tris:ClientID>'             + FX1013.SIN               + '</tris:ClientID>'); //sin or trust

xmlFileList.add('      <tris:ClientName>');
if AllTrim(FX1013.taxPayerFirstName)>'' then  //20180205 it means if Trust then do not create the first NM
   xmlFileList.add('        <tris:GivenName>'+ FX1013.taxPayerFirstName + '</tris:GivenName>');

xmlFileList.add('        <tris:Surname>'  + FX1013.taxPayerlastName  + '</tris:Surname>'); //contains last name or trust name

xmlFileList.add('      </tris:ClientName>');
xmlFileList.add('    </tris:TaxpayerSection>');

//Part 2 - Authorization Section (Optional Group)
If (AllTrim(FX1013.repID)>'')  Or (AllTrim(FX1013.BN)>'') Or (AllTrim(FX1013.groupID)>'') then
Begin
 xmlFileList.add('    <tris:AuthorizationSection>');
 xmlFileList.add('      <tris:RegisteredRepresentativeAuthorization>');
 xmlFileList.add('        <tris:RegisteredRepresentative>');
 If AllTrim(FX1013.repID) >'' then xmlFileList.add('          <tris:RepresentativeID>' + FX1013.repID   + '</tris:RepresentativeID>');
 If AllTrim(FX1013.BN) >'' then xmlFileList.add('          <tris:BusinessNumber>'   + FX1013.BN      + '</tris:BusinessNumber>');
 If AllTrim(FX1013.RepBusinessName) >'' then xmlFileList.add('          <tris:RepBusinessName>'   + FX1013.RepBusinessName   + '</tris:RepBusinessName>');
 If AllTrim(FX1013.groupID) >'' then xmlFileList.add('          <tris:GroupID>'          + FX1013.groupID + '</tris:GroupID>');
 xmlFileList.add('        </tris:RegisteredRepresentative>');
 xmlFileList.add('        <tris:AuthorizationLevelOfPermission>' + FX1013.authLevel + '</tris:AuthorizationLevelOfPermission>');
 xmlFileList.add('      </tris:RegisteredRepresentativeAuthorization>');
 If AllTrim(FX1013.expiryDateYear)+AllTrim(FX1013.expiryDateMonth)+AllTrim(FX1013.expiryDateMonth) >'' then
 Begin
  xmlFileList.add('      <tris:AuthorizationExpiryDate>');
  xmlFileList.add('        <tris:FormDateYear>'  + FX1013.expiryDateYear  + '</tris:FormDateYear>');
  xmlFileList.add('        <tris:FormDateMonth>' + FX1013.expiryDateMonth + '</tris:FormDateMonth>');
  xmlFileList.add('        <tris:FormDateDay>'   + FX1013.expiryDateDay   + '</tris:FormDateDay>');
  xmlFileList.add('      </tris:AuthorizationExpiryDate>');
 end;
 xmlFileList.add('    </tris:AuthorizationSection>');
end;


//CancelSection (Optional Group)
If AllTrim(FX1013.cancelAllCB)+AllTrim(FX1013.cancelSpecificCB)>'' then
Begin

 xmlFileList.add('    <tris:CancelSection>');

 //removed as per ch11-24e.pdf //jz//20250211
 //If AllTrim(FX1013.cancelAllCB) >'' then  xmlFileList.add('      <tris:CancelAll>' + FX1013.cancelAllCB + '</tris:CancelAll>');

 //CancelSpecific (Optional Group)
 If AllTrim(FX1013.cancelSpecificCB)>'' then
 begin
   xmlFileList.add('      <tris:CancelSpecific>');
   xmlFileList.add('        <tris:CancelSpecificCheck>' + FX1013.cancelSpecificCB + '</tris:CancelSpecificCheck>');


//removed as per ch11-24e.pdf //jz//20250211
{
   //CancelRepresentativeName (Optional Group)
   if AllTrim(FX1013.repLastNameCancel) + AllTrim(FX1013.repFirstNameCancel) + FX1013.repBusinessCancel > '' then
   begin
     xmlFileList.add('        <tris:CancelRepresentativeName>');

     if AllTrim(FX1013.repLastNameCancel) + AllTrim(FX1013.repFirstNameCancel) > '' then
     begin
       xmlFileList.add('          <tris:ClientName>');
       xmlFileList.add('            <tris:GivenName>'    + FX1013.repFirstNameCancel + '</tris:GivenName>');
       xmlFileList.add('            <tris:Surname>'      + FX1013.repLastNameCancel  + '</tris:Surname>');
       xmlFileList.add('          </tris:ClientName>');
     end;

     If AllTrim(FX1013.repBusinessCancel)  > '' then
       xmlFileList.add('          <tris:BusinessName>' + FX1013.repBusinessCancel  + '</tris:BusinessName>');

     xmlFileList.add('        </tris:CancelRepresentativeName>');
   end; //CancelRepresentativeName
}

   //CancelRepresentative (Optional Group)
   If (AllTrim(FX1013.repIDCancel)>'') Or (AllTrim(FX1013.BNCancel)>'')  Or (AllTrim(FX1013.groupIDCancel)>'') then
   begin
     xmlFileList.add('        <tris:CancelRepresentative>');
     If AllTrim(FX1013.repIDCancel)>'' then xmlFileList.add('          <tris:RepresentativeID>' + FX1013.repIDCancel   + '</tris:RepresentativeID>');
     //removed as per ch11-24e.pdf //jz//20250211
     //If AllTrim(FX1013.groupIDCancel)>'' then xmlFileList.add('          <tris:GroupID>'          + FX1013.groupIDCancel + '</tris:GroupID>');
     If AllTrim(FX1013.BNCancel)>'' then xmlFileList.add('          <tris:BusinessNumber>'   + FX1013.BNCancel      + '</tris:BusinessNumber>');
     xmlFileList.add('        </tris:CancelRepresentative>');
   end;
   xmlFileList.add('      </tris:CancelSpecific>');
 end;
 xmlFileList.add('    </tris:CancelSection>');
end;


xmlFileList.add('    <tris:SignatureSection>');
xmlFileList.add('      <tris:PrintedName>'      + FX1013.PrintName        + '</tris:PrintedName>');  //no space after quote 20110114
xmlFileList.add('      <tris:LegalRepresentativeSignature>' + FX1013.LegalSignatureCB + '</tris:LegalRepresentativeSignature>'); //20110114 signiture???
xmlFileList.add('      <tris:SignatureDate>');
xmlFileList.add('        <tris:FormDateYear>'  + FX1013.SignatureDateYear  + '</tris:FormDateYear>');
xmlFileList.add('        <tris:FormDateMonth>' + FX1013.SignatureDateMonth + '</tris:FormDateMonth>');
xmlFileList.add('        <tris:FormDateDay>'   + FX1013.SignatureDateDay   + '</tris:FormDateDay>');
xmlFileList.add('      </tris:SignatureDate>');
xmlFileList.add('    </tris:SignatureSection>');
xmlFileList.add('  </tris:BatchForms>');

xmlFileList.SavetoFile(AppDir+'\'+'T1013Temp.XML');
xmlFileList.Free;
end;

Procedure TT1013EfileT1_2026.PrepareT1013Rec(RetNo:Integer);
    Function monthDayToJulian(month,Day:Word):integer;
    var
        MonthDays:Array[1..12] of integer;
        i,total:integer;
    begin
        MonthDays[1]:=31;
        MonthDays[2]:=28;
        MonthDays[3]:=31;
        MonthDays[4]:=30;
        MonthDays[5]:=31;
        MonthDays[6]:=30;
        MonthDays[7]:=31;
        MonthDays[8]:=31;
        MonthDays[9]:=30;
        MonthDays[10]:=31;
        MonthDays[11]:=30;
        MonthDays[12]:=31;

        total:=0;
        for i:=1 to Month -1  do
        begin
            total := total + MonthDays[i];
        end;
        total := total + Day;
        result := total;
    end;

    Function CBXto1(valu:string):string;
    begin
     result := '';
     if alltrim(Uppercase(valu)) = 'X' then
        result := '1';
    end;

Var i,j, Rule, LLine,ElmNo:integer;FormName1013:String;
LType : string[1]; FName :string[12]; S : string;
LLineString:String[4];
 tempDate:string;
 Present: TDateTime;
 Year, Month, Day, Hour, Min, Sec, MSec: Word;
 jmonthDay:integer;
Begin
 FormName1013:='AUTHREP#1';
 Present := Now();
 DecodeDate(Present, Year, Month, Day);
 DecodeTime(Present, Hour, Min, Sec, MSec);
 jmonthDay := monthDayToJulian(month,Day);
 FX1013.UDN                :=  PaddZero(FetchElm(RetNo,FormName1013,9),9) + appYear + PaddZero(inttostr(jmonthDay),3) + PaddZero(IntToStr(Hour),2) + PaddZero(IntToStr(Min),2) + PaddZero(IntToStr(Sec),2) + PaddZero(IntToStr(MSec),3);

// showmessage(PaddZero(inttostr(jmonthDay),3));
// showmessage('Hour ' + IntToStr(Hour) + '  Minute ' + IntToStr(Min) + '  sec:' + IntToStr(Sec) + '   milisec: ' + IntToStr(MSec));
// showmessage(FX1013.UDN);
// showmessage(inttostr(Length(FX1013.UDN)));

 //part 1
 FX1013.taxPayerFirstName  :=  UpperCase(FetchElm(RetNo,FormName1013,3));
 FX1013.taxPayerlastName   :=  UpperCase(FetchElm(RetNo,FormName1013,4));
 FX1013.SIN                :=  FetchElm(RetNo,FormName1013,9);

 //20180205 TRUST
 if Length(FetchElm(RetNo,FormName1013,12))>1 then
 Begin
   FX1013.SIN:=FetchElm(RetNo,FormName1013,12); //Trust account
   FX1013.taxPayerlastName   :=UpperCase(FetchElm(RetNo,FormName1013,41)); //trust name
 end;

 //part 2
 FX1013.repID              :=  UpperCase(FetchElm(RetNo,FormName1013,27));

 FX1013.groupID            :=  UpperCase(FetchElm(RetNo,FormName1013,8));
 if AllTrim(FX1013.groupID)='G' then FX1013.groupID:='';  //20180201

 FX1013.BN                 :=  UpperCase(FetchElm(RetNo,FormName1013,28));
 FX1013.authLevel          :=  UpperCase(FetchElm(RetNo,FormName1013,32));
 //part 3
 FX1013.repFirstName       :=  UpperCase(FetchElm(RetNo,FormName1013,15));
 FX1013.repLastName        :=  UpperCase(FetchElm(RetNo,FormName1013,22));
 FX1013.repBusinessName    :=  UpperCase(FetchElm(RetNo,FormName1013,17));   //20110114
 FX1013.repTelephoneNumber :=  FetchElm(RetNo,FormName1013,18) + StringReplace(FetchElm(RetNo,FormName1013,19), '-', '',[rfReplaceAll, rfIgnoreCase]);
 FX1013.repExt             :=  FetchElm(RetNo,FormName1013,23);
 FX1013.repFax             :=  FetchElm(RetNo,FormName1013,24) + StringReplace(FetchElm(RetNo,FormName1013,25), '-', '',[rfReplaceAll, rfIgnoreCase]);
 FX1013.allTaxYearsCB      :=  CBXto1(FetchElm(RetNo,FormName1013,101));
 FX1013.authLevelAllYears  :=  UpperCase(FetchElm(RetNo,FormName1013,103));
 FX1013.specificTaxYearsCB :=  CBXto1(FetchElm(RetNo,FormName1013,132));

 //tables
 j:=0;
 for i:=1 to 10 do
 begin
   FX1013.specificTaxYears[i]  :=  UpperCase(FetchElm(RetNo,FormName1013,105 + j));
   FX1013.specificauthLevel[i] :=  UpperCase(FetchElm(RetNo,FormName1013,106 + j));
   inc(j,2);
 end;

 //part 4
 tempDate := ''; tempDate := FetchElm(RetNo,FormName1013,129);
 FX1013.expiryDate          :=  ReplaceChar(tempDate,'-','');

 FX1013.expiryDateYear  := leftstr(tempDate,4);
 FX1013.expiryDateMonth := midstr(tempDate,6,2);
 FX1013.expiryDateDay   := rightstr(tempDate,2);

 //part 5
 FX1013.cancelAllCB         :=  CBXto1(FetchElm(RetNo,FormName1013,14));
 FX1013.cancelSpecificCB    :=  CBXto1(FetchElm(RetNo,FormName1013,16));
 FX1013.repFirstNameCancel  :=  UpperCase(FetchElm(RetNo,FormName1013,1));
 FX1013.repLastNameCancel   :=  UpperCase(FetchElm(RetNo,FormName1013,31));
 FX1013.repBusinessCancel   :=  UpperCase(FetchElm(RetNo,FormName1013,2));
 FX1013.repIDCancel         :=  UpperCase(FetchElm(RetNo,FormName1013,6));

 FX1013.groupIDCancel       :=  UpperCase(FetchElm(RetNo,FormName1013,10));
 if AllTrim(FX1013.groupIDCancel)='G' then FX1013.groupIDCancel:='';  //20180201

 FX1013.BNCancel            :=  UpperCase(FetchElm(RetNo,FormName1013,7));
 //Part 6
 FX1013.PrintName           :=  UpperCase(FetchElm(RetNo,FormName1013,133));
 If FetchElm(RetNo,FormName1013,33)>'' then
  FX1013.LegalSignatureCB    := '1'
 Else
  FX1013.LegalSignatureCB    := '0';
  // CBXto1(FetchElm(RetNo,FormName1013,33));  //20110114

 tempDate := ''; tempDate := FetchElm(RetNo,FormName1013,131);
 FX1013.SignatureDate      := ReplaceChar(tempDate,'-','');
 FX1013.SignatureDateYear  := leftstr(tempDate,4);
 FX1013.SignatureDateMonth := midstr(tempDate,6,2);
 FX1013.SignatureDateDay   := rightstr(tempDate,2);

 FX1013.VendorCertCode      :=  SoftVendor;
End;



procedure TT1013EfileT1_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 setTestingElementsVisibility(testPanal); //jz//20260402

 FormIdToFlName := TDictionary<Integer, String>.Create; //20220113 Igor
 T1013EfileDir:=AppDir+'\'+'AuthRepEfile'; //T1013Efile';
 If DirectoryExists(T1013EfileDir) = false then ForceDirectories(T1013EfileDir);
 FormCnt:=0;
 //if TestOrProductionGroup.visible = true then

 TestOrProductionGroup.itemindex := 0;  //20220219  //20180210 //20220113 Igor
end;


procedure TT1013EfileT1_2026.FormDestroy(Sender: TObject); //20220113 Igor
begin
  if Assigned(FormIdToFlName) then
    FormIdToFlName.Free;
end;

Procedure TT1013EfileT1_2026.CreateSoapMessage;
Var
i,j,FormIdx:Integer; //20220113 Igor
TempSoapList:TStringList;
TempDataList:TStringList;
FlName:String;
//RetNo:Integer; //20160722 Igor
Begin
//  RetNo:=GetCurrentRetNo; //20160722 Igor
  If RetNo>0 then
  begin
   If ValidForT1013Efile(RetNo,GetFormNo('AUTHREP#1')) = false then  //20200123
   //If ValidForT1013Efile(RetNo,GetFormNo('AUTHREP#1')) = false then
   Begin  SoapMsg:='';  Exit; End;
  end;


  TempSoapList:=TStringList.Create;
 //Start SOAP envelope
 // TempSoapList.LoadFromFile(AppDir+'\'+'T1013-SoapEnv.xml'); //obsolete
  PrepareT1013Rec(RetNo);
  CreateSoapHeader(TempSoapList);
  CreateBatchDetail('header',TempSoapList);

  TempDataList:=TstringList.Create;

  If EfileOptionGroup.ItemIndex=0 then
  begin
   If RetNo>0 then
    begin
      CreateXMLFile(RetNo);
      TempDatalist.LoadFromFile(AppDir+'\'+'T1013Temp.XML');
      For j:=0 to TempDataList.count-1 do TempSoapList.add(TempDataList[j]);
   end
   else
   Begin
     ShowMessage('The tax return must be opened first');
     Close;
     Exit;
   end;
  end;

  //batch   // add the XML for each return
  If EfileOptionGroup.ItemIndex=1 then  //batch
  begin
    //20220113 Igor >>>
    FormIdToFlName.Clear;
    FormIdx := 0;
    for i:=0 to ListBox1.Items.Count -1 do
    begin
      ListBox1.ItemIndex :=i;
      if not arrValidFiles[i] then continue;
      //RetNo:=CreateNewReturn;//20160119 Igor
      FlName:=ExtractFileName(ListBox1.Items[i]);
      RetNo := ReadReturn(DataDirBox.Text,FlName);//20160119 Igor
      Screen.Cursor := crDefault;
      if RetNo > 0 then
      begin
        If ValidForT1013Efile(RetNo,GetFormNo('AUTHREP#1')) = True then
        begin
          CreateXMLFile(RetNo);
          inc(FormIdx);
          FormIdToFlName.AddOrSetValue(FormIdx, FlName);
          //FormCnt:=FormCnt+1;
          TempDatalist.LoadFromFile(AppDir+'\'+'T1013Temp.XML');
          For j:=0 to TempDataList.count-1 do TempSoapList.add(TempDataList[j]);
        end
        Else
          ShowMessage('The T1013 for '+GetLastName(RetNo)+', '+GetFirstName(RetNo) + ' has errors and it has been skipped');
      end
      Else
        ShowMessage('Error Reading return: '+FileName);
    end; //i
    If RetNo >0 then CloseReturn(RetNo);
    //20220113 Igor <<<
  end; //batch

  CreateBatchDetail('footer',TempSoapList);
  CreateSoapFooter(TempSoapList);
  SoapMsg:='';
  For I:=0 to TempSoapList.count-1 do SoapMsg:=SoapMsg+TempSoapList[i]+Chr(13);
  If FileExists(MkSubmittedFileName(RetNo)) then  DeleteFile(MkSubmittedFileName(RetNo));
  TempSoapList.SaveToFile(MkSubmittedFileName(RetNo));
  TempSoapList.Free;
  TempDataList.Free;

End;

procedure TT1013EfileT1_2026.SubmitBtnClick(Sender: TObject);
//Var RetNo:Integer; //20160722 Igor
begin
 //20220218 Igor >>>
 try
 // If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;  //20180126 //20180212
   //20200209
   //20220113 Igor >>>
   If EfileOptionGroup.ItemIndex=0 then  //single return
   begin
     if MessageDlg('Do you have a signature page signed and dated'
             +Chr(13)+'by the taxpayer or legal representative'
             +Chr(13)+'before electronically submitting the authorization'
             +chr(13)+'or cancellation information to CRA?',
              mtInformation, [mbYes, mbNo], 0) = mrYes then
              //ok
              Else
              Exit;
     //20190125
     If ValidForT1013Efile(RetNo,GetFormNo('AUTHREP#1')) = false then  //20200123
     Begin
      ShowMessage('Please fix the errors shown on the AUTHREP form, indicated by a strong yellow color');
      Exit;
     End;

     if ConfirmDeclineGroup.ItemIndex =1 then
     Begin
      ShowMessage('Since you declined the above terms and conditions, the AUTHREP submission is now terminated');
      Exit;
     End;
   end;

   If SoapMsg='' then
   Begin
    If EfileOptionGroup.ItemIndex=0 then  //single return
      ShowMessage('No data available for submission')
    else
      ShowMessage('You need to build Batch AUTHREP file first');
    Exit;
   end;
   //20220113 Igor <<<
   SubmitSoapMsg(SoapMsg,MkSubmittedFileName(RetNo));
 except on E: Exception do
   begin
     ShowMessage('Error occured: '+ E.Message + #13#10#13#10 +
                 'Stack Information: '+ E.StackTrace);
   end;
 end;
 //20220218 Igor <<<
end;

Procedure TT1013EfileT1_2026.SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);
Var
 i, j:Integer; //20220113 Igor
 WString:AnsiString;  //wide string
 objHttp:ixmlHttpRequest;
 Status: String;
 T1013Msg:AnsiString;
 TempSoapList:TStringList;
 TempDataList:TStringList;
 h:THandle;
 s:String;
 AList:TstringList;
 DOMDocument:IXMLDOMDocument; TrackNodes: IXMLDOMNodeList;  //20110129
 ResponseXmlFile:String;
 ConfirmationNumber:String;
 T1013ResponseRec:T1013AckRec;
 T1013ResponseHTM:string;
 //20220113 Igor >>>
 RejectedFormIDs: TList<Integer>;
 bRejected: boolean;
 //20220113 Igor <<<
Begin
 //sUrl:=UrlBox.text; //20110120
 //define
  ObjHTTP := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
  //20220218 Igor >>>
  if not Assigned(ObjHTTP) then
  begin
    ShowMessage('MSXML2.XMLHTTP.3.0 was not created');
    Exit;
  end;
  //20220218 Igor <<<
 //open it
 ObjHTTP.open('POST', sURL, False, OnlineNo,Password);   //20110120

 ObjHTTP.setRequestHeader('SOAPAction', 'NA'); //set action?
 objHTTP.setRequestHeader('Content-Type','text/xml');
 //ShowHTTPStatus(ObjHTTP.ReadyState);
 //transmit it now
 Screen.Cursor := crHourGlass;
 //20180228 Igor >>>
 try
   ObjHTTP.send(SoapMsg);
 except on E: Exception do
  begin
    Screen.Cursor := crDefault;
    objHttp := Nil;
    Application.MessageBox(PChar('It seems that there is no internet connection to the web site' + #13#13 +
                                  E.Message), 'Error', MB_OK or MB_ICONERROR);
    Exit;
  end;
 end;
 //20180228 Igor <<<
 Screen.Cursor := crDefault;
 delay(2000);
 Screen.Cursor := crDefault;
 WString:=objHttp.ResponseText;

 (*  20110129  not needed
 DOMDocument:=coDOMDocument.Create;
 DomDocument.async := False;
 DOMDocument.loadXML(WString);
 *)
  //20220113 Igor >>>
  ResponseXmlFile:= MkResponseFileName(RetNo);

 //DOMDocument.Save(ResponseXmlFile);

 //Now save the WString
  AList:=TStringList.Create;
  AList.Add(WString);
  AList.SaveToFile(ResponseXmlFile);
  AList.Free;

  T1013ResponseRec := parseT1013Response(WString);

  If EfileOptionGroup.ItemIndex=0 then  //single return
  Begin
    //if (T1013ResponseRec.T1013resultType = T1013accepted) or (T1013ResponseRec.T1013resultType = T1013Delayed) then
    if T1013ResponseRec.ConfirmationID > '' then
    begin
      RetNo:=GetCurrentRetNo; //make sure has returnnumber populated, not sure needed 20170219
      If T1013ResponseRec.ConfirmationId <>'--' then
        StoreElm(RetNo,GetFormNo('AUTHREP#1'),39,T1013ResponseRec.ConfirmationID);   //20200123
      If not SaveReturn(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName,True,False) =0 then
        ShowMessage('Return cannot be saved');
    end;

    T1013ResponseRec.Name := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);

    T1013ResponseHTM := CreateT1013ResponseHtm(T1013ResponseRec,AppDir+'\'+'T1013EFResponse.htm',ResponseXmlFile);

    h := ShellExecute(MainForm.Handle,'open',Pchar(''+T1013ResponseHTM),Nil,Nil,Sw_Show);
    If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');
  End
  Else  //batch
  Begin
    if T1013ResponseRec.ConfirmationID > '' then
    begin
      RejectedFormIDs := TList<Integer>.Create;
      try
        // get rejected form ids
        for I := 0 to Length(T1013ResponseRec.FormLevelResponses) - 1 do
        begin
          bRejected := false;

          // get name from return
          if not FormIdToFlName.TryGetValue(T1013ResponseRec.FormLevelResponses[I].FormID, FlName) then continue;
          RetNo := ReadReturn(DataDirBox.Text,FlName);
          if RetNo > 0 then
          begin
            T1013ResponseRec.FormLevelResponses[I].Name := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
            CloseReturn(RetNo);
          end;

          for J := 0 to Length(T1013ResponseRec.FormLevelResponses[I].ResponseCodes) - 1 do
            if T1013ResponseRec.FormLevelResponses[I].ResponseCodes[J].StartsWith('T') then
            begin
              bRejected := true;
              break;
            end;
          if bRejected then
            RejectedFormIDs.Add(T1013ResponseRec.FormLevelResponses[I].FormID);
        end;

        // save confirmation id to accepted forms
        for I := 1 to T1013ResponseRec.ReceivedFormsCount do
        begin
          if RejectedFormIDs.Contains(I) then continue;
          if not FormIdToFlName.TryGetValue(I, FlName) then continue;
          RetNo := ReadReturn(DataDirBox.Text,FlName);
          if RetNo > 0 then
          begin
            If T1013ResponseRec.ConfirmationId <>'--' then
              StoreElm(RetNo,GetFormNo('AUTHREP#1'),39,T1013ResponseRec.ConfirmationID);
            If not SaveReturn(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName,True,False) =0 then
              ShowMessage('Return cannot be saved');
            CloseReturn(RetNo);
          end;
        end;

      finally
        RejectedFormIDs.Free;
      end;

    end;

    T1013ResponseRec.Name :=
      '<table width="997" height="67" border="0" cellpadding="0" cellspacing="2">'+
      '<tr>'+
      '<td width="300"><p><strong>Received Forms Count:</strong></p></td>'+
			'<td width="750"><font size="3" face="arial, helvetica, sans-serif">'+ IntToStr(T1013ResponseRec.ReceivedFormsCount) +'</font></td>'+
      '</tr>'+
      '<tr>'+
      '<td width="300"><p><strong>Accepted Forms Count:</strong></p></td>'+
			'<td width="750"><font size="3" face="arial, helvetica, sans-serif">'+ IntToStr(T1013ResponseRec.AcceptedFormsCount) +'</font></td>'+
      '</tr>'+
      '<tr>'+
      '<td width="300"><p><strong>Rejected Forms Count:</strong></p></td>'+
			'<td width="750"><font size="3" face="arial, helvetica, sans-serif">'+ IntToStr(T1013ResponseRec.RejectedFormsCount) +'</font></td>'+
      '</tr>'+
      '</table>';

    T1013ResponseHTM := CreateT1013ResponseHtm(T1013ResponseRec,AppDir+'\'+'T1013EFResponse.htm',ResponseXmlFile);

    h := ShellExecute(MainForm.Handle,'open',Pchar(''+T1013ResponseHTM),Nil,Nil,Sw_Show);
    If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');
  end;
  //succesful transmission
  If EfileOptionGroup.ItemIndex=0 then  //single return
  Begin
    s:=MkSubmittedFileName(RetNo);
    If FileExists(s) then RenameFile(s,ReplaceStr(S, 'ToBeSubmitted', 'Submitted')); //rename it
  end;
  objHttp:=Nil;  //20110129  .Free It is not accepted
  //20220113 Igor <<<
end;


procedure TT1013EfileT1_2026.FormActivate(Sender: TObject);
begin
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);    //20110120
  //GetEOLPParms(OnlineNo,TransmitterNo,Password,Url,NetFileDir);
//  OnlineNoBox.text:=OnLineNo;
//  PassWordBox.Text:=Password;
  //20110120
  GetUrlBox;
  If (Length(OnlineNo)<>5) or (Password='') then
  begin
   SoapMsg:='';
   ShowMessage('Efiler number/password not entered correctly. Please complete the EfileOnline -> Setup EOL and Setup Eol Plus');
   MainFormT1.SetupEOL1Click(Sender);
   Exit;
  end;

  userName1013 := OnLineNo;
  passWord1013 := Password;

  SoapMsg:='';

  //20220113 Igor >>>
  If GetCurrentRetNo=0 then  //no return opened defaults to batch
    EfileOptionGroup.ItemIndex:=1;
  UpdateSingleOrBatch;
  //20220113 Igor <<<
end;

procedure TT1013EfileT1_2026.ShowBtnClick(Sender: TObject);
Var h:THandle; FlName:String; openDialogShowXML:TOpenDialog;
begin

  if EfileOptionGroup.ItemIndex=1 then
  begin
    openDialogShowXML := TOpenDialog.Create(self);
    openDialogShowXML.InitialDir := T1013EfileDir+'\';
    openDialogShowXML.Options := [ofFileMustExist];     // Only allow existing files to be selected
    openDialogShowXML.Filter := 'XML files|*.xml|ALL|*.*';
    openDialogShowXML.FilterIndex := 1;     // Select XML files as the starting filter type

    if openDialogShowXML.Execute then FLname:= openDialogShowXML.FileName
    else
    begin
      ShowMessage('Open file was cancelled');
      FLname:='';
    end;
    openDialogShowXML.Free;
  end
  else
    FLname:=MkSubmittedFileName(RetNo); //AppDir+'\'+'T1013-Submitted.xml';

  if FLname > '' then
  begin
    h := ShellExecute(Self.Handle,'open',Pchar(''+FlName),Nil,Nil,Sw_Show);
    If H<=32 then ShowMessage('File not found');
  end;

end;

procedure TT1013EfileT1_2026.EfileOptionGroupClick(Sender: TObject);
begin
 //20220113 Igor >>> 
 {If (RetInMem>0) and (EfileOptionGroup.ItemIndex=1) then
 begin
 // ShowMessage('Please close All returns first');
  Exit;
 end;}

// If (LicenseLevel <> 'T1 Power') and (EfileOptionGroup.ItemIndex=1) then
 If (LicenseLevel <> llPower) and (EfileOptionGroup.ItemIndex=1) then//20160119 Igor
 Begin
  ShowMessage('Batch T1013 submission is only available in the T1-Power version');
  TimerClose.Enabled := true; //20240131 Igor
  Exit;
 End;
 UpdateSingleOrBatch;
 //20220113 Igor <<<
end;

procedure TT1013EfileT1_2026.DBGrid1DblClick(Sender: TObject);
Var i:Integer; FlName:String;
SomeList:TStringList;
begin

 FlName:=MkSelectedStr;

 If OpenReturnAndCheckT1013(DataDirBox.Text,Table1.FieldByName('File_Name').AsString) =False then
 begin
  //20240131
 // ShowMessage('T1013 not ready for Efile, or already Efiled or file cannot be found');
 // Exit;
 end;

 //duplicates
 SomeList:=TStringList.Create;
 For i:=0 to ListBox1.Items.count-1 do SomeList.Add(ListBox1.Items[i]);
 If IsInList(FlName,SomeList)>-1 then
 Begin
  ShowMessage('Already selected');
  Exit;
 End;
 SomeList.Free;
 ListBox1.Items.Add(FlName);
end;

procedure TT1013EfileT1_2026.BitBtn1Click(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;

procedure TT1013EfileT1_2026.RemoveBtnClick(Sender: TObject);
begin
ListBox1DblClick(Sender);
end;


procedure TT1013EfileT1_2026.BitBtn2Click(Sender: TObject);
begin
ListBox1.Clear;
end;

Function TT1013EfileT1_2026.MkSelectedStr: String;
Const
 PartNameLen = 14;
Var
 S : string[80];
begin
    Result :=
     LeftStr(Table1.FieldByName('Last_Name').AsString,PartNameLen)
     + ' ' +LeftStr(Table1.FieldByName('First_Name').AsString,1)
     + '.'
     + FilledStr(
       PartNameLen+3-Length(LeftStr(Table1.FieldByName('Last_Name').AsString,PartNameLen))
       + 1 + Length(LeftStr(Table1.FieldByName('First_Name').AsString,1))+1
       ,' ')
     + '\'+Table1.FieldByName('File_Name').AsString
end;



procedure TT1013EfileT1_2026.ListBox1DblClick(Sender: TObject);
begin
 ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TT1013EfileT1_2026.BuildBatchBtnClick(Sender: TObject);
begin
  if LicenseLevel in [llHome..llStd] then//20160119 Igor
 begin
  ShowMessage('Batch T1013 Efile is available only in the T1 Power version');
  Exit;
 end;

 If ListBox1.Items.Count = 0 then  begin ShowMessage('No records selected');exit;end;
 If ListBox1.Items.Count >30 then  begin ShowMessage('Selected number exceeds 30');exit;end;
 CreateBatch;
end;

procedure TT1013EfileT1_2026.ShowFiles;
var DataBaseName: string;//20160119 Igor
begin

 DataDirBox.Text := OptRec.Dir_Cur;
 DataBaseName := DataDirBox.Text + '\' + ClientsDBLite;

 If Not FileExists(DataBaseName) then
 begin
  ShowMessage('There is no Clients data base in this directory'+
    Chr(13)+'Use Configure | Data Directories');
    exit;
 end;

 SetTableName(FDConnection, Table1, DataBaseName, ClientsTableLite, 'LAST_Name');

 Screen.Cursor := crDefault;
 If Table1.RecordCount = 0 then
 begin
  ShowMessage('DataBase is empty. Press Close');
  exit;
 end;
end;

Procedure TT1013EfileT1_2026.CreateBatch; //20220113 Igor
Var FlName:String;i:Integer; //RetNo:Integer; 20160722 Igor
Begin
  FormCnt:=0;
  // RetNo:=GetCurrentRetNo; //20160722 Igor
  SoapMsg:='';
  SetLength(arrValidFiles, ListBox1.Items.Count);
  for i:=0 to ListBox1.Items.Count -1 do
  begin
    Try
      arrValidFiles[i] := false;
      ListBox1.ItemIndex :=i;
      //RetNo:=CreateNewReturn;//20160119 Igor
      FlName:=ExtractFileName(ListBox1.Items[i]);
      RetNo := ReadReturn(DataDirBox.Text,FlName);//20160119 Igor
      Screen.Cursor := crDefault;
      if RetNo > 0 then
      begin
        If ValidForT1013Efile(RetNo,GetFormNo('AUTHREP#1')) = True then
        begin
          FormCnt:=FormCnt+1;
          arrValidFiles[i] := true;
        end
        Else
        begin
          ShowMessage('The T1013 for '+GetLastName(RetNo)+', '+GetFirstName(RetNo) + ' has errors and it will be skipped');
          if MessageDlg('Do you want to Fix it and Save the return now?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            If RetNo >0 then CloseReturn(RetNo);
            RetNo :=0; //RetINmem :=0;
            //RetNo:=CreateNewReturn;//20160119 Igor
            RetNo := ReadReturn(DataDirBox.Text,FlName);//20160119 Igor
            Screen.Cursor := crDefault;
            if RetNo =0 then
            begin
              OpenForm(RetNo,GetFormNo('AUTHREP#1'),0);
              MainForm.WizardPanel.visible:=True;
              MainForm.RefreshAuditPanel(RetNo);
              Close;
              Exit;
            End;
          end;
        end;
      end;
      If RetNo >0 then CloseReturn(RetNo);
      RetNo :=0; //RetINmem :=0;//20160119 Igor
    Except
      ShowMessage('File cannot be processed: '+FlName);
    end;
  end; //i
  if FormCnt = 0 then
    ShowMessage('No valid files are available for transmission')
  else
  begin
    CreateSoapMessage;
    ShowMessage('Batch created with '+IntToStr(FormCnt)+' submissions of T1013. You can Connect/Transmit now');
  end;
End;



//jz//20250211
Procedure TT1013EfileT1_2026.CreateSoapHeader(Var TempSoapList:TStringList);
Var i:Integer;
begin



if testLastyearsXMLformat then //just for testing
begin
  //jz20250211 //pre 2024
  If EfileOptionGroup.itemindex=0 then FormCnt:=1;
  With TempSoaplist do
  begin
   add('<?xml version="1.0" encoding="ISO-8859-1"?>');
   add('<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">');
   add('<soap-env:Header>');
   add('<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">');
   add('<wsse:UsernameToken>');
   add('<wsse:Username>'+ userName1013 +'</wsse:Username>');
   add('<wsse:Password>'+ passWord1013 +'</wsse:Password>');
   add('</wsse:UsernameToken>');
   add('</wsse:Security>');
   add('</soap-env:Header>');
   add('<soap-env:Body>');

   //must be combined or hex character 0d 0a (line break) causes error on CRA side
   //20210112
   //20240122
   add('<tris:Request xmlns:tris="http://ccra.gc.ca/tris" xmlns:xsi="http://www.w3.org/2001/XMLSchema" xsi:type="tris:Request"><type>2023</type><file>');  //20230204
   //add('<tris:Request xmlns:tris="http://ccra.gc.ca/tris" xmlns:xsi="http://www.w3.org/2001/XMLSchema" xsi:type="tris:Request"><type>2022</type><file>');  //20230204
   //add('<tris:Request xmlns:tris="http://ccra.gc.ca/tris" xmlns:xsi="http://www.w3.org/2001/XMLSchema" xsi:type="tris:Request"><type>2020</type><file>');  //20200119
   //add('<tris:Request xmlns:tris="http://ccra.gc.ca/tris" xmlns:xsi="http://www.w3.org/2001/XMLSchema" xsi:type="tris:Request"><type>2019</type><file>');  //20200119
   //add('<tris:Request xmlns:tris="http://ccra.gc.ca/tris" xmlns:xsi="http://www.w3.org/2001/XMLSchema" xsi:type="tris:Request"><type>2018</type><file>');  //20190102
  end;
end
else  //jz20250211
begin
  If EfileOptionGroup.itemindex=0 then FormCnt:=1;
  With TempSoaplist do
  begin
    add('<?xml version="1.0" encoding="UTF-8"?>');
    add('<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">');

    add('<soap-env:Header>');
    add('<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">');
    add('<wsse:UsernameToken>');
    add('<wsse:Username>'+ userName1013 +'</wsse:Username>');
    add('<wsse:Password>'+ passWord1013 +'</wsse:Password>');
    add('</wsse:UsernameToken>');
    add('</wsse:Security>');
    add('</soap-env:Header>');
    add('<soap-env:Body>');

    //must be combined or hex character 0d 0a (line break) causes error on CRA side
    add('<tris:Request xmlns:tris="http://cra.gc.ca/tris" xmlns:xsi="http://www.w3.org/2001/XMLSchema" xsi:type="tris:Request">');

    add('<type>'+appyear+'</type>');
    add('<file>');

  end;
end; //else


end;

Procedure TT1013EfileT1_2026.CreateSoapFooter(Var TempSoapList:TStringList);
Var i:Integer;
begin
 With TempSoaplist do
 begin
   add('</file>');
   add('</tris:Request>');
   add('</soap-env:Body>');
   add('</soap-env:Envelope>');
  end;
end;

Function TT1013EfileT1_2026.MkSubmittedFileName(RetNo:Integer):String; //20220113 Igor
begin
 If EfileOptionGroup.ItemIndex=0 then
  result:=T1013EfileDir+'\'+'T1013-Submitted-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+'.xml'
 Else
 Begin
  sBatchFileSuffix:=FormatDateTime('yyyy-mm-dd hh-nn-ss',Now);
  result:=T1013EfileDir+'\'+'T1013-Submitted-Batch'+'-'+sBatchFileSuffix+'.xml';
  //PaddZero(FetchElm(RetNo,FormName1013,9),9) + appYear + PaddZero(inttostr(jmonthDay),3) + PaddZero(IntToStr(Hour),2) + PaddZero(IntToStr(Min),2) + PaddZero(IntToStr(Sec),2) + PaddZero(IntToStr(MSec),3);
 end;
end;

Function TT1013EfileT1_2026.MkResponseFileName(RetNo:Integer):String; //20220113 Igor
begin
 If EfileOptionGroup.ItemIndex=0 then
  result:=T1013EfileDir+'\'+'T1013-Response-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+'.xml'
 Else
  result:=T1013EfileDir+'\'+'T1013-Response-Batch-'+sBatchFileSuffix+'.xml';
end;

procedure TT1013EfileT1_2026.GetUrlBox;
begin

 If TestOrProductionGroup.ItemIndex=0 then  //production
   sUrl := 'https://apps.cra-arc.gc.ca/ebci/tdws/esub/services/TRISWebService'
 else
   sUrl := 'https://apps-ct.cra-arc.gc.ca/ebci/tdws/esub/services/TRISWebService?wsdl';

  UrlBox.Text := SUrl;

end;

procedure TT1013EfileT1_2026.TestOrProductionGroupClick(Sender: TObject);
begin
GetUrlBox;
end;

procedure TT1013EfileT1_2026.BitBtn3Click(Sender: TObject);
begin
 MainFormT1.T1013EfileErrors1Click(Sender);
end;

procedure TT1013EfileT1_2026.SearchBoxChange(Sender: TObject);
begin
//20170522 Igor >>>
 // Table1.Locate('LAST_NAME', SearchBox.Text, [loCaseInsensitive, loPartialKey]); //20180127
//  with Table1 do
//  begin
//   SetKey;
//   FieldByName('Last_Name').AsString := UpperCase(SearchBox.Text);
//   GotoNearest;
//  end;
//20170522 Igor <<<
end;



procedure TT1013EfileT1_2026.BitBtn4Click(Sender: TObject);
Var h:THandle; Pgm:String;
begin
  PGM:=AppDir+'\'+'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle,'open',Pchar(''+Pgm),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Installation interrupted or program not found');
end;

procedure TT1013EfileT1_2026.BitBtn5Click(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

Function TT1013EfileT1_2026.parseT1013Response(ResponseString:AnsiString):T1013AckRec; //20220113 Igor
var T1013ResponseRec:T1013AckRec;
    X: XML.XMLDoc.TXMLDocument;
    N, Body, Fault, BatchResponse, Detail, BatchLevelResponse,
    BatchResponseCode, ResponseCodes, FormLevelResponse,
    FormResponseCode, Node: IXMLNode;
    fontRedColor, fontGreenColor, fontEnd: string;
    I, J, CurrCount, CurrFormCount: integer;

    function ClearXML(AXML: String): string;
    begin
      Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
      Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
    end;

begin
  fontRedColor      := '<font color="#990000">';
  fontGreenColor    := '<font color="#009900">';
  fontEnd           := '</font>';

  T1013ResponseRec.DateTimeReceived := FormatDateTime('yyyy-mm-dd',Date)+ '  '+GetTimeToMilliSec(Date);

  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try //20220219 Igor
      X.XML.Clear;
      X.XML.Add(ClearXML(ResponseString));
      if not(X.Active) then
        X.Active := true;
      N := X.DocumentElement;
      if (N = nil) or (N.NodeName <> 'Envelope') then
        raise Exception.Create('Bad Response XML structure: ' + ResponseString);

      Body := N.ChildNodes.FindNode('Body');
      if (Body = nil) then
        raise Exception.Create('Bad Response XML structure: ' + ResponseString);
      Fault := Body.ChildNodes.FindNode('Fault');
      if Fault <> nil then
      begin
        Fault.ChildValues['faultcode'];
        T1013ResponseRec.ResponseCode   := VarToStr(Fault.ChildValues['faultcode']);
        T1013ResponseRec.ResponseText   := VarToStr(Fault.ChildValues['faultstring']);
        T1013ResponseRec.Response       := fontRedColor+'Server Error'+ fontEnd;
        T1013ResponseRec.additionalText := 'Check with CRA to see if Efile is down.';
        T1013ResponseRec.TransmitterID  := '--';
        T1013ResponseRec.ConfirmationID := '--';
        T1013ResponseRec.T1013resultType:= T1013webServiceError;

        result := T1013ResponseRec;
        exit;
      end;
      BatchResponse := Body.ChildNodes.FindNode('Response')
                           .ChildNodes.FindNode('BatchResponse');
      if BatchResponse <> nil then
      begin
        Detail := BatchResponse.ChildNodes.FindNode('BatchResponseDetail');
        if (Detail = nil) then
          raise Exception.Create('Bad Response XML structure: ' + ResponseString);

        T1013ResponseRec.TransmitterID := VarToStr(Detail.ChildValues['TransmitterID']);
        T1013ResponseRec.ReceivedFormsCount := MyStrToInt(VarToStr(Detail.ChildValues['ReceivedFormsCount']));
        T1013ResponseRec.AcceptedFormsCount := MyStrToInt(VarToStr(Detail.ChildValues['AcceptedFormsCount']));
        T1013ResponseRec.RejectedFormsCount := MyStrToInt(VarToStr(Detail.ChildValues['RejectedFormsCount']));

        //20220219 Igor >>>
        if Assigned(BatchResponse.ChildNodes.FindNode('ResponseCodes')) then
        begin
          BatchLevelResponse := BatchResponse.ChildNodes.FindNode('ResponseCodes')
                                             .ChildNodes.FindNode('BatchLevelResponse');
          SetLength(T1013ResponseRec.ResponseCodes, 0);
          SetLength(T1013ResponseRec.ResponseTexts, 0);
          CurrCount := 0;
          if BatchLevelResponse <> nil then
          begin
            BatchResponseCode := BatchLevelResponse.ChildNodes.FindNode('BatchResponseCode');
            for I := 0 to BatchResponseCode.ChildNodes.Count - 1 do
            begin
              Node := BatchResponseCode.ChildNodes[I];
              if SameText(Node.NodeName, 'ResponseCode') then
              begin
                Inc(CurrCount);
                SetLength(T1013ResponseRec.ResponseCodes, CurrCount);
                SetLength(T1013ResponseRec.ResponseTexts, CurrCount);
                T1013ResponseRec.ResponseCodes[CurrCount - 1] := VarToStr(Node.NodeValue);
                T1013ResponseRec.ResponseTexts[CurrCount - 1] := GetT1013ErrorDescr(VarToStr(Node.NodeValue));
              end;
            end;
          end;

          ResponseCodes := BatchResponse.ChildNodes.FindNode('ResponseCodes');
          SetLength(T1013ResponseRec.FormLevelResponses, 0);
          CurrFormCount := 0;
          if ResponseCodes <> nil then
          begin
            for I := 0 to ResponseCodes.ChildNodes.Count - 1 do
            begin
              FormLevelResponse := ResponseCodes.ChildNodes[I];
              if not SameText(FormLevelResponse.NodeName, 'FormLevelResponse') then continue;
              Inc(CurrFormCount);
              SetLength(T1013ResponseRec.FormLevelResponses, CurrFormCount);
              SetLength(T1013ResponseRec.FormLevelResponses[CurrFormCount - 1].ResponseCodes, 0);
              SetLength(T1013ResponseRec.FormLevelResponses[CurrFormCount - 1].ResponseTexts, 0);
              T1013ResponseRec.FormLevelResponses[CurrFormCount - 1].FormID := MyStrToInt(VarToStr(FormLevelResponse.ChildValues['FormID']));
              FormResponseCode := FormLevelResponse.ChildNodes.FindNode('FormResponseCode');
              CurrCount := 0;
              for J := 0 to FormResponseCode.ChildNodes.Count - 1 do
              begin
                Node := FormResponseCode.ChildNodes[J];
                if SameText(Node.NodeName, 'ResponseCode') then
                begin
                  Inc(CurrCount);
                  SetLength(T1013ResponseRec.FormLevelResponses[CurrFormCount - 1].ResponseCodes, CurrCount);
                  SetLength(T1013ResponseRec.FormLevelResponses[CurrFormCount - 1].ResponseTexts, CurrCount);
                  T1013ResponseRec.FormLevelResponses[CurrFormCount - 1].ResponseCodes[CurrCount - 1] := VarToStr(Node.NodeValue);
                  T1013ResponseRec.FormLevelResponses[CurrFormCount - 1].ResponseTexts[CurrCount - 1] := GetT1013ErrorDescr(VarToStr(Node.NodeValue));
                end;
              end
            end;
          end;
        end;
        //20220219 Igor <<<

        if Detail.ChildNodes.FindNode('ConfirmationNumber') <> nil then
        begin
          T1013ResponseRec.ConfirmationID := VarToStr(Detail.ChildValues['ConfirmationNumber']);

          If (Length(T1013ResponseRec.ResponseCodes) > 0) and (T1013ResponseRec.ResponseCodes[0].StartsWith('W')) then
          begin
            T1013ResponseRec.Response       := fontGreenColor+'Accepted - Delayed'+ fontEnd;
            T1013ResponseRec.T1013resultType:= T1013Delayed;
            T1013ResponseRec.additionalText := '';
          end
          else
          begin
            T1013ResponseRec.Response       := fontGreenColor+'Accepted'+ fontEnd;
            T1013ResponseRec.T1013resultType:= T1013accepted;
            T1013ResponseRec.additionalText := '';
          end;
        end
        else
        begin
          T1013ResponseRec.Response       := fontRedColor+'Rejected'+ fontEnd;
          T1013ResponseRec.ConfirmationID := '--';
          T1013ResponseRec.T1013resultType:= T1013rejected;
          T1013ResponseRec.additionalText := '';
        end;
      end;
    //20220219 Igor >>>
    except on E: Exception do
      begin
        ShowMessage('Error occured while parsing Response' + #13#10#13#10 + ResponseString);
        T1013ResponseRec.ResponseText   := E.Message;
        T1013ResponseRec.Response       := fontRedColor+'Internal error'+ fontEnd;
        T1013ResponseRec.additionalText := '<pre>' + ReplaceStr(ReplaceStr(ResponseString, '<', '&lt;'), '>', '&gt;') + '<pre>';
        T1013ResponseRec.TransmitterID  := '--';
        T1013ResponseRec.ConfirmationID := '--';
        T1013ResponseRec.T1013resultType:= T1013webServiceError;
      end;
    end;
    //20220219 Igor <<<
  finally
    X.Free;
  end;
  Result := T1013ResponseRec;
end;

(*Function TT1013EfileT1_2026.parseT1013Response(ResponseString:AnsiString):T1013AckRec;
Var
    k,sPos,sLength,ePos:Integer;
    TempList:TStringList;
    s,e, fontRedColor, fontGreenColor, fontEnd:string;
    T1013ResponseRec:T1013AckRec;
Begin
  fontRedColor      := '<font color="#990000">';
  fontGreenColor    := '<font color="#009900">';
  fontEnd           := '</font>';

  T1013ResponseRec.DateTimeReceived := 'Date/Time: '+ FormatDateTime('yyyy-mm-dd',Date)+ '  '+GetTimeToMilliSec(Date);

  //check if web server error ------------------------------------------------------------------------------------
  s         := '<faultcode>';
  sPos      := Pos(s,ResponseString);
  If sPos>0 then
  begin
        s := '<faultcode>';     sLength := Length(s);   sPos := Pos(s,ResponseString) + sLength;
        e := '</faultcode>';                            ePos := Pos(e,ResponseString);
        T1013ResponseRec.ResponseCode   := MidAnsiStr(ResponseString,sPos,ePos-sPos);

        s := '<faultstring>';   sLength := Length(s);   sPos    := Pos(s,ResponseString) + sLength;
        e := '</faultstring>';                          ePos    := Pos(e,ResponseString);
        T1013ResponseRec.ResponseText   := MidAnsiStr(ResponseString,sPos,ePos-sPos);

        T1013ResponseRec.Response       := fontRedColor+'Server Error'+ fontEnd;
        T1013ResponseRec.additionalText := 'Check with CRA to see if Efile is down.'; //20170126 //20160307 //20160505 Igor
       // T1013ResponseRec.additionalText := 'Check with CRA to see if Efile is down. If not, contact VisualTax.'; //20160307 //20160505 Igor
        T1013ResponseRec.TransmitterID  := '--';
        T1013ResponseRec.ConfirmationID := '--';
        T1013ResponseRec.T1013resultType:= T1013webServiceError;

        result := T1013ResponseRec;

        exit;

  end;

  //not fault error, assume response(s) -----------------------------------------------------------------------------------
  s := '<trisr:TransmitterID>';    sLength := Length(s);  sPos := Pos(s,ResponseString) + sLength;
  e := '</trisr:TransmitterID>';                          ePos := Pos(e,ResponseString);
  T1013ResponseRec.TransmitterID  := MidAnsiStr(ResponseString,sPos,ePos-sPos);


  //get error code and text //error code was supposed to be replaced by response code but still seems to be in use?
  s := '<trisr:ErrorCode>';         sLength := Length(s);   sPos := Pos(s,ResponseString) + sLength;
  e := '</trisr:ErrorCode>';                                ePos := Pos(e,ResponseString);
  if sPos - sLength > 0 then
  begin
        T1013ResponseRec.ResponseCode   := MidAnsiStr(ResponseString,sPos,ePos-sPos);
        T1013ResponseRec.ResponseText   := GetT1013ErrorDescr(T1013ResponseRec.ResponseCode);
  end;


  //get response code and text
  s := '<trisr:ResponseCode>';     sLength := Length(s);  sPos := Pos(s,ResponseString) + sLength;
  e := '</trisr:ResponseCode>';                           ePos := Pos(e,ResponseString);
  if sPos - sLength > 0 then
  begin
        T1013ResponseRec.ResponseCode   := MidAnsiStr(ResponseString,sPos,ePos-sPos);
        T1013ResponseRec.ResponseText   := GetT1013ErrorDescr(T1013ResponseRec.ResponseCode);
  end;

  //check if confirmation  ---------------------------------------------------------------------------------------
  s         := '<trisr:ConfirmationNumber>';
  sPos      := Pos(s,ResponseString);
  If sPos>0 then
  begin
        s := '<trisr:ConfirmationNumber>';      sLength := Length(s);   sPos := Pos(s,ResponseString) + sLength;
        e := '</trisr:ConfirmationNumber>';                             ePos := Pos(e,ResponseString);
        T1013ResponseRec.ConfirmationID := MidAnsiStr(ResponseString,sPos,ePos-sPos);

        //If T1013ResponseRec.ResponseCode[1] = 'W' then
        //not sure if needed, make sure is not blank so ResponseCode[1] doesnt fail //20170219
        If (length(T1013ResponseRec.ResponseCode) > 0) and (T1013ResponseRec.ResponseCode[1] = 'W') then
        begin
                T1013ResponseRec.Response       := fontGreenColor+'Accepted - Delayed'+ fontEnd;
                T1013ResponseRec.T1013resultType:= T1013Delayed;
                T1013ResponseRec.additionalText := '';
        end
        else
        begin
                T1013ResponseRec.Response       := fontGreenColor+'Accepted'+ fontEnd;
                T1013ResponseRec.T1013resultType:= T1013accepted;
                T1013ResponseRec.additionalText := '';
        end;
  end
  Else
  begin
        T1013ResponseRec.Response       := fontRedColor+'Rejected'+ fontEnd;
        T1013ResponseRec.ConfirmationID := '--';
        T1013ResponseRec.T1013resultType:= T1013rejected;
        T1013ResponseRec.additionalText := '';
  end;

  result := T1013ResponseRec;

end;
*)

Function TT1013EfileT1_2026.GetT1013ErrorDescr(ErrorCode:String):String;  //20140119 //20220110 Igor
var
  //20160119 igor
  FDCon: TADConnection;
  Tbl: TADTable;
begin
  Result := '';

  FDCon := TADConnection.Create(nil);
  Tbl := TADTable.Create(nil);
  try
    //20150925 igor
    if SetTableName(FDCon, Tbl, AppDir + '\' + 'T1013Errors.db', 'T1013Errors', 'Code')
    then
      if Tbl.FindKey([ErrorCode]) = True then
      begin
        Result := Tbl.FieldByName('Descr').AsWideString; //20220110 Igor
      end;
  finally
    FreeAndNil(FDCon);
    FreeAndNil(Tbl);
  end;

end;


Function TT1013EfileT1_2026.CreateT1013ResponseHtm(T1013ResponseRec:T1013AckRec;HtmTemplateFileName,ResponseXmlFileName:String):String;
var
 htmlSource:TStringList;
 sString,source,flName:string;
 OnLineNo,PassWord,Url,NetFileDir:String;
 i,j,k,s,startPos,itemNumTemp:integer;
 cBatchResponse, cFormResponse: string; //20220113 Igor
begin
 htmlSource:=TStringList.Create;
 htmlSource.LoadFromFile(HtmTemplateFileName);

 //20220113 Igor >>>
 cBatchResponse := '';
 if (EfileOptionGroup.ItemIndex=1) and (Length(T1013ResponseRec.ResponseCodes) > 0) then
  cBatchResponse :=
     '<tr>'+
     '<td width="1050" colspan=2>'+
       '<strong>Batch Level Responses:</strong>'+
     '</font></td>'+
    '</tr>' + #13#10;
 for I := 0 to Length(T1013ResponseRec.ResponseCodes) -1 do
 begin
   cBatchResponse := cBatchResponse +
    '<tr>'+
     '<td width="50" style="vertical-align: top"><font size="3" face="arial, helvetica, sans-serif">'+ T1013ResponseRec.ResponseCodes[I] +'</font></td>'+
     '<td width="1000"><font size="3" face="arial, helvetica, sans-serif">'+ T1013ResponseRec.ResponseTexts[I] +'</font></td>'+
    '</tr>' + #13#10;
 end;

 cFormResponse := '';
 if Length(T1013ResponseRec.FormLevelResponses) > 0 then
  cFormResponse :=
     '<tr>'+
     '<td width="1050" colspan=2>'+
       '<br><strong>Form Level Responses:</strong>'+
     '</td>'+
    '</tr>' + #13#10;
 for I := 0 to Length(T1013ResponseRec.FormLevelResponses) -1 do
 begin
   cFormResponse := cFormResponse +
    '<tr><td width="1050" colspan=2><hr></td></tr>' + #13#10 +
    '<tr>'+
     '<td width="80"><strong>Form ID:</strong></td>'+
     '<td width="970"><font size="3" face="arial, helvetica, sans-serif">'+ IntToStr(T1013ResponseRec.FormLevelResponses[I].FormID) + '</font></td>'+
    '</tr>' + #13#10 +
    '<tr>'+
     '<td width="80"><strong>Name:</strong></td>'+
     '<td width="970"><font size="3" face="arial, helvetica, sans-serif">'+ T1013ResponseRec.FormLevelResponses[I].Name + '</font></td>'+
    '</tr>' + #13#10;
   for J := 0 to Length(T1013ResponseRec.FormLevelResponses[I].ResponseCodes) -1 do
     cFormResponse := cFormResponse +
      '<tr>'+
       '<td width="80" style="vertical-align: top"><font size="3" face="arial, helvetica, sans-serif">'+ T1013ResponseRec.FormLevelResponses[I].ResponseCodes[J] +'</font></td>'+
       '<td width="970"><font size="3" face="arial, helvetica, sans-serif">'+ T1013ResponseRec.FormLevelResponses[I].ResponseTexts[J] +'</font></td>'+
      '</tr>' + #13#10;

 end;
 //20220113 Igor <<< 
 For i := 0 to htmlSource.Count-1 do
 begin
  sString := '!Client!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1013ResponseRec.Name,[rfReplaceAll, rfIgnoreCase]);

  sString := '!Response!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1013ResponseRec.Response,[rfReplaceAll, rfIgnoreCase]);

  sString := '!DateTime!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1013ResponseRec.DateTimeReceived,[rfReplaceAll, rfIgnoreCase]);

  sString := '!TransmitterID!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1013ResponseRec.TransmitterID,[rfReplaceAll, rfIgnoreCase]);

  sString := '!ConfirmationNumberNo!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1013ResponseRec.ConfirmationID,[rfReplaceAll, rfIgnoreCase]);

  sString := '!ResponseCode!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1013ResponseRec.ResponseCode,[rfReplaceAll, rfIgnoreCase]);

  sString := '!ResponseText!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1013ResponseRec.ResponseText,[rfReplaceAll, rfIgnoreCase]);

  //20220113 Igor >>>
  sString := '!BatchResponse!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, cBatchResponse,[rfReplaceAll, rfIgnoreCase]);

  sString := '!FormResponse!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, cFormResponse,[rfReplaceAll, rfIgnoreCase]);
  //20220113 Igor <<<

  sString := '!additionalText!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1013ResponseRec.additionalText,[rfReplaceAll, rfIgnoreCase]);

 end;

 flName := ChangeFileExt(ResponseXmlFileName, '.htm');
 htmlSource.SaveToFile(flName);

 htmlSource.Free;

 result := flName;
end;

procedure TT1013EfileT1_2026.testResponseClick(Sender: TObject);
var  tempResponseList:tstringlist;
     AckResponseFlName, T1135ResponseHTM, ResponseXmlFile:string;
     T1013ResponseRec:T1013AckRec;
     T1013ResponseHTM:string;
     h:THandle;
begin
  OpenDialog1.FileName := '*Response*.xml';
  //OpenDialog1.FileName := '';

  OpenDialog1.InitialDir:= T1013EfileDir;
  OpenDialog1.Filter := 'XML files (*.xml)|*.xml|'+
                        'Any (*.*)|*.*';
  If OpenDialog1.Execute then
  begin

    tempResponseList := TStringList.Create;
    tempResponseList.loadFromFile(OpenDialog1.FileName);

    T1013ResponseRec := parseT1013Response(tempResponseList.text);

     if T1013ResponseRec.ConfirmationID > '' then
     begin
         RetNo:=GetCurrentRetNo;
         If T1013ResponseRec.ConfirmationId <>'--' then StoreElm(RetNo,GetFormNo('AUTHREP#1'),39,T1013ResponseRec.ConfirmationID); //20220113 Igor
         //showmessage('SourceDataDir' + Ret[RetNo].SourceDataDir);
         //showmessage('SourceFlName' + Ret[RetNo].SourceFlName);
         If not SaveReturn(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName,True,False)=0 then
                 ShowMessage('Return cannot be saved');
     end;

     T1013ResponseRec.Name := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);

     T1013ResponseHTM :=CreateT1013ResponseHtm(T1013ResponseRec,AppDir+'\'+'T1013EFResponse.htm',ResponseXmlFile);

     h :=ShellExecute(MainForm.Handle,'open',Pchar(''+T1013ResponseHTM),Nil,Nil,Sw_Show);
     If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');

  end;
end;


procedure TT1013EfileT1_2026.TimerCloseTimer(Sender: TObject); //20240131 Igor
begin
  TimerClose.Enabled := false;
  Close;
end;

procedure TT1013EfileT1_2026.UpdateSingleOrBatch; //20220113 Igor
begin
  If EfileOptionGroup.ItemIndex=0 then
  begin
    pgMain.ActivePage := tabSingle;
    RetNo:=GetCurrentRetNo;
    If (RetNo>0) and (EfileOptionGroup.ItemIndex=0) then   //current return
     CreateSoapMessage;
  end
  Else
  begin
    pgMain.ActivePage := tabMulti;
    ShowFiles;
    SoapMsg := '';
  end;
end;

end.

