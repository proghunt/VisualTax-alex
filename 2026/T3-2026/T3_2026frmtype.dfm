object FrmtypeT3_2026: TFrmtypeT3_2026
  Left = 226
  Top = 123
  Caption = 'Forms'
  ClientHeight = 793
  ClientWidth = 833
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
  object Label2: TLabel
    Left = 33
    Top = 105
    Width = 147
    Height = 16
    Caption = 'T3RET - Trust Return'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 316
    Top = 393
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
  object Label7: TLabel
    Left = 308
    Top = 185
    Width = 94
    Height = 16
    Caption = 'T3 - Prov Tax'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label11: TLabel
    Left = 309
    Top = 105
    Width = 109
    Height = 16
    Caption = 'T3 - Allocations'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 558
    Top = 393
    Width = 211
    Height = 16
    Caption = 'T3 - MJ (Multiple Jurisdictions)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 579
    Top = 105
    Width = 133
    Height = 16
    Caption = 'T3 - Special Types'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 539
    Top = 123
    Width = 240
    Height = 13
    Caption = 'If you need any, please contact VisualTax'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object T3List: TListBox
    Left = 11
    Top = 121
    Width = 259
    Height = 622
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 1
    OnDblClick = T3ListDblClick
    OnDrawItem = T3ListDrawItem
    OnKeyPress = T3ListKeyPress
    OnMouseDown = T3ListMouseDown
  end
  object AlList: TListBox
    Left = 579
    Top = 747
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
    TabOrder = 3
    Visible = False
    OnDblClick = AlListDblClick
    OnDrawItem = AlListDrawItem
    OnKeyPress = AlListKeyPress
    OnMouseDown = AlListMouseDown
  end
  object MIList: TListBox
    Left = 278
    Top = 415
    Width = 255
    Height = 328
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
    OnDblClick = MIListDblClick
    OnDrawItem = MIListDrawItem
    OnKeyPress = MIListKeyPress
    OnMouseDown = MIListMouseDown
  end
  object ADList: TListBox
    Left = 453
    Top = 743
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
    TabOrder = 5
    Visible = False
    OnDblClick = ADListDblClick
    OnDrawItem = ADListDrawItem
    OnKeyPress = ADListKeyPress
    OnMouseDown = ADListMouseDown
  end
  object T3PrvList: TListBox
    Left = 276
    Top = 201
    Width = 257
    Height = 176
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 2
    OnDblClick = T3ListDblClick
    OnDrawItem = T3ListDrawItem
    OnKeyPress = T3ListKeyPress
    OnMouseDown = T3ListMouseDown
  end
  object T3AllocList: TListBox
    Left = 278
    Top = 121
    Width = 255
    Height = 57
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 6
    OnDblClick = T3ListDblClick
    OnDrawItem = T3ListDrawItem
    OnKeyPress = T3ListKeyPress
    OnMouseDown = T3ListMouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 833
    Height = 99
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -25
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label13: TLabel
      Left = 308
      Top = 7
      Width = 173
      Height = 29
      Caption = 'Forms Explorer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -25
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label14: TLabel
      Left = 155
      Top = 61
      Width = 185
      Height = 16
      Caption = 'Or Double click a form below'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label15: TLabel
      Left = 17
      Top = 35
      Width = 114
      Height = 16
      Caption = 'Find by keyword'
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
      Left = 355
      Top = 35
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
      Left = 355
      Top = 73
      Width = 89
      Height = 26
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
      Left = 558
      Top = 38
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
      Left = 17
      Top = 57
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
  object T3MJLIST: TListBox
    Left = 539
    Top = 415
    Width = 292
    Height = 322
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
    OnDblClick = MIListDblClick
    OnDrawItem = MIListDrawItem
    OnKeyPress = MIListKeyPress
    OnMouseDown = MIListMouseDown
  end
  object T3SPLIST: TListBox
    Left = 537
    Top = 145
    Width = 294
    Height = 232
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
    OnDblClick = MIListDblClick
    OnDrawItem = MIListDrawItem
    OnKeyPress = MIListKeyPress
    OnMouseDown = MIListMouseDown
  end
end
