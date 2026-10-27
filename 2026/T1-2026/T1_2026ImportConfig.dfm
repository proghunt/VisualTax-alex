object ImportConfigT1_2026: TImportConfigT1_2026
  Left = 300
  Top = 102
  Caption = 'InportConfig'
  ClientHeight = 724
  ClientWidth = 755
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label6: TLabel
    Left = 8
    Top = 296
    Width = 69
    Height = 16
    Caption = 'Import Log'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 24
    Top = 83
    Width = 691
    Height = 15
    Caption = 
      'The first time you install the program  DO NOT Import item '#39'2. O' +
      'ther Options'#39' and '#39'8. Data Dictionary'#39'. Also inspect all others'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 755
    Height = 41
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label4: TLabel
      Left = 249
      Top = 8
      Width = 278
      Height = 24
      Caption = 'Import Configuration (Restore)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 755
    Height = 40
    Align = alTop
    Color = 16052193
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 0
      Width = 670
      Height = 15
      Caption = 
        'This facility allows you to import the program configuration par' +
        'ameters you used the previous year or from your last back-up'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 16
      Width = 571
      Height = 15
      Caption = 
        'Such parameters are the Preparer identification data, Fees struc' +
        'ture , Client Letters, etc. as shown below'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object GroupBox1: TGroupBox
    Left = 378
    Top = 105
    Width = 248
    Height = 190
    Caption = 'What to import...'
    TabOrder = 2
    object CheckBox1: TCheckBox
      Left = 16
      Top = 40
      Width = 223
      Height = 17
      Caption = '1. Options (Preparer data)..'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 56
      Width = 145
      Height = 17
      Caption = '2. Other options'
      Enabled = False
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 16
      Top = 72
      Width = 145
      Height = 17
      Caption = '3. Print templates'
      TabOrder = 2
    end
    object CheckBox5: TCheckBox
      Left = 16
      Top = 104
      Width = 145
      Height = 17
      Caption = '5. Fee schedule'
      TabOrder = 3
    end
    object CheckBox6: TCheckBox
      Left = 16
      Top = 120
      Width = 161
      Height = 17
      Caption = '6. Super entry files'
      TabOrder = 4
    end
    object CheckBox7: TCheckBox
      Left = 16
      Top = 138
      Width = 185
      Height = 17
      Caption = '7. Client Letter templates'
      TabOrder = 5
    end
    object CheckBox8: TCheckBox
      Left = 16
      Top = 154
      Width = 145
      Height = 17
      Caption = '8. Data dictionary'
      TabOrder = 6
      Visible = False
    end
    object CheckBox4: TCheckBox
      Left = 16
      Top = 88
      Width = 161
      Height = 17
      Caption = '4. Forms Print Sequence'
      TabOrder = 7
    end
    object CheckAllBtn: TBitBtn
      Left = 88
      Top = 16
      Width = 75
      Height = 17
      Caption = 'Check All'
      TabOrder = 8
      OnClick = CheckAllBtnClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 104
    Width = 364
    Height = 191
    Caption = 'Import from...'
    TabOrder = 3
    object Label1: TLabel
      Left = 16
      Top = 72
      Width = 145
      Height = 15
      Caption = 'Last Year'#39's Program folder'
    end
    object Label5: TLabel
      Left = 16
      Top = 134
      Width = 236
      Height = 15
      Caption = 'Folder of last configuration export (back-up)'
    end
    object ImportFromBox: TRadioGroup
      Left = 16
      Top = 16
      Width = 313
      Height = 41
      Columns = 2
      Items.Strings = (
        'Last Year'
        'Last back-up')
      TabOrder = 0
      OnExit = ImportFromBoxExit
    end
    object LastYrPgmDirBox: TEdit
      Left = 16
      Top = 88
      Width = 321
      Height = 23
      TabOrder = 1
    end
    object LastConfigDirBox: TEdit
      Left = 16
      Top = 152
      Width = 321
      Height = 23
      TabOrder = 2
    end
    object BrowseFromBtn: TBitBtn
      Left = 262
      Top = 126
      Width = 71
      Height = 22
      Hint = 'Click if directory already exists'
      Caption = 'Browse...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = BrowseFromBtnClick
    end
  end
  object ListBox1: TListBox
    Left = 8
    Top = 312
    Width = 737
    Height = 410
    Color = 15925247
    ItemHeight = 15
    TabOrder = 4
  end
  object GroupBox3: TGroupBox
    Left = 630
    Top = 105
    Width = 113
    Height = 190
    Caption = 'Actions..'
    TabOrder = 5
    object OkBtn: TBitBtn
      Left = 14
      Top = 40
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
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
      TabOrder = 0
      OnClick = OkBtnClick
    end
    object ExitBtn: TBitBtn
      Left = 14
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = ExitBtnClick
    end
  end
end
