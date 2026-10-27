object SignatureT1_2026: TSignatureT1_2026
  Left = 158
  Top = 197
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Find any bad passwords'
  ClientHeight = 608
  ClientWidth = 863
  Color = clSilver
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
    Left = 0
    Top = 33
    Width = 863
    Height = 57
    Align = alTop
    BorderStyle = bsSingle
    TabOrder = 0
    ExplicitLeft = 27
    ExplicitTop = 39
    ExplicitWidth = 435
    object OKBtn: TBitBtn
      Left = 221
      Top = 16
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
      Left = 476
      Top = 16
      Width = 92
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = CancelBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 357
      Top = 20
      Width = 75
      Height = 29
      Caption = 'Print'
      TabOrder = 2
      OnClick = PrintBtnClick
    end
  end
  object Panel2: TPanel
    Left = 29
    Top = 162
    Width = 863
    Height = 499
    BorderStyle = bsSingle
    TabOrder = 1
    object Label1: TLabel
      Left = 413
      Top = 245
      Width = 44
      Height = 16
      Caption = 'Label1'
    end
    object Label3: TLabel
      Left = 34
      Top = 9
      Width = 114
      Height = 16
      Caption = 'Signature on file  '
    end
    object e_SignatureHolder: TImage
      Left = 224
      Top = 9
      Width = 274
      Height = 27
    end
    object FileListBox1: TFileListBox
      Left = 13
      Top = 31
      Width = 169
      Height = 442
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Mask = '*.d'
      ParentFont = False
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 863
    Height = 33
    Align = alTop
    Caption = 'Electronic Signature'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    ExplicitLeft = 154
    ExplicitTop = 3
    ExplicitWidth = 756
  end
  object Panel3: TPanel
    Left = 0
    Top = 90
    Width = 863
    Height = 66
    Align = alTop
    BorderStyle = bsSingle
    TabOrder = 3
    ExplicitLeft = 44
    ExplicitTop = 102
    object Label2: TLabel
      Left = 104
      Top = 3
      Width = 177
      Height = 16
      Caption = 'Client Documents Directory'
    end
    object DataDirBox: TEdit
      Left = 104
      Top = 25
      Width = 610
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'C:\delphi\t1\data'
      OnExit = DataDirBoxExit
    end
  end
end
