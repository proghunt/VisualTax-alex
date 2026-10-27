object TrustReconciliation: TTrustReconciliation
  Left = 66
  Top = 82
  BorderStyle = bsDialog
  ClientHeight = 489
  ClientWidth = 795
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 96
    Top = 88
    Width = 106
    Height = 15
    Caption = 'Expected Deposits'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 496
    Top = 88
    Width = 75
    Height = 15
    Caption = 'Order Details'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 795
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Reconciliation with the Trust Account'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object CancelBtn: TBitBtn
      Left = 656
      Top = 10
      Width = 65
      Height = 23
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Kind = bkCancel
      Margin = 2
      NumGlyphs = 2
      ParentFont = False
      Spacing = -1
      TabOrder = 0
      OnClick = CancelBtnClick
    end
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 459
    Width = 328
    Height = 22
    DataSource = datasource2
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 1
  end
  object DBGrid2: TDBGrid
    Left = 360
    Top = 104
    Width = 433
    Height = 313
    DataSource = DataSource1
    FixedColor = 10930928
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Arial'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'TransactionId'
        Width = 96
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Status'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DepositRefNo'
        Title.Caption = 'Deposit Ref. No'
        Width = 98
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'GrossAmount'
        Title.Caption = 'Gross'
        Visible = True
      end>
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 104
    Width = 337
    Height = 313
    DataSource = datasource2
    FixedColor = 10930928
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Arial'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    Columns = <
      item
        Expanded = False
        FieldName = 'AgentCode'
        Width = 67
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LastUpdate'
        Title.Caption = 'Date'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ClientId'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TotalAmount'
        Width = 74
        Visible = True
      end>
  end
  object DBNavigator2: TDBNavigator
    Left = 352
    Top = 459
    Width = 408
    Height = 22
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 795
    Height = 48
    Align = alTop
    TabOrder = 5
    object ShowOnlyBox: TRadioGroup
      Left = 304
      Top = 8
      Width = 185
      Height = 33
      Caption = 'Show only orders with status'
      Columns = 2
      Items.Strings = (
        'HO Ready'
        'On Hold')
      TabOrder = 0
      OnClick = ShowOnlyBoxClick
    end
  end
  object PutOnHoldBtn: TBitBtn
    Left = 224
    Top = 424
    Width = 161
    Height = 25
    Caption = 'Place this order on '#39'Hold'#39
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = PutOnHoldBtnClick
  end
  object PutHOReadyBtn: TBitBtn
    Left = 400
    Top = 424
    Width = 161
    Height = 25
    Caption = 'Make this order '#39'HO Ready'#39
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = PutHOReadyBtnClick
  end
  object datasource2: TDataSource
    DataSet = ExpectedDepositsQ
    Left = 192
    Top = 208
  end
  object DataSource1: TDataSource
    DataSet = TransactionsQ
    Left = 448
    Top = 216
  end
  object ExpectedDepositsQ: TADQuery
    Connection = eFDConnection
    SQL.Strings = (
      
        'Select AgentCode, LastUpdate, ClientId, Sum(NetAmount) as TotalA' +
        'mount'
      'from Transactions '
      
        'WHERE Trim(TransactionType) = '#39'BUY'#39' AND Trim(Status) = '#39'HO Ready' +
        #39
      'GROUP BY AgentCode, LastUpdate, ClientId')
    Left = 140
    Top = 139
  end
  object eFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 181
    Top = 145
  end
  object TransactionsQ: TADQuery
    Connection = tFDConnection
    SQL.Strings = (
      'Select * from Transactions'
      'ORDER BY AgentCode, LastUpdate, ClientId')
    Left = 484
    Top = 163
  end
  object tFDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 445
    Top = 129
  end
end
