{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{            FireDAC persistent definitions             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADStanDef"'}

unit uADStanDef;

interface

uses
  uADStanIntf;

function ADLoadConnDefGlobalFileName: String;
procedure ADSaveConnDefGlobalFileName(const AName: String);
function ADLoadDriverDefGlobalFileName: String;
procedure ADSaveDriverDefGlobalFileName(const AName: String);

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils, Classes, IniFiles,
  uADStanFactory, uADStanUtil, uADStanError, uADStanConst, uADStanOption,
    uADStanResStrs;

type
  TADCustomDefinitionStorage = class;
  TADFileDefinitionStorage = class;
  TADDefinition = class;
  TADDefinitions = class;
  TADDefinitionClass = class of TADDefinition;
  TADConnectionDef = class;
  TADConnectionDefs = class;

  TADCustomDefinitionStorage = class (TADObject, IADStanDefinitionStorage)
  private
    FFileName: String;
    FGlobalFileName: String;
    FDefaultFileName: String;
  protected
    // IADStanDefinitionStorage
    function GetFileName: String;
    procedure SetFileName(const AValue: String);
    function GetGlobalFileName: String;
    procedure SetGlobalFileName(const AValue: String);
    function GetDefaultFileName: String;
    procedure SetDefaultFileName(const AValue: String);
    function CreateIniFile: TCustomIniFile; virtual; abstract;
    function ActualFileName: String; virtual; abstract;
  end;

  TADFileDefinitionStorage = class(TADCustomDefinitionStorage)
  public
    function CreateIniFile: TCustomIniFile; override;
    function ActualFileName: String; override;
  end;

  TADDefinitionFlag = (dfParentMaybeChanged, dfRefManaged, dfDeleteDisabled,
    dfModifyDisabled);
  TADDefinitionFlags = set of TADDefinitionFlag;

  TADDefinition = class (TCollectionItem, IUnknown, IADStanDefinition)
  private
{$IFNDEF AUTOREFCOUNT}
    FRefCount: Integer;
{$ENDIF}
    FOriginalName,
    FPrevName: String;
    FParams: TStrings;
    FState: TADDefinitionState;
    FStyle: TADDefinitionStyle;
    FFlags: TADDefinitionFlags;
    FParentDefinition: IADStanDefinition;
    FOnChanging: TNotifyEvent;
    FOnChanged: TNotifyEvent;
    FPassCode: LongWord;
    function GetDefinitionList: TADDefinitions;
    procedure Normalize;
    procedure Migrate;
    procedure ParamsChanging(Sender: TObject);
    procedure CheckRO(AFlag: TADDefinitionFlag);
    procedure UpdateParentDefinition;
    procedure InternalSetParentDefinition(const AValue: IADStanDefinition);
  protected
    // IUnknown
{$IFDEF AnyDAC_FPC}
    function QueryInterface({$IFDEF FPC_HAS_CONSTREF} constref {$ELSE} const {$ENDIF} iid: tguid;
      out obj): longint; {$IFNDEF WINDOWS} cdecl {$ELSE} stdcall {$ENDIF};
{$ELSE}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
{$ENDIF}
    function _AddRef: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    function _Release: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    // IADStanDefinition
    function GetName: String;
    function GetParams: TStrings;
    function GetAsBoolean(const AName: String): LongBool;
    function GetAsInteger(const AName: String): LongInt;
    function GetAsString(const AName: String): String;
    function GetAsXString(const AName: String): String;
    function GetState: TADDefinitionState;
    function GetStyle: TADDefinitionStyle;
    function GetParentDefinition: IADStanDefinition;
    function GetOnChanging: TNotifyEvent;
    function GetOnChanged: TNotifyEvent;
    function GetUpdatable: Boolean;
    procedure SetName(const AValue: string);
    procedure SetParams(const AValue: TStrings);
    procedure SetAsBoolean(const AName: String; const AValue: LongBool);
    procedure SetAsYesNo(const AName: String; const AValue: LongBool);
    procedure SetAsInteger(const AName: String; const AValue: LongInt);
    procedure SetAsString(const AName, AValue: String);
    procedure SetParentDefinition(const AValue: IADStanDefinition);
    procedure SetOnChanging(AValue: TNotifyEvent);
    procedure SetOnChanged(AValue: TNotifyEvent);
{$IFDEF AnyDAC_MONITOR}
    procedure BaseTrace(const AMonitor: IADMoniClient);
    procedure Trace(const AMonitor: IADMoniClient);
{$ENDIF}
    procedure Apply;
    procedure Clear;
    procedure Cancel;
    procedure Delete;
    procedure MarkPersistent; virtual;
    procedure MarkUnchanged;
    procedure OverrideBy(const ADefinition: IADStanDefinition; AAll: Boolean);
    function ParseString(const AStr: String; AKeywords: TStrings = nil): String; overload;
    function ParseString(const AStr: String; AKeywords: TStrings; const AFmt: TADParseFmtSettings): String; overload;
    function BuildString(AKeywords: TStrings = nil): String; overload;
    function BuildString(AKeywords: TStrings; const AFmt: TADParseFmtSettings): String; overload;
    function HasValue(const AName: String): Boolean; overload;
    function HasValue(const AName: String; var ALevel: Integer): Boolean; overload;
    function OwnValue(const AName: String): Boolean;
    function IsSpecified(const AName: String): Boolean;
    procedure ToggleUpdates(APassCode: LongWord; ADisableDelete, ADisableModify: Boolean);
    // other
    procedure ParamsChanged(Sender: TObject);
    procedure ReadFrom(AReader: TCustomIniFile);
    procedure WriteTo(AWriter: TCustomIniFile; AIfModified: Boolean = True);
  public
    constructor Create(ACollection: TCollection); override;
    constructor CreateTemporary;
    destructor Destroy; override;
{$IFNDEF AUTOREFCOUNT}
    procedure AfterConstruction; override;
    class function NewInstance: TObject; override;
{$ENDIF}
    property OriginalName: String read FOriginalName;
    property DefinitionList: TADDefinitions read GetDefinitionList;
  end;

  TADDefinitionTemporaryFactory = class(TADMultyInstanceFactory)
  protected
    function CreateObject: TObject; override;
  public
    constructor Create;
  end;

  TADDefinitionsState = (dsNotLoaded, dsLoading, dsLoaded);
  TADDefinitions = class (TADObject, IADStanDefinitions)
  private
    FAutoLoad: Boolean;
    FState: TADDefinitionsState;
    FStorage: IADStanDefinitionStorage;
    FList: TCollection;
    FLock: TADMREWSynchronizer;
    FBeforeLoad,
    FAfterLoad: TNotifyEvent;
    FName: String;
    procedure InternalDelete(ADefinition: TADDefinition);
    function InternalAdd: TADDefinition;
    procedure CheckLoaded;
    function InternalFindDefinition(const AName: String;
      AExclude: TADDefinition): TADDefinition;
    function BuildUniqueName(const AName: String; AItem: TADDefinition): String;
    function IsUniqueName(const AName: String; AItem: TADDefinition): Boolean;
  protected
    // IADStanDefinitions
    function GetCount: Integer;
    function GetItems(AIndex: Integer): IADStanDefinition;
    function GetAutoLoad: Boolean;
    function GetStorage: IADStanDefinitionStorage;
    function GetLoaded: Boolean;
    function GetBeforeLoad: TNotifyEvent;
    function GetAfterLoad: TNotifyEvent;
    function GetUpdatable: Boolean;
    function GetName: String;
    procedure SetAutoLoad(AValue: Boolean);
    procedure SetBeforeLoad(AValue: TNotifyEvent);
    procedure SetAfterLoad(AValue: TNotifyEvent);
    procedure SetName(const AValue: String);
    function Add: IADStanDefinition;
    function AddTemporary: IADStanDefinition;
    function FindDefinition(const AName: String): IADStanDefinition;
    function DefinitionByName(const AName: String): IADStanDefinition;
    procedure Cancel;
    procedure Save(AIfModified: Boolean = True);
    function Load: Boolean;
    procedure Clear;
    procedure BeginRead;
    procedure EndRead;
    procedure BeginWrite;
    procedure EndWrite;
    // other
    function CreateIniFile: TCustomIniFile;
    function GetItemClass: TADDefinitionClass; virtual;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

  TADConnectionDef = class (TADDefinition, IADStanConnectionDef)
  protected
    // IADStanConnectionDef
    function GetPooled: Boolean;
    function GetDriverID: String;
    function GetPassword: String;
    function GetUserName: String;
    function GetDatabase: String;
    function GetNewPassword: String;
    function GetExpandedDatabase: String;
    function GetMonitorBy: String;
    function GetServer: String;
    function GetPort: Integer;
    function GetOSAuthent: Boolean;
    function GetMetaDefSchema: String;
    function GetMetaDefCatalog: String;
    procedure SetPooled(AValue: Boolean);
    procedure SetDriverID(const AValue: String);
    procedure SetPassword(const AValue: String);
    procedure SetUserName(const AValue: String);
    procedure SetDatabase(const AValue: String);
    procedure SetNewPassword(const AValue: String);
    procedure SetMonitorBy(const AValue: String);
    procedure SetServer(const AValue: String);
    procedure SetPortI(const AValue: Integer);
    procedure SetOSAuthent(const AValue: Boolean);
    procedure SetMetaDefSchema(const AValue: String);
    procedure SetMetaDefCatalog(const AValue: String);
    procedure WriteOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
    procedure ReadOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
  public
    procedure MarkPersistent; override;
  end;

  TADConnectionDefTemporaryFactory = class(TADMultyInstanceFactory)
  protected
    function CreateObject: TObject; override;
  public
    constructor Create;
  end;

  TADConnectionDefs = class (TADDefinitions, IADStanConnectionDefs)
  protected
    // IADStanConnectionDefs
    function GetConnectionDefs(AIndex: Integer): IADStanConnectionDef;
    function AddConnectionDef: IADStanConnectionDef;
    function FindConnectionDef(const AName: String): IADStanConnectionDef;
    function ConnectionDefByName(const AName: String): IADStanConnectionDef;
    // other
    function GetItemClass: TADDefinitionClass; override;
  public
    procedure Initialize; override;
  end;

{$IFNDEF AnyDAC_FPC}
  TADOptsComponent = class(TADComponent)
  private
    FFetchOptions: TADFetchOptions;
    FFormatOptions: TADFormatOptions;
    FUpdateOptions: TADUpdateOptions;
    FResourceOptions: TADResourceOptions;
  published
    property FetchOptions: TADFetchOptions read FFetchOptions write FFetchOptions;
    property FormatOptions: TADFormatOptions read FFormatOptions write FFormatOptions;
    property UpdateOptions: TADUpdateOptions read FUpdateOptions write FUpdateOptions;
    property ResourceOptions: TADResourceOptions read FResourceOptions write FResourceOptions;
  end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADCustomDefinitionStorage                                                    }
{-------------------------------------------------------------------------------}
function TADCustomDefinitionStorage.GetDefaultFileName: String;
begin
  Result := FDefaultFileName;
end;

{-------------------------------------------------------------------------------}
function TADCustomDefinitionStorage.GetFileName: String;
begin
  Result := FFileName;
end;

{-------------------------------------------------------------------------------}
function TADCustomDefinitionStorage.GetGlobalFileName: String;
begin
  Result := FGlobalFileName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomDefinitionStorage.SetDefaultFileName(const AValue: String);
begin
  FDefaultFileName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomDefinitionStorage.SetFileName(const AValue: String);
begin
  FFileName := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomDefinitionStorage.SetGlobalFileName(const AValue: String);
begin
  FGlobalFileName := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADFileDefinitionStorage                                                      }
{-------------------------------------------------------------------------------}
function TADFileDefinitionStorage.ActualFileName: String;
begin
  Result := ADGetBestPath(GetFileName, GetGlobalFileName, GetDefaultFileName);
