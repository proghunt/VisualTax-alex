object ExportToFS: TExportToFS
  Left = 85
  Top = 59
  BorderStyle = bsDialog
  Caption = 'Fund Serve Order Set-up'
  ClientHeight = 519
  ClientWidth = 761
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 256
    Top = 128
    Width = 191
    Height = 19
    Caption = 'Outstanding Field Orders'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 33
    Width = 761
    Height = 88
    Align = alTop
    Color = 13815225
    ParentColor = False
    TabOrder = 0
    object Label3: TLabel
      Left = 136
      Top = 32
      Width = 45
      Height = 15
      Caption = 'File Seq'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 552
      Top = 16
      Width = 8
      Height = 16
      Caption = '3'
    end
    object Label4: TLabel
      Left = 256
      Top = 16
      Width = 8
      Height = 16
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 392
      Top = 16
      Width = 8
      Height = 16
      Caption = '2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Image3: TImage
      Left = 328
      Top = 39
      Width = 25
      Height = 25
      Picture.Data = {
        07544269746D61707E010000424D7E0100000000000076000000280000001400
        0000160000000100040000000000080100000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00777777777777777777770000777777777777777777770000777777777707
        7777777700007777777777007777777700007777777777040777777700007777
        7777770440777777000077777777770444077777000077770000000444407777
        0000777704444444444407770000777704444444444440770000777704444444
        4444440700007777044444444444407700007777044444444444077700007777
        0000000444407777000077777777770444077777000077777777770440777777
        0000777777777704077777770000777777777700777777770000777777777707
        7777777700007777777777777777777700007777777777777777777700007777
        77777777777777770000}
      Transparent = True
    end
    object Image1: TImage
      Left = 440
      Top = 39
      Width = 25
      Height = 25
      Picture.Data = {
        07544269746D61707E010000424D7E0100000000000076000000280000001400
        0000160000000100040000000000080100000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00777777777777777777770000777777777777777777770000777777777707
        7777777700007777777777007777777700007777777777040777777700007777
        7777770440777777000077777777770444077777000077770000000444407777
        0000777704444444444407770000777704444444444440770000777704444444
        4444440700007777044444444444407700007777044444444444077700007777
        0000000444407777000077777777770444077777000077777777770440777777
        0000777777777704077777770000777777777700777777770000777777777707
        7777777700007777777777777777777700007777777777777777777700007777
        77777777777777770000}
      Transparent = True
    end
    object Label6: TLabel
      Left = 672
      Top = 16
      Width = 4
      Height = 16
    end
    object Image2: TImage
      Left = 664
      Top = 39
      Width = 25
      Height = 25
      Picture.Data = {
        07544269746D61707E010000424D7E0100000000000076000000280000001400
        0000160000000100040000000000080100000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00777777777777777777770000777777777777777777770000777777777707
        7777777700007777777777007777777700007777777777040777777700007777
        7777770440777777000077777777770444077777000077770000000444407777
        0000777704444444444407770000777704444444444440770000777704444444
        4444440700007777044444444444407700007777044444444444077700007777
        0000000444407777000077777777770444077777000077777777770440777777
        0000777777777704077777770000777777777700777777770000777777777707
        7777777700007777777777777777777700007777777777777777777700007777
        77777777777777770000}
      Transparent = True
    end
    object PrepBtn: TBitBtn
      Left = 184
      Top = 32
      Width = 145
      Height = 41
      Caption = 'Prepare FundServ  File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object TestOrProduction: TRadioGroup
      Left = 8
      Top = 16
      Width = 121
      Height = 57
      Caption = 'Test or Production'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        'Production'
        'Test')
      ParentFont = False
      TabOrder = 1
    end
    object FileSeqBox: TEdit
      Left = 144
      Top = 48
      Width = 25
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 2
      ParentFont = False
      TabOrder = 2
      Text = '00'
    end
    object SetForSelectedBtn: TBitBtn
      Left = 648
      Top = 16
      Width = 57
      Height = 17
      Caption = 'Selectted orders only'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Visible = False
    end
    object SetForAllBtn: TBitBtn
      Left = 464
      Top = 32
      Width = 193
      Height = 41
      Caption = 'Set status to Xmitted and Archive'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object CancelBtn: TBitBtn
      Left = 688
      Top = 33
      Width = 65
      Height = 40
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Kind = bkCancel
      Margin = 1
      NumGlyphs = 2
      ParentFont = False
      Spacing = -1
      TabOrder = 5
    end
    object ListFsOutFilesBtn: TBitBtn
      Left = 704
      Top = 16
      Width = 41
      Height = 17
      Caption = 'List outgoing files...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Visible = False
    end
    object TransmitBtn: TBitBtn
      Left = 352
      Top = 32
      Width = 89
      Height = 41
      Caption = 'Upload To FS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        F6010000424DF60100000000000076000000280000001E000000180000000100
        0400000000008001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888880088888888888888888888888888888800888888888888
        8888888888888888880088888888888888888888888888888800880000000000
        0000000000088888880088088888888888888888008088888800880000000000
        0000000000880888880088000A00900A00900A0000888088880088000A00900A
        00900A0000888808880088000000000000000000008888808800880000000000
        0000000000888880880088088888888888888888808888808800888088888000
        0000088888088880880088880888888888888888888088808800888880888880
        0000000888880880880088888808888800000000088880808800888888808888
        8888888888888800880088888888000000000000000000008800888888888888
        8888888888888888880088888888888888888888888888888800888888888888
        8888888888888888880088888888888888888888888888888800888888888888
        8888888888888888880088888888888888888888888888888800}
      Layout = blGlyphTop
      ParentFont = False
      Spacing = 1
      TabOrder = 7
    end
  end
  object DBNavigator1: TDBNavigator
    Left = 224
    Top = 488
    Width = 256
    Height = 22
    DataSource = TransactionsQSrc
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 1
  end
  object DBGrid2: TDBGrid
    Left = 8
    Top = 152
    Width = 729
    Height = 329
    DataSource = TransactionsQSrc
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
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ClientName'
        Width = 148
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Product'
        Title.Caption = 'Fund'
        Width = 52
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TransType'
        Width = 84
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'GrossAmount'
        Title.Caption = 'Gross'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NetAmount'
        Title.Caption = 'Net'
        Width = 57
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LastUpdate'
        Width = 78
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Status'
        Width = 59
        Visible = True
      end>
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 761
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Export Orders and Transmit to FundServ'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object TransactionsQSrc: TDataSource
    DataSet = TransactionsQ
    Left = 104
    Top = 208
  end
  object AccountQuerySource: TDataSource
    DataSet = AccountQuery
    Left = 140
    Top = 300
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=FpClients')
    Left = 245
    Top = 185
  end
  object ClientsTbl: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'CLIENTS'
    TableName = 'CLIENTS'
    Left = 172
    Top = 256
  end
  object TransactionsQ: TADQuery
    Connection = FDConnection
    SQL.Strings = (
      'Select * from Transactions')
    Left = 164
    Top = 203
  end
  object AccountQuery: TADQuery
    Connection = FDConnection
    Left = 100
    Top = 299
  end
end
