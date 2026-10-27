object vtVirtualTaxOfficePayer: TvtVirtualTaxOfficePayer
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Virtual Tax Office'
  ClientHeight = 435
  ClientWidth = 711
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
    Width = 711
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
    Left = 230
    Top = 21
    Width = 250
    Height = 31
    Caption = 'Virtual Client Profile'
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
    Width = 711
    Height = 365
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 403
    object gbLogin: TGroupBox
      Left = 6
      Top = 6
      Width = 291
      Height = 163
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
        Top = 51
        Width = 51
        Height = 13
        Caption = 'First Name'
      end
      object Label2: TLabel
        Left = 10
        Top = 78
        Width = 50
        Height = 13
        Caption = 'Last Name'
      end
      object Label3: TLabel
        Left = 10
        Top = 105
        Width = 24
        Height = 13
        Caption = 'Email'
      end
      object Label4: TLabel
        Left = 10
        Top = 134
        Width = 76
        Height = 13
        Caption = 'Virtual Office ID'
      end
      object btnShowProfile: TSpeedButton
        Left = 240
        Top = 131
        Width = 40
        Height = 21
        Caption = 'Profile'
        OnClick = btnShowProfileClick
      end
      object edCyberId: TEdit
        Left = 112
        Top = 21
        Width = 168
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edFirstName: TEdit
        Left = 112
        Top = 48
        Width = 168
        Height = 21
        TabOrder = 1
      end
      object edLastName: TEdit
        Left = 112
        Top = 75
        Width = 168
        Height = 21
        TabOrder = 2
      end
      object edEmail: TEdit
        Left = 112
        Top = 102
        Width = 168
        Height = 21
        ReadOnly = True
        TabOrder = 3
      end
      object edTaxOfficeCyberId: TEdit
        Left = 112
        Top = 131
        Width = 126
        Height = 21
        TabOrder = 4
      end
    end
    object gbAddress: TGroupBox
      Left = 303
      Top = 6
      Width = 397
      Height = 106
      Caption = 'Address'
      TabOrder = 1
      object Label5: TLabel
        Left = 8
        Top = 24
        Width = 30
        Height = 13
        Caption = 'Street'
      end
      object Label6: TLabel
        Left = 8
        Top = 51
        Width = 19
        Height = 13
        Caption = 'City'
      end
      object Label7: TLabel
        Left = 179
        Top = 51
        Width = 41
        Height = 13
        Caption = 'Province'
      end
      object Label8: TLabel
        Left = 283
        Top = 51
        Width = 29
        Height = 13
        Caption = 'Postal'
      end
      object Label9: TLabel
        Left = 8
        Top = 78
        Width = 39
        Height = 13
        Caption = 'Country'
      end
      object edStreet: TEdit
        Left = 59
        Top = 21
        Width = 325
        Height = 21
        TabOrder = 0
      end
      object edCity: TEdit
        Left = 59
        Top = 48
        Width = 114
        Height = 21
        TabOrder = 1
      end
      object edProvince: TEdit
        Left = 240
        Top = 48
        Width = 35
        Height = 21
        TabOrder = 2
      end
      object edPostal: TEdit
        Left = 322
        Top = 48
        Width = 62
        Height = 21
        TabOrder = 3
      end
      object edCountry: TEdit
        Left = 59
        Top = 75
        Width = 114
        Height = 21
        TabOrder = 4
      end
    end
    object GroupBox1: TGroupBox
      Left = 303
      Top = 116
      Width = 397
      Height = 77
      Caption = 'Phone'
      TabOrder = 2
      object Label10: TLabel
        Left = 8
        Top = 24
        Width = 23
        Height = 13
        Caption = 'Area'
      end
      object Label11: TLabel
        Left = 99
        Top = 24
        Width = 30
        Height = 13
        Caption = 'Phone'
      end
      object Label12: TLabel
        Left = 208
        Top = 24
        Width = 17
        Height = 13
        Caption = 'Cell'
      end
      object Label13: TLabel
        Left = 8
        Top = 52
        Width = 18
        Height = 13
        Caption = 'Fax'
      end
      object edArea: TEdit
        Left = 59
        Top = 21
        Width = 30
        Height = 21
        TabOrder = 0
      end
      object edPhone: TEdit
        Left = 133
        Top = 21
        Width = 63
        Height = 21
        TabOrder = 1
      end
      object edCell: TEdit
        Left = 241
        Top = 21
        Width = 143
        Height = 21
        TabOrder = 2
      end
      object edFax: TEdit
        Left = 59
        Top = 49
        Width = 137
        Height = 21
        TabOrder = 3
      end
    end
    object gbComputer: TGroupBox
      Left = 6
      Top = 175
      Width = 291
      Height = 149
      Caption = 'Computer and software available'
      TabOrder = 3
      object Label14: TLabel
        Left = 7
        Top = 46
        Width = 72
        Height = 13
        Caption = 'Teamviewer ID'
      end
      object Label15: TLabel
        Left = 7
        Top = 149
        Width = 101
        Height = 13
        Caption = 'Virtual Meeting Alarm'
        Visible = False
      end
      object Label16: TLabel
        Left = 7
        Top = 95
        Width = 69
        Height = 13
        Caption = 'UltraViewer ID'
      end
      object Label17: TLabel
        Left = 7
        Top = 122
        Width = 100
        Height = 13
        Caption = 'Tax Software Names'
      end
      object rbWindows: TRadioButton
        Left = 10
        Top = 20
        Width = 64
        Height = 17
        Caption = 'Windows'
        TabOrder = 0
      end
      object rbMac: TRadioButton
        Left = 82
        Top = 20
        Width = 39
        Height = 17
        Caption = 'Mac'
        TabOrder = 1
      end
      object rbOther: TRadioButton
        Left = 129
        Top = 20
        Width = 51
        Height = 17
        Caption = 'Other'
        TabOrder = 2
      end
      object edTeamviewerID: TEdit
        Left = 112
        Top = 43
        Width = 168
        Height = 21
        TabOrder = 3
      end
      object edVirtualMeetingAlarm: TEdit
        Left = 112
        Top = 146
        Width = 168
        Height = 21
        TabOrder = 4
        Visible = False
      end
      object cbZoomVideoID: TCheckBox
        Left = 112
        Top = 69
        Width = 72
        Height = 17
        Caption = 'ZoomVideo'
        TabOrder = 5
      end
      object edUltraViewerId: TEdit
        Left = 112
        Top = 92
        Width = 168
        Height = 21
        TabOrder = 6
      end
      object edTaxSoftwareNames: TEdit
        Left = 112
        Top = 119
        Width = 168
        Height = 21
        TabOrder = 7
      end
    end
    object btnSave: TButton
      Left = 275
      Top = 332
      Width = 75
      Height = 25
      Caption = 'Save'
      Default = True
      TabOrder = 4
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 356
      Top = 332
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 5
    end
  end
end
