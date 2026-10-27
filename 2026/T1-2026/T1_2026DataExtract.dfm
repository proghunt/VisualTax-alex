object frmDataExtract: TfrmDataExtract
  Left = 0
  Top = 0
  BorderIcons = [biMinimize]
  Caption = 'Data extract'
  ClientHeight = 296
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 248
    Width = 469
    Height = 29
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      469
      29)
    object btnClose: TBitBtn
      Left = 389
      Top = 1
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 0
    end
    object btnAbort: TBitBtn
      Left = 308
      Top = 1
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Abort'
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
      TabOrder = 1
      Visible = False
      OnClick = btnAbortClick
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 277
    Width = 469
    Height = 19
    Panels = <>
  end
  object pgMain: TPageControl
    Left = 0
    Top = 0
    Width = 469
    Height = 248
    ActivePage = tsImport
    Align = alClient
    TabOrder = 2
    object tsExport: TTabSheet
      Caption = 'Export'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 461
        Height = 137
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 74
          Width = 82
          Height = 13
          Caption = 'Export directory:'
        end
        object rgExportMode: TRadioGroup
          Left = 0
          Top = 0
          Width = 445
          Height = 65
          Caption = 'Export mode'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Current return'
            'All opened returns'
            'All returns')
          TabOrder = 0
        end
        object btnSelectDir: TButton
          Left = 415
          Top = 69
          Width = 30
          Height = 25
          Caption = '...'
          TabOrder = 1
          OnClick = btnSelectDirClick
        end
        object edtExportDir: TEdit
          Left = 96
          Top = 71
          Width = 313
          Height = 21
          TabOrder = 2
        end
        object Button1: TButton
          Left = 120
          Top = 98
          Width = 217
          Height = 25
          Caption = 'Export'
          TabOrder = 3
          OnClick = btnStartClick
        end
      end
    end
    object tsImport: TTabSheet
      Caption = 'Import'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 461
        Height = 220
        Align = alClient
        Caption = 'Import'
        TabOrder = 0
        object Label2: TLabel
          Left = 8
          Top = 18
          Width = 82
          Height = 13
          Caption = 'Import directory:'
        end
        object Label3: TLabel
          Left = 8
          Top = 34
          Width = 74
          Height = 13
          Caption = 'Import files list:'
        end
        object edtImport: TEdit
          Left = 96
          Top = 15
          Width = 313
          Height = 21
          ReadOnly = True
          TabOrder = 0
        end
        object btnOpenImportDir: TButton
          Left = 416
          Top = 13
          Width = 30
          Height = 25
          Caption = '...'
          TabOrder = 1
          OnClick = btnOpenImportDirClick
        end
        object cbImportSelect: TCheckListBox
          Left = 8
          Top = 48
          Width = 433
          Height = 97
          ItemHeight = 13
          TabOrder = 2
        end
        object btnSelectCurrent: TButton
          Left = 82
          Top = 152
          Width = 115
          Height = 25
          Caption = 'Select current return'
          TabOrder = 3
          OnClick = btnSelectCurrentClick
        end
        object btSelectOpened: TButton
          Left = 203
          Top = 152
          Width = 115
          Height = 25
          Caption = 'Select opened returns'
          TabOrder = 4
          OnClick = btSelectOpenedClick
        end
        object btnSelectAll: TButton
          Left = 324
          Top = 152
          Width = 115
          Height = 25
          Caption = 'Select all returns'
          TabOrder = 5
          OnClick = btnSelectAllClick
        end
        object btnImportnotOpen: TButton
          Left = 8
          Top = 184
          Width = 209
          Height = 25
          Caption = 'Import, but not open returns'
          TabOrder = 6
          OnClick = btnImportnotOpenClick
        end
        object btnImportOpen: TButton
          Left = 230
          Top = 183
          Width = 209
          Height = 25
          Caption = 'Import and open returns'
          TabOrder = 7
          OnClick = btnImportOpenClick
        end
        object btnRefresh: TButton
          Left = 8
          Top = 152
          Width = 70
          Height = 25
          Caption = 'Refresh'
          TabOrder = 8
          OnClick = btnRefreshClick
        end
      end
    end
  end
  object conClients: TADConnection
    Left = 385
    Top = 25
  end
  object tblClients: TADTable
    Connection = conClients
    Left = 361
    Top = 33
  end
end
