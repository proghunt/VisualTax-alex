{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{        FireDAC design time registration unit          }
{                                                       }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompReg;

interface

procedure Register;

implementation

uses
{$IFDEF AnyDAC_D9}
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
{$ENDIF}
  SysUtils, Classes, Dialogs, DB, Graphics,
{$IFDEF AnyDAC_FPC}
  PropEdits, LazarusPackageIntf, LResources, ComponentEditors,
{$ELSE}
  {$IFDEF AnyDAC_D6}
    ToolsAPI, DesignIntf, DesignEditors, PropertyCategories, DSDesign, DBReg,
    StrEdit, Menus,
  {$ELSE}
    ToolIntf, DsgnIntf, ExptIntf,
  {$ENDIF}
{$ENDIF}
  uADStanConst, uADStanUtil, uADStanDef, uADStanAsync, uADStanExpr,
    uADStanExprFuncs, uADStanFactory, uADStanResStrs, uADStanOption,
    uADStanStorage, uADStanPool, uADStanIntf,
{$IFDEF AnyDAC_MONITOR}
  uADMoniCustom, uADMoniFlatFile, uADMoniRemoteClient,
{$ENDIF}
  uADGUIxFormsfAbout, uADGUIxFormsfError, uADGUIxFormsfLogin,
    uADGUIxFormsfFetchOptions, uADGUIxFormsfFormatOptions, uADGUIxFormsfUpdateOptions,
    uADGUIxFormsfResourceOptions, uADGUIxFormsfConnEdit, uADGUIxFormsfUSEdit,
    uADGUIxFormsfQEdit, uADGUIxFormsfAsync, uADGUIxFormsWait, uADGUIxIntf,
    uADGUIxFormsControls, uADGUIxFormsMemo, uADGUIxFormsfScript,
    uADGUIxFormsfDesignTimeOptions, uADGUIxFormsfFields,
  uADDAptManager,
{$IFDEF AnyDAC_DBX}
  {$IFDEF AnyDAC_D11}
  uADPhysTDBX,
    {$IFDEF AnyDAC_D16}
      {$IFNDEF AnyDAC_ProSKU}
  uADPhysDataSnap,
      {$ENDIF}
    {$ENDIF}
  {$ELSE}
    {$IFDEF AnyDAC_D6}
  uADPhysDbExp,
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  uADPhysManager,
{$IFNDEF AnyDAC_MOBILE}
  uADPhysMSAcc, uADPhysMySQL, uADPhysASA, uADPhysADS, uADPhysPg, uADPhysODBCWrapper,
    uADPhysODBCBase, uADPhysODBC, uADPhysMSSQL, uADPhysDB2, uADPhysOracle,
{$ENDIF}
  uADPhysIB, uADPhysSQLite, uADPhysSQLiteVDataSet,
  uADCompDataSet, uADCompClient, uADCompDataMove, uADCompScript,
    uADCompScriptCommands, uADCompGUIx;

{$IFNDEF AnyDAC_FPC}
  {$R uADSplash.res}
  {$R uADDcl.dcr}
{$ENDIF}

const
  C_ADMenu = 'ADMENU';
  C_ADAbout = 'ADABOUT';
  C_ADMonitor = 'ADMONITOR';
  C_ADExplorer = 'ADEXPLORER';
{$IFDEF AnyDAC_D11}
  C_ADLogo = 'ADSPLASH2007';
{$ELSE}
  {$IFDEF AnyDAC_D10}
  C_ADLogo = 'ADSPLASH2006';
  {$ELSE}
    {$IFDEF AnyDAC_D9}
  C_ADLogo = 'ADSPLASH2005';
    {$ELSE}
  C_ADLogo = 'ADSPLASH2007';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{-------------------------------------------------------------------------------}
{ Utilities                                                                     }
{-------------------------------------------------------------------------------}
function DefStr(const AValue, ADefault: String): String;
begin
  if AValue = '' then
    Result := ADefault
  else
    Result := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADListProperty                                                               }
{-------------------------------------------------------------------------------}
type
  TADListProperty = class(TStringProperty)
  protected
    procedure DoGetValues(AComp: TComponent; AList: TStrings); virtual; abstract;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: Boolean; override;
  end;

{-------------------------------------------------------------------------------}
function TADListProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADListProperty.GetValues(Proc: TGetStrProc);
var
  oList: TADStringList;
  i: Integer;
  oComp: TComponent;
begin
  oList := TADStringList.Create;
  try
    oComp := GetComponent(0) as TComponent;
    DoGetValues(oComp, oList);
    for i := 0 to oList.Count - 1 do
      Proc(oList[i]);
  finally
    ADFree(oList);
  end;
end;

{-------------------------------------------------------------------------------}
function TADListProperty.AutoFill: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
{ TADConnectionNameProp                                                         }
{-------------------------------------------------------------------------------}
type
  TADConnectionNameProp = class(TADListProperty)
  protected
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADConnectionNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
begin
  ADManager.GetConnectionNames(AList);
end;

{-------------------------------------------------------------------------------}
{ TADConnectionDefFileNameProp                                                  }
{-------------------------------------------------------------------------------}
type
  TADConnectionDefFileNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADConnectionDefFileNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefFileNameProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    oDialog.DefaultExt := 'ini';
    oDialog.Filter := S_AD_RegIniFilter;
    oDialog.FileName := GetValue;
    if oDialog.Execute then
      SetValue(oDialog.FileName);
  finally
    ADFree(oDialog);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADConnectionDefNameProp                                                      }
{-------------------------------------------------------------------------------}
type
  TADConnectionDefNameProp = class(TADListProperty)
  protected
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADConnectionDefNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
begin
  ADManager.GetConnectionDefNames(AList);
end;

{-------------------------------------------------------------------------------}
{ TADProviderProp                                                               }
{-------------------------------------------------------------------------------}
type
  TADProviderProp = class(TADListProperty)
  protected
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADProviderProp.DoGetValues(AComp: TComponent; AList: TStrings);
var
  oProviders: TADStringList;
  i: Integer;
  rGUID: TGUID;
begin
  if AComp is TADGUIxComponent then
    rGUID := TADGUIxComponent(AComp).GetGUID
  else if AComp is TADCustomManager then
    rGUID := IADGUIxWaitCursor
  else
    Exit;
  oProviders := TADStringList.Create;
  try
    oProviders.Sorted := True;
    oProviders.Duplicates := dupIgnore;
    ADGetProviders(rGUID, oProviders);
    AList.Clear;
    for i := 0 to oProviders.Count - 1 do
      AList.Add(ADNameFromIndex(oProviders, i));
  finally
    ADFree(oProviders);
  end;
end;

{-------------------------------------------------------------------------------}
function TADProviderProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

{-------------------------------------------------------------------------------}
{ TADDriverNameProp                                                             }
{-------------------------------------------------------------------------------}
type
  TADDriverNameProp = class(TADListProperty)
  protected
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADDriverNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
begin
  ADManager.GetDriverNames(AList);
end;

{-------------------------------------------------------------------------------}
{ TADConnectionEditor                                                           }
{-------------------------------------------------------------------------------}
type
  TADConnectionEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADConnectionEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0:
      if TfrmADGUIxFormsConnEdit.Execute(TADCustomConnection(Component), Component.Name) then
        Designer.Modified;
    end;
end;

{-------------------------------------------------------------------------------}
function TADConnectionEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegConnectionEditor;
    end;
end;

{-------------------------------------------------------------------------------}
function TADConnectionEditor.GetVerbCount: Integer;
begin
  Result := 1 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADCatalogNameProp                                                            }
{-------------------------------------------------------------------------------}
type
  TADCatalogNameProp = class(TADListProperty)
  protected
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADCatalogNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
var
  oCmd: TADCustomCommand;
  oConn: TADCustomConnection;
begin
  if AComp is TADCustomCommand then
    oCmd := TADCustomCommand(AComp)
  else if AComp is TADAdaptedDataSet then
    oCmd := TADAdaptedDataSet(AComp).Command
  else
    oCmd := nil;
  if oCmd <> nil then begin
    oConn := oCmd.AcquireConnection;
    try
      oConn.GetCatalogNames('', AList);
    finally
      oCmd.ReleaseConnection(oConn);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADSchemaNameProp                                                             }
{-------------------------------------------------------------------------------}
type
  TADSchemaNameProp = class(TADListProperty)
  protected
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADSchemaNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
var
  oCmd: TADCustomCommand;
  oConn: TADCustomConnection;
  sCat: String;
begin
  sCat := '';
  oCmd := nil;
  if AComp is TADCustomCommand then
    oCmd := TADCustomCommand(AComp)
  else if AComp is TADTable then begin
    oCmd := TADTable(AComp).Command;
    sCat := TADTable(AComp).CatalogName;
  end
  else if AComp is TADAdaptedDataSet then
    oCmd := TADAdaptedDataSet(AComp).Command;
  if oCmd <> nil then begin
    if sCat = '' then
      sCat := oCmd.CatalogName;
    oConn := oCmd.AcquireConnection;
    try
      oConn.GetSchemaNames(DefStr(sCat, GADDTCatalog), '', AList);
    finally
      oCmd.ReleaseConnection(oConn);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPackageNameProp                                                            }
{-------------------------------------------------------------------------------}
type
  TADPackageNameProp = class(TADListProperty)
  protected
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADPackageNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
var
  oSP: TADCustomStoredProc;
  oConn: TADCustomConnection;
