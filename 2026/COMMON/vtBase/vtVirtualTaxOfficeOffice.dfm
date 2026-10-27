object vtVirtualTaxOfficeOffice: TvtVirtualTaxOfficeOffice
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Virtual Tax Office'
  ClientHeight = 566
  ClientWidth = 618
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object shHeader: TvtShape
    Left = 0
    Top = 0
    Width = 618
    Height = 70
    Align = alTop
    Brush.Color = 11301888
    GradientColor = clBlack
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
    ExplicitWidth = 764
  end
  object vtLabel37: TvtLabel
    Left = 184
    Top = 21
    Width = 249
    Height = 31
    Caption = 'Virtual Office Profile'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10930928
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    vtBorderType = vtlblNoBorder
  end
  object pnlMain: TPanel
    Left = 0
    Top = 70
    Width = 618
    Height = 496
    Align = alClient
    TabOrder = 0
    object gbLogin: TGroupBox
      Left = 5
      Top = 6
      Width = 601
      Height = 134
      Caption = 'Identification'
      TabOrder = 0
      object lbCyberId: TLabel
        Left = 10
        Top = 24
        Width = 44
        Height = 13
        Caption = 'Virtual ID'
      end
      object Label1: TLabel
        Left = 10
        Top = 78
        Width = 38
        Height = 13
        Caption = 'Contact'
      end
      object Label3: TLabel
        Left = 10
        Top = 51
        Width = 24
        Height = 13
        Caption = 'Email'
      end
      object Label17: TLabel
        Left = 307
        Top = 24
        Width = 71
        Height = 13
        Caption = 'Business Name'
      end
      object Label18: TLabel
        Left = 307
        Top = 51
        Width = 43
        Height = 13
        Caption = 'Web Site'
      end
      object lbCRAEfilerName: TLabel
        Left = 307
        Top = 105
        Width = 78
        Height = 13
        Caption = 'CRA Efiler Name'
      end
      object edCyberId: TEdit
        Left = 112
        Top = 21
        Width = 168
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edContact: TEdit
        Left = 112
        Top = 75
        Width = 479
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object edEmail: TEdit
        Left = 112
        Top = 48
        Width = 168
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object edBusinessName: TEdit
        Left = 409
        Top = 21
        Width = 182
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object edWebSiteUrl: TEdit
        Left = 409
        Top = 48
        Width = 182
        Height = 21
        TabOrder = 4
      end
      object edCRAEfilerName: TEdit
        Left = 409
        Top = 102
        Width = 182
        Height = 21
        TabOrder = 5
      end
      object cbHaveCRAEfilerNumber: TCheckBox
        Left = 112
        Top = 104
        Width = 137
        Height = 17
        Caption = 'Have CRA Efiler Number'
        TabOrder = 6
      end
    end
    object gbAddress: TGroupBox
      Left = 5
      Top = 143
      Width = 291
      Height = 106
      Caption = 'Address'
      TabOrder = 1
      object Label5: TLabel
        Left = 10
        Top = 24
        Width = 30
        Height = 13
        Caption = 'Street'
      end
      object Label6: TLabel
        Left = 10
        Top = 51
        Width = 19
        Height = 13
        Caption = 'City'
      end
      object Label7: TLabel
        Left = 10
        Top = 78
        Width = 41
        Height = 13
        Caption = 'Province'
      end
      object Label8: TLabel
        Left = 155
        Top = 78
        Width = 29
        Height = 13
        Caption = 'Postal'
      end
      object edStreet: TEdit
        Left = 112
        Top = 21
        Width = 168
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edCity: TEdit
        Left = 112
        Top = 48
        Width = 168
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object edProvince: TEdit
        Left = 112
        Top = 75
        Width = 35
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
      object edPostal: TEdit
        Left = 194
        Top = 75
        Width = 62
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
    end
    object GroupBox1: TGroupBox
      Left = 304
      Top = 146
      Width = 302
      Height = 103
      Caption = 'Phone'
      TabOrder = 2
      object Label10: TLabel
        Left = 8
        Top = 21
        Width = 23
        Height = 13
        Caption = 'Area'
      end
      object Label11: TLabel
        Left = 150
        Top = 21
        Width = 30
        Height = 13
        Caption = 'Phone'
      end
      object Label12: TLabel
        Left = 8
        Top = 48
        Width = 17
        Height = 13
        Caption = 'Cell'
      end
      object Label13: TLabel
        Left = 8
        Top = 75
        Width = 18
        Height = 13
        Caption = 'Fax'
      end
      object edArea: TEdit
        Left = 110
        Top = 18
        Width = 30
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edPhone: TEdit
        Left = 184
        Top = 18
        Width = 108
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object edCell: TEdit
        Left = 110
        Top = 45
        Width = 182
        Height = 21
        TabOrder = 2
      end
      object edFax: TEdit
        Left = 110
        Top = 72
        Width = 182
        Height = 21
        TabOrder = 3
      end
    end
    object gbComputer: TGroupBox
      Left = 5
      Top = 255
      Width = 291
      Height = 128
      Caption = 'Computer and software available'
      TabOrder = 3
      object Label14: TLabel
        Left = 7
        Top = 25
        Width = 72
        Height = 13
        Caption = 'Teamviewer ID'
      end
      object Label15: TLabel
        Left = 5
        Top = 125
        Width = 101
        Height = 13
        Caption = 'Virtual Meeting Alarm'
        Visible = False
      end
      object Label16: TLabel
        Left = 7
        Top = 100
        Width = 100
        Height = 13
        Caption = 'Tax Software Names'
      end
      object Label2: TLabel
        Left = 8
        Top = 76
        Width = 69
        Height = 13
        Caption = 'UltraViewer ID'
      end
      object edTeamviewerID: TEdit
        Left = 112
        Top = 22
        Width = 168
        Height = 21
        TabOrder = 0
      end
      object edVirtualMeetingAlarm: TEdit
        Left = 110
        Top = 122
        Width = 168
        Height = 21
        TabOrder = 1
        Visible = False
      end
      object cbZoomVideoID: TCheckBox
        Left = 112
        Top = 50
        Width = 72
        Height = 17
        Caption = 'ZoomVideo'
        TabOrder = 2
      end
      object edTaxSoftwareNames: TEdit
        Left = 112
        Top = 97
        Width = 168
        Height = 21
        TabOrder = 4
      end
      object edUltraViewerId: TEdit
        Left = 113
        Top = 73
        Width = 168
        Height = 21
        TabOrder = 3
      end
    end
    object btnSave: TButton
      Left = 228
      Top = 454
      Width = 75
      Height = 25
      Caption = 'Save'
      Default = True
      TabOrder = 4
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 309
      Top = 454
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 5
    end
    object GroupBox2: TGroupBox
      Left = 304
      Top = 255
      Width = 302
      Height = 186
      Caption = 'Services Provided'
      TabOrder = 6
      object Label4: TLabel
        Left = 8
        Top = 25
        Width = 82
        Height = 13
        Caption = 'Years in business'
      end
      object Label19: TLabel
        Left = 8
        Top = 102
        Width = 96
        Height = 13
        Caption = 'Other Service Desc.'
      end
      object Label20: TLabel
        Left = 8
        Top = 126
        Width = 53
        Height = 13
        Caption = 'Experience'
      end
      object cbT1: TCheckBox
        Left = 8
        Top = 51
        Width = 32
        Height = 17
        Caption = 'T1'
        Enabled = False
        TabOrder = 0
      end
      object cbT2: TCheckBox
        Left = 47
        Top = 51
        Width = 33
        Height = 17
        Caption = 'T2'
        Enabled = False
        TabOrder = 1
      end
      object edYearsInBusiness: TEdit
        Left = 110
        Top = 22
        Width = 23
        Height = 21
        TabOrder = 2
      end
      object cbT3: TCheckBox
        Left = 87
        Top = 51
        Width = 32
        Height = 17
        Caption = 'T3'
        Enabled = False
        TabOrder = 3
      end
      object cbT4T5: TCheckBox
        Left = 126
        Top = 51
        Width = 44
        Height = 17
        Caption = 'T4T5'
        Enabled = False
        TabOrder = 4
      end
      object cbNR4: TCheckBox
        Left = 176
        Top = 51
        Width = 40
        Height = 17
        Caption = 'NR4'
        TabOrder = 5
      end
      object cbT3010: TCheckBox
        Left = 225
        Top = 51
        Width = 49
        Height = 17
        Caption = 'T3010'
        TabOrder = 6
      end
      object cbT5013: TCheckBox
        Left = 8
        Top = 76
        Width = 49
        Height = 17
        Caption = 'T5013'
        TabOrder = 7
      end
      object cbT5018: TCheckBox
        Left = 63
        Top = 76
        Width = 49
        Height = 17
        Caption = 'T5018'
        TabOrder = 8
      end
      object cbvtNOA: TCheckBox
        Left = 118
        Top = 76
        Width = 49
        Height = 17
        Caption = 'vtNOA'
        TabOrder = 9
      end
      object cbOther: TCheckBox
        Left = 176
        Top = 76
        Width = 49
        Height = 17
        Caption = 'Other'
        TabOrder = 10
      end
      object edOtherServiceDescription: TEdit
        Left = 110
        Top = 99
        Width = 182
        Height = 21
        TabOrder = 11
      end
      object edExperience: TMemo
        Left = 110
        Top = 126
        Width = 182
        Height = 52
        ScrollBars = ssVertical
        TabOrder = 12
      end
    end
  end
end
