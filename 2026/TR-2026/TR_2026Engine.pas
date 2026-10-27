unit TR_2026Engine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, OleCtrls, Buttons, ToolWin, ActnList,
  ImgList, shdocvw, Printers, ActiveX, System.Actions,
  {$WARN UNIT_PLATFORM OFF}FileCtrl, {$WARN UNIT_PLATFORM ON}
  ClipBrd, mshtml, ShellApi, Wininet,
  IOUtils, StrUtils, UITypes, Types,
  
  //20211229 Igor >>>
  IdHTTP, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  //20211229 Igor <<<

  TR_2026, TR_2026About, TR_2026Declare, TR_2026AskForKey, TR_2026Authorization, TR_2026PopTreeView,  TR_2026Utils,
  //20200813 Igor >>>
  uADStanIntf, uADStanOption, uADStanParam, uADStanError, uADDatSManager,
  uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager, Data.DB,
  uADCompDataSet, uADCompClient, uADPhysManager, uADPhysSQLite, uADStanDef,
  uADGUIxIntf, uADGUIxFormsWait, uADCompGUIx, System.Generics.Collections;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;
  TRTOC_PWD = 'rc5fxD2FVwpucQww';
  //TRTOC_PWD = '';
  //20200813 Igor <<<

  //for internet connection.....
  INTERNET_CONNECTION_MODEM = 1;
  INTERNET_CONNECTION_LAN = 2;
  INTERNET_CONNECTION_PROXY = 4;
  INTERNET_CONNECTION_MODEM_BUSY = 8;

