object InvestmentStrategyFP_2012: TInvestmentStrategyFP_2012
  Left = 92
  Top = 241
  Caption = 'InvestmentStrategyFP_2012'
  ClientHeight = 503
  ClientWidth = 718
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 14
  object Label8: TLabel
    Left = 56
    Top = 352
    Width = 130
    Height = 15
    Caption = 'Total annual investment'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label25: TLabel
    Left = 96
    Top = 40
    Width = 510
    Height = 15
    Caption = 
      'Allocate the disposable income and the tax refund amounts by spi' +
      'nning the boxes up or down'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label37: TLabel
    Left = 200
    Top = 336
    Width = 80
    Height = 15
    Caption = 'Non-Sheltered'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label38: TLabel
    Left = 320
    Top = 336
    Width = 53
    Height = 15
    Caption = 'Sheltered'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label39: TLabel
    Left = 400
    Top = 336
    Width = 89
    Height = 15
    Caption = 'Semi-Sheltered '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label40: TLabel
    Left = 520
    Top = 336
    Width = 30
    Height = 15
    Caption = 'Other'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 718
    Height = 33
    Align = alTop
    Caption = 'Investment Strategy'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 726
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 384
    Width = 657
    Height = 113
    Color = 14933196
    ParentColor = False
    TabOrder = 1
    Visible = False
    object Label11: TLabel
      Left = 24
      Top = 56
      Width = 75
      Height = 16
      Caption = 'Before tax %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 32
      Top = 80
      Width = 65
      Height = 16
      Caption = 'After tax %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label29: TLabel
      Left = 112
      Top = 24
      Width = 84
      Height = 15
      Caption = 'Non-Sheltered '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label30: TLabel
      Left = 208
      Top = 24
      Width = 55
      Height = 15
      Caption = 'Sheltered'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label31: TLabel
      Left = 304
      Top = 24
      Width = 91
      Height = 15
      Caption = 'Semi-Sheltered '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label32: TLabel
      Left = 408
      Top = 24
      Width = 32
      Height = 15
      Caption = 'Other'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 299
      Height = 16
      Caption = 'Expected rates of return for asset accumulation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object NonShBfrTax: TEdit
      Left = 112
      Top = 48
      Width = 46
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '0'
      OnChange = NonShBfrTaxChange
      OnKeyPress = NonShBfrTaxKeyPress
    end
    object NonShAftTax: TEdit
      Left = 112
      Top = 80
      Width = 46
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = 'NonShAftTax'
    end
    object SheltBfrTax: TEdit
      Left = 208
      Top = 48
      Width = 57
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '0'
      OnChange = SheltBfrTaxChange
      OnKeyPress = SheltBfrTaxKeyPress
    end
    object SheltAftTax: TEdit
      Left = 208
      Top = 80
      Width = 57
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      Text = 'SheltAftTax'
    end
    object SemShBfrTax: TEdit
      Left = 304
      Top = 48
      Width = 57
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '0'
      OnChange = SheltBfrTaxChange
      OnKeyPress = SemShBfrTaxKeyPress
    end
    object SemShAftTax: TEdit
      Left = 304
      Top = 80
      Width = 57
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      Text = 'SemShAftTax'
    end
    object OtherBfrTax: TEdit
      Left = 400
      Top = 48
      Width = 57
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = '0'
      OnChange = SheltBfrTaxChange
    end
    object OtherAftTax: TEdit
      Left = 400
      Top = 80
      Width = 57
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
      Text = 'OtherAftTax'
    end
    object NonShBtn: TSpinButton
      Left = 160
      Top = 48
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800300808000808000808000
        8080000000008080008080008080008080020080800080800080800000000000
        0000000000808000808000808000008080008080000000000000000000000000
        0000000080800080800000808000000000000000000000000000000000000000
        0000008080000080800080800080800080800080800080800080800080800080
        8001}
      TabOrder = 8
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808001008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080000080800080800080800080800080800080800080800080800080
        8000}
      OnDownClick = NonShBtnDownClick
      OnUpClick = NonShBtnUpClick
    end
    object SheltBtn: TSpinButton
      Left = 264
      Top = 48
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800300808000808000808000
        8080000000008080008080008080008080020080800080800080800000000000
        0000000000808000808000808000008080008080000000000000000000000000
        0000000080800080800000808000000000000000000000000000000000000000
        0000008080000080800080800080800080800080800080800080800080800080
        8001}
      TabOrder = 9
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808001008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080000080800080800080800080800080800080800080800080800080
        8000}
      OnDownClick = SheltBtnDownClick
      OnUpClick = SheltBtnUpClick
    end
    object SemShBtn: TSpinButton
      Left = 360
      Top = 48
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800300808000808000808000
        8080000000008080008080008080008080020080800080800080800000000000
        0000000000808000808000808000008080008080000000000000000000000000
        0000000080800080800000808000000000000000000000000000000000000000
        0000008080000080800080800080800080800080800080800080800080800080
        8001}
      TabOrder = 10
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808001008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080000080800080800080800080800080800080800080800080800080
        8000}
      OnDownClick = SemShBtnDownClick
      OnUpClick = SemShBtnUpClick
    end
    object OthBtn: TSpinButton
      Left = 456
      Top = 48
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800300808000808000808000
        8080000000008080008080008080008080020080800080800080800000000000
        0000000000808000808000808000008080008080000000000000000000000000
        0000000080800080800000808000000000000000000000000000000000000000
        0000008080000080800080800080800080800080800080800080800080800080
        8001}
      TabOrder = 11
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808001008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080000080800080800080800080800080800080800080800080800080
        8000}
      OnDownClick = OthBtnDownClick
      OnUpClick = OthBtnUpClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 32
    Top = 496
    Width = 649
    Height = 185
    Caption = 'Investment balance at retirement (Calculated)'
    Color = 14933196
    ParentColor = False
    TabOrder = 2
    Visible = False
    object Label48: TLabel
      Left = 64
      Top = 88
      Width = 43
      Height = 15
      Caption = 'Current'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label49: TLabel
      Left = 32
      Top = 112
      Width = 75
      Height = 15
      Caption = 'At retirement'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 120
      Top = 56
      Width = 84
      Height = 15
      Caption = 'Non-Sheltered '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label14: TLabel
      Left = 216
      Top = 56
      Width = 55
      Height = 15
      Caption = 'Sheltered'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label15: TLabel
      Left = 296
      Top = 56
      Width = 91
      Height = 15
      Caption = 'Semi-Sheltered '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label16: TLabel
      Left = 408
      Top = 56
      Width = 32
      Height = 15
      Caption = 'Other'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 488
      Top = 56
      Width = 27
      Height = 15
      Caption = 'Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Left = 8
      Top = 136
      Width = 95
      Height = 15
      Caption = 'Left in the Estate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label19: TLabel
      Left = 120
      Top = 24
      Width = 421
      Height = 14
      Caption = 
        'Balances are based on above contributions and rates, Shortfall w' +
        'ithdrawals, '
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label20: TLabel
      Left = 120
      Top = 40
      Width = 409
      Height = 14
      Caption = 
        'RIF withdrawals and any Special Life Events contributions and wi' +
        'thdrawals'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Shape7: TShape
      Left = 112
      Top = 72
      Width = 89
      Height = 89
      Brush.Style = bsClear
    end
    object Shape8: TShape
      Left = 200
      Top = 72
      Width = 89
      Height = 89
      Brush.Style = bsClear
    end
    object Shape9: TShape
      Left = 288
      Top = 72
      Width = 89
      Height = 89
      Brush.Style = bsClear
    end
    object Shape10: TShape
      Left = 376
      Top = 72
      Width = 81
      Height = 89
      Brush.Style = bsClear
    end
    object Shape11: TShape
      Left = 456
      Top = 72
      Width = 89
      Height = 89
      Brush.Style = bsClear
    end
    object NonShBalBox: TEdit
      Left = 120
      Top = 104
      Width = 73
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
      Text = '0'
    end
    object SheltBalBox: TEdit
      Left = 208
      Top = 104
      Width = 73
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      Text = '0'
    end
    object SemShBalBox: TEdit
      Left = 296
      Top = 104
      Width = 73
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 7
      Text = '0'
    end
    object OtherBalBox: TEdit
      Left = 384
      Top = 104
      Width = 65
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 8
      Text = '0'
    end
    object TotValAtRetirementBox: TEdit
      Left = 464
      Top = 104
      Width = 73
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
      Text = '0'
    end
    object NonShCurBalBox: TEdit
      Left = 120
      Top = 80
      Width = 73
      Height = 22
      Hint = 'Double click to change'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      Text = '0'
      OnDblClick = NonShCurBalBoxDblClick
      OnKeyPress = NonShCurBalBoxKeyPress
    end
    object SheltCurBalBox: TEdit
      Left = 208
      Top = 80
      Width = 73
      Height = 22
      Hint = 'Double click to change'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      Text = '0'
      OnDblClick = SheltCurBalBoxDblClick
      OnKeyPress = SheltCurBalBoxKeyPress
    end
    object SemShCurBalBox: TEdit
      Left = 296
      Top = 80
      Width = 73
      Height = 22
      Hint = 'Double click to change'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 2
      Text = '0'
      OnDblClick = SemShCurBalBoxDblClick
      OnKeyPress = SemShCurBalBoxKeyPress
    end
    object OtherCurBalBox: TEdit
      Left = 384
      Top = 80
      Width = 65
      Height = 22
      Hint = 'Double click to change'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 3
      Text = '0'
      OnDblClick = OtherCurBalBoxDblClick
      OnKeyPress = OtherCurBalBoxKeyPress
    end
    object TotCurBalBox: TEdit
      Left = 464
      Top = 80
      Width = 73
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = '0'
    end
    object NonShEstateBox: TEdit
      Left = 120
      Top = 131
      Width = 73
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 10
      Text = '0'
    end
    object SheltEstateBox: TEdit
      Left = 208
      Top = 131
      Width = 73
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 11
      Text = '0'
    end
    object SemShEstateBox: TEdit
      Left = 296
      Top = 131
      Width = 73
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 12
      Text = '0'
    end
    object OtherEstateBox: TEdit
      Left = 384
      Top = 131
      Width = 65
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 13
      Text = '0'
    end
    object TotEstateValBox: TEdit
      Left = 464
      Top = 131
      Width = 73
      Height = 22
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 14
      Text = '0'
    end
  end
  object NonShTotalBox: TEdit
    Left = 208
    Top = 352
    Width = 65
    Height = 23
    TabStop = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    Text = '0'
  end
  object SheltTotalBox: TEdit
    Left = 312
    Top = 352
    Width = 73
    Height = 23
    TabStop = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    Text = '0'
  end
  object SemShTotalBox: TEdit
    Left = 408
    Top = 352
    Width = 73
    Height = 23
    TabStop = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    Text = '0'
    OnKeyPress = IncGoalBoxKeyPress
  end
  object OtherTotalBox: TEdit
    Left = 504
    Top = 352
    Width = 73
    Height = 23
    TabStop = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 6
    Text = '0'
  end
  object Panel1: TPanel
    Left = 24
    Top = 56
    Width = 657
    Height = 153
    Color = 14933196
    TabOrder = 7
    object Label21: TLabel
      Left = 8
      Top = 72
      Width = 108
      Height = 15
      Caption = 'Disposable Income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label23: TLabel
      Left = 288
      Top = 72
      Width = 55
      Height = 15
      Caption = 'Sheltered'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label24: TLabel
      Left = 288
      Top = 96
      Width = 91
      Height = 15
      Caption = 'Semi-Sheltered '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label26: TLabel
      Left = 288
      Top = 120
      Width = 32
      Height = 15
      Caption = 'Other'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label28: TLabel
      Left = 569
      Top = 72
      Width = 20
      Height = 14
      Caption = 'Max'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label33: TLabel
      Left = 400
      Top = 24
      Width = 11
      Height = 15
      Caption = '%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label34: TLabel
      Left = 488
      Top = 24
      Width = 49
      Height = 15
      Caption = '$Amount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 88
      Width = 142
      Height = 15
      Caption = 'available for investments'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape5: TShape
      Left = 232
      Top = 56
      Width = 1
      Height = 73
      Brush.Color = clBlack
    end
    object Label17: TLabel
      Left = 288
      Top = 48
      Width = 81
      Height = 15
      Caption = 'Non-Sheltered'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape1: TShape
      Left = 232
      Top = 56
      Width = 47
      Height = 2
      Brush.Color = clBlack
    end
    object Shape2: TShape
      Left = 232
      Top = 80
      Width = 47
      Height = 2
      Brush.Color = clBlack
    end
    object Shape3: TShape
      Left = 232
      Top = 104
      Width = 47
      Height = 2
      Brush.Color = clBlack
    end
    object Shape4: TShape
      Left = 232
      Top = 128
      Width = 47
      Height = 2
      Brush.Color = clBlack
    end
    object Label4: TLabel
      Left = 424
      Top = 8
      Width = 56
      Height = 15
      Caption = 'Allocation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DispIncBox: TEdit
      Left = 160
      Top = 80
      Width = 65
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = '0'
      OnKeyPress = IncGoalBoxKeyPress
    end
    object NonShAmountBox: TEdit
      Left = 480
      Top = 40
      Width = 73
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
    object SheltAmountBox: TEdit
      Left = 480
      Top = 64
      Width = 73
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
    object SemShAmountBox: TEdit
      Left = 480
      Top = 88
      Width = 73
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      Text = '0'
    end
    object OtherAmountBox: TEdit
      Left = 480
      Top = 112
      Width = 73
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = '0'
    end
    object NonShPercentBox: TEdit
      Left = 392
      Top = 40
      Width = 41
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = '0'
    end
    object SheltPerCentBox: TEdit
      Left = 392
      Top = 64
      Width = 41
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Text = '0'
      OnChange = SheltPerCentBoxChange
      OnExit = SheltPerCentBoxExit
    end
    object SemShPercentBox: TEdit
      Left = 392
      Top = 88
      Width = 41
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Text = '0'
      OnChange = SemShPercentBoxChange
      OnExit = SemShPercentBoxExit
    end
    object OtherPercentBox: TEdit
      Left = 392
      Top = 112
      Width = 41
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Text = '0'
      OnChange = OtherPercentBoxChange
      OnExit = RecalcBtnClick
    end
    object SheltPercentBtn: TSpinButton
      Left = 440
      Top = 64
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800200808000808000808000
        8080000000008080008080008080008080000080800080800080800000000000
        0000000000808000808000808081008080008080000000000000000000000000
        0000000080800080800100808000000000000000000000000000000000000000
        0000008080030080800080800080800080800080800080800080800080800080
        8003}
      TabOrder = 9
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808081008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080030080800080800080800080800080800080800080800080800080
        8003}
      OnDownClick = SheltPercentBtnDownClick
      OnUpClick = SheltPercentBtnUpClick
    end
    object SemShPercentBtn: TSpinButton
      Left = 440
      Top = 88
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800200808000808000808000
        8080000000008080008080008080008080000080800080800080800000000000
        0000000000808000808000808081008080008080000000000000000000000000
        0000000080800080800100808000000000000000000000000000000000000000
        0000008080030080800080800080800080800080800080800080800080800080
        8003}
      TabOrder = 10
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808081008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080030080800080800080800080800080800080800080800080800080
        8003}
      OnDownClick = SemShPercentBtnDownClick
      OnUpClick = SemShPercentBtnUpClick
    end
    object OtherPercentBtn: TSpinButton
      Left = 440
      Top = 112
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800200808000808000808000
        8080000000008080008080008080008080000080800080800080800000000000
        0000000000808000808000808081008080008080000000000000000000000000
        0000000080800080800100808000000000000000000000000000000000000000
        0000008080030080800080800080800080800080800080800080800080800080
        8003}
      TabOrder = 11
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808081008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080030080800080800080800080800080800080800080800080800080
        8003}
      OnDownClick = OtherPercentBtnDownClick
      OnUpClick = OtherPercentBtnUpClick
    end
    object RRSProomBox: TEdit
      Left = 592
      Top = 64
      Width = 41
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 12
      Text = '0'
      OnKeyPress = RRSProomBoxKeyPress
    end
    object InvestDisposableBox: TCheckBox
      Left = 40
      Top = 112
      Width = 185
      Height = 17
      Caption = 'Invest it year after year?'
      TabOrder = 13
      OnClick = InvestDisposableBoxClick
    end
  end
  object Panel3: TPanel
    Left = 24
    Top = 216
    Width = 657
    Height = 113
    Color = 14933196
    TabOrder = 8
    object Label6: TLabel
      Left = 16
      Top = 64
      Width = 63
      Height = 15
      Caption = 'Tax Refund'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 16
      Top = 48
      Width = 70
      Height = 15
      Caption = 'Allocation of'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 288
      Top = 40
      Width = 55
      Height = 15
      Caption = 'Sheltered'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label22: TLabel
      Left = 288
      Top = 64
      Width = 91
      Height = 15
      Caption = 'Semi-Sheltered '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label27: TLabel
      Left = 288
      Top = 88
      Width = 32
      Height = 15
      Caption = 'Other'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label35: TLabel
      Left = 288
      Top = 16
      Width = 81
      Height = 15
      Caption = 'Non-Sheltered'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape6: TShape
      Left = 232
      Top = 24
      Width = 1
      Height = 73
      Brush.Color = clBlack
    end
    object Shape12: TShape
      Left = 232
      Top = 24
      Width = 47
      Height = 2
      Brush.Color = clBlack
    end
    object Shape13: TShape
      Left = 232
      Top = 48
      Width = 47
      Height = 2
      Brush.Color = clBlack
    end
    object Shape14: TShape
      Left = 232
      Top = 72
      Width = 47
      Height = 2
      Brush.Color = clBlack
    end
    object Shape15: TShape
      Left = 232
      Top = 96
      Width = 47
      Height = 2
      Brush.Color = clBlack
    end
    object TaxRefundBox: TEdit
      Left = 160
      Top = 48
      Width = 65
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      Text = '0'
    end
    object NonShRefundAmountBox: TEdit
      Left = 480
      Top = 8
      Width = 73
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = '0'
    end
    object SheltRefundAmountBox: TEdit
      Left = 480
      Top = 32
      Width = 73
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
    object SemShRefundAmountBox: TEdit
      Left = 480
      Top = 56
      Width = 73
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      Text = '0'
    end
    object OtherRefundAmountBox: TEdit
      Left = 480
      Top = 80
      Width = 73
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
      Text = '0'
    end
    object NonShRefundPercentBox: TEdit
      Left = 392
      Top = 8
      Width = 41
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = '0'
    end
    object SheltRefundPercentBox: TEdit
      Left = 392
      Top = 32
      Width = 41
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Text = '0'
      OnChange = SheltRefundPercentBoxChange
    end
    object SemShRefundPercentBox: TEdit
      Left = 392
      Top = 56
      Width = 41
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Text = '0'
      OnChange = SemShRefundPercentBoxChange
    end
    object OtherRefundPercentBox: TEdit
      Left = 392
      Top = 80
      Width = 41
      Height = 23
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Text = '0'
      OnChange = OtherRefundPercentBoxChange
    end
    object SheltRefundPercentBtn: TSpinButton
      Left = 440
      Top = 32
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800300808000808000808000
        8080000000008080008080008080008080030080800080800080800000000000
        0000000000808000808000808003008080008080000000000000000000000000
        0000000080800080800300808000000000000000000000000000000000000000
        0000008080030080800080800080800080800080800080800080800080800080
        8000}
      TabOrder = 9
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808000008080008080008080000000000000000000
        0080800080800080800000808000808000808000808000000000808000808000
        8080008080030080800080800080800080800080800080800080800080800080
        8003}
      OnDownClick = SheltRefundPercentBtnDownClick
      OnUpClick = SheltRefundPercentBtnUpClick
    end
    object SemShRefundPercentBtn: TSpinButton
      Left = 440
      Top = 56
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800300808000808000808000
        8080000000008080008080008080008080030080800080800080800000000000
        0000000000808000808000808003008080008080000000000000000000000000
        0000000080800080800300808000000000000000000000000000000000000000
        0000008080030080800080800080800080800080800080800080800080800080
        8000}
      TabOrder = 10
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808000008080008080008080000000000000000000
        0080800080800080800000808000808000808000808000000000808000808000
        8080008080030080800080800080800080800080800080800080800080800080
        8003}
      OnDownClick = SemShRefundPercentBtnDownClick
      OnUpClick = SemShRefundPercentBtnUpClick
    end
    object OtherRefundPercentBtn: TSpinButton
      Left = 440
      Top = 80
      Width = 25
      Height = 22
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800300808000808000808000
        8080000000008080008080008080008080030080800080800080800000000000
        0000000000808000808000808003008080008080000000000000000000000000
        0000000080800080800300808000000000000000000000000000000000000000
        0000008080030080800080800080800080800080800080800080800080800080
        8000}
      TabOrder = 11
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800000808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808000008080008080008080000000000000000000
        0080800080800080800000808000808000808000808000000000808000808000
        8080008080030080800080800080800080800080800080800080800080800080
        8003}
      OnDownClick = OtherRefundPercentBtnDownClick
      OnUpClick = OtherRefundPercentBtnUpClick
    end
    object InvestTaxRefundBox: TCheckBox
      Left = 32
      Top = 80
      Width = 185
      Height = 17
      Caption = 'Invest it year after year?'
      TabOrder = 12
      OnClick = InvestTaxRefundBoxClick
    end
  end
  object CancelBtn: TBitBtn
    Left = 616
    Top = 352
    Width = 65
    Height = 25
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'System'
    Font.Style = [fsBold]
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 9
    OnClick = CancelBtnClick
  end
end
