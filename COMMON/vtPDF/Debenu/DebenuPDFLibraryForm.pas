{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryForm.pas                               }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryForm;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryStructure, Classes, DebenuPDFLibraryFont, DebenuPDFLibraryPainter, DebenuPDFLibraryExtra,
  DebenuPDFLibraryXFA;

type
  TPDFForm = class;

  TPDFFieldType = (ftUnknown, ftText, ftPushButton, ftCheckbox, ftRadioButton,
    ftChoice, ftSignature, ftParent);

  TPDFBorderProperty = (bpWidth, bpDashOn, bpDashOff);

  TPDFFormFieldCheckStyle = (csCross, csCheck, csCircle, csXPCheck, csXPRadio, csDiamond, csSquare, csStar, csNone);

  TPDFFormFieldCheckPosition = (cpLeft, cpCenter, cpRight);

  TPDFFormTabOrder = record
    ObjNum: Int64;
    ParentObjNum: Int64;
    TabOrder: Integer;
    FieldType: TPDFFieldType;
  end;

  TPDFField = class
  private
    FStructure: TPDFStructure;
    FSourceDict: TPDFDictionary;
    FSubNames: TQuickPDFStringList;
    FDisplayNames: TQuickPDFStringList;
    FLeft: Double;
    FTop: Double;
    FWidth: Double;
    FHeight: Double;
    FLW: Double;
    FTitle: WideString;
    FPage: Integer;
    FGotSubNames: Boolean;
    FGotDisplayNames: Boolean;
    FFieldType: TPDFFieldType;
    FOnFindObject: TPDFFindObjectEvent;
    FMergedAnnot: Boolean;
    FAnnotDict: TPDFDictionary;
    FAnnotRef: TPDFIndRef;
    FFieldRef: TPDFIndRef;
    procedure GetSubNames;
    procedure GetDisplayNames;
    procedure GetSubNamesFromDict(APDict: TPDFDictionary; KidIndex: Integer);
    function DictHasSubName(APDict: TPDFDictionary; const Key: AnsiString): Boolean;
    procedure SetValueByKey(const NewValue: WideString; const Key: AnsiString);
    procedure SetKidsValue(const NewValue: WideString);
    function KillColor(const Input: AnsiString): AnsiString;
    function InterpretValue(Obj: TPDFObject): WideString;
  protected
    FTemp: Boolean;
    Form: TPDFForm;
    Parent: TPDFField;
    HasKids: Boolean;
    procedure SetFieldFlags(Bit: Integer; SetBit: Boolean);
    function IsVisible: Boolean;
    procedure SetVisible(NewVisible: Boolean);
    function IsPrintable: Boolean;
    procedure SetPrintable(NewPrintable: Boolean);
    procedure SetVisiblePrintable(NewVisible, NewPrintable: Boolean);
    function IsReadOnly: Boolean;
    function IsRequired: Boolean;
    function IsNoExport: Boolean;
    procedure SetReadOnly(NewReadOnly: Boolean);
    procedure SetRequired(NewRequired: Boolean);
    procedure SetNoExport(NewNoExport: Boolean);
    function GetValue: WideString;
    function GetDefaultValue: WideString;
    procedure SetValue(const NewValue: WideString);
    procedure SetDefaultValue(const NewDefaultValue: WideString);
    function GetTitle: WideString;
    function GetFieldType: TPDFFieldType;
    function GetPage: Integer;
    procedure SetPage(NewPage: Integer);
    function GetFlags: Integer;
    procedure SetFlags(NewFlags: Integer);
    function GetAnnotFlags: Integer;
    procedure SetAnnotFlags(NewFlags: Integer);
    procedure AppearanceBox(Painter: TPDFPainter; Width, Height: Double;
      var BorderWidth: Double; Combs: Integer; CheckStyle: TPDFFormFieldCheckStyle);
    function MakeFloat(D: Double): AnsiString;
    function GetDescription: WideString;
    procedure SetDescription(const NewValue: WideString);
    procedure SetMKKey(const Key: AnsiString; Value: TPDFObject);
    function GetMKKey(const Key: AnsiString): TPDFObject;
    procedure SetAlignment(NewAlignment: Integer);
    function GetAlignment: Integer;
    procedure SetMaxLen(NewMaxLen: Integer);
    procedure SetComb(NewComb: Boolean);
    function GetMaxLen: Integer;
    function GetComb: Boolean;
    function GetFontName: AnsiString;
    function GetFontRef: TPDFIndRef;
    function GetFontSize: Double;
    function GetFontKey: AnsiString;
    procedure FieldChanged;
    procedure SetFontSize(NewSize: Double);
    function F(D: Double): AnsiString;
    procedure MakeCheckStyle(Style: TPDFFormFieldCheckStyle;
      Position: TPDFFormFieldCheckPosition; OnStream, OffStream: TPDFStream;
      AWidth, AHeight: Double);
    function FindObject(Ref: TPDFIndRef): TPDFObject;
    procedure FindFieldAnnot;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load(SourceRef: TPDFIndRef);
    procedure SetTitle(const NewTitle: WideString);
    function GetFieldFlags(Bit: Integer): Boolean;
    procedure SetBounds(Left, Top, Width, Height: Double);
    function SubCount: Integer;
    function GetSubName(SubIndex: Integer): AnsiString;
    function SetSubName(SubIndex: Integer; Value, DisplayValue: WideString): Integer;
    function GetDisplayName(SubIndex: Integer): AnsiString;
    function GetSubKidIndex(SubIndex: Integer): Integer;
    procedure AddJavaScriptAction(const ActionType: AnsiString;
      const JavaScript: WideString; AsString, Compress: Boolean);
    procedure AddWebLinkAction(const ActionType, Link: AnsiString);
    procedure SetBorderColor(Red, Green, Blue: Double); overload;
    procedure SetBorderColor(C, M, Y, K: Double); overload;
    procedure SetBorderColor(const CSName: AnsiString; Tint: Double); overload;
    procedure SetBorderColor(Gray: Double); overload;
    function GetBorderColorType: Integer;
    procedure SetRotation(Angle: Integer);
    function GetRotation: Integer;
    procedure SetBackgroundColor(Red, Green, Blue: Double); overload;
    procedure SetBackgroundColor(C, M, Y, K: Double); overload;
    procedure SetBackgroundColor(const CSName: AnsiString; Tint: Double); overload;
    procedure SetBackgroundColor(Gray: Double); overload;
    function GetBackgroundColorType: Integer;
    procedure RemoveBorderColor;
    procedure RemoveBackgroundColor;
    procedure SetCaption(const NewCaption: WideString);
    function GetCaption: WideString;
    function GetCaptionEx(StringType: Integer): WideString;
    procedure SetBorderStyle(Width: Double; const Style: AnsiString;
      DashOn, DashOff: Double);
    function GetBorderStyle: AnsiString;
    function GetBorderProperty(BP: TPDFBorderProperty): Double;
    function GetBorderColor(Component: Integer): Double;
    function GetBackgroundColor(Component: Integer): Double;
    procedure SetIcon(const Key: AnsiString; Ref: TPDFIndRef);
    procedure SetIconStyle(Placement: Integer; const Scale, ScaleType: AnsiString;
      HShift, VShift: Double);
    procedure SetHighlightMode(const Mode: AnsiString);
    procedure RemoveAppearanceStream;
    procedure SetFontIndex(FontIndex: Integer);
    procedure SetStandardFont(StandardFontID: Integer);
    procedure SetDingbatsFont;
    procedure SetFontColor(Red, Green, Blue: Double); overload;
    procedure SetFontColor(C, M, Y, K: Double); overload;
    procedure SetFontColor(const CSName: AnsiString; Tint: Double); overload;
    procedure UpdateAppearanceStream(OnlyIfNecessary: Boolean = False);
    function GetFontColor(Component: Integer): Double;
    function GetFontColorSpace: AnsiString;
    function GetJavaScriptAction(const ActionType: AnsiString): WideString;
    function GetWebLinkAction(const ActionType: AnsiString): AnsiString;
    procedure SetTextFlags(MultiLine, Password, FileSelect, DoNotSpellCheck,
      DoNotScroll, Comb: Boolean);
    function GetNormalAPDictRef(Update: Boolean): TPDFIndRef;
    function GetSelectedAPDictRef: TPDFIndRef;
    function MakeTempChild(KidIndex: Integer): TPDFField;
    function KidCount: Integer;
    procedure SetPageRef(PageNumber: Integer; Ref: TPDFIndRef);
    procedure SetSigKeyValue(const SigKey, SigValue: AnsiString);
    function GetSigValue: TPDFDictionary;
    function HasParent: Boolean;
    procedure SetCheckStyle(Style: TPDFFormFieldCheckStyle;
      Position: TPDFFormFieldCheckPosition);
    function GetCheckStyle: TPDFFormFieldCheckStyle;
    function AddRadioButtonChild(const StrValue: WideString): Integer;
    function AddOpt(const StrValue: WideString): Integer;
    function AddChoiceOpt(const StrValue, DisplayValue: WideString): Integer;
    procedure AddChild(ChildField: TPDFField);
    procedure SetOptional(OCGRef: TPDFIndRef);
    procedure SetAppearance(AppRef: TPDFIndRef);
    function GetAction(const TriggerEvent: AnsiString): TPDFDictionary;
    function GetInheritableValue(Dict: TPDFDictionary; const Name: AnsiString): TPDFObject;
    procedure AddResetAction(const ActionType: AnsiString);
    procedure AddSubmitAction(const ActionType, Link: AnsiString; Flags: Integer);
    procedure DeleteFromParent;
    procedure DeleteKid(KidRef: TPDFIndRef);
    function GetPageRef: TPDFIndRef;
    procedure SetSignatureImage(ImageRef: TPDFIndRef; Options: Integer);
    function GetRichTextValue(Key: WideString): WideString;
    function SetRichTextValue(Key, NewValue: WideString): Integer;
    function DeleteParentKey: Boolean;
    function DeleteSubName(Name: WideString): Integer;
    function GetSubmitActionString(const ActionType: WideString): WideString;

    property Left: Double read FLeft;
    property Top: Double read FTop;
    property Width: Double read FWidth;
    property Height: Double read FHeight;
    property LW: Double read FLW write FLW;

    property Visible: Boolean read IsVisible write SetVisible;
    property Printable: Boolean read IsPrintable write SetPrintable;
    property ReadOnly: Boolean read IsReadOnly write SetReadOnly;
    property Required: Boolean read IsRequired write SetRequired;
    property NoExport: Boolean read IsNoExport write SetNoExport;
    property Title: WideString read GetTitle write SetTitle;
    property Value: WideString read GetValue write SetValue;
    property DefaultValue: WideString read GetDefaultValue write SetDefaultValue;
    property FieldType: TPDFFieldType read GetFieldType;
    property ChildTitle: WideString read FTitle;
    property Page: Integer read GetPage write SetPage;
    property Flags: Integer read GetFlags write SetFlags;
    property AnnotFlags: Integer read GetAnnotFlags write SetAnnotFlags;
    property Description: WideString read GetDescription write SetDescription;
    property Alignment: Integer read GetAlignment write SetAlignment;
    property MaxLen: Integer read GetMaxLen write SetMaxLen;
    property Comb: Boolean read GetComb write SetComb;
    property FontName: AnsiString read GetFontName;
    property FontSize: Double read GetFontSize write SetFontSize;
    property SourceDict: TPDFDictionary read FSourceDict;
    property TempField: Boolean read FTemp write FTemp;
    property AnnotDict: TPDFDictionary read FAnnotDict;
    property FieldRef: TPDFIndRef read FFieldRef;
    property AnnotRef: TPDFIndRef read FAnnotRef;
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;
  end;

  TStandardFontEvent = function(StandardFontID: Integer): TPDFIndRef of object;

  TPDFForm = class
  private
    FOnNewIndObj: TNewIndObjEvent;
    FStructure: TPDFStructure;
    FFormDict: TPDFDictionary;
    FPDFFields: array of TPDFField;
    FOnStandardFont: TStandardFontEvent;
    FOnFindObject: TPDFFindObjectEvent;
    function F(D: Double): AnsiString;
  protected
    function GetField(Index: Integer): TPDFField;
    function GetCount: Integer;
    function GetFormFontCount: Integer;
    function FindObject(Ref: TPDFIndRef): TPDFObject;
  public
    FieldsArray: TPDFArray;
    COArray: TPDFArray;
    DRDict: TPDFDictionary;
    XFA: TPDFXFA;
    FValidDatasetsXML: Boolean;
    FValidTemplateXML: Boolean;
    procedure CreateXFA;
    procedure UpdateXFA;
    function FindFormField(Ref: TPDFIndRef): TPDFField;
    function GetFormFieldIndex(Ref: TPDFIndRef): Integer;
    function SetFormFieldByTitle(const Title, NewValue: WideString): Boolean;
    function GetFormFieldByTitle(const Title: WideString): WideString;
    function GetFormFontName(Index: Integer): AnsiString;
    constructor Create;
    procedure Load(AFormDict: TPDFDictionary);
    destructor Destroy; override;
    procedure DeleteField(FieldIndex: Integer);
    procedure DetachField(FieldIndex: Integer);
    function AttachField(FieldRef: TPDFIndRef): Boolean;
    function NewField(const Title: WideString; FieldType: TPDFFieldType;
      IndRef: TPDFIndRef): TPDFField;
    procedure NeedAppearances(AddKey: Boolean);
    function AddFont(Font: TPDFFont): Integer;
    procedure UseSeparationColor(const CSName: AnsiString; CS: TPDFIndRef);
    function GetNeedAppearances: AnsiString;
    function GetFontName(const ResourceName: AnsiString): AnsiString;
    function GetFontRef(const ResourceName: AnsiString): TPDFIndRef;
    function GetFontKey(FontIndex: Integer): AnsiString;
    function GetFormFontDict: TPDFDictionary;
    function GetDefaultFontKey: AnsiString;
    procedure SetCalcOrder(Ref: TPDFIndRef; Order: Integer);
    function NewIndObj(Obj: TPDFObject): TPDFIndRef;
    function SingleXFAStream: Boolean;
    function GetXFA(const Key: AnsiString = ''): AnsiString;
    procedure SetXFA(const Key, NewXML: AnsiString);
    function GetXFAFormFieldValue(const XFAFieldName: AnsiString): WideString;
    function SetXFAFormFieldValue(const XFAFieldName: AnsiString; const NewValue: WideString): Boolean;
    function SetXFAFormFieldAttribute(const XFAFieldName, Attribute, NewValue: AnsiString): Boolean;
    function SetXFAFormFieldBorderWidth(const XFAFieldName: AnsiString; Width: Double): Boolean;
    function SetXFAFormFieldBorderColor(const XFAFieldName: AnsiString; Red, Green, Blue: Double): Boolean;
    function SetXFAFormFieldBorderPresence(const XFAFieldName: AnsiString; NewValue: AnsiString): Boolean;
    function GetXFAFormFieldNames(const Delimiter: AnsiString): AnsiString;
    function RemoveXFAEntries(Options: Integer): Integer;
    function GetCompleteXFA: AnsiString;
    procedure SetCompleteXFA(XFAStreamRef: TPDFIndRef);
    property Count: Integer read GetCount;
    property FontCount: Integer read GetFormFontCount;
    property Field[Index: Integer]: TPDFField read GetField;
    property FormDict: TPDFDictionary read FFormDict;
    property ValidDatasetsXML: Boolean read FValidDatasetsXML;
    property ValidTemplateXML: Boolean read FValidTemplateXML;
    property OnNewIndObj: TNewIndObjEvent read FOnNewIndObj write FOnNewIndObj;
    property OnStandardFont: TStandardFontEvent read FOnStandardFont write FOnStandardFont;
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;
  end;

implementation

uses Math, SysUtils, DebenuPDFLibraryFontConst, DebenuPDFLibraryEncoding;

{ TPDFForm }

constructor TPDFForm.Create;
begin
  FOnFindObject := nil;
  XFA := nil;
  FValidDatasetsXML := False;
  FValidTemplateXML := False;
end;

procedure TPDFForm.Load(AFormDict: TPDFDictionary);
var
  Obj: TPDFObject;
  X: Integer;

  procedure NewField(Parent: TPDFField; IndRef: TPDFIndRef);
  var
    K: Integer;
    Len: Integer;
    RefObj: TPDFObject;
    Kids: TPDFArray;
  begin
    RefObj := FindObject(IndRef);
    if RefObj is TPDFDictionary then
    begin
      Len := Length(FPDFFields);
      SetLength(FPDFFields, Len + 1);
      FPDFFields[Len] := TPDFField.Create;
      FPDFFields[Len].OnFindObject := FOnFindObject;
      FPDFFields[Len].Load(IndRef);
      FPDFFields[Len].Form := Self;
      FPDFFields[Len].Parent := Parent;

      if (Parent = nil) then // Delete 'Parent' key from malformed entries.
        FPDFFields[Len].DeleteParentKey;

      if (FPDFFields[Len].FieldType <> ftCheckBox) and
        (FPDFFields[Len].FieldType <> ftRadioButton) then
      begin
        RefObj := TPDFDictionary(RefObj).FindValueByKeyName('Kids', True);
        if RefObj is TPDFArray then
        begin
          FPDFFields[Len].HasKids := True;
          Kids := TPDFArray(RefObj);
          for K := 0 to Kids.Count - 1 do
          begin
            if TPDFArray(RefObj).Item[K] is TPDFIndRef then
              NewField(FPDFFields[Len], TPDFIndRef(TPDFArray(RefObj).Item[K]));
          end;
        end;
      end;
    end;
  end;

begin
  FStructure := AFormDict.Owner;
  FFormDict := AFormDict;

  Obj := AFormDict.FindValueByKeyName('Fields');

  if (not Assigned(Obj)) then
  begin
    Obj := FStructure.NewArray;
    AFormDict.Add('Fields', Obj);
  end;

  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFArray then
  begin
    FieldsArray := TPDFArray(Obj);
    SetLength(FPDFFields, 0);

    for X := 0 to FieldsArray.Count - 1 do
    begin
      Obj := FieldsArray.Item[X];
      if Obj is TPDFIndRef then
        NewField(nil, TPDFIndRef(Obj));
    end;
  end;

  Obj := AFormDict.FindValueByKeyName('CO');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if not Assigned(Obj) then
  begin
    Obj := FStructure.NewArray;
    AFormDict.Add('CO', Obj);
  end;
  if Obj is TPDFArray then COArray := TPDFArray(Obj);

  Obj := AFormDict.FindValueByKeyName('DR');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if not Assigned(Obj) then
  begin
    Obj := FStructure.NewDictionary;
    AFormDict.Add('DR', Obj);
  end;
  if Obj is TPDFDictionary then DRDict := TPDFDictionary(Obj);
end;

procedure TPDFForm.DeleteField(FieldIndex: Integer);
var
  OldField: TPDFField;
  MoveCount: Integer;
begin
  if (FieldIndex >= 0) and (FieldIndex < Length(FPDFFields)) then
  begin
    OldField := FPDFFields[FieldIndex];
    OldField.DeleteFromParent;
    OldField.SourceDict.RemoveKeys;
    MoveCount := Length(FPDFFields) - FieldIndex - 1;
    if (MoveCount > 0) then
    begin
      Move(FPDFFields[FieldIndex + 1], FPDFFields[FieldIndex], MoveCount * SizeOf(TPDFField));
    end;
    SetLength(FPDFFields, Length(FPDFFields) - 1);
    FieldsArray.DeleteObj(OldField.FieldRef, True);
    COArray.DeleteObj(OldField.FieldRef, True);
  end;
end;

destructor TPDFForm.Destroy;
var
  X: Integer;
begin
  if (Assigned(XFA)) then
    XFA.Free;

  for X := 0 to Length(FPDFFields) - 1 do
    FPDFFields[X].Free;
  inherited;
end;

function TPDFForm.FindFormField(Ref: TPDFIndRef): TPDFField;
var
  X: Integer;
  Output: AnsiString;
begin
  Result := nil;
  Output := Ref.Output;
  X := 0;
  while (X <= Length(FPDFFields) - 1) and (Result = nil) do
  begin
    if FPDFFields[X].FieldRef.Output = Output then Result := FPDFFields[X];
    Inc(X);
  end;
end;

function TPDFForm.GetFormFieldIndex(Ref: TPDFIndRef): Integer;
var
  X: Integer;
  Output: AnsiString;
begin
  Result := -1;
  Output := Ref.Output;
  X := 0;
  while (X <= Length(FPDFFields) - 1) and (Result < 0) do
  begin
    if FPDFFields[X].FieldRef.Output = Output then Result := X;
    Inc(X);
  end;
end;

function TPDFForm.GetCompleteXFA: AnsiString;
var
  Obj: TPDFObject;
  XFAArray: TPDFArray;
  X: Integer;
  TestKey: AnsiString;
