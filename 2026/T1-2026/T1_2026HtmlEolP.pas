unit T1_2026htmleolp;
interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Menus,ComCtrls,OleCtrls,Buttons,ToolWin,ActnList,ImgList,shdocvw,
  FileCtrl,Printers,TeeProcs,TeEngine,Chart,ActiveX,Db, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADCompDataSet, uADCompClient,
  System.Actions;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  THtmlEOLPT1_2026 = class(TForm)
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
    MonitorPlanBtn: TChart;
    Label1: TLabel;
    urlLbl: TLabel;
    TitleLbl: TLabel;
    OpenDialog1: TOpenDialog;
    Query1: TADQuery;
    ProcessAckBtn: TBitBtn;
    Label2: TLabel;
    ProcessTransmittedFilesBtn: TBitBtn;
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
    procedure WebBrowser1BeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1DownloadBegin(Sender: TObject);
    procedure WebBrowser1DownloadComplete(Sender: TObject);
    procedure ExitProgramClick(Sender: TObject);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowser1TitleChange(Sender: TObject;const Text: WideString);
    function FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
    procedure Print1Click(Sender: TObject);
    //procedure FillDataBtnClick(Sender: TObject);
    procedure FillLogin;
    procedure FillFileName;
    //procedure FillBatchFileClick(Sender: TObject);
    procedure SetDocumentCaption;
    Function  GetAckFileNameFromHtml:String;
    
    function  GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
    procedure ProcessAckBtnClick(Sender: TObject);
    procedure ProcessTransmittedFilesBtnClick(Sender: TObject);
    //procedure ReadAck(FlName:String);
    (*
    procedure UpdateDataBase(FlNm:String);
    Function  UpdateAckStatus(SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo:String):boolean;
    Function  LoadReturn(RNo:Integer;DataDir:String;FlName:string):Boolean;
    Function  BackUpTEDFile(NetFileDir,FileName:String):Boolean;
    *)

   private
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;
    procedure FindAddress;
    procedure HomePageRequest(var message: tmessage); message CM_HOMEPAGEREQUEST;
  end;

var
  HtmlEOLP: THtmlEOLPT1_2026;
  PrevDownloadDir:String;
  //OnLineNo,PassWord:String;  done in UNetFile

implementation


{$R *.DFM}

uses vtCommon,vtTrimStr,T1_2026EolPAck,T1_2026Trimstr,T1_2026Declare,
  T1_2026Common,T1_2026Common2,T1_2026EOLP,T1_2026Main,
  T1_2026EFileRtns;

procedure THtmlEOLPT1_2026.FormCreate(Sender: TObject);
Var Flags: OLEVariant;
begin
 PrevDownloadDir:=GetRegistryValue(
   HKEY_CURRENT_USER,'\Software\Microsoft\Internet Explorer\','Download Directory');
 //set the IE download directory
  SetRegistryValue(
   HKEY_CURRENT_USER,'\Software\Microsoft\Internet Explorer\','Download Directory',NetFileDir);

  HistoryIndex := -1;
  HistoryList := TStringList.Create;
  { Load the animation from the AVI file in the startup directory.  An
    alternative to this would be to create a .RES file including the cool.avi
    as an AVI resource and use the ResName or ResId properties of Animate1 to
    point to it. }
  //Animate1.FileName := ExtractFilePath(Application.ExeName) + 'cool.avi';
  { Find the home page - needs to be posted because HTML control hasn't been
    registered yet. }

  WebBrowser1.Navigate(WideString('www.visualtax.com/Efiling/RedirectPage.asp' +
                                 GetPreparerInfo('')),Flags, Flags, Flags, Flags);

  urls.text := '';
  delay(1000);

  PostMessage(Handle, CM_HOMEPAGEREQUEST, 0, 0);
end;


procedure THtmlEOLPT1_2026.FindAddress;
var
  Flags: OLEVariant;
begin
  Flags := 0;
  UpdateCombo := True;
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;

procedure THtmlEOLPT1_2026.StopClick(Sender: TObject);
begin
  WebBrowser1.Stop;
end;

procedure THtmlEOLPT1_2026.URLsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    FindAddress;
  end;
end;

procedure THtmlEOLPT1_2026.URLsClick(Sender: TObject);
begin
  FindAddress;
end;

(*
procedure THtmlEOLP.LinksClick(Sender: TObject);
begin
  {if (Sender as TToolButton).Hint = '' then Exit;}
  URLs.Text := (Sender as TToolButton).Hint;
  FindAddress;
end;
*)
procedure THtmlEOLPT1_2026.RefreshClick(Sender: TObject);
begin
  FindAddress;
end;

procedure THtmlEOLPT1_2026.BackClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex - 1];
  FindAddress;
end;

procedure THtmlEOLPT1_2026.ForwardClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex + 1];
  FindAddress;
