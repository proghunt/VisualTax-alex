{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{               FireDAC SQL script engine               }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompScript;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF AnyDAC_D16}
  Types,
{$ENDIF}
  SysUtils, Classes, SyncObjs,
  uADStanParam, uADStanIntf, uADStanOption, uADStanUtil, uADStanError,
  uADGUIxIntf,
  uADDatSManager,
  uADPhysIntf, uADPhysCmdPreprocessor,
  uADCompGUIx, uADCompClient;

type
  IADScriptEngineIntf = interface;
  TADScriptCommand = class;
  TADScriptCommandClass = class of TADScriptCommand;
  TADScriptParser = class;
  TADScriptOptions = class;
  TADSQLScript = class;
  TADSQLScripts = class;
  TADScript = class;

  TADScriptEchoCommands = (ecNone, ecSQL, ecAll);
  TADScriptSpoolOutputMode = (smNone, smOnReset, smOnAppend);
  TADScriptStatus = (ssInactive, ssValidating, ssRunning, ssFinishWithErrors,
    ssFinishSuccess, ssAborted);
  TADScriptTextMode = (smRead, smWriteReset, smWriteAppend);

  TADHostCommandEvent = procedure (AEngine: TADScript;
    const ACommand: String; var ADoDefault: Boolean) of object;
  TADConsolePutEvent = procedure (AEngine: TADScript;
    const AMessage: String; AKind: TADScriptOuputKind) of object;
  TADConsoleLockUpdate = procedure (AEngine: TADScript; ALock: Boolean) of object;
  TADConsoleGetEvent = procedure (AEngine: TADScript;
    const APrompt: String; var AResult: String) of object;
  TADGetTextEvent = procedure (AEngine: TADScript;
    const AFileName: String; AMode: TADScriptTextMode; out AText: TADTextFile) of object;
  TADPauseEvent = procedure (AEngine: TADScript;
    const AText: String) of object;

  IADScriptEngineIntf = interface (IUnknown)
    ['{FFD3BABC-CFAB-4A6E-9B1B-882E76791DF6}']
    // private
    function GetRDBMSKind: TADRDBMSKind;
    function GetConnectionIntf: IADPhysConnection;
    function GetCommandIntf: IADPhysCommand;
    function GetTable: TADDatSTable;

    // public
    procedure CheckCommand;
    procedure CheckCommit(AForce: Boolean);
    procedure CheckStartTransaction;
    procedure UpdateCommandSeparator;
    function ExpandString(const AValue: String): String;

    procedure CloseSpool;
    procedure UpdateSpool;

    procedure OpenConnection(const AConnectionString: String);
    procedure CloseConnection;
    procedure Disconnect(AAbortJob: Boolean = False);

    function ExecuteAll(AParser: TADScriptParser): Boolean; overload;
    function ExecuteStep(AParser: TADScriptParser): Boolean; overload;
    function ValidateAll(AParser: TADScriptParser): Boolean; overload;
    function ValidateStep(AParser: TADScriptParser): Boolean; overload;

    procedure Progress;
    procedure ConPut(const AMsg: String; AKind: TADScriptOuputKind);
    procedure ConLockUpdate;
    procedure ConUnlockUpdate;
    procedure ConGet(const APrompt: String; var AResult: String);
    procedure ConPause(const APrompt: String);
    procedure GetText(const AFileName: String; AMode: TADScriptTextMode;
      out AText: TADTextFile);
    procedure ReleaseText(const AFileName: String; AMode: TADScriptTextMode;
      var AText: TADTextFile);
    procedure ExecuteHostCommand(const ACommand: String);

    property ConnectionIntf: IADPhysConnection read GetConnectionIntf;
    property CommandIntf: IADPhysCommand read GetCommandIntf;
    property RDBMSKind: TADRDBMSKind read GetRDBMSKind;
    property Table: TADDatSTable read GetTable;
  end;

  TADScriptCommand = class(TObject)
  private
    FParser: TADScriptParser;
    FEngine: TADScript;
    FEngineIntf: IADScriptEngineIntf;
    FPosition: TPoint;
  public
    constructor Create(AParser: TADScriptParser; AEngine: TADScript); virtual;
    destructor Destroy; override;
{$IFDEF AnyDAC_MONITOR}
    function Dump(): String; virtual;
{$ENDIF}
    class function Help(): String; virtual;
    class procedure Keywords(AKwds: TStrings); virtual;
    function Parse(const AKwd: String): Boolean; virtual;
    procedure Execute(); virtual;
    procedure Validate(); virtual;
    procedure AbortJob(const AWait: Boolean = False); virtual;
    property Parser: TADScriptParser read FParser;
    property Engine: TADScript read FEngine;
    property EngineIntf: IADScriptEngineIntf read FEngineIntf;
    property Position: TPoint read FPosition;
  end;

  TADScriptCommandLookupRes = (ucNone, ucPartial, ucShort, ucExact);
  TADScriptCommandRegistry = class(TObject)
  private
    FKeywords: TADStringList;
    FCommands: TADClassList;
    FDefaultSQLCommandClass: TADScriptCommandClass;
    FDefaultPLSQLCommandClass: TADScriptCommandClass;
    function GetCommand(AIndex: Integer): TADScriptCommandClass;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddCommand(ACommand: TADScriptCommandClass);
    function LookupCommand(const AStr: String;
      out ACommand: TADScriptCommandClass): TADScriptCommandLookupRes;
    property DefaultSQLCommandClass: TADScriptCommandClass
      read FDefaultSQLCommandClass write FDefaultSQLCommandClass;
    property DefaultPLSQLCommandClass: TADScriptCommandClass
      read FDefaultPLSQLCommandClass write FDefaultPLSQLCommandClass;
    property Count: Integer read GetCount;
    property Commands[AIndex: Integer]: TADScriptCommandClass read GetCommand; default;
  end;

  TADScriptParser = class(TObject)
  private
    FCh: Char;
    FBeginningOfLine: Boolean;
    FWasBeginningOfLine: Boolean;
    FFileName: String;
    FParentCommand: TADScriptCommand;
    FLineNumber: Integer;
    FLineNumberPos: Int64;
    FTotalSize: Integer;
    FScriptOptions: TADScriptOptions;
    FText: TADTextFile;
    FLastKwd: String;
    FPrep: TADPhysPreprocessor;
    function CreateScriptCommand(ACmdClass: TADScriptCommandClass;
      AEngine: TADScript; const AKwd: String): TADScriptCommand;
    function CreateSQLCommand(var ABeginBmk, ALastBmk, AEndBmk: Integer;
      AEngine: TADScript; var ACommand: TADScriptCommand): Boolean;
    function GetPosition: TPoint;
    procedure SetPosition(const AValue: TPoint);
    function InternalGetString(AAllowQuote, AAllowDoubleQuote, ARequired,
      AIgnoreSep: Boolean; ASet: TADCharSet): String;
    function GetEOL(AFirstCh: Char): Boolean;
  protected
    function InternalGetChar: Char;
    function InternalGetBookmark: Integer;
    procedure InternalSetBookmark(ABmk: Integer);
    function InternalExtractString(ABmk1, ABmk2: Integer): String;
  public
    constructor Create(AFileName: String; AParentCommand: TADScriptCommand;
      AText: TADTextFile; AOptions: TADScriptOptions);
    // low level
    procedure GetChar;
    procedure UnGetChar;
    function GetBookmark: Integer;
    procedure SetBookmark(ABmk: Integer);
    function ExtractString(ABmk1, ABmk2: Integer): String;
    procedure SkipWS;
    procedure SkipWSLF;
    function GetUCWord: String;
    function GetString(ARequired: Boolean = False): String;
    function GetStringInFull: String;
    function GetIdentifier: String;
    function GetLine: String;
    function GetOnOfChar(ADef: Char): Integer;
    function GetOnOff: Integer;
    function GetNumber(ADef: Integer = 0): Integer;
    // high level
    procedure InvalidSyntax;
    function ExtractCommand(AEngine: TADScript): TADScriptCommand;
    // props
    // R/O
    property Ch: Char read FCh;
    property FileName: String read FFileName;
    property LineNumber: Integer read FLineNumber;
    property ParentCommand: TADScriptCommand read FParentCommand;
    property WasBeginningOfLine: Boolean read FWasBeginningOfLine;
    // R/W
    property TotalSize: Integer read FTotalSize write FTotalSize;
    property ScriptOptions: TADScriptOptions read FScriptOptions write FScriptOptions;
    property Position: TPoint read GetPosition write SetPosition;
  end;

  TADScriptOptions = class(TPersistent)
  private
    FOwner: TPersistent;
    FCommitEachNCommands: Integer;
    FAutoPrintParams: Boolean;
    FEchoCommands: TADScriptEchoCommands;
    FFeedbackCommands: Boolean;
    FColumnHeadings: Boolean;
    FMaxBytesToPrintLongs: Integer;
    FConsoleOutput: Boolean;
    FSpoolOutput: TADScriptSpoolOutputMode;
    FSpoolFileName: String;
    FTiming: Boolean;
    FBreakOnError: Boolean;
    FDropNonexistObj: Boolean;
    FCommandSeparator: String;
    FParamArraySize: Integer;
    FEchoCommandTrim: Integer;
    FFeedbackScript: Boolean;
    FActualCommandSeparator: String;
    FDefaultScriptPath: String;
    FMacroExpand: Boolean;
    FTrimConsole: Boolean;
    FTrimSpool: Boolean;
    FVerify: Boolean;
    FDefaultDataPath: String;
    FPageSize: Integer;
    FLineSize: Integer;
    FFileEndOfLine: TADTextEndOfLine;
    FFileEncoding: TADEncoding;
    FIgnoreError: Boolean;
    FCharacterSet: String;
    FSQLDialect: Integer;
    FClientLib: String;
    FDriverID: String;
    FRaisePLSQLErrors: Boolean;
    procedure SetCommandSeparator(const AValue: String);
    procedure SetDriverID(const AValue: String);
  protected
    function GetOwner: TPersistent; override;
  public
    property ActualCommandSeparator: String read FActualCommandSeparator;
  published
    constructor Create(AOwner: TPersistent);
    procedure Reset;
    procedure Assign(Source: TPersistent); override;
    property CommitEachNCommands: Integer read FCommitEachNCommands write FCommitEachNCommands default 0;
    property AutoPrintParams: Boolean read FAutoPrintParams write FAutoPrintParams default False;
    property EchoCommands: TADScriptEchoCommands read FEchoCommands write FEchoCommands default ecSQL;
    property EchoCommandTrim: Integer read FEchoCommandTrim write FEchoCommandTrim default 50;
    property FeedbackCommands: Boolean read FFeedbackCommands write FFeedbackCommands default True;
    property FeedbackScript: Boolean read FFeedbackScript write FFeedbackScript default True;
    property ColumnHeadings: Boolean read FColumnHeadings write FColumnHeadings default True;
    property MaxStringWidth: Integer read FMaxBytesToPrintLongs write FMaxBytesToPrintLongs default 80;
    property ConsoleOutput: Boolean read FConsoleOutput write FConsoleOutput default True;
    property SpoolOutput: TADScriptSpoolOutputMode read FSpoolOutput write FSpoolOutput default smNone;
    property SpoolFileName: String read FSpoolFileName write FSpoolFileName;
    property Timing: Boolean read FTiming write FTiming default True;
    property BreakOnError: Boolean read FBreakOnError write FBreakOnError default False;
    property IgnoreError: Boolean read FIgnoreError write FIgnoreError default False;
    property DropNonexistObj: Boolean read FDropNonexistObj write FDropNonexistObj default True;
    property CommandSeparator: String read FCommandSeparator write SetCommandSeparator;
    property ParamArraySize: Integer read FParamArraySize write FParamArraySize default 1;
    property PageSize: Integer read FPageSize write FPageSize default 24;
    property LineSize: Integer read FLineSize write FLineSize default 0;
    property DefaultScriptPath: String read FDefaultScriptPath write FDefaultScriptPath;
    property MacroExpand: Boolean read FMacroExpand write FMacroExpand default True;
    property TrimConsole: Boolean read FTrimConsole write FTrimConsole default False;
    property TrimSpool: Boolean read FTrimSpool write FTrimSpool default True;
    property Verify: Boolean read FVerify write FVerify default False;
    property DefaultDataPath: String read FDefaultDataPath write FDefaultDataPath;
    property FileEncoding: TADEncoding read FFileEncoding write FFileEncoding default ecANSI;
    property FileEndOfLine: TADTextEndOfLine read FFileEndOfLine write FFileEndOfLine default elDefault;
    property DriverID: String read FDriverID write SetDriverID;
    property ClientLib: String read FClientLib write FClientLib;
    property CharacterSet: String read FCharacterSet write FCharacterSet;
    property SQLDialect: Integer read FSQLDialect write FSQLDialect default 0;
    property RaisePLSQLErrors: Boolean read FRaisePLSQLErrors write FRaisePLSQLErrors default False;
  end;

  TADSQLScript = class(TCollectionItem)
  private
    FName: String;
    FSQL: TStrings;
    procedure SetSQL(const AValue: TStrings);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
  published
    property Name: String read FName write FName;
    property SQL: TStrings read FSQL write SetSQL;
  end;

  TADSQLScripts = class(TOwnedCollection)
  private
    function GetItems(AIndex: Integer): TADSQLScript;
    procedure SetItems(AIndex: Integer; const AValue: TADSQLScript);
  public
    constructor Create(AScript: TADScript);
    function Add: TADSQLScript;
    function FindScript(const AName: String): TADSQLScript;
    property Items[AIndex: Integer]: TADSQLScript read GetItems write SetItems; default;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADScript = class(TADComponent,
    {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF} IADStanOptions, IADStanErrorHandler,
    IADStanObject, IADGUIxScriptDialogInfoProvider, IADScriptEngineIntf)
  private
    FFinished: Boolean;
    FConnectionIntf: IADPhysConnection;
    FCommandIntf: IADPhysCommand;
    FTable: TADDatSTable;
    FMacros: TADMacros;
    FParams: TADParams;
    FArguments: TStrings;
    FProcessedAfterCommit: Integer;
    FSpool: TADTextFile;
    FLastSpoolFileName: String;
    FLock: TCriticalSection;
    FPrep: TADPhysPreprocessor;
    FRDBMSKind: TADRDBMSKind;

    FCurrentCommand: TADScriptCommand;
    FCallStack: TStrings;
    FAllSpools: TStrings;
    FTotalJobSize: Integer;
    FTotalJobDone: Integer;
    FTotalPct10Done: Integer;
    FTotalErrors: Integer;
    FStatus: TADScriptStatus;

    FOnHostCommand: TADHostCommandEvent;
    FOnConsolePut: TADConsolePutEvent;
    FOnConsoleLockUpdate: TADConsoleLockUpdate;
    FOnConsoleGet: TADConsoleGetEvent;
    FOnSpoolPut: TADConsolePutEvent;
    FOnGetText: TADGetTextEvent;
    FOnReleaseText: TADGetTextEvent;
    FOnPause: TADPauseEvent;
    FOnProgress: TNotifyEvent;
    FBeforeScript: TNotifyEvent;
    FAfterScript: TNotifyEvent;
    FAfterExecute: TNotifyEvent;
    FBeforeExecute: TNotifyEvent;
    FOnError: TADErrorEvent;

    FScriptOptions: TADScriptOptions;
    FScriptDialog: TADGUIxScriptDialog;
    FScriptDialogVisible: Boolean;
    FSQLScriptFileName: String;
    FSQLScripts: TADSQLScripts;
    FConnection: TADCustomConnection;
    FTransaction: TADCustomTransaction;
    FOptionsIntf: IADStanOptions;
    FPosition: TPoint;

    function GetScriptDialogIntf(out AIntf: IADGUIxScriptDialog): Boolean;
    procedure SetCurrentCommand(const ACommand: TADScriptCommand);
    procedure SetScriptOptions(const AValue: TADScriptOptions);
    procedure SetScriptDialog(const AValue: TADGUIxScriptDialog);
    procedure RestoreArguments(AArgs: TStrings);
    function SetupArguments: TStrings;
    procedure SetArguments(const AValue: TStrings);
    procedure SetConnection(const AValue: TADCustomConnection);
    procedure SetTransaction(const AValue: TADCustomTransaction);
    procedure DoConnectChanged(Sender: TObject; Connecting: Boolean);
    procedure SetSQLScripts(const AValue: TADSQLScripts);
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetResourceOptions: TADResourceOptions;
    procedure SetFetchOptions(const Value: TADFetchOptions);
    procedure SetFormatOptions(const Value: TADFormatOptions);
    procedure SetResourceOptions(const Value: TADResourceOptions);
    function GetEof: Boolean;
    procedure SetMacros(const AValue: TADMacros);
    procedure SetParams(const AValue: TADParams);
    function GetParamsOwner: TPersistent;
    function GetIsEmpty: Boolean;

  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    function InternalExecute(AParser: TADScriptParser; ARealExecute: Boolean;
      AAll: Boolean): Boolean; overload;
    function InternalExecute(ARealExecute: Boolean; AAll: Boolean): Boolean; overload;
    procedure InternalOpenConnection(const AConnectionString: String);
    procedure InternalReleaseConnection;

    { IADStanObject }
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    { IADStanOptions }
    property OptionsIntf: IADStanOptions read FOptionsIntf implements IADStanOptions;
    procedure GetParentOptions(out AOpts: IADStanOptions);
    { IADStanErrorHandler }
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    { IADGUIxScriptDialogInfoProvider }
    procedure RequestStop;
    function GetCallStack: TStrings;
    function GetTotalJobSize: Integer;
    function GetTotalJobDone: Integer;
    function GetTotalPct10Done: Integer;
    function GetTotalErrors: Integer;
    function GetIsRunning: Boolean;

    { IADScriptEngineIntf }
    function GetRDBMSKind: TADRDBMSKind;
    function GetConnectionIntf: IADPhysConnection;
    function GetCommandIntf: IADPhysCommand;
    function GetTable: TADDatSTable;

    procedure CheckCommand;
    procedure CheckCommit(AForce: Boolean);
    procedure CheckStartTransaction;
    procedure UpdateCommandSeparator;
    function ExpandString(const AValue: String): String;

    procedure CloseSpool;
    procedure UpdateSpool;

    procedure OpenConnection(const AConnectionString: String);
    procedure CloseConnection;
    procedure Disconnect(AAbortJob: Boolean = False);

    function ExecuteAll(AParser: TADScriptParser): Boolean; overload;
    function ExecuteStep(AParser: TADScriptParser): Boolean; overload;
    function ValidateAll(AParser: TADScriptParser): Boolean; overload;
    function ValidateStep(AParser: TADScriptParser): Boolean; overload;

    procedure Progress;
    procedure ConPut(const AMsg: String; AKind: TADScriptOuputKind); virtual;
    procedure ConLockUpdate; virtual;
    procedure ConUnlockUpdate; virtual;
    procedure ConGet(const APrompt: String; var AResult: String); virtual;
    procedure ConPause(const APrompt: String); virtual;
    procedure GetText(const AFileName: String; AMode: TADScriptTextMode;
      out AText: TADTextFile); virtual;
    procedure ReleaseText(const AFileName: String; AMode: TADScriptTextMode;
      var AText: TADTextFile); virtual;
    procedure ExecuteHostCommand(const ACommand: String); virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function ExecuteAll: Boolean; overload;
    function ExecuteStep: Boolean; overload;
    function ValidateAll: Boolean; overload;
    function ValidateStep: Boolean; overload;

    procedure ExecuteFile(const AFileName: String); overload;
    procedure ExecuteFile(const AFileName: String; const AArguments: array of String); overload;
    procedure ExecuteScript(const AScript: TStrings); overload;
    procedure ExecuteScript(const AScript: TStrings; const AArguments: array of String); overload;
    procedure AbortJob(const AWait: Boolean = False);

    property CallStack: TStrings read GetCallStack;
    property TotalJobSize: Integer read GetTotalJobSize;
    property TotalJobDone: Integer read GetTotalJobDone;
    property TotalPct10Done: Integer read GetTotalPct10Done;
    property TotalErrors: Integer read GetTotalErrors;
    property CurrentCommand: TADScriptCommand read FCurrentCommand;
    property AllSpools: TStrings read FAllSpools;
    property LastSpoolFileName: String read FLastSpoolFileName;
    property Status: TADScriptStatus read FStatus;
    property Eof: Boolean read GetEof;
    property IsEmpty: Boolean read GetIsEmpty;

    property Position: TPoint read FPosition write FPosition;
    property Finished: Boolean read FFinished write FFinished;
    property ProcessedAfterCommit: Integer read FProcessedAfterCommit write FProcessedAfterCommit;

  published
    property SQLScriptFileName: String read FSQLScriptFileName write FSQLScriptFileName;
    property SQLScripts: TADSQLScripts read FSQLScripts write SetSQLScripts;
    property Connection: TADCustomConnection read FConnection write SetConnection;
    property Transaction: TADCustomTransaction read FTransaction write SetTransaction;
    property ScriptOptions: TADScriptOptions read FScriptOptions write SetScriptOptions;
    property ScriptDialog: TADGUIxScriptDialog read FScriptDialog write SetScriptDialog;
    property Params: TADParams read FParams write SetParams;
    property Macros: TADMacros read FMacros write SetMacros;
    property Arguments: TStrings read FArguments write SetArguments;
    property FormatOptions: TADFormatOptions read GetFormatOptions write SetFormatOptions;
    property FetchOptions: TADFetchOptions read GetFetchOptions write SetFetchOptions;
    property ResourceOptions: TADResourceOptions read GetResourceOptions write SetResourceOptions;

    property OnHostCommand: TADHostCommandEvent read FOnHostCommand write FOnHostCommand;
    property OnConsolePut: TADConsolePutEvent read FOnConsolePut write FOnConsolePut;
    property OnConsoleLockUpdate: TADConsoleLockUpdate read FOnConsoleLockUpdate write FOnConsoleLockUpdate;
    property OnConsoleGet: TADConsoleGetEvent read FOnConsoleGet write FOnConsoleGet;
    property OnSpoolPut: TADConsolePutEvent read FOnSpoolPut write FOnSpoolPut;
    property OnGetText: TADGetTextEvent read FOnGetText write FOnGetText;
    property OnReleaseText: TADGetTextEvent read FOnReleaseText write FOnReleaseText;
    property OnPause: TADPauseEvent read FOnPause write FOnPause;
    property OnProgress: TNotifyEvent read FOnProgress write FOnProgress;
    property BeforeScript: TNotifyEvent read FBeforeScript write FBeforeScript;
    property AfterScript: TNotifyEvent read FAfterScript write FAfterScript;
    property OnError: TADErrorEvent read FOnError write FOnError;
    property BeforeExecute: TNotifyEvent read FBeforeExecute write FBeforeExecute;
    property AfterExecute: TNotifyEvent read FAfterExecute write FAfterExecute;
  end;

