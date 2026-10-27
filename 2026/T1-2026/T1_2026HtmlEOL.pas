unit T1_2026HtmlEOL;
//imported 07-26
interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Menus,ComCtrls,OleCtrls,Buttons,ToolWin,ActnList,ImgList,shdocvw,
  Printers,Db,ActiveX,FileCtrl, System.Actions;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  THtmlEOLT1_2026 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    View1: TMenuItem;
    NavigatorImages: TImageList;
    NavigatorHotImages: TImageList;
    LinksImages: TImageList;
    LinksHotImages: TImageList;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    BackBtn: TToolButton;
    ForwardBtn: TToolButton;
    StopBtn: TToolButton;
    RefreshBtn: TToolButton;
    ToolBar2: TToolBar;
    URLs: TComboBox;
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
    WebBrowser1: TWebBrowser;
    ExitProgram: TMenuItem;
    Print1: TMenuItem;
    EFReadyReturns1: TMenuItem;
    DisplayFile1: TMenuItem;
    BuildFile1: TMenuItem;
    FillLoginData1: TMenuItem;
    UpdateDataBase1: TMenuItem;
    SetUp1: TMenuItem;
    HeaderPanel: TPanel;
    urlLbl: TLabel;
    TitleLbl: TLabel;
    LabelEfileType: TLabel;
    Label3: TLabel;
    TransmitBtn: TBitBtn;
    FileNameBox: TEdit;
    URLBox: TEdit;
    ExitBtn: TBitBtn;
    Panel2: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    DoingLbl: TLabel;
    FileListBox1: TFileListBox;
    DataDirBox: TEdit;
    DoAllBtn: TBitBtn;
    CreateBtn: TBitBtn;
    LoadallfilesBox: TCheckBox;
    ProdOrTestBox: TRadioGroup;
    ShowContentsBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    BitBtn1: TBitBtn;

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
    procedure BackActionUpdate(Sender: TObject);
    procedure ForwardActionUpdate(Sender: TObject);
    procedure WebBrowser1DownloadBegin(Sender: TObject);
    procedure WebBrowser1DownloadComplete(Sender: TObject);
    procedure ExitProgramClick(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant); // 20150821 igor
    procedure WebBrowser1TitleChange(Sender: TObject;const Text: WideString);
    function FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
    procedure Print1Click(Sender: TObject);
    procedure WebBrowser1NavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant); // 20150821 igor
    procedure EFReadyReturns1Click(Sender: TObject);
    procedure ShowReturns(DBName:String;QryName:String);
    Function  MakeSelectedStr: String;
    procedure FillDataBtnClick(Sender: TObject);
    procedure ShowBrowserProperties;
 //   Function MkFileName(RetNo:Integer):String;
    Function GetProductionOrTest:String;
    procedure TransmitBtnClick(Sender: TObject);
   // procedure DisplayFile1Click(Sender: TObject);
    procedure BuildFile1Click(Sender: TObject);
    procedure FillLoginData1Click(Sender: TObject);
    procedure SetUp1Click(Sender: TObject);
    procedure GetParms;
    procedure ExitBtnClick(Sender: TObject);
    procedure UpdateDataBase1Click(Sender: TObject);
    Function LoadReturn(DataDir:String;FlName:string):integer;
    Function UpdateAckStatus(SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo:String):boolean;
    Function BackUpTaxFile(NetFileDir,FileName:String):Boolean;
    procedure DoAllBtnClick(Sender: TObject);
    procedure DoAll;
    Function GetConfirmationNoFromHtml:String;
    function  GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
    procedure ShowContentsBtnClick(Sender: TObject);
    procedure SaveDialog1Close(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool); // 20150821 igor

   private
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;
    procedure FindAddress;
    procedure HomePageRequest(var message: tmessage); message CM_HOMEPAGEREQUEST;
   private
      CurDispatch: IDispatch; {save the interface globally }
      RetNo:Integer;
      OnLineNo,PassWord,FileName,Url,Refund:String;
      //OnLineMethod:String; //global via u declare  //to be used bu the uhtmlEfOnline
      DcnSeqNo:String;
      F1:TextFile;
      SfdNo : Integer;
      EFlines  : TStringList;
      //ProdOrTest:String[1];   //global as of 20111204 in Udeclare
      CrLf  :String;
      SegmentCnt:Integer;
      NetFileDir:String;
      IsBrowsePage:Boolean;

      CurrentRtn:String;
  end;

