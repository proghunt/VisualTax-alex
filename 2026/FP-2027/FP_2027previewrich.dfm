object PreviewRichFP_2027: TPreviewRichFP_2027
  Left = 138
  Top = 105
  Width = 714
  Height = 493
  Caption = 'Preview letter'
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RichText1: TvtRichMemo
    Left = 0
    Top = 0
    Width = 706
    Height = 447
    Align = alClient
    Lines.Strings = (
      'RichText1')
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 257
    Top = 27
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
end
