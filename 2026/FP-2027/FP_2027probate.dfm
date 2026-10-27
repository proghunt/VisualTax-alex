object ProbateFP_2012: TProbateFP_2012
  Left = 54
  Top = 0
  Caption = 'Probate Fees'
  ClientHeight = 531
  ClientWidth = 742
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 25
    Width = 742
    Height = 109
    Align = alTop
    Color = 15532031
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'Your executor has to determine if your will has to be probated t' +
        'hat is, if court approval must be obtained  to '
      'settle the estate and transfer the ownership of your assets. '
      ''
      
        'Probate fees are paid out of the estate generally to the provinc' +
        'ial court of the province where you lived '
      'when you died. '
      
        'The fees are based on the value of the assets that flow through ' +
        'your will.'
      'Each province has a different fee schedule.')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    ExplicitWidth = 750
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Probate Fees'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    ExplicitWidth = 750
  end
  object Chart1: TChart
    Left = 0
    Top = 207
    Width = 742
    Height = 324
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Border.Visible = True
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = 16777156
    Gradient.Visible = True
    Legend.Visible = False
    Title.Font.Charset = ANSI_CHARSET
    Title.Font.Color = clNavy
    Title.Font.Height = -16
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      'Probate Fees (Estate in Thousands)')
    LeftAxis.Title.Caption = 'FEE'
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 750
    ExplicitHeight = 336
    ColorPaletteIndex = 13
    object Series1: TBarSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.ShapeStyle = fosRoundRectangle
      Marks.Visible = False
      SeriesColor = clRed
      BarStyle = bsRectGradient
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 134
    Width = 742
    Height = 73
    Align = alTop
    Caption = 'Specific Estate '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnExit = GroupBox1Exit
    ExplicitWidth = 750
    object Label2: TLabel
      Left = 220
      Top = 16
      Width = 74
      Height = 15
      Caption = 'Probate Fees'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 17
      Top = 16
      Width = 67
      Height = 15
      Caption = 'Estate value'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 129
      Top = 16
      Width = 47
      Height = 15
      Caption = 'Province'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 521
      Top = 9
      Width = 64
      Height = 15
      Caption = 'Show Chart'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label5: TLabel
      Left = 507
      Top = 23
      Width = 92
      Height = 15
      Caption = 'for Estate Values'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label6: TLabel
      Left = 598
      Top = 9
      Width = 39
      Height = 15
      Caption = 'From $'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label7: TLabel
      Left = 500
      Top = 44
      Width = 23
      Height = 15
      Caption = 'To $'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object EstateValueBox: TEdit
      Left = 11
      Top = 40
      Width = 105
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = EstateValueBoxChange
      OnKeyPress = EstateValueBoxKeyPress
    end
    object CalcBtn: TBitBtn
      Left = 657
      Top = 15
      Width = 30
      Height = 17
      Caption = 'Calc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Visible = False
      OnExit = CalcBtnExit
    end
    object ProbateValueBox: TEdit
      Left = 216
      Top = 40
      Width = 97
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object CancelBtn: TBitBtn
      Left = 616
      Top = 35
      Width = 75
      Height = 29
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 4
      OnClick = CancelBtnClick
    end
    object XferFeesBtn: TBitBtn
      Left = 689
      Top = 15
      Width = 33
      Height = 17
      Caption = 'Transfer To Insurance Needs'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Visible = False
    end
    object PrvBox: TComboBox
      Left = 126
      Top = 42
      Width = 64
      Height = 20
      Style = csOwnerDrawFixed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 1
      OnChange = PrvBoxChange
      Items.Strings = (
        'AB'
        'BC'
        'MB'
        'NB'
        'NS'
        'NT'
        'NL'
        'NU'
        'ON'
        'PE'
        'QC'
        'SK'
        'YT'
        '')
    end
    object ShowChartBtn: TBitBtn
      Left = 693
      Top = 36
      Width = 29
      Height = 28
      Caption = 'Show Chart'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Visible = False
      OnClick = ShowChartBtnClick
      OnExit = CalcBtnExit
    end
    object MinEstateAxisBox: TEdit
      Left = 587
      Top = 19
      Width = 79
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Text = '0'
      Visible = False
      OnExit = MinEstateAxisBoxExit
    end
    object MaxEstateAxisBox: TEdit
      Left = 531
      Top = 40
      Width = 79
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Text = '1,000,000'
      Visible = False
    end
    object XferProbate: TCheckBox
      Left = 441
      Top = 42
      Width = 50
      Height = 17
      Caption = 'Transfer Fees to Ins. needs'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      Visible = False
    end
  end
end
