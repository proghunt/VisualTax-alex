object ReadEMail: TReadEMail
  Left = 248
  Top = 133
  Width = 544
  Height = 375
  Caption = 'ReadEMail'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 236
    Top = 0
    Width = 78
    Height = 16
    Caption = 'POP3 Server'
  end
  object Label6: TLabel
    Left = 30
    Top = 0
    Width = 35
    Height = 17
    Caption = 'User:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object OKBtn: TBitBtn
    Left = 463
    Top = 10
    Width = 92
    Height = 31
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 335
    Top = 364
    Width = 92
    Height = 31
    TabOrder = 1
    OnClick = CancelBtnClick
    Kind = bkCancel
  end
  object Memo1: TRichEdit
    Left = 30
    Top = 69
    Width = 621
    Height = 277
    TabOrder = 2
  end
  object eServer: TEdit
    Left = 207
    Top = 25
    Width = 218
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object eFrom: TEdit
    Left = 10
    Top = 23
    Width = 129
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object Button2: TBitBtn
    Left = 79
    Top = 364
    Width = 92
    Height = 31
    Caption = 'Button2'
    TabOrder = 5
    OnClick = Button2Click
  end
  object DeleteBtn: TBitBtn
    Left = 217
    Top = 364
    Width = 92
    Height = 31
    Caption = 'DeleteBtn'
    TabOrder = 6
    OnClick = DeleteBtnClick
  end
  object NMPOP31: TNMPOP3
    Port = 110
    ReportLevel = 0
    OnConnect = NMPOP31Connect
    Parse = False
    DeleteOnRead = False
    OnRetrieveStart = NMPOP31RetrieveStart
    OnRetrieveEnd = NMPOP31RetrieveEnd
    OnSuccess = NMPOP31Success
    Left = 136
    Top = 153
  end
end
