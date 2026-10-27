unit vtLicense;

interface

uses System.Classes, System.SysUtils, System.IOUtils;

const
  LicenseFile = 'LVerf.EX_';
type
  eLicenseLevel = (
    llNone, //not licensed
    llDemo,
    llHome, //~NetFile
    llLimited,
    llLimEfile,
    llStd,
    llPower,
    llMulti,
    //T2 only
    llMultiPower,
    //FP only
    llAgStd, llAgPower, llDealer //llEnterprise?
    , llLimited1Returns, llLimited2Returns, llLimited3Returns, llLimited4Returns, llLimited5Returns, //20170502 Igor  //20170627
    llLimitedForms //20171012 Igor
    );
  sLicenseLevel = set of eLicenseLevel;
const
  llNetFile = llHome;
  anyLimited: sLicenseLevel = [llLimited, llLimEFile,
    llLimited1Returns, llLimited2Returns, llLimited3Returns, llLimited4Returns, llLimited5Returns];//20170802 Igor
  anyMulti: sLicenseLevel = [llMulti, llMultiPower];
  //anyPower = [llPower, llAgPower]; //???
type
  eLicenseCapabilities = (
    //required by the IDE
    lcLimited, //limited version --> not lcMultiData, limited returns
    lcMultiData, //multiple Data directories
    lcMultiDrive, //more than ABCD: ?
    lcSuperAudit, //= lcSuperVerification?
    lcEFile, //EFile, applies not to Limited, but Limited EFile
    //others
    lcLetter //client letters (Demo, Power, Multi)
    );
  sLicenseCapabilities = set of eLicenseCapabilities;

  RPgmLicenseData = record
  //20170502 igor >>>
  private
    function GetLimitReturns: Integer;
  public
  //20170502 Igor <<<
    Name, Id: string;
    Factor: byte; //Factor2 provided by ???
    Level: eLicenseLevel;
    Caps: sLicenseCapabilities;
    Caption: string; //Caption defaults to Name if empty
    property LimitReturns: Integer read GetLimitReturns; //20170502 Igor
  end;
  PPgmLicenseData = ^RPgmLicenseData;

  function GetLicenseKeyFromFile(AName: string): string;
  function vtValidateKey(AKey, AppName: string; pgmLicenses: array of RPgmLicenseData; Factor2: integer): boolean;
  function vtMyHashString(const AKey: string; pgmLicenses: array of RPgmLicenseData; Factor2: integer): string;
  function vtMakeHashString(const TheKey: string; Factor, Factor2: Integer): string;
  function vtGetDemoDateExpiration(AKey: String; pgmLicenses: array of RPgmLicenseData): TDateTime;
  function vtValidateApp(Akey, AApp: string): boolean; //20190305 Igor

implementation

function MidStr(const Str: string; StartPos, Size: Integer): string;
begin
  Result := Copy(Str, StartPos, Size);
end;

function LeftStr(const Str: string; Size: Integer): string;
begin
  Result := Copy(Str, 1, Size);
end;

function LTrim(const S: string): string;
var
  i: Integer;
begin
  for i := 1 to Length(s) do
  begin
    if s[i] <> ' ' then
    begin
      result := copy(s, i, length(s));
      exit;
    end;
  end;
  //nothing but spaces
  Result := '';
end;

function RTrim(const S: string): string;
begin
  result := TrimRight(S);
end;

function AllTrim(const Str: string): string;
begin
  Result := LTrim(RTrim(Str));
end {Trim};

function FilledStr(Count: integer; ch: char): string;
{returns a string with Count spaces, or other character}
begin
  { Set a string to all spaces }
  Result := StringOfChar(ch, Count);
end;

function PaddCount(const s: string; maxLength: integer): Integer;
{how many characters to reach to mx length}
begin
  Result := MaxLength - Length(s);
  if Result < 0 then
    result := 0;
end;

function PaddZero(S: string; MaxLength: Integer): string;
begin
  Result := FilledStr(PaddCount(S, MaxLength), '0') + S;
end;

procedure MyXOR(var S: String; const r1, r2, r3: Integer); overload; //20190305 igor
var
  X: Integer;
begin
  X := r1 * 1000 + r2 * 100 + r3 * 10 + r2 + r1 + ((r1 + r2 + r3) mod 5) * 10000;
  S := PaddZero(IntToStr(StrToInt(S) xor X), 5);
end;

procedure MyXOR(var S: String; const r1, r2: Integer); overload; //20190305 igor
var
  X: Integer;
begin
  X := r1 * 10 + r2;
  S := PaddZero(IntToStr(StrToInt(S) xor X), 2);
end;

function vtGetDemoDateExpiration(AKey: String; pgmLicenses: array of RPgmLicenseData): TDateTime;
var
  LicenseRec: PPgmLicenseData;
  A: TArray<String>;
  r1, r2, r3: Integer;
  S: String;
