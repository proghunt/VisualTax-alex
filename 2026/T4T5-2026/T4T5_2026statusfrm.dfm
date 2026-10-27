object StatusFrmT4T5_2026: TStatusFrmT4T5_2026
  Left = 245
  Top = 180
  Caption = 'StatusFrm'
  ClientHeight = 510
  ClientWidth = 676
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 71
    Width = 676
    Height = 376
    Align = alClient
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'CORP_NAME'
        Title.Caption = 'Employer/Payer Name'
        Width = 212
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ACCOUNT'
        Title.Caption = 'Empl. No'
        Width = 52
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'T4CountValue'
        Title.Caption = 'T4 slips'
        Width = 41
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'T4StatusValue'
        Title.Caption = 'T4 Status'
        Width = 71
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'T4ACountValue'
        Title.Caption = 'T4A slips'
        Width = 46
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'T4AStatusValue'
        Title.Caption = 'T4A Status'
        Width = 78
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'T5CountValue'
        Title.Caption = 'T5 slips'
        Width = 38
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'T5StatusValue'
        Title.Caption = 'T5 Status'
        Width = 77
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 447
    Width = 676
    Height = 63
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 9
      Top = 30
      Width = 44
      Height = 13
      Caption = 'Go To: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 9
      Top = 6
      Width = 300
      Height = 13
      Caption = 'Select (click) one of the Employers, then click below'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object OkBtn: TBitBtn
      Left = 589
      Top = 24
      Width = 75
      Height = 25
      Caption = '&Close'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
        F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
        000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
        338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
        45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
        3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
        F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
        000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
        338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
        4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
        8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
        333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
        0000}
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OkBtnClick
    end
    object T4Btn: TBitBtn
      Left = 185
      Top = 23
      Width = 65
      Height = 28
      Hint = 'Edit T4 Slips for selected employer'
      Caption = 'T&4 data...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = T4BtnClick
    end
    object T4ABtn: TBitBtn
      Left = 257
      Top = 23
      Width = 65
      Height = 28
      Hint = 'Edit T4A slips for selected Payer'
      Caption = 'T4&A data...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = T4ABtnClick
    end
    object T5Btn: TBitBtn
      Left = 329
      Top = 23
      Width = 73
      Height = 28
      Hint = 'Edit T5 Slips for selected Payer'
      Caption = 'T&5 data...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = T5BtnClick
    end
    object EmpllBtn: TBitBtn
      Left = 73
      Top = 23
      Width = 97
      Height = 28
      Hint = 'Edit/add employer'
      Caption = '&Employer data...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = EmpllBtnClick
    end
    object printBtn: TBitBtn
      Left = 455
      Top = 24
      Width = 120
      Height = 26
      Hint = 'Edit T5 Slips for selected Payer'
      Caption = 'Print Employer Listing'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = printBtnClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 676
    Height = 71
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    object Label2: TLabel
      Left = 156
      Top = 52
      Width = 363
      Height = 13
      Caption = 'The '#39'Status'#39' of the Slips can be set/changed in the '#39'EMPL'#39' form'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 241
      Top = 6
      Width = 171
      Height = 19
      Caption = 'Employers/Payers List'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 206
      Top = 31
      Width = 249
      Height = 13
      Caption = 'After Saving any currently opened Employer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = Q
    Left = 214
    Top = 140
  end
  object Q: TADQuery
    Connection = Conn
    Left = 115
    Top = 140
  end
  object PrintDialog1: TPrintDialog
    Left = 273
    Top = 140
  end
  object Conn: TADConnection
    Left = 72
    Top = 144
  end
end
