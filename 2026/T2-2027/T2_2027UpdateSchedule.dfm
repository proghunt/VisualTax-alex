object UpdateScheduleT2_2027: TUpdateScheduleT2_2027
  Left = 149
  Top = 191
  Width = 614
  Height = 412
  Caption = 'UpdateScheduleT2_2027'
  Color = 15658734
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TBitBtn
    Left = 184
    Top = 328
    Width = 113
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = OKBtnClick
    Kind = bkOK
  end
  object CancelBtn: TBitBtn
    Left = 328
    Top = 328
    Width = 113
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 604
    Height = 33
    Align = alTop
    Caption = 'Frequency of checking updates via the Internet'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 272
    Top = 48
    Width = 321
    Height = 265
    BevelWidth = 2
    Color = 14867151
    TabOrder = 3
    object Label14: TLabel
      Left = 16
      Top = 24
      Width = 289
      Height = 64
      Caption = 
        'The program will follow this schedule to automatically check the' +
        ' VisualTax web site for any updates available. If an update is a' +
        'vailable it will prompt you to download and install the update.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label18: TLabel
      Left = 11
      Top = 104
      Width = 294
      Height = 64
      Caption = 
        'The program keeps track of the last time you checked the Interne' +
        't for any program update. Based on this schedule, it will initia' +
        'te automatically the Internet check at program start up time.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label1: TLabel
      Left = 11
      Top = 168
      Width = 289
      Height = 48
      Caption = 
        'i.e: If you set the frequency to 1 (once a day), the first time ' +
        'in the day you start the program the Internet will be checked au' +
        'tomatically.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label28: TLabel
      Left = 120
      Top = 8
      Width = 35
      Height = 16
      Caption = 'Notes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 48
    Width = 257
    Height = 265
    Color = 13948116
    TabOrder = 4
    object Label16: TLabel
      Left = 40
      Top = 48
      Width = 149
      Height = 16
      Caption = 'Check automaticaly every'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 120
      Top = 88
      Width = 28
      Height = 16
      Caption = 'days'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label23: TLabel
      Left = 28
      Top = 120
      Width = 179
      Height = 96
      Caption = 
        'If you set the frequency to 0, the program will never check the ' +
        'Internet automatically. You will need to initiate the internet c' +
        'heck manually via the Help | Check Update via the Web'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Edit1: TEdit
      Left = 80
      Top = 80
      Width = 33
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '7'
    end
  end
end
