object ListBalT1_2026: TListBalT1_2026
  Left = 192
  Top = 129
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'List Balances'
  ClientHeight = 591
  ClientWidth = 1152
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
    1152
    591)
  PixelsPerInch = 96
  TextHeight = 16
  object Panel2: TPanel
    Left = 7
    Top = 14
    Width = 1135
    Height = 296
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      1135
      296)
    object Label1: TLabel
      Left = 7
      Top = 43
      Width = 93
      Height = 16
      Caption = 'Data Directory'
    end
    object Label2: TLabel
      Left = 11
      Top = 113
      Width = 175
      Height = 16
      Caption = 'Approximate no. of returns:'
    end
    object Label3: TLabel
      Left = 192
      Top = 64
      Width = 4
      Height = 16
    end
    object Label6: TLabel
      Left = 11
      Top = 129
      Width = 112
      Height = 16
      Caption = 'Now processing: '
    end
    object Label7: TLabel
      Left = 192
      Top = 80
      Width = 4
      Height = 16
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
    object Label11: TLabel
      Left = 11
      Top = 248
      Width = 120
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'File Save Location'
      ExplicitTop = 251
    end
    object FileListBox1: TFileListBox
      Left = 7
      Top = 147
      Width = 1118
      Height = 96
      Anchors = [akLeft, akTop, akRight, akBottom]
      Mask = '*.d'
      TabOrder = 0
      ExplicitWidth = 1056
      ExplicitHeight = 99
    end
    object DataDirBox: TEdit
      Left = 5
      Top = 63
      Width = 703
      Height = 22
      TabOrder = 1
      Text = 'C:\delphi\t1\data'
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
      Left = 961
      Top = 264
      Width = 154
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = 'Print Listing'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 5
      OnClick = OKBtnClick
      ExplicitLeft = 809
      ExplicitTop = 267
    end
    object vtDataSaveEditBox: TEdit
      Left = 12
      Top = 265
      Width = 787
      Height = 24
      Anchors = [akLeft, akBottom]
      TabOrder = 6
      OnExit = DataDirBoxExit
      ExplicitTop = 268
    end
  end
  object Panel1: TPanel
    Left = 7
    Top = 315
    Width = 1135
    Height = 246
    Anchors = [akRight, akBottom]
    TabOrder = 1
    DesignSize = (
      1135
      246)
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
      Left = 11
      Top = 188
      Width = 120
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = 'File Save Location'
    end
    object xmlDataDirEditBox: TEdit
      Left = 12
      Top = 54
      Width = 689
      Height = 24
      TabOrder = 0
      Text = 
        'C:\Users\XPSWINDOWSPRO\Documents\VTdocs\CRASpecs\T1-2025\T1-2025' +
        '_TESTCASES'
      OnExit = DataDirBoxExit
    end
    object exrtractfromCraXMLBTN: TBitBtn
      Left = 966
      Top = 206
      Width = 154
      Height = 24
      Anchors = [akRight, akBottom]
      Caption = 'extract'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      OnClick = exrtractfromCraXMLBTNClick
      ExplicitLeft = 968
    end
    object FileListBox2: TFileListBox
      Left = 7
      Top = 84
      Width = 1118
      Height = 95
      Anchors = [akLeft, akTop, akRight, akBottom]
      Mask = '*.d'
      TabOrder = 2
      ExplicitWidth = 1055
      ExplicitHeight = 99
    end
    object xmlDataSaveEditBox: TEdit
      Left = 12
      Top = 208
      Width = 787
      Height = 24
      Anchors = [akLeft, akBottom]
      TabOrder = 3
      OnExit = DataDirBoxExit
    end
  end
  object CancelBtn: TBitBtn
    Left = 1062
    Top = 566
    Width = 86
    Height = 22
    Anchors = [akRight, akBottom]
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    OnClick = CancelBtnClick
    ExplicitLeft = 884
    ExplicitTop = 558
  end
  object PrintDialog1: TPrintDialog
    Left = 585
    Top = 21
  end
end