begin
  Result := '';
  Obj := FFormDict.FindValueByKeyName('XFA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if (Obj is TPDFArray) then
  begin
    XFAArray := TPDFArray(Obj);
    X := 0;
    while (X < XFAArray.Count - 1) do
    begin
      Obj := XFAArray.Item[X];
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFString then
      begin
        TestKey := TPDFString(Obj).AsString;

        Obj := XFAArray.Item[X + 1];
        if Obj is TPDFIndRef then
        begin
          Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFStream then
            Result := Result + TPDFStream(Obj).GetDecodedStream;
        end;
      end;
      Inc(X, 2);
    end;
  end else
  if (Obj is TPDFStream) then
  begin
    Result := TPDFStream(Obj).GetDecodedStream;
  end;
end;

function TPDFForm.GetCount: Integer;
begin
  Result := Length(FPDFFields);
end;

function TPDFForm.GetField(Index: Integer): TPDFField;
begin
  Result := nil;
  if (Index >= 0) and (Index < Length(FPDFFields)) then
    Result := FPDFFields[Index];
end;

function TPDFForm.GetFormFontCount: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  Obj := FFormDict.FindValueByKeyName('DR');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName('Font');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then Result := TPDFDictionary(Obj).Count;
  end;
end;

function TPDFForm.GetFormFontDict: TPDFDictionary;
var
  Obj: TPDFObject;
begin
  Result := nil;
  Obj := FFormDict.FindValueByKeyName('DR');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName('Font');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then Result := TPDFDictionary(Obj);
  end;
end;

function TPDFForm.GetFontName(const ResourceName: AnsiString): AnsiString;
var
  Obj: TPDFObject;
begin
  Result := '';
  Obj := FFormDict.FindValueByKeyName('DR');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName('Font');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName(ResourceName);
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
      begin
        Obj := TPDFDictionary(Obj).FindValueByKeyName('BaseFont');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFName then
          Result := TPDFName(Obj).Name;
      end;
    end;
  end;
end;

function TPDFForm.GetFormFontName(Index: Integer): AnsiString;
var
  Obj: TPDFObject;
begin
  Result := '';
  Obj := FFormDict.FindValueByKeyName('DR');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName('Font');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if (Obj is TPDFDictionary) and (Index >= 1) and (Index <= TPDFDictionary(Obj).Count) then
    begin
      Obj := TPDFDictionary(Obj).Entry[Index - 1].Value;
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
      begin
        Obj := TPDFDictionary(Obj).FindValueByKeyName('BaseFont');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFName then
          Result := TPDFName(Obj).Name;
      end;
    end;
  end;
end;

function TPDFForm.GetFormFieldByTitle(const Title: WideString): WideString;
var
  X: Integer;
  Found: Boolean;
begin
  Result := '';
  Found := False;
  X := 0;
  while (X < Length(FPDFFields)) and (not Found) do
  begin
    if FPDFFields[X].Title = Title then
    begin
      Result := FPDFFields[X].Value;
      Found := True;
    end;
    Inc(X);
  end;
end;

function TPDFForm.GetNeedAppearances: AnsiString;
var
  Obj: TPDFObject;
begin
  Obj := FFormDict.FindValueByKeyName('NeedAppearances');
  if not Assigned(Obj) then Result := '' else
    Result := Obj.Output;
end;

procedure TPDFForm.NeedAppearances(AddKey: Boolean);
begin
  FFormDict.PurgeKey('NeedAppearances');
  FFormDict.Add('NeedAppearances', FStructure.NewBoolean(AddKey));
end;

function TPDFForm.NewField(const Title: WideString;
  FieldType: TPDFFieldType; IndRef: TPDFIndRef): TPDFField;
var
  FieldDict: TPDFDictionary;
  CheckDict: TPDFDictionary;
  OnOffDict: TPDFDictionary;
  ValidTitle: WideString;
  Obj: TPDFObject;
begin
  ValidTitle := QPLWideStringReplace(Title, '.', '', [rfReplaceAll]);

  Result := TPDFField.Create;
  Result.OnFindObject := FOnFindObject;
  Result.Load(IndRef);
  SetLength(FPDFFields, Length(FPDFFields) + 1);
  FPDFFields[Length(FPDFFields) - 1] := Result;
  FieldsArray.Add(IndRef);
  Obj := FindObject(IndRef);
  if Obj is TPDFDictionary then
    FieldDict := TPDFDictionary(Obj)
  else
    FieldDict := nil;
  Result.FTitle := ValidTitle;
  Result.HasKids := False;
  Result.Parent := nil;
  Result.Form := Self;

  if Assigned(FieldDict) then
  begin
    if ((FieldType <> ftRadioButton) and (FieldType <> ftParent)) then
    begin
      FieldDict.Add('Type', FStructure.NewName('Annot'));
      FieldDict.Add('Subtype', FStructure.NewName('Widget'));
    end;
    case FieldType of
      ftText:
      begin
        FieldDict.Add('FT', FStructure.NewName('Tx'));
        FieldDict.Add('F', FStructure.NewNumeric(4));
        FieldDict.Add('T', FStructure.NewTextString(ValidTitle));
      end;
      ftPushButton:
      begin
        FieldDict.Add('FT', FStructure.NewName('Btn'));
        FieldDict.Add('Ff', FStructure.NewNumeric(65536));
        FieldDict.Add('F', FStructure.NewNumeric(4));
        FieldDict.Add('T', FStructure.NewTextString(ValidTitle));
      end;
      ftCheckbox:
      begin
        FieldDict.Add('FT', FStructure.NewName('Btn'));
        FieldDict.Add('Ff', FStructure.NewNumeric(0));
        FieldDict.Add('F', FStructure.NewNumeric(4));
        FieldDict.Add('T', FStructure.NewTextString(ValidTitle));
        FieldDict.Add('AS', FStructure.NewName('Off'));
        FieldDict.Add('V', FStructure.NewName('Off'));
        CheckDict := FStructure.NewDictionary;
        FieldDict.Add('AP', CheckDict);
        OnOffDict := FStructure.NewDictionary;
        CheckDict.Add('N', OnOffDict);
        OnOffDict.Add('Yes', NewIndObj(FStructure.NewStream('')));
        OnOffDict.Add('Off', NewIndObj(FStructure.NewStream('')));
      end;
      ftRadioButton:
      begin
        FieldDict.Add('FT', FStructure.NewName('Btn'));
        FieldDict.Add('Ff', FStructure.NewNumeric(32768));
        FieldDict.Add('T', FStructure.NewTextString(ValidTitle));
        FieldDict.Add('AS', FStructure.NewName('Off'));
        FieldDict.Add('V', FStructure.NewName('Off'));
        FieldDict.Add('Kids', FStructure.NewArray);
      end;
      ftChoice:
      begin
        FieldDict.Add('FT', FStructure.NewName('Ch'));
        FieldDict.Add('T', FStructure.NewTextString(ValidTitle));
        FieldDict.Add('Opt', FStructure.NewArray);
        FieldDict.Add('F', FStructure.NewNumeric(4));
        FieldDict.Add('Ff', FStructure.NewNumeric(131072));
        FieldDict.Add('TU', FStructure.NewName('dropdownfield'));
      end;
      ftSignature:
      begin
        FFormDict.Add('SigFlags', FStructure.NewNumeric(3));
        FieldDict.Add('FT', FStructure.NewName('Sig'));
        FieldDict.Add('T', FStructure.NewTextString(ValidTitle));
        FieldDict.Add('F', FStructure.NewNumeric(4));
      end;
      ftParent:
      begin
        FieldDict.Add('T', FStructure.NewTextString(ValidTitle));
      end;
    end;
  end;
end;

procedure TPDFForm.SetCalcOrder(Ref: TPDFIndRef; Order: Integer);
var
  Obj: TPDFObject;
  CO: TPDFArray;
  I: Integer;
begin
  Obj := FFormDict.FindValueByKeyName('CO');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if not Assigned(Obj) then
  begin
    Obj := FStructure.NewArray;
    FFormDict.Add('CO', Obj);
    COArray := TPDFArray(Obj);
  end;
  if Obj is TPDFArray then
  begin
    CO := TPDFArray(Obj);
    I := CO.ItemIndexMatch(Ref);
    if I >= 0 then
    begin
      if Order < 0 then Order := CO.Count - 1;
      if Order >= CO.Count then Order := CO.Count - 1;
      CO.Move(I, Order);
    end else
    begin
      if (Order < 0) or (Order >= CO.Count) then CO.Add(Ref) else
        CO.Insert(Order, Ref);
    end;
  end;
end;

procedure TPDFForm.SetCompleteXFA(XFAStreamRef: TPDFIndRef);
begin
  FFormDict.Add('XFA', XFAStreamRef);
end;

function TPDFForm.SetFormFieldByTitle(const Title,
  NewValue: WideString): Boolean;
var
  X: Integer;
begin
  Result := False;
  for X := 0 to Length(FPDFFields) - 1 do
  begin
    if FPDFFields[X].Title = Title then
    begin
      FPDFFields[X].Value := NewValue;
      Result := True;
    end;
  end;
end;

function TPDFForm.GetFontKey(FontIndex: Integer): AnsiString;
var
  Obj: TPDFObject;
begin
  Result := '';
  Obj := FFormDict.FindValueByKeyName('DR');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName('Font');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      if (FontIndex >= 1) and (FontIndex <= TPDFDictionary(Obj).Count) then
      begin
        Obj := TPDFDictionary(Obj).Entry[FontIndex - 1].Key;
        if Obj is TPDFName then Result := TPDFName(Obj).Name;
      end;
    end;
  end;
end;

function TPDFForm.AddFont(Font: TPDFFont): Integer;
var
  DR: TPDFDictionary;
  Obj: TPDFObject;
  FontDict: TPDFDictionary;
begin
  Result := 0;
  Font.SetName(Font.Name);
  Obj := FFormDict.FindValueByKeyName('DR');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if not (Obj is TPDFDictionary) then
  begin
    Obj := FStructure.NewDictionary;
    FFormDict.Add('DR', Obj);
    DRDict := TPDFDictionary(Obj);
  end;
  if Obj is TPDFDictionary then
  begin
    DR := TPDFDictionary(Obj);
    Obj := DR.FindValueByKeyName('Font');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));    
    if not (Obj is TPDFDictionary) then
    begin
      Obj := FStructure.NewDictionary;
      DR.Add('Font', Obj);
    end;
    if Obj is TPDFDictionary then
    begin
      FontDict := TPDFDictionary(Obj);
      FontDict.Add(Font.Name, Font.IndRef);
      Result := FontDict.Count;
    end;
  end;

  Obj := FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if not Assigned(Obj) then
  begin
    FFormDict.Add('DA', FStructure.NewString('/' + Font.Name + ' 0 Tf 0 0 0 rg'));
  end;
end;

function TPDFForm.GetDefaultFontKey: AnsiString;
begin
  if GetFormFontCount = 0 then Result := '' else
    Result := GetFontKey(1);
end;

function TPDFForm.GetFontRef(const ResourceName: AnsiString): TPDFIndRef;
var
  Obj: TPDFObject;
  X: Integer;
  I: Integer;
const
  StandardFontNames: array[0..13] of AnsiString = ('Cour', 'CoBo', 'CoBO',
    'CoOb', 'Helv', 'HeBo', 'HeBO', 'HeOb', 'Time', 'TiBo', 'TiIt', 'TiBI',
    'Symb', 'ZaDb');
begin
  Result := nil;
  Obj := FFormDict.FindValueByKeyName('DR');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName('Font');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName(ResourceName);
      if Obj is TPDFIndRef then Result := TPDFIndRef(Obj);
    end;
  end;
  if not Assigned(Result) then
  begin
    I := -1;
    X := 0;
    while (I < 0) and (X <= 13) do
    begin
      if StandardFontNames[X] = ResourceName then I := X
        else Inc(X);
    end;
    if (I >= 0) and (Assigned(FOnStandardFont)) then
      Result := FOnStandardFont(I);
  end;
end;

function TPDFForm.NewIndObj(Obj: TPDFObject): TPDFIndRef;
var
  ObjNum: Integer;
  GenNum: Integer;
begin
  FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
  Result := FStructure.NewIndirectRef(ObjNum, GenNum);
end;

procedure TPDFForm.UpdateXFA;
begin
  if (Assigned(XFA)) then
  begin
    if (XFA.DataSetsXMLChanged) then
      XFA.ChangeDatasetsXMLObject(XFA.DXML);

    if SingleXFAStream then
      SetXFA('', XFA.FullXML)
    else
    begin
      if (XFA.TemplateXMLChanged) then
        XFA.ChangeTemplateXMLObject(XFA.TXML);

      SetXFA('datasets', XFA.DatasetsXML);
      SetXFA('template', XFA.TemplateXML);
    end;
  end;
end;

procedure TPDFForm.UseSeparationColor(const CSName: AnsiString;
  CS: TPDFIndRef);
var
  DR: TPDFDictionary;
  Obj: TPDFObject;
  ColorSpaceDict: TPDFDictionary;
begin
  Obj := FFormDict.FindValueByKeyName('DR');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if not (Obj is TPDFDictionary) then
  begin
    Obj := FStructure.NewDictionary;
    FFormDict.Add('DR', Obj);
    DRDict := TPDFDictionary(Obj);
  end;
  if Obj is TPDFDictionary then
  begin
    DR := TPDFDictionary(Obj);
    Obj := DR.FindValueByKeyName('ColorSpace');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));    
    if not (Obj is TPDFDictionary) then
    begin
      Obj := FStructure.NewDictionary;
      DR.Add('ColorSpace', Obj);
    end;
    if Obj is TPDFDictionary then
    begin
      ColorSpaceDict := TPDFDictionary(Obj);
      ColorSpaceDict.Add(CSName, CS);
    end;
  end;
end;

function TPDFForm.GetXFA(const Key: AnsiString): AnsiString;
var
  Obj: TPDFObject;
  XFAArray: TPDFArray;
  X: Integer;
  Found: Boolean;
  TestKey: AnsiString;
