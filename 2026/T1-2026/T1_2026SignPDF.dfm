object SignPDFT1_2026: TSignPDFT1_2026
  Left = 199
  Top = 94
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Sign PDF with E-Signature'
  ClientHeight = 623
  ClientWidth = 953
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object pnlCaption: TPanel
    Left = 0
    Top = 0
    Width = 953
    Height = 37
    Align = alTop
    Caption = 'Sign PDF with E-Signature'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 37
    Width = 953
    Height = 92
    Align = alTop
    TabOrder = 1
    object SignatureImage: TImage
      Left = 231
      Top = 7
      Width = 9
      Height = 77
      Proportional = True
      Stretch = True
    end
    object btnPrevPage: TSpeedButton
      Left = 57
      Top = 62
      Width = 23
      Height = 22
      Caption = '<'
      OnClick = btnPrevPageClick
    end
    object btnNextPage: TSpeedButton
      Left = 144
      Top = 62
      Width = 23
      Height = 22
      Caption = '>'
      OnClick = btnNextPageClick
    end
    object lbCurrentPage: TLabel
      Left = 84
      Top = 62
      Width = 55
      Height = 22
      Alignment = taCenter
      AutoSize = False
      Caption = '100 / 100'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object lbPage: TLabel
      Left = 11
      Top = 65
      Width = 36
      Height = 16
      Caption = 'Page:'
    end
    object shDelimiter: TShape
      Left = 221
      Top = 6
      Width = 1
      Height = 70
    end
    object shSignaturePreview: TShape
      Left = 566
      Top = 6
      Width = 65
      Height = 23
      Brush.Style = bsClear
      Visible = False
    end
    object btnAddSignature: TSpeedButton
      Left = 621
      Top = 34
      Width = 181
      Height = 25
      Caption = 'Add signature to document'
      Visible = False
      OnClick = btnAddSignatureClick
    end
    object btnOpen: TSpeedButton
      Left = 11
      Top = 6
      Width = 103
      Height = 25
      Caption = 'Open PDF'
      OnClick = btnOpenClick
    end
    object btnSelectSignature: TSpeedButton
      Left = 620
      Top = 6
      Width = 122
      Height = 25
      Caption = 'Select signature'
      OnClick = btnSelectSignatureClick
    end
    object btnSave: TSpeedButton
      Left = 120
      Top = 6
      Width = 90
      Height = 25
      Caption = 'Save PDF'
      OnClick = btnSaveClick
    end
    object btnHelp: TSpeedButton
      Left = 744
      Top = 6
      Width = 57
      Height = 25
      Caption = 'Help'
      OnClick = btnHelpClick
    end
    object btnSaveAndEmail: TSpeedButton
      Left = 11
      Top = 34
      Width = 199
      Height = 25
      Caption = 'Save and Email with vtCourier'
      OnClick = btnSaveAndEmailClick
    end
    object cbKeepAspectRatio: TCheckBox
      Left = 621
      Top = 65
      Width = 122
      Height = 17
      Caption = 'Keep aspect ratio'
      Checked = True
      State = cbChecked
      TabOrder = 0
      Visible = False
      OnClick = cbKeepAspectRatioClick
    end
    object pnlWarning: TPanel
      Left = 230
      Top = 6
      Width = 385
      Height = 79
      BevelInner = bvLowered
      Color = 14803455
      ParentBackground = False
      TabOrder = 1
      object lbWarning: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 375
        Height = 41
        Align = alTop
        AutoSize = False
        Caption = 
          'Signature is not found. Please, select a file with your signatur' +
          'e'#13#10'If you do not have an Electronic Signature, click here'
        WordWrap = True
        ExplicitLeft = -59
        ExplicitTop = 3
        ExplicitWidth = 287
      end
      object btnHowToCreate: TSpeedButton
        Left = 73
        Top = 45
        Width = 238
        Height = 25
        Caption = 'How To create an electronic signature'
        OnClick = btnHowToCreateClick
      end
    end
  end
  object pnlPreview: TPanel
    Left = 0
    Top = 129
    Width = 953
    Height = 494
    Align = alClient
    TabOrder = 2
    OnResize = pnlPreviewResize
    DesignSize = (
      953
      494)
    object PreviewImage: TImage
      Left = 138
      Top = 80
      Width = 105
      Height = 105
    end
    object shSignature: TShape
      Left = 152
      Top = 96
      Width = 65
      Height = 65
      Anchors = []
      Brush.Style = bsClear
      Pen.Color = clRed
      Pen.Style = psDot
      Pen.Width = 2
      Visible = False
      OnMouseDown = shSignatureMouseDown
      OnMouseLeave = shSignatureMouseLeave
      OnMouseMove = shSignatureMouseMove
      OnMouseUp = shSignatureMouseUp
    end
    object shSignatureDate: TShape
      Tag = 1
      Left = 152
      Top = 191
      Width = 65
      Height = 20
      Anchors = []
      Brush.Style = bsClear
      Pen.Color = clRed
      Pen.Style = psDot
      Pen.Width = 2
      Visible = False
      OnMouseDown = shSignatureMouseDown
      OnMouseLeave = shSignatureMouseLeave
      OnMouseMove = shSignatureMouseMove
      OnMouseUp = shSignatureMouseUp
    end
  end
  object OpenPDFDialog: TOpenDialog
    Filter = 
      'All supported files (*.pdf; *.pdf.encrypted)|*.pdf;*.pdf.encrypt' +
      'ed'
    Left = 320
    Top = 256
  end
  object OpenSignatureDialog: TOpenPictureDialog
    Left = 560
    Top = 49
  end
  object SavePDFDialog: TSaveDialog
    DefaultExt = '.pdf'
    Filter = 'PDF Files (*.pdf)|*.pdf'
    Left = 480
    Top = 185
  end
end
