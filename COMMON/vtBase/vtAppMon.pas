unit vtAppMon;

interface

uses
  SysUtils, Classes, vtMulti, vtCommon, IdHTTP, Vcl.Forms, Windows, uADCompClient,
  vtDatabase, System.IOUtils, System.Types, Dialogs, Data.DB, IdSSLOpenSSL, // 20180722 Igor //20191210 Igor
  IdSSLOpenSSLHeaders; //20200804 Igor

type
  TAppMonType = (amtNone, amtOnSave, amtonEfile); // 20180722 Igor
  TAppsMode = (amAll, amNone, amAppsList);
  TKeysMode = (kmAll, kmNone, kmKeysList);
  TDatesMode = (dmAll, dmNone, dmPeriod);

const APPMON_URL = 'http://www.visualtax.com/AppMon/AppMon.xml';
      APPMON_DB = 'Recent.db'; // 20180722 Igor
      SENDLOG_URL = 'http://www.visualtax.com/AppMon/AddLog.php';
      SEND_LOG_TO_SITE = true;
      // Log is sent to site at every run when fLogon is shown. If this is true, then
      // it will be sent immediately after save. However it can create a noticeable delay
      SEND_LOG_AFTER_SAVE = false;

type TAppMon = class(TObject)
  private
    FRetNo: integer;
    FAppMonType: TAppMonType; // 20180722 Igor
    FAppName: string;
    FAppKey: string;
    FLicenseLevel: string; // 20180722 Igor
    FAppsMode: TAppsMode;
    FKeysMode: TKeysMode;
    FDatesMode: TDatesMode;
    FAppsList: TStringList;
    FKeysList: TStringList;
    FExcludedKeysList: TStringList; // 20180722 Igor
    FDateStart, FDateFinal: TDateTime;
    // 20180722 Igor >>>
    FReturnCountLimited: boolean;
    FMaxReturnCount: integer;
    // 20180722 Igor <<<

    FConnection: TADConnection;
    FQuery: TADQuery;

    function GetAppMon: string;
    function CheckDate: boolean;
    function CheckApp: boolean;
    function CheckKey: boolean;
    procedure InitDatabase;

    function GetReturnCount: integer;
  public
    constructor Create;
    destructor Destroy; override; // 20180722 Igor
    procedure InitAppMon(AUpdateXML: boolean);
    function CheckIfNeedLog: boolean;
    procedure SaveLog;
    procedure SendLogs;

    property AppMonType: TAppMonType read FAppMonType; // 20180722 Igor
    property AppsMode: TAppsMode read FAppsMode;
    property KeysMode: TKeysMode read FKeysMode;
    property DatesMode: TDatesMode read FDatesMode;
    property DateStart: TDateTime read FDateStart;
    property DateFinal: TDateTime read FDateFinal;
    property AppsList: TStringList read FAppsList;
    property KeysList: TStringList read FKeysList;
    property ExcludedKeysList: TStringList read FExcludedKeysList; // 20180722 Igor
    property AppName: string read FAppName;
    property AppKey: string read FAppKey;
    // 20180722 Igor >>>
    property LicenseLevel: string read FLicenseLevel;
    property ReturnCountLimited: boolean read FReturnCountLimited;
    property MaxReturnCount: integer read FMaxReturnCount;
    // 20180722 Igor <<<
end;

implementation

uses Xml.XMLDoc, Xml.XMLIntf;

{ TAppMon }

function GetComputerName: string;
var
  buffer: array[0..255] of Char;
  Size: Cardinal;
begin
  Size := 255;
  Windows.GetComputerName(@buffer, Size);
  Result := StrPas(buffer);
end;

function TAppMon.CheckApp: boolean;
begin
  Result := (AppsMode = amAll) or ((AppsMode = amAppsList) and (AppsList.IndexOf(AppName) >= 0));
end;

function TAppMon.CheckDate: boolean;
begin
  Result := (DatesMode = dmAll) or ((DatesMode = dmPeriod) and (Date >= DateStart) and (Date <= DateFinal));
end;

function TAppMon.CheckIfNeedLog: boolean;
begin
  Result := false;
  if not CheckDate then Exit;
  if not CheckApp then Exit;
  if not CheckKey then Exit;
  Result := true;
end;

