Unit vtVirtualTaxOfficeColourSettings;

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DBCtrls,
  Vcl.Mask, vteditbox, vtLabel, vtShape, ShellApi, System.Generics.Collections,
  System.IOUtils, Data.DBXJSON, vtVirtualTaxOffice, Vcl.ComCtrls, Vcl.OleCtrls,
  SHDocVw, uCEFChromiumWindow, uCEFWinControl, uCEFChromium,
  uCEFTypes, uCEFInterfaces, uCEFStringMultimap, uCEFApplication,
  Vcl.Samples.Spin, Vcl.ExtDlgs;

type TShape = class(ExtCtrls.TShape) //20210303 Igor
  private
    FFillColor: string;
    function GetWebColor: string;
    procedure SetWebColor(const Value: string);
    function GetFillColor: string;
    procedure SetFillColor(const Value: string);
  public
    property WebColor: string read GetWebColor write SetWebColor;
    property FillColor: string read GetFillColor write SetFillColor;
end;

type TColorSetting = record
  TitleSmallColor: string;
  TitleColor: string;
  BackgroundColor: string;
  LeftPanelColor: string;
  RightPanelColor: string;
  ProjectorColor: string;
  FloorColor: string;
  GroutColor: string;
  LogoFileName: string;
  LogoMessage: string;
  CompanyName: string;
  LogoMessageColor: string;
  CompanyNameColor: string;
  //20210111 Igor >>>
  NameColor: string;
  OtherTextColor: string;
  LogoMessageSize: string;
  CompanyNameSize: string;
  NameSize: string;
  OtherTextSize: string;
  //20210111 Igor <<<
  BackgroundFileName: string;
  BackgroundRepeat: string;
  BorderColor: string;
  BorderWidth: string;
  //20210303 Igor >>>
  WallsWidth: string;
  CeilingColor: string;
  FloorMode: string;
  CeilingMode: string;
  LeftWallMode: string;
  RightWallMode: string;
  LeftBaseBoardColor: string;
  RightBaseBoardColor: string;
  //20210303 Igor <<<
  //20210304 Igor >>>
  LeftCrownColor: string;
  RightCrownColor: string;
  //20210304 Igor <<<
  SameWalls: string; //20210312 Igor
end;

