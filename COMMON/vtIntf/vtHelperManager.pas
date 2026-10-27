unit vtHelperManager;

interface

uses System.Classes, System.SysUtils, Vcl.Dialogs, System.Generics.Collections,
  vtCommonIntf, db, VCL.Forms, vcl.ComCtrls, VCL.Menus, vtMulti, vtCommon, System.IOUtils; //20180113 Igor //20190222 Igor

type
  //THelperAction = (haSaveToCloud, haLoadFromCloud, haViewList);  //20180113 Igor
  TCreateLoadItemEvent = procedure(const aName: string; const aHelperID: Integer) of object;//20171212 Igor
  TMenuItemEx = class(TMenuItem)
  private
    FHelperID: Integer;
    FHelperAction: THelperAction;
  public
    property HelperID: Integer read FHelperID write FHelperID;
    property HelperAction: THelperAction read FHelperAction write FHelperAction;
  end;

  TCloudHelperClassList = TDictionary<TCloudHelperClass, String>;

  TParentFullName = function: String of Object;
  THelperAppUserConfig = class;
  TOnUserConfigChangeNotify = procedure(Sender: THelperAppUserConfig) of object;
  THelperAppUserConfig = class
  private
    FAppId: String; //20190222 Igor
    FPath: String;
    FToken: String;
    FSaveToken: Boolean;
    FUserName: String;
    FOnChange: TOnUserConfigChangeNotify;
    FSaveReturnToCloud: Boolean;
    FParentFullName: TParentFullName;
    procedure SetPath(const Value: String);
    procedure SetSaveToken(const Value: Boolean);
    procedure SetToken(const Value: String);
    procedure SetOnChange(const Value: TOnUserConfigChangeNotify);
    procedure DoChange;
    procedure SetSaveReturnToCloud(const Value: Boolean);
    procedure SetParentFullName(const Value: TParentFullName);
    function GetParentFullName: String;
    //20190513 Igor >>>
    function ReadPath: String;
    function ReadSaveToken: Boolean;
    function ReadSaveReturnToCloud: Boolean;
    //20190513 Igor <<<
    function ReadFullPath: string; //20200217 Igor
  public
    constructor Create(AUserName: String; ASaveToken: Boolean; AToken, APath: String); overload;
    constructor Create(AUserName: String); overload;
    property ParentFullName: TParentFullName read FParentFullName write SetParentFullName;
    function GetFullName: String;
    property UserName: String read FUserName;
    property SaveToken: Boolean read ReadSaveToken write SetSaveToken; //20190513 Igor
    property Token: String read FToken write SetToken;
    property Path: String read ReadPath write SetPath; //20190513 Igor
    property FullPath: string read ReadFullPath; //20200217 Igor
    property AppId: String read FAppId write FAppId; //20190222 Igor
    property SaveReturnToCloud: Boolean read ReadSaveReturnToCloud write SetSaveReturnToCloud; //20190513 Igor
    property OnChange: TOnUserConfigChangeNotify read FOnChange write SetOnChange;
  end;

  THelperAppConfig = class;
  TAppConfigChangeNotify = procedure(Sender: THelperAppConfig; Item: THelperAppUserConfig) of object;
  THelperAppConfig = class(TObjectList<THelperAppUserConfig>)
  private
    FAppID: String;
    FOnChange: TAppConfigChangeNotify;
    FLockNotify: Integer;
    FParentFullName: TParentFullName;
    procedure UserConfigChange(Sender: THelperAppUserConfig);
    procedure SetOnChange(const Value: TAppConfigChangeNotify);
    Procedure LockNotify;
    Procedure UnLockNotify;
    function GetParentFullName: String;
    procedure SetParentFullName(const Value: TParentFullName);
  public
    constructor Create(AAppID: String);
    function PropertyByUserName(AUserName: String; AAddIfNotExists: Boolean = true): THelperAppUserConfig;
    procedure AddOrReplaceProperty(AUserName: String; ASaveToken: Boolean; AToken, APath: String);
    function AddUserConfig(AUserName: String): THelperAppUserConfig;
    property ParentFullName: TParentFullName read FParentFullName write SetParentFullName;
    function GetFullName: String;
    property AppID: String read FAppID;
    property OnChange: TAppConfigChangeNotify read FOnChange write SetOnChange;
  end;

  THelperConfig = class;
  HelperConfigChange = procedure(Sender: THelperConfig; Item: THelperAppConfig;
    SubItem: THelperAppUserConfig) of Object;
  THelperConfig = class(TObjectList<THelperAppConfig>)
  private
    FUseDefaultClientID: Boolean;
    FClientID: String;
    FHelperName: String;
    FHelperClass: String;
    FDefaultClientID: String;
    FLockNotify: Integer;
    FOnCHange: HelperConfigChange;
    procedure DoChange;
    procedure SetClientID(const Value: String);
    procedure SetDefaultClientID(const Value: String);
    procedure SetHelperName(const Value: String);
    procedure SetUseDefaultClientID(const Value: Boolean);
    procedure AppConfigChange(Sender: THelperAppConfig; Item: THelperAppUserConfig);
    procedure SetOnChange(const Value: HelperConfigChange);
    Procedure LockNotify;
    Procedure UnLockNotify;
  public
    constructor Create(AHelperClass: String); overload;
    constructor Create(AHelperClass: String; AHelperName,
      ADefaultClientID, AClientID: String; AUseDefaultClientID: Boolean); overload;
    function PropertyByAppID(AAppID: String; AAddIfNotExists: Boolean = true): THelperAppConfig;
    function AddAppConfig(AAppID: String): THelperAppConfig;
    function GetFullName: String;
    property HelperClass: String read FHelperClass;

    property HelperName: String read FHelperName write SetHelperName;
    property DefaultClientID: String read FDefaultClientID write SetDefaultClientID;
    property ClientID: String read FClientID write SetClientID;
    property UseDefaultClientID: Boolean read FUseDefaultClientID write SetUseDefaultClientID;

    property OnChange: HelperConfigChange read FOnCHange write SetOnChange;
  end;

  TManagerConfig = class(TObjectList<THelperConfig>)
  private
    FConfigFileName: String;
    FPrevConfigFileName: String; //20190222 Igor
    FLockNotify: Integer;
    procedure ConfigChange(Sender: THelperConfig; Item: THelperAppConfig;
      SubItem: THelperAppUserConfig);
    Procedure LockNotify;
    Procedure UnLockNotify;
    procedure SaveConfig(Helper: THelperConfig; App: THelperAppConfig;
      User: THelperAppUserConfig);
    procedure SetConfigFileName(const Value: string); //20190222 Igor
  public
    constructor Create(AFileName: String);
    function PropertyByHelperClass(AHelperClass: String;
      AAddIfNotExists: Boolean = true): THelperConfig;
    function AddOrReplaceProperty(AHelperClass: String; AHelperName,
      ADefaultClientID, AClientID: String; AUseDefaultClientID: Boolean): THelperConfig;
    function AddHelperConfig(AHelperClass: String): THelperConfig;
    procedure LoadConfig;
    procedure Save;
    property ConfigFileName: string read FConfigFileName write SetConfigFileName; //20190222 Igor
  end;

  THelperManager = class
  private
    FHelperClassList: TCloudHelperClassList;
    DLLs: Array of HMODULE;
    FListResult: string;
  private
    FOnCloudFileExists: THelperIOError;
    FOnCloudFileNotExists: THelperIOError;
    FOnLocalFileExists: THelperIOError;
    FOnDialog: THelperDialog;
    FOnCheckBytesError: THelperIOError;
    FOnLocalFileNotExists: THelperIOError;
    FOnDownLoadError: THelperIOError;
    FOnUpLoadError: THelperIOError;
    FOnSaveLocalFileError: THelperIOError;
    FOnReadLocalFileError: THelperIOError;
    FManagerConfig: TManagerConfig;
    FOnHelperLog: THelperLog;//20161213 Igor

    procedure SetOnCloudFileExists(const Value: THelperIOError);
    procedure SetOnCloudFileNotExists(const Value: THelperIOError);
    procedure SetOnDialog(const Value: THelperDialog);
    procedure SetOnLocalFileExists(const Value: THelperIOError);
    procedure SetOnLocalFileNotExists(const Value: THelperIOError);
    procedure SetOnDownLoadError(const Value: THelperIOError);
    procedure SetOnUpLoadError(const Value: THelperIOError);
    procedure SetOnCheckBytesError(const Value: THelperIOError);
    procedure SetOnSaveLocalFileError(const Value: THelperIOError);
    procedure SetOnReadLocalFileError(const Value: THelperIOError);
    procedure SetOnHelperLog(const Value: THelperLog); //20161213 Igor

    procedure DoLog(Sender: TObject; const AEvent: String);// 20161214 Igor
    procedure LoadHelperPlugins;
    procedure UnloadHelperPlugin;
    procedure RestoreApplication;
  public
    LastError: string; //20200224 Igor
    constructor Create;
    destructor Destroy; override;

    procedure RegisterHelper(AClass: TCloudHelperClass; AName, AClientID: String;
      HelperPlugin: HModule);
    procedure UnregisterHelper(AClass: TCloudHelperClass);

    property OnDialog: THelperDialog read FOnDialog write SetOnDialog;
    property OnLocalFileExists: THelperIOError read FOnLocalFileExists write SetOnLocalFileExists;
    property OnLocalFileNotExists: THelperIOError read FOnLocalFileNotExists write SetOnLocalFileNotExists;
    property OnCloudFileExists: THelperIOError read FOnCloudFileExists write SetOnCloudFileExists;
    property OnCloudFileNotExists: THelperIOError read FOnCloudFileNotExists write SetOnCloudFileNotExists;
    property OnDownLoadError: THelperIOError read FOnDownLoadError write SetOnDownLoadError;
    property OnUpLoadError: THelperIOError read FOnUpLoadError write SetOnUpLoadError;
    property OnCheckBytesError: THelperIOError read FOnCheckBytesError write SetOnCheckBytesError;
    property OnSaveLocalFileError: THelperIOError read FOnSaveLocalFileError write SetOnSaveLocalFileError;
    property OnReadLocalFileError: THelperIOError read FOnReadLocalFileError write SetOnReadLocalFileError;
    property OnHelperLog: THelperLog read FOnHelperLog write SetOnHelperLog; //20161213 Igor

    procedure GetHelperList(var AList: TStrings);
    function GetCurrentKey(const AHelperIndex: integer): string; //20190307 Igor
    procedure ShowLastError(ASilent: boolean = false); //20200224 Igor

    //20200224 Igor >>>
    function Send(const AHelperIndex: integer; const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId: String; var AToken: String; ASilent: boolean = false): boolean;
    function Get(const AHelperIndex: integer; const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId: String; var AToken: String; ASilent: boolean = false): boolean;
    function DeleteCloudFile(const AHelperIndex: integer; const ACloudPath, ACloudFile, ADropBoxClientId: String; var AToken: String; ASilent: boolean = false): boolean; //20190522 Igor
    function SetShare(const AHelperIndex: integer; const AEmail, ACloudPath, ACloudFile, ADropBoxClientId: String; var AToken: String; ASilent: boolean = false): boolean;
    function GetShared(const AHelperIndex: integer; const ALocalFile, AUrlFile, ADropBoxClientId: String; var AToken: String; ASilent: boolean = false): boolean;

    function List(const AHelperIndex: integer;  const ACloudPath, ADropBoxClientId: String; var AToken:  String; AList: TStrings; ASilent: boolean = false): Boolean;
    function ListReceived(const AHelperIndex: integer;  const ADropBoxClientId: String; var AToken: String; AList: TStrings; ASilent: boolean = false): Boolean; overload;
    function ListReceived(const AHelperIndex: integer;  const ADropBoxClientId: String; var AToken: String; AList: TCloudFileList; ASilent: boolean = false): Boolean; overload;//20171212 Igor
    //20200224 Igor <<<
    //20180113 Igor >>>
    function HasLicenseKey(const AHelperIndex: integer): boolean;
    function ValidateKey(const AHelperIndex: integer; AKey: string): boolean;
    function AllowExecuteOperation(const AHelperIndex: integer; AHelperAction: THelperAction): boolean;
    function AllowSend(const AHelperIndex: integer): boolean;
    function AllowSetShare(const AHelperIndex: integer): boolean;
    //20180113 Igor <<<
    function ValidateApp(const AHelperIndex: integer): boolean; //20190305 Igor

    property HelperClassList: TCloudHelperClassList read FHelperClassList;
    property ManagerConfig: TManagerConfig read FManagerConfig;
    function Config(AHelperClass, AAppID, AUserName: String): THelperAppUserConfig; overload;
    function Config(AHelperID: Integer; AAppID, AUserName: String): THelperAppUserConfig; overload;
    function Config(AHelperClass, AAppID: String): THelperAppConfig; overload;
    function Config(AHelperClass: String): THelperConfig; overload;
    function Config(AHelperID: Integer): THelperConfig; overload;
  end;

  function HelperManager: THelperManager;
  procedure LoadPluginSettings(AAppID, AUserName: String; AWindow: TForm;
    APageContainer: TPageControl);
  procedure SavePluginSettings(AAppID, AUserName: String; AWindow: TForm;
    APageContainer: TPageControl);
  procedure LoadPluginActions(AWindow: TForm;
    AMenuContainer: TMainMenu; AOnClickNotify: TNotifyEvent; AOnCreateEvent: TCreateLoadItemEvent);//20171212 Igor

  procedure CallBackLog(Sender: TObject; const AEvent: String);
  procedure CallBackDialog(Sender: TObject; AMessageType: THelperMessageType;
    const AMessage: string; var AAnswer: THelperAnswer);
  procedure CallBackLocalFileExists(Sender: TObject; const AErrorMessage: string;
      AFileName: string; var AAnswer: THelperAnswer);
  procedure CallBackLocalFileNotExists(Sender: TObject; const AErrorMessage: string;
      AFileName: string; var AAnswer: THelperAnswer);
  procedure CallBackCloudFileExists(Sender: TObject; const AErrorMessage: string;
      AFileName: string; var AAnswer: THelperAnswer);
  procedure CallBackCloudFileNotExists(Sender: TObject; const AErrorMessage: string;
      AFileName: string; var AAnswer: THelperAnswer);
  procedure CallBackDownLoadError(Sender: TObject; const AErrorMessage: string;
      AFileName: string; var AAnswer: THelperAnswer);
  procedure CallBackUpLoadError(Sender: TObject; const AErrorMessage: string;
      AFileName: string; var AAnswer: THelperAnswer);
  procedure CallBackCheckBytesError(Sender: TObject; const AErrorMessage: string;
      AFileName: string; var AAnswer: THelperAnswer);
  procedure CallBackSaveLocalFileError(Sender: TObject; const AErrorMessage: string;
      AFileName: string; var AAnswer: THelperAnswer);
  procedure CallBackReadLocalFileError(Sender: TObject; const AErrorMessage: string;
      AFileName: string; var AAnswer: THelperAnswer);
  procedure CallbackReturnStringResult(const AString: String);