function ADKeywordMatch(const AStr, AMatch: String; AOptLength: Integer): Boolean;
function ADScriptCommandRegistry(): TADScriptCommandRegistry;

implementation

uses
  uADStanFactory, uADStanConst
{$IFNDEF AnyDAC_D7}
  , uADCompScriptCommands
{$ENDIF}
  ;

var
  FScriptCommandRegistry: TADScriptCommandRegistry = nil;

{-------------------------------------------------------------------------------}
function ADKeywordMatch(const AStr, AMatch: String; AOptLength: Integer): Boolean;
begin
  if Length(AStr) > Length(AMatch) then
    Result := False
  else begin
    Result := StrLComp(PChar(AStr), PChar(AMatch), AOptLength) = 0;
    if Result and (Length(AStr) > AOptLength) then
      Result := StrLComp(PChar(AStr) + AOptLength, PChar(AMatch) + AOptLength,
        Length(AStr) - AOptLength) = 0;
  end;
end;

{-------------------------------------------------------------------------------}
function ADScriptCommandRegistry(): TADScriptCommandRegistry;
begin
  if FScriptCommandRegistry = nil then
    FScriptCommandRegistry := TADScriptCommandRegistry.Create;
  Result := FScriptCommandRegistry;
end;

{-------------------------------------------------------------------------------}
function UpperCh(const ACh: Char): Char;
begin
  if ADInSet(ACh, ['a' .. 'z']) then
    Result := Char(Word(ACh) xor $0020)
  else
    Result := ACh;