end;

{-------------------------------------------------------------------------------}
function TADFileDefinitionStorage.CreateIniFile: TCustomIniFile;
var
  oIni: TADIniFile;
begin
  oIni := TADIniFile.Create(ActualFileName);
{$IFDEF AnyDAC_D12}
  if (oIni.Encoding = nil) or (oIni.Encoding = TEncoding.Default) then
    oIni.Encoding := TEncoding.UTF8;
{$ENDIF}
  Result := oIni;
end;

{-------------------------------------------------------------------------------}
{- TADDefinitionCollection                                                     -}
{-------------------------------------------------------------------------------}
type
  TADDefinitionCollection = class(TCollection)
  private
    FDefinitionList: TADDefinitions;
  public
    constructor Create(AList: TADDefinitions;
      AItemClass: TADDefinitionClass);
  end;

{-------------------------------------------------------------------------------}
constructor TADDefinitionCollection.Create(AList: TADDefinitions;
  AItemClass: TADDefinitionClass);
begin
  inherited Create(AItemClass);
  FDefinitionList := AList;
end;

{-------------------------------------------------------------------------------}
{- TADDefinition                                                               -}
{-------------------------------------------------------------------------------}
constructor TADDefinition.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FParams := TADStringList.Create;
  TADStringList(FParams).OnChange := ParamsChanged;
  TADStringList(FParams).OnChanging := ParamsChanging;
  Clear;
end;

{-------------------------------------------------------------------------------}
constructor TADDefinition.CreateTemporary;
begin
  Create(nil);
  FParams.Clear;
  FStyle := atTemporary;
  Include(FFlags, dfRefManaged);
end;

{-------------------------------------------------------------------------------}
destructor TADDefinition.Destroy;
begin
  CheckRO(dfDeleteDisabled);
  SetParentDefinition(nil);
  ADFreeAndNil(FParams);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AUTOREFCOUNT}
procedure TADDefinition.AfterConstruction;
begin
  ADInterlockedDecrement(FRefCount);
end;

