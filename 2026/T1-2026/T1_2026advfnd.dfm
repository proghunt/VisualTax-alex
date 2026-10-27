object advfndT1_2026: TadvfndT1_2026
  Left = 409
  Top = 117
  Caption = 'Client Data Base - Advanced analyser'
  ClientHeight = 780
  ClientWidth = 896
  Color = 16777183
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
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 896
    Height = 33
    Align = alTop
    Caption = 'Advanced Data Base Filter'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 33
    Width = 896
    Height = 171
    Align = alTop
    Color = 15794175
    TabOrder = 1
    object Label15: TLabel
      Left = 7
      Top = 4
      Width = 513
      Height = 15
      Caption = 
        'This utility allows you to analyse the clients based on values o' +
        'f any field on any of the tax forms'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label16: TLabel
      Left = 7
      Top = 58
      Width = 308
      Height = 15
      Caption = 'FINDING FIELD NUMBERS: Click any form shown below'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label17: TLabel
      Left = 7
      Top = 104
      Width = 332
      Height = 15
      Caption = 'Example 2: Find Married tax payers who did not apply for GST'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label18: TLabel
      Left = 7
      Top = 82
      Width = 360
      Height = 15
      Caption = 'Example 1: Find all tax payers whose Postal Code starts with L4W'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label23: TLabel
      Left = 7
      Top = 21
      Width = 513
      Height = 30
      AutoSize = False
      Caption = 
        'Note: To find clients with certain amounts of Income or non-refu' +
        'nsable credits, it is easier to use Line Numbers in the previous' +
        ' basic window'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label1: TLabel
      Left = 7
      Top = 125
      Width = 311
      Height = 15
      Caption = 'Example 3: Find clients who do NOT have Email address'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label25: TLabel
      Left = 7
      Top = 146
      Width = 283
      Height = 15
      Caption = 'Example 4: Find clients who do have Email address'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label13: TLabel
      Left = 485
      Top = 73
      Width = 57
      Height = 15
      Caption = 'on Month='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label19: TLabel
      Left = 485
      Top = 98
      Width = 53
      Height = 15
      Caption = 'and  day='
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label24: TLabel
      Left = 485
      Top = 38
      Width = 104
      Height = 29
      AutoSize = False
      Caption = 'Clients having a birthdate '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Sample1Btn: TBitBtn
      Left = 376
      Top = 80
      Width = 99
      Height = 22
      Caption = 'Set example 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Sample1BtnClick
    end
    object Sample2Btn: TBitBtn
      Left = 376
      Top = 102
      Width = 99
      Height = 21
      Caption = 'Set example 2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Sample2BtnClick
    end
    object Sample3Btn: TBitBtn
      Left = 376
      Top = 123
      Width = 99
      Height = 21
      Caption = 'Set example 3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Sample3BtnClick
    end
    object Sample4Btn: TBitBtn
      Left = 376
      Top = 144
      Width = 99
      Height = 22
      Caption = 'Set example 4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Sample4BtnClick
    end
    object BirthdateBtn: TBitBtn
      Left = 485
      Top = 119
      Width = 104
      Height = 26
      Caption = 'Set birthdate filter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = BirthdateBtnClick
    end
    object mm: TEdit
      Left = 546
      Top = 69
      Width = 43
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object dd: TEdit
      Left = 546
      Top = 94
      Width = 43
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
  end
  object pgc: TPageControl
    Left = 0
    Top = 204
    Width = 896
    Height = 576
    ActivePage = tabFilter
    Align = alClient
    TabOrder = 2
    OnChange = pgcChange
    object tabFilter: TTabSheet
      Caption = 'Filter'
      object Label20: TLabel
        Left = 6
        Top = 71
        Width = 106
        Height = 15
        Caption = 'Most Useful Forms'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label21: TLabel
        Left = 7
        Top = 13
        Width = 110
        Height = 45
        AutoSize = False
        Caption = 'Double click a form to show fiield numbers'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label6: TLabel
        Left = 20
        Top = 175
        Width = 50
        Height = 15
        Caption = 'AllForms'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ListBox1: TListBox
        Left = 4
        Top = 90
        Width = 113
        Height = 71
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Items.Strings = (
          'INFO'
          'TAXSUM'
          'T1')
        ParentFont = False
        TabOrder = 0
        OnDblClick = ListBox1DblClick
      end
      object ListBox2: TListBox
        Left = 4
        Top = 196
        Width = 113
        Height = 334
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnDblClick = ListBox2DblClick
      end
      object Panel2: TPanel
        Left = 124
        Top = 1
        Width = 477
        Height = 225
        TabOrder = 2
        object Label2: TLabel
          Left = 60
          Top = 67
          Width = 66
          Height = 15
          Caption = 'Form Name'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 132
          Top = 67
          Width = 49
          Height = 15
          Caption = 'Field No.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 276
          Top = 67
          Width = 53
          Height = 15
          Caption = 'Condition'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 348
          Top = 67
          Width = 30
          Height = 15
          Caption = 'Value'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label7: TLabel
          Left = 8
          Top = 131
          Width = 35
          Height = 15
          Caption = 'and/or'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 8
          Top = 163
          Width = 35
          Height = 15
          Caption = 'and/or'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label9: TLabel
          Left = 8
          Top = 187
          Width = 35
          Height = 15
          Caption = 'and/or'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label10: TLabel
          Left = 204
          Top = 59
          Width = 42
          Height = 15
          Caption = 'Amount'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label11: TLabel
          Left = 196
          Top = 75
          Width = 68
          Height = 15
          Caption = 'or Character'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label12: TLabel
          Left = 95
          Top = 1
          Width = 226
          Height = 16
          Caption = 'Enter up to four Filtering Conditions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Frm1: TEdit
          Left = 60
          Top = 91
          Width = 57
          Height = 23
          Hint = 'Enter valid form as per List'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object Fld1: TEdit
          Left = 132
          Top = 91
          Width = 41
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 3
          ParentFont = False
          TabOrder = 1
        end
        object Condition1: TComboBox
          Left = 284
          Top = 91
          Width = 41
          Height = 24
          Hint = 'Click to select conditional operator'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Items.Strings = (
            '>'
            '<'
            '='
            '>='
            '<=')
        end
        object Value1: TEdit
          Left = 340
          Top = 91
          Width = 114
          Height = 23
          Hint = 
            'If field is a dollar amount enter as number with no decimals i.e' +
            '. 32000.56, If Character enter any text'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object Frm2: TEdit
          Left = 60
          Top = 123
          Width = 57
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object Fld2: TEdit
          Left = 132
          Top = 123
          Width = 41
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 3
          ParentFont = False
          TabOrder = 6
        end
        object Condition2: TComboBox
          Left = 284
          Top = 123
          Width = 41
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          Items.Strings = (
            '>'
            '<'
            '='
            '>='
            '<=')
        end
        object Value2: TEdit
          Left = 340
          Top = 123
          Width = 114
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object Frm3: TEdit
          Left = 60
          Top = 155
          Width = 57
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
        end
        object Fld3: TEdit
          Left = 132
          Top = 155
          Width = 41
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 3
          ParentFont = False
          TabOrder = 11
        end
        object Condition3: TComboBox
          Left = 284
          Top = 155
          Width = 41
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
          Items.Strings = (
            '>'
            '<'
            '='
            '>='
            '<=')
        end
        object Value3: TEdit
          Left = 339
          Top = 155
          Width = 115
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
        end
        object Frm4: TEdit
          Left = 60
          Top = 187
          Width = 57
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 15
        end
        object Fld4: TEdit
          Left = 132
          Top = 187
          Width = 41
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 3
          ParentFont = False
          TabOrder = 16
        end
        object Condition4: TComboBox
          Left = 284
          Top = 187
          Width = 41
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 18
          Items.Strings = (
            '>'
            '<'
            '='
            '>='
            '<=')
        end
        object Value4: TEdit
          Left = 340
          Top = 187
          Width = 114
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 19
        end
        object FldType1: TComboBox
          Left = 189
          Top = 91
          Width = 80
          Height = 23
          Hint = 'Click to select'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Items.Strings = (
            'Amount'
            'Character')
        end
        object FldType2: TComboBox
          Left = 189
          Top = 123
          Width = 80
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          Items.Strings = (
            'Amount'
            'Character')
        end
        object FldType3: TComboBox
          Left = 189
          Top = 155
          Width = 80
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          Items.Strings = (
            'Amount'
            'Character')
        end
        object FldType4: TComboBox
          Left = 189
          Top = 187
          Width = 80
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 17
          Items.Strings = (
            'Amount'
            'Character')
        end
        object AndOrOrBox: TRadioGroup
          Left = 133
          Top = 21
          Width = 185
          Height = 36
          Caption = 'Combine with AND or OR'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'AND'
            'OR')
          ParentFont = False
          TabOrder = 20
        end
        object ClearBtn: TBitBtn
          Left = 356
          Top = 22
          Width = 105
          Height = 25
          Caption = 'Clear conditions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 21
          Visible = False
          OnClick = ClearBtnClick
        end
      end
      object Panel3: TPanel
        Left = 123
        Top = 232
        Width = 478
        Height = 298
        TabOrder = 3
        object doing: TLabel
          Left = 116
          Top = 67
          Width = 317
          Height = 14
          AutoSize = False
          Caption = 'Doing'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label14: TLabel
          Left = 112
          Top = 19
          Width = 81
          Height = 15
          Caption = 'Data Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object FindBtn: TBitBtn
          Left = 168
          Top = 112
          Width = 89
          Height = 33
          Hint = 'Click to proceed'
          Caption = 'Find'
          Glyph.Data = {
            46060000424D4606000000000000360400002800000018000000160000000100
            0800000000001002000000000000000000000001000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
            A4003F3F5F003F3F7F003F3F9F003F3FBF003F3FDF003F3FFF003F5F3F003F5F
            5F003F5F7F003F5F9F003F5FBF003F5FDF003F5FFF003F7F3F003F7F5F003F7F
            7F003F7F9F003F7FBF003F7FDF003F7FFF003F9F3F003F9F5F003F9F7F003F9F
            9F003F9FBF003F9FDF003F9FFF003FBF3F003FBF5F003FBF7F003FBF9F003FBF
            BF003FBFDF003FBFFF003FDF3F003FDF5F003FDF7F003FDF9F003FDFBF003FDF
            DF003FDFFF003FFF3F003FFF5F003FFF7F003FFF9F003FFFBF003FFFDF003FFF
            FF005F3F3F005F3F5F005F3F7F005F3F9F005F3FBF005F3FDF005F3FFF005F5F
            3F005F5F5F005F5F7F005F5F9F005F5FBF005F5FDF005F5FFF005F7F3F005F7F
            5F005F7F7F005F7F9F005F7FBF005F7FDF005F7FFF005F9F3F005F9F5F005F9F
            7F005F9F9F005F9FBF005F9FDF005F9FFF005FBF3F005FBF5F005FBF7F005FBF
            9F005FBFBF005FBFDF005FBFFF005FDF3F005FDF5F005FDF7F005FDF9F005FDF
            BF005FDFDF005FDFFF005FFF3F005FFF5F005FFF7F005FFF9F005FFFBF005FFF
            DF005FFFFF007F3F3F007F3F5F007F3F7F007F3F9F007F3FBF007F3FDF007F3F
            FF007F5F3F007F5F5F007F5F7F007F5F9F007F5FBF007F5FDF007F5FFF007F7F
            3F007F7F5F007F7F7F007F7F9F007F7FBF007F7FDF007F7FFF007F9F3F007F9F
            5F007F9F7F007F9F9F007F9FBF007F9FDF007F9FFF007FBF3F007FBF5F007FBF
            7F007FBF9F007FBFBF007FBFDF007FBFFF007FDF3F007FDF5F007FDF7F007FDF
            9F007FDFBF007FDFDF007FDFFF007FFF3F007FFF5F007FFF7F007FFF9F007FFF
            BF007FFFDF007FFFFF009F3F3F009F3F5F009F3F7F009F3F9F009F3FBF009F3F
            DF009F3FFF009F5F3F009F5F5F009F5F7F009F5F9F009F5FBF009F5FDF009F5F
            FF009F7F3F009F7F5F009F7F7F009F7F9F009F7FBF009F7FDF009F7FFF009F9F
            3F009F9F5F009F9F7F009F9F9F009F9FBF009F9FDF009F9FFF009FBF3F009FBF
            5F009FBF7F009FBF9F009FBFBF009FBFDF009FBFFF009FDF3F009FDF5F009FDF
            7F009FDF9F009FDFBF009FDFDF009FDFFF009FFF3F009FFF5F009FFF7F009FFF
            9F009FFFBF009FFFDF009FFFFF00BF3F3F00BF3F5F00BF3F7F00BF3F9F00BF3F
            BF00BF3FDF00BF3FFF00BF5F3F00BF5F5F00BF5F7F00BF5F9F00BF5FBF00BF5F
            DF00BF5FFF00BF7F3F00BF7F5F00BF7F7F00BF7F9F00BF7FBF00BF7FDF00BF7F
            FF00BF9F3F00BF9F5F00BF9F7F00BF9F9F00BF9FBF00BF9FDF00BF9FFF00BFBF
            3F00BFBF5F00BFBF7F00BFBF9F00BFBFBF00BFBFDF00BFBFFF00BFDF3F00BFDF
            5F00BFDF7F00BFDF9F00BFDFBF00BFDFDF00F0FBFF00A4A0A000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00070707070707
            0707070707070707070707070707070707070707070707070707070707070707
            0707070707070707070707070707070707070707070707070707070707070707
            0707070707070707070707070707070707070707070707070707070707070707
            0707070700000007070707070000000707070707070707070707070700070007
            0707070700070007070707070707070707070707000000F80707077B00000007
            0707070707070707070707070000000000000000000000070707070707070707
            0707070700070000000007000000000707070707070707070707070700070000
            00000700000000070707070707F8000000000000000000000000000000000007
            070707070700FEFEFEFEFEFE00000000007B000000000707070707070700FEFE
            FEFEFEFEFEFE0000FE00070000070707070707070700FEFEFEFEFEFEFEFE0000
            FE00070000070707070707070700FEFEFEFEFEFEFEFE0000FE00070000070707
            070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707070707070700FEFE
            FEFEFEFEFEFEFEFEFE00070707070707070707070700FEFEFEFEFEFEFEFEFEFE
            FE00000707070707070707070700FEFEFEFEFEFEFEFEFEFEFE00070707070707
            0707070707000000FEFEFE000000000000F80707070707070707070707070700
            0000000707070707070707070707070707070707070707070707070707070707
            07070707070707070707}
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = FindBtnClick
        end
        object BitBtn1: TBitBtn
          Left = 288
          Top = 112
          Width = 89
          Height = 33
          Caption = 'Exit'
          Kind = bkCancel
          NumGlyphs = 2
          TabOrder = 1
          OnClick = BitBtn1Click
        end
        object FileListBox1: TFileListBox
          Left = 12
          Top = 8
          Width = 93
          Height = 278
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 15
          Mask = '*.d'
          ParentFont = False
          TabOrder = 2
        end
        object DataDirBox: TEdit
          Left = 112
          Top = 36
          Width = 153
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Text = 'DataDirBox'
          OnExit = DataDirBoxExit
          OnKeyPress = DataDirBoxKeyPress
        end
      end
    end
  end
  object pnlClosePage: TPanel
    Left = 873
    Top = 205
    Width = 22
    Height = 22
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object btnClosePage: TSpeedButton
      Left = 0
      Top = 0
      Width = 22
      Height = 22
      Align = alClient
      Caption = 'X'
      OnClick = btnClosePageClick
      ExplicitLeft = 8
      ExplicitTop = 8
      ExplicitWidth = 23
    end
  end
end