implementation

{ THelperManager }

uses
  WinAPI.Windows,
  IniFiles,
  uEncrypt,
  ManagerHelperSettingsFrame;

var
  FHelperManager: THelperManager;
const
  c_key = 8546;

function HelperManager: THelperManager;
begin
  Result := FHelperManager;
end;

function GetCorrectName(AName: String): String;
var
  I: Integer;
begin
  Result := AName;
  for I := 1 to length(Result) do
    if not CharInSet(Result[I], ['a'..'z', 'A'..'Z', '0'..'9', '_']) then
      Result[I] := '_';
end;

function THelperManager.Config(AHelperClass, AAppID,
  AUserName: String): THelperAppUserConfig;
begin
  result := ManagerConfig.PropertyByHelperClass(AHelperClass).
                          PropertyByAppID(AAppId).
                          PropertyByUserName(AUserName);
end;

function THelperManager.Config(AHelperClass, AAppID: String): THelperAppConfig;
begin
  result := ManagerConfig.PropertyByHelperClass(AHelperClass).
                          PropertyByAppID(AAppId);
end;

function THelperManager.Config(AHelperClass: String): THelperConfig;
begin
  result := ManagerConfig.PropertyByHelperClass(AHelperClass);
end;

function THelperManager.Config(AHelperID: Integer; AAppID,
  AUserName: String): THelperAppUserConfig;