{-------------------------------------------------------------------------------}
class function TADDefinition.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TADDefinition(Result).FRefCount := 1;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDefinition._AddRef: Integer;
begin
{$IFDEF AUTOREFCOUNT}
  Result := __ObjAddRef;
{$ELSE}
  Result := ADInterlockedIncrement(FRefCount);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADDefinition._Release: Integer;
begin
{$IFDEF AUTOREFCOUNT}
  { TODO -cNEXTGEN : How to handle dfRefManaged ? }
  Result := __ObjRelease;
{$ELSE}
  Result := ADInterlockedDecrement(FRefCount);
  if (Result = 0) and (dfRefManaged in FFlags) then
    Destroy;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_FPC}
function TADDefinition.QueryInterface({$IFDEF FPC_HAS_CONSTREF} constref {$ELSE} const {$ENDIF}
  iid: tguid; out obj): longint; {$IFNDEF WINDOWS} cdecl {$ELSE} stdcall {$ENDIF};
{$ELSE}
function TADDefinition.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
{$ENDIF}
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetDefinitionList: TADDefinitions;
begin
  if Collection <> nil then
    Result := TADDefinitionCollection(Collection).FDefinitionList
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.InternalSetParentDefinition(const AValue: IADStanDefinition);
begin
  if (AValue <> nil) and (AValue = Self as IADStanDefinition) then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefCircular, [GetName]);
  if FParentDefinition <> AValue then begin
    FParentDefinition := AValue;
    Normalize;
    Migrate;
  end;
  Exclude(FFlags, dfParentMaybeChanged);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetParentDefinition(const AValue: IADStanDefinition);
begin
  InternalSetParentDefinition(AValue);
  if AValue = nil then
    Include(FFlags, dfParentMaybeChanged);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.UpdateParentDefinition;
var
  s: String;
begin
  if (dfParentMaybeChanged in FFlags) and (GetDefinitionList <> nil) then begin
    Exclude(FFlags, dfParentMaybeChanged);
    s := GetAsString(S_AD_DefinitionParam_Common_Parent);
    if s = '' then
      s := GetAsString(S_AD_DefinitionParam_Common_ConnectionDef);
    if s <> '' then
      InternalSetParentDefinition(GetDefinitionList.DefinitionByName(s));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Normalize;
var
  i, j: Integer;
  sName: String;
begin
  if FParentDefinition <> nil then begin
    FParams.BeginUpdate;
    try
      i := FParams.Count - 1;
      while i >= 0 do begin
        sName := ADNameFromIndex(FParams, i);
        if sName <> '' then begin
          j := FParams.IndexOfName(sName);
          if (j >= 0) and (j < i) then begin
            FParams.Delete(j);
            Dec(i);
          end;
          if AnsiCompareText(FParentDefinition.GetAsString(sName), FParams.Values[sName]) = 0 then
            FParams.Delete(i);
        end;
        Dec(i);
      end;
    finally
      FParams.EndUpdate;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Migrate;
var
  i: Integer;
begin
  // v 2.0.0
  // changed: MSSQL2000 and MSSQL2005 driver ID's replaced by MSSQL
  i := FParams.IndexOfName(S_AD_ConnParam_Common_DriverID);
  if i <> -1 then
    if (AnsiCompareText(FParams.Values[S_AD_ConnParam_Common_DriverID], S_AD_MSSQLId + '2000') = 0) or
       (AnsiCompareText(FParams.Values[S_AD_ConnParam_Common_DriverID], S_AD_MSSQLId + '2005') = 0) then
    FParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_MSSQLId;
  // changed: Generic ODBC driver parameter 'Driver' renamed to 'ODBCDriver'
  i := FParams.IndexOfName('Driver');
  if i <> -1 then
    FParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_ConnParam_ODBC_Driver;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.OverrideBy(const ADefinition: IADStanDefinition; AAll: Boolean);
var
  i: Integer;
  sName, sValue: String;
begin
  CheckRO(dfModifyDisabled);
  if ADefinition <> nil then
    for i := 0 to ADefinition.Params.Count - 1 do begin
      sName := ADNameFromIndex(ADefinition.Params, i);
      sValue := ADValueFromIndex(ADefinition.Params, i);
      if AAll or (sValue <> '') then
        SetAsString(sName, sValue);
    end;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.ParseString(const AStr: String; AKeywords: TStrings): String;
begin
  Result := ParseString(AStr, AKeywords, GParseFmtSettings);
end;

{-------------------------------------------------------------------------------}
function TADDefinition.ParseString(const AStr: String; AKeywords: TStrings;
  const AFmt: TADParseFmtSettings): String;
var
  i, j: Integer;
  sParam, sValue, sId, sODBCId: String;
  lFound: Boolean;
begin
  i := 1;
  Result := '';
  while i <= Length(AStr) do begin
    sParam := ADExtractFieldName(AStr, i, AFmt);
    j := Pos('=', sParam);
    if j <> 0 then begin
      sId := Copy(sParam, 1, j - 1);
      sValue := Copy(sParam, j + 1, Length(sParam));
    end
    else begin
      sId := S_AD_ConnParam_Common_Database;
      sValue := sParam;
    end;
    if (AKeywords <> nil) and (AKeywords.Count > 0) then begin
      lFound := False;
      for j := 0 to AKeywords.Count - 1 do begin
        sODBCId := ADValueFromIndex(AKeywords, j);
        if (sODBCId <> '') and (sODBCId[Length(sODBCId)] = '*') then
          sODBCId:= Copy(sODBCId, 1, Length(sODBCId) - 1);
        if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
           (sODBCId, sId) = 0 then begin
          sId := ADNameFromIndex(AKeywords, j);
          lFound := True;
        end
        else if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
                (AKeywords[j], sId) = 0 then
          lFound := True;
        if lFound then
          Break;
      end;
    end
    else
      lFound := True;
    if sId <> '' then
      if lFound then begin
        if (sValue <> '') and (
            (sValue[1] = AFmt.FQuote) and (sValue[Length(sValue)] = AFmt.FQuote) or
            (sValue[1] = AFmt.FQuote1) and (sValue[Length(sValue)] = AFmt.FQuote2)
           ) then
          sValue := Copy(sValue, 2, Length(sValue) - 2);
        SetAsString(sId, sValue);
      end
      else begin
        if Result <> '' then
          Result := Result + AFmt.FDelimiter;
        Result := Result + sParam;
      end;
  end;
  Normalize;
  Migrate;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.BuildString(AKeywords: TStrings): String;
begin
  Result := BuildString(AKeywords, GParseFmtSettings);
end;

{-------------------------------------------------------------------------------}
type
  TADKwdValue = class(TObject)
  private
    FId, FVal: String;
    FKwdPos: Integer;
  public
    constructor Create(const AId, AVal: String; AKwdPos: Integer);
  end;

constructor TADKwdValue.Create(const AId, AVal: String; AKwdPos: Integer);
begin
  inherited Create;
  FId := AId;
  FVal := AVal;
  FKwdPos := AKwdPos;
