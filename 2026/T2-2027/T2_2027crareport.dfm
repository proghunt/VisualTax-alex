object TCRAReport: TTCRAReport
  Left = 366
  Top = 183
  Caption = 'CRA Report'
  ClientHeight = 388
  ClientWidth = 902
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  DesignSize = (
    902
    388)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 77
    Top = 28
    Width = 582
    Height = 14
    Caption = 
      '*** Before you Efile YOUR FIRST install the Microsoft MSXML 6.0 ' +
      'program (unless it was installed before) ***'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 7
    Top = 70
    Width = 729
    Height = 1
    Shape = bsBottomLine
  end
  object Label9: TLabel
    Left = 127
    Top = 49
    Width = 592
    Height = 13
    Caption = 
      'Once connected locate MSXML6.MSI and click Download then RUN. Up' +
      'on comletion it prompts you for MSXML: Click RUN '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
  end
  object SubmitBtn: TBitBtn
    Left = 729
    Top = 112
    Width = 99
    Height = 64
    Anchors = [akTop, akRight]
    Caption = 'Connect/Transmit'
    Default = True
    Glyph.Data = {
      FE080000424DFE08000000000000360400002800000022000000220000000100
      080000000000C804000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A600000000000000000000000000000000000000000000000000000000000000
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
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
      0707070707070707070707070707070707070707070707070707070700000707
      070707070707070707070707FCFCFCFCFCFC0707070707070707070707070707
      00000707070707070707070707FCFCFCFCFCFCFCFCFCFCFCFC07070707070707
      070707070000070707070707070707FCFCFCFCFCFCFCFCFC0707FCFCFCFCFC07
      070707070707070700000707070707070707FCFCFCFCFCFCFCFCFCFC07FAFCFC
      FCFCFCFC07070707070707070000070707070707FCFCFCFCFCFCFCFCFCFCFCFC
      FCFA0707FCFCFCFCFCFC07070707070700000707070707FCFCFCFCFCFCFCFCFC
      FCFCFCFCFCFAFAFA07FCFCFCFCFCFC070707070700000707070707FCFCFCFCFC
      FCFCFCFCFCFCFCFCFCFCFAFAFA07FCFCFCFCFC0707070707000007070707FCFC
      FCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFA07FCFCFCFCFC0707070700000707
      07FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFA07FCFCFCFCFC070707
      0000070707FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC07FAFAFAFAFAFA07FCFC
      FC07070700000707FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC07FAFAFAFAFA
      FA07FCFC07FC070700000707FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFA
      FAFAFAFAFAFAFCFC07FC070700000707FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
      07FAFAFAFAFAFAFAFAFAFCFC07FA0707000007FCFCFCFCFCFCFCFCFCFCFCFCFC
      FCFCFCFAFAFAFAFAFAFAFAFAFAFAFCFC07FAFC07000007FCFCFCFCFCFCFCFCFC
      FCFCFCFCFCFCFCFAFAFAFAFAFAFAFAFAFA07FCFC07FA0707000007FCFCFCFCFC
      FCFCFCFCFCFCFCFCFCFCFC07FAFAFAFAFAFAFA07FCFCFCFC07FAFA07000007FC
      FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFAFAFAFCFCFCFCFCFC07FAFA07
      000007FCFCFCFCFCFCFCFCFCFCFCFCFCFCFC07FA0707FAFAFA07FCFCFCFCFCFC
      07FAFC07000007FCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFCFCFAFA07FCFCFC
      FCFCFCFCFAFAFC0700000707FC0707FCFCFCFCFCFC0707FAFAFAFA07FCFCFCFC
      FCFCFCFCFCFCFCFCFA07070700000707FCFAFAFCFCFCFCFCFCFAFAFAFA07FAFC
      FAFA07FCFCFCFCFCFCFCFCFCFAFC070700000707FCFCFCFCFCFCFCFCFA07FAFA
      07FCFCFC07070707FCFCFCFCFCFCFCFA07FC07070000070707FCFCFCFCFCFC07
      FAFAFAFAFA0707FA07FCFCFCFCFCFCFCFCFC0707FC0707070000070707FCFCFC
      FCFCFCFAFAFAFAFAFAFAFAFA07FCFCFCFCFCFCFCFCFC07FCFC07070700000707
      0707FCFCFCFCFCFAFAFAFAFAFAFAFAFAFAFA07FCFCFCFCFCFCFCFCFC07070707
      00000707070707FCFCFCFCFCFAFAFAFAFAFA07FAFAFAFAFCFCFCFCFCFCFCFC07
      0707070700000707070707FC070707FCFAFAFAFAFAFA07FAFAFAFAFA07FCFCFC
      FCFCFC07070707070000070707070707FC0707FAFAFAFAFAFAFAFAFAFA070707
      07FA07FCFCFC07070707070700000707070707070707FCFC07FAFAFAFAFAFAFA
      07FC07FAFAFAFCFC07070707070707070000070707070707070707FCFCFC0707
      0707070707FA070707FCFC070707070707070707000007070707070707070707
      07FCFCFCFCFCFCFCFCFCFCFCFC07070707070707070707070000070707070707
      0707070707070707FCFCFCFCFCFC070707070707070707070707070700000707
      0707070707070707070707070707070707070707070707070707070707070707
      0000}
    Layout = blGlyphTop
    TabOrder = 0
    OnClick = SubmitBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 834
    Top = 112
    Width = 57
    Height = 64
    Anchors = [akTop, akRight]
    Kind = bkCancel
    Layout = blGlyphTop
    NumGlyphs = 2
    TabOrder = 1
  end
  object ShowBtn: TBitBtn
    Left = 729
    Top = 77
    Width = 162
    Height = 29
    Anchors = [akTop, akRight]
    Caption = 'Show XML data being submitted'
    TabOrder = 2
  end
  object TestOrProductionGroup: TRadioGroup
    Left = 603
    Top = 77
    Width = 120
    Height = 57
    Anchors = [akTop, akRight]
    Caption = 'Test Or Production'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 1
    Items.Strings = (
      'Production (users)'
      'Test (developer).')
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    OnClick = TestOrProductionGroupClick
  end
  object BitBtn4: TBitBtn
    Left = 707
    Top = 35
    Width = 43
    Height = 12
    Caption = '1. Install SOAP'
    TabOrder = 4
    Visible = False
    OnClick = BitBtn4Click
  end
  object BitBtn5: TBitBtn
    Left = 14
    Top = 49
    Width = 106
    Height = 18
    Caption = 'Install MSXML 6.0'
    TabOrder = 5
    OnClick = BitBtn5Click
  end
  object testResponse: TBitBtn
    Left = 729
    Top = 182
    Width = 162
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Test Response'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Layout = blGlyphTop
    ModalResult = 2
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 6
    Visible = False
    OnClick = testResponseClick
  end
  object btnSelectDoc: TButton
    Left = 432
    Top = 240
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 7
    Visible = False
  end
  object dbcgMain: TDBCtrlGrid
    Left = 8
    Top = 80
    Width = 549
    Height = 288
    DataSource = dsMain
    PanelHeight = 144
    PanelWidth = 532
    TabOrder = 8
    RowCount = 2
    object lblFile: TLabel
      Left = 8
      Top = 123
      Width = 25
      Height = 13
      Caption = 'File:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblFileType: TLabel
      Left = 151
      Top = 5
      Width = 49
      Height = 13
      Caption = 'File type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblFileDesc: TLabel
      Left = 340
      Top = 5
      Width = 87
      Height = 13
      Caption = 'File description'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBMemo1: TDBMemo
      Left = 151
      Top = 24
      Width = 185
      Height = 89
      DataField = 'doccomment'
      DataSource = dsMain
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
    end
    object DBMemo2: TDBMemo
      Left = 340
      Top = 24
      Width = 185
      Height = 89
      DataField = 'Desc'
      DataSource = dsMain
      MaxLength = 255
      TabOrder = 1
      WantReturns = False
    end
    object DBEdit1: TDBEdit
      Left = 40
      Top = 119
      Width = 457
      Height = 21
      DataField = 'filepath'
      DataSource = dsMain
      Enabled = False
      TabOrder = 2
    end
    object pnlSelectFile: TPanel
      Left = 500
      Top = 119
      Width = 28
      Height = 21
      Caption = '...'
      TabOrder = 3
      OnClick = pnlSelectFileClick
    end
    object pnlSelectType: TPanel
      Left = 8
      Top = 8
      Width = 137
      Height = 105
      Caption = 'Select document type'
      TabOrder = 4
      OnClick = pnlSelectTypeClick
    end
  end
  object DBNavigator1: TDBNavigator
    Left = 562
    Top = 77
    Width = 25
    Height = 240
    DataSource = dsMain
    Kind = dbnVertical
    TabOrder = 9
  end
  object DataSource1: TDataSource
    Left = 65
    Top = 540
  end
  object OpenDialog1: TOpenDialog
    Left = 476
    Top = 182
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 826
    Top = 21
    object StringField1: TStringField
      FieldKind = fkCalculated
      FieldName = 'PrpStatusDescr'
      Calculated = True
    end
    object StringField2: TStringField
      FieldKind = fkCalculated
      FieldName = 'EfStatusDescr'
      Calculated = True
    end
    object StringField3: TStringField
      FieldName = 'LAST_NAME'
      Size = 30
    end
    object StringField4: TStringField
      FieldName = 'FIRST_NAME'
    end
    object StringField5: TStringField
      FieldName = 'FILE_NAME'
      Size = 12
    end
    object StringField6: TStringField
      FieldName = 'AREA'
      Size = 3
    end
    object StringField7: TStringField
      FieldName = 'PHONE'
      Size = 8
    end
    object StringField8: TStringField
      FieldName = 'FAX'
      Size = 8
    end
    object SmallintField1: TSmallintField
      FieldName = 'MARSTATUS'
    end
    object StringField9: TStringField
      FieldName = 'EF_STATUS'
      Size = 2
    end
    object StringField10: TStringField
      FieldName = 'PRP_STATUS'
      Size = 2
    end
    object StringField11: TStringField
      FieldName = 'CREATED_BY'
      Size = 10
    end
    object StringField12: TStringField
      FieldName = 'CREATED_DT'
      Size = 10
    end
    object StringField13: TStringField
      FieldName = 'CREATED_TM'
      Size = 10
    end
    object StringField14: TStringField
      FieldName = 'UPDATED_BY'
      Size = 10
    end
    object StringField15: TStringField
      FieldName = 'UPDATED_DT'
      Size = 10
    end
    object StringField16: TStringField
      FieldName = 'UPDATED_TM'
      Size = 10
    end
    object StringField17: TStringField
      FieldName = 'RTUSENT_BY'
      Size = 10
    end
    object StringField18: TStringField
      FieldName = 'RTUSENT_DT'
      Size = 10
    end
    object StringField19: TStringField
      FieldName = 'RTUSENT_TM'
      Size = 10
    end
    object StringField20: TStringField
      FieldName = 'ACKRCVD_BY'
      Size = 10
    end
    object StringField21: TStringField
      FieldName = 'ACKRCVD_DT'
      Size = 10
    end
    object StringField22: TStringField
      FieldName = 'ACKRCVD_TM'
      Size = 10
    end
    object StringField23: TStringField
      FieldName = 'PRINTED_BY'
      Size = 10
    end
    object StringField24: TStringField
      FieldName = 'PRINTED_DT'
      Size = 10
    end
    object StringField25: TStringField
      FieldName = 'PRINTED_TM'
      Size = 10
    end
    object StringField26: TStringField
      FieldName = 'DCN_NO'
      Size = 10
    end
    object StringField27: TStringField
      FieldName = 'SIN'
      Size = 9
    end
    object StringField28: TStringField
      FieldName = 'BIRTHDATE'
      Size = 10
    end
    object StringField29: TStringField
      FieldName = 'STREET'
      Size = 30
    end
    object StringField30: TStringField
      FieldName = 'APARTMENT'
      Size = 8
    end
    object StringField31: TStringField
      FieldName = 'CITY'
      Size = 15
    end
    object StringField32: TStringField
      FieldName = 'PROVINCE'
      Size = 2
    end
    object StringField33: TStringField
      FieldName = 'POSTAL'
      Size = 7
    end
    object StringField34: TStringField
      FieldName = 'COUNTRY'
      Size = 10
    end
    object StringField35: TStringField
      FieldName = 'EF_ELGBL'
      Size = 1
    end
    object StringField36: TStringField
      FieldName = 'RTUFILE'
      Size = 12
    end
    object StringField37: TStringField
      FieldName = 'ACKFILE'
      Size = 12
    end
    object StringField38: TStringField
      FieldName = 'COMPL_BY'
      Size = 10
    end
    object StringField39: TStringField
      FieldName = 'COMPL_DT'
      Size = 10
    end
    object StringField40: TStringField
      FieldName = 'COMPL_TM'
      Size = 10
    end
    object StringField41: TStringField
      FieldName = 'DISCOUNTED'
      Size = 1
    end
    object StringField42: TStringField
      FieldName = 'DUE_DT'
      Size = 10
    end
    object StringField43: TStringField
      FieldName = 'NOTES'
      Size = 80
    end
    object FloatField1: TFloatField
      FieldName = 'PAY_AMOUNT'
    end
    object StringField44: TStringField
      FieldName = 'PAY_INVNO'
      Size = 18
    end
    object StringField45: TStringField
      FieldName = 'PAY_TYPE'
      Size = 6
    end
    object FloatField2: TFloatField
      FieldName = 'INV_AMOUNT'
    end
    object StringField46: TStringField
      FieldName = 'PAY_DT'
      Size = 10
    end
    object StringField47: TStringField
      FieldKind = fkCalculated
      FieldName = 'CalcMarStatus'
      Size = 15
      Calculated = True
    end
    object StringField48: TStringField
      FieldKind = fkCalculated
      FieldName = 'ClientName'
      Size = 30
      Calculated = True
    end
    object StringField49: TStringField
      FieldName = 'FAXAREA'
      Size = 3
    end
    object StringField50: TStringField
      FieldName = 'FAMILYHEAD'
      Size = 1
    end
    object StringField51: TStringField
      FieldName = 'CLIENT_ID'
      Size = 15
    end
    object StringField52: TStringField
      FieldName = 'TITLE'
      Size = 6
    end
    object StringField53: TStringField
      FieldName = 'EMAIL'
      Size = 35
    end
    object StringField54: TStringField
      FieldName = 'TAXPROV'
      Size = 2
    end
    object StringField55: TStringField
      FieldName = 'GENDER'
      Size = 1
    end
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 784
    Top = 24
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Method = sslvTLSv1_2
    SSLOptions.SSLVersions = [sslvTLSv1_2]
    SSLOptions.Mode = sslmClient
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 32
    Top = 88
  end
  object IdHTTP1: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    AllowCookies = True
    HandleRedirects = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 88
    Top = 88
  end
  object mtMain: TADMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'Desc'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'filepath'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'docid'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'docname'
        DataType = ftString
        Size = 500
      end
      item
        Name = 'doccomment'
        DataType = ftString
        Size = 500
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 576
    Top = 192
    object mtMainDesc: TStringField
      FieldName = 'Desc'
      Size = 255
    end
    object mtMainfilepath: TStringField
      FieldName = 'filepath'
      Size = 1000
    end
    object mtMaindocid: TStringField
      FieldName = 'docid'
      Size = 100
    end
    object mtMaindocname: TStringField
      FieldName = 'docname'
      Size = 500
    end
    object mtMaindoccomment: TStringField
      FieldName = 'doccomment'
      Size = 500
    end
  end
  object dsMain: TDataSource
    DataSet = mtMain
    Left = 576
    Top = 240
  end
end
