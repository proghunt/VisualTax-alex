{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                   FireDAC utilities                   }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADStanUtil;

interface

uses
{$IFDEF POSIX}
  Posix.String_,
{$ENDIF}
{$IFDEF UNIX}
  Unix, types,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows, Registry, ShellApi, ShlObj, ComObj, ActiveX,
{$ENDIF}
  IniFiles, SysUtils, Classes, SyncObjs,
{$IFDEF AnyDAC_D6Base}
  Variants, FmtBCD,
  {$IFDEF AnyDAC_D6}
  SqlTimSt,
  {$ENDIF}
{$ENDIF}
  uADStanIntf;

const
{$IFNDEF AnyDAC_D6Base}
  soBeginning = soFromBeginning;
  soEnd = soFromEnd;
{$ENDIF}

{$IFNDEF MSWINDOWS}
  LOCALE_USER_DEFAULT = 1024;
  INFINITE = LongWord($FFFFFFFF);
  E_NOINTERFACE = HRESULT($80004002);
{$ENDIF}

{$IFNDEF AnyDAC_D7}
  {$EXTERNALSYM CSTR_LESS_THAN}
  CSTR_LESS_THAN = 1;         { string 1 less than string 2 }
  {$EXTERNALSYM CSTR_EQUAL}
  CSTR_EQUAL = 2;             { string 1 equal to string 2 }
  {$EXTERNALSYM CSTR_GREATER_THAN}
  CSTR_GREATER_THAN = 3;      { string 1 greater than string 2 }
  {$EXTERNALSYM CP_THREAD_ACP}
  CP_THREAD_ACP = 3;
{$ENDIF}

  C_AD_AESBlockSize = 16;
  C_AD_AESContextSize = 282;

type
  TADMachineType = (mtUnknown, mt32Bit, mt64Bit, mtOther);
const
  mtNative = {$IFDEF AnyDAC_32} mt32Bit {$ENDIF}
             {$IFDEF AnyDAC_64} mt64Bit {$ENDIF};
  C_AD_MachineTypes: array[TADMachineType] of String =
    ('Unknown', '32Bit', '64Bit', 'Other');

type
  TADFileStream = class;
  TADReadSharedMemoryStream = class;
  TADThreadMsgBase = class;
  TADThread = class;
{$IFDEF AnyDAC_ASM}
  TADMethodThunk = class;
{$ENDIF}
  TADRefCounter = class;
  TADBuffer = class;
  TADEncoder = class;
  TADTextFile = class;
  TADLog = class;
  TADLibrary = class;
  TADConfigFile = class;
  TADIniFile = class;

  TADFileStream = class(TFileStream)
  private
    FModified: Boolean;
    FBuffer: PADByteString;
    FStreamBufferSize: word;
    FPos, FBufStart, FBufEnd: Int64;
  public
    constructor Create(const AFileName: string; AMode: Word; AStreamBufferSize: Word = $7FFF);
    destructor Destroy; override;
    procedure SyncBuffer(AReRead: Boolean);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  {$IFDEF AnyDAC_D6Base}
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
  {$ENDIF}
  end;

  TADReadSharedMemoryStream = class(TMemoryStream)
  public
    destructor Destroy; override;
    procedure SetData(APtr: Pointer; ASize: Longint);
  end;

  TADThreadMsgClass = class of TADThreadMsgBase;
  TADThreadMsgBase = class(TObject)
  public
    constructor Create; overload; virtual;
    function Perform(AThread: TADThread): Boolean; virtual;
  end;

  TADThreadStartMsg = class(TADThreadMsgBase)
  public
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADThreadStopMsg = class(TADThreadStartMsg)
  end;

  TADThreadTerminateMsg = class (TADThreadMsgBase)
  public
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADThread = class(TThread)
  private
    FActive: Boolean;
    FStartupTimeout: LongWord;
    FIdleTimeout: LongWord;
    FMessages: TADThreadObjList;
    FControlEvent: TEvent;
    FMessageEvent: TEvent;
{$IFNDEF AnyDAC_D12}
    FFinished: Boolean;
{$ENDIF}
    procedure SetActive(AValue: Boolean);
    procedure EnqueueControlMsg(AMsg: TADThreadMsgBase);
  protected
{$IFNDEF AnyDAC_D12}
    procedure DoTerminate; override;
{$ENDIF}
    procedure Execute; override;
    function DoAllowTerminate: Boolean; virtual;
    procedure DoIdle; virtual;
    procedure DoTimeout; virtual;
    procedure DoActiveChanged; virtual;
    class function GetStartMsgClass: TADThreadMsgClass; virtual;
    class function GetStopMsgClass: TADThreadMsgClass; virtual;
    class function GetTerminateMsgClass: TADThreadMsgClass; virtual;
    property Messages: TADThreadObjList read FMessages;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Shutdown(AWait: Boolean = True);
    procedure Ping;
    procedure EnqueueMsg(AMsg: TADThreadMsgBase);
    class procedure Synchronize(AMethod: TThreadMethod); overload;
    property StartupTimeout: LongWord read FStartupTimeout write FStartupTimeout;
    property IdleTimeout: LongWord read FIdleTimeout write FIdleTimeout;
    property Active: Boolean read FActive write SetActive;
{$IFNDEF AnyDAC_D12}
    property Finished: Boolean read FFinished;
{$ENDIF}
  end;

{$IFDEF AnyDAC_FPC}
  PADThreadInfo = ^TADThreadInfo;
  TADThreadInfo = record
    Next: PADThreadInfo;
    ThreadID: TADThreadID;
    Active: Integer;
    RecursionCount: Cardinal;
  end;

  TADThreadLocalCounter = class
  private
    FHashTable: array [0..15] of PADThreadInfo;
    function HashIndex: Byte;
    function Recycle: PADThreadInfo;
  public
    destructor Destroy; override;
    procedure Open(var Thread: PADThreadInfo);
    procedure Delete(var Thread: PADThreadInfo);
    procedure Close(var Thread: PADThreadInfo);
  end;

  TADMREWSynchronizer = class(TInterfacedObject, IReadWriteSync)
  private
    FSentinel: Integer;
    FReadSignal: TEvent;
    FWriteSignal: TEvent;
    FWaitRecycle: Cardinal;
    FWriteRecursionCount: Cardinal;
    tls: TADThreadLocalCounter;
    FWriterID: TADThreadID;
    FRevisionLevel: Cardinal;
    procedure BlockReaders;
    procedure UnblockReaders;
    procedure UnblockOneWriter;
    procedure WaitForReadSignal;
    procedure WaitForWriteSignal;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BeginRead;
    procedure EndRead;
    function BeginWrite: Boolean;
    procedure EndWrite;
    property RevisionLevel: Cardinal read FRevisionLevel;
  end;
{$ELSE}
  TADMREWSynchronizer = TMultiReadExclusiveWriteSynchronizer;
{$ENDIF}

{$IFDEF AnyDAC_ASM}
  TADMethodThunk = class(TObject)
  private
    FCallAddress: Pointer;
    FProcPtr: Pointer;
    FSavedFlag: LongWord;
    FSelfPtr: Pointer;
    function GetCallAddress: Pointer;
  public
    constructor Create(ApSelf, ApProc: Pointer);
    destructor Destroy; override;
    procedure Clear;
    property CallAddress: Pointer read GetCallAddress;
  end;
{$ENDIF}

  TADTimerOption = (toSynchronized, toSingleFire, toImmediateFire);
  TADTimerOptions = set of TADTimerOption;
  TADTimerState = (tsDisabled, tsWaiting, tsRaised, tsReqRemove);
  TADTimer = class(TComponent)
  private
    FInterval: LongWord;
    FEnabled: Boolean;
    FOptions: TADTimerOptions;
    FOnTimer: TThreadMethod;
    FData: TObject;
    procedure SetInterval(AValue: Longword);
    procedure SetEnabled(AValue: Boolean);
    procedure Update;
    function GetState: TADTimerState;
    class procedure CheckPool;
  protected
    procedure Loaded; override;
    procedure DoFire; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Schedule(AInterval: Longword);
    procedure Fire;
    class procedure LockTimers;
    class procedure UnLockTimers;
    class procedure Shutdown;
    property State: TADTimerState read GetState;
  published
    property Interval: Longword read FInterval write SetInterval default 1000;
    property Enabled: Boolean read FEnabled write SetEnabled default False;
    property Options: TADTimerOptions read FOptions write FOptions default [];
    property OnTimer: TThreadMethod read FOnTimer write FOnTimer;
  end;

  TADRefCounter = class(TObject)
  private
    FRefs: Integer;
    FOwner: TObject;
  public
    constructor Create(AOwner: TObject);
    destructor Destroy; override;
    procedure CountRef(AInit: Integer = 1); {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    procedure AddRef; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    procedure RemRef; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    property Refs: Integer read FRefs;
  end;

  TADBuffer = class(TObject)
  public
    FBuffer: Pointer;
    FBufferSize: LongWord;
    constructor Create;
    destructor Destroy; override;
    function Extend(ASrcDataLen: LongWord; var ADestDataLen: LongWord;
      ASrcType, ADestType: TADDataType): Pointer;
    function Check(ALen: LongWord = 0): Pointer;
    procedure Release;
    property Ptr: Pointer read FBuffer;
    property Size: LongWord read FBufferSize;
  end;

  TADEncoder = class(TObject)
  private
    FBuffer: TADBuffer;
    FOwnBuffer: Boolean;
    FEncoding: TADEncoding;
    function GetPreamble: TADByteString;
    function Alloc(ALen: LongWord): Pointer; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    procedure Release(APtr: Pointer); {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    class procedure SetBytes(var AStr: TADByteString; AValue: Pointer;
      ALen, ATrailerLen: Integer);
    class procedure SetTrailerBytes(var AStr: TADByteString; AAppend: Boolean;
      ATrailerLen: Integer);
    { TODO -cUTIL : Replace Win32 calls with these ones. They are about 20-30% faster. }
(*
    class function Utf16ToUtf8(ADest: PAnsiChar; AMaxDestBytes: Integer;
      ASource: PWideChar; ASourceChars: Integer): Integer;
    class function Utf8ToUtf16(ADest: PWideChar; AMaxDestChars: Integer;
      ASource: PAnsiChar; ASourceBytes: Integer): Integer;
*)
  public
    constructor Create(ABuffer: TADBuffer);
    destructor Destroy; override;

    function Encode(const AStr: String; ADestEncoding: TADEncoding = ecDefault): TADByteString; overload;
    function Encode(const ASrc: Pointer; ASrcLen: Integer; var ADest: Pointer;
      ASrcEncoding: TADEncoding = ecDefault; ADestEncoding: TADEncoding = ecDefault): Integer; overload;
    function Encode(const ASrc: Pointer; ASrcLen: Integer;
      ASrcEncoding: TADEncoding = ecDefault; ADestEncoding: TADEncoding = ecDefault): TADByteString; overload;
    function Decode(const ASrc: Pointer; ASrcLen: Integer; var ADest: Pointer;
      ADestEncoding: TADEncoding = ecDefault; ASrcEncoding: TADEncoding = ecDefault): Integer; overload;
    function Decode(const AStr: TADByteString; ASrcEncoding: TADEncoding = ecDefault): String; overload;
    function Decode(const ASrc: Pointer; ASrcLen: Integer = -1; ASrcEncoding: TADEncoding = ecDefault): String; overload;

    class function Deco(const ASrc: Pointer; ASrcLen: Integer = -1; ASrcEncoding: TADEncoding = ecDefault): String; overload;
    class function Deco(const ASrc: TADByteString; ASrcEncoding: TADEncoding = ecDefault): String; overload;
    class function Enco(const AStr: String; ADestEncoding: TADEncoding): TADByteString; overload;

    property Encoding: TADEncoding read FEncoding write FEncoding;
    property Preamble: TADByteString read GetPreamble;
  end;

  TADTextFile = class(TObject)
  private
    FStream: TStream;
    FStreamOwned: Boolean;
    FBuffer: TADBuffer;
    FEncoder: TADEncoder;
    FEndOfLine: TADTextEndOfLine;
    function GetPosition: Int64;
    procedure SetPosition(AValue: Int64);
  public
    constructor Create(const AFileName: String; ARead, AAppend: Boolean;
      AEncoding: TADEncoding; AEndOfLine: TADTextEndOfLine); overload;
    constructor Create(AStream: TStream; AOwned, ARead, AAppend: Boolean;
      AEncoding: TADEncoding; AEndOfLine: TADTextEndOfLine); overload;
    destructor Destroy; override;
    procedure WriteChar(const AChar: Char);
    procedure WriteText(const AText: String);
    procedure WriteLine(const AText: String);
    function ReadChar(out AChar: Char): Boolean;
    function ReadChars(out AChar: Char; ACount: Integer): Integer;
    function ReadLine: String;
    function ExtractString(AFromPosition, AToPosition: Integer): String;
    property Stream: TStream read FStream;
    property Encoder: TADEncoder read FEncoder;
    property EndOfLine: TADTextEndOfLine read FEndOfLine;
    property Position: Int64 read GetPosition write SetPosition;
  end;

  TADLog = class(TADStringList)
  private
    FLogLevel: Integer;
  public
    procedure Value(const AName, AValue: String);
    procedure Msg(const AMsg: String);
    procedure Start(const AMsg: String);
    procedure Stop;
  end;

  TADLibrary = class(TObject)
  private
    FDriverID: String;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FOwningObj: TObject;
    FProduct, FVersionName, FCopyright, FInfo: String;
    FDLLName: String;
    FFailedProcs: TStrings;
  protected
    FVersion: TADVersion;
    FVersionStr: String;
    FhDLL: THandle;
    procedure GetLibraryInfo; virtual;
    procedure LoadLibrary(const ADLLNames: array of String; ARequired: Boolean); virtual;
    function GetProc(const AProcName: String; ARequired: Boolean = True): Pointer; virtual;
    procedure LoadEntries; virtual; abstract;
  public
    constructor Create(const ADriverID: String; AOwningObj: TObject);
    destructor Destroy; override;
    procedure Load(const ADLLNames: array of String; ARequired: Boolean);
    procedure Unload; virtual;
    property DriverID: String read FDriverID;
    property OwningObj: TObject read FOwningObj;
    property hDLL: THandle read FhDLL;
    property DLLName: String read FDLLName;
    property Version: TADVersion read FVersion;
    property Product: String read FProduct;
    property VersionStr: String read FVersionStr;
    property VersionName: String read FVersionName;
    property Copyright: String read FCopyright;
    property Info: String read FInfo;
  end;

  TADConfigFile = class({$IFDEF MSWINDOWS} TRegistryIniFile
                        {$ELSE}            TMemIniFile      {$ENDIF})
{$IFNDEF MSWINDOWS}
  private
    FReadOnly: Boolean;
{$ENDIF}
  public
    constructor Create(AReadOnly: Boolean);
{$IFNDEF MSWINDOWS}
    destructor Destroy; override;
{$ENDIF}
  end;

  TADIniFile = class(TMemIniFile)
  private
    FModified: Boolean;
  public
    destructor Destroy; override;
    procedure DeleteKey(const Section, Ident: String); override;
    procedure EraseSection(const Section: string); override;
    procedure WriteString(const Section, Ident, Value: String); override;
    procedure UpdateFile; override;
  end;

  TADIntfCodePart = (cpHeader, cpPrivate, cpProtected, cpPublic, cpPublished);
  TADImplCodePart = (ipHeader, ipConstr, ipDestr, ipMethod);
  TADCodeGenerator = class
  private
    FIntfStreams: array[TADIntfCodePart] of TStream;
    FImplStreams: array[TADImplCodePart] of TStream;
    FMyClassName, FParentClassName, FOriginalObject: String;
    FIsComponent: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure WriteIntf(APart: TADIntfCodePart; const AStr: String);
    procedure WriteImplNewMethod(ASourceName: String);
    procedure WriteImpl(APart: TADImplCodePart; const AStr: String);
    procedure SaveIntf(AStream: TStream);
    procedure SaveImpl(AStream: TStream);
    property MyClassName: String read FMyClassName write FMyClassName;
    property ParentClassName: String read FParentClassName write FParentClassName;
    property OriginalObject: String read FOriginalObject write FOriginalObject;
    property IsComponent: Boolean read FIsComponent write FIsComponent;
  end;

// String
function ADStrLike(const AStr, AMask: String; ANoCase: Boolean = False;
  AManyCharsMask: Char = '%'; AOneCharMask: Char = '_'; AEscapeChar: Char = '\'): Boolean;
function ADPosEx(const ASub, AStr: String; AFrom: Integer = 1): Integer;
function ADStrRPos(Str1, Str2: PChar): PChar;
function ADPadR(const AStr: String; ALength: Integer): String;
function ADPadL(const AStr: String; ALength: Integer): String;
function ADValToStr(const AValue: Variant; AQuotes: Boolean): String;
function ADIdentToStr(const AValue: Variant; var AQuotes: Boolean): String;
function ADVarToBool(const AValue: Variant): Boolean;
function ADVar2Int(const AValue: Variant): Integer;
function ADSameVariants(const A, B: Variant): Boolean;
function ADFixCRLF(const AStr: String): String;
function ADExtractFieldName(const AStr: String; var APos: Integer): String; overload;
function ADExtractFieldName(const AStr: String; var APos: Integer; const AFmt: TADParseFmtSettings): String; overload;
function ADMergeFieldNames(const AFieldNames1, AFieldNames2: String): String;
function ADCountFieldNames(const AStr: String): Integer;
function ADFieldInFieldNames(const AStr, AName: String) : Boolean;
procedure ADFieldNamesToArray(const AFieldNames: String; var AFieldNamesArray: TADStringArray);
function ADNameFromIndex(AStrs: TStrings; AIndex: Integer): String;
function ADValueFromIndex(AStrs: TStrings; AIndex: Integer): String;
function ADStrToken(const AString: String; AChars: String; var AFrom: Integer;
  ASqueeze: Boolean = False): String;
function ADUnquote(const AString: String; AQuoteChar: Char = '"'): String;
function ADCompareAnsiStr(const AStr1, AStr2: PADAnsiString; ALen1, ALen2: Integer;
  ALocale: TADLocalID; ANoCase, APartial, ANoSymbols: Boolean): Integer;
function ADCompareWideStr(const AStr1, AStr2: PWideChar; ALen1, ALen2: Integer;
  ALocale: TADLocalID; ANoCase, APartial, ANoSymbols: Boolean): Integer;
function ADCompareByteStr(const AStr1, AStr2: PADByteString; ALen1, ALen2: Integer): Integer;
function ADStrReplace(const AStr: String; ASrch, ARepl: Char): String;
procedure ADBin2HexBS(APtr: Pointer; ALen: Integer; ADest: PADByteString);
function ADBin2Hex(APtr: Pointer; ALen: Integer): String;
function ADHex2Bin(AStr: String): TADByteString;

// ANSI string
function ADAnsiStrLen(AStr: PADAnsiString): Integer;
function ADByteStrLength(const AStr: TADByteString): Integer; {$IFDEF AnyDAC_D9} inline; {$ENDIF}

// Wide string
function ADWideStrLen(AStr: PWideChar): Integer;
function ADStrLIComp(const AStr1, AStr2: PWideChar; AMaxLen: Cardinal): Integer;
function ADInSet(AChar: Char; ASet: TADCharSet): Boolean; {$IFDEF AnyDAC_D9} inline; {$ENDIF}

// System & path
function ADLastSystemErrorMsg: String;
function ADGetCmdParam(const AParName: String; const ADefValue: String): String; overload;
function ADGetCmdParam(const AParName: String; ATrigger: Boolean; var AValue: String): Boolean; overload;
function ADGetSystemCfgPath: String;
function ADGetAppPath: String;
function ADGetAppCfgPath: String;
function ADGetAppDocPath: String;
function ADGetTempPath: String;
function ADGetBestPath(const ASpecifiedFileName, AGlobalFileName, ADefFileName: String): String;
function ADNormPath(const APath: String): String;
function ADExtractFileNameNoPath(const AFileName: String): String;
function ADBrowseForFolder(AHandle: THandle; ATitle: string): string;
{$IFDEF MSWINDOWS}
function ADGetVersionInfo(const AFileName: string; out AProduct,
  AVersion, AVersionName, ACopyright, AInfo: string): Boolean;
{$ENDIF}
function ADGetLibMachineType(const AFileName: string): TADMachineType;
function ADVerStr2Int(const AVersion: String): TADVersion;
function ADVerInt2Str(AVersion: TADVersion): String;
function ADReadRegValue(const AName: String): String;
procedure ADWriteRegValue(const AName, AValue: String);
function ADReadEnvValue(const AName: String): String;
function ADExpandStr(const AStr: String; AVars: TStrings = nil): String;
function ADIsDesignTime: Boolean;
function ADToolName: String;

// Date & time
// All time-interval related code is in the uADStanSQLTimeInt
function ADIsSQLTimeStampBlank(const ATimeStamp: TADSQLTimeStamp): Boolean;
function ADDateTime2SQLTimeStamp(const ADateTime: TDateTime): TADSQLTimeStamp;
function ADSQLTimeStamp2DateTime(const ADateTime: TADSQLTimeStamp): TDateTime;
function ADSQLTimeStamp2Time(const AValue: TADSQLTimeStamp): Longint;
function ADSQLTimeStamp2Date(const AValue: TADSQLTimeStamp): Longint;
function ADTime2SQLTimeStamp(const AValue: Longint): TADSQLTimeStamp;
function ADDate2SQLTimeStamp(const AValue: Longint): TADSQLTimeStamp;
function ADTime2DateTime(const AValue: Longint): TDateTime;
function ADDateTime2Time(const AValue: TDateTime): Longint;
function ADDate2DateTime(const AValue: Longint): TDateTime;
function ADDateTime2Date(const AValue: TDateTime): Longint;
{$IFDEF AnyDAC_D6}
function ADVar2SQLTimeStamp(const AValue: Variant): TADSQLTimeStamp;
{$ENDIF}
function ADGetTickCount: LongWord;
function ADGetPerformanceCounter: Int64;
function ADEncodeDateTime(const AYear, AMonth, ADay, AHour, AMin, ASec, AMSec: Word): TDateTime;
function ADMSecs2DateTime(const AValue: Double): TDateTime; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
function ADDateTime2MSecs(const AValue: TDateTime): Comp; {$IFDEF AnyDAC_D9} inline; {$ENDIF}

// BCD & numeric
function ADFixFMTBcdAdd(const V1, V2: Variant): Variant;
function ADFixFMTBcdSub(const V1, V2: Variant): Variant;
function ADFixFMTBcdDiv(const V1, V2: Variant): Variant;
function ADCompareUInt64(const Value1, Value2: Int64): Integer;
procedure ADStr2BCD(pIn: PChar; ASize: Integer; out ABcd: TADBcd; ADot: Char);
procedure ADFloatRec2BCD(const ARec: TFloatRec; out ABcd: TADBcd);
procedure ADBCD2Str(pOut: PChar; out ASize: Integer; const ABcd: TADBcd; ADot: Char);
procedure ADBcdGetMetrics(const ABcd: TADBcd; out APrecision, AScale: Smallint);
procedure ADBCD2Double(const ABcd: TADBcd; out AVal: Extended);
procedure ADDouble2BCD(const AExt: Extended; out AVal: TADBcd);
procedure ADInt2Str(ASrcData: Pointer; ASrcLen: Integer; var ADestData: PChar;
  var ADestLen: Integer; AScale: Integer);
procedure ADStr2Int(ASrcData: PChar; ASrcLen: Integer; ADestData: Pointer;
  ADestLen: Integer; ANoSign: Boolean = False; AScale: Integer = 0);
{$IFDEF AnyDAC_FPC}
function CurrToBCD(const Curr: Currency; out BCD: TADBcd; Precision: Integer = 32;
  Decimals: Integer = 4): Boolean;
function BCDToCurr(const BCD: TADBcd; out Curr: Currency): Boolean;
{$ENDIF}
function ADFloat2Str(const AValue: Extended; ADot: Char = '.'; APrec: Integer = 18): String;
function ADStr2Float(const AValue: String; ADot: Char = '.'): Extended; overload;
procedure ADStr2Float(pIn: PChar; ASize: Integer; out AExt: Extended; ADot: Char = '.'); overload;
function ADBcdIsDecimalPartEmpty(const ABCD: TADBcd): Boolean;
function ADCurr2Str(const AValue: Currency; ADot: Char = '.'): String;
  overload; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
procedure ADCurr2Str(pOut: PChar; out ASize: Integer;
  const AValue: Currency; ADot: Char = '.'); overload;
function ADStr2Curr(const AValue: String; ADot: Char = '.'): Currency; overload;
procedure ADStr2Curr(pIn: PChar; ASize: Integer; out ACurr: Currency;
  ADot: Char = '.'); overload;
function ADRandomNumber(AMaxPrec, AMaxScale: Integer; ASign: Integer): String;
function ADDisableFPExc: TADNativeUInt;
procedure ADResetFPExc(AValue: TADNativeUInt);

// other
function ADIndexOf(AList: Pointer; ALen: Integer; AItem: Pointer): Integer;
procedure ADFree(AObj: TObject); {$IFDEF AnyDAC_D9} inline; {$ENDIF}
procedure ADFreeAndNil(var AObj); {$IFDEF AnyDAC_D9} inline; {$ENDIF}
function ADTimeout(AStartTicks, ATimeout: LongWord): Boolean;
function ADAcquireExceptionObject: Exception;
procedure ADHandleException;
procedure ADShell(const ACommand, ALayer: String);
procedure ADFileMove(const ASrcName, ADestName: String);
procedure ADSystemMessage(const ACaption, AMessage: String; AWarning: Boolean);
procedure ADSetEnv(const AName, AValue: String);
function ADInterlockedExchangePointer(var Destination: Pointer; Exchange: Pointer): Pointer; {$IFDEF AnyDAC_D18} inline; {$ENDIF}
function ADInterlockedIncrement(var Addend: LongInt): LongInt; {$IFDEF AnyDAC_D18} inline; {$ENDIF}
function ADInterlockedDecrement(var Addend: LongInt): LongInt; {$IFDEF AnyDAC_D18} inline; {$ENDIF}
procedure ADHighRefCounter(var ACounter: Integer); {$IFDEF AnyDAC_D9} inline; {$ENDIF}

// standard routine replacement
type
  TADFillChar = procedure(var Dest; count: Integer; Value: Byte);
var
  ADFillChar: TADFillChar;

type
  TADCheckGuiRunningFunc = function: Boolean;
var
  GParseFmtSettings: TADParseFmtSettings;
  GSemicolonFmtSettings: TADParseFmtSettings;
  GSpaceFmtSettings: TADParseFmtSettings;
  GCheckGuiRunning: TADCheckGuiRunningFunc;

const
  C_AD_ScaleFactor: array[1 .. 15] of Int64 = (10, 100, 1000, 10000, 100000,
    1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000,
    1000000000000, 10000000000000, 100000000000000, 1000000000000000);

implementation

uses
{$IFDEF UNIX}
  cthreads, BaseUnix, unixtype, initc, dynlibs, dl,
{$ENDIF}
{$IFDEF POSIX}
  Posix.Pthread, Posix.Dlfcn, Posix.Stdio, Posix.Unistd, Posix.Stdlib,
    Posix.Signal,
{$ENDIF}
{$IFDEF MACOS}
  {$IFDEF AnyDAC_FPC}
  DriverServices,
  {$ELSE}
  Macapi.CoreServices, Macapi.Mach,
  {$ENDIF}
  {$IFDEF IOS}
  iOSapi.Foundation,
  {$ELSE}
  Macapi.Foundation,
  {$ENDIF}
{$ENDIF}
{$IFDEF AnyDAC_D7}
  StrUtils,
{$ENDIF}
{$IFDEF AnyDAC_D6}
  TypInfo,
{$ENDIF}
{$IFDEF LCL}
  Dialogs,
{$ENDIF}
  SysConst,
{$IFDEF AnyDAC_D6Base}
  RTLConsts
{$ELSE}
  Consts
{$ENDIF},
{$IFDEF AnyDAC_D17}
  System.Generics.Collections,
  System.Types,
{$ENDIF}
{$IFDEF AnyDAC_D18}
  {$IFNDEF NEXTGEN}
  System.AnsiStrings,
  {$ENDIF}
{$ENDIF}
  Math,
  uADStanConst, uADStanError;

var
  C_Date_1_1_1: TDateTime;

{$IFDEF AnyDAC_D7}
threadvar
  GCachedNumFS: TFormatSettings;
{$ENDIF}

{$IFDEF UNIX}
function gettimeofday(tp: ptimeval; tzp: ptimezone): cint; cdecl; external clib name 'gettimeofday';
function __rename(__old: PChar; __new: PChar): cint; cdecl; external clib name 'rename';
function __write(Handle: Integer; const Buffer; Count: size_t): ssize_t; cdecl; external clib name 'write';
function setenv(__name: PChar; __value: PChar; __replace: LongInt): LongInt; cdecl; external clib name 'setenv';
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADFileStream                                                                 }
{-------------------------------------------------------------------------------}
constructor TADFileStream.Create(const AFileName: string; AMode: Word; AStreamBufferSize: Word = $7FFF);
begin
  inherited Create(AFileName, AMode);
  FStreamBufferSize := AStreamBufferSize;
  GetMem(FBuffer, FStreamBufferSize);
  SyncBuffer(True);
end;

{-------------------------------------------------------------------------------}
destructor TADFileStream.Destroy;
begin
  SyncBuffer(False);
  FreeMem(FBuffer, FStreamBufferSize);
  inherited;
end;

{-------------------------------------------------------------------------------}
procedure TADFileStream.SyncBuffer(AReRead: boolean);
begin
  if FModified then begin
    inherited Seek(FBufStart, soBeginning);
    inherited Write(FBuffer^, Longint(FBufEnd - FBufStart));
    FModified := False;
  end;
  if AReRead then begin
    FBufStart := inherited Seek(FPos, soBeginning);
    FBufEnd := FBufStart + inherited Read(FBuffer^, FStreamBufferSize);
  end
  else begin
    inherited Seek(FPos, soBeginning);
    FBufEnd := FBufStart;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFileStream.Read(var Buffer; Count: Longint): Longint;
var
  pSrc: PADByteString;
begin
  if Count >= FStreamBufferSize then begin
    SyncBuffer(False);
    Result := inherited Read(Buffer, Count)
  end
  else begin
    if (FBufStart > FPos) or (FPos + Count > FBufEnd) then
      SyncBuffer(True);
    if (Count < FBufEnd - FPos) then
      Result := Count
    else
      Result := Longint(FBufEnd - FPos);
    pSrc := FBuffer + (FPos - FBufStart);
    case Result of
    SizeOf(Byte):     PByte(@Buffer)^ := PByte(pSrc)^;
    SizeOf(Word):     PWord(@Buffer)^ := PWord(pSrc)^;
    SizeOf(LongWord): PLongWord(@Buffer)^ := PLongWord(pSrc)^;
    SizeOf(Int64):    PInt64(@Buffer)^ := PInt64(pSrc)^;
    else              Move(pSrc^, Buffer, Result);
    end;
  end;
  FPos := FPos + Result;
end;

{-------------------------------------------------------------------------------}
function TADFileStream.Write(const Buffer; Count: Longint): Longint;
var
  pDest: PADByteString;
begin
  if Count >= FStreamBufferSize then begin
    SyncBuffer(False);
    Result := inherited Write(Buffer, Count);
    FPos := FPos + Result;
  end
  else begin
    if (FBufStart > FPos) or (FPos + Count > FBufStart + FStreamBufferSize) then
      SyncBuffer(True);
    Result := Count;
    pDest := FBuffer + (FPos - FBufStart);
    case Result of
    SizeOf(Byte):     PByte(pDest)^ := PByte(@Buffer)^;
    SizeOf(Word):     PWord(pDest)^ := PWord(@Buffer)^;
    SizeOf(LongWord): PLongWord(pDest)^ := PLongWord(@Buffer)^;
    SizeOf(Int64):    PInt64(pDest)^ := PInt64(@Buffer)^;
    else              Move(Buffer, pDest^, Result);
    end;
    FModified := True;
    FPos := FPos + Result;
    if (FPos > FBufEnd) then
      FBufEnd := FPos;
  end;
end;

{-------------------------------------------------------------------------------}
function TADFileStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPos := Offset;
    soFromCurrent:   FPos := FPos + Offset;
    soFromEnd:       FPos := inherited Seek(Offset, Origin);
  else
    Assert(False);
  end;
  Result := Longint(FPos);
end;

{$IFDEF AnyDAC_D6Base}
{-------------------------------------------------------------------------------}
function TADFileStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  case Origin of
    soBeginning: FPos := Offset;
    soCurrent:   FPos := FPos + Offset;
    soEnd:       FPos := inherited Seek(Offset,Origin);
  else
    Assert(False);
  end;
  Result := FPos;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADReadSharedMemoryStream                                                     }
{-------------------------------------------------------------------------------}
destructor TADReadSharedMemoryStream.Destroy;
begin
  SetPointer(nil, 0);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADReadSharedMemoryStream.SetData(APtr: Pointer; ASize: Integer);
begin
  SetPointer(APtr, ASize);
end;

{-------------------------------------------------------------------------------}
{ TADThreadMsgBase                                                              }
{-------------------------------------------------------------------------------}
constructor TADThreadMsgBase.Create;
begin
  inherited Create;
end;

{-------------------------------------------------------------------------------}
function TADThreadMsgBase.Perform(AThread: TADThread): Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
{ TADThreadStartMsg                                                             }
{-------------------------------------------------------------------------------}
function TADThreadStartMsg.Perform(AThread: TADThread): Boolean;
begin
  AThread.FControlEvent.SetEvent;
  Result := True;
end;

{-------------------------------------------------------------------------------}
{ TADThreadTerminateMsg                                                         }
{-------------------------------------------------------------------------------}
function TADThreadTerminateMsg.Perform(AThread: TADThread): Boolean;
begin
  AThread.Terminate;
  if AThread.FControlEvent <> nil then
    AThread.FControlEvent.SetEvent;
  Result := False;
end;

{-------------------------------------------------------------------------------}
{ TADThread                                                                     }
{-------------------------------------------------------------------------------}
var
  FThreads: TADThreadObjList;
  FLock: TCriticalSection;

constructor TADThread.Create;
begin
  FThreads.Add(Self);
  inherited Create(True);
  FreeOnTerminate := True;
  FActive := False;
  FMessages := TADThreadObjList.Create;
  FMessages.Duplicates := dupAccept;
  FMessageEvent := TEvent.Create(nil, False, False, '');
  FControlEvent := TEvent.Create(nil, False, False, '');
  FStartupTimeout := C_AD_ThreadStartupTimeout;
  FIdleTimeout := C_AD_ThreadIdleTimeout;
end;

{-------------------------------------------------------------------------------}
destructor TADThread.Destroy;
begin
  if FThreads <> nil then
    FThreads.Remove(Self);
  Shutdown(True);
  ADFreeAndNil(FControlEvent);
  ADFreeAndNil(FMessageEvent);
  ADFreeAndNil(FMessages);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADThread.GetStartMsgClass: TADThreadMsgClass;
begin
  Result := TADThreadStartMsg;
end;

{-------------------------------------------------------------------------------}
class function TADThread.GetStopMsgClass: TADThreadMsgClass;
begin
  Result := TADThreadStopMsg;
end;

{-------------------------------------------------------------------------------}
class function TADThread.GetTerminateMsgClass: TADThreadMsgClass;
begin
  Result := TADThreadTerminateMsg;
end;

{-------------------------------------------------------------------------------}
procedure TADThread.DoActiveChanged;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D14}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADThread.SetActive(AValue: Boolean);
var
  oList: TADObjList;
  i: Integer;
  oMsg: TADThreadMsgBase;
