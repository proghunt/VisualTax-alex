unit T1_2026htmlsend;
//updated 07-28

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Menus,ComCtrls,OleCtrls,Buttons,ToolWin,ActnList,ImgList,shdocvw,
  FileCtrl,Printers,VclTee.TeeProcs,VclTee.TeEngine,VclTee.Chart,ActiveX,Db,
  System.Actions, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager, uADCompClient,
  uADCompDataSet;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  THtmlSENDT1_2026 = class(TForm)
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
    MonitorPlanBtn: TChart;
    urlLbl: TLabel;
    TitleLbl: TLabel;
    OpenDialog1: TOpenDialog;
    Query1: TADQuery;
    FDConnection: TADConnection;
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
    procedure FillSin;
    procedure FillGivenName;
    procedure FillSurname;
    procedure FillBirthDate;

    //procedure FillBatchFileClick(Sender: TObject);
    procedure ShowBrowserProperties;
    Function  GetAckFileNameFromHtml:String;
    
    function  GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
    //procedure ProcessAckBtnClick(Sender: TObject);
    //procedure ProcessTransmittedFilesBtnClick(Sender: TObject);
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
  HtmlSEND: THtmlSENDT1_2026;
  RetNo:Integer;
  OnLineNo,TransmitterNo,PassWord,NetFileDir,FileName,Url,OnlineMethod:String;

  Sin, BirthDate,GivenName,SurName,SurnameChangeCd:string;

  //OnLineNo,PassWord:String;  done in UNetFile

implementation

{$R *.DFM}

uses vtTrimStr,vtCommon,T1_2026EolPAck,T1_2026Trimstr,T1_2026Declare,
  T1_2026Common,T1_2026Common2,T1_2026ChildWinNew,T1_2026Main;

procedure THtmlSENDT1_2026.FormCreate(Sender: TObject);
begin
  RetNo:=GetCurrentRetNo;
  GetEOLPParms(OnlineNo,TransmitterNo,Password,Url,NetFileDir);

  url:='https://apps.cra-arc.gc.ca/ebci/efes/emod/sec/EmodLogin-e'; //20140131 (the link on the EOLP set up is no good
//  url:='https://apps-ct.cra-arc.gc.ca/ebci/efes/emod/sec/EmodLogin-e'; //20140131 (the link on the EOLP set up is no good

  Sin:=GetSinNo(RetNo);
  BirthDate:=RemoveChar(FetchELm(RetNo,'T1',9),'-');
  GivenName:=GetFirstName(RetNo);
  Surname:=GetLastName(RetNo);

  HistoryIndex := -1;
  HistoryList := TStringList.Create;
  { Load the animation from the AVI file in the startup directory.  An
    alternative to this would be to create a .RES file including the cool.avi
    as an AVI resource and use the ResName or ResId properties of Animate1 to
    point to it. }
  //Animate1.FileName := ExtractFilePath(Application.ExeName) + 'cool.avi';
  { Find the home page - needs to be posted because HTML control hasn't been
    registered yet. }
  PostMessage(Handle, CM_HOMEPAGEREQUEST, 0, 0);
end;


procedure THtmlSENDT1_2026.FindAddress;
var
  Flags: OLEVariant;
begin
  Flags := 0;
  UpdateCombo := True;
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;

procedure THtmlSENDT1_2026.StopClick(Sender: TObject);
begin
  WebBrowser1.Stop;
end;

procedure THtmlSENDT1_2026.URLsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    FindAddress;
  end;
end;

procedure THtmlSENDT1_2026.URLsClick(Sender: TObject);
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
procedure THtmlSENDT1_2026.RefreshClick(Sender: TObject);
begin
  FindAddress;
end;

procedure THtmlSENDT1_2026.BackClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex - 1];
  FindAddress;
end;

procedure THtmlSENDT1_2026.ForwardClick(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex + 1];
  FindAddress;
end;

procedure THtmlSENDT1_2026.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ssAlt] then
    if (Key = VK_RIGHT) and ForwardBtn.Enabled then
      ForwardBtn.Click
    else if (Key = VK_LEFT) and BackBtn.Enabled then
      BackBtn.Click;
end;

procedure THtmlSENDT1_2026.Toolbar3Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    Coolbar1.Visible := Checked;
  end;
end;

procedure THtmlSENDT1_2026.Statusbar2Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    Checked := not Checked;
    StatusBar1.Visible := Checked;
  end;
end;

procedure THtmlSENDT1_2026.HomePageRequest(var Message: TMessage);
Var AppDir:String;{with slash}
begin
  AppDir := ExtractFilePath(Application.ExeName); {where the Exe is}
  Urls.Text:= url;
  //coming from Unetfile 'http://www.netfile.gc.ca/pro';
  //Urls.Text:='http://www.pro.netfile.ccra-adrc.gc.ca/eol-splash-e.html';
  //URLs.Text := 'File://'+AppDir+'Index.Htm';
  {URLs.Text := 'www.visualTax.com';}
  FindAddress;
