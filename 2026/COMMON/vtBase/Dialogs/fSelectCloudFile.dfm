object frmSelectCloudFile: TfrmSelectCloudFile
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Select file..'
  ClientHeight = 291
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 250
    Width = 604
    Height = 41
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    ExplicitLeft = 160
    ExplicitTop = 216
    ExplicitWidth = 185
    DesignSize = (
      604
      41)
    object Label1: TLabel
      Left = 16
      Top = 14
      Width = 26
      Height = 13
      Caption = 'Show'
    end
    object rbAll: TRadioButton
      Left = 53
      Top = 13
      Width = 33
      Height = 17
      Caption = 'All'
      TabOrder = 0
      OnClick = rbAllClick
    end
    object rbFiltered: TRadioButton
      Left = 101
      Top = 13
      Width = 60
      Height = 17
      Caption = 'Filtered'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = rbAllClick
    end
    object edFilter: TEdit
      Left = 165
      Top = 11
      Width = 105
      Height = 21
      TabOrder = 2
      OnChange = edFilterChange
    end
    object btnOk: TButton
      Left = 440
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Select'
      Default = True
      ModalResult = 1
      TabOrder = 3
      ExplicitLeft = 285
    end
    object Button2: TButton
      Left = 521
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 4
      ExplicitLeft = 366
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 604
    Height = 250
    Align = alClient
    DataSource = dsFiles
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = DBGrid1DblClick
    Columns = <
      item
        Expanded = False
        FieldName = 'FILE_NAME'
        Title.Alignment = taCenter
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Alignment = taCenter
        Title.Caption = 'Filename'
        Width = 266
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FOLDER'
        Title.Alignment = taCenter
        Title.Caption = 'Folder'
        Width = 194
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'EXT'
        Title.Alignment = taCenter
        Title.Caption = 'Extension'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'SHARED'
        Title.Alignment = taCenter
        Title.Caption = 'Is shared'
        Width = 55
        Visible = True
      end>
  end
  object dsFiles: TDataSource
    DataSet = qFiles
    Left = 200
    Top = 144
  end
  object qFiles: TADMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 200
    Top = 96
    object qFilesFILE_NAME: TStringField
      FieldName = 'FILE_NAME'
      Size = 255
    end
    object qFilesFOLDER: TStringField
      FieldName = 'FOLDER'
      Size = 255
    end
    object qFilesNAME: TStringField
      FieldName = 'NAME'
      Size = 255
    end
    object qFilesEXT: TStringField
      FieldName = 'EXT'
      Size = 255
    end
    object qFilesSHARED: TStringField
      FieldName = 'SHARED'
      Size = 3
    end
  end
end
