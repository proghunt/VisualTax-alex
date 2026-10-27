{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{       FireDAC Data Adapter Layer implementation       }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADDAptManager"'}

unit uADDAptManager;

interface

implementation

uses
  SysUtils, Classes, DB,
{$IFDEF AnyDAC_D17}
  System.Generics.Collections,
  System.Types,
{$ENDIF}
  uADStanIntf, uADStanParam, uADStanFactory, uADStanUtil, uADStanError,
    uADStanConst, uADStanResStrs,
  uADGUIxIntf,
  uADDatSManager,
  uADPhysIntf,
  uADDAptIntf, uADDAptColumn,
  uADStanOption;

type
  TADDAptTableAdapter = class;
  TADDAptTableAdapters = class;
  TADDAptSchemaAdapter = class;

  TADDAptUpdatesJournalProcessor = class(TObject)
  private
    FJournal: TADDatSUpdatesJournal;
    FAdapters: TADDAptTableAdapters;
    FAdapter: TADDAptTableAdapter;
    FUpdateHandler: IADDAptUpdateHandler;
    FAutoMergeChangeLog: Boolean;
    FSilentMode: Boolean;
{$IFDEF AnyDAC_MONITOR}
    FMonitor: IADMoniClient;
    function IsTracing: Boolean;
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; const AArgs: array of const);
{$ENDIF}
    function GetLimitToTable: TADDatSTable;
    function LookupTableAdapter(ATable: TADDatSTable): IADDAptTableAdapter;
  public
    constructor CreateForTableAdapter(ATableAdapter: TADDAptTableAdapter);
    constructor CreateForSchemaAdapter(ASchemaAdapter: TADDAptSchemaAdapter);
    destructor Destroy; override;
    function Process(AMaxErrors: Integer = -1): Integer;
    function Reconcile: Boolean;
    property LimitToTable: TADDatSTable read GetLimitToTable;
{$IFDEF AnyDAC_MONITOR}
    property Monitor: IADMoniClient read FMonitor write FMonitor;
{$ENDIF}
    property Journal: TADDatSUpdatesJournal read FJournal write FJournal;
    property AutoMergeChangeLog: Boolean read FAutoMergeChangeLog write FAutoMergeChangeLog;
    property UpdateHandler: IADDAptUpdateHandler read FUpdateHandler
      write FUpdateHandler;
  end;

  TADDAptUpdateCommandReason = (urSetSelect, urSetErrorHandler,
    urReset, urSetTransaction, urSetUpdateTransaction);

  TADDAptTableAdapter = class(TADObject, IUnknown, IADStanObject,
    IADStanErrorHandler, IADPhysMappingHandler, IADDAptTableAdapter)
  private
    FDatSTable: TADDatSTable;
    FDatSTableName: String;
    FSourceRecordSetID: Integer;
    FSourceRecordSetName: String;
    FUpdateTableName: String;
    FColMappings: TADDAptColumnMappings;
    FMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
    FMappings: TADDAptTableAdapters;
    FDatSManager: TADDatSManager;

    FGeneratedCommands: TADActionRequests;
    FCommands: array of IADPhysCommand;
    FBuffer: TADBuffer;
    FErrorHandler: IADStanErrorHandler;
    FUpdateHandler: IADDAptUpdateHandler;
    FInUpdateRowHandler: Boolean;
    FTransaction: IADPhysTransaction;
    FUpdateTransaction: IADPhysTransaction;

    procedure ProcessUpdate(ARow: TADDatSRow; var AAction: TADErrorAction;
      ARequest: TADUpdateRequest; AUpdRowOptions: TADUpdateRowOptions;
      AFillRowOptions: TADPhysFillRowOptions; AColumn: Integer);
    function GetUpdateRowCommand(ARow: TADDatSRow;
      AUpdRowOptions: TADUpdateRowOptions; AUpdateRequest: TADUpdateRequest;
      AFillRowOptions: TADPhysFillRowOptions; AColumn: Integer; ACacheCommand: Boolean;
      var AFlags: TADPhysCommandGeneratorFlags): IADPhysCommand;
    procedure MergeRowFromParams(const ACommand: IADPhysCommand;
      ABaseRow: TADDatSRow; AFetchedParams: TADParams; AClearRow: Boolean);
    procedure MergeRows(const ACommand: IADPhysCommand;
      ABaseRow, AFetchedRow: TADDatSRow; AClearRow: Boolean);
    procedure ParName2Col(ABaseRow: TADDatSRow; const AName: String;
      var ACol: TADDatSColumn; var ARow: TADDatSRow; var AVersion: Integer);
    procedure ProcessRequest(const ACommand: IADPhysCommand; ARow: TADDatSRow;
      ARequest: TADUpdateRequest; AUpdRowOptions: TADUpdateRowOptions;
      AFillRowOptions: TADPhysFillRowOptions; AWrapByTX: Boolean);
    procedure SetParamsFromRow(AParams: TADParams; ARow: TADDatSRow);
{$IFDEF AnyDAC_MONITOR}
    function IsTracing: Boolean;
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; const AArgs: array of const);
    function GetUpdateRequestName(ARequest: TADUpdateRequest): String;
{$ENDIF}
    function SetCommand(AReq: TADActionRequest; const ACmd: IADPhysCommand): Boolean;
    procedure GetCommand(AReq: TADActionRequest; out ACmd: IADPhysCommand);
    procedure UpdateCommands(AReason: TADDAptUpdateCommandReason);
    procedure CheckSelectCommand;
    function GetSchemaAdapter: TADDAptSchemaAdapter;
    procedure InternalSetCommand(AReq: TADActionRequest; const ACmd: IADPhysCommand);
    procedure ReleaseDatSTable;
    procedure AttachDatSTable(ATable: TADDatSTable);
    function MatchRecordSet(const ATable: Variant; ATabNameKind: TADPhysNameKind): Boolean;
    procedure GetConn(out AConn: IADPhysConnection);
    procedure GetUpdTx(out ATx: IADPhysTransaction);

  protected
    // IUnknown
    function _AddRef: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    function _Release: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};

    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);

    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception);

    // IADPhysMappingHandler
    function MapRecordSet(const ATable: Variant; ATabNameKind: TADPhysNameKind;
      var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
      var ADatSTable: TADDatSTable): TADPhysMappingResult;
    function MapRecordSetColumn(const ATable: Variant; ATabNameKind: TADPhysNameKind;
      const AColumn: Variant; AColNameKind: TADPhysNameKind; var ASourceID: Integer;
      var ASourceName, ADatSName, AUpdateName: String;
      var ADatSColumn: TADDatSColumn): TADPhysMappingResult;

    // IADDAptTableAdapter
    function GetSourceRecordSetID: Integer;
    procedure SetSourceRecordSetID(const AValue: Integer);
    function GetSourceRecordSetName: String;
    procedure SetSourceRecordSetName(const AValue: String);
    function GetUpdateTableName: String;
    procedure SetUpdateTableName(const AValue: String);
    function GetDatSTableName: String;
    procedure SetDatSTableName(const AValue: String);
    function GetDatSTable: TADDatSTable;
    procedure SetDatSTable(AValue: TADDatSTable);
    function GetColumnMappings: TADDAptColumnMappings;
    function GetMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
    procedure SetMetaInfoMergeMode(const AValue: TADPhysMetaInfoMergeMode);
    function GetTableMappings: IADDAptTableAdapters;
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(AValue: TADDatSManager);

    function GetSelectCommand: IADPhysCommand;
    procedure SetSelectCommand(const ACmd: IADPhysCommand);
    function GetInsertCommand: IADPhysCommand;
    procedure SetInsertCommand(const ACmd: IADPhysCommand);
    function GetUpdateCommand: IADPhysCommand;
    procedure SetUpdateCommand(const ACmd: IADPhysCommand);
    function GetDeleteCommand: IADPhysCommand;
    procedure SetDeleteCommand(const ACmd: IADPhysCommand);
    function GetLockCommand: IADPhysCommand;
    procedure SetLockCommand(const ACmd: IADPhysCommand);
    function GetUnLockCommand: IADPhysCommand;
    procedure SetUnLockCommand(const ACmd: IADPhysCommand);
    function GetFetchRowCommand: IADPhysCommand;
    procedure SetFetchRowCommand(const ACmd: IADPhysCommand);
    function GetTransaction: IADPhysTransaction;
    procedure SetTransaction(const AValue: IADPhysTransaction);
    function GetUpdateTransaction: IADPhysTransaction;
    procedure SetUpdateTransaction(const AValue: IADPhysTransaction);

    function GetOptions: IADStanOptions;
    function GetErrorHandler: IADStanErrorHandler;
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    function GetUpdateHandler: IADDAptUpdateHandler;
    procedure SetUpdateHandler(const AValue: IADDAptUpdateHandler);

    function GetObj: TObject;

    function Define: TADDatSTable;
    procedure Fetch(AAll: Boolean = False; ABlocked: Boolean = False); overload;
    function Update(AMaxErrors: Integer = -1): Integer; overload;
    function Reconcile: Boolean;
    procedure Reset;

    procedure Fetch(ARow: TADDatSRow; var AAction: TADErrorAction;
      AColumn: Integer; AFillRowOptions: TADPhysFillRowOptions); overload;
    procedure Update(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADUpdateRowOptions = []; AForceRequest: TADActionRequest = arFromRow); overload;
    procedure Lock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADUpdateRowOptions = []);
    procedure UnLock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADUpdateRowOptions = []);
    procedure FetchGenerators(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADUpdateRowOptions = []);
  public
    constructor CreateForSchema(AMappings: TADDAptTableAdapters);
    procedure Initialize; override;
    destructor Destroy; override;
  end;

  TADDAptTableAdapters = class(TInterfacedObject, IUnknown,
    IADDAptTableAdapters)
  private
    FItems: TADObjList;
    FSchemaAdapter: TADDAptSchemaAdapter;
    procedure Clear;
    function Find(const ATable: Variant; ANameKind: TADPhysNameKind): Integer;
    procedure DatSManagerDetaching;
    procedure DatSManagerAttached;
  protected
    // IUnknown
    function _AddRef: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    function _Release: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    // IADDAptTableAdapters
    function GetCount: Integer;
    function GetItems(AIndex: Integer): IADDAptTableAdapter;
    function Lookup(const ATable: Variant; ANameKind: TADPhysNameKind): IADDAptTableAdapter;
    function Add(const ASourceRecordSetName: String = '';
      const ADatSTableName: String = '';
      const AUpdateTableName: String = ''): IADDAptTableAdapter; overload;
    procedure Add(const AAdapter: IADDAptTableAdapter); overload;
    procedure Remove(const ATable: Variant; ANameKind: TADPhysNameKind); overload;
    procedure Remove(const AAdapter: IADDAptTableAdapter); overload;
  public
    constructor Create(ASchemaAdapter: TADDAptSchemaAdapter);
    destructor Destroy; override;
  end;

  TADDAptSchemaAdapter = class(TADObject, IADStanObject,
    IADPhysMappingHandler, IADDAptSchemaAdapter)
  private
    FDatSManager: TADDatSManager;
    FAdapters: TADDAptTableAdapters;
    FUpdateHandler: IADDAptUpdateHandler;
    FErrorHandler: IADStanErrorHandler;
    FTransaction: IADPhysTransaction;
    FUpdateTransaction: IADPhysTransaction;
    procedure AttachDatSManager(AManager: TADDatSManager);
    procedure ReleaseDatSManager;
  protected
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);

    // IADPhysMappingHandler
    function MapRecordSet(const ATable: Variant; ATabNameKind: TADPhysNameKind;
      var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
      var ADatSTable: TADDatSTable): TADPhysMappingResult;
    function MapRecordSetColumn(const ATable: Variant; ATabNameKind: TADPhysNameKind;
      const AColumn: Variant; AColNameKind: TADPhysNameKind; var ASourceID: Integer;
      var ASourceName, ADatSName, AUpdateName: String;
      var ADatSColumn: TADDatSColumn): TADPhysMappingResult;

    // IADDAptSchemaAdapter
    function GetErrorHandler: IADStanErrorHandler;
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    function GetUpdateHandler: IADDAptUpdateHandler;
    procedure SetUpdateHandler(const AValue: IADDAptUpdateHandler);
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(AValue: TADDatSManager);
    function GetTableAdapters: IADDAptTableAdapters;
    function GetTransaction: IADPhysTransaction;
    procedure SetTransaction(const AValue: IADPhysTransaction);
    function GetUpdateTransaction: IADPhysTransaction;
    procedure SetUpdateTransaction(const AValue: IADPhysTransaction);
    function Reconcile: Boolean;
    function Update(AMaxErrors: Integer = -1): Integer;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
{ TADDAptUpdatesJournalProcessor                                                }
{-------------------------------------------------------------------------------}
constructor TADDAptUpdatesJournalProcessor.CreateForSchemaAdapter(
  ASchemaAdapter: TADDAptSchemaAdapter);
{$IFDEF AnyDAC_MONITOR}
var
  i: Integer;
  oAdapt: TADDAptTableAdapter;
{$ENDIF}
begin
  inherited Create;
  FAdapters := ASchemaAdapter.FAdapters;
  FJournal := ASchemaAdapter.GetDatSManager.Updates;
  ASSERT(FJournal <> nil);
{$IFDEF AnyDAC_MONITOR}
  for i := 0 to FAdapters.GetCount - 1 do begin
    oAdapt := TADDAptTableAdapter(FAdapters.FItems.Items[i]);
    if (oAdapt.GetSelectCommand <> nil) and (oAdapt.GetSelectCommand.Connection <> nil) then begin
      FMonitor := oAdapt.GetSelectCommand.Connection.Monitor;
      if FMonitor <> nil then
        Break;
    end;
  end;
{$ENDIF}
  FUpdateHandler := ASchemaAdapter.GetUpdateHandler;
  FSilentMode := ADGUIxSilent;
