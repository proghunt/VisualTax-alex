object AskForScanKey: TAskForScanKey
  Left = 295
  Top = 259
  ClientHeight = 169
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 20
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 632
    Height = 169
    Align = alClient
    Caption = 
      'Enter the vtScan Authorization key you received when purchased t' +
      'he vtScan option'
    Color = 13353654
    ParentColor = False
    TabOrder = 0
    object Label2: TLabel
      Left = 213
      Top = 40
      Width = 29
      Height = 17
      Caption = 'Key:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 263
      Top = 40
      Width = 321
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object OKBtn: TBitBtn
      Left = 263
      Top = 101
      Width = 111
      Height = 42
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
      TabOrder = 1
      OnClick = OKBtnClick
    end
    object CancelProgramBtn: TBitBtn
      Left = 414
      Top = 101
      Width = 161
      Height = 42
      Caption = 'Cancel'
      Default = True
      NumGlyphs = 2
      TabOrder = 2
      OnClick = CancelProgramBtnClick
    end
  end
end
