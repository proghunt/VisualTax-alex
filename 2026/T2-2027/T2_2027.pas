unit T2_2027;
(* Version updates: -todo, +done, =unchanged
2014-10-31
+ udeclare.pas        |   55 +-
2014-07-29
+ AppId
+ ValidateKey (from uAuthorization)
unit updates to 2014-07-29
+ Calc,Calc1,Calc2,Calc3,Calc4,Calc5,CalcPdf (replaced)
+ Common2.pas         |   39 +-
+ childwinnew.pas     |  173 +-
+ common.pas          |    6 +-
+ main.dfm            |  466 +-
+ main.pas            |  120 +-
+ trimstr.pas         |  667 +-
+ uCtxReader.pas      |   32 +-
+ uarsifrm.dfm        |  Bin 8831 -> 9130 bytes
+ uarsifrm.pas        |  245 +-
+ uauthorization.pas  |  116 +-
+ ubardatagen.pas     |  828 +-
+ ucnterr.pas         |  382 +-
+ uefsecure.pas       |   64 +
+ ueolsetup.dfm       |   82 +-
+ ueolsetup.pas       |    6 +
+ ugifibsedit.dfm     |   54 +-
+ ugifibsedit.pas     |    5 +-
+ ugifiisedit.dfm     |   25 +-
+ ugifiisedit.pas     |    3 +-
+ uimportgpt2.dfm     |    5 +-
+ uimportgpt2.pas     |   13 +-
+ uoptionsfrm.dfm     |   65 +-
= uoptionsfrm.pas     |    1 +
+ uprint.pas          | 1145 +-
= urepfsbs.pas        |    1 +
= urepfsis.pas        |    1 +
+ urollover.pas       |  139 +-
+ usaveas.pas         |    1 +
+ uspecialgpt2.pas    |    4 +-
+ usuperentry.pas     |    2 +-
+ uvtscan.pas         |    7 +
removed 2014-07-29
+ uimportctxT2.pas
+ ursifrm.pas
*)

interface

uses
  Classes, Controls, ComCtrls, Forms, Menus, ExtCtrls, DB, StdCtrls,
  vtMulti, vtForm, uEncrypt, //20191015 Igor
  vtChild, T2_2027Declare,
  IOUtils, //20180503 Igor
  rxRichEd; //20160819 Igor (Must be last)

const //update every year
  //license keys
  //ScanId2 = 'S2-2013';  //20150607 //??? //scan AppId
  ScanId2 = 'S2-2027'; // 'S2-2023';

  //20150607  TRIED BUT IT DOES NOT WORK  T2F2-2015 is not defined
  //2015 F2 factors
  T2F2_2026 = 57; //20280827 Alex
  S2F2_2026 = 63; //20280827 Alex

 
 //20191015 Igor >>>
  //20191021 Igor >>>
  //20150607   Changed pgm factors but still a problem
  PgmLicenses: array[0..15] of RPgmLicenseData = (                          //20170627  //20200916 Igor
  //PgmLicenses: array[0..11] of RPgmLicenseData = (
    //20280827 Alex >>>
    (Name: 'T2 Demo';               Id: 'T200'; Factor: 32; Level: llDemo),  //20160223 Igor //20240905 Igor
    (Name: 'T2 Limited';            Id: 'T201'; Factor: 33; Level: llLimited),  //20160223 Igor   //limited to 2 returns //20240905 Igor
    (Name: 'T2 Limited With Efile'; Id: 'T203'; Factor: 34; Level: llLimEfile),  //20160223 Igor //4 returns //20240905 Igor
    (Name: 'T2 Standard';           Id: 'T204'; Factor: 35; Level: llStd),  //20160223 Igor //20240905 Igor
    (Name: 'T2 MultiOffice';        Id: 'T205'; Factor: 36; Level: llMulti),  //20160223 Igor //20240905 Igor
    (Name: 'T2 Power';              Id: 'T206'; Factor: 37; Level: llPower),  //20160223 Igor //20240905 Igor
    (Name: 'T2 MultiPower';         Id: 'T207'; Factor: 38; Level: llMultiPower),  //20160223 Igor //20240905 Igor
    (Name: 'T2 Enterprise';         Id: 'T214'; Factor: 45; Level: llEnterprise),  //20200916 Igor //20240905 Igor
    //some changes by  CON 20170628
    (Name: 'T2 Limited to 1 return';  Id: 'T208'; Factor: 39; Level: llLimited1Returns),  //20170502 Igor //20240905 Igor
    (Name: 'T2 Limited to 2 returns'; Id: 'T209'; Factor: 40; Level: llLimited2Returns),  //20170502 Igor  not in mclnt, nor Authorize 20170627 CON //20240905 Igor
    (Name: 'T2 Limited to 3 returns'; Id: 'T210'; Factor: 41; Level: llLimited3Returns),  //20170502 Igor //20170502 Igor  not in mclnt, nor Authorize 20170627 CON //20240905 Igor
    (Name: 'T2 Limited to 4 returns'; Id: 'T211'; Factor: 42; Level: llLimited4Returns),  //20170502 Igor //20170502 Igor  not in mclnt, nor Authorize 20170627 CON //20240905 Igor
    (Name: 'T2 Limited to 5 returns'; Id: 'T212'; Factor: 43; Level: llLimited5Returns),  //20170502 Igor //20170502 Igor  not in mclnt, nor Authorize 20170627 CON //20240905 Igor
    (Name: 'T2 Limited to 6 returns'; Id: 'T213'; Factor: 44; Level: llLimited6Returns),

    //scan license
    (Name: 'S2 Standard'; Id: 'S201'; Factor: 82; Level: llStd), //20240905 Igor
    //dummy for invalid license
    (Name: 'Unlicensed'; Id: ''; Factor: 0; Level: llNone; Caps: [])
    //20280827 Alex <<<
    );
    //20191021 Igor <<<
    //20191015 Igor <<<

(* /20191021
 //20191015 Igor >>>
  //20150607   Changed pgm factors but still a problem
  PgmLicenses: array[0..8] of RPgmLicenseData = (                          //20170627
  //PgmLicenses: array[0..11] of RPgmLicenseData = (
    (Name: 'T2 Demo';               Id: 'T200'; Factor: 25; Level: llDemo),  //20160223 Igor
    (Name: 'T2 Limited';            Id: 'T201'; Factor: 26; Level: llLimited),  //20160223 Igor   //limited to 2 returns
    (Name: 'T2 Limited With Efile'; Id: 'T203'; Factor: 27; Level: llLimEfile),  //20160223 Igor //4 returns
    (Name: 'T2 Standard';           Id: 'T204'; Factor: 28; Level: llStd),  //20160223 Igor
    (Name: 'T2 MultiOffice';        Id: 'T205'; Factor: 29; Level: llMulti),  //20160223 Igor
    (Name: 'T2 Power';              Id: 'T206'; Factor: 30; Level: llPower),  //20160223 Igor
    (Name: 'T2 MultiPower';         Id: 'T207'; Factor: 31; Level: llMultiPower),  //20160223 Igor
    //some changes by  CON 20170628
    {(Name: 'T2 Limited to 1 return';  Id: 'T208'; Factor: 32; Level: llLimited1Returns),  //20170502 Igor
    (Name: 'T2 Limited to 2 returns'; Id: 'T209'; Factor: 33; Level: llLimited2Returns),  //20170502 Igor  not in mclnt, nor Authorize 20170627 CON
    (Name: 'T2 Limited to 3 returns'; Id: 'T210'; Factor: 34; Level: llLimited3Returns),  //20170502 Igor //20170502 Igor  not in mclnt, nor Authorize 20170627 CON
    (Name: 'T2 Limited to 4 returns'; Id: 'T211'; Factor: 35; Level: llLimited4Returns),  //20170502 Igor //20170502 Igor  not in mclnt, nor Authorize 20170627 CON
    (Name: 'T2 Limited to 5 returns'; Id: 'T212'; Factor: 36; Level: llLimited5Returns),  //20170502 Igor //20170502 Igor  not in mclnt, nor Authorize 20170627 CON
    (Name: 'T2 Limited to 6 returns'; Id: 'T213'; Factor: 37; Level: llLimited6Returns),
    }
    //scan license
    (Name: 'S2 Standard'; Id: 'S201'; Factor: 76; Level: llStd),
    //dummy for invalid license
    (Name: 'Unlicensed'; Id: ''; Factor: 0; Level: llNone; Caps: [])
    );
    //20191015 Igor <<<
*)

  GifiFormName = 'FNOTE2'; //Elm=222
  S60FormName = 'S60';
{$IFDEF old}
  S60MemoIndex: array[1..5] of integer = (
    //240,242,244,250,252
    240, 242, 244, 246 //2014
    );
{$ELSE}
const
  S60MemoIdx: array[240..252] of byte = (
    1, 0, 2, 0, 3, 0, 4, 0, 0, 0, //Id of 246=4
    0, 0, 0 //2013: 4,0,5
    );
{$ENDIF}

(* 20191016
  //20150607   Changed pgm factors but still a problem
  PgmLicenses: array[0..14] of RPgmLicenseData = (                          //20170627
  //PgmLicenses: array[0..11] of RPgmLicenseData = (
    (Name: 'T2 Demo';               Id: 'T200'; Factor: 25; Level: llDemo),  //20160223 Igor
    (Name: 'T2 Limited';            Id: 'T201'; Factor: 26; Level: llLimited),  //20160223 Igor   //limited to 2 returns
    (Name: 'T2 Limited With Efile'; Id: 'T203'; Factor: 27; Level: llLimEfile),  //20160223 Igor //4 returns
    (Name: 'T2 Standard';           Id: 'T204'; Factor: 28; Level: llStd),  //20160223 Igor
    (Name: 'T2 MultiOffice';        Id: 'T205'; Factor: 29; Level: llMulti),  //20160223 Igor
    (Name: 'T2 Power';              Id: 'T206'; Factor: 30; Level: llPower),  //20160223 Igor
    (Name: 'T2 MultiPower';         Id: 'T207'; Factor: 31; Level: llMultiPower),  //20160223 Igor
    //some changes by  CON 20170628
    (Name: 'T2 Limited to 1 return';  Id: 'T208'; Factor: 32; Level: llLimited1Returns),  //20170502 Igor
    (Name: 'T2 Limited to 2 returns'; Id: 'T209'; Factor: 33; Level: llLimited2Returns),  //20170502 Igor  not in mclnt, nor Authorize 20170627 CON
    (Name: 'T2 Limited to 3 returns'; Id: 'T210'; Factor: 34; Level: llLimited3Returns),  //20170502 Igor //20170502 Igor  not in mclnt, nor Authorize 20170627 CON
    (Name: 'T2 Limited to 4 returns'; Id: 'T211'; Factor: 35; Level: llLimited4Returns),  //20170502 Igor //20170502 Igor  not in mclnt, nor Authorize 20170627 CON
    (Name: 'T2 Limited to 5 returns'; Id: 'T212'; Factor: 36; Level: llLimited5Returns),  //20170502 Igor //20170502 Igor  not in mclnt, nor Authorize 20170627 CON
    (Name: 'T2 Limited to 6 returns'; Id: 'T213'; Factor: 37; Level: llLimited6Returns),
    //scan license
    (Name: 'S2 Standard'; Id: 'S201'; Factor: 76; Level: llStd),
    //dummy for invalid license
    (Name: 'Unlicensed'; Id: ''; Factor: 0; Level: llNone; Caps: [])
    );

  GifiFormName = 'FNOTE2'; //Elm=222
  S60FormName = 'S60';
{$IFDEF old}
  S60MemoIndex: array[1..5] of integer = (
    //240,242,244,250,252
    240, 242, 244, 246 //2014
    );
{$ELSE}
const
  S60MemoIdx: array[240..252] of byte = (
    1, 0, 2, 0, 3, 0, 4, 0, 0, 0, //Id of 246=4
    0, 0, 0 //2013: 4,0,5
    );
{$ENDIF}
*)

type
  TFListT2 = class(TFList)
  protected
    function LoadFromTable(Table1: TDataSet): TFRec; override; // 20150920 Igor
  end;

//20191015 Igor >>>  
type
  TBNList = class(TStringList)
  protected
    function GetEncryptedText: string;
    procedure SetEncryptedText(Value: string);
    function NormalizeFileName(AFileName: string): string;
    function GetBN(AIndex: integer): string;
    function GetYearEnd(AIndex: integer): string;
  public
    procedure LoadFromFile(const FileName: string); override;
    procedure SaveToFile(const FileName: string); override;
    property EncryptedText: string read GetEncryptedText write SetEncryptedText;
    property BN[AIndex: integer]: string read GetBN;
    property YearEnd[AIndex: integer]: string read GetYearEnd;
  end;

