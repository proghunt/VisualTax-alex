object frmvtUsers: TfrmvtUsers
  Left = 125
  Top = 93
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'User Set-Up'
  ClientHeight = 551
  ClientWidth = 920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 184
    Width = 920
    Height = 8
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 217
    ExplicitWidth = 921
  end
  object gbUserList: TGroupBox
    Left = 0
    Top = 0
    Width = 920
    Height = 184
    Align = alTop
    Caption = 'User List'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object pnlTools: TPanel
      Left = 2
      Top = 15
      Width = 916
      Height = 33
      Align = alTop
      TabOrder = 0
      object AddBtn: TBitBtn
        Left = 6
        Top = 4
        Width = 99
        Height = 25
        Caption = 'New user'
        TabOrder = 0
        OnClick = AddBtnClick
      end
      object DeleteBtn: TBitBtn
        Left = 215
        Top = 4
        Width = 99
        Height = 25
        Caption = 'Delete user'
        TabOrder = 2
        OnClick = DeleteBtnClick
      end
      object btnCopyUser: TBitBtn
        Left = 110
        Top = 4
        Width = 99
        Height = 25
        Caption = 'Copy user'
        TabOrder = 1
        OnClick = AddBtnClick
      end
    end
    object grUsers: TDBGrid
      Left = 2
      Top = 48
      Width = 916
      Height = 134
      Align = alClient
      DataSource = dsUsers
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = [fsBold]
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 500
    Width = 920
    Height = 51
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 2
    DesignSize = (
      916
      47)
    object OKBtn: TBitBtn
      Left = 697
      Top = 8
      Width = 98
      Height = 33
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 701
    end
    object CancelBtn: TBitBtn
      Left = 801
      Top = 8
      Width = 97
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      ExplicitLeft = 805
    end
  end
  object pnlUserSettings: TPanel
    Left = 0
    Top = 192
    Width = 920
    Height = 308
    Align = alClient
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 289
      Top = 1
      Height = 306
      ExplicitLeft = 448
      ExplicitTop = 128
      ExplicitHeight = 100
    end
    object gbCommonSettings: TGroupBox
      Left = 1
      Top = 1
      Width = 288
      Height = 306
      Align = alLeft
      Caption = 'Identification'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      object Label4: TLabel
        Left = 54
        Top = 18
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = 'Login Id'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 173
        Top = 18
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Caption = 'Password'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 17
        Top = 153
        Width = 73
        Height = 13
        AutoSize = False
        Caption = 'Authority Level'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label3: TLabel
        Left = 63
        Top = 72
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'Initials'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 17
        Top = 126
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = 'Last Invoice No'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 3
        Top = 39
        Width = 89
        Height = 30
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Preparer'#39's Name (Tax Consultant)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label12: TLabel
        Left = 25
        Top = 99
        Width = 67
        Height = 13
        Alignment = taRightJustify
        Caption = 'Code (4 digits)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object edtLOGIN_ID: TDBEdit
        Left = 98
        Top = 15
        Width = 68
        Height = 21
        CharCase = ecUpperCase
        Color = clSilver
        DataField = 'LOGIN_ID'
        DataSource = dsUsers
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object edtPSWD: TDBEdit
        Left = 225
        Top = 15
        Width = 56
        Height = 21
        DataField = 'PSWD'
        DataSource = dsUsers
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object edtAUTH_LEVEL: TDBEdit
        Left = 98
        Top = 150
        Width = 43
        Height = 21
        CharCase = ecUpperCase
        DataField = 'AUTH_LEVEL'
        DataSource = dsUsers
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        Visible = False
      end
      object edtPREP_INTLS: TDBEdit
        Left = 98
        Top = 69
        Width = 43
        Height = 21
        DataField = 'PREP_INTLS'
        DataSource = dsUsers
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object edtINV_NO: TDBEdit
        Left = 98
        Top = 123
        Width = 43
        Height = 21
        DataField = 'INV_NO'
        DataSource = dsUsers
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object gbLocations: TGroupBox
        Left = 17
        Top = 177
        Width = 184
        Height = 72
        Caption = 'Location'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 7
        object Label1: TLabel
          Left = 9
          Top = 17
          Width = 100
          Height = 13
          Alignment = taRightJustify
          Caption = 'Office Code (4 chars)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 31
          Top = 44
          Width = 78
          Height = 13
          Alignment = taRightJustify
          Caption = 'Branch (2 chars)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edtM_OFFICE: TDBEdit
          Left = 120
          Top = 14
          Width = 49
          Height = 21
          DataField = 'M_OFFICE'
          DataSource = dsUsers
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object edtBRANCH: TDBEdit
          Left = 120
          Top = 41
          Width = 25
          Height = 21
          DataField = 'BRANCH'
          DataSource = dsUsers
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
      object edtPREP_NAME: TDBEdit
        Left = 98
        Top = 42
        Width = 183
        Height = 21
        DataField = 'PREP_NAME'
        DataSource = dsUsers
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object edtCODE: TDBEdit
        Left = 98
        Top = 96
        Width = 43
        Height = 21
        DataField = 'CODE'
        DataSource = dsUsers
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
    object gbMultiSettings: TGroupBox
      Left = 292
      Top = 1
      Width = 627
      Height = 306
      Align = alClient
      Caption = 'Settings for multi-office licensed modules'
      TabOrder = 1
      object pgcMulti: TPageControl
        Left = 2
        Top = 15
        Width = 623
        Height = 289
        Align = alClient
        TabOrder = 0
      end
    end
  end
  object dsUsers: TDataSource
    DataSet = tblUsers
    Left = 176
    Top = 112
  end
  object conUsers: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=C:\t1\Users.DB')
    Left = 113
    Top = 113
  end
  object tblUsers: TADTable
    BeforeInsert = tblUsersBeforeInsert
    AfterInsert = tblUsersAfterInsert
    BeforeDelete = tblUsersBeforeDelete
    BeforeScroll = tblUsersBeforeScroll
    AfterScroll = tblUsersAfterScroll
    Connection = conUsers
    UpdateOptions.UpdateTableName = 'Users'
    UpdateOptions.KeyFields = 'login_id'
    TableName = 'Users'
    Left = 144
    Top = 112
  end
end
