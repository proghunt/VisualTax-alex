object FindALineT1_2026: TFindALineT1_2026
  Left = 61
  Top = 112
  Caption = 'Find...(EFFields.d)'
  ClientHeight = 538
  ClientWidth = 1040
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1040
    Height = 36
    Align = alTop
    Caption = 'Find a Form or Line Number'
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
    Top = 141
    Width = 1040
    Height = 397
    Align = alClient
    TabOrder = 2
    object ListBox1: TListBox
      Left = 1
      Top = 1
      Width = 1038
      Height = 395
      Hint = 'Double click or Enter to go to the form'
      Align = alClient
      Color = 15925247
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
    Width = 1040
    Height = 105
    Align = alTop
    Color = 15393742
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 49
      Width = 233
      Height = 15
      Caption = 'Enter line No OR Keyword and press Enter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 567
      Top = 88
      Width = 126
      Height = 15
      Caption = 'FORM ID   FIELD NO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 35
      Top = 70
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
      Top = 89
      Width = 63
      Height = 15
      Caption = 'FORM/LINE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 104
      Top = 89
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
      Left = 56
      Top = 28
      Width = 212
      Height = 15
      Caption = 'Enter form or Keyword and press Enter'
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
    object Label13: TLabel
      Left = 253
      Top = 0
      Width = 265
      Height = 15
      Caption = 'Pressing Enter on an empty box, shows the list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
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
    object Label15: TLabel
      Left = 413
      Top = 28
      Width = 151
      Height = 15
      Caption = 'i.e. T2124, Empl,  Business'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 413
      Top = 49
      Width = 86
      Height = 15
      Caption = 'i.e. 101 or Empl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 273
      Top = 28
      Width = 34
      Height = 15
      Caption = 'FORM'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 273
      Top = 49
      Width = 27
      Height = 15
      Caption = 'LINE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 259
      Top = 70
      Width = 502
      Height = 15
      Caption = 
        'Do not use to Find A Line - This facility is under revision due ' +
        'to line re-numbering this year'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LineBox: TEdit
      Left = 315
      Top = 49
      Width = 85
      Height = 21
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnKeyPress = LineBoxKeyPress
    end
    object EditBtn: TBitBtn
      Left = 681
      Top = 19
      Width = 33
      Height = 25
      Caption = 'Edit Contents'
      Enabled = False
      TabOrder = 3
      Visible = False
      OnClick = EditBtnClick
    end
    object ExitBtn: TBitBtn
      Left = 581
      Top = 20
      Width = 57
      Height = 25
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 4
      OnClick = ExitBtnClick
    end
    object KeyWBox: TEdit
      Left = 728
      Top = 35
      Width = 36
      Height = 21
      Enabled = False
      TabOrder = 2
      Visible = False
      OnKeyPress = KeyWBoxKeyPress
    end
    object FormBox: TEdit
      Left = 315
      Top = 28
      Width = 85
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnKeyPress = FormBoxKeyPress
    end
    object SectionBox: TEdit
      Left = 665
      Top = 49
      Width = 36
      Height = 21
      Enabled = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 5
      Visible = False
      OnKeyPress = SectionBoxKeyPress
    end
  end
end
