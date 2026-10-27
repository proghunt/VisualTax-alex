object ListBalT3jz_2025: TListBalT3jz_2025
  Left = 192
  Top = 129
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'List Balances - extra functions while in degug'
  ClientHeight = 478
  ClientWidth = 1080
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
    1080
    478)
  PixelsPerInch = 96
  TextHeight = 16
  object Panel2: TPanel
    Left = 7
    Top = 7
    Width = 515
    Height = 442
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      515
      442)
    object Label1: TLabel
      Left = 7
      Top = 36
      Width = 93
      Height = 16
      Caption = 'Data Directory'
    end
    object Label2: TLabel
      Left = 297
      Top = 252
      Width = 175
      Height = 16
      Anchors = [akRight, akBottom]
      Caption = 'Approximate no. of returns:'
      ExplicitLeft = 889
      ExplicitTop = 126
    end
    object Label3: TLabel
      Left = 487
      Top = 126
      Width = 8
      Height = 16
      Anchors = [akTop, akRight]
      Caption = '--'
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
      Width = 498
      Height = 253
      Anchors = [akLeft, akTop, akRight, akBottom]
      Mask = '*.d'
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 7
      Top = 56
      Width = 435
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
      Left = 266
      Top = 91
      Width = 80
      Height = 17
      Caption = 'CPP lines'
      Enabled = False
      TabOrder = 2
      Visible = False
    end
    object netIncomeCheckBox: TCheckBox
      Left = 154
      Top = 91
      Width = 92
      Height = 17
      Caption = 'Net Income'
      Checked = True
      State = cbChecked
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
      Left = 348
      Top = 410
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
      Left = 448
      Top = 56
      Width = 61
      Height = 25
      Caption = 'browse'
      TabOrder = 6
      OnClick = browseDataDirButtonClick
    end
  end
  object Panel1: TPanel
    Left = 525
    Top = 8
    Width = 550
    Height = 441
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 1
    DesignSize = (
      550
      441)
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
      Width = 253
      Height = 16
      Caption = 'Exact lines from CRA XML files (50, 94)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 525
      Top = 105
      Width = 13
      Height = 16
      Caption = 'or'
      Enabled = False
      Visible = False
    end
    object Label11: TLabel
      Left = 525
      Top = 91
      Width = 13
      Height = 16
      Caption = 'or'
      Enabled = False
      Visible = False
    end
    object xmlDataDirEditBox: TEdit
      Left = 7
      Top = 54
      Width = 456
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
      Left = 388
      Top = 408
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
      Width = 524
      Height = 253
      Anchors = [akLeft, akTop, akRight, akBottom]
      Mask = '*.d'
      TabOrder = 2
    end
    object CRABalCheckBox: TCheckBox
      Left = 434
      Top = 105
      Width = 85
      Height = 17
      Caption = 'Balance'
      Enabled = False
      TabOrder = 3
      Visible = False
    end
    object craCPPLinesCheckBox: TCheckBox
      Left = 434
      Top = 119
      Width = 80
      Height = 17
      Caption = 'CPP lines'
      Enabled = False
      TabOrder = 4
      Visible = False
    end
    object xmlDataDirButton: TButton
      Left = 469
      Top = 56
      Width = 61
      Height = 25
      Caption = 'browse'
      TabOrder = 5
      OnClick = xmlDataDirButtonClick
    end
    object ln15000checkbox: TCheckBox
      Left = 434
      Top = 91
      Width = 99
      Height = 17
      Caption = 'Line 15000'
      Enabled = False
      TabOrder = 6
      Visible = False
    end
  end
  object CancelBtn: TBitBtn
    Left = 990
    Top = 453
    Width = 86
    Height = 22
    Anchors = [akRight, akBottom]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    OnClick = CancelBtnClick
  end
  object PrintDialog1: TPrintDialog
    Left = 18
    Top = 434
  end
end
