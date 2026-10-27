{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{              FireDAC interface factories              }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADStanFactory;

interface

uses
  SysUtils, Classes,
  uADStanIntf;

type
  TADObject = class;
  TADObjectClass = class of TADObject;
  TADFactory = class;
  TADSingletonFactory = class;
  TADMultyInstanceFactory = class;

  TADObject = class(TInterfacedObject,
    {$IFNDEF AnyDAC_SkipIUnk} IUnknown, {$ENDIF} IADStanComponentReference)
  private
    FComponentReference: IInterfaceComponentReference;
  protected
{$IFDEF AnyDAC_FPC}
    function QueryInterface({$IFDEF FPC_HAS_CONSTREF} constref {$ELSE} const {$ENDIF} iid: tguid;
      out obj): longint; {$IFNDEF WINDOWS} cdecl {$ELSE} stdcall {$ENDIF};
{$ELSE}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
{$ENDIF}
    // IADStanComponentReference
    procedure SetComponentReference(const AValue: IInterfaceComponentReference);
    // etc
    class function IsFactoryEnabled(const AMyProvider, AReqProvider: String): Boolean; virtual;
    procedure Finalize; virtual;
  public
    function ADDecRef(const AValue: Integer = 1): Integer;
    function ADAddRef(const AValue: Integer = 1): Integer;
    constructor Create; virtual;
    procedure Initialize; virtual;
    destructor Destroy; override;
  end;

  TADFactory = class(TObject)
  private
    FClass: TADObjectClass;
    FClassID: TGUID;
    FProvider: String;
    FUnit: String;
    FFriends: TStringList;
  protected
    function CreateObject: TObject; virtual; abstract;
  public
    constructor Create(AClass: TADObjectClass; const AClassID: TGUID;
      const AProvider: String = ''; const AUnit: String = '');
    destructor Destroy; override;
    procedure AddFriend(const AFriend: String);
    procedure GetProviders(Alist: TStrings);
  end;

  TADSingletonFactory = class(TADFactory)
  private
    FSingleton: TADObject;
    FSingletonIntf: IUnknown;
  protected
    function CreateObject: TObject; override;
  public
    destructor Destroy; override;
  end;

  TADMultyInstanceFactory = class(TADFactory)
  protected
    function CreateObject: TObject; override;
  end;

  procedure ADCreateInterface(const AIID: TGUID; out AIntf;
    const ARequired: Boolean = True; const AProvider: String = '');
  procedure ADGetProviders(const AIID: TGUID; AList: TStrings);
  procedure ADReleaseFactory(var AFactory: TADFactory);
  procedure ADTerminate;

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFNDEF AnyDAC_D6Base}
  ActiveX, ComObj,
{$ENDIF}
{$IFDEF AnyDAC_D17}
  System.Generics.Collections,
  System.Types,
{$ENDIF}
  SyncObjs,
  uADStanResStrs, uADStanUtil, uADStanConst,
  uADPhysIntf,
  uADDAptIntf,
  uADGUIxIntf;

{ ---------------------------------------------------------------------------- }
{ TADManager                                                                   }
{ ---------------------------------------------------------------------------- }
type
  TADManager = class(TObject)
  private
    FFactories: TADObjList;
    FLock: TCriticalSection;
    FObjects: Integer;
    function Find(const AIID: TGUID; const AProvider: String = ''): Integer;
    procedure GetProviders(const AIID: TGUID; AList: TStrings);
    procedure AddObj;
    procedure RemObj;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CreateInterface(const AIID: TGUID; out AIntf; ARequired: Boolean;
      const AProvider: String);
    procedure AddFactory(AFactory: TADFactory);
    procedure RemoveFactory(AFactory: TADFactory);
  end;

var
  GTerminating: Boolean;
  GManager: TADManager;

{ ---------------------------------------------------------------------------- }
constructor TADManager.Create;
begin
  inherited Create;
  FFactories := TADObjList.Create;
  FLock := TCriticalSection.Create;
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.AddFactory(AFactory: TADFactory);
begin
  FLock.Enter;
  try
    FFactories.Add(AFactory);
  finally
    FLock.Leave;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.RemoveFactory(AFactory: TADFactory);
