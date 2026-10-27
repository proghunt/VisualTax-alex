object Recalc: TRecalc
  Left = 142
  Top = 150
  Width = 744
  Height = 497
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Recalculate and save all tax returns in the directory'
  Color = clGray
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
  PixelsPerInch = 120
  TextHeight = 20
  object Panel1: TPanel
    Left = 320
    Top = 240
    Width = 225
    Height = 137
    BorderStyle = bsSingle
    TabOrder = 0
    object OKBtn: TBitBtn
      Left = 21
      Top = 20
      Width = 162
      Height = 33
      Caption = 'ReCalc and Save'
      TabOrder = 0
      OnClick = OKBtnClick
      Kind = bkOK
    end
    object CancelBtn: TBitBtn
      Left = 21
      Top = 76
      Width = 162
      Height = 33
      TabOrder = 1
      OnClick = CancelBtnClick
      Kind = bkCancel
    end
  end
  object Panel2: TPanel
    Left = 24
    Top = 128
    Width = 265
    Height = 337
    BorderStyle = bsSingle
    TabOrder = 1
    object Label1: TLabel
      Left = 59
      Top = 8
      Width = 77
      Height = 15
      Caption = 'Data Directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 43
      Top = 56
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
      Top = 56
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
      Top = 72
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
      Top = 72
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
    object FileListBox1: TFileListBox
      Left = 48
      Top = 96
      Width = 169
      Height = 233
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 16
      Mask = '*.d'
      ParentFont = False
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 41
      Top = 28
      Width = 176
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'C:\delphi\t1\data'
      OnExit = DataDirBoxExit
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 33
    Width = 716
    Height = 89
    Align = alTop
    TabOrder = 2
    object Label4: TLabel
      Left = 11
      Top = 8
      Width = 643
      Height = 20
      Caption = 
        'Use this facility to re-calculate all tax returns in the data di' +
        'rectory and save them. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 10
      Top = 62
      Width = 402
      Height = 20
      Caption = 'Before proceeding you should BackUp the returns '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 10
      Top = 32
      Width = 684
      Height = 20
      Caption = 
        '*** Ensure that the data directory contains only current year'#39's ' +
        'returns (not last year'#39's)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object BackUpBtn: TBitBtn
      Left = 455
      Top = 56
      Width = 141
      Height = 25
      Caption = 'Backup the data'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BackUpBtnClick
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 716
    Height = 33
    Align = alTop
    Caption = 'Recalc and Save'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object Panel5: TPanel
    Left = 320
    Top = 144
    Width = 225
    Height = 81
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
end
