{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                 FireDAC Error dialog                  }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFormsfError"'}

unit uADGUIxFormsfError;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, ExtCtrls, ComCtrls,
    Clipbrd,
  uADStanIntf, uADStanError,
  uADGUIxIntf, uADGUIxFormsControls, uADGUIxFormsMemo, uADGUIxFormsfOptsBase;

type
  TfrmADGUIxFormsError = class(TfrmADGUIxFormsOptsBase)
    pcAdvanced: TPageControl;
    tsAdvanced: TTabSheet;
    tsQuery: TTabSheet;
    Bevel1: TBevel;
    NativeLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtErrorCode: TEdit;
    edtServerObject: TEdit;
    edtMessage: TMemo;
    edtErrorKind: TEdit;
    edtCommandTextOffset: TEdit;
    btnPrior: TButton;
    btnNext: TButton;
    Label9: TLabel;
    Label5: TLabel;
    lvCommandParams: TListView;
    tsOther: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    edtClassName: TEdit;
    edtADCode: TEdit;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    pnlMsg: TPanel;
    memMsg: TMemo;
    pnlAdvanced: TPanel;
    btnCopy: TButton;
    Label12: TLabel;
    edtADObjName: TEdit;
    procedure FormShow(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DetailsBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCopyClick(Sender: TObject);
  private
    mmCommandText: TADGUIxFormsMemo;
    FError: EADDBEngineException;
    FDetailsHeight, CurItem: Integer;
    FDetails: string;
    FPrevWidth: Integer;
    FOnHide: TADGUIxErrorDialogEvent;
    FOnShow: TADGUIxErrorDialogEvent;
    procedure UpdateLayout(ASwitching: Boolean);
    procedure ShowError;
    procedure ShowCommand;
  protected
    procedure Execute(AExc: EADDBEngineException);
  end;

var
  frmADGUIxFormsError: TfrmADGUIxFormsError;

implementation

uses
  uADStanConst, uADStanFactory, uADStanUtil, uADStanResStrs,
  uADGUIxManager;

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

{ --------------------------------------------------------------------------- }
{ TfrmADGUIxFormsError                                                        }
{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.FormCreate(Sender: TObject);
begin
  mmCommandText := TADGUIxFormsMemo.Create(Self);
  mmCommandText.Left := 5;
  mmCommandText.Top := 45;
  mmCommandText.Width := 418;
  mmCommandText.Height := 80;
  mmCommandText.TabStop := False;
  mmCommandText.Anchors := [akLeft, akTop, akRight, akBottom];
  mmCommandText.ReadOnly := True;
  mmCommandText.ScrollBars := ssBoth;
  mmCommandText.TabOrder := 0;
  mmCommandText.Parent := tsQuery;

  Caption := S_AD_ErrorDialogDefCaption;
  FDetailsHeight := ClientHeight;
  FDetails := btnCancel.Caption;
  UpdateLayout(False);
  ActiveControl := btnOk;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.FormDestroy(Sender: TObject);
begin
  if frmADGUIxFormsError = Self then
    frmADGUIxFormsError := nil;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    ModalResult := mrCancel;
    Key := 0;
  end
  else if (ssCtrl in Shift) and ((Key = Ord('C')) or (Key = VK_INSERT)) then begin
    btnCopyClick(nil);
    Key := 0;
  end;
  inherited;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.btnCopyClick(Sender: TObject);
const
  C_Delim: String = '-------------------------------------------';
var
  oStrs: TADStringList;
  i: Integer;
begin
  oStrs := TADStringList.Create;
  try
    oStrs.Add(Caption);
    oStrs.Add(lblPrompt.Caption);
    oStrs.Add(C_Delim);
    oStrs.Add(Label4.Caption + ' ' + edtMessage.Text);
    oStrs.Add(NativeLabel.Caption + ' ' + edtErrorCode.Text);
    oStrs.Add(Label2.Caption + ' ' + edtErrorKind.Text);
    oStrs.Add(Label1.Caption + ' ' + edtServerObject.Text);
    oStrs.Add(Label3.Caption + ' ' + edtCommandTextOffset.Text);
    oStrs.Add(C_Delim);
    oStrs.Add(Label9.Caption + ' ' + mmCommandText.Text);
    oStrs.Add(Label5.Caption);
    for i := 0 to lvCommandParams.Items.Count - 1 do
      oStrs.Add('  ' + lvCommandParams.Items[i].Caption + '=' +
        lvCommandParams.Items[i].SubItems[0]);
    oStrs.Add(C_Delim);
    oStrs.Add(Label6.Caption + ' ' + edtClassName.Text);
    oStrs.Add(Label7.Caption + ' ' + edtADCode.Text);
    oStrs.Add(Label12.Caption + ' ' + edtADObjName.Text);
    Clipboard.AsText := oStrs.Text;
  finally
    ADFree(oStrs);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.UpdateLayout(ASwitching: Boolean);
const
  DetailsOn: array [Boolean] of string = ('%s >>', '<< %s');
begin
  DisableAlign;
  try
    if pnlAdvanced.Visible then
      ClientHeight := FDetailsHeight
    else begin
      FDetailsHeight := ClientHeight;
      ClientHeight := ClientHeight - pnlAdvanced.Height;
    end;
    btnCancel.Caption := Format(DetailsOn[pnlAdvanced.Visible], [FDetails]);
  finally
    EnableAlign;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.ShowError;
const
  ErrorKinds: array [TADCommandExceptionKind] of String =
    ('Other', 'NoDataFound', 'TooManyRows', 'RecordLocked', 'UKViolated',
     'FKViolated', 'ObjNotExists', 'UserPwdInvalid', 'UserPwdExpired',
     'UserPwdWillExpire', 'CmdAborted', 'ServerGone', 'ServerOutput',
     'ArrExecMalfunc', 'InvalidParams');
var
  oError: TADDBError;
  s: String;
  i: Integer;
begin
  btnPrior.Enabled := CurItem > 0;
  btnNext.Enabled := CurItem < FError.ErrorCount - 1;
  if CurItem > FError.ErrorCount - 1 then
    CurItem := FError.ErrorCount - 1
  else if CurItem < 0 then
    CurItem := 0;
  if FError.ErrorCount > 0 then begin
    oError := FError.Errors[CurItem];
    s := IntToStr(oError.ErrorCode);
    if oError.ErrorCode > 0 then
      for i := 1 to 5 - Length(s) do
        s := '0' + s;
    edtErrorCode.Text := s;
    edtErrorKind.Text := ErrorKinds[oError.Kind];
    edtMessage.Text := ADFixCRLF(oError.Message);
    edtServerObject.Text := oError.ObjName;
    if oError.CommandTextOffset = -1 then
      edtCommandTextOffset.Text := ''
    else
      edtCommandTextOffset.Text := IntToStr(oError.CommandTextOffset);
  end
  else begin
    edtErrorCode.Text := '';
    edtErrorKind.Text := '';
    edtMessage.Text := '';
    edtServerObject.Text := '';
    edtCommandTextOffset.Text := '';
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.ShowCommand;
var
  i: Integer;
  oParams: TStrings;
  oLI: TListItem;
begin
  mmCommandText.Text := FError.SQL;
  lvCommandParams.Items.Clear;
  oParams := FError.Params;
  for i := 0 to oParams.Count - 1 do begin
    oLI := lvCommandParams.Items.Add;
    oLI.Caption := ADNameFromIndex(oParams, i);
    oLI.SubItems.Add(ADValueFromIndex(oParams, i));
  end;
  tsQuery.TabVisible := (Trim(mmCommandText.Text) <> '') or (lvCommandParams.Items.Count > 0);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.FormShow(Sender: TObject);
begin
  memMsg.Text := ADFixCRLF(FError.Message);
  edtClassName.Text := FError.ClassName;
  edtADCode.Text := IntToStr(FError.ADCode);
  edtADObjName.Text := FError.ADObjName;
  CurItem := 0;
  ShowError;
  ShowCommand;
  FPrevWidth := ClientWidth;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.BackClick(Sender: TObject);
begin
  Dec(CurItem);
  ShowError;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.NextClick(Sender: TObject);
begin
  Inc(CurItem);
  ShowError;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.DetailsBtnClick(Sender: TObject);
begin
  DisableAlign;
  try
    pnlAdvanced.Visible := not pnlAdvanced.Visible;
    UpdateLayout(True);
  finally
    EnableAlign;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.Execute(AExc: EADDBEngineException);
var
  oPrevForm: TCustomForm;
begin
  if Assigned(FOnShow) then
    FOnShow(Self, AExc);
  FError := AExc;
  oPrevForm := Screen.ActiveCustomForm;
  Application.BringToFront;
  ShowModal;
  if oPrevForm <> nil then
    oPrevForm.BringToFront;
  FError := nil;
  if Assigned(FOnHide) then
    FOnHide(Self, AExc);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsError.FormResize(Sender: TObject);
begin
  FPrevWidth := ClientWidth;
end;

{ --------------------------------------------------------------------------- }
{ TADGUIxErrorDialogImpl                                                      }
{ --------------------------------------------------------------------------- }
type
  TADGUIxErrorDialogImpl = class(TADGUIxObject, IADGUIxErrorDialog)
  private
    FPrevOnException: TExceptionEvent;
    FHandlingException: Boolean;
    function GetForm: TfrmADGUIxFormsError;
    procedure HandleException(Sender: TObject; E: Exception);
  protected
    // IADGUIxErrorDialog
    function GetOnShow: TADGUIxErrorDialogEvent;
    procedure SetOnShow(const AValue: TADGUIxErrorDialogEvent);
    function GetOnHide: TADGUIxErrorDialogEvent;
    procedure SetOnHide(const AValue: TADGUIxErrorDialogEvent);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    function GetEnabled: Boolean;
    procedure SetEnabled(const AValue: Boolean);
    function GetStayOnTop: Boolean;
    procedure SetStayOnTop(const AValue: Boolean);
    procedure Execute(AExc: EADDBEngineException);
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.Initialize;
begin
  inherited Initialize;
  frmADGUIxFormsError := nil;
  SetEnabled(True);
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxErrorDialogImpl.Destroy;
begin
  SetEnabled(False);
  ADFreeAndNil(frmADGUIxFormsError);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetForm: TfrmADGUIxFormsError;
begin
  if frmADGUIxFormsError = nil then
    frmADGUIxFormsError := TfrmADGUIxFormsError.Create(Application);
  Result := frmADGUIxFormsError;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.HandleException(Sender: TObject; E: Exception);
begin
  if (E is EADDBEngineException) and not Application.Terminated and
     not FHandlingException then begin
    FHandlingException := True;
    try
      Execute(EADDBEngineException(E))
    finally
      FHandlingException := False;
    end;
  end
  else if Assigned(FPrevOnException) then
    FPrevOnException(Sender, E)
  else
    Application.ShowException(E);
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.Execute(AExc: EADDBEngineException);
begin
  if not ADGUIxSilent() then
    GetForm.Execute(AExc);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetOnHide: TADGUIxErrorDialogEvent;
begin
  Result := GetForm.FOnHide;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetOnShow: TADGUIxErrorDialogEvent;
begin
  Result := GetForm.FOnShow;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetCaption: String;
begin
  Result := GetForm.Caption;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetEnabled: Boolean;
var
  oHndlExc: TExceptionEvent;
begin
  oHndlExc := HandleException;
  Result := (Application <> nil) and
            (TMethod(Application.OnException).Code = TMethod(oHndlExc).Code) and
            (TMethod(Application.OnException).Data = TMethod(oHndlExc).Data);
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetStayOnTop: Boolean;
begin
  Result := GetForm.FormStyle = fsStayOnTop;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetOnHide(const AValue: TADGUIxErrorDialogEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFormsError) then
    GetForm.FOnHide := AValue;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetOnShow(const AValue: TADGUIxErrorDialogEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFormsError) then
    GetForm.FOnShow := AValue;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetCaption(const AValue: String);
begin
  if (AValue <> '') or Assigned(frmADGUIxFormsError) then
    GetForm.Caption := AValue;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetEnabled(const AValue: Boolean);
begin
  if GetEnabled <> AValue then
    if AValue then begin
      FPrevOnException := Application.OnException;
      Application.OnException := HandleException;
    end
    else begin
      if Application <> nil then
        Application.OnException := FPrevOnException;
      FPrevOnException := nil;
    end;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetStayOnTop(const AValue: Boolean);
begin
  if AValue then
    GetForm.FormStyle := fsStayOnTop
  else
    GetForm.FormStyle := fsNormal;
end;

{ --------------------------------------------------------------------------- }
var
  oFact: TADFactory;

initialization
{$IFDEF AnyDAC_FPC}
  {$I uADGUIxFormsfError.lrs}
{$ENDIF}
  oFact := TADSingletonFactory.Create(TADGUIxErrorDialogImpl,
    IADGUIxErrorDialog, C_AD_GUIxFormsProvider, 'uADGUIxFormsfError');
{$IFDEF AnyDAC_FMX}
  oFact.AddFriend(C_AD_GUIxFMXProvider + '=uADGUIxFMXfError');
{$ENDIF}

finalization
  ADReleaseFactory(oFact);

end.