var
  HtmlEOL: THtmlEOLT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
     T1_2026Common2,T1_2026T1rtns,T1_2026Calc,T1_2026T1Rtns2,ShellApi,
     T1_2026ChildWinNew,T1_2026EolSetup,T1_2026EfileRtns,vtTrimStr,vtShared
   , vtDataBase, uADCompClient; // 20150821 igor;

procedure THtmlEOLT1_2026.GetParms;
begin
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 UrlBox.Text:=Url;

 If UrlBox.Text='' then
 begin
  UrlBox.text:='http://www.efile.cra.gc.ca/-rdy-eng.html';  //production 2009
  If IsHomeUse then UrlBox.text:='http://www.efile.cra.gc.ca/-rdy-eng.html';  //production 2009
  //actual selection is entered in setupeol
 //production 2008:  UrlBox.text:='http://www.efile.cra.gc.ca/eol-ready-e.html';
 end;

 Urls.Text:=UrlBox.Text;
 DataDirBox.Text := OptRec.Dir_Cur;

end;

procedure THtmlEOLT1_2026.FormCreate(Sender: TObject);
var   Flags: OLEVariant;
h:word; InitialDir:String;
begin

 System.Set8087CW($133f); //Disable all fpu exceptions  //supress the Floating point //20130207

// XmlList:=TStringList.Create;  //20111212
 IsBrowsePage:=False;
 If IsHomeUse then
   LabelEfileType.caption:='VisualTax Netfile'
 else
   LabelEfileType.Caption:='VisualTax Efile On-Line (EOL)';
 RetNo:=GetCurrentRetNo;
 OnLineMethod:='EOL';
 GetParms;

 If LoadAllFilesBox.Checked then
 begin
  DataDirBox.Text := OptRec.Dir_Cur;
  FileListBox1.Directory := DataDirBox.Text;
  FileListBox1.Mask := '*.*';
  FileListBox1.ItemIndex :=0;
 end;
 DcnSeqNo:=MidStr(FetchElm(RetNo,'T183',21),6,8);  //FetchElm(RetNo,'T183',21);  //20111208
 FileName :=MkXmlFileName(RetNo,NetFileDir);
 FileNameBox.Text :=FileName;
 ProdOrTestBox.ItemIndex :=1; //20111204

 HistoryIndex := -1;
 HistoryList := TStringList.Create;


 BuildFile1Click(Sender);
 Screen.Cursor:=CrDefault;

 (*
 InitialDir:= ExtractFileDir(FileNameBox.Text);
 h:=ShellExecute(Handle,'open', Pchar(''+InitialDir), nil, nil, SW_SHOWNORMAL) ;
 TransmitBtnClick(Self);
 *)


 //20110218
 If FileExists(FileNameBox.Text) then
 begin
    OpenDialog1.InitialDir:= ExtractFileDir(FileNameBox.Text);
    OpenDialog1.Title:= 'Click any of the buttons';
    OpenDialog1.FileName:=ExtractFileName(FileNameBox.Text);
    OpenDialog1.Execute;
    TRY
     TransmitBtnClick(Self);
    EXCEPT
     on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
    end;
 end;
 //20180502 Igor >>>
  if not Assigned(XmlList) then
    XmlList := TStringList.Create;
  XmlList.Clear; // 20111212
  //20180502 Igor <<<
end;


procedure THtmlEOLT1_2026.FindAddress;
var
  Flags: OLEVariant;
begin
  Flags := 0;
  UpdateCombo := True;
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;

procedure THtmlEOLT1_2026.StopClick(Sender: TObject);
begin
 if Assigned(WebBrowser1.Document) then WebBrowser1.Stop;
end;

procedure THtmlEOLT1_2026.URLsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    FindAddress;
  end;
end;

procedure THtmlEOLT1_2026.URLsClick(Sender: TObject);
begin
  FindAddress;
end;

procedure THtmlEOLT1_2026.RefreshClick(Sender: TObject);
begin
  FindAddress;
end;

procedure THtmlEOLT1_2026.BackClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex - 1];
  FindAddress;
end;

procedure THtmlEOLT1_2026.ForwardClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex + 1];
  FindAddress;
end;

