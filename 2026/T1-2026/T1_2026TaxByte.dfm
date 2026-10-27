object TaxbyteT1_2026: TTaxbyteT1_2026
  Left = 21
  Top = 70
  Caption = 'TaxbyteT1_2026'
  ClientHeight = 1
  ClientWidth = 127
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
          Top = -8
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
            object DBText1: TDBText
              Left = 72
              Top = 16
              Width = 193
              Height = 17
              DataField = 'LastName'
              DataSource = DataSource1
            end
            object DBText2: TDBText
              Left = 72
              Top = 32
              Width = 193
              Height = 17
              DataField = 'FirstName'
              DataSource = DataSource1
            end
            object DBText3: TDBText
              Left = 72
              Top = 56
              Width = 193
              Height = 17
              DataField = 'FileName'
              DataSource = DataSource1
            end
            object DBText4: TDBText
              Left = 72
              Top = 72
              Width = 193
              Height = 17
              DataField = 'SIN'
              DataSource = DataSource1
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
            object DBText5: TDBText
              Left = 72
              Top = 16
              Width = 193
              Height = 17
              DataField = 'Address'
              DataSource = DataSource1
            end
            object DBText6: TDBText
              Left = 72
              Top = 48
              Width = 193
              Height = 17
              DataField = 'City'
              DataSource = DataSource1
            end
            object DBText7: TDBText
              Left = 72
              Top = 64
              Width = 193
              Height = 17
              DataField = 'Prov'
              DataSource = DataSource1
            end
            object DBText8: TDBText
              Left = 72
              Top = 80
              Width = 193
              Height = 17
              DataField = 'PCode'
              DataSource = DataSource1
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
            object DBText9: TDBText
              Left = 72
              Top = 26
              Width = 193
              Height = 17
              DataField = 'Phone'
              DataSource = DataSource1
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
          FieldName = 'LastName'
          Width = 96
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FirstName'
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
          FieldName = 'SIN'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EFileStat'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IsCustStat'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DocCtrlNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Salutation'
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
          FieldName = 'State'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PCode'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ZipCode'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Phone'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DOB'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ProvRes'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MaritalSt'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TaxRPrepNm'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ClientNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ReturnType'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TypeOfInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TypeOfDed'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NonRefTxCr'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DetOfDeps'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TypeTaxCr'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GSTCrdDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ChTaxBDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MinTaxApp'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CarryFAmts'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CarryBAmts'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ForeignPrp'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TotalInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'AmtNetInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'AmtTaxInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'AmtTotTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FedTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ProvTax'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BalDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'QInstDue'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RRSPUnDed'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RRSPLimit'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RRSPRoom'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ChTaxBen'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GSTCredit'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RTUFileNam'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RTUSentDat'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'AcceptDate'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RejectDate'
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
          FieldName = 'T1CertDate'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FamStatus'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FamFileNm'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InvoiceNum'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InvoiceAmt'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SpouseNm'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SpouseSIN'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InvoicePd'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Password'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SelfEmpInc'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TotTime'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UntutEdu'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UnDon'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NonCapLCF'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NetCapLCF'
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
    Left = 168
    Top = 272
  end
end
