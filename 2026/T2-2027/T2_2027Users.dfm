object UserSetupT2_2027: TUserSetupT2_2027
  Left = 152
  Top = 92
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Program User Set-Up'
  ClientHeight = 363
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 67
    Top = 16
    Width = 158
    Height = 13
    Margins.Bottom = 2
    Alignment = taRightJustify
    Caption = 'Preparer'#39's Name (Tax Consultant)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 24
    Top = 224
    Width = 82
    Height = 13
    Margins.Bottom = 2
    Caption = 'Returns Directory'
  end
  object Label10: TLabel
    Left = 32
    Top = 240
    Width = 68
    Height = 13
    Margins.Bottom = 2
    Caption = 'EFile Directory'
  end
  object Label12: TLabel
    Left = 256
    Top = 16
    Width = 25
    Height = 13
    Margins.Bottom = 2
    Alignment = taRightJustify
    Caption = 'Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 412
    Top = 48
    Width = 117
    Height = 13
    Margins.Bottom = 2
    Alignment = taRightJustify
    Caption = 'Select a name for editing'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label14: TLabel
    Left = 24
    Top = 267
    Width = 90
    Height = 13
    Caption = 'DBF data Directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object EditPREP_NAME: TDBEdit
    Left = 64
    Top = 32
    Width = 161
    Height = 21
    DataField = 'PREP_NAME'
    DataSource = DataSource1
    TabOrder = 0
  end
  object EditTAX_DIR: TDBEdit
    Left = 120
    Top = 216
    Width = 200
    Height = 21
    DataField = 'TAX_DIR'
    DataSource = DataSource1
    TabOrder = 4
  end
  object EditEFILE_DIR: TDBEdit
    Left = 120
    Top = 240
    Width = 200
    Height = 21
    DataField = 'EFILE_DIR'
    DataSource = DataSource1
    TabOrder = 5
  end
  object DBNavigator: TDBNavigator
    Left = 344
    Top = 208
    Width = 222
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 7
  end
  object Panel1: TPanel
    Left = 168
    Top = 312
    Width = 225
    Height = 49
    BorderStyle = bsSingle
    TabOrder = 1
    object OKBtn: TBitBtn
      Left = 16
      Top = 8
      Width = 89
      Height = 33
      Caption = 'OK'
      Default = True
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A400000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303FF030303030303030303
        03030303030303040403030303030303030303030303030303F8F8FF03030303
        03030303030303030303040202040303030303030303030303030303F80303F8
        FF030303030303030303030303040202020204030303030303030303030303F8
        03030303F8FF0303030303030303030304020202020202040303030303030303
        0303F8030303030303F8FF030303030303030304020202FA0202020204030303
        0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
        040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
        03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
        FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
        0303030303030303030303FA0202020403030303030303030303030303F8FF03
        03F8FF03030303030303030303030303FA020202040303030303030303030303
        0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
        03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
        030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
        0202040303030303030303030303030303F8FF03F8FF03030303030303030303
        03030303FA0202030303030303030303030303030303F8FFF803030303030303
        030303030303030303FA0303030303030303030303030303030303F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 120
      Top = 8
      Width = 89
      Height = 33
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 208
    Top = 56
    Width = 121
    Height = 153
    Caption = 'Location'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 33
      Width = 57
      Height = 13
      Margins.Bottom = 2
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Main Office'
    end
    object Label2: TLabel
      Left = 10
      Top = 80
      Width = 39
      Height = 13
      Margins.Bottom = 2
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Branch'
    end
    object EditM_OFFICE: TDBEdit
      Left = 77
      Top = 30
      Width = 36
      Height = 21
      DataField = 'M_OFFICE'
      DataSource = DataSource1
      TabOrder = 0
    end
    object EditBRANCH: TDBEdit
      Left = 77
      Top = 80
      Width = 28
      Height = 21
      DataField = 'BRANCH'
      DataSource = DataSource1
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 56
    Width = 185
    Height = 153
    Caption = 'Identification'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    object Label4: TLabel
      Left = 67
      Top = 16
      Width = 38
      Height = 13
      Margins.Bottom = 2
      Alignment = taRightJustify
      Caption = 'Login Id'
    end
    object Label5: TLabel
      Left = 56
      Top = 40
      Width = 47
      Height = 13
      Margins.Bottom = 2
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Password'
    end
    object Label6: TLabel
      Left = 32
      Top = 112
      Width = 73
      Height = 13
      Margins.Bottom = 2
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Authority Level'
    end
    object Label3: TLabel
      Left = 72
      Top = 64
      Width = 31
      Height = 13
      Margins.Bottom = 2
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Initials'
    end
    object Label7: TLabel
      Left = 8
      Top = 88
      Width = 97
      Height = 13
      Margins.Bottom = 2
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Starting Invoice No'
    end
    object Label11: TLabel
      Left = 20
      Top = 132
      Width = 99
      Height = 13
      Margins.Bottom = 2
      Caption = 'H0,H1,M0,M1,B0,B1'
    end
    object EditLOGIN_ID: TDBEdit
      Left = 128
      Top = 14
      Width = 49
      Height = 21
      CharCase = ecUpperCase
      DataField = 'LOGIN_ID'
      DataSource = DataSource1
      TabOrder = 0
    end
    object EditPSWD: TDBEdit
      Left = 128
      Top = 38
      Width = 50
      Height = 21
      DataField = 'PSWD'
      DataSource = DataSource1
      TabOrder = 1
    end
    object EditAUTH_LEVEL: TDBEdit
      Left = 128
      Top = 126
      Width = 25
      Height = 21
      CharCase = ecUpperCase
      DataField = 'AUTH_LEVEL'
      DataSource = DataSource1
      TabOrder = 4
    end
    object EditPREP_INTLS: TDBEdit
      Left = 128
      Top = 62
      Width = 25
      Height = 21
      DataField = 'PREP_INTLS'
      DataSource = DataSource1
      TabOrder = 2
    end
    object EditINV_NO: TDBEdit
      Left = 127
      Top = 86
      Width = 50
      Height = 21
      DataField = 'INV_NO'
      DataSource = DataSource1
      TabOrder = 3
    end
  end
  object DBGrid1: TDBGrid
    Left = 344
    Top = 64
    Width = 233
    Height = 145
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 6
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBEdit1: TDBEdit
    Left = 246
    Top = 31
    Width = 43
    Height = 21
    DataField = 'CODE'
    DataSource = DataSource1
    TabOrder = 8
  end
  object EditDBFData_Dir: TDBEdit
    Left = 120
    Top = 264
    Width = 201
    Height = 21
    DataField = 'DBFData_Dir'
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 512
    Top = 264
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=c:\delphi\t1\Users.DB')
    Left = 441
    Top = 233
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Users'
    TableName = 'Users'
    Left = 480
    Top = 240
  end
end