end;

function SortByKwdPos(AList: TStringList; AIndex1, AIndex2: Integer): Integer;
begin
  Result := TADKwdValue(AList.Objects[AIndex1]).FKwdPos -
    TADKwdValue(AList.Objects[AIndex2]).FKwdPos;
end;

function TADDefinition.BuildString(AKeywords: TStrings; const AFmt: TADParseFmtSettings): String;
var
  i, j, iParamsProcessed: Integer;
  sId, sVal: String;
  oKeywordValues: TADStringList;
  oDef: IADStanDefinition;
  oKwdValue: TADKwdValue;

  procedure AddKwdValue(AKwdPos: Integer; const AID: String);
  begin
    if (sVal <> '') and (AID <> '') and (oKeywordValues.IndexOf(AID) = -1) then
      oKeywordValues.AddObject(AID, TADKwdValue.Create(AID, sVal, AKwdPos));
  end;

  function AddParam(const AStr, AId, AValue: String): String;
  var
    lSpecialSymbol: Boolean;
    j: Integer;
    sId: String;
  begin
    lSpecialSymbol := False;
    sId := AId;
    if (sId <> '') and (sId[Length(sId)] = '*') then
      sId := Copy(sId, 1, Length(sId) - 1)
    else if not ((AValue[1] = AFmt.FQuote1) and (AValue[Length(AValue)] = AFmt.FQuote2) or
                (AValue[1] = AFmt.FQuote) and (AValue[Length(AValue)] = AFmt.FQuote)) then
      for j := 1 to Length(AValue) do
        case AValue[j] of
        '[', ']', '{', '}', '(', ')', ',', ';', '?', '*', '=', '!', '@':
          begin
            lSpecialSymbol := True;
            Break;
          end;
        end;
    if lSpecialSymbol then
      Result := Format('%s%s=%s%s%s%s', [AStr, sId, AFmt.FQuote1, AValue,
        AFmt.FQuote2, AFmt.FDelimiter])
    else
      Result := Format('%s%s=%s%s', [AStr, sId, AValue, AFmt.FDelimiter]);
  end;

begin
  oKeywordValues := TADStringList.Create;
  oKeywordValues.Sorted := True;
  iParamsProcessed := 0;
  try
    oDef := Self as IADStanDefinition;
    while oDef <> nil do begin
      for i := 0 to oDef.Params.Count - 1 do begin
        sId := ADNameFromIndex(oDef.Params, i);
        sVal := ADExpandStr(ADValueFromIndex(oDef.Params, i));
        Inc(iParamsProcessed);
        if (sVal <> '') and (AKeywords <> nil) and (AKeywords.Count > 0) then
          for j := 0 to AKeywords.Count - 1 do begin
            if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
               (AKeywords[j], sId) = 0 then
              AddKwdValue(j, sId)
            else if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
                    (ADNameFromIndex(AKeywords, j), sId) = 0 then
              AddKwdValue(j, ADValueFromIndex(AKeywords, j));
          end
        else
          AddKwdValue(iParamsProcessed, sId);
      end;
      oDef := oDef.ParentDefinition;
    end;

    Result := '';
    oKeywordValues.Sorted := False;
    oKeywordValues.CustomSort(SortByKwdPos);
    for i := 0 to oKeywordValues.Count - 1 do begin
      oKwdValue := TADKwdValue(oKeywordValues.Objects[i]);
      Result := AddParam(Result, oKwdValue.FId, oKwdValue.FVal);
      ADFree(oKwdValue);
    end;
    if (Result <> '') and (Result[Length(Result)] = AFmt.FDelimiter) then
      SetLength(Result, Length(Result) - 1);

  finally
    ADFree(oKeywordValues);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.CheckRO(AFlag: TADDefinitionFlag);
var
  s: String;
begin
  if (FPassCode <> 0) and (AFlag in FFlags) then begin
    if AFlag = dfModifyDisabled then
      s := 'change'
    else
      s := 'delete';
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefRO, [s, GetName]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.ParamsChanging(Sender: TObject);
begin
  CheckRO(dfModifyDisabled);
  FPrevName := GetName;
  if Assigned(FOnChanging) then
    FOnChanging(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.ParamsChanged(Sender: TObject);
var
  sNewName: String;
begin
  if FState = asLoaded then
    FState := asModified;
  Include(FFlags, dfParentMaybeChanged);
  if (Collection <> nil) and (FPrevName <> '') then
    try
      sNewName := GetName;
      if (FPrevName <> sNewName) and not DefinitionList.IsUniqueName(sNewName, Self) then begin
        SetName(FPrevName);
        ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefDupName, [sNewName]);
      end;
    finally
      FPrevName := '';
    end;
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Clear;
begin
  CheckRO(dfModifyDisabled);
  FParams.Clear;
  FOriginalName := '';
  FPrevName := '';
  if Collection <> nil then
    SetName(DefinitionList.BuildUniqueName(S_AD_Unnamed, Self))
  else
    SetName(S_AD_Unnamed);
  if FState <> asLoading then
    FState := asAdded;
  if FStyle <> atTemporary then begin
    FStyle := atPrivate;
    Exclude(FFlags, dfRefManaged);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Apply;
var
  oIni: TCustomIniFile;
begin
  if (FStyle = atPersistent) and (FState <> asLoaded) then begin
    oIni := DefinitionList.CreateIniFile;
    try
      WriteTo(oIni, True);
    finally
      ADFree(oIni);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Cancel;
var
  oIni: TCustomIniFile;
begin
  CheckRO(dfModifyDisabled);
  if (FStyle = atPrivate) or
     (FStyle = atPersistent) and (FState = asAdded) then begin
    DefinitionList.InternalDelete(Self);
    Exit;
  end
  else if (FStyle = atPersistent) and (FState <> asLoaded) then begin
    SetName(FOriginalName);
    oIni := DefinitionList.CreateIniFile;
    try
      if oIni.SectionExists(FOriginalName) then
        ReadFrom(oIni);
    finally
      ADFree(oIni);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Delete;
begin
  CheckRO(dfDeleteDisabled);
  if (FStyle = atPrivate) or
     (FStyle = atPersistent) and (FState = asAdded) then
    Cancel
  else
    FState := asDeleted;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.MarkPersistent;
begin
  if (DefinitionList = nil) or (GetName = '') then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefCantMakePers, []);
  FStyle := atPersistent;
  Exclude(FFlags, dfRefManaged);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.MarkUnchanged;
begin
  if FStyle = atPersistent then
    case FState of
    asAdded,
    asModified:
      begin
        FOriginalName := GetName;
        FState := asLoaded;
      end;
    asDeleted:
      DefinitionList.InternalDelete(Self);
    end;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.HasValue(const AName: String): Boolean;
var
  iLevel: Integer;
begin
  iLevel := 0;
  Result := HasValue(AName, iLevel);
end;

{-------------------------------------------------------------------------------}
function TADDefinition.HasValue(const AName: String; var ALevel: Integer): Boolean;
var
  i: Integer;
  s: String;
