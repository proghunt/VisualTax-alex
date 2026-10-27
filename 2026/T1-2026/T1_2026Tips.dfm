object TipT1_2026: TTipT1_2026
  Left = 182
  Top = 141
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Tips'
  ClientHeight = 419
  ClientWidth = 528
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 528
    Height = 419
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Color = 15269887
    TabOrder = 0
    object Label3: TLabel
      Left = 60
      Top = 16
      Width = 99
      Height = 16
      Caption = 'Did you know...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
    end
    object Image1: TImage
      Left = 23
      Top = 8
      Width = 26
      Height = 25
      Picture.Data = {
        07544269746D617096010000424D960100000000000076000000280000001800
        0000180000000100040000000000200100000000000000000000100000000000
        0000000000000000800000800000008080008000000080008000808000008080
        8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00888888888888888888888888888888888888888888888888888888888888
        8888888888888888888888000008888888888888888888000008888888888888
        8888808F77708888888888888888870000078888888888888888808F77708888
        88888888878880000000888788888888883803BB8BB308388888888888870BB8
        B88B0788888888887880B88B8BB8B088788888887880B88B8BB8B08878888888
        830B8BBBB88B8B0388888888880BBBBBBBB8B80888888888830BBBBBBBBB8B03
        88888888780BBBBBBBBBB808788888888880BBBBBBBB80888888888888830BBB
        BBB8038888888888837880000000887388888888837880000000887388888888
        8888888888888888888888888888888888888888888888888888888888888888
        8888}
    end
    object Label1: TLabel
      Left = 30
      Top = 38
      Width = 207
      Height = 15
      Caption = 'For navigation, click the arrows below '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Panel2: TPanel
      Left = 376
      Top = 96
      Width = 66
      Height = 161
      BorderStyle = bsSingle
      TabOrder = 0
      object CancelBtn: TBitBtn
        Left = 9
        Top = 64
        Width = 41
        Height = 25
        Cancel = True
        Caption = 'Exit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ModalResult = 2
        NumGlyphs = 2
        ParentFont = False
        TabOrder = 0
        OnClick = CancelBtnClick
      end
      object SaveBtn: TBitBtn
        Left = 9
        Top = 16
        Width = 41
        Height = 25
        Caption = 'Save'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Ms Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnClick = SaveBtnClick
      end
    end
    object DBMemo1: TDBMemo
      Left = 16
      Top = 72
      Width = 337
      Height = 307
      DataField = 'TIP_TEXT'
      DataSource = DataSource1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object DBNavigator1: TDBNavigator
      Left = 16
      Top = 55
      Width = 312
      Height = 18
      DataSource = DataSource1
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      TabOrder = 2
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 362
    Top = 10
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'tips'
    TableName = 'tips'
    Left = 431
    Top = 37
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=c:\t1\tips.db')
    Left = 471
    Top = 40
  end
end
