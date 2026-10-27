object AutoFillPrintT1_2026: TAutoFillPrintT1_2026
  Left = 177
  Top = 105
  Caption = 'Printable Auto-fill data'
  ClientHeight = 769
  ClientWidth = 1091
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1091
    Height = 36
    Align = alTop
    Caption = 'Auto-Fill Data'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Panel4: TPanel
    Left = 0
    Top = 36
    Width = 1091
    Height = 56
    Align = alTop
    Color = 15393742
    TabOrder = 0
    object ExitBtn: TBitBtn
      Left = 588
      Top = 6
      Width = 92
      Height = 37
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
      OnClick = ExitBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 483
      Top = 7
      Width = 85
      Height = 36
      Caption = 'Print'
      TabOrder = 1
      OnClick = PrintBtnClick
    end
    object FilterBox: TRadioGroup
      Left = 294
      Top = 0
      Width = 185
      Height = 43
      Caption = 'Show'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Slips Only'
        'All')
      TabOrder = 2
      OnClick = FilterBoxClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 92
    Width = 1091
    Height = 677
    Align = alClient
    TabOrder = 2
    object ListBox1: TListBox
      Left = 288
      Top = 1
      Width = 802
      Height = 675
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
    end
    object FileListBox1: TFileListBox
      Left = 1
      Top = 1
      Width = 287
      Height = 675
      Hint = 'Double click a file'
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 15
      Mask = '*.d'
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = FileListBox1Click
      ExplicitLeft = -5
      ExplicitTop = 6
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Left = 817
    Top = 46
  end
  object PrintDialog1: TPrintDialog
    Left = 882
    Top = 49
  end
end