begin
  if FActive <> AValue then begin
    FActive := AValue;
    try
      if Suspended then
        Resume;
      if FActive then
        EnqueueControlMsg(GetStartMsgClass().Create)
      else begin
        EnqueueControlMsg(GetStopMsgClass().Create);
{$IFDEF AnyDAC_D6}
        if GetCurrentThreadID = MainThreadID then
          CheckSynchronize();
{$ENDIF}
        oList := FMessages.LockList;
        try
          for i := 0 to oList.Count - 1 do begin
            oMsg := TADThreadMsgBase(oList[i]);
            oMsg.Perform(Self);
            ADFree(oMsg);
          end;
        finally
{$IFDEF AnyDAC_D6}
          oList.Count := 0;
{$ELSE}
          oList.Clear;
{$ENDIF}
          FMessages.UnlockList;
        end;
      end;
      DoActiveChanged;
    except
      FActive := False;
    end;
  end;
end;
{$IFDEF AnyDAC_D14}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D14}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADThread.Shutdown(AWait: Boolean);
var
{$IFDEF MSWINDOWS}
  iExitCode: LongWord;
{$ENDIF}
  iCurrTID: TADThreadID;
begin
  if Suspended then
    Resume;
  Active := False;
  EnqueueControlMsg(GetTerminateMsgClass().Create);
  iCurrTID := GetCurrentThreadId;
  if iCurrTID <> ThreadID then
{$IFDEF MSWINDOWS}
    repeat
  {$IFDEF AnyDAC_D6}
      if (iCurrTID = MainThreadID) and AWait then
        CheckSynchronize()
      else
  {$ENDIF}
        Sleep(10);
      iExitCode := 0;
    until not (AWait and GetExitCodeThread(Handle, iExitCode) and (iExitCode = STILL_ACTIVE));
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
    WaitFor;
{$ENDIF}
end;
{$IFDEF AnyDAC_D14}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADThread.EnqueueMsg(AMsg: TADThreadMsgBase);
begin
  FMessages.Add(AMsg);
  FMessageEvent.SetEvent;
end;

{-------------------------------------------------------------------------------}
procedure TADThread.EnqueueControlMsg(AMsg: TADThreadMsgBase);
var
  sEventName: String;
  i: Integer;
begin
  if (GetCurrentThreadId <> ThreadID) and not Finished then begin
    sEventName := LowerCase(Copy(AMsg.ClassName, 10, Length(AMsg.ClassName) - 9 - 3));
    EnqueueMsg(AMsg);
    if FThreads = nil then
      i := -1
    else begin
      i := FThreads.LockList.IndexOf(Self);
      FThreads.UnlockList;
    end;
    if i > 0 then
      case FControlEvent.WaitFor(FStartupTimeout) of
      wrTimeout:
        raise EThread.CreateFmt('Failed to %s thread [%s].'#13#10'Timeout [%d] expired',
          [sEventName, ClassName, FStartupTimeout]);
      wrError:
        raise EThread.CreateFmt('Failed to %s thread [%s].'#13#10'System error: %s',
          [sEventName, ClassName, ADLastSystemErrorMsg]);
      end;
  end
  else begin
    AMsg.Perform(Self);
    ADFree(AMsg);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADThread.Ping;
begin
  FMessageEvent.SetEvent;
end;

{-------------------------------------------------------------------------------}
function TADThread.DoAllowTerminate: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADThread.DoIdle;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADThread.DoTimeout;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D12}
procedure TADThread.DoTerminate;
begin
  inherited DoTerminate;
  FFinished := True;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADThread.Execute;
var
  oReceivedMsgs: TADObjList;
  i: Integer;
  oMsg: TADThreadMsgBase;

  procedure Idle;
  begin
    if not (Terminated and DoAllowTerminate) then
      DoIdle;
  end;

begin
  while not (Terminated and DoAllowTerminate) do begin
    try
      case FMessageEvent.WaitFor(FIdleTimeout) of
      wrSignaled:
        begin
          oReceivedMsgs := FMessages.LockList;
          try
            if oReceivedMsgs.Count = 0 then
              Idle
            else
              for i := 0 to oReceivedMsgs.Count - 1 do begin
                oMsg := TADThreadMsgBase(oReceivedMsgs[i]);
                try
                  if not oMsg.Perform(Self) then
                    Break;
                finally
                  ADFree(oMsg);
                end;
                Idle;
              end;
          finally
{$IFDEF AnyDAC_D6}
            oReceivedMsgs.Count := 0;
{$ELSE}
            oReceivedMsgs.Clear;
{$ENDIF}
            FMessages.UnlockList;
          end;
        end;
      wrTimeout:
        if not (Terminated and DoAllowTerminate) then begin
          DoTimeout;
          Idle;
        end;
      else
        Terminate;
      end;
    except
      // no exceptions
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D7}
  {$IFNDEF AnyDAC_FPC}
type
  __TThread = class(TThread)
  end;
  {$ENDIF}
{$ENDIF}

class procedure TADThread.Synchronize(AMethod: TThreadMethod);
{$IFNDEF AnyDAC_D7}
  {$IFNDEF AnyDAC_FPC}
var
  oList: TList;
  {$ENDIF}
{$ENDIF}
begin
{$IFDEF AnyDAC_D7}
  TThread.Synchronize(nil, AMethod);
{$ELSE}
  {$IFDEF AnyDAC_FPC}
  TThread.Synchronize(nil, AMethod);
  {$ELSE}
  if GetCurrentThreadID = MainThreadID then
    AMethod()
  else begin
    oList := FThreads.LockList;
    try
      ASSERT(oList.Count > 0);
      __TThread(oList[0]).Synchronize(AMethod);
    finally
      FThreads.UnlockList;
    end;
  end;
  {$ENDIF}
{$ENDIF}
end;

{$IFDEF AnyDAC_FPC}
{-------------------------------------------------------------------------------}
{ TADThreadLocalCounter                                                         }
{-------------------------------------------------------------------------------}
const
  Alive = High(Integer);

{-------------------------------------------------------------------------------}
destructor TADThreadLocalCounter.Destroy;
var
  P, Q: PADThreadInfo;
  I: Integer;
begin
  for I := 0 to High(FHashTable) do
  begin
    P := FHashTable[I];
    FHashTable[I] := nil;
    while P <> nil do
    begin
      Q := P;
      P := P^.Next;
      FreeMem(Q);
    end;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADThreadLocalCounter.HashIndex: Byte;
var
  H: Word;
begin
  H := Word(GetCurrentThreadID);
  Result := (WordRec(H).Lo xor WordRec(H).Hi) and 15;
end;

{-------------------------------------------------------------------------------}
procedure TADThreadLocalCounter.Open(var Thread: PADThreadInfo);
var
  P: PADThreadInfo;
  CurThread: TADThreadID;
  H: Byte;
begin
  H := HashIndex;
  CurThread := GetCurrentThreadID;

  P := FHashTable[H];
  while (P <> nil) and (P.ThreadID <> CurThread) do
    P := P.Next;

  if P = nil then
  begin
    P := Recycle;

    if P = nil then
    begin
      P := PADThreadInfo(AllocMem(sizeof(TADThreadInfo)));
      P.ThreadID := CurThread;
      P.Active := Alive;

      // Another thread could start traversing the list between when we set the
      // head to P and when we assign to P.Next.  Initializing P.Next to point
      // to itself will make others spin until we assign the tail to P.Next.
      P.Next := P;
      P.Next := PADThreadInfo(ADInterlockedExchangePointer(FHashTable[H], P));
    end;
  end;
  Thread := P;
end;

{-------------------------------------------------------------------------------}
procedure TADThreadLocalCounter.Close(var Thread: PADThreadInfo);
begin
  Thread := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADThreadLocalCounter.Delete(var Thread: PADThreadInfo);
begin
  Thread.ThreadID := 0;
  Thread.Active := 0;
end;

{-------------------------------------------------------------------------------}
function TADThreadLocalCounter.Recycle: PADThreadInfo;
var
  Gen: Integer;
begin
  Result := FHashTable[HashIndex];
  while (Result <> nil) do
  begin
    Gen := InterlockedExchange(Result.Active, Alive);
    if Gen <> Alive then
    begin
      Result.ThreadID := GetCurrentThreadID;
      Exit;
    end
    else
      Result := Result.Next;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMREWSynchronizer                                                           }
{-------------------------------------------------------------------------------}
const
  mrWriteRequest = $FFFF; // 65535 concurrent read requests (threads)
                          // 32768 concurrent write requests (threads)
                          // only one write lock at a time
                          // 2^32 lock recursions per thread (read and write combined)

constructor TADMREWSynchronizer.Create;
begin
  inherited Create;
  FSentinel := mrWriteRequest;
  FReadSignal := TEvent.Create(nil, True, True, '');  // manual reset, start signaled
  FWriteSignal := TEvent.Create(nil, False, False, ''); // auto reset, start blocked
  FWaitRecycle := INFINITE;
  tls := TADThreadLocalCounter.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADMREWSynchronizer.Destroy;
begin
  BeginWrite;
  inherited Destroy;
  ADFreeAndNil(FReadSignal);
  ADFreeAndNil(FWriteSignal);
  ADFree(tls);
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.BlockReaders;
begin
  FReadSignal.ResetEvent;
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.UnblockReaders;
begin
  FReadSignal.SetEvent;
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.UnblockOneWriter;
begin
  FWriteSignal.SetEvent;
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.WaitForReadSignal;
begin
  FReadSignal.WaitFor(FWaitRecycle);
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.WaitForWriteSignal;
begin
  FWriteSignal.WaitFor(FWaitRecycle);
end;

{-------------------------------------------------------------------------------}
function TADMREWSynchronizer.BeginWrite: Boolean;
var
  Thread: PADThreadInfo;
  HasReadLock: Boolean;
  ThreadID: TADThreadID;
  Test: Integer;
  OldRevisionLevel: Cardinal;
begin
  {
    States of FSentinel (roughly - during inc/dec's, the states may not be exactly what is said here):
    mrWriteRequest:         A reader or a writer can get the lock
    1 - (mrWriteRequest-1): A reader (possibly more than one) has the lock
    0:                      A writer (possibly) just got the lock, if returned from the main write While loop
    < 0, but not a multiple of mrWriteRequest: Writer(s) want the lock, but reader(s) have it.
          New readers should be blocked, but current readers should be able to call BeginRead
    < 0, but a multiple of mrWriteRequest: Writer(s) waiting for a writer to finish
  }


  Result := True;
  ThreadID := GetCurrentThreadID;
  if FWriterID <> ThreadID then  // somebody or nobody has a write lock
  begin
    // Prevent new readers from entering while we wait for the existing readers
    // to exit.
    BlockReaders;

    OldRevisionLevel := FRevisionLevel;

    Thread := nil;
    tls.Open(Thread);
    // We have another lock already. It must be a read lock, because if it
    // were a write lock, FWriterID would be our threadid.
    HasReadLock := Thread.RecursionCount > 0;

    if HasReadLock then    // acquiring a write lock requires releasing read locks
      InterlockedIncrement(FSentinel);

    // InterlockedExchangeAdd returns prev value
    while InterlockedExchangeAdd(FSentinel, -mrWriteRequest) <> mrWriteRequest do
    begin
      // Undo what we did, since we didn't get the lock
      Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest);
      // If the old value (in Test) was 0, then we may be able to
      // get the lock (because it will now be mrWriteRequest). So,
      // we continue the loop to find out. Otherwise, we go to sleep,
      // waiting for a reader or writer to signal us.

      if Test <> 0 then
        WaitForWriteSignal;
    end;

    // At the EndWrite, first Writers are awoken, and then Readers are awoken.
    // If a Writer got the lock, we don't want the readers to do busy
    // waiting. This Block resets the event in case the situation happened.
    BlockReaders;

    // Put our read lock marker back before we lose track of it
    if HasReadLock then
      InterlockedDecrement(FSentinel);

    FWriterID := ThreadID;

    Result := Integer(OldRevisionLevel) = (InterlockedIncrement(Integer(FRevisionLevel)) - 1);
  end;

  Inc(FWriteRecursionCount);
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.EndWrite;
var
  Thread: PADThreadInfo;
begin
  assert(FWriterID = GetCurrentThreadID);
  Thread := nil;
  tls.Open(Thread);
  Dec(FWriteRecursionCount);
  if FWriteRecursionCount = 0 then
  begin
    FWriterID := 0;
    InterlockedExchangeAdd(FSentinel, mrWriteRequest);
    UnblockOneWriter;
    UnblockReaders;
  end;
  if Thread.RecursionCount = 0 then
    tls.Delete(Thread);
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.BeginRead;
var
  Thread: PADThreadInfo;
  WasRecursive: Boolean;
  SentValue: Integer;
begin
  Thread := nil;
  tls.Open(Thread);
  Inc(Thread.RecursionCount);
  WasRecursive := Thread.RecursionCount > 1;

  if FWriterID <> GetCurrentThreadID then
  begin
    // In order to prevent recursive Reads from causing deadlock,
    // we need to always WaitForReadSignal if not recursive.
    // This prevents unnecessarily decrementing the FSentinel, and
    // then immediately incrementing it again.
    if not WasRecursive then
    begin
      // Make sure we don't starve writers. A writer will
      // always set the read signal when it is done, and it is initially on.
      WaitForReadSignal;
      while (InterlockedDecrement(FSentinel) <= 0) do
      begin
        // Because the InterlockedDecrement happened, it is possible that
        // other threads "think" we have the read lock,
        // even though we really don't. If we are the last reader to do this,
        // then SentValue will become mrWriteRequest
        SentValue := InterlockedIncrement(FSentinel);
        // So, if we did inc it to mrWriteRequest at this point,
        // we need to signal the writer.
        if SentValue = mrWriteRequest then
          UnblockOneWriter;

        // This sleep below prevents starvation of writers
        Sleep(0);

        WaitForReadSignal;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMREWSynchronizer.EndRead;
var
  Thread: PADThreadInfo;
  Test: Integer;
begin
  Thread := nil;
  tls.Open(Thread);
  Dec(Thread.RecursionCount);
  if (Thread.RecursionCount = 0) then
  begin
     tls.Delete(Thread);

    // original code below commented out
    if (FWriterID <> GetCurrentThreadID) then
    begin
      Test := InterlockedIncrement(FSentinel);
      // It is possible for Test to be mrWriteRequest
      // or, it can be = 0, if the write loops:
      // Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest) + mrWriteRequest;
      // Did not get executed before this has called (the sleep debug makes it happen faster)
      if Test = mrWriteRequest then
        UnblockOneWriter
      else if Test <= 0 then // We may have some writers waiting
      begin
        if (Test mod mrWriteRequest) = 0 then
          UnblockOneWriter; // No more readers left (only writers) so signal one of them
      end;
    end;
  end;
end;
{$ENDIF}

{$IFDEF AnyDAC_ASM}
{ TODO -cx64 : Implement TADMethodThunk for x64 }
// http://code.google.com/p/python4delphi/source/browse/trunk/PythonForDelphi/Components/Sources/Core/MethodCallBack.pas?r=88
// http://stackoverflow.com/questions/8283490/how-to-turn-a-method-to-a-callback-procedure-in-64bit-delphi-xe2
{-------------------------------------------------------------------------------}
{ TADMethodThunk                                                                }
{-------------------------------------------------------------------------------}
type
  PADThunk = ^TADThunk;
  TADThunk = packed record
    POPEDX: Byte;
    MOVEAX: Byte;
    SelfPtr: Pointer;
    PUSHEAX: Byte;
    PUSHEDX: Byte;
    JMP: Byte;
    JmpOffset: Integer;
  end;

{-------------------------------------------------------------------------------}
constructor TADMethodThunk.Create(ApSelf, ApProc: Pointer);
begin
  inherited Create;
  FCallAddress := nil;
  FSelfPtr := ApSelf;
  FProcPtr := ApProc;
end;

{-------------------------------------------------------------------------------}
destructor TADMethodThunk.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMethodThunk.Clear;
var
  SaveFlag: DWORD;
begin
  if @FCallAddress <> nil then begin
    VirtualProtect(PADThunk(@FCallAddress), SizeOf(TADThunk),
      FSavedFlag, @SaveFlag);
    VirtualFree(FCallAddress, 0, MEM_RELEASE);
    FCallAddress := nil;
    FSavedFlag := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMethodThunk.GetCallAddress: Pointer;
var
  pThunk: PADThunk;
