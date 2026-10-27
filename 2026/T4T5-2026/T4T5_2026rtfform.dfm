object RTFFormT4T5_2026: TRTFFormT4T5_2026
  Left = 88
  Top = 102
  Caption = 'File Reader (TXT, DOC, RTF, LTR)'
  ClientHeight = 547
  ClientWidth = 763
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 189
    Top = 42
    Width = 70
    Height = 15
    Caption = 'Current File: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 763
    Height = 127
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 771
    object FileNameLbl: TLabel
      Left = 189
      Top = 70
      Width = 414
      Height = 13
      AutoSize = False
      Caption = '(None)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 14
      Top = 14
      Width = 77
      Height = 15
      Caption = 'File Extension'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 14
      Top = 70
      Width = 74
      Height = 15
      Caption = 'Selected File:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 14
      Top = 49
      Width = 89
      Height = 15
      Caption = 'Selected Folder:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 14
      Top = 91
      Width = 533
      Height = 30
      Caption = 
        'To Copy: Highligt the text and Press Ctrl C. Once you return to ' +
        'your original document, position the cursor on the desired spot ' +
        'and press Ctrl V to Paste it.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object ExitBtn: TBitBtn
      Left = 350
      Top = 7
      Width = 75
      Height = 29
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object SelectDirBtn1: TBitBtn
      Left = 108
      Top = 42
      Width = 75
      Height = 24
      Caption = 'Select folder...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = SelectDirBtn1Click
    end
    object ExtensionBox: TComboBox
      Left = 105
      Top = 14
      Width = 73
      Height = 21
      TabOrder = 2
      OnClick = ExtensionBoxClick
      Items.Strings = (
        'TXT'
        'RTF'
        'DOC'
        'LTR')
    end
    object FromDirBox: TEdit
      Left = 189
      Top = 42
      Width = 414
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'FromDirBox'
      OnExit = FromDirBoxExit
      OnKeyPress = FromDirBoxKeyPress
    end
    object OpenBtn: TBitBtn
      Left = 238
      Top = 7
      Width = 75
      Height = 29
      Caption = 'Open'
      TabOrder = 4
      OnClick = OpenBtnClick
    end
    object SelectFileBtn: TBitBtn
      Left = 469
      Top = 7
      Width = 22
      Height = 25
      Caption = 'SelectFileBtn'
      TabOrder = 5
      Visible = False
      OnClick = SelectFileBtnClick
    end
  end
  object FileListBox1: TFileListBox
    Left = 0
    Top = 127
    Width = 155
    Height = 420
    Hint = 'Double click to Open it'
    Align = alLeft
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = FileListBox1Click
    OnDblClick = FileListBox1DblClick
    ExplicitHeight = 432
  end
  object ARichEdit: TvtRichMemo
    Left = 155
    Top = 127
    Width = 608
    Height = 420
    DrawEndPage = False
    Align = alClient
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 2
    ExplicitWidth = 616
    ExplicitHeight = 432
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.Txt;*.DOC;*.RTF;*.LTR;'
    InitialDir = 'C:\'
    Left = 504
    Top = 7
  end
end