const
  BNListKey = 'T6kYmS9b?A$=9yChLYCG';
  
//20191015 Igor <<<

type
  TAppT2_2027 = class(TApp2018)
  private
    {inherited
     ActiveBoxColor      : string; //[20];
     DataInBold          : Boolean;
     DecimalAssume       : Boolean;
     Dir_Cur      : string; //[80];   //20120201  from 70
     FormZoom            : Integer;
     NoTypeAhead         : Boolean;
     UseProperName       : Boolean;
     Prp_EMail,
     Prp_BusNo,
     Prp_ContactFN,
     Prp_ContactLN,
     Prp_ContactPos,
     Prp_RepId,
     Prp_Name,
     Prp_Street,
     Prp_City,
     Prp_Prov,
     Prp_Postal,
     Prp_Countr,
     Prp_Area,
     Prp_OrgType,
     Prp_Tel,
     Prp_FxArea,
     Prp_Fax,
     Prp_DiscNo,
     Prp_DiscNm,
     Prp_GSTNo: string;
     Prp_Bill     : string; //[1];
     Prp_VSFee    : Integer;
     Prp_SFee     :Integer;
     Prp_AFee     :Integer;
     Prp_CFee     :Integer;
     Prp_VCFee    :Integer;
     Prp_GSTRat   : String;
     Prp_Hour     :Real;
     Prp_Elect    :Boolean;
     Prp_EfRepr   :Boolean;
     Prp_Dates    :Boolean;
    }
    {shared
     HideMostRecent      : Boolean;
     Prn_LMargin,
     Prn_RMargin : String;
     Prn_FontIncr: string; //[1];
     UpdateFrequency     : String;
    }
  public //options
    //Dir_Deflt, //20170310 Igor
      Dir_LastYr,
      Dir_PgmLastYr, //20160321 Igor
      //Dir_ClientDocs, //20170308 Igor
      { //20160523
      Dir2006,
      Dir2005,
      Dir2004,
      Dir2003,
      Dir2002,
      Dir2001,
      }
      Dir_PrvLYr,
      BackUpDir,
      LastBackupDir,
      BackupFrequency: string;

    Dir_Train,
      Dir_Sample: string;

    Reviewer_Name,
      Reviewer_EMail,
      Reviewer_Area,
      Reviewer_Tel,

    Nfl_Prov: string; {New File defqaults}
    Nfl_City: string;
    Nfl_Disced: string; //[1];
    Nfl_Efile: Boolean;

    Ef_ThirdParty: Boolean; //20110601
    EF_Method,
      Ef_PrepNo,
      Ef_TransNo,
      Ef_PsWord,
      Ef_ProdNo,
      Ef_TestNo,
      Ef_DataDir,
      Ef_EncDir,
      Ef_DialNo,
      Ef_NUI,
      Ef_NuiPass: string;
    Ef_Port: Integer;
    Ef_Baud: Integer;
    Ef_Protocl,
      Ef_Centre,
      Ef_PrepId: string;
    Ef_PrnPort: Integer;
    Ef_Carrier,
      Ef_Stage: string;

    Prn_Head: Boolean;
    Prn_NameH: Boolean;
    Prn_SinH: Boolean;
    Prn_DateH: Boolean;
    Prn_Disclm: string;
    Prn_logoln: integer;
    Opr_Recalc: Boolean;
    Opr_Close: Boolean;
    Opr_FPres: Integer;
    Opr_GstHst: Real;
    //other options
    ShowTreeViewSW: Boolean;
    ShowUsedForms: Boolean;
    OpenAtLastForm: Boolean;
    ShowConsultantOnInv: Boolean;
    UseFastPrint: Boolean;
    UseFormSearch: Boolean;
    ShowVisitedForms: Boolean;
    ShowInvoiceWarning: Boolean;
    RolloverProgram: string;

    InvFoot1,
      InvFoot2,
      InvFoot3,
      InvFoot4,
      InvFoot5: string;

    NoBarCode: Boolean;
    Capitalization: string;
    AllowedBN: TBNList; //20191015 Igor
    FileNameFormat      : string; //20201013 Igor

  protected
    //must override
    function GetAppName: string; override;
    function GetAppDir: string; override; //20180503 Igor
    Function GetAppRelease: string; override;
    function GetAppUpdateDate: string; override;
    function GetAppYear: string; override;
    function GetDfmFileName(const FormName: string): string; override;
    function GetDfmFileNameLY(const FormName: string): string; override;
    function GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160226 Igor //20160303 Igor
    function GetSQLLiteRFPassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160415 Igor
    function GetValidLastYearPgmFolder: Boolean; override; //20160302 Igor
    function GetValidLastYearDataFolder: Boolean; Override; //20160302 Igor
    function GetLastYearFormNo(AFormName: String): Integer; override; //20160302 Igor
    function GetSubstituteLastYearForm(AFormName: String): String; override; //20160302 Igor
    function GetLastYearDataFolder: String; override; //20160302 Igor
    function GetInitLastYear: Boolean; Override; //20160424 Igor
    function GetHelpFile: String; override; //20160526 Igor
    function GetHelpUpdFile: String; override; //20160526 Igor
    function GetLimitedVersionDir: String; override; //20160718 Igor
    procedure CreateDefaultDataDirectories; override;//20170811 Igor
    function GetLimitReturns: Integer; Override;//20170901 Igor
    function GetRightTabSheets: TRightTabSheets; Override;//20180603 CON
    //20180503 Igor >>>
    procedure InitStorage;
    function Factor2: Byte; override;
    //20180503 Igor <<<
    // 20180712 Igor >>>
    function GetEfilerNumber: string; override;
    function GetTaxationYear: string; override;
    function GetAdditionalInfo: string; override;
    // 20180712 Igor <<<
    procedure LoadBN; //20191015 Igor

  public
    constructor Create(AppList: TAppList); override; // 20151118 Igor
    destructor Destroy; override; //20191015 Igor
    //implement abstract methods
    function GetMenu: TMainMenu; override;
    function GetToolBar: TControl; override;//20170824 Igor
    function GetSplash: TCustomControl; override;
    procedure SelectFeatures; override;
    //20160114 Igor
    procedure SetZoomCaption(AZoom: Integer); override;
    function ConvertToLastYearName(AFileName: String): String; override; //20160424 Igor
    procedure ReloadMainMenu; override; //20190307 Igor
  public //cross-app adds
    function InitNewReturn(ForLoad: boolean = False): integer; override;
    function OpenReturn(DirName, FlName: string; fShow: boolean; AIsAppendix: Boolean = False): integer; override;
    function SaveReturn(RetNo: Integer; DataDir: string; FlName: string;
      OverrideSW: boolean; UpdMostRecent: boolean; ATextFormat: boolean = False;
      AUpdateClientTable: boolean = True; AClouds: TArrayOfInteger = nil): Integer; override; //20200914 Igor //20200916 Igor
    function OpenForeignForm(const ADir, AFile, AForm: String; const AElement: Integer): TFormData; override; //20170717 Igor
    function CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; override; //20160516 Igor
    function CheckLastYearDataFolder(out AErrorMessage: String): Boolean; override; //20160516 Igor
    function GetDefaultOptionsValue(AOptionName: String): String; override; //20160617 Igor
    function GetOptionsCaption(AOptionName: String): String; override; //20160617 Igor
    function HaveOptions(AOptionsName: String): Boolean; override; //20170112 Igor
    function GetDefaultOptions: TStringList; override; //20160617 Igor
    procedure LoadOptionsFileToMem; override; //20160617 Igor
    procedure InitFList; override; //20160617 Igor
    procedure SaveSingleOptions(const AOptionName, AValue: String; AOptionsFileName: String = ''); override; //20160602 Igor //20160617 Igor
    procedure InitFormsTable; override; //20160617 Igor
    function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
      var AErr: String; AOverride: Boolean): Boolean; override; //20160631 Igor
    //20180424 Igor >>>
    function AllowFormForBuildReport(const AFormName: String): Boolean; override;
    function MaskFormDataForBuildReport(const AFormName: String; AFieldNo: Integer;
      AFieldValue: String): String; override;
    //20180424 Igor <<<
    procedure OpenClientBook; override; //20200916 Igor
  public //client letters
    //function  LoadDataDict: TDataDictList; //virtual;
    procedure HelpOnClientLetter; override;
  public //licenses
    //Procedure GetLicenseLevel; virtual;
    function Licenses: PPgmLicenseData; override;
    //procedure SetLicense(const Key: string);
    function ValidateKey(AKey: string): boolean; override;
    function ValidateScanKey(AKey: string): boolean; override;
    //20191015 Igor >>>
    function CheckAllowedBN(ARetNo: integer; ASilent: boolean = false): boolean; 
    function GetBNText: string; override;
    procedure SetBNText(const Value: string); override;
    function IsBNButtonVisible: boolean; override;
    //20191015 Igor <<<
    function ExceedsMaxReturnsAllowed(ABeforeCreateNew: Boolean): Boolean; override;
  end;

  TRetT2_2027 = class(TRetData)
  protected
    function GetLocked: Boolean; override;
    procedure SetLocked(const Value: boolean); override;
    function GetOldGifiDataConverted: Boolean; //20160721 Igor
    procedure SetOldGifiDataConverted(const Value: boolean); //20160721 Igor
  public
    {inherited
     AuditList      : TSingleStringList;
     EFileErrorCount    :Integer;
     ErrorCount         :Integer;
     Ln          : Array[LnLowBound..LnHighBound] of real;
     MandatoryErrorCount:Integer;
     Notes       : string;  //[80];
     Province    : String;
     PrpStatus, //   : string; //[2];
     Saved        : boolean; - dropped
     SeriousErrorCount  :Integer;
     SourceDataDir : string;  //dir it came from
     SourceFlName : string;  //file name it came from via readreturn
    }
    Tbl: array[0..FormsLimit] of array of array of string; //row, column  //20110422  //Locked       : Boolean;
    DaysInYear: Integer;
    FedCalcStatus: Boolean;
    OntCalcStatus: Boolean;
    AlbCalcStatus: Boolean;
    OpenedForms: TSingleStringList;
    PreselForms: TSingleStringList;
    CouplingSw: Boolean;
    OntAlloc: Real;
    AlbAlloc: Real;
    CorpType: TCorpTypes; {integer;}
    PartYear: Real;
    Bankrupt: Boolean;
    Balance: Real;
  public
    constructor Create(TheApp: TApp); override;
    destructor Destroy; override;
    function AddPageInstance(NonInstFormName, FormInst: string): integer; override;
    procedure CloneForm(FromFormName: string; ToRetNo: integer; ToFormName: string; fAll: boolean); override;
    procedure CloneReturn(ToRetNo: integer); override;
    //procedure InitFormData(FNo: integer); override;
    function Close(fRemove: boolean): boolean; override;
  public //utils
    function NewChild: TMyChild; override;
    function BeforeOpenForm(var FormName: string; var FormNo: integer): string; override;
    function GetReturnCaption: string; override;
    function GetReturnName: string; override; //for printing
    function DoSave: boolean; override; //part of SaveAllReturns
    procedure DoSaveAs; override; //using SaveAs dialog
    function GetDefaultFileName: String; override; //20160305 Igor
    function GetCloudFileName: String; override; //20190312 Igor
    function GetFirstName: string; override; //20150606       //outstanding
    function GetLastName: string; override; //20150606       //outstanding
    function GetLastYearFile: String; override; //20160701 Igor
    procedure SetLastYearFile(const AValue: String); override; //20160701 Igor
    function GetTDDFileName: String; override; // 20180530 Igor
  public //forms
    function GetDfmFileName(const FormName: string): string; override;

    procedure GetFrmTree(TreeView: TTreeView; fUsedForms: boolean); override;
    function GetFrmTreeFNo(SourceNode: TTreeNode; fUsedForms: boolean): integer; override;
    function FormClass: TvtFormClass; override; //20161211 Igor
    function IsLetterForm(AFormName: String): Boolean; override; //20161211 Igor

  public //calculations
    procedure Calc(RNo: integer; const FName: string; FNo: integer = -1); override;
    procedure CalcAll; override;
    //procedure CalcFullReturn; override;
    procedure ReCalcEveryThing; override;
    procedure SetCalcStatus(const Value: boolean); override;
    procedure CountDiagnostics; override;
    property OldGifiDataConverted: Boolean read GetOldGifiDataConverted write SetOldGifiDataConverted; //20160721 Igor
  public //letters
    function GetInterpetedRichEdit(LetterName: string; ARichEdit: TRichEdit): boolean; override;
    //no such functions?
  public //visual feedback
    function RefreshAuditPanel(ReturnsHeaderPanel: TPanel; ErrorView: TTreeView; AuditMode: eAuditMode): string; override;
    procedure StartPrintForm(FormName: string; WhichPage: integer); override;
  end;

  TRetT2_LastYear = class(TRetT2_2027)
  public
    constructor Create(TheApp: TApp); override;
  end;


  TRetListT2 = class(TRetList)
  private
    function GetRet(RetNo: integer): TRetT2_2027;
  public
    property Return[RetNo: integer]: TRetT2_2027 read GetRet; default;
  end;
