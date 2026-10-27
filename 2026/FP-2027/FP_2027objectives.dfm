object ObjectivesFP_2012: TObjectivesFP_2012
  Left = 170
  Top = 145
  Caption = 'ObjectivesFP_2012'
  ClientHeight = 360
  ClientWidth = 706
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 706
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Specific Objectives'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 714
    object CancelBtn: TBitBtn
      Left = 608
      Top = 8
      Width = 65
      Height = 25
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4194368
      Font.Height = -11
      Font.Name = 'System'
      Font.Style = [fsBold]
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = CancelBtnClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 706
    Height = 319
    Align = alClient
    Color = 14675693
    TabOrder = 1
    ExplicitWidth = 714
    ExplicitHeight = 331
    object Label1: TLabel
      Left = 240
      Top = 296
      Width = 259
      Height = 16
      Caption = 'For additional objectives see also Life Events'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object GroupBox2: TGroupBox
      Left = 32
      Top = 32
      Width = 249
      Height = 249
      Caption = 'Retirement Objectives'
      Color = 14933196
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      object Label20: TLabel
        Left = 8
        Top = 120
        Width = 119
        Height = 16
        Caption = 'Desired cost of living'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label30: TLabel
        Left = 8
        Top = 40
        Width = 132
        Height = 16
        Caption = 'Retirement Age - client'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 8
        Top = 152
        Width = 73
        Height = 16
        Caption = 'Ultimate age'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label50: TLabel
        Left = 8
        Top = 80
        Width = 143
        Height = 16
        Caption = 'Retirement Age - spouse'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object RetAgeBox: TEdit
        Left = 160
        Top = 40
        Width = 25
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 2
        ParentFont = False
        TabOrder = 0
        Text = '0'
      end
      object IncGoalBox: TEdit
        Left = 160
        Top = 120
        Width = 65
        Height = 22
        Hint = 'Double click to change'
        TabStop = False
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
        OnDblClick = IncGoalBoxDblClick
        OnKeyPress = IncGoalBoxKeyPress
      end
      object AgeBtn: TSpinButton
        Left = 184
        Top = 40
        Width = 20
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
        TabOrder = 2
        UpGlyph.Data = {
          DE000000424DDE00000000000000360000002800000009000000060000000100
          180000000000A800000000000000000000000000000000000000008080008080
          0080800080800080800080800080800080800080800000808000000000000000
          0000000000000000000000000000008080000080800080800000000000000000
          0000000000000000808000808001008080008080008080000000000000000000
          0080800080800080808100808000808000808000808000000000808000808000
          8080008080000080800080800080800080800080800080800080800080800080
          8000}
        OnDownClick = AgeBtnDownClick
        OnUpClick = AgeBtnUpClick
      end
      object SpRetAgeBox: TEdit
        Left = 160
        Top = 80
        Width = 25
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 2
        ParentFont = False
        TabOrder = 3
        Text = '0'
      end
      object SpAgeBtn: TSpinButton
        Left = 184
        Top = 80
        Width = 20
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
        TabOrder = 4
        UpGlyph.Data = {
          DE000000424DDE00000000000000360000002800000009000000060000000100
          180000000000A800000000000000000000000000000000000000008080008080
          0080800080800080800080800080800080800080800000808000000000000000
          0000000000000000000000000000008080000080800080800000000000000000
          0000000000000000808000808001008080008080008080000000000000000000
          0080800080800080808100808000808000808000808000000000808000808000
          8080008080000080800080800080800080800080800080800080800080800080
          8000}
        OnDownClick = SpAgeBtnDownClick
        OnUpClick = SpAgeBtnUpClick
      end
      object PlanAgeBox: TEdit
        Left = 160
        Top = 152
        Width = 33
        Height = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 2
        ParentFont = False
        TabOrder = 5
        Text = '0'
      end
      object PlanAgeBtn: TSpinButton
        Left = 192
        Top = 152
        Width = 20
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
        TabOrder = 6
        UpGlyph.Data = {
          DE000000424DDE00000000000000360000002800000009000000060000000100
          180000000000A800000000000000000000000000000000000000008080008080
          0080800080800080800080800080800080800080800000808000000000000000
          0000000000000000000000000000008080000080800080800000000000000000
          0000000000000000808000808001008080008080008080000000000000000000
          0080800080800080808100808000808000808000808000000000808000808000
          8080008080000080800080800080800080800080800080800080800080800080
          8000}
        OnDownClick = PlanAgeBtnDownClick
        OnUpClick = PlanAgeBtnUpClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 296
      Top = 32
      Width = 177
      Height = 249
      Caption = 'Investment Objectives'
      Color = 14933196
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      object Label32: TLabel
        Left = 24
        Top = 40
        Width = 79
        Height = 16
        Caption = 'Capital safety'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label33: TLabel
        Left = 24
        Top = 64
        Width = 56
        Height = 16
        Caption = 'Cash flow'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label34: TLabel
        Left = 24
        Top = 88
        Width = 72
        Height = 16
        Caption = 'Appreciation'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label35: TLabel
        Left = 24
        Top = 112
        Width = 71
        Height = 16
        Caption = 'Tax Benefits'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label36: TLabel
        Left = 24
        Top = 136
        Width = 48
        Height = 16
        Caption = 'Liquidity'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label37: TLabel
        Left = 24
        Top = 160
        Width = 27
        Height = 16
        Caption = 'Debt'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label38: TLabel
        Left = 24
        Top = 184
        Width = 63
        Height = 16
        Caption = 'Risk/return'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label39: TLabel
        Left = 24
        Top = 208
        Width = 54
        Height = 16
        Caption = 'Mgt effort'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label47: TLabel
        Left = 48
        Top = 24
        Width = 106
        Height = 16
        Caption = 'Preferences (1-8)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SafetyBox: TComboBox
        Left = 120
        Top = 40
        Width = 41
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = 'SafetyBox'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8')
      end
      object CashFlowBox: TComboBox
        Left = 120
        Top = 64
        Width = 41
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = 'CashFlowBox'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8')
      end
      object AppreciationBox: TComboBox
        Left = 120
        Top = 88
        Width = 41
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = 'AppreciationBox'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8')
      end
      object TaxBenefitsBox: TComboBox
        Left = 120
        Top = 112
        Width = 41
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = 'TaxBenefitsBox'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8')
      end
      object LiquidityBox: TComboBox
        Left = 120
        Top = 136
        Width = 41
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        Text = 'LiquidityBox'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8')
      end
      object DebtBox: TComboBox
        Left = 120
        Top = 160
        Width = 41
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Text = 'DebtBox'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8')
      end
      object RiskReturnBox: TComboBox
        Left = 120
        Top = 184
        Width = 41
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        Text = 'RiskReturnBox'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8')
      end
      object MgtEffortBox: TComboBox
        Left = 120
        Top = 208
        Width = 41
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        Text = 'MgtEffortBox'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8')
      end
    end
    object GroupBox4: TGroupBox
      Left = 488
      Top = 32
      Width = 185
      Height = 249
      Caption = 'Risk Tolerance'
      Color = 14933196
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 2
      object RiskToleranceBox: TRadioGroup
        Left = 24
        Top = 48
        Width = 113
        Height = 129
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Items.Strings = (
          'Low'
          'Medium'
          'High')
        ParentFont = False
        TabOrder = 0
      end
    end
  end
end
