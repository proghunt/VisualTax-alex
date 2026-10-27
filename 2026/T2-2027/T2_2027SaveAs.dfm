object SaveAsT2_2027: TSaveAsT2_2027
  Left = 148
  Top = 152
  Caption = 'Save as...'
  ClientHeight = 614
  ClientWidth = 718
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
    Top = 395
    Width = 712
    Height = 216
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
      Left = 48
      Top = 155
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
      Left = 56
      Top = 11
      Width = 233
      Height = 121
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
      Left = 212
      Top = 155
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
      Top = 179
      Width = 473
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object RadioGroup1: TRadioGroup
      Left = 504
      Top = 17
      Width = 153
      Height = 161
      Caption = ' Actions'
      Color = clBtnFace
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 3
    end
    object SaveBtn: TBitBtn
      Left = 368
      Top = 35
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
      TabOrder = 4
      OnClick = SaveBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 368
      Top = 75
      Width = 89
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 5
      OnClick = CancelBtnClick
    end
    object HelpBtn: TBitBtn
      Left = 367
      Top = 115
      Width = 89
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 6
      OnClick = HelpBtnClick
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 36
    Width = 712
    Height = 353
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
      Left = 56
      Top = 65
      Width = 56
      Height = 13
      Caption = 'Directory:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 52
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
      Left = 124
      Top = 8
      Width = 494
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
      Left = 48
      Top = 8
      Width = 67
      Height = 13
      Caption = 'Corp. Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8404992
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 48
      Top = 179
      Width = 609
      Height = 15
      Caption = 
        'a. If the normal directory was C:/vt/T2-2024/Data just change it' +
        ' to C:/vt/T2-2024/Data1 (leave the same file name)'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label3: TLabel
      Left = 48
      Top = 158
      Width = 495
      Height = 15
      Caption = 
        'If you need to save two returns for the same corporation, and ta' +
        'x year, you have two options:'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label4: TLabel
      Left = 48
      Top = 200
      Width = 579
      Height = 15
      Caption = 
        'b. Change the file name and leave the same data directory name: ' +
        ' I.e change the file name to xxxxxxxxx.19B'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object FLNameBox: TEdit
      Left = 124
      Top = 32
      Width = 496
      Height = 21
      TabOrder = 0
    end
    object DataDirBox: TEdit
      Left = 126
      Top = 62
      Width = 494
      Height = 21
      TabOrder = 1
    end
    object SelectCurBtn: TBitBtn
      Left = 626
      Top = 35
      Width = 65
      Height = 16
      Caption = 'or Browse...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = SelectCurBtnClick
    end
    object sbStorage: TScrollBox
      Left = 16
      Top = 247
      Width = 589
      Height = 84
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 3
    end
    object FileNameFormat: TRadioGroup
      Left = 44
      Top = 104
      Width = 573
      Height = 44
      Caption = 'FILE NAME FORMAT'
      Columns = 2
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'BusinessNumber 999999999.YR'
        'CompanyName-{BusinessNumber}.YR')
      ParentFont = False
      TabOrder = 4
      OnClick = FileNameFormatClick
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 718
    Height = 33
    Align = alTop
    Caption = 'Save return'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
end
