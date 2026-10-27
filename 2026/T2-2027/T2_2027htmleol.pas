unit T2_2027htmleol;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Menus,ComCtrls,OleCtrls,Buttons,ToolWin,ActnList,ImgList,shdocvw,
  Printers,Db,ActiveX,T2_2027Declare,T2_2027TrimStr,ShellApi,
  T2_2027ChildWinNew,FileCtrl, System.Actions, uADCompClient, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADCompDataSet;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  THtmlEOLT2_2027 = class(TForm)
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
    Query1: TADQuery;
    FillLoginData1: TMenuItem;
    UpdateDataBase1: TMenuItem;
    HeaderPanel: TPanel;
    urlLbl: TLabel;
    TitleLbl: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TransmitBtn: TBitBtn;
    FileNameBox: TEdit;
    URLBox: TEdit;
    ExitBtn: TBitBtn;
    ProdOrTestBox: TRadioGroup;
    procedure StopClick(Sender: TObject);
    procedure URLsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    //procedure LinksClick(Sender: TObject);
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
  const pDisp: IDispatch; const URL: OleVariant);
    procedure WebBrowser1TitleChange(Sender: TObject;const Text: WideString);
    function FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
    procedure Print1Click(Sender: TObject);
    procedure WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
    procedure FillData(RetNo:Integer);
    procedure ShowBrowserProperties;
    //procedure BuildBtnClick(Sender: TObject);
    //procedure ShowBtnClick(Sender: TObject);
    Function GetProductionOrTest:String;
    procedure TransmitBtnClick(Sender: TObject);
    procedure FillLoginData1Click(Sender: TObject);
    //procedure GetParms;
    procedure ExitBtnClick(Sender: TObject);
    procedure UpdateDataBase1Click(Sender: TObject);
    Function LoadReturn(RNo:Integer;DataDir:String;FlName:string):Boolean;
    Function UpdateAckStatus(SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo:String):boolean;
    Function BackUpTaxFile(NetFileDir,FileName:String):Boolean;
    Function GetConfirmationNoFromHtml:String;
    function  GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
  private
    FRetNo: integer;

   private
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;
    property RetNo: integer read FRetNo;
    procedure FindAddress;
    procedure HomePageRequest(var message: tmessage); message CM_HOMEPAGEREQUEST;
  end;

var
  HtmlEOLT2_2027: THtmlEOLT2_2027;
  CurDispatch: IDispatch; {save the interface globally }
  OnLineNo,PassWord,FileName,Url:String;  //to be used by the uhtmlEfOnline
  //DcnSeqNo:String;
  //F1:TextFile;
  //SfdNo : Integer;
  //EFlines  : TStringList;
  POrT:string; //[1];
  //CrLf  :String;
  //SegmentCnt:Integer;
  NetFileDir:String;

implementation

{$R *.DFM}

uses vtDialogs,vtCommon,vtTrimStr,vtShared;

procedure THtmlEOLT2_2027.FormCreate(Sender: TObject);
begin
  FRetNo := getcurrentRetNo;
 System.Set8087CW($133f); //Disable all fpu (floating point) exceptions //20130207

 //GetParms;
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 UrlBox.Text:=Url;
 Urls.Text:=UrlBox.Text;

 FileName := MkCorEfileName(RetNo); //20170626
 FileNameBox.Text :=FileName;
 ProdOrTestBox.ItemIndex :=0;

 HistoryIndex := -1;
 HistoryList := TStringList.Create;
 Screen.Cursor:=CrDefault;
end;


procedure THtmlEOLT2_2027.FindAddress;
var
  Flags: OLEVariant;

begin
  Flags := 0;
  UpdateCombo := True;
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;

procedure THtmlEOLT2_2027.StopClick(Sender: TObject);
begin
 if Assigned(WebBrowser1.Document) then WebBrowser1.Stop;
end;

procedure THtmlEOLT2_2027.URLsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    FindAddress;
  end;
end;

procedure THtmlEOLT2_2027.URLsClick(Sender: TObject);
begin
  FindAddress;
end;

procedure THtmlEOLT2_2027.RefreshClick(Sender: TObject);
begin
  FindAddress;
end;

