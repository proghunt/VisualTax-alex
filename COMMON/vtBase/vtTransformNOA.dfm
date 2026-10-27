object fTransformNOA: TfTransformNOA
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  ClientHeight = 66
  ClientWidth = 267
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
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 267
    Height = 66
    Align = alClient
    Caption = 'Transforming XML..'
    TabOrder = 0
    ExplicitTop = 34
    ExplicitWidth = 268
    ExplicitHeight = 41
    object WB: TWebBrowser
      Left = -32
      Top = 300
      Width = 300
      Height = 150
      TabOrder = 0
      OnNavigateComplete2 = WBNavigateComplete2
      ControlData = {
        4C000000021F0000810F00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
