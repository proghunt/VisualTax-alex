{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{        FireDAC resource options editing frame         }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxFormsfResourceOptions;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages,
{$ENDIF}
  SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls, Buttons, DB,
  uADStanOption, uADStanIntf,
  uADGUIxFormsControls;

type
  TfrmADGUIxFormsResourceOptions = class(TFrame)
    ro_gbCmdTextProcess: TPanel;
    ro_rbConnection: TPanel;
    ro_cbAutoReconnect: TCheckBox;
    ro_gbCmdExecute: TPanel;
    ro_cbCreateParams: TCheckBox;
    ro_cbCreateMacros: TCheckBox;
    ro_Label1: TLabel;
    ro_edtMaxCursors: TEdit;
    ro_cbxCmdExecMode: TComboBox;
    ro_Label2: TLabel;
    ro_Label3: TLabel;
    ro_edtCmdExecTimeout: TEdit;
    ro_cbExpandParams: TCheckBox;
    ro_cbExpandMacros: TCheckBox;
    ro_cbExpandEscapes: TCheckBox;
    ro_Label4: TLabel;
    ro_cbxDefaultParamType: TComboBox;
    ro_gbPersistance: TPanel;
    ro_cbPersistent: TCheckBox;
    ro_cbBackup: TCheckBox;
    ro_Label6: TLabel;
    ro_edtDefaultStorageFolder: TEdit;
    ro_Label7: TLabel;
    ro_edtDefaultBackupFolder: TEdit;
    ro_Label8: TLabel;
    ro_Label9: TLabel;
    ro_edtDefaultStorageExt: TEdit;
    ro_edtDefaultBackupExt: TEdit;
    ro_btnFld1: TSpeedButton;
    ro_btnFld2: TSpeedButton;
    ro_Label10: TLabel;
    ro_edtArrayDMLSize: TEdit;
    ro_cbShowWaitCursor: TCheckBox;
    ro_cbServerOutput: TCheckBox;
    ro_Label5: TLabel;
    ro_edtServerOutputSize: TEdit;
    ro_Label11: TLabel;
    ro_cbDefaultStoreFormat: TComboBox;
    ro_cbAutoConnect: TCheckBox;
    ro_cbKeepConnection: TCheckBox;
    ro_cbUnifyParams: TCheckBox;
    procedure ro_Change(Sender: TObject);
    procedure ro_btnFld1Click(Sender: TObject);
    procedure ro_btnFld2Click(Sender: TObject);
  private
    { Private declarations }
    FOnModified: TNotifyEvent;
    FModifiedLocked: Boolean;
  public
    procedure LoadFrom(AOpts: TADResourceOptions);
    procedure SaveTo(AOpts: TADResourceOptions);
  published
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;

implementation

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

uses
  uADStanUtil;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsResourceOptions.LoadFrom(AOpts: TADResourceOptions);
var
  lTopVis: Boolean;
begin
  FModifiedLocked := True;
  try
    lTopVis := AOpts is TADTopResourceOptions;

    if lTopVis then begin
      ro_cbAutoConnect.Checked := TADTopResourceOptions(AOpts).AutoConnect;
      ro_cbKeepConnection.Checked := TADTopResourceOptions(AOpts).KeepConnection;
      ro_cbAutoReconnect.Checked := TADTopResourceOptions(AOpts).AutoReconnect;
      ro_edtMaxCursors.Text := IntToStr(TADTopResourceOptions(AOpts).MaxCursors);
      ro_cbServerOutput.Checked := TADTopResourceOptions(AOpts).ServerOutput;
      ro_edtServerOutputSize.Text := IntToStr(TADTopResourceOptions(AOpts).ServerOutputSize);
    end;
    ro_rbConnection.Visible := lTopVis;
    ro_cbAutoConnect.Visible := lTopVis;
    ro_cbKeepConnection.Visible := lTopVis;
    ro_cbAutoReconnect.Visible := lTopVis;
    ro_Label1.Visible := lTopVis;
    ro_edtMaxCursors.Visible := lTopVis;
    ro_cbServerOutput.Visible := lTopVis;
    ro_Label5.Visible := lTopVis;
    ro_edtServerOutputSize.Visible := lTopVis;

    ro_cbCreateParams.Checked := AOpts.ParamCreate;
    ro_cbCreateMacros.Checked := AOpts.MacroCreate;
    ro_cbExpandParams.Checked := AOpts.ParamExpand;
    ro_cbExpandMacros.Checked := AOpts.MacroExpand;
    ro_cbExpandEscapes.Checked := AOpts.EscapeExpand;
    ro_cbxDefaultParamType.ItemIndex := Integer(AOpts.DefaultParamType);
    ro_cbUnifyParams.Checked := AOpts.UnifyParams;

    ro_cbxCmdExecMode.ItemIndex := Integer(AOpts.CmdExecMode);
    ro_edtCmdExecTimeout.Text := IntToStr(Integer(AOpts.CmdExecTimeout));
    ro_edtArrayDMLSize.Text := IntToStr(Integer(AOpts.ArrayDMLSize));
    ro_cbShowWaitCursor.Checked := not AOpts.SilentMode;

    ro_cbPersistent.Checked := AOpts.Persistent;
    ro_cbBackup.Checked := AOpts.Backup;
    if lTopVis then begin
      ro_cbDefaultStoreFormat.ItemIndex := Integer(TADTopResourceOptions(AOpts).DefaultStoreFormat);
      ro_edtDefaultStorageFolder.Text := TADTopResourceOptions(AOpts).DefaultStoreFolder;
      ro_edtDefaultStorageExt.Text := TADTopResourceOptions(AOpts).DefaultStoreExt;
      ro_edtDefaultBackupFolder.Text := TADTopResourceOptions(AOpts).BackupFolder;
      ro_edtDefaultBackupExt.Text := TADTopResourceOptions(AOpts).BackupExt;
    end;
    ro_Label11.Visible := lTopVis;
    ro_cbDefaultStoreFormat.Visible := lTopVis;
    ro_Label6.Visible := lTopVis;
    ro_edtDefaultStorageFolder.Visible := lTopVis;
    ro_Label7.Visible := lTopVis;
    ro_edtDefaultBackupFolder.Visible := lTopVis;
    ro_Label8.Visible := lTopVis;
    ro_edtDefaultStorageExt.Visible := lTopVis;
    ro_Label9.Visible := lTopVis;
    ro_edtDefaultBackupExt.Visible := lTopVis;

  finally
    FModifiedLocked := False;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsResourceOptions.SaveTo(AOpts: TADResourceOptions);
begin
  if AOpts is TADTopResourceOptions then begin
    if TADTopResourceOptions(AOpts).AutoConnect <> ro_cbAutoConnect.Checked then
      TADTopResourceOptions(AOpts).AutoConnect := ro_cbAutoConnect.Checked;
    if TADTopResourceOptions(AOpts).KeepConnection <> ro_cbKeepConnection.Checked then
      TADTopResourceOptions(AOpts).KeepConnection := ro_cbKeepConnection.Checked;
    if TADTopResourceOptions(AOpts).AutoReconnect <> ro_cbAutoReconnect.Checked then
      TADTopResourceOptions(AOpts).AutoReconnect := ro_cbAutoReconnect.Checked;
    if TADTopResourceOptions(AOpts).MaxCursors <> StrToInt(ro_edtMaxCursors.Text) then
      TADTopResourceOptions(AOpts).MaxCursors := StrToInt(ro_edtMaxCursors.Text);
    if TADTopResourceOptions(AOpts).ServerOutput <> ro_cbServerOutput.Checked then
      TADTopResourceOptions(AOpts).ServerOutput := ro_cbServerOutput.Checked;
    if TADTopResourceOptions(AOpts).ServerOutputSize <> StrToInt(ro_edtServerOutputSize.Text) then
      TADTopResourceOptions(AOpts).ServerOutputSize := StrToInt(ro_edtServerOutputSize.Text);
  end;

  if ro_cbCreateParams.Checked <> AOpts.ParamCreate then
    AOpts.ParamCreate := ro_cbCreateParams.Checked;
  if ro_cbCreateMacros.Checked <> AOpts.MacroCreate then
    AOpts.MacroCreate := ro_cbCreateMacros.Checked;
  if ro_cbExpandParams.Checked <> AOpts.ParamExpand then
    AOpts.ParamExpand := ro_cbExpandParams.Checked;
  if ro_cbExpandMacros.Checked <> AOpts.MacroExpand then
    AOpts.MacroExpand := ro_cbExpandMacros.Checked;
  if ro_cbExpandEscapes.Checked <> AOpts.EscapeExpand then
    AOpts.EscapeExpand := ro_cbExpandEscapes.Checked;
  if ro_cbxDefaultParamType.ItemIndex <> Integer(AOpts.DefaultParamType) then
    AOpts.DefaultParamType := TParamType(ro_cbxDefaultParamType.ItemIndex);
  if ro_cbUnifyParams.Checked <> AOpts.UnifyParams then
    AOpts.UnifyParams := ro_cbUnifyParams.Checked;

  if ro_cbxCmdExecMode.ItemIndex <> Integer(AOpts.CmdExecMode) then
    AOpts.CmdExecMode := TADStanAsyncMode(ro_cbxCmdExecMode.ItemIndex);
  if StrToInt(ro_edtCmdExecTimeout.Text) <> Integer(AOpts.CmdExecTimeout) then
    AOpts.CmdExecTimeout := LongWord(StrToInt(ro_edtCmdExecTimeout.Text));
  if ro_edtArrayDMLSize.Text <> IntToStr(Integer(AOpts.ArrayDMLSize)) then
    AOpts.ArrayDMLSize := StrToInt(ro_edtArrayDMLSize.Text);
  if ro_cbShowWaitCursor.Checked <> not AOpts.SilentMode then
    AOpts.SilentMode := not ro_cbShowWaitCursor.Checked;

  if AOpts.Persistent <> ro_cbPersistent.Checked then
    AOpts.Persistent := ro_cbPersistent.Checked;
  if AOpts.Backup <> ro_cbBackup.Checked then
    AOpts.Backup := ro_cbBackup.Checked;
  if AOpts is TADTopResourceOptions then begin
    if TADTopResourceOptions(AOpts).DefaultStoreFormat <> TADStorageFormat(ro_cbDefaultStoreFormat.ItemIndex) then
      TADTopResourceOptions(AOpts).DefaultStoreFormat := TADStorageFormat(ro_cbDefaultStoreFormat.ItemIndex);
    if TADTopResourceOptions(AOpts).DefaultStoreFolder <> ro_edtDefaultStorageFolder.Text then
      TADTopResourceOptions(AOpts).DefaultStoreFolder := ro_edtDefaultStorageFolder.Text;
    if TADTopResourceOptions(AOpts).DefaultStoreExt <> ro_edtDefaultStorageExt.Text then
      TADTopResourceOptions(AOpts).DefaultStoreExt := ro_edtDefaultStorageExt.Text;
    if TADTopResourceOptions(AOpts).BackupFolder <> ro_edtDefaultBackupFolder.Text then
      TADTopResourceOptions(AOpts).BackupFolder := ro_edtDefaultBackupFolder.Text;
    if TADTopResourceOptions(AOpts).BackupExt <> ro_edtDefaultBackupExt.Text then
      TADTopResourceOptions(AOpts).BackupExt := ro_edtDefaultBackupExt.Text;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsResourceOptions.ro_Change(Sender: TObject);
begin
  if not FModifiedLocked and Assigned(FOnModified) then
    FOnModified(Self);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsResourceOptions.ro_btnFld1Click(Sender: TObject);
var
  s: String;
begin
  s := ADBrowseForFolder(Handle, 'Select storage files folder');
  if s <> '' then
    ro_edtDefaultStorageFolder.Text := s;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsResourceOptions.ro_btnFld2Click(Sender: TObject);
var
  s: String;
begin
  s := ADBrowseForFolder(Handle, 'Select backup files folder');
  if s <> '' then
    ro_edtDefaultBackupFolder.Text := s;
end;

{$IFDEF AnyDAC_FPC}
initialization
  {$I uADGUIxFormsfResourceOptions.lrs}
{$ENDIF}

end.