function TAppMon.CheckKey: boolean;
begin
  // 20180722 Igor >>>
  Result := false;
  if ExcludedKeysList.IndexOf(AppKey) >= 0 then Exit;
  // 20180722 Igor <<<
  Result := (KeysMode = kmAll) or ((KeysMode = kmKeysList) and (KeysList.IndexOf(AppKey) >= 0));
end;

constructor TAppMon.Create;
begin
  FAppsList := TStringList.Create;
  FKeysList := TStringList.Create;
  FExcludedKeysList := TStringList.Create; // 20180722 Igor
  FConnection := TADConnection.create(Application);
  FQuery := TADQuery.create(Application);
end;

destructor TAppMon.Destroy;
begin
  if Assigned(FAppsList) then
    FAppsList.Destroy;
  if Assigned(FKeysList) then
    FKeysList.Destroy;
  // 20180722 Igor >>>
  if Assigned(FExcludedKeysList) then
    FExcludedKeysList.Destroy;
  // 20180722 Igor <<<
  if Assigned(FQuery) then
  begin
    FQuery.Close;
    FQuery.Free;
  end;
  if Assigned(FConnection) then
  begin
    FConnection.Close;
    FConnection.Free;
  end;
  inherited; // 20180722 Igor
end;

function TAppMon.GetAppMon: string;
var HTTP: TIdHTTP;
    SS: TStringStream;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := '';
  try
    SS := TStringStream.Create;
    IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));//20200804 Igor
    HTTP := TIdHTTP.Create(nil);
    IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2]; //20210628 Igor
      HTTP.HandleRedirects := True;
      HTTP.IOHandler := IdSSLIOHandlerSocket;
      HTTP.AllowCookies := True;
      //20190513 Igor >>>
      HTTP.ConnectTimeout := HTTP_TimeOut;
      HTTP.ReadTimeout := HTTP_TimeOut;
      //20190513 Igor <<<
      with HTTP do
      begin
        Request.UserAgent := 'Mozilla/4.0';
        Request.Connection := 'Keep-Alive';
        Request.ProxyConnection := 'Keep-Alive';
        Request.CacheControl := 'no-cache';
      end;
      HTTP.Get(APPMON_URL, SS);
      Result := SS.DataString;
    finally
      IdSSLIOHandlerSocket.Free;
      SS.Free;
      HTTP.Free;
    end;
  except
  end;
end;

function TAppMon.GetReturnCount: integer;
var FileList: TStringDynArray;
    cDir, cFile: string;
    //FTempRetNo: integer; // 20180722 Igor
begin
  Result := 0;
  if FRetNo = 0 then Exit;
  //cDir := RetList[FRetNo].MyApp.Dir_Cur;
  cDir := RetList[FRetNo].SourceDataDir;
  if not DirectoryExists(cDir) then Exit;
  FileList := TDirectory.GetFiles(cDir);
  for cFile in FileList do
  begin
    if not SameText(ExtractFileExt(cFile), '.db') then
      inc(Result);
    {
    try
      FTempRetNo := RetList[FRetNo].MyApp.OpenReturn(RetList[FRetNo].MyApp.Dir_Cur, TPath.GetFileName(cFile), False, False);
      if FTempRetNo > 0 then
      begin
        inc(Result);
        RetList[FTempRetNo].Close(true);
      end;
    except on E: Exception do
      continue;
    end;
    }
  end;
end;

procedure TAppMon.InitAppMon(AUpdateXML: boolean);
var X: XML.XMLDoc.TXMLDocument;
    MainNode, Node: IXMLNode;
    cXML, cValue: string;
    I, J: integer;
    A: TArray<string>;

    function StringToDate(AStr: String; ADefaultDate: TDateTime; AFormat: String = 'YYYY-MM-DD'): TDateTime;
    var
      FS : TFormatSettings;
    begin
      FS := TFormatSettings.Create;
      FS.DateSeparator := '-';
      FS.ShortDateFormat := AFormat;

      Result := StrToDateDef(AStr, ADefaultDate, FS);
    end;

begin
  InitDatabase;
  if not FConnection.Connected then Exit;
