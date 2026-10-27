object PrT5013T4T5_2026: TPrT5013T4T5_2026
  Left = 205
  Top = 271
  Caption = 'Printing of T5013 slips'
  ClientHeight = 451
  ClientWidth = 690
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label2: TLabel
    Left = 308
    Top = 28
    Width = 212
    Height = 15
    Caption = 'Total number of T5013 slips prepared: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 44
    Top = 8
    Width = 87
    Height = 18
    Caption = 'T5013 Slips'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 272
    Top = 258
    Width = 216
    Height = 14
    Caption = 'NOTE: Copy 3 includesthe instruction sheet'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object NumOfT5013Slips: TEdit
    Left = 532
    Top = 21
    Width = 33
    Height = 24
    TabStop = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object OkBtn: TBitBtn
    Left = 351
    Top = 292
    Width = 89
    Height = 33
    Caption = 'Print'
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 470
    Top = 292
    Width = 89
    Height = 33
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object ListBox1: TListBox
    Left = 14
    Top = 28
    Width = 239
    Height = 407
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 3
  end
  object SlipSelected: TRadioGroup
    Left = 266
    Top = 77
    Width = 393
    Height = 36
    Caption = 'Select slips to print'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Items.Strings = (
      'Selected Slip only'
      'All Slips')
    ParentFont = False
    TabOrder = 4
  end
  object CopySelected: TRadioGroup
    Left = 266
    Top = 140
    Width = 393
    Height = 113
    Caption = 'Select copy of slip to print'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Items.Strings = (
      'Copy 1 - For Tax Centre'
      
        'Copy 2: Recipient'#39's copy (for attachment to the income tax retur' +
        'n)'
      'Copy 3: Recipients copy (to be kept for record purposes)'
      'Copy 4: For partnership'#39's records'
      'ALL copies')
    ParentFont = False
    TabOrder = 5
  end
  object PrintDialog1: TPrintDialog
    Left = 608
    Top = 11
  end
end
