object fGetToken: TfGetToken
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  ClientHeight = 539
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CW: TChromiumWindow
    Left = 0
    Top = 0
    Width = 922
    Height = 539
    Align = alClient
    TabOrder = 0
    OnAfterCreated = CWAfterCreated
    ExplicitHeight = 432
  end
  object TimerChromium: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerChromiumTimer
    Left = 200
    Top = 472
  end
end
