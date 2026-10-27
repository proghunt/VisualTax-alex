object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Replace Ln'
  ClientHeight = 541
  ClientWidth = 746
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 746
    Height = 105
    Align = alTop
    TabOrder = 0
    DesignSize = (
      746
      105)
    object lbFolder: TLabel
      Left = 16
      Top = 16
      Width = 84
      Height = 13
      Caption = 'Folder to Replace'
    end
    object btnSelectFolder: TSpeedButton
      Left = 711
      Top = 13
      Width = 23
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '..'
      OnClick = btnSelectFolderClick
    end
    object lbFiles: TLabel
      Left = 16
      Top = 48
      Width = 75
      Height = 13
      Caption = 'Files to Replace'
    end
    object lbDelimiter: TLabel
      Left = 248
      Top = 48
      Width = 41
      Height = 13
      Caption = 'Delimiter'
    end
    object Label1: TLabel
      Left = 16
      Top = 79
      Width = 63
      Height = 13
      Caption = 'Delphi 5 Path'
    end
    object btnOpenDelphi5: TSpeedButton
      Left = 711
      Top = 76
      Width = 23
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '..'
      OnClick = btnOpenDelphi5Click
    end
    object btnFromRegistry: TSpeedButton
      Left = 656
      Top = 76
      Width = 54
      Height = 21
      Hint = 'Try to get path to Delphi5 from registry'
      Anchors = [akTop, akRight]
      Caption = 'Registry'
      ParentShowHint = False
      ShowHint = True
      OnClick = btnFromRegistryClick
    end
    object edFolder: TEdit
      Left = 112
      Top = 13
      Width = 593
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 
        'c:\Projects\Outsource\Customers\VisualTax\VisualTax_V2\2019\T1-2' +
        '019\'
    end
    object edFiles: TEdit
      Left = 112
      Top = 45
      Width = 89
      Height = 21
      TabOrder = 1
      Text = '*.pas'
    end
    object edDelimiter: TEdit
      Left = 304
      Top = 45
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '='
    end
    object cbRevert: TCheckBox
      Left = 454
      Top = 47
      Width = 166
      Height = 17
      Caption = 'Revert from new codes to old'
      TabOrder = 3
    end
    object edDelphi5: TEdit
      Left = 112
      Top = 76
      Width = 538
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 424
    Width = 746
    Height = 117
    Align = alBottom
    TabOrder = 1
    object btnReplace: TButton
      Left = 536
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Replace'
      Enabled = False
      TabOrder = 0
      OnClick = btnReplaceClick
    end
    object btnAddSpace: TButton
      Left = 118
      Top = 48
      Width = 111
      Height = 25
      Caption = 'Add Space on Pos'
      Enabled = False
      TabOrder = 1
      OnClick = btnAddSpaceClick
    end
    object SpacePos: TSpinEdit
      Left = 235
      Top = 50
      Width = 33
      Height = 22
      Enabled = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 4
    end
    object cbOnlyFirst: TCheckBox
      Left = 428
      Top = 52
      Width = 65
      Height = 17
      Caption = 'Only first'
      Enabled = False
      TabOrder = 3
    end
    object FirstChars: TSpinEdit
      Left = 498
      Top = 50
      Width = 33
      Height = 22
      Enabled = False
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 5
    end
    object btnReplacePas: TButton
      Left = 13
      Top = 9
      Width = 127
      Height = 25
      Caption = 'Replace .pas files'
      TabOrder = 5
      OnClick = btnReplacePasClick
    end
    object btnReplaceD: TButton
      Left = 145
      Top = 9
      Width = 127
      Height = 25
      Caption = 'Replace .d files'
      TabOrder = 6
      OnClick = btnReplaceDClick
    end
    object btnReplaceRtf: TButton
      Left = 278
      Top = 9
      Width = 127
      Height = 25
      Caption = 'Replace .rtf files'
      TabOrder = 7
      OnClick = btnReplaceRtfClick
    end
    object btnReplaceDfm: TButton
      Left = 410
      Top = 9
      Width = 127
      Height = 25
      Caption = 'Replace .dfm files'
      TabOrder = 8
      OnClick = btnReplaceDfmClick
    end
    object cbDeveloperMode: TCheckBox
      Left = 13
      Top = 52
      Width = 100
      Height = 17
      Caption = 'Developer mode'
      TabOrder = 9
      OnClick = cbDeveloperModeClick
    end
    object cbReplaceSpaceBeforeReplace: TCheckBox
      Left = 277
      Top = 52
      Width = 146
      Height = 17
      Caption = 'Space to ~ before replace'
      Enabled = False
      TabOrder = 10
    end
    object pbProgress: TProgressBar
      AlignWithMargins = True
      Left = 11
      Top = 89
      Width = 724
      Height = 17
      Margins.Left = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alBottom
      TabOrder = 11
    end
    object GroupBox1: TGroupBox
      Left = 617
      Top = 6
      Width = 118
      Height = 80
      Caption = 'DFM Convert'
      TabOrder = 12
      object btnBinaryToText: TButton
        Left = 15
        Top = 17
        Width = 91
        Height = 25
        Caption = 'Binary > Text'
        TabOrder = 0
        OnClick = btnBinaryToTextClick
      end
      object btnTextToBinary: TButton
        Left = 15
        Top = 48
        Width = 91
        Height = 25
        Caption = 'Text > Binary'
        TabOrder = 1
        OnClick = btnBinaryToTextClick
      end
    end
    object cbOneByOne: TCheckBox
      Left = 540
      Top = 13
      Width = 75
      Height = 17
      Hint = 
        'Works only for DFM mode. If checked, opens dfm after replace and' +
        ' asks to continue'
      Caption = 'One by one'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
    end
  end
  object pnlCenter: TPanel
    Left = 0
    Top = 105
    Width = 746
    Height = 319
    Align = alClient
    TabOrder = 2
    ExplicitTop = 81
    ExplicitHeight = 343
    object meReplace: TMemo
      Left = 1
      Top = 1
      Width = 744
      Height = 137
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitHeight = 161
    end
    object meLog: TMemo
      Left = 1
      Top = 138
      Width = 744
      Height = 180
      Align = alBottom
      ScrollBars = ssVertical
      TabOrder = 1
      ExplicitTop = 162
    end
  end
  object OpenDelphi5Dialog: TOpenDialog
    Filter = 
      'Delphi 5 Executable (delphi32.exe)|delphi32.exe|All Files (*.*)|' +
      '*.*'
    Left = 632
    Top = 145
  end
end