begin
  Result := '';
  Obj := FFormDict.FindValueByKeyName('XFA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if (Key <> '') and (Obj is TPDFArray) then
  begin
    XFAArray := TPDFArray(Obj);
    X := 0;
    Found := False;
    while (not Found) and (X < XFAArray.Count - 1) do
    begin
      Obj := XFAArray.Item[X];
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFString then
      begin
        TestKey := TPDFString(Obj).AsString;
        if TestKey = Key then
        begin
          Found := True;
          Obj := XFAArray.Item[X + 1];
          if Obj is TPDFIndRef then
          begin
            Obj := FindObject(TPDFIndRef(Obj));
            if Obj is TPDFStream then
              Result := TPDFStream(Obj).GetDecodedStream;
          end;
        end;
      end;
      Inc(X, 2);
    end;
  end else
  if (Key = '') and (Obj is TPDFStream) then
  begin
    Result := TPDFStream(Obj).GetDecodedStream;    
  end;
end;

procedure TPDFForm.CreateXFA;
begin
  if (XFA = nil) then
  begin
    XFA := TPDFXFA.Create;
    try
      if SingleXFAStream then
        XFA.FullXML := GetXFA
      else
      begin
        XFA.TemplateXML := GetXFA('template');
        XFA.DatasetsXML := GetXFA('datasets');
      end;

      FValidDatasetsXML := XFA.ValidXML;
      FValidTemplateXML := FValidDatasetsXML;
    except
      XFA := nil;
    end;
  end;
end;

function TPDFForm.GetXFAFormFieldValue(const XFAFieldName: AnsiString): WideString;
begin
  Result := '';
  CreateXFA;

  if ValidDatasetsXML then
    Result := XFA.GetFieldValue(XFAFieldName);
end;

function TPDFForm.SetXFAFormFieldValue(const XFAFieldName: AnsiString;
  const NewValue: WideString): Boolean;
begin
  Result := False;
  CreateXFA;

  if ValidDatasetsXML then
  begin
    XFA.SetFieldValue(XFAFieldName, NewValue);
    Result := True;
  end;
end;

procedure TPDFForm.SetXFA(const Key, NewXML: AnsiString);
var
  Obj: TPDFObject;
  XFAArray: TPDFArray;
  X: Integer;
  Found: Boolean;
  TestKey: AnsiString;
  NewStream: TPDFStream;
begin
  Found := False;
  Obj := FFormDict.FindValueByKeyName('XFA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if (Key <> '') then
  begin
    if Obj is TPDFArray then
    begin
      XFAArray := TPDFArray(Obj);
      X := 0;
      while (not Found) and (X < XFAArray.Count - 1) do
      begin
        Obj := XFAArray.Item[X];
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFString then
        begin
          TestKey := TPDFString(Obj).AsString;
          if TestKey = Key then
          begin
            Found := True;
            Obj := XFAArray.Item[X + 1];
            if Obj is TPDFIndRef then
            begin
              Obj := FindObject(TPDFIndRef(Obj));
              if Obj is TPDFStream then
                TPDFStream(Obj).SetTo(NewXML, True);
            end;
          end;
        end;
        Inc(X, 2);
      end;
    end else
    begin
      XFAArray := FStructure.NewArray;
      FFormDict.Add('XFA', XFAArray);
    end;
    if (not Found) and Assigned(XFAArray) then
    begin
      NewStream := FStructure.NewStream('');
      NewStream.SetTo(NewXML, True);
      XFAArray.Add(FStructure.NewString(Key));
      XFAArray.Add(NewIndObj(NewStream));
    end;
  end else
  begin
    if Obj is TPDFStream then
    begin
      TPDFStream(Obj).SetTo(NewXML, True);
    end else
    begin
      NewStream := FStructure.NewStream('');
      NewStream.SetTo(NewXML, True);
      FFormDict.Add('XFA', NewIndObj(NewStream));      
    end;
  end;
end;

function TPDFForm.SetXFAFormFieldAttribute(const XFAFieldName, Attribute,
  NewValue: AnsiString): Boolean;
begin
  Result := False;
  CreateXFA;

  if ValidTemplateXML then
  begin
    XFA.SetFieldAttribute(XFAFieldName, Attribute, NewValue);
    Result := True;
  end;
end;

function TPDFForm.SetXFAFormFieldBorderWidth(const XFAFieldName: AnsiString;
  Width: Double): Boolean;
var
  X: Integer;
  UI: AnsiString;
const
  UITypes: array[1..6] of AnsiString = ('checkButton', 'choiceList',
    'dateTimeEdit', 'numericEdit', 'passwordEdit', 'textEdit');
begin
  Result := False;
  CreateXFA;
  if ValidTemplateXML then
  begin
    UI := '';
    X := 1;
    while (UI = '') and (X <= 6) do
    begin
      if XFA.FieldHasChild(XFAFieldName, 'ui/' + UITypes[X]) then
        UI := UITypes[X]
      else
        Inc(X);
    end;
    if UI <> '' then
    begin
      if not XFA.FieldHasChild(XFAFieldName, 'ui/' + UI + '/border') then
        XFA.CreateFieldChild(XFAFieldName, 'ui/' + UI + '/border');
      if Width > 0 then
      begin
        XFA.SetFieldChildAttribute(XFAFieldName, 'ui/' + UI + '/border', 'presence', 'visible');
        if not XFA.FieldHasChild(XFAFieldName, 'ui/' + UI + '/border/edge') then
          XFA.CreateFieldChild(XFAFieldName, 'ui/' + UI + '/border/edge');
        XFA.SetFieldChildAttribute(XFAFieldName, 'ui/' + UI + '/border/edge', 'thickness', F(Width) + 'pt');
      end else
        XFA.SetFieldChildAttribute(XFAFieldName, 'ui/' + UI + '/border', 'presence', 'hidden');
    end;
    Result := True;
  end;
end;

function TPDFForm.F(D: Double): AnsiString;
begin
  Result := QPLDoubleToStr(D, 3) + ' ';
end;

function TPDFForm.SetXFAFormFieldBorderColor(const XFAFieldName: AnsiString;
  Red, Green, Blue: Double): Boolean;
var
  RGBColor: AnsiString;
  X: Integer;
  UI: AnsiString;
const
  UITypes: array[1..6] of AnsiString = ('checkButton', 'choiceList',
    'dateTimeEdit', 'numericEdit', 'passwordEdit', 'textEdit');
begin
  Result := False;
  CreateXFA;
  if ValidTemplateXML then
  begin
    UI := '';
    X := 1;
    while (UI = '') and (X <= 6) do
    begin
      if XFA.FieldHasChild(XFAFieldName, 'ui/' + UITypes[X]) then
        UI := UITypes[X]
      else
        Inc(X);
    end;
    if UI <> '' then
    begin
      if not XFA.FieldHasChild(XFAFieldName, 'ui/' + UI + '/border') then
        XFA.CreateFieldChild(XFAFieldName, 'ui/' + UI + '/border');
      XFA.SetFieldChildAttribute(XFAFieldName, 'ui/' + UI + '/border', 'presence', 'visible');
      if not XFA.FieldHasChild(XFAFieldName, 'ui/' + UI + '/border/edge/color') then
        XFA.CreateFieldChild(XFAFieldName, 'ui/' + UI + '/border/edge/color');
      RGBColor := QPLIntToStr(Round(Red * 255)) + ',' +
        QPLIntToStr(Round(Green * 255)) + ',' +
        QPLIntToStr(Round(Blue * 255));
      XFA.SetFieldChildAttribute(XFAFieldName, 'ui/' + UI + '/border/edge/color', 'value', RGBColor);
    end;
    Result := True;
  end;
end;

function TPDFForm.SingleXFAStream: Boolean;
var
  Obj: TPDFObject;
begin
  Obj := FFormDict.FindValueByKeyName('XFA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  Result := Obj is TPDFStream;
end;

function TPDFForm.SetXFAFormFieldBorderPresence(const XFAFieldName: AnsiString;
  NewValue: AnsiString): Boolean;
var
  X: Integer;
  UI: AnsiString;
const
  UITypes: array[1..6] of AnsiString = ('checkButton', 'choiceList',
    'dateTimeEdit', 'numericEdit', 'passwordEdit', 'textEdit');
begin
  Result := False;
  CreateXFA;
  if ValidTemplateXML then
  begin
    UI := '';
    X := 1;
    while (UI = '') and (X <= 6) do
    begin
      if XFA.FieldHasChild(XFAFieldName, 'ui/' + UITypes[X]) then
        UI := UITypes[X]
      else
        Inc(X);
    end;
    if UI <> '' then
    begin
      if not XFA.FieldHasChild(XFAFieldName, 'ui/' + UI + '/border') then
        XFA.CreateFieldChild(XFAFieldName, 'ui/' + UI + '/border');
      XFA.SetFieldChildAttribute(XFAFieldName, 'ui/' + UI + '/border', 'presence', NewValue)
    end;
    Result := True;
  end;
end;

function TPDFForm.GetXFAFormFieldNames(
  const Delimiter: AnsiString): AnsiString;
begin
  Result := '';
  CreateXFA;

  if ValidDatasetsXML then
  begin
    Result := XFA.GetFieldNames(Delimiter);
  end;
end;

// Removes the field with the specified field index from the
// /Fields array and the /CO array
procedure TPDFForm.DetachField(FieldIndex: Integer);
var
  OldField: TPDFField;
begin
  if (FieldIndex >= 0) and (FieldIndex < Length(FPDFFields)) then
  begin
    OldField := FPDFFields[FieldIndex];
    FieldsArray.DeleteObj(OldField.FieldRef, True);
    COArray.DeleteObj(OldField.FieldRef, True);
  end;
end;

// Attaches an annotation specified by the FieldRef indirect reference
// to the /AcroForm dictionary's /Fields array
function TPDFForm.AttachField(FieldRef: TPDFIndRef): Boolean;
var
  Field: TPDFField;
  Obj: TPDFObject;
begin
  Result := False;

  // Check if this indirect reference is already linked to a field object
  Field := FindFormField(FieldRef);
  if not Assigned(Field) then
  begin
    // Check that this indirect reference links to a dictionary
    Obj := FindObject(FieldRef);
    if Obj is TPDFDictionary then
    begin
      Result := True;

      // Create a TPDFField object from the annotation dictionary
      Field := TPDFField.Create;
      Field.OnFindObject := FOnFindObject;
      Field.Load(FieldRef);
      Field.Form := Self;

      // Add the TPDFField object to the FPDFFields array
      SetLength(FPDFFields, Length(FPDFFields) + 1);
      FPDFFields[Length(FPDFFields) - 1] := Field;

      // Add the FieldRef to the /Fields array
      FieldsArray.Add(FieldRef);
    end;
  end;
end;

function TPDFForm.RemoveXFAEntries(Options: Integer): Integer;
begin
  FFormDict.PurgeKey('XFA');

  if (Assigned(XFA)) then
    XFA.Free;
  XFA := nil;

  Result := 1;
end;

function TPDFForm.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

{ TPDFField }

constructor TPDFField.Create;
begin
  FOnFindObject := nil;
  FSubNames := TQuickPDFStringList.Create;
  FDisplayNames := TQuickPDFStringList.Create;
end;

procedure TPDFField.Load(SourceRef: TPDFIndRef);
var
  Obj: TPDFObject;
  Rect: TPDFArray;
  L, B, T, R: Double;
  Temp: Double;
begin
  Parent := nil;
  HasKids := False;
  FPage := -1;
  FGotSubNames := False;
  FGotDisplayNames := False;
  FFieldType := ftUnknown;
  if (Assigned(SourceRef)) then
  begin
    Obj := FindObject(SourceRef);
    if (Obj is TPDFDictionary) then
    begin
      FFieldRef := SourceRef;
      FSourceDict := TPDFDictionary(Obj);
      FindFieldAnnot;

      FStructure := FSourceDict.Owner;
      GetFieldType;
      Obj := FSourceDict.FindValueByKeyName('Rect');
      if Obj is TPDFArray then
      begin
        L := 0;
        T := 0;
        R := 0;
        B := 0;
        Rect := TPDFArray(Obj);
        Obj := Rect.Item[0];
        if Obj is TPDFNumeric then
          L := TPDFNumeric(Obj).AsDouble;
        Obj := Rect.Item[1];
        if Obj is TPDFNumeric then
          B := TPDFNumeric(Obj).AsDouble;
        Obj := Rect.Item[2];
        if Obj is TPDFNumeric then
          R := TPDFNumeric(Obj).AsDouble;
        Obj := Rect.Item[3];
        if Obj is TPDFNumeric then
          T := TPDFNumeric(Obj).AsDouble;

        if (L > R) then
        begin
          Temp := L;
          L := R;
          R := Temp;
        end;

        if (B > T) then
        begin
          Temp := B;
          B := T;
          T := Temp;
        end;

        FLeft := L;
        FWidth := R - L;
        FHeight := T - B;
        FTop := B + FHeight;
      end;

      Obj := FSourceDict.FindValueByKeyName('T');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFString then
      begin
        FTitle := TPDFString(Obj).AsTextString;
      end else
      begin
        FTitle := '';
      end;
    end;
  end;
end;

function TPDFField.GetInheritableValue(Dict: TPDFDictionary; const Name: AnsiString): TPDFObject;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if Assigned(Dict) then
  begin
    Obj := Dict.FindValueByKeyName(Name);
    if Assigned(Obj) then Result := Obj else
    begin
      Obj := Dict.FindValueByKeyName('Parent');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
        Result := GetInheritableValue(TPDFDictionary(Obj), Name);
    end;
  end;
end;

function TPDFField.GetFieldType: TPDFFieldType;
var
  Obj: TPDFObject;
  FT: AnsiString;
  Ff: Integer;
begin
  if FFieldType = ftUnknown then
  begin
    Result := ftUnknown;
    Obj := GetInheritableValue(FSourceDict, 'FT');
    if Obj is TPDFName then
    begin
      FT := TPDFName(Obj).Name;
      if FT = 'Tx' then
        Result := ftText else
      if FT = 'Ch' then
        Result := ftChoice else
      if FT = 'Btn' then
      begin
        Obj := GetInheritableValue(FSourceDict, 'Ff');
        if Obj is TPDFNumeric then
          Ff := TPDFNumeric(Obj).AsInteger
        else
          Ff := 0;

        if Ff and $10000 = $10000 then
          Result := ftPushButton
        else
        if (Ff and $10000 = $0) and (Ff and $8000 = 0) then
          Result := ftCheckbox
        else
        if (Ff and $10000 = 0) and (Ff and $8000 = $8000) then
        begin
          Result := ftRadioButton;
          HasKids := FSourceDict.FindIndexByKeyName('Kids') >= 0;
        end;

        if (Result = ftCheckBox) then
        begin
          Obj := FSourceDict.FindValueByKeyName('Kids', True);
          if (Assigned(Obj)) then
          begin
            HasKids := True;
            Obj := FSourceDict.FindValueByKeyName('Kids', True);
            if (Obj is TPDFArray) then
            begin
              Obj := TPDFArray(Obj).Item[0];
              if (Obj is TPDFIndRef) then
                Obj := TPDFIndRef(Obj).Obj;

              if (Obj is TPDFDictionary) then
              begin
                Obj := TPDFDictionary(obj).FindValueByKeyName('Ff', true);
                if Obj is TPDFNumeric then
                  Ff := TPDFNumeric(Obj).AsInteger;
              end;

              if Ff and $10000 = $10000 then
                Result := ftPushButton
              else
              if (Ff and $10000 = $0) and (Ff and $8000 = 0) then
                Result := ftCheckbox
              else
              if (Ff and $10000 = 0) and (Ff and $8000 = $8000) then
              begin
                Result := ftRadioButton;
                HasKids := FSourceDict.FindIndexByKeyName('Kids') >= 0;
              end;
            end;
          end
        end;
      end else
      if FT = 'Sig' then
        Result := ftSignature;
    end;
    FFieldType := Result;
  end else
    Result := FFieldType;

  if (Result = ftUnknown) and HasKids then Result := ftParent;
  if (Result = ftText) and HasKids then Result := ftParent;
end;

function TPDFField.GetTitle: WideString;
begin
  if Assigned(Parent) then
  begin
    Result := Parent.Title + '.';
  end else
  begin
    Result := '';
  end;
  Result := Result + FTitle;
end;

function TPDFField.GetValue: WideString;
begin
  Result := InterpretValue(GetInheritableValue(FSourceDict, 'V'));
end;

function TPDFField.InterpretValue(Obj: TPDFObject): WideString;
var
  ChoiceArray: TPDFArray;
  ChoiceItem: Integer;
begin
  Result := '';

  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));

  case FFieldType of
    ftText:
    begin
      // The value of a text field is a text string or a text stream
      if Obj is TPDFString then
      begin
        Result := TPDFString(Obj).AsTextString;
      end else
      if Obj is TPDFStream then
      begin
        Result := TPDFStream(Obj).GetDecodedTextStream;
      end;
    end;

    ftPushButton:
    begin
      // A push button field does not have a value
    end;

    ftCheckbox:
    begin
      // The value of a checkbox field is a name value
      // or "Off" as default
      if Obj is TPDFName then
      begin
        Result := QPLLatin1ToWideString(TPDFName(Obj).Name);
      end else
      begin
        Result := 'Off';
      end;
    end;

    ftRadioButton:
    begin
      // The value of a radiobutton field is a name value
      // or "Off" as default
      if Obj is TPDFName then
      begin
        Result := QPLLatin1ToWideString(TPDFName(Obj).Name);
      end else
      begin
        Result := 'Off';
      end;
    end;

    ftChoice:
    begin
      // Choice fields either have a text string for single
      // values or an array of text strings for multiple
      // selection
      if (Obj is TPDFName) then
      begin
        Result := QPLLatin1ToWideString(TPDFName(Obj).Name);
      end else
      if (Obj is TPDFString) then
      begin
        //Result := TPDFString(Obj).As.AsTextString;  // Old version
        Result := WideString(QPLUtf8Decode(TPDFString(Obj).AsString));
      end else
      if (Obj is TPDFArray) then
      begin
        ChoiceArray := TPDFArray(Obj);
        for ChoiceItem := 0 to ChoiceArray.Count - 1 do
        begin
          Obj := ChoiceArray.Item[ChoiceItem];
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFString then
          begin
            if Length(Result) > 0 then
            begin
              Result := Result + WideChar(13);
            end;
            //Result := Result + TPDFString(Obj).AsTextString;
            Result := Result + WideString(QPLUtf8Decode(TPDFString(Obj).AsString));
          end;
        end;
      end;
    end;

    ftSignature:
    begin
      if (Obj is TPDFDictionary) then
      begin
        Result := QPLAnsiStringToWideString(TPDFDictionary(Obj).Output);
      end;
    end;
  end;
end;

function TPDFField.IsReadOnly: Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  Obj := GetInheritableValue(FSourceDict, 'Ff');
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger and 1 = 1;
end;

function TPDFField.IsRequired: Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  Obj := GetInheritableValue(FSourceDict, 'Ff');
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger and 2 = 2;
end;

function TPDFField.IsNoExport: Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  Obj := GetInheritableValue(FSourceDict, 'Ff');
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger and 4 = 4;
end;

function TPDFField.IsVisible: Boolean;
var
  F: Integer;
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('F', True);
  if Obj is TPDFNumeric then
  begin
    F := TPDFNumeric(Obj).AsInteger;
    Result := (F and 38 = 0) or (F and 38 = 4);
  end else
    Result := True;
end;

function TPDFField.SubCount: Integer;
begin
  if not FGotSubNames then GetSubNames;
  Result := FSubNames.Count;
end;

procedure TPDFField.SetReadOnly(NewReadOnly: Boolean);
var
  Ff: Integer;
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('Ff', True);
  if Obj is TPDFNumeric then
  begin
    if NewReadOnly then
      TPDFNumeric(Obj).SetTo(TPDFNumeric(Obj).AsInteger or 1)
    else
    begin
      Ff := TPDFNumeric(Obj).AsInteger;
      if (Ff and 1) = 1 then
        TPDFNumeric(Obj).SetTo(Ff and not(1));
    end;
  end else
  begin
    if NewReadOnly then
      FSourceDict.Add('Ff', FStructure.NewNumeric(1))
    else
      FSourceDict.Add('Ff', FStructure.NewNumeric(0));
  end;
end;

procedure TPDFField.SetRequired(NewRequired: Boolean);
var
  Ff: Integer;
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('Ff', True);
  if Obj is TPDFNumeric then
  begin
    if NewRequired then
      TPDFNumeric(Obj).SetTo(TPDFNumeric(Obj).AsInteger or 2)
    else
    begin
      Ff := TPDFNumeric(Obj).AsInteger;
      if (Ff and 2) = 2 then
        TPDFNumeric(Obj).SetTo(Ff and not(2));
    end;
  end else
  begin
    if NewRequired then
      FSourceDict.Add('Ff', FStructure.NewNumeric(2))
    else
      FSourceDict.Add('Ff', FStructure.NewNumeric(0));
  end;
end;

procedure TPDFField.SetNoExport(NewNoExport: Boolean);
var
  Ff: Integer;
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('Ff', True);
  if Obj is TPDFNumeric then
  begin
    if NewNoExport then
      TPDFNumeric(Obj).SetTo(TPDFNumeric(Obj).AsInteger or 4)
    else
    begin
      Ff := TPDFNumeric(Obj).AsInteger;
      if (Ff and 4) = 4 then
        TPDFNumeric(Obj).SetTo(Ff and not(4));
    end;
  end else
  begin
    if NewNoExport then
      FSourceDict.Add('Ff', FStructure.NewNumeric(4))
    else
      FSourceDict.Add('Ff', FStructure.NewNumeric(0));
  end;
end;

procedure TPDFField.SetTitle(const NewTitle: WideString);
var
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('T', True);
  if not Assigned(Obj) then
  begin
    Obj := FStructure.NewString('');
    FSourceDict.Add('T', Obj);
  end;
  if Obj is TPDFString then
  begin
    TPDFString(Obj).SetToTextString(NewTitle);
    FTitle := NewTitle;
  end;
  FieldChanged;  
end;

procedure TPDFField.SetValue(const NewValue: WideString);
begin
  SetValueByKey(NewValue, 'V');
  FieldChanged;
end;

procedure TPDFField.SetValueByKey(const NewValue: WideString; const Key: AnsiString);
var
  I: Integer;
  Obj: TPDFObject;
  FieldType: TPDFFieldType;
  NewValuePD: AnsiString;
  NewValueUTF8: AnsiString;
  NDict, APDict: TPDFDictionary;
  KeyFound: Boolean;
  NStream: TPDFStream;
  SL: TQuickPDFStringList;
  IL: TQuickPDFIntegerList;
  VArr, IArr: TPDFArray;
  Idx: Integer;
 begin
  FieldType := GetFieldType;

  // Get the PDFDocEncoding version of the new value
  NewValuePD := QPLEncodePDFDoc(NewValue);

  // Get the UTF-8 version of the new value
  NewValueUTF8 := QPLUTF8Encode(NewValue);

  if (FieldType = ftText) or (FieldType = ftParent) then
  begin
    FSourceDict.PurgeKey(Key);
    FSourceDict.Add(Key, FStructure.NewTextString(NewValue));
  end;

  if (FieldType = ftCheckBox) or (FieldType = ftRadioButton) then
  begin
    SetKidsValue(NewValue);
    Obj := FSourceDict.FindValueByKeyName(Key);

    if not Assigned(Obj) then
    begin
      FSourceDict.PurgeKey(Key);
      FSourceDict.Add(Key, FStructure.NewName(''));
      Obj := FSourceDict.FindValueByKeyName(Key, True);
    end;

    if Obj is TPDFName then
      TPDFName(Obj).SetTo(NewValuePD);

    if Key = 'V' then
    begin
      KeyFound := False;
      Obj := FSourceDict.FindValueByKeyName('AP');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
      begin
        APDict := TPDFDictionary(Obj);
        Obj := APDict.FindValueByKeyName('N');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFDictionary then
        begin
          NDict := TPDFDictionary(Obj);

          Obj := NDict.FindValueByKeyName(NewValuePD);
          if Obj is TPDFIndRef then KeyFound := True;

          for I := 0 to NDict.Count - 1 do
          begin
            Obj := NDict.Entry[I].Value;
            if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));

            if (Obj is TPDFStream) then
            begin
              NStream := TPDFStream(Obj);

              // Look for the /Type entry in the /N stream, add it if necessary
              Obj := NStream.Dictionary.FindValueByKeyName('Type');
              if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
              if (not (Obj is TPDFName)) then
              begin
                Obj := FStructure.NewName('XObject');
                NDict.Add('Type', Obj);
              end else
              if (Obj is TPDFName) then
              begin
                TPDFName(Obj).SetTo('XObject');
              end;

              // Look for the /Subtype entry in the /N stream, add it if necessary
              Obj := NStream.Dictionary.FindValueByKeyName('Subtype');
              if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
              if (not (Obj is TPDFName)) then
              begin
                Obj := FStructure.NewName('Form');
                NDict.Add('Subtype', Obj);
              end else
              if (Obj is TPDFName) then
              begin
                TPDFName(Obj).SetTo('Form');
              end;
            end
            else
            begin
              // Look for the /Type entry in the /N dict, add it if necessary
              Obj := NDict.FindValueByKeyName('Type');
              if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
              if (not (Obj is TPDFName)) then
              begin
                Obj := FStructure.NewName('XObject');
                NDict.Add('Type', Obj);
              end else
              if (Obj is TPDFName) then
              begin
                TPDFName(Obj).SetTo('XObject');
              end;

              // Look for the /Subtype entry in the /N dict, add it if necessary
              Obj := NDict.FindValueByKeyName('Subtype');
              if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
              if (not (Obj is TPDFName)) then
              begin
                Obj := FStructure.NewName('Form');
                NDict.Add('Subtype', Obj);
              end else
              if (Obj is TPDFName) then
              begin
                TPDFName(Obj).SetTo('Form');
              end;
            end;
          end;
        end;
      end;

      Obj := FSourceDict.FindValueByKeyName('AS');

      if not Assigned(Obj) then
      begin
        FSourceDict.PurgeKey('AS');
        FSourceDict.Add('AS', FStructure.NewName(''));
        Obj := FSourceDict.FindValueByKeyName('AS', True);
      end;

      if Obj is TPDFName then
      begin
        if KeyFound then
          TPDFName(Obj).SetTo(NewValuePD)
        else
          TPDFName(Obj).SetTo('Off');
      end;
    end;
  end;

  if FieldType = ftChoice then
  begin
    if not FGotSubNames then GetSubNames;

    VArr := FStructure.NewArray;
    IArr := FStructure.NewArray;
    SL := TQuickPDFStringList.Create;
    IL := TQuickPDFIntegerList.Create;

    SL.Text := NewValueUTF8;
    for I := 0 to SL.Count - 1 do
    begin
      Idx := FSubNames.IndexOf(SL[I]);
      if (Idx <> -1) and (IL.Find(Idx) = false) then
        IL.Add((Idx))
    end;

    IL.SortList;

    for I := 0 to IL.Count - 1 do
    begin
      VArr.Add(FStructure.NewString(FSubNames[IL.Items[I]]));
      IArr.Add(FStructure.NewNumeric(IL.Items[I]));
    end;

    if IL.Count > 0 then
    begin

      if (GetFlags and $200000) = $200000 then
      begin
        // Multiselect

        FSourceDict.DeleteEntryByKeyName(Key);
        if (IL.Count = 1) then
          FSourceDict.Add(Key, FStructure.NewString(FSubNames[IL.Items[0]]))
        else
          FSourceDict.Add(Key, VArr);

        if (Key = 'V') then
        begin
          FSourceDict.DeleteEntryByKeyName('I');
          FSourceDict.Add('I', IArr);
        end;

      end else
      begin
        // Not multiselect

        Obj := FSourceDict.FindValueByKeyName(Key);
        if not Assigned(Obj) then
        begin
          FSourceDict.PurgeKey(Key);
          FSourceDict.Add(Key, FStructure.NewString(''));
          Obj := FSourceDict.FindValueByKeyName(Key, True);
        end;

        if Obj is TPDFString then TPDFString(Obj).SetToTextString(WideString(FSubNames[IL.Items[0]]));

        if Key = 'V' then
        begin
          FSourceDict.PurgeKey('I');
          FSourceDict.Add('I', FStructure.NewIntArray([IL.Items[0]]));
        end;
      end;

    end else
    begin
      FSourceDict.PurgeKey(Key);
      if Key = 'V' then
        FSourceDict.PurgeKey('I');

      if (GetFlags and $40000) = $40000 then
      begin
        // Editable choice field

        FSourceDict.Add(Key, FStructure.NewString(NewValueUTF8));
      end;
    end;

    IL.Destroy;
    SL.Destroy;

  end;
end;

procedure TPDFField.SetVisible(NewVisible: Boolean);
begin
  SetVisiblePrintable(NewVisible, IsPrintable);
end;

procedure TPDFField.DeleteFromParent;
begin
  if (Assigned(Parent)) then
  begin
    Parent.DeleteKid(FFieldRef);
  end;
end;

procedure TPDFField.DeleteKid(KidRef: TPDFIndRef);
var
  Obj: TPDFObject;
  Kids: TPDFArray;
begin
  if (Assigned(FSourceDict)) then
  begin
    Obj := FSourceDict.FindValueByKeyName('Kids');
  end else
  begin
    Obj := nil;
  end;
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFArray then
  begin
    Kids := TPDFArray(Obj);
    Kids.DeleteObj(KidRef);
    if (Kids.Count = 0) then
    begin
      DeleteFromParent;
    end;
  end;
