object SaveAsTF_2026: TSaveAsTF_2026
  Left = 370
  Top = 206
  Caption = 'Save as...'
  ClientHeight = 515
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 263
    Width = 778
    Height = 249
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object statuslbl: TLabel
      Left = 40
      Top = 9
      Width = 109
      Height = 16
      Alignment = taCenter
      Caption = 'Status Indicators'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -16
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object noteslbl: TLabel
      Left = 16
      Top = 160
      Width = 114
      Height = 16
      Alignment = taCenter
      Caption = 'Preparer'#39's Notes:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object StatusGroup: TRadioGroup
      Left = 16
      Top = 24
      Width = 233
      Height = 89
      Caption = '  Preparation Status  '
      Color = clBtnFace
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object ClearBtn: TBitBtn
      Left = 144
      Top = 152
      Width = 65
      Height = 21
      Caption = 'Clear Notes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ClearBtnClick
    end
    object Notes: TEdit
      Left = 16
      Top = 184
      Width = 393
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object Panel3: TPanel
      Left = 280
      Top = 22
      Width = 121
      Height = 147
      BevelInner = bvRaised
      BevelOuter = bvNone
      BorderWidth = 1
      BorderStyle = bsSingle
      TabOrder = 3
      object SaveBtn: TBitBtn
        Left = 16
        Top = 8
        Width = 89
        Height = 33
        Caption = 'Save'
        Glyph.Data = {
          56020000424D5602000000000000760000002800000024000000180000000100
          040000000000E001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888880000888888888888888888888888888888888888
          0000888888888888888884444444444444444488000088888888808888884444
          4444444444444448000088888888800888884444444444444444444800008888
          000000B088884444447788888444444800008888000000B088884444447888FF
          F444444800008880000000BB08884444447878888444444800008880BBBBBBBB
          B0884444447777777444444800008880BBBBBBBBBB0844444444444444444448
          00008880BBBBBBBBBBF04444444444444444444800008880BBBBBBBBBB084444
          444444444444444800008880BBBBBBBBB0884444FFFFFFFFFFF4444800008880
          000000BB08884444FFFFFFFFFFF4444800008888888880B088884444FFFFFFFF
          FFF44448000088888888800888884444FFFFFFFFFFF444480000888888888088
          88884444FFFFFFFFFFF44448000088888888888888884444FFFFFFFFFFF44448
          000080008800888888884444FFFFFFFFFFF44448000088808800888888884C4C
          0C4C4C4C4C4C4C48000080008800888888884444444444444444444800008088
          8088088888888888888888888888888800008000808808888888888888888888
          8888888800008888888888888888888888888888888888880000}
        TabOrder = 0
        OnClick = SaveBtnClick
      end
      object CancelBtn: TBitBtn
        Left = 16
        Top = 56
        Width = 89
        Height = 33
        Kind = bkCancel
        NumGlyphs = 2
        TabOrder = 1
        OnClick = CancelBtnClick
      end
      object HelpBtn: TBitBtn
        Left = 16
        Top = 104
        Width = 89
        Height = 33
        Kind = bkHelp
        NumGlyphs = 2
        TabOrder = 2
        OnClick = HelpBtnClick
      end
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 778
    Height = 254
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TLabel
      Left = 16
      Top = 98
      Width = 52
      Height = 13
      Caption = 'Directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 16
      Top = 40
      Width = 61
      Height = 13
      Caption = 'File Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RetNameLbl: TLabel
      Left = 114
      Top = 8
      Width = 249
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'RetNameLbl'
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label2: TLabel
      Left = 38
      Top = 8
      Width = 72
      Height = 13
      Caption = 'Current Return:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 13
      Top = 125
      Width = 93
      Height = 13
      Caption = 'File Description:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 114
      Top = 60
      Width = 429
      Height = 14
      Caption = 
        'Use a unique file name such as an account XXXXXXXXX (NO special ' +
        'characters)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 114
      Top = 148
      Width = 411
      Height = 14
      Caption = 
        'Use a more decriptive name and easier to relate to. (No special ' +
        'characters)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object FLNameBox: TEdit
      Left = 115
      Top = 32
      Width = 174
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 110
      Top = 90
      Width = 420
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object FlDescrBox: TEdit
      Left = 112
      Top = 121
      Width = 421
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnChange = FlDescrBoxChange
    end
    object BrowseBtn: TBitBtn
      Left = 536
      Top = 93
      Width = 71
      Height = 22
      Hint = 'Click if directory already exists'
      Caption = 'Browse...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = BrowseBtnClick
    end
    object sbStorage: TScrollBox
      Left = 13
      Top = 168
      Width = 570
      Height = 63
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentBackground = True
      TabOrder = 4
    end
  end
end
