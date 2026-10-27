object ExportDataT1_2026: TExportDataT1_2026
  Left = 54
  Top = 80
  BorderIcons = [biSystemMenu, biMaximize]
  ClientHeight = 531
  ClientWidth = 784
  Color = clGray
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Panel3: TPanel
    Left = 0
    Top = 33
    Width = 784
    Height = 496
    Align = alTop
    TabOrder = 0
    object Panel2: TPanel
      Left = 576
      Top = 8
      Width = 209
      Height = 345
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 0
      object Label11: TLabel
        Left = 11
        Top = 8
        Width = 90
        Height = 15
        Caption = 'Exported returns'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object SelectedReturns: TListBox
        Left = 8
        Top = 24
        Width = 193
        Height = 305
        Color = 16777162
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        TabOrder = 0
      end
    end
    object Panel5: TPanel
      Left = 8
      Top = 8
      Width = 281
      Height = 345
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object Label7: TLabel
        Left = 11
        Top = 56
        Width = 64
        Height = 16
        Caption = 'FormName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 91
        Top = 56
        Width = 42
        Height = 16
        Caption = 'Cell No'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 147
        Top = 56
        Width = 63
        Height = 16
        Caption = 'Comments'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object TemplateBox: TEdit
        Left = 12
        Top = 32
        Width = 237
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnExit = TemplateBoxExit
      end
      object SaveBtn: TBitBtn
        Left = 72
        Top = 288
        Width = 113
        Height = 25
        Caption = 'Save Template'
        TabOrder = 1
        OnClick = SaveBtnClick
      end
      object Memo1: TMemo
        Left = 8
        Top = 72
        Width = 265
        Height = 209
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 2
      end
      object SaveAsBox: TEdit
        Left = 8
        Top = 312
        Width = 237
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnExit = TemplateBoxExit
      end
      object BitBtn1: TBitBtn
        Left = 56
        Top = 8
        Width = 129
        Height = 25
        Caption = 'Load Template'
        TabOrder = 4
        OnClick = BitBtn1Click
      end
    end
    object Panel6: TPanel
      Left = 296
      Top = 8
      Width = 273
      Height = 345
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 2
      object Label3: TLabel
        Left = 19
        Top = 177
        Width = 186
        Height = 16
        Caption = #39'Export to'#39'  File Name (Full path)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 43
        Top = 8
        Width = 140
        Height = 15
        Caption = 'Tax returns Data Directory'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 11
        Top = 120
        Width = 58
        Height = 15
        Caption = 'From Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 11
        Top = 136
        Width = 42
        Height = 15
        Caption = 'To Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 99
        Top = 96
        Width = 72
        Height = 15
        Caption = 'Last updated'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 59
        Top = 64
        Width = 135
        Height = 15
        Caption = 'Discounted returns only'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ExportFileBox: TEdit
        Left = 8
        Top = 194
        Width = 257
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnExit = ExportFileBoxExit
      end
      object SelectBtn: TBitBtn
        Left = 24
        Top = 260
        Width = 105
        Height = 33
        Caption = '1. Select returns'
        Default = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 1
        OnClick = SelectBtnClick
      end
      object CancelBtn: TBitBtn
        Left = 84
        Top = 300
        Width = 81
        Height = 33
        Caption = 'Exit'
        Kind = bkCancel
        NumGlyphs = 2
        TabOrder = 2
        OnClick = CancelBtnClick
      end
      object DataDirBox: TEdit
        Left = 4
        Top = 24
        Width = 261
        Height = 23
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnExit = DataDirBoxExit
        OnKeyPress = DataDirBoxKeyPress
      end
      object FromDateBox: TEdit
        Left = 104
        Top = 112
        Width = 73
        Height = 23
        TabOrder = 4
        Text = 'FromDateBox'
      end
      object ToDateBox: TEdit
        Left = 104
        Top = 136
        Width = 73
        Height = 23
        TabOrder = 5
        Text = 'ToDateBox'
      end
      object DiscountedBox: TCheckBox
        Left = 48
        Top = 48
        Width = 169
        Height = 17
        Caption = 'Discounted returns only'
        Checked = True
        State = cbChecked
        TabOrder = 6
        Visible = False
      end
      object ExportBtn: TBitBtn
        Left = 152
        Top = 260
        Width = 97
        Height = 33
        Caption = '2. Export'
        Default = True
        NumGlyphs = 2
        TabOrder = 7
        OnClick = ExportBtnClick
      end
    end
    object DataList: TMemo
      Left = 8
      Top = 360
      Width = 777
      Height = 129
      Color = 14942207
      ScrollBars = ssBoth
      TabOrder = 3
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 33
    Align = alTop
    Caption = 'Export Data'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 552
    Top = 1
  end
  object SaveDialog1: TSaveDialog
    Left = 224
    Top = 8
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 456
    Top = 16
  end
  object Table1: TADTable
    Connection = FDConnection
    Left = 504
    Top = 16
  end
end
