object OptionsFrmT1_2026: TOptionsFrmT1_2026
  Left = 295
  Top = 116
  Caption = 'OptionsFrmT1_2026'
  ClientHeight = 766
  ClientWidth = 1106
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label81: TLabel
    Left = 431
    Top = 284
    Width = 34
    Height = 17
    Caption = 'Area:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label85: TLabel
    Left = 396
    Top = 284
    Width = 24
    Height = 17
    Caption = 'Fax'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 44
    Width = 1106
    Height = 722
    ActivePage = TabSheet8
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Preparer'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 1098
        Height = 691
        Align = alClient
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Panel12: TPanel
          Left = 0
          Top = 0
          Width = 1098
          Height = 31
          Align = alTop
          Caption = ' Preparer'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -27
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object ScrollBox1: TScrollBox
          Left = 0
          Top = 31
          Width = 1098
          Height = 660
          HorzScrollBar.Tracking = True
          VertScrollBar.Tracking = True
          Align = alClient
          TabOrder = 1
          object IdentPanel: TPanel
            Left = 9
            Top = 9
            Width = 742
            Height = 285
            BevelOuter = bvLowered
            BorderWidth = 1
            TabOrder = 0
            object Label1: TLabel
              Left = 103
              Top = 69
              Width = 43
              Height = 17
              Caption = 'Street:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 121
              Top = 95
              Width = 29
              Height = 17
              Caption = 'City:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 86
              Top = 121
              Width = 61
              Height = 17
              Caption = 'Province:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label4: TLabel
              Left = 233
              Top = 121
              Width = 55
              Height = 17
              Caption = 'Country:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 422
              Top = 121
              Width = 45
              Height = 17
              Caption = 'Postal:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 112
              Top = 172
              Width = 34
              Height = 17
              Caption = 'Area:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 293
              Top = 172
              Width = 22
              Height = 17
              Caption = 'Tel:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 293
              Top = 198
              Width = 28
              Height = 17
              Caption = 'Fax:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label12: TLabel
              Left = 78
              Top = 172
              Width = 22
              Height = 17
              Caption = 'Tel:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label26: TLabel
              Left = 112
              Top = 198
              Width = 34
              Height = 17
              Caption = 'Area:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label27: TLabel
              Left = 78
              Top = 198
              Width = 24
              Height = 17
              Caption = 'Fax'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label14: TLabel
              Left = 34
              Top = 34
              Width = 110
              Height = 17
              Caption = 'Company Name:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label40: TLabel
              Left = 17
              Top = 9
              Width = 159
              Height = 18
              Caption = 'Preparer Identification'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label88: TLabel
              Left = 34
              Top = 258
              Width = 94
              Height = 17
              Caption = 'Email Address'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label108: TLabel
              Left = 43
              Top = 233
              Width = 87
              Height = 17
              Caption = 'Business No:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label112: TLabel
              Left = 284
              Top = 224
              Width = 38
              Height = 17
              Caption = 'RepId'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label113: TLabel
              Left = 448
              Top = 233
              Width = 270
              Height = 17
              Caption = '(B/N and RepId may be used in AuthRep)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = [fsItalic]
              ParentFont = False
            end
            object Label136: TLabel
              Left = 396
              Top = 146
              Width = 71
              Height = 17
              Caption = 'Last Name'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label137: TLabel
              Left = 86
              Top = 146
              Width = 55
              Height = 17
              Caption = 'Contact:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label135: TLabel
              Left = 164
              Top = 146
              Width = 70
              Height = 17
              Caption = 'First name'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Prp_Street: TEdit
              Left = 164
              Top = 60
              Width = 483
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object Prp_City: TEdit
              Left = 164
              Top = 86
              Width = 483
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Text = ' '
            end
            object Prp_Prov: TComboBox
              Left = 164
              Top = 112
              Width = 53
              Height = 25
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              Text = 'Prp_Prov'
              Items.Strings = (
                'NL'
                'PE'
                'NS'
                'NB'
                'QC'
                'ON'
                'MB'
                'SK'
                'AB'
                'BC'
                'NT'
                'YT'
                'ZZ')
            end
            object Prp_countr: TEdit
              Left = 293
              Top = 112
              Width = 122
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
              Text = ' '
            end
            object Prp_Postal: TEdit
              Left = 473
              Top = 115
              Width = 79
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              Text = ' '
            end
            object Prp_Area: TEdit
              Left = 164
              Top = 172
              Width = 46
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 8
              Text = ' '
            end
            object Prp_Tel: TEdit
              Left = 336
              Top = 172
              Width = 105
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 9
            end
            object Prp_Fax: TEdit
              Left = 336
              Top = 198
              Width = 105
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 11
            end
            object Prp_FxArea: TEdit
              Left = 164
              Top = 198
              Width = 46
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 10
            end
            object Prp_Name: TEdit
              Left = 164
              Top = 34
              Width = 483
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = 'Prp_Name'
            end
            object Prp_Email: TEdit
              Left = 164
              Top = 250
              Width = 414
              Height = 24
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 14
              Text = ' '
            end
            object Prp_BusNo: TEdit
              Left = 164
              Top = 224
              Width = 113
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 9
              ParentFont = False
              TabOrder = 12
              Text = ' '
            end
            object Prp_RepId: TEdit
              Left = 336
              Top = 224
              Width = 105
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 7
              ParentFont = False
              TabOrder = 13
              Text = ' '
            end
            object Prp_FirstName: TEdit
              Left = 250
              Top = 146
              Width = 139
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
              Text = ' '
            end
            object Prp_LastName: TEdit
              Left = 473
              Top = 146
              Width = 182
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 7
            end
          end
          object DiscounterPanel: TPanel
            Left = 9
            Top = 508
            Width = 742
            Height = 70
            BevelOuter = bvLowered
            TabOrder = 3
            object Label11: TLabel
              Left = 9
              Top = 9
              Width = 116
              Height = 18
              Caption = 'Discounter data:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label32: TLabel
              Left = 293
              Top = 34
              Width = 111
              Height = 17
              Caption = 'Proprietor Name:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label33: TLabel
              Left = 17
              Top = 34
              Width = 138
              Height = 17
              Caption = 'Registration Number:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Prp_DiscNo: TEdit
              Left = 172
              Top = 34
              Width = 107
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object Prp_DiscNm: TEdit
              Left = 422
              Top = 34
              Width = 312
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
          end
          object LogoPanel: TPanel
            Left = 9
            Top = 405
            Width = 742
            Height = 87
            BevelOuter = bvLowered
            BorderWidth = 1
            TabOrder = 2
            object Label84: TLabel
              Left = 9
              Top = 9
              Width = 105
              Height = 18
              Caption = 'Company Logo'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object vtLabel1: TvtLabel
              Left = 9
              Top = 26
              Width = 661
              Height = 51
              Caption = 
                'If you have a company Logo (graphic), you can insert it into the' +
                ' Client Letters such the Covering Letter (CLetter), the Privacy ' +
                'Act Letter (PIPEDA) and the Engangement Letter (ENGAGE). See Con' +
                'figure | Client Letter Design after you finish this window)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              WordWrap = True
              vtBorderType = vtlblNoBorder
            end
          end
          object ReviewerPanel: TPanel
            Left = 9
            Top = 302
            Width = 742
            Height = 96
            BevelOuter = bvLowered
            BorderWidth = 1
            TabOrder = 1
            object Label51: TLabel
              Left = 17
              Top = 9
              Width = 429
              Height = 18
              Caption = 'Reviewer Identification (i.e. Supervisor or other Tax Advisor)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label60: TLabel
              Left = 86
              Top = 34
              Width = 43
              Height = 17
              Caption = 'Name:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label89: TLabel
              Left = 26
              Top = 69
              Width = 98
              Height = 17
              Caption = 'Email Address:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label90: TLabel
              Left = 577
              Top = 9
              Width = 30
              Height = 17
              Caption = 'Area'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label92: TLabel
              Left = 534
              Top = 34
              Width = 22
              Height = 17
              Caption = 'Tel:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label95: TLabel
              Left = 638
              Top = 9
              Width = 52
              Height = 17
              Caption = 'Number'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Reviewer_Name: TEdit
              Left = 164
              Top = 34
              Width = 337
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
            end
            object Reviewer_EMail: TEdit
              Left = 164
              Top = 60
              Width = 337
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              Text = ' '
            end
            object Reviewer_Area: TEdit
              Left = 569
              Top = 28
              Width = 46
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = ' '
            end
            object Reviewer_Tel: TEdit
              Left = 620
              Top = 28
              Width = 105
              Height = 25
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Billing/Invoice'
      ImageIndex = 1
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 1098
        Height = 691
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object FeesPanel: TPanel
          Left = 261
          Top = 46
          Width = 335
          Height = 136
          BevelOuter = bvLowered
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          object Label17: TLabel
            Left = 10
            Top = 1
            Width = 91
            Height = 18
            Caption = 'Flat Fees ($):'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label18: TLabel
            Left = 17
            Top = 26
            Width = 71
            Height = 17
            Caption = 'Very small '
          end
          object Label19: TLabel
            Left = 17
            Top = 78
            Width = 53
            Height = 17
            Caption = 'Average'
          end
          object Label20: TLabel
            Left = 190
            Top = 26
            Width = 58
            Height = 17
            Caption = 'Complex'
          end
          object Label21: TLabel
            Left = 17
            Top = 52
            Width = 41
            Height = 17
            Caption = 'Small '
          end
          object Label23: TLabel
            Left = 155
            Top = 52
            Width = 90
            Height = 17
            Caption = 'Very Complex'
          end
          object Prp_VSFee: TEdit
            Left = 103
            Top = 26
            Width = 47
            Height = 24
            BorderStyle = bsNone
            TabOrder = 0
            Text = ' '
          end
          object Prp_SFee: TEdit
            Left = 103
            Top = 52
            Width = 47
            Height = 24
            BorderStyle = bsNone
            TabOrder = 2
            Text = ' '
          end
          object Prp_AFee: TEdit
            Left = 103
            Top = 78
            Width = 47
            Height = 24
            BorderStyle = bsNone
            TabOrder = 4
            Text = ' '
          end
          object Prp_CFee: TEdit
            Left = 258
            Top = 26
            Width = 47
            Height = 24
            BorderStyle = bsNone
            TabOrder = 1
            Text = ' '
          end
          object Prp_VCFee: TEdit
            Left = 258
            Top = 52
            Width = 47
            Height = 24
            BorderStyle = bsNone
            TabOrder = 3
            Text = ' '
          end
        end
        object FooterPanel: TPanel
          Left = 26
          Top = 405
          Width = 738
          Height = 173
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 7
          object Label22: TLabel
            Left = 9
            Top = 9
            Width = 441
            Height = 18
            Caption = 'Invoice footer (Free format text to appear at bottom of Invoice)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object InvFoot1: TEdit
            Left = 9
            Top = 34
            Width = 670
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 0
          end
          object InvFoot2: TEdit
            Left = 9
            Top = 60
            Width = 670
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 1
          end
          object InvFoot3: TEdit
            Left = 9
            Top = 86
            Width = 670
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 2
          end
          object InvFoot4: TEdit
            Left = 9
            Top = 112
            Width = 670
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 3
          end
          object InvFoot5: TEdit
            Left = 9
            Top = 138
            Width = 670
            Height = 24
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 4
          end
        end
        object BillOptionPanel: TPanel
          Left = 26
          Top = 190
          Width = 475
          Height = 121
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 4
          object Label24: TLabel
            Left = 14
            Top = 11
            Width = 152
            Height = 18
            Caption = 'Default Billing Option'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object vtShape1: TvtShape
            Left = 181
            Top = 78
            Width = 18
            Height = 18
            Brush.Color = clBlack
            GradientColor = clBlack
            Shape = vtTriangleRight
            FillDirection = vtUpFill
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            Caption = ''
            CaptionX = 0
            CaptionY = 0
            CaptionCentered = True
            CaptionAngle = 0
            byUser = True
            vtPageBreak = False
            vtPageFooter = False
            vtIsPrintable = True
          end
          object ListBox1: TListBox
            Left = 15
            Top = 36
            Width = 150
            Height = 86
            Hint = 'Select by clicking '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 17
            Items.Strings = (
              '0. Manual Charge'
              '1. Fee per Form*'
              '2. Time Billing'
              '3. Flat fee')
            ParentFont = False
            TabOrder = 0
            OnClick = ListBox1Click
          end
          object Prp_Bill: TEdit
            Left = 213
            Top = 69
            Width = 29
            Height = 24
            TabStop = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            Text = ' '
          end
          object FeesBtn: TBitBtn
            Left = 267
            Top = 69
            Width = 199
            Height = 31
            Hint = 'Set up the Form Fee Schedule'
            Caption = '*   Form Fee Schedule...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = FeesBtnClick
          end
        end
        object GstPanel: TPanel
          Left = 26
          Top = 43
          Width = 225
          Height = 139
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 2
          object Label10: TLabel
            Left = 17
            Top = 34
            Width = 56
            Height = 17
            Caption = 'GST No:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label29: TLabel
            Left = 17
            Top = 60
            Width = 96
            Height = 17
            Caption = 'GST/HST rate:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label30: TLabel
            Left = 207
            Top = 60
            Width = 13
            Height = 17
            Caption = '%'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label13: TLabel
            Left = 18
            Top = 1
            Width = 63
            Height = 18
            Caption = 'GST info'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label133: TLabel
            Left = 17
            Top = 95
            Width = 64
            Height = 17
            Caption = 'PST Rate'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label134: TLabel
            Left = 207
            Top = 86
            Width = 13
            Height = 17
            Caption = '%'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
          object Prp_GstNo: TEdit
            Left = 138
            Top = 34
            Width = 81
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Opr_GstHst: TEdit
            Left = 138
            Top = 60
            Width = 53
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object Opr_PST: TEdit
            Left = 138
            Top = 86
            Width = 53
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object PstOnInvoice: TCheckBox
            Left = 52
            Top = 112
            Width = 147
            Height = 21
            Caption = 'Use PST on Invoice'
            TabOrder = 3
          end
        end
        object HourlyPanel: TPanel
          Left = 620
          Top = 34
          Width = 144
          Height = 148
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 1
          object Label25: TLabel
            Left = 5
            Top = 2
            Width = 51
            Height = 16
            Caption = 'Charge'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Ms Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label125: TLabel
            Left = 5
            Top = 20
            Width = 80
            Height = 16
            Caption = 'per hour ($)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Ms Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Prp_Hour: TEdit
            Left = 9
            Top = 59
            Width = 55
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = ' '
          end
        end
        object Panel13: TPanel
          Left = 0
          Top = 0
          Width = 1094
          Height = 31
          Align = alTop
          Caption = ' Billing and Invoice'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -27
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object DiscountPanel: TPanel
          Left = 517
          Top = 190
          Width = 247
          Height = 121
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 5
          object Label58: TLabel
            Left = 9
            Top = 17
            Width = 144
            Height = 18
            Caption = 'Discount for seniors'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label86: TLabel
            Left = 69
            Top = 69
            Width = 58
            Height = 17
            Caption = 'Discount'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label87: TLabel
            Left = 172
            Top = 69
            Width = 13
            Height = 17
            Caption = '%'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object AutoSeniorDiscount: TCheckBox
            Left = 9
            Top = 43
            Width = 156
            Height = 21
            Alignment = taLeftJustify
            Caption = 'Apply automatically'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object DiscountForSeniors: TEdit
            Left = 129
            Top = 69
            Width = 36
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 6
            ParentFont = False
            TabOrder = 1
          end
        end
        object Panel4: TPanel
          Left = 26
          Top = 319
          Width = 738
          Height = 87
          BevelOuter = bvLowered
          TabOrder = 6
          object Label120: TLabel
            Left = 17
            Top = 9
            Width = 136
            Height = 18
            Caption = 'Invoice numbering:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label124: TLabel
            Left = 155
            Top = 9
            Width = 576
            Height = 17
            Caption = 
              'The default invoice consists of the client SIN followed by the t' +
              'ax year i.e. 123456789-2008'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label126: TLabel
            Left = 16
            Top = 26
            Width = 79
            Height = 18
            Caption = 'OR Option:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label127: TLabel
            Left = 249
            Top = 26
            Width = 458
            Height = 17
            Caption = 
              'The invoice number will be in the format:  Prefix + Seq Number +' +
              ' Suffix'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label129: TLabel
            Left = 292
            Top = 60
            Width = 41
            Height = 17
            Caption = 'Prefix:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label130: TLabel
            Left = 430
            Top = 60
            Width = 106
            Height = 17
            Caption = 'Starting Seq No:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label131: TLabel
            Left = 602
            Top = 60
            Width = 40
            Height = 17
            Caption = 'Suffix:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label128: TLabel
            Left = 33
            Top = 60
            Width = 224
            Height = 17
            Caption = 'Enter at least the Starting Seq. No.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label132: TLabel
            Left = 119
            Top = 43
            Width = 607
            Height = 17
            Caption = 
              'You may end the prefix with a hyphen and/or start the suffix wit' +
              'h a hyphen for visual separation'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object InvPrefix: TEdit
            Left = 336
            Top = 60
            Width = 81
            Height = 19
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 11
            ParentFont = False
            TabOrder = 1
          end
          object InvStartNo: TEdit
            Left = 534
            Top = 60
            Width = 62
            Height = 19
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 5
            ParentFont = False
            TabOrder = 2
          end
          object InvSuffix: TEdit
            Left = 646
            Top = 60
            Width = 44
            Height = 19
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 4
            ParentFont = False
            TabOrder = 3
          end
          object SerializeInvoice: TCheckBox
            Left = 95
            Top = 26
            Width = 147
            Height = 21
            Caption = 'Serialize Invoice No.'
            TabOrder = 0
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Data Directories'
      ImageIndex = 2
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 0
        Width = 1098
        Height = 691
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Label46: TLabel
          Left = 10
          Top = 66
          Width = 112
          Height = 17
          Caption = 'Current Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label47: TLabel
          Left = 10
          Top = 103
          Width = 109
          Height = 17
          Caption = 'Default Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Prior1Lbl: TLabel
          Left = 4
          Top = 363
          Width = 63
          Height = 16
          Caption = 'Prior1Lbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label49: TLabel
          Left = 250
          Top = 86
          Width = 266
          Height = 15
          Caption = '(To be used in this session - Max 60 characters))'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label50: TLabel
          Left = 250
          Top = 126
          Width = 305
          Height = 15
          Caption = '(To be used at start-up time. Normally same as current) '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label52: TLabel
          Left = 251
          Top = 359
          Width = 458
          Height = 20
          Caption = 'Last year'#39's DATA and Program folders (For ROLL-OVER)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Bevel1: TBevel
          Left = 9
          Top = 534
          Width = 680
          Height = 1
        end
        object Label53: TLabel
          Left = 260
          Top = 37
          Width = 286
          Height = 20
          Caption = 'Required VisualTax data directories'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -17
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object TyT: TLabel
          Left = 247
          Top = 449
          Width = 437
          Height = 16
          Caption = 
            'Typically C:\VT\T1-2022\data (and for Limited  version: C:\VT-T1' +
            'DATA22 )'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object CurDirLbl: TLabel
          Left = 7
          Top = 46
          Width = 65
          Height = 16
          Caption = 'CurDirLbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label93: TLabel
          Left = 7
          Top = 232
          Width = 102
          Height = 17
          Caption = 'Tax Planner Dir.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label94: TLabel
          Left = 247
          Top = 255
          Width = 327
          Height = 15
          Caption = 'To be used for storing tax planner returns (N/A to T1 Limited)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label96: TLabel
          Left = 9
          Top = 556
          Width = 218
          Height = 17
          Caption = 'Remind me to backup data every '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label98: TLabel
          Left = 286
          Top = 558
          Width = 31
          Height = 17
          Caption = 'days'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label97: TLabel
          Left = 53
          Top = 659
          Width = 171
          Height = 17
          Caption = 'Most recent back up folder'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label99: TLabel
          Left = 6
          Top = 536
          Width = 89
          Height = 16
          Caption = 'Data backup'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label100: TLabel
          Left = 9
          Top = 582
          Width = 159
          Height = 17
          Caption = 'Default Backup directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label101: TLabel
          Left = 224
          Top = 608
          Width = 443
          Height = 17
          Caption = 
            '(The actual backup will be below the above dir as Backup01, 02, ' +
            'etc)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label102: TLabel
          Left = 250
          Top = 625
          Width = 532
          Height = 17
          Caption = 
            '(An external  drive (i.e. flash drive) directory is recommended ' +
            'for multiple backups)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label103: TLabel
          Left = 251
          Top = 464
          Width = 236
          Height = 16
          Caption = 'It will be used for ROLL-OVER purposes'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label121: TLabel
          Left = 6
          Top = 389
          Width = 222
          Height = 17
          Caption = 'PROGRAM name used last year...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label122: TLabel
          Left = 6
          Top = 423
          Width = 221
          Height = 17
          Caption = 'DATA DIRECTORY used last year'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label138: TLabel
          Left = 10
          Top = 489
          Width = 235
          Height = 17
          Caption = 'PROGRAM install directory last year'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label62: TLabel
          Left = 7
          Top = 274
          Width = 180
          Height = 17
          Caption = 'Client Documents Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label141: TLabel
          Left = 247
          Top = 298
          Width = 426
          Height = 15
          Caption = 
            'For storing Client Documents (i.e Scanned slips, Tax return in P' +
            'DF format, etc)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label145: TLabel
          Left = 752
          Top = 506
          Width = 157
          Height = 37
          AutoSize = False
          Caption = 
            'Data directory of the T1-2018 production data prior to Multi-App' +
            '. Typically enter  C:\T1-2018\data. To be used as the source to ' +
            'import data into the Multi-App version'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Bevel2: TBevel
          Left = 0
          Top = 359
          Width = 733
          Height = 1
        end
        object Label147: TLabel
          Left = 7
          Top = 190
          Width = 144
          Height = 17
          Caption = 'Auto-Fill data directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label148: TLabel
          Left = 247
          Top = 213
          Width = 362
          Height = 15
          Caption = 
            '(To be used  for the Auto-fill history of submissions/receipts o' +
            'f data'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label34: TLabel
          Left = 7
          Top = 318
          Width = 215
          Height = 17
          Caption = 'Client Permanent Docs Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label35: TLabel
          Left = 247
          Top = 342
          Width = 356
          Height = 15
          Caption = 'For storing permanent Client Documents independant of tax year '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label150: TLabel
          Left = 243
          Top = 509
          Width = 478
          Height = 16
          Caption = 
            'Typically: C:\VT-2022\T1-2022  (for Roll-over and side by side  ' +
            'display purposes)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label139: TLabel
          Left = 10
          Top = 508
          Width = 227
          Height = 17
          Caption = '(Needed to see forms side by side)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label152: TLabel
          Left = 10
          Top = 148
          Width = 109
          Height = 17
          Caption = 'Re-file Directory '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label153: TLabel
          Left = 250
          Top = 176
          Width = 258
          Height = 15
          Caption = '(To store non-modified returns before Re-refile)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object SelectCurBtn: TBitBtn
          Left = 138
          Top = 75
          Width = 87
          Height = 19
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = SelectCurBtnClick
        end
        object SelectDefBtn: TBitBtn
          Left = 138
          Top = 103
          Width = 87
          Height = 20
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = SelectDefBtnClick
        end
        object SelectL1Btn: TBitBtn
          Left = 152
          Top = 443
          Width = 70
          Height = 26
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 16
          OnClick = SelectL1BtnClick
        end
        object Dir_Cur: TEdit
          Left = 250
          Top = 60
          Width = 466
          Height = 25
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object Dir_Deflt: TEdit
          Left = 250
          Top = 101
          Width = 466
          Height = 24
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object Dir_LastYr: TEdit
          Left = 247
          Top = 425
          Width = 458
          Height = 24
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 15
        end
        object Panel17: TPanel
          Left = 742
          Top = 65
          Width = 205
          Height = 429
          Color = 15461355
          TabOrder = 3
          object Label36: TLabel
            Left = 4
            Top = 4
            Width = 145
            Height = 16
            Caption = 'Hard Disk examples:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Ms Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label42: TLabel
            Left = 9
            Top = 34
            Width = 119
            Height = 16
            Caption = 'C:\VT\T1-2023\Data'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label43: TLabel
            Left = 36
            Top = 268
            Width = 155
            Height = 126
            Caption = 
              '- In the Multi-Office version of the program the Default directo' +
              'ry needs also to be defined in Configure | Multi-user for each u' +
              'ser'
            Color = 14869218
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            WordWrap = True
          end
          object Label44: TLabel
            Left = 9
            Top = 71
            Width = 88
            Height = 16
            Caption = 'G:\xxxxx\DATA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label45: TLabel
            Left = 12
            Top = 150
            Width = 105
            Height = 16
            Caption = 'C:\VT-T1DATA21'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label31: TLabel
            Left = 10
            Top = 128
            Width = 128
            Height = 16
            Caption = 'Limited T1 version'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Ms Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label107: TLabel
            Left = 12
            Top = 169
            Width = 155
            Height = 13
            Caption = '(Current,Default and TaxPlanner)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -10
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 1094
          Height = 31
          Align = alTop
          Caption = ' Data Directories'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -27
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object CreateNewDirBtn: TBitBtn
          Left = 138
          Top = 49
          Width = 87
          Height = 20
          Hint = 'Click if directory already exists'
          Caption = 'New folder...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = CreateNewDirBtnClick
        end
        object SelectDirPlannerBtn: TBitBtn
          Left = 135
          Top = 232
          Width = 87
          Height = 19
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
          OnClick = SelectDirPlannerBtnClick
        end
        object Dir_Planner: TEdit
          Left = 247
          Top = 229
          Width = 466
          Height = 25
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object BackupFrequency: TEdit
          Left = 247
          Top = 556
          Width = 30
          Height = 24
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 20
        end
        object LastBackupDir: TEdit
          Left = 290
          Top = 657
          Width = 400
          Height = 25
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 23
        end
        object BackupDir: TEdit
          Left = 247
          Top = 582
          Width = 400
          Height = 25
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 21
        end
        object SelectBackupDirBtn: TBitBtn
          Left = 181
          Top = 585
          Width = 61
          Height = 19
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 22
          OnClick = SelectBackupDirBtnClick
        end
        object RolloverProgram: TComboBox
          Left = 247
          Top = 390
          Width = 165
          Height = 25
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
          Text = 'VisualTax'
          Items.Strings = (
            'VisualTax'
            'CanTax'
            'Profile'
            'TaxCycle')
        end
        object Dir_PgmLastYr: TEdit
          Left = 247
          Top = 486
          Width = 458
          Height = 24
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 17
        end
        object Dir_ClientDocs: TEdit
          Left = 247
          Top = 272
          Width = 466
          Height = 25
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
        end
        object SelectDirClientDocBtn: TBitBtn
          Left = 135
          Top = 292
          Width = 87
          Height = 19
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 11
          OnClick = SelectDirClientDocBtnClick
        end
        object SelectDBFBtn: TBitBtn
          Left = 742
          Top = 549
          Width = 87
          Height = 20
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 19
          OnClick = SelectDBFBtnClick
        end
        object Dir_DBFData: TEdit
          Left = 846
          Top = 546
          Width = 45
          Height = 25
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 18
        end
        object Dir_AutoFill: TEdit
          Left = 247
          Top = 188
          Width = 466
          Height = 24
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object Dir_PermanentDocs: TEdit
          Left = 247
          Top = 316
          Width = 466
          Height = 25
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
        end
        object btnSelectPermanentDir: TBitBtn
          Left = 135
          Top = 336
          Width = 87
          Height = 19
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 13
          OnClick = btnSelectPermanentDirClick
        end
        object Dir_refile: TEdit
          Left = 247
          Top = 145
          Width = 466
          Height = 25
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 24
          Visible = False
        end
        object SelectRefileBtn: TBitBtn
          Left = 138
          Top = 148
          Width = 87
          Height = 20
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 25
          Visible = False
          OnClick = SelectDefBtnClick
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Display'
      ImageIndex = 5
      object ScrollBox4: TScrollBox
        Left = 0
        Top = 0
        Width = 1098
        Height = 691
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Panel19: TPanel
          Left = 0
          Top = 0
          Width = 1094
          Height = 31
          Align = alTop
          Caption = ' Display'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -27
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object Panel23: TPanel
          Left = 9
          Top = 34
          Width = 44
          Height = 519
          BevelOuter = bvLowered
          TabOrder = 1
          Visible = False
          object Label77: TLabel
            Left = 78
            Top = 43
            Width = 97
            Height = 16
            Caption = 'Available colors'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label80: TLabel
            Left = 17
            Top = 43
            Width = 42
            Height = 16
            Caption = 'Color #'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label82: TLabel
            Left = 17
            Top = 9
            Width = 164
            Height = 16
            Caption = 'Form color of first return'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label83: TLabel
            Left = 34
            Top = 26
            Width = 136
            Height = 16
            Caption = '(Click available colors)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Panel24: TPanel
            Left = 9
            Top = 60
            Width = 182
            Height = 432
            BevelOuter = bvLowered
            Color = clWhite
            TabOrder = 0
            object Clr1: TvtLabel
              Left = 52
              Top = 43
              Width = 123
              Height = 36
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object Clr3: TvtLabel
              Left = 52
              Top = 112
              Width = 123
              Height = 36
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object Clr4: TvtLabel
              Left = 52
              Top = 146
              Width = 123
              Height = 36
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object Clr5: TvtLabel
              Left = 52
              Top = 181
              Width = 123
              Height = 36
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object Clr6: TvtLabel
              Left = 52
              Top = 215
              Width = 123
              Height = 36
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object clr7: TvtLabel
              Left = 52
              Top = 250
              Width = 123
              Height = 36
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              OnClick = clr7Click
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object clr8: TvtLabel
              Left = 52
              Top = 284
              Width = 123
              Height = 36
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              OnClick = clr8Click
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object Clr9: TvtLabel
              Left = 52
              Top = 319
              Width = 123
              Height = 35
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              OnClick = Clr9Click
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object Clr10: TvtLabel
              Left = 52
              Top = 353
              Width = 123
              Height = 36
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              OnClick = Clr10Click
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object Clr11: TvtLabel
              Left = 52
              Top = 388
              Width = 123
              Height = 35
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              OnClick = Clr11Click
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object Clr2: TvtLabel
              Left = 52
              Top = 78
              Width = 123
              Height = 35
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtTransparent = False
              vtBorderType = vtlblFull
            end
            object vtLabel16: TvtLabel
              Left = 17
              Top = 17
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '1'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel17: TvtLabel
              Left = 17
              Top = 52
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '2'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel18: TvtLabel
              Left = 17
              Top = 86
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '3'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel19: TvtLabel
              Left = 17
              Top = 121
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '4'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel20: TvtLabel
              Left = 17
              Top = 155
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '5'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel21: TvtLabel
              Left = 17
              Top = 190
              Width = 27
              Height = 20
              Alignment = taCenter
              AutoSize = False
              Caption = '6'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel22: TvtLabel
              Left = 17
              Top = 224
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '7'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel23: TvtLabel
              Left = 17
              Top = 258
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '8'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel24: TvtLabel
              Left = 17
              Top = 293
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '9'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel25: TvtLabel
              Left = 17
              Top = 327
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '10'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel26: TvtLabel
              Left = 17
              Top = 362
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '11'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object vtLabel27: TvtLabel
              Left = 17
              Top = 396
              Width = 27
              Height = 21
              Alignment = taCenter
              AutoSize = False
              Caption = '12'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblFull
            end
            object Clr0: TvtLabel
              Left = 52
              Top = 9
              Width = 123
              Height = 35
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              OnClick = Clr0Click
              vtTransparent = False
              vtBorderType = vtlblFull
            end
          end
        end
        object Panel25: TPanel
          Left = 60
          Top = 43
          Width = 749
          Height = 596
          BevelOuter = bvLowered
          TabOrder = 2
          object Panel6: TPanel
            Left = 335
            Top = 142
            Width = 228
            Height = 35
            BevelOuter = bvLowered
            TabOrder = 2
            Visible = False
          end
          object FormSizePanel: TPanel
            Left = 335
            Top = 183
            Width = 225
            Height = 113
            BevelOuter = bvLowered
            TabOrder = 4
            object Label75: TLabel
              Left = 9
              Top = 9
              Width = 179
              Height = 16
              Caption = 'Form Size (zoom) in effect'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label57: TLabel
              Left = 43
              Top = 57
              Width = 4
              Height = 20
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label73: TLabel
              Left = 121
              Top = 31
              Width = 15
              Height = 19
              Caption = '%'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label74: TLabel
              Left = 9
              Top = 59
              Width = 179
              Height = 34
              Caption = '(automatically set by the +- zoom of main form)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object FormZoom: TEdit
              Left = 69
              Top = 30
              Width = 44
              Height = 27
              Hint = 'It can be set also via the Zoom in main menu'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ReadOnly = True
              ShowHint = True
              TabOrder = 0
            end
          end
          object SetDisplayPanel: TPanel
            Left = 335
            Top = 377
            Width = 225
            Height = 166
            BevelOuter = bvLowered
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 7
            object Label9: TLabel
              Left = 9
              Top = 9
              Width = 200
              Height = 19
              Caption = 'Set the display resolution'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label37: TLabel
              Left = 17
              Top = 36
              Width = 175
              Height = 68
              Caption = 
                'Changing the display resolution will affect all other programs (' +
                'as if using the Control Panel) '
              WordWrap = True
            end
            object SetDisplayBtn: TBitBtn
              Left = 26
              Top = 110
              Width = 165
              Height = 30
              Caption = 'Set Display Resolution...'
              TabOrder = 0
            end
          end
          object NavigPanel: TPanel
            Left = 9
            Top = 241
            Width = 320
            Height = 320
            BevelOuter = bvLowered
            TabOrder = 5
            object Label38: TLabel
              Left = 9
              Top = 0
              Width = 196
              Height = 20
              Caption = 'Navigation and warnings'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label79: TLabel
              Left = 34
              Top = 276
              Width = 175
              Height = 17
              Caption = '(in Multi-office version only)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label91: TLabel
              Left = 43
              Top = 164
              Width = 191
              Height = 34
              Caption = 'If Checked, the buttons of all other slips show on every slip'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object ShowFinWarning: TCheckBox
              Left = 17
              Top = 258
              Width = 200
              Height = 21
              Hint = 'Available only in the Multi-office version'
              Caption = 'Show Financial Warning'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 7
            end
            object UseFormSearch: TCheckBox
              Left = 17
              Top = 69
              Width = 277
              Height = 21
              Hint = 'Otherwise the GOTO (F6) defaults to Line No'
              Caption = 'Use FORM vs Line as default search'
              Checked = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 2
            end
            object OtherSlipsButtons: TCheckBox
              Left = 17
              Top = 146
              Width = 208
              Height = 21
              Caption = 'Show Other Slips buttons'
              Checked = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 4
            end
            object ShowUsedForms: TCheckBox
              Left = 17
              Top = 207
              Width = 286
              Height = 21
              Caption = 'Show forms used last time you saved '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
            end
            object OpenAtLastForm: TCheckBox
              Left = 43
              Top = 224
              Width = 251
              Height = 21
              Caption = 'If ticked, open at last form used'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
            end
            object Use2YearSummary: TCheckBox
              Left = 17
              Top = 43
              Width = 277
              Height = 21
              Hint = 'Otherwise the GOTO (F6) defaults to Line No'
              Caption = 'Use 2-year summary as default'
              Checked = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 1
            end
            object EscOption: TRadioGroup
              Left = 17
              Top = 95
              Width = 294
              Height = 44
              Caption = 'ESC key - When pressed on a form it will'
              Columns = 2
              Items.Strings = (
                'Close the form'
                'Go to Tax Summary')
              TabOrder = 3
            end
            object OpenCouple: TCheckBox
              Left = 17
              Top = 17
              Width = 277
              Height = 21
              Hint = 'Otherwise the GOTO (F6) defaults to Line No'
              Caption = 'Open couple without warning'
              Checked = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 0
            end
          end
          object BoldDataPanel: TPanel
            Left = 336
            Top = 17
            Width = 225
            Height = 119
            BevelOuter = bvLowered
            TabOrder = 1
            object Label76: TLabel
              Left = 9
              Top = 9
              Width = 102
              Height = 20
              Caption = 'Form display'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object DataInBold: TCheckBox
              Left = 9
              Top = 26
              Width = 208
              Height = 21
              Alignment = taLeftJustify
              Caption = 'Show data in Bold in all forms'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object Prp_NameAsTitle: TCheckBox
              Left = 9
              Top = 60
              Width = 208
              Height = 46
              Alignment = taLeftJustify
              Caption = 'Show Company name instead of '#39'VisualTax'#39' in the Mainform'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              WordWrap = True
            end
          end
          object ColorsPanel: TPanel
            Left = 9
            Top = 17
            Width = 320
            Height = 217
            BevelOuter = bvLowered
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            object Label41: TLabel
              Left = 9
              Top = 60
              Width = 225
              Height = 16
              Caption = 'Color on entry to a field of a form'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object vtLabel2: TvtLabel
              Left = 26
              Top = 146
              Width = 167
              Height = 17
              Caption = 'Linked field color is set to:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblNoBorder
            end
            object vtLabel3: TvtLabel
              Left = 9
              Top = 190
              Width = 198
              Height = 17
              Caption = 'Calculated  field color is set to:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              vtBorderType = vtlblNoBorder
            end
            object Label142: TLabel
              Left = 112
              Top = 9
              Width = 52
              Height = 20
              Caption = 'Colors'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object UseDefaultBoxColor: TBitBtn
              Left = 52
              Top = 86
              Width = 130
              Height = 36
              Caption = 'Change color...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              OnClick = UseDefaultBoxColorClick
            end
            object LinkedBoxColor: TEdit
              Left = 190
              Top = 146
              Width = 104
              Height = 25
              TabStop = False
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 3
              Text = 'LinkedBoxColor'
            end
            object ProtectedBoxColor: TEdit
              Left = 190
              Top = 181
              Width = 104
              Height = 25
              TabStop = False
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 4
              Text = 'ProtectedBoxColor'
            end
            object ActiveBoxColor: TEdit
              Left = 190
              Top = 94
              Width = 104
              Height = 24
              TabStop = False
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              Text = 'ActiveBoxColor'
            end
            object RetainRetColor: TCheckBox
              Left = 9
              Top = 26
              Width = 277
              Height = 21
              Hint = 'Otherwise the GOTO (F6) defaults to Line No'
              Caption = 'Retain return Color upon saving it '
              Checked = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 0
            end
          end
          object Panel1: TPanel
            Left = 335
            Top = 302
            Width = 225
            Height = 69
            BevelOuter = bvLowered
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 6
            object Label117: TLabel
              Left = 9
              Top = 9
              Width = 166
              Height = 19
              Caption = 'Most Recent Returns'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object HideMostRecent: TCheckBox
              Left = 9
              Top = 34
              Width = 173
              Height = 21
              Caption = 'Hide most recent returns'
              TabOrder = 0
            end
          end
          object MaximizeMainForm: TCheckBox
            Left = 344
            Top = 151
            Width = 208
            Height = 21
            Alignment = taLeftJustify
            Caption = 'Maximize main form at startup'
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            State = cbChecked
            TabOrder = 3
            Visible = False
          end
          object GroupBox1: TGroupBox
            Left = 576
            Top = 16
            Width = 169
            Height = 65
            Caption = 'Preferred Interface'
            TabOrder = 8
            object Skin: TComboBox
              Left = 16
              Top = 24
              Width = 137
              Height = 24
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 0
              Text = 'VisualTax Classic'
              Items.Strings = (
                'VisualTax Classic'
                'Small ToolBar'
                'Large Toolbar'
                'Ribbon')
            end
          end
          object GroupBox2: TGroupBox
            Left = 576
            Top = 87
            Width = 169
            Height = 91
            Caption = 'Active tab color'
            TabOrder = 9
            object ActiveTabColor: TShape
              Left = 16
              Top = 24
              Width = 137
              Height = 21
            end
            object SetActiveTabColor: TBitBtn
              Left = 16
              Top = 48
              Width = 137
              Height = 36
              Caption = 'Change color...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = SetActiveTabColorClick
            end
          end
        end
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Defaults/Tax returns'
      ImageIndex = 6
      object ScrollBox5: TScrollBox
        Left = 0
        Top = 0
        Width = 1098
        Height = 691
        HorzScrollBar.Tracking = True
        VertScrollBar.Position = 32
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object DefaultsPanel: TGroupBox
          Left = -15
          Top = 71
          Width = 895
          Height = 616
          Caption = 'Default values for tax returns'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object Label70: TLabel
            Left = 17
            Top = 241
            Width = 501
            Height = 17
            Caption = 
              'AUTHREP-Default Authorization: 1=Disclose    2=Disclose/Request ' +
              'Changes'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label63: TLabel
            Left = 20
            Top = 279
            Width = 451
            Height = 17
            Caption = 'PRE-ASSESSMENT CONTACT (CV)   (2=Preparer By Mail  3=Client)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label71: TLabel
            Left = 17
            Top = 571
            Width = 191
            Height = 18
            Caption = 'ROLLOVER from prior year'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label28: TLabel
            Left = 20
            Top = 505
            Width = 328
            Height = 18
            Caption = 'DISCLAIMERS  (Leave it blank, if not required)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label15: TLabel
            Left = 18
            Top = 55
            Width = 100
            Height = 17
            Caption = 'DEFAULT CITY'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label16: TLabel
            Left = 18
            Top = 26
            Width = 148
            Height = 17
            Caption = 'DEFAULT PROVINCE:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label140: TLabel
            Left = 20
            Top = 302
            Width = 456
            Height = 17
            Caption = 'POST-ASSESSMENT CONTACT (CV)  (2=Preparer By Mail  3=Client)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label143: TLabel
            Left = 27
            Top = 526
            Width = 65
            Height = 14
            Caption = 'On T1 Page 4'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label144: TLabel
            Left = 27
            Top = 554
            Width = 90
            Height = 14
            Caption = 'On S/E Statements'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label151: TLabel
            Left = 662
            Top = 19
            Width = 116
            Height = 17
            Caption = 'Must use SIN only'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Prp_Elect: TCheckBox
            Left = 17
            Top = 129
            Width = 751
            Height = 21
            Caption = 
              'ELECTIONS CANADA: If checked, the Elections Canada question on P' +
              'age 1, defaults to Yes for new returns'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
          object Prp_EfRepr: TCheckBox
            Left = 17
            Top = 164
            Width = 734
            Height = 21
            Caption = 
              'T183 REPRESENTATION: If checked, the Representation question in ' +
              'T183, defaults to Yes for new returns'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 6
          end
          object Prp_Dates: TCheckBox
            Left = 17
            Top = 327
            Width = 708
            Height = 21
            Caption = 
              'SIGNATURE DATE: If checked, the program will automatically fill ' +
              'Signature dates with today'#39's date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 11
          end
          object T1013AuthorLevel: TComboBox
            Left = 594
            Top = 240
            Width = 122
            Height = 25
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 8
            Text = 'T1013AuthorLevel'
            Items.Strings = (
              '1'
              '2')
          end
          object CVSetting: TComboBox
            Left = 482
            Top = 266
            Width = 114
            Height = 25
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 9
            Items.Strings = (
              ''
              '2 By mail'
              '3 Client')
          end
          object UseCondominiumLine: TCheckBox
            Left = 17
            Top = 428
            Width = 656
            Height = 20
            Caption = 'BUSINESS USE OF HOME: Show Condominium/Telephone expense lines'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 17
          end
          object ShowInvoiceWarning: TCheckBox
            Left = 17
            Top = 361
            Width = 518
            Height = 21
            Caption = 'INVOICE: Show warning  if invoice not prepared'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 13
          end
          object ShowInvoiceEfCharge: TCheckBox
            Left = 17
            Top = 377
            Width = 406
            Height = 21
            Caption = 'INVOICE: Show Efile charge as separate item'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 14
          end
          object ShowConsultantOnInv: TCheckBox
            Left = 17
            Top = 394
            Width = 648
            Height = 21
            Caption = 
              'INVOICE: Multi-office version only: Show Consultant name on invo' +
              'ice'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 15
          end
          object RollOverT4T5: TCheckBox
            Left = 17
            Top = 588
            Width = 467
            Height = 21
            Caption = 'Rollover names of T4/T5  (Option in Roll-over from last year)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 23
          end
          object ShowSaluteWarning: TCheckBox
            Left = 17
            Top = 411
            Width = 587
            Height = 21
            Caption = 'SALUTATION: Show Warning if client Title (Mr, Mrs..) not entered'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 16
          end
          object Prn_Disclm: TEdit
            Left = 129
            Top = 522
            Width = 734
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 21
            Text = 'Prn_Disclm'
          end
          object Nfl_Prov: TComboBox
            Left = 190
            Top = 17
            Width = 113
            Height = 25
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'Nfl_Prov'
            Items.Strings = (
              'NL'
              'PE'
              'NS'
              'NB'
              'QC'
              'ON'
              'MB'
              'SK'
              'AB'
              'BC'
              'NT'
              'YT'
              'ZZ')
          end
          object Nfl_City: TEdit
            Left = 129
            Top = 52
            Width = 244
            Height = 24
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object Nfl_Disced: TRadioGroup
            Left = 379
            Top = 17
            Width = 270
            Height = 106
            Caption = 'COMPENSATION'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            Items.Strings = (
              'Prepared for compensation'
              'Prepared by Client'
              'Discounted return (Discounting Act)')
            ParentFont = False
            TabOrder = 1
          end
          object NoTypeAhead: TCheckBox
            Left = 17
            Top = 445
            Width = 406
            Height = 21
            Caption = 'DO NOT USE PREDICTIVE TYPING (Super Entry)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 18
          end
          object UseProperName: TCheckBox
            Left = 17
            Top = 462
            Width = 639
            Height = 21
            Caption = 
              'CLIENT LETTERS: Show proper format (Capitalize only first letter' +
              ')  in Name and Address '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 19
          end
          object Capitalization: TRadioGroup
            Left = 17
            Top = 78
            Width = 356
            Height = 44
            Caption = 'NAME/ADDRESS CAPITALIZATION: Convert to: '
            Columns = 3
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            Items.Strings = (
              'UpperCase'
              'ProperCase'
              'None')
            ParentFont = False
            TabOrder = 3
          end
          object DecimalAssume: TCheckBox
            Left = 17
            Top = 479
            Width = 742
            Height = 21
            Caption = 
              'DECIMAL ASSUME (if you enter 12345 it will register as 123.45) D' +
              'O NOT TICK it unless you are used to it'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 20
          end
          object Prp_Citizen: TCheckBox
            Left = 17
            Top = 146
            Width = 725
            Height = 21
            Caption = 
              'CANADIAN CITIZEN: If Checked, the Canadian Citizen question on P' +
              'age 1, defaults to Yes '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
          end
          object T1013Warn: TRadioGroup
            Left = 17
            Top = 190
            Width = 824
            Height = 44
            Caption = 'AUTHREP warning if form not completed'
            Columns = 3
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            Items.Strings = (
              'Warn only if not completed previously'
              'Never issue warning'
              'Always issue warning')
            ParentFont = False
            TabOrder = 7
          end
          object CVPostSetting: TComboBox
            Left = 482
            Top = 292
            Width = 114
            Height = 25
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 10
            Items.Strings = (
              ''
              '2 By mail'
              '3 Client')
          end
          object Bus_Disclm: TEdit
            Left = 129
            Top = 553
            Width = 734
            Height = 22
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 22
          end
          object ShowTaxSavings: TCheckBox
            Left = 18
            Top = 344
            Width = 536
            Height = 21
            Caption = 
              'INVOICE: Show tax savings due to Family Tax Cut or Pension Split' +
              'ting'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 12
          end
          object FileNameFormat: TRadioGroup
            Left = 655
            Top = 42
            Width = 237
            Height = 81
            Caption = 'FILE NAME FORMAT'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ItemIndex = 0
            Items.Strings = (
              'SIN 99999999.9'
              'LastName FirstName-{SIN}.YR')
            ParentFont = False
            TabOrder = 24
            OnClick = FileNameFormatClick
          end
        end
        object Panel21: TPanel
          Left = 0
          Top = -32
          Width = 1077
          Height = 31
          Align = alTop
          Caption = ' Defaults Settings'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -27
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'Internet Updates'
      ImageIndex = 8
      object ScrollBox6: TScrollBox
        Left = 0
        Top = 0
        Width = 1098
        Height = 691
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Label67: TLabel
          Left = 110
          Top = 59
          Width = 191
          Height = 19
          Caption = 'Check automatically every'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label68: TLabel
          Left = 208
          Top = 108
          Width = 35
          Height = 19
          Caption = 'days'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label69: TLabel
          Left = 95
          Top = 148
          Width = 220
          Height = 140
          Caption = 
            'If you set the frequency to 0, the program will never check the ' +
            'Internet automatically. You will need to initiate the internet c' +
            'heck manually via the Help | Check Update via the Web'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsItalic]
          ParentFont = False
          WordWrap = True
        end
        object UpdateFrequency: TEdit
          Left = 159
          Top = 98
          Width = 40
          Height = 25
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '7'
        end
        object Panel14: TPanel
          Left = 389
          Top = 60
          Width = 410
          Height = 397
          BevelWidth = 2
          Color = 15461355
          TabOrder = 1
          object Label61: TLabel
            Left = 20
            Top = 30
            Width = 352
            Height = 100
            Caption = 
              'The program will follow this schedule to automatically check the' +
              ' VisualTax web site for any updates available. If an update is a' +
              'vailable it will prompt you to download and install the update.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
          end
          object Label64: TLabel
            Left = 14
            Top = 128
            Width = 341
            Height = 100
            Caption = 
              'The program keeps track of the last time you checked the Interne' +
              't for any program update. Based on this schedule, it will initia' +
              'te automatically the Internet check at program start up time.'
            Color = 15461355
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentColor = False
            ParentFont = False
            WordWrap = True
          end
          object Label65: TLabel
            Left = 12
            Top = 226
            Width = 347
            Height = 60
            Caption = 
              'i.e: If you set the frequency to 1 (once a day), the first time ' +
              'in the day you start the program the Internet will be checked au' +
              'tomatically.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
          end
          object Label66: TLabel
            Left = 148
            Top = 10
            Width = 46
            Height = 19
            Caption = 'Notes'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label72: TLabel
            Left = 14
            Top = 292
            Width = 273
            Height = 40
            Caption = 'Note: The automatic Internet update does not work on Windows 98'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -17
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
          end
        end
        object Panel26: TPanel
          Left = 0
          Top = 0
          Width = 1094
          Height = 31
          Align = alTop
          Caption = ' Internet Updates'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -27
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Efile'
      ImageIndex = 8
      object ScrollBox7: TScrollBox
        Left = 0
        Top = 0
        Width = 1098
        Height = 691
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Nfl_Efile: TCheckBox
          Left = 250
          Top = 86
          Width = 251
          Height = 22
          Caption = 'Check if most returns are EFiled'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object EfMethodBox: TRadioGroup
          Left = 241
          Top = 121
          Width = 346
          Height = 87
          Caption = 'Default Efile method'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Items.Strings = (
            'On-line (EOL one at a time)'
            'On-line Plus (EOLP batch)')
          ParentFont = False
          TabOrder = 2
        end
        object SetupEOLBtn: TBitBtn
          Left = 327
          Top = 241
          Width = 139
          Height = 31
          Caption = 'SetUp EOL...'
          TabOrder = 3
          Visible = False
          OnClick = SetupEOLBtnClick
        end
        object SetupEOLPBtn: TBitBtn
          Left = 327
          Top = 293
          Width = 139
          Height = 31
          Caption = 'SetUp EOLP...'
          TabOrder = 4
          Visible = False
          OnClick = SetupEOLPBtnClick
        end
        object Panel28: TPanel
          Left = 0
          Top = 0
          Width = 1094
          Height = 31
          Align = alTop
          Caption = ' Efile'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -27
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Security/Password'
      ImageIndex = 7
      object ScrollBox8: TScrollBox
        Left = 0
        Top = 0
        Width = 1098
        Height = 691
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -14
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label146: TLabel
          Left = 26
          Top = 278
          Width = 161
          Height = 16
          Caption = 'Level of blocking of returns:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label149: TLabel
          Left = 26
          Top = 248
          Width = 439
          Height = 16
          Caption = 'Concurrent open of same return by more than one user - Options'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LoginPanel: TPanel
          Left = 26
          Top = 52
          Width = 557
          Height = 158
          BevelOuter = bvLowered
          TabOrder = 1
          object Label48: TLabel
            Left = 17
            Top = 9
            Width = 330
            Height = 16
            Caption = 'Login Id (If you are the only user of the program)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label55: TLabel
            Left = 52
            Top = 43
            Width = 76
            Height = 16
            Caption = 'Log in Name'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label119: TLabel
            Left = 59
            Top = 125
            Width = 331
            Height = 14
            Caption = 
              'Do not skip the Login window if you plan to set a Program Passwo' +
              'rd'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label39: TLabel
            Left = 59
            Top = 105
            Width = 484
            Height = 14
            Caption = 
              'If you skip it, you will also miss the Alerts and update status ' +
              'of your program that shows in the Login'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label123: TLabel
            Left = 7
            Top = 103
            Width = 46
            Height = 16
            Caption = 'Notes:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object SingleLoginId: TEdit
            Left = 134
            Top = 39
            Width = 149
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object SkipLogin: TCheckBox
            Left = 134
            Top = 69
            Width = 266
            Height = 21
            Caption = 'Skip the Login window is disallowed'
            TabOrder = 1
            OnClick = SkipLoginClick
          end
        end
        object PswPanel: TPanel
          Left = 596
          Top = 52
          Width = 227
          Height = 158
          BevelOuter = bvLowered
          TabOrder = 2
          object Label56: TLabel
            Left = 12
            Top = 9
            Width = 131
            Height = 16
            Caption = 'Program password'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object SetPgmPswBtn: TBitBtn
            Left = 17
            Top = 34
            Width = 191
            Height = 31
            Caption = 'Set Program Password...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = SetPgmPswBtnClick
          end
          object RemovePgmPswBtn: TBitBtn
            Left = 17
            Top = 69
            Width = 191
            Height = 31
            Caption = 'Remove Program Password'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -14
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = RemovePgmPswBtnClick
          end
        end
        object Panel27: TPanel
          Left = 0
          Top = 0
          Width = 1094
          Height = 31
          Align = alTop
          Caption = ' Security/Password'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -27
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object cbLockManagerLevel: TComboBox
          Left = 193
          Top = 270
          Width = 459
          Height = 24
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -14
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemIndex = 0
          ParentFont = False
          TabOrder = 3
          Text = 'Do not use locking'
          Items.Strings = (
            'Do not use locking'
            'Warn but allow simultaneous work with the return'
            'Disallow concurrent with the return')
        end
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Printing'
      ImageIndex = 8
      object ScrollBox9: TScrollBox
        Left = 0
        Top = 0
        Width = 1098
        Height = 691
        Align = alClient
        TabOrder = 0
        object Panel29: TPanel
          Left = 0
          Top = 0
          Width = 1094
          Height = 31
          Align = alTop
          Caption = ' Printing'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -27
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object HeadersPanel: TPanel
          Left = 335
          Top = 171
          Width = 337
          Height = 138
          BevelOuter = bvLowered
          TabOrder = 5
          object Label59: TLabel
            Left = 17
            Top = 56
            Width = 133
            Height = 16
            Caption = 'add Headings with:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label54: TLabel
            Left = 11
            Top = 8
            Width = 140
            Height = 16
            Caption = 'Printing of tax forms:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Prn_NameH: TCheckBox
            Left = 17
            Top = 69
            Width = 208
            Height = 21
            Caption = 'Client Name on Headings'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Prn_SinH: TCheckBox
            Left = 17
            Top = 90
            Width = 157
            Height = 20
            Caption = 'SIN on Headings'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object Prn_DateH: TCheckBox
            Left = 17
            Top = 110
            Width = 157
            Height = 21
            Caption = 'Date on Headings'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object Prn_HideSin: TCheckBox
            Left = 13
            Top = 30
            Width = 312
            Height = 20
            Caption = 'Partially Hide Sensitive Info (SIN,REPID)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
        end
        object FullPrintPanel: TPanel
          Left = 336
          Top = 330
          Width = 337
          Height = 139
          BevelOuter = bvLowered
          TabOrder = 7
          object Label78: TLabel
            Left = 28
            Top = 16
            Width = 140
            Height = 16
            Caption = 'In Full return printing'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label104: TLabel
            Left = 9
            Top = 69
            Width = 303
            Height = 17
            Caption = 'The fast method assembles all print pages into'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label105: TLabel
            Left = 9
            Top = 86
            Width = 207
            Height = 17
            Caption = 'an un-interruptable print stream.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label106: TLabel
            Left = 9
            Top = 103
            Width = 234
            Height = 17
            Caption = '(recommended for network printers)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object UseFastPrint: TCheckBox
            Left = 26
            Top = 41
            Width = 234
            Height = 21
            Hint = 'Print Pages are assembled together'
            Caption = 'Use Fast Print method  '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object LetterMarginsPanel: TPanel
          Left = 43
          Top = 330
          Width = 286
          Height = 139
          BevelOuter = bvLowered
          TabOrder = 6
          object Label109: TLabel
            Left = 97
            Top = 7
            Width = 147
            Height = 16
            Caption = 'Client Letters Printing'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label110: TLabel
            Left = 18
            Top = 43
            Width = 135
            Height = 17
            Caption = 'Left margin in inches'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label111: TLabel
            Left = 18
            Top = 78
            Width = 145
            Height = 17
            Caption = 'Right margin in inches'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Prn_LMargin: TEdit
            Left = 181
            Top = 43
            Width = 53
            Height = 25
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Prn_RMargin: TEdit
            Left = 181
            Top = 78
            Width = 53
            Height = 24
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object FontPanel: TPanel
          Left = 43
          Top = 173
          Width = 286
          Height = 136
          BevelOuter = bvLowered
          TabOrder = 4
          object Label114: TLabel
            Left = 9
            Top = 26
            Width = 206
            Height = 18
            Caption = 'Printing Font Size Increment:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label115: TLabel
            Left = 10
            Top = 52
            Width = 192
            Height = 17
            Caption = 'The default size is Arial size 8'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label116: TLabel
            Left = 10
            Top = 78
            Width = 135
            Height = 17
            Caption = 'Increment by (0 or 1)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Prn_FontIncr: TEdit
            Left = 155
            Top = 78
            Width = 19
            Height = 24
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 1
            ParentFont = False
            TabOrder = 0
            OnChange = Prn_FontIncrChange
          end
        end
        object Panel3: TPanel
          Left = 43
          Top = 43
          Width = 630
          Height = 59
          BevelOuter = bvLowered
          TabOrder = 1
          object Label118: TLabel
            Left = 9
            Top = 9
            Width = 122
            Height = 18
            Caption = 'BarCode printing'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object NoBarCode: TCheckBox
            Left = 34
            Top = 34
            Width = 576
            Height = 21
            Caption = 
              'DO NOT Print BarCode in Client Copy (The CRA Filing Copy will al' +
              'ways print the BarCode)'
            TabOrder = 0
          end
        end
        object RetainDefaultPrinter: TCheckBox
          Left = 43
          Top = 112
          Width = 492
          Height = 21
          Caption = 'Retain default printer between successive print requests'
          TabOrder = 2
          Visible = False
        end
        object Prn_PIPEDAAll: TCheckBox
          Left = 76
          Top = 139
          Width = 485
          Height = 21
          Caption = 
            'Print the Privacy Letter (PIPEDA) not only in New but also in Ol' +
            'd returns'
          TabOrder = 3
        end
      end
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 0
    Width = 1106
    Height = 44
    Align = alTop
    Caption = 'Configuration Options'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -28
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object ExitBtn: TBitBtn
      Left = 805
      Top = 11
      Width = 122
      Height = 27
      Caption = ' Save / Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 2
      OnClick = ExitBtnClick
    end
    object BitBtn2: TBitBtn
      Left = 172
      Top = 9
      Width = 75
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = BitBtn2Click
    end
    object SaveBtn: TBitBtn
      Left = 700
      Top = 11
      Width = 87
      Height = 27
      Cancel = True
      Caption = 'Save'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
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
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = SaveBtnClick
    end
  end
  object ColorDialog1: TColorDialog
    Left = 720
    Top = 415
  end
end
