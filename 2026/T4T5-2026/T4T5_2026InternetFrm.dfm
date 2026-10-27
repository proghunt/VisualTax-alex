object InternetFrmT4T5_2026: TInternetFrmT4T5_2026
  Left = 346
  Top = 208
  Caption = 'Internet Filing'
  ClientHeight = 524
  ClientWidth = 725
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 466
    Width = 725
    Height = 58
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 420
    object CancelBtn: TBitBtn
      Left = 518
      Top = 7
      Width = 120
      Height = 42
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
      OnClick = CancelBtnClick
    end
    object PrepBtn: TBitBtn
      Left = 84
      Top = 7
      Width = 120
      Height = 42
      Hint = 'Prepare file'
      Caption = 'Prepare XML file...'
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 1
      TabOrder = 1
      OnClick = PrepBtnClick
    end
    object ConnectBtn: TBitBtn
      Left = 347
      Top = 6
      Width = 165
      Height = 42
      Hint = 'Prepare file'
      Caption = 'Internet File now...'
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
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = ConnectBtnClick
    end
    object ShowXmittalBtn: TBitBtn
      Left = 651
      Top = 7
      Width = 25
      Height = 36
      Hint = 'Print T619 Transmittal form'
      Caption = 'Show Xmittal Form'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Layout = blGlyphTop
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 1
      TabOrder = 3
      Visible = False
    end
    object PrintXmittalBtn: TBitBtn
      Left = 679
      Top = 7
      Width = 25
      Height = 35
      Hint = 'Print T619 Transmittal form'
      Caption = 'Print Xmittal Form'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        56020000424D5602000000000000760000002800000024000000180000000100
        040000000000E001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888888880000888888888888888888888888888888888888
        0000888888888888888888888888888888888888000088888888888888888888
        8888888888888888000088888877000000000000000007788888888800008888
        8800000000000000000000078888888800008888877777777777777777777770
        788888880000888887F888888888888888888777078888880000888887F88888
        8888888889988777707888880000888887F88888888888888998877777088888
        0000888887F8CCCC8888888889988777770888880000888887F8888888888888
        88888877770888880000888887FFFFFFFFFFFFFFFFF888877708888800008888
        878FFFFFFFFFFFFFFFF8888877088888000088888878FF000000000000008888
        870888880000888888878FF07FFFFFFFFF707888880888880000888888887888
        74444444FF7007888708888800008888888887007FFFFFFFFF70000000888888
        00008888888888887F4444444F7888888888888800008888888888887FFFFFFF
        FF78888888888888000088888888888887F4444444F788888888888800008888
        8888888887FFFFFFFFF788888888888800008888888888888888888888888888
        8888888800008888888888888888888888888888888888880000}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 1
      TabOrder = 4
      Visible = False
    end
    object ShowXmlBtn: TBitBtn
      Left = 210
      Top = 7
      Width = 120
      Height = 42
      Caption = 'Show the XML'
      TabOrder = 5
      OnClick = ShowXmlBtnClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 725
    Height = 80
    Align = alTop
    Color = 15925247
    TabOrder = 1
    object Label6: TLabel
      Left = 10
      Top = 8
      Width = 43
      Height = 16
      Caption = 'STEPS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label14: TLabel
      Left = 8
      Top = 40
      Width = 160
      Height = 16
      Caption = '2. Click on Prepare XML file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 8
      Top = 56
      Width = 163
      Height = 16
      Caption = '3. Click on Internet File Now'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 8
      Top = 26
      Width = 132
      Height = 16
      Caption = '1. Select type of return'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 121
    Width = 725
    Height = 345
    Align = alClient
    TabOrder = 2
    ExplicitHeight = 386
    DesignSize = (
      725
      345)
    object Label2: TLabel
      Left = 14
      Top = 65
      Width = 179
      Height = 16
      Caption = 'Submission Reference Number'
    end
    object Label11: TLabel
      Left = 14
      Top = 169
      Width = 125
      Height = 16
      Caption = 'URL for Internet Filing'
    end
    object Label1: TLabel
      Left = 14
      Top = 117
      Width = 74
      Height = 16
      Caption = 'File Location'
    end
    object Label4: TLabel
      Left = 143
      Top = 90
      Width = 143
      Height = 16
      Caption = '(Assigned automatically)'
    end
    object Label3: TLabel
      Left = 14
      Top = 227
      Width = 554
      Height = 16
      Caption = 
        'Before you click '#39'Prepare XML", exit first and visit  the Config' +
        'ure -> General Options -> Preparer '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 14
      Top = 245
      Width = 587
      Height = 16
      Caption = 
        'and enter the correct '#39'Transmitter Account No  or a Rep Id, as t' +
        'he XML created will be slightly different'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 14
      Top = 267
      Width = 590
      Height = 16
      Caption = 
        'Do Not login to CRA with RepId or MyAccount.  There an issue to ' +
        'be resolved by CRA  by Jan 31,2026'
      Color = clBlue
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 723
      Height = 48
      Align = alTop
      TabOrder = 0
      object DataTypeBtn: TRadioGroup
        Left = 219
        Top = 1
        Width = 356
        Height = 46
        Align = alLeft
        Caption = 'Data type for ALL slips submitted in this transmission'
        Columns = 3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Original'
          'Amended'
          'Canceled')
        ParentFont = False
        TabOrder = 0
      end
      object TypeOfReturnBtn: TRadioGroup
        Left = 1
        Top = 1
        Width = 218
        Height = 46
        Align = alLeft
        Caption = 'Type of return '
        Columns = 3
        Items.Strings = (
          'T4'
          'T4A'
          'T5')
        TabOrder = 1
        OnClick = TypeOfReturnBtnClick
      end
    end
    object SubmissionSeqBox: TEdit
      Left = 353
      Top = 82
      Width = 91
      Height = 24
      Enabled = False
      TabOrder = 1
      Visible = False
    end
    object SubmissionPrefixBox: TEdit
      Left = 48
      Top = 87
      Width = 89
      Height = 24
      ReadOnly = True
      TabOrder = 2
    end
    object FlNm: TEdit
      Left = 48
      Top = 139
      Width = 610
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
    object UrlBox: TEdit
      Left = 48
      Top = 191
      Width = 610
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
    object cbUseXMLValidator: TCheckBox
      Left = 210
      Top = 308
      Width = 254
      Height = 17
      Caption = 'Use XML validator after prepare XML file'
      TabOrder = 5
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 80
    Width = 725
    Height = 41
    Align = alTop
    Caption = 'INTERNET FILING (XML format)'
    Color = clTeal
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
  end
  object PrintDialog1: TPrintDialog
    Left = 567
    Top = 177
  end
  object SaveDialog1: TSaveDialog
    Left = 623
    Top = 183
  end
end
