object FundsMenu: TFundsMenu
  Left = 28
  Top = 53
  Caption = 'FundsMenu'
  ClientHeight = 0
  ClientWidth = 124
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 0
    Width = 124
    Height = 2
    Cursor = crVSplit
    Align = alTop
    Color = clRed
    ParentColor = False
    ExplicitWidth = 709
  end
  object DealerButtons: TChart
    Left = 120
    Top = 100
    Width = 481
    Height = 273
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Border.Visible = True
    Gradient.Direction = gdFromCenter
    Gradient.EndColor = 14933196
    Gradient.StartColor = 2105344
    Gradient.Visible = True
    Legend.Visible = False
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 10
    Title.Font.Color = clBlack
    Title.Font.Height = -13
    Title.Text.Strings = (
      '')
    AxisVisible = False
    Chart3DPercent = 1
    View3DOptions.HorizOffset = -1257
    View3DOptions.VertOffset = -365
    View3DOptions.Zoom = 1
    View3DWalls = False
    Zoom.AnimatedSteps = 9
    BevelInner = bvRaised
    TabOrder = 0
    ColorPaletteIndex = 13
    object Chart2: TChart
      Left = 144
      Top = 56
      Width = 225
      Height = 169
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      Gradient.Direction = gdFromCenter
      Gradient.EndColor = clSilver
      Gradient.Visible = True
      Legend.Visible = False
      MarginLeft = 0
      MarginRight = 0
      MarginTop = 10
      Title.Font.Color = clBlack
      Title.Font.Height = -13
      Title.Text.Strings = (
        '')
      AxisVisible = False
      Chart3DPercent = 1
      View3DOptions.HorizOffset = -1257
      View3DOptions.VertOffset = -365
      View3DOptions.Zoom = 1
      View3DWalls = False
      Zoom.AnimatedSteps = 9
      BevelWidth = 3
      TabOrder = 0
      ColorPaletteIndex = 13
      object Label2: TLabel
        Left = 48
        Top = 96
        Width = 151
        Height = 26
        Caption = 'Fund Analyser'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5921370
        Font.Height = -24
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
      end
      object Label6: TLabel
        Left = 56
        Top = 48
        Width = 100
        Height = 26
        Caption = 'Visual FP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -24
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
      end
      object Label9: TLabel
        Left = 157
        Top = 40
        Width = 16
        Height = 13
        Caption = 'TM'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 304
    Top = 8
    object FindBtn: TMenuItem
      Caption = 'Find'
      OnClick = FindBtnClick
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
end
