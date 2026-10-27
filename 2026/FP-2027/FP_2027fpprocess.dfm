object fpProcessFP_2012: TfpProcessFP_2012
  Left = 276
  Top = 448
  ClientHeight = 465
  ClientWidth = 748
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 73
    Width = 748
    Height = 392
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 756
    ExplicitHeight = 404
    ControlData = {
      4C000000234E0000C12900000100000005000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126209000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 748
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Visual FP - 2000'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 756
    object CancelBtn: TBitBtn
      Left = 568
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = CancelBtnClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 748
    Height = 32
    Align = alTop
    TabOrder = 2
    Visible = False
    ExplicitWidth = 756
    object URLs: TComboBox
      Left = 246
      Top = 4
      Width = 209
      Height = 21
      Hint = 'URL'
      TabOrder = 0
    end
  end
end
