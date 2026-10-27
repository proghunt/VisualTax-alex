object vtEditHTML: TvtEditHTML
  Left = 0
  Top = 0
  Caption = 'Edit Email Wording'
  ClientHeight = 575
  ClientWidth = 777
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  DesignSize = (
    777
    575)
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 777
    Height = 49
    Align = alTop
    Brush.Color = 11301888
    ExplicitLeft = 8
    ExplicitTop = -8
  end
  object Label2: TLabel
    Left = 247
    Top = 6
    Width = 282
    Height = 37
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Edit Email Wording'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -33
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pnlActions: TPanel
    Left = 0
    Top = 49
    Width = 777
    Height = 32
    Align = alTop
    TabOrder = 0
    object btnBold: TSpeedButton
      Left = 4
      Top = 4
      Width = 23
      Height = 21
      Action = actBold
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnItalic: TSpeedButton
      Left = 28
      Top = 4
      Width = 23
      Height = 21
      Action = actItalic
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object SpeedButton3: TSpeedButton
      Left = 287
      Top = 4
      Width = 69
      Height = 21
      Action = actAddLink
    end
    object btnUnderline: TSpeedButton
      Left = 53
      Top = 4
      Width = 23
      Height = 21
      Action = actUnderline
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 82
      Top = 8
      Width = 44
      Height = 13
      Caption = 'Font Size'
    end
    object SpeedButton1: TSpeedButton
      Left = 214
      Top = 4
      Width = 69
      Height = 21
      Action = actSetTextColor
    end
    object cbFontSizes: TComboBox
      Left = 133
      Top = 4
      Width = 76
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbFontSizesChange
      Items.Strings = (
        '1 (smallest)'
        '2'
        '3 (default)'
        '4'
        '5'
        '6'
        '7 (largest)')
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 538
    Width = 777
    Height = 37
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      777
      37)
    object btnSave: TButton
      Left = 610
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Save'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 691
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 81
    Width = 777
    Height = 457
    Align = alClient
    TabOrder = 1
    object WB: TWebBrowser
      Left = 1
      Top = 1
      Width = 775
      Height = 455
      Align = alClient
      TabOrder = 0
      OnCommandStateChange = WBCommandStateChange
      ControlData = {
        4C00000019500000072F00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object alActions: TActionList
    Left = 480
    Top = 233
    object actBold: TAction
      Caption = 'B'
      OnExecute = actBoldExecute
    end
    object actItalic: TAction
      Caption = 'I'
      OnExecute = actItalicExecute
    end
    object actUnderline: TAction
      Caption = 'U'
      OnExecute = actUnderlineExecute
    end
    object actAddLink: TAction
      Caption = 'Add link'
      OnExecute = actAddLinkExecute
    end
    object actSetTextColor: TAction
      Caption = 'Text Color'
      OnExecute = actSetTextColorExecute
    end
  end
  object SelectColorDialog: TColorDialog
    Left = 360
    Top = 225
  end
end
