object AuthorFrm: TAuthorFrm
  Left = 286
  Top = 186
  Width = 732
  Height = 534
  Caption = 'Program Authorization'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 152
    Top = 8
    Width = 373
    Height = 19
    Caption = 'Year 2016 (T1,TF,T4,TR) and T2-2017 and FP-2017'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 32
    Width = 42
    Height = 16
    Caption = 'Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 228
    Top = 32
    Width = 38
    Height = 16
    Caption = 'Code'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 284
    Top = 32
    Width = 45
    Height = 16
    Caption = 'Factor'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 340
    Top = 48
    Width = 337
    Height = 129
    Caption = 'Create Key'
    Color = 16777185
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 199
      Top = 8
      Width = 70
      Height = 13
      Caption = 'Key Created'
    end
    object Label2: TLabel
      Left = 192
      Top = 96
      Width = 68
      Height = 13
      Caption = 'Save as file'
    end
    object CreateKeyBtn: TBitBtn
      Left = 16
      Top = 24
      Width = 113
      Height = 25
      Caption = '1. Create Key'
      TabOrder = 0
      OnClick = CreateKeyBtnClick
    end
    object KeyBox: TEdit
      Left = 144
      Top = 24
      Width = 185
      Height = 21
      TabOrder = 1
    end
    object ValidateBtn: TBitBtn
      Left = 16
      Top = 48
      Width = 113
      Height = 25
      Caption = '2. Validate key'
      TabOrder = 2
      OnClick = ValidateBtnClick
    end
    object SaveKeyBtn: TBitBtn
      Left = 16
      Top = 72
      Width = 113
      Height = 25
      Caption = '3. Save Key'
      TabOrder = 3
      OnClick = SaveKeyBtnClick
    end
    object FileNameBox: TEdit
      Left = 144
      Top = 76
      Width = 185
      Height = 21
      TabOrder = 4
    end
    object ResultBox: TEdit
      Left = 144
      Top = 48
      Width = 185
      Height = 21
      TabOrder = 5
    end
    object ExitBtn: TBitBtn
      Left = 16
      Top = 96
      Width = 113
      Height = 25
      Caption = 'Exit'
      TabOrder = 6
      OnClick = ExitBtnClick
      Kind = bkCancel
    end
  end
  object Panel1: TPanel
    Left = 340
    Top = 184
    Width = 337
    Height = 305
    TabOrder = 1
    object Label3: TLabel
      Left = 6
      Top = 8
      Width = 55
      Height = 13
      Caption = 'No. of Keys'
    end
    object ListBox4: TListBox
      Left = 40
      Top = 40
      Width = 249
      Height = 257
      ItemHeight = 13
      TabOrder = 0
    end
    object GenKeysBtn: TBitBtn
      Left = 112
      Top = 8
      Width = 97
      Height = 25
      Caption = 'Generate Keys'
      TabOrder = 1
      OnClick = GenKeysBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 224
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Print Keys'
      TabOrder = 2
      OnClick = PrintBtnClick
    end
    object NumKeys: TEdit
      Left = 72
      Top = 8
      Width = 33
      Height = 21
      TabOrder = 3
      Text = 'NumKeys'
    end
  end
  object ListBox1: TListBox
    Left = 8
    Top = 48
    Width = 196
    Height = 433
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = ListBox1DblClick
  end
  object ListBox2: TListBox
    Left = 212
    Top = 48
    Width = 57
    Height = 433
    ItemHeight = 13
    TabOrder = 3
  end
  object ListBox3: TListBox
    Left = 284
    Top = 48
    Width = 49
    Height = 433
    ItemHeight = 13
    TabOrder = 4
  end
  object PrintDialog1: TPrintDialog
    Left = 648
  end
end
