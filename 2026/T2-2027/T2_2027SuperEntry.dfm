object SuperEntryT2_2027: TSuperEntryT2_2027
  Left = 171
  Top = 136
  Caption = 'SuperEntryT2_2027'
  ClientHeight = 487
  ClientWidth = 708
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 708
    Height = 78
    Align = alTop
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label1: TLabel
      Left = 107
      Top = 44
      Width = 455
      Height = 38
      Caption = 
        'Train VisualTax to learn your Business and Clients. It will serv' +
        'e you better.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12971774
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 268
      Top = 12
      Width = 203
      Height = 24
      Caption = 'Super Predictive Entry'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12971774
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 78
    Width = 708
    Height = 70
    Align = alTop
    Color = 15400959
    TabOrder = 4
    object Label2: TLabel
      Left = 16
      Top = 8
      Width = 408
      Height = 15
      Caption = 
        'Ask it to memorize all Corporation Names, Business Numbers, Citi' +
        'es, etc..'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 260
      Height = 15
      Caption = 'You may never have to type these words again...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 16
      Top = 48
      Width = 29
      Height = 15
      Caption = 'Note:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 51
      Top = 48
      Width = 391
      Height = 15
      Caption = 
        'You can turn off predictive entry in Configure | General Options' +
        ' | Defaults'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
  end
  object MemorizeGroup: TGroupBox
    Left = 223
    Top = 152
    Width = 249
    Height = 311
    Caption = 'Memorize...'
    Color = 13353654
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    object CharityBox: TCheckBox
      Left = 16
      Top = 176
      Width = 169
      Height = 17
      Caption = 'Charity Organizations'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
    end
    object CorpNmBox: TCheckBox
      Left = 16
      Top = 40
      Width = 217
      Height = 17
      Caption = 'Corporation Names'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 2
    end
    object CorpBnBox: TCheckBox
      Left = 16
      Top = 80
      Width = 161
      Height = 17
      Caption = 'Business Numbers'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 3
    end
    object CitiesBox: TCheckBox
      Left = 16
      Top = 128
      Width = 161
      Height = 17
      Caption = 'Cities'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 1
    end
  end
  object ActionGroup: TGroupBox
    Left = 494
    Top = 152
    Width = 201
    Height = 311
    Caption = 'Action...'
    Color = 13353654
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    object OKBtn: TBitBtn
      Left = 24
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Do it now'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 24
      Top = 272
      Width = 137
      Height = 25
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = CancelBtnClick
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 56
      Width = 169
      Height = 209
      Caption = 'Review results'
      TabOrder = 1
      object CharityBtn: TBitBtn
        Left = 32
        Top = 144
        Width = 105
        Height = 25
        Caption = 'Charities'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = CharityBtnClick
      end
      object CoppBNBtn: TBitBtn
        Left = 32
        Top = 64
        Width = 105
        Height = 25
        Caption = 'Business No.'#39's'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = CoppBNBtnClick
      end
      object CorpNamesBtn: TBitBtn
        Left = 32
        Top = 24
        Width = 105
        Height = 25
        Caption = 'Corp. Names'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = CorpNamesBtnClick
      end
      object CitiesBtn: TBitBtn
        Left = 32
        Top = 104
        Width = 105
        Height = 25
        Caption = 'Cities'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = CitiesBtnClick
      end
    end
  end
  object ExperienceBox: TRadioGroup
    Left = 16
    Top = 152
    Width = 185
    Height = 81
    Caption = 'Gather Experience from...'
    Color = 13353654
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemIndex = 1
    Items.Strings = (
      'Last Year'#39's clients'
      'This Year'#39's Clients')
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    OnClick = ExperienceBoxClick
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 247
    Width = 185
    Height = 217
    Caption = 'File List'
    Color = 13353654
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    object FileListBox1: TFileListBox
      Left = 8
      Top = 16
      Width = 153
      Height = 185
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 0
    end
  end
end
