object DataGatherFP_2012: TDataGatherFP_2012
  Left = 96
  Top = 85
  Caption = 'Gather Data'
  ClientHeight = 418
  ClientWidth = 597
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 0
    Top = 33
    Width = 597
    Height = 320
    Align = alClient
    Color = 14933196
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'This is the first and most time consuming step in the financial ' +
        'planning process and it should be '
      
        'prepared carefully as most of the remaining steps rely on its ac' +
        'curacy.'
      ''
      
        'In this step information is gathered on the present financial po' +
        'sition of your client.'
      ''
      
        'Particular attention should be paid in the classification and re' +
        'cording of the Assets and the Liabilities. '
      ''
      
        'One should try to provide ALL the information for each Asset or ' +
        'Liability including Account numbers and '
      'Rate of Return where applicable.'
      ''
      'The objective is to arrive at:'
      '- An accurate Net Worth Statement (Balance Sheet)'
      
        '- Current Income sources and Expenses and projected ones for Ret' +
        'irement or Disability.'
      
        '  This helps determine any current or future cash flow problems ' +
        'and shortfalls.'
      '- Current tax situation (imported from the tax return)'
      '')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 597
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = '1 - Present situation'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 353
    Width = 597
    Height = 65
    Align = alBottom
    TabOrder = 2
    object NewtBtn: TBitBtn
      Left = 72
      Top = 16
      Width = 129
      Height = 33
      Caption = 'Open New Client'
      Glyph.Data = {
        96010000424D9601000000000000760000002800000018000000180000000100
        0400000000002001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        777777777777770000000000000000000077770EEEEEEEEEEEEEEEEEE077770E
        EEEEEEEEEEEEEEEEE077770EEEEEE000000EEEEEE077770EEEEEEEEEEEEEEEEE
        E077770EEEEEEEEEEEEEEEEEE077770EEEEEE000000EEEEEE077770EEEEEEEEE
        EEEEEEEEE077770EEEEEEEEEEEEEEEEEE077770EE0EEE0E00EE0E0EEE077770E
        E0EE00E0EEE0E0EEE077770EE0E0E0E00E0E0E0EE077770EE00EE0E0EE0EEE0E
        E077770EE0EEE0E00E0EEE0EE077770EEEEEEEEEEEEEEEEEE077770EEEEEEEEE
        EEEEEEEEE077770EEEEEEEEEEEEEEEEEE077770EE999EEEEEEEEEEEEE077770E
        EE99EEEEEEEEEEEEE077770EEEE9EEEEEEEEEEEEE077770EEEEEEEEEEEEEEEEE
        E077770000000000000000000077777777777777777777777777}
      TabOrder = 0
      OnClick = NewtBtnClick
    end
    object OpenBtn: TBitBtn
      Left = 248
      Top = 16
      Width = 145
      Height = 33
      Caption = 'Open Existing Client'
      Glyph.Data = {
        56020000424D5602000000000000760000002800000024000000180000000100
        040000000000E001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777770000777777777777777777777777777777777777
        0000777777000000000000000007777777777777000077777700666666666666
        666077777777777700007777770E006666666666666607777777777700007777
        770EEE0666666666666660777777777700007777770EEEE06666666666666600
        7777777700007777770EEEEE06666666666666660777777700007777770EEEEE
        E0666666666666666077777700007777770EEEEEEE0666666666666666077777
        00007777770EEEEEEEE06666666666666660777700007777770EEEEEEEEE0000
        000000000000777700007777770EEEEEEEEEEEEEEEE077777777777700007777
        770EEEEEEEEEEEEEEEE077777777777700007777770EEEEEE000000000007777
        7777777700007777770EEEEEE077777777777779999997770000777777700000
        0777777777777777999997770000777777777777777777777777777777999777
        0000700007077770007077077777777779799777000070770707777077707707
        7777777797779777000070770700007007707007777999997777777700007077
        0707707077700707777777777777777700007000070000700070770777777777
        7777777700007777777777777777777777777777777777770000}
      TabOrder = 1
      OnClick = OpenBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 438
      Top = 16
      Width = 75
      Height = 33
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 2
      OnClick = CancelBtnClick
    end
  end
end
