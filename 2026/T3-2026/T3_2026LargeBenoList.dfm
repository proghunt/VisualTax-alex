object LargeBenoListT3_2026: TLargeBenoListT3_2026
  Left = 137
  Top = 0
  Caption = 'T3 Beno List'
  ClientHeight = 488
  ClientWidth = 940
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  Scaled = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 469
    Width = 940
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 80
      end
      item
        Width = 50
      end>
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 940
    Height = 33
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      940
      33)
    object lblTrustAccountNumber: TLabel
      Left = 10
      Top = 10
      Width = 107
      Height = 13
      Caption = 'Trust Account Number'
    end
    object Label1: TLabel
      Left = 273
      Top = 10
      Width = 55
      Height = 13
      Caption = 'Trust Name'
    end
    object edTrustAccountNumber: TEdit
      Left = 125
      Top = 6
      Width = 132
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object edTrustName: TEdit
      Left = 335
      Top = 6
      Width = 594
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 1
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 66
    Width = 940
    Height = 403
    Align = alClient
    DataSource = dsQ
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid1DrawColumnCell
    OnDblClick = btnEditClick
    Columns = <
      item
        Expanded = False
        FieldName = 'EntityNo'
        Title.Caption = 'Entity No'
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EntityAction'
        Title.Caption = 'Action'
        Width = 65
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EntityType'
        Title.Caption = 'Type'
        Width = 135
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Classification'
        Width = 118
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EntityName'
        Title.Caption = 'Entity Name'
        Width = 125
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TaxIdentificationNumberType'
        Title.Caption = 'Tax Identification Number Type'
        Width = 156
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TaxIdentificationNumber'
        Title.Caption = 'Tax Identification Number'
        Width = 125
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'OtherCountryOfResidence'
        Title.Caption = 'Country Of Residence'
        Width = 110
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AddressLineOne'
        Title.Caption = 'Address'
        Width = 122
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'City'
        Width = 53
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ProvinceTerritoryState'
        Title.Caption = 'Province'
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Country'
        Width = 44
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'GlobalPostalZipCode'
        Title.Caption = 'lPostal'
        Width = 51
        Visible = True
      end>
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 33
    Width = 940
    Height = 33
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    DesignSize = (
      940
      33)
    object btnAdd: TSpeedButton
      Left = 10
      Top = 4
      Width = 63
      Height = 25
      Caption = 'Add'
      OnClick = btnAddClick
    end
    object btnEdit: TSpeedButton
      Left = 79
      Top = 4
      Width = 63
      Height = 25
      Caption = 'Edit'
      OnClick = btnEditClick
    end
    object btnDelete: TSpeedButton
      Left = 148
      Top = 4
      Width = 63
      Height = 25
      Caption = 'Delete'
      OnClick = btnDeleteClick
    end
    object btnImportFromExcel: TSpeedButton
      Left = 401
      Top = 4
      Width = 111
      Height = 25
      Caption = 'Import from Excel'
      OnClick = btnImportFromExcelClick
    end
    object btnCancel: TSpeedButton
      Left = 863
      Top = 4
      Width = 66
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      Visible = False
      OnClick = btnCancelClick
    end
    object btnDeleteAll: TSpeedButton
      Left = 217
      Top = 4
      Width = 63
      Height = 25
      Caption = 'Delete All'
      OnClick = btnDeleteAllClick
    end
    object btnPopulateFromS15: TSpeedButton
      Left = 286
      Top = 4
      Width = 111
      Height = 25
      Caption = 'Populate from S15#'
      OnClick = btnPopulateFromS15Click
    end
    object btnImportHelp: TSpeedButton
      Left = 511
      Top = 4
      Width = 26
      Height = 25
      Caption = '?'
      OnClick = btnImportHelpClick
    end
    object ImportProgressBar: TProgressBar
      Left = 543
      Top = 4
      Width = 314
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      Visible = False
    end
  end
  object Query1: TQuery
    Left = 65193
    Top = 65462
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 77
    Top = 121
  end
  object dsQ: TDataSource
    DataSet = Q
    Left = 80
    Top = 224
  end
  object Q: TADQuery
    AfterScroll = QAfterScroll
    Connection = FDConnection
    FetchOptions.AssignedValues = [evAutoFetchAll]
    FetchOptions.AutoFetchAll = afTruncate
    SQL.Strings = (
      'SELECT'
      '    Id,'
      '    NULL AS EntityNo,'
      '    CASE'
      '        WHEN EntityAction = '#39'A'#39' THEN '#39'ADD'#39
      '        WHEN EntityAction = '#39'M'#39' THEN '#39'MODIFY'#39
      '    END As EntityAction,'
      '    CASE'
      '        WHEN EntityType = '#39'T'#39' THEN '#39'TRUSTEE'#39
      '        WHEN EntityType = '#39'S'#39' THEN '#39'SETTLOR'#39
      '        WHEN EntityType = '#39'B'#39' THEN '#39'BENEFICIARY'#39
      '        WHEN EntityType = '#39'C'#39' THEN '#39'CONTROLLING_PERSON'#39
      '    END As EntityType,'
      '    CASE'
      '        WHEN EntityClassification = '#39'N'#39' THEN '#39'NATURAL_PERSON'#39
      '        WHEN EntityClassification = '#39'C'#39' THEN '#39'CORPORATION'#39
      '        WHEN EntityClassification = '#39'T'#39' THEN '#39'TRUST'#39
      '        WHEN EntityClassification = '#39'O'#39' THEN '#39'OTHER'#39
      '    END As Classification,'
      '    CASE'
      
        '        WHEN EntityClassification = '#39'N'#39' THEN NaturalPersonGivenN' +
        'ame || '#39' '#39' || NaturalPersonFamilyName'
      
        '        WHEN EntityClassification <> '#39'N'#39' THEN NotNaturalPersonEn' +
        'tityName'
      '    END AS EntityName,    '
      '    TaxIdentificationNumberType,'
      '    TaxIdentificationNumber,'
      '    OtherCountryOfResidence,'
      '    AddressLineOne, '
      '    City,'
      '    ProvinceTerritoryState,'
      '    Country,'
      '    GlobalPostalZipCode'
      'FROM BenoTable B '
      'WHERE TrustAccountNumber = :TrustAccountNumber'
      'ORDER BY Id')
    Left = 80
    Top = 176
    ParamData = <
      item
        Name = 'TRUSTACCOUNTNUMBER'
        ParamType = ptInput
      end>
  end
  object ExcelFileOpenDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Excel files (*.xls, *.xlsx)'
        FileMask = '*.xls;*.xlsx'
      end>
    Options = [fdoFileMustExist]
    Left = 160
    Top = 120
  end
  object TimerStart: TTimer
    Interval = 100
    OnTimer = TimerStartTimer
    Left = 160
    Top = 176
  end
end
