{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{            FireDAC FireMonkey Error dialog            }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFMXfError"'}

unit uADGUIxFMXfError;

interface

uses
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes,
{$IFDEF AnyDAC_FPC}
  FMX_Forms, FMX_Controls, FMX_ListBox, FMX_Layouts, FMX_Memo, FMX_Edit,
    FMX_TabControl, FMX_Objects, FMX_Types, FMX_ExtCtrls, FMX_Grid,
{$ELSE}
  FMX.Forms, FMX.Controls, FMX.ListBox, FMX.Layouts, FMX.Memo, FMX.Edit,
    FMX.TabControl, FMX.Objects, FMX.Types, FMX.ExtCtrls, FMX.Grid,
  {$IFDEF AnyDAC_D18}
    FMX.StdCtrls, FMX.Header,
  {$ENDIF}
{$ENDIF}
  uADStanIntf, uADStanError,
  uADGUIxIntf, uADGUIxFMXfOptsBase;

type
  TfrmADGUIxFMXError = class(TfrmADGUIxFMXOptsBase)
    pcAdvanced: TTabControl;
    tsAdvanced: TTabItem;
    tsQuery: TTabItem;
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
    lvCommandParams: TListBox;
    tsOther: TTabItem;
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
    pnlCopy: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    StyleBook1: TStyleBook;
    Line5: TLine;
    Line6: TLine;
    mmCommandText: TMemo;
    Panel3: TPanel;
    Header1: THeader;
    HeaderItem1: THeaderItem;
    HeaderItem2: THeaderItem;
    Label12: TLabel;
    edtADObjName: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DetailsBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure btnCopyClick(Sender: TObject);
  private
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
  frmADGUIxFMXError: TfrmADGUIxFMXError;

implementation

uses
  UITypes, 
{$IFDEF AnyDAC_FPC}
  FMX_Platform,
{$ELSE}
  FMX.Platform,
{$ENDIF}
  uADStanConst, uADStanFactory, uADStanUtil, uADStanResStrs,
  uADGUIxManager;

{$IFNDEF AnyDAC_FPC}
{$R *.fmx}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{ --------------------------------------------------------------------------- }
{ TfrmADGUIxFMXError                                                          }
{ --------------------------------------------------------------------------- }

procedure TfrmADGUIxFMXError.FormCreate(Sender: TObject);
begin
  Caption := S_AD_ErrorDialogDefCaption;
  FDetailsHeight := ClientHeight;
  FDetails := btnCancel.Text;
  pnlAdvanced.Visible := True;
  DetailsBtnClick(nil);
  ActiveControl := btnOk;
  Visible := False;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.FormDestroy(Sender: TObject);
begin
  if frmADGUIxFMXError = Self then
    frmADGUIxFMXError := nil;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkEscape then begin
    ModalResult := mrCancel;
    Key := 0;
  end
  else if (ssCtrl in Shift) and ((KeyChar = 'C') or (Key = vkInsert)) then begin
    btnCopyClick(nil);
    Key := 0;
  end;
  inherited;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.btnCopyClick(Sender: TObject);
const
  C_Delim: String = '-------------------------------------------';
var
  oStrs: TADStringList;
  i: Integer;
  oLI: TListBoxItem;
  oName, oValue: TText;
{$IFDEF AnyDAC_D17}
  oClpSrv: IFMXClipboardService;
{$ENDIF}
begin
  oStrs := TADStringList.Create;
  try
    oStrs.Add(Caption);
    oStrs.Add(lblPrompt.Text);
    oStrs.Add(C_Delim);
    oStrs.Add(Label4.Text + ' ' + edtMessage.Text);
    oStrs.Add(NativeLabel.Text + ' ' + edtErrorCode.Text);
    oStrs.Add(Label2.Text + ' ' + edtErrorKind.Text);
    oStrs.Add(Label1.Text + ' ' + edtServerObject.Text);
    oStrs.Add(Label3.Text + ' ' + edtCommandTextOffset.Text);
    oStrs.Add(C_Delim);
    oStrs.Add(Label9.Text + ' ' + mmCommandText.Text);
    oStrs.Add(Label5.Text);
    // Start from 1/skip the header
    for i := 1 to lvCommandParams.Items.Count - 1 do begin
      oLI := lvCommandParams.ListItems[i];
      oName := TText(oLI.FindStyleResource('Name'));
      oValue := TText(oLI.FindStyleResource('Value'));
      if (oName <> nil) and (oValue <> nil) then
        oStrs.Add('  ' + oName.Text + '=' + oValue.Text);
    end;
    oStrs.Add(C_Delim);
    oStrs.Add(Label6.Text + ' ' + edtClassName.Text);
    oStrs.Add(Label7.Text + ' ' + edtADCode.Text);
    oStrs.Add(Label12.Text + ' ' + edtADObjName.Text);
{$IFDEF AnyDAC_D17}
    if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, IInterface(oClpSrv)) then
      oClpSrv.SetClipboard(oStrs.Text);
{$ELSE}
    Platform.SetClipboard(oStrs.Text);
{$ENDIF}
  finally
    ADFree(oStrs);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.UpdateLayout(ASwitching: Boolean);
