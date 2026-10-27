object PopTreeViewFP_2012: TPopTreeViewFP_2012
  Left = 141
  Top = 75
  Width = 750
  Height = 603
  BorderIcons = [biSystemMenu]
  Color = 13353654
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object TreeView1: TTreeView
    Left = 0
    Top = 41
    Width = 742
    Height = 496
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    HotTrack = True
    Indent = 19
    ParentFont = False
    TabOrder = 0
    OnDblClick = TreeView1DblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 41
    Align = alTop
    Caption = 'Search Results'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 537
    Width = 742
    Height = 39
    Align = alBottom
    TabOrder = 2
    object OKBtn: TBitBtn
      Left = 248
      Top = 8
      Width = 65
      Height = 25
      TabOrder = 0
      OnClick = OKBtnClick
      Kind = bkOK
    end
    object CancelBtn: TBitBtn
      Left = 344
      Top = 8
      Width = 89
      Height = 25
      TabOrder = 1
      OnClick = CancelBtnClick
      Kind = bkCancel
    end
  end
end
