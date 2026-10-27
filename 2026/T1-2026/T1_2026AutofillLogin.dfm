object AutoFillLoginT1_2026: TAutoFillLoginT1_2026
  Left = 84
  Top = 154
  Caption = 'AFR (Also lnown as TDD=Tax Data Delivery)'
  ClientHeight = 608
  ClientWidth = 1029
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 1029
    Height = 554
    Align = alClient
    Caption = 'Auto-fill initiation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object AcceptanceGroup: TGroupBox
      Left = 2
      Top = 18
      Width = 1025
      Height = 215
      Align = alTop
      Caption = 'Acceptance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object RadioGroup1: TRadioGroup
        Left = 105
        Top = 224
        Width = 185
        Height = 35
        Caption = 'Accept/Decline'
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Items.Strings = (
          'Accept'
          'Decline')
        ParentFont = False
        TabOrder = 0
      end
      object wbStart: TWebBrowser
        Left = 2
        Top = 18
        Width = 1021
        Height = 195
        Margins.Left = 30
        Margins.Top = 30
        Margins.Right = 30
        Align = alClient
        TabOrder = 1
        OnBeforeNavigate2 = wbStartBeforeNavigate2
        ExplicitWidth = 829
        ExplicitHeight = 397
        ControlData = {
          4C00000086690000271400000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object SinSelectionGroup: TGroupBox
      Left = 2
      Top = 233
      Width = 1025
      Height = 319
      Align = alClient
      Caption = 
        'Select one or more returns (max 10)  for Auto-fill submission to' +
        ' CRA '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      DesignSize = (
        1025
        319)
      object TDDRetList: TCheckListBox
        Left = 3
        Top = 63
        Width = 1019
        Height = 194
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object ConnectToTDDBtn: TBitBtn
        Left = 691
        Top = 21
        Width = 197
        Height = 36
        Anchors = [akTop, akRight]
        Caption = 'Connect to CRA for Auto-fill'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = -1
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = ConnectToTDDBtnClick
      end
      object ClearTDDRetListBtn: TBitBtn
        Left = 31
        Top = 28
        Width = 120
        Height = 29
        Caption = 'Clear the list'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = ClearTDDRetListBtnClick
      end
      object ExitBtn1: TBitBtn
        Left = 930
        Top = 21
        Width = 92
        Height = 36
        Anchors = [akTop, akRight]
        Caption = 'Exit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = -1
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ModalResult = 2
        ParentFont = False
        TabOrder = 4
        OnClick = ExitBtn1Click
      end
      object UncheckBtn: TBitBtn
        Left = 171
        Top = 28
        Width = 120
        Height = 29
        Caption = 'Un-check ALL'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = UncheckBtnClick
      end
      object CRAAutoFillBtn: TBitBtn
        Left = 485
        Top = 273
        Width = 204
        Height = 32
        Caption = 'CRA Auto-fill description'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = CRAAutoFillBtnClick
      end
      object VtAutofillBtn: TBitBtn
        Left = 226
        Top = 274
        Width = 232
        Height = 31
        Caption = 'VisualTax Auto-Fill Guide'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnClick = VtAutofillBtnClick
      end
      object TestOrProductionGroup: TRadioGroup
        Left = 343
        Top = 20
        Width = 239
        Height = 37
        Caption = 'Production or Test'
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          'Production'
          'Test ( Developer)')
        ParentFont = False
        TabOrder = 7
      end
    end
  end
  object TestGroup: TGroupBox
    Left = 0
    Top = 554
    Width = 1029
    Height = 54
    Align = alBottom
    Caption = 'TestGroup'
    Color = clYellow
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    Visible = False
    object TestLabel: TLabel
      Left = 361
      Top = 26
      Width = 158
      Height = 14
      Caption = 'TEST: File received from CRA'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object TestCasesReceivedBox: TEdit
      Left = 525
      Top = 28
      Width = 190
      Height = 21
      TabOrder = 0
      Text = 'TestALL.txt'
      Visible = False
    end
    object LoadReceivedDataBtn: TBitBtn
      Left = 728
      Top = 29
      Width = 183
      Height = 20
      Caption = 'TEST-LoadReceivedDataBtn'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Visible = False
      OnClick = LoadReceivedDataBtnClick
    end
  end
  object OpenDialog: TOpenDialog
    Left = 931
    Top = 42
  end
end
