object FeesT1_2026: TFeesT1_2026
  Left = 212
  Top = 163
  BorderIcons = [biSystemMenu]
  Caption = 'Fee Schedule'
  ClientHeight = 716
  ClientWidth = 751
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 751
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
  object TextRelatedPanel: TPanel
    Left = 0
    Top = 606
    Width = 751
    Height = 70
    Align = alBottom
    TabOrder = 1
    object Label2: TLabel
      Left = 33
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
      Left = 329
      Top = 28
      Width = 148
      Height = 23
      Caption = '&Import fees from a text file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = ImportBtnClick
    end
    object ExportBtn: TBitBtn
      Left = 490
      Top = 28
      Width = 120
      Height = 23
      Caption = '&Export fees to text file'
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
      Left = 12
      Top = 28
      Width = 290
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'FlBox'
    end
    object PrintBtn: TBitBtn
      Left = 623
      Top = 28
      Width = 113
      Height = 22
      Caption = '&Print Fee Schedule'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = PrintBtnClick
    end
    object EditBoxBtn: TBitBtn
      Left = 357
      Top = 0
      Width = 106
      Height = 23
      Caption = 'Show Fees Text File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Visible = False
      OnClick = EditBoxBtnClick
    end
  end
  object SavePanel: TPanel
    Left = 0
    Top = 676
    Width = 751
    Height = 40
    Align = alBottom
    TabOrder = 2
    object OKBtn: TBitBtn
      Left = 272
      Top = 9
      Width = 81
      Height = 25
      Caption = '&Save'
      Default = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 398
      Top = 9
      Width = 81
      Height = 25
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object SortPanel: TPanel
    Left = 0
    Top = 25
    Width = 751
    Height = 49
    Align = alTop
    TabOrder = 3
    object SortBy: TRadioGroup
      Left = 42
      Top = 3
      Width = 197
      Height = 38
      Caption = '  Sort &by:  '
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Form Name'
        'Fee')
      ParentFont = False
      TabOrder = 0
      OnClick = SortByClick
    end
    object GetSampleBtn: TBitBtn
      Left = 483
      Top = 7
      Width = 141
      Height = 36
      Caption = 'Start-off with a sample'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = GetSampleBtnClick
    end
    object GetHelpBtn: TBitBtn
      Left = 273
      Top = 9
      Width = 169
      Height = 34
      Caption = '&Help / Recommendations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = GetHelpBtnClick
    end
  end
  object DBNavigator1: TDBNavigator
    Left = 0
    Top = 74
    Width = 751
    Height = 18
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    Align = alTop
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 92
    Width = 751
    Height = 478
    Align = alClient
    Color = clWhite
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
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
        FieldName = 'FORMABREV'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'HOWCHARGED'
        Title.Caption = 'How Charged'
        Width = 110
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'FEE'
        Width = 57
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ADDNLFORM'
        Title.Caption = '+Each addt'#39'l Form'
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'EACH_ITEM'
        Title.Caption = '* Plus each Item ($)'
        Width = 152
        Visible = True
      end>
  end
  object FootNotesPanel: TPanel
    Left = 0
    Top = 570
    Width = 751
    Height = 36
    Align = alBottom
    TabOrder = 6
    object Label1: TLabel
      Left = 7
      Top = 7
      Width = 372
      Height = 12
      Caption = 
        '+ Applies to any of the Multiple forms (Slips, Rentals, Self-emp' +
        'loyment statements, etc)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 7
      Top = 21
      Width = 205
      Height = 12
      Caption = '* Use only for forms that are charged '#39'Per Item'#39'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 472
    Top = 227
  end
  object PrintDialog1: TPrintDialog
    Left = 561
    Top = 233
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=C:\t1\t1fees.db')
    Left = 313
    Top = 233
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 't1fees'
    TableName = 't1fees'
    Left = 384
    Top = 272
    object Table1FORMNAME: TStringField
      FieldName = 'FORMNAME'
      Origin = 'FORMNAME'
      Size = 8
    end
    object Table1FEE: TStringField
      FieldName = 'FEE'
      Origin = 'FEE'
      Size = 7
    end
    object Table1EACH_ITEM: TStringField
      FieldName = 'EACH_ITEM'
      Origin = 'EACH_ITEM'
      Size = 7
    end
    object Table1ADDNLFORM: TStringField
      FieldName = 'ADDNLFORM'
      Origin = 'ADDNLFORM'
      Size = 7
    end
    object Table1FORMABREV: TStringField
      FieldName = 'FORMABREV'
      Origin = 'FORMABREV'
      Size = 22
    end
    object Table1HOWCHARGED: TStringField
      FieldName = 'HOWCHARGED'
      Origin = 'HOWCHARGED'
    end
  end
end
