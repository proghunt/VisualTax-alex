object frmAuthorize: TfrmAuthorize
  Left = 0
  Top = 0
  Caption = 'Generate keys'
  ClientHeight = 457
  ClientWidth = 812
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 12
    Width = 98
    Height = 13
    Caption = 'Root sources folder:'
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 309
    Width = 812
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 37
    ExplicitWidth = 275
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 812
    Height = 37
    Align = alTop
    TabOrder = 0
    DesignSize = (
      812
      37)
    object edtRootSourceFolder: TEdit
      Left = 129
      Top = 8
      Width = 507
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = '..\..'
    end
    object btnBrowse: TButton
      Left = 575
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Browse'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
    object btnRefresh: TButton
      Left = 656
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Refresh'
      TabOrder = 2
      OnClick = btnRefreshClick
    end
  end
  object pgcYears: TPageControl
    Left = 0
    Top = 37
    Width = 812
    Height = 272
    Align = alClient
    TabOrder = 1
  end
  object pnlTools: TPanel
    Left = 0
    Top = 312
    Width = 812
    Height = 145
    Align = alBottom
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 393
      Top = 1
      Height = 143
      ExplicitLeft = 496
      ExplicitTop = 24
      ExplicitHeight = 100
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 392
      Height = 143
      Align = alLeft
      Caption = 'Create single key'
      TabOrder = 0
      DesignSize = (
        392
        143)
      object btnCreateSingleKey: TButton
        Left = 16
        Top = 24
        Width = 121
        Height = 25
        Caption = '1. Create key'
        TabOrder = 0
        OnClick = btnCreateSingleKeyClick
      end
      object btnValidateSingleKey: TButton
        Left = 16
        Top = 51
        Width = 121
        Height = 25
        Caption = '2. Validate key'
        TabOrder = 1
        OnClick = btnValidateSingleKeyClick
      end
      object btnSaveSingleKeyToFile: TButton
        Left = 16
        Top = 102
        Width = 121
        Height = 25
        Caption = '3. Save key to file'
        TabOrder = 2
        OnClick = btnSaveSingleKeyToFileClick
      end
      object edtSingleKey: TEdit
        Left = 160
        Top = 24
        Width = 217
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnChange = btnValidateSingleKeyClick
      end
      object edtSaveSingleKeyLocation: TEdit
        Left = 160
        Top = 102
        Width = 217
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
      end
      object mmoValidateSingleKey: TMemo
        Left = 160
        Top = 51
        Width = 217
        Height = 45
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
      end
    end
    object GroupBox2: TGroupBox
      Left = 396
      Top = 1
      Width = 312
      Height = 143
      Align = alClient
      Caption = 'Generate X keys'
      TabOrder = 1
      object Label3: TLabel
        Left = 6
        Top = 19
        Width = 56
        Height = 13
        Caption = 'No. of Keys'
      end
      object edKeyCount: TSpinEdit
        Left = 68
        Top = 16
        Width = 53
        Height = 22
        MaxValue = 10000
        MinValue = 1
        TabOrder = 0
        Value = 50
      end
      object btnGenerateXKeys: TButton
        Left = 143
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Generate'
        TabOrder = 1
        OnClick = btnGenerateXKeysClick
      end
      object btnPrintXKeys: TButton
        Left = 224
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Print'
        TabOrder = 2
        OnClick = btnPrintXKeysClick
      end
      object lbXKeys: TListBox
        Left = 2
        Top = 47
        Width = 308
        Height = 94
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 3
      end
    end
    object GroupBox3: TGroupBox
      Left = 708
      Top = 1
      Width = 103
      Height = 143
      Align = alRight
      Caption = 'Site'
      TabOrder = 2
      object btnGenerateProductsPHP: TButton
        Left = 6
        Top = 16
        Width = 94
        Height = 33
        Caption = 'Generate "Products.php"'
        TabOrder = 0
        WordWrap = True
        OnClick = btnGenerateProductsPHPClick
      end
    end
  end
end
