unit T2_2027optionsfrm;
//revision 2014-07-29

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  vtLabel,ExtCtrls,ComCtrls,Db,Buttons,DBCtrls,Mask,FileCtrl,
  T2_2027TrimStr,T2_2027Declare,vtEditBox,T2_2027Common,T2_2027Fees,vtShape,
  ColorGrd,
  System.IOUtils;  //20180523

  {UCompLogo;}

type
  TOptionsFrmT2_2027 = class(TForm)
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
    FooterPanel: TPanel;
    Label22: TLabel;
    InvFoot1: TEdit;
    InvFoot2: TEdit;
    InvFoot3: TEdit;
    InvFoot4: TEdit;
    InvFoot5: TEdit;
    GstPanel: TPanel;
    Label10: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label13: TLabel;
    Prp_GstNo: TEdit;
    Opr_GstHst: TEdit;
    Panel13: TPanel;
    ScrollBox3: TScrollBox;
    Label46: TLabel;
    Label47: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label53: TLabel;
    SelectCurBtn: TBitBtn;
    SelectDefBtn: TBitBtn;
    SelectL1Btn: TBitBtn;
    Dir_Cur: TEdit;
    Dir_Deflt: TEdit;
    Dir_LastYr: TEdit;
    Panel17: TPanel;
    Label36: TLabel;
    Label42: TLabel;
    Label44: TLabel;
    Panel5: TPanel;
    ScrollBox4: TScrollBox;
    Panel19: TPanel;
    ScrollBox5: TScrollBox;
    DefaultsPanel: TGroupBox;
    Label28: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Prp_Dates: TCheckBox;
    ShowInvoiceWarning: TCheckBox;
    Prn_Disclm: TEdit;
    Nfl_Prov: TComboBox;
    Nfl_City: TEdit;
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
    Panel26: TPanel;
    ScrollBox7: TScrollBox;
    Nfl_Efile: TCheckBox;
    Ef_ThirdParty: TCheckBox;
    SetupEOLBtn: TBitBtn;
    Panel28: TPanel;
    Panel7: TPanel;
    ColorDialog1: TColorDialog;
    TabSheet4: TTabSheet;
    TabSheet8: TTabSheet;
    Panel25: TPanel;
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
    Label26: TLabel;
    Label14: TLabel;
    Label40: TLabel;
    Prp_Street: TEdit;
    Prp_City: TEdit;
    Prp_Prov: TComboBox;
    Prp_Postal: TEdit;
    Prp_Area: TEdit;
    Prp_Tel: TEdit;
    Prp_Fax: TEdit;
    Prp_FxArea: TEdit;
    Prp_Name: TEdit;
    CreateNewDirBtn: TBitBtn;
    LogoPanel: TPanel;
    Label84: TLabel;
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
    Label95: TLabel;
    Label96: TLabel;
    BackupFrequency: TEdit;
    Label98: TLabel;
    Label97: TLabel;
    LastBackupDir: TEdit;
    Label100: TLabel;
    BackupDir: TEdit;
    Label101: TLabel;
    SelectBackupDirBtn: TBitBtn;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label108: TLabel;
    Prp_BusNo: TEdit;
    LetterMarginsPanel: TPanel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Prn_LMargin: TEdit;
    Prn_RMargin: TEdit;
    SaveBtn: TBitBtn;
    FontPanel: TPanel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Prn_FontIncr: TEdit;
    Panel3: TPanel;
    NoBarCode: TCheckBox;
    Label118: TLabel;
    NoTypeAhead: TCheckBox;
    RolloverProgram: TComboBox;
    Label121: TLabel;
    Label122: TLabel;
    UseProperName: TCheckBox;
    Capitalization: TRadioGroup;
    Label11: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label41: TLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    UseDefaultBoxColor: TBitBtn;
    LinkedBoxColor: TEdit;
    ProtectedBoxColor: TEdit;
    ActiveBoxColor: TEdit;
    Label76: TLabel;
    DataInBold: TCheckBox;
    Label75: TLabel;
    Label57: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    FormZoom: TEdit;
    Label117: TLabel;
    HideMostRecent: TCheckBox;
    Label38: TLabel;
    Label62: TLabel;
    Opr_Close: TCheckBox;
    Label9: TLabel;
    Label37: TLabel;
    SetDisplayBtn: TBitBtn;
    Label25: TLabel;
    Prp_Hour: TEdit;
    Label24: TLabel;
    ListBox1: TListBox;
    vtShape1: TvtShape;
    Prp_Bill: TEdit;
    FeesBtn: TBitBtn;
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
    Panel4: TPanel;
    ShowUsedForms: TCheckBox;
    OpenAtLastForm: TCheckBox;
    DecimalAssume: TCheckBox;
    Label70: TLabel;
    Label54: TLabel;
    Prp_ContactFn: TEdit;
    Lbl1: TLabel;
    Prp_RepId: TEdit;
    EscOption: TRadioGroup;
    Label82: TLabel;
    Label141: TLabel;
    Dir_ClientDocs: TEdit;
    SelectDirClientDocBtn: TBitBtn;
    Label83: TLabel;
    Prp_ContactLn: TEdit;
    Label86: TLabel;
    Prp_ContactPos: TEdit;
    Label87: TLabel;
    Label91: TLabel;
    Prp_OrgType: TComboBox;
    Prp_Countr: TComboBox;
    Label12: TLabel;
    SelectDBFBtn: TBitBtn;
    Dir_DBFData: TEdit;
    Label138: TLabel;
    Dir_PgmLastYr: TEdit;
    Label139: TLabel;
    btnDir_PgmLastYr: TBitBtn;
    Panel1: TPanel;
    //20171031 igor>>>
    GroupBox1: TGroupBox;
    Skin: TComboBox;
    //20180111 Igor >>>
    GroupBox2: TGroupBox;
    ActiveTabColor: TShape;
    SetActiveTabColor: TBitBtn;
    Label34: TLabel;
    FileNameFormat: TRadioGroup;
    Label27: TLabel;
    //20180111 Igor <<<
    //20171031 igor<<<
