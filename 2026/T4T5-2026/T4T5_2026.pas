unit T4T5_2026;

interface

uses Classes,Forms,Controls,Windows,ComCtrls,Menus,ExtCtrls,vtMulti,
  DB,vtForm,vtChild,vtMain,T4T5_2026Declare,
  Dialogs, //20171031 Igor
  IOUtils, //20180503 Igor
  rxRichEd; //20160819 Igor (Must be last)

const //update every year
//  LimitedVersionDir = 'C:\VTDATA14'; //?  //20150623 //20160718 Igor Move to Declare
//license keys
//2013 factors (inc every year)
  //SLF2012 = 16;
  T4T5F2025 = 61; //20280827 Alex

   PgmLicenses: array[0..5] of RPgmLicenseData = (//20171031 Igor  //20231211 Igor
  //T$T%  //20150623
  //20280827 Alex >>>
    (Name: 'T4T5 Demo';        Id:'T400'; Factor: 55; Level: llDemo),   //20160223 Igor //20240905 Igor
    (Name: 'T4T5 Standard';    Id:'T401'; Factor: 56; Level: llStd),   //20160223 Igor //20240905 Igor
    (Name: 'T4T5 Power';       Id:'T402'; Factor: 57; Level: llPower),   //20160223 Igor //20240905 Igor
    //dummy for invalid license
    (Name: 'T4T5 Limited Forms'; Id:'T403'; Factor: 58; Level: llLimitedForms), //20171012 Igor //20171031 Igor //20240905 Igor
    (Name: 'T4T5 Enterprise';    Id:'T404'; Factor: 59; Level: llEnterprise),   //20231211 Igor //20240905 Igor
    (Name: 'Unlicensed'; Id:''; Factor:0; Level:llNone; Caps:[])
   //20280827 Alex <<<
  );
  {
  //PgmLicenses: array[0..4] of RPgmLicenseData = (//20171031 Igor
  //T$T%  //20150623
  //20170801 Igor>>>
    (Name:'T4T5 Demo';        Id:'T400'; Factor:52; Level:llDemo),   //20160223 Igor
    (Name:'T4T5 Standard';    Id:'T401'; Factor:53; Level:llStd),   //20160223 Igor
    (Name:'T4T5 Power';       Id:'T402'; Factor:54; Level:llPower),   //20160223 Igor
  //20170801 Igor<<<
  //dummy for invalid license
    (Name:'T4T5 Limited Forms'; Id:'T403'; Factor:55; Level:llLimitedForms), //20171012 Igor //20171031 Igor
    (Name:'Unlicensed'; Id:''; Factor:0; Level:llNone; Caps:[])
  );
  }

{--------------- Data storage definition---------}

type
  TFListT4T5 = class(TFList)
  protected
    function LoadFromTable(Table1: TDataSet): TFRec; override;//20150917 Igor
  end;