begin
  oSP := AComp as TADCustomStoredProc;
  oConn := oSP.Command.AcquireConnection;
  try
    oConn.GetPackageNames(DefStr(oSP.CatalogName, GADDTCatalog),
                          DefStr(oSP.SchemaName, GADDTSchema),
                          GADDTMask, AList, GADDTScope, GADDTFullName);
  finally
    oSP.Command.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADStoredProcNameProp                                                         }
{-------------------------------------------------------------------------------}
type
  TADStoredProcNameProp = class(TADListProperty)
  protected
    procedure DoGetValues(AComp: TComponent; AList: TStrings); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADStoredProcNameProp.DoGetValues(AComp: TComponent; AList: TStrings);
var
  oSP: TADCustomStoredProc;
  oConn: TADCustomConnection;
begin
  oSP := AComp as TADCustomStoredProc;
  oConn := oSP.Command.AcquireConnection;
  try
    oConn.GetStoredProcNames(DefStr(oSP.CatalogName, GADDTCatalog),
                             DefStr(oSP.SchemaName, GADDTSchema),
                             oSP.PackageName, GADDTMask, AList, GADDTScope,
                             GADDTFullName);
  finally
    oSP.Command.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADDataSetEditor                                                              }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
type
  TADDSDesigner = class(TDSDesigner)
  public
    function SupportsAggregates: Boolean; override;
    function SupportsInternalCalc: Boolean; override;
    function DoCreateField(const FieldName: {$IFDEF AnyDAC_D10} WideString {$ELSE}
      string {$ENDIF}; Origin: string): TField; override;
  end;

  TADDataSetEditor = class(TDataSetEditor)
  protected
    function GetDSDesignerClass: TDSDesignerClass; override;
  end;

{-------------------------------------------------------------------------------}
function TADDSDesigner.DoCreateField(const FieldName: {$IFDEF AnyDAC_D10} WideString {$ELSE}
  string {$ENDIF}; Origin: string): TField;
var
  oDS: TADDataSet;
begin
  Result := inherited DoCreateField(FieldName, Origin);
  oDS := TADDataSet(DataSet);
  oDS.SetFieldAttributes(Result, oDS.GetFieldColumn(Result));
end;

{-------------------------------------------------------------------------------}
function TADDSDesigner.SupportsAggregates: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDSDesigner.SupportsInternalCalc: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDataSetEditor.GetDSDesignerClass: TDSDesignerClass;
begin
  Result := TADDSDesigner;
end;
{$ELSE}

{-------------------------------------------------------------------------------}
{-------------------------------------------------------------------------------}
var
  DataSetEditorClass: TComponentEditorClass;

{-------------------------------------------------------------------------------}
{$WARNINGS OFF}
procedure CaptureDataSetEditorClass;
var
  ds: TDataSet;
  dsEditor: {$IFDEF AnyDAC_FPC} TBaseComponentEditor {$ELSE}
                                TComponentEditor {$ENDIF};
begin
  ds := nil;
  dsEditor := nil;
  try
    ds := TDataSet.Create(nil);
    dsEditor := GetComponentEditor(ds, nil);
    DataSetEditorClass := TComponentEditorClass(dsEditor.ClassType);
  finally
    ADFree(dsEditor);
    ADFree(ds);
  end;
end;
{$WARNINGS ON}

{-------------------------------------------------------------------------------}
type
  TADDataSetEditor = class(TComponentEditor)
  private
    FPrevEditor: {$IFDEF AnyDAC_FPC} TBaseComponentEditor {$ELSE}
                                     TComponentEditor {$ENDIF};
  public
    constructor Create(AComponent: TComponent; ADesigner:
      {$IFDEF AnyDAC_FPC} TComponentEditorDesigner {$ELSE}
                          IFormDesigner {$ENDIF}); override;
    destructor Destroy; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADDataSetEditor.Create(AComponent: TComponent; ADesigner:
    {$IFDEF AnyDAC_FPC} TComponentEditorDesigner {$ELSE}
                        IFormDesigner {$ENDIF});
begin
  inherited Create(AComponent, ADesigner);
  FPrevEditor := DataSetEditorClass.Create(AComponent, ADesigner);
end;

{-------------------------------------------------------------------------------}
destructor TADDataSetEditor.Destroy;
begin
  ADFreeAndNil(FPrevEditor);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSetEditor.ExecuteVerb(Index: Integer);
begin
  if Index < FPrevEditor.GetVerbCount then
    FPrevEditor.ExecuteVerb(Index);
end;

{-------------------------------------------------------------------------------}
function TADDataSetEditor.GetVerb(Index: Integer): string;
begin
  if Index < FPrevEditor.GetVerbCount then
    Result := FPrevEditor.GetVerb(Index);
end;

{-------------------------------------------------------------------------------}
function TADDataSetEditor.GetVerbCount: Integer;
begin
  Result := FPrevEditor.GetVerbCount;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSetEditor.Edit;
begin
  ExecuteVerb(0);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADRdbmsDataSetEditor                                                         }
{-------------------------------------------------------------------------------}
type
  TADRdbmsDataSetEditor = class(TADDataSetEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  __TADRdbmsDataSet = class(TADRdbmsDataSet)
  end;

procedure TADRdbmsDataSetEditor.ExecuteVerb(Index: Integer);
var
  lPrep: Boolean;
  oDS: __TADRdbmsDataSet;
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case Index - inherited GetVerbCount of
    0:
      begin
        oDS := __TADRdbmsDataSet(Component);
        lPrep := oDS.Prepared;
        try
          oDS.Execute;
        finally
          if not lPrep then
            oDS.Prepared := False;
        end;
      end;
    1: TADRdbmsDataSet(Component).NextRecordSet;
    end;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSetEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case Index - inherited GetVerbCount of
    0: Result := S_AD_RegExecute;
    1: Result := S_AD_RegRdbmsNextRS;
    end;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSetEditor.GetVerbCount: Integer;
begin
  Result := 2 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADSelectionEditor                                                            }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
type
  TADSelectionEditor = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADSelectionEditor.RequiresUnits(Proc: TGetStrProc);
var
  i, j: Integer;
  oComp: TComponent;
  oProviders: TStrings;
begin
  for i := 0 to Designer.Root.ComponentCount - 1 do begin
    oComp := Designer.Root.Components[i];
    if oComp is TADDataSet then begin
      Proc('uADStanIntf');
      Proc('uADStanOption');
      Proc('uADStanParam');
      Proc('uADStanError');
      Proc('uADDatSManager');
    end;
    if oComp is TADAdaptedDataSet then begin
      Proc('uADPhysIntf');
      Proc('uADDAptIntf');
    end;
    if oComp is TADRdbmsDataSet then begin
      //
      Proc('uADStanAsync');
      Proc('uADDAptManager');
    end;
    if oComp is TADCustomManager then begin
      Proc('uADStanIntf');
      Proc('uADStanOption');
      Proc('uADStanError');
      Proc('uADGUIxIntf');
      Proc('uADPhysIntf');
      //
      Proc('uADStanDef');
      Proc('uADPhysManager');
    end;
    if oComp is TADCustomConnection then begin
      Proc('uADStanIntf');
      Proc('uADStanOption');
      Proc('uADStanError');
      Proc('uADGUIxIntf');
      Proc('uADPhysIntf');
      //
      Proc('uADStanDef');
      Proc('uADStanPool');
      Proc('uADStanAsync');
      Proc('uADPhysManager');
    end;
    if oComp is TADCustomCommand then begin
      Proc('uADStanIntf');
      Proc('uADStanOption');
      Proc('uADStanError');
      Proc('uADStanParam');
      Proc('uADDatSManager');
      Proc('uADPhysIntf');
      Proc('uADDAptIntf');
      //
      Proc('uADStanAsync');
    end;
    if oComp is TADUpdateSQL then begin
      Proc('uADStanIntf');
      Proc('uADStanParam');
      Proc('uADPhysIntf');
    end;
    if (oComp is TADCustomTableAdapter) or
       (oComp is TADCustomSchemaAdapter) then begin
      Proc('uADStanIntf');
      Proc('uADStanOption');
      Proc('uADDatSManager');
      Proc('uADPhysIntf');
      Proc('uADDAptIntf');
      //
      Proc('uADDAptManager');
    end;
    if oComp is TADScript then begin
      Proc('uADGUIxIntf');
      //
      Proc('uADStanAsync');
      Proc('uADCompScriptCommands');
    end;
    if oComp is TADGUIxComponent then begin
      Proc('uADGUIxIntf');
      oProviders := TADStringList.Create;
      try
        ADGetProviders(TADGUIxComponent(oComp).GetGUID, oProviders);
        for j := 0 to oProviders.Count - 1 do
          if TADGUIxComponent(oComp).Provider = ADNameFromIndex(oProviders, j) then begin
            Proc(ADValueFromIndex(oProviders, j));
            Break;
          end;
      finally
        ADFree(oProviders);
      end;
    end;
    if oComp is TADPhysSQLiteDriverLink then
      Proc('uADStanExprFuncs');
    if oComp is TADSQLiteFunction then
      Proc('uADPhysSQLiteWrapper');
    if oComp is TADSQLiteValidate then
      Proc('uADStanAsync');
{$IFNDEF AnyDAC_MOBILE}
    if oComp is TADASAService then
      Proc('uADPhysASAWrapper');
    if oComp is TADADSService then
      Proc('uADPhysADSWrapper');
{$ENDIF}
{$IFDEF AnyDAC_DBX}
  {$IFDEF AnyDAC_D17}
    {$IFNDEF AnyDAC_ProSKU}
    if oComp is TADPhysDataSnapDriverLink then
      Proc('IPPeerClient');
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADFieldsProp                                                                 }
{-------------------------------------------------------------------------------}
type
  TADFieldsProp = class(TStringProperty)
  protected
    procedure GetSetup(out ADS: TDataSet; out ACaption: String); virtual;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADFieldsProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADFieldsProp.GetSetup(out ADS: TDataSet; out ACaption: String);
