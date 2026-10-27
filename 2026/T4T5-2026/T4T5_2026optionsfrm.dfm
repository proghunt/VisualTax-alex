object OptionsFrmT4T5_2026: TOptionsFrmT4T5_2026
  Left = 255
  Top = 177
  Caption = 'OptionsFrmT4T5_2026'
  ClientHeight = 642
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label81: TLabel
    Left = 350
    Top = 231
    Width = 28
    Height = 15
    Caption = 'Area:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label85: TLabel
    Left = 322
    Top = 231
    Width = 19
    Height = 15
    Caption = 'Fax'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 36
    Width = 888
    Height = 606
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Preparer'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 880
        Height = 578
        Align = alClient
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Panel12: TPanel
          Left = 0
          Top = 0
          Width = 880
          Height = 25
          Align = alTop
          Caption = ' Preparer'
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object ScrollBox1: TScrollBox
          Left = 0
          Top = 25
          Width = 880
          Height = 553
          HorzScrollBar.Tracking = True
          VertScrollBar.Tracking = True
          Align = alClient
          TabOrder = 1
          object IdentPanel: TPanel
            Left = 17
            Top = -27
            Width = 603
            Height = 358
            BevelOuter = bvLowered
            BorderWidth = 1
            TabOrder = 0
            object Label1: TLabel
              Left = 109
              Top = 77
              Width = 32
              Height = 14
              Alignment = taRightJustify
              Caption = 'Street:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 120
              Top = 98
              Width = 21
              Height = 14
              Alignment = taRightJustify
              Caption = 'City:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 96
              Top = 119
              Width = 45
              Height = 14
              Alignment = taRightJustify
              Caption = 'Province:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label4: TLabel
              Left = 240
              Top = 119
              Width = 41
              Height = 14
              Alignment = taRightJustify
              Caption = 'Country:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 382
              Top = 119
              Width = 32
              Height = 14
              Alignment = taRightJustify
              Caption = 'Postal:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 98
              Top = 140
              Width = 42
              Height = 14
              Alignment = taRightJustify
              Caption = 'Tel Area:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 265
              Top = 140
              Width = 16
              Height = 14
              Alignment = taRightJustify
              Caption = 'Tel:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 260
              Top = 161
              Width = 21
              Height = 14
              Alignment = taRightJustify
              Caption = 'Fax:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label26: TLabel
              Left = 94
              Top = 161
              Width = 47
              Height = 14
              Alignment = taRightJustify
              Caption = 'Fax Area:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label14: TLabel
              Left = 63
              Top = 28
              Width = 78
              Height = 14
              Alignment = taRightJustify
              Caption = 'Company Name:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label40: TLabel
              Left = 7
              Top = 7
              Width = 127
              Height = 15
              Caption = 'Preparer Identification'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label88: TLabel
              Left = 70
              Top = 203
              Width = 71
              Height = 14
              Alignment = taRightJustify
              Caption = 'Email Address:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label108: TLabel
              Left = 77
              Top = 182
              Width = 64
              Height = 14
              Alignment = taRightJustify
              Caption = 'Business No:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label43: TLabel
              Left = 37
              Top = 252
              Width = 97
              Height = 14
              Alignment = taRightJustify
              Caption = 'Transmitter Account'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label45: TLabel
              Left = 44
              Top = 327
              Width = 81
              Height = 14
              Alignment = taRightJustify
              Caption = 'Transmitter type:'
              Enabled = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Visible = False
            end
            object Label58: TLabel
              Left = 71
              Top = 49
              Width = 70
              Height = 14
              Alignment = taRightJustify
              Caption = 'Contact Name:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label12: TLabel
              Left = 35
              Top = 231
              Width = 394
              Height = 15
              Caption = 
                'Electronic Filing Info  (required if you  Efile slips to CRA in ' +
                'XML format) '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label27: TLabel
              Left = 293
              Top = 252
              Width = 268
              Height = 14
              Caption = 'Enter a 15 character Business Number for Internet filing'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label31: TLabel
              Left = 174
              Top = 8
              Width = 182
              Height = 14
              Alignment = taRightJustify
              Caption = '(Complete ALL applicable boxes)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label34: TLabel
              Left = 80
              Top = 283
              Width = 48
              Height = 14
              Alignment = taRightJustify
              Caption = 'OR Rep Id'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label35: TLabel
              Left = 373
              Top = 345
              Width = 217
              Height = 14
              Caption = 'Discontinued beginning of 2025. Do not use it'
              Enabled = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Visible = False
            end
            object Label39: TLabel
              Left = 293
              Top = 282
              Width = 267
              Height = 14
              Caption = 'Enter a 7 character RepId if you plan to use MyAccount'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label54: TLabel
              Left = 401
              Top = 318
              Width = 64
              Height = 14
              Alignment = taRightJustify
              Caption = 'WAC number'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Visible = False
            end
            object Prp_Street: TEdit
              Left = 147
              Top = 70
              Width = 337
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
            end
            object Prp_City: TEdit
              Left = 147
              Top = 91
              Width = 337
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
              Text = ' '
            end
            object Prp_Prov: TComboBox
              Left = 147
              Top = 112
              Width = 43
              Height = 23
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 4
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
              Left = 287
              Top = 112
              Width = 85
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 5
              Text = ' '
            end
            object Prp_Postal: TEdit
              Left = 420
              Top = 112
              Width = 64
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 6
              Text = ' '
            end
            object Prp_Area: TEdit
              Left = 147
              Top = 140
              Width = 38
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 7
              Text = ' '
            end
            object Prp_Tel: TEdit
              Left = 287
              Top = 140
              Width = 85
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 8
            end
            object Prp_Fax: TEdit
              Left = 287
              Top = 161
              Width = 85
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 10
            end
            object Prp_FxArea: TEdit
              Left = 147
              Top = 161
              Width = 38
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 9
            end
            object Prp_Name: TEdit
              Left = 147
              Top = 28
              Width = 337
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              Text = 'Prp_Name'
            end
            object Prp_Email: TEdit
              Left = 147
              Top = 203
              Width = 337
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 12
              Text = ' '
            end
            object Prp_BusNo: TEdit
              Left = 147
              Top = 182
              Width = 134
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 15
              ParentFont = False
              TabOrder = 11
              Text = ' '
            end
            object PRP_TransmitterType: TComboBox
              Left = 147
              Top = 338
              Width = 212
              Height = 23
              Enabled = False
              TabOrder = 16
              Text = '2 Submitting on the behalf of others'
              Visible = False
            end
            object Prp_TransmitterNo: TEdit
              Left = 147
              Top = 252
              Width = 124
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 13
            end
            object Prp_ContactName: TEdit
              Left = 147
              Top = 49
              Width = 337
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object PRP_RepId: TEdit
              Left = 147
              Top = 278
              Width = 94
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 7
              ParentFont = False
              TabOrder = 15
            end
            object Prp_WacNo: TEdit
              Left = 483
              Top = 319
              Width = 124
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 7
              ParentFont = False
              TabOrder = 14
              Visible = False
            end
          end
          object LogoPanel: TPanel
            Left = 10
            Top = 461
            Width = 603
            Height = 71
            BevelOuter = bvLowered
            BorderWidth = 1
            TabOrder = 2
            object Label84: TLabel
              Left = 7
              Top = 7
              Width = 84
              Height = 15
              Caption = 'Company Logo'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object vtLabel1: TvtLabel
              Left = 7
              Top = 21
              Width = 545
              Height = 42
              Caption = 
                'If you have a company Logo (graphic), you can insert it into the' +
                ' Client Letters such the Covering Letter (CLetter), the Privacy ' +
                'Act Letter (PIPEDA) and the Engangement Letter (ENGAGE). See Con' +
                'figure | Client Letter Design after you finish this window)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              WordWrap = True
              vtBorderType = vtlblNoBorder
            end
          end
          object ReviewerPanel: TPanel
            Left = 10
            Top = 377
            Width = 603
            Height = 78
            BevelOuter = bvLowered
            BorderWidth = 1
            TabOrder = 1
            object Label51: TLabel
              Left = 14
              Top = 7
              Width = 338
              Height = 15
              Caption = 'Reviewer Identification (i.e. Supervisor or other Tax Advisor)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label60: TLabel
              Left = 21
              Top = 28
              Width = 37
              Height = 15
              Caption = 'Name:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label89: TLabel
              Left = 21
              Top = 56
              Width = 83
              Height = 15
              Caption = 'Email Address:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label90: TLabel
              Left = 469
              Top = 7
              Width = 25
              Height = 15
              Caption = 'Area'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label92: TLabel
              Left = 434
              Top = 28
              Width = 19
              Height = 15
              Caption = 'Tel:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label95: TLabel
              Left = 518
              Top = 7
              Width = 45
              Height = 15
              Caption = 'Number'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Reviewer_Name: TEdit
              Left = 112
              Top = 28
              Width = 274
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
            object Reviewer_EMail: TEdit
              Left = 112
              Top = 49
              Width = 274
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 1
              Text = ' '
            end
            object Reviewer_Area: TEdit
              Left = 462
              Top = 23
              Width = 38
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 2
              Text = ' '
            end
            object Reviewer_Tel: TEdit
              Left = 504
              Top = 23
              Width = 85
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 3
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Billing/Invoice'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 880
        Height = 578
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object FooterPanel: TPanel
          Left = 21
          Top = 280
          Width = 561
          Height = 148
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 1
          object Label22: TLabel
            Left = 14
            Top = 7
            Width = 350
            Height = 15
            Caption = 'Invoice footer (Free format text to appear at bottom of Invoice)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object InvFoot1: TEdit
            Left = 7
            Top = 28
            Width = 545
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 0
          end
          object InvFoot2: TEdit
            Left = 7
            Top = 49
            Width = 545
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 1
          end
          object InvFoot3: TEdit
            Left = 7
            Top = 70
            Width = 545
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 2
          end
          object InvFoot4: TEdit
            Left = 7
            Top = 91
            Width = 545
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 3
          end
          object InvFoot5: TEdit
            Left = 7
            Top = 112
            Width = 545
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            MaxLength = 100
            ParentFont = False
            TabOrder = 4
          end
        end
        object GstPanel: TPanel
          Left = 21
          Top = 35
          Width = 561
          Height = 232
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 0
          object Label10: TLabel
            Left = 91
            Top = 7
            Width = 40
            Height = 14
            Caption = 'GST No:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label29: TLabel
            Left = 217
            Top = 7
            Width = 69
            Height = 14
            Caption = 'GST/HST rate:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label30: TLabel
            Left = 336
            Top = 14
            Width = 10
            Height = 14
            Caption = '%'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label13: TLabel
            Left = 14
            Top = 7
            Width = 47
            Height = 15
            Caption = 'GST info'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label25: TLabel
            Left = 14
            Top = 42
            Width = 111
            Height = 13
            Caption = 'Charge per hour ($)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Ms Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label24: TLabel
            Left = 14
            Top = 98
            Width = 117
            Height = 15
            Caption = 'Default Billing Option'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object vtShape1: TvtShape
            Left = 273
            Top = 112
            Width = 15
            Height = 15
            Brush.Color = clBlack
            GradientColor = clBlack
            Shape = vtTriangleRight
            FillDirection = vtUpFill
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
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
          object Label17: TLabel
            Left = 14
            Top = 168
            Width = 71
            Height = 15
            Caption = 'Flat Fees ($):'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label18: TLabel
            Left = 105
            Top = 168
            Width = 50
            Height = 13
            Caption = 'Very small '
          end
          object Label19: TLabel
            Left = 294
            Top = 168
            Width = 40
            Height = 13
            Caption = 'Average'
          end
          object Label20: TLabel
            Left = 112
            Top = 203
            Width = 40
            Height = 13
            Caption = 'Complex'
          end
          object Label21: TLabel
            Left = 217
            Top = 168
            Width = 28
            Height = 13
            Caption = 'Small '
          end
          object Label23: TLabel
            Left = 273
            Top = 203
            Width = 64
            Height = 13
            Caption = 'Very Complex'
          end
          object Prp_GstNo: TEdit
            Left = 140
            Top = 7
            Width = 66
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Opr_GstHst: TEdit
            Left = 287
            Top = 7
            Width = 43
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object Prp_Hour: TEdit
            Left = 140
            Top = 42
            Width = 45
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Text = ' '
          end
          object ListBox1: TListBox
            Left = 140
            Top = 77
            Width = 122
            Height = 70
            Hint = 'Select by clicking '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 15
            Items.Strings = (
              '0. Manual Charge'
              '1. Fee per Form*'
              '2. Time Billing'
              '3. Flat fee')
            ParentFont = False
            TabOrder = 3
            OnClick = ListBox1Click
          end
          object Prp_Bill: TEdit
            Left = 294
            Top = 105
            Width = 24
            Height = 21
            TabStop = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 4
            Text = ' '
          end
          object FeesBtn: TBitBtn
            Left = 336
            Top = 105
            Width = 162
            Height = 25
            Hint = 'Set up the Form Fee Schedule'
            Caption = '*   Form Fee Schedule...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = FeesBtnClick
          end
          object Prp_VSFee: TEdit
            Left = 161
            Top = 168
            Width = 38
            Height = 20
            BorderStyle = bsNone
            TabOrder = 6
            Text = ' '
          end
          object Prp_SFee: TEdit
            Left = 252
            Top = 168
            Width = 38
            Height = 20
            BorderStyle = bsNone
            TabOrder = 7
            Text = ' '
          end
          object Prp_AFee: TEdit
            Left = 343
            Top = 168
            Width = 38
            Height = 20
            BorderStyle = bsNone
            TabOrder = 8
            Text = ' '
          end
          object Prp_CFee: TEdit
            Left = 161
            Top = 196
            Width = 38
            Height = 20
            BorderStyle = bsNone
            TabOrder = 9
            Text = ' '
          end
          object Prp_VCFee: TEdit
            Left = 343
            Top = 196
            Width = 38
            Height = 20
            BorderStyle = bsNone
            TabOrder = 10
            Text = ' '
          end
        end
        object Panel13: TPanel
          Left = 0
          Top = 0
          Width = 876
          Height = 25
          Align = alTop
          Caption = ' Billing and Invoice'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Data Directories'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 0
        Width = 880
        Height = 578
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Label46: TLabel
          Left = 8
          Top = 61
          Width = 92
          Height = 15
          Caption = 'Current Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label47: TLabel
          Left = 8
          Top = 100
          Width = 90
          Height = 15
          Caption = 'Default Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label49: TLabel
          Left = 147
          Top = 77
          Width = 133
          Height = 14
          Caption = '(To be used in this session)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label50: TLabel
          Left = 147
          Top = 119
          Width = 268
          Height = 14
          Caption = '(To be used at start-up time. Normally same as current) '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label52: TLabel
          Left = 5
          Top = 257
          Width = 317
          Height = 16
          Caption = 'Last year'#39's data (For ROLL-OVER purposes) *'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label53: TLabel
          Left = 8
          Top = 30
          Width = 251
          Height = 16
          Caption = 'Required VisualTax data directories'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label96: TLabel
          Left = 7
          Top = 147
          Width = 182
          Height = 15
          Caption = 'Remind me to backup data every '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label98: TLabel
          Left = 232
          Top = 149
          Width = 26
          Height = 15
          Caption = 'days'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label97: TLabel
          Left = 8
          Top = 226
          Width = 143
          Height = 15
          Caption = 'Most recent back up folder'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label99: TLabel
          Left = 5
          Top = 131
          Width = 74
          Height = 13
          Caption = 'Data backup'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label100: TLabel
          Left = 7
          Top = 175
          Width = 132
          Height = 15
          Caption = 'Default Backup directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label101: TLabel
          Left = 182
          Top = 196
          Width = 334
          Height = 14
          Caption = 
            '(The actual backup will be below the above dir as Backup01, 02, ' +
            'etc)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label102: TLabel
          Left = 203
          Top = 210
          Width = 286
          Height = 14
          Caption = '(A CD drive directory is recommended for multiple backups)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label103: TLabel
          Left = 8
          Top = 334
          Width = 142
          Height = 15
          Caption = 'for ROLL-OVER purposes'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label121: TLabel
          Left = 7
          Top = 279
          Width = 171
          Height = 15
          Caption = 'Program name used last year...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label122: TLabel
          Left = 7
          Top = 314
          Width = 110
          Height = 15
          Caption = 'Last year'#39's Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label145: TLabel
          Left = 8
          Top = 425
          Width = 533
          Height = 36
          AutoSize = False
          Caption = 
            'Data directory of the TForce-2016 production data prior to Multi' +
            '-App. Typically enter  C:\T4-2016\data. To be used as the source' +
            ' to import data into the Multi-App version'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Visible = False
          WordWrap = True
        end
        object Label138: TLabel
          Left = 8
          Top = 374
          Width = 126
          Height = 15
          Caption = 'PROGRAM dir last year'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object SelectCurBtn: TBitBtn
          Left = 546
          Top = 61
          Width = 64
          Height = 16
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = SelectCurBtnClick
        end
        object SelectDefBtn: TBitBtn
          Left = 546
          Top = 100
          Width = 64
          Height = 16
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = SelectDefBtnClick
        end
        object SelectL1Btn: TBitBtn
          Left = 546
          Top = 328
          Width = 64
          Height = 21
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = SelectL1BtnClick
        end
        object Dir_Cur: TEdit
          Left = 145
          Top = 56
          Width = 395
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object Dir_Deflt: TEdit
          Left = 145
          Top = 98
          Width = 395
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object Dir_LastYr: TEdit
          Left = 175
          Top = 330
          Width = 365
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object Panel17: TPanel
          Left = 616
          Top = 50
          Width = 204
          Height = 113
          Color = 15461355
          TabOrder = 9
          object Label36: TLabel
            Left = 3
            Top = 3
            Width = 117
            Height = 13
            Caption = 'Hard Disk examples:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Ms Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label42: TLabel
            Left = 7
            Top = 28
            Width = 121
            Height = 13
            Caption = 'C:\VT\T4T5-2023\DATA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label44: TLabel
            Left = 7
            Top = 56
            Width = 75
            Height = 13
            Caption = 'G:\xxxxx\DATA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 876
          Height = 25
          Align = alTop
          Caption = ' Data Directories'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
        end
        object CreateNewDirBtn: TBitBtn
          Left = 546
          Top = 47
          Width = 64
          Height = 16
          Hint = 'Click if directory already exists'
          Caption = 'New folder...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 11
          OnClick = CreateNewDirBtnClick
        end
        object BackupFrequency: TEdit
          Left = 201
          Top = 147
          Width = 24
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object LastBackupDir: TEdit
          Left = 166
          Top = 224
          Width = 374
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 7
        end
        object BackupDir: TEdit
          Left = 145
          Top = 175
          Width = 395
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object SelectBackupDirBtn: TBitBtn
          Left = 546
          Top = 177
          Width = 64
          Height = 16
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 12
          OnClick = SelectBackupDirBtnClick
        end
        object RolloverProgram: TComboBox
          Left = 245
          Top = 280
          Width = 134
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
          Text = 'VisualTax'
          Items.Strings = (
            'VisualTax'
            'Taxcycle')
        end
        object Dir_DBFData: TEdit
          Left = 175
          Top = 454
          Width = 366
          Height = 21
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
          Visible = False
        end
        object SelectDBFBtn: TBitBtn
          Left = 547
          Top = 456
          Width = 71
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
          TabOrder = 15
          Visible = False
          OnClick = SelectDBFBtnClick
        end
        object Dir_PgmLastYr: TEdit
          Left = 175
          Top = 371
          Width = 365
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 16
        end
        object SelectLYPrgmDir: TBitBtn
          Left = 546
          Top = 372
          Width = 64
          Height = 21
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 17
          OnClick = SelectLYPrgmDirClick
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Display'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox4: TScrollBox
        Left = 0
        Top = 0
        Width = 880
        Height = 578
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Panel19: TPanel
          Left = 0
          Top = 0
          Width = 876
          Height = 25
          Align = alTop
          Caption = ' Display'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object Panel25: TPanel
          Left = 28
          Top = 35
          Width = 491
          Height = 421
          BevelOuter = bvLowered
          TabOrder = 1
          object Label41: TLabel
            Left = 14
            Top = 70
            Width = 188
            Height = 13
            Caption = 'Color on entry to a field of a form'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object vtLabel2: TvtLabel
            Left = 189
            Top = 98
            Width = 125
            Height = 14
            Caption = 'Linked field color is set to:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
            vtBorderType = vtlblNoBorder
          end
          object vtLabel3: TvtLabel
            Left = 168
            Top = 119
            Width = 147
            Height = 14
            Caption = 'Calculated  field color is set to:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
            vtBorderType = vtlblNoBorder
          end
          object Label76: TLabel
            Left = 14
            Top = 154
            Width = 100
            Height = 13
            Caption = 'Form data display'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label75: TLabel
            Left = 14
            Top = 189
            Width = 148
            Height = 13
            Caption = 'Form Size (zoom) in effect'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label57: TLabel
            Left = 280
            Top = 186
            Width = 3
            Height = 16
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label73: TLabel
            Left = 224
            Top = 186
            Width = 12
            Height = 16
            Caption = '%'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label74: TLabel
            Left = 238
            Top = 188
            Width = 226
            Height = 14
            Caption = '(automatically set by the +- zoom of main form)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label117: TLabel
            Left = 14
            Top = 224
            Width = 116
            Height = 14
            Caption = 'Most Recent Returns'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label38: TLabel
            Left = 14
            Top = 315
            Width = 141
            Height = 13
            Caption = 'Navigation and warnings'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Visible = False
          end
          object Label62: TLabel
            Left = 259
            Top = 315
            Width = 189
            Height = 14
            Caption = '(If Checked, ESC goes to TaxSummary)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Visible = False
          end
          object Label9: TLabel
            Left = 14
            Top = 266
            Width = 141
            Height = 14
            Caption = 'Set the display resolution'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label37: TLabel
            Left = 21
            Top = 294
            Width = 422
            Height = 13
            Caption = 
              'Changing the display resolution will affect all other programs (' +
              'as if using the Control Panel) '
          end
          object UseDefaultBoxColor: TBitBtn
            Left = 210
            Top = 63
            Width = 106
            Height = 29
            Caption = 'Change color...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = UseDefaultBoxColorClick
          end
          object LinkedBoxColor: TEdit
            Left = 329
            Top = 98
            Width = 85
            Height = 20
            TabStop = False
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            Text = 'LinkedBoxColor'
          end
          object ProtectedBoxColor: TEdit
            Left = 329
            Top = 119
            Width = 85
            Height = 20
            TabStop = False
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 2
            Text = 'ProtectedBoxColor'
          end
          object ActiveBoxColor: TEdit
            Left = 329
            Top = 69
            Width = 85
            Height = 20
            TabStop = False
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 3
            Text = 'ActiveBoxColor'
          end
          object DataInBold: TCheckBox
            Left = 175
            Top = 154
            Width = 169
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Show data in Bold in all forms'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
          object FormZoom: TEdit
            Left = 182
            Top = 185
            Width = 36
            Height = 24
            Hint = 'It can be set also via the Zoom in main menu'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 5
          end
          object HideMostRecent: TCheckBox
            Left = 182
            Top = 224
            Width = 141
            Height = 17
            Caption = 'Hide most recent returns'
            TabOrder = 6
          end
          object Opr_Close: TCheckBox
            Left = 182
            Top = 315
            Width = 71
            Height = 17
            Hint = 'Otherwise Esc goes to the previous form'
            Caption = 'Esc key'
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 7
            Visible = False
          end
          object SetDisplayBtn: TBitBtn
            Left = 175
            Top = 263
            Width = 134
            Height = 25
            Caption = 'Set Display Resolution...'
            Enabled = False
            TabOrder = 8
          end
          object ShowUsedForms: TCheckBox
            Left = 14
            Top = 14
            Width = 232
            Height = 17
            Caption = 'Show forms used last time you saved '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 9
          end
          object OpenAtLastForm: TCheckBox
            Left = 35
            Top = 28
            Width = 204
            Height = 17
            Caption = 'If ticked, open at last form used'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 10
          end
        end
        object GroupBox2: TGroupBox
          Left = 529
          Top = 101
          Width = 169
          Height = 91
          Caption = 'Active tab color'
          TabOrder = 2
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
        object GroupBox1: TGroupBox
          Left = 529
          Top = 31
          Width = 169
          Height = 65
          Caption = 'Preferred Interface'
          TabOrder = 3
          object Skin: TComboBox
            Left = 16
            Top = 24
            Width = 137
            Height = 21
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
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Defaults/Tax returns'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox5: TScrollBox
        Left = 0
        Top = 0
        Width = 880
        Height = 578
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object DefaultsPanel: TGroupBox
          Left = 14
          Top = 35
          Width = 617
          Height = 400
          Caption = 'Default values for tax returns'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object Label28: TLabel
            Left = 16
            Top = 238
            Width = 378
            Height = 14
            Caption = 
              'Disclaimer above signature on Page 4 (Leave it blank, if not req' +
              'uired)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label15: TLabel
            Left = 15
            Top = 45
            Width = 64
            Height = 15
            Caption = 'Default City'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label16: TLabel
            Left = 15
            Top = 21
            Width = 96
            Height = 15
            Caption = 'Default Province:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Prp_Dates: TCheckBox
            Left = 14
            Top = 126
            Width = 533
            Height = 17
            Caption = 
              'Signature date: If checked, the program will automatically fill ' +
              'Signature dates with today'#39's date'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object ShowInvoiceWarning: TCheckBox
            Left = 14
            Top = 154
            Width = 421
            Height = 17
            Caption = 'Invoice: Show warning  if invoice not prepared'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
          end
          object Prn_Disclm: TEdit
            Left = 14
            Top = 259
            Width = 456
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            Text = 'Prn_Disclm'
          end
          object Nfl_Prov: TComboBox
            Left = 126
            Top = 14
            Width = 92
            Height = 23
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
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
            Left = 124
            Top = 42
            Width = 213
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object NoTypeAhead: TCheckBox
            Left = 21
            Top = 294
            Width = 330
            Height = 17
            Caption = 'DO NOT Use the Predictive Typing feature (Super Entry)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            Visible = False
          end
          object UseProperName: TCheckBox
            Left = 14
            Top = 182
            Width = 519
            Height = 17
            Caption = 
              'Client Letters: Show proper format (Capitalize only first letter' +
              ')  in Name and Address '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 6
          end
          object Capitalization: TRadioGroup
            Left = 14
            Top = 70
            Width = 281
            Height = 36
            Caption = 'Name/address: Convert to: '
            Columns = 2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            Items.Strings = (
              'UpperCase'
              'ProperCase')
            ParentFont = False
            TabOrder = 7
          end
        end
        object Panel21: TPanel
          Left = 0
          Top = 0
          Width = 876
          Height = 25
          Align = alTop
          Caption = ' Defaults Settings'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'Internet Updates'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox6: TScrollBox
        Left = 0
        Top = 0
        Width = 880
        Height = 578
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Label67: TLabel
          Left = 89
          Top = 48
          Width = 149
          Height = 16
          Caption = 'Check automaticaly every'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label68: TLabel
          Left = 169
          Top = 88
          Width = 28
          Height = 16
          Caption = 'days'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label69: TLabel
          Left = 77
          Top = 120
          Width = 179
          Height = 96
          Caption = 
            'If you set the frequency to 0, the program will never check the ' +
            'Internet automatically. You will need to initiate the internet c' +
            'heck manually via the Help | Check Update via the Web'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsItalic]
          ParentFont = False
          WordWrap = True
        end
        object UpdateFrequency: TEdit
          Left = 129
          Top = 80
          Width = 33
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = '7'
        end
        object Panel14: TPanel
          Left = 316
          Top = 49
          Width = 321
          Height = 274
          BevelWidth = 2
          Color = 15461355
          TabOrder = 1
          object Label61: TLabel
            Left = 16
            Top = 24
            Width = 289
            Height = 64
            Caption = 
              'The program will follow this schedule to automatically check the' +
              ' VisualTax web site for any updates available. If an update is a' +
              'vailable it will prompt you to download and install the update.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
          end
          object Label64: TLabel
            Left = 11
            Top = 104
            Width = 294
            Height = 64
            Caption = 
              'The program keeps track of the last time you checked the Interne' +
              't for any program update. Based on this schedule, it will initia' +
              'te automatically the Internet check at program start up time.'
            Color = 15461355
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentColor = False
            ParentFont = False
            WordWrap = True
          end
          object Label65: TLabel
            Left = 11
            Top = 168
            Width = 289
            Height = 48
            Caption = 
              'i.e: If you set the frequency to 1 (once a day), the first time ' +
              'in the day you start the program the Internet will be checked au' +
              'tomatically.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
          end
          object Label66: TLabel
            Left = 120
            Top = 8
            Width = 35
            Height = 16
            Caption = 'Notes'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label72: TLabel
            Left = 47
            Top = 230
            Width = 213
            Height = 32
            Caption = 'Note: The automatic Internet update does not work on Windows 98'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
          end
        end
        object Panel26: TPanel
          Left = 0
          Top = 0
          Width = 876
          Height = 25
          Align = alTop
          Caption = ' Internet Updates'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Security/Password'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox8: TScrollBox
        Left = 0
        Top = 0
        Width = 880
        Height = 578
        Align = alClient
        TabOrder = 0
        object LoginPanel: TPanel
          Left = 21
          Top = 49
          Width = 526
          Height = 64
          BevelOuter = bvLowered
          TabOrder = 0
          object Label48: TLabel
            Left = 14
            Top = 7
            Width = 276
            Height = 13
            Caption = 'Login Id (If you are the only user of the program)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label55: TLabel
            Left = 42
            Top = 35
            Width = 60
            Height = 13
            Caption = 'Log in Name'
          end
          object SingleLoginId: TEdit
            Left = 105
            Top = 28
            Width = 121
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object SkipLogin: TCheckBox
            Left = 252
            Top = 35
            Width = 141
            Height = 17
            Caption = 'Skip the Login window'
            TabOrder = 1
          end
        end
        object PswPanel: TPanel
          Left = 21
          Top = 126
          Width = 526
          Height = 64
          BevelOuter = bvLowered
          TabOrder = 1
          object Label56: TLabel
            Left = 10
            Top = 7
            Width = 104
            Height = 13
            Caption = 'Program password'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object SetPgmPswBtn: TBitBtn
            Left = 14
            Top = 28
            Width = 155
            Height = 25
            Caption = 'Set Program Password...'
            TabOrder = 0
            OnClick = SetPgmPswBtnClick
          end
          object RemovePgmPswBtn: TBitBtn
            Left = 196
            Top = 28
            Width = 155
            Height = 25
            Caption = 'Remove Program Password'
            TabOrder = 1
            OnClick = RemovePgmPswBtnClick
          end
        end
        object Panel27: TPanel
          Left = 0
          Top = 0
          Width = 876
          Height = 25
          Align = alTop
          Caption = ' Security/Password'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Printing'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox9: TScrollBox
        Left = 0
        Top = 0
        Width = 880
        Height = 578
        Align = alClient
        TabOrder = 0
        object Panel29: TPanel
          Left = 0
          Top = 0
          Width = 876
          Height = 25
          Align = alTop
          Caption = ' Printing'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object HeadersPanel: TPanel
          Left = 21
          Top = 112
          Width = 519
          Height = 71
          BevelOuter = bvLowered
          TabOrder = 1
          object Label59: TLabel
            Left = 9
            Top = 20
            Width = 149
            Height = 13
            Caption = 'Print headers on tax forms'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Prn_NameH: TCheckBox
            Left = 14
            Top = 42
            Width = 169
            Height = 17
            Caption = 'Client Name on Headings'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Prn_SinH: TCheckBox
            Left = 196
            Top = 42
            Width = 127
            Height = 17
            Caption = 'B/N on Headings'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object Prn_DateH: TCheckBox
            Left = 329
            Top = 42
            Width = 127
            Height = 17
            Caption = 'Date on Headings'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
        end
        object FullPrintPanel: TPanel
          Left = 21
          Top = 266
          Width = 519
          Height = 127
          BevelOuter = bvLowered
          TabOrder = 3
          object Label78: TLabel
            Left = 9
            Top = 13
            Width = 104
            Height = 13
            Caption = 'Full return printing'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label104: TLabel
            Left = 203
            Top = 35
            Width = 259
            Height = 15
            Caption = 'The fast method assembles all print pages into'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label105: TLabel
            Left = 203
            Top = 49
            Width = 176
            Height = 15
            Caption = 'an un-interruptable print stream.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label106: TLabel
            Left = 203
            Top = 63
            Width = 197
            Height = 15
            Caption = '(recommended for network printers)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label11: TLabel
            Left = 203
            Top = 84
            Width = 280
            Height = 15
            Caption = 'It will not be applied if return has data in  landscape'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label32: TLabel
            Left = 205
            Top = 98
            Width = 32
            Height = 15
            Caption = 'forms'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object UseFastPrint: TCheckBox
            Left = 14
            Top = 33
            Width = 162
            Height = 17
            Hint = 'Print Pages are assembled together'
            Caption = 'Use Fast Print method  '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object LetterMarginsPanel: TPanel
          Left = 21
          Top = 196
          Width = 519
          Height = 64
          BevelOuter = bvLowered
          TabOrder = 2
          object Label109: TLabel
            Left = 9
            Top = 13
            Width = 154
            Height = 13
            Caption = 'Client Letters Print Margins'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label110: TLabel
            Left = 15
            Top = 35
            Width = 115
            Height = 15
            Caption = 'Left margin in inches'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label111: TLabel
            Left = 218
            Top = 35
            Width = 124
            Height = 15
            Caption = 'Right margin in inches'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Prn_LMargin: TEdit
            Left = 147
            Top = 35
            Width = 43
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Prn_RMargin: TEdit
            Left = 350
            Top = 35
            Width = 43
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
        end
        object FontPanel: TPanel
          Left = 21
          Top = 35
          Width = 519
          Height = 71
          BevelOuter = bvLowered
          TabOrder = 0
          object Label114: TLabel
            Left = 7
            Top = 21
            Width = 159
            Height = 14
            Caption = 'Printing Font Size Increment:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label115: TLabel
            Left = 8
            Top = 42
            Width = 160
            Height = 15
            Caption = 'The default size is Arial size 8'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label116: TLabel
            Left = 190
            Top = 42
            Width = 112
            Height = 15
            Caption = 'Increment by (0 or 1)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Prn_FontIncr: TEdit
            Left = 308
            Top = 42
            Width = 15
            Height = 20
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            MaxLength = 1
            ParentFont = False
            TabOrder = 0
            OnChange = Prn_FontIncrChange
          end
        end
        object Panel3: TPanel
          Left = 21
          Top = 406
          Width = 519
          Height = 64
          BevelOuter = bvLowered
          TabOrder = 5
          Visible = False
          object Label118: TLabel
            Left = 7
            Top = 7
            Width = 93
            Height = 14
            Caption = 'BarCode printing'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label33: TLabel
            Left = 119
            Top = 7
            Width = 359
            Height = 15
            Caption = 
              'CRA will introduce it towards the end of 2006 (Not applicable no' +
              'w)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object NoBarCode: TCheckBox
            Left = 28
            Top = 28
            Width = 400
            Height = 22
            Caption = 'DO NOT Print BarCode. '
            Checked = True
            Enabled = False
            State = cbChecked
            TabOrder = 0
          end
        end
      end
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 0
    Width = 888
    Height = 36
    Align = alTop
    Alignment = taLeftJustify
    Caption = '   Configuration Options'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object ExitBtn: TBitBtn
      Left = 553
      Top = 7
      Width = 99
      Height = 22
      Caption = ' Save / Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = ExitBtnClick
    end
    object BitBtn2: TBitBtn
      Left = 364
      Top = 7
      Width = 61
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Kind = bkHelp
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object SaveBtn: TBitBtn
      Left = 441
      Top = 7
      Width = 92
      Height = 22
      Cancel = True
      Caption = 'Save'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
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
      TabOrder = 2
      OnClick = SaveBtnClick
    end
  end
  object ColorDialog1: TColorDialog
    Left = 671
    Top = 363
  end
end