var
  Ret: TRetListT2 absolute RetList; //fake typed returns
  AppT2: TAppT2_2027;
  OptRec: TAppT2_2027 absolute AppT2;

procedure Calc(RetNo: integer; FName: string; FNo: integer = -1); {ALL FORMS IN CAPITAL}
procedure CalcAffectedBy(RetNo: integer; FName: string);
function GetAuthorizationKey: string;
function GetScanAuthorizationKey: string;
function GetScanLicenseLevel: eLicenseLevel;

implementation

uses
  SysUtils,
  EkRtf, ekbasereport, ekfunc,
  vtMain, vtAuthorization, vtCommon, vtDialogs, vtEditBox,
  T2_2027Multi,
  T2_2027TrimStr, T2_2027main, T2_2027childwinnew, T2_2027common, T2_2027common2,
  T2_2027Calc, T2_2027Calc1, T2_2027Calc2, T2_2027Calc3, T2_2027Calc4, T2_2027Calc5, T2_2027CalcPdf,
  T2_2027CntErr,
  T2_2027CalcSers, //20240724 Igor
  vtTrimStr, vtShared;

procedure CalcAffectedBy(RetNo: integer; FName: string);
begin
  FList.CalcAffectedBy(RetNo, FName);
end;

procedure Calc(RetNo: integer; FName: string; FNo: integer); {ALL FORMS IN CAPITAL}
var
  FRec: TFRec;
  MyCalc: TCalcRtn;
