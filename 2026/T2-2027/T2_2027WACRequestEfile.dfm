object WACRequestEfileT2_2027: TWACRequestEfileT2_2027
  Left = 366
  Top = 183
  Hint = 'Double click to select'
  BorderStyle = bsToolWindow
  Caption = 'WAC Request'
  ClientHeight = 583
  ClientWidth = 681
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label7: TLabel
    Left = 18
    Top = 463
    Width = 29
    Height = 16
    Caption = 'URL:'
  end
  object vtLabel1: TvtLabel
    Left = 16
    Top = 67
    Width = 642
    Height = 16
    Caption = 
      'If you do not have a T1 or T2 Efiler number, you can click this ' +
      'button to automatically receive a WAC from CRA.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel2: TvtLabel
    Left = 16
    Top = 87
    Width = 609
    Height = 16
    Caption = 
      'In order to Efile, enter the WAC number on the top of page 1 of ' +
      'the T2 form and then Efile the T2 normally.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel3: TvtLabel
    Left = 17
    Top = 144
    Width = 223
    Height = 22
    AutoSize = False
    Caption = 'Business Number (BN) *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel4: TvtLabel
    Left = 17
    Top = 168
    Width = 223
    Height = 22
    AutoSize = False
    Caption = 'Tax Year-End (yyyy/mm/dd) *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel5: TvtLabel
    Left = 17
    Top = 193
    Width = 223
    Height = 22
    AutoSize = False
    Caption = 'Tax Year-End Time (hh:mm)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel6: TvtLabel
    Left = 17
    Top = 217
    Width = 223
    Height = 22
    AutoSize = False
    Caption = 'Incorporation Date (yyyy/mm/dd) *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel7: TvtLabel
    Left = 17
    Top = 242
    Width = 223
    Height = 22
    AutoSize = False
    Caption = 'Postal Code / Zip Code *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel8: TvtLabel
    Left = 17
    Top = 266
    Width = 223
    Height = 22
    AutoSize = False
    Caption = 'Requester Last Name *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel9: TvtLabel
    Left = 17
    Top = 291
    Width = 223
    Height = 22
    AutoSize = False
    Caption = 'Requester First Name *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel10: TvtLabel
    Left = 17
    Top = 316
    Width = 223
    Height = 22
    AutoSize = False
    Caption = 'Requester Job Title *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel11: TvtLabel
    Left = 17
    Top = 115
    Width = 464
    Height = 16
    Caption = 
      '* Mandatory (almost all data are mandatory and enter Dates with ' +
      'slashes)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel12: TvtLabel
    Left = 29
    Top = 365
    Width = 211
    Height = 22
    AutoSize = False
    Caption = 'Date Issued (yyyy/mm/dd) *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel13: TvtLabel
    Left = 29
    Top = 393
    Width = 211
    Height = 22
    AutoSize = False
    Caption = 'Part I Tax  (enter 0.00 if zero) * '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel14: TvtLabel
    Left = 29
    Top = 421
    Width = 211
    Height = 22
    AutoSize = False
    Caption = 'Or Total Federal Tax  (Optional)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblUnderline
  end
  object vtLabel15: TvtLabel
    Left = 18
    Top = 344
    Width = 529
    Height = 22
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = 
      'Your last NOA related data. If not available, call CRA to give y' +
      'ou a WAC number.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object EfileType: TPanel
    Left = 0
    Top = 0
    Width = 681
    Height = 49
    Hint = 'Click to change tax year and rates'
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '   WAC Request  (Web Access Code)'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object SubmitBtn: TBitBtn
    Left = 210
    Top = 511
    Width = 135
    Height = 64
    Caption = 'Connect/Transmit'
    Glyph.Data = {
      FE080000424DFE08000000000000360400002800000022000000220000000100
      080000000000C804000000000000000000000001000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
      A600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
      0707070707070707070707070707070707070707070707070707070700000707
      070707070707070707070707FCFCFCFCFCFC0707070707070707070707070707
      00000707070707070707070707FCFCFCFCFCFCFCFCFCFCFCFC07070707070707
      070707070000070707070707070707FCFCFCFCFCFCFCFCFC0707FCFCFCFCFC07
      070707070707070700000707070707070707FCFCFCFCFCFCFCFCFCFC07FAFCFC
      FCFCFCFC07070707070707070000070707070707FCFCFCFCFCFCFCFCFCFCFCFC
      FCFA0707FCFCFCFCFCFC07070707070700000707070707FCFCFCFCFCFCFCFCFC
      FCFCFCFCFCFAFAFA07FCFCFCFCFCFC070707070700000707070707FCFCFCFCFC
      FCFCFCFCFCFCFCFCFCFCFAFAFA07FCFCFCFCFC0707070707000007070707FCFC
      FCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFA07FCFCFCFCFC0707070700000707
      07FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFA07FCFCFCFCFC070707
      0000070707FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC07FAFAFAFAFAFA07FCFC
      FC07070700000707FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC07FAFAFAFAFA
      FA07FCFC07FC070700000707FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFA
      FAFAFAFAFAFAFCFC07FC070700000707FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
      07FAFAFAFAFAFAFAFAFAFCFC07FA0707000007FCFCFCFCFCFCFCFCFCFCFCFCFC
      FCFCFCFAFAFAFAFAFAFAFAFAFAFAFCFC07FAFC07000007FCFCFCFCFCFCFCFCFC
      FCFCFCFCFCFCFCFAFAFAFAFAFAFAFAFAFA07FCFC07FA0707000007FCFCFCFCFC
      FCFCFCFCFCFCFCFCFCFCFC07FAFAFAFAFAFAFA07FCFCFCFC07FAFA07000007FC
      FCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFAFAFAFCFCFCFCFCFC07FAFA07
      000007FCFCFCFCFCFCFCFCFCFCFCFCFCFCFC07FA0707FAFAFA07FCFCFCFCFCFC
      07FAFC07000007FCFCFCFCFCFCFCFCFCFCFCFCFCFAFAFAFAFCFCFAFA07FCFCFC
      FCFCFCFCFAFAFC0700000707FC0707FCFCFCFCFCFC0707FAFAFAFA07FCFCFCFC
      FCFCFCFCFCFCFCFCFA07070700000707FCFAFAFCFCFCFCFCFCFAFAFAFA07FAFC
      FAFA07FCFCFCFCFCFCFCFCFCFAFC070700000707FCFCFCFCFCFCFCFCFA07FAFA
      07FCFCFC07070707FCFCFCFCFCFCFCFA07FC07070000070707FCFCFCFCFCFC07
      FAFAFAFAFA0707FA07FCFCFCFCFCFCFCFCFC0707FC0707070000070707FCFCFC
      FCFCFCFAFAFAFAFAFAFAFAFA07FCFCFCFCFCFCFCFCFC07FCFC07070700000707
      0707FCFCFCFCFCFAFAFAFAFAFAFAFAFAFAFA07FCFCFCFCFCFCFCFCFC07070707
      00000707070707FCFCFCFCFCFAFAFAFAFAFA07FAFAFAFAFCFCFCFCFCFCFCFC07
      0707070700000707070707FC070707FCFAFAFAFAFAFA07FAFAFAFAFA07FCFCFC
      FCFCFC07070707070000070707070707FC0707FAFAFAFAFAFAFAFAFAFA070707
      07FA07FCFCFC07070707070700000707070707070707FCFC07FAFAFAFAFAFAFA
      07FC07FAFAFAFCFC07070707070707070000070707070707070707FCFCFC0707
      0707070707FA070707FCFC070707070707070707000007070707070707070707
      07FCFCFCFCFCFCFCFCFCFCFCFC07070707070707070707070000070707070707
      0707070707070707FCFCFCFCFCFC070707070707070707070707070700000707
      0707070707070707070707070707070707070707070707070707070707070707
      0000}
    Layout = blGlyphTop
    TabOrder = 2
    OnClick = SubmitBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 371
    Top = 511
    Width = 112
    Height = 64
    Kind = bkCancel
    Layout = blGlyphTop
    NumGlyphs = 2
    TabOrder = 3
  end
  object ShowXMLBtn: TBitBtn
    Left = 210
    Top = 449
    Width = 205
    Height = 22
    Caption = 'Show XML data to be submitted'
    TabOrder = 1
    OnClick = ShowXMLBtnClick
  end
  object TestOrProductionGroup: TRadioGroup
    Left = 18
    Top = 511
    Width = 128
    Height = 64
    Caption = 'Test Or Production'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Production (users)'
      'Test (developer).')
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    OnClick = TestOrProductionGroupClick
  end
  object UrlBox: TEdit
    Left = 18
    Top = 477
    Width = 655
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object testResponse: TBitBtn
    Left = 532
    Top = 511
    Width = 41
    Height = 64
    Cancel = True
    Caption = 'Test Response'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Layout = blGlyphTop
    ModalResult = 2
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 7
    Visible = False
    OnClick = testResponseClick
  end
  object wacR_BNnumber: TEdit
    Left = 246
    Top = 141
    Width = 400
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object wacR_TaxYearEnd: TEdit
    Left = 246
    Top = 165
    Width = 400
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object wacR_TaxEndTime: TEdit
    Left = 246
    Top = 190
    Width = 400
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
  end
  object wacR_IncorporationDate: TEdit
    Left = 246
    Top = 214
    Width = 400
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnExit = wacR_IncorporationDateExit
  end
  object wacR_Postal: TEdit
    Left = 246
    Top = 239
    Width = 400
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
  end
  object wacR_RequesterLastName: TEdit
    Left = 246
    Top = 263
    Width = 400
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
  end
  object wacR_RequesterFirstName: TEdit
    Left = 246
    Top = 288
    Width = 400
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
  end
  object wacR_RequesterJobTitle: TEdit
    Left = 246
    Top = 313
    Width = 400
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
  end
  object eDateIssued: TEdit
    Left = 246
    Top = 362
    Width = 400
    Height = 24
    Hint = 'The issue date of the most recent Notice of Assessment.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
  end
  object ePartITax: TEdit
    Left = 246
    Top = 391
    Width = 400
    Height = 24
    Hint = 
      'The amount of Part I Tax on the most recent Notice of Assessment' +
      '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 16
  end
  object eTotalFederalTax: TEdit
    Left = 246
    Top = 419
    Width = 400
    Height = 24
    Hint = 'The total federal tax on the most recent Notice of Assessment.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 17
  end
  object testResponseOpenDialog: TOpenDialog
    Left = 606
    Top = 536
  end
end
