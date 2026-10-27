object OptionsFrmT2_2027: TOptionsFrmT2_2027
  Left = 265
  Top = 178
  Caption = 'OptionsFrmT2_2027'
  ClientHeight = 714
  ClientWidth = 915
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
    Width = 915
    Height = 678
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Preparer'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 907
        Height = 650
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
          Width = 907
          Height = 25
          Align = alTop
          Caption = ' Preparer'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object ScrollBox1: TScrollBox
          Left = 0
          Top = 25
          Width = 907
          Height = 625
          HorzScrollBar.Tracking = True
          VertScrollBar.Tracking = True
          Align = alClient
          TabOrder = 1
          object IdentPanel: TPanel
            Left = 7
            Top = 7
            Width = 603
            Height = 309
            BevelOuter = bvLowered
            BorderWidth = 1
            TabOrder = 0
            object Label1: TLabel
              Left = 38
              Top = 49
              Width = 84
              Height = 15
              Caption = 'Address:Street:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 98
              Top = 77
              Width = 23
              Height = 15
              Caption = 'City:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 41
              Top = 98
              Width = 81
              Height = 15
              Caption = 'Province/State:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label4: TLabel
              Left = 236
              Top = 98
              Width = 45
              Height = 15
              Caption = 'Country:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 432
              Top = 98
              Width = 38
              Height = 15
              Caption = 'Postal:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 40
              Top = 119
              Width = 79
              Height = 15
              Caption = 'Tel. Area code:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 181
              Top = 119
              Width = 38
              Height = 15
              Caption = 'Tel No.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 181
              Top = 140
              Width = 38
              Height = 15
              Caption = 'Fax No'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label26: TLabel
              Left = 40
              Top = 140
              Width = 79
              Height = 15
              Caption = 'Fax Area code:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label14: TLabel
              Left = 28
              Top = 28
              Width = 93
              Height = 15
              Caption = 'Company Name:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label40: TLabel
              Left = 14
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
              Left = 35
              Top = 189
              Width = 80
              Height = 15
              Caption = 'Email Address'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label108: TLabel
              Left = 42
              Top = 168
              Width = 75
              Height = 15
              Caption = 'Business No:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label54: TLabel
              Left = 7
              Top = 238
              Width = 109
              Height = 15
              Caption = 'Contact: First Name'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Lbl1: TLabel
              Left = 21
              Top = 280
              Width = 93
              Height = 15
              Caption = 'RepId (for RC59)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label86: TLabel
              Left = 252
              Top = 238
              Width = 61
              Height = 15
              Caption = 'Last Name'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label87: TLabel
              Left = 21
              Top = 259
              Width = 93
              Height = 15
              Caption = 'Contact: Position'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label91: TLabel
              Left = 42
              Top = 210
              Width = 69
              Height = 15
              Caption = 'Organization'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label12: TLabel
              Left = 157
              Top = 7
              Width = 377
              Height = 15
              Caption = 
                'ALL fields up to and including Contact Position MUST be complete' +
                'd'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Prp_Street: TEdit
              Left = 133
              Top = 49
              Width = 402
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 35
              ParentFont = False
              TabOrder = 1
            end
            object Prp_City: TEdit
              Left = 133
              Top = 70
              Width = 402
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 35
              ParentFont = False
              TabOrder = 2
              Text = ' '
            end
            object Prp_Prov: TComboBox
              Left = 133
              Top = 91
              Width = 95
              Height = 23
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 2
              ParentFont = False
              TabOrder = 3
              Text = 'Prp_Prov'
              Items.Strings = (
                'AB  Alberta'
                'BC  British Columbia'
                'MB  Manitoba'
                'NS  Nova Scotia'
                'NB  New Brunswick'
                'NL  Newfoundland'
                'NT  Northest Teritorries'
                'NU  Nunavut'
                'ON  Ontario'
                'PE  Prince Edward Island'
                'QC  Quebec'
                'SK  Saskatchewan'
                'YT  Yukon Teritory'
                ''
                'AK  Alaska'
                'AL  Alabama'
                'AR  Arkansas'
                'AS  American Samoa'
                'AZ  Arizona'
                'CA  California'
                'CO  Colorado'
                'CT  Connecticut'
                'DC  District of Columbia'
                'DE  Delaware'
                'FL  Florida'
                'FM  Federated Micronesia'
                'GA  Georgia'
                'GU  Guam'
                'HI  Hawaii'
                'IA  Iowa'
                'ID  Idaho'
                'IL  Illinois'
                'IN  Indiana'
                'KS  Kansas'
                'KY  Kentucky'
                'LA  Louisiana'
                'MA  Massachusetts'
                'MD  Maryland'
                'ME  Maine'
                'MH  Marshall Islands'
                'MI  Michigan'
                'MN  Minnesota'
                'MO  Missouri'
                'MP  North Mariana Island'
                'MS  Mississippi'
                'MT  Montana'
                'NC  North Carolina'
                'ND  North Dakota'
                'NE  Nebraska'
                'NH  New Hampshire'
                'NJ  New Jersey'
                'NM  New Mexico'
                'NV  Nevada'
                'NY  New York'
                'OH  Ohio'
                'OK  Oklahoma'
                'OR  Oregon'
                'PA  Pennsylvania'
                'PR  Puerto Rico'
                'PW  Palau'
                'RI  Rhode Island'
                'SC  South Carolina'
                'SD  South Dakota'
                'TN  Tennessee'
                'TX  Texas'
                'UT  Utah'
                'VA  Virginia'
                'VI  Virgin Islands'
                'VT  Vermont'
                'WA  Washington'
                'WI  Wisconsin'
                'WV  West Virginia'
                'WY  Wyoming')
            end
            object Prp_Postal: TEdit
              Left = 472
              Top = 91
              Width = 63
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
            object Prp_Area: TEdit
              Left = 133
              Top = 119
              Width = 38
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 3
              ParentFont = False
              TabOrder = 6
              Text = ' '
            end
            object Prp_Tel: TEdit
              Left = 233
              Top = 119
              Width = 86
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 12
              ParentFont = False
              TabOrder = 7
            end
            object Prp_Fax: TEdit
              Left = 233
              Top = 140
              Width = 86
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 12
              ParentFont = False
              TabOrder = 9
            end
            object Prp_FxArea: TEdit
              Left = 133
              Top = 140
              Width = 38
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 3
              ParentFont = False
              TabOrder = 8
            end
            object Prp_Name: TEdit
              Left = 133
              Top = 28
              Width = 402
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 70
              ParentFont = False
              TabOrder = 0
              Text = 'Prp_Name'
            end
            object Prp_Email: TEdit
              Left = 133
              Top = 182
              Width = 379
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 50
              ParentFont = False
              TabOrder = 11
              Text = ' '
            end
            object Prp_BusNo: TEdit
              Left = 133
              Top = 161
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
              TabOrder = 10
              Text = ' '
              OnExit = Prp_BusNoExit
            end
            object Prp_ContactFn: TEdit
              Left = 133
              Top = 238
              Width = 113
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 35
              ParentFont = False
              TabOrder = 13
              Text = 'Prp_ContactFn'
            end
            object Prp_RepId: TEdit
              Left = 133
              Top = 280
              Width = 379
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              TabOrder = 16
              Text = 'Prp_RepId'
            end
            object Prp_ContactLn: TEdit
              Left = 322
              Top = 238
              Width = 190
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 35
              ParentFont = False
              TabOrder = 14
              Text = 'Prp_ContactLn'
            end
            object Prp_ContactPos: TEdit
              Left = 133
              Top = 259
              Width = 190
              Height = 20
              BorderStyle = bsNone
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 40
              ParentFont = False
              TabOrder = 15
              Text = 'Prp_ContactPos'
            end
            object Prp_OrgType: TComboBox
              Left = 133
              Top = 203
              Width = 145
              Height = 23
              TabOrder = 12
              Text = 'Prp_OrgType'
              Items.Strings = (
                '1  CORPORATION'
                '2  PARTNERSHIP'
                '3  INDIVIDUAL')
            end
            object Prp_Countr: TComboBox
              Left = 281
              Top = 91
              Width = 146
              Height = 23
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              MaxLength = 2
              ParentFont = False
              TabOrder = 4
              Text = 'Prp_Prov'
              Items.Strings = (
                'CA Canada'
                'AD Andorra'
                'AE United Arab Emirates'
                'AF Afghanistan'
                'AG Antigua And Barbuda'
                'AI Anguilla'
                'AL Albania'
                'AM Armenia'
                'AN Netherlands Antilles'
                'AO Angola'
                'AQ Antarctica'
                'AR Argentina'
                'AS American Samoa'
                'AT Austria'
                'AU Australia'
                'AW Aruba'
                'AZ Azerbaijan'
                'BA Bosnia Herzegovina'
                'BB Barbados'
                'BD Bangladesh'
                'BE Belgium'
                'BF Burkina Faso'
                'BG Bulgaria'
                'BH Bahrain'
                'BI Burundi'
                'BJ Benin'
                'BM Bermuda'
                'BN Brunei Darussalam'
                'BO Bolivia'
                'BR Brazil'
                'BS Bahamas'
                'BT Bhutan'
                'BV Bouvet Island'
                'BW Botswana'
                'BY Belarus'
                'BZ Belize'
                'CC Cocos (Keeling) Islands'
                'CF Central African Republic'
                'CG Congo'
                'CH Switzerland'
                'CI Ivory Coast'
                'CL Chile'
                'CM Cameroon'
                'CN China'
                'CO Colombia'
                'CR Costa Rica'
                'CU Cuba'
                'CV Cape Verde'
                'CX Christmas Island'
                'CY Cyprus'
                'CZ Czech Republic'
                'DE Germany'
                'DJ Djibouti'
                'DK Denmark'
                'DM Dominica'
                'DO Dominican Republic'
                'DZ Algeria'
                'EC Ecuador'
                'EE Republic Of Estonia'
                'EG Egypt'
                'EH Western Sahara'
                'ES Spain'
                'ET Ethiopia'
                'FI Finland'
                'FJ Fiji'
                'FK Falkland Islands (Malvinas)'
                'FM Micronesia'
                'FO Faroe Islands'
                'FR France'
                'GA Gabon'
                'GB United Kingdom'
                'GD Grenada'
                'GE Georgia'
                'GF French Guiana'
                'GG Guernsey'
                'GH Ghana'
                'GI Gibraltar'
                'GL Greenland'
                'GM Gambia'
                'GN Guinea'
                'GP Guadeloupe'
                'GQ Equatorial Guinea'
                'GR Greece'
                'GT Guatemala'
                'GU Guam'
                'GW Guinea Bissau'
                'GY Guyana'
                'HK Hong Kong'
                'HM Hear and Mcdonald Islands'
                'HN Honduras'
                'HR Croatia'
                'HT Haiti'
                'HU Hungary'
                'ID Indonesia'
                'IE Ireland'
                'IL Israel'
                'IM Isle of Man'
                'IN India'
                'IO British Indian Ocean Terr'
                'IQ Iraq'
                'IR Iran (Islamic Republic Of)'
                'IS Iceland'
                'IT Italy'
                'JE Jersey'
                'JM Jamaica'
                'JO Jordan'
                'JP Japan'
                'KE Kenya'
                'KG Kyrgyzstan'
                'KH Cambodia'
                'KI Kiribati'
                'KM Comoros'
                'KN Saint Kitts And Nevis'
                'KP Korea, Democratic People'#39's'
                'KR Korea, Republic Of Coree'
                'KW Kuwait'
                'KY Cayman Islands'
                'KZ Kazakhstan'
                'LA Lao People'#39's Democratic'
                'LB Lebanon'
                'LC Saint Lucia'
                'LI Liechtenstein'
                'LK Sri Lanka'
                'LR Liberia'
                'LS Lesotho'
                'LT Lithuania'
                'LU Luxembourg'
                'LV Latvia'
                'LY Libyan Arab Jamahiriya'
                'MA Morocco'
                'MC Monaco'
                'MD Moldova'
                'ME Montenegro'
                'MG Madagascar'
                'MH Marshall Islands'
                'ML Mali'
                'MM Myanmar'
                'MN Mongolia'
                'MO Macau'
                'MP Northern Mariana Islands'
                'MQ Martinique'
                'MR Mauritania'
                'MS Montserrat'
                'MT Malta Malte'
                'MU Mauritius'
                'MV Maldives'
                'MW Malawi'
                'MX Mexico'
                'MY Malaysia'
                'MZ Mozambique'
                'NA Namibia'
                'NC New Calendonia'
                'NE Niger'
                'NF Norfolk Island'
                'NG Nigeria'
                'NI Nicaragua'
                'NL Netherlands Pays'
                'NO Norway'
                'NP Nepal'
                'NR Nauru'
                'NU Niue'
                'NZ New Zealand'
                'OM Oman'
                'PA Panama'
                'PE Peru'
                'PF French Polynesia'
                'PG Papua New Guinea'
                'PH Philippines'
                'PK Pakistan'
                'PL Poland'
                'PM St. Pierre And Miquelon'
                'PN Pitcairn'
                'PR Puerto Rico'
                'PT Portugal'
                'PW Palau'
                'PY Paraguay'
                'QA Qatar'
                'RE Reunion'
                'RO Romania'
                'RU Russian Federation'
                'RW Rwanda'
                'SA Saudi Arabia'
                'SB Solomon Islands'
                'SC Seychelles'
                'SD Sudan'
                'SE Sweden'
                'SG Singapore'
                'SH St. Helena'
                'SI Slovenia'
                'SJ Svalbard & Jan Mayen Islands'
                'SK Slovakia'
                'SM San Marino'
                'SN Senegal'
                'SO Somalia'
                'SR Suriname'
                'ST Sao Tome And Principe'
                'SV El Salvador'
                'SY Syrian Arab Republic'
                'SZ Swaziland'
                'TC Turks And Caicos Islands'
                'TD Chad'
                'TF French Southern Territories'
                'TG Togo'
                'TH Thailand'
                'TJ Tajikistan'
                'TK Tokelau'
                'TM Turkmenistan'
                'TN Tunisia'
                'TO Tonga'
                'TR Turkey'
                'TT Trinidad And Tobago'
                'TV Tuvalu'
                'TW Taiwan, Province Of China'
                'TZ Tanzania, United Republic'
                'UA Ukraine'
                'UG Uganda'
                'UM United States Islands Minor'
                'US United States'
                'UY Uruguay'
                'UZ Uzbekistan'
                'VA Vatican City State'
                'VC Saint Vincent & The Grenadin'
                'VE Venezuela'
                'VG Virgin Islands (British)'
                'VI Virgin Islands (U.S.)'
                'VN Viet Nam'
                'VU Vanuatu'
                'WF Wallis And Futuna Islands'
                'WS Samoa'
                'YE Yemen, Republic Of Yemen'
                'YT Mayotte'
                'ZA South Africa'
                'ZM Zambia'
                'ZW Zimbabwe')
            end
          end
          object LogoPanel: TPanel
            Left = 7
            Top = 392
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
              Width = 518
              Height = 45
              Caption = 
                'If you have a company Logo (graphic), you can insert it into the' +
                ' Client Letters such the Covering Letter (CLetter), the Privacy ' +
                'Act Letter (PIPEDA) and the Engangement Letter (ENGAGE). See Con' +
                'figure | Client Letter Design after you finish this window)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
              Transparent = True
              WordWrap = True
              vtBorderType = vtlblNoBorder
            end
          end
          object ReviewerPanel: TPanel
            Left = 7
            Top = 315
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
              MaxLength = 50
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
              MaxLength = 3
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
              MaxLength = 15
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
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 907
        Height = 650
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
            Width = 46
            Height = 15
            Caption = 'GST No:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label29: TLabel
            Left = 224
            Top = 7
            Width = 78
            Height = 15
            Caption = 'GST/HST rate:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label30: TLabel
            Left = 357
            Top = 14
            Width = 11
            Height = 15
            Caption = '%'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
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
            Font.Height = -12
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
            Font.Height = -12
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
            Left = 98
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
            Left = 105
            Top = 203
            Width = 40
            Height = 13
            Caption = 'Complex'
          end
          object Label21: TLabel
            Left = 210
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
            Left = 147
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
            Left = 308
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
            Left = 154
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
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = FeesBtnClick
          end
          object Prp_VSFee: TEdit
            Left = 168
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
            Left = 364
            Top = 168
            Width = 38
            Height = 20
            BorderStyle = bsNone
            TabOrder = 8
            Text = ' '
          end
          object Prp_CFee: TEdit
            Left = 168
            Top = 196
            Width = 38
            Height = 20
            BorderStyle = bsNone
            TabOrder = 9
            Text = ' '
          end
          object Prp_VCFee: TEdit
            Left = 364
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
          Width = 903
          Height = 25
          Align = alTop
          Caption = ' Billing and Invoice'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
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
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 0
        Width = 907
        Height = 650
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        Color = 12961221
        ParentColor = False
        TabOrder = 0
        object Label46: TLabel
          Left = 8
          Top = 62
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
          Top = 101
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
          Top = 78
          Width = 313
          Height = 15
          Caption = '(To be used in this session MAX Dir length 80 characters)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label50: TLabel
          Left = 147
          Top = 120
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
        object Label53: TLabel
          Left = 8
          Top = 31
          Width = 251
          Height = 16
          Caption = 'Required VisualTax data directories'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label96: TLabel
          Left = 3
          Top = 468
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
          Left = 228
          Top = 470
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
          Left = 4
          Top = 541
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
        object Label100: TLabel
          Left = 3
          Top = 490
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
          Left = 178
          Top = 511
          Width = 372
          Height = 15
          Caption = 
            '(The actual backup will be below the above dir as Backup01, 02, ' +
            'etc)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label103: TLabel
          Left = 206
          Top = 328
          Width = 201
          Height = 13
          Caption = 'Typically it would ber C:\VT\T2-2023\data'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label121: TLabel
          Left = 3
          Top = 273
          Width = 217
          Height = 15
          Caption = 'Program that created last year'#39's return...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label122: TLabel
          Left = 3
          Top = 308
          Width = 108
          Height = 15
          Caption = 'last year'#39's tax return'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label70: TLabel
          Left = 3
          Top = 294
          Width = 121
          Height = 15
          Caption = 'Directory that contains'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label82: TLabel
          Left = 8
          Top = 136
          Width = 99
          Height = 15
          Caption = 'Client Documents'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label141: TLabel
          Left = 147
          Top = 167
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
        object Label83: TLabel
          Left = 8
          Top = 150
          Width = 48
          Height = 15
          Caption = 'Directory'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label138: TLabel
          Left = 5
          Top = 393
          Width = 132
          Height = 29
          AutoSize = False
          Caption = 'PROGRAM DIR last year'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Label139: TLabel
          Left = 206
          Top = 416
          Width = 219
          Height = 15
          Caption = 'Typically it would be C:\VT-2022\T2-2023'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label34: TLabel
          Left = 3
          Top = 328
          Width = 145
          Height = 15
          Caption = ' for ROLL-OVER purposes'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label27: TLabel
          Left = 206
          Top = 347
          Width = 226
          Height = 13
          Caption = 'Or it can be the same with the Current Directory '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SelectCurBtn: TBitBtn
          Left = 546
          Top = 62
          Width = 83
          Height = 21
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
          TabOrder = 0
          OnClick = SelectCurBtnClick
        end
        object SelectDefBtn: TBitBtn
          Left = 546
          Top = 101
          Width = 83
          Height = 18
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
          TabOrder = 1
          OnClick = SelectDefBtnClick
        end
        object SelectL1Btn: TBitBtn
          Left = 547
          Top = 304
          Width = 82
          Height = 20
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = SelectL1BtnClick
        end
        object Dir_Cur: TEdit
          Left = 145
          Top = 53
          Width = 395
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          TabOrder = 3
        end
        object Dir_Deflt: TEdit
          Left = 145
          Top = 99
          Width = 395
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          TabOrder = 4
        end
        object Dir_LastYr: TEdit
          Left = 143
          Top = 302
          Width = 393
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          TabOrder = 8
        end
        object Panel17: TPanel
          Left = 635
          Top = 48
          Width = 176
          Height = 169
          Color = 15461355
          TabOrder = 13
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
            Left = 8
            Top = 31
            Width = 108
            Height = 13
            Caption = 'C:\VT\T2-2024\DATA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label44: TLabel
            Left = 7
            Top = 65
            Width = 75
            Height = 13
            Caption = 'G:\xxxxx\DATA'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 903
          Height = 25
          Align = alTop
          Alignment = taLeftJustify
          Caption = ' Data Directories'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 14
        end
        object CreateNewDirBtn: TBitBtn
          Left = 546
          Top = 40
          Width = 83
          Height = 24
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
          TabOrder = 15
          OnClick = CreateNewDirBtnClick
        end
        object BackupFrequency: TEdit
          Left = 197
          Top = 468
          Width = 24
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
        object LastBackupDir: TEdit
          Left = 162
          Top = 539
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
          TabOrder = 12
        end
        object BackupDir: TEdit
          Left = 141
          Top = 491
          Width = 395
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          TabOrder = 11
        end
        object SelectBackupDirBtn: TBitBtn
          Left = 542
          Top = 489
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
          TabOrder = 16
          OnClick = SelectBackupDirBtnClick
        end
        object RolloverProgram: TComboBox
          Left = 241
          Top = 274
          Width = 134
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          Text = 'VisualTax'
          Items.Strings = (
            'VisualTax'
            'CanTax'
            'Profile'
            'TaxCycle')
        end
        object Panel4: TPanel
          Left = 3
          Top = 223
          Width = 798
          Height = 25
          Alignment = taLeftJustify
          Caption = 'Last year'#39's data (For ROLL-OVER purposes)'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 17
        end
        object Dir_ClientDocs: TEdit
          Left = 147
          Top = 141
          Width = 393
          Height = 20
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          MaxLength = 80
          ParentFont = False
          TabOrder = 5
        end
        object SelectDirClientDocBtn: TBitBtn
          Left = 63
          Top = 150
          Width = 71
          Height = 16
          Hint = 'Click if directory already exists'
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 18
          OnClick = SelectDirClientDocBtnClick
        end
        object SelectDBFBtn: TBitBtn
          Left = 178
          Top = 191
          Width = 83
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
          TabOrder = 19
          Visible = False
          OnClick = SelectDBFBtnClick
        end
        object Dir_DBFData: TEdit
          Left = 147
          Top = 189
          Width = 14
          Height = 21
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          Visible = False
        end
        object Dir_PgmLastYr: TEdit
          Left = 143
          Top = 390
          Width = 393
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
        object btnDir_PgmLastYr: TBitBtn
          Left = 542
          Top = 391
          Width = 87
          Height = 21
          Caption = 'Browse...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Ms Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 20
          OnClick = btnDir_PgmLastYrClick
        end
        object Panel1: TPanel
          Left = 4
          Top = 437
          Width = 798
          Height = 25
          Alignment = taLeftJustify
          Caption = 'Data backup'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 21
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Display'
      ImageIndex = 5
      object ScrollBox4: TScrollBox
        Left = 0
        Top = 0
        Width = 907
        Height = 650
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Panel19: TPanel
          Left = 0
          Top = 0
          Width = 903
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
          Width = 701
          Height = 400
          BevelOuter = bvLowered
          TabOrder = 1
          object Label41: TLabel
            Left = 14
            Top = 14
            Width = 188
            Height = 13
            Caption = 'Color on entry to a field of a form'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object vtLabel2: TvtLabel
            Left = 175
            Top = 42
            Width = 142
            Height = 15
            Caption = 'Linked field color is set to:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
            vtBorderType = vtlblNoBorder
          end
          object vtLabel3: TvtLabel
            Left = 147
            Top = 63
            Width = 167
            Height = 15
            Caption = 'Calculated  field color is set to:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            Transparent = True
            vtBorderType = vtlblNoBorder
          end
          object Label76: TLabel
            Left = 14
            Top = 189
            Width = 100
            Height = 13
            Caption = 'Form data display'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label75: TLabel
            Left = 14
            Top = 224
            Width = 148
            Height = 13
            Caption = 'Form Size (zoom) in effect'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label57: TLabel
            Left = 280
            Top = 221
            Width = 3
            Height = 16
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label73: TLabel
            Left = 224
            Top = 221
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
          object Label74: TLabel
            Left = 238
            Top = 223
            Width = 254
            Height = 15
            Caption = '(automatically set by the +- zoom of main form)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label117: TLabel
            Left = 14
            Top = 259
            Width = 119
            Height = 15
            Caption = 'Most Recent Returns'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label38: TLabel
            Left = 14
            Top = 294
            Width = 141
            Height = 13
            Caption = 'Navigation and warnings'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label62: TLabel
            Left = 266
            Top = 294
            Width = 215
            Height = 15
            Caption = '(If Checked, ESC goes to TaxSummary)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Label9: TLabel
            Left = 14
            Top = 329
            Width = 143
            Height = 15
            Caption = 'Set the display resolution'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label37: TLabel
            Left = 21
            Top = 350
            Width = 422
            Height = 13
            Caption = 
              'Changing the display resolution will affect all other programs (' +
              'as if using the Control Panel) '
          end
          object UseDefaultBoxColor: TBitBtn
            Left = 210
            Top = 7
            Width = 106
            Height = 29
            Caption = 'Change color...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = UseDefaultBoxColorClick
          end
          object LinkedBoxColor: TEdit
            Left = 329
            Top = 42
            Width = 85
            Height = 20
            TabStop = False
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 1
            Text = 'LinkedBoxColor'
          end
          object ProtectedBoxColor: TEdit
            Left = 329
            Top = 63
            Width = 85
            Height = 20
            TabStop = False
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 2
            Text = 'ProtectedBoxColor'
          end
          object ActiveBoxColor: TEdit
            Left = 329
            Top = 13
            Width = 85
            Height = 20
            TabStop = False
            BorderStyle = bsNone
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            TabOrder = 3
            Text = 'ActiveBoxColor'
          end
          object DataInBold: TCheckBox
            Left = 175
            Top = 189
            Width = 190
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Show data in Bold in all forms'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
          end
          object FormZoom: TEdit
            Left = 182
            Top = 220
            Width = 36
            Height = 25
            Hint = 'It can be set also via the Zoom in main menu'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
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
            Top = 259
            Width = 141
            Height = 17
            Caption = 'Hide most recent returns'
            TabOrder = 6
          end
          object Opr_Close: TCheckBox
            Left = 189
            Top = 294
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
          end
          object SetDisplayBtn: TBitBtn
            Left = 175
            Top = 326
            Width = 162
            Height = 25
            Caption = 'Set Display Resolution...'
            TabOrder = 8
            OnClick = SetDisplayBtnClick
          end
          object ShowUsedForms: TCheckBox
            Left = 14
            Top = 140
            Width = 295
            Height = 17
            Caption = 'Show forms used last time you saved the return '
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
            Top = 161
            Width = 204
            Height = 17
            Caption = 'If ticked, open at last form used'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 10
          end
          object EscOption: TRadioGroup
            Left = 14
            Top = 84
            Width = 316
            Height = 36
            Caption = 'ESC key - When pressed on a form it will'
            Columns = 2
            Items.Strings = (
              'Close the form'
              'Go to Tax Summary')
            TabOrder = 11
          end
          object GroupBox1: TGroupBox
            Left = 519
            Top = 7
            Width = 169
            Height = 67
            Caption = 'Skin'
            TabOrder = 12
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
          object GroupBox2: TGroupBox
            Left = 519
            Top = 80
            Width = 169
            Height = 91
            Caption = 'Active tab color'
            TabOrder = 13
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
        Width = 907
        Height = 650
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object DefaultsPanel: TGroupBox
          Left = 14
          Top = 35
          Width = 547
          Height = 386
          Caption = 'Default values for tax returns'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object Label28: TLabel
            Left = 16
            Top = 252
            Width = 388
            Height = 15
            Caption = 
              'Disclaimer above signature on Page 8 (Leave it blank, if not req' +
              'uired)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -12
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
            Top = 273
            Width = 519
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
            Left = 14
            Top = 189
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
          end
          object UseProperName: TCheckBox
            Left = 14
            Top = 217
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
            Width = 323
            Height = 36
            Caption = 'Name/address Capitalization: Convert to: '
            Columns = 3
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            Items.Strings = (
              'UpperCase'
              'ProperCase'
              'None')
            ParentFont = False
            TabOrder = 7
          end
          object DecimalAssume: TCheckBox
            Left = 308
            Top = 315
            Width = 43
            Height = 17
            Caption = 
              'Decimal Assume (if you enter 12345 it will register as 123.45) D' +
              'O NOT TICK it unless USED TO IT'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 8
            Visible = False
          end
        end
        object Panel21: TPanel
          Left = 0
          Top = 0
          Width = 903
          Height = 25
          Align = alTop
          Caption = ' Defaults Settings'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
        object FileNameFormat: TRadioGroup
          Left = 567
          Top = 34
          Width = 307
          Height = 106
          Caption = 'FILE NAME FORMAT'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Items.Strings = (
            'BusinessNumber 999999999.YR'
            'CompanyName-{BusinessNumber}.YR')
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'Internet Updates'
      ImageIndex = 8
      object ScrollBox6: TScrollBox
        Left = 0
        Top = 0
        Width = 907
        Height = 650
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Label67: TLabel
          Left = 89
          Top = 48
          Width = 167
          Height = 17
          Caption = 'Check automaticaly every'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label68: TLabel
          Left = 169
          Top = 81
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
        object Label69: TLabel
          Left = 77
          Top = 120
          Width = 173
          Height = 136
          Caption = 
            'If you set the frequency to 0, the program will never check the ' +
            'Internet automatically. You will need to initiate the internet c' +
            'heck manually via the Help | Check Update via the Web'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
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
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = '7'
        end
        object Panel14: TPanel
          Left = 316
          Top = 49
          Width = 329
          Height = 274
          BevelWidth = 2
          Color = 15461355
          TabOrder = 1
          object Label61: TLabel
            Left = 16
            Top = 24
            Width = 280
            Height = 85
            Caption = 
              'The program will follow this schedule to automatically check the' +
              ' VisualTax web site for any updates available. If an update is a' +
              'vailable it will prompt you to download and install the update.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
          end
          object Label64: TLabel
            Left = 11
            Top = 104
            Width = 273
            Height = 85
            Caption = 
              'The program keeps track of the last time you checked the Interne' +
              't for any program update. Based on this schedule, it will initia' +
              'te automatically the Internet check at program start up time.'
            Color = 15461355
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentColor = False
            ParentFont = False
            WordWrap = True
          end
          object Label65: TLabel
            Left = 11
            Top = 168
            Width = 273
            Height = 68
            Caption = 
              'i.e: If you set the frequency to 1 (once a day), the first time ' +
              'in the day you start the program the Internet will be checked au' +
              'tomatically.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            WordWrap = True
          end
          object Label66: TLabel
            Left = 120
            Top = 8
            Width = 42
            Height = 18
            Caption = 'Notes'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object Panel26: TPanel
          Left = 0
          Top = 0
          Width = 903
          Height = 25
          Align = alTop
          Caption = ' Internet Updates'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Efile'
      ImageIndex = 8
      object ScrollBox7: TScrollBox
        Left = 0
        Top = 0
        Width = 907
        Height = 650
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object Nfl_Efile: TCheckBox
          Left = 203
          Top = 70
          Width = 204
          Height = 18
          Caption = 'Check if most returns are EFiled'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object SetupEOLBtn: TBitBtn
          Left = 259
          Top = 112
          Width = 113
          Height = 25
          Caption = 'SetUp EOL...'
          TabOrder = 1
          Visible = False
          OnClick = SetupEOLBtnClick
        end
        object Panel28: TPanel
          Left = 0
          Top = 0
          Width = 903
          Height = 25
          Align = alTop
          Caption = ' Efile'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
          Font.Height = -21
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
        end
        object Ef_ThirdParty: TCheckBox
          Left = 203
          Top = 91
          Width = 253
          Height = 18
          Caption = 'Efile as third party prepared/transmitter'
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
    object TabSheet4: TTabSheet
      Caption = 'Security/Password'
      ImageIndex = 7
      object ScrollBox8: TScrollBox
        Left = 0
        Top = 0
        Width = 907
        Height = 650
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
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label55: TLabel
            Left = 21
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
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object SetPgmPswBtn: TBitBtn
            Left = 14
            Top = 28
            Width = 162
            Height = 25
            Caption = 'Set Program Password...'
            TabOrder = 0
            OnClick = SetPgmPswBtnClick
          end
          object RemovePgmPswBtn: TBitBtn
            Left = 196
            Top = 28
            Width = 190
            Height = 25
            Caption = 'Remove Program Password'
            TabOrder = 1
            OnClick = RemovePgmPswBtnClick
          end
        end
        object Panel27: TPanel
          Left = 0
          Top = 0
          Width = 903
          Height = 25
          Align = alTop
          Caption = ' Security/Password'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
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
      object ScrollBox9: TScrollBox
        Left = 0
        Top = 0
        Width = 907
        Height = 650
        Align = alClient
        TabOrder = 0
        object Panel29: TPanel
          Left = 0
          Top = 0
          Width = 903
          Height = 25
          Align = alTop
          Caption = ' Printing'
          Color = 11301888
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10930928
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
            Font.Height = -12
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
            Font.Height = -12
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
            Width = 133
            Height = 15
            Caption = 'forms such as S8 (CCA)'
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
            Font.Height = -12
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
            Width = 162
            Height = 15
            Caption = 'Printing Font Size Increment:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
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
            Width = 95
            Height = 15
            Caption = 'BarCode printing'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
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
    Width = 915
    Height = 36
    Align = alTop
    Alignment = taLeftJustify
    Caption = '   Configuration Options'
    Color = 11301888
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -23
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object ExitBtn: TBitBtn
      Left = 552
      Top = 8
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
    Left = 853
    Top = 195
  end
end
