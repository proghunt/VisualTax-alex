unit vtCashedData;

interface

uses
  System.SysUtils, System.Generics.Collections;

type
  TCashedReturns = class;

  TCashedField = class(TObject)
  private
    FFieldNo: Integer;
    FKind: string;
    FValue: string;
    procedure SetKind(const Value: string);
    procedure SetFieldNo(const Value: Integer);
    procedure SetValue(const Value: string);
  public
    constructor Create(const AFieldNo: Integer; const AKind, AValue: String);
    property FieldNo: Integer read FFieldNo write SetFieldNo;
    property Kind: string read FKind write SetKind;
    property Value: string read FValue write SetValue;
  end;

  TCashedForm = class(TObjectList<TCashedField>)
  private
    FFormName: string;
    procedure SetFormName(const Value: string);
  public
    function AddCashedField(const AFieldNo: Integer; const AKind, AValue: String): TCashedField;
    function GetCashedFieldByFieldNo(const AFieldNo: Integer; const AKind: String): TCashedField;
    function GetValue(const AFieldNo: Integer; const AKinds: array of String): string;
    property FormName: string read FFormName write SetFormName;
  end;

  TCashedReturn = class(TObjectList<TCashedForm>)
  private
    FFileName: string;
    procedure SetFileName(const Value: string);
  public
    function AddCashedForm(const AFormName: string): TCashedForm;
    function GetCashedFormByFormName(const AFormName: string): TCashedForm;
    function GetValue(const AFormName: String; AKinds: array of string;
      const AFieldNo: Integer): string;
    property FileName: string read FFileName write SetFileName;
  end;

  TCashedReturns = class(TObjectList<TCashedReturn>)
  private
  public
    function AddCashedReturn(const AFileName: String): TCashedReturn;
    function ReturnByFileName(const AFileName: String): TCashedReturn;
    function GetValue(const AFileName, AFormName: string;
      AKinds: array of String; const AFieldNo: Integer): string;
  end;

implementation

{ TCashedField }

constructor TCashedField.Create(const AFieldNo: Integer; const AKind,
  AValue: String);
begin
  inherited Create;
  FFieldNo := AFieldNo;
  FKind := AKind;
  FValue := AValue;
end;

procedure TCashedField.SetKind(const Value: string);
begin
  FKind := Value;
end;

procedure TCashedField.SetFieldNo(const Value: Integer);
begin
  FFieldNo := Value;
end;

procedure TCashedField.SetValue(const Value: string);
begin
  FValue := Value;
end;

{ TCashedForm }

function TCashedForm.AddCashedField(const AFieldNo: Integer; const AKind,
  AValue: String): TCashedField;
begin
  Result := TCashedField.Create(AFieldNo, AKind, AValue);
  Self.Add(Result);
end;

function TCashedForm.GetCashedFieldByFieldNo(
  const AFieldNo: Integer; const AKind: String): TCashedField;
var
  F: TCashedField;
begin
  for F in Self do
    if (F.FieldNo = AFieldNo) AND
       SameText(F.Kind, AKind) then
      Exit(F);
  Result := nil;
end;

function TCashedForm.GetValue(const AFieldNo: Integer; const AKinds: array of String): string;
var
  F: TCashedField;
  I: Integer;
begin
  for I := Low(AKinds) to High(AKinds) do
  begin
    F := GetCashedFieldByFieldNo(AFieldNo, AKinds[I]);
    if Assigned(F) then
      Exit(F.Value);
  end;
  Result := '';
end;

procedure TCashedForm.SetFormName(const Value: string);
begin
  FFormName := Value;
end;

{ TCashedReturn }

function TCashedReturn.AddCashedForm(const AFormName: string): TCashedForm;
begin
  Result := TCashedForm.Create;
  Result.FormName := AFormName;
  Self.Add(Result);
end;

function TCashedReturn.GetCashedFormByFormName(const AFormName: string): TCashedForm;
var
  F: TCashedForm;
begin
  for F in Self do
    if SameText(F.FormName, AFormName) then
      Exit(F);
  Result := nil;
end;

function TCashedReturn.GetValue(const AFormName: String; AKinds: array of string;
  const AFieldNo: Integer): string;
var
  F: TCashedForm;
begin
  F := GetCashedFormByFormName(AFormName);
  if not Assigned(F) then
    Exit('');
  Result := F.GetValue(AFieldNo, AKinds);
end;

procedure TCashedReturn.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

{ TCashedReturns }

function TCashedReturns.AddCashedReturn(const AFileName: String): TCashedReturn;
begin
  Result := TCashedReturn.Create;
  Result.FileName := AFilename;
  Self.Add(Result);
end;

function TCashedReturns.GetValue(const AFileName, AFormName: string;
  AKinds: array of String; const AFieldNo: Integer): string;
var
  R: TCashedReturn;
begin
  R := ReturnByFileName(AFileName);
  if not Assigned(R) then
    Exit('');
  Result := R.GetValue(AFormName, AKinds, AFieldNo);
end;

function TCashedReturns.ReturnByFileName(
  const AFileName: String): TCashedReturn;
var
  R: TCashedReturn;
begin
  for R in Self do
    if SameText(R.FileName, AFileName) then
      Exit(R);
  Result := nil;
end;

end.
