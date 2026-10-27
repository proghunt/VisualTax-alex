object frmConvertToMultiApp: TfrmConvertToMultiApp
  Left = 0
  Top = 0
  Caption = 
    'Convert your current VisualTax To MultiApp Version (Configuratio' +
    'n Options, Program Key and Tax Returns)'
  ClientHeight = 697
  ClientWidth = 1012
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblTaxModule: TLabel
    Left = 0
    Top = 0
    Width = 1012
    Height = 23
    Align = alTop
    Alignment = taCenter
    Caption = 'Tax module to be converted:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 274
  end
  object Splitter1: TSplitter
    Left = 417
    Top = 23
    Width = 6
    Height = 633
    Color = clRed
    ParentColor = False
    ExplicitLeft = 422
  end
  object Panel1: TPanel
    Left = 0
    Top = 23
    Width = 417
    Height = 633
    Align = alLeft
    TabOrder = 0
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 91
      Height = 19
      Align = alTop
      Alignment = taCenter
      Caption = 'Old version'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 20
      Width = 415
      Height = 270
      Align = alTop
      Caption = 'Program options'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        415
        270)
      object Label3: TLabel
        Left = 11
        Top = 36
        Width = 48
        Height = 13
        Caption = 'Location'
      end
      object Label4: TLabel
        Left = 11
        Top = 58
        Width = 37
        Height = 13
        Caption = 'Values'
      end
      object chkUseOptions: TCheckBox
        Left = 11
        Top = 16
        Width = 214
        Height = 17
        Caption = 'Use for vt2015 version'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = chkUseOptionsClick
      end
      object edtLocation: TEdit
        Left = 56
        Top = 33
        Width = 354
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object lbOptions: TListBox
        Left = 2
        Top = 77
        Width = 411
        Height = 191
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 290
      Width = 415
      Height = 64
      Align = alTop
      Caption = 'Program license key'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      DesignSize = (
        415
        64)
      object chkUseKey: TCheckBox
        Left = 11
        Top = 16
        Width = 214
        Height = 17
        Caption = 'Use for vt2015 version'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = chkUseKeyClick
      end
      object edtKey: TEdit
        Left = 11
        Top = 40
        Width = 298
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 1
      end
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 354
      Width = 415
      Height = 278
      Align = alClient
      Caption = 'Tax Returns'
      TabOrder = 2
      object chlbReturns: TCheckListBox
        Left = 2
        Top = 43
        Width = 411
        Height = 233
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        PopupMenu = PopupMenu1
        TabOrder = 0
      end
      object rbAllReturns: TRadioButton
        Left = 15
        Top = 20
        Width = 33
        Height = 17
        Caption = 'All'
        TabOrder = 1
        OnClick = rbNoneReturnsClick
      end
      object rbSomeReturns: TRadioButton
        Left = 54
        Top = 20
        Width = 47
        Height = 17
        Caption = 'Some'
        TabOrder = 2
        OnClick = rbNoneReturnsClick
      end
      object rbNoneReturns: TRadioButton
        Left = 107
        Top = 20
        Width = 54
        Height = 17
        Caption = 'None'
        TabOrder = 3
        OnClick = rbNoneReturnsClick
      end
      object chkBackUp: TCheckBox
        Left = 198
        Top = 20
        Width = 212
        Height = 17
        Caption = 'Create Backup copy before conversion'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
    end
  end
  object Panel2: TPanel
    Left = 423
    Top = 23
    Width = 589
    Height = 633
    Align = alClient
    TabOrder = 1
    object Label5: TLabel
      Left = 1
      Top = 1
      Width = 100
      Height = 19
      Align = alTop
      Alignment = taCenter
      Caption = 'New version'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox4: TGroupBox
      Left = 1
      Top = 20
      Width = 587
      Height = 270
      Align = alTop
      Caption = 'Program options'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        587
        270)
      object Label6: TLabel
        Left = 11
        Top = 36
        Width = 48
        Height = 13
        Caption = 'Location'
      end
      object Label7: TLabel
        Left = 11
        Top = 58
        Width = 185
        Height = 13
        Caption = 'Values (                                             )'
      end
      object Label1: TLabel
        Left = 59
        Top = 58
        Width = 130
        Height = 13
        Caption = 'Double click for change'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtvt2015tLocation: TEdit
        Left = 65
        Top = 33
        Width = 509
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
      end
      object lbvt2015Options: TListBox
        Left = 2
        Top = 80
        Width = 583
        Height = 172
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 1
        OnDblClick = lbvt2015OptionsDblClick
      end
      object pbOptions: TProgressBar
        Left = 2
        Top = 252
        Width = 583
        Height = 16
        Align = alBottom
        TabOrder = 2
      end
      object chkResetDefault: TCheckBox
        Left = 11
        Top = 16
        Width = 150
        Height = 17
        Caption = 'Reset to default options'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = chkUseOptionsClick
      end
    end
    object GroupBox5: TGroupBox
      Left = 1
      Top = 290
      Width = 587
      Height = 64
      Align = alTop
      Caption = 'Program license key'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      DesignSize = (
        587
        64)
      object lblLicenseName: TLabel
        Left = 434
        Top = 43
        Width = 91
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'XXXXXXXXXXXXX'
        ExplicitLeft = 416
      end
      object edtvt2015Key: TEdit
        Left = 11
        Top = 40
        Width = 418
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        OnChange = edtvt2015KeyChange
      end
    end
    object GroupBox6: TGroupBox
      Left = 1
      Top = 354
      Width = 587
      Height = 278
      Align = alClient
      Caption = 'Tax Returns'
      TabOrder = 2
      object pbConvert: TProgressBar
        Left = 2
        Top = 259
        Width = 583
        Height = 17
        Align = alBottom
        TabOrder = 0
      end
      object chkOverwrite: TCheckBox
        Left = 11
        Top = 20
        Width = 146
        Height = 17
        Caption = 'Replace existing returns'
        TabOrder = 1
      end
      object lchbvt2015Returns: TListBox
        Left = 2
        Top = 43
        Width = 583
        Height = 216
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 656
    Width = 1012
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      1012
      41)
    object btnOk: TBitBtn
      Left = 769
      Top = 6
      Width = 139
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Start convert'
      Default = True
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnCancel: TBitBtn
      Left = 921
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object btnShowLog: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Show log'
      TabOrder = 2
      Visible = False
      OnClick = btnShowLogClick
    end
    object btnHelp: TBitBtn
      Left = 680
      Top = 6
      Width = 75
      Height = 25
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 3
      OnClick = btnHelpClick
    end
  end
  object pnlLog: TPanel
    Left = 619
    Top = 130
    Width = 364
    Height = 127
    TabOrder = 3
    Visible = False
    OnMouseDown = pnlLogMouseDown
    OnMouseMove = pnlLogMouseMove
    OnMouseUp = pnlLogMouseUp
    DesignSize = (
      364
      127)
    object mmoLog: TMemo
      Left = 8
      Top = 24
      Width = 348
      Height = 63
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object btnCloseLog: TButton
      Left = 272
      Top = 93
      Width = 86
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Hide log'
      TabOrder = 1
      OnClick = btnCloseLogClick
    end
  end
  object Connection: TADOConnection
    Left = 72
    Top = 448
  end
  object Table: TADOTable
    Connection = Connection
    Left = 72
    Top = 496
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 249
    Top = 513
    object mniCheckall: TMenuItem
      Caption = 'Check all'
      OnClick = mniCheckallClick
    end
    object mniUncheckall: TMenuItem
      Caption = 'Uncheck all'
      OnClick = mniUncheckallClick
    end
    object mniInvert: TMenuItem
      Caption = 'Invert'
      OnClick = mniInvertClick
    end
  end
end
