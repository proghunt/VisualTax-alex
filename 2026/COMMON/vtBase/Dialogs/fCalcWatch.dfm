object CalcWatch: TCalcWatch
  Left = 454
  Top = 113
  Caption = 'Watch calculation'
  ClientHeight = 266
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    397
    266)
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 4
    Top = 8
    Width = 51
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'FormName'
  end
  object Label4: TLabel
    Left = 4
    Top = 32
    Width = 57
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Dollar Fields'
  end
  object Button1: TButton
    Left = 156
    Top = 238
    Width = 75
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object edFormName: TEdit
    Left = 68
    Top = 4
    Width = 109
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 1
    Text = 'TAXSUM'
    OnChange = edFormNameChange
  end
  object edFields: TEdit
    Left = 68
    Top = 28
    Width = 305
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 2
    Text = '30 100 -14'
    OnChange = edFieldsChange
  end
  object gbRetName: TGroupBox
    Left = 8
    Top = 64
    Width = 381
    Height = 161
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Return to be shown'
    TabOrder = 3
    DesignSize = (
      381
      161)
    object Label1: TLabel
      Left = 44
      Top = 24
      Width = 41
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'On Entry'
    end
    object Label2: TLabel
      Left = 256
      Top = 20
      Width = 51
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Before Exit'
    end
    object lbBefore: TListBox
      Left = 8
      Top = 44
      Width = 169
      Height = 105
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      TabOrder = 0
    end
    object lbAfter: TListBox
      Left = 196
      Top = 44
      Width = 169
      Height = 105
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      TabOrder = 1
    end
  end
end