end;

procedure THtmlEOLPT1_2026.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ssAlt] then
    if (Key = VK_RIGHT) and ForwardBtn.Enabled then
      ForwardBtn.Click
    else if (Key = VK_LEFT) and BackBtn.Enabled then
      BackBtn.Click;
end;

procedure THtmlEOLPT1_2026.Toolbar3Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    Coolbar1.Visible := Checked;
  end;
end;

procedure THtmlEOLPT1_2026.Statusbar2Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    StatusBar1.Visible := Checked;
  end;
end;

procedure THtmlEOLPT1_2026.HomePageRequest(var Message: TMessage);
Var AppDir:String;{with slash}
begin
  AppDir := ExtractFilePath(Application.ExeName); {where the Exe is}
  Urls.Text:= url; //coming from Unetfile 'http://www.netfile.gc.ca/pro';
  //Urls.Text:='http://www.pro.netfile.ccra-adrc.gc.ca/eol-splash-e.html';
  //URLs.Text := 'File://'+AppDir+'Index.Htm';
  {URLs.Text := 'www.visualTax.com';}
  FindAddress;
end;


procedure THtmlEOLPT1_2026.FormDestroy(Sender: TObject);
begin
  HistoryList.Free;
end;

procedure THtmlEOLPT1_2026.BackActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    BackAction.Enabled := HistoryIndex > 0
 else
    BackAction.Enabled := False;
end;

procedure THtmlEOLPT1_2026.ForwardActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    ForwardAction.Enabled := HistoryIndex < HistoryList.Count - 1
  else
    ForwardAction.Enabled := False;
end;

procedure THtmlEOLPT1_2026.WebBrowser1BeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
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

procedure THtmlEOLPT1_2026.WebBrowser1DownloadBegin(Sender: TObject);
begin
  { Turn the stop button dark red }
  StopBtn.ImageIndex := 4;
  { Play the avi from the first frame indefinitely }
  //Animate1.Active := True;
end;

procedure THtmlEOLPT1_2026.WebBrowser1DownloadComplete(Sender: TObject);
begin
  { Turn the stop button grey }
  StopBtn.ImageIndex := 2;
  { Stop the avi and show the first frame }
  //Animate1.Active := False;

 // https://www.pro.netfile.ccra-adrc.gc.ca/servlet/NetfileAgentAccessServlet?language=english&action=login
 {
 ShowMessage('Download complete');
 ProcessAckClick(Sender);
 }
end;

procedure THtmlEOLPT1_2026.ExitProgramClick(Sender: TObject);
begin
 SetRegistryValue(
   HKEY_CURRENT_USER,'\Software\Microsoft\Internet Explorer\','Download Directory',PrevDownloadDir);
Close;
end;

procedure THtmlEOLPT1_2026.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
 SetDocumentCaption;
 //ShowMessage(UrlLbl.Caption);
 If FillForm(WebBrowser1, 'lsIdentNbr', OnlineNo) then FillLogin;  //2004
 If FillForm(WebBrowser1, 'clientFile', FileName) then FillFileName;
 //If FillForm(WebBrowser1, 'commIdentNbr', OnlineNo) then FillLogin; //2003
end;

function THtmlEOLPT1_2026.FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
var
  i, j: Integer;
  FormItem: Variant;
begin
  //If FieldName='clientFile' then showMessage('Click Browse to select file');
  Result := False;
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
          (*
          If FormItem.Item(j).Name='clientFile' then
           FormItem.Item(j).Name.value := Value
          else
          *)
          FormItem.Item(j).Value := Value;
          Result := True;
        end;
      except
        Exit;
      end;
    end;
  end;
end;

procedure THtmlEOLPT1_2026.WebBrowser1TitleChange(Sender: TObject;
  const Text: WideString);
begin
 SetDocumentCaption;
 //If Text = 'Errors detected' then ShowMessage('Errors detected: = '+Text);
//ShowMessage('Title change Text = '+Text);
end;

procedure THtmlEOLPT1_2026.Print1Click(Sender: TObject);
var
  //OldCur: TCursor;
  vaIn, vaOut: OleVariant; // Needed in all examples

Begin
  // Print with the Printer dialog
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER,vaIn, vaOut);
 (*
  // Printing without the Printer dialog
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER,vaIn, vaOut);
  // Show the Print Preview dialog
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINTPREVIEW,OLECMDEXECOPT_DONTPROMPTUSER, vaIn, vaOut);
  // Show the Page Setup dialog
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PAGESETUP, OLECMDEXECOPT_PROMPTUSER,vaIn, vaOut);
 *)
