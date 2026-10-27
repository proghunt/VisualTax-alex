object InvAdjT1_2026: TInvAdjT1_2026
  Left = 154
  Top = 136
  Width = 544
  Height = 375
  Caption = 'InvAdjT1_2026'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 168
    Top = 72
    Width = 75
    Height = 13
    Caption = 'Total Income'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 336
    Top = 72
    Width = 82
    Height = 13
    Caption = 'Adjustment ($)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 136
    Top = 104
    Width = 23
    Height = 13
    Caption = 'From'
  end
  object Label4: TLabel
    Left = 224
    Top = 104
    Width = 13
    Height = 13
    Caption = 'To'
  end
  object Label5: TLabel
    Left = 200
    Top = 16
    Width = 131
    Height = 16
    Caption = 'Invoice Adjustment'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 72
    Top = 48
    Width = 369
    Height = 1
    Shape = bsBottomLine
  end
  object Label6: TLabel
    Left = 328
    Top = 88
    Width = 108
    Height = 13
    Caption = 'Over Forms Based Fee'
  end
  object FromInc1: TEdit
    Left = 104
    Top = 128
    Width = 73
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object ToInc1: TEdit
    Left = 208
    Top = 128
    Width = 73
    Height = 21
    TabOrder = 1
    Text = '20000'
  end
  object Adj1: TEdit
    Left = 336
    Top = 128
    Width = 73
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object FromInc2: TEdit
    Left = 104
    Top = 168
    Width = 73
    Height = 21
    TabOrder = 3
    Text = '20000'
  end
  object ToInc2: TEdit
    Left = 208
    Top = 168
    Width = 73
    Height = 21
    TabOrder = 4
    Text = '30000'
  end
  object Adj2: TEdit
    Left = 336
    Top = 168
    Width = 73
    Height = 21
    TabOrder = 5
    Text = '0'
  end
  object FromInc3: TEdit
    Left = 104
    Top = 200
    Width = 73
    Height = 21
    TabOrder = 6
    Text = '30000'
  end
  object ToInc3: TEdit
    Left = 208
    Top = 200
    Width = 73
    Height = 21
    TabOrder = 7
    Text = '50000'
  end
  object Adj3: TEdit
    Left = 336
    Top = 200
    Width = 73
    Height = 21
    TabOrder = 8
    Text = '0'
  end
  object FromInc4: TEdit
    Left = 104
    Top = 240
    Width = 73
    Height = 21
    TabOrder = 9
    Text = '50000'
  end
  object ToInc4: TEdit
    Left = 208
    Top = 240
    Width = 73
    Height = 21
    TabOrder = 10
    Text = '9000000'
  end
  object Adj4: TEdit
    Left = 336
    Top = 240
    Width = 73
    Height = 21
    TabOrder = 11
    Text = '0'
  end
  object OKBtn: TBitBtn
    Left = 184
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Save'
    Default = True
    TabOrder = 12
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
    Left = 280
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 13
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
end