begin
 if not AppT2.CheckAllowedBN(RetNo, true) then Exit; //20191015 Igor
 FRec := FList.ByFormName(FName);
  if not assigned(FRec.Calc) then
  begin
    if FName = 'T2' then
      MyCalc := @T2
    else if FName = 'T183CP' then
      MyCalc := @T183CP
    else if FName = 'BLIMIT' then  MyCalc := @BLIMIT
    else if FName = 'AFRBAL' then MyCalc := @AFRBAL    //20211213 Con
    else if FName = 'TAXSUM' then
      MyCalc := @TAXSUM
    else if FName = 'COMPSUM' then
      MyCalc := @COMPSUM

    else if FName = 'CBCR' then MyCalc := @CBCR    //20180614  Con

    else if FName = 'GROUPINFO' then MyCalc := @GroupInfo    //20170719  Con

    else if FName = 'S141' then MyCalc := @S141    //20160425  Con
      //    else if FName = 'S141' then   //instead of FNote1
      //      MyCalc := @S141
    else if FName = 'FNOTE2' then
      MyCalc := @FNOTE2
    else if FName = 'AMEND' then
      MyCalc := @AMEND


    else if FName = 'EMAILINFO' then MyCalc := @EMAILINFO  //20160630

    else if FName = 'SALDIVSET' then MyCalc := @SALDIVSET  //20190614 //20200819
   // else if FName = 'SALDIVC' then MyCalc := @SALDIVC  //20190614

    else if FName = 'TESTFRM' then
      MyCalc := @TESTFRM
        {Schedules}
    else if FName = 'S1' then
      MyCalc := @S1

    else if FName = 'S2' then
      MyCalc := @S2

    else if FName = 'S3' then
      MyCalc := @S3

    else if FName = 'S4' then
      MyCalc := @S4
        //added T2-2014
    else if FName = 'S4WS' then
      MyCalc := @S4WS

    else if FName = 'S5' then
      MyCalc := @S5

    else if FName = 'S6' then
      MyCalc := @S6

    else if FName = 'S6RE' then
      MyCalc := @S6RE

  //  else if FName = 'S7OLD' then  MyCalc := @S7OLD
    else if FName = 'S7' then
      MyCalc := @S7

       //20190302
  //  else if LeftStr(FName, 3) = 'S8NEW#' then MyCalc := @S8NEW


    else if LeftStr(FName, 3) = 'S8#' then
      MyCalc := @S8
   // else if LeftStr(FName, 7) = 'S8FREE#' then MyCalc := @S8FREE //20260718
   // else if LeftStr(FName, 8) = 'S8LFREE#' then  MyCalc := @S8LFREE
   // else if FName = 'S8LH' then  MyCalc := @S8LH
    else if FName = 'S8ALL' then
      MyCalc := @S8ALL
    else if FName = 'S9' then
      MyCalc := @S9

   // else if FName = 'S10' then MyCalc := @S10
      //20171022
   // else if FName = 'S10OLD' then  MyCalc := @S10OLD

    else if FName = 'S11' then
      MyCalc := @S11

    else if FName = 'S12' then
      MyCalc := @S12

    else if FName = 'S13' then
      MyCalc := @S13
    else if FName = 'S14' then
      MyCalc := @S14
    else if FName = 'S15' then
      MyCalc := @S15

    else if FName = 'S16' then
      MyCalc := @S16

    else if FName = 'S17' then
      MyCalc := @S17
    else if FName = 'S18' then
      MyCalc := @S18

    else if FName = 'S19' then
      MyCalc := @S19

    else if FName = 'S20' then
      MyCalc := @S20

    else if FName = 'S21' then
      MyCalc := @S21

    else if FName = 'S21P' then
      MyCalc := @S21P
    else if FName = 'S21SP' then
      MyCalc := @S21SP

    else if FName = 'S22' then
      MyCalc := @S22
    else if FName = 'S23' then
      MyCalc := @S23
    else if FName = 'S24' then
      MyCalc := @S24
    else if FName = 'S25' then
      MyCalc := @S25
    else if FName = 'S27RATE' then
      MyCalc := @S27RATE

    else if FName = 'S27' then
      MyCalc := @S27
    else if FName = 'S28' then
      MyCalc := @S28
    else if FName = 'S29' then
      MyCalc := @S29

    else if FName = 'S31' then
      MyCalc := @S31
    else if FName = 'S33' then
      MyCalc := @S33

    else if FName = 'S34' then
      MyCalc := @S34

    else if FName = 'S35' then
      MyCalc := @S35

    else if FName = 'S38' then
      MyCalc := @S38
    else if FName = 'S39' then
      MyCalc := @S39
    else if FName = 'S40' then
      MyCalc := @S40
    else if FName = 'S41' then
      MyCalc := @S41
    else if FName = 'S42' then
      MyCalc := @S42

    else if FName = 'S43' then
      MyCalc := @S43

    else if FName = 'S44' then
      MyCalc := @S44
    else if FName = 'S45' then
      MyCalc := @S45
    else if FName = 'S46' then
      MyCalc := @S46

      {Mult statements}
    else if LeftStr(FName, 4) = 'S48#' then
      MyCalc := @S48

    else if LeftStr(FName, 4) = 'S58#' then
      MyCalc := @S58

    else if LeftStr(FName, 6) = 'FLDMEM' then
      MyCalc := @FldMem
    else if LeftStr(FName, 7) = 'FLDTAPE' then
      MyCalc := @FldTape

    else if FName = 'S49' then
      MyCalc := @S49
    else if FName = 'S50' then
      MyCalc := @S50
    else if LeftStr(FName, 3) = 'S52' then MyCalc:= @S52 //20261006 Alex

    else if LeftStr(FName, 4) = 'S60#' then
      MyCalc := @S60

    else if FName = 'S51' then
      MyCalc := @S51

    else if FName = 'S51CRN' then
      MyCalc := @S51CRN
    else if FName = 'S53' then
      MyCalc := @S53
    else if LeftStr(FName, 7) = 'S53ADJ#' then
      MyCalc := @S53ADJ
    else if FName = 'S53ADD06' then
      MyCalc := @S53ADD06

    else if FName = 'S54' then
      MyCalc := @S54

    //20221104
    else if LeftStr(FName,6) = 'S54WS1' then  MyCalc := @S54WS1
    else if LeftStr(FName,6) = 'S54WS2' then  MyCalc := @S54WS2

    else if LeftStr(FName, 7) = 'S54ADJ#' then
      MyCalc := @S54ADJ
    else if FName = 'S55' then MyCalc := @S55

    //t22020509
    else if FName = 'S59' then MyCalc := @S59
    else if FName = 'S63' then MyCalc := @S63
   // else if FName = 'S65' then MyCalc := @S65  //220260526

    else if FName = 'S67' then MyCalc := @S67
    else if FName = 'S68' then MyCalc := @S68
    else if FName = 'S444' then MyCalc := @S444


    else if FName = 'S351' then MyCalc := @S351

    else if LeftStr(FName, 5) = 'S51P#' then
      MyCalc := @S51P
    else if FName = 'S88' then
      MyCalc := @S88

    else if FName = 'S100' then  MyCalc := @S100 //20150816
    else if FName = 'S101' then  MyCalc := @S101 //20150816
    else if LeftStr(FName,5) = 'S125#' then MyCalc := @S125 //20150721 //20150816
    else if FName = 'S140' then MyCalc := @S140

    else if FName = 'T7DRQR' then MyCalc := @T7DRQR  //20220614

    else if FName = 'T106' then
      MyCalc := @T106
    else if LeftStr(FName, 7) = 'T106SL#' then
      MyCalc := @T106SL
    else if FName = 'CDA' then
      MyCalc := @CDA
    else if LeftStr(FName, 6) = 'T1131#' then
      MyCalc := @T1131

    else if LeftStr(FName, 6) = 'T1163#' then
      MyCalc := @T1163
    else if LeftStr(FName, 6) = 'T1273#' then
      MyCalc := @T1273
    else if LeftStr(FName, 8) = 'T1273A1#' then
      MyCalc := @T1273A1
    else if LeftStr(FName, 8) = 'T1273A2#' then
      MyCalc := @T1273A2

    else if FName = 'T2002' then
      MyCalc := @T2002
   // else if FName = 'S300' then MyCalc := @S300   //20181114
    else if FName = 'S301' then
      MyCalc := @S301
    else if FName = 'S302' then
      MyCalc := @S302
    else if FName = 'S303' then
      MyCalc := @S303
    else if FName = 'S304' then
      MyCalc := @S304
    else if FName = 'S305' then
      MyCalc := @S305
    else if FName = 'S306' then
      MyCalc := @S306
    else if FName = 'S307' then
      MyCalc := @S307

    else if FName = 'S308' then  MyCalc := @S308  //20171120
    else if FName = 'S309' then  MyCalc := @S309

    else if FName = 'S310' then  MyCalc := @S310
    else if FName = 'S311' then  MyCalc := @S311

    else if FName = 'S321' then
      MyCalc := @S321
    else if FName = 'S322' then
      MyCalc := @S322
    else if FName = 'S340' then
      MyCalc := @S340
    else if FName = 'S346' then
      MyCalc := @S346
    else if FName = 'S341' then
      MyCalc := @S341
    {
    else if FName = 'S342' then
      MyCalc := @S342
    else if FName = 'S343' then
      MyCalc := @S343
    }
     //else if FName = 'S344'    then MyCalc := @S344

   // else if FName = 'S345' then MyCalc := @S345 //20220509
    else if FName = 'S347' then
      MyCalc := @S347

    else if FName = 'S348' then  MyCalc := @S348
    else if FName = 'S349' then  MyCalc := @S349
    else if FName = 'S350' then  MyCalc := @S350
    else if FName = 'S352' then  MyCalc := @S352
    else if FName = 'S353' then  MyCalc := @S353 //20220918

    else if FName = 'S360' then
      MyCalc := @S360
   // else if FName = 'S365' then MyCalc := @S365  //20220509
    else if FName = 'S366' then
      MyCalc := @S366
    else if FName = 'S380' then
      MyCalc := @S380
    else if FName = 'S381' then
      MyCalc := @S381
    else if FName = 'S383' then
      MyCalc := @S383
    else if LeftStr(FName, 5) = 'S384#' then
      MyCalc := @S384
    else if FName = 'S385' then
      MyCalc := @S385
    else if FName = 'S387' then
      MyCalc := @S387
    else if LeftStr(FName, 5) = 'S388#' then
      MyCalc := @S388
    else if FName = 'S389' then
      MyCalc := @S389
    else if FName = 'S390' then
      MyCalc := @S390
    //else if FName = 'S391' then MyCalc := @S391  //20210516
    else if FName = 'S392' then MyCalc := @S392       //20221123
    //else if FName = 'S393' then MyCalc := @S393
    else if FName = 'S394' then
      MyCalc := @S394
    else if FName = 'S400' then
      MyCalc := @S400
    else if FName = 'S402' then
      MyCalc := @S402
    else if FName = 'S403' then
      MyCalc := @S403
    else if FName = 'S404' then MyCalc := @S404
    else if FName = 'S411' then MyCalc := @S411
    else if FName = 'S420' then MyCalc := @S420
    else if FName = 'S421' then MyCalc := @S421
    else if LeftStr(FName, 5) = 'S422#' then MyCalc := @S422
    else if FName = 'S427' then MyCalc := @S427
    else if LeftStr(FName, 5) = 'S428#' then MyCalc := @S428
    else if FName = 'S429' then  MyCalc := @S429
    else if FName = 'S430' then MyCalc := @S430
    else if FName = 'S432' then MyCalc := @S432  //20230628
    else if FName = 'S440' then  MyCalc := @S440
    else if FName = 'S444' then  MyCalc := @S444 //20220511
    else if FName = 'S442' then  MyCalc := @S442
    else if FName = 'S443' then  MyCalc := @S443
    else if FName = 'S461' then  MyCalc := @S461
    else if FName = 'S481' then  MyCalc := @S481
    else if FName =  'S91' then   MyCalc := @S91
    else if FName =  'S97' then   MyCalc := @S97
    else if LeftStr(Fname, 4) = 'S71#' then MyCalc := @S71
    else if LeftStr(Fname, 4) = 'S72#' then MyCalc := @S72
    else if FName = 'S73' then MyCalc := @S73
    else if FName = 'S75' then MyCalc := @S75 //JZ 20241201

    else if FName = 'S76' then MyCalc := @S76 //20250530
    else if FName = 'S77' then MyCalc := @S77 //20260508 Alex
    else if leftStr(FName,3) = 'S78' then MyCalc := @S78 //20250608
    else if FName = 'S130' then MyCalc := @S130 //20250530
    else if FName = 'T2184' then MyCalc := @T2184 //20250530

    else if FName = 'USEDFRM' then MyCalc := @USEDFRM
    else if FName = 'INVOICE' then MyCalc := @INVOICE
    else if FName = 'INVFORMS' then MyCalc := @INVFORMS
    else if FName = 'POLIT' then
      MyCalc := @POLIT
    else if FName = 'ADDINFO' then
      MyCalc := @ADDINFO
    else if FName = 'INSTLM' then
      MyCalc := @INSTLM

    else if FName = 'T400A' then
      MyCalc := @T400A

    else if FName = 'T661' then
      MyCalc := @T661

    else if LeftStr(FName, 4) = 'S30#' then  MyCalc := @S30
    else if LeftStr(FName, 5) = 'T661F' then MyCalc := @T661F
    else if FName = 'S425' then  MyCalc := @S425
    else if FName = 'T5004' then MyCalc := @T5004
    else if FName = 'T2054' then MyCalc := @T2054  //20180616
    else if FName = 'T1521' then MyCalc := @T1521  //20250812

    else if FName = 'T1134' then MyCalc := @T1134  //20180611
    else if LeftStr(FName, 7) = 'T1134S#' then MyCalc := @T1134S  //20171124
    else if FName = 'T1521' then MyCalc := @T1521  //20250826 Igor
    else if FName = 'T2055' then MyCalc := @T2055  //20250901 Igor
    else if FName = 'T2123' then MyCalc := @T2123  //20250901 Igor
    else if FName = 'S151' then MyCalc := @S151  //20250901 Igor
    else if FName = 'S150' then MyCalc := @S150  //20250908 Igor
    else if (LeftStr(FName, 3) = 'S74') then MyCalc:= @S74 // 20251117 Igor
    else if LeftStr(FName, 5) = 'T2107' then MyCalc:= @T2107 //20251028 Igor

    else if FName = 'T1135' then  MyCalc := @T1135
    else if LeftStr(FName, 6) = 'T1141#' then MyCalc := @T1141
    else if LeftStr(FName, 6) = 'T1142#' then MyCalc := @T1142
    else if LeftStr(FName, 6) = 'T1145#' then MyCalc := @T1145
    else if LeftStr(FName, 6) = 'T1146#' then MyCalc := @T1146
    else if LeftStr(FName, 6) = 'T1174#' then MyCalc := @T1174

    else if FName = 'FASSET' then
      MyCalc := @FASSET
    else if LeftStr(FName, 5) = 'S423#' then
      MyCalc := @S423

    else if LeftStr(FName, 7) = 'S1AUTO#' then
      MyCalc := @S1AUTO
    else if LeftStr(FName, 7) = 'S7RENT#' then
      MyCalc := @S7RENT

    else if LeftStr(Fname, 5) = 'NPAD#' then
      MyCalc := @NPAD
    else if LeftStr(Fname, 5) = 'NPADC' then
      MyCalc := @NPADC
    else if LeftStr(Fname, 6) = 'PRIVAT' then
      MyCalc := @PRIVAT
    else if FName = 'LETR_1' then
      MyCalc := @LETR_1
    else if FName = 'LETR_2' then
      MyCalc := @LETR_2
    else if FName = 'STATUS' then
      MyCalc := @STATUS
    else if FName = 'T7B' then
      MyCalc := @T7B

    else if LeftStr(FName,8) = 'CONSENT#' then MyCalc := @COnsent  //20200215
    else if FName = 'RC59' then MyCalc := @RC59
    else if FName = 'RC59X' then MyCalc := @RC59X  //20180801
    else if FName = 'EFCONFIRM' then MyCalc := @EFCONFIRM
    //else if LeftStr(FName,4) = 'UHT#' then MyCalc := @UHT  //20240405  //20240726 Igor

        {******** Ontario *********}

    else if FName = 'S500' then
      MyCalc := @S500
    else if FName = 'S502' then
      MyCalc := @S502
    else if FName = 'S504' then
      MyCalc := @S504
    else if FName = 'S506' then
      MyCalc := @S506
    else if FName = 'S507' then
      MyCalc := @S507
    else if FName = 'S508' then
      MyCalc := @S508
    else if FName = 'S510' then
      MyCalc := @S510
    else if FName = 'S511' then
      MyCalc := @S511
    else if FName = 'S512' then
      MyCalc := @S512
    else if FName = 'S513' then
      MyCalc := @S513
    else if FName = 'S517' then
      MyCalc := @S517
    else if FName = 'S524' then
      MyCalc := @S524
    else if FName = 'S525' then
      MyCalc := @S525
     //20210516
    //else if FName = 'S546' then MyCalc := @S546
    //else if LeftStr(FName, 5) = 'S547#' then MyCalc := @S547
    //else if FName = 'S548' then  MyCalc := @S548

    else if LeftStr(FName, 5) = 'S550#' then
      MyCalc := @S550
    else if LeftStr(FName, 5) = 'S552#' then
      MyCalc := @S552
    else if LeftStr(FName, 5) = 'S554#' then
      MyCalc := @S554
    else if LeftStr(FName, 5) = 'S556#' then
      MyCalc := @S556
    else if LeftStr(FName, 5) = 'S558#' then
      MyCalc := @S558
    else if LeftStr(FName, 5) = 'S560#' then
      MyCalc := @S560
    else if LeftStr(FName, 5) = 'S562#' then
      MyCalc := @S562
    else if LeftStr(FName, 5) = 'S564#' then
      MyCalc := @S564
    else if FName = 'S566' then
      MyCalc := @S566
    else if FName = 'S568' then
      MyCalc := @S568
    else if LeftStr(FName, 5) = 'S569#' then
      MyCalc := @S569
    else if LeftStr(FName, 4) = 'S570' then MyCalc := @S570

    //else if FName = 'UHT' then MyCalc := @UHT  //20231020  //20240726 Igor
    {******* ALBERTA *********}
    else if FName = 'AT1' then
      MyCalc := @AT1

    else if FName = 'AS1' then
      MyCalc := @AS1
    else if FName = 'AS2' then
      MyCalc := @AS2

    else if FName = 'AS3' then
      MyCalc := @AS3

    else if FName = 'AS4' then
      MyCalc := @AS4
    else if FName = 'AS5' then
      MyCalc := @AS5
    else if FName = 'AS6' then
      MyCalc := @AS6
    else if FName = 'AS7' then
      MyCalc := @AS7
    else if FName = 'AS8' then
      MyCalc := @AS8
   // else if FName = 'AS9' then MyCalc := @AS9 //20231024
    else if LeftStr(FName, 7) = 'AS9SUP#' then MyCalc := @AS9SUP
    else if FName = 'AS9L' then MyCalc := @AS9L
    else if FName = 'AS10' then
      MyCalc := @AS10
    else if FName = 'AS11' then
      MyCalc := @AS11
    else if FName = 'AS12SUP' then
      MyCalc := @AS12SUP

    else if FName = 'AS12' then
      MyCalc := @AS12
    else if LeftStr(FName, 5) = 'AS13#' then
      MyCalc := @AS13
    else if FName = 'AS14' then
      MyCalc := @AS14
    else if FName = 'AS14WS' then
      MyCalc := @AS14WS
    else if FName = 'AS15' then
      MyCalc := @AS15
    else if FName = 'AS16' then
      MyCalc := @AS16
    else if FName = 'AS17' then
      MyCalc := @AS17

    else if FName = 'AS18' then
      MyCalc := @AS18
    else if FName = 'ACAPD' then
      MyCalc := @ACAPD
    else if FName = 'ACAPDRE' then
      MyCalc := @ACAPDRE

    else if FName = 'AEFDONE' then
      MyCalc := @AEfDone

    else if FName = 'AS20' then
      MyCalc := @AS20
    else if FName = 'AS20WS' then
      MyCalc := @AS20WS
    else if FName = 'AS21' then MyCalc := @AS21

    else if FName = 'AS29' then MyCalc := @AS29  //20210530
    else if FName = 'AS29L' then MyCalc := @AS29L  //20210530

    else if FName = 'AS51' then
      MyCalc := @AS51
   // else if FName = 'AT100' then MyCalc := @AT100

    else if FName = 'ACONSENT' then  //20201204
      MyCalc := @ACONSENT

    else if FName = 'AT1013' then
      MyCalc := @AT1013

      //else if FName = 'MCT'  then MyCalc := @MCT
    else if FName = 'T2054' then
      MyCalc := @T2054
        //pdf
    else if FName = 'SCT1' then
      MyCalc := @SCT1
    else if FName = 'CO17' then
      MyCalc := @CO17
    else if FName = 'CO17A1' then
      MyCalc := @CO17A1

    else if FName = 'S56' then //jz 20240424 - adding new forms S56 S572 T2047
      MyCalc := @S56
    else if FName = 'S572' then //jz 20240424 - adding new forms S56 S572 T2047
      MyCalc := @S572
    else if FName = 'T2047' then //jz 20240424 - adding new forms S56 S572 T2047
      MyCalc := @T2047

    else if FName = 'TEST' then
      MyCalc := @TEST
//20160222 Igor <<<

   //sers //20240724 Igor >>>
    else if LeftStr(FName,6) = 'T2057#'  then MyCalc := @T2057
    else if FName = 'T2054'  then MyCalc := @T2054
    else if FName = 'T2058'  then MyCalc := @T2058
    else if FName = 'T2059'  then MyCalc := @T2059
    else if LeftStr(FName, 4) = 'UHT#'  then MyCalc := @UHT2900
    else if LeftStr(FName, 4) = 'T217' then MyCalc := @T217
    else if LeftStr(FName, 3) = 'S89' then MyCalc := @S89
    else if FName = 'T2311' then MyCalc:= @T2311  // 20250714 Igor
    //20240724 Igor <<<

    else
      MyCalc := @NothingToCalc; //dummy
    FRec.Calc := MyCalc;
  end;

  if RetNo > 0 then
  begin
    FNo := FRec.FormNo;
    if (FNo > 0) then
      if (RetList[RetNo].MyApp = AppT2) then //20160323 Igor
      Begin
        if (RetList[RetNo].Frm[Fno].Count = 0) then
          InitFormData(RetNo, FNo);
        FRec.Calc(RetNo, FName, FNo);
      End;
  end;
end;

