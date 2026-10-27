object PortFolioMenuFP_2012: TPortFolioMenuFP_2012
  Left = 68
  Top = 90
  Caption = 'PortfolioMenu'
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
    ExplicitWidth = 777
  end
  object DealerButtons: TChart
    Left = 80
    Top = 100
    Width = 617
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
    object Image3: TImage
      Left = 144
      Top = 120
      Width = 25
      Height = 25
      Picture.Data = {
        07544269746D61707E010000424D7E0100000000000076000000280000001400
        0000160000000100040000000000080100000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00777777777777777777770000777777777777777777770000777777777707
        7777777700007777777777007777777700007777777777040777777700007777
        7777770440777777000077777777770444077777000077770000000444407777
        0000777704444444444407770000777704444444444440770000777704444444
        4444440700007777044444444444407700007777044444444444077700007777
        0000000444407777000077777777770444077777000077777777770440777777
        0000777777777704077777770000777777777700777777770000777777777707
        7777777700007777777777777777777700007777777777777777777700007777
        77777777777777770000}
      Transparent = True
    end
    object Image1: TImage
      Left = 448
      Top = 120
      Width = 25
      Height = 25
      Picture.Data = {
        07544269746D61707E010000424D7E0100000000000076000000280000001400
        0000160000000100040000000000080100000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00777777777777777777770000777777777777777777770000777777777707
        7777777700007777777777007777777700007777777777040777777700007777
        7777770440777777000077777777770444077777000077770000000444407777
        0000777704444444444407770000777704444444444440770000777704444444
        4444440700007777044444444444407700007777044444444444077700007777
        0000000444407777000077777777770444077777000077777777770440777777
        0000777777777704077777770000777777777700777777770000777777777707
        7777777700007777777777777777777700007777777777777777777700007777
        77777777777777770000}
      Transparent = True
    end
    object ClientPortfBtn: TChart
      Left = 488
      Top = 104
      Width = 89
      Height = 57
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      Gradient.Direction = gdBottomTop
      Gradient.EndColor = clSilver
      Gradient.Visible = True
      Legend.Visible = False
      MarginLeft = 0
      MarginRight = 0
      MarginTop = 10
      Title.Font.Color = clBlack
      Title.Font.Height = -13
      Title.Text.Strings = (
        'Build Client'
        'Portfolio')
      AxisVisible = False
      Chart3DPercent = 1
      View3DOptions.HorizOffset = -1257
      View3DOptions.VertOffset = -365
      View3DOptions.Zoom = 1
      View3DWalls = False
      Zoom.AnimatedSteps = 9
      BevelWidth = 2
      TabOrder = 0
      OnClick = ClientPortfBtnClick
      ColorPaletteIndex = 13
    end
    object ModelPortfBtn: TChart
      Left = 40
      Top = 104
      Width = 89
      Height = 57
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      Gradient.Direction = gdBottomTop
      Gradient.EndColor = clSilver
      Gradient.Visible = True
      Legend.Visible = False
      MarginLeft = 0
      MarginRight = 0
      MarginTop = 10
      Title.Font.Color = clBlack
      Title.Font.Height = -13
      Title.Text.Strings = (
        'Build Model'
        'Portfolios')
      AxisVisible = False
      Chart3DPercent = 1
      View3DOptions.HorizOffset = -1257
      View3DOptions.VertOffset = -365
      View3DOptions.Zoom = 1
      View3DWalls = False
      Zoom.AnimatedSteps = 9
      BevelWidth = 2
      TabOrder = 1
      OnClick = ModelPortfBtnClick
      ColorPaletteIndex = 13
    end
    object Chart2: TChart
      Left = 192
      Top = 56
      Width = 241
      Height = 161
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
      TabOrder = 2
      ColorPaletteIndex = 13
      object Label2: TLabel
        Left = 48
        Top = 96
        Width = 175
        Height = 26
        Caption = 'Portfolio Builder'
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
        Left = 69
        Top = 40
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
        Left = 173
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
    object CancelBtn: TBitBtn
      Left = 272
      Top = 232
      Width = 75
      Height = 25
      Caption = 'Exit'
      ModalResult = 2
      TabOrder = 3
      OnClick = CancelBtnClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 304
    Top = 8
    object PortfolioBuilder1: TMenuItem
      Caption = 'PortfolioBuilder'
      object ModelPortfolio: TMenuItem
        Caption = 'ModelPortfolio'
        OnClick = ModelPortfolioClick
      end
      object ClientPortfolio1: TMenuItem
        Caption = 'ClientPortfolio'
        OnClick = ClientPortfolio1Click
      end
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
end
