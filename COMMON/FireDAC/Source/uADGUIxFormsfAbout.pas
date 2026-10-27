{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{               FireDAC VCL About dialog                }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxFormsfAbout;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls;

type
  { ------------------------------------------------------------------------- }
  { TfrmADGUIxFormsAbout                                                      }
  { ------------------------------------------------------------------------- }
  TfrmADGUIxFormsAbout = class(TForm)
    lblVersion: TLabel;
    lblCopyright: TLabel;
    lblInternetLink: TLabel;
    Image1: TImage;
    procedure lblInternetLinkClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    procedure Setup(AModHInst: THandle; const ACaption: String);
    class procedure Execute(AModHInst: THandle = 0; const ACaption: String = '');
  end;

var
  frmADGUIxFormsAbout: TfrmADGUIxFormsAbout;

implementation

uses
  uADStanConst, uADStanUtil, uADStanResStrs;

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

{ ------------------------------------------------------------------------- }
{ TfrmADGUIxFormsAbout                                                      }
{ ------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsAbout.Setup(AModHInst: THandle; const ACaption: String);
var
{$IFDEF MSWINDOWS}
  sMod, sVersion,
{$ENDIF}
  sProduct, sVersionName, sCopyright, sInfo: String;
{$IFNDEF AnyDAC_D6}
  ModName: array[0..MAX_PATH] of Char;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  if AModHInst = 0 then
    AModHInst := HInstance;
  {$IFDEF AnyDAC_D6}
  sMod := GetModuleName(AModHInst);
  {$ELSE}
  SetString(sMod, ModName, GetModuleFileName(AModHInst, ModName, SizeOf(ModName)));
  {$ENDIF}
  ADGetVersionInfo(sMod, sProduct, sVersion, sVersionName, sCopyright, sInfo);
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  sProduct := '';
{$ENDIF}
  if sProduct = '' then begin
    sProduct := C_AD_Product + ' ' + ExtractFileName(ParamStr(0));
    sVersionName := C_AD_Version;
    sCopyright := C_AD_Copyright;
    sInfo := C_AD_Link;
  end;
  if ACaption = '' then
    Caption := Format(S_AD_ProductAbout, [sProduct])
  else
    Caption := ACaption;
  lblVersion.Caption := sVersionName;
  lblCopyright.Caption := sCopyright;
  lblInternetLink.Caption := sInfo;
end;

{ ------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsAbout.Image1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{ ------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

{ ------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsAbout.lblInternetLinkClick(Sender: TObject);
begin
  if TLabel(Sender).Caption <> '' then
    ADShell(TLabel(Sender).Caption, S_AD_LComp_Design);
end;

{ ------------------------------------------------------------------------- }
class procedure TfrmADGUIxFormsAbout.Execute(AModHInst: THandle = 0;
  const ACaption: String = '');
var
  oFrm: TfrmADGUIxFormsAbout;
begin
  oFrm := TfrmADGUIxFormsAbout.Create(nil);
  oFrm.Position := poMainFormCenter;
  oFrm.Setup(AModHInst, ACaption);
  try
    oFrm.ShowModal;
  finally
    ADFree(oFrm);
  end;
end;

{$IFDEF AnyDAC_FPC}
initialization
  {$I uADGUIxFormsfAbout.lrs}
{$ENDIF}

end.