type
  TRetT4T5_2026 = class(TRetData)
  public
   DaysInYear  : Integer;
   CouplingSw  : Boolean;
  { from ClienTtable}
  public //methods, override
    constructor Create(TheApp: TApp); override;
    destructor Destroy; override;
    Function  AddPageInstance(NonInstFormName, FormInst: string): integer; override;
    Procedure CloneForm(FromFormName: string;ToRetNo: integer;ToFormName:String; fAll: boolean); override;
    Procedure CloneReturn(ToRetNo: integer); override;
    //function InitFormData(FRec: TFRec): boolean; override;
    function  Close(fRemove: boolean): boolean; override;
    function  NewChild: TMyChild; override;
    function  BeforeOpenForm(var FormName: string; var FormNo: integer): string; override;
    function  GetReturnCaption: string; override;
    function  GetReturnName: string; override; //for printing
    function  DoSave: boolean; override; //part of SaveAllReturns
    procedure DoSaveAs; override; //using SaveAs dialog
    function GetDefaultFileName: String; override; //20160305 Igor
    function GetFirstName: string; override;//20160629 Igor
    function GetLastName: string; override;//20160629 Igor
    function GetLastYearFile: String; override; //20160701 Igor
    procedure SetLastYearFile(const AValue: String); override; //20160701 Igor
  public //forms
    function  GetDfmFileName(const FName: string): string; override;
    procedure GetFrmTree(TreeView: TTreeView; fUsedForms: boolean = False); override;
    function  GetFrmTreeFNo(SourceNode: TTreeNode; fUsedForms: boolean): integer; override;
    function FormClass: TvtFormClass; override; //20170612 Igor
    function IsLetterForm(AFormName: String): Boolean; override; //20170612 Igor
    function GenerateDefaultFileNameForExport: String; override; //20170612 Igor
  public //calculations
    procedure Calc(RNo: integer; const FName: string; FNo: integer = -1); override;
    procedure CalcAll; override;
    procedure CountDiagnostics; override;
  public //letters
    function GetInterpetedRichEdit(LetterName: string; ARichEdit: TRichEdit): boolean; override; //20160819 Igor
  public //visual feedback
    function RefreshAuditPanel(ReturnsHeaderPanel: TPanel; ErrorView: TTreeView; AuditMode: eAuditMode): string; override;
    procedure StartPrintForm(FormName:String;WhichPage:integer); override;
  end;

  TRetListT4T5_2026 = class(TRetList)
  private
    function GetRetT4T5(RetNo: integer): TRetT4T5_2026;
  public
    property RetT4T5[RetNo: integer]: TRetT4T5_2026 read GetRetT4T5; default;
  end;

  TAppT4T5_2026 = class(TApp2018)
  public
  //20170216 Igor >>>
    //Dir_Deflt    : String; //20170310 Igor
    Dir_LastYr   : String;
    Dir_Train    : String;
    Dir_Sample    : String;

    Prp_AName    : String;
    Prp_TName    : String;
    Prp_TArea    : String;
    Prp_TPhone   : String;
    Prp_XmitNo   : String;
    Prp_XmitCd   : String;

    Prp_Kstrk    :Real;
    Prp_TaxCen   :String;

    Nfl_Prov     : String; {New File defqaults}
    Nfl_City     : String;
    Nfl_Disced   : String;
    Nfl_Efile    : Boolean;

    Ef_PrepNo   : String;
    Ef_TransNo  : String;
    Ef_PsWord   : String;
    Ef_ProdNo   : String;
    Ef_TestNo   : String;
    Ef_DataDir  : String;
    Ef_EncDir   : String;
    Ef_DialNo   : String;
    Ef_NUI      : String;
    Ef_NuiPass  : String;
    Ef_Port     : Integer;
    Ef_Baud     : Integer;
    Ef_Protocl  : String;
    Ef_Centre   : String;
    Ef_PrepId   : String;
    Ef_PrnPort  : Integer;

    Prn_Shade   : Boolean;
    Prn_Head    : Boolean;
    Prn_NameH   : Boolean;
    Prn_SinH    : Boolean;
    Prn_DateH   : Boolean;
    Prn_Disclm  : String;
    Prn_Logo    : Boolean;
    Prn_logoln  : integer;

    Prn_T4JX  : Real;
    Prn_T4JY  : Real;
    Prn_T4SJX   : Real; {summary}
    Prn_T4SJY   : Real;

    Prn_T4AJX  : Real;
    Prn_T4AJY  : Real;
    Prn_T4ASJX   : Real; {summary}
    Prn_T4ASJY   : Real;

    Prn_T5JX  : Real;
    Prn_T5JY  : Real;
    Prn_T5SJX   : Real; {summary}
    Prn_T5SJY   : Real;

    Opr_Recalc  : Boolean;
    Opr_Close   : Boolean;
    Opr_FPres   : Integer;
    Opr_CopPrv  : String;
    Opr_ValT4   : String;
    Opr_ValNet  : String;
    Opr_CppTol  : Real;
    Opr_EITol   : Real;
    Opr_ShdChr  : Integer;
    Opr_T4SER   : LongInt;
    Opr_T4ASER  : LongInt;
    Opr_EIExmt  : Real;
    Opr_T5Auto  : String;
    Opr_CPPRat  : Real;
    Opr_AutoPe  : String;

    Dir_PgmLastYr,
    Dir_PrvLYr,
    BackUpDir,
    LastBackupDir,
    BackupFrequency : String;

    Reviewer_Name,
    Prp_TransmitterType,
    Prp_TransmitterNo,

    RepId, //jz 20250117
    Reviewer_EMail,
    Prp_ContactName,
    Reviewer_Area,
    Reviewer_Tel: string;

    Opr_GstHst  : Real;

    //other options
    ShowTreeViewSW      : Boolean;
    ShowConsultantOnInv : Boolean;
    UseFastPrint        : Boolean;
    UseFormSearch       : Boolean;
    ShowVisitedForms    : Boolean;
    ShowInvoiceWarning  : Boolean;
    FirstReturnColor,
    RolloverProgram,

    InvFoot1,
    InvFoot2,
    InvFoot3,
    InvFoot4,
    InvFoot5            : String;

    ShowUsedForms       : Boolean;
    OpenAtLastForm      : Boolean;
    NoBarCode           : Boolean;
    Capitalization      : String;
    //20170216 Igor <<<
  protected
  //must override
    function GetAppName: string;  override;
    function GetAppDir: string; override; //20180503 Igor
    function GetAppRelease: string;  override;
    function GetAppUpdateDate: string;  override;
    function GetAppYear: string;  override;
    function  GetDfmFileName(const FName: string): string; override;
    function GetDfmFileNameLY(const FormName: string): string; override; //20160321 Igor
    function GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160226 Igor //20160303 Igor
    function GetSQLLiteRFPassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160415 Igor
    function GetValidLastYearPgmFolder: Boolean; override; //20160302 Igor
    function GetValidLastYearDataFolder: Boolean; Override; //20160302 Igor
    function GetLastYearFormNo(AFormName: String): Integer; override; //20160302 Igor
    function GetSubstituteLastYearForm(AFormName: String): String; override; //20160302 Igor
    function GetLastYearDataFolder: String; override; //20160302 Igor
    function GetHelpFile: String; override; //20160526 Igor
    function GetHelpUpdFile: String; override; //20160526 Igor
    function GetInitLastYear: Boolean; Override; //20160629 Igor
    function GetLimitedVersionDir: String; override; //20160718 Igor
    procedure CreateDefaultDataDirectories; override;//20170803 Igor
    function GetRightTabSheets: TRightTabSheets; Override;//20171228 Igor
    //20180503 Igor >>>
    procedure InitStorage;
    function Factor2: Byte; override;
    //20180503 Igor <<<
  public
    constructor Create (AppList: TAppList); override; // 20151118 Igor
  //implement abstract methods
    function  GetMenu: TMainMenu; override;
    function  GetToolBar: TControl; override;//20170824 Igor
    function  GetSplash: TCustomControl; override;
    procedure SelectFeatures; override;
    //20160114 Igor
    procedure SetZoomCaption(AZoom: Integer); override;
    procedure ReloadMainMenu; override; //20190307 Igor
  public //cross-app adds
    function  InitNewReturn(ForLoad: boolean = False): integer; override;
    function  OpenReturn(DirName,FlName: string; fShow: boolean; AIsAppendix: Boolean = False): integer; override;
    function SaveReturn(RetNo: Integer; DataDir: string; FlName: string;
      OverrideSW: boolean; UpdMostRecent: boolean; ATextFormat: boolean = False;
      AUpdateClientTable: boolean = True; AClouds: TArrayOfInteger = nil): Integer; override; //20200914 Igor //20200916 Igor
    function OpenForeignForm(const ADir, AFile, AForm: String; const AElement: Integer): TFormData; override; //20170717 Igor
    function CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; override; //20160516 Igor
    function CheckLastYearDataFolder(out AErrorMessage: String): Boolean; override; //20160516 Igor
    function GetDefaultOptionsValue(AOptionName: String): String; override; //20160530 Igor
    function GetOptionsCaption(AOptionName: String): String; override; //20160530 Igor
    function HaveOptions(AOptionsName: String): Boolean; override; //20170112 Igor
    function GetDefaultOptions: TStringList; override; //20160530 Igor
    procedure InitFList; override; //20160531 Igor
    procedure LoadOptionsFileToMem; override; //20160530 Igor
    procedure SaveSingleOptions(const AOptionName, AValue: String; AOptionsFileName: String = ''); override; //20160602 Igor //20160617 Igor
    function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String; //20160627 Igor
      var AErr: String; AOverride: Boolean): Boolean; override;
    function isMyReturn(const AAppName: String): Boolean; override;
    //20170609 Igor >>>
    procedure InitFormsTable; override;
    function isValidDataDir(const ADir: String): Boolean; override;
    //20170609 Igor <<<
    function LicenseKeyPrefix: String; override;//20170731 Igor
    procedure OpenClientBook; override; //20200916 Igor
  public //licenses
    function  Licenses: PPgmLicenseData; override;
    function  ValidateKey(AKey: String): boolean; override;
  end;

  TRetT4T5_LastYear = class(TRetT4T5_2026) //20160629 Igor
  public
    constructor Create(TheApp: TApp); override;
  end;

