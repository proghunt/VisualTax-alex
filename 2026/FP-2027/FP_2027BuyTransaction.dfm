object BuyTransactionFP_2012: TBuyTransactionFP_2012
  Left = 92
  Top = 86
  Caption = 'Fund Purchase Form'
  ClientHeight = 457
  ClientWidth = 747
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
  object Label2: TLabel
    Left = 0
    Top = 0
    Width = 747
    Height = 24
    Align = alTop
    Alignment = taCenter
    Caption = 'Fund Purchase'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    ExplicitWidth = 135
  end
  object Label10: TLabel
    Left = 96
    Top = 376
    Width = 80
    Height = 13
    Caption = 'Purchased funds'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object GroupBox2: TGroupBox
    Left = 256
    Top = 400
    Width = 433
    Height = 49
    TabOrder = 0
    object Label12: TLabel
      Left = 16
      Top = 16
      Width = 30
      Height = 13
      Caption = 'Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object CancelBtn: TBitBtn
      Left = 312
      Top = 16
      Width = 73
      Height = 25
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
    end
    object SelectedItem: TEdit
      Left = 8
      Top = 376
      Width = 65
      Height = 21
      TabOrder = 1
      Text = 'SelectedItem'
      Visible = False
    end
    object SaveBtn: TBitBtn
      Left = 192
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Save'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object StatusBox: TComboBox
      Left = 56
      Top = 16
      Width = 105
      Height = 21
      TabOrder = 3
      Text = 'StatusBox'
      Items.Strings = (
        'WIP'
        'Hold'
        'HO Ready'
        'Xmitted'
        'Accepted'
        'Rejected'
        'Posted'
        'Settled'
        'Finished')
    end
  end
  object ListBox1: TListBox
    Left = 40
    Top = 392
    Width = 185
    Height = 73
    Color = clWhite
    Enabled = False
    ItemHeight = 13
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 24
    Width = 747
    Height = 353
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Base data'
      object Panel2: TPanel
        Left = 8
        Top = 0
        Width = 729
        Height = 321
        TabOrder = 0
        object OptionsPanel: TGroupBox
          Left = 441
          Top = 176
          Width = 248
          Height = 137
          Caption = 'Options'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          object Label32: TLabel
            Left = 8
            Top = 16
            Width = 84
            Height = 13
            Caption = 'SettlementSource'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label26: TLabel
            Left = 8
            Top = 56
            Width = 103
            Height = 13
            Caption = 'Settlemement Method'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label1: TLabel
            Left = 8
            Top = 96
            Width = 78
            Height = 13
            Caption = 'Source of Funds'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object SettlementMethodBox: TComboBox
            Left = 8
            Top = 72
            Width = 217
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Items.Strings = (
              'C Cheque'
              'E EFT'
              '# N/A')
          end
          object SettlementSourceBox: TComboBox
            Left = 8
            Top = 32
            Width = 217
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Items.Strings = (
              'D Dealer'
              'I Intermediary'
              'F Fund Company ')
          end
          object SourceOfFundsBox: TComboBox
            Left = 8
            Top = 112
            Width = 217
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Items.Strings = (
              'B Bank account'
              'C Capital gains portion of distribution'
              'D Entire distribution'
              'I Interest portion of distribution'
              'L Limited partnership'
              'F Fund Company account'
              'O Other Income portion of distribution'
              'R Foreign non-business income portion of distribution'
              'T Non-taxable return of capital gain portion of distribution'
              'V Dividends portion of distribution')
          end
        end
        object GroupBox3: TGroupBox
          Left = 16
          Top = 19
          Width = 417
          Height = 294
          Caption = 'Fund and Account data'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          object Label5: TLabel
            Left = 16
            Top = 64
            Width = 67
            Height = 13
            Caption = 'Fund Account'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label6: TLabel
            Left = 16
            Top = 192
            Width = 36
            Height = 13
            Caption = 'Amount'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label8: TLabel
            Left = 16
            Top = 24
            Width = 24
            Height = 13
            Caption = 'Fund'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label7: TLabel
            Left = 16
            Top = 160
            Width = 59
            Height = 13
            Caption = 'Amount type'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label11: TLabel
            Left = 16
            Top = 88
            Width = 24
            Height = 13
            Caption = 'Type'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object TLabel
            Left = 16
            Top = 112
            Width = 60
            Height = 13
            Caption = 'Intermediary:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label13: TLabel
            Left = 80
            Top = 112
            Width = 40
            Height = 13
            Caption = 'Account'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label16: TLabel
            Left = 240
            Top = 112
            Width = 25
            Height = 13
            Caption = 'Code'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object AccountBox: TEdit
            Left = 128
            Top = 56
            Width = 97
            Height = 21
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object AmountBox: TEdit
            Left = 96
            Top = 184
            Width = 81
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object AmountTypeBox: TComboBox
            Left = 96
            Top = 160
            Width = 217
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Items.Strings = (
              'D   Dollars'
              'S   Shares/units')
          end
          object ProductBox: TEdit
            Left = 128
            Top = 16
            Width = 97
            Height = 21
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
          object SelectAccountBtn: TBitBtn
            Left = 240
            Top = 59
            Width = 89
            Height = 17
            Caption = 'Select Account...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
          object AccountTypeBox: TComboBox
            Left = 128
            Top = 80
            Width = 97
            Height = 21
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            Items.Strings = (
              'OPEN'
              'RRSP'
              'RRIF'
              'RESP'
              'DPSP'
              'RHOSP'
              'OTHER'
              'LIF'
              'LIRA'
              'LRIF')
          end
          object NewAccountBtn: TBitBtn
            Left = 352
            Top = 59
            Width = 49
            Height = 17
            Caption = 'New...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 6
          end
          object IntermediaryCodeBox: TEdit
            Left = 272
            Top = 104
            Width = 41
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 7
          end
          object IntermediaryAccountBox: TEdit
            Left = 128
            Top = 104
            Width = 97
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 8
          end
          object BitBtn1: TBitBtn
            Left = 240
            Top = 19
            Width = 81
            Height = 17
            Caption = 'Select Fund...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 9
          end
          object PortfolioBtn: TBitBtn
            Left = 360
            Top = 19
            Width = 41
            Height = 17
            Caption = 'Select Portfolio...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 10
            Visible = False
          end
        end
        object GroupBox4: TGroupBox
          Left = 441
          Top = 23
          Width = 248
          Height = 146
          Caption = 'Commission Settlement'
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          object Label14: TLabel
            Left = 96
            Top = 88
            Width = 45
            Height = 13
            Caption = 'Dsc-Rate'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label15: TLabel
            Left = 104
            Top = 64
            Width = 38
            Height = 13
            Caption = 'Fe-Rate'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label3: TLabel
            Left = 24
            Top = 24
            Width = 70
            Height = 13
            Caption = 'Manager Code'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Fe_RateBox: TEdit
            Left = 152
            Top = 56
            Width = 49
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Dsc_RateBox: TEdit
            Left = 152
            Top = 80
            Width = 49
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object GrossNetBox: TRadioGroup
            Left = 24
            Top = 48
            Width = 57
            Height = 57
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            Items.Strings = (
              'Gross'
              'Net')
            ParentFont = False
            TabOrder = 2
          end
          object ManagerCodeBox: TEdit
            Left = 112
            Top = 24
            Width = 49
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
          object SelectAnAgentBtn: TBitBtn
            Left = 175
            Top = 24
            Width = 25
            Height = 25
            Caption = '...'
            TabOrder = 4
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Contribution/SystematicPlan'
      ImageIndex = 1
      object SysPlanPanel: TGroupBox
        Left = 16
        Top = 100
        Width = 321
        Height = 185
        Caption = 'Systematic Plan'
        Color = 11842740
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        object Label38: TLabel
          Left = 16
          Top = 22
          Width = 41
          Height = 13
          Caption = 'Indicator'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label39: TLabel
          Left = 16
          Top = 70
          Width = 48
          Height = 13
          Caption = 'Start Date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label40: TLabel
          Left = 16
          Top = 94
          Width = 48
          Height = 13
          Caption = 'Stop Date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label41: TLabel
          Left = 16
          Top = 116
          Width = 60
          Height = 13
          Caption = 'Restart Date'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label42: TLabel
          Left = 16
          Top = 140
          Width = 36
          Height = 13
          Caption = 'Amount'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label43: TLabel
          Left = 16
          Top = 164
          Width = 63
          Height = 13
          Caption = 'Commission%'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label44: TLabel
          Left = 16
          Top = 40
          Width = 50
          Height = 13
          Caption = 'Frequency'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SysPlanFreqBox: TComboBox
          Left = 96
          Top = 40
          Width = 217
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Items.Strings = (
            '1 Monthly'
            '2 Bi-Monthly  (Every Other Month)'
            '3 Quarterly'
            '4 Semi-Annually'
            '5 Annually'
            '6 Weekly'
            '7 Bi-Weekly (Every Other Week)'
            '8 Semi-Monthly (Twice Monthly)'
            'Z Other (Special Arrangements)'
            '# Not Applicable')
        end
        object SysPlanIndicatorBox: TComboBox
          Left = 96
          Top = 16
          Width = 217
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Items.Strings = (
            '# Not Applicable'
            'A AWD'
            'P PAC'
            'S Systematic Switch From One Fund To Another Fund '
            
              'T Systematic Transfer From One Fund Account To Another Fund Acco' +
              'unt'
            
              'D Automatic Redirection Of Distributions/Dividends From One Acco' +
              'unt/Fund To One Or More Account/Fund(S).'
            'M Multiple Systematic Plans On An Account/Fund')
        end
        object SysPlanStartDateBox: TEdit
          Left = 96
          Top = 64
          Width = 121
          Height = 21
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object SysPlanStopDateBox: TEdit
          Left = 96
          Top = 88
          Width = 121
          Height = 21
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object SysPlanRestartDateBox: TEdit
          Left = 96
          Top = 112
          Width = 121
          Height = 21
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object SysPlanAmountBox: TEdit
          Left = 96
          Top = 136
          Width = 121
          Height = 21
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object SysPlanCommRateBox: TEdit
          Left = 96
          Top = 160
          Width = 121
          Height = 21
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
      end
      object GroupBox10: TGroupBox
        Left = 16
        Top = 20
        Width = 321
        Height = 69
        Caption = 'Contribution'
        Color = 11842740
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        object Label36: TLabel
          Left = 11
          Top = 44
          Width = 30
          Height = 13
          Caption = 'Period'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label37: TLabel
          Left = 8
          Top = 19
          Width = 25
          Height = 13
          Caption = 'Code'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object ContrPeriodBox: TComboBox
          Left = 96
          Top = 40
          Width = 217
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Items.Strings = (
            'C  (Current)  Issue(d) Receipt for Current Period '
            'P  (Previous)  Issue(d)  Receipt for Previous Period'
            
              'X  (neXt)  Issue(d) Receipt for Next Period  (Rest of year if do' +
              'ne in first 60 days)'
            '#  Not applicable')
        end
        object ContrCodeBox: TComboBox
          Left = 96
          Top = 16
          Width = 217
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Items.Strings = (
            
              '  N/A (Non-registered Account, or New Money Purchase into Regist' +
              'ered Account (e.g. Tax Receipt Produced).'
            'R  T2033 Transfer  (Direct Transfer)'
            'L  60L Transfer on Death'
            'J  60J  Pension Transfer')
        end
      end
    end
  end
  object DataSource2: TDataSource
    DataSet = TransactionsTbl
    Left = 400
    Top = 176
  end
  object DataSource1: TDataSource
    DataSet = PortfolioDetailsQ
    Left = 404
    Top = 259
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 325
    Top = 121
  end
  object TransactionsTbl: TADTable
    Connection = FDConnection
    Left = 364
    Top = 120
  end
  object PortfolioDetailsQ: TADQuery
    Connection = FDConnection
    Left = 340
    Top = 259
  end
end