begin
  Result := False;
  i := FParams.IndexOfName(AName);
  if i = -1 then begin
    if GetParentDefinition <> nil then begin
      Inc(ALevel);
      Result := GetParentDefinition.HasValue(AName, ALevel);
    end;
    if not Result then
      ALevel := $7FFFFFFF;
  end
  else begin
    s := ADValueFromIndex(FParams, i);
    if (s <> '') and ((s[1] <= ' ') or (s[Length(s)] <= ' ')) then
      s := Trim(s);
    Result := (s <> '');
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.OwnValue(const AName: String): Boolean;
begin
  Result := (FParams.IndexOfName(AName) <> -1);
end;

{-------------------------------------------------------------------------------}
function TADDefinition.IsSpecified(const AName: String): Boolean;
var
  i, iLevel: Integer;
begin
  i := FParams.IndexOfName(AName);
  if i > -1 then
    Result := True
  else if GetParentDefinition <> nil then begin
    iLevel := 1;
    Result := GetParentDefinition.HasValue(AName, iLevel);
  end
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.ToggleUpdates(APassCode: LongWord; ADisableDelete, ADisableModify: Boolean);

  procedure SetFlags;
  begin
    if ADisableDelete then
      Include(FFlags, dfDeleteDisabled)
    else
      Exclude(FFlags, dfDeleteDisabled);
    if ADisableModify then
      Include(FFlags, dfModifyDisabled)
    else
      Exclude(FFlags, dfModifyDisabled);
  end;

begin
  if FPassCode = 0 then begin
    if ADisableDelete or ADisableModify then begin
      FPassCode := APassCode;
      SetFlags;
    end;
  end
  else if FPassCode <> APassCode then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefRO, ['unprotect', GetName])
  else begin
    SetFlags;
    if not ADisableDelete and not ADisableModify then
      FPassCode := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetUpdatable: Boolean;
begin
  Result := FPassCode = 0;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetAsString(const AName: String): String;
var
  i: Integer;
begin
  Result := '';
  i := FParams.IndexOfName(AName);
  if i = -1 then begin
    if GetParentDefinition <> nil then
      Result := GetParentDefinition.GetAsString(AName);
  end
  else begin
    Result := ADValueFromIndex(FParams, i);
    if (Result <> '') and ((Result[1] <= ' ') or (Result[Length(Result)] <= ' ')) then
      Result := Trim(Result);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetAsXString(const AName: String): String;
var
  sName: String;
begin
  sName := AName;
{$IFDEF MSWINDOWS}
  {$IFDEF AnyDAC_32}
  sName := sName + S_AD_Win32;
  {$ENDIF}
  {$IFDEF AnyDAC_64}
  sName := sName + S_AD_Win64;
  {$ENDIF}
{$ENDIF}
{$IFDEF MACOS}
  {$IFDEF AnyDAC_32}
  sName := sName + S_AD_OSX32;
  {$ENDIF}
  {$IFDEF AnyDAC_64}
  sName := sName + S_AD_OSX64;
  {$ENDIF}
{$ENDIF}
{$IFDEF UNIX}
  {$IFNDEF MACOS}
    {$IFDEF AnyDAC_32}
  sName := sName + S_AD_UIX32;
    {$ENDIF}
    {$IFDEF AnyDAC_64}
  sName := sName + S_AD_UIX64;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  if IsSpecified(sName) then
    Result := GetAsString(sName)
  else
    Result := GetAsString(AName);
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetAsBoolean(const AName: String): LongBool;
var
  s: String;
begin
  s := GetAsString(AName);
  Result := (Length(s) > 0) and (
    (s[1] = 'Y') or (s[1] = 'y') or (s[1] = 'T') or (s[1] = 't'));
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetAsInteger(const AName: String): LongInt;
begin
  Result := StrToIntDef(GetAsString(AName), 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetAsString(const AName, AValue: String);
var
  sVal: String;
  i: Integer;
begin
  CheckRO(dfModifyDisabled);
  sVal := Trim(AValue);
  if GetAsString(AName) <> sVal then begin
    FParams.BeginUpdate;
    try
      if GetParentDefinition <> nil then
        if AnsiCompareText(GetParentDefinition.GetAsString(AName), sVal) = 0 then begin
          i := FParams.IndexOfName(AName);
          if i <> -1 then
            FParams.Delete(i);
        end
        else
          FParams.Values[AName] := sVal
      else
        FParams.Values[AName] := sVal;
    finally
      FParams.EndUpdate;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetAsBoolean(const AName: String; const AValue: LongBool);
begin
  if GetAsBoolean(AName) <> AValue then
    if AValue then
      SetAsString(AName, S_AD_True)
    else
      SetAsString(AName, S_AD_False);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetAsYesNo(const AName: String; const AValue: LongBool);
begin
  if GetAsBoolean(AName) <> AValue then
    if AValue then
      SetAsString(AName, S_AD_Yes)
    else
      SetAsString(AName, S_AD_No);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetAsInteger(const AName: String; const AValue: LongInt);
begin
  if GetAsInteger(AName) <> AValue then
    SetAsString(AName, IntToStr(AValue));
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetName: String;
begin
  Result := GetAsString(S_AD_DefinitionParam_Common_Name);
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetName(const AValue: string);
begin
  SetAsString(S_AD_DefinitionParam_Common_Name, AValue);
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetParams: TStrings;
begin
  Result := FParams;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetParams(const AValue: TStrings);
begin
  CheckRO(dfModifyDisabled);
  FParams.Assign(AValue);
  Normalize;
  Migrate;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetParentDefinition: IADStanDefinition;
begin
  UpdateParentDefinition;
  Result := FParentDefinition;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetState: TADDefinitionState;
begin
  Result := FState;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetStyle: TADDefinitionStyle;
begin
  Result := FStyle;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetOnChanged: TNotifyEvent;
begin
  Result := FOnChanged;
end;

{-------------------------------------------------------------------------------}
function TADDefinition.GetOnChanging: TNotifyEvent;
begin
  Result := FOnChanging;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetOnChanged(AValue: TNotifyEvent);
begin
  FOnChanged := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.SetOnChanging(AValue: TNotifyEvent);
begin
  FOnChanging := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.ReadFrom(AReader: TCustomIniFile);
var
  sName: String;
  lLoaded: Boolean;
begin
  CheckRO(dfModifyDisabled);
  sName := GetName;
  FState := asLoading;
  lLoaded := False;
  try
    Clear;
    if AReader.SectionExists(sName) then
      try
        AReader.ReadSectionValues(sName, FParams);
        Normalize;
        Migrate;
        FStyle := atPersistent;
        Exclude(FFlags, dfRefManaged);
        FOriginalName := sName;
        lLoaded := True;
      except
        Clear;
        raise;
      end;
  finally
    SetName(sName);
    if lLoaded then
      FState := asLoaded
    else
      FState := asAdded;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.WriteTo(AWriter: TCustomIniFile; AIfModified: Boolean = True);
var
  sName: String;
  sOrigName: String;

  procedure DeleteOldSection;
  begin
    if (sOrigName <> '') and AWriter.SectionExists(sOrigName) then
      AWriter.EraseSection(sOrigName);
  end;

  procedure WriteNewSection;
  var
    i: Integer;
  begin
    for i := 0 to FParams.Count - 1 do
      if CompareText(ADNameFromIndex(FParams, i), S_AD_DefinitionParam_Common_Name) <> 0 then
        AWriter.WriteString(sName, ADNameFromIndex(FParams, i), ADValueFromIndex(FParams, i));
  end;

begin
  if FStyle = atPersistent then begin
    sName := GetName;
    sOrigName := FOriginalName;
    case FState of
    asLoaded:
      if not AIfModified then
        WriteNewSection;
    asModified:
      begin
        DeleteOldSection;
        WriteNewSection;
        FState := asLoaded;
      end;
    asDeleted:
      begin
        DeleteOldSection;
        DefinitionList.InternalDelete(Self);
      end;
    asAdded:
      begin
        WriteNewSection;
        FState := asLoaded;
      end;
    end;
    FOriginalName := sName;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TADDefinition.BaseTrace(const AMonitor: IADMoniClient);
var
  i: Integer;
  sName, s: String;
begin
  if GetParentDefinition <> nil then
    GetParentDefinition.BaseTrace(AMonitor);
  for i := 0 to FParams.Count - 1 do begin
    sName := ADNameFromIndex(FParams, i);
    if AnsiCompareText(sName, S_AD_ConnParam_Common_Password) = 0 then
      s := S_AD_ConnParam_Common_Password + '=*****'
    else if AnsiCompareText(sName, S_AD_ConnParam_Common_NewPassword) = 0 then
      s := S_AD_ConnParam_Common_NewPassword + '=*****'
    else
      s := FParams[i];
    AMonitor.Notify(ekConnService, esProgress, Self, s, []);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinition.Trace(const AMonitor: IADMoniClient);
begin
  if (AMonitor <> nil) and AMonitor.Tracing then begin
    AMonitor.Notify(ekConnService, esStart, Self, 'Definition', ['Name', GetName]);
    BaseTrace(AMonitor);
    AMonitor.Notify(ekConnService, esEnd, Self, 'Definition', ['Name', GetName]);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADDefinitionTemporaryFactory                                                 }
{-------------------------------------------------------------------------------}
constructor TADDefinitionTemporaryFactory.Create;
begin
  inherited Create(nil, IADStanDefinition);
