object ABListT1_2026: TABListT1_2026
  Left = 124
  Top = 99
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Tax Topics - Alphabetical Index '
  ClientHeight = 784
  ClientWidth = 965
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 965
    Height = 784
    Align = alClient
    BevelOuter = bvLowered
    BevelWidth = 3
    TabOrder = 0
    object ListBox1: TListBox
      Left = 3
      Top = 81
      Width = 959
      Height = 700
      Style = lbOwnerDrawFixed
      Align = alClient
      Color = clWhite
      Columns = 5
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      TabOrder = 0
      OnDblClick = ListBox1DblClick
      OnDrawItem = ListBox1DrawItem
      OnKeyPress = ListBox1KeyPress
      OnMouseDown = ListBox1MouseDown
    end
    object Panel2: TPanel
      Left = 3
      Top = 3
      Width = 959
      Height = 78
      Align = alTop
      TabOrder = 1
      object Label1: TLabel
        Left = 46
        Top = 48
        Width = 32
        Height = 16
        Caption = 'Find:'
      end
      object Label2: TLabel
        Left = 224
        Top = 48
        Width = 94
        Height = 16
        Caption = 'or double-click'
      end
      object OpenBtn: TBitBtn
        Left = 362
        Top = 40
        Width = 89
        Height = 33
        Caption = '&Open'
        Kind = bkOK
        NumGlyphs = 2
        TabOrder = 0
        OnClick = OpenBtnClick
      end
      object CancelBtn: TBitBtn
        Left = 498
        Top = 40
        Width = 89
        Height = 33
        Kind = bkCancel
        NumGlyphs = 2
        TabOrder = 1
        OnClick = CancelBtnClick
      end
      object FindBox: TEdit
        Left = 90
        Top = 44
        Width = 121
        Height = 24
        TabOrder = 2
        OnChange = FindBoxChange
        OnKeyPress = FindBoxKeyPress
      end
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 957
        Height = 33
        Align = alTop
        Caption = 'Forms Explorer - Alphabetical View'
        Color = 11301888
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10930928
        Font.Height = -21
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
    end
  end
end
