object T5013EfleT4T5_2019: TT5013EfleT4T5_2019
  Left = 122
  Top = 142
  Caption = 'Efile T5013'
  ClientHeight = 905
  ClientWidth = 1089
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Image1: TImage
    Left = 497
    Top = 413
    Width = 105
    Height = 105
  end
  object RsiFrmList: TListBox
    Left = 0
    Top = 187
    Width = 1089
    Height = 718
    Style = lbOwnerDrawFixed
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
  end
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 1089
    Height = 25
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    Caption = ' Efile T5013'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 1089
    Height = 162
    Align = alTop
    TabOrder = 2
    object Label6: TLabel
      Left = 15
      Top = 16
      Width = 144
      Height = 15
      Caption = 'URL for Efile web services'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 15
      Top = 64
      Width = 70
      Height = 15
      Caption = 'File Location'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 15
      Top = 109
      Width = 175
      Height = 15
      Caption = 'Submission Reference Number'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object ShowBarCodeDataBtn: TBitBtn
      Left = 656
      Top = 99
      Width = 134
      Height = 57
      Caption = 'Show Filing Data'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ShowBarCodeDataBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 936
      Top = 99
      Width = 134
      Height = 57
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
    end
    object WebServiceEfileBtn: TBitBtn
      Left = 796
      Top = 99
      Width = 134
      Height = 57
      Caption = 'EFILE NOW'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        DA080000424DDA08000000000000360400002800000022000000210000000100
        080000000000A404000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600FFF3FF0000006600000099000000CC000033000000333300003366000033
        99000033CC000033FF00006600000066330000666600006699000066CC000066
        FF000099330000996600009999000099CC000099FF0000CC000000CC330000CC
        660000CC990000CCCC0000CCFF0000FF330000FF660000FF990000FFCC003300
        00003300330033006600330099003300CC003300FF0033330000333333003333
        6600333399003333CC003333FF00336600003366330033666600336699003366
        CC003366FF00339900003399330033996600339999003399CC003399FF0033CC
        000033CC330033CC66000099000033CC990033CCCC0033CCFF0033FF000033FF
        330033FF660033FF990033FFCC0033FFFF006600000066003300660066006600
        99006600CC006600FF00663300006633330066336600663399006633CC006633
        FF00666600006666330066666600666699006666CC006666FF00669900006699
        330066996600669999006699CC006699FF0066CC000066CC330066CC660066CC
        990066CCCC0066CCFF0066FF000066FF330066FF660066FF990066FFCC0066FF
        FF00990000009900330099006600990099009900CC009900FF00993300009933
        330099336600993399009933CC009933FF009966000099663300996666009966
        99009966CC009966FF00999900009999330099996600999999009999CC009999
        FF0099CC000099CC330099CC660099CC990099CCCC0099CCFF0099FF000099FF
        330099FF660099FF990099FFCC0099FFFF00CC000000CC003300CC006600CC00
        9900CC00CC00CC00FF00CC330000CC333300CC336600CC339900CC33CC00CC33
        FF00CC660000CC663300CC666600CC669900CC66CC00CC66FF00CC990000CC99
        3300CC996600CC999900CC99CC00CC99FF00CCCC0000CCCC3300CCCC6600CCCC
        9900CCCCCC00CCCCFF00CCFF0000CCFF3300CCFF6600CCFF9900CCFFCC00CCFF
        FF00FF003300FF006600FF009900FF00CC00FF330000FF333300FF336600FF33
        9900FF33CC00FF33FF00FF660000FF663300FF666600FF669900FF66CC00FF66
        FF00FF990000FF993300FF996600FF999900FF99CC00FF99FF00FFCC0000FFCC
        3300FFCC6600FFCC9900FFCCCC00FFCCFF00FFFF3300FFFF6600FFFF9900FFFF
        CC007D7D7D0061285500249D2C0018008D006D79610091102C0034DA3400B24C
        9D00754C6500442038000000A5009D309100000095009D488D00004BB400004C
        B300004DB200004EB100004FB0000050AF000051AE000052AD000053AC000054
        AB000055AA000056A9000048B7000049B600F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFCFCFCFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF
        FFFFFFFFFFFFFFFFFFFCFCFCFCFCFCFCFCFCFCFCFCFFFFFFFFFFFFFFFFFFFFFF
        0000FFFFFFFFFFFFFFFFFFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFFFFFFFFFF
        FFFFFFFF0000FFFFFFFFFFFFFFFFFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
        FFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFCFCFCFCFC07FA07FCFCFCFCFCFCFCFC
        FCFCFCFCFCFCFFFFFFFFFFFF0000FFFFFFFFFFFCFCFCFCFC07FA07FCFCFCFCFC
        FCFCFCFCFCFCFCFCFCFCFCFFFFFFFFFF0000FFFFFFFFFFFCFCFCFCFC07FAFA07
        FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFFFFFFFFFF0000FFFFFFFFFCFCFCFCFCFC
        07FAFA07FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFFFFFFFF0000FFFFFFFCFCFC
        FCFCFCFCFAFAFAFAFAFCFCFCFCFCFCFCFCFCFCFCFC0707FCFCFFFFFF0000FFFF
        FFFCFCFCFCFCFCFCFAFAFAFAFA07FCFCFCFCFCFCFCFCFCFCFC07FA07FCFFFFFF
        0000FFFFFCFCFCFCFCFCFC07FAFAFAFAFAFAFA07FCFCFCFCFCFCFCFCFCFCFAFA
        07FCFFFF0000FFFFFCFCFCFCFCFCFCFAFAFAFAFAFAFAFAFAFCFCFCFCFCFCFCFC
        FCFC07FAFAFCFFFF0000FFFFFCFCFCFCFCFC07FAFAFAFAFAFAFAFAFAFCFCFCFC
        FCFCFCFCFCFC07FAFAFCFFFF0000FFFCFCFCFCFCFCFAFAFAFAFAFAFAFAFAFAFA
        07FCFCFCFCFCFCFCFCFC07FAFAFCFCFF0000FFFCFCFCFCFC07FAFAFAFAFAFAFA
        FAFAFAFAFAFCFCFCFCFCFCFCFCFC07FAFAFCFCFF0000FFFCFCFCFCFC07FAFAFA
        FAFAFAFAFAFAFA0707FCFCFCFCFCFCFCFCFC07FAFAFCFCFF0000FFFCFCFCFCFC
        FCFAFAFAFAFAFAFAFAFAFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFCFF0000FFFC
        FCFCFCFCFCFAFAFAFAFAFA0707FCFCFCFCFCFCFCFCFC07FAFAFAFAFAFAFAFCFF
        0000FFFCFCFCFCFCFAFAFAFAFAFAFCFCFCFCFCFCFCFCFCFCFC07FAFAFAFAFAFA
        FAFCFCFF0000FFFFFCFCFC07FA0707FA0707FCFCFCFCFCFCFCFCFCFC07FAFAFA
        FAFAFAFAFAFCFFFF0000FFFFFCFCFAFAFAFAFCFCFCFCFCFCFCFCFCFCFCFCFCFC
        07FAFAFAFAFAFAFAFAFCFFFF0000FFFFFC07FAFA07FC07FAFAFCFCFCFCFCFCFC
        FCFCFCFC07FAFAFAFAFAFAFA07FCFFFF0000FFFFFF07FA07FC07FCFCFCFCFCFC
        FCFCFCFCFCFCFCFCFCFAFAFAFAFAFAFAFCFFFFFF0000FFFFFFFAFAFAFAFA07FC
        FCFCFCFCFCFCFCFCFCFCFCFCFC07FAFAFAFAFAFCFCFFFFFF0000FFFFFFFAFAFA
        FAFAFA07FCFCFCFCFCFCFCFCFCFCFCFCFC0707FAFA07FCFCFFFFFFFF0000FFFF
        FFFFFFFAFAFAFAFAFA07FCFCFCFCFCFCFCFCFCFCFCFAFAFCFAFA07FFFFFFFFFF
        0000FFFFFFFFFFFAFAFAFAFAFAFA07FCFCFCFCFCFCFCFCFCFC07FAFAFA07FCFF
        FFFFFFFF0000FFFFFFFFFFFFFAFA0707FAFAFA0707FC07FCFCFCFC07FAFAFAFA
        07FCFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFCFAFA07FAFAFC07FAFAFCFCFCFA
        FAFAFAFCFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFC07FAFAFA0707FAFA
        07FC07FA0707FCFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFCFAFA
        FA07FAFCFCFCFCFCFCFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
        FFFFFFFAFAFCFCFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000}
      Layout = blGlyphTop
      ParentFont = False
      TabOrder = 2
      OnClick = WebServiceEfileBtnClick
    end
    object testingIndicator: TPanel
      Left = 470
      Top = 6
      Width = 600
      Height = 87
      Hint = 'If yellow box is visible then in testing mode'
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Caption = 'visible panel = testing'
      Color = clYellow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      object corFileClickLbl: TvtLabel
        Left = 0
        Top = 0
        Width = 148
        Height = 15
        Hint = 'Click here to create .cor file'
        Alignment = taCenter
        AutoSize = False
        Caption = 'create COR -view soap data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Transparent = True
        vtIsPrintable = False
        vtBorderType = vtlblFull
      end
      object xmlInfoFileInputBox: TEdit
        Left = 0
        Top = 56
        Width = 386
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object xmlInfoFileBtn: TBitBtn
        Left = 392
        Top = 56
        Width = 121
        Height = 21
        Caption = 'select source file'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = xmlInfoFileBtnClick
      end
      object T619xmlInfoFileInputBox: TEdit
        Left = 0
        Top = 32
        Width = 386
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        Text = 'C:\XE-WIP\2019\DistrFl\TF-2019\t619xml.xml'
      end
    end
    object URLForWebServicesBox: TEdit
      Left = 15
      Top = 32
      Width = 449
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object FileLocationBox: TEdit
      Left = 15
      Top = 80
      Width = 449
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
    end
    object SubmissionPrefixBox: TEdit
      Left = 15
      Top = 125
      Width = 89
      Height = 24
      ReadOnly = True
      TabOrder = 6
    end
    object SubmissionSeqBox: TEdit
      Left = 111
      Top = 125
      Width = 91
      Height = 24
      Enabled = False
      TabOrder = 7
      Visible = False
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 862
    Top = 27
  end
  object OpenDialog1: TOpenDialog
    Left = 934
    Top = 25
  end
end
