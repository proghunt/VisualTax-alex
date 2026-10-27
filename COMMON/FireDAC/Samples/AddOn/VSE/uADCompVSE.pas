{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{     FireDAC Virtual Storage Engine base classes       }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompVSE;

interface

uses
  Classes, DB,
  uADStanIntf, uADDatSManager,
  uADCompDataSet;

type
  TADVSEFieldDef = class;
  TADVSEFieldDefs = class;
  TADVSESchema = class;
  TADVSESchemas = class;
  TADVSESessionField = class;
  TADVSESessionFields = class;
  TADVSESession = class;
  TADVSEManager = class;

  TADVSEFieldDefClass = class of TADVSEFieldDef;
  TADVSEFieldDefsClass = class of TADVSEFieldDefs;
  TADVSESchemaClass = class of TADVSESchema;
  TADVSESchemasClass = class of TADVSESchemas;
  TADVSESessionFieldClass = class of TADVSESessionField;
  TADVSESessionFieldsClass = class of TADVSESessionFields;
  TADVSESessionClass = class of TADVSESession;
  TADVSESessionsClass = class of TADVSESessions;

  {-----------------------------------------------------------------------------}
  // A virtual storage definition classes

  TADVSEFieldMode = (fmDisabled, fmInvisible, fmVisible);

  // A field definition
  TADVSEFieldDef = class(TNamedItem)
  private
    FID: Integer;
    FName: String;
    FPrecision: Integer;
    FDataType: TADDataType;
    FSize: Integer;
    FScale: Integer;
    FMode: TADVSEFieldMode;
    function GetSchema: TADVSESchema;
    function GetStorage: TADVSEManager;
    function GetActualMode: TADVSEFieldMode;
  protected
    function GetDisplayName: String; override;
  public
    constructor Create(ACollection: TCollection); override;
    procedure Assign(AValue: TPersistent); override;
    property Schema: TADVSESchema read GetSchema;
    property Storage: TADVSEManager read GetStorage;
    property ActualMode: TADVSEFieldMode read GetActualMode;
  published
    property ID: Integer read FID write FID;
    property Name: String read FName write FName;
    property DataType: TADDataType read FDataType write FDataType default dtUnknown;
    property Size: Integer read FSize write FSize default 0;
    property Precision: Integer read FPrecision write FPrecision default 0;
    property Scale: Integer read FScale write FScale default 0;
    property Mode: TADVSEFieldMode read FMode write FMode default fmVisible;
  end;

  // A collection of the field definitions
  TADVSEFieldDefs = class(TOwnedCollection)
  private
    function GetItems(AIndex: integer): TADVSEFieldDef;
    function GetSchema: TADVSESchema;
    function GetStorage: TADVSEManager;
  public
    constructor Create(ASchema: TADVSESchema);
    function Add: TADVSEFieldDef;
    property Schema: TADVSESchema read GetSchema;
    property Storage: TADVSEManager read GetStorage;
    property Items[AIndex: integer]: TADVSEFieldDef read GetItems; default;
  end;

  // A named set of the field definitions
  TADVSESchema = class(TCollectionItem)
  private
    FName: String;
    FFieldDefs: TADVSEFieldDefs;
    FMode: TADVSEFieldMode;
    function GetStorage: TADVSEManager;
    procedure SetFieldDefs(const AValue: TADVSEFieldDefs);
  protected
    function GetDisplayName: String; override;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(AValue: TPersistent); override;
    property Storage: TADVSEManager read GetStorage;
  published
    property Name: String read FName write FName;
    property Mode: TADVSEFieldMode read FMode write FMode default fmVisible;
    property FieldDefs: TADVSEFieldDefs read FFieldDefs write SetFieldDefs;
  end;

  // A collection of schemas
  TADVSESchemas = class(TOwnedCollection)
  private
    function GetItems(AIndex: integer): TADVSESchema;
    function GetStorage: TADVSEManager;
  public
    constructor Create(AStorage: TADVSEManager);
    function Add: TADVSESchema;
    property Storage: TADVSEManager read GetStorage;
    property Items[AIndex: integer]: TADVSESchema read GetItems; default;
  end;

  {-----------------------------------------------------------------------------}
  // A virtual storage session (run-time) classes

  // A field-def to column mapping
  TADVSESessionField = class(TCollectionItem)
  private
    FFieldDef: TADVSEFieldDef;
    FColumn: TADDatSColumn;
    FMode: TADVSEFieldMode;
    function GetSession: TADVSESession;
    function GetStorage: TADVSEManager;
  public
    destructor Destroy; override;
    property Session: TADVSESession read GetSession;
    property Storage: TADVSEManager read GetStorage;
    property FieldDef: TADVSEFieldDef read FFieldDef;
    property Column: TADDatSColumn read FColumn;
    property Mode: TADVSEFieldMode read FMode write FMode;
  end;

  // A collection of mappings
  TADVSESessionFields = class(TOwnedCollection)
  private
    function GetItems(AIndex: integer): TADVSESessionField;
    function GetSession: TADVSESession;
    function GetStorage: TADVSEManager;
  public
    constructor Create(ASession: TADVSESession);

    procedure AddAll;
    function AddField(AFieldDef: TADVSEFieldDef): TADVSESessionField;
    function FindField(const AFieldName: String): TADVSESessionField;
    function FieldByName(const AFieldName: String): TADVSESessionField;

    property Session: TADVSESession read GetSession;
    property Storage: TADVSEManager read GetStorage;
    property Items[AIndex: integer]: TADVSESessionField read GetItems; default;
  end;

  // A base column & virtual columns & storage engine binding (run-time session)
  TADVSESession = class(TCollectionItem, IUnknown,
    IADStanExpressionEvaluator, IADDataSetListener)
  private
    FOwner: TObject;
    FBaseColumnName: String;

    FTable: TADDatSTable;
    FBaseColumn: TADDatSColumn;
    FRow: TADDatSRow;
    FBuff: Pointer;
    FLen: LongWord;
    FFields: TADVSESessionFields;
    FDataSource: IADStanExpressionDataSource;
    function GetStorage: TADVSEManager;
    function GetDataSet: TADDataSet;

  protected
    // IUnknown
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    // IADStanExpressionEvaluator
    function GetSubAggregateCount: Integer;
    function GetSubAggregateKind(AIndex: Integer): TADAggregateKind;
    function GetDataSource: IADStanExpressionDataSource;
    function GetDataType: TADDataType;
    function HandleNotification(AKind: Word; AReason: Word;
      AParam1, AParam2: LongWord): Boolean;
    function Evaluate: Variant;
    function EvaluateSubAggregateArg(AIndex: Integer): Variant;

    // IADDataSetListener
    procedure ResultsetDefined(ADataSet: TADDataSet);
    procedure ResultsetReleasing(ADataSet: TADDataSet);
    procedure ResultsetActivated(ADataSet: TADDataSet);

    // introduced
    procedure DoAttaching; virtual;
    procedure DoAttached; virtual;
    procedure DoDetaching; virtual;
    procedure DoDetached; virtual;

  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;

    procedure Attach(ATable: TADDatSTable = nil);
    procedure Detach;
    procedure ApplyVisibility(ADataSet: TDataSet);

    property Storage: TADVSEManager read GetStorage;

    property Row: TADDatSRow read FRow;
    property Buff: Pointer read FBuff;
    property Len: LongWord read FLen;

    property DataSet: TADDataSet read GetDataSet;
    property Table: TADDatSTable read FTable;
    property BaseColumn: TADDatSColumn read FBaseColumn;
    property Fields: TADVSESessionFields read FFields;
  end;

  // A collection of sessions
  TADVSESessions = class(TOwnedCollection)
  private
    function GetStorage: TADVSEManager;
    function GetItems(AIndex: integer): TADVSESession;
  public
    constructor Create(AStorage: TADVSEManager);
    function FindSession(AOwner: TObject; const ABaseColumnName: String): TADVSESession;
    function AddSession(AOwner: TObject; const ABaseColumnName: String): TADVSESession;
    function EnsureSession(AOwner: TObject; const ABaseColumnName: String): TADVSESession;
    property Storage: TADVSEManager read GetStorage;
    property Items[AIndex: integer]: TADVSESession read GetItems; default;
  end;

  // A decoder and corresponding dictionary
  TADVSESessionEvent = procedure (ASender: TADVSEManager;
    ASession: TADVSESession; ADataSet: TADDataSet) of object;
  TADVSEManager = class(TADComponent)
  private
    FSchemas: TADVSESchemas;
    FSessions: TADVSESessions;
    FOnDecode: TADVSESessionEvent;
    FOnResultsetDefined: TADVSESessionEvent;
    FOnResultsetReleasing: TADVSESessionEvent;
    FOnResultsetActivated: TADVSESessionEvent;
    FAutoManage: Boolean;
    procedure SetSchemas(const AValue: TADVSESchemas);
  protected
    class function GetFieldDefClass: TADVSEFieldDefClass; virtual;
    class function GetFieldDefsClass: TADVSEFieldDefsClass; virtual;
    class function GetSchemaClass: TADVSESchemaClass; virtual;
    class function GetSchemasClass: TADVSESchemasClass; virtual;
    class function GetSessionFieldClass: TADVSESessionFieldClass; virtual;
    class function GetSessionFieldsClass: TADVSESessionFieldsClass; virtual;
    class function GetSessionClass: TADVSESessionClass; virtual;
    class function GetSessionsClass: TADVSESessionsClass; virtual;

    procedure DoResultsetDefined(ASession: TADVSESession; ADataSet: TADDataSet); virtual;
    procedure DoResultsetReleasing(ASession: TADVSESession; ADataSet: TADDataSet); virtual;
    procedure DoResultsetActivated(ASession: TADVSESession; ADataSet: TADDataSet); virtual;
    procedure DoDecode(ASession: TADVSESession; ADataSet: TADDataSet); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Sessions: TADVSESessions read FSessions;
  published
    property AutoManage: Boolean read FAutoManage write FAutoManage;
    property Schemas: TADVSESchemas read FSchemas write SetSchemas;
    property OnResultsetDefined: TADVSESessionEvent read FOnResultsetDefined
      write FOnResultsetDefined;
    property OnResultsetReleasing: TADVSESessionEvent read FOnResultsetReleasing
      write FOnResultsetReleasing;
    property OnResultsetActivated: TADVSESessionEvent read FOnResultsetActivated
      write FOnResultsetActivated;
    property OnDecode: TADVSESessionEvent read FOnDecode write FOnDecode;
  end;

implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ELSE}
  Windows,  
{$ENDIF}
  SysUtils;

