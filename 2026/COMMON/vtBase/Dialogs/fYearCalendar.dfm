object YearCalendar: TYearCalendar
  Left = 242
  Top = 137
  BorderIcons = []
  Caption = 'Calendar  (C) Copyright Microsophic Inc.'
  ClientHeight = 406
  ClientWidth = 359
  Color = 13616305
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 208
    Top = 8
    Width = 21
    Height = 15
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Day'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 88
    Top = 8
    Width = 33
    Height = 15
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Month'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 8
    Width = 24
    Height = 15
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Year'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 168
    Top = 312
    Width = 94
    Height = 27
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Calendar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -19
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 136
    Top = 336
    Width = 189
    Height = 16
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '(C) Copyright Microsophic Inc.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Image1: TImage
    Left = 96
    Top = 312
    Width = 41
    Height = 33
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Picture.Data = {
      055449636F6E0000010001002020100000000000E80200001600000028000000
      2000000040000000010004000000000080020000000000000000000000000000
      0000000000000000000080000080000000808000800000008000800080800000
      C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
      FFFFFF0077777777777777777777777777777777777777777777777777777777
      7777777777888888888888888888888888888888778888888888888888888888
      8888888800000000000000000000000000000088000000000000000000000000
      00000088000F0FFFFFFFFF00FFFFFFFFF0F0008800F0FFFFFFFFFF00FFFFFFFF
      FF0F008800F0FFFFFFFFFF00FFFFFFFFFF0F008800F0F0000000F0000F000000
      0F0F008800F0FFFFFFFFF0FF0FFFFFFFFF0F008800F0F0000000FF00FF000000
      0F0F008800F0FFFFFFFFFF00FFFFFFFFFF0F008800F0FFFFFFFFFF00FFFFFFFF
      FF0F008800F0FFF9999FFF00FFF99999FF0F008800F0FFF9999FFF00FFF99999
      FF0F008800F0FFFF99FFFF00FFF99FFFFF0F008800F0FFFF99FFFF00FFF999FF
      FF0F008800F0FFFF99FFFF00FFFF999FFF0F008800F0FFFF99FFFF00FFFFF999
      FF0F008800F0FFF999FFF0000FF99F99FF0F008800F0FFF999FFF0FF0FF99999
      FF0F008800F0FFFF99FFFF00FFFF999FFF0F008800F0FFFFFFFFFF00FFFFFFFF
      FF0F0088000F0FFFFFFFFF00FFFFFFFFF0F00088000000000000000000000000
      0000007700000000000000000000000000000077777777777777777777777777
      7777777777777777777777777777777777777777777777777777777777777777
      7777777777777777777777777777777777777777777777777777777777777777
      7777777700000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000}
    Transparent = True
  end
  object Bevel1: TBevel
    Left = 80
    Top = 280
    Width = 273
    Height = 9
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Shape = bsBottomLine
  end
  object Bevel2: TBevel
    Left = 79
    Top = 368
    Width = 273
    Height = 9
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Shape = bsBottomLine
  end
  object Calendar1: TCalendar
    Left = 141
    Top = 24
    Width = 196
    Height = 177
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    StartOfWeek = 0
    TabOrder = 2
    UseCurrentDate = False
    OnClick = Calendar1Click
    OnChange = Calendar1Change
  end
  object MonthList: TListBox
    Left = 88
    Top = 24
    Width = 41
    Height = 177
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
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
    Left = 16
    Top = 24
    Width = 57
    Height = 353
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
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
    TabOrder = 0
    OnClick = YearListClick
  end
  object SpinButton1: TSpinButton
    Left = 115
    Top = 216
    Width = 15
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
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
    Visible = False
    OnDownClick = SpinButton1DownClick
    OnUpClick = SpinButton1UpClick
  end
  object OkBtn: TButton
    Left = 160
    Top = 216
    Width = 49
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 4
    OnClick = OkBtnClick
  end
  object PickedDate: TEdit
    Left = 184
    Top = 248
    Width = 81
    Height = 26
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object CancelBtn: TBitBtn
    Left = 232
    Top = 216
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 6
    OnClick = CancelBtnClick
  end
end
