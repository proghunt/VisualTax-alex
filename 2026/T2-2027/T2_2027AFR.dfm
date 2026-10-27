object frmAFR: TfrmAFR
  Left = 0
  Top = 0
  Caption = 'AFR'
  ClientHeight = 598
  ClientWidth = 843
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 843
    Height = 598
    ActivePage = tsWork
    Align = alClient
    TabOrder = 0
    object tsStart: TTabSheet
      Caption = 'tsStart'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        835
        570)
      object lblStart: TLabel
        AlignWithMargins = True
        Left = 30
        Top = 30
        Width = 775
        Height = 510
        Margins.Left = 30
        Margins.Top = 30
        Margins.Right = 30
        Margins.Bottom = 30
        Align = alClient
        Caption = 
          'T2 Auto-fill'#13#10#13#10'You are about to be redirected to a secure Canad' +
          'a Revenue Agency (CRA) electronic service for Corporations which' +
          ' will automatically allow the delivery of available corporate ta' +
          'x data.'#13#10#13#10'To use this secure service you must have a CRA or Sig' +
          'n-In partner credential and be signed up and registered with eit' +
          'her CRA'#8217's My Business Account or Represent a client.'#13#10#13#10'Each ind' +
          'ividual should enter their own userid and password to use T2 Aut' +
          'o-fill. Authorized Reps can also use T2 Auto-fill on behalf of a' +
          ' client, to do so you must have: '#13#10#13#10#8226#9'a RepID with the Represen' +
          't a Client portal.'#13#10#8226#9'a valid RC59 for online access on file'#13#10#13#10 +
          'For more information on authorizing a representative, go to Auth' +
          'orize or cancel a representative.'#13#10#13#10'See the user'#8217's consent to t' +
          'he Terms and Conditions of agreement for the service for more de' +
          'tails.'#13#10
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitHeight = 460
      end
      object btnContinue: TButton
        Left = 527
        Top = 531
        Width = 195
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'I agree, Continue'
        TabOrder = 0
        OnClick = btnContinueClick
      end
      object btnCancel: TButton
        Left = 743
        Top = 531
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
    object tsWork: TTabSheet
      Caption = 'tsWork'
      ImageIndex = 1
      object pgcWizard: TPageControl
        Left = 0
        Top = 0
        Width = 835
        Height = 529
        ActivePage = tsProcess
        Align = alClient
        TabOrder = 0
        object tsSelectReturn: TTabSheet
          Caption = 'Select Return'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Label1: TLabel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 121
            Height = 25
            Align = alTop
            Alignment = taCenter
            Caption = 'Select return'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -21
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object grClients: TDBGrid
            Left = 0
            Top = 72
            Width = 827
            Height = 429
            Align = alClient
            DataSource = dsClients
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDblClick = btnNextClick
            OnKeyPress = grClientsKeyPress
            OnTitleClick = grClientsTitleClick
          end
          object Panel2: TPanel
            Left = 0
            Top = 31
            Width = 827
            Height = 41
            Align = alTop
            TabOrder = 1
            object Label3: TLabel
              Left = 16
              Top = 16
              Width = 28
              Height = 13
              Caption = 'Filter:'
            end
            object edFilter: TEdit
              Left = 50
              Top = 14
              Width = 311
              Height = 21
              TabOrder = 0
              OnChange = edFilterChange
              OnKeyPress = grClientsKeyPress
            end
          end
        end
        object tsProcess: TTabSheet
          Caption = 'tsProcess'
          ImageIndex = 1
          object GroupBox1: TGroupBox
            Left = 0
            Top = 0
            Width = 827
            Height = 177
            Align = alTop
            Caption = 'Return Info'
            TabOrder = 0
            object vlReturnInfo: TValueListEditor
              Left = 2
              Top = 15
              Width = 823
              Height = 160
              Align = alClient
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goAlwaysShowEditor, goThumbTracking]
              TabOrder = 0
              TitleCaptions.Strings = (
                'Field'
                'Value')
              ColWidths = (
                166
                651)
            end
          end
          object mmoLog: TMemo
            Left = 0
            Top = 269
            Width = 827
            Height = 232
            Align = alClient
            TabOrder = 1
          end
          object Panel3: TPanel
            Left = 0
            Top = 177
            Width = 827
            Height = 62
            Align = alTop
            TabOrder = 2
            DesignSize = (
              827
              62)
            object btnExecuteAFR: TButton
              Left = 623
              Top = 14
              Width = 169
              Height = 42
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Submit request to CRA'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnExecuteAFRClick
            end
            object chbAutoClose: TCheckBox
              Left = 308
              Top = 16
              Width = 237
              Height = 17
              Caption = 'Close CRA webpage after authorization'
              Checked = True
              State = cbChecked
              TabOrder = 1
            end
            object rgTestOrProd: TRadioGroup
              Left = 9
              Top = 6
              Width = 244
              Height = 55
              ItemIndex = 0
              Items.Strings = (
                'Production (user)'
                'Test (Software Developer only)')
              TabOrder = 2
            end
            object chbAutoSaveToMobileDB: TCheckBox
              Left = 308
              Top = 39
              Width = 266
              Height = 17
              Caption = 'Automatically save the result to a mobile database.'
              TabOrder = 3
            end
          end
          object pnlViewOld: TPanel
            Left = 0
            Top = 239
            Width = 827
            Height = 30
            Align = alTop
            TabOrder = 3
            DesignSize = (
              827
              30)
            object btnViewOld: TButton
              Left = 218
              Top = 2
              Width = 295
              Height = 25
              Anchors = [akLeft, akTop, akRight]
              Caption = 'View AFR from 21/01/2017'
              TabOrder = 0
              OnClick = btnViewOldClick
            end
            object btnViewOldNOA: TButton
              Left = 519
              Top = 2
              Width = 295
              Height = 25
              Anchors = [akLeft, akTop, akRight]
              Caption = 'View NOA from 21/01/2017'
              TabOrder = 1
              OnClick = btnViewOldNOAClick
            end
          end
        end
        object tsFinish: TTabSheet
          Caption = 'tsFinish'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object lblFinish: TLabel
            AlignWithMargins = True
            Left = 30
            Top = 30
            Width = 765
            Height = 207
            Margins.Left = 30
            Margins.Top = 30
            Margins.Right = 30
            Margins.Bottom = 30
            Align = alClient
            Caption = 
              '  The <tax year> tax return for <taxpayer name> has been assesse' +
              'd. To view your clients most recent assessment/reassessment deta' +
              'ils, login to the Express NOA service within your software.  '#13#10#13 +
              #10'  The same selection criteria for verifying income tax returns ' +
              'are used for both paper and electronic versions. Your client nee' +
              'ds to keep all tax information slips and documents for six years' +
              ' after you filed the tax return. Please keep this confirmation n' +
              'umber and DCN for your records: #######- #############'#13#10
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -21
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
          object lblHTMLPath: TLabel
            Left = 0
            Top = 478
            Width = 6
            Height = 23
            Align = alBottom
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 529
        Width = 835
        Height = 41
        Align = alBottom
        TabOrder = 1
        DesignSize = (
          835
          41)
        object btnPrev: TButton
          Left = 575
          Top = 8
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = '<<< Prev'
          TabOrder = 0
          OnClick = btnPrevClick
        end
        object btnNext: TButton
          Left = 664
          Top = 8
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Next >>>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = btnNextClick
        end
        object btnCancel2: TButton
          Left = 751
          Top = 8
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Cancel'
          TabOrder = 2
          OnClick = btnCancel2Click
        end
      end
    end
  end
  object conClients: TADConnection
    Left = 216
    Top = 120
  end
  object tblClients: TADTable
    OnFilterRecord = tblClientsFilterRecord
    Connection = conClients
    Left = 216
    Top = 176
  end
  object dsClients: TDataSource
    DataSet = tblClients
    Left = 256
    Top = 176
  end
end