{-------------------------------------------------------------------------------}
{ TADVSEFieldDef                                                                }
{-------------------------------------------------------------------------------}
constructor TADVSEFieldDef.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FMode := fmVisible;
end;

{-------------------------------------------------------------------------------}
procedure TADVSEFieldDef.Assign(AValue: TPersistent);
begin
  if AValue is TADVSEFieldDef then begin
    ID := TADVSEFieldDef(AValue).ID;
    Name := TADVSEFieldDef(AValue).Name;
    DataType := TADVSEFieldDef(AValue).DataType;
    Size := TADVSEFieldDef(AValue).Size;
    Precision := TADVSEFieldDef(AValue).Precision;
    Scale := TADVSEFieldDef(AValue).Scale;
    Mode := TADVSEFieldDef(AValue).Mode;
  end
  else
    inherited Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADVSEFieldDef.GetDisplayName: String;
begin
  if Name <> '' then
    Result := Name
  else
    Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
function TADVSEFieldDef.GetSchema: TADVSESchema;
begin
  Result := (Collection as TADVSEFieldDefs).Schema;
end;

{-------------------------------------------------------------------------------}
function TADVSEFieldDef.GetStorage: TADVSEManager;
begin
  Result := (Collection as TADVSEFieldDefs).Storage;
end;

