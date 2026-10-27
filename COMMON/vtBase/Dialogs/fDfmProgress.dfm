object DfmProgress: TDfmProgress
  Left = 77
  Top = 112
  Width = 453
  Height = 416
  Caption = 'DFM File Analysis in Progress'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    445
    364)
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 5
    Top = 10
    Width = 40
    Height = 16
    Caption = 'Action:'
  end
  object lbAction: TLabel
    Left = 74
    Top = 10
    Width = 454
    Height = 21
    AutoSize = False
    Caption = '...'
  end
  object Label3: TLabel
    Left = 5
    Top = 39
    Width = 25
    Height = 16
    Caption = 'File:'
  end
  object lbFile: TLabel
    Left = 74
    Top = 39
    Width = 454
    Height = 21
    AutoSize = False
    Caption = '...'
  end
  object Label5: TLabel
    Left = 5
    Top = 84
    Width = 62
    Height = 16
    Caption = 'Exception:'
  end
  object lbExcept: TLabel
    Left = 74
    Top = 84
    Width = 454
    Height = 21
    AutoSize = False
    Caption = '...'
  end
  object buCancel: TBitBtn
    Left = 364
    Top = 133
    Width = 93
    Height = 36
    TabOrder = 0
    OnClick = buCancelClick
    Kind = bkCancel
  end
  object buIgnore: TBitBtn
    Left = 231
    Top = 133
    Width = 120
    Height = 36
    Caption = '&Ignore All'
    Default = True
    ModalResult = 5
    TabOrder = 1
    OnClick = buIgnoreClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00344446333334
      44433333FFFF333333FFFF33000033AAA43333332A4333338833F33333883F33
      00003332A46333332A4333333383F33333383F3300003332A2433336A6633333
      33833F333383F33300003333AA463362A433333333383F333833F33300003333
      6AA4462A46333333333833FF833F33330000333332AA22246333333333338333
      33F3333300003333336AAA22646333333333383333F8FF33000033444466AA43
      6A43333338FFF8833F383F330000336AA246A2436A43333338833F833F383F33
      000033336A24AA442A433333333833F33FF83F330000333333A2AA2AA4333333
      333383333333F3330000333333322AAA4333333333333833333F333300003333
      333322A4333333333333338333F333330000333333344A433333333333333338
      3F333333000033333336A24333333333333333833F333333000033333336AA43
      33333333333333833F3333330000333333336663333333333333333888333333
      0000}
    NumGlyphs = 2
  end
  object buOK: TBitBtn
    Left = 10
    Top = 133
    Width = 92
    Height = 36
    TabOrder = 2
    OnClick = buOKClick
    Kind = bkOK
  end
  object lbMsg: TListBox
    Left = 10
    Top = 182
    Width = 528
    Height = 289
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 16
    TabOrder = 3
  end
  object buIgnore1: TBitBtn
    Left = 123
    Top = 133
    Width = 92
    Height = 36
    TabOrder = 4
    OnClick = buIgnore1Click
    Kind = bkIgnore
  end
end
