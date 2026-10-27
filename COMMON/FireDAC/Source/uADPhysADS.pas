{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{       FireDAC Advantage Database Server driver        }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysADS"'}

{ TODO -cADS : Array DML }

unit uADPhysADS;

interface

uses
  SysUtils, Classes,
  uADStanIntf, uADDatSManager,
  uADPhysIntf, uADPhysManager,
  uADPhysADSWrapper;

type
  TADPhysADSDriverLink = class;
  TADADSService = class;
  TADADSBackupRestore = class;
  TADADSBackup = class;
  TADADSRestore = class;
  TADADSUtility = class;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TADPhysADSDriverLink = class(TADPhysDriverLink)
  private
    FDateFormat: String;
    FDecimals: Integer;
    FDefaultPath: String;
    FSearchPath: String;
    FShowDeleted: Boolean;
    FEpoch: Word;
    FExact: Boolean;
    function GetDateFormat: String;
    function GetDecimals: Word;
    function GetDefaultPath: String;
    function GetEpoch: Word;
    function GetExact: Boolean;
    function GetSearchPath: String;
    function GetShowDeleted: Boolean;
    procedure SetDateFormat(const AValue: String);
    procedure SetDecimals(const AValue: Word);
    procedure SetDefaultPath(const AValue: String);
    procedure SetEpoch(const AValue: Word);
    procedure SetExact(const AValue: Boolean);
    procedure SetSearchPath(const AValue: String);
    procedure SetShowDeleted(const AValue: Boolean);
    function IsDFS: Boolean;
    function IsDS: Boolean;
    function IsDPS: Boolean;
    function IsEpS: Boolean;
    function IsExS: Boolean;
    function IsSDS: Boolean;
    function IsSPS: Boolean;
  protected
    function GetBaseDriverID: String; override;
    function IsConfigured: Boolean; override;
    procedure ApplyTo(const AParams: IADStanDefinition); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property DateFormat: String read GetDateFormat write SetDateFormat stored IsDFS;
    property Decimals: Word read GetDecimals write SetDecimals stored IsDS;
    property DefaultPath: String read GetDefaultPath write SetDefaultPath stored IsDPS;
    property SearchPath: String read GetSearchPath write SetSearchPath stored IsSPS;
    property ShowDeleted: Boolean read GetShowDeleted write SetShowDeleted stored IsSDS;
    property Epoch: Word read GetEpoch write SetEpoch stored IsEpS;
    property Exact: Boolean read GetExact write SetExact stored IsExS;
  end;

  TADADSService = class (TADPhysDriverService)
  private
    FPassword: String;
    FUserName: String;
    FDatabase: String;
    function GetDriverLink: TADPhysADSDriverLink;
    procedure SetDriverLink(const AValue: TADPhysADSDriverLink);
    procedure GetConnection(out AConn: IADPhysConnection; out ACmd: IADPhysCommand);
  published
    property DriverLink: TADPhysADSDriverLink read GetDriverLink write SetDriverLink;
    property Database: String read FDatabase write FDatabase;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
  end;

  TADADSBackupRestore = class(TADADSService)
  private
    FInclude: TStrings;
    FExclude: TStrings;
    FTableTypeMap: TStrings;
    FResults: TADDatSTable;
    procedure SetInclude(const AValue: TStrings);
    procedure SetExclude(const AValue: TStrings);
    procedure SetTableTypeMap(const AValue: TStrings);
    procedure AddOption(var AStr: String; const AName, AValue: String);
  protected
    function GetOptions: String; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Results: TADDatSTable read FResults;
  published
    property Include: TStrings read FInclude write SetInclude;
    property Exclude: TStrings read FExclude write SetExclude;
    property TableTypeMap: TStrings read FTableTypeMap write SetTableTypeMap;
  end;

  TADADSBackupOptions = set of (boDontOverwrite, boMetaOnly, boPrepareDiff, boDiff);
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TADADSBackup = class(TADADSBackupRestore)
  private
    FBackupPath: String;
    FOptions: TADADSBackupOptions;
  protected
    procedure InternalExecute; override;
    function GetOptions: String; override;
  public
    procedure Backup;
  published
    property BackupPath: String read FBackupPath write FBackupPath;
    property Options: TADADSBackupOptions read FOptions write FOptions default [];
  end;

  TADADSRestoreOptions = set of (roDontOverwrite, roMetaOnly);
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TADADSRestore = class(TADADSBackupRestore)
  private
    FSourcePath: String;
    FSourcePassword: String;
    FDestinationPath: String;
    FDDPassword: String;
    FOptions: TADADSRestoreOptions;
  protected
    procedure InternalExecute; override;
    function GetOptions: String; override;
  public
    procedure Restore;
  published
    property SourcePath: String read FSourcePath write FSourcePath;
    property SourcePassword: String read FSourcePassword write FSourcePassword;
    property DestinationPath: String read FDestinationPath write FDestinationPath;
    property DDPassword: String read FDDPassword write FDDPassword;
    property Options: TADADSRestoreOptions read FOptions write FOptions default [];
  end;

  TADADSUtilityMode = (umEncrypt, umDecrypt, umPack, umZap, umReindex, umRecall);
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TADADSUtility = class(TADADSService)
  private
    FTables: TStrings;
    FMode: TADADSUtilityMode;
    FOnProgress: TADPhysServiceProgressEvent;
    FTableType: TADSTableType;
    FTablePassword: String;
    procedure SetTables(const AValue: TStrings);
  protected
    procedure InternalExecute; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Encrypt;
    procedure Decrypt;
    procedure Pack;
    procedure Zap;
    procedure Reindex;
    procedure Recall;
  published
    property Tables: TStrings read FTables write SetTables;
    property TableType: TADSTableType read FTableType write FTableType default ttDefault;
    property TablePassword: String read FTablePassword write FTablePassword;
    property OnProgress: TADPhysServiceProgressEvent read FOnProgress write FOnProgress;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}  
{$IFDEF AnyDAC_D6Base}
  Variants, StrUtils,
{$ENDIF}
  DB,
  uADStanConst, uADStanError, uADStanUtil, uADStanOption, uADStanParam,
    uADStanFactory,
  uADPhysCmdGenerator, uADPhysADSCli, uADPhysADSMeta;

type
  TADPhysADSDriver = class;
  TADPhysADSConnection = class;
  TADPhysADSTransaction = class;
  TADPhysADSEventAlerter = class;
  TADPhysADSCommand = class;

  TADPhysADSCliHandles = array [0..0] of TADNativeUInt;
  PADPhysADSCliHandles = ^TADPhysADSCliHandles;

  TADPhysADSDriver = class(TADPhysDriver)
  private
    FLib: TADSLib;
  protected
    class function GetBaseDriverID: String; override;
    procedure InternalLoad; override;
    procedure InternalUnload; override;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; override;
    function GetCliObj: Pointer; override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer;
      var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  public
    constructor Create(AManager: TADPhysManager; const ADriverDef: IADStanDefinition); override;
    destructor Destroy; override;
  end;

  TADPhysADSConnection = class (TADPhysConnection)
  private
    FConnection: TADSConnection;
    FDictionary: TADSDictionary;
    FServerVersion: TADVersion;
    FCliHandles: TADPhysADSCliHandles;
    FAliasPath: String;
    FAliasTableType: String;
    FSharedStmt: TADSStatement;
    function BuildServerTypes(const AConnDef: IADStanConnectionDef): Integer;
    function BuildConnectionPath(const AConnDef: IADStanConnectionDef): String;
    function Build60Options(const AConnDef: IADStanConnectionDef): Integer;
    function BuildADS101ConnectString(const AConnDef: IADStanConnectionDef): String;
    procedure BaseConnect(AConn: TADSConnection; const AConnDef: IADStanConnectionDef);
  protected
    procedure InternalConnect; override;
    procedure InternalSetMeta; override;
    procedure InternalDisconnect; override;
    procedure InternalPing; override;
    procedure InternalChangePassword(const AUserName, AOldPassword, ANewPassword: String); override;
    function InternalCreateTransaction: TADPhysTransaction; override;
    function InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter; override;
    function InternalCreateCommand: TADPhysCommand; override;
    function InternalCreateMetadata: TObject; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand): TADPhysCommandGenerator; override;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; override;
{$ENDIF}
    procedure InternalExecuteDirect(const ASQL: String; ATransaction: TADPhysTransaction); override;
    procedure GetItem(AIndex: Integer; out AName: String;
      out AValue: Variant; out AKind: TADMoniAdapterItemKind); override;
    function GetItemCount: Integer; override;
    function GetMessages: EADDBEngineException; override;
    function GetCliObj: Pointer; override;
    function InternalGetCliHandle: Pointer; override;
    function GetLastAutoGenValue(const AName: String): Variant; override;
    procedure InternalAnalyzeSession(AMessages: TStrings); override;
  public
    constructor Create(ADriverObj: TADPhysDriver; AConnHost: TADPhysConnectionHost); override;
    destructor Destroy; override;
  end;

  TADPhysADSTransaction = class(TADPhysTransaction)
  protected
    procedure InternalStartTransaction(ATxID: LongWord); override;
    procedure InternalCommit(ATxID: LongWord); override;
    procedure InternalRollback(ATxID: LongWord); override;
    procedure InternalChanged; override;
    procedure InternalCheckState(ACommandObj: TADPhysCommand; ASuccess: Boolean); override;
    procedure InternalNotify(ANotification: TADPhysTxNotification; ACommandObj: TADPhysCommand); override;
  end;

  TADPhysADSEventAlerter = class(TADPhysEventAlerter)
  private
    FWaitThread: TThread;
    FWaitConnection: IADPhysConnection;
    FWaitCommand: IADPhysCommand;
    FTab: TADDatSTable;
    procedure DoFired;
  protected
    // TADPhysEventAlerter
    procedure InternalAllocHandle; override;
    procedure InternalRegister; override;
    procedure InternalHandle(AEventMessage: TADPhysEventMessage); override;
    procedure InternalAbortJob; override;
    procedure InternalUnregister; override;
    procedure InternalReleaseHandle; override;
    procedure InternalSignal(const AEvent: String; const AArgument: Variant); override;
  end;

  PADAdsParInfoRec = ^TADAdsParInfoRec;
  PADAdsColInfoRec = ^TADAdsColInfoRec;

  TADAdsParInfoRec = record
    FAdsParamIndex: Integer;
    FParamIndex: Integer;
    FOutSQLDataType: Word;
    FDestDataType: TADDataType;
    FSrcDataType: TADDataType;
    FOutDataType: TADDataType;
    FSrcFieldType: TFieldType;
    FSrcSize: LongWord;
    FSrcPrec: Integer;
    FSrcScale: Integer;
    FParamType: TParamType;
  end;

  TADAdsColInfoRec = record
    FName: String;
    FPos: Integer;
    FLen: LongWord;
    FPrec,
    FScale: Integer;
    FSrcSQLDataType,
    FSrcSQLMemoType: Word;
    FSrcDataType,
    FDestDataType: TADDataType;
    FAttrs: TADDataAttributes;
    FVar: TADSVariable;
    FADLen: LongWord;
    FInPK: WordBool;
  end;

  TADPhysADSCommand = class(TADPhysCommand)
  private
    FStmt: TADSStatement;
    FCursor: TADSCursor;
    FParInfos: array of TADAdsParInfoRec;
    FColInfos: array of TADAdsColInfoRec;
    FColIndex: Integer;
    FMetainfoAddonView: TADDatSView;
    FMetaEncoder: TADEncoder;
    function GetConnection: TADPhysADSConnection;
    function UseExecDirect: Boolean;
    procedure SetupStatement(AStmt: TADSStatement);
    procedure SetupCursor(ACrs: TADSCursor);
    function ADType2SQL(AType: TADDataType): Word;
    procedure SQL2ADColInfo(ASQLType, ASQLMemoType: Word; ASQLLen: LongWord; ASQLPrec,
      ASQLScale: Word; out AType: TADDataType; var AAttrs: TADDataAttributes;
      out ALen: LongWord; out APrec, AScale: Integer;
      AFmtOpts: TADFormatOptions);
    procedure CreateParamInfos;
    procedure DestroyParamInfos;
    procedure CreateColInfos;
    procedure DestroyColInfos;
    procedure SetParamValue(AFmtOpts: TADFormatOptions; AParam: TADParam;
      AAdsParam: TADSVariable; ApInfo: PADAdsParInfoRec; AArrIndex: Integer);
    procedure SetParamValues(AArrIndex: Integer = 0);
    procedure FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    function FetchMetaRow(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowNo: Integer): Boolean;
    procedure GetParamValues(AArrIndex: Integer = 0);
    function AllocStatement: TADSStatement;
    procedure ReleaseStatement(var AStmt: TADSStatement);
  protected
    procedure InternalAbort; override;
    procedure InternalClose; override;
    procedure InternalExecute(ATimes: LongInt; AOffset: LongInt; var ACount: TADCounter); override;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; override;
    function InternalOpen: Boolean; override;
    function InternalNextRecordSet: Boolean; override;
    procedure InternalPrepare; override;
    function InternalUseStandardMetadata: Boolean; override;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; override;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; override;
    procedure InternalUnprepare; override;
    function GetCliObj: Pointer; override;
  public
    constructor Create(AConnection: TADPhysConnection);
    destructor Destroy; override;
    property ADSConnection: TADPhysADSConnection read GetConnection;
    property ADSStatement: TADSStatement read FStmt;
  end;

