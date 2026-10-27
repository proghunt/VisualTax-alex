object PDFFrmT4T5_2026: TPDFFrmT4T5_2026
  Left = 102
  Top = 80
  Width = 756
  Height = 335
  Caption = 'PDF and 4-in-one'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 40
    Top = 64
    Width = 451
    Height = 16
    Caption = 
      'You will need to install a PDF driver in order to create PDF fil' +
      'es from tax forms'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 40
    Top = 96
    Width = 539
    Height = 16
    Caption = 
      'This creates a '#39'printer'#39' on your Control Panel | Printers by the' +
      ' name of FinePrint PDF Factory '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label7: TLabel
    Left = 40
    Top = 120
    Width = 347
    Height = 16
    Caption = 'PDF files can then be saved or printed or attached in EMails'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label14: TLabel
    Left = 40
    Top = 48
    Width = 37
    Height = 19
    Caption = 'PDF '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 40
    Top = 152
    Width = 307
    Height = 19
    Caption = 'Multiple pages in one (normally 4-in-one)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label17: TLabel
    Left = 40
    Top = 176
    Width = 310
    Height = 16
    Caption = 'You can download such driver from www.fineprint.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label18: TLabel
    Left = 40
    Top = 192
    Width = 429
    Height = 16
    Caption = 
      'Then you can print 4 pages in one page i.e. print the T1 jacket ' +
      'in one page'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label21: TLabel
    Left = 40
    Top = 80
    Width = 424
    Height = 16
    Caption = 
      'You can download and install a free demo PDF driver by clicking ' +
      'here --> '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object FinePrintLbl: TLabel
    Left = 464
    Top = 80
    Width = 125
    Height = 16
    Caption = ' www.fineprint.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8421440
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = FinePrintLblClick
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 748
    Height = 25
    Align = alTop
    Caption = 'Special Printing (PDF Format OR Multiple pages in one)'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object OKBtn: TBitBtn
    Left = 216
    Top = 240
    Width = 129
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 360
    Top = 240
    Width = 153
    Height = 25
    TabOrder = 2
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
end
