object CashRepT1_2026: TCashRepT1_2026
  Left = 107
  Top = 80
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Cash Reports'
  ClientHeight = 478
  ClientWidth = 738
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label3: TLabel
    Left = 255
    Top = 59
    Width = 80
    Height = 15
    Caption = 'Data Directory:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 7
    Top = 59
    Width = 105
    Height = 16
    Caption = 'Client Data Base'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 119
    Top = 59
    Width = 129
    Height = 15
    Caption = '(Sorted by Last Update)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 152
    Top = 8
    Width = 433
    Height = 41
    Caption = 'Select Date'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 4
      Top = 18
      Width = 174
      Height = 15
      Caption = 'Reporting payment date:  FROM'
    end
    object Label2: TLabel
      Left = 284
      Top = 18
      Width = 19
      Height = 15
      Caption = 'TO:'
    end
    object FromDt: TEdit
      Left = 184
      Top = 14
      Width = 81
      Height = 23
      TabOrder = 0
      Text = 'FromDt'
    end
    object ToDt: TEdit
      Left = 304
      Top = 14
      Width = 81
      Height = 23
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 416
    Width = 721
    Height = 49
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object PrintBtn: TBitBtn
      Left = 5
      Top = 8
      Width = 147
      Height = 31
      Caption = 'Print Cash report'
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
      TabOrder = 0
      OnClick = PrintBtnClick
    end
    object CancelBtm: TBitBtn
      Left = 646
      Top = 8
      Width = 63
      Height = 31
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtmClick
    end
    object InvoiceReportBtn: TBitBtn
      Left = 159
      Top = 8
      Width = 157
      Height = 31
      Caption = 'Print Invoice report'
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
      TabOrder = 2
      OnClick = InvoiceReportBtnClick
    end
    object EnhancedInvoiceReportBtn: TBitBtn
      Left = 322
      Top = 8
      Width = 318
      Height = 31
      Caption = 'Efiled By Preparer Invoices- Excel Worksheet'
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
      TabOrder = 3
      OnClick = EnhancedInvoiceReportBtnClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 80
    Width = 721
    Height = 321
    DataSource = DataSource1
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
    TitleFont.Height = -11
    TitleFont.Name = 'Arial'
    TitleFont.Style = []
  end
  object DataDirBox: TEdit
    Left = 363
    Top = 55
    Width = 302
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnExit = DataDirBoxExit
    OnKeyPress = DataDirBoxKeyPress
  end
  object PrintDialog1: TPrintDialog
    Left = 241
    Top = 202
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 128
    Top = 213
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 80
    Top = 160
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=c:\clients.db')
    LoginPrompt = False
    Left = 248
    Top = 177
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Clients'
    TableName = 'Clients'
    Left = 184
    Top = 185
  end
end
