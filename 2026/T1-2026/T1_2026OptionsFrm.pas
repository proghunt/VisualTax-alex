Unit T1_2026optionsfrm;
//imported 07-28

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  vtLabel,ExtCtrls,ComCtrls,Db,Buttons,DBCtrls,Mask,FileCtrl,vtEditBox,
  vtShape,ColorGrd, T1_2026HeaderFrame, IOUtils, System.StrUtils, VirtualUI_Mediator;//20171031 igor

type
  TOptionsFrmT1_2026 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel2: TPanel;
    Panel12: TPanel;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet5: TTabSheet;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    FeesPanel: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Prp_VSFee: TEdit;
    Prp_SFee: TEdit;
    Prp_AFee: TEdit;
    Prp_CFee: TEdit;
    Prp_VCFee: TEdit;
    FooterPanel: TPanel;
    Label22: TLabel;
    InvFoot1: TEdit;
    InvFoot2: TEdit;
    InvFoot3: TEdit;
    InvFoot4: TEdit;
    InvFoot5: TEdit;
    BillOptionPanel: TPanel;
    Label24: TLabel;
    vtShape1: TvtShape;
    ListBox1: TListBox;
    Prp_Bill: TEdit;
    FeesBtn: TBitBtn;
    GstPanel: TPanel;
    Label10: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label13: TLabel;
    Prp_GstNo: TEdit;
    Opr_GstHst: TEdit;
    HourlyPanel: TPanel;
    Label25: TLabel;
    Prp_Hour: TEdit;
    Panel13: TPanel;
    ScrollBox3: TScrollBox;
    Label46: TLabel;
    Label47: TLabel;
    Prior1Lbl: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label52: TLabel;
    Bevel1: TBevel;
    Label53: TLabel;
    TyT: TLabel;
    CurDirLbl: TLabel;
    SelectCurBtn: TBitBtn;
    SelectDefBtn: TBitBtn;
    SelectL1Btn: TBitBtn;
    Dir_Cur: TEdit;
    Dir_Deflt: TEdit;
    Dir_LastYr: TEdit;
    Panel17: TPanel;
    Label36: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label31: TLabel;
    Panel5: TPanel;
    ScrollBox4: TScrollBox;
    Panel19: TPanel;
    ScrollBox5: TScrollBox;
    DefaultsPanel: TGroupBox;
    Label70: TLabel;
    Label63: TLabel;
    Label71: TLabel;
    Label28: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Prp_Elect: TCheckBox;
    Prp_EfRepr: TCheckBox;
    Prp_Dates: TCheckBox;
    T1013AuthorLevel: TComboBox;
    CVSetting: TComboBox;
    UseCondominiumLine: TCheckBox;
    ShowInvoiceWarning: TCheckBox;
    ShowInvoiceEfCharge: TCheckBox;
    ShowConsultantOnInv: TCheckBox;
    RollOverT4T5: TCheckBox;
    ShowSaluteWarning: TCheckBox;
    Prn_Disclm: TEdit;
    Nfl_Prov: TComboBox;
    Nfl_City: TEdit;
    Nfl_Disced: TRadioGroup;
    Panel21: TPanel;
    ScrollBox6: TScrollBox;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    UpdateFrequency: TEdit;
    Panel14: TPanel;
    Label61: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label72: TLabel;
    Panel26: TPanel;
    ScrollBox7: TScrollBox;
    Nfl_Efile: TCheckBox;
    EfMethodBox: TRadioGroup;
    SetupEOLBtn: TBitBtn;
    SetupEOLPBtn: TBitBtn;
    Panel28: TPanel;
    Panel7: TPanel;
    ColorDialog1: TColorDialog;
    TabSheet4: TTabSheet;
    Panel23: TPanel;
    Label77: TLabel;
    TabSheet8: TTabSheet;
    Panel24: TPanel;
    Clr1: TvtLabel;
    Clr3: TvtLabel;
    Clr4: TvtLabel;
    Clr5: TvtLabel;
    Clr6: TvtLabel;
    clr7: TvtLabel;
    clr8: TvtLabel;
    Clr9: TvtLabel;
    Clr10: TvtLabel;
    Clr11: TvtLabel;
    Clr2: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    Label80: TLabel;
    Panel25: TPanel;
    FormSizePanel: TPanel;
    Label75: TLabel;
    Label57: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    FormZoom: TEdit;
    SetDisplayPanel: TPanel;
    Label9: TLabel;
    Label37: TLabel;
    SetDisplayBtn: TBitBtn;
    NavigPanel: TPanel;
    Label38: TLabel;
    ShowFinWarning: TCheckBox;
    UseFormSearch: TCheckBox;
    BoldDataPanel: TPanel;
    Label76: TLabel;
    DataInBold: TCheckBox;
    Clr0: TvtLabel;
    ScrollBox8: TScrollBox;
    LoginPanel: TPanel;
    Label48: TLabel;
    Label55: TLabel;
    SingleLoginId: TEdit;
    SkipLogin: TCheckBox;
    PswPanel: TPanel;
    Label56: TLabel;
    SetPgmPswBtn: TBitBtn;
    RemovePgmPswBtn: TBitBtn;
    Panel27: TPanel;
    ScrollBox9: TScrollBox;
    Panel29: TPanel;
    HeadersPanel: TPanel;
    Label59: TLabel;
    Prn_NameH: TCheckBox;
    Prn_SinH: TCheckBox;
    Prn_DateH: TCheckBox;
    FullPrintPanel: TPanel;
    UseFastPrint: TCheckBox;
    Label78: TLabel;
    IdentPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label14: TLabel;
    Label40: TLabel;
    Prp_Street: TEdit;
    Prp_City: TEdit;
    Prp_Prov: TComboBox;
    Prp_countr: TEdit;
    Prp_Postal: TEdit;
    Prp_Area: TEdit;
    Prp_Tel: TEdit;
    Prp_Fax: TEdit;
    Prp_FxArea: TEdit;
    Prp_Name: TEdit;
    DiscounterPanel: TPanel;
    Label11: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Prp_DiscNo: TEdit;
    Prp_DiscNm: TEdit;
    Label79: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    ColorsPanel: TPanel;
    Label41: TLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    UseDefaultBoxColor: TBitBtn;
    LinkedBoxColor: TEdit;
    ProtectedBoxColor: TEdit;
    ActiveBoxColor: TEdit;
    CreateNewDirBtn: TBitBtn;
    LogoPanel: TPanel;
    Label84: TLabel;
    DiscountPanel: TPanel;
    Label58: TLabel;
    AutoSeniorDiscount: TCheckBox;
    Label86: TLabel;
    DiscountForSeniors: TEdit;
    Label87: TLabel;
    ExitBtn: TBitBtn;
    BitBtn2: TBitBtn;
    vtLabel1: TvtLabel;
    ReviewerPanel: TPanel;
    Label51: TLabel;
    Label60: TLabel;
    Reviewer_Name: TEdit;
    Label81: TLabel;
    Label85: TLabel;
    Label88: TLabel;
    Prp_Email: TEdit;
    Reviewer_EMail: TEdit;
    Label89: TLabel;
    Label90: TLabel;
    Label92: TLabel;
    Reviewer_Area: TEdit;
    Reviewer_Tel: TEdit;
    OtherSlipsButtons: TCheckBox;
    Label91: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    SelectDirPlannerBtn: TBitBtn;
    Dir_Planner: TEdit;
    Label95: TLabel;
    Label96: TLabel;
    BackupFrequency: TEdit;
    Label98: TLabel;
    Label97: TLabel;
    LastBackupDir: TEdit;
    Label99: TLabel;
    Label100: TLabel;
    BackupDir: TEdit;
    Label101: TLabel;
    SelectBackupDirBtn: TBitBtn;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Prp_BusNo: TEdit;
    LetterMarginsPanel: TPanel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Prn_LMargin: TEdit;
    Prn_RMargin: TEdit;
    SaveBtn: TBitBtn;
    Label112: TLabel;
    Prp_RepId: TEdit;
    Label113: TLabel;
    FontPanel: TPanel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Prn_FontIncr: TEdit;
    Panel1: TPanel;
    Label117: TLabel;
    HideMostRecent: TCheckBox;
    Panel3: TPanel;
    NoBarCode: TCheckBox;
    Label118: TLabel;
    NoTypeAhead: TCheckBox;
    RolloverProgram: TComboBox;
    Label121: TLabel;
    Label122: TLabel;
    UseProperName: TCheckBox;
    Capitalization: TRadioGroup;
    Label125: TLabel;
    Panel4: TPanel;
    Label120: TLabel;
    Label124: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label129: TLabel;
    InvPrefix: TEdit;
    Label130: TLabel;
    InvStartNo: TEdit;
    Label131: TLabel;
    InvSuffix: TEdit;
    SerializeInvoice: TCheckBox;
    Label128: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    Opr_PST: TEdit;
    Label134: TLabel;
    ShowUsedForms: TCheckBox;
    DecimalAssume: TCheckBox;
    OpenAtLastForm: TCheckBox;
    Label136: TLabel;
    Label137: TLabel;
    Prp_FirstName: TEdit;
    Prp_LastName: TEdit;
    Label135: TLabel;
    Label138: TLabel;
    Dir_PgmLastYr: TEdit;
    Prp_Citizen: TCheckBox;
    PstOnInvoice: TCheckBox;
    T1013Warn: TRadioGroup;
    Label140: TLabel;
    CVPostSetting: TComboBox;
    Use2YearSummary: TCheckBox;
    EscOption: TRadioGroup;
    Label62: TLabel;
    Dir_ClientDocs: TEdit;
    Label141: TLabel;
    SelectDirClientDocBtn: TBitBtn;
    RetainRetColor: TCheckBox;
    Label142: TLabel;
    MaximizeMainForm: TCheckBox;
    Panel6: TPanel;
    RetainDefaultPrinter: TCheckBox;
    OpenCouple: TCheckBox;
    Bus_Disclm: TEdit;
    Label143: TLabel;
    Label144: TLabel;
    Prn_PIPEDAAll: TCheckBox;
    ShowTaxSavings: TCheckBox;
    Label145: TLabel;
    SelectDBFBtn: TBitBtn;
    Dir_DBFData: TEdit;
    Bevel2: TBevel;
    Label147: TLabel;
    Dir_AutoFill: TEdit;
    Label148: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Dir_PermanentDocs: TEdit;
    btnSelectPermanentDir: TBitBtn;
    cbLockManagerLevel: TComboBox;
    Label146: TLabel;
    Label149: TLabel;
    Label119: TLabel;
    Label39: TLabel;
    Label123: TLabel;
    GroupBox1: TGroupBox;
    Skin: TComboBox;
    //btnUploadLastYearData: TBitBtn; //20180111 Igor
    Label150: TLabel;//20171031 igor
    //20180111 Igor >>>
    GroupBox2: TGroupBox;
    ActiveTabColor: TShape;
    SetActiveTabColor: TBitBtn;
    Label139: TLabel;
    Prp_NameAsTitle: TCheckBox;
    Prn_HideSin: TCheckBox;
    Label54: TLabel;
    FileNameFormat: TRadioGroup;
    Label151: TLabel;
    Label152: TLabel;
    Dir_refile: TEdit;
    SelectRefileBtn: TBitBtn;
    Label153: TLabel; //20200921 Igor
    //20180111 Igor <<<
    Function SaveOptions:Boolean;
   // procedure SaveBtnClick(Sender: TObject);
    Function ValidateOptions:Boolean;
    procedure SaveOptionsToFile;
    procedure LoadOptionsToForm;
   // Procedure SaveOptionValue(FieldNm:String;Value:String;TempList:TStringList);
    Function CheckBoxToText(ACheckBox:TCheckBox):String;
    procedure FormCreate(Sender: TObject);
    procedure SelectCurBtnClick(Sender: TObject);
    procedure SelectDefBtnClick(Sender: TObject);
    procedure SelectL1BtnClick(Sender: TObject);
    Function  EditDirectory(DirName: string; ALastYearDir: Boolean = False): boolean; //20160229 Igor
    procedure FeesBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure SetupEOLBtnClick(Sender: TObject);
    procedure SetupEOLPBtnClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SetPgmPswBtnClick(Sender: TObject);
    procedure RemovePgmPswBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject); //20200914 Igor
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExitBtnClick(Sender: TObject);
    procedure UseDefaultBoxColorClick(Sender: TObject);
    procedure Clr0Click(Sender: TObject);
    procedure clr7Click(Sender: TObject);
    procedure clr8Click(Sender: TObject);
    procedure Clr9Click(Sender: TObject);
    procedure Clr10Click(Sender: TObject);
    procedure Clr11Click(Sender: TObject);
    procedure CreateNewDirBtnClick(Sender: TObject);
   // procedure SelectLogoBtnClick(Sender: TObject);
   // procedure Prn_LogoClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LogoFileExit(Sender: TObject);
    procedure LogoFileKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SelectDirPlannerBtnClick(Sender: TObject);
    procedure SelectBackupDirBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure Prn_FontIncrChange(Sender: TObject);
    procedure SkipLoginClick(Sender: TObject);
    procedure SelectDirClientDocBtnClick(Sender: TObject);
    procedure SelectDBFBtnClick(Sender: TObject);
    procedure btnSelectPermanentDirClick(Sender: TObject);
    //20171031 igor>>>
    procedure RolloverProgramChange(Sender: TObject);
    //procedure btnUploadLastYearDataClick(Sender: TObject); //20180111 Igor
    procedure SetActiveTabColorClick(Sender: TObject);
    procedure FileNameFormatClick(Sender: TObject); //20180111 Igor
    //20171031 igor<<<
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