const
  S_AD_UDP = 'UDP';
  S_AD_IPX = 'IPX';
  S_AD_TCPIP = 'TCPIP';
  S_AD_TLS = 'TLS';

  S_AD_Remote = 'Remote';
  S_AD_Local = 'Local';
  S_AD_Internet = 'Internet';

  // S_AD_Internet
  S_AD_Always = 'Always';
  S_AD_Never = 'Never';

  S_AD_ADT = 'ADT';
  S_AD_VFP = 'VFP';
  S_AD_CDX = 'CDX';
  S_AD_NTX = 'NTX';

  S_AD_Proprietary = 'Proprietary';
  S_AD_Compatible = 'Compatible';

  C_AdsCharTypeMap = 'ANSI;OEM';

{-------------------------------------------------------------------------------}
{ TADPhysADSDriverLink                                                          }
{-------------------------------------------------------------------------------}
const
  C_DefDateFormat = 'MM/DD/YYYY';
  C_DefDecimals = 2;
  C_DefShowDeleted = True;
  C_DefEpoch = 1900;
  C_DefExact = False;

constructor TADPhysADSDriverLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDateFormat := C_DefDateFormat;
  FDecimals := C_DefDecimals;
  FShowDeleted := C_DefShowDeleted;
  FEpoch := C_DefEpoch;
  FExact := C_DefExact;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_ADSId;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriverLink.ApplyTo(const AParams: IADStanDefinition);
begin
  inherited ApplyTo(AParams);
  if IsDFS then
    AParams.AsString[S_AD_ConnParam_ADS_DateFormat] := DateFormat;
  if IsDS then
    AParams.AsInteger[S_AD_ConnParam_ADS_Decimals] := Decimals;
  if IsDPS then
    AParams.AsString[S_AD_ConnParam_ADS_DefaultPath] := DefaultPath;
  if IsSPS then
    AParams.AsString[S_AD_ConnParam_ADS_SearchPath] := SearchPath;
  if IsSDS then
    AParams.AsString[S_AD_ConnParam_ADS_ShowDeleted] := S_AD_Bools[ShowDeleted];
  if IsEpS then
    AParams.AsInteger[S_AD_ConnParam_ADS_Epoch] := Epoch;
  if IsExS then
    AParams.AsString[S_AD_ConnParam_ADS_Exact] := S_AD_Bools[Exact];
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.IsConfigured: Boolean;
begin
  Result := inherited IsConfigured or IsDFS or IsDS or IsDPS or IsSPS or
    IsSDS or IsEpS or IsExS;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.GetDateFormat: String;
begin
  if DriverState in [drsLoaded, drsActive] then
    Result := TADSLib(DriverIntf.CliObj).DateFormat
  else
    Result := FDateFormat;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriverLink.SetDateFormat(const AValue: String);
begin
  FDateFormat := AValue;
  if DriverState in [drsLoaded, drsActive] then
    TADSLib(DriverIntf.CliObj).DateFormat := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.IsDFS: Boolean;
begin
  Result := (FDateFormat <> '') and (FDateFormat <> C_DefDateFormat);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.GetDecimals: Word;
begin
  if DriverState in [drsLoaded, drsActive] then
    Result := TADSLib(DriverIntf.CliObj).Decimals
  else
    Result := FDecimals;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriverLink.SetDecimals(const AValue: Word);
begin
  FDecimals := AValue;
  if DriverState in [drsLoaded, drsActive] then
    TADSLib(DriverIntf.CliObj).Decimals := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.IsDS: Boolean;
begin
  Result := (FDecimals <> C_DefDecimals) and (FDecimals <= 30);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.GetDefaultPath: String;
begin
  if DriverState in [drsLoaded, drsActive] then
    Result := TADSLib(DriverIntf.CliObj).DefaultPath
  else
    Result := FDefaultPath;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriverLink.SetDefaultPath(const AValue: String);
begin
  FDefaultPath := AValue;
  if DriverState in [drsLoaded, drsActive] then
    TADSLib(DriverIntf.CliObj).DefaultPath := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.IsDPS: Boolean;
begin
  Result := (FDefaultPath <> '') and (CompareText(String(FDefaultPath), GetCurrentDir) <> 0);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.GetSearchPath: String;
begin
  if DriverState in [drsLoaded, drsActive] then
    Result := TADSLib(DriverIntf.CliObj).SearchPath
  else
    Result := FSearchPath;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriverLink.SetSearchPath(const AValue: String);
begin
  FSearchPath := AValue;
  if DriverState in [drsLoaded, drsActive] then
    TADSLib(DriverIntf.CliObj).SearchPath := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.IsSPS: Boolean;
begin
  Result := (FSearchPath <> '') and (CompareText(FSearchPath, DefaultPath) <> 0);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.GetShowDeleted: Boolean;
begin
  if DriverState in [drsLoaded, drsActive] then
    Result := TADSLib(DriverIntf.CliObj).ShowDeleted
  else
    Result := FShowDeleted;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriverLink.SetShowDeleted(const AValue: Boolean);
begin
  FShowDeleted := AValue;
  if DriverState in [drsLoaded, drsActive] then
    TADSLib(DriverIntf.CliObj).ShowDeleted := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.IsSDS: Boolean;
begin
  Result := FShowDeleted <> C_DefShowDeleted;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.GetEpoch: Word;
begin
  if DriverState in [drsLoaded, drsActive] then
    Result := TADSLib(DriverIntf.CliObj).Epoch
  else
    Result := FEpoch;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriverLink.SetEpoch(const AValue: Word);
begin
  FEpoch := AValue;
  if DriverState in [drsLoaded, drsActive] then
    TADSLib(DriverIntf.CliObj).Epoch := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.IsEpS: Boolean;
begin
  Result := FEpoch <> C_DefEpoch;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.GetExact: Boolean;
begin
  if DriverState in [drsLoaded, drsActive] then
    Result := TADSLib(DriverIntf.CliObj).Exact
  else
    Result := FExact;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriverLink.SetExact(const AValue: Boolean);
begin
  FExact := AValue;
  if DriverState in [drsLoaded, drsActive] then
    TADSLib(DriverIntf.CliObj).Exact := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriverLink.IsExS: Boolean;
begin
  Result := FExact <> C_DefExact;
end;

{-------------------------------------------------------------------------------}
{ TADADSService                                                                 }
{-------------------------------------------------------------------------------}
function TADADSService.GetDriverLink: TADPhysADSDriverLink;
begin
  Result := inherited DriverLink as TADPhysADSDriverLink;
end;

{-------------------------------------------------------------------------------}
procedure TADADSService.SetDriverLink(const AValue: TADPhysADSDriverLink);
begin
  inherited DriverLink := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADADSService.GetConnection(out AConn: IADPhysConnection;
  out ACmd: IADPhysCommand);
var
  sConn: String;
begin
  sConn := 'DriverID=' + DriverLink.ActualDriverID + ';Database=' + Database;
  if UserName <> '' then
    sConn := sConn + ';User_Name=' + UserName;
  if Password <> '' then
    sConn := sConn + ';Password=' + Password;
  ADPhysManager().CreateConnection(sConn, AConn);
  AConn.ErrorHandler := Self as IADStanErrorHandler;
  AConn.Open;
  AConn.CreateCommand(ACmd);
  ACmd.Options.ResourceOptions.CmdExecMode := amBlocking;
end;

{-------------------------------------------------------------------------------}
{ TADADSBackupRestore                                                           }
{-------------------------------------------------------------------------------}
constructor TADADSBackupRestore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInclude := TADStringList.Create;
  FExclude := TADStringList.Create;
  FTableTypeMap := TADStringList.Create;
  FResults := TADDatSTable.Create;
  FResults.CountRef;
end;

{-------------------------------------------------------------------------------}
destructor TADADSBackupRestore.Destroy;
begin
  FResults.RemRef;
  FResults := nil;
  ADFreeAndNil(FInclude);
  ADFreeAndNil(FExclude);
  ADFreeAndNil(FTableTypeMap);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADADSBackupRestore.SetInclude(const AValue: TStrings);
begin
  FInclude.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADADSBackupRestore.SetExclude(const AValue: TStrings);
begin
  FExclude.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADADSBackupRestore.SetTableTypeMap(const AValue: TStrings);
begin
  FTableTypeMap.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADADSBackupRestore.AddOption(var AStr: String; const AName, AValue: String);
begin
  if AStr <> '' then
    AStr := AStr + ';';
  AStr := AStr + AName;
  if AValue <> '' then
    AStr := AStr + '=' + AValue;
end;

{-------------------------------------------------------------------------------}
function TADADSBackupRestore.GetOptions: String;
var
  i: Integer;
  s: String;
begin
  if Include.Count > 0 then begin
    s := '';
    for i := 0 to Include.Count - 1 do
      if Trim(Include[i]) <> '' then begin
        if s <> '' then
          s := s + ', ';
        s := s + Include[i];
      end;
    AddOption(Result, 'include', s);
  end;

  if Exclude.Count > 0 then begin
    s := '';
    for i := 0 to Exclude.Count - 1 do
      if Trim(Exclude[i]) <> '' then begin
        if s <> '' then
          s := s + ', ';
        s := s + Exclude[i];
      end;
    AddOption(Result, 'exclude', s);
  end;

  if TableTypeMap.Count > 0 then begin
    s := '';
    for i := 0 to TableTypeMap.Count - 1 do
      if Trim(Exclude[i]) <> '' then begin
        if s <> '' then
          s := s + ', ';
        s := s + TableTypeMap[i];
      end;
    AddOption(Result, 'TABLETYPEMAP', s);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADADSBackup                                                                  }
{-------------------------------------------------------------------------------}
function TADADSBackup.GetOptions: String;
begin
  Result := inherited GetOptions;
  if boDontOverwrite in Options then
    AddOption(Result, 'DontOverwrite', '');
  if boMetaOnly in Options then
    AddOption(Result, 'MetaOnly', '');
  if boPrepareDiff in Options then
    AddOption(Result, 'PrepareDiff', '');
  if boDiff in Options then
    AddOption(Result, 'Diff', '');
end;

{-------------------------------------------------------------------------------}
procedure TADADSBackup.InternalExecute;
var
  oConn: IADPhysConnection;
  oCmd: IADPhysCommand;
begin
  GetConnection(oConn, oCmd);
  oCmd.CommandText := 'EXECUTE PROCEDURE sp_BackupDatabase(:p1, :p2)';
  oCmd.Params[0].AsString := BackupPath;
  { TODO -cNEXTGEN :
    oCmd.Params[1].AsMemo := AnsiString(GetOptions);
    -> probably this should be changed back after AsMemo is ported to return String }
  oCmd.Params[1].DataType := ftMemo;
  oCmd.Params[1].Value := GetOptions;
  oCmd.Prepare();
  oCmd.Define(FResults);
  oCmd.Fetch(FResults);
end;

{-------------------------------------------------------------------------------}
procedure TADADSBackup.Backup;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADADSRestore                                                                 }
{-------------------------------------------------------------------------------}
function TADADSRestore.GetOptions: String;
begin
  Result := inherited GetOptions;
  if roDontOverwrite in Options then
    AddOption(Result, 'DontOverwrite', '');
  if roMetaOnly in Options then
    AddOption(Result, 'MetaOnly', '');
  if DDPassword <> '' then
    AddOption(Result, 'DDPassword', DDPassword);
end;

{-------------------------------------------------------------------------------}
procedure TADADSRestore.InternalExecute;
var
  oConn: IADPhysConnection;
  oCmd: IADPhysCommand;
begin
  GetConnection(oConn, oCmd);
  oCmd.CommandText := 'EXECUTE PROCEDURE sp_RestoreDatabase(:p1, :p2, :p3, :p4)';
  oCmd.Params[0].AsString := SourcePath;
  oCmd.Params[1].AsString := SourcePassword;
  oCmd.Params[2].AsString := DestinationPath;
  { TODO -cNEXTGEN : correct after porting AsMemo }
  oCmd.Params[3].DataType := ftMemo;
  oCmd.Params[3].Value := GetOptions;
  oCmd.Prepare();
  oCmd.Define(FResults);
  oCmd.Fetch(FResults);
end;

{-------------------------------------------------------------------------------}
procedure TADADSRestore.Restore;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADADSUtility                                                                 }
{-------------------------------------------------------------------------------}
constructor TADADSUtility.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTables := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADADSUtility.Destroy;
begin
  ADFreeAndNil(FTables);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADADSUtility.SetTables(const AValue: TStrings);
begin
  FTables.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADADSUtility.Encrypt;
begin
  FMode := umEncrypt;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADADSUtility.Decrypt;
begin
  FMode := umDecrypt;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADADSUtility.Pack;
begin
  FMode := umPack;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADADSUtility.Zap;
begin
  FMode := umZap;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADADSUtility.Recall;
begin
  FMode := umRecall;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADADSUtility.Reindex;
begin
  FMode := umReindex;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADADSUtility.InternalExecute;
var
  oConn: IADPhysConnection;
  oCmd: IADPhysCommand;
  oMetaCmd: IADPhysMetaInfoCommand;
  oTab: TADSTable;
  oNames: TStrings;
  i: Integer;
  oSTab: TADDatSTable;
  oDict: TADSDictionary;
  sPath: String;
