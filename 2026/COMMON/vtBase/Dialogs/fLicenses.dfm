object About: TAbout
  Left = 341
  Top = 129
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'About'
  ClientHeight = 599
  ClientWidth = 922
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    922
    599)
  PixelsPerInch = 96
  TextHeight = 16
  object Shape1: TShape
    Left = 14
    Top = 436
    Width = 888
    Height = 127
    Anchors = [akLeft, akRight, akBottom]
    Brush.Style = bsClear
    ExplicitWidth = 848
  end
  object Label1: TLabel
    Left = 326
    Top = 495
    Width = 184
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = 'EMail: Support@VisualTax.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    IsControl = True
  end
  object Label3: TLabel
    Left = 326
    Top = 474
    Width = 169
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = 'Web site: www.visualtax.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    IsControl = True
  end
  object Copyright: TLabel
    Left = 318
    Top = 443
    Width = 179
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = '(C) Copyright: Microsophic Inc.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    IsControl = True
  end
  object Label4: TLabel
    Left = 329
    Top = 539
    Width = 116
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = 'Fax: (905) 625-9384'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    IsControl = True
  end
  object Label6: TLabel
    Left = 329
    Top = 523
    Width = 114
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = 'Tel.: (905) 238-6159'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    IsControl = True
  end
  object Panel2: TPanel
    Left = 14
    Top = 16
    Width = 888
    Height = 407
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Color = 16777134
    TabOrder = 0
    ExplicitWidth = 848
    DesignSize = (
      888
      407)
    object Label2: TLabel
      Left = 312
      Top = 19
      Width = 170
      Height = 45
      Caption = 'VisualTax'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -40
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      IsControl = True
    end
    object Label7: TLabel
      Left = 480
      Top = 26
      Width = 16
      Height = 13
      Caption = 'TM'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      IsControl = True
    end
    object AppReleaseLbl: TLabel
      Left = 294
      Top = 84
      Width = 206
      Height = 16
      Caption = 'Last update Date:  yyyy/mm/dd '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object TaxYearLbl: TLabel
      Left = 312
      Top = 64
      Width = 152
      Height = 16
      Caption = 'Program Version:  2013'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 21
      Top = 111
      Width = 856
      Height = 9
      Anchors = [akLeft, akTop, akRight]
      Shape = bsBottomLine
      ExplicitWidth = 908
    end
    object Label16: TLabel
      Left = 455
      Top = 133
      Width = 172
      Height = 16
      Caption = 'Your License Program key'
    end
    object Label21: TLabel
      Left = 658
      Top = 133
      Width = 139
      Height = 16
      Caption = 'Your License Version'
    end
    object ProgramIcon: TImage
      Left = 9
      Top = 9
      Width = 41
      Height = 41
      Picture.Data = {
        07544269746D617076020000424D760200000000000076000000280000002000
        0000200000000100040000000000000200000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00000000000000000000000000000000000EE8787878EEEEEEE03F30878EEE
        EEE00EE8787878EEEEEEE03F30878EEEEEE00EE8787878EEEEEEE03F30878EEE
        EEE00EE8787878EEEEEEE03F30878EEEEEE00887787877788888803F3088787E
        EEE00788787878878887803F3088887EEEE00788887888878887803F3088887E
        EEE00877888887788888703F308887EEEEE00888777778888888037883088888
        8EE007777777777777703787883087777EE00888888888888803787FF8830888
        888008888888888880378777778830888880077777777788037873F3F3F87808
        88E00888888888803787FFFFFFFF8830EEE00887777778800001111111111100
        EEE00888888888888899B999B99999EEEEE00888888888888899B9B99BB9B9EE
        EEE0088888888888899BB9BB99BB99EEEEE0078888888888899B999B999999EE
        EEE0087788888778899B9B9BB9BB99EEEEE00888778778888E9B9B9BB9999EEE
        EEE0088888788888EE9B99B9BB9BEEEEEEE00EE8888888EEEEE999B9999EEEEE
        EEE00EEEE888EEEEEEEE99BB999EEEEEEEE00EEEEE8EEEEEEEEEE999B9EEEEEE
        EEE00EEEEE8EEEEEEEEEEEE999EEEEEEEEE00EEEEE8EEEEEEEEEEEEE99EEEEEE
        EEE00EEEEE8EEEEEEEEEEEEE9EEEEEEEEEE00EEEEE8EEEEEEEEEEEEEEEEEEEEE
        EEE00EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE00000000000000000000000000000
        0000}
      Stretch = True
      IsControl = True
    end
    object Label26: TLabel
      Left = 105
      Top = 140
      Width = 62
      Height = 16
      Caption = 'Released'
    end
    object Label27: TLabel
      Left = 175
      Top = 119
      Width = 88
      Height = 16
      Caption = 'TAX MODULE'
    end
    object Label28: TLabel
      Left = 217
      Top = 140
      Width = 49
      Height = 16
      Caption = 'Version'
    end
    object Label29: TLabel
      Left = 294
      Top = 140
      Width = 110
      Height = 16
      Caption = 'Last update Date'
    end
    object Label44: TLabel
      Left = 21
      Top = 140
      Width = 38
      Height = 16
      Caption = 'Name'
    end
    object Label46: TLabel
      Left = 452
      Top = 309
      Width = 71
      Height = 16
      Caption = '(Enter Key)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label47: TLabel
      Left = 655
      Top = 309
      Width = 22
      Height = 16
      Caption = 'N/A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label48: TLabel
      Left = 207
      Top = 309
      Width = 22
      Height = 16
      Caption = 'N/A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label49: TLabel
      Left = 305
      Top = 309
      Width = 22
      Height = 16
      Caption = 'N/A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label9: TLabel
      Left = 455
      Top = 147
      Width = 114
      Height = 14
      Caption = 'Enter the keys provided'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label50: TLabel
      Left = 455
      Top = 161
      Width = 109
      Height = 14
      Caption = ' to you upon purchase'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object buSave: TBitBtn
      Left = 217
      Top = 358
      Width = 155
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Save '
      TabOrder = 0
      OnClick = buSaveClick
    end
    object buExit: TBitBtn
      Left = 420
      Top = 358
      Width = 155
      Height = 25
      Anchors = [akLeft, akBottom]
      Cancel = True
      Caption = 'Exit'
      ModalResult = 1
      TabOrder = 1
    end
    object CheckBox7: TCheckBox
      Left = 112
      Top = 308
      Width = 22
      Height = 17
      TabOrder = 2
      Visible = False
    end
    object sbLics: TScrollBox
      Left = 16
      Top = 176
      Width = 861
      Height = 170
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      TabOrder = 3
      ExplicitWidth = 821
    end
  end
end
