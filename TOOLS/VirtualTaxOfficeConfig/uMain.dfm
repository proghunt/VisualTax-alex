object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'Virtual Tax Office Configurator'
  ClientHeight = 134
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 286
    Height = 97
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 783
    object btnUpdateTaxOffices: TButton
      Left = 46
      Top = 10
      Width = 194
      Height = 25
      Caption = 'Update Tax Offices from Clients.DBF'
      TabOrder = 0
      OnClick = btnUpdateTaxOfficesClick
    end
    object btnLoadEfilers: TButton
      Left = 46
      Top = 41
      Width = 194
      Height = 25
      Caption = 'Load Efilers from spreadsheet'
      TabOrder = 1
      OnClick = btnLoadEfilersClick
    end
  end
  object pnlProgress: TPanel
    Left = 0
    Top = 80
    Width = 286
    Height = 54
    Align = alBottom
    TabOrder = 1
    Visible = False
    ExplicitTop = 89
    object lbInfo: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 3
      Height = 13
      Align = alTop
    end
    object pbProgress: TProgressBar
      AlignWithMargins = True
      Left = 4
      Top = 23
      Width = 197
      Height = 27
      Align = alClient
      TabOrder = 0
      ExplicitTop = 4
      ExplicitWidth = 694
      ExplicitHeight = 24
    end
    object btnCancelThread: TButton
      AlignWithMargins = True
      Left = 207
      Top = 23
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelThreadClick
      ExplicitLeft = 704
      ExplicitTop = 4
      ExplicitHeight = 24
    end
  end
  object OpenClientsDBFDialog: TOpenDialog
    Filter = 
      'Clients.DBF|Clients.DBF|DBF files (*.DBF)|*.DBF|All Files (*.*)|' +
      '*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 248
    Top = 8
  end
  object OpenExcelDialog: TOpenDialog
    Filter = 'Excel files (*.xls, *.xlsx)|*.xls;*.xlsx|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 248
    Top = 40
  end
end