end;

{-------------------------------------------------------------------------------}
{ TADScriptCommand                                                              }
{-------------------------------------------------------------------------------}
constructor TADScriptCommand.Create(AParser: TADScriptParser;
  AEngine: TADScript);
begin
  inherited Create;
  FParser := AParser;
  FEngine := AEngine;
  FEngineIntf := AEngine as IADScriptEngineIntf;
  if FEngine <> nil then
    FEngine.SetCurrentCommand(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADScriptCommand.Destroy;
begin
  if (FEngine <> nil) and (FEngine.CurrentCommand = Self) then
    FEngine.SetCurrentCommand(nil);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
function TADScriptCommand.Dump(): String;
begin
  Result := '<incompleted>';
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
class function TADScriptCommand.Help(): String;
begin
  Result := '';
end;

{-------------------------------------------------------------------------------}
class procedure TADScriptCommand.Keywords(AKwds: TStrings);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADScriptCommand.Parse(const AKwd: String): Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptCommand.Execute;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADScriptCommand.Validate;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADScriptCommand.AbortJob(const AWait: Boolean);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
{ TADScriptCommandRegistry                                                      }
{-------------------------------------------------------------------------------}
type
  TADScriptCommandRegItem = class (TObject)
    FClass: TADScriptCommandClass;
    constructor Create(AClass: TADScriptCommandClass);
  end;

constructor TADScriptCommandRegItem.Create(AClass: TADScriptCommandClass);
begin
  inherited Create;
  FClass := AClass;
end;

{-------------------------------------------------------------------------------}
{ TADScriptCommandRegistry                                                      }
{-------------------------------------------------------------------------------}
constructor TADScriptCommandRegistry.Create;
begin
  inherited Create;
  FCommands := TADClassList.Create;
  FKeywords := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADScriptCommandRegistry.Destroy;
begin
  ADFreeAndNil(FCommands);
  ADFreeAndNil(FKeywords);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADScriptCommandRegistry.GetCount: Integer;
begin
  Result := FCommands.Count;
end;

{-------------------------------------------------------------------------------}
function TADScriptCommandRegistry.GetCommand(AIndex: Integer): TADScriptCommandClass;
begin
  Result := TADScriptCommandClass(FCommands[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADScriptCommandRegistry.AddCommand(ACommand: TADScriptCommandClass);
var
  i: Integer;
  oKwds: TADStringList;
begin
  FCommands.Add(ACommand);
  FKeywords.Sorted := False;
  oKwds := TADStringList.Create;
  try
    ACommand.Keywords(oKwds);
    for i := 0 to oKwds.Count - 1 do
      FKeywords.AddPtr(oKwds[i], ACommand);
  finally
    ADFree(oKwds);
  end;
end;

{-------------------------------------------------------------------------------}
function TADScriptCommandRegistry.LookupCommand(const AStr: String;
  out ACommand: TADScriptCommandClass): TADScriptCommandLookupRes;
var
  L, H, I, C, j, iStrLen: Integer;
  sKwd: String;
begin
  FKeywords.Sorted := True;
  Result := ucNone;
  ACommand := nil;
  iStrLen := Length(AStr);
  L := 0;
  H := FKeywords.Count - 1;
  while L <= H do begin
    I := (L + H) shr 1;

    //      1     2      3      4      5      6
    // kwd: AAAA  AAAA   AAAA   AAaa   AAaa   AAaa
    // str: AA    AAAA   AAAAA  AA     AAA    AAAA
    // res: part  exact  none   short  short  exact

    sKwd := FKeywords[I];
    C := 0;
    j := 1;
    Result := ucNone;
    while j <= iStrLen do begin
      // 3
      if j > Length(sKwd) then begin
        Result := ucNone;
        Break;
      end;
      C := Ord(sKwd[j]) - Ord(AStr[j]);
      if j = iStrLen then begin
        if C = 0 then
          if j < Length(sKwd) then
            // 4
            if ADInSet(sKwd[j + 1], ['a' .. 'z']) then
              Result := ucShort
            // 1
            else begin
              Result := ucPartial;
              if not ADInSet(sKwd[j + 1], ['a' .. 'z', 'A' .. 'Z', '0' .. '9']) then
                C := 1;
            end
          // 2
          else
            Result := ucExact
        else if (C = 32) and ADInSet(sKwd[j], ['a' .. 'z']) then begin
          // 5
          if j < Length(sKwd) then
            Result := ucShort
          // 6
          else
            Result := ucExact;
          C := 0;
        end
        else
          Result := ucNone;
      end
      else
        if not ((C = 0) or (C = 32) and ADInSet(sKwd[j], ['a' .. 'z'])) then begin
          Result := ucNone;
          Break;
        end
        else
          C := 0;
      Inc(j);
    end;

    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then
        L := I;
    end;
  end;

  if Result in [ucShort, ucExact] then
    ACommand := TADScriptCommandClass(FKeywords.Ptrs[L]);
end;

{-------------------------------------------------------------------------------}
{ TADScriptParser                                                               }
{-------------------------------------------------------------------------------}
constructor TADScriptParser.Create(AFileName: String; AParentCommand: TADScriptCommand;
  AText: TADTextFile; AOptions: TADScriptOptions);
begin
  inherited Create;
  FFileName := AFileName;
  FParentCommand := AParentCommand;
  FText := AText;
  FBeginningOfLine := True;
  FScriptOptions := AOptions;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.InternalGetBookmark: Integer;
begin
  Result := Integer(FText.Position);
end;

{-------------------------------------------------------------------------------}
procedure TADScriptParser.InternalSetBookmark(ABmk: Integer);
begin
  FText.Position := ABmk;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.InternalGetChar: Char;
begin
  if not FText.ReadChar(Result) then
    Result := #0;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.InternalExtractString(ABmk1, ABmk2: Integer): String;
begin
  Result := FText.ExtractString(ABmk1, ABmk2);
end;

{-------------------------------------------------------------------------------}
procedure TADScriptParser.GetChar;
begin
  FCh := InternalGetChar;
  if FCh <> #0 then begin
    Inc(FTotalSize);
    if ADInSet(FCh, [#13, #10]) then
      FBeginningOfLine := True
    else if FBeginningOfLine then
      FBeginningOfLine := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptParser.UnGetChar;
begin
  SetBookmark(GetBookmark - 1);
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetBookmark: Integer;
begin
  Result := InternalGetBookmark;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptParser.SetBookmark(ABmk: Integer);
begin
  if ABmk > 0 then begin
    Inc(FTotalSize, ABmk - 1 - InternalGetBookmark);
    InternalSetBookmark(ABmk - 1);
    GetChar;
  end
  else begin
    Inc(FTotalSize, ABmk - InternalGetBookmark);
    InternalSetBookmark(ABmk);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptParser.SkipWSLF;
begin
  while ADInSet(FCh, [' ', #9, #13, #10]) do
    GetChar;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptParser.SkipWS;
begin
  while ADInSet(FCh, [' ', #9]) do
    GetChar;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.InternalGetString(AAllowQuote, AAllowDoubleQuote,
  ARequired, AIgnoreSep: Boolean; ASet: TADCharSet): String;
var
  i1, i2: Integer;
  iQuoted, iSep, iLen: Integer;
  ucCS: String;
begin
  SkipWS;
  i1 := GetBookmark - 1;
  iLen := 2;
  if AAllowDoubleQuote and (FCh = '"') then begin
    iQuoted := 1;
    GetChar;
    while not ADInSet(FCh, [#0, #13, #10]) do begin
      if FCh = '"' then begin
        GetChar;
        if FCh <> '"' then
          Break;
      end;
      GetChar;
    end;
  end
  else if AAllowQuote and (FCh = '''') then begin
    iQuoted := 2;
    GetChar;
    while not ADInSet(FCh, [#0, #13, #10]) do begin
      if FCh = '''' then begin
        GetChar;
        if FCh <> '''' then
          Break;
      end;
      GetChar;
    end;
  end
  else begin
    ucCS := UpperCase(ScriptOptions.ActualCommandSeparator);
    iQuoted := 0;
    iSep := 1;
    while not ADInSet(FCh, ASet) do begin
      if ARequired then
        GetChar;
      if not AIgnoreSep then begin
        if UpperCh(FCh) = ucCS[iSep] then
          Inc(iSep)
        else
          iSep := 1;
        if iSep > Length(ucCS) then begin
          iLen := Length(ucCS) + 1;
          Break;
        end;
      end;
      if not ARequired then
        GetChar;
    end;
  end;
  i2 := GetBookmark - iLen;
  if iQuoted <> 0 then begin
    Inc(i1);
    Dec(i2);
  end;
  if i2 < i1 then
    Result := ''
  else
    Result := ExtractString(i1, i2);
  if iQuoted = 1 then
    Result := StringReplace(Result, '""', '"', [rfReplaceAll])
  else if iQuoted = 2 then
    Result := StringReplace(Result, '''''', '''', [rfReplaceAll]);
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetUCWord: String;
begin
  Result := InternalGetString(False, False, False, False, [#0..#255] -
    ['a'..'z', 'A'..'Z', '0'..'9', '_', '$', '#']);
  Result := UpperCase(Result);
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetIdentifier: String;
begin
  Result := InternalGetString(False, True, False, False, [#0..#255] -
    ['a'..'z', 'A'..'Z', '0'..'9', '_', ':', '.', '#', '@', '$']);
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetLine: String;
begin
  Result := InternalGetString(True, True, False, False, [#13, #10, #0]);
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetString(ARequired: Boolean = False): String;
begin
  Result := InternalGetString(True, True, ARequired, False, [' ', #9, #13, #10, #0]);
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetStringInFull: String;
begin
  Result := InternalGetString(True, True, False, True, [' ', #9, #13, #10, #0]);
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetOnOfChar(ADef: Char): Integer;
var
  ucS: String;
begin
  ucS := Trim(UpperCase(GetString()));
  if ucS = 'OFF' then
    Result := -1
  else if ucS = 'ON' then
    Result := Ord(ADef)
  else begin
    if Length(ucS) <> 1 then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrStrSize1, []);
    if ADInSet(ucS[1], ['A'..'Z', '0'..'9', ' ', #9, #13, #10]) then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrStrNotAlphaNum, []);
    Result := Ord(ucS[1]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetOnOff: Integer;
var
  ucS: String;
begin
  ucS := GetUCWord;
  if ucS = 'OFF' then
    Result := -1
  else if ucS = 'ON' then
    Result := 1
  else begin
    Result := 0;
    ADException(Self, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrSetArgInvalid, []);
  end;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetNumber(ADef: Integer): Integer;
var
  ucS: String;
begin
  ucS := GetUCWord;
  if ucS = 'OFF' then
    Result := -1
  else if ucS = 'ON' then
    Result := ADef
  else
    try
      Result := StrToInt(ucS);
    except
      Result := 0;
      ADException(Self, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrSetArgInvalid, []);
    end;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.ExtractString(ABmk1, ABmk2: Integer): String;
begin
  Result := InternalExtractString(ABmk1, ABmk2);
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetEOL(AFirstCh: Char): Boolean;
begin
  Result := False;
  case ScriptOptions.FileEndOfLine of
{$IFDEF MSWINDOWS}
  elDefault,
{$ENDIF}
  elWindows:
    if AFirstCh = #13 then begin
      GetChar;
      Result := ADInSet(FCh, [#10, #0]);
      if not Result then
        UnGetChar
    end
    else if AFirstCh = #10 then
      Result := True;
{$IFDEF UNIX}
  {$IFNDEF MACOS}
  elDefault,
  {$ENDIF}
{$ENDIF}
  elUnix:
    if AFirstCh = #10 then
      Result := True;
{$IFDEF MACOS}
  elDefault,
{$ENDIF}
  elMac:
    if AFirstCh = #13 then
      Result := True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptParser.InvalidSyntax;
begin
  ADException(nil, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrInvalidSyntax,
    [FLastKwd]);
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.CreateScriptCommand(ACmdClass: TADScriptCommandClass;
  AEngine: TADScript; const AKwd: String): TADScriptCommand;
begin
  Result := ACmdClass.Create(Self, AEngine);
  try
    FLastKwd := AKwd;
    if not Result.Parse(AKwd) then
      ADFreeAndNil(Result);
  except
    ADFree(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.CreateSQLCommand(var ABeginBmk, ALastBmk, AEndBmk: Integer;
  AEngine: TADScript; var ACommand: TADScriptCommand): Boolean;
var
  lEmpty: Boolean;
  sSQL: String;
  i: Integer;
begin
  AEndBmk := ALastBmk - 2;

  // check command is empty or not
  lEmpty := (AEndBmk = -1) or (ABeginBmk >= AEndBmk);
  if not lEmpty then begin
    sSQL := ExtractString(ABeginBmk, AEndBmk);
    lEmpty := True;
    for i := 1 to Length(sSQL) do
      if sSQL[i] > ' ' then begin
        lEmpty := False;
        Break;
      end;
  end;

  // if empty command, then continue to parse
  if lEmpty then begin
    ADFreeAndNil(ACommand);
    ABeginBmk := GetBookmark;
    AEndBmk := -1;
    Result := False;
  end
  // ... otherwise exit from loop
  else begin
    if ACommand = nil then
      ACommand := FScriptCommandRegistry.DefaultSQLCommandClass.Create(Self, AEngine);
    ACommand.Parse(ExtractString(ABeginBmk, AEndBmk));
    Result := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.ExtractCommand(AEngine: TADScript): TADScriptCommand;
var
  lInComment2, lInStr, lInStr2, lInName, lCmdSep, lAlpha: Boolean;
  iInComment1, iBraceLevel, iLastBmk, iBeginBmk, iEndBmk, i: Integer;
  ucS, ucCS, s, sPgStr2Delim: String;
  oCmdClass: TADScriptCommandClass;
  rPos: TPoint;
begin
  iInComment1 := 0;
  lInComment2 := False;
  lInStr := False;
  lInStr2 := False;
  lInName := False;
  iBraceLevel := 0;
  iBeginBmk := GetBookmark;
  iEndBmk := -1;
  Result := nil;
  ucCS := ScriptOptions.ActualCommandSeparator;
  ASSERT(ucCS <> '');
  FPrep := AEngine.FPrep;
  rPos.X := 0;
  rPos.Y := 0;

  while True do begin
    FWasBeginningOfLine := FBeginningOfLine;
    GetChar;
    if (FCh <> #0) and (FLineNumber = 0) then begin
      FLineNumber := 1;
      FLineNumberPos := FText.Position - 1;
    end;
    if AEngine.Finished then begin
      ADFreeAndNil(Result);
      Exit;
    end;
    if (FCh > ' ') and (rPos.X = 0) and (rPos.Y = 0) then begin
      rPos := Position;
      Dec(rPos.X);
    end;
    iLastBmk := GetBookmark;
    case FCh of
    '(':
      if (iInComment1 = 0) and not lInComment2 and not lInStr and not lInStr2 and not lInName then begin
        Inc(iBraceLevel);
        Continue;
      end;
    ')':
      if (iInComment1 = 0) and not lInComment2 and not lInStr and not lInStr2 and not lInName then begin
        Dec(iBraceLevel);
        Continue;
      end;
    '/':
      if (iInComment1 = 0) and not lInComment2 and not lInStr and not lInStr2 and not lInName then begin
        GetChar;
        if FCh = '*' then begin
          Inc(iInComment1);
          Continue;
        end
        else if (ucCS = '/') or (ucCS = ';') then begin
          SetBookmark(iLastBmk);
          // if SQL or PL/SQL command, then extract it
          if FWasBeginningOfLine and
             CreateSQLCommand(iBeginBmk, iLastBmk, iEndBmk, AEngine, Result) then
            Break;
        end
        else if (Length(ucCS) > 1) and (ucCS[1] = '/') then
          // protection for // separator or similar
          SetBookmark(iLastBmk);
      end;
    #0:
      begin
        if ((Result = nil) or (Result.ClassType = FScriptCommandRegistry.DefaultSQLCommandClass) or
                              (Result.ClassType = FScriptCommandRegistry.DefaultPLSQLCommandClass)) then
          // if SQL or PL/SQL command, then extract it
          CreateSQLCommand(iBeginBmk, iLastBmk, iEndBmk, AEngine, Result);
        Break;
      end;
    '*':
      begin
        GetChar;
        if not lInComment2 and not lInStr and not lInStr2 and not lInName and (FCh = '/') then begin
          if iInComment1 > 0 then
            Dec(iInComment1);
          Continue;
        end
        else
          SetBookmark(iLastBmk);
      end;
    '-':
      begin
        GetChar;
        if (iInComment1 = 0) and not lInStr and not lInStr2 and not lInName and (FCh = '-') then begin
          lInComment2 := True;
          Continue;
        end
        else
          SetBookmark(iLastBmk);
      end;
    '''':
      if (iInComment1 = 0) and not lInComment2 and not lInName and not lInStr2 then begin
        lInStr := not lInStr;
        Continue;
      end;
    '"':
      if (iInComment1 = 0) and not lInComment2 and not lInStr and not lInStr2 then begin
        lInName := not lInName;
        Continue;
      end;
    '$':
      if (iInComment1 = 0) and not lInComment2 and not lInName and not lInStr and
         (AEngine.GetRDBMSKind = mkPostgreSQL) then begin
        GetChar;
        if not ADInSet(FCh, ['0' .. '9']) then begin
          s := InternalGetString(False, False, False, True, ['$']);
          if not lInStr2 then begin
            sPgStr2Delim := s;
            lInStr2 := True;
            Continue;
          end
          else if s = sPgStr2Delim then begin
            sPgStr2Delim := '';
            lInStr2 := False;
            Continue;
          end;
        end;
      end;
    #13, #10:
      if GetEOL(FCh) then begin
        Inc(FLineNumber);
        FLineNumberPos := FText.Position;
        if (iInComment1 = 0) and lInComment2 then
          lInComment2 := False;
        Continue;
      end;
    '\':
      if (iInComment1 = 0) and not lInComment2 and lInStr and
         // only MySQL and SQL Anywhere support C-style escape sequences
         // in string literals
         (AEngine.GetRDBMSKind in [mkMySQL, mkASA]) then begin
        GetChar;
        Continue;
      end;
    end;

    if (iInComment1 = 0) and not lInComment2 and not lInStr and not lInStr2 and not lInName and (iBraceLevel = 0) then begin

      // check for command separator:
      // 1) first char the same and
      // 2) either non alpha, either it is at start of line
      lCmdSep := False;
      if ((FCh = ucCS[1]) or ADInSet(FCh, ['a' .. 'z']) and (Chr(Ord(FCh) - 32) = ucCS[1])) and
         (not ADInSet(ucCS[1], ['A'..'Z', '0'..'9', '_']) or FWasBeginningOfLine) and (
            (Result = nil) or (ucCS <> ';') or
            (Result.ClassType <> FScriptCommandRegistry.DefaultPLSQLCommandClass) or
            (AEngine.GetRDBMSKind = mkPostgreSQL)) then begin
        lCmdSep := True;
        for i := 1 to Length(ucCS) do begin
          if ucCS[i] <> UpperCh(FCh) then begin
            lCmdSep := False;
            Break;
          end;
          GetChar;
        end;
        // if alpha-numeric separator, then it must end by spaces
        if ADInSet(ucCS[1], ['A'..'Z', '0'..'9', '_']) and not ADInSet(FCh, [' ', #9, #13, #10, #0]) then
          lCmdSep := False;
        // if SQL or PL/SQL command, then extract it
        if lCmdSep then begin
          if FCh <> #0 then
            UnGetChar;
          if CreateSQLCommand(iBeginBmk, iLastBmk, iEndBmk, AEngine, Result) then
            Break
        end
        else
          SetBookmark(iLastBmk);
      end;

      // check for non SQL command
      ucS := '';
      if not lCmdSep and (Result = nil) then begin
        lAlpha := ADInSet(FCh, ['A' .. 'Z', 'a' .. 'z']);
        while True do begin
          ucS := ucS + UpperCh(FCh);
          case FScriptCommandRegistry.LookupCommand(ucS, oCmdClass) of
          ucNone:
            begin
              if Length(ucS) > 1 then
                SetBookmark(iLastBmk);
              ucS := '';
              Break;
            end;
          ucPartial:
            GetChar;
          ucShort,
          ucExact:
            begin
              GetChar;
              if not lAlpha or
                 not ADInSet(FCh, ['A'..'Z', 'a'..'z', '0'..'9', '_', '$', '#', '-']) then begin
                Result := CreateScriptCommand(oCmdClass, AEngine, ucS);
                if Result = nil then
                  UnGetChar;
                Break;
              end;
            end;
          end;
        end;
        if Result <> nil then
          Break;
      end;

      // check for SQL programming language command
      if not lCmdSep and (Result = nil) and ((ucS <> '') or ADInSet(FCh, ['A'..'Z', 'a'..'z'])) then begin
        if ucS = '' then
          ucS := GetUCWord
        else
          GetChar;
        if (AEngine.GetRDBMSKind = mkOracle) and ((ucS = 'BEGIN') or (ucS = 'DECLARE')) then
          Result := FScriptCommandRegistry.DefaultPLSQLCommandClass.Create(Self, AEngine)
        else if (AEngine.GetRDBMSKind = mkInterbase) and (ucS = 'EXECUTE') then begin
          SkipWSLF;
          ucS := GetUCWord;
          if ucS = 'BLOCK' then
            Result := FScriptCommandRegistry.DefaultPLSQLCommandClass.Create(Self, AEngine);
        end
        else if not (AEngine.GetRDBMSKind in [mkMSSQL, mkASA]) and
                    ((ucS = 'CREATE') or (ucS = 'RECREATE')) then begin
          SkipWSLF;
          ucS := GetUCWord;
          if (AEngine.GetRDBMSKind = mkInterbase) and (ucS = 'DATABASE') then begin
            FScriptCommandRegistry.LookupCommand('CREATE DATABASE', oCmdClass);
            if oCmdClass <> nil then
              Result := oCmdClass.Create(Self, AEngine)
            else
              Result := FScriptCommandRegistry.DefaultSQLCommandClass.Create(Self, AEngine);
          end
          else begin
            if ucS = 'OR' then begin
              SkipWSLF;
              ucS := GetUCWord;
              if (ucS = 'REPLACE') or (ucS = 'ALTER') then begin
                SkipWSLF;
                ucS := GetUCWord;
              end;
            end;
            if (ucS = 'PROCEDURE') or (ucS = 'FUNCTION') or (ucS = 'PACKAGE') or
               (ucS = 'TYPE') or (ucS = 'TRIGGER') or (ucS = 'VARIABLE') then
              Result := FScriptCommandRegistry.DefaultPLSQLCommandClass.Create(Self, AEngine);
          end;
        end
        else
          Result := FScriptCommandRegistry.DefaultSQLCommandClass.Create(Self, AEngine);
        if not ADInSet(FCh, [' ', #9, #0]) then
          UnGetChar;
      end;
    end;
  end;

  // assign command position
  if Result <> nil then
    Result.FPosition := rPos;

  // if echo is on, then output command
  if (AEngine.Status <> ssValidating) and (
      (ScriptOptions.EchoCommands = ecAll) or
      (ScriptOptions.EchoCommands = ecSQL) and (Result <> nil) and
      ((Result.ClassType = FScriptCommandRegistry.DefaultSQLCommandClass) or
       (Result.ClassType = FScriptCommandRegistry.DefaultPLSQLCommandClass))) then begin
    s := ExtractString(iBeginBmk, GetBookmark);
    if (ScriptOptions.EchoCommandTrim > 0) and (Length(s) > ScriptOptions.EchoCommandTrim) then
      s := Copy(s, 1, ScriptOptions.EchoCommandTrim) + ' ...';
    AEngine.ConPut(s, soEcho);
  end;

  // skip stream to the next line
  GetChar;
  SkipWS;
  if ADInSet(FCh, [#13, #10]) and GetEOL(FCh) then begin
    Inc(FLineNumber);
    FLineNumberPos := FText.Position;
  end
  else if FCh <> #0 then
    UnGetChar;
end;

{-------------------------------------------------------------------------------}
function TADScriptParser.GetPosition: TPoint;
begin
  if FLineNumber > 0 then
    Result := Point(Integer(FText.Position - FLineNumberPos), FLineNumber - 1)
  else
    Result := Point(0, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADScriptParser.SetPosition(const AValue: TPoint);
var
  i: Integer;
  p: TPoint;
begin
  p := Position;
  if (p.X = AValue.X) and (p.Y = AValue.Y) then
    Exit;
  FText.Position := 0;
  FLineNumber := 0;
  FLineNumberPos := 0;
  FBeginningOfLine := False;
  if AValue.Y >= 0 then begin
    i := 0;
    while i < AValue.Y do begin
      GetChar;
      if FCh = #0 then
        Break
      else begin
        if FLineNumber = 0 then begin
          FLineNumber := 1;
          FLineNumberPos := FText.Position - 1;
        end;
        if ADInSet(FCh, [#13, #10]) and GetEOL(FCh) then begin
          Inc(FLineNumber);
          FLineNumberPos := FText.Position;
          Inc(i);
        end;
      end;
    end;
    i := 0;
    while i < AValue.X do begin
      GetChar;
      if FCh = #0 then
        Break
      else begin
        if FLineNumber = 0 then begin
          FLineNumber := 1;
          FLineNumberPos := FText.Position - 1;
        end;
        if ADInSet(FCh, [#13, #10]) then begin
          UnGetChar;
          Break;
        end;
      end;
      Inc(i);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADScriptOptions                                                              }
{-------------------------------------------------------------------------------}
constructor TADScriptOptions.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  Reset;
end;

{-------------------------------------------------------------------------------}
function TADScriptOptions.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptOptions.Reset;
begin
  FCommitEachNCommands := 0;
  FAutoPrintParams := False;
  FEchoCommands := ecSQL;
  FEchoCommandTrim := 50;
  FFeedbackCommands := True;
  FFeedbackScript := True;
  FColumnHeadings := True;
  FMaxBytesToPrintLongs := 80;
  FConsoleOutput := True;
  FSpoolOutput := smNone;
  FTiming := True;
  FBreakOnError := False;
  FIgnoreError := False;
  FDropNonexistObj := True;
  FCommandSeparator := '';
  FParamArraySize := 1;
  FPageSize := 24;
  FDefaultScriptPath := '';
  FMacroExpand := True;
  FTrimConsole := False;
  FTrimSpool := True;
  FVerify := False;
  FDefaultDataPath := '';
  FLineSize := 0;
  FFileEncoding := ecANSI;
  FFileEndOfLine := elDefault;
  FDriverID := '';
  FClientLib := '';
  FCharacterSet := '';
  FSQLDialect := 0;
  FRaisePLSQLErrors := False;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptOptions.Assign(Source: TPersistent);
begin
  if Source is TADScriptOptions then begin
    FCommitEachNCommands := TADScriptOptions(Source).FCommitEachNCommands;
    FAutoPrintParams := TADScriptOptions(Source).FAutoPrintParams;
    FEchoCommands := TADScriptOptions(Source).FEchoCommands;
    FFeedbackCommands := TADScriptOptions(Source).FFeedbackCommands;
    FFeedbackScript := TADScriptOptions(Source).FFeedbackScript;
    FColumnHeadings := TADScriptOptions(Source).FColumnHeadings;
    FMaxBytesToPrintLongs := TADScriptOptions(Source).FMaxBytesToPrintLongs;
    FConsoleOutput := TADScriptOptions(Source).FConsoleOutput;
    FSpoolOutput := TADScriptOptions(Source).FSpoolOutput;
    FSpoolFileName := TADScriptOptions(Source).FSpoolFileName;
    FTiming := TADScriptOptions(Source).FTiming;
    FBreakOnError := TADScriptOptions(Source).FBreakOnError;
    FIgnoreError := TADScriptOptions(Source).FIgnoreError;
    FDropNonexistObj := TADScriptOptions(Source).FDropNonexistObj;
    FCommandSeparator := TADScriptOptions(Source).FCommandSeparator;
    FActualCommandSeparator := TADScriptOptions(Source).FActualCommandSeparator;
    FParamArraySize := TADScriptOptions(Source).FParamArraySize;
    FPageSize := TADScriptOptions(Source).FPageSize;
    FEchoCommandTrim := TADScriptOptions(Source).FEchoCommandTrim;
    FDefaultScriptPath := TADScriptOptions(Source).FDefaultScriptPath;
    FMacroExpand := TADScriptOptions(Source).FMacroExpand;
    FTrimConsole := TADScriptOptions(Source).FTrimConsole;
    FTrimSpool := TADScriptOptions(Source).FTrimSpool;
    FVerify := TADScriptOptions(Source).FVerify;
    FDefaultDataPath := TADScriptOptions(Source).FDefaultDataPath;
    FLineSize := TADScriptOptions(Source).FLineSize;
    FFileEncoding := TADScriptOptions(Source).FFileEncoding;
    FFileEndOfLine := TADScriptOptions(Source).FFileEndOfLine;
    FDriverID := TADScriptOptions(Source).FDriverID;
    FClientLib := TADScriptOptions(Source).FClientLib;
    FCharacterSet := TADScriptOptions(Source).FCharacterSet;
    FSQLDialect := TADScriptOptions(Source).FSQLDialect;
    FRaisePLSQLErrors := TADScriptOptions(Source).FRaisePLSQLErrors;
  end
  else
    inherited Assign(Source);
end;

{-------------------------------------------------------------------------------}
procedure TADScriptOptions.SetCommandSeparator(const AValue: String);
begin
  if FCommandSeparator <> AValue then begin
    FCommandSeparator := AValue;
    FActualCommandSeparator := UpperCase(Trim(AValue));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScriptOptions.SetDriverID(const AValue: String);
begin
  if FDriverID <> AValue then begin
    FDriverID := AValue;
    if (FOwner <> nil) and (FOwner is TADScript) then
      TADScript(FOwner).FRDBMSKind := mkUnknown;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADSQLScript                                                                  }
{-------------------------------------------------------------------------------}
constructor TADSQLScript.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FSQL := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADSQLScript.Destroy;
begin
  ADFreeAndNil(FSQL);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADSQLScript.GetDisplayName: string;
begin
  if FName <> '' then
    Result := FName
  else
    Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLScript.Assign(ASource: TPersistent);
begin
  if ASource is TADSQLScript then begin
    FName := TADSQLScript(ASource).Name;
    FSQL.Assign(TADSQLScript(ASource).SQL);
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLScript.SetSQL(const AValue: TStrings);
begin
  FSQL.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
{ TADSQLScripts                                                                 }
{-------------------------------------------------------------------------------}
constructor TADSQLScripts.Create(AScript: TADScript);
begin
  inherited Create(AScript, TADSQLScript);
end;

{-------------------------------------------------------------------------------}
function TADSQLScripts.GetItems(AIndex: Integer): TADSQLScript;
begin
  Result := TADSQLScript(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLScripts.SetItems(AIndex: Integer;
  const AValue: TADSQLScript);
begin
  inherited Items[AIndex] := AValue;
end;

{-------------------------------------------------------------------------------}
function TADSQLScripts.Add: TADSQLScript;
begin
  Result := TADSQLScript(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TADSQLScripts.FindScript(const AName: String): TADSQLScript;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].Name, AName) = 0 then begin
      Result := Items[i];
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADScript                                                                     }
{-------------------------------------------------------------------------------}
constructor TADScript.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCallStack := TADStringList.Create;
  FScriptOptions := TADScriptOptions.Create(Self);
  FTable := TADDatSTable.Create;
  FParams := TADParams.CreateRefCounted(GetParamsOwner);
  FMacros := TADMacros.CreateRefCounted(GetParamsOwner);
  FArguments := TADStringList.Create;
  FAllSpools := TADStringList.Create;
  FPrep := TADPhysPreprocessor.Create;
  FPrep.MacrosRead := FMacros;
  FPrep.Instrs := [piExpandMacros];
  FSQLScripts := TADSQLScripts.Create(Self);
  FOptionsIntf := TADOptionsContainer.Create(Self, TADFetchOptions,
    TADBottomUpdateOptions, TADBottomResourceOptions, GetParentOptions);
  FLock := TCriticalSection.Create;
  ADScriptCommandRegistry();
  if ADIsDesigning(Self) then
    Connection := ADFindDefaultConnection(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADScript.Destroy;
begin
  CloseSpool;
  Connection := nil;
  FOptionsIntf := nil;
  ADFreeAndNil(FSQLScripts);
  ADFreeAndNil(FCallStack);
  ADFreeAndNil(FScriptOptions);
  FParams.RemRef;
  FParams := nil;
  FMacros.RemRef;
  FMacros := nil;
  ADFreeAndNil(FArguments);
  ADFreeAndNil(FTable);
  ADFreeAndNil(FAllSpools);
  ADFreeAndNil(FPrep);
  ADFreeAndNil(FLock);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetParamsOwner: TPersistent;
begin
  Result := Self;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if AOperation = opRemove then
    if FScriptDialog = AComponent then
      ScriptDialog := nil
    else if FConnection = AComponent then
      Connection := nil
    else if FTransaction = AComponent then
      Transaction := nil;
end;

{-------------------------------------------------------------------------------}
// IADStanObject
function TADScript.GetName: TComponentName;
begin
  if Name = '' then
    Result := '$' + IntToHex(Integer(Self), 8)
  else
    Result := Name;
  Result := Result + ': ' + ClassName;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetParent: IADStanObject;
begin
  if FConnection = nil then
    Result := nil
  else
    Result := FConnection as IADStanObject;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADScript.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
// IADStanOptions
procedure TADScript.GetParentOptions(out AOpts: IADStanOptions);
begin
  if FConnection <> nil then
    AOpts := FConnection.OptionsIntf;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetFetchOptions: TADFetchOptions;
begin
  Result := OptionsIntf.FetchOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetFetchOptions(const Value: TADFetchOptions);
begin
  OptionsIntf.FetchOptions.Assign(Value);
end;

{-------------------------------------------------------------------------------}
function TADScript.GetFormatOptions: TADFormatOptions;
begin
  Result := OptionsIntf.FormatOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetFormatOptions(const Value: TADFormatOptions);
begin
  OptionsIntf.FormatOptions.Assign(Value);
end;

{-------------------------------------------------------------------------------}
function TADScript.GetResourceOptions: TADResourceOptions;
begin
  Result := OptionsIntf.ResourceOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetResourceOptions(const Value: TADResourceOptions);
begin
  OptionsIntf.ResourceOptions.Assign(Value);
end;

{-------------------------------------------------------------------------------}
// IADStanErrorHandler
procedure TADScript.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
var
  oInit: IADStanObject;
begin
  if AInitiator = nil then
    oInit := Self as IADStanObject
  else
    oInit := AInitiator;
  if Assigned(FOnError) then
    FOnError(Self, oInit, AException)
  else if Connection <> nil then
    (Connection as IADStanErrorHandler).HandleException(oInit, AException);
end;

{-------------------------------------------------------------------------------}
// etc

{$IFNDEF AnyDAC_FPC}
type
  __TADCustomConnection = class(TADCustomConnection)
  end;
{$ENDIF}

procedure TADScript.SetConnection(const AValue: TADCustomConnection);
begin
{$IFNDEF AnyDAC_FPC}
  if FConnection <> nil then
    __TADCustomConnection(FConnection).UnRegisterClient(Self);
{$ENDIF}
  InternalReleaseConnection;
  FConnection := AValue;
  if FConnection <> nil then begin
{$IFNDEF AnyDAC_FPC}
    __TADCustomConnection(FConnection).RegisterClient(Self, DoConnectChanged);
{$ENDIF}
    FConnection.FreeNotification(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetTransaction(const AValue: TADCustomTransaction);
begin
  FTransaction := AValue;
  if FTransaction <> nil then
    FTransaction.FreeNotification(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.DoConnectChanged(Sender: TObject; Connecting: Boolean);
begin
  if not Connecting then
    InternalReleaseConnection;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetSQLScripts(const AValue: TADSQLScripts);
begin
  FSQLScripts.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetScriptOptions(const AValue: TADScriptOptions);
begin
  FScriptOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetArguments(const AValue: TStrings);
begin
  FArguments.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetParams(const AValue: TADParams);
begin
  FParams.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetMacros(const AValue: TADMacros);
begin
  FMacros.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetScriptDialog(const AValue: TADGUIxScriptDialog);
begin
  if FScriptDialog <> nil then
    FScriptDialog.RemoveFreeNotification(Self);
  FScriptDialog := AValue;
  if FScriptDialog <> nil then
    FScriptDialog.FreeNotification(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ConGet(const APrompt: String;
  var AResult: String);
var
  oDlg: IADGUIxScriptDialog;
begin
  if Assigned(FOnConsoleGet) then
    FOnConsoleGet(Self, APrompt, AResult)
  else if GetScriptDialogIntf(oDlg) then
    oDlg.Input(APrompt, AResult);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ConPause(const APrompt: String);
var
  oDlg: IADGUIxScriptDialog;
begin
  if Assigned(FOnPause) then
    FOnPause(Self, APrompt)
  else if GetScriptDialogIntf(oDlg) then
    oDlg.Pause(APrompt);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ConPut(const AMsg: String; AKind: TADScriptOuputKind);
var
  sCon: String;
  sSpool: String;
  oDlg: IADGUIxScriptDialog;
begin
  if ScriptOptions.ConsoleOutput then begin
    if ScriptOptions.TrimConsole then
      sCon := TrimRight(AMsg)
    else
      sCon := AMsg;
    if Assigned(FOnConsolePut) then
      FOnConsolePut(Self, sCon, AKind);
    if GetScriptDialogIntf(oDlg) then
      oDlg.Output(sCon, AKind);
  end;
  if ScriptOptions.SpoolOutput <> smNone then begin
    if ScriptOptions.TrimSpool then
      sSpool := TrimRight(AMsg)
    else
      sSpool := AMsg;
    if Assigned(FOnSpoolPut) then
      FOnSpoolPut(Self, sSpool, AKind);
    if FSpool <> nil then
      FSpool.WriteLine(sSpool);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ConLockUpdate;
begin
  if ScriptOptions.ConsoleOutput then
    if Assigned(FOnConsoleLockUpdate) then
      FOnConsoleLockUpdate(Self, True);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ConUnlockUpdate;
begin
  if ScriptOptions.ConsoleOutput then
    if Assigned(FOnConsoleLockUpdate) then
      FOnConsoleLockUpdate(Self, False);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.GetText(const AFileName: String; AMode: TADScriptTextMode;
  out AText: TADTextFile);
var
  s: String;
  oSQL: TADSQLScript;
begin
  AText := nil;
  if Assigned(FOnGetText) then
    FOnGetText(Self, AFileName, AMode, AText);
  if AText = nil then begin
    s := ADExpandStr(AFileName);
    oSQL := SQLScripts.FindScript(s);
    if oSQL <> nil then
      AText := TADTextFile.Create(TStringStream.Create(oSQL.SQL.Text
        {$IFDEF AnyDAC_Unicode}, TEncoding.Unicode {$ENDIF}), True, True, False,
        {$IFDEF AnyDAC_Unicode} ecUTF16 {$ELSE} ecANSI {$ENDIF}, elWindows)
    else if AMode in [smWriteReset, smWriteAppend] then begin
      if ExtractFileExt(s) = '' then
        s := s + '.log';
      AText := TADTextFile.Create(s, False, AMode = smWriteAppend,
        ScriptOptions.FileEncoding, ScriptOptions.FileEndOfLine);
    end
    else begin
      if not FileExists(s) and (ExtractFileExt(s) = '') then
        s := s + '.sql';
      if (ExtractFilePath(s) = '') and (ScriptOptions.DefaultScriptPath <> '') then
        s := ADNormPath(ScriptOptions.DefaultScriptPath) + s;
      AText := TADTextFile.Create(s, True, False,
        ScriptOptions.FileEncoding, ScriptOptions.FileEndOfLine);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ReleaseText(const AFileName: String; AMode: TADScriptTextMode;
  var AText: TADTextFile);
var
  s: String;
  oSQL: TADSQLScript;
begin
  if AText = nil then
    Exit;
  if AMode in [smWriteReset, smWriteAppend] then begin
    s := ADExpandStr(AFileName);
    oSQL := SQLScripts.FindScript(s);
    if oSQL <> nil then begin
      AText.Position := 0;
      oSQL.SQL.LoadFromStream(AText.Stream {$IFDEF AnyDAC_Unicode}, TEncoding.Unicode {$ENDIF});
    end;
  end;
  if Assigned(FOnReleaseText) then
    FOnReleaseText(Self, AFileName, AMode, AText);
  if AText <> nil then
    ADFreeAndNil(AText);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ExecuteHostCommand(const ACommand: String);
var
  lDefault: Boolean;
begin
  if Assigned(FOnHostCommand) then begin
    lDefault := False;
    FOnHostCommand(Self, ACommand, lDefault);
  end
  else
    lDefault := True;
  if lDefault then
    ADShell(ACommand, S_AD_LComp_PScr);
end;

{-------------------------------------------------------------------------------}
function TADScript.GetCallStack: TStrings;
var
  oCmd: TADScriptCommand;
begin
  FCallStack.Clear;
  FLock.Enter;
  try
    oCmd := FCurrentCommand;
    while oCmd <> nil do begin
      FCallStack.Insert(0, Format('%s (line %d)',
        [oCmd.Parser.FileName, oCmd.Parser.LineNumber]));
      oCmd := oCmd.Parser.ParentCommand;
    end;
  finally
    FLock.Leave;
  end;
  Result := FCallStack;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetScriptDialogIntf(out AIntf: IADGUIxScriptDialog): Boolean;
begin
  Result := FScriptDialogVisible and (FScriptDialog <> nil);
  if Result then
    AIntf := FScriptDialog as IADGUIxScriptDialog;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetTotalErrors: Integer;
begin
  Result := FTotalErrors;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetTotalJobDone: Integer;
begin
  Result := FTotalJobDone;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetTotalJobSize: Integer;
begin
  Result := FTotalJobSize;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetTotalPct10Done: Integer;
begin
  Result := FTotalPct10Done;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetIsRunning: Boolean;
begin
  Result := FStatus in [ssValidating, ssRunning];
end;

{-------------------------------------------------------------------------------}
procedure TADScript.RequestStop;
begin
  AbortJob();
end;

{-------------------------------------------------------------------------------}
procedure TADScript.SetCurrentCommand(const ACommand: TADScriptCommand);
var
  iPct10Done: Integer;
begin
  FLock.Enter;
  try
    if (ACommand <> nil) and (ACommand.Parser <> nil) then
      FTotalJobDone := ACommand.Parser.TotalSize
    else if (FCurrentCommand <> nil) and (FCurrentCommand.Parser <> nil) then
      FTotalJobDone := FCurrentCommand.Parser.TotalSize;
    FCurrentCommand := ACommand;
  finally
    FLock.Leave;
  end;
  if FTotalJobSize = 0 then begin
    if ACommand <> nil then begin
      Inc(FTotalPct10Done);
      Progress;
      if FTotalPct10Done >= 1000 then
        FTotalPct10Done := 0;
    end;
  end
  else begin
    iPct10Done := Integer((Int64(FTotalJobDone) * Int64(1000)) div Int64(FTotalJobSize));
    if FTotalPct10Done <> iPct10Done then begin
      FTotalPct10Done := iPct10Done;
      Progress;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.UpdateCommandSeparator;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  if ScriptOptions.CommandSeparator = '' then
    if FConnectionIntf <> nil then begin
      FConnectionIntf.CreateMetadata(oConnMeta);
      ScriptOptions.FActualCommandSeparator := UpperCase(Trim(oConnMeta.CommandSeparator));
    end
    else
      ScriptOptions.FActualCommandSeparator := ';';
end;

{-------------------------------------------------------------------------------}
{$HINTS OFF}
function TADScript.SetupArguments: TStrings;
var
  i, iName, iCode: Integer;
  oMac: TADMacro;
begin
  Result := TADStringList.Create;
  i := 0;
  while i <= Macros.Count - 1 do begin
    Val(Macros[i].Name, iName, iCode);
    if iCode = 0 then begin
      Result.Add(Macros[i].Name + '=' + Macros[i].AsRaw);
      Macros[i].Free;
    end
    else
      Inc(i);
  end;
  for i := 0 to Arguments.Count - 1 do begin
    oMac := Macros.Add;
    oMac.Name := IntToStr(i + 1);
    oMac.AsRaw := Arguments[i];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.RestoreArguments(AArgs: TStrings);
var
  i, iName, iCode: Integer;
  oMac: TADMacro;
begin
  i := 0;
  while i <= Macros.Count - 1 do begin
    Val(Macros[i].Name, iName, iCode);
    if iCode = 0 then
      Macros[i].Free
    else
      Inc(i);
  end;
  for i := 0 to AArgs.Count - 1 do begin
    oMac := Macros.Add;
    oMac.Name := ADNameFromIndex(AArgs, i);
    oMac.AsRaw := ADValueFromIndex(AArgs, i);
  end;
  ADFree(AArgs);
end;
{$HINTS ON}

{-------------------------------------------------------------------------------}
function TADScript.InternalExecute(AParser: TADScriptParser;
  ARealExecute: Boolean; AAll: Boolean): Boolean;
var
  oCmd: TADScriptCommand;
  dwStartTime: DWORD;
  dwExecTime: DWORD;
  sFeedback: String;
  iStartErrors: Integer;
  iExecErrors: Integer;
  i: Integer;
  oPrevArgs: TStrings;
  oDlg: IADGUIxScriptDialog;
  oSaveOpts: TADScriptOptions;
begin
  if AAll and Assigned(FBeforeScript) then
    FBeforeScript(Self);
  if (ADScriptCommandRegistry().FCommands.Count = 0) or
     (ADScriptCommandRegistry().FDefaultSQLCommandClass = nil) or
     (ADScriptCommandRegistry().FDefaultPLSQLCommandClass = nil) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrNoCmds, []);
  oSaveOpts := nil;
  if AParser.ParentCommand = nil then begin
    Finished := False;
    if ARealExecute then
      FStatus := ssRunning
    else
      FStatus := ssValidating;
    if AAll and ARealExecute then begin
      FAllSpools.Clear;
      ProcessedAfterCommit := 0;
    end;
    FTotalJobDone := 0;
    if not ARealExecute then
      FTotalJobSize := 0;
    FTotalErrors := 0;
    if (Connection <> nil) and Connection.Connected then
      CheckCommand
    else
      UpdateCommandSeparator;
    FScriptDialogVisible := False;
    if AAll and (FScriptDialog <> nil) then begin
      oDlg := FScriptDialog as IADGUIxScriptDialog;
      oDlg.Show;
      FScriptDialogVisible := True;
    end;
    if AAll then begin
      oSaveOpts := TADScriptOptions.Create(Self);
      oSaveOpts.Assign(ScriptOptions);
    end;
  end;
  Progress;
  oPrevArgs := SetupArguments;
  if AAll and ARealExecute then
    UpdateSpool;
  if AAll and ARealExecute and ScriptOptions.FeedbackScript and (AParser.FileName <> '') then
    ConPut('Running script [' + AParser.FileName + '] ...', soScript);
  dwStartTime := ADGetTickCount();
  iStartErrors := FTotalErrors;
  try
    try
      while not Finished do begin
        oCmd := nil;
        try
          try
            oCmd := AParser.ExtractCommand(Self);
            if oCmd = nil then
              Break
            else if not Finished then
              if ARealExecute then
                oCmd.Execute()
              else
                oCmd.Validate();
          except
            on E: Exception do begin
              if not ScriptOptions.IgnoreError then begin
                Inc(FTotalErrors);
                if E is EADDBEngineException then
                  for i := 0 to EADDBEngineException(E).ErrorCount - 1 do
                    if i = 0 then
                      ConPut('ERROR: ' + EADDBEngineException(E).Errors[i].Message, soError)
                    else
                      ConPut(EADDBEngineException(E).Errors[i].Message, soError)
                else
                  ConPut('ERROR: ' + E.Message, soError);
                if ScriptOptions.BreakOnError then
                  Finished := True;
                if not AAll then
                  raise;
              end;
            end;
          end;
        finally
          ADFree(oCmd);
        end;
        if not AAll then
          Finished := True;
      end;
    except
      if FStatus in [ssRunning, ssValidating] then
        FStatus := ssFinishWithErrors;
      raise;
    end;
  finally
    if AAll and ARealExecute then
      CheckCommit(True);
    dwExecTime := ADGetTickCount() - dwStartTime;
    iExecErrors := FTotalErrors - iStartErrors;
    Result := iExecErrors = 0;
    RestoreArguments(oPrevArgs);
    if AAll and ARealExecute and ScriptOptions.FeedbackScript and (AParser.FileName <> '') then begin
      sFeedback := 'Script [' + AParser.FileName + '] finished';
      if iExecErrors = 0 then
        sFeedback := sFeedback + ' without errors'
      else if iExecErrors = 1 then
        sFeedback := sFeedback + ' with [1] error'
      else
        sFeedback := sFeedback + ' with [' + IntToStr(iExecErrors) + '] errors';
      if ScriptOptions.Timing then
        sFeedback := sFeedback + Format(' [%.2d:%.2d:%.2d.%.3d]', [
          (dwExecTime div 3600000) mod 60, (dwExecTime div 60000) mod 60,
          (dwExecTime div 1000) mod 60, dwExecTime mod 1000]);
      sFeedback := sFeedback + '.';
      ConPut(sFeedback, soScript);
      ConPut('', soSeparator);
    end;
    if AParser.ParentCommand = nil then begin
      Finished := True;
      if FStatus in [ssRunning, ssValidating] then
        if FTotalErrors = 0 then
          FStatus := ssFinishSuccess
        else
          FStatus := ssFinishWithErrors;
      if not ARealExecute then begin
        FTotalJobSize := AParser.TotalSize;
        FTotalPct10Done := 1000;
      end;
      if AAll then
        CloseSpool;
      Progress;
      if GetScriptDialogIntf(oDlg) then
        oDlg.Hide;
      if AAll then begin
        ScriptOptions.Assign(oSaveOpts);
        ADFree(oSaveOpts);
      end;
      if AAll and Assigned(FAfterScript) then
        FAfterScript(Self);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADScript.InternalExecute(ARealExecute: Boolean; AAll: Boolean): Boolean;
var
  oText: TADTextFile;
  oParser: TADScriptParser;
  oWait: IADGUIxWaitCursor;
  sName: String;
  lUsePosition: Boolean;
begin
  if Assigned(FBeforeExecute) then
    FBeforeExecute(Self);
  if not ADGUIxSilent then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
  end;
  try
    if Connection = nil then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ClntDbNotDefined, [Name]);
    FRDBMSKind := mkUnknown;
    lUsePosition := False;
    if SQLScriptFileName <> '' then begin
      sName := SQLScriptFileName;
      GetText(SQLScriptFileName, smRead, oText);
    end
    else if SQLScripts.Count > 0 then begin
      sName := SQLScripts[0].Name;
      GetText(sName, smRead, oText);
      lUsePosition := not AAll;
    end
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrNoScript, [Name]);
    try
      oParser := TADScriptParser.Create(sName, nil, oText, ScriptOptions);
      try
        if lUsePosition then
          oParser.Position := FPosition;
        Result := InternalExecute(oParser, ARealExecute, AAll);
      finally
        if lUsePosition then
          FPosition := oParser.Position;
        ADFree(oParser);
      end;
    finally
      ReleaseText(sName, smRead, oText);
    end;
  finally
    if not ADGUIxSilent then
      oWait.StopWait;
    if Assigned(FAfterExecute) then
      FAfterExecute(Self);
  end;
end;

{-------------------------------------------------------------------------------}
function TADScript.ExecuteAll: Boolean;
begin
  Result := InternalExecute(True, True);
end;

{-------------------------------------------------------------------------------}
function TADScript.ExecuteStep: Boolean;
begin
  Result := InternalExecute(True, False);
end;

{-------------------------------------------------------------------------------}
function TADScript.ValidateAll: Boolean;
begin
  Result := InternalExecute(False, True);
end;

{-------------------------------------------------------------------------------}
function TADScript.ValidateStep: Boolean;
begin
  Result := InternalExecute(False, False);
end;

{-------------------------------------------------------------------------------}
function TADScript.ExecuteAll(AParser: TADScriptParser): Boolean;
begin
  Result := InternalExecute(AParser, True, True);
end;

{-------------------------------------------------------------------------------}
function TADScript.ExecuteStep(AParser: TADScriptParser): Boolean;
begin
  Result := InternalExecute(AParser, True, False);
end;

{-------------------------------------------------------------------------------}
function TADScript.ValidateAll(AParser: TADScriptParser): Boolean;
begin
  Result := InternalExecute(AParser, False, True);
end;

{-------------------------------------------------------------------------------}
function TADScript.ValidateStep(AParser: TADScriptParser): Boolean;
begin
  Result := InternalExecute(AParser, False, False);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ExecuteFile(const AFileName: String);
begin
  SQLScripts.Clear;
  SQLScriptFileName := AFileName;
  ValidateAll;
  if Status = ssFinishSuccess then
    ExecuteAll;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ExecuteFile(const AFileName: String; const AArguments: array of String);
var
  i: Integer;
begin
  Arguments.Clear;
  for i := Low(AArguments) to High(AArguments) do
    Arguments.Add(AArguments[i]);
  ExecuteFile(AFileName);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ExecuteScript(const AScript: TStrings);
begin
  SQLScripts.Clear;
  SQLScripts.Add.SQL := AScript;
  SQLScriptFileName := '';
  ValidateAll;
  if Status = ssFinishSuccess then
    ExecuteAll;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.ExecuteScript(const AScript: TStrings; const AArguments: array of String);
var
  i: Integer;
begin
  Arguments.Clear;
  for i := Low(AArguments) to High(AArguments) do
    Arguments.Add(AArguments[i]);
  ExecuteScript(AScript);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.AbortJob(const AWait: Boolean = False);
begin
  if FStatus in [ssValidating, ssRunning] then
    FStatus := ssAborted;
  Finished := True;
  if FCommandIntf <> nil then
    FCommandIntf.AbortJob(AWait);
  if CurrentCommand <> nil then
    CurrentCommand.AbortJob(AWait);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.Progress;
var
  oDlg: IADGUIxScriptDialog;
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self);
  if GetScriptDialogIntf(oDlg) then
    oDlg.Progress(Self as IADGUIxScriptDialogInfoProvider);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.CloseSpool;
begin
  if ScriptOptions.SpoolOutput = smOnReset then
    ReleaseText(FLastSpoolFileName, smWriteReset, FSpool)
  else
    ReleaseText(FLastSpoolFileName, smWriteAppend, FSpool);
  FLastSpoolFileName := '';
end;

{-------------------------------------------------------------------------------}
procedure TADScript.UpdateSpool;
begin
  if ScriptOptions.SpoolOutput = smNone then
    CloseSpool
  else begin
    if ScriptOptions.SpoolFileName <> FLastSpoolFileName then
      CloseSpool;
    if (FSpool = nil) and (ScriptOptions.SpoolFileName <> '') then begin
      if ScriptOptions.SpoolOutput = smOnReset then
        GetText(ScriptOptions.SpoolFileName, smWriteReset, FSpool)
      else
        GetText(ScriptOptions.SpoolFileName, smWriteAppend, FSpool);
      FLastSpoolFileName := ScriptOptions.SpoolFileName;
      FAllSpools.Add(FLastSpoolFileName);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.CheckCommand;
begin
  if (FConnectionIntf = nil) or (FConnectionIntf.State <> csConnected) then
    OpenConnection('');
  if (FConnectionIntf = nil) or (FConnectionIntf.State <> csConnected) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PScr], er_AD_ScrNotLogged, []);
  ASSERT(FCommandIntf <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADScript.CheckCommit(AForce: Boolean);
begin
  if ScriptOptions.CommitEachNCommands > 0 then begin
    ProcessedAfterCommit := ProcessedAfterCommit + 1;
    if AForce or (ProcessedAfterCommit >= ScriptOptions.CommitEachNCommands) then begin
      if Transaction <> nil then
        Transaction.Commit
      else
        FConnectionIntf.Transaction.Commit;
      ProcessedAfterCommit := 0;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.CheckStartTransaction;
begin
  if (ScriptOptions.CommitEachNCommands > 0) and (ProcessedAfterCommit = 0) and
     ((Transaction <> nil) and not Transaction.Active or
      (Transaction = nil) and not FConnectionIntf.Transaction.Active) then
    if Transaction <> nil then
      Transaction.StartTransaction
    else
      FConnectionIntf.Transaction.StartTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.InternalOpenConnection(const AConnectionString: String);
var
  sConnStr: String;
  oObjIntf: IADStanObject;
  oConnMeta: IADPhysConnectionMetadata;
  oDef: IADStanDefinition;
begin
  if AConnectionString <> '' then begin
    sConnStr := AConnectionString;
    if ScriptOptions.DriverID <> '' then
      sConnStr := S_AD_ConnParam_Common_DriverID + '=' +
        ScriptOptions.DriverID + ';' + sConnStr;
    Connection.Close;
    Connection.ResultConnectionDef.Params.Clear;
    Connection.ResultConnectionDef.ParseString(sConnStr);
  end;
  if ScriptOptions.ClientLib <> '' then begin
    Connection.CheckConnectionDef;
    { TODO : This has to be reviewed, when the driver configuration API will be updated }
    oDef := ADPhysManager.DriverDefs.FindDefinition(Connection.ResultConnectionDef.DriverID);
    if oDef = nil then begin
      oDef := ADPhysManager.DriverDefs.Add;
      oDef.Name := Connection.ResultConnectionDef.DriverID;
    end;
    oDef.AsString[S_AD_DrvVendorLib] := ScriptOptions.ClientLib;
  end;
  if ScriptOptions.CharacterSet <> '' then
    Connection.ResultConnectionDef.AsString[S_AD_ConnParam_Common_CharacterSet] :=
      ScriptOptions.CharacterSet;
  if ScriptOptions.SQLDialect > 0 then
    Connection.ResultConnectionDef.AsInteger[S_AD_ConnParam_IB_SQLDialect] :=
      ScriptOptions.SQLDialect;
  Connection.Open;
  FConnectionIntf := FConnection.ConnectionIntf;
  FConnectionIntf.CreateCommand(FCommandIntf);
  if Transaction <> nil then
    FCommandIntf.Transaction := Transaction.TransactionIntf;
  FCommandIntf.ErrorHandler := Self as IADStanErrorHandler;
  FCommandIntf.Options := Self as IADStanOptions;
  FCommandIntf.Macros := FMacros;
  FConnectionIntf.CreateMetadata(oConnMeta);
  FPrep.ConnMetadata := oConnMeta;
  if Supports(FCommandIntf, IADStanObject, oObjIntf) then begin
    oObjIntf.SetOwner(Self, '');
    oObjIntf := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.OpenConnection(const AConnectionString: String);
const
  C_UROWID = '_ora_UROWID';
var
  oURIMac: TADMacro;
  oCmd: IADPhysCommand;
begin
  InternalOpenConnection(AConnectionString);
  // This is needed for FireDAC QA scripts. Depending on Oracle version
  // in CREATE TABLE will be used either UROWID data type, either ROWID.
  if GetRDBMSKind = mkOracle then begin
    oURIMac := Macros.FindMacro(C_UROWID);
    if oURIMac = nil then begin
      oURIMac := Macros.Add;
      oURIMac.Name := C_UROWID;
    end;
    try
      FConnectionIntf.CreateCommand(oCmd);
      if Transaction <> nil then
        oCmd.Transaction := Transaction.TransactionIntf;
      oCmd.Prepare('declare r urowid; begin null; end;');
      oCmd.Execute;
      oURIMac.AsRaw := 'UROWID'
    except
      oURIMac.AsRaw := 'ROWID';
    end;
  end;
  UpdateCommandSeparator;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.InternalReleaseConnection;
begin
  if FCommandIntf <> nil then begin
    FCommandIntf.AbortJob(False);
    FCommandIntf.Disconnect;
    FCommandIntf.ErrorHandler := nil;
    FCommandIntf.Options := nil;
    FCommandIntf.Params := nil;
    FCommandIntf.Macros := nil;
    FCommandIntf := nil;
  end;
  if FPrep <> nil then
    FPrep.ConnMetadata := nil;
  FConnectionIntf := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.CloseConnection;
begin
  InternalReleaseConnection;
  FConnection.Close;
end;

{-------------------------------------------------------------------------------}
procedure TADScript.Disconnect(AAbortJob: Boolean = False);
begin
  if AAbortJob then
    AbortJob(True);
  InternalReleaseConnection;
end;

{-------------------------------------------------------------------------------}
function TADScript.ExpandString(const AValue: String): String;
{$IFNDEF AnyDAC_D6Base}
var
  pDest: PChar;
{$ENDIF}
begin
  if ScriptOptions.MacroExpand then begin
    FPrep.Source := AnsiQuotedStr(AValue, '''');
    FPrep.Init;
    FPrep.Execute;
{$IFDEF AnyDAC_D6Base}
    Result := AnsiDequotedStr(FPrep.Destination, '''');
{$ELSE}
    pDest := PChar(FPrep.Destination);
    Result := AnsiExtractQuotedStr(pDest, '''');
{$ENDIF}
  end
  else
    Result := AValue;
  Result := ADExpandStr(Result);
end;

{-------------------------------------------------------------------------------}
function TADScript.GetRDBMSKind: TADRDBMSKind;
begin
  if FRDBMSKind = mkUnknown then begin
    if (ScriptOptions.DriverID <> '') and ((Connection = nil) or not Connection.Connected) then
      FRDBMSKind := ADManager.GetRDBMSKind(ScriptOptions.DriverID)
    else if Connection <> nil then
      FRDBMSKind := Connection.RDBMSKind;
  end;
  Result := FRDBMSKind;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetTable: TADDatSTable;
begin
  Result := FTable;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetCommandIntf: IADPhysCommand;
begin
  Result := FCommandIntf;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetConnectionIntf: IADPhysConnection;
begin
  Result := FConnectionIntf;
end;

{-------------------------------------------------------------------------------}
function TADScript.GetEof: Boolean;
begin
  Result := (SQLScripts.Count = 0) or
    (FPosition.Y > SQLScripts[0].SQL.Count - 1) or
    (FPosition.Y = SQLScripts[0].SQL.Count - 1) and
      (FPosition.X >= Length(SQLScripts[0].SQL[FPosition.Y]));
end;

{-------------------------------------------------------------------------------}
function TADScript.GetIsEmpty: Boolean;
begin
  Result := (SQLScripts.Count = 0) or (SQLScripts[0].SQL.Count = 0);
end;

{-------------------------------------------------------------------------------}
initialization

finalization
  ADFreeAndNil(FScriptCommandRegistry);

end.