procedure InitT2; //from main.pas
begin
  (* shared options moved into vtMain.ProgramInit
    corresponding Done - where???
  *)
  BarCodePrinted := False;
  //DataChanged:=False;
  Sc := 1;
  ScChar := 1;
  ScChange := 0;
  RY := 0; {0:current year;Rate year = next year/prelim}

  InitOptions;
  OptRec.Dir_Cur := OptRec.Dir_Deflt;
//  if (LicenseLevel in anyMulti) //20170113 Igor
//    {and (UserName <> 'ADMIN')} then  //20170113 Igor
//20161230 Igor >>>
//  begin
//    OptRec.Dir_Cur := User.Tax_Dir;
//    OptRec.Dir_Deflt := User.Tax_Dir;
//    OptRec.Dir_DBFData :=User.DBFData_Dir; //20160226 Igor
//    OptRec.Ef_DataDir := User.EFile_Dir;
//  end;
//20170112 Igor  <<<
  UpdateDbStructure; //20201015 Igor
  AppT2.InitFList; //20160617 Igor
//  FList := TFListT2.Create(AppT2, FormsLimit, FieldsLimit, FormsDBLite,FormsTableLite);//20150119 Igor
////  AppT2.FList := FList;
////  AppT2.lFormsDBLite    := FormsDBLite;    //20150920 Igor
////  AppT2.lFormsTableLite := FormsTableLite; //20150920 Igor
//  AppT2.ConvertDataBase; //20160304 Igor
//  InitFormsTable; {all forms available}
//  //LoadEditBoxProperties;
//  InitColorTable; {all colors available}
//  InitLists; {Forms and return lists}
//  InitSwitches;
//  InitBmps;
end;

function GetAuthorizationKey: string;
begin
  Result := AppT2.GetAuthorizationKey;
end;

function GetScanAuthorizationKey: string;
begin
  Result := AppT2.GetScanAuthorizationKey;
end;

function GetScanLicenseLevel: eLicenseLevel;
begin
  AppT2.GetScanLicenseLevel;
  Result := AppT2.ScanLicenseLevel; //lvl or string?
end;

{ TAppT2_2027 }

constructor TAppT2_2027.Create(AppList: TAppList);// 20151118 Igor //20220509
begin
  InitMulti;
  CurrentApp := self;
  AppT2 := self;
  //AppIdx := aiT2;
  AppId := 'T2-2027'; //'T2_2027';
  ClientsDBLite:=lClientsDBLite+'_'+AppName+'.db'; //20151017 Igor !!!after AppId!!!//20170731 Igor
//  SQLLitePassword:=T2SQLLitePassword;                      //20151017 Igor //20160226 Igor
  FSQLitePassword := TSQLitePassword.Create(Self); //20160303 Igor
  AppIdx := aiT2;

  //20180503 Igor >>>
  //20200510 Igor >>>
  if SameText(ExtractFileName(Application.ExeName), 'VTDebugT2.exe') then
    T2_2027Declare.AppDir := ExeDir + '\T2Test-2023'
  else if CheckIsCloud(true) then
    T2_2027Declare.AppDir := CloudDir + '\' + AppId //20190213 Igor
  else
    T2_2027Declare.AppDir := ExeDir + '\' + AppId;
  //20200510 Igor <<<
  //20180503 Igor <<<

 // T2_2027Declare.AppDir := ExeDir + '\' + AppId;
 
 FFirstForm := 'T2'; //???
  //FCalcs := TCalcsT1_2012;
  ScanId := ScanId2;
  //20210510 Igor >>>
  if not SameText(ExtractFileName(Application.ExeName), 'VTDebugT2.exe') then
    InitStorage; //20180503 Igor
  //20210510 Igor <<<
  InitT2;
  inherited Create (AppList); // 20151118 Igor //register the AppId
  MainFormT2 := TMainFormT2_2027.Create(Application);
  AddReviewStaticForm('TAXSUM'); //20160220 Igor
  AddReviewStaticForm('COMPSUM'); //20160229 Igor
  AddReviewStaticForm('S1'); //20160418 Con
 //20191015 Igor >>>
  AllowedBN := TBNList.Create;
  LoadBN;
  //20191015 Igor <<<

end;

procedure TAppT2_2027.CreateDefaultDataDirectories;//20170811 Igor
begin
  T2_2027TrimStr.CreateDefaultDataDirectories;
end;


destructor TAppT2_2027.Destroy; //20191015 Igor
begin
  FreeAndNil(AllowedBN);
  inherited;
end;

function TAppT2_2027.ExceedsMaxReturnsAllowed(
  ABeforeCreateNew: Boolean): Boolean;
begin
  Result := false;
end;

function TAppT2_2027.Factor2: Byte; //20180503 Igor
begin
  Result := T2F2_2026;
end;

function TAppT2_2027.GetAdditionalInfo: string; // 20180712 Igor
var FRetNo: integer;
begin
  Result := '';
  FRetNo := GetCurrentRetNo;
  if FRetNo = 0 then Exit;
  Result := FetchElm(FRetNo, 'T2', 1); // Business Number
end;

function TAppT2_2027.GetAppDir: string; //20180503 Igor
begin
  Result := T2_2027declare.AppDir;
end;

//20180603
function TAppT2_2027.GetRightTabSheets: TRightTabSheets;
begin
  Result := [rtsReview, rtsPrevYear, rtsClientDocument, rtsAutoFill]; //20180611
  // rtsAutoFill
end;


function TAppT2_2027.GetAppName: string;
begin
  Result := T2_2027Declare.AppName;
end;

function TAppT2_2027.GetMenu: TMainMenu;
begin
  Result := T2Menu;
  MainFormT2.ShowCellNumbers1.Checked := ShowFieldIdSw;
end;

function TAppT2_2027.GetTaxationYear: string; // 20180712 Igor
var FRetNo: integer;
begin
  Result := '';
  FRetNo := GetCurrentRetNo;
  if FRetNo = 0 then Exit;
  Result := FetchElm(FRetNo, 'T2', 11);
end;

function TAppT2_2027.GetToolBar: TControl;//20170824 Igor
begin
  //20171031 Igor>>>
  MainFormT2.ZoomStr:=IntToStr(OptRec.FormZoom)+'%';
  case MainOptions.Skin of
    skSmallToolbar:
      Result := MainFormT2.CoolBar1;
    skLargeToolbar:
      Result := MainFormT2.CoolBar2;
    skRibbon:
      Result := MainFormT2.MainUIRibbon; //20190415 Igor
  else
    Result := MainFormT2.ToolBar;
  end;
  //20171031 Igor<<<
end;

function TAppT2_2027.GetValidLastYearDataFolder: Boolean; //20160302 Igor
var
  ErrorMessage: String;
begin
  Result := isValidLastYearDataFolder(true,ErrorMessage);
end;

function TAppT2_2027.GetValidLastYearPgmFolder: Boolean; //20160302 Igor
var
  ErrorMessage: String;
begin
  Result := isValidLastYearPgmFolder(true,ErrorMessage); //20160424 Igor
end;

function TAppT2_2027.AllowFormForBuildReport(const AFormName: String): Boolean; //20180424 Igor
begin
  {define forms that are visible in report builder}
  Result := false;
end;

function TAppT2_2027.MaskFormDataForBuildReport(const AFormName: String; //20180424 Igor
  AFieldNo: Integer; AFieldValue: String): String;
begin
  {mask field values}
  Result := AFieldValue;
end;

function TAppT2_2027.CheckAllowedBN(ARetNo: integer; ASilent: boolean = false): boolean; //20191015 Igor
var cBN, cYearEnd: string;
    I: integer;
begin
  //20191021 Igor >>>
  if not (LicenseLevel in [llLimited1Returns, llLimited2Returns, llLimited3Returns,
                           llLimited4Returns, llLimited5Returns, llLimited6Returns]) then Exit(true);
  //20191021 Igor <<<
  Result := false;
  cBN := FetchElm(ARetNo, 'T2', 1);
  cBN := Copy(cBN, 1, 9);
  cBN := Copy(cBN, Length(cBN) - 3, Length(cBN));
  cYearEnd := FetchElm(ARetNo, 'T2', 11);
  for I := 0 to AllowedBN.Count - 1 do
    if SameText(cBN, AllowedBN.BN[I]) and SameText(cYearEnd, AllowedBN.YearEnd[I]) then
    begin
      Result := true;
      break;
    end;
  if not Result and not ASilent then
    UserMsg('Your Business Number and Tax Year End are not allowed for use');
end;


function TAppT2_2027.CheckLastYearDataFolder(
  out AErrorMessage: String): Boolean;
begin
  Result := isValidLastYearDataFolder(false,AErrorMessage); //20160424 Igor
end;

function TAppT2_2027.CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; //20160516 Igor
begin
  Result := isValidLastYearPgmFolder(false,AErrorMessage); //20160424 Igor
end;

function TAppT2_2027.GetSplash: TCustomControl;
begin
  Result := MainFormT2.AboutPanel;
end;

function TAppT2_2027.GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; //20160302 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := AppName+Reverse(Contributor1)+Contributor2+Contributor3;
    2: Result := AppName+Reverse(Contributor1)+Contributor2+Contributor3ver2;
    3: Result := chr(103)+chr(69)+'e'+chr(123)+chr(88)+chr(83)+'f'+chr(98)+'m'+  //20161208 Igor
                 chr(126)+chr(109)+chr(53)+'h'+chr(118)+chr(108)+chr(57);
    4: Result := '%'+chr(113)+chr(68)+chr(106)+chr(77)+chr(115)+chr(81)+chr(84)+
                 '4'+chr(64)+chr(105)+chr(113)+chr(69)+chr(81)+''+chr(84)+chr(81); //20161215 Igor
  end;
end;

function TAppT2_2027.GetSQLLiteRFPassword(const Version: Integer): String; //20160415 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := Reverse(Contributor1)+AppName+Contributor2+Contributor3;
    2: Result := Reverse(Contributor1)+AppName+Contributor2+Contributor3ver2;
    3: Result := '0'+chr(80)+chr(65)+chr(105)+chr(119)+chr(37)+'O'+chr(106)+    //20161208 Igor
                 chr(67)+chr(77)+'j'+chr(86)+'7'+''+chr(103)+chr(52)+chr(74);
    4: Result := '?'+''+chr(82)+'M'+chr(103)+chr(75)+chr(84)+chr(68)+''+chr(88)+
                 '?'+chr(119)+chr(106)+chr(97)+''+'B'+chr(102)+chr(104)+chr(36); //20161215 Igor
  end;
end;

function TAppT2_2027.GetSubstituteLastYearForm(AFormName: String): String; //20160302 Igor
begin
  Result := SubstituteLastYearForm(AFormName); //20160424 Igor
end;

function TAppT2_2027.Licenses: PPgmLicenseData;
begin
  Result := @PgmLicenses;
end;

procedure TAppT2_2027.LoadBN; //20191015 Igor //20200617 Igor
var cLimitedBN: string;
begin
  if FileExists(TPath.Combine(GetExeDir, LimitedBN)) then
    cLimitedBN := TPath.Combine(GetExeDir, LimitedBN)
  else if FileExists(TPath.Combine(T2_2027Declare.AppDir, LimitedBN)) then
    cLimitedBN := TPath.Combine(T2_2027Declare.AppDir, LimitedBN)
  else
    Exit;
  AllowedBN.LoadFromFile(cLimitedBN);
end;

{
procedure TAppT2_2027.LoadBN; //20191015 Igor //20200617 Igor
var cLimitedBN: string;
begin
  if FileExists(TPath.Combine(GetExeDir, LimitedBN)) then
    cLimitedBN := TPath.Combine(GetExeDir, LimitedBN)
  else if FileExists(TPath.Combine(T2_2027Declare.AppDir, LimitedBN)) then
    cLimitedBN := TPath.Combine(T2_2027Declare.AppDir, LimitedBN)
  else
    Exit;
  AllowedBN.LoadFromFile(cLimitedBN);
end;
}

procedure TAppT2_2027.LoadOptionsFileToMem; //20160617 Igor
begin
  inherited;
  T2_2027TrimStr.LoadOptionsFileToMem;
end;

function MyHashString(const AKey: string): string;
var
  p: PPgmLicenseData;
  id: string;
  f1, f2: integer;
