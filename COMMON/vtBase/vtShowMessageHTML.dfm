object fShowMessageHTML: TfShowMessageHTML
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  ClientHeight = 438
  ClientWidth = 873
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser: TWebBrowser
    Left = 0
    Top = 0
    Width = 873
    Height = 397
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 136
    ExplicitTop = 80
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C0000003A5A0000082900000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel: TPanel
    Left = 0
    Top = 397
    Width = 873
    Height = 41
    Align = alBottom
    TabOrder = 1
    OnResize = PanelResize
    ExplicitTop = 366
    ExplicitWidth = 728
    DesignSize = (
      873
      41)
    object ButtonOK: TButton
      Left = 418
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
  object CW: TChromiumWindow
    Left = 86
    Top = 168
    Width = 321
    Height = 121
    TabOrder = 2
    Visible = False
    OnAfterCreated = CWAfterCreated
  end
end
