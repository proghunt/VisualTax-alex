object BackupFrmT1_2026: TBackupFrmT1_2026
  Left = 206
  Top = 240
  Caption = 'Backup'
  ClientHeight = 573
  ClientWidth = 747
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    747
    573)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 68
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
    Left = 8
    Top = 103
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
    Left = 470
    Top = 39
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
  object Label7: TLabel
    Left = 8
    Top = 42
    Width = 253
    Height = 19
    Caption = 'Backup all tax data to Local Drive'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 8
    Top = 321
    Width = 142
    Height = 19
    Caption = 'Backup to vtCloud'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 338
    Width = 638
    Height = 13
    Caption = 
      'This will replace all existing tax returns currently on your vtC' +
      'loud directory, as specified in Configure -> General Options -> ' +
      'DropBoxhelper'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 9
    Top = 360
    Width = 98
    Height = 15
    Caption = 'User Login Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 8
    Top = 386
    Width = 185
    Height = 15
    Caption = 'Local data folder being backed up'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label11: TLabel
    Left = 9
    Top = 412
    Width = 146
    Height = 15
    Caption = 'Cloud Data Folder affected'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object ProgressInfoLabel: TLabel
    Left = 8
    Top = 492
    Width = 561
    Height = 15
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label12: TLabel
    Left = 199
    Top = 473
    Width = 404
    Height = 13
    Caption = 
      'If you Cancel the backup after you start it, the remaining retur' +
      'ns will not be backedUp.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 249
    Top = 142
    Width = 336
    Height = 13
    Caption = 'You can use your own names such as C:\VT\T1-2023\BackUp\Feb20'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label14: TLabel
    Left = 249
    Top = 161
    Width = 437
    Height = 13
    Caption = 
      'For a better Backup, use a USB flash drive (stick) and change th' +
      'e drive letter  i.e  from C to F'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 317
    Top = 190
    Width = 98
    Height = 13
    Caption = 'New BackUp folders'
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
    Width = 747
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
  end
  object LastBackupDirBox: TEdit
    Left = 85
    Top = 65
    Width = 626
    Height = 23
    Anchors = [akLeft, akTop, akRight]
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
    Left = 533
    Top = 36
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
    Left = 85
    Top = 100
    Width = 626
    Height = 23
    Anchors = [akLeft, akTop, akRight]
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
    Left = 30
    Top = 143
    Width = 199
    Height = 31
    Caption = 'Backup All tax returns'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 1
    OnClick = OkBtnClick
  end
  object Exit: TBitBtn
    Left = 269
    Top = 536
    Width = 146
    Height = 25
    Caption = 'EXIT'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 2
    OnClick = ExitClick
  end
  object BackupToCloudBtn: TBitBtn
    Left = 44
    Top = 462
    Width = 149
    Height = 31
    Caption = 'Backup To vtCloud'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = BackupToCloudBtnClick
  end
  object UserLoginNameBox: TEdit
    Left = 199
    Top = 357
    Width = 539
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 7
    Text = 'UserLoginNameBox'
  end
  object LocalDataFolder: TEdit
    Left = 199
    Top = 383
    Width = 539
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
    Text = 'LocalDataFolder'
  end
  object CloudDataFolder: TEdit
    Left = 199
    Top = 409
    Width = 539
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 9
    Text = 'CloudDataFolder'
  end
  object BackupProgressBar: TProgressBar
    Left = 8
    Top = 513
    Width = 729
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 10
  end
  object rbFast: TRadioButton
    Left = 609
    Top = 438
    Width = 33
    Height = 17
    Caption = 'Fast (file names with no changes)'
    TabOrder = 11
    Visible = False
  end
  object rbSlow: TRadioButton
    Left = 9
    Top = 439
    Width = 573
    Height = 17
    Caption = 
      'Files are renamed to LastName-SIN during backup for readability ' +
      'in Dropbox listing (allow 3 seconds per return)'
    Checked = True
    TabOrder = 12
    TabStop = True
  end
  object BackUpClientDocs: TBitBtn
    Left = 30
    Top = 196
    Width = 272
    Height = 32
    Caption = 'BackUp All Client Documents'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 13
    OnClick = BackUpClientDocsClick
  end
  object BackUpPermDocs: TBitBtn
    Left = 30
    Top = 234
    Width = 272
    Height = 32
    Caption = 'BackUp All Permanent Client Documents'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 14
    OnClick = BackUpPermDocsClick
  end
  object NewClientDocsDirBox: TEdit
    Left = 317
    Top = 209
    Width = 394
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 15
    Text = 'NewClientDocsDirBox'
  end
  object NewPermanentDocsDirBox: TEdit
    Left = 317
    Top = 238
    Width = 394
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 16
    Text = 'NewPermanentDocsDir'
  end
  object VerifyBtn: TButton
    Left = 322
    Top = 272
    Width = 57
    Height = 25
    Caption = 'Verify/Review the backup Folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 17
    Visible = False
    OnClick = VerifyBtnClick
  end
end
