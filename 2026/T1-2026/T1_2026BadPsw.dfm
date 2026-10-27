object BadPswT1_2026: TBadPswT1_2026
  Left = 158
  Top = 197
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Find any bad passwords'
  ClientHeight = 566
  ClientWidth = 910
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
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 238
    Top = 42
    Width = 666
    Height = 57
    BorderStyle = bsSingle
    TabOrder = 0
    object OKBtn: TBitBtn
      Left = 81
      Top = 13
      Width = 88
      Height = 33
      Caption = 'Find'
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
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 308
      Top = 13
      Width = 92
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 203
      Top = 14
      Width = 75
      Height = 29
      Caption = 'Print'
      TabOrder = 2
      OnClick = PrintBtnClick
    end
  end
  object Panel2: TPanel
    Left = 17
    Top = 42
    Width = 208
    Height = 526
    BorderStyle = bsSingle
    TabOrder = 1
    object Label1: TLabel
      Left = 31
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
      Left = 15
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
      Left = 164
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
      Left = 39
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
      Left = 164
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
      Left = 20
      Top = 96
      Width = 169
      Height = 416
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
      Left = 13
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
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 910
    Height = 33
    Align = alTop
    Caption = 'Find tax returns with bad passwords'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    ExplicitWidth = 918
  end
  object Memo1: TMemo
    Left = 238
    Top = 112
    Width = 666
    Height = 449
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 3
  end
end
