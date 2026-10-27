unit T2_2027ftpfrm;
//imported 08-02
interface

uses Windows,Messages,SysUtils,Classes,Graphics,Forms,Dialogs,FileCtrl,shellapi,
  ComCtrls,StdCtrls, {Psock,} IdFtp, Controls,Buttons, //20150624
  ExtCtrls, IdGlobal, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase;


type
  TFtpFrmT2_2027 = class(TForm)
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Panel2: TPanel;
    ProxyPanel: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    CheckBox1: TCheckBox;
    Edit6: TEdit;
    Edit7: TEdit;
    ButtonPanel: TPanel;
    DownloadBtn: TButton;
    AbortBtn: TButton;
    CheckUpdatesBtn: TBitBtn;
    //IdFTP1: TIdFTP; //20150624
    Button1: TButton;
    IdFTP1: TIdFTP;

    {procedure ApplyUpdate(UpdFileName:String);}
    procedure ConnectToFtpSite;

    //20150624
    //procedure NMFTP1Success(Trans_Type: TCmdType);
    procedure IdFTP1Status(ASender: TObject; const AStatus: TIdStatus;
        const AStatusText: string);

    //procedure IdFTP1PacketRecvd(Sender: TObject); //20150624
    procedure IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);

    procedure AbortBtnClick(Sender: TObject);
    procedure DownloadBtnClick(Sender: TObject);

    // 20150624
    //procedure NMFTP1Connect(Sender: TObject);
    procedure IdFTP1Connected(Sender: TObject);

    //20150624
    //procedure NMFTP1Failure(var handled: Boolean; Trans_Type: TCmdType);

    //20150624
    {procedure NMFTP1TransactionStop(Sender: TObject);
    procedure NMFTP1HostResolved(Sender: TComponent);
    procedure NMFTP1InvalidHost(var handled: Boolean);
    procedure NMFTP1PacketSent(Sender: TObject);
    procedure NMFTP1TransactionStart(Sender: TObject);}

    //20150624
    //procedure NMFTP1Disconnect(Sender: TObject);
    procedure IdFTP1Disconnected(Sender: TObject);

    //20150624
    {procedure NMFTP1Error(Sender: TComponent; Errno: Word; Errmsg: String);
    procedure NMFTP1Status(Sender: TComponent; Status: String);}

    //procedure NMFTP1UnSupportedFunction(Trans_Type: TCmdType); //20150622
    procedure NMFTP1ConnectionFailed(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure CheckUpdatesBtnClick(Sender: TObject); //20150622
    procedure CancelBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WorldButtonClick(Sender: TObject);
  private
    RemoteDir,LocalDir,ProgramDir:String;
    UpdControlFile,UpdFileName:String;
  public
    { Public declarations }
  end;

var
  FtpFrm: TFtpFrmT2_2027;


implementation

{$R *.DFM}

uses
  vtCommon,
  T2_2027,T2_2027Declare,T2_2027TrimStr,
  vtTrimStr, vtShared;

var
  Q: Integer;


procedure TFtpFrmT2_2027.FormCreate(Sender: TObject);
var
  P1,P2:String;
begin
  DownloadBtn.Enabled:=False;
  P1:= 'vgpl';
  If UpperCase(LeftStr(AppName,2)) = 'T1' then
    UpdControlFile := 'T1'+'LastUpd.txt'
  else
  if UpperCase(LeftStr(AppName,2)) = 'T2' then
    UpdControlFile := 'T2'+'LastUpd.txt'
  else
  If UpperCase(LeftStr(AppName,2)) = 'TF' then
    UpdControlFile := 'TF'+'LastUpd.txt'
  else
  If UpperCase(LeftStr(AppName,2)) = 'T4' then
    UpdControlFile := 'T4'+'LastUpd.txt'
  else
  If UpperCase(LeftStr(AppName,2)) = 'FP' then
    UpdControlFile := 'FP'+'LastUpd.txt';

  RemoteDir:= '/Downloads';
  LocalDir:='C:\Downloads';
  P2:='ig10';
  If not SysUtils.DirectoryExists(LocalDir) then //20150702
    SysUtils.ForceDirectories(LocalDir);

end;

{procedure TFtpFrmT2_2027.NMFTP1Success(Trans_Type: TCmdType); //20150622
begin
  Case Trans_Type of
    cmdDownRestore: StatusBar1.SimpleText := 'DownloadRestore success';
    cmdDownload: StatusBar1.SimpleText := 'Download success';
    cmdReInit: StatusBar1.SimpleText := 'ReInit success';
  end;
end; }

{procedure TFtpFrmT2_2027.IdFTP1PacketRecvd(Sender: TObject);
begin //20150622
  StatusBar1.SimpleText :=
   'Downloaded file is stored in '+ LocalDir+'\'+UpdFileName
   +'          '
   +IntToStr(NMFTP1.BytesRecvd)+' of '+IntToStr(NMFTP1.BytesTotal);
end;  }

procedure TFtpFrmT2_2027.IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
    AWorkCount: Int64);
