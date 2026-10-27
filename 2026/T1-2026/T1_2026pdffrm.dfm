object PDFFrmT1_2026: TPDFFrmT1_2026
  Left = 169
  Top = 188
  Width = 592
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
    Left = 8
    Top = 57
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
    Left = 8
    Top = 89
    Width = 479
    Height = 16
    Caption = 
      'This creates a '#39'printer'#39' on your Control Panel | Printers by the' +
      ' name of PDFFactory '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label7: TLabel
    Left = 8
    Top = 151
    Width = 340
    Height = 16
    Caption = 'PDF files can then be attached in EMails, saved or printed '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label14: TLabel
    Left = 8
    Top = 41
    Width = 309
    Height = 19
    Caption = 'PDF and EMail attachment of a tax return'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 8
    Top = 175
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
    Left = 8
    Top = 199
    Width = 342
    Height = 16
    Caption = 'Also, you can download such driver from www.fineprint.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label18: TLabel
    Left = 8
    Top = 215
    Width = 491
    Height = 16
    Caption = 
      'Then you can print 4 pages in one page i.e. print the T1 jacket ' +
      '(4 pages)  in one page'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label21: TLabel
    Left = 8
    Top = 73
    Width = 408
    Height = 16
    Caption = 
      'You can download and install a free demo PDF driver by clicking ' +
      'here: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object FinePrintLbl: TLabel
    Left = 418
    Top = 73
    Width = 125
    Height = 16
    Caption = ' www.fineprint.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    OnClick = FinePrintLblClick
  end
  object Label1: TLabel
    Left = 8
    Top = 113
    Width = 506
    Height = 32
    Caption = 
      'Once you have such a driver, you can print any report from any s' +
      'oftware in PDF format. Just select the PDFFactory printer instea' +
      'd of your normal printer..'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 25
    Align = alTop
    Caption = 'Special Printing (PDF Format OR Multiple pages in one)'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object CancelBtn: TBitBtn
    Left = 237
    Top = 256
    Width = 86
    Height = 25
    Caption = 'Exit'
    TabOrder = 1
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
end