begin
  ACaption := 'Select field names';
  ADS := GetComponent(0) as TDataSet;
end;

{-------------------------------------------------------------------------------}
procedure TADFieldsProp.Edit;
var
  s, sCapt: String;
  oDS: TDataSet;
begin
  GetSetup(oDS, sCapt);
  if oDS = nil then
    Exit;
  s := GetValue;
  if TfrmADGUIxFormsFields.EditFields(s, oDS, sCapt) then
    SetValue(s);
end;

{-------------------------------------------------------------------------------}
{ TADIndexNameProp, TADIndexFieldNamesProp, TADMasterFieldsProp, ...            }
{-------------------------------------------------------------------------------}
type
  TADIndexNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TADIndexFieldNamesProp = class(TADFieldsProp)
  protected
    procedure GetSetup(out ADS: TDataSet; out ACaption: String); override;
  end;

  TADIndexFieldNamesSimpleProp = class(TADIndexFieldNamesProp)
  end;

  TADMasterFieldsProp = class(TADFieldsProp)
  protected
    procedure GetSetup(out ADS: TDataSet; out ACaption: String); override;
  end;

  TADDetailFieldsProp = class(TADFieldsProp)
  protected
    procedure GetSetup(out ADS: TDataSet; out ACaption: String); override;
  end;

{-------------------------------------------------------------------------------}
function TADIndexNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADIndexNameProp.GetValues(Proc: TGetStrProc);
var
  i: Integer;
  oObj: TPersistent;
  oDS: TADDataSet;
begin
  oObj := GetComponent(0);
  if oObj is TADAggregate then
    oDS := TADAggregate(oObj).DataSet
  else if oObj is TADDataSet then
    oDS := TADDataSet(oObj)
  else
    oDS := nil;
  if oDS <> nil then begin
    oDS.IndexDefs.Update;
    for i := 0 to oDS.Indexes.Count - 1 do
      Proc(oDS.Indexes[i].Name);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndexFieldNamesProp.GetSetup(out ADS: TDataSet; out ACaption: String);
var
  oObj: TPersistent;
begin
  oObj := GetComponent(0);
  if oObj is TADIndex then
    ADS := TADIndex(oObj).DataSet
  else if oObj is TADDataSet then
    ADS := TADDataSet(oObj)
  else
    ADS := nil;
  ACaption := 'Select sort field list';
end;

{-------------------------------------------------------------------------------}
procedure TADMasterFieldsProp.GetSetup(out ADS: TDataSet; out ACaption: String);
var
  oDS: TADDataSet;
begin
  oDS := GetComponent(0) as TADDataSet;
  if TADDataSet(oDS).MasterSource <> nil then
    ADS := TADDataSet(oDS).MasterSource.DataSet
  else
    ADS := nil;
  ACaption := 'Select master dataset field list';
end;

{-------------------------------------------------------------------------------}
procedure TADDetailFieldsProp.GetSetup(out ADS: TDataSet; out ACaption: String);
begin
  ADS := GetComponent(0) as TADDataSet;
  ACaption := 'Select detail dataset field list';
end;

{-------------------------------------------------------------------------------}
{ TADUpdateSQLEditor                                                            }
{-------------------------------------------------------------------------------}
type
  TADUpdateSQLEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure TADUpdateSQLEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: if TfrmADGUIxFormsUSEdit.Execute(TADUpdateSQL(Component), Component.Name) then
         Designer.Modified;
    end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQLEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegUpdSQLEditor;
    end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQLEditor.GetVerbCount: Integer;
begin
  Result := 1 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADQueryEditor                                                                }
{-------------------------------------------------------------------------------}
type
  TADQueryEditor = class(TADRdbmsDataSetEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure Edit; override;
  end;

procedure TADQueryEditor.ExecuteVerb(Index: Integer);
begin
  if Index < 1 then
    case Index of
    0: if TfrmADGUIxFormsQEdit.Execute(TADCustomQuery(Component), Component.Name) then
         Designer.Modified;
    end
  else
    inherited ExecuteVerb(Index - 1);
end;

{-------------------------------------------------------------------------------}
function TADQueryEditor.GetVerb(Index: Integer): string;
begin
  if Index < 1 then
    case Index of
    0: Result := S_AD_RegQEditor;
    end
  else
    Result := inherited GetVerb(Index - 1);
end;

{-------------------------------------------------------------------------------}
function TADQueryEditor.GetVerbCount: Integer;
begin
  Result := 1 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
procedure TADQueryEditor.Edit;
begin
  if GADDCFieldsEditor then
    ExecuteVerb(1)
  else
    ExecuteVerb(0);
end;

{-------------------------------------------------------------------------------}
{ TADStoredProcEditor                                                           }
{-------------------------------------------------------------------------------}
type
  TADStoredProcEditor = class(TADRdbmsDataSetEditor)
  end;

{-------------------------------------------------------------------------------}
{ TADCommandEditor                                                              }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
type
  TADSQLProperty = class(TStringListProperty)
  public
    procedure Edit; override;
  end;

procedure TADSQLProperty.Edit;
var
  oComponents: IDesignerSelections;
  oDesigner: IDesigner;
begin
  inherited Edit;
  oComponents := TDesignerSelections.Create;
  oDesigner := Designer;
  oDesigner.GetSelections(oComponents);
  oDesigner.ClearSelection;
  if Assigned(oDesigner) then
    oDesigner.SetSelections(oComponents);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADCommandEditor                                                              }
{-------------------------------------------------------------------------------}
type
  TADCommandEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure TADCommandEditor.ExecuteVerb(Index: Integer);
var
  lPrep: Boolean;
  oQry: TADQuery;
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0:
      begin
        oQry := TADQuery.Create(nil);
        try
          oQry.Name := Component.Name;
          oQry.Connection := TADCustomCommand(Component).Connection;
          oQry.ConnectionName := TADCustomCommand(Component).ConnectionName;
          oQry.SQL := TADCustomCommand(Component).CommandText;
          oQry.Params := TADCustomCommand(Component).Params;
          oQry.Macros := TADCustomCommand(Component).Macros;
          oQry.FetchOptions.RestoreDefaults;
          oQry.FetchOptions := TADCustomCommand(Component).FetchOptions;
          oQry.ResourceOptions := TADCustomCommand(Component).ResourceOptions;
          oQry.UpdateOptions := TADCustomCommand(Component).UpdateOptions;
          oQry.FormatOptions := TADCustomCommand(Component).FormatOptions;
          if TfrmADGUIxFormsQEdit.Execute(oQry, oQry.Name) then begin
            TADCustomCommand(Component).CommandText := oQry.SQL;
            TADCustomCommand(Component).Params := oQry.Params;
            TADCustomCommand(Component).Macros := oQry.Macros;
            TADCustomCommand(Component).FetchOptions := oQry.FetchOptions;
            TADCustomCommand(Component).ResourceOptions := oQry.ResourceOptions;
            TADCustomCommand(Component).UpdateOptions := oQry.UpdateOptions;
            TADCustomCommand(Component).FormatOptions := oQry.FormatOptions;
            Designer.Modified;
          end;
        finally
          ADFree(oQry);
        end;
      end;
    1:
      begin
        lPrep := TADCustomCommand(Component).Prepared;
        try
          TADCustomCommand(Component).Execute;
        finally
          TADCustomCommand(Component).Prepared := lPrep;
        end;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADCommandEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegQEditor;
    1: Result := S_AD_RegExecute;
    end;
end;

