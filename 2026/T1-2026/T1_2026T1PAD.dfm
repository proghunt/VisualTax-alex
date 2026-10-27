object T1PadT1_2026: TT1PadT1_2026
  Left = 0
  Top = 0
  Caption = 'T1PadT1_2026'
  ClientHeight = 496
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 64
    Top = 279
    Width = 68
    Height = 13
    Caption = 'Payment Date'
  end
  object Label3: TLabel
    Left = 64
    Top = 298
    Width = 37
    Height = 13
    Caption = 'Amount'
  end
  object Label4: TLabel
    Left = 64
    Top = 160
    Width = 133
    Height = 13
    Caption = 'Financial Institution Number'
  end
  object Label5: TLabel
    Left = 64
    Top = 179
    Width = 73
    Height = 13
    Caption = 'Branch Number'
  end
  object Label6: TLabel
    Left = 64
    Top = 211
    Width = 39
    Height = 13
    Caption = 'Account'
  end
  object Label7: TLabel
    Left = 8
    Top = 84
    Width = 114
    Height = 13
    Caption = 'URL for PAD connection'
  end
  object PADbtn: TButton
    Left = 149
    Top = 384
    Width = 125
    Height = 53
    Caption = 'Connent / Transmit'
    TabOrder = 0
    OnClick = PADbtnClick
  end
  object PaymentDateEdit: TEdit
    Left = 220
    Top = 275
    Width = 121
    Height = 21
    TabStop = False
    Enabled = False
    ReadOnly = True
    TabOrder = 1
    Text = '2017-07-10'
  end
  object PaymentAmountEdit: TEdit
    Left = 220
    Top = 300
    Width = 121
    Height = 21
    TabStop = False
    Enabled = False
    ReadOnly = True
    TabOrder = 2
    Text = '1413.09'
  end
  object FinancialInstitutionNumberEdit: TEdit
    Left = 220
    Top = 154
    Width = 121
    Height = 21
    TabStop = False
    Enabled = False
    ReadOnly = True
    TabOrder = 3
    Text = '003'
  end
  object FinancialInstitutionBranchNumberEdit: TEdit
    Left = 220
    Top = 181
    Width = 121
    Height = 21
    TabStop = False
    Enabled = False
    ReadOnly = True
    TabOrder = 4
    Text = '00002'
  end
  object FinancialInstitutionAccountNumberEdit: TEdit
    Left = 220
    Top = 208
    Width = 121
    Height = 21
    TabStop = False
    Enabled = False
    ReadOnly = True
    TabOrder = 5
    Text = '3333AAA'
  end
  object testPADResponsebtn: TButton
    Left = 287
    Top = 441
    Width = 121
    Height = 25
    Caption = 'test PADResponsebtn'
    TabOrder = 6
    Visible = False
    OnClick = testPADResponsebtnClick
  end
  object EfileType: TPanel
    Left = 0
    Top = 0
    Width = 533
    Height = 29
    Hint = 'Click to change tax year and rates'
    Align = alTop
    BevelOuter = bvNone
    Caption = 'PAD -  Pre-Authorized Debit'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
  end
  object TestOrProductionGroup: TRadioGroup
    Left = 114
    Top = 33
    Width = 285
    Height = 45
    Caption = 'Production or Test'
    Color = clBtnFace
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Production (users)'
      'Test (developer)')
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 8
    OnClick = TestOrProductionGroupClick
  end
  object CancelBtn: TBitBtn
    Left = 285
    Top = 384
    Width = 121
    Height = 53
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 9
  end
  object UrlBox: TEdit
    Left = 8
    Top = 101
    Width = 511
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
  end
  object PadInfoBtn: TButton
    Left = 64
    Top = 129
    Width = 121
    Height = 25
    Caption = 'Data from PadInfo'
    TabOrder = 11
    OnClick = PadInfoBtnClick
  end
  object T183Btn: TButton
    Left = 64
    Top = 248
    Width = 126
    Height = 25
    Caption = 'Data From T185'
    TabOrder = 12
    OnClick = T183BtnClick
  end
  object showPADXML: TButton
    Left = 147
    Top = 441
    Width = 127
    Height = 25
    Caption = 'show PAD XML'
    TabOrder = 13
    OnClick = showPADXMLClick
  end
  object OpenDialog1: TOpenDialog
    Left = 81
    Top = 362
  end
end
