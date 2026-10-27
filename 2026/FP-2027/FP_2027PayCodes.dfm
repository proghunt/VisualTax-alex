object PayCodes: TPayCodes
  Left = 143
  Top = 112
  Width = 540
  Height = 512
  Caption = 'PayCodes'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object HeaderBox: TPanel
    Left = 0
    Top = 0
    Width = 532
    Height = 33
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Commission Pay Codes'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 97
    Width = 532
    Height = 320
    Align = alTop
    DataSource = DataSource1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Code'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Description'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Type'
        ReadOnly = True
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 0
    Top = 417
    Width = 532
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete]
    Align = alTop
    TabOrder = 2
  end
  object SaveBtn: TBitBtn
    Left = 168
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 3
  end
  object CancelBtn: TBitBtn
    Left = 264
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 4
    Kind = bkCancel
  end
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 532
    Height = 64
    Align = alTop
    Color = 14942207
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 485
      Height = 13
      Caption = 
        'Existing codes must not be deleted/modified, unless they were ne' +
        'ver used in any Agent'#39's set-up screen'
    end
    object Label2: TLabel
      Left = 32
      Top = 32
      Width = 139
      Height = 16
      Caption = 'Charge codes 00-30'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 192
      Top = 32
      Width = 130
      Height = 16
      Caption = 'Credit codes 31-60'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 344
      Top = 32
      Width = 157
      Height = 16
      Caption = 'Reserved codes 61-99'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object DataSource1: TDataSource
    Left = 256
    Top = 232
  end
end
