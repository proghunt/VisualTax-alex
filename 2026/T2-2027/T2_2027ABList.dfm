object ABListT2_2027: TABListT2_2027
  Left = 147
  Top = 162
  ActiveControl = ListBox1
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Tax Topics - Alphabetical Index '
  ClientHeight = 458
  ClientWidth = 686
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 686
    Height = 89
    Align = alTop
    Color = 15532031
    TabOrder = 0
    object Label2: TLabel
      Left = 88
      Top = 56
      Width = 115
      Height = 16
      Margins.Bottom = 2
      Alignment = taRightJustify
      Caption = 'Double-click or Fin&d'
      FocusControl = FindBox
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object ShowBox: TRadioGroup
      Left = 88
      Top = 8
      Width = 441
      Height = 41
      Caption = 'Filter'
      Color = clBtnFace
      Columns = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        '&Federal only'
        '&Ontario only'
        '&Alberta only')
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      OnClick = ShowBoxClick
    end
    object OpenBtn: TBitBtn
      Left = 338
      Top = 48
      Width = 89
      Height = 33
      Caption = 'O&pen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkOK
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = OpenBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 442
      Top = 48
      Width = 87
      Height = 33
      Caption = '&Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = CancelBtnClick
    end
    object FindBox: TEdit
      Left = 223
      Top = 52
      Width = 107
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnChange = FindBoxChange
      OnKeyDown = FindBoxKeyDown
      OnKeyPress = FindBoxKeyPress
    end
  end
  object ListBox1: TListBox
    Left = 0
    Top = 89
    Width = 686
    Height = 369
    Style = lbOwnerDrawFixed
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnDblClick = ListBox1DblClick
    OnDrawItem = ListBox1DrawItem
    OnKeyPress = ListBox1KeyPress
    OnMouseDown = ListBox1MouseDown
  end
end