begin
  result := ManagerConfig.PropertyByHelperClass(HelperManager.HelperClassList.Keys.ToArray[AHelperID].ClassName).
                          PropertyByAppID(AAppId).
                          PropertyByUserName(AUserName);
end;

constructor THelperManager.Create;
begin
  inherited Create;
  FHelperClassList := TCloudHelperClassList.Create;
  FManagerConfig := TManagerConfig.Create(extractFilePath(ParamStr(0))+'HelpersConfig.txt');
end;

function THelperManager.DeleteCloudFile(const AHelperIndex: integer; //20190522 Igor //20200224 Igor
  const ACloudPath, ACloudFile, ADropBoxClientId: String;
  var AToken: String; ASilent: boolean): boolean;
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False);
      Result := DeleteCloudFile(ACloudPath, ACloudFile, ADropBoxClientId, AToken);
      LastError := GetLastError;
      if not Result then ShowLastError(ASilent);
      if (AToken <> GetToken) and (GetToken <> '') then
        AToken := GetToken;
    finally
      free;
    end;
  end;
  RestoreApplication; //20210826 Igor
end;

destructor THelperManager.Destroy;
begin
  FHelperClassList.Free;
  ManagerConfig.Free;
  inherited;
end;

procedure THelperManager.DoLog(Sender: TObject; const AEvent: String);
begin

end;

procedure THelperManager.GetHelperList(var AList: TStrings);
var
  LPair: TPair<TCloudHelperClass, String>;
begin
  for LPair in FHelperClassList do
    AList.Add(LPair.Value);
end;

function THelperManager.GetShared(const AHelperIndex: integer; const ALocalFile, AUrlFile, ADropBoxClientId: String;
  var AToken: String; ASilent: boolean): boolean; //20200224 Igor
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False); //20190307 Igor
      Result := GetShared(ALocalFile,  AUrlFile, ADropBoxClientId, AToken);
      LastError := GetLastError;
      if not Result then ShowLastError(ASilent);
      if (AToken <> GetToken) and (GetToken <> '') then
        AToken := GetToken;
    finally
      free;
    end;
  end;
  RestoreApplication; //20210826 Igor
end;

function THelperManager.HasLicenseKey(const AHelperIndex: integer): boolean; //20180113 Igor
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      Result := HasLicenseKey;
    finally
      free;
    end;
  end;
end;

procedure THelperManager.RegisterHelper(AClass: TCloudHelperClass; AName, AClientID: String;
  HelperPlugin: HModule);
begin
  FHelperClassList.Add(AClass, AName);
  with ManagerConfig.PropertyByHelperClass(AClass.ClassName, true) do
  begin
    HelperName := AName;
    DefaultClientID := AClientID;
    if ClientID = '' then
      UseDefaultClientID := True;
  end;
  setlength(DLLs, length(DLLs) + 1);
  DLLs[Length(Dlls) - 1] := HelperPlugin;
end;

procedure THelperManager.RestoreApplication;
begin
  if Assigned(Application.MainForm) then
    Application.MainForm.Visible := True;
  Application.BringToFront;
end;