begin
  if FCallAddress = nil then begin
    FCallAddress := VirtualAlloc(nil, SizeOf(TADThunk), MEM_COMMIT, PAGE_READWRITE);
    pThunk := PADThunk(FCallAddress);
    pThunk^.POPEDX := $5A;
    pThunk^.MOVEAX := $B8;
    pThunk^.SelfPtr := FSelfPtr;
    pThunk^.PUSHEAX := $50;
    pThunk^.PUSHEDX := $52;
    pThunk^.JMP := $E9;
    pThunk^.JmpOffset := TADNativeInt(FProcPtr) - TADNativeInt(@pThunk^.JMP) - 5;
    if not VirtualProtect(FCallAddress, SizeOf(TADThunk), PAGE_EXECUTE_READ, @FSavedFlag) then
      FCallAddress := nil;
  end;
  ASSERT(FCallAddress <> nil);
  Result := FCallAddress;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{- TADTimerPool                                                                -}
{-------------------------------------------------------------------------------}
type
  TADTimerData = class(TObject)
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FTimer: TADTimer;
    FNextFire: Int64;
    FPrev, FNext: TADTimerData;
    FState: TADTimerState;
    procedure DoFire;
  end;

  TADTimerPool = class(TThread)
  private
    FTimerDatas: TADTimerData;
    FLock: TCriticalSection;
    FEvent: TEvent;
    FLastTickCount: LongWord;
    FTickCountBase: Int64;
    function GetTickCount64: Int64;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure ExtractTimer(AData: TADTimerData);
    procedure Schedule(AData: TADTimerData; ANewNextFire: Int64);
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update(ATimer: TADTimer);
    procedure Remove(ATimer: TADTimer);
  end;

var
  GTimerPool: TADTimerPool;

{-------------------------------------------------------------------------------}
procedure TADTimerData.DoFire;
begin
  if (FTimer <> nil) and (FState = tsRaised) then
    FTimer.DoFire;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D14}
  {$WARNINGS OFF}
{$ENDIF}
constructor TADTimerPool.Create;
begin
  GTimerPool := Self;
  inherited Create(True);
  FLock := TCriticalSection.Create;
  FEvent := TEvent.Create(nil, False, False, '');
  Resume;
end;
{$IFDEF AnyDAC_D14}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
destructor TADTimerPool.Destroy;
begin
  if GTimerPool = Self then
    GTimerPool := nil;
  Terminate;
  FEvent.SetEvent;
  WaitFor;
  ADFreeAndNil(FEvent);
  ADFreeAndNil(FLock);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADTimerPool.BeginUpdate;
begin
  FLock.Enter;
end;

{-------------------------------------------------------------------------------}
procedure TADTimerPool.EndUpdate;
begin
  if FTimerDatas <> nil then
    FEvent.SetEvent;
  FLock.Leave;
end;

{-------------------------------------------------------------------------------}
function TADTimerPool.GetTickCount64: Int64;
var
  iTicks: LongWord;
begin
  iTicks := ADGetTickCount();
  if iTicks < FLastTickCount then
    FTickCountBase := FTickCountBase + $FFFFFFFF;
  FLastTickCount := iTicks;
  Result := iTicks + FTickCountBase;
end;

{-------------------------------------------------------------------------------}
procedure TADTimerPool.Schedule(AData: TADTimerData; ANewNextFire: Int64);
var
  pCur, p1: TADTimerData;
begin
  AData.FNextFire := ANewNextFire;
  if AData.FState <> tsDisabled then
    ExtractTimer(AData);
  if FTimerDatas = nil then begin
    FTimerDatas := AData;
    AData.FNext := nil;
    AData.FPrev := nil;
  end
  else begin
    pCur := FTimerDatas;
    while (pCur.FNext <> nil) and (pCur.FNextFire < AData.FNextFire) do
      pCur := pCur.FNext;
    if pCur.FNextFire < AData.FNextFire then begin
      pCur.FNext := AData;
      AData.FPrev := pCur;
      AData.FNext := nil;
    end
    else begin
      p1 := pCur.FPrev;
      AData.FPrev := p1;
      if p1 <> nil then
        p1.FNext := AData
      else
        FTimerDatas := AData;
      AData.FNext := pCur;
      pCur.FPrev := AData;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTimerPool.ExtractTimer(AData: TADTimerData);
var
  p1, p2: TADTimerData;
begin
  p1 := AData.FNext;
  p2 := AData.FPrev;
  if p1 <> nil then
    p1.FPrev := p2;
  if p2 <> nil then
    p2.FNext := p1
  else
    FTimerDatas := p1;
end;

{-------------------------------------------------------------------------------}
procedure TADTimerPool.Update(ATimer: TADTimer);
var
  oData: TADTimerData;
  iInterval: Int64;
begin
  ASSERT(ATimer <> nil);
  BeginUpdate;
  try
    if ATimer.FData = nil then begin
      oData := TADTimerData.Create;
      ATimer.FData := oData;
      oData.FTimer := ATimer;
    end
    else
      oData := TADTimerData(ATimer.FData);
    if oData.FState in [tsDisabled, tsWaiting, tsReqRemove] then begin
      if toImmediateFire in ATimer.Options then begin
        Exclude(ATimer.FOptions, toImmediateFire);
        iInterval := 0;
      end
      else
        iInterval := ATimer.Interval;
      Schedule(oData, GetTickCount64() + iInterval);
      oData.FState := tsWaiting;
    end;
  finally
    EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTimerPool.Remove(ATimer: TADTimer);
var
  oData: TADTimerData;
begin
  ASSERT((ATimer <> nil) and (ATimer.FData <> nil));
  BeginUpdate;
  try
    oData := TADTimerData(ATimer.FData);
    ATimer.FData := nil;
    oData.FTimer := nil;
    if oData.FState = tsWaiting then begin
      ExtractTimer(oData);
      ADFreeAndNil(oData);
    end
    else if oData.FState = tsRaised then
      oData.FState := tsReqRemove;
  finally
    EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTimerPool.Execute;
var
  iLastTime: Int64;
  iSleep: Int64;
  oData: TADTimerData;
begin
  repeat
    iLastTime := 0;
    while True do begin
      iSleep := INFINITE;
      FLock.Enter;
      try
        iLastTime := GetTickCount64();
        if FTimerDatas <> nil then begin
          if iLastTime > FTimerDatas.FNextFire then
            Break;
          iSleep := FTimerDatas.FNextFire - iLastTime;
        end;
      finally
        FLock.Leave;
      end;
      FEvent.WaitFor(iSleep);
      if Terminated then
        Exit;
    end;
    FLock.Enter;
    try
      oData := FTimerDatas;
      ASSERT((oData <> nil) and (oData.FState = tsWaiting) and (oData.FTimer <> nil));
      oData.FState := tsRaised;
    finally
      FLock.Leave;
    end;
    try
      if (toSynchronized in oData.FTimer.Options) and Assigned(GCheckGuiRunning) then begin
        if GCheckGuiRunning() then
          Synchronize(oData.DoFire);
      end
      else
        oData.DoFire;
    except
      // hide exceptions
    end;
    FLock.Enter;
    try
      if oData.FState in [tsRaised, tsReqRemove] then
        if oData.FState = tsReqRemove then begin
          ExtractTimer(oData);
          ADFreeAndNil(oData);
        end
        else begin
          oData.FState := tsWaiting;
          if toSingleFire in oData.FTimer.Options then
            oData.FTimer.Enabled := False
          else
            Schedule(oData, iLastTime + oData.FTimer.Interval);
        end;
    finally
      FLock.Leave;
    end;
  until Terminated;
end;

{-------------------------------------------------------------------------------}
{ TADTimer                                                                      }
{-------------------------------------------------------------------------------}
constructor TADTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInterval := 1000;
end;

{-------------------------------------------------------------------------------}
destructor TADTimer.Destroy;
begin
  Enabled := False;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADTimer.GetState: TADTimerState;
begin
  if FData = nil then
    Result := tsDisabled
  else
    Result := TADTimerData(FData).FState;
end;

{-------------------------------------------------------------------------------}
procedure TADTimer.SetInterval(AValue: Longword);
begin
  if FInterval <> AValue then begin
    FInterval := AValue;
    Update;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTimer.SetEnabled(AValue: Boolean);
begin
  if FEnabled <> AValue then begin
    FEnabled := AValue;
    Update;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTimer.DoFire;
begin
  if Assigned(FOnTimer) then
    FOnTimer();
end;

{-------------------------------------------------------------------------------}
procedure TADTimer.Loaded;
begin
  inherited Loaded;
  Update;
end;

{-------------------------------------------------------------------------------}
class procedure TADTimer.CheckPool;
begin
  FLock.Enter;
  try
    if GTimerPool = nil then
      TADTimerPool.Create;
  finally
    FLock.Leave;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTimer.Update;
begin
  if [csDesigning, csLoading] * ComponentState <> [] then
    Exit;
  if not ((FLock = nil) and (GTimerPool = nil)) then begin
    CheckPool;
    if Enabled then
      GTimerPool.Update(Self)
    else if State <> tsDisabled then
      GTimerPool.Remove(Self);
  end
  else
    ADFreeAndNil(FData);
end;

{-------------------------------------------------------------------------------}
procedure TADTimer.Schedule(AInterval: Longword);
begin
  FInterval := AInterval;
  FEnabled := True;
  Update;
end;

{-------------------------------------------------------------------------------}
procedure TADTimer.Fire;
begin
  Include(FOptions, toImmediateFire);
  FEnabled := True;
  Update;
end;

{-------------------------------------------------------------------------------}
class procedure TADTimer.LockTimers;
begin
  CheckPool;
  GTimerPool.BeginUpdate;
end;

{-------------------------------------------------------------------------------}
class procedure TADTimer.UnLockTimers;
begin
  CheckPool;
  GTimerPool.EndUpdate;
end;

{-------------------------------------------------------------------------------}
class procedure TADTimer.Shutdown;
begin
  ADFreeAndNil(GTimerPool);
end;

{-------------------------------------------------------------------------------}
{- TADRefCounter                                                               -}
{-------------------------------------------------------------------------------}
constructor TADRefCounter.Create(AOwner: TObject);
begin
  ASSERT(AOwner <> nil);
  inherited Create;
  FRefs := -1;
  FOwner := AOwner;
end;

{-------------------------------------------------------------------------------}
destructor TADRefCounter.Destroy;
begin
  FRefs := -1;
  FOwner := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADRefCounter.CountRef(AInit: Integer);
begin
  ASSERT(AInit >= 0);
  if FRefs = -1 then
    FRefs := AInit;
end;

{-------------------------------------------------------------------------------}
procedure TADRefCounter.AddRef;
begin
  if FRefs >= 0 then
    Inc(FRefs);
end;

{-------------------------------------------------------------------------------}
procedure TADRefCounter.RemRef;
begin
  if FRefs > 0 then begin
    Dec(FRefs);
    if FRefs = 0 then
      ADFree(FOwner);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADBuffer                                                                     }
{-------------------------------------------------------------------------------}
constructor TADBuffer.Create;
begin
  inherited Create;
  Release;
end;

{-------------------------------------------------------------------------------}
destructor TADBuffer.Destroy;
begin
  Release;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADBuffer.Extend(ASrcDataLen: LongWord;
  var ADestDataLen: LongWord; ASrcType, ADestType: TADDataType): Pointer;
var
  uiLen: LongWord;
begin
  ADestDataLen := ASrcDataLen;
  if ADestDataLen < ASrcDataLen then
    uiLen := ASrcDataLen
  else
    uiLen := ADestDataLen;
  if (ASrcType in C_AD_WideTypes) or (ADestType in C_AD_WideTypes) then begin
    uiLen := uiLen * SizeOf(WideChar);
    Inc(uiLen, SizeOf(WideChar));
  end;
  if (ASrcType in C_AD_AnsiTypes) or (ADestType in C_AD_AnsiTypes) then
    Inc(uiLen, SizeOf(TADAnsiChar));
  Result := Check(uiLen);
end;

{-------------------------------------------------------------------------------}
function TADBuffer.Check(ALen: LongWord = 0): Pointer;
var
  lAlloc: Boolean;
begin
  Inc(ALen, SizeOf(Word));
  if FBufferSize < ALen then begin
    FBufferSize := ALen;
    lAlloc := True;
  end
  else
    lAlloc := (FBuffer = nil);
  if lAlloc then
    ReallocMem(FBuffer, FBufferSize);
  Result := FBuffer;
end;

{-------------------------------------------------------------------------------}
procedure TADBuffer.Release;
begin
  if FBuffer <> nil then begin
    FreeMem(FBuffer, FBufferSize);
    FBuffer := nil;
  end;
  FBufferSize := C_AD_MaxFixedSize;
end;

{-------------------------------------------------------------------------------}
{ TADEncoder                                                                    }
{-------------------------------------------------------------------------------}
{ TODO -cLINUX : All ANSI <-> UCS2 code performs binary conversion of character code.
In future, it should use code page based conversion. }

var
  GEncoder: TADEncoder;

constructor TADEncoder.Create(ABuffer: TADBuffer);
begin
  inherited Create;
  if ABuffer <> nil then begin
    FBuffer := ABuffer;
    FOwnBuffer := False;
  end
  else begin
    FBuffer := TADBuffer.Create;
    FOwnBuffer := True;
  end;
end;

{-------------------------------------------------------------------------------}
destructor TADEncoder.Destroy;
begin
  if FOwnBuffer then
    ADFree(FBuffer);
  FBuffer := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADEncoder.Alloc(ALen: LongWord): Pointer;
begin
  if FBuffer = nil then
    GetMem(Result, ALen)
  else
    Result := FBuffer.Check(ALen);
end;

{-------------------------------------------------------------------------------}
procedure TADEncoder.Release(APtr: Pointer);
begin
  if FBuffer = nil then
    FreeMem(APtr);
end;

{-------------------------------------------------------------------------------}
class procedure TADEncoder.SetBytes(var AStr: TADByteString; AValue: Pointer;
  ALen, ATrailerLen: Integer);
begin
  SetLength(AStr, ALen + ATrailerLen);
  if ALen > 0 then
    Move(AValue^, PADByteString(AStr)^, ALen);
  if ATrailerLen > 0 then
    SetTrailerBytes(AStr, False, ATrailerLen);
end;

{-------------------------------------------------------------------------------}
class procedure TADEncoder.SetTrailerBytes(var AStr: TADByteString;
  AAppend: Boolean; ATrailerLen: Integer);
var
  iLen: Integer;
  p: PADByteString;
begin
  iLen := Length(AStr);
  if AAppend then
    SetLength(AStr, iLen + ATrailerLen)
  else
    Dec(iLen, ATrailerLen);
  p := PADByteString(AStr) + iLen;
  while ATrailerLen > 0 do begin
    p^ := TADByte(0);
    Inc(p);
    Dec(ATrailerLen);
  end;
end;

(*
{-------------------------------------------------------------------------------}
class function TADEncoder.Utf16ToUtf8(ADest: PAnsiChar; AMaxDestBytes: Integer;
  ASource: PWideChar; ASourceChars: Integer): Integer;
var
  i, count: Integer;
  c: Cardinal;
begin
  Result := 0;
  if ASource = nil then
    Exit;
  count := 0;
  i := 0;
  if ADest <> nil then begin
    while (i < ASourceChars) and (count < AMaxDestBytes) do begin
      c := Cardinal(ASource[i]);
      Inc(i);
      if c <= $7F then begin
        ADest[count] := AnsiChar(c);
        Inc(count);
      end
      else if c > $7FF then begin
        if count + 3 > AMaxDestBytes then
          break;
        ADest[count] := AnsiChar($E0 or (c shr 12));
        ADest[count+1] := AnsiChar($80 or ((c shr 6) and $3F));
        ADest[count+2] := AnsiChar($80 or (c and $3F));
        Inc(count,3);
      end
      else begin //  $7F < ASource[i] <= $7FF
        if count + 2 > AMaxDestBytes then
          break;
        ADest[count] := AnsiChar($C0 or (c shr 6));
        ADest[count+1] := AnsiChar($80 or (c and $3F));
        Inc(count,2);
      end;
    end;
  end
  else begin
    while i < ASourceChars do begin
      c := Integer(ASource[i]);
      Inc(i);
      if c > $7F then begin
        if c > $7FF then
          Inc(count);
        Inc(count);
      end;
      Inc(count);
    end;
  end;
  Result := count;  // convert zero based index to byte count
end;

{-------------------------------------------------------------------------------}
class function TADEncoder.Utf8ToUtf16(ADest: PWideChar; AMaxDestChars: Integer;
  ASource: PAnsiChar; ASourceBytes: Integer): Integer;
var
  i, count: Integer;
  c: Byte;
  wc: Cardinal;
begin
  Result := 0;
  if ASource = nil then
    Exit;
  count := 0;
  i := 0;
  if ADest <> nil then begin
    while (i < ASourceBytes) and (count < AMaxDestChars) do begin
      wc := Cardinal(ASource[i]);
      Inc(i);
      if (wc and $80) <> 0 then begin
        if i >= ASourceBytes then
          Exit;           // incomplete multibyte char
        wc := wc and $3F;
        if (wc and $20) <> 0 then begin
          c := Byte(ASource[i]);
          Inc(i);
          if (c and $C0) <> $80 then
            Exit;         // malformed trail byte or out of range char
          if i >= ASourceBytes then
            Exit;         // incomplete multibyte char
          wc := (wc shl 6) or (c and $3F);
        end;
        c := Byte(ASource[i]);
        Inc(i);
        if (c and $C0) <> $80 then
          Exit;           // malformed trail byte

        ADest[count] := WideChar((wc shl 6) or (c and $3F));
      end
      else
        ADest[count] := WideChar(wc);
      Inc(count);
    end;
  end
  else begin
    while (i < ASourceBytes) do begin
      c := Byte(ASource[i]);
      Inc(i);
      if (c and $80) <> 0 then begin
        if i >= ASourceBytes then
          Exit;           // incomplete multibyte char
        c := c and $3F;
        if (c and $20) <> 0 then begin
          c := Byte(ASource[i]);
          Inc(i);
          if (c and $C0) <> $80 then
            Exit;         // malformed trail byte or out of range char
          if i >= ASourceBytes then
            Exit;         // incomplete multibyte char
        end;
        c := Byte(ASource[i]);
        Inc(i);
        if (c and $C0) <> $80 then
          Exit;           // malformed trail byte
      end;
      Inc(count);
    end;
  end;
  Result := count;
end;
*)

{-------------------------------------------------------------------------------}
{$WARNINGS OFF}
function TADEncoder.Encode(const AStr: String; ADestEncoding: TADEncoding = ecDefault): TADByteString;
{$IFDEF MSWINDOWS}
var
  iLen: Integer;
  pUTF8: PAnsiChar;
  {$IFNDEF AnyDAC_Unicode}
  pWC: PWideChar;
  {$ENDIF}
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  {$IFNDEF NEXTGEN}
var
    {$IFDEF AnyDAC_D16}
  sb: TBytes;
    {$ELSE}
  sw: TADWideString;
  s: String;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
begin
  SetLength(Result, 0);
  if ADestEncoding = ecDefault then
    ADestEncoding := FEncoding;
{$IFDEF MSWINDOWS}
  if AStr <> '' then
  {$IFDEF AnyDAC_Unicode}
    case ADestEncoding of
      ecANSI:
        begin
          SetLength(Result, (Length(AStr) + 1) * SizeOf(AnsiChar));
          WideCharToMultiByte(CP_THREAD_ACP, 0, PWideChar(AStr),
            Length(AStr), LPSTR(PADByteString(Result)), Length(Result), nil, nil);
          SetTrailerBytes(Result, False, SizeOf(AnsiChar));
        end;
      ecUTF8:
        begin
          pUTF8 := Alloc(Length(AStr) * C_AD_MaxUTF8Len + 1);
          iLen := WideCharToMultiByte(CP_UTF8, 0, PWideChar(AStr),
            Length(AStr), pUTF8, Length(AStr) * C_AD_MaxUTF8Len + 1, nil, nil);
          SetBytes(Result, pUTF8, iLen, 1);
          Release(pUTF8);
        end;
      ecUTF16:
        SetBytes(Result, PADByteString(@AStr[1]), Length(AStr) * SizeOf(WideChar), 2);
    end;
  {$ELSE}
    case ADestEncoding of
      ecANSI:
        SetBytes(Result, PADByteString(@AStr[1]), Length(AStr) * SizeOf(TADAnsiChar), 1);
      ecUTF8:
        begin
          pWC := Alloc((Length(AStr) + 1) * SizeOf(WideChar) + Length(AStr) * C_AD_MaxUTF8Len + 1);
          pUTF8 := PAnsiChar(pWC + Length(AStr) + 1);
          iLen := MultiByteToWideChar(CP_THREAD_ACP, 0, PAnsiChar(AStr),
            Length(AStr), pWC, Length(AStr));
          iLen := WideCharToMultiByte(CP_UTF8, 0, PWideChar(pWC),
            iLen, pUTF8, Length(AStr) * C_AD_MaxUTF8Len, nil, nil);
          SetBytes(Result, pUTF8, iLen, 1);
          Release(pWC);
        end;
      ecUTF16:
        begin
          iLen := (Length(AStr) + 1) * SizeOf(WideChar);
          SetLength(Result, iLen);
          MultiByteToWideChar(CP_THREAD_ACP, 0, PAnsiChar(AStr),
            Length(AStr), PWideChar(PADByteString(Result)), Length(AStr));
          SetTrailerBytes(Result, False, SizeOf(WideChar));
        end;
    end;
  {$ENDIF}
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  {$IFDEF NEXTGEN}
    case ADestEncoding of
      ecANSI:
        begin
          Result := TEncoding.ANSI.GetBytes(AStr);
          SetTrailerBytes(Result, True, SizeOf(TADAnsiChar));
        end;
      ecUTF8:
        begin
          Result := TEncoding.UTF8.GetBytes(AStr);
          SetTrailerBytes(Result, True, SizeOf(TADAnsiChar));
        end;
      ecUTF16:
        begin
          Result := TEncoding.Unicode.GetBytes(AStr);
          SetTrailerBytes(Result, True, SizeOf(WideChar));
        end;
    end;
  {$ELSE}
    {$IFDEF AnyDAC_D16}
    case ADestEncoding of
      ecANSI:
        begin
          sb := TEncoding.ANSI.GetBytes(AStr);
          SetBytes(Result, PByte(sb), Length(sb), SizeOf(TADAnsiChar));
        end;
      ecUTF8:
        begin
          sb := TEncoding.UTF8.GetBytes(AStr);
          SetBytes(Result, PByte(sb), Length(sb), SizeOf(TADAnsiChar));
        end;
      ecUTF16:
        begin
          sb := TEncoding.Unicode.GetBytes(AStr);
          SetBytes(Result, PByte(sb), Length(sb), SizeOf(WideChar));
        end;
    end;
    {$ELSE}
  if AStr <> '' then
    case ADestEncoding of
      ecANSI:
        SetBytes(Result, PADByteString(@AStr[1]), Length(AStr) * SizeOf(TADAnsiChar), 1);
      ecUTF8:
        begin
          s := AnsiToUtf8(AStr);
          SetBytes(Result, PADByteString(@s[1]), Length(s) * SizeOf(TADAnsiChar), 1);
        end;
      ecUTF16:
        begin
          sw := TADWideString(AStr);
          SetBytes(Result, PADByteString(PWideChar(sw)), Length(sw) * SizeOf(WideChar), 2);
        end;
    end;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
end;
{$WARNINGS ON}

{-------------------------------------------------------------------------------}
function TADEncoder.Decode(const AStr: TADByteString; ASrcEncoding: TADEncoding = ecDefault): String;
{$IFDEF MSWINDOWS}
var
  iLen: Integer;
  pWC: PWideChar;
  {$IFNDEF AnyDAC_Unicode}
  pAC: PAnsiChar;
  {$ENDIF}
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  {$IFNDEF NEXTGEN}
var
    {$IFDEF AnyDAC_D16}
  sb: TBytes;
    {$ELSE}
  sw: TADWideString;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
begin
  Result := '';
  if ASrcEncoding = ecDefault then
    ASrcEncoding := FEncoding;
  if Length(AStr) > 0 then begin
{$IFDEF MSWINDOWS}
  {$IFDEF AnyDAC_Unicode}
    case ASrcEncoding of
      ecANSI:
        begin
          SetLength(Result, Length(AStr));
          MultiByteToWideChar(CP_THREAD_ACP, 0, LPCSTR(PADByteString(AStr)),
            Length(AStr), PWideChar(Result), Length(Result));
        end;
      ecUTF8:
        begin
          pWC := Alloc((Length(AStr) + 1) * SizeOf(WideChar));
          iLen := MultiByteToWideChar(CP_UTF8, 0, LPCSTR(PADByteString(AStr)),
            Length(AStr), pWC, Length(AStr));
          SetString(Result, pWC, iLen);
          Release(pWC);
        end;
      ecUTF16:
        SetString(Result, PChar(PADByteString(AStr)), Length(AStr) div SizeOf(Char));
    end;
  {$ELSE}
    case ASrcEncoding of
      ecANSI:
        Result := AStr;
      ecUTF8:
        begin
          pAC := Alloc(Length(AStr) + 1 + Length(AStr) * SizeOf(WideChar));
          pWC := PWideChar(pAC + Length(AStr) + 1);
          iLen := MultiByteToWideChar(CP_UTF8, 0, PADByteString(AStr),
            Length(AStr), pWC, Length(AStr));
          iLen := WideCharToMultiByte(CP_THREAD_ACP, 0, pWC, iLen,
            pAC, Length(AStr) + 1, nil, nil);
          SetString(Result, pAC, iLen);
          Release(pAC);
        end;
      ecUTF16:
        begin
          SetLength(Result, Length(AStr) * SizeOf(WideChar));
          WideCharToMultiByte(CP_THREAD_ACP, 0, PWideChar(PADByteString(AStr)),
            Length(AStr) div SizeOf(WideChar), PChar(Result), Length(Result), nil, nil);
        end;
    end;
  {$ENDIF}
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  {$IFDEF NEXTGEN}
    case ASrcEncoding of
      ecANSI:
        Result := TEncoding.ANSI.GetString(AStr);
      ecUTF8:
        Result := TEncoding.UTF8.GetString(AStr);
      ecUTF16:
        Result := TEncoding.Unicode.GetString(AStr);
    end;
  {$ELSE}
    {$IFDEF AnyDAC_D16}
    SetLength(sb, Length(AStr));
    Move(PADByteString(AStr)^, PADByteString(sb)^, Length(AStr));
    case ASrcEncoding of
      ecANSI:
        Result := TEncoding.ANSI.GetString(sb);
      ecUTF8:
        Result := TEncoding.UTF8.GetString(sb);
      ecUTF16:
        Result := TEncoding.Unicode.GetString(sb);
    end;
    {$ELSE}
    case ASrcEncoding of
      ecANSI:
        Result := String(AStr);
      ecUTF8:
        Result := Utf8ToAnsi(AStr);
      ecUTF16:
        begin
          SetString(sw, PWideChar(PADByteString(AStr)), Length(AStr) div SizeOf(WideChar));
          Result := String(sw);
        end;
    end;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF NEXTGEN}