end;

destructor TPDFField.Destroy;
begin
  FSubNames.Free;
  FDisplayNames.Free;
end;

procedure TPDFField.GetSubNames;
var
  APDict: TPDFDictionary;
  Obj: TPDFObject;
  FieldType: TPDFFieldType;
  K: Integer;
  Kids: TPDFArray;
  KidDict: TPDFDictionary;
  KidIndRef: TPDFIndRef;
  S: AnsiString;
  HasKidsArray: Boolean;
begin
  FGotSubNames := True;
  FSubNames.Clear;
  FieldType := GetFieldType;

  HasKidsArray := FSourceDict.FindIndexByKeyName('Kids') > 0;

  if ((FieldType = ftCheckbox) or (FieldType = ftRadioButton)) and not HasKidsArray then
  begin
    FSubNames.Add('Off');
    Obj := FSourceDict.FindValueByKeyName('AP', True);
    if Obj is TPDFDictionary then
    begin
      APDict := TPDFDictionary(Obj);
      GetSubNamesFromDict(APDict, -1);
    end;
  end;
  if ((FieldType = ftCheckbox) or (FieldType = ftRadioButton)) and HasKidsArray then
  begin
    FSubNames.Add('Off');
    Obj := FSourceDict.FindValueByKeyName('Kids');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFArray then
    begin
      Kids := TPDFArray(Obj);
      for K := 0 to Kids.Count - 1 do
      begin
        if Kids.Item[K] is TPDFIndRef then
        begin
          KidIndRef := TPDFIndRef(Kids.Item[K]);
          Obj := FindObject(KidIndRef);
          if Obj is TPDFDictionary then
          begin
            KidDict := TPDFDictionary(Form.FindObject(KidIndRef));
            Obj := KidDict.FindValueByKeyName('AP');
            if Obj is TPDFDictionary then
            begin
              APDict := TPDFDictionary(Obj);
              GetSubNamesFromDict(APDict, K);
            end;
          end;
        end;
      end;
    end;
  end;
  if FieldType = ftChoice then
  begin
    Obj := FSourceDict.FindValueByKeyName('Opt');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFArray then
    begin
      Kids := TPDFArray(Obj);
      for K := 0 to Kids.Count - 1 do
      begin
        Obj := Kids.Item[K];
        if Obj is TPDFIndRef then
          Obj := FindObject(TPDFIndRef(Obj));
        S := Obj.Output;
        if Obj is TPDFArray then
          Obj := TPDFArray(Obj).Item[0];
        if Obj is TPDFString then
        begin
          FSubNames.Add(QPLUTF8Encode(TPDFString(Obj).AsTextString));
        end;
      end;
    end;
  end;
end;

procedure TPDFField.GetDisplayNames;
var
  Obj: TPDFObject;
  FieldType: TPDFFieldType;
  K: Integer;
  Kids: TPDFArray;
  S: AnsiString;
begin
  FGotDisplayNames := True;
  FDisplayNames.Clear;
  FieldType := GetFieldType;

  if FieldType = ftChoice then
  begin
    Obj := FSourceDict.FindValueByKeyName('Opt');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFArray then
    begin
      Kids := TPDFArray(Obj);
      for K := 0 to Kids.Count - 1 do
      begin
        Obj := Kids.Item[K];
        if Obj is TPDFIndRef then
          Obj := FindObject(TPDFIndRef(Obj));
        S := Obj.Output;

        if (Obj is TPDFArray) then
        begin
          if (TPDFArray(Obj).Count > 1) then
            Obj := TPDFArray(Obj).Item[1]
          else
            Obj := TPDFArray(Obj).Item[0];
        end;

        if Obj is TPDFString then
        begin
          FDisplayNames.Add(QPLUTF8Encode(TPDFString(Obj).AsTextString));
        end;
      end;
    end;
  end;
end;

procedure TPDFField.GetSubNamesFromDict(APDict: TPDFDictionary; KidIndex: Integer);
var
  Obj: TPDFObject;
  AppDict: TPDFDictionary;
  X: Integer;
  V: Integer;
  SubName: AnsiString;
  I: Integer;
const
  Appearances: AnsiString = 'NRD';
begin
  for X := 1 to Length(Appearances) do
  begin
    Obj := APDict.FindValueByKeyName(QPLCopy(Appearances, X, 1));
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      AppDict := TPDFDictionary(Obj);
      for V := 0 to AppDict.Count - 1 do
      begin
        SubName := AppDict.Entry[V].Key.Name;

        if (not QPLValidUTF8(SubName)) then
        begin
          SubName := GetUTF8FromPDFDoc(SubName);
        end;

        if SubName = 'Off' then I := -1 else I := KidIndex;
        if FSubNames.IndexOf(SubName) < 0 then
          FSubNames.AddObject(SubName, TObject(I));
      end;
    end;
  end;
end;

function TPDFField.GetSubName(SubIndex: Integer): AnsiString;
begin
  if not FGotSubNames then GetSubNames;
  if (SubIndex >= 0) and (SubIndex < FSubNames.Count) then
    Result := FSubNames[SubIndex]
  else
    Result := '';
end;

function TPDFField.SetSubName(SubIndex: Integer; Value, DisplayValue: WideString): Integer;
var
  Obj: TPDFObject;
  Kids: TPDFArray;
  A: TPDFArray;
begin
  Result := 0;

  if GetFieldType = ftChoice then
  begin
    if not FGotSubNames then GetSubNames;
    if not FGotDisplayNames then GetDisplayNames;
    
    if (SubIndex >= 0) and (SubIndex < FSubNames.Count) then
    begin
      if Length(DisplayValue) = 0 then
        DisplayValue := Value;

      FSubNames[SubIndex] := AnsiString(Value);            // Update the SubNames list
      FDisplayNames[SubIndex] := AnsiString(DisplayValue); // Update the DislpayNames list

      begin
        Obj := FSourceDict.FindValueByKeyName('Opt');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFArray then
        begin
          Kids := TPDFArray(Obj);
          if (SubIndex >=0) and (SubIndex <= Kids.Count) then
          begin
            Obj := Kids.Item[SubIndex];
            if Obj is TPDFIndRef then
              Obj := FindObject(TPDFIndRef(Obj));

            if (Obj is TPDFString) then
            begin
              A := FStructure.NewArray;
              A.Add(FStructure.NewString(AnsiString(Value)));
              A.Add(FStructure.NewString(AnsiString(DisplayValue)));
              Kids.Replace(SubIndex, A);
              Result := 1;
            end
            else if Obj is TPDFArray then
            begin
              if (TPDFArray(Obj).Count = 2) then
              begin
                if TPDFArray(Obj).Item[0] is TPDFString then
                  TPDFString(TPDFArray(Obj).Item[0]).SetTo(AnsiString(Value));
                if TPDFArray(Obj).Item[1] is TPDFString then
                  TPDFString(TPDFArray(Obj).Item[1]).SetTo(AnsiString(DisplayValue));
                Result := 1;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFField.GetDisplayName(SubIndex: Integer): AnsiString;
begin
  if not FGotDisplayNames then GetDisplayNames;
  if (SubIndex >= 0) and (SubIndex < FDisplayNames.Count) then
    Result := FDisplayNames[SubIndex]
  else
    Result := '';
end;

function TPDFField.GetPage: Integer;
var
  Obj: TPDFObject;
  PageRef: TPDFIndRef;

  function GetCount(Ref: TPDFIndRef): Integer;
  var
    O: TPDFObject;
    T: AnsiString;
  begin
    Result := 0;
    O := FindObject(Ref);
    if O is TPDFDictionary then
    begin
      T := TPDFDictionary(O).DictType;
      if T = 'Pages' then
      begin
        O := TPDFDictionary(O).FindValueByKeyName('Count');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));        
        if O is TPDFNumeric then
          Result := TPDFNumeric(O).AsInteger;
      end;
      if T = 'Page' then
        Result := 1;
    end;
  end;

  function CountUpTo(ChildRef: TPDFIndRef): Integer;
  var
    O: TPDFObject;
    D: TPDFDictionary;
    K: TPDFArray;
    R: AnsiString;
    X: Integer;
    T: AnsiString;
    ParentRef: TPDFIndRef;
  begin
    Result := 0;
    O := FindObject(ChildRef);
    R := ChildRef.Output;
    if O is TPDFDictionary then
    begin
      D := TPDFDictionary(O);
      O := D.FindValueByKeyName('Parent');
      if O is TPDFIndRef then
      begin
        ParentRef := TPDFIndRef(O);
        O := FindObject(ParentRef);
        if O is TPDFDictionary then
        begin
          D := TPDFDictionary(O);
          O := D.FindValueByKeyName('Kids', True);
          if O is TPDFArray then
          begin
            K := TPDFArray(O);
            X := 0;
            T := '';
            while (X < K.Count) and (T <> R) do
            begin
              O := K.Item[X];
              T := O.Output;
              if (T <> R) and (O is TPDFIndRef) then
                Result := Result + GetCount(TPDFIndRef(O));
              Inc(X);
            end;
          end;
        end;
        Result := Result + CountUpTo(ParentRef);
      end;
    end;
  end;

begin
  if FPage < 0 then
  begin
    Obj := FSourceDict.FindValueByKeyName('P');
    if Obj is TPDFIndRef then
    begin
      PageRef := TPDFIndRef(Obj);
      FPage := CountUpTo(PageRef) + 1;
    end;
  end;
  Result := FPage;
end;

function TPDFField.GetPageRef: TPDFIndRef;
var
  Obj: TPDFObject;
begin
  Result := nil;
  Obj := FSourceDict.FindValueByKeyName('P');
  if Obj is TPDFIndRef then
  begin
    Result := TPDFIndRef(Obj);
  end;
end;

procedure TPDFField.SetDefaultValue(const NewDefaultValue: WideString);
begin
  SetValueByKey(NewDefaultValue, 'DV');
end;

procedure TPDFField.SetPage(NewPage: Integer);
begin
  FPage := NewPage;
end;

procedure TPDFField.SetBounds(Left, Top, Width, Height: Double);
var
  X: Integer;
  A: TPDFArray;
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('Rect');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if (not (Obj is TPDFArray)) or ((Obj is TPDFArray) and
    (TPDFArray(Obj).Count <> 4)) then
  begin
    FSourceDict.PurgeKey('Rect');
    FSourceDict.Add('Rect', FStructure.NewIntArray([0, 0, 0, 0]));
    Obj := FSourceDict.FindValueByKeyName('Rect');
  end;
  if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 4) then
  begin
    FWidth := Width;
    FHeight := Height;
    FTop := Top;
    FLeft := Left;
    A := TPDFArray(Obj);
    for X := 0 to 3 do
    begin
      Obj := A.Item[X];
      if not (Obj is TPDFNumeric) then
      begin
        Obj := FStructure.NewNumeric(0);
        A.Replace(X, Obj);
      end;
      if Obj is TPDFNumeric then
        case X of
          0: TPDFNumeric(Obj).SetTo(Left);
          1: TPDFNumeric(Obj).SetTo(Top - Height);
          2: TPDFNumeric(Obj).SetTo(Left + Width);
          3: TPDFNumeric(Obj).SetTo(Top);
        end;
    end;
  end;
  FieldChanged;
end;

procedure TPDFField.AddJavaScriptAction(const ActionType: AnsiString;
  const JavaScript: WideString; AsString, Compress: Boolean);
var
  JS: TPDFStream;
  Obj: TPDFObject;
  ObjNum: Integer;
  GenNum: Integer;
  AddActDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
begin
  Obj := FSourceDict.FindValueByKeyName('AA');
  if not (Obj is TPDFDictionary) then
  begin
    AddActDict := FStructure.NewDictionary;
    FSourceDict.Add('AA', AddActDict);
  end else
    AddActDict := TPDFDictionary(Obj);

  ActionDict := FStructure.NewDictionary;
  ActionDict.Add('Type', FStructure.NewName('Action'));
  ActionDict.Add('S', FStructure.NewName('JavaScript'));

  if AsString then
  begin
    ActionDict.Add('JS', FStructure.NewTextString(JavaScript));
  end else
  begin
    JS := FStructure.NewTextStream(JavaScript, True);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, JS);
    ActionDict.Add('JS', FStructure.NewIndirectRef(ObjNum, GenNum));
  end;

  if ActionType = 'U' then
    FSourceDict.Add('A', ActionDict)
  else
    AddActDict.Add(ActionType, ActionDict);
end;

function TPDFField.GetFlags: Integer;
var
  Obj: TPDFObject;
begin
  Obj := GetInheritableValue(FSourceDict, 'Ff');
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger
  else
    Result := 0;
end;

procedure TPDFField.SetFlags(NewFlags: Integer);
var
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('Ff');
  if not (Obj is TPDFNumeric) then
  begin
    FSourceDict.PurgeKey('Ff');
    Obj := FStructure.NewNumeric(NewFlags);
    FSourceDict.Add('Ff', Obj);
  end else
    TPDFNumeric(Obj).SetTo(NewFlags);
  FieldChanged;
end;

procedure TPDFField.UpdateAppearanceStream(OnlyIfNecessary: Boolean);
var
  Obj: TPDFObject;
  N: TPDFStream;
  CA: AnsiString;
  DR: TPDFDictionary;
  AP: TPDFDictionary;
  Q: Integer;
  BBox: TPDFArray;
  ProcSet: TPDFArray;
  Matrix: TPDFArray;
  Filter: TPDFArray;
  AppearanceStream: AnsiString;
  CheckStyle: TPDFFormFieldCheckStyle;
  ObjNum: Integer;
  GenNum: Integer;
  MK: TPDFDictionary;
  FontRef: TPDFIndRef;
  Font: TPDFFont;
  XPos: Double;
  YPos: Double;
  Painter: TPDFPainter;
  Ff: Integer;
  FontSize: Double;
  AutoFontSize: Double;
  BorderWidth: Double;
  NewValue: WideString;
  FieldType: TPDFFieldType;
  Rotation: Integer;
  BoxWidth, BoxHeight: Double;
  AutoSize: Boolean;
  CanDoIt: Boolean;
  P: Integer;
  CS: AnsiString;
  TextWidth: Double;

const
  Valid: array[TPDFFieldType] of AnsiString = ('', '13-14-21-23-24-25-28-',
    '16-17-26-', '16-17-26-', '16-17-26-', '18-19-20-22-23-27-', '', '');

  function FfBitSet(Position: Integer): Boolean;
  var
    Mask: Integer;
  begin
    if QPLPos(QPLIntToStr(Position) + '-', Valid[FieldType]) > 0 then
    begin
      Mask := 1 shl (Position - 1);
      Result := Ff and Mask = Mask;
    end else
      Result := False;
  end;

begin
  Rotation := 0;
  BoxWidth := Width;
  BoxHeight := Height;

  BorderWidth := 0;
  SetLength(NewValue, 0);

  if (BoxWidth > 0) and (BoxHeight > 0) then
  begin
    FieldType := GetFieldType;
    case FieldType of
      ftText: NewValue := GetValue;
      ftPushButton: NewValue := GetCaption;
      ftChoice: NewValue := GetValue;
    end;

    if (FieldType = ftText) or (FieldType = ftPushButton) or (FieldType = ftSignature) or (FieldType = ftChoice) or
      (FieldType = ftCheckBox) or (FieldType = ftRadioButton) then
    begin

      // Find the DR dictionary
      DR := nil;
      Obj := Form.FFormDict.FindValueByKeyName('DR');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then DR := TPDFDictionary(Obj);

      // Find the Q value
      Q := 0;
      if FieldType = ftChoice then Q := 2;     // Default is right aligned
      Obj := GetInheritableValue(FSourceDict, 'Q');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFNumeric then Q := TPDFNumeric(Obj).AsInteger;

      // Get the flags
      Ff := 0;
      Obj := GetInheritableValue(FSourceDict, 'Ff');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFNumeric then Ff := TPDFNumeric(Obj).AsInteger;

      // Find the AP dictionary
      AP := nil;
      Obj := FSourceDict.FindValueByKeyName('AP');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then AP := TPDFDictionary(Obj);

      // Find the MK dictionary, if any
      MK := nil;
      Obj := FSourceDict.FindValueByKeyName('MK');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then MK := TPDFDictionary(Obj);

      if not Assigned(MK) then
      begin
        MK := FStructure.NewDictionary;
        FSourceDict.Add('MK', MK);
      end;

      if Assigned(MK) then
      begin
        Obj := MK.FindValueByKeyName('R');
        if Obj is TPDFNumeric then
          Rotation := TPDFNumeric(Obj).AsInteger;
      end;

      if not Assigned(AP) then
      begin
        AP := FStructure.NewDictionary;
        FSourceDict.Add('AP', AP);
      end;

      CanDoIt := not OnlyIfNecessary;

      // Get the normal appearance (N stream)
      N := nil;
      if Assigned(AP) then
      begin
        Obj := AP.FindValueByKeyName('N');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFStream then
        begin
          N := TPDFStream(Obj);
          CanDoIt := True;
        end;

        if (Obj is TPDFDictionary) then
        begin
          CheckStyle := csCheck;
          CA := '4';            // CheckBox
          if (FieldType = ftRadioButton)  then
            CA := 'l';          // Circle

          if Assigned(MK) then
          begin
            Obj := MK.FindValueByKeyName('CA');

            if (not Assigned(Obj)) then
              MK.Add('CA', FStructure.NewString(CA))
            else
              if Obj is TPDFString then
                CA := TPDFString(Obj).AsString;
          end;
          if (CA = '4') then            // Checkbox
            CheckStyle := csCheck
          else if (CA = 'l') then       // Circle
            CheckStyle := csCircle
          else if (CA = '8') then       // Cross
            CheckStyle := csCross
          else if (CA = 'u') then       // Diamond
            CheckStyle := csDiamond
          else if (CA = 'n') then       // Square
            CheckStyle := csSquare
          else if (CA = 'H') then       // Star
            CheckStyle := csStar
          else if (CA = 'Q1') then      // QPL XP Check
            CheckStyle := csXPCheck
          else if (CA = 'Q2') then      // QPL XP Radio
            CheckStyle := csXPRadio;

          SetCheckStyle(CheckStyle, cpCenter);
        end else
        if not Assigned(N) then
        begin
          CanDoIt := True;
          N := FStructure.NewStream('');
          Form.OnNewIndObj(Self, ObjNum, GenNum, N);
          AP.PurgeKey('N');
          AP.Add('N', FStructure.NewIndirectRef(ObjNum, GenNum));
        end;
      end;

      if Assigned(DR) and Assigned(N) and CanDoIt then
      begin

        if Assigned(N) then AppearanceStream := N.GetDecodedStream
          else AppearanceStream := '';

        if ((Rotation div 90) mod 2 = 1) then
        begin
          BoxWidth := Height;
          BoxHeight := Width;
        end;

        Painter := TPDFPainter.Create;
        try
          Painter.PDFPrecNum := FStructure.PDFPrecNum;
          if Rotation = 90 then Painter.Rotate(Width, 0, 90);
          if Rotation = 180 then Painter.Rotate(Width, Height, 180);
          if Rotation = 270 then Painter.Rotate(0, Height, 270);

          if (FfBitSet(25) and (not FfBitSet(14)) and (not FfBitSet(21)) and (MaxLen > 0)) then
          begin
            AppearanceBox(Painter, BoxWidth, BoxHeight, BorderWidth, MaxLen, csNone);
          end else
          begin
            AppearanceBox(Painter, BoxWidth, BoxHeight, BorderWidth, 0, csNone);
          end;

          {if NewValue <> '' then}
          begin

            FontRef := GetFontRef;

            if (FieldType = ftText) or (FieldType = ftPushButton) or (FieldType = ftSignature) or (FieldType = ftChoice) then
            begin
              if (not Assigned(FontRef)) or (GetFontKey = 'ZaDb') then
              begin
                FontRef := Form.GetFontRef('Helv');
                SetStandardFont(4);
              end;
            end;

            if Assigned(FontRef) then
            begin
              Font := TPDFFont.Create(FStructure, GetFontKey);
              try
                Font.PopulateFromIndRef(FontRef);
                FontSize := GetFontSize;
                AutoSize := FontSize = 0;
                if AutoSize then FontSize := (BoxHeight - 4 * BorderWidth);
                if FontSize <= 0 then FontSize := 1;
                Painter.SelectFont(Font, FontSize);
                CS := GetFontColorSpace;
                if CS = 'DeviceRGB' then
                  Painter.SetTextColor(GetFontColor(1), GetFontColor(2), GetFontColor(3));
                if CS = 'DeviceGray' then
                  Painter.SetTextColor(F(GetFontColor(1)) + 'g');
                if CS = 'DeviceCMYK' then
                  Painter.SetTextColor(GetFontColor(1), GetFontColor(2), GetFontColor(3), GetFontColor(4));
                if QPLCopy(CS, 1, 12) = 'Separation: ' then
                  Painter.SetTextColor(QPLCopy(CS, 14, MaxInt), GetFontColor(1));
                XPos := BorderWidth * 2;

                if  (FieldType = ftText) or (FieldType = ftChoice) then
                begin
                  case Q of       // case 0 is the default anyway
                    1:
                      begin
                        XPos := BoxWidth / 2;
                        Painter.TextAlign := paCenter;
                      end;
                    2:
                      begin
                        XPos := BoxWidth - BorderWidth * 2;
                        Painter.TextAlign := paRight;
                      end;
                  end;
                end;

                if FfBitSet(13) then     // Multiline
                begin
                  if AutoSize then
                  begin
                    FontSize := 12;
                    Painter.SelectFont(Font, FontSize);
                    YPos := BoxHeight - (2 * BorderWidth - Font.Bound.Bottom / 1000 * FontSize);
                    Painter.FitWideTextBox(BorderWidth + LW, YPos, BoxWidth - (BorderWidth * 4 - LW * 0.5), BoxHeight - BorderWidth * 4, NewValue, 1, AnsiChar(13));
                  end else
                  begin
                    YPos := BoxHeight - (1.5 * BorderWidth + LW * 0.5) - Painter.TextHeight;

                    if (YPos < 1.5 * BorderWidth + LW * 0.5) then
                      YPos := 3 * BorderWidth + LW;

                    Painter.DrawWrappedWideText(BorderWidth + LW, YPos, BoxWidth - (BorderWidth * 4 - LW * 0.5), NewValue, AnsiChar(13));
                  end;
                end else
                begin
                  if AutoSize then
                  begin
                    TextWidth := Painter.WideTextWidth(NewValue);
                    if (TextWidth > 0) then
                    begin
                      AutoFontSize := FontSize * ((BoxWidth - BorderWidth * 4) / TextWidth);

                      if (BoxHeight - (2 * BorderWidth)) * 0.74 < AutoFontSize then
                        FontSize := (BoxHeight - (2 * BorderWidth)) * 0.74
                      else if (AutoFontSize < FontSize) then
                        FontSize := AutoFontSize;

                      if FontSize < 4 then
                        FontSize := 4;

                      Painter.SelectFont(Font, FontSize);
                    end;

                    if FfBitSet(25) and (not FfBitSet(14)) and
                      (not FfBitSet(21)) and (MaxLen > 0) then
                    begin
                      YPos := BoxHeight;
                      Painter.SetFillColor(1, 0, 0);
                      Painter.WideComb(0, YPos, BoxWidth, BoxHeight, NewValue, MaxLen);
                    end else
                    begin
                      YPos := (BoxHeight - Painter.TextHeight) / 2 - Painter.TextDescent;
                      Painter.DrawWideText(XPos, YPos, NewValue);
                    end;
                  end else
                  begin
                    if FfBitSet(25) and (not FfBitSet(14)) and
                      (not FfBitSet(21)) and (MaxLen > 0) then
                    begin
                      YPos := BoxHeight;
                      Painter.SetFillColor(1, 0, 0);
                      Painter.WideComb(0, YPos, BoxWidth, BoxHeight, NewValue, MaxLen);
                    end else
                    begin
                      YPos := (BoxHeight - Painter.TextHeight) / 2 - Painter.TextDescent;
                      Painter.DrawWideText(XPos, YPos, NewValue);
                    end;
                  end;
                end;
              finally
                Font.Free;
              end;
            end;

            AppearanceStream := Painter.Source;
            P := QPLPos('q', QPLCopy(AppearanceStream, 1, 3));
            if P = 0 then AppearanceStream := 'q ' + AppearanceStream;
            P := QPLPos('Q', QPLCopy(AppearanceStream, Length(AppearanceStream) - 2, 3));
            if P = 0 then AppearanceStream := AppearanceStream + ' Q';
            AppearanceStream := '/Tx BMC ' + AppearanceStream + ' EMC';

          end;          
        finally
          Painter.Free;
        end;

        BBox := FStructure.NewArray;
        BBox.Add(FStructure.NewNumeric(0));
        BBox.Add(FStructure.NewNumeric(0));
        BBox.Add(FStructure.NewNumeric(Width));
        BBox.Add(FStructure.NewNumeric(Height));
        N.Dictionary.Add('BBox', BBox);
        N.Dictionary.DeleteEntryByKeyName('Matrix');
        Matrix := FStructure.NewArray;
        Matrix.Add(FStructure.NewNumeric(1));
        Matrix.Add(FStructure.NewNumeric(0));
        Matrix.Add(FStructure.NewNumeric(0));
        Matrix.Add(FStructure.NewNumeric(1));
        Matrix.Add(FStructure.NewNumeric(0));
        Matrix.Add(FStructure.NewNumeric(0));
        N.Dictionary.Add('Matrix', Matrix);
        N.Dictionary.Add('Subtype', FStructure.NewCommonName('Form'));
        ProcSet := FStructure.NewArray;
        ProcSet.Add(FStructure.NewName('PDF'));
        ProcSet.Add(FStructure.NewName('Text'));
        DR.Add('ProcSet', ProcSet);
        N.Dictionary.Add('Resources', DR);
        N.Dictionary.Add('Type', FStructure.NewName('XObject'));
        N.Dictionary.Add('FormType', FStructure.NewNumeric(1));
        N.Dictionary.DeleteEntryByKeyName('Filter');
        Filter := FStructure.NewArray;
        Filter.Add(FStructure.NewName('FlateDecode'));
        N.Dictionary.Add('Filter', Filter);
        N.SetTo(AppearanceStream, True);
      end;
    end;
  end;