var
  OptionsFrm: TOptionsFrmT1_2026;

implementation

{$IFDEF v2013}
uses UselectDir,Main,UFeatures;
{$ELSE}
uses vtMulti,vtMain,vtCommon,vtDialogs,T1_2026,T1_2026TrimStr,T1_2026Declare,
  T1_2026Common,T1_2026T1Rtns,T1_2026Fees,T1_2026EOLSetup,T1_2026EOLPSetup,
  T1_2026ChildWinNew,
//T1_2026SelectFile,
  T1_2026Calc,T1_2026Main,T1_2026Features,
  vtTrimStr,vtShared,
  vtHelperManager, //20170124 Igor
  vtForm;//20170811 Igor
{$ENDIF}

{$R *.DFM}



Function TOptionsFrmT1_2026.SaveOptions:Boolean;
//20171031 igor>>>
Var
  TempList: TStringList;
begin
  Result := False;
  If ValidateOptions = True then
  begin
    TempList := TstringList.Create;
    try
      TempList.Add(InvStartNo.text);
      TempList.SaveToFile(AppDir+'\'+'NextInvNo.d');
    finally
      TempList.Free;
    end;

    SaveOptionsToFile;
    LoadOptionsFileToMem;
    TempList:=TStringList.Create;
    try
      TempList.Add(Dir_Cur.Text);
      TempList.Add(Dir_LastYr.Text);
      TempList.Add(Dir_DBFData.Text); //20160226 Igor
      TempList.SaveToFile(AppDir+'/'+'DIRS.d');
    finally
      TempList.Free;
    end;
    MainFormT1.ShowMostRecentReturns;
  end;
//20171031 igor<<<
end;

Function TOptionsFrmT1_2026.ValidateOptions: Boolean;
//20170811 Igor>>>
Var
  Err: String;
begin
  Try
    If not IsDataDirectoryGood(Dir_Cur.Text) then
    begin
      TvtForm.SafeSetFocus(Dir_Cur);
      exit(False);
    end;
    If not IsDataDirectoryGood(Dir_Deflt.Text) then
    begin
      TvtForm.SafeSetFocus(Dir_Deflt);
      exit(False);
    end;

    {
    If not IsDataDirectoryGood(Dir_refile.Text) then //20240606
    begin
      TvtForm.SafeSetFocus(Dir_refile);
      exit(False);
    end;
    }
    if SamePath(Dir_Cur.text, Dir_LastYr.text) then //20120131
    begin
      ShowMessage('Current Directory and Last Year directory cannot be the same');
      TvtForm.SafeSetFocus(Dir_LastYr);
      Exit(False);
    end;
    if (dir_DbfData.Text <> '') then
    begin
      if not SysUtils.DirectoryExists(dir_DbfData.Text) then
      Begin
        ShowMessage('Invalid data directory of the T1-2018 production data (prior to Multi-App) '+    //20160305 Igor
                    dir_DbfData.Text +' (it does not exist)');
        TvtForm.SafeSetFocus(Dir_DbfData);
        Exit(False);
      end;
      if not SysUtils.FileExists(IncludeTrailingPathDelimiter(dir_DbfData.Text) + ClientsTable_dbf) then
      Begin
        ShowMessage('Invalid data directory of the T1-2018 production data (prior to Multi-App) '+    //20160305 Igor
                    dir_DbfData.Text +' (file "'+ClientsTable_dbf+'" does not exist).');    //does not exist //20171206
        TvtForm.SafeSetFocus(Dir_DbfData);
        Exit(False);
      end;
      if SamePath(dir_DbfData.Text, dir_Cur.Text) then
      Begin
        ShowMessage('Invalid data directory of the T1-2018 production data (prior to Multi-App) '+   //20160305 Igor
                    dir_DbfData.Text +' (Current Directory and data directory of the T1-2018 production data (prior to Multi-App)'+
                    ' cannot be the same)');
        TvtForm.SafeSetFocus(Dir_DbfData);
        Exit;
      end;
    end;
    if EditDirectory(Dir_Cur.Text) and
       EditDirectory(Dir_Deflt.Text) and
      // EditDirectory(Dir_Refile.Text) and
       EditDirectory(Dir_LastYr.Text, true) and //20160229 Igor
       EditDirectory(Dir_AutoFill.Text) and   //20160307 //20160505 Igor
       EditDirectory(Dir_Planner.Text) and
       EditDirectory(BackUpDir.text) and
       EditDirectory(Dir_ClientDocs.text) and
       EditDirectory(Dir_PermanentDocs.text) then
    begin
      {initialize data bases}
      if not SysUtils.FileExists(IncludeTrailingPathDelimiter(Dir_Cur.Text) + ClientsDbLite) then
        if not InitDataBase(Dir_Cur.Text, Err) then //20171031 igor
        begin
          MessageDlg(Err, mtError, [mbOk], 0);
          TvtForm.SafeSetFocus(Dir_Cur);
          Exit(False);
        end;
      if not SysUtils.FileExists(IncludeTrailingPathDelimiter(Dir_Deflt.Text) + ClientsDbLite) then
        if not InitDataBase(Dir_Deflt.Text, Err) then //20171031 igor
        begin
          MessageDlg(Err, mtError, [mbOk], 0);
          TvtForm.SafeSetFocus(Dir_Deflt);
          Exit(False);
        end;

      {
       //20240606
      if not SysUtils.FileExists(IncludeTrailingPathDelimiter(Dir_Refile.Text) + ClientsDbLite) then
        if not InitDataBase(Dir_Refile.Text, Err) then //20171031 igor
        begin
          MessageDlg(Err, mtError, [mbOk], 0);
          TvtForm.SafeSetFocus(Dir_Refile);
          Exit(False);
        end;
      }
        if not SysUtils.FileExists(IncludeTrailingPathDelimiter(Dir_Planner.Text) + ClientsDbLite) then
          if not InitDataBase(Dir_Planner.Text, Err) then //20171031 igor
          begin
            MessageDlg(Err, mtError, [mbOk], 0);
            TvtForm.SafeSetFocus(Dir_Planner);
            Exit(False);
          end;
    end
    else
      exit(False);
  except
  end;

  if AllTrim(DiscountForSeniors.Text) > '' then
  begin
    if (not RealNumeric(DiscountForSeniors.Text)) or (Vl(DiscountForSeniors.Text) > 100) then
    begin
      ShowMessage('Please enter a valid discount');
      TvtForm.SafeSetFocus(DiscountForSeniors);
      Exit(False);
    end;
  end;

  if ValidEMail(PrP_EMail.text) = False then
  begin
    ShowMessage('Please enter a valid EMail');
    TvtForm.SafeSetFocus(Prp_EMail);
    Exit(False);
  end;
  if ValidEMail(Reviewer_EMail.text) = False then
  begin
    ShowMessage('Please enter a valid Reviewer EMail');
    TvtForm.SafeSetFocus(Reviewer_EMail);
    Exit(False);
  end;

  if AllTrim(InvStartNo.Text) > '' then
  begin
    if (not Numeric(InvStartNo.Text)) then
    begin
      ShowMessage('Please enter a valid Invoice Start No. or remove it');
      TvtForm.SafeSetFocus(InvStartNo);
      Exit(False);
    end;
  end;

  if AllTrim(Prp_VSFee.Text) > '' then
  begin
    if (not RealNumeric(Prp_VSFee.Text)) then
    begin
      ShowMessage('Please enter a valid amount');
      TvtForm.SafeSetFocus(Prp_VSFee);
      Exit(False);
    end;
  end;

  if AllTrim(Prp_SFee.Text) > '' then
  begin
    if (not RealNumeric(Prp_SFee.Text)) then
    begin
      ShowMessage('Please enter a valid amount');
      TvtForm.SafeSetFocus(Prp_SFee);
      Exit(False);
    end;
  end;

  if AllTrim(Prp_AFee.Text) > '' then
  begin
    if (not RealNumeric(Prp_AFee.Text)) then
    begin
      ShowMessage('Please enter a valid amount');
      TvtForm.SafeSetFocus(Prp_AFee);
      Exit(False);
    end;
  end;

  if AllTrim(Prp_CFee.Text) > '' then
  begin
    if (not RealNumeric(Prp_CFee.Text)) then
    begin
      ShowMessage('Please enter a valid amount');
      TvtForm.SafeSetFocus(Prp_CFee);
      Exit(False);
    end;
  end;

  if AllTrim(UpdateFrequency.Text) > '' then
  begin
    if (not Numeric(UpdateFrequency.Text)) then
    begin
      ShowMessage('Please enter a valid number');
      TvtForm.SafeSetFocus(UpdateFrequency);
      Exit(False);
    end;
  end;

  if AllTrim(Prp_VCFee.Text) > '' then
  begin
    if (not RealNumeric(Prp_VCFee.Text)) then
    begin
      ShowMessage('Please enter a valid amount');
      TvtForm.SafeSetFocus(Prp_VCFee);
      Exit(False);
    end;
  end;

  if AllTrim(Prp_Hour.Text) > '' then
  begin
    if (not RealNumeric(Prp_Hour.Text)) then
    begin
      ShowMessage('Please enter a valid amount');
      TvtForm.SafeSetFocus(Prp_Hour);
      Exit(False);
    end;
  end;

  if AllTrim(Opr_GstHst.Text) > '' then
  begin
    if (not RealNumeric(Opr_GstHst.Text)) or (Vl(Opr_GstHst.Text) > 100) then
    begin
      ShowMessage('Please enter a valid percentage');
      TvtForm.SafeSetFocus(Opr_GstHst);
      Exit(False);
    end;
  end;

  if AllTrim(Opr_PST.Text) > '' then
  begin
    if (not RealNumeric(Opr_PST.Text)) or (Vl(Opr_PST.Text) > 100) then
    begin
      ShowMessage('Please enter a valid percentage');
      TvtForm.SafeSetFocus(Opr_PST);
      Exit(False);
    end;
  end;

  Result := True;
//20170811 Igor<<<
end;


Function TOptionsFrmT1_2026.CheckBoxToText(ACheckBox:TCheckBox):String;
begin
 If ACheckBox.Checked then result:='X' else Result:='';
end;


procedure TOptionsFrmT1_2026.SaveOptionsToFile;
Var i,j,jj:Integer; ABox:TEdit;AControl:TControl;TempList:TStringList;s:String;
begin
 {Local project options}
 TempList:=TStringList.Create;
 Screen.Cursor:=crHourGlass;
 //save values
   SaveOptionValue(Dir_Cur.Name,Dir_Cur.Text,TempList);
   SaveOptionValue(Dir_ClientDocs.Name,Dir_ClientDocs.Text,TempList);
   SaveOptionValue(Dir_PermanentDocs.Name,Dir_PermanentDocs.Text,TempList); //20170130 Igor
   SaveOptionValue(BackUpFrequency.Name,BackUpFrequency.Text,TempList);
   SaveOptionValue(BackupDir.Name,BackUpDir.Text,TempList);
   SaveOptionValue(LastBackupDir.Name,LastBackUpDir.Text,TempList);
   SaveOptionValue(Dir_Deflt.Name,Dir_Deflt.Text,TempList);
   SaveOptionValue(Dir_Planner.Name,Dir_Planner.Text,TempList);
   SaveOptionValue(Dir_LastYr.Name,Dir_LastYr.Text,TempList);
   SaveOptionValue(Dir_AutoFill.Name,Dir_AutoFill.Text,TempList);  //20160307 //20160505 Igor
   SaveOptionValue(Dir_PgmLastYr.Name,Dir_PgmLastYr.Text,TempList);
   SaveOptionValue(Dir_DBFData.Name,Dir_DBFData.Text,TempList); //20160226 Igor
   SaveOptionValue(Prp_Name.Name,Prp_Name.Text,TempList);
   SaveOptionValue(Prp_NameAsTitle.Name,CheckBoxToText(Prp_NameAsTitle),TempList); //20191202 Igor
   SaveOptionValue(Prp_FirstName.Name,Prp_FirstName.Text,TempList);
   SaveOptionValue(Prp_LastName.Name,Prp_LastName.Text,TempList);
   SaveOptionValue(Prp_RepId.Name,Prp_RepId.Text,TempList);

//   SaveOptionValue(Prn_LMargin.Name,Prn_LMargin.Text,TempList); //20160204 Igor
//   SaveOptionValue(Prn_RMargin.Name,Prn_RMargin.Text,TempList); //20160204 Igor
//   SaveOptionValue(Prn_FontIncr.Name,Prn_FontIncr.Text,TempList); //20160204 Igor

   SaveOptionValue(Prp_EMail.Name,Prp_EMail.Text,TempList);
   SaveOptionValue(Prp_BusNo.Name,Prp_BusNo.Text,TempList);
   SaveOptionValue(Reviewer_EMail.Name,Reviewer_EMail.Text,TempList);
   SaveOptionValue(Reviewer_Name.Name,Reviewer_Name.Text,TempList);
   SaveOptionValue(Reviewer_Area.Name,Reviewer_Area.Text,TempList);
   SaveOptionValue(Reviewer_Tel.Name,Reviewer_Tel.Text,TempList);

   SaveOptionValue(Prp_Street.Name,Prp_Street.Text,TempList);
   SaveOptionValue(Prp_City.Name,Prp_City.Text,TempList);
   SaveOptionValue(Prp_Prov.Name,Prp_Prov.Text,TempList);
   SaveOptionValue(Prp_Postal.Name,Prp_Postal.Text,TempList);
   SaveOptionValue(Prp_Countr.Name,Prp_Countr.Text,TempList);
   SaveOptionValue(Prp_Area.Name,Prp_Area.Text,TempList);
   SaveOptionValue(Prp_Tel.Name,Prp_Tel.Text,TempList);
   SaveOptionValue(Prp_FxArea.Name,Prp_FxArea.Text,TempList);
   SaveOptionValue(Prp_Fax.Name,Prp_Fax.Text,TempList);
   SaveOptionValue(Prp_DiscNo.Name,Prp_DiscNo.Text,TempList);
   SaveOptionValue(Prp_DiscNm.Name,Prp_DiscNm.Text,TempList);
   SaveOptionValue(Prp_GSTNo.Name,Prp_GSTNo.Text,TempList);
   SaveOptionValue(Prp_Bill.Name,Prp_Bill.Text,TempList);
   SaveOptionValue(Prp_VSFee.Name,Prp_VSFee.Text,TempList);
   SaveOptionValue(Prp_SFee.Name,Prp_SFee.Text,TempList);
   SaveOptionValue(Prp_AFee.Name,Prp_AFee.Text,TempList);
   SaveOptionValue(Prp_CFee.Name,Prp_CFee.Text,TempList);
   SaveOptionValue(Prp_VCFee.Name,Prp_VCFee.Text,TempList);
   SaveOptionValue(Prp_Hour.Name,Prp_Hour.Text,TempList);

   SaveOptionValue(Prp_Elect.Name,CheckBoxToText(Prp_Elect),TempList);
   SaveOptionValue(Prp_Citizen.Name,CheckBoxToText(Prp_Citizen),TempList);
   SaveOptionValue(Prp_EfRepr.Name,CheckBoxToText(Prp_EfRepr),TempList);
   SaveOptionValue(Prp_Dates.Name,CheckBoxToText(Prp_Dates),TempList);
   SaveOptionValue(Nfl_Prov.Name,Nfl_Prov.Text,TempList);
   SaveOptionValue(Nfl_City.Name,Nfl_City.Text,TempList);
   //compens
   s:='1';
   If Nfl_Disced.ItemIndex =0  then s:='1'
   else If Nfl_Disced.ItemIndex =1  then s:='2'
   else If Nfl_Disced.ItemIndex =2  then s:='3';
   SaveOptionValue(Nfl_Disced.Name,s,TempList);

   If Capitalization.ItemIndex =0  then s:='UpperCase'
   else If Capitalization.ItemIndex =1  then s:='ProperCase'
   else If Capitalization.ItemIndex =2  then s:='None';
   SaveOptionValue(Capitalization.Name,s,TempList);

   If T1013Warn.ItemIndex =0  then s:='IfNotLastYear'
   else If T1013Warn.ItemIndex =1  then s:='Never'
   else If T1013Warn.ItemIndex =2  then s:='Always';
   SaveOptionValue(T1013Warn.Name,s,TempList);

   s:='CloseForm';
   If EscOption.ItemIndex =1  then s:='GoToSummary';
   SaveOptionValue(EscOption.Name,s,TempList);

   SaveOptionValue(Nfl_Efile.Name,CheckBoxToText(Nfl_Efile),TempList);
   If EfMethodBox.itemindex=0 then
    SaveOptionValue('Ef_Method','EOL',TempList)
   else
    SaveOptionValue('Ef_Method','EOLP',TempList);
  // SaveOptionValue(Prn_Shade.Name,CheckBoxToText(Prn_Shade),TempList);
   SaveOptionValue(Prn_NameH.Name,CheckBoxToText(Prn_NameH),TempList);
   SaveOptionValue(Prn_PIPEDAAll.Name,CheckBoxToText(Prn_PIPEDAAll),TempList);  //20140316
   SaveOptionValue(Prn_SinH.Name,CheckBoxToText(Prn_SinH),TempList);
   SaveOptionValue(Prn_HideSin.Name,CheckBoxToText(Prn_HideSin),TempList);
   SaveOptionValue(Prn_DateH.Name,CheckBoxToText(Prn_DateH),TempList);
   SaveOptionValue(Prn_Disclm.Name,Prn_Disclm.Text,TempList);
   SaveOptionValue(Bus_Disclm.Name,Bus_Disclm.Text,TempList);
   //SaveOptionValue(Prn_Logo.Name,CheckBoxToText(Prn_Logo),TempList);
   //SaveOptionValue(Prn_logoln.Name,Prn_logoln.Text,TempList);
   //SaveOptionValue(LogoFile.Name,LogoFile.Text,TempList);
  // SaveOptionValue(Opr_Close.Name,CheckBoxToText(Opr_Close),TempList); //20090816
  //? SaveOptionValue(Opr_FPres.Name,CheckBoxToText(Opr_FPres),TempList);
   SaveOptionValue(Opr_GstHst.Name,Opr_GstHst.Text,TempList);
   SaveOptionValue(Opr_PST.Name,Opr_PST.Text,TempList);

   //other options
   //SaveOptionValue(ShowTreeViewSw.Name,CheckBoxToText(ShowTreeViewSw),TempList);
   SaveOptionValue(ShowFinWarning.Name,CheckBoxToText(ShowFinWarning),TempList);
   SaveOptionValue(ShowConsultantOnInv.Name,CheckBoxToText(ShowConsultantOnInv),TempList);
   SaveOptionValue(UseFastPrint.Name,CheckBoxToText(UseFastPrint),TempList);
   SaveOptionValue(UseProperName.Name,CheckBoxToText(UseProperName),TempList);
   SaveOptionValue(UseFormSearch.Name,CheckBoxToText(UseFormSearch),TempList);
   SaveOptionValue(RetainRetColor.Name,CheckBoxToText(RetainRetColor),TempList);
   SaveOptionValue(Use2YearSummary.Name,CheckBoxToText(Use2YearSummary),TempList);
   SaveOptionValue(OpenCouple.Name,CheckBoxToText(OpenCouple),TempList);
   SaveOptionValue(PstOnInvoice.Name,CheckBoxToText(PstOnInvoice),TempList);
   SaveOptionValue(OtherSlipsButtons.Name,CheckBoxToText(OtherSlipsButtons),TempList);
   SaveOptionValue(ShowUsedForms.Name,CheckBoxToText(ShowUsedForms),TempList);
   SaveOptionValue(OpenAtLastForm.Name,CheckBoxToText(OpenAtLastForm),TempList);
   SaveOptionValue(UseCondominiumLine.Name,CheckBoxToText(UseCondominiumLine),TempList);
   SaveOptionValue(NoTypeAhead.Name,CheckBoxToText(NoTypeAhead),TempList);
   SaveOptionValue(RolloverT4T5.Name,CheckBoxToText(RolloverT4T5),TempList);
   SaveOptionValue(DecimalAssume.Name,CheckBoxToText(DecimalAssume),TempList);
   //SaveOptionValue(ShowVisitedForms.Name,CheckBoxToText(ShowVisitedForms),TempList);
   SaveOptionValue(ShowInvoiceWarning.Name,CheckBoxToText(ShowInvoiceWarning),TempList);
   SaveOptionValue(ShowTaxSavings.Name,CheckBoxToText(ShowTaxSavings),TempList);//20160119 Igor
   SaveOptionValue(ShowInvoiceEfCharge.Name,CheckBoxToText(ShowInvoiceEfCharge),TempList);
   SaveOptionValue(ShowSaluteWarning.Name,CheckBoxToText(ShowSaluteWarning),TempList);

   SaveOptionValue(T1013AuthorLevel.Name,T1013AuthorLevel.Text,TempList);
   SaveOptionValue(CVSetting.Name,CVSetting.Text,TempList);
   SaveOptionValue(CVPostSetting.Name,CVPostSetting.Text,TempList);

   SaveOptionValue(UpdateFrequency.Name,UpdateFrequency.Text,TempList);

   SaveOptionValue(SerializeInvoice.Name,CheckBoxToText(SerializeInvoice),TempList);
   SaveOptionValue(InvPrefix.Name,InvPrefix.Text,TempList);
   SaveOptionValue(InvStartNo.Name,InvStartNo.Text,TempList);
   SaveOptionValue(InvSuffix.Name,InvSuffix.Text,TempList);

   SaveOptionValue(InvFoot1.Name,InvFoot1.Text,TempList);
   SaveOptionValue(InvFoot2.Name,InvFoot2.Text,TempList);
   SaveOptionValue(InvFoot3.Name,InvFoot3.Text,TempList);
   SaveOptionValue(InvFoot4.Name,InvFoot4.Text,TempList);
   SaveOptionValue(InvFoot5.Name,InvFoot5.Text,TempList);

   SaveOptionValue(ActiveBoxColor.Name,ActiveBoxColor.Text,TempList);
  // SaveOptionValue(FirstReturnColor.Name,FirstReturnColor.Caption,TempList);

   SaveOptionValue(DataInBold.Name,CheckBoxToText(DataInBold),TempList);
   SaveOptionValue(MaximizeMainForm.Name,CheckBoxToText(MaximizeMainForm),TempList);
   SaveOptionValue(HideMostRecent.Name,CheckBoxToText(HideMostRecent),TempList);
   SaveOptionValue(NoBarCode.Name,CheckBoxToText(NoBarCode),TempList);
   SaveOptionValue(RetainDefaultPrinter.Name,CheckBoxToText(RetainDefaultPrinter),TempList);
   SaveOptionValue(SingleLoginId.Name,SingleLoginId.Text,TempList);
   SaveOptionValue(RolloverProgram.Name,RolloverProgram.Text,TempList);
   SaveOptionValue(SkipLogin.Name,'',TempList);  //20190220
   //SaveOptionValue(SkipLogin.Name,CheckBoxToText(SkipLogin),TempList);
   SaveOptionValue(FormZoom.Name,FormZoom.Text,TempList);

   SaveOptionValue(AutoSeniorDiscount.Name,CheckBoxToText(AutoSeniorDiscount),TempList);
   SaveOptionValue(DiscountForSeniors.Name,DiscountForSeniors.Text,TempList);
//   SaveOptionValue(DropBox_ClientID.Name,DropBox_ClientID.Text,TempList); //20161208 Igor
//   SaveOptionValue(DefaultSaveToCloud.Name,CheckBoxToText(DefaultSaveToCloud),TempList); //20161208 Igor //20170130 Igor

   //20200921 Igor >>>
   s:='0';
   If FileNameFormat.ItemIndex =0  then s:='0'
   else If FileNameFormat.ItemIndex =1  then s:='1';
   SaveOptionValue(FileNameFormat.Name,s,TempList);
   //20200921 Igor <<<

//shared options
   s:='CloseForm';
   If EscOption.ItemIndex =1  then s:='GoToSummary';
   //SaveOptionValue(EscOption.Name,s,TempList);
   MainOptions.EscOption := s;  //EscOption.Name;
   //SaveOptionValue(FormZoom.Name,FormZoom.Text,TempList);
    //not here!
   //SaveOptionValue(MaximizeMainForm.Name,CheckBoxToText(MaximizeMainForm),TempList);
   MainOptions.MaximizeMainForm := MaximizeMainForm.Checked;
   //SaveOptionValue(SingleLoginId.Name,SingleLoginId.Text,TempList);
   MainOptions.SingleLoginId := SingleLoginId.Text;
   //SaveOptionValue(SkipLogin.Name,CheckBoxToText(SkipLogin),TempList);
   MainOptions.SkipLogin := False; //SkipLogin.Checked; //20190220
   //SaveOptionValue(UpdateFrequency.Name,UpdateFrequency.Text,TempList);
   MainOptions.UpdateFrequency := StrToInt(UpdateFrequency.Text);

//   SaveOptionValue(Prn_LMargin.Name,Prn_LMargin.Text,TempList);
   MainOptions.Prn_LMargin := StrToFloat(Prn_LMargin.Text); //20160204 Igor
//   SaveOptionValue(Prn_RMargin.Name,Prn_RMargin.Text,TempList);
   MainOptions.Prn_RMargin := StrToFloat(Prn_RMargin.Text); //20160204 Igor
//   SaveOptionValue(Prn_FontIncr.Name,Prn_FontIncr.Text,TempList);
   MainOptions.Prn_FontIncr := StrToInt(Prn_FontIncr.Text); //20160204 Igor

   MainOptions.LockManagerLevel := TLockManagerLevel(cbLockManagerLevel.ItemIndex); //20170315 Igor

   MainOptions.Skin := TSkin(Skin.ItemIndex);//20170824 Igor
   MainOptions.ActiveTabColor := ActiveTabColor.Brush.Color; //20180111 Igor
   MainOptions.Save;

  TempList.SaveToFile(AppDir+'\'+OptionsFlName);

  TempList.Free;
  Screen.Cursor:=crDefault;
  ShowMessage('Saved');
end;


procedure TOptionsFrmT1_2026.LoadOptionsToForm;
Var i:Integer; TempList:TStringList;s:String;
Begin
 TempList:=TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+ OptionsFlName);
  //Read Values
   Dir_Cur.Text:=GetOptionValue('Dir_Cur',TempList);
   Dir_ClientDocs.Text:=GetOptionValue('Dir_ClientDocs',TempList);
   Dir_PermanentDocs.Text:=GetOptionValue('Dir_PermanentDocs',TempList); //20170130 Igor
   BackUpFrequency.Text:=GetOptionValue('BackUpFrequency',TempList);
   BackUpDir.Text:=GetOptionValue('BackUpDir',TempList);
   LastBackUpDir.Text:=GetOptionValue('LastBackUpDir',TempList);
   Dir_Deflt.Text:=GetOptionValue('Dir_Deflt',TempList);
   Dir_Planner.Text:=GetOptionValue('Dir_Planner',TempList);
   If Dir_Planner.text='' then Dir_Planner.Text:=AppDir+'\'+'Planner';
   Dir_LastYr.Text:=GetOptionValue('Dir_LastYr',TempList);
   Dir_AutoFill.Text:=GetOptionValue('Dir_AutoFill',TempList);    //20160311 //20160505 Igor
   Dir_PgmLastYr.Text:=GetOptionValue('Dir_PgmLastYr',TempList);
   Dir_DBFData.Text:=GetOptionValue(Dir_DBFData.Name,TempList); //20160226 Igor
   Prp_Name.Text:=GetOptionValue('Prp_Name',TempList);
   Prp_NameAsTitle.Checked := StringToBoolean(GetOptionValue('Prp_NameAsTitle',TempList)); //20191202 Igor
   Prp_FirstName.Text:=GetOptionValue('Prp_FirstName',TempList);
   Prp_LastName.Text:=GetOptionValue('Prp_LastName',TempList);
   Prp_RepId.Text:=GetOptionValue('Prp_RepId',TempList);
//   Prn_LMargin.Text:=GetOptionValue('Prn_LMargin',TempList); //20160204 Igor
   Prn_LMargin.Text := FloatToStr(MainOptions.Prn_LMargin); //20160204 Igor
//   Prn_RMargin.Text:=GetOptionValue('Prn_RMargin',TempList); //20160204 Igor
   Prn_RMargin.Text := FloatToStr(MainOptions.Prn_RMargin); //20160204 Igor
//   Prn_FontIncr.Text:=GetOptionValue('Prn_FontIncr',TempList); //20160204 Igor
   Prn_FontIncr.Text := IntToStr(MainOptions.Prn_FontIncr); //20160204 Igor
   Prp_EMail.Text:=GetOptionValue('Prp_EMail',TempList);
   Prp_BusNo.Text:=GetOptionValue('Prp_BusNo',TempList);

   Reviewer_Name.Text:=GetOptionValue('Reviewer_Name',TempList);
   Reviewer_EMail.Text:=GetOptionValue('Reviewer_EMail',TempList);
   Reviewer_Area.Text:=GetOptionValue('Reviewer_Area',TempList);
   Reviewer_Tel.Text:=GetOptionValue('Reviewer_Tel',TempList);

   Prp_Street.Text:=GetOptionValue('Prp_Street',TempList);
   Prp_City.Text:=GetOptionValue('Prp_City',TempList);
   Prp_Prov.Text:=GetOptionValue('Prp_Prov',TempList);
   Prp_Postal.Text:=GetOptionValue('Prp_Postal',TempList);
   Prp_Countr.Text:=GetOptionValue('Prp_Countr',TempList);
   Prp_Area.Text:=GetOptionValue('Prp_Area',TempList);
   Prp_Tel.Text:=GetOptionValue('Prp_Tel',TempList);
   Prp_FxArea.Text:=GetOptionValue('Prp_FxArea',TempList);
   Prp_Fax.Text:=GetOptionValue('Prp_Fax',TempList);
   Prp_DiscNo.Text:=GetOptionValue('Prp_DiscNo',TempList);
   Prp_DiscNm.Text:=GetOptionValue('Prp_DiscNm',TempList);
   Prp_GSTNo.Text:=GetOptionValue('Prp_GSTNo',TempList);
   Prp_Bill.Text:=GetOptionValue('Prp_Bill',TempList);
   Prp_VSFee.Text:=GetOptionValue('Prp_VSFee',TempList);
   Prp_SFee.Text:=GetOptionValue('Prp_SFee',TempList);
   Prp_AFee.Text:=GetOptionValue('Prp_AFee',TempList);
   Prp_CFee.Text:=GetOptionValue('Prp_CFee',TempList);
   Prp_VCFee.Text:=GetOptionValue('Prp_VCFee',TempList);
   Prp_Hour.Text:=GetOptionValue('Prp_Hour',TempList);

   Prp_Elect.Checked:=StringToBoolean(GetOptionValue('Prp_Elect',TempList));
   Prp_Citizen.Checked:=StringToBoolean(GetOptionValue('Prp_Citizen',TempList));
   Prp_EfRepr.Checked:=StringToBoolean(GetOptionValue('Prp_EfRepr',TempList));
   Prp_Dates.Checked:=StringToBoolean(GetOptionValue('Prp_Dates',TempList));
   Nfl_Prov.Text:=GetOptionValue('Nfl_Prov',TempList);
   Nfl_City.Text:=GetOptionValue('Nfl_City',TempList);


   s:=GetOptionValue('Nfl_Disced',TempList);
   If      s='1' then Nfl_Disced.ItemIndex:=0
   else If s='2' then Nfl_Disced.ItemIndex:=1
   else If s='3' then Nfl_Disced.ItemIndex:=2;

   s:=GetOptionValue('Capitalization',TempList);
   If      s='UpperCase' then Capitalization.ItemIndex:=0
   else If s='ProperCase' then Capitalization.ItemIndex:=1
   else If s='None' then Capitalization.ItemIndex:=2
   else Capitalization.ItemIndex:=0;

   s:=GetOptionValue('T1013Warn',TempList);
   If      s='IfNotLastYear' then T1013Warn.ItemIndex:=0
   else If s='Never' then T1013Warn.ItemIndex:=1
   else If s='Always' then T1013Warn.ItemIndex:=2;

   s:=GetOptionValue('EscOption',TempList);
   If      s='CloseForm' then EscOption.ItemIndex:=0
   else If s='GoToSummary' then EscOption.ItemIndex:=1;

   Nfl_Efile.Checked:=StringToBoolean(GetOptionValue('Nfl_Efile',TempList));

   If GetOptionValue('Ef_Method',TempList) ='EOL' then
     EfMethodBox.ItemIndex:=0
   Else If GetOptionValue('Ef_Method',TempList) ='EOLP' then
     EfMethodBox.ItemIndex:=1;
   Prn_NameH.Checked:=StringToBoolean(GetOptionValue('Prn_NameH',TempList));
   Prn_PIPEDAAll.Checked:=StringToBoolean(GetOptionValue('Prn_PIPEDAAll',TempList));
   Prn_SinH.Checked:=StringToBoolean(GetOptionValue('Prn_SinH',TempList));
   Prn_HideSin.Checked:=StringToBoolean(GetOptionValue('Prn_HideSin',TempList));
   Prn_DateH.Checked:=StringToBoolean(GetOptionValue('Prn_DateH',TempList));
   Prn_Disclm.Text:=GetOptionValue('Prn_Disclm',TempList);
   Bus_Disclm.Text:=GetOptionValue('Bus_Disclm',TempList);
   //Prn_Logo.Checked:=StringToBoolean(GetOptionValue('Prn_Logo',TempList));
   //Prn_logoln.Text:=GetOptionValue('Prn_logoln',TempList);
   //LogoFile.Text:=GetOptionValue('LogoFile',TempList);
  // Opr_Close.Checked:=StringToBoolean(GetOptionValue('Opr_Close',TempList)); //20090816
   Opr_GstHst.Text:=GetOptionValue('Opr_GstHst',TempList);
   Opr_PST.Text:=GetOptionValue('Opr_PST',TempList);

   //other options
   ShowFinWarning.Checked:=StringToBoolean(GetOptionValue('ShowFinWarning',TempList));
   ShowConsultantOnInv.Checked:=StringToBoolean(GetOptionValue('ShowConsultantOnInv',TempList));
   UseFastPrint.Checked:=StringToBoolean(GetOptionValue('UseFastPrint',TempList));
   UseProperName.Checked:=StringToBoolean(GetOptionValue('UseProperName',TempList));
   UseFormSearch.Checked:=StringToBoolean(GetOptionValue('UseFormSearch',TempList));
   RetainRetColor.Checked:=StringToBoolean(GetOptionValue('RetainRetColor',TempList));
   Use2YearSummary.Checked:=StringToBoolean(GetOptionValue('Use2YearSummary',TempList));
   OpenCouple.Checked:=StringToBoolean(GetOptionValue('OpenCouple',TempList));
   PstOnInvoice.Checked:=StringToBoolean(GetOptionValue('PstOnInvoice',TempList));
   OtherSlipsButtons.Checked:=StringToBoolean(GetOptionValue('OtherSlipsButtons',TempList));
   ShowUsedForms.Checked:=StringToBoolean(GetOptionValue('ShowUsedForms',TempList));
   OpenAtLastForm.Checked:=StringToBoolean(GetOptionValue('OpenAtLastForm',TempList));
   UseCondominiumLine.Checked:=StringToBoolean(GetOptionValue('UseCondominiumLine',TempList));
   NoTypeAhead.Checked:=StringToBoolean(GetOptionValue('NoTypeAhead',TempList));

   RolloverT4T5.Checked:=StringToBoolean(GetOptionValue('RolloverT4T5',TempList));
   DecimalAssume.Checked:=StringToBoolean(GetOptionValue('DecimalAssume',TempList));
   ShowInvoiceWarning.Checked:=StringToBoolean(GetOptionValue('ShowInvoiceWarning',TempList));
   ShowTaxSavings.Checked:=StringToBoolean(GetOptionValue('ShowTaxSavings',TempList));//20160119 Igor
   ShowInvoiceEfCharge.Checked:=StringToBoolean(GetOptionValue('ShowInvoiceEfCharge',TempList));
   ShowSaluteWarning.Checked:=StringToBoolean(GetOptionValue('ShowSaluteWarning',TempList));
   T1013AuthorLevel.Text:=GetOptionValue('T1013AuthorLevel',TempList);
   CVSetting.Text:=GetOptionValue('CVSetting',TempList);
   CVPostSetting.Text:=GetOptionValue('CVPostSetting',TempList);
   ActiveBoxColor.Text:=GetOptionValue('ActiveBoxColor',TempList);
  // FirstReturnColor.Caption:=GetOptionValue('FirstReturnColor',TempList);
   //update frequency
   UpdateFrequency.Text:=GetOptionValue('UpdateFrequency',TempList);

   //invoice numbering
   SerializeInvoice.Checked:=StringToBoolean(GetOptionValue('SerializeInvoice',TempList));
   InvPrefix.Text:=GetOptionValue('InvPrefix',TempList);
   InvStartNo.Text:=GetOptionValue('InvStartNo',TempList);
   InvSuffix.Text:=GetOptionValue('InvSuffix',TempList);
   // inv footer
   InvFoot1.Text:=GetOptionValue('InvFoot1',TempList);
   InvFoot2.Text:=GetOptionValue('InvFoot2',TempList);
   InvFoot3.Text:=GetOptionValue('InvFoot3',TempList);
   InvFoot4.Text:=GetOptionValue('InvFoot4',TempList);
   InvFoot5.Text:=GetOptionValue('InvFoot5',TempList);

   If ActiveBoxColor.Text='' then ActiveBoxColor.Text:=IntToStr(PinkishColor); //IntToStr(Rgb(160,221,250));
   ActiveBoxColor.Color:=MyStrToInt(ActiveBoxColor.Text);
   ActiveBoxColor.Font.Color:=MyStrToInt(ActiveBoxColor.Text);

   {
   If FirstReturnColor.Caption='' then FirstReturnColor.Caption:=IntToStr(FirstRetColor); //RGB(195,255,255));
   FirstReturnColor.Color:=MyStrToInt(FirstReturnColor.Caption);
   FirstReturnColor.Font.Color:=MyStrToInt(FirstReturnColor.caption);
   }

   DataInBold.Checked:=StringToBoolean(GetOptionValue('DataInBold',TempList));
   MaximizeMainForm.Checked:=StringToBoolean(GetOptionValue('MaximizeMainForm',TempList));
   HideMostRecent.Checked:=StringToBoolean(GetOptionValue('HideMostRecent',TempList));
   NoBarCode.Checked:=StringToBoolean(GetOptionValue('NoBarCode',TempList));
   RetainDefaultPrinter.Checked:=StringToBoolean(GetOptionValue('RetainDefaultPrinter',TempList));
   SingleLoginId.Text:=GetOptionValue('SingleLoginId',TempList);
   RolloverProgram.Text:=GetOptionValue('RolloverProgram',TempList);
   SkipLogin.Checked:=False; //StringToBoolean(GetOptionValue('SkipLogin',TempList)); //20190220
   FormZoom.Text:=GetOptionValue('FormZoom',TempList);

   AutoSeniorDiscount.Checked:=StringToBoolean(GetOptionValue('AutoSeniorDiscount',TempList));
   DiscountForSeniors.Text:=GetOptionValue('DiscountForSeniors',TempList);

   cbLockManagerLevel.ItemIndex := Integer(MainOptions.LockManagerLevel); //20170315 Igor
   //DropBox_ClientID.Text:=GetOptionValue(DropBox_ClientID.Name,TempList); //20161208 Igor
//   DefaultSaveToCloud.Checked := StringToBoolean(GetOptionValue(DefaultSaveToCloud.Name,TempList)); //20161208 Igor //20170130 Igor
   Skin.ItemIndex := Integer(MainOptions.Skin);//20170824 Igor
   ActiveTabColor.Brush.Color := MainOptions.ActiveTabColor; //20180111 Igor

   //20200921 Igor >>>
   s:=GetOptionValue('FileNameFormat',TempList);
   If      s='0' then FileNameFormat.ItemIndex:=0
   else If s='1' then FileNameFormat.ItemIndex:=1;
   //20200921 Igor <<<

   //get colors
   Clr0.Color := ColorList[0];
   Clr1.Color := ColorList[1];
   Clr2.Color := ColorList[2];
   Clr3.Color := ColorList[3];
   Clr4.Color := ColorList[4];
   Clr5.Color := ColorList[5];
   Clr6.Color := ColorList[6];
   Clr7.Color := ColorList[7];
   Clr8.Color := ColorList[8];
   Clr9.Color := ColorList[9];
   Clr10.Color := ColorList[10];
   Clr11.Color := ColorList[11];
   TempList.Free;
end;

procedure TOptionsFrmT1_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 FileNameFormat.ItemIndex:=0;  //20201222
 //Enter as Tab
 KeyPreview:=True;
 //set all form's buttons property Default to False
 //Create an OnKeyPress event for the form like this:

   PageControl1.ActivePage:=TabSheet1;
  //Load dirs
  If FileExists(AppDir+'\'+'Dirs.d') then
  begin
   TempList:=TStringList.Create;
   TempList.LoadFromFile(AppDir+'/'+'DIRS.d');
   Dir_cur.Text:=TempList[0];
   Dir_LastYr.Text:=TempList[1];
   if TempList.Count > 2 then
     Dir_DBFData.Text:=TempList[2]; //20160226 Igor
   TempList.Free;
  end;
  CurDirLbl.Caption := IntToStr(StrToInt(AppYear));
  Prior1Lbl.Caption := IntToStr(StrToInt(AppYear)-1);
  LoadOptionsToForm;
//20171031 igor>>>
  if CheckIsCloud(true) then //20180503 Igor
  begin
    CreateNewDirBtn.Enabled := False;
    Dir_Cur.Enabled := False;
    SelectCurBtn.Enabled := False;
    SelectDefBtn.Enabled := False;
    Dir_Deflt.Enabled := False;
    Dir_AutoFill.Enabled := False;
    Dir_Planner.Enabled := False;
    SelectDirPlannerBtn.Enabled := False;
    Dir_ClientDocs.Enabled := False;
    SelectDirClientDocBtn.Enabled := False;
    Dir_PermanentDocs.Enabled := False;
    btnSelectPermanentDir.Enabled := False;
    Dir_LastYr.Enabled := False;
    SelectL1Btn.Enabled := False;
    Dir_PgmLastYr.Enabled := False;
    SelectBackupDirBtn.Enabled := False;
    BackupDir.Enabled := False;
    //btnUploadLastYearData.Visible := True; //20180111 Igor
  end;
  If Dir_AutoFill.text = '' then
    Dir_AutoFill.text := TPath.Combine(AppDir, 'TddData');
  If (Dir_PgmLastYr.text = '') and not CheckIsCloud(true) then //20180503 Igor
    Dir_PgmLastYr.text := 'C:\T1-' + IntToStr(MyStrToInt(AppYear)-1);
  If (Dir_ClientDocs.text = '') then
    if CheckIsCloud(true) then //20180503 Igor
      Dir_ClientDocs.text := TPath.Combine(AppDir, 'Client Documents')
    else
      Dir_ClientDocs.text := 'C:\T1-'+IntToStr(MyStrToInt(AppYear))+'\Client Documents'+'-'+IntToStr(MyStrToInt(AppYear));
  //20190115 Igor >>>
  if CheckIsCloud(true) then //20180503 Igor
      Dir_PermanentDocs.text := TPath.Combine(AppDir, 'Permanent-Client Documents')
  else If Dir_PermanentDocs.text = '' then
      Dir_PermanentDocs.text:='C:\T1-Permanent-Client Documents';
  //20190115 Igor <<<
  If Prn_FontIncr.Text = '' then
    Prn_FontIncr.Text := '1';
  If Prn_LMargin.text = '' then
    Prn_LMargin.text := '1.0';
  If Prn_RMargin.text = '' then
    Prn_RMargin.text:='0.75';
  if Prn_FontIncr.text = '' then
    Prn_FontIncr.text := '1';
  if FormZoom.text = '' then
    FormZoom.text := IntToStr(GetDefaultScaling);
  if BackUpFrequency.text = '' then
    BackUpFrequency.text := '5';
  if (BackUpDir.text = '') then
    if CheckIsCloud(true) then //20180503 Igor
      BackUpDir.text := TPath.Combine(AppDir, 'BackupTax')
    else
      BackUpDir.text := 'C:\BackupTax\' + AppName + '-' + AppYear;
  if (LicenseLevel in anyLimited) then
    if CheckIsCloud(true) then //20180503 Igor
      Dir_Planner.text := TPath.Combine(AppDir, 'Planner')
    else
      Dir_Planner.text := 'C:\VT-T1Planner'; //20160716
  if Dir_LastYr.Text = '' then
    if RolloverProgram.Text <> '' then
      RolloverProgramChange(RolloverProgram);

  LinkedBoxColor.Text := IntToStr(BrightGreen); //(RGB(151,255,151));
  LinkedBoxColor.Color := BrightGreen; //RGB(151,255,151);
  LinkedBoxColor.Font.Color := BrightGreen; //RGB(151,255,151);

  ProtectedBoxColor.Text := IntToStr(DarkShade); //IntToStr(Rgb(130,130,130));
  ProtectedBoxColor.Color := DarkShade; //Rgb(130,130,130);
  ProtectedBoxColor.Font.Color := DarkShade; //Rgb(130,130,130);

  ColorsPanel.Color := Clr0.Color;
   //If LogoFile.Text='' then LogoFile.Text:=AppDir+'\'+'MyLogo.bmp';
  LoadPluginSettings(AppT1_2026.AppId, UserName, Self, PageControl1); //20170124 Igor
//20171031 igor<<<
  //20191202 Igor >>>
  Prp_NameAsTitle.Enabled := (LicenseLevel in anyMulti);
  if (not Prp_NameAsTitle.Enabled) then
    Prp_NameAsTitle.Checked := False;
  //20191202 Igor <<<
end;

procedure TOptionsFrmT1_2026.SelectCurBtnClick(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    Dir_Cur.Text := DirSelected;
 {
 Application.CreateForm(TSelectDir,SelectDir);
 SelectDir.ShowModal;
 SelectDir.Free;
 If SelectedDir >'' then Dir_Cur.Text := SelectedDir;
 }
end;

procedure TOptionsFrmT1_2026.SelectDBFBtnClick(Sender: TObject); //20160226 Igor
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    Dir_DbfData.Text := DirSelected;
end;

procedure TOptionsFrmT1_2026.SelectDefBtnClick(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    Dir_deflt.Text:=DirSelected;
 (*
 Application.CreateForm(TSelectDir,SelectDir);
 SelectDir.ShowModal;
 SelectDir.Free;
 If SelectedDir >'' then Dir_deflt.Text := SelectedDir;
 *)
end;

procedure TOptionsFrmT1_2026.SelectL1BtnClick(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    Dir_LastYr.Text:=DirSelected;
 {
  Application.CreateForm(TSelectDir,SelectDir);
 SelectDir.ShowModal;
 SelectDir.Free;
 If SelectedDir >'' then Dir_LastYr.Text := SelectedDir;
 }
end;

Function TOptionsFrmT1_2026.EditDirectory(DirName: string; ALastYearDir: Boolean = False): boolean; //20160229 Igor
//20171031 igor>>>
Var
  s: String;
begin
  Result := True;
  if UpperCase(DirName) = UpperCase(AppDir) then
  begin
    ShowMessage('You cannot use the Program Directory ' + DirName + Chr(13) + 'as Data Directory');
    result := False;
    exit;
  end;
// 20181103 Why fails? It says dir contains old format , any empty dir
  if not ALastYearDir and FileExists(DirName + '\' + ClientsTable_dbf) then //20160227 Igor //20160229 Igor
  begin
    ShowMessage('This data directory ' + DirName + ' has tax returns with the old format. ' +
                'Please use a different data directory for this program.'); //20160310 Igor
   Result := False;
    exit;
  end;

  s := GetAnyPathMoreThan8Chars(DirName);
  if DirectoryExists(DirName) or (DirName = '') then
    exit;

  {Does Not exist}
  if CheckIsCloud(true) or //20180503 Igor
     (MessageDlg('Directory: ' + DirName + ' does not exist. Create?', mtInformation, [mbYes, mbNo], 0) = mrYes) then
  begin {replied mrYes to create}
    {$I-}   {so that the ioresult can be effective}
    ForceDirectories(DirName); {MkDir(DirName);}
    {$I+}
    if IOResult = 0 then
    begin
      if not CheckIsCloud(true) then //20180503 Igor
        MessageDlg('Directory: ' + DirName + ' created', mtInformation, [mbOk], 0);
      exit;
    end
    else
    begin
      MessageDlg('Directory: ' + DirName + chr(13) + ' cannot be created', mtInformation, [mbOk], 0);
      Result := False;
      exit;
    end;
  end
  else  {replied mrNo}
  begin
    result := False;
    exit;
  end;
//20171031 igor<<<
end;


procedure TOptionsFrmT1_2026.FeesBtnClick(Sender: TObject);
begin
 If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 If RetInMem>0 then
  begin ShowMessage('Close all returns first');exit;end;
  ExecuteForm(TFeesT1_2026);
end;

procedure TOptionsFrmT1_2026.FileNameFormatClick(Sender: TObject);
begin
 FileNameFormat.ItemIndex:=0;  //20201222
end;

procedure TOptionsFrmT1_2026.ListBox1Click(Sender: TObject);
begin
 Prp_bill.Text := AllTrim(IntToStr(ListBox1.ItemIndex));
end;

procedure TOptionsFrmT1_2026.SetupEOLBtnClick(Sender: TObject);
begin
  ExecuteForm(TEOLSetupT1_2026);
end;

procedure TOptionsFrmT1_2026.SetupEOLPBtnClick(Sender: TObject);
begin
  ExecuteForm(TEOLPSetupT1_2026);
end;

procedure TOptionsFrmT1_2026.BitBtn2Click(Sender: TObject);
begin
  ShowHelp('T1Help','Preparer_information');
end;

procedure TOptionsFrmT1_2026.BitBtn3Click(Sender: TObject);
begin
//howHelp('Data Directories');
end;

procedure TOptionsFrmT1_2026.btnSelectPermanentDirClick(Sender: TObject);
Var
  DirSelected: String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    Dir_PermanentDocs.Text := DirSelected;
end;
//20180111 Igor>>>
{
procedure TOptionsFrmT1_2026.btnUploadLastYearDataClick(Sender: TObject);//20170927 igor
begin
  if not StartParams.isCloud then
    Exit;
  if TDirectory.Exists(Dir_LastYr.Text) AND not TDirectory.IsEmpty(Dir_LastYr.Text) then
  begin
    case MessageDlg('LastYear data directory not empty! Rewrite?', mtWarning, [mbYes, mbCancel], 0) of
      mrYes:
        begin
          if MessageDlg('After you click "OK" the directory with the data of the previous year will be cleared'+
                          ' and you will be offered a choice of files with the data of the previous year on your computer.'+
                          ' Select the necessary files' +
                          IfThen(SameText(RolloverProgram.Text, 'VisualTax'),
                            ', including the database file "Clients_T1.db"','') + '.', mtInformation, [mbOK, mbCancel], 0) <> mrOk then
            Exit;
        end;
    else
      Exit;
    end;
  end
  else
    if MessageDlg('After you click "OK" you will be offered a choice of files with the data of the previous year on your computer.'+
                  ' Select the necessary files' +
                  IfThen(SameText(RolloverProgram.Text, 'VisualTax'),
                  ', including the database file "Clients_T1.db"','') + '.', mtInformation, [mbOK, mbCancel], 0) <> mrOk then
      Exit;
  UploadFile(Dir_LastYr.Text, True);
end;
}
//20180111 Igor<<<
procedure TOptionsFrmT1_2026.SetActiveTabColorClick(Sender: TObject); //20180111 Igor
begin
  ColorDialog1.Color := ActiveTabColor.Brush.Color;
  if ColorDialog1.Execute then
    ActiveTabColor.Brush.Color := ColorDialog1.Color;
end;

procedure TOptionsFrmT1_2026.SetPgmPswBtnClick(Sender: TObject);
begin
  SetThePgmPsw;
 SkipLogin.Checked:=False;
end;

procedure TOptionsFrmT1_2026.RemovePgmPswBtnClick(Sender: TObject);
begin
 RemovePgmPsw;
 ShowTimedMsg('Program Password Removed',1000);
end;
//20171031 Igor>>>
procedure TOptionsFrmT1_2026.RolloverProgramChange(Sender: TObject);//20170927 igor
begin
  if CheckIsCloud(true) then //20180503 Igor
  begin
    Dir_LastYr.Text := TPath.Combine(AppDir, 'LastYear' + TPath.DirectorySeparatorChar + RolloverProgram.Text);
  end;
end;
//20171031 Igor<<<
procedure TOptionsFrmT1_2026.FormPaint(Sender: TObject);
begin
 If Dir_ClientDocs.text='' then Dir_ClientDocs.text:='C:\T1-'+IntToStr(MyStrToInt(AppYear))+'\Client Documents'+'-'+IntToStr(MyStrToInt(AppYear));
 ActiveBoxColor.Font.Color :=ActiveBoxColor.Color;
 SkipLogin.Checked := False; //20190220
 {//20190220
 If LicenseLevel in anyMulti then
 begin
  SkipLogin.Checked := False;
  SkipLogin.Enabled := False;
 end;
 }
end;

procedure TOptionsFrmT1_2026.FormShow(Sender: TObject); //20200914 Igor
var nMaxHeight: integer;
begin
  if not CheckIsCloud(true) then Exit;
  nMaxHeight := Application.MainForm.Height - 20;
  if Height > nMaxHeight then
    Height := nMaxHeight;
end;

procedure TOptionsFrmT1_2026.ExitBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TOptionsFrmT1_2026.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //if MessageDlg('Save options?',mtWarning, [mbYes, mbNo], 0) = mrYes then
  SaveOptions;
  MainFormT1.ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
  If RetInMem>0 then
  begin
    If RetNo>0 then   //20101219
    begin
      Calc(RetNo,'INFO'); //for capitalization
      RetList[RetNo].MyChild.RefreshActiveForm;
      MainForm.RefreshAuditPanel(RetNo);
    End;
  end;
end;


procedure TOptionsFrmT1_2026.UseDefaultBoxColorClick(Sender: TObject);
begin
 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Select a color';
 SomeList.Add('1. Light Blue (for color consistency');
 SomeList.Add('2. Light Red (for greater visibility)');
 SomeList.Add('3. Select your own (use a light color)');
  SelectedString := PopSomeList(SomeList,SomeCaption);
 //SomeList.Free; //20160301 Igor
 If LeftStr(SelectedString,1) = '1' then
   ActiveBoxColor.Text:= IntToStr(BluishColor) {Rgb(160,221,250))}
 Else If LeftStr(SelectedString,1) = '2' then
  ActiveBoxColor.Text:=IntToStr(PinkishColor) {IntToStr(Rgb(255,128,128)) //redish}
 else  If LeftStr(SelectedString,1) = '3' then
 begin
  if ColorDialog1.Execute then
  begin
   ActiveBoxColor.Text:=IntToStr(ColorToRgb(ColorDialog1.Color));
   ActiveBoxColor.Color:=ColorDialog1.Color;
   ActiveBoxColor.Font.Color:=ActiveBoxColor.Color; //same color hiding
  end;
 end;

 ActiveBoxColor.Color:=MyStrToInt(ActiveBoxColor.Text);
 ActiveBoxColor.Font.Color:=ActiveBoxColor.Color; //same color -hide
 ActiveBoxColor.Refresh;
end;

procedure TOptionsFrmT1_2026.Clr0Click(Sender: TObject);
begin
// SeFirstReturnColor(Sender);
 {
 FirstReturnColor.Caption:=IntToStr(clr0.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 }
end;

procedure TOptionsFrmT1_2026.clr7Click(Sender: TObject);
begin
 (*
 FirstReturnColor.Caption:=IntToStr(clr7.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT1_2026.clr8Click(Sender: TObject);
begin
(*
FirstReturnColor.Caption:=IntToStr(clr8.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT1_2026.Clr9Click(Sender: TObject);
begin
(*
FirstReturnColor.Caption:=IntToStr(clr9.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT1_2026.Clr10Click(Sender: TObject);
begin
(*
 FirstReturnColor.Caption:=IntToStr(clr10.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT1_2026.Clr11Click(Sender: TObject);
begin
(*
 FirstReturnColor.Caption:=IntToStr(clr11.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT1_2026.CreateNewDirBtnClick(Sender: TObject);
Var s:String;
begin
 s:=CreateNewDataDir;
 If s>'' then  Dir_Cur.Text:=s;
end;

(*
procedure TOptionsFrm.SelectLogoBtnClick(Sender: TObject);
Var DirSelected:AnsiString;
begin
 Application.CreateForm(TSelectFile,SelectFile);
 SelectFile.ShowModal;
 SelectFile.Free;
 If SelectedString>'' then
   LogoFile.Text:=SelectedString;
 If IsAcceptableGraphicsFile(LogoFile.Text) = false then
 begin
  ShowMessage('Acceptable graphics files are BMP,JPG,WMF');
  LogoFile.Text:='';
  Exit;
 end;
 If FileExists(LogoFile.Text) then
   LogoImage.Picture.LoadFromFile(LogoFile.Text)
 Else
 begin
   LogoImage.Picture:=Nil;
   Prn_Logo.Checked := False;
 end;
end;

procedure TOptionsFrm.Prn_LogoClick(Sender: TObject);
begin
 If FileExists(LogoFile.Text) = False then
   Prn_Logo.Checked := False;
end;
*)
procedure TOptionsFrmT1_2026.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
//20171031 igor>>>
  if not ValidateOptions then
    CanClose := MessageDlg('Exit with out save?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes
  else
    CanClose := True;
//20171031 igor<<<
end;

procedure TOptionsFrmT1_2026.LogoFileExit(Sender: TObject);
begin
 FormPaint(Sender);
end;

procedure TOptionsFrmT1_2026.LogoFileKeyPress(Sender: TObject; var Key: Char);
begin
 If Key=#13 then FormPaint(Sender);
end;

procedure TOptionsFrmT1_2026.FormKeyPress(Sender: TObject; var Key: Char);
begin
EXIT;  //good but needs work
  if Key = #13 then
  begin
    Key := #0;
    //if (Sender is TDBGrid) then  TDBGrid(Sender).Perform(WM_KeyDown,VK_Tab,0) else
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TOptionsFrmT1_2026.SelectDirPlannerBtnClick(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    Dir_Planner.Text:=DirSelected;
end;

procedure TOptionsFrmT1_2026.SelectBackupDirBtnClick(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    BackupDir.Text:=DirSelected;
end;

procedure TOptionsFrmT1_2026.SaveBtnClick(Sender: TObject);
begin
 SaveOptions;
end;

procedure TOptionsFrmT1_2026.Prn_FontIncrChange(Sender: TObject);
begin
 If MyStrToInt(Prn_FontIncr.Text) >1 then Prn_FontIncr.Text:='1';

end;

procedure TOptionsFrmT1_2026.SkipLoginClick(Sender: TObject);
begin
   //If GetPgmPsw>'' then  //20190220
 SkipLogin.Checked:=False;
end;

procedure TOptionsFrmT1_2026.SelectDirClientDocBtnClick(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    Dir_ClientDocs.Text := DirSelected;
end;

end.