//    Ef_ThirdParty: TCheckBox;
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
    //procedure SetupEOLPBtnClick(Sender: TObject);
    procedure SetDisplayBtnClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SetPgmPswBtnClick(Sender: TObject);
    procedure RemovePgmPswBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
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
    procedure SelectBackupDirBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure Prn_FontIncrChange(Sender: TObject);

    (* //20160523
    procedure Select2006BtnClick(Sender: TObject);
    procedure Select2005BtnClick(Sender: TObject);
    procedure Select2004BtnClick(Sender: TObject);
    procedure Select2003BtnClick(Sender: TObject);
    procedure Select2002BtnClick(Sender: TObject);
    procedure Select2001BtnClick(Sender: TObject);
    *)
    procedure Prp_BusNoExit(Sender: TObject);
    procedure SelectDirClientDocBtnClick(Sender: TObject);
    procedure SelectDBFBtnClick(Sender: TObject);
    procedure btnDir_PgmLastYrClick(Sender: TObject);  //20160226 Igor
    procedure SetActiveTabColorClick(Sender: TObject); //20180111 Igor
    procedure RolloverProgramChange(Sender: TObject); //20180503 Igor

    //Procedure SaveAGroupControl(AControl:TControl;TempList:TStringList);
  private
    FRetNo: integer;
    procedure FixMessage(const msg: string; FocusElm: TWinControl);
  public
    property RetNo: integer read FRetNo;
  end;

var
  OptionsFrmT2_2027: TOptionsFrmT2_2027;

implementation

uses
  vtMulti,vtDialogs,vtCommon,
  T2_2027,T2_2027EOLSetup,T2_2027ChildWinNew,
//T2_2027SelectFile,
  T2_2027Calc,
//T2_2027selectDir,
  T2_2027Main,
  T2_2027Features,
  vtHelperManager, //20190221 Igor
  vtChild,vtMain,vtTrimStr,vtShared, vtForm;//20170811 Igor

{$R *.DFM}



Function TOptionsFrmT2_2027.SaveOptions:Boolean;
Var TempList:TStringList;
begin
 Result:=False;
 If ValidateOptions = True then
 begin
     SaveOptionsToFile;
     LoadOptionsFileToMem;
     TempList:=TStringList.Create;
     TempList.Add(Dir_Cur.Text);
     TempList.Add(Dir_LastYr.Text);
     TempList.Add(Dir_DBFData.Text); //20160226 Igor
     TempList.SaveToFile(AppDir+'/'+'DIRS.d');
     TempList.Free;
     MainFormT2.ShowMostRecentReturns;
 end;
end;

Function TOptionsFrmT2_2027.ValidateOptions:Boolean;
//20170811 Igor >>>
var
  i: Integer;
  Err: String;
