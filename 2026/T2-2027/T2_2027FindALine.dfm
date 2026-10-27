object FindALineT2_2027: TFindALineT2_2027
  Left = 151
  Top = 70
  Caption = 'Find A Form'
  ClientHeight = 584
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 674
    Height = 36
    Align = alTop
    Caption = 'Find a Form'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 113
    Width = 674
    Height = 471
    Align = alClient
    TabOrder = 2
    object ListBox1: TListBox
      Left = 1
      Top = 1
      Width = 672
      Height = 469
      Hint = 'Double click or Enter to go to the form'
      Align = alClient
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDblClick = ListBox1DblClick
      OnKeyPress = ListBox1KeyPress
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 36
    Width = 674
    Height = 77
    Align = alTop
    Color = 15393742
    TabOrder = 0
    object Label2: TLabel
      Left = 567
      Top = 60
      Width = 49
      Height = 15
      Caption = 'FORM ID'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 35
      Top = 35
      Width = 193
      Height = 15
      Caption = 'OR Double click any item on the list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 61
      Width = 28
      Height = 15
      Caption = 'FORM'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 104
      Top = 61
      Width = 77
      Height = 15
      Caption = 'DESCRIPTION'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 35
      Top = 14
      Width = 256
      Height = 15
      Caption = 'Enter FORM name or Keyword and press Enter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 767
      Top = 54
      Width = 197
      Height = 15
      Caption = '(i.e. T4, Donations, don, 120, ONtax)'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label11: TLabel
      Left = 238
      Top = 91
      Width = 3
      Height = 15
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 735
      Top = 14
      Width = 82
      Height = 15
      Caption = 'OR ar Keyword'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label14: TLabel
      Left = 770
      Top = 35
      Width = 88
      Height = 15
      Caption = 'and press Enter'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object EditBtn: TBitBtn
      Left = 695
      Top = 12
      Width = 33
      Height = 25
      Caption = 'Edit Contents'
      Enabled = False
      TabOrder = 2
      Visible = False
      OnClick = EditBtnClick
    end
    object ExitBtn: TBitBtn
      Left = 581
      Top = 13
      Width = 57
      Height = 25
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 3
      OnClick = ExitBtnClick
    end
    object KeyWBox: TEdit
      Left = 735
      Top = 21
      Width = 36
      Height = 21
      Enabled = False
      TabOrder = 1
      Visible = False
      OnKeyPress = KeyWBoxKeyPress
    end
    object FormBox: TEdit
      Left = 301
      Top = 14
      Width = 85
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnKeyPress = FormBoxKeyPress
    end
    object SectionBox: TEdit
      Left = 651
      Top = 14
      Width = 36
      Height = 21
      Enabled = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 4
      Visible = False
      OnKeyPress = SectionBoxKeyPress
    end
  end
end