begin
  LicenseRec :=  @pgmLicenses[0];
  while LicenseRec.Level <> llNone do
  begin
    if Copy(AKey, 1, 4) = LicenseRec.Id then
      break; //found it
    inc(LicenseRec); //next record
  end;
  if LicenseRec.Level = llDemo then
  begin
    A := AKey.Split(['-']);
    S := A[1] + Copy(A[2], 1, 1);
    r1 := StrToInt(A[2][2]);
    r2 := StrToInt(A[2][3]);
    r3 := StrToInt(A[2][4]);
    MyXOR(S, r1, r2, r3);
    Result := StrToInt(S);
  end
  else
    Result := Date + 365; //always > date
end;

function Crypt(const s: string): string;
var
  i: integer;
begin
  SetLength(Result, Length(s));
  for i := 1 to Length(s) do
    Result[i] := chr(ord(s[i]) xor $F); //no ctrl chars!
end;

function GetLicenseKeyFromFile(AName: string): string;
var L: TStringList;
    cFile: string;
    I: integer;
begin
  Result := '';
  cFile := TPath.Combine(ExtractFilepath(GetModuleName(HInstance)), LicenseFile);
  if not FileExists(cFile) then Exit;
  L := TStringList.Create;
  try
    L.LoadFromFile(cFile);
    for I := 0 to L.Count - 1 do
      L.Strings[I] := Crypt(L.Strings[I]);
    Result := L.Values[AName];
  finally
    L.Free;
  end;
end;

function vtMyHashString(const AKey: string; pgmLicenses: array of RPgmLicenseData; Factor2: integer): string;
var
  p: PPgmLicenseData;
  id: string;
  f1,f2: integer;
begin
  Result := '';
  if Length(AKey) <> 24 then //20190305 Igor
    exit; //valid key has exactly 19 chars
  id := Copy(AKey, 1, 4); //T10x
  p := @pgmLicenses[0];
  while p.Level > llNone do begin
    if p.Id = id then
      break;
    inc(p);
  end;
  f1 := p.Factor;
  f2 := Factor2;
  {case AKey[1] of
   //20150623
  'T':  f2 := T1F2017; //T1 key  factor2
  'S':  f2 := S1F2017; //S1 key  Scan key
  else
    exit;
  end;}
  Result := vtMakeHashString(AKey, f1, f2);
end;

function vtMakeHashString(const TheKey: string; Factor, Factor2: Integer): string; //20190305 Igor
var
  PgmId, PgmNum, Random1, Random2, Random3: string;
  //Factor,factor2,
  HashNum: Integer;

  function StrToInt(c: char): integer;
  begin
    (* no exceptions on invalid numbers!
    *)
    Result := ord(c) - ord('0');
  end;

begin
  (* Multi-year requires year specific factors
  *)
  PgmNum := MidStr(TheKey, 3, 2);
  Random1 := MidStr(TheKey, 6, 4);
  Random2 := MidStr(TheKey, 11, 4);
  Random3 := MidStr(TheKey, 16, 4);

  PgmId := LeftStr(TheKey, 4);
  //Factor:=GetProductFactor(PgmId); ...
  HashNum := (StrToInt(PgmNum[1]) + StrToInt(PgmNum[2])) * (Factor + Factor2)
    + Factor2
    + (StrToInt(Random1[1]) + StrToInt(Random1[2]) + StrToInt(Random1[3]) + StrToInt(Random1[4])) * Factor
    + (StrToInt(Random2[1]) + StrToInt(Random2[2]) + StrToInt(Random2[3]) + StrToInt(Random2[4])) * Factor +
    + (StrToInt(Random3[1]) + StrToInt(Random3[2]) + StrToInt(Random3[3]) + StrToInt(Random3[4]));
  Result := PaddZero(AllTrim(IntToStr(HashNum)), 4);
end;

function vtValidateKey(AKey, AppName: string; pgmLicenses: array of RPgmLicenseData; Factor2: integer): boolean; //20190305 Igor
begin
  Result := MidStr(AKey,21,4) = vtMyHashString(AKey, pgmLicenses, Factor2);
  If UpperCase(LeftStr(AKey,2)) <> UpperCase(LeftStr(AppName,2)) then result:=False;
end;

function vtValidateApp(AKey, AApp: string): boolean; //20190305 Igor
var A: TArray<string>;
    r1, r2, I: Integer;
    S: String;
    CloudOptions: Integer;
begin
  Result := false;
  A := AKey.Split(['-']);
  if Length(A) < 4 then Exit;
  S := A[3];
  r1 := StrToInt(A[3][3]);
  r2 := StrToInt(A[3][4]);
  S := Copy(S, 1, 2);
  MyXOR(S, r1, r2);
  CloudOptions := StrToInt(S);
  AApp := Copy(AApp, 1, 2);
  if SameText(AApp, 'T1') then
    I := 0
  else if SameText(AApp, 'T2') then
    I := 1
  else if SameText(AApp, 'T3') then
    I := 2
  else if SameText(AApp, 'T4') then
    I := 3
  else if SameText(AApp, 'TF') then
    I := 4
  else if SameText(AApp, 'FP') then
    I := 5
  else
    Exit;
  Result := (CloudOptions and (1 shl I)) <> 0;
end;


{ RPgmLicenseData }

function RPgmLicenseData.GetLimitReturns: Integer;
begin
  Result := MaxInt;
end;

end.