end;

{-------------------------------------------------------------------------------}
constructor TADDAptUpdatesJournalProcessor.CreateForTableAdapter(
  ATableAdapter: TADDAptTableAdapter);
var
  oTab: TADDatSTable;
{$IFDEF AnyDAC_MONITOR}
  oConn: IADPhysConnection;
{$ENDIF}
  oCmd: IADPhysCommand;
begin
  inherited Create;
  FAdapter := ATableAdapter;
  oTab := ATableAdapter.GetDatSTable;
  if oTab <> nil then
    if oTab.UpdatesRegistry then
      FJournal := oTab.Updates
    else if (oTab.Manager <> nil) and oTab.Manager.UpdatesRegistry then
      FJournal := oTab.Manager.Updates;
  ASSERT(FJournal <> nil);
{$IFDEF AnyDAC_MONITOR}
  ATableAdapter.GetConn(oConn);
  if oConn <> nil then
    FMonitor := oConn.Monitor;
{$ENDIF}
  FUpdateHandler := ATableAdapter.GetUpdateHandler;
  ATableAdapter.GetCommand(arSelect, oCmd);
  FSilentMode := (oCmd <> nil) and oCmd.Options.ResourceOptions.ActualSilentMode;
end;

{-------------------------------------------------------------------------------}
destructor TADDAptUpdatesJournalProcessor.Destroy;
begin
  FAdapter := nil;
  FAdapters := nil;
  FJournal := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDAptUpdatesJournalProcessor.GetLimitToTable: TADDatSTable;
begin
  if FAdapter <> nil then
    Result := FAdapter.GetDatSTable
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDAptUpdatesJournalProcessor.LookupTableAdapter(ATable: TADDatSTable): IADDAptTableAdapter;
begin
  if FAdapter <> nil then begin
    ASSERT(FAdapter.GetDatSTable = ATable);
    Result := FAdapter as IADDAptTableAdapter;
  end
  else if FAdapters <> nil then
    Result := FAdapters.Lookup(ATable.Name, nkDatS)
  else
    Result := nil;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
function TADDAptUpdatesJournalProcessor.IsTracing: Boolean;
begin
  Result := (FMonitor <> nil) and FMonitor.Tracing;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptUpdatesJournalProcessor.Trace(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; const AMsg: String; const AArgs: array of const);
