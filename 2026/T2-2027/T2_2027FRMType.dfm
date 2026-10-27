object FrmtypesT2_2027: TFrmtypesT2_2027
  Left = 759
  Top = 425
  Caption = 'Forms Explorer'
  ClientHeight = 773
  ClientWidth = 987
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 14
    Width = 58
    Height = 13
    Caption = 'T2 Jacket'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 184
    Top = 14
    Width = 47
    Height = 13
    Caption = 'Federal '
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 653
    Top = 14
    Width = 42
    Height = 13
    Caption = 'Ontario'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 841
    Top = 14
    Width = 41
    Height = 13
    Caption = 'Alberta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 448
    Top = 14
    Width = 57
    Height = 13
    Caption = 'Provincial'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 8
    Top = 145
    Width = 81
    Height = 13
    Caption = 'Miscellaneous'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 819
    Top = 726
    Width = 108
    Height = 13
    Caption = 'BC and SK Capital Tax'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label8: TLabel
    Left = 819
    Top = 707
    Width = 115
    Height = 13
    Caption = 'and Quebec Tax Return'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label10: TLabel
    Left = 8
    Top = 660
    Width = 40
    Height = 13
    Caption = 'Letters'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 175
    Top = 611
    Width = 91
    Height = 13
    Caption = 'SR&ED and ITC'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label12: TLabel
    Left = 135
    Top = 0
    Width = 130
    Height = 13
    Caption = 'Find (Form or keyword)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label13: TLabel
    Left = 401
    Top = 0
    Width = 163
    Height = 13
    Caption = 'or double-ckick on the list(s)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label9: TLabel
    Left = 602
    Top = 465
    Width = 186
    Height = 13
    Caption = 'SERS (Special Election Returns)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label14: TLabel
    Left = 602
    Top = 484
    Width = 170
    Height = 13
    Caption = 'on the Enterprise version only'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object T2List: TListBox
    Left = 8
    Top = 30
    Width = 161
    Height = 109
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 1
    OnDblClick = T2ListDblClick
    OnDrawItem = T2ListDrawItem
    OnKeyPress = T2ListKeyPress
    OnMouseDown = T2ListMouseDown
  end
  object ScList: TListBox
    Left = 170
    Top = 30
    Width = 216
    Height = 575
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 2
    OnDblClick = ScListDblClick
    OnDrawItem = ScListDrawItem
    OnKeyPress = ScListKeyPress
    OnMouseDown = ScListMouseDown
  end
  object OOList: TListBox
    Left = 600
    Top = 33
    Width = 202
    Height = 412
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 3
    OnDblClick = OOListDblClick
    OnDrawItem = OOListDrawItem
    OnKeyPress = OOListKeyPress
    OnMouseDown = OOListMouseDown
  end
  object AlList: TListBox
    Left = 808
    Top = 30
    Width = 166
    Height = 538
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 4
    OnDblClick = AlListDblClick
    OnDrawItem = AlListDrawItem
    OnKeyPress = AlListKeyPress
    OnMouseDown = AlListMouseDown
  end
  object TFList: TListBox
    Left = 388
    Top = 30
    Width = 208
    Height = 734
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 5
    OnDblClick = TFListDblClick
    OnDrawItem = TFListDrawItem
    OnKeyPress = TFListKeyPress
    OnMouseDown = TFListMouseDown
  end
  object MIList: TListBox
    Left = 8
    Top = 164
    Width = 161
    Height = 474
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 6
    OnDblClick = MIListDblClick
    OnDrawItem = MIListDrawItem
    OnKeyPress = MIListKeyPress
    OnMouseDown = MIListMouseDown
  end
  object OpenBtn: TBitBtn
    Left = 816
    Top = 605
    Width = 66
    Height = 50
    Caption = 'Open'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
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
    ParentFont = False
    TabOrder = 7
    OnClick = OpenBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 841
    Top = 661
    Width = 109
    Height = 40
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 8
    OnClick = CancelBtnClick
  end
  object PrintBtn: TBitBtn
    Left = 888
    Top = 605
    Width = 79
    Height = 50
    Caption = '&Print Form'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Glyph.Data = {
      56020000424D5602000000000000760000002800000024000000180000000100
      040000000000E001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888888888888888888880000888888888888888888888888888888888888
      0000888888888888888888888888888888888888000088888888888888888888
      8888888888888888000088888877000000000000000007788888888800008888
      8800000000000000000000078888888800008888877777777777777777777770
      788888880000888887F888888888888888888777078888880000888887F88888
      8888888889988777707888880000888887F88888888888888998877777088888
      0000888887F8CCCC8888888889988777770888880000888887F8888888888888
      88888877770888880000888887FFFFFFFFFFFFFFFFF888877708888800008888
      878FFFFFFFFFFFFFFFF8888877088888000088888878FF000000000000008888
      870888880000888888878FF07FFFFFFFFF707888880888880000888888887888
      74444444FF7007888708888800008888888887007FFFFFFFFF70000000888888
      00008888888888887F4444444F7888888888888800008888888888887FFFFFFF
      FF78888888888888000088888888888887F4444444F788888888888800008888
      8888888887FFFFFFFFF788888888888800008888888888888888888888888888
      8888888800008888888888888888888888888888888888880000}
    Layout = blGlyphTop
    ParentFont = False
    TabOrder = 9
    OnClick = PrintBtnClick
  end
  object RDList: TListBox
    Left = 168
    Top = 630
    Width = 216
    Height = 134
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 10
    OnDblClick = ScListDblClick
    OnDrawItem = ScListDrawItem
    OnKeyPress = ScListKeyPress
    OnMouseDown = ScListMouseDown
  end
  object OtherBtn: TBitBtn
    Left = 805
    Top = 574
    Width = 166
    Height = 25
    Caption = 'OTHER (PDF Format)...'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    Visible = False
    OnClick = OtherBtnClick
  end
  object ClList: TListBox
    Left = 8
    Top = 679
    Width = 154
    Height = 85
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 12
    OnDblClick = ClListDblClick
    OnDrawItem = ClListDrawItem
    OnKeyPress = ClListKeyPress
  end
  object FormBox: TEdit
    Left = 273
    Top = 0
    Width = 120
    Height = 21
    TabOrder = 0
    OnExit = FormBoxExit
  end
  object SERSList: TListBox
    Left = 602
    Top = 498
    Width = 202
    Height = 241
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    Sorted = True
    TabOrder = 13
    OnDblClick = SersListDblClick
    OnDrawItem = SersListDrawItem
    OnKeyPress = SersListKeyPress
    OnMouseDown = SersListMouseDown
  end
  object PrintDialog1: TPrintDialog
    Left = 516
    Top = 294
  end
end