end;

{-------------------------------------------------------------------------------}
function TADDefinitionTemporaryFactory.CreateObject: TObject;
begin
  Result := TADDefinition.CreateTemporary;
end;

{-------------------------------------------------------------------------------}
{- TADDefinitions                                                              -}
{-------------------------------------------------------------------------------}
procedure TADDefinitions.Initialize;
begin
  inherited Initialize;
  FAutoLoad := True;
  FState := dsNotLoaded;
  ADCreateInterface(IADStanDefinitionStorage, FStorage);
  FList := TADDefinitionCollection.Create(Self, GetItemClass);
  FLock := TADMREWSynchronizer.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDefinitions.Destroy;
begin
  FState := dsNotLoaded;
  FStorage := nil;
  ADFreeAndNil(FList);
  ADFreeAndNil(FLock);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetItemClass: TADDefinitionClass;
begin
  Result := TADDefinition;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.CreateIniFile: TCustomIniFile;
begin
  Result := FStorage.CreateIniFile;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.CheckLoaded;
begin
  if (FState = dsNotLoaded) and FAutoLoad then
    Load;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetLoaded: Boolean;
begin
  Result := (FState = dsLoaded);
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetAutoLoad: Boolean;
begin
  Result := FAutoLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.SetAutoLoad(AValue: Boolean);
begin
  FAutoLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetStorage: IADStanDefinitionStorage;
begin
  Result := FStorage;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetAfterLoad: TNotifyEvent;
begin
  Result := FAfterLoad;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetBeforeLoad: TNotifyEvent;
begin
  Result := FBeforeLoad;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetName: String;
begin
  Result := FName;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.SetAfterLoad(AValue: TNotifyEvent);
begin
  FAfterLoad := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.SetBeforeLoad(AValue: TNotifyEvent);
begin
  FBeforeLoad := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.SetName(const AValue: String);
begin
  FName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.InternalAdd: TADDefinition;
begin
  BeginWrite;
  try
    CheckLoaded;
    Result := TADDefinition(FList.Add);
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.Add: IADStanDefinition;
begin
  Result := InternalAdd as IADStanDefinition;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.AddTemporary: IADStanDefinition;
begin
  Result := GetItemClass.CreateTemporary as IADStanDefinition;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.InternalDelete(ADefinition: TADDefinition);
var
  i: Integer;
  oDef: IADStanDefinition;
begin
  BeginWrite;
  try
    oDef := ADefinition as IADStanDefinition;
    for i := 0 to FList.Count - 1 do
      if TADDefinition(FList.Items[i]).GetParentDefinition = oDef then
        TADDefinition(FList.Items[i]).SetParentDefinition(nil);
    Include(ADefinition.FFlags, dfRefManaged);
    if ADefinition.FRefCount = 0 then
      ADFree(ADefinition);
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.Cancel;
var
  i: Integer;
begin
  BeginWrite;
  try
    for i := FList.Count - 1 downto 0 do
      TADDefinition(FList.Items[i]).Cancel;
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.Save(AIfModified: Boolean = True);
var
  i: Integer;
  oIni: TCustomIniFile;
begin
  BeginWrite;
  try
    oIni := CreateIniFile;
    try
      if GetName <> '' then
        oIni.WriteString(GetName, 'Encoding', 'UTF8');
      for i := FList.Count - 1 downto 0 do
        TADDefinition(FList.Items[i]).WriteTo(oIni, AIfModified);
    finally
      ADFree(oIni);
    end;
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.Load: Boolean;
var
  oList: TADStringList;
  oIni: TCustomIniFile;
  i: Integer;
  oDefinition: TADDefinition;
begin
  BeginWrite;
  try
    if FState <> dsNotLoaded then
      ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefAlreadyLoaded, []);
    FState := dsLoading;
    Result := False;
    try
      if Assigned(FBeforeLoad) then
        FBeforeLoad(Self);
      oList := TADStringList.Create;
      try
{$IFDEF AnyDAC_D6Base}
        oList.CaseSensitive := False;
{$ENDIF}
        oIni := CreateIniFile;
        try
          if FileExists(GetStorage.ActualFileName) then begin
            Result := True;
            oIni.ReadSections(oList);
            oList.Sort;
            for i := 0 to oList.Count - 1 do
              if (GetName = '') or (CompareText(oList[i], GetName) <> 0) then begin
                oDefinition := InternalAdd;
                oDefinition.SetName(oList[i]);
                oDefinition.ReadFrom(oIni);
              end;
          end;
        finally
          ADFree(oIni);
        end;
      finally
        ADFree(oList);
      end;
    finally
      FState := dsLoaded;
      if Assigned(FAfterLoad) then
        FAfterLoad(Self);
    end;
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.Clear;
var
  i: Integer;
