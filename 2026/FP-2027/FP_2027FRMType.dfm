object FrmtypesFP_2012: TFrmtypesFP_2012
  Left = 211
  Top = 200
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Forms'
  ClientHeight = 626
  ClientWidth = 977
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 42
    Top = 56
    Width = 96
    Height = 13
    Caption = 'Present situation'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 742
    Top = 56
    Width = 118
    Height = 13
    Caption = 'Goals & Assumptions'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 14
    Top = 371
    Width = 158
    Height = 13
    Caption = 'Projections and assessment'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 483
    Top = 518
    Width = 118
    Height = 13
    Caption = 'Performance Review'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 273
    Top = 371
    Width = 118
    Height = 13
    Caption = 'Strategies and Plans'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 52
    Top = 30
    Width = 596
    Height = 13
    Caption = 
      'Double click or press Enter.    Select/Unselect with space bar o' +
      'r single click    Change section with TAB'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 483
    Top = 364
    Width = 111
    Height = 13
    Caption = 'Implementation and'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 483
    Top = 378
    Width = 123
    Height = 13
    Caption = 'Portfolio management'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 756
    Top = 371
    Width = 103
    Height = 13
    Caption = 'Compliance Forms'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 756
    Top = 518
    Width = 72
    Height = 13
    Caption = 'Admin Forms'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label12: TLabel
    Left = 301
    Top = 56
    Width = 38
    Height = 13
    Caption = 'Assets'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Liabilities: TLabel
    Left = 497
    Top = 56
    Width = 54
    Height = 13
    Caption = 'Liabilities'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object PrList: TListBox
    Left = 7
    Top = 70
    Width = 225
    Height = 281
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 0
    OnDblClick = PRListDblClick
    OnDrawItem = PRListDrawItem
    OnKeyPress = PRListKeyPress
    OnMouseDown = PRListMouseDown
  end
  object GlList: TListBox
    Left = 735
    Top = 70
    Width = 218
    Height = 281
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 1
    OnDblClick = GlListDblClick
    OnKeyPress = GlListKeyPress
    OnMouseDown = GlListMouseDown
  end
  object PAList: TListBox
    Left = 14
    Top = 392
    Width = 225
    Height = 246
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 2
    OnDblClick = PAListDblClick
    OnDrawItem = PAListDrawItem
    OnKeyPress = PAListKeyPress
    OnMouseDown = PAListMouseDown
  end
  object ImList: TListBox
    Left = 476
    Top = 392
    Width = 253
    Height = 120
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 3
    OnDblClick = ImListDblClick
    OnDrawItem = ImListDrawItem
    OnKeyPress = ImListKeyPress
    OnMouseDown = ImListMouseDown
  end
  object PlList: TListBox
    Left = 252
    Top = 392
    Width = 211
    Height = 246
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 4
    OnDblClick = PlListDblClick
    OnDrawItem = PlListDrawItem
    OnKeyPress = PlListKeyPress
    OnMouseDown = PlListMouseDown
  end
  object PeList: TListBox
    Left = 476
    Top = 532
    Width = 253
    Height = 106
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 5
    OnDblClick = PeListDblClick
    OnDrawItem = PeListDrawItem
    OnKeyPress = PeListKeyPress
    OnMouseDown = PeListMouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 977
    Height = 47
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 6
    ExplicitWidth = 120
    object Label11: TLabel
      Left = 8
      Top = 8
      Width = 140
      Height = 24
      Caption = 'Forms Explorer'
    end
    object OpenBtn: TBitBtn
      Left = 291
      Top = 7
      Width = 65
      Height = 34
      Caption = '&Open'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkOK
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = OpenBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 385
      Top = 7
      Width = 73
      Height = 34
      Caption = '&Print Form'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = PrintBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 486
      Top = 8
      Width = 73
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = CancelBtnClick
    end
  end
  object CoList: TListBox
    Left = 749
    Top = 392
    Width = 204
    Height = 120
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 7
    OnDblClick = CoListDblClick
    OnDrawItem = CoListDrawItem
    OnKeyPress = CoListKeyPress
    OnMouseDown = CoListMouseDown
  end
  object AdList: TListBox
    Left = 742
    Top = 532
    Width = 211
    Height = 106
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 8
    OnDblClick = PeListDblClick
    OnDrawItem = PeListDrawItem
    OnKeyPress = PeListKeyPress
    OnMouseDown = PeListMouseDown
  end
  object DaList: TListBox
    Left = 245
    Top = 70
    Width = 211
    Height = 281
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 9
    OnDblClick = PRListDblClick
    OnDrawItem = PRListDrawItem
    OnKeyPress = PRListKeyPress
    OnMouseDown = PRListMouseDown
  end
  object DlList: TListBox
    Left = 469
    Top = 70
    Width = 253
    Height = 281
    Style = lbOwnerDrawFixed
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    Sorted = True
    TabOrder = 10
    OnDblClick = PRListDblClick
    OnDrawItem = PRListDrawItem
    OnKeyPress = PRListKeyPress
    OnMouseDown = PRListMouseDown
  end
  object PrintDialog1: TPrintDialog
    Left = 215
    Top = 12
  end
end