begin
  FLock.Enter;
  try
    FFactories.Remove(AFactory);
  finally
    FLock.Leave;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADManager.Find(const AIID: TGUID; const AProvider: String = ''): Integer;
var
  i: Integer;
  oFact: TADFactory;
begin
  Result := -1;
  for i := 0 to FFactories.Count - 1 do begin
    oFact := TADFactory(FFactories[i]);
    if IsEqualGUID(AIID, oFact.FClassID) and
       ((oFact.FClass = nil) or oFact.FClass.IsFactoryEnabled(oFact.FProvider, AProvider)) then begin
      Result := i;
      Break;
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.GetProviders(const AIID: TGUID; AList: TStrings);
var
  i: Integer;
  oFact: TADFactory;
begin
  for i := 0 to FFactories.Count - 1 do begin
    oFact := TADFactory(FFactories[i]);
    if IsEqualGUID(AIID, oFact.FClassID) then
      oFact.GetProviders(AList);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.CreateInterface(const AIID: TGUID; out AIntf; ARequired: Boolean;
  const AProvider: String);
var
  i: Integer;
  oObj: TObject;
  oFact: TADFactory;

  procedure ObjFactMissError;
  var
    s, sProv: String;
  begin
    if IsEqualGUID(AIID, IADGUIxWaitCursor) then
      s := Format(S_AD_StanHowToReg, ['TADGUIxWaitCursor'])
    else if IsEqualGUID(AIID, IADGUIxAsyncExecuteDialog) then
      s := Format(S_AD_StanHowToReg, ['TADGUIxAsyncExecuteDialog'])
    else if IsEqualGUID(AIID, IADGUIxErrorDialog) then
      s := Format(S_AD_StanHowToReg, ['TADGUIxErrorDialog'])
    else if IsEqualGUID(AIID, IADGUIxLoginDialog) then
      s := Format(S_AD_StanHowToReg, ['TADGUIxLoginDialog'])
    else if IsEqualGUID(AIID, IADGUIxScriptDialog) then
      s := Format(S_AD_StanHowToReg, ['TADGUIxScriptDialog'])
    else if IsEqualGUID(AIID, IADPhysManager) then
      s := Format(S_AD_StanHowToReg, ['TADPhysXXXDriverLink'])
{$IFDEF AnyDAC_MONITOR}
    else if IsEqualGUID(AIID, IADMoniRemoteClient) then
      s := Format(S_AD_StanHowToReg, ['TADMoniRemoteClientLink'])
    else if IsEqualGUID(AIID, IADMoniCustomClient) then
      s := Format(S_AD_StanHowToReg, ['TADMoniCustomClientLink'])
    else if IsEqualGUID(AIID, IADMoniFlatFileClient) then
      s := Format(S_AD_StanHowToReg, ['TADMoniFlatFileClientLink'])
{$ENDIF}
    else if IsEqualGUID(AIID, IADDAptTableAdapter) or
            IsEqualGUID(AIID, IADDAptSchemaAdapter) then
      s := Format(S_AD_StanHowToInc, ['uADDAptManager'])
    else if IsEqualGUID(AIID, IADStanObjectFactory) then
      s := Format(S_AD_StanHowToInc, ['uADStanPool'])
    else if IsEqualGUID(AIID, IADStanAsyncExecutor) then
      s := Format(S_AD_StanHowToInc, ['uADStanAsync'])
    else if IsEqualGUID(AIID, IADStanExpressionParser) then
      s := Format(S_AD_StanHowToInc, ['uADStanExpr'])
    else if IsEqualGUID(AIID, IADStanConnectionDefs) or
            IsEqualGUID(AIID, IADStanConnectionDef) or
            IsEqualGUID(AIID, IADStanDefinition) or
            IsEqualGUID(AIID, IADStanDefinitions) or
            IsEqualGUID(AIID, IADStanDefinitionStorage) then
      s := Format(S_AD_StanHowToInc, ['uADStanDef'])
    else
      s := '';
    if AProvider <> '' then
      sProv := ', provider [' + AProvider + '],'
    else
      sProv := '';
    raise Exception.CreateFmt('Object factory for class %s%s is missing' + s,
      [GUIDToString(AIID), sProv]);
  end;

  procedure IntfNotImplError;
  begin
    raise Exception.CreateFmt('Class [%s] does not implement interface [%s]',
      [oFact.FClass.ClassName, GUIDToString(AIID)]);
  end;

