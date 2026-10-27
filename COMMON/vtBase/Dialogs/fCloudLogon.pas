unit fCloudLogon;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, vtShape, Vcl.ExtCtrls, vtDemoUserDB,
  vtSQLiteDemoUserDB, IdHTTP, IdSSLOpenSSL; // 20180917 Igor //20191210 Igor

const
  UM_LOGON = WM_USER + 100; //20190109 Igor

type
  TfrmCloudLogon = class(TForm)
    Image3: TImage;
    vtShape6: TvtShape;
    Label16: TLabel;
    Label14: TLabel;
    lbProgramId: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    lblName: TLabel;
    edtName: TEdit;
    lblEmail: TLabel;
    edtEmail: TEdit;
    lblPhone: TLabel;
    edtPhone: TEdit;
    btnGetDemoKey: TButton;
    lblKey: TLabel;
    edtKey: TEdit;
    btnLogon: TButton;
    lblinstruction: TLabel;
    lblNewUser: TLabel;
    Label2: TLabel;
    btnClose: TButton;
    procedure lblinstructionClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLogonClick(Sender: TObject);
    procedure btnGetDemoKeyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtEmailChange(Sender: TObject);
    procedure edtKeyChange(Sender: TObject);
  private
    FYear: string; // 20180917 Igor
    FUserDB: TDemoUserDB;
    FUserDir: string;
    FUserDataDir: string; //20190213 Igor
    procedure UMLogon(var Message: TMessage); message UM_LOGON; //20190109 Igor
  public
    property UserDir: string read FUserDir;
    property UserDataDir: string read FUserDataDir; //20190213 Igor
  end;

var
  frmCloudLogon: TfrmCloudLogon;
  UniqueInstanceMutexHandle: THandle;

//20190523 Igor >>>
function StartLogSession(AName, AEmail, APhone: string): integer;
procedure KeepAliveSession(ACloudId: integer);
//20190523 Igor <<<

implementation

uses vtDialogs, vtMulti, System.RegularExpressions, Xml.XMLDoc, Xml.XMLIntf, StrUtils; // 20180917 Igor

{$R *.dfm}

function StartLogSession(AName, AEmail, APhone: string): integer; //20190523 Igor //20191210 Igor
var HTTP: TIdHTTP;
    ParamList: TStringList;
    I: integer;
    cResult, cDir, cName, cTemp: string;
    X: XML.XMLDoc.TXMLDocument;
    Node, NodeCloudId: IXMLNode;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := 0;
  HTTP := TIdHTTP.Create;
  ParamList := TStringList.Create;
  cResult := '';
  cDir := '';
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    ParamList.Clear;
    ParamList.Add('CLOUDKEY=' + StartParams.CloudKey);
    ParamList.Add('PREPARERNAME=' + AName);
    ParamList.Add('EMAIL=' + AEmail);
    ParamList.Add('PHONE=' + APhone);
    try
      cResult := HTTP.Post('http://visualtax.com/CloudLog/start_log.php', ParamList);
    except on E: Exception do
      ShowMessage('Error occured while checking key: '+ E.Message);
    end;
  finally
    IdSSLIOHandlerSocket.Free;
    HTTP.Free;
    ParamList.Free;
  end;
  if SameText(cResult, '') then Exit;
  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try
      X.XML.Clear;
      X.XML.Add(cResult);
      if not(X.Active) then
        X.Active := true;
      Node := X.DocumentElement;
      if (Node = nil) or (Node.NodeName <> 'RESULTS') then
        raise Exception.Create('Bad Response XML structure: ' + cResult);
      NodeCloudId := Node.ChildNodes.FindNode('CLOUDID');
      if (NodeCloudId = nil) then
        raise Exception.Create('Bad Response XML structure: ' + cResult);
      Result := StrToIntDef(NodeCloudId.NodeValue, 0);
     except on E: Exception do
      ShowMessage('Error occured while parsing XML response: '+ E.Message);
    end;
  finally
    X.Free;
  end;
end;

