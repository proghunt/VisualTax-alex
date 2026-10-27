unit FP_2027ftpfrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Forms,Dialogs,FileCtrl,shellapi,
  ComCtrls,StdCtrls,{Psock,NMFtp,} //20150817 igor
  Controls,Buttons,FP_2027Declare,ExtCtrls;


type
  TFtpFrmFP_2012 = class(TForm)
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
    Button1: TButton;

    {procedure ApplyUpdate(UpdFileName:String);}
    procedure ConnectToFtpSite;
    //20150817 igor procedure NMFTP1Success(Trans_Type: TCmdType);
    procedure NMFTP1PacketRecvd(Sender: TObject);
    procedure AbortBtnClick(Sender: TObject);
    procedure DownloadBtnClick(Sender: TObject);
    procedure NMFTP1Connect(Sender: TObject);
    //20150817 igor procedure NMFTP1Failure(var handled: Boolean; Trans_Type: TCmdType);
    procedure NMFTP1TransactionStop(Sender: TObject);
    procedure NMFTP1HostResolved(Sender: TComponent);
    procedure NMFTP1InvalidHost(var handled: Boolean);
    procedure NMFTP1PacketSent(Sender: TObject);
    procedure NMFTP1TransactionStart(Sender: TObject);
    procedure NMFTP1Disconnect(Sender: TObject);
    procedure NMFTP1Error(Sender: TComponent; Errno: Word; Errmsg: String);
    procedure NMFTP1Status(Sender: TComponent; Status: String);

    //20150817 igor procedure NMFTP1UnSupportedFunction(Trans_Type: TCmdType);
    procedure NMFTP1ConnectionFailed(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure CheckUpdatesBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WorldButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FtpFrm: TFtpFrmFP_2012;
  RemoteDir,LocalDir,ProgramDir:String;
  UpdControlFile,UpdFileName:String;
  P1,P2:String;

implementation

{$R *.DFM}

uses FP_2027TrimStr,vtTrimStr,vtShared;

var
  Q: Integer;


procedure TFtpFrmFP_2012.FormCreate(Sender: TObject);
begin
 DownloadBtn.Enabled:=False;
 P1:= 'vgpl';
 If UpperCase(LeftStr(AppName,2)) = 'T1' then UpdControlFile := 'T1'+'LastUpd.txt'
 else if UpperCase(LeftStr(AppName,2)) = 'T2' then UpdControlFile := 'T2'+'LastUpd.txt'
 else If UpperCase(LeftStr(AppName,2)) = 'TF' then UpdControlFile := 'TF'+'LastUpd.txt'
 else If UpperCase(LeftStr(AppName,2)) = 'T4' then UpdControlFile := 'T4'+'LastUpd.txt'
 else If UpperCase(LeftStr(AppName,2)) = 'FP' then UpdControlFile := 'FP'+'LastUpd.txt';

 RemoteDir:= '/Downloads';
 LocalDir:='C:\Downloads';
 P2:='ig10';
 If not DirectoryExists(LocalDir) then
   ForceDirectories(LocalDir);

end;

{//20150817 igor procedure TFtpFrmFP_2012.NMFTP1Success(Trans_Type: TCmdType);
begin
  Case Trans_Type of
    cmdDownRestore: StatusBar1.SimpleText := 'DownloadRestore success';
    cmdDownload: StatusBar1.SimpleText := 'Download success';
    cmdReInit: StatusBar1.SimpleText := 'ReInit success';
  end;
end;
}

procedure TFtpFrmFP_2012.NMFTP1PacketRecvd(Sender: TObject);
begin
  //20150817 igor
  //StatusBar1.SimpleText :=
  // 'Downloaded file is stored in '+ LocalDir+'\'+UpdFileName
 //  +'          '
 //  +IntToStr(NMFTP1.BytesRecvd)+' of '+IntToStr(NMFTP1.BytesTotal);
end;

procedure TFtpFrmFP_2012.AbortBtnClick(Sender: TObject);
begin
  //20150817 igor
  //If FileExists(LocalDir+'\'+UpdFileName) then
  //  DeleteFile(LocalDir+'\'+UpdFileName);
 // NMFTP1.Abort;
end;


procedure TFtpFrmFP_2012.DownloadBtnClick(Sender: TObject);
Var  EncrPgm : string; //[20];
  PgmZ: Array[0..21] of Char;
  ParmsZ : Array[0..254] of Char;
  PgmPathZ : Array[0..254] of Char;
  h :Thandle;
  TempList:TStringList;
begin
 If FileExists(LocalDir+'\'+UpdFileName) then
  DeleteFile(LocalDir+'\'+UpdFileName);
 try
 //20150817 igor
   {NMFTP1.Download(RemoteDir+'\'+UpdFileName,
                  LocalDir+'\'+UpdFileName);

   TempList:=TstringList.Create;
   Templist.Add(LocalDir+'\'+UpdFileName);
   TempList.SaveToFile(AppDir+'\'+'StartRun.Tmp');
   TempList.Free;
   ShowMessage('The update has been stored as '+
                  LocalDir+'\'+UpdFileName
               +Chr(13)+'You may run it and apply it now');

   StrPCopy(PgmZ,'STARTRUN.EXE');
   StrPCopy(PgmPathZ,AppDir);
   h := ShellExecute(Self.handle, Nil, PgmZ, Nil,
    PgmPathZ, SW_HIDE);
   If H<=32 then ShowMessage('Cannot start the update process');
   Application.Terminate;}
 except
 end; {Try}
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

procedure TFtpFrmFP_2012.NMFTP1Connect(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Connected';
end;
//20150817 igor
{procedure TFtpFrmFP_2012.NMFTP1Failure(var handled: Boolean; Trans_Type: TCmdType);
begin
  Case Trans_Type of
    cmdDownRestore: StatusBar1.SimpleText := 'DownloadRestore failure';
    cmdDownload: StatusBar1.SimpleText := 'Download failure';
    cmdReInit: StatusBar1.SimpleText := 'ReInit failure';
    cmdAllocate: StatusBar1.SimpleText := 'Allocate failure';
    cmdDoCommand: StatusBar1.SimpleText := 'DoCommand failure';
  end;
end;
}
procedure TFtpFrmFP_2012.NMFTP1TransactionStop(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Data Transfer done';
end;

procedure TFtpFrmFP_2012.NMFTP1HostResolved(Sender: TComponent);
begin
  StatusBar1.SimpleText := 'Host resolved';
end;

procedure TFtpFrmFP_2012.NMFTP1InvalidHost(var handled: Boolean);
begin
  ShowMessage('Invalid Host');
end;

procedure TFtpFrmFP_2012.NMFTP1PacketSent(Sender: TObject);
begin
  {
  ProgressBar1.Min:=1;
  ProgressBar1.Max:=NMFTP1.BytesTotal;
  ProgressBar1.Position := NMFTP1.BytesSent;
  }
  //20150817 igor StatusBar1.SimpleText := IntToStr(NMFTP1.BytesSent)+' of '+IntToStr(NMFTP1.BytesTotal);
end;

procedure TFtpFrmFP_2012.NMFTP1TransactionStart(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Beginning Data Transfer';
end;

procedure TFtpFrmFP_2012.NMFTP1Disconnect(Sender: TObject);
begin
  If StatusBar1 <> nil then
    StatusBar1.SimpleText := 'Disconnected';
end;

procedure TFtpFrmFP_2012.NMFTP1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin
  ShowMessage('Error '+IntToStr(Errno)+': '+Errmsg);
end;

procedure TFtpFrmFP_2012.NMFTP1Status(Sender: TComponent; Status: String);
begin
//  If StatusBar1 <> nil then
//    StatusBar1.SimpleText := status;
end;
//20150817 igor
{procedure TFtpFrmFP_2012.NMFTP1UnSupportedFunction(Trans_Type: TCmdType);
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
end;
}

procedure TFtpFrmFP_2012.NMFTP1ConnectionFailed(Sender: TObject);
begin
  ShowMessage('Connection Failed');
end;

procedure TFtpFrmFP_2012.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   //20150817 igor NMFTP1.Abort;
end;

procedure TFtpFrmFP_2012.CheckUpdatesBtnClick(Sender: TObject);
Var FileName:String;
begin
 Screen.Cursor :=crHourGlass;
 If FileExists(LocalDir+'\'+UpdControlFile) then
  DeleteFile(LocalDir+'\'+UpdControlFile);

 ConnectToFtpSite;

 try
  //20150817 igor NMFTP1.Download(RemoteDir+'\'+UpdControlFile,
                  //LocalDir+'\'+UpdControlFile);
 except
 end;
 Screen.Cursor :=crDefault;

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

procedure TFtpFrmFP_2012.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TFtpFrmFP_2012.ConnectToFtpSite;
Var h:thandle;
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
//20150817 igor
  (*If CheckBox1.Checked then
  Begin
    NMFTP1.Proxy := Edit6.Text;
    NMFTP1.ProxyPort := StrToInt(Edit7.Text);
  End;
  NMFTP1.Host := '205.178.154.42'; {HostTxt.Text;}
  NMFTP1.Port := 21; {StrToInt(PortTxt.Text);}
  NMFTP1.Timeout := 1500000;
  NMFTP1.UserID := 'VisualTax'; {UserTxt.Text;}
  NMFTP1.Password := 'vgplig10'; {PassTxt.Text;}
  try
    NMFTP1.Connect;
   except
   On E:Exception do
       writeln(E.message);
   end*)
end;


procedure TFtpFrmFP_2012.Button1Click(Sender: TObject);
begin
 //20150817 igor NMFTP1.Disconnect;
 Close;
end;

procedure TFtpFrmFP_2012.WorldButtonClick(Sender: TObject);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(FtpFrm.Handle,'open','HTTP://www.VisualTax.com',Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;

end;

end.