begin
  FLock.Enter;
  try
    i := Find(AIID, AProvider);
    if i = -1 then begin
      if not ARequired then begin
        IUnknown(AIntf) := nil;
        Exit;
      end;
      ObjFactMissError;
    end;
    oFact := TADFactory(FFactories[i]);
  finally
    FLock.Leave;
  end;
  oObj := oFact.CreateObject();
  if oObj is TADObject then begin
    if TADObject(oObj).QueryInterface(AIID, AIntf) <> 0 then
      IntfNotImplError;
  end
  else begin
    if not oObj.GetInterface(AIID, AIntf) then
      IntfNotImplError;
  end;
end;

{ ---------------------------------------------------------------------------- }
destructor TADManager.Destroy;
var
  i: Integer;
begin
  FLock.Enter;
  for i := FFactories.Count - 1 downto 0 do
    ADFree(TADFactory(FFactories[i]));
  ADFreeAndNil(FFactories);
  ADFreeAndNil(FLock);
  GManager := nil;
  inherited Destroy;
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.AddObj;
begin
  ADInterlockedIncrement(FObjects);
end;

{ ---------------------------------------------------------------------------- }
procedure TADManager.RemObj;
begin
  ADInterlockedDecrement(FObjects);
end;

{ ---------------------------------------------------------------------------- }
procedure ADCreateInterface(const AIID: TGUID; out AIntf;
  const ARequired: Boolean = True; const AProvider: String = '');
begin
  if GTerminating then
    IUnknown(AIntf) := nil
  else
    GManager.CreateInterface(AIID, AIntf, ARequired, AProvider);
end;

{ ---------------------------------------------------------------------------- }
procedure ADGetProviders(const AIID: TGUID; AList: TStrings);
begin
  if not GTerminating then
    GManager.GetProviders(AIID, AList);
end;

{ ---------------------------------------------------------------------------- }
procedure ADReleaseFactory(var AFactory: TADFactory);
begin
  // At design time (actually, when FireDAC is packaged) the factories must be
  // destroyed in the implementation unit finilization sections (see AD-0261).
  // At run time (actually, when FireDAC is not packaged) the ADManager must
  // destroy the factories. Because the units finalization order is not
  // dependent on the FireDAC services dependency, so a factory may be destroyed
  // before all it interfaces will be released.
  if ADIsDesignTime then
    ADFreeAndNil(AFactory);
end;

{ ---------------------------------------------------------------------------- }
procedure ADTerminate;
begin
  if not GTerminating then begin
    GTerminating := True;
    ADFreeAndNil(GManager);
    TADTimer.Shutdown;
  end;
end;

{ ---------------------------------------------------------------------------- }
{ TADObject                                                                    }
{ ---------------------------------------------------------------------------- }
constructor TADObject.Create;
begin
  inherited Create;
  Initialize;
  if GManager <> nil then
    GManager.AddObj;
end;

{ ---------------------------------------------------------------------------- }
procedure TADObject.Initialize;
begin
  // nothing
end;

{ ---------------------------------------------------------------------------- }
destructor TADObject.Destroy;
begin
  if GManager <> nil then
    GManager.RemObj;
  inherited Destroy;
end;

