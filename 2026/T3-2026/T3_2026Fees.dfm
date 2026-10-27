object FeesT3_2026: TFeesT3_2026
  Left = 133
  Top = 97
  BorderIcons = [biSystemMenu]
  Caption = 'Fee Schedule'
  ClientHeight = 501
  ClientWidth = 602
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
    Left = 112
    Top = 374
    Width = 490
    Height = 13
    Caption = 
      '* Applies to any of the Multiple forms (Slips, Rentals, Self-emp' +
      'loyment statements, etc)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 602
    Height = 25
    Align = alTop
    Caption = 'Fee Schedule'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 396
    Width = 602
    Height = 65
    Align = alBottom
    TabOrder = 1
    object Label2: TLabel
      Left = 194
      Top = 15
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
    object ImportBtn: TBitBtn
      Left = 7
      Top = 36
      Width = 141
      Height = 23
      Caption = 'Import fees from a text file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ImportBtnClick
    end
    object ExportBtn: TBitBtn
      Left = 7
      Top = 7
      Width = 141
      Height = 23
      Caption = 'Export fees to text file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ExportBtnClick
    end
    object FlBox: TEdit
      Left = 173
      Top = 28
      Width = 185
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'FlBox'
    end
    object PrintBtn: TBitBtn
      Left = 378
      Top = 28
      Width = 134
      Height = 22
      Caption = 'Print Fee Schedule'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = PrintBtnClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 461
    Width = 602
    Height = 40
    Align = alBottom
    TabOrder = 2
    object OKBtn: TBitBtn
      Left = 181
      Top = 9
      Width = 81
      Height = 25
      Caption = '&Save'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 349
      Top = 9
      Width = 81
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object BitBtn1: TBitBtn
      Left = 266
      Top = 9
      Width = 78
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = BitBtn1Click
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 25
    Width = 602
    Height = 371
    Align = alClient
    TabOrder = 3
    object DBGrid1: TDBGrid
      Left = 1
      Top = 57
      Width = 600
      Height = 313
      Align = alClient
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
      Columns = <
        item
          Expanded = False
          FieldName = 'FORMNAME'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FEE'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FEEADDITEM'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FORMABREV'
          Width = 249
          Visible = True
        end>
    end
    object DBNavigator1: TDBNavigator
      Left = 1
      Top = 1
      Width = 600
      Height = 18
      DataSource = DataSource1
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Align = alTop
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object Panel5: TPanel
      Left = 1
      Top = 19
      Width = 600
      Height = 38
      Align = alTop
      TabOrder = 2
      object SortBy: TRadioGroup
        Left = 198
        Top = 3
        Width = 181
        Height = 38
        Caption = '  Sort &by:  '
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Items.Strings = (
          'Form Name'
          'Fee')
        ParentFont = False
        TabOrder = 0
        OnClick = SortByClick
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 521
    Top = 416
  end
  object PrintDialog1: TPrintDialog
    Left = 561
    Top = 422
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=C:\T3-2017\Data\tfscr.db')
    Left = 509
    Top = 289
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'tfscr'
    TableName = 'tfscr'
    Left = 548
    Top = 288
  end
end
