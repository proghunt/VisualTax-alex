object frmTaxCycleUtil: TfrmTaxCycleUtil
  Left = 0
  Top = 0
  Caption = 'TaxCycle'
  ClientHeight = 747
  ClientWidth = 829
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 600
    Width = 829
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 8
    ExplicitTop = 205
    ExplicitWidth = 635
  end
  object pnlTree: TPanel
    Left = 0
    Top = 603
    Width = 829
    Height = 144
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 627
    object Splitter2: TSplitter
      Left = 640
      Top = 25
      Height = 118
      Align = alRight
      ExplicitLeft = 328
      ExplicitTop = 192
      ExplicitHeight = 100
    end
    object TreeView1: TTreeView
      Left = 1
      Top = 25
      Width = 639
      Height = 118
      Align = alClient
      HideSelection = False
      Images = ImageList1
      Indent = 19
      PopupMenu = pmNode
      ReadOnly = True
      RightClickSelect = True
      StateImages = ImageList1
      TabOrder = 0
      OnChange = TreeView1Change
      OnChanging = TreeView1Changing
    end
    object mmoNodeData: TMemo
      Left = 643
      Top = 25
      Width = 185
      Height = 118
      Align = alRight
      TabOrder = 1
    end
    object pnlSearch: TPanel
      Left = 1
      Top = 1
      Width = 827
      Height = 24
      Align = alTop
      TabOrder = 2
      object btnSearchNext: TSpeedButton
        Left = 393
        Top = 1
        Width = 23
        Height = 22
        Align = alLeft
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000003300000033FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0000000033008B4BFF008B4BFF0000
          0033FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF0000000033008848FF00C382FF00C382FF0088
          48FF00000033FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF0000000033008847FF00BD7EFF00DD9FFF00DD9FFF00BD
          7EFF008847FF00000033FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00008C4BFF53D8B0FF53EAC4FF00D59CFF00D59CFF53EA
          C4FF53D8B0FF008C4BFFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00006C3BC5008846FF00B97EFF00D39DFF00D39EFF00B9
          7EFF008847FF006C3BC5FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008644FF1BD9ACFF00D4A1FF0086
          44FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008846FF2ADBB4FF00D1A2FF0088
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008845FF3ADBBBFF00CEA3FF0089
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008845FF49DCC1FF00CAA2FF0089
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008844FF58DDC7FF00C7A2FF0089
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008844FF67E0CDFF00C3A1FF008A
          46FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008844FF76E1D3FF00BFA0FF008A
          46FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008844FF86E4DAFF00BBA1FF008A
          46FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008A46FF98EAE6FF67DCD4FF008A
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00006134B0008A47FF008A47FF0061
          34B0FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        OnClick = btnSearchNextClick
        ExplicitLeft = 424
        ExplicitTop = 8
      end
      object btnSearchPrior: TSpeedButton
        Left = 416
        Top = 1
        Width = 23
        Height = 22
        Align = alLeft
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF000000002200000033000000330000
          0022FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00005E33BC008A4AFF008A4AFF005E
          33BCFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008949FF00E7A7FF00E7A7FF0089
          49FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008847FF08E2A6FF00E0A2FF0088
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008747FF16E0ACFF00DCA2FF0088
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008746FF23E0B2FF00D9A2FF0088
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008846FF30DFB7FF00D5A2FF0088
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008845FF3EDFBDFF00D2A1FF0089
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008845FF4BE0C1FF00CFA1FF0089
          47FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008844FF59E1C8FF00CBA2FF0089
          46FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF000000002600000033008742FF6AE2CCFF00C9A1FF0087
          44FF0000003300000026FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00006A39CD008946FF00AE7FFF00C39EFF00C39EFF00AE
          80FF008946FF006A39CDFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00008C4AFF82DCCAFF00C1A0FF00BE9BFF00BE9BFF00C1
          A0FF83DCCAFF008C4AFFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00008844FF8EDBCBFF00B99DFF00B99DFF8EDB
          CBFF008844FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00008742FF9AE0D3FF9AE0D3FF0087
          42FFFF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00008A47FF008A47FFFF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        OnClick = btnSearchPriorClick
        ExplicitLeft = 464
        ExplicitTop = 8
      end
      object edtSearch: TEdit
        Left = 1
        Top = 1
        Width = 392
        Height = 22
        Align = alLeft
        TabOrder = 0
        ExplicitHeight = 21
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 78
    Width = 829
    Height = 522
    Align = alClient
    Caption = 'Panel3'
    TabOrder = 1
    ExplicitHeight = 546
    DesignSize = (
      829
      522)
    object Label6: TLabel
      Left = 16
      Top = 90
      Width = 190
      Height = 14
      Caption = 'TaxCycle last year'#39's data directory:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 224
      Top = 90
      Width = 243
      Height = 14
      Caption = 'To avoid constant '#39'Select '#39' enter the data folder in: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object LinkToOptionsLbl: TLabel
      Left = 473
      Top = 90
      Width = 218
      Height = 14
      Cursor = crHandPoint
      Caption = 'Configure | General Options | Data Directories'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsUnderline]
      ParentFont = False
      Transparent = True
      OnClick = LinkToOptionsLblClick
    end
    object btnSelectVTDir: TSpeedButton
      Left = 652
      Top = 148
      Width = 63
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Select...'
      OnClick = btnSelectTaxCycleDirClick
      ExplicitLeft = 655
    end
    object Label9: TLabel
      Left = 16
      Top = 132
      Width = 151
      Height = 14
      Caption = 'VisualTax Current directory'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnSelectTaxCycleDir: TSpeedButton
      Left = 584
      Top = 105
      Width = 63
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Select...'
      OnClick = btnSelectTaxCycleDirClick
      ExplicitLeft = 587
    end
    object pnlToolsDeveloper: TPanel
      Left = 714
      Top = 1
      Width = 114
      Height = 520
      Align = alRight
      TabOrder = 0
      Visible = False
      ExplicitHeight = 544
      object btnReadCurrent: TButton
        Left = 7
        Top = 80
        Width = 102
        Height = 47
        Caption = 'Read Current TaxCycle file'
        TabOrder = 0
        WordWrap = True
        OnClick = btnReadCurrentClick
      end
      object btnMappingMode: TButton
        Left = 7
        Top = 291
        Width = 102
        Height = 25
        Caption = 'Mapping mode'
        TabOrder = 1
        OnClick = btnMappingModeClick
      end
      object btnConvert: TButton
        Left = 7
        Top = 239
        Width = 102
        Height = 44
        Caption = 'Convert To VisualTax return(s)'
        TabOrder = 2
        WordWrap = True
        OnClick = btnConvertClick
      end
      object btnReadSelected: TButton
        Left = 7
        Top = 133
        Width = 101
        Height = 47
        Caption = 'Read Selected TaxCycle file(s)'
        TabOrder = 3
        WordWrap = True
        OnClick = btnReadCurrentClick
      end
      object btnReadAll: TButton
        Left = 7
        Top = 186
        Width = 102
        Height = 47
        Caption = 'Read All TaxCycle file(s)'
        TabOrder = 4
        WordWrap = True
        OnClick = btnReadCurrentClick
      end
      object btnGenerateDFile: TButton
        Left = 7
        Top = 322
        Width = 102
        Height = 25
        Caption = 'Generate .d file'
        TabOrder = 5
        OnClick = btnGenerateDFileClick
      end
    end
    object PageControl1: TPageControl
      Left = 19
      Top = 183
      Width = 699
      Height = 475
      ActivePage = TabSheet1
      TabOrder = 1
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 691
          Height = 447
          Align = alClient
          TabOrder = 0
          DesignSize = (
            691
            447)
          object Label7: TLabel
            Left = 12
            Top = 13
            Width = 25
            Height = 13
            Caption = 'Files:'
          end
          object Label18: TLabel
            Left = 434
            Top = 140
            Width = 87
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Not saved returns'
          end
          object Label20: TLabel
            Left = 48
            Top = 12
            Width = 516
            Height = 14
            Caption = 
              'Select files for '#39'Open'#39' or '#39'Batch mode Rollover and Save to file' +
              #39'  (For multiple selection Press Shift and Click)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object flbMain: TFileListBox
            Left = 12
            Top = 32
            Width = 389
            Height = 277
            Anchors = [akLeft, akTop, akRight, akBottom]
            FileType = [ftReadOnly, ftHidden, ftSystem, ftVolumeID, ftArchive, ftNormal]
            ItemHeight = 13
            Mask = '*.2016T1'
            MultiSelect = True
            TabOrder = 0
          end
          object btnRolloverSelected: TButton
            Left = 434
            Top = 29
            Width = 249
            Height = 27
            Anchors = [akTop, akRight]
            Caption = 'RollOver Selected TaxCycle file(s)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            WordWrap = True
            OnClick = btnReadCurrentClick
          end
          object GroupBox1: TGroupBox
            Left = 434
            Top = 62
            Width = 249
            Height = 72
            Anchors = [akTop, akRight]
            Caption = 'Status'
            TabOrder = 2
            object lblCurrOfTotal: TLabel
              Left = 62
              Top = 35
              Width = 28
              Height = 13
              Caption = '0 of 0'
            end
            object lblStage: TLabel
              Left = 16
              Top = 16
              Width = 32
              Height = 13
              Caption = 'Stage:'
            end
            object lblStageName: TLabel
              Left = 64
              Top = 16
              Width = 24
              Height = 13
              Caption = 'none'
            end
            object Label17: TLabel
              Left = 16
              Top = 35
              Width = 20
              Height = 13
              Caption = 'File:'
            end
            object Label16: TLabel
              Left = 16
              Top = 51
              Width = 42
              Height = 13
              Caption = 'Element:'
            end
            object lblElement: TLabel
              Left = 62
              Top = 51
              Width = 12
              Height = 13
              Caption = '...'
            end
          end
          object lbNotSavedReturns: TListBox
            Left = 434
            Top = 154
            Width = 249
            Height = 155
            Anchors = [akTop, akRight, akBottom]
            ItemHeight = 13
            TabOrder = 3
            OnDblClick = lbNotSavedReturnsDblClick
          end
        end
      end
      object tsMap: TTabSheet
        Caption = 'tsMap'
        ImageIndex = 1
        DesignSize = (
          691
          447)
        object Label1: TLabel
          Left = 3
          Top = 3
          Width = 44
          Height = 13
          Caption = 'TaxCycle'
        end
        object Label2: TLabel
          Left = 3
          Top = 30
          Width = 49
          Height = 13
          Caption = 'VisualTax:'
        end
        object Label3: TLabel
          Left = 3
          Top = 139
          Width = 53
          Height = 13
          Caption = 'Transform:'
        end
        object Label4: TLabel
          Left = 58
          Top = 30
          Width = 53
          Height = 13
          Caption = 'Form name'
        end
        object Label5: TLabel
          Left = 375
          Top = 30
          Width = 54
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Element No'
        end
        object imgSlip: TImage
          Left = 578
          Top = 3
          Width = 16
          Height = 16
          Hint = 
            'This is element from slips form. Please, link only "Form#1" to "' +
            'Form#1". All other slip forms will be created automatically.'
          Anchors = [akTop, akRight]
          ParentShowHint = False
          Picture.Data = {
            055449636F6E0000010001001010000001002000680400001600000028000000
            1000000020000000010020000000000000040000000000000000000000000000
            0000000000000000000000000000000000000000000000000000002400000033
            0000003300000033000000330000003300000033000000330000003300000033
            000000240000002400000033000000330000003300000033297FD3C13787D6FF
            3985D2FF3985D2FF3985D2FF3986D3FF3985D2FF3985D2FF3985D2FF3A87D3FF
            367FC4C1AA783CC1B98546FFB88546FFB98444FFC28339FF3087DBFF42D5FFFF
            48DBFFFF48DAFFFF48DBFFFF47DDFFFF48DBFFFF48DAFFFF49DBFFFF48D6FFFF
            3A89D4FFB88446FFEDB25AFFC79049FFEBB05CFFEFAB4EFFB79E76FF3198E9FF
            50DEFFFF51D9FFFF50DCFFFF704638FF50DCFFFF51D9FFFF54DEFFFF3F9ADEFF
            3A89D445B78445FFEBB260FFC48D48FFEAB364FFE7A850FFF2A947FF588BBBFF
            4AC5FBFF5DE0FFFF5CE1FFFF5BE5FFFF5CE1FFFF5EE1FFFF53C6F4FF3986D3CF
            3B8BD500B78345FFECB666FFC48C46FFEAB76EFFE4A752FFE9A84EFFDBA557FF
            3588D8FF62E3FFFF67EBFFFF6B483FFF68EBFFFF67E3FFFF3A89D5FF3A89D40A
            3B8CD600B78344FFEDB86AFFC38C45FFEBBC77FFE3A751FFE5A851FFEDA84BFF
            9A9788FF45B1F4FF74F6FFFF694D44FF76F6FFFF4FB4EDFF3687D66A398BD800
            398CD800B78344FFEEBD72FFC38C45FFECC183FFE3A853FFE3A854FFE6A951FF
            F2A946FF5589B8FF6CE6FFFF684C42FF70E8FFFF5683AEFF2D8AE3002F8CE300
            308CE300B78243FFF0C37EFFC38C45FFEFC98FFFE3AB56FFE2A952FFE3A84FFF
            E9A84AFFCBA05EFF3194E6FF87FFFFFF359AECFFAD8350FFAB875800AB885900
            AB885900B68242FFF2C889FFC38C47FFF1D09CFFE3AB57FFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFF98C8FBFF329DEDFF91ACBCFFC28237FFC0864100BF874200
            BF874200B68141FFF3CE93FFC38E48FFF2D7A8FFE3AF5BFFE1AA52FFE0A74CFF
            E0A74BFFE4A84BFFEAAD4FFFEFB254FFFDDAA5FFB9813DFFBB864500BB874700
            BB874700B68140FFF4D49DFFC48E48FFF4DCB3FFE4B05EFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFE6B25EFFF8DFB5FFB67F3EFFBA864500BB874700
            BB874700B6813FFFF5D9A7FFC38E49FFF7E1BEFFE5B564FFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFE5B564FFF9E4C1FFB57F3DFFBA854500BB874700
            BB874700B6813FFFF7DFB1FFC48F4BFFF8E9CBFFE5BA6EFFE4B86AFFE4B767FF
            E4B667FFE4B767FFE4B86AFFE6BA6EFFFAECCDFFB57F3CFFBA854500BB874700
            BB874700B88241FFFCE8C0FFC69552FFFDF0D6FFFBEED3FFFBEDD2FFFBEDD2FF
            FBEDD2FFFBEDD2FFFBEDD2FFFCEED3FFFFF2D8FFB7813EFFBB864500BB874700
            BB874700B88241B2B88241FFB78240FFB67F3DFFB57E3CFFB57E3BFFB57E3BFF
            B57E3BFFB57E3BFFB57E3BFFB57E3CFFB7803EFFB88241B2BB874700BB874700
            BB874700F8000000000000000000000000000000000100000001000000030000
            0007000000070000000700000007000000070000000700000007000000070000
            00070000}
          ShowHint = True
          Visible = False
        end
        object lblNumberOfForms: TLabel
          Left = 357
          Top = 55
          Width = 159
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Number of forms in one multiform'
          ExplicitLeft = 363
        end
        object lblShift: TLabel
          Left = 490
          Top = 30
          Width = 22
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Shift'
        end
        object imgTableRow: TImage
          Left = 602
          Top = 3
          Width = 16
          Height = 16
          Hint = 
            'This is element from Table. Please, link only "Table row #1" to ' +
            '"Rable row #1". All other rows will be created automatically.'
          Anchors = [akTop, akRight]
          ParentShowHint = False
          Picture.Data = {
            055449636F6E0000010001001010000001002000680400001600000028000000
            1000000020000000010020000000000000040000000000000000000000000000
            0000000000000000000000000000000000000000000000000000003300000033
            0000003300000033000000330000003300000033000000330000003300000033
            000000330000003000000033000000330000003300000033147CD7FF217AC6FF
            2378C2FF2277C1FF2278C2FF2278C2FF2278C2FF2277C1FF2378C2FF247BC3FF
            257EC5FFB78219F2B67E0EFFB47B09FFB67A06FFC17C00FF1773C1FF42D2FFFF
            4BDDFFFF4BDBFFFF4ADDFFFF4ADFFFFF4ADDFFFF4BDBFFFF4CDDFFFF4AD5FFFF
            247CC4FFB67E0EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7E0F9FF1D88D1FF
            52DDFFFF52DAFFFF50DCFFFF714638FF50DCFFFF52DAFFFF54DFFFFF2B91D6FF
            227CC842B47B09FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8C5A4FF4C94D2FF
            42BDF0FF5EE0FFFF5CE1FFFF5BE5FFFF5CE1FFFF5EE1FFFF46C2F7FF487A97FF
            00000000B47A08FFFFFFFFFFFFFFFDFFFFFFFDFFFFFFFFFFE0C2A2FFFAFBFDFF
            1F7DC7FF62E2FFFF68EBFFFF6B483FFF68EBFFFF63E2FFFF2383D4FFB78119FF
            00000000B47B08FFFFFFFFFFD4B999FFD5BA9AFFD7BD9EFFDAC0A1FFE3C29EFF
            879CACFF36A6E2FF75F6FFFF694D44FF74F5FFFF35A5E1FFA6CFFBFFC28107FF
            00000000B47B08FFFFFFFFFFFFFDF2FFFFFEF3FFFFFFF7FFD7BB9AFFFFFFF7FF
            FFFFF4FF3F81B7FF6BE4FFFF694D42FF69E2FFFF4990CDFFFFFFFFFFB97D09FF
            00000000B47B08FFFFFFFFFFFFFBEBFFFFFCECFFFFFFF0FFD7BA96FFFFFFF1FF
            FFFFF0FFC1B19EFF1E89D5FF8AFFFFFF1C86D2FFE5E7E4FFFFFFFFFFB57C08FF
            00000000B47B08FFFFFFFFFFD4B38CFFD5B58FFFD7B892FFD8BA95FFD7B893FF
            DAB992FFE4BE94FF7595ACFF1E8FD9FF7595ABFFE2BA8DFFFFFFFFFFB57B08FF
            00000000B47B08FFFFFFFFFFFFF7DFFFFFF8E1FFFFFBE5FFD6B78FFFFFFBE6FF
            FFFBE6FFD9B98EFFFFFEE4FFFFFFE2FFDFBA8CFFFFFBE2FFFFFFFFFFB47B08FF
            00000000B47B08FFFFFFFFFFFFF5D7FFFFF6D9FFFFF9DEFFD7B58BFFFFF9DFFF
            FFF9DFFFD8B68BFFFFFADEFFFFFADEFFD8B589FFFFF8DBFFFFFFFFFFB47B08FF
            00000000B57B09FFFFFFFFFFDDB17CFFE0B47EFFE0B682FFDEB786FFDFB683FF
            DFB683FFDEB786FFDFB683FFDFB683FFDDB684FFDBB37FFFFFFFFFFFB57B09FF
            00000000B57C09FFFFFFFFFF44C3FFFF49C5FFFF47C6FFFFE3B57EFF46C7FFFF
            46C7FFFFE3B57EFF46C7FFFF46C7FFFFE1B47EFF40C4FFFFFFFFFFFFB57C09FF
            00000000B67E0EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB67E0EFF
            00000000B98419EFB67E0EFFB67C09FFB67B07FFB67B08FFB57B08FFB67B08FF
            B67B08FFB57B08FFB67B08FFB67B08FFB57B08FFB67C09FFB67E0EFFB98419EF
            00000000F8000000000000000000000000000000000100000001000000010000
            0001000000010000000100000001000000010000000100000001000000010000
            00010000}
          ShowHint = True
          Visible = False
        end
        object btnDynTarget: TSpeedButton
          Left = 671
          Top = 27
          Width = 20
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          OnClick = btnDynTargetClick
        end
        object edTaxCyclePath: TEdit
          Left = 53
          Top = 3
          Width = 516
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 0
          OnChange = edTaxCyclePathChange
        end
        object edVisualTaxFormName: TEdit
          Left = 117
          Top = 27
          Width = 252
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnChange = edTaxCyclePathChange
        end
        object veTransform: TValueListEditor
          Left = 62
          Top = 143
          Width = 619
          Height = 163
          Anchors = [akLeft, akTop, akRight, akBottom]
          KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
          TabOrder = 2
          TitleCaptions.Strings = (
            'TaxCycle Value / MidStr for split (<Start>:<Count>)'
            'VisualTax Value / Element No')
          OnValidate = veTransformValidate
          ColWidths = (
            266
            347)
        end
        object rgValue: TRadioGroup
          Left = 3
          Top = 69
          Width = 678
          Height = 68
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Value:'
          Columns = 4
          Items.Strings = (
            'As is '
            'As dollar'
            'Yes Or Not (0='#39'N'#39', 1 = '#39'Y'#39')'
            'Check (0='#39#39', 1 = '#39'X'#39')'
            'RadioGroup (Ex. MaritalStatus)'
            'Date'
            'Transform (0=ON,1=AB...)'
            'Split (Ex. Phone)'
            'As Percent (Multiplied by 100)'
            'Cumulative (Dollars)'
            'Concate (Strings)')
          TabOrder = 3
          OnClick = edTaxCyclePathChange
        end
        object edVisualTaxElementNo: TSpinEdit
          Left = 435
          Top = 27
          Width = 51
          Height = 22
          Anchors = [akTop, akRight]
          MaxValue = 999999999
          MinValue = 0
          TabOrder = 4
          Value = 0
          OnChange = edTaxCyclePathChange
        end
        object btnSaveMapElement: TButton
          Left = 3
          Top = 423
          Width = 678
          Height = 24
          Anchors = [akLeft, akRight, akBottom]
          Caption = 'Apply'
          TabOrder = 5
          OnClick = btnSaveMapElementClick
        end
        object btnFillProvince: TButton
          Left = 3
          Top = 160
          Width = 53
          Height = 31
          Caption = '(Ontario -> ON)'
          TabOrder = 6
          WordWrap = True
          OnClick = btnFillProvinceClick
        end
        object btnPhone: TButton
          Left = 3
          Top = 249
          Width = 53
          Height = 25
          Caption = 'Phone'
          TabOrder = 7
          OnClick = btnPhoneClick
        end
        object chbSlipToMuliSlip: TCheckBox
          Left = 3
          Top = 54
          Width = 346
          Height = 17
          Caption = 'Slip to Multi (ex. T5#1-5 to T5MULT#1, T5#6-10 to T5MULT#2, ...)'
          TabOrder = 8
          OnClick = edTaxCyclePathChange
        end
        object edtNumberOfForms: TSpinEdit
          Left = 518
          Top = 52
          Width = 51
          Height = 22
          Anchors = [akTop, akRight]
          MaxValue = 99
          MinValue = 1
          TabOrder = 9
          Value = 5
          OnChange = edTaxCyclePathChange
        end
        object edtShift: TSpinEdit
          Left = 518
          Top = 27
          Width = 51
          Height = 22
          Anchors = [akTop, akRight]
          MaxValue = 999999999
          MinValue = 0
          TabOrder = 10
          Value = 0
          OnChange = edTaxCyclePathChange
        end
        object chbUseDynTarget: TCheckBox
          Left = 575
          Top = 30
          Width = 96
          Height = 17
          Anchors = [akTop, akRight]
          Caption = 'Use Dyn. target'
          TabOrder = 11
          OnClick = chbUseDynTargetClick
        end
        object chAutolink: TCheckBox
          Left = 631
          Top = 2
          Width = 60
          Height = 17
          Anchors = [akTop, akRight]
          Caption = 'Autolink'
          TabOrder = 12
        end
        object chbSkipLastRow: TCheckBox
          Left = 575
          Top = 53
          Width = 97
          Height = 17
          Anchors = [akTop, akRight]
          Caption = 'Skip last row'
          TabOrder = 13
          OnClick = edTaxCyclePathChange
        end
        object btnFillProvince2: TButton
          Left = 3
          Top = 191
          Width = 53
          Height = 30
          Caption = '(9 -> Ontario)'
          TabOrder = 14
          WordWrap = True
          OnClick = btnFillProvinceClick
        end
        object btnFillProvince3: TButton
          Left = 3
          Top = 221
          Width = 53
          Height = 22
          Caption = '(9 -> ON)'
          TabOrder = 15
          WordWrap = True
          OnClick = btnFillProvinceClick
        end
      end
      object tsDynTarget: TTabSheet
        Caption = 'tsDynTarget'
        ImageIndex = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 691
          Height = 406
          Align = alClient
          TabOrder = 0
          object lvDynTarget: TListView
            Left = 1
            Top = 1
            Width = 689
            Height = 183
            Align = alClient
            Columns = <
              item
                Caption = 'TC From row #'
                Width = 100
              end
              item
                Caption = 'VT FormName'
                Width = 200
              end
              item
                Caption = 'VT From Element #'
                Width = 120
              end
              item
                Caption = 'Shift'
                Width = 60
              end>
            GridLines = True
            TabOrder = 0
            ViewStyle = vsReport
            OnChange = lvDynTargetChange
            OnSelectItem = lvDynTargetSelectItem
            ExplicitHeight = 176
          end
          object Panel5: TPanel
            Left = 1
            Top = 184
            Width = 689
            Height = 221
            Align = alBottom
            TabOrder = 1
            object Label10: TLabel
              Left = 24
              Top = 9
              Width = 73
              Height = 13
              Caption = 'TC from Row #'
            end
            object Label11: TLabel
              Left = 24
              Top = 35
              Width = 68
              Height = 13
              Caption = 'VT Form name'
            end
            object Label12: TLabel
              Left = 24
              Top = 62
              Width = 91
              Height = 13
              Caption = 'VT From Element #'
            end
            object Label13: TLabel
              Left = 24
              Top = 88
              Width = 37
              Height = 13
              Caption = 'VT Shift'
            end
            object btnDynMapAdd: TSpeedButton
              Left = 517
              Top = 6
              Width = 110
              Height = 22
              Caption = 'Add'
              OnClick = btnDynMapAddClick
            end
            object btnDynMapApply: TSpeedButton
              Left = 517
              Top = 34
              Width = 110
              Height = 22
              Caption = 'Apply'
              OnClick = btnDynMapApplyClick
            end
            object btnDynMapDelete: TSpeedButton
              Left = 517
              Top = 62
              Width = 110
              Height = 22
              Caption = 'Delete'
              OnClick = btnDynMapDeleteClick
            end
            object Label14: TLabel
              Left = 351
              Top = 35
              Width = 141
              Height = 13
              Caption = 'enter "*" for use current forn'
            end
            object Label15: TLabel
              Left = 183
              Top = 6
              Width = 105
              Height = 13
              Caption = 'enter "-1" for last row'
            end
            object edTCFromRowNo: TSpinEdit
              Left = 120
              Top = 6
              Width = 57
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 0
              Value = 0
            end
            object edvtFormName: TEdit
              Left = 120
              Top = 32
              Width = 222
              Height = 21
              TabOrder = 1
              Text = '*'
            end
            object edVTFromElementNo: TSpinEdit
              Left = 120
              Top = 59
              Width = 57
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 2
              Value = 0
            end
            object edVTShift: TSpinEdit
              Left = 120
              Top = 87
              Width = 57
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 3
              Value = 0
            end
            object BitBtn3: TBitBtn
              Left = 517
              Top = 95
              Width = 52
              Height = 25
              Caption = 'Copy'
              TabOrder = 4
              OnClick = BitBtn3Click
            end
            object BitBtn4: TBitBtn
              Left = 575
              Top = 95
              Width = 52
              Height = 25
              Caption = 'Paste'
              TabOrder = 5
              OnClick = BitBtn4Click
            end
          end
        end
        object Panel4: TPanel
          Left = 0
          Top = 406
          Width = 691
          Height = 41
          Align = alBottom
          TabOrder = 1
          object BitBtn1: TBitBtn
            Left = 527
            Top = 6
            Width = 75
            Height = 25
            Caption = 'Ok'
            TabOrder = 0
            OnClick = BitBtn1Click
          end
          object BitBtn2: TBitBtn
            Left = 608
            Top = 6
            Width = 75
            Height = 25
            Caption = 'Cancel'
            TabOrder = 1
            OnClick = BitBtn2Click
          end
        end
      end
    end
    object SaveOrOpenOptionBox: TRadioGroup
      Left = 16
      Top = 20
      Width = 412
      Height = 57
      Anchors = [akTop, akRight]
      Caption = 'Roll-Over Options'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = -1
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        'Open Return(s) and optionally save them (up to 10)'
        
          'Rollover and Save to Data Folder (Unlimited returns in Batch Mod' +
          'e)')
      ParentColor = False
      ParentFont = False
      TabOrder = 2
    end
    object ReplaceOptionBox: TRadioGroup
      Left = 434
      Top = 18
      Width = 281
      Height = 39
      Anchors = [akTop, akRight]
      Caption = 'Replace already existing return(s) in VisualTax'
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ItemIndex = 1
      Items.Strings = (
        'Yes'
        'No')
      ParentFont = False
      TabOrder = 3
    end
    object edtSourcePath: TEdit
      Left = 13
      Top = 105
      Width = 551
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      OnChange = edtSourcePathChange
    end
    object cbFileExt: TComboBox
      Left = 653
      Top = 105
      Width = 63
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 5
      OnChange = cbFileExtChange
    end
    object edtTargetPath: TEdit
      Left = 13
      Top = 147
      Width = 620
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 6
      OnChange = edtSourcePathChange
    end
    object cbDeveloperMode: TCheckBox
      Left = 618
      Top = 63
      Width = 97
      Height = 17
      Caption = 'Developer mode'
      TabOrder = 7
      OnClick = cbDeveloperModeClick
    end
  end
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 829
    Height = 78
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.StartColor = 9733176
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
      '  '
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
    TabOrder = 2
    ColorPaletteIndex = 13
    object Label19: TLabel
      Left = 177
      Top = 22
      Width = 412
      Height = 26
      Caption = 'Roll-over TaxCycle returns to VisualTax'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object Label21: TLabel
      Left = 177
      Top = 50
      Width = 412
      Height = 22
      Caption = 'Draft Version rolling into the redesigned VisualTax'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object ImageList1: TImageList
    Left = 128
    Top = 404
    Bitmap = {
      494C01010F0014012C0110001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000002300000033000000330000
      0033000000330000003300000033000000330000003300000033000000330000
      0033000000330000003300000033000000230000000000000000000000000000
      0000000000000000000000000000000000330000003300000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000022000000330000003300000022000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000805B11C0B67E0EFFB47B09FFB47A
      07FFB47A08FFB47B08FFB47A08FFB47A08FFB47B08FFB47A08FFB47A08FFB47B
      08FFB47A08FFB47B09FFB67E0EFF805B11C00000000000000000000000000000
      0000000000000000000000000033008B4BFF008B4BFF00000033000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000005E33BC008A4AFF008A4AFF005E33BC000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B67E0EFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB67E0EFF0000000000000000000000000000
      00000000000000000033008848FF00C382FF00C382FF008848FF000000330000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008949FF00E7A7FF00E7A7FF008949FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B47B09FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFD5BCA1FFFFFFFFFFFFFFFFFFD5BCA1FFFFFFFFFFFFFFFFFFD5BC
      A1FFFFFFFFFFFFFFFFFFFFFFFFFFB47B09FF0000000000000000000000000000
      000000000033008847FF00BD7EFF00DD9FFF00DD9FFF00BD7EFF008847FF0000
      0033000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008847FF08E2A6FF00E0A2FF008847FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B47A07FFFFFFFFFFFFFFFCFFFFFF
      FBFFFFFFFFFFD7BEA0FFFFFFFFFFFFFFFFFFD7BEA0FFFFFFFFFFFFFFFFFFD7BE
      A0FFFFFFFFFFFFFFFDFFFFFFFFFFB47A07FF0000000000000000000000000000
      0000008C4BFF53D8B0FF53EAC4FF00D59CFF00D59CFF53EAC4FF53D8B0FF008C
      4BFF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008747FF16E0ACFF00DCA2FF008847FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B47B08FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFDAC5ABFFFFFFFFFFFFFFFFFFDAC5ABFFFFFFFFFFFFFFFFFFDAC5
      ABFFFFFFFFFFFFFFFFFFFFFFFFFFB47B08FF0000000000000000000000000000
      0000006C3BC5008846FF00B97EFF00D39DFF00D39EFF00B97EFF008847FF006C
      3BC5000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008746FF23E0B2FF00D9A2FF008847FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B57C0AFFFFFFFFFFAF5600FFB05A
      03FFB15B05FFB25D07FFB15B05FFB15B05FFB25D07FFB15B05FFB15B05FFB25D
      08FFB15B05FFAF5600FFFFFFFFFFB57C0AFF0000000000000000000000000000
      00000000000000000000008644FF1BD9ACFF00D4A1FF008644FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008846FF30DFB7FF00D5A2FF008847FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B57D0BFFFFFFFFFFB15B06FFEACF
      ADFFEACEACFFCDA371FFEACDABFFEACDABFFCDA371FFEACDABFFEACDABFFCEA4
      73FFEBD1AFFFB25C06FFFFFFFFFFB57D0BFF0000000000000000000000000000
      00000000000000000000008846FF2ADBB4FF00D1A2FF008847FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008845FF3EDFBDFF00D2A1FF008947FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B57D0BFFFFFFFFFFB15B06FFEACF
      ADFFEACEACFFCDA372FFEACEABFFEACEABFFCDA372FFEACEABFFEACEABFFCEA4
      73FFEBD1B0FFB25C06FFFFFFFFFFB57D0BFF0000000000000000000000000000
      00000000000000000000008845FF3ADBBBFF00CEA3FF008947FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008845FF4BE0C1FF00CFA1FF008947FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B57C0AFFFFFFFFFFAF5700FFB05B
      06FFB15C08FFB25E09FFB15C08FFB15C08FFB25E09FFB15C08FFB15C08FFB35E
      0AFFB25C08FFAF5700FFFFFFFFFFB57C0AFF0000000000000000000000000000
      00000000000000000000008845FF49DCC1FF00CAA2FF008947FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008844FF59E1C8FF00CBA2FF008946FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B47B09FFFFFFFFFFFFFCE6FFFFFE
      EAFFFFFFEFFFD9BE9AFFFFFFF0FFFFFFF0FFD9BE9AFFFFFFF0FFFFFFF0FFD9BE
      9AFFFFFFEEFFFFFCE7FFFFFFFFFFB47B09FF0000000000000000000000000000
      00000000000000000000008844FF58DDC7FF00C7A2FF008947FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000002600000033008742FF6AE2CCFF00C9A1FF008744FF000000330000
      0026000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B47B09FFFFFFFFFFFFF6D8FFFFF7
      DAFFFFFADFFFD8B78CFFFFFBE0FFFFFBE0FFD8B78CFFFFFBE0FFFFFBE0FFD8B7
      8CFFFFFADEFFFFF6D8FFFFFFFFFFB47B09FF0000000000000000000000000000
      00000000000000000000008844FF67E0CDFF00C3A1FF008A46FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000006A39CD008946FF00AE7FFF00C39EFF00C39EFF00AE80FF008946FF006A
      39CD000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B57B09FFFFFFFFFFDDB17CFFE0B4
      7EFFE0B682FFDEB786FFDFB683FFDFB683FFDEB786FFDFB683FFDFB683FFDEB7
      86FFDFB581FFDDB27CFFFFFFFFFFB57B09FF0000000000000000000000000000
      00000000000000000000008844FF76E1D3FF00BFA0FF008A46FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008C4AFF82DCCAFF00C1A0FF00BE9BFF00BE9BFF00C1A0FF83DCCAFF008C
      4AFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B57C09FFFFFFFFFF44C3FFFF49C5
      FFFF47C6FFFFE3B57EFF46C7FFFF46C7FFFFE3B57EFF46C7FFFF46C7FFFFE3B5
      7EFF46C6FFFF44C4FFFFFFFFFFFFB57C09FF0000000000000000000000000000
      00000000000000000000008844FF86E4DAFF00BBA1FF008A46FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008844FF8EDBCBFF00B99DFF00B99DFF8EDBCBFF008844FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B67E0EFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB67E0EFF0000000000000000000000000000
      00000000000000000000008A46FF98EAE6FF67DCD4FF008A47FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008742FF9AE0D3FF9AE0D3FF008742FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AD7B17EFB67E0EFFB67C09FFB67B
      07FFB67B08FFB57B08FFB67B08FFB67B08FFB57B08FFB67B08FFB67B08FFB57B
      08FFB67B08FFB67C09FFB67E0EFFAD7B17EF0000000000000000000000000000
      00000000000000000000006134B0008A47FF008A47FF006134B0000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008A47FF008A47FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000033000000330000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000002F0000003300000033000000330000003300000033000000330000
      0033000000330000003300000033000000300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000033008A49FF008A49FF0000
      0033000000000000000000000000000000000000000000000000000000000000
      0008868686EF8E8E8FFF8C8C8CFF8C8C8CFF8C8C8CFF8C8C8CFF8C8C8CFF8C8C
      8CFF8C8C8CFF8C8C8CFF8D8D8DFF888888F244300A00B8811600B77F1400B77F
      1300B7801400B8811500B8811500B8811500B8811500B8811500B7801400B77F
      1300B77F1400B881160044300A000000000071717100A2A2A200A0A0A000A0A0
      A000A0A0A0009F9F9F009F9F9F009F9F9F009F9F9F009F9F9F009F9F9F009F9F
      9F009F9F9F009F9F9F00A2A2A200717171000000000000000000000000000000
      000000000000000000000000000000000033008645FF00E2A5FF00E2A5FF0087
      46FF000000330000000000000000000000000000000000000000000000221818
      18558F8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF8D8D8DFFB8811600EFE1AA00EDDDA400EFE0
      A600F1E3AA00F2E6AD00F3E6AD00F3E7AE00F3E6AD00F2E6AD00F1E3AA00EFE0
      A600EDDDA400EFE1AA00B881160000000000A2A2A200FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A2000000000000000000000000000000
      0000000000000000000000000033008644FF00D7A3FF00D29DFF00D29DFF00D7
      A3FF008745FF0000003300000000000000000000000000000008626262BC9090
      90FF8C8C8CFF878787FF858585FF858585FF858585FF858585FF848484FF8383
      83FF828282FFB5B3B3FFFFFFFFFF8C8C8CFFB77F1400EDDCA200EBD59300E2C8
      8400A87423008743000088450000905000008845000087430000A8742300E2C8
      8400EBD59300EDDCA200B77F140000000000A0A0A000FFFFFF00ADADAD007676
      7600ACACAC00FFFFFF00FFFFFF00FEFEFE00FEFEFE00FEFEFE00FEFEFE00FDFD
      FD00FDFDFD00FDFDFE00FFFFFF009F9F9F000000000000000000000000000000
      00000000000000000000008947FF42EFC7FF00C89EFF42E9C0FF42EAC0FF00C9
      9EFF00CEA4FF008845FF00000033000000000000002F18181855909090FFF5F5
      F5FFF2F2F2FFF1F1F1FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFEEEEEEFFFFFF
      FFFFFFFFFFFF828282FFFFFFFFFF8C8C8CFFB7801400F0DBA300E6CD89008D4C
      00009C600D00D6B56D00F2DE9C0089460000F2DE9C00D6B56D009C600D008D4C
      0000E6CD8900F0DBA300B780140000000000A0A0A000FFFFFF0077777700E3E1
      E00077777700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FCFB
      FB00F9F8F800FAF9F900FFFFFF009F9F9F000000000000000000000000000000
      00000000000000000000008947FF5BF3D5FF5BF2D3FF00833FFF00833FFF5DF1
      D1FF00C19EFF00C5A3FF008743FF00000033868686EF8D8D8DFF888889FF8585
      85FF848484FF838383FF838383FF838383FF838383FF848484FF848484FFA4A5
      A5FFFFFFFFFF838484FFFFFFFFFF8D8D8DFFB7811400F3DEA700AE792900A36A
      1900F0D69100EBCF8900EED48E0086430000EED48E00EBCF8900F0D69100A36A
      1900AE792900F3DEA700B781140000000000A1A1A100FFFFFF0078787800E3E1
      E00079797900FFFFFF0047454200605E5C0074726F00656261004A484600FEFE
      FE00F8F9F900F7F7F700FFFFFF009F9F9F000000000000000000000000000000
      0000000000000000000000000000008947FF008947FF00000000000000000086
      41FF76F4DEFF00B59DFF73F5DFFF008946FF8D8D8DFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8283
      83FFFFFFFFFF848484FFFFFFFFFF8D8D8DFFB7811400F4DDA9008B4A0000A167
      1500C3974A00E9C98000EDCE860085430000EDCE8600E9C98000C3974A00A167
      15008B4A0000F4DDA900B781140000000000A1A1A100FFFFFF0078787800E3E1
      E0007A7A7A00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FDFDFC00F7F8F600FFFFFF009F9F9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008641FF8EF7ECFF8DF8EDFF008946FF8B8B8BFFFFFFFFFFFEFEFFFFFFFF
      FFFFFFFFFFFFFEFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFDFEFEFFFFFFFFFF8282
      82FFFFFFFFFF848585FFFFFFFFFF8D8D8DFFB6801400F2DAA700E9C67B00E9C6
      7C00E7C47A00E7C47900ECCA800086440000ECCA8000E7C47900E7C47A00E9C6
      7C00E9C67B00F2DAA700B680140000000000A1A1A100FFFFFF0078787800E3E1
      E0007A7A7A00FFFFFF00474544005B5958006B686600787573006E6B69005C5A
      570046444300F8F7F600FFFFFF009F9F9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008946FF008946FF000000008B8B8BFFFFFFFFFFFBFCFCFF563D
      21FFA88466FFA58061FFFDFFFFFF563D22FFA58061FFF9FAFBFFFEFEFEFF8283
      83FFFFFFFFFF858585FFFFFFFFFF8D8D8DFFB6801300F1D8A600E5BD6F00E5BE
      7100E6C07300EAC57800F0CC800089490000F0CC8000EAC57800E6C07300E5BE
      7100E5BD6F00F1D8A600B680130000000000A1A1A100FFFFFF0078787800E3E1
      E0007A7A7A00FFFFFE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FDFD
      FC00F7F8F700F2F2F100FFFFFF009F9F9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B8B8BFFFEFDFDFFF7F7F8FFFCFE
      FFFFFCFFFFFFF9FBFEFFFBFCFFFFFDFFFFFFF9FBFFFFF4F5F6FFFCFBFBFF8383
      83FFFFFFFFFF858585FFFFFFFFFF8D8D8DFFB6801300F2D7A700E4B86700E5B9
      6A00E8BE6F0083410000894900008D4E00008949000083410000E8BE6F00E5B9
      6A00E4B86700F2D7A700B680130000000000A1A1A100FFFFFF0078787800E3E1
      E0007A7A7A00FDFCFB004B4846006461600078767300686665004F4C4A00F7F5
      F400F1EFEE00EEECEB00FFFFFF009F9F9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008B8C8CFFFDFCFDFFF3F3F3FF5940
      25FFAA8667FFF6F8F9FF594025FFAB886AFFA68364FFF0F1F1FFFBFAFBFF8383
      83FFFFFFFFFF878787FFFFFFFFFF8F8F8FFFB6801300F3D8AB00E3B46200E3B6
      6500E5B96800EABF6E00F1C877008C4C0000F1C87700EABF6E00E5B96800E3B6
      6500E3B46200F3D8AB00B680130000000000A1A1A100FFFFFF0078787800E3E1
      E0007A7A7B00F9F9F800FBFCFB00FEFEFD00FDFDFD00FDFDFC00FBFBFA00F7F7
      F600F2F2F100ECECEB00FFFFFF009F9F9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8C8CFFFCFCFCFFECECECFFF2F4
      F6FFF1F4F6FFEFF1F3FFF1F3F4FFF2F5F7FFEFF1F3FFEAEBEBFFFAFAFAFF8484
      84FFFFFFFFFF8B8B8BFF8F8F8FFF898989EEB6801300F4DAAE00E3B05C00E3B2
      5F00E5B46200E9B968009B5F0B00995B07009B5F0B00E9B96700E4B36200E3B2
      5F00E3B05C00F4DAAE00B680130000000000A0A0A000FFFFFF0078787800E3E1
      E0007A7A7A00F6F5F400484544005B5958006B686600787673006E6C6A005E5B
      590049464500EDECEB00FFFFFF009F9F9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8C8CFFFDFCFCFFE8E7E8FF5A41
      26FFAB886AFFA88566FFEBEBEEFF5A4126FFA98565FFE6E5E6FFFBFBFBFF8585
      86FFFFFFFFFF8F8F8FFF0000000000000000B6801300F6DBB200E3AC5400E3AE
      5800E4B05A00DCA7510095570300F3C16B0095570200E9B55F00E4AF5A00E3AE
      5700E3AC5400F6DBB200B680130000000000A0A0A000FFFFFF00A3A2A2007878
      7800A5A4A400EDEDEC00EDEDEC00EEEEED00EEEEED00EDEEED00EEEEED00EEEE
      ED00ECECEB00E7E7E500FFFFFF009F9F9F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C8C8CFFFFFEFEFFE1DFDFFFE4E3
      E4FFE4E4E5FFE2E2E3FFE2E2E1FFE4E3E4FFE3E2E2FFE0DFDEFFFEFDFEFF8A8A
      8AFF8F8F8FFF646464AE0000000000000000B6801300F6DCB600E1A64B00E1A7
      4D00E2A94F00E6AD5300975801009453000097580100E6AD5300E2A84F00E1A7
      4D00E1A64B00F6DCB600B680130000000000A0A0A000FFFFFF00E6E4E300E8E7
      E500E6E5E400E4E2E100E3E2E100E3E2E100E3E2E100E3E2E100E3E2E100E3E2
      E100E2E1E000E1E0DF00FFFFFF00A0A0A0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008E8E8EFFFFFFFFFFF5F4F3FFF5F4
      F3FFF5F4F4FFF5F4F3FFF5F4F3FFF5F4F3FFF5F4F3FFF5F3F2FFFFFFFFFF8E8E
      8EFF00000000000000000000000000000000B7811500FAE1C000F7DEBB00F7DE
      BB00F7DEBC00F9E0BD00FCE3C000FDE4C100FCE3C000F9E0BD00F7DEBC00F7DE
      BB00F7DEBB00FAE1C000B781150000000000A2A2A200FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A2A2A2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000888888EF8E8E8EFF8C8C8DFF8C8C
      8CFF8C8C8CFF8C8C8CFF8C8C8CFF8C8C8CFF8C8C8CFF8C8C8DFF8E8E8EFF8888
      88EE0000000000000000000000000000000044310900B7811500B6801200B680
      1200B6801200B6801200B6811300B6811300B6811300B6801200B6801200B680
      1200B6801200B781150044310900000000009A9A9A00A2A2A200A0A0A0009F9F
      9F009F9F9F009F9F9F009F9F9F009F9F9F009F9F9F009F9F9F009F9F9F009F9F
      9F009F9F9F00A0A0A000A2A2A2009A9A9A000000000000000013000000330000
      0033000000330000003300000033000000330000003300000033000000330000
      0033000000330000003300000033000000130000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000152F4A7E397FC8FF387D
      C7FF387CC7FF387CC7FF387CC7FF387CC7FF387CC7FF387CC7FF387CC7FF387C
      C7FF387CC7FF387DC7FF397FC8FF152F4A7E44300A00B8811600B67F1300B67F
      1300B67F1300B67F1300B67F1300B67F1300B67F1300B67F1300B67F1300B67F
      1300B67F1300B881160044300A000000000000000000585553007A7773007673
      700076736F0076736F0076736F007673700076736F0094918F00A6A4A200A4A2
      A000A3A19E00A3A19F009A9896000000000044300A00B8811600B67F1300B67F
      1300B67F1300B67F1300B67F1300B67F1300B67F1300B67F1300B67F1300B67F
      1300B67F1300B881160044300A000000000000000000397FC8FF5EEAFFFF5DE5
      FFFF5DE3FFFF5DE3FFFF5DE3FFFF5DE3FFFF5DE3FFFF5DE3FFFF5DE3FFFF5DE3
      FFFF5DE3FFFF5DE5FFFF5EEAFFFF397FC8FFB8811600EFE1A900ECDCA200ECDC
      A200ECDCA200ECDCA200ECDCA200ECDCA200ECDCA200ECDCA200ECDCA200ECDC
      A200EDDDA300EFE1AA00B881160000000000000000007C797700FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C4C300C1BFBE00D4D3
      D100DFDEDE00FFFFFF00A7A5A30000000000B8811600EFE1A900ECDCA200ECDC
      A100ECDCA100ECDCA200EDDDA300EDDDA300EDDDA300ECDCA200ECDCA100ECDC
      A100ECDCA200EFE1A900B88116000000000000000000387DC7FF61E2FFFF4FD7
      FFFF50D6FFFF50D6FFFF50D6FFFF50D6FFFF50D6FFFF50D6FFFF50D6FFFF50D6
      FFFF50D6FFFF4FD7FFFF61E2FFFF387DC7FFB67F1400ECDBA100E8D08E00E8D0
      8E00E9D39100EBD59300EBD59300EBD59400EBD49300E9D39100EBD49300EBD5
      9300E9D39100ECDCA200B67F140000000000000000007D797600FFFFFF00FFFF
      FF00FDFDFD00FEFEFE00FEFEFE00FFFFFF00FFFFFF00FFFFFF009F9D9A00E7E7
      E600CFCECD00E9E8E700ABA9A70000000000B67F1400ECDBA100E8D08E00E7CF
      8D00E7D08D00E9D29000ECD79500EED99800ECD79500E9D29000E7D08D00E7CF
      8D00E8D08E00ECDBA100B67F14000000000000000000387CC7FF64E0FFFF4BD4
      FFFF4CD3FFFF4CD3FFFF4CD3FFFF4DD4FFFF4DD4FFFF4CD3FFFF4CD3FFFF4CD3
      FFFF4CD4FFFF4BD4FFFF64E0FFFF387CC7FFB67F1300EDD89F00E6CC8700E7CE
      8900DEC07B00833D0000E7CD890090500000BF944900EDD79400BF9449008F4F
      0000E3C78200EED9A000B67F130000000000000000007E7C7900FFFFFF00FAFA
      FA00F9F9F900FBFBFB00FFFFFF00FFFFFF00DADADA00D2D2D200C0BEBD00EFEF
      EF00EDECEC00D6D6D300B2B0AE0000000000B67F1300EDD89F00E5CC8700E5CB
      8600E5CC8700E9D18D00833E000088440000833E0000E9D18D00E5CC8700E5CB
      8600E5CC8700EDD89F00B67F13000000000000000000387DC7FF6AE1FFFF49D5
      FFFF4BD4FFFF4BD5FFFF4BD4FFFF4DD7FFFF4DD8FFFF4BD5FFFF4BD3FFFF4BD5
      FFFF4CD6FFFF49D4FFFF6AE0FFFF377DC7FFB67F1300EED7A000E6C88100E8CC
      8500C59C5000A0671400EED38E00D4B166008E4D0000DFC078008E4D0000D3AF
      6400E9CC8500EFD8A100B67F13000000000000000000827F7D00FFFFFF00F5F6
      F600F5F5F600FCFCFC0058585800DAD9D9006A6A6A0071717100464545009F9C
      9A00A09D9B00C1C0BE00B9B7B50000000000B67F1300EED7A000E5C78000E5C7
      8000E5C78000E8CB8500EFD5900088460000EFD59000E8CB8500E5C78000E5C7
      8000E5C78000EED7A000B67F13000000000000000000387EC8FF71E5FFFF0037
      67FF4CDFFFFF003867FF4BDCFFFF003A6AFF003C6BFF1A76A7FF49D9FFFF1A75
      A6FF003665FF146FA0FF6FE1FFFF377DC7FFB6801300F0D6A200E6C57C00EACB
      8200AD782700B9893A00EBCC8400EDCF8700B68536008C4B0000B17E2D00EDCE
      8600E7C77D00F0D7A200B6801300000000000000000085827F00FFFFFF00F2F2
      F100F3F3F200FCFCFB005C5C5C00FFFFFF00FFFFFF00FFFFFF0058585800CECD
      CE00E7E6E500B2B0AE00A8A6A40000000000B6801300F0D6A200E5C47A00E5C4
      7B00E5C47B00E7C67E00EDCF870086430000EDCF8700E7C67E00E5C47B00E5C4
      7B00E5C47A00F0D6A200B68013000000000000000000387FC9FF77E9FFFF003F
      6FFF004271FF004170FF49DDFFFF00416FFF4CE2FFFF003D6CFF48DAFFFF003B
      69FF45D6FFFF3FCEFFFF73E0FFFF377DC7FFB6801300F0D7A400E6C27600EAC9
      7E008C4D0000D8B26500E8C67B00EBC97F00B68434008C4B0000B07D2B00EBC9
      7E00E6C27600F0D7A400B6801300000000000000000088868200FFFFFF00EFEE
      EE00F1F0F000FBFAFA005D5D5E00FFFFFF00626262005755550060606000EDED
      EC00F5F4F500F6F5F6008785820000000000B6801300EFD7A400E4C07300E4C0
      7400E4C07500E5C27700EBC97F0086430000EBC97F00E5C27700E4C07500E4C0
      7400E4C07300EFD7A400B68013000000000000000000377FC9FF7CE8FFFF003E
      6DFF46DDFFFF00406EFF44DAFFFF014271FF024372FF1A79AEFF44D7FFFF003C
      6AFF40D0FFFF38C7FFFF78DEFFFF367DC7FFB6801300F1D7A600E7C07200D8AE
      60008C4C0000ECC67A00E9C37600D3A757008E4E0000E5BE71008E4E0000D3A6
      5700E7C07200F1D8A600B680130000000000000000008B888600FEFEFE00EBEB
      EA00EFEFEE00DFDFDE0061606000FFFFFF003A3B3B00FFFFFF00FDFDFB00F2F2
      F100EDEDEC00FFFFFF008C88860000000000B6801300F1D7A500E4BC6E00E4BD
      7000E4BD7000E6BF7200ECC67A0086440000EBC67900E5BF7200E4BD7000E4BD
      7000E4BC6E00F1D7A500B68013000000000000000000377FC8FF82E6FFFF003C
      6AFF3FD6FFFF003E6CFF3FD3FFFF01416FFF42DAFFFF003F6CFF3FD1FFFF003C
      69FF3CCEFFFF34C6FFFF7FDFFFFF367DC7FFB6801300F2D8A800E8BD6C00C08C
      3A00A66D1A00EAC07200E9BF70008F500000BF8C3A00ECC37500BF8C3B008F50
      0000E1B56400F3D9A800B680130000000000000000008E8B8800FEFEFD00E8E7
      E600EEECEB00595959002A2A2B00FBF9F8005E5E5D005E5E5E0058585900C7C6
      C500E9E8E700FEFEFD008E8B880000000000B6801300F2D7A700E4B86700E4B9
      6900E4B96A00E7BC6D00EEC5770087470000EBC27300E5BB6C00E4B96A00E4B9
      6900E4B86700F2D7A700B68013000000000000000000367EC8FF86E4FFFF0D6F
      A6FF003C68FF1471A7FF38CBFFFF003D69FF003F6BFF1471A7FF37CAFFFF1371
      A6FF003965FF0A6AA0FF85E1FFFF367DC7FFB6801300F4D9AC00E8BB68009E63
      0F00C5924000E7BB6A00E5B96800E7BB6A00E6BB6A00E6B96800E6BB6A00E7BB
      6900E5B76400F4D8AC00B68013000000000000000000948F8B00FFFFFE00E6E6
      E200E9E9E600F0F0EC00CCCAC600EFEEEB00F0EFEB00F0F0EC00EEEEEA00EAE9
      E600E7E6E300FFFFFE00948F8B0000000000B6801300F3D8AB00E3B46200E3B6
      6400E3B76600E7BB6A008544000088490000EABF6E00E4B86700E3B66500E3B6
      6400E3B46200F3D8AB00B68013000000000000000000367DC7FF8BE0FFFF29BE
      FFFF30C0FFFF31BFFFFF30BEFFFF31C1FFFF31C2FFFF31BFFFFF30BEFFFF31BF
      FFFF30C0FFFF29BDFFFF8BE0FFFF367DC7FFB6801300F6DBB000E1AF5A008242
      0000DCAB5800E5B46300E3B26100E4B36100E3B26100E3B26000E3B26100E3B2
      6000E3B05C00F4DAAE00B68013000000000000000000A39C8900FFFFFD00F2ED
      DE00F4F0E100F6F2E300F7F2E100F6F0DF00F6F0DE00F6F1E000F5F1E200F4F0
      E100F2EEDE00FFFFFD00A39C890000000000B6801300F4DAAE00E3B05C00E3B2
      5F00E3B26000E5B56300EBBB6A0084440000E8B86600E4B36100E3B26000E3B2
      5F00E3B05C00F4DAAE00B68013000000000000000000357DC7FF91E0FFFF21B4
      FFFF27B6FFFF29B6FFFF28B6FFFF29B7FFFF29B7FFFF29B6FFFF28B6FFFF29B6
      FFFF27B6FFFF21B4FFFF91E0FFFF357DC7FFB6801300F6DBB300E5AF5600E6B2
      5C00E5B15C00E3AF5900E3AF5800E3AE5800E3AE5800E3AE5800E3AE5800E3AE
      5700E3AC5400F6DBB200B680130000000000000000000020E700526FEF000016
      E500000AB100000CB3000019E9000018E3000018E2000018E600000BB100000B
      B2000016E700526FEF000020E70000000000B6801300F6DBB200E3AC5400E3AE
      5700E3AF5800E3AF5900E5B15C00E7B35D00E5B15B00E3AF5900E3AE5800E3AE
      5700E3AC5400F6DBB200B68013000000000000000000357DC7FF97E1FFFF15AE
      FFFF1AAFFFFF1BAFFFFF1BAFFFFF1BAFFFFF1BAFFFFF1BAFFFFF1BAFFFFF1BAF
      FFFF1AAFFFFF15AEFFFF97E1FFFF357DC7FFB6801300F6DCB600E2A64B00E2A8
      4E00E2A84F00E1A84E00E1A84E00E1A84E00E1A84E00E1A84E00E1A84E00E1A7
      4D00E1A64B00F6DCB600B680130000000000000000000138F1009DB3FB0096AF
      FF00C0BAA40080714E0093A2D6009BB2FD009CB2FA0097B0FF00C1BBA4008171
      4C0098B1FF009DB4FC000138F10000000000B6801300F6DCB600E1A64B00E1A7
      4D00E1A84E00E1A84E00E2A84F00E2A84F00E2A84F00E1A84E00E1A84E00E1A7
      4D00E1A64B00F6DCB600B68013000000000000000000357FC8FF9FE6FFFF9FE2
      FFFFA0E2FFFFA0E2FFFFA0E2FFFFA0E2FFFFA0E2FFFFA0E2FFFFA0E2FFFFA0E2
      FFFFA0E2FFFF9FE2FFFF9FE6FFFF357FC8FFB7811500FAE1C000F7DEBB00F7DE
      BB00F7DEBB00F7DEBB00F7DEBB00F7DEBB00F7DEBB00F7DEBB00F7DEBB00F7DE
      BB00F7DEBB00FAE1C000B781150000000000000000005173D2000648FE000042
      FF00BCB7A500938873002154E4000447FF000748FC000043FF00BDB7A400978B
      6E000045FF000748FE005173D20000000000B7811500FAE1C000F7DEBB00F7DE
      BB00F7DEBB00F7DEBB00F7DEBB00F7DEBB00F7DEBB00F7DEBB00F7DEBB00F7DE
      BB00F7DEBB00FAE1C000B7811500000000000000000015304A5E357FC8FF347D
      C7FF347DC7FF347DC7FF347DC7FF347DC7FF347DC7FF347DC7FF347DC7FF347D
      C7FF347DC7FF347DC7FF357FC8FF15304A5E44310900B7811500B6801200B680
      1200B6801200B6801200B6801200B6801200B6801200B6801200B6801200B680
      1200B6801200B781150044310900000000000000000000000000000000000000
      0000BBB5A400A8A195001F1D1800000000000000000000000000BDB6A200B2A6
      8F000000000000000000000000000000000044310900B7811500B6801200B680
      1200B6801200B6801200B6801200B6801200B6801200B6801200B6801200B680
      1200B6801200B781150044310900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000011000000320000003300000033000000330000
      00330000003300000033000000320000000F0000002400000033000000330000
      0033000000330000003300000033000000330000003300000033000000330000
      0033000000330000003300000033000000240000000000000023000000330000
      0033000000330000003300000033000000330000003300000033000000330000
      0033000000330000002300000000000000000000000000000000000000000000
      0000000000000000000000000012000000320000003300000032000000120000
      000000000000000000000000000000000000000000000000002F000000330000
      00330000003300000033391F0877A45109F9A7530AFFA7520AFFA7520AFFA752
      0AFFA7520AFFA7530BFFA5520BFB321A056F7F5709C1B77F0FFFB67D0AFFB67C
      0AFFB67C0AFFB67C0AFFB67C0AFFB67C0AFFB67C0AFFB67C0AFFB67C0AFFB67C
      0AFFB67C0AFFB67D0AFFB77F0FFF7F5709C1000000007B7B79C0B0B0AEFFAEAE
      ADFFAEAFADFFAEAFADFFAEAFADFFAEAFADFFAEAFADFFAEAFADFFAEAEADFFAEAE
      ACFFAFAFADFF7B7B79C000000000000000000000000000000000000000000000
      000000000012000000310B25357A29729DF94C96C0FF29719DF90B25357A0000
      00310000001200000000000000000000000000000000AC7E4AEED0A675FFB889
      56FFB88955FFCBA881FFB05B11FFD8975BFFE3A971FFE3A870FFE3A770FFE3A7
      70FFE3A870FFE4A971FFD9995EFFB26019FFB77F0FFFF7FFFFFFF2F7FFFFF2F6
      FFFFF2F6FFFFF2F6FFFFF1F6FFFFF1F6FFFFF1F6FFFFF1F6FFFFF1F6FFFFF1F6
      FFFFF1F6FFFFF2F7FFFFF7FFFFFFB77F0FFF00000000B0B0AEFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB0B0ADFF00000000000000000000000000000000000000130000
      00310B253479266E9AF74090B8FF54A8CDFF77C0E6FF5CAED2FF408FB8FF266E
      9AF70B25347900000031000000130000000000000033BF986DFFE5C49FFFBD8E
      57FFB58550FFFFFFF7FFBF712AFFE9BF95FFE1A261FFE19F5CFFE19D59FFE19D
      59FFE19F5DFFE1A261FFEAC198FFBA6B22FFB67D0AFFF4FBFFFFEBEBEEFFEBEA
      ECFFEBEBECFFEBEAECFFEAEAECFFE9E9EBFFE8E8EAFFE7E7E9FFE7E7E9FFE8E8
      EAFFE9E9EBFFEAEBEEFFF4FBFFFFB67D0AFF00000000AEAFADFFFFFFFFFFEBC9
      A5FFE2A86AFFE5AA6DFFE7AA6DFFE8AC6DFFE9AD6DFFE4AA6BFFEBC9A4FFFFFF
      FFFFFFFFFFFFAEAEABFF000000000000000000000000000000000C28397F2E78
      A3F94594BEFF56A9CFFF53A6CDFF50A3CAFF74BDE3FF59AAD0FF54A7CCFF57A9
      CFFF4695BEFF2E78A3F90C283A7F000000008E8D8FFFC6CAD0FF58616DFFC698
      5EFFB4834DFFFFF9EFFFCC8442FFF0D4B9FFF0B776FFF0BA7BFFF5FAFDFFEBEF
      F2FFF0B979FFF1B877FFF2D8BFFFC3762DFFB67C09FFF4FAFFFFE8E7E7FFE9E8
      E7FFEBEAE8FFEAE9E7FFE8E7E6FFEBEAEAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFEBEAEAFFE6E6E7FFF4FAFFFFB67C09FF00000000AEAFADFFFFFFFFFFDEA6
      69FF21B78CFF28B78DFF2BB98EFF33BD90FF1D7A8BFF2DBD8FFFE1A76AFFFEFF
      FFFFFFFFFFFFADADABFF00000000000000000000000000000000236D9BFF5BA9
      CFFF4FA0C9FF4E9FC8FF4D9EC7FF4A9CC5FF74BDE2FF55A5CCFF4DA0C8FF4EA1
      C9FF50A3CAFF5CACD0FF246E9BFF0000000000000000BF894CFFA57A42FFCC9F
      64FFB3824CFFFFF7ECFFCE823AFFF0D6BDFFFAE5CBFFFFF8EAFFFFFEFEFFF5F4
      F3FFEFE4D3FFFDE8CFFFF3DCC6FFC97E39FBB67C09FFF5FBFFFFE5E4E6FF9D9C
      9CFF9E9D9DFF9D9C9CFFE8E5E6FFC0BFBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFBFBEBCFFE5E3E5FFF5FBFFFFB67C09FF00000000AEAFADFFFFFFFFFFDEA5
      67FFFFEBB2FFFFEAB1FFFFEBB6FF7DBD96FF196B98FF7AC098FFE4A86BFFFBFD
      FFFFFFFFFFFFADADABFF00000000000000000000000000000000317AA6FF62AA
      CFFF4899C4FF4999C4FF4899C4FF4696C2FF75BEE3FF51A1CAFF4A9AC4FF4B9B
      C5FF4A9BC5FF66ADD0FF276F9DFF0000000000000033C0986DFFE4C59AFFD1A5
      68FFB2814BFFFFF4E7FFF2D9BDFFDC9755FFEAB27BFFAEC4CAFF5D9FC3FF3B7B
      9FFF728488FFEFBA86FFCE8943FF03020104B67C09FFF5FBFFFFDFDFE1FFE2E1
      E1FFE4E3E3FFE3E2E2FFE3E2E2FFA0A0A0FFA0A0A0FF9F9F9FFF9F9F9FFFA0A0
      A0FFA0A0A0FFE1E1E3FFF5FBFFFFB67C09FF00000000AEAFADFFFFFFFFFFE1A6
      62FF2DC0FFFF2DBFFFFFFFDF9AFF23A689FF1EA88BFF24A98BFFE2A86AFFF8FB
      FFFFFFFFFFFFADADABFF00000000000000000000000000000000327AA6FF6CAC
      D0FF4293BFFF4594C0FF4493C0FF4191BDFF76BEE3FF4E9EC8FF4596C1FF4697
      C2FF4496C2FF6FB0D1FF2A719EFF000000008E8D8FFFC6C9D0FF57606CFFDAAF
      6FFFB2804AFFFCF2E5FFF5DEC4FFFFFFFFFFF3DDC9FF9AAAA8FF66A2C3FF4E88
      A8FF747E7AFFFFE4C3FFB58651FF00000000B67C09FFF5FBFFFFDBDBDCFFDDDC
      DBFFDEDDDCFFDEDDDBFFDDDCDBFFDEDDDCFFDDDCDAFFDCDBDAFFDCDBDAFFDDDC
      DAFFDDDCDBFFDCDBDCFFF5FBFFFFB67C09FF00000000AEAFADFFFFFFFFFFDFA4
      61FF32CEFFFF32CDFFFFFFD483FFFFD68AFF15B29BFFFFD78AFFDAA569FFF3F7
      FBFFFFFFFFFFADADABFF00000000000000000000000000000000337AA7FF77B0
      D2FF3D8DBCFF408EBDFF408EBCFF3C8BBAFF76C0E4FF4C9BC6FF4290BEFF4391
      BFFF4090BEFF7BB4D4FF2D73A0FF0000000000000000BF884CFFA37B3DFFDFB6
      76FFB17F49FFFDF2E4FFF3D9BBFFFFFFFFFF9FA7AEFF70B7DDFF7EBFE2FF6FAF
      D1FF4E93BCFFE9E6E0FFBC8951FF00000000B67C0AFFF6FBFFFFD9D9D9FFDCDB
      DAFFDDDDDBFFDCDBDAFFDAD9D8FFEEEDEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFEEEDEDFFD7D7D8FFF6FBFFFFB67C0AFF00000000AEAEADFFFFFFFFFFE3C1
      9BFFE0A663FFE0A766FFDAA76AFFDBA76CFFDEA76BFFDAA568FFDFC09CFFF0F1
      F4FFFFFFFFFFADADABFF00000000000000000000000000000000347AA6FF83B6
      D5FF3787B8FF3A89B9FF3A88B8FF3785B6FF77C0E4FF4896C3FF3D8BBAFF3D8C
      BBFF3A8BBAFF86B9D6FF3076A1FF0000000000000033C0986DFFE2C497FFE5BC
      7AFFB17F49FFFDF3E7FFF4D8B7FFFFFFFFFF09305EFFA0EAFFFF8ED0F0FF7EBE
      DEFF6EB0D4FF254B7BFFC38E53FF00000000B67D0AFFF6FCFFFFD7D5D6FF9392
      92FF959495FF949393FFD9D7D6FFC2C1BEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFC1C0BDFFD5D4D4FFF6FCFFFFB67D0AFF00000000AEAEACFFFFFFFFFFF0F4
      FBFFF2F8FFFFF3FAFFFFF2F9FFFFF1F7FFFFF0F3F9FFEFF1F5FFEDEEF0FFECEC
      ECFFFFFFFFFFADADABFF00000000000000000000000000000000377CA7FF91BD
      D9FF3484B7FF3D89BAFF5097C2FF5CA5CAFF58ABD1FF5DA4C9FF4A90BDFF3E8B
      BAFF3384B7FF92BDDAFF3478A3FF000000008E8D8FFFC6C9D0FF565E6CFFECC5
      7FFFB17E49FFFEF5EAFFF4D6B4FFFFFFF3FF00285FFF64A7CCFF79B4D6FF8CCC
      EBFF7CBEE0FF00205BFFC89255FF00000000B67D0AFFF6FCFFFFD2D1D1FFD6D3
      D2FFD7D5D3FFD6D4D3FFD6D3D2FFA2A3A3FFA1A2A2FFA0A0A1FFA0A0A1FFA1A2
      A2FFA2A2A2FFD3D1D2FFF6FCFFFFB67D0AFF00000000AEAFADFFFFFFFFFFD8AF
      6CFFCC8B1BFFCC8D1EFFCC8C1CFFD8B06DFFF5F9FEFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFAEAEABFF000000000000000000000000000000003D81AAFF8EBB
      D8FF67A2C7FF7CB4D2FF71B4D3FF5BA6CCFF499CC6FF5BA6CCFF6FB1D1FF77AE
      D0FF68A4CAFF90BCD9FF3A7DA5FF0000000000000000BF884CFFA17B3AFFEDC5
      81FFB07E48FFFEF8EEFFF3D4B1FFFFDFB6FF00336CFF2874A7FF4D89B7FF517A
      A5FF2F4D7AFF002660FFC99356FF00000000B67D0AFFF6FCFFFFCACBCCFFCCCC
      CCFFCCCCCCFFCCCCCCFFCDCCCDFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
      CEFFCDCDCDFFCBCBCDFFF6FCFFFFB67D0AFF00000000AEAFAEFFFFFFFFFFCB8A
      18FFEBD3A9FFE0B56BFFEBD3AAFFCB8918FFFFFFFFFFCCCCCDFFA6A6A4FFA5A5
      A2FFFFFFFFFFAFAFADFF000000000000000000000000000000003A7CA7FF95C0
      D9FF74B3D4FF4E9DC6FF4E9DC6FF61A7CBFF5AA1C8FF4698C2FF4295C2FF4E9C
      C5FF70AECFFF95C2DDFF3A7CA7FF0000000000000033C0976CFFD9BB89FFEBC4
      7EFFB07D47FFFFFAF1FFF1D1ACFFFFDBB1FF0A335FFF1B72AAFF3B86B8FF3B78
      A9FF174272FF1A4176FFC58F54FF00000000B67D0CFFF5FDFFFFF2F7FFFFF3F7
      FFFFF3F7FFFFF3F7FFFFF3F7FFFFF3F8FFFFF3F8FFFFF3F8FFFFF3F8FFFFF3F8
      FFFFF3F7FFFFF3F7FFFFF5FDFFFFB67D0CFF00000000AEAFAEFFFFFFFFFFCB89
      18FFEBD2A9FFEBD2A9FFEBD2A9FFCB8918FFFFFFFFFFA7A7A6FFFBFBFAFFFFFF
      FFFFE9E9E9FF767675AC00000000000000000000000000000000113952882672
      A2FF3685B3FF4292C0FF4493C2FF4694C1FF5BA0C9FF88BBD8FF75B0D2FF4795
      C1FF3684B3FF2975A4FF11395288000000008D8D8FFFC4C7CEFF535A66FFF1CD
      90FFB07D46FFFFFFFCFFF3D8B8FFFADDBAFFD4C3B1FF164C7FFF044E89FF0346
      7CFF164476FFE3E8ECFFBD8950FF00000000B67F10FFF7E4C0FFDCAA4AFFDCAB
      4AFFDCAB4BFFDCAB4BFFDCAB4BFFDCAB4BFFDCAB4BFFDCAB4BFFDCAB4BFFDCAB
      4BFFDCAB4AFFDCAA4AFFF7E4C0FFB67F10FF00000000AEAFADFFFFFFFFFFD3AB
      66FFCB8918FFCB8A1AFFCB8918FFD3AB65FFFFFFFFFFA5A5A4FFFFFFFFFFE7E7
      E8FF727270A70000000000000000000000000000000000000000000000000000
      00000E2E416C236A96F52F7CAAFF3D8BBAFF3F8EBEFF3A89B9FF2D7AA9FF2269
      95F50E2E416C00000000000000000000000000000000BC864BFFFFF2D4FFFEF0
      D4FFB27F48FFFFFFFEFFFFFEF9FFFFFEF9FFFFFFFAFFFFFFFCFFFFFFFDFFFFFF
      FDFFFFFFFDFFFFFFFFFFB88650FF00000000B88216FFEFD2A0FFEDCF9BFFECCF
      9BFFECCF9BFFECCF9BFFECCF9BFFECCF9BFFECCF9BFFECCF9BFFECCF9BFFECCF
      9BFFECCF9BFFEDCF9BFFEFD2A0FFB88216FF00000000AFB0AEFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E9E9FF7171
      6FA6000000000000000000000000000000000000000000000000000000000000
      000000000000000000000C263659236A96F8236D9BFF226A96F80C2636590000
      000000000000000000000000000000000000000000007F5E39AFB78752FFB686
      52FFB78752FFB5844EFFB4824BFFB4824BFFB5834BFFB6834CFFB7844CFFB784
      4CFFB6844CFFB6854FFF7E5E3AB000000000815C13B2B88217FFB78114FFB681
      14FFB68114FFB68114FFB68114FFB68114FFB68114FFB68114FFB68114FFB681
      14FFB68114FFB78114FFB88217FF815C13B200000000A7A7A5EFB0B0AEFFAEAF
      ADFFAEAFAEFFAEAFAEFFAEAFAEFFAEAEADFFAEAEACFFAFAFADFFA1A19FEA0000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF000000FE7FFC3F00000000FC3FFC3F0000
      0000F81FFC3F00000000F00FFC3F00000000F00FFC3F00000000F00FFC3F0000
      0000FC3FFC3F00000000FC3FFC3F00000000FC3FFC3F00000000FC3FFC3F0000
      0000FC3FF00F00000000FC3FF00F00000000FC3FF00F00000000FC3FF81F0000
      0000FC3FFC3F00000000FC3FFE7F0000FF9FF00000010000FF0FE00000010000
      FE07C00000010000FC03800000010000FC01000000010000FC00000000010000
      FE60000000010000FFF0000000010000FFF9000000010000FFFF000000010000
      FFFF000000010000FFFF000000010000FFFF000300010000FFFF000300010000
      FFFF000F00010000FFFF000F0001000080000001800100018000000180010001
      8000000180010001800000018001000180000001800100018000000180010001
      8000000180010001800000018001000180000001800100018000000180010001
      8000000180010001800000018001000180000001800100018000000180010001
      800000018001000180000001F1CF0001FFFFFC0000008003FC1F800000008003
      F007800000008003C001000000008003C001000000008003C001800000008003
      C001000000008003C001000100008003C001800100008003C001000100008003
      C001000100008003C001800100008003C001000100008003C001000100008007
      F00780010000800FFC1F80010000801F00000000000000000000000000000000
      000000000000}
  end
  object pmNode: TPopupMenu
    Left = 384
    Top = 396
    object mniClearLink: TMenuItem
      Caption = 'ClearLink'
      OnClick = mniClearLinkClick
    end
  end
end
