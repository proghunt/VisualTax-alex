unit T1_2026ftpfrm;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Forms, Dialogs, FileCtrl, shellapi,
     ComCtrls, StdCtrls, Controls, Buttons, ExtCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
     IdTCPClient, IdExplicitTLSClientServerBase, IdFTP;


type
  TFtpFrmT1_2026 = class(TForm)
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
    IdFTP: TIdFTP;

    {procedure ApplyUpdate(UpdFileName:String);}
    procedure ConnectToFtpSite;
// 20150727    procedure NMFTP1Success(Trans_Type: TCmdType);
// 20150727    procedure NMFTP1PacketRecvd(Sender: TObject);
    procedure AbortBtnClick(Sender: TObject);
    procedure DownloadBtnClick(Sender: TObject);
 // 20150727   procedure NMFTP1Failure(var handled: Boolean; Trans_Type: TCmdType);
    procedure NMFTP1HostResolved(Sender: TComponent);
    procedure NMFTP1InvalidHost(var handled: Boolean);
    procedure NMFTP1Error(Sender: TComponent; Errno: Word; Errmsg: String);

 // 20150727   procedure NMFTP1UnSupportedFunction(Trans_Type: TCmdType);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure CheckUpdatesBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WorldButtonClick(Sender: TObject);
    procedure IdFTPConnected(Sender: TObject);
    procedure IdFTPStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure IdFTPDisconnected(Sender: TObject);
    procedure IdFTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure IdFTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdFTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
  private
    FWorkCountMax: Int64;
  public
    { Public declarations }
  end;

var
  FtpFrm: TFtpFrmT1_2026;
  RemoteDir,LocalDir,ProgramDir:String;
  UpdControlFile,UpdFileName:String;
  P1,P2:String;

implementation

{$R *.DFM}

uses T1_2026Declare,T1_2026TrimStr,vtTrimStr,vtShared;

var
  Q: Integer;


procedure TFtpFrmT1_2026.FormCreate(Sender: TObject);
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

procedure TFtpFrmT1_2026.IdFTPConnected(Sender: TObject);
begin
  StatusBar1.SimpleText := 'Connected';
end;

procedure TFtpFrmT1_2026.IdFTPDisconnected(Sender: TObject);
begin
  If StatusBar1 <> nil then
    StatusBar1.SimpleText := 'Disconnected';
end;

procedure TFtpFrmT1_2026.IdFTPStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  If StatusBar1 <> nil then
     StatusBar1.SimpleText := AStatusText;
end;

procedure TFtpFrmT1_2026.IdFTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  StatusBar1.SimpleText := IntToStr(AWorkCount)+' of '+IntToStr(FWorkCountMax);
end;

procedure TFtpFrmT1_2026.IdFTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  StatusBar1.SimpleText := 'Beginning Data Transfer';
  FWorkCountMax := AWorkCountMax
end;

procedure TFtpFrmT1_2026.IdFTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  StatusBar1.SimpleText := 'Data Transfer done';
  StatusBar1.SimpleText :=
   'Downloaded file is stored in '+ LocalDir+'\'+UpdFileName
   +'          '
   +IntToStr(FWorkCountMax)+' of '+IntToStr(FWorkCountMax);
end;

{procedure TFtpFrmT1_2026.NMFTP1Success(Trans_Type: TCmdType);
begin
  Case Trans_Type of
    cmdDownRestore: StatusBar1.SimpleText := 'DownloadRestore success';
    cmdDownload: StatusBar1.SimpleText := 'Download success';
    cmdReInit: StatusBar1.SimpleText := 'ReInit success';
  end;
end;}
// 20150727
{
procedure TFtpFrmT1_2026.NMFTP1PacketRecvd(Sender: TObject);
begin
  StatusBar1.SimpleText :=
   'Downloaded file is stored in '+ LocalDir+'\'+UpdFileName
   +'          '
   +IntToStr(NMFTP1.BytesRecvd)+' of '+IntToStr(NMFTP1.BytesTotal);
end; }

