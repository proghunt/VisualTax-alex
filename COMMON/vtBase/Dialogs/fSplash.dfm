object Splash: TSplash
  Left = 366
  Top = 439
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Applications'
  ClientHeight = 658
  ClientWidth = 866
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Pages: TPageControl
    Left = 0
    Top = 0
    Width = 866
    Height = 658
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alClient
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnChange = PagesChange
    OnChanging = PagesChanging
  end
end
