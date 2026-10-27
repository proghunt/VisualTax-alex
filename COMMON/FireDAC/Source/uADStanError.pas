{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{            FireDAC error handling support             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADStanError;

interface

uses
  Classes, DB, SysUtils,
  uADStanIntf, uADStanStorage;

type
  EADException = class;
  TADDBError = class;
  EADDBEngineException = class;
  EADDBArrayExecuteError = class;
  EADExceptionClass = class of EADException;
  TADDBErrorClass = class of TADDBError;
  EADDBEngineExceptionClass = class of EADDBEngineException;

  EADException = class(EDatabaseError)
  private
    FADCode: Integer;
    FADObjName: String;
  protected
    procedure SetADObjectName(const AValue: IADStanObject);
    procedure LoadFromStorage(AStorage: TADStorage); virtual;
    procedure SaveToStorage(AStorage: TADStorage); virtual;
  public
    constructor Create; overload; virtual;
    constructor Create(AADCode: Integer; const AMessage: String); overload;
    procedure Duplicate(var AValue: EADException); virtual;
    property ADCode: Integer read FADCode write FADCode;
    property ADObjName: String read FADObjName write FADObjName;
  end;

  TADCommandExceptionKind = (ekOther, ekNoDataFound, ekTooManyRows,
    ekRecordLocked, ekUKViolated, ekFKViolated, ekObjNotExists,
    ekUserPwdInvalid, ekUserPwdExpired, ekUserPwdWillExpire, ekCmdAborted,
    ekServerGone, ekServerOutput, ekArrExecMalfunc, ekInvalidParams);

  TADDBError = class(TObject)
  private
    FMessage: string;
    FErrorCode: Integer;
    FLevel: Integer;
    FObjName: String;
    FKind: TADCommandExceptionKind;
    FCommandTextOffset: Integer;
    FRowIndex: Integer;
  protected
    procedure Assign(ASrc: TADDBError); virtual;
    procedure LoadFromStorage(AStorage: TADStorage); virtual;
    procedure SaveToStorage(AStorage: TADStorage); virtual;
  public
    constructor Create; overload; virtual;
    constructor Create(ALevel, AErrorCode: Integer; const AMessage,
      AObjName: String; AKind: TADCommandExceptionKind; ACmdOffset, ARowIndex: Integer); overload; virtual;
    property ErrorCode: Integer read FErrorCode write FErrorCode;
    property Kind: TADCommandExceptionKind read FKind write FKind;
    property Level: Integer read FLevel write FLevel;
    property Message: String read FMessage write FMessage;
    property ObjName: String read FObjName write FObjName;
    property CommandTextOffset: Integer read FCommandTextOffset write FCommandTextOffset;
    property RowIndex: Integer read FRowIndex write FRowIndex;
  end;

  EADDBEngineException = class(EADException)
  private
    FItems: TADObjList;
    FParams: TStrings;
    FSQL: String;
    function GetErrors(AIndex: Integer): TADDBError;
    function GetErrorCount: Integer;
    function GetKind: TADCommandExceptionKind;
    function GetErrorCode: Integer;
    procedure SetParams(const AValue: TStrings);
  protected
    procedure SetSQLAndParams(const AValue: IADMoniAdapter);
    procedure LoadFromStorage(AStorage: TADStorage); override;
    procedure SaveToStorage(AStorage: TADStorage); override;
    function GetErrorClass: TADDBErrorClass; virtual;
    function AppendError: TADDBError; overload;
  public
    constructor Create; overload; override;
    constructor Create(AADCode: Integer; const AMessage: String); overload;
    destructor Destroy; override;
    function AppendError(ALevel, AErrorCode: Integer;
      const AMessage, AObjName: String; AKind: TADCommandExceptionKind;
      ACmdOffset, ARowIndex: Integer): TADDBError; overload;
    procedure Duplicate(var AValue: EADException); override;
    procedure Append(AItem: TADDBError);
    procedure Remove(AItem: TADDBError);
    procedure Clear;
    procedure Merge(AValue: EADDBEngineException; AIndex: Integer);
    property ErrorCount: Integer read GetErrorCount;
    property Errors[Index: Integer]: TADDBError read GetErrors; default;
    property ErrorCode: Integer read GetErrorCode;
    property Kind: TADCommandExceptionKind read GetKind;
    property Params: TStrings read FParams write SetParams;
    property SQL: String read FSQL write FSQL;
  end;

  EADDBArrayExecuteError = class(EADException)
  private
    FTimes: LongInt;
    FOffset: LongInt;
    FAction: TADErrorAction;
    FException: EADDBEngineException;
    FRetryLevel: Integer;
  public
    constructor Create(ATimes, AOffset: LongInt; AException: EADDBEngineException;
      ARetryLevel: Integer); overload;
    property Times: LongInt read FTimes;
    property Offset: LongInt read FOffset;
    property Exception: EADDBEngineException read FException;
    property RetryLevel: Integer read FRetryLevel;
    property Action: TADErrorAction read FAction write FAction;
  end;

  TADErrorEvent = procedure (ASender: TObject; const AInitiator: IADStanObject;
    var AException: Exception) of object;

procedure ADException(AObj: TObject; AEx: EADException
  {$IFDEF AnyDAC_Monitor}; ATracing: Boolean {$ENDIF}); overload;
function ADExceptionLayers(const ALayers: array of String): String;
function ADGetErrorMessage(ACode: Integer; const AArgs: array of const): String;
procedure ADException(AObj: TObject; const ALayers: array of String;
  ACode: Integer; const AArgs: array of const); overload;
procedure ADCapabilityNotSupported(AObj: TObject; const ALayers: array of String);

function ADDBEngineExceptionLoad(AStorage: TADStorage): TObject;
function ADDBEngineExceptionCreate(AClass: EADDBEngineExceptionClass;
  ACode: Integer; const AArgs: array of const): EADDBEngineException;
function ADExceptionLoad(AStorage: TADStorage): TObject;
procedure ADExceptionSave(AObject: TObject; AStorage: TADStorage);

implementation

uses
{$IFNDEF AnyDAC_D6Base}
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
{$ENDIF}
{$IFDEF AnyDAC_D17}
  System.Generics.Collections,
  System.Types,
{$ENDIF}
  uADStanConst, uADStanResStrs, uADStanUtil;

{-------------------------------------------------------------------------------}
{ Utilities                                                                     }
{-------------------------------------------------------------------------------}
procedure ADException(AObj: TObject; AEx: EADException
  {$IFDEF AnyDAC_Monitor}; ATracing: Boolean {$ENDIF});
var
  oHndlr: IADStanErrorHandler;
  oMAIntf: IADMoniAdapter;
  oEx: Exception;
  oObj: IADStanObject;
begin
  if (AEx is EADDBEngineException) and
     Supports(AObj, IADMoniAdapter, oMAIntf) and
     (oMAIntf.SupportItems * [ikSQL, ikParam] = [ikSQL, ikParam]) then
    EADDBEngineException(AEx).SetSQLAndParams(oMAIntf);
  if Supports(AObj, IADStanObject, oObj) then
    AEx.SetADObjectName(oObj);
  oEx := Exception(AEx);
  if Supports(AObj, IADStanErrorHandler, oHndlr) then begin
    try
      oHndlr.HandleException(oObj, oEx);
    except
      on E: Exception do begin
        if (E <> oEx) and (oEx <> nil) then
          ADFree(oEx);
        raise;
      end;
    end;
  end;
  if oEx <> nil then begin
{$IFDEF AnyDAC_Monitor}
    // The monitor client messages queue may be not empty. When an exception
    // is raised and an IDE is stopped, the queue remains not empty and
    // ADMonitor does not show error message. So, give the CPU to other threads.
    if ATracing then
      Sleep(50);
{$ENDIF}
    raise oEx;
  end;
end;

{-------------------------------------------------------------------------------}
function ADExceptionLayers(const ALayers: array of String): String;
var
  i: Integer;
begin
  Result := '[FireDAC]';
  for i := Low(ALayers) to High(ALayers) do
    Result := Result + '[' + ALayers[i] + ']';
end;

{-------------------------------------------------------------------------------}
function ADGetErrorMessage(ACode: Integer; const AArgs: array of const): String;

  function CheckCustomMessage(const AStdMessage: String): String;
  begin
    if TVarRec(AArgs[1]).VInteger = 1 then
      Result := AStdMessage
    else
      Result := String(TVarRec(AArgs[0]).VAnsiString);
  end;

begin
  case ACode of
  er_AD_DuplicatedName: Result := S_AD_DuplicatedName;
  er_AD_NameNotFound: Result := S_AD_NameNotFound;
  er_AD_ColTypeUndefined: Result := S_AD_ColTypeUndefined;
  er_AD_NoColsDefined: Result := S_AD_NoColsDefined;
  er_AD_CheckViolated: Result := CheckCustomMessage(S_AD_CheckViolated);
  er_AD_CantBeginEdit: Result := S_AD_CantBeginEdit;
  er_AD_CantCreateChildView: Result := S_AD_CantCreateChildView;
  er_AD_RowCantBeDeleted: Result := S_AD_RowCantBeDeleted;
  er_AD_ColMBBLob: Result := S_AD_ColMBBLob;
  er_AD_FixedLenDataMismatch: Result := S_AD_FixedLenDataMismatch;
  er_AD_RowNotInEditableState: Result := S_AD_RowNotInEditableState;
  er_AD_ColIsReadOnly: Result := S_AD_ColIsReadOnly;
  er_AD_RowCantBeInserted: Result := S_AD_RowCantBeInserted;
  er_AD_RowColMBNotNull: Result := S_AD_RowColMBNotNull;
  er_AD_DuplicateRows: Result := CheckCustomMessage(S_AD_DuplicateRows);
  er_AD_NoMasterRow: Result := CheckCustomMessage(S_AD_NoMasterRow);
  er_AD_HasChildRows: Result := CheckCustomMessage(S_AD_HasChildRows);
  er_AD_CantCompareRows: Result := S_AD_CantCompareRows;
  er_AD_ConvIsNotSupported: Result := S_AD_ConvIsNotSupported;
  er_AD_ColIsNotSearchable: Result := S_AD_ColIsNotSearchable;
  er_AD_RowMayHaveSingleParent: Result := S_AD_RowMayHaveSingleParent;
  er_AD_CantOperateInvObj: Result := S_AD_CantOperateInvObj;
  er_AD_CantSetParentRow: Result := S_AD_CantSetParentRow;
  er_AD_RowIsNotNested: Result := S_AD_RowIsNotNested;
  er_AD_ColumnIsNotRef: Result := S_AD_ColumnIsNotRef;
  er_AD_ColumnIsNotSetRef: Result := S_AD_ColumnIsNotSetRef;
  er_AD_OperCNBPerfInState: Result := S_AD_OperCNBPerfInState;
  er_AD_CantSetUpdReg: Result := S_AD_CantSetUpdReg;
  er_AD_TooManyAggs: Result := S_AD_TooManyAggs;
  er_AD_GrpLvlExceeds: Result := S_AD_GrpLvlExceeds;
  er_AD_VarLenDataMismatch: Result := S_AD_VarLenDataMismatch;
  er_AD_BadForeignKey: Result := S_AD_BadForeignKey;
  er_AD_BadUniqueKey: Result := S_AD_BadUniqueKey;
  er_AD_CantChngColType: Result := S_AD_CantChngColType;
  er_AD_BadRelation: Result := S_AD_BadRelation;
  er_AD_CantCreateParentView: Result := S_AD_CantCreateParentView;
  er_AD_CantChangeTableStruct: Result := S_AD_CantChangeTableStruct;
  er_AD_FoundCascadeLoop: Result := S_AD_FoundCascadeLoop;
  er_AD_RecLocked: Result := S_AD_RecLocked;
  er_AD_RecNotLocked: Result := S_AD_RecNotLocked;
  er_AD_TypeIncompat: Result := S_AD_TypeIncompat;
  er_AD_ValueOutOfRange: Result := S_AD_ValueOutOfRange;

  er_AD_ColumnDoesnotFound: Result := S_AD_ColumnDoesnotFound;
  er_AD_ExprTermination: Result := S_AD_ExprTermination;
  er_AD_ExprMBAgg: Result := S_AD_ExprMBAgg;
  er_AD_ExprCantAgg: Result := S_AD_ExprCantAgg;
  er_AD_ExprTypeMis: Result := S_AD_ExprTypeMis;
  er_AD_ExprIncorrect: Result := S_AD_ExprIncorrect;
  er_AD_InvalidKeywordUse: Result := S_AD_InvalidKeywordUse;
  er_AD_ExprInvalidChar: Result := S_AD_ExprInvalidChar;
  er_AD_ExprNameError: Result := S_AD_ExprNameError;
  er_AD_ExprStringError: Result := S_AD_ExprStringError;
  er_AD_ExprNoLParen: Result := S_AD_ExprNoLParen;
  er_AD_ExprNoRParenOrComma: Result := S_AD_ExprNoRParenOrComma;
  er_AD_ExprNoRParen: Result := S_AD_ExprNoRParen;
  er_AD_ExprEmptyInList: Result := S_AD_ExprEmptyInList;
  er_AD_ExprExpected: Result := S_AD_ExprExpected;
  er_AD_ExprNoArith: Result := S_AD_ExprNoArith;
  er_AD_ExprBadScope: Result := S_AD_ExprBadScope;
  er_AD_ExprEmpty: Result := S_AD_ExprEmpty;
  er_AD_ExprEvalError: Result := S_AD_ExprEvalError;

  er_AD_DSNoBookmark: Result := S_AD_DSNoBookmark;
  er_AD_DSViewNotSorted: Result := S_AD_DSViewNotSorted;
  er_AD_DSNoAdapter: Result := S_AD_DSNoAdapter;
  er_AD_DSNoNestedMasterSource: Result := S_AD_DSNoNestedMasterSource;
  er_AD_DSCircularDataLink: Result := S_AD_DSCircularDataLink;
  er_AD_DSRefreshError: Result := S_AD_DSRefreshError;
  er_AD_DSNoDataTable: Result := S_AD_DSNoDataTable;
  er_AD_DSIndNotFound: Result := S_AD_DSIndNotFound;
  er_AD_DSAggNotFound: Result := S_AD_DSAggNotFound;
  er_AD_DSIndNotComplete: Result := S_AD_DSIndNotComplete;
  er_AD_DSAggNotComplete: Result := S_AD_DSAggNotComplete;
  er_AD_DSCantUnidir: Result := S_AD_DSCantUnidir;
  er_AD_DSIncompatBmkFields: Result := S_AD_DSIncompatBmkFields;
  er_AD_DSCantEdit: Result := S_AD_DSCantEdit;
  er_AD_DSCantInsert: Result := S_AD_DSCantInsert;
  er_AD_DSCantDelete: Result := S_AD_DSCantDelete;
  er_AD_DSFieldNotFound: Result := S_AD_DSFieldNotFound;
  er_AD_DSCantOffline: Result := S_AD_DSCantOffline;
  er_AD_DSCantOffCachedUpdates: Result := S_AD_DSCantOffCachedUpdates;

  er_AD_DefCircular: Result := S_AD_DefCircular;
  er_AD_DefRO: Result := S_AD_DefRO;
  er_AD_DefCantMakePers: Result := S_AD_DefCantMakePers;
  er_AD_DefAlreadyLoaded: Result := S_AD_DefAlreadyLoaded;
  er_AD_DefNotExists: Result := S_AD_DefNotExists;
  er_AD_DefDupName: Result := S_AD_DefDupName;

  er_AD_AccSrvNotFound: Result := S_AD_AccSrvNotFound;
  er_AD_AccCannotReleaseDrv: Result := S_AD_AccCannotReleaseDrv;
  er_AD_AccSrvNotDefined: Result := S_AD_AccSrvNotDefined;
  er_AD_AccSrvMBConnected: Result := S_AD_AccSrvMBConnected;
  er_AD_AccCapabilityNotSup: Result := S_AD_AccCapabilityNotSup;
  er_AD_AccTxMBActive: Result := S_AD_AccTxMBActive;
  er_AD_AccTxMBInActive: Result := S_AD_AccTxMBInActive;
  er_AD_AccCantChngCommandState: Result := S_AD_AccCantChngCommandState;
  er_AD_AccCommandMBFilled: Result := S_AD_AccCommandMBFilled;
  er_AD_AccEscapeEmptyName: Result := S_AD_AccEscapeEmptyName;
  er_AD_AccCmdMHRowSet: Result := S_AD_AccCmdMHRowSet;
  er_AD_AccCmdMBPrepared: Result := S_AD_AccCmdMBPrepared;
  er_AD_AccCantExecCmdWithRowSet: Result := S_AD_AccCantExecCmdWithRowSet;
  er_AD_AccCmdMBOpen4Fetch: Result := S_AD_AccCmdMBOpen4Fetch;
  er_AD_AccExactMismatch: Result := S_AD_AccExactMismatch;
  er_AD_AccMetaInfoMismatch: Result := S_AD_AccMetaInfoMismatch;
  er_AD_AccCantLoadLibrary: Result := S_AD_AccCantLoadLibrary;
  er_AD_AccCantGetLibraryEntry: Result := S_AD_AccCantGetLibraryEntry;
  er_AD_AccSrvMBDisConnected: Result := S_AD_AccSrvMBDisConnected;
  er_AD_AccToManyLogins: Result := S_AD_AccToManyLogins;
  er_AD_AccDrvMngrMB: Result := S_AD_AccDrvMngrMB;
  er_AD_AccPrepMissed: Result := S_AD_AccPrepMissed;
  er_AD_AccPrepTooLongIdent: Result := S_AD_AccPrepTooLongIdent;
  er_AD_AccParamArrayMismatch: Result := S_AD_AccParamArrayMismatch;
  er_AD_AccAsyncOperInProgress: Result := S_AD_AccAsyncOperInProgress;
  er_AD_AccEscapeIsnotSupported: Result := S_AD_AccEscapeIsnotSupported;
  er_AD_AccMetaInfoReset: Result := S_AD_AccMetaInfoReset;
  er_AD_AccWhereIsEmpty: Result := S_AD_AccWhereIsEmpty;
  er_AD_AccUpdateTabUndefined: Result := S_AD_AccUpdateTabUndefined;
  er_AD_AccNameHasErrors: Result := S_AD_AccNameHasErrors;
  er_AD_AccEscapeBadSyntax: Result := S_AD_AccEscapeBadSyntax;
  er_AD_AccShutdownTO: Result := S_AD_AccShutdownTO;
  er_AD_AccParTypeUnknown: Result := S_AD_AccParTypeUnknown;
  er_AD_AccParDataMapNotSup: Result := S_AD_AccParDataMapNotSup;
  er_AD_AccColDataMapNotSup: Result := S_AD_AccColDataMapNotSup;
  er_AD_AccParDefChanged: Result := S_AD_AccParDefChanged;
  er_AD_AccMetaInfoNotDefined: Result := S_AD_AccMetaInfoNotDefined;
  er_AD_AccCantAssignTxIntf: Result := S_AD_AccCantAssignTxIntf;
  er_AD_AccParSetChanged: Result := S_AD_AccParSetChanged;
  er_AD_AccDataToLarge: Result := S_AD_AccDataToLarge;
  er_AD_AccDbNotExists: Result := S_AD_AccDbNotExists;
  er_AD_AccClassNotRegistered: Result := S_AD_AccClassNotRegistered;
  er_AD_AccSysClassNotRegistered: Result := S_AD_AccSysClassNotRegistered;
  er_AD_AccUnrecognizedDbFormat: Result := S_AD_AccUnrecognizedDbFormat;
  er_AD_AccNotValidPassword: Result := S_AD_AccNotValidPassword;
  er_AD_AccUnknownOleError: Result := S_AD_AccUnknownOleError;

  er_AD_SvcLinkMBSet: Result := S_AD_SvcLinkMBSet;
  er_AD_SvcMBActive: Result := S_AD_SvcMBActive;
  er_AD_SvcCannotUninstall: Result := S_AD_SvcCannotUninstall;

  er_AD_DAptRecordIsDeleted: Result := S_AD_DAptRecordIsDeleted;
  er_AD_DAptNoSelectCmd: Result := S_AD_DAptNoSelectCmd;
  er_AD_DAptApplyUpdateFailed: Result := S_AD_DAptApplyUpdateFailed;
  er_AD_DAptCantEdit: Result := S_AD_DAptCantEdit;
  er_AD_DAptCantInsert: Result := S_AD_DAptCantInsert;
  er_AD_DAptCantDelete: Result := S_AD_DAptCantDelete;

  er_AD_ClntSessMBSingle: Result := S_AD_ClntSessMBSingle;
  er_AD_ClntSessMBInactive: Result := S_AD_ClntSessMBInactive;
  er_AD_ClntSessMBActive: Result := S_AD_ClntSessMBActive;
  er_AD_ClntDbDupName: Result := S_AD_ClntDbDupName;
  er_AD_ClntDbMBInactive: Result := S_AD_ClntDbMBInactive;
  er_AD_ClntDbMBActive: Result := S_AD_ClntDbMBActive;
  er_AD_ClntDbLoginAborted: Result := S_AD_ClntDbLoginAborted;
  er_AD_ClntDbCantConnPooled: Result := S_AD_ClntDbCantConnPooled;
  er_AD_ClntDBNotFound: Result := S_AD_ClntDBNotFound;
  er_AD_ClntAdaptMBActive: Result := S_AD_ClntAdaptMBActive;
  er_AD_ClntAdaptMBInactive: Result := S_AD_ClntAdaptMBInactive;
  er_AD_ClntNotCachedUpdates: Result := S_AD_ClntNotCachedUpdates;
  er_AD_ClntDbNotDefined: Result := S_AD_ClntDbNotDefined;
  er_AD_ClntDbMBOnline: Result := S_AD_ClntDbMBOnline;
  er_AD_ClntTxMBActive: Result := S_AD_AccTxMBActive;
  er_AD_ClntCantShareAdapt: Result := S_AD_ClntCantShareAdapt;
  er_AD_ClntConnNotMatch: Result := S_AD_ClntConnNotMatch;
  er_AD_ClntPKNotFound: Result := S_AD_ClntPKNotFound;
  er_AD_ClntLocalSQLMisuse: Result := S_AD_ClntLocalSQLMisuse;
  er_AD_ClntWrongIndex: Result := S_AD_ClntWrongIndex;
  er_AD_ClntDSNameEmpty: Result := S_AD_ClntDSNameEmpty;
  er_AD_ClntDSNameNotUnique: Result := S_AD_ClntDSNameNotUnique;

  er_AD_DPNoTxtFld: Result := S_AD_DPNoTxtFld;
  er_AD_DPNoSrcDS: Result := S_AD_DPNoSrcDS;
  er_AD_DPNoDestDS: Result := S_AD_DPNoDestDS;
  er_AD_DPNoTxtDest: Result := S_AD_DPNoTxtDest;
  er_AD_DPNoTxtSrc: Result := S_AD_DPNoTxtSrc;
  er_AD_DPBadFixedSize: Result := S_AD_DPBadFixedSize;
  er_AD_DPTxtFldDup: Result := S_AD_DPTxtFldDup;
  er_AD_DPBadTextFmt: Result := S_AD_DPBadTextFmt;
  er_AD_DPSrcUndefined: Result := S_AD_DPSrcUndefined;

  er_AD_StanTimeout: Result := S_AD_StanTimeout;
  er_AD_StanCantGetBlob: Result := S_AD_StanCantGetBlob;
  er_AD_StanParamOverflow: Result := S_AD_StanParamOverflow;
  er_AD_StanCantNonblocking: Result := S_AD_StanCantNonblocking;
  er_AD_StanMacroNotFound: Result := S_AD_StanMacroNotFound;
  er_AD_StanBadParRowIndex: Result := S_AD_StanBadParRowIndex;
  er_AD_StanPoolTooManyItems: Result := S_AD_StanPoolTooManyItems;
  er_AD_StanStrgInvBinFmt: Result := S_AD_StanStrgInvBinFmt;
  er_AD_StanStrgCantReadProp: Result := S_AD_StanStrgCantReadProp;
  er_AD_StanStrgCantReadObj: Result := S_AD_StanStrgCantReadObj;
  er_AD_StanStrgCantReadCDATA: Result := S_AD_StanStrgCantReadCDATA;
  er_AD_StanStrgDictOverflow: Result := S_AD_StanStrgDictOverflow;
  er_AD_StanStrgClassUnknown: Result := S_AD_StanStrgClassUnknown;
  er_AD_StanStrgUnknownFmt: Result := S_AD_StanStrgUnknownFmt;
  er_AD_StanStrgFileError: Result := S_AD_StanStrgFileError;
  er_AD_StanStrgInvDIntFmt: Result := S_AD_StanStrgInvDIntFmt;

  er_AD_ScrCantExecHostCmd: Result := S_AD_ScrCantExecHostCmd;
  er_AD_ScrStrSize1: Result := S_AD_ScrStrSize1;
  er_AD_ScrStrNotAlphaNum: Result := S_AD_ScrStrNotAlphaNum;
  er_AD_ScrSetArgInvalid: Result := S_AD_ScrSetArgInvalid;
  er_AD_ScrInvalidSyntax: Result := S_AD_ScrInvalidSyntax;
  er_AD_ScrAccMustSpecVar: Result := S_AD_ScrAccMustSpecVar;
  er_AD_ScrDefReqValue: Result := S_AD_ScrDefReqValue;
  er_AD_ScrVarMissedCloseBrace: Result := S_AD_ScrVarMissedCloseBrace;
  er_AD_ScrVarUnsupType: Result := S_AD_ScrVarUnsupType;
  er_AD_ScrNotLogged: Result := S_AD_ScrNotLogged;
  er_AD_ScrNoCmds: Result := S_AD_ScrNoCmds;
  er_AD_ScrNoScript: Result := S_AD_ScrNoScript;

  er_AD_DBXParMBNotEmpty: Result := S_AD_DBXParMBNotEmpty;
  er_AD_DBXNoDriverCfg: Result := S_AD_DBXNoDriverCfg;

  er_AD_MySQLBadVersion: Result := S_AD_MySQLBadVersion;
  er_AD_MySQLCantSetPort: Result := S_AD_MySQLCantSetPort;
  er_AD_MySQLBadParams: Result := S_AD_MySQLBadParams;
  er_AD_MySQLCantInitEmbeddedServer: Result := S_AD_MySQLCantInitEmbeddedServer;

  er_AD_OdbcVarDataTypeUnsup: Result := S_AD_OdbcVarDataTypeUnsup;

  er_AD_OraNoCursor: Result := S_AD_OraNoCursor;
  er_AD_OraCantSetCharset: Result := S_AD_OraCantSetCharset;
  er_AD_OraCantAssFILE: Result := S_AD_OraCantAssFILE;
  er_AD_OraNoCursorParams: Result := S_AD_OraNoCursorParams;
  er_AD_OraNotInstalled: Result := S_AD_OraNotInstalled;
  er_AD_OraBadVersion: Result := S_AD_OraBadVersion;
  er_AD_OraBadVarType: Result := S_AD_OraBadVarType;
  er_AD_OraTooLongGTRID: Result := S_AD_OraTooLongGTRID;
  er_AD_OraTooLongBQUAL: Result := S_AD_OraTooLongBQUAL;
  er_AD_OraTooLongTXName: Result := S_AD_OraTooLongTXName;
  er_AD_OraDBTNManyClBraces: Result := S_AD_OraDBTNManyClBraces;
  er_AD_OraNotPLSQLObj: Result := S_AD_OraNotPLSQLObj;
  er_AD_OraNotPackageProc: Result := S_AD_OraNotPackageProc;
  er_AD_OraBadTableType: Result := S_AD_OraBadTableType;
  er_AD_OraUnNamedRecParam: Result := S_AD_OraUnNamedRecParam;
  er_AD_OraCantConvNum: Result := S_AD_OraCantConvNum;
  er_AD_OraPipeAlertToMany: Result := S_AD_OraPipeAlertToMany;

  er_AD_IBTraceIsActive: Result := S_AD_IBTraceIsActive;

  er_AD_PgProcNotFound: Result := S_AD_PgProcNotFound;
  er_AD_PgMultiDimArrNotSup: Result := S_AD_PgMultiDimArrNotSup;
  er_AD_PgUnsupArrValueTypeNotSup: Result := S_AD_PgUnsupArrValueTypeNotSup;
  er_AD_PgArrIndexOutOfBound: Result := S_AD_PgArrIndexOutOfBound;
  er_AD_PgCannotDescribeType: Result := S_AD_PgCannotDescribeType;

  er_AD_SQLiteInitFailed: Result := S_AD_SQLiteInitFailed;
  er_AD_SQLiteDBNotFound: Result := S_AD_SQLiteDBNotFound;
  er_AD_SQLiteVTabInvalidArgs: Result := S_AD_SQLiteVTabInvalidArgs;
  er_AD_SQLiteVTabDSNotFoundOrEmpty: Result := S_AD_SQLiteVTabDSNotFoundOrEmpty;
  er_AD_SQLiteVTabDSNotSupported: Result := S_AD_SQLiteVTabDSNotSupported;
  er_AD_SQLiteVTabDSSPNotFound: Result := S_AD_SQLiteVTabDSSPNotFound;
  er_AD_SQLiteVTabDSDataModFailed: Result := S_AD_SQLiteVTabDSDataModFailed;
  er_AD_SQLiteVTabDSRowidInvalid: Result := S_AD_SQLiteVTabDSRowidInvalid;
  er_AD_SQLiteVTabDSChangedOrFreed: Result := S_AD_SQLiteVTabDSChangedOrFreed;
  er_AD_SQLiteVTabDSNoRowExists: Result := S_AD_SQLiteVTabDSNoRowExists;
  er_AD_SQLiteVTabDSCursorInvalid: Result := S_AD_SQLiteVTabDSCursorInvalid;
  er_AD_SQLiteVTabCannotAttach: Result := S_AD_SQLiteVTabCannotAttach;
  er_AD_SQLiteVTabDataSetBusy: Result := S_AD_SQLiteVTabDataSetBusy;

  er_AD_ASADBToolNotFound: Result := S_AD_ASADBToolNotFound;
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADException(AObj: TObject; const ALayers: array of String;
  ACode: Integer; const AArgs: array of const);
var
  s, sMsg: String;
begin
  sMsg := ADGetErrorMessage(ACode, AArgs);
  s := ADExceptionLayers(ALayers) + '-' + IntToStr(ACode) + '. ';
  try
    s := s + Format(sMsg, AArgs);
  except
    s := s + sMsg;
  end;
  ADException(AObj, EADException.Create(ACode, s)
    {$IFDEF AnyDAC_Monitor}, False {$ENDIF});
end;

{-------------------------------------------------------------------------------}
procedure ADCapabilityNotSupported(AObj: TObject; const ALayers: array of String);
begin
  ADException(AObj, ALayers, er_AD_AccCapabilityNotSup, []);
end;

{-------------------------------------------------------------------------------}
function ADDBEngineExceptionCreate(AClass: EADDBEngineExceptionClass; ACode: Integer;
  const AArgs: array of const): EADDBEngineException;
var
  sMsg: String;
begin
  sMsg := ADGetErrorMessage(ACode, AArgs);
  try
    sMsg := Format(sMsg, AArgs);
  except
    // silent
  end;
  Result := AClass.Create(ACode, sMsg);
end;

{-------------------------------------------------------------------------------}
{ EADException                                                                  }
{-------------------------------------------------------------------------------}
constructor EADException.Create;
begin
  inherited Create('');
end;

{-------------------------------------------------------------------------------}
constructor EADException.Create(AADCode: Integer; const AMessage: String);
begin
  inherited Create(AMessage);
  FADCode := AADCode;
end;

{-------------------------------------------------------------------------------}
procedure EADException.SetADObjectName(const AValue: IADStanObject);
var
  oObj: IADStanObject;
begin
  oObj := AValue;
  FADObjName := '';
  repeat
    if FADObjName <> '' then
      FADObjName := '.' + FADObjName;
    FADObjName := oObj.Name + FADObjName;
    oObj := oObj.Parent;
  until oObj = nil;
end;

{-------------------------------------------------------------------------------}
procedure EADException.Duplicate(var AValue: EADException);
begin
  if AValue = nil then
    AValue := EADExceptionClass(ClassType).Create;
  AValue.Message := Message;
  AValue.ADCode := ADCode;
  AValue.ADObjName := ADObjName;
end;

{-------------------------------------------------------------------------------}
procedure EADException.LoadFromStorage(AStorage: TADStorage);
begin
  ADCode := AStorage.ReadInteger('ADCode', 0);
  Message := AStorage.ReadString('Message', '');
  if AStorage.StreamVersion >= 8 then
    ADObjName := AStorage.ReadString('ADObjName', '');
end;

{-------------------------------------------------------------------------------}
procedure EADException.SaveToStorage(AStorage: TADStorage);
begin
  AStorage.WriteInteger('ADCode', ADCode, 0);
  AStorage.WriteString('Message', Message, '');
  if AStorage.StreamVersion >= 8 then
    AStorage.WriteString('ADObjName', ADObjName, '');
end;

{-------------------------------------------------------------------------------}
function ADExceptionLoad(AStorage: TADStorage): TObject;
begin
  Result := EADException.Create;
  EADException(Result).LoadFromStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
procedure ADExceptionSave(AObject: TObject; AStorage: TADStorage);
begin
  EADException(AObject).SaveToStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
{ TADDBError                                                                    }
{-------------------------------------------------------------------------------}
constructor TADDBError.Create;
begin
  inherited Create;
  FCommandTextOffset := -1;
  FRowIndex := -1;
end;

{-------------------------------------------------------------------------------}
constructor TADDBError.Create(ALevel, AErrorCode: Integer;
  const AMessage, AObjName: String; AKind: TADCommandExceptionKind;
  ACmdOffset, ARowIndex: Integer);
begin
  Create;
  FLevel := ALevel;
  FErrorCode := AErrorCode;
  FMessage := AMessage;
  FObjName := AObjName;
  FKind := AKind;
  FCommandTextOffset := ACmdOffset;
  FRowIndex := ARowIndex;
end;

{-------------------------------------------------------------------------------}
procedure TADDBError.Assign(ASrc: TADDBError);
begin
  FLevel := ASrc.Level;
  FErrorCode := ASrc.ErrorCode;
  FMessage := ASrc.Message;
  FObjName := ASrc.ObjName;
  FKind := ASrc.Kind;
  FCommandTextOffset := ASrc.CommandTextOffset;
  FRowIndex := ASrc.RowIndex;
end;

{-------------------------------------------------------------------------------}
procedure TADDBError.LoadFromStorage(AStorage: TADStorage);
begin
  ErrorCode := AStorage.ReadInteger('ErrorCode', 0);
  Kind := TADCommandExceptionKind(AStorage.ReadInteger('Kind', 0));
  Level := AStorage.ReadInteger('Level', 0);
  Message := AStorage.ReadString('Message', '');
  ObjName := AStorage.ReadString('ObjName', '');
  CommandTextOffset := AStorage.ReadInteger('CommandTextOffset', 0);
  RowIndex := AStorage.ReadInteger('RowIndex', 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDBError.SaveToStorage(AStorage: TADStorage);
begin
  AStorage.WriteInteger('ErrorCode', ErrorCode, 0);
  AStorage.WriteInteger('Kind', Integer(Kind), 0);
  AStorage.WriteInteger('Level', Level, 0);
  AStorage.WriteString('Message', Message, '');
  AStorage.WriteString('ObjName', ObjName, '');
  AStorage.WriteInteger('CommandTextOffset', CommandTextOffset, 0);
  AStorage.WriteInteger('RowIndex', RowIndex, 0);
end;

{-------------------------------------------------------------------------------}
{ EADDBEngineException                                                          }
{-------------------------------------------------------------------------------}
constructor EADDBEngineException.Create;
begin
  inherited Create(0, '');
  FItems := TADObjList.Create;
  FParams := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
constructor EADDBEngineException.Create(AADCode: Integer;
  const AMessage: String);
begin
  inherited Create(AADCode, AMessage);
  FItems := TADObjList.Create;
  FParams := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor EADDBEngineException.Destroy;
begin
  Clear;
  ADFreeAndNil(FItems);
  ADFreeAndNil(FParams);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.SetSQLAndParams(const AValue: IADMoniAdapter);
var
  i: Integer;
  sName: String;
  vValue: Variant;
  eKind: TADMoniAdapterItemKind;
begin
  FParams.Clear;
  FSQL := '';
  if AValue <> nil then
    for i := 0 to AValue.ItemCount - 1 do begin
      AValue.GetItem(i, sName, vValue, eKind);
      if eKind = ikParam then
        FParams.Add(ADValToStr(sName, False) + '=' + ADValToStr(vValue, False))
      else if eKind = ikSQL then
        FSQL := ADFixCRLF(vValue);
    end;
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.SetParams(const AValue: TStrings);
begin
  FParams.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.GetErrorClass: TADDBErrorClass;
begin
  Result := TADDBError;
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.Duplicate(var AValue: EADException);
var
  oItem: TADDBError;
  i: Integer;
begin
  inherited Duplicate(AValue);
  EADDBEngineException(AValue).FParams.Assign(FParams);
  EADDBEngineException(AValue).FSQL := FSQL;
  for i := 0 to FItems.Count - 1 do begin
    oItem := EADDBEngineException(AValue).AppendError;
    oItem.Assign(TADDBError(FItems[i]));
  end;
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.GetErrorCount: Integer;
begin
  Result := FItems.Count;
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.GetErrors(AIndex: Integer): TADDBError;
begin
  Result := TADDBError(FItems[AIndex]);
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.GetKind: TADCommandExceptionKind;
var
  i: Integer;
begin
  Result := ekOther;
  for i := 0 to FItems.Count - 1 do
    if Errors[i].Kind <> ekOther then begin
      Result := Errors[i].Kind;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.GetErrorCode: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FItems.Count - 1 do
    if Errors[i].ErrorCode <> 0 then begin
      Result := Errors[i].ErrorCode;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.AppendError: TADDBError;
begin
  Result := GetErrorClass.Create;
  Append(Result);
end;

{-------------------------------------------------------------------------------}
function EADDBEngineException.AppendError(ALevel, AErrorCode: Integer;
  const AMessage, AObjName: String; AKind: TADCommandExceptionKind;
  ACmdOffset, ARowIndex: Integer): TADDBError;
begin
  Result := GetErrorClass.Create(ALevel, AErrorCode, AMessage, AObjName,
    AKind, ACmdOffset, ARowIndex);
  Append(Result);
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.Append(AItem: TADDBError);
begin
  FItems.Add(AItem);
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.Remove(AItem: TADDBError);
begin
  FItems.Remove(AItem);
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.Merge(AValue: EADDBEngineException; AIndex: Integer);
var
  i: Integer;
begin
  for i := AValue.ErrorCount - 1 downto 0 do begin
    FItems.Insert(AIndex, AValue[i]);
    AValue.FItems.Delete(i);
  end;
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.Clear;
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
    ADFree(TADDBError(FItems[i]));
  FItems.Clear;
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.LoadFromStorage(AStorage: TADStorage);
var
  oErr: TADDBError;
begin
  inherited LoadFromStorage(AStorage);
  while not AStorage.IsObjectEnd('DBError') do begin
    AStorage.ReadObjectBegin('DBError');
    try
      oErr := AppendError;
      oErr.LoadFromStorage(AStorage);
    finally
      AStorage.ReadObjectEnd('DBError');
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure EADDBEngineException.SaveToStorage(AStorage: TADStorage);
var
  i: Integer;
  oErr: TADDBError;
begin
  inherited SaveToStorage(AStorage);
  for i := 0 to ErrorCount - 1 do begin
    AStorage.WriteObjectBegin('DBError');
    try
      oErr := Errors[i];
      oErr.SaveToStorage(AStorage);
    finally
      AStorage.WriteObjectEnd('DBError');
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADDBEngineExceptionLoad(AStorage: TADStorage): TObject;
begin
  Result := EADDBEngineException.Create;
  EADDBEngineException(Result).LoadFromStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
{ EADDBArrayExecuteError                                                        }
{-------------------------------------------------------------------------------}
constructor EADDBArrayExecuteError.Create(ATimes, AOffset: Integer;
  AException: EADDBEngineException; ARetryLevel: Integer);
begin
  inherited Create(er_AD_AccArrayExecError, 'Array DML failed: ' + AException.Message);
  FTimes := ATimes;
  FOffset := AOffset;
  FException := AException;
  FAction := eaFail;
  FRetryLevel := ARetryLevel;
end;

{-------------------------------------------------------------------------------}
initialization
  ADStorageManager().RegisterClass(EADException, 'Exception',
    @ADExceptionLoad, @ADExceptionSave);
  ADStorageManager().RegisterClass(EADDBEngineException, 'DBEngineException',
    @ADDBEngineExceptionLoad, @ADExceptionSave);

end.