begin
  if AWorkMode = wmRead then
    StatusBar1.SimpleText :=
      'Downloaded file is stored in ' + LocalDir+ '\' + UpdFileName +
      '          ' +
      IntToStr(AWorkCount);// + ' of ' + IntToStr(NMFTP1.BytesTotal);
end;

procedure TFtpFrmT2_2027.AbortBtnClick(Sender: TObject);
begin
  If FileExists(LocalDir+'\'+UpdFileName) then
    DeleteFile(LocalDir+'\'+UpdFileName);
  IdFTP1.Abort; //20150624
end;


procedure TFtpFrmT2_2027.DownloadBtnClick(Sender: TObject);
Var
  EncrPgm : string[20];
  PgmZ: Array[0..21] of Char;
  ParmsZ : Array[0..254] of Char;
  PgmPathZ : Array[0..254] of Char;
  h :Thandle;
  TempList:TStringList;
  aFS: TFileStream;
begin   //20150624
  If FileExists(LocalDir + '\' + UpdFileName) then
    DeleteFile(LocalDir + '\' + UpdFileName);

  aFS := nil;
  try
    try
      aFS := TFileStream.Create(LocalDir + '\' + UpdFileName, fmCreate or fmShareDenyWrite);
      //
      {NMFTP1.Download(RemoteDir+'\'+UpdFileName,
                    LocalDir+'\'+UpdFileName);}
      IdFTP1.Get(RemoteDir + '\' + UpdFileName, aFS);

      TempList:=TstringList.Create;                    // ?
      Templist.Add(LocalDir+'\'+UpdFileName);          // !
      TempList.SaveToFile(AppDir+'\'+'StartRun.Tmp');  // ?
      TempList.Free;
      ShowMessage('The update has been stored as ' +
                  LocalDir + '\' + UpdFileName + Chr(13) +
                  'You may run it and apply it now');

      StrPCopy(PgmZ,'STARTRUN.EXE');
      StrPCopy(PgmPathZ,AppDir);
      h := ShellExecute(Self.handle, Nil, PgmZ, Nil,
          PgmPathZ, SW_HIDE);
      If H<=32 then
        ShowMessage('Cannot start the update process');
      Application.Terminate;
    except
    end; {Try}
  finally
    aFS.Free;
  end;
end;


(*
procedure TFtpFrm.ApplyUpdate(UpdFileName:String);
Var  PgmZ: Array[0..21] of Char;
     ParmsZ : Array[0..254] of Char;
     PgmPathZ : Array[0..254] of Char;
     h :Thandle;

begin
   StrPCopy(PgmZ,UpdFileName);
   StrPCopy(PgmPathZ,LocalDir);

   h := ShellExecute(FtpFrm.Handle, Nil, PgmZ, Nil,
    PgmPathZ, SW_RESTORE);

    { 'HTTP://www.VisualTax.com/download.htm',Nil,Nil,Sw_Show);}

   If H<=32 then
    ShowMessage('Failed')
   else
   begin
    ShowMessage('Done. The program will terminate now'
    +Chr(13)+'Please run it again');
    Application.Terminate;
   end;
end;
*)

//20150624
{procedure TFtpFrmT2_2027.NMFTP1Connect(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Connected';
end; }
procedure TFtpFrmT2_2027.IdFTP1Connected(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Connected';
end;

//20150622
{procedure TFtpFrmT2_2027.NMFTP1Failure(var handled: Boolean; Trans_Type: TCmdType);
begin
  Case Trans_Type of
    cmdDownRestore: StatusBar1.SimpleText := 'DownloadRestore failure';
    cmdDownload: StatusBar1.SimpleText := 'Download failure';
    cmdReInit: StatusBar1.SimpleText := 'ReInit failure';
    cmdAllocate: StatusBar1.SimpleText := 'Allocate failure';
    cmdDoCommand: StatusBar1.SimpleText := 'DoCommand failure';
  end;
end; }

procedure TFtpFrmT2_2027.IdFTP1Status(ASender: TObject; const AStatus: TIdStatus;
        const AStatusText: string);
begin
  case AStatus of
    hsResolving: ;
    hsConnecting: ;
    hsConnected: ;
    hsDisconnecting: ;
    hsDisconnected: ;
    hsStatusText: ;
    ftpTransfer: ;
    ftpReady: ;
    ftpAborted: ;
  end;
  StatusBar1.SimpleText := AStatusText;
end;

{procedure TFtpFrmT2_2027.NMFTP1TransactionStop(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Data Transfer done';
end;

procedure TFtpFrmT2_2027.NMFTP1HostResolved(Sender: TComponent);
begin
  StatusBar1.SimpleText := 'Host resolved';
end;

procedure TFtpFrmT2_2027.NMFTP1InvalidHost(var handled: Boolean);
begin
  ShowMessage('Invalid Host');
end;

procedure TFtpFrmT2_2027.NMFTP1PacketSent(Sender: TObject);
begin

  //ProgressBar1.Min:=1;
  //ProgressBar1.Max:=NMFTP1.BytesTotal;
  //ProgressBar1.Position := NMFTP1.BytesSent;

  //StatusBar1.SimpleText := IntToStr(NMFTP1.BytesSent)+' of '+IntToStr(NMFTP1.BytesTotal); //20150622
end;

procedure TFtpFrmT2_2027.NMFTP1TransactionStart(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Beginning Data Transfer';
end;}

//20150624
{procedure TFtpFrmT2_2027.NMFTP1Disconnect(Sender: TObject);
begin
  If StatusBar1 <> nil then
    StatusBar1.SimpleText := 'Disconnected';
end;}
procedure TFtpFrmT2_2027.IdFTP1Disconnected(Sender: TObject);
begin
  If StatusBar1 <> nil then //hmmm... loading time?
    StatusBar1.SimpleText := 'Disconnected';
end;

//20150624
{procedure TFtpFrmT2_2027.NMFTP1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin
  ShowMessage('Error '+IntToStr(Errno)+': '+Errmsg);
end;

procedure TFtpFrmT2_2027.NMFTP1Status(Sender: TComponent; Status: String);
begin
//  If StatusBar1 <> nil then
//    StatusBar1.SimpleText := status;
end;
}

{procedure TFtpFrmT2_2027.NMFTP1UnSupportedFunction(Trans_Type: TCmdType);
begin
  Case Trans_Type of
    cmdChangeDir: ShowMessage('ChangeDir unsupported');
    cmdMakeDir: ShowMessage('MakeDir unsupported');
    cmdDelete: ShowMessage('Delete unsupported');
    cmdRemoveDir: ShowMessage('RemoveDir unsupported');
    cmdList: ShowMessage('List unsupported');
    cmdRename: ShowMessage('Rename unsupported');
    cmdUpRestore: ShowMessage('UploadRestore unsupported');
    cmdDownRestore: ShowMessage('DownloadRestore unsupported');
    cmdDownload: ShowMessage('Download unsupported');
    cmdUpload: ShowMessage('Upload unsupported');
    cmdAppend: ShowMessage('UploadAppend unsupported');
    cmdReInit: ShowMessage('ReInit unsupported');
    cmdAllocate: ShowMessage('Allocate unsupported');
    cmdNList: ShowMessage('NList unsupported');
    cmdDoCommand: ShowMessage('DoCommand unsupported');
  end;
end; }

procedure TFtpFrmT2_2027.NMFTP1ConnectionFailed(Sender: TObject);
begin
  ShowMessage('Connection Failed');
end;

procedure TFtpFrmT2_2027.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IdFTP1.Abort;
end;

//20150624
procedure TFtpFrmT2_2027.CheckUpdatesBtnClick(Sender: TObject);
Var
  FileName: String;
  aFS: TFileStream;
begin
  Screen.Cursor := crHourGlass;
  If FileExists(LocalDir+ '\' + UpdControlFile) then
    DeleteFile(LocalDir + '\' + UpdControlFile);

  ConnectToFtpSite;

  aFS := nil;
  try
    try
      aFS := TFileStream.Create(LocalDir + '\' + UpdControlFile, fmCreate or fmShareDenyWrite);
      {NMFTP1.Download(RemoteDir+'\'+UpdControlFile, //20150624
                    LocalDir+'\'+UpdControlFile); }
      IdFTP1.Get(RemoteDir + '\' + UpdControlFile, aFS);
    except
      //on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
    end;
  finally
    aFS.Free;
  end;
  Screen.Cursor := crDefault;

  If FileExists(LocalDir+'\'+UpdControlFile) then
  begin
    Memo1.Visible:=False;
    DownloadBtn.Enabled:= True;
    Memo1.Lines.LoadFromFile(LocalDir+'\'+UpdControlFile);
    UpdFileName:= Memo1.Lines[1];
    If Memo1.lines[0]<= AppUpdateDate then
    begin
     ShowMessage('There is NO newer update than your current'
     +Chr(13)+AppUpdateDate
     +Chr(13)+
     'If you like to download again the update of '+Memo1.lines[0]
      +Chr(13)+'click the Download button');
    end
    else
    begin
      Memo1.Visible:=True;
      ShowMessage('There is a NEW update'+
      Chr(13)+'You may click the Download button');
    end;
 end
 else
  ShowMessage('Cannot determine last update');
end;

procedure TFtpFrmT2_2027.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

//20150624
procedure TFtpFrmT2_2027.ConnectToFtpSite;
Var
  h:thandle;
begin
{This takes me to download}
(*

h := ShellExecute(FtpFrm.Handle,'open',
'HTTP://www.VisualTax.com/download.htm',Nil,Nil,Sw_Show);

  If H<=32 then
   ShowMessage('Connection failed')
  else
   ShowMessage('Connected');

  Delay(5000);
*)
  {If CheckBox1.Checked then //20150622
  Begin
    NMFTP1.Proxy := Edit6.Text;
    NMFTP1.ProxyPort := StrToInt(Edit7.Text);
  End;
  NMFTP1.Host := '205.178.154.42'; //HostTxt.Text;
  NMFTP1.Port := 21; //StrToInt(PortTxt.Text);
  NMFTP1.Timeout := 1500000;
  NMFTP1.UserID := 'visualtax%visualtax.com'; //UserTxt.Text;
  NMFTP1.Password := 'vgplig10'; //PassTxt.Text;
  try
    NMFTP1.Connect;
   except
   On E:Exception do
       writeln(E.message);
   end }

  If CheckBox1.Checked then //20150624
  Begin
    //NMFTP1.Proxy := Edit6.Text;
    //NMFTP1.ProxyPort := StrToInt(Edit7.Text);
  End;
  IdFTP1.ProxySettings.ProxyType := fpcmNone; // con.values from IdFTP1 instance
  IdFTP1.Host := '205.178.154.42'; //HostTxt.Text;
  IdFTP1.Port := 21; //StrToInt(PortTxt.Text);
  IdFTP1.ConnectTimeout := 1500000;
  IdFTP1.Username := 'visualtax%visualtax.com'; //UserTxt.Text;
  IdFTP1.Password := 'vgplig10'; //PassTxt.Text;
  try
    IdFTP1.Connect;
   except
     On E:Exception do
       writeln(E.message);
   end
end;


procedure TFtpFrmT2_2027.Button1Click(Sender: TObject);
begin
 //NMFTP1.Disconnect;
 Close;
end;

procedure TFtpFrmT2_2027.WorldButtonClick(Sender: TObject);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(FtpFrm.Handle,'open','HTTP://www.VisualTax.com',Nil,Nil,Sw_Show);
  If H<=32 then
  begin
   ShowMessage('Connection failed - Code '+IntToStr(H));
  end;
  Screen.Cursor :=crDefault;

end;

end.
