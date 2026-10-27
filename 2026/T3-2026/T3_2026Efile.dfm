object EfileT3_2026: TEfileT3_2026
  Left = 137
  Top = 0
  Caption = 'T3 EFILE using CRA Web Services'
  ClientHeight = 591
  ClientWidth = 544
  Color = 11301888
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poDesigned
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelEfileType: TLabel
    Left = 182
    Top = 38
    Width = 204
    Height = 22
    Caption = 'T3 Efile On-Line (EOL)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 66
    Top = 300
    Width = 423
    Height = 16
    Caption = 
      'CRA does not support electronic '#39'Amend'#39' of T3 returns. (use T3AD' +
      'J)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 572
    Width = 544
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitWidth = 970
  end
  object ProdOrTestBox: TRadioGroup
    Left = 164
    Top = 116
    Width = 235
    Height = 33
    Caption = 'Tax Preparer or Software Developer'#39's Test'
    Color = clBtnFace
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Production'
      'Test')
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 1
  end
  object TransmitBtn: TBitBtn
    Left = 175
    Top = 167
    Width = 99
    Height = 59
    Hint = 'Connect to Internet and transmit to CCRA'
    Caption = 'Transmit now...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
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
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Spacing = 1
    TabOrder = 2
    OnClick = TransmitBtnClick
  end
  object ExitBtn: TBitBtn
    Left = 287
    Top = 168
    Width = 99
    Height = 59
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkCancel
    Layout = blGlyphTop
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 3
    OnClick = ExitBtnClick
  end
  object CreateFileHML: TBitBtn
    Left = 161
    Top = 245
    Width = 243
    Height = 36
    Caption = '(optional) Show Efiling contents (JSON)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = CreateFileHMLClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 554
    Width = 544
    Height = 18
    Align = alBottom
    Color = clSilver
    TabOrder = 5
    ExplicitWidth = 970
    object Label2: TLabel
      Left = 58
      Top = 1
      Width = 448
      Height = 14
      Alignment = taCenter
      Caption = 
        '*** Before you Efile YOUR FIRST return  install the Microsoft MS' +
        'XML 6.0 program ***'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object Label9: TLabel
      Left = 127
      Top = 42
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
      Visible = False
    end
    object Label1: TLabel
      Left = 211
      Top = 63
      Width = 382
      Height = 13
      Caption = 
        'The above allows you to use the CRA Web Services for Efiling T1 ' +
        'and also T013'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object BitBtn5: TBitBtn
      Left = 287
      Top = 21
      Width = 106
      Height = 18
      Caption = 'Install MSXML 6.0'
      TabOrder = 0
      Visible = False
      OnClick = BitBtn5Click
    end
  end
  object WebBrowser1: TWebBrowser
    Left = 371
    Top = 189
    Width = 0
    Height = 8
    Hint = '5'
    TabOrder = 6
    ControlData = {
      4C00000000000000D40000000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object testingPanel: TvtPanel
    Left = 581
    Top = 21
    Width = 358
    Height = 414
    TabOrder = 7
    Visible = False
    vtTableNumber = 0
    vtRowNumber = 0
    object Label3: TLabel
      Left = 21
      Top = 182
      Width = 114
      Height = 13
      Caption = 'Location of built file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label6: TLabel
      Left = 21
      Top = 14
      Width = 95
      Height = 13
      Caption = 'TESTINGPANEL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object FileNameBox: TEdit
      Left = 21
      Top = 203
      Width = 55
      Height = 24
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      Text = 'FileNameBox'
    end
    object ShowContentsBtn: TBitBtn
      Left = 21
      Top = 231
      Width = 50
      Height = 36
      Caption = 'Show Efile SOAP message being submitted'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ShowContentsBtnClick
    end
    object testResponse: TBitBtn
      Left = 21
      Top = 133
      Width = 204
      Height = 22
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
      TabOrder = 2
      OnClick = testResponseClick
    end
    object rgReturnType: TRadioGroup
      Left = 21
      Top = 273
      Width = 318
      Height = 116
      Caption = 'Return Type'
      Color = clBtnFace
      Columns = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'T3'
        'T3M'
        'T3RCA'
        'T3ATH'
        'T3D'
        'T3P'
        'T3PRP'
        'T3GR'
        'T3RI'
        'T3S'
        'T1061')
      ParentBackground = False
      ParentColor = False
      ParentFont = False
      TabOrder = 3
    end
    object BitBtn1: TBitBtn
      Left = 21
      Top = 84
      Width = 204
      Height = 22
      Cancel = True
      Caption = 'Test Program Values Against Cert JSON'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Layout = blGlyphTop
      ModalResult = 2
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 4
      OnClick = BitBtn1Click
    end
    object transmitWithTestFileCHK: TCheckBox
      Left = 28
      Top = 112
      Width = 190
      Height = 17
      Caption = 'Transmit Efile with Test File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCream
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object BitBtn2: TBitBtn
      Left = 21
      Top = 56
      Width = 204
      Height = 22
      Cancel = True
      Caption = 'Traverse JSON, compare against VT'
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
      OnClick = BitBtn2Click
    end
    object removeRefundCodeCheckBox: TCheckBox
      Left = 21
      Top = 35
      Width = 120
      Height = 17
      Caption = 'remove refund code'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCream
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
  end
  object MainMenu1: TMainMenu
    Left = 105
    Top = 336
    object WebServiceserrors1: TMenuItem
      Caption = 'Web Services errors'
      OnClick = WebServiceserrors1Click
    end
    object EfileErrorMessages1: TMenuItem
      Caption = 'Efile Error Messages'
      OnClick = EfileErrorMessages1Click
    end
    object ExitProgram: TMenuItem
      Caption = '&Exit'
    end
  end
  object Query1: TQuery
    Left = 65193
    Top = 65462
  end
  object OpenDialog1: TOpenDialog
    Left = 105
    Top = 434
  end
  object SaveDialog1: TSaveDialog
    OnClose = SaveDialog1Close
    Left = 105
    Top = 385
  end
end