function THelperManager.Get(const AHelperIndex: integer; const ALocalFile,
  ACloudPath, ACloudFile, ADropBoxClientId: String; var AToken: String; ASilent: boolean): boolean; //20200224 Igor
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False); //20190307 Igor
      Result := Get(ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken);
      LastError := GetLastError;
      if not Result then ShowLastError(ASilent);
      if (AToken <> GetToken) and (GetToken <> '') then
        AToken := GetToken;
    finally
      free;
    end;
  end;
  RestoreApplication; //20210826 Igor
end;

function THelperManager.GetCurrentKey(const AHelperIndex: integer): string; //20190307 Igor
begin
  Result := LicenseList.Keys[HelperClassList.Values.ToArray[AHelperIndex]];
end;

function THelperManager.List(const AHelperIndex: integer;  const ACloudPath,
  ADropBoxClientId: String; var AToken: String; AList: TStrings; ASilent: boolean): Boolean; //20200224 Igor
var
  myList: TCloudFileList;
  i: integer;
  PRes: PChar;
  Res: string;
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False); //20190307 Igor
      PRes := List(ACloudPath, ADropBoxClientId, AToken);
      LastError := GetLastError;
      if PRes = nil then
      begin
        ShowLastError(ASilent);
        Exit(False);
      end;
      Res := string(PRes);
      myList := vtCommonIntf.StrToTCloudFileList(Res);
      if Assigned(myList)  then
      begin
        try
          for i := 0 to myList.Count - 1 do
            if not myList.Items[i].IsDir then //20190222 Igor
              AList.Add(myList.Items[i].Path);
        finally
          myList.Free;
        end;
        if (AToken <> GetToken) and (GetToken <> '') then
          AToken := GetToken;
      end;
      Result := True;//20170811 Igor
    finally
      free;
    end;
  end;
//20161219 Igor <<<
  RestoreApplication; //20210826 Igor
end;
//20171212 Igor>>
function THelperManager.ListReceived(const AHelperIndex: integer;
  const ADropBoxClientId: String; var AToken: String;
  AList: TCloudFileList; ASilent: boolean): Boolean; //20200224 Igor
var
  MyList: TCloudFileList;
  aFile: TCloudFile;
  PRes: PChar;
  Res: string;
  I: Integer;
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False); //20190307 Igor
      PRes := ListReceived(ADropBoxClientId, AToken);
      LastError := GetLastError;
      if PRes = nil then
      begin
        ShowLastError(ASilent);
        Exit(False);
      end;
      Res := string(PRes);
      MyList := vtCommonIntf.StrToTCloudFileList(Res);
      if Assigned(MyList) then
      begin
        try
          for i := 0 to myList.Count - 1 do
          begin
            aFile := TCloudFile.Create(myList.Items[i].Path, myList.Items[i].FullPath,
              myList.Items[i].IsDir, myList.Items[i].Size, myList.Items[i].ServerModified,
              myList.Items[i].Url);
            AList.Add(aFile);
          end;
        finally
          myList.Free;
        end;
        if (AToken <> GetToken) and (GetToken <> '') then
          AToken := GetToken;
      end;
      Result := true;
    finally
      free;
    end;
  end;
  RestoreApplication; //20210826 Igor
end;
//20171212 Igor<<
function THelperManager.ListReceived(const AHelperIndex: integer;
  const ADropBoxClientId: String; var AToken: String; AList: TStrings; ASilent: boolean): Boolean; //20200224 Igor
var
  myList: TCloudFileList;
  PRes: PChar;
  Res: string;
  I: Integer;
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False); //20190307 Igor
      PRes := ListReceived(ADropBoxClientId, AToken);
      LastError := GetLastError;
      if PRes = nil then
      begin
        ShowLastError(ASilent);
        Exit(False);
      end;
      Res := string(PRes);
      myList := vtCommonIntf.StrToTCloudFileList(Res);
      if Assigned(myList) then
      begin
        try
          for i := 0 to myList.Count - 1 do
            AList.Add(myList.Items[i].Path);
        finally
          myList.Free;
        end;
        if (AToken <> GetToken) and (GetToken <> '') then
          AToken := GetToken;
      end;
      Result := true;//20170811 Igor
    finally
      free;
    end;
  end;
  RestoreApplication; //20210826 Igor
end;

function THelperManager.Send(const AHelperIndex: integer; const ALocalFile,
  ACloudPath, ACloudFile, ADropBoxClientId: String; var AToken: String; ASilent: boolean): boolean; //20200224 Igor
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False); //20190307 Igor
      Result := Send(ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken);
      LastError := GetLastError;
      if not Result then ShowLastError(ASilent);
      if (AToken <> GetToken) and (GetToken <> '') then
        AToken := GetToken;
    finally
      free;
    end;
  end;
  RestoreApplication; //20210826 Igor
end;

procedure THelperManager.SetOnCheckBytesError(const Value: THelperIOError);
begin
  FOnCheckBytesError := Value;
end;

procedure THelperManager.SetOnCloudFileExists(const Value: THelperIOError);
begin
  FOnCloudFileExists := Value;
end;

procedure THelperManager.SetOnCloudFileNotExists(const Value: THelperIOError);
begin
  FOnCloudFileNotExists := Value;
end;

procedure THelperManager.SetOnDialog(const Value: THelperDialog);
begin
  FOnDialog := Value;
end;

procedure THelperManager.SetOnDownLoadError(const Value: THelperIOError);
begin
  FOnDownLoadError := Value;
end;

procedure THelperManager.SetOnHelperLog(const Value: THelperLog); //20161213 Igor
begin
  FOnHelperLog := Value;
end;

procedure THelperManager.SetOnLocalFileExists(const Value: THelperIOError);
begin
  FOnLocalFileExists := Value;
end;

procedure THelperManager.SetOnLocalFileNotExists(const Value: THelperIOError);
begin
  FOnLocalFileNotExists := Value;
end;

procedure THelperManager.SetOnReadLocalFileError(const Value: THelperIOError);
begin
  FOnReadLocalFileError := Value;
end;

procedure THelperManager.SetOnSaveLocalFileError(const Value: THelperIOError);
begin
  FOnSaveLocalFileError := Value;
end;

procedure THelperManager.SetOnUpLoadError(const Value: THelperIOError);
begin
  FOnUpLoadError := Value;
end;

function THelperManager.SetShare(const AHelperIndex: integer; const AEmail, ACloudPath, ACloudFile, ADropBoxClientId: String;
  var AToken: String; ASilent: boolean): boolean; //20200224 Igor
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False); //20190307 Igor
      Result := SetShare(AEmail, ACloudPath, ACloudFile, ADropBoxClientId, AToken);
      LastError := GetLastError;
      if not Result then ShowLastError(ASilent);
      if (AToken <> GetToken) and (GetToken <> '') then
        AToken := GetToken;
    finally
      free;
    end;
  end;
  RestoreApplication; //20210826 Igor
