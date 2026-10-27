object UserSetupT3_2026: TUserSetupT3_2026
  Left = 43
  Top = 60
  Caption = 'Program User Set-Up'
  ClientHeight = 352
  ClientWidth = 544
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 64
    Top = 16
    Width = 177
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Preparer'#39's Name (Tax Consultant)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 218
    Top = 204
    Width = 82
    Height = 13
    Caption = 'Returns Directory'
  end
  object Label10: TLabel
    Left = 232
    Top = 224
    Width = 68
    Height = 13
    Caption = 'EFile Directory'
  end
  object Label13: TLabel
    Left = 210
    Top = 250
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
    Left = 248
    Top = 16
    Width = 137
    Height = 21
    DataField = 'PREP_NAME'
    DataSource = DataSource1
    TabOrder = 0
  end
  object EditTAX_DIR: TDBEdit
    Left = 304
    Top = 200
    Width = 200
    Height = 21
    DataField = 'TAX_DIR'
    DataSource = DataSource1
    Enabled = False
    TabOrder = 1
  end
  object EditEFILE_DIR: TDBEdit
    Left = 304
    Top = 224
    Width = 200
    Height = 21
    DataField = 'EFILE_DIR'
    DataSource = DataSource1
    Enabled = False
    TabOrder = 2
  end
  object DBNavigator: TDBNavigator
    Left = 72
    Top = 273
    Width = 420
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 162
    Top = 304
    Width = 239
    Height = 49
    BorderStyle = bsSingle
    TabOrder = 4
    object OKBtn: TBitBtn
      Left = 16
      Top = 8
      Width = 89
      Height = 33
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 120
      Top = 8
      Width = 89
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 416
    Top = 40
    Width = 121
    Height = 153
    Caption = 'Location'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    object Label1: TLabel
      Left = 8
      Top = 33
      Width = 57
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Main Office'
    end
    object Label2: TLabel
      Left = 10
      Top = 80
      Width = 39
      Height = 13
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
    Left = 222
    Top = 40
    Width = 185
    Height = 153
    Caption = ' Log-in data '
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    object Label4: TLabel
      Left = 40
      Top = 16
      Width = 39
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Login Id'
    end
    object Label5: TLabel
      Left = 32
      Top = 40
      Width = 47
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Password'
    end
    object Label6: TLabel
      Left = 32
      Top = 72
      Width = 73
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Authority Level'
    end
    object Label3: TLabel
      Left = 48
      Top = 104
      Width = 31
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Initials'
    end
    object Label7: TLabel
      Left = 8
      Top = 128
      Width = 97
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Starting Invoice No'
    end
    object Label11: TLabel
      Left = 12
      Top = 84
      Width = 99
      Height = 13
      Caption = 'H0,H1,M0,M1,B0,B1'
    end
    object EditLOGIN_ID: TDBEdit
      Left = 128
      Top = 14
      Width = 49
      Height = 21
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
      Top = 70
      Width = 25
      Height = 21
      CharCase = ecUpperCase
      DataField = 'AUTH_LEVEL'
      DataSource = DataSource1
      TabOrder = 2
    end
    object EditPREP_INTLS: TDBEdit
      Left = 128
      Top = 102
      Width = 25
      Height = 21
      DataField = 'PREP_INTLS'
      DataSource = DataSource1
      TabOrder = 3
    end
    object EditINV_NO: TDBEdit
      Left = 127
      Top = 126
      Width = 50
      Height = 21
      DataField = 'INV_NO'
      DataSource = DataSource1
      TabOrder = 4
    end
  end
  object DBGrid1: TDBGrid
    Left = 28
    Top = 40
    Width = 181
    Height = 209
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object EditDBFData_Dir: TDBEdit
    Left = 304
    Top = 247
    Width = 200
    Height = 21
    DataField = 'DBFData_Dir'
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 512
    Top = 224
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Users'
    TableName = 'Users'
    Left = 504
    Top = 184
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=C:\t1\Users.DB')
    Left = 497
    Top = 145
  end
end