end;
 (* OldCur := Screen.Cursor;
 begin
  with Printer do begin
     BeginDoc;
     //HTML1.AutoPrint(handle);
     //Title := HTML1.URL;
     EndDoc;
  end;
  Screen.Cursor := OldCur;
end;
*)


(*
procedure THtmlEFOnline.WebBrowser1NavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  HTMLDoc: IHTMLDocument2;
  HTMLWnd: IHTMLWindow2;
  HTMLWindow3: IHTMLWindow3;
begin
  HTMLDoc := (Sender as TWebBrowser).Document as IHTMLDocument2;
  if HTMLDoc = nil then
    raise Exception.Create('Couldn''t convert the WebBrowser to an IHTMLDocument2');
  HTMLWnd := HTMLDoc.parentWindow;
  HTMLWindow3 := HTMLWnd as IHTMLWindow3;
  // Finally, we get to the print method
  HTMLWindow3.print;
end;
*)

(* IPersistStreamInit  not known;
procedure THtmlEFOnline.SaveHTMLSourceToFile(const FileName: string; WB: TWebBrowser);
var
  PersistStream: IPersistStreamInit;
  FileStream: TFileStream;
  Stream: IStream;
  SaveResult: HRESULT;
begin
  PersistStream := WB.Document as IPersistStreamInit;
  FileStream := TFileStream.Create(FileName, fmCreate);
  try
    Stream := TStreamAdapter.Create(FileStream, soReference) as IStream;
    SaveResult := PersistStream.Save(Stream, True);
    if FAILED(SaveResult) then
      MessageBox(Handle, 'Fail to save HTML source', 'Error', 0);
  finally
    { we are passing soReference to TStreamAdapter contructor parameter,
      it is our reponsibility to destroy the stream object. }
    FileStream.Free;
  end;
end;
*)

(*
procedure THtmlEOLP.FillBatchFileClick(Sender: TObject);
begin
 If  FillForm(WebBrowser1, 'uploaded_file', FileName) = False then
  ShowMessage('Click when prompted for File Location');
end;
*)
procedure THtmlEOLPT1_2026.SetDocumentCaption;
begin
 if Assigned(WebBrowser1.Document) then
 begin
  // abends: WebBrowser1.OleObject.Document.Body.Style.Zoom := 0.50;
  UrlLbl.Caption := Webbrowser1.OleObject.Document.Url;
  TitleLbl.Caption := Webbrowser1.OleObject.Document.title;
 end;
end;

procedure THtmlEOLPT1_2026.FillLogin;
Var flags:OleVariant;NextUrl:WideString;
begin
 FillForm(WebBrowser1, 'lsIdentNbr', OnlineNo);  //new nm in 2004
 FillForm(WebBrowser1, 'lsPassword', Password);
 FillForm(WebBrowser1, 'clientFile', FileName);
 //FillForm(WebBrowser1, 'commIdentNbr', OnlineNo);
 //FillForm(WebBrowser1, 'commAgentPassword', Password);
end;

procedure THtmlEOLPT1_2026.FillFileName;
begin
 FillForm(WebBrowser1, 'clientFile', FileName);
end;

(*
procedure THtmlEOLP.ReadAck(FlName:String);
begin
//
end;
*)