begin
  BeginWrite;
  try
    for i := 0 to FList.Count - 1 do
      TADDefinition(FList.Items[i]).FParentDefinition := nil;
    FList.Clear;
    FState := dsNotLoaded;
  finally
    EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.InternalFindDefinition(const AName: String;
  AExclude: TADDefinition): TADDefinition;
var
  i: Integer;
  oDefinition: TADDefinition;
begin
  Result := nil;
  FLock.BeginRead;
  try
    CheckLoaded;
    for i := 0 to FList.Count - 1 do begin
      oDefinition := TADDefinition(FList.Items[i]);
      if (oDefinition <> AExclude) and (
         {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
         (oDefinition.GetName, AName) = 0) then begin
        Result := oDefinition;
        Break;
      end;
    end;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.FindDefinition(const AName: String): IADStanDefinition;
begin
  Result := InternalFindDefinition(AName, nil) as IADStanDefinition;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.DefinitionByName(const AName: String): IADStanDefinition;
begin
  Result := FindDefinition(AName);
  if Result = nil then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefNotExists,
      [AName, FStorage.ActualFilename]);
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.BuildUniqueName(const AName: String; AItem: TADDefinition): String;
var
  i: Integer;
begin
  Result := AName;
  i := 0;
  FLock.BeginRead;
  try
    while InternalFindDefinition(Result, AItem) <> nil do begin
      Inc(i);
      Result := AName + '_' + IntToStr(i);
    end;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.IsUniqueName(const AName: String; AItem: TADDefinition): Boolean;
begin
  Result := InternalFindDefinition(AName, AItem) = nil;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetCount: Integer;
begin
  FLock.BeginRead;
  try
    CheckLoaded;
    Result := FList.Count;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetItems(AIndex: Integer): IADStanDefinition;
begin
  FLock.BeginRead;
  try
    CheckLoaded;
    Result := TADDefinition(FList.Items[AIndex]) as IADStanDefinition;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.BeginRead;
begin
  FLock.BeginRead;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.EndRead;
begin
  FLock.EndRead;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.BeginWrite;
begin
  FLock.BeginWrite;
end;

{-------------------------------------------------------------------------------}
procedure TADDefinitions.EndWrite;
begin
  FLock.EndWrite;
end;

{-------------------------------------------------------------------------------}
function TADDefinitions.GetUpdatable: Boolean;
var
  i: Integer;
begin
  Result := True;
  BeginRead;
  try
    for i := 0 to FList.Count - 1 do
      if not TADDefinition(FList.Items[i]).GetUpdatable then begin
        Result := False;
        Break;
      end;
  finally
    EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADConnectionDef                                                            -}
{-------------------------------------------------------------------------------}
procedure TADConnectionDef.MarkPersistent;
begin
  if GetDriverID = '' then
    ADException(Self, [S_AD_LStan, S_AD_LStan_PDef], er_AD_DefCantMakePers, []);
  inherited MarkPersistent;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetPooled: Boolean;
begin
  Result := GetAsBoolean(S_AD_ConnParam_Common_Pooled);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetPooled(AValue: Boolean);