{-------------------------------------------------------------------------------}
function TADCommandEditor.GetVerbCount: Integer;
begin
  Result := 2 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADDataMoveEditor                                                             }
{-------------------------------------------------------------------------------}
type
  TADDataMoveEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADDataMoveEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: TADDataMove(Component).Execute;
    1: TADDataMove(Component).GuessTextFormat;
    2: TADDataMove(Component).Mappings.AddAll;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDataMoveEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegExecute;
    1: Result := S_AD_RegGuessTxt;
    2: Result := S_AD_RegAddMappins;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDataMoveEditor.GetVerbCount: Integer;
begin
  Result := 3 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADDataMoveMapFieldEditor                                                     }
{-------------------------------------------------------------------------------}
type
  TADDataMoveMapFieldEditor = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{-------------------------------------------------------------------------------}
function TADDataMoveMapFieldEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

{-------------------------------------------------------------------------------}
procedure TADDataMoveMapFieldEditor.GetValues(Proc: TGetStrProc);
var
  oList: TADStringList;
  i: Integer;
  oDM: TADDataMove;
  oDS: TDataSet;
  oFlds: TADTextFields;
begin
  oDS := nil;
  oFlds := nil;
  oDM := TADMappings((GetComponent(0) as TADMappingItem).Collection).DataMove;
  if GetName = 'SourceFieldName' then begin
    if oDM.SourceKind = skDataSet then
      oDS := oDM.Source
    else
      oFlds := oDM.TextDataDef.Fields;
  end
  else if GetName = 'DestinationFieldName' then begin
    if oDM.DestinationKind = skDataSet then
      oDS := oDM.Destination
    else
      oFlds := oDM.TextDataDef.Fields;
  end;
  if oDS <> nil then begin
{$IFDEF AnyDAC_D6}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
    oList := TADStringList.Create;
    try
      oDS.GetFieldNames(oList);
      for i := 0 to oList.Count - 1 do
        Proc(oList[i]);
    finally
      ADFree(oList);
    end;
{$IFDEF AnyDAC_D6}
  {$WARN SYMBOL_DEPRECATED ON}
{$ENDIF}
  end
  else if oFlds <> nil then
    for i := 0 to oFlds.Count - 1 do
      Proc(oFlds[i].FieldName);
end;

{-------------------------------------------------------------------------------}
{ TADTextFileNameProp                                                           }
{-------------------------------------------------------------------------------}
type
  TADTextFileNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADTextFileNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADTextFileNameProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    oDialog.DefaultExt := 'txt';
    oDialog.Filter := S_AD_RegTxtFilter;
    oDialog.FileName := GetValue;
    if oDialog.Execute then
      SetValue(oDialog.FileName);
  finally
    ADFree(oDialog);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADLogFileNameProp                                                            }
{-------------------------------------------------------------------------------}
type
  TADLogFileNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADLogFileNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADLogFileNameProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    oDialog.DefaultExt := 'log';
    oDialog.Filter := S_AD_RegLogFilter;
    oDialog.FileName := GetValue;
    if oDialog.Execute then
      SetValue(oDialog.FileName);
  finally
    ADFree(oDialog);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADScriptEditor                                                               }
{-------------------------------------------------------------------------------}
type
  TADScriptEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADScriptEditor.ExecuteVerb(Index: Integer);
begin
  if Index < inherited GetVerbCount then
    inherited ExecuteVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: TADScript(Component).ExecuteAll;
    1: TADScript(Component).ValidateAll;
    end;
end;

{-------------------------------------------------------------------------------}
function TADScriptEditor.GetVerb(Index: Integer): string;
begin
  if Index < inherited GetVerbCount then
    Result := inherited GetVerb(Index)
  else
    case (Index - inherited GetVerbCount) of
    0: Result := S_AD_RegExecute;
    1: Result := S_AD_RegValidate;
    end;
end;

{-------------------------------------------------------------------------------}
function TADScriptEditor.GetVerbCount: Integer;
begin
  Result := 2 + inherited GetVerbCount;
end;

{-------------------------------------------------------------------------------}
{ TADSQLScriptFileNameProp                                                      }
{-------------------------------------------------------------------------------}
type
  TADSQLScriptFileNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADSQLScriptFileNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADSQLScriptFileNameProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    oDialog.DefaultExt := 'sql';
    oDialog.Filter := S_AD_RegSQLFilter;
    oDialog.FileName := GetValue;
    if oDialog.Execute then
      SetValue(oDialog.FileName);
  finally
    ADFree(oDialog);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADTableNameProp                                                              }
{-------------------------------------------------------------------------------}
type
  TADTableNameProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: Boolean; override;
  end;

{-------------------------------------------------------------------------------}
function TADTableNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
function TADTableNameProp.AutoFill: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADTableNameProp.GetValues(Proc: TGetStrProc);
var
  oList: TADStringList;
  i: Integer;
  oTab: TADTable;
  oConn: TADCustomConnection;
  sValue, sCatalogName, sSchemaName, sBaseObjectName, sObjectName: String;
begin
  oTab := GetComponent(0) as TADTable;
  try
    oConn := oTab.Command.AcquireConnection;
    oList := TADStringList.Create;
    try
      sCatalogName := oTab.CatalogName;
      sSchemaName := oTab.SchemaName;
      sValue := {$IFDEF AnyDAC_FPC} FirstValue {$ELSE} Value {$ENDIF};
      if (sCatalogName = '') and (sSchemaName = '') and (sValue <> '') then
        oConn.DecodeObjectName(sValue, sCatalogName, sSchemaName,
          sBaseObjectName, sObjectName);
      oConn.GetTableNames(DefStr(sCatalogName, GADDTCatalog),
                          DefStr(sSchemaName, GADDTSchema),
                          GADDTMask, oList, GADDTScope, GADDTTableKinds,
                          GADDTFullName);
      for i := 0 to oList.Count - 1 do
        Proc(oList[i]);
    finally
      ADFree(oList);
      oTab.Command.ReleaseConnection(oConn);
    end;
  except
  end;
end;

{-------------------------------------------------------------------------------}
{ TADUpdateTableNameProp                                                        }
{-------------------------------------------------------------------------------}
type
  TADUpdateTableNameProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: Boolean; override;
  end;

{-------------------------------------------------------------------------------}
function TADUpdateTableNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
function TADUpdateTableNameProp.AutoFill: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateTableNameProp.GetValues(Proc: TGetStrProc);
var
  oList: TADStringList;
  i: Integer;
  oObj: TPersistent;
  oConn: TADCustomConnection;
begin
  oObj := (GetComponent(0) as TADBottomUpdateOptions).OwnerObj;
  if (oObj <> nil) and (oObj is TADCommand) then begin
    oList := TADStringList.Create;
    try
      try
        oConn := TADCommand(oObj).AcquireConnection;
        try
          oConn.GetTableNames(GADDTCatalog, GADDTSchema, GADDTMask,
                              oList, GADDTScope, GADDTTableKinds, GADDTFullName);
          for i := 0 to oList.Count - 1 do
            Proc(oList[i]);
        finally
          TADCommand(oObj).ReleaseConnection(oConn);
        end;
      finally
        ADFree(oList);
      end;
    except
      // silent
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADGeneratorNameProp                                                          }
{-------------------------------------------------------------------------------}
type
  TADGeneratorNameProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function AutoFill: Boolean; override;
  end;

{-------------------------------------------------------------------------------}
function TADGeneratorNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
function TADGeneratorNameProp.AutoFill: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADGeneratorNameProp.GetValues(Proc: TGetStrProc);
var
  oList: TADStringList;
  i: Integer;
  oObj: TPersistent;
  oConn: TADCustomConnection;
begin
  oList := TADStringList.Create;
  try
    try
      if GetComponent(0) is TADUpdateOptions then begin
        oObj := (GetComponent(0) as TADUpdateOptions).OwnerObj;
        if (oObj <> nil) and (oObj is TADCustomCommand) then begin
          oConn := TADCommand(oObj).AcquireConnection;
          try
            oConn.GetGeneratorNames(GADDTCatalog, GADDTSchema, GADDTMask,
                                    oList, GADDTScope, GADDTFullName);
          finally
            TADCommand(oObj).ReleaseConnection(oConn);
          end;
        end
        else if (oObj <> nil) and (oObj is TADCustomConnection) then begin
          oConn := TADCustomConnection(oObj);
          oConn.GetGeneratorNames(GADDTCatalog, GADDTSchema, GADDTMask,
                                  oList, GADDTScope, GADDTFullName);
        end;
      end
      else if GetComponent(0) is TADAutoIncField then begin
        oObj := (GetComponent(0) as TADAutoIncField).DataSet;
        if (oObj <> nil) and (oObj is TADAdaptedDataSet) and
           (TADAdaptedDataSet(oObj).Command <> nil) then begin
          oObj := TADAdaptedDataSet(oObj).Command;
          oConn := TADCommand(oObj).AcquireConnection;
          try
            oConn.GetGeneratorNames(GADDTCatalog, GADDTSchema, GADDTMask,
                                    oList, GADDTScope, GADDTFullName);
          finally
            TADCommand(oObj).ReleaseConnection(oConn);
          end;
        end;
      end;
    except
    end;
    for i := 0 to oList.Count - 1 do
      Proc(oList[i]);
  finally
    ADFree(oList);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADAutoIncFieldsProp, TADKeyFieldsProp                                        }
{-------------------------------------------------------------------------------}
type
  TADAutoIncFieldsProp = class(TADFieldsProp)
  protected
    procedure GetSetup(out ADS: TDataSet; out ACaption: String); override;
  end;

  TADKeyFieldsProp = class(TADAutoIncFieldsProp)
  protected
    procedure GetSetup(out ADS: TDataSet; out ACaption: String); override;
  end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncFieldsProp.GetSetup(out ADS: TDataSet;
  out ACaption: String);
