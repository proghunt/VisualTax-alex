object SaveAsT1_2026: TSaveAsT1_2026
  AlignWithMargins = True
  Left = 778
  Top = 250
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Save as...'
  ClientHeight = 546
  ClientWidth = 793
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 299
    Width = 783
    Height = 183
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      779
      179)
    object statuslbl: TLabel
      Left = 2
      Top = 2
      Width = 775
      Height = 16
      Align = alTop
      Alignment = taCenter
      Caption = 'Status Indicators'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
      ExplicitWidth = 109
    end
    object noteslbl: TLabel
      Left = 9
      Top = 149
      Width = 97
      Height = 14
      Alignment = taCenter
      Caption = 'Preparer'#39's Notes:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label3: TLabel
      Left = 108
      Top = 111
      Width = 357
      Height = 13
      Caption = 
        'You may attach a Return Category code of your choice (Max 15 cha' +
        'racters)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 108
      Top = 130
      Width = 346
      Height = 13
      Caption = 
        'You can filter your returns using this code on the '#39'Selective Op' +
        'en'#39' window'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 9
      Top = 111
      Width = 93
      Height = 14
      Caption = 'Return Category:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object StatusGroup: TRadioGroup
      Left = 8
      Top = 16
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
    object EFStatusGroup: TRadioGroup
      Left = 248
      Top = 16
      Width = 383
      Height = 89
      Anchors = [akLeft, akTop, akRight]
      Caption = '  Filing Status  '
      Color = clBtnFace
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
    end
    object ClearBtn: TBitBtn
      Left = 569
      Top = 146
      Width = 82
      Height = 21
      Caption = 'Clear Notes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = ClearBtnClick
    end
    object Notes: TEdit
      Left = 112
      Top = 146
      Width = 451
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object Category: TEdit
      Left = 483
      Top = 111
      Width = 81
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      MaxLength = 15
      ParentFont = False
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 783
    Height = 284
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Ms Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label1: TLabel
      Left = 14
      Top = 30
      Width = 57
      Height = 13
      Caption = 'File Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RetNameLbl: TLabel
      Left = 200
      Top = 8
      Width = 345
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
      Left = 112
      Top = 10
      Width = 72
      Height = 13
      Caption = 'Current Return:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 365
      Top = 76
      Width = 245
      Height = 13
      Caption = 'File name must be the SIN in the format 99999999.9'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 365
      Top = 132
      Width = 229
      Height = 13
      Caption = 'You can deviate here only in exceptional cases. '
    end
    object Label8: TLabel
      Left = 365
      Top = 95
      Width = 328
      Height = 13
      Caption = 
        'Coupling can be done ONLY if you use one of these file name form' +
        'ats'
    end
    object Label9: TLabel
      Left = 365
      Top = 114
      Width = 369
      Height = 13
      Caption = 
        'Define your format in Configure -> General Options -> Defaults f' +
        'or Tax Returns.'
    end
    object FLNameBox: TEdit
      Left = 14
      Top = 49
      Width = 531
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object gbStorage: TGroupBox
      AlignWithMargins = True
      Left = 5
      Top = 183
      Width = 769
      Height = 92
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      object sbStorage: TScrollBox
        Left = 2
        Top = 15
        Width = 765
        Height = 75
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        DesignSize = (
          765
          75)
        object lblDirectoryNote: TLabel
          Left = 9
          Top = 52
          Width = 521
          Height = 13
          Caption = 
            'You can also change the Data Directory so the return is saved on' +
            ' a folder different than the one initially shown.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblDirectory: TLabel
          Left = 7
          Top = 6
          Width = 83
          Height = 13
          Caption = 'Data Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object BrowseBtn: TBitBtn
          Left = 562
          Top = 27
          Width = 51
          Height = 22
          Hint = 'Click if directory already exists'
          Anchors = [akTop, akRight]
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = BrowseBtnClick
        end
        object DataDirBox: TEdit
          Left = 7
          Top = 25
          Width = 531
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnExit = DataDirBoxExit
          OnKeyPress = DataDirBoxKeyPress
        end
      end
    end
    object FileNameFormat: TRadioGroup
      Left = 14
      Top = 76
      Width = 293
      Height = 61
      Caption = 'FileName format'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'SIN 99999999.9'
        'LastName FirstName-{SIN}.YR')
      ParentFont = False
      TabOrder = 2
      OnClick = FileNameFormatClick
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 492
    Width = 783
    Height = 49
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    TabOrder = 1
    object SaveBtn: TBitBtn
      Left = 237
      Top = 8
      Width = 89
      Height = 33
      Caption = '&Save'
      Glyph.Data = {
        56020000424D5602000000000000760000002800000024000000180000000100
        040000000000E001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777770000777777777777777777777777777777777777
        0000777777777777777774444444444444444477000077777777707777774444
        4444444444444447000077777777700777774444444444444444444700007777
        00000090777744444488777774444447000077770000009077774444448777FF
        F444444700007770000000990777444444878777744444470000777099999999
        9077444444888888844444470000777099999999990744444444444444444447
        0000777099999999999044444444444444444447000077709999999999074444
        4444444444444447000077709999999990774444FFFFFFFFFFF4444700007770
        0000009907774444FFFFFFFFFFF44447000077777777709077774444FFFFFFFF
        FFF44447000077777777700777774444FFFFFFFFFFF444470000777777777077
        77774444FFFFFFFFFFF44447000077777777777777774444FFFFFFFFFFF44447
        000077077700077777774444FFFFFFFFFFF44447000077077777077777774C4C
        0C4C4C4C4C4C4C47000077007700077777774444444444444444444700007707
        7777077777777777777777777777777700007700070007777777777777777777
        7777777700007777777777777777777777777777777777770000}
      TabOrder = 0
      OnClick = SaveBtnClick
    end
    object DoNotSaveBtn: TBitBtn
      Left = 332
      Top = 8
      Width = 118
      Height = 33
      Caption = 'Do NOT save'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = DoNotSaveBtnClick
    end
    object HelpBtn: TBitBtn
      Left = 456
      Top = 8
      Width = 73
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 2
      OnClick = HelpBtnClick
    end
    object btnDownload: TBitBtn
      Left = 552
      Top = 8
      Width = 145
      Height = 33
      Caption = 'Save and &Download'
      Glyph.Data = {
        0E060000424D0E06000000000000360000002800000016000000160000000100
        180000000000D8050000C40E0000C40E00000000000000000000FF00FFFF00FF
        1B814C04733A04733A04733A04733A04733A04733A04733A04733A04733A0473
        3A04733A04733A04733A04733A04733A04733A1B814CFF00FFFF00FF0000FF00
        FFFF00FF04733A7ECAA37ECAA37ECAA37ECAA37ECCA47FCEA57FD0A77FD1A780
        D2A880D2A880D1A87FD1A77FD0A77FCEA57ECCA47ECAA304733AFF00FFFF00FF
        0000FF00FFFF00FF04733A7ECAA3069A4E069A4E079F5108A4540AA8570BAC5A
        0CAF5B0CB05D0CB15D0CB05D0CAF5B0BAC5A0AA85708A4547ECDA404733AFF00
        FFFF00FF0000FF00FFFF00FF04733A7DC9A27DC9A27ECBA47ECEA57FD1A880D4
        A981D6AB82D9AC82DAAD82D9AD81D8AC81D7AB81D6AA80D4A97FD1A87ECEA504
        733AFF00FFFF00FF0000FF00FFFF00FF22845108753D08753D08753D08753D08
        753D07753C06753C08753D08753D06753C07753C08753D08753D08753D08753D
        08753D228452FF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF53A17943A9766BD9A16CDCA343AC7753A279FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF2F956075D8A61EC7711FCD7578E2AD309762FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF1E855076D2A329C37511C36913C86C2BCF7C78DAA9
        1F8751FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF177F4A70C89C39C17C0EB96210BD6511C16711C2
        683CCC836DCD9D17804AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00
        FFFF00FFFF00FFFF00FFFF00FF22855268BB9170CD9D12B15F0DB35E0EB7610E
        B9620FBA630EB9624FCA8B5BBC89228652FF00FFFF00FFFF00FFFF00FFFF00FF
        0000FF00FFFF00FFFF00FFFF00FF46996E55AB7F88D1AC42B97D34B7740FAD5D
        0CAF5C0CB15D0CB25E0CB15D0CAF5C62C99448A97746996EFF00FFFF00FFFF00
        FFFF00FF0000FF00FFFF00FFFF00FF79B596409B6D96D4B452B88346B67D3FB6
        7933B47218AD600AA9580AAA580AA9580AA85711A85B6EC89933956479B596FF
        00FFFF00FFFF00FF0000FF00FFFF00FFADD1BF2F8D5CA3D8BDA8DBC1A4DABEA0
        D8BB41B2793AB27431B06F22AA6509A25408A1537ECDA57ECCA47ECBA377C69E
        248754ADD1BFFF00FFFF00FF0000FF00FFFF00FF42976B04733A04733A04733A
        0C7A41A2D9BD45B37B3CB07432AC6D2AA8671AA25C069A4E7ECAA30C7A410473
        3A04733A04733A42976BFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FF04733AA4DABE47B47C3EB07634AD6F2CA96923A562119E567ECAA304
        733AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF04733AA5DABF49B57D40B17736AD702DA96924A66318A15B
        7ECAA304733AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF04733AA6DABF4AB57E40B17736AD702EAA6A25A6
        641AA25C7FCBA404733AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF04733AA6DABF4AB57E40B17736AD702E
        AA6A24A6631AA25C7FCBA404733AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF04733AA5DABFA0D8BB9CD6B8
        96D4B492D2B18DD0AE88CEAA80CBA404733AFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1B814C04733A0473
        3A04733A04733A04733A04733A04733A04733A1B814CFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
      TabOrder = 3
      OnClick = SaveBtnClick
    end
  end
end
