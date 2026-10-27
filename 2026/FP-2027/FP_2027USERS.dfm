object UserSetup: TUserSetup
  Left = 122
  Top = 90
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Program User Set-Up'
  ClientHeight = 427
  ClientWidth = 592
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
    Left = 44
    Top = 16
    Width = 181
    Height = 13
    Alignment = taRightJustify
    Caption = 'Preparer'#39's Name (Financial consultant)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label12: TLabel
    Left = 257
    Top = 16
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Agent Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 412
    Top = 72
    Width = 117
    Height = 13
    Alignment = taRightJustify
    Caption = 'Select a name for editing'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label16: TLabel
    Left = 342
    Top = 16
    Width = 59
    Height = 13
    Alignment = taRightJustify
    Caption = 'Dealer Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label17: TLabel
    Left = 174
    Top = 56
    Width = 219
    Height = 13
    Alignment = taRightJustify
    Caption = 'Note: Do not delete the '#39'ADMIN'#39' user'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
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
  object DBNavigator: TDBNavigator
    Left = 352
    Top = 216
    Width = 228
    Height = 18
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 8
  end
  object ButtonsPanel: TPanel
    Left = 352
    Top = 256
    Width = 233
    Height = 161
    BorderStyle = bsSingle
    TabOrder = 6
    object CancelBtn: TBitBtn
      Left = 128
      Top = 48
      Width = 65
      Height = 33
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
      OnClick = CancelBtnClick
    end
    object OKBtn: TBitBtn
      Left = 32
      Top = 48
      Width = 73
      Height = 35
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
      TabOrder = 1
      OnClick = OKBtnClick
    end
  end
  object LocationPanel: TGroupBox
    Left = 216
    Top = 80
    Width = 121
    Height = 153
    Caption = 'LOCATION'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
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
  object IdentPanel: TGroupBox
    Left = 16
    Top = 80
    Width = 185
    Height = 153
    Caption = 'IDENTIFICATION'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    object Label4: TLabel
      Left = 67
      Top = 16
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Login Id'
    end
    object Label5: TLabel
      Left = 56
      Top = 40
      Width = 47
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Password'
    end
    object Label3: TLabel
      Left = 72
      Top = 64
      Width = 31
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Initials'
    end
    object Label7: TLabel
      Left = 8
      Top = 88
      Width = 97
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Starting Invoice No'
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
      Visible = False
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
    Left = 352
    Top = 88
    Width = 233
    Height = 129
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 7
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBlack
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object AgentCode: TDBEdit
    Left = 262
    Top = 31
    Width = 43
    Height = 21
    DataField = 'CODE'
    DataSource = DataSource1
    TabOrder = 1
  end
  object DirPanel: TGroupBox
    Left = 16
    Top = 248
    Width = 321
    Height = 169
    Caption = 'DIRECTORIES'
    TabOrder = 5
    object Label9: TLabel
      Left = 8
      Top = 28
      Width = 87
      Height = 13
      Caption = 'F/P Files Directory'
    end
    object Label10: TLabel
      Left = 8
      Top = 124
      Width = 68
      Height = 13
      Caption = 'EFile Directory'
    end
    object Label14: TLabel
      Left = 8
      Top = 76
      Width = 93
      Height = 13
      Caption = 'Represented Funds'
    end
    object Label15: TLabel
      Left = 8
      Top = 52
      Width = 82
      Height = 13
      Caption = 'Tax files directory'
    end
    object Label18: TLabel
      Left = 8
      Top = 100
      Width = 78
      Height = 13
      Caption = 'All Mutual Funds'
    end
    object Label6: TLabel
      Left = 8
      Top = 144
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
    object EditFilesDIR: TDBEdit
      Left = 104
      Top = 22
      Width = 201
      Height = 21
      DataField = 'FILES_DIR'
      DataSource = DataSource1
      TabOrder = 0
    end
    object EditEFILEDIR: TDBEdit
      Left = 104
      Top = 118
      Width = 201
      Height = 21
      DataField = 'EFILE_DIR'
      DataSource = DataSource1
      TabOrder = 4
    end
    object EditSecDir: TDBEdit
      Left = 104
      Top = 70
      Width = 201
      Height = 21
      DataField = 'SEC_DIR'
      DataSource = DataSource1
      TabOrder = 2
    end
    object EditTaxDir: TDBEdit
      Left = 104
      Top = 46
      Width = 201
      Height = 21
      DataField = 'TAX_DIR'
      DataSource = DataSource1
      TabOrder = 1
    end
    object EditSouthmDir: TDBEdit
      Left = 104
      Top = 94
      Width = 201
      Height = 21
      DataField = 'SOUTHM_DIR'
      DataSource = DataSource1
      TabOrder = 3
    end
    object EditDBFData_Dir: TDBEdit
      Left = 104
      Top = 141
      Width = 203
      Height = 21
      DataField = 'DBFData_Dir'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
  end
  object BrokerCode: TDBEdit
    Left = 350
    Top = 31
    Width = 43
    Height = 21
    DataField = 'BROKER'
    DataSource = DataSource1
    TabOrder = 2
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 544
    Top = 16
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=C:\fp\Users.DB')
    Left = 409
    Top = 41
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Users'
    TableName = 'Users'
    Left = 480
    Top = 80
  end
end
