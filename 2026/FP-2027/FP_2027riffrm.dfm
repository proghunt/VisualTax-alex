object RIFFrmFP_2012: TRIFFrmFP_2012
  Left = 187
  Top = 103
  Width = 659
  Height = 534
  Caption = 'RRIF '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 142
    Top = 35
    Width = 80
    Height = 13
    Caption = 'RRIF set-up year'
  end
  object Label2: TLabel
    Left = 281
    Top = 35
    Width = 82
    Height = 13
    Caption = 'Opening Balance'
  end
  object Label3: TLabel
    Left = 429
    Top = 35
    Width = 70
    Height = 13
    Caption = 'Rate of Return'
  end
  object ImageX: TImage
    Left = 16
    Top = 142
    Width = 609
    Height = 177
  end
  object Label4: TLabel
    Left = 44
    Top = 35
    Width = 44
    Height = 13
    Caption = 'BirthDate'
  end
  object Label5: TLabel
    Left = 37
    Top = 49
    Width = 68
    Height = 13
    Caption = 'YYYY-MM-DD'
  end
  object RulesBtn: TRadioGroup
    Left = 16
    Top = 87
    Width = 265
    Height = 47
    Caption = 'Rules applied'
    Items.Strings = (
      'New Rules'
      'Old Rules (set up prior to 1993)')
    TabOrder = 0
    OnClick = RulesBtnClick
  end
  object YrStart: TEdit
    Left = 155
    Top = 62
    Width = 41
    Height = 21
    MaxLength = 4
    TabOrder = 1
    Text = '2000'
    OnExit = YrStartExit
  end
  object OpBalance: TEdit
    Left = 285
    Top = 55
    Width = 81
    Height = 21
    TabOrder = 2
    Text = '100000'
    OnChange = OpBalanceChange
    OnExit = OpBalanceExit
  end
  object Rte: TEdit
    Left = 432
    Top = 55
    Width = 49
    Height = 21
    TabOrder = 3
    Text = '10'
    OnExit = RteExit
  end
  object RateSpin: TSpinButton
    Left = 487
    Top = 55
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
    TabOrder = 4
    UpGlyph.Data = {
      DE000000424DDE00000000000000360000002800000009000000060000000100
      180000000000A800000000000000000000000000000000000000008080008080
      0080800080800080800080800080800080800080800200808000000000000000
      0000000000000000000000000000008080000080800080800000000000000000
      0000000000000000808000808002008080008080008080000000000000000000
      0080800080800080808100808000808000808000808000000000808000808000
      8080008080020080800080800080800080800080800080800080800080800080
      8003}
    OnDownClick = RateSpinDownClick
    OnUpClick = RateSpinUpClick
  end
  object CancelBtn: TBitBtn
    Left = 512
    Top = 95
    Width = 89
    Height = 39
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
  object CalcBtn: TBitBtn
    Left = 432
    Top = 95
    Width = 65
    Height = 39
    Caption = 'Calc'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'System'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = CalcBtnClick
  end
  object ByYearOrAge: TRadioGroup
    Left = 292
    Top = 87
    Width = 129
    Height = 47
    Caption = 'Chart By year or Age'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Items.Strings = (
      'By Year'
      'By Age')
    ParentFont = False
    TabOrder = 7
    OnClick = ByYearOrAgeClick
  end
  object StringGrid2: TStringGrid
    Left = 121
    Top = 326
    Width = 429
    Height = 161
    ColCount = 6
    DefaultRowHeight = 18
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowSelect]
    ParentFont = False
    TabOrder = 8
    ColWidths = (
      64
      38
      72
      70
      75
      78)
  end
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 651
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'RIF Calculator'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
  end
  object BirthdateBox: TEdit
    Left = 29
    Top = 62
    Width = 77
    Height = 21
    TabOrder = 10
    OnExit = BirthdateBoxExit
  end
end