end;


procedure THtmlSENDT1_2026.FormDestroy(Sender: TObject);
begin
  HistoryList.Free;
end;

procedure THtmlSENDT1_2026.BackActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    BackAction.Enabled := HistoryIndex > 0
 else
    BackAction.Enabled := False;
end;

procedure THtmlSENDT1_2026.ForwardActionUpdate(Sender: TObject);
begin
  if HistoryList.Count > 0 then
    ForwardAction.Enabled := HistoryIndex < HistoryList.Count - 1
  else
    ForwardAction.Enabled := False;
end;

procedure THtmlSENDT1_2026.WebBrowser1BeforeNavigate2(Sender: TObject;
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

procedure THtmlSENDT1_2026.WebBrowser1DownloadBegin(Sender: TObject);
begin
  { Turn the stop button dark red }
  StopBtn.ImageIndex := 4;
end;

procedure THtmlSENDT1_2026.WebBrowser1DownloadComplete(Sender: TObject);
begin
  StopBtn.ImageIndex := 2;
end;

procedure THtmlSENDT1_2026.ExitProgramClick(Sender: TObject);
begin
Close;
end;

procedure THtmlSENDT1_2026.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
 ShowBrowserProperties;
(*
 If FillForm(WebBrowser1, 'EFILER', OnlineNo) then FillLogin;
 If FillForm(WebBrowser1, 'uploaded_file', FileName) then FillFileName;
 If FillForm(WebBrowser1, 'lsSinTtn', Sin) then FillSin;
 If FillForm(WebBrowser1, 'lsBirthDateTp', BirthDate) then FillBirthDate;
 If FillForm(WebBrowser1, 'lsGivenName', GivenName) then FillGivenName;
 If FillForm(WebBrowser1, 'lsSurname', Surname) then FillSurName;
*)

 If FillForm(WebBrowser1, 'lsIdentNbr', OnlineNo) then FillLogin;
 If FillForm(WebBrowser1, 'clientFile', FileName) then FillFileName;
 If FillForm(WebBrowser1, 'lsSinTtn', Sin) then FillSin;
 If FillForm(WebBrowser1, 'lsBirthDateTp', BirthDate) then FillBirthDate;
 If FillForm(WebBrowser1, 'lsGivenName', GivenName) then FillGivenName;
 If FillForm(WebBrowser1, 'lsSurname', Surname) then FillSurName;

end;

function THtmlSENDT1_2026.FillForm(WebBrowser: TWebBrowser; FieldName: string; Value: string): Boolean;
var
  i, j: Integer;
  FormItem: Variant;
begin
  Result := False;
  //count forms on document
  for I := 0 to WebBrowser.OleObject.Document.forms.Length - 1 do
  begin
    FormItem := WebBrowser.OleObject.Document.forms.Item(I);
    for j := 0 to FormItem.Length - 1 do
    begin
      try
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

procedure THtmlSENDT1_2026.WebBrowser1TitleChange(Sender: TObject;
  const Text: WideString);
begin
 ShowBrowserProperties;
end;

procedure THtmlSENDT1_2026.Print1Click(Sender: TObject);
var
  vaIn, vaOut: OleVariant; // Needed in all examples

Begin
  WebBrowser1.ControlInterface.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER,vaIn, vaOut);
end;
procedure THtmlSENDT1_2026.ShowBrowserProperties;
begin
 if Assigned(WebBrowser1.Document) then
 begin
  UrlLbl.Caption := Webbrowser1.OleObject.Document.Url;
  TitleLbl.Caption := Webbrowser1.OleObject.Document.title;
 end;
end;

procedure THtmlSENDT1_2026.FillLogin;
Var flags:OleVariant;NextUrl:WideString;
begin
 //20111210
// FillForm(WebBrowser1, 'EFILER', OnlineNo);
// FillForm(WebBrowser1, 'PASSWORD', Password);

 FillForm(WebBrowser1, 'lsIdentNbr', OnlineNo);
 FillForm(WebBrowser1, 'lsPassword', Password);

end;

procedure THtmlSENDT1_2026.FillFileName;
begin
 FillForm(WebBrowser1, 'clientFile', FileName);
end;

procedure THtmlSENDT1_2026.FillSin;
begin
 FillForm(WebBrowser1, 'lsSinTtn', Sin);
end;

procedure THtmlSENDT1_2026.FillBirthdate;
begin
 FillForm(WebBrowser1, 'lsBirthDateTp', BirthDate);
end;

procedure THtmlSENDT1_2026.FillGivenName;
begin
 FillForm(WebBrowser1, 'lsGivenName', GivenName);
end;

procedure THtmlSENDT1_2026.FillSurname;
begin
 FillForm(WebBrowser1, 'lsSurname', SurName);
end;


Function THtmlSENDT1_2026.GetAckFileNameFromHtml:String;
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
end;


function THtmlSENDT1_2026.GetHTMLCode(WebBrowser1: TWebBrowser; Var TempList: TStringList): Boolean;
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


end.
