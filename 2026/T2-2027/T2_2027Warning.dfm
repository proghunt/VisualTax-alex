object WarningT2_2027: TWarningT2_2027
  Left = 35
  Top = 97
  Caption = 'Warnings and Diagnostics'
  ClientHeight = 218
  ClientWidth = 470
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 25
    Top = 8
    Width = 72
    Height = 13
    Margins.Bottom = 2
    Caption = 'Current Return:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object RetNameLbl: TLabel
    Left = 145
    Top = 8
    Width = 272
    Height = 16
    Margins.Bottom = 2
    Alignment = taCenter
    AutoSize = False
    Caption = 'RetNameLbl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 16
    Top = 32
    Width = 553
    Height = 193
    TabOrder = 0
    OnDblClick = ListBox1DblClick
  end
  object ListBox2: TListBox
    Left = 25
    Top = 240
    Width = 24
    Height = 25
    TabOrder = 1
    Visible = False
  end
  object ListBox3: TListBox
    Left = 57
    Top = 240
    Width = 24
    Height = 25
    TabOrder = 2
    Visible = False
  end
  object ReviewBtn: TBitBtn
    Left = 176
    Top = 232
    Width = 97
    Height = 33
    Caption = 'Review'
    Glyph.Data = {
      56020000424D5602000000000000760000002800000024000000180000000100
      040000000000E001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888888888888888888880000888888888888888888888888886688888888
      0000888888888888888888888888866668888888000088888888888888888888
      8888666666888888000088888888888808707888886666666668888800008888
      8888870787878078866666666688888800008888888808786878788066666666
      8888888800008888888087887866687866666688888888880000888888078878
      888876886666888888888888000088888078668888F888878868888888888888
      0000888878878877F787F88866788888888888880000888808688888FF8FF8F8
      8807888888888888000088887768888F88888878787788888888888800008888
      0887888F8F8F8F888680888888888888000088887788887FF88F887887878888
      888888880000888808687888F88877F888078888888888880000888877888877
      F7F7FF8878878888888888880000888880786868888888868808888888888888
      0000888887087888868888878088888888888888000088888870888788868768
      0888888888888888000088888887808887878680888888888888888800008888
      8888787080880878888888888888888800008888888888887878788888888888
      8888888800008888888888888888888888888888888888880000}
    TabOrder = 3
    OnClick = ReviewBtnClick
  end
  object ExitBtn: TBitBtn
    Left = 297
    Top = 232
    Width = 88
    Height = 33
    Caption = 'Ignore'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 4
    OnClick = ExitBtnClick
  end
end
