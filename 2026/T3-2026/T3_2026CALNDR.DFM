object Calndr: TCalndr
  Left = 289
  Top = 44
  Width = 286
  Height = 234
  Caption = 'Calendar'
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 16
  object Calendar1: TCalendar
    Left = 5
    Top = 8
    Width = 172
    Height = 161
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    StartOfWeek = 0
    TabOrder = 0
    UseCurrentDate = False
  end
  object MonthList: TListBox
    Left = 185
    Top = 8
    Width = 32
    Height = 161
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ItemHeight = 13
    Items.Strings = (
      'Jan'
      'Feb'
      'Mar'
      'Apr'
      'May'
      'Jun'
      'Jul'
      'Aug'
      'Sep'
      'Oct'
      'Nov'
      'Dec')
    ParentFont = False
    TabOrder = 1
    OnClick = MonthListClick
  end
  object YearList: TListBox
    Left = 224
    Top = 8
    Width = 33
    Height = 161
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ItemHeight = 13
    Items.Strings = (
      '1960'
      '1961'
      '1962'
      '1963'
      '1964'
      '1965'
      '1966'
      '1967'
      '1968'
      '1969'
      '1970'
      '1971')
    ParentFont = False
    TabOrder = 2
    OnClick = YearListClick
  end
  object SpinButton1: TSpinButton
    Left = 259
    Top = 8
    Width = 15
    Height = 161
    DownGlyph.Data = {
      DE000000424DDE00000000000000360000002800000009000000060000000100
      180000000000A800000000000000000000000000000000000000008080008080
      0080800080800080800080800080800080800080800000808000808000808000
      8080000000008080008080008080008080000080800080800080800000000000
      0000000000808000808000808000008080008080000000000000000000000000
      0000000080800080800000808000000000000000000000000000000000000000
      0000008080000080800080800080800080800080800080800080800080800080
      8000}
    TabOrder = 3
    UpGlyph.Data = {
      DE000000424DDE00000000000000360000002800000009000000060000000100
      180000000000A800000000000000000000000000000000000000008080008080
      0080800080800080800080800080800080800080800000808000000000000000
      0000000000000000000000000000008080000080800080800000000000000000
      0000000000000000808000808000008080008080008080000000000000000000
      0080800080800080800000808000808000808000808000000000808000808000
      8080008080000080800080800080800080800080800080800080800080800080
      8000}
    OnDownClick = SpinButton1DownClick
    OnUpClick = SpinButton1UpClick
  end
  object OkBtn: TButton
    Left = 96
    Top = 176
    Width = 89
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = OkBtnClick
  end
end