begin
  GetConnection(oConn, oCmd);
  oNames := Tables;
  try
    if oNames.Count = 0 then begin
      oNames := TADStringList.Create;
      oSTab := TADDatSTable.Create;
      try
        oConn.CreateMetaInfoCommand(oMetaCmd);
        oMetaCmd.MetaInfoKind := mkTables;
        oMetaCmd.TableKinds := [tkTable, tkTempTable, tkLocalTable];
        oMetaCmd.ObjectScopes := [osMy, osOther];
        oMetaCmd.Open(True);
        oMetaCmd.Define(oSTab);
        oMetaCmd.Fetch(oSTab, True);
        for i := 0 to oSTab.Rows.Count - 1 do
          oNames.Add(oSTab.Rows[i].AsString['TABLE_NAME']);
      finally
        ADFree(oSTab);
      end;
    end;
    oDict := TADSDictionary.Create(TADSConnection(oConn.CliObj));
    try
      if not oDict.HasDictionary then
        sPath := ADNormPath(String(TADSConnection(oConn.CliObj).ConnectionPath))
      else
        sPath := '';
    finally
      ADFree(oDict);
    end;
    oTab := TADSTable.Create(TADSConnection(oConn.CliObj), Self);
    try
      for i := 0 to oNames.Count - 1 do begin
        oTab.Close;
        oTab.Options := ADS_EXCLUSIVE;
        oTab.TableName := sPath + oNames[i];
        oTab.TableType := TableType;
        oTab.Open;
        if TablePassword <> '' then
          oTab.EnableEncryption(TablePassword);
        case FMode of
        umEncrypt: oTab.Encrypt;
        umDecrypt: oTab.Decrypt;
        umPack:    oTab.Pack;
        umZap:     oTab.Zap;
        umReindex: oTab.Reindex;
        umRecall:  oTab.Recall;
        end;
        if Assigned(OnProgress) then
          OnProgress(Self, oTab.TableName);
      end;
    finally
      ADFree(oTab);
    end;
  finally
    if oNames <> Tables then
      ADFree(oNames);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysADSDriver                                                              }
{-------------------------------------------------------------------------------}
constructor TADPhysADSDriver.Create(AManager: TADPhysManager;
  const ADriverDef: IADStanDefinition);
begin
  inherited Create(AManager, ADriverDef);
  FLib := TADSLib.Create(ADPhysManagerObj);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysADSDriver.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FLib);
end;

{-------------------------------------------------------------------------------}
class function TADPhysADSDriver.GetBaseDriverID: String;
begin
  Result := S_AD_ADSId;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriver.InternalLoad;
var
  sHome, sLib: String;
begin
  sHome := '';
  sLib := '';
  GetVendorParams(sHome, sLib);
  FLib.Load(sHome, sLib);
  if Params <> nil then begin
    if Params.OwnValue(S_AD_ConnParam_ADS_DateFormat) then
      FLib.DateFormat := Params.AsString[S_AD_ConnParam_ADS_DateFormat];
    if Params.OwnValue(S_AD_ConnParam_ADS_Decimals) then
      FLib.Decimals := Params.AsInteger[S_AD_ConnParam_ADS_Decimals];
    if Params.OwnValue(S_AD_ConnParam_ADS_DefaultPath) then
      FLib.DefaultPath := Params.AsString[S_AD_ConnParam_ADS_DefaultPath];
    if Params.OwnValue(S_AD_ConnParam_ADS_SearchPath) then
      FLib.SearchPath := Params.AsString[S_AD_ConnParam_ADS_SearchPath];
    if Params.OwnValue(S_AD_ConnParam_ADS_ShowDeleted) then
      FLib.ShowDeleted := Params.AsBoolean[S_AD_ConnParam_ADS_ShowDeleted];
    if Params.OwnValue(S_AD_ConnParam_ADS_Epoch) then
      FLib.Epoch := Params.AsInteger[S_AD_ConnParam_ADS_Epoch];
    if Params.OwnValue(S_AD_ConnParam_ADS_Exact) then
      FLib.Exact := Params.AsBoolean[S_AD_ConnParam_ADS_Exact];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriver.InternalUnload;
begin
  FLib.Unload;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysADSConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriver.GetCliObj: Pointer;
begin
  Result := FLib;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 13;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  i: Integer;
  oList: TADStringList;
begin
  ALoginIndex := -1;
  ADefVal := '';
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then begin
      ALoginIndex := 2;
      AType := '@F:Advantage Dictionary|*.add';
    end;
  end
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_ADS_Alias;
        Employ;
        try
          oList := TADStringList.Create;
          try
            FLib.ListAliases(oList);
            AType := '';
            for i := 0 to oList.Count - 1 do
              AType := AType + oList[i] + ';';
            AType := Copy(AType, 1, Length(AType) - 1);
          finally
            ADFree(oList);
          end;
        finally
          Vacate;
        end;
      end;
    1:
      begin
        AName := S_AD_ConnParam_ADS_ServerTypes;
        AType := S_AD_Remote + ';' + S_AD_Local + ';' + S_AD_Internet;
      end;
    2:
      begin
        AName := S_AD_ConnParam_ADS_Protocol;
        AType := S_AD_UDP + ';' + S_AD_IPX + ';' + S_AD_TCPIP + ';' + S_AD_TLS;
      end;
    3:
      begin
        AName := S_AD_ConnParam_Common_Server;
        Employ;
        try
          oList := TADStringList.Create;
          try
            FLib.ListServers(oList);
            AType := '';
            for i := 0 to oList.Count - 1 do
              AType := AType + oList[i] + ';';
            AType := Copy(AType, 1, Length(AType) - 1);
          finally
            ADFree(oList);
          end;
        finally
          Vacate;
        end;
      end;
    4:
      begin
        AName := S_AD_ConnParam_Common_Port;
        AType := '@I';
      end;
    5:
      begin
        AName := S_AD_ConnParam_Common_CharacterSet;
        AType := C_AdsCharTypeMap;
        ADefVal := 'ANSI';
      end;
    6:
      begin
        AName := S_AD_ConnParam_ADS_Compress;
        AType := S_AD_Internet + ';' + S_AD_Always + ';' + S_AD_Never;
      end;
    7:
      begin
        AName := S_AD_ConnParam_ADS_TableType;
        AType := S_AD_ADT + ';' + S_AD_VFP + ';' + S_AD_CDX + ';' + S_AD_NTX;
      end;
    8:
      begin
        AName := S_AD_ConnParam_ADS_TablePassword;
        AType := '@S';
      end;
    9:
      begin
        AName := S_AD_ConnParam_ADS_Locking;
        AType := S_AD_Proprietary + ';' + S_AD_Compatible;
      end;
    10:
      begin
        AName := S_AD_ConnParam_ADS_Advanced;
        AType := '@S';
      end;
    11:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
      end;
    12:
      begin
        AName := S_AD_ConnParam_Common_MetaCurCatalog;
        AType := '@S';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysADSConnection                                                          }
{-------------------------------------------------------------------------------}
constructor TADPhysADSConnection.Create(ADriverObj: TADPhysDriver;
  AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, AConnHost);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysADSConnection.Destroy;
begin
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.InternalCreateTransaction: TADPhysTransaction;
begin
  Result := TADPhysADSTransaction.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.InternalCreateEvent(
  const AEventKind: String): TADPhysEventAlerter;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  CreateMetadata(oConnMeta);
  if (oConnMeta.ServerVersion >= caADS10) and
     (CompareText(AEventKind, S_AD_EventKind_ADS_Events) = 0) then
    Result := TADPhysADSEventAlerter.Create(Self, AEventKind)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysADSCommand.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysADSCommandGenerator.Create(ACommand)
  else
    Result := TADPhysADSCommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysADSMetadata.Create(Self, FServerVersion,
    TADPhysADSDriver(DriverObj).FLib.Version);
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_Monitor}
procedure TADPhysADSConnection.InternalTracingChanged;
begin
  if FConnection <> nil then begin
    FConnection.Monitor := FMonitor;
    FConnection.Tracing := FTracing;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.BuildServerTypes(
  const AConnDef: IADStanConnectionDef): Integer;
