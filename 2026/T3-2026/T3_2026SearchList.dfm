object SearchListT3_2026: TSearchListT3_2026
  Left = 106
  Top = 149
  Width = 733
  Height = 513
  BorderIcons = [biSystemMenu]
  Color = 13353654
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 56
    Top = 8
    Width = 191
    Height = 16
    Caption = 'Search by keyword (i.e. eggs)'
  end
  object ListBox1: TListBox
    Left = 0
    Top = 40
    Width = 705
    Height = 385
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 1
    OnDblClick = ListBox1DblClick
    OnKeyPress = ListBox1KeyPress
  end
  object OKBtn: TBitBtn
    Left = 224
    Top = 432
    Width = 65
    Height = 33
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
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
    Left = 320
    Top = 432
    Width = 89
    Height = 33
    TabOrder = 3
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
  object KeyWBox: TEdit
    Left = 264
    Top = 8
    Width = 121
    Height = 24
    TabOrder = 0
    OnChange = KeyWBoxChange
  end
end
