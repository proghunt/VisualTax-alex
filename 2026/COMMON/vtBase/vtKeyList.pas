unit vtKeyList;

interface

type
  TArrInteger = array of integer;
  TSubKeyID = (sk1, sk2, sk3, sk4, sk5, sk6, sk7, sk8, sk9,
    sk10, sk11, sk12, sk13, sk14, sk15, sk16);
  KeyItem = record
    ID: TSubKeyID;
    AppID: string;
    ShortName: string;
    FormList: array of string;
  end;

var
  KeyList: array of KeyItem;

function ArrToString(aArr: array of string): string;

implementation

function IfThen(AValue: Boolean; const ATrue: string;
  AFalse: string = ''): string;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function ArrToString(aArr: array of string): string;
var
  i: Integer;
begin
  Result := '';
  for I := 0 to Length(aArr) - 1 do
    Result := Result + ifthen(Result = '', '', ';') + aArr[i];
end;


procedure AddKeyItem(aID: TSubKeyID; aAppID: string; aShortName: string; aFormList: array of string);
var
  i: integer;
begin
  SetLength(KeyList, Length(KeyList) + 1);
  KeyList[Length(KeyList) - 1].Id := aID;
  KeyList[Length(KeyList) - 1].AppID := aAppID;
  KeyList[Length(KeyList) - 1].ShortName := aShortName;
  SetLength(KeyList[Length(KeyList) - 1].FormList, Length(aFormList));
  for I := 0 to Length(aFormList) - 1 do
    KeyList[Length(KeyList) - 1].FormList[i] := aFormList[i];
end;

initialization
  AddKeyItem(sk1, 'T4T5', 'T4 Slips', ['T4']);
  AddKeyItem(sk2, 'T4T5', 'T4A Slips', ['T4A']);
  AddKeyItem(sk3, 'T4T5', 'T5 Slips', ['T5']);
  AddKeyItem(sk1, 'TF', 'CH', ['T3010']);
  AddKeyItem(sk2, 'TF', 'PA', ['T5013']);
  AddKeyItem(sk3, 'TF', 'CP', ['T5018']);
  AddKeyItem(sk4, 'TF', 'NR', ['NR4']);

end.
