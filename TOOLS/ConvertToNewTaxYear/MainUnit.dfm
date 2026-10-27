object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Convert to new tax year'
  ClientHeight = 430
  ClientWidth = 726
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    726
    430)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 104
    Height = 13
    Caption = 'New Tax Year Folder:'
  end
  object btnSelectFolder: TSpeedButton
    Left = 691
    Top = 13
    Width = 23
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '..'
    OnClick = btnSelectFolderClick
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 94
    Height = 13
    Caption = 'Detected Tax Year:'
  end
  object lblNote: TLabel
    Left = 16
    Top = 64
    Width = 698
    Height = 13
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblStatus: TLabel
    Left = 16
    Top = 381
    Width = 698
    Height = 13
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edFolder: TEdit
    Left = 128
    Top = 13
    Width = 561
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Color = clInactiveBorder
    ReadOnly = True
    TabOrder = 0
    OnChange = edFolderChange
  end
  object edYear: TEdit
    Left = 128
    Top = 37
    Width = 65
    Height = 21
    Color = clInactiveBorder
    ReadOnly = True
    TabOrder = 1
  end
  object meLog: TMemo
    Left = 16
    Top = 88
    Width = 698
    Height = 286
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object pbMain: TProgressBar
    Left = 16
    Top = 400
    Width = 698
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
  end
  object btnStart: TButton
    Left = 639
    Top = 37
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Start'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = btnStartClick
  end
end
