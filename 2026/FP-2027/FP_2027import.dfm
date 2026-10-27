object Import: TImport
  Left = 167
  Top = 167
  Caption = 'Rollover from Last Year VisualTax'
  ClientHeight = 323
  ClientWidth = 608
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object RetCntLabel: TLabel
    Left = 192
    Top = 176
    Width = 5
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CancelBtn: TBitBtn
    Left = 304
    Top = 240
    Width = 121
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    Kind = bkClose
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 144
    Width = 569
    Height = 65
    Caption = 'FP Clients database location'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 16
      Width = 115
      Height = 14
      Caption = 'Last Year (import from) '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 305
      Top = 16
      Width = 102
      Height = 13
      Caption = 'This Year (import into)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Image1: TImage
      Left = 253
      Top = 36
      Width = 28
      Height = 21
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
    end
    object LastYearDirBox: TEdit
      Left = 9
      Top = 36
      Width = 224
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'LastYearDirBox'
    end
    object ThisYearDirBox: TEdit
      Left = 307
      Top = 36
      Width = 222
      Height = 21
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'ThisYearDirBox'
    end
  end
  object AllBtn: TBitBtn
    Left = 128
    Top = 240
    Width = 161
    Height = 33
    Caption = 'Import all plans'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 1
    OnClick = AllBtnClick
  end
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 608
    Height = 65
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.StartColor = 12615680
    Gradient.Visible = True
    Legend.Visible = False
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 10
    Title.Font.Charset = ANSI_CHARSET
    Title.Font.Color = 12971774
    Title.Font.Height = -27
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      '  '
      '')
    AxisVisible = False
    Chart3DPercent = 1
    View3DOptions.HorizOffset = -1257
    View3DOptions.VertOffset = -365
    View3DOptions.Zoom = 1
    View3DWalls = False
    Zoom.AnimatedSteps = 9
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    ColorPaletteIndex = 13
    object Label4: TLabel
      Left = 104
      Top = 16
      Width = 443
      Height = 26
      Caption = 'Import the FP plans from the previous year'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      Transparent = True
    end
  end
end