const
  C_PS: TADParseFmtSettings = (FDelimiter: '|'; FQuote: #0; FQuote1: #0; FQuote2: #0);
var
  s, sType: String;
  i, iCode: Integer;
begin
  Result := 0;
  if AConnDef.HasValue(S_AD_ConnParam_ADS_ServerTypes) then begin
    s := Trim(AConnDef.AsString[S_AD_ConnParam_ADS_ServerTypes]);
    Val(s, Result, iCode);
    if iCode <> 0 then begin
      i := 1;
      while i <= Length(s) do begin
        sType := Trim(ADExtractFieldName(s, i, C_PS));
        if CompareText(sType, S_AD_Remote) = 0 then
          Result := Result or ADS_REMOTE_SERVER
        else if CompareText(sType, S_AD_Local) = 0 then
          Result := Result or ADS_LOCAL_SERVER
        else if CompareText(sType, S_AD_Internet) = 0 then
          Result := Result or ADS_AIS_SERVER;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.Build60Options(
  const AConnDef: IADStanConnectionDef): Integer;
var
  s: String;
begin
  Result := 0;
  if AConnDef.HasValue(S_AD_ConnParam_ADS_Protocol) then begin
    s := AConnDef.AsString[S_AD_ConnParam_ADS_Protocol];
    if CompareText(s, S_AD_UDP) = 0 then
      Result := Result or ADS_UDP_IP_CONNECTION
    else if CompareText(s, S_AD_IPX) = 0 then
      Result := Result or ADS_IPX_CONNECTION
    else if CompareText(s, S_AD_TCPIP) = 0 then
      Result := Result or ADS_TCP_IP_CONNECTION
    else if CompareText(s, S_AD_TLS) = 0 then
      Result := Result or ADS_TLS_CONNECTION;
  end;

  if AConnDef.HasValue(S_AD_ConnParam_ADS_Compress) then begin
    s := AConnDef.AsString[S_AD_ConnParam_ADS_Compress];
    if CompareText(s, S_AD_Internet) = 0 then
      Result := Result or ADS_COMPRESS_INTERNET
    else if CompareText(s, S_AD_Always) = 0 then
      Result := Result or ADS_COMPRESS_ALWAYS
    else if CompareText(s, S_AD_Never) = 0 then
      Result := Result or ADS_COMPRESS_NEVER;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.BuildConnectionPath(
  const AConnDef: IADStanConnectionDef): String;
var
  i: Integer;
begin
  Result := '';
  if AConnDef.HasValue(S_AD_ConnParam_Common_Server) then begin
    Result := AConnDef.Server;
    if (Result <> '') and (Copy(Result, 1, 2) <> '//') and (Copy(Result, 1, 2) <> '\\') then
      Result := '//' + Result;
    if AConnDef.HasValue(S_AD_ConnParam_Common_Port) then begin
      i := Pos(':', Result);
      if i <> 0 then
        Result := Copy(Result, 1, i - 1);
      if AConnDef.Port <> 0 then
        Result := Result + ':' + IntToStr(AConnDef.Port);
    end;
  end;
  if AConnDef.HasValue(S_AD_ConnParam_Common_Database) or (FAliasPath <> '') then begin
    if (Result <> '') and (Copy(Result, Length(Result), 1) <> '/') and
       (Copy(Result, Length(Result), 1) <> '\') then
      Result := Result + '/';
    if AConnDef.Database <> '' then
      Result := Result + AConnDef.Database
    else if FAliasPath <> '' then
      Result := Result + FAliasPath;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.BuildADS101ConnectString(
  const AConnDef: IADStanConnectionDef): String;

  procedure Add(const AParam, AValue: String);
  begin
    if Result <> '' then
      Result := Result + ';';
    Result := Result + AParam + '=' + AValue;
  end;

var
  s: String;
begin
  Result := '';

  s := IntToStr(BuildServerTypes(AConnDef));
  if s <> '0' then
    Add('ServerType', s);

  s := '';
  if AConnDef.HasValue(S_AD_ConnParam_ADS_Protocol) then begin
    s := AConnDef.AsString[S_AD_ConnParam_ADS_Protocol];
    if CompareText(s, S_AD_UDP) = 0 then
      s := 'UDP_IP'
    else if CompareText(s, S_AD_IPX) = 0 then
      s := 'IPX'
    else if CompareText(s, S_AD_TCPIP) = 0 then
      s := 'TCP_IP'
    else if CompareText(s, S_AD_TLS) = 0 then
      s := 'TLS';
  end;
  if s <> '' then
    Add('CommType', s);

  s := BuildConnectionPath(AConnDef);
  if s <> '' then
    Add('Data Source', s);

  if AConnDef.HasValue(S_AD_ConnParam_Common_UserName) then
    Add('User ID', AConnDef.UserName);
  if AConnDef.HasValue(S_AD_ConnParam_Common_Password) then
    Add('Password', AConnDef.Password);
  if AConnDef.HasValue(S_AD_ConnParam_Common_CharacterSet) then
    Add('CharType', AConnDef.AsString[S_AD_ConnParam_Common_CharacterSet]);
  if AConnDef.HasValue(S_AD_ConnParam_ADS_Compress) then
    Add('Compression', AConnDef.AsString[S_AD_ConnParam_ADS_Compress]);
  if AConnDef.HasValue(S_AD_ConnParam_ADS_TableType) then
    Add('TableType', AConnDef.AsString[S_AD_ConnParam_ADS_TableType])
  else if FAliasTableType <> '' then
    Add('TableType', FAliasTableType);
  if AConnDef.HasValue(S_AD_ConnParam_ADS_Locking) then
    Add('LockMode', AConnDef.AsString[S_AD_ConnParam_ADS_Locking]);

  if AConnDef.HasValue(S_AD_ConnParam_ADS_Advanced) then
    Result := Result + ';' + AConnDef.AsString[S_AD_ConnParam_ADS_Advanced];
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSConnection.BaseConnect(AConn: TADSConnection;
  const AConnDef: IADStanConnectionDef);
begin
  if AConnDef.HasValue(S_AD_ConnParam_ADS_Alias) then
    AConn.Lib.ResolveAlias(AConnDef.AsString[S_AD_ConnParam_ADS_Alias],
      FAliasPath, FAliasTableType)
  else begin
    FAliasPath := '';
    FAliasTableType := '';
  end;
  if Assigned(AConn.Lib.FAdsConnect101) then
    AConn.Connect101(BuildADS101ConnectString(AConnDef))
  else begin
    AConn.Connect60(BuildConnectionPath(AConnDef), BuildServerTypes(AConnDef),
      AConnDef.UserName, AConnDef.Password, Build60Options(AConnDef));
    if AConnDef.HasValue(S_AD_ConnParam_Common_CharacterSet) then
      AConn.Collation := AConnDef.AsString[S_AD_ConnParam_Common_CharacterSet];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSConnection.InternalConnect;
var
  pCliHandles: PADPhysADSCliHandles;
begin
  if InternalGetSharedCliHandle() <> nil then begin
    pCliHandles := PADPhysADSCliHandles(InternalGetSharedCliHandle());
    FConnection := TADSConnection.CreateUsingHandle(TADPhysADSDriver(DriverObj).FLib,
      pCliHandles^[0], Self);
  end
  else
    FConnection := TADSConnection.Create(TADPhysADSDriver(DriverObj).FLib, Self);
{$IFDEF AnyDAC_MONITOR}
  InternalTracingChanged;
{$ENDIF}

  if InternalGetSharedCliHandle() = nil then begin
    BaseConnect(FConnection, GetConnectionDef);

    if GetConnectionDef.NewPassword <> '' then
      InternalExecuteDirect('EXECUTE PROCEDURE sp_ModifyUserProperty(''' +
        GetConnectionDef.UserName + ''', ''USER_PASSWORD'', ''' +
        GetConnectionDef.NewPassword + '''', nil);
  end;

  FDictionary := TADSDictionary.Create(FConnection);
  FServerVersion := FConnection.ServerVersion;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSConnection.InternalSetMeta;
var
  sName: String;
begin
  inherited InternalSetMeta;
  sName := String(FConnection.ConnectionPath);
  if FCurrentCatalog = '' then
    FCurrentCatalog := sName;
  if FDefaultCatalog = '' then
    FDefaultCatalog := sName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSConnection.InternalDisconnect;
begin
  ADFreeAndNil(FDictionary);
  ADFreeAndNil(FConnection);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSConnection.InternalPing;
begin
  FConnection.Ping;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSConnection.InternalChangePassword(const AUserName,
  AOldPassword, ANewPassword: String);
var
  oConnDef: IADStanConnectionDef;
  oConn: TADSConnection;
  oStmt: TADSStatement;
begin
  ADCreateInterface(IADStanConnectionDef, oConnDef);
  oConnDef.ParentDefinition := ConnectionDef;
  oConnDef.UserName := AUserName;
  oConnDef.Password := AOldPassword;
  oConn := TADSConnection.Create(TADPhysADSDriver(DriverObj).FLib, Self);
  oStmt := TADSStatement.Create(oConn, Self);
  try
    BaseConnect(oConn, oConnDef);
    oStmt.ExecuteDirect('EXECUTE PROCEDURE sp_ModifyUserProperty(''' +
      AUserName + ''', ''USER_PASSWORD'', ''' + ANewPassword + '''');
  finally
    ADFree(oStmt);
    ADFree(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSConnection.InternalExecuteDirect(const ASQL: String;
  ATransaction: TADPhysTransaction);
var
  oStmt: TADSStatement;
begin
  oStmt := TADSStatement.Create(FConnection, Self);
  try
    oStmt.ExecuteDirect(ASQL);
  finally
    ADFree(oStmt);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.GetLastAutoGenValue(const AName: String): Variant;
var
  iLastAutoInc: LongWord;
begin
  if (FConnection <> nil) and (AName = '') then begin
    iLastAutoInc := FConnection.LastAutoInc;
    if iLastAutoInc = 0 then
      Result := FLastAutoGenValue
    else
{$IFDEF AnyDAC_D6Base}
      Result := iLastAutoInc
{$ELSE}
      Result := Integer(iLastAutoInc)
{$ENDIF}
  end
  else
    Result := inherited GetLastAutoGenValue(AName);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  if DriverObj.State in [drsLoaded, drsActive] then begin
    Inc(Result, 2);
    if FConnection <> nil then
      Inc(Result, 3);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSConnection.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'Client version';
        AValue := Integer(TADPhysADSDriver(DriverObj).FLib.Version);
        AKind := ikClientInfo;
      end;
    1:
      begin
        AName := 'Client DLL name';
        AValue := TADPhysADSDriver(DriverObj).FLib.DLLName;
        AKind := ikClientInfo;
      end;
    2:
      begin
        AName := 'Server version';
        AValue := FConnection.ServerVersionStr;
        AKind := ikSessionInfo;
      end;
    3:
      begin
        AName := 'Server collation';
        AValue := FConnection.Collation;
        AKind := ikSessionInfo;
      end;
    4:
      begin
        AName := 'Connection path';
        AValue := FConnection.ConnectionPath;
        AKind := ikSessionInfo;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.GetMessages: EADDBEngineException;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.GetCliObj: Pointer;
begin
  Result := FConnection;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSConnection.InternalGetCliHandle: Pointer;
begin
  if FConnection <> nil then begin
    FCliHandles[0] := FConnection.Handle;
    Result := @FCliHandles;
  end
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSConnection.InternalAnalyzeSession(AMessages: TStrings);
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  inherited InternalAnalyzeSession(AMessages);
  CreateMetadata(oConnMeta);

  // 2. The minimal Advantage server version is 10.0
  if (oConnMeta.ServerVersion > 0) and (oConnMeta.ServerVersion < caADS10) then
    AMessages.Add(Format('Warning: invalid Advantage version [%s]. Minimal version is [10.0]',
      [ADVerInt2Str(oConnMeta.ServerVersion)]));

  // 3. The minimal ACE version is 10.0
  if (oConnMeta.ClientVersion > 0) and (oConnMeta.ClientVersion < caADS10) then
    AMessages.Add(Format('Warning: invalid ACE version [%s]. Minimal version is [10.0]',
      [ADVerInt2Str(oConnMeta.ClientVersion)]));
end;

{-------------------------------------------------------------------------------}
{ TADPhysADSTransaction                                                         }
{-------------------------------------------------------------------------------}
procedure TADPhysADSTransaction.InternalStartTransaction(ATxID: LongWord);
begin
  TADPhysADSConnection(ConnectionObj).InternalExecuteDirect(
    'BEGIN TRANSACTION; SAVEPOINT ' + 't_' + IntToStr(ATxID), Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSTransaction.InternalCommit(ATxID: LongWord);
begin
  TADPhysADSConnection(ConnectionObj).InternalExecuteDirect(
    'COMMIT', Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSTransaction.InternalRollback(ATxID: LongWord);
begin
  if GetNestingLevel = 1 then
    TADPhysADSConnection(ConnectionObj).InternalExecuteDirect(
      'ROLLBACK', Self)
  else
    TADPhysADSConnection(ConnectionObj).InternalExecuteDirect(
      'ROLLBACK TO SAVEPOINT ' + 't_' + IntToStr(ATxID), Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSTransaction.InternalChanged;
var
  s: String;
begin
  // ADS does not support transaction modes, only autocommit on/off
  if xoAutoCommit in GetOptions.Changed then begin
    if GetOptions.AutoCommit then
      s := 'ON'
    else
      s := 'OFF';
    TADPhysADSConnection(ConnectionObj).InternalExecuteDirect(
      'SET TRANSACTION AUTOCOMMIT_' + s, nil);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSTransaction.InternalCheckState(ACommandObj: TADPhysCommand;
  ASuccess: Boolean);
var
  oStmt: TADSStatement;
  oCrs: TADSCursor;
  iTrans, iSize: Integer;
  lActive: Boolean;
begin
  if ASuccess and (TADPhysADSCommand(ACommandObj).GetCommandKind in
                   [skStartTransaction, skCommit, skRollback]) then begin
    oStmt := TADSStatement.Create(TADPhysADSConnection(ConnectionObj).FConnection, Self);
    oCrs := nil;
    try
      // Local server ignores transaction control commands.
      // So, the ::conn.TransactionCount is always zero.
      oStmt.ExecuteDirect('SELECT ::conn.TransactionCount FROM system.iota');
      oCrs := oStmt.GetCursor;
      oCrs.AddColumns;
      oCrs.Columns[0].GetData(@iTrans, iSize);
      lActive := (iTrans > 0);
      if GetActive <> lActive then
        if lActive then
          TransactionStarted
        else
          TransactionFinished;
    finally
      ADFree(oCrs);
      ADFree(oStmt);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSTransaction.InternalNotify(
  ANotification: TADPhysTxNotification; ACommandObj: TADPhysCommand);
begin
  // ADS does not invalidate open cursors after explicit 
  // transaction control commands
  inherited InternalNotify(ANotification, ACommandObj);
end;

{-------------------------------------------------------------------------------}
{ TADPhysADSEventThread                                                         }
{-------------------------------------------------------------------------------}
type
  TADPhysADSEventThread = class(TThread)
  private
    FAlerter: TADPhysADSEventAlerter;
  protected
    procedure Execute; override;
  public
    constructor Create(AAlerter: TADPhysADSEventAlerter);
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysADSEventThread.Create(AAlerter: TADPhysADSEventAlerter);
begin
  inherited Create(False);
  FAlerter := AAlerter;
  FreeOnTerminate := True;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysADSEventThread.Destroy;
begin
  FAlerter.FWaitThread := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSEventThread.Execute;
begin
  while not Terminated and FAlerter.IsRunning do
    try
      FAlerter.FWaitCommand.Open;
      if not Terminated then
        FAlerter.DoFired;
    except
      on E: EADDBEngineException do
        if E.Kind <> ekCmdAborted then begin
          Terminate;
          FAlerter.AbortJob;
        end;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysADSEventMessage                                                        }
{-------------------------------------------------------------------------------}
type
  TADPhysADSEventMessage = class(TADPhysEventMessage)
  private
    FName: String;
    FCount: Integer;
    FMessage: String;
  public
    constructor Create(const AName: String; ACount: Integer; const AMessage: String);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysADSEventMessage.Create(const AName: String;
  ACount: Integer; const AMessage: String);
begin
  inherited Create;
  FName := AName;
  FCount := ACount;
  FMessage := AMessage;
end;

{-------------------------------------------------------------------------------}
{ TADPhysADSEventAlerter                                                        }
{-------------------------------------------------------------------------------}
const
  C_WakeUpEvent = C_AD_SysNamePrefix + 'WAKEUP';
  C_SignalEventProc = C_AD_SysNamePrefix + '_SIGNALEVENT';

procedure TADPhysADSEventAlerter.InternalAllocHandle;
begin
  FWaitConnection := GetConnection.Clone;
  if FWaitConnection.State = csDisconnected then
    FWaitConnection.Open;
  FWaitConnection.CreateCommand(FWaitCommand);
  SetupCommand(FWaitCommand);
  FTab := TADDatSTable.Create;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSEventAlerter.DoFired;
var
  i: Integer;
  oRow: TADDatSRow;
begin
  try
    if FTab.Columns.Count = 0 then
      FWaitCommand.Define(FTab);
    FWaitCommand.Fetch(FTab);
    for i := 0 to FTab.Rows.Count - 1 do begin
      oRow := FTab.Rows[i];
      if (oRow.GetData(1) <> 0) and
         (CompareText(oRow.GetData(0), C_WakeUpEvent) <> 0) then
        FMsgThread.EnqueueMsg(TADPhysADSEventMessage.Create(
          oRow.GetData(0), oRow.GetData(1), oRow.GetData(2)));
    end;
  finally
    FTab.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSEventAlerter.InternalHandle(
  AEventMessage: TADPhysEventMessage);
var
  oEventMsg: TADPhysADSEventMessage;
begin
  if GetHandler <> nil then begin
    oEventMsg := TADPhysADSEventMessage(AEventMessage);
    GetHandler.HandleEvent(oEventMsg.FName, oEventMsg.FMessage);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSEventAlerter.InternalAbortJob;
begin
  if FWaitThread <> nil then begin
    FWaitThread.Terminate;
    InternalSignal(C_WakeUpEvent, Null);
    FWaitCommand.AbortJob(True);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSEventAlerter.InternalRegister;
var
  i: Integer;
begin
  FWaitCommand.CommandText := 'SELECT 1 FROM system.storedprocedures WHERE UPPER(Name) = ''' +
    C_SignalEventProc + '''';
  FWaitCommand.Open;
  FWaitCommand.Define(FTab);
  FWaitCommand.Fetch(FTab);
  if FTab.Rows.Count = 0 then begin
    FWaitCommand.Prepare('CREATE PROCEDURE ' + C_SignalEventProc +
      ' (AEvNm CHAR(200), AWFC LOGICAL, AEvDt MEMO)' +
      ' BEGIN' +
      ' DECLARE AEvNm CHAR(200), AWFC LOGICAL, AEvDt MEMO;' +
      ' AEvNm = (SELECT A.AEvNm FROM __INPUT A);' +
      ' AWFC = (SELECT A.AWFC FROM __INPUT A);' +
      ' AEvDt = (SELECT A.AEvDt FROM __INPUT A);' +
      ' EXECUTE PROCEDURE sp_SignalEvent(AEvNm, AWFC, 0, AEvDt);' +
      ' END;');
    FWaitCommand.Execute();
  end;
  FTab.Reset;

  FWaitCommand.CommandText := 'EXECUTE PROCEDURE sp_CreateEvent(:EventName, 2)';
  FWaitCommand.Params[0].DataType := ftString;
  FWaitCommand.Prepare;
  FWaitCommand.Params[0].AsString := C_WakeUpEvent;
  FWaitCommand.Execute();
  for i := 0 to GetNames.Count - 1 do begin
    FWaitCommand.Params[0].AsString := GetNames()[i];
    FWaitCommand.Execute();
  end;

  FWaitCommand.CommandText := 'SELECT * FROM (EXECUTE PROCEDURE sp_WaitForAnyEvent(-1, 0, 0)) A';
  FWaitCommand.Prepare;

  FWaitThread := TADPhysADSEventThread.Create(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSEventAlerter.InternalUnregister;
begin
  FWaitThread := nil;

  if FWaitCommand <> nil then
  try
    FWaitCommand.Prepare('EXECUTE PROCEDURE sp_DropAllEvents(0)');
    FWaitCommand.Execute();
  except
    // hide exception
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSEventAlerter.InternalReleaseHandle;
begin
  ADFreeAndNil(FTab);
  FWaitCommand := nil;
  FWaitConnection := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSEventAlerter.InternalSignal(const AEvent: String;
  const AArgument: Variant);
var
  oCmd: IADPhysCommand;
  sCmd: String;
begin
  sCmd := 'EXECUTE PROCEDURE ' + C_SignalEventProc + '(' + QuotedStr(AEvent) + ', true';
  if VarIsNull(AArgument) or VarIsEmpty(AArgument) then
    sCmd := sCmd + ', NULL'
  else
    sCmd := sCmd + ', ' + QuotedStr(VarToStr(AArgument));
  sCmd := sCmd + ')';
  GetConnection.CreateCommand(oCmd);
  SetupCommand(oCmd);
  oCmd.Prepare(sCmd);
  oCmd.Execute();
end;

{-------------------------------------------------------------------------------}
{ TADPhysADSCommand                                                             }
{-------------------------------------------------------------------------------}
constructor TADPhysADSCommand.Create(AConnection: TADPhysConnection);
begin
  inherited Create(AConnection);
  FMetaEncoder := TADEncoder.Create(nil);
  FMetaEncoder.Encoding := ecANSI;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysADSCommand.Destroy;
begin
  ADFreeAndNil(FMetaEncoder);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.GetConnection: TADPhysADSConnection;
begin
  Result := TADPhysADSConnection(FConnectionObj);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.GetCliObj: Pointer;
begin
  Result := FStmt;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.UseExecDirect: Boolean;
begin
  Result := (FOptions.ResourceOptions.DirectExecute or
             (GetCommandKind in [skSet, skSetSchema, skCreate, skDrop, skAlter, skOther,
                                 skStartTransaction, skCommit, skRollback])) and
            (GetParams.Count = 0);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.SetupStatement(AStmt: TADSStatement);
var
  oFmtOpts: TADFormatOptions;
  oResOpts: TADResourceOptions;
  s: String;
begin
  oFmtOpts := FOptions.FormatOptions;
  oResOpts := FOptions.ResourceOptions;
  if GetMetaInfoKind <> mkNone then begin
    AStmt.StrsTrim := True;
    AStmt.StrsEmpty2Null := True;
  end
  else begin
    AStmt.StrsTrim := oFmtOpts.StrsTrim;
    AStmt.StrsEmpty2Null := oFmtOpts.StrsEmpty2Null;
  end;
  if oResOpts.CmdExecTimeout <> $FFFFFFFF then
    AStmt.Timeout := (oResOpts.CmdExecTimeout + 999) div 1000;
  AStmt.ReadOnly := True;

  if not Assigned(AStmt.Lib.FAdsConnect101) then begin
    if ADSConnection.ConnectionDef.HasValue(S_AD_ConnParam_ADS_TableType) or
       (ADSConnection.FAliasTableType <> '') then begin
      s := ADSConnection.ConnectionDef.AsString[S_AD_ConnParam_ADS_TableType];
      if s = '' then
        s := ADSConnection.FAliasTableType;
      if CompareText(s, S_AD_ADT) = 0 then
        AStmt.TableType := ttADT
      else if CompareText(s, S_AD_VFP) = 0 then
        AStmt.TableType := ttVFP
      else if CompareText(s, S_AD_CDX) = 0 then
        AStmt.TableType := ttCDX
      else if CompareText(s, S_AD_NTX) = 0 then
        AStmt.TableType := ttNTX;
    end;
    if ADSConnection.ConnectionDef.HasValue(S_AD_ConnParam_ADS_Locking) then begin
      s := ADSConnection.ConnectionDef.AsString[S_AD_ConnParam_ADS_Locking];
      if CompareText(s, S_AD_Proprietary) = 0 then
        AStmt.LockType := ltProprietary
      else if CompareText(s, S_AD_Compatible) = 0 then
        AStmt.LockType := ltCompatible;
    end;
    if ADSConnection.ConnectionDef.HasValue(S_AD_ConnParam_Common_CharacterSet) then
      AStmt.Collation := ADSConnection.ConnectionDef.AsString[S_AD_ConnParam_Common_CharacterSet];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.SetupCursor(ACrs: TADSCursor);
var
  oFetchOpts: TADFetchOptions;
begin
  oFetchOpts := FOptions.FetchOptions;
  ACrs.CacheRecords := oFetchOpts.RowsetSize;
  if ADSConnection.ConnectionDef.HasValue(S_AD_ConnParam_ADS_TablePassword) then
    ACrs.EnableEncryption(ADSConnection.ConnectionDef.AsString[S_AD_ConnParam_ADS_TablePassword]);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.AllocStatement: TADSStatement;
begin
  { TODO -cADS : At moment record locking and cursors seems not working }
(*
  if (FOptions.UpdateOptions.LockMode = lmPessimistic) and
     (GetCommandKind in [skSelect, skSelectForLock, skSelectForUnLock, skDelete,
                         skInsert, skMerge, skUpdate]) then begin
    if ADSConnection.FSharedStmt = nil then
      ADSConnection.FSharedStmt := TADSStatement.Create(ADSConnection.FConnection,
        ADSConnection);
    Result := ADSConnection.FSharedStmt;
    Result.OwningObj := Self;
  end
  else
*)  
    Result := TADSStatement.Create(ADSConnection.FConnection, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.ReleaseStatement(var AStmt: TADSStatement);
begin
  if ADSConnection.FSharedStmt <> AStmt then
    AStmt.Free
  else
    AStmt.OwningObj := ADSConnection;
  AStmt := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.InternalPrepare;
var
  rName: TADPhysParsedName;
  oConnMeta: IADPhysConnectionMetadata;
begin
  // generate metadata SQL command
  if GetMetaInfoKind <> mkNone then begin
    GetSelectMetaInfoParams(rName);
    // ADS returns error for mkIndexes query to the SYSTEM catalog tables
    if (CompareText(rName.FCatalog, 'SYSTEM') = 0) and
       (GetMetaInfoKind in [mkIndexes, mkIndexFields]) then
      Exit;
    // ADS returns error for SP query to a non-dictionary connection
    if not ADSConnection.FDictionary.HasDictionary and
       (GetMetaInfoKind in [mkPackages, mkProcs, mkProcArgs, mkGenerators]) then
      Exit;

    if GetMetaInfoKind = mkIndexes then begin
      GetConnection.CreateMetadata(oConnMeta);
      FMetainfoAddonView := oConnMeta.GetTablePrimaryKey(rName.FCatalog,
        rName.FSchema, Trim(GetCommandText()));
    end;

    GenerateSelectMetaInfo(rName);
    if FDbCommandText = '' then
      Exit;
  end

  // generate stored proc call SQL command
  else if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
    GetConnection.CreateMetadata(oConnMeta);
    oConnMeta.DecodeObjName(Trim(GetCommandText()), rName, Self, []);
    FDbCommandText := '';
    if fiMeta in FOptions.FetchOptions.Items then
      GenerateStoredProcParams(rName);
    // ADS does not support <catalog>.<name> as a stored procedure name
    rName.FCatalog := '';
    GenerateStoredProcCall(rName);
  end;

  // adjust SQL command
  GenerateLimitSelect();
  GenerateParamMarkers();

  FStmt := AllocStatement;
  SetupStatement(FStmt);
  if GetParams.Count > 0 then
    CreateParamInfos;
  if not UseExecDirect then
    FStmt.Prepare(FDbCommandText);
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.ADType2SQL(AType: TADDataType): Word;
begin
  case AType of
  dtSByte,
  dtByte,
  dtInt16,
  dtUInt16:
    Result := ADS_SHORTINT;
  dtInt32,
  dtUInt32:
    Result := ADS_INTEGER;
  dtInt64,
  dtUInt64:
    Result := ADS_LONGLONG;
  dtDouble,
  dtSingle,
  dtExtended:
    Result := ADS_DOUBLE;
  dtCurrency:
    Result := ADS_MONEY;
  dtBCD,
  dtFmtBcd:
    Result := ADS_NUMERIC;
  dtAnsiString:
    Result := ADS_STRING;
  dtWideString:
    Result := ADS_NVARCHAR;
  dtMemo,
  dtHMemo:
    Result := ADS_MEMO;
  dtWideMemo,
  dtWideHMemo,
  dtXML:
    Result := ADS_NMEMO;
  dtByteString:
    Result := ADS_RAW;
  dtBlob,
  dtHBFile,
  dtHBlob:
    Result := ADS_BINARY;
  dtDate:
    Result := ADS_DATE;
  dtTime:
    Result := ADS_TIME;
  dtDateTime,
  dtDateTimeStamp:
    Result := ADS_TIMESTAMP;
  dtBoolean:
    Result := ADS_LOGICAL;
  dtGUID:
    Result := ADS_STRING;
  else
    // dtTimeIntervalFull, dtTimeIntervalYM, dtTimeIntervalDS,
    // dtCursorRef, dtRowSetRef, dtRowRef, dtArrayRef, dtParentRowRef, dtObject
    Result := ADS_TYPE_UNKNOWN;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.SQL2ADColInfo(ASQLType, ASQLMemoType: Word; ASQLLen: LongWord;
  ASQLPrec, ASQLScale: Word; out AType: TADDataType; var AAttrs: TADDataAttributes;
  out ALen: LongWord; out APrec, AScale: Integer; AFmtOpts: TADFormatOptions);
begin
  AType := dtUnknown;
  ALen := 0;
  APrec := 0;
  AScale := 0;
  Exclude(AAttrs, caFixedLen);
  Exclude(AAttrs, caBlobData);
  Include(AAttrs, caSearchable);
  case ASQLType of
  ADS_SHORTINT:
    AType := dtInt16;
  ADS_INTEGER:
    AType := dtInt32;
  ADS_LONGLONG:
    AType := dtInt64;
  ADS_AUTOINC:
    begin
      AType := dtInt32;
      Include(AAttrs, caAutoInc);
      Include(AAttrs, caReadOnly);
    end;
  ADS_ROWVERSION:
    begin
      AType := dtInt64;
      Include(AAttrs, caRowVersion);
      Include(AAttrs, caReadOnly);
    end;
  ADS_DOUBLE:
    AType := dtDouble;
  ADS_CURDOUBLE,
  ADS_MONEY:
    begin
      APrec := 19;
      AScale := 4;
      AType := dtCurrency;
    end;
  ADS_NUMERIC:
    begin
      APrec := ASQLPrec;
      AScale := ASQLScale;
      if (APrec > AFmtOpts.MaxBcdPrecision) or (AScale > AFmtOpts.MaxBcdScale) then
        AType := dtFmtBCD
      else
        AType := dtBCD
    end;
  ADS_STRING,
  ADS_CISTRING,
  ADS_VARCHAR,
  ADS_VARCHAR_FOX:
    if ASQLLen <= AFmtOpts.MaxStringSize then begin
      ALen := ASQLLen;
      AType := dtAnsiString;
      if ASQLType in [ADS_STRING, ADS_CISTRING] then
        Include(AAttrs, caFixedLen);
    end
    else begin
      AType := dtMemo;
      Include(AAttrs, caBlobData);
    end;
  ADS_MEMO:
    begin
      AType := dtMemo;
      Include(AAttrs, caBlobData);
    end;
  ADS_NCHAR,
  ADS_NVARCHAR:
    if ASQLLen <= AFmtOpts.MaxStringSize then begin
      ALen := ASQLLen;
      AType := dtWideString;
      if ASQLType = ADS_NCHAR then
        Include(AAttrs, caFixedLen);
    end
    else begin
      AType := dtWideMemo;
      Include(AAttrs, caBlobData);
    end;
  ADS_NMEMO:
    begin
      AType := dtWideMemo;
      Include(AAttrs, caBlobData);
    end;
  ADS_RAW,
  ADS_VARBINARY_FOX,
  ADS_SYSTEM_FIELD:
    begin
      AType := dtByteString;
      ALen := ASQLLen;
      if ASQLType in [ADS_RAW, ADS_SYSTEM_FIELD] then
        Include(AAttrs, caFixedLen);
    end;
  ADS_BINARY,
  ADS_IMAGE,
  ADS_FOXGENERAL,
  ADS_FOXPICTURE:
    begin
      AType := dtBlob;
      Include(AAttrs, caBlobData);
    end;
  ADS_DATE,
  ADS_COMPACTDATE:
    AType := dtDate;
  ADS_TIME:
    begin
      AType := dtTime;
      AScale := 1;
    end;
  ADS_TIMESTAMP,
  ADS_MODTIME:
    begin
      AType := dtDateTimeStamp;
      AScale := 1;
    end;
  ADS_LOGICAL:
    AType := dtBoolean;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.CreateParamInfos;
var
  i: Integer;
  oFmtOpts: TADFormatOptions;
  oParams: TADParams;
  oParam: TADParam;
  iAdsParIndex, iAdsParRef: Integer;
  oAdsParam: TADSVariable;
  eDestFldType: TFieldType;
  eAttrs: TADDataAttributes;
  iPrec, iScale: Integer;
  iLen: LongWord;
  pPar: PADAdsParInfoRec;
begin
  oFmtOpts := FOptions.FormatOptions;
  oParams := GetParams;

  iAdsParIndex := 0;
  for i := 0 to oParams.Count - 1 do
    if oParams[i].ParamType in [ptUnknown, ptInput, ptInputOutput] then
      Inc(iAdsParIndex);

  FStmt.Params.Count := iAdsParIndex;
  SetLength(FParInfos, iAdsParIndex);

  iAdsParIndex := 0;
  for i := 0 to oParams.Count - 1 do begin
    oParam := oParams[i];
    if oParam.ParamType in [ptUnknown, ptInput, ptInputOutput] then begin
      pPar := @FParInfos[iAdsParIndex];
      case GetParams.BindMode of
      pbByName:   iAdsParRef := iAdsParIndex;
      pbByNumber: iAdsParRef := oParam.Position - 1;
      else        iAdsParRef := -1;
      end;
      if (iAdsParRef >= 0) and (iAdsParRef < FStmt.Params.Count) then begin
        oAdsParam := FStmt.Params[iAdsParRef];
        pPar^.FAdsParamIndex := iAdsParRef;
        pPar^.FParamIndex := i;
        pPar^.FParamType := oParam.ParamType;

        if oParam.DataType = ftUnknown then
          ParTypeUnknownError(oParam);

        pPar^.FSrcFieldType := oParam.DataType;
        oFmtOpts.ResolveFieldType('', oParam.DataType, oParam.ADDataType,
          oParam.Size, oParam.Precision, oParam.NumericScale, eDestFldType,
          pPar^.FSrcSize, pPar^.FSrcPrec, pPar^.FSrcScale,
          pPar^.FSrcDataType, pPar^.FDestDataType, False);

        pPar^.FOutSQLDataType := ADType2SQL(pPar^.FDestDataType);
        eAttrs := [];
        SQL2ADColInfo(pPar^.FOutSQLDataType, ADS_MEMO, pPar^.FSrcSize,
          pPar^.FSrcPrec, pPar^.FSrcScale, pPar^.FOutDataType,
          eAttrs, iLen, iPrec, iScale, oFmtOpts);

        case GetParams.BindMode of
        pbByName:   oAdsParam.Name := oParam.Name;
        pbByNumber: oAdsParam.Position := oParam.Position;
        end;
        oAdsParam.ValueType := pPar^.FOutSQLDataType;
      end;
      Inc(iAdsParIndex);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.DestroyParamInfos;
begin
  SetLength(FParInfos, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.CreateColInfos;
var
  i: Integer;
  oDef: TADSColumnDef;
  oFmtOpts: TADFormatOptions;
  iPrec, iScale: Integer;
  sKeyColumns: String;
  pCol: PADAdsColInfoRec;
  oVar: TADSVariable;
begin
  oFmtOpts := FOptions.FormatOptions;
  SetLength(FColInfos, FCursor.ColumnDefsCount);
  FCursor.Columns.Count := FCursor.ColumnDefsCount;
  sKeyColumns := '';

  if (GetMetaInfoKind = mkNone) and (fiMeta in FOptions.FetchOptions.Items) then begin
    sKeyColumns := FCursor.KeyColumns;
    if sKeyColumns <> '' then
      sKeyColumns := ';' + AnsiUpperCase(sKeyColumns) + ';';
  end;

  for i := 0 to Length(FColInfos) - 1 do begin
    oDef := FCursor.ColumnDefs[i];
    try
      pCol := @FColInfos[i];
      pCol^.FName := String(oDef.Name);
      pCol^.FPos := i + 1;

      pCol^.FLen := oDef.Length;
      pCol^.FPrec := oDef.Precision;
      pCol^.FScale := oDef.Scale;
      pCol^.FSrcSQLDataType := oDef.FieldType;
      pCol^.FSrcSQLMemoType := oDef.MemoType;

      // ACE API does not provide more information about result set columns
      pCol^.FAttrs := [caAllowNull];
      if sKeyColumns <> '' then
        pCol^.FInPK := Pos(';' + AnsiUpperCase(pCol^.FName) + ';',
          sKeyColumns) > 0;

      if CompareText(pCol^.FName, 'ROWID') = 0 then begin
        Include(pCol^.FAttrs, caROWID);
        Include(pCol^.FAttrs, caAllowNull);
      end;

      SQL2ADColInfo(pCol^.FSrcSQLDataType, pCol^.FSrcSQLMemoType,
        pCol^.FLen, pCol^.FPrec, pCol^.FScale, pCol^.FSrcDataType,
        pCol^.FAttrs, pCol^.FADLen, iPrec, iScale, oFmtOpts);
      pCol^.FPrec := iPrec;
      pCol^.FScale := iScale;

      if GetMetaInfoKind = mkNone then
        oFmtOpts.ResolveDataType(pCol^.FName, pCol^.FSrcDataType,
          pCol^.FADLen, pCol^.FPrec, pCol^.FScale, pCol^.FDestDataType,
          pCol^.FADLen, True)
      else
        pCol^.FDestDataType := pCol^.FSrcDataType;

      if CheckFetchColumn(pCol^.FSrcDataType, pCol^.FAttrs) then begin
        oVar := FCursor.Columns[i];
        oVar.Position := pCol^.FPos;
        oVar.Name := oDef.Name;
        oVar.ValueType := oDef.FieldType;
        oVar.IsImage := oDef.MemoType = ADS_IMAGE;
        pCol^.FVar := oVar;
      end
      else
        pCol^.FVar := nil;
    finally
      ADFree(oDef);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.DestroyColInfos;
begin
  SetLength(FColInfos, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.SetParamValue(AFmtOpts: TADFormatOptions; AParam: TADParam;
  AAdsParam: TADSVariable; ApInfo: PADAdsParInfoRec; AArrIndex: Integer);
var
  pData: PADByteString;
  iSize, iSrcSize: LongWord;
begin
  pData := nil;
  iSize := 0;

  // null
  if AParam.IsNulls[AArrIndex] then
    AAdsParam.SetData(nil, 0)

  // conversion is not required
  else if ApInfo^.FSrcDataType = ApInfo^.FOutDataType then begin
    // byte string data, then optimizing - get data directly
    if ApInfo^.FOutDataType in C_AD_VarLenTypes then begin
      AParam.GetBlobRawData(iSize, pData, AArrIndex);
      AAdsParam.SetData(pData, iSize);
    end
    else begin
      iSize := AParam.GetDataLength(AArrIndex);
      FBuffer.Check(iSize);
      AParam.GetData(FBuffer.Ptr, AArrIndex);
      AAdsParam.SetData(FBuffer.Ptr, iSize);
    end;
  end

  // conversion is required
  else begin
    // calculate buffer size to move param values
    iSrcSize := AParam.GetDataLength(AArrIndex);
    FBuffer.Extend(iSrcSize, iSize, ApInfo^.FSrcDataType, ApInfo^.FOutDataType);

    // get, convert and set parameter value
    AParam.GetData(FBuffer.Ptr, AArrIndex);
    AFmtOpts.ConvertRawData(ApInfo^.FSrcDataType, ApInfo^.FOutDataType,
      FBuffer.Ptr, iSrcSize, FBuffer.FBuffer, FBuffer.Size, iSize,
      ADSConnection.FConnection.Encoder);
    AAdsParam.SetData(FBuffer.Ptr, iSize);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.SetParamValues(AArrIndex: Integer = 0);
var
  oFmtOpts: TADFormatOptions;
  oParams: TADParams;
  oParam: TADParam;
  oAdsParam: TADSVariable;
  i: Integer;
  pParInfo: PADAdsParInfoRec;
begin
  oParams := GetParams;
  if oParams.Count = 0 then
    Exit;

  oFmtOpts := GetOptions.FormatOptions;
  for i := 0 to Length(FParInfos) - 1 do begin
    pParInfo := @FParInfos[i];
    oParam := oParams[pParInfo^.FParamIndex];
    if (pParInfo^.FAdsParamIndex <> -1) and
       (oParam.DataType <> ftCursor) and
       (oParam.ParamType in [ptInput, ptInputOutput, ptUnknown]) then begin
      oAdsParam := FStmt.Params[pParInfo^.FAdsParamIndex];
      CheckParamMatching(oParam, pParInfo^.FSrcFieldType, pParInfo^.FParamType, 0);
      SetParamValue(oFmtOpts, oParam, oAdsParam, pParInfo, AArrIndex);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.GetParamValues(AArrIndex: Integer = 0);
var
  oTab: TADDatSTable;
  i: Integer;
  oParams: TADParams;
  oPar: TADParam;
  ePrevState: TADPhysCommandState;
begin
  oParams := GetParams;
  if (FCursor = nil) or (oParams.Count = 0) then
    Exit;

  SetupCursor(FCursor);
  FCursor.AddColumns;
  if FCursor.Columns.Count = 0 then
    Exit;

  CreateColInfos;

  oTab := TADDatSTable.Create;
  oTab.Setup(FOptions);
  ePrevState := GetState;
  SetState(csOpen);
  try
    Define(oTab);
    if oTab.Columns.Count > 0 then begin
      FetchRow(oTab, nil);
      // SP parameters are binded by name
      for i := 0 to oTab.Columns.Count - 1 do begin
        oPar := oParams.FindParam(oTab.Columns[i].Name);
        if (oPar <> nil) and (oPar.ParamType in [ptOutput, ptInputOutput, ptResult]) then
          oPar.Values[AArrIndex] := oTab.Rows[0].GetData(i);
      end;
    end;
  finally
    SetState(ePrevState);
    ADFree(oTab);
    DestroyColInfos;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.InternalUseStandardMetadata: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.InternalColInfoStart(
  var ATabInfo: TADPhysDataTableInfo): Boolean;
begin
  Result := OpenBlocked;
  if ATabInfo.FSourceID = -1 then begin
    ATabInfo.FSourceName := GetCommandText;
    ATabInfo.FSourceID := 1;
    FColIndex := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.InternalColInfoGet(
  var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  pColInfo: PADAdsColInfoRec;
begin
  if FColIndex < Length(FColInfos) then begin
    pColInfo := @FColInfos[FColIndex];

    AColInfo.FSourceName := pColInfo^.FName;
    AColInfo.FSourceID := pColInfo^.FPos;
    AColInfo.FSourceType := pColInfo^.FSrcDataType;
    AColInfo.FOriginTabName.FSchema := '';
    AColInfo.FOriginTabName.FObject := '';
    AColInfo.FOriginColName := '';
    AColInfo.FType := pColInfo^.FDestDataType;
    AColInfo.FLen := pColInfo^.FADLen;
    AColInfo.FPrec := pColInfo^.FPrec;
    AColInfo.FScale := pColInfo^.FScale;
    AColInfo.FAttrs := pColInfo^.FAttrs;
    AColInfo.FForceAddOpts := [];
    if pColInfo^.FInPK then
      Include(AColInfo.FForceAddOpts, coInKey);

    Inc(FColIndex);
    Result := True;
  end
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.InternalExecute(ATimes, AOffset: Integer;
  var ACount: TADCounter);
var
  i, iArraySize: Integer;
  iTimes: Integer;
  iCount: TADCounter;
begin
  if ATimes - AOffset > 1 then begin
    iArraySize := GetParams.ArraySize;
    if ATimes > iArraySize then
      iTimes := iArraySize
    else
      iTimes := ATimes;
    for i := AOffset to iTimes - 1 do begin
      iCount := 0;
      InternalExecute(i + 1, i, iCount);
      Inc(ACount, iCount);
    end;
  end

  else begin
    SetParamValues(AOffset);
    ADSConnection.FConnection.EnableAbort;
    try
      try
        if UseExecDirect then
          FStmt.ExecuteDirect(FDbCommandText)
        else
          FStmt.Execute;
      except
        on E: EAdsNativeException do begin
          E.Errors[0].RowIndex := AOffset;
          raise;
        end;
      end;
    finally
      ADSConnection.FConnection.DisableAbort;
      Inc(ACount, FStmt.RecordCount);
    end;
    FCursor := FStmt.GetCursor;
    if FCursor <> nil then
      try
        GetParamValues;
      finally
        InternalClose;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.InternalOpen: Boolean;
begin
  Result := False;
  if (GetMetaInfoKind <> mkNone) and (FDbCommandText = '') then
    Exit;
  ADSConnection.FConnection.EnableAbort;
  try
    SetParamValues;
    try
      if UseExecDirect then
        FStmt.ExecuteDirect(FDbCommandText)
      else
        FStmt.Execute;
      FCursor := FStmt.GetCursor;
      if FCursor <> nil then begin
        SetupCursor(FCursor);
        CreateColInfos;
        Result := Length(FColInfos) > 0;
      end;
    except
      on E: Exception do begin
        InternalClose;
        if not ((GetMetaInfoKind <> mkNone) and
                (E is EADSNativeException) and
                (EADSNativeException(E).Kind = ekObjNotExists)) then
          raise;
      end;
    end;
  finally
    ADSConnection.FConnection.DisableAbort;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.InternalNextRecordSet: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
var
  oRow: TADDatSRow;
  oFmtOpts: TADFormatOptions;
  pColInfo: PADAdsColInfoRec;
  j: Integer;
  lMetadata: Boolean;
  oCol: TADDatSColumn;

  procedure ProcessColumn(AColIndex: Integer; ARow: TADDatSRow;
    ApInfo: PADAdsColInfoRec);
  var
    iSize: Integer;
    iDestSize: LongWord;
    lIsVal: Boolean;
    oVar: TADSVariable;
  begin
    iSize := 0;
    oVar := ApInfo^.FVar;
    if (oVar = nil) or not CheckFetchColumn(ApInfo^.FSrcDataType, ApInfo^.FAttrs) then
      Exit

    // null
    else if oVar.IsNull then
      lIsVal := False

    // conversion is not required
    else if ApInfo^.FSrcDataType = ApInfo^.FDestDataType then begin
      if ApInfo^.FSrcDataType in C_AD_BlobTypes then
        iSize := oVar.GetDataLength
      else
        iSize := ApInfo^.FLen;
      FBuffer.Check((iSize + 1) * SizeOf(WideChar));
      lIsVal := oVar.GetData(FBuffer.FBuffer, iSize);
      if lIsVal then
        ARow.SetData(AColIndex, FBuffer.Ptr, iSize);
    end

    // conversion is required
    else begin
      if ApInfo^.FSrcDataType in C_AD_BlobTypes then
        iSize := oVar.GetDataLength
      else
        iSize := ApInfo^.FLen;
      FBuffer.Check((iSize + 1) * SizeOf(WideChar));
      lIsVal := oVar.GetData(FBuffer.FBuffer, iSize);
      if lIsVal then begin
        iDestSize := 0;
        oFmtOpts.ConvertRawData(ApInfo^.FSrcDataType, ApInfo^.FDestDataType,
          FBuffer.Ptr, iSize, FBuffer.FBuffer, FBuffer.Size, iDestSize,
          ADSConnection.FConnection.Encoder);
        ARow.SetData(AColIndex, FBuffer.Ptr, iDestSize);
      end;
    end;
    if not lIsVal then
      ARow.SetData(AColIndex, nil, 0);
  end;

  procedure ProcessMetaColumn(AColIndex: Integer; ARow: TADDatSRow;
    ApInfo: PADAdsColInfoRec);
  var
    iSize: Integer;
    iDestSize: Longword;
    lIsVal: Boolean;
    oVar: TADSVariable;
  begin
    iSize := 0;
    oVar := ApInfo^.FVar;
    if oVar = nil then
      Exit

    else if AColIndex = 0 then begin
      lIsVal := True;
      ARow.SetData(0, ATable.Rows.Count + 1);
    end

    else if oVar.IsNull then
      lIsVal := False

    else begin
      FBuffer.Check((ApInfo^.FLen + 1) * SizeOf(WideChar));
      lIsVal := oVar.GetData(FBuffer.FBuffer, iSize);
      if lIsVal then begin
        iDestSize := 0;
        if (ApInfo^.FDestDataType in C_AD_AnsiTypes) or
           (ApInfo^.FDestDataType in [dtInt16, dtInt32, dtDouble, dtBCD, dtFmtBCD]) then
          oFmtOpts.ConvertRawData(ApInfo^.FDestDataType, ATable.Columns[AColIndex].DataType,
            FBuffer.Ptr, iSize, FBuffer.FBuffer, FBuffer.Size, iDestSize,
            ADSConnection.FConnection.Encoder)
        else
          iDestSize := iSize;
        ARow.SetData(AColIndex, FBuffer.Ptr, iDestSize);
      end;
    end;
    if not lIsVal then
      ARow.SetData(AColIndex, nil, 0)
  end;

begin
  oFmtOpts := FOptions.FormatOptions;
  oRow := ATable.NewRow(False);
  lMetadata := GetMetaInfoKind <> mkNone;
  try
    for j := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[j];
      if oCol.SourceID > 0 then begin
        pColInfo := @FColInfos[oCol.SourceID - 1];
        if lMetadata then
          ProcessMetaColumn(j, oRow, pColInfo)
        else
          ProcessColumn(j, oRow, pColInfo);
      end;
    end;
    if AParentRow <> nil then begin
      oRow.ParentRow := AParentRow;
      AParentRow.Fetched[ATable.Columns.ParentCol] := True;
    end;
    ATable.Rows.Add(oRow);
  except
    ADFree(oRow);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.FetchMetaRow(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowNo: Integer): Boolean;
var
  oRow: TADDatSRow;
  iRecNo: Integer;
  lDeleteRow: Boolean;
  pData: Pointer;
  i, iSize: Integer;
  eTableKind: TADPhysTableKind;
  eScope: TADPhysObjectScope;
  eAttrs: TADDataAttributes;
  {iAdsType,} iAdsSize, iAdsDec: Integer;
  iLen: LongWord;
  iPrec, iScale: Integer;
  eType: TADDataType;
  eIndKind: TADPhysIndexKind;
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
  eCascade: TADPhysCascadeRuleKind;
  eProcKind: TADPhysProcedureKind;
  eParType: TParamType;
  s: String;

  procedure DecodeColInfo(ASQLDataType: String; ASQLLen, ASQLScale: Integer;
    out AType: TADDataType; var AAttrs: TADDataAttributes; out ALen: LongWord;
    out APrec, AScale: Integer);
  begin
    AType := dtUnknown;
    ALen := 0;
    APrec := 0;
    AScale := 0;
    Exclude(AAttrs, caFixedLen);
    Exclude(AAttrs, caBlobData);
    Include(AAttrs, caSearchable);
    if (ASQLDataType = 'SHORT') or (ASQLDataType = 'SHORTINT') then
      AType := dtInt16
    else if (ASQLDataType = 'INTEGER') or (ASQLDataType = 'Integer') then
      AType := dtInt32
    else if ASQLDataType = 'LONG' then
      AType := dtInt64
    else if ASQLDataType = 'AUTOINC' then begin
      AType := dtInt32;
      AAttrs := AAttrs + [caAutoInc];
    end
    else if ASQLDataType = 'ROWVERSION' then begin
      AType := dtInt64;
      AAttrs := AAttrs + [caRowVersion, caReadOnly];
    end
    else if ASQLDataType = 'DOUBLE' then begin
      AType := dtDouble;
    end
    else if ASQLDataType = 'CURDOUBLE' then begin
      AType := dtCurrency;
      APrec := 15;
      AScale := 4;
    end
    else if (ASQLDataType = 'MONEY') or (ASQLDataType = 'Money') then begin
      AType := dtCurrency;
      APrec := 19;
      AScale := 4;
    end
    else if (ASQLDataType = 'NUMERIC') or (ASQLDataType = 'Numeric') then begin
      if (ASQLLen - 2 > 18) or (ASQLScale > 4) then
        AType := dtBCD
      else
        AType := dtFmtBCD;
      APrec := ASQLLen - 2;
      AScale := ASQLScale;
    end
    else if (ASQLDataType = 'CHAR') or (ASQLDataType = 'CHARACTER') or
            (ASQLDataType = 'CICHAR') or (ASQLDataType = 'CICHARACTER') then begin
      AType := dtAnsiString;
      AAttrs := AAttrs + [caFixedLen];
      ALen := ASQLLen;
    end
    else if (ASQLDataType = 'VARCHAR') or (ASQLDataType = 'VARCHARFOX') then begin
      AType := dtAnsiString;
      ALen := ASQLLen;
    end
    else if ASQLDataType = 'NCHAR' then begin
      AType := dtWideString;
      AAttrs := AAttrs + [caFixedLen];
      ALen := ASQLLen;
    end
    else if ASQLDataType = 'NVARCHAR' then begin
      AType := dtWideString;
      ALen := ASQLLen;
    end
    else if (ASQLDataType = 'MEMO') or (ASQLDataType = 'Memo') then begin
      AType := dtMemo;
      AAttrs := AAttrs + [caBlobData] - [caSearchable];
    end
    else if ASQLDataType = 'NMEMO' then begin
      AType := dtWideMemo;
      AAttrs := AAttrs + [caBlobData] - [caSearchable];
    end
    else if ASQLDataType = 'RAW' then begin
      AType := dtByteString;
      AAttrs := AAttrs + [caFixedLen];
      ALen := ASQLLen;
    end
    else if (ASQLDataType = 'VARBINARY') or (ASQLDataType = 'VARBINARYFOX') then begin
      AType := dtByteString;
      ALen := ASQLLen;
    end
    else if (ASQLDataType = 'BINARY') or (ASQLDataType = 'BLOB') or
            (ASQLDataType = 'IMAGE') then begin
      AType := dtBlob;
      AAttrs := AAttrs + [caBlobData] - [caSearchable];
    end
    else if (ASQLDataType = 'DATE') or
            (ASQLDataType = 'SHORTDATE') then
      AType := dtDate
    else if ASQLDataType = 'TIME' then
      AType := dtTime
    else if (ASQLDataType = 'TIMESTAMP') or
            (ASQLDataType = 'MODTIME') then
      AType := dtDateTimeStamp
    else if ASQLDataType = 'LOGICAL' then
      AType := dtBoolean;
  end;

  function GetCrsData(ACrsIndex, ARowIndex: Integer): Boolean;
  var
    pOut: Pointer;
  begin
    iSize := 0;
    Result := FCursor.Columns[ACrsIndex].GetData(pData, iSize);
    if not Result then begin
      pOut := nil;
      iSize := 0;
    end
    else if ATable.Columns[ARowIndex].DataType in C_AD_WideTypes then begin
      pOut := nil;
      iSize := FMetaEncoder.Decode(pData, iSize, pOut, ecUTF16);
    end
    else
      pOut := pData;
    oRow.SetData(ARowIndex, pOut, iSize);
  end;

begin
  lDeleteRow := False;
  iRecNo := ATable.Rows.Count + 1;
  oRow := ATable.NewRow(False);
  pData := FBuffer.Check(1024);
  try
    FConnection.CreateMetadata(oConnMeta);
    case GetMetaInfoKind of
    mkCatalogs:
      begin
        oRow.SetData(0, iRecNo);
        GetCrsData(0, 1);
        if (GetWildcard <> '') and
           not ADStrLike(VarToStr(oRow.GetData(1, rvDefault)), GetWildcard, True) then
          lDeleteRow := True;
      end;
    mkTables:
      begin
        oRow.SetData(0, iRecNo);
        GetCrsData(0, 1);
        GetCrsData(1, 2);
        GetCrsData(2, 3);
        iSize := 0;
        eTableKind := tkTable;
        eScope := osOther;
        if FCursor.Columns[3].GetData(pData, iSize) then begin
          eScope := osMy;
          s := FMetaEncoder.Decode(pData, iSize);
          if StrLIComp(PChar(s), 'TABLE', iSize) = 0 then
            eTableKind := tkTable
          else if StrLIComp(PChar(s), 'VIEW', iSize) = 0 then
            eTableKind := tkView
          else if StrLIComp(PChar(s), 'SYSTEM TABLE', iSize) = 0 then begin
            eTableKind := tkTable;
            eScope := osSystem;
          end
          else if StrLIComp(PChar(s), 'LOCAL TEMPORARY', iSize) = 0 then
            eTableKind := tkLocalTable
        end;
        oRow.SetData(4, Smallint(eTableKind));
        oRow.SetData(5, Smallint(eScope));
        lDeleteRow := not (eTableKind in GetTableKinds) or
                      not (eScope in GetObjectScopes);
      end;
    mkTableFields:
      begin
        oRow.SetData(0, iRecNo);
        GetCrsData(0, 1);
        GetCrsData(1, 2);
        GetCrsData(2, 3);
        GetCrsData(3, 4);
        iSize := 0;
        if FCursor.Columns.Count >= 17 then begin
          if FCursor.Columns[16].GetData(pData, iSize) then
            oRow.SetData(5, PInteger(pData)^);
        end
        else
          oRow.SetData(5, iRecNo);
        eAttrs := [caBase];
        iSize := 0;
        if FCursor.Columns[5].GetData(pData, iSize) then begin
          s := FMetaEncoder.Decode(pData, iSize);
          if StrLIComp(PChar(s), 'AUTOINC', iSize) = 0 then begin
            Include(eAttrs, caAutoInc);
            Include(eAttrs, caReadOnly);
          end
          else if StrLIComp(PChar(s), 'ROWVERSION', iSize) = 0 then begin
            Include(eAttrs, caRowVersion);
            Include(eAttrs, caReadOnly);
          end;
          oRow.SetData(7, pData, iSize);
        end;
        iSize := 0;
        if FCursor.Columns.Count >= 13 then
          if FCursor.Columns[12].GetData(pData, iSize) and (iSize > 0) then begin
            s := FMetaEncoder.Decode(pData, iSize);
            if StrLIComp(PChar(s), 'NULL', iSize) <> 0 then
              Include(eAttrs, caDefault);
          end;
        iSize := 0;
        if not FCursor.Columns[10].GetData(pData, iSize) or
           (PSIGNED16(pData)^ <> 0) then
          Include(eAttrs, caAllowNull);
        iSize := 0;
        { if FCursor.Columns[4].GetData(pData, iSize) then
          iAdsType := PSIGNED16(pData)^
        else
          iAdsType := 0; }
        iSize := 0;
        if FCursor.Columns[6].GetData(pData, iSize) then
          iAdsSize := PSIGNED32(pData)^
        else
          iAdsSize := 0;
        iSize := 0;
        if FCursor.Columns[8].GetData(pData, iSize) then
          iAdsDec := PSIGNED16(pData)^
        else
          iAdsDec := 0;
        DecodeColInfo(oRow.GetData(7), iAdsSize, iAdsDec, eType, eAttrs,
          iLen, iPrec, iScale);
        oRow.SetData(6, Smallint(eType));
        oRow.SetData(8, PWord(@eAttrs)^);
        oRow.SetData(9, iPrec);
        oRow.SetData(10, iScale);
{$IFDEF AnyDAC_D6Base}
        oRow.SetData(11, iLen);
{$ELSE}
        oRow.SetData(11, Integer(iLen));
{$ENDIF}
      end;
    mkIndexes:
      begin
        iSize := 0;
        if FCursor.Columns[6].GetData(pData, iSize) and
           (PSIGNED16(pData)^ = 0) then
          lDeleteRow := True
        else begin
          oRow.SetData(0, iRecNo);
          GetCrsData(0, 1);
          GetCrsData(1, 2);
          GetCrsData(2, 3);
          GetCrsData(5, 4);
          iSize := 0;
          if FCursor.Columns[3].GetData(pData, iSize) and
             (PWordBool(pData)^ = False) then
            eIndKind := ikUnique
          else
            eIndKind := ikNonUnique;
          FMetainfoAddonView.RowFilter := 'INDEX_NAME = ''' + VarToStr(oRow.GetData(4)) + '''';
          if FMetainfoAddonView.Rows.Count > 0 then begin
            eIndKind := ikPrimaryKey;
            oRow.SetData(5, FMetainfoAddonView.Rows[0].GetData(5));
          end;
          oRow.SetData(6, Smallint(eIndKind));
          FMetainfoAddonView.RowFilter := '';
          for i := 0 to ATable.Rows.Count - 1 do
            if (VarToStr(ATable.Rows[i].GetData(1, rvDefault)) = VarToStr(oRow.GetData(1, rvDefault))) and
               (VarToStr(ATable.Rows[i].GetData(2, rvDefault)) = VarToStr(oRow.GetData(2, rvDefault))) and
               (VarToStr(ATable.Rows[i].GetData(3, rvDefault)) = VarToStr(oRow.GetData(3, rvDefault))) and
               (VarToStr(ATable.Rows[i].GetData(4, rvDefault)) = VarToStr(oRow.GetData(4, rvDefault))) then begin
              lDeleteRow := True;
              Break;
            end;
          if not lDeleteRow and (GetWildcard <> '') and
             not ADStrLike(VarToStr(oRow.GetData(4, rvDefault)), GetWildcard, True) then
            lDeleteRow := True;
        end;
      end;
    mkIndexFields:
      begin
        iSize := 0;
        if FCursor.Columns[6].GetData(pData, iSize) and
           (PSIGNED16(pData)^ = 0) then
          lDeleteRow := True
        else begin
          oRow.SetData(0, iRecNo);
          GetCrsData(0, 1);
          GetCrsData(1, 2);
          GetCrsData(2, 3);
          GetCrsData(5, 4);
          GetCrsData(8, 5);
          iSize := 0;
          if FCursor.Columns[7].GetData(pData, iSize) then
            oRow.SetData(6, PSIGNED16(pData)^);
          GetCrsData(9, 7);
          GetCrsData(12, 8);
          oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self,
            [doNormalize, doUnquote]);
          lDeleteRow := (AnsiCompareText(rName.FObject,
            Trim(VarToStr(oRow.GetData(4, rvDefault)))) <> 0);
          if not lDeleteRow and (GetWildcard <> '') and
             not ADStrLike(VarToStr(oRow.GetData(5, rvDefault)), GetWildcard, True) then
            lDeleteRow := True;
        end;
      end;
    mkPrimaryKey:
      begin
        oRow.SetData(0, iRecNo);
        GetCrsData(0, 1);
        GetCrsData(1, 2);
        GetCrsData(2, 3);
        iSize := 0;
        if FCursor.Columns.Count >= 6 then begin
          GetCrsData(5, 4);
          GetCrsData(5, 5);
        end;
        oRow.SetData(6, Smallint(ikPrimaryKey));
        for i := 0 to ATable.Rows.Count - 1 do
          if (VarToStr(ATable.Rows[i].GetData(1, rvDefault)) = VarToStr(oRow.GetData(1, rvDefault))) and
             (VarToStr(ATable.Rows[i].GetData(2, rvDefault)) = VarToStr(oRow.GetData(2, rvDefault))) and
             (VarToStr(ATable.Rows[i].GetData(3, rvDefault)) = VarToStr(oRow.GetData(3, rvDefault))) and
             (VarToStr(ATable.Rows[i].GetData(5, rvDefault)) = VarToStr(oRow.GetData(5, rvDefault))) then begin
            lDeleteRow := True;
            Break;
          end;
        if not lDeleteRow and (GetWildcard <> '') and
           not ADStrLike(VarToStr(oRow.GetData(4, rvDefault)), GetWildcard, True) then
          lDeleteRow := True;
      end;
    mkPrimaryKeyFields:
      begin
        oRow.SetData(0, iRecNo);
        GetCrsData(0, 1);
        GetCrsData(1, 2);
        GetCrsData(2, 3);
        if FCursor.Columns.Count >= 6 then
          GetCrsData(5, 4);
        GetCrsData(3, 5);
        iSize := 0;
        if FCursor.Columns[4].GetData(pData, iSize) then
          oRow.SetData(6, PSIGNED16(pData)^);
        oRow.SetData(7, 'A');
        if not lDeleteRow and (GetWildcard <> '') and
           not ADStrLike(VarToStr(oRow.GetData(5, rvDefault)), GetWildcard, True) then
          lDeleteRow := True;
      end;
    mkForeignKeys:
      begin
        oRow.SetData(0, iRecNo);
        GetCrsData(4, 1);
        GetCrsData(5, 2);
        GetCrsData(6, 3);
        GetCrsData(11, 4);
        GetCrsData(0, 5);
        GetCrsData(1, 6);
        GetCrsData(2, 7);
        iSize := 0;
        if FCursor.Columns[10].GetData(pData, iSize) then begin
          eCascade := ckNone;
          case PSIGNED16(pData)^ of
          0: eCascade := ckCascade;
          2: eCascade := ckSetNull;
          3: eCascade := ckRestrict;
          4: eCascade := ckSetDefault;
          end;
          oRow.SetData(8, SmallInt(eCascade));
        end;
        iSize := 0;
        if FCursor.Columns[9].GetData(pData, iSize) then begin
          eCascade := ckNone;
          case PSIGNED16(pData)^ of
          0: eCascade := ckCascade;
          2: eCascade := ckSetNull;
          3: eCascade := ckRestrict;
          4: eCascade := ckSetDefault;
          end;
          oRow.SetData(9, SmallInt(eCascade));
        end;
        for i := 0 to ATable.Rows.Count - 1 do
          if (VarToStr(ATable.Rows[i].GetData(1, rvDefault)) = VarToStr(oRow.GetData(1, rvDefault))) and
             (VarToStr(ATable.Rows[i].GetData(2, rvDefault)) = VarToStr(oRow.GetData(2, rvDefault))) and
             (VarToStr(ATable.Rows[i].GetData(3, rvDefault)) = VarToStr(oRow.GetData(3, rvDefault))) and
             (VarToStr(ATable.Rows[i].GetData(4, rvDefault)) = VarToStr(oRow.GetData(4, rvDefault))) then begin
            lDeleteRow := True;
            Break;
          end;
        if not lDeleteRow and (GetWildcard <> '') and
           not ADStrLike(VarToStr(oRow.GetData(4, rvDefault)), GetWildcard, True) then
          lDeleteRow := True;
      end;
    mkForeignKeyFields:
      begin
        oRow.SetData(0, iRecNo);
        GetCrsData(4, 1);
        GetCrsData(5, 2);
        GetCrsData(6, 3);
        GetCrsData(11, 4);
        GetCrsData(7, 5);
        GetCrsData(3, 6);
        GetCrsData(8, 7);
        oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self,
          [doNormalize, doUnquote]);
        lDeleteRow := (AnsiCompareText(rName.FObject,
          Trim(VarToStr(oRow.GetData(4, rvDefault)))) <> 0);
        if not lDeleteRow and (GetWildcard <> '') and
           not ADStrLike(VarToStr(oRow.GetData(5, rvDefault)), GetWildcard, True) then
          lDeleteRow := True;
      end;
    mkProcs:
      begin
        oRow.SetData(0, iRecNo);
        GetCrsData(0, 1);
        GetCrsData(1, 2);
        GetCrsData(2, 4);
        iSize := 0;
        if FCursor.Columns[7].GetData(pData, iSize) and
           (PSIGNED16(pData)^ = 2) then
          eProcKind := pkFunction
        else
          eProcKind := pkProcedure;
        oRow.SetData(6, Smallint(eProcKind));
        eScope := osMy;
        oRow.SetData(7, Smallint(eScope));
        iSize := 0;
        if FCursor.Columns[3].GetData(pData, iSize) then
          if PInteger(pData)^ = -1 then
            oRow.SetData(8, 0)
          else
            oRow.SetData(8, PInteger(pData)^);
        iSize := 0;
        if FCursor.Columns[4].GetData(pData, iSize) then
          if PInteger(pData)^ = -1 then
            oRow.SetData(9, 0)
          else
            oRow.SetData(9, PInteger(pData)^);
        lDeleteRow := not (eScope in GetObjectScopes);
        if not lDeleteRow and (GetWildcard <> '') and
           not ADStrLike(VarToStr(oRow.GetData(4, rvDefault)), GetWildcard, True) then
          lDeleteRow := True;
      end;
    mkProcArgs:
      begin
        oRow.SetData(0, iRecNo);
        GetCrsData(0, 1);
        GetCrsData(1, 2);
        GetCrsData(2, 4);
        GetCrsData(3, 6);
        oRow.SetData(7, iRecNo);
        eParType := ptUnknown;
        iSize := 0;
        if FCursor.Columns[4].GetData(pData, iSize) then
          case PSIGNED16(pData)^ of
          1:    eParType := ptInput;
          2:    eParType := ptInputOutput;
          3, 4: eParType := ptOutput;
          5:    eParType := ptResult;
          end;
        oRow.SetData(8, Smallint(eParType));
        GetCrsData(6, 10);
        eAttrs := [];
        iSize := 0;
        if not FCursor.Columns[11].GetData(pData, iSize) or
           (PSIGNED16(pData)^ <> 0) then
          Include(eAttrs, caAllowNull);
        iSize := 0;
        { if FCursor.Columns[5].GetData(pData, iSize) then
          iAdsType := PSIGNED16(pData)^
        else
          iAdsType := 0; }
        iSize := 0;
        if FCursor.Columns[7].GetData(pData, iSize) then
          iAdsSize := PInteger(pData)^
        else
          iAdsSize := 0;
        iSize := 0;
        if FCursor.Columns[9].GetData(pData, iSize) then
          iAdsDec := PSIGNED16(pData)^
        else
          iAdsDec := 0;
        DecodeColInfo(oRow.GetData(10), iAdsSize, iAdsDec, eType, eAttrs,
          iLen, iPrec, iScale);
        oRow.SetData(9, Smallint(eType));
        oRow.SetData(11, PWord(@eAttrs)^);
        oRow.SetData(12, iPrec);
        oRow.SetData(13, iScale);
{$IFDEF AnyDAC_D6Base}
        oRow.SetData(14, iLen);
{$ELSE}
        oRow.SetData(14, Integer(iLen));
{$ENDIF}
      end;
    end;
    if lDeleteRow then begin
      ADFree(oRow);
      Result := False;
    end
    else begin
      ATable.Rows.Add(oRow);
      Result := True;
    end;
  except
    ADFree(oRow);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysADSCommand.InternalFetchRowSet(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowsetSize: LongWord): LongWord;
var
  i: LongWord;
begin
  Result := 0;
  if not (GetMetaInfoKind in [mkNone, mkPackages]) and
     (ADSConnection.FServerVersion < caADS10) then
    for i := 1 to ARowsetSize do begin
      if FCursor.Eof then
        Break;
      if FetchMetaRow(ATable, AParentRow, Result + 1) then
        Inc(Result);
      FCursor.Skip(1);
    end
  else
    for i := 1 to ARowsetSize do begin
      if FCursor.Eof then
        Break;
      case GetCommandKind of
      skSelectForLock:   FCursor.Lock(0);
      skSelectForUnLock: FCursor.UnLock(0);
      end;
      FetchRow(ATable, AParentRow);
      Inc(Result);
      FCursor.Skip(1);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.InternalAbort;
begin
  ADSConnection.FConnection.Abort;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.InternalClose;
begin
  if FCursor <> nil then
    ADFreeAndNil(FCursor);
  if FStmt <> nil then
    FStmt.Close;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysADSCommand.InternalUnprepare;
begin
  if FStmt = nil then
    Exit;
  FStmt.Unprepare;
  DestroyColInfos;
  DestroyParamInfos;
  ReleaseStatement(FStmt);
  FMetainfoAddonView := nil;
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysADSDriver);

end.