procedure THtmlEOLT1_2026.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ssAlt] then
    if (Key = VK_RIGHT) and ForwardBtn.Enabled then
      ForwardBtn.Click
    else if (Key = VK_LEFT) and BackBtn.Enabled then
      BackBtn.Click;
end;

procedure THtmlEOLT1_2026.Toolbar3Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    Coolbar1.Visible := Checked;
  end;
end;

procedure THtmlEOLT1_2026.Statusbar2Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    StatusBar1.Visible := Checked;
  end;
end;

procedure THtmlEOLT1_2026.HomePageRequest(var Message: TMessage);
Var AppDir:String;{with slash}
begin
  AppDir := ExtractFilePath(Application.ExeName); {where the Exe is}
  Urls.Text:= url;
  FindAddress;
end;


procedure THtmlEOLT1_2026.FormDestroy(Sender: TObject);
begin
  HistoryList.Free;
end;

procedure THtmlEOLT1_2026.BackActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    BackAction.Enabled := HistoryIndex > 0
 else
    BackAction.Enabled := False;
end;

procedure THtmlEOLT1_2026.ForwardActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    ForwardAction.Enabled := HistoryIndex < HistoryList.Count - 1
  else
    ForwardAction.Enabled := False;
end;

procedure THtmlEOLT1_2026.WebBrowser1BeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  NewIndex: Integer;
begin
  NewIndex := HistoryList.IndexOf(URL);
  if NewIndex = -1 then
  begin
    { Remove entries in HistoryList between last address and current address }
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

procedure THtmlEOLT1_2026.WebBrowser1DownloadBegin(Sender: TObject);
begin
  ShowBrowserProperties;
  { Turn the stop button dark red }
  StopBtn.ImageIndex := 4;
  { Play the avi from the first frame indefinitely }
  //Animate1.Active := True;
end;

procedure THtmlEOLT1_2026.WebBrowser1DownloadComplete(Sender: TObject);
begin
  ShowBrowserProperties;
  { Turn the stop button grey }
  StopBtn.ImageIndex := 2;
  { Stop the avi and show the first frame }
  //Animate1.Active := False;

 // https://www.pro.netfile.ccra-adrc.gc.ca/servlet/NetfileAgentAccessServlet?language=english&action=login
 // ShowMessage('Download complete');
end;

procedure THtmlEOLT1_2026.ExitProgramClick(Sender: TObject);
begin
 If FileExists(FileNameBox.Text) then SysUtils.DeleteFile(FileNameBox.text);
 ExitBtnClick(Sender);
 Close;
end;

procedure THtmlEOLT1_2026.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  ShowBrowserProperties;
 // ShowMessage(Webbrowser1.OleObject.Document.title(Webbrowser1.OleObject.Document.title)); //20130130   does not work
  //20111208
  If FillForm(WebBrowser1, 'EFILER', OnlineNo) = True then  FillDataBtnClick(ASender);
  If Webbrowser1.OleObject.Document.title = 'Return Accepted - EFILE' then UpdateDataBase1Click(ASender);  //20130130
  If FillForm(WebBrowser1, 'SIN', OnlineNo) = True then  FillDataBtnClick(ASender);
  If FillForm(WebBrowser1, 'DOBYEAR', OnlineNo) = True then  FillDataBtnClick(ASender);
  If FillForm(WebBrowser1, 'DOBMONTH', OnlineNo) = True then  FillDataBtnClick(ASender);
  If FillForm(WebBrowser1, 'DOBMONTH', OnlineNo) = True then  FillDataBtnClick(ASender);

  (*
  If FillForm(WebBrowser1, 'AGENTNUM', OnlineNo) = True then  FillDataBtnClick(Sender);
  If Webbrowser1.OleObject.Document.title = 'Return Accepted' then UpdateDataBase1Click(Sender);
  If FillForm(WebBrowser1, 'SIN', OnlineNo) = True then  FillDataBtnClick(Sender);
  If FillForm(WebBrowser1, 'DOBYEAR', OnlineNo) = True then  FillDataBtnClick(Sender);
  If FillForm(WebBrowser1, 'DOBMONTH', OnlineNo) = True then  FillDataBtnClick(Sender);
  If FillForm(WebBrowser1, 'DOBMONTH', OnlineNo) = True then  FillDataBtnClick(Sender);
  *)
  //If IsBrowsePage then  maximize