type
  TEngineTR_2026 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    View1: TMenuItem;
    NavigatorImages: TImageList;
    NavigatorHotImages: TImageList;
    LinksImages: TImageList;
    LinksHotImages: TImageList;
    Toolbar3: TMenuItem;
    Statusbar2: TMenuItem;
    ActionList1: TActionList;
    BackAction: TAction;
    ForwardAction: TAction;
    StopAction: TAction;
    RefreshAction: TAction;
    ExitProgram: TMenuItem;
    Print1: TMenuItem;
    SetUp1: TMenuItem;
    Splitter1: TSplitter;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    NotePad1: TMenuItem;
    Download2: TMenuItem;
    SaveDocument1: TMenuItem;
    LinkToAWebSite1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    TrUserGuide1: TMenuItem;
    File1: TMenuItem;
    Configure1: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Panel3: TPanel;
    TreeView1: TTreeView;
    TOCHeaderPanel: TPanel;
    Collapse: TBitBtn;
    Label6: TLabel;
    ExpandBtn: TBitBtn;
    Panel4: TPanel;
    WebBrowser1: TWebBrowser;
    DocumentHeaderPanel: TPanel;
    Panel1: TPanel;
    urlLbl: TLabel;
    TitleLbl: TLabel;
    ExpandANodeBtn: TBitBtn;
    URLBox: TEdit;
    SearchComboBox: TComboBox;
    TestModeBtn: TBitBtn;
    ProductionModeBtn: TBitBtn;
    LookInBox: TComboBox;
    Label14: TLabel;
    BasicPanel: TPanel;
    Label2: TLabel;
    SearchPersonalBtn: TBitBtn;
    SearchBusinessBtn: TBitBtn;
    CorporateTaxBtn: TBitBtn;
    advSearchOp: TComboBox;
    CRAAdvanced: TCheckBox;
    Utilities1: TMenuItem;
    Advanced1: TMenuItem;
    Deregisterprogram1: TMenuItem;
    Importwebsitesfrompreviousyear1: TMenuItem;
    URLs: TComboBox;
    imglstButtons: TImageList;
    imglstButtonsHot: TImageList;
    imglstButtonsDisabled: TImageList;
    currentSearchPanel: TPanel;
    Label9: TLabel;
    HighlightBox: TEdit;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    HighlightBtn: TBitBtn;
    WebToolBar: TToolBar;
    BackBtn: TToolButton;
    ForwardBtn: TToolButton;
    StopBtn: TToolButton;
    RefreshBtn: TToolButton;
    WebHomeBtn: TToolButton;
    WebPrintBtn: TToolButton;
    PopupMenu1: TPopupMenu;
    AllWords1: TMenuItem;
    AnyWords1: TMenuItem;
    ExactPhrase1: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ProgressPanel: TPanel;
    ProgressBar1: TProgressBar;
    ClearSearchBtn: TBitBtn;
    CheckUpdates1: TMenuItem;
    N2: TMenuItem;
    ContainerPanel: TPanel;
    SearchBoxPanel: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    AppUpdateDateLbl: TLabel;
    SearchOptionBox: TRadioGroup;
    SearchBox: TEdit;
    SearchTitlesBtn: TBitBtn;
    GoogleSearchBtn: TBitBtn;
    HighlightOption: TCheckBox;
    CRASearch: TButton;
    craDropDownOptionsBtn: TBitBtn;
    searchWordOptionsComboBox: TComboBox;
    ToolButton4: TToolButton;
    getUrlFileDateBtn: TBitBtn;
    //20211229 Igor >>>


    //HTTP: TIdHTTP;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
    HTTP: TIdHTTP;




    //20211229 Igor <<<
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);


    procedure RemoveDuplicateLinks(var SomeList: TStringList);
    function ReplaceSpecialChar(info: string): string;
    procedure CBListener1ClipboardChanged(Sender: TObject);
    procedure DoClipBoardChanged;
    //20200813 Igor >>>
    procedure DoLoadTreeFromDB;
    procedure reLoadTrFromWeb;
    procedure LoadTr;
    procedure LoadTrFromWeb;
    procedure LoadDbFromWeb;
    //20200813 Igor <<<
    procedure LoadTrFromLocalDrive;
    procedure WB_ShowFindDialog(AWebbrowser: TWebbrowser);
    procedure WB_SaveAs_HTML(WB: TWebBrowser; const FileName: string);
    procedure GoogleSearch(AString: string);
    function DownloadITA: boolean;
    procedure ShowITA;
    procedure ShowTrGuide;
    procedure AddOtherTrSources;
    procedure AddLocalITA;
    procedure WBHighlight(WB: TWebBrowser; sText: string);
    procedure LoadTreeView;
    procedure SearchViaTreeView(AString: string; SearchOption: Integer);
    procedure StopClick(Sender: TObject);
    procedure URLsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefreshClick(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure URLsClick(Sender: TObject);
    procedure Statusbar2Click(Sender: TObject);
    function IsKeyWInDocument(WB: TWebBrowser; sText: string): Boolean;
    procedure WebBrowser1BeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure ExitProgramClick(Sender: TObject);
    function FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
    procedure Print1Click(Sender: TObject);
    procedure FillDataBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    function GetHTMLCode(WebBrowser1: TWebBrowser; var TempList: TStringList): Boolean;
    procedure SaveHTMLSource(WB: TWebBrowser; const FileName: string);
    procedure TreeView1DblClick(Sender: TObject);
    procedure SearchTitlesBtnClick(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure ExpandBtnClick(Sender: TObject);
    procedure CollapseClick(Sender: TObject);
    //20211229 Igor >>>
    (*
    function DownLoadFromWeb(url, remoteFlName, localDir, localFlName: string): boolean;
    function IsUrlValid(const url: string): boolean;
    *)
    //20211229 Igor <<<
    function GetUrlFileDate(Filename: string; var FileDate: string): Boolean;
    procedure ExpandANodeBtnClick(Sender: TObject);
    procedure TreeView1KeyPress(Sender: TObject; var Key: Char);
    function IsConnectedToInternet: Boolean;
    procedure TrGuideBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure SetUp1Click(Sender: TObject);
    procedure TrGuide1Click(Sender: TObject);
    procedure NotePad1Click(Sender: TObject);
    procedure Download2Click(Sender: TObject);
    procedure GoogleSearchBtnClick(Sender: TObject);
    procedure SaveDocument1Click(Sender: TObject);
    procedure LinkToAWebSite1Click(Sender: TObject);
    procedure TrUserGuide1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Minimize1Click(Sender: TObject);
    procedure TestModeBtnClick(Sender: TObject);
    procedure ProductionModeBtnClick(Sender: TObject);
    procedure HighlightBtnClick(Sender: TObject);
    procedure findNext(Sender: TObject);
    procedure findPrevious(Sender: TObject);
    procedure HighlightBoxKeyPress(Sender: TObject; var Key: Char);
    procedure CRASearchClick(Sender: TObject);
    procedure ShowtheIncomeTaxAct1Click(Sender: TObject);
    procedure Deregisterprogram1Click(Sender: TObject);
    procedure Importwebsitesfrompreviousyear1Click(Sender: TObject);
    procedure HighlightBoxChange(Sender: TObject);
    procedure WebHomeBtnClick(Sender: TObject);
    procedure WebPrintBtnClick(Sender: TObject);
    procedure craDropDownOptionsBtnClick(Sender: TObject);
    procedure craDropDownOptionsClick(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure ClearSearchBtnClick(Sender: TObject);
    procedure CheckUpdates1Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
    procedure getUrlFileDateBtnClick(Sender: TObject);
    procedure WebBrowser1CommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
    procedure ForwardBtnClick(Sender: TObject);
  private
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;
    //20200813 Igor >>>
    TrDbFlName: string;
    arrUrls: TArray<string>;
    //20200813 Igor <<<
    procedure FindAddress;
    procedure HomePageRequest(var message: tmessage); message CM_HOMEPAGEREQUEST;
    procedure DoLoad(OriginalTocList: TStringList);

    function GetFileWithNoCache(AUrl, AFileName: string): boolean; //20211229 Igor
  end;

var
  EngineTR_2026: TEngineTR_2026;
  TrSourceId, Descr, UrlPage, UrlPrefix: string;
  Keyw: string;
  CurDispatch: IDispatch; {save the interface globally }
  TitleList, LinkList: TStringList;
  OnLineNo, PassWord, FileName, {Url,} Refund, OnLineMethod: string;  //to be used bu the uhtmlEfOnline
  //F1:TextFile;
  textRange: IHTMLTxtRange;

implementation

{$R *.DFM}

uses System.Zip; //20180207 Igor

function TEngineTR_2026.GetFileWithNoCache(AUrl, AFileName: string): boolean; //20211229 Igor
var FS: TFileStream;
begin
  Result := false;
  if AUrl.IsEmpty then Exit;
  if FileExists(AFileName) then
    DeleteFile(AFileName);
  FS := TFileStream.Create(AFileName, fmCreate);
  try
    IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    HTTP.HandleRedirects := True;
    HTTP.AllowCookies := True;
    HTTP.ConnectTimeout := 5000;
    HTTP.ReadTimeout := 5000;
    with HTTP do
    begin
      Request.UserAgent := 'Mozilla/4.0';
      Request.Connection := 'Keep-Alive';
      Request.ProxyConnection := 'Keep-Alive';
      Request.CacheControl := 'no-cache';
    end;
    try
      HTTP.Get(AUrl, FS);
      Result := true;
    except on E: Exception do
      begin
        if Pos('404', E.Message) > 0 then
        begin
          if AUrl.EndsWith(ITAFlName) then
            ShowMessage('The Income Tax Act is currently not available for download.')
          else
            ShowMessage('The TR Engine is not currently available'); //. It will be re-activated after July 13 2021') //20211231
        end
        else
          ShowMessage(E.Message);
      end;
    end;
  finally
    FS.Free;
  end;
end;

procedure GetLicenseLevel;
  function ReadKey: Boolean;
  var
    SL: TStringList;
    S: String;
  begin
    SL := TStringList.Create;
    try
      if not FileExists(TPath.Combine(AppDir, ActivationFile)) then
        exit(False);
      SL.LoadFromFile(TPath.Combine(AppDir, ActivationFile));
      for S in SL do
        if ValidateKey(Crypt(S)) then
        begin
          License := GetLicenseLevelByKey(Crypt(S));
          exit(True);
        end;
      Result := False;
    finally
      SL.Free;
    end;
  end;
begin
  License.Level := llNone;

  While not ReadKey do
  begin
    with TAskForKeyTR_2026.create(Application) do
    begin
      try
        if ShowModal = mrCancel then
        begin
          Close;
          Application.Terminate;
          exit;
        end;
      finally
        Free;
      end;
    end;
  end;
end;

procedure TEngineTR_2026.FormCreate(Sender: TObject);
begin
  Application.Title := 'TR-' + AppYear;
  EngineTR_2026.Caption := 'VisualTax - Tax Research ' + AppYear;
  AppUpdateDateLbl.Caption := 'Updated: ' + AppUpdateDate;

  TrDbFlName := TPath.Combine(AppDir, 'TRTOC.db'); //20200813 Igor
  GetLicenseLevel;
  if License.Level = llNone then
  begin
    Application.Terminate;
    exit;
  end;

  SearchWordOptionsComboBox.ItemIndex := 2;
  HistoryIndex := -1;

  HistoryList := TStringList.Create;
  TitleList := TStringList.Create;
  LinkList := TStringList.Create;

  ShowTrGuide;
end;

procedure TEngineTR_2026.FormActivate(Sender: TObject);
begin
  if Assigned(TitleList) and (TitleList.Count = 0) then
  begin
    Screen.Cursor := crHourGlass;
    try
      LoadTr; //20200813 Igor
      LoadTreeView;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TEngineTR_2026.FormDestroy(Sender: TObject);
begin
  FreeAndNil(TitleList);
  FreeAndNil(LinkList);
  FreeAndNil(HistoryList);
end;

procedure TEngineTR_2026.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [ssAlt] then
    if (Key = VK_RIGHT) and ForwardBtn.Enabled then
      ForwardBtn.Click
    else
    if (Key = VK_LEFT) and BackBtn.Enabled then
      BackBtn.Click;
end;

procedure TEngineTR_2026.reLoadTrFromWeb;
begin
  ProgressPanel.Visible := True;
  try
    TitleList.Clear;
    LinkList.Clear;
    Treeview1.Items.Clear;
    LoadTr; //20200813 Igor
    LoadTreeview;
  finally
    ProgressPanel.Visible := False;
  end;
end;

procedure TEngineTR_2026.LoadTrFromWeb;
var
  TrTocFlName: string;
  OriginalTocList: TStringList;
  url, remoteflname, localflname, LocalDir: string;
  FZip: TZipFile; //20180207 Igor
begin
  if IsConnectedToInternet = false then
  begin
    ShowMessage('Internet connection not found, please check your connection and try again');
    exit;
  end;
  LocalDir := AppDir; //20180207 Igor

  if not TDirectory.Exists(LocalDir) then
    SysUtils.ForceDirectories(LocalDir);

  Screen.Cursor := crHourGlass;

  //20180207 Igor >>>
  //url := 'http://visualtax.com/downloads/';

  url := 'https://www.visualtax.com/TR/';  //john
  //url := 'http://visualtax.com/TR/';        //not sure what the difference is

  //20210701 >>>
  //remoteflname := 'TRDLDIR'+AppYear+'.ZIP';
  //localflname  := 'TRDLDIR'+AppYear+'.ZIP';
  remoteflname :=  'TRDLDIRDB'+AppYear+'.ZIP'; //'TRDLDIR.ZIP'; //20211231
  localflname  :=  'TRDLDIRDB'+AppYear+'.ZIP'; //'TRDLDIR.ZIP'; //20211231
  //20210701 <<<
  //20180207 Igor <<<
  TrTocFlName := TPath.Combine(LocalDir, 'TRTOC.txt');

  if FileExists(TrTocFlName) then
    SysUtils.DeleteFile(TrTocFlName);
  if FileExists(TPath.Combine(LocalDir, localflname)) then
    SysUtils.DeleteFile(TPath.Combine(LocalDir, localflname));
  //20211229 Igor >>>
  (*if not IsUrlValid(url + remoteflname) then
  begin
    ShowMessage('The TR Engine is not available. It will be re-activated after July 13 2021');  //20210703
    exit;
  end;
  *)

  ProgressBar1.Position := 0;
  ProgressBar1.Max := 100;
  if EngineTR_2026.GetFileWithNoCache(url + remoteflname, TPath.Combine(LocalDir, localflname)) then
  begin
    ProgressBar1.Position := 30;
    //20180207 Igor >>>
    {if not ExecAndWait(TPath.Combine(LocalDir, localflname), '', SW_HIDE) then
    begin
      showMessage(SysErrorMessage(GetLastError));
      Exit;
    end;}
    FZip := TZipFile.Create;
    try
      try
        FZip.Open(TPath.Combine(LocalDir, localflname), zmRead);
        FZip.ExtractAll(LocalDir);
        FZip.Close;
        SysUtils.DeleteFile(TPath.Combine(LocalDir, localflname));
      except on E: Exception do
        begin
          ShowMessage('Error occured while unzipping file: ' + E.Message);
          Exit;
        end;
      end;
    finally
      FZip.Free;
    end;
    //20180207 Igor <<<
  end
  else
  begin
    //ShowMessage('Error in file download: ' + remoteflname); //20180207 Igor
    exit;
  end;
  //20211229 Igor <<<

  ProgressBar1.Position := ProgressBar1.Position + 10;
  if not (FileExists(TrTocFlName)) then
  begin
    showmessage('Downloaded files do not exist');
    exit;
  end;

  ProgressBar1.Position := ProgressBar1.Position + 10;
  OriginalTocList := TStringList.Create;
  try
    try
      if FileExists(TrTocFlName) then
        OriginalTocList.LoadFromFile(TrTocFlName);
      if not SysUtils.DeleteFile(TrTocFlName) then
        ShowMessage('Cannot delete Toc');
      if FileExists(TPath.Combine(LocalDir, remoteflname)) then
        SysUtils.DeleteFile(TPath.Combine(LocalDir, remoteflname));
      //20180207 Igor >>>
      //TDirectory.Delete(LocalDir, True);
      SysUtils.DeleteFile(TrTocFlName);
      //20180207 Igor <<<
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbok], 0);
    end;
    DoLoad(OriginalTocList);
  finally
    OriginalTocList.Free;
  end;
end;

procedure TEngineTR_2026.LoadTrFromLocalDrive;
var
  TrTocFlName: string;
  OriginalTocList: TStringList;
begin
  TitleList.Clear;
  LinkList.Clear;
  TrTocFlName     := 'C:\XE-WIP\TRMaintainProject - XE4\FINALDIR\TRTOC.txt'; //'C:\Delphi\TrMaintainProject\FinalDir\TRTOC.txt';
  Screen.Cursor := crHourGlass;
  OriginalTocList := TStringList.Create;
  try
    if FileExists(TrTocFlName) then
      OriginalTocList.LoadFromFile(TrTocFlName);
    DoLoad(OriginalTocList);
  finally
    OriginalTocList.Free;
    Screen.Cursor := CrDefault;
  end;
end;

procedure TEngineTR_2026.LoadDbFromWeb; //20200813 Igor
var
  url, remoteflname, localflname, LocalDir: string;
  FZip: TZipFile; //20180207 Igor
begin
  if IsConnectedToInternet = false then
  begin
    ShowMessage('Internet connection not found, please check your connection and try again');
    exit;
  end;
  LocalDir := AppDir; //20180207 Igor

  if not TDirectory.Exists(LocalDir) then
    SysUtils.ForceDirectories(LocalDir);

  Screen.Cursor := crHourGlass;

  //20180207 Igor >>>
  //url := 'http://visualtax.com/downloads/';

  url := 'https://www.visualtax.com/TR/';  //john
  //url := 'http://visualtax.com/TR/';        //not sure what the difference is
  //20210701 >>>

  //remoteflname := 'TRDLDIRDB.ZIP';
  //localflname  := 'TRDLDIRDB.ZIP';

  remoteflname := 'TRDLDIRDB'+AppYear+'.ZIP';
  localflname  := 'TRDLDIRDB'+AppYear+'.ZIP';

  //20210701 <<<
  //20180207 Igor <<<

  if FileExists(TrDbFlName) then
    SysUtils.DeleteFile(TrDbFlName);
  if FileExists(TPath.Combine(LocalDir, localflname)) then
    SysUtils.DeleteFile(TPath.Combine(LocalDir, localflname));
  //20211229 Igor >>>
  (*if not IsUrlValid(url + remoteflname) then
  begin
    ShowMessage('The TR Engine is not available. It will be re-activated after July 13 2021');  //20210703
    exit;
  end;*)

  ProgressBar1.Position := 0;
  ProgressBar1.Max := 100;
  if EngineTR_2026.GetFileWithNoCache(url + remoteflname, TPath.Combine(LocalDir, localflname)) then
  begin
    ProgressBar1.Position := 30;
    FZip := TZipFile.Create;
    try
      try
        FZip.Open(TPath.Combine(LocalDir, localflname), zmRead);
        FZip.ExtractAll(LocalDir);
        FZip.Close;
        SysUtils.DeleteFile(TPath.Combine(LocalDir, localflname));
      except on E: Exception do
        begin
          ShowMessage('Error occured while unzipping file: ' + E.Message);
          Exit;
        end;
      end;
    finally
      FZip.Free;
    end;
  end
  else
  begin
    //ShowMessage('Error in file download: ' + remoteflname);
    exit;
  end;
  //20211229 Igor <<<

  ProgressBar1.Position := ProgressBar1.Position + 10;
  if not (FileExists(TrDbFlName)) then
  begin
    showmessage('Downloaded files do not exist');
    exit;
  end;

  ProgressBar1.Position := ProgressBar1.Position + 10;
  DoLoadTreeFromDB;
end;

procedure TEngineTR_2026.LoadTr; //20200813 Igor
begin
  //LoadTrFromWeb;
  LoadDbFromWeb;
end;

procedure TEngineTR_2026.LoadTreeView;
var
  //i: Integer;
  MS: TMemoryStream;
begin
  Exit; //20200813 Igor
  TreeView1.Items.Clear;
  ProgressBar1.Position := ProgressBar1.Position + 10;

{
  for i := 0 to TitleList.count - 1 do //remove ID and other sources
    TitleList[i] := MidStr(TitleList[i], 17, 140);
}

  ProgressBar1.Position := ProgressBar1.Position + 5;
  //AddLocalITA; //no longer used
  AddOtherTrSources;
  ProgressBar1.Position := ProgressBar1.Position + 5;
  MS := TMemoryStream.Create;
  try
    TitleList.SaveToStream(MS);
    ProgressBar1.Position := ProgressBar1.Position + 5;
    MS.Position := 0;
    TreeView1.LoadFromStream(MS);
  finally
    MS.Free;
  end;
end;

procedure TEngineTR_2026.FindAddress;
begin
  UpdateCombo := True;
  WebBrowser1.Navigate2(Urls.Text);
end;

procedure TEngineTR_2026.StopClick(Sender: TObject);
begin
  if Assigned(WebBrowser1.Document) then
    WebBrowser1.Stop;
end;

procedure TEngineTR_2026.URLsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_Return then
    FindAddress;
end;

procedure TEngineTR_2026.URLsClick(Sender: TObject);
begin
  FindAddress;
end;

procedure TEngineTR_2026.RefreshClick(Sender: TObject);
begin
  FindAddress;
end;

procedure TEngineTR_2026.BackClick(Sender: TObject);
begin
  WebBrowser1.GoBack;
end;

procedure TEngineTR_2026.ForwardBtnClick(Sender: TObject);
begin
  WebBrowser1.GoForward;
end;

procedure TEngineTR_2026.Statusbar2Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    StatusBar1.Visible := Checked;
  end;
end;

procedure TEngineTR_2026.HomePageRequest(var Message: TMessage);
begin
  Urls.Text := HomePage;
  FindAddress;
end;

procedure TEngineTR_2026.DoLoad(OriginalTocList: TStringList);
var
  i: Integer;
  //ID: string;
  s: string;
  title: string;
  paramsList : TStringlist;
begin

  for i := 0 to OriginalTocList.count - 1 do
  begin

    if (I > 0) and ((i mod 1000) = 0) then
      ProgressBar1.Position := ProgressBar1.Position + 10;

    s := OriginalTocList[i];

    paramsList := TStringList.Create;
    //ExtractStrings(['|'],[],pchar(s), paramsList); // doesnt work fails on ' character
    paramsList.StrictDelimiter := True;
    paramsList.Delimiter := '|';
    paramsList.DelimitedText := s; //'A|B||C';

    title := paramsList[1];
    TitleList.add(title);

    if paramsList.count = 3 then
      LinkList.add(trim(paramsList[2]))
    else
      LinkList.add('');

    paramsList.free;
  end;
end;

procedure TEngineTR_2026.DoLoadTreeFromDB; //20200813 Igor
var FConn: TADConnection;
    QTree: TADQuery;
    NodeIDs: TDictionary<integer, TTreeNode>;
    ParentNode, CurrNode: TTreeNode;
    cURL: string;
    I: integer;
    L: TStringList;

    function GetNodeByID(AID: integer): TTreeNode;
    begin
      Result := nil;
      NodeIDs.TryGetValue(AID, Result);
    end;

begin
  FConn := TADConnection.Create(nil);
  QTree := TADQuery.Create(nil);
  NodeIDs := TDictionary<integer, TTreeNode>.Create;
  try
    FConn.LoginPrompt := False;
    FConn.DriverName := 'SQLite';
    FConn.Params.Values['Database'] := TrDbFlName;
    FConn.Params.Values['Password'] := TRTOC_PWD;
    FConn.Params.Values['LockingMode'] := 'Normal';
    FConn.Connected := True;

    QTree.Connection := FConn;
    QTree.SQL.Text :=
      ' SELECT * FROM '+
      ' ( '+
      '     SELECT Id, Title, ParentTitleId, '''' AS URL, SeqNo AS TitleSeqNo, 0 AS URLSeqNo, ''T'' AS RecordType '+
      '     FROM Titles '+
      '     UNION '+
      '     SELECT U.Id, Caption, U.ParentTitleId, URL, T.SeqNo AS TitleSeqNo, U.SeqNo AS URLSeqNo, ''U'' '+
      '     FROM Urls U '+
      '         INNER JOIN Titles T ON T.Id = U.ParentTitleId '+
      ' ) '+
      ' ORDER BY NULLIF(ParentTitleId, 0), TitleSeqNo, URLSeqNo';
    QTree.Open;

    SetLength(arrUrls, 0);
    TreeView1.Items.BeginUpdate;
    try
      TreeView1.Items.Clear;
      I := 0;
      while not QTree.Eof do
      begin
        ParentNode := GetNodeByID(QTree.FieldByName('ParentTitleId').AsInteger);
        if Assigned(ParentNode) then
          CurrNode := TreeView1.Items.AddChild(ParentNode, QTree.FieldByName('Title').AsString)
        else
          CurrNode := TreeView1.Items.Add(nil, QTree.FieldByName('Title').AsString);
        CurrNode.OverlayIndex := -1;
        if SameText(QTree.FieldByName('RecordType').AsString, 'T') then
          NodeIDs.AddOrSetValue(QTree.FieldByName('Id').AsInteger, CurrNode);
        cURL := QTree.FieldByName('URL').AsString;
        if not cURL.IsEmpty then
        begin
          SetLength(arrUrls, Length(arrURLs) + 1);
          arrUrls[Length(arrURLs) - 1] := cURL;
          CurrNode.OverlayIndex := Length(arrURLs) - 1;
        end;
        if (I > 0) and ((i mod 1000) = 0) then
          ProgressBar1.Position := ProgressBar1.Position + 10;
        inc(I);
        QTree.Next;
      end;

    finally
      TreeView1.Items.EndUpdate;
    end;

    if TFile.Exists(TPath.Combine(AppDir, 'websites.d')) then
    begin
      ParentNode := TreeView1.Items.Add(nil, 'OTHER TR SOURCES');
      ParentNode.OverlayIndex := -1;
      L := TStringList.Create;
      try
        L.LoadFromFile(TPath.Combine(AppDir, 'websites.d'));
        if L.Count >= 2 then
        begin
          i := 0;
          repeat
            CurrNode := TreeView1.Items.AddChild(ParentNode, L[i]);
            SetLength(arrUrls, Length(arrURLs) + 1);
            arrUrls[Length(arrURLs) - 1] := L[i + 2];
            CurrNode.OverlayIndex := Length(arrURLs) - 1;
            Inc(i, 4);
          until i > L.count - 1;
        end;
      finally
        L.Free;
      end;
    end;

  finally
    QTree.Free;
    FConn.Free;
    FreeAndNil(NodeIDs);
  end;
end;

procedure TEngineTR_2026.WebBrowser1CommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
begin
  case Command of
    CSC_NAVIGATEBACK:
      BackBtn.Enabled := Enable;
    CSC_NAVIGATEFORWARD:
      ForwardBtn.Enabled := Enable;
  end;
end;

procedure TEngineTR_2026.WebBrowser1BeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  WebBrowser1.Silent := True;
  URLs.Text := URL;
  Statusbar1.Panels[0].Text := URL;

  //stop searching while document loading
  currentSearchPanel.enabled := false;
end;

procedure TEngineTR_2026.ExitProgramClick(Sender: TObject);
begin
  if MessageDlg('For frequent use it is better to Minimize instead of exiting TR' + Chr(13) + 'Exit?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    close;
end;

function TEngineTR_2026.FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
var
  i, j: Integer;
  FormItem: Variant;
begin
  Result := False;
  //no form on document
  if WebBrowser.OleObject.Document.all.tags('FORM').Length = 0 then
    exit;

  //count forms on document
  for i := 0 to WebBrowser.OleObject.Document.forms.Length - 1 do
  begin
    FormItem := WebBrowser.OleObject.Document.forms.Item(i);
    for j := 0 to FormItem.Length - 1 do
    begin
      try
        //when the fieldname is found, try to fill out
        //ShowMessage(FormItem.Item(j).Name);
        if FormItem.Item(j).Name = FieldName then
        begin
          FormItem.Item(j).Value := Value;
          Result := True;
        end;
      except
        Exit;
      end;
    end;
  end;
end;

procedure TEngineTR_2026.Print1Click(Sender: TObject);
var
  //OldCur: TCursor;
  vaIn, vaOut: OleVariant; // Needed in all examples
begin
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER, vaIn, vaOut);
end;

procedure TEngineTR_2026.FillDataBtnClick(Sender: TObject);
begin
 //ShowMessage('filename='+FileName);
  FillForm(WebBrowser1, 'uploaded_file', FileName);
  FillForm(WebBrowser1, 'AGENTNUM', OnlineNo);
  FillForm(WebBrowser1, 'AGENTPASS', Password);
  FillForm(WebBrowser1, 'PMTIND', 'Checked');
end;

procedure TEngineTR_2026.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

function TEngineTR_2026.GetHTMLCode(WebBrowser1: TWebBrowser; var TempList: TStringList): Boolean;
var
  ps: IPersistStreamInit;
  ss: TStringStream;
  sa: IStream;
  s: string;
begin
  ps := WebBrowser1.Document as IPersistStreamInit;
  s := '';
  ss := TStringStream.Create(s);
  try
    sa := TStreamAdapter.Create(ss, soReference) as IStream;
    Result := Succeeded(ps.Save(sa, True));
    try
      if Result then
        TempList.Add(ss.Datastring);
    except
    end;
  finally
    ss.Free;
  end;
end;


function TEngineTR_2026.IsKeyWInDocument(WB: TWebBrowser; sText: string): Boolean;
var
  tr: IHTMLTxtRange;
begin
  Result := False;

  tr := ((WB.Document as IHTMLDocument2).body as IHTMLBodyElement).createTextRange;
  if Assigned(WB.Document) then
  begin
    if tr.findText(sText, 1, 0) then
      result := True;
  end;
end;

procedure TEngineTR_2026.SaveHTMLSource(WB: TWebBrowser; const FileName: string);
var
  PersistStream: IPersistStreamInit;
  Stream: IStream;
  FileStream: TFileStream;
begin
  if not Assigned(WB.Document) then
  begin
    delay(10000);
  end;

  if not Assigned(WB.Document) then
  begin
    ShowMessage('Document not loaded!');
    exit;
  end;

  PersistStream := WB.Document as IPersistStreamInit;
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    Stream := TStreamAdapter.Create(FileStream, soReference) as IStream;
    if Failed(PersistStream.Save(Stream, True)) then
      ShowMessage('Save HTML Source fail!');
  finally
    FileStream.Free;
  end;
end;

procedure TEngineTR_2026.TreeView1DblClick(Sender: TObject);
var
  SourceNode: TTreeNode;
  Ndx: Integer;
  Flags: OLEVariant;
  Url: string;
begin
  if Treeview1.Items.count = 0 then
    exit;
  Flags := 0;
  SourceNode := Treeview1.Selected;
  Ndx := SourceNode.OverlayIndex; //20200813 Igor
  if Ndx > -1 then //i>-1 then
  begin
    Url := Trim(arrURLs[Ndx]); //20200813 Igor
    //showmessage(Url);
    if Url > '' then
      WebBrowser1.Navigate2(Url);
  end;
end;

procedure TEngineTR_2026.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    SearchTitlesBtnClick(Sender);
end;

{
function TEngineTR_2025.GetUrlPrefix(Id: string; TrSourcesList: TStringList): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to TrSourcesList.count - 1 do
  begin
    if UpperCase(Id) = UpperCase(Trim(LeftStr(TrSourcesList[i], 16))) then
    begin
      Result := MidStr(TrSourcesList[i], 169, 250);
      Exit;
    end;
  end;
end;
}


{
function TEngineTR_2025.GetTrSourceDescription(Id: string; TrSourcesList: TStringList): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to TrSourcesList.count - 1 do
  begin
    if UpperCase(Id) = UpperCase(Trim(LeftStr(TrSourcesList[i], 16))) then
    begin
      Result := MidStr(TrSourcesList[i], 17, 30);
      Exit;
    end;
  end;
end;
}

procedure TEngineTR_2026.ExpandBtnClick(Sender: TObject);
begin
  Screen.Cursor := CrHourGlass;
  try
    TreeView1.FullExpand;
    TreeView1.TopItem := TreeView1.Items[0];
  finally
    Screen.Cursor := CrDefault;
  end;
end;

procedure TEngineTR_2026.CollapseClick(Sender: TObject);
begin
  TreeView1.FullCollapse;
end;

function TEngineTR_2026.GetUrlFileDate(Filename: string; var FileDate: string): Boolean;
var
  Buffer: array[0..1024] of Char;
  NetHandle: HINTERNET;
  UrlHandle: HINTERNET;
  Reserved: dWord;
  BufSize: Cardinal;
  Success: Boolean;
begin
  Success := False;
  NetHandle := InternetOpen('Delphi 5.x', INTERNET_OPEN_TYPE_PRECONFIG, Nil, Nil, 0);
  if Assigned(NetHandle) then
  begin
    UrlHandle := InternetOpenUrl(NetHandle, PChar(Filename), Nil, 0, INTERNET_FLAG_RELOAD, 0);

    if Assigned(UrlHandle) then
    begin
      Buffer := '';
      BufSize := SizeOf(Buffer);
      Reserved := 0;

      Success := HttpQueryInfo(UrlHandle, HTTP_QUERY_LAST_MODIFIED, @Buffer, BufSize, Reserved);
      if Success then
        FileDate := Buffer
      else
        FileDate := 'FILE_NOT_FOUND';
      InternetCloseHandle(UrlHandle);
    end;
    InternetCloseHandle(NetHandle);
  end;
  showmessage(FileDate);
  Result := Success;
end;

(* //20211229 Igor
function TEngineTR_2025.IsUrlValid(const url: string): boolean;
var
  hInet: HINTERNET;
  hConnect: HINTERNET;
  infoBuffer: array[0..512] of char;
  dummy: DWORD;
  bufLen: DWORD;
  okay: LongBool;
  reply: string;
begin
  hInet := InternetOpen(PChar(application.title), INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY, nil, nil, 0);
  hConnect := InternetOpenUrl(hInet, PChar(url), nil, 0, INTERNET_FLAG_NO_UI, 0);
  if not Assigned(hConnect) then
    //----------------------------------------------------------
    // If we couldn't open a connection then we know the url
    // is bad. The most likely reason is that the url is bad,
    // but it could be because of an unknown or badly specified
    // protocol.
    //----------------------------------------------------------
    result := false
  else
  begin
    //------------------------------
    // Create a request for the url.
    //------------------------------
    dummy := 0;
    bufLen := Length(infoBuffer);
    okay := HttpQueryInfo(hConnect, HTTP_QUERY_STATUS_CODE, @infoBuffer[0], bufLen, dummy);
    if not okay then
      // Probably working offline, or no internet connection.
      result := False
    else
    begin
      reply := infoBuffer;
      if reply = '200' then
        // File exists, all ok.
        result := True
      else if reply = '401' then
        // Not authorised. Assume page exists,
        // but we can't check it.
        result := True
      else if reply = '404' then
        // No such file.
        result := False
      else if reply = '500' then
        // Internal server error.
        result := False
      else
        // Shouldn't get here! It means there is
        // a status code left unhandled.
        result := False;
    end;
    InternetCloseHandle(hConnect);
  end;
  InternetCloseHandle(hInet);
end;
*)

(* //20211229 Igor
function TEngineTR_2025.DownLoadFromWeb(url, remoteFlName, localDir, localFlName: string): boolean;
const
  BufferSize = 1024;
//const fileURL = string;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: file;
  sAppName: string;
  fileURL, FileName: string;
begin
  ProgressBar1.Position := 0;
  ProgressBar1.Max := 100;  //120k
  fileURL := url + remoteFlName;
  FileName := TPath.Combine(localDir, localFlName); //20180206 Igor
  sAppName := ExtractFileName(Application.ExeName);

  hSession := InternetOpen(PChar('' + sAppName), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
 //If hSession=Nil then exit; //does not work
  try
    result := false;
    hURL := InternetOpenURL(hSession, PChar('' + fileURL), nil, 0, 0, 0);
  //If hUrl=Nil then exit;  //does not work
    try
      AssignFile(f, FileName);
      Rewrite(f, 1);
      repeat
        InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
        Screen.Cursor := crHourGlass;
        BlockWrite(f, Buffer, BufferLen);
    //ProgressBar1.Position:=ProgressBar1.Position+1000;
      until BufferLen = 0;
      CloseFile(f);
      Result := True;
    finally
      InternetCloseHandle(hURL)
    end
  finally
    InternetCloseHandle(hSession)
  end;
  Screen.Cursor := crDefault;
  ProgressBar1.Position := 30;
end;
*)

procedure TEngineTR_2026.ExpandANodeBtnClick(Sender: TObject);
var
  i: integer;
  SourceNode: TTreeNode;
  Rec: string;
  Flags: OLEVariant;
begin
  Flags := 0;

  for i := 0 to Treeview1.Items.count - 1 do
  begin
    SourceNode := Treeview1.Items[i];
    Rec := SourceNode.text;
    if LeftStr(Rec, 5) = 'Basic' then
      SourceNode.Expand(True);
  end;
  TreeView1.TopItem := TreeView1.Items[0];
end;

procedure TEngineTR_2026.TreeView1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    TreeView1DblClick(Sender);
end;

procedure TEngineTR_2026.SearchTitlesBtnClick(Sender: TObject);
var
  WList: TStringList;
begin
  if SearchBox.Text = '' then
  begin
    ShowMessage('Please enter keyword in the Search box');
    Exit;
  end;

  WList := TStringList.Create;

// SearchViaTreeView(SearchBox.Text,SearchOptionBox.ItemIndex);
  SearchViaTreeView(SearchBox.Text, searchWordOptionsComboBox.ItemIndex);

  WList.Free;
end;

procedure TEngineTR_2026.SearchViaTreeView(AString: string; SearchOption: Integer);
var
  i, j, jj, paddrAmount: integer;
  SourceNode: TTreeNode;
  Rec: string;
  Flags: OLEVariant;
  Url: string;
  FoundWord: Boolean;
  DocumentSource: string;
  WList: TStringList;
  s: string;
begin
  Flags := 0;
  DocumentSource := '';
 //SourceAddedToList:=False;
  if SearchBox.Text = '' then
    exit;

  Screen.Cursor := crHourGlass;

  SomeCaption := SearchBox.Text;
  SomeList.Clear;

  AString := UpperCase(Trim(AString));

  paddrAmount := 100;

  for i := 0 to Treeview1.Items.count - 1 do
  begin
    SourceNode := Treeview1.Items[i];
    Rec := SourceNode.text;
    if SourceNode.Level = 0 then
      DocumentSource := Rec;

    case SearchOption of
      0: //all words
        begin
          WList := TStringList.Create;
          ParseWords(AString, ' ', WList);
          FoundWord := False;
          for jj := 0 to WList.Count - 1 do
          begin
            if Pos(WList[jj], UpperCase(Rec)) > 0 then
              FoundWord := True
            else
            begin
              break;
            end;
            if FoundWord = True then
            begin
              s := PaddR(Trim(IntToStr(i)), 7);
       //If Trim(LinkList[i])>'' then
              SomeList.Add(s + ' ' + PaddR(DocumentSource, paddrAmount) + ' ' + Rec);
            end;
          end; //option 2
        end;

      1: // Any words
        begin
          FoundWord := False;
          WList := TStringList.Create;
          ParseWords(AString, ' ', WList);
          for jj := 0 to WList.Count - 1 do
          begin
            if Pos(WList[jj], UpperCase(Rec)) > 0 then
            begin
              FoundWord := True;
              Break;
            end;
          end;
          if FoundWord = True then
          begin
            s := PaddR(Trim(IntToStr(i)), 7);
            SomeList.Add(s + ' ' + PaddR(DocumentSource, paddrAmount) + ' ' + Rec);
          end;
          WList.Free;
        end; //option 1

      2: //exact phrase
        begin
          j := Pos(AString, UpperCase(Rec));
          if j > 0 then
          begin
            s := PaddR(Trim(IntToStr(i)), 7);
            SomeList.Add(s + ' ' + PaddR(DocumentSource, paddrAmount) + ' ' + Rec);
          end;
        end;
    end; //Option case

  end; //i treeview

  if SomeList.Count = 0 then
  begin
    ShowMessage('No matches in Titles.');
    Screen.Cursor := crDefault;
    Exit;
  end;

  RemoveDuplicateLinks(SomeList);

  Screen.Cursor := crDefault;
  with TPopTreeViewTR_2026.Create(Application) do
    try
      ShowModal;
    finally
      Free;
    end;
  if SelectedString > '' then
  begin
    i := StrToIntDef(Trim(MidStr(SelectedString, 102, 7)), 0); //the i portion
    //Url := Trim(LinkList[i]);
    Url := Trim(arrURLs[i]);
    if Url > '' then
      WebBrowser1.Navigate2(Url);
  end;
end;

procedure TEngineTR_2026.RemoveDuplicateLinks(var SomeList: TStringList);
var
  i, k: Integer;
  UsedLinks, NewList: TStringList;
  s:string;
begin
  UsedLinks := TStringList.Create;
  NewList := TStringList.Create;
  try
    for i := 0 to SomeList.count - 1 do
    begin
      k := StrToIntDef(Trim(MidStr(SomeList[i], 1, 7)), 0); //the i portion

      //s := Trim(LinkList[k]);
      s := Trim(arrURLs[k]);
      //if UsedLinks.IndexOf(Trim(LinkList[k])) = -1 then  //used already
      if UsedLinks.IndexOf(s) = -1 then  //used already
      begin
        NewList.Add(SomeList[i]);
        //UsedLinks.Add(Trim(LinkList[k]));
        UsedLinks.Add(Trim(arrURLs[k]));
      end;
    end;
    SomeList.Assign(NewList);
  finally
    UsedLinks.Free;
    NewList.Free;
  end;
end;

function TEngineTR_2026.IsConnectedToInternet: Boolean;
var
  dwConnectionTypes: Integer;
begin
  try
    dwConnectionTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN + INTERNET_CONNECTION_PROXY;
    if InternetGetConnectedState(@dwConnectionTypes, 0) then
      Result := true
    else
      Result := false;
  except
    Result := false;
  end;
end;

procedure TEngineTR_2026.WebHomeBtnClick(Sender: TObject);
begin
  ShowTrGuide;
end;

procedure TEngineTR_2026.TrGuideBtnClick(Sender: TObject);
begin
  ShowTrGuide;
end;

procedure TEngineTR_2026.ShowTrGuide;
begin
  WebBrowser1.Navigate2(HomePage);
end;

procedure TEngineTR_2026.AddLocalITA;
var
  i: Integer;
  title, link: string;
  TempList: TstringList;
begin
  if FileExists(ITAMenuFlName) then
  begin
    TempList := TstringList.Create;
    try
      TempList.LoadFromFile(ITAMenuFlName);

      for i := 0 to TempList.Count - 1 do
      begin
        title := MidStr(TempList[i], 156, 250);
        link := Trim(MidStr(TempList[i], 16, 140));

        TitleList.add(title);
        if i = 0 then
          LinkList.Add('') //do not add link to header title
        else
          LinkList.Add(TPath.Combine(AppDir, ITAFlName) + link);
      end;
    finally
      TempList.Free;
    end;
  end;
end;

procedure TEngineTR_2026.AddOtherTrSources;
var
  i: Integer;
  TempList: TstringList;
begin
  if TFile.Exists(TPath.Combine(AppDir, 'websites.d')) then
  begin
    TitleList.Add('OTHER TR SOURCES');
    LinkList.Add('');

    TempList := TstringList.Create;
    try
      TempList.LoadFromFile(TPath.Combine(AppDir, 'websites.d'));
      if TempList.count >= 2 then
      begin
        i := 0;
        repeat
          TitleList.Add(' ' + TempList[i]);   //this goes to titles
          LinkList.Add(TempList[i + 2]);
          Inc(i, 4);
        until i > TempList.count - 1;
      end;
    finally
      TempList.Free;
    end;
  end;
end;

procedure TEngineTR_2026.SetUp1Click(Sender: TObject);
begin
  ShowMessage('You can add your favorite sites for tax research in the upcoming window');
  if not ExecAndWait(TPath.Combine(AppDir, 'WebSites.exe'), '', SW_RESTORE) then
  begin
    ShowMessage(SysErrorMessage(GetLastError));
    exit;
  end;
  reLoadTrFromWeb;
end;

procedure TEngineTR_2026.TrGuide1Click(Sender: TObject);
begin
  ShowTrGuide;
end;

procedure TEngineTR_2026.NotePad1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, Nil, 'NotePad.Exe', Nil, '', SW_RESTORE);
end;

procedure TEngineTR_2026.Download2Click(Sender: TObject);
begin
  if DownLoadITA then
    ShowITA;
end;

procedure TEngineTR_2026.ShowITA;
var
  FlName: string;
begin
  FlName := TPath.Combine(AppDir, ITAFlName);
  if not FileExists(FlName) then
  begin
    ShowMessage('Please Download the current Income Tax Act. See Menu | File');
    Exit;
  end;
  WebBrowser1.Navigate2(FlName);
  reLoadTrFromWeb;
end;

function TEngineTR_2026.DownloadITA;
var
  i: Integer;
  Url, RemoteFlName, LocalDir, LocalFlName: string;
  H: Thandle;
begin
  result := false;
  Screen.Cursor := crHourGlass;
  Screen.Cursor := CrAppStart;
  RemoteFlName := ChangeFileExt(ITAFlName, '.EXE'); //F'IncomeTaxAct.EXE';
  LocalFlName := RemoteFlName;
  LocalDir := 'C:\';
  Url := 'https://www.visualtax.com/TR/'; // Url:= 'http://www.visualtax.com/downloads/'; //20211229 Igor

  if IsConnectedToInternet = false then
  begin
    ShowMessage('Internet connection not found, please check your connection and try again');
    Screen.Cursor := crDefault;
    exit;
  end;

  //20211229 Igor >>>
  if fileexists(TPath.Combine(AppDir, ITAFlName)) then
    DeleteFile(TPath.Combine(AppDir, ITAFlName));

  (*
   if not IsUrlValid(Url + RemoteFlName {+ 'testingWrongName'}) then
  begin
    ShowMessage('The Income Tax Act is currently not available for download.');
    Screen.Cursor := CrDefault;

    if fileexists(TPath.Combine(AppDir, ITAFlName)) then
    begin
      DeleteFile(TPath.Combine(AppDir, ITAFlName));
    end;
    exit;
  end;
  *)

  if GetFileWithNoCache(Url + RemoteFlName, TPath.Combine(LocalDir, LocalFlName)) then
  begin
  //open the self extracting zip file VtTrUpd.exe
    H := ShellExecute(Self.Handle, 'open', PChar(TPath.Combine(LocalDir, LocalFlName)), Nil, Nil, SW_HIDE); //Sw_Show
    if H <= 32 then
    begin
      showMessage('Downloading failed...');
      Exit;
    end;
  end
  else
  begin
    //ShowMessage('Error in file download');
    exit;
  end;
  //20211229 Igor <<<

 //ShowMessage('Delaying use of files');
  Sleep(500);
  Application.ProcessMessages;

  for i := 1 to 20 do
  begin
    while (not FileExists(TPath.Combine(LocalDir, ITAFlName))) and (not FileExists(TPath.Combine(LocalDir, ChangeFileExt(ITAFlName, '.txt')))) do
    begin
      Sleep(800);
    end;
  end;

  if (FileExists(TPath.Combine(LocalDir, ITAFlName))) and (FileExists(TPath.Combine(LocalDir, ITAMenuFlName))) then
  begin
    TFile.Copy(LocalDir + ITAFlName, TPath.Combine(AppDir, ITAFlName));
    SysUtils.DeleteFile(TPath.Combine(LocalDir, ITAFlName));

    TFile.Copy(TPath.Combine(LocalDir, ITAMenuFlName), TPath.Combine(AppDir, ITAMenuFlName));
    SysUtils.DeleteFile(TPath.Combine(LocalDir, ITAMenuFlName));

    if (FileExists(TPath.Combine(LocalDir, LocalFlName))) then
      SysUtils.DeleteFile(TPath.Combine(LocalDir, LocalFlName));

    result := true;
  end;
  Screen.Cursor := crDefault;
end;

procedure TEngineTR_2026.GoogleSearchBtnClick(Sender: TObject);
begin
  if SearchBox.Text = '' then
  begin
    ShowMessage('Please enter keyword in the Search box');
    Exit;
  end;

  GoogleSearch(SearchBox.Text);
end;

procedure TEngineTR_2026.GoogleSearch(AString: string);
var
  searchString, quotes, url: string;
  site1, site2, site3, site4, site5, site6: string;
begin

  searchString := Trim(AString);

  case searchWordOptionsComboBox.ItemIndex of
    0:
      begin
     //all words
        quotes := '';
      end;
    1:
      begin
     //any word
        quotes := '';
        searchString := StringReplace(searchString, ' ', '+OR+', [rfReplaceAll, rfIgnoreCase]);
      end; //option 1
    2:
      begin
      //this phrase
        quotes := '%22';
      end;
  end;  //case

  searchString := quotes + searchString + quotes;

  //var not used
  site1 := 'canada.ca';
  site2 := 'laws.justice.gc.ca';
  site3 := 'bankofcanada.ca';
  site4 := ''; //ontario.ca/
  site5 := ''; //www.bdo.ca/';
  site6 := ''; //www.bankofcanada.ca/';

           //https://www.google.com/search?hl=en-CA&source=hp&biw=&bih=&q=justice+site%3Alaws.justice.gc.ca+%7C+canada.ca
  //url :=  'https://www.google.com/search?hl=en-CA&source=hp&biw=&bih=&q=' + searchString + '+site%3A' + site1 + '+%7C+' + site2;
  url :=  'https://www.google.com/search?q=' + searchString + '+site%3Alaws.justice.gc.ca+|+canada.ca+|+bankofcanada.ca';
  WebBrowser1.Navigate2(url);
end;

procedure TEngineTR_2026.FindBtnClick(Sender: TObject);
begin
  if Assigned(WebBrowser1.Document) then
  begin
    if UpperCase(RightStr(WebBrowser1.OleObject.Document.Url, 3)) = 'PDF' then
      ShowMessage('This is a PDF file. You can use the Search button of your Adobe PDF menu')
    else
      WB_ShowFindDialog(WebBrowser1);
  end;

 //SelectHighlightWord:='tax';
// if Assigned(WebBrowser1.Document) then WBHighlight(WebBrowser1,SelectHighlightWord);
end;

procedure TEngineTR_2026.WB_ShowFindDialog(AWebbrowser: TWebbrowser);
const
  CGID_WebBrowser: TGUID = '{ED016940-BD5B-11cf-BA4E-00C04FD70816}';
  HTMLID_FIND = 1;
  HTMLID_VIEWSOURCE = 2;
  HTMLID_OPTIONS = 3;
var
  CmdTarget: IOleCommandTarget;
  vaIn, vaOut: OleVariant;
  PtrGUID: PGUID;
begin
  New(PtrGUID);
  PtrGUID^ := CGID_WebBrowser;
  if AWebbrowser.Document <> nil then
  try
    AWebbrowser.Document.QueryInterface(IOleCommandTarget, CmdTarget);
    if CmdTarget <> nil then
    try
      CmdTarget.Exec(PtrGUID, HTMLID_FIND, 0, vaIn, vaOut);
    finally
      CmdTarget._Release;
    end;
  except
     // Nothing
  end;
  Dispose(PtrGUID);
end;

procedure TEngineTR_2026.WB_SaveAs_HTML(WB: TWebBrowser; const FileName: string);
var
  PersistStream: IPersistStreamInit;
  Stream: IStream;
  FileStream: TFileStream;
begin
  if not Assigned(WB.Document) then
  begin
    ShowMessage('Document not loaded!');
    Exit;
  end;

  PersistStream := WB.Document as IPersistStreamInit;
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    Stream := TStreamAdapter.Create(FileStream, soReference) as IStream;
    if Failed(PersistStream.Save(Stream, True)) then
      ShowMessage('SaveAs HTML failed!');
  finally
    FileStream.Free;
  end;
end; (* WB_SaveAs_HTML *)

procedure TEngineTR_2026.SaveDocument1Click(Sender: TObject);
begin
  if not SysUtils.DirectoryExists(TPath.Combine(AppDir, 'TR-Projects')) then
    SysUtils.ForceDirectories(TPath.Combine(AppDir, 'TR-Projects'));
  SaveDialog1.InitialDir := TPath.Combine(AppDir, 'Tr-Projects');
  if UpperCase(RightStr(Trim(UrlLbl.Caption), 3)) = 'PDF' then
  begin
    ShowMessage('This is a PDF file: To save use the Save a copy button of the PDF menu');
    Exit;
  end;
 //html file by default
  SaveDialog1.FileName := ExtractFileNameFromUrl(WebBrowser1.LocationUrl); //showmessage(WebBrowser1.LocationName);showmessage(WebBrowser1.LocationUrl);
  SaveDialog1.Filter := '*' + ExtractFileExt(WebBrowser1.LocationUrl) + '|*.*'; //saveDialog1.Filter := 'Text file|*.txt|Word file|*.doc';

  if SaveDialog1.Execute then
  begin
    WB_SaveAs_HTML(WebBrowser1, SaveDialog1.FileName);
    ShowMessage('Saved in ' + SaveDialog1.FileName);
  end;
end;

procedure TEngineTR_2026.LinkToAWebSite1Click(Sender: TObject);
var
  aUrl: string;
begin
  aUrl := 'http://www.cra-arc.gc.ca';
  if InputQuery('Enter a Web site URL address', 'In format:   http://www.xxxxx.yyy', aUrl) then
    if aUrl > '' then
      WebBrowser1.Navigate2(aUrl);
end;

procedure TEngineTR_2026.TrUserGuide1Click(Sender: TObject);
begin
  ShowTrGuide;
end;

procedure TEngineTR_2026.About1Click(Sender: TObject);
begin
  with TAboutTR_2026.Create(Application) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TEngineTR_2026.Exit1Click(Sender: TObject);
begin
  ExitProgramClick(Sender);
end;

procedure TEngineTR_2026.Minimize1Click(Sender: TObject);
begin
  Application.Minimize;
//WindowState:=wsMinimized;
end;

procedure TEngineTR_2026.CBListener1ClipboardChanged(Sender: TObject);
begin
  DoClipBoardChanged;
end;

procedure TEngineTR_2026.DoClipBoardChanged;
var
  ClipboardText: String;
  WList: TStringList;
  ActionVerb: string;
  SearchValue: string;
  ClipbdDelim: string;
begin

   //ShowTimedMsg('Checking messages',2500);
  try
    if (Titlelist = Nil) or (LinkList = Nil) then
    //Clipboard.Clear;
   //If (Titlelist.count=0) or (LinkList.count=0) then
      Exit;
  except
    Exit;
  end;

  if Clipboard.AsText = '' then
    exit;
  ClipbdDelim := '|';
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    ClipboardText := Clipboard.AsText;
    if (LeftStr(ClipboardText, 8) = 'From T1' + ClipbdDelim) or (LeftStr(ClipboardText, 8) = 'From T2' + ClipbdDelim) then
    begin
      WList := TstringList.Create;
      ParseWords(ClipboardText + ClipbdDelim, ClipbdDelim, WList);
      ActionVerb := WList[1];
      SearchValue := WList[2];

      if (ActionVerb = 'Search') then
      begin
        SearchBox.Text := SearchValue;
        if UpperCase(LeftStr(SearchValue, 5)) = 'LINE ' then
          SearchOptionBox.ItemIndex := 2;
        WList.Free;
        if SearchBox.text > '' then
          SearchTitlesBtnClick(Application);
        Clipboard.Clear;
        Application.BringToFront;
        Application.Restore;
      end;
    end;  //has legitimate text
  end;  //has text
end;

procedure TEngineTR_2026.TestModeBtnClick(Sender: TObject);
begin
  Treeview1.Items.clear;
  TitleList.Clear;
  LinkList.Clear;
  LoadTrFromLocalDrive;
  LoadTreeview;
end;

procedure TEngineTR_2026.ProductionModeBtnClick(Sender: TObject);
begin
  TitleList.Clear;
  LinkList.Clear;
  Treeview1.Items.Clear;
  ProgressPanel.Visible := True;
  try
    LoadTr; //20200813 Igor
    LoadTreeview;
  finally
    ProgressPanel.Visible := False;
  end;
end;

procedure TEngineTR_2026.WBHighlight(WB: TWebBrowser; sText: string);
var
  i: Integer;
  prefix, suffix: string;
  tr: IHTMLTxtRange;
begin
  i := Pos(ITAFlName, UrlLbl.Caption);
  if i > 0 then
  begin
    //ShowTimedMsg('Due to size (6 Meg), Highlighting is not provided for the ITA',2000);
    exit;
  end;
  if Length(sText) < 2 then
  begin
    RefreshClick(Application);
    Exit;
  end;

  prefix := '<span style="color:red; background-color: yellow;">';
  suffix := '</span>';
  try
    if Assigned(WB.Document) then
    begin
      tr := ((WB.Document as IHTMLDocument2).body as IHTMLBodyElement).createTextRange;
      tr.scrollIntoView(True);  // focus on first element

      if not tr.findText(sText, 1, 0) then
       //showTimedMsg('No results found for "' + sText + '" ',1500)

      else
        tr.scrollIntoView(True);  // focus on element

      while tr.findText(sText, 1, 0) do
      begin
        tr.pasteHTML(prefix + tr.htmlText + suffix);
        //tr.scrollIntoView(True);  // focus on element
      end;
    end;
  except
  end;
end;

procedure TEngineTR_2026.findPrevious(Sender: TObject);
begin

  showmessage(textRange.text);
  showmessage(textRange.htmlText);

   {
   //finding links
   Document := WebBrowser1.Document as IHTMlDocument2;

   for i := 0 to Document.Links.Length - 1 do
   begin
        Link := Document.Links.Item(i, 0) as IHTMLElement;
        StrLinks := Link.ToString + #13#10;
        ShowMessage(StrLinks);
   end;

}
end;

procedure TEngineTR_2026.findNext(Sender: TObject);
var
  WB: TWebBrowser;
  sText: string;
begin
  WB := WebBrowser1;
  sText := Highlightbox.text;
  try
    if (Assigned(WB.Document)) and (sText <> '') then
    begin
      textRange.moveStart('Word', 1);
      if textRange.findText(sText, 1, 0) then
      begin
        textRange.select;
        textRange.scrollIntoView(True);  // focus on element
      end
      else
      begin
        textRange := ((WB.Document as IHTMLDocument2).body as IHTMLBodyElement).createTextRange;
        if textRange.findText(sText, 1, 0) then
        begin
          textRange.select;
          textRange.scrollIntoView(True);  // focus on element
        end
      end;
    end;
  except
  end;

end;

procedure TEngineTR_2026.HighlightBtnClick(Sender: TObject);
begin
  if (HighlightBox.Text > '') and (Assigned(WebBrowser1.Document) = True) then
    WBHighlight(WebBrowser1, HighlightBox.Text);
  if (HighlightBox.Text = '') and (Assigned(WebBrowser1.Document) = True) then
    RefreshClick(Sender);

end;

procedure TEngineTR_2026.ClearSearchBtnClick(Sender: TObject);
begin
  HighlightBox.Text := '';
  HighlightBox.Color := clWindow;
  if Assigned(WebBrowser1.Document) = True then
    RefreshClick(Sender);
end;

procedure TEngineTR_2026.HighlightBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if (highlightbox.color <> clWindow) and (Key <> #8) and (highlightbox.text <> '') then
    Key := #0
  else if Key = #13 then
  begin
    HighlightBoxChange(Sender);
    findNext(Sender);
    Key := #0; //stop the beep
  end;
end;

procedure TEngineTR_2026.HighlightBoxChange(Sender: TObject);
var
  WB: TWebBrowser;
  sText: string;
begin

  WB := WebBrowser1;
  sText := Highlightbox.text;
  if sText = '' then
  begin
    textRange := ((WB.Document as IHTMLDocument2).body as IHTMLBodyElement).createTextRange;
    Highlightbox.Color := clWindow;
    exit;
  end;
  try
    if Assigned(WB.Document) then
    begin
      if (textRange.findText(sText, 1, 0)) and (sText <> '') then
      begin
        Highlightbox.Color := clWindow;
        textRange.Select;
        textRange.scrollIntoView(True);  // focus on first element
      end
      else
      begin
        Highlightbox.Color := clYellow;
        sText := rightStr(sText, 1);
      end;
    end;
  except
  end;

end;

function TEngineTR_2026.ReplaceSpecialChar(info: string): string;
begin
  Result := ReplaceStr(info, '&', 'and');
// info := ReplaceChar(info, '<' , ' ' );
// info := ReplaceChar(info,'"','&quot;');
// info := ReplaceChar(info,'>','&gt;');
// info := ReplaceChar(info,'''','&apos;');
// info := ReplaceChar(info,'.','');
end;

procedure TEngineTR_2026.CRASearchClick(Sender: TObject);
var
  delim, searchString, url: string;
begin
  if SearchBox.Text = '' then
  begin
    ShowMessage('Please enter keyword in the Search box');
    Exit;
  end;

  delim := ' ';
  searchString := '';

  searchString := ReplaceSpecialChar(SearchBox.text);
  searchString := StringReplace(Trim(searchString), ' ', '+', [rfReplaceAll, rfIgnoreCase]);
  {
  ParseWords(S,Delim,WList);
  For i:=0 to WList.count-1 do
   searchString := searchString + '+' + WList[i];
  }
  //Case SearchOptionBox.ItemIndex of
  case searchWordOptionsComboBox.ItemIndex of
    0:
      begin
        //all words
             // https://www.canada.ca/en/sr/srb/sra.html?allq=test+test&exctq=&anyq=&noneq=&fqupdate=&dmn=&fqocct=#wb-land
        url := 'https://www.canada.ca/en/sr/srb/sra.html?allq=' + searchString + '&exctq=&anyq=&noneq=&fqupdate=&dmn=&fqocct=#wb-land';
      end;
    1:
      begin
     //any word
             // https://www.canada.ca/en/sr/srb/sra.html?allq=test+test&exctq=&anyq=&noneq=&fqupdate=&dmn=&fqocct=#wb-land
        url := 'https://www.canada.ca/en/sr/srb/sra.html?allq=&exctq=&anyq=' + searchString + '&noneq=&fqupdate=&dmn=&fqocct=#wb-land';
      end; //option 1
    2:
      begin
        //this phrase
             // https://www.canada.ca/en/sr/srb/sra.html?allq=test+test&exctq=&anyq=&noneq=&fqupdate=&dmn=&fqocct=#wb-land
        url := 'https://www.canada.ca/en/sr/srb/sra.html?allq=&exctq=' + searchString + '&anyq=&noneq=&fqupdate=&dmn=&fqocct=#wb-land';
      end;
  end;  //case

  WebBrowser1.Navigate2(url);
end;

procedure TEngineTR_2026.ShowtheIncomeTaxAct1Click(Sender: TObject);
begin
  ShowITA;
end;

procedure TEngineTR_2026.Deregisterprogram1Click(Sender: TObject);
const
  ActivationFile = 'LVerf.EX_';
begin
  if MessageDlg('BE CAREFUL' + Chr(13) + 'If you click Yes the program will terminate and ask you for a new key', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if FileExists(TPath.Combine(AppDir, ActivationFile)) then
      Sysutils.DeleteFile(TPath.Combine(AppDir, ActivationFile));
    Application.Terminate;
  end;
end;

procedure TEngineTR_2026.Importwebsitesfrompreviousyear1Click(Sender: TObject);
var
  FlName: string;
  LastYr: string;
begin
  LastYr := IntToStr(StrToInt(AppYear) - 1);
  FlName := InputBox('If you used TR in ' + LastYr, 'Enter folder and file name of WebSites.d', 'C:\TR-' + LastYr + '\WebSites.d'); //'C:\TR-2007\WebSites.d');
  if FileExists(FlName) then
  begin
    TFile.Copy(FlName, TPath.Combine(AppDir, 'WebSites.d'));
    ShowMessage('Click here to refresh');
    TitleList.Clear;
    LinkList.Clear;
    Treeview1.Items.Clear;
    ProgressPanel.Visible := True;
    try
      LoadTr; //20200813 Igor
      LoadTreeview;
    finally
      ProgressPanel.Visible := False;
    end;
  end
  else
    ShowMessage('File Not Found');
end;

procedure TEngineTR_2026.WebPrintBtnClick(Sender: TObject);
begin
  Print1Click(Sender);
end;

procedure TEngineTR_2026.craDropDownOptionsBtnClick(Sender: TObject);
var
  button: TControl;
  lowerLeft: TPoint;
begin
  if Sender is TControl then
  begin
    button := TControl(Sender);
    lowerLeft := Point(0, button.Height);
    lowerLeft := button.ClientToScreen(lowerLeft);
    PopupMenu1.Popup(lowerLeft.X, lowerLeft.Y);
  end;
end;

procedure TEngineTR_2026.craDropDownOptionsClick(Sender: TObject);
var
  clicked: TmenuItem;
begin
  clicked := Sender as TmenuItem;
  clicked.Checked := true;
//  craSearch.caption := 'CRA Text ('+ clicked.caption +')';
  case clicked.MenuIndex of
    0:
      craDropDownOptionsBtn.caption := 'All Words';
    1:
      craDropDownOptionsBtn.caption := 'Any Word';
    2:
      craDropDownOptionsBtn.caption := 'Exact Phrase';
  end;
end;

procedure TEngineTR_2026.WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
var
  WB: TWebBrowser;
  tr: IHTMLTxtRange;
begin
  if (SearchBox.Text > '') and (Assigned(WebBrowser1.Document) = True) and (HighlightOption.Checked = True) then
    if (RightStr(UrlLbl.Caption, Length(ITAFlName)) <> ITAFlName) then
      WBHighlight(WebBrowser1, SearchBox.Text);

  WB := WebBrowser1;

    //showmessage(ExtractFileExt(wb.LocationURL));
  if not (ExtractFileExt(WB.LocationURL) = '.pdf') then
  begin

    currentSearchPanel.visible := true;

    try
      if Assigned(WB.Document) then
      begin
        tr := ((WB.Document as IHTMLDocument2).body as IHTMLBodyElement).createTextRange;
        textRange := tr;
        if (HighLightBox.Text = '') or (textRange.findText(HighLightBox.Text, 1, 0)) then
          HighLightBox.color := clWindow
        else
          HighLightBox.color := clYellow;

      end;
    except
    end;
    currentSearchPanel.enabled := true;
  end //if not pdf
  else
    currentSearchPanel.visible := false;

end;

procedure TEngineTR_2026.CheckUpdates1Click(Sender: TObject);
var
  h: THandle;
  spaceDelimiter, quotes, params: string;
begin
  Screen.Cursor := crHourGlass;

  spaceDelimiter := ' ';
  quotes := '"';
  params := spaceDelimiter + quotes + AppName + '-' + AppYear + quotes + spaceDelimiter + quotes + AppUpdateDate + quotes + spaceDelimiter + quotes + AppRelease + quotes + spaceDelimiter + quotes + 'c:\Downloads' + quotes + spaceDelimiter + quotes + AppDir + quotes + spaceDelimiter + quotes + 'http://www.visualtax.com/downloads/vtUpdate/vtVersions.xml' + quotes;

  h := ShellExecute(WindowHandle, 'open', 'VTChkUpd.Exe', Pchar(' ' + params), Nil, Sw_Show);

  if h <= 32 then
  begin
    ShowMessage('The Updater program cannot run.' + Chr(13) + 'Error Code:  ' + IntToStr(h));
    Screen.Cursor := crDefault;
    Exit;
  end;
  Screen.Cursor := crDefault;
end;

procedure TEngineTR_2026.ToolButton4Click(Sender: TObject);
var
  sText: string;
  WB: TWebBrowser;
  tr: IHTMLTxtRange;
begin
  WB := WebBrowser1;
  sText := '<input type="file" maxlength="100" size="30" name="uploaded_file"';
  try
    if Assigned(WB.Document) then
    begin
      tr := ((WB.Document as IHTMLDocument2).body as IHTMLBodyElement).createTextRange;
      tr.scrollIntoView(True);  // focus on first element

      if not tr.findText(sText, 1, 0) then
       //showTimedMsg('No results found for "' + sText + '" ',1500)

      else
        tr.scrollIntoView(True);  // focus on element
      while tr.findText(sText, 1, 0) do
      begin
        tr.pasteHTML('<p><input name="uploaded_file" type="text" id="uploaded_file" value="C:\LoOkInGfOrThEOthER\870000627-A-DUMMY-TESTONLY-OTHER.TAX" size="30" maxlength="100" /></p>');
        //tr.scrollIntoView(True);  // focus on element
      end;
    end;
  except
  end;
end;

procedure TEngineTR_2026.TreeView1Expanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
begin
  if pos('(Local)', Node.text) > 0 then
  begin
    if not FileExists(TPath.Combine(AppDir, ITAFlName)) then
    begin
      AllowExpansion := false;
      if MessageDlg('The Income Tax Act (Local) has not been downloaded. Download it now?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        Exit
      else
        Download2Click(Sender);
    end;
  end;
end;

procedure TEngineTR_2026.getUrlFileDateBtnClick(Sender: TObject);
var
  s: string;
begin
  GetUrlFileDate('http://www.visualtax.com/downloads/' + 'VTTRUPD' + AppYear + '.exe', s);
  showmessage(s);
end;

initialization
  AppDir := ExtractFileDir(Application.ExeName);
  OleInitialize(nil);  //allows copy/paste in twebbrowser

finalization
  OleUninitialize;

end.