begin
  Result := False;
  try
    Prp_busNo.Text := RemoveChar(Prp_busNo.Text, ' ');

    if Length(Prp_busNo.Text) >= 9 then
    begin
      for i := 1 to 9 do
      begin
        if not Numeric(Prp_busNo.Text[i]) then
        begin
          FixMessage('The Business Number is invalid', Prp_busNo);
          TvtForm.SafeSetFocus(Prp_busNo);
          exit;
        end;
      end;
    end;

    if not IsDataDirectoryGood(Dir_Cur.Text) then
    begin
      TvtForm.SafeSetFocus(Dir_Cur);
      exit;
    end;
    if not IsDataDirectoryGood(Dir_Deflt.Text) then
    begin
      TvtForm.SafeSetFocus(Dir_Deflt);
      exit;
    end;

    if SysUtils.DirectoryExists(Dir_Cur.Text) and //20150701
      not FileExists(Dir_Cur.Text + '\' + ClientsDBLite) then //20150922 Igor
      if InitDataBase(AppDir, Dir_Cur.Text, Err) = false then
      begin
        FixMessage(Err, Dir_Cur);
        Exit;
      end;

    if EditDirectory(Dir_Cur.Text) and
       EditDirectory(Dir_Deflt.Text) and
       EditDirectory(Dir_LastYr.Text, true) and
       EditDirectory(Dir_ClientDocs.text) and
       EditDirectory(BackUpDir.text) then
    begin
      {initialize data bases}
      if not FileExists(Dir_Cur.Text + '\' + ClientsDBLite) then //20150922 Igor
        if not InitDataBase(AppDir, Dir_Cur.Text, Err) then
        begin
          FixMessage(Err, Dir_Cur);
          Exit;
        end;
      if FileExists(Dir_Deflt.Text + '\' + ClientsDBLite) = false then //20150922 Igor
        if InitDataBase(AppDir, Dir_Deflt.Text, Err) = false then
        begin
          FixMessage(Err, Dir_Deflt);
          Exit;
        end;
    end
    else
      exit;

  (* 20220303
  //20160226 Igor >>>>
    if (dir_DbfData.Text <> '') then
    begin
      if not directoryExists(dir_DbfData.Text) then
      begin
        FixMessage('Invalid data directory of the T2-2024 production data (prior to Multi-App) ' +  //20160305 Igor
          dir_DbfData.Text + ' (it does not exist)', Dir_DbfData);
        Exit;
      end;
      if not FileExists(dir_DbfData.Text + '\' + ClientsTable_dbf) then
      begin
        FixMessage('Invalid data directory of the T2-2024 production data (prior to Multi-App) ' + //20160305 Igor
          dir_DbfData.Text + ' (file "' + ClientsTable_dbf + '" Dos not exist).', Dir_DbfData);  //does not exist //20171206 CON
        Exit;
      end;

      if SamePath(dir_DbfData.Text, dir_Cur.Text) then
      begin
        FixMessage('Invalid data directory of the T2-2024 production data (prior to Multi-App) ' +  //20160305 Igor
                    dir_DbfData.Text + ' (Current Directory and data directory of the T2-2024 production data (prior to Multi-App)' +
                    ' cannot be the same)', Dir_DbfData);
        Exit;
      end;
    end;
    //20160226 Igor <<<<<
  *)
    if ValidEMail(PrP_EMail.text) = False then
    begin
      FixMessage('Preparer section: Please enter a valid EMail', Prp_EMail);
      Exit;
    end;

    if AllTrim(PrP_Name.text) = '' then
    begin
      FixMessage('Please complete the Preparer section', Prp_Name);
      Exit;
    end;

    //20201207
    if AllTrim(PrP_Postal.text) = '' then
    begin
      FixMessage('Please enter the Postal code', Prp_Postal);
      Exit;
    end;

    if (UpperCase(LeftStr(PrP_Countr.text, 2)) = 'CA') or (UpperCase(LeftStr(PrP_Countr.text, 2)) = 'US') then
    begin
      if Prp_Prov.text = '' then
      begin
        FixMessage('Preparer section: Province/State required', Prp_Prov);
        Exit;
      end;
    end
    else
    begin
      if Prp_Prov.text > '' then
      begin
        FixMessage('Preparer section: Province/State should be removed', Prp_Prov);
        Exit;
      end;
    end;



    if ValidEMail(Reviewer_EMail.text) = False then
    begin
      FixMessage('Preparer section: Please enter a valid Reviewer EMail', Reviewer_EMail);
      Exit;
    end;
    if AllTrim(Prp_OrgType.text) = '' then
    begin
      FixMessage('Preparer section: Please enter Organization type', Prp_OrgType);
      Exit;
    end;

    if AllTrim(Prp_VSFee.Text) > '' then
    begin
      if (not RealNumeric(Prp_VSFee.Text)) then
      begin
        FixMessage('Please enter a valid amount', Prp_VSFee);
        Exit;
      end;
    end;

    if AllTrim(Prp_SFee.Text) > '' then
    begin
      if (not RealNumeric(Prp_SFee.Text)) then
      begin
        FixMessage('Please enter a valid amount', Prp_SFee);
        Exit;
      end;
    end;

    if AllTrim(Prp_AFee.Text) > '' then
    begin
      if (not RealNumeric(Prp_AFee.Text)) then
      begin
        FixMessage('Please enter a valid amount', Prp_AFee);
        Exit;
      end;
    end;

    if AllTrim(Prp_CFee.Text) > '' then
    begin
      if (not RealNumeric(Prp_CFee.Text)) then
      begin
        FixMessage('Please enter a valid amount', Prp_CFee);
        Exit;
      end;
    end;

    if AllTrim(UpdateFrequency.Text) > '' then
    begin
      if (not Numeric(UpdateFrequency.Text)) then
      begin
        FixMessage('Please enter a valid number', UpdateFrequency);
        Exit;
      end;
    end;

    if AllTrim(Prp_VCFee.Text) > '' then
    begin
      if (not RealNumeric(Prp_VCFee.Text)) then
      begin
        FixMessage('Please enter a valid amount', Prp_VCFee);
        Exit;
      end;
    end;

    if AllTrim(Prp_Hour.Text) > '' then
    begin
      if (not RealNumeric(Prp_Hour.Text)) then
      begin
        FixMessage('Please enter a valid amount', Prp_Hour);
        Exit;
      end;
    end;

    if AllTrim(Opr_GstHst.Text) > '' then
    begin
      if (not RealNumeric(Opr_GstHst.Text)) or (Vl(Opr_GstHst.Text) > 100) then
      begin
        FixMessage('Please enter a valid percentage', Opr_GstHst);
        Exit;
      end;
    end;
  except  //20120329
  end;

  Result := True;
  //20170811 Igor<<<
end;


Function TOptionsFrmT2_2027.CheckBoxToText(ACheckBox:TCheckBox):String;
begin
 If ACheckBox.Checked then result:='X' else Result:='';
end;


procedure TOptionsFrmT2_2027.SaveOptionsToFile;
Var TempList:TStringList;s:String;
begin
 TempList:=TStringList.Create;
 Screen.Cursor:=crHourGlass;
 //save values
   SaveOptionValue(Dir_Cur.Name,Dir_Cur.Text,TempList);
   SaveOptionValue(Dir_ClientDocs.Name,Dir_ClientDocs.Text,TempList);
   SaveOptionValue(BackUpFrequency.Name,BackUpFrequency.Text,TempList);
   SaveOptionValue(BackupDir.Name,BackUpDir.Text,TempList);
   SaveOptionValue(LastBackupDir.Name,LastBackUpDir.Text,TempList);
   SaveOptionValue(Dir_Deflt.Name,Dir_Deflt.Text,TempList);
   SaveOptionValue(Dir_LastYr.Name,Dir_LastYr.Text,TempList);
   SaveOptionValue(Dir_PgmLastYr.Name,Dir_PgmLastYr.Text,TempList); //20160424 Igor
   SaveOptionValue(Dir_DBFData.Name,Dir_DBFData.Text,TempList); //20160226 Igor
   {20160523
   SaveOptionValue(Dir2006.Name,Dir2006.Text,TempList);
   SaveOptionValue(Dir2005.Name,Dir2005.Text,TempList);
   SaveOptionValue(Dir2004.Name,Dir2004.Text,TempList);
   SaveOptionValue(Dir2003.Name,Dir2003.Text,TempList);
   SaveOptionValue(Dir2002.Name,Dir2002.Text,TempList);
   SaveOptionValue(Dir2001.Name,Dir2001.Text,TempList);
   }
   SaveOptionValue(Prp_Name.Name,Prp_Name.Text,TempList);
   SaveOptionValue(Prp_ContactFn.Name,Prp_ContactFn.Text,TempList);
   SaveOptionValue(Prp_ContactLn.Name,Prp_ContactLn.Text,TempList);
   SaveOptionValue(Prp_ContactPos.Name,Prp_ContactPos.Text,TempList);
   SaveOptionValue(Prp_RepId.Name,Prp_RepId.Text,TempList);

 //20160719 Igor
//   SaveOptionValue(Prn_LMargin.Name,Prn_LMargin.Text,TempList);
//   SaveOptionValue(Prn_RMargin.Name,Prn_RMargin.Text,TempList);
//   SaveOptionValue(Prn_FontIncr.Name,Prn_FontIncr.Text,TempList);

   SaveOptionValue(Prp_EMail.Name,Prp_EMail.Text,TempList);
   SaveOptionValue(Prp_OrgType.Name,Prp_OrgType.Text,TempList);
   SaveOptionValue(Prp_BusNo.Name,Prp_BusNo.Text,TempList);
   SaveOptionValue(Reviewer_EMail.Name,Reviewer_EMail.Text,TempList);
   SaveOptionValue(Reviewer_Name.Name,Reviewer_Name.Text,TempList);
   SaveOptionValue(Reviewer_Area.Name,Reviewer_Area.Text,TempList);
   SaveOptionValue(Reviewer_Tel.Name,Reviewer_Tel.Text,TempList);

   SaveOptionValue(Prp_Street.Name,Prp_Street.Text,TempList);
   SaveOptionValue(Prp_City.Name,Prp_City.Text,TempList);
   SaveOptionValue(Prp_Prov.Name,LeftStr(Prp_Prov.Text,2),TempList);  //20160813
   SaveOptionValue(Prp_Postal.Name,Prp_Postal.Text,TempList);
   SaveOptionValue(Prp_Countr.Name,LeftStr(Prp_Countr.Text,2),TempList);  //20160813
   SaveOptionValue(Prp_Area.Name,Prp_Area.Text,TempList);
   SaveOptionValue(Prp_Tel.Name,Prp_Tel.Text,TempList);
   SaveOptionValue(Prp_FxArea.Name,Prp_FxArea.Text,TempList);
   SaveOptionValue(Prp_Fax.Name,Prp_Fax.Text,TempList);
   SaveOptionValue(Prp_GSTNo.Name,Prp_GSTNo.Text,TempList);
   SaveOptionValue(Prp_Bill.Name,Prp_Bill.Text,TempList);
   SaveOptionValue(Prp_VSFee.Name,Prp_VSFee.Text,TempList);
   SaveOptionValue(Prp_SFee.Name,Prp_SFee.Text,TempList);
   SaveOptionValue(Prp_AFee.Name,Prp_AFee.Text,TempList);
   SaveOptionValue(Prp_CFee.Name,Prp_CFee.Text,TempList);
   SaveOptionValue(Prp_VCFee.Name,Prp_VCFee.Text,TempList);
   SaveOptionValue(Prp_Hour.Name,Prp_Hour.Text,TempList);

   SaveOptionValue(Prp_Dates.Name,CheckBoxToText(Prp_Dates),TempList);
   SaveOptionValue(Nfl_Prov.Name,Nfl_Prov.Text,TempList);
   SaveOptionValue(Nfl_City.Name,Nfl_City.Text,TempList);

   If Capitalization.ItemIndex =0  then s:='UpperCase'
   else If Capitalization.ItemIndex =1  then s:='ProperCase'
   else {If Capitalization.ItemIndex =2  then} s:='None';
   SaveOptionValue(Capitalization.Name,s,TempList);
   SaveOptionValue(DecimalAssume.Name,CheckBoxToText(DecimalAssume),TempList);
   SaveOptionValue(Nfl_Efile.Name,CheckBoxToText(Nfl_Efile),TempList);
   SaveOptionValue(Ef_ThirdParty.Name,CheckBoxToText(Ef_ThirdParty),TempList);
  // SaveOptionValue(Prn_Shade.Name,CheckBoxToText(Prn_Shade),TempList);
   SaveOptionValue(Prn_NameH.Name,CheckBoxToText(Prn_NameH),TempList);
   SaveOptionValue(Prn_SinH.Name,CheckBoxToText(Prn_SinH),TempList);
   SaveOptionValue(Prn_DateH.Name,CheckBoxToText(Prn_DateH),TempList);
   SaveOptionValue(Prn_Disclm.Name,Prn_Disclm.Text,TempList);
   //SaveOptionValue(Prn_Logo.Name,CheckBoxToText(Prn_Logo),TempList);
   //SaveOptionValue(Prn_logoln.Name,Prn_logoln.Text,TempList);
   //SaveOptionValue(LogoFile.Name,LogoFile.Text,TempList);
   SaveOptionValue(Opr_Close.Name,CheckBoxToText(Opr_Close),TempList);
  //? SaveOptionValue(Opr_FPres.Name,CheckBoxToText(Opr_FPres),TempList);
   SaveOptionValue(Opr_GstHst.Name,Opr_GstHst.Text,TempList);

   SaveOptionValue(UseFastPrint.Name,CheckBoxToText(UseFastPrint),TempList);
   SaveOptionValue(ShowUsedForms.Name,CheckBoxToText(ShowUsedForms),TempList);
   SaveOptionValue(OpenAtLastForm.Name,CheckBoxToText(OpenAtLastForm),TempList);
   SaveOptionValue(UseProperName.Name,CheckBoxToText(UseProperName),TempList);
   SaveOptionValue(NoTypeAhead.Name,CheckBoxToText(NoTypeAhead),TempList);
   SaveOptionValue(ShowInvoiceWarning.Name,CheckBoxToText(ShowInvoiceWarning),TempList);

   SaveOptionValue(InvFoot1.Name,InvFoot1.Text,TempList);
   SaveOptionValue(InvFoot2.Name,InvFoot2.Text,TempList);
   SaveOptionValue(InvFoot3.Name,InvFoot3.Text,TempList);
   SaveOptionValue(InvFoot4.Name,InvFoot4.Text,TempList);
   SaveOptionValue(InvFoot5.Name,InvFoot5.Text,TempList);

   SaveOptionValue(DataInBold.Name,CheckBoxToText(DataInBold),TempList);
   SaveOptionValue(HideMostRecent.Name,CheckBoxToText(HideMostRecent),TempList);
   SaveOptionValue(NoBarCode.Name,CheckBoxToText(NoBarCode),TempList);
   SaveOptionValue(RolloverProgram.Name,RolloverProgram.Text,TempList);

//candidates for shared options
   SaveOptionValue(ActiveBoxColor.Name,ActiveBoxColor.Text,TempList);

//shared options - replace calls!
   s:='CloseForm';
   If EscOption.ItemIndex =1  then s:='GoToSummary';
   //SaveOptionValue(EscOption.Name,s,TempList);
   MainOptions.EscOption := s;  //EscOption.Name;
   //SaveOptionValue(FormZoom.Name,FormZoom.Text,TempList);
    //not here!
   //SaveOptionValue(SingleLoginId.Name,SingleLoginId.Text,TempList);
   MainOptions.SingleLoginId := SingleLoginId.Text;
   //SaveOptionValue(SkipLogin.Name,CheckBoxToText(SkipLogin),TempList);
   MainOptions.SkipLogin := SkipLogin.Checked;
   //SaveOptionValue(UpdateFrequency.Name,UpdateFrequency.Text,TempList);
   MainOptions.UpdateFrequency := StrToInt(UpdateFrequency.Text);

   MainOptions.Prn_LMargin := StrToFloat(Prn_LMargin.Text); //20160719 Igor
   MainOptions.Prn_RMargin := StrToFloat(Prn_RMargin.Text); //20160719 Igor
   MainOptions.Prn_FontIncr := StrToInt(Prn_FontIncr.Text); //20160719 Igor

   MainOptions.Skin := TSkin(Skin.ItemIndex);//20171031 Igor
   MainOptions.ActiveTabColor := ActiveTabColor.Brush.Color; //20180111 Igor

   //20201013 Igor >>>
   FileNameFormat.ItemIndex:=0;  //20201212 CON
   s:='0';
   If FileNameFormat.ItemIndex =0  then s:='0'  else If FileNameFormat.ItemIndex =1  then s:='1';

   SaveOptionValue(FileNameFormat.Name,s,TempList);
   //20201013 Igor <<<

   MainOptions.Save; //20170127 Igor
 TempList.SaveToFile(AppDir+'\'+OptionsFlName);
 TempList.Free;

 Screen.Cursor:=crDefault;
 ShowMessage('Saved');
end;


procedure TOptionsFrmT2_2027.LoadOptionsToForm;
Var TempList:TStringList;s:String;
Begin
 TempList:=TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+ OptionsFlName);
  //Read Values
   Dir_Cur.Text:=GetOptionValue('Dir_Cur',TempList);
   Dir_ClientDocs.Text:=GetOptionValue('Dir_ClientDocs',TempList);
   BackUpFrequency.Text:=GetOptionValue('BackUpFrequency',TempList);
   BackUpDir.Text:=GetOptionValue('BackUpDir',TempList);
   LastBackUpDir.Text:=GetOptionValue('LastBackUpDir',TempList);
   Dir_Deflt.Text:=GetOptionValue('Dir_Deflt',TempList);
   Dir_LastYr.Text:=GetOptionValue('Dir_LastYr',TempList);
   Dir_PgmLastYr.Text:=GetOptionValue('Dir_PgmLastYr',TempList);
   Dir_DBFData.Text:=GetOptionValue(Dir_DBFData.Name,TempList); //20160226 Igor
   Prp_Name.Text:=GetOptionValue('Prp_Name',TempList);
   Prp_ContactFn.Text:=GetOptionValue('Prp_ContactFn',TempList);
   Prp_ContactLn.Text:=GetOptionValue('Prp_ContactLn',TempList);
   Prp_ContactPos.Text:=GetOptionValue('Prp_ContactPos',TempList);
   Prp_RepId.Text:=GetOptionValue('Prp_RepId',TempList);
   Prp_EMail.Text:=GetOptionValue('Prp_EMail',TempList);
   Prp_OrgType.Text:=GetOptionValue('Prp_OrgType',TempList);
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
   Prp_GSTNo.Text:=GetOptionValue('Prp_GSTNo',TempList);
   Prp_Bill.Text:=GetOptionValue('Prp_Bill',TempList);
   Prp_VSFee.Text:=GetOptionValue('Prp_VSFee',TempList);
   Prp_SFee.Text:=GetOptionValue('Prp_SFee',TempList);
   Prp_AFee.Text:=GetOptionValue('Prp_AFee',TempList);
   Prp_CFee.Text:=GetOptionValue('Prp_CFee',TempList);
   Prp_VCFee.Text:=GetOptionValue('Prp_VCFee',TempList);
   Prp_Hour.Text:=GetOptionValue('Prp_Hour',TempList);

   Prp_Dates.Checked:=StringToBoolean(GetOptionValue('Prp_Dates',TempList));
   Nfl_Prov.Text:=GetOptionValue('Nfl_Prov',TempList);
   Nfl_City.Text:=GetOptionValue('Nfl_City',TempList);

   s:=GetOptionValue('Capitalization',TempList);
   If      s='UpperCase' then Capitalization.ItemIndex:=0
   else If s='ProperCase' then Capitalization.ItemIndex:=1
   else If s='None' then Capitalization.ItemIndex:=2
   else Capitalization.ItemIndex:=0;

   Nfl_Efile.Checked:=StringToBoolean(GetOptionValue('Nfl_Efile',TempList));
   Ef_ThirdParty.Checked:=StringToBoolean(GetOptionValue('Ef_ThirdParty',TempList));

   Prn_NameH.Checked:=StringToBoolean(GetOptionValue('Prn_NameH',TempList));
   Prn_SinH.Checked:=StringToBoolean(GetOptionValue('Prn_SinH',TempList));
   Prn_DateH.Checked:=StringToBoolean(GetOptionValue('Prn_DateH',TempList));
   Prn_Disclm.Text:=GetOptionValue('Prn_Disclm',TempList);
   //Prn_Logo.Checked:=StringToBoolean(GetOptionValue('Prn_Logo',TempList));
   //Prn_logoln.Text:=GetOptionValue('Prn_logoln',TempList);
   //LogoFile.Text:=GetOptionValue('LogoFile',TempList);
   Opr_Close.Checked:=StringToBoolean(GetOptionValue('Opr_Close',TempList));
   Opr_GstHst.Text:=GetOptionValue('Opr_GstHst',TempList);

   //other options
   UseFastPrint.Checked:=StringToBoolean(GetOptionValue('UseFastPrint',TempList));
   ShowUsedForms.Checked:=StringToBoolean(GetOptionValue('ShowUsedForms',TempList));
   OpenAtLastForm.Checked:=StringToBoolean(GetOptionValue('OpenAtLastForm',TempList));
   DecimalAssume.Checked:=StringToBoolean(GetOptionValue('DecimalAssume',TempList));
   UseProperName.Checked:=StringToBoolean(GetOptionValue('UseProperName',TempList));
   NoTypeAhead.Checked:=StringToBoolean(GetOptionValue('NoTypeAhead',TempList));

   ShowInvoiceWarning.Checked:=StringToBoolean(GetOptionValue('ShowInvoiceWarning',TempList));
   ActiveBoxColor.Text:=GetOptionValue('ActiveBoxColor',TempList);
   // inv footer
   InvFoot1.Text:=GetOptionValue('InvFoot1',TempList);
   InvFoot2.Text:=GetOptionValue('InvFoot2',TempList);
   InvFoot3.Text:=GetOptionValue('InvFoot3',TempList);
   InvFoot4.Text:=GetOptionValue('InvFoot4',TempList);
   InvFoot5.Text:=GetOptionValue('InvFoot5',TempList);

   If ActiveBoxColor.Text='' then ActiveBoxColor.Text:=IntToStr(PinkishColor); //IntToStr(Rgb(160,221,250));
   ActiveBoxColor.Color:=MyStrToInt(ActiveBoxColor.Text);
   ActiveBoxColor.Font.Color:=MyStrToInt(ActiveBoxColor.Text);

   DataInBold.Checked:=StringToBoolean(GetOptionValue('DataInBold',TempList));
   HideMostRecent.Checked:=StringToBoolean(GetOptionValue('HideMostRecent',TempList));
   NoBarCode.Checked:=StringToBoolean(GetOptionValue('NoBarCode',TempList));
   RolloverProgram.Text:=GetOptionValue('RolloverProgram',TempList);

//shared options
   //s:=GetOptionValue('EscOption',TempList);
   s := MainOptions.EscOption;
   If      s='CloseForm' then EscOption.ItemIndex:=0
   else If s='GoToSummary' then EscOption.ItemIndex:=1;
   //FormZoom.Text:=GetOptionValue('FormZoom',TempList);
   FormZoom.Text := IntToStr(MainOptions.FormZoom);
   //SingleLoginId.Text:=GetOptionValue('SingleLoginId',TempList);
   SingleLoginId.Text:=MainOptions.SingleLoginId;
   //SkipLogin.Checked:=StringToBoolean(GetOptionValue('SkipLogin',TempList));
   SkipLogin.Checked:=MainOptions.SkipLogin;
   //UpdateFrequency.Text:=GetOptionValue('UpdateFrequency',TempList);
   UpdateFrequency.Text:= IntToStr(MainOptions.UpdateFrequency);

   Prn_LMargin.Text := FloatToStr(MainOptions.Prn_LMargin); //20160719 Igor
   Prn_RMargin.Text := FloatToStr(MainOptions.Prn_RMargin); //20160719 Igor
   Prn_FontIncr.Text := IntToStr(MainOptions.Prn_FontIncr); //20160719 Igor
   Skin.ItemIndex := Integer(MainOptions.Skin);//20171031 Igor
   ActiveTabColor.Brush.Color := MainOptions.ActiveTabColor; //20180111 Igor

   //20201013 Igor >>>
   s:=GetOptionValue('FileNameFormat',TempList);
   If      s='0' then FileNameFormat.ItemIndex:=0
   else If s='1' then FileNameFormat.ItemIndex:=1;
   //20201013 Igor <<<

   TempList.Free;
end;

procedure TOptionsFrmT2_2027.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
  FRetNo := GetCurrentRetNo;
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

   LoadOptionsToForm;
   //20180503 Igor >>>
   if CheckIsCloud(true) then
   begin
    CreateNewDirBtn.Enabled := False;
    Dir_Cur.Enabled := False;
    SelectCurBtn.Enabled := False;
    SelectDefBtn.Enabled := False;
    Dir_Deflt.Enabled := False;
    Dir_ClientDocs.Enabled := False;
    SelectDirClientDocBtn.Enabled := False;
    Dir_LastYr.Enabled := False;
    SelectL1Btn.Enabled := False;
    Dir_PgmLastYr.Enabled := False;
    SelectBackupDirBtn.Enabled := False;
    BackupDir.Enabled := False;
    Dir_DBFData.Enabled := False;
    SelectDBFBtn.Enabled := False;
    btnDir_PgmLastYr.Enabled := false;
    LastBackupDir.Enabled := false;
   end;
   //20180503 Igor <<<
   //If Dir_ClientDocs.text='' then Dir_ClientDocs.text:='C:\T2-'+IntToStr(MyStrToInt(AppYear))+'\Client Documents'+'-'+IntToStr(MyStrToInt(AppYear));
   //20180503 Igor >>>
   if CheckIsCloud(true) then
   begin
     If Dir_ClientDocs.text='' then Dir_ClientDocs.text := TPath.Combine(AppDir, 'Client Documents');
     If BackUpDir.text='' then BackUpDir.text := TPath.Combine(AppDir, 'BackupTax');
   end
   else
   begin
     If Dir_ClientDocs.text='' then Dir_ClientDocs.text:='C:\T2\Client Documents';
     If BackUpDir.text='' then BackUpDir.text:='C:\BackupTax\'+AppName+'-'+AppYear;
   end;
   If Prn_FontIncr.Text='' then Prn_FontIncr.Text:='1';
   If Prn_LMargin.text='' then Prn_LMargin.text:='1.0';
   If Prn_RMargin.text='' then Prn_RMargin.text:='0.75';
   If Prn_FontIncr.text='' then Prn_FontIncr.text:='1';
   If FormZoom.text='' then FormZoom.text:=IntToStr(GetDefaultScaling);
   If BackUpFrequency.text='' then BackUpFrequency.text:='5';
   //20180503 Igor <<<
   If AllTrim(Prp_countr.text)='' then Prp_countr.text:='CA';
   If AllTrim(Prp_OrgType.text)='' then Prp_OrgType.text:='1 CORPORATION';
  // If LicenseLevel='T1 Limited' then Dir_Planner.text:=LimitedVersionDir;
   LinkedBoxColor.Text:=IntToStr(BrightGreen); //(RGB(151,255,151));
   LinkedBoxColor.Color:=BrightGreen; //RGB(151,255,151);
   LinkedBoxColor.Font.Color:=BrightGreen; //RGB(151,255,151);

   ProtectedBoxColor.Text:=IntToStr(DarkShade); //IntToStr(Rgb(130,130,130));
   ProtectedBoxColor.Color:=DarkShade; //Rgb(130,130,130);
   ProtectedBoxColor.Font.Color:=DarkShade; //Rgb(130,130,130);

   //ColorsPanel.Color:=Clr0.Color;
   //If LogoFile.Text='' then LogoFile.Text:=AppDir+'\'+'MyLogo.bmp';
   LoadPluginSettings(AppT2.AppId, UserName, Self, PageControl1); //20190221 Igor
end;

procedure TOptionsFrmT2_2027.SelectCurBtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir_Cur.Text := DirSelected;
 {
 Application.CreateForm(TSelectDir,SelectDir);
 SelectDir.ShowModal;
 SelectDir.Free;
 If SelectedDir >'' then Dir_Cur.Text := SelectedDir;
 }
end;

procedure TOptionsFrmT2_2027.SelectDBFBtnClick(Sender: TObject); //20160226 Igor
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    Dir_DbfData.Text := DirSelected;
end;

procedure TOptionsFrmT2_2027.SelectDefBtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir_deflt.Text:=DirSelected;
 (*
 Application.CreateForm(TSelectDir,SelectDir);
 SelectDir.ShowModal;
 SelectDir.Free;
 If SelectedDir >'' then Dir_deflt.Text := SelectedDir;
 *)
end;

procedure TOptionsFrmT2_2027.SelectL1BtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir_LastYr.Text:=DirSelected;

end;

Function TOptionsFrmT2_2027.EditDirectory(DirName: string; ALastYearDir: Boolean = False): boolean; //20160229 Igor
Var s:String;
begin
   Result := True;
   If UpperCase(DirName) = UpperCase(AppDir) then
    begin
     ShowMessage('You cannot use the Program Directory '+
       DirName + Chr(13)+'as Data Directory');
     result := False;
     exit;
    end;

    If not ALastYearDir AND FileExists(DirName+'\'+ClientsTable_dbf) then //20160227 Igor //20160229 Igor
    begin
      ShowMessage('This data directory '+ DirName + ' has tax returns with the old format. '+
                  'Please use a different data directory for this program.');//20160310 Igor
      Result := False;
      exit;
    end;

   s:=GetAnyPathMoreThan8Chars(DirName);
   if SysUtils.DirectoryExists(DirName) then exit; //20150701
   If DirName='' then exit; {no directory}

  {Does Not exist}
   //20180503 Igor >>>
   if CheckIsCloud(true) or
      (MessageDlg('Directory: '+ DirName +
     ' does not exist. Create?',
      mtInformation, [mbYes, mbNo], 0) = mrYes) then
   //20180503 Igor <<<
    begin {replied mrYes to create}
        {$I-}   {so that the ioresult can be effective}
        SysUtils.ForceDirectories(DirName); {MkDir(DirName);} //20150701
        if IOResult = 0 then
           begin
            if not CheckIsCloud(true) then //20180503 Igor
              MessageDlg('Directory: '+ DirName + ' created', mtInformation, [mbOk], 0);
            exit;
           end
        else
           begin
             MessageDlg('Directory: '+ DirName +
              chr(13)+' cannot be created', mtInformation, [mbOk], 0);
             Result := False;
             exit;
           end;
    end
    else  {replied mrNo}
       begin result := False; exit; end;
end;

procedure TOptionsFrmT2_2027.FeesBtnClick(Sender: TObject);
begin
 If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 If RetInMem>0 then
  begin ShowMessage('Close all returns first');exit;end;
 ExecuteForm(TFeesT2_2027);
end;

procedure TOptionsFrmT2_2027.ListBox1Click(Sender: TObject);
begin
 Prp_bill.Text := AllTrim(IntToStr(ListBox1.ItemIndex));
end;

procedure TOptionsFrmT2_2027.SetupEOLBtnClick(Sender: TObject);
begin
  ExecuteForm(TEOLSetUpT2_2027);
end;

procedure TOptionsFrmT2_2027.SetActiveTabColorClick(Sender: TObject); //20180111 Igor
begin
  ColorDialog1.Color := ActiveTabColor.Brush.Color;
  if ColorDialog1.Execute then
    ActiveTabColor.Brush.Color := ColorDialog1.Color;
end;

procedure TOptionsFrmT2_2027.SetDisplayBtnClick(Sender: TObject);
begin
  MainForm.SetDisplayBtnClick(Sender);
end;


procedure TOptionsFrmT2_2027.BitBtn2Click(Sender: TObject);
begin
ShowHelp('T2Help','Configuration');
end;

procedure TOptionsFrmT2_2027.BitBtn3Click(Sender: TObject);
begin
//howHelp('Data Directories');
end;

procedure TOptionsFrmT2_2027.btnDir_PgmLastYrClick(Sender: TObject); //20160424 Igor
Var
  DirSelected: String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected, []) then
    Dir_PgmLastYr.Text:=DirSelected;
end;

procedure TOptionsFrmT2_2027.SetPgmPswBtnClick(Sender: TObject);
begin
  vtDialogs.SetThePgmPsw;
end;

procedure TOptionsFrmT2_2027.RemovePgmPswBtnClick(Sender: TObject);
begin
  RemovePgmPsw;
end;

procedure TOptionsFrmT2_2027.RolloverProgramChange(Sender: TObject); //20180503 Igor
begin
  if CheckIsCloud(true) then
    Dir_LastYr.Text := TPath.Combine(AppDir, 'LastYear' + TPath.DirectorySeparatorChar + RolloverProgram.Text);
end;

procedure TOptionsFrmT2_2027.FormPaint(Sender: TObject);
begin
 If Dir_ClientDocs.text='' then
   Dir_ClientDocs.text:='C:\T2\Client Documents';
     //'C:\T2-'+IntToStr(MyStrToInt(AppYear))+'\Client Documents'+'-'+IntToStr(MyStrToInt(AppYear));
 ActiveBoxColor.Font.Color :=ActiveBoxColor.Color;
 If LicenseLevel in anyMulti then
 begin
  SkipLogin.Checked := False;
  SkipLogin.Enabled := False;
 end;

end;

procedure TOptionsFrmT2_2027.ExitBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TOptionsFrmT2_2027.FormClose(Sender: TObject; var Action: TCloseAction);
//var MyChild: TMyChild;
begin
 if MessageDlg('Save options?',mtWarning, [mbYes, mbNo], 0) = mrYes then
     SaveOptions;

 MainFormT2.ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
 if RetNo > 0 then //as on FormShow
 begin
   Calc(RetNo,'T2'); //for capitalization
   RetList[RetNo].MyChild.RefreshActiveForm;
   MainForm.RefreshAuditPanel(RetNo);
 end;
end;


procedure TOptionsFrmT2_2027.UseDefaultBoxColorClick(Sender: TObject);
begin
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Add('1. Light Blue (for color consistency');
 SomeList.Add('2. Light Red (for greater visibility)');
 SomeList.Add('3. Select your own (use a light color)');
  SelectedString := PopSomeList(SomeList,'Select a color');
 //SomeList.Free; //20160704 Igor
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

(*
procedure TOptionsFrm.SetFirstReturnColor(Sender: TObject);
Var aLabel:TVtLabel;Nm:String;
begin
 If Sender is TvtLabel then
   ColorsPanel.Color := (Sender As TvTLabel).color;
end;
*)
procedure TOptionsFrmT2_2027.Clr0Click(Sender: TObject);
begin
// SeFirstReturnColor(Sender);
 {
 FirstReturnColor.Caption:=IntToStr(clr0.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 }
end;

procedure TOptionsFrmT2_2027.clr7Click(Sender: TObject);
begin
 (*
 FirstReturnColor.Caption:=IntToStr(clr7.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT2_2027.clr8Click(Sender: TObject);
begin
(*
FirstReturnColor.Caption:=IntToStr(clr8.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT2_2027.Clr9Click(Sender: TObject);
begin
(*
FirstReturnColor.Caption:=IntToStr(clr9.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT2_2027.Clr10Click(Sender: TObject);
begin
(*
 FirstReturnColor.Caption:=IntToStr(clr10.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT2_2027.Clr11Click(Sender: TObject);
begin
(*
 FirstReturnColor.Caption:=IntToStr(clr11.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT2_2027.CreateNewDirBtnClick(Sender: TObject);
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
procedure TOptionsFrmT2_2027.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:=ValidateOptions;
end;

procedure TOptionsFrmT2_2027.LogoFileExit(Sender: TObject);
begin
 FormPaint(Sender);
end;

procedure TOptionsFrmT2_2027.LogoFileKeyPress(Sender: TObject; var Key: Char);
begin
 If Key=#13 then FormPaint(Sender);
end;

procedure TOptionsFrmT2_2027.FormKeyPress(Sender: TObject; var Key: Char);
begin
EXIT;  //good but needs work
  if Key = #13 then
  begin
    Key := #0;
    //if (Sender is TDBGrid) then  TDBGrid(Sender).Perform(WM_KeyDown,VK_Tab,0) else
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;



procedure TOptionsFrmT2_2027.SelectBackupDirBtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   BackupDir.Text:=DirSelected;
end;

procedure TOptionsFrmT2_2027.SaveBtnClick(Sender: TObject);
begin
 SaveOptions;
end;

procedure TOptionsFrmT2_2027.Prn_FontIncrChange(Sender: TObject);
begin
 If MyStrToInt(Prn_FontIncr.Text) >1 then Prn_FontIncr.Text:='1';

end;

(* //20160523
procedure TOptionsFrmT2_2027.Select2006BtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir2006.Text:=DirSelected;
end;

procedure TOptionsFrmT2_2027.Select2005BtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir2005.Text:=DirSelected;

end;

procedure TOptionsFrmT2_2027.Select2004BtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir2004.Text:=DirSelected;

end;

procedure TOptionsFrmT2_2027.Select2003BtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir2003.Text:=DirSelected;

end;

procedure TOptionsFrmT2_2027.Select2002BtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir2002.Text:=DirSelected;
end;
*)

(* //20160523
procedure TOptionsFrmT2_2027.Select2001BtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
 if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir2001.Text:=DirSelected;
end;
*)
procedure TOptionsFrmT2_2027.Prp_BusNoExit(Sender: TObject);
begin
  Prp_busNo.Text:=RemoveChar(Prp_busNo.Text,' ');
end;

procedure TOptionsFrmT2_2027.SelectDirClientDocBtnClick(Sender: TObject);
Var DirSelected: String; //20150622
begin
if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir_ClientDocs.Text := DirSelected;
end;

procedure TOptionsFrmT2_2027.FixMessage(const msg: string;
  FocusElm: TWinControl);
//20170811 Igor>>>
begin
(* show message and focus elm to fix.
  Must make page visible before SetFocus!
*)
  UserMsg(msg);
  TvtForm.SafeSetFocus(FocusElm);
//20170811 Igor<<<
end;

end.
