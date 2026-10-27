object ClientBookFP_2012: TClientBookFP_2012
  Left = 105
  Top = 126
  Caption = 'FP Clients'
  ClientHeight = 538
  ClientWidth = 793
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BookBack: TShape
    Left = 8
    Top = 91
    Width = 777
    Height = 441
    Brush.Color = clGray
    Shape = stRoundRect
  end
  object RPanel: TPanel
    Left = 408
    Top = 115
    Width = 337
    Height = 393
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 8
      Top = 8
      Width = 321
      Height = 377
      ActivePage = TabSheet1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MultiLine = True
      ParentFont = False
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Identification'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel1: TPanel
          Left = 8
          Top = -8
          Width = 305
          Height = 353
          Color = 12971774
          TabOrder = 0
          object GroupBox1: TGroupBox
            Left = 8
            Top = 16
            Width = 289
            Height = 121
            Caption = 'Name'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 0
            object Label1: TLabel
              Left = 8
              Top = 80
              Width = 16
              Height = 14
              Caption = 'SIN'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 8
              Top = 16
              Width = 51
              Height = 14
              Caption = 'Last Name'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 8
              Top = 32
              Width = 51
              Height = 14
              Caption = 'First Name'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label4: TLabel
              Left = 8
              Top = 48
              Width = 47
              Height = 14
              Caption = 'Birth Date'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label12: TLabel
              Left = 8
              Top = 96
              Width = 46
              Height = 14
              Caption = 'File Name'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label30: TLabel
              Left = 8
              Top = 64
              Width = 31
              Height = 14
              Caption = 'Marital'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object DBEdit2: TDBEdit
              Left = 72
              Top = 80
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'SIN'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 0
            end
            object DBEdit12: TDBEdit
              Left = 72
              Top = 16
              Width = 177
              Height = 17
              BorderStyle = bsNone
              DataField = 'LAST_NAME'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 1
            end
            object DBEdit1: TDBEdit
              Left = 72
              Top = 32
              Width = 177
              Height = 17
              BorderStyle = bsNone
              DataField = 'FIRST_NAME'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 2
            end
            object DBEdit3: TDBEdit
              Left = 72
              Top = 48
              Width = 73
              Height = 17
              BorderStyle = bsNone
              DataField = 'BIRTHDATE'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 3
            end
            object DBEdit11: TDBEdit
              Left = 72
              Top = 96
              Width = 209
              Height = 17
              BorderStyle = bsNone
              DataField = 'FILE_NAME'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 4
            end
            object DBEdit33: TDBEdit
              Left = 72
              Top = 64
              Width = 121
              Height = 17
              BorderStyle = bsNone
              DataField = 'CalcMarStatus'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 5
            end
          end
          object GroupBox2: TGroupBox
            Left = 8
            Top = 144
            Width = 289
            Height = 89
            Caption = 'Address'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 1
            object Label5: TLabel
              Left = 8
              Top = 16
              Width = 29
              Height = 14
              Caption = 'Street'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 8
              Top = 48
              Width = 18
              Height = 14
              Caption = 'City'
              FocusControl = DBEdit5
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 8
              Top = 64
              Width = 42
              Height = 14
              Caption = 'Province'
              FocusControl = DBEdit6
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 136
              Top = 64
              Width = 54
              Height = 14
              Caption = 'PostalCode'
              FocusControl = DBEdit7
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label31: TLabel
              Left = 8
              Top = 32
              Width = 50
              Height = 14
              Caption = 'Apartment'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object DBEdit4: TDBEdit
              Left = 72
              Top = 16
              Width = 177
              Height = 17
              BorderStyle = bsNone
              DataField = 'Street'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 0
            end
            object DBEdit5: TDBEdit
              Left = 72
              Top = 48
              Width = 169
              Height = 17
              BorderStyle = bsNone
              DataField = 'City'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 1
            end
            object DBEdit6: TDBEdit
              Left = 72
              Top = 64
              Width = 57
              Height = 17
              BorderStyle = bsNone
              DataField = 'Province'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 2
            end
            object DBEdit7: TDBEdit
              Left = 192
              Top = 64
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'POSTAL'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 3
            end
            object DBEdit34: TDBEdit
              Left = 72
              Top = 32
              Width = 177
              Height = 17
              BorderStyle = bsNone
              DataField = 'APARTMENT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 4
            end
          end
          object GroupBox4: TGroupBox
            Left = 4
            Top = 304
            Width = 293
            Height = 41
            Caption = 'Notes'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 2
            object DBEdit16: TDBEdit
              Left = 8
              Top = 18
              Width = 249
              Height = 17
              BorderStyle = bsNone
              DataField = 'NOTES'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
          end
          object GroupBox7: TGroupBox
            Left = 4
            Top = 240
            Width = 293
            Height = 57
            Caption = 'Phone/Fax'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 3
            object Label10: TLabel
              Left = 8
              Top = 16
              Width = 30
              Height = 14
              Caption = 'Phone'
              FocusControl = DBEdit9
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label11: TLabel
              Left = 178
              Top = 16
              Width = 18
              Height = 14
              Caption = 'Fax'
              FocusControl = DBEdit10
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label32: TLabel
              Left = 8
              Top = 32
              Width = 24
              Height = 14
              Caption = 'EMail'
              FocusControl = DBEdit9
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object DBEdit9: TDBEdit
              Left = 120
              Top = 16
              Width = 57
              Height = 17
              BorderStyle = bsNone
              DataField = 'Phone'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 0
            end
            object DBEdit10: TDBEdit
              Left = 200
              Top = 16
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'Fax'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 1
            end
            object DBEdit30: TDBEdit
              Left = 80
              Top = 16
              Width = 33
              Height = 17
              BorderStyle = bsNone
              DataField = 'AREA'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 2
            end
            object DBEdit35: TDBEdit
              Left = 48
              Top = 32
              Width = 209
              Height = 17
              BorderStyle = bsNone
              DataField = 'EMAIL'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 3
            end
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Return Status'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel2: TPanel
          Left = 8
          Top = 0
          Width = 305
          Height = 337
          Color = 12971774
          TabOrder = 0
          object GroupBox5: TGroupBox
            Left = 4
            Top = 6
            Width = 293
            Height = 123
            Caption = 'Preparation progress'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 0
            object Label16: TLabel
              Left = 8
              Top = 56
              Width = 41
              Height = 14
              Caption = 'Created '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label18: TLabel
              Left = 8
              Top = 72
              Width = 58
              Height = 14
              Caption = 'Last Update'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label19: TLabel
              Left = 8
              Top = 88
              Width = 33
              Height = 14
              Caption = 'Printed'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label22: TLabel
              Left = 88
              Top = 40
              Width = 13
              Height = 14
              Caption = 'By'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label23: TLabel
              Left = 152
              Top = 40
              Width = 22
              Height = 14
              Caption = 'Date'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label24: TLabel
              Left = 216
              Top = 40
              Width = 22
              Height = 14
              Caption = 'Time'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label28: TLabel
              Left = 8
              Top = 16
              Width = 31
              Height = 14
              Caption = 'Status'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Bevel1: TBevel
              Left = 8
              Top = 48
              Width = 257
              Height = 9
              Shape = bsBottomLine
            end
            object DBEdit14: TDBEdit
              Left = 72
              Top = 56
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'CREATED_BY'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 0
            end
            object DBEdit15: TDBEdit
              Left = 72
              Top = 72
              Width = 57
              Height = 17
              BorderStyle = bsNone
              DataField = 'UPDATED_BY'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 1
            end
            object DBEdit17: TDBEdit
              Left = 72
              Top = 88
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'PRINTED_BY'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 2
            end
            object DBEdit20: TDBEdit
              Left = 136
              Top = 56
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'CREATED_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 3
            end
            object DBEdit21: TDBEdit
              Left = 136
              Top = 72
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'UPDATED_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 4
            end
            object DBEdit22: TDBEdit
              Left = 136
              Top = 88
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'PRINTED_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 5
            end
            object DBEdit25: TDBEdit
              Left = 208
              Top = 56
              Width = 81
              Height = 17
              BorderStyle = bsNone
              DataField = 'CREATED_TM'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 6
            end
            object DBEdit26: TDBEdit
              Left = 208
              Top = 72
              Width = 81
              Height = 17
              BorderStyle = bsNone
              DataField = 'UPDATED_TM'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 7
            end
            object DBEdit27: TDBEdit
              Left = 208
              Top = 88
              Width = 81
              Height = 17
              BorderStyle = bsNone
              DataField = 'PRINTED_TM'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 8
            end
            object DBEdit31: TDBEdit
              Left = 80
              Top = 16
              Width = 161
              Height = 17
              BorderStyle = bsNone
              DataField = 'PrpStatusDescr'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 9
            end
          end
          object GroupBox3: TGroupBox
            Left = 4
            Top = 137
            Width = 293
            Height = 59
            Caption = 'Invoice Info'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 1
            object Label15: TLabel
              Left = 8
              Top = 16
              Width = 90
              Height = 14
              Caption = 'Invoice Amount ($)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label9: TLabel
              Left = 8
              Top = 32
              Width = 45
              Height = 14
              Caption = 'Date Paid'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object DBEdit13: TDBEdit
              Left = 104
              Top = 16
              Width = 49
              Height = 17
              BorderStyle = bsNone
              DataField = 'INV_AMOUNT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 0
            end
            object DBEdit8: TDBEdit
              Left = 104
              Top = 32
              Width = 73
              Height = 17
              BorderStyle = bsNone
              DataField = 'PAY_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 1
            end
          end
        end
      end
    end
  end
  object LPanel: TPanel
    Left = 28
    Top = 115
    Width = 301
    Height = 393
    BevelOuter = bvNone
    Color = clSilver
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 8
      Top = 8
      Width = 287
      Height = 377
      Color = clWhite
      DataSource = DataSource1
      FixedColor = 12971774
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'Arial'
      TitleFont.Style = [fsBold]
      OnDblClick = DBGrid1DblClick
      OnKeyPress = DBGrid1KeyPress
      Columns = <
        item
          Expanded = False
          FieldName = 'LAST_NAME'
          Title.Caption = 'Last Name'
          Width = 112
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FIRST_NAME'
          Title.Caption = 'First'
          Width = 69
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PLANDATE'
          Title.Caption = 'Plan Date'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PrpStatusDescr'
          Title.Caption = 'Prep-Status'
          Visible = True
        end>
    end
  end
  object Panel6: TPanel
    Left = 336
    Top = 115
    Width = 68
    Height = 393
    BevelInner = bvRaised
    BiDiMode = bdRightToLeft
    Color = 14342874
    ParentBiDiMode = False
    TabOrder = 3
    object Image3: TImage
      Left = 8
      Top = 32
      Width = 57
      Height = 17
      Picture.Data = {
        07544269746D6170AE010000424DAE0100000000000076000000280000003000
        00000D0000000100040000000000380100000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FFF7800087FFFFFFFFFFFFFFFFFFFFFFFFFFFF7800087FFFFF808777887F
        FFFFFFFFFFFFFFFFFFFFFFFFF8087F7887FFF808777888888888888888888088
        8888888888888887787F70077788888888888888888808888888888888888888
        7787800778888777777777777770877777777777777778888788000778887777
        7777777777770877777777777777778887700088788877777777777777777087
        77777777777777888770088878888FFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFF888
        8770888887888888888888888888808888888888888888887788788888888888
        888888888888088888888888888888877807F78888800008FFFFFFFFFFFFFFFF
        FFFFFFFF78888800008FFF788800008FFFFFFFFFFFFFFFFFFFFFFFFFF7888000
        08FFFFF7800087FFFFFFFFFFFFFFFFFFFFFFFFFFFF7800087FFF}
      Transparent = True
    end
    object Image1: TImage
      Left = 8
      Top = 168
      Width = 57
      Height = 17
      Picture.Data = {
        07544269746D6170AE010000424DAE0100000000000076000000280000003000
        00000D0000000100040000000000380100000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FFF7800087FFFFFFFFFFFFFFFFFFFFFFFFFFFF7800087FFFFF808777887F
        FFFFFFFFFFFFFFFFFFFFFFFFF8087F7887FFF808777888888888888888888088
        8888888888888887787F70077788888888888888888808888888888888888888
        7787800778888777777777777770877777777777777778888788000778887777
        7777777777770877777777777777778887700088788877777777777777777087
        77777777777777888770088878888FFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFF888
        8770888887888888888888888888808888888888888888887788788888888888
        888888888888088888888888888888877807F78888800008FFFFFFFFFFFFFFFF
        FFFFFFFF78888800008FFF788800008FFFFFFFFFFFFFFFFFFFFFFFFFF7888000
        08FFFFF7800087FFFFFFFFFFFFFFFFFFFFFFFFFFFF7800087FFF}
      Transparent = True
    end
    object Image2: TImage
      Left = 8
      Top = 320
      Width = 57
      Height = 17
      Picture.Data = {
        07544269746D6170AE010000424DAE0100000000000076000000280000003000
        00000D0000000100040000000000380100000000000000000000100000000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00FFF7800087FFFFFFFFFFFFFFFFFFFFFFFFFFFF7800087FFFFF808777887F
        FFFFFFFFFFFFFFFFFFFFFFFFF8087F7887FFF808777888888888888888888088
        8888888888888887787F70077788888888888888888808888888888888888888
        7787800778888777777777777770877777777777777778888788000778887777
        7777777777770877777777777777778887700088788877777777777777777087
        77777777777777888770088878888FFFFFFFFFFFFFFFFF0FFFFFFFFFFFFFF888
        8770888887888888888888888888808888888888888888887788788888888888
        888888888888088888888888888888877807F78888800008FFFFFFFFFFFFFFFF
        FFFFFFFF78888800008FFF788800008FFFFFFFFFFFFFFFFFFFFFFFFFF7888000
        08FFFFF7800087FFFFFFFFFFFFFFFFFFFFFFFFFFFF7800087FFF}
      Transparent = True
    end
  end
  object MonitorPlanBtn: TChart
    Left = 0
    Top = 0
    Width = 793
    Height = 78
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clSilver
    Gradient.StartColor = 12615680
    Gradient.Visible = True
    Legend.Visible = False
    MarginLeft = 0
    MarginRight = 0
    MarginTop = 10
    Title.Font.Charset = ANSI_CHARSET
    Title.Font.Color = clYellow
    Title.Font.Height = -21
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      '')
    AxisVisible = False
    Chart3DPercent = 1
    View3DOptions.HorizOffset = -1257
    View3DOptions.VertOffset = -365
    View3DOptions.Zoom = 1
    View3DWalls = False
    Zoom.AnimatedSteps = 9
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ColorPaletteIndex = 13
    object Label17: TLabel
      Left = 8
      Top = 24
      Width = 77
      Height = 13
      Caption = 'Search Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label13: TLabel
      Left = 96
      Top = 24
      Width = 52
      Height = 13
      Caption = 'Directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label14: TLabel
      Left = 0
      Top = 0
      Width = 122
      Height = 26
      Align = alTop
      Alignment = taCenter
      Caption = 'Client Book'
      Color = 11301888
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10930928
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object SearchBox: TEdit
      Left = 9
      Top = 41
      Width = 57
      Height = 24
      Hint = 'Enter one or more leers from last name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = SearchBoxChange
      OnKeyPress = SearchBoxKeyPress
    end
    object DataDirBox: TEdit
      Left = 70
      Top = 42
      Width = 232
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnExit = DataDirBoxExit
      OnKeyPress = DataDirBoxKeyPress
    end
    object HelpBtn: TBitBtn
      Left = 644
      Top = 32
      Width = 53
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 4
      OnClick = HelpBtnClick
    end
    object OpenBtn: TBitBtn
      Left = 306
      Top = 32
      Width = 115
      Height = 33
      Caption = '&Open '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      Glyph.Data = {
        56020000424D5602000000000000760000002800000024000000180000000100
        040000000000E001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777777777777777777777770000777777777777777777777777777777777777
        0000777777000000000000000007777777777777000077777700666666666666
        666077777777777700007777770E006666666666666607777777777700007777
        770EEE0666666666666660777777777700007777770EEEE06666666666666600
        7777777700007777770EEEEE06666666666666660777777700007777770EEEEE
        E0666666666666666077777700007777770EEEEEEE0666666666666666077777
        00007777770EEEEEEEE06666666666666660777700007777770EEEEEEEEE0000
        000000000000777700007777770EEEEEEEEEEEEEEEE077777777777700007777
        770EEEEEEEEEEEEEEEE077777777777700007777770EEEEEE000000000007777
        7777777700007777770EEEEEE077777777777779999997770000777777700000
        0777777777777777999997770000777777777777777777777777777777999777
        0000700007077770007077077777777779799777000070770707777077707707
        7777777797779777000070770700007007707007777999997777777700007077
        0707707077700707777777777777777700007000070000700070770777777777
        7777777700007777777777777777777777777777777777770000}
      ParentFont = False
      TabOrder = 2
      OnClick = OpenBtnClick
    end
    object DeleteBtn: TBitBtn
      Left = 595
      Top = 32
      Width = 43
      Height = 33
      Caption = '&Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = DeleteBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 705
      Top = 32
      Width = 65
      Height = 33
      Cancel = True
      Caption = '&Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      ModalResult = 2
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 5
      OnClick = CancelBtnClick
    end
    object SelectCurBtn: TBitBtn
      Left = 152
      Top = 24
      Width = 73
      Height = 16
      Caption = 'Browse...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = SelectCurBtnClick
    end
    object EmailBtn: TBitBtn
      Left = 477
      Top = 32
      Width = 49
      Height = 32
      Caption = 'Email...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = EmailBtnClick
    end
    object CopyBtn: TBitBtn
      Left = 533
      Top = 32
      Width = 49
      Height = 32
      Caption = 'Copy...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = CopyBtnClick
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 184
    Top = 232
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=d:\wip\fp\data\Clients.DB')
    Left = 149
    Top = 153
  end
  object Table1: TADTable
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Clients'
    TableName = 'Clients'
    Left = 188
    Top = 152
    object Table1LAST_NAME: TStringField
      FieldName = 'LAST_NAME'
      Size = 30
    end
    object Table1FIRST_NAME: TStringField
      FieldName = 'FIRST_NAME'
    end
    object Table1PLANDATE: TStringField
      FieldName = 'PLANDATE'
      Size = 10
    end
    object Table1AREA: TStringField
      FieldName = 'AREA'
      Size = 3
    end
    object Table1PHONE: TStringField
      FieldName = 'PHONE'
      Size = 8
    end
    object Table1FAX: TStringField
      FieldName = 'FAX'
      Size = 8
    end
    object Table1MARSTATUS: TSmallintField
      FieldName = 'MARSTATUS'
    end
    object Table1PRP_STATUS: TStringField
      FieldName = 'PRP_STATUS'
      Size = 2
    end
    object Table1CREATED_BY: TStringField
      FieldName = 'CREATED_BY'
      Size = 10
    end
    object Table1CREATED_DT: TStringField
      FieldName = 'CREATED_DT'
      Size = 10
    end
    object Table1CREATED_TM: TStringField
      FieldName = 'CREATED_TM'
      Size = 10
    end
    object Table1UPDATED_BY: TStringField
      FieldName = 'UPDATED_BY'
      Size = 10
    end
    object Table1UPDATED_DT: TStringField
      FieldName = 'UPDATED_DT'
      Size = 10
    end
    object Table1UPDATED_TM: TStringField
      FieldName = 'UPDATED_TM'
      Size = 10
    end
    object Table1ACKRCVD_BY: TStringField
      FieldName = 'ACKRCVD_BY'
      Size = 10
    end
    object Table1ACKRCVD_DT: TStringField
      FieldName = 'ACKRCVD_DT'
      Size = 10
    end
    object Table1ACKRCVD_TM: TStringField
      FieldName = 'ACKRCVD_TM'
      Size = 10
    end
    object Table1PRINTED_BY: TStringField
      FieldName = 'PRINTED_BY'
      Size = 10
    end
    object Table1PRINTED_DT: TStringField
      FieldName = 'PRINTED_DT'
      Size = 10
    end
    object Table1PRINTED_TM: TStringField
      FieldName = 'PRINTED_TM'
      Size = 10
    end
    object Table1SIN: TStringField
      FieldName = 'SIN'
      Size = 9
    end
    object Table1BIRTHDATE: TStringField
      FieldName = 'BIRTHDATE'
      Size = 10
    end
    object Table1STREET: TStringField
      FieldName = 'STREET'
      Size = 30
    end
    object Table1APARTMENT: TStringField
      FieldName = 'APARTMENT'
      Size = 8
    end
    object Table1CITY: TStringField
      FieldName = 'CITY'
      Size = 15
    end
    object Table1PROVINCE: TStringField
      FieldName = 'PROVINCE'
      Size = 2
    end
    object Table1POSTAL: TStringField
      FieldName = 'POSTAL'
      Size = 7
    end
    object Table1COUNTRY: TStringField
      FieldName = 'COUNTRY'
      Size = 10
    end
    object Table1COMPL_BY: TStringField
      FieldName = 'COMPL_BY'
      Size = 10
    end
    object Table1COMPL_DT: TStringField
      FieldName = 'COMPL_DT'
      Size = 10
    end
    object Table1COMPL_TM: TStringField
      FieldName = 'COMPL_TM'
      Size = 10
    end
    object Table1DISCOUNTED: TStringField
      FieldName = 'DISCOUNTED'
      Size = 1
    end
    object Table1DUE_DT: TStringField
      FieldName = 'DUE_DT'
      Size = 10
    end
    object Table1NOTES: TStringField
      FieldName = 'NOTES'
      Size = 80
    end
    object Table1PAY_AMOUNT: TFloatField
      FieldName = 'PAY_AMOUNT'
    end
    object Table1PAY_INVNO: TStringField
      FieldName = 'PAY_INVNO'
      Size = 18
    end
    object Table1PAY_TYPE: TStringField
      FieldName = 'PAY_TYPE'
      Size = 6
    end
    object Table1INV_AMOUNT: TFloatField
      FieldName = 'INV_AMOUNT'
    end
    object Table1PAY_DT: TStringField
      FieldName = 'PAY_DT'
      Size = 10
    end
    object Table1FAXAREA: TStringField
      FieldName = 'FAXAREA'
      Size = 3
    end
    object Table1FAMILYHEAD: TStringField
      FieldName = 'FAMILYHEAD'
      Size = 1
    end
    object Table1TITLE: TStringField
      FieldName = 'TITLE'
      Size = 6
    end
    object Table1EMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 35
    end
    object Table1TAXPROV: TStringField
      FieldName = 'TAXPROV'
      Size = 2
    end
    object Table1GENDER: TStringField
      FieldName = 'GENDER'
      Size = 1
    end
    object Table1CATEGORY: TStringField
      FieldName = 'CATEGORY'
      Size = 10
    end
    object Table1FILE_NAME: TStringField
      FieldName = 'FILE_NAME'
      Size = 50
    end
    object Table1PrpStatusDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'PrpStatusDescr'
      Size = 30
      Calculated = True
    end
    object Table1CalcMarStatus: TStringField
      FieldKind = fkCalculated
      FieldName = 'CalcMarStatus'
      Size = 10
      Calculated = True
    end
  end
end
