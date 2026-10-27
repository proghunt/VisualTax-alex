unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  {$IFDEF  MSWINDOWS}
  WinApi.Windows,
  {$ENDIF}
  {$IFDEF ANDROID}
  Posix.Stdio, Posix.Unistd, uToast,
  {$ENDIF}
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.WebBrowser,
  System.Actions, FMX.ActnList, FMX.Edit, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.ListBox, System.Generics.Collections, CloudHelperAbstr, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.DBScope, FMX.Gestures, FMX.Platform, FMX.Memo,
  FMX.ScrollBox, IdComponent, FMX.VirtualKeyboard, FMX.Styles, FMX.Menus,
  FMX.Objects;

type
  TState = (asWelcome, asClients, asDocuments, asDocument, asSettings,
    asStartUpdate, asStartUpdateLogin, asStartDownloadHeaders, asStartDownload,
    asSaveToken, asRewriteDataBase);

  TAppState = set of TState;

  TStatePair = class(TObject)
  private
    FBackState: TState;
    FForwardState: TState;
    procedure SetBackState(const Value: TState);
    procedure SetForwardState(const Value: TState);
  public
    constructor Create(AForwardState, ABackState: TState);
    property ForwardState: TState read FForwardState write SetForwardState;
    property BackState: TState read FBackState write SetBackState;
  end;

  TStateList = class(TObjectList<TStatePair>)
  private
    function GetBackState: TState;
    function GetForwardState: TState;
  public
    property ForwardState: TState read GetForwardState;
    property BackState: TState read GetBackState;
    procedure ClearIfNeed(AState: TState);
  end;

  TfrmMain = class(TForm)
    tcMain: TTabControl;
    tabWelcome: TTabItem;
    tabSettings: TTabItem;
    tabWork: TTabItem;
    pnlHead: TPanel;
    lblVisualTax: TLabel;
    lblMobileEdition: TLabel;
    btnStart: TButton;
    alMain: TActionList;
    actStart: TAction;
    wbNews: TWebBrowser;
    GridPanelLayout1: TGridPanelLayout;
    Label1: TLabel;
    chbSettingSkipWelcomePage: TCheckBox;
    Label2: TLabel;
    edSettingClientID: TEdit;
    Label3: TLabel;
    edSettingToken: TEdit;
    Label4: TLabel;
    edSettingCloudPath: TEdit;
    Label5: TLabel;
    chbSettingSaveAutorization: TCheckBox;
    btnSettingsSave: TButton;
    actSettingsSave: TAction;
    actSettingsCancel: TAction;
    btnSettingsCancel: TButton;
    btnUseDefaultClientID: TButton;
    btnAutorizeNow: TButton;
    actUseDefaultClientID: TAction;
    actAutorizeNow: TAction;
    tcWork: TTabControl;
    tabWorkClients: TTabItem;
    tabWorkDocuments: TTabItem;
    lvClients: TListView;
    lblUpdateUnStart: TLabel;
    chbUpdateOnStart: TCheckBox;
    tabUpdate: TTabItem;
    AniIndicator1: TAniIndicator;
    tcUpdate: TTabControl;
    tabUpdateLogin: TTabItem;
    tabUpdateSelectDataBase: TTabItem;
    tabUpdateFinish: TTabItem;
    wbUpdateLogin: TWebBrowser;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    lblCloudHelper: TLabel;
    cbCloudHelper: TComboBox;
    Panel2: TPanel;
    Button2: TButton;
    actCancelAuthorize: TAction;
    actSettings: TAction;
    lblNoDBInCloud: TLabel;
    pnlUpdateSelectDB: TPanel;
    btnUpdateSelectDBBack: TButton;
    btnUpdateSelectDBNext: TButton;
    lvCloudFiles: TListView;
    pnlUpdateFinish: TPanel;
    btnUpdateFinishCancel: TButton;
    btnUpdateFinishNext: TButton;
    bsClients: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    lvDocuments: TListView;
    bsDocuments: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    btnBack: TButton;
    actBack: TAction;
    GridPanelLayout2: TGridPanelLayout;
    GridPanelLayout3: TGridPanelLayout;
    GridPanelLayout4: TGridPanelLayout;
    GridPanelLayout5: TGridPanelLayout;
    btnUpdateDBNow: TButton;
    actUpdateDBNow: TAction;
    mmoDownloadLog: TMemo;
    GridPanelLayout6: TGridPanelLayout;
    btnUpdateProgram: TButton;
    actUpdateProgram: TAction;
    pbDownLoad: TProgressBar;
    tabWorkHTMLView: TTabItem;
    wbHTMLView: TWebBrowser;
    GestureManager1: TGestureManager;
    cbStyle: TComboBox;
    lblStyle: TLabel;
    StyleBookMain: TStyleBook;
    Image1: TImage;
    procedure actStartExecute(Sender: TObject);
    procedure actSettingsSaveExecute(Sender: TObject);
    procedure actSettingsCancelExecute(Sender: TObject);
    procedure actUseDefaultClientIDExecute(Sender: TObject);
    procedure actAutorizeNowExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure wbUpdateLoginDidFinishLoad(ASender: TObject);
    procedure wbUpdateLoginShouldStartLoadWithRequest(ASender: TObject;
      const URL: string);
    procedure actCancelAuthorizeExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnUpdateSelectDBBackClick(Sender: TObject);
    procedure btnUpdateSelectDBNextClick(Sender: TObject);
    procedure btnUpdateFinishCancelClick(Sender: TObject);
    procedure btnUpdateFinishNextClick(Sender: TObject);
    procedure lvClientsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure actBackExecute(Sender: TObject);
    procedure alMainUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure lvDocumentsItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure actUpdateDBNowExecute(Sender: TObject);
    procedure actUpdateProgramExecute(Sender: TObject);
    procedure edSettingTokenTap(Sender: TObject; const Point: TPointF);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure cbStyleChange(Sender: TObject);
  private
    { Private declarations }
    AppState: TAppState;
    WorkToken: String;
    WorkDownloadFile: TCloudFile;
    FCloudFiles: TCloudFileList;
    FStateList: TStateList;
    TryUpdateOnStart: Boolean;
    FCurrentStyleName: String;
    procedure DownloadCallBackLog(const AMessage: String);
    procedure AppOnIdle(Sender: TObject; var Done: boolean);
    procedure DoWelcome;
    procedure DoShowClients;
    procedure DoShowDocuments;
    procedure DoShowSettings;
    procedure DoUpdate;
    procedure DoStartUpdate;
    procedure CraftToken;
    procedure DoStartDownLoadHeaders;
    procedure DoStartDownLoad;
    procedure DoStartRewriteDataBase;
    procedure CheckToken(AURL: String);
    function ActiveTabToState: TState;
    procedure idWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure idWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure idWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure OnException(const AException: String);
    procedure InplaceView(const AFileName: String; var ADone: Boolean);
    procedure ApplayStyle(AStyleName: String = '');
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  DataModule;

