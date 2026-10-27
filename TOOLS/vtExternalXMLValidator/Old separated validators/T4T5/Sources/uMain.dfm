object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'T4T5 Visual Tax XML Validator'
  ClientHeight = 411
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 204
    Height = 13
    Caption = 'Please select the T4T5 XML file to analyze:'
  end
  object eFilePath: TEdit
    Left = 16
    Top = 35
    Width = 793
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 808
    Top = 33
    Width = 33
    Height = 25
    Caption = 'Open'
    TabOrder = 1
    OnClick = Button1Click
  end
  object rgTaxType: TRadioGroup
    Left = 16
    Top = 62
    Width = 337
    Height = 51
    Caption = 'Please select the tax file type:'
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'T4'
      'T4A'
      'T5')
    TabOrder = 2
  end
  object btnStart: TButton
    Left = 16
    Top = 119
    Width = 105
    Height = 28
    Caption = 'Check the file'
    TabOrder = 3
    OnClick = btnStartClick
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.XML'
    Left = 736
  end
end