type
  MarshaledAString = PAnsiChar;
{$ENDIF}
{$IFNDEF MSWINDOWS}
const
  CP_THREAD_ACP = CP_ACP;
{$ENDIF}

{$IFNDEF AnyDAC_D16}
function UnicodeFromLocaleChars(CodePage, Flags: Cardinal; LocaleStr: PADAnsiString;
  LocaleStrLen: Integer; UnicodeStr: PWideChar; UnicodeStrLen: Integer): Integer;
  {$IFDEF POSIX}
var
  i: Integer;
  {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  Result := MultiByteToWideChar(CodePage, Flags, LocaleStr, LocaleStrLen,
    UnicodeStr, UnicodeStrLen);
  {$ENDIF}
  {$IFDEF POSIX}
  if CodePage = CP_UTF8 then
    Result := Utf8ToUnicode(UnicodeStr, LocaleStrLen + 1, LocaleStr, LocaleStrLen) - 1
  else begin
    Result := LocaleStrLen;
    for i := 0 to Result - 1 do
      (UnicodeStr + i)^ := WideChar((LocaleStr + i)^);
  end;
  {$ENDIF}
end;

{-------------------------------------------------------------------------------}
function LocaleCharsFromUnicode(CodePage, Flags: Cardinal;
  UnicodeStr: PWideChar; UnicodeStrLen: Integer; LocaleStr: PADAnsiString;
  LocaleStrLen: Integer; DefaultChar: PADAnsiString; UsedDefaultChar: PLongBool): Integer;
  {$IFDEF POSIX}
var
  i: Integer;
  {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  Result := WideCharToMultiByte(CodePage, Flags, UnicodeStr, UnicodeStrLen, LocaleStr,
    LocaleStrLen, DefaultChar, PBOOL(UsedDefaultChar));
  {$ENDIF}
  {$IFDEF POSIX}
  if CodePage = CP_UTF8 then
    Result := UnicodeToUtf8(LocaleStr, LocaleStrLen, UnicodeStr, UnicodeStrLen) - 1
  else begin
    Result := UnicodeStrLen;
    for i := 0 to Result - 1 do
      (LocaleStr + i)^ := TADAnsiChar((UnicodeStr + i)^);
  end;
  {$ENDIF}
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADEncoder.Encode(const ASrc: Pointer; ASrcLen: Integer; var ADest: Pointer;
  ASrcEncoding: TADEncoding = ecDefault; ADestEncoding: TADEncoding = ecDefault): Integer;
var
  iLen: Integer;
  pWC: PWideChar;
  iMaxLen: Integer;
  lRelease: Boolean;
begin
  if ASrcEncoding = ecDefault then
    ASrcEncoding := {$IFDEF AnyDAC_Unicode} ecUTF16 {$ELSE} ecANSI {$ENDIF};
  if ADestEncoding = ecDefault then
    ADestEncoding := FEncoding;
  ASSERT(ASrcEncoding in [ecUTF16, ecANSI]);
  Result := 0;
  if (ASrcLen = 0) or (ASrc = nil) then begin
    if (ASrcLen = 0) and (ASrc <> nil) and (ADest = nil) then
      ADest := FBuffer.Check(0);
    Exit;
  end;
  if ASrcEncoding = ecUTF16 then begin
    if ASrcLen = -1 then
      ASrcLen := ADWideStrLen(PWideChar(ASrc));
    case ADestEncoding of
      ecANSI:
        begin
          iMaxLen := ASrcLen * SizeOf(TADAnsiChar) + 1;
          if ADest = nil then
            ADest := Alloc(iMaxLen);
          Result := LocaleCharsFromUnicode(CP_THREAD_ACP, 0, PWideChar(ASrc),
            ASrcLen, MarshaledAString(ADest), iMaxLen, nil, nil);
        end;
      ecUTF8:
        begin
          iMaxLen := ASrcLen * C_AD_MaxUTF8Len + 1;
          if ADest = nil then
            ADest := Alloc(iMaxLen);
          Result := LocaleCharsFromUnicode(CP_UTF8, 0, PWideChar(ASrc),
            ASrcLen, MarshaledAString(ADest), iMaxLen, nil, nil);
        end;
      ecUTF16:
        begin
          Result := ASrcLen;
          if ADest = nil then
            ADest := ASrc
          else
            Move(ASrc^, ADest^, ASrcLen * SizeOf(WideChar));
        end;
    end;
  end
  else begin
    if ASrcLen = -1 then
      ASrcLen := ADAnsiStrLen(PADAnsiString(ASrc));
    case ADestEncoding of
      ecANSI:
        begin
          Result := ASrcLen;
          if ADest = nil then
            ADest := ASrc
          else
            Move(ASrc^, ADest^, ASrcLen * SizeOf(TADAnsiChar));
        end;
      ecUTF8:
        begin
          iMaxLen := ASrcLen * C_AD_MaxUTF8Len + 2;
          if ADest = nil then begin
            ADest := Alloc(iMaxLen + (ASrcLen + 1) * SizeOf(WideChar));
            pWC := PWideChar(TADNativeInt(ADest) + iMaxLen);
            lRelease := False;
          end
          else begin
            pWC := Alloc((ASrcLen + 1) * SizeOf(WideChar));
            lRelease := False;
          end;
          iLen := UnicodeFromLocaleChars(CP_THREAD_ACP, 0, MarshaledAString(ASrc),
            ASrcLen, pWC, ASrcLen);
          Result := LocaleCharsFromUnicode(CP_UTF8, 0, pWC,
            iLen, MarshaledAString(ADest), iMaxLen, nil, nil);
          if lRelease then
            Release(pWC);
        end;
      ecUTF16:
        begin
          iMaxLen := (ASrcLen + 1) * SizeOf(WideChar);
          if ADest = nil then
            ADest := Alloc(iMaxLen);
          Result := UnicodeFromLocaleChars(CP_THREAD_ACP, 0, MarshaledAString(ASrc),
            ASrcLen, PWideChar(ADest), iMaxLen);
        end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADEncoder.Encode(const ASrc: Pointer; ASrcLen: Integer;
  ASrcEncoding: TADEncoding = ecDefault; ADestEncoding: TADEncoding = ecDefault): TADByteString;
var
  iLen: Integer;
  pDest: Pointer;
  iTrailerLen: Integer;
begin
  pDest := nil;
  iLen := Encode(ASrc, ASrcLen, pDest, ASrcEncoding, ADestEncoding);
  if ADestEncoding = ecDefault then
    ADestEncoding := FEncoding;
  case ADestEncoding of
  ecANSI,
  ecUTF8:  iTrailerLen := SizeOf(TADAnsiChar);
  ecUTF16: iTrailerLen := SizeOf(WideChar);
  else     iTrailerLen := 0;
  end;
  SetBytes(Result, pDest, iLen, iTrailerLen);
end;

{-------------------------------------------------------------------------------}
function TADEncoder.Decode(const ASrc: Pointer; ASrcLen: Integer; var ADest: Pointer;
  ADestEncoding: TADEncoding = ecDefault; ASrcEncoding: TADEncoding = ecDefault): Integer;
var
  iLen: Integer;
  pWC: PWideChar;
  iMaxLen: Integer;
  lRelease: Boolean;
begin
  if ADestEncoding = ecDefault then
    ADestEncoding := {$IFDEF AnyDAC_Unicode} ecUTF16 {$ELSE} ecANSI {$ENDIF};
  if ASrcEncoding = ecDefault then
    ASrcEncoding := FEncoding;
  ASSERT(ADestEncoding in [ecUTF16, ecANSI]);
  Result := 0;
  if (ASrcLen = 0) or (ASrc = nil) then begin
    if (ASrcLen = 0) and (ASrc <> nil) and (ADest = nil) then
      ADest := FBuffer.Check(0);
    Exit;
  end;
  if ADestEncoding = ecUTF16 then
    case ASrcEncoding of
      ecANSI:
        begin
          if ASrcLen = -1 then
            ASrcLen := ADAnsiStrLen(PADAnsiString(ASrc));
          iMaxLen := (ASrcLen + 1) * SizeOf(WideChar);
          if ADest = nil then
            ADest := Alloc(iMaxLen);
          Result := UnicodeFromLocaleChars(CP_THREAD_ACP, 0, MarshaledAString(ASrc),
            ASrcLen, PWideChar(ADest), iMaxLen);
        end;
      ecUTF8:
        begin
          if ASrcLen = -1 then
            ASrcLen := ADAnsiStrLen(PADAnsiString(ASrc));
          iMaxLen := (ASrcLen + 1) * SizeOf(WideChar);
          if ADest = nil then
            ADest := Alloc(iMaxLen);
          Result := UnicodeFromLocaleChars(CP_UTF8, 0, MarshaledAString(ASrc),
            ASrcLen, PWideChar(ADest), iMaxLen);
        end;
      ecUTF16:
        begin
          if ASrcLen = -1 then
            ASrcLen := ADWideStrLen(PWideChar(ASrc));
          Result := ASrcLen;
          if ADest = nil then
            ADest := ASrc
          else
            Move(ASrc^, ADest^, ASrcLen * SizeOf(WideChar));
        end;
    end
  else
    case ASrcEncoding of
      ecANSI:
        begin
          if ASrcLen = -1 then
            ASrcLen := ADAnsiStrLen(PADAnsiString(ASrc));
          Result := ASrcLen;
          if ADest = nil then
            ADest := ASrc
          else
            Move(ASrc^, ADest^, ASrcLen * SizeOf(TADAnsiChar));
        end;
      ecUTF8:
        begin
          if ASrcLen = -1 then
            ASrcLen := ADAnsiStrLen(PADAnsiString(ASrc));
          iMaxLen := (ASrcLen + 1) * SizeOf(TADAnsiChar);
          if Odd(iMaxLen) then
            Inc(iMaxLen);
          if ADest = nil then begin
            ADest := Alloc(iMaxLen + (ASrcLen + 1) * SizeOf(WideChar));
            pWC := PWideChar(TADNativeInt(ADest) + iMaxLen);
            lRelease := False;
          end
          else begin
            pWC := Alloc((ASrcLen + 1) * SizeOf(WideChar));
            lRelease := True;
          end;
          iLen := UnicodeFromLocaleChars(CP_UTF8, 0, MarshaledAString(ASrc),
            ASrcLen, pWC, ASrcLen);
          Result := LocaleCharsFromUnicode(CP_THREAD_ACP, 0, pWC, iLen,
            MarshaledAString(ADest), iMaxLen, nil, nil);
          if lRelease then
            Release(pWC);
        end;
      ecUTF16:
        begin
          if ASrcLen = -1 then
            ASrcLen := ADWideStrLen(PWideChar(ASrc));
          iMaxLen := (ASrcLen + 1) * SizeOf(TADAnsiChar);
          if ADest = nil then
            ADest := Alloc(iMaxLen);
          Result := LocaleCharsFromUnicode(CP_THREAD_ACP, 0, PWideChar(ASrc),
            ASrcLen, MarshaledAString(ADest), iMaxLen, nil, nil);
        end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADEncoder.Decode(const ASrc: Pointer; ASrcLen: Integer = -1;
  ASrcEncoding: TADEncoding = ecDefault): String;
var
  iDestLen: Integer;
  pDest: Pointer;
begin
  if ASrcEncoding = ecDefault then
    ASrcEncoding := FEncoding;
  ASSERT(ASrcEncoding <> ecDefault);
  pDest := nil;
  iDestLen := Decode(ASrc, ASrcLen, pDest, ecDefault, ASrcEncoding);
  SetString(Result, PChar(pDest), iDestLen);
  Release(pDest);
end;

{-------------------------------------------------------------------------------}
function TADEncoder.GetPreamble: TADByteString;
const
  C_UTF8: array [0 .. 2] of Byte = ($EF, $BB, $BF);
  C_UTF16: array [0 .. 1] of Byte = ($FF, $FE);
begin
  case FEncoding of
  ecANSI:  SetLength(Result, 0);
  ecUTF8:  SetBytes(Result, @C_UTF8[0], SizeOf(C_UTF8), 0);
  ecUTF16: SetBytes(Result, @C_UTF16[0], SizeOf(C_UTF16), 0);
  end;
end;

{-------------------------------------------------------------------------------}
class function TADEncoder.Deco(const ASrc: Pointer; ASrcLen: Integer = -1;
  ASrcEncoding: TADEncoding = ecDefault): String;
begin
  Result := GEncoder.Decode(ASrc, ASrcLen, ASrcEncoding);
end;

{-------------------------------------------------------------------------------}
class function TADEncoder.Deco(const ASrc: TADByteString;
  ASrcEncoding: TADEncoding = ecDefault): String;
begin
  Result := GEncoder.Decode(ASrc, ASrcEncoding);
end;

{-------------------------------------------------------------------------------}
class function TADEncoder.Enco(const AStr: String; ADestEncoding: TADEncoding): TADByteString;
begin
  Result := GEncoder.Encode(AStr, ADestEncoding);
end;

{-------------------------------------------------------------------------------}
{ TADTextFile                                                                   }
{-------------------------------------------------------------------------------}
constructor TADTextFile.Create(const AFileName: String; ARead, AAppend: Boolean;
  AEncoding: TADEncoding; AEndOfLine: TADTextEndOfLine);
var
  oStream: TStream;
begin
  inherited Create;
  if not ARead then begin
    if not FileExists(AFileName) then
      FileClose(FileCreate(AFileName));
    oStream := TADFileStream.Create(AFileName, fmOpenWrite or fmShareDenyWrite);
  end
  else
    oStream := TADFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  Create(oStream, True, ARead, AAppend, AEncoding, AEndOfLine);
end;

{-------------------------------------------------------------------------------}
constructor TADTextFile.Create(AStream: TStream; AOwned, ARead, AAppend: Boolean;
  AEncoding: TADEncoding; AEndOfLine: TADTextEndOfLine);
var
  sb1, sb2: TADByteString;
begin
  inherited Create;
  FStream := AStream;
  FStreamOwned := AOwned;
  FBuffer := TADBuffer.Create;
  FEncoder := TADEncoder.Create(FBuffer);
  FEncoder.Encoding := AEncoding;
  FEndOfLine := AEndOfLine;
  if ARead then begin
    sb1 := FEncoder.Preamble;
    if Length(sb1) <> 0 then begin
      SetLength(sb2, Length(sb1));
      FStream.Read(PADByteString(sb2)^, Length(sb2));
      if sb1 <> sb2 then
        FStream.Position := 0;
    end;
  end
  else
    if AAppend and (FStream.Size > 0) then begin
      FStream.Position := FStream.Size;
      if FStream is TADFileStream then
        TADFileStream(FStream).SyncBuffer(True);
      if FStream.Position > 0 then
        WriteLine('');
    end
    else begin
      FStream.Size := 0;
      if FStream is TADFileStream then
        TADFileStream(FStream).SyncBuffer(True);
      sb1 := FEncoder.Preamble;
      if Length(sb1) <> 0 then
        FStream.Write(PADByteString(sb1)^, Length(sb1));
    end;
end;

{-------------------------------------------------------------------------------}
destructor TADTextFile.Destroy;
begin
  if FStreamOwned then
    ADFree(FStream);
  FStream := nil;
  ADFreeAndNil(FEncoder);
  ADFreeAndNil(FBuffer);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADTextFile.GetPosition: Int64;
begin
  Result := FStream.Position;
  if FEncoder.Encoding = ecUTF16 then
    Result := Result div SizeOf(WideChar);
end;

{-------------------------------------------------------------------------------}
procedure TADTextFile.SetPosition(AValue: Int64);
begin
  if FEncoder.Encoding = ecUTF16 then
    AValue := AValue * SizeOf(WideChar);
  FStream.Position := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFile.WriteText(const AText: String);
var
  sb: TADByteString;
begin
  if Length(AText) > 0 then begin
    sb := FEncoder.Encode(AText);
    FStream.Write(PADByteString(sb)^, ADByteStrLength(sb));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFile.WriteLine(const AText: String);
begin
  WriteText(AText);
  case EndOfLine of
  elDefault: {$IFDEF MSWINDOWS} WriteText(C_AD_WinEOL) {$ENDIF}
             {$IFDEF MACOS}     WriteText(C_AD_MacEOL) {$ENDIF}
             {$IFDEF UNIX}
               {$IFNDEF MACOS}  WriteText(C_AD_UnixEOL) {$ENDIF}{$ENDIF};
  elWindows: WriteText(C_AD_WinEOL);
  elUnix:    WriteText(C_AD_UnixEOL);
  elMac:     WriteText(C_AD_MacEOL);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFile.WriteChar(const AChar: Char);
var
  aBuff: array [0 .. 3] of Byte;
  pByte: Pointer;
  iLen: Integer;
begin
  pByte := @aBuff[0];
  iLen := FEncoder.Encode(@AChar, 1, pByte);
  if FEncoder.Encoding = ecUTF16 then
    iLen := iLen * SizeOf(WideChar);
  FStream.Write(aBuff[0], iLen);
end;

{-------------------------------------------------------------------------------}
function TADTextFile.ReadChars(out AChar: Char; ACount: Integer): Integer;
var
  aBuff: array [0 .. 4095] of Byte;
  pCh: Pointer;
  c: Byte;
  iBytes, iChars: Integer;
begin
  Result := 0;
  case FEncoder.Encoding of
{$IFNDEF AnyDAC_Unicode}
  ecDefault,
{$ENDIF}
  ecANSI:
    begin
{$IFDEF AnyDAC_Unicode}
      iChars := FStream.Read(aBuff[0], ACount * SizeOf(TADAnsiChar)) div SizeOf(TADAnsiChar);
      pCh := @AChar;
      Result := FEncoder.Decode(@aBuff[0], iChars, pCh);
{$ELSE}
      Result := FStream.Read(AChar, ACount * SizeOf(TADAnsiChar)) div SizeOf(TADAnsiChar);
{$ENDIF}
    end;
  ecUTF8:
    begin
      iBytes := 0;
      iChars := 0;
      while (iBytes < 4095) and (iChars < ACount) do begin
        if FStream.Read(aBuff[iBytes], 1) <> 1 then
          Break;
        c := Byte(aBuff[iBytes]);
        Inc(iBytes);
        if (c and $80) <> 0 then begin
          if FStream.Read(aBuff[iBytes], 1) <> 1 then
            Break;           // incomplete multibyte char
          c := c and $3F;
          if (c and $20) <> 0 then begin
            c := Byte(aBuff[iBytes]);
            Inc(iBytes);
            if (c and $C0) <> $80 then
              Break;         // malformed trail byte or out of range char
            if FStream.Read(aBuff[iBytes], 1) <> 1 then
              Break;         // incomplete multibyte char
          end;
          c := Byte(aBuff[iBytes]);
          Inc(iBytes);
          if (c and $C0) <> $80 then
            Break;           // malformed trail byte
        end;
        Inc(iChars);
      end;
      pCh := @AChar;
      Result := FEncoder.Decode(@aBuff[0], iBytes, pCh);
    end;
{$IFDEF AnyDAC_Unicode}
  ecDefault,
{$ENDIF}
  ecUTF16:
    begin
{$IFDEF AnyDAC_Unicode}
      Result := FStream.Read(AChar, ACount * SizeOf(WideChar)) div SizeOf(WideChar);
{$ELSE}
      iChars := FStream.Read(aBuff[0], ACount * SizeOf(WideChar)) div SizeOf(WideChar);
      pCh := @AChar;
      Result := FEncoder.Decode(@aBuff[0], iChars, pCh);
{$ENDIF}
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTextFile.ReadChar(out AChar: Char): Boolean;
begin
  Result := ReadChars(AChar, 1) = 1;
  if not Result then
    AChar := #0;
end;

{-------------------------------------------------------------------------------}
function TADTextFile.ReadLine: String;
var
  aBuff: array [0 .. 8191] of Char;
  lEOF: Boolean;
  i: Integer;
begin
  i := -1;
  repeat
    Inc(i);
    lEOF := not ReadChar(aBuff[i]);
  until lEOF or (aBuff[i] = #13) or (aBuff[i] = #10);
  if lEOF and (aBuff[i] <> #0) then
    Inc(i);
  SetString(Result, aBuff, i);
  if EndOfLine in [elWindows {$IFDEF MSWINDOWS}, elDefault {$ENDIF}] then
    ReadChar(aBuff[0]);
end;

{-------------------------------------------------------------------------------}
function TADTextFile.ExtractString(AFromPosition, AToPosition: Integer): String;
var
  aBuff: array [0 .. 8191] of Byte;
  sBuff: TADByteString;
  pBuff: Pointer;
  iRead, iChars: Integer;
  iCurPos: Int64;
  pCh: Pointer;
begin
  iRead := AToPosition - AFromPosition + 1;
  if FEncoder.Encoding = ecUTF16 then begin
    AFromPosition := AFromPosition * SizeOf(WideChar);
    iRead := iRead * SizeOf(WideChar);
  end;
  Result := '';
  if iRead = 0 then
    Exit;
  iCurPos := FStream.Position;
  FStream.Position := AFromPosition;
  if iRead > SizeOf(aBuff) then begin
    SetLength(sBuff, iRead);
    pBuff := PADByteString(sBuff);
  end
  else
    pBuff := @aBuff[0];
  iRead := FStream.Read(pBuff^, iRead);
  if FEncoder.Encoding = ecUTF16 then
    iRead := iRead div SizeOf(WideChar);
  FStream.Position := iCurPos;
  pCh := nil;
  iChars := FEncoder.Decode(pBuff, iRead, pCh);
  SetString(Result, PChar(pCh), iChars);
end;

{-------------------------------------------------------------------------------}
{ TADLog                                                                        }
{-------------------------------------------------------------------------------}
procedure TADLog.Value(const AName, AValue: String);
begin
  Msg(Format('Variable [%s]: [%s]', [AName, AValue]));
end;

{-------------------------------------------------------------------------------}
procedure TADLog.Msg(const AMsg: String);
begin
  Add(StringOfChar(' ', FLogLevel * 2) + AMsg);
end;

{-------------------------------------------------------------------------------}
procedure TADLog.Start(const AMsg: String);
begin
  Msg(AMsg + ' ...');
  Inc(FLogLevel);
end;

{-------------------------------------------------------------------------------}
procedure TADLog.Stop;
begin
  Dec(FLogLevel);
end;

{-------------------------------------------------------------------------------}
{ TADLibrary                                                                    }
{-------------------------------------------------------------------------------}
constructor TADLibrary.Create(const ADriverID: String; AOwningObj: TObject);
begin
  inherited Create;
  FDriverID := ADriverID;
  FOwningObj := AOwningObj;
  FFailedProcs := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
procedure TADLibrary.Load(const ADLLNames: array of String; ARequired: Boolean);
begin
  FFailedProcs.Clear;
  LoadLibrary(ADLLNames, ARequired);
  if FhDLL <> 0 then begin
    GetLibraryInfo;
    LoadEntries;
  end;
  if FFailedProcs.Count > 0 then
    ADException(FOwningObj, [S_AD_LPhys, FDriverID], er_AD_AccCantGetLibraryEntry,
      [Trim(FFailedProcs.Text)]);
end;

{-------------------------------------------------------------------------------}
destructor TADLibrary.Destroy;
begin
  Unload;
  ADFreeAndNil(FFailedProcs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADLibrary.LoadLibrary(const ADLLNames: array of String; ARequired: Boolean);
{$IFDEF MSWINDOWS}
type
  TSetDllDirectory = function (lpPathName: PChar): BOOL; stdcall;
{$ENDIF}
var
  sLibs, sErr: String;
  i: Integer;
{$IFDEF MSWINDOWS}
  sPath, sCurrDir: String;
  hKernel: HMODULE;
  pSetDllDirectory: TSetDllDirectory;
  iBinType: Longword;
{$ENDIF}
begin
  FhDLL := 0;
  FDLLName := '';

{$IFDEF MSWINDOWS}
  hKernel := Windows.LoadLibrary(PChar(kernel32));
  pSetDllDirectory := GetProcAddress(hKernel, PChar(
    'SetDllDirectory' + {$IFDEF AnyDAC_Unicode} 'W' {$ELSE} 'A' {$ENDIF}));
  if not Assigned(pSetDllDirectory) then
    sCurrDir := GetCurrentDir
  else
    sCurrDir := '';

  try
    for i := Low(ADLLNames) to High(ADLLNames) do
      if ADLLNames[i] <> '' then begin
        sPath := ExtractFilePath(ADLLNames[i]);
        // If a full library path is specified, then force Windows to load the DLL's
        // at first from this folder, then from System32 or how else. This allows
        // to avoid the chances for getting a DLL version conflict.
        if sPath <> '' then
          if Assigned(pSetDllDirectory) then
            pSetDllDirectory(PChar(sPath))
          else
            SetCurrentDir(sPath);
        try
          FhDLL := SafeLoadLibrary(ADLLNames[i]);
        finally
          if sPath <> '' then
            if Assigned(pSetDllDirectory) then
              pSetDllDirectory(nil)
            else
              SetCurrentDir(sCurrDir);
        end;
        if FhDLL <> 0 then
          Break;
      end;

  finally
    FreeLibrary(hKernel);
  end;
{$ENDIF}

{$IFDEF AnyDAC_POSIX}
    for i := Low(ADLLNames) to High(ADLLNames) do
      if ADLLNames[i] <> '' then begin
        FhDll := SafeLoadLibrary(ADLLNames[i]);
        if FhDLL <> 0 then begin
          FDLLName := ADLLNames[i];
          Break;
        end;
      end;
{$ENDIF}

  if (FhDLL = 0) and ARequired then begin
    sLibs := '';
    sErr := '';
    for i := Low(ADLLNames) to High(ADLLNames) do begin
      if Low(ADLLNames) <> High(ADLLNames) then
        if i = High(ADLLNames) then
          sLibs := sLibs + ' or '
        else if i > Low(ADLLNames) then
          sLibs := sLibs + ', ';
      sLibs := sLibs + ADLLNames[i];
{$IFDEF MSWINDOWS}
      if GetBinaryType(PChar(ADLLNames[i]), iBinType) and
         (iBinType = {$IFDEF AnyDAC_32} 6 {SCS_64BIT_BINARY} {$ELSE} SCS_32BIT_BINARY {$ENDIF}) then
        sErr := sErr + Format('%s has not supported architecture [%s]. Required [%s].', [ADLLNames[i],
          {$IFDEF AnyDAC_32} 'x64' {$ELSE} 'x86' {$ENDIF},
          {$IFDEF AnyDAC_32} 'x86' {$ELSE} 'x64' {$ENDIF}]) + C_AD_EOL;
{$ENDIF}
    end;
    sErr := sErr + ADLastSystemErrorMsg;
    if (sErr <> '') and not ADInSet(sErr[Length(sErr)], [#13, #10, '.']) then
      sErr := sErr + C_AD_EOL;
    ADException(OwningObj, [S_AD_LPhys, FDriverID], er_AD_AccCantLoadLibrary,
      [sLibs, sErr])
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADLibrary.Unload;
begin
  if FhDLL <> 0 then begin
    FreeLibrary(FhDLL);
    FhDLL := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADLibrary.GetLibraryInfo;
begin
  FProduct := '';
  FVersionStr := '';
  FVersionName := '';
  FCopyright := '';
  FInfo := '';
  FVersion := 0;
  if FhDLL = 0 then
    Exit;
{$IFDEF MSWINDOWS}
  SetLength(FDLLName, 255);
  SetLength(FDLLName, GetModuleFileName(FhDLL, PChar(FDLLName), 255));
  ADGetVersionInfo(FDLLName, FProduct, FVersionStr, FVersionName, FCopyright, FInfo);
  if FVersionStr <> '' then
    FVersion := ADVerStr2Int(FVersionStr)
  else
    FVersion := 0;
  if FVersion <= 100000000 then
    if FVersionName <> '' then
      FVersion := ADVerStr2Int(FVersionName)
    else
      FVersion := 0;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  {$IFNDEF AnyDAC_FPC}
  SetLength(FDLLName, 255);
  SetLength(FDLLName, GetModuleFileName(FhDLL, PChar(FDLLName), 255) - 1);
  {$ENDIF}
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADLibrary.GetProc(const AProcName: String; ARequired: Boolean = True): Pointer;
begin
  if FhDLL <> 0 then begin
    Result := GetProcAddress(FhDLL, PChar(AProcName));
    if (Result = nil) and ARequired then
      FFailedProcs.Add(AProcName);
  end
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
{ TADConfigFile                                                                 }
{-------------------------------------------------------------------------------}
constructor TADConfigFile.Create(AReadOnly: Boolean);
{$IFDEF MSWINDOWS}
var
  iAccess: LongWord;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if AReadOnly then
    iAccess := KEY_READ
  else
    iAccess := KEY_WRITE;
  inherited Create('', iAccess);
  RegIniFile.OpenKey(S_AD_CfgKeyName, not AReadOnly);
{$ENDIF}
{$IFDEF POSIX}
  inherited Create(ADGetAppDocPath + S_AD_CfgFile);
  FReadOnly := AReadOnly;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{$IFNDEF MSWINDOWS}
destructor TADConfigFile.Destroy;
begin
  if not FReadOnly then
    try
      UpdateFile;
    except
      // none
    end;
  inherited Destroy;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADIniFile                                                                    }
{-------------------------------------------------------------------------------}
destructor TADIniFile.Destroy;
begin
  UpdateFile;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADIniFile.WriteString(const Section, Ident, Value: String);
begin
  inherited WriteString(Section, Ident, Value);
  FModified := True;
end;

{-------------------------------------------------------------------------------}
procedure TADIniFile.DeleteKey(const Section, Ident: String);
begin
  inherited DeleteKey(Section, Ident);
  FModified := True;
end;

{-------------------------------------------------------------------------------}
procedure TADIniFile.EraseSection(const Section: string);
begin
  inherited EraseSection(Section);
  FModified := True;
end;

{-------------------------------------------------------------------------------}
procedure TADIniFile.UpdateFile;
begin
  if FModified then begin
    FModified := False;
    inherited UpdateFile;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADCodeGenerator                                                              }
{-------------------------------------------------------------------------------}
const
  CCommentBrd  = '{-------------------------------------------------------------------------------}';
  CCommentBody = '{                                       }';

{-------------------------------------------------------------------------------}
procedure WriteStr(AStream: TStream; const AStr: String);
var
  sb: TADByteString;
begin
  sb := TADEncoder.Enco(AStr + #13#10, ecANSI);
  AStream.Write(PADByteString(sb)^, ADByteStrLength(sb));
end;

{-------------------------------------------------------------------------------}
procedure WriteComment(AStream: TStream; const AStr: String);
var
  S: String;
begin
  S := CCommentBody;
  if AStr <> '' then
    if Length(AStr) > Length(CCommentBody) - 6 then
      Move(AStr[1], S[3], (Length(CCommentBody) - 6) * SizeOf(Char))
    else
      Move(AStr[1], S[3], Length(AStr) * SizeOf(Char));
  WriteStr(AStream, S);
end;

{-------------------------------------------------------------------------------}
procedure WriteCommentBorder(AStream: TStream);
begin
  WriteStr(AStream, CCommentBrd);
end;

{-------------------------------------------------------------------------------}
procedure StartNewMethod(AStream: TStream; ASourceName: String);
begin
  WriteStr(AStream, '');
  if ASourceName <> '' then
    WriteStr(AStream, '// Generated for: Stored Procedure ' + ASourceName);
end;

{-------------------------------------------------------------------------------}
constructor TADCodeGenerator.Create;
var
  intf: TADIntfCodePart;
  impl: TADImplCodePart;
begin
  inherited Create;
  for intf := Low(TADIntfCodePart) to High(TADIntfCodePart) do
    FIntfStreams[intf] := TMemoryStream.Create;
  for impl := Low(TADImplCodePart) to High(TADImplCodePart) do
    FImplStreams[impl] := TMemoryStream.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADCodeGenerator.Destroy;
var
  intf: TADIntfCodePart;
  impl: TADImplCodePart;
begin
  for intf := Low(TADIntfCodePart) to High(TADIntfCodePart) do
    FIntfStreams[intf].Free;
  for impl := Low(TADImplCodePart) to High(TADImplCodePart) do
    FImplStreams[impl].Free;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADCodeGenerator.WriteImpl(APart: TADImplCodePart; const AStr: String);
begin
  WriteStr(FImplStreams[APart], AStr);
end;

{-------------------------------------------------------------------------------}
procedure TADCodeGenerator.WriteImplNewMethod(ASourceName: String);
begin
  StartNewMethod(FImplStreams[ipMethod], ASourceName);
end;

{-------------------------------------------------------------------------------}
procedure TADCodeGenerator.WriteIntf(APart: TADIntfCodePart; const AStr: String);
begin
  WriteStr(FIntfStreams[APart], AStr);
end;

{-------------------------------------------------------------------------------}
procedure TADCodeGenerator.SaveImpl(AStream: TStream);
var
  lNeedDelim: Boolean;
begin
  WriteStr(AStream, '// ' + MyClassName);
  WriteStr(AStream, '// Generated for: ' + OriginalObject);
  lNeedDelim := False;
  if FImplStreams[ipHeader].Size > 0 then begin
    if lNeedDelim then
      StartNewMethod(AStream, '');
    AStream.CopyFrom(FImplStreams[ipHeader], 0);
    lNeedDelim := True;
  end;
  if FImplStreams[ipConstr].Size > 0 then begin
    if lNeedDelim then
      StartNewMethod(AStream, '');
    if FIsComponent then begin
      WriteStr(AStream, 'constructor ' + MyClassName + '.Create(AOwner: TComponent);');
      WriteStr(AStream, 'begin');
      WriteStr(AStream, '  inherited Create(AOwner);');
    end
    else begin
      WriteStr(AStream, 'constructor ' + MyClassName + '.Create;');
      WriteStr(AStream, 'begin');
      WriteStr(AStream, '  inherited Create;');
    end;
    AStream.CopyFrom(FImplStreams[ipConstr], 0);
    WriteStr(AStream, 'end;');
    lNeedDelim := True;
  end;
  if FImplStreams[ipDestr].Size > 0 then begin
    if lNeedDelim then
      StartNewMethod(AStream, '');
    WriteStr(AStream, 'destructor ' + MyClassName + '.Destroy;');
    WriteStr(AStream, 'begin');
    AStream.CopyFrom(FImplStreams[ipDestr], 0);
    WriteStr(AStream, '  inherited Destroy;');
    WriteStr(AStream, 'end;');
  end;
  if FImplStreams[ipMethod].Size > 0 then begin
    AStream.CopyFrom(FImplStreams[ipMethod], 0);
    lNeedDelim := True;
  end;
  if not lNeedDelim then
    WriteStr(AStream, '// - no methods');
  WriteStr(AStream, '');
end;

{-------------------------------------------------------------------------------}
procedure TADCodeGenerator.SaveIntf(AStream: TStream);
begin
  WriteStr(AStream, '  // ' + MyClassName);
  WriteStr(AStream, '  // Generated for: ' + OriginalObject);
  if FIntfStreams[cpHeader].Size > 0 then begin
    AStream.CopyFrom(FIntfStreams[cpHeader], 0);
    WriteStr(AStream, '');
  end;
  WriteStr(AStream, '  ' + MyClassName + ' = class(' + ParentClassName + ')');
  if FIntfStreams[cpPrivate].Size > 0 then begin
    WriteStr(AStream, '  private');
    AStream.CopyFrom(FIntfStreams[cpPrivate], 0);
  end;
  if FIntfStreams[cpProtected].Size > 0 then begin
    WriteStr(AStream, '  protected');
    AStream.CopyFrom(FIntfStreams[cpProtected], 0);
  end;
  if (FIntfStreams[cpPublic].Size > 0) or
     (FImplStreams[ipConstr].Size > 0) or
     (FImplStreams[ipDestr].Size > 0) then begin
    WriteStr(AStream, '  public');
    if FImplStreams[ipConstr].Size > 0 then
      if FIsComponent then
        WriteStr(AStream, '  constructor Create(AOwner: TComponent); override;')
      else
        WriteStr(AStream, '  constructor Create; override;');
    if FImplStreams[ipDestr].Size > 0 then
      WriteStr(AStream, '  destructor Destroy; override;');
    if FIntfStreams[cpPublic].Size > 0 then
      AStream.CopyFrom(FIntfStreams[cpPublic], 0);
  end;
  if FIntfStreams[cpPublished].Size > 0 then begin
    WriteStr(AStream, '  published');
    AStream.CopyFrom(FIntfStreams[cpPublished], 0);
  end;
  WriteStr(AStream, '  end;');
  WriteStr(AStream, '');
end;

{-------------------------------------------------------------------------------}
{ Routines                                                                      }
{-------------------------------------------------------------------------------}
function ADStrLike(const AStr, AMask: String; ANoCase: Boolean = False;
  AManyCharsMask: Char = '%'; AOneCharMask: Char = '_'; AEscapeChar: Char = '\'): Boolean;

  function InternalScan(pStr, pMask: PChar): Boolean;
  begin
    Result := True;
    while ((pStr^ = pMask^) and (pMask^ <> AManyCharsMask) or
        (pMask^ = AOneCharMask) or (pMask^ = AEscapeChar)) and
       (pStr^ <> #0) and (pMask^ <> #0) do begin
      if pMask^ = AEscapeChar then begin
        Inc(pMask);
        if pStr^ <> pMask^ then
          Break;
      end;
      Inc(pMask);
      Inc(pStr);
    end;
    if pMask^ = AManyCharsMask then begin
      while (pMask^ = AManyCharsMask) or (pMask^ = AOneCharMask) do begin
        if pMask^ = AOneCharMask then
          if pStr^ = #0 then begin
            Result := False;
            Exit;
          end
          else
            Inc(pStr);
        Inc(pMask);
      end;
      if pMask^ <> #0 then begin
        while (pStr^ <> #0) and ((pMask^ <> pStr^) or not InternalScan(pStr, pMask)) do
          Inc(pStr);
        Result := pStr^ <> #0;
      end;
    end
    else
      Result := (pMask^ = #0) and (pStr^ = #0);
  end;

begin
  if AMask = AManyCharsMask then
    Result := True
  else if (AMask = '') or (AStr = '') then
    Result := False
  else begin
    if ANoCase then
      Result := InternalScan(PChar(AnsiUpperCase(AStr)), PChar(AnsiUpperCase(AMask)))
    else
      Result := InternalScan(PChar(AStr), PChar(AMask));
  end;
end;

{-------------------------------------------------------------------------------}
function ADPosEx(const ASub, AStr: String; AFrom: Integer = 1): Integer;
var
  P: PChar;
begin
  if AFrom < 1 then
    AFrom := 1;
  if AFrom > Length(AStr) then
    Result := 0
  else begin
    P := StrPos(PChar(AStr) + (AFrom - 1), PChar(ASub));
    if P = nil then
      Result := 0
    else
      Result := P - PChar(AStr) + 1;
  end;
end;

{-------------------------------------------------------------------------------}
function ADStrRPos(Str1, Str2: PChar): PChar;
var
  p1, p2, pBSub, pESub, pBS, pES: PChar;
begin
  Result := nil;
  if (Str1 = nil) or (Str2 = nil) then
    Exit;
  pBSub := Str2;
  pESub := Str2 + StrLen(Str2) - 1;
  pBS := Str1 + StrLen(Str2) - 1;
  pES := Str1 + StrLen(Str1) - 1;
  while pES >= pBS do begin
    if pES^ = pESub^ then begin
      p1 := pES;
      p2 := pESub;
      while (p2 >= pBSub) and (p1^ = p2^) do begin
        Dec(p1);
        Dec(p2);
      end;
      if p2 < pBSub then begin
        Result := p1 + 1;
        Exit;
      end;
    end;
    Dec(pES);
  end;
end;

{-------------------------------------------------------------------------------}
function ADPadR(const AStr: String; ALength: Integer): String;
begin
  if Length(AStr) > ALength then
    Result := Copy(AStr, 1, ALength)
  else
    Result := AStr + StringOfChar(' ', ALength - Length(AStr));
end;

{-------------------------------------------------------------------------------}
function ADPadL(const AStr: String; ALength: Integer): String;
begin
  if Length(AStr) > ALength then
    Result := Copy(AStr, 1, ALength)
  else
    Result := StringOfChar(' ', ALength - Length(AStr)) + AStr;
end;

{-------------------------------------------------------------------------------}
procedure ADBin2HexBS(APtr: Pointer; ALen: Integer; ADest: PADByteString);
{$IFDEF NEXTGEN}
var
  aData, aBuff: TBytes;
{$ENDIF}
begin
  if not ((APtr = nil) or (ALen = 0)) then begin
{$IFNDEF NEXTGEN}
    BinToHex(PAnsiChar(APtr), PAnsiChar(ADest), ALen);
{$ELSE}
    SetLength(aData, ALen);
    Move(APtr^, aData[0], ALen);
    SetLength(aBuff, ALen * 2);
    BinToHex(aData, 0, aBuff, 0, ALen);
    Move(PADByteString(aBuff)^, ADest^, Length(aBuff));
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function ADBin2Hex(APtr: Pointer; ALen: Integer): String;
{$IFDEF NEXTGEN}
var
  aData, aBuff: TBytes;
{$ENDIF}
begin
  if (APtr = nil) or (ALen = 0) then
    Result := ''
  else begin
{$IFNDEF NEXTGEN}
    SetLength(Result, ALen * 2);
    BinToHex(PAnsiChar(APtr), PChar(Result), ALen);
{$ELSE}
    SetLength(aData, ALen);
    Move(APtr^, aData[0], ALen);
    SetLength(aBuff, ALen * 2);
    BinToHex(aData, 0, aBuff, 0, ALen);
    Result := StringOf(aBuff);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function ADHex2Bin(AStr: String): TADByteString;
{$IFDEF NEXTGEN}
var
  aText: TBytes;
{$ENDIF}
begin
  if AStr = '' then
    SetLength(Result, 0)
  else begin
    SetLength(Result, Length(AStr) div 2);
{$IFNDEF NEXTGEN}
    HexToBin(PChar(AStr), PADByteString(Result), Length(Result));
{$ELSE}
    SetLength(aText, Length(AStr));
    Move(PChar(AStr)^, aText[0], Length(AStr));
    HexToBin(aText, 0, Result, 0, Length(Result));
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function ADAnsiStrLen(AStr: PADAnsiString): Integer;
var
  pStart: PADAnsiString;
begin
  if AStr = nil then
    Result := 0
  else begin
    pStart := AStr;
    while TADByte(AStr^) <> TADByte(#0) do
      Inc(AStr);
    Result := AStr - pStart;
  end;
end;

{-------------------------------------------------------------------------------}
function ADByteStrLength(const AStr: TADByteString): Integer;
begin
  Result := Length(AStr);
  if Result > 0 then
    Dec(Result);
end;

{-------------------------------------------------------------------------------}
function ADWideStrLen(AStr: PWideChar): Integer;
begin
  Result := 0;
  if AStr <> nil then
{$IFDEF AnyDAC_Unicode}
    Result := StrLen(AStr);
{$ELSE}
    while (PChar(AStr)^ <> #0) or ((PChar(AStr) + 1)^ <> #0) do begin
      Inc(Result);
      AStr := PWideChar(PChar(AStr) + 2);
    end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADStrLIComp(const AStr1, AStr2: PWideChar; AMaxLen: Cardinal): Integer;
{$IFNDEF AnyDAC_Unicode}
var
  P1, P2: PWideChar;
  I: Cardinal;
  C1, C2: WideChar;
{$ENDIF}
begin
{$IFDEF AnyDAC_Unicode}
  Result := StrLIComp(AStr1, AStr2, AMaxLen);
{$ELSE}
  P1 := AStr1;
  P2 := AStr2;
  I := 0;
  while I < AMaxLen do begin
    if (Word(P1^) >= Word('a')) and (Word(P1^) <= Word('z')) then
      C1 := WideChar(Word(P1^) xor $20)
    else
      C1 := P1^;

    if (Word(P2^) >= Word('a')) and (Word(P2^) <= Word('z')) then
      C2 := WideChar(Word(P2^) xor $20)
    else
      C2 := P2^;

    if (C1 <> C2) or (C1 = #0) then begin
      Result := Ord(C1) - Ord(C2);
      Exit;
    end;

    Inc(P1);
    Inc(P2);
    Inc(I);
  end;
  Result := 0;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{$WARNINGS OFF}
function ADInSet(AChar: Char; ASet: TADCharSet): Boolean;
begin
{$IFDEF AnyDAC_Unicode}
  if Ord(AChar) <= 255 then
    Result := AChar in ASet
  else
    Result := False;
{$ELSE}
  Result := AChar in ASet;
{$ENDIF}
end;
{$WARNINGS ON}

{-------------------------------------------------------------------------------}
function ADValToStr(const AValue: Variant; AQuotes: Boolean): String;
begin
  case VarType(AValue) of
    varEmpty:    Result := '<unassigned>';
    varNull:     Result := '<null>';
    varByte:     Result := '$' + IntToHex(Cardinal(AValue), 2);
{$IFDEF AnyDAC_D6}
    varWord:     Result := '$' + IntToHex(AValue, 4);
    varLongWord: Result := '$' + IntToHex(AValue, 8);
{$ENDIF}
{$IFDEF AnyDAC_D12}
    varUString,
{$ENDIF}
    varOleStr,
    varString:
      if AQuotes then
        Result := '"' + AValue + '"'
      else
        Result := AValue;
    else
      try
{$IFDEF AnyDAC_FPC}
        // FPC fails to convert TBcd variant to String automatically
        if VarIsFmtBCD(AValue) then
          Result := BCDToStr(VarToBCD(AValue))
        else
{$ENDIF}
          Result := AValue;
      except
        Result := '<unknown>';
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADIdentToStr(const AValue: Variant; var AQuotes: Boolean): String;
begin
  AQuotes := True;
  case VarType(AValue) of
{$IFDEF AnyDAC_D12}
    varUString,
{$ENDIF}
    varString,
    varOleStr:
      begin
        Result := AValue;
        if Result[1] = '@' then begin
          AQuotes := False;
          Result := Copy(Result, 2, Length(Result));
        end;
      end
    else
      Result := ADValToStr(AValue, True);
  end;
end;

{-------------------------------------------------------------------------------}
function ADVarToBool(const AValue: Variant): Boolean;
begin
  if VarIsNull(AValue) or VarIsEmpty(AValue) then
    Result := False
  else
    Result := AValue;
end;

{-------------------------------------------------------------------------------}
function ADVar2Int(const AValue: Variant): Integer;
begin
{$IFDEF AnyDAC_FPC}
  // FPC does not support TBCD variant to Integer automatic conversion
  if VarIsFmtBCD(AValue) then
    Result := BCDToInteger(VarToBCD(AValue))
  else
{$ENDIF}
    Result := AValue;
end;

{-------------------------------------------------------------------------------}
function ADSameVariants(const A, B: Variant): Boolean;
var
  ia, ib: Integer;
begin
  ia := VarType(A);
  ib := VarType(B);
  if ia <> ib then
    Result := False
  else if ia = varEmpty then
    Result := ib = varEmpty
  else if ia = varNull then
    Result := ib = varNull
  else if ib in [varEmpty, varNull] then
    Result := False
  else
    try
      Result := A = B;
    except
      Result := False;
    end;
end;

{-------------------------------------------------------------------------------}
function ADFixCRLF(const AStr: String): String;
var
  i: Integer;
begin
  Result := AStr;
  i := 1;
  while i <= Length(Result) do
    if (Result[i] = #13) and ((i = Length(Result)) or (Result[i + 1] <> #10)) then begin
      Insert(#10, Result, i + 1);
      Inc(i, 2);
    end
    else if (Result[i] = #10) and ((i = 1) or (Result[i - 1] <> #13)) then begin
      Insert(#13, Result, i);
      Inc(i, 2);
    end
    else
      Inc(i);
end;

{-------------------------------------------------------------------------------}
function ADExtractFieldName(const AStr: String; var APos: Integer): String; overload;
begin
  Result := ADExtractFieldName(AStr, APos, GParseFmtSettings);
end;

{-------------------------------------------------------------------------------}
function ADExtractFieldName(const AStr: String; var APos: Integer; const AFmt: TADParseFmtSettings): String; overload;
var
  i, iInBrackets: Integer;
  lSqueeze, lInQuotes: Boolean;
  sQuotes: String;
begin
  i := APos;
  lSqueeze := False;
  lInQuotes := False;
  iInBrackets := 0;
  while i <= Length(AStr) do begin
    if (AStr[i] = AFmt.FQuote) and (iInBrackets = 0) then begin
      if (i < Length(AStr)) and (AStr[i + 1] = AFmt.FQuote) then begin
        lSqueeze := True;
        Inc(i);
      end
      else
        lInQuotes := not lInQuotes;
    end
    else if (AStr[i] = AFmt.FQuote1) and not lInQuotes then
      Inc(iInBrackets)
    else if (AStr[i] = AFmt.FQuote2) and not lInQuotes then
      Dec(iInBrackets)
    else if (AStr[i] = AFmt.FDelimiter) and not lInQuotes and (iInBrackets = 0) then
      Break;
    Inc(i);
  end;
  Result := Trim(Copy(AStr, APos, i - APos));
  if (i <= Length(AStr)) and (AStr[i] = AFmt.FDelimiter) then
    Inc(i);
  APos := i;
  if lSqueeze then begin
    sQuotes := AFmt.FQuote + AFmt.FQuote;
    i := 0;
    while True do begin
      i := ADPosEx(sQuotes, Result, i + 1);
      if i = 0 then
        Break;
      Delete(Result, i, 1);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADMergeFieldNames(const AFieldNames1, AFieldNames2: String): String;
var
  i: Integer;
  sField: String;
  sUCResult: String;
begin
  Result := AFieldNames1;
  sUCResult := ';' + UpperCase(Result) + ';';
  i := 1;
  while i <= Length(AFieldNames2) do begin
    sField := ADExtractFieldName(AFieldNames2, i);
    if sField <> '' then
      if Pos(';' + UpperCase(sField) + ';', sUCResult) = 0 then begin
        if (Length(Result) > 0) and (Result[Length(Result)] <> ';') then
          Result := Result + ';';
        Result := Result + sField;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADCountFieldNames(const AStr: String): Integer;
var
  pCh: PChar;
begin
  if Length(AStr) = 0 then
    Result := 0
  else begin
    Result := 1;
    pCh := PChar(AStr);
    while pCh^ <> #0 do begin
      if pCh^ = ';' then
        Inc(Result);
      Inc(pCh);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADFieldInFieldNames(const AStr, AName: String) : Boolean;
var
  i, iNameLen, iLen: Integer;
  sUCName, sUCStr: String;
begin
  sUCName := UpperCase(AName);
  iNameLen := Length(sUCName);
  sUCStr := UpperCase(AStr);
  iLen := Length(sUCStr);
  i := 0;
  repeat
    i := ADPosEx(sUCName, sUCStr, i + 1);
    Result := (i <> 0) and
      ((i = 1) or (sUCStr[i - 1] = ';')) and
      ((i + iNameLen > iLen) or (sUCStr[i + iNameLen] = ';'));
  until Result or (i = 0);
end;

{-------------------------------------------------------------------------------}
procedure ADFieldNamesToArray(const AFieldNames: String;
  var AFieldNamesArray: TADStringArray);
var
  sField: String;
  i: Integer;
  iLen: Integer;
begin
  SetLength(AFieldNamesArray, 0);
  i := 1;
  while i <= Length(AFieldNames) do begin
    sField := ADExtractFieldName(AFieldNames, i);
    if sField <> '' then begin
      // collect key fields
      iLen := Length(AFieldNamesArray);
      SetLength(AFieldNamesArray, iLen + 1);
      AFieldNamesArray[iLen] := sField;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADNameFromIndex(AStrs: TStrings; AIndex: Integer): String;
var
  s: String;
  i: Integer;
begin
  Result := '';
  if AIndex >= 0 then begin
    s := AStrs[AIndex];
    i := Pos('=', s);
    if i > 0 then
      Result := Copy(s, 1, i - 1)
    else
      Result := s;
  end;
end;

{-------------------------------------------------------------------------------}
function ADValueFromIndex(AStrs: TStrings; AIndex: Integer): String;
var
  s: String;
  i: Integer;
begin
  Result := '';
  if AIndex >= 0 then begin
    s := AStrs[AIndex];
    i := Pos('=', s);
    if i > 0 then
      Result := Copy(s, i + 1, MAXINT div 2);
  end;
end;

{-------------------------------------------------------------------------------}
function ADStrToken(const AString: String; AChars: String; var AFrom: Integer;
  ASqueeze: Boolean = False): String;
var
  pS, pFrom: PChar;
begin
  if AFrom <= Length(AString) then begin
    pS := PChar(AString) + AFrom - 1;
    pFrom := pS;
    while (pS^ <> #0) and (StrScan(PChar(AChars), pS^) = nil) do
      Inc(pS);
    Inc(AFrom, pS - pFrom + 1);
    SetString(Result, pFrom, pS - pFrom);
    if ASqueeze then
      while (AFrom <= Length(AString)) and (StrScan(PChar(AChars), AString[AFrom]) <> nil) do
        Inc(AFrom);
  end
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
function ADUnquote(const AString: String; AQuoteChar: Char = '"'): String;
begin
  Result := AString;
  if (Result <> '') and (Result[1] = AQuoteChar) and (Result[Length(Result)] = AQuoteChar) then
    Result := Copy(Result, 2, Length(Result) - 2);
end;

{-------------------------------------------------------------------------------}
function ADCompareAnsiStr(const AStr1, AStr2: PADAnsiString; ALen1, ALen2: Integer;
  ALocale: TADLocalID; ANoCase, APartial, ANoSymbols: Boolean): Integer;
type
  TBuff = array [0 .. 4096] of TADAnsiChar;
var
  iLen: Integer;
{$IFDEF MSWINDOWS}
  iFlag: Integer;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  aBuff1, aBuff2: TBuff;
  pBuff1, pBuff2: PADAnsiString;

  function DupStr(const AStr: PADAnsiString; var ABuff: TBuff; ALen: Integer): PADAnsiString;
  begin
    if ALen < SizeOf(ABuff) then
      Result := @ABuff[0]
    else
      GetMem(Result, ALen + 1);
    Move(AStr^, Result^, ALen);
    if (Result + ALen)^ <> TADAnsiChar(#0) then
      (Result + ALen)^ := TADAnsiChar(#0);
  end;
{$ENDIF}
begin
  iLen := ALen1;
  if iLen > ALen2 then
    iLen := ALen2;
{$IFDEF AnyDAC_NOLOCALE_DATA}
  ALocale := 0;
{$ENDIF}
{$IFDEF MSWINDOWS}
  if ALocale = 0 then
    if ANoCase then
      Result := {$IFDEF AnyDAC_D18} {$IFNDEF NEXTGEN} System.AnsiStrings. {$ENDIF} {$ENDIF}
        StrLIComp(PADAnsiString(AStr1), PADAnsiString(AStr2), iLen)
    else
      Result := {$IFDEF AnyDAC_D18} {$IFNDEF NEXTGEN} System.AnsiStrings. {$ENDIF} {$ENDIF}
        StrLComp(PADAnsiString(AStr1), PADAnsiString(AStr2), iLen)
  else begin
    if ANoCase then
      iFlag := NORM_IGNORECASE or SORT_STRINGSORT
    else
      iFlag := SORT_STRINGSORT;
    if ANoSymbols then
      iFlag := iFlag or NORM_IGNORESYMBOLS or NORM_IGNORENONSPACE;
    SetLastError(0);
    if APartial then
      Result := CompareStringA(ALocale, iFlag, PADAnsiString(AStr1), iLen,
        PADAnsiString(AStr2), ALen2) - CSTR_EQUAL
    else
      Result := CompareStringA(ALocale, iFlag, PADAnsiString(AStr1), ALen1,
        PADAnsiString(AStr2), ALen2) - CSTR_EQUAL;
    if GetLastError <> 0 then
  {$IFDEF AnyDAC_D6Base}
      RaiseLastOSError;
  {$ELSE}
      RaiseLastWin32Error;
  {$ENDIF}
  end;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  if ANoCase then begin
    pBuff1 := DupStr(AStr1, aBuff1, iLen);
    pBuff2 := DupStr(AStr2, aBuff2, iLen);
    try
      Result := strcasecmp(MarshaledAString(pBuff1), MarshaledAString(pBuff2));
    finally
      if pBuff1 <> @aBuff1[0] then
        FreeMem(pBuff1);
      if pBuff2 <> @aBuff2[0] then
        FreeMem(pBuff2);
    end;
  end
  else
    Result := strncmp(MarshaledAString(AStr1), MarshaledAString(AStr2), iLen);
{$ENDIF}
  if Result > 0 then
    Result := 1
  else if Result < 0 then
    Result := -1
  else
    if ALen1 < ALen2 then
      Result := -1
    else if (ALen1 > ALen2) and not APartial then
      Result := 1;
end;

{-------------------------------------------------------------------------------}
function ADCompareWideStr(const AStr1, AStr2: PWideChar; ALen1, ALen2: Integer;
  ALocale: TADLocalID; ANoCase, APartial, ANoSymbols: Boolean): Integer;
var
  iLen: Integer;
{$IFDEF MSWINDOWS}
  iFlag: Integer;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  ws1, ws2: TADWideString;
{$ENDIF}
begin
  iLen := ALen1;
  if iLen > ALen2 then
    iLen := ALen2;
{$IFDEF AnyDAC_NOLOCALE_DATA}
  ALocale := 0;
{$ENDIF}
{$IFDEF MSWINDOWS}
  {$IFDEF AnyDAC_D14}
  if ALocale = 0 then
    if ANoCase then
      Result := StrLIComp(AStr1, AStr2, iLen)
    else
      Result := StrLComp(AStr1, AStr2, iLen)
  else
  {$ENDIF}
  begin
    if ANoCase then
      iFlag := NORM_IGNORECASE or SORT_STRINGSORT
    else
      iFlag := SORT_STRINGSORT;
    if ANoSymbols then
      iFlag := iFlag or NORM_IGNORESYMBOLS or NORM_IGNORENONSPACE;
    SetLastError(0);
    if APartial then
      Result := CompareStringW(ALocale, iFlag, AStr1, iLen, AStr2, ALen2) - CSTR_EQUAL
    else
      Result := CompareStringW(ALocale, iFlag, AStr1, ALen1, AStr2, ALen2) - CSTR_EQUAL;
    if GetLastError <> 0 then
  {$IFDEF AnyDAC_D6Base}
      RaiseLastOSError;
  {$ELSE}
      RaiseLastWin32Error;
  {$ENDIF}
  end;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  // This is not optimal, but platform neutral.
  // Optimal will be to use wcsncoll and wcsnicoll.
  // See SVN # 874
  if APartial then begin
    SetString(ws1, AStr1, iLen);
    SetString(ws2, AStr2, iLen);
  end
  else begin
    SetString(ws1, AStr1, ALen1);
    SetString(ws2, AStr2, ALen2);
  end;
  {$IFDEF NEXTGEN}
  if ANoCase then
    Result := AnsiCompareText(ws1, ws2)
  else
    Result := AnsiCompareStr(ws1, ws2);
  {$ELSE}
  if ANoCase then
    Result := WideCompareText(ws1, ws2)
  else
    Result := WideCompareStr(ws1, ws2);
  {$ENDIF}
{$ENDIF}
  if Result > 0 then
    Result := 1
  else if Result < 0 then
    Result := -1
  else
    if ALen1 < ALen2 then
      Result := -1
    else if (ALen1 > ALen2) and not APartial then
      Result := 1;
end;

{-------------------------------------------------------------------------------}
function ADCompareByteStr(const AStr1, AStr2: PADByteString; ALen1, ALen2: Integer): Integer;
var
  iLen, i: Integer;
begin
  iLen := ALen1;
  if iLen > ALen2 then
    iLen := ALen2;
  Result := 0;
  for i := 0 to iLen - 1 do begin
    if PByte(PADByteString(AStr1) + i)^ > PByte(PADByteString(AStr2) + i)^ then begin
      Result := 1;
      Break;
    end
    else if PByte(PADByteString(AStr1) + i)^ < PByte(PADByteString(AStr2) + i)^ then begin
      Result := -1;
      Break;
    end
    else
      Result := 0;
  end;
  if Result = 0 then
    if ALen1 > ALen2 then
      Result := 1
    else if ALen1 < ALen2 then
      Result := -1;
end;

{-------------------------------------------------------------------------------}
function ADStrReplace(const AStr: String; ASrch, ARepl: Char): String;
var
  i: Integer;
begin
  Result := AStr;
  for i := 1 to Length(Result) do
    if Result[i] = ASrch then
      Result[i] := ARepl;
end;

{-------------------------------------------------------------------------------}
function ADLastSystemErrorMsg: String;
{$IFDEF MSWINDOWS}
var
  buf: PChar;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
    nil, GetLastError(), (SUBLANG_DEFAULT shl 10) or LANG_NEUTRAL,
    PChar(@buf), 0, nil);
  Result := buf;
  LocalFree(HLOCAL(buf));
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  Result := TADEncoder.Deco(dlerror, -1, ecUTF8);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADIsSQLTimeStampBlank(const ATimeStamp: TADSQLTimeStamp): Boolean;
begin
  Result := (ATimeStamp.Year = 0) and
            (ATimeStamp.Month = 0) and
            (ATimeStamp.Day = 0) and
            (ATimeStamp.Hour = 0) and
            (ATimeStamp.Minute = 0) and
            (ATimeStamp.Second = 0) and
            (ATimeStamp.Fractions = 0);
end;

{-------------------------------------------------------------------------------}
function ADDateTime2SQLTimeStamp(const ADateTime: TDateTime): TADSQLTimeStamp;
{$IFDEF AnyDAC_D6}
begin
  Result := DateTimeToSQLTimeStamp(ADateTime);
end;
{$ELSE}
var
  FFractions, FYear: Word;
begin
  with Result do begin
    FYear := 0;
    DecodeDate(ADateTime, FYear, Month, Day);
    Year := FYear;
    FFractions := 0;
    DecodeTime(ADateTime, Hour, Minute, Second, FFractions);
    Fractions := FFractions;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADSQLTimeStamp2DateTime(const ADateTime: TADSQLTimeStamp): TDateTime;
begin
{$IFDEF AnyDAC_D6}
  Result := SQLTimeStampToDateTime(ADateTime);
{$ELSE}
  if ADIsSQLTimeStampBlank(ADateTime) then
    Result := 0
  else
    with ADateTime do
      Result := ADEncodeDateTime(Year, Month, Day, Hour, Minute, Second, Word(Fractions))
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADSQLTimeStamp2Time(const AValue: TADSQLTimeStamp): Longint;
begin
  Result := LongInt(LongWord(((AValue.Hour * 60 + AValue.Minute) * 60 +
    AValue.Second) * 1000) + AValue.Fractions);
end;

{-------------------------------------------------------------------------------}
function ADTime2SQLTimeStamp(const AValue: Longint): TADSQLTimeStamp;
begin
  Result := ADDateTime2SQLTimeStamp(ADTime2DateTime(AValue));
end;

{-------------------------------------------------------------------------------}
function ADSQLTimeStamp2Date(const AValue: TADSQLTimeStamp): Longint;
begin
  Result := Longint(Trunc(ADSQLTimeStamp2DateTime(AValue) - C_Date_1_1_1 + 1.0));
end;

{-------------------------------------------------------------------------------}
function ADDate2SQLTimeStamp(const AValue: Longint): TADSQLTimeStamp;
begin
  Result := ADDateTime2SQLTimeStamp(ADDate2DateTime(AValue));
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
function ADVar2SQLTimeStamp(const AValue: Variant): TADSQLTimeStamp;
begin
  {$IFDEF AnyDAC_D12}
    {$IFNDEF NEXTGEN}
  // workaround for QC 72462
  if VarType(AValue) = varUString then
    Result := VarToSQLTimeStamp(VarAsType(AValue, varString))
  else
    {$ENDIF}
  {$ENDIF}
    Result := VarToSQLTimeStamp(AValue);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADTime2DateTime(const AValue: Longint): TDateTime;
begin
  Result := AValue / (24.0 * 60.0 * 60.0 * 1000.0);
end;

{-------------------------------------------------------------------------------}
function ADDateTime2Time(const AValue: TDateTime): Longint;
var
  d: Double;
begin
  d := AValue * (24.0 * 60.0 * 60.0 * 1000.0) + 0.1;
  Result := LongInt(Trunc(d));
end;

{-------------------------------------------------------------------------------}
function ADDate2DateTime(const AValue: Longint): TDateTime;
begin
  Result := AValue - 1 + C_Date_1_1_1;
end;

{-------------------------------------------------------------------------------}
function ADDateTime2Date(const AValue: TDateTime): Longint;
begin
  Result := LongInt(Trunc(AValue - C_Date_1_1_1 + 1));
end;

{-------------------------------------------------------------------------------}
function ADGetTickCount: LongWord;
begin
{$IFDEF MSWINDOWS}
  Result := GetTickCount();
{$ENDIF}
{$IFDEF UNIX}
  Result := LongWord(Trunc(Now() * 24 * 60 * 60 * 1000));
{$ELSE}
  {$IFDEF MACOS}
    {$IFDEF AnyDAC_D18}
  Result := AbsoluteToNanoseconds(mach_absolute_time) div 1000000;
    {$ELSE}
  Result := AbsoluteToNanoseconds(UpTime) div 1000000;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADGetPerformanceCounter: Int64;
{$IFDEF UNIX}
var
  rTimeval: TTimeval;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  QueryPerformanceCounter(Result);
{$ENDIF}
{$IFDEF UNIX}
  GetTimeOfDay(@rTimeval, nil);
  Result := Int64(rTimeval.tv_sec) * 100000 + Int64(rTimeval.tv_usec);
{$ELSE}
  {$IFDEF MACOS}
    {$IFDEF AnyDAC_D18}
  Result := Int64(AbsoluteToNanoseconds(mach_absolute_time) div 100);
    {$ELSE}
  Result := Int64(AbsoluteToNanoseconds(UpTime) div 100);
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADEncodeDateTime(const AYear, AMonth, ADay, AHour, AMin, ASec, AMSec: Word): TDateTime;
var
  tm: TDateTime;
begin
  Result := EncodeDate(AYear, AMonth, ADay);
  tm := EncodeTime(AHour, AMin, ASec, AMSec);
  if Result >= 0 then
    Result := Result + tm
  else
    Result := Result - tm;
end;

{-------------------------------------------------------------------------------}
function ADMSecs2DateTime(const AValue: Double): TDateTime;
begin
{$IFDEF AnyDAC_FPC}
  Result := TimeStampToDateTime(MSecsToTimeStamp(Trunc(AValue)));
{$ELSE}
  Result := TimeStampToDateTime(MSecsToTimeStamp(AValue));
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADDateTime2MSecs(const AValue: TDateTime): Comp;
begin
  Result := TimeStampToMSecs(DateTimeToTimeStamp(AValue));
end;

{-------------------------------------------------------------------------------}
function ADFixFMTBcdAdd(const V1, V2: Variant): Variant;
{$IFDEF AnyDAC_FPC}
var
  D1, D2: Double;
{$ENDIF}
{$IFDEF VER140}
var
  C1, C2: Currency;
  B: TBcd;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  {$IFDEF VER140}
  if ((VarType(V1) = VarFMTBcd) or (VarType(V2) = VarFMTBcd)) and
     BCDToCurr(VarToBcd(V1), C1) and BCDToCurr(VarToBcd(V2), C2) and CurrToBCD(C1 + C2, B) then
    Result := VarFMTBcdCreate(B)
  else
  {$ENDIF}
  {$IFNDEF AnyDAC_D6}
  if (VarType(V1) = varInt64) and (VarType(V2) = varInt64) then begin
    TVarData(Result).VType := varInt64;
    Decimal(Result).Lo64 := Decimal(V1).Lo64 + Decimal(V2).Lo64;
  end
  else
  {$ENDIF}
{$ELSE}
  if (VarType(V1) = VarFMTBcd) or (VarType(V2) = VarFMTBcd) then begin
    if VarType(V1) = VarFMTBcd then
      D1 := BCDToDouble(VarToBCD(V1))
    else
      D1 := V1;
    if VarType(V2) = VarFMTBcd then
      D2 := BCDToDouble(VarToBCD(V2))
    else
      D2 := V2;
    Result := D1 + D2;
  end
  else
{$ENDIF}
    Result := V1 + V2;
end;

{-------------------------------------------------------------------------------}
function ADFixFMTBcdSub(const V1, V2: Variant): Variant;
{$IFDEF AnyDAC_FPC}
var
  D1, D2: Double;
{$ENDIF}
{$IFDEF VER140}
var
  C1, C2: Currency;
  B: TBcd;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  {$IFDEF VER140}
  if ((VarType(V1) = VarFMTBcd) or (VarType(V2) = VarFMTBcd)) and
     BCDToCurr(VarToBcd(V1), C1) and BCDToCurr(VarToBcd(V2), C2) and CurrToBCD(C1 - C2, B) then
    Result := VarFMTBcdCreate(B)
  else
  {$ENDIF}
  {$IFNDEF AnyDAC_D6}
  if (VarType(V1) = varInt64) and (VarType(V2) = varInt64) then begin
    TVarData(Result).VType := varInt64;
    Decimal(Result).Lo64 := Decimal(V1).Lo64 - Decimal(V2).Lo64;
  end
  else
  {$ENDIF}
{$ELSE}
  if (VarType(V1) = VarFMTBcd) or (VarType(V2) = VarFMTBcd) then begin
    if VarType(V1) = VarFMTBcd then
      D1 := BCDToDouble(VarToBCD(V1))
    else
      D1 := V1;
    if VarType(V2) = VarFMTBcd then
      D2 := BCDToDouble(VarToBCD(V2))
    else
      D2 := V2;
    Result := D1 - D2;
  end
  else
{$ENDIF}
    Result := V1 - V2;
end;

{-------------------------------------------------------------------------------}
function ADFixFMTBcdDiv(const V1, V2: Variant): Variant;
var
  cPrevDecimalSeparator: Char;
{$IFNDEF AnyDAC_D6Base}
  dVal: Extended;
{$ENDIF}
begin
{$IFNDEF AnyDAC_D6Base}
  if VarType(V1) = varInt64 then begin
    dVal := V2;
    Result := Decimal(V1).Lo64 / dVal;
  end
  else
{$ENDIF}
  begin
    cPrevDecimalSeparator := {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator;
    {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator := '.';
    try
      Result := V1 / V2;
    finally
      {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator := cPrevDecimalSeparator;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADCompareUInt64(const Value1, Value2: Int64): Integer;
begin
  if Value1 = Value2 then
    Result := 0
  else if (Value1 >= 0) and (Value2 >= 0) then
    if Value1 > Value2 then
      Result := 1
    else
      Result := -1
  else if (Value1 < 0) and (Value2 >= 0) then
    Result := 1
  else if (Value1 >= 0) and (Value2 < 0) then
    Result := -1
  else
    if Value2 > Value1 then
      Result := 1
    else
      Result := -1
end;

{-------------------------------------------------------------------------------}
function ADGetSystemCfgPath: String;
begin
{$IFDEF MSWINDOWS}
  SetLength(Result, MAX_PATH);
  SetLength(Result, GetWindowsDirectory(PChar(Result), MAX_PATH));
  Result := ADNormPath(Result);
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  {$IFDEF IOS}
  Result := ADGetAppCfgPath;
  {$ELSE}
  Result := '/etc/';
  {$ENDIF}
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ TODO -cIOS : Should be replaced with NSHomeDirectory,
  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, ...), etc }
function ADGetAppPath: String;
begin
{$IFDEF IOS}
  Result := ADReadEnvValue('HOME');
{$ELSE}
  Result := ExtractFileDir(ParamStr(0));
{$ENDIF}
  Result := ADNormPath(Result);
end;

{-------------------------------------------------------------------------------}
function ADGetAppCfgPath: String;
begin
{$IFDEF IOS}
  Result := ADGetAppDocPath;
{$ELSE}
  Result := ADGetAppPath;
{$ENDIF}
end;

{ --------------------------------------------------------------------------- }
function ADGetAppDocPath: String;
{$IFDEF MSWINDOWS}
  {$IFDEF AnyDAC_FPC}
const
  CSIDL_PERSONAL = $0005;
  {$ENDIF}
var
  pidlDoc: PItemIDList;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  pidlDoc := nil;
  if not Succeeded(SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, pidlDoc)) then begin
    Result := '';
    Exit;
  end;
  SetLength(Result, MAX_PATH);
  if not SHGetPathFromIDList(pidlDoc, PChar(Result)) then
    Result := ''
  else
    SetLength(Result, StrLen(PChar(Result)));
  CoTaskMemFree(pidlDoc);
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  {$IFDEF IOS}
  Result := ADGetAppPath + 'Documents';
  {$ELSE}
  Result := ADReadEnvValue('HOME');
  {$ENDIF}
{$ENDIF}
  Result := ADNormPath(Result);
end;

{-------------------------------------------------------------------------------}
function ADGetTempPath: String;
begin
{$IFDEF IOS}
  Result := ADGetAppPath + 'tmp';
{$ELSE}
  {$IFDEF AnyDAC_POSIX}
  Result := ADReadEnvValue('TMPDIR');
  if Result = '' then
  {$ENDIF}
    Result := ADReadEnvValue('TEMP');
  if Result = '' then
    Result := ADReadEnvValue('TMP');
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADGetBestPath(const ASpecifiedFileName, AGlobalFileName, ADefFileName: String): String;
var
  sSpec, sGlob, sDef: String;
begin
  sSpec := ADExpandStr(ASpecifiedFileName);
  sGlob := ADExpandStr(AGlobalFileName);
  sDef := ADExpandStr(ADefFileName);
  if sSpec = '' then begin
    Result := ADGetAppCfgPath + sDef;
    if not FileExists(Result) then
      Result := sGlob;
  end
  else begin
    if ExtractFilePath(sSpec) = '' then
      Result := ADGetAppCfgPath + sSpec
    else
      Result := sSpec;
  end;
end;

{-------------------------------------------------------------------------------}
function ADNormPath(const APath: String): String;
begin
  Result := APath;
  if (Result <> '') and (Result[Length(Result)] <> C_AD_PathDelim) then
    Result := Result + C_AD_PathDelim;
end;

{ --------------------------------------------------------------------------- }
function ADExtractFileNameNoPath(const AFileName: String): String;
begin
  Result := ChangeFileExt(ExtractFileName(AFileName), '');
end;

{ --------------------------------------------------------------------------- }
function ADBrowseForFolder(AHandle: THandle; ATitle: string): string;
{$IFDEF MSWINDOWS}
var
  browseinfo: TBrowseInfo;
  itemidlist: PItemIDList;
  image: Integer;
  displayname: PChar;
  itaskalloc: IMalloc;
  s: PChar;
{$ELSE}
  {$IFDEF LCL}
var
  oDlg: TSelectDirectoryDialog;
  {$ENDIF}
{$ENDIF}
begin
  Result := '';
{$IFDEF MSWINDOWS}
  image := 0;
  displayname := StrAlloc(MAX_PATH);
  try
    browseinfo.hwndOwner := AHandle;
    browseinfo.pidlRoot := nil;
    browseinfo.pszDisplayName := displayname;
    browseinfo.lpszTitle := PChar(ATitle);
    browseinfo.ulFlags := BIF_RETURNONLYFSDIRS;
    browseinfo.lpfn := nil;
    browseinfo.lParam := 0;
    browseinfo.iImage := image;
    itemidList := SHBrowseForFolder({$IFDEF AnyDAC_FPC} @ {$ENDIF} browseinfo);
    if Assigned(itemidlist) then
    try
      s := StrAlloc(MAX_PATH);
      try
        if SHGetPathFromIDList(itemidlist, s) then
          Result := s;
      finally
        StrDispose(s);
      end;
    finally
      OleCheck(SHGetMalloc(itaskalloc));
      try
        assert(itaskalloc.DidAlloc(itemidlist) = 1, 'wrong allocator');
        itaskalloc.Free(itemidlist);
      finally
        itaskalloc := nil;
      end;
    end;
  finally
    StrDispose(displayname);
  end;
{$ELSE}
  {$IFDEF LCL}
  oDlg := TSelectDirectoryDialog.Create(nil);
  try
    oDlg.Title := ATitle;
    if oDlg.Execute then
      Result := oDlg.FileName;
  finally
    ADFree(oDlg);
  end;
  {$ENDIF}
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADVerStr2Int(const AVersion: String): TADVersion;
var
  i, iItemNo, iDot, iFirstNonDig, iVal: Integer;
  s, sItem: String;
begin
  i := 1;
  while i <= Length(AVersion) do
    if (AVersion[i] >= '0') and (AVersion[i] <= '9') then
      Break
    else
      Inc(i);
  s := Copy(AVersion, i, Length(AVersion));
  Result := 0;
  for iItemNo := 1 to 5 do begin
    if s = '' then
      Result := Result * 100
    else begin
      iDot := Pos('.', s);
      if iDot = 0 then
        iDot := Length(s) + 1;
      sItem := Trim(Copy(s, 1, iDot - 1));
      iFirstNonDig := 1;
      while (iFirstNonDig <= Length(sItem)) and
            (sItem[iFirstNonDig] >= '0') and (sItem[iFirstNonDig] <= '9') do
        Inc(iFirstNonDig);
      iVal := StrToIntDef(Copy(sItem, 1, iFirstNonDig - 1), 0);
      if (iVal > 99) and (iItemNo > 1) then
        iVal := 99;
      Result := Result * 100 + iVal;
      s := Copy(s, iDot + 1, Length(s));
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADVerInt2Str(AVersion: TADVersion): String;
var
  iVal: Integer;
begin
  Result := '';
  while AVersion > 0 do begin
    if Result <> '' then
      Result := '.' + Result;
    iVal := AVersion mod 100;
    AVersion := AVersion div 100;
    if iVal = 99 then
      iVal := 0;
    Result := IntToStr(iVal) + Result;
  end;
end;

{-------------------------------------------------------------------------------}
function ADReadRegValue(const AName: String): String;
var
  oCfg: TADConfigFile;
begin
  oCfg := TADConfigFile.Create(True);
  try
    Result := oCfg.ReadString(S_AD_Main, AName, '');
  finally
    ADFree(oCfg);
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADWriteRegValue(const AName, AValue: String);
var
  oCfg: TADConfigFile;
begin
  oCfg := TADConfigFile.Create(False);
  try
    oCfg.WriteString(S_AD_Main, AName, AValue);
  finally
    ADFree(oCfg);
  end;
end;

{-------------------------------------------------------------------------------}
function ADReadEnvValue(const AName: String): String;
{$IFNDEF AnyDAC_D6Base}
var
  iSz: Integer;
{$ENDIF}
begin
{$IFDEF AnyDAC_D6Base}
  Result := GetEnvironmentVariable(AName);
{$ELSE}
  iSz := GetEnvironmentVariable(PChar(AName), nil, 0);
  if iSz = 0 then
    Result := ''
  else begin
    SetLength(Result, iSz - 1);
    GetEnvironmentVariable(PChar(AName), PChar(Result), iSz);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
var
  FExpandStrCache: TADStringList = nil;

function ADExpandStr(const AStr: String; AVars: TStrings = nil): String;

  function TrimSlash(const AStr: String): String;
  begin
    Result := AStr;
    if (Result <> '') and (Result[Length(Result)] = C_AD_PathDelim) then
      Result := Copy(Result, 1, Length(Result) - 1);
  end;

var
  i1, i2, iRes, iMax, iVal: Integer;
  sName, sVal: String;
  lNext: Boolean;
  rSR: TSearchRec;
{$IFDEF AnyDAC_POSIX}
  i: Integer;
{$ENDIF}
begin
  Result := AStr;
  i1 := 1;
  lNext := False;
  while True do begin
    i1 := ADPosEx('$(', Result, i1);
    if i1 = 0 then
      Break;
    i2 := ADPosEx(')', Result, i1 + 2);
    if i2 = 0 then
      Break;
    sName := UpperCase(Copy(Result, i1 + 2, i2 - i1 - 2));
    FLock.Enter;
    if (AVars <> nil) and (AVars.IndexOfName(sName) <> -1) then
      sVal := AVars.Values[sName]
    else if FExpandStrCache.IndexOfName(sName) <> -1 then
      sVal := FExpandStrCache.Values[sName]
    else if sName = 'RAND' then
      sVal := IntToStr(Random($7FFFFFFF))
    else if sName = 'NEXT' then begin
      sVal := '*';
      lNext := True;
    end
    else if sName = 'RUN' then
      sVal := TrimSlash(ExtractFilePath(ParamStr(0)))
    else if sName = 'APP' then
      sVal := TrimSlash(ADGetAppPath)
    else if sName = 'CFG' then
      sVal := TrimSlash(ADGetAppCfgPath)
    else if sName = 'SYSCFG' then
      sVal := TrimSlash(ADGetSystemCfgPath)
    else if sName = 'DOC' then
      sVal := TrimSlash(ADGetAppDocPath)
    else if sName = 'TEMP' then
      sVal := TrimSlash(ADGetTempPath)
    else begin
      sVal := ADReadEnvValue(sName);
      if sVal = '' then
        sVal := ADReadRegValue(sName);
      FExpandStrCache.Add(sName + '=' + sVal);
    end;
    FLock.Leave;
    Result := Copy(Result, 1, i1 - 1) + sVal + Copy(Result, i2 + 1, Length(Result));
  end;
  if lNext then begin
    sName := ExtractFileName(Result);
    i1 := Pos('*', sName);
    iMax := 0;
    iRes := FindFirst(Result, faAnyFile, rSR);
    while iRes = 0 do begin
      iVal := StrToIntDef(Copy(rSR.Name, i1, Length(rSR.Name) - Length(sName) + 1), 0);
      if iVal > iMax then
        iMax := iVal;
      iRes := FindNext(rSR);
    end;
    FindClose(rSR);
    i1 := Pos('*', Result);
    Result := Copy(Result, 1, i1 - 1) + IntToStr(iMax + 1) + Copy(Result, i1 + 1, Length(Result));
  end;
{$IFDEF AnyDAC_POSIX}
  for i := 1 to Length(Result) do
    if Result[i] = '\' then
      Result[i] := '/';
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function ADIsDesignTime: Boolean;
const
  SIDEFileName: String =
{$IFDEF AnyDAC_FPC}
  {$IFDEF MSWINDOWS}
  'lazarus.exe'
  {$ENDIF}
  {$IFDEF AnyDAC_POSIX}
  'lazarus'
  {$ENDIF}
{$ELSE}
  {$IFDEF AnyDAC_BCB}
    'bcb.exe'
  {$ELSE}
    {$IFDEF AnyDAC_DELPHI}
      {$IFDEF AnyDAC_D8}
        'bds.exe'
      {$ELSE}
        'delphi32.exe'
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  ;
begin
  Result := (CompareText(ExtractFileName(ParamStr(0)), SIDEFileName) = 0);
end;

{-------------------------------------------------------------------------------}
function ADToolName: String;
begin
  Result :=
{$IFDEF AnyDAC_FPC}
          'FPC'
{$ELSE}
  {$IFDEF AnyDAC_Delphi}
    {$IFDEF AnyDAC_D18}
          'D18'
    {$ELSE}
      {$IFDEF AnyDAC_D17}
          'D17'
      {$ELSE}
        {$IFDEF AnyDAC_D16}
          'D16'
        {$ELSE}
          {$IFDEF AnyDAC_D15}
          'D15'
          {$ELSE}
            {$IFDEF AnyDAC_D14}
          'D14'
            {$ELSE}
              {$IFDEF AnyDAC_D12}
          'D12'
              {$ELSE}
                {$IFDEF AnyDAC_D11}
          'D11'
                {$ELSE}
                  {$IFDEF AnyDAC_D10}
          'D10'
                  {$ELSE}
                    {$IFDEF AnyDAC_D9}
          'D9'
                    {$ELSE}
                      {$IFDEF AnyDAC_D7}
          'D7'
                      {$ELSE}
                        {$IFDEF AnyDAC_D6}
          'D6'
                        {$ELSE}
                          {$IFDEF AnyDAC_D5}
          'D5'
                          {$ENDIF}
                        {$ENDIF}
                      {$ENDIF}
                    {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ELSE}
    {$IFDEF AnyDAC_D6}
          'Bcb5'
    {$ELSE}
      {$IFDEF AnyDAC_D5}
          'Bcb6'
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  ;
end;

{-------------------------------------------------------------------------------}
function ADIndexOf(AList: Pointer; ALen: Integer; AItem: Pointer): Integer;
type
  PPtr = ^Pointer;
  TPtrArray = array of Pointer;
var
  p, lastP: PPtr;
  prevLastP: Pointer;
  c: Integer;
begin
  if ALen = -1 then
    c := Length(TPtrArray(AList))
  else
    c := ALen;
  if c = 0 then
    Result := -1
  else begin
    p := PPtr(AList);
    if c > 1 then begin
      lastP := PPtr(PADByteString(p) + (c - 1) * SizeOf(Pointer));
      prevLastP := lastP^;
      lastP^ := AItem;
      while p^ <> AItem do
        Inc(p);
      lastP^ := prevLastP;
    end;
    if p^ = AItem then
      Result := (PADByteString(p) - PADByteString(AList)) div SizeOf(Pointer)
    else
      Result := -1;
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADFree(AObj: TObject);
begin
  if AObj <> nil then
{$IFDEF AUTOREFCOUNT}
    AObj.DisposeOf;
{$ELSE}
    AObj.Destroy;
 {$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure ADFreeAndNil(var AObj);
var
  o: TObject;
begin
  o := TObject(AObj);
  if o <> nil then begin
    Pointer(AObj) := nil;
{$IFDEF AUTOREFCOUNT}
    o.DisposeOf;
{$ELSE}
    o.Destroy;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function ADGetCmdParam(const AParName: String; const ADefValue: String): String;
begin
  Result := ADefValue;
  if ADGetCmdParam(AParName, ADefValue = '', Result) then
    if (ADefValue = '') and (Result = '') then
      Result := '1';
end;

{-------------------------------------------------------------------------------}
function ADGetCmdParam(const AParName: String; ATrigger: Boolean; var AValue: String): Boolean;
var
  i, j, l: Integer;
  s: String;
begin
  Result := False;
  i := 1;
  while i <= ParamCount do begin
    s := ParamStr(i);
    if AdInSet(s[1], ['-', '/']) then begin
      j := 2;
      while (j <= Length(s)) and not ADInSet(s[j], [':', '=', ' ']) do
        Inc(j);
      l := j - 2;
      if (l = Length(AParName)) and
         (AnsiStrLIComp(PChar(s) + 1, PChar(AParName), l) = 0) then begin
        Result := True;
        if not ATrigger then
          if j <= Length(s) then
            AValue := Copy(s, j + 1, Length(s))
          else if i < ParamCount then begin
            Inc(i);
            AValue := ParamStr(i);
          end;
        Exit;
      end;
    end;
    Inc(i);
  end;
end;

{-------------------------------------------------------------------------------}
function ADTimeout(AStartTicks, ATimeout: LongWord): Boolean;
var
  i: LongWord;
begin
  i := ADGetTickCount();
  if i < AStartTicks then
    Result := ($FFFFFFFF - AStartTicks + i) >= ATimeout
  else
    Result := (i - AStartTicks) >= ATimeout;
end;

{-------------------------------------------------------------------------------}
procedure ADStr2BCD(pIn: PChar; ASize: Integer; out ABcd: TADBcd; ADot: Char);
var
  lNeg, lDec: Boolean;
  iDecPos: Integer;
  pTmp: PChar;
  pFrac: PByte;
  lStore: Boolean;
  iSize: Integer;
  iCell: Byte;
  c: Char;
begin
  if ASize = -1 then
    ASize := StrLen(pIn);
  ADFillChar(ABcd, SizeOf(ABcd), 0);
  if (pIn^ = '0') and ((ASize = 1) or ((pIn + 1)^ = #0)) or
     (pIn^ = #0) then begin
    ABcd.Precision := 8;
    ABcd.SignSpecialPlaces := 2;
    Exit;
  end;

  iDecPos := 0;
  lDec := False;
  while iDecPos < ASize do begin
    if pIn[iDecPos] = ADot then begin
      lDec := True;
      Break;
    end;
    Inc(iDecPos);
  end;
  if iDecPos = ASize then
    iDecPos := 0;

  { Strip leading whitespace }
  while ((pIn^ = ' ') or (pIn^ = '0')) and (ASize > 0) do begin
    Inc(pIn);
    Dec(ASize);
    if iDecPos > 0 then
      Dec(iDecPos);
  end;
  if ASize = 0 then
    Exit;

  { Strip trailing whitespace }
  pTmp := pIn + ASize - 1;
  while pTmp^ = ' ' do begin
    pTmp^ := #0;
    Dec(pTmp);
  end;

  { Is the number negative? }
  if pIn^ = '-' then begin
    lNeg := True;
    Inc(pIn);
    Dec(ASize);
    if iDecPos > 0 then
      Dec(iDecPos);
  end
  else begin
    lNeg := False;
    if pIn^ = '+' then begin
      Inc(pIn);
      Dec(ASize);
      if iDecPos > 0 then
        Dec(iDecPos);
    end;
  end;

  { Clear structure }
  if pIn^ = '0' then begin
    Inc(pIn);  // '0.' scenario
    Dec(ASize);
    if iDecPos > 0 then
      Dec(iDecPos);
  end;

  if ASize <= 0 then
    Exit
  else if ASize > 66 then begin
    ABcd.Precision := 8;
    ABcd.SignSpecialPlaces := 2;
    Exit;
  end;

  pFrac := @ABcd.Fraction[0];
  lStore := False;
  iSize := ASize;
  iCell := 0;
  while iSize > 0 do begin
    Dec(iSize);
    c := pIn^;
    Inc(pIn);
    if c <> ADot then
      if lStore then begin
        pFrac^ := (iCell shl 4) or (Ord(c) - Ord('0'));
        Inc(pFrac);
        lStore := False;
      end
      else begin
        iCell := Ord(c) - Ord('0');
        lStore := True;
      end;
  end;
  if lStore then
    pFrac^ := iCell shl 4;

  if lDec then begin
    ABcd.Precision := Byte(ASize - 1);
    if lNeg then
      ABcd.SignSpecialPlaces := Byte((1 shl 7) + Byte(ASize - iDecPos - 1))
    else
      ABcd.SignSpecialPlaces := Byte((0 shl 7) + Byte(ASize - iDecPos - 1));
  end
  else begin
    ABcd.Precision := Byte(ASize);
    if lNeg then
      ABcd.SignSpecialPlaces := (1 shl 7)
    else
      ABcd.SignSpecialPlaces := (0 shl 7);
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADFloatRec2BCD(const ARec: TFloatRec; out ABcd: TADBcd);
var
  pIn: PADAnsiString;
  iSize, iPrecision, iExponent, iDecimal: Integer;
  pFrac: PByte;
  lStore: Boolean;
  iCell: Byte;
  c: Char;
  i: Integer;
begin
  pIn := PADAnsiString(@ARec.Digits[0]);
  iSize := ADAnsiStrLen(pIn);
  iExponent := ARec.Exponent;

  ADFillChar(ABcd.Fraction, SizeOf(ABcd.Fraction), 0);

 if iSize = 0 then begin
    ABcd.Precision := 8;
    ABcd.SignSpecialPlaces := 2;
    Exit;
  end;

  pFrac := @ABcd.Fraction[0];
  lStore := False;
  iCell := 0;

  // If Exponent is negative, then prepend value by zeros
  if iExponent < 0 then begin
    i := -iExponent;
    while i > 0 do begin
      Dec(i);
      if lStore then begin
        pFrac^ := 0;
        Inc(pFrac);
        lStore := False;
      end
      else
        lStore := True;
    end;
  end;

  // Put digits
  i := iSize;
  while i > 0 do begin
    Dec(i);
    c := Char(pIn^);
    Inc(pIn);
    if lStore then begin
      pFrac^ := (iCell shl 4) or (Ord(c) - Ord('0'));
      Inc(pFrac);
      lStore := False;
    end
    else begin
      iCell := Ord(c) - Ord('0');
      lStore := True;
    end;
  end;

  // If Exponent is positive and more than length, then append value by zeros
  if (iExponent > 0) and (iExponent > iSize) then begin
    i := iExponent - iSize;
    while i > 0 do begin
      Dec(i);
      if lStore then begin
        pFrac^ := iCell shl 4;
        Inc(pFrac);
        lStore := False;
      end
      else begin
        iCell := 0;
        lStore := True;
      end;
    end;
  end;

  if lStore then
    pFrac^ := iCell shl 4;

  if iExponent > iSize then
    iPrecision := iExponent
  else if iExponent < 0 then
    iPrecision := iSize + -iExponent
  else
    iPrecision := iSize;
  ABcd.Precision := Byte(iPrecision);

  if iExponent < iSize then
    iDecimal := iSize - iExponent
  else
    iDecimal := 0;
  if ARec.Negative then
    ABcd.SignSpecialPlaces := Byte((1 shl 7) + Byte(iDecimal))
  else
    ABcd.SignSpecialPlaces := Byte((0 shl 7) + Byte(iDecimal));
end;

{-------------------------------------------------------------------------------}
procedure ADBCD2Str(pOut: PChar; out ASize: Integer; const ABcd: TADBcd; ADot: Char);
var
  iLoop: Integer;
  iNumDigits: Integer;
  pStr: PChar;
  cVal: Byte;
  lWasDigit: WordBool;
begin
  pStr := pOut;

  // First, is the number negative?
  if (ABcd.SignSpecialPlaces and (1 shl 7)) <> 0 then begin
    pOut^ := '-';
    Inc(pOut);
  end;

  // Now, loop through the whole part of the bcd number
  // use lower 6 bits of iSignSpecialPlaces.
  iNumDigits := ABcd.Precision - (ABcd.SignSpecialPlaces and 63);
  if iNumDigits < 0 then
    iNumDigits := 0;
  lWasDigit := False;
  for iLoop := 0 to iNumDigits - 1 do begin
    if (iLoop mod 2) <> 0 then
      // lower 4 bits only
      cVal := Byte((ABcd.Fraction[(iLoop - 1 ) div 2] and 15) + Ord('0'))
    else
      // upper 4 bits only
      cVal := Byte((ABcd.Fraction[iLoop div 2] shr 4) + Ord('0'));

    // This little test is used to strip leading '0' chars.
    if (cVal <> Ord('0')) or lWasDigit then begin
      pOut^ := Char(cVal);
      Inc(pOut);
      lWasDigit := True;
    end;
  end;

  // If no data is stored yet, add a leading '0'.
  if not lWasDigit then begin
    pOut^ := '0';
    Inc(pOut);
  end;
  pOut^ := ADot;
  Inc(pOut);

  for iLoop := iNumDigits to ABcd.Precision - 1 do begin
    if iLoop mod 2 <> 0 then
      // lower 4 bits only
      pOut^ := Char((ABcd.Fraction[(iLoop - 1) div 2] and 15) + Ord('0'))
    else
      // upper 4 bits only
      pOut^ := Char((ABcd.Fraction[iLoop div 2] shr 4) + Ord('0'));
    Inc(pOut);
  end;

  // Right trim '0' chars
  ASize := pOut - pStr;
  while (ASize > 0) and ((pOut - 1)^ = '0') do begin
    Dec(pOut);
    Dec(ASize);
  end;
  if (ASize > 0) and ((pOut - 1)^ = ADot) then begin
    Dec(pOut);
    Dec(ASize);
  end;
  pOut^ := #0;
end;

{-------------------------------------------------------------------------------}
procedure ADBcdGetMetrics(const ABcd: TADBcd; out APrecision, AScale: Smallint);
begin
  APrecision := ABcd.Precision;
  AScale := ABcd.SignSpecialPlaces AND $3F;
  // Workaround for Delphi XE2, where StrToBcd always returns even precision
  if (AScale <> 0) and ((ABcd.Fraction[(APrecision + 1) div 2] AND $F) = 0) then begin
    Dec(APrecision);
    Dec(AScale);
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADBCD2Double(const ABcd: TADBcd; out AVal: Extended);
var
  aBuff: array [0 .. 127] of Char;
  iLen: Integer;
begin
  ADBCD2Str(aBuff, iLen, ABcd, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator));
  TextToFloat(aBuff, AVal, fvExtended);
end;

{-------------------------------------------------------------------------------}
procedure ADDouble2BCD(const AExt: Extended; out AVal: TADBcd);
var
  rFloat: TFloatRec;
begin
  // With Precision >= 16 we will get Double -> Extended conversion
  // garbage. Eg 0.07 gives 0.0700000000000001.
  FloatToDecimal(rFloat, AExt, fvExtended, 15, 9999);
  ADFloatRec2BCD(rFloat, AVal);
end;

{-------------------------------------------------------------------------------}
procedure ADInt2Str(ASrcData: Pointer; ASrcLen: Integer;
  var ADestData: PChar; var ADestLen: Integer; AScale: Integer);
var
  i: LongInt;
  i64: Int64;
  lNeg: Boolean;
  pBuff: PChar;
  iDigs: Integer;
begin
  ASSERT((ASrcData <> nil) and (ADestData <> nil));
  iDigs := 0;
  pBuff := ADestData + ADestLen - 1;
  pBuff^ := #0;
  Dec(pBuff);
  if ASrcLen = SizeOf(Int64) then begin
    i64 := PInt64(ASrcData)^;
    lNeg := i64 < 0;
    repeat
      pBuff^ := Char(Abs(i64 mod 10) + Ord('0'));
      Dec(pBuff);
      Inc(iDigs);
      if iDigs = AScale then begin
        pBuff^ := Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator);
        Dec(pBuff);
        iDigs := $FF;
      end;
      i64 := i64 div 10;
    until i64 = 0;
  end
  else begin
    case ASrcLen of
    SizeOf(ShortInt): i := PShortInt(ASrcData)^;
    SizeOf(SmallInt): i := PSmallInt(ASrcData)^;
    SizeOf(Integer):  i := PInteger(ASrcData)^;
    else              i := 0; ASSERT(False);
    end;
    lNeg := i < 0;
    repeat
      pBuff^ := Char(Abs(i mod 10) + Ord('0'));
      Dec(pBuff);
      Inc(iDigs);
      if iDigs = AScale then begin
        pBuff^ := Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator);
        Dec(pBuff);
        iDigs := $FF;
      end;
      i := i div 10;
    until i = 0;
  end;
  while iDigs < AScale do begin
    pBuff^ := '0';
    Dec(pBuff);
    Inc(iDigs);
    if iDigs = AScale then begin
      pBuff^ := Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator);
      Dec(pBuff);
      iDigs := $FF;
    end;
  end;
  if iDigs = $FF then begin
    pBuff^ := '0';
    Dec(pBuff);
  end;
  if lNeg then begin
    pBuff^ := '-';
    Dec(pBuff);
  end;
  ADestLen := ADestLen - (pBuff - ADestData) - 2;
  ADestData := pBuff + 1;
end;

{-------------------------------------------------------------------------------}
procedure ADStr2Int(ASrcData: PChar; ASrcLen: Integer;
  ADestData: Pointer; ADestLen: Integer; ANoSign: Boolean;
  AScale: Integer);
var
  ui64: UInt64;
  ui64Max: UInt64;
  lw: LongWord;
  lNeg: Boolean;
  pEnd: PChar;
  lHasPoint: Boolean;
  iDecs: Integer;
  pStart: PChar;

  procedure RangeError;
  var
    sVal: String;
    sType: String;
  begin
    SetString(sVal, pStart, ASrcLen);
    if ANoSign then
      case ADestLen of
      SizeOf(UInt64):   sType := 'UInt64';
      SizeOf(LongWord): sType := 'LongWord';
      SizeOf(Word):     sType := 'Word';
      SizeOf(Byte):     sType := 'Byte';
      end
    else
      case ADestLen of
      SizeOf(Int64):    sType := 'Int64';
      SizeOf(Integer):  sType := 'Integer';
      SizeOf(SmallInt): sType := 'SmallInt';
      SizeOf(ShortInt): sType := 'ShortInt';
      end;
    ADException(nil, [S_AD_LStan], er_AD_ValueOutOfRange, [sVal, sType]);
  end;

begin
  ASSERT((ASrcData <> nil) and (ADestData <> nil) and
         ((AScale = 0) or not ANoSign));
  pStart := ASrcData;
  pEnd := ASrcData + ASrcLen - 1;
  while (pEnd^ <= ' ') and (ASrcData <= pEnd) do
    Dec(pEnd);
  while (ASrcData^ <= ' ') and (ASrcData <= pEnd) do
    Inc(ASrcData);
  if ASrcData^ = '-' then begin
    if ANoSign then
      RangeError;
    lNeg := True;
    Inc(ASrcData);
  end
  else begin
    lNeg := False;
    if ASrcData^ = '+' then
      Inc(ASrcData);
  end;
  if AScale = 0 then begin
    if ADestLen = SizeOf(Int64) then begin
      ui64 := 0;
{$IFDEF AnyDAC_D15}
      if ANoSign then
        ui64Max := $FFFFFFFFFFFFFFFF div 10
      else
{$ENDIF}
        ui64Max := $7FFFFFFFFFFFFFFF div 10;
      while ASrcData <= pEnd do begin
        if ui64 > ui64Max then
          RangeError;
        ui64 := ui64 * 10 + UInt64(Ord(ASrcData^) - Ord('0'));
        Inc(ASrcData);
      end;
      if lNeg then
        Int64(ui64) := - Int64(ui64);
      PUInt64(ADestData)^ := ui64;
    end
    else begin
      lw := 0;
      while ASrcData <= pEnd do begin
        if ANoSign and (lw > $FFFFFFFF div 10) then
          RangeError;
        lw := lw * 10 + Longword(Ord(ASrcData^) - Ord('0'));
        Inc(ASrcData);
      end;
      if lNeg then
        Integer(lw) := - Integer(lw);
      case ADestLen of
      SizeOf(Byte):     PByte(ADestData)^ := Byte(lw);
      SizeOf(Word):     PWord(ADestData)^ := Word(lw);
      SizeOf(LongWord): PLongWord(ADestData)^ := LongWord(lw);
      end;
    end;
  end
  else begin
    lHasPoint := False;
    iDecs := 0;
    if ADestLen = SizeOf(Int64) then begin
      ui64 := 0;
      while (ASrcData <= pEnd) and (iDecs < AScale) do begin
        if ASrcData^ = Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator) then
          lHasPoint := True
        else begin
          if lHasPoint then
            Inc(iDecs);
          if ui64 > $7FFFFFFFFFFFFFFF div 10 then
            RangeError;
          ui64 := ui64 * 10 + UInt64(Ord(ASrcData^) - Ord('0'));
        end;
        Inc(ASrcData);
      end;
      while iDecs < AScale do begin
        if ui64 > $7FFFFFFFFFFFFFFF div 10 then
          RangeError;
        ui64 := ui64 * 10;
        Inc(iDecs);
      end;
      if lNeg then
        Int64(ui64) := - Int64(ui64);
      PUInt64(ADestData)^ := ui64;
    end
    else begin
      lw := 0;
      while (ASrcData <= pEnd) and (iDecs < AScale) do begin
        if ASrcData^ = Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator) then
          lHasPoint := True
        else begin
          if lHasPoint then
            Inc(iDecs);
          if lw > $7FFFFFFF div 10 then
            RangeError;
          lw := lw * 10 + Longword(Ord(ASrcData^) - Ord('0'));
        end;
        Inc(ASrcData);
      end;
      while iDecs < AScale do begin
        if lw > $7FFFFFFF div 10 then
          RangeError;
        lw := lw * 10;
        Inc(iDecs);
      end;
      if lNeg then
        Integer(lw) := - Integer(lw);
      case ADestLen of
      SizeOf(Byte):     PByte(ADestData)^ := Byte(lw);
      SizeOf(Word):     PWord(ADestData)^ := Word(lw);
      SizeOf(LongWord): PLongWord(ADestData)^ := LongWord(lw);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_FPC}
function CurrToBCD(const Curr: Currency; out BCD: TADBcd; Precision: Integer = 32;
  Decimals: Integer = 4): Boolean;
var
  s: String;
begin
  try
    s := ADCurr2Str(Curr, DecimalSeparator);
    ADStr2BCD(PChar(s), Length(s), BCD, DecimalSeparator);
    Result := True;
  except
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
function BCDToCurr(const BCD: TADBcd; out Curr: Currency): Boolean;
var
  aBuff: array [0..79] of Char;
  iSize: Integer;
begin
  try
    ADBCD2Str(aBuff, iSize, BCD, DecimalSeparator);
    ADStr2Curr(aBuff, iSize, Curr, DecimalSeparator);
    Result := True;
  except
    Result := False;
  end;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
function ADFloat2Str(const AValue: Extended; ADot: Char = '.';
  APrec: Integer = 18): String;
var
  aBuff: array[0..63] of Char;
{$IFDEF AnyDAC_D7}
  pFS: PADFormatSettings;
{$ELSE}
  prevDecSep: Char;
{$ENDIF}
begin
  if APrec = 0 then
    APrec := 18;
{$IFDEF AnyDAC_D7}
  pFS := @GCachedNumFS;
  pFS^.DecimalSeparator := ADot;
  SetString(Result, aBuff, FloatToText(aBuff, AValue,
    fvExtended, ffGeneral, APrec, 0, pFS^));
{$ELSE}
  prevDecSep := DecimalSeparator;
  DecimalSeparator := ADot;
  SetString(Result, aBuff, FloatToText(aBuff, AValue,
    {$IFNDEF AnyDAC_FPC} fvExtended, {$ENDIF} ffGeneral, APrec, 0));
  DecimalSeparator := prevDecSep;
{$ENDIF}
end;

{------------------------------------------------------------------------------}
function ADStr2Float(const AValue: String; ADot: Char = '.'): Extended;

  procedure Error;
  begin
    raise EConvertError.CreateFmt(SInvalidFloat, [AValue]);
  end;

var
{$IFDEF AnyDAC_D7}
  pFS: PADFormatSettings;
{$ELSE}
  prevDecSep: Char;
  lOK: Boolean;
{$ENDIF}
begin
{$IFDEF AnyDAC_D7}
  pFS := @GCachedNumFS;
  pFS^.DecimalSeparator := ADot;
  if not TextToFloat(PChar(AValue), Result, fvExtended, pFS^) then
    Error;
{$ELSE}
  prevDecSep := DecimalSeparator;
  DecimalSeparator := ADot;
  lOK := TextToFloat(PChar(AValue), Result, fvExtended);
  DecimalSeparator := prevDecSep;
  if not lOK then
    Error;
{$ENDIF}
end;

{------------------------------------------------------------------------------}
procedure ADStr2Float(pIn: PChar; ASize: Integer; out AExt: Extended; ADot: Char = '.');

  procedure Error;
  begin
    raise EConvertError.CreateFmt(SInvalidFloat, [pIn]);
  end;

var
{$IFDEF AnyDAC_D7}
  pFS: PADFormatSettings;
{$ELSE}
  prevDecSep: Char;
  lOK: Boolean;
{$ENDIF}
begin
  if (pIn + ASize)^ <> #0 then
    (pIn + ASize)^ := #0;
{$IFDEF AnyDAC_D7}
  pFS := @GCachedNumFS;
  pFS^.DecimalSeparator := Char(ADot);
  if not TextToFloat(pIn, AExt, fvExtended, pFS^) then
    Error;
{$ELSE}
  prevDecSep := DecimalSeparator;
  DecimalSeparator := ADot;
  lOK := TextToFloat(pIn, AExt, fvExtended);
  DecimalSeparator := prevDecSep;
  if not lOK then
    Error;
{$ENDIF}
end;

{------------------------------------------------------------------------------}
procedure ADCurr2Str(pOut: PChar; out ASize: Integer;
  const AValue: Currency; ADot: Char = '.');
var
{$IFDEF AnyDAC_D7}
  pFS: PADFormatSettings;
{$ELSE}
  iPrevCurrencyFormat: Integer;
  cPrevDecSep: Char;
  iPrevNegCurrFormat: Integer;
  cPrevThousandSeparator: Char;
  sPrevCurrencyString: String;
  {$IFDEF AnyDAC_FPC}
  s: String;
  {$ENDIF}
{$ENDIF}
begin
{$IFDEF AnyDAC_D7}
  pFS := @GCachedNumFS;
  pFS^.DecimalSeparator := Char(ADot);
  pFS^.CurrencyFormat := 0;
  pFS^.NegCurrFormat := 1;
  pFS^.ThousandSeparator := #0;
  pFS^.CurrencyString := '';
  ASize := FloatToText(pOut, AValue, fvCurrency, ffGeneral, 0, 0, pFS^);
{$ELSE}
  iPrevCurrencyFormat := CurrencyFormat;
  cPrevDecSep := DecimalSeparator;
  iPrevNegCurrFormat := NegCurrFormat;
  cPrevThousandSeparator := ThousandSeparator;
  sPrevCurrencyString := CurrencyString;
  CurrencyFormat := 0;
  NegCurrFormat := 1;
  ThousandSeparator := #0;
  CurrencyString := '';
  DecimalSeparator := ADot;
  {$IFNDEF AnyDAC_FPC}
  ASize := FloatToText(pOut, AValue, fvCurrency, ffGeneral, 0, 0);
  {$ELSE}
  s := FloatToStrF(AValue, ffCurrency, -1, 4);
  ASize := Length(s);
  strcopy(pOut, PChar(s));
  {$ENDIF}
  CurrencyFormat := iPrevCurrencyFormat;
  DecimalSeparator := cPrevDecSep;
  NegCurrFormat := iPrevNegCurrFormat;
  ThousandSeparator := cPrevThousandSeparator;
  CurrencyString := sPrevCurrencyString;
{$ENDIF}
end;

{------------------------------------------------------------------------------}
function ADCurr2Str(const AValue: Currency; ADot: Char = '.'): String;
var
  aBuff: array[0..63] of Char;
  iSize: Integer;
begin
  ADCurr2Str(aBuff, iSize, AValue, ADot);
  SetString(Result, aBuff, iSize);
end;

{------------------------------------------------------------------------------}
function ADStr2Curr(const AValue: String; ADot: Char = '.'): Currency;

  procedure Error;
  begin
    raise EConvertError.CreateFmt(SInvalidFloat, [AValue]);
  end;

var
{$IFDEF AnyDAC_D7}
  pFS: PADFormatSettings;
{$ELSE}
  iPrevCurrencyFormat: Integer;
  cPrevDecSep: Char;
  iPrevNegCurrFormat: Integer;
  cPrevThousandSeparator: Char;
  sPrevCurrencyString: String;
  lOK: Boolean;
{$ENDIF}
begin
{$IFDEF AnyDAC_D7}
  pFS := @GCachedNumFS;
  pFS^.DecimalSeparator := ADot;
  pFS^.CurrencyFormat := 0;
  pFS^.NegCurrFormat := 1;
  pFS^.ThousandSeparator := #0;
  pFS^.CurrencyString := '';
  if not TextToFloat(PChar(AValue), Result, fvCurrency, pFS^) then
    Error;
{$ELSE}
  iPrevCurrencyFormat := CurrencyFormat;
  cPrevDecSep := DecimalSeparator;
  iPrevNegCurrFormat := NegCurrFormat;
  cPrevThousandSeparator := ThousandSeparator;
  sPrevCurrencyString := CurrencyString;
  CurrencyFormat := 0;
  NegCurrFormat := 1;
  ThousandSeparator := #0;
  CurrencyString := '';
  DecimalSeparator := ADot;
  lOK := TextToFloat(PChar(AValue), Result, fvCurrency);
  CurrencyFormat := iPrevCurrencyFormat;
  DecimalSeparator := cPrevDecSep;
  NegCurrFormat := iPrevNegCurrFormat;
  ThousandSeparator := cPrevThousandSeparator;
  CurrencyString := sPrevCurrencyString;
  if not lOK then
    Error;
{$ENDIF}
end;

{------------------------------------------------------------------------------}
procedure ADStr2Curr(pIn: PChar; ASize: Integer; out ACurr: Currency; ADot: Char = '.');

  procedure Error;
  begin
    raise EConvertError.CreateFmt(SInvalidFloat, [pIn]);
  end;

var
{$IFDEF AnyDAC_D7}
  pFS: PADFormatSettings;
{$ELSE}
  iPrevCurrencyFormat: Integer;
  cPrevDecSep: Char;
  iPrevNegCurrFormat: Integer;
  cPrevThousandSeparator: Char;
  sPrevCurrencyString: String;
  lOK: Boolean;
{$ENDIF}
begin
  if (pIn + ASize)^ <> #0 then
    (pIn + ASize)^ := #0;
{$IFDEF AnyDAC_D7}
  pFS := @GCachedNumFS;
  pFS^.DecimalSeparator := Char(ADot);
  pFS^.CurrencyFormat := 0;
  pFS^.NegCurrFormat := 1;
  pFS^.ThousandSeparator := #0;
  pFS^.CurrencyString := '';
  if not TextToFloat(pIn, ACurr, fvCurrency, pFS^) then
    Error;
{$ELSE}
  iPrevCurrencyFormat := CurrencyFormat;
  cPrevDecSep := DecimalSeparator;
  iPrevNegCurrFormat := NegCurrFormat;
  cPrevThousandSeparator := ThousandSeparator;
  sPrevCurrencyString := CurrencyString;
  CurrencyFormat := 0;
  NegCurrFormat := 1;
  ThousandSeparator := #0;
  CurrencyString := '';
  DecimalSeparator := ADot;
  lOK := TextToFloat(pIn, ACurr, fvCurrency);
  CurrencyFormat := iPrevCurrencyFormat;
  DecimalSeparator := cPrevDecSep;
  NegCurrFormat := iPrevNegCurrFormat;
  ThousandSeparator := cPrevThousandSeparator;
  CurrencyString := sPrevCurrencyString;
  if not lOK then
    Error;
{$ENDIF}
end;

{------------------------------------------------------------------------------}
function ADBcdIsDecimalPartEmpty(const ABCD: TADBcd): Boolean;
var
  iDecPos: ShortInt;
  i: ShortInt;
  iDigit: Byte;
begin
  Result := True;
  iDecPos := ShortInt(ABCD.Precision - (ABCD.SignSpecialPlaces and 63));
  for i := iDecPos to ABCD.Precision - 1 do begin
    if i mod 2 = 0 then
      iDigit := Byte((ABcd.Fraction[i div 2]) shr 4)
    else
      iDigit := Byte(Byte((ABcd.Fraction[i div 2]) and 15));
    if iDigit <> 0 then begin
      Result := False;
      Break;
    end;
  end;
end;

{------------------------------------------------------------------------------}
function ADRandomNumber(AMaxPrec, AMaxScale: Integer; ASign: Integer): String;
var
  iLen, iDec, i: Integer;
  lWasDigit: Boolean;
begin
  iLen := Random(AMaxPrec + 1);
  if iLen = 0 then begin
    Result := '0';
    Exit;
  end;

  if AMaxScale > iLen then
    AMaxScale := iLen;
  if AMaxScale > 0 then
    iDec := iLen - Random(AMaxScale + 1)
  else
    iDec := 0;

  if (ASign = 0) and (Random(2) = 1) then
    ASign := -1;
  if ASign < 0 then begin
    Inc(iLen);
    if iDec > 0 then
      Inc(iDec);
  end;

  if iDec > 0 then
    Inc(iLen);
  if iDec = 1 then
    Inc(iLen);
  if (iDec >= iLen) or (ASign = -1) and (iDec = iLen - 1) then begin
    Dec(iLen);
    iDec := 0;
  end;

  SetLength(Result, iLen);
  i := 1;

  if ASign = -1 then begin
    Result[i] := '-';
    Inc(iDec);
    Inc(i);
  end;

  lWasDigit := False;
  while i <= iLen do begin

    if i = iDec then begin
      if not lWasDigit then begin
        Result[i] := '0';
        Inc(i);
        lWasDigit := True;
      end;
      Result[i] := {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator;
      Inc(i);
    end;

    if lWasDigit and (i < iLen) then
      Result[i] := Chr(Ord('0') + Random(10))
    else
      Result[i] := Chr(Ord('1') + Random(9));
    Inc(i);
    lWasDigit := True;
  end;

end;

{------------------------------------------------------------------------------}
function ADDisableFPExc: TADNativeUInt;
begin
{$IFDEF MSWINDOWS}
  {$IFDEF AnyDAC_D6}
  Result := TADNativeUInt(Get8087CW());
  {$ELSE}
  Result := TADNativeUInt(Default8087CW);
  {$ENDIF}
  Set8087CW($133F);
{$ENDIF}
{$IFDEF POSIX}
  Result := TADNativeUInt(signal(SIGFPE, TSignalHandler(SIG_IGN)));
{$ENDIF}
end;

{------------------------------------------------------------------------------}
procedure ADResetFPExc(AValue: TADNativeUInt);
begin
{$IFDEF MSWINDOWS}
  Set8087CW(Word(AValue));
{$ENDIF}
{$IFDEF POSIX}
  signal(SIGFPE, TSignalHandler(AValue));
{$ENDIF}
end;

{------------------------------------------------------------------------------}
{ RTL                                                                          }
{------------------------------------------------------------------------------}
procedure RTLFillChar(var Dest; count: Integer; Value: Char);
begin
  FillChar(Dest, count, TADAnsiChar(Value));
end;

{------------------------------------------------------------------------------}
{ TODO -cIOS : Should be replaced with CFBundleGetValueForInfoDictionaryKey
  (CFBundleGetMainBundle, kCFBundleVersionKey), etc }
{$IFDEF MSWINDOWS}
function ADGetVersionInfo(const AFileName: string; out AProduct,
  AVersion, AVersionName, ACopyright, AInfo: string): Boolean;
type
  TTranslation = array[0 .. 1] of Word;
const
  CTrans: String = '\VarFileInfo\Translation';
  CProdName: String = '\StringFileInfo\%s\FileDescription';
  CFileVers: String = '\StringFileInfo\%s\FileVersion';
  CCopyright: String = '\StringFileInfo\%s\LegalCopyright';
  CComments: String = '\StringFileInfo\%s\Comments';
  CSlash: String = '\';
var
  iHndl, iSz, iLen: DWORD;
  pBuff: Pointer;
  pTranslation: ^TTranslation;
  sTranslation, sBeta: String;
  pStr: PChar;
  pFileInfo: ^TVSFixedFileInfo;
begin
  Result := False;
  AProduct := '';
  AVersion := '';
  AVersionName := '';
  ACopyright := '';
  AInfo := '';
  iHndl := 0;
  iLen := 0;
  pFileInfo := nil;
  pTranslation := nil;
  pStr := nil;
  iSz := GetFileVersionInfoSize(PChar(AFileName), iHndl);
  if iSz <= 0 then
    Exit;
  GetMem(pBuff, iSz);
  try
    if not GetFileVersionInfo(PChar(AFileName), iHndl, iSz, pBuff) then
      Exit;
    if VerQueryValue(pBuff, PChar(CSlash), Pointer(pFileInfo), iLen) then
      if (pFileInfo.dwFileFlags and VS_FF_PRERELEASE) <> 0 then
        sBeta := ' Beta';
    if VerQueryValue(pBuff, PChar(CTrans), Pointer(pTranslation), iLen) then
      sTranslation := IntToHex(pTranslation^[0], 4) + IntToHex(pTranslation^[1], 4)
    else
      sTranslation := '040904B0';
    if VerQueryValue(pBuff, PChar(Format(CProdName, [sTranslation])), Pointer(pStr), iLen) then
      AProduct := pStr;
    if VerQueryValue(pBuff, PChar(Format(CFileVers, [sTranslation])), Pointer(pStr), iLen) then begin
      AVersion := pStr;
      AVersionName := Format('%d.%d.%d (Build %d)%s', [pFileInfo^.dwFileVersionMS shr 16,
        pFileInfo^.dwFileVersionMS and $0000FFFF, pFileInfo^.dwFileVersionLS shr 16,
        pFileInfo^.dwFileVersionLS and $0000FFFF, sBeta]);
    end;
    if VerQueryValue(pBuff, PChar(Format(CCopyright, [sTranslation])), Pointer(pStr), iLen) then
      ACopyright := pStr;
    if VerQueryValue(pBuff, PChar(Format(CComments, [sTranslation])), Pointer(pStr), iLen) then
      AInfo := pStr;
    Result := True;
  finally
    FreeMem(pBuff, iSz);
  end;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{$IFDEF MSWINDOWS}
var
  FLastFileName: String = '';
  FLastMachineType: TADMachineType = mtUnknown;

function ADGetLibMachineType(const AFileName: string): TADMachineType;
var
  oFS: TFileStream;
  iPeOffset: Integer;
  iPeHead: LongWord;
  iMachineType: Word;
begin
  Result := mtUnknown;
  // http://download.microsoft.com/download/9/c/5/9c5b2167-8017-4bae-9fde-d599bac8184a/pecoff_v8.doc
  // Offset to PE header is always at 0x3C.
  // PE header starts with "PE\0\0" = 0x50 0x45 0x00 0x00,
  // followed by 2-byte machine type field (see document above for enum).
  FLock.Enter;
  try
    if FLastFileName = AFileName then begin
      Result := FLastMachineType;
      Exit;
    end;
    try
      oFS := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
      try
        oFS.Seek($3C, soFromBeginning);
        oFS.Read(iPeOffset, SizeOf(iPeOffset));
        oFS.Seek(iPeOffset, soFromBeginning);
        oFS.Read(iPeHead, SizeOf(iPeHead));
        // "PE\0\0", little-endian then
        if iPeHead <> $00004550 then
          Exit;
        oFS.Read(iMachineType, SizeOf(iMachineType));
        case iMachineType of
        $8664, // AMD64
        $0200: // IA64
          Result := mt64Bit;
        $014C: // I386
          Result := mt32Bit;
        else
          Result := mtOther;
        end;
      finally
        ADFree(oFS);
      end;
    except
      // none
    end;
    FLastFileName := AFileName;
    FLastMachineType := Result;
  finally
    FLock.Leave;
  end;
end;
{$ENDIF}

{$IFDEF AnyDAC_POSIX}
function ADGetLibMachineType(const AFileName: string): TADMachineType;
begin
  { TODO -cLINUX : Implement detection of the SO type }
  Result := mt32Bit;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{$WARNINGS OFF}
{$IFDEF AnyDAC_D6Base}
function ADAcquireExceptionObject: Exception;
begin
  Result := AcquireExceptionObject;
end;
{$ELSE}
type
  PRaiseFrame = ^TRaiseFrame;
  TRaiseFrame = record
    NextRaise: PRaiseFrame;
    ExceptAddr: Pointer;
    ExceptObject: TObject;
    ExceptionRecord: PExceptionRecord;
  end;

function ADAcquireExceptionObject: Exception;
begin
  if (RaiseList <> nil) and (PRaiseFrame(RaiseList)^.ExceptObject is Exception) then begin
    Result := Exception(PRaiseFrame(RaiseList)^.ExceptObject);
    PRaiseFrame(RaiseList)^.ExceptObject := nil;
  end
  else
    Result := nil;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
procedure ADHandleException;
begin
{$IFDEF AnyDAC_D6}
  if Assigned(Classes.ApplicationHandleException) then
    Classes.ApplicationHandleException(ExceptObject);
{$ELSE}
  if GetCurrentThreadId = MainThreadID then
    SysUtils.ShowException(ExceptObject, ExceptAddr);
{$ENDIF}
end;
{$WARNINGS ON}

{------------------------------------------------------------------------------}
procedure ADShell(const ACommand, ALayer: String);
{$IFDEF POSIX}
var
  s: TADByteString;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if ShellExecute(0, 'open', PChar(ACommand), nil, nil, SW_SHOW) <= 32 then
    ADException(nil, [S_AD_LComp, ALayer], er_AD_ScrCantExecHostCmd,
      [ACommand, ADLastSystemErrorMsg]);
{$ENDIF}
{$IFDEF UNIX}
  fpSystem(ACommand);
{$ENDIF}
{$IFDEF POSIX}
  s := TADEncoder.Enco(ACommand, ecUTF8);
  _system(MarshaledAString(PADByteString(s)));
{$ENDIF}
end;

{------------------------------------------------------------------------------}
procedure ADFileMove(const ASrcName, ADestName: String);
{$IFDEF AnyDAC_POSIX}
var
  s1, s2: TADByteString;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if not MoveFileEx(PChar(ASrcName), PChar(ADestName),
                    MOVEFILE_COPY_ALLOWED or MOVEFILE_REPLACE_EXISTING) then
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  s1 := TADEncoder.Enco(ASrcName, ecUTF8);
  s2 := TADEncoder.Enco(ADestName, ecUTF8);
  unlink(MarshaledAString(PADByteString(s2)));
  if __rename(MarshaledAString(PADByteString(s1)), MarshaledAString(PADByteString(s2))) <> 0 then
{$ENDIF}
    ADException(nil, [S_AD_LStan], er_AD_StanStrgFileError,
      [ASrcName, ADestName, ADLastSystemErrorMsg]);
end;

{------------------------------------------------------------------------------}
procedure ADSystemMessage(const ACaption, AMessage: String; AWarning: Boolean);
var
{$IFDEF MSWINDOWS}
  iFlags: LongWord;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  s: TADByteString;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  iFlags := MB_TOPMOST or MB_SERVICE_NOTIFICATION;
  if AWarning then
    iFlags := iFlags or MB_ICONWARNING;
  MessageBox(0, PChar(AMessage), PChar(ACaption), iFlags);
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  s := TADEncoder.Enco(AMessage, ecUTF8);
  {$IFDEF AnyDAC_FPC}
  __write(2, PADByteString(s)^, ADByteStrLength(s));
  {$ELSE}
  __write(2, PADByteString(s), ADByteStrLength(s));
  {$ENDIF}
{$ENDIF}
end;

{------------------------------------------------------------------------------}
procedure ADSetEnv(const AName, AValue: String);
{$IFDEF AnyDAC_POSIX}
var
  s1, s2: TADByteString;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  SetEnvironmentVariable(PChar(AName), PChar(AValue));
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  s1 := TADEncoder.Enco(AName, ecUTF8);
  s2 := TADEncoder.Enco(AValue, ecUTF8);
  setenv(MarshaledAString(PADByteString(s1)), MarshaledAString(PADByteString(s2)), 1);
{$ENDIF}
end;

{------------------------------------------------------------------------------}
{$IFNDEF FPC}
  {$IFDEF POSIX}
    {$IFDEF CPU386}
function InterlockedExchange(var Target: Integer; Value: Integer): Integer;
asm
      MOV     ECX,EAX
      MOV     EAX,[ECX]
@@loop:
 LOCK CMPXCHG [ECX],EDX
      JNZ     @@loop
end;

function InterlockedAdd(var Addend: Integer; Increment: Integer): Integer;
asm
      MOV   ECX,EAX
      MOV   EAX,EDX
 LOCK XADD  [ECX],EAX
      ADD   EAX,EDX
end;

function InterlockedDecrement(var Addend: Integer): Integer;
asm
      MOV   EDX,-1
      JMP   InterlockedAdd
end;

function InterlockedIncrement(var Addend: Integer): Integer;
asm
      MOV   EDX,1
      JMP   InterlockedAdd
end;
    {$ENDIF}
    {$IFDEF CPUX64}
function InterlockedExchangePointer(var Target: Pointer; Value: Pointer): Pointer;
asm
       .NOFRAME
  LOCK XCHG [RCX],RDX
       MOV RAX,RDX
end;

function InterlockedDecrement(var Addend: LongInt): LongInt;
asm
      .NOFRAME
      MOV   EAX,-1
 LOCK XADD  [RCX].Integer,EAX
      DEC   EAX
end;

function InterlockedIncrement(var Addend: LongInt): LongInt;
asm
      MOV   EAX,1
 LOCK XADD  [RCX].Integer,EAX
      INC   EAX
end;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

function ADInterlockedExchangePointer(var Destination: Pointer; Exchange: Pointer): Pointer;
begin
{$IFDEF AnyDAC_D18}
  Result := AtomicExchange(Destination, Exchange);
{$ELSE}
  {$IFDEF AnyDAC_32}
  Result := Pointer(InterlockedExchange(Integer(Destination), Integer(Exchange)));
  {$ELSE}
    {$IFDEF FPC}
  Result := Pointer(InterlockedExchange64(Int64(Destination), Int64(Exchange)));
    {$ELSE}
  Result := InterlockedExchangePointer(Destination, Exchange);
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
end;

{------------------------------------------------------------------------------}
function ADInterlockedIncrement(var Addend: LongInt): LongInt;
begin
{$IFDEF AnyDAC_D18}
  Result := AtomicIncrement(Addend);
{$ELSE}
  Result := InterlockedIncrement(Addend);
{$ENDIF}
end;

{------------------------------------------------------------------------------}
function ADInterlockedDecrement(var Addend: LongInt): LongInt;
begin
{$IFDEF AnyDAC_D18}
  Result := AtomicDecrement(Addend);
{$ELSE}
  Result := InterlockedDecrement(Addend);
{$ENDIF}
end;

{------------------------------------------------------------------------------}
procedure ADHighRefCounter(var ACounter: Integer);
begin
{$IFDEF AUTOREFCOUNT}
  ACounter := ACounter or $FFFFFFF;
{$ELSE}
  ACounter := $3FFFFFFF;
{$ENDIF}
end;

{------------------------------------------------------------------------------}
initialization
{$IFDEF MACOS}
  // MACOS: by default invalid format - ':nn' and ':'
  FormatSettings.ShortTimeFormat := 'hh:nn';
  FormatSettings.TimeSeparator := ':';
{$ENDIF}
  C_Date_1_1_1 := EncodeDate(1, 1, 1);
  FLock := TCriticalSection.Create;
  FExpandStrCache := TADStringList.Create;
  FExpandStrCache.Sorted := True;
  FExpandStrCache.Duplicates := dupError;
  ADFillChar := @RTLFillChar;

  GParseFmtSettings.FDelimiter := ';';
  GParseFmtSettings.FQuote := '"';
  GParseFmtSettings.FQuote1 := '{';
  GParseFmtSettings.FQuote2 := '}';

  GSemicolonFmtSettings.FDelimiter := ';';
  GSemicolonFmtSettings.FQuote := #0;
  GSemicolonFmtSettings.FQuote1 := #0;
  GSemicolonFmtSettings.FQuote2 := #0;

  GSpaceFmtSettings.FDelimiter := ' ';
  GSpaceFmtSettings.FQuote := #0;
  GSpaceFmtSettings.FQuote1 := #0;
  GSpaceFmtSettings.FQuote2 := #0;

  FThreads := TADThreadObjList.Create;
  GTimerPool := nil;
  GCheckGuiRunning := nil;

  GEncoder := TADEncoder.Create(nil);

finalization
  ADFreeAndNil(FExpandStrCache);
  ADFreeAndNil(FThreads);
  TADTimer.Shutdown;
  ADFreeAndNil(FLock);
  ADFreeAndNil(GEncoder);

end.
