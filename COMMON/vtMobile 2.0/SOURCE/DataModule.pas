unit DataModule;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, System.IOUtils,
  {$IFDEF MSWINDOWS}
  Winapi.ShellAPI,
  FMX.Forms,
  FMX.Types,
  {$ENDIF}
  {$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  Androidapi.JNI.Net,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.App,
  Posix.Unistd,
  {$ENDIF}
  CloudHelperAbstr, CloudHelperFactory, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Comp.UI, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.ZLib,
  System.ImageList, FMX.ImgList;

type
  TCallBackWithStringEvent = procedure(const AException: String) of Object;
  TInplaceViewEvent = procedure(const AFileName: String; var ADone: Boolean) of Object;

  TDownloadThread = class(TThread)
  private
    FURL: String;
    FLocalPath: String;
    FOnWork: TWorkEvent;
    FOnWorkBegin: TWorkBeginEvent;
    FOnWorkEnd: TWorkEndEvent;
    FOnExcption: TCallBackWithStringEvent;
    FCallBack: TCallBackWithStringEvent;
    procedure idWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure idWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure idWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure OnException(const AException: String);
  protected
    procedure Execute; override;
    procedure DoCallBack;
  public
    constructor Create(AURL, ALocalPath: String; AOnWork: TWorkEvent; AOnWorkBegin: TWorkBeginEvent;
      AOnWorkEnd: TWorkEndEvent; AOnExcption: TCallBackWithStringEvent; ACallBack: TCallBackWithStringEvent);
  end;

  TSettings = class
  private
    FFileName: string;
    FSkipWelcome: Boolean;
    FEmail: string;
    FClientID: string;
    FToken: string;
    FSaveToken: Boolean;
    FCloudPath: string;
    FUpdateOnStart: Boolean;
    FCloudHelperClass: TCloudHelperClass;

    FUpdate: Integer;
    FNeedSave: Integer;
    FFirstStart: Boolean;
    FStyle: String;
    procedure SetClientID(const Value: string);
    procedure SetCloudPath(const Value: string);
    procedure SetEmail(const Value: string);
    procedure SetSaveToken(const Value: Boolean);
    procedure SetSkipWelcome(const Value: Boolean);
    procedure SetToken(const Value: string);
    procedure SetUpdateOnStart(const Value: Boolean);
    procedure SetCloudHelperClass(const Value: TCloudHelperClass);

    procedure Load;
    procedure Save;
    procedure SetStyle(const Value: String);
  protected
  public
    constructor Create(AFileName: String);
    property Email: string read FEmail write SetEmail;
    property SkipWelcome: Boolean read FSkipWelcome write SetSkipWelcome;
    property CloudPath: string read FCloudPath write SetCloudPath;
    property ClientID: string read FClientID write SetClientID;
    property SaveToken: Boolean read FSaveToken write SetSaveToken;
    property Token: string read FToken write SetToken;
    property FileName: string read FFileName;
    property UpdateOnStart: Boolean read FUpdateOnStart write SetUpdateOnStart;
    property CloudHelperClass: TCloudHelperClass read FCloudHelperClass write SetCloudHelperClass;
    property Style: String read FStyle write SetStyle;
    property FirstStart: Boolean read FFirstStart;
    procedure BeginUpdate;
    procedure EndUpdate;
  end;

  TdmMain = class(TDataModule)
    conMain: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    qryClients: TFDQuery;
    qryClientsID: TFDAutoIncField;
    qryClientsName: TWideStringField;
    qryDocuments: TFDQuery;
    qryDocumentsID: TFDAutoIncField;
    qryDocumentsClientID: TIntegerField;
    qryDocumentsDocumentName: TStringField;
    qryDocumentsDocumentType: TStringField;
    qryClientsDetail: TWideStringField;
    qryDoc: TFDQuery;
    qryDocDocumentName: TStringField;
    qryDocFileExtension: TStringField;
    qryDocDocumentData: TBlobField;
    IdHTTP1: TIdHTTP;
    ImageList1: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure qryDocumentsBeforeOpen(DataSet: TDataSet);
    procedure qryDocBeforeOpen(DataSet: TDataSet);
  private
    FSettings: TSettings;
    FWorkDir: string;
    FTempDir: String;
    FCloudHelper: TCloudHelperAbstr;
    FStyleFiles: TStringList;
    function GetDataBase: string;
    procedure DoUpdate(const ALocalPath: String);
    procedure ClearTempDir;
    { Private declarations }
  public
    { Public declarations }
    property Settings: TSettings read FSettings;
    property WorkDir: string Read FWorkDir;
    property TempDir: string read FTempDir;
    property DataBase: string read GetDataBase;
    property CloudHelper: TCloudHelperAbstr read FCloudHelper;
    procedure UpdateCloudHelperClass(AClass: TCloudHelperClass);
    procedure FillCloudHelpers(AList: TStrings);
    function GetCloudHelperClass(AClassName: String): TCloudHelperClass;
    procedure Disconnect;
    function Connect: Boolean;
    procedure ShowDocument(AInplaceView: TInplaceViewEvent);
    procedure UpdateProgramm(AOnWork: TWorkEvent; AOnWorkBegin: TWorkBeginEvent;
      AOnWorkEnd: TWorkEndEvent; AOnException: TCallBackWithStringEvent);
    procedure FillStyles(AList: TStrings);
    function StyleFileName(AStyleName: String): String;
  end;

var
  dmMain: TdmMain;

const
  vtAlerthtml = 'http://www.visualtax.com/vtmobile/vtmobilenews.html';
  c_DataBase = 'vtMobile.sdb';
  c_Styles = 'Styles';
  c_styleExt = '.style';
  c_DefaultStyle = 'Default';

implementation


{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TSettings }
const
  c_options = 'OPTIONS';

procedure TSettings.BeginUpdate;
begin
  inc(FUpdate);
end;

constructor TSettings.Create(AFileName: String);
begin
  inherited Create;
  FFileName := AFileName;
  FUpdate := 0;
  FNeedSave := 0;
  FFirstStart := not FileExists(AFileName);
  Load;
end;

procedure TSettings.EndUpdate;
begin
  Dec(FUpdate);
  if (FUpdate <= 0) then
  begin
    if (FNeedSave > 0) or not FileExists(FileName) then
      Save;
    FNeedSave := 0;
  end;
end;

procedure TSettings.Load;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(FFileName);
  try
    FSkipWelcome := ini.ReadBool(c_options, 'SkipWelcome', False);
    FEmail := ini.ReadString(c_options, 'Email', '');
    FToken := ini.ReadString(c_options, 'Token', '');
    FSaveToken := ini.ReadBool(c_options, 'SaveToken', True);
    FCloudPath := ini.ReadString(c_options, 'CloudPath', '');
    FUpdateOnStart := ini.ReadBool(c_options, 'UpdateOnStart', False);
    FCloudHelperClass := TCloudHelperFactory.GetCloudHelperClass(ini.ReadString(c_options, 'CloudHelperClass', 'TCloudHelperDropBox'));
    FClientID := ini.ReadString(c_options, 'ClientID', '');
    if (FClientID = '') and (FCloudHelperClass <> nil) then
      FClientID := FCloudHelperClass.DefaultClientID;
    FStyle := ini.ReadString(c_options, 'Style', c_DefaultStyle);
  finally
    ini.Free;
  end;
end;

procedure TSettings.Save;
var
  ini: TIniFile;
begin
  if FUpdate >0 then
  begin
    inc(FNeedSave);
    Exit;
  end;
  ini := TIniFile.Create(FFileName);
  try
    ini.WriteBool(c_options, 'SkipWelcome', FSkipWelcome);
    ini.WriteString(c_options, 'Email', FEmail);
    ini.WriteString(c_options, 'ClientID', FClientID);
    ini.WriteString(c_options, 'Token', FToken);
    ini.WriteBool(c_options, 'SaveToken', FSaveToken);
    ini.WriteString(c_options, 'CloudPath', FCloudPath);
    ini.WriteBool(c_options, 'UpdateOnStart', FUpdateOnStart);
    ini.WriteString(c_options, 'CloudHelperClass', FCloudHelperClass.HelperName);
    ini.WriteString(c_options, 'Style', FStyle);
  finally
    ini.Free;
  end;
  FNeedSave := 0;
end;

procedure TSettings.SetClientID(const Value: string);
begin
  if FClientID <> Value then
  begin
    FClientID := Value;
    Save;
  end;
end;

procedure TSettings.SetCloudHelperClass(const Value: TCloudHelperClass);
begin
  if FCloudHelperClass <> Value then
  begin
    FCloudHelperClass := Value;
    Save;
  end;
end;

procedure TSettings.SetCloudPath(const Value: string);
begin
  if FCloudPath <> Value then
  begin
    FCloudPath := Value;
    Save;
  end;
end;

procedure TSettings.SetEmail(const Value: string);
begin
  if FEmail <> Value then
  begin
    FEmail := Value;
    Save;
  end;
end;

procedure TSettings.SetSaveToken(const Value: Boolean);
begin
  if FSaveToken <> Value then
  begin
    FSaveToken := Value;
    Save;
  end;
end;

procedure TSettings.SetSkipWelcome(const Value: Boolean);
begin
  if FSkipWelcome <> Value then
  begin
    FSkipWelcome := Value;
    Save;
  end;
end;

procedure TSettings.SetStyle(const Value: String);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Save;
  end;
end;

procedure TSettings.SetToken(const Value: string);
begin
  if FToken <> Value then
  begin
    FToken := Value;
    Save;
  end;
end;

procedure TSettings.SetUpdateOnStart(const Value: Boolean);
begin
  if FUpdateOnStart <> Value then
  begin
    FUpdateOnStart := Value;
    Save;
  end;
end;

procedure FindFiles(AStartDir: String; AList: TStrings; AIncludeDir, ARecurrency: Boolean);
var
  SR: TSearchRec;
  I: Integer;
  Attr: Integer;
begin
  if not Assigned(AList) then
    exit;
  Attr := faAnyFile;
  if not AIncludeDir and not ARecurrency then
    Attr := Attr - faDirectory;
  I := FindFirst(TPath.Combine(AStartDir, '*.*'), Attr, SR);
  try
    while I = 0 do
    begin
      if (SR.Name <> '.') and (SR.Name <> '..') then
      begin
        if (SR.Attr AND faDirectory) = 0 then
          AList.Add(TPath.Combine(AStartDir, SR.Name))
        else
        begin
          if AIncludeDir then
            AList.AddObject(TPath.Combine(AStartDir, SR.Name), TObject(1));
          if ARecurrency then
            FindFiles(TPath.Combine(AStartDir, SR.Name), AList, AIncludeDir, ARecurrency);
        end;
      end;
      I := FindNext(SR);
    end;
  finally
    FindClose(SR);
  end;
end;

procedure TdmMain.ClearTempDir;
var
  SL: TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    FindFiles(FTempDir, SL, True, True);
    for I := 0 to SL.Count - 1 do
    begin
      try
        if SL.Objects[I] = nil then
          DeleteFile(SL[I]);
      except
      end;
    end;
    for I := SL.Count - 1 downto 0 do
    begin
      try
        if Integer(SL.Objects[I]) = 1 then
          RemoveDir(SL[I]);
      except
      end;
    end;
  finally
    SL.Free;
  end
end;

function TdmMain.Connect: Boolean;
begin
  Result := conMain.Connected;
  if not Result then
  begin
    {TODO}
    conMain.DriverName := 'SQLite';
    conMain.Params.Database := DataBase;
    try
      conMain.Connected := True;
    except ON E: Exception do
    end;
    Result := conMain.Connected;
    if Result then
    try
      qryClients.Open;
    except
      conMain.Close;
      Result := False;
    end;
  end;
end;

procedure TdmMain.DataModuleCreate(Sender: TObject);
var
  SettingFileName: string;
begin
  conMain.Connected := False;
  FWorkDir := TPath.Combine(TPath.GetDocumentsPath, 'VisualTaxMobile');
  FTempDir := TPath.Combine(FWorkDir, '~Temp');
  if not ForceDirectories(FWorkDir) or not ForceDirectories(FTempDir) then
    raise Exception.Create('Can''tcreate work directory. Program terminated.');
  SettingFileName := TPath.Combine(FWorkDir, 'setup.ini');
  FSettings := TSettings.Create(SettingFileName);
  FCloudHelper := FSettings.CloudHelperClass.Create;
  {$IFDEF MSWINDOWS}
  FDPhysSQLiteDriverLink1.VendorLib := TPath.Combine(ExtractFilePath(ParamStr(0)), 'sqlite3.dll');
  {$ENDIF}
  FStyleFiles := TStringList.Create;
end;

procedure TdmMain.DataModuleDestroy(Sender: TObject);
begin
  ClearTempDir;
  FSettings.Free;
  FreeAndNil(FCloudHelper);
  FreeAndNil(FStyleFiles);
end;

procedure TdmMain.Disconnect;
begin
  conMain.Connected := False;
end;

procedure TdmMain.DoUpdate(const ALocalPath: String);
var
{$IFDEF ANDROID}
  aFile: Jfile;
  Intent: JIntent;
  FileName: String;
{$ENDIF}
  FileDir: String;
begin
  FileDir := ExtractFileDir(ALocalPath);
{$IFDEF ANDROID}
  FileName := ExtractFileName(ALocalPath);
  aFile := TJfile.JavaClass.init(stringtojstring(FileDir),stringtojstring(FileName));
  Intent := TJIntent.Create ;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.addFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
  Intent.setDataAndType(TJnet_Uri.JavaClass.fromFile(aFile),
    StringToJString('application/vnd.android.package-archive'));
  TAndroidHelper.Context.startActivity(Intent);
{$ENDIF}
{$IFDEF MSWINDOWS}
  ShellExecute(0, PWideChar('open'), PWideChar(ALocalPath), nil, PWideChar(FileDir), 1);
  Application.Terminate;
{$ENDIF}
end;

procedure TdmMain.FillCloudHelpers(AList: TStrings);
begin
  if AList = nil then
    Exit;
  TCloudHelperFactory.FillCloudHelpers(AList);
end;

procedure TdmMain.FillStyles(AList: TStrings);
var
  StylePath: String;
  SL: TStringList;
begin
  if not Assigned(AList) then
    exit;
  AList.Clear;
  AList.Add(c_DefaultStyle);
  SL := TStringList.Create;
  try
    FindFiles(TPath.Combine(WorkDir, c_Styles), SL, False, False);
    for StylePath in SL do
    begin
      if SameText(ExtractFileExt(StylePath), c_styleExt) then
      begin
        AList.Add(ChangeFileExt(ExtractFileName(StylePath), ''));
        FStyleFiles.Add(StylePath);
      end;
    end;
  finally
    SL.Free;
  end;
end;

function TdmMain.GetCloudHelperClass(AClassName: String): TCloudHelperClass;
begin
  Result := TCloudHelperFactory.GetCloudHelperClass(AClassName);
end;

function TdmMain.GetDataBase: string;
begin
  Result := TPath.Combine(FWorkDir, c_DataBase);
end;

procedure TdmMain.qryDocBeforeOpen(DataSet: TDataSet);
begin
  qryDoc.ParamByName('ID').AsInteger := qryDocumentsID.AsInteger;
end;

procedure TdmMain.qryDocumentsBeforeOpen(DataSet: TDataSet);
begin
  qryDocuments.Params.ParamByName('ClientID').AsInteger := qryClientsID.AsInteger;
end;

procedure TdmMain.ShowDocument(AInplaceView: TInplaceViewEvent);
var
  FileName: string;
  Done: Boolean;
{$IFDEF ANDROID}
  Intent: JIntent;
{$ENDIF}
begin
  if dmMain.qryDocuments.IsEmpty then
    Exit;
  qryDoc.Close;
  qryDoc.Open;
  if not sametext(ExtractFileExt(qryDocDocumentName.AsString), '.' + qryDocFileExtension.AsString)  then
    FileName := qryDocDocumentName.AsString + '.' + qryDocFileExtension.AsString
  else
    FileName := qryDocDocumentName.AsString;

  FileName := TPath.Combine(TempDir, FileName);
  if not qryDocDocumentData.IsNull then
    qryDocDocumentData.SaveToFile(FileName);
  Done := False;
  if Assigned(AInplaceView) then
    AInplaceView(FileName, Done);
  if Done then
    exit;

  {$IFDEF ANDROID}
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setDataAndType(StrToJURI('file:///' + FileName),  StringToJString('application/' + qryDocFileExtension.AsString));
  TAndroidHelper.Activity.startActivity(Intent);
  {$ENDIF}
  {$IFDEF  MSWINDOWS}
  ShellExecute(0, 'open', PWideChar(FileName), nil, PWideChar(TPath.GetTempPath), 1);
  {$ENDIF}
end;

function TdmMain.StyleFileName(AStyleName: String): String;
var
  I: Integer;
begin
  for I := 0 to FStyleFiles.Count - 1 do
    if SameText(ChangeFileExt(ExtractFileName(FStyleFiles[I]), ''), AStyleName) then
      Exit(FStyleFiles[I]);
  Result := '';
end;

procedure TdmMain.UpdateCloudHelperClass(AClass: TCloudHelperClass);
begin
  FreeAndNil(FCloudHelper);
  if AClass = nil then
    Exit;
  FCloudHelper := AClass.Create;
end;

procedure TdmMain.UpdateProgramm(AOnWork: TWorkEvent; AOnWorkBegin: TWorkBeginEvent;
  AOnWorkEnd: TWorkEndEvent; AOnException: TCallBackWithStringEvent);
const
  c_DownloadFolder = 'http://visualtax.com/vtmobile/download/';
  c_App = {$IFDEF ANDROID}'vtMobile2.apk'{$ELSE}'vtMobile2Setup.exe'{$ENDIF};
begin
  TDownloadThread.Create(TPath.Combine(c_DownloadFolder, c_App), TPath.Combine(TPath.GetDownloadsPath, c_App),
    AOnWork, AOnWorkBegin, AOnWorkEnd, AOnException, DoUpdate);
end;

{ TDownloadThread }

constructor TDownloadThread.Create(AURL, ALocalPath: String;
  AOnWork: TWorkEvent; AOnWorkBegin: TWorkBeginEvent; AOnWorkEnd: TWorkEndEvent;
  AOnExcption: TCallBackWithStringEvent; ACallBack: TCallBackWithStringEvent);
begin
  inherited Create(False);
  FURL := AURL;
  FLocalPath := ALocalPath;
  FOnWork := AOnWork;
  FOnWorkBegin := AOnWorkBegin;
  FOnWorkEnd := AOnWorkEnd;
  FOnExcption := AOnExcption;
  FCallBack := ACallBack;
  FreeOnTerminate := True;
end;

procedure TDownloadThread.DoCallBack;
begin
  if Assigned(FCallBack) then
    FCallBack(FLocalPath);
end;

procedure TDownloadThread.Execute;
var
  Http: TIdHTTP;
  MS: TMemoryStream;
//  LUnZip: TZDecompressionStream;
//  ResultStream: TMemoryStream;
begin
  try
    if Not ForceDirectories(ExtractFileDir(FLocalPath)) then
    Begin
      raise Exception.Create('Can''t create download folder "'+ExtractFileDir(FLocalPath)+'".');
    end;
    Http := TIdHTTP.Create(nil);
    try
      MS := TMemoryStream.Create;
      try
        Http.HandleRedirects := False;
        Http.OnWork := idWork;
        Http.OnWorkBegin := idWorkBegin;
        Http.OnWorkEnd := idWorkEnd;
        Http.Get(FURL, MS);
        MS.Position := 0;
        MS.SaveToFile(FLocalPath);
        {
        ResultStream := TMemoryStream.Create;
        try
          LUnZip := TZDecompressionStream.Create(MS, 15);
          LUnZip.Position := 0;
          try
            ResultStream.CopyFrom(LUnZip, 0);
          finally
            LUnZip.Free;
          end;
          ResultStream.Position := 0;
          ResultStream.SaveToFile(FLocalPath);
        finally
          ResultStream.Free;
        end;
        }
      finally
        MS.Free;
      end;
    finally
      Http.Free;
    end;
  except ON E: Exception DO
    begin
      OnException(E.Message);
      Exit;
    end;
  end;
  Synchronize(DoCallBack);
end;

procedure TDownloadThread.idWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  if Assigned(FOnWork) then
    Synchronize(
      procedure
      begin
        FOnWork(ASender, AWorkMode, AWorkCount);
      end);
end;

procedure TDownloadThread.idWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  if Assigned(FOnWorkBegin) then
    Synchronize(
      procedure
      begin
        FOnWorkBegin(ASender, AWorkMode, AWorkCountMax);
      end);
end;

procedure TDownloadThread.idWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if Assigned(FOnWorkEnd) then
    Synchronize(
      procedure
      begin
        FOnWorkEnd(ASender, AWorkMode);
      end);
end;

procedure TDownloadThread.OnException(const AException: String);
begin
  if Assigned(FOnExcption) then
    Synchronize(
      procedure
      begin
        FOnExcption(AException);
      end);
end;

end.
