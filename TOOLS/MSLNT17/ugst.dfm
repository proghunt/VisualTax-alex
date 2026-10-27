object GST: TGST
  Left = 313
  Top = 167
  Width = 1080
  Height = 769
  Caption = 'GST'
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
  object Label1: TLabel
    Left = 385
    Top = 7
    Width = 193
    Height = 19
    Caption = 'GST/HST CALCULATION '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 329
    Top = 42
    Width = 49
    Height = 13
    Caption = 'From Date'
  end
  object Label3: TLabel
    Left = 329
    Top = 77
    Width = 39
    Height = 13
    Caption = 'To Date'
  end
  object Label4: TLabel
    Left = 448
    Top = 658
    Width = 128
    Height = 13
    Caption = 'Total GST/HST collected$'
  end
  object labelx: TLabel
    Left = 112
    Top = 588
    Width = 68
    Height = 13
    Caption = 'Total Paypal $'
  end
  object lblxx: TLabel
    Left = 63
    Top = 672
    Width = 124
    Height = 13
    Caption = 'TotalSalesWith GST/HST'
  end
  object Label5: TLabel
    Left = 112
    Top = 567
    Width = 69
    Height = 13
    Caption = 'Total Interac $'
  end
  object Label6: TLabel
    Left = 112
    Top = 546
    Width = 55
    Height = 13
    Caption = 'Total Mail $'
  end
  object Label7: TLabel
    Left = 112
    Top = 609
    Width = 77
    Height = 13
    Caption = 'Total All Gross $'
  end
  object Label8: TLabel
    Left = 112
    Top = 637
    Width = 69
    Height = 13
    Caption = '(1)-TotWithGst'
  end
  object Label9: TLabel
    Left = 336
    Top = 609
    Width = 12
    Height = 13
    Caption = '(1)'
  end
  object Label10: TLabel
    Left = 448
    Top = 630
    Width = 151
    Height = 13
    Caption = 'TotalSalesWITHOUTGST/HST'
  end
  object FromDate: TEdit
    Left = 434
    Top = 35
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'FromDate'
  end
  object ToDate: TEdit
    Left = 434
    Top = 70
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'ToDate'
  end
  object TotGstHst: TEdit
    Left = 616
    Top = 651
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'TotalGstHstCollected'
  end
  object OKbtn: TButton
    Left = 406
    Top = 567
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = OKbtnClick
  end
  object CancelBtn: TButton
    Left = 539
    Top = 567
    Width = 75
    Height = 25
    Caption = 'Exit'
    ModalResult = 2
    TabOrder = 4
    OnClick = CancelBtnClick
  end
  object ListBox1: TListBox
    Left = 14
    Top = 105
    Width = 1002
    Height = 428
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 5
  end
  object TotPayPal: TEdit
    Left = 210
    Top = 581
    Width = 121
    Height = 21
    TabOrder = 6
    Text = 'TotalPayPal'
  end
  object TotSalesWithGst: TEdit
    Left = 210
    Top = 665
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'TotSalesWithGst'
  end
  object TotInterac: TEdit
    Left = 210
    Top = 560
    Width = 121
    Height = 21
    TabOrder = 8
    Text = 'Totalnterac'
  end
  object TotMail: TEdit
    Left = 210
    Top = 539
    Width = 121
    Height = 21
    TabOrder = 9
    Text = 'TotaMail'
  end
  object TotAll: TEdit
    Left = 210
    Top = 602
    Width = 121
    Height = 21
    TabOrder = 10
    Text = 'TotalAll'
  end
  object TotDiff: TEdit
    Left = 210
    Top = 630
    Width = 121
    Height = 21
    TabOrder = 11
    Text = 'TotalDiif'
  end
  object TotSalesWithoutGst: TEdit
    Left = 616
    Top = 623
    Width = 121
    Height = 21
    TabOrder = 12
    Text = 'TotSalesWithoutGst'
  end
end
