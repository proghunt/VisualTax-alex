object RemoveNullValues: TRemoveNullValues
  Left = 106
  Top = 59
  Caption = 'Remove Null values'
  ClientHeight = 503
  ClientWidth = 617
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 8
    Width = 98
    Height = 15
    Caption = 'Data Base Tables'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 304
    Top = 8
    Width = 67
    Height = 15
    Caption = 'Results Log'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 24
    Top = 464
    Width = 489
    Height = 15
    Caption = 
      '* Due to long running time, Accounts and Transactions are not in' +
      'cluded (and not required)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 16
    Top = 24
    Width = 169
    Height = 385
    Color = 16777198
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    Items.Strings = (
      'Clients'
      'Assets'
      'LifeInsurance'
      'ProblemsSolutions'
      'GoalsObjectives'
      'ActionGeneral'
      'ActionPlan'
      'PortFolios'
      'PortfolioDetails'
      'HeadOffice'
      'BranchOffices'
      'Agents'
      'TrustAccount'
      'TrustDeposits'
      'PayCodes'
      'PayAdjustmentsSchedule'
      'CommissionDates'
      'ClientStatementDates'
      'Liabilities')
    ParentFont = False
    TabOrder = 0
  end
  object OkBtn: TBitBtn
    Left = 160
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Ok'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 376
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object DoAllBtn: TBitBtn
    Left = 264
    Top = 424
    Width = 75
    Height = 25
    Caption = '* Do All '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = DoAllBtnClick
  end
  object ListBox2: TListBox
    Left = 224
    Top = 24
    Width = 281
    Height = 385
    Color = 15400959
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 4
  end
end
