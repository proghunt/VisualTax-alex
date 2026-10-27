{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{           FireDAC design time setup dialog            }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxFormsfDesignTimeOptions;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
    ComCtrls,
  uADGUIxFormsfOptsBase, uADStanIntf, uADPhysIntf;

type
  TfrmADGUIxFormsDesignTimeOptions = class(TfrmADGUIxFormsOptsBase)
    btnRefreshMetadata: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edtCatalog: TEdit;
    edtSchema: TEdit;
    GroupBox2: TGroupBox;
    cbMy: TCheckBox;
    cbSystem: TCheckBox;
    cbOther: TCheckBox;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    edtMask: TEdit;
    GroupBox4: TGroupBox;
    cbTable: TCheckBox;
    cbView: TCheckBox;
    cbSynonym: TCheckBox;
    cbTempTable: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox5: TGroupBox;
    cbTraceDT: TCheckBox;
    GroupBox6: TGroupBox;
    cbDClickFE: TCheckBox;
    cbFullName: TCheckBox;
    procedure btnRefreshMetadataClick(Sender: TObject);
  public
    class function Execute: Boolean;
  end;

var
  GADDTCatalog, GADDTSchema: String;
  GADDTScope: TADPhysObjectScopes;
  GADDTMask: String;
  GADDTTableKinds: TADPhysTableKinds;
  GADDTFullName: Boolean;
  GADMoniEnabled: Boolean;
  GADDCFieldsEditor: Boolean;

implementation

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

uses
  uADStanConst, uADStanUtil,
  uADCompClient;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsDesignTimeOptions.btnRefreshMetadataClick(Sender: TObject);
begin
  ADManager.RefreshMetadataCache;
end;

{ --------------------------------------------------------------------------- }
class function TfrmADGUIxFormsDesignTimeOptions.Execute: Boolean;
var
  oOpts: TfrmADGUIxFormsDesignTimeOptions;
  oConf: TADConfigFile;
begin
  oOpts := TfrmADGUIxFormsDesignTimeOptions.Create(nil);
  try
    oOpts.edtCatalog.Text := GADDTCatalog;
    oOpts.edtSchema.Text := GADDTSchema;
    oOpts.cbMy.Checked := osMy in GADDTScope;
    oOpts.cbSystem.Checked := osSystem in GADDTScope;
    oOpts.cbOther.Checked := osOther in GADDTScope;
    oOpts.edtMask.Text := GADDTMask;
    oOpts.cbTable.Checked := tkTable in GADDTTableKinds;
    oOpts.cbView.Checked := tkView in GADDTTableKinds;
    oOpts.cbSynonym.Checked := tkSynonym in GADDTTableKinds;
    oOpts.cbTempTable.Checked := tkTempTable in GADDTTableKinds;
    oOpts.cbFullName.Checked := GADDTFullName;
    oOpts.cbTraceDT.Checked := GADMoniEnabled;
    oOpts.cbDClickFE.Checked := GADDCFieldsEditor;
    Result := oOpts.ShowModal = mrOk;
    if Result then begin
      GADDTCatalog := oOpts.edtCatalog.Text;
      GADDTSchema := oOpts.edtSchema.Text;
      GADDTScope := [];
      if oOpts.cbMy.Checked then
        Include(GADDTScope, osMy);
      if oOpts.cbSystem.Checked then
        Include(GADDTScope, osSystem);
      if oOpts.cbOther.Checked then
        Include(GADDTScope, osOther);
      GADDTMask := oOpts.edtMask.Text;
      GADDTTableKinds := [];
      if oOpts.cbTable.Checked then
        Include(GADDTTableKinds, tkTable);
      if oOpts.cbView.Checked then
        Include(GADDTTableKinds, tkView);
      if oOpts.cbSynonym.Checked then
        Include(GADDTTableKinds, tkSynonym);
      if oOpts.cbTempTable.Checked then
        Include(GADDTTableKinds, tkTempTable);
      GADDTFullName := oOpts.cbFullName.Checked;
      GADMoniEnabled := oOpts.cbTraceDT.Checked;
      GADDCFieldsEditor := oOpts.cbDClickFE.Checked;
      oConf := TADConfigFile.Create(False);
      try
        oConf.WriteString(S_AD_DesignTime, S_AD_DTCatalog, GADDTCatalog);
        oConf.WriteString(S_AD_DesignTime, S_AD_DTSchema, GADDTSchema);
        oConf.WriteInteger(S_AD_DesignTime, S_AD_DTScope, Longword(Pointer(@GADDTScope)^));
        oConf.WriteString(S_AD_DesignTime, S_AD_DTMask, GADDTMask);
        oConf.WriteInteger(S_AD_DesignTime, S_AD_DTTableKinds, Longword(Pointer(@GADDTTableKinds)^));
        oConf.WriteBool(S_AD_DesignTime, S_AD_DTFullName, GADDTFullName);
        oConf.WriteBool(S_AD_DesignTime, S_AD_DTTracing, GADMoniEnabled);
        oConf.WriteBool(S_AD_DesignTime, S_AD_DTDCFieldsEditor, GADDCFieldsEditor);
      finally
        ADFree(oConf);
      end;
    end;
  finally
    ADFree(oOpts);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure Init;
var
  i: Integer;
  oConf: TADConfigFile;
begin
  oConf := TADConfigFile.Create(True);
  try
    if oConf.SectionExists(S_AD_DesignTime) then begin
      GADDTCatalog := oConf.ReadString(S_AD_DesignTime, S_AD_DTCatalog, '');
      GADDTSchema := oConf.ReadString(S_AD_DesignTime, S_AD_DTSchema, '');
      i := oConf.ReadInteger(S_AD_DesignTime, S_AD_DTScope, 0);
      GADDTScope := TADPhysObjectScopes(Pointer(@i)^);
      GADDTMask := oConf.ReadString(S_AD_DesignTime, S_AD_DTMask, '');
      i := oConf.ReadInteger(S_AD_DesignTime, S_AD_DTTableKinds, 0);
      GADDTTableKinds := TADPhysTableKinds(Pointer(@i)^);
      GADDTFullName := oConf.ReadBool(S_AD_DesignTime, S_AD_DTFullName, True);
      GADMoniEnabled := oConf.ReadBool(S_AD_DesignTime, S_AD_DTTracing, False);
      GADDCFieldsEditor := oConf.ReadBool(S_AD_DesignTime, S_AD_DTDCFieldsEditor, False);
    end
    else begin
      GADDTCatalog := '';
      GADDTSchema := '';
      GADDTScope := [osMy, osOther];
      GADDTMask := '';
      GADDTTableKinds := [tkSynonym, tkTable, tkView];
      GADDTFullName := True;
      GADMoniEnabled := False;
      GADDCFieldsEditor := False;
    end;
  finally
    ADFree(oConf);
  end;
end;

{ --------------------------------------------------------------------------- }
initialization
{$IFDEF AnyDAC_FPC}
  {$I uADGUIxFormsfDesignTimeOptions.lrs}
{$ENDIF}
  Init;

end.
