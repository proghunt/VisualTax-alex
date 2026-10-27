object vtCourier: TvtCourier
  Left = 0
  Top = 0
  Caption = 'vtCourier'
  ClientHeight = 495
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    770
    495)
  PixelsPerInch = 96
  TextHeight = 13
  object vtShape4: TvtShape
    Left = 0
    Top = 0
    Width = 770
    Height = 70
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
    ExplicitWidth = 764
  end
  object vtLabel37: TvtLabel
    Left = 295
    Top = 1
    Width = 181
    Height = 37
    Caption = 'vtCourier '#8482
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object vtLabel1: TvtLabel
    Left = 215
    Top = 44
    Width = 292
    Height = 19
    Caption = 'Encrypted Messages and Attachments'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object WWWLbl: TLabel
    Left = 628
    Top = 22
    Width = 112
    Height = 15
    Cursor = crHandPoint
    Hint = 'Click to connect to the VisualTax web site'
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'www.visualtax.com'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 13948116
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Transparent = True
    OnClick = WWWLblClick
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 70
    Width = 770
    Height = 499
    Align = alTop
    TabOrder = 0
    object vtLabel2: TvtLabel
      Left = 546
      Top = 167
      Width = 195
      Height = 16
      Caption = 'or drag attachments into this area'
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
      Left = 164
      Top = 166
      Width = 90
      Height = 16
      Caption = 'Email message'
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
      Left = 23
      Top = 143
      Width = 81
      Height = 16
      Caption = 'Email Subject'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object vtLabel5: TvtLabel
      Left = 23
      Top = 108
      Width = 62
      Height = 24
      Caption = 'Sender'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object vtLabel10: TvtLabel
      Left = 23
      Top = 83
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
      Left = 525
      Top = 83
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
    object vtLabel9: TvtLabel
      Left = 23
      Top = 56
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
    object vtLabel7: TvtLabel
      Left = 23
      Top = 349
      Width = 84
      Height = 24
      Caption = 'Recipient'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      vtBorderType = vtlblNoBorder
    end
    object lbAvailable: TLabel
      Left = 631
      Top = 8
      Width = 116
      Height = 42
      AutoSize = False
      Caption = 'Encryption is available only for users who paid membership fees'
      Color = clInfoBk
      ParentColor = False
      Transparent = False
      Visible = False
      WordWrap = True
    end
    object btnSelectDirectory: TSpeedButton
      Left = 724
      Top = 56
      Width = 23
      Height = 21
      Caption = '..'
      OnClick = btnSelectDirectoryClick
    end
    object CancelBtn: TBitBtn
      Left = 680
      Top = 383
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
      TabOrder = 12
    end
    object EmailToRecipient: TButton
      Left = 546
      Top = 317
      Width = 115
      Height = 25
      Caption = 'Email to Recipient'
      TabOrder = 11
      OnClick = EmailToRecipientClick
    end
    object lbFiles: TListBox
      Left = 546
      Top = 189
      Width = 201
      Height = 121
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Sorted = True
      TabOrder = 10
      OnKeyDown = lbFilesKeyDown
    end
    object AddFiles: TButton
      Left = 546
      Top = 141
      Width = 87
      Height = 25
      Caption = 'Add files'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = AddFilesClick
    end
    object EmailSubject: TEdit
      Left = 124
      Top = 142
      Width = 382
      Height = 21
      TabOrder = 2
      Text = 'vtCourier Email'
    end
    object meMessage: TMemo
      Left = 23
      Top = 188
      Width = 483
      Height = 99
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object GenerateMessage: TButton
      Left = 23
      Top = 317
      Width = 186
      Height = 25
      Caption = 'Generate the Encryption Message'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = GenerateMessageClick
    end
    object DecryptFileBtn: TButton
      Left = 23
      Top = 383
      Width = 82
      Height = 25
      Caption = 'Decrypt files'
      TabOrder = 9
      OnClick = DecryptFileBtnClick
    end
    object RecipientEmail: TEdit
      Left = 124
      Top = 82
      Width = 382
      Height = 21
      TabOrder = 3
      OnExit = FolderNameExit
    end
    object RecipientSalutation: TEdit
      Left = 593
      Top = 82
      Width = 154
      Height = 21
      TabOrder = 6
    end
    object FolderName: TEdit
      Left = 124
      Top = 56
      Width = 597
      Height = 21
      TabOrder = 8
      OnExit = FolderNameExit
    end
    object DirGroup: TRadioGroup
      Left = 23
      Top = 8
      Width = 369
      Height = 42
      Caption = 'Folder where documents are located'
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Items.Strings = (
        'Client Documents folder'
        'Other folder  (enter below)')
      ParentFont = False
      TabOrder = 0
      OnClick = DirGroupClick
    end
    object TransmitAsEncrypted: TCheckBox
      Left = 23
      Top = 292
      Width = 251
      Height = 17
      Caption = 'Transmit the textual message as encrypted file?'
      TabOrder = 5
    end
    object SecuritySettingsGroup: TRadioGroup
      Left = 398
      Top = 8
      Width = 227
      Height = 42
      Caption = 'Security settings'
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Items.Strings = (
        'Encrypt files'
        'No encryption')
      ParentFont = False
      TabOrder = 13
      OnClick = SecuritySettingsGroupClick
    end
    object AddCurrentReturn: TButton
      Left = 639
      Top = 141
      Width = 108
      Height = 25
      Caption = 'Add current return'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
      OnClick = AddCurrentReturnClick
    end
    object btnHelp: TButton
      Left = 616
      Top = 383
      Width = 58
      Height = 25
      Caption = 'Help'
      TabOrder = 15
      OnClick = btnHelpClick
    end
  end
  object OpenFilesDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 712
    Top = 160
  end
  object OpenEncryptedDialog: TOpenDialog
    Filter = 'Encrypted files (*.encrypted)|*.encrypted'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 656
    Top = 344
  end
end
