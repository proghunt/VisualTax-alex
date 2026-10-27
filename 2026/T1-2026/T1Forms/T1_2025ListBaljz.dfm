object ListBalT1jz_2024: TListBalT1jz_2024
  Left = 192
  Top = 129
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'List Balances - extra functions while in degug'
  ClientHeight = 550
  ClientWidth = 1180
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  DesignSize = (
    1180
    550)
  PixelsPerInch = 96
  TextHeight = 16
  object Panel2: TPanel
    Left = 7
    Top = 7
    Width = 561
    Height = 461
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      561
      461)
    object Label1: TLabel
      Left = 7
      Top = 36
      Width = 93
      Height = 16
      Caption = 'Data Directory'
    end
    object Label2: TLabel
      Left = 343
      Top = 271
      Width = 175
      Height = 16
      Anchors = [akRight, akBottom]
      Caption = 'Approximate no. of returns:'
      ExplicitLeft = 889
      ExplicitTop = 126
    end
    object Label3: TLabel
      Left = 533
      Top = 126
      Width = 8
      Height = 16
      Anchors = [akTop, akRight]
      Caption = '--'
      ExplicitLeft = 487
    end
    object Label6: TLabel
      Left = 11
      Top = 126
      Width = 112
      Height = 16
      Caption = 'Now processing: '
    end
    object Label7: TLabel
      Left = 126
      Top = 126
      Width = 8
      Height = 16
      Caption = '--'
    end
    object Label5: TLabel
      Left = 7
      Top = 91
      Width = 51
      Height = 16
      Caption = 'Include:'
    end
    object Label4: TLabel
      Left = 10
      Top = 15
      Width = 417
      Height = 16
      Caption = 
        'Use this facility to print the balance due or refund for each re' +
        'turn'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object FileListBox1: TFileListBox
      Left = 7
      Top = 147
      Width = 544
      Height = 272
      Anchors = [akLeft, akTop, akRight, akBottom]
      Mask = '*.d'
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 7
      Top = 56
      Width = 472
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnExit = DataDirBoxExit
    end
    object CPPLinesCheckBox: TCheckBox
      Left = 252
      Top = 91
      Width = 80
      Height = 17
      Caption = 'CPP lines'
      TabOrder = 2
    end
    object line15000CheckBox: TCheckBox
      Left = 154
      Top = 91
      Width = 80
      Height = 17
      Caption = 'Line 15000'
      TabOrder = 3
    end
    object HeaderCheckBox: TCheckBox
      Left = 70
      Top = 91
      Width = 80
      Height = 17
      Caption = 'Header'
      TabOrder = 4
    end
    object OKBtn: TBitBtn
      Left = 394
      Top = 429
      Width = 154
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = 'Create Listing'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 5
      OnClick = OKBtnClick
    end
    object browseDataDirButton: TButton
      Left = 434
      Top = 56
      Width = 61
      Height = 25
      Caption = 'browse'
      TabOrder = 6
      OnClick = browseDataDirButtonClick
    end
  end
  object Panel1: TPanel
    Left = 581
    Top = 8
    Width = 587
    Height = 460
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 1
    DesignSize = (
      587
      460)
    object Label8: TLabel
      Left = 11
      Top = 34
      Width = 93
      Height = 16
      Caption = 'Data Directory'
    end
    object Label9: TLabel
      Left = 10
      Top = 8
      Width = 201
      Height = 16
      Caption = 'Exact lines from CRA XML files'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 336
      Top = 91
      Width = 24
      Height = 16
      Caption = 'and'
    end
    object Label11: TLabel
      Left = 189
      Top = 91
      Width = 24
      Height = 16
      Caption = 'and'
    end
    object Label12: TLabel
      Left = 63
      Top = 91
      Width = 28
      Height = 16
      Caption = 'and '
    end
    object xmlDataDirEditBox: TEdit
      Left = 7
      Top = 54
      Width = 442
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnExit = DataDirBoxExit
    end
    object exrtractfromCraXMLBTN: TBitBtn
      Left = 418
      Top = 427
      Width = 154
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = 'Extract'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      OnClick = exrtractfromCraXMLBTNClick
    end
    object FileListBox2: TFileListBox
      Left = 7
      Top = 147
      Width = 561
      Height = 272
      Anchors = [akLeft, akTop, akRight, akBottom]
      Mask = '*.d'
      TabOrder = 2
    end
    object CRABalCheckBox: TCheckBox
      Left = 105
      Top = 91
      Width = 85
      Height = 17
      Caption = 'Balance'
      TabOrder = 3
    end
    object craCPPLinesCheckBox: TCheckBox
      Left = 378
      Top = 91
      Width = 80
      Height = 17
      Caption = 'CPP lines'
      TabOrder = 4
    end
    object xmlDataDirButton: TButton
      Left = 455
      Top = 56
      Width = 61
      Height = 25
      Caption = 'browse'
      TabOrder = 5
      OnClick = xmlDataDirButtonClick
    end
    object ln15000checkbox: TCheckBox
      Left = 231
      Top = 91
      Width = 99
      Height = 17
      Caption = 'Line 15000'
      TabOrder = 6
    end
    object craSINCheckBox: TCheckBox
      Left = 7
      Top = 91
      Width = 80
      Height = 17
      Caption = 'SIN'
      TabOrder = 7
    end
  end
  object CancelBtn: TBitBtn
    Left = 1083
    Top = 511
    Width = 86
    Height = 22
    Anchors = [akRight, akBottom]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object compareVTCRABalClick: TBitBtn
    Left = 910
    Top = 476
    Width = 257
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = 'Compare  VT and CRA Balances'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 3
    OnClick = compareVTCRABalClickClick
  end
  object PrintDialog1: TPrintDialog
    Left = 18
    Top = 434
  end
end