begin
  Result := '';
  if Length(AKey) <> 19 then
    exit; //valid key has exactly 19 chars
  id := LeftStr(AKey, 4); //T10x
  p := @pgmLicenses[0];
  while p.Level > llNone do
  begin
    if p.Id = id then
      break;
    inc(p);
  end;
  f1 := p.Factor;
  case AKey[1] of
    //20150607 T2F2_2015 to refer to 2015
    'T': f2 := T2F2_2026; //T2 key
    'S': f2 := S2F2_2026; //S2 key
  else
    exit;
  end;
  Result := MakeHashString(AKey, f1, f2);
end;

function TAppT2_2027.ValidateKey(AKey: string): boolean;
begin
  Result := inherited ValidateKey(AKey);
  if not Result then
    exit;
 //e2-2023
 //T204-5492-6834-1760

 If (LeftStr(AKey,19) = 'T204-5492-6834-1760')  //saimakhalil@hotmail.c //20250122
 or (LeftStr(AKey,19) = 'T206-1155-1864-1636')  //Clips Accounting //20240320
 or (LeftStr(AKey,19) = 'T206-2033-2644-1398')  //GSM ACCOUNTING LTD
 or (LeftStr(AKey,19) = 'T206-6454-6574-1976')  //AOD TAX SERVICES-aodtax@rogers.com  //20240315
 or (LeftStr(AKey,19) = 'T206-0802-0712-1229')  //bogdan wrong Email //20230129
 or (LeftStr(AKey,19) = 'T206-4128-4506-1602')  //JULIUS JAYEOBA -Julius japcinfo@gmail.com  //20240212
 or (LeftStr(AKey,19) = 'T204-3968-4364-1774')  // HAWKINS //20240124
 or (LeftStr(AKey,19) = 'T211-6207-6354-1527')  //SVETLANA MAIZEL  //2023 //20240117
 or (LeftStr(AKey,19) = 'T208-6127-5446-1982')  // taxes@aysoffice.ca rosa villar king //20230218
 //T2-2022
 or (LeftStr(AKey,19) = 'T204-7879-7004-1538')  //OTTON
 or (LeftStr(AKey,19) = 'T204-3725-3311-1096')  //notaboo  //Beb 19, 2021
 or (LeftStr(AKey,19) = 'T206-5025-4466-1490') //bushi replaced keys 20200528
 or (LeftStr(AKey,19) = 'T209-5922-5264-1952')  //ANTHONY QUERQUES //20200516
 or (LeftStr(AKey,19) = 'T206-8960-7965-2030')  //GILZENE'S ACCOUNTING SERVICES //20200514
 or (LeftStr(AKey,19) = 'T206-4042-3592-1400')   //RNK PROFESSIONAL   //20200514
 or (LeftStr(AKey,19) = 'T208-2751-2445-1666')  //Financial planners //20200409
 or (LeftStr(AKey,19) = 'T209-0659-0586-2084')  //Kathy Hamilton
 or (LeftStr(AKey,19) = 'T208-8246-7330-1762')  //PRANAV ANAND canceled replaced
 //2019
 or (LeftStr(AKey,19) = 'T206-1713-1523-1148')  //Cashshop  //20180818 He bought 3
 Or (LeftStr(AKey,19) = 'T206-0729-0648-1610')  //633771 NB LTD OP AS BARTER & ASSOCIATES  //20200209
 Or (LeftStr(AKey,19) = 'T201-1447-1286-0876')  //PETER ODURO keeps buyng without paying  //20170728
 Or (LeftStr(AKey,19) = 'T206-8081-7183-1512')  //Arib financial   //20180328
 //20180225
 Or (LeftStr(AKey,19) = 'T209-7964-7079-2278')  //DRB TAX SERVICE C/O DENIS R BLONSKY
 Or (LeftStr(AKey,19) = 'T209-7964-7079-2278')  //LOGAN'S ACCOUNTING & TAX SOLUTIONS C/O LOGARAJAH KUMARASAMY
 //---
 Or (LeftStr(AKey,19) = 'T206-3425-3044-1166')  //JULIUS OLU JAYEOBA CGA   //20170405
 Or (LeftStr(AKey,19) = 'T203-4110-3653-0812')  //Rosa Moniz
 Or (LeftStr(AKey,19) = 'T201-6221-5530-0642')  //anita aggarwalnedicine  //20160130
 or (LeftStr(AKey,19) = 'T201-7059-6275-1060')  //gerald ostry  //20170130
 or (LeftStr(AKey,19) = 'T201-2291-2037-0686')  //Hamid Khan  //20160712
 or (LeftStr(AKey,19) = 'T203-7431-6605-0989')  //20160710  karikani
 or (LeftStr(AKey,19) = 'T201-4726-4201-0686')  //hummel  //20160523
 or (LeftStr(AKey,19) = 'T203-7818-6949-1449')  //daniel kc wong  //20160130
 or (LeftStr(AKey,19) = 'T201-3658-3252-0862')  //joyce french  //20160130
 or (LeftStr(AKey,19) = 'T203-1531-1361-0736')  //jgs management services //20160130
 or (LeftStr(AKey,19) = 'T203-8527-7579-0922')  //alice l zhang  //20160122
 or (LeftStr(AKey,19) = 'T201-4991-4436-0994')  //Double-edge Support@Defs.com
 or (LeftStr(AKey,19) = 'T201-1832-1629-0818')  //ldk consulting
 or (LeftStr(AKey,19) = 'T203-2128-1891-0989')  //amd accounting and tax
 or (LeftStr(AKey,19) = 'T206-7011-6232-1015')  //dan foste
 or (LeftStr(AKey,19) = 'T203-5807-5162-0994')   //Kim Milligan Wrong upgrade on 10151003
 or (LeftStr(AKey,19) = 'T201-2013-1789-0762')  //ibrahim
 or (LeftStr(AKey,19) = 'T201-0838-0744-0825')  //billion luz
 or (LeftStr(AKey,19) = 'T201-4661-4143-9720')  //inderjite
 or (LeftStr(AKey,19) = 'T201-5128-4538-0909')  //joanne harde
 or (LeftStr(AKey,19) = 'T201-5924-5266-0930')  //Payless Income tax
 or (LeftStr(AKey,19) = 'T201-4071-3619-0762')  //mc donell?  //20150213

 {not needed //20230917
 //2014 to oct 31
 Or (LeftStr(AKey,19) = 'T201-6364-5657-1016')  //linda migli.. by mistake
 OR (LeftStr(AKey,19) = 'T201-5128-4558-0909')  //harte 2015 t2 by mistake
 OR (LeftStr(AKey,19) = 'T201-3445-3062-0686')  //edward galoszkie
 OR (LeftStr(AKey,19) = 'T206-2611-2321-0915')  //j hamilton 2015 key given wrongly
 OR (LeftStr(AKey,19) = 'T104-2397-2131-0970')  //devram vt29
 //2014
 OR (LeftStr(AKey,19) = 'T206-0997-0886-1623')  //DJ TUPLING
 OR (LeftStr(AKey,19) = 'T206-7780-6915-1519')  //ML TAX SERVICE
 OR (LeftStr(AKey,19) = 'T203-0767-0681-1014')  //TWISTED DARLENE
 OR (LeftStr(AKey,19) = 'T203-3869-3439-1244')  //PURI

 or (LeftStr(AKey,19) = 'T204-2004-1781-1020')  //paw entrprises-wrongly given
 or (LeftStr(AKey,19) = 'T201-1866-1659-1016')  //xhag ning..-wrongly given
 //2013
 or (LeftStr(AKey,19) = 'T203-6506-5783-1522')  //jgs management/stewart
 or (LeftStr(AKey,19) = 'T204-6359-5652-1650')  //trax accounting
 or (LeftStr(AKey,19) = 'T203-3905-3471-1250')  //assured bokkeeping
 or (LeftStr(AKey,19) = 'T204-9700-8622-1405')  //???
 or (LeftStr(AKey,19) = 'T201-9929-8825-1779')  //koubarakos
 or (LeftStr(AKey,19) = 'T201-5895-5840-1317')  //lewis
 //2012
 or (LeftStr(AKey,19) = 'T206-9549-8488-1677')  //3d accounting
 or (LeftStr(AKey,19) = 'T201-0143-0127-0465')  //steve doris
 or (LeftStr(AKey,19) = 'T201-3405-3026-0580')  //Moronder Singh
 or (LeftStr(AKey,19) = 'T201-7745-6885-1201')  //julia Leghorn
 or (LeftStr(AKey,19) = 'T201-8679-7715-1201')  //Mona Basset
 or (LeftStr(AKey,19) = 'T201-4939-4389-1132')  //lloyd's bell
 or (LeftStr(AKey,19) = 'T206-0968-0860-1259')  //ivan soave  //returned
 or (LeftStr(AKey,19) = 'T206-0968-0860-1259')  //ivan soave  //returned
 }
 then
  begin
    result := False;
    exit;
  end;

  Result := MidStr(AKey, 16, 4) = MyHashString(AKey); //20150812
  If UpperCase(LeftStr(AKey,2)) <> UpperCase(LeftStr(AppName,2)) then //20160222 Igor
    result:=False;  {T1 key goes with T1, etc}
end;

function TAppT2_2027.ValidateScanKey(AKey: string): boolean;
begin //20150812
  Result := (Length(AKey) = 19)
    and (LeftStr(AKey, 2) = 'S2');
  if not Result then
    exit;

  Result := MidStr(AKey, 16, 4) = MyHashString(AKey);
end;

function TAppT2_2027.GetAppRelease: string;
begin
  Result := T2_2027Declare.AppRelease;
end;

function TAppT2_2027.GetAppUpdateDate: string;
begin
  Result := T2_2027Declare.AppUpdateDate;
end;

function TAppT2_2027.GetAppYear: string;
begin
  Result := T2_2027Declare.AppYear;
end;

function TAppT2_2027.GetBNText: string; //20191015 Igor
var L: TStringList;
begin
  Result := '';
  if not FileExists(TPath.Combine(T2_2027Declare.AppDir, LimitedBN)) then Exit;
  L := TStringList.Create;
  try
    L.LoadFromFile(TPath.Combine(T2_2027Declare.AppDir, LimitedBN));
    Result := L.Text;
  finally
    L.Free;
  end;
end;

function TAppT2_2027.SaveReturn(RetNo: Integer; DataDir, FlName: string; //20200914 Igor //20200916 Igor
  OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable: boolean;
  AClouds: TArrayOfInteger): Integer;
var FSaveApp: TApp;
begin
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppT2;
    Result := T2_2027Common2.SaveReturn(RetNo, DataDir, FlName, OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable, AClouds);
  finally
    CurrentApp := FSaveApp;
  end;
end;

procedure TAppT2_2027.SaveSingleOptions(const AOptionName, AValue: String;
  AOptionsFileName: String); //20160617 Igor
begin
  inherited;
  T2_2027TrimStr.SaveSingleOption(AOptionName, AValue, AOptionsFileName);
end;

procedure TAppT2_2027.SelectFeatures;
begin
  MainFormT2.SelectFeatures;
end;

procedure TAppT2_2027.SetBNText(const Value: string); //20191015 Igor
var L: TStringList;
    FRetNo: integer;
begin
  L := TStringList.Create;
  try
    L.Text := Value;
    L.SaveToFile(TPath.Combine(T2_2027Declare.AppDir, LimitedBN));
  finally
    L.Free;
  end;
  LoadBN;
  FRetNo := GetCurrentRetNo;
  if FRetNo > 0 then
  begin
    CalcAll(FRetNo);
    CountDiagnostics(FRetNo);
    MainForm.RefreshAuditPanel(FRetNo);
  end;
end;

procedure TAppT2_2027.SetZoomCaption(AZoom: Integer);
begin
  MainFormT2.ZoomStr := IntToStr(AZoom)+'%'; //20180118 Igor
end;

function TAppT2_2027.ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
  var AErr: String; AOverride: Boolean): Boolean; //20160617 Igor
begin
  Result := T2_2027TrimStr.ImportOneReturn(ADS, ASrcDir, ADstDir, AErr, AOverride); //20160617 igor
end;

procedure TAppT2_2027.InitFList;
begin
  inherited;
  if not assigned(FList) then
  begin
    T2_2027Declare.FList := TFListT2.Create(AppT2, FormsLimit, FieldsLimit, FormsDBLite,FormsTableLite);//20150119 Igor
    Self.ConvertDataBase;
    T2_2027TrimStr.InitFormsTable;
    InitColorTable;
    InitLists;
    InitSwitches;
    InitBmps;
    InitT1Constants;  //20200810
    // 20180530 Igor >>>
    If OptRec.Dir_AutoFill.isEmpty then
      OptRec.Dir_AutoFill := TPath.Combine(AppDir, 'AFR');
    // 20180530 Igor >>>
  end;
end;

