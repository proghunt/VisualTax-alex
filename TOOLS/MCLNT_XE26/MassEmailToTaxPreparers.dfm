object MassEmailToTaxPreparers: TMassEmailToTaxPreparers
  Left = 415
  Top = 205
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Mass Email To Tax Preparers'
  ClientHeight = 573
  ClientWidth = 903
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 361
    Width = 903
    Height = 5
    Cursor = crVSplit
    Align = alTop
  end
  object pnlCaption: TPanel
    Left = 0
    Top = 0
    Width = 903
    Height = 37
    Align = alTop
    Caption = 'Mass Email To Tax Preparers'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 526
    Width = 903
    Height = 47
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object pnlButtons: TPanel
      Left = 613
      Top = 1
      Width = 289
      Height = 45
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnCancel: TButton
        Left = 207
        Top = 9
        Width = 75
        Height = 25
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
      object btnRegister: TButton
        Left = 10
        Top = 9
        Width = 190
        Height = 25
        Caption = 'Send Email to clients'
        TabOrder = 0
        OnClick = btnRegisterClick
      end
    end
    object pnlProgress: TPanel
      Left = 1
      Top = 1
      Width = 612
      Height = 45
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object lbProgress: TLabel
        Left = 0
        Top = 17
        Width = 126
        Height = 28
        Align = alLeft
        Caption = 'Processed 10 of 5000'
        Layout = tlCenter
        ExplicitHeight = 16
      end
      object lbTime: TLabel
        Left = 126
        Top = 17
        Width = 83
        Height = 28
        Align = alLeft
        Caption = 'Elapsed Time:'
        Layout = tlCenter
        ExplicitHeight = 16
      end
      object pbProgress: TProgressBar
        Left = 0
        Top = 0
        Width = 612
        Height = 17
        Align = alTop
        TabOrder = 0
      end
    end
  end
  object pnlTemplate: TPanel
    Left = 0
    Top = 366
    Width = 903
    Height = 160
    Align = alClient
    TabOrder = 2
    object pnlTemplateHeader: TPanel
      Left = 1
      Top = 1
      Width = 901
      Height = 35
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        901
        35)
      object lbTemplateCaption: TLabel
        Left = 1
        Top = 1
        Width = 147
        Height = 33
        Align = alLeft
        Caption = 'Mass Email Wording:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitHeight = 16
      end
      object Label1: TLabel
        Left = 513
        Top = 9
        Width = 141
        Height = 16
        Anchors = [akTop, akRight]
        Caption = 'Mass Email Subject:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object btnEdit: TSpeedButton
        Left = 385
        Top = 6
        Width = 58
        Height = 24
        Anchors = [akTop, akRight]
        Caption = 'Edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = btnEditClick
      end
      object btnNew: TSpeedButton
        Left = 449
        Top = 6
        Width = 58
        Height = 24
        Anchors = [akTop, akRight]
        Caption = 'New'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = btnNewClick
      end
      object cbMassEmailWording: TComboBox
        Left = 157
        Top = 6
        Width = 220
        Height = 24
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbMassEmailWordingChange
      end
      object edSubject: TEdit
        Left = 660
        Top = 6
        Width = 232
        Height = 24
        Anchors = [akTop, akRight]
        TabOrder = 1
      end
    end
    object pnlPreview: TPanel
      Left = 1
      Top = 36
      Width = 901
      Height = 123
      Align = alClient
      TabOrder = 1
      object wbPreview: TWebBrowser
        Left = 1
        Top = 1
        Width = 899
        Height = 121
        Align = alClient
        TabOrder = 0
        OnCommandStateChange = wbPreviewCommandStateChange
        OnBeforeNavigate2 = wbPreviewBeforeNavigate2
        ControlData = {
          4C000000EA5C0000810C00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
  object pnlFilter: TPanel
    Left = 0
    Top = 37
    Width = 903
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    DesignSize = (
      903
      41)
    object lbWhere: TLabel
      Left = 9
      Top = 12
      Width = 43
      Height = 16
      Caption = 'Where:'
    end
    object btnShowColumns: TSpeedButton
      Left = 631
      Top = 9
      Width = 100
      Height = 24
      Anchors = [akTop, akRight]
      Caption = 'Show columns'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = btnShowColumnsClick
    end
    object edWhere: TEdit
      Left = 59
      Top = 9
      Width = 566
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object btnGetTaxPreparers: TButton
      Left = 740
      Top = 9
      Width = 138
      Height = 24
      Anchors = [akTop, akRight]
      Caption = 'Get Tax Preparers'
      TabOrder = 1
      OnClick = btnGetTaxPreparersClick
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 78
    Width = 903
    Height = 283
    Align = alTop
    TabOrder = 4
    object grOffices: TDBGrid
      Left = 1
      Top = 105
      Width = 901
      Height = 158
      Align = alClient
      DataSource = dsOffices
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'System'
      TitleFont.Style = []
      OnDrawColumnCell = grOfficesDrawColumnCell
      Columns = <
        item
          Expanded = False
          FieldName = 'NAME'
          Title.Caption = 'Name'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 233
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EMAIL'
          Title.Caption = 'Email'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 236
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RESULT'
          Title.Caption = 'Result'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Arial'
          Title.Font.Style = []
          Width = 393
          Visible = True
        end>
    end
    object sbGrid: TStatusBar
      Left = 1
      Top = 263
      Width = 901
      Height = 19
      Panels = <
        item
          Alignment = taCenter
          Text = '0 : 0'
          Width = 100
        end
        item
          Width = 50
        end>
    end
    object meColumns: TMemo
      Left = 1
      Top = 1
      Width = 901
      Height = 104
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object dsOffices: TDataSource
    Left = 104
    Top = 216
  end
  object ThreadTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = ThreadTimerTimer
    Left = 480
    Top = 416
  end
  object SaveWordingDialog: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'Text files (*.txt)|*.txt|All Files (*.*)|*.*'
    Left = 312
    Top = 262
  end
  object QClients: TADQuery
    Connection = dmMain.FConnection
    SQL.Strings = (
      'SELECT * FROM Clients')
    Left = 152
    Top = 78
  end
  object QOffices: TADQuery
    Connection = dmMain.FConnection
    Left = 200
    Top = 94
  end
end
