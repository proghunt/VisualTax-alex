object ABListTF_2026: TABListTF_2026
  Left = 64
  Top = 48
  Width = 632
  Height = 464
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Tax Topics - Alphabetical Index '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 585
    Height = 425
    BevelOuter = bvLowered
    BevelWidth = 3
    TabOrder = 0
    object Label1: TLabel
      Left = 46
      Top = 384
      Width = 32
      Height = 16
      Caption = 'Find:'
    end
    object ListBox1: TListBox
      Left = 8
      Top = 8
      Width = 569
      Height = 353
      Color = 15269887
      Columns = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnDblClick = ListBox1DblClick
      OnDrawItem = ListBox1DrawItem
      OnKeyPress = ListBox1KeyPress
      OnMouseDown = ListBox1MouseDown
    end
    object OpenBtn: TBitBtn
      Left = 242
      Top = 376
      Width = 89
      Height = 33
      Caption = '&Open'
      TabOrder = 1
      OnClick = OpenBtnClick
      Kind = bkOK
    end
    object CancelBtn: TBitBtn
      Left = 346
      Top = 376
      Width = 89
      Height = 33
      TabOrder = 2
      OnClick = CancelBtnClick
      Kind = bkCancel
    end
    object FindBox: TEdit
      Left = 90
      Top = 380
      Width = 121
      Height = 24
      TabOrder = 3
      OnChange = FindBoxChange
    end
  end
end
