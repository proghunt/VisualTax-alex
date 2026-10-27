object SaveAsT4T5_2026: TSaveAsT4T5_2026
  Left = 370
  Top = 206
  Caption = 'Save as...'
  ClientHeight = 458
  ClientWidth = 654
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
    Top = 174
    Width = 648
    Height = 281
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
    object noteslbl: TLabel
      Left = 18
      Top = 155
      Width = 100
      Height = 16
      Alignment = taCenter
      Caption = 'Preparer'#39's Notes:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object StatusGroup: TRadioGroup
      Left = 18
      Top = 20
      Width = 253
      Height = 124
      Caption = '  Overall Preparation Status  '
      Color = clBtnFace
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 0
    end
    object ClearBtn: TBitBtn
      Left = 122
      Top = 150
      Width = 86
      Height = 21
      Caption = 'Clear Notes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ClearBtnClick
    end
    object Notes: TEdit
      Left = 18
      Top = 177
      Width = 606
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
      Left = 157
      Top = 205
      Width = 327
      Height = 55
      BevelInner = bvRaised
      BevelOuter = bvNone
      BorderWidth = 1
      BorderStyle = bsSingle
      TabOrder = 3
      object SaveBtn: TBitBtn
        Left = 14
        Top = 7
        Width = 89
        Height = 33
        Caption = 'Save'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
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
        ParentFont = False
        TabOrder = 0
        OnClick = SaveBtnClick
      end
      object CancelBtn: TBitBtn
        Left = 126
        Top = 7
        Width = 80
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        Kind = bkCancel
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 1
        OnClick = CancelBtnClick
      end
      object HelpBtn: TBitBtn
        Left = 224
        Top = 7
        Width = 85
        Height = 33
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Kind = bkHelp
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 2
        OnClick = HelpBtnClick
      end
    end
    object FilingStatusPanel: TPanel
      Left = 294
      Top = 20
      Width = 330
      Height = 121
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBackground
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      object Label5: TLabel
        Left = 28
        Top = 4
        Width = 234
        Height = 16
        Caption = 'Filing Status of Slips and Summaries'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object T4CountLbl: TLabel
        Left = 14
        Top = 33
        Width = 66
        Height = 13
        Caption = 'T4CountLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object T4ACountLbl: TLabel
        Left = 14
        Top = 52
        Width = 74
        Height = 13
        Caption = 'T4ACountLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object T5CountLbl: TLabel
        Left = 14
        Top = 71
        Width = 66
        Height = 13
        Caption = 'T4CountLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 14
        Top = 97
        Width = 262
        Height = 13
        Caption = '(Set Status on the Empl screen before saving)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBackground
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object T4StatusLbl: TLabel
        Left = 108
        Top = 33
        Width = 69
        Height = 13
        Caption = 'T4StatusLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object T4AStatusLbl: TLabel
        Left = 108
        Top = 52
        Width = 69
        Height = 13
        Caption = 'T4StatusLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object T5StatusLbl: TLabel
        Left = 108
        Top = 71
        Width = 69
        Height = 13
        Caption = 'T5StatusLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 648
    Height = 165
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
      Left = 18
      Top = 87
      Width = 57
      Height = 16
      Caption = 'Directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 18
      Top = 58
      Width = 69
      Height = 16
      Caption = 'File Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RetNameLbl: TLabel
      Left = 122
      Top = 13
      Width = 418
      Height = 22
      Alignment = taCenter
      AutoSize = False
      Caption = 'RetNameLbl'
      Color = clGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label2: TLabel
      Left = 16
      Top = 13
      Width = 97
      Height = 16
      Caption = 'Current Return:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 13
      Top = 120
      Width = 103
      Height = 16
      Caption = 'File Description:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object FLNameBox: TEdit
      Left = 122
      Top = 57
      Width = 418
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
      Left = 122
      Top = 85
      Width = 418
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
      Left = 122
      Top = 120
      Width = 418
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
      Left = 546
      Top = 85
      Width = 71
      Height = 22
      Hint = 'Click if directory already exists'
      Caption = 'Browse...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = BrowseBtnClick
    end
    object sbStorage: TScrollBox
      Left = 18
      Top = 158
      Width = 589
      Height = 63
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentBackground = True
      TabOrder = 4
    end
  end
end
