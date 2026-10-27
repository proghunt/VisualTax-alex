object AutoFillFrmT1_2026: TAutoFillFrmT1_2026
  Left = 317
  Top = 91
  Caption = 'Auto-fill my return  (TDD - CRA Tax Data Delivery)'
  ClientHeight = 620
  ClientWidth = 1136
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1136
    Height = 620
    ActivePage = TabSheet2
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = 'AutoFill'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TabControl1: TTabControl
        Left = 0
        Top = 0
        Width = 1128
        Height = 589
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MultiLine = True
        ParentFont = False
        TabOrder = 0
        Tabs.Strings = (
          '')
        TabIndex = 0
        OnMouseDown = TabControl1MouseDown
        object GroupBox5: TGroupBox
          Left = 4
          Top = 24
          Width = 1120
          Height = 561
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object FillReturnFromFileBtn: TBitBtn
            Left = 28
            Top = 504
            Width = 106
            Height = 23
            Caption = 'OLD-Auto-fill now'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = -1
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object AutoFillSectionsGroup: TGroupBox
            Left = 2
            Top = 15
            Width = 258
            Height = 495
            Align = alLeft
            Caption = 'Data groups received'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            DesignSize = (
              258
              495)
            object Label3: TLabel
              Left = 7
              Top = 42
              Width = 45
              Height = 15
              Caption = 'REVIEW'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label1: TLabel
              Left = 56
              Top = 42
              Width = 193
              Height = 15
              Caption = '(Click a description to see the data)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object DataGroups: TCheckListBox
              Left = 2
              Top = 63
              Width = 251
              Height = 194
              OnClickCheck = DataGroupsClickCheck
              Anchors = [akLeft, akTop, akRight, akBottom]
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ItemHeight = 15
              ParentFont = False
              Sorted = True
              TabOrder = 0
              OnClick = DataGroupsClick
            end
            object AutoFillAcceptGroup: TRadioGroup
              Left = 3
              Top = 263
              Width = 232
              Height = 78
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'ACCEPT'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              Items.Strings = (
                'Accept ALL data groups above'
                'Accept SOME (check boxes above)'
                'Accept NONE')
              ParentFont = False
              TabOrder = 1
              OnClick = AutoFillAcceptGroupClick
            end
            object Exit2Btn: TBitBtn
              Left = 35
              Top = 463
              Width = 183
              Height = 26
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'Exit'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = -1
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ModalResult = 2
              ParentFont = False
              TabOrder = 2
              OnClick = Exit2BtnClick
            end
            object HelpBtn: TBitBtn
              Left = 35
              Top = 410
              Width = 183
              Height = 26
              Hint = 'Explain Auto-fill data'
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'VT Auto-Fill Guide'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = HelpBtnClick
            end
            object AutoFillBtn: TBitBtn
              Left = 35
              Top = 361
              Width = 183
              Height = 26
              Hint = 'Update the tax return with data received and accepted'
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'Auto-fill the tax return'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = AutoFillBtnClick
            end
          end
          object GridGroup: TGroupBox
            Left = 260
            Top = 15
            Width = 858
            Height = 495
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            object StringGrid1: TStringGrid
              Left = 2
              Top = 18
              Width = 854
              Height = 475
              Align = alClient
              ColCount = 6
              DrawingStyle = gdsClassic
              RowCount = 25
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goThumbTracking]
              ParentFont = False
              TabOrder = 0
              OnClick = StringGrid1Click
              OnDrawCell = StringGridDrawCell
              ColWidths = (
                64
                233
                116
                116
                172
                31)
              RowHeights = (
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24
                24)
            end
          end
          object Panel1: TPanel
            Left = 2
            Top = 510
            Width = 1116
            Height = 49
            Align = alBottom
            TabOrder = 3
            DesignSize = (
              1116
              49)
            object ExitBtn2: TBitBtn
              Left = 992
              Top = 6
              Width = 113
              Height = 35
              Anchors = [akTop, akRight]
              Caption = 'Exit'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = -1
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ModalResult = 2
              ParentFont = False
              TabOrder = 0
              OnClick = ExitBtn1Click
            end
            object ViewReturnBtn: TBitBtn
              Left = 848
              Top = 6
              Width = 129
              Height = 35
              Anchors = [akTop, akRight]
              Caption = 'View return'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = -1
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Visible = False
            end
          end
        end
      end
    end
  end
  object OpenDialog: TOpenDialog
    Left = 931
    Top = 42
  end
end