function  Calc(RetNo: integer; FName: string; FNo: integer=-1): TCalcRtn; overload;
Procedure CalcAffectedBy(RetNo: integer;FName: string);

var
  AppT4T5_2026: TAppT4T5_2026;
  OptRec: TAppT4T5_2026 absolute AppT4T5_2026;
  Ret: TRetListT4T5_2026 absolute RetList;

implementation

uses SysUtils,vtCommon,vtDialogs,vtAuthorization,vtEditBox,
  //T4T5_2026Features,
  T4T5_2026TrimStr,T4T5_2026Common,T4T5_2026Common2,T4T5_2026CntErr,T4T5_2026ChildWinNew,
  T4T5_2026main,T4T5_2026Calc,T4T5_2026Calc1,//T4T5_2026Calc2,//T4T5_2026Calc3,//T4T5_2026CalcBus,
  //T4T5_2026CalcT5013,
  vtTrimStr,vtShared;

Procedure CalcAffectedBy(RetNo: integer;FName: string);
begin
  FList.CalcAffectedBy(RetNo,FName);
end;

function  Calc(RetNo: integer; FName: string; FNo: integer=-1): TCalcRtn;
Var
  FRec: TFRec;
  MyCalc: TCalcRtn;
  h: HWND;
Begin
  Result := nil;//20170609 igor
  FRec := FList.ByFormName(FName);
  if not assigned(FRec.Calc) then
  begin
    h := GetModuleHandle('vtT4T5_2026.bpl');
    MyCalc := GetProcAddress(h, PWideChar(ExtractNonInstFormName(FName)));
    if not assigned(MyCalc) then
      exit; //certification mode

    FRec.Calc := MyCalc;
  end;

  if RetNo > 0 then
  begin
    FNo := FRec.FormNo;
    If (FNo > 0) then
      if (RetList[RetNo].MyApp = AppT4T5_2026) then //20160323 Igor
      Begin
        if (Ret[RetNo].Frm[Fno].Count =0) then
          InitFormData(RetNo,FNo);
        FRec.Calc(RetNo,FName,FNo);
      End;
  end;
end;

procedure InitLists;
{MUST create the data lists AND also initialize them before using them}
var
i,j,k : integer;
s : string;
begin
  ElmsInError := TStringList.Create;
  TaxSumList := TstringList.Create;
  LoadEditBoxProperties; //20110131
  VList   := TStringList.Create;
  InitFrmTree;
  LoadOthOpt;
end;

procedure InitT4T5; //from main.initialization
begin

 If CertificationMode then userMsg('Certification Mode'
   +Chr(13)+'Open new then activate a non T3 form such as TX19');

  //GetLicenseLevel;

  InitOptions;
  AppT4T5_2026.InitFList;

end;

{ TRetListT4T5_2026 }

function TRetListT4T5_2026.GetRetT4T5(RetNo: integer): TRetT4T5_2026;
begin
  TObject(Result) := TypedReturn(RetNo,TRetT4T5_2026, False); //warnings???
end;

{ TRetT4T5_2026 }

