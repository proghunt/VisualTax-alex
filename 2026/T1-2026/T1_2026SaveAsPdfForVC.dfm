object SaveAsPdfForVCT1_2026: TSaveAsPdfForVCT1_2026
  Left = 0
  Top = 0
  Caption = 'Save As PDF'
  ClientHeight = 507
  ClientWidth = 755
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object vtShape1: TvtShape
    Left = 8
    Top = 56
    Width = 735
    Height = 105
    Brush.Color = clBtnFace
    GradientColor = clBlack
    FillDirection = vtUpFill
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Caption = ''
    CaptionX = 0
    CaptionY = 0
    CaptionCentered = True
    CaptionAngle = 0
    byUser = True
    vtPageBreak = False
    vtPageFooter = False
    vtIsPrintable = True
  end
  object vtShape3: TvtShape
    Left = 8
    Top = 166
    Width = 735
    Height = 334
    Brush.Color = clBtnFace
    GradientColor = clBlack
    FillDirection = vtUpFill
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Caption = ''
    CaptionX = 0
    CaptionY = 0
    CaptionCentered = True
    CaptionAngle = 0
    byUser = True
    vtPageBreak = False
    vtPageFooter = False
    vtIsPrintable = True
  end
  object vtShape4: TvtShape
    Left = 0
    Top = 0
    Width = 755
    Height = 50
    Align = alTop
    Brush.Color = 11301888
    GradientColor = clBlack
    FillDirection = vtUpFill
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Caption = ''
    CaptionX = 0
    CaptionY = 0
    CaptionCentered = True
    CaptionAngle = 0
    byUser = True
    vtPageBreak = False
    vtPageFooter = False
    vtIsPrintable = True
    ExplicitWidth = 762
  end
  object vtLabel42: TvtLabel
    Left = 316
    Top = 175
    Width = 117
    Height = 16
    Caption = 'E-Signature forms '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel9: TvtLabel
    Left = 16
    Top = 113
    Width = 93
    Height = 16
    Caption = 'Folder selected:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel10: TvtLabel
    Left = 14
    Top = 133
    Width = 95
    Height = 16
    Caption = 'Recipient Email:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel11: TvtLabel
    Left = 518
    Top = 133
    Width = 62
    Height = 16
    Caption = 'Salutation:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel4: TvtLabel
    Left = 291
    Top = 265
    Width = 173
    Height = 16
    Caption = 'For Client Review/Acceptance'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel16: TvtLabel
    Left = 19
    Top = 64
    Width = 287
    Height = 16
    Caption = 'For temporary needs or tests select '#39'Other Folder'#39
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel17: TvtLabel
    Left = 19
    Top = 86
    Width = 305
    Height = 16
    Caption = 'For archive purposes, select Client Documents folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel1: TvtLabel
    Left = 19
    Top = 267
    Width = 175
    Height = 80
    Caption = 
      'You can also find similar PDF creation functions when you click ' +
      'Print -> Print Current Return that requires a PDF driver called ' +
      'PdfFactory.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    Transparent = True
    Visible = False
    WordWrap = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel6: TvtLabel
    Left = 93
    Top = 15
    Width = 579
    Height = 19
    Caption = 
      'Create PDF documents of non-signed tax forms that require Client' +
      ' Signature'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object FolderName: TvtEdit
    Left = 115
    Top = 111
    Width = 614
    Height = 16
    BorderStyle = bsNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = ''
    OnExit = FolderNameExit
    vtPopData.vtPopFieldLength = 0
    vtTabOnEnter = True
    vtDataSource = vtUser
    vtTypeAhead = vtNoTypeAhead
    vtInputType = vtString
    vtBorderType = vtFull
    vtDecimalPlaces = 0
    vtLayout = vtTop
    BorderFocusColor = clBlack
    vtLVars.vtTableNum = 0
    vtLVars.vtTableColumnNum = 0
    vtLVars.vtTableRowNum = 0
  end
  object CreatePdfBtn1: TBitBtn
    Left = 118
    Top = 217
    Width = 97
    Height = 40
    Caption = 'Create PDF'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = CreatePdfBtn1Click
  end
  object CancelBtn: TBitBtn
    Left = 344
    Top = 464
    Width = 67
    Height = 25
    Caption = 'EXIT'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Kind = bkCancel
    NumGlyphs = 2
    ParentFont = False
    TabOrder = 6
  end
  object DocName1: TvtEdit
    Left = 118
    Top = 197
    Width = 520
    Height = 14
    BorderStyle = bsNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 4
    Text = ''
    vtPopData.vtPopFieldLength = 0
    vtAlignment = taCenter
    vtTabOnEnter = True
    vtDataSource = vtUser
    vtTypeAhead = vtNoTypeAhead
    vtInputType = vtString
    vtBorderType = vtFull
    vtDecimalPlaces = 0
    vtLayout = vtTop
    BorderFocusColor = clBlack
    vtLVars.vtTableNum = 0
    vtLVars.vtTableColumnNum = 0
    vtLVars.vtTableRowNum = 0
  end
  object RecipientEmail: TvtEdit
    Left = 115
    Top = 133
    Width = 397
    Height = 16
    BorderStyle = bsNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = ''
    vtPopData.vtPopFieldLength = 0
    vtTabOnEnter = True
    vtDataSource = vtUser
    vtTypeAhead = vtNoTypeAhead
    vtInputType = vtString
    vtBorderType = vtFull
    vtDecimalPlaces = 0
    vtLayout = vtTop
    BorderFocusColor = clBlack
    vtLVars.vtTableNum = 0
    vtLVars.vtTableColumnNum = 0
    vtLVars.vtTableRowNum = 0
  end
  object RecipientSalutation: TvtEdit
    Left = 584
    Top = 133
    Width = 145
    Height = 16
    BorderStyle = bsNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Text = ''
    vtPopData.vtPopFieldLength = 0
    vtTabOnEnter = True
    vtDataSource = vtUser
    vtTypeAhead = vtNoTypeAhead
    vtInputType = vtString
    vtBorderType = vtFull
    vtDecimalPlaces = 0
    vtLayout = vtTop
    BorderFocusColor = clBlack
    vtLVars.vtTableNum = 0
    vtLVars.vtTableColumnNum = 0
    vtLVars.vtTableRowNum = 0
  end
  object MapiEmailBox: TCheckBox
    Left = 544
    Top = 305
    Width = 77
    Height = 17
    Caption = 'MAPI Email'
    TabOrder = 2
    Visible = False
  end
  object FlowPanel1: TFlowPanel
    Left = 598
    Top = 328
    Width = 90
    Height = 129
    Caption = 'FlowPanel1'
    TabOrder = 7
    Visible = False
    object vtShape2: TvtShape
      Left = 1
      Top = 1
      Width = 379
      Height = 83
      Brush.Color = clBtnFace
      GradientColor = clBlack
      FillDirection = vtUpFill
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Caption = ''
      CaptionX = 0
      CaptionY = 0
      CaptionCentered = True
      CaptionAngle = 0
      byUser = True
      vtPageBreak = False
      vtPageFooter = False
      vtIsPrintable = True
    end
    object vtLabel5: TvtLabel
      Left = 1
      Top = 84
      Width = 65
      Height = 16
      Caption = 'Tax return'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object vtLabel2: TvtLabel
      Left = 1
      Top = 100
      Width = 92
      Height = 16
      Caption = 'Selected Forms'
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
      Left = 1
      Top = 116
      Width = 62
      Height = 12
      Caption = 'Or double click'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object vtLabel12: TvtLabel
      Left = 1
      Top = 128
      Width = 60
      Height = 16
      Caption = 'All Forms '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object vtLabel13: TvtLabel
      Left = 1
      Top = 144
      Width = 77
      Height = 12
      Caption = 'to select/de-select'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object vtLabel20: TvtLabel
      Left = 1
      Top = 156
      Width = 113
      Height = 16
      Caption = 'All applicable forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object ListBox2: TListBox
      Left = 1
      Top = 172
      Width = 133
      Height = 109
      Hint = 'Double click to select one'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnDblClick = ListBox2DblClick
    end
    object CreatePdfBtn2: TBitBtn
      Left = 1
      Top = 281
      Width = 118
      Height = 25
      Caption = 'Create PDF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = CreatePdfBtn2Click
    end
    object DocName2: TvtEdit
      Left = 1
      Top = 306
      Width = 323
      Height = 14
      BorderStyle = bsNone
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
      Text = ''
      vtPopData.vtPopFieldLength = 0
      vtAlignment = taCenter
      vtTabOnEnter = True
      vtDataSource = vtUser
      vtTypeAhead = vtNoTypeAhead
      vtInputType = vtString
      vtBorderType = vtFull
      vtDecimalPlaces = 0
      vtLayout = vtTop
      BorderFocusColor = clBlack
      vtLVars.vtTableNum = 0
      vtLVars.vtTableColumnNum = 0
      vtLVars.vtTableRowNum = 0
    end
    object ListBox3: TListBox
      Left = 1
      Top = 320
      Width = 133
      Height = 128
      Hint = 'Double click to remove 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnDblClick = ListBox3DblClick
    end
    object EmailPdfBtn2: TButton
      Left = 1
      Top = 448
      Width = 70
      Height = 25
      Caption = 'Email PDF...'
      TabOrder = 3
    end
    object AddAllBtn: TBitBtn
      Left = 1
      Top = 473
      Width = 66
      Height = 41
      Hint = 'Select All forms'
      Caption = 'Select All '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        7E010000424D7E01000000000000760000002800000014000000160000000100
        0400000000000801000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888800008888888888888888888800008888888888088888888800008888
        8888880088888888000088888888880C08888888000088888888880CC0888888
        000088888888880CCC088888000088880000000CCCC08888000088880CCCCCCC
        CCCC0888000088880CCCCCCCCCCCC088000088880CCCCCCCCCCCCC0800008888
        0CCCCCCCCCCCC088000088880CCCCCCCCCCC0888000088880000000CCCC08888
        000088888888880CCC088888000088888888880CC0888888000088888888880C
        0888888800008888888888008888888800008888888888088888888800008888
        8888888888888888000088888888888888888888000088888888888888888888
        0000}
      Layout = blGlyphBottom
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Spacing = 1
      TabOrder = 4
      OnClick = SelectAllBtnClick
    end
    object RemoveAllbtn: TBitBtn
      Left = 1
      Top = 514
      Width = 66
      Height = 42
      Hint = 'emove All forms'
      Caption = 'De-select All'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        7E010000424D7E01000000000000760000002800000014000000160000000100
        0400000000000801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777700007777777777777777777700007777777777077777777700007777
        77777007777777770000777777770C0777777777000077777770CC0777777777
        00007777770CCC07777777770000777770CCCC0000000777000077770CCCCCCC
        CCCC077700007770CCCCCCCCCCCC07770000770CCCCCCCCCCCCC077700007770
        CCCCCCCCCCCC0777000077770CCCCCCCCCCC07770000777770CCCC0000000777
        00007777770CCC0777777777000077777770CC07777777770000777777770C07
        7777777700007777777770077777777700007777777777077777777700007777
        7777777777777777000077777777777777777777000077777777777777777777
        0000}
      Layout = blGlyphBottom
      ParentFont = False
      Spacing = 1
      TabOrder = 5
      OnClick = RemoveAllBtnClick
    end
  end
  object DirGroup: TRadioGroup
    Left = 343
    Top = 67
    Width = 386
    Height = 35
    Caption = 'Folder where documents will be saved'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Client Documents folder'
      'Other folder  (enter below)')
    ParentFont = False
    TabOrder = 8
    OnClick = DirGroupClick
  end
  object ShowPDFBtn: TBitBtn
    Left = 221
    Top = 217
    Width = 96
    Height = 40
    Caption = 'Show PDF'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = ShowPDFBtnClick
  end
  object vtCourierPdfBtn: TButton
    Left = 19
    Top = 412
    Width = 162
    Height = 25
    Caption = 'Email PDF with vtCourier'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    Visible = False
    OnClick = vtCourierPdfBtnClick
  end
  object vtSignPDFBtn: TButton
    Left = 19
    Top = 381
    Width = 153
    Height = 25
    Caption = 'Send PDF to vtSignPDF'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    Visible = False
    OnClick = vtSignPDFBtnClick
  end
  object rbUpload: TRadioButton
    Left = 331
    Top = 219
    Width = 217
    Height = 17
    Caption = 'Upload to server for pick up by recipient'
    Checked = True
    TabOrder = 12
    TabStop = True
    OnClick = rbUploadClick
  end
  object rbSend: TRadioButton
    Left = 331
    Top = 242
    Width = 113
    Height = 17
    Caption = 'Send by vtCourier'
    TabOrder = 13
    OnClick = rbUploadClick
  end
  object btnAction: TButton
    Left = 567
    Top = 217
    Width = 71
    Height = 40
    Caption = 'Upload'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 14
    OnClick = btnActionClick
  end
  object ListBox1: TCheckListBox
    Left = 302
    Top = 287
    Width = 151
    Height = 141
    ItemHeight = 13
    TabOrder = 24
  end
  object SelectAllBtn: TBitBtn
    Left = 302
    Top = 429
    Width = 75
    Height = 25
    Caption = 'Select All'
    TabOrder = 25
    OnClick = SelectAllBtnClick
  end
  object DeselectAllBtn: TBitBtn
    Left = 378
    Top = 429
    Width = 75
    Height = 25
    Caption = 'Deselect All'
    TabOrder = 26
    OnClick = SelectAllBtnClick
  end
  object PrintDialog1: TPrintDialog
    Left = 639
    Top = 244
  end
end