end;

function TPDFField.GetJavaScriptAction(const ActionType: AnsiString): WideString;
var
  Obj: TPDFObject;
  AddActDict: TPDFDictionary;
begin
  Result := '';
  Obj := FSourceDict.FindValueByKeyName('AA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if (Obj is TPDFDictionary) then
  begin
    AddActDict := TPDFDictionary(Obj);
    Obj := AddActDict.FindValueByKeyName(ActionType);
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('JS');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFStream then
        Result := TPDFStream(Obj).GetDecodedTextStream;
      if Obj is TPDFString then
        Result := TPDFString(Obj).AsTextString;
    end;
  end;

  if (ActionType = 'U') and (Result = '') then
  begin
    Obj := FSourceDict.FindValueByKeyName('A');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('JS');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFStream then
        Result := TPDFStream(Obj).GetDecodedTextStream;
      if Obj is TPDFString then
        Result := TPDFString(Obj).AsTextString;
    end;
  end;
end;

procedure TPDFField.SetKidsValue(const NewValue: WideString);
var
  K: Integer;
  Obj: TPDFObject;
  Kids: TPDFArray;
  APDict: TPDFDictionary;
  KidDict: TPDFDictionary;
  KidIndRef: TPDFIndRef;
  NewValuePD: AnsiString;
begin
  NewValuePD := QPLEncodePDFDoc(NewValue);

  Obj := FSourceDict.FindValueByKeyName('Kids');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFArray then
  begin
    Kids := TPDFArray(Obj);
    for K := 0 to Kids.Count - 1 do
    begin
      if Kids.Item[K] is TPDFIndRef then
      begin
        KidIndRef := TPDFIndRef(Kids.Item[K]);
        Obj := FindObject(KidIndRef);
        if Obj is TPDFDictionary then
        begin
          KidDict := TPDFDictionary(Form.FindObject(KidIndRef));
          KidDict.Add('AS', FStructure.NewName('Off'));
          Obj := KidDict.FindValueByKeyName('AP');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFDictionary then
          begin
            APDict := TPDFDictionary(Obj);
            if DictHasSubName(APDict, NewValuePD) then
              KidDict.Add('AS', FStructure.NewName(NewValuePD));
          end;
        end;
      end;
    end;
  end;
end;

function TPDFField.DictHasSubName(APDict: TPDFDictionary; const Key: AnsiString): Boolean;
var
  Obj: TPDFObject;
  AppDict: TPDFDictionary;
  X: Integer;
  V: Integer;
const
  Appearances: AnsiString = 'NRD';
begin
  Result := False;
  for X := 1 to Length(Appearances) do
  begin
    Obj := APDict.FindValueByKeyName(QPLCopy(Appearances, X, 1), True);
    if Obj is TPDFDictionary then
    begin
      AppDict := TPDFDictionary(Obj);
      for V := 0 to AppDict.Count - 1 do
        if AppDict.Entry[V].Key.Name = Key then Result := True;
    end;
  end;
end;

function TPDFField.MakeFloat(D: Double): AnsiString;
begin
  Result := QPLDoubleToStr(D, FStructure.PDFPrecNum) + ' ';
end;

function TPDFField.GetDescription: WideString;
var
  Obj: TPDFObject;
begin
  Result := '';
  Obj := FSourceDict.FindValueByKeyName('TU');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
    Result := TPDFString(Obj).AsTextString;
end;

procedure TPDFField.SetDescription(const NewValue: WideString);
var
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('TU');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
    TPDFString(Obj).SetToTextString(NewValue)
  else
    FSourceDict.Add('TU', FStructure.NewTextString(NewValue));
  FieldChanged;    
end;

procedure TPDFField.SetDingbatsFont;
var
  DA: AnsiString;
  Obj: TPDFObject;
begin

  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));

  DA := '/ZaDb 0 Tf 0 0 0 rg';

  if Obj is TPDFString then
    TPDFString(Obj).SetTo(DA)
  else
    FSourceDict.Add('DA', FStructure.NewString(DA));
end;

procedure TPDFField.SetBackgroundColor(Red, Green, Blue: Double);
begin
  SetMKKey('BG', FStructure.NewDoubleArray([Red, Green, Blue]));
  FieldChanged;
end;

procedure TPDFField.SetBorderColor(Red, Green, Blue: Double);
begin
  SetMKKey('BC', FStructure.NewDoubleArray([Red, Green, Blue]));
  FieldChanged;
end;

procedure TPDFField.RemoveBackgroundColor;
var
  Obj: TPDFObject;
  MK: TPDFDictionary;
begin
  Obj := FSourceDict.FindValueByKeyName('MK');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if (Obj is TPDFDictionary) then
  begin
    MK := TPDFDictionary(Obj);
    MK.PurgeKey('BG');
  end;
end;

procedure TPDFField.RemoveBorderColor;
var
  Obj: TPDFObject;
  MK: TPDFDictionary;
begin
  Obj := FSourceDict.FindValueByKeyName('MK');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if (Obj is TPDFDictionary) then
  begin
    MK := TPDFDictionary(Obj);
    MK.PurgeKey('BC');
  end;
end;

procedure TPDFField.SetMKKey(const Key: AnsiString; Value: TPDFObject);
var
  Obj: TPDFObject;
  MK: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
begin
  Obj := FSourceDict.FindValueByKeyName('MK');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if not Assigned(Obj) then
  begin
    Obj := FStructure.NewDictionary;
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
    FSourceDict.Add('MK', FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
  if Obj is TPDFDictionary then
  begin
    MK := TPDFDictionary(Obj);
    Obj := MK.FindValueByKeyName(Key);
    if Assigned(Obj) then MK.PurgeKey(Key);
    MK.Add(Key, Value);
  end;
end;

procedure TPDFField.SetCaption(const NewCaption: WideString);
begin
  SetMKKey('CA', FStructure.NewTextString(NewCaption));
  FieldChanged;  
end;

procedure TPDFField.SetBorderColor(Gray: Double);
begin
  SetMKKey('BC', FStructure.NewDoubleArray([Gray]));
end;

procedure TPDFField.SetBorderStyle(Width: Double; const Style: AnsiString;
  DashOn, DashOff: Double);
var
  Obj: TPDFObject;
  BSDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
begin
  Obj := FSourceDict.FindValueByKeyName('BS');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if not Assigned(Obj) then
  begin
    Obj := FStructure.NewDictionary;
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
    FSourceDict.Add('BS', FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
  if Obj is TPDFDictionary then
  begin
    BSDict := TPDFDictionary(Obj);
    BSDict.PurgeKey('Type');
    BSDict.PurgeKey('W');
    BSDict.PurgeKey('S');
    BSDict.PurgeKey('D');
    BSDict.Add('Type', FStructure.NewName('Border'));
    BSDict.Add('W', FStructure.NewNumeric(Width));
    BSDict.Add('S', FStructure.NewName(Style));
    if Style = 'D' then
    begin
      BSDict.Add('D', FStructure.NewArray([
        FStructure.NewNumeric(DashOn),
        FStructure.NewNumeric(DashOff)
      ]));
    end;
  end;
  FieldChanged;
end;

procedure TPDFField.SetIcon(const Key: AnsiString; Ref: TPDFIndRef);
begin
  SetMKKey(Key, Ref);
  FieldChanged;  
end;

procedure TPDFField.SetIconStyle(Placement: Integer; const Scale,
  ScaleType: AnsiString; HShift, VShift: Double);
var
  IFDict: TPDFDictionary;
begin
  SetMKKey('TP', FStructure.NewNumeric(Placement));
  IFDict := FStructure.NewDictionary;
  SetMKKey('IF', IFDict);
  IFDict.Add('SW', FStructure.NewName(Scale));
  IFDict.Add('S', FStructure.NewName(ScaleType));
  IFDict.Add('A', FStructure.NewArray([
    FStructure.NewNumeric(HShift),
    FStructure.NewNumeric(VShift)
  ]));
  FieldChanged;  
end;

procedure TPDFField.SetHighlightMode(const Mode: AnsiString);
begin
  FSourceDict.PurgeKey('H');
  FSourceDict.Add('H', FStructure.NewName(Mode));
  FieldChanged;  
end;

procedure TPDFField.RemoveAppearanceStream;
var
  Obj: TPDFObject;
  Kids: TPDFArray;
  X: Integer;
  KidField: TPDFField;
begin
  FSourceDict.PurgeKey('AP');

  Obj := FSourceDict.FindValueByKeyName('Kids');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFArray then
  begin
    Kids := TPDFArray(Obj);
    for X := 0 to Kids.Count - 1 do
    begin
      Obj := Kids.Item[X];
      if Obj is TPDFIndRef then
      begin
        KidField := Form.FindFormField(TPDFIndRef(Obj));
        if Assigned(KidField) then
          KidField.RemoveAppearanceStream;
      end;
    end;
  end;
end;

function TPDFField.GetAnnotFlags: Integer;
var
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('F');
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger
  else
    Result := 0;
end;

procedure TPDFField.SetAnnotFlags(NewFlags: Integer);
var
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('F');
  if not (Obj is TPDFNumeric) then
  begin
    FSourceDict.PurgeKey('F');
    Obj := FStructure.NewNumeric(NewFlags);
    FSourceDict.Add('F', Obj);
  end else
    TPDFNumeric(Obj).SetTo(NewFlags);
  FieldChanged;    
end;

function TPDFField.GetAlignment: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  Obj := GetInheritableValue(FSourceDict, 'Q');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger;
end;

procedure TPDFField.SetAlignment(NewAlignment: Integer);
begin
  FSourceDict.PurgeKey('Q');
  FSourceDict.Add('Q', FStructure.NewNumeric(NewAlignment));
  FieldChanged;  
end;

function TPDFField.GetMaxLen: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  Obj := GetInheritableValue(FSourceDict, 'MaxLen');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger;
end;

procedure TPDFField.SetMaxLen(NewMaxLen: Integer);
var
  CurrentValue: WideString;
begin
  FSourceDict.PurgeKey('MaxLen');
  FSourceDict.Add('MaxLen', FStructure.NewNumeric(NewMaxLen));
  CurrentValue := GetValue;
  if Length(CurrentValue) > NewMaxLen then
  begin
    SetLength(CurrentValue, NewMaxLen);
    SetValue(CurrentValue); 
  end;
end;

function TPDFField.GetFontName: AnsiString;
var
  Obj: TPDFObject;
  DA: AnsiString;
  P: Integer;
begin
  Result := '';
  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
  begin
    DA := TPDFString(Obj).AsString;
    P := QPLPos('Tf', DA);
    if P > 0 then
    begin
      Delete(DA, P, MaxInt);
      DA := QPLTrim(DA);
      P := Length(DA);
      while (P > 1) and (DA[P] <> ' ') do
        Dec(P);
      if QPLCopy(DA, P, 1) = ' ' then
      begin
        Delete(DA, P, MaxInt);
        DA := QPLTrim(DA);
        P := Length(DA);
        while (P > 1) and (DA[P] <> '/') do
          Dec(P);
        if QPLCopy(DA, P, 1) = '/' then
        begin
          DA := QPLCopy(DA, P + 1, MaxInt);
          Result := Form.GetFontName(DA);
        end;
      end;
    end;
  end;
end;

function TPDFField.GetFontSize: Double;
var
  Obj: TPDFObject;
  DA: AnsiString;
  P: Integer;
begin
  Result := 0;
  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
  begin
    DA := TPDFString(Obj).AsString;
    P := QPLPos('Tf', DA);
    if P > 0 then
    begin
      Delete(DA, P, MaxInt);
      DA := QPLTrim(DA);
      P := Length(DA);
      while (P > 1) and (DA[P] <> ' ') do
        Dec(P);
      if QPLCopy(DA, P, 1) = ' ' then
      begin
        Delete(DA, 1, P);
        DA := QPLTrim(DA);
        Result := TazzToFloat(DA);
      end;
    end;
  end;
end;

procedure TPDFField.SetFontIndex(FontIndex: Integer);
var
  DA: AnsiString;
  P: Integer;
  PE: Integer;
  Key: AnsiString;
  Obj: TPDFObject;
  Added: Boolean;
begin
  DA := '';
  Added := False;
  Key := Form.GetFontKey(FontIndex);
  if Key <> '' then
  begin
    Obj := GetInheritableValue(FSourceDict, 'DA');
    if not Assigned(Obj) then
      Obj := Form.FFormDict.FindValueByKeyName('DA');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFString then
      DA := TPDFString(Obj).AsString;
    P := QPLPos('Tf', DA);
    if P > 0 then
    begin
      repeat
        Dec(P);
      until (P = 0) or (DA[P] <> ' ');
      if (P > 0) then
      begin
        repeat
          Dec(P);
        until (P = 0) or (DA[P] = ' ');
        if (P > 0) then
        begin
          repeat
            Dec(P);
          until (P = 0) or (DA[P] <> ' ');
          if P > 0 then
          begin
            PE := P;
            if (P > 1) then
            begin
              repeat
                Dec(P);
              until (P = 1) or (DA[P] = ' ');
            end;
            if P = 1 then
            begin
              Delete(DA, 1, PE);
              DA := '/' + Key + DA;
            end else
            begin
              Delete(DA, P + 1, PE - P);
              Insert('/' + Key, DA, P + 1);
            end;
            Added := True;
          end;
        end;
      end;
    end;
    if (DA <> '') and (not Added) then
    begin
      DA := DA + ' /' + Key + ' 0 Tf';;
    end;
    if DA = '' then
    begin
      DA := '/' + Key + ' 0 Tf 0 0 0 rg';
    end;
    FSourceDict.Add('DA', FStructure.NewString(DA));
  end;
  FieldChanged;
end;

procedure TPDFField.SetFontSize(NewSize: Double);
var
  DA: AnsiString;
  P: Integer;
  PE: Integer;
  Obj: TPDFObject;
  Added: Boolean;
begin
  DA := '';
  Added := False;
  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
 if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
    DA := TPDFString(Obj).AsString;
  P := QPLPos('Tf', DA);
  if P > 0 then
  begin
    repeat
      Dec(P);
    until (P = 0) or (DA[P] <> ' ');
    if (P > 0) then
    begin
      PE := P;
      repeat
        Dec(P);
      until (P = 0) or (DA[P] = ' ');
      if (P > 0) then
      begin
        Delete(DA, P + 1, PE - P);
        Insert(QPLTrim(MakeFloat(NewSize)), DA, P + 1);
        Added := True;
      end;
    end;
  end;
  if (not Added) and (DA <> '') then
  begin
    DA := DA + ' /' + Form.GetDefaultFontKey + ' ' +
      MakeFloat(NewSize) + 'Tf';
  end;
  if DA = '' then
  begin
    DA := '/' + Form.GetDefaultFontKey + ' ' +
      MakeFloat(NewSize) + 'Tf 0 0 0 rg';
  end;
  FSourceDict.Add('DA', FStructure.NewString(DA));
  FieldChanged;
end;

function TPDFField.GetFontColor(Component: Integer): Double;
var
  Obj: TPDFObject;
  DA: AnsiString;
  P: Integer;
  X: Integer;
  CC: AnsiString;

  function Pop: AnsiString;
  var
    I: Integer;
  begin
    DA := QPLTrim(DA);
    if QPLPos(' ', DA) = 0 then
    begin
      Result := DA;
      DA := '';
    end else
    begin
      I := Length(DA);
      repeat
        Dec(I);
      until DA[I] = ' ';
      Result := QPLCopy(DA, I + 1, MaxInt);
      Delete(DA, I, MaxInt);
    end;
  end;

begin
  Result := 0;
  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
  begin
    DA := TPDFString(Obj).AsString;
    P := QPLPos('rg', DA);
    if P > 0 then
    begin
      Delete(DA, P, MaxInt);
      DA := QPLTrim(DA);
      for X := 3 downto Component do
      begin
        CC := Pop;
        Result := TazzToFloat(CC);
      end;
    end;
    if P = 0 then
    begin
      P := QPLPos('k', DA);
      if P > 0 then
      begin
        Delete(DA, P, MaxInt);
        DA := QPLTrim(DA);
        for X := 4 downto Component do
        begin
          CC := Pop;
          Result := TazzToFloat(CC);
        end;
      end;
    end;
    if P = 0 then
    begin
      P := QPLPos('g', DA);
      if P > 0 then
      begin
        Delete(DA, P, MaxInt);
        DA := QPLTrim(DA);
        Result := TazzToFloat(Pop);
      end;
    end;
    if P = 0 then
    begin
      P := QPLPos('scn', DA);
      if P > 0 then
      begin
        Delete(DA, P, MaxInt);
        DA := QPLTrim(DA);
        Result := TazzToFloat(Pop);
      end;
    end;
  end;
end;

procedure TPDFField.SetFontColor(Red, Green, Blue: Double);
var
  DA: AnsiString;
  Obj: TPDFObject;
  CC: AnsiString;
begin
  DA := '';
  CC := F(Red) + F(Green) + F(Blue) + 'rg';

  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
    DA := TPDFString(Obj).AsString;
  DA := KillColor(DA);
  if (DA <> '') then
  begin
    DA := DA + ' ' + CC;
  end else
  begin
    DA := '/' + Form.GetDefaultFontKey + ' 0 Tf ' + CC;
  end;
  FSourceDict.Add('DA', FStructure.NewString(DA));
  FieldChanged;
end;

procedure TPDFField.SetTextFlags(MultiLine, Password, FileSelect,
  DoNotSpellCheck, DoNotScroll, Comb: Boolean);
begin
  if GetFieldType = ftText then
  begin
    SetFieldFlags(13, MultiLine);
    SetFieldFlags(14, Password);
    SetFieldFlags(21, FileSelect);
    SetFieldFlags(23, DoNotSpellCheck);
    SetFieldFlags(24, DoNotScroll);
    SetFieldFlags(25, Comb);
  end;
  FieldChanged;
end;

procedure TPDFField.SetFieldFlags(Bit: Integer; SetBit: Boolean);
var
  Ff: Integer;
  Obj: TPDFObject;
  Mask: Integer;
begin
  Mask := 1 shl (Bit - 1);
  Obj := FSourceDict.FindValueByKeyName('Ff');
  if Obj is TPDFNumeric then
  begin
    if SetBit then
      TPDFNumeric(Obj).SetTo(TPDFNumeric(Obj).AsInteger or Mask)
    else
    begin
      Ff := TPDFNumeric(Obj).AsInteger;
      if (Ff and Mask) = Mask then
        TPDFNumeric(Obj).SetTo(Ff - Mask);
    end;
  end else
  begin
    if SetBit then
      FSourceDict.Add('Ff', FStructure.NewNumeric(Mask))
    else
      FSourceDict.Add('Ff', FStructure.NewNumeric(0));
  end;
end;

function TPDFField.GetFontRef: TPDFIndRef;
var
  Obj: TPDFObject;
  DA: AnsiString;
  P: Integer;
begin
  Result := nil;
  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj)); 
  if Obj is TPDFString then
  begin
    DA := TPDFString(Obj).AsString;
    P := QPLPos('Tf', DA);
    if P > 0 then
    begin
      Delete(DA, P, MaxInt);
      DA := QPLTrim(DA);
      P := Length(DA);
      while (P > 1) and (DA[P] <> ' ') do
        Dec(P);
      if QPLCopy(DA, P, 1) = ' ' then
      begin
        Delete(DA, P, MaxInt);
        DA := QPLTrim(DA);
        P := Length(DA);
        while (P > 1) and (DA[P] <> '/') do
          Dec(P);
        if QPLCopy(DA, P, 1) = '/' then
        begin
          DA := QPLCopy(DA, P + 1, MaxInt);
          Result := Form.GetFontRef(DA);
        end;
      end;
    end;
  end;
