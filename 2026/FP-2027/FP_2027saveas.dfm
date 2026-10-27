object SaveAsFP_2012: TSaveAsFP_2012
  Left = 172
  Top = 154
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Save as...'
  ClientHeight = 444
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 175
    Width = 594
    Height = 211
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
    object statuslbl: TLabel
      Left = 198
      Top = 16
      Width = 109
      Height = 16
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
    end
    object noteslbl: TLabel
      Left = 8
      Top = 160
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
    object StatusGroup: TRadioGroup
      Left = 57
      Top = 39
      Width = 413
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
      Left = 416
      Top = 176
      Width = 65
      Height = 21
      Caption = 'Clear Notes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = ClearBtnClick
    end
    object Notes: TEdit
      Left = 8
      Top = 176
      Width = 393
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 594
    Height = 166
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
    object TLabel
      Left = 20
      Top = 101
      Width = 56
      Height = 13
      Caption = 'Directory:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
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
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RetNameLbl: TLabel
      Left = 125
      Top = 10
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
      Left = 52
      Top = 8
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
      Left = 84
      Top = 57
      Width = 363
      Height = 13
      Caption = 
        'The default File name consists of: Last Name, First Name, Plan D' +
        'ate and SIN'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 84
      Top = 76
      Width = 370
      Height = 13
      Caption = 'But you can change it to a short name such as ClientName-Plan1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object FLNameBox: TEdit
      Left = 80
      Top = 32
      Width = 390
      Height = 21
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 82
      Top = 98
      Width = 388
      Height = 21
      TabOrder = 1
      OnExit = DataDirBoxExit
      OnKeyPress = DataDirBoxKeyPress
    end
    object sbStorage: TScrollBox
      Left = 8
      Top = 112
      Width = 570
      Height = 63
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      ParentBackground = True
      TabOrder = 2
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 392
    Width = 594
    Height = 49
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    TabOrder = 1
    object SaveBtn: TBitBtn
      Left = 136
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
      Left = 240
      Top = 8
      Width = 105
      Height = 33
      Caption = 'Do NOT save'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = DoNotSaveBtnClick
    end
    object HelpBtn: TBitBtn
      Left = 360
      Top = 8
      Width = 73
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 2
      OnClick = HelpBtnClick
    end
  end
end
