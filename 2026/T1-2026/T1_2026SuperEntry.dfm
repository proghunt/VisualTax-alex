object SuperEntryT1_2026: TSuperEntryT1_2026
  Left = 224
  Top = 353
  Caption = 'SuperEntryT1_2026'
  ClientHeight = 476
  ClientWidth = 711
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
    Width = 711
    Height = 97
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
      Left = 48
      Top = 72
      Width = 576
      Height = 16
      Caption = 
        'Take a minute to train VisualTax to learn your Business and Clie' +
        'nts. It will serve you better.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 287
      Top = 40
      Width = 107
      Height = 24
      Caption = 'Super Entry'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 239
      Top = 8
      Width = 233
      Height = 19
      Caption = 'Train the VisualTax program !...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 327
      Top = 24
      Width = 17
      Height = 16
      Caption = 'for'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 97
    Width = 711
    Height = 48
    Align = alTop
    Color = 10930928
    TabOrder = 4
    object Label2: TLabel
      Left = 16
      Top = 8
      Width = 682
      Height = 13
      Caption = 
        'Ask it to memorize all Doctors/Hospitals used in Medical Expense' +
        's, Types of Medical Expenses, Charity organizations,  Financial ' +
        'Institutions, etc..'
    end
    object Label3: TLabel
      Left = 16
      Top = 24
      Width = 328
      Height = 13
      Caption = 
        'You may never have to type these names again, this or next seaso' +
        'n...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object MemorizeGroup: TGroupBox
    Left = 248
    Top = 152
    Width = 225
    Height = 305
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
    object BanksBox: TCheckBox
      Left = 16
      Top = 152
      Width = 161
      Height = 17
      Caption = 'Financial Institutions'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 4
    end
    object MedExpBox: TCheckBox
      Left = 16
      Top = 216
      Width = 177
      Height = 17
      Caption = 'Medical Expense types'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 6
    end
    object CharitiesBox: TCheckBox
      Left = 16
      Top = 24
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
    object DoctorsBox: TCheckBox
      Left = 16
      Top = 88
      Width = 217
      Height = 17
      Caption = 'Doctors/Hospitals/Pharmacies'
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
    object EmployersBox: TCheckBox
      Left = 16
      Top = 120
      Width = 161
      Height = 17
      Caption = 'Employer Names'
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
    object FirstNmBox: TCheckBox
      Left = 16
      Top = 184
      Width = 161
      Height = 17
      Caption = 'First Names'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 5
    end
    object CitiesBox: TCheckBox
      Left = 16
      Top = 56
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
    Left = 488
    Top = 152
    Width = 201
    Height = 305
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
      object MedExpBtn: TBitBtn
        Left = 32
        Top = 173
        Width = 113
        Height = 25
        Caption = 'Medical Expenses'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = MedExpBtnClick
      end
      object DoctorsBtn: TBitBtn
        Left = 32
        Top = 73
        Width = 113
        Height = 25
        Caption = 'Doctors-Hospitals'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = DoctorsBtnClick
      end
      object CharityBtn: TBitBtn
        Left = 32
        Top = 23
        Width = 113
        Height = 25
        Caption = 'Charities'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = CharityBtnClick
      end
      object BanksBtn: TBitBtn
        Left = 32
        Top = 123
        Width = 113
        Height = 25
        Caption = 'Financial Instit.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = BanksBtnClick
      end
      object EmployersBtn: TBitBtn
        Left = 32
        Top = 98
        Width = 113
        Height = 25
        Caption = 'Employers'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = EmployersBtnClick
      end
      object FirstNameBox: TBitBtn
        Left = 32
        Top = 148
        Width = 113
        Height = 25
        Caption = 'First Names'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = FirstNameBoxClick
      end
      object CitiesBtn: TBitBtn
        Left = 32
        Top = 48
        Width = 113
        Height = 25
        Caption = 'Cities'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = CitiesBtnClick
      end
    end
  end
  object ExperienceBox: TRadioGroup
    Left = 8
    Top = 152
    Width = 225
    Height = 81
    Caption = 'Gather Experience from...'
    Color = 13353654
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemIndex = 0
    Items.Strings = (
      'Last Year'#39's clients (VisualTax)'
      'This Year'#39's Clients')
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    OnClick = ExperienceBoxClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 240
    Width = 225
    Height = 217
    Caption = 'File List'
    Color = 13353654
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    object FileListBox1: TFileListBox
      Left = 8
      Top = 16
      Width = 209
      Height = 185
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      TabOrder = 0
    end
  end
end