end;

procedure THelperManager.ShowLastError(ASilent: boolean = false); //20200224 Igor //20200305 Igor
begin
  if not ASilent and not LastError.isEmpty then
  begin
    if (Pos('RecentCloud.txt', LastError) > 0) and (Pos('does not exist', LastError) > 0) then
      LastError := 'There are no tax returns done recently';
    ShowMessage(LastError);
  end;
end;

procedure THelperManager.UnregisterHelper(AClass: TCloudHelperClass);
begin
  FHelperClassList.Remove(AClass);
  FManagerConfig.Remove(FManagerConfig.PropertyByHelperClass(AClass.ClassName, false)); //20161212 Igor
end;

function THelperManager.ValidateApp(const AHelperIndex: integer): boolean; //20190305 Igor
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False); //20190307 Igor
      Result := ValidateApp(CurrentApp.AppName);
    finally
      free;
    end;
  end;
end;

function THelperManager.ValidateKey(const AHelperIndex: integer; AKey: string): boolean; //20180113 Igor
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      Result := ValidateKey(AKey, ProjectYear);
    finally
      free;
    end;
  end;
end;

procedure THelperManager.LoadHelperPlugins;
var
  FindRes: Integer;
  SR: TSearchRec;
  HelperPlugin: HModule;
  PProc: procedure(out AClass: TCloudHelperClass; out AHelperName: string; out AClientID: String);
  PInit: procedure(const ACallBackDialog: TCallBackHelperDialog;
                  const ACallBackLocalFileExists, ACallBackLocalFileNotExists, ACallBackCloudFileExists,
                  ACallBackCloudFileNotExists, ACallBackDownLoadError, ACallBackUpLoadError,
                  ACallBackCheckBytesError, ACallBackSaveLocalFileError, ACallBackReadLocalFileError: TCallBackHelperIOError;
                  const ACallBackHelperLog: TCallBackHelperLog);
  HelperClass: TCloudHelperClass;
  HelperName: String;
  ClientID: String;

begin
  FindRes := FindFirst(ExtractFilePath(ParamStr(0))+'vt*Helper.dll', faAnyFile, SR);
  try
    while FindRes = 0 do
    begin
      HelperPlugin := SafeLoadLibrary(PWideChar(ExtractFilePath(ParamStr(0))+SR.Name), SEM_FAILCRITICALERRORS);
      if HelperPlugin <> 0 then
      begin
        try
          @PProc := getProcAddress(HelperPlugin, 'Radar');
          if @PProc <> nil then
          begin
            PProc(HelperClass, HelperName, ClientID);
            RegisterHelper(HelperClass, HelperName, ClientID, HelperPlugin);
          end
          else
            FreeLibrary(HelperPlugin);
          @PInit := getProcAddress(HelperPlugin, 'init');
          if @PInit <> nil then
            PInit(CallBackDialog, CallBackLocalFileExists, CallBackLocalFileNotExists,
              CallBackCloudFileExists, CallBackCloudFileNotExists, CallBackDownLoadError,
              CallBackUpLoadError, CallBackCheckBytesError, CallBackSaveLocalFileError,
              CallBackReadLocalFileError, CallBackLog);
        except ON E: Exception DO
          FreeLibrary(HelperPlugin);
        End;
      end;
      FindRes := FindNext(SR);
    end;
  finally
    System.SysUtils.FindClose(SR);
  end;
end;

procedure THelperManager.UnloadHelperPlugin;
var
  I: Integer;
  PProc: procedure; //20190312 Igor
begin
  FHelperClassList.Clear;//20161212 Igor
  FManagerConfig.Clear;//20161212 Igor
  //20190312 Igor >>>
  for I := 0 to Length(DLLs) - 1 do
  begin
    @PProc := getProcAddress(DLLs[I], 'CloseCef');
    if @PProc <> nil then
      PProc;
    FreeLibrary(DLLs[I]);
  end;
  //20190312 Igor <<<
  SetLength(DLLs, 0); //20161212 Igor
end;

function THelperManager.AllowExecuteOperation(const AHelperIndex: integer; //20180113 Igor
  AHelperAction: THelperAction): boolean;
begin
  with FHelperClassList.Keys.ToArray[AHelperIndex].Create do
  begin
    try
      //20190306 Igor >>>
      Result := false;
      if not ValidateKey(GetCurrentkey(AHelperIndex), ProjectYear) then Exit(False); //20190307 Igor
      if not ValidateApp(CurrentApp.AppName) then Exit;
      //20190306 Igor <<<
      Result := AllowExecuteOperation(AHelperAction);
    finally
      free;
    end;
  end;
end;

function THelperManager.AllowSend(const AHelperIndex: integer): boolean; //20180113 Igor
begin
  Result := AllowExecuteOperation(AHelperIndex, haSaveToCloud);
end;

function THelperManager.AllowSetShare(const AHelperIndex: integer): boolean; //20180113 Igor
begin
  Result := AllowExecuteOperation(AHelperIndex, haSaveToCloud);
end;

function THelperManager.Config(AHelperID: Integer): THelperConfig;
begin
  Result := ManagerConfig.PropertyByHelperClass(HelperManager.HelperClassList.Keys.ToArray[AHelperID].ClassName);
end;

{ THelperAppUserConfig }

constructor THelperAppUserConfig.Create(AUserName: String; ASaveToken: Boolean; AToken,
  APath: String);
begin
  Create(AUserName);
  FSaveToken := ASaveToken;
  FToken := AToken;
  FPath := APath;
end;

constructor THelperAppUserConfig.Create(AUserName: String);
begin
  inherited Create;
  FUserName := AUserName;
end;

procedure THelperAppUserConfig.DoChange;
begin
  if assigned(FOnChange) then
    FOnChange(Self);
end;

function THelperAppUserConfig.GetFullName: String;
begin
  result := 'US_' + GetParentFullName + GetCorrectName(Self.UserName);
end;

function THelperAppUserConfig.GetParentFullName: String;
begin
  if assigned(FParentFullName) then
    Result := FParentFullName
  else
    Result := '';
end;