{-------------------------------------------------------------------------------}
function TADVSEFieldDef.GetActualMode: TADVSEFieldMode;
begin
  Result := fmVisible;
  case Schema.Mode of
  fmDisabled:    Result := fmDisabled;
  fmInvisible:
    case Mode of
    fmDisabled:  Result := fmDisabled;
    fmInvisible,
    fmVisible:   Result := fmInvisible;
    end;
  fmVisible:     Result := Mode;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADVSEFieldDefs                                                               }
{-------------------------------------------------------------------------------}
constructor TADVSEFieldDefs.Create(ASchema: TADVSESchema);
begin
  inherited Create(ASchema, ASchema.Storage.GetFieldDefClass);
end;

{-------------------------------------------------------------------------------}
function TADVSEFieldDefs.GetItems(AIndex: integer): TADVSEFieldDef;
begin
  Result := TADVSEFieldDef(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADVSEFieldDefs.Add: TADVSEFieldDef;
begin
  Result := TADVSEFieldDef(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TADVSEFieldDefs.GetSchema: TADVSESchema;
begin
  Result := (GetOwner as TADVSESchema);
end;

{-------------------------------------------------------------------------------}
function TADVSEFieldDefs.GetStorage: TADVSEManager;
begin
  Result := (GetOwner as TADVSESchema).Storage;
end;

{-------------------------------------------------------------------------------}
{ TADVSESchema                                                                  }
{-------------------------------------------------------------------------------}
constructor TADVSESchema.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FFieldDefs := Storage.GetFieldDefsClass.Create(Self);
  FMode := fmVisible;
end;

{-------------------------------------------------------------------------------}
destructor TADVSESchema.Destroy;
begin
  FreeAndNil(FFieldDefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADVSESchema.Assign(AValue: TPersistent);
begin
  if AValue is TADVSESchema then begin
    Name := TADVSESchema(AValue).Name;
    FieldDefs := TADVSESchema(AValue).FieldDefs;
    Mode := TADVSESchema(AValue).Mode;
  end
  else
    inherited Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADVSESchema.GetDisplayName: String;
begin
  if Name <> '' then
    Result := Name
  else
    Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
procedure TADVSESchema.SetFieldDefs(const AValue: TADVSEFieldDefs);
begin
  FFieldDefs.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADVSESchema.GetStorage: TADVSEManager;
begin
  Result := (Collection as TADVSESchemas).Storage;
end;

{-------------------------------------------------------------------------------}
{ TADVSESchemas                                                                 }
{-------------------------------------------------------------------------------}
constructor TADVSESchemas.Create(AStorage: TADVSEManager);
begin
  inherited Create(AStorage, AStorage.GetSchemaClass);
end;

{-------------------------------------------------------------------------------}
function TADVSESchemas.GetItems(AIndex: integer): TADVSESchema;
begin
  Result := TADVSESchema(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADVSESchemas.Add: TADVSESchema;
begin
  Result := TADVSESchema(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TADVSESchemas.GetStorage: TADVSEManager;
begin
  Result := GetOwner as TADVSEManager;
end;

{-------------------------------------------------------------------------------}
{ TADVSESessionField                                                            }
{-------------------------------------------------------------------------------}
destructor TADVSESessionField.Destroy;
begin
  FreeAndNil(FColumn);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADVSESessionField.GetSession: TADVSESession;
begin
  Result := (Collection as TADVSESessionFields).Session;
end;

{-------------------------------------------------------------------------------}
function TADVSESessionField.GetStorage: TADVSEManager;
begin
  Result := (Collection as TADVSESessionFields).Storage;
end;

{-------------------------------------------------------------------------------}
{ TADVSESessionFields                                                           }
{-------------------------------------------------------------------------------}
constructor TADVSESessionFields.Create(ASession: TADVSESession);
begin
  inherited Create(ASession, ASession.Storage.GetSessionFieldClass());
end;

{-------------------------------------------------------------------------------}
function TADVSESessionFields.GetItems(AIndex: integer): TADVSESessionField;
begin
  Result := TADVSESessionField(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADVSESessionFields.GetSession: TADVSESession;
begin
  Result := GetOwner as TADVSESession;
end;

{-------------------------------------------------------------------------------}
function TADVSESessionFields.GetStorage: TADVSEManager;
begin
  Result := Session.Storage;
end;

{-------------------------------------------------------------------------------}
function TADVSESessionFields.FindField(
  const AFieldName: String): TADVSESessionField;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].FieldDef.Name, AFieldName) = 0 then begin
      Result := Items[i];
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADVSESessionFields.FieldByName(
  const AFieldName: String): TADVSESessionField;
begin
  Result := FindField(AFieldName);
  if Result = nil then
    raise Exception.CreateFmt('Virtual storage field [%s] is not found !', [AFieldName]);
end;

{-------------------------------------------------------------------------------}
procedure TADVSESessionFields.AddAll;
var
  i, j: Integer;
  oSchema: TADVSESchema;
begin
  BeginUpdate;
  try
    Clear;
    for i := 0 to Storage.Schemas.Count - 1 do begin
      oSchema := Storage.Schemas[i];
      if oSchema.Mode <> fmDisabled then
        for j := 0 to oSchema.FieldDefs.Count - 1 do
          if oSchema.FieldDefs[j].Mode <> fmDisabled then
            AddField(oSchema.FieldDefs[j]);
    end;
  finally
    EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
function TADVSESessionFields.AddField(AFieldDef: TADVSEFieldDef):
  TADVSESessionField;
begin
  if AFieldDef.Name = '' then
    raise Exception.Create('A field name is not defined !');
  if AFieldDef.DataType = dtUnknown then
    raise Exception.Create('A field data type is not defined !');
  Result := TADVSESessionField(Add);
  Result.FFieldDef := AFieldDef;
  Result.FColumn := nil;
  Result.Mode := AFieldDef.ActualMode;
end;

{-------------------------------------------------------------------------------}
{ TADVSESession                                                                 }
{-------------------------------------------------------------------------------}
constructor TADVSESession.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FFields := Storage.GetSessionFieldsClass().Create(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADVSESession.Destroy;
begin
  Detach;
  if DataSet <> nil then
    DataSet.RemoveListener(Self as IADDataSetListener);
  FreeAndNil(FFields);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADVSESession.GetStorage: TADVSEManager;
begin
  Result := (Collection as TADVSESessions).Storage;
end;

{-------------------------------------------------------------------------------}
function TADVSESession.GetDataSet: TADDataSet;
begin
  if FOwner is TADDataSet then
    Result := TADDataSet(FOwner)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
// IUnknown

function TADVSESession.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

{-------------------------------------------------------------------------------}
function TADVSESession._AddRef: Integer;
begin
  Result := -1;
end;

{-------------------------------------------------------------------------------}
function TADVSESession._Release: Integer;
begin
  Result := -1;
end;

{-------------------------------------------------------------------------------}
// IADStanExpressionEvaluator

function TADVSESession.GetDataSource: IADStanExpressionDataSource;
begin
  Result := FDataSource;
end;

{-------------------------------------------------------------------------------}
function TADVSESession.GetDataType: TADDataType;
begin
  Result := FBaseColumn.DataType;
end;

{-------------------------------------------------------------------------------}
function TADVSESession.GetSubAggregateCount: Integer;
begin
  Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADVSESession.GetSubAggregateKind(AIndex: Integer): TADAggregateKind;
begin
  Result := akSum;
end;

{-------------------------------------------------------------------------------}
function TADVSESession.HandleNotification(AKind, AReason: Word;
  AParam1, AParam2: LongWord): Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADVSESession.EvaluateSubAggregateArg(AIndex: Integer): Variant;
begin
  Result := Unassigned;
end;

{-------------------------------------------------------------------------------}
function TADVSESession.Evaluate: Variant;
var
  i: Integer;
begin
  FRow := TADDatSRow(FDataSource.Position);
  FBuff := nil;
  FLen := 0;
  try
    if not FRow.GetData(FBaseColumn.Index, rvDefault, FBuff, 0, FLen, False) then
      for i := 0 to Fields.Count - 1 do
        FRow.SetData(Fields[i].Column.Index, nil, 0)
    else
      Storage.DoDecode(Self, DataSet);
  finally
    FRow := nil;
    FBuff := nil;
    FLen := 0;
  end;
end;

{-------------------------------------------------------------------------------}
// IADDataSetListener

procedure TADVSESession.ResultsetDefined(ADataSet: TADDataSet);
begin
  Storage.DoResultsetDefined(Self, ADataSet);
  if Storage.AutoManage and (BaseColumn = nil) then begin
    if Fields.Count = 0 then
      Fields.AddAll;
    Attach;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADVSESession.ResultsetReleasing(ADataSet: TADDataSet);
begin
  Storage.DoResultsetReleasing(Self, ADataSet);
  if Storage.AutoManage and (BaseColumn <> nil) then
    Detach;
end;

{-------------------------------------------------------------------------------}
procedure TADVSESession.ResultsetActivated(ADataSet: TADDataSet);
begin
  Storage.DoResultsetActivated(Self, ADataSet);
  if Storage.AutoManage and (BaseColumn <> nil) then
    ApplyVisibility(ADataSet);
end;

{-------------------------------------------------------------------------------}
// Other

procedure TADVSESession.DoAttaching;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADVSESession.DoAttached;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADVSESession.Attach(ATable: TADDatSTable);
var
  i: Integer;
  oCol: TADDatSColumn;
  oDef: TADVSEFieldDef;
  oFld: TADVSESessionField;
begin
  Detach;
  try
    DoAttaching;
    if ATable = nil then begin
      if FOwner is TADDatSTable then
        ATable := TADDatSTable(FOwner)
      else if FOwner is TADDataSet then
        ATable := TADDataSet(FOwner).Table;
    end;
    if ATable = nil then
      raise Exception.Create('Result set is not defined !');
    if FBaseColumnName = '' then
      raise Exception.Create('Base column name is not defined !');
    i := ATable.Columns.IndexOfName(FBaseColumnName);
    if i = -1 then
      raise Exception.CreateFmt('Base column [%s] does not exists !', [FBaseColumnName]);
    if Fields.Count = 0 then
      raise Exception.Create('No columns specified for a session !');
    FBaseColumn := ATable.Columns[i];
    FBaseColumn.Evaluator := Self as IADStanExpressionEvaluator;
    FBaseColumn.Attributes := FBaseColumn.Attributes - [caCalculated] + [caVirtual];
    FTable := ATable;
    FDataSource := TADDatSTableExpressionDS.Create(ATable) as IADStanExpressionDataSource;
    for i := 0 to Fields.Count - 1 do begin
      oFld := Fields[i];
      oDef := oFld.FieldDef;
      if oFld.Mode in [fmInvisible, fmVisible] then begin
        oCol := TADDatSColumn.Create;
        oFld.FColumn := oCol;
        oCol.Name := oDef.Name;
        oCol.DataType := oDef.DataType;
        oCol.Size := oDef.Size;
        oCol.Precision := oDef.Precision;
        oCol.Scale := oDef.Scale;
        oCol.Attributes := oCol.Attributes + [caCalculated];
        FTable.Columns.Add(oCol);
      end;
    end;
    DoAttached;
  except
    Detach;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADVSESession.DoDetaching;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADVSESession.DoDetached;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADVSESession.Detach;
var
  i: Integer;
begin
  try
    DoDetaching;
    for i := 0 to Fields.Count - 1 do
      Fields[i].FColumn := nil;
  finally
    if FBaseColumn <> nil then begin
      FBaseColumn.Evaluator := nil;
      FBaseColumn := nil;
    end;
    FTable := nil;
    FDataSource := nil;
    DoDetached;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADVSESession.ApplyVisibility(ADataSet: TDataSet);
var
  i: Integer;
  oDef: TADVSESessionField;
  oFld: TField;
begin
  for i := 0 to Fields.Count - 1 do begin
    oDef := Fields[i];
    if oDef.Column <> nil then begin
      oFld := ADataSet.FindField(oDef.Column.Name);
      if oFld <> nil then
        oFld.Visible := (oDef.Mode = fmVisible);
    end;
  end;
  oFld := ADataSet.FindField(FBaseColumnName);
  if oFld <> nil then
    oFld.Visible := False;
end;

{-------------------------------------------------------------------------------}
{ TADVSESessions                                                                }
{-------------------------------------------------------------------------------}
constructor TADVSESessions.Create(AStorage: TADVSEManager);
begin
  inherited Create(AStorage, AStorage.GetSessionClass());
end;

{-------------------------------------------------------------------------------}
function TADVSESessions.GetStorage: TADVSEManager;
begin
  Result := GetOwner as TADVSEManager;
end;

{-------------------------------------------------------------------------------}
function TADVSESessions.GetItems(AIndex: integer): TADVSESession;
begin
  Result := TADVSESession(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADVSESessions.FindSession(AOwner: TObject;
  const ABaseColumnName: String): TADVSESession;
var
  i: Integer;
  oSess: TADVSESession;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    oSess := Items[i];
    if (oSess.FOwner = AOwner) and
       (AnsiCompareText(oSess.FBaseColumnName, ABaseColumnName) = 0) then begin
      Result := oSess;
      Break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADVSESessions.AddSession(AOwner: TObject;
  const ABaseColumnName: String): TADVSESession;
begin
  Result := TADVSESession(Add);
  Result.FOwner := AOwner;
  if Result.DataSet <> nil then
    Result.DataSet.AddListener(Result as IADDataSetListener);
  Result.FBaseColumnName := ABaseColumnName;
end;

{-------------------------------------------------------------------------------}
function TADVSESessions.EnsureSession(AOwner: TObject;
  const ABaseColumnName: String): TADVSESession;
begin
  Result := FindSession(AOwner, ABaseColumnName);
  if Result = nil then
    Result := AddSession(AOwner, ABaseColumnName);
end;

{-------------------------------------------------------------------------------}
{ TADVSEManager                                                                   }
{-------------------------------------------------------------------------------}
constructor TADVSEManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSchemas := GetSchemasClass.Create(Self);
  FSessions := GetSessionsClass.Create(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADVSEManager.Destroy;
begin
  FreeAndNil(FSessions);
  FreeAndNil(FSchemas);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADVSEManager.GetFieldDefClass: TADVSEFieldDefClass;
begin
  Result := TADVSEFieldDef;
end;

{-------------------------------------------------------------------------------}
class function TADVSEManager.GetFieldDefsClass: TADVSEFieldDefsClass;
begin
  Result := TADVSEFieldDefs;
end;

{-------------------------------------------------------------------------------}
class function TADVSEManager.GetSchemaClass: TADVSESchemaClass;
begin
  Result := TADVSESchema;
end;

{-------------------------------------------------------------------------------}
class function TADVSEManager.GetSchemasClass: TADVSESchemasClass;
begin
  Result := TADVSESchemas;
end;

{-------------------------------------------------------------------------------}
class function TADVSEManager.GetSessionFieldClass: TADVSESessionFieldClass;
begin
  Result := TADVSESessionField;
end;

{-------------------------------------------------------------------------------}
class function TADVSEManager.GetSessionFieldsClass: TADVSESessionFieldsClass;
begin
  Result := TADVSESessionFields;
end;

{-------------------------------------------------------------------------------}
class function TADVSEManager.GetSessionClass: TADVSESessionClass;
begin
  Result := TADVSESession;
end;

{-------------------------------------------------------------------------------}
class function TADVSEManager.GetSessionsClass: TADVSESessionsClass;
begin
  Result := TADVSESessions;
end;

{-------------------------------------------------------------------------------}
procedure TADVSEManager.SetSchemas(const AValue: TADVSESchemas);
begin
  FSchemas.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADVSEManager.DoResultsetActivated(ASession: TADVSESession;
  ADataSet: TADDataSet);
begin
  if Assigned(OnResultsetActivated) then
    OnResultsetActivated(Self, ASession, ADataSet);
end;

{-------------------------------------------------------------------------------}
procedure TADVSEManager.DoResultsetDefined(ASession: TADVSESession;
  ADataSet: TADDataSet);
begin
  if Assigned(OnResultsetDefined) then
    OnResultsetDefined(Self, ASession, ADataSet);
end;

{-------------------------------------------------------------------------------}
procedure TADVSEManager.DoResultsetReleasing(ASession: TADVSESession;
  ADataSet: TADDataSet);
begin
  if Assigned(OnResultsetReleasing) then
    OnResultsetReleasing(Self, ASession, ADataSet);
end;

{-------------------------------------------------------------------------------}
procedure TADVSEManager.DoDecode(ASession: TADVSESession;
  ADataSet: TADDataSet);
begin
  if Assigned(OnDecode) then
    OnDecode(Self, ASession, ADataSet);
end;

end.
