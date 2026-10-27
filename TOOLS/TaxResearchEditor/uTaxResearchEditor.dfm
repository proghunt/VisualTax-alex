object fTaxResearchEditor: TfTaxResearchEditor
  Left = 0
  Top = 0
  Caption = 'Tax Research Editor'
  ClientHeight = 404
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDatabase: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 38
    Align = alTop
    TabOrder = 0
    DesignSize = (
      1000
      38)
    object lbDatabase: TLabel
      Left = 11
      Top = 10
      Width = 50
      Height = 13
      Caption = 'Database:'
    end
    object btnOpenDatabase: TSpeedButton
      Left = 885
      Top = 7
      Width = 23
      Height = 21
      Anchors = [akTop, akRight]
      Caption = '..'
      ExplicitLeft = 695
    end
    object edDatabase: TEdit
      Left = 72
      Top = 7
      Width = 807
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object btnConnect: TButton
      Left = 914
      Top = 7
      Width = 75
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Connect'
      TabOrder = 1
      OnClick = btnConnectClick
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 38
    Width = 393
    Height = 366
    Align = alLeft
    TabOrder = 1
    object tvMain: TTreeView
      Left = 1
      Top = 29
      Width = 391
      Height = 304
      Align = alClient
      HideSelection = False
      Indent = 19
      ReadOnly = True
      TabOrder = 0
      OnChange = tvMainChange
    end
    object grpLeft: TGridPanel
      Left = 1
      Top = 333
      Width = 391
      Height = 32
      Align = alBottom
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 70.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 10.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 45.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 45.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 1
          Control = btnTitleAdd
          Row = 0
        end
        item
          Column = 3
          Control = btnTitleEdit
          Row = 0
        end
        item
          Column = 4
          Control = btnTitleDelete
          Row = 0
        end
        item
          Column = 6
          Control = btnTitleUp
          Row = 0
        end
        item
          Column = 7
          Control = btnTitleDown
          Row = 0
        end
        item
          Column = 2
          Control = btnAddChild
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 1
      object btnTitleAdd: TButton
        AlignWithMargins = True
        Left = 23
        Top = 4
        Width = 54
        Height = 24
        Align = alClient
        Caption = 'Add'
        TabOrder = 0
        OnClick = btnTitleAddClick
      end
      object btnTitleEdit: TButton
        AlignWithMargins = True
        Left = 153
        Top = 4
        Width = 54
        Height = 24
        Align = alClient
        Caption = 'Edit'
        TabOrder = 2
        OnClick = btnTitleEditClick
      end
      object btnTitleDelete: TButton
        AlignWithMargins = True
        Left = 213
        Top = 4
        Width = 54
        Height = 24
        Align = alClient
        Caption = 'Delete'
        TabOrder = 3
        OnClick = btnTitleDeleteClick
      end
      object btnTitleUp: TButton
        AlignWithMargins = True
        Left = 283
        Top = 4
        Width = 39
        Height = 24
        Align = alClient
        Caption = 'Up'
        TabOrder = 4
        OnClick = btnTitleUpClick
      end
      object btnTitleDown: TButton
        AlignWithMargins = True
        Left = 328
        Top = 4
        Width = 39
        Height = 24
        Align = alClient
        Caption = 'Down'
        TabOrder = 5
        OnClick = btnTitleUpClick
        ExplicitTop = 6
      end
      object btnAddChild: TButton
        AlignWithMargins = True
        Left = 83
        Top = 4
        Width = 64
        Height = 24
        Align = alClient
        Caption = 'Add Child'
        TabOrder = 1
        OnClick = btnAddChildClick
      end
    end
    object pnlLeftCaption: TPanel
      Left = 1
      Top = 1
      Width = 391
      Height = 28
      Align = alTop
      TabOrder = 2
      object lbTitles: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 117
        Height = 20
        Align = alClient
        AutoSize = False
        Caption = 'Tree Structure'
        Layout = tlCenter
        ExplicitWidth = 177
        ExplicitHeight = 21
      end
      object btnImportFromTRTOC: TButton
        AlignWithMargins = True
        Left = 127
        Top = 2
        Width = 134
        Height = 24
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 1
        Align = alRight
        Caption = 'Import from TRTOC.txt'
        TabOrder = 0
        OnClick = btnImportFromTRTOCClick
      end
      object btnExportToTRTOC: TButton
        AlignWithMargins = True
        Left = 265
        Top = 2
        Width = 124
        Height = 24
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 1
        Align = alRight
        Caption = 'Export to TRTOC.txt'
        TabOrder = 1
        OnClick = btnExportToTRTOCClick
      end
    end
  end
  object pnlRight: TPanel
    Left = 393
    Top = 38
    Width = 607
    Height = 366
    Align = alClient
    TabOrder = 2
    OnResize = pnlRightResize
    object lbURLs: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 599
      Height = 21
      Align = alTop
      AutoSize = False
      Caption = 'URL Items'
      Layout = tlCenter
      ExplicitLeft = 8
      ExplicitTop = 12
      ExplicitWidth = 617
    end
    object grURLs: TDBGrid
      Left = 1
      Top = 28
      Width = 605
      Height = 305
      Align = alClient
      DataSource = dmData.dsURLs
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Id'
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'Caption'
          Width = 186
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'URL'
          Width = 380
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ParentTitleId'
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'SeqNo'
          Width = -1
          Visible = False
        end>
    end
    object grpRight: TGridPanel
      Left = 1
      Top = 333
      Width = 605
      Height = 32
      Align = alBottom
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 60.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 10.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 45.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 45.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 1
          Control = btnUrlAdd
          Row = 0
        end
        item
          Column = 2
          Control = btnUrlEdit
          Row = 0
        end
        item
          Column = 3
          Control = btnUrlDelete
          Row = 0
        end
        item
          Column = 5
          Control = btnUrlUp
          Row = 0
        end
        item
          Column = 6
          Control = btnUrlDown
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 1
      object btnUrlAdd: TButton
        AlignWithMargins = True
        Left = 165
        Top = 4
        Width = 54
        Height = 24
        Align = alClient
        Caption = 'Add'
        TabOrder = 0
        OnClick = btnUrlAddClick
      end
      object btnUrlEdit: TButton
        AlignWithMargins = True
        Left = 225
        Top = 4
        Width = 54
        Height = 24
        Align = alClient
        Caption = 'Edit'
        TabOrder = 1
        OnClick = btnUrlEditClick
      end
      object btnUrlDelete: TButton
        AlignWithMargins = True
        Left = 285
        Top = 4
        Width = 54
        Height = 24
        Align = alClient
        Caption = 'Delete'
        TabOrder = 2
        OnClick = btnUrlDeleteClick
      end
      object btnUrlUp: TButton
        AlignWithMargins = True
        Left = 355
        Top = 4
        Width = 39
        Height = 24
        Align = alClient
        Caption = 'Up'
        TabOrder = 3
        OnClick = btnUrlUpClick
      end
      object btnUrlDown: TButton
        AlignWithMargins = True
        Left = 400
        Top = 4
        Width = 39
        Height = 24
        Align = alClient
        Caption = 'Down'
        TabOrder = 4
        OnClick = btnUrlUpClick
      end
    end
  end
  object OpenTRTOC: TOpenDialog
    Filter = 'TRTOC file (TRTOC.txt)|TRTOC.txt|All Files (*.*)|*.*'
    Left = 200
    Top = 166
  end
  object SaveTRTOC: TSaveDialog
    FileName = 'TRTOC.txt'
    Filter = 'Text files (*.txt)|*.txt|All Files (*.*)|*.*'
    Left = 200
    Top = 214
  end
end
