object PrSetFP_2012: TPrSetFP_2012
  Left = 418
  Top = 209
  Caption = 'Build Print Templates (Print set) '
  ClientHeight = 555
  ClientWidth = 660
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 56
    Width = 128
    Height = 20
    Caption = 'Forms Available'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CurrentSetLabel: TLabel
    Left = 448
    Top = 56
    Width = 153
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'Print Set: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 448
    Top = 40
    Width = 153
    Height = 20
    Alignment = taCenter
    AutoSize = False
    Caption = 'Forms to print for:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object AddAllBtn: TBitBtn
    Left = 376
    Top = 192
    Width = 73
    Height = 49
    Hint = 'Add All forms'
    Caption = 'Add All '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
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
    Left = 376
    Top = 128
    Width = 73
    Height = 49
    Hint = 'Remove Selected form'
    Caption = 'Remove'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
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
    Left = 376
    Top = 80
    Width = 73
    Height = 49
    Hint = 'Add selected form'
    Caption = 'Add'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
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
    Left = 376
    Top = 240
    Width = 73
    Height = 49
    Hint = 'Remove All forms'
    Caption = 'Remove All'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
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
    Left = 8
    Top = 80
    Width = 361
    Height = 481
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
    Left = 464
    Top = 80
    Width = 160
    Height = 481
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
    Left = 32
    Top = 8
    Width = 513
    Height = 33
    Caption = ' Select a Print Set '
    Color = clBtnFace
    Columns = 6
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    Items.Strings = (
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
    Left = 376
    Top = 352
    Width = 73
    Height = 33
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 7
    OnClick = CancelBtnClick
  end
  object DataSource1: TDataSource
    Left = 288
    Top = 48
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 241
    Top = 121
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 296
    Top = 112
  end
end
