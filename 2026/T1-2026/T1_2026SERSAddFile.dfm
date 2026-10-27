object SERSAddFileT1_2026: TSERSAddFileT1_2026
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'SERS - Attach File'
  ClientHeight = 386
  ClientWidth = 437
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 431
    Height = 62
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 9
      Width = 85
      Height = 13
      Caption = 'Business Number:'
    end
    object Label2: TLabel
      Left = 9
      Top = 33
      Width = 55
      Height = 13
      Caption = 'Form Type:'
    end
    object Label3: TLabel
      Left = 205
      Top = 33
      Width = 130
      Height = 13
      Caption = 'EFile Confirmation Number:'
    end
    object edNumber: TEdit
      Left = 126
      Top = 6
      Width = 291
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object edFormType: TEdit
      Left = 126
      Top = 30
      Width = 71
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object edEFileNumber: TEdit
      Left = 342
      Top = 30
      Width = 75
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
  end
  object pnlBottom: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 71
    Width = 431
    Height = 312
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label8: TLabel
      Left = 9
      Top = 159
      Width = 198
      Height = 13
      Caption = 'Maximum remaining total file upload size: '
    end
    object lbRemaining: TLabel
      Left = 217
      Top = 159
      Width = 51
      Height = 13
      Caption = '150.0 Mb'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 9
      Top = 12
      Width = 317
      Height = 13
      Caption = 
        'Attach file(s) associated to the Form'#8217's EFILE confirmation numbe' +
        'r.'
    end
    object Label9: TLabel
      Left = 9
      Top = 31
      Width = 112
      Height = 13
      Caption = 'Allowable file types:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 9
      Top = 50
      Width = 322
      Height = 13
      Caption = 
        '.pdf, .doc, .docx, .xls, .xlsx, .rtf, .txt, .jpg, .jpeg, .tiff, ' +
        '.tif, .xps*'
    end
    object Label11: TLabel
      Left = 12
      Top = 69
      Width = 309
      Height = 13
      Caption = 
        '* Files that can'#8217't be scanned for viruses will be securely delet' +
        'ed.'
      WordWrap = True
    end
    object Label12: TLabel
      Left = 9
      Top = 179
      Width = 79
      Height = 13
      Caption = 'Document Type:'
    end
    object Label13: TLabel
      Left = 9
      Top = 225
      Width = 20
      Height = 13
      Caption = 'File:'
    end
    object Label14: TLabel
      Left = 94
      Top = 179
      Width = 48
      Height = 13
      Caption = '(required)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object Label15: TLabel
      Left = 35
      Top = 225
      Width = 48
      Height = 13
      Caption = '(required)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object btnOpenFile: TSpeedButton
      Left = 397
      Top = 244
      Width = 23
      Height = 21
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000CCE4EEFF65AFCCFF5BAAC9FFDEE8EBFF0000000000000000000000000000
        0000000000000000000000000000000000000000000000000000F5FAFCFF8FC5
        DAFF60B0CEFF70C1DBFF60AFCDFFA7BBC2FFDDDDDDFF0000000000000000EFF6
        F0FF529955FF619E63FF0000000000000000000000000000000065AFCCFF6ABD
        D7FF77CCE3FF76CAE2FF5BAAC9FF4887A0FF427B93FF4D8FAAFF509CB1FF1782
        32FF17A72FFF087911FFDFEDF2FF0000000000000000000000005BAAC9FF79D2
        E7FF78D0E6FF77CEE4FF5BAAC9FF5696B0FF5590A8FF5AA0B2FF1E903CFF1DAF
        3AFF1BB538FF097D13FF3C8F85FF0000000000000000000000005BAAC9FF7BD6
        EAFF7AD4E8FF79D2E7FF5BAAC9FF599BB6FF4B9897FF1E963CFF22B646FF22BB
        45FF1BB538FF13A728FF0A8A15FF227D26FFCFE2D0FF000000005BAAC9FF7CD9
        ECFF7CD7EBFF7BD6EAFF5BAAC9FF5BA9C8FF2EAB43FF46C867FF28C152FF22BB
        45FF1BB538FF15AF2CFF0FA920FF099F13FF137816FFCFE1D0FF5BAAC9FF7EDD
        EEFF7DDBEDFF7DDAEDFF7DD9ECFF76D0E5FF2FB147FFBBF6C0FF47CC69FF22BB
        45FF1BB538FF15AF2CFF0FA920FF09A314FF049709FF418C44FF5BAAC9FF81E1
        F1FF80E0F0FF80DEEFFF7EDEEFFF7EDDEEFF4EAAABFF3CB752FFBAF5BFFF4CCC
        67FF1BB538FF0F931FFF0C951AFF09A314FF049E08FF037406FF5BAAC9FF82E4
        F3FF82E3F3FF82E3F2FF81E2F2FF81E2F1FF5BAAC9FF58B9BFFF3CB653FFAAED
        AFFF5DD06EFF0F9520FF66B26DFF098F13FF049E08FF047909FF5BAAC9FF84E8
        F6FF83E7F5FF83E6F5FF83E6F4FF83E6F4FF5BAAC9FF6BC4EAFF5DC2CBFF24AB
        3EFFA9EDAEFF3EAE49FF0000000047A450FF049E08FF057E0BFF5BAAC9FF85EB
        F8FF85EAF7FF85EAF7FF85E9F7FF85E9F6FF5BAAC9FF6EC9F0FF6FCDF5FF62CC
        D7FF2AAD4BFF2AA44CFF0000000057B45FFF049E08FF16881FFF5BAAC9FF87EE
        FAFF86EEF9FF86EDF9FF86EDF9FF86EDF9FF5BAAC9FF6FCCF5FF71CFF8FF74D5
        FFFF74D5FFFF5DAECEFFC3E5C8FF0B9A17FF089511FF85C18BFF5BAAC9FF88F1
        FCFF88F1FCFF88F0FBFF87F0FBFF87F0FBFF5BAAC9FF71D0F9FF73D3FDFF74D5
        FFFF74D5FFFF50ADB0FF11A023FF0D9E1AFF4AAC55FF000000005BAAC9FF89F4
        FDFF89F3FDFF89F3FDFF86EEF9FF77D7E9FF5BAAC9FF8BDFFFFF8BE0FFFF8BE0
        FFFFABEFFFFF51B0B2FF13A528FF79C885FF00000000000000005BAAC9FF8AF5
        FFFF77D9EAFF69C1DAFF5BAAC9FF7EC5DAFFA9E4EEFFCCFFFFFFCCFFFFFFCCFF
        FFFFB8F1F7FF6AB8D6FF000000000000000000000000000000007ABAD3FF5BAA
        C9FF5DADCDFF5FB1D1FF60B4D5FF61B5D6FF61B5D6FF61B5D6FF61B5D6FF62B7
        D8FF6CBCDAFFC4E3EFFF00000000000000000000000000000000}
      OnClick = btnOpenFileClick
    end
    object btnAttach: TBitBtn
      Left = 9
      Top = 276
      Width = 102
      Height = 27
      Caption = 'Attach file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = btnAttachClick
    end
    object btnCancel: TBitBtn
      Left = 117
      Top = 276
      Width = 102
      Height = 27
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
    end
    object edFileName: TEdit
      Left = 9
      Top = 244
      Width = 382
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object cbDocumentType: TComboBox
      Left = 9
      Top = 198
      Width = 217
      Height = 21
      Style = csDropDownList
      TabOrder = 3
    end
  end
  object dlgFileOpen: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 339
    Top = 303
  end
end
