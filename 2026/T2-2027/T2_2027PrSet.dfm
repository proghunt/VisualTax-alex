object PrSetT2_2027: TPrSetT2_2027
  Left = 212
  Top = 133
  Caption = 'Build Print Templates (Print set) '
  ClientHeight = 629
  ClientWidth = 619
  Color = 13353654
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 71
    Width = 128
    Height = 20
    Caption = 'Forms Available'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CurrentSetLabel: TLabel
    Left = 422
    Top = 79
    Width = 153
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'Print Set: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 430
    Top = 63
    Width = 153
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'Forms to print for:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object AddAllBtn: TBitBtn
    Left = 312
    Top = 215
    Width = 123
    Height = 49
    Hint = 'Add All forms'
    Caption = 'Add All '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Glyph.Data = {
      7E010000424D7E01000000000000760000002800000014000000160000000100
      0400000000000801000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888800008888888888888888888800008888888888088888888800008888
      8888880088888888000088888888880C08888888000088888888880CC0888888
      000088888888880CCC088888000088880000000CCCC08888000088880CCCCCCC
      CCCC0888000088880CCCCCCCCCCCC088000088880CCCCCCCCCCCCC0800008888
      0CCCCCCCCCCCC088000088880CCCCCCCCCCC0888000088880000000CCCC08888
      000088888888880CCC088888000088888888880CC0888888000088888888880C
      0888888800008888888888008888888800008888888888088888888800008888
      8888888888888888000088888888888888888888000088888888888888888888
      0000}
    Layout = blGlyphBottom
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Spacing = 1
    TabOrder = 0
    OnClick = AddAllBtnClick
  end
  object RemoveBtn: TBitBtn
    Left = 312
    Top = 151
    Width = 123
    Height = 49
    Hint = 'Remove Selected form'
    Caption = 'Remove'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Glyph.Data = {
      7E010000424D7E01000000000000760000002800000014000000160000000100
      0400000000000801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777700007777777777777777777700007777777777077777777700007777
      77777007777777770000777777770C0777777777000077777770CC0777777777
      00007777770CCC07777777770000777770CCCC0000000777000077770CCCCCCC
      CCCC077700007770CCCCCCCCCCCC07770000770CCCCCCCCCCCCC077700007770
      CCCCCCCCCCCC0777000077770CCCCCCCCCCC07770000777770CCCC0000000777
      00007777770CCC0777777777000077777770CC07777777770000777777770C07
      7777777700007777777770077777777700007777777777077777777700007777
      7777777777777777000077777777777777777777000077777777777777777777
      0000}
    Layout = blGlyphTop
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = RemoveBtnClick
  end
  object AddBtn: TBitBtn
    Left = 312
    Top = 103
    Width = 123
    Height = 49
    Hint = 'Add selected form'
    Caption = 'Add'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Glyph.Data = {
      7E010000424D7E01000000000000760000002800000014000000160000000100
      0400000000000801000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888800008888888888888888888800008888888888088888888800008888
      8888880088888888000088888888880C08888888000088888888880CC0888888
      000088888888880CCC088888000088880000000CCCC08888000088880CCCCCCC
      CCCC0888000088880CCCCCCCCCCCC088000088880CCCCCCCCCCCCC0800008888
      0CCCCCCCCCCCC088000088880CCCCCCCCCCC0888000088880000000CCCC08888
      000088888888880CCC088888000088888888880CC0888888000088888888880C
      0888888800008888888888008888888800008888888888088888888800008888
      8888888888888888000088888888888888888888000088888888888888888888
      0000}
    Layout = blGlyphTop
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = AddBtnClick
  end
  object RemoveAllBtn: TBitBtn
    Left = 312
    Top = 263
    Width = 123
    Height = 49
    Hint = 'Remove All forms'
    Caption = 'Remove All'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Glyph.Data = {
      7E010000424D7E01000000000000760000002800000014000000160000000100
      0400000000000801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777700007777777777777777777700007777777777077777777700007777
      77777007777777770000777777770C0777777777000077777770CC0777777777
      00007777770CCC07777777770000777770CCCC0000000777000077770CCCCCCC
      CCCC077700007770CCCCCCCCCCCC07770000770CCCCCCCCCCCCC077700007770
      CCCCCCCCCCCC0777000077770CCCCCCCCCCC07770000777770CCCC0000000777
      00007777770CCC0777777777000077777770CC07777777770000777777770C07
      7777777700007777777770077777777700007777777777077777777700007777
      7777777777777777000077777777777777777777000077777777777777777777
      0000}
    Layout = blGlyphBottom
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = RemoveAllBtnClick
  end
  object StringGrid1: TStringGrid
    Left = 16
    Top = 103
    Width = 289
    Height = 521
    Hint = 'Double click to add to the set'
    ColCount = 3
    DefaultRowHeight = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnDblClick = StringGrid1DblClick
  end
  object StringGrid2: TStringGrid
    Left = 444
    Top = 103
    Width = 137
    Height = 521
    Hint = 'Double Click to remove form'
    ColCount = 2
    DefaultRowHeight = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnDblClick = StringGrid2DblClick
    RowHeights = (
      16
      16
      16
      16
      16)
  end
  object RadioGroup1: TRadioGroup
    Left = 21
    Top = 8
    Width = 561
    Height = 42
    Caption = ' Select a Print Set '
    Color = 13353654
    Columns = 6
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ItemIndex = 0
    Items.Strings = (
      'Filing'
      'Client'
      'Preparer'
      'Other 1'
      'Other 2'
      'Other 3')
    ParentColor = False
    ParentFont = False
    TabOrder = 6
    OnClick = RadioGroup1Click
  end
  object CancelBtn: TBitBtn
    Left = 312
    Top = 375
    Width = 123
    Height = 46
    Caption = 'Save and Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    Spacing = 2
    TabOrder = 7
    OnClick = CancelBtnClick
  end
  object BitBtn1: TBitBtn
    Left = 312
    Top = 335
    Width = 123
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    Kind = bkHelp
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 8
    OnClick = BitBtn1Click
  end
  object DataSource1: TDataSource
    DataSet = Table1_notOpened
    Left = 232
    Top = 125
  end
  object Table1_notOpened: TADTable
    Connection = FDConnection
    Left = 231
    Top = 171
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 231
    Top = 218
  end
end
