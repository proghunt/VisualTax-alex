object CloudRebuildT1_2026: TCloudRebuildT1_2026
  Left = 329
  Top = 196
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Rebuild Client Data Base'
  ClientHeight = 547
  ClientWidth = 912
  Color = 14537409
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 11
    Top = 1
    Width = 579
    Height = 16
    Caption = 
      'Use this facility to re-generate a client data base (Client Book' +
      ') from tax return files in Cloud directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 11
    Top = 24
    Width = 134
    Height = 16
    Caption = 'Cloud Data Directory'
  end
  object Panel1: TPanel
    Left = 209
    Top = 483
    Width = 296
    Height = 50
    BorderStyle = bsSingle
    TabOrder = 0
    object OKBtn: TBitBtn
      Left = 10
      Top = 5
      Width = 159
      Height = 33
      Caption = 'Rebuild the database'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
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
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 191
      Top = 5
      Width = 81
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 56
    Width = 443
    Height = 407
    BorderStyle = bsSingle
    TabOrder = 1
    object Label3: TLabel
      Left = 175
      Top = 8
      Width = 4
      Height = 16
      Color = clWhite
      ParentColor = False
    end
    object Label7: TLabel
      Left = 112
      Top = 24
      Width = 323
      Height = 16
      AutoSize = False
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object Label8: TLabel
      Left = 11
      Top = 8
      Width = 157
      Height = 16
      Caption = 'Approximate no. of returns:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 11
      Top = 24
      Width = 100
      Height = 16
      Caption = 'Now processing: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbFiles: TListBox
      Left = 47
      Top = 46
      Width = 258
      Height = 347
      TabOrder = 0
    end
  end
  object ListBox1: TListBox
    Left = 462
    Top = 84
    Width = 400
    Height = 379
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
  end
  object Panel3: TPanel
    Left = 462
    Top = 56
    Width = 400
    Height = 29
    Caption = 'Progress'
    TabOrder = 3
  end
  object DataDirBox: TEdit
    Left = 168
    Top = 21
    Width = 470
    Height = 24
    TabOrder = 4
    OnExit = DataDirBoxExit
  end
end