//  SqlLoadDBFromFile(FConnection, FQuery, TPath.Combine(ExeDir, APPMON_DB), '');
  if AUpdateXML then
    cXML := GetAppMon;
  FAppsMode := amNone;
  FKeysMode := kmNone;
  FDatesMode := dmNone;
  FDateStart := Date;
  FDateFinal := Date;
  FAppName := '';
  FAppKey := '';
  if not SameText(cXML, '') then
  begin
    X := XML.XMLDoc.TXMLDocument.Create(Application);
    try
      try
        X.XML.Clear;
        X.XML.Add(cXML);
        if not (X.Active) then
          X.Active := true;
        MainNode := X.DocumentElement;
        if not Assigned(MainNode) or not SameText(MainNode.NodeName, 'APPMON') then
          Exit;
		// 20180722 Igor >>>
        // AppMonType
        Node := MainNode.ChildNodes.FindNode('APPMONTYPE');
        cValue := Trim(Node.NodeValue);
        if SameText(cValue, 'OnSave') then
          FAppMonType := amtOnSave
        else if SameText(cValue, 'OnEfile') then
          FAppMonType := amtOnEfile
        else
          FAppMonType := amtNone;
        // 20180722 Igor <<< 
        // Apps
        Node := MainNode.ChildNodes.FindNode('APPNAMES');
        if Node <> nil then
        begin
          for I := 0 to Node.ChildNodes.Count - 1 do
            if SameText(Node.ChildNodes.Nodes[I].NodeName, 'ELEMENT') then
            begin
              cValue := Trim(Node.ChildNodes.Nodes[I].NodeValue);
              if SameText(cValue, 'ALL') then
                FAppsMode := amAll
              else if SameText(cValue, 'NONE') then
                FAppsMode := amNone
              else
              begin
                FAppsMode := amAppslist;
                A := cValue.Split([','], ExcludeEmpty);
                for J := 0 to Length(A) - 1 do
                  FAppsList.Add(Trim(UpperCase(A[J])));
              end;
            end;
        end;
        // Keys
        Node := MainNode.ChildNodes.FindNode('PGMKEYS');
        if Node <> nil then
        begin
          for I := 0 to Node.ChildNodes.Count - 1 do
            if SameText(Node.ChildNodes.Nodes[I].NodeName, 'ELEMENT') then
            begin
              cValue := Trim(Node.ChildNodes.Nodes[I].NodeValue);
              if SameText(cValue, 'ALL') then
                FKeysMode := kmAll
              else if SameText(cValue, 'NONE') then
                FKeysMode := kmNone
              else
              begin
                FKeysMode := kmKeyslist;
                A := cValue.Split([','], ExcludeEmpty);
                for J := 0 to Length(A) - 1 do
                  FKeysList.Add(Trim(UpperCase(A[J])));
              end;
            end;
        end;
		// 20180722 Igor >>>
        // Excluded Keys
        Node := MainNode.ChildNodes.FindNode('EXCLUDEDPGMKEYS');
        if Node <> nil then
        begin
          for I := 0 to Node.ChildNodes.Count - 1 do
            if SameText(Node.ChildNodes.Nodes[I].NodeName, 'ELEMENT') then
            begin
              cValue := Trim(Node.ChildNodes.Nodes[I].NodeValue);
              if SameText(cValue, 'NONE') then
                FExcludedKeysList.Clear
              else
              begin
                A := cValue.Split([','], ExcludeEmpty);
                for J := 0 to Length(A) - 1 do
                  FExcludedKeysList.Add(Trim(UpperCase(A[J])));
              end;
            end;
        end;
        // 20180722 Igor <<<
        // Dates
        Node := MainNode.ChildNodes.FindNode('DATES');
        if Node <> nil then
        begin
          for I := 0 to Node.ChildNodes.Count - 1 do
          begin
            cValue := Trim(Node.ChildNodes.Nodes[I].NodeValue);
            if SameText(Node.ChildNodes.Nodes[I].NodeName, 'ELEMENT') then
            begin
              if SameText(cValue, 'ALL') then
                FDatesMode := dmAll
              else if SameText(cValue, 'NONE') then
                FDatesMode := dmNone;
            end
            else if SameText(Node.ChildNodes.Nodes[I].NodeName, 'FROM') then
            begin
              FDatesMode := dmPeriod;
              FDateStart := StringToDate(cValue, Date);
            end
            else if SameText(Node.ChildNodes.Nodes[I].NodeName, 'TO') then
            begin
              FDatesMode := dmPeriod;
              FDateFinal := StringToDate(cValue, Date);
            end;
          end;
        end;
        FQuery.Close;
        FQuery.SQL.text := 'SELECT * FROM AppMonData';
        FQuery.Open;
        if FQuery.RecordCount = 0 then
          FQuery.Append
        else
          FQuery.Edit;
        FQuery.FieldByName('AppMonType').Value := Integer(AppMonType); // 20180722 Igor
        FQuery.FieldByName('AppsMode').Value := Integer(AppsMode);
        FQuery.FieldByName('AppsList').Value := AppsList.Text;
        FQuery.FieldByName('KeysMode').Value := Integer(KeysMode);
        FQuery.FieldByName('KeysList').Value := KeysList.Text;
        FQuery.FieldByName('ExcludedKeysList').Value := ExcludedKeysList.Text; // 20180722 Igor
        FQuery.FieldByName('DatesMode').Value := Integer(DatesMode);
        FQuery.FieldByName('DateStart').Value := DateStart;
        FQuery.FieldByName('DateFinal').Value := DateFinal;
        FQuery.Post;
      except
      end;
    finally
      X.Free;
    end;
  end
  else
  begin
    // load previously saved data
    FQuery.Close;
    FQuery.SQL.text := 'SELECT * FROM AppMonData';
    FQuery.Open;
    if FQuery.RecordCount > 0 then
    begin
      FAppMonType := TAppMonType(FQuery.FieldByName('AppMonType').AsInteger); // 20180722 Igor
      FAppsMode := TAppsMode(FQuery.FieldByName('AppsMode').AsInteger);
      FAppsList.Text := FQuery.FieldByName('AppsList').AsString;
      FKeysMode := TKeysMode(FQuery.FieldByName('KeysMode').AsInteger);
      FKeysList.Text := FQuery.FieldByName('KeysList').AsString;
      FExcludedKeysList.Text := FQuery.FieldByName('ExcludedKeysList').AsString; // 20180722 Igor
      FDatesMode := TDatesMode(FQuery.FieldByName('DatesMode').AsInteger);
      FDateStart := FQuery.FieldByName('DateStart').AsDateTime;
      FDateFinal := FQuery.FieldByName('DateFinal').AsDateTime;
    end;
    FQuery.Close;
  end;
  FRetNo := GetCurrentRetNo;
  if FRetNo <> 0 then
  begin
    FAppName := Trim(UpperCase(RetList[FRetNo].MyApp.AppName + '-' + RetList[FRetNo].MyApp.AppYear));
    FAppKey := Trim(UpperCase(LicenseList.Keys[AppName]));
    // 20180722 Igor >>>
    FReturnCountLimited := false;
    FMaxReturnCount := 0;
    case RetList[FRetNo].MyApp.LicenseLevel of
      llNone: FLicenseLevel := 'None';
      llDemo: FLicenseLevel := 'Demo';
      llHome: FLicenseLevel := 'Home';
      llLimited: FLicenseLevel := 'Limited';
      llLimEfile: FLicenseLevel := 'Limited Efile';
      llStd: FLicenseLevel := 'Standart';
      llPower: FLicenseLevel := 'Power';
      llMulti: FLicenseLevel := 'Multi';
      llMultiPower: FLicenseLevel := 'Multi Power';
      llAgStd: FLicenseLevel := 'Ag Standart';
      llAgPower: FLicenseLevel := 'Ag Power';
      llDealer: FLicenseLevel := 'Dealer';
      llLimited1Returns: begin
        FLicenseLevel := 'Limited 1 Return';
        FReturnCountLimited := true;
        FMaxReturnCount := 1;
      end;
      llLimited2Returns: begin
        FLicenseLevel := 'Limited 2 Returns';
        FReturnCountLimited := true;
        FMaxReturnCount := 2;
      end;
      llLimited3Returns: begin
        FLicenseLevel := 'Limited 3 Returns';
        FReturnCountLimited := true;
        FMaxReturnCount := 3;
      end;
      llLimited4Returns: begin
        FLicenseLevel := 'Limited 4 Returns';
        FReturnCountLimited := true;
        FMaxReturnCount := 4;
      end;
      llLimited5Returns: begin
        FLicenseLevel := 'Limited 5 Returns';
        FReturnCountLimited := true;
        FMaxReturnCount := 5;
      end;
      // 20180830 Igor >>>
      llLimited6Returns: begin
        FLicenseLevel := 'Limited 6 Returns';
        FReturnCountLimited := true;
        FMaxReturnCount := 6;
      end;
      // 20180830 Igor <<<
      llLimitedForms: FLicenseLevel := 'Limited Forms';
    end;
    // 20180722 Igor <<<
  end;