end;

function THtmlEOLT1_2026.FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
var
  i, j: Integer; h:THandle;
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
        if FormItem.Item(j).Name = FieldName then
        begin
          FormItem.Item(j).Value := Value;
          If FieldName='EFILER' Then IsBrowsePage:=True;//If FieldName='AGENTPASS' Then IsBrowsePage:=True;
          Result := True;
        end;
      except
        Exit;
      end;
    end;
   // h:=ShellExecute(self.Handle,'open', Pchar(''+ExtractFileDir(FileName)), nil, nil, SW_NORMAL) ;  //20110216 does not work
   //use 'explore'' instead of 'open'?

  end;
end;

procedure THtmlEOLT1_2026.WebBrowser1TitleChange(Sender: TObject;
  const Text: WideString);
begin
 ShowBrowserProperties;
//If Text = 'Errors detected' then ShowMessage('Errors detected: = '+Text);
//ShowMessage('Title change Text = '+Text);
end;

procedure THtmlEOLT1_2026.Print1Click(Sender: TObject);
var
  //OldCur: TCursor;
  vaIn, vaOut: OleVariant; // Needed in all examples

Begin
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER,vaIn, vaOut);
end;

procedure THtmlEOLT1_2026.WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
 ShowBrowserProperties;
 //if CurDispatch = nil then CurDispatch := pDisp; { save for comparison }
end;

procedure THtmlEOLT1_2026.EFReadyReturns1Click(Sender: TObject);
begin
 //ShowReturns(CfgRec.Dir_Cur,'EFReady.Qry');
end;

procedure THtmlEOLT1_2026.ShowReturns(DBName:String;QryName:String);
Var Rslt:Integer;RetFile:String;
Begin
end;

Function THtmlEOLT1_2026.MakeSelectedStr: String;
Const
 PartNameLen = 14;
Var
 S : string[80];
begin
end;

procedure THtmlEOLT1_2026.FillDataBtnClick(Sender: TObject);
begin

 //ShowMessage('filename='+FileName);
 FillForm(WebBrowser1, 'uploaded_file', FileNameBox.Text);  //20111208
// FillForm(WebBrowser1, 'uploaded_file', FileName);
 //20111208
 FillForm(WebBrowser1, 'EFILER', OnlineNo);
 FillForm(WebBrowser1, 'PASSWORD', Password);
 {
 FillForm(WebBrowser1, 'AGENTNUM', OnlineNo);
 FillForm(WebBrowser1, 'AGENTPASS', Password);
 }
 FillForm(WebBrowser1, 'PMTIND', 'Checked');

 //net file  //20100208
 FillForm(WebBrowser1, 'SIN', GetSinNo(RetNo));
 FillForm(WebBrowser1, 'DOBYEAR', LeftStr(FetchElm(RetNo,'INFO',9),4));
 FillForm(WebBrowser1, 'DOBMONTH', MIDSTR(FetchElm(RetNo,'INFO',9),6,2));
 FillForm(WebBrowser1, 'DOBDAY',RIGHTSTR(FetchElm(RetNo,'INFO',9),2));
// FillForm(WebBrowser1, 'uploaded_file', FileName); //20110216  did not work
end;

procedure THtmlEOLT1_2026.ShowBrowserProperties;
begin
 if Assigned(WebBrowser1.Document) then
 begin
  // abends: WebBrowser1.OleObject.Document.Body.Style.Zoom := 0.50;
  UrlLbl.Caption := Webbrowser1.OleObject.Document.Url;
  TitleLbl.Caption := Webbrowser1.OleObject.Document.title;
 end;
end;



(*
Function THtmlEOL.MkFileName(RetNo:Integer):String;
Var s:String;
begin
 s:= RemoveChar(RemoveChar(NetFileDir+'\'+GetSinNo(RetNo)
     +'-'+GetFirstName(RetNo)
     +'-'+GetLastName(RetNo),' '),'.');
 Result:=s+'.XML';  //20111202
end;
*)

Function THtmlEOLT1_2026.GetProductionOrTest:String;
begin
 If ProdOrTestBox.itemIndex =0 then
   Result:='P'
 else
   Result :='T';
end;

