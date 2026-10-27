object FrmtypeTF_2026: TFrmtypeTF_2026
  Left = 226
  Top = 123
  Caption = 'Forms - FrmType'
  ClientHeight = 673
  ClientWidth = 1376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Label3: TLabel
    Left = 8
    Top = 64
    Width = 155
    Height = 16
    Caption = 'T3010 - Charity returns'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 254
    Top = 64
    Width = 212
    Height = 16
    Caption = 'T5013 - FIN Partnership Return'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 8
    Top = 241
    Width = 149
    Height = 16
    Caption = 'Admin/Miscellaneous'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 485
    Top = 64
    Width = 148
    Height = 16
    Caption = 'Miscellaneous Forms'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label34: TLabel
    Left = 774
    Top = 64
    Width = 160
    Height = 16
    Caption = 'FILLABLE CRA FORMS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 251
    Top = 478
    Width = 185
    Height = 16
    Caption = 'T5018 - Contract Payments'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 251
    Top = 566
    Width = 166
    Height = 16
    Caption = 'NR4 slips and Summary'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CHList: TListBox
    Left = 8
    Top = 86
    Width = 237
    Height = 139
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 0
    OnDblClick = CHListDblClick
    OnDrawItem = CHListDrawItem
    OnKeyPress = CHListKeyPress
    OnMouseDown = CHListMouseDown
  end
  object AlList: TListBox
    Left = 698
    Top = 585
    Width = 68
    Height = 32
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 1
    Visible = False
    OnDblClick = AlListDblClick
    OnDrawItem = AlListDrawItem
    OnKeyPress = AlListKeyPress
    OnMouseDown = AlListMouseDown
  end
  object MIList: TListBox
    Left = 8
    Top = 263
    Width = 237
    Height = 361
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 2
    OnDblClick = MIListDblClick
    OnDrawItem = MIListDrawItem
    OnKeyPress = MIListKeyPress
    OnMouseDown = MIListMouseDown
  end
  object ADList: TListBox
    Left = 579
    Top = 581
    Width = 100
    Height = 36
    Style = lbOwnerDrawFixed
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 3
    Visible = False
    OnDblClick = ADListDblClick
    OnDrawItem = ADListDrawItem
    OnKeyPress = ADListKeyPress
    OnMouseDown = ADListMouseDown
  end
  object ELList: TListBox
    Left = 484
    Top = 86
    Width = 261
    Height = 489
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 4
    OnDblClick = ELListDblClick
    OnDrawItem = ELListDrawItem
    OnKeyPress = ELListKeyPress
    OnMouseDown = ELListMouseDown
  end
  object PAList: TListBox
    Left = 251
    Top = 86
    Width = 215
    Height = 384
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 5
    OnDblClick = PAListDblClick
    OnDrawItem = PAListDrawItem
    OnKeyPress = PAListKeyPress
    OnMouseDown = PAListMouseDown
  end
  object Panel2: TPanel
    Left = 768
    Top = 86
    Width = 213
    Height = 484
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 6
    object Label1: TLabel
      Left = 10
      Top = 102
      Width = 75
      Height = 16
      Caption = 'Fill and Print '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 10
      Top = 140
      Width = 20
      Height = 16
      Caption = 'OR'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 11
      Top = 170
      Width = 100
      Height = 16
      Caption = 'using PdfFactory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 13
      Top = 47
      Width = 82
      Height = 16
      Caption = 'Then select'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label18: TLabel
      Left = 13
      Top = 63
      Width = 176
      Height = 16
      Caption = 'the PDF - Fillable version'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label19: TLabel
      Left = 6
      Top = 208
      Width = 124
      Height = 16
      Caption = 'Forms of interest  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label21: TLabel
      Left = 6
      Top = 369
      Width = 158
      Height = 16
      Caption = '- NR forms (NR4, NR5, etc)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label22: TLabel
      Left = 6
      Top = 327
      Width = 103
      Height = 16
      Caption = '- GST/HST forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label24: TLabel
      Left = 6
      Top = 348
      Width = 125
      Height = 16
      Caption = '- Notices of objection'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label25: TLabel
      Left = 10
      Top = 116
      Width = 135
      Height = 16
      Caption = 'the CRA provided form'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label26: TLabel
      Left = 10
      Top = 154
      Width = 108
      Height = 16
      Caption = 'Fill and Print/Save'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label27: TLabel
      Left = 6
      Top = 264
      Width = 73
      Height = 16
      Caption = '- Certificates'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label28: TLabel
      Left = 6
      Top = 243
      Width = 81
      Height = 16
      Caption = '- Applications'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label29: TLabel
      Left = 6
      Top = 306
      Width = 96
      Height = 16
      Caption = '- Excise duty/tax'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label30: TLabel
      Left = 6
      Top = 285
      Width = 91
      Height = 16
      Caption = '- Election forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label31: TLabel
      Left = 6
      Top = 390
      Width = 62
      Height = 16
      Caption = '- RC forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label32: TLabel
      Left = 6
      Top = 411
      Width = 69
      Height = 16
      Caption = '- TD1 forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label33: TLabel
      Left = 6
      Top = 432
      Width = 104
      Height = 16
      Caption = '- T1 and T2 forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 104
      Top = 4
      Width = 94
      Height = 16
      Caption = 'and Press Ctrl F'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label35: TLabel
      Left = 102
      Top = 21
      Width = 83
      Height = 16
      Caption = ' to Find a form'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label36: TLabel
      Left = 12
      Top = 184
      Width = 112
      Height = 16
      Caption = 'or other PDF driver'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label37: TLabel
      Left = 6
      Top = 222
      Width = 143
      Height = 16
      Caption = 'for low-volume forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label23: TLabel
      Left = 6
      Top = 453
      Width = 57
      Height = 16
      Caption = '- Waivers'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object BitBtn1: TBitBtn
      Left = 13
      Top = 4
      Width = 85
      Height = 32
      Caption = 'Click here'
      TabOrder = 0
      OnClick = BitBtn1Click
    end
  end
  object CPList: TListBox
    Left = 251
    Top = 500
    Width = 215
    Height = 60
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 7
    OnDblClick = PAListDblClick
    OnDrawItem = PAListDrawItem
    OnKeyPress = PAListKeyPress
    OnMouseDown = PAListMouseDown
  end
  object NRList: TListBox
    Left = 251
    Top = 588
    Width = 215
    Height = 37
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 8
    OnDblClick = NRListDblClick
    OnDrawItem = NRListDrawItem
    OnKeyPress = NRListKeyPress
    OnMouseDown = NRListMouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1376
    Height = 53
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -25
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    object Label13: TLabel
      Left = 9
      Top = 9
      Width = 173
      Height = 29
      Caption = 'Forms Explorer'
      Color = 10930928
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -25
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label14: TLabel
      Left = 361
      Top = 25
      Width = 166
      Height = 16
      Caption = 'Double click a form below'
      Color = 10930928
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label15: TLabel
      Left = 226
      Top = 7
      Width = 114
      Height = 16
      Caption = 'Find by keyword'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label9: TLabel
      Left = 434
      Top = 7
      Width = 23
      Height = 16
      Caption = 'OR'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object OpenBtn: TBitBtn
      Left = 544
      Top = 9
      Width = 89
      Height = 32
      Caption = 'Open'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
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
      TabOrder = 1
      OnClick = OpenBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 656
      Top = 8
      Width = 89
      Height = 33
      Caption = '&Print Form'
      Default = True
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = PrintBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 768
      Top = 8
      Width = 89
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 3
      OnClick = CancelBtnClick
    end
    object FormBox: TEdit
      Left = 224
      Top = 22
      Width = 113
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnExit = FormBoxExit
      OnKeyPress = FormBoxKeyPress
    end
  end
end
