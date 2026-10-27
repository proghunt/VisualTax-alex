object SaveAsPdfT2_2027: TSaveAsPdfT2_2027
  Left = 0
  Top = 0
  Caption = 'Save As PDF'
  ClientHeight = 588
  ClientWidth = 734
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
  object vtShape4: TvtShape
    Left = 0
    Top = 0
    Width = 734
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
    ExplicitTop = 9
    ExplicitWidth = 336
  end
  object vtLabel37: TvtLabel
    Left = 89
    Top = 3
    Width = 576
    Height = 19
    Caption = 
      'Create PDF documents of the forms auto-signed by the vtSignature' +
      ' method '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel6: TvtLabel
    Left = 139
    Top = 28
    Width = 457
    Height = 19
    Caption = 'Or PDF of non-signed tax forms that require Client Signature'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object Panel2: TPanel
    Left = 0
    Top = 183
    Width = 729
    Height = 384
    Caption = 'Panel2'
    TabOrder = 0
    object vtLabel42: TvtLabel
      Left = 336
      Top = 20
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
    object vtLabel4: TvtLabel
      Left = 306
      Top = 48
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
    object ListBox1: TListBox
      Left = 333
      Top = 182
      Width = 146
      Height = 131
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Sorted = True
      TabOrder = 0
    end
    object CreatePdfBtn1: TBitBtn
      Left = 336
      Top = 112
      Width = 116
      Height = 25
      Caption = 'Create PDF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = CreatePdfBtn1Click
    end
    object EmailPdfBtn1: TButton
      Left = 337
      Top = 143
      Width = 116
      Height = 25
      Caption = 'Email PDF to client...'
      TabOrder = 3
      OnClick = EmailPdfBtn1Click
    end
    object DocName1: TvtEdit
      Left = 284
      Top = 70
      Width = 225
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
      TabOrder = 5
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
    object CancelBtn: TBitBtn
      Left = 372
      Top = 340
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
      TabOrder = 2
    end
    object Panel1: TPanel
      Left = 584
      Top = 210
      Width = 117
      Height = 60
      Caption = 'Panel1'
      TabOrder = 4
      Visible = False
      object vtShape2: TvtShape
        Left = 45
        Top = 27
        Width = 379
        Height = 492
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
        Left = 359
        Top = 40
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
        Left = 332
        Top = 182
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
        Left = 362
        Top = 331
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
        Left = 364
        Top = 62
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
        Left = 347
        Top = 349
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
        Left = 311
        Top = 182
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
        Left = 291
        Top = 204
        Width = 133
        Height = 300
        Hint = 'Double click to select one'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnDblClick = ListBox2DblClick
      end
      object CreatePdfBtn2: TBitBtn
        Left = 306
        Top = 104
        Width = 118
        Height = 25
        Caption = 'Create PDF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = CreatePdfBtn2Click
      end
      object DocName2: TvtEdit
        Left = 101
        Top = 84
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
        TabOrder = 0
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
        Left = 291
        Top = 211
        Width = 133
        Height = 300
        Hint = 'Double click to remove 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnDblClick = ListBox3DblClick
      end
      object EmailPdfBtn2: TButton
        Left = 354
        Top = 135
        Width = 70
        Height = 25
        Caption = 'Email PDF...'
        TabOrder = 2
        OnClick = EmailPdfBtn2Click
      end
      object AddAllBtn: TBitBtn
        Left = 358
        Top = 219
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
        TabOrder = 3
        OnClick = SelectAllBtnClick
      end
      object RemoveAllbtn: TBitBtn
        Left = 358
        Top = 266
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
  end
  object TPanel
    Left = 0
    Top = 53
    Width = 729
    Height = 130
    TabOrder = 1
    object vtLabel9: TvtLabel
      Left = 16
      Top = 57
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
      Left = 13
      Top = 85
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
      Left = 429
      Top = 85
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
    object Fr: TvtLabel
      Left = 648
      Top = 85
      Width = 67
      Height = 14
      Caption = '(from T2-Pg9)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object vtLabel16: TvtLabel
      Left = 16
      Top = 3
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
      Left = 16
      Top = 25
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
    object DirGroup: TRadioGroup
      Left = 336
      Top = 3
      Width = 372
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
      TabOrder = 0
      OnClick = DirGroupClick
    end
    object FolderName: TvtEdit
      Left = 115
      Top = 57
      Width = 593
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
    object MapiEmailBox: TCheckBox
      Left = 519
      Top = 107
      Width = 77
      Height = 17
      Caption = 'MAPI Email'
      TabOrder = 3
      Visible = False
    end
    object RecipientEmail: TvtEdit
      Left = 110
      Top = 85
      Width = 313
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
      TabOrder = 2
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
      Left = 497
      Top = 85
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
      TabOrder = 4
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
  end
end