procedure THtmlEOLT1_2026.TransmitBtnClick(Sender: TObject);
Var FileName:String;  Flags: OLEVariant; h:THandle;
begin
Try
 CurrentRtn:='Navigate';
 WebBrowser1.Navigate(WideString('www.visualtax.com/Efiling/RedirectPage.asp' +
                                 GetPreparerInfo('')),Flags, Flags, Flags, Flags);

 urls.text := '';
 delay(1000);


  Chdir(NetFileDir);
  FileName:= FileNameBox.Text;

  Url:=UrlBox.Text;
  If (OnLineNo='')
  or (Password='')
  then
  begin
   ShowMessage('Please complete the EOL setup first');
   Exit;
  end;
  If (FileName='')
  or (Url='')
  then
  begin
   ShowMessage('Please complete all boxes above');
   Exit;
  end;

  Screen.Cursor :=crHourGlass;
  FileName := FileNameBox.Text;
  If Not FileExists(FileName) then
  begin
   ShowMessage('File '+FileName+' has not been built or invalid directory');
   Screen.Cursor:=crDefault;
   exit;
  end;
 CurrentRtn:='PostMsg';
 PostMessage(Handle, CM_HOMEPAGEREQUEST, 0, 0);
 CurrentRtn:='Properties';
 ShowBrowserProperties;
 CurrentRtn:='Assigned';
 if Assigned(WebBrowser1.Document) then
 begin
  UrlLbl.Caption := Webbrowser1.OleObject.Document.Url;
  TitleLbl.Caption := Webbrowser1.OleObject.Document.title;
 end;
 Screen.Cursor:=crDefault;
 Except
  on E: Exception do MessageDlg(E.Message+' '+CurrentRtn, mtError, [mbok], 0);
 end;
end;

(*
procedure THtmlEOL.DisplayFile1Click(Sender: TObject);
Var Flnm:String;FirstLast:String;
begin
 Try
  Flnm :=Appdir+'\'+'Temp.TAX';
  PorT:=GetProductionOrTest;
  CreateFile(RetNo,Flnm,PorT,'','T',FirstLast,OnLineMethod,DcnSeqNo);  //'' is tedflnane
  SomeList := TStringList.Create;
  SomeCaption := 'EFile contents';
  SomeList.LoadFromFile(Flnm);
  Application.CreateForm(TPoplist,PopList);
  {PopList.Width := 800;}
  PopList.ShowModal;
 Finally
  SomeList.Clear;  //Free;
  PopList.Release;
 end;
end;
*)
procedure THtmlEOLT1_2026.BuildFile1Click(Sender: TObject);
Var FileNm:String;FirstLast:String;
begin
 FirstLast:='';
 FileNm := FileNameBox.Text;
 ProdOrTest:=GetProductionOrTest;
 CreateXmlDataFile(RetNo,FileNm,ProdOrTest,OnLineMethod,Sender);
end;

procedure THtmlEOLT1_2026.FillLoginData1Click(Sender: TObject);
var h:Word;
begin
// h:=ShellExecute(self.Handle,'open', Pchar(''+FileName), nil, nil, SW_NORMAL) ;  //20110216 does not work
 FillForm(WebBrowser1, 'EFILER', OnlineNo);
 FillForm(WebBrowser1, 'PASSWORD', Password);
 FillForm(WebBrowser1, 'PMTIND', 'Checked');
(*


 FillForm(WebBrowser1, 'AGENTNUM', OnlineNo);
 FillForm(WebBrowser1, 'AGENTPASS', Password);
 FillForm(WebBrowser1, 'PMTIND', 'Checked');
 *)
// FillForm(WebBrowser1, 'uploaded_file', FileName);
end;

procedure THtmlEOLT1_2026.SetUp1Click(Sender: TObject);
begin
  ExecuteForm(TEOLSetUpT1_2026);
  GetParms;
end;

procedure THtmlEOLT1_2026.ExitBtnClick(Sender: TObject);
begin
  If FileExists(FileNameBox.Text) then SysUtils.DeleteFile(FileNameBox.text);  //20130317
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

procedure THtmlEOLT1_2026.UpdateDataBase1Click(Sender: TObject);
Var //RNo:Integer;
    SinNo,Status,ConfirmationNo,DataDir,FlName,AckRcvdBy,AckRcvdDt,AckRcvdTm:String;
