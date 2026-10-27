object EmptyFpTables: TEmptyFpTables
  Left = 188
  Top = 31
  Width = 353
  Height = 436
  Caption = 'Empty FPClients Data Base'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 16
    Top = 16
    Width = 313
    Height = 337
    ItemHeight = 13
    Items.Strings = (
      'Agents'
      'BranchOffices'
      'HeadOffice'
      'BranchOffices'
      'Clients'
      'Assets'
      'Liabilities'
      'LifeInsurance'
      'ProblemsSolutions'
      'GoalsObjectives'
      'ActionGeneral'
      'ActionPlan'
      'PortFolios'
      'PortfolioDetails'
      'Accounts'
      'PayAdjustmentsSchedule'
      'TrustDeposits'
      'TrustAccount'
      'Transactions')
    TabOrder = 0
  end
  object OkBtn: TBitBtn
    Left = 16
    Top = 368
    Width = 49
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    Visible = False
  end
  object CancelBtn: TBitBtn
    Left = 200
    Top = 368
    Width = 105
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object EmptyAllBtn: TBitBtn
    Left = 80
    Top = 368
    Width = 105
    Height = 25
    Caption = 'Empty All'
    TabOrder = 3
  end
end