end;

function TPDFField.GetFontKey: AnsiString;
var
  Obj: TPDFObject;
  DA: AnsiString;
  P: Integer;
begin
  Result := '';
  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
  begin
    DA := TPDFString(Obj).AsString;
    P := QPLPos('Tf', DA);
    if P > 0 then
    begin
      Delete(DA, P, MaxInt);
      DA := QPLTrim(DA);
      P := Length(DA);
      while (P > 1) and (DA[P] <> ' ') do
        Dec(P);
      if QPLCopy(DA, P, 1) = ' ' then
      begin
        Delete(DA, P, MaxInt);
        DA := QPLTrim(DA);
        P := Length(DA);
        while (P > 1) and (DA[P] <> '/') do
          Dec(P);
        if QPLCopy(DA, P, 1) = '/' then
        begin
          DA := QPLCopy(DA, P + 1, MaxInt);
          Result := DA;
        end;
      end;
    end;
  end;
end;

procedure TPDFField.SetRotation(Angle: Integer);
var
  Obj: TPDFObject;
  A: TPDFArray;
  R: TPDFRectangle;
  MK: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
begin
  Angle := (Angle + 360) mod 360;
  //SetMKKey('R', FStructure.NewNumeric(Angle));

  Obj := FSourceDict.FindValueByKeyName('MK', True);
  // No need for a key if there is no key and Angle is 0.
  if not Assigned(Obj) and (Angle <> 0) then
  begin
    Obj := FStructure.NewDictionary;
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
    FSourceDict.Add('MK', FStructure.NewIndirectRef(ObjNum, GenNum));
  end;

  if Obj is TPDFDictionary then
  begin
    MK := TPDFDictionary(Obj);
    Obj := MK.FindValueByKeyName('R', True);

    if (Obj is TPDFNumeric) then
    begin
      TPDFNumeric(Obj).SetTo(Angle);
    end else
    begin
      // No need for a key if there is no key and Angle is 0.
      if (Angle <> 0) then
      begin
        MK.Add('R', FStructure.NewNumeric(Angle));
      end;
    end;
  end;

  Obj := FSourceDict.FindValueByKeyName('Rect');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));

  if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 4) then
  begin
    A := TPDFArray(Obj);
    R := TPDFRectangle.Create(A);
    if R.IsRectangle then
    begin
      FWidth := R.Width;
      FHeight := R.Height;
    end;
    if Assigned(R) then R.Free;
  end;

  FieldChanged;
end;

procedure TPDFField.AppearanceBox(Painter: TPDFPainter; Width, Height: Double;
  var BorderWidth: Double; Combs: Integer; CheckStyle: TPDFFormFieldCheckStyle);
var
  Obj: TPDFObject;
  MKDict: TPDFDictionary;
  BSDict: TPDFDictionary;
  X: Integer;
  C: array of Double;
  B: array of Double;
  Style: AnsiString;
  XPos, YPos, Size: Double;
  DashOn: Double;
  DashOff: Double;
  CArray: TPDFArray;
  DArray: TPDFArray;
  HasFill: Boolean;
  HasColor: Boolean;
begin
  FLW := 1;
  BorderWidth := 1;

  HasFill := False;
  HasColor := False;
  Style := '';

  DashOn := 0;
  DashOff := 0;

  Painter.SetFillColor(1, 1, 1);
  Painter.SetLineColor(0, 0, 0);
  Painter.SetLineWidth(1);
  Obj := FSourceDict.FindValueByKeyName('MK');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    MKDict := TPDFDictionary(Obj);
    Obj := MKDict.FindValueByKeyName('BC');
    if Obj is TPDFArray then
    begin
      Style := 'S';
      CArray := TPDFArray(Obj);
      SetLength(C, CArray.Count);
      for X := 0 to CArray.Count - 1 do
      begin
        Obj := CArray.Item[X];
        if Obj is TPDFNumeric then
          C[X] := TPDFNumeric(Obj).AsDouble
        else
          C[X] := 0;
      end;
      if Length(C) = 1 then
      begin
        Obj := MKDict.FindValueByKeyName('QuickPDFBCColorSpace');
        if Obj is TPDFName then
          Painter.SetLineColor(TPDFName(Obj).Name, C[0])
        else
          Painter.SetLineColor(C[0], C[0], C[0]);
      end;
      if Length(C) = 3 then
        Painter.SetLineColor(C[0], C[1], C[2]);
      if Length(C) = 4 then
        Painter.SetLineColor(C[0], C[1], C[3], C[4]);
      HasColor := True;
    end;
    Obj := MKDict.FindValueByKeyName('BG');
    if Obj is TPDFArray then
    begin
      HasFill := True;
      CArray := TPDFArray(Obj);
      SetLength(B, CArray.Count);
      for X := 0 to CArray.Count - 1 do
      begin
        Obj := CArray.Item[X];
        if Obj is TPDFNumeric then
          B[X] := TPDFNumeric(Obj).AsDouble
        else
          B[X] := 0;
      end;
      if Length(B) = 1 then
      begin
        Obj := MKDict.FindValueByKeyName('QuickPDFBGColorSpace');
        if Obj is TPDFName then
          Painter.SetFillColor(TPDFName(Obj).Name, B[0])
        else
          Painter.SetFillColor(B[0], B[0], B[0]);
      end;
      if Length(B) = 3 then
        Painter.SetFillColor(B[0], B[1], B[2]);
      if Length(B) = 4 then
        Painter.SetFillColor(B[0], B[1], B[2], B[3]);
    end;
  end;

  Obj := FSourceDict.FindValueByKeyName('BS');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    BSDict := TPDFDictionary(Obj);
    Obj := BSDict.FindValueByKeyName('W');
    if Obj is TPDFNumeric then
    begin
      BorderWidth := TPDFNumeric(Obj).AsDouble;;
      if (BorderWidth >= 0) and (BorderWidth <= 3) then
        FLW := BorderWidth;
    end;
    Painter.SetLineWidth(LW);
    Obj := BSDict.FindValueByKeyName('S');
    if Obj is TPDFName then
      Style := TPDFName(Obj).Name;
  end else
    BSDict := nil;

  Size := Min(Width, Height);
  XPos := Width / 2;
  YPos := Height / 2;

  if HasFill then
  begin
    if CheckStyle in [csCircle, csXPRadio] then
      Painter.Circle(XPos, YPos, Size / 2 - LW / 2, HasFill, False)
    else
      Painter.Rectangle(0, Height, Width, Height, True, False);  // No border
  end;

  if ((LW > 0) and HasColor) then
  begin
    if Style = 'S' then
    begin
      if not (CheckStyle in [csCircle, csXPRadio]) then
      begin
        Painter.Rectangle(LW / 2, Height - LW / 2, Width - LW, Height - LW, False, True);
        if (Combs > 0) then
        begin
          for X := 0 to Combs - 1 do
          begin
            Painter.DrawLine(X * Width / Combs, LW / 2, X * Width / Combs, Height - LW);
          end;
        end;
      end else
      begin
        Painter.Circle(XPos, YPos, Size / 2 - LW, False, True);
      end;
    end;
    if (Style = 'D') and Assigned(BSDict) then
    begin
      Obj := BSDict.FindValueByKeyName('D');
      if (Obj is TPDFArray) then
      begin
        DArray := TPDFArray(Obj);
        if (TPDFArray(Obj).Count >= 2) then
        begin
          Obj := DArray.Item[0];
          if Obj is TPDFNumeric then DashOn := TPDFNumeric(Obj).AsDouble else DashOn := 0;
          Obj := DArray.Item[1];
          if Obj is TPDFNumeric then DashOff := TPDFNumeric(Obj).AsDouble else DashOff := 0;
        end
        else if (TPDFArray(Obj).Count = 1) then
        begin
          Obj := DArray.Item[0];
          if Obj is TPDFNumeric then DashOn := TPDFNumeric(Obj).AsDouble else DashOn := 0;
          DashOff := DashOn;
        end;
        Painter.SetLineDash(DashOn, DashOff);
      end;
      if not (CheckStyle in [csCircle, csXPRadio]) then
        Painter.Rectangle(LW / 2, Height - LW / 2, Width - LW, Height - LW, False, True)
      else
        Painter.Circle(XPos, YPos, Size / 2 - LW, False, True);
    end;
    if Style = 'U' then
    begin
      Painter.DrawLine(0, LW / 2, Width, LW / 2);
    end;
    if Style = 'B' then
    begin
      if not (CheckStyle in [csCircle, csXPRadio]) then
      begin
        BorderWidth := LW * 3;
        Painter.Rectangle(LW / 2, Height - LW / 2, Width - LW, Height - LW, False, True);
        Painter.SetFillColor(1, 1, 1);
        Painter.StartPath(LW, Height - LW);
        Painter.AddLineToPath(Width - LW, Height - LW);
        Painter.AddLineToPath(Width - LW * 2, Height - LW * 2);
        Painter.AddLineToPath(LW * 2, Height - LW * 2);
        Painter.AddLineToPath(LW * 2, LW * 2);
        Painter.AddLineToPath(LW, LW);
        Painter.ClosePath;
        Painter.DrawPath(True, False);

        if Length(B) >= 4 then
        begin
          Painter.SetFillColor(B[0] / 2, B[1] / 2, B[2] / 2, B[3] / 2)
        end else
        if Length(B) >= 3 then
        begin
          Painter.SetFillColor(B[0] * 0.7, B[1] * 0.7, B[2] * 0.7);
        end;

        Painter.StartPath(LW, LW);
        Painter.AddLineToPath(LW * 2, LW * 2);
        Painter.AddLineToPath(Width - LW * 2, LW * 2);
        Painter.AddLineToPath(Width - LW * 2, Height - LW * 2);
        Painter.AddLineToPath(Width - LW, Height - LW);
        Painter.AddLineToPath(Width - LW, LW);
        Painter.ClosePath;
        Painter.DrawPath(True, False);
      end else
      begin
        Painter.Circle(XPos, YPos, Size / 2 - LW, False, True);
      end;
    end;
    if Style = 'I' then
    begin
      if not (CheckStyle in [csCircle, csXPRadio]) then
      begin
        BorderWidth := LW * 3;
        Painter.Rectangle(LW / 2, Height - LW / 2, Width - LW, Height - LW, False, True);

        Painter.SetFillColor(0.5, 0.5, 0.5);

        Painter.StartPath(LW, Height - LW);
        Painter.AddLineToPath(Width - LW, Height - LW);
        Painter.AddLineToPath(Width - LW * 2, Height - LW * 2);
        Painter.AddLineToPath(LW * 2, Height - LW * 2);
        Painter.AddLineToPath(LW * 2, LW * 2);
        Painter.AddLineToPath(LW, LW);
        Painter.ClosePath;
        Painter.DrawPath(True, False);

        Painter.SetFillColor(0.7, 0.7, 0.7);
        Painter.StartPath(LW, LW);
        Painter.AddLineToPath(LW * 2, LW * 2);
        Painter.AddLineToPath(Width - LW * 2, LW * 2);
        Painter.AddLineToPath(Width - LW * 2, Height - LW * 2);
        Painter.AddLineToPath(Width - LW, Height - LW);
        Painter.AddLineToPath(Width - LW, LW);
        Painter.ClosePath;
        Painter.DrawPath(True, False);
      end else
      begin
        Painter.Circle(XPos, YPos, Size / 2 - LW, False, True);
      end;
    end;
  end;
end;

procedure TPDFField.FieldChanged;
begin
  if Form.GetNeedAppearances = '' then
    Form.NeedAppearances(True);

  if Form.GetNeedAppearances = 'false' then
  begin
    case GetFieldType of
      ftText: UpdateAppearanceStream;
      ftPushButton: UpdateAppearanceStream;
      //ftSignature: UpdateAppearanceStream;
      ftChoice: UpdateAppearanceStream;
      ftRadioButton: UpdateAppearanceStream;
      ftCheckBox: UpdateAppearanceStream;
    end;
  end else
  begin
    //case GetFieldType of
      //ftText: RemoveAppearanceStream;
      //ftPushButton: RemoveAppearanceStream;
      //ftSignature: RemoveAppearanceStream;
      //ftChoice: RemoveAppearanceStream;
      //ftCheckBox: RemoveAppearanceStream;
    //end;
  end;
end;

function TPDFField.GetCaption: WideString;
var
  Obj: TPDFObject;
begin
  Obj := GetMKKey('CA');
  if Obj is TPDFString then
    Result := TPDFString(Obj).AsTextString;
end;

function TPDFField.GetCaptionEx(StringType: Integer): WideString;
var
  Obj: TPDFObject;
begin
  case StringType of
    1: Obj := GetMKKey('CA');
    2: Obj := GetMKKey('RC');
    3: Obj := GetMKKey('AC');
    else Obj := nil;
  end;
  if Obj is TPDFString then
    Result := TPDFString(Obj).AsTextString;
end;

function TPDFField.GetCheckStyle: TPDFFormFieldCheckStyle;
var
  Obj: TPDFObject;
  CA: WideString;
begin
  Obj := GetMKKey('CA');
  if Obj is TPDFString then
    CA := TPDFString(Obj).AsTextString
  else
  begin
    Obj := FSourceDict.FindValueByKeyName('Kids');
    if Obj is TPDFIndRef then
      Obj := FindObject(TPDFIndRef(Obj));

    if (Obj is TPDFArray) then
      Obj := TPDFArray(Obj).Item[0];
    if Obj is TPDFIndRef then
      Obj := FindObject(TPDFIndRef(Obj));

    if (Obj is TPDFDictionary) then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('MK');
      if Obj is TPDFIndRef then
        Obj := FindObject(TPDFIndRef(Obj));

      if (Obj is TPDFDictionary) then
        Obj := TPDFDictionary(Obj).FindValueByKeyName('CA');
      if Obj is TPDFString then
        CA := TPDFString(Obj).AsTextString
    end;
  end;

  Result := csNone;
  if (CA = '4') then // Checkbox
    Result := csCheck
  else if (CA = 'l') then // Circle
    Result := csCircle
  else if (CA = '8') then // Cross
    Result := csCross
  else if (CA = 'u') then // Diamond
    Result := csDiamond
  else if (CA = 'n') then // Square
    Result := csSquare
  else if (CA = 'H') then // Star
    Result := csStar
  else if (CA = 'Q1') then
    Result := csXPCheck
  else if (CA = 'Q2') then
    Result := csXPRadio;
end;

function TPDFField.GetMKKey(const Key: AnsiString): TPDFObject;
var
  Obj: TPDFObject;
  MK: TPDFDictionary;
begin
  Obj := FSourceDict.FindValueByKeyName('MK');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    MK := TPDFDictionary(Obj);
    Obj := MK.FindValueByKeyName(Key, True);
    Result := Obj;
  end else
    Result := nil;
end;

function TPDFField.GetNormalAPDictRef(Update: Boolean): TPDFIndRef;
var
  Obj: TPDFObject;
  APDict: TPDFDictionary;
  FieldType: TPDFFieldType;
begin
  Result := nil;
  FieldType := GetFieldType;
  if (FieldType = ftText) or (FieldType = ftPushButton) or (FieldType = ftChoice) or (FieldType = ftSignature) then
  begin
    if (FieldType <> ftSignature) then
    begin
      if (Update) then
      begin
        UpdateAppearanceStream(True);
      end;
    end;
    Obj := FSourceDict.FindValueByKeyName('AP');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));    
    if Obj is TPDFDictionary then
    begin
      APDict := TPDFDictionary(Obj);
      Obj := APDict.FindValueByKeyName('N');
      if Obj is TPDFIndRef then Result := TPDFIndRef(Obj);
    end;
  end;
end;

function TPDFField.GetSelectedAPDictRef: TPDFIndRef;
var
  Obj: TPDFObject;
  APDict: TPDFDictionary;
  NDict: TPDFDictionary;
  FieldType: TPDFFieldType;
  SelName: AnsiString;
begin
  Result := nil;
  FieldType := GetFieldType;
  if (FieldType = ftCheckbox) or (FieldType = ftRadioButton) then
  begin
    UpdateAppearanceStream(True);
    Obj := FSourceDict.FindValueByKeyName('AS');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));    
    if Obj is TPDFName then
    begin
      SelName := TPDFName(Obj).Name;
      Obj := FSourceDict.FindValueByKeyName('AP');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));      
      if Obj is TPDFDictionary then
      begin
        APDict := TPDFDictionary(Obj);
        Obj := APDict.FindValueByKeyName('N');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));        
        if Obj is TPDFDictionary then
        begin
          NDict := TPDFDictionary(Obj);
          Obj := NDict.FindValueByKeyName(SelName);
          if Obj is TPDFIndRef then Result := TPDFIndRef(Obj);
        end;
      end;
    end;
  end;
end;

function TPDFField.MakeTempChild(KidIndex: Integer): TPDFField;
var
  Obj: TPDFObject;
  Kids: TPDFArray;
  KidRef: TPDFIndRef;
begin
  Result := nil;
  Obj := FSourceDict.FindValueByKeyName('Kids');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if Obj is TPDFArray then
  begin
    Kids := TPDFArray(Obj);
    Obj := Kids.Item[KidIndex - 1];
    if Obj is TPDFIndRef then
    begin
      KidRef := TPDFIndRef(Obj);
      Result := TPDFField.Create;
      Result.OnFindObject := FOnFindObject;
      Result.Load(KidRef);
      Result.Parent := Self;
      Result.TempField := True;
      Result.Form := Form;
    end;
  end;
end;

function TPDFField.KidCount: Integer;
var
  Obj: TPDFObject;
begin
  Obj := FSourceDict.FindValueByKeyName('Kids');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if Obj is TPDFArray then
    Result := TPDFArray(Obj).Count
  else
    Result := 0;
end;

procedure TPDFField.AddWebLinkAction(const ActionType,
  Link: AnsiString);
var
  Obj: TPDFObject;
  AddActDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
begin
  Obj := FSourceDict.FindValueByKeyName('AA');
  if not (Obj is TPDFDictionary) then
  begin
    AddActDict := FStructure.NewDictionary;
    FSourceDict.Add('AA', AddActDict);
  end else
    AddActDict := TPDFDictionary(Obj);

  ActionDict := FStructure.NewDictionary;
  ActionDict.Add('Type', FStructure.NewName('Action'));
  ActionDict.Add('S', FStructure.NewName('URI'));
  ActionDict.Add('URI', FStructure.NewString(Link));

  if ActionType = 'U' then
    FSourceDict.Add('A', ActionDict)
  else
    AddActDict.Add(ActionType, ActionDict);