begin
  SetAsBoolean(S_AD_ConnParam_Common_Pooled, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetDriverID: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_DriverID);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetDriverID(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_DriverID, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetPassword: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_Password);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetPassword(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_Password, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetNewPassword: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_NewPassword);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetNewPassword(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_NewPassword, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetOSAuthent: Boolean;
begin
  Result := GetAsBoolean(S_AD_ConnParam_Common_OSAuthent);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetOSAuthent(const AValue: Boolean);
begin
  SetAsYesNo(S_AD_ConnParam_Common_OSAuthent, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetUserName: String;
var
  iLvlStd, iLvlBDE: Integer;
  lStd, lBde: Boolean;
begin
  iLvlStd := 0;
  iLvlBDE := 0;
  lStd := HasValue(S_AD_ConnParam_Common_UserName, iLvlStd);
  lBde := HasValue(S_AD_ConnParam_Common_BDEStyleUserName, iLvlBDE);
  if lStd or lBde then
    if iLvlStd < iLvlBDE then
      Result := GetAsString(S_AD_ConnParam_Common_UserName)
    else
      Result := GetAsString(S_AD_ConnParam_Common_BDEStyleUserName);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetUserName(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_UserName, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetDatabase: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_Database);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetDatabase(const AValue: String);
begin
  if Pos('=', AValue) = 0 then
    SetAsString(S_AD_ConnParam_Common_Database, AValue)
  else
    ParseString(AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetExpandedDatabase: String;
begin
  Result := ADExpandStr(GetDatabase);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetMonitorBy: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_MonitorBy);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetMonitorBy(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_MonitorBy, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetPort: Integer;
begin
  Result := GetAsInteger(S_AD_ConnParam_Common_Port);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetPortI(const AValue: Integer);
begin
  SetAsInteger(S_AD_ConnParam_Common_Port, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetServer: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_Server);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetServer(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_Server, AValue);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetMetaDefCatalog: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_MetaDefCatalog);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDef.GetMetaDefSchema: String;
begin
  Result := GetAsString(S_AD_ConnParam_Common_MetaDefSchema);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetMetaDefCatalog(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_MetaDefCatalog, AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.SetMetaDefSchema(const AValue: String);
begin
  SetAsString(S_AD_ConnParam_Common_MetaDefSchema, AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.ReadOptions(AFormatOptions: TObject;
  AUpdateOptions: TObject; AFetchOptions: TObject; AResourceOptions: TObject);
{$IFNDEF AnyDAC_FPC}
var
  oComp: TADOptsComponent;
  oMS: TMemoryStream;
  oStr: TStringStream;
  oRdr: TReader;
  i: Integer;
  s, sName: String;
  oDef: IADStanConnectionDef;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  s := 'object TADOptsComponent' + C_AD_EOL;
  oDef := Self as IADStanConnectionDef;
  while oDef <> nil do begin
    for i := 0 to oDef.Params.Count - 1 do begin
      sName := LowerCase(ADNameFromIndex(oDef.Params, i));
      if (Pos('fetchoptions.', sName) <> 0) or (Pos('formatoptions.', sName) <> 0) or
         (Pos('updateoptions.', sName) <> 0) or (Pos('resourceoptions.', sName) <> 0) then
        s := s + oDef.Params[i] + C_AD_EOL;
    end;
    oDef := oDef.ParentDefinition as IADStanConnectionDef;
  end;
  s := s + 'end';
  oComp := TADOptsComponent.Create(nil);
  try
    oComp.FetchOptions := AFetchOptions as TADFetchOptions;
    oComp.UpdateOptions := AUpdateOptions as TADUpdateOptions;
    oComp.FormatOptions := AFormatOptions as TADFormatOptions;
    oComp.ResourceOptions := AResourceOptions as TADResourceOptions;
    oStr := TStringStream.Create(s);
    try
      oMS := TMemoryStream.Create;
      oRdr := TReader.Create(oMS, 4096);
      try
        ObjectTextToBinary(oStr, oMS);
        oMS.Position := 0;
        oRdr.BeginReferences;
        try
          oRdr.ReadSignature;
          oRdr.ReadComponent(oComp);
        finally
          oRdr.EndReferences;
        end;
      finally
        ADFree(oRdr);
        ADFree(oMS);
      end;
    finally
      ADFree(oStr);
    end;
  finally
    ADFree(oComp);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDef.WriteOptions(AFormatOptions: TObject;
  AUpdateOptions: TObject; AFetchOptions: TObject; AResourceOptions: TObject);
{$IFNDEF AnyDAC_FPC}
var
  oComp: TADOptsComponent;
  oMS: TMemoryStream;
  oStr: TStringStream;
  i: Integer;
  pCh, pStart, pEnd, pWS: PChar;
  lValue, lCollection: Boolean;
  s, sName: String;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  oComp := TADOptsComponent.Create(nil);
  try
    oComp.FetchOptions := AFetchOptions as TADFetchOptions;
    oComp.UpdateOptions := AUpdateOptions as TADUpdateOptions;
    oComp.FormatOptions := AFormatOptions as TADFormatOptions;
    oComp.ResourceOptions := AResourceOptions as TADResourceOptions;
    oMS := TMemoryStream.Create;
    try
      oMS.WriteComponent(oComp);
      oStr := TStringStream.Create('');
      try
        oMS.Position := 0;
        ObjectBinaryToText(oMS, oStr);
        s := oStr.DataString;
        pCh := PChar(s);
        while pCh^ <> #13 do
          Inc(pCh);
        pEnd := PChar(s) + Length(s) - 1;
        for i := 1 to 2 do begin
          while pEnd^ <> #13 do
            Dec(pEnd);
          if i <> 2 then
            Dec(pEnd)
          else
            Inc(pEnd)
        end;
        lValue := False;
        lCollection := False;
        Inc(pCh, 2);
        pStart := pCh;
        while pCh <= pEnd do begin
          if lCollection then begin
            if pCh^ = '>' then
              lCollection := False
            else if pCh^ = #13 then begin
              pCh^ := ' ';
              (pCh + 1)^ := ' ';
            end;
            if pCh^ = ' ' then begin
              pWS := pCh;
              while pCh^ = ' ' do
                Inc(pCh);
              if pCh - pWS > 1 then begin
                Move(pCh^, (pWS + 1)^, (pEnd - pCh + 1) * SizeOf(Char));
                Dec(pEnd, pCh - pWS - 1);
                Dec(pCh, pCh - pWS - 1);
              end;
            end
            else
              Inc(pCh);
          end
          else begin
            if (pCh^ = ' ') and not lValue then begin
              Move((pCh + 1)^, pCh^, (pEnd - pCh) * SizeOf(Char));
              Dec(pEnd);
            end
            else begin
              if pCh^ = '=' then
                lValue := True
              else if pCh^ = #10 then
                lValue := False
              else if pCh^ = '<' then
                lCollection := True;
              Inc(pCh);
            end;
          end;
        end;
        if pEnd - pStart - 1 > 0 then
          SetString(s, pStart, pEnd - pStart - 1)
        else
          s := '';
        i := 0;
        while i < GetParams.Count do begin
          sName := ADNameFromIndex(GetParams, i);
          if (CompareText(sName, 'FetchOptions') = 0) or (CompareText(sName, 'FormatOptions') = 0) or
             (CompareText(sName, 'UpdateOptions') = 0) or (CompareText(sName, 'ResourceOptions') = 0) then
            GetParams.Delete(i)
          else
            Inc(i);
        end;
        if s <> '' then
          GetParams.Text := GetParams.Text + s;
      finally
        ADFree(oStr);
      end;
    finally
      ADFree(oMS);
    end;
  finally
    ADFree(oComp);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ TADConnectionDefTemporaryFactory                                              }
{-------------------------------------------------------------------------------}
constructor TADConnectionDefTemporaryFactory.Create;
begin
  inherited Create(nil, IADStanConnectionDef);
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefTemporaryFactory.CreateObject: TObject;
begin
  Result := TADConnectionDef.CreateTemporary;
end;

{-------------------------------------------------------------------------------}
{- TADConnectionDefs                                                           -}
{-------------------------------------------------------------------------------}
procedure TADConnectionDefs.Initialize;
begin
  inherited Initialize;
  SetName(S_AD_DefCfgFileName);
  GetStorage.DefaultFileName := S_AD_DefCfgFileName;
  GetStorage.GlobalFileName := ADLoadConnDefGlobalFileName;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.GetItemClass: TADDefinitionClass;
begin
  Result := TADConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.AddConnectionDef: IADStanConnectionDef;
begin
  Result := inherited Add as IADStanConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.FindConnectionDef(const AName: String): IADStanConnectionDef;
begin
  Result := inherited FindDefinition(AName) as IADStanConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.ConnectionDefByName(const AName: String): IADStanConnectionDef;
begin
  Result := inherited DefinitionByName(AName) as IADStanConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADConnectionDefs.GetConnectionDefs(AIndex: Integer): IADStanConnectionDef;
begin
  Result := inherited GetItems(AIndex) as IADStanConnectionDef;
end;

{-------------------------------------------------------------------------------}
procedure ADSaveConnDefGlobalFileName(const AName: String);
begin
  ADWriteRegValue(S_AD_CfgValName, AName);
end;

{-------------------------------------------------------------------------------}
function ADLoadConnDefGlobalFileName: String;
begin
  Result := ADReadRegValue(S_AD_CfgValName);
end;

{-------------------------------------------------------------------------------}
procedure ADSaveDriverDefGlobalFileName(const AName: String);
begin
  ADWriteRegValue(S_AD_DrvValName, AName);
end;

{-------------------------------------------------------------------------------}
function ADLoadDriverDefGlobalFileName: String;
begin
  Result := ADReadRegValue(S_AD_DrvValName);
end;

{-------------------------------------------------------------------------------}
var
  oFact1,
  oFact2,
  oFact3,
  oFact4,
  oFact5: TADFactory;

initialization
  oFact1 := TADMultyInstanceFactory.Create(TADFileDefinitionStorage, IADStanDefinitionStorage);
  oFact2 := TADDefinitionTemporaryFactory.Create;
  oFact3 := TADMultyInstanceFactory.Create(TADDefinitions, IADStanDefinitions);
  oFact4 := TADConnectionDefTemporaryFactory.Create;
  oFact5 := TADMultyInstanceFactory.Create(TADConnectionDefs, IADStanConnectionDefs);

finalization
  ADReleaseFactory(oFact1);
  ADReleaseFactory(oFact2);
  ADReleaseFactory(oFact3);
  ADReleaseFactory(oFact4);
  ADReleaseFactory(oFact5);

end.


