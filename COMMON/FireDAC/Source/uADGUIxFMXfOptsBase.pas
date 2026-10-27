{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{          FireDAC FireMonkey Base dialog form          }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxFMXfOptsBase;

interface

uses
  Classes, IniFiles, UITypes,
{$IFDEF AnyDAC_FPC}
  FMX_Controls, FMX_Forms, FMX_ExtCtrls, FMX_Types, FMX_Objects, FMX_Edit, 
    FMX_ListBox, FMX_Dialogs
{$ELSE}
  FMX.Controls, FMX.Forms, FMX.ExtCtrls, FMX.Types, FMX.Objects, FMX.Edit,
    FMX.ListBox, FMX.Dialogs
  {$IFDEF AnyDAC_D18}
    , FMX.StdCtrls
  {$ENDIF}
{$ENDIF}
  ;

type
  TfrmADGUIxFMXOptsBase = class(TForm)
    pnlTop: TPanel;
    Image2: TImage;
    lblPrompt: TLabel;
    pnlButtons: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    pnlAlign: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FShown: Boolean;
{$IFNDEF AnyDAC_D17}
    FOnShow: TNotifyEvent;
    FOnHide: TNotifyEvent;
    procedure DoShow;
    procedure DoHide;
{$ENDIF}
  protected
    FCentered: Boolean;
    procedure LoadFormState(AIni: TCustomIniFile); virtual;
    procedure SaveFormState(AIni: TCustomIniFile); virtual;
  public
    procedure LoadState;
    procedure SaveState;
{$IFNDEF AnyDAC_D17}
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
{$ENDIF}
  end;

  procedure ADGUIxFMXCancel;
  function ADGUIxFMXBeginModal(AForm: TCustomForm; ASaveActive: Boolean = True): Pointer;
  procedure ADGUIxFMXEndModal(var AData: Pointer);
  function ADGUIxFMXSetupEditor(ACombo: TComboBox; AEdit: TEdit;
    AFileEdt: TCustomEdit; AOpenDlg: TOpenDialog; const AType: String): Integer;

implementation

{$IFNDEF AnyDAC_FPC}
{$R *.fmx}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
{$IFDEF MSWINDOWS}
  Messages, Windows, Registry,
{$ENDIF}
  uADStanConst, uADStanUtil;

{$IFDEF MSWINDOWS}
type
  PTaskWindow = ^TTaskWindow;
  TTaskWindow = record
    Next: PTaskWindow;
    Window: hwnd;
  end;

var
  TaskActiveWindow: HWND = 0;
  TaskFirstWindow: HWND = 0;
  TaskFirstTopMost: HWND = 0;
  TaskWindowList: PTaskWindow = nil;

{-------------------------------------------------------------------------------}
function DoDisableWindow(Window: hwnd; Data: Longint): bool; stdcall;
var
  P: PTaskWindow;
begin
  if (Window <> TaskActiveWindow) and IsWindowVisible(Window) and IsWindowEnabled(Window) then
  begin
    New(P);
    P^.Next := TaskWindowList;
    P^.Window := Window;
    TaskWindowList := P;
    EnableWindow(Window, False);
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure EnableTaskWindows(WindowList: Pointer);
var
  P: PTaskWindow;
begin
  while WindowList <> nil do
  begin
    P := WindowList;
    if IsWindow(P^.Window) then
      EnableWindow(P^.Window, True);
    WindowList := P^.Next;
    Dispose(P);
  end;
end;

{-------------------------------------------------------------------------------}
function DisableTaskWindows(ActiveWindow: HWND): Pointer;
var
  SaveActiveWindow: hwnd;
  SaveWindowList: Pointer;
begin
  Result := nil;
  SaveActiveWindow := TaskActiveWindow;
  SaveWindowList := TaskWindowList;
  TaskActiveWindow := ActiveWindow;
  TaskWindowList := nil;
  try
    try
      EnumThreadWindows(GetCurrentThreadID, @DoDisableWindow, 0);
      Result := TaskWindowList;
    except
      EnableTaskWindows(TaskWindowList);
      raise;
    end;
  finally
    TaskWindowList := SaveWindowList;
    TaskActiveWindow := SaveActiveWindow;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure ADGUIxFMXCancel;
begin
{$IFDEF MSWINDOWS}
  if GetCapture <> 0 then
    SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  ReleaseCapture;
{$ENDIF}
end;

{$IFDEF MSWINDOWS}
type
  TADGUIxFMXModalData = class(TObject)
    FWindowList: Pointer;
    FActiveWindow: HWnd;
  end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function ADGUIxFMXBeginModal(AForm: TCustomForm; ASaveActive: Boolean = True): Pointer;
{$IFDEF MSWINDOWS}
var
  oData: TADGUIxFMXModalData;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  Result := TADGUIxFMXModalData.Create;
  oData := TADGUIxFMXModalData(Result);
  oData.FWindowList := DisableTaskWindows(0);
  if ASaveActive then
    oData.FActiveWindow := GetActiveWindow
  else
    oData.FActiveWindow := 0;
{$ELSE}
  Result := nil;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure ADGUIxFMXEndModal(var AData: Pointer);
{$IFDEF MSWINDOWS}
var
  oData: TADGUIxFMXModalData;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  oData := TADGUIxFMXModalData(AData);
  EnableTaskWindows(oData.FWindowList);
  if oData.FActiveWindow <> 0 then
    SetActiveWindow(oData.FActiveWindow);
  ADFree(oData);
{$ENDIF}
  AData := nil;
end;

{-------------------------------------------------------------------------------}
function ADGUIxFMXSetupEditor(ACombo: TComboBox; AEdit: TEdit;
  AFileEdt: TCustomEdit; AOpenDlg: TOpenDialog; const AType: String): Integer;
var
  i: Integer;
begin
  Result := 1;
  if AType = '@L' then begin
    ACombo.Items.BeginUpdate;
    try
      ACombo.Items.Clear;
      ACombo.Items.Add(S_AD_True);
      ACombo.Items.Add(S_AD_False);
    finally
      ACombo.Items.EndUpdate;
    end;
    ACombo.ItemIndex := 1;
  end
  else if AType = '@Y' then begin
    ACombo.Items.BeginUpdate;
    try
      ACombo.Items.Clear;
      ACombo.Items.Add(S_AD_Yes);
      ACombo.Items.Add(S_AD_No);
    finally
      ACombo.Items.EndUpdate;
    end;
    ACombo.ItemIndex := 1;
  end
  else if AType = '@I' then begin
    AEdit.Text := '0';
    Result := 0;
  end
  else if (AType = '') or (AType = '@S') then begin
    AEdit.Text := '';
    Result := 0;
  end
  else if Copy(AType, 1, 2) = '@F' then begin
    AFileEdt.Text := '';
    AOpenDlg.Filter := Copy(AType, 4, MAXINT) + '|All Files|*.*';
    AOpenDlg.FilterIndex := 0;
    Result := 2;
  end
  else begin
    i := 1;
    ACombo.Items.BeginUpdate;
    try
      ACombo.Items.Clear;
      while i <= Length(AType) do
        ACombo.Items.Add(ADExtractFieldName(AType, i));
    finally
      ACombo.Items.EndUpdate;
    end;
    ACombo.ItemIndex := -1;
  end;
end;

{------------------------------------------------------------------------------}
{ TfrmADGUIxFMXOptsBase                                                        }
{------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXOptsBase.FormActivate(Sender: TObject);
var
  oMainForm: TCommonCustomForm;
begin
  if not FShown then
    DoShow;
  // In FMX setting position to poMainFormCenter doesn't work
  if FCentered then begin
    oMainForm := Application.MainForm;
    if (oMainForm <> nil) and oMainForm.Visible then begin
      Left := oMainForm.Left + (oMainForm.Width - Width) div 2;
      Top := oMainForm.Top + (oMainForm.Height - Height) div 2;
    end
    else
      Position := TFormPosition.poScreenCenter;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXOptsBase.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FShown := False;
  DoHide;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXOptsBase.FormCreate(Sender: TObject);
begin
  FShown := False;
  FCentered := False;
end;

{$IFNDEF AnyDAC_D17}
{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXOptsBase.DoShow;
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXOptsBase.DoHide;
begin
  if Assigned(FOnHide) then
    FOnHide(Self);
end;
{$ENDIF}

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXOptsBase.LoadFormState(AIni: TCustomIniFile);
var
  eWinState: TWindowState;
begin
  eWinState := TWindowState(AIni.ReadInteger(Name, 'State', Integer(WindowState)));
  if eWinState = TWindowState.wsNormal then begin
    Position := TFormPosition.poDesigned;
    Width := AIni.ReadInteger(Name, 'Width', Width);
    Height := AIni.ReadInteger(Name, 'Height', Height);
    Top := AIni.ReadInteger(Name, 'Top', Top);
    Left := AIni.ReadInteger(Name, 'Left', Left);
  end
  else if eWinState = TWindowState.wsMaximized then
    WindowState := TWindowState.wsMaximized;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXOptsBase.SaveFormState(AIni: TCustomIniFile);
begin
  AIni.WriteInteger(Name, 'State', Integer(WindowState));
  if WindowState = TWindowState.wsNormal then begin
    AIni.WriteInteger(Name, 'Width', Width);
    AIni.WriteInteger(Name, 'Height', Height);
    AIni.WriteInteger(Name, 'Top', Top);
    AIni.WriteInteger(Name, 'Left', Left);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXOptsBase.LoadState;
var
  oIni: TCustomIniFile;
begin
  oIni := TADConfigFile.Create(True);
  try
    Position := TFormPosition.poMainFormCenter;
    if oIni.SectionExists(Name) then
      LoadFormState(oIni);
  except
  end;
  ADFree(oIni);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXOptsBase.SaveState;
var
  oIni: TCustomIniFile;
begin
  oIni := TADConfigFile.Create(False);
  try
    SaveFormState(oIni);
  except
  end;
  ADFree(oIni);
end;

end.
