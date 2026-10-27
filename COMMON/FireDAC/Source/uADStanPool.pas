{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{         FireDAC pool standard implementation          }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADStanPool"'}

unit uADStanPool;

interface

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}  
  SysUtils, Classes, SyncObjs,
  uADStanIntf, uADStanConst, uADStanUtil, uADStanError, uADStanFactory;

type
  TADResourcePoolItem = class(TObject)
  private
    FObj: IADStanObject;
    FInUse: Boolean;
    FLastUsed: LongWord;
  public
    property Obj: IADStanObject read FObj;
    property InUse: Boolean read FInUse;
    property LastUsed: LongWord read FLastUsed;
  end;

  TADResourcePool = class(TADObject, IADStanObjectFactory)
  private
    FHost: IADStanObjectHost;
    FList: TADObjList;
    FLock: TCriticalSection;
    FTimer: TADTimer;
    FCleanupTimeout: LongWord;
    FExpireTimeout: LongWord;
    FMaximumItems: Integer;
    FBusyItems: LongWord;
    FCloseTimeout: LongWord;
    procedure DoCleanup;
    procedure InternalRelease(const AObject: IADStanObject);
  protected
    // IADStanObjectFactory
    procedure Open(const AHost: IADStanObjectHost; const ADef: IADStanDefinition);
    procedure Close;
    procedure Acquire(out AObject: IADStanObject);
    procedure Release(const AObject: IADStanObject);
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

{ ---------------------------------------------------------------------------- }
{ TADResourcePool                                                              }
{ ---------------------------------------------------------------------------- }
procedure TADResourcePool.Initialize;
begin
  inherited Initialize;
  FCleanupTimeout := C_AD_PoolCleanupTimeout;
  FExpireTimeout := C_AD_PoolExpireTimeout;
  FCloseTimeout := C_AD_PoolCloseTimeout;
  FMaximumItems := C_AD_PoolMaximumItems;
  FList := TADObjList.Create;
  FLock := TCriticalSection.Create;
  FTimer := TADTimer.Create(nil);
  FTimer.Interval := FCleanupTimeout;
  FTimer.OnTimer := DoCleanup;
end;

{ ---------------------------------------------------------------------------- }
destructor TADResourcePool.Destroy;
begin
  Close;
  ADFreeAndNil(FTimer);
  ADFreeAndNil(FList);
  ADFreeAndNil(FLock);
  inherited Destroy;
end;

{ ---------------------------------------------------------------------------- }
procedure TADResourcePool.DoCleanup;
var
  i: integer;
  oList: TADObjList;
begin
{$IFDEF AnyDAC_D9}
  if FLock.TryEnter then begin
{$ELSE}
  FLock.Enter;
  begin
{$ENDIF}
    oList := TADObjList.Create;
    try
      try
        for i := FList.Count - 1 downto 0 do
          if not TADResourcePoolItem(FList[i]).InUse and
             ADTimeout(TADResourcePoolItem(FList[i]).LastUsed, FExpireTimeout) then begin
            oList.Add(FList[i]);
            FList.Delete(i);
          end;
      finally
        FLock.Leave;
      end;
      for i := 0 to oList.Count - 1 do
        ADFree(TADResourcePoolItem(oList[i]));
    finally
      ADFree(oList);
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADResourcePool.Acquire(out AObject: IADStanObject);
var
  i, iCreate: integer;
  oItem: TADResourcePoolItem;
begin
  AObject := nil;
  FLock.Enter;
  try
    ASSERT(FHost <> nil);
    for i := 0 to FList.Count - 1 do begin
      oItem := TADResourcePoolItem(FList[i]);
      if not oItem.InUse then begin
        AObject := oItem.Obj;
        oItem.FInUse := True;
        Inc(FBusyItems);
        Break;
      end;
    end;
    if AObject = nil then begin
      if (FMaximumItems > 0) and (FMaximumItems <= FList.Count) then
        ADException(Self, [S_AD_LStan], er_AD_StanPoolTooManyItems, [FMaximumItems]);
      iCreate := 5;
      oItem := nil;
      if (FMaximumItems > 0) and (iCreate > FMaximumItems - FList.Count) then
        iCreate := FMaximumItems - FList.Count;
      while iCreate > 0 do begin
        oItem := TADResourcePoolItem.Create;
        try
          oItem.FLastUsed := ADGetTickCount;
          FHost.CreateObject(oItem.FObj);
        except
          ADFree(oItem);
          raise;
        end;
        FList.Add(oItem);
        Dec(iCreate);
      end;
      ASSERT((oItem <> nil) and not oItem.FInUse and (oItem.FObj <> nil));
      AObject := oItem.FObj;
      oItem.FInUse := True;
      Inc(FBusyItems);
    end;
  finally
    FLock.Leave;
  end;
  try
    AObject.BeforeReuse;
  except
    InternalRelease(AObject);
    AObject := nil;
    raise;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADResourcePool.InternalRelease(const AObject: IADStanObject);
var
  i: integer;
  oItem: TADResourcePoolItem;
begin
  FLock.Enter;
  try
    for i := 0 to FList.Count - 1 do begin
      oItem := TADResourcePoolItem(FList[i]);
      if oItem.Obj = AObject then begin
        oItem.FInUse := False;
        oItem.FLastUsed := ADGetTickCount;
        Dec(FBusyItems);
        Exit;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADResourcePool.Release(const AObject: IADStanObject);
begin
  try
    AObject.AfterReuse;
  finally
    InternalRelease(AObject);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.Open(const AHost: IADStanObjectHost; const ADef: IADStanDefinition);

  function Def(AValue, ADef: Integer): Integer;
  begin
    if AValue = 0 then
      Result := ADef
    else
      Result := AValue;
  end;

begin
  FLock.Enter;
  try
    ASSERT(FHost = nil);
    if ADef <> nil then begin
      FCleanupTimeout := LongWord(Def(ADef.AsInteger[S_AD_PoolParam_CleanupTimeout], C_AD_PoolCleanupTimeout));
      FExpireTimeout := LongWord(Def(ADef.AsInteger[S_AD_PoolParam_ExpireTimeout], C_AD_PoolExpireTimeout));
      FMaximumItems := Def(ADef.AsInteger[S_AD_PoolParam_MaximumItems], C_AD_PoolMaximumItems);
    end;
    FHost := AHost;
    FTimer.Enabled := True;
  finally
    FLock.Leave;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADResourcePool.Close;
var
  i: Integer;
  iStartTime: LongWord;
begin
  if FHost <> nil then begin
    FHost := nil;
    iStartTime := ADGetTickCount;
    while (FBusyItems > 0) and not ADTimeout(iStartTime, FCloseTimeout) do
      Sleep(1);
    FLock.Enter;
    try
      FTimer.Enabled := False;
      for i := 0 to FList.Count - 1 do
        ADFree(TADResourcePoolItem(FList[i]));
      FList.Clear;
    finally
      FLock.Leave;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  oFact := TADMultyInstanceFactory.Create(TADResourcePool, IADStanObjectFactory);

finalization
  ADReleaseFactory(oFact);

end.
