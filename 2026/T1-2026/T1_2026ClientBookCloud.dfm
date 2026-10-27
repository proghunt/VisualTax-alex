object ClientBookCloudT1_2026: TClientBookCloudT1_2026
  Left = 233
  Top = 94
  Caption = 'T1 Clients'
  ClientHeight = 416
  ClientWidth = 706
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BookBack: TShape
    Left = 0
    Top = 26
    Width = 706
    Height = 390
    Align = alClient
    Brush.Color = clGray
    ExplicitLeft = 40
    ExplicitTop = 112
    ExplicitWidth = 843
    ExplicitHeight = 409
  end
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 706
    Height = 26
    Align = alTop
    Alignment = taCenter
    Caption = 'Client Book Cloud'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
    ExplicitLeft = 344
    ExplicitTop = 8
    ExplicitWidth = 190
  end
  object MonitorPlanBtn: TChart
    Left = 0
    Top = 440
    Width = 941
    Height = 105
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
    Zoom.Pen.Mode = pmNotXor
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    ColorPaletteIndex = 13
    object Label17: TLabel
      Left = 15
      Top = 10
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
      Left = 19
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
      Left = 336
      Top = 0
      Width = 190
      Height = 26
      Alignment = taCenter
      Caption = 'Client Book Cloud'
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
    object Label34: TLabel
      Left = 8
      Top = 80
      Width = 68
      Height = 13
      Caption = 'OR Find by:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label35: TLabel
      Left = 94
      Top = 80
      Width = 18
      Height = 13
      Caption = 'SIN'
      Transparent = True
    end
    object Label36: TLabel
      Left = 197
      Top = 80
      Width = 31
      Height = 13
      Caption = 'Phone'
      Transparent = True
    end
    object Label37: TLabel
      Left = 583
      Top = 72
      Width = 37
      Height = 13
      Caption = 'Word in'
      Transparent = True
    end
    object Label38: TLabel
      Left = 383
      Top = 80
      Width = 50
      Height = 13
      Caption = 'First Name'
      Transparent = True
    end
    object Label39: TLabel
      Left = 580
      Top = 85
      Width = 48
      Height = 13
      Caption = 'Str. or City'
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
      Font.Name = 'Arial'
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
      Width = 281
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
      Left = 755
      Top = 33
      Width = 57
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 5
      OnClick = HelpBtnClick
    end
    object OpenBtn: TBitBtn
      Left = 357
      Top = 33
      Width = 80
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
    object OpenSelBtn: TBitBtn
      Left = 443
      Top = 33
      Width = 99
      Height = 33
      Caption = 'Selective Open...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = OpenSelBtnClick
    end
    object DeleteBtn: TBitBtn
      Left = 699
      Top = 33
      Width = 50
      Height = 33
      Caption = '&Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = DeleteBtnClick
    end
    object CancelBtn: TBitBtn
      Left = 818
      Top = 34
      Width = 65
      Height = 33
      Caption = '&Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 6
      OnClick = CancelBtnClick
    end
    object SelectCurBtn: TBitBtn
      Left = 117
      Top = 21
      Width = 73
      Height = 19
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
    object SinBox: TEdit
      Left = 118
      Top = 72
      Width = 73
      Height = 21
      Hint = 'Enter SIN 999999999 and press enter'
      MaxLength = 9
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      OnKeyPress = SinBoxKeyPress
    end
    object PhoneBox: TEdit
      Left = 238
      Top = 72
      Width = 71
      Height = 21
      Hint = 'Enter phone 999-9999 (or partial) and press enter'
      MaxLength = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnKeyPress = PhoneBoxKeyPress
    end
    object StreetBox: TEdit
      Left = 652
      Top = 72
      Width = 81
      Height = 21
      Hint = 
        'Enter a word (full or partial) of the Street or City and press E' +
        'nter'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnKeyPress = StreetBoxKeyPress
    end
    object FindNextPhoneBtn: TBitBtn
      Left = 315
      Top = 72
      Width = 60
      Height = 25
      Hint = 'Click to Find Again'
      Caption = 'Find again'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      OnClick = FindNextPhoneBtnClick
    end
    object FirstNameBox: TEdit
      Left = 455
      Top = 72
      Width = 56
      Height = 21
      Hint = 'Enter First Name (or partial) and press enter'
      MaxLength = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      OnKeyPress = FirstNameBoxKeyPress
    end
    object FindNextFirstNameBtn: TBitBtn
      Left = 518
      Top = 72
      Width = 57
      Height = 25
      Hint = 'Click to Find Again'
      Caption = 'Find again'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
      OnClick = FindNextFirstNameBtnClick
    end
    object FindNextStreetBtn: TBitBtn
      Left = 740
      Top = 72
      Width = 59
      Height = 25
      Hint = 'Click to Find Again'
      Caption = 'Find again'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 14
      OnClick = FindNextStreetBtnClick
    end
    object EmailBtn: TBitBtn
      Left = 548
      Top = 34
      Width = 54
      Height = 32
      Caption = 'Email...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
      OnClick = EmailBtnClick
    end
    object CopyBtn: TBitBtn
      Left = 608
      Top = 34
      Width = 85
      Height = 32
      Caption = 'Copy/move...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Ms Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 16
      OnClick = CopyBtnClick
    end
    object TaxPlansBox: TCheckBox
      Left = 210
      Top = 21
      Width = 99
      Height = 17
      Caption = 'Tax Plans'
      TabOrder = 17
      OnClick = TaxPlansBoxClick
    end
  end
  object RPanel: TPanel
    Left = 373
    Top = 29
    Width = 330
    Height = 385
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 330
      Height = 385
      ActivePage = TabSheet1
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      MultiLine = True
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 8
      ExplicitTop = 3
      ExplicitWidth = 321
      ExplicitHeight = 377
      object TabSheet1: TTabSheet
        Caption = 'Identification'
        ExplicitWidth = 356
        ExplicitHeight = 392
        object Panel1: TPanel
          Left = 8
          Top = -8
          Width = 343
          Height = 137
          Color = 12971774
          TabOrder = 0
          object GroupBox1: TGroupBox
            Left = 8
            Top = 16
            Width = 322
            Height = 56
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
              TabOrder = 0
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
              TabOrder = 1
            end
          end
          object GroupBox7: TGroupBox
            Left = 8
            Top = 71
            Width = 326
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
            TabOrder = 1
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
              TabOrder = 1
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
              TabOrder = 2
            end
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Return Status'
        ImageIndex = 1
        ExplicitWidth = 356
        ExplicitHeight = 503
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
          object GroupBox6: TGroupBox
            Left = 4
            Top = 142
            Width = 293
            Height = 115
            Caption = 'EFile progress'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 1
            object Label20: TLabel
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
            object Label21: TLabel
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
            object Label25: TLabel
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
            object Label26: TLabel
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
            object Label27: TLabel
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
            object Label29: TLabel
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
              Font.Name = 'MS Sans Serif'
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
              Font.Name = 'MS Sans Serif'
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
              Font.Name = 'MS Sans Serif'
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
              Font.Name = 'MS Sans Serif'
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
              Font.Name = 'MS Sans Serif'
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
              Font.Name = 'MS Sans Serif'
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
          object GroupBox3: TGroupBox
            Left = 4
            Top = 270
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
            TabOrder = 2
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
    Left = 3
    Top = 29
    Width = 340
    Height = 385
    BevelOuter = bvNone
    Color = clSilver
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 0
      Top = 0
      Width = 340
      Height = 385
      Align = alClient
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
      Columns = <
        item
          Expanded = False
          FieldName = 'LAST_NAME'
          Title.Caption = 'Last Name'
          Width = 85
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FIRST_NAME'
          Title.Caption = 'First'
          Width = 51
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EfStatusDescr'
          Title.Caption = 'EF-Status'
          Width = 72
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
    Left = 341
    Top = 32
    Width = 32
    Height = 377
    BevelInner = bvRaised
    BiDiMode = bdRightToLeft
    Color = 14342874
    ParentBiDiMode = False
    TabOrder = 3
    object Image3: TImage
      Left = 3
      Top = 32
      Width = 26
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
      Stretch = True
      Transparent = True
    end
    object Image1: TImage
      Left = 3
      Top = 168
      Width = 26
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
      Stretch = True
      Transparent = True
    end
    object Image2: TImage
      Left = 3
      Top = 320
      Width = 26
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
      Stretch = True
      Transparent = True
    end
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 184
    Top = 232
  end
  object Table1: TADTable
    AutoCalcFields = False
    OnCalcFields = Table1CalcFields
    Connection = FDConnection
    UpdateOptions.UpdateTableName = 'Clients'
    TableName = 'Clients'
    Left = 184
    Top = 185
    object Table1PrpStatusDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'PrpStatusDescr'
      Calculated = True
    end
    object Table1EfStatusDescr: TStringField
      FieldKind = fkCalculated
      FieldName = 'EfStatusDescr'
      Calculated = True
    end
    object Table1ClientName: TStringField
      FieldKind = fkCalculated
      FieldName = 'ClientName'
      Calculated = True
    end
    object Table1CalcMarStatus: TStringField
      FieldKind = fkCalculated
      FieldName = 'CalcMarStatus'
      Calculated = True
    end
    object Table1LAST_NAME: TStringField
      FieldName = 'LAST_NAME'
      Origin = 'LAST_NAME'
      Size = 30
    end
    object Table1FIRST_NAME: TStringField
      FieldName = 'FIRST_NAME'
      Origin = 'FIRST_NAME'
    end
    object Table1FILE_NAME: TStringField
      FieldName = 'FILE_NAME'
      Origin = 'FILE_NAME'
      Size = 12
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
    object Table1MARSTATUS: TIntegerField
      FieldName = 'MARSTATUS'
      Origin = 'MARSTATUS'
    end
    object Table1EF_STATUS: TStringField
      FieldName = 'EF_STATUS'
      Origin = 'EF_STATUS'
      Size = 2
    end
    object Table1PRP_STATUS: TStringField
      FieldName = 'PRP_STATUS'
      Origin = 'PRP_STATUS'
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
      Origin = 'RTUSENT_BY'
      Size = 10
    end
    object Table1RTUSENT_DT: TStringField
      FieldName = 'RTUSENT_DT'
      Origin = 'RTUSENT_DT'
      Size = 10
    end
    object Table1RTUSENT_TM: TStringField
      FieldName = 'RTUSENT_TM'
      Origin = 'RTUSENT_TM'
      Size = 10
    end
    object Table1ACKRCVD_BY: TStringField
      FieldName = 'ACKRCVD_BY'
      Origin = 'ACKRCVD_BY'
      Size = 10
    end
    object Table1ACKRCVD_DT: TStringField
      FieldName = 'ACKRCVD_DT'
      Origin = 'ACKRCVD_DT'
      Size = 10
    end
    object Table1ACKRCVD_TM: TStringField
      FieldName = 'ACKRCVD_TM'
      Origin = 'ACKRCVD_TM'
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
    object Table1DCN_NO: TStringField
      FieldName = 'DCN_NO'
      Origin = 'DCN_NO'
      Size = 8
    end
    object Table1SIN: TStringField
      FieldName = 'SIN'
      Origin = 'SIN'
      Size = 9
    end
    object Table1BIRTHDATE: TStringField
      FieldName = 'BIRTHDATE'
      Origin = 'BIRTHDATE'
      Size = 10
    end
    object Table1STREET: TStringField
      FieldName = 'STREET'
      Origin = 'STREET'
      Size = 30
    end
    object Table1APARTMENT: TStringField
      FieldName = 'APARTMENT'
      Origin = 'APARTMENT'
      Size = 8
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
    object Table1EF_ELGBL: TStringField
      FieldName = 'EF_ELGBL'
      Origin = 'EF_ELGBL'
      Size = 1
    end
    object Table1RTUFILE: TStringField
      FieldName = 'RTUFILE'
      Origin = 'RTUFILE'
      Size = 12
    end
    object Table1ACKFILE: TStringField
      FieldName = 'ACKFILE'
      Origin = 'ACKFILE'
      Size = 12
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
    object Table1DISCOUNTED: TStringField
      FieldName = 'DISCOUNTED'
      Origin = 'DISCOUNTED'
      Size = 1
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
      Size = 18
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
    object Table1FAXAREA: TStringField
      FieldName = 'FAXAREA'
      Origin = 'FAXAREA'
      Size = 3
    end
    object Table1FAMILYHEAD: TStringField
      FieldName = 'FAMILYHEAD'
      Origin = 'FAMILYHEAD'
      Size = 1
    end
    object Table1CLIENT_ID: TStringField
      FieldName = 'CLIENT_ID'
      Origin = 'CLIENT_ID'
      Size = 15
    end
    object Table1TITLE: TStringField
      FieldName = 'TITLE'
      Origin = 'TITLE'
      Size = 6
    end
    object Table1EMAIL: TStringField
      FieldName = 'EMAIL'
      Origin = 'EMAIL'
      Size = 75
    end
    object Table1EMAIL2: TStringField
      FieldName = 'EMAIL2'
      Origin = 'EMAIL2'
      Size = 75
    end
    object Table1TAXPROV: TStringField
      FieldName = 'TAXPROV'
      Origin = 'TAXPROV'
      Size = 2
    end
    object Table1GENDER: TStringField
      FieldName = 'GENDER'
      Origin = 'GENDER'
      Size = 1
    end
    object Table1CATEGORY: TStringField
      FieldName = 'CATEGORY'
      Origin = 'CATEGORY'
      Size = 10
    end
  end
  object FDConnection: TADConnection
    Params.Strings = (
      'DriverID=SQLite'
      'DataBase=c:\t1\data\clients_t1.db'
      'Password=')
    LoginPrompt = False
    Left = 248
    Top = 177
  end
end
