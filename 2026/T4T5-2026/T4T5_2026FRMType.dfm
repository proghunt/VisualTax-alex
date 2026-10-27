object FrmtypeT4T5_2026: TFrmtypeT4T5_2026
  Left = 226
  Top = 123
  Caption = 'Forms'
  ClientHeight = 590
  ClientWidth = 1061
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
  DesignSize = (
    1061
    590)
  PixelsPerInch = 96
  TextHeight = 16
  object Label2: TLabel
    Left = 107
    Top = 118
    Width = 36
    Height = 16
    Caption = 'Slips'
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
    Left = 296
    Top = 118
    Width = 85
    Height = 16
    Caption = 'Other Forms'
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
  object SLList: TListBox
    Left = 8
    Top = 140
    Width = 217
    Height = 408
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akBottom]
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
    OnDblClick = SLListDblClick
    OnDrawItem = SLListDrawItem
    OnKeyPress = SLListKeyPress
    OnMouseDown = SLListMouseDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1061
    Height = 112
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -25
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 1129
    object Label13: TLabel
      Left = 9
      Top = 9
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
      Left = 158
      Top = 66
      Width = 166
      Height = 16
      Caption = 'Double click a form below'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label15: TLabel
      Left = 23
      Top = 44
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
    object Label9: TLabel
      Left = 202
      Top = 44
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
      Left = 362
      Top = 8
      Width = 89
      Height = 32
      Caption = 'Open'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
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
      TabOrder = 1
      OnClick = OpenBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 362
      Top = 40
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
      Left = 362
      Top = 79
      Width = 89
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 3
      OnClick = CancelBtnClick
    end
    object FormBox: TEdit
      Left = 24
      Top = 66
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
  object OtherList: TListBox
    Left = 249
    Top = 140
    Width = 174
    Height = 408
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akBottom]
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
    OnDblClick = SLListDblClick
    OnDrawItem = SLListDrawItem
    OnKeyPress = SLListKeyPress
    OnMouseDown = SLListMouseDown
  end
end