begin
  ConfirmationNo:=GetConfirmationNoFromHtml;
  If ConfirmationNo='' then
  begin
   ShowMessage('Confirmation no cannot be retrieved'+
     Chr(13)+'Please mark it down and enter it on the T183 form');
  end;

  SinNo:=LeftStr(ExtractFileName(FileName),9);
  RetNo:=IsRetInMemory(SinNo);  //0=not found
  If RetNo=0 then  //not in memory
  begin
   FlName:= LeftStr(SinNo,8)+'.'+RightStr(SinNo,1);
 //  CreatingNew := True;
   RetNo := LoadReturn(DataDir,FlName);
   if RetNo < 1 then //failed
   begin
    ShowMessage('Tax return '+FlName+' could not be found or cannot load from '+DataDir);
    //RetNo:=RetNo-1;
    Exit;
   end;
  end;

  Status:='02';
  DataDir:=OptRec.Dir_Cur;
  FlName:= LeftStr(SinNo,8)+'.'+RightStr(SinNo,1);
  AckRcvdBy:= UserName;
  AckRcvdDt:=FormatDateTime('yyyy-mm-dd',now);
  AckRcvdTm:=TimeToStr(Now);
   If UpdateAckStatus(SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo) then
   begin
     If SaveReturn(RetNo,DataDir,FlName,True,True) <0 then  //override=true, no prompt
       ShowMessage('Return failed to save with acknowledgment data')
     else
      begin
       ShowMessage('Return updated with acknowledgment data');
       BackupTAXfile(NetFileDir,FileName); //this is the tax file transmitted
       If FileExists(FileName) then DeleteFile(FileName);  //20130130
      end;
   end
   else  //memory update failed
       ShowMessage('Return faild to save with acknowledgment data');
end;

Function THtmlEOLT1_2026.UpdateAckStatus(SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo:String):boolean;
Var RNo,FNo:Integer;
begin
 Result:=False;
 RNo:=IsRetInMemory(SinNo);  //0=not found
 If RNo>0 then
 begin
   FNo:=GetFormNo('STATUS');
   If Ret[RNo].Frm[Fno].Count =0 then InitFormData(RNo,FNo);
   Ret[RNo].EfStatus:=Status;
   StoreElm(RNo,FNo,15,Status);
   StoreElm(RNo,FNo,21,AckRcvdDt);
   StoreElm(RNo,FNo,22,AckRcvdDt);
   StoreElm(RNo,FNo,23,AckRcvdTm);
   StoreElm(RNo,FNo,31,ConfirmationNo);  //conf and DCN

   FNo:=GetFormNo('T183');
   If Ret[RNo].Frm[Fno].Count =0 then InitFormData(RNo,FNo);
   if Fno>0 then
     StoreElm(RNo,FNo,21,ConfirmationNo)
   else
     ShowMessage('Form T183 not found. Confirmation no Not stored');
   Ret[RNo].Changed:=True;
   Result:=True;
   Exit;
 end;
end;


Function THtmlEOLT1_2026.LoadReturn(DataDir:String;FlName:string):integer;
var
  //20150821 igor
  FDConnection: TADConnection;
  Table: TADTable;
