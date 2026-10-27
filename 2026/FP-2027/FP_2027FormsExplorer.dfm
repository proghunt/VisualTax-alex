object FormsExplorerFP_2012: TFormsExplorerFP_2012
  Left = 123
  Top = 135
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Forms'
  ClientHeight = 0
  ClientWidth = 113
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
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 113
    Height = 25
    Align = alTop
    Caption = 'Forms Explorer (List View)'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 804
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 25
    Width = 113
    Height = 512
    ActivePage = TabSheet1
    Align = alTop
    Style = tsButtons
    TabOrder = 1
    OnChange = PageControl1Change
    ExplicitWidth = 804
    object TabSheet1: TTabSheet
      Caption = 'Forms'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 106
        Height = 13
        Caption = 'Federal Schedules'
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
        Left = 160
        Top = 24
        Width = 87
        Height = 13
        Caption = 'Provincial Sch.'
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
        Left = 280
        Top = 24
        Width = 28
        Height = 13
        Caption = 'Slips'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 384
        Top = 24
        Width = 97
        Height = 13
        Caption = 'Self-Empl/Rental'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 536
        Top = 24
        Width = 46
        Height = 13
        Caption = 'T-Forms'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 648
        Top = 24
        Width = 81
        Height = 13
        Caption = 'Miscellaneous'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 32
        Top = 280
        Width = 35
        Height = 13
        Caption = 'Admin'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 273
        Top = 304
        Width = 67
        Height = 13
        Caption = 'Carry-Overs'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 44
        Top = 6
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
        Left = 385
        Top = 304
        Width = 83
        Height = 13
        Caption = 'Oil-Gas-Mining'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object T1List: TListBox
        Left = 8
        Top = 40
        Width = 145
        Height = 241
        Style = lbOwnerDrawFixed
        Color = 16777158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 0
        OnDblClick = T1ListDblClick
        OnDrawItem = T1ListDrawItem
        OnKeyPress = T1ListKeyPress
        OnMouseDown = T1ListMouseDown
      end
      object CRList: TListBox
        Left = 160
        Top = 40
        Width = 89
        Height = 385
        Style = lbOwnerDrawFixed
        Color = 16777158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 1
        OnDblClick = CRListDblClick
        OnDrawItem = CRListDrawItem
        OnKeyPress = CRListKeyPress
        OnMouseDown = CRListMouseDown
      end
      object SLList: TListBox
        Left = 256
        Top = 40
        Width = 113
        Height = 257
        Style = lbOwnerDrawFixed
        Color = 16777158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 2
        OnDblClick = SLListDblClick
        OnDrawItem = SLListDrawItem
        OnKeyPress = SLListKeyPress
        OnMouseDown = SLListMouseDown
      end
      object SEList: TListBox
        Left = 376
        Top = 40
        Width = 121
        Height = 257
        Style = lbOwnerDrawFixed
        Color = 16777158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 3
        OnDblClick = SEListDblClick
        OnDrawItem = SEListDrawItem
        OnKeyPress = SEListKeyPress
        OnMouseDown = SEListMouseDown
      end
      object TFList: TListBox
        Left = 504
        Top = 40
        Width = 129
        Height = 385
        Style = lbOwnerDrawFixed
        Color = 16777158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 4
        OnDblClick = TFListDblClick
        OnDrawItem = TFListDrawItem
        OnKeyPress = TFListKeyPress
        OnMouseDown = TFListMouseDown
      end
      object MIList: TListBox
        Left = 640
        Top = 40
        Width = 121
        Height = 441
        Style = lbOwnerDrawFixed
        Color = 16777158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 5
        OnDblClick = MIListDblClick
        OnDrawItem = MIListDrawItem
        OnKeyPress = MIListKeyPress
        OnMouseDown = MIListMouseDown
      end
      object ADList: TListBox
        Left = 8
        Top = 296
        Width = 145
        Height = 185
        Style = lbOwnerDrawFixed
        Color = 16777158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 6
        OnDblClick = ADListDblClick
        OnDrawItem = ADListDrawItem
        OnKeyPress = ADListKeyPress
        OnMouseDown = ADListMouseDown
      end
      object CFList: TListBox
        Left = 256
        Top = 320
        Width = 113
        Height = 105
        Style = lbOwnerDrawFixed
        Color = 16777158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 7
        OnDblClick = CFListDblClick
        OnDrawItem = CFListDrawItem
        OnKeyPress = CFListKeyPress
        OnMouseDown = CFListMouseDown
      end
      object REList: TListBox
        Left = 376
        Top = 320
        Width = 121
        Height = 105
        Style = lbOwnerDrawFixed
        Color = 16777158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 8
        OnDblClick = REListDblClick
        OnDrawItem = REListDrawItem
        OnKeyPress = REListKeyPress
        OnMouseDown = REListMouseDown
      end
      object SwapBtn: TBitBtn
        Left = 256
        Top = 431
        Width = 201
        Height = 42
        Hint = 'Swap returns'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Glyph.Data = {
          F6010000424DF601000000000000760000002800000020000000180000000100
          0400000000008001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888899889999988998888888888888880888998999999989988888888888888
          8008899899999998998888888888000000008999997779999988888888808888
          8008899977888779998888888808888880888899887878899888888888088888
          8888888887777788888888888808888888888888778887788888888888088888
          8888888878888878888888888888888888888888778887788888888877777788
          88888888877877888888844847FFF74844888888877777888888844847FFF748
          44888888888888888888844447F4F74444888888888888888888844447F4F744
          44888888888808888888884447F4F74444888888888808888888884488787884
          4888888888880888888888888777778888888888888808888888888877888778
          8888808888880888888888887888887888880088888088888888888877888778
          8880000000088888888888888778778888880088888888888888888887777788
          8888808888888888888888888888888888888888888888888888}
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = SwapBtnClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'KeyWords'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label11: TLabel
        Left = 72
        Top = 8
        Width = 29
        Height = 13
        Caption = 'Find:'
      end
      object FindResultLbl: TLabel
        Left = 264
        Top = 16
        Width = 103
        Height = 16
        Caption = 'FindResultLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
      end
      object FindBox: TEdit
        Left = 112
        Top = 8
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'tax'
        OnChange = FindBoxChange
      end
      object FoundList: TListBox
        Left = 16
        Top = 40
        Width = 729
        Height = 425
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object Panel2: TPanel
    Left = 168
    Top = 25
    Width = 465
    Height = 34
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object FrmDescr: TLabel
      Left = 328
      Top = 8
      Width = 89
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'FrmDescr'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object OpenBtn: TBitBtn
      Left = 24
      Top = 7
      Width = 65
      Height = 26
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
    object CancelBtn: TBitBtn
      Left = 240
      Top = 7
      Width = 73
      Height = 26
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 128
      Top = 7
      Width = 73
      Height = 26
      Caption = '&Print Form'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = PrintBtnClick
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 310
    Top = 266
  end
end