{$R *.fmx}

procedure TfrmMain.actAutorizeNowExecute(Sender: TObject);
begin
  FStateList.Add(TStatePair.Create(asSaveToken, asSettings));
  Include(AppState, asStartUpdateLogin);
end;

procedure TfrmMain.actBackExecute(Sender: TObject);
begin
  if tcWork.ActiveTab = tabWorkHTMLView then
    tcWork.ActiveTab := tabWorkDocuments
  else
  if tcWork.ActiveTab = tabWorkDocuments then
    tcWork.ActiveTab := tabWorkClients;
end;

procedure TfrmMain.actCancelAuthorizeExecute(Sender: TObject);
begin
  wbUpdateLogin.Stop;
  Include(AppState, FStateList.BackState);
end;

function TfrmMain.ActiveTabToState: TState;
begin
  if tcMain.ActiveTab = tabWelcome then
    Result := asWelcome
  else
  if tcMain.ActiveTab = tabSettings then
    Result := asSettings
  else
  if tcMain.ActiveTab = tabWork then
  begin
    if tcWork.ActiveTab = tabWorkClients then
      Result := asClients
    else
    if tcWork.ActiveTab = tabWorkDocuments then
      Result := asDocuments
    else
      Result := asClients
  end
  else
  if tcMain.ActiveTab = tabUpdate then
  begin
    if tcUpdate.ActiveTab = tabUpdateLogin then
      Result := asStartUpdateLogin
    else
    if tcUpdate.ActiveTab = tabUpdateSelectDataBase then
      Result := asStartDownloadHeaders
    else
    if tcUpdate.ActiveTab = tabUpdateFinish then
      Result := asStartDownload
    else
      Result := asStartUpdateLogin
  end
  else
    Result := asWelcome;