type
  TvtVirtualTaxOfficeColourSettings = class(TForm)
    shHeader: TvtShape;
    vtLabel37: TvtLabel;
    pnlMain: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    gbTemplates: TGroupBox;
    pnlButtons: TPanel;
    lbTemplates: TListBox;
    lblTemplates: TLabel;
    lblLeftPanel: TLabel;
    LeftPanelColour: TShape;
    RightPanelColour: TShape;
    lblRightPanel: TLabel;
    FloorColour: TShape;
    lblFloor: TLabel;
    GroutColour: TShape;
    lblGrout: TLabel;
    LeftPanelColourBtn: TSpeedButton;
    SelectColorDialog: TColorDialog;
    RightPanelColourBtn: TSpeedButton;
    FloorColourBtn: TSpeedButton;
    GroutColourBtn: TSpeedButton;
    PreviewHtml: TMemo;
    CW: TChromiumWindow;
    TimerChromium: TTimer;
    lblTitleSmallColour: TLabel;
    TitleSmallColour: TShape;
    TitleSmallColourBtn: TSpeedButton;
    lblTitleColour: TLabel;
    TitleColour: TShape;
    TitleColourBtn: TSpeedButton;
    lblBackgroundColour: TLabel;
    BackgroundColour: TShape;
    BackgroundColourBtn: TSpeedButton;
    lblProjectorColour: TLabel;
    ProjectorColour: TShape;
    ProjectorColourBtn: TSpeedButton;
    lblBorderColour: TLabel;
    BorderColour: TShape;
    BorderColourBtn: TSpeedButton;
    BorderWidth: TSpinEdit;
    lblBorderWidth: TLabel;
    BackgroundFileName: TEdit;
    cbRepeat: TCheckBox;
    lblBackgroundFileName: TLabel;
    BackgroundFileNameBtn: TSpeedButton;
    lblLogoFileName: TLabel;
    LogoFileName: TEdit;
    LogoFileNameBtn: TSpeedButton;
    lblCompanyName: TLabel;
    CompanyName: TEdit;
    lblLogoMessage: TLabel;
    LogoMessage: TEdit;
    lblCompanyNameColour: TLabel;
    CompanyNameColour: TShape;
    CompanyNameColourBtn: TSpeedButton;
    lblLogoMessageColour: TLabel;
    LogoMessageColour: TShape;
    LogoMessageColourBtn: TSpeedButton;
    btnPreview: TButton;
    btnSaveAsTemplate: TButton;
    OpenImageDialog: TOpenPictureDialog;    
    lbCompanyNameSize: TLabel;
    CompanyNameSize: TSpinEdit;
    lbLogoMessageSize: TLabel;
    LogoMessageSize: TSpinEdit;
    lbNameColour: TLabel;
    NameColour: TShape;
    NameColourBtn: TSpeedButton;
    lbNameSize: TLabel;
    NameSize: TSpinEdit;
    lbOtherTextColour: TLabel;
    OtherTextColour: TShape;
    OtherTextColourBtn: TSpeedButton;
    lbOtherTextSize: TLabel;
    OtherTextSize: TSpinEdit;
    pgSettings: TPageControl;
    tabMain: TTabSheet;
    pnlSettings: TPanel;
    pnlPreviewBtn: TPanel;
    tabLeftWall: TTabSheet;
    tabRightWall: TTabSheet;
    tabFloor: TTabSheet;
    tabCeiling: TTabSheet;
    lbWallsWidth: TLabel;
    WallsWidth: TSpinEdit;
    lbCeiling: TLabel;
    CeilingColour: TShape;
    CeilingColourBtn: TSpeedButton;
    rgFloorMode: TRadioGroup;
    rgCeilingMode: TRadioGroup;
    ShowLeftWindow: TCheckBox;
    ShowLeftBaseBoard: TCheckBox;
    LeftBaseBoardColour: TShape;
    LeftBaseBoardColourBtn: TSpeedButton;
    lbLeftBaseBoardColour: TLabel;
    ShowRightWindow: TCheckBox;
    ShowRightBaseBoard: TCheckBox;
    lbRightBaseBoardColour: TLabel;
    RightBaseBoardColour: TShape;
    RightBaseBoardColourBtn: TSpeedButton;
    TimerSpinEditChange: TTimer;
    ShowLeftCrown: TCheckBox;
    lbLeftCrownColour: TLabel;
    LeftCrownColour: TShape;
    LeftCrownColourBtn: TSpeedButton;
    ShowRightCrown: TCheckBox;
    lbRightCrownColour: TLabel;
    RightCrownColour: TShape;
    RightCrownColourBtn: TSpeedButton;
    cbSameWalls: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FillColourBtnClick(Sender: TObject);
    procedure CWAfterCreated(Sender: TObject);
    procedure TimerChromiumTimer(Sender: TObject);
    procedure BorderWidthChange(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure BackgroundFileNameBtnClick(Sender: TObject);
    procedure cbRepeatClick(Sender: TObject);
    procedure btnSaveAsTemplateClick(Sender: TObject);
    procedure lbTemplatesClick(Sender: TObject);
    procedure lbTemplatesDblClick(Sender: TObject);
    //20210303 Igor >>>
    procedure ColourBtnClick(Sender: TObject);
    procedure TimerSpinEditChangeTimer(Sender: TObject);
    //20210303 Igor <<<
    procedure cbSameWallsClick(Sender: TObject); //20210312 Igor
  private
    { Private declarations }
    FTempFileName: string;
    FCurrTemplate: string;
    FShownTemplate: string;
    FSettings: TArray<TColorSetting>;
    SkipPreview: boolean;
    BaseUrl: string;
    //20210111 Igor >>>
    FBusinessName: string; //20210120 Igor
    FEmail: string;
    FPhone: string;
    FWebSite: string;
    FServices: string; //20210304 Igor
    procedure CEFLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
    procedure InitProfileValues;
    //20210111 Igor <<<
    //20210223 Igor >>>
    function GetFloorMode: string;
    procedure SetFloorMode(const Value: string);
    function GetCeilingMode: string;
    procedure SetCeilingMode(const Value: string);
    function GetLeftWallMode: string;
    procedure SetLeftWallMode(const Value: string);
    function GetRightWallMode: string;
    procedure SetRightWallMode(const Value: string);
    //20210223 Igor <<<
    procedure ChromiumCertificateError(Sender: TObject; const browser: ICefBrowser;
      certError: TCefErrorcode; const requestUrl: ustring; const sslInfo: ICefSslInfo;
      const callback: ICefRequestCallback; out Result: Boolean); //20220119 Igor
  public
    { Public declarations }
    procedure LoadColourSettings;
    function SaveCurrentColourSettings(ATemplateName: string = ''): boolean;

    procedure PreviewCurrentColours;
    //20210111 Igor >>>
    procedure PreviewColours(
      ATitleSmallColour, ATitleColour, ABackgroundColour,
      ALeftPanelColour, ARightPanelColour, AProjectorColour,
      AFloorColour, AGroutColour, ABorderColour, ABorderWidth, AWallsWidth, 
      ABackgroundFileName, ABackgroundRepeat,
      ALogoFileName, ACompanyName, ALogoMessage,
      ACompanyNameColour, ALogoMessageColour,
      ANameColour, AOtherTextColour,
      ACompanyNameSize, ALogoMessageSize,
      ANameSize, AOtherTextSize,
      ACeilingColour, AFloorMode, ACeilingMode, ALeftWallMode, ARightWallMode,
      ALeftBaseBoardColour, ARightBaseBoardColour, //20210303 Igor
      ALeftCrownColour, ARightCrownColour : string); //20210304 Igor
    //20210111 Igor <<<
    //20210223 Igor >>>
    property FloorMode: string read GetFloorMode write SetFloorMode;
    property CeilingMode: string read GetCeilingMode write SetCeilingMode;
    property LeftWallMode: string read GetLeftWallMode write SetLeftWallMode;
    property RightWallMode: string read GetRightWallMode write SetRightWallMode;
    //20210223 Igor <<<
  end;

  procedure EditVirtualTaxOfficeColourSettings;

implementation

{$R *.dfm}

Uses
  vtMulti, vtCommon, vtDialogs, vtMain, vtTrimStr, vtShared, vtDataBase,
  Variants, vtColorPatternSelect; //20210303 Igor

procedure EditVirtualTaxOfficeColourSettings;
var
  FVirtualTaxOfficePayer: TvtVirtualTaxOfficeColourSettings;
begin
  FVirtualTaxOfficePayer := TvtVirtualTaxOfficeColourSettings.Create(Application);
  try
    FVirtualTaxOfficePayer.ShowModal;
  finally
    FVirtualTaxOfficePayer.Free;
  end;
end;

{ TvtVirtualTaxOfficeColourSettings }

procedure TvtVirtualTaxOfficeColourSettings.BackgroundFileNameBtnClick(
  Sender: TObject);
var cFile: string;
begin
  cFile := '';
  if Sender = BackgroundFileNameBtn then
    cFile := BackgroundFileName.Text
  else if Sender = LogoFileNameBtn then
    cFile := LogoFileName.Text
  else
    Exit;
  if FileExists(cFile) then
    OpenImageDialog.FileName := cFile;
  if not OpenImageDialog.Execute then Exit;
  if Sender = BackgroundFileNameBtn then
    BackgroundFileName.Text := OpenImageDialog.FileName
  else if Sender = LogoFileNameBtn then
    LogoFileName.Text := OpenImageDialog.FileName;
  PreviewCurrentColours;
end;

procedure TvtVirtualTaxOfficeColourSettings.BorderWidthChange(Sender: TObject);
begin
  //20210303 Igor >>>
  TimerSpinEditChange.Enabled := false;
  TimerSpinEditChange.Enabled := true;
  //20210303 Igor <<<
end;

procedure TvtVirtualTaxOfficeColourSettings.btnPreviewClick(Sender: TObject);
begin
  PreviewCurrentColours;
end;

procedure TvtVirtualTaxOfficeColourSettings.btnSaveAsTemplateClick(
  Sender: TObject);
var cValue: string;
begin
  if UpperCase(InputBox('Please, enter password to save template', 'PSW', '')) <> 'IGOR' then exit; //20210312 Igor
  cValue := FCurrTemplate;
  while True do
  begin
    if not InputQuery('Save as template', 'Template name', cValue) then Exit;
    cValue := Trim(cValue);
    if cValue.IsEmpty then
      ShowMessageWarning('Template name cannot be empty')
    else
      break;
  end;
  FCurrTemplate := cValue;
  SaveCurrentColourSettings(FCurrTemplate);
  LoadColourSettings;
end;

procedure TvtVirtualTaxOfficeColourSettings.btnSaveClick(Sender: TObject);
begin
  if SaveCurrentColourSettings then
  begin
    ShowMessageInfo('Colour settings were successfully saved!');
    ModalResult := mrOk;
  end;
end;

procedure TvtVirtualTaxOfficeColourSettings.cbRepeatClick(Sender: TObject);
begin
  //20210312 Igor >>>
  if (cbSameWalls.Checked) then
  begin
    if Sender = ShowLeftWindow then
      ShowRightWindow.Checked := ShowLeftWindow.Checked
    else if Sender = ShowLeftBaseBoard then
      ShowRightBaseBoard.Checked := ShowLeftBaseBoard.Checked
    else if Sender = ShowLeftCrown then
      ShowRightCrown.Checked := ShowLeftCrown.Checked;
  end;
  //20210312 Igor <<<
  PreviewCurrentColours;
end;

procedure TvtVirtualTaxOfficeColourSettings.cbSameWallsClick(Sender: TObject); //20210312 Igor
begin
  RightPanelColourBtn.Enabled := not cbSameWalls.Checked;
  ShowRightWindow.Enabled := not cbSameWalls.Checked;
  ShowRightBaseBoard.Enabled := not cbSameWalls.Checked;
  ShowRightCrown.Enabled := not cbSameWalls.Checked;
  RightBaseBoardColourBtn.Enabled := not cbSameWalls.Checked;
  RightCrownColourBtn.Enabled := not cbSameWalls.Checked;
  if cbSameWalls.Checked then
  begin
    SkipPreview := true;
    try
      RightPanelColour.FillColor := LeftPanelColour.FillColor;
      ShowRightWindow.Checked := ShowLeftWindow.Checked;
      ShowRightBaseBoard.Checked := ShowLeftBaseBoard.Checked;
      ShowRightCrown.Checked := ShowLeftCrown.Checked;
      RightBaseBoardColour.WebColor := LeftBaseBoardColour.WebColor;
      RightCrownColour.WebColor := LeftCrownColour.WebColor;
    finally
      SkipPreview := false;
    end;
    PreviewCurrentColours;
  end;
end;

procedure TvtVirtualTaxOfficeColourSettings.CEFLoadEnd( //20210111 Igor
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
begin
  pnlMain.Width := pnlMain.Width - 1;
  pnlMain.Width := pnlMain.Width + 1;
end;

procedure TvtVirtualTaxOfficeColourSettings.ChromiumCertificateError( //20220119 Igor
  Sender: TObject; const browser: ICefBrowser; certError: TCefErrorcode;
  const requestUrl: ustring; const sslInfo: ICefSslInfo;
  const callback: ICefRequestCallback; out Result: Boolean);
begin
  Result := True;
  callback.Cont(True);
end;

procedure TvtVirtualTaxOfficeColourSettings.ColourBtnClick( //20210303 Igor
  Sender: TObject);
var FColor: TColor;
begin
  if Sender = TitleSmallColourBtn then
    FColor := TitleSmallColour.Brush.Color
  else if Sender = TitleColourBtn then
    FColor := TitleColour.Brush.Color
  else if Sender = BackgroundColourBtn then
    FColor := BackgroundColour.Brush.Color
  else if Sender = ProjectorColourBtn then
    FColor := ProjectorColour.Brush.Color
  else if Sender = GroutColourBtn then
    FColor := GroutColour.Brush.Color
  else if Sender = BorderColourBtn then
    FColor := BorderColour.Brush.Color
  else if Sender = CompanyNameColourBtn then
    FColor := CompanyNameColour.Brush.Color
  else if Sender = LogoMessageColourBtn then
    FColor := LogoMessageColour.Brush.Color
  else if Sender = NameColourBtn then
    FColor := NameColour.Brush.Color
  else if Sender = OtherTextColourBtn then
    FColor := OtherTextColour.Brush.Color
  else if Sender = LeftBaseBoardColourBtn then
    FColor := LeftBaseBoardColour.Brush.Color
  else if Sender = RightBaseBoardColourBtn then
    FColor := RightBaseBoardColour.Brush.Color
  //20210304 Igor >>>
  else if Sender = LeftCrownColourBtn then
    FColor := LeftCrownColour.Brush.Color
  else if Sender = RightCrownColourBtn then
    FColor := RightCrownColour.Brush.Color
  //20210304 Igor <<<
  else
    Exit;
  if not RunOnlyColorSelect(FColor) then Exit;
  if Sender = TitleSmallColourBtn then
    TitleSmallColour.Brush.Color := FColor
  else if Sender = TitleColourBtn then
    TitleColour.Brush.Color := FColor
  else if Sender = BackgroundColourBtn then
    BackgroundColour.Brush.Color := FColor
  else if Sender = ProjectorColourBtn then
    ProjectorColour.Brush.Color := FColor
  else if Sender = GroutColourBtn then
    GroutColour.Brush.Color := FColor
  else if Sender = BorderColourBtn then
    BorderColour.Brush.Color := FColor
  else if Sender = CompanyNameColourBtn then
    CompanyNameColour.Brush.Color := FColor
  else if Sender = LogoMessageColourBtn then
    LogoMessageColour.Brush.Color := FColor
  else if Sender = NameColourBtn then
    NameColour.Brush.Color := FColor
  else if Sender = OtherTextColourBtn then
    OtherTextColour.Brush.Color := FColor
  else if Sender = LeftBaseBoardColourBtn then
    LeftBaseBoardColour.Brush.Color := FColor
  else if Sender = RightBaseBoardColourBtn then
    RightBaseBoardColour.Brush.Color := FColor
  //20210304 Igor >>>
  else if Sender = LeftCrownColourBtn then
    LeftCrownColour.Brush.Color := FColor
  else if Sender = RightCrownColourBtn then
    RightCrownColour.Brush.Color := FColor;
  //20210304 Igor <<<
  //20210312 Igor >>>
  if cbSameWalls.Checked then
  begin
    if Sender = LeftBaseBoardColourBtn then
      RightBaseBoardColour.Brush.Color := LeftBaseBoardColour.Brush.Color
    else if Sender = LeftCrownColourBtn then
      RightCrownColour.Brush.Color := LeftCrownColour.Brush.Color;
  end;
  //20210312 Igor <<<
  PreviewCurrentColours;
end;

procedure TvtVirtualTaxOfficeColourSettings.CWAfterCreated(Sender: TObject);
begin
  PreviewCurrentColours;
end;

procedure TvtVirtualTaxOfficeColourSettings.FormShow(Sender: TObject);

  function GenerateTempFilename: String;
  var
    TempFile: array[0..MAX_PATH - 1] of Char;
    TempPath: array[0..MAX_PATH - 1] of Char;
  begin
    GetTempPath(MAX_PATH, TempPath);
    if GetTempFileName(TempPath, PChar('abc'), 0, TempFile) <> 0 then
      Result := TempFile
    else
      Result := '';
  end;

begin
  //20220119 Igor >>>
  FTempFileName := GenerateTempFilename + FormatDateTime('yyyymmddhhnnss', Now) + '.html';
  BaseUrl := ReplaceStr(ReplaceStr(VirtualTaxOfficeUrl, 'api.php', ''), 'https:', 'http:');
  //20220119 Igor <<<
  SkipPreview := false;
  FShownTemplate := '';
  pgSettings.ActivePageIndex := 0; //20210303 Igor
  InitProfileValues; //20210111 Igor

  CW.Align := alClient;
  CW.Visible := true;

  InitChromiumEngine; //20220704 Igor
  GlobalCEFApp.DisableWebSecurity := true;
  GlobalCEFApp.AllowFileAccessFromFiles := true;
  GlobalCEFApp.AllowUniversalAccessFromFileUrls := true;
  GlobalCEFApp.OnLoadEnd := CEFLoadEnd; //20210111 Igor

  TimerChromium.Enabled := True;

  LoadColourSettings;
  VirtualTaxOfficeInfo.LoadPatterns; //20210218 Igor //20210303 Igor
end;

function TvtVirtualTaxOfficeColourSettings.GetCeilingMode: string;//20210303 Igor
begin
  if rgCeilingMode.ItemIndex = 0 then
    Result := 'N'
  else if rgCeilingMode.ItemIndex = 2 then
    Result := 'P'
  else
    Result := 'F';
end;

function TvtVirtualTaxOfficeColourSettings.GetFloorMode: string;//20210303 Igor
begin
  if rgFloorMode.ItemIndex = 1 then
    Result := 'N'
  else
    Result := 'T';
end;

function TvtVirtualTaxOfficeColourSettings.GetLeftWallMode: string;//20210303 Igor
begin
  Result := '';
  if ShowLeftWindow.Checked then
    Result := Result + 'W';
  if ShowLeftBaseBoard.Checked then
    Result := Result + 'B';
  //20210304 Igor >>>
  if ShowLeftCrown.Checked then
    Result := Result + 'C';
  //20210304 Igor <<<
end;

function TvtVirtualTaxOfficeColourSettings.GetRightWallMode: string;//20210303 Igor
begin
  Result := '';
  if ShowRightWindow.Checked then
    Result := Result + 'W';
  if ShowRightBaseBoard.Checked then
    Result := Result + 'B';
  //20210304 Igor >>>
  if ShowRightCrown.Checked then
    Result := Result + 'C';
  //20210304 Igor <<<
end;

procedure TvtVirtualTaxOfficeColourSettings.InitProfileValues; //20210111 Igor
var FParams: TParamList;
    Res: TJSONObject;

    procedure AddServiceDiv(ACaption: string); //20210304 Igor
    begin
      FServices := FServices + '<div class="form-group wordwrap other_text">'+ ACaption +'</div>';
    end;

    procedure AddService(AName: string); //20210304 Igor
    begin
      if SameText(GetJSONValue(Res, AName), 'Y') then
        AddServiceDiv(AName);
    end;
begin
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'LOAD_PROFILE');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText( GetJSONValue(Res, 'success'), 'true') then
      begin
        FBusinessName := GetJSONValue(Res, 'BusinessName'); //20210120 Igor
        FEmail := GetJSONValue(Res, 'Email');
        FPhone := GetJSONValue(Res, 'Area') + ' ' + GetJSONValue(Res, 'Phone');
        FWebSite := GetJSONValue(Res, 'WebSiteUrl');
        //20210304 Igor >>>
        FServices := '';
        AddService('T1');
        AddService('T2');
        AddService('T3');
        AddService('T4T5');
        AddService('NR4');
        AddService('T3010');
        AddService('T5013');
        AddService('T5018');
        AddService('vtNOA');
        if not GetJSONValue(Res, 'OtherServiceDescription').IsEmpty then
          AddServiceDiv(GetJSONValue(Res, 'OtherServiceDescription'));
        if not GetJSONValue(Res, 'Experience').IsEmpty then
          AddServiceDiv(GetJSONValue(Res, 'Experience'));
        //20210304 Igor <<<
      end
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TvtVirtualTaxOfficeColourSettings.lbTemplatesClick(Sender: TObject);
begin
  if lbTemplates.Count = 0 then Exit;
  if lbTemplates.ItemIndex < 0 then Exit;
  if SameText(FShownTemplate, lbTemplates.Items[lbTemplates.ItemIndex]) then Exit;
  PreviewColours(
    FSettings[lbTemplates.ItemIndex].TitleSmallColor,
    FSettings[lbTemplates.ItemIndex].TitleColor,
    FSettings[lbTemplates.ItemIndex].BackgroundColor,
    FSettings[lbTemplates.ItemIndex].LeftPanelColor,
    FSettings[lbTemplates.ItemIndex].RightPanelColor,
    FSettings[lbTemplates.ItemIndex].ProjectorColor,
    FSettings[lbTemplates.ItemIndex].FloorColor,
    FSettings[lbTemplates.ItemIndex].GroutColor,
    FSettings[lbTemplates.ItemIndex].BorderColor,
    FSettings[lbTemplates.ItemIndex].BorderWidth,
    FSettings[lbTemplates.ItemIndex].WallsWidth, //20210303 Igor
    FSettings[lbTemplates.ItemIndex].BackgroundFileName,
    FSettings[lbTemplates.ItemIndex].BackgroundRepeat,
    FSettings[lbTemplates.ItemIndex].LogoFileName,
    FSettings[lbTemplates.ItemIndex].CompanyName,
    FSettings[lbTemplates.ItemIndex].LogoMessage,
    FSettings[lbTemplates.ItemIndex].CompanyNameColor,
    FSettings[lbTemplates.ItemIndex].LogoMessageColor,
    //20210111 Igor >>>
    FSettings[lbTemplates.ItemIndex].NameColor,
    FSettings[lbTemplates.ItemIndex].OtherTextColor,
    FSettings[lbTemplates.ItemIndex].CompanyNameSize,
    FSettings[lbTemplates.ItemIndex].LogoMessageSize,
    FSettings[lbTemplates.ItemIndex].NameSize,
    FSettings[lbTemplates.ItemIndex].OtherTextSize,
    //20210223 Igor >>>
    FSettings[lbTemplates.ItemIndex].CeilingColor,
    FSettings[lbTemplates.ItemIndex].FloorMode,
    FSettings[lbTemplates.ItemIndex].CeilingMode,
    FSettings[lbTemplates.ItemIndex].LeftWallMode,
    FSettings[lbTemplates.ItemIndex].RightWallMode,
    FSettings[lbTemplates.ItemIndex].LeftBaseBoardColor,
    FSettings[lbTemplates.ItemIndex].RightBaseBoardColor,
    //20210304 Igor >>>
    FSettings[lbTemplates.ItemIndex].LeftBaseBoardColor,
    FSettings[lbTemplates.ItemIndex].RightBaseBoardColor
    //20210304 Igor <<<
    );
    //20210223 Igor <<<
    //20210111 Igor <<<
  FShownTemplate := lbTemplates.Items[lbTemplates.ItemIndex];
  FCurrTemplate := lbTemplates.Items[lbTemplates.ItemIndex];
end;

procedure TvtVirtualTaxOfficeColourSettings.lbTemplatesDblClick( //20210303 Igor
  Sender: TObject);
begin
  if lbTemplates.Count = 0 then Exit;
  if lbTemplates.ItemIndex < 0 then Exit;
  if Assigned(Sender) then
    if MessageDlg('Are you sure you want to apply selected template ?', mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit;
  SkipPreview := true;
  try
    TitleSmallColour.WebColor := FSettings[lbTemplates.ItemIndex].TitleSmallColor;
    TitleColour.WebColor := FSettings[lbTemplates.ItemIndex].TitleColor;
    BackgroundColour.WebColor :=   FSettings[lbTemplates.ItemIndex].BackgroundColor;
    LeftPanelColour.FillColor :=   FSettings[lbTemplates.ItemIndex].LeftPanelColor;
    RightPanelColour.FillColor :=   FSettings[lbTemplates.ItemIndex].RightPanelColor;
    ProjectorColour.WebColor :=   FSettings[lbTemplates.ItemIndex].ProjectorColor;
    FloorColour.FillColor :=   FSettings[lbTemplates.ItemIndex].FloorColor;
    GroutColour.WebColor :=   FSettings[lbTemplates.ItemIndex].GroutColor;
    BorderColour.WebColor :=   FSettings[lbTemplates.ItemIndex].BorderColor;
    BorderWidth.Value := StrToIntDef(FSettings[lbTemplates.ItemIndex].BorderWidth, 0);
    WallsWidth.Value := StrToIntDef(FSettings[lbTemplates.ItemIndex].WallsWidth, 240);
    BackgroundFileName.Text := FSettings[lbTemplates.ItemIndex].BackgroundFileName;
    cbRepeat.Checked := SameText(FSettings[lbTemplates.ItemIndex].BackgroundRepeat, 'Y');
    LogoFileName.Text := FSettings[lbTemplates.ItemIndex].LogoFileName;
    CompanyName.Text := FSettings[lbTemplates.ItemIndex].CompanyName;
    LogoMessage.Text := FSettings[lbTemplates.ItemIndex].LogoMessage;
    CompanyNameColour.WebColor := FSettings[lbTemplates.ItemIndex].CompanyNameColor;
    LogoMessageColour.WebColor := FSettings[lbTemplates.ItemIndex].LogoMessageColor;
    //20210111 Igor >>>
    NameColour.WebColor := FSettings[lbTemplates.ItemIndex].NameColor;
    OtherTextColour.WebColor := FSettings[lbTemplates.ItemIndex].OtherTextColor;
    CompanyNameSize.Value := StrToIntDef(FSettings[lbTemplates.ItemIndex].CompanyNameSize, 0);
    LogoMessageSize.Value := StrToIntDef(FSettings[lbTemplates.ItemIndex].LogoMessageSize, 0);
    NameSize.Value := StrToIntDef(FSettings[lbTemplates.ItemIndex].NameSize, 0);
    OtherTextSize.Value := StrToIntDef(FSettings[lbTemplates.ItemIndex].OtherTextSize, 0);
    //20210111 Igor <<<
    //20210223 Igor >>>
    CeilingColour.FillColor :=  FSettings[lbTemplates.ItemIndex].CeilingColor;
    FloorMode := FSettings[lbTemplates.ItemIndex].FloorMode;
    CeilingMode := FSettings[lbTemplates.ItemIndex].CeilingMode;
    LeftWallMode := FSettings[lbTemplates.ItemIndex].LeftWallMode;
    RightWallMode := FSettings[lbTemplates.ItemIndex].RightWallMode;
    LeftBaseBoardColour.WebColor := FSettings[lbTemplates.ItemIndex].LeftBaseBoardColor;
    RightBaseBoardColour.WebColor := FSettings[lbTemplates.ItemIndex].RightBaseBoardColor;
    //20210223 Igor <<<
    //20210304 Igor >>>
    LeftCrownColour.WebColor := FSettings[lbTemplates.ItemIndex].LeftCrownColor;
    RightCrownColour.WebColor := FSettings[lbTemplates.ItemIndex].RightCrownColor;
    //20210304 Igor <<<
    cbSameWalls.Checked := SameText(FSettings[lbTemplates.ItemIndex].SameWalls, 'Y'); //20210312 Igor
  finally
    SkipPreview := false;
  end;

  PreviewCurrentColours;
end;

procedure TvtVirtualTaxOfficeColourSettings.LoadColourSettings;
var FParams: TParamList;
    Res, Row: TJSONObject;
    Values: TJSONArray;
    ArrayElement: TJSONValue;
    I: integer;
begin
  SetLength(FSettings, 0);
  lbTemplates.Clear;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'LIST_COLOR_TEMPLATES');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText( GetJSONValue(Res, 'success'), 'true') then
      begin
        Values := TJSONArray(Res.Get('result').JSONValue);
        if Assigned(Values) then
        begin
          for ArrayElement in Values do
            if Assigned(ArrayElement) then
            begin
              Row := TJSONObject(ArrayElement);
              lbTemplates.Items.Add(GetJSONValue(Row, 'Caption'));
              SetLength(FSettings, Length(FSettings) + 1);
              I := Length(FSettings) - 1;
              FSettings[I].TitleSmallColor := GetJSONValue(Row, 'TitleSmallColor');
              FSettings[I].TitleColor := GetJSONValue(Row, 'TitleColor');
              FSettings[I].BackgroundColor := GetJSONValue(Row, 'BackgroundColor');
              FSettings[I].LeftPanelColor := GetJSONValue(Row, 'LeftPanelColor');
              FSettings[I].RightPanelColor := GetJSONValue(Row, 'RightPanelColor');
              FSettings[I].ProjectorColor := GetJSONValue(Row, 'ProjectorColor');
              FSettings[I].FloorColor := GetJSONValue(Row, 'FloorColor');
              FSettings[I].GroutColor := GetJSONValue(Row, 'GroutColor');
              FSettings[I].LogoFileName := GetJSONValue(Row, 'LogoFileName');
              FSettings[I].LogoMessage := GetJSONValue(Row, 'LogoMessage');
              FSettings[I].CompanyName := GetJSONValue(Row, 'CompanyName');
              FSettings[I].LogoMessageColor := GetJSONValue(Row, 'LogoMessageColor');
              FSettings[I].CompanyNameColor := GetJSONValue(Row, 'CompanyNameColor');
              //20210111 Igor >>>
              FSettings[I].NameColor := GetJSONValue(Row, 'NameColor');
              FSettings[I].OtherTextColor := GetJSONValue(Row, 'OtherTextColor');
              FSettings[I].LogoMessageSize := GetJSONValue(Row, 'LogoMessageSize');
              FSettings[I].CompanyNameSize := GetJSONValue(Row, 'CompanyNameSize');
              FSettings[I].NameSize := GetJSONValue(Row, 'NameSize');
              FSettings[I].OtherTextSize := GetJSONValue(Row, 'OtherTextSize');
              //20210111 Igor <<<
              FSettings[I].BackgroundFileName := GetJSONValue(Row, 'BackgroundFileName');
              FSettings[I].BackgroundRepeat := GetJSONValue(Row, 'BackgroundRepeat');
              FSettings[I].BorderColor := GetJSONValue(Row, 'BorderColor');
              FSettings[I].BorderWidth := GetJSONValue(Row, 'BorderWidth');
              //20210303 Igor >>>
              FSettings[I].WallsWidth := GetJSONValue(Row, 'WallsWidth');
              FSettings[I].CeilingColor := GetJSONValue(Row, 'CeilingColor');
              FSettings[I].FloorMode := GetJSONValue(Row, 'FloorMode');
              FSettings[I].CeilingMode := GetJSONValue(Row, 'CeilingMode');
              FSettings[I].LeftWallMode := GetJSONValue(Row, 'LeftWallMode');
              FSettings[I].RightWallMode := GetJSONValue(Row, 'RightWallMode');
              FSettings[I].LeftBaseBoardColor := GetJSONValue(Row, 'LeftBaseBoardColor');
              FSettings[I].RightBaseBoardColor := GetJSONValue(Row, 'RightBaseBoardColor');
              //20210303 Igor <<<
              //20210304 Igor >>>
              FSettings[I].LeftCrownColor := GetJSONValue(Row, 'LeftCrownColor');
              FSettings[I].RightCrownColor := GetJSONValue(Row, 'RightCrownColor');
              //20210304 Igor <<<
              FSettings[I].SameWalls := GetJSONValue(Row, 'SameWalls'); //20210312 Igor
            end;
        end;
      end
      else
        ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TvtVirtualTaxOfficeColourSettings.PreviewColours(
      ATitleSmallColour, ATitleColour, ABackgroundColour,
      ALeftPanelColour, ARightPanelColour, AProjectorColour,
      AFloorColour, AGroutColour, ABorderColour, ABorderWidth, AWallsWidth,
      ABackgroundFileName, ABackgroundRepeat,
      ALogoFileName, ACompanyName, ALogoMessage,
      ACompanyNameColour, ALogoMessageColour,
      //20210111 Igor >>>
      ANameColour, AOtherTextColour,
      ACompanyNameSize, ALogoMessageSize,
      ANameSize, AOtherTextSize,
      //20210223 Igor >>>
      ACeilingColour, AFloorMode, ACeilingMode, ALeftWallMode, ARightWallMode,
      ALeftBaseBoardColour, ARightBaseBoardColour,
      ALeftCrownColour, ARightCrownColour : string); //20210304 Igor
      //20210223 Igor <<<
      //20210111 Igor <<<
var HTML: string;
    Doc: Variant;

    function GetStyle(AValue: string): string; //20210223 Igor
    begin
      if AValue.StartsWith('#') then
        Result := 'background-color: '+ AValue + ';'
      else
        Result := 'background-image: url('+ QuotedStr(BaseUrl + AValue) +'); background-repeat: repeat;';
    end;

    function GetContrastColor(AColor: TColor): string; //20210303 Igor  //20210304 Igor
    begin
      if (0.299 * GetRValue(AColor) + 0.587 * GetGValue(AColor) + 0.114 * GetBValue(AColor)) / 255 > 0.5 then
        Result := 'rgba(0, 0, 0, 0.7)'
      else
        Result := 'rgba(255, 255, 255, 0.7)';
    end;

    function AddUrlIfNeeded(AValue: string): string; //20210303 Igor
    begin
      Result := AValue;
      if not Result.StartsWith('#') and not Result.IsEmpty  then
        Result := BaseUrl + AValue;
    end;

begin
  if SkipPreview then Exit;
  if not ABackgroundFileName.IsEmpty and not SameText(Copy(ABackgroundFileName, 1, 4), 'http') then
    ABackgroundFileName := 'file://' + ABackgroundFileName.Replace('\', '/');
  if not ALogoFileName.IsEmpty and not SameText(Copy(ALogoFileName, 1, 4), 'http') then
    ALogoFileName := 'file://' + ALogoFileName.Replace('\', '/');

  //20210303 Igor >>>
  HTML := PreviewHtml.Text;
  HTML := ReplaceStr(HTML, '%URL%', BaseUrl);
  HTML := ReplaceStr(HTML, '%TITLE_SMALL_COLOR%', ATitleSmallColour);
  HTML := ReplaceStr(HTML, '%TITLE_COLOR%', ATitleColour);
  HTML := ReplaceStr(HTML, '%BACKGROUND_COLOR%', ABackgroundColour);
  HTML := ReplaceStr(HTML, '%LEFT_PANEL_COLOR%', AddUrlIfNeeded(ALeftPanelColour));
  HTML := ReplaceStr(HTML, '%LEFT_PANEL_COLOR_STYLE%', GetStyle(ALeftPanelColour));
  HTML := ReplaceStr(HTML, '%RIGHT_PANEL_COLOR%', AddUrlIfNeeded(ARightPanelColour));
  HTML := ReplaceStr(HTML, '%RIGHT_PANEL_COLOR_STYLE%', GetStyle(ARightPanelColour));
  HTML := ReplaceStr(HTML, '%PROJECTOR_COLOR%', AProjectorColour);
  HTML := ReplaceStr(HTML, '%FLOOR_COLOR%', AddUrlIfNeeded(AFloorColour));
  HTML := ReplaceStr(HTML, '%FLOOR_COLOR_STYLE%', GetStyle(AFloorColour));
  HTML := ReplaceStr(HTML, '%GROUT_COLOR%', AGroutColour);
  HTML := ReplaceStr(HTML, '%BORDER_COLOR%', ABorderColour);
  HTML := ReplaceStr(HTML, '%BORDER_WIDTH%', ABorderWidth);
  HTML := ReplaceStr(HTML, '%WALLS_WIDTH%', AWallsWidth);
  HTML := ReplaceStr(HTML, '%BORDER%', ABorderWidth + 'px solid ' + ABorderColour);
  HTML := ReplaceStr(HTML, '%BACKGROUND_FILENAME%', ABackgroundFileName);
  //20210303 Igor <<<
  if SameText(ABackgroundRepeat, 'Y') then
  begin
    HTML := ReplaceStr(HTML, '%BACKGROUND_REPEAT%', 'repeat');
    HTML := ReplaceStr(HTML, '%BACKGROUND_SIZE%', 'auto');
  end
  else
  begin
    HTML := ReplaceStr(HTML, '%BACKGROUND_REPEAT%', 'no-repeat');
    HTML := ReplaceStr(HTML, '%BACKGROUND_SIZE%', '100% 100%');
  end;
  HTML := ReplaceStr(HTML, '%LOGO_FILENAME%', ALogoFileName);
  HTML := ReplaceStr(HTML, '%COMPANY_NAME%', ACompanyName);
  HTML := ReplaceStr(HTML, '%LOGO_MESSAGE%', ALogoMessage);
  HTML := ReplaceStr(HTML, '%COMPANY_NAME_COLOR%', ACompanyNameColour);
  HTML := ReplaceStr(HTML, '%LOGO_MESSAGE_COLOR%', ALogoMessageColour);
  //20210111 Igor >>>
  HTML := ReplaceStr(HTML, '%NAME_COLOR%', ANameColour);
  HTML := ReplaceStr(HTML, '%OTHER_TEXT_COLOR%', AOtherTextColour);
  HTML := ReplaceStr(HTML, '%COMPANY_NAME_SIZE%', ACompanyNameSize);
  HTML := ReplaceStr(HTML, '%LOGO_MESSAGE_SIZE%', ALogoMessageSize);
  HTML := ReplaceStr(HTML, '%NAME_SIZE%', ANameSize);
  HTML := ReplaceStr(HTML, '%OTHER_TEXT_SIZE%', AOtherTextSize);
  HTML := ReplaceStr(HTML, '%VERSION%', ReplaceStr(ReplaceStr(ReplaceStr(DateTimeToStr(Now), ':', '_'), '/', '_'), ' ', '_'));
  HTML := ReplaceStr(HTML, '%VIRTUALID%', VirtualTaxOfficeInfo.CyberId);
  HTML := ReplaceStr(HTML, '%EMAIL%', FEmail);
  HTML := ReplaceStr(HTML, '%PHONE%', FPhone);
  HTML := ReplaceStr(HTML, '%WEBSITE%', FWebSite);
  HTML := ReplaceStr(HTML, '%BUSINESS_NAME%', FBusinessName); //20210120 Igor
  HTML := ReplaceStr(HTML, '%SERVICES%', FServices); //20210304 Igor
  //20210111 Igor <<<
  //20210223 Igor >>>
  HTML := ReplaceStr(HTML, '%CEILING_COLOR%', AddUrlIfNeeded(ACeilingColour));
  HTML := ReplaceStr(HTML, '%CEILING_COLOR_STYLE%', GetStyle(ACeilingColour));
  HTML := ReplaceStr(HTML, '%FLOOR_MODE%', AFloorMode);
  HTML := ReplaceStr(HTML, '%CEILING_MODE%', ACeilingMode);
  HTML := ReplaceStr(HTML, '%LEFT_WALL_MODE%', ALeftWallMode);
  HTML := ReplaceStr(HTML, '%RIGHT_WALL_MODE%', ARightWallMode);
  HTML := ReplaceStr(HTML, '%LEFT_BASEBOARD_COLOR%', ALeftBaseBoardColour);
  HTML := ReplaceStr(HTML, '%RIGHT_BASEBOARD_COLOR%', ARightBaseBoardColour);
  HTML := ReplaceStr(HTML, '%LOGO_MESSAGE_CONTRAST_COLOR%', GetContrastColor(WebToTColor(ALogoMessageColour))); //20210304 Igor
  if ALeftWallMode.Contains('B') then
    HTML := ReplaceStr(HTML, '%LEFT_BASEBOARD_DISPLAY%', 'block')
  else
    HTML := ReplaceStr(HTML, '%LEFT_BASEBOARD_DISPLAY%', 'none');
  if ARightWallMode.Contains('B') then
    HTML := ReplaceStr(HTML, '%RIGHT_BASEBOARD_DISPLAY%', 'block')
  else
    HTML := ReplaceStr(HTML, '%RIGHT_BASEBOARD_DISPLAY%', 'none');
  //20210304 Igor >>>
  HTML := ReplaceStr(HTML, '%LEFT_CROWN_COLOR%', ALeftCrownColour);
  HTML := ReplaceStr(HTML, '%RIGHT_CROWN_COLOR%', ARightCrownColour);
  if ALeftWallMode.Contains('C') then
    HTML := ReplaceStr(HTML, '%LEFT_CROWN_DISPLAY%', 'block')
  else
    HTML := ReplaceStr(HTML, '%LEFT_CROWN_DISPLAY%', 'none;');
  if ARightWallMode.Contains('C') then
    HTML := ReplaceStr(HTML, '%RIGHT_CROWN_DISPLAY%', 'block')
  else
    HTML := ReplaceStr(HTML, '%RIGHT_CROWN_DISPLAY%', 'none;');
  //20210304 Igor <<<

  //20210223 Igor <<<


  with TStringList.Create do
  try
    Text := HTML;
    SaveToFile(FTempFileName);
  finally
    Free;
  end;

  //CW.ChromiumBrowser.LoadString(HTML);
  CW.LoadURL(FTempFileName);
end;

procedure TvtVirtualTaxOfficeColourSettings.PreviewCurrentColours;
var cRepeat: string;
begin
  if cbRepeat.Checked then
    cRepeat := 'Y'
  else
    cRepeat := 'N';
  //20210303 Igor >>>
  PreviewColours(
    TitleSmallColour.WebColor,
    TitleColour.WebColor,
    BackgroundColour.WebColor,
    LeftPanelColour.FillColor,
    RightPanelColour.FillColor,
    ProjectorColour.WebColor,
    FloorColour.FillColor,
    GroutColour.WebColor,
    BorderColour.WebColor,
    '1',//IntToStr(BorderWidth.Value), //20220321 Igor
    IntToStr(WallsWidth.Value),
    BackgroundFileName.Text,
    cRepeat,
    LogoFileName.Text,
    CompanyName.Text,
    LogoMessage.Text,
    CompanyNameColour.WebColor,
    LogoMessageColour.WebColor,
    //20210111 Igor >>>
    NameColour.WebColor,
    OtherTextColour.WebColor,
    IntToStr(CompanyNameSize.Value),
    IntToStr(LogoMessageSize.Value),
    IntToStr(NameSize.Value),
    IntToStr(OtherTextSize.Value),
    //20210223 Igor >>>
    CeilingColour.FillColor,
    FloorMode,
    CeilingMode,
    LeftWallMode,
    RightWallMode,
    LeftBaseBoardColour.WebColor,
    RightBaseBoardColour.WebColor,
    //20210304 Igor >>>
    LeftCrownColour.WebColor,
    RightCrownColour.WebColor);
    //20210304 Igor <<<
    //20210223 Igor <<<
    //20210111 Igor <<<
  //20210303 Igor <<<    
  FShownTemplate := '';
end;

function TvtVirtualTaxOfficeColourSettings.SaveCurrentColourSettings(ATemplateName: string): boolean; //20210303 Igor
var FParams, FFiles: TParamList;
    Res: TJSONObject;
begin
  Result := false;
  FParams := TParamList.Create;
  FFiles := TParamList.Create;
  try
    FParams.AddParam('action', 'SAVE_COLOR_SETTINGS');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    if ATemplateName.IsEmpty then
      FParams.AddParam('IsTemplate', 'false')
    else
      FParams.AddParam('IsTemplate', 'true');
    FParams.AddParam('Caption', ATemplateName);
    FParams.AddParam('TitleSmallColor', TitleSmallColour.WebColor);
    FParams.AddParam('TitleColor', TitleColour.WebColor);
    FParams.AddParam('BackgroundColor', BackgroundColour.WebColor);
    FParams.AddParam('LeftPanelColor', LeftPanelColour.FillColor);
    FParams.AddParam('RightPanelColor', RightPanelColour.FillColor);
    FParams.AddParam('ProjectorColor', ProjectorColour.WebColor);
    FParams.AddParam('FloorColor', FloorColour.FillColor);
    FParams.AddParam('GroutColor', GroutColour.WebColor);
    FParams.AddParam('LogoFileName', LogoFileName.Text);
    FParams.AddParam('LogoMessage', LogoMessage.Text);
    FParams.AddParam('CompanyName', CompanyName.Text);
    FParams.AddParam('LogoMessageColor', LogoMessageColour.WebColor);
    FParams.AddParam('CompanyNameColor', CompanyNameColour.WebColor);
    //20210111 Igor >>>
    FParams.AddParam('NameColor', NameColour.WebColor);
    FParams.AddParam('OtherTextColor', OtherTextColour.WebColor);
    FParams.AddParam('LogoMessageSize', IntToStr(LogoMessageSize.Value));
    FParams.AddParam('CompanyNameSize', IntToStr(CompanyNameSize.Value));
    FParams.AddParam('NameSize', IntToStr(NameSize.Value));
    FParams.AddParam('OtherTextSize', IntToStr(OtherTextSize.Value));
    //20210111 Igor <<<
    FParams.AddParam('BackgroundFileName', BackgroundFileName.Text);
    if cbRepeat.Checked then
      FParams.AddParam('BackgroundRepeat', 'Y')
    else
      FParams.AddParam('BackgroundRepeat', 'N');
    FParams.AddParam('BorderColor', BorderColour.WebColor);
    FParams.AddParam('BorderWidth', IntToStr(BorderWidth.Value));
    FParams.AddParam('WallsWidth', IntToStr(WallsWidth.Value));
    //20210223 Igor >>>
    FParams.AddParam('CeilingColor', CeilingColour.FillColor);
    FParams.AddParam('FloorMode', FloorMode);
    FParams.AddParam('CeilingMode', CeilingMode);
    FParams.AddParam('LeftWallMode', LeftWallMode);
    FParams.AddParam('RightWallMode', RightWallMode);
    FParams.AddParam('LeftBaseBoardColor', LeftBaseBoardColour.WebColor);
    FParams.AddParam('RightBaseBoardColor', RightBaseBoardColour.WebColor);
    //20210223 Igor <<<
    //20210304 Igor >>>
    FParams.AddParam('LeftCrownColor', LeftCrownColour.WebColor);
    FParams.AddParam('RightCrownColor', RightCrownColour.WebColor);
    //20210304 Igor <<<
    //20210312 Igor >>>
    FParams.AddParam('RightCrownColor', RightCrownColour.WebColor);
    if cbSameWalls.Checked then
      FParams.AddParam('SameWalls', 'Y')
    else
      FParams.AddParam('SameWalls', 'N');
    //20210312 Igor <<<
    if not String(LogoFileName.Text).IsEmpty then
      if not SameText(Copy(LogoFileName.Text, 1, 4), 'http') then
        FFiles.AddParam('LogoFile', LogoFileName.Text);
    if not String(BackgroundFileName.Text).IsEmpty then
      if not SameText(Copy(BackgroundFileName.Text, 1, 4), 'http') then
        FFiles.AddParam('BackgroundFile', BackgroundFileName.Text);

    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtFiles,false, FFiles);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        Result := true
      else
        ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
    end;
  finally
    FParams.Free;
    FFiles.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
  LoadColourSettings;
end;

procedure TvtVirtualTaxOfficeColourSettings.SetCeilingMode(const Value: string);//20210303 Igor
begin
  if SameText(Value, 'N') then
    rgCeilingMode.ItemIndex := 0
  else if SameText(Value, 'P') then
    rgCeilingMode.ItemIndex := 2
  else
    rgCeilingMode.ItemIndex := 1;
end;

procedure TvtVirtualTaxOfficeColourSettings.SetFloorMode(const Value: string);//20210303 Igor
begin
  if SameText(Value, 'T') then
    rgFloorMode.ItemIndex := 0
  else
    rgFloorMode.ItemIndex := 1;
end;

procedure TvtVirtualTaxOfficeColourSettings.SetLeftWallMode(//20210303 Igor
  const Value: string);
begin
  ShowLeftWindow.Checked := Value.Contains('W');
  ShowLeftBaseBoard.Checked := Value.Contains('B');
  ShowLeftCrown.Checked := Value.Contains('C'); //20210304 Igor
end;

procedure TvtVirtualTaxOfficeColourSettings.SetRightWallMode(//20210303 Igor
  const Value: string);
begin
  ShowRightWindow.Checked := Value.Contains('W');
  ShowRightBaseBoard.Checked := Value.Contains('B');
  ShowRightCrown.Checked := Value.Contains('C'); //20210304 Igor
end;

procedure TvtVirtualTaxOfficeColourSettings.TimerChromiumTimer(Sender: TObject);
begin
  TimerChromium.Enabled := False;
  if not (CW.CreateBrowser) and not (CW.Initialized) then
    TimerChromium.Enabled := True
  else
  begin
    CW.ChromiumBrowser.OnCertificateError := ChromiumCertificateError; //20220119 igor
    if lbTemplates.Count > 0 then
    begin
      lbTemplates.ItemIndex := 0;
      lbTemplatesDblClick(nil);
    end;
  end;
end;

procedure TvtVirtualTaxOfficeColourSettings.TimerSpinEditChangeTimer(//20210303 Igor
  Sender: TObject);
begin
  TimerSpinEditChange.Enabled := false;
  PreviewCurrentColours;
end;

procedure TvtVirtualTaxOfficeColourSettings.FillColourBtnClick(Sender: TObject);//20210303 Igor
var FValue: string;
begin
  if Sender = LeftPanelColourBtn then
    FValue := LeftPanelColour.FillColor
  else if Sender = RightPanelColourBtn then
    FValue := RightPanelColour.FillColor
  else if Sender = FloorColourBtn then
    FValue := FloorColour.FillColor
  else if Sender = CeilingColourBtn then
    FValue := CeilingColour.FillColor
  else
    Exit;
  if not RunColorPatternSelect(FValue) then Exit;
  if Sender = LeftPanelColourBtn then
    LeftPanelColour.FillColor := FValue
  else if Sender = RightPanelColourBtn then
    RightPanelColour.FillColor := FValue
  else if Sender = FloorColourBtn then
    FloorColour.FillColor := FValue
  else if Sender = CeilingColourBtn then
    CeilingColour.FillColor := FValue;
  //20210312 Igor >>>
  if cbSameWalls.Checked then
  begin
    if Sender = LeftPanelColourBtn then
      RightPanelColour.FillColor := LeftPanelColour.FillColor;
  end;
  //20210312 Igor <<<
  PreviewCurrentColours;
end;

{ TShape }

function TShape.GetFillColor: string;//20210303 Igor
begin
  Result := FFillColor;
end;

function TShape.GetWebColor: string;
begin
  Result := TColorToWeb(Brush.Color);
end;

procedure TShape.SetFillColor(const Value: string);//20210303 Igor
begin
  if Value.StartsWith('#') then
  begin
    Brush.Bitmap := nil;
    Brush.Color := WebToTColor(Value);
  end
  else
    Brush.Bitmap := VirtualTaxOfficeInfo.FindPatternByFileName(Value);
  FFillColor := Value;
end;

procedure TShape.SetWebColor(const Value: string);
begin
  Brush.Color := WebToTColor(Value);
end;

end.
