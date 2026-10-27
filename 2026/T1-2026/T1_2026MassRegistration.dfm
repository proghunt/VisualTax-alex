object MassRegistrationT1_2026: TMassRegistrationT1_2026
  Left = 199
  Top = 94
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Mass Registration'
  ClientHeight = 573
  ClientWidth = 898
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 0
    Top = 281
    Width = 898
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 841
    ExplicitTop = 323
    ExplicitWidth = 203
  end
  object pnlCaption: TPanel
    Left = 0
    Top = 0
    Width = 898
    Height = 37
    Align = alTop
    Caption = 'Mass Registration of your clients to your Virtual Tax Office'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 526
    Width = 898
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
      Left = 608
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
        Caption = 'Register and Email to clients'
        Default = True
        TabOrder = 0
        OnClick = btnRegisterClick
      end
    end
    object pnlProgress: TPanel
      Left = 1
      Top = 1
      Width = 607
      Height = 45
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object lbProgress: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 26
        Width = 126
        Height = 16
        Align = alLeft
        Caption = 'Processed 10 of 5000'
        Layout = tlCenter
        ExplicitTop = 3
      end
      object lbTime: TLabel
        AlignWithMargins = True
        Left = 147
        Top = 26
        Width = 83
        Height = 16
        Margins.Left = 15
        Align = alLeft
        Caption = 'Elapsed Time:'
        Layout = tlCenter
      end
      object pbProgress: TProgressBar
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 601
        Height = 17
        Align = alTop
        TabOrder = 0
      end
    end
  end
  object grPayers: TDBGrid
    Left = 0
    Top = 37
    Width = 898
    Height = 244
    Align = alTop
    DataSource = dsPayers
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    PopupMenu = pmGrid
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'System'
    TitleFont.Style = []
    OnDrawColumnCell = grPayersDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'LAST_NAME'
        Title.Caption = 'Last Name'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Arial'
        Title.Font.Style = []
        Width = 193
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FIRST_NAME'
        Title.Caption = 'First Name'
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -13
        Title.Font.Name = 'Arial'
        Title.Font.Style = []
        Width = 160
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
        Width = 222
        Visible = True
      end>
  end
  object pnlTemplate: TPanel
    Left = 0
    Top = 286
    Width = 898
    Height = 240
    Align = alClient
    TabOrder = 3
    object pnlTemplateHeader: TPanel
      Left = 1
      Top = 1
      Width = 896
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
        896
        35)
      object lbTemplateCaption: TLabel
        AlignWithMargins = True
        Left = 104
        Top = 4
        Width = 143
        Height = 27
        Align = alLeft
        Caption = 'Mass Email Wording'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitHeight = 16
      end
      object btnSendTestEmail: TSpeedButton
        Left = 205
        Top = 27
        Width = 201
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Send test email to your address'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        OnClick = btnSendTestEmailClick
        ExplicitLeft = 153
      end
      object btnCreateOwn: TSpeedButton
        Left = 393
        Top = 4
        Width = 161
        Height = 25
        Caption = 'Create my own wording'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = btnCreateOwnClick
      end
      object btnResetToDefault: TSpeedButton
        Left = 560
        Top = 4
        Width = 216
        Height = 25
        Caption = 'Initialize My Own with the Default'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        OnClick = btnResetToDefaultClick
      end
      object rbDefault: TRadioButton
        Left = 251
        Top = 10
        Width = 65
        Height = 17
        Caption = 'Default'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = rbDefaultClick
      end
      object rbOwn: TRadioButton
        Left = 322
        Top = 10
        Width = 65
        Height = 17
        Caption = 'My own'
        Enabled = False
        TabOrder = 1
        OnClick = rbDefaultClick
      end
      object btnHelp: TButton
        Left = 814
        Top = 4
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Help'
        TabOrder = 2
        OnClick = btnHelpClick
      end
      object cbSendEmail: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 1
        Width = 97
        Height = 33
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = 'Send Email'
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 3
        Visible = False
        OnClick = cbSendEmailClick
      end
    end
    object pnlPreview: TPanel
      Left = 1
      Top = 36
      Width = 896
      Height = 203
      Align = alClient
      TabOrder = 1
      object wbPreview: TWebBrowser
        Left = 1
        Top = 1
        Width = 894
        Height = 201
        Align = alClient
        TabOrder = 0
        OnCommandStateChange = wbPreviewCommandStateChange
        OnBeforeNavigate2 = wbPreviewBeforeNavigate2
        ExplicitLeft = 32
        ExplicitTop = 69
        ExplicitWidth = 300
        ExplicitHeight = 150
        ControlData = {
          4C000000665C0000C61400000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
  object QPayers: TADMemTable
    AfterScroll = QPayersAfterScroll
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 104
    Top = 160
    object QPayersLAST_NAME: TStringField
      FieldName = 'LAST_NAME'
      Size = 255
    end
    object QPayersFIRST_NAME: TStringField
      FieldName = 'FIRST_NAME'
      Size = 255
    end
    object QPayersEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 255
    end
    object QPayersRESULT: TStringField
      FieldName = 'RESULT'
      Size = 255
    end
    object QPayersREGISTERED: TBooleanField
      FieldName = 'REGISTERED'
    end
    object QPayersERROR: TBooleanField
      FieldName = 'ERROR'
    end
  end
  object dsPayers: TDataSource
    DataSet = QPayers
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
  object pmGrid: TPopupMenu
    Left = 384
    Top = 160
    object Resendregistrationemail1: TMenuItem
      Caption = 'Resend registration email'
      OnClick = Resendregistrationemail1Click
    end
  end
end
