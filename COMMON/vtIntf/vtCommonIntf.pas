unit vtCommonIntf;

interface

uses db, system.Classes, System.SysUtils, System.Generics.Collections,
  vcl.Forms, vtLicense, System.IOUtils, Windows; //20180113 Igor //20190228 Igor

type

  THelperAction = (haSaveToCloud, haLoadFromCloud, haViewList); //20180113 Igor
  THelperAnswer = (haOk, haBreak, haContinue, haRetry);
  THelperMessageType = (hmtInfo, hmtError, hmtConfirm);

  THelperDialog = procedure(Sender: TObject; AMessageType: THelperMessageType;
    const AMessage: string; var AAnswer: THelperAnswer) of Object;
  THelperIOError = procedure(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer) of Object;
  THelperLog = procedure(Sender: TObject; const AEvent: String) of Object;

  TCallBackHelperLog = procedure(Sender: TObject; const AEvent: String);
  TCallBackHelperDialog = procedure(Sender: TObject; AMessageType: THelperMessageType;
    const AMessage: string; var AAnswer: THelperAnswer);
  TCallBackHelperIOError = procedure(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
  TCallbackReturnStringResult = procedure (const AString: String);

  TFillDBStartRec = record
    BasePath: string;
    SourceClientDataBase: string;
    SourceClientTable: string;
    SourceClientDataBasePassword: string;
    VisualTaxUserId: string;
    vtTaxModulePath: string;
    ClientDir: string;
    vtAppId: string;
  end;

  TCloudFile = class
  private
    FPath: string;
    FFullPath: string;
    FIsDir: Boolean;
    FSize: Integer;
    FServerModified: TDateTime;
    FUrl: string;
  public
    constructor Create(APath, AFullPath: string; AIsDir: Boolean; ASize: Integer; AServerModified: TDateTime; AUrl: string = '');
    property Path: string read FPath write FPath;
    property FullPath: string read FFullPath write FFullPath;
    property IsDir: Boolean read FIsDir write FIsDir;
    property Size: Integer read FSize write FSize;
    property ServerModified: TDateTime read FServerModified write FServerModified;
    property Url: string read FUrl write FUrl;
  end;
  TCloudFileList = class(TObjectList<TCloudFile>)
  public
    function GetFileByPath(APath: String): TCloudFile;
    procedure AddFile(APath, AFullPath: string; AIsDir: Boolean; ASize: Integer; AServerModified: TDateTime; AUrl: string = '');
  end;

  ICloudHelper = interface
    ['{72878381-4905-493A-8F89-83EC7C82C7FB}']
    procedure SetLocalFile(const AValue: String);
    procedure SetCloudFile(const AValue: string);
    procedure SetCloudPath(const AValue: string);
    procedure SetDropBoxClientId(const AValue: String);
    procedure SetToken(const AValue: String);
    function GetToken: string;
    function Send: boolean; overload;
    function Send(const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken: String): boolean; overload;
    function Get: boolean; overload;
    function Get(const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken: String): boolean; overload;
    //20190522 Igor >>>
    function DeleteCloudFile: boolean; overload;
    function DeleteCloudFile(const ACloudPath, ACloudFile, ADropBoxClientId, AToken: String): boolean; overload;
    //20190522 Igor <<<
    function GetShared: boolean; overload;
    function GetShared(const ALocalFile, AUrlFile, ADropBoxClientId, AToken: String): boolean; overload;
    function List: PChar; overload; //20161219 Igor
    function List(const ACloudPath, ADropBoxClientId, AToken: String): PChar; overload;//20161219 Igor
    function ListReceived: PChar; overload;
    function ListReceived(ADropBoxClientId, AToken: String): PChar; overload;
    function SetShare: boolean; overload;
    function SetShare(const AEmail, ACloudPath, ACloudFile, ADropBoxClientId, AToken: String): boolean; overload;
    //20180113 Igor >>>
    function HasLicenseKey: boolean;
    function GetLicenseKey: string;
    function GetLicenseKeyPrefix: string;
    function GetLicenses: PPgmLicenseData;
    function ValidateKey(AKey: string; AYear: integer): boolean; //20190307 Igor
    procedure SetLicense(AKey: string);
    function GetLicenseData(AKey: string): PPgmLicenseData;
    function GetLicenseDemoDate(AKey: string): TDateTime;
    function AllowExecuteOperation(AHelperAction: THelperAction): boolean;
    //20180113 Igor <<<
    //20190305 Igor >>>
    function ValidateApp(AAppName: string): boolean;
    function GetAllowedApps(AKey: string): string;
    //20190305 Igor <<<
    function GetLastError: string; //20200224 Igor
  end;

  TCloudHelper = class(TInterfacedObject, ICloudHelper)
  protected
    FEmail: string;
    FLocalFile: string;
    FUrlFile: string;
    FLocalFolder: string;
    FCloudFile: string;
    FCloudPath: string;
    FDropBoxClientId: string;
    FToken: string;
    Fl_server_modified: TDateTime; // âðåìÿ ïîäèôèêàöèè ôàéëà èç ìåòà äàòû
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetEmail(const AValue: string);
    procedure SetLocalFile(const AValue: String);
    procedure SetUrlFile(const AValue: String);
    procedure SetCloudFile(const AValue: string);
    procedure SetCloudPath(const AValue: string);
    procedure SetDropBoxClientId(const AValue: String);
    procedure SetToken(const AValue: String);
    function GetToken: string;

    function Send: boolean; overload; virtual; abstract;
    function Send(const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken: String): boolean; overload; virtual; abstract;

    function Get: boolean; overload; virtual; abstract;
    function Get(const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken: String): boolean; overload; virtual; abstract;

    //20190522 Igor >>>
    function DeleteCloudFile: boolean; overload; virtual; abstract;
    function DeleteCloudFile(const ACloudPath, ACloudFile, ADropBoxClientId, AToken: String): boolean; overload; virtual; abstract;
    //20190522 Igor <<<

    function SetShare: boolean; overload; virtual; abstract;
    function SetShare(const AEmail, ACloudPath, ACloudFile, ADropBoxClientId, AToken: String): boolean; overload; virtual; abstract;


    function GetShared: boolean; overload; virtual; abstract;
    function GetShared(const ALocalFile, AUrlFile, ADropBoxClientId, AToken: String): boolean; overload; virtual; abstract;

    function List: PChar; overload;  virtual; abstract;//20161219 Igor
    function List(const ACloudPath, ADropBoxClientId, AToken: String): PChar; overload; virtual; abstract;//20161219 Igor

    function ListReceived: PChar; overload;  virtual; abstract;
    function ListReceived(ADropBoxClientId, AToken: String): PChar; overload; virtual; abstract;
    //20180113 Igor >>>
    function HasLicenseKey: boolean; virtual; abstract;
    function GetLicenseKey: string; virtual; abstract;
    function GetLicenseKeyPrefix: string; virtual; abstract;
    function GetLicenses: PPgmLicenseData; virtual; abstract;
    function ValidateKey(AKey: string; AYear: integer): boolean; virtual; abstract; //20190307 Igor
    procedure SetLicense(AKey: string); virtual; abstract;
    function GetLicenseData(AKey: string): PPgmLicenseData; virtual; abstract;
    function GetLicenseDemoDate(AKey: string): TDateTime; virtual; abstract;
    function AllowExecuteOperation(AHelperAction: THelperAction): boolean; virtual; abstract;
    //20180113 Igor <<<
    //20190305 Igor
    function ValidateApp(AApp: string): boolean; virtual; abstract;
    function GetAllowedApps(AKey: string): string; virtual; abstract;
    //20190305 Igor <<<
    function GetLastError: string; virtual; abstract; //20200224 Igor
  end;

  TCloudHelperClass = class of TCloudHelper;
    function TCloudFileListToStr(ACloudFileList: TCloudFileList): string;
    function StrToTCloudFileList(AString: string): TCloudFileList;

  procedure AddChromiumDirToPath; //20190228 Igor

implementation

procedure AddChromiumDirToPath; //20190228 Igor
var CurrPath, ChromiumPath: string;
begin
  ChromiumPath := TPath.Combine(ExtractFilePath(Application.ExeName), 'Chromium');
  CurrPath := GetEnvironmentVariable('PATH');
  SetEnvironmentVariable('PATH', PChar(CurrPath + ';' + ChromiumPath));
end;

function StrToTCloudFileList(AString: string): TCloudFileList;
const r: string = '|';
var
I: Integer;
ACloudFileList: TCloudFileList;
APath, AFullPath,  AUrl: string;
AIsDir: Boolean;
ASize: Integer;
AServerModified: TDateTime;
addr: Array of String;
S, S1: String;
begin
  if AString.IsEmpty then Exit(nil); //20190222 Igor
  S := AString;
  if S[Length(S)]<> r then
    S:=S+r;
  while S<>'' do
  begin
    S1:=copy(S,1,pos(r,S)-1);
    Delete(S,1, pos(r,S));
    SetLength(addr,length(Addr)+1);
    Addr[length(addr)-1] := S1;
  end;

 ACloudFileList := TCloudFileList.Create(True);

 i:=0;
  repeat
    APath := addr[i];
    AFullPath := addr[i+1];
    AIsDir := addr[i+2]='true';
    ASize := StrToInt(addr[i+3]);
    AServerModified:= StrToDateTime(addr[i+4]);
    AUrl:= addr[i+5];
    ACloudFileList.AddFile(APath, AFullPath, AIsDir, ASize, AServerModified, AUrl);
    i:=i+6;
  until (i>=Length(Addr)-1);

 Result:=ACloudFileList;
end;


function TCloudFileListToStr( ACloudFileList: TCloudFileList): string;
const r: string = '|';
var I: Integer;
 temp: string;
begin
  Result:='';
  temp:='';
  if Assigned(ACloudFileList) then
  begin
   for I := 0 to ACloudFileList.Count-1 do
    begin
     with  ACloudFileList[i] do
     begin
      temp := temp + FPath + r;
      temp := temp + FFullPath + r;
      if  FIsDir then
       temp := temp + 'true' + r
      else
       temp := temp + 'false' + r;
      temp := temp + IntToStr(FSize) + r;
      temp := temp + DateTimeToStr(FServerModified) + r;
      temp := temp + FUrl + r;
     end;
    end;
    Result:=temp;
  end;

end;


constructor TCloudHelper.Create;
begin
  inherited Create;
end;

destructor TCloudHelper.Destroy;
begin
  if Assigned(Application.MainForm) then
    Application.MainForm.Visible := True;
  Application.BringToFront;
  inherited;
end;

function TCloudHelper.GetToken: string;
begin
  Result := FToken;
end;

procedure TCloudHelper.SetDropBoxClientId(const AValue: String);
begin
  FDropBoxClientId := AValue;
end;

procedure TCloudHelper.SetEmail(const AValue: string);
begin
 FEmail := AValue;
end;

procedure TCloudHelper.SetLocalFile(const AValue: String);
begin
  FLocalFile := AValue;
  FLocalFolder := ExtractFileDir(AValue);
end;

procedure TCloudHelper.SetCloudFile(const AValue: string);
begin
  FCloudFile := AValue;
end;

procedure TCloudHelper.SetCloudPath(const AValue: string);
begin
  FCloudPath := StringReplace(AValue, '\', '/', [rfReplaceAll]);  //20170327 Igor
end;

procedure TCloudHelper.SetToken(const AValue: String);
begin
  FToken := AValue;
end;



procedure TCloudHelper.SetUrlFile(const AValue: String);
begin
  FUrlFile := StringReplace(AValue, '\', '/', [rfReplaceAll]);    //20170327 Igor
end;


constructor TCloudFile.Create(APath, AFullPath: string; AIsDir: Boolean; ASize: Integer; AServerModified: TDateTime; AUrl: string);
begin
  inherited Create;
  FPath := APath;
  FFullPath := AFullPath;
  FIsDir := AIsDir;
  FSize := ASize;
  FUrl := AUrl;
  FServerModified := AServerModified;
end;

{ TCloudFileList }

procedure TCloudFileList.AddFile(APath, AFullPath: string; AIsDir: Boolean; ASize: Integer; AServerModified: TDateTime; AUrl: string);
begin
  Self.Add(TCloudFile.Create(APath, AFullPath, AIsDir, ASize, AServerModified, AUrl));
end;

function TCloudFileList.GetFileByPath(APath: String): TCloudFile;
var
  F: TCloudFile;
begin
  for F in Self do
    if SameText(F.FPath, APath) then
      Exit(F);
  Result := nil;
end;


end.