procedure TAppT2_2027.InitFormsTable;
begin
  inherited;
  T2_2027TrimStr.InitFormsTable;
end;

function TAppT2_2027.InitNewReturn(ForLoad: boolean): integer;
begin
  Result := T2_2027Common.CreateNewReturn; // TRetT2_2027.Create(self);
end;

procedure TAppT2_2027.InitStorage; //20180503 Igor
var
  EtalonDir, S: String;
  procedure CopyIfNeed(AFileName: String);
  begin
    if not TFile.Exists(TPath.Combine(EtalonDir, AFileName)) then Exit;
    if not TFile.Exists(TPath.Combine(AppDir, AFileName)) or
       (TFile.GetLastWriteTime(TPath.Combine(EtalonDir, AFileName)) > TFile.GetLastWriteTime(TPath.Combine(AppDir, AFileName))) then
      TFile.Copy(TPath.Combine(EtalonDir, AFileName), TPath.Combine(AppDir, AFileName), True);
  end;
begin
  EtalonDir := TPath.Combine(ExtractFilePath(Application.ExeName), AppId);
  if not SamePath(EtalonDir, AppDir) then
  begin
    ForceDirectories(AppDir);
    CopyIfNeed(FormsDBLite);
    CopyIfNeed(FormsFeesDBLite);
    CopyIfNeed(DictDBLite);
    CopyIfNeed(ClientsDBLite);
    for S in TDirectory.GetFiles(EtalonDir, '*.xml') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.rtf') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.qry') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.d') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.dfm') do
      CopyIfNeed(ExtractFileName(S));
    //20190115 Igor >>>
    for S in TDirectory.GetFiles(EtalonDir, '*.htm') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.html') do
      CopyIfNeed(ExtractFileName(S));
    //20190115 Igor <<<
  end;
end;

function TAppT2_2027.IsBNButtonVisible: boolean; //20191015 Igor //20191021 Igor
begin
  Result := LicenseLevel in [llLimited1Returns, llLimited2Returns, llLimited3Returns,
                             llLimited4Returns, llLimited5Returns, llLimited6Returns];
end;


procedure TAppT2_2027.OpenClientBook; //20200916 Igor
var FSaveApp: TApp;
begin
  inherited;
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppT2;
    MainformT2.OpenReturnLblClick(nil);
  finally
    CurrentApp := FSaveApp;
  end;
end;

function TAppT2_2027.OpenForeignForm(const ADir, AFile, AForm: String;
  const AElement: Integer): TFormData;
var
  R, I: Integer;
  F: TvtForm;
begin
  R := -1;
  for I := 0 to RetList.Count - 1 do
    if Assigned(RetList[I]) and
       not RetList[I].Destroying and
       (RetList[I].MyApp = Self) and
       SameText(RetList[I].SourceDataDir, ADir) and
       SameText(RetList[I].SourceFlName, AFile) then
    begin
      R := RetList[I].RetNo;
      break;
    end;
  if R < 0 then
    R := T2_2027Common2.OpenReturn(ADir, AFile, False, False);
  if R <=0 then
    exit(nil);
  F := OpenForm(R, AForm, AElement);
  if Assigned(F) then
    Result := RetList[R].Form[AForm]
  else
    Result := nil;
end;

function TAppT2_2027.OpenReturn(DirName, FlName: string;
  fShow: boolean; AIsAppendix: Boolean = False): integer;
begin
  Result := T2_2027Common2.OpenReturn(DirName, FlName, fShow, AIsAppendix);
end;

procedure TAppT2_2027.ReloadMainMenu; //20190307 Igor
begin
  inherited;
  MainFormT2.ReloadMainMenu;
end;

//20160613
function TAppT2_2027.GetDefaultOptions: TStringList;
begin
  result := T2_2027TrimStr.GetDefaultOptions; //20160617 Igor
end;

function TAppT2_2027.GetDefaultOptionsValue(AOptionName: String): String;
begin
  result := T2_2027TrimStr.GetDefaultOptionsValue(AOptionName); //20160617 Igor
end;

function TAppT2_2027.GetOptionsCaption(AOptionName: String): String;
begin
  result := T2_2027TrimStr.GetOptionsCaption(AOptionName); //20160617 Igor
end;


function TAppT2_2027.GetDfmFileName(const FormName: string): string;
begin
  Result := T2_2027ChildWinNew.GetDFMFileName(FormName);
end;

function TAppT2_2027.GetDfmFileNameLY(const FormName: string): string;
begin
  Result := T2_2027ChildWinNew.GetLastYearDFMFileName(FormName);
end;

function TAppT2_2027.GetEfilerNumber: string; // 20180712 Igor
var OnlineNo, Password, Url, NetFileDir: string;
begin
  GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  Result := OnlineNo;
end;

//20160631
function TAppT2_2027.GetHelpFile: String;
begin
 Result := 'http://www.visualtax.com/VtHELP/T2Help/Website/index.html'; //20161220 Igor  //20161224 CON
 // Result := 'http://www.visualtax.com/Vt2017HELP/T2Help/Website/T2Help.html'; //20161220 Igor

end;

function TAppT2_2027.GetHelpUpdFile: String;
begin
 Result:='http://www.visualtax.com/Vt2018HELP/T2Help/T2UpdHlp/Website/What_s_New.html'; //20161220 Igor  //20161224 CON//20171205 Igor
// Result := 'http://visualtax.com/Vt2017HELP/T2Help/T2UPDHlp/WebSite/T2UpdHlp.html'; //Igor //20161220 Igor  //20161224 CON
  //Result := 'http://visualtax.com/Vt2017HELP/T2Help/T2UPD/T2UpdHlp.html'; //20160801 Igor //20161220 Igor
end;


function TAppT2_2027.GetInitLastYear: Boolean; //20160424 Igor
begin
  if Assigned(FLastYearList) then
    Result := True
  else
  Begin
    InitLastYearFormsTable;
    result := Assigned(FLastYearList);
  End;
end;

function TAppT2_2027.GetLastYearDataFolder: String; //20160302 Igor
begin
  if Dir_LastYr <> '' then //20160608 Igor
  begin
    if Dir_LastYr[length(Dir_LastYr)] = '\' then //20160424 Igor
      Delete(Dir_LastYr,length(Dir_LastYr)-1,1);
    Result := Dir_LastYr;
  end
  else // if not set Dir_LastYr - search lastYear return in Cur_Dir
    Result := Dir_Cur;
end;

{
function TAppT2_2027.GetLastYearDataFolder: String; //20160302 Igor
begin
  if Dir_LastYr[length(Dir_LastYr)] = '\' then //20160424 Igor
    Delete(Dir_LastYr,length(Dir_LastYr)-1,1);
  Result := Dir_LastYr;
end;
}
function TAppT2_2027.GetLastYearFormNo(AFormName: String): Integer; //20160302 Igor
begin
  Result := T2_2027TrimStr.GetLastYearFormNo(AFormName); //20160424 Igor
end;

function TAppT2_2027.GetLimitedVersionDir: String; //20160718 Igor
begin
  Result := T2_2027Declare.LimitedVersionDir;
end;

function TAppT2_2027.GetLimitReturns: Integer;//20170901 Igor
begin
  case self.LicenseLevel of
    llLimited: Result := LimitedVersionReturns;
    llLimEfile: result := LimitedWithEfileVersionReturns;
  else
    Result := inherited GetLimitReturns;
  end;
end;

function TAppT2_2027.HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
begin
  Result := T2_2027TrimStr.HaveOptions(AOptionsName);
end;

procedure TAppT2_2027.HelpOnClientLetter;
begin
  ShowHelp(AppT2.ModuleHelpFile, 'client_letter', True); //20161220 Igor
end;

{ TRetListT2 }

