object PopComboListT4T5_2026: TPopComboListT4T5_2026
  Left = 69
  Top = 103
  Width = 818
  Height = 625
  BorderIcons = [biSystemMenu]
  Caption = 'Select an item'
  Color = 13353654
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
    Left = 96
    Top = 8
    Width = 114
    Height = 16
    Caption = 'Type item or click it'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    OnClick = CancelBtnClick
  end
  object Label2: TLabel
    Left = 56
    Top = 24
    Width = 288
    Height = 16
    Caption = 'Note: Press the backspace to start a new search)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    OnClick = CancelBtnClick
  end
  object OKBtn: TBitBtn
    Left = 360
    Top = 40
    Width = 65
    Height = 33
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = OKBtnClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object CancelBtn: TBitBtn
    Left = 440
    Top = 40
    Width = 89
    Height = 33
    TabOrder = 2
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 48
    Width = 321
    Height = 24
    Style = csDropDownList
    DropDownCount = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    Sorted = True
    TabOrder = 0
    OnEnter = ComboBox1Enter
    OnKeyPress = ComboBox1KeyPress
  end
end
