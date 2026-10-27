object ReportMenuFP_2012: TReportMenuFP_2012
  Left = 222
  Top = 150
  Caption = 'ReportMenuFP_2012'
  ClientHeight = 354
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Preview: TButton
    Left = 36
    Top = 316
    Width = 89
    Height = 29
    Caption = 'P&review'
    TabOrder = 0
    OnClick = PreviewClick
  end
  object Print: TButton
    Left = 140
    Top = 316
    Width = 89
    Height = 29
    Caption = '&Print'
    TabOrder = 1
    OnClick = PrintClick
  end
  object Exit: TButton
    Left = 248
    Top = 316
    Width = 89
    Height = 29
    Caption = 'E&xit'
    TabOrder = 2
    OnClick = ExitClick
  end
  object ReportList: TRadioGroup
    Left = 16
    Top = 16
    Width = 305
    Height = 137
    Caption = 'Reports'
    Items.Strings = (
      'Client Listing'
      'Portfolios'
      'ALL transactions'
      'PNONSH')
    TabOrder = 3
  end
end
