unit vtAuthorization;
(* License management
  Licensing changed to hold all licenses in an common file,
  and all apps (to be installed) in an installation file.
*)

interface

uses
  SysUtils, Classes,
  vtMulti, vtCommon;

//packages
//function LoadApp(const id: string): boolean;//20170927 igor
procedure LoadApps;

procedure GetLoginNames(TempList: TStrings);
procedure SaveLoginNames(TempList: TStrings);

function AppFromKey(const AKey: string): TApp;

function ValidateKey(const AKey: string): Boolean;
//Function  ValidateScanKey(const AKey, ScanId: String):Boolean;

function MakeHashString(const TheKey: string; Factor, Factor2: Integer): string;
procedure UpdateLicenseFile(const AppId, Key: string);
function GetProductName(p: PPgmLicenseData): string;

function HasVtScanLicense(MyApp: TApp): Boolean;

function TimeToCheckUpdates: Boolean;
function GetUpdateFrequency: Integer;
function GetLastUpdCheck: string;
procedure Checkupdates(const AppTitle: string);

{$IFDEF oldLic}
const
  T1StdCaps = [lcMultiData, lcMultiDrive, lcEfile];

  //this is the 2011 version (Factor!)
  PgmLicenses: array[eLicenseData] of RPgmLicenseData = (
    //dummy for invalid license
    (Name: 'Unlicensed'; Id: ''; Factor: 0; Level: llNone; Caps: []),
    //T1
    (Name: 'T1 Demo'; Id: 'T100'; Factor: 12; Level: llDemo;
    Caps: T1StdCaps), // + [lcDemo, lcLetter]),
    (Name: 'T1 NetFile'; Id: 'T101'; Factor: 13; Level: llHome;
    Caps: T1StdCaps + [lcSuperAudit]; //demo???
    Caption: 'Home use - Netfile Version'),
    (Name: 'T1 Limited'; Id: 'T102'; Factor: 14; Level: llLimited;
    Caps: T1StdCaps - [lcMultiData, lcEFile] + [lcSuperAudit]),
    (Name: 'T1 Limited Efile'; Id: 'T103'; Factor: 15; Level: llLimEfile;
    Caps: T1StdCaps + [lcSuperAudit]),
    (Name: 'T1 Standard'; Id: 'T104'; Factor: 16; Level: llStd;
    Caps: T1StdCaps - [lcMultiDrive] + [lcSuperAudit]),
    (Name: 'T1 Power'; Id: 'T105'; Factor: 17; Level: llPower;
    Caps: T1StdCaps + [lcLetter]),
    (Name: 'T1 MultiOffice'; Id: 'T106'; Factor: 18; Level: llMulti;
    Caps: T1StdCaps + [lcLetter]
    ),

    (Name: 'T2 Demo'; Id: 'T200'; Factor: 22; Level: llDemo),
    (Name: 'T2 Limited'; Id: 'T201'; Factor: 23; Level: llLimited),
    (Name: 'T2 Limited With Efile'; Id: 'T203'; Factor: 24; Level: llLimEfile),
    (Name: 'T2 Standard'; Id: 'T204'; Factor: 25; Level: llStd),
    (Name: 'T2 MultiOffice'; Id: 'T205'; Factor: 26; Level: llMulti),
    (Name: 'T2 Power'; Id: 'T206'; Factor: 27; Level: llPower),
    (Name: 'T2 MultiPower'; Id: 'T207'; Factor: 28; Level: llMultiPower),

    (Name: 'TF Demo'; Id: 'TF00'; Factor: 32; Level: llDemo),
    (Name: 'TF Standard'; Id: 'TF01'; Factor: 33; Level: llStd),
    (Name: 'TF Power'; Id: 'TF02'; Factor: 34; Level: llPower),

    (Name: 'T4 Demo'; Id: 'T400'; Factor: 42; Level: llDemo),
    (Name: 'T4 Standard'; Id: 'T401'; Factor: 43; Level: llStd),
    (Name: 'T4 Power'; Id: 'T402'; Factor: 44; Level: llPower),

    (Name: 'FP Demo'; Id: 'FP00'; Factor: 52; Level: llDemo),
    (Name: 'FP Limited'; Id: 'FP01'; Factor: 53; Level: llLimited),
    (Name: 'FP Standard'; Id: 'FP02'; Factor: 54; Level: llStd),
    (Name: 'FP Power'; Id: 'FP03'; Factor: 55; Level: llPower),
    (Name: 'FP AgStandard'; Id: 'FP04'; Factor: 56; Level: llAgStd),
    (Name: 'FP AgPower'; Id: 'FP05'; Factor: 57; Level: llAgPower),
    (Name: 'FP Dealer'; Id: 'FP06'; Factor: 58; Level: llDealer),

    (Name: 'TR Demo'; Id: 'TR00'; Factor: 62; Level: llDemo),
    (Name: 'TR Standard'; Id: 'TR01'; Factor: 63; Level: llStd),
    (Name: 'TR Power'; Id: 'TR02'; Factor: 64; Level: llPower),

    (Name: 'S1 Standard'; Id: 'S101'; Factor: 73; Level: llStd),
    (Name: 'S2 Standard'; Id: 'S201'; Factor: 74; Level: llStd)
    );
{$ELSE}
//moved into apps
//scan licenses???
const
  StdLicenses: array[0..2] of RPgmLicenseData = (
    //dummy for invalid license
    (Name: 'Unlicensed'; Id: ''; Factor: 0; Level: llNone; Caps: []),
    //scan licenses
    (Name: 'S1 Standard'; Id: 'S101'; Factor: 73; Level: llStd),
    (Name: 'S2 Standard'; Id: 'S201'; Factor: 74; Level: llStd)
    );
{$ENDIF}

