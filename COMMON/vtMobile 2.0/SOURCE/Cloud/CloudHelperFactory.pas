unit CloudHelperFactory;

interface

uses
  CloudHelperAbstr, System.SysUtils, System.Generics.Collections, System.Classes;

type
  TRegisteredCloudHelper = TDictionary<String, TCloudHelperClass>;
  TCloudHelperFactory = class
    class procedure FillCloudHelpers(AList: TStrings);
    class function GetCloudHelperClass(AClassName: String): TCloudHelperClass;
  end;

  function RegisteredCloudHelper: TRegisteredCloudHelper;

  procedure RegCloudHelper(AName: string; AClass: TCloudHelperClass);
  procedure UnRegCloudHelper(AName: string);
implementation

{ TCloudHelperFactory }

var
  FRegisteredCloudHelper: TRegisteredCloudHelper;

function RegisteredCloudHelper: TRegisteredCloudHelper;
begin
  if FRegisteredCloudHelper = nil then
    FRegisteredCloudHelper := TRegisteredCloudHelper.Create;
  Result := FRegisteredCloudHelper;
end;

procedure RegCloudHelper(AName: string; AClass: TCloudHelperClass);
begin
  with RegisteredCloudHelper do
    if not ContainsKey(AName) then
      Add(AName, AClass);
end;

procedure UnRegCloudHelper(AName: string);
begin
  if FRegisteredCloudHelper = nil then
    Exit;
  FRegisteredCloudHelper.Remove(AName);
end;

class procedure TCloudHelperFactory.FillCloudHelpers(AList: TStrings);
var
  p:TPair<String, TCloudHelperClass>;
begin
  if AList = nil then
    Exit;
  for p in RegisteredCloudHelper do
    AList.Add(p.Key);
end;

class function TCloudHelperFactory.GetCloudHelperClass(
  AClassName: String): TCloudHelperClass;
var
  p:TPair<String, TCloudHelperClass>;
begin
  for p in RegisteredCloudHelper do
    if SameText(AClassName, p.Key) then
      Exit(p.Value);
  if RegisteredCloudHelper.Count > 0 then
    Result := RegisteredCloudHelper.Values.ToArray[0]
  else
    Result := nil;
end;

initialization

finalization
  FreeAndNil(FRegisteredCloudHelper);

end.
