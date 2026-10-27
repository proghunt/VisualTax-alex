object CommissionStatementsFrm: TCommissionStatementsFrm
  Left = 79
  Top = 60
  Caption = 'CommissionStatementsFrm'
  ClientHeight = 492
  ClientWidth = 657
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
  object Panel1: TPanel
    Left = 352
    Top = 40
    Width = 305
    Height = 417
    TabOrder = 0
    object AgentNameLbl: TLabel
      Left = 24
      Top = 24
      Width = 233
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = '???'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 128
      Top = 8
      Width = 28
      Height = 13
      Caption = 'Agent'
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 56
      Width = 257
      Height = 49
      Caption = 'Statement Dates'
      TabOrder = 0
      object Label3: TLabel
        Left = 18
        Top = 24
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label4: TLabel
        Left = 140
        Top = 24
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object FromDateBox: TEdit
        Left = 48
        Top = 16
        Width = 81
        Height = 21
        TabOrder = 0
      end
      object ToDateBox: TEdit
        Left = 160
        Top = 16
        Width = 81
        Height = 21
        TabOrder = 1
      end
    end
    object CancelBtn: TBitBtn
      Left = 110
      Top = 328
      Width = 67
      Height = 33
      Caption = 'Exit'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object ScopeBox: TRadioGroup
      Left = 24
      Top = 368
      Width = 225
      Height = 33
      Caption = 'Scope'
      Items.Strings = (
        'Selected Agent'
        'All Agents of Branch'
        'All Agents, All Branches')
      TabOrder = 2
      Visible = False
    end
    object GroupBox1: TGroupBox
      Left = 136
      Top = 136
      Width = 145
      Height = 129
      Caption = 'Print'
      TabOrder = 3
      object PrintOneBtn: TBitBtn
        Left = 8
        Top = 40
        Width = 129
        Height = 33
        Caption = 'Print selected'
        Glyph.Data = {
          56020000424D5602000000000000760000002800000024000000180000000100
          040000000000E001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888880000888888888888888888888888888888888888
          0000888888888888888888888888888888888888000088888888888888888888
          8888888888888888000088888877000000000000000007788888888800008888
          8800000000000000000000078888888800008888877777777777777777777770
          788888880000888887F888888888888888888777078888880000888887F88888
          8888888889988777707888880000888887F88888888888888998877777088888
          0000888887F8CCCC8888888889988777770888880000888887F8888888888888
          88888877770888880000888887FFFFFFFFFFFFFFFFF888877708888800008888
          878FFFFFFFFFFFFFFFF8888877088888000088888878FF000000000000008888
          870888880000888888878FF07FFFFFFFFF707888880888880000888888887888
          74444444FF7007888708888800008888888887007FFFFFFFFF70000000888888
          00008888888888887F4444444F7888888888888800008888888888887FFFFFFF
          FF78888888888888000088888888888887F4444444F788888888888800008888
          8888888887FFFFFFFFF788888888888800008888888888888888888888888888
          8888888800008888888888888888888888888888888888880000}
        TabOrder = 0
      end
      object MarkAsPaidBox: TCheckBox
        Left = 8
        Top = 16
        Width = 113
        Height = 17
        Caption = 'Mark As '#39'PAID'#39
        Enabled = False
        TabOrder = 1
      end
      object PrintAllBtn: TBitBtn
        Left = 8
        Top = 80
        Width = 129
        Height = 33
        Caption = 'Print All Agents'
        Glyph.Data = {
          56020000424D5602000000000000760000002800000024000000180000000100
          040000000000E001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888880000888888888888888888888888888888888888
          0000888888888888888888888888888888888888000088888888888888888888
          8888888888888888000088888877000000000000000007788888888800008888
          8800000000000000000000078888888800008888877777777777777777777770
          788888880000888887F888888888888888888777078888880000888887F88888
          8888888889988777707888880000888887F88888888888888998877777088888
          0000888887F8CCCC8888888889988777770888880000888887F8888888888888
          88888877770888880000888887FFFFFFFFFFFFFFFFF888877708888800008888
          878FFFFFFFFFFFFFFFF8888877088888000088888878FF000000000000008888
          870888880000888888878FF07FFFFFFFFF707888880888880000888888887888
          74444444FF7007888708888800008888888887007FFFFFFFFF70000000888888
          00008888888888887F4444444F7888888888888800008888888888887FFFFFFF
          FF78888888888888000088888888888887F4444444F788888888888800008888
          8888888887FFFFFFFFF788888888888800008888888888888888888888888888
          8888888800008888888888888888888888888888888888880000}
        TabOrder = 2
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 136
      Width = 113
      Height = 129
      Caption = 'Screen view'
      TabOrder = 4
      object OkBtn: TBitBtn
        Left = 8
        Top = 80
        Width = 97
        Height = 33
        Caption = 'Preview Statement'
        TabOrder = 0
      end
      object CalcAgentCommissionBtn: TBitBtn
        Left = 8
        Top = 40
        Width = 97
        Height = 33
        Caption = 'Show Commission'
        TabOrder = 1
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 657
    Height = 25
    Align = alTop
    BevelOuter = bvLowered
    Caption = 'Commission Statements'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 8
    Top = 40
    Width = 329
    Height = 417
    TabOrder = 2
    object TreeView1: TTreeView
      Left = 8
      Top = 8
      Width = 305
      Height = 393
      Color = 16777198
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HotTrack = True
      Indent = 19
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 152
    Top = 160
  end
  object DataSource2: TDataSource
    DataSet = TransactionsQ
    Left = 200
    Top = 240
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 125
    Top = 297
  end
  object TransactionsQ: TADQuery
    Connection = FDConnection
    Left = 180
    Top = 299
  end
  object Query1: TADQuery
    Connection = FDConnection
    SQL.Strings = (
      'Select *  from Agents a, BranchOffices b'
      'where a.Branch = b.branch '
      'ORDER BY b.BranchName, a.LastName')
    Left = 52
    Top = 155
  end
end