end;

function TPDFField.GetWebLinkAction(const ActionType: AnsiString): AnsiString;
var
  Obj: TPDFObject;
  AddActDict: TPDFDictionary;
begin
  Result := '';
  Obj := FSourceDict.FindValueByKeyName('AA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if (Obj is TPDFDictionary) then
  begin
    AddActDict := TPDFDictionary(Obj);
    Obj := AddActDict.FindValueByKeyName(ActionType);
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('URI');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFString then
        Result := TPDFString(Obj).AsString;
    end;
  end;

  if (ActionType = 'U') and (Result = '') then
  begin
    Obj := FSourceDict.FindValueByKeyName('A');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('URI');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFString then
        Result := TPDFString(Obj).AsString;
    end;
  end;
end;

procedure TPDFField.SetPageRef(PageNumber: Integer; Ref: TPDFIndRef);
begin
  FSourceDict.Add('P', Ref);
  FPage := PageNumber;
end;

procedure TPDFField.SetSigKeyValue(const SigKey, SigValue: AnsiString);
var
  Obj: TPDFObject;
  SigValueDict: TPDFDictionary;
  CertArray: TPDFArray;
begin
  SigValueDict := GetSigValue;
  if Assigned(SigValueDict) then
  begin
    if SigKey = 'ExtraCert' then
    begin
      Obj := SigValueDict.FindValueByKeyName('Cert', False);
      if Obj is TPDFString then
      begin
        CertArray := FStructure.NewArray(Obj);
        SigValueDict.Add('Cert', CertArray);
        CertArray.Add(FStructure.NewString(SigValue));
      end;
    end else
      SigValueDict.Add(SigKey, FStructure.NewString(SigValue));
  end;
end;

procedure TPDFField.SetSignatureImage(ImageRef: TPDFIndRef; Options: Integer);
var
  Obj: TPDFObject;
  APDict: TPDFDictionary;
  NStream: TPDFStream;
  ResourcesDict: TPDFDictionary;
  XObjectDict: TPDFDictionary;
  ImageName: AnsiString;
  StreamContent: AnsiString;
  ObjNum, GenNum: Integer;
begin
  if (FieldType = ftSignature) and (Assigned(FAnnotDict)) then
  begin
    APDict := nil;
    NStream := nil;
    ResourcesDict := nil;
    XObjectDict := nil;
    ImageName := '';

    // Look for the /AP entry in the annotation dictionary, add it if
    // necessary
    Obj := FAnnotDict.FindValueByKeyName('AP');
    if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
    if (not (Obj is TPDFDictionary)) then
    begin
      Obj := FStructure.NewDictionary;
      FAnnotDict.Add('AP', Obj);
    end;
    if (Obj is TPDFDictionary) then
    begin
      APDict := TPDFDictionary(Obj);
    end;

    if (Assigned(APDict)) then
    begin
      // Look for the /N entry in the /AP dictionary, add it if necessary
      Obj := APDict.FindValueByKeyName('N');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (not (Obj is TPDFStream)) then
      begin
        Obj := FStructure.NewStream('', False);
        Form.OnNewIndObj(Self, ObjNum, GenNum, Obj);
        APDict.Add('N', FStructure.NewIndirectRef(ObjNum, GenNum));
      end;
      if (Obj is TPDFStream) then
      begin
        NStream := TPDFStream(Obj);
      end;
    end;

    if (Assigned(NStream)) then
    begin
      // Look for the /Resources entry in the /N stream, add it if necessary
      Obj := NStream.Dictionary.FindValueByKeyName('Resources');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (not (Obj is TPDFDictionary)) then
      begin
        Obj := FStructure.NewDictionary;
        NStream.Dictionary.Add('Resources', Obj);
      end;
      if (Obj is TPDFDictionary) then
      begin
        ResourcesDict := TPDFDictionary(Obj);
      end;

      // Look for the /Type entry in the /N stream, add it if necessary
      Obj := NStream.Dictionary.FindValueByKeyName('Type');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (not (Obj is TPDFName)) then
      begin
        Obj := FStructure.NewName('XObject');
        NStream.Dictionary.Add('Type', Obj);
      end else
      if (Obj is TPDFName) then
      begin
        TPDFName(Obj).SetTo('XObject');
      end;

      // Look for the /Subtype entry in the /N stream, add it if necessary
      Obj := NStream.Dictionary.FindValueByKeyName('Subtype');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (not (Obj is TPDFName)) then
      begin
        Obj := FStructure.NewName('Form');
        NStream.Dictionary.Add('Subtype', Obj);
      end else
      if (Obj is TPDFName) then
      begin
        TPDFName(Obj).SetTo('Form');
      end;

      // Look for the /BBox entry in the /N stream, add it if necessary
      Obj := NStream.Dictionary.FindValueByKeyName('BBox');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (not (Obj is TPDFArray)) then
      begin
        Obj := FStructure.NewDoubleArray([0, 0, FWidth, FHeight]);
        NStream.Dictionary.Add('BBox', Obj);
      end else
      if (Obj is TPDFArray) then
      begin
        TPDFArray(Obj).Clear;
        TPDFArray(Obj).Add(FStructure.NewNumeric(0));
        TPDFArray(Obj).Add(FStructure.NewNumeric(0));
        TPDFArray(Obj).Add(FStructure.NewNumeric(FWidth));
        TPDFArray(Obj).Add(FStructure.NewNumeric(FHeight));
      end;
    end;

    if (Assigned(ResourcesDict)) then
    begin
      // Look for the /XObject entry in the /Resources dictionary, add it if necessary
      Obj := ResourcesDict.FindValueByKeyName('XObject');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (not (Obj is TPDFDictionary)) then
      begin
        Obj := FStructure.NewDictionary;
        ResourcesDict.Add('XObject', Obj);
      end;
      if (Obj is TPDFDictionary) then
      begin
        XObjectDict := TPDFDictionary(Obj);
      end;
    end;

    if (Assigned(XObjectDict)) then
    begin
      // Add the image to the resource dictionary's XObject list
      ImageName := 'QuickPDFIm' + QPLRandomID;
      XObjectDict.Add(ImageName, ImageRef);
    end;

    if (ImageName <> '') then
    begin
      // Set the /N stream's content
      StreamContent := 'q ' + QPLDoubleToStrConst(FWidth, 4) + ' 0 0 ' +
        QPLDoubleToStr(FHeight, 4) + ' 0 0 cm /' + ImageName + ' Do Q';
      NStream.SetTo(StreamContent, True);
    end;
  end;
end;

function TPDFField.IsPrintable: Boolean;
var
  F: Integer;
  Obj: TPDFObject;
begin
  // Hidden    0   1   0   1   0   1   0   1
  // Print     0   0   1   1   0   0   1   1
  // NoView    0   0   0   0   1   1   1   1
  // Result    0   0   1   0   0   0   1   0
  Result := False;
  Obj := FSourceDict.FindValueByKeyName('F');
  if Obj is TPDFNumeric then
  begin
    F := TPDFNumeric(Obj).AsInteger;
    Result := (F and 38 = 4) or (F and 38 = 36);
  end;
end;

procedure TPDFField.SetPrintable(NewPrintable: Boolean);
begin
  SetVisiblePrintable(IsVisible, NewPrintable);
end;

function TPDFField.GetSubKidIndex(SubIndex: Integer): Integer;
begin
  if not FGotSubNames then GetSubNames;
  if (SubIndex >= 0) and (SubIndex < FSubNames.Count) then
    Result := Integer(FSubNames.Objects[SubIndex])
  else
    Result := 0;
end;

function TPDFField.GetSigValue: TPDFDictionary;
var
  S: AnsiString;
  Obj: TPDFObject;
  SigValue: TPDFDictionary;
begin
  Obj := FSourceDict.FindValueByKeyName('V');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if Obj is TPDFDictionary then
  begin
    SigValue := TPDFDictionary(Obj);
  end else
  begin
    Obj := FStructure.NewDictionary;
    SigValue := TPDFDictionary(Obj);
    SigValue.Add('Type', FStructure.NewName('Sig'));
    SigValue.Add('Filter', FStructure.NewName('Adobe.PPKLite'));
    SigValue.Add('SubFilter', FStructure.NewName('adbe.x509.rsa_sha1'));
    SetLength(S, 512);
    FillChar(S[1], Length(S), '0');
    SigValue.Add('Contents', FStructure.Decode('<' + S + '>'));
    SigValue.Add('ByteRange', FStructure.NewIntArray([999999990, 999999991, 999999992, 999999993]));
    SigValue.Add('Cert', FStructure.NewString(''));
    FSourceDict.Add('V', Form.NewIndObj(Obj));
  end;
  Result := SigValue;
end;

procedure TPDFField.SetVisiblePrintable(NewVisible, NewPrintable: Boolean);
var
  Obj: TPDFObject;
  F: Integer;
  Bit2: Boolean;
  Bit3: Boolean;
  Bit6: Boolean;
begin
  //   View  Print    Flags
  //   No    No       2on   3off  6on
  //   Yes   No       2off  3off  6off
  //   No    Yes      2off  3on   6on
  //   Yes   Yes      2off  3on   6off
  Bit2 := (not NewVisible) and (not NewPrintable);
  Bit3 := NewPrintable;
  Bit6 := (not NewVisible);

  Obj := FSourceDict.FindValueByKeyName('F');
  if Obj is TPDFNumeric then
  begin
    F := TPDFNumeric(Obj).AsInteger;
    if Bit2 then F := F or 2 else if (F and 2 = 2) then F := F - 2;
    if Bit3 then F := F or 4 else if (F and 4 = 4) then F := F - 4;
    if Bit6 then F := F or 32 else if (F and 32 = 32) then F := F - 32;
    TPDFNumeric(Obj).SetTo(F);
  end else
  begin
    F := 0;
    if Bit2 then F := F + 2;
    if Bit3 then F := F + 4;
    if Bit6 then F := F + 32;
    FSourceDict.Add('F', FStructure.NewNumeric(F));
  end;
end;

function TPDFField.GetRotation: Integer;
var
  Obj: TPDFObject;
begin
  Obj := GetMKKey('R');
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger
  else
    Result := 0;
end;

function TPDFField.GetFieldFlags(Bit: Integer): Boolean;
var
  Ff: Integer;
  Obj: TPDFObject;
  Mask: Integer;
begin
  Result := False;
  Mask := 1 shl (Bit - 1);
  Obj := FSourceDict.FindValueByKeyName('Ff');
  if Obj is TPDFNumeric then
  begin
    Ff := TPDFNumeric(Obj).AsInteger;
    Result := (Ff and Mask) = Mask;
  end;
end;

function TPDFField.GetBorderStyle: AnsiString;
var
  Obj: TPDFObject;
  BSDict: TPDFDictionary;
begin
  Result := 'S';
  Obj := FSourceDict.FindValueByKeyName('BS');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if Obj is TPDFDictionary then
  begin
    BSDict := TPDFDictionary(Obj);
    if (BSDict.DictType = '') or (BSDict.DictType = 'Border') then
    begin
      Obj := BSDict.FindValueByKeyName('S');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));      
      if Obj is TPDFName then
        Result := TPDFName(Obj).Name;
    end;
  end;
end;

function TPDFField.GetBorderProperty(BP: TPDFBorderProperty): Double;
var
  Obj: TPDFObject;
  BSDict: TPDFDictionary;
  Style: AnsiString;
begin
  Result := 0;
  Obj := FSourceDict.FindValueByKeyName('BS');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if Obj is TPDFDictionary then
  begin
    Style := 'S';
    BSDict := TPDFDictionary(Obj);
    if (BSDict.DictType = '') or (BSDict.DictType = 'Border') then
    begin
      Obj := BSDict.FindValueByKeyName('S');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));      
      if Obj is TPDFName then
        Style := TPDFName(Obj).Name;
      case BP of
        bpWidth:
        begin
          Obj := BSDict.FindValueByKeyName('W');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));          
          if Obj is TPDFNumeric then
            Result := TPDFNumeric(Obj).AsDouble;
        end;
        bpDashOn:
        begin
          if Style = 'D' then
          begin
            Obj := BSDict.FindValueByKeyName('D');
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));            
            if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 2) then
            begin
              Obj := TPDFArray(Obj).Item[0];
              if Obj is TPDFNumeric then
                Result := TPDFNumeric(Obj).AsDouble;
            end;
          end;
        end;
        bpDashOff:
        begin
          if Style = 'D' then
          begin
            Obj := BSDict.FindValueByKeyName('D');
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));            
            if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 2) then
            begin
              Obj := TPDFArray(Obj).Item[1];
              if Obj is TPDFNumeric then
                Result := TPDFNumeric(Obj).AsDouble;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFField.GetBorderColor(Component: Integer): Double;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Component > 0) then
  begin
    Obj := GetMKKey('BC');
    if (Obj is TPDFArray) and (TPDFArray(Obj).Count >= Component) then
    begin
      Obj := TPDFArray(Obj).Item[Component - 1];
      if Obj is TPDFNumeric then
        Result := TPDFNumeric(Obj).AsDouble;
    end;
  end;
end;

function TPDFField.GetBorderColorType: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  Obj := GetMKKey('BC');
  if (Obj is TPDFArray) then
  begin
    Result := TPDFArray(Obj).Count;
  end;
end;

function TPDFField.GetBackgroundColor(Component: Integer): Double;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Component > 0) then
  begin
    Obj := GetMKKey('BG');
    if (Obj is TPDFArray) and (TPDFArray(Obj).Count >= Component) then
    begin
      Obj := TPDFArray(Obj).Item[Component - 1];
      if Obj is TPDFNumeric then
        Result := TPDFNumeric(Obj).AsDouble;
    end;
  end;
end;

function TPDFField.GetBackgroundColorType: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  Obj := GetMKKey('BG');
  if (Obj is TPDFArray) then
  begin
    Result := TPDFArray(Obj).Count;
  end;
end;

procedure TPDFField.SetBackgroundColor(Gray: Double);
begin
  SetMKKey('BG', FStructure.NewDoubleArray([Gray]));
  FieldChanged;
end;

procedure TPDFField.SetBorderColor(const CSName: AnsiString; Tint: Double);
begin
  SetMKKey('BC', FStructure.NewDoubleArray([Tint]));
  SetMKKey('QuickPDFBCColorSpace', FStructure.NewName(CSName));
  FieldChanged;
end;

procedure TPDFField.SetBackgroundColor(const CSName: AnsiString; Tint: Double);
begin
  SetMKKey('BG', FStructure.NewDoubleArray([Tint]));
  SetMKKey('QuickPDFBGColorSpace', FStructure.NewName(CSName));
  FieldChanged;
end;

procedure TPDFField.SetFontColor(const CSName: AnsiString; Tint: Double);
var
  DA: AnsiString;
  Obj: TPDFObject;
  CC: AnsiString;
const
  CheckChar: AnsiString = '0123456789. ';
begin
  CC := '/' + CSName + ' cs ' + F(Tint) + 'scn';
  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
    DA := TPDFString(Obj).AsString;
  DA := KillColor(DA);
  if (DA <> '') then
  begin
    DA := DA + ' ' + CC;
  end else
  begin
    DA := '/' + Form.GetDefaultFontKey + ' 0 Tf ' + CC;
  end;
  FSourceDict.Add('DA', FStructure.NewString(DA));
  FieldChanged;
end;

function TPDFField.F(D: Double): AnsiString;
begin
  Result := QPLDoubleToStr(D, 3) + ' ';
end;

function TPDFField.KillColor(const Input: AnsiString): AnsiString;
var
  P: Integer;
  PE: Integer;
  PC: Integer;
const
  Valid: AnsiString = '0123456789. ';
begin
  PC := 3;
  P := QPLPos(' rg', Input);
  if P = 0 then
  begin
    P := QPLPos(' k', Input);
    PC := 2;
  end;
  if P = 0 then
  begin
    P := QPLPos(' g', Input);
    PC := 2;
  end;
  if P > 0 then
  begin
    PE := P;
    repeat
      Dec(P);
    until (P = 0) or (QPLPos(Input[P], Valid) = 0);
    Result := QPLCopy(Input, 1, P) + ' ' + QPLCopy(Input, PE + PC + 1, MaxInt);
  end else
    Result := Input;
end;

function TPDFField.GetFontColorSpace: AnsiString;
var
  P: Integer;
  PE: Integer;
  Obj: TPDFObject;
  DA: AnsiString;
begin
  Result := '';
  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
  begin
    DA := TPDFString(Obj).AsString;
    if QPLPos(' rg', DA) > 0 then Result := 'DeviceRGB';
    if QPLPos(' k', DA) > 0 then Result := 'DeviceCMYK';
    if QPLPos(' scn', DA) > 0 then
    begin
      Result := 'Separation:';
      P := QPLPos(' cs', DA);
      PE := P;
      repeat
        Dec(P);
      until (P = 0) or (DA[P] = ' ');
      Result := Result + QPLCopy(DA, P, PE - P);
    end;
    if QPLPos(' g', DA) > 0 then Result := 'DeviceGray';    
  end;
end;

procedure TPDFField.SetBorderColor(C, M, Y, K: Double);
begin
  SetMKKey('BC', FStructure.NewDoubleArray([C, M, Y, K]));
end;

procedure TPDFField.SetFontColor(C, M, Y, K: Double);
var
  DA: AnsiString;
  Obj: TPDFObject;
  CC: AnsiString;
begin
  DA := '';
  CC := F(C) + F(M) + F(Y) + F(K) + 'k';

  Obj := GetInheritableValue(FSourceDict, 'DA');
  if not Assigned(Obj) then
    Obj := Form.FFormDict.FindValueByKeyName('DA');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFString then
    DA := TPDFString(Obj).AsString;
  DA := KillColor(DA);
  if (DA <> '') then
  begin
    DA := DA + ' ' + CC;
  end else
  begin
    DA := '/' + Form.GetDefaultFontKey + ' 0 Tf ' + CC;
  end;
  FSourceDict.Add('DA', FStructure.NewString(DA));
  FieldChanged;
end;

procedure TPDFField.SetBackgroundColor(C, M, Y, K: Double);
begin
  SetMKKey('BG', FStructure.NewDoubleArray([C, M, Y, K]));
  FieldChanged;
end;

function TPDFField.HasParent: Boolean;
begin
  Result := Assigned(Parent);
end;

function TPDFField.GetComb: Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  Obj := GetInheritableValue(FSourceDict, 'Ff');
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger and (1 shl 24) = (1 shl 24);
end;

procedure TPDFField.SetComb(NewComb: Boolean);
var
  Flags: Integer;
begin
  Flags := GetFlags;
  if NewComb then
    Flags := Flags or (1 shl 24)
  else
    Flags := Flags and $7EFFFFFF;
  SetFlags(Flags);
end;

procedure TPDFField.SetStandardFont(StandardFontID: Integer);
var
  DA: AnsiString;
  P: Integer;
  PE: Integer;
  Key: AnsiString;
  Obj: TPDFObject;
  Added: Boolean;
const
  StandardFontNames: array[0..13] of AnsiString = ('Cour', 'CoBo', 'CoBO',
    'CoOb', 'Helv', 'HeBo', 'HeBO', 'HeOb', 'Time', 'TiBo', 'TiIt', 'TiBI',
    'Symb', 'ZaDb');
begin
  DA := '';
  Added := False;
  if (StandardFontID >= 0) and (StandardFontID <= 13) then
    Key := StandardFontNames[StandardFontID]
  else
    Key := 'Helv';
  if Key <> '' then
  begin
    Obj := GetInheritableValue(FSourceDict, 'DA');
    if not Assigned(Obj) then
      Obj := Form.FFormDict.FindValueByKeyName('DA');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFString then
      DA := TPDFString(Obj).AsString;
    P := QPLPos('Tf', DA);
    if P > 0 then
    begin
      repeat
        Dec(P);
      until (P = 0) or (DA[P] <> ' ');
      if (P > 0) then
      begin
        repeat
          Dec(P);
        until (P = 0) or (DA[P] = ' ');
        if (P > 0) then
        begin
          repeat
            Dec(P);
          until (P = 0) or (DA[P] <> ' ');
          if P > 0 then
          begin
            PE := P;

            if (P <> 1) then
            begin
              repeat
                Dec(P);
              until (P = 1) or (DA[P] = ' ');
            end else
            begin
              P := 1;
            end;

            if P = 1 then
            begin
              Delete(DA, 1, PE);
              DA := '/' + Key + DA;
            end else
            begin
              Delete(DA, P + 1, PE - P);
              Insert('/' + Key, DA, P + 1);
            end;
            Added := True;
          end;
        end;
      end;
    end;
    if (DA <> '') and (not Added) then
    begin
      DA := DA + ' /' + Key + ' 0 Tf';;
    end;
    if DA = '' then
    begin
      DA := '/' + Key + ' 0 Tf 0 0 0 rg';
    end;
    FSourceDict.Add('DA', FStructure.NewString(DA));
  end;
  FieldChanged;
end;

function TPDFField.GetDefaultValue: WideString;
begin
  Result := InterpretValue(GetInheritableValue(FSourceDict, 'DV'));
end;

procedure TPDFField.SetCheckStyle(Style: TPDFFormFieldCheckStyle;
  Position: TPDFFormFieldCheckPosition);
var
  Obj: TPDFObject;
  APDict: TPDFDictionary;
  NDict: TPDFDictionary;
  X: Integer;
  StateList: TQuickPDFStringList;
  OffStream: TPDFStream;
  OnStream: TPDFStream;
  OffIndex: Integer;
  OnIndex: Integer;