end;

procedure TAppMon.InitDatabase;
begin
  FConnection.LoginPrompt := False;
  FConnection.DriverName := 'SQLite';
  FConnection.Params.Values['Database'] := TPath.Combine(ExeDir, APPMON_DB);
  FConnection.Params.Values['Password'] := '';
  if not TFile.Exists(TPath.Combine(ExeDir, APPMON_DB)) then
  begin
    try
      FConnection.Connected := True;
	  // 20180722 Igor >>>
      FConnection.ExecSQL(
        ' CREATE TABLE AppMonData ( '+ #13#10 +
        '     Id                INTEGER        PRIMARY KEY AUTOINCREMENT '+ #13#10 +
        '                                      UNIQUE '+ #13#10 +
        '                                      NOT NULL, '+ #13#10 +
        '     AppMonType        INTEGER, '+ #13#10 +
        '     AppsMode          INTEGER, '+ #13#10 +
        '     AppsList          VARCHAR (2000), '+ #13#10 +
        '     KeysMode          INTEGER, '+ #13#10 +
        '     KeysList          VARCHAR (255), '+ #13#10 +
        '     ExcludedKeysList  VARCHAR (255), '+ #13#10 +
        '     DatesMode         INTEGER, '+ #13#10 +
        '     DateStart         DATETIME, '+ #13#10 +
        '     DateFinal         DATETIME '+ #13#10 +
        ' );');
      FConnection.ExecSQL(
        ' CREATE TABLE SaveLog ( '+ #13#10 +
        '     Id                   INTEGER       PRIMARY KEY AUTOINCREMENT '+ #13#10 +
        '                                        UNIQUE '+ #13#10 +
        '                                        NOT NULL, '+ #13#10 +
        '     AppName              VARCHAR (10), '+ #13#10 +
        '     AppKey               VARCHAR (19), '+ #13#10 +
        '     LicenseLevel         VARCHAR (255), '+ #13#10 +
        '     ReturnCountLimited   BOOLEAN, '+ #13#10 +
        '     MaxReturnCount       INTEGER, '+ #13#10 +
        '     EventDate            DATETIME, '+ #13#10 +
        '     ComputerName         VARCHAR (255), '+ #13#10 +
        '     PreparerName         VARCHAR (255), '+ #13#10 +
        '     PreparerAddress      VARCHAR (255), '+ #13#10 +
        '     ReturnCount          INTEGER, '+ #13#10 +
        '     FileName             VARCHAR (255), '+ #13#10 +
        '     EfileNumber          VARCHAR (20), '+ #13#10 +
        '     TaxationYear         VARCHAR, '+ #13#10 +
        '     SentToSite           BOOLEAN, '+ #13#10 +
        '     AdditionalInfo       VARCHAR (500) '+ #13#10 +
        ' );');
      // 20180722 Igor <<<
    except on E: Exception do
      FConnection.Connected := False;
    end;
  end
  else
    FConnection.Connected := True;
  FQuery.Connection:= FConnection;
  {$WARN SYMBOL_PLATFORM OFF}
  FileSetAttr(TPath.Combine(ExeDir, APPMON_DB), faHidden);
  {$WARN SYMBOL_PLATFORM ON}
