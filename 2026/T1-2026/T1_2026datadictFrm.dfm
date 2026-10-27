object DatadictFrmT1_2026: TDatadictFrmT1_2026
  Left = 256
  Top = 158
  Width = 696
  Height = 480
  Caption = 'uDataDictFrm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object vtLabel1: TvtLabel
    Left = 0
    Top = 50
    Width = 688
    Height = 15
    Align = alTop
    Alignment = taCenter
    Caption = 
      'The Data Dictionary contains key words that are used in Client L' +
      'etters'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object Panel12: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 50
    Align = alTop
    Caption = 'Data Dictionary'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 119
    Width = 680
    Height = 288
    TabOrder = 1
  end
  object OpenFormBtn: TBitBtn
    Left = 84
    Top = 77
    Width = 75
    Height = 25
    Caption = 'Open Form'
    TabOrder = 2
    OnClick = OpenFormBtnClick
  end
end
