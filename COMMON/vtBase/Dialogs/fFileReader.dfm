object FileReader: TFileReader
  Left = 88
  Top = 102
  Caption = 'File Reader (TXT, DOC, RTF, LTR)'
  ClientHeight = 554
  ClientWidth = 771
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Label2: TLabel
    Left = 233
    Top = 52
    Width = 84
    Height = 17
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Caption = 'Current File: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 771
    Height = 156
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 1
    object FileNameLbl: TLabel
      Left = 233
      Top = 86
      Width = 509
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      AutoSize = False
      Caption = '(None)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 17
      Top = 17
      Width = 91
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Caption = 'File Extension'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 17
      Top = 86
      Width = 88
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Caption = 'Selected File:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 17
      Top = 60
      Width = 106
      Height = 17
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Caption = 'Selected Folder:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 17
      Top = 112
      Width = 640
      Height = 34
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Caption = 
        'To Copy: Highligt the text and Press Ctrl C. Once you return to ' +
        'your original document, position the cursor on the desired spot ' +
        'and press Ctrl V to Paste it.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object ExitBtn: TBitBtn
      Left = 431
      Top = 9
      Width = 92
      Height = 35
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object SelectDirBtn1: TBitBtn
      Left = 133
      Top = 52
      Width = 92
      Height = 29
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Select folder...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = SelectDirBtn1Click
    end
    object ExtensionBox: TComboBox
      Left = 129
      Top = 17
      Width = 90
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 2
      OnClick = ExtensionBoxClick
      Items.Strings = (
        'TXT'
        'RTF'
        'DOC'
        'LTR')
    end
    object FromDirBox: TEdit
      Left = 233
      Top = 52
      Width = 509
      Height = 23
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'FromDirBox'
      OnExit = FromDirBoxExit
      OnKeyPress = FromDirBoxKeyPress
    end
    object OpenBtn: TBitBtn
      Left = 293
      Top = 9
      Width = 92
      Height = 35
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Open'
      TabOrder = 4
      OnClick = OpenBtnClick
    end
    object SelectFileBtn: TBitBtn
      Left = 577
      Top = 9
      Width = 27
      Height = 30
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'SelectFileBtn'
      TabOrder = 5
      Visible = False
      OnClick = SelectFileBtnClick
    end
  end
  object FileListBox1: TFileListBox
    Left = 0
    Top = 156
    Width = 191
    Height = 398
    Hint = 'Double click to Open it'
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alLeft
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = FileListBox1Click
    OnDblClick = FileListBox1DblClick
  end
  object ARichEdit: TvtRichMemo
    Left = 191
    Top = 156
    Width = 580
    Height = 398
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'ARichEdit')
    ParentFont = False
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.Txt;*.DOC;*.RTF;*.LTR;'
    InitialDir = 'C:\'
    Left = 504
    Top = 7
  end
end