procedure THtmlEOLT2_2027.BackClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex - 1];
  FindAddress;
end;

procedure THtmlEOLT2_2027.ForwardClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex + 1];
  FindAddress;
end;

procedure THtmlEOLT2_2027.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ssAlt] then
    if (Key = VK_RIGHT) and ForwardBtn.Enabled then
      ForwardBtn.Click
    else if (Key = VK_LEFT) and BackBtn.Enabled then
      BackBtn.Click;
end;

procedure THtmlEOLT2_2027.Toolbar3Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    Coolbar1.Visible := Checked;
  end;
end;

procedure THtmlEOLT2_2027.Statusbar2Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    StatusBar1.Visible := Checked;
  end;
end;

procedure THtmlEOLT2_2027.HomePageRequest(var Message: TMessage);
Var AppDir:String;{with slash}
begin
  AppDir := ExtractFilePath(Application.ExeName); {where the Exe is}
  Urls.Text:= url;
  FindAddress;
end;


procedure THtmlEOLT2_2027.FormDestroy(Sender: TObject);
begin
  HistoryList.Free;
end;

procedure THtmlEOLT2_2027.BackActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    BackAction.Enabled := HistoryIndex > 0
 else
    BackAction.Enabled := False;
end;

procedure THtmlEOLT2_2027.ForwardActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    ForwardAction.Enabled := HistoryIndex < HistoryList.Count - 1
  else
    ForwardAction.Enabled := False;
end;

procedure THtmlEOLT2_2027.WebBrowser1DownloadBegin(Sender: TObject);
begin
  ShowBrowserProperties;
  { Turn the stop button dark red }
  StopBtn.ImageIndex := 4;
  { Play the avi from the first frame indefinitely }
  //Animate1.Active := True;
end;

procedure THtmlEOLT2_2027.WebBrowser1DownloadComplete(Sender: TObject);
begin
  ShowBrowserProperties;
  { Turn the stop button grey }
  StopBtn.ImageIndex := 2;
  { Stop the avi and show the first frame }
  //Animate1.Active := False;

 // https://www.pro.netfile.ccra-adrc.gc.ca/servlet/NetfileAgentAccessServlet?language=english&action=login
 // ShowMessage('Download complete');
end;

procedure THtmlEOLT2_2027.ExitProgramClick(Sender: TObject);
begin
Close;
end;

procedure THtmlEOLT2_2027.WebBrowser1BeforeNavigate2(ASender: TObject;
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

procedure THtmlEOLT2_2027.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  ShowBrowserProperties;

  If FillForm(WebBrowser1, 'clientIdentNbr', OnlineNo) = True then
     FillData(RetNo);

  If Webbrowser1.OleObject.Document.title = 'Return Accepted' then
    UpdateDataBase1Click(ASender);

end;

function THtmlEOLT2_2027.FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
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

procedure THtmlEOLT2_2027.WebBrowser1TitleChange(Sender: TObject;
  const Text: WideString);
begin
 ShowBrowserProperties;
end;

procedure THtmlEOLT2_2027.Print1Click(Sender: TObject);
var
  vaIn, vaOut: OleVariant; // Needed in all examples

Begin
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER,vaIn, vaOut);
end;

procedure THtmlEOLT2_2027.WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
 ShowBrowserProperties;
 //if CurDispatch = nil then CurDispatch := pDisp; { save for comparison }
end;


procedure THtmlEOLT2_2027.FillData(RetNo:Integer);
begin
 FillForm(WebBrowser1, 'clientBase', LeftStr(GetCorpBusNo(RetNo),9));
 FillForm(WebBrowser1, 'clientExt', RightStr(GetCorpBusNo(RetNo),4));
 FillForm(WebBrowser1, 'clientYyyy', LeftStr(GetTaxationYearEnd(RetNo),4));
 FillForm(WebBrowser1, 'clientMm',MidStr(GetTaxationYearEnd(RetNo),6,2));
 FillForm(WebBrowser1, 'clientDd',RightStr(GetTaxationYearEnd(RetNo),2));
 FillForm(WebBrowser1, 'clientIdentNbr', OnlineNo);
 FillForm(WebBrowser1, 'clientAgentPassword', Password);
 If OnlineNo='' then FillForm(WebBrowser1, 'clientWac', GetWacNumber(RetNo));
 FillForm(WebBrowser1, 'clientFile', FileName);
