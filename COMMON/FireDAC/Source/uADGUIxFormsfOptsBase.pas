{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{               FireDAC Base dialog form                }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxFormsfOptsBase;

interface

uses
{$IFNDEF AnyDAC_FPC}
  Messages,
{$ELSE}
  LCLIntf, LCLType, LResources,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls, IniFiles;

type
  TfrmADGUIxFormsOptsBase = class(TForm)
    pnlTop: TPanel;
    Image2: TImage;
    lblPrompt: TLabel;
    pnlButtons: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
  protected
    procedure LoadFormState(AIni: TCustomIniFile); virtual;
    procedure SaveFormState(AIni: TCustomIniFile); virtual;
  public
    procedure LoadState;
    procedure SaveState;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmADGUIxFormsOptsBase: TfrmADGUIxFormsOptsBase;

implementation

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

uses
{$IFDEF AnyDAC_FPC}
  RTLConsts,
{$ELSE}
  Consts,
  {$IFDEF MSWINDOWS}
  Registry,
  {$ENDIF}
{$ENDIF}
  uADStanConst, uADStanUtil;

{------------------------------------------------------------------------------}
{ TfrmADGUIxFormsOptsBase                                                      }
{------------------------------------------------------------------------------}
constructor TfrmADGUIxFormsOptsBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  btnOk.Caption := '&' + SOKButton;
  if btnCancel.Caption = '&Cancel' then
    btnCancel.Caption := '&' + SCancelButton;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsOptsBase.LoadFormState(AIni: TCustomIniFile);
var
  eWinState: TWindowState;
begin
  eWinState := TWindowState(AIni.ReadInteger(Name, 'State', Integer(WindowState)));
  if eWinState = wsNormal then begin
    Position := poDesigned;
    Width := AIni.ReadInteger(Name, 'Width', Width);
    Height := AIni.ReadInteger(Name, 'Height', Height);
    Top := AIni.ReadInteger(Name, 'Top', Top);
    Left := AIni.ReadInteger(Name, 'Left', Left);
  end
  else if eWinState = wsMaximized then
    WindowState := wsMaximized;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsOptsBase.SaveFormState(AIni: TCustomIniFile);
begin
  AIni.WriteInteger(Name, 'State', Integer(WindowState));
  if WindowState = wsNormal then begin
    AIni.WriteInteger(Name, 'Width', Width);
    AIni.WriteInteger(Name, 'Height', Height);
    AIni.WriteInteger(Name, 'Top', Top);
    AIni.WriteInteger(Name, 'Left', Left);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsOptsBase.LoadState;
var
  oIni: TCustomIniFile;
begin
  oIni := TADConfigFile.Create(True);
  try
{$IFDEF AnyDAC_FPC}
    Position := poScreenCenter;
{$ELSE}
    Position := poMainFormCenter;
{$ENDIF}
    if oIni.SectionExists(Name) then
      LoadFormState(oIni);
  except
  end;
  ADFree(oIni);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsOptsBase.SaveState;
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

{$IFDEF AnyDAC_FPC}
initialization
  {$I uADGUIxFormsfOptsBase.lrs}
{$ENDIF}

end.
