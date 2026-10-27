object LargeBenoEditT3_2026: TLargeBenoEditT3_2026
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Client'
  ClientHeight = 573
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelBottom: TPanel
    Left = 0
    Top = 540
    Width = 443
    Height = 33
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 530
    DesignSize = (
      443
      33)
    object OKBtn: TButton
      Left = 277
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 358
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 540
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    ExplicitHeight = 530
    object rgEntityAction: TDBRadioGroup
      Left = 8
      Top = 8
      Width = 425
      Height = 41
      Caption = 'Entity Action'
      Columns = 3
      DataField = 'EntityAction'
      DataSource = dsQ
      Items.Strings = (
        'Add reportable entity'
        'Modify reportable entity')
      TabOrder = 0
      Values.Strings = (
        'A'
        'M')
    end
    object rgEntityType: TDBRadioGroup
      Left = 8
      Top = 55
      Width = 425
      Height = 41
      Caption = 'Entity Type'
      Columns = 4
      DataField = 'EntityType'
      DataSource = dsQ
      Items.Strings = (
        'Trustee'
        'Settlor'
        'Beneficiary'
        'Controlling person')
      TabOrder = 1
      Values.Strings = (
        'T'
        'S'
        'B'
        'C')
    end
    object rgEntityClassification: TDBRadioGroup
      Left = 8
      Top = 102
      Width = 425
      Height = 41
      Caption = 'Entity Classification'
      Columns = 4
      DataField = 'EntityClassification'
      DataSource = dsQ
      Items.Strings = (
        'Natural person'
        'Corporation'
        'Trust'
        'Other')
      TabOrder = 2
      Values.Strings = (
        'N'
        'C'
        'T'
        'O')
    end
    object gbEntityName: TGroupBox
      Left = 8
      Top = 149
      Width = 425
      Height = 52
      Caption = 'Entity Name'
      TabOrder = 3
      object edName: TDBEdit
        Left = 8
        Top = 18
        Width = 409
        Height = 21
        DataField = 'NotNaturalPersonEntityName'
        DataSource = dsQ
        TabOrder = 0
      end
    end
    object gbFirstName: TGroupBox
      Left = 8
      Top = 207
      Width = 209
      Height = 52
      Caption = 'First Name'
      TabOrder = 4
      object edFirstName: TDBEdit
        Left = 8
        Top = 18
        Width = 192
        Height = 21
        DataField = 'NaturalPersonGivenName'
        DataSource = dsQ
        TabOrder = 0
      end
    end
    object gbLastName: TGroupBox
      Left = 224
      Top = 207
      Width = 209
      Height = 52
      Caption = 'Last Name'
      TabOrder = 5
      object edLastName: TDBEdit
        Left = 8
        Top = 18
        Width = 193
        Height = 21
        DataField = 'NaturalPersonFamilyName'
        DataSource = dsQ
        TabOrder = 0
      end
    end
    object gbDateOfBirth: TGroupBox
      Left = 8
      Top = 265
      Width = 209
      Height = 52
      Caption = 'Date of birth (if natural person)'
      TabOrder = 6
      object edDateOfBirth: TDBEdit
        Left = 8
        Top = 18
        Width = 192
        Height = 21
        DataField = 'NaturalPersonBirthDate'
        DataSource = dsQ
        TabOrder = 0
      end
    end
    object gbTaxIdentificationNumber: TGroupBox
      Left = 8
      Top = 323
      Width = 209
      Height = 90
      Caption = 'Tax identification number'
      TabOrder = 7
      object rbSIN: TRadioButton
        Left = 8
        Top = 16
        Width = 41
        Height = 17
        Caption = 'SIN'
        TabOrder = 0
        OnClick = rbSINClick
      end
      object rbTTN: TRadioButton
        Left = 55
        Top = 16
        Width = 41
        Height = 17
        Caption = 'TTN'
        TabOrder = 1
        OnClick = rbSINClick
      end
      object rbITN: TRadioButton
        Left = 102
        Top = 16
        Width = 41
        Height = 17
        Caption = 'ITN'
        TabOrder = 2
        OnClick = rbSINClick
      end
      object rbBN: TRadioButton
        Left = 8
        Top = 39
        Width = 41
        Height = 17
        Caption = 'BN'
        TabOrder = 3
        OnClick = rbSINClick
      end
      object rbTN: TRadioButton
        Left = 55
        Top = 39
        Width = 41
        Height = 17
        Caption = 'TN'
        TabOrder = 4
        OnClick = rbSINClick
      end
      object rbInternational: TRadioButton
        Left = 102
        Top = 39
        Width = 83
        Height = 17
        Caption = 'International'
        TabOrder = 5
        OnClick = rbSINClick
      end
      object edTaxIdentificationNumber: TDBEdit
        Left = 8
        Top = 62
        Width = 192
        Height = 21
        DataField = 'TaxIdentificationNumber'
        DataSource = dsQ
        TabOrder = 6
      end
    end
    object gbCountryOfResidence: TGroupBox
      Left = 223
      Top = 323
      Width = 210
      Height = 51
      Caption = 'Country of residence'
      TabOrder = 8
      object lcbCountryOfResidence: TDBLookupComboBox
        Left = 9
        Top = 20
        Width = 193
        Height = 21
        DataField = 'OtherCountryOfResidence'
        DataSource = dsQ
        KeyField = 'Code'
        ListField = 'Name'
        ListSource = dsCountry
        TabOrder = 0
      end
    end
    object GroupBox7: TGroupBox
      Left = 8
      Top = 419
      Width = 425
      Height = 94
      TabOrder = 9
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 41
        Height = 13
        Caption = 'Address '
      end
      object Label2: TLabel
        Left = 310
        Top = 10
        Width = 36
        Height = 13
        Caption = 'Country'
      end
      object Label3: TLabel
        Left = 8
        Top = 48
        Width = 17
        Height = 13
        Caption = 'City'
      end
      object Label4: TLabel
        Left = 206
        Top = 50
        Width = 42
        Height = 13
        Caption = 'Province'
      end
      object Label5: TLabel
        Left = 310
        Top = 48
        Width = 105
        Height = 13
        Caption = 'Postal code/ZIP code'
      end
      object edAddress: TDBEdit
        Left = 8
        Top = 25
        Width = 298
        Height = 21
        DataField = 'AddressLineOne'
        DataSource = dsQ
        TabOrder = 0
      end
      object lcbCountry: TDBLookupComboBox
        Left = 310
        Top = 25
        Width = 107
        Height = 21
        DataField = 'Country'
        DataSource = dsQ
        KeyField = 'Code'
        ListField = 'Name'
        ListSource = dsCountry
        TabOrder = 1
      end
      object edCity: TDBEdit
        Left = 8
        Top = 65
        Width = 192
        Height = 21
        DataField = 'City'
        DataSource = dsQ
        TabOrder = 2
      end
      object lcbProvince: TDBLookupComboBox
        Left = 206
        Top = 65
        Width = 100
        Height = 21
        DataField = 'ProvinceTerritoryState'
        DataSource = dsQ
        KeyField = 'Code'
        ListField = 'Name'
        ListSource = dsProvince
        TabOrder = 3
      end
      object edGlobalPostalZipCode: TDBEdit
        Left = 310
        Top = 65
        Width = 107
        Height = 21
        DataField = 'GlobalPostalZipCode'
        DataSource = dsQ
        TabOrder = 4
      end
    end
    object cbEntityAssociationEndAction: TDBCheckBox
      Left = 16
      Top = 517
      Width = 353
      Height = 17
      Caption = 
        'Did the entity cease to be a reportable entity in the current ta' +
        'x year?'
      DataField = 'EntityAssociationEndAction'
      DataSource = dsQ
      TabOrder = 10
    end
  end
  object dsQ: TDataSource
    DataSet = Q
    Left = 352
  end
  object Q: TADQuery
    SQL.Strings = (
      'SELECT * FROM BenoTable'
      'WHERE ID = :ID')
    Left = 312
    ParamData = <
      item
        Name = 'ID'
        ParamType = ptInput
      end>
  end
  object qProvince: TADMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 328
    Top = 144
    object qProvinceCode: TStringField
      FieldName = 'Code'
      Size = 5
    end
    object qProvinceName: TStringField
      FieldName = 'Name'
      Size = 255
    end
  end
  object qCountry: TADMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 384
    Top = 144
    object qCountryCode: TStringField
      FieldName = 'Code'
      Size = 3
    end
    object qCountryName: TStringField
      FieldName = 'Name'
      Size = 255
    end
  end
  object dsProvince: TDataSource
    DataSet = qProvince
    Left = 328
    Top = 197
  end
  object dsCountry: TDataSource
    DataSet = qCountry
    Left = 384
    Top = 197
  end
end
