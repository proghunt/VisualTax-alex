object TaxbyteT2_2027: TTaxbyteT2_2027
  Left = 35
  Top = 102
  Caption = 'TaxbyteT2_2027'
  ClientHeight = 450
  ClientWidth = 808
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BookBack: TShape
    Left = 8
    Top = 88
    Width = 769
    Height = 449
    Brush.Color = clGray
    Shape = stRoundRect
  end
  object MonitorPlanBtn: TChart
    Left = -1
    Top = 0
    Width = 793
    Height = 81
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
    Title.Font.Color = 12971774
    Title.Font.Height = -27
    Title.Font.Name = 'Times New Roman'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      '   Taxbyte to VisualTax'
      '')
    AxisVisible = False
    Chart3DPercent = 1
    View3DOptions.HorizOffset = -1257
    View3DOptions.VertOffset = -365
    View3DOptions.Zoom = 1
    View3DWalls = False
    Zoom.AnimatedSteps = 9
    BevelOuter = bvNone
    TabOrder = 0
    ColorPaletteIndex = 13
    object Label3: TLabel
      Left = 72
      Top = 35
      Width = 124
      Height = 14
      Caption = 'Convert into directory:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object CancelBtn: TBitBtn
      Left = 688
      Top = 40
      Width = 75
      Height = 33
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 0
      OnClick = CancelBtnClick
    end
    object ConvertOneBtn: TBitBtn
      Left = 464
      Top = 40
      Width = 131
      Height = 33
      Caption = 'Convert Selected file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = ConvertOneBtnClick
    end
    object ConvertAllBtn: TBitBtn
      Left = 600
      Top = 40
      Width = 81
      Height = 33
      Caption = 'Convert ALL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = ConvertAllBtnClick
    end
    object ToDirBox: TEdit
      Left = 48
      Top = 48
      Width = 169
      Height = 23
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'ToDirBox'
    end
    object ReplaceOptionBox: TRadioGroup
      Left = 296
      Top = 40
      Width = 161
      Height = 33
      Caption = 'Replace existing return(s)'
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemIndex = 1
      Items.Strings = (
        'Yes'
        'No')
      ParentFont = False
      TabOrder = 4
    end
    object ShowFilesBtn: TBitBtn
      Left = 8
      Top = 40
      Width = 25
      Height = 33
      Caption = 'Show Files'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      Visible = False
      OnClick = ShowFilesBtnClick
    end
    object HelpBtn: TBitBtn
      Left = 224
      Top = 40
      Width = 65
      Height = 33
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 6
      OnClick = HelpBtnClick
    end
  end
  object RPanel: TPanel
    Left = 408
    Top = 112
    Width = 337
    Height = 393
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 16
      Top = 8
      Width = 313
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
          Left = 16
          Top = 8
          Width = 289
          Height = 337
          Color = 12971774
          TabOrder = 0
          object GroupBox1: TGroupBox
            Left = 8
            Top = 16
            Width = 273
            Height = 97
            Caption = 'Identification'
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
            object Label4: TLabel
              Left = 8
              Top = 72
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
            object Label13: TLabel
              Left = 8
              Top = 56
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
            object Label2: TLabel
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
          end
          object GroupBox2: TGroupBox
            Left = 8
            Top = 120
            Width = 273
            Height = 121
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
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 8
              Top = 80
              Width = 54
              Height = 14
              Caption = 'PostalCode'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
          end
          object GroupBox4: TGroupBox
            Left = 4
            Top = 246
            Width = 277
            Height = 83
            Caption = 'Contact Numbers'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold, fsItalic]
            ParentColor = False
            ParentFont = False
            TabOrder = 2
            object Label10: TLabel
              Left = 8
              Top = 24
              Width = 30
              Height = 14
              Caption = 'Phone'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Arial'
              Font.Style = []
              ParentFont = False
            end
          end
        end
      end
    end
  end
  object LPanel: TPanel
    Left = 32
    Top = 112
    Width = 297
    Height = 393
    BevelOuter = bvNone
    Color = clSilver
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 8
      Top = 8
      Width = 281
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
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Arial'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'CorpName'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'YearEnd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FileName'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FileStat'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FNameExt'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Address'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Address2'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'City'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Prov'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PCode'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Country'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MailAdd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MailAdd2'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MailCity'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MailProv'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MailPCode'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MailCntry'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Contact'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Phone'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClientNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InvNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Jurisdict'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CorpType'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MajBusAct'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InvAmt'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GrossRev'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TotAssets'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InvoicePd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SignOffcr'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONAcctNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCAcctNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABAcctNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BCAcctNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MBAcctNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SKAcctNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NetIncome'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TaxableInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ActvBusInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TaxCapGain'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DividsPaid'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DividsRecd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SmBusDedct'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MPDedct'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NonBusFTC'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BusFTC'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ITC'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartITax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartIVTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartIV1Tax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartVI1Tax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartI3Tax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartVITax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Installmnt'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ITCRefund'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DividRefd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BalDueRef'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InstallDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RDTOH'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Donations'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ITC_CF'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CapDivAcct'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RandD'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ResPools'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UnSurTaxCr'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NonCapLoss'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GrsCapLoss'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FarmLoss'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NFPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NFIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NFCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NFBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NFInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PEPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PEIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PECapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PEBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PEInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NBPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NBIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NBCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NBBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NBInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MBPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MBIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MBCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MBBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MBInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SKPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SKIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SKCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SKBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SKInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BCPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BCIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BCCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BCBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BCInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'YTPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'YTIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NUPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NUIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NTPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NTIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NSFPerAllc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NFFPerAllc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TTPerAlloc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TTIncTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TTCapTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TTBalDueRf'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TTInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABDonatns'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABNonCapLs'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABGrsCapLs'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABFarmLoss'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONDonatns'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONNonCapLs'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONGrsCapLs'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ONFarmLoss'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCDonatns'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCNonCapLs'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCGrsCapLs'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCFarmLoss'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GroupName'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TBVersion'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CompltDate'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FileCrDate'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FileSvDate'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Password'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PrepName'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TypeofCorp'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'YearEndDat'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'YearStDat'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DetFiscalP'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'JurisSrch'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DedClaimed'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TypesofInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ForeignAff'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClassCCA1'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClassCCA2'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NonCapLDon'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FedTaxInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'OntTaxInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QCTaxInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ABTaxInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TypeTaxPd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DivRecPd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ReducPartI'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FedPrTaxRd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CapTaxPay'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CarryFwd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CarryBack'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EDICT23'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LrgCorpQC'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EDIDskDt'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TotTime'
          Visible = True
        end>
    end
  end
  object Panel6: TPanel
    Left = 336
    Top = 112
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
  object DataSource1: TDataSource
    DataSet = ClientsQ
    Left = 96
    Top = 272
  end
  object ClientsQ: TADQuery
    SQL.Strings = (
      'select * from clients')
    Left = 216
    Top = 264
  end
end