end;

procedure TAppMon.SaveLog;
begin
  if FRetNo = 0 then Exit;
  FQuery.Close;
  FQuery.SQL.Text := 'SELECT * FROM SaveLog WHERE FileName = :FileName AND AppName = :AppName';
  FQuery.ParamByName('FileName').Value := RetList[FRetNo].SourceFlName;
  FQuery.ParamByName('AppName').Value := AppName;
  FQuery.Open;
  if FQuery.RecordCount > 0 then Exit;
  FQuery.Append;
  FQuery.FieldByName('SentToSite').Value := false;
  FQuery.FieldByName('AppName').Value := AppName;
  FQuery.FieldByName('AppKey').Value := AppKey;
  // 20180722 Igor >>>
  FQuery.FieldByName('LicenseLevel').Value := LicenseLevel;
  FQuery.FieldByName('ReturnCountLimited').Value := ReturnCountLimited;
  FQuery.FieldByName('MaxReturnCount').Value := MaxReturnCount;
  // 20180722 Igor <<<
  FQuery.FieldByName('EventDate').Value := Now;
  FQuery.FieldByName('ComputerName').Value := GetComputerName;
  FQuery.FieldByName('PreparerName').Value := RetList[FRetNo].MyApp.Prp_Name;
  FQuery.FieldByName('PreparerAddress').Value := RetList[FRetNo].MyApp.Prp_Street +
                                              ' ' +
                                              RetList[FRetNo].MyApp.Prp_City +
                                              ' ' +
                                              RetList[FRetNo].MyApp.Prp_Postal;
  FQuery.FieldByName('ReturnCount').Value := GetReturnCount;
  FQuery.FieldByName('FileName').Value := RetList[FRetNo].SourceFlName;
  FQuery.FieldByName('EfileNumber').Value := RetList[FRetNo].MyApp.EfilerNumber;
  FQuery.FieldByName('TaxationYear').Value := RetList[FRetNo].MyApp.TaxationYear;
  FQuery.FieldByName('AdditionalInfo').Value := RetList[FRetNo].MyApp.AdditionalInfo;
  FQuery.Post;
  FQuery.Close;
  if SEND_LOG_AFTER_SAVE then
    SendLogs;