var
  oObj: TPersistent;
begin
  ADS := nil;
  if GetComponent(0) is TADBottomUpdateOptions then begin
    oObj := (GetComponent(0) as TADBottomUpdateOptions).OwnerObj;
    if (oObj <> nil) and (oObj is TADCustomCommand) then
      ADS := TADCustomCommand(oObj).DataSet
    else if (oObj <> nil) and (oObj is TADDataSet) then
      ADS := TADDataSet(oObj);
  end;
  ACaption := 'Select auto incremented field list';
end;

{-------------------------------------------------------------------------------}
procedure TADKeyFieldsProp.GetSetup(out ADS: TDataSet; out ACaption: String);
begin
  inherited GetSetup(ADS, ACaption);
  ACaption := 'Select primary key field list';
end;

{-------------------------------------------------------------------------------}
{ TADFolderProp                                                                 }
{-------------------------------------------------------------------------------}
type
  TADFolderProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADFolderProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADFolderProp.Edit;
var
  s: String;
begin
  s := ADBrowseForFolder(0, 'Select folder');
  if s <> '' then
    SetValue(s);
end;

{-------------------------------------------------------------------------------}
{ TADStoreExtProp                                                               }
{-------------------------------------------------------------------------------}
type
  TADStoreExtProp = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{-------------------------------------------------------------------------------}
function TADStoreExtProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADStoreExtProp.GetValues(Proc: TGetStrProc);
begin
  Proc('.xml');
  Proc('.adb');
end;

{-------------------------------------------------------------------------------}
{ TADPersistentFileNameProp                                                     }
{-------------------------------------------------------------------------------}
type
  TADPersistentFileNameProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADPersistentFileNameProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADPersistentFileNameProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    oDialog.DefaultExt := 'adb';
    oDialog.Filter := S_AD_RegADSFilter;
    oDialog.FileName := GetValue;
    if oDialog.Execute then
      SetValue(oDialog.FileName);
  finally
    ADFree(oDialog);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADVendorLibProp                                                              }
{-------------------------------------------------------------------------------}
type
  TADVendorLibProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

{-------------------------------------------------------------------------------}
function TADVendorLibProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADVendorLibProp.Edit;
var
  oDialog: TOpenDialog;
begin
  oDialog := TOpenDialog.Create(nil);
  try
    oDialog.DefaultExt := 'dll';
    oDialog.Filter := S_AD_RegDLLFilter;
    oDialog.FileName := GetValue;
    if oDialog.Execute then
      SetValue(oDialog.FileName);
  finally
    ADFree(oDialog);
  end;
end;

{$IFNDEF AnyDAC_MOBILE}
{-------------------------------------------------------------------------------}
{ TADOraclVendorHomeProp                                                        }
{-------------------------------------------------------------------------------}
type
  TADOraclVendorHomeProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{-------------------------------------------------------------------------------}
function TADOraclVendorHomeProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADOraclVendorHomeProp.GetValues(Proc: TGetStrProc);
var
  oHomes: TADStringList;
  i: Integer;
begin
  oHomes := TADStringList.Create;
  try
    TADPhysOracleDriverLink.GetOracleHomes(oHomes);
    for i := 0 to oHomes.Count - 1 do
      Proc(oHomes[i]);
  finally
    ADFree(oHomes);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADODBCDriverProp                                                             }
{-------------------------------------------------------------------------------}
type
  TADODBCDriverProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{-------------------------------------------------------------------------------}
function TADODBCDriverProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList, paMultiSelect];
end;

{-------------------------------------------------------------------------------}
procedure TADODBCDriverProp.GetValues(Proc: TGetStrProc);
var
  oLib: TODBCLib;
  oEnv: TODBCEnvironment;
  sDriver, sAttr: String;
begin
  oLib := TODBCLib.Allocate('', '', nil);
  oEnv := TODBCEnvironment.Create(oLib, nil);
  try
    if oEnv.DriverFirst(sDriver, sAttr) then
      repeat
        Proc(sDriver);
      until not oEnv.DriverNext(sDriver, sAttr);
  finally
    ADFree(oEnv);
    TODBCLib.Release(oLib);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADEventAlerterKindProp                                                       }
{-------------------------------------------------------------------------------}
type
  TADEventAlerterKindProp = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

{-------------------------------------------------------------------------------}
function TADEventAlerterKindProp.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

{-------------------------------------------------------------------------------}
procedure TADEventAlerterKindProp.GetValues(Proc: TGetStrProc);
begin
  Proc('');
end;

{$IFNDEF AnyDAC_FPC}
{-------------------------------------------------------------------------------}
{ TADExpert                                                                     }
{-------------------------------------------------------------------------------}
  {$IFDEF AnyDAC_D6}
