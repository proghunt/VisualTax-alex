object IncomeStreamCalculatorFP_2012: TIncomeStreamCalculatorFP_2012
  Left = 98
  Top = 80
  ClientHeight = 483
  ClientWidth = 678
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ImageX: TImage
    Left = 0
    Top = 129
    Width = 678
    Height = 177
    Align = alTop
    ExplicitWidth = 686
  end
  object ListBox1: TListBox
    Left = 0
    Top = 306
    Width = 678
    Height = 177
    Align = alClient
    Columns = 4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 678
    Height = 88
    Align = alTop
    BevelOuter = bvLowered
    Color = clSilver
    TabOrder = 0
    ExplicitWidth = 686
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 86
      Height = 15
      Caption = 'Starting income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 280
      Top = 16
      Width = 112
      Height = 15
      Caption = 'For Number of years'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 232
      Top = 16
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
    object Label3: TLabel
      Left = 152
      Top = 16
      Width = 72
      Height = 15
      Caption = 'Yearly growth'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object AmountBox: TEdit
      Left = 16
      Top = 40
      Width = 81
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '10000'
    end
    object YearsBox: TEdit
      Left = 304
      Top = 40
      Width = 41
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 2
      ParentFont = False
      TabOrder = 4
      Text = '10'
    end
    object CalcBtn: TBitBtn
      Left = 432
      Top = 31
      Width = 89
      Height = 33
      Caption = 'Calculate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = CalcBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 536
      Top = 31
      Width = 81
      Height = 33
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 7
      OnClick = CancelBtnClick
    end
    object IndexByBox: TEdit
      Left = 160
      Top = 40
      Width = 49
      Height = 21
      TabOrder = 2
      Text = '10'
    end
    object GrowthSpin: TSpinButton
      Left = 216
      Top = 40
      Width = 20
      Height = 21
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800200808000808000808000
        8080000000008080008080008080008080000080800080800080800000000000
        0000000000808000808000808002008080008080000000000000000000000000
        0000000080800080800000808000000000000000000000000000000000000000
        0000008080000080800080800080800080800080800080800080800080800080
        8000}
      TabOrder = 3
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800200808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808002008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080020080800080800080800080800080800080800080800080800080
        8003}
      OnDownClick = GrowthSpinDownClick
      OnUpClick = GrowthSpinUpClick
    end
    object AmountSpinBox: TSpinButton
      Left = 104
      Top = 40
      Width = 20
      Height = 21
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800200808000808000808000
        8080000000008080008080008080008080000080800080800080800000000000
        0000000000808000808000808002008080008080000000000000000000000000
        0000000080800080800000808000000000000000000000000000000000000000
        0000008080000080800080800080800080800080800080800080800080800080
        8000}
      TabOrder = 1
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800200808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808002008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080020080800080800080800080800080800080800080800080800080
        8003}
      OnDownClick = AmountSpinBoxDownClick
      OnUpClick = AmountSpinBoxUpClick
    end
    object YearsSpin: TSpinButton
      Left = 352
      Top = 40
      Width = 20
      Height = 21
      DownGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800200808000808000808000
        8080000000008080008080008080008080000080800080800080800000000000
        0000000000808000808000808002008080008080000000000000000000000000
        0000000080800080800000808000000000000000000000000000000000000000
        0000008080000080800080800080800080800080800080800080800080800080
        8000}
      TabOrder = 5
      UpGlyph.Data = {
        DE000000424DDE00000000000000360000002800000009000000060000000100
        180000000000A800000000000000000000000000000000000000008080008080
        0080800080800080800080800080800080800080800200808000000000000000
        0000000000000000000000000000008080000080800080800000000000000000
        0000000000000000808000808002008080008080008080000000000000000000
        0080800080800080808100808000808000808000808000000000808000808000
        8080008080020080800080800080800080800080800080800080800080800080
        8003}
      OnDownClick = YearsSpinDownClick
      OnUpClick = YearsSpinUpClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 678
    Height = 41
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    ExplicitWidth = 686
    object Label4: TLabel
      Left = 248
      Top = 10
      Width = 160
      Height = 26
      Caption = 'Income Growth'
    end
  end
end