const
  DetailsOn: array [Boolean] of string = ('%s >>', '<< %s');
begin
  if pnlAdvanced.Visible then
    ClientHeight := FDetailsHeight
  else begin
    FDetailsHeight := ClientHeight;
    ClientHeight := ClientHeight - Trunc(pnlAdvanced.Height);
  end;
  btnCancel.Text := Format(DetailsOn[pnlAdvanced.Visible], [FDetails]);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.ShowError;
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
procedure TfrmADGUIxFMXError.ShowCommand;
var
  i: Integer;
  oParams: Classes.TStrings;
  oLI: TListBoxItem;
  oText: TText;
begin
  mmCommandText.Text := FError.SQL;
  lvCommandParams.Clear;
  oParams := FError.Params;
  for i := 0 to oParams.Count - 1 do begin
    oLI := TListBoxItem.Create(Self);
    oLI.Parent := lvCommandParams;
    oLI.StyleLookup := 'LBReportStyle';
    oText := TText(oLI.FindStyleResource('Name'));
    if oText <> nil then
      oText.Text := ADNameFromIndex(oParams, i);
    oText := TText(oLI.FindStyleResource('Value'));
    if oText <> nil then
      oText.Text := ADValueFromIndex(oParams, i);
  end;
  tsQuery.Visible := (Trim(mmCommandText.Text) <> '') or
    (lvCommandParams.Items.Count > 0);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.FormActivate(Sender: TObject);
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
procedure TfrmADGUIxFMXError.BackClick(Sender: TObject);
begin
  Dec(CurItem);
  ShowError;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.NextClick(Sender: TObject);
begin
  Inc(CurItem);
  ShowError;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.DetailsBtnClick(Sender: TObject);
begin
  pnlAdvanced.Visible := not pnlAdvanced.Visible;
  UpdateLayout(True);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.Execute(AExc: EADDBEngineException);
var
  oPrevForm: TCommonCustomForm;
  i: Integer;
begin
  if Assigned(FOnShow) then
    FOnShow(Self, AExc);
  FError := AExc;
  oPrevForm := nil;
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].Active then begin
      oPrevForm := Screen.Forms[i];
      Break;
    end;
  if Application.MainForm <> nil then
    Application.MainForm.BringToFront;
  ShowModal;
  if oPrevForm <> nil then
    oPrevForm.BringToFront;
  FError := nil;
  if Assigned(FOnHide) then
    FOnHide(Self, AExc);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFMXError.FormResize(Sender: TObject);
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
    function GetForm: TfrmADGUIxFMXError;
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
  frmADGUIxFMXError := nil;
  SetEnabled(True);
end;

{ --------------------------------------------------------------------------- }
destructor TADGUIxErrorDialogImpl.Destroy;
begin
  SetEnabled(False);
  ADFreeAndNil(frmADGUIxFMXError);
  inherited Destroy;
end;

{ --------------------------------------------------------------------------- }
function TADGUIxErrorDialogImpl.GetForm: TfrmADGUIxFMXError;
begin
  if frmADGUIxFMXError = nil then
    frmADGUIxFMXError := TfrmADGUIxFMXError.Create(Application);
  Result := frmADGUIxFMXError;
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
  Result := GetForm.TopMost;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetOnHide(const AValue: TADGUIxErrorDialogEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFMXError) then
    GetForm.FOnHide := AValue;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetOnShow(const AValue: TADGUIxErrorDialogEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFMXError) then
    GetForm.FOnShow := AValue;
end;

{ --------------------------------------------------------------------------- }
procedure TADGUIxErrorDialogImpl.SetCaption(const AValue: String);
begin
  if (AValue <> '') or Assigned(frmADGUIxFMXError) then
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
  GetForm.TopMost := AValue;
end;

{ --------------------------------------------------------------------------- }
var
  oFact: TADFactory;

initialization
  oFact := TADSingletonFactory.Create(TADGUIxErrorDialogImpl,
    IADGUIxErrorDialog, C_AD_GUIxFMXProvider, 'uADGUIxFMXfError');

finalization
  ADReleaseFactory(oFact);

end.