end;

procedure TAppMon.SendLogs; //20191210 Igor
var
  HTTP: TIdHTTP;
  ParamList: TStringList;
  I: integer;
  cResult: string;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  if not SEND_LOG_TO_SITE then Exit;
  if not FConnection.Connected then Exit;
  if SameText(GetComputerName, 'WIN-KH407I4ESEI') then Exit; // 20180830 Igor do not send from dev comp to site
  HTTP := TIdHTTP.Create;
  //20190513 Igor >>>
  HTTP.ConnectTimeout := HTTP_TimeOut;
  HTTP.ReadTimeout := HTTP_TimeOut;
  //20190513 Igor <<<
  ParamList := TStringList.Create;
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    FQuery.Close;
    // 20180722 Igor >>>
    FQuery.SQL.Text :=
      ' SELECT Id, AppName, AppKey, LicenseLevel, CAST(ReturnCountLimited AS VARCHAR) AS ReturnCountLimited, MaxReturnCount, '+
      '   strftime(''%Y-%m-%d %H:%M:%S'', EventDate) as EventDate, ComputerName, PreparerName, PreparerAddress, '+
      '   ReturnCount, FileName, EfileNumber, TaxationYear, AdditionalInfo '+
      ' FROM SaveLog '+
      ' WHERE SentToSite = 0';
    // 20180722 Igor <<<
    FQuery.Open;
    while not FQuery.Eof do
    begin
      ParamList.Clear;
      for I := 0 to FQuery.FieldCount - 1 do
      begin
        if not SameText(FQuery.Fields.Fields[I].FieldName, 'Id') then
          ParamList.Add(FQuery.Fields.Fields[I].FieldName + '=' + FQuery.Fields.Fields[I].AsString);
      end;

      try
        cResult := HTTP.Post(SENDLOG_URL, ParamList);
		// 20180722 Igor >>>
        if SameText(cResult, 'OK') then
        begin
//          FConnection.ExecSQL(
//            ' UPDATE SaveLog '+
//            ' SET SentToSite = 1 '+
//            ' WHERE Id = '+ IntToStr(FQuery.FieldByName('Id').AsInteger));
          FConnection.ExecSQL(
            ' DELETE FROM SaveLog '+
            ' WHERE Id = '+ IntToStr(FQuery.FieldByName('Id').AsInteger));
        end;
        // 20180722 Igor <<<
      except
        Exit;
      end;

      FQuery.Next;
    end;
    FConnection.ExecSQL('VACUUM;'); // 20180722 Igor
  finally
    HTTP.Free; ParamList.Free;
    IdSSLIOHandlerSocket.Free;
  end;
end;

end.
