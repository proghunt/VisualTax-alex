object MortgageCalculatorFP_2012: TMortgageCalculatorFP_2012
  Left = 85
  Top = 57
  Width = 726
  Height = 585
  Caption = 'Canadian Mortgage Calculator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 32
    Width = 50
    Height = 16
    Caption = 'Principal'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 216
    Top = 16
    Width = 90
    Height = 16
    Caption = 'Interest Rate %'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 128
    Top = 32
    Width = 73
    Height = 16
    Caption = 'Amortization'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 128
    Top = 48
    Width = 83
    Height = 16
    Caption = 'Period (Years)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 64
    Top = 118
    Width = 65
    Height = 16
    Caption = 'Period (M)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 144
    Top = 118
    Width = 80
    Height = 16
    Caption = 'Interest Paid'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 272
    Top = 118
    Width = 90
    Height = 16
    Caption = 'Principal Paid'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 496
    Top = 118
    Width = 130
    Height = 16
    Caption = 'Principal Remaining'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 336
    Top = 32
    Width = 121
    Height = 16
    Caption = 'Monthly Payment ($)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label12: TLabel
    Left = 16
    Top = 48
    Width = 64
    Height = 16
    Caption = 'Amount ($)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Bevel3: TBevel
    Left = 16
    Top = 102
    Width = 641
    Height = 9
    Shape = bsBottomLine
    Style = bsRaised
  end
  object Label5: TLabel
    Left = 384
    Top = 118
    Width = 86
    Height = 16
    Caption = 'Total Monthly'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label10: TLabel
    Left = 24
    Top = 118
    Width = 29
    Height = 16
    Caption = 'Year'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label14: TLabel
    Left = 24
    Top = 485
    Width = 120
    Height = 16
    Caption = 'Total Interest Paid:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 232
    Top = 46
    Width = 76
    Height = 16
    Caption = 'Compounded'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 232
    Top = 62
    Width = 80
    Height = 16
    Caption = 'semi-annually'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label16: TLabel
    Left = 232
    Top = 32
    Width = 59
    Height = 16
    Caption = 'Interest %'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object resultList: TListBox
    Left = 16
    Top = 134
    Width = 641
    Height = 321
    TabStop = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 7
  end
  object CalcBtn: TButton
    Left = 584
    Top = 56
    Width = 73
    Height = 33
    Caption = 'Calculate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = CalcBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 424
    Top = 477
    Width = 73
    Height = 33
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
  object PrintBtn: TBitBtn
    Left = 312
    Top = 477
    Width = 81
    Height = 33
    Caption = 'Print'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = PrintBtnClick
    Glyph.Data = {
      56020000424D5602000000000000760000002800000024000000180000000100
      040000000000E001000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      8888888888888888888888880000888888888888888888888888888888888888
      0000888888888888888888888888888888888888000088888888888888888888
      8888888888888888000088888877000000000000000007788888888800008888
      8800000000000000000000078888888800008888877777777777777777777770
      788888880000888887F888888888888888888777078888880000888887F88888
      8888888889988777707888880000888887F88888888888888998877777088888
      0000888887F8CCCC8888888889988777770888880000888887F8888888888888
      88888877770888880000888887FFFFFFFFFFFFFFFFF888877708888800008888
      878FFFFFFFFFFFFFFFF8888877088888000088888878FF000000000000008888
      870888880000888888878FF07FFFFFFFFF707888880888880000888888887888
      74444444FF7007888708888800008888888887007FFFFFFFFF70000000888888
      00008888888888887F4444444F7888888888888800008888888888887FFFFFFF
      FF78888888888888000088888888888887F4444444F788888888888800008888
      8888888887FFFFFFFFF788888888888800008888888888888888888888888888
      8888888800008888888888888888888888888888888888880000}
  end
  object PaymentBox: TEdit
    Left = 336
    Top = 78
    Width = 81
    Height = 24
    Hint = 'Enter 0 to calculate'
    TabOrder = 3
    Text = '0'
  end
  object InterestBox: TEdit
    Left = 232
    Top = 78
    Width = 49
    Height = 24
    Hint = 'Compunded Semi-annually'
    TabOrder = 2
    Text = '0'
  end
  object YearsBox: TEdit
    Left = 128
    Top = 78
    Width = 49
    Height = 24
    TabOrder = 1
    Text = '0'
  end
  object PrincipalBox: TEdit
    Left = 16
    Top = 78
    Width = 89
    Height = 24
    TabOrder = 0
    Text = '0'
  end
  object FindMinimumOptionBox: TCheckBox
    Left = 336
    Top = 48
    Width = 241
    Height = 17
    Caption = 'Calculate Minimum monthly payment'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 718
    Height = 33
    Align = alTop
    Caption = 'Mortgage Calculator'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
  end
  object TotInterestPaidBox: TEdit
    Left = 152
    Top = 477
    Width = 81
    Height = 24
    TabOrder = 10
    Text = '0'
  end
  object PrintDialog1: TPrintDialog
    Left = 475
    Top = 389
  end
end
