object RetSumT1_2026: TRetSumT1_2026
  Left = 199
  Top = 94
  BorderIcons = [biSystemMenu, biMaximize]
  ClientHeight = 573
  ClientWidth = 846
  Color = 15269887
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object StringGrid1: TStringGrid
    Left = 0
    Top = 27
    Width = 846
    Height = 505
    Align = alClient
    DefaultRowHeight = 16
    DrawingStyle = gdsClassic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking]
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnDblClick = btnOpenFormAndCloseClick
    OnDrawCell = StringGrid1DrawCell
    OnSelectCell = StringGrid1SelectCell
    ExplicitTop = 36
    ExplicitHeight = 675
    RowHeights = (
      16
      16
      16
      16
      16)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 846
    Height = 27
    Align = alTop
    Caption = 'Summary of loaded returns'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 12971774
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 532
    Width = 846
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 328
    ExplicitTop = 0
    ExplicitWidth = 185
    object CancelBtn: TBitBtn
      Left = 751
      Top = 2
      Width = 89
      Height = 32
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
    end
    object ColorCheckBox: TCheckBox
      Left = 15
      Top = 10
      Width = 186
      Height = 17
      Caption = 'Color each return'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ColorCheckBoxClick
    end
    object btnOpenFormAndClose: TBitBtn
      Left = 479
      Top = 2
      Width = 266
      Height = 32
      Caption = 'Open Form and close "R-Sum"'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Times New Roman'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = btnOpenFormAndCloseClick
    end
    object btnOpenForm: TBitBtn
      Tag = 1
      Left = 191
      Top = 2
      Width = 282
      Height = 32
      Caption = 'Open Form without closing "R-Sum"'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Times New Roman'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 3
      OnClick = btnOpenFormAndCloseClick
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 312
    Top = 208
    object miOpenForm: TMenuItem
      Tag = 1
      Caption = 'Open Form without closing "R-Sum"'
      OnClick = btnOpenFormAndCloseClick
    end
    object miOpenFormAndClose: TMenuItem
      Caption = 'Open Form and close "R-Sum"'
      OnClick = btnOpenFormAndCloseClick
    end
  end
end
