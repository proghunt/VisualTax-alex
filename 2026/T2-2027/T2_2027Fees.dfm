object FeesT2_2027: TFeesT2_2027
  Left = 180
  Top = 186
  BorderIcons = [biSystemMenu]
  Caption = 'Fee Schedule'
  ClientHeight = 558
  ClientWidth = 623
  Color = 13353654
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
  object Label1: TLabel
    Left = 0
    Top = 446
    Width = 286
    Height = 13
    Caption = 
      '* Applies to any of the Multiple forms (Foreign tax credits, etc' +
      ')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 399
    Top = 18
    Width = 116
    Height = 14
    Caption = 'Full Path of fees text file'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 64
    Width = 587
    Height = 350
    Color = clWhite
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Ms Sans Serif'
    TitleFont.Style = [fsBold]
  end
  object OKBtn: TBitBtn
    Left = 512
    Top = 419
    Width = 91
    Height = 25
    Caption = '&Save'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 512
    Top = 443
    Width = 91
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object DBNavigator1: TDBNavigator
    Left = 192
    Top = 419
    Width = 208
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object SortBy: TRadioGroup
    Left = 16
    Top = 0
    Width = 177
    Height = 57
    Caption = 'Sort &by:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Items.Strings = (
      'Form Name'
      'Fee (descending)')
    ParentFont = False
    TabOrder = 4
    OnClick = SortByClick
  end
  object ExportBtn: TBitBtn
    Left = 200
    Top = 8
    Width = 193
    Height = 23
    Caption = 'Export fees to text file (for back-up)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = ExportBtnClick
  end
  object FlBox: TEdit
    Left = 400
    Top = 32
    Width = 203
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = 'FlBox'
  end
  object ImportBtn: TBitBtn
    Left = 200
    Top = 32
    Width = 193
    Height = 23
    Caption = 'Import fees from a text file'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = ImportBtnClick
  end
  object BitBtn1: TBitBtn
    Left = 416
    Top = 419
    Width = 89
    Height = 49
    Kind = bkHelp
    NumGlyphs = 2
    TabOrder = 8
    OnClick = BitBtn1Click
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 199
    Top = 74
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 249
    Top = 73
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 't2scr'
    TableName = 't2scr'
    Left = 296
    Top = 72
    object Table1FORMNO: TIntegerField
      FieldName = 'FORMNO'
      Origin = 'FORMNO'
    end
    object Table1FORMNAME: TStringField
      FieldName = 'FORMNAME'
      Origin = 'FORMNAME'
      Size = 10
    end
    object Table1RSINAME: TStringField
      FieldName = 'RSINAME'
      Origin = 'RSINAME'
      Size = 16
    end
    object Table1FEE: TStringField
      FieldName = 'FEE'
      Origin = 'FEE'
      Size = 7
    end
    object Table1FEEADDITEM: TStringField
      FieldName = 'FEEADDITEM'
      Origin = 'FEEADDITEM'
      Size = 7
    end
    object Table1FORMABREV: TStringField
      FieldName = 'FORMABREV'
      Origin = 'FORMABREV'
      Size = 50
    end
  end
end
