unit ekdsn;

interface
uses SysUtils, Classes, Dialogs, Menus, ColnEdit, DesignIntf, DesignEditors;

{ TEkLanguageIDProperty
  Editor for the TEkRTF.Lang property.}

  type TEkLanguageIDproperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  {VarList property editor}
  type
    TEkVarListProperty = class(TClassProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;


  {EkUDF Functions collection}
 type
  TEkUDFCollectionEditor = class(TCollectionEditor)
  protected
    procedure Loaded; override;
    procedure ListView1DblClick(Sender: TObject);
 end;

 type
  TEkUDFCollectionProperty = class(TCollectionProperty)
  public
    function GetEditorClass: TCollectionEditorClass; override;
  end;


{ TEkUDFResultTypeProperty
  Editor for the TEkUDF.ResultType property.}

  type TEkUDFResultTypeProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;


  type TFileNameProperty = class(TStringProperty)
  public
    function  GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;


  type TEkUDFListEditor = class(TDefaultEditor) //class(TComponentEditor)
   protected
     //procedure EditProperty(PropertyEditor: TPropertyEditor; var Continue: Boolean); override;
     procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
   public
      function GetVerbCount:integer; override;
      function GetVerb(Index: Integer): string; override;
      procedure ExecuteVerb(Index: Integer); override;

  end;

  procedure Register;

implementation
uses conscom, ekbasereport, ekrtf, ekfunc, ekvaredit;


procedure TEkUDFCollectionEditor.Loaded;
begin
  inherited Loaded;
  ListView1.OnDblClick:=ListView1DblClick;
end;

procedure TEkUDFCollectionEditor.ListView1DblClick(Sender: TObject);
begin
  //
end;

function TEkUDFCollectionProperty.GetEditorClass: TCollectionEditorClass;
begin
  Result:=TEkUDFCollectionEditor;
end;


{-------------- functions and methods LangID ---------}
procedure GetLanguageIDValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  for I := Low(EkLanguageIDs) to High(EkLanguageIDs) do Proc(EkLanguageIDs[I].Name);
end;

function LanguageIDToIdent(L: Longint; var Ident: string): Boolean;
begin
  Result := IntToIdent(L, Ident, EkLanguageIDs);
end;

function IdentToLanguageID(const Ident: string; var L: Longint): Boolean;
begin
  Result := IdentToInt(Ident, L, EkLanguageIDs);
end;


{TEkLanguageIDproperty}

function TEkLanguageIDProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSortList, paValueList];
end;

function TEkLanguageIDProperty.GetValue: string;
begin
  if not LanguageIDToIdent(TEkLanguageID(GetOrdValue), Result) then
    FmtStr(Result, '%d', [GetOrdValue]);
end;

procedure TEkLanguageIDProperty.GetValues(Proc: TGetStrProc);
begin
  GetLanguageIDValues(Proc);
end;

procedure TEkLanguageIDProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToLanguageID(Value, NewValue) then
    SetOrdValue(NewValue)
  else inherited SetValue(Value);
end;

{---------------------TEkUDFResultTypeProperty-------------------}
procedure GetUDFResultTypeIDValues(Proc: TGetStrProc);
var
  I: Integer;
begin
  for I := Low(EkUDFResultTypeIDs) to High(EkUDFResultTypeIDs) do Proc(EkUDFResultTypeIDs[I].Name);
end;

function UDFResultTypeIDToIdent(L: Longint; var Ident: string): Boolean;
begin
  Result := IntToIdent(L, Ident, EkUDFResultTypeIDs);
end;

function IdentToUDFResultTypeID(const Ident: string; var L: Longint): Boolean;
begin
  Result := IdentToInt(Ident, L, EkUDFResultTypeIDs);
end;

{TEkUDFResultTypeProperty}
function TEkUDFResultTypeProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSortList, paValueList];
end;

function TEkUDFResultTypeProperty.GetValue: string;
begin
  if not UDFResultTypeIDToIdent(TEkUDFResultType(GetOrdValue), Result) then
    FmtStr(Result, '%d', [GetOrdValue]);
end;

procedure TEkUDFResultTypeProperty.GetValues(Proc: TGetStrProc);
begin
  GetUDFResultTypeIDValues(Proc);
end;

procedure TEkUDFResultTypeProperty.SetValue(const Value: string);
var
  NewValue: Longint;
begin
  if IdentToUDFREsultTypeID(Value, NewValue) then
    SetOrdValue(NewValue)
  else inherited SetValue(Value);
end;


{-------------------- TInFileProperty ---------------------------}
function TFileNameProperty.GetAttributes: TPropertyAttributes;
begin
 Result:=[paDialog];
end;

procedure TFileNameProperty.Edit;
var
   OpenDialog:TOpenDialog;
begin
   OpenDialog:=TOpenDialog.Create(nil);
   try
     OpenDialog.Filter:='RTF files (*.rtf)|*.rtf|All files|*.*';
     If OpenDialog.Execute then SetStrValue(OpenDialog.FileName);
   finally
     OpenDialog.Free;
   end;
end;

{ TEkUDFListEditor }


//procedure TEkUDFListEditor.EditProperty(PropertyEditor: TPropertyEditor; var Continue: Boolean);
procedure TEkUDFListEditor.EditProperty(const Prop: IProperty; var Continue: Boolean);
begin
  if (Assigned(Prop)) and (Prop.GetName = 'Functions') then
     begin
        Prop.Edit;
     end;
end;

function TEkUDFListEditor.GetVerbCount: integer;
begin
  Result:=1;
end;

function TEkUDFListEditor.GetVerb(Index: Integer): String;
begin
 case index of
   0:Result:='&Functions';
 end;//case
end;

procedure TEkUDFListEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
   0:begin //Functions context menu
      Edit; //Control gets to procedure TEkUDFListEditor.EditProperty
     end;
  end;
end;

{ TVarListProperty }

function TEkVarListProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog] - [paSubProperties];
end;

procedure TEkVarListProperty.Edit;
var
   Component:TComponent;
   vf:TEkVarListForm;
begin
  Component := TComponent(GetComponent(0));
  vf:=TEkVarListForm.Create(nil);
  vf.BaseReport:=TEkBaseReport(Component);
  try
    vf.ShowModal;
    Modified;
  finally
  vf.Free;
  end;
end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TEkLanguageID), TEkBaseReport,'Lang',TEkLanguageIDproperty);
  RegisterPropertyEditor(TypeInfo(TEkUDFResultType), TEkUDF,'ResultType',TEkUDFResultTypeProperty);
  RegisterPropertyEditor(TypeInfo(TFileName), TEkRTF, 'Infile', TFileNameProperty);
  RegisterPropertyEditor(TypeInfo(TFileName), TEkRTF, 'OutFile', TFileNameProperty);
  RegisterPropertyEditor(TypeInfo(TEkUDFCollection), TEkUDFList, 'Functions', TEkUDFCollectionProperty);
  RegisterPropertyEditor(TypeInfo(TEkVarList), TEkRTF, 'VarList', TEkVarListProperty);
  RegisterComponentEditor(TEkUDFList, TEkUDFListEditor);
end;

end.
