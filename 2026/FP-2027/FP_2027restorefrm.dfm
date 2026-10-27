object RestoreFrmFP_2012: TRestoreFrmFP_2012
  Left = 233
  Top = 239
  Width = 571
  Height = 270
  Caption = 'RestoreFrmFP_2012'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 63
    Top = 63
    Width = 67
    Height = 15
    Caption = 'Last backup'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Labelx: TLabel
    Left = 140
    Top = 119
    Width = 272
    Height = 15
    Caption = 'Restore the last back up into your current directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 77
    Top = 91
    Width = 51
    Height = 15
    Caption = 'Taken on'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 563
    Height = 36
    Align = alTop
    Caption = 'Restore from Backup'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object LastBackupDirBox: TEdit
    Left = 140
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
    TabOrder = 3
    Text = 'LastBackupDirBox'
  end
  object LastDateTakenBox: TEdit
    Left = 140
    Top = 84
    Width = 113
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    Text = 'LastDateTakenBox'
    Visible = False
  end
  object RestoreToDirBox: TEdit
    Left = 140
    Top = 140
    Width = 379
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = 'RestoreToDirBox'
  end
  object OkBtn: TBitBtn
    Left = 182
    Top = 189
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = OkBtnClick
    Kind = bkOK
  end
  object Exit: TBitBtn
    Left = 280
    Top = 189
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 2
    OnClick = ExitClick
    Kind = bkCancel
  end
end
