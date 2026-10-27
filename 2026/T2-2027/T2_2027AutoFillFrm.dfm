object AutoFillFrmT2_2027: TAutoFillFrmT2_2027
  Left = 317
  Top = 91
  Caption = 'Auto-fill my return  (TDD - CRA Tax Data Delivery)'
  ClientHeight = 652
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
    Height = 652
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
      object TabControl1: TTabControl
        Left = 0
        Top = 0
        Width = 1128
        Height = 621
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
          Height = 593
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
            Height = 527
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
              527)
            object Label3: TLabel
              Left = 7
              Top = 18
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
              Left = 58
              Top = 18
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
            object Label6: TLabel
              Left = 7
              Top = 39
              Width = 220
              Height = 15
              Caption = 'Most data is in the T2ReturnData group'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object DataGroups: TCheckListBox
              Left = 1
              Top = 63
              Width = 251
              Height = 261
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
              Left = 2
              Top = 347
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
              Top = 495
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
            object AutoFillBtn: TBitBtn
              Left = 35
              Top = 431
              Width = 183
              Height = 26
              Hint = 'Update the tax return with data received and accepted'
              Anchors = [akLeft, akRight, akBottom]
              Caption = '* Post Data Now'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = AutoFillBtnClick
            end
            object RecreateAutofillElmTypesBtn: TBitBtn
              Left = 69
              Top = 330
              Width = 183
              Height = 22
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'Recreate AutofillElmTypes.d'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = -1
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              Visible = False
              OnClick = RecreateAutofillElmTypesBtnClick
            end
            object AFRHELPBTN: TBitBtn
              Left = 35
              Top = 463
              Width = 183
              Height = 26
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'Help by CRA'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
              OnClick = AFRHELPBTNClick
            end
          end
          object GridGroup: TGroupBox
            Left = 260
            Top = 15
            Width = 858
            Height = 527
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
              Height = 507
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
              OnDrawCell = StringGridDrawCell
              OnMouseUp = StringGrid1MouseUp
              ColWidths = (
                64
                233
                116
                116
                172
                64)
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
            Top = 542
            Width = 1116
            Height = 49
            Align = alBottom
            TabOrder = 3
            DesignSize = (
              1116
              49)
            object Label2: TLabel
              Left = 29
              Top = 4
              Width = 504
              Height = 15
              Caption = 
                'Posting of  Accepted data groups will replace the corresponding ' +
                'data boxes of the Tax Return'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label4: TLabel
              Left = 17
              Top = 6
              Width = 6
              Height = 19
              Caption = '*'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -16
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label5: TLabel
              Left = 29
              Top = 18
              Width = 741
              Height = 15
              Caption = 
                'The individual schedules of the T2ReturnData group can be Accept' +
                'ed - NonAccepted (checked-unchecked) at the last column of the g' +
                'rid '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
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
