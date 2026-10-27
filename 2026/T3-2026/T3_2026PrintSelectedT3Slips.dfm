object PrintSelectedT3SlipsT3_2026: TPrintSelectedT3SlipsT3_2026
  Left = 414
  Top = 154
  Caption = 'Print Selected T3 Slips'
  ClientHeight = 449
  ClientWidth = 473
  Color = clAqua
  Constraints.MinHeight = 250
  Constraints.MinWidth = 250
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object CheckListBox1: TCheckListBox
    Left = 0
    Top = 0
    Width = 373
    Height = 449
    OnClickCheck = CheckListBox1ClickCheck
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 15
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 373
    Top = 0
    Width = 100
    Height = 449
    Align = alRight
    TabOrder = 1
    DesignSize = (
      100
      449)
    object OKBtn: TBitBtn
      Left = 12
      Top = 367
      Width = 78
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Print'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
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
      Left = 12
      Top = 402
      Width = 78
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Close'
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
    object selectedT3SlipRecipient: TRadioGroup
      Left = 12
      Top = 6
      Width = 78
      Height = 121
      Anchors = [akTop, akRight]
      Caption = 'Recipient'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'CRA'
        'Taxpayer'
        'Trustee')
      ParentColor = False
      ParentFont = False
      TabOrder = 2
    end
  end
  object PrintDialogItem: TPrintDialog
    Left = 7
    Top = 6
  end
end
