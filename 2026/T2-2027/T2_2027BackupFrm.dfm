object BackupFrmT2_2027: TBackupFrmT2_2027
  Left = 215
  Top = 224
  Caption = 'Backup'
  ClientHeight = 261
  ClientWidth = 715
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 95
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
    Left = 95
    Top = 126
    Width = 69
    Height = 15
    Caption = 'New Backup'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 109
    Top = 91
    Width = 50
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
  object Label2: TLabel
    Left = 81
    Top = 154
    Width = 29
    Height = 15
    Caption = 'Note:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 123
    Top = 154
    Width = 463
    Height = 13
    Caption = 
      'You can override the New Backup Folder if you like and re-use an' +
      ' existing backup folder (recycle) '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 123
    Top = 168
    Width = 440
    Height = 13
    Caption = 
      'For example, you can specify Backup01 if you are prompted for Ba' +
      'ckup05 as a new backup. '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 123
    Top = 182
    Width = 427
    Height = 13
    Caption = 
      'It is recommended that you keep at least 3 backup folders (01, 0' +
      '2, 03). Then recycle them.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 124
    Top = 209
    Width = 348
    Height = 13
    Caption = 
      'You camn also use any meaningful name such as .../BackUp-2020-Ma' +
      'y 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 715
    Height = 36
    Align = alTop
    Caption = 'Data Backup'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    ExplicitWidth = 622
  end
  object LastBackupDirBox: TEdit
    Left = 172
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
    TabOrder = 4
    Text = 'LastBackupDirBox'
  end
  object LastDateTakenBox: TEdit
    Left = 172
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
    TabOrder = 3
    Text = 'LastDateTakenBox'
    Visible = False
  end
  object NewBackupDirBox: TEdit
    Left = 172
    Top = 119
    Width = 379
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = 'NewBackUpDirBox'
  end
  object OkBtn: TBitBtn
    Left = 270
    Top = 228
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object Exit: TBitBtn
    Left = 368
    Top = 228
    Width = 75
    Height = 25
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
    OnClick = ExitClick
  end
end