begin
  Obj := FSourceDict.FindValueByKeyName('AP');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if not (Obj is TPDFDictionary) then
  begin
    Obj := FStructure.NewDictionary;
    FSourceDict.Add('AP', Obj);
  end;
  if Obj is TPDFDictionary then
  begin
    APDict := TPDFDictionary(Obj);
    APDict.DeleteEntryByKeyName('R');
    APDict.DeleteEntryByKeyName('D');
    Obj := APDict.FindValueByKeyName('N');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));    
    if not (Obj is TPDFDictionary) then
    begin
      Obj := FStructure.NewDictionary;
      APDict.Add('N', Obj);
    end;
    if Obj is TPDFDictionary then
    begin
      NDict := TPDFDictionary(Obj);
      StateList := TQuickPDFStringList.Create;
      try
        for X := 0 to NDict.Count - 1 do
          StateList.Add(NDict.Entry[X].Key.Name);
        OffStream := nil;
        OnStream := nil;
        if StateList.Count = 2 then
        begin
          OffIndex := StateList.IndexOf('Off');        
          if OffIndex = 0 then OnIndex := 1 else OnIndex := 0;
          Obj := NDict.Entry[OffIndex].Value;
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFStream then OffStream := TPDFStream(Obj);
          Obj := NDict.Entry[OnIndex].Value;
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFStream then OnStream := TPDFStream(Obj);
        end;
        if (StateList.Count = 1) then
        begin
          if (StateList.IndexOf('Off') <> 0) then
          begin
            // We have an On but no Off
            Obj := NDict.Entry[0].Value;
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
            if Obj is TPDFStream then OnStream := TPDFStream(Obj);
            OffStream := FStructure.NewStream('');
            NDict.Add('Off', Form.NewIndObj(OffStream));
          end else
          begin
            // We have an Off but no On
            Obj := NDict.Entry[0].Value;
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
            if Obj is TPDFStream then OffStream := TPDFStream(Obj);
            OnStream := FStructure.NewStream('');
            NDict.Add('Yes', Form.NewIndObj(OnStream));
          end;
        end;
        if (not Assigned(OnStream)) or (not Assigned(OffStream)) then
        begin
          NDict.Clear;
          OnStream := FStructure.NewStream('');
          NDict.Add('Yes', Form.NewIndObj(OnStream));
          OffStream := FStructure.NewStream('');
          NDict.Add('Off', Form.NewIndObj(OffStream));
        end;
        if Assigned(OnStream) and Assigned(OffStream) then
        begin
          MakeCheckStyle(Style, Position, OnStream, OffStream,
            Width, Height);
        end;
      finally
        StateList.Free;
      end;
    end;
  end;
end;

function TPDFField.AddRadioButtonChild(const StrValue: WideString): Integer;
var
  Obj: TPDFObject;
  KidsArray: TPDFArray;
  ChildDict: TPDFDictionary;
  APDict: TPDFDictionary;
  NDict: TPDFDictionary;
begin
  Result := 0;
  Obj := FSourceDict.FindValueByKeyName('Kids');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if not (Obj is TPDFArray) then
  begin
    Obj := FStructure.NewArray;
    FSourceDict.Add('Kids', Obj);
  end;
  if Obj is TPDFArray then
  begin
    KidsArray := TPDFArray(Obj);
    ChildDict := FStructure.NewDictionary;
    ChildDict.Add('Type', FStructure.NewCommonName('Annot'));
    ChildDict.Add('Subtype', FStructure.NewCommonName('Widget'));
    ChildDict.Add('FT', FStructure.NewCommonName('Btn'));
    ChildDict.Add('F', FStructure.NewNumeric(4));
    ChildDict.Add('Parent', FFieldRef);
    ChildDict.Add('AS', FStructure.NewName('Off'));
    KidsArray.Add(Form.NewIndObj(ChildDict));
    APDict := FStructure.NewDictionary;
    ChildDict.Add('AP', APDict);
    NDict := FStructure.NewDictionary;
    APDict.Add('N', NDict);
    NDict.Add(QPLUTF8Encode(StrValue), Form.NewIndObj(FStructure.NewStream('')));
    NDict.Add('Off', Form.NewIndObj(FStructure.NewStream('')));
    GetSubNames;
    Result := KidsArray.Count;
  end;
end;

procedure TPDFField.MakeCheckStyle(Style: TPDFFormFieldCheckStyle;
  Position: TPDFFormFieldCheckPosition; OnStream, OffStream: TPDFStream;
  AWidth, AHeight: Double);
var
  Painter: TPDFPainter;
  XPos: Double;
  YPos: Double;
  Size, FontScale: Double;
  Font: TPDFFont;
  FontRef: TPDFIndRef;
  CA, S: AnsiString;
  XScale, YScale: Double;
  FontDict, ResourcesDict: TPDFDictionary;
begin

  OffStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
  OffStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
  OffStream.Dictionary.Add('BBox',
    FStructure.Decode('[ 0 0 ' + QPLIntToStr(Round(AWidth)) + ' ' +
    QPLIntToStr(Round(AHeight)) + ' ]'));

  OnStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
  OnStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
  OnStream.Dictionary.Add('BBox',
    FStructure.Decode('[ 0 0 ' + QPLIntToStr(Round(AWidth)) + ' ' +
    QPLIntToStr(Round(AHeight)) + ' ]'));

  OnStream.Dictionary.Add('Resources', FStructure.NewDictionary);
  ResourcesDict := TPDFDictionary(OnStream.Dictionary.FindValueByKeyName
    ('Resources', True));

  ResourcesDict.Add('Font', FStructure.NewDictionary);
  FontDict := TPDFDictionary(ResourcesDict.FindValueByKeyName('Font', True));

  CA := '4';

  if (Style = csNone) then
    CA := 'l';
  if (Style = csCheck) then
    CA := '4';
  if (Style = csCircle) then
    CA := 'l';
  if (Style = csCross) then
    CA := '8';
  if (Style = csDiamond) then
    CA := 'u';
  if (Style = csSquare) then
    CA := 'n';
  if (Style = csStar) then
    CA := 'H';
  if (Style = csXPCheck) then
    CA := 'Q1';
  if (Style = csXPRadio) then
    CA := 'Q2';

  SetMKKey('CA', FStructure.NewString(CA));

  if AWidth > AHeight then Size := AHeight else Size := AWidth;
  case Position of
    cpLeft:
    begin
      XPos := Size / 2;
      YPos := AHeight / 2;
    end;
    cpCenter:
    begin
      XPos := AWidth / 2;
      YPos := AHeight / 2;
    end;
    cpRight:
    begin
      XPos := AWidth - Size / 2;
      YPos := AHeight / 2;
    end;
  else
    XPos := AWidth / 2;
    YPos := AHeight / 2;
  end;
  Painter := TPDFPainter.Create;
  try
    Painter.PDFPrecNum := FStructure.PDFPrecNum;
    if Style in [csCross, csCheck, csDiamond, csSquare, csStar] then
    begin
      AppearanceBox(Painter, Width, Height, FLW, 0, Style);
      OffStream.SetTo('q ' + Painter.Source + ' Q', True);

      if (LW = 0) then LW := 1;
      Painter.SetLineWidth(LW);
      Painter.SetLineCap(2);
      Painter.SetLineColor(0, 0, 0);
      if Style = csCross then
      begin
        Painter.DrawLine(Size / 10 + LW, Size / 10 + LW, Width - Size / 10 - LW,
          Height - Size / 10 - LW);   // draw /
        Painter.DrawLine(Size / 10 + LW, Height - Size / 10 - LW, Width - Size / 10 - LW,
          Size / 10 + LW);            // draw \
      end else
      begin
        FontScale := 1;
        XScale := 1;
        YScale := 1;

        case Style of
          csCheck     : begin S := '4'; FontScale := 0.78; XScale := 0.32; YScale := 0.32; end;
          csDiamond   : begin S := 'u'; FontScale := 0.85; XScale := 0.32; YScale := 0.30; end;
          csSquare    : begin S := 'n'; FontScale := 0.85; XScale := 0.32; YScale := 0.30; end;
          csStar      : begin S := 'H'; FontScale := 0.85; XScale := 0.32; YScale := 0.30; end;

        end;

        SetDingbatsFont;    // Set default font to ZaDb

        // Add ZapfDingbats if it doesn't exist already.
        FontRef := GetFontRef;
        if (FontRef = nil) then
        begin
          FontRef := Form.GetFontRef('ZaDb');
          SetStandardFont(13);
        end;

        FontDict.Add('ZaDb', FontRef);

        Font := TPDFFont.Create(FStructure, GetFontKey);
        try
          Font.PopulateFromIndRef(FontRef);
          Painter.SelectFont(Font, Size  * FontScale);
          Painter.DrawText(XPos - Size * XScale, YPos - Size * YScale, S);
        finally
          Font.Free;
        end;
      end;
      OnStream.SetTo('q ' + Painter.Source + ' Q', True);
    end;
    if Style = csCircle then
    begin
      AppearanceBox(Painter, Width, Height, FLW, 0, Style);

      OffStream.SetTo('q ' + Painter.Source + ' Q', True);
      Painter.SetFillColor(0, 0, 0);
      Painter.Circle(XPos, YPos, Size / 4, True, False);
      OnStream.SetTo('q ' + Painter.Source + ' Q', True);
    end;
    if Style = csXPCheck then
    begin
      if (LW = 0) then LW := 1;
      Painter.SetLineWidth(LW * 0.75);
      Painter.SetLineColor(28 / 255, 81 / 255, 128 / 255);
      Painter.SetFillColor(239 / 255, 239 / 255, 236);
      Painter.Rectangle(XPos - LW * 4.625, YPos + LW * 4.625, LW * 9.25, LW * 9.25, True, True);
      OffStream.SetTo('q ' + Painter.Source + ' Q', True);
      Painter.SetFillColor(33 / 255, 161 / 255, 33 / 255);
      Painter.StartPath(XPos - LW * 0.9, YPos - LW * 0.43);
      Painter.AddLineToPath(XPos + LW * 2.65, YPos + LW * 2.65);
      Painter.AddLineToPath(XPos + LW * 2.65, YPos + LW * 0.4);
      Painter.AddLineToPath(XPos - LW * 0.80, YPos - LW * 2.65);
      Painter.AddLineToPath(XPos - LW * 2.65, YPos - LW * 1.1);
      Painter.AddLineToPath(XPos - LW * 2.65, YPos + LW * 1.1);
      Painter.ClosePath;
      Painter.DrawPath(True, False);
      OnStream.SetTo('q ' + Painter.Source + ' Q', True);
    end;
    if Style = csXPRadio then
    begin
      if (LW = 0) then LW := 1;
      Painter.SetLineWidth(LW * 0.75);
      Painter.SetLineColor(28 / 255, 81 / 255, 128 / 255);
      Painter.SetFillColor(239 / 255, 239 / 255, 236);
      Painter.Circle(XPos, YPos, LW * 4.625, True, True);
      OffStream.SetTo('q ' + Painter.Source + ' Q', True);
      Painter.SetFillColor(33 / 255, 161 / 255, 33 / 255);
      Painter.Circle(XPos, YPos, LW * 2, True, False);
      OnStream.SetTo('q ' + Painter.Source + ' Q', True);
    end;
  finally
    Painter.Free;
  end;
end;

procedure TPDFField.SetOptional(OCGRef: TPDFIndRef);
begin
  FSourceDict.Add('OC', OCGRef);
end;

procedure TPDFField.SetAppearance(AppRef: TPDFIndRef);
begin
  FSourceDict.PurgeKey('AP');
  FSourceDict.Add('AP', AppRef);
end;

procedure TPDFField.AddSubmitAction(const ActionType, Link: AnsiString; Flags:Integer);
var
  Obj: TPDFObject;
  AddActDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  FileSpecDict: TPDFDictionary;
begin
  Obj := FSourceDict.FindValueByKeyName('AA');
  if not (Obj is TPDFDictionary) then
  begin
    AddActDict := FStructure.NewDictionary;
    FSourceDict.Add('AA', AddActDict);
  end else
  begin
    AddActDict := TPDFDictionary(Obj);
  end;

  ActionDict := FStructure.NewDictionary;
  ActionDict.Add('Type', FStructure.NewName('Action'));
  ActionDict.Add('S', FStructure.NewName('SubmitForm'));

  if (Flags <> - 1) then
    ActionDict.Add('Flags', FStructure.NewNumeric(Flags));

  if ActionType = 'U' then
  begin
    FileSpecDict := FStructure.NewDictionary;
    FileSpecDict.Add('F', FStructure.NewString(Link));
    FileSpecDict.Add('FS', FStructure.NewName('URL'));
    //FileSpecDict.Add('Type', FStructure.NewName('FileSpec'));
    //FileSpecDict.Add('UF', FStructure.NewString(Link));

    ActionDict.Add('F', FileSpecDict);
    FSourceDict.Add('A', ActionDict)
  end else
  begin
    AddActDict.Add(ActionType, ActionDict);
  end;
end;

procedure TPDFField.AddChild(ChildField: TPDFField);
var
  Obj: TPDFObject;
  KidsArray: TPDFArray;
begin
  if Assigned(ChildField) then
  begin
    HasKids := True;
    Obj := FSourceDict.FindValueByKeyName('Kids');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));    
    if not (Obj is TPDFArray) then
    begin
      Obj := FStructure.NewArray;
      FSourceDict.Add('Kids', Obj);
    end;
    if Obj is TPDFArray then
    begin
      KidsArray := TPDFArray(Obj);
      KidsArray.Add(ChildField.FieldRef);
    end;
    ChildField.FSourceDict.Add('Parent', FFieldRef);
    ChildField.Parent := Self;
  end;
end;

function TPDFField.AddOpt(const StrValue: WideString): Integer;
var
  Obj: TPDFObject;
  Opt: TPDFArray;
begin
  Result := 0;
  Obj := FSourceDict.FindValueByKeyName('Opt');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if not (Obj is TPDFArray) then
  begin
    Opt := FStructure.NewArray;
    FSourceDict.Add('Opt', Opt);
  end else
    Opt := TPDFArray(Obj);
  Opt.Add(FStructure.NewTextString(StrValue));
  FSourceDict.DeleteEntryByKeyName('DA');
  GetSubNames();
end;

function TPDFField.AddChoiceOpt(const StrValue, DisplayValue: WideString): Integer;
var
  Obj: TPDFObject;
  Opt, Arr: TPDFArray;
begin
  Result := 0;
  Obj := FSourceDict.FindValueByKeyName('Opt');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if not (Obj is TPDFArray) then
  begin
    Opt := FStructure.NewArray;
    FSourceDict.Add('Opt', Opt);
  end else
    Opt := TPDFArray(Obj);

  if (Length(DisplayValue) <> 0) then  // Need to add an array for the two entries.
  begin
    Arr := FStructure.NewArray;
    Arr.Add(FStructure.NewTextString(StrValue));
    Arr.Add(FStructure.NewTextString(DisplayValue));
    Opt.Add(Arr);
  end else
    Opt.Add(FStructure.NewTextString(StrValue));

  FSourceDict.DeleteEntryByKeyName('DA');
  GetSubNames();
end;

function TPDFField.GetAction(const TriggerEvent: AnsiString): TPDFDictionary;
var
  Obj: TPDFObject;
  AADict: TPDFDictionary;
begin
  if (TriggerEvent = '') then
  begin
    // If TriggerEvent is empty use the /A entry which is the older type of simple action
    Obj := FSourceDict.FindValueByKeyName('A');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));    
  end else
  begin
    // If TriggerEvent has a value, first use the /AA entry to find the
    // additional actions dictionary and then look for the specified key
    Obj := FSourceDict.FindValueByKeyName('AA');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));    
    if Obj is TPDFDictionary then
    begin
      // The additional actions dictionary was found
      AADict := TPDFDictionary(Obj);

      // Look for the additional action with the named TriggerEvent
      Obj := AADict.FindValueByKeyName(TriggerEvent);
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));      
    end else
    begin
      Obj := nil;
    end;
  end;
  if Obj is TPDFDictionary then
  begin
    Result := TPDFDictionary(Obj);
  end else
  begin
    Result := nil;
  end;
end;

// Set FAnnotRef, FAnnotDict and FMergedAnnot depending on where the
// field's annotation is stored (merged with the field dictionary or not)
procedure TPDFField.FindFieldAnnot;
var
  Obj: TPDFObject;
  KidRef: TPDFIndRef;
  KidDict: TPDFDictionary;
begin
  FAnnotRef := FFieldRef;
  FAnnotDict := FSourceDict;
  FMergedAnnot := True;
  KidRef := nil;
  Obj := FSourceDict.FindValueByKeyName('Kids');
  if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
  if (Obj is TPDFArray) then
  begin
    if (TPDFArray(Obj).Count = 1) then
    begin
      if (TPDFArray(Obj).Item[0] is TPDFIndRef) then
      begin
        KidRef := TPDFIndRef(TPDFArray(Obj).Item[0]);
      end;
    end;
  end else
  if (Obj is TPDFIndRef) then
  begin
    KidRef := TPDFIndRef(Obj);
  end;
  if (Assigned(KidRef)) then
  begin
    Obj := FindObject(KidRef);
    if (Obj is TPDFDictionary) then
    begin
      KidDict := TPDFDictionary(Obj);
      Obj := KidDict.FindValueByKeyName('Subtype');
      if (Obj is TPDFName) then
      begin
        if (TPDFName(Obj).Name = 'Widget') then
        begin
          FAnnotRef := KidRef;
          FAnnotDict := KidDict;
          FMergedAnnot := False;
        end;
      end;
    end;
  end;
end;

function TPDFField.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

procedure TPDFField.AddResetAction(const ActionType: AnsiString);
var
  Obj: TPDFObject;
  AddActDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
begin
  Obj := FSourceDict.FindValueByKeyName('AA');
  if not (Obj is TPDFDictionary) then
  begin
    AddActDict := FStructure.NewDictionary;
    FSourceDict.Add('AA', AddActDict);
  end else
  begin
    AddActDict := TPDFDictionary(Obj);
  end;

  ActionDict := FStructure.NewDictionary;
  ActionDict.Add('Type', FStructure.NewName('Action'));
  ActionDict.Add('S', FStructure.NewName('ResetForm'));

  AddActDict.Add(ActionType, ActionDict);
end;

function TPDFField.GetRichTextValue(Key: WideString): WideString;
var
  Obj: TPDFObject;
begin

  Result := '';
  if (Key = 'RV') or (Key = 'DS') then
  begin
    Obj := FSourceDict.FindValueByKeyName(AnsiString(Key));
    if (Obj is TPDFString) then
      Result := TPDFString(Obj).AsTextString
    else if (Obj is TPDFStream) and (Key = 'RV') then
      Result := TPDFStream(Obj).GetDecodedTextStream;
  end;
end;

function TPDFField.SetRichTextValue(Key, NewValue: WideString): Integer;
var
  Obj: TPDFObject;
begin

  Result := 0;
  if (Key = 'RV') or (Key = 'DS') then
  begin
    Obj := FSourceDict.FindValueByKeyName(AnsiString(Key));

    if (not Assigned(Obj)) then
      FSourceDict.Add(AnsiString(Key), FStructure.NewTextString(NewValue))
    else if (Obj is TPDFString) then
      TPDFString(Obj).SetToTextString(NewValue)
    else if (Obj is TPDFStream) and (Key = 'RV') then
      TPDFStream(Obj).SetToTextString(NewValue, True);
  end;
end;

function TPDFField.DeleteParentKey: Boolean;
begin
  FSourceDict.DeleteEntryByKeyName('Parent');
  Result := True;
end;

function TPDFField.DeleteSubName(Name: WideString): Integer;
var
  Obj: TPDFObject;
  K: Integer;
  Kids: TPDFArray;
  S: AnsiString;
  WS: WideString;
begin
  FSubNames.Clear;
  FGotSubNames := False;
  Result := 0;

  if FieldType = ftChoice then
  begin
    Obj := FSourceDict.FindValueByKeyName('Opt');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFArray then
    begin
      Kids := TPDFArray(Obj);
      for K := Kids.Count - 1 downto 0 do
      begin
        Obj := Kids.Item[K];
        if Obj is TPDFIndRef then
          Obj := FindObject(TPDFIndRef(Obj));
        S := Obj.Output;
        if Obj is TPDFArray then
          Obj := TPDFArray(Obj).Item[0];
        if Obj is TPDFString then
        begin
          WS := TPDFString(Obj).AsTextString;
          if (WS = Name) then
          begin
            Kids.Delete(K);
            Result := 1;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFField.GetSubmitActionString(const ActionType: WideString): WideString;
var
  Obj: TPDFObject;
  ActionDict: TPDFDictionary;
  FileSpecDict: TPDFDictionary;
begin

  Result := '';
  Obj := FSourceDict.FindValueByKeyName('A', True);
  if Obj is TPDFDictionary then
  begin
    ActionDict := TPDFDictionary(Obj);
    if ActionType = 'U' then
    begin
      Obj := ActionDict.FindValueByKeyName('F', True);
      if Obj is TPDFDictionary then
      begin
        FileSpecDict := TPDFDictionary(Obj);
        Obj := FileSpecDict.FindValueByKeyName('F', true);

        if (Obj is TPDFString) then
          Result := WideString(TPDFString(Obj).AsTextString);
      end;
    end
  end;
end;

end.
