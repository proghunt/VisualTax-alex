unit TR_2026Authorization;

interface

uses
  SysUtils, Messages, Classes, Controls, Forms, Dialogs, IOUtils,
  TR_2026, TR_2026Utils, TR_2026Declare;

function ValidateKey(AKey: string): Boolean;
function GetLicenseLevelByKey(AKey: String): RPgmLicenseData;
procedure SetKey(AKey: String);

function MakeHashString(TheKey: string; Factor, Factor2: Integer): string;

implementation

uses
  StrUtils;

function GetLicenseLevelByKey(AKey: String): RPgmLicenseData;
var
  P: RPgmLicenseData;
  A: TArray<String>;
begin
  A := AKey.Split(['-']);
  for P in PgmLicenses do
    if P.Id = A[0] then
      Exit(P);
  Result := PgmLicenses[length(PgmLicenses) - 1];
end;

function ValidateKey(AKey: string): Boolean;
var
  A: TArray<String>;
  P: RPgmLicenseData;
begin
  A := AKey.Split(['-']);
  if (Length(A) <> 4) or (Length(A[0]) <> 4) or (Length(A[1]) <> 4) or
     (Length(A[2]) <> 4) or (Length(A[3]) <> 4) then
    exit(False);
  P := GetLicenseLevelByKey(AKey);
  if P.Level <> llNone then
    Result := SameStr(A[3], MakeHashString(AKey, P.Factor, TRF2_2023)) //20210103 Igor
  else
    Result := False;
end;

procedure SetKey(AKey: String);
var
  SL: TStringList;
  S: String;
begin
  SL := TStringList.Create;
  try
    if TFile.Exists(TPath.Combine(AppDir, ActivationFile)) then
      SL.LoadFromFile(TPath.Combine(AppDir, ActivationFile));
    for S in SL do
      if Crypt(S) = AKey then
        exit;
    SL.Add(Crypt(AKey));
    Sl.SaveToFile(TPath.Combine(AppDir, ActivationFile));
  finally
    SL.Free;
  end;
end;

function MakeHashString(TheKey: string; Factor, Factor2: Integer): string;
var
  PgmNum, Random1, Random2: string;
  HashNum: Integer;
begin
  PgmNum := MidStr(TheKey, 3, 2);
  Random1 := MidStr(TheKey, 6, 4);
  Random2 := MidStr(TheKey, 11, 4);

  try
    HashNum := (StrToInt(PgmNum[1]) + StrToInt(PgmNum[2])) * (Factor + Factor2)
        + Factor2
        + (StrToInt(Random1[1]) + StrToInt(Random1[2])
        + StrToInt(Random1[3]) + StrToInt(Random1[4])) * Factor
        + (StrToInt(Random2[1]) + StrToInt(Random2[2])
        + StrToInt(Random2[3]) + StrToInt(Random2[4])) * Factor;
    Result := PaddZero(Trim(IntToStr(HashNum)), 4);
  except
    result := '';
  end;
end;

end.