function TRetListT2.GetRet(RetNo: integer): TRetT2_2027;
begin
  (* problem with AppId switching :-(
  *)
  TObject(Result) := TypedReturn(RetNo, TRetT2_2027);
end;

{ TRetT2_2027 }

constructor TRetT2_2027.Create(TheApp: TApp);

  procedure InitRetData;
  var
    i, j: integer;
  begin
    (* used only by Open/New return!
    *)
    Changed := False; {for new returns only}
    SourceDataDir := OptRec.Dir_cur;
    SourceFlName := '';
    Balance := 0;
    Province := OptRec.Nfl_Prov;
    Bankrupt := False;
    Notes := '';
    PrpStatus := '00';
    CouplingSw := False;
//20170515 Igor >>>
    PreselForms := TSingleStringList.Create;
    OpenedForms := TSingleStringList.Create;
//    StringLists.AddSingle(@PreselForms, TSingleStringList);
//    StringLists.AddSingle(@OpenedForms, TSingleStringList);
//20170515 Igor <<<
    ///StringLists.AddSingle(@AuditList, TSingleStringList);
    //Locked        := False;

    ErrorCount := 0;
    MandatoryErrorCount := 0;
    SeriousErrorCount := 0;
    EFileErrorCount := 0;
    {create strings for forms}
  end;

begin
  SetLength(Ln, LnHighBound + 1); //made it dynamic //20190704 Igor
  SetLength(Frm, FormsLimit + 1);
  SetLength(FrmHasData, FormsLimit + 1);
  inherited Create(TheApp); //add to RetList
  //more?
  FRetColor := GetNextAvailColor;
  InitRetData;
end;

destructor TRetT2_2027.Destroy;
begin
  //FreeAndNil(AuditEfileList); - global!!!
//these are automatically destroyed
  //FreeAndNil(auditlist);
  //FreeAndNil(PreselForms);
  //FreeAndNil(OpenedForms);
  //FreeAndNil(TS60Ln240Memo);
  //FreeAndNil(TS60Ln242Memo);
  //FreeAndNil(TS60Ln244Memo);
  //FreeAndNil(TS60Ln250Memo);
  //FreeAndNil(TS60Ln252Memo);
  //FreeAndNil(GifiNotesMemo);
//20170515 Igor >>>
  FreeAndNil(PreselForms);
  FreeAndNil(OpenedForms);
//20170515 Igor <<<
  inherited Destroy;
end;

procedure TRetT2_2027.SetLastYearFile(const AValue: String);
begin
  T2_2027TrimStr.SetLastYearFile(Self.RetNo, AValue);
end;

procedure TRetT2_2027.SetLocked(const Value: boolean);
begin
  inherited;
  if Value then
    StoreElm(RetNo, GetFormNo('STATUS'), 26, 'Y')
  else
    StoreElm(RetNo, GetFormNo('STATUS'), 26, 'N');
end;

function TRetT2_2027.GetLocked: Boolean;
begin
  Result := FLocked;
end;

function TRetT2_2027.GetOldGifiDataConverted: Boolean; //20160721 Igor
begin
  Result := FetchElm(RetNo, GetFormNo('STATUS'), c_OldGifiDataConvertedElm) = 'Y';
end;

procedure TRetT2_2027.SetOldGifiDataConverted(const Value: boolean); //20160721 Igor
begin
  if Value then
    StoreElm(RetNo, GetFormNo('STATUS'), c_OldGifiDataConvertedElm, 'Y')
  else
    StoreElm(RetNo, GetFormNo('STATUS'), c_OldGifiDataConvertedElm, 'N');
end;

function TRetT2_2027.GetCloudFileName: String; //20190312 Igor
begin
  Result := GetDefaultFileName; //20201015 Igor
end;

function TRetT2_2027.GetDefaultFileName: String;
begin
  Result := GenerateReturnFileName(RetNo, OptRec.FileNameFormat); //20200914 Igor //20200921 Igor
end;

function TRetT2_2027.GetDfmFileName(const FormName: string): string;
begin
  Result := T2_2027ChildWinNew.GetDFMFileName(FormName);
end;

procedure TRetT2_2027.GetFrmTree(TreeView: TTreeView; fUsedForms: boolean);
var
  FormsTreeView1: TTreeView absolute TreeView;
  TempList: TStringList;
  i: integer;
begin
  (* this could become a generic function of TRetData,
      provided a unified FList.
    from main.RefreshFormsPanel
  *)
  FormsTreeView1.items.clear;
  if fUsedForms then
  begin
    TempList := TStringList.Create;
    TempList.Sorted := True;
    //TempList.Add('USED FORMS'); screws up!

    for i := 0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if (Frec.FormShow) and (Ret[RetNo].FrmHasData[Frec.FormNo]) then
        TempList.Add(' ' + AllTrim(Frec.FormAbrev));
    end;
    TempList.Sorted := False;
    TempList.Insert(0, 'USED FORMS');
    TempList.SaveToFile(AppDir + '\' + 'Temp');
    FormsTreeView1.LoadFromFile(AppDir + '\' + 'Temp');
    FormsTreeView1.FullExpand;
    TempList.Free;
  end
  else
  begin
    FormsTreeview1.LoadFromFile(AppDir + '\Treeview2.D');
  end;
  FormsTreeView1.TopItem := FormsTreeView1.Items[0];
end;

function TRetT2_2027.GetFrmTreeFNo(SourceNode: TTreeNode;
  fUsedForms: boolean): integer;
var
  FormName: string;
begin
  (* Forms TreeView OnClick handler
    //init FrmsTree[] in InitLists
  *)
  if fUsedForms then
    FormName := GetFName(SourceNode.Text)
  else
    FormName := AllTrim(FrmTreeForms[SourceNode.AbsoluteIndex]);
  if FormName <> '' then
    Result := GetFormNo(FormName)
  else
    Result := 0;
end;

procedure TRetT2_2027.Calc(RNo: integer; const FName: string; FNo: integer);
begin
  (* When called from within WITH with a different RetNo,
    call the virtual method of THAT return.
  *)
  if RNo = 0 then
    exit;
  if not AppT2.CheckAllowedBN(RNo, true) then Exit; //20191015 Igor
  if RNo = RetNo then
    T2_2027.Calc(RNo, FName)
  else
    RetList[RNo].Calc(RNo, FName);
end;

procedure TRetT2_2027.CalcAll;
begin
  if not AppT2.CheckAllowedBN(RetNo, true) then Exit; //20191015 Igor
  CalcFed(RetNo);
  CalcOnt(RetNo);
  CalcAlb(RetNo);
end;

procedure TRetT2_2027.ReCalcEveryThing;
begin
  RecalcAllForms(RetNo);
end;

function TRetT2_2027.GetReturnCaption: string;
begin
  Result := T2_2027ChildWinNew.GetReturnCaption(RetNo);
end;

function TRetT2_2027.NewChild: TMyChild;
begin
  Result := TMyChildT2_2027.CreateNew(Application, RetNo);
end;

function TRetT2_2027.RefreshAuditPanel(ReturnsHeaderPanel: TPanel; ErrorView: TTreeView; AuditMode: eAuditMode): string;
begin
  AuditRecsToTreeView(ErrorView, 'MEWFRTSDNO');
end;

function TRetT2_2027.DoSave: boolean;
begin
  (* single return saving part of SaveAll - SaveAllReturns
  *)
  Result := MainFormT2.DoSaveAllReturns(RetNo);
end;

procedure TRetT2_2027.DoSaveAs;
begin
  (* FileSaveAsItemClick
  *)
  MainFormT2.DoFileSaveAs(RetNo);
end;

function TRetT2_2027.FormClass: TvtFormClass; //20161211 Igor
begin
  Result := TFormT2_2027;
end;

function TRetT2_2027.BeforeOpenForm(var FormName: string; var FormNo: integer): string;
begin
  Result := T2_2027ChildWinNew.BeforeOpenForm(RetNo, FormName, FormNo);
end;

function TAppT2_2027.ConvertToLastYearName(AFileName: String): String;
var
  Y: Integer;
Begin
  if tryStrToInt(RightStr(AFileName,2),Y) then
    result := LeftStr(AFileName,length(AFileName)-2)+FormatFloat('00',Y-1)
  else
    result := AFileName;
end;

procedure TRetT2_2027.CountDiagnostics;
begin
  T2_2027cnterr.CountDiagnostics(RetNo);
end;

function TRetT2_2027.Close(fRemove: boolean): boolean;
begin
  if RetList[RetNo].LastYearRetNo <> 0 then //20160305 Igor
    CloseReturn(RetList[RetNo].LastYearRetNo, fRemove); //20160305 Igor
  Result := CloseReturn(RetNo, fRemove);
end;

function TRetT2_2027.GetReturnName: string;
begin
  Result := T2_2027Common.GetRetName(RetNo);
end;

function TRetT2_2027.GetTDDFileName: String; // 20180530 Igor
begin
  Result := MkTddFileNameAutofill(GetCurrentRetNo);
end;

function TRetT2_2027.IsLetterForm(AFormName: String): Boolean; //20161211 Igor
begin
  Result := T2_2027TrimStr.IsFormAClientLetter(AFormName);
end;

procedure TRetT2_2027.StartPrintForm(FormName: string; WhichPage: integer);
begin
  MainFormT2.StartPrintForm(RetNo, FormName, WhichPage);
end;

function TRetT2_2027.AddPageInstance(NonInstFormName,
  FormInst: string): integer;
begin
  Result := T2_2027Common2.AddPageInstance(RetNo, NonInstFormName, FormInst);
end;

procedure TRetT2_2027.SetCalcStatus(const Value: boolean);
begin
  inherited;
  if value then
    exit;
  //clear all indicators
  FedCalcStatus := False;
  OntCalcStatus := False;
  AlbCalcStatus := False;
end;

procedure TRetT2_2027.CloneForm(FromFormName: string; ToRetNo: integer;
  ToFormName: string; fAll: boolean);
begin
  inherited;
  Ret[ToRetNo].Calc(ToRetNo, ToFormName);
end;

procedure TRetT2_2027.CloneReturn(ToRetNo: integer);
var
  ToRet: TRetT2_2027;
begin
  inherited;
  {copy other data}
  ToRet := Ret[ToRetNo];
  ToRet.Bankrupt := Bankrupt;
end;


function GetCorpName(RetNo: Integer): string;
{Returns Corp Name from T2}
begin
  Result := AllTrim(FetchElm(RetNo, 'T2', 3) +
    ' ' + FetchElm(RetNo, 'T2', 65));
end;

function TRetT2_2027.GetFirstName: string;
begin
  Result := AllTrim(FetchElm(RetNo, 'T2', 3)); //+ ' '+FetchElm (RetNo, 'T2', 65));    //corp name
end;

function TRetT2_2027.GetLastName: string;
begin
  Result := AllTrim(FetchElm(RetNo, 'T2', 65));    //additianal corp name
end;

function TRetT2_2027.GetLastYearFile: String; //20160701 Igor
begin
  Result := T2_2027TrimStr.GetLastYearFile(Self.RetNo);
end;

function TRetT2_2027.GetInterpetedRichEdit(LetterName: string;   //20160819 Igor
  ARichEdit: TRichEdit): boolean;
begin
  Result := T2_2027TrimStr.GetInterpetedRichEdit(Self.RetNo, LetterName, ARichEdit);
end;

{ TFListT2 }

function TFListT2.LoadFromTable(Table1: TDataSet): TFRec;
var
  FRec: TFRec absolute Result;
  function GetBooleanValue(AField: TField):Boolean; //20160424 Igor
  begin
    if AField.DataType = ftBoolean then
      Result := AField.AsBoolean
    else
      Result := Boolean(AField.AsInteger);
  end;
begin
  FRec := TFRec.Create;
  FRec.FormNo := Table1.FieldByName('FormNo').AsInteger;
  FRec.FormName := UpperCase(Trim(Table1.FieldByName('FormName').AsString));
  FRec.FormInst := Trim(Table1.FieldByName('FormInst').AsString);
  FRec.FormMxInst := Table1.FieldByName('FormMxInst').AsString;
  FRec.FormDescr := Table1.FieldByName('FormDescr').AsString;
  FRec.FormMxPg := Table1.FieldByName('FormMxPg').AsInteger;
  FRec.FormRlNm := Table1.FieldByName('FormRlNm').AsString;
  FRec.FormAbrev := Table1.FieldByName('FormAbrev').AsString;
  FRec.PDFFile := Table1.FieldByName('PdfFile').AsString;
  FRec.FormType := Table1.FieldByName('FormType').AsString;
  FRec.FormShow := GetBooleanValue(Table1.FieldByName('FormShow')); //20160424 Igor
  Frec.FormFields := Table1.FieldByName('FormFields').AsInteger;
  //If Frec.FormFields = 0 then Frec.FormFields := FieldsLimit;
  Frec.IsSlip := GetBooleanValue(Table1.FieldByName('IsSlip')); //20160424 Igor
  Frec.Preload := GetBooleanValue(Table1.FieldByName('Preload')); //20160424 Igor
  Frec.DataIndic := Table1.FieldByName('DataIndic').AsString;
  Frec.WhiteBoxes := GetBooleanValue(Table1.FieldByName('WhiteBoxes')); //20160424 Igor
  Frec.ShowFlag := GetBooleanValue(Table1.FieldByName('ShowFlag')); //20160424 Igor
  Frec.ShowHdr := GetBooleanValue(Table1.FieldByName('ShowHdr')); //20160424 Igor
  Frec.PrnSeq := Table1.FieldByName('PrnSeq').AsString;
  Frec.Fee := Table1.FieldByName('Fee').AsString;
  Frec.FeeAddItem := Table1.FieldByName('FeeAddItem').AsString;
  Frec.CursorPos := Table1.FieldByName('CursorPos').AsInteger;
  Frec.FormHeight := Table1.FieldByName('FormHeight').AsInteger;
  Frec.LandScape := StringToBoolean(Table1.FieldByName('LandScape').AsString);
  Frec.RSINAME := Table1.FieldByName('RsiName').AsString;
  Frec.MultiPage := StringToBoolean(Table1.FieldByName('MultiPage').AsString);
  //If FRec.FormAbrev   = '' then FRec.FormAbrev := FRec.FormName;
end;

{ TRetT2_LastYear }

constructor TRetT2_LastYear.Create(TheApp: TApp);
begin
//  inherited; //20160704 Igor
// for T2 all return loaded with T2_2027 settings
//    FList := FLastYearList; //20160710 Igor
  inherited Create(TheApp);
//    FIsLastYearReturn := True; //20160710 Igor
end;

{ TBNList }

function TBNList.GetBN(AIndex: integer): string; //20191015 Igor
begin
  Result := Copy(Strings[AIndex], 1, Pos('=', Strings[AIndex]) - 1);
end;

function TBNList.GetEncryptedText: string; //20191015 Igor
var
  L: TStringList;
  S: string;
  I: integer;
begin
  L := TStringList.Create;
  try
    for I := 0 to Count - 1 do
      begin
        S := uEncrypt.Encrypt(Strings[I], BNListKey); //20191021 Igor
        L.Add(S);
      end;
    Result := L.Text;
  finally
    L.Free;
  end;
end;

function TBNList.GetYearEnd(AIndex: integer): string; //20191015 Igor
begin
  Result := Copy(Strings[AIndex], Pos('=', Strings[AIndex]) + 1, Length(Strings[AIndex]));
end;

procedure TBNList.LoadFromFile(const FileName: string); //20191015 Igor
var
  L: TStringList;
  S: string;
  I: integer;
begin
  Clear;
  L := TStringList.Create;
  try
    L.LoadFromFile(NormalizeFileName(FileName));
    for I := 0 to L.Count - 1 do
      begin
        try
          S := uEncrypt.Decrypt(L.Strings[i], BNListKey); //20191021 Igor
        except
          S := '';
        end;
        if not S.IsEmpty then
          Add(S);
      end;
  finally
    L.Free;
  end;
end;

function TBNList.NormalizeFileName(AFileName: string): string; //20191015 Igor
begin
  Result := AFileName;
  if Pos(':', Result) < 2 then
    Result := ExtractFilePath(ParamStr(0)) + '\' + Result;
end;

procedure TBNList.SaveToFile(const FileName: string); //20191015 Igor
var
  L: TStringList;
  S: string;
  I: integer;
begin
  L := TStringList.Create;
  try
    for I := 0 to Count - 1 do
      begin
        S := uEncrypt.Encrypt(Strings[I], BNListKey); //20191021 Igor
        L.Add(S);
      end;
    L.SaveToFile(NormalizeFileName(FileName));
  finally
    L.Free;
  end;
end;

procedure TBNList.SetEncryptedText(Value: string); //20191015 Igor
var
  L: TStringList;
  S: string;
  I: integer;
begin
  L := TStringList.Create;
  try
    L.Text := Value;
    for I := 0 to L.Count - 1 do
      begin
        try
          S := uEncrypt.Decrypt(L.Strings[i], BNListKey); //20191021 Igor
        except
          S := '';
        end;
        if not S.IsEmpty then
          Add(S);
      end;
  finally
    L.Free;
  end;
end;


initialization

{$IFDEF isbpl}
   Classes.RegisterClass(TAppT2_2027);   // 20151118 Igor
{$ELSE}
//   AppT2 := TAppT2_2027.Create(AppList);//20170927 Igor
{$ENDIF}

end.