type
  TADExpert = class(TNotifierObject, IOTAWIzard)
  private
    FAnyDACMainMI: TMenuItem;
    FMonitorMI: TMenuItem;
    FExplorerMI: TMenuItem;
    FPreferencesMI: TMenuItem;
    FSplitter1: TMenuItem;
    FHelpMI: TMenuItem;
    FFAQMI: TMenuItem;
    FForumsMI: TMenuItem;
    FSplitter2: TMenuItem;
    FAnyDACMI: TMenuItem;
    FAboutMI: TMenuItem;
    FErrDlg: TADGUIxErrorDialog;
    FLoginDlg: TADGUIxLoginDialog;
    FAsyncDlg: TADGUIxAsyncExecuteDialog;
  {$IFDEF AnyDAC_MONITOR}
    FMoniRemote: TADMoniRemoteClientLink;
    FMoniFlatFile: TADMoniFlatFileClientLink;
  {$ENDIF}
    procedure MonitorClick(Sender: TObject);
    procedure ExplorerClick(Sender: TObject);
    procedure SetupClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure FAQClick(Sender: TObject);
    procedure ForumsClick(Sender: TObject);
    procedure AnyDACClick(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure RunRegisteredApp(const AName: String);
  public
    constructor Create;
    destructor Destroy; override;
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
  end;

{-------------------------------------------------------------------------------}
constructor TADExpert.Create;
var
  oNTAServ: INTAServices;
  oMainMenu: TMainMenu;
  oBmp: TBitmap;
  {iImgMain,} iImgMoni, iImgExpl, i: Integer;
begin
  inherited Create;
  FAnyDACMainMI := nil;
  FMonitorMI := nil;
  FExplorerMI := nil;
  FPreferencesMI := nil;
  FSplitter1 := nil;
  FAnyDACMainMI := nil;
  FHelpMI := nil;
  FFAQMI := nil;
  FForumsMI := nil;
  FSplitter2 := nil;
  FAnyDACMI := nil;
  FAboutMI := nil;

  oNTAServ := BorlandIDEServices as INTAServices;
  oMainMenu := oNTAServ.MainMenu;

  oBmp := TBitmap.Create;
  try
    oBmp.LoadFromResourceName(FindResourceHInstance(HInstance), C_ADMenu);
    {iImgMain := } oNTAServ.AddMasked(oBmp, oBmp.Canvas.Pixels[0, 0]);
    oBmp.LoadFromResourceName(FindResourceHInstance(HInstance), C_ADMonitor);
    iImgMoni := oNTAServ.AddMasked(oBmp, oBmp.Canvas.Pixels[0, 0]);
    oBmp.LoadFromResourceName(FindResourceHInstance(HInstance), C_ADExplorer);
    iImgExpl := oNTAServ.AddMasked(oBmp, oBmp.Canvas.Pixels[0, 0]);
  finally
    ADFree(oBmp);
  end;

  for i := 0 to oMainMenu.Items.Count - 1 do
    if oMainMenu.Items[i].Name = 'ToolsMenu' then begin
      FAnyDACMainMI := NewItem('&' + C_AD_Product, 0, False, True, nil, -1, 'ADMenu');
      // FAnyDACMainMI.ImageIndex := iImgMain;

      FExplorerMI := NewItem(S_AD_Explorer, 0, False, True, ExplorerClick, -1, 'ADExplorerItem');
      FExplorerMI.ImageIndex := iImgExpl;
      FMonitorMI := NewItem(S_AD_Monitor, 0, False, True, MonitorClick, -1, 'ADMonitorItem');
      FMonitorMI.ImageIndex := iImgMoni;
      FPreferencesMI := NewItem(S_AD_Preferences, 0, False, True, SetupClick, -1, 'ADPreferencesItem');
      FSplitter1 := NewItem('-', 0, False, False, nil, -1, 'ADSplitter1');
      FHelpMI := NewItem(S_AD_Help, 0, False, True, HelpClick, -1, 'ADHelpItem');
      FFAQMI := NewItem(S_AD_FAQ, 0, False, True, FAQClick, -1, 'ADFAQItem');
      FForumsMI := NewItem(S_AD_Forums, 0, False, True, ForumsClick, -1, 'ADForumsItem');
      FSplitter2 := NewItem('-', 0, False, False, nil, -1, 'ADSplitter2');
      FAnyDACMI := NewItem(S_AD_ADHome, 0, False, True, AnyDACClick, -1, 'ADHomeItem');
      FAboutMI := NewItem(S_AD_About, 0, False, True, AboutClick, -1, 'ADAboutItem');

      FAnyDACMainMI.Add([FExplorerMI, FMonitorMI, FPreferencesMI, FSplitter1,
        FHelpMI, FFAQMI, FForumsMI, FSplitter2, FAnyDACMI, FAboutMI]);
      oMainMenu.Items.Insert(i + 1, FAnyDACMainMI);

      Break;
    end;

  FErrDlg := TADGUIxErrorDialog.Create(nil);
  FLoginDlg := TADGUIxLoginDialog.Create(nil);
  FLoginDlg.LoginRetries := $7FFFFFFF;
  FAsyncDlg := TADGUIxAsyncExecuteDialog.Create(nil);
  {$IFDEF AnyDAC_MONITOR}
  if GADMoniEnabled then begin
    FMoniRemote := TADMoniRemoteClientLink.Create(nil);
    FMoniRemote.Tracing := True;
    FMoniFlatFile := TADMoniFlatFileClientLink.Create(nil);
    FMoniFlatFile.Tracing := True;
  end;
  {$ENDIF}
end;

{-------------------------------------------------------------------------------}
destructor TADExpert.Destroy;
begin
  ADFreeAndNil(FExplorerMI);
  ADFreeAndNil(FMonitorMI);
  ADFreeAndNil(FPreferencesMI);
  ADFreeAndNil(FSplitter1);
  ADFreeAndNil(FHelpMI);
  ADFreeAndNil(FFAQMI);
  ADFreeAndNil(FForumsMI);
  ADFreeAndNil(FSplitter2);
  ADFreeAndNil(FAnyDACMI);
  ADFreeAndNil(FAboutMI);
  ADFreeAndNil(FAnyDACMainMI);

  ADFreeAndNil(FErrDlg);
  ADFreeAndNil(FLoginDlg);
  ADFreeAndNil(FAsyncDlg);
  {$IFDEF AnyDAC_MONITOR}
  ADFreeAndNil(FMoniRemote);
  ADFreeAndNil(FMoniFlatFile);
  {$ENDIF}
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADExpert.GetIDString: string;
begin
  Result := 'Embarcadero.' + C_AD_Product + '.Expert';
end;

{-------------------------------------------------------------------------------}
function TADExpert.GetName: string;
begin
  Result := C_AD_Product + 'Expert';
end;

{-------------------------------------------------------------------------------}
function TADExpert.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.Execute;
begin
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.RunRegisteredApp(const AName: String);
var
  sPath: String;
begin
  sPath := ADExpandStr(ADReadRegValue(AName));
  if sPath = '' then
    MessageDlg('No value [' + AName + '] in ' + C_AD_Product + ' registry', mtError, [mbOk], -1)
  else
    ADShell(sPath, S_AD_LComp_Design);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.ExplorerClick(Sender: TObject);
begin
  RunRegisteredApp(S_AD_ExplValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.MonitorClick(Sender: TObject);
begin
  RunRegisteredApp(S_AD_MoniValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.SetupClick(Sender: TObject);
var
  lPriorMoniEnabled: Boolean;
begin
  lPriorMoniEnabled := GADMoniEnabled;
  if TfrmADGUIxFormsDesignTimeOptions.Execute then begin
  {$IFDEF AnyDAC_MONITOR}
    if not lPriorMoniEnabled and GADMoniEnabled then
      MessageDlg('Restart Delphi IDE to enable tracing', mtInformation, [mbOk], -1);
  {$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.HelpClick(Sender: TObject);
begin
  RunRegisteredApp(S_AD_HelpValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.FAQClick(Sender: TObject);
begin
  ADShell(C_AD_FAQ_Link, S_AD_LComp_Design);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.ForumsClick(Sender: TObject);
begin
  ADShell(C_AD_Forums_Link, S_AD_LComp_Design);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.AnyDACClick(Sender: TObject);
begin
  ADShell(C_AD_Link, S_AD_LComp_Design);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.AboutClick(Sender: TObject);
begin
  TfrmADGUIxFormsAbout.Execute(HInstance);
end;

  {$ELSE}
{-------------------------------------------------------------------------------}
type
  TADExpert = class(TIExpert)
  private
    FAnyDACMainMI: TIMenuItemIntf;
    FMonitorMI: TIMenuItemIntf;
    FExplorerMI: TIMenuItemIntf;
    FPreferencesMI: TIMenuItemIntf;
    FSplitter1: TIMenuItemIntf;
    FHelpMI: TIMenuItemIntf;
    FFAQMI: TIMenuItemIntf;
    FForumsMI: TIMenuItemIntf;
    FSplitter2: TIMenuItemIntf;
    FAnyDACMI: TIMenuItemIntf;
    FAboutMI: TIMenuItemIntf;
    FErrDlg: TADGUIxErrorDialog;
    FLoginDlg: TADGUIxLoginDialog;
    FAsyncDlg: TADGUIxAsyncExecuteDialog;
  {$IFDEF AnyDAC_MONITOR}
    FMoniRemote: TADMoniRemoteClientLink;
    FMoniFlatFile: TADMoniFlatFileClientLink;
  {$ENDIF}
    procedure ExplorerClick(Sender: TIMenuItemIntf);
    procedure MonitorClick(Sender: TIMenuItemIntf);
    procedure SetupClick(Sender: TIMenuItemIntf);
    procedure HelpClick(Sender: TIMenuItemIntf);
    procedure FAQClick(Sender: TIMenuItemIntf);
    procedure ForumsClick(Sender: TIMenuItemIntf);
    procedure AnyDACClick(Sender: TIMenuItemIntf);
    procedure AboutClick(Sender: TIMenuItemIntf);
    procedure RunRegisteredApp(const AName: String);
  public
    constructor Create;
    destructor Destroy; override;
    function GetName: string; override;
    function GetStyle: TExpertStyle; override;
    function GetIDString: string; override;
  end;

{ --------------------------------------------------------------------------- }
function TADExpert.GetIDString: string;
begin
  Result := 'Embarcadero.' + C_AD_Product + '.Expert';
end;

{ --------------------------------------------------------------------------- }
function TADExpert.GetName: string;
begin
  Result := C_AD_Product + 'Expert';
end;

{ --------------------------------------------------------------------------- }
function TADExpert.GetStyle: TExpertStyle;
begin
  Result := esAddIn;
end;

{ --------------------------------------------------------------------------- }
constructor TADExpert.Create;
var
  oMainMenu: TIMainMenuIntf;
  oMenuItems: TIMenuItemIntf;
  oToolsMenu: TIMenuItemIntf;
begin
  inherited Create;
  FAnyDACMainMI := nil;
  FMonitorMI := nil;
  FExplorerMI := nil;
  FPreferencesMI := nil;
  FSplitter1 := nil;
  FHelpMI := nil;
  FFAQMI := nil;
  FForumsMI := nil;
  FSplitter2 := nil;
  FAnyDACMI := nil;
  FAboutMI := nil;

  oToolsMenu := nil;
  oMenuItems := nil;
  oMainMenu := ToolServices.GetMainMenu;
  if oMainMenu <> nil then
  try
    oMenuItems := oMainMenu.GetMenuItems;
    if oMenuItems <> nil then begin
      FAnyDACMainMI := oMainMenu.FindMenuItem('FireDACMenu');
      if FAnyDACMainMI = nil then begin
        oToolsMenu := oMainMenu.FindMenuItem('ToolsMenu');
        if oToolsMenu <> nil then begin
          FAnyDACMainMI := oMenuItems.InsertItem(oToolsMenu.GetIndex + 1,
            '&' + C_AD_Product, 'FireDACMenu', '', 0, 0, 0, [mfVisible, mfEnabled], nil);
          FExplorerMI := FAnyDACMainMI.InsertItem(0, S_AD_Explorer,
            'ADExplorerItem', '', 0, 0, 0, [mfVisible, mfEnabled], ExplorerClick);
          FMonitorMI := FAnyDACMainMI.InsertItem(1, S_AD_Monitor,
            'ADMonitorItem', '', 0, 0, 0, [mfVisible, mfEnabled], MonitorClick);
          FPreferencesMI := FAnyDACMainMI.InsertItem(2, S_AD_Preferences,
            'ADPreferencesItem', '', 0, 0, 0, [mfVisible, mfEnabled], SetupClick);
          FSplitter1 := FAnyDACMainMI.InsertItem(3, '-',
            'ADSplitter1Item', '', 0, 0, 0, [mfVisible, mfEnabled], nil);
          FHelpMI := FAnyDACMainMI.InsertItem(4, S_AD_Help,
            'ADHelpItem', '', 0, 0, 0, [mfVisible, mfEnabled], HelpClick);
          FFAQMI := FAnyDACMainMI.InsertItem(5, S_AD_FAQ,
            'ADFAQItem', '', 0, 0, 0, [mfVisible, mfEnabled], FAQClick);
          FForumsMI := FAnyDACMainMI.InsertItem(6, S_AD_Forums,
            'ADForumsItem', '', 0, 0, 0, [mfVisible, mfEnabled], ForumsClick);
          FSplitter2 := FAnyDACMainMI.InsertItem(7, '-',
            'ADSplitter2', '', 0, 0, 0, [mfVisible, mfEnabled], nil);
          FAnyDACMI := FAnyDACMainMI.InsertItem(8, S_AD_ADHome,
            'ADHomeItem', '', 0, 0, 0, [mfVisible, mfEnabled], AnyDACClick);
          FAboutMI := FAnyDACMainMI.InsertItem(9, S_AD_About,
            'ADAboutItem', '', 0, 0, 0, [mfVisible, mfEnabled], AboutClick);
        end;
      end;
    end;
  finally
    ADFreeAndNil(oToolsMenu);
    ADFreeAndNil(oMenuItems);
    ADFreeAndNil(oMainMenu);
  end;

  FErrDlg := TADGUIxErrorDialog.Create(nil);
  FLoginDlg := TADGUIxLoginDialog.Create(nil);
  FLoginDlg.LoginRetries := $7FFFFFFF;
  FAsyncDlg := TADGUIxAsyncExecuteDialog.Create(nil);
  {$IFDEF AnyDAC_MONITOR}
  FMoniRemote := TADMoniRemoteClientLink.Create(nil);
  FMoniRemote.Tracing := GADMoniEnabled;
  FMoniFlatFile := TADMoniFlatFileClientLink.Create(nil);
  FMoniFlatFile.Tracing := GADMoniEnabled;
  {$ENDIF}
end;

{ --------------------------------------------------------------------------- }
destructor TADExpert.Destroy;
begin
  ADFreeAndNil(FExplorerMI);
  ADFreeAndNil(FMonitorMI);
  ADFreeAndNil(FPreferencesMI);
  ADFreeAndNil(FSplitter1);
  ADFreeAndNil(FHelpMI);
  ADFreeAndNil(FFAQMI);
  ADFreeAndNil(FForumsMI);
  ADFreeAndNil(FSplitter2);
  ADFreeAndNil(FAnyDACMI);
  ADFreeAndNil(FAboutMI);
  ADFreeAndNil(FAnyDACMainMI);

  ADFreeAndNil(FErrDlg);
  ADFreeAndNil(FLoginDlg);
  ADFreeAndNil(FAsyncDlg);
  {$IFDEF AnyDAC_MONITOR}
  ADFreeAndNil(FMoniRemote);
  ADFreeAndNil(FMoniFlatFile);
  {$ENDIF}
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.RunRegisteredApp(const AName: String);
var
  sPath: String;
begin
  sPath := ADExpandStr(ADReadRegValue(AName));
  if sPath = '' then
    MessageDlg('No value [' + AName + '] in ' + C_AD_Product + ' registry', mtError, [mbOk], -1)
  else
    ADShell(sPath, S_AD_LComp_Design);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.ExplorerClick(Sender: TIMenuItemIntf);
begin
  RunRegisteredApp(S_AD_ExplValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.MonitorClick(Sender: TIMenuItemIntf);
begin
  RunRegisteredApp(S_AD_MoniValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.SetupClick(Sender: TIMenuItemIntf);
begin
  if TfrmADGUIxFormsDesignTimeOptions.Execute then begin
  {$IFDEF AnyDAC_MONITOR}
    FMoniRemote.Tracing := GADMoniEnabled;
    FMoniFlatFile.Tracing := GADMoniEnabled;
  {$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.HelpClick(Sender: TIMenuItemIntf);
begin
  RunRegisteredApp(S_AD_HelpValName);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.FAQClick(Sender: TIMenuItemIntf);
begin
  ADShell(C_AD_FAQ_Link, S_AD_LComp_Design);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.ForumsClick(Sender: TIMenuItemIntf);
begin
  ADShell(C_AD_Forums_Link, S_AD_LComp_Design);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.AnyDACClick(Sender: TIMenuItemIntf);
begin
  ADShell(C_AD_Link, S_AD_LComp_Design);
end;

{-------------------------------------------------------------------------------}
procedure TADExpert.AboutClick(Sender: TIMenuItemIntf);
begin
  TfrmADGUIxFormsAbout.Execute(HInstance);
end;
  {$ENDIF}
{$ENDIF}

{-------------------------------------------------------------------------------}
{ Splash screen                                                                 }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D9}
var
  AboutBoxServices: IOTAAboutBoxServices = nil;
  AboutBoxIndex: Integer = 0;

{-------------------------------------------------------------------------------}
procedure RegisterAboutBox;
var
  hProductImage: HBITMAP;
begin
  Supports(BorlandIDEServices, IOTAAboutBoxServices, AboutBoxServices);
  Assert(AboutBoxServices <> nil);
  hProductImage := LoadBitmap(FindResourceHInstance(HInstance), C_ADAbout);
  AboutBoxIndex := AboutBoxServices.AddPluginInfo(C_AD_ProductFull,
    C_AD_ProductFull + C_AD_EOL + C_AD_Copyright + '.' + C_AD_EOL +
    'All rights reserved.' + C_AD_EOL + C_AD_Link, hProductImage, 
    False, 'Registered');
end;

{-------------------------------------------------------------------------------}
procedure UnregisterAboutBox;
begin
  if (AboutBoxIndex <> 0) and (AboutBoxServices <> nil) then begin
    AboutBoxServices.RemoveProductInfo(AboutBoxIndex);
    AboutBoxIndex := 0;
    AboutBoxServices := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure RegisterSplashScreen;
var
  hProductImage: HBITMAP;
begin
  Assert(SplashScreenServices <> nil);
  hProductImage := LoadBitmap(FindResourceHInstance(HInstance), C_ADLogo);
  SplashScreenServices.AddPluginBitmap(C_AD_ProductFull, hProductImage,
    False, 'Registered');
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ Registration                                                                  }
{-------------------------------------------------------------------------------}
procedure RegisterUnituADCompClient;
begin
{$IFNDEF AnyDAC_D6}
  CaptureDataSetEditorClass;
{$ENDIF}

  RegisterComponents(C_AD_Product, [TADManager, TADConnection, TADTransaction,
    TADCommand, TADTableAdapter, TADSchemaAdapter, TADMemTable, TADQuery,
    TADStoredProc, TADTable, TADUpdateSQL, TADDataMove, TADScript,
    TADMetaInfoQuery, TADEventAlerter, TADLocalSQL]);
  RegisterComponents(C_AD_Product + ' UI', [TADGUIxErrorDialog, TADGUIxLoginDialog,
    TADGUIxAsyncExecuteDialog, TADGUIxScriptDialog, TADGUIxWaitCursor]);
  RegisterComponents(C_AD_Product + ' Links', [
{$IFDEF AnyDAC_MONITOR}
    TADMoniRemoteClientLink, TADMoniCustomClientLink, TADMoniFlatFileClientLink,
{$ENDIF}
{$IFNDEF AnyDAC_MOBILE}
    TADPhysOracleDriverLink, TADPhysDB2DriverLink, TADPhysMSSQLDriverLink,
    TADPhysODBCDriverLink, TADPhysMSAccessDriverLink, TADPhysMySQLDriverLink,
    TADPhysASADriverLink, TADPhysADSDriverLink,
    TADPhysPGDriverLink,
{$ENDIF}
    TADPhysIBDriverLink, TADPhysSQLiteDriverLink
{$IFDEF AnyDAC_DBX}
  {$IFDEF AnyDAC_D11}
  , TADPhysTDBXDriverLink
    {$IFDEF AnyDAC_D16}
      {$IFNDEF AnyDAC_ProSKU}
  , TADPhysDataSnapDriverLink
      {$ENDIF}
    {$ENDIF}
  {$ELSE}
    {$IFDEF AnyDAC_D6}
  , TADPhysDBXDriverLink
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
    ]);
  RegisterComponents(C_AD_Product + ' Services', [
{$IFNDEF AnyDAC_MOBILE}
    TADMSAccessService,
    {$IFDEF AnyDAC_ASM}
    TADASABackup, TADASAValidate,
    {$ENDIF}
    TADADSBackup, TADADSRestore, TADADSUtility,
{$ENDIF}
    TADIBBackup, TADIBRestore, TADIBValidate, TADIBTrace, TADIBSecurity,
{$IFNDEF AnyDAC_MOBILE}
    TADIBNBackup, TADIBNRestore,
{$ENDIF}
    TADSQLiteFunction, TADSQLiteCollation, TADSQLiteRTree, TADSQLiteBackup,
      TADSQLiteValidate, TADSQLiteSecurity
  ]);
  RegisterComponents(C_AD_Product + ' Devs', [TfrmADGUIxFormsFetchOptions,
    TfrmADGUIxFormsFormatOptions, TfrmADGUIxFormsUpdateOptions,
    TfrmADGUIxFormsResourceOptions, TADGUIxFormsPanelTree, TADGUIxFormsMemo,
    TADGUIxFormsDblListBox]);
{$IFNDEF AnyDAC_FPC}
  RegisterFields([TADWideMemoField, TADAutoIncField, TADSQLTimeIntervalField,
    TADXMLField
  {$IFDEF AnyDAC_D12}
    {$IFNDEF AnyDAC_D14}
    // D2009 misses registration of these fields
    // SP2 will fix that
    , TLongWordField, TShortintField, TByteField, TExtendedField
    {$ENDIF}
  {$ENDIF}
  ]);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(String), TADCustomManager,
    'ConnectionDefFileName', TADConnectionDefFileNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomManager,
    'DriverDefFileName', TADConnectionDefFileNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomManager,
    'GUIxProvider', TADProviderProp);
{$IFDEF AnyDAC_D6}
  RegisterSelectionEditor(TADCustomManager, TADSelectionEditor);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(String), TADGUIxComponent,
    'Provider', TADProviderProp);
{$IFDEF AnyDAC_D6}
  RegisterSelectionEditor(TADGUIxComponent, TADSelectionEditor);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(String), TADCustomConnection,
    'ConnectionDefName', TADConnectionDefNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomConnection,
    'DriverName', TADDriverNameProp);
  RegisterComponentEditor(TADCustomConnection, TADConnectionEditor);
{$IFDEF AnyDAC_D6}
  RegisterSelectionEditor(TADCustomConnection, TADSelectionEditor);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(String), TADCustomCommand,
    'ConnectionName', TADConnectionNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomCommand,
    'CatalogName', TADCatalogNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomCommand,
    'SchemaName', TADSchemaNameProp);
  // 1) BaseObjectName, Oracle, skStoredProc -> Packages
  // CatalogName
  // SchemaName
  // 2) CommandEditor = Query Editor
{$IFDEF AnyDAC_D6}
  RegisterSelectionEditor(TADCustomCommand, TADSelectionEditor);
{$ENDIF}

  RegisterPropertyEditor(TypeInfo(String), TADAggregate,
    'IndexName', TADIndexNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADIndex,
    'Fields', TADIndexFieldNamesProp);
  RegisterPropertyEditor(TypeInfo(String), TADIndex,
    'CaseInsFields', TADIndexFieldNamesSimpleProp);
  RegisterPropertyEditor(TypeInfo(String), TADIndex,
    'DescFields', TADIndexFieldNamesSimpleProp);

{$IFDEF AnyDAC_D6}
  RegisterSelectionEditor(TADDataSet, TADSelectionEditor);
{$ENDIF}
  RegisterComponentEditor(TADDataSet, TADDataSetEditor);
  RegisterPropertyEditor(TypeInfo(String), TADDataSet,
    'IndexName', TADIndexNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADDataSet,
    'IndexFieldNames', TADIndexFieldNamesProp);
  RegisterPropertyEditor(TypeInfo(String), TADDataSet,
    'MasterFields', TADMasterFieldsProp);
  RegisterPropertyEditor(TypeInfo(String), TADDataSet,
    'DetailFields', TADDetailFieldsProp);

  RegisterPropertyEditor(TypeInfo(String), TADAutoIncField,
    'GeneratorName', TADGeneratorNameProp);

  RegisterPropertyEditor(TypeInfo(String), TADRdbmsDataSet,
    'ConnectionName', TADConnectionNameProp);

  RegisterComponentEditor(TADCustomCommand, TADCommandEditor);
  RegisterComponentEditor(TADCustomQuery, TADQueryEditor);
{$IFDEF AnyDAC_D6}
  RegisterPropertyEditor(TypeInfo(TStrings), TComponent,
    'SQL', TADSQLProperty);
  RegisterPropertyEditor(TypeInfo(TStrings), TComponent,
    'CommandText', TADSQLProperty);
{$ENDIF}

  RegisterComponentEditor(TADCustomStoredProc, TADStoredProcEditor);
  RegisterPropertyEditor(TypeInfo(String), TADCustomStoredProc,
    'CatalogName', TADCatalogNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomStoredProc,
    'SchemaName', TADSchemaNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomStoredProc,
    'PackageName', TADPackageNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADCustomStoredProc,
    'StoredProcName', TADStoredProcNameProp);

  RegisterPropertyEditor(TypeInfo(String), TADUpdateSQL,
    'ConnectionName', TADConnectionNameProp);
  RegisterComponentEditor(TADUpdateSQL, TADUpdateSQLEditor);

  RegisterPropertyEditor(TypeInfo(String), TADDataMove,
    'TextFileName', TADTextFileNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADDataMove,
    'LogFileName', TADLogFileNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADMappingItem,
    'SourceFieldName', TADDataMoveMapFieldEditor);
  RegisterPropertyEditor(TypeInfo(String), TADMappingItem,
    'DestinationFieldName', TADDataMoveMapFieldEditor);
  RegisterComponentEditor(TADDataMove, TADDataMoveEditor);

  RegisterPropertyEditor(TypeInfo(String), TADScript,
    'SQLScriptFileName', TADSQLScriptFileNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADScript,
    'DefaultDriverName', TADDriverNameProp);
  RegisterComponentEditor(TADScript, TADScriptEditor);

  RegisterComponentEditor(TADTable, TADDataSetEditor);
  RegisterPropertyEditor(TypeInfo(String), TADTable,
    'CatalogName', TADCatalogNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADTable,
    'SchemaName', TADSchemaNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADTable,
    'TableName', TADTableNameProp);

  RegisterPropertyEditor(TypeInfo(String), TADMetaInfoQuery,
    'CatalogName', TADCatalogNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADMetaInfoQuery,
    'SchemaName', TADSchemaNameProp);

  RegisterPropertyEditor(TypeInfo(String), TADBottomUpdateOptions,
    'UpdateTableName', TADUpdateTableNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADBottomUpdateOptions,
    'AutoIncFields', TADAutoIncFieldsProp);
  RegisterPropertyEditor(TypeInfo(String), TADBottomUpdateOptions,
    'KeyFields', TADKeyFieldsProp);
  RegisterPropertyEditor(TypeInfo(String), TADUpdateOptions,
    'GeneratorName', TADGeneratorNameProp);
  RegisterPropertyEditor(TypeInfo(String), TADTopResourceOptions,
    'DefaultStoreFolder', TADFolderProp);
  RegisterPropertyEditor(TypeInfo(String), TADTopResourceOptions,
    'BackupFolder', TADFolderProp);
  RegisterPropertyEditor(TypeInfo(String), TADBottomResourceOptions,
    'DefaultStoreExt', TADStoreExtProp);
  RegisterPropertyEditor(TypeInfo(String), TADBottomResourceOptions,
    'PersistentFileName', TADPersistentFileNameProp);

  RegisterPropertyEditor(TypeInfo(String), TADPhysDriverLink,
    'VendorLib', TADVendorLibProp);
  RegisterPropertyEditor(TypeInfo(String), TADPhysDriverLink,
    'VendorHome', TADFolderProp);
{$IFNDEF AnyDAC_MOBILE}
  RegisterPropertyEditor(TypeInfo(String), TADPhysOracleDriverLink,
    'VendorHome', TADOraclVendorHomeProp);
  RegisterPropertyEditor(TypeInfo(String), TADPhysASADriverLink,
    'ToolLib', TADVendorLibProp);
  RegisterPropertyEditor(TypeInfo(String), TADPhysODBCBaseDriverLink,
    'ODBCDriver', TADODBCDriverProp);
  RegisterPropertyEditor(TypeInfo(String), TADPhysADSDriverLink,
    'DefaultPath', TADFolderProp);
  RegisterPropertyEditor(TypeInfo(String), TADPhysADSDriverLink,
    'SearchPath', TADFolderProp);
  RegisterPropertyEditor(TypeInfo(String), TADADSService,
    'Database', TADFolderProp);
{$ENDIF}

{$IFNDEF AnyDAC_FPC}
  {$IFDEF AnyDAC_DesignTimeMenu}
    {$IFDEF AnyDAC_D6}
  RegisterPackageWizard(TADExpert.Create as IOTAWizard);
    {$ELSE}
  RegisterLibraryExpert(TADExpert.Create);
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure Register;
begin
{$IFDEF AnyDAC_FPC}
  RegisterUnit('uADCompClient', @RegisterUnituADCompClient);
{$ELSE}
  RegisterUnituADCompClient;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
initialization
{$IFDEF AnyDAC_FPC}
  {$I uADDcl.lrs}
{$ENDIF}
{$IFDEF AnyDAC_D9}
  RegisterAboutBox;
  RegisterSplashScreen;
{$ENDIF}

finalization
{$IFDEF AnyDAC_D9}
  UnRegisterAboutBox;
{$ENDIF}

end.
