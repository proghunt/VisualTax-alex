object ClientBookT3_2026: TClientBookT3_2026
  Left = 105
  Top = 142
  BorderIcons = [biSystemMenu]
  Caption = 'T3 Clients'
  ClientHeight = 535
  ClientWidth = 790
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clSilver
  Font.Height = -11
  Font.Name = 'Ms Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BookBack: TShape
    Left = 12
    Top = 91
    Width = 769
    Height = 441
    Brush.Color = clGray
    Shape = stRoundRect
  end
  object RPanel: TPanel
    Left = 440
    Top = 112
    Width = 321
    Height = 393
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 3
    object PageControl1: TPageControl
      Left = 8
      Top = 8
      Width = 305
      Height = 369
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
        object Panel1: TPanel
          Left = 8
          Top = -8
          Width = 281
          Height = 353
          Color = 12971774
          TabOrder = 0
          object GroupBox1: TGroupBox
            Left = 8
            Top = 16
            Width = 265
            Height = 97
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
            object Label13: TLabel
              Left = 8
              Top = 16
              Width = 56
              Height = 14
              Caption = 'Corp. Name'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label16: TLabel
              Left = 8
              Top = 48
              Width = 44
              Height = 14
              Caption = 'Year end'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label17: TLabel
              Left = 8
              Top = 72
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
            object Label4: TLabel
              Left = 8
              Top = 32
              Width = 41
              Height = 14
              Caption = 'Account'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object DBEdit12: TDBEdit
              Left = 72
              Top = 16
              Width = 185
              Height = 17
              BorderStyle = bsNone
              DataField = 'CORP_NAME'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 0
            end
            object DBEdit3: TDBEdit
              Left = 72
              Top = 48
              Width = 73
              Height = 17
              BorderStyle = bsNone
              DataField = 'YEAR_END'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 1
            end
            object DBEdit11: TDBEdit
              Left = 72
              Top = 72
              Width = 181
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
              TabOrder = 2
            end
            object DBEdit33: TDBEdit
              Left = 72
              Top = 32
              Width = 121
              Height = 17
              BorderStyle = bsNone
              DataField = 'ACCOUNT'
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
          object GroupBox2: TGroupBox
            Left = 8
            Top = 200
            Width = 265
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
            object Label18: TLabel
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
            object Label19: TLabel
              Left = 8
              Top = 32
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
            object Label20: TLabel
              Left = 8
              Top = 48
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
            object Label21: TLabel
              Left = 8
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
            object DBEdit4: TDBEdit
              Left = 72
              Top = 16
              Width = 177
              Height = 17
              BorderStyle = bsNone
              DataField = 'STREET'
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
              Top = 32
              Width = 185
              Height = 21
              BorderStyle = bsNone
              DataField = 'CITY'
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
              Top = 48
              Width = 177
              Height = 17
              BorderStyle = bsNone
              DataField = 'PROVINCE'
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
              Left = 72
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
          end
          object GroupBox4: TGroupBox
            Left = 4
            Top = 296
            Width = 269
            Height = 49
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
            Left = 8
            Top = 120
            Width = 265
            Height = 73
            Caption = 'Phone'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 3
            object Label22: TLabel
              Left = 8
              Top = 32
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
            object Label23: TLabel
              Left = 8
              Top = 48
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
            object Label15: TLabel
              Left = 8
              Top = 16
              Width = 37
              Height = 14
              Caption = 'Contact'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object DBEdit9: TDBEdit
              Left = 112
              Top = 32
              Width = 73
              Height = 17
              BorderStyle = bsNone
              DataField = 'PHONE'
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
              Left = 72
              Top = 48
              Width = 185
              Height = 17
              BorderStyle = bsNone
              DataField = 'FAX'
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
              Left = 72
              Top = 32
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
            object DBEdit1: TDBEdit
              Left = 72
              Top = 16
              Width = 177
              Height = 17
              BorderStyle = bsNone
              DataField = 'CONTACT'
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
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 305
          Height = 337
          Color = 12971774
          TabOrder = 0
          object GroupBox5: TGroupBox
            Left = 4
            Top = 176
            Width = 293
            Height = 139
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
            Visible = False
            object Label24: TLabel
              Left = 8
              Top = 64
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
            object Label25: TLabel
              Left = 8
              Top = 88
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
            object Label26: TLabel
              Left = 8
              Top = 112
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
            object Label27: TLabel
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
            object Label28: TLabel
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
            object Label29: TLabel
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
            object Label31: TLabel
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
              Top = 64
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'CREATED_BY'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 0
            end
            object DBEdit15: TDBEdit
              Left = 72
              Top = 88
              Width = 57
              Height = 17
              BorderStyle = bsNone
              DataField = 'UPDATED_BY'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 1
            end
            object DBEdit17: TDBEdit
              Left = 72
              Top = 112
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'PRINTED_BY'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 2
            end
            object DBEdit20: TDBEdit
              Left = 136
              Top = 64
              Width = 73
              Height = 17
              BorderStyle = bsNone
              DataField = 'CREATED_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 3
            end
            object DBEdit21: TDBEdit
              Left = 136
              Top = 88
              Width = 73
              Height = 17
              BorderStyle = bsNone
              DataField = 'UPDATED_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 4
            end
            object DBEdit22: TDBEdit
              Left = 136
              Top = 112
              Width = 73
              Height = 17
              BorderStyle = bsNone
              DataField = 'PRINTED_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 5
            end
            object DBEdit25: TDBEdit
              Left = 208
              Top = 64
              Width = 81
              Height = 17
              BorderStyle = bsNone
              DataField = 'CREATED_TM'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 6
            end
            object DBEdit26: TDBEdit
              Left = 208
              Top = 88
              Width = 81
              Height = 17
              BorderStyle = bsNone
              DataField = 'UPDATED_TM'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 7
            end
            object DBEdit27: TDBEdit
              Left = 208
              Top = 112
              Width = 81
              Height = 17
              BorderStyle = bsNone
              DataField = 'PRINTED_TM'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
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
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 9
            end
          end
          object GroupBox3: TGroupBox
            Left = 4
            Top = 111
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
            object Label38: TLabel
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
            object Label39: TLabel
              Left = 8
              Top = 40
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
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 0
            end
            object DBEdit8: TDBEdit
              Left = 104
              Top = 40
              Width = 73
              Height = 17
              BorderStyle = bsNone
              DataField = 'PAY_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
              TabOrder = 1
            end
          end
          object GroupBox6: TGroupBox
            Left = 4
            Top = 6
            Width = 293
            Height = 99
            Caption = 'EFile progress'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 2
            object Label3: TLabel
              Left = 8
              Top = 56
              Width = 59
              Height = 14
              Caption = 'RTU x'#39'mitted'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 8
              Top = 72
              Width = 49
              Height = 14
              Caption = 'Ack Rec'#39'd'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
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
            object Label7: TLabel
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
            object Label8: TLabel
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
            object Bevel2: TBevel
              Left = 8
              Top = 48
              Width = 257
              Height = 9
              Shape = bsBottomLine
            end
            object Label9: TLabel
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
            object DBEdit18: TDBEdit
              Left = 72
              Top = 56
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'RTUSENT_BY'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 0
            end
            object DBEdit19: TDBEdit
              Left = 72
              Top = 72
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'ACKRCVD_BY'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 1
            end
            object DBEdit23: TDBEdit
              Left = 136
              Top = 56
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'RTUSENT_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 2
            end
            object DBEdit24: TDBEdit
              Left = 136
              Top = 72
              Width = 65
              Height = 17
              BorderStyle = bsNone
              DataField = 'ACKRCVD_DT'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 3
            end
            object DBEdit28: TDBEdit
              Left = 208
              Top = 56
              Width = 81
              Height = 17
              BorderStyle = bsNone
              DataField = 'RTUSENT_TM'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 4
            end
            object DBEdit29: TDBEdit
              Left = 208
              Top = 72
              Width = 81
              Height = 17
              BorderStyle = bsNone
              DataField = 'ACKRCVD_TM'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 5
            end
            object DBEdit32: TDBEdit
              Left = 80
              Top = 16
              Width = 169
              Height = 17
              BorderStyle = bsNone
              DataField = 'EfStatusDescr'
              DataSource = DataSource1
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              TabOrder = 6
            end
          end
        end
      end
    end
  end
  object MonitorPlanBtn: TChart
    Left = 0
    Top = 0
    Width = 790
    Height = 89
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clSilver
    Gradient.StartColor = 7950848
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
    object Label14: TLabel
      Left = 336
      Top = 0
      Width = 122
      Height = 26
      Alignment = taCenter
      Caption = 'Client Book'
      Color = 11301888
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11134974
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Label1: TLabel
      Left = 9
      Top = 28
      Width = 81
      Height = 13
      Caption = 'Search Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11134974
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label2: TLabel
      Left = 24
      Top = 52
      Width = 56
      Height = 13
      Caption = 'Directory:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11134974
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object DataDirBox: TEdit
      Left = 95
      Top = 44
      Width = 169
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnExit = DataDirBoxExit
      OnKeyPress = DataDirBoxKeyPress
    end
    object SearchBox: TEdit
      Left = 95
      Top = 20
      Width = 169
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = SearchBoxChange
      OnKeyPress = SearchBoxKeyPress
    end
    object OpenBtn: TBitBtn
      Left = 273
      Top = 28
      Width = 81
      Height = 33
      Caption = 'Open '
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
    object CancelBtn: TBitBtn
      Left = 525
      Top = 28
      Width = 83
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 3
      OnClick = CancelBtnClick
    end
    object DeleteBtn: TBitBtn
      Left = 441
      Top = 28
      Width = 85
      Height = 33
      Caption = 'Delete...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = DeleteBtnClick
    end
    object HelpBtn: TBitBtn
      Left = 616
      Top = 28
      Width = 71
      Height = 33
      Caption = 'Help'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 5
      OnClick = HelpBtnClick
    end
    object PrintBtn: TBitBtn
      Left = 357
      Top = 28
      Width = 85
      Height = 33
      Caption = 'Print listing... '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = PrintBtnClick
    end
    object SelectCurBtn: TBitBtn
      Left = 133
      Top = 72
      Width = 64
      Height = 16
      Caption = 'Browse...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = SelectCurBtnClick
    end
    object EmailBtn: TBitBtn
      Left = 357
      Top = 63
      Width = 85
      Height = 26
      Caption = 'Email...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = EmailBtnClick
    end
    object CopyMoveBtn: TBitBtn
      Left = 441
      Top = 63
      Width = 85
      Height = 26
      Caption = 'Copy/Move..'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = CopyMoveBtnClick
    end
  end
  object Panel6: TPanel
    Left = 368
    Top = 112
    Width = 68
    Height = 393
    BevelInner = bvRaised
    BiDiMode = bdRightToLeft
    Color = 14342874
    ParentBiDiMode = False
    TabOrder = 1
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
  object LPanel: TPanel
    Left = 40
    Top = 112
    Width = 321
    Height = 393
    BevelOuter = bvNone
    Color = clSilver
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 8
      Top = 8
      Width = 305
      Height = 369
      DataSource = DataSource1
      FixedColor = 12971774
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clBlack
      TitleFont.Height = -11
      TitleFont.Name = 'Ms Sans Serif'
      TitleFont.Style = [fsBold]
      OnDblClick = DBGrid1DblClick
      OnKeyPress = DBGrid1KeyPress
      Columns = <
        item
          Expanded = False
          FieldName = 'CORP_NAME'
          Width = 132
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'YEAR_END'
          Width = 69
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EfStatusDescr'
          Title.Caption = 'EF-Status'
          Width = 121
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PrpStatusDescr'
          Title.Caption = 'Prep-Status'
          Width = 121
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRP_STATUS'
          Title.Caption = 'STATUS'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FILE_NAME'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UPDATED_BY'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UPDATED_DT'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UPDATED_TM'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRINTED_BY'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRINTED_DT'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRINTED_TM'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'STREET'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CITY'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PROVINCE'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'POSTAL'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COUNTRY'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COMPL_BY'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COMPL_DT'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COMPL_TM'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DUE_DT'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOTES'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PAY_AMOUNT'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PAY_INVNO'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PAY_TYPE'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'INV_AMOUNT'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PAY_DT'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DUE_DATE'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CORPTYPE'
          Visible = True
        end>
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    OnDataChange = DataSource1DataChange
    Left = 160
    Top = 248
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 165
    Top = 161
  end
  object Table1: TADTable
    OnCalcFields = Table1CalcFields
    IndexFieldNames = 'FILE_NAME'
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Clients'
    TableName = 'Clients'
    Left = 204
    Top = 160
    object Table1PrpStatusDescr: TStringField
      DisplayWidth = 16
      FieldKind = fkCalculated
      FieldName = 'PrpStatusDescr'
      Size = 16
      Calculated = True
    end
    object Table1EfStatusDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'EfStatusDescr'
      Size = 255
      Calculated = True
    end
    object Table1CORP_NAME: TStringField
      FieldName = 'CORP_NAME'
      Origin = 'CORP_NAME'
      Size = 40
    end
    object Table1YEAR_END: TStringField
      FieldName = 'YEAR_END'
      Origin = 'YEAR_END'
      Size = 10
    end
    object Table1FILE_NAME: TStringField
      FieldName = 'FILE_NAME'
      Origin = 'FILE_NAME'
      Size = 50
    end
    object Table1CONTACT: TStringField
      FieldName = 'CONTACT'
      Origin = 'CONTACT'
    end
    object Table1AREA: TStringField
      FieldName = 'AREA'
      Origin = 'AREA'
      Size = 3
    end
    object Table1PHONE: TStringField
      FieldName = 'PHONE'
      Origin = 'PHONE'
      Size = 8
    end
    object Table1FAX: TStringField
      FieldName = 'FAX'
      Origin = 'FAX'
      Size = 8
    end
    object Table1PRP_STATUS: TStringField
      FieldName = 'PRP_STATUS'
      Origin = 'PRP_STATUS'
      Size = 2
    end
    object Table1EF_STATUS: TStringField
      FieldName = 'EF_STATUS'
      Size = 2
    end
    object Table1CREATED_BY: TStringField
      FieldName = 'CREATED_BY'
      Origin = 'CREATED_BY'
      Size = 10
    end
    object Table1CREATED_DT: TStringField
      FieldName = 'CREATED_DT'
      Origin = 'CREATED_DT'
      Size = 10
    end
    object Table1CREATED_TM: TStringField
      FieldName = 'CREATED_TM'
      Origin = 'CREATED_TM'
      Size = 10
    end
    object Table1UPDATED_BY: TStringField
      FieldName = 'UPDATED_BY'
      Origin = 'UPDATED_BY'
      Size = 10
    end
    object Table1UPDATED_DT: TStringField
      FieldName = 'UPDATED_DT'
      Origin = 'UPDATED_DT'
      Size = 10
    end
    object Table1UPDATED_TM: TStringField
      FieldName = 'UPDATED_TM'
      Origin = 'UPDATED_TM'
      Size = 10
    end
    object Table1RTUSENT_BY: TStringField
      FieldName = 'RTUSENT_BY'
      Size = 10
    end
    object Table1RTUSENT_DT: TStringField
      FieldName = 'RTUSENT_DT'
      Size = 10
    end
    object Table1RTUSENT_TM: TStringField
      FieldName = 'RTUSENT_TM'
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
      Origin = 'PRINTED_BY'
      Size = 10
    end
    object Table1PRINTED_DT: TStringField
      FieldName = 'PRINTED_DT'
      Origin = 'PRINTED_DT'
      Size = 10
    end
    object Table1PRINTED_TM: TStringField
      FieldName = 'PRINTED_TM'
      Origin = 'PRINTED_TM'
      Size = 10
    end
    object Table1ACCOUNT: TStringField
      FieldName = 'ACCOUNT'
      Origin = 'ACCOUNT'
      Size = 15
    end
    object Table1STREET: TStringField
      FieldName = 'STREET'
      Origin = 'STREET'
      Size = 30
    end
    object Table1CITY: TStringField
      FieldName = 'CITY'
      Origin = 'CITY'
      Size = 15
    end
    object Table1PROVINCE: TStringField
      FieldName = 'PROVINCE'
      Origin = 'PROVINCE'
      Size = 2
    end
    object Table1POSTAL: TStringField
      FieldName = 'POSTAL'
      Origin = 'POSTAL'
      Size = 7
    end
    object Table1COUNTRY: TStringField
      FieldName = 'COUNTRY'
      Origin = 'COUNTRY'
      Size = 10
    end
    object Table1COMPL_BY: TStringField
      FieldName = 'COMPL_BY'
      Origin = 'COMPL_BY'
      Size = 10
    end
    object Table1COMPL_DT: TStringField
      FieldName = 'COMPL_DT'
      Origin = 'COMPL_DT'
      Size = 10
    end
    object Table1COMPL_TM: TStringField
      FieldName = 'COMPL_TM'
      Origin = 'COMPL_TM'
      Size = 10
    end
    object Table1DUE_DT: TStringField
      FieldName = 'DUE_DT'
      Origin = 'DUE_DT'
      Size = 10
    end
    object Table1NOTES: TStringField
      FieldName = 'NOTES'
      Origin = 'NOTES'
      Size = 80
    end
    object Table1PAY_AMOUNT: TFloatField
      FieldName = 'PAY_AMOUNT'
      Origin = 'PAY_AMOUNT'
    end
    object Table1PAY_INVNO: TStringField
      FieldName = 'PAY_INVNO'
      Origin = 'PAY_INVNO'
      Size = 13
    end
    object Table1PAY_TYPE: TStringField
      FieldName = 'PAY_TYPE'
      Origin = 'PAY_TYPE'
      Size = 6
    end
    object Table1INV_AMOUNT: TFloatField
      FieldName = 'INV_AMOUNT'
      Origin = 'INV_AMOUNT'
    end
    object Table1PAY_DT: TStringField
      FieldName = 'PAY_DT'
      Origin = 'PAY_DT'
      Size = 10
    end
    object Table1DUE_DATE: TStringField
      FieldName = 'DUE_DATE'
      Origin = 'DUE_DATE'
      Size = 10
    end
    object Table1CORPTYPE: TStringField
      FieldName = 'CORPTYPE'
      Origin = 'CORPTYPE'
      Size = 1
    end
  end
end