begin
  Result := iorUnknown;

  FDConnection := TADConnection.Create(nil);
  Table := TADTable.Create(nil);
  try
    //20150925 igor
    if SetTableName(FDConnection, Table, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name')
    then
      //20150904 igor
      //20170223 Igor >>>
      //if Table.FindKey([FlName]) = True then
      if Table.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
      //20170223 Igor <<<
      begin
        Result:= ReadReturn(Datadir, FlName);
      end;
  finally
    FreeAndNil(FDConnection);
    FreeAndNil(Table);
  end;
end;


Function THtmlEOLT1_2026.BackUpTaxFile(NetFileDir,FileName:String):Boolean;
Var DestDir:String; FlNm:String;
begin
 Result:=False;
 DestDir:=NetFileDir+'\'+'Transmitted';
 FlNm:=ExtractFileName(FileName);
 ForceDirectories(DestDir);
 If DirectoryExists(DestDir) then
 begin
   If CopyFile(FileName,DestDir+'\'+FLNm) then
   begin
    result:=True;
   // ShowTimedMsg(FileName + ' copied to folder: '+DestDir,1600);  //20130130
    Exit;
   end
   else
   begin
    ShowMessage('Failed to back up the transmitted file');
   end;
 end
 Else  //no backup directory
  ShowMessage('Directory '+NetFileDir+'\'+'Transmitted' + ' cannot be created');
end;


procedure THtmlEOLT1_2026.DoAllBtnClick(Sender: TObject);
begin
DataDirBox.Text := OptRec.Dir_Cur;
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
DoAll;
ShowMessage('All done');

end;

procedure THtmlEOLT1_2026.DoAll;
var i:integer; TmpList :TstringList;FileNm,s:string;FirstLast:String;
begin

 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;
 TmpList := TStringList.Create;
 for i:=0 to FileListBox1.Items.Count -1 do
 begin
     FileListBox1.ItemIndex :=i;
     FileListBox1.Refresh;
     //RetNo:=InitNewReturn;
     If (UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite))                             //20150909 Igor
     and(UpperCase(FileListBox1.Items[i]) <> UpperCase(ReplaceStr(ClientsDBLite,'.','-JOURNAL.'))) //20151018 Igor
     then
       Try
        //if ReadReturn(RetNo,DataDirBox.Text,FileListBox1.Items[i]) =0 then
        RetNo := ReadReturn(DataDirBox.Text,FileListBox1.Items[i]);
        if RetNo > 0 then
        begin
         DoingLbl.Caption:='';
         DoingLbl.Caption := '#'+IntToStr(i+1);
         DoingLbl.Refresh;
         CalcAll(RetNo);

         FirstLast:='';
         FileName :=MkXmlFileName(RetNo,NetFileDir);
         FileNameBox.Text :=FileName;
        end;
        except
        end;
     If RetNo > 0 then RemoveReturnFromMemory(RetNo);
     RetNo:=0; //RetInMem :=0;
  end;
 TmpList.Free;
end;

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

Function THtmlEOLT1_2026.GetConfirmationNoFromHtml:String;
Var i,k:Integer; TempList:TStringList;s:String;
begin
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


function THtmlEOLT1_2026.GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
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
Function THtmlEOL.GetDcnSeqNoEOL:String;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec,SMSec : string[2];
 Syyyy:String[4];
begin
   DecodeDate(Now,YYYY,MM,DD);
   DecodeTime(Now,Hour,Min,Sec,Msec);
   Syyyy:=AllTrim(IntToStr(YYYY));
   SMM   := LTrim(RTrim(IntToStr(MM)));
   SDD   := Ltrim(Rtrim(IntToStr(dd)));
   SMIN  := Ltrim(Rtrim(IntToStr(Min)));
   SSec   := AllTrim(IntToStr(Sec));
   SMSec:=LTrim(RTrim(IntToStr(MSec)));
   If Length(SMM)   =1 then SMM   := '0'+SMM;
   If Length(SDD)   =1 then SDD   := '0'+Sdd;
   If Length(SMIN)  =1 then SMin  := '0'+SMin;
   If Length(SSec)  =1 then SSec  := '0'+SSec;
   If Length(SMSec) =1 then SMSec:= '0'+SMSec;
   Result:=OnlineNo+smm+Sdd+SMin+SMSec;    //2005
end;
*)

procedure THtmlEOLT1_2026.ShowContentsBtnClick(Sender: TObject);
Var h:Word;
begin
  h := ShellExecute(Self.Handle,'open',Pchar(''+FileNameBox.Text),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('File not found');
{
 h:=ShellExecute(Self.Handle,'open', Pchar(''+FileNameBox.Text), nil, nil, SW_SHOWNORMAL) ; //20110216
 ShowMessage(IntToStr(h));
 }
// DisplayFile1Click(Sender);
end;

procedure THtmlEOLT1_2026.SaveDialog1Close(Sender: TObject);
begin
 If FileExists(FileNameBox.Text) then SysUtils.DeleteFile(FileNameBox.text);
 Close;
end;

(* VB
Private Sub Command2_Click()
On Error GoTo CancelError

With CommonDialog1
    .DialogTitle = "open"
    .ShowOpen
End With

CancelError:
Select Case Err.Number
    Case 32755 '/// closed dialog with cancel button
    MsgBox "You closed without choosing a file!", vbOKOnly, Err.Description
End Select

End Sub
*)
procedure THtmlEOLT1_2026.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        System.Set8087CW($1372); // Default value  //resets the floating error //20130207 
end;

procedure THtmlEOLT1_2026.BitBtn1Click(Sender: TObject);
begin
  //  20130724
end;

end.