end;

procedure TfrmMain.actSettingsCancelExecute(Sender: TObject);
begin
  ApplayStyle;
  Include(AppState, FStateList.BackState);
end;

procedure TfrmMain.actSettingsExecute(Sender: TObject);
var
  S: TState;
begin
  if tcMain.ActiveTab = tabSettings then
    Exit;
  S := ActiveTabToState;
  FStateList.Add(TStatePair.Create(S, S));
  DoShowSettings;
end;

procedure TfrmMain.actSettingsSaveExecute(Sender: TObject);
begin
  dmMain.Settings.BeginUpdate;
  try
    dmMain.Settings.SkipWelcome := chbSettingSkipWelcomePage.IsChecked;
    dmMain.Settings.ClientID := edSettingClientID.Text;
    dmMain.Settings.Token := edSettingToken.Text;
    dmMain.Settings.CloudPath := edSettingCloudPath.Text;
    dmMain.Settings.SaveToken := chbSettingSaveAutorization.IsChecked;
    dmMain.Settings.UpdateOnStart := chbUpdateOnStart.IsChecked;
    dmMain.Settings.CloudHelperClass := dmMain.GetCloudHelperClass(chbUpdateOnStart.Text);
    dmMain.UpdateCloudHelperClass(dmMain.Settings.CloudHelperClass);
    if cbStyle.Selected <> nil then
      dmMain.Settings.Style := cbStyle.Selected.Text
    else
      dmMain.Settings.Style := '';
  finally
    dmMain.Settings.EndUpdate;
  end;
  Include(AppState, FStateList.ForwardState);
end;

procedure TfrmMain.actStartExecute(Sender: TObject);
begin
  Include(AppState, asClients);
end;

procedure TfrmMain.actUpdateDBNowExecute(Sender: TObject);
begin
  FStateList.Add(TStatePair.Create(asSettings, asSettings));
  Include(AppState, asStartUpdate);
end;

procedure TfrmMain.actUpdateProgramExecute(Sender: TObject);
begin
  dmMain.UpdateProgramm(idWork, idWorkBegin, idWorkEnd, OnException);
end;

procedure TfrmMain.idWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
Begin
  pbDownLoad.Value := 0;
  pbDownLoad.Max := AWorkCountMax;
  pbDownLoad.Visible := True;
  AniIndicator1.Visible := True;
  AniIndicator1.BringToFront;
  AniIndicator1.Enabled := True;
  Application.ProcessMessages;
  actUpdateProgram.Enabled := False;
End;

procedure TfrmMain.idWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
Begin
  pbDownLoad.Visible := False;
  AniIndicator1.Visible := False;
  actUpdateProgram.Enabled := True;
  Application.ProcessMessages;
End;

procedure TfrmMain.InplaceView(const AFileName: String; var ADone: Boolean);
begin
  if SameText(ExtractFileExt(AFileName), '.html') then
  Begin
    ADone := True;
    tcWork.ActiveTab := tabWorkHTMLView;
    wbHTMLView.Navigate('file:///'+AFileName);
  End;
end;

procedure TfrmMain.idWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
Begin
  pbDownLoad.Value := AWorkCount;
  Application.ProcessMessages;
End;

