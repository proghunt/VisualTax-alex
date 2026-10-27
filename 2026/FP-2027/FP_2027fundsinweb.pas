unit FP_2027fundsinweb;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Menus,ComCtrls,OleCtrls,Buttons,ToolWin,ActnList,ImgList,shdocvw,
  Printers,Db,ActiveX,FileCtrl,mshtml,ShellApi,Wininet,ClipBrd,Grids,
  DBGrids, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient,
  System.Actions;

  const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

  //for internet connection.....
  INTERNET_CONNECTION_MODEM           = 1;
  INTERNET_CONNECTION_LAN             = 2;
  INTERNET_CONNECTION_PROXY           = 4;
  INTERNET_CONNECTION_MODEM_BUSY      = 8;

type
  TFundsInWebFP_2012 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    View1: TMenuItem;
    NavigatorImages: TImageList;
    NavigatorHotImages: TImageList;
    LinksImages: TImageList;
    LinksHotImages: TImageList;
    Toolbar3: TMenuItem;
    Statusbar2: TMenuItem;
    Go1: TMenuItem;
    Back1: TMenuItem;
    Forward1: TMenuItem;
    Stop1: TMenuItem;
    Refresh1: TMenuItem;
    N2: TMenuItem;
    ActionList1: TActionList;
    BackAction: TAction;
    ForwardAction: TAction;
    StopAction: TAction;
    RefreshAction: TAction;
    ExitProgram: TMenuItem;
    Print1: TMenuItem;
    SetUp1: TMenuItem;
    ContainerPanel: TPanel;
    Splitter1: TSplitter;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    NotePad1: TMenuItem;
    SaveDocument1: TMenuItem;
    TrUserGuide1: TMenuItem;
    File1: TMenuItem;
    Configure1: TMenuItem;
    Exit1: TMenuItem;
    Panel3: TPanel;
    TOCHeaderPanel: TPanel;
    Collapse: TBitBtn;
    ExpandBtn: TBitBtn;
    Panel4: TPanel;
    WebBrowser1: TWebBrowser;
    DocumentHeaderPanel: TPanel;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    BackBtn: TToolButton;
    ForwardBtn: TToolButton;
    StopBtn: TToolButton;
    RefreshBtn: TToolButton;
    URLs: TComboBox;
    SearchBoxPanel: TPanel;
    Panel2: TPanel;
    Utilities1: TMenuItem;
    Advanced1: TMenuItem;
    Deregisterprogram1: TMenuItem;
    Importwebsitesfrompreviousyear1: TMenuItem;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    FundCodeBox: TEdit;
    SearchBtn: TBitBtn;
    FavoriteBox: TCheckBox;
    RemoveFilterBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    HeaderBox: TPanel;
    Label2: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Image1: TImage;
    Panel6: TPanel;
    GroupBox2: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    AnalyseBtn: TBitBtn;
    DataSource1: TDataSource;
    FDConnection: TADConnection;
    Query1: TADQuery;

    Procedure OpenQuery1;
    procedure ShowFundsGuide;
    procedure CBListener1ClipboardChanged(Sender: TObject);
    Procedure DoClipBoardChanged;
    procedure LoadTrFromWeb;
    procedure WB_ShowFindDialog(AWebbrowser: TWebbrowser);
    procedure WB_SaveAs_HTML(WB:TWebBrowser; const FileName : string);
    procedure StopClick(Sender: TObject);
    procedure URLsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure RefreshClick(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure ForwardClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure URLsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Toolbar3Click(Sender: TObject);
    procedure Statusbar2Click(Sender: TObject);
    Function  IsKeyWInDocument(WB: TWebBrowser; sText: string):Boolean;
    procedure BackActionUpdate(Sender: TObject);
    procedure ForwardActionUpdate(Sender: TObject);
    {procedure WebBrowser1BeforeNavigate2(Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);}
     procedure WebBrowser1BeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1DownloadBegin(Sender: TObject);
    procedure WebBrowser1DownloadComplete(Sender: TObject);
    procedure ExitProgramClick(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject;const pDisp: IDispatch; const URL: OleVariant);
    procedure WebBrowser1TitleChange(Sender: TObject;const Text: WideString);
    function FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
    procedure Print1Click(Sender: TObject);
    procedure WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
    procedure ShowBrowserProperties;
    procedure ExitBtnClick(Sender: TObject);
    Function GetConfirmationNoFromHtml:String;
    function  GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
    procedure SaveHTMLSource(WB:TWebBrowser; const FileName : string);
    Function  DownLoadFromWeb(url,remoteFlName,localDir,localFlName:string): boolean;
    Function IsConnectedToInternet: Boolean;
    procedure SetUp1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SaveDocument1Click(Sender: TObject);
    procedure LinkToAWebSite1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure AnalyseBtnClick(Sender: TObject);

   private
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;
    procedure FindAddress;
    procedure HomePageRequest(var message: tmessage); message CM_HOMEPAGEREQUEST;
  end;

var
  FundsInWeb: TFundsInWebFP_2012;
  FundType :string; //[2];
  FilterClause:String;
  FundCode:String;
  CaptureFileName:String;

  ItaFlName:String;
  ExpKeysFlName:String;
  TrSourceId,Descr,UrlPage,UrlPrefix:String;
  Keyw:String;
  CurDispatch: IDispatch; {save the interface globally }
  TitleList,LinkList:TStringList;
  OnLineNo,PassWord,FileName,Url,Refund,OnLineMethod:String;  //to be used bu the uhtmlEfOnline
  //F1:TextFile;

implementation

{$R *.DFM}

uses vtCommon,vtDialogs,FP_2027TrimStr,FP_2027CBListener,FP_2027PopTreeView,
  FP_2027MyStr,FP_2027Declare,vtTrimStr,vtShared;


procedure TFundsInWebFP_2012.FormCreate(Sender: TObject);
begin
 CaptureWebDir:=AppDir+'\'+'WebData';
 ForceDirectories(CaptureWebDir);
 //ExchangeBox.Text:='TO';
 OpenQuery1;
 //Flags:=0;
 HistoryIndex := -1;
 HistoryList := TStringList.Create;
 ShowFundsGuide;
 Screen.Cursor:=CrHourGlass;
 Screen.Cursor:=CrHourGlass;
 TitleList:=TStringList.Create;
 LinkList:=TStringList.Create;
 //See activate creates TitleList and linkList //LoadTreeView;  //
 Screen.Cursor:=CrDefault;
end;


procedure TFundsInWebFP_2012.LoadTrFromWeb;
Var TrSourcesFlName,TrTocFlName,TempFile:String;i:Integer;s:String;
 OriginalTocList:TStringList;
 title,ID:string;
 TrSourcesList:TStringList;
 url,remoteflname,localdir,localflname:string;
 h:THandle;
 Flags: OLEVariant;
 TotDelay:Integer;
begin
 Screen.Cursor:=crHourGlass;

 if IsConnectedToInternet = false then
 begin
  ShowMessage('Internet connection not found, please check your connection and try again');
  Screen.Cursor:=crDefault;
  exit;
 end;

 {
 Screen.Cursor:=crHourGlass;
 url:= 'http://www.visualtax.com/downloads/';
 LocalDir := 'c:\'; //where the dowloaded files are saved
 RemoteFlName := 'VTTRUPD2005.exe';
 LocalFlName := 'VTTRUPD2005.exe';
 TrSourcesFlName := 'C:\TrSources.txt';
 TrTocFlName:= 'C:\TRTOC.txt';
 ExpKeysFlName:='C:\ExpKeys.txt'; //expired tr keys

 if FileExists(TrSourcesFlName) then SysUtils.DeleteFile(TrSourcesFlName);
 if FileExists(TrTocFlName) then SysUtils.DeleteFile(TrTocFlName);
 if FileExists(ExpKeysFlName) then SysUtils.DeleteFile(ExpKeysFlName);
 If FileExists(LocalDir+LocalFlName) then SysUtils.DeleteFile(LocalDir+LocalFlName);
 ProgressBar1.Position:=0;
 //unzip the file
 if TrEngine.DownLoadFromWeb(url,remoteflname,localdir,localflname)=True then
 begin
  //open the self extracting zip file VtTrUpd.exe
  h := ShellApi.ShellExecute(Application.Handle,'open',PChar(localdir+localflname),Nil,Nil,SW_HIDE); //Sw_Show
  If H<=32 then
  begin
  showMessage('Downloading failed...');
  Screen.Cursor:=crDefault;
  Exit;
  end;
 end
 else
 begin
  ShowMessage('Error in file download');
  Screen.Cursor:=crDefault;
  exit;
 end;
 ProgressBar1.Position:=ProgressBar1.Position+10;
 //ShowMessage('Delaying use of files');
 For i:=1 to 150 do
 begin
  Screen.Cursor:=crHourGlass;
  while (not FileExists(TrSourcesFlName)) and (not FileExists(TrTocFlName)) do
  begin
   Delay(500);
   //TotDelay:=TotDelay+500;
   //If TotDelay>100000 then  begin Application.Terminate; end;
  end;
 end;
 ProgressBar1.Position:=ProgressBar1.Position+10;
 Try
  if FileExists(TrSourcesFlName) then
  begin
    TrSourcesList:=TStringList.Create;
    TrSourcesList.LoadFromFile(TrSourcesFlName);
  end;

  if FileExists(TrTocFlName) then
  begin
    OriginalTocList:=TStringList.Create;
    OriginalTocList.LoadFromFile(TrTocFlName);
  end;

  if FileExists(ExpKeysFlName) then
  begin
   CopyFile(ExpKeysFlName,AppDir+'\'+'ExpKeys.txt');
  end;

  If SysUtils.DeleteFile(TrSourcesFlName) = false then
      ShowMessage('Cannot delete Source');
  If SysUtils.DeleteFile(TrTocFlName) = False then
        ShowMessage('Cannot delete Toc');
  If FileExists(LocalDir+RemoteFlName) then
   SysUtils.DeleteFile(LocalDir+RemoteFlName);
  If SysUtils.DeleteFile(ExpKeysFlName) = false then
      ShowMessage('Cannot delete Exp');

 Except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;

 // the Web zipped file has empty files
 If OriginalTocList.Count<3 then
 begin
  ShowMessage('The TR Engine is not available. Contact Microsophic Inc');
  OriginalTocList.Free;
  Screen.Cursor:=CrDefault;
  Exit;
 end;

 For i:=0 to OriginalTocList.count-1 do    //OriginalToc has original trtoc.txt
 begin
  If (i=1000) or (i=2000) or (i=3000) or (i=4000) then
   ProgressBar1.Position:=ProgressBar1.Position+10;
  ID := alltrim(LeftStr(OriginalTocList[i],15));
  title := MidStr(OriginalTocList[i],156,250);
  TitleList.add(PaddR(Id,15)+ ' '+title);
  s:=AllTrim(MidStr(OriginalTocList[i],16,140));

  If S>'' then
   if (Pos('ttp:',S) > 0) or (Pos('ttps:',S)> 0) then
     LinkList.Add('h' + s)
   else
     LinkList.Add(GetUrlPrefix(Id,TrSourcesList)+s)
   else
   LinkList.Add(' ');
  end;
 //ProgressBar1.Position:=ProgressBar1.Position+50;
 OriginalTocList.Free;
 //PopulateLookInBox(TrSourcesList); ?? needs titles list
 Screen.Cursor:=CrDefault;
}
end;


(*
procedure TFundsInWeb.LoadTrFromLocalDrive;
Var TrSourcesFlName,TrTocFlName,TempFile:String;i:Integer;s:String;
 OriginalTocList:TStringList;
 title,ID:string;
 TrSourcesList:TStringList;
 url,remoteflname,localdir,localflname:string;
 h:THandle;
 Flags: OLEVariant;
begin
 TitleList.Clear;
 LinkList.Clear;

 Screen.Cursor:=crHourGlass;
 //needed in case of failure
 //TitleList:=TStringList.Create;
 //LinkList:=TStringList.Create;

 TrSourcesFlName := 'C:\Delphi\TrMaintainProject\FinalDir\TrSources.txt';
 TrTocFlName:= 'C:\Delphi\TrMaintainProject\FinalDir\TRTOC.txt';

 if FileExists(TrSourcesFlName) then
 begin
    TrSourcesList:=TStringList.Create;
    TrSourcesList.LoadFromFile(TrSourcesFlName);
 end;

 if FileExists(TrTocFlName) then
 begin
    OriginalTocList:=TStringList.Create;
    OriginalTocList.LoadFromFile(TrTocFlName);
 end;

 For i:=0 to OriginalTocList.count-1 do    //OriginalToc has original trtoc.txt
 begin
  ID := alltrim(LeftStr(OriginalTocList[i],15));
  title := MidStr(OriginalTocList[i],156,250);
  TitleList.add(PaddR(Id,15)+ ' '+title);
  s:=AllTrim(MidStr(OriginalTocList[i],16,140));

  If S>'' then
   if Pos('ttp:',S) > 0 then
    LinkList.Add('h' + MidStr(OriginalTocList[i],16,140))
   else
    LinkList.Add(GetUrlPrefix(Id,TrSourcesList)+MidStr(OriginalTocList[i],16,140))
  else
   LinkList.Add(' ');

 end;
 OriginalTocList.Free;
 Screen.Cursor:=CrDefault;
end;

procedure TFundsInWeb.LoadTreeView;
Var i:Integer;Id:String;//TempList:TStringList;
Begin
 TreeView1.Items.Clear;
 ProgressBar1.Position:= ProgressBar1.Position+10;
 //get only titles , skip Id
 //TempList:=TstringList.Create;
 For i:=0 to TitleList.count-1 do //remove ID and other sources
 begin
  id:=LeftStr(TitleList[i],15);
  TitleList[i]:=MidStr(TitleList[i],17,140);
 end;
 ProgressBar1.Position:= ProgressBar1.Position+5;
 AddOtherTrSources;
 ProgressBar1.Position:= ProgressBar1.Position+5;
 TitleList.SaveToFile(AppDir+'\'+'TempFile');
 ProgressBar1.Position:= ProgressBar1.Position+5;
 TreeView1.LoadFromFile(AppDir+'\'+'TempFile');
 SysUtils.DeleteFile(AppDir+'\'+'TempFile');
 ProgressBar1.Position:=100;
 ProgressPanel.Visible:=False;
end;
*)
procedure TFundsInWebFP_2012.FindAddress;
var
  Flags: OLEVariant;

begin
  Flags := 0;
  UpdateCombo := True;
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;

procedure TFundsInWebFP_2012.StopClick(Sender: TObject);
begin
 if Assigned(WebBrowser1.Document) then WebBrowser1.Stop;
end;

procedure TFundsInWebFP_2012.URLsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    FindAddress;
  end;
end;

procedure TFundsInWebFP_2012.URLsClick(Sender: TObject);
begin
  FindAddress;
end;

(*
procedure THtmlEOL.LinksClick(Sender: TObject);
begin
  {if (Sender as TToolButton).Hint = '' then Exit;}
  URLs.Text := (Sender as TToolButton).Hint;
  FindAddress;
end;
*)
procedure TFundsInWebFP_2012.RefreshClick(Sender: TObject);
begin
  FindAddress;
end;

procedure TFundsInWebFP_2012.BackClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex - 1];
  FindAddress;
end;

procedure TFundsInWebFP_2012.ForwardClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex + 1];
  FindAddress;
end;

procedure TFundsInWebFP_2012.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ssAlt] then
    if (Key = VK_RIGHT) and ForwardBtn.Enabled then
      ForwardBtn.Click
    else if (Key = VK_LEFT) and BackBtn.Enabled then
      BackBtn.Click;
end;

procedure TFundsInWebFP_2012.Toolbar3Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    Coolbar1.Visible := Checked;
  end;
end;

procedure TFundsInWebFP_2012.Statusbar2Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    StatusBar1.Visible := Checked;
  end;
end;

procedure TFundsInWebFP_2012.HomePageRequest(var Message: TMessage);
Var AppDir:String;{with slash}
begin
  AppDir := ExtractFilePath(Application.ExeName); {where the Exe is}
  Urls.Text:= url;
  FindAddress;
end;


procedure TFundsInWebFP_2012.FormDestroy(Sender: TObject);
begin
  HistoryList.Free;
end;

procedure TFundsInWebFP_2012.BackActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    BackAction.Enabled := HistoryIndex > 0
 else
    BackAction.Enabled := False;
end;

procedure TFundsInWebFP_2012.ForwardActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    ForwardAction.Enabled := HistoryIndex < HistoryList.Count - 1
  else
    ForwardAction.Enabled := False;
end;

procedure TFundsInWebFP_2012.WebBrowser1BeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  NewIndex: Integer;
begin
  NewIndex := HistoryList.IndexOf(URL);
  if NewIndex = -1 then
  begin
    //Remove entries in HistoryList between last address and current address
    if (HistoryIndex >= 0) and (HistoryIndex < HistoryList.Count - 1) then
      while HistoryList.Count > HistoryIndex do
        HistoryList.Delete(HistoryIndex);
    HistoryIndex := HistoryList.Add(URL);
  end
  else
    HistoryIndex := NewIndex;
  if UpdateCombo then
  begin
    UpdateCombo := False;
    NewIndex := URLs.Items.IndexOf(URL);
    if NewIndex = -1 then
      URLs.Items.Insert(0, URL)
    else
      URLs.Items.Move(NewIndex, 0);
  end;
  URLs.Text := URL;
  Statusbar1.Panels[0].Text := URL;
end;

procedure TFundsInWebFP_2012.WebBrowser1DownloadBegin(Sender: TObject);
begin
  ShowBrowserProperties;
  { Turn the stop button dark red }
  StopBtn.ImageIndex := 4;
  { Play the avi from the first frame indefinitely }
  //Animate1.Active := True;
end;

procedure TFundsInWebFP_2012.WebBrowser1DownloadComplete(Sender: TObject);
begin
  ShowBrowserProperties;
 // ShowMessage('Download complete');
 // Screen.Cursor:=crDefault;
 (*
  If (SearchBox.Text>'')
  and (Assigned(WebBrowser1.Document)=True)
  and (HighlightOption.Checked = True)
  then
    If (RightStr(UrlLbl.Caption,Length(ITAFlName)) <> ITAFlName) then
      WBHighlight(WebBrowser1,SearchBox.Text);
  { Turn the stop button grey }
  StopBtn.ImageIndex := 2;
  Screen.Cursor:=crDefault;
  { Stop the avi and show the first frame }
  //Animate1.Active := False;
 *)
end;

procedure TFundsInWebFP_2012.ExitProgramClick(Sender: TObject);
begin
(*
 if MessageDlg(
 'For frequent users it is better to Minimize instead of exiting TR'
 +Chr(13)+'Exit?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then close;
 *)
end;

procedure TFundsInWebFP_2012.WebBrowser1DocumentComplete(ASender: TObject;const pDisp: IDispatch; const URL: OleVariant);
begin
  ShowBrowserProperties;
  //Screen.Cursor:=crDefault;
 // ShowMessage('document complete');
   //If FillForm(WebBrowser1, 'AGENTNUM', OnlineNo) = True then FillDataBtnClick(Sender);
end;

function TFundsInWebFP_2012.FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
var
  i, j: Integer;
  FormItem: Variant;
begin
  Result := False;
  //no form on document
  if WebBrowser.OleObject.Document.all.tags('FORM').Length = 0 then exit;

  //count forms on document
  for I := 0 to WebBrowser.OleObject.Document.forms.Length - 1 do
  begin
    FormItem := WebBrowser.OleObject.Document.forms.Item(I);
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

procedure TFundsInWebFP_2012.WebBrowser1TitleChange(Sender: TObject;
  const Text: WideString);
begin
 ShowBrowserProperties;
//If Text = 'Errors detected' then ShowMessage('Errors detected: = '+Text);
//ShowMessage('Title change Text = '+Text);
end;

procedure TFundsInWebFP_2012.Print1Click(Sender: TObject);
var
  //OldCur: TCursor;
  vaIn, vaOut: OleVariant; // Needed in all examples
Begin
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER,vaIn, vaOut);
end;

procedure TFundsInWebFP_2012.WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
 ShowBrowserProperties;
// Screen.Cursor:=crDefault;
// ShowMessage('Navigate complete2');
 //if CurDispatch = nil then CurDispatch := pDisp; { save for comparison }
end;

procedure TFundsInWebFP_2012.ShowBrowserProperties;
begin
 if Assigned(WebBrowser1.Document) then
 begin
 // UrlLbl.Caption := Webbrowser1.OleObject.Document.Url;
 // TitleLbl.Caption := Webbrowser1.OleObject.Document.title;
 end;
end;


procedure TFundsInWebFP_2012.ExitBtnClick(Sender: TObject);
begin
Close;
end;


(*
function THtmlEOL.SaveHTMLCode(WebBrowser: TWebBrowser; const FileName: TFileName): Boolean;
var
  ps: IPersistStreamInit;
  fs: TFileStream;
  sa: IStream;
begin
  ps := WebBrowser.Document as IPersistStreamInit;
  fs := TFileStream.Create(FileName, fmCreate);
  try
    sa := TStreamAdapter.Create(fs, soReference) as IStream;
    Result := Succeeded(ps.Save(sa, True));
  finally
    fs.Free;
  end;
end;
*)


(*
procedure THtmlEOL.Button1Click(Sender: TObject);
begin
  SaveHTMLCode(Webbrowser1, 'c:\test.txt');
end;

procedure THtmlEOL.Button2Click(Sender: TObject);
begin
  GetHTMLCode(Webbrowser1, Memo1.Lines);
end;
*)


(*
Function THtmlEOL.ReadHtmlSource:Boolean;
Var
  wb := pDisp as IWebBrowser2;
  doc := wb.Document as IHTMLDocument2;
  body2 := doc.body as IHTMLElement2;
  elements := doc.all;

begin
  for i := 0 to elements.length-1 do
  begin
    element := elements.item(i, 0) as IHTMLElement;
    {
    if element.tagName='IMG' then
      begin
       imgElement := element as IHTMLImgElement;
       controlRange := body2.createControlRange as IHTMLControlRange;
       controlElement := imgElement as IHTMLControlElement;
       controlRange.add(controlElement);
       controlRange.execCommand('Copy', False, EmptyParam);
      end;
    }
  end;
end;
*)

Function TFundsInWebFP_2012.GetConfirmationNoFromHtml:String;
Var i,k:Integer; TempList:TStringList;s:String;
begin
EXIT;
 Result:='';
 TempList:=TStringList.Create;
 GetHtmlCode(WebBrowser1,TempList);

 TempList.SaveToFile(AppDir+'\'+'Temp');
 TempList.Clear;
 TempList.LoadFromFile(AppDir+'\'+'Temp');
 For i:=0 to TempList.Count-1 do
 begin
   k:=FindWord('confirm_num',TempList[i]);
   if k>0 then
   begin
    result:=MidStr(TempList[i],k+13,7)+' - '+MidStr(TempList[i],k+41,13);
    TempList.Free;
    Exit;
   end;
 end;
 TempList.Free;
 { ShowMessage('Confirmation no cannot be retrieved'+
   Chr(13)+'Please mark it down and enter it on the T183 form');}
end;


function TFundsInWebFP_2012.GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
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
    Try
     if Result then TempList.Add(ss.Datastring);
    except
    end;
  finally
    ss.Free;
  end;
end;


(*
procedure TTrEngine.ConnectBtnClick(Sender: TObject);
begin
 PostMessage(Handle, CM_HOMEPAGEREQUEST, 0, 0);

 ShowBrowserProperties;
 if Assigned(WebBrowser1.Document) then
 begin
  UrlLbl.Caption := Webbrowser1.OleObject.Document.Url;
  TitleLbl.Caption := Webbrowser1.OleObject.Document.title;
 end;
end;
*)

Function TFundsInWebFP_2012.IsKeyWInDocument(WB: TWebBrowser; sText: string):Boolean;
var
   prefix,suffix: string;
   tr: IHTMLTxtRange;
begin
   Result:=False;

   tr := ((wb.Document AS IHTMLDocument2).body AS IHTMLBodyElement).createTextRange;
   if Assigned(WB.Document) then
   begin
     if tr.findText(sText, 1, 0) then result:=True;
   end;
end;

procedure TFundsInWebFP_2012.SaveHTMLSource(WB:TWebBrowser; const FileName : string);
var
  i:Integer;
  PersistStream: IPersistStreamInit;
  Stream: IStream;
  FileStream: TFileStream;
begin
   if not Assigned(WB.Document) then
   begin
    delay (10000);
   end;

   if not Assigned(WB.Document) then
   begin
      ShowMessage('Document not loaded!');
   end;

  PersistStream := WB.Document as IPersistStreamInit;
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    Stream := TStreamAdapter.Create(FileStream, soReference)
              as IStream;
    if Failed(PersistStream.Save(Stream, True)) then
      ShowMessage('Save HTML Source fail!');
  finally
    FileStream.Free;
end;
end;

(*
procedure TFundsInWeb.TreeView1DblClick(Sender: TObject);
Var i:integer;SourceNode : TTreeNode; Ndx :Integer;Rec:String;
Flags: OLEVariant; Url:String;
begin
 If Treeview1.Items.count=0 then exit;
 //SearchBox.Text:='';
 Flags:= 0;
 SourceNode:= Treeview1.Selected;
 Ndx :=SourceNode.AbsoluteIndex;
 If Ndx>-1 then //i>-1 then
 begin
  Url:=AllTrim(LinkList[Ndx]);
  if Url > '' then
  begin
   Screen.Cursor:=crHourGlass;
   WebBrowser1.Navigate(WideString(url),Flags, Flags, Flags, Flags);
  end;
 end;
end;
*)

(*
Function TFundsInWeb.GetUrlPrefix(Id:String;TrSourcesList:TStringList):String;
Var i:Integer;
begin
 Result:='';
 For i:=0 to TrSourcesList.count-1 do
 begin
  If UpperCase(Id) = UpperCase(AllTrim(LeftStr(TrSourcesList[i],16))) then
   begin Result:=MidStr(TrSourcesList[i],169,250);Exit;end;
 end;
end;
*)
(*
Function TFundsInWeb.GetTrSourceDescription(Id:String;TrSourcesList:TStringList):String;
Var i:Integer;
begin
 Result:='';
 For i:=0 to TrSourcesList.count-1 do
 begin
  If UpperCase(Id) = UpperCase(AllTrim(LeftStr(TrSourcesList[i],16))) then
   begin Result:=MidStr(TrSourcesList[i],17,30);Exit;end;
 end;
end;

procedure TFundsInWeb.ExpandBtnClick(Sender: TObject);
begin
 TreeView1.FullExpand;
 TreeView1.TopItem:=TreeView1.Items[0];
end;

procedure TFundsInWeb.CollapseClick(Sender: TObject);
begin
TreeView1.FullCollapse;
end;
*)

Function TFundsInWebFP_2012.DownLoadFromWeb(url,remoteFlName,localDir,localFlName:string): boolean;
const BufferSize = 1024;
//const fileURL = string;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: File;
  sAppName: string;
  fileURL, FileName: String;
begin
 //ProgressBar1.Position:=0;
 //ProgressBar1.Max:=100;  //120k
 fileURL := url + remoteFlName;
 FileName := localDir + localFlName;
 Result:=False;
 sAppName := ExtractFileName(Application.ExeName);

 hSession := InternetOpen(PChar(''+sAppName),INTERNET_OPEN_TYPE_PRECONFIG,nil, nil, 0);
 //If hSession=Nil then exit; //does not work
 try
  result:=false;
  hURL := InternetOpenURL(hSession,PChar(''+fileURL),nil,0,0,0);
  //If hUrl=Nil then exit;  //does not work
  try
   AssignFile(f, FileName);
   Rewrite(f,1);
   repeat
    InternetReadFile(hURL, @Buffer,SizeOf(Buffer), BufferLen);
    Screen.Cursor:=crHourGlass;
    BlockWrite(f, Buffer, BufferLen);
    //ProgressBar1.Position:=ProgressBar1.Position+1000;
   until BufferLen = 0;
   CloseFile(f);
   Result:=True;
  finally
   InternetCloseHandle(hURL)
  end
 finally
  InternetCloseHandle(hSession)
 end;
 Screen.Cursor:=crDefault;
 //ProgressBar1.Position:=30;
end;






Function  TFundsInWebFP_2012.IsConnectedToInternet: Boolean;
var
  dwConnectionTypes: Integer;
begin
  try
    dwConnectionTypes := INTERNET_CONNECTION_MODEM +
                         INTERNET_CONNECTION_LAN +
                         INTERNET_CONNECTION_PROXY;
    if InternetGetConnectedState(@dwConnectionTypes, 0) then
      Result := true
    else
      Result := false;
  except
    Result := false;
  end;
end;



procedure TFundsInWebFP_2012.ShowFundsGuide;
Var Flags: OLEVariant;
begin
 Flags:=0;
 Url:='http://www.visualtax.com/FundsGuide.htm';
 WebBrowser1.Navigate(WideString(Url), Flags, Flags, Flags, Flags);
end;

procedure TFundsInWebFP_2012.SetUp1Click(Sender: TObject);
Var h:THandle;
begin
  ShowMessage('You can add your favorite sites for tax research in the upcoming window');
  h :=ShellExecute(self.Handle, Nil, 'WebSites.exe', Nil,
  Nil, SW_RESTORE);
  if h <=32 then
   ShowMessage('Cannot execute. Error '+IntToStr(h));

  ShowMessage('Click here to refresh');
 // Delay(1000);
  TitleList.Clear;
  LinkList.Clear;
  //ProgressPanel.Visible:=True;
  LoadTrFromWeb; //original again

  //ProgressPanel.Visible:=False;
end;


procedure TFundsInWebFP_2012.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 //TitleList.Free;
 //LinkList.Free;
end;

(*
procedure TFundsInWeb.TrGuide1Click(Sender: TObject);
begin
 ShowTrGuide;
end;


procedure TFundsInWeb.NotePad1Click(Sender: TObject);
Var h : Thandle;
begin
 h := ShellExecute(Self.Handle, Nil, 'NotePad.Exe', Nil,  '', SW_RESTORE);
end;


procedure TFundsInWeb.Download2Click(Sender: TObject);
begin
 DownLoadITA;
 ShowITA;
end;

procedure TFundsInWeb.ShowITA;
Var Flags: OLEVariant;
FlName:String;
begin
 FlName:=AppDir+'\'+ITAFlName; //'IncomeTaxAct.htm';
 If Not FileExists(FlName) then
 begin
  ShowMessage('Please Download the current Income Tax Act. See Menu | File');
  Exit;
 end;
 Flags:=0;
 Url:=FlName;
 WebBrowser1.Navigate(WideString(Url), Flags, Flags, Flags, Flags);
end;

procedure TFundsInWeb.ShowITAFromLocalDrive;
Var Flags: OLEVariant;
FlName:String;
begin
 FlName:='c:\delphi\TrMaintainProject\FinalDir\'+ItaFlName;
 If Not FileExists(FlName) then
 begin
  ShowMessage('Please Download the Income Tax Act. See Menu | File');
  Exit;
 end;
 Flags:=0;
 Url:=FlName;
 WebBrowser1.Navigate(WideString(Url), Flags, Flags, Flags, Flags);
end;


procedure TFundsInWeb.DownloadITA;
Var i:Integer;
 Url,RemoteFlName, LocalDir, LocalFlName:String;
 H:Thandle;
Begin
 Screen.Cursor:=crHourGlass;
 RemoteFlName := ChangeFileExt(ITAFlName,'.EXE'); //F'IncomeTaxAct.EXE';
 LocalFlName := 'IncomeTaxAct.EXE';
 LocalDir:='C:\';
 Url:= 'http://www.visualtax.com/downloads/';
 if DownLoadFromWeb(url,remoteflname,localdir,localflname)=True then
 begin
  //open the self extracting zip file VtTrUpd.exe
  h := ShellExecute(Self.Handle,'open',PChar(localdir+localflname),Nil,Nil,SW_HIDE); //Sw_Show
  If H<=32 then
  begin
  showMessage('Downloading failed...');
  Exit;
  end;
 end
 else
 begin
  ShowMessage('Error in file download');
  exit;
 end;

 //ShowMessage('Delaying ue of files');
 For i:=1 to 20 do
 begin
  while (not FileExists(LocalDir+ITAFlName)) do Delay(800);
 end;

 If FileExists(LocalDir+ITAFlName) then
 begin
  CopyFile(LocalDir+ITAFlName,AppDir+'\'+ITAFlName);//'IncomeTaxAct.htm');
  SysUtils.DeleteFile(LocalDir+ITAFlName);
 end;
 Screen.Cursor:=crDefault;
End;
*)
(*
procedure TFundsInWeb.GoogleSearchBtnClick(Sender: TObject);
begin
 If SearchBox.Text='' then
 begin
  ShowTimedMsg('Please enter keyword in the Search box',1600);
  Exit;
 end;
GoogleSearch(SearchBox.Text);
end;

procedure TFundsInWeb.GoogleSearch(AString:String);
var
searchString,url:string;
site1,site2,site3,site4,site5,site6:string;
Flags: OLEVariant;
begin
 searchString := AString;
 site1 := 'www.cra-arc.gc.ca/';
 site2 := 'www.cra-arc.gc.ca/'; //laws.justice.gc.ca/';
 site3 := 'www.cra-arc.gc.ca/'; //canada.gc.ca/';
 site4 := 'www.cra-arc.gc.ca/'; //www.fin.gc.ca/';
 site5 := 'www.cra-arc.gc.ca/'; //www.bdo.ca/';
 site6 := 'www.cra-arc.gc.ca/'; //www.bankofcanada.ca/';
 url := 'http://www.google.com/search?num=100&hl=en&lr=&ie=UTF-8&c2coff=1&q=' + searchString + '+site%3A' + site1 + '+OR+site%3A+' + site2 + '&btnG=Search';
 WebBrowser1.Navigate(WideString(url),Flags, Flags, Flags, Flags);
end;
 *)

 procedure TFundsInWebFP_2012.WB_ShowFindDialog(AWebbrowser: TWebbrowser);
const
 CGID_WebBrowser: TGUID = '{ED016940-BD5B-11cf-BA4E-00C04FD70816}';
 HTMLID_FIND = 1;
 HTMLID_VIEWSOURCE = 2;
 HTMLID_OPTIONS = 3;
var
 CmdTarget : IOleCommandTarget;
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

procedure TFundsInWebFP_2012.WB_SaveAs_HTML(WB:TWebBrowser; const FileName : string);
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
    Stream := TStreamAdapter.Create(FileStream, soReference)
              as IStream;
    if Failed(PersistStream.Save(Stream, True)) then
      ShowMessage('SaveAs HTML failed!');
  finally
    FileStream.Free;
  end;
end; (* WB_SaveAs_HTML *)

procedure TFundsInWebFP_2012.SaveDocument1Click(Sender: TObject);
begin
 (*
 If Not DirectoryExists(AppDir+'\'+'TR-Projects') then MkDir(AppDir+'\'+'TR-Projects');
 SaveDialog1.InitialDir:=AppDir+'\'+'Tr-Projects';
 If UpperCase(RightStr(AllTrim(UrlLbl.Caption),3))='PDF' then
 begin
  ShowMessage('This is a PDF file: To save use the Save a copy button of the PDF menu');
  Exit;
 end;
 //html file by default
 SaveDialog1.FileName:=ExtractFileNameFromUrl(UrlLbl.Caption);
 If SaveDialog1.Execute then
 begin
  WB_SaveAs_HTML(WebBrowser1,SaveDialog1.FileName);
  ShowTimedMsg('Saved in '+SaveDialog1.FileName,1600);
 End;
 *)
end;

procedure TFundsInWebFP_2012.LinkToAWebSite1Click(Sender: TObject);
Var aUrl:String; Flags:OleVariant;
begin
 Flags:=0;
 aUrl:= InputBox('Enter a Web site URL address', 'In format:   http://www.xxxxx.yyy', 'http://www.cra-arc.gc.ca');
 If aUrl>'' then
   WebBrowser1.Navigate(WideString(aUrl), Flags, Flags, Flags, Flags);
end;

procedure TFundsInWebFP_2012.Exit1Click(Sender: TObject);
begin
 ExitProgramClick(Sender);
end;


procedure TFundsInWebFP_2012.CBListener1ClipboardChanged(Sender: TObject);
begin
 DoClipBoardChanged;
end;


Procedure TFundsInWebFP_2012.DoClipBoardChanged;
Var i,FNo:Integer;
    AMemo:TMemo;
    ClipboardText:AnsiString;
    WList:TStringList;
    TempList:TStringList;
    h : THandle;
    ActionVerb:String;
    ActionParm:String;
    SearchValue:String;
    ClipbdDelim:String;
begin

   //ShowTimedMsg('Checking messages',2500);
   Try
    If (Titlelist=Nil) or (LinkList=Nil) then
    //Clipboard.Clear;
   //If (Titlelist.count=0) or (LinkList.count=0) then
     Exit;
   Except
    Exit;
   end;

   If Clipboard.AsText = '' then exit;
   ClipBdDelim:='|';
   if Clipboard.HasFormat(CF_TEXT) then
   begin
     ClipBoardText:=Clipboard.AsText;
     If (LeftStr(ClipBoardText,8)='From T1'+ClipBdDelim)
     or (LeftStr(ClipBoardText,8)='From T2'+ClipBdDelim) then
     begin
      WList:=TstringList.Create;
      ParseWords(ClipBoardText+ClipBdDelim,ClipBdDelim,WList);
      ActionVerb:=Wlist[1];
      SearchValue:=Wlist[2];

      If (ActionVerb='Search') then
      begin
       //If UpperCase(LeftStr(SearchValue,5))='LINE ' then  SearchOptionBox.ItemIndex:=2;
       WList.Free;
       Clipboard.Clear;
       Application.BringToFront;
       Application.Restore;
      end;
     end;  //has legitimate text
   end;  //has text
end;

Procedure TFundsInWebFP_2012.OpenQuery1;
Var WhereClause:String;FavoriteValue:string; //[1];
begin
 Screen.Cursor:=CrHourGlass;
 If FundCodeBox.text >'' then FavoriteBox.Checked:=False;
 If FavoriteBox.Checked then FavoriteValue:='Y' else FavoriteValue:='*';
 If FavoriteBox.Checked then FundCodeBox.Text:='';

 WhereClause :='';

 If FavoriteValue='Y' then
   WhereClause := ' Where '
   +'(' + 'Favorite LIKE ' + '"' +  FavoriteValue + '"' +')'
 else
 begin
  If FundCodeBox.text >'' then
  begin
  If RightStr(FundCodeBox.text,1) <> '*' then FundCodeBox.text:=FundCodeBox.text+'*';
  WhereClause := ' Where '
  +'('
  + 'Trim(FundCode) LIKE ' + '"' +  FundCodeBox.Text + '"'
  +')';
  end;
 end;

// Query1.ConnectionString:=FundBaseConnectionString;
 With query1 do
 begin
  If Active then Close;
  SQL.Clear;
  Try
   SQL.Add('Select * from '+FundsTableLite); // 20150922 Igor
   SQL.Add( WhereClause);
   SQL.Add( 'ORDER BY FundCode');
   //Prepare;
   open;
  except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
 end;
 Screen.Cursor:=CrDefault;
end;



procedure TFundsInWebFP_2012.DBGrid1DblClick(Sender: TObject);
Var FundCode,FundId,WebPageId:String;Exchange:String;
    TempString : array[0..79] of char; h:THandle;
    Url:String; FndName:String;
    ZString : Array[0..150] of Char;
    Ptr : Pchar;
    FLAGS:OLEVariant;

begin
 Screen.Cursor:=CrHourGlass;
  (*
  If (IsAgentVersion = false) and (IsDealerVersion = false)
  and (IsAgentDemo = False)
  then
   begin
   ShowMessage('Available only in the Investment Agent/dealer version of the program');
   exit;
  end;
 *)
 (*
 SomeList := TStringList.Create;
 SomeList.Sorted := False;
 SomeCaption := 'Fund Analysis from Internet';
 SomeList.Add('Profile');
 SomeList.Add('Performance');
 SomeList.Add('Holdings');
 SomeList.Add('3m chart');
 SomeList.Add('6m chart');
 SomeList.Add('1y chart');
 SomeList.Add('2y chart');
 SomeList.Add('3y chart');
 SomeList.Add('5y chart');
 SomeList.Add('my chart (max years)');

 // SomeList.Add('-------------------');
 // SomeList.Add('Get Current Price');

 ExecuteForm(TPopList);
 SomeList.Free;

 If SelectedString = '' then exit;
 *)


 FundCode:= Query1.FieldByName('FundCode').AsString;
 Url:='http://finance.yahoo.com/lookup?s='+LeftStr(Fundcode,3);

 {
 Url:='http://globefunddb.theglobeandmail.com/gishome/plsql/gis.process_fr?fr_param1='+FundCode+'&fr_mode='
   +LeftStr(FUNDCode,3)+'&fr_mode='+FundCode+'&iaction=Go';
 }
// Url:='http:\\sympaticodb.globeinvestor.com/invest/investSQL/syma.fundquote?pi_symbol='+FundCode+'&iaction=Go';

 Flags:=0;
 //Url:='http://www.visualtax.com/TrGuide-2005.htm';
 WebBrowser1.Navigate(WideString(Url), Flags, Flags, Flags, Flags);

 {
 Ptr := StrPCopy(ZString,Url);
 If Url>'' then h := ShellExecute(0,'open',Ptr,Nil,Nil,Sw_Show);
 If H<=32 then ShowMessage('Connection failed');
 }
 Screen.Cursor:=CrDefault;
 EXIT;

 //remaining from Yahoo is not used
 If LeftStr(SelectedString,3) = 'Get' then
 begin
  FndName:=ReplaceChar(
           UpperCase(AllTrim(Query1.FieldByName('Supplier').AsString)) + ' '
          +Query1.FieldByName('FundTypeDescr').AsString,' ','+');
  //Url:='http://sympaticodb.globeinvestor.com/invest/investSQL/symp.fund_pro?fundname='+FndName;
  // STOCK QUOUT HARD to DECYPHER: Url:=http://sympaticodb.globeinvestor.com/invest/investSQL/syma.fundquote?pi_symbol=AGF934&iaction=Go
  //Url:='http://sympaticodb.globeinvestor.com/invest/investSQL/symp.fund_pro?fundname=AGF+Canadian+Balanced';
 { CaptureFileName:= CaptureWebDir+'\'
       +Query1.FieldByName('FundCode').AsString+'_'+ 'BriefProfile'+'.Htm';}
  //GetTheHtmlDoc(Url,CaptureFileName);
//  ShowMessage('Price ='+GetValueFromInternet(Url,'Current Price:'));
  Exit;
 end;

 WebPageId:=SelectedString;
 Exchange:='TO';
 FundId:= Query1.FieldByName('FundId').AsString;
// AnalyseAFundFromYahoo(WebPageId,FundId,Exchange);

end;



procedure TFundsInWebFP_2012.AnalyseBtnClick(Sender: TObject);
begin
 DBGrid1DblClick(Sender);
end;

initialization
 OleInitialize(nil);  //allows copy/paste in twebbrowser
 finalization
  OleUninitialize;
end.
