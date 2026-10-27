object FixCnilT1_2026: TFixCnilT1_2026
  Left = 102
  Top = 61
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Fix CNIL balances prior to T1-2004 rollover'
  ClientHeight = 595
  ClientWidth = 670
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 368
    Top = 256
    Width = 225
    Height = 137
    BorderStyle = bsSingle
    TabOrder = 0
    object OKBtn: TBitBtn
      Left = 32
      Top = 20
      Width = 145
      Height = 33
      Caption = 'Check and Fix'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 32
      Top = 76
      Width = 137
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object Panel2: TPanel
    Left = 16
    Top = 168
    Width = 345
    Height = 425
    BorderStyle = bsSingle
    TabOrder = 1
    object Label1: TLabel
      Left = 83
      Top = 8
      Width = 89
      Height = 15
      Caption = 'Data Directories'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 43
      Top = 112
      Width = 146
      Height = 15
      Caption = 'Approximate no. of returns:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 192
      Top = 112
      Width = 3
      Height = 15
      Color = 8454143
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label6: TLabel
      Left = 67
      Top = 128
      Width = 96
      Height = 15
      Caption = 'Now processing: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 192
      Top = 128
      Width = 3
      Height = 15
      Color = 8454143
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label12: TLabel
      Left = 8
      Top = 32
      Width = 46
      Height = 15
      Caption = 'T1-2003'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 8
      Top = 88
      Width = 46
      Height = 15
      Caption = 'T1-2002'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 8
      Top = 56
      Width = 271
      Height = 15
      Caption = 'Were the T1-2002 tax returns in VisualTax format?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object FileListBox1: TFileListBox
      Left = 48
      Top = 152
      Width = 169
      Height = 265
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Mask = '*.d'
      ParentFont = False
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 56
      Top = 24
      Width = 256
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'C:\delphi\t1\data'
      OnExit = DataDirBoxExit
    end
    object LastYrDataDirBox: TEdit
      Left = 56
      Top = 80
      Width = 257
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = 'C:\delphi\t1\data'
      OnExit = DataDirBoxExit
    end
    object LastYearYesNo: TEdit
      Left = 288
      Top = 56
      Width = 20
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      MaxLength = 1
      ParentFont = False
      TabOrder = 3
      Text = 'Y'
      OnExit = DataDirBoxExit
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 33
    Width = 670
    Height = 128
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 678
    object Label4: TLabel
      Left = 11
      Top = 8
      Width = 569
      Height = 16
      Caption = 
        'Use this facility to recalculate the CNIL balances before rollin' +
        'g over 2003 data into 2004'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 10
      Top = 48
      Width = 353
      Height = 16
      Caption = ' were less than the Cumulative Net Investment Income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 10
      Top = 64
      Width = 584
      Height = 16
      Caption = 
        'This utility restores the proper balances so they will be availa' +
        'ble for the T1-2004 program.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 10
      Top = 32
      Width = 543
      Height = 16
      Caption = 
        'The continuity of CNIL is not correct when the Cumulative Net In' +
        'vestment Expences '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 10
      Top = 88
      Width = 664
      Height = 16
      Caption = 
        'The program checks both VisualTax T1-2002 and T1-2003 returns to' +
        ' restore proper balances in T936_2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 10
      Top = 104
      Width = 158
      Height = 16
      Caption = 'for the T1-2004 tax year.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 670
    Height = 33
    Align = alTop
    Caption = 'Check and Fix CNIL balances'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    ExplicitWidth = 678
  end
  object Panel5: TPanel
    Left = 496
    Top = 440
    Width = 49
    Height = 49
    TabOrder = 4
    Visible = False
    object Label5: TLabel
      Left = 64
      Top = 8
      Width = 78
      Height = 14
      Caption = 'Special Option'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 8
      Top = 24
      Width = 205
      Height = 42
      Caption = 
        'Change the personal supplement indicator to '#39'Yes'#39' in S13, Recalc' +
        ' and Save. All other returns will be by-passed.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object DoOnlyBox: TCheckBox
      Left = 40
      Top = 80
      Width = 137
      Height = 17
      Caption = 'Do the above'
      TabOrder = 0
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 480
    Top = 192
  end
end