procedure TfrmMain.actUseDefaultClientIDExecute(Sender: TObject);
begin
  if cbCloudHelper.Selected = nil then
    Exit;
  if dmMain.GetCloudHelperClass(cbCloudHelper.Selected.Text) = nil then
    Exit;
  MessageDlg('Use default Client ID from VisualTax?', TMsgDlgType.mtConfirmation,
             [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
              procedure(const AResult: TModalResult)
              begin
                if AResult <> mrYes then
                  Exit;
                edSettingClientID.Text :=  dmMain.GetCloudHelperClass(cbCloudHelper.Selected.Text).DefaultClientID;
              end);
end;

procedure TfrmMain.alMainUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  actBack.Visible := (tcMain.ActiveTab = tabWork) and
                     ((tcWork.ActiveTab = tabWorkDocuments) or
                      (tcWork.ActiveTab = tabWorkHTMLView));
  actBack.Enabled := actBack.Visible;
end;

procedure TfrmMain.ApplayStyle(AStyleName: String);
var
  StyleFile: String;
begin
  if AStyleName = '' then
    AStyleName := dmMain.Settings.Style;
  if SameText(AStyleName, FCurrentStyleName) then
    exit;
  AniIndicator1.Visible := True;
  AniIndicator1.Enabled := True;
  try
    FCurrentStyleName := AStyleName;
    if SameText(c_DefaultStyle, AStyleName) then
      TStyleManager.SetStyle(nil)
    else
    begin
      StyleFile := dmMain.StyleFileName(AStyleName);
      if (StyleFile = '') or not FileExists(StyleFile) then
        TStyleManager.SetStyle(nil)
      else
        TStyleManager.SetStyleFromFile(StyleFile);
    end;
  finally
    AniIndicator1.Visible := False;
    AniIndicator1.Enabled := False;
  end;
end;

procedure TfrmMain.AppOnIdle(Sender: TObject; var Done: boolean);
begin
  if asWelcome in AppState then
  begin
    Exclude(AppState, asWelcome);
    FStateList.ClearIfNeed(asWelcome);
    if dmMain.Settings.FirstStart then
    begin
      FStateList.Add(TStatePair.Create(asWelcome, asWelcome));
      DoShowSettings;
    end
    else
    if not FileExists(dmMain.DataBase) or
       (dmMain.Settings.UpdateOnStart AND Not TryUpdateOnStart) then
    begin
      FStateList.Add(TStatePair.Create(asClients, asWelcome));
      DoUpdate;
    end
    else
    if dmMain.Settings.SkipWelcome then
      DoShowClients
    else
      DoWelcome;
  end
  else
  if asStartUpdate in AppState then
  begin
    Exclude(AppState, asStartUpdate);
    FStateList.ClearIfNeed(asStartUpdate);
    DoStartUpdate;
  end
  else
  if asStartUpdateLogin in AppState then
  begin
    Exclude(AppState, asStartUpdateLogin);
    FStateList.ClearIfNeed(asStartUpdateLogin);
    CraftToken;
  end
  else
  if asStartDownloadHeaders in AppState then
  begin
    Exclude(AppState, asStartDownloadHeaders);
    FStateList.ClearIfNeed(asStartDownloadHeaders);
    DoStartDownLoadHeaders;
  end
  else
  if asStartDownload in AppState then
  begin
    Exclude(AppState, asStartDownload);
    FStateList.ClearIfNeed(asStartDownload);
    DoStartDownLoad;
  end
  else
  if asRewriteDataBase in AppState then
  begin
    Exclude(AppState, asRewriteDataBase);
    FStateList.ClearIfNeed(asRewriteDataBase);
    DoStartRewriteDataBase;
  end
  else
  if asSettings in AppState then
  begin
    Exclude(AppState, asSettings);
    FStateList.ClearIfNeed(asSettings);
    tcMain.ActiveTab := tabSettings;
  end
  else
  if asSaveToken in AppState then
  begin
    Exclude(AppState, asSaveToken);
    FStateList.ClearIfNeed(asSaveToken);
    tcMain.ActiveTab := tabSettings;
    edSettingToken.Text := WorkToken;
  end
  else
  if asClients in AppState then
  begin
    Exclude(AppState, asClients);
    FStateList.ClearIfNeed(asClients);
    DoShowClients;
  end
  else
  if asDocuments in AppState then
  begin
    Exclude(AppState, asDocuments);
    FStateList.ClearIfNeed(asDocuments);
    DoShowDocuments;
  end;
end;

procedure TfrmMain.btnUpdateFinishCancelClick(Sender: TObject);
begin
  Include(AppState, FStateList.BackState);
end;

procedure TfrmMain.btnUpdateFinishNextClick(Sender: TObject);
begin
  Include(AppState, FStateList.ForwardState);
end;

procedure TfrmMain.btnUpdateSelectDBBackClick(Sender: TObject);
begin
  Include(AppState, FStateList.BackState);
end;

procedure TfrmMain.btnUpdateSelectDBNextClick(Sender: TObject);
begin
  WorkDownloadFile := FCloudFiles[lvCloudFiles.Selected.Index];
  FStateList.Add(TStatePair.Create(FStateList.ForwardState, asStartDownloadHeaders));
  Include(AppState, asStartDownload);
end;

procedure TfrmMain.cbStyleChange(Sender: TObject);
begin
  if cbStyle.Selected <> nil then
    ApplayStyle(cbStyle.Selected.Text)
  else
    ApplayStyle(c_DefaultStyle);
end;

procedure TfrmMain.CraftToken;
begin
  tcMain.ActiveTab := tabUpdate;
  tcUpdate.ActiveTab := tabUpdateLogin;

  wbUpdateLogin.CanFocus := TRUE;
  wbUpdateLogin.Navigate(dmMain.Settings.CloudHelperClass.AuthorizationURL(dmMain.Settings.ClientID));
  wbUpdateLogin.SetFocus;
end;

procedure TfrmMain.DoShowClients;
begin
  tcMain.ActiveTab := tabWork;
  tcWork.ActiveTab := tabWorkClients;
  dmMain.Connect;
end;

procedure TfrmMain.DoShowDocuments;
begin
  tcMain.ActiveTab := tabWork;
  tcWork.ActiveTab := tabWorkDocuments;
  dmMain.qryDocuments.Close;
  dmMain.qryDocuments.Open;
end;

procedure TfrmMain.DoShowSettings;
begin
  chbSettingSkipWelcomePage.IsChecked := dmMain.Settings.SkipWelcome;
  edSettingClientID.Text := dmMain.Settings.ClientID;
  edSettingToken.Text := dmMain.Settings.Token;
  edSettingCloudPath.Text := dmMain.Settings.CloudPath;
  chbSettingSaveAutorization.IsChecked := dmMain.Settings.SaveToken;
  chbUpdateOnStart.IsChecked := dmMain.Settings.UpdateOnStart;
  tcMain.ActiveTab := tabSettings;
  if dmMain.Settings.CloudHelperClass <> nil then
    cbCloudHelper.ItemIndex := cbCloudHelper.Items.IndexOf(dmMain.Settings.CloudHelperClass.HelperName);
  actSettingsCancel.Enabled := FileExists(dmMain.Settings.FileName);
  cbStyle.ItemIndex := cbStyle.Items.IndexOf(dmMain.Settings.Style);
  if cbStyle.ItemIndex  = -1 then
    cbStyle.ItemIndex := cbStyle.Items.IndexOf(c_DefaultStyle);
end;

procedure TfrmMain.DoStartDownLoad;
begin
  tcMain.ActiveTab := tabUpdate;
  tcUpdate.ActiveTab := tabUpdateFinish;
  AniIndicator1.Visible := True;
  AniIndicator1.BringToFront;
  AniIndicator1.Enabled := True;
  mmoDownloadLog.Lines.Clear;
  dmMain.CloudHelper.GetFile(WorkToken, dmMain.Settings.ClientID, WorkDownloadFile,
    procedure (const AErrorMessage: string; const AFile: TStream)
    var
      fs: TFileStream;
    begin
      tcMain.ActiveTab := tabUpdate;
      tcUpdate.ActiveTab := tabUpdateFinish;
      AniIndicator1.Visible := False;
      AniIndicator1.Enabled := False;
      if AErrorMessage <> '' then
      begin
        DownloadCallBackLog(AErrorMessage);
        {$IFDEF ANDROID}
        Toast(AErrorMessage, LongToast);
        {$ENDIF}
        {$IFDEF MSWINDOWS}
        MessageDlg(AErrorMessage, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
        {$ENDIF}
        pnlUpdateFinish.Visible := True;
        btnUpdateFinishCancel.Visible := True;
        btnUpdateFinishNext.Visible := False;
      end
      else
      begin
        DownloadCallBackLog('Start update DataBase');
        if AFile <> nil then
        begin
          fs := TFileStream.Create(dmMain.DataBase + '.new', fmCreate);
          try
            fs.CopyFrom(AFile, 0);
          finally
            fs.Free;
          end;
          Include(AppState, asRewriteDataBase);
        end;
      end;
    end,
    DownloadCallBackLog);
end;

procedure TfrmMain.DoStartDownLoadHeaders;
begin
  TryUpdateOnStart := True;
  wbUpdateLogin.Stop;
  pnlUpdateSelectDB.Visible := False;
  lblNoDBInCloud.Visible := False;
  lvCloudFiles.Visible := False;
  tcMain.ActiveTab := tabUpdate;
  tcUpdate.ActiveTab := tabUpdateSelectDataBase;
  AniIndicator1.Visible := True;
  AniIndicator1.BringToFront;
  AniIndicator1.Enabled := True;

  dmMain.CloudHelper.GetDataBaseHeaders(WorkToken, dmMain.Settings.ClientID, dmMain.Settings.CloudPath, c_DataBase,
    procedure (const AErrorMessage: string; const AList: TCloudFileList)
    var
      I: Integer;
    begin
      tcMain.ActiveTab := tabUpdate;
      tcUpdate.ActiveTab := tabUpdateSelectDataBase;
      AniIndicator1.Visible := False;
      AniIndicator1.Enabled := False;
      if AErrorMessage <> '' then
      begin
        {$IFDEF ANDROID}
        Toast(AErrorMessage, LongToast);
        {$ENDIF}
        {$IFDEF MSWINDOWS}
        MessageDlg(AErrorMessage, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
        {$ENDIF}
        pnlUpdateSelectDB.Visible := True;
        btnUpdateSelectDBBack.Visible := True;
        btnUpdateSelectDBNext.Visible := False;
      end;

      if Length(AList) = 0 then
      begin
        pnlUpdateSelectDB.Visible := True;
        btnUpdateSelectDBBack.Visible := True;
        btnUpdateSelectDBNext.Visible := False;
      end
      else
      begin
        FCloudFiles := AList;
        lvCloudFiles.Items.Clear;
        for I := Low(AList) to High(AList) do
        begin
          with lvCloudFiles.Items.Add do
          begin
            Text := AList[I].Path;
            Detail := //AList[I].FullPath +
              '(Update: ' + DateTimeToStr(AList[I].ServerModified) +
              '; Size: ' + IntToStr(AList[I].Size div 1024) + 'Kb)';
          end;
        end;
        lvCloudFiles.ItemIndex := 0;
        lvCloudFiles.Visible := True;
        pnlUpdateSelectDB.Visible := True;
        btnUpdateSelectDBBack.Visible := True;
        btnUpdateSelectDBNext.Visible := True;
      end;
    end);
end;

procedure TfrmMain.DoStartRewriteDataBase;
begin
  if System.SysUtils.FileExists(dmMain.DataBase+'.new') then
  begin
    DownloadCallBackLog('Disconnect');
    dmMain.Disconnect;
    if System.SysUtils.FileExists(dmMain.DataBase) then
    begin
      DownloadCallBackLog('Backup database');
      System.SysUtils.RenameFile(dmMain.DataBase, dmMain.DataBase + '.old');
    end;
    DownloadCallBackLog('Write new database');
    System.SysUtils.RenameFile(dmMain.DataBase+'.new', dmMain.DataBase);
    DownloadCallBackLog('Connect');
    if dmMain.Connect then
    begin
      if System.SysUtils.FileExists(dmMain.DataBase + '.old') then
        System.SysUtils.DeleteFile(dmMain.DataBase + '.old');
      DownloadCallBackLog('Done');
      DownloadCallBackLog('Goto ' + IntToStr(Integer(FStateList.ForwardState)));
      Include(AppState, FStateList.ForwardState);
    end
    else
    begin
      DownloadCallBackLog('Connect failed');
      System.SysUtils.DeleteFile(dmMain.DataBase);
      if System.SysUtils.FileExists(dmMain.DataBase + '.old') then
      begin
        DownloadCallBackLog('Restore database');
        System.SysUtils.RenameFile(dmMain.DataBase+'.old', dmMain.DataBase);
      end;
      DownloadCallBackLog('Connect to old database');
      if not dmMain.Connect then
        System.SysUtils.DeleteFile(dmMain.DataBase);
      DownloadCallBackLog('Start update');
      Include(AppState, asStartDownloadHeaders);
    end;
  end;
end;

procedure TfrmMain.DoStartUpdate;
begin
  if dmMain.Settings.Token = '' then
  begin
    FStateList.Add(TStatePair.Create(asStartDownloadHeaders, FStateList.BackState));
    Include(AppState, asStartUpdateLogin);
  end
  else
  begin
    WorkToken := dmMain.Settings.Token;
    Include(AppState, asStartDownloadHeaders);
  end;
end;

procedure TfrmMain.DoUpdate;
begin
  tcMain.ActiveTab := tabUpdate;
  Include(AppState, asStartUpdate);
end;

procedure TfrmMain.DoWelcome;
begin
  tcMain.ActiveTab := tabWelcome;
  wbNews.URL := vtAlerthtml;
  wbNews.Navigate;
end;

procedure TfrmMain.DownloadCallBackLog(const AMessage: String);
begin
  mmoDownloadLog.Lines.Add(AMessage);
end;

procedure TfrmMain.edSettingTokenTap(Sender: TObject; const Point: TPointF);
begin
{$IFDEF DEBUG}
  (Sender as TEdit).Text := 'yloZG8R_9oAAAAAAAAABo9uiWuBc3HQqykPekI-p95_58EtQ-QwonsMh_HvvwbTE';
{$ENDIF DEBUG}
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  c: TObject;
//  ScreenService: IFMXScreenService;
//  OrientSet: TScreenOrientations;
begin
//  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
//  begin
//    OrientSet := [TScreenOrientation.Portrait,TScreenOrientation.Landscape];
//    ScreenService.SetScreenOrientation(OrientSet);
//  end;
  AppState := [];
  FStateList := TStateList.Create(true);
  for c in Self do
    if C is TTabControl then
      (C as TTabControl).TabPosition := TTabPosition.None;
  TryUpdateOnStart := False;
  {$IFDEF MSWINDOWS}
  with Screen.DisplayFromForm(Self) do
    Self.SetBounds((WorkareaRect.Width - 800) div 2, (WorkareaRect.Height - 600) div 2, 800, 600);
  {$ENDIF}
  tcMain.ActiveTab := tabWelcome;
  Application.OnIdle := AppOnIdle;

  Include(AppState, asWelcome);
  dmMain.FillStyles(cbStyle.Items);
  dmMain.FillCloudHelpers(cbCloudHelper.Items);

  if dmMain.Settings.Style <> '' then
    ApplayStyle;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FStateList);
end;

procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
{$IFDEF ANDROID}
var
  FService : IFMXVirtualKeyboardService;
{$ENDIF}
begin
{$IFDEF ANDROID}
  if Key <> vkHardwareBack then
    exit;
  TPlatformServices.Current.SupportsPlatformService(
    IFMXVirtualKeyboardService, IInterface(FService));
  if (FService <> nil) and
     (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
    exit;
  if tcMain.ActiveTab = tabWelcome then
    exit;
  Key := 0;
  if actBack.Enabled then
    actBack.Execute
  else
    Include(AppState, FStateList.BackState);
{$ENDIF}
end;

procedure TfrmMain.lvDocumentsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  dmMain.ShowDocument(InplaceView);
end;

procedure TfrmMain.lvClientsItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  Include(AppState, asDocuments);
end;

procedure TfrmMain.OnException(const AException: String);
begin
  {$IFDEF ANDROID}
  Toast(AException, LongToast);
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  MessageDlg(AException, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
  {$ENDIF}
  idWorkEnd(nil, wmRead);
end;

procedure TfrmMain.CheckToken(AURL: String);
var
  lToken: string;
begin
  lToken := '';
  if dmMain.CloudHelper.GetToken(AURL, lToken) then
  begin
    if dmMain.Settings.SaveToken then
      dmMain.Settings.Token := lToken;
    WorkToken := lToken;
    Include(appState, FStateList.ForwardState);
  end;
end;

procedure TfrmMain.wbUpdateLoginDidFinishLoad(ASender: TObject);
begin
  CheckToken(wbUpdateLogin.URL);
end;

procedure TfrmMain.wbUpdateLoginShouldStartLoadWithRequest(ASender: TObject;
  const URL: string);
begin
  CheckToken(URL);
end;

{ TStatePair }

constructor TStatePair.Create(AForwardState, ABackState: TState);
begin
  inherited Create;
  FForwardState := AForwardState;
  FBackState := ABackState
end;

procedure TStatePair.SetBackState(const Value: TState);
begin
  FBackState := Value;
end;

procedure TStatePair.SetForwardState(const Value: TState);
begin
  FForwardState := Value;
end;

{ TStateList }

procedure TStateList.ClearIfNeed(AState: TState);
begin
  while Count > 0 do
    if (Items[Count - 1].BackState = AState) or
        (Items[Count - 1].ForwardState = AState) then
      Remove(Items[Count - 1])
    else
      Break;
end;

function TStateList.GetBackState: TState;
begin
  if Count > 0 then
    Result := Items[Count - 1].BackState
  else
    Result := asWelcome;
end;

function TStateList.GetForwardState: TState;
begin
  if Count > 0 then
    Result := Items[Count - 1].ForwardState
  else
    Result := asWelcome;
end;

end.
