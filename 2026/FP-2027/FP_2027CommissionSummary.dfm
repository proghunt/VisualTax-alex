object CommissionSummary: TCommissionSummary
  Left = 96
  Top = 109
  Width = 698
  Height = 490
  Caption = 'CommissionSummary'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 52
    Top = 16
    Width = 28
    Height = 13
    Caption = 'Agent'
  end
  object GroupBox3: TGroupBox
    Left = 136
    Top = 16
    Width = 329
    Height = 57
    Caption = 'Statement Dates'
    TabOrder = 0
    object Label3: TLabel
      Left = 42
      Top = 24
      Width = 23
      Height = 13
      Caption = 'From'
    end
    object Label4: TLabel
      Left = 188
      Top = 24
      Width = 13
      Height = 13
      Caption = 'To'
    end
    object FromDateBox: TEdit
      Left = 88
      Top = 24
      Width = 81
      Height = 21
      TabOrder = 0
    end
    object ToDateBox: TEdit
      Left = 216
      Top = 24
      Width = 81
      Height = 21
      TabOrder = 1
    end
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 136
    Width = 665
    Height = 257
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'AgentCode'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AgentName'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ProductRt'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DealerCommission'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AgentRate'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'AgentCommission'
        Visible = True
      end>
  end
  object OkBtn: TBitBtn
    Left = 200
    Top = 88
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
  end
  object CancelBtn: TBitBtn
    Left = 480
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 3
    Kind = bkCancel
  end
  object AgentBox: TEdit
    Left = 40
    Top = 40
    Width = 49
    Height = 21
    TabOrder = 4
    Text = '0000'
  end
  object CalcBtn: TBitBtn
    Left = 312
    Top = 88
    Width = 105
    Height = 25
    Caption = 'Calc Commission'
    TabOrder = 5
  end
  object DataSource1: TDataSource
    Left = 64
    Top = 96
  end
end
