object T1135Efile: TT1135Efile
  Left = 397
  Top = 178
  Hint = 'Double click to select'
  Caption = 'T1135 Efile'
  ClientHeight = 254
  ClientWidth = 849
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
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 7
    Top = 77
    Width = 94
    Height = 13
    Caption = 'URL for T1135 Efile'
  end
  object Label2: TLabel
    Left = 77
    Top = 28
    Width = 618
    Height = 14
    Caption = 
      '*** Before you Efile YOUR FIRST T1135  install the Microsoft MSX' +
      'ML 6.0 program (unless it was installed before) ***'
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
  object EfileType: TPanel
    Left = 0
    Top = 0
    Width = 849
    Height = 29
    Hint = 'Click to change tax year and rates'
    Align = alTop
    BevelOuter = bvNone
    Caption = 'T1135 Efile - Foreign Income Verification'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ExplicitWidth = 841
  end
  object SubmitBtn: TBitBtn
    Left = 574
    Top = 112
    Width = 99
    Height = 64
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
    TabOrder = 1
    OnClick = SubmitBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 679
    Top = 112
    Width = 57
    Height = 64
    Kind = bkCancel
    Layout = blGlyphTop
    NumGlyphs = 2
    TabOrder = 2
  end
  object ShowBtn: TBitBtn
    Left = 574
    Top = 77
    Width = 162
    Height = 29
    Caption = 'Show XML data being submitted'
    TabOrder = 3
    OnClick = ShowBtnClick
  end
  object EfileOptionGroup: TRadioGroup
    Left = 224
    Top = 119
    Width = 218
    Height = 57
    Caption = 'Efile Option'
    ItemIndex = 0
    Items.Strings = (
      '1. T1135 of current return only')
    TabOrder = 4
    OnClick = EfileOptionGroupClick
  end
  object BatchPanel: TPanel
    Left = 7
    Top = 399
    Width = 729
    Height = 134
    TabOrder = 5
    Visible = False
    object Label1: TLabel
      Left = 155
      Top = 28
      Width = 96
      Height = 13
      Caption = 'T1 returns Directory:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 15
      Top = 7
      Width = 101
      Height = 13
      Caption = 'Batch Submission'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 127
      Top = 56
      Width = 102
      Height = 13
      Caption = 'Double click to select'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label6: TLabel
      Left = 449
      Top = 63
      Width = 42
      Height = 13
      Caption = 'Selected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Label17: TLabel
      Left = 15
      Top = 24
      Width = 77
      Height = 13
      Caption = 'Search Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object ListBox1: TListBox
      Left = 406
      Top = 77
      Width = 134
      Height = 372
      Hint = 'Double click on a line to remove from list'
      Color = 15393742
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Sorted = True
      TabOrder = 0
      OnDblClick = ListBox1DblClick
    end
    object OtherBatchButtonsPanel: TPanel
      Left = 555
      Top = 77
      Width = 167
      Height = 372
      TabOrder = 1
      object BuildBatchBtn: TBitBtn
        Left = 21
        Top = 100
        Width = 134
        Height = 57
        Hint = 'Create batch file for transmission'
        Caption = 'Build batch T1013 File'
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
    end
    object BatchButtonsPanel: TPanel
      Left = 343
      Top = 77
      Width = 57
      Height = 288
      TabOrder = 2
      object RemoveBtn: TBitBtn
        Left = 7
        Top = 113
        Width = 43
        Height = 33
        Hint = 'Remove Selected file'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Glyph.Data = {
          7E010000424D7E01000000000000760000002800000014000000160000000100
          0400000000000801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777700007777777777777777777700007777777777077777777700007777
          77777007777777770000777777770C0777777777000077777770CC0777777777
          00007777770CCC07777777770000777770CCCC0000000777000077770CCCCCCC
          CCCC077700007770CCCCCCCCCCCC07770000770CCCCCCCCCCCCC077700007770
          CCCCCCCCCCCC0777000077770CCCCCCCCCCC07770000777770CCCC0000000777
          00007777770CCC0777777777000077777770CC07777777770000777777770C07
          7777777700007777777770077777777700007777777777077777777700007777
          7777777777777777000077777777777777777777000077777777777777777777
          0000}
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = RemoveBtnClick
      end
      object BitBtn1: TBitBtn
        Left = 7
        Top = 69
        Width = 43
        Height = 33
        Hint = 'Select File'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Glyph.Data = {
          7E010000424D7E01000000000000760000002800000014000000160000000100
          0400000000000801000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888800008888888888888888888800008888888888088888888800008888
          8888880088888888000088888888880C08888888000088888888880CC0888888
          000088888888880CCC088888000088880000000CCCC08888000088880CCCCCCC
          CCCC0888000088880CCCCCCCCCCCC088000088880CCCCCCCCCCCCC0800008888
          0CCCCCCCCCCCC088000088880CCCCCCCCCCC0888000088880000000CCCC08888
          000088888888880CCC088888000088888888880CC0888888000088888888880C
          0888888800008888888888008888888800008888888888088888888800008888
          8888888888888888000088888888888888888888000088888888888888888888
          0000}
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = BitBtn1Click
      end
      object BitBtn2: TBitBtn
        Left = 7
        Top = 202
        Width = 43
        Height = 42
        Caption = 'All'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Glyph.Data = {
          7E010000424D7E01000000000000760000002800000014000000160000000100
          0400000000000801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777700007777777777777777777700007777777777077777777700007777
          77777007777777770000777777770C0777777777000077777770CC0777777777
          00007777770CCC07777777770000777770CCCC0000000777000077770CCCCCCC
          CCCC077700007770CCCCCCCCCCCC07770000770CCCCCCCCCCCCC077700007770
          CCCCCCCCCCCC0777000077770CCCCCCCCCCC07770000777770CCCC0000000777
          00007777770CCC0777777777000077777770CC07777777770000777777770C07
          7777777700007777777770077777777700007777777777077777777700007777
          7777777777777777000077777777777777777777000077777777777777777777
          0000}
        Layout = blGlyphBottom
        ParentFont = False
        Spacing = 1
        TabOrder = 2
        OnClick = BitBtn2Click
      end
    end
    object DataDirBox: TEdit
      Left = 260
      Top = 27
      Width = 305
      Height = 21
      Hint = 'Press Tab after changing directory'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = 'DataDirBox'
    end
    object DBGrid1: TDBGrid
      Left = 15
      Top = 71
      Width = 315
      Height = 392
      Hint = 'Double click to select'
      Color = clWhite
      DataSource = DataSource1
      FixedColor = 12971774
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'Arial'
      TitleFont.Style = [fsBold]
      OnDblClick = DBGrid1DblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'LAST_NAME'
          Title.Caption = 'Last Name'
          Width = 105
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FIRST_NAME'
          Title.Caption = 'First'
          Width = 71
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EfStatusDescr'
          Title.Caption = 'EF-Status'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PrpStatusDescr'
          Title.Caption = 'Prep-Status'
          Visible = True
        end>
    end
    object SearchBox: TEdit
      Left = 16
      Top = 41
      Width = 76
      Height = 24
      Hint = 'Enter one or more leers from last name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnChange = SearchBoxChange
    end
  end
  object TestOrProductionGroup: TRadioGroup
    Left = 448
    Top = 126
    Width = 120
    Height = 50
    Caption = 'Test Or Production'
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Production (users)'
      'Test (developer).')
    ParentColor = False
    ParentFont = False
    TabOrder = 6
    Visible = False
    OnClick = TestOrProductionGroupClick
  end
  object UrlBox: TEdit
    Left = 7
    Top = 91
    Width = 561
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object BitBtn3: TBitBtn
    Left = 7
    Top = 147
    Width = 211
    Height = 29
    Caption = 'View Error Clues...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = BitBtn3Click
  end
  object BitBtn4: TBitBtn
    Left = 707
    Top = 35
    Width = 43
    Height = 12
    Caption = '1. Install SOAP'
    TabOrder = 9
    Visible = False
    OnClick = BitBtn4Click
  end
  object BitBtn5: TBitBtn
    Left = 14
    Top = 49
    Width = 106
    Height = 18
    Caption = 'Install MSXML 6.0'
    TabOrder = 10
    OnClick = BitBtn5Click
  end
  object Memo1: TMemo
    Left = 7
    Top = 280
    Width = 729
    Height = 106
    Lines.Strings = (
      'Memo1')
    TabOrder = 11
    Visible = False
  end
  object testResponse: TBitBtn
    Left = 574
    Top = 182
    Width = 162
    Height = 25
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
    TabOrder = 12
    Visible = False
    OnClick = testResponseClick
  end
  object Table1: TTable
    DatabaseName = 'C:\delphi\t1'
    TableName = 'Clients.DBF'
    TableType = ttDBase
    Left = 10
    Top = 539
    object Table1PrpStatusDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'PrpStatusDescr'
      Calculated = True
    end
    object Table1EfStatusDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'EfStatusDescr'
      Calculated = True
    end
    object Table1LAST_NAME: TStringField
      FieldName = 'LAST_NAME'
      Size = 30
    end
    object Table1FIRST_NAME: TStringField
      FieldName = 'FIRST_NAME'
    end
    object Table1FILE_NAME: TStringField
      FieldName = 'FILE_NAME'
      Size = 12
    end
    object Table1AREA: TStringField
      FieldName = 'AREA'
      Size = 3
    end
    object Table1PHONE: TStringField
      FieldName = 'PHONE'
      Size = 8
    end
    object Table1FAX: TStringField
      FieldName = 'FAX'
      Size = 8
    end
    object Table1MARSTATUS: TSmallintField
      FieldName = 'MARSTATUS'
    end
    object Table1EF_STATUS: TStringField
      FieldName = 'EF_STATUS'
      Size = 2
    end
    object Table1PRP_STATUS: TStringField
      FieldName = 'PRP_STATUS'
      Size = 2
    end
    object Table1CREATED_BY: TStringField
      FieldName = 'CREATED_BY'
      Size = 10
    end
    object Table1CREATED_DT: TStringField
      FieldName = 'CREATED_DT'
      Size = 10
    end
    object Table1CREATED_TM: TStringField
      FieldName = 'CREATED_TM'
      Size = 10
    end
    object Table1UPDATED_BY: TStringField
      FieldName = 'UPDATED_BY'
      Size = 10
    end
    object Table1UPDATED_DT: TStringField
      FieldName = 'UPDATED_DT'
      Size = 10
    end
    object Table1UPDATED_TM: TStringField
      FieldName = 'UPDATED_TM'
      Size = 10
    end
    object Table1RTUSENT_BY: TStringField
      FieldName = 'RTUSENT_BY'
      Size = 10
    end
    object Table1RTUSENT_DT: TStringField
      FieldName = 'RTUSENT_DT'
      Size = 10
    end
    object Table1RTUSENT_TM: TStringField
      FieldName = 'RTUSENT_TM'
      Size = 10
    end
    object Table1ACKRCVD_BY: TStringField
      FieldName = 'ACKRCVD_BY'
      Size = 10
    end
    object Table1ACKRCVD_DT: TStringField
      FieldName = 'ACKRCVD_DT'
      Size = 10
    end
    object Table1ACKRCVD_TM: TStringField
      FieldName = 'ACKRCVD_TM'
      Size = 10
    end
    object Table1PRINTED_BY: TStringField
      FieldName = 'PRINTED_BY'
      Size = 10
    end
    object Table1PRINTED_DT: TStringField
      FieldName = 'PRINTED_DT'
      Size = 10
    end
    object Table1PRINTED_TM: TStringField
      FieldName = 'PRINTED_TM'
      Size = 10
    end
    object Table1DCN_NO: TStringField
      FieldName = 'DCN_NO'
      Size = 10
    end
    object Table1SIN: TStringField
      FieldName = 'SIN'
      Size = 9
    end
    object Table1BIRTHDATE: TStringField
      FieldName = 'BIRTHDATE'
      Size = 10
    end
    object Table1STREET: TStringField
      FieldName = 'STREET'
      Size = 30
    end
    object Table1APARTMENT: TStringField
      FieldName = 'APARTMENT'
      Size = 8
    end
    object Table1CITY: TStringField
      FieldName = 'CITY'
      Size = 15
    end
    object Table1PROVINCE: TStringField
      FieldName = 'PROVINCE'
      Size = 2
    end
    object Table1POSTAL: TStringField
      FieldName = 'POSTAL'
      Size = 7
    end
    object Table1COUNTRY: TStringField
      FieldName = 'COUNTRY'
      Size = 10
    end
    object Table1EF_ELGBL: TStringField
      FieldName = 'EF_ELGBL'
      Size = 1
    end
    object Table1RTUFILE: TStringField
      FieldName = 'RTUFILE'
      Size = 12
    end
    object Table1ACKFILE: TStringField
      FieldName = 'ACKFILE'
      Size = 12
    end
    object Table1COMPL_BY: TStringField
      FieldName = 'COMPL_BY'
      Size = 10
    end
    object Table1COMPL_DT: TStringField
      FieldName = 'COMPL_DT'
      Size = 10
    end
    object Table1COMPL_TM: TStringField
      FieldName = 'COMPL_TM'
      Size = 10
    end
    object Table1DISCOUNTED: TStringField
      FieldName = 'DISCOUNTED'
      Size = 1
    end
    object Table1DUE_DT: TStringField
      FieldName = 'DUE_DT'
      Size = 10
    end
    object Table1NOTES: TStringField
      FieldName = 'NOTES'
      Size = 80
    end
    object Table1PAY_AMOUNT: TFloatField
      FieldName = 'PAY_AMOUNT'
    end
    object Table1PAY_INVNO: TStringField
      FieldName = 'PAY_INVNO'
      Size = 18
    end
    object Table1PAY_TYPE: TStringField
      FieldName = 'PAY_TYPE'
      Size = 6
    end
    object Table1INV_AMOUNT: TFloatField
      FieldName = 'INV_AMOUNT'
    end
    object Table1PAY_DT: TStringField
      FieldName = 'PAY_DT'
      Size = 10
    end
    object Table1CalcMarStatus: TStringField
      FieldKind = fkCalculated
      FieldName = 'CalcMarStatus'
      Size = 15
      Calculated = True
    end
    object Table1ClientName: TStringField
      FieldKind = fkCalculated
      FieldName = 'ClientName'
      Size = 30
      Calculated = True
    end
    object Table1FAXAREA: TStringField
      FieldName = 'FAXAREA'
      Size = 3
    end
    object Table1FAMILYHEAD: TStringField
      FieldName = 'FAMILYHEAD'
      Size = 1
    end
    object Table1CLIENT_ID: TStringField
      FieldName = 'CLIENT_ID'
      Size = 15
    end
    object Table1TITLE: TStringField
      FieldName = 'TITLE'
      Size = 6
    end
    object Table1EMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 35
    end
    object Table1TAXPROV: TStringField
      FieldName = 'TAXPROV'
      Size = 2
    end
    object Table1GENDER: TStringField
      FieldName = 'GENDER'
      Size = 1
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 65
    Top = 540
  end
  object OpenDialog1: TOpenDialog
    Left = 476
    Top = 182
  end
end