end;

procedure THtmlEOLT2_2027.ShowBrowserProperties;
begin
 if Assigned(WebBrowser1.Document) then
 begin
  // abends: WebBrowser1.OleObject.Document.Body.Style.Zoom := 0.50;
  UrlLbl.Caption := Webbrowser1.OleObject.Document.Url;
  TitleLbl.Caption := Webbrowser1.OleObject.Document.title;
 end;
end;


Function THtmlEOLT2_2027.GetProductionOrTest:String;
begin
 If ProdOrTestBox.itemIndex =0 then
   Result:='P'
 else
   Result :='T';
end;

procedure THtmlEOLT2_2027.TransmitBtnClick(Sender: TObject);
Var FileName:String;  Flags: OLEVariant;

begin
  //capture info
  WebBrowser1.Navigate(WideString('http://www.visualtax.com/EfilingT2/RedirectPage.asp' +
                                 GetPreparerInfo('')),Flags, Flags, Flags, Flags);

  urls.text := '';
  delay(1000);

  Chdir(NetFileDir);
  //FirstLast:='';
  FileName:= FileNameBox.Text;
  Url:=UrlBox.Text;
  (*
  If (OnLineNo='')
  or (Password='')
  then
  begin
   ShowMessage('Please complete the CIF setup first');
   Exit;
  end;

  If (Url='')
  then
  begin
   ShowMessage('Please complete all boxes above');
   Exit;
  end;
  *)
  Screen.Cursor :=crHourGlass;
  PostMessage(Handle, CM_HOMEPAGEREQUEST, 0, 0);
  ShowBrowserProperties;
  if Assigned(WebBrowser1.Document) then
  begin
   UrlLbl.Caption := Webbrowser1.OleObject.Document.Url;
   TitleLbl.Caption := Webbrowser1.OleObject.Document.title;
  end;
end;


procedure THtmlEOLT2_2027.FillLoginData1Click(Sender: TObject);
begin
//ShowMessage('filename='+FileName);
 FillForm(WebBrowser1, 'uploaded_file', FileName);
 FillForm(WebBrowser1, 'AGENTNUM', OnlineNo);
 FillForm(WebBrowser1, 'AGENTPASS', Password);
 FillForm(WebBrowser1, 'PMTIND', 'Checked');
end;


procedure THtmlEOLT2_2027.ExitBtnClick(Sender: TObject);
begin
  If FileExists(FileName) then SysUtils.DeleteFile(FileName);
    Close;
end;

procedure THtmlEOLT2_2027.UpdateDataBase1Click(Sender: TObject);
Var
  RNo:Integer;
  SinNo,Status,ConfirmationNo,DataDir,FlName,AckRcvdBy,AckRcvdDt,AckRcvdTm:String;
begin

end;

Function THtmlEOLT2_2027.UpdateAckStatus(SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo:String):boolean;
Var
  RNo,FNo:Integer;
begin
end;

Function THtmlEOLT2_2027.LoadReturn(RNo:Integer;DataDir:String;FlName:string):Boolean;
Var
  Table1 : TADTable;Reslt:Integer;
begin
end;


Function THtmlEOLT2_2027.BackUpTaxFile(NetFileDir,FileName:String):Boolean;
Var DestDir:String; FlNm:String;
begin
 Result:=False;
 DestDir:=NetFileDir+'\'+'Transmitted';
 FlNm:=ExtractFileName(FileName);
 SysUtils.ForceDirectories(DestDir); //20150702
 If SysUtils.DirectoryExists(DestDir) then //20150702
 begin
   If CopyFile(FileName,DestDir+'\'+FLNm) then
   begin
    result:=True;
    ShowTimedMsg(FileName + ' copied to folder: '+DestDir,1200);
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



Function THtmlEOLT2_2027.GetConfirmationNoFromHtml:String;
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


function THtmlEOLT2_2027.GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
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


procedure THtmlEOLT2_2027.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 System.Set8087CW($1372); //back to default value //20130207
end;

end.