procedure TFtpFrmT1_2026.AbortBtnClick(Sender: TObject);
begin
  If FileExists(LocalDir+'\'+UpdFileName) then
     DeleteFile(LocalDir+'\'+UpdFileName);
  IdFTP.Abort;
end;


procedure TFtpFrmT1_2026.DownloadBtnClick(Sender: TObject);
Var  EncrPgm : string[20];
  PgmZ: Array[0..21] of Char;
  ParmsZ : Array[0..254] of Char;
  PgmPathZ : Array[0..254] of Char;
  h :Thandle;
  TempList:TStringList;
begin
 If FileExists(LocalDir+'\'+UpdFileName) then
    DeleteFile(LocalDir+'\'+UpdFileName);
 IdFTP.Get(RemoteDir+'\'+UpdFileName, LocalDir+'\'+UpdFileName);
 try
   IdFTP.Get(RemoteDir+'\'+UpdFileName, LocalDir+'\'+UpdFileName);

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
   Application.Terminate;
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

    { 'www.VisualTax.com/download.htm',Nil,Nil,Sw_Show);}

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

// 20150727
{procedure TFtpFrmT1_2026.NMFTP1Failure(var handled: Boolean; Trans_Type: TCmdType);
begin
  Case Trans_Type of
    cmdDownRestore: StatusBar1.SimpleText := 'DownloadRestore failure';
    cmdDownload: StatusBar1.SimpleText := 'Download failure';
    cmdReInit: StatusBar1.SimpleText := 'ReInit failure';
    cmdAllocate: StatusBar1.SimpleText := 'Allocate failure';
    cmdDoCommand: StatusBar1.SimpleText := 'DoCommand failure';
  end;
end; }

procedure TFtpFrmT1_2026.NMFTP1HostResolved(Sender: TComponent);
begin
  StatusBar1.SimpleText := 'Host resolved';
end;

procedure TFtpFrmT1_2026.NMFTP1InvalidHost(var handled: Boolean);
begin
  ShowMessage('Invalid Host');
end;

procedure TFtpFrmT1_2026.NMFTP1Error(Sender: TComponent; Errno: Word;
  Errmsg: String);
begin
  ShowMessage('Error '+IntToStr(Errno)+': '+Errmsg);
end;

// 20150727
{
procedure TFtpFrmT1_2026.NMFTP1UnSupportedFunction(Trans_Type: TCmdType);
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
end;  }

procedure TFtpFrmT1_2026.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IdFTP.Abort;
end;

procedure TFtpFrmT1_2026.CheckUpdatesBtnClick(Sender: TObject);
Var FileName:String;
begin
 Screen.Cursor :=crHourGlass;
 If FileExists(LocalDir+'\'+UpdControlFile) then
  DeleteFile(LocalDir+'\'+UpdControlFile);

 ConnectToFtpSite;
 try
   idFTP.Get(RemoteDir+'\'+UpdControlFile,
             LocalDir+'\'+UpdControlFile);
 except
  begin
  ShowMessage('Auto-Download failed'+
  Chr(13)+'Please logon to wwww.visualtax.com via your Internet button');
  end;
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
  ShowMessage('Cannot determine last update')
end;

procedure TFtpFrmT1_2026.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TFtpFrmT1_2026.ConnectToFtpSite;
Var h:thandle;
begin
  If CheckBox1.Checked then
  Begin
    idFTP.ProxySettings.Host := Edit6.Text;
    idFTP.ProxySettings.Port := StrToInt(Edit7.Text);
  End;
  idFTP.Host := 'www.visualtax.com'; //'205.178.154.42'; {HostTxt.Text;}
  idFTP.Port := 21; {StrToInt(PortTxt.Text);}
  idFTP.ConnectTimeout := 1500000;
  idFTP.ReadTimeout := 1500000;
  idFTP.Username := 'visualtax%visualtax.com'; {UserTxt.Text;}
  idFTP.Password := 'vgplig10'; {PassTxt.Text;}
  try
    idFTP.Connect;
  except
     on E:Exception do begin
        ShowMessage('Connection Failed');
        writeln(E.message);
     end;
  end
end;


procedure TFtpFrmT1_2026.Button1Click(Sender: TObject);
begin
 idFTP.Disconnect;
 Close;
end;

procedure TFtpFrmT1_2026.WorldButtonClick(Sender: TObject);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(FtpFrm.Handle,'open','www.VisualTax.com',Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;

end;

end.