constructor TRetT4T5_2026.Create(TheApp: TApp);

  //Function InitRetData(RetNo: Integer): Boolean;
  procedure InitRetData;
   var
     i,j: integer;
   begin
      Locked := False; {for new returns only}
      Changed := False; {for new returns only}
      SourceDataDir := OptRec.Dir_cur;
      SourceFlName := '';
     // Balance := 0;
      Province := OptRec.Nfl_Prov;
     // Bankrupt := False;
      Notes := '';
      PrpStatus := '00';
      CouplingSw := False;
    {$IFDEF defaults}
      for j := LowAvlbleAlloc to HiAvlbleAlloc do
        begin
          AvlbleAlloc[j] := 0;
          T3BoxRes[j] :=0;
          T3BoxPref[j] :=0;
          T3BoxNonRes[j] :=0;
        end;
      for j := 1 to 8 do
        begin
          T3FootRes[j] := 0;
          T3FootNonRes[j] := 0;
          T3FootPref[j] := 0;
        end;

     AvlbleFootQfp1:=0;
     AvlbleFootQfp2:=0;
     AvlbleFootQfp3:=0;
     AvlbleFootQsb1:=0;
     AvlbleFootQsb2:=0;
     AvlbleFootQsb3:=0;
    {$ELSE}
    {$ENDIF}
    FRetColor := GetNextAvailColor;
  end;

begin
    //SetLength(Ln,LnHighBound+1); //made it dynamic
    SetLength(Frm, FormsLimit+1);
    SetLength(FrmHasData, FormsLimit+1);
  inherited;
  InitRetData;
end;

destructor TRetT4T5_2026.Destroy;

  procedure DeEnlistReturn;
  var
   i,j : integer;
  begin
    {get rid of the form stringlists}
    //for i := 1 to FormsLimit do Ret[RetNo].Frm[i].free;
    //For j:=1 to MaxDynamicArraysPerForm do
  end;

begin
  DeEnListReturn;
  inherited;
end;

function TRetT4T5_2026.BeforeOpenForm(var FormName: string;
  var FormNo: integer): string;
begin
  //20171031 Igor>>>
  if not FList.ByFormName(FormName).Allowed then
  begin
    Result := '';
    ShowMessage(cLicenseDenied);
  end else
  //20171031 Igor<<<
    Result := T4T5_2026ChildWinNew.BeforeOpenForm(RetNo,FormName,FormNo);
end;

procedure TRetT4T5_2026.Calc(RNo: integer; const FName: string;
  FNo: integer);
begin
(* When called from within WITH with a different RetNo,
  call the virtual method of THAT return.
*)
  if RNo = 0 then exit;
  if RNo = RetNo then
    T4T5_2026.Calc(RNo,FName)
  else
    RetList[RNo].Calc(RNo,FName);
end;

procedure TRetT4T5_2026.CalcAll;
begin
  T4T5_2026Calc.CALCALL(RetNo);
end;

function TRetT4T5_2026.Close(fRemove: boolean): boolean;
begin
  if RetList[RetNo].LastYearRetNo <> 0 then //20160305 Igor
    CloseReturn(RetList[RetNo].LastYearRetNo, fRemove); //20160305 Igor
  Result := CloseReturn(RetNo, fRemove);
end;

procedure TRetT4T5_2026.CountDiagnostics;
begin
  T4T5_2026CntErr.CountDiagnostics(RetNo);
end;

function TRetT4T5_2026.GenerateDefaultFileNameForExport: String; //20170612 Igor
begin
  Result := IncludeTrailingPathDelimiter(OptRec.Dir_Cur) + 'ExportedData\' +
    GetReturnName + '.txt';
end;

function TRetT4T5_2026.GetDefaultFileName: String;   //20161229 Igor
//20171226 Igor>>>
//Var s:String;
begin
//  s:=GetRetName(RetNo);
//  s:=RePlaceChar(s,'&','and');
//  s:=RePlaceChar(s,'.','');
//  Result :=GetCorrectFileName(s+'-'+AppT4T5_2026.AppYear);
  Result := LeftStr(GetAccountNumber(RetNo), 8);
  if Result = '' then
    Result := RemoveSpaces(LeftStr(GetReturnName, 8));
  Result := Result + '.' + MidStr(GetYearEnd(RetNo), 3, 2);
//20171226 Igor<<<
end;

function TRetT4T5_2026.GetDfmFileName(const FName: string): string;
begin
  //20160629 Igor >>>
  //Result:=T4T5_2026ChildWinNew.GetDfmFileName(FName)
  If ShowUnconvertedLastYear(RetNo) = False then
    Result:=T4T5_2026ChildWinNew.GetDfmFileName(FName)
  else
    Result:=T4T5_2026ChildWinNew.GetLastYearDfmFileName(FName);
  //20160629 Igor <<<
end;

function TRetT4T5_2026.GetFirstName: string;
begin
  Result := RTrim(FetchElm(RetNo,'EMPL',1)); //20161229 Igor
end;

