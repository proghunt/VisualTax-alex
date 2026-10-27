object CopyMoveFrmT2_2027: TCopyMoveFrmT2_2027
  Left = 617
  Top = 397
  Caption = 'Copy'
  ClientHeight = 349
  ClientWidth = 589
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
    Left = 7
    Top = 77
    Width = 63
    Height = 15
    Caption = 'From folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Labelx: TLabel
    Left = 7
    Top = 112
    Width = 47
    Height = 15
    Caption = 'To folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object FileDescrLbl: TLabel
    Left = 112
    Top = 42
    Width = 239
    Height = 13
    AutoSize = False
    Caption = 'FileDescrLbl'
  end
  object Label2: TLabel
    Left = 7
    Top = 147
    Width = 38
    Height = 13
    Caption = 'Notes:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 77
    Top = 147
    Width = 311
    Height = 15
    Caption = '- '#39'Copy'#39' creates a duplicate copy on the destination folder.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 77
    Top = 168
    Width = 514
    Height = 15
    Caption = 
      '- '#39'Move'#39' creates a copy on the destination folder and removes th' +
      'e return from the original folder.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 77
    Top = 182
    Width = 77
    Height = 15
    Caption = 'In both cases:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 98
    Top = 196
    Width = 330
    Height = 45
    Caption = 
      'a Client Data Base will also be created (or updated) on the dest' +
      'ination folder so returns can be directly accessed by the progra' +
      'm via the destination folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 589
    Height = 36
    Align = alTop
    Caption = 'Copy or Move Return'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    ExplicitWidth = 595
  end
  object FromDirBox: TEdit
    Left = 77
    Top = 70
    Width = 386
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    Text = 'FromDirBox'
  end
  object ToDirBox: TEdit
    Left = 77
    Top = 105
    Width = 386
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = 'ToDirBox'
  end
  object CopyBtn: TBitBtn
    Left = 133
    Top = 259
    Width = 75
    Height = 25
    Caption = 'Copy'
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
    TabOrder = 2
    OnClick = CopyBtnClick
  end
  object Exit: TBitBtn
    Left = 336
    Top = 259
    Width = 75
    Height = 25
    Caption = 'Exit'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 4
    OnClick = ExitClick
  end
  object MoveBtn: TBitBtn
    Left = 238
    Top = 259
    Width = 75
    Height = 25
    Caption = 'Move'
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
    TabOrder = 3
    OnClick = MoveBtnClick
  end
  object BrowseBtn: TBitBtn
    Left = 469
    Top = 105
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
    TabOrder = 6
    OnClick = BrowseBtnClick
  end
end