function THelperAppUserConfig.ReadFullPath: string; //20200217 Igor
begin
  if FPath.IsEmpty then
    Result := ''
  else
    Result := String('https://www.dropbox.com/home/apps/vtCloud/' + FPath.Replace('\', '/')).Replace('//', '/');
end;

function THelperAppUserConfig.ReadPath: String; //20190313 Igor
begin
  if FPath.IsEmpty then
   Path := AppId;
  Result := FPath;
end;

function THelperAppUserConfig.ReadSaveReturnToCloud: Boolean; //20190513 Igor //20190522 Igor
begin
  Result := FSaveReturnToCloud;
  if CheckIsCloud(true) then
    Result := true;
end;

function THelperAppUserConfig.ReadSaveToken: Boolean; //20190513 Igor
begin
  Result := true;
end;

procedure THelperAppUserConfig.SetOnChange(const Value: TOnUserConfigChangeNotify);
begin
  FOnChange := Value;
end;

procedure THelperAppUserConfig.SetParentFullName(const Value: TParentFullName);
begin
  FParentFullName := Value;
end;

procedure THelperAppUserConfig.SetPath(const Value: String);
begin
  if FPath <> Value then
  begin
    FPath := Value;
    DoChange;
  end;
end;

procedure THelperAppUserConfig.SetSaveReturnToCloud(const Value: Boolean);
begin
  if FSaveReturnToCloud <> Value then
  begin
    FSaveReturnToCloud := Value;
    DoChange;
  end;
end;

procedure THelperAppUserConfig.SetSaveToken(const Value: Boolean);
begin
  if FSaveToken <> Value then
  begin
    FSaveToken := Value;
    DoChange;
  end;
end;

procedure THelperAppUserConfig.SetToken(const Value: String);
begin
  if FToken <> Value then
  begin
    FToken := Value;
    DoChange;
  end;
end;

{ THelperAppConfig }

constructor THelperAppConfig.Create(AAppID: String);
begin
  inherited Create(true);
  FAppID := AAppID;
  FLockNotify := 0;
end;

function THelperAppConfig.GetFullName: String;
begin
  result := GetParentFullName + GetCorrectName(Self.AppID);
end;

function THelperAppConfig.GetParentFullName: String;
begin
  if assigned(FParentFullName) then
    Result := FParentFullName
  else
    Result := '';
end;

procedure THelperAppConfig.LockNotify;
begin
  inc(FLockNotify);
end;

procedure THelperAppConfig.AddOrReplaceProperty(AUserName: String;
  ASaveToken: Boolean; AToken, APath: String);
var
  C: THelperAppUserConfig;
begin
  C := PropertyByUserName(AUserName, true);
  LockNotify;
  try
    C.SaveToken := ASaveToken;
    C.Token := AToken;
    C.Path := APath;
  finally
    UnlockNotify;
  end;
  UserConfigChange(C);
end;

procedure THelperAppConfig.SetOnChange(const Value: TAppConfigChangeNotify);
begin
  FOnChange := Value;
end;

procedure THelperAppConfig.SetParentFullName(const Value: TParentFullName);
begin
  FParentFullName := Value;
end;

procedure THelperAppConfig.UnLockNotify;
begin
  Dec(FLockNotify);
end;

procedure THelperAppConfig.UserConfigChange(Sender: THelperAppUserConfig);
begin
  if (FLockNotify = 0) and assigned(FOnChange) then
    FOnChange(Self, Sender);
end;

function THelperAppConfig.AddUserConfig(AUserName: String): THelperAppUserConfig;
begin
  Result :=  THelperAppUserConfig.Create(AUserName);
  Result.OnChange := UserConfigChange;
  Result.ParentFullName := GetFullName;
  Result.AppId := AppId; //20190222 Igor
  Self.Add(Result);
end;

function THelperAppConfig.PropertyByUserName(AUserName: String; AAddIfNotExists: Boolean = true): THelperAppUserConfig;
var
  C: THelperAppUserConfig;
begin
  for C in Self do
  begin
    if SameText(AUserName, C.UserName) then
      exit(C);
  end;
  if AAddIfNotExists then
    Result := AddUserConfig(AUserName)
  else
    Result := nil;
end;

{ THelperConfig }

function THelperConfig.AddAppConfig(AAppID: String): THelperAppConfig;
begin
  Result := THelperAppConfig.Create(AAppID);
  Result.OnChange := AppConfigChange;
  Result.ParentFullName := GetFullName;
  Self.Add(Result);
end;

procedure THelperConfig.AppConfigChange(Sender: THelperAppConfig;
  Item: THelperAppUserConfig);
begin
  if (FLockNotify = 0) AND Assigned(FOnChange) then
    FOnChange(Self, Sender, Item);
end;

constructor THelperConfig.Create(AHelperClass: String);
begin
  inherited Create;
  FHelperClass := AHelperClass;
  FLockNotify := 0;
end;

constructor THelperConfig.Create(AHelperClass: String; AHelperName,
  ADefaultClientID, AClientID: String; AUseDefaultClientID: Boolean);
begin
  Create(AHelperClass);
  HelperName := AHelperName;
  DefaultClientID := ADefaultClientID;
  ClientID := AClientID;
  UseDefaultClientID := AUseDefaultClientID;
end;

procedure THelperConfig.DoChange;
begin
  if assigned(FOnChange) then
    FOnChange(Self, nil, nil);
end;

function THelperConfig.GetFullName: String;
begin
  Result := GetCorrectName(Self.HelperClass);
end;

procedure THelperConfig.LockNotify;
begin
  inc(FLockNotify);
end;

function THelperConfig.PropertyByAppID(AAppID: String;
  AAddIfNotExists: Boolean): THelperAppConfig;
var
  C: THelperAppConfig;
begin
  for C in Self do
  begin
    if SameText(AAppID, C.AppID) then
      exit(C);
  end;
  if AAddIfNotExists then
    Result := AddAppConfig(AAppID)
  else
    Result := nil;
end;

procedure THelperConfig.SetClientID(const Value: String);
begin
  if FClientID <> Value then
  begin
    FClientID := Value;
    DoChange;
  end;
end;

procedure THelperConfig.SetDefaultClientID(const Value: String);
begin
  if FDefaultClientID <> Value then
  begin
    FDefaultClientID := Value;
    DoChange;
  end;
end;

procedure THelperConfig.SetHelperName(const Value: String);
begin
  FHelperName := Value;
end;

procedure THelperConfig.SetOnCHange(const Value: HelperConfigChange);
begin
  FOnChange := Value;
end;

procedure THelperConfig.SetUseDefaultClientID(const Value: Boolean);
begin
  if FUseDefaultClientID <> Value then
  begin
    FUseDefaultClientID := Value;
    DoChange;
  end;
end;

procedure THelperConfig.UnLockNotify;
begin
  Dec(FLockNotify);
end;

{ TManagerConfig }

function TManagerConfig.AddHelperConfig(AHelperClass: String): THelperConfig;
begin
  Result := THelperConfig.Create(AHelperClass);
  Result.OnChange := ConfigChange;
  Self.Add(Result);
end;

function TManagerConfig.AddOrReplaceProperty(AHelperClass: String;
  AHelperName, ADefaultClientID, AClientID: String;
  AUseDefaultClientID: Boolean): THelperConfig;
begin
  Result := PropertyByHelperClass(AHelperClass, True);
  LockNotify;
  try
    Result.HelperName := AHelperName;
    Result.DefaultClientID := ADefaultClientID;
    Result.ClientID := AClientID;
    Result.UseDefaultClientID := AUseDefaultClientID;
  finally
    UnlockNotify;
  end;
  SaveConfig(Result, nil, nil);
end;

procedure TManagerConfig.ConfigChange(Sender: THelperConfig;
  Item: THelperAppConfig; SubItem: THelperAppUserConfig);
begin
  if (FLockNotify = 0) then
    SaveConfig(Sender, Item, SubItem);
end;

constructor TManagerConfig.Create(AFileName: String);
begin
  inherited Create(true);
  FConfigFileName := AFileName;
  LoadConfig;
end;

procedure TManagerConfig.LoadConfig;
var
  ini: TIniFile;
  SL, SL2, SL3: TStringList;
  I, J, k: Integer;
begin
  if FConfigFileName = '' then
    exit;
  LockNotify;
  try
    self.Clear;
    //20190222 Igor >>>
    if FileExists(FConfigFileName) then
      ini := TIniFile.Create(FConfigFileName)
    else
      ini := TIniFile.Create(FPrevConfigFileName);
    //20190222 Igor <<<
    try
      sl := TStringList.Create;
      SL2 := TStringList.Create;
      SL3 := TStringList.Create;
      try
        ini.ReadSection('LIST', SL);
        for I := 0 to SL.Count - 1 do
        begin
          with AddHelperConfig(SL[I]) do
          begin
            HelperName := ini.ReadString(SL[I],'HelperName',SL[I]);
            DefaultClientID := String(uEncrypt.Decrypt(AnsiString(ini.ReadString(SL[I], 'DefaultClientID', '')), c_key));//20170811 Igor
            ClientID := String(uEncrypt.Decrypt(AnsiString(ini.ReadString(SL[I], 'ClientID', '')), c_key));//20170811 Igor
            UseDefaultClientID := ini.ReadBool(SL[I], 'UseDefaultClientID',  ClientID = '');
            SL2.Clear;
            ini.ReadSection(SL[I]+'_LIST', SL2);
            for J := 0 to SL2.Count - 1 do
            begin
              with AddAppConfig(SL2[J]) do
              begin
                SL3.Clear;
                ini.ReadSection(SL[I]+'|'+SL2[J]+'_LIST', SL3);
                for k := 0 to SL3.Count - 1 do
                begin
                  with AddUserConfig(SL3[k]) do
                  begin
                    SaveToken := ini.ReadBool(SL[I]+'|'+SL2[J]+'|'+SL3[k], 'SaveToken', True);
                    Token  := String(Decrypt(AnsiString(ini.ReadString(SL[I]+'|'+SL2[J]+'|'+SL3[k], 'Token','')), c_key));//20170811 Igor
                    Path := String(Decrypt(AnsiString(ini.ReadString(SL[I]+'|'+SL2[J]+'|'+SL3[k], 'Path','')), c_key));//20170811 Igor
                    SaveReturnToCloud := ini.ReadBool(SL[I]+'|'+SL2[J]+'|'+SL3[k], 'SaveReturnToCloud', False);
                  end;
                end;
              end;
            end;
          end;
        end;
      finally
        sl.Free;
        SL2.Free;
        SL3.Free;
      end;
    finally
      ini.Free;
    end;
  finally
    UnlockNotify;
  end;
end;

procedure TManagerConfig.LockNotify;
begin
  inc(FLockNotify);
end;

function TManagerConfig.PropertyByHelperClass(AHelperClass: String;
  AAddIfNotExists: Boolean): THelperConfig;
var
  C: THelperConfig;
begin
  for C in Self do
  begin
    if SameText(AHelperClass, C.HelperClass) then
      exit(C);
  end;
  if AAddIfNotExists then
    Result := AddHelperConfig(AHelperClass)
  else
    Result := nil;
end;

procedure TManagerConfig.Save;
begin
  SaveConfig(nil,nil,nil);
end;

procedure TManagerConfig.SaveConfig(Helper: THelperConfig;
  App: THelperAppConfig; User: THelperAppUserConfig);
var
  ini: TIniFile;
  SL, SL2, SL3: TStringList;
  I, J, k: Integer;
  H: THelperConfig;
  A: THelperAppConfig;
  U: THelperAppUserConfig;
begin
  if FConfigFileName = '' then
    exit;
  ini := TIniFile.Create(FConfigFileName);
  try
    for H in Self do
    begin
      if (H = Helper) or (Helper = nil) then
      begin
        ini.WriteString('LIST', H.HelperClass, H.HelperName);
        ini.WriteString(H.HelperClass, 'HelperName', H.HelperName);
        ini.WriteString(H.HelperClass, 'DefaultClientID', String(Encrypt(AnsiString(H.DefaultClientID), c_key)));//20170811 Igor
        ini.WriteString(H.HelperClass, 'ClientID', String(Encrypt(AnsiString(H.ClientID), c_key)));//20170811 Igor
        ini.WriteBool(H.HelperClass, 'UseDefaultClientID', H.UseDefaultClientID);
        for A in H do
        begin
          if (A = App) or (App = nil) then
          begin
            ini.WriteString(H.HelperClass+'_LIST', A.AppID, A.AppID);
            for U in A do
            begin
              if (U = User) or (User = nil) then
              begin
                ini.WriteString(H.HelperClass+'|'+A.AppID+'_LIST', U.UserName, U.UserName);
                ini.WriteBool(H.HelperClass+'|'+A.AppID+'|'+U.UserName, 'SaveToken', U.SaveToken);
                ini.WriteString(H.HelperClass+'|'+A.AppID+'|'+U.UserName, 'Token', String(Encrypt(AnsiString(U.Token), c_key)));//20170811 Igor
                ini.WriteString(H.HelperClass+'|'+A.AppID+'|'+U.UserName, 'Path', String(Encrypt(AnsiString(U.Path), c_key)));//20170811 Igor
                ini.WriteBool(H.HelperClass+'|'+A.AppID+'|'+U.UserName, 'SaveReturnToCloud', U.SaveReturnToCloud);
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure TManagerConfig.SetConfigFileName(const Value: string); //20190222 Igor
begin
  FPrevConfigFileName := FConfigFileName;
  FConfigFileName := Value;
  LoadConfig;
end;

procedure TManagerConfig.UnLockNotify;
begin
  Dec(FLockNotify);
end;


procedure LoadPluginSettings(AAppID, AUserName: String; AWindow: TForm;
  APageContainer: TPageControl);
var
  ts: TTabSheet;
  frm: TframeManagerHelperSettings;
  I: Integer;
  AllowedCount: Integer; //20190306 Igor
Begin
  if HelperManager.HelperClassList.count = 0 then exit; //20161216 Igor

  //20190306 Igor >>>
  AllowedCount := 0;
  for I := 0 to HelperManager.HelperClassList.count - 1 do
    if HelperManager.ValidateApp(I) then
      Inc(AllowedCount);
  if AllowedCount = 0 then Exit;
  //20190306 Igor <<<

  for I := 0 to HelperManager.HelperClassList.count - 1 do
  begin
    HelperManager.ManagerConfig.PropertyByHelperClass(HelperManager.HelperClassList.Keys.ToArray[I].ClassName).
      PropertyByAppID(AAppID).PropertyByUserName(AUserName);
  end;
  ts := TTabSheet.Create(AWindow);
  ts.PageControl := APageContainer;
  ts.Caption := 'Cloud helper config';
  frm := TframeManagerHelperSettings.Create(AWindow);
  frm.Parent := ts;
  frm.Init(HelperManager.ManagerConfig, AAppID, AUserName);
  frm.ShowAdvanced := False;
End;

procedure SavePluginSettings(AAppID, AUserName: String; AWindow: TForm;
  APageContainer: TPageControl);
begin

end;

procedure LoadPluginActions(AWindow: TForm;
  AMenuContainer: TMainMenu; AOnClickNotify: TNotifyEvent; AOnCreateEvent: TCreateLoadItemEvent);//20171212 Igor
var
  mi: TMenuItemEx;
  m: TMenuItem;
  LPair: TPair<TCloudHelperClass, String>;
  I, Z: Integer;
begin
  //20180113 Igor >>>
  // clear helper items
  for m in AMenuContainer.Items[0] do
  begin
    if m is TMenuItemEx then
      m.Free;
  end;
  //20180113 Igor <<<
  z := 0;
  for m in AMenuContainer.Items[0] do
  begin
    if pos('open', lowerCase(m.Caption)) = 1 then
    begin
      z := m.MenuIndex;
      break;
    end;
  end;
  I := 0;
  for LPair in HelperManager.HelperClassList do
  begin
    //20180113 Igor >>>
    if HelperManager.AllowExecuteOperation(I, haLoadFromCloud) then
    begin
      mi := TMenuItemEx.Create(AWindow);
      mi.Caption := 'Open return from cloud ('+LPair.Value+') ...';
      mi.OnClick := AOnClickNotify;
      mi.HelperID := I;
      mi.HelperAction := haLoadFromCloud;
      mi.Visible := not CheckIsCloud(true); //20200305 Igor
      AMenuContainer.Items[0].Add(mi);
      mi.MenuIndex := Z;
      if Assigned(AOnCreateEvent) then//20171212 Igor
        AOnCreateEvent(mi.Caption, I);//20171212 Igor
    end;
    //20180113 Igor <<<
    inc(I);
  end;
end;

procedure CallBackLog(Sender: TObject; const AEvent: String);
begin
  if assigned(FHelperManager.OnHelperLog) then
    FHelperManager.OnHelperLog(Sender, AEvent);
end;

procedure CallBackDialog(Sender: TObject; AMessageType: THelperMessageType;
    const AMessage: string; var AAnswer: THelperAnswer);
begin
  if assigned(FHelperManager.OnDialog) then
    FHelperManager.OnDialog(Sender, AMessageType, AMessage, AAnswer);
end;

procedure CallBackLocalFileExists(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
Begin
  if assigned(FHelperManager.OnLocalFileExists) then
    FHelperManager.OnLocalFileExists(Sender, AErrorMessage, AFileName, AAnswer);
End;

procedure CallBackLocalFileNotExists(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
Begin
  if assigned(FHelperManager.OnLocalFileNotExists) then
    FHelperManager.OnLocalFileNotExists(Sender, AErrorMessage, AFileName, AAnswer);
End;

procedure CallBackCloudFileExists(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
Begin
  if assigned(FHelperManager.OnCloudFileExists) then
    FHelperManager.OnCloudFileExists(Sender, AErrorMessage, AFileName, AAnswer);
End;

procedure CallBackCloudFileNotExists(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
Begin
  if assigned(FHelperManager.OnCloudFileNotExists) then
    FHelperManager.OnCloudFileNotExists(Sender, AErrorMessage, AFileName, AAnswer);
End;

procedure CallBackDownLoadError(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
Begin
  if assigned(FHelperManager.OnDownLoadError) then
    FHelperManager.OnDownLoadError(Sender, AErrorMessage, AFileName, AAnswer);
End;

procedure CallBackUpLoadError(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
Begin
  if assigned(FHelperManager.OnUpLoadError) then
    FHelperManager.OnUpLoadError(Sender, AErrorMessage, AFileName, AAnswer);
End;

procedure CallBackCheckBytesError(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
Begin
  if assigned(FHelperManager.OnCheckBytesError) then
    FHelperManager.OnCheckBytesError(Sender, AErrorMessage, AFileName, AAnswer);
End;

procedure CallBackSaveLocalFileError(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
Begin
  if assigned(FHelperManager.OnSaveLocalFileError) then
    FHelperManager.OnSaveLocalFileError(Sender, AErrorMessage, AFileName, AAnswer);
End;

procedure CallBackReadLocalFileError(Sender: TObject; const AErrorMessage: string;
    AFileName: string; var AAnswer: THelperAnswer);
Begin
  if assigned(FHelperManager.OnReadLocalFileError) then
    FHelperManager.OnReadLocalFileError(Sender, AErrorMessage, AFileName, AAnswer);
End;

procedure CallbackReturnStringResult(const AString: String);
begin
  SetLength(FHelperManager.FListResult, Length(AString));
  Move(AString, FHelperManager.FListResult, Length(AString));
//  FHelperManager.FListResult := AString;
end;

initialization
  FHelperManager := THelperManager.Create;
  FHelperManager.LoadHelperPlugins;

finalization
  FHelperManager.UnloadHelperPlugin;
  FHelperManager.Free;
end.