{ ---------------------------------------------------------------------------- }
{$IFDEF AnyDAC_FPC}
function TADObject.QueryInterface({$IFDEF FPC_HAS_CONSTREF} constref {$ELSE} const {$ENDIF}
  iid: tguid; out obj): longint; {$IFNDEF WINDOWS} cdecl {$ELSE} stdcall {$ENDIF};
{$ELSE}
function TADObject.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
{$ENDIF}
begin
  Result := inherited QueryInterface(IID, Obj);
  if (Result = E_NOINTERFACE) and Assigned(FComponentReference) then
    Result := FComponentReference.QueryInterface(IID, Obj);
end;

{ ---------------------------------------------------------------------------- }
function TADObject.ADAddRef(const AValue: Integer = 1): Integer;
begin
  if AValue = 1 then
    Result := ADInterlockedIncrement(FRefCount)
  else begin
    Inc(FRefCount, AValue);
    Result := FRefCount;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADObject.ADDecRef(const AValue: Integer = 1): Integer;
begin
  if AValue = 1 then
    Result := ADInterlockedDecrement(FRefCount)
  else begin
    Dec(FRefCount, AValue);
    Result := FRefCount;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADObject.SetComponentReference(const AValue: IInterfaceComponentReference);
begin
  FComponentReference := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADObject.Finalize;
begin
  // none
end;

{ ---------------------------------------------------------------------------- }
class function TADObject.IsFactoryEnabled(const AMyProvider, AReqProvider: String): Boolean;
begin
  Result := CompareText(AMyProvider, AReqProvider) = 0;
end;

{ ---------------------------------------------------------------------------- }
{ TADFactory                                                                   }
{ ---------------------------------------------------------------------------- }
constructor TADFactory.Create(AClass: TADObjectClass; const AClassID: TGUID;
  const AProvider: String = ''; const AUnit: String = '');
begin
  inherited Create;
  FClass := AClass;
  FClassID := AClassID;
  FProvider := AProvider;
  FUnit := AUnit;
  FFriends := TADStringList.Create;
  FFriends.Sorted := True;
  FFriends.Duplicates := dupIgnore;
  GManager.AddFactory(Self);
end;

{ ---------------------------------------------------------------------------- }
destructor TADFactory.Destroy;
begin
  ADFreeAndNil(FFriends);
  if GManager <> nil then
    GManager.RemoveFactory(Self);
  inherited Destroy;
end;

{ ---------------------------------------------------------------------------- }
procedure TADFactory.AddFriend(const AFriend: String);
begin
  FFriends.Add(AFriend);
end;

{ ---------------------------------------------------------------------------- }
procedure TADFactory.GetProviders(AList: TStrings);
begin
  AList.Add(FProvider + '=' + FUnit);
  if ADIsDesignTime then
    AList.AddStrings(FFriends);
end;

{ ---------------------------------------------------------------------------- }
{ TADSingletonFactory                                                          }
{ ---------------------------------------------------------------------------- }
function TADSingletonFactory.CreateObject: TObject;
begin
  if FSingleton = nil then begin
    FSingleton := FClass.Create;
    FSingletonIntf := FSingleton as IUnknown;
  end;
  Result := FSingleton;
end;

{ ---------------------------------------------------------------------------- }
destructor TADSingletonFactory.Destroy;
begin
  if FSingleton <> nil then
    FSingleton.Finalize;
  if not GTerminating and (FSingleton <> nil) and (FSingleton.RefCount > 1) then
    ADSystemMessage(C_AD_Product + ' Warning', 'Class [' + FClass.ClassName +
      '] singleton factory has unreleased interfaces', True);
  FSingletonIntf := nil;
  FSingleton := nil;
  inherited Destroy;
end;

{ ---------------------------------------------------------------------------- }
{ TADMultyInstanceFactory                                                      }
{ ---------------------------------------------------------------------------- }
function TADMultyInstanceFactory.CreateObject: TObject;
begin
  Result := FClass.Create;
end;

{ ---------------------------------------------------------------------------- }
initialization
  GTerminating := False;
  GManager := TADManager.Create;

{ ---------------------------------------------------------------------------- }
finalization
  ADTerminate;

end.