begin
  if IsTracing then
    FMonitor.Notify(AKind, AStep, Self, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDAptUpdatesJournalProcessor.Process(AMaxErrors: Integer): Integer;
var
  eAction: TADErrorAction;
  oRow, oNextRow: TADDatSRow;
  oTabAdapter: IADDAptTableAdapter;
  oWait: IADGUIxWaitCursor;

  function UpdateNoLocking(AUpdOpts: TADUpdateRowOptions): TADErrorAction;
  begin
    try
      Result := eaApplied;
      oTabAdapter.Update(oRow, Result, AUpdOpts);
    except
      Result := eaFail;
    end;
  end;

  function UpdateLocking(AUpdOpts, ALockOpts, AUnlockOpts: TADUpdateRowOptions): TADErrorAction;
  var
    eTmpAction, ePrevAction: TADErrorAction;
  begin
    ePrevAction := eaRetry; // impossible output value
    try
      Result := eaApplied;
      oTabAdapter.Lock(oRow, Result, ALockOpts);
      try
        if Result = eaApplied then begin
          oTabAdapter.Update(oRow, Result, AUpdOpts);
          ePrevAction := Result;
        end;
      finally
        if Result <> eaApplied then begin
          AUnlockOpts := AUnlockOpts + [uoCancelUnlock];
          if oRow.RowState = rsDeleted then
            AUnlockOpts := AUnlockOpts - [uoNoSrvRecord];
          eTmpAction := eaApplied;
          oTabAdapter.UnLock(oRow, eTmpAction, AUnlockOpts);
        end
        else
          oTabAdapter.UnLock(oRow, Result, AUnlockOpts);
        if ePrevAction <> eaRetry then
          Result := ePrevAction;
      end;
    except
      Result := eaFail;
    end;
  end;

begin
{$IFDEF AnyDAC_MONITOR}
  if IsTracing then
    if LimitToTable <> nil then
      Trace(ekAdaptUpdate, esStart, 'Process',
        ['LimitToTable', LimitToTable.SourceName])
    else
      Trace(ekAdaptUpdate, esStart, 'Process', []);
  try
{$ENDIF}
    if not FSilentMode then begin
      ADCreateInterface(IADGUIxWaitCursor, oWait);
      oWait.StartWait;
    end;
    Journal.Lock;
    try
      Result := 0;
      oRow := Journal.FirstChange(LimitToTable);
      while oRow <> nil do begin
        oNextRow := Journal.NextChange(oRow, LimitToTable);
        oTabAdapter := LookupTableAdapter(oRow.Table);
        if oTabAdapter <> nil then begin
          try
            case oRow.RowState of
            rsInserted: eAction := UpdateNoLocking([uoNoSrvRecord]);
            rsDeleted:  eAction := UpdateLocking([], [uoDeferredLock], [uoNoSrvRecord]);
            rsModified: eAction := UpdateLocking([], [uoDeferredLock], []);
            else        eAction := eaSkip;
            end;
          except
            eAction := eaFail;
          end;
          if eAction = eaFail then begin
            Inc(Result);
            if (AMaxErrors <> -1) and (Result > AMaxErrors) then
              Exit;
          end;
        end;
        oRow := oNextRow;
      end;
    finally
      Journal.Unlock;
      if not FSilentMode then
        oWait.StopWait;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if IsTracing then
      if LimitToTable <> nil then
        Trace(ekAdaptUpdate, esEnd, 'Process',
          ['LimitToTable', LimitToTable.SourceName])
      else
        Trace(ekAdaptUpdate, esEnd, 'Process', []);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADDAptUpdatesJournalProcessor.Reconcile: Boolean;
var
  oRow, oNextRow: TADDatSRow;
  eAction: TADDAptReconcileAction;
  oTabAdapter: IADDAptTableAdapter;
  eErrAction: TADErrorAction;
  oWait: IADGUIxWaitCursor;
begin
{$IFDEF AnyDAC_MONITOR}
  if IsTracing then
    if LimitToTable <> nil then
      Trace(ekAdaptUpdate, esStart, 'Reconcile',
        ['LimitToTable', LimitToTable.SourceName])
    else
      Trace(ekAdaptUpdate, esStart, 'Reconcile', []);
  try
{$ENDIF}
    if not FSilentMode then begin
      ADCreateInterface(IADGUIxWaitCursor, oWait);
      oWait.StartWait;
    end;
    if Journal <> nil then
      Journal.Lock;
    try
      if (Journal = nil) or not Assigned(FUpdateHandler) then begin
        if AutoMergeChangeLog and (Journal <> nil) then
          Journal.AcceptChanges(LimitToTable);
        Result := True;
        Exit;
      end;
      oRow := Journal.FirstChange(LimitToTable);
      if oRow = nil then begin
        if AutoMergeChangeLog then
          Journal.AcceptChanges(LimitToTable);
        Result := True;
        Exit;
      end;
      while oRow <> nil do begin
        oNextRow := Journal.NextChange(oRow, LimitToTable);
        oTabAdapter := LookupTableAdapter(oRow.Table);

        if (oTabAdapter <> nil) and oRow.HasErrors then begin
          if not FSilentMode then
            oWait.PushWait;
          try
            eAction := raMerge;
            FUpdateHandler.ReconcileRow(oRow, eAction);
          finally
            if not FSilentMode then
              oWait.PopWait;
          end;
          case eAction of
          raSkip:
            ;
          raAbort:
            Break;
          raMerge:
            begin
              oRow.ClearErrors;
              oRow.AcceptChanges;
            end;
          raCorrect:
            oRow.ClearErrors;
          raCancel:
            begin
              oRow.ClearErrors;
              oRow.RejectChanges;
            end;
          raRefresh:
            begin
              oRow.ClearErrors;
              eErrAction := eaApplied;
              oTabAdapter.Fetch(oRow, eErrAction, -1,
                [foClear] + ADGetFillRowOptions(oTabAdapter.Options.FetchOptions));
            end;
          end;
        end;

        oRow := oNextRow;
      end;
      Result := not Journal.HasChanges(LimitToTable);
    finally
      if Journal <> nil then
        Journal.Unlock;
      if not FSilentMode then
        oWait.StopWait;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if IsTracing then
      if LimitToTable <> nil then
        Trace(ekAdaptUpdate, esEnd, 'Reconcile',
          ['LimitToTable', LimitToTable.SourceName])
      else
        Trace(ekAdaptUpdate, esEnd, 'Reconcile', []);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ TADDAptTableAdapterMappingHandler                                             }
{-------------------------------------------------------------------------------}
type
  TADDAptTableAdapterMappingHandler = class(TInterfacedObject, IADPhysMappingHandler)
  private
    FTableAdapter: TADDAptTableAdapter;
  protected
    // IADPhysMappingHandler
    function MapRecordSet(const ATable: Variant; ATabNameKind: TADPhysNameKind;
      var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
      var ADatSTable: TADDatSTable): TADPhysMappingResult;
    function MapRecordSetColumn(const ATable: Variant; ATabNameKind: TADPhysNameKind;
      const AColumn: Variant; AColNameKind: TADPhysNameKind; var ASourceID: Integer;
      var ASourceName, ADatSName, AUpdateName: String;
      var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
  public
    constructor Create(ATableAdapter: TADDAptTableAdapter);
  end;

{-------------------------------------------------------------------------------}
constructor TADDAptTableAdapterMappingHandler.Create(ATableAdapter: TADDAptTableAdapter);
begin
  inherited Create;
  FTableAdapter := ATableAdapter;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapterMappingHandler.MapRecordSet(const ATable: Variant;
  ATabNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSTable: TADDatSTable): TADPhysMappingResult;
begin
  Result := FTableAdapter.MapRecordSet(ATable, ATabNameKind, ASourceID,
    ASourceName, ADatSName, AUpdateName, ADatSTable);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapterMappingHandler.MapRecordSetColumn(
  const ATable: Variant; ATabNameKind: TADPhysNameKind; const AColumn: Variant;
  AColNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
begin
  Result := FTableAdapter.MapRecordSetColumn(ATable, ATabNameKind, AColumn,
    AColNameKind, ASourceID, ASourceName, ADatSName, AUpdateName, ADatSColumn);
end;

{-------------------------------------------------------------------------------}
{ TADDAptTableAdapter                                                           }
{-------------------------------------------------------------------------------}
constructor TADDAptTableAdapter.CreateForSchema(AMappings: TADDAptTableAdapters);
begin
  inherited Create;
  FMappings := AMappings;
  if FMappings <> nil then
    FMappings.FItems.Add(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Initialize;
begin
  inherited Initialize;
  FBuffer := TADBuffer.Create;
  FColMappings := TADDAptColumnMappings.Create(nil);
  SetLength(FCommands, Integer(arFetchGenerators) - Integer(arSelect) + 1);
  FSourceRecordSetID := -1;
  FMappings := nil;
end;

{-------------------------------------------------------------------------------}
destructor TADDAptTableAdapter.Destroy;
begin
  ReleaseDatSTable;
  SetDatSManager(nil);
  ADFreeAndNil(FBuffer);
  SetLength(FCommands, 0);
  ADFreeAndNil(FColMappings);
  FErrorHandler := nil;
  FUpdateHandler := nil;
  if FMappings <> nil then begin
    FMappings.FItems.Remove(Self);
    FMappings := nil;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter._AddRef: Integer;
begin
  Result := ADAddRef;
  if FMappings <> nil then
    FMappings._AddRef;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter._Release: Integer;
begin
  Result := ADDecRef;
  if FMappings <> nil then
    Result := FMappings._Release
  else if Result = 0 then
    ADFree(Self);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetObj: TObject;
begin
  Result := Self;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetSchemaAdapter: TADDAptSchemaAdapter;
begin
  if FMappings <> nil then
    Result := FMappings.FSchemaAdapter
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetTableMappings: IADDAptTableAdapters;
begin
  if FMappings <> nil then
    Result := FMappings as IADDAptTableAdapters
  else
    Result := nil;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
// Tracing

function TADDAptTableAdapter.IsTracing: Boolean;
var
  oConn: IADPhysConnection;
begin
  GetConn(oConn);
  Result := (oConn <> nil) and oConn.Tracing;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Trace(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; const AMsg: String; const AArgs: array of const);
var
  oConn: IADPhysConnection;
begin
  GetConn(oConn);
  if (oConn <> nil) and oConn.Tracing then
    oConn.Monitor.Notify(AKind, AStep, Self, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetName: TComponentName;
begin
  Result := GetSourceRecordSetName + ': ' + ClassName + '($' +
    IntToHex(Integer(Self), 8) + ')';
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetParent: IADStanObject;
begin
  if (FMappings = nil) or (FMappings.FSchemaAdapter = nil) then
    Result := nil
  else
    Result := FMappings.FSchemaAdapter as IADStanObject;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
  { TODO -cDAPT : Schema adapter should call this method. Is "nothing" correct ? }
end;

{-------------------------------------------------------------------------------}
// Get/Set props

function TADDAptTableAdapter.GetOptions: IADStanOptions;
var
  oCmd: IADPhysCommand;
begin
  oCmd := GetSelectCommand;
  if oCmd = nil then
    Result := nil
  else
    Result := oCmd.Options;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetColumnMappings: TADDAptColumnMappings;
begin
  Result := FColMappings;
  Result.DatSTable := GetDatSTable;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetSourceRecordSetID: Integer;
begin
  Result := FSourceRecordSetID;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetSourceRecordSetID(const AValue: Integer);
begin
  if FSourceRecordSetID <> AValue then begin
    FSourceRecordSetID := AValue;
    if AValue >= 0 then
      FSourceRecordSetName := '';
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetSourceRecordSetName: String;
var
  oCmd: IADPhysCommand;
begin
  Result := FSourceRecordSetName;
  oCmd := GetSelectCommand;
  if (Result = '') and (oCmd <> nil) then
    Result := oCmd.SourceObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetSourceRecordSetName(const AValue: String);
begin
  if FSourceRecordSetName <> AValue then begin
    FSourceRecordSetName := AValue;
    if AValue <> '' then
      FSourceRecordSetID := -1;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateTableName: String;
begin
  Result := FUpdateTableName;
  if (Result = '') and (FDatSTable <> nil) then
    Result := FDatSTable.ActualOriginName;
  if Result = '' then
    Result := GetSourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetUpdateTableName(const AValue: String);
begin
  FUpdateTableName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetDatSTableName: String;
begin
  Result := FDatSTableName;
  if Result = '' then
    Result := GetSourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.ReleaseDatSTable;
begin
  if FDatSTable <> nil then begin
    FDatSTable.RemRef;
    FDatSTable := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.AttachDatSTable(ATable: TADDatSTable);
begin
  if FDatSTable <> ATable then begin
    ReleaseDatSTable;
    if ATable <> nil then
      ATable.AddRef;
    FDatSTable := ATable;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetDatSTableName(const AValue: String);
begin
  if FDatSTableName <> AValue then begin
    FDatSTableName := AValue;
    ReleaseDatSTable;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetDatSTable: TADDatSTable;
var
  i: Integer;
  oTabs: TADDatSTableList;
  sName: String;
begin
  if FDatSTable <> nil then
    Result := FDatSTable
  else begin
    Result := nil;
    if GetSchemaAdapter <> nil then begin
      sName := GetDatSTableName;
      if sName <> '' then begin
        oTabs := GetSchemaAdapter.GetDatSManager.Tables;
        i := oTabs.IndexOfName(sName);
        if i <> -1 then
          Result := oTabs.ItemsI[i];
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetDatSTable(AValue: TADDatSTable);
begin
  if FDatSTable <> AValue then begin
    AttachDatSTable(AValue);
    FDatSTableName := '';
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
begin
  Result := FMetaInfoMergeMode;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetMetaInfoMergeMode(const AValue: TADPhysMetaInfoMergeMode);
begin
  FMetaInfoMergeMode := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetDatSManager: TADDatSManager;
begin
  if GetSchemaAdapter <> nil then
    Result := GetSchemaAdapter.GetDatSManager
  else
    Result := FDatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetDatSManager(AValue: TADDatSManager);
begin
  if FDatSManager <> AValue then begin
    SetDatSTable(nil);
    if FDatSManager <> nil then
      FDatSManager.RemRef;
    FDatSManager := AValue;
    if FDatSManager <> nil then
      FDatSManager.AddRef;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.GetCommand(AReq: TADActionRequest; out ACmd: IADPhysCommand);
begin
  ACmd := FCommands[Integer(AReq) - Integer(arSelect)];
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetSelectCommand: IADPhysCommand;
begin
  GetCommand(arSelect, Result);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetDeleteCommand: IADPhysCommand;
begin
  GetCommand(arDelete, Result);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetFetchRowCommand: IADPhysCommand;
begin
  GetCommand(arFetchRow, Result);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetInsertCommand: IADPhysCommand;
begin
  GetCommand(arInsert, Result);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetLockCommand: IADPhysCommand;
begin
  GetCommand(arLock, Result);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUnlockCommand: IADPhysCommand;
begin
  GetCommand(arUnlock, Result);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateCommand: IADPhysCommand;
begin
  GetCommand(arUpdate, Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.UpdateCommands(AReason: TADDAptUpdateCommandReason);
var
  i: Integer;
  oCmd: IADPhysCommand;
begin
  if (FGeneratedCommands = []) and (AReason = urSetSelect) then
    Exit;
  for i := 0 to Length(FCommands) - 1 do begin
    oCmd := FCommands[i];
    if TADActionRequest(i + Integer(arSelect)) in FGeneratedCommands then begin
      Exclude(FGeneratedCommands, TADActionRequest(i + Integer(arSelect)));
      if oCmd <> nil then
        FCommands[i] := nil;
    end
    else if oCmd <> nil then
      case AReason of
      urSetSelect:
        ;
      urSetErrorHandler:
        begin
          oCmd.ErrorHandler := GetErrorHandler;
          oCmd.MappingHandler := TADDAptTableAdapterMappingHandler.Create(Self) as
            IADPhysMappingHandler;
        end;
      urReset:
        oCmd.Disconnect;
      urSetTransaction:
        if (TADActionRequest(i + Integer(arSelect)) = arSelect) and
           (oCmd.Transaction <> GetTransaction) then begin
          oCmd.Disconnect;
          oCmd.Transaction := GetTransaction;
        end;
      urSetUpdateTransaction:
        if (TADActionRequest(i + Integer(arSelect)) <> arSelect) and
           (oCmd.Transaction <> GetUpdateTransaction) then begin
          oCmd.Disconnect;
          oCmd.Transaction := GetUpdateTransaction;
        end;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.InternalSetCommand(AReq: TADActionRequest; const ACmd: IADPhysCommand);
begin
  if Length(FCommands) <> 0 then
    FCommands[Integer(AReq) - Integer(arSelect)] := ACmd;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.SetCommand(AReq: TADActionRequest; const ACmd: IADPhysCommand): Boolean;
var
  oCmd: IADPhysCommand;
begin
  Result := False;
  GetCommand(AReq, oCmd);
  if oCmd <> ACmd then begin
    if oCmd <> nil then begin
      oCmd.ErrorHandler := nil;
      oCmd.MappingHandler := nil;
    end;
    InternalSetCommand(AReq, ACmd);
    if ACmd <> nil then begin
      ACmd.ErrorHandler := GetErrorHandler;
      ACmd.MappingHandler := TADDAptTableAdapterMappingHandler.Create(Self) as
        IADPhysMappingHandler;
      Exclude(FGeneratedCommands, AReq);
    end
    else
      Include(FGeneratedCommands, AReq);
    Result := True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.GetConn(out AConn: IADPhysConnection);
var
  oCmd: IADPhysCommand;
begin
  oCmd := GetSelectCommand;
  if oCmd <> nil then
    AConn := oCmd.Connection
  else
    AConn := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.GetUpdTx(out ATx: IADPhysTransaction);
var
  oCmd: IADPhysCommand;
  oConn: IADPhysConnection;
begin
  ATx := GetUpdateTransaction;
  if ATx = nil then begin
    ATx := GetTransaction;
    if ATx = nil then begin
      oCmd := GetSelectCommand;
      if oCmd <> nil then begin
        ATx := oCmd.Transaction;
        if ATx = nil then begin
          oConn := oCmd.Connection;
          if oConn <> nil then
            ATx := oConn.Transaction;
        end;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetSelectCommand(const ACmd: IADPhysCommand);
begin
  if SetCommand(arSelect, ACmd) then
    UpdateCommands(urSetSelect);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetDeleteCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arDelete, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetFetchRowCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arFetchRow, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetInsertCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arInsert, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetLockCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arLock, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetUnlockCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arUnlock, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetUpdateCommand(const ACmd: IADPhysCommand);
begin
  SetCommand(arUpdate, ACmd);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.CheckSelectCommand;
begin
  if GetSelectCommand = nil then
    ADException(Self, [S_AD_LDApt], er_AD_DAptNoSelectCmd, []);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetTransaction: IADPhysTransaction;
var
  oManAdapt: TADDAptSchemaAdapter;
begin
  if FTransaction <> nil then
    Result := FTransaction
  else begin
    oManAdapt := GetSchemaAdapter;
    if oManAdapt <> nil then
      Result := oManAdapt.GetTransaction
    else
      Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetTransaction(const AValue: IADPhysTransaction);
begin
  if FTransaction <> AValue then begin
    FTransaction := AValue;
    UpdateCommands(urSetTransaction);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateTransaction: IADPhysTransaction;
var
  oManAdapt: TADDAptSchemaAdapter;
begin
  if FUpdateTransaction <> nil then
    Result := FUpdateTransaction
  else begin
    oManAdapt := GetSchemaAdapter;
    if oManAdapt <> nil then
      Result := oManAdapt.GetUpdateTransaction
    else
      Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetUpdateTransaction(const AValue: IADPhysTransaction);
begin
  if FUpdateTransaction <> AValue then begin
    FUpdateTransaction := AValue;
    UpdateCommands(urSetUpdateTransaction);
  end;
end;

{-------------------------------------------------------------------------------}
// Exception handling

procedure TADDAptTableAdapter.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
begin
{$IFDEF AnyDAC_MONITOR}
  if not (AException is EADDBEngineException) and IsTracing then
    Trace(ekError, esProgress, AException.Message, []);
{$ENDIF}
  if Assigned(GetErrorHandler()) then
    GetErrorHandler().HandleException(AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetErrorHandler: IADStanErrorHandler;
var
  oManAdapt: TADDAptSchemaAdapter;
begin
  if FErrorHandler <> nil then
    Result := FErrorHandler
  else begin
    oManAdapt := GetSchemaAdapter;
    if oManAdapt <> nil then
      Result := oManAdapt.GetErrorHandler
    else
      Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetErrorHandler(const AValue: IADStanErrorHandler);
begin
  FErrorHandler := AValue;
  UpdateCommands(urSetErrorHandler);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateHandler: IADDAptUpdateHandler;
var
  oManAdapt: TADDAptSchemaAdapter;
begin
  if FUpdateHandler <> nil then
    Result := FUpdateHandler
  else begin
    oManAdapt := GetSchemaAdapter;
    if oManAdapt <> nil then
      Result := oManAdapt.GetUpdateHandler
    else
      Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetUpdateHandler(const AValue: IADDAptUpdateHandler);
begin
  FUpdateHandler := AValue;
end;

{-------------------------------------------------------------------------------}
// Mapping handling

function TADDAptTableAdapter.MatchRecordSet(const ATable: Variant;
  ATabNameKind: TADPhysNameKind): Boolean;
var
  oTab: TADDatSTable;
begin
  case ATabNameKind of
  nkID:
    Result := GetSourceRecordSetID = ATable;
  nkSource:
    Result := {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
      (ATable, GetSourceRecordSetName) = 0;
  nkDatS:
    Result := {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
      (ATable, GetDatSTableName) = 0;
  nkObj:
    begin
      oTab := TADDatSTable(TADNativeUInt(ATable));
      Result :=
        (GetDatSTable <> nil) and (GetDatSTable = oTab) or
        (GetSourceRecordSetID <> -1) and (GetSourceRecordSetID = oTab.SourceID) or
        (GetSourceRecordSetName <> '') and (
          {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
          (GetSourceRecordSetName, oTab.SourceName) = 0) or
        (GetDatSTableName <> '') and (
          {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
          (GetDatSTableName, oTab.Name) = 0);
    end;
  nkDefault:
    Result := True;
  else
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADGetRecordSetInfo(const AAdapter: IADDAptTableAdapter;
  var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
  var ADatSTable: TADDatSTable);
var
  oTab: TADDatSTable;
  sName: String;
begin
  if AAdapter.SourceRecordSetID <> -1 then
    ASourceID := AAdapter.SourceRecordSetID;
  sName := AAdapter.SourceRecordSetName;
  if sName <> '' then
    ASourceName := sName;
  sName := AAdapter.DatSTableName;
  if sName <> '' then
    ADatSName := sName;
  sName := AAdapter.UpdateTableName;
  if sName <> '' then
    AUpdateName := sName;
  oTab := AAdapter.DatSTable;
  if oTab <> nil then
    ADatSTable := oTab;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.MapRecordSet(const ATable: Variant;
  ATabNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSTable: TADDatSTable): TADPhysMappingResult;
begin
  if (GetSchemaAdapter <> nil) and (ATabNameKind <> nkDefault) then
    Result := GetSchemaAdapter.MapRecordSet(ATable, ATabNameKind, ASourceID,
      ASourceName, ADatSName, AUpdateName, ADatSTable)
  else if MatchRecordSet(ATable, ATabNameKind) then begin
    Result := mrMapped;
    ADGetRecordSetInfo(Self as IADDAptTableAdapter, ASourceID,
      ASourceName, ADatSName, AUpdateName, ADatSTable);
  end
  else
    Result := mrNotMapped;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.MapRecordSetColumn(const ATable: Variant;
  ATabNameKind: TADPhysNameKind; const AColumn: Variant; AColNameKind: TADPhysNameKind;
  var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
  var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
var
  oColMap: TADDAptColumnMapping;
begin
  Result := mrNotMapped;
  if GetSchemaAdapter <> nil then
    Result := GetSchemaAdapter.MapRecordSetColumn(ATable, ATabNameKind,
      AColumn, AColNameKind, ASourceID, ASourceName, ADatSName, AUpdateName,
      ADatSColumn)
  else if MatchRecordSet(ATable, ATabNameKind) then
    if (GetColumnMappings = nil) or (GetColumnMappings.Count = 0) then
      Result := mrDefault
    else begin
      oColMap := GetColumnMappings.Lookup(AColumn, AColNameKind);
      if oColMap <> nil then begin
        Result := mrMapped;
        ADGetRecordSetColumnInfo(oColMap, ASourceID, ASourceName, ADatSName,
          AUpdateName, ADatSColumn);
      end;
    end;
end;

{-------------------------------------------------------------------------------}
// Command generation

procedure TADDAptTableAdapter.ParName2Col(ABaseRow: TADDatSRow; const AName: String;
  var ACol: TADDatSColumn; var ARow: TADDatSRow; var AVersion: Integer);
var
  i, i1, iCol, iKind, iUCNameLen: Integer;
  sUCName: String;
begin
  sUCName := UpperCase(AName);
  iUCNameLen := Length(sUCName);
  if StrLIComp(PChar(sUCName), PChar('NEW_P$_'), 7) = 0 then begin
    iKind := 1;
    AVersion := 1;
    i := 6;
  end
  else if StrLComp(PChar(sUCName), PChar('OLD_P$_'), 7) = 0 then begin
    iKind := 1;
    AVersion := -1;
    i := 6;
  end
  else if StrLComp(PChar(sUCName), PChar('NEW_'), 4) = 0 then begin
    iKind := 2;
    AVersion := 1;
    i := 6;
  end
  else if StrLComp(PChar(sUCName), PChar('OLD_'), 4) = 0 then begin
    iKind := 2;
    AVersion := -1;
    i := 6;
  end
  else begin
    iKind := 0;
    AVersion := 0;
    i := 1;
  end;
  ACol := nil;
  ARow := nil;
  if iKind = 1 then begin
    while (i + 2 <= iUCNameLen) and (sUCName[i] <> '#') and (sUCName[i] = '$') and (sUCName[i + 1] = '_') do begin
      Inc(i, 2);
      i1 := i;
      while (i <= iUCNameLen) and (sUCName[i] >= '0') and (sUCName[i] <= '9') do
        Inc(i);
      iCol := StrToInt(Copy(sUCName, i1, i - i1));
      if (ACol = nil) and (ARow = nil) then begin
        ARow := ABaseRow;
        ACol := ARow.Table.Columns[iCol];
      end
      else begin
        if ARow <> nil then
          ARow := ARow.NestedRow[ACol.Index];
        ACol := ACol.NestedTable.Columns[iCol];
      end;
    end;
  end
  else if iKind = 2 then begin
    ARow := ABaseRow;
    // See comment in TADPhysCommandGenerator.AddColumnParam
    i := Pos('$#', sUCName);
    if i = 0 then
      i := MAXINT;
    ACol := ARow.Table.Columns.ColumnByName(Copy(sUCName, 5, i - 5));
  end
  else if iKind = 0 then begin
    ARow := ABaseRow;
    i := ARow.Table.Columns.IndexOfName(sUCName);
    if i <> -1 then
      ACol := ARow.Table.Columns[i];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.SetParamsFromRow(AParams: TADParams; ARow: TADDatSRow);
var
  i, iVersion: Integer;
  eRowVersion: TADDatSRowVersion;
  oPar: TADParam;
  oCol: TADDatSColumn;
  oRow: TADDatSRow;
  pBuff: Pointer;
  iLen, iFldSize: LongWord;
  iFldPrec, iFldScale: Integer;
  eFldType: TFieldType;
  oFmtOpts: TADFormatOptions;
begin
  oFmtOpts := GetOptions.FormatOptions;
  for i := 0 to AParams.Count - 1 do begin
    oPar := AParams[I];
    if oPar.ParamType in [ptUnknown, ptInput, ptInputOutput] then begin
      oCol := nil;
      oRow := nil;
      iVersion := -1;
      pBuff := nil;
      iLen := 0;
      ParName2Col(ARow, oPar.Name, oCol, oRow, iVersion);
      if oCol <> nil then begin
        case iVersion of
        -1:  eRowVersion := rvOriginal;
         1:  eRowVersion := rvCurrent;
        else eRowVersion := rvDefault;
        end;
        if oRow <> nil then
          oRow.GetData(oCol.Index, eRowVersion, pBuff, 0, iLen, False);
        oFmtOpts.ColumnDef2FieldDef(oCol.DataType, oCol.Size,
          oCol.Precision, oCol.Scale, oCol.Attributes, eFldType,
          iFldSize, iFldPrec, iFldScale);
        if (oPar.DataType = ftUnknown) or (oPar.DataType <> eFldType) then begin
          oPar.DataType := eFldType;
          if oPar.ADDataType = dtUnknown then
            oPar.ADDataType := oCol.DataType;
          oPar.Precision := iFldPrec;
          oPar.NumericScale := iFldScale;
          oPar.Size := iFldSize;
        end;
        oPar.SetData(pBuff, iLen, -1);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.MergeRows(const ACommand: IADPhysCommand;
  ABaseRow, AFetchedRow: TADDatSRow; AClearRow: Boolean);
var
  i, iBaseCol: Integer;
  oBaseCols, oFetchedCols: TADDatSColumnList;
  pBuff: Pointer;
  iLen: LongWord;
  lRefreshing, lLoadingData, lCtrlEditing: Boolean;
  rState: TADDatSLoadState;
begin
  lRefreshing := (ABaseRow.RowState = rsUnchanged);
  lLoadingData := False;
  lCtrlEditing := not (ABaseRow.RowState in [rsDetached, rsForceWrite]) or AClearRow;
  ABaseRow.Table.BeginLoadData(rState, lmRefreshing);
  try
    try
      oBaseCols := ABaseRow.Table.Columns;
      oFetchedCols := AFetchedRow.Table.Columns;
      for i := 0 to oFetchedCols.Count - 1 do begin
        iBaseCol := oBaseCols.IndexOfSourceName(oFetchedCols[i].SourceName);
        if iBaseCol <> -1 then begin
          if not lLoadingData then begin
            lLoadingData := True;
            if lCtrlEditing then begin
              ABaseRow.BeginEdit;
              if AClearRow then
                ABaseRow.Erase;
            end;
          end;
          if oBaseCols.ItemsI[iBaseCol].DataType = oFetchedCols.ItemsI[i].DataType then begin
            pBuff := nil;
            iLen := 0;
            AFetchedRow.GetData(i, rvDefault, pBuff, 0, iLen, False);
            ABaseRow.SetData(iBaseCol, pBuff, iLen);
          end
          else
            ABaseRow.SetData(iBaseCol, AFetchedRow.GetData(i, rvDefault));
          if caAutoInc in oBaseCols.ItemsI[iBaseCol].ActualAttributes then
            ACommand.Connection.SaveLastAutoGenValue(AFetchedRow.GetData(i, rvDefault));
        end;
      end;
      if lLoadingData and lCtrlEditing then begin
        ABaseRow.EndEdit;
        if lRefreshing then
          ABaseRow.AcceptChanges(False);
      end;
    except
      if lLoadingData and lCtrlEditing then
        ABaseRow.CancelEdit;
      raise;
    end;
  finally
    ABaseRow.Table.EndLoadData(rState);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.MergeRowFromParams(const ACommand: IADPhysCommand;
  ABaseRow: TADDatSRow; AFetchedParams: TADParams; AClearRow: Boolean);
var
  i: Integer;
  oCol: TADDatSColumn;
  oRow: TADDatSRow;
  iVersion: Integer;
  lRefreshing, lLoadingData, lCtrlEditing: Boolean;
  rState: TADDatSLoadState;
begin
  lRefreshing := (ABaseRow.RowState = rsUnchanged);
  lLoadingData := False;
  lCtrlEditing := not (ABaseRow.RowState in [rsDetached, rsForceWrite]) or AClearRow;
  ABaseRow.Table.BeginLoadData(rState, lmRefreshing);
  try
    try
      for i := 0 to AFetchedParams.Count - 1 do
        if AFetchedParams[i].ParamType in [ptOutput, ptInputOutput] then begin
          oCol := nil;
          oRow := nil;
          iVersion := -1;
          ParName2Col(ABaseRow, AFetchedParams[i].Name, oCol, oRow, iVersion);
          if (oRow <> nil) and (oCol <> nil) and (iVersion = 1) then begin
            if not lLoadingData then begin
              lLoadingData := True;
              if lCtrlEditing then begin
                ABaseRow.BeginEdit;
                if AClearRow then
                  ABaseRow.Erase;
              end;
            end;
            oRow.SetData(oCol.Index, AFetchedParams[i].Value);
            if caAutoInc in oCol.ActualAttributes then
              ACommand.Connection.SaveLastAutoGenValue(AFetchedParams[i].Value);
          end;
        end;
      if lLoadingData and lCtrlEditing then begin
        ABaseRow.EndEdit;
        if lRefreshing then
          ABaseRow.AcceptChanges(False);
      end;
    except
      if lLoadingData and lCtrlEditing then
        ABaseRow.CancelEdit;
      raise;
    end;
  finally
    ABaseRow.Table.EndLoadData(rState);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.ProcessRequest(const ACommand: IADPhysCommand;
  ARow: TADDatSRow; ARequest: TADUpdateRequest; AUpdRowOptions: TADUpdateRowOptions;
  AFillRowOptions: TADPhysFillRowOptions; AWrapByTX: Boolean);
var
  oTab: TADDatSTable;
  lOpen, lClearErrorHandler: Boolean;

  procedure ErrorRecordIsDeleted(ARowsCount: Integer);
  const
    SOper: array[TADUpdateRequest] of String = ('Insert', 'Update',
      'Delete', 'Lock', 'Unlock', 'Fetch', 'UpdateHBlobs', 'DeleteAll',
      'FetchGenerators');
  var
    s, sReasons: String;
  begin
    s := LowerCase(SOper[ARequest]);
    if s[Length(s)] = 'e' then
      s := s + 'd'
    else
      s := s + 'ed';
    if ACommand.Connection.Messages <> nil then
      sReasons := ACommand.Connection.Messages.Errors[0].Message
    else
      sReasons := S_AD_DAptRecordIsDeletedReasons;
    ADException(Self, [S_AD_LDApt], er_AD_DAptRecordIsDeleted,
      [SOper[ARequest], s, ARowsCount, sReasons]);
  end;

begin
{$IFDEF AnyDAC_MONITOR}
  if IsTracing then
    if ARow <> nil then
      Trace(ekAdaptUpdate, esStart, 'ProcessRequest',
        ['ARow.Table.Name', ARow.Table.SourceName])
    else
      Trace(ekAdaptUpdate, esStart, 'ProcessRequest', []);
  try
{$ENDIF}
    if ACommand.ErrorHandler = nil then begin
      lClearErrorHandler := True;
      ACommand.ErrorHandler := Self as IADStanErrorHandler;
    end
    else
      lClearErrorHandler := False;
    try
      try
        ACommand.CloseAll;
        if ACommand.CommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
          if ACommand.State = csInactive then
            ACommand.Prepare;
          SetParamsFromRow(ACommand.Params, ARow);
        end
        else begin
          SetParamsFromRow(ACommand.Params, ARow);
          if ACommand.State = csInactive then
            ACommand.Prepare;
        end;
        if GetSelectCommand <> nil then
          ACommand.SourceRecordSetName := GetSelectCommand.SourceRecordSetName;
        lOpen := (ACommand.CommandKind in [skSelect, skSelectForLock, skSelectForUnLock,
          skStoredProcWithCrs]);
        while ACommand.State <> csInactive do begin
          if lOpen then begin
            ACommand.Open;
            if ACommand.State <> csOpen then
              Break;
            oTab := TADDatSTable.Create;
            try
              ACommand.Define(oTab, mmReset);
              ACommand.Fetch(oTab, True);
              if ARequest = arLock then begin
                // Dont compare server side SELECT item values with client
                // columns values - there always will be rounding errors.
                // Instead use correct UpdateMode to build WHERE and lets
                // server perform a comparision.
                if oTab.Rows.Count <> 1 then
                  if ACommand.Options.UpdateOptions.CountUpdatedRecords then
                    ErrorRecordIsDeleted(oTab.Rows.Count);
              end
              else if ARequest in [arFetchRow, arInsert, arUpdate, arFetchGenerators] then begin
                if oTab.Rows.Count <> 1 then
                  if ACommand.Options.UpdateOptions.CountUpdatedRecords then
                    ErrorRecordIsDeleted(oTab.Rows.Count);
                if oTab.Rows.Count > 0 then
                  MergeRows(ACommand, ARow, oTab.Rows[0], foClear in AFillRowOptions);
              end;
            finally
              ADFree(oTab);
            end;
          end
          else begin
            ACommand.Execute;
            if ACommand.RowsAffectedReal and (ACommand.RowsAffected <> 1) and
               ACommand.Options.UpdateOptions.CountUpdatedRecords then
              ErrorRecordIsDeleted(ACommand.RowsAffected);
            if ARequest in [arInsert, arUpdate, arFetchRow, arUpdateHBlobs] then
              MergeRowFromParams(ACommand, ARow, ACommand.Params, foClear in AFillRowOptions);
          end;
          ACommand.NextRecordSet := True;
          lOpen := True;
        end;
      except
        on E: EADDBEngineException do begin
          if ARequest in [arInsert, arUpdate, arDelete, arLock, arUnlock,
                          arUpdateHBlobs, arFetchGenerators] then
            ARow.RowError := E;
          if E.Kind in [ekNoDataFound, ekTooManyRows] then begin
            if ACommand.Options.UpdateOptions.CountUpdatedRecords then
              ErrorRecordIsDeleted(ACommand.RowsAffected);
          end
          else
            raise;
        end;
        on E: EADException do begin
          if ARequest in [arInsert, arUpdate, arDelete, arLock, arUnlock,
                          arUpdateHBlobs, arFetchGenerators] then
            ARow.RowError := E;
          raise;
        end;
      end;
    finally
      ACommand.CloseAll;
      if lClearErrorHandler then
        ACommand.ErrorHandler := nil;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if IsTracing then
      if ARow <> nil then
        Trace(ekAdaptUpdate, esEnd, 'ProcessRequest',
          ['ARow.Table.Name', ARow.Table.SourceName])
      else
        Trace(ekAdaptUpdate, esEnd, 'ProcessRequest', []);
  end;
{$ENDIF}
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateRequestName(ARequest: TADUpdateRequest): String;
begin
  case ARequest of
  arLock:            Result := 'Lock';
  arUnLock:          Result := 'UnLock';
  arInsert:          Result := 'Insert';
  arDelete:          Result := 'Delete';
  arUpdate:          Result := 'Update';
  arUpdateHBlobs:    Result := 'UpdateHBlobs';
  arFetchRow:        Result := 'FetchRow';
  arFetchGenerators: Result := 'FetchGenerators';
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.GetUpdateRowCommand(ARow: TADDatSRow;
  AUpdRowOptions: TADUpdateRowOptions; AUpdateRequest: TADUpdateRequest;
  AFillRowOptions: TADPhysFillRowOptions; AColumn: Integer; ACacheCommand: Boolean;
  var AFlags: TADPhysCommandGeneratorFlags): IADPhysCommand;
var
  oConn: IADPhysConnection;
  oTx: IADPhysTransaction;
{$IFDEF AnyDAC_MONITOR}
  oObjIntf: IADStanObject;
{$ENDIF}
  eCommandKind: TADPhysCommandKind;
  oCmdGen: IADPhysCommandGenerator;
  oConnMeta: IADPhysConnectionMetadata;
  oMeta: IADPhysConnectionMetadata;
  oRes: TADResourceOptions;
  oFtch: TADFetchOptions;
  oUpd: TADUpdateOptions;
begin
  GetConn(oConn);
  oConn.CreateMetadata(oMeta);
  if (AUpdateRequest = arUnlock) and not oMeta.IsFileBased then
    Exit;
  GetUpdTx(oTx);
  oConn.CreateCommand(Result);
  Result.Transaction := oTx;
{$IFDEF AnyDAC_MONITOR}
  Supports(Result, IADStanObject, oObjIntf);
  oObjIntf.SetOwner(Self, GetUpdateRequestName(AUpdateRequest));
{$ENDIF}
  oRes := Result.Options.ResourceOptions;
  oFtch := Result.Options.FetchOptions;
  oUpd := Result.Options.UpdateOptions;
  oRes.ParamCreate := False;
  oRes.MacroCreate := False;
  Result.Params.BindMode := pbByNumber;

  oConn.CreateCommandGenerator(oCmdGen, nil);
  oCmdGen.Options := GetOptions;
  oCmdGen.Table := ARow.Table;
  oCmdGen.Row := ARow;
  oCmdGen.Params := Result.Params;
  oCmdGen.MappingHandler := TADDAptTableAdapterMappingHandler.Create(Self) as
    IADPhysMappingHandler;
  if AColumn <> -1 then
    oCmdGen.Column := ARow.Table.Columns[AColumn]
  else
    oCmdGen.Column := nil;
  oCmdGen.UpdateRowOptions := AUpdRowOptions;
  oCmdGen.FillRowOptions := AFillRowOptions;
  case AUpdateRequest of
  arInsert:          Result.CommandText := oCmdGen.GenerateInsert;
  arUpdate:          Result.CommandText := oCmdGen.GenerateUpdate;
  arDelete:          Result.CommandText := oCmdGen.GenerateDelete;
  arLock:            Result.CommandText := oCmdGen.GenerateLock;
  arUnlock:          Result.CommandText := oCmdGen.GenerateUnLock;
  arUpdateHBlobs:    Result.CommandText := oCmdGen.GenerateUpdateHBlobs;
  arFetchRow:        Result.CommandText := oCmdGen.GenerateSelect([foAfterIns, foAfterUpd] * AFillRowOptions = []);
  arFetchGenerators: Result.CommandText := oCmdGen.GenerateFetchGenerators;
  end;
  eCommandKind := oCmdGen.CommandKind;
  AFlags := oCmdGen.Flags;

  if Result.CommandText = '' then
    Result := nil
  else begin
    Result.CommandKind := eCommandKind;
    Result.Options.FormatOptions.Assign(GetOptions.FormatOptions);
    Result.Options.FetchOptions.Assign(GetOptions.FetchOptions);
    Result.Options.UpdateOptions.Assign(GetOptions.UpdateOptions);
    Result.Options.ResourceOptions.Assign(GetOptions.ResourceOptions);

    if oRes.CmdExecMode = amAsync then
      oRes.CmdExecMode := amBlocking;
    if (AUpdateRequest = arLock) and
       (oUpd.LockMode = lmPessimistic) and not oUpd.LockWait then begin
      oConn.CreateMetadata(oConnMeta);
      if not oConnMeta.LockNoWait and oConnMeta.AsyncAbortSupported then
        oRes.CmdExecTimeout := 1000
      else
        oRes.CmdExecTimeout := $FFFFFFFF;
    end;
    oRes.ParamCreate := False;
    oRes.ParamExpand := True;
    oRes.MacroCreate := False;
    oRes.MacroExpand := False;
    oRes.EscapeExpand := False;
    if not ACacheCommand then
      oRes.DirectExecute := True;

    oFtch.Mode := fmExactRecsMax;
    oFtch.RecsMax := 1;
    oFtch.Items := [];
    if foBlobs in AFillRowOptions then
      oFtch.Items := oFtch.Items + [fiBlobs];
    if foDetails in AFillRowOptions then
      oFtch.Items := oFtch.Items + [fiDetails];
    oFtch.Cache := [];
    oFtch.AutoClose := True;
    oFtch.AutoFetchAll := afAll;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.ProcessUpdate(ARow: TADDatSRow; var AAction: TADErrorAction;
  ARequest: TADUpdateRequest; AUpdRowOptions: TADUpdateRowOptions;
  AFillRowOptions: TADPhysFillRowOptions; AColumn: Integer);
var
  oConn: IADPhysConnection;
  oTx: IADPhysTransaction;
  iLockID: LongWord;
  lEndTX, lSavepoint: Boolean;
  oCmd: IADPhysCommand;
  oMeta: IADPhysConnectionMetadata;
  eFillOpts: TADPhysFillRowOptions;
  lCacheUpdateCommand: Boolean;
  eCmdFlags: TADPhysCommandGeneratorFlags;
  oUpdOpts: TADUpdateOptions;
  oExc: Exception;
{$IFDEF AnyDAC_MONITOR}
  sCaller, sTabName: String;
{$ENDIF}
  lCustomFetchRow: Boolean;
begin
  try
    CheckSelectCommand;
  except
    AAction := eaExitFailure;
    raise;
  end;

  AAction := eaApplied;
  oUpdOpts := GetOptions.UpdateOptions;
  if not oUpdOpts.CheckRequest(ARequest, AUpdRowOptions, False) then
    Exit;

  eCmdFlags := [];
  lCacheUpdateCommand := False;
  oCmd := nil;
  iLockID := $FFFFFFFF;
  GetConn(oConn);
  GetUpdTx(oTx);
  oConn.CreateMetadata(oMeta);
  AAction := eaDefault;

{$IFDEF AnyDAC_MONITOR}
  sCaller := GetUpdateRequestName(ARequest);
  sTabName := '';
  if IsTracing then
    if ARow <> nil then begin
      sTabName := ARow.Table.SourceName;
      Trace(ekAdaptUpdate, esStart, sCaller, ['ARow.Table.Name', sTabName]);
    end
    else
      Trace(ekAdaptUpdate, esStart, sCaller, []);
{$ENDIF}
  oTX.LockAutoStop;
  try
    // get existing command
    if not (ARequest in FGeneratedCommands) then
      GetCommand(ARequest, oCmd);
    if oCmd = nil then begin
      lCacheUpdateCommand :=
        (ARequest = arFetchGenerators) or
        (oUpdOpts.LockMode = lmNone) and not oUpdOpts.UpdateChangedFields and (
          (ARequest = arInsert) or
          (ARequest = arUpdate) and (oUpdOpts.UpdateMode = upWhereKeyOnly) or
          (ARequest = arDelete) and (oUpdOpts.UpdateMode = upWhereKeyOnly));
      if lCacheUpdateCommand then
        GetCommand(ARequest, oCmd)
      else begin
        InternalSetCommand(ARequest, nil);
        oCmd := nil;
      end;
    end;

    repeat
      try
        if not FInUpdateRowHandler and (GetUpdateHandler <> nil) then begin
          FInUpdateRowHandler := True;
          try
            GetUpdateHandler.UpdateRow(ARow, ARequest, AUpdRowOptions, AAction);
            if AAction <> eaDefault then
              lCacheUpdateCommand := False;
          finally
            FInUpdateRowHandler := False;
          end;
        end;
        if AAction in [eaRetry, eaDefault] then begin
          AAction := eaDefault;

          // build command if required
          if oCmd = nil then
            case ARequest of
            arLock:
              begin
                if oUpdOpts.LockMode <> lmNone then begin
                  if (oUpdOpts.LockMode = lmPessimistic) and oMeta.TxSupported and not oTx.Active then
                    iLockID := oTx.StartTransaction;
                  if not (uoNoSrvRecord in AUpdRowOptions) and (ARow.DBLockID = 0) then
                    oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arLock,
                      [foData, foBlobs, foDetails, foUpdatable], -1, lCacheUpdateCommand,
                      eCmdFlags);
                end;
              end;
            arUnLock:
              begin
                if (oUpdOpts.LockMode <> lmNone) and not (uoNoSrvRecord in AUpdRowOptions) and
                   (ARow.DBLockID <> 0) then
                  oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arUnLock,
                    [foData, foBlobs, foDetails, foUpdatable, foAfterUpd], -1, lCacheUpdateCommand,
                    eCmdFlags);
              end;
            arInsert:
              begin
                if not oUpdOpts.EnableInsert then
                  ADException(Self, [S_AD_LDApt], er_AD_DAptCantInsert, []);
                oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arInsert,
                  [], -1, lCacheUpdateCommand, eCmdFlags);
                if gfFetchGenerator in eCmdFlags then begin
                  ProcessUpdate(ARow, AAction, arFetchGenerators,
                    AUpdRowOptions + [uoDeferredGenGet], [], -1);
                  if not (AAction in [eaApplied, eaDefault]) then
                    oCmd := nil;
                end;
              end;
            arDelete:
              begin
                if not oUpdOpts.EnableDelete then
                  ADException(Self, [S_AD_LDApt], er_AD_DAptCantDelete, []);
                oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arDelete,
                  [], -1, lCacheUpdateCommand, eCmdFlags);
              end;
            arUpdate:
              begin
                if not oUpdOpts.EnableUpdate then
                  ADException(Self, [S_AD_LDApt], er_AD_DAptCantEdit, []);
                oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arUpdate,
                  [], -1, lCacheUpdateCommand, eCmdFlags);
              end;
            arUpdateHBlobs:
              begin
                if not oUpdOpts.EnableInsert then
                  ADException(Self, [S_AD_LDApt], er_AD_DAptCantInsert, []);
                oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arUpdateHBlobs,
                  [], -1, lCacheUpdateCommand, eCmdFlags);
              end;
            arFetchRow:
              begin
                if ARow.RowState in [rsInserted, rsDeleted, rsModified, rsUnchanged] then
                  oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arFetchRow,
                    AFillRowOptions, AColumn, lCacheUpdateCommand, eCmdFlags);
              end;
            arFetchGenerators:
              begin
                if not oMeta.GeneratorSupported then
                  oCmd := nil
                else
                  oCmd := GetUpdateRowCommand(ARow, AUpdRowOptions, arFetchGenerators,
                    [], -1, lCacheUpdateCommand, eCmdFlags);
              end;
            end;
          if (oCmd = nil) and (AAction = eaDefault) then
            if ARequest in [arDelete, arInsert] then
              AAction := eaFail
            else
              AAction := eaApplied;

          // process command if required
          if oCmd <> nil then begin
            // When transaction is active, DBMS has atomic transactions (PostgreSQL) and
            // a command fails, then full transaction is marked as "invalid" and no
            // more actions are possible - only Rollback. With pessimistic locking, if
            // Post has failed, then user cannot change a data and do another Post. To
            // unify behaviour with other DBMS's, FireDAC surrounds editing commands into
            // savepoints.
            lSavepoint := oTx.Active and oMeta.TxAtomic and
               (oMeta.TxNested or oMeta.TxSavepoints);
            if lSavepoint then
              oTx.StartTransaction;
            try
              ProcessRequest(oCmd, ARow, ARequest, AUpdRowOptions, AFillRowOptions,
                (ARequest in [arUpdate, arDelete]) and (oUpdOpts.LockMode <> lmNone));
              if lSavepoint then
                oTx.Commit;
            except
              if lSavepoint or (iLockID <> $FFFFFFFF) then
                oTx.Rollback;
              raise;
            end;
          end;
        end;

        // post process
        if ARequest = arLock then begin
          if ((AAction = eaApplied) and (oCmd = nil) or
              (AAction = eaDefault) and (oCmd <> nil)) and
             (oUpdOpts.LockMode <> lmNone) and (ARow.DBLockID = 0) then
            ARow.DBLock(iLockID);
          AAction := eaApplied;
        end
        else if ARequest = arUnLock then begin
          lEndTX := False;
          if (AAction = eaApplied) and (oCmd = nil) or
             (AAction = eaDefault) and (oCmd <> nil) then begin
            if (oUpdOpts.LockMode <> lmNone) and (ARow.DBLockID <> 0) then begin
              lEndTX := (oTx.SerialID = ARow.DBLockID);
              ARow.DBUnlock;
            end;
            if uoImmediateUpd in AUpdRowOptions then
              if uoCancelUnlock in AUpdRowOptions then
                ARow.RejectChanges
              else
                ARow.AcceptChanges;
          end;
          if (oUpdOpts.LockMode = lmPessimistic) and oTx.Active and lEndTX then
            if uoCancelUnlock in AUpdRowOptions then
              oTx.Rollback
            else
              oTx.Commit;
          AAction := eaApplied;
        end
        else if (ARequest in [arInsert, arUpdate]) then begin
          if oCmd <> nil then begin
            lCustomFetchRow := not (arFetchRow in FGeneratedCommands) and (GetFetchRowCommand <> nil);
            if not lCustomFetchRow and not oMeta.InlineRefresh and (oUpdOpts.RefreshMode <> rmManual) or
               lCustomFetchRow and (oUpdOpts.RefreshMode = rmAll) then begin
              eFillOpts := ADGetFillRowOptions(GetOptions.FetchOptions);
              if ARequest = arInsert then
                Include(eFillOpts, foAfterIns)
              else if ARequest = arUpdate then
                Include(eFillOpts, foAfterUpd);
              if gfIdentityInsert in eCmdFlags then
                Include(eFillOpts, foNoIdentity);
              Fetch(ARow, AAction, -1, eFillOpts);
            end;
            if (ARequest = arInsert) and (gfHasHBlob in eCmdFlags) and
               (oMeta.InsertHBlobMode = hmUpdateAfterInsert) then
              ProcessUpdate(ARow, AAction, arUpdateHBlobs,
                AUpdRowOptions - [uoNoSrvRecord], [], -1)
            else
              AAction := eaApplied;
            if (ARequest = arInsert) and
               ((AAction = eaApplied) or (AAction = eaDefault)) then
              if uoImmediateUpd in AUpdRowOptions then
                ARow.AcceptChanges;
          end;
        end
        else
          AAction := eaApplied;

      except
        // handle exception
        on E: EADException do begin
          if Assigned(GetErrorHandler()) then begin
            oExc := EADDAptRowUpdateException.Create(ARequest, ARow, AAction, E);
            try
              GetErrorHandler().HandleException(nil, oExc);
              if oExc <> nil then
                AAction := EADDAptRowUpdateException(oExc).Action;
            finally
              ADFree(oExc);
            end;
          end
          else
            AAction := eaDefault;

          // if refreshing record is not found, then remove it
          if (ARequest = arFetchRow) and (AAction = eaDefault) and
             ([foClear, foData] * AFillRowOptions = [foClear, foData]) and
             (E.ADCode = er_AD_DAptRecordIsDeleted) and oUpdOpts.RefreshDelete then begin
            ADFreeAndNil(ARow);
            AAction := eaExitFailure;
          end;

          if AAction = eaDefault then
            AAction := eaFail;
          if AAction = eaFail then
            raise;
        end;
      end;

    until AAction <> eaRetry;

    if AAction = eaFail then
      ADException(Self, [S_AD_LDApt], er_AD_DAptApplyUpdateFailed, []);
    if lCacheUpdateCommand then begin
      InternalSetCommand(ARequest, oCmd);
      if oCmd <> nil then
        Include(FGeneratedCommands, ARequest)
      else
        Exclude(FGeneratedCommands, ARequest);
    end;
  finally
    oTX.UnlockAutoStop(
      not ((ARequest = arUnlock) and (uoCancelUnlock in AUpdRowOptions)) and
      (AAction in [eaSkip, eaApplied, eaDefault, eaExitSuccess]) and (ExceptObject = nil),
      not ((ARequest = arLock) and (oUpdOpts.LockMode = lmPessimistic)));
{$IFDEF AnyDAC_MONITOR}
    if IsTracing then
      if ARow <> nil then
        Trace(ekAdaptUpdate, esEnd, sCaller, ['ARow.Table.Name', sTabName])
      else
        Trace(ekAdaptUpdate, esEnd, sCaller, []);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Update(ARow: TADDatSRow; var AAction: TADErrorAction;
  AUpdRowOptions: TADUpdateRowOptions; AForceRequest: TADActionRequest);
var
  iKind: TADUpdateRequest;
begin
  ASSERT(ARow <> nil);
  case AForceRequest of
  arNone:
    Exit;
  arFromRow:
    case ARow.RowState of
    rsInserted: iKind := arInsert;
    rsDeleted:  iKind := arDelete;
    rsModified: iKind := arUpdate;
    else        Exit;
    end;
  else
    iKind := AForceRequest;
  end;
  ProcessUpdate(ARow, AAction, iKind, AUpdRowOptions, [], -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Lock(ARow: TADDatSRow; var AAction: TADErrorAction;
  AUpdRowOptions: TADUpdateRowOptions);
begin
  ASSERT(ARow <> nil);
  ProcessUpdate(ARow, AAction, arLock, AUpdRowOptions, [], -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.UnLock(ARow: TADDatSRow; var AAction: TADErrorAction;
  AUpdRowOptions: TADUpdateRowOptions);
begin
  ASSERT(ARow <> nil);
  ProcessUpdate(ARow, AAction, arUnlock, AUpdRowOptions, [], -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.FetchGenerators(ARow: TADDatSRow;
  var AAction: TADErrorAction; AUpdRowOptions: TADUpdateRowOptions);
begin
  ASSERT(ARow <> nil);
  ProcessUpdate(ARow, AAction, arFetchGenerators, AUpdRowOptions, [], -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Fetch(ARow: TADDatSRow; var AAction: TADErrorAction;
  AColumn: Integer; AFillRowOptions: TADPhysFillRowOptions);
begin
  ASSERT(ARow <> nil);
  ProcessUpdate(ARow, AAction, arFetchRow, [], AFillRowOptions, AColumn);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.Define: TADDatSTable;
var
  lAttached: Boolean;
begin
  CheckSelectCommand;
  if GetDatSManager = nil then
    Result := GetSelectCommand.Define(GetDatSTable, GetMetaInfoMergeMode)
  else
    Result := GetSelectCommand.Define(GetDatSManager, GetDatSTable, GetMetaInfoMergeMode);
  lAttached := (Result <> nil) and (GetDatSTable = nil);
  if lAttached then
    AttachDatSTable(Result);
  try
    if GetSelectCommand.State = csPrepared then
      GetSelectCommand.Open;
  except
    if lAttached then
      ReleaseDatSTable;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Fetch(AAll: Boolean = False; ABlocked: Boolean = False);
begin
  CheckSelectCommand;
  GetSelectCommand.Fetch(GetDatSTable, AAll, ABlocked);
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.Reconcile: Boolean;
var
  oPrc: TADDAptUpdatesJournalProcessor;
begin
  CheckSelectCommand;
  oPrc := TADDAptUpdatesJournalProcessor.CreateForTableAdapter(Self);
  try
    Result := oPrc.Reconcile;
  finally
    ADFree(oPrc);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapter.Update(AMaxErrors: Integer = -1): Integer;
var
  oTX: IADPhysTransaction;
  oPrc: TADDAptUpdatesJournalProcessor;
begin
  CheckSelectCommand;
  GetUpdTx(oTX);
  oTX.LockAutoStop;
  oPrc := TADDAptUpdatesJournalProcessor.CreateForTableAdapter(Self);
  Result := 0;
  try
    Result := oPrc.Process(AMaxErrors);
  finally
    ADFree(oPrc);
    oTX.UnlockAutoStop(
      ((AMaxErrors = -1) or (Result <= AMaxErrors)) and (ExceptObject = nil),
      True);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapter.Reset;
begin
  UpdateCommands(urReset);
  FBuffer.Release;
end;

{-------------------------------------------------------------------------------}
{ TADDAptTableAdapters                                                          }
{-------------------------------------------------------------------------------}
constructor TADDAptTableAdapters.Create(ASchemaAdapter: TADDAptSchemaAdapter);
begin
  inherited Create;
  FSchemaAdapter := ASchemaAdapter;
  FItems := TADObjList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDAptTableAdapters.Destroy;
begin
  Clear;
  ADFreeAndNil(FItems);
  FSchemaAdapter := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters._AddRef: Integer;
begin
  if FSchemaAdapter <> nil then
    Result := FSchemaAdapter._AddRef
  else
    Result := -1;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters._Release: Integer;
begin
  if FSchemaAdapter <> nil then
    Result := FSchemaAdapter._Release
  else
    Result := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.Clear;
var
  i: Integer;
begin
  for i := FItems.Count - 1 downto 0 do
    ADFree(TADDAptTableAdapter(FItems.Items[i]));
  FItems.Clear;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.GetCount: Integer;
begin
  Result := FItems.Count;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.Find(const ATable: Variant; ANameKind: TADPhysNameKind): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FItems.Count - 1 do
    if TADDAptTableAdapter(FItems.Items[i]).MatchRecordSet(ATable, ANameKind) then begin
      Result := i;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.GetItems(AIndex: Integer): IADDAptTableAdapter;
begin
  Result := TADDAptTableAdapter(FItems.Items[AIndex]) as IADDAptTableAdapter;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.Add(const ASourceRecordSetName: String = '';
  const ADatSTableName: String = ''; const AUpdateTableName: String = ''): IADDAptTableAdapter;
begin
  Result := TADDAptTableAdapter.CreateForSchema(Self) as IADDAptTableAdapter;
  Result.SourceRecordSetName := ASourceRecordSetName;
  Result.DatSTableName := ADatSTableName;
  Result.UpdateTableName := AUpdateTableName;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.Add(const AAdapter: IADDAptTableAdapter);
var
  oAdapt: TADDAptTableAdapter;
begin
  if AAdapter.TableMappings <> nil then
    AAdapter.TableMappings.Remove(AAdapter);
  oAdapt := AAdapter.GetObj as TADDAptTableAdapter;
  FItems.Add(oAdapt);
  oAdapt.FMappings := Self;
  if (AAdapter.DatSTable <> nil) and (AAdapter.DatSTable.Manager <> FSchemaAdapter.GetDatSManager) then begin
    if AAdapter.DatSTable.Manager <> nil then
      AAdapter.DatSTable.Manager.Tables.Remove(AAdapter.DatSTable, True);
    if FSchemaAdapter.GetDatSManager <> nil then
      FSchemaAdapter.GetDatSManager.Tables.Add(AAdapter.DatSTable);
  end;
  FSchemaAdapter.ADAddRef(oAdapt.RefCount);
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.DatSManagerDetaching;
var
  i: Integer;
  oAdapt: TADDAptTableAdapter;
  oTab: TADDatSTable;
begin
  for i := 0 to FItems.Count - 1 do begin
    oAdapt := TADDAptTableAdapter(FItems.Items[i]);
    // Here was call of GetDatSTable, but it leads to TADDatSTable leak
    // in case, when (FDatSTable = nil) and (GetDatSTableName <> '').
    // Because table will be removed from oTab.Manager.Tables, and
    // TADDAptTableAdapter ReleaseDatSTable releases only FDatSTable.
    oTab := oAdapt.FDatSTable;
    if (oTab <> nil) and (oTab.Manager <> nil) and
       (oTab.Manager = FSchemaAdapter.GetDatSManager) then
      oTab.Manager.Tables.Remove(oTab, True);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.DatSManagerAttached;
var
  i: Integer;
  oAdapt: TADDAptTableAdapter;
  oTab: TADDatSTable;
begin
  for i := 0 to FItems.Count - 1 do begin
    oAdapt := TADDAptTableAdapter(FItems.Items[i]);
    oTab := oAdapt.GetDatSTable;
    if (oTab <> nil) and (oTab.Manager <> FSchemaAdapter.GetDatSManager) then begin
      if oTab.Manager <> nil then
        oTab.Manager.Tables.Remove(oTab, True);
      if FSchemaAdapter.GetDatSManager <> nil then
        FSchemaAdapter.GetDatSManager.Tables.Add(oTab);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.Remove(const ATable: Variant; ANameKind: TADPhysNameKind);
var
  i: Integer;
begin
  i := Find(ATable, ANameKind);
  if i <> -1 then
    Remove(GetItems(i));
end;

{-------------------------------------------------------------------------------}
procedure TADDAptTableAdapters.Remove(const AAdapter: IADDAptTableAdapter);
var
  i: Integer;
  oAdapt: TADDAptTableAdapter;
begin
  oAdapt := AAdapter.GetObj as TADDAptTableAdapter;
  i := FItems.Remove(oAdapt);
  if i >= 0 then begin
    if (AAdapter.DatSTable <> nil) and (AAdapter.DatSTable.Manager = FSchemaAdapter.GetDatSManager) then
      AAdapter.DatSTable.Manager.Tables.Remove(AAdapter.DatSTable, True);
    FSchemaAdapter.ADDecRef(oAdapt.RefCount);
    oAdapt.FMappings := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptTableAdapters.Lookup(const ATable: Variant;
  ANameKind: TADPhysNameKind): IADDAptTableAdapter;
var
  i: Integer;
begin
  i := Find(ATable, ANameKind);
  if i <> -1 then
    Result := GetItems(i)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
{ TADDAptSchemaAdapter                                                          }
{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.Initialize;
begin
  inherited Initialize;
  FAdapters := TADDAptTableAdapters.Create(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADDAptSchemaAdapter.Destroy;
begin
  ReleaseDatSManager;
  ADFreeAndNil(FAdapters);
  FErrorHandler := nil;
  FUpdateHandler := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetName: TComponentName;
begin
  Result := ClassName + '($' + IntToHex(Integer(Self), 8) + ')';
  if FDatSManager <> nil then
    Result := FDatSManager.Name + ': ' + Result;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetParent: IADStanObject;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetErrorHandler: IADStanErrorHandler;
begin
  Result := FErrorHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetErrorHandler(const AValue: IADStanErrorHandler);
var
  i: Integer;
begin
  if FErrorHandler <> AValue then begin
    FErrorHandler := AValue;
    for i := 0 to FAdapters.GetCount - 1 do
      TADDAptTableAdapter(FAdapters.FItems.Items[i]).UpdateCommands(urSetErrorHandler);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetUpdateHandler: IADDAptUpdateHandler;
begin
  Result := FUpdateHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetUpdateHandler(const AValue: IADDAptUpdateHandler);
begin
  FUpdateHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetTransaction: IADPhysTransaction;
begin
  Result := FTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetTransaction(const AValue: IADPhysTransaction);
var
  i: Integer;
begin
  if FTransaction <> AValue then begin
    FTransaction := AValue;
    for i := 0 to FAdapters.GetCount - 1 do
      TADDAptTableAdapter(FAdapters.FItems.Items[i]).UpdateCommands(urSetTransaction);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetUpdateTransaction: IADPhysTransaction;
begin
  Result := FUpdateTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetUpdateTransaction(const AValue: IADPhysTransaction);
var
  i: Integer;
begin
  if FUpdateTransaction <> AValue then begin
    FUpdateTransaction := AValue;
    for i := 0 to FAdapters.GetCount - 1 do
      TADDAptTableAdapter(FAdapters.FItems.Items[i]).UpdateCommands(urSetUpdateTransaction);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.MapRecordSet(const ATable: Variant;
  ATabNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSTable: TADDatSTable): TADPhysMappingResult;
var
  oTabAdapt: IADDAptTableAdapter;
begin
  oTabAdapt := GetTableAdapters.Lookup(ATable, ATabNameKind);
  if oTabAdapt = nil then
    Result := mrNotMapped
  else begin
    Result := mrMapped;
    ADGetRecordSetInfo(oTabAdapt, ASourceID, ASourceName, ADatSName,
      AUpdateName, ADatSTable);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.MapRecordSetColumn(const ATable: Variant;
  ATabNameKind: TADPhysNameKind; const AColumn: Variant;
  AColNameKind: TADPhysNameKind; var ASourceID: Integer; var ASourceName,
  ADatSName, AUpdateName: String; var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
var
  oTabAdapt: IADDAptTableAdapter;
  oColMap: TADDAptColumnMapping;
begin
  Result := mrNotMapped;
  oTabAdapt := GetTableAdapters.Lookup(ATable, ATabNameKind);
  if oTabAdapt <> nil then
    if (oTabAdapt.ColumnMappings = nil) or (oTabAdapt.ColumnMappings.Count = 0) then
      Result := mrDefault
    else begin
      oColMap := oTabAdapt.ColumnMappings.Lookup(AColumn, AColNameKind);
      if oColMap <> nil then begin
        Result := mrMapped;
        ADGetRecordSetColumnInfo(oColMap, ASourceID, ASourceName, ADatSName,
          AUpdateName, ADatSColumn);
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.ReleaseDatSManager;
begin
  if FDatSManager <> nil then begin
    FAdapters.DatSManagerDetaching;
    FDatSManager.RemRef;
    FDatSManager := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.AttachDatSManager(AManager: TADDatSManager);
begin
  if FDatSManager <> AManager then begin
    ReleaseDatSManager;
    FDatSManager := AManager;
    if AManager <> nil then begin
      AManager.AddRef;
      FAdapters.DatSManagerAttached;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetDatSManager: TADDatSManager;
var
  oMgr: TADDatSManager;
begin
  if FDatSManager = nil then begin
    oMgr := TADDatSManager.Create;
    oMgr.CountRef(0);
    oMgr.UpdatesRegistry := True;
    AttachDatSManager(oMgr);
  end;
  Result := FDatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADDAptSchemaAdapter.SetDatSManager(AValue: TADDatSManager);
begin
  if FDatSManager <> AValue then
    AttachDatSManager(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.GetTableAdapters: IADDAptTableAdapters;
begin
  Result := FAdapters as IADDAptTableAdapters;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.Reconcile: Boolean;
var
  oPrc: TADDAptUpdatesJournalProcessor;
begin
  oPrc := TADDAptUpdatesJournalProcessor.CreateForSchemaAdapter(Self);
  try
    Result := oPrc.Reconcile;
  finally
    ADFree(oPrc);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDAptSchemaAdapter.Update(AMaxErrors: Integer = -1): Integer;
var
  oPrc: TADDAptUpdatesJournalProcessor;
begin
  oPrc := TADDAptUpdatesJournalProcessor.CreateForSchemaAdapter(Self);
  try
    Result := oPrc.Process(AMaxErrors);
  finally
    ADFree(oPrc);
  end;
end;

{-------------------------------------------------------------------------------}
var
  oFact1,
  oFact2: TADFactory;

initialization
  oFact1 := TADMultyInstanceFactory.Create(TADDAptTableAdapter, IADDAptTableAdapter);
  oFact2 := TADMultyInstanceFactory.Create(TADDAptSchemaAdapter, IADDAptSchemaAdapter);

finalization
  ADReleaseFactory(oFact1);
  ADReleaseFactory(oFact2);

end.
