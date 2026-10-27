object frameUserAppSettings: TframeUserAppSettings
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  TabOrder = 0
  object lvValues: TListView
    Left = 0
    Top = 0
    Width = 451
    Height = 304
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = 'Name'
        MinWidth = 120
      end
      item
        AutoSize = True
        Caption = 'Description'
        MinWidth = 200
      end
      item
        AutoSize = True
        Caption = 'Common Value'
        MinWidth = 150
      end
      item
        AutoSize = True
        Caption = 'Override value '#13#10'(Doubleclick for edit)'
        MinWidth = 150
      end>
    GridLines = True
    Groups = <
      item
        Header = 'Folders'
        GroupID = 0
        State = [lgsNormal]
        HeaderAlign = taLeftJustify
        FooterAlign = taLeftJustify
        TitleImage = -1
      end>
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = lvValuesCustomDrawItem
    OnCustomDrawSubItem = lvValuesCustomDrawSubItem
    OnDblClick = lvValuesDblClick
    OnItemChecked = lvValuesItemChecked
  end
  object qrySettings: TADQuery
    Left = 120
    Top = 56
  end
end