(*
procedure THtmlEOLP.ProcessAckClick(Sender: TObject);
Var FlNm:String;
begin
 {
 FlNm:=GetAckFileNameFromHtml+'.ACK';
 ShowMessage('AckFile='+Flnm);
 Exit;
 UpdateFromAck(FlNm);
 }
end;
*)
(*
procedure THtmlEOLP.UpdateDataBase(FlNm:String);
Var RNo:Integer;
    SinNo,Status,ConfirmationNo,DataDir,FlName,AckRcvdBy,AckRcvdDt,AckRcvdTm:String;
begin
  ShowTimedMsg('Updating the DataBase',1000);
  ConfirmationNo:=GetConfirmationNoFromHtml;
  If ConfirmationNo='' then
  begin
   ShowMessage('Confirmation no cannot be retrieved'+
     Chr(13)+'Please mark it down and enter it on the T183 form');
  end;
  EXIT;

  SinNo:=LeftStr(ExtractFileName(FileName),9);
  RNo:=IsRetInMemory(SinNo);  //0=not found
  If RNo=0 then  //not in memory
  begin
   FlName:= LeftStr(SinNo,8)+'.'+RightStr(SinNo,1);
   CreatingNew := True;
   InitNewReturn(RetNo);  //starting from current return
   RNo:=RetNo;
   If LoadReturn(RNo,DataDir,FlName) = False then //failed
   begin
    ShowMessage('Tax return '+FlName+' could not be found or cannot load from '+DataDir);
    RetNo:=RetNo-1;
    Exit;
   end;
  end;

  Status:='02';
  DataDir:=CfgRec.Dir_Cur;
  FlName:= LeftStr(SinNo,8)+'.'+RightStr(SinNo,1);
  AckRcvdBy:= UserName;
  AckRcvdDt:=FormatDateTime('yyyy-mm-dd',now);
  AckRcvdTm:=TimeToStr(Now);
   If UpdateAckStatus(SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo) then
   begin
     If SaveReturn(RNo,DataDir,FlName,True) <0 then  //override=true, no prompt
       ShowMessage('Return faild to save with acknowledgment data')
     else
      begin
       ShowMessage('Return updated with acknowledgment data');
       BackupTEDfile(NetFileDir,FileName); //this is the tax file transmitted
       If FileExists(FileName) then DeleteFile(FileName);
      end;
   end
   else  //memory update failed
       ShowMessage('Return faild to save with acknowledgment data');
end;
*)
(*
Function THtmlEOLP.UpdateAckStatus(SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo:String):boolean;
Var RNo,FNo:Integer;
begin
 ShowTimedMsg('Updating the Ack status',1000);
 EXIT;

 Result:=False;
 RNo:=IsRetInMemory(SinNo);  //0=not found
 If RNo>0 then
 begin
   FNo:=GetFormNo('STATUS');
   If Ret[RNo]^.Frm[Fno].Count =0 then InitFormData(RNo,FNo);
   Ret[RNo]^.EfStatus:=Status;
   StoreElm(RNo,FNo,15,Status);
   StoreElm(RNo,FNo,21,AckRcvdDt);
   StoreElm(RNo,FNo,22,AckRcvdDt);
   StoreElm(RNo,FNo,23,AckRcvdTm);
   StoreElm(RNo,FNo,31,ConfirmationNo);  //conf and DCN

   FNo:=GetFormNo('T183');
   If Ret[RNo]^.Frm[Fno].Count =0 then InitFormData(RNo,FNo);
   if Fno>0 then
     StoreElm(RNo,FNo,21,ConfirmationNo)
   else
     ShowMessage('Form T183 not found. Confirmation no Not stored');
   Ret[RNo].Changed:=True;
   Result:=True;
   Exit;
 end;
end;
*)
Function THtmlEOLPT1_2026.GetAckFileNameFromHtml:String;
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
   k:=FindWord('name="TIN"',TempList[i]);
   if k>0 then
   begin
    result:=MidStr(TempList[i],k+1,13);
    TempList.Free;
    Exit;
   end;
 end;
 TempList.Free;
 { ShowMessage('Confirmation no cannot be retrieved'+
   Chr(13)+'Please mark it down and enter it on the T183 form');}
end;

(*
Function THtmlEOLP.LoadReturn(RNo:Integer;DataDir:String;FlName:string):Boolean;
Var Table1 : T Table;Reslt:Integer;
begin
  Result := False;
  Table1 := TTable.Create(Application);
  Table1.DataBaseName := DataDir;
  Table1.TableName := ClientsTable;
  Table1.IndexFieldNames := 'FILE_NAME';
  Table1.Open;

  If Table1.FindKey([FlName]) then
  begin
    Reslt:=ReadReturn(RNo,Datadir,FlName);
    If Reslt=0 then  begin Result := True; Table1.Close; Table1.Free; Exit; end
  end;

  Table1.Close;
  Table1.Free;
end;
*)

(*
Function THtmlEOLP.BackUpTEDFile(NetFileDir,FileName:String):Boolean;
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
*)
function THtmlEOLPT1_2026.GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
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

procedure THtmlEOLPT1_2026.ProcessAckBtnClick(Sender: TObject);
begin
 MainFormT1.ProcessAcknowledgements1Click(Sender);
end;

procedure THtmlEOLPT1_2026.ProcessTransmittedFilesBtnClick(Sender: TObject);
begin
 If FileName>'' then ProcessTransmittedFiles(FileName);
end;

end.