procedure TRetT4T5_2026.GetFrmTree(TreeView: TTreeView; fUsedForms: boolean);
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
  if fUsedForms then begin
    TempList:=TStringList.Create;
    TempList.Sorted:=True;
    //TempList.Add('USED FORMS'); screws up!

    for i :=0 to (FList.Count - 1) do
    begin
     FRec := FList.Items[i];
     If (Frec.FormShow) and (Ret[RetNo].FrmHasData[Frec.FormNo])
      then TempList.Add(' '+AllTrim(Frec.FormAbrev));
   end;
    TempList.Sorted := False;
    TempList.Insert(0,'USED FORMS');
    TempList.SaveToFile(AppDir+'\'+'Temp');
    FormsTreeView1.LoadFromFile(AppDir+'\'+'Temp');
    FormsTreeView1.FullExpand;
    TempList.Free;
  end else begin
     FormsTreeview1.LoadFromFile(AppDir+'\Treeview2.D');
  end;
  FormsTreeView1.TopItem:=FormsTreeView1.Items[0];
end;

function TRetT4T5_2026.GetFrmTreeFNo(SourceNode: TTreeNode;
  fUsedForms: boolean): integer;
begin
  Result := 0;
  If Uppercase(SourceNode.Text)='FILLABLE CRA FORMS' then
  Begin
    MainFormT4T5.SelectFormClick(nil);
    Exit;
  End
  else
    Result := MainFormT4T5.FormsTreeView1Click(SourceNode, fUsedForms);
end;

function TRetT4T5_2026.GetInterpetedRichEdit(LetterName: string;
  ARichEdit: TRichEdit): boolean; //20160819 Igor
begin
  Result := T4T5_2026TrimStr.GetInterpetedRichEdit(Self.RetNo, LetterName, ARichEdit);
end;

function TRetT4T5_2026.GetLastName: string;
begin
  Result := '';
end;

function TRetT4T5_2026.GetLastYearFile: String; //20160701 Igor
begin
  Result := T4T5_2026TrimStr.GetLastYearFile(Self.RetNo);
end;

function TRetT4T5_2026.GetReturnCaption: string;
begin
  Result := T4T5_2026ChildWinNew.GetReturnCaption(RetNo);
end;

function TRetT4T5_2026.GetReturnName: string;
begin
  Result := T4T5_2026TrimStr.GetRetName(RetNo);
end;

function TRetT4T5_2026.IsLetterForm(AFormName: String): Boolean; //20170612 Igor
begin
  Result := (AFormName = 'CLETTER') or
            (AFormName = 'PIPEDA') or
            (AFormName = 'ENGAGE') or
            (AFormName = 'CUSTINV') or
            (AFormName = 'ALETTER');
end;

function TRetT4T5_2026.NewChild: TMyChild;
begin
  Result := TMyChildT4T5_2026.CreateNew(Application,RetNo);
end;

function TRetT4T5_2026.RefreshAuditPanel(ReturnsHeaderPanel: TPanel;
  ErrorView: TTreeView; AuditMode: eAuditMode): string;
begin
  Result := MainFormT4T5.RefreshAuditPanel(RetNo, ReturnsHeaderPanel, ErrorView);
end;

function TRetT4T5_2026.DoSave: boolean;
begin
  Result := MainFormT4T5.DoSaveAllReturns(RetNo);  //20160223 Igor
end;

procedure TRetT4T5_2026.DoSaveAs;
begin
  MainFormT4T5.FileSaveAs(RetNo);
end;

function TRetT4T5_2026.FormClass: TvtFormClass; //20170612 igor
begin
  Result := TFormT4T5_2026;
end;

procedure TRetT4T5_2026.SetLastYearFile(const AValue: String);
begin
  T4T5_2026TrimStr.SetLastYearFile(Self.RetNo, AValue);
end;

procedure TRetT4T5_2026.StartPrintForm(FormName: String; WhichPage: integer);
begin
  MainFormT4T5.StartPrintForm(RetNo,FormName,WhichPage);
end;

function TRetT4T5_2026.AddPageInstance(NonInstFormName,
  FormInst: string): integer;
begin
  Result := T4T5_2026Common2.AddPageInstance(RetNo, NonInstFormName,FormInst);
end;

procedure TRetT4T5_2026.CloneForm(FromFormName: string; ToRetNo: integer;
  ToFormName: String; fAll: boolean);
begin
  inherited CloneForm(FromFormName, ToRetNo, ToFormName, True);
  Ret[ToRetNo].Calc(ToRetNo, ToFormName);
end;

procedure TRetT4T5_2026.CloneReturn(ToRetNo: integer);
begin
  inherited;
{copy other data}
 // Ret[ToRetNo].Bankrupt := Bankrupt;
end;

{ TAppT4T5_2026 }

function TAppT4T5_2026.CheckLastYearDataFolder(
  out AErrorMessage: String): Boolean;
begin
  Result := isValidLastYearDataFolder(false,AErrorMessage); //20160629 Igor
end;

function TAppT4T5_2026.CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; //20160516 Igor
begin
  Result := isValidLastYearPgmFolder(false,AErrorMessage); //20160629 Igor
end;

constructor TAppT4T5_2026.Create (AppList: TAppList); // 20151118 Igor
begin
  assert(AppT4T5_2026=nil,'dupe T4T5.Create');
  InitMulti;
  CurrentApp := self;
  AppT4T5_2026 := self; //required in initialization!
  AppIdx := aiT4T5;
  AppId := 'T4T5-2026';   //20150628
  ClientsDBLite:=lClientsDBLite+'_'+AppName+'.db'; //20151017 Igor !!!after AppId!!!//20170731 Igor
//  SQLLitePassword:=TFSQLLitePassword;                      //20151017 Igor //20160226 Igor
  FSQLitePassword := TSQLitePassword.Create(Self); //20160303 Igor
  //20180503 Igor >>>
  if CheckIsCloud(true) then
    T4T5_2026Declare.AppDir := CloudDir + '\' + AppId //20190213 Igor
  else
    T4T5_2026Declare.AppDir := ExeDir + '\' + AppId;
  //20180503 Igor <<<
  FFirstForm := 'EMPL'; //???
  //FCalcs := TCalcsT1_2012;
  InitStorage; //20180503 Igor
  InitT4T5; //init uDeclare
  inherited Create (AppList); // 20151118 Igor //register the AppId
  MainFormT4T5 := TMainFormT4T5_2026.Create(Application);

  AddReviewStaticForm('T4SUM'); //20171210 CON
  AddReviewStaticForm('T4ASUM'); //20171210 CON
  AddReviewStaticForm('T5SUM'); //20171210 CON

end;

procedure TAppT4T5_2026.CreateDefaultDataDirectories;//20170803 Igor
begin
  T4T5_2026TrimStr.CreateDefaultDataDirectories;
end;

function TAppT4T5_2026.Factor2: Byte; //20180503 Igor
begin
  Result := T4T5F2025;
end;

function TAppT4T5_2026.GetAppDir: string; //20180503 Igor
begin
  Result := T4T5_2026declare.AppDir;
end;

function TAppT4T5_2026.GetAppName: string;
begin
  Result := T4T5_2026declare.AppName;
end;

function TAppT4T5_2026.GetAppRelease: string;
begin
   Result := T4T5_2026declare.AppRelease;
end;

function TAppT4T5_2026.GetAppUpdateDate: string;
begin
  Result := T4T5_2026declare.AppUpdateDate;
end;

function TAppT4T5_2026.GetAppYear: string;
begin
  Result := T4T5_2026declare.AppYear;
end;

function TAppT4T5_2026.GetMenu: TMainMenu;
begin
  Result := T4T5Menu;
  MainFormT4T5.ShowCellNumbers1.Checked := ShowFieldIdSw;
end;

function TAppT4T5_2026.GetSplash: TCustomControl;
begin
  Result := MainFormT4T5.AboutPanel;
end;

function TAppT4T5_2026.GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; //20160303 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := AppName+Contributor1+Reverse(Contributor2)+Contributor3;
    2: Result := AppName+Contributor1+Reverse(Contributor2)+Contributor3ver2;
    3: Result := 'Q'+chr(111)+chr(103)+chr(55)+chr(78)+''+chr(65)+'$'+chr(57)+
                 '4'+chr(82)+chr(78)+chr(82)+''+'v'+chr(63)+'I'+chr(67); //20161208 Igor
    4: Result := 'R'+chr(80)+chr(89)+chr(107)+chr(71)+chr(106)+'1'+chr(107)+'a'+
                 chr(54)+chr(87)+chr(120)+'7'+chr(77)+''+chr(77)+chr(118); //20161215 Igor
  end;
end;

function TAppT4T5_2026.GetSQLLiteRFPassword(const Version: Integer): String; //20160415 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := Contributor1+AppName+Reverse(Contributor2)+Contributor3;
    2: Result := Contributor1+AppName+Reverse(Contributor2)+Contributor3ver2;
    3: Result := chr(98)+chr(84)+''+'1'+chr(75)+'b'+chr(80)+chr(42)+''+chr(102)+
                 'h'+chr(81)+chr(75)+chr(126)+chr(81)+chr(97)+chr(102)+chr(85); //20161208 Igor
    4: Result := chr(117)+chr(65)+'#'+chr(65)+chr(56)+chr(108)+chr(75)+chr(124)+
                 chr(48)+chr(87)+'8'+chr(88)+'~'+chr(89)+'P'+chr(51); //20161215 Igor
  end;
end;

function TAppT4T5_2026.GetSubstituteLastYearForm(AFormName: String): String; //20160302 Igor
begin
  Result := SubstituteLastYearForm(AFormName);
end;

function TAppT4T5_2026.GetToolBar: TControl; //20180122 Igor
begin
  //MainFormT4T5.SelectFeatures;
  MainFormT4T5.ZoomStr:=IntToStr(OptRec.FormZoom)+'%';
  case MainOptions.Skin of
    skSmallToolbar:
      Result := MainFormT4T5.CoolBar1;
	  skLargeToolbar:
      Result := MainFormT4T5.CoolBar2;
    skRibbon:
      Result := MainFormT4T5.MainUIRibbon; //20190415 Igor
  else
    Result := MainFormT4T5.ToolBar;
  end;
end;

function TAppT4T5_2026.GetValidLastYearDataFolder: Boolean; //20160302 Igor
begin
  Result := False;
end;

function TAppT4T5_2026.GetValidLastYearPgmFolder: Boolean; //20160302 Igor
begin
  Result := False;
end;

function TAppT4T5_2026.HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
begin
  Result := T4T5_2026TrimStr.HaveOptions(AOptionsName);
end;

function TAppT4T5_2026.LicenseKeyPrefix: String;//20170731 Igor
begin
  Result := 'T4';//20170801 Igor
end;

function TAppT4T5_2026.Licenses: PPgmLicenseData;
begin
  Result := @PgmLicenses[0];
end;

procedure TAppT4T5_2026.LoadOptionsFileToMem;
begin
  T4T5_2026TrimStr.LoadOptionsFileToMem;
end;

function MyHashString(const AKey: string): string;
var
  p: PPgmLicenseData;
  id: string;
  f1,f2: integer;
begin
  Result := '';
  if Length(AKey) <> 19 then
    exit; //valid key has exactly 19 chars
  id := LeftStr(AKey, 4); //T10x
  p := @pgmLicenses[0];
  while p.Level > llNone do begin
    if p.Id = id then
      break;
    inc(p);
  end;
  f1 := p.Factor;
  f2 := T4T5F2025; //20220801
  Result := MakeHashString(AKey, f1, f2);
end;

function TAppT4T5_2026.ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String; //20160627 Igor
  var AErr: String; AOverride: Boolean): Boolean;
begin
  Result := T4T5_2026TrimStr.ImportOneReturn(ADS, ASrcDir, ADstDir, AErr, AOverride);
end;

procedure TAppT4T5_2026.InitFList;
begin
  inherited;
  if not assigned(FList) then
  begin
    OptRec.Dir_Cur :=OptRec.Dir_Deflt;

    T4T5_2026Declare.FList := TFListT4T5.Create(AppT4T5_2026, FormsLimit,FieldsLimit,FormsDBLite,FormsTableLite);//20150119 Igor
    AppT4T5_2026.ConvertDataBase; //20160304 Igor
    T4T5_2026TrimStr.InitFormsTable;  {all forms available}
    InitColorTable;  {all colors available}
    InitLists;       {Forms and return lists}
    InitSwitches;
    InitBmps;
  end;

end;

function TAppT4T5_2026.InitNewReturn(ForLoad: boolean): integer;
begin
  Result := T4T5_2026Common.CreateNewReturn; //(ForLoad);
end;

procedure TAppT4T5_2026.InitStorage; //20180503 Igor
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

function TAppT4T5_2026.isMyreturn(const AAppName: String): Boolean;
begin
  Result := AAppName = 'TAXFORMS';
end;

procedure TAppT4T5_2026.OpenClientBook; //20200916 Igor
var FSaveApp: TApp;
begin
  inherited;
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppT4T5_2026;
    MainformT4T5.OpenReturnLblClick(nil);
  finally
    CurrentApp := FSaveApp;
  end;
end;

function TAppT4T5_2026.OpenForeignForm(const ADir, AFile, AForm: String;
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
    R := T4T5_2026Common2.OpenReturn(ADir, AFile, False, False);
  if R <=0 then
    exit(nil);
  F := OpenForm(R, AForm, AElement);
  if Assigned(F) then
    Result := RetList[R].Form[AForm]
  else
    Result := nil;
end;

function TAppT4T5_2026.OpenReturn(DirName, FlName: string;
  fShow: boolean; AIsAppendix: Boolean = False): integer; //20160305 Igor
begin
  Result := T4T5_2026Common2.OpenReturn(DirName,FlName,fShow,AIsAppendix); //20160305 Igor
end;

procedure TAppT4T5_2026.ReloadMainMenu; //20190307 Igor
begin
  inherited;
  MainFormT4T5.ReloadMainMenu;
end;

function TAppT4T5_2026.SaveReturn(RetNo: Integer; DataDir, FlName: string; //20200914 Igor //20200916 Igor
  OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable: boolean;
  AClouds: TArrayOfInteger): Integer;
var FSaveApp: TApp;
begin
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppT4T5_2026;
    Result := T4T5_2026Common2.SaveReturn(RetNo, DataDir, FlName, OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable, AClouds);
  finally
    CurrentApp := FSaveApp;
  end;
end;

procedure TAppT4T5_2026.SaveSingleOptions(const AOptionName, AValue: String;
  AOptionsFileName: String);
begin
  inherited;
  T4T5_2026TrimStr.SaveSingleOption(AOptionName, AValue, AOptionsFileName);
end;

procedure TAppT4T5_2026.SelectFeatures;
begin
 // T4T5_2026Features.SelectFeatures;
end;

procedure TAppT4T5_2026.SetZoomCaption(AZoom: Integer);
begin
  MainFormT4T5.ZoomStr := IntToStr(AZoom)+'%'; //20180122 Igor
end;

function TAppT4T5_2026.ValidateKey(AKey: String): boolean;
begin
  result:= inherited ValidateKey(AKey); //checks length and hash
  //T402-0138-1239-1740

  if not Result then exit;

  //20231211
  If (UpperCase(AKey)='T402-0138-1239-1740')   //Paul gerin by mistake //20231211
  or (UpperCase(AKey)='T402-9013-0518-1740')   // M Pandya Refund  /20231211
  then
  begin
   result:=False;
   exit;
  end;

  //20150628
  Result := MidStr(AKey,16,4) = MyHashString(AKey); //20160220 Igor
  If UpperCase(LeftStr(AKey,2)) <> UpperCase(LicenseKeyPrefix) then result:=False;  {T1 key goes with T1, etc}

end;

function TAppT4T5_2026.GetDefaultOptions: TStringList;
begin
  result := T4T5_2026TrimStr.GetDefaultOptions;
end;

function TAppT4T5_2026.GetDefaultOptionsValue(AOptionName: String): String;
begin
  result := T4T5_2026TrimStr.GetDefaultOptionsValue(AOptionName);
end;

function TAppT4T5_2026.GetOptionsCaption(AOptionName: String): String;
begin
  result := T4T5_2026TrimStr.GetOptionsCaption(AOptionName);
end;

function TAppT4T5_2026.GetRightTabSheets: TRightTabSheets;//20171228 Igor
begin
  Result := [rtsReview];
end;

function TAppT4T5_2026.GetDfmFileName(const FName: string): string;
begin
  Result:=T4T5_2026ChildWinNew.GetDfmFileName(FName)
end;

function TAppT4T5_2026.GetDfmFileNameLY(const FormName: string): string;
begin
  Result:=T4T5_2026ChildWinNew.GetLastYearDfmFileName(FormName)
end;

function TAppT4T5_2026.GetHelpFile: String;
begin
  Result := 'http://www.visualtax.com/Vt2018HELP/T4T5Help/Website/T4T5Help.html'; //20161220 Igor
end;

function TAppT4T5_2026.GetHelpUpdFile: String;
begin
  Result := 'http://visualtax.com/Vt2018HELP/T4T5Help/T4T5UPD/T4T5UpdHlp.html'; //20160801 Igor //20161220 Igor
end;

function TAppT4T5_2026.GetInitLastYear: Boolean;
begin
  if Assigned(FLastYearList) then
    Result := True
  else
  Begin
    InitLastYearFormsTable;
    result := Assigned(FLastYearList);
  End;
end;

function TAppT4T5_2026.GetLastYearDataFolder: String; //20160302 Igor
begin
  if Dir_LastYr[length(Dir_LastYr)] = '\' then   //20160424 Igor
    Delete(Dir_LastYr,length(Dir_LastYr)-1,1);
  Result := Dir_LastYr;
end;

function TAppT4T5_2026.GetLastYearFormNo(AFormName: String): Integer; //20160302 Igor
begin
  Result := T4T5_2026TrimStr.GetLastYearFormNo(AFormName); //20160629 Igor
end;

function TAppT4T5_2026.GetLimitedVersionDir: String; //20160718 Igor
begin
  Result := T4T5_2026Declare.LimitedVersionDir;
end;

//20170609 Igor >>>
procedure TAppT4T5_2026.InitFormsTable;
begin
  if T4T5_2026Declare.FList.InitFormsTable(AppDir, FormsDBLite, FormsTableLite) then
    exit; //okay

  PrepareDistribution;

  if T4T5_2026Declare.FList.InitFormsTable(AppDir, FormsDBLite, FormsTableLite) then
    exit; //okay

  UserMsg('Please fix errors in T4T5 forms');
  Application.Terminate;
end;

function TAppT4T5_2026.isValidDataDir(const ADir: String): Boolean;
Begin
  If (LicenseLevel in anyLimited)
     and not SameText(UpperCase(ADir), LimitedVersionDir) then
  begin
    UserMsg('In T4T5 Limited version' + Chr(13) +
            'the current and default data directory must be '+LimitedVersionDir);
    Result := False;
  end
  else
    Result := True;
End;
//20170609 Igor <<<

{ TFListT4T5 }

function TFListT4T5.LoadFromTable(Table1: TDataSet): TFRec;
var
  FRec: TFRec absolute Result;
begin
  Result := TFRec.Create;
    FRec.FormNo      := Table1.FieldByName('FormNo').AsInteger;
    FRec.FormName    := UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
    FRec.FormInst    := LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
    FRec.FormMxInst  := Table1.FieldByName('FormMxInst').AsString;
    FRec.FormDescr   := Table1.FieldByName('FormDescr').AsString;
    FRec.FormMxPg    := Table1.FieldByName('FormMxPg').AsInteger;
    FRec.FormRlNm    := Table1.FieldByName('FormRlNm').AsString;
    FRec.FormAbrev   := Table1.FieldByName('FormAbrev').AsString;
    FRec.FormType    := Table1.FieldByName('FormType').AsString;
    if Table1.FieldByName('FormShow').DataType = ftBoolean then //20160629 Igor
       FRec.FormShow := Table1.FieldByName('FormShow').AsBoolean
    else
       FRec.FormShow := Boolean(Table1.FieldByName('FormShow').AsInteger);
    Frec.FormFields  := Table1.FieldByName('FormFields').AsInteger;
    //If Frec.FormFields = 0 then Frec.FormFields := FieldsLimit;
    if Table1.FieldByName('IsSlip').DataType = ftBoolean then  //20160629 Igor
      Frec.IsSlip      := Table1.FieldByName('IsSlip').AsBoolean
    else
      Frec.IsSlip      := Boolean(Table1.FieldByName('IsSlip').AsInteger);

    if Table1.FieldByName('Preload').DataType = ftBoolean then  //20160629 Igor
      Frec.Preload     := Table1.FieldByName('Preload').AsBoolean
    else
      Frec.Preload     := Boolean(Table1.FieldByName('Preload').AsInteger);

    Frec.DataIndic   := Table1.FieldByName('DataIndic').AsString;

    if Table1.FieldByName('WhiteBoxes').DataType = ftBoolean then  //20160629 Igor
      Frec.WhiteBoxes  := Table1.FieldByName('WhiteBoxes').AsBoolean
    else
      Frec.WhiteBoxes  := Boolean(Table1.FieldByName('WhiteBoxes').AsInteger);

    if Table1.FieldByName('ShowFlag').DataType = ftBoolean then  //20160629 Igor
      Frec.ShowFlag  := Table1.FieldByName('ShowFlag').AsBoolean
    else
      Frec.ShowFlag  := Boolean(Table1.FieldByName('ShowFlag').AsInteger);

    if Table1.FieldByName('ShowHdr').DataType = ftBoolean then  //20160629 Igor
      Frec.ShowHdr  := Table1.FieldByName('ShowHdr').AsBoolean
    else
      Frec.ShowHdr  := Boolean(Table1.FieldByName('ShowHdr').AsInteger);
    Frec.LandScape  := StringToBoolean(Table1.FieldByName('LandScape').AsString);
    Frec.PrnSeq     := Table1.FieldByName('PrnSeq').AsString; //really string!
    Frec.CursorPos  := Table1.FieldByName('CursorPos').AsInteger;
    Frec.FormHeight  := Table1.FieldByName('FormHeight').AsInteger;
    Frec.Fee         := Table1.FieldByName('Fee').AsString;
    Frec.FeeAddItem  := Table1.FieldByName('FeeAddItem').AsString;
end;

{ TRetT4T5_LastYear }

constructor TRetT4T5_LastYear.Create(TheApp: TApp);
begin
  FList := FLastYearList;
  inherited Create(TheApp);
  FIsLastYearReturn := True;
end;

initialization
{$IFDEF isbpl}
   Classes.RegisterClass(TAppT4T5_2026);   // 20151118 Igor
{$ELSE}
//   AppT4T5_2026 := TAppT4T5_2026.Create(AppList); //20170927 Igor
{$ENDIF}
end.