implementation

uses
  //vtCommon,
  {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON}, Forms, Controls, Windows, ShellApi,//20170811 Igor
  vtTrimStr, vtDialogs, fPopList, //fAskForKey,
  fAskForScanKey,
  vtShared,
  fVTnoSplash;// 20151108 Igor

const
  LoginNames = 'LoginNames';
//20170927 igor>>>
{
function LoadApp(const id: string): boolean;
//function  LoadApp(id: eAppId): boolean;
var
  FName, PkgName: string;
  MyApp: TApp;
begin
  Result := False;
  FName := ExeDir; // + '\' + AppDirs[id];
  //if not DirectoryExists(FName) then exit;

(* license check requires app! done in constructor
  lic := ReadPgmFileLine(FName + '\' + ActivationFile, 0, False);
  If ValidateKey(lic) = false then
  begin
    if AskForKey(AppDirs[id]) = '' then exit; //exits pgm already
  end;
*)
//check for debug version (static package)
  MyApp := AppList.AppFromID(id);
  //if AppList.Apps['T1', '2011'] = nil then begin
  if MyApp = nil then
  begin
    //only try install available packages
    PkgName := FName + '\' + StringReplace(id, '-', '_', []) + 'pkg.bpl';
    if not FileExists(PkgName) then
      exit;
    ErrorMsg('Loading package ' + PkgName); // <----------- using packages?
    LoadPackage(PkgName); //registers itself
    MyApp := AppList.AppFromID(id);
    Result := MyApp <> nil; // True if just loaded
  end;

  //checks based on options
  if MyApp = nil then
    exit; //not loaded

  //  ShowMessage('Loggin in');
  MyApp.GetLicenseLevel;
end;
}

procedure LoadApps;
var
  i: integer;
begin
  for i := vtnosplash.TabControl1.Tabs.Count - 1 downto 1 do //!not downto 0!
    if not Assigned (AppList.AppFromID(vtnosplash.TabControl1.Tabs[i])) then
      vtnosplash.TabControl1.Tabs.Delete(i);
  if vtnosplash.TabControl1.Tabs.Count > 0 then
    vtnosplash.TabControl1.Tabs[0] := 'Prior Years'
  else
    vtnosplash.TabControl1.Tabs.Insert(0, 'Prior Years');
end;
//20170927 igor<<<

function GetApp(const AppId: string): TApp;
var
  AppName: string;
begin
  //guess the App
  AppName := Copy(AppId, 1, pos('-', AppID) - 1);//20170731 Igor
  Result := AppList.AppFromName(AppName);
end;

function AppDir(TheApp: TApp): string;
begin
  Result := TheApp.AppDir;
end;

procedure UpdateLicenseFile(const AppId, Key: string);
var
  fn: string;
begin
  (* Update the common license file with Key for AppId.
    Keep list in memory?
  *)
  fn := ExeDir + '\' + LicenseFile;
  LicenseList.Values[AppId] := Key;
  LicenseList.Values['Licensee'] := Licensee;
  LicenseList.SaveToFile(fn);
end;

function GetProductName(p: PPgmLicenseData): string;
begin
  Result := 'Unlicensed';
  if p = nil then
    exit;
  if p.Caption <> '' then
    Result := p.Caption
  else
    Result := p.Name;
end;

function MakeHashString(const TheKey: string; Factor, Factor2: Integer): string;
var
  PgmId, PgmNum, Random1, Random2: string;
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

  PgmId := LeftStr(TheKey, 4);
  //Factor:=GetProductFactor(PgmId); ...

{$IFDEF old}
  // 11-12
  if LeftStr(PgmId, 2) = 'T1' then
    Factor2 := 13
  else if LeftStr(PgmId, 2) = 'T2' then
    Factor2 := 14
  else if LeftStr(PgmId, 2) = 'TF' then
    Factor2 := 15
  else if LeftStr(PgmId, 2) = 'T4' then
    Factor2 := 16
  else if LeftStr(PgmId, 2) = 'FP' then
    Factor2 := 17
  else if LeftStr(PgmId, 2) = 'TR' then
    Factor2 := 18
  else if LeftStr(PgmId, 2) = 'S1' then
    Factor2 := 19
  else if LeftStr(PgmId, 2) = 'S2' then
    Factor2 := 20
  else
    Factor2 := -1; //???

  (*
  // 2010/11
  If      LeftStr(PgmId,2)='T1' then Factor2:=12
  else If LeftStr(PgmId,2)='T2' then Factor2:=13
  else If LeftStr(PgmId,2)='TF' then Factor2:=14
  else If LeftStr(PgmId,2)='T4' then Factor2:=15
  else If LeftStr(PgmId,2)='FP' then Factor2:=16
  else If LeftStr(PgmId,2)='TR' then Factor2:=17
  else If LeftStr(PgmId,2)='S1' then Factor2:=18
  else If LeftStr(PgmId,2)='S2' then Factor2:=19;
 *)
{$ELSE}
  //factors must be provided by caller!
{$ENDIF}
  HashNum := (StrToInt(PgmNum[1]) + StrToInt(PgmNum[2])) * (Factor + Factor2)
    + Factor2
    + (StrToInt(Random1[1]) + StrToInt(Random1[2])
    + StrToInt(Random1[3]) + StrToInt(Random1[4])) * Factor
    + (StrToInt(Random2[1]) + StrToInt(Random2[2])
    + StrToInt(Random2[3]) + StrToInt(Random2[4])) * Factor;
  Result := PaddZero(AllTrim(IntToStr(HashNum)), 4);
end;

{$IFDEF unused}

function GetAuthorizationKey(const AppId: string): string;
// Const ActivationFile = 'LVerf.EX_'; //20120128
var
  MyApp: TApp;
begin
  Result := 'N/A'; {default to no key}
  MyApp := AppList.GetApp(LeftStr(AppId, 2));
  Result := ReadAppFileLine(ActivationFile, 0, MyApp);
  //check for invalidated licenses
  if (UpperCase(LeftStr(Result, 19)) = 'T105-5555-4600-0714')
    {//or (UpperCase(LeftStr(Optrec.Prp_Name,6))='CORDEV')} then
    Application.Terminate;
end;

function GetScanAuthorizationKey(const AppDir: string): string;
var
  SomeString: TstringList;
begin
  Result := 'N/A'; {default to no key}
  SomeString := TstringList.Create;
  if FileExists(AppDir + '\' + ScanActivationFile) then
  begin
    SomeString.LoadFromFile(AppDir + '\' + ScanActivationFile);
    Result := SomeString[0];
  end;
  SomeString.Free;
end;
{$ELSE}
//in TApp
{$ENDIF}

function AppFromKey(const AKey: string): TApp;
var
//20170731 Igor>>>
//  AppName: string;
  I: Integer;
begin
  for I := 0 to AppList.Count - 1 do
    if SameText(AKey, AppList.GetApp(I).LicenseKeyPrefix) then
      Exit(AppList.GetApp(I));
  Result := nil;
//  AppName := Copy(AKey, 1, 2);
//  Result := AppList.AppFromName(AppName);
//20170731 Igor<<<
end;

function ValidateKey(const AKey: string): boolean;
var
  MyApp: TApp;
begin
  //guess the App
  MyApp := AppFromKey(AKey);
  if MyApp <> nil then
    Result := MyApp.ValidateKey(AKey)
  else
    Result := False;
end;

{$IFDEF old}

function ValidateScanKey(const AKey, ScanId: string): boolean;
begin
  Result := False;
  if length(Akey) <> 19 then
    Exit;
  if MidStr(AKey, 16, 4) = MakeHashString(AKey) then
    result := True;
  //If UpperCase(LeftStr(AKey,2)) <> 'S1' then
  if UpperCase(LeftStr(AKey, 2)) <> ScanId then
    result := False; {T1 key goes with T1, etc}
end;
{$ELSE}
//use AppId.ValidateScanKey
{$ENDIF}

function HasVtScanLicense(MyApp: TApp): Boolean;
begin
  Result := MyApp.ScanLicenseLevel > llNone;
end;

//moved into MainOptions

function GetLastUpdCheck: string;
begin
  result := MainOptions.LastUpdateCheck; // ReadAppFileLine('LastUpdCheck.txt');
end;

procedure Checkupdates(const AppTitle: string);
//Var  h:THandle;
begin
  { TODO -oCon : multi-app updates how? }
  ErrorMsg('Make update checks multi-app');
  (*
    Screen.Cursor :=crHourGlass;

    spaceDelimiter := ' ';
    quotes := '"';
    params := spaceDelimiter+quotes+MyApp.AppID+quotes
    +spaceDelimiter+quotes+MyApp.AppUpdateDate+quotes
    +spaceDelimiter+quotes+MyApp.AppRelease+quotes
    +spaceDelimiter+quotes+'c:\Downloads'+quotes
    +spaceDelimiter+quotes+MyApp.AppDir+quotes
    +spaceDelimiter+quotes+'http://www.visualtax.com/downloads/vtUpdate/vtVersions.xml'+quotes;

    h := ShellExecute(Application.MainForm.Handle,
      'open','VTChkUpd.Exe',Pchar(' '+params),Nil,Sw_Show);

    If H<=32 then
    begin
      ErrorMsg('The Updater program cannot run.'
      +Chr(13)+'Error Code:  '+IntToStr(H));
     // +Chr(13)+'and unzipped into the program folder?');
    end else
    //now save the date
      ReadPgmFileLine('LastUpdCheck.txt', FormatDateTime('yyyy-mm-dd',Date));
    Screen.Cursor :=crDefault;
  *)
end;

function TimeToCheckUpdates: Boolean;
var
  DaysFreq: Integer;
  LastUpdateDone: string;
  D2, D1: TDate; // string;
begin
  LastUpdateDone := GetLastUpdCheck;
  if LastUpdateDone = '' then
  begin Result := True;
    Exit;
  end;
  //there is previous update
  //Result:=False;
  DaysFreq := GetUpdateFrequency;
  if DaysFreq = 0 then
  begin Result := False;
    exit;
  end;
  D2 := date; // FormatDateTime('yyyy/mm/dd',Date);
  D1 := StrToDate(LastUpdateDone); // ReplaceChar(LastUpdateDone,'-','/');
  //If DateDiff(D1,D2) > DaysFreq then result:=True;
  Result := (D2 - D1) > DaysFreq;
end;

function GetUpdateFrequency: Integer;
begin
  Result := MainOptions.UpdateFrequency;
end;

procedure GetLoginNames(TempList: TStrings);
begin
  ReadPgmFile(LoginNames, TempList);
end;

procedure SaveLoginNames(TempList: TStrings);
begin
  WritePgmFile(LoginNames, TempList);
end;

end.