procedure KeepAliveSession(ACloudId: integer); //20190523 Igor //20191210 Igor
var HTTP: TIdHTTP;
    ParamList: TStringList;
    cResult: string;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  HTTP := TIdHTTP.Create;
  ParamList := TStringList.Create;
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    ParamList.Clear;
    ParamList.Add('CLOUDID=' + IntToStr(ACloudId));
    try
      cResult := HTTP.Post('http://visualtax.com/CloudLog/keep_alive.php', ParamList);
    except on E: Exception do
      ShowMessage('Error occured while checking key: '+ E.Message);
    end;
  finally
    IdSSLIOHandlerSocket.Free;
    HTTP.Free;
    ParamList.Free;
  end;
end;

function IsNextInstance(AKey: string): BOOLEAN; //20190429 Igor
var cName: string;
begin
  Result := FALSE;
  UniqueInstanceMutexHandle := 0;
  cName := ReplaceStr(AKey, '\', '_');
  UniqueInstanceMutexHandle := CREATEMUTEX(nil, TRUE, PChar('Global\Mutex_'+ cName));
  if UniqueInstanceMutexHandle <> 0 then
  begin
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      Result := TRUE;
      CLOSEHANDLE(UniqueInstanceMutexHandle);
      UniqueInstanceMutexHandle := 0;
    end;
  end;
end;

procedure TfrmCloudLogon.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmCloudLogon.btnGetDemoKeyClick(Sender: TObject);
var
  aPass: string;
begin
  if FUserDB.AddUser(LowerCase(edtEmail.Text), edtPhone.Text, edtName.Text) then // 20180904 Igor
  begin
    ShowMessage('Check you email for logon key. Paste logon key in "Key" control and press "Logon" button.');
  end else
    ShowMessage(FUserDB.LastError);
end;

procedure TfrmCloudLogon.btnLogonClick(Sender: TObject); // 20180917 Igor //20191210 Igor
var HTTP: TIdHTTP;
    ParamList: TStringList;
    I: integer;
    cResult, cDir, cName: string; //20190429 Igor
    X: XML.XMLDoc.TXMLDocument;
    Node, NodeResult: IXMLNode;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  HTTP := TIdHTTP.Create;
  ParamList := TStringList.Create;
  cResult := '';
  cDir := '';
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    ParamList.Clear;
    ParamList.Add('key=' + Trim(edtKey.Text)); //20190523 Igor
    ParamList.Add('year=' + FYear);
    try
      cResult := HTTP.Post('http://visualtax.com/Cloud/check_key.php', ParamList);
    except on E: Exception do
      ShowMessage('Error occured while checking key: '+ E.Message);
    end;
  finally
    IdSSLIOHandlerSocket.Free;
    HTTP.Free;
    ParamList.Free;
  end;
  if SameText(cResult, '') then Exit;
  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try
      X.XML.Clear;
      X.XML.Add(cResult);
      if not(X.Active) then
        X.Active := true;
      Node := X.DocumentElement;
      if (Node = nil) or (Node.NodeName <> 'RESULTS') then
        raise Exception.Create('Bad Response XML structure: ' + cResult);
      NodeResult := Node.ChildNodes.FindNode('RESULT');
      if (NodeResult = nil) then
        raise Exception.Create('Bad Response XML structure: ' + cResult);
      if not SameText(NodeResult.NodeValue, 'OK') then
      begin
        ShowMessage('The key is incorrect, verify that you have the correct key, and then retype it');
        Exit;
      end;
      for I := 0 to Node.ChildNodes.Count - 1 do
      begin
        if SameText(Node.ChildNodes.Nodes[I].NodeName, 'RESULT') then
          continue
        else if SameText(Node.ChildNodes.Nodes[I].NodeName, 'CLOUDDIR') then
          FUserDir := VarToStr(Node.ChildNodes.FindNode('CLOUDDIR').NodeValue) //20190308 Igor
        //20190213 Igor >>>
        else if SameText(Node.ChildNodes.Nodes[I].NodeName, 'CLOUDDATADIR') then
          FUserDataDir := VarToStr(Node.ChildNodes.FindNode('CLOUDDATADIR').NodeValue) //20190308 Igor
        //20190213 Igor <<<
        //20190429 Igor >>>
        else if SameText(Node.ChildNodes.Nodes[I].NodeName, 'NAME') then
          cName := VarToStr(Node.ChildNodes.FindNode('NAME').NodeValue)
        //20190429 Igor <<<
        else
          StartParams.StartKeys.AddOrSetValue(UpperCase(Node.ChildNodes.Nodes[I].NodeName), VarToStr(Node.ChildNodes.Nodes[I].NodeValue));
      end;
      if SameText(FUserDir, '') then
      begin
        ShowMessage('Cloud directory is not specified for this key!');
        Exit;
      end;
      //20190213 Igor >>>
      if SameText(FUserDir, FUserDataDir) then
        FUserDataDir := '';
      //20190213 Igor <<<
      //20190429 Igor >>>
      if (Pos('MICROSOPHIC', UpperCase(cName)) = 0)
         and
         (Pos('KUKHTIN', UpperCase(cName)) = 0) then
      begin
        if IsNextInstance(edtKey.Text) then
        begin
          ShowMessage('Another user is logged in with the same Login key. Try later!');
          Exit;
        end;
      end
      else
        StartParams.IsAdmin := true;
      //20190429 Igor <<<
      StartParams.CloudKey := Trim(edtKey.Text); //20190523 Igor

      ModalResult := mrOk;
    except on E: Exception do
      ShowMessage('Error occured while parsing XML response: '+ E.Message);
    end;
  finally
    X.Free;
  end;


  {
  if FUserDB.LogOn(edtKey.Text) then
  begin
    if not FUserDB.GetExeDir(edtKey.Text, FUserDir) then
      ShowMessage(FUserDB.LastError);
    ModalResult := mrOk;
//    Close; //20180503 Igor
  end else
    ShowMessage(FUserDB.LastError);
  }
end;

procedure TfrmCloudLogon.edtEmailChange(Sender: TObject);
begin
  btnGetDemoKey.Enabled := TRegEx.IsMatch(edtEmail.Text,
  '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*|"((?=[\x01-\x7f])'
             +'[^"\\]|\\[\x01-\x7f])*"\x20*)*(?<angle><))?((?!\.)'
             +'(?>\.?[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])'
             +'[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\-]+(?<!-)\.)+[a-zA-Z]'
             +'{2,}|\[(((?(?<!\[)\.)(25[0-5]|2[0-4]\d|[01]?\d?\d))'
             +'{4}|[a-zA-Z\d\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|\\'
             +'[\x01-\x7f])+)\])(?(angle)>)$') and (trim(edtName.Text) <> '')
             and (trim(edtPhone.Text) <> '');
end;

procedure TfrmCloudLogon.edtKeyChange(Sender: TObject);
begin
  btnLogon.Enabled := trim(edtKey.Text) <> '';
end;

procedure TfrmCloudLogon.FormDestroy(Sender: TObject);
begin
  FUserDB.Free;
end;

procedure TfrmCloudLogon.FormShow(Sender: TObject); // 20180917 Igor
{var
  v: Variant;}
begin
  case vtMulti.InternalExeYear of
    iey2015 : FYear := '2015';
    iey2016 : FYear := '2016';
    iey2017 : FYear := '2017';
    iey2018 : FYear := '2018';
    iey2019 : FYear := '2019';
    iey2020 : FYear := '2020'
    else FYear := 'NONE';
  end;
  lbProgramId.Caption := 'VT-' + FYear;
  btnGetDemoKey.Enabled := False;
  btnLogon.Enabled := False;
  //FUserDB := TDemoUserDB.Create(TSQLiteDemoUserDB.Create, ExtractFileDir(Application.ExeName) + '\virtualui.db', v, True);
  //20190109 Igor >>>
  if ParamCount() > 1 then
  begin
    edtKey.Text := ParamStr(2);
    PostMessage(Handle, UM_LOGON, 0, 0);
  end;
  //20190109 Igor <<<
end;

procedure TfrmCloudLogon.lblinstructionClick(Sender: TObject);
begin
  ShowHelp(RedesignFile, 'CloudLogon', true);
end;

procedure TfrmCloudLogon.UMLogon(var Message: TMessage); //20190109 Igor
begin
  btnLogonClick(nil);
end;

//20190429 Igor >>>
initialization

finalization
  if UniqueInstanceMutexHandle <> 0 then
    CLOSEHANDLE(UniqueInstanceMutexHandle);
//20190429 Igor <<<

end.