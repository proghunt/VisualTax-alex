unit T3_2026optionsfrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  vtLabel,ExtCtrls,ComCtrls,Db,Buttons,DBCtrls,Mask,FileCtrl,
  T3_2026TrimStr,T3_2026Declare,vtEditBox,vtShape,ColorGrd, System.IOUtils; //20180503 Igor
  {UCompLogo;}

type
  TOptionsFrmT3_2026 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel2: TPanel;
    Panel12: TPanel;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet9: TTabSheet;
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
    Label52: TLabel;
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
    Label72: TLabel;
    Panel26: TPanel;
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
    Prp_countr: TEdit;
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
    ShowUsedForms: TCheckBox;
    OpenAtLastForm: TCheckBox;
    Prp_ContactName: TEdit;
    Label58: TLabel;
    Label12: TLabel;
    Label145: TLabel;
    Dir_DBFData: TEdit;
    SelectDBFBtn: TBitBtn;
    Label138: TLabel;
    Dir_PgmLastYr: TEdit;
    SelectLYPrgmDir: TBitBtn;
    //20180111 Igor >>>
    GroupBox2: TGroupBox;
    ActiveTabColor: TShape;
    SetActiveTabColor: TBitBtn;
    //20180111 Igor <<<
    //20180118 Igor >>>
    GroupBox1: TGroupBox;
    Skin: TComboBox;
    Label27: TLabel;
    Label31: TLabel;
    Label34: TLabel;
    Prp_RepresentativeId: TEdit;
    Label82: TLabel;
    Label141: TLabel;
    Label83: TLabel;
    Dir_ClientDocs: TEdit;
    SelectDirClientDocBtn: TBitBtn;
    Label43: TLabel;
    Prp_TransmitterNo: TEdit;
    Label54: TLabel;
    Label45: TLabel;
    PRP_TransmitterType: TComboBox;
    Label35: TLabel;
    Prp_TransmitterAccountRepId: TEdit;
    //20180118 Igor <<<
    Function SaveOptions:Boolean;
   // procedure SaveBtnClick(Sender: TObject);
    Function ValidateOptions:Boolean;
    procedure SaveOptionsToFile;
    procedure LoadOptionsToForm;
    Function CheckBoxToText(ACheckBox:TCheckBox):String;
    procedure FormCreate(Sender: TObject);
    procedure SelectCurBtnClick(Sender: TObject);
    procedure SelectDefBtnClick(Sender: TObject);
    procedure SelectL1BtnClick(Sender: TObject);
    Function  EditDirectory(DirName: string; ALastYearDir: Boolean = False): boolean; //20160229 Igor
    procedure FeesBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
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
    procedure SelectDBFBtnClick(Sender: TObject); //20160226 Igor
    procedure SelectLYPrgmDirClick(Sender: TObject); //20160629 Igor
    procedure SetActiveTabColorClick(Sender: TObject);
    procedure SelectDirClientDocBtnClick(Sender: TObject); //20180111 Igor


    //Procedure SaveAGroupControl(AControl:TControl;TempList:TStringList);
  private
    function GetRetNo: Integer; //20160223 Igor
    procedure FixMessage(const msg: string; FocusElm: TWinControl);
  public
    property RetNo: integer read GetRetNo; //20160223 Igor
  end;

var
  OptionsFrm: TOptionsFrmT3_2026;
 // LogoName:String;
  {
  LogoFile:String;
  LogoHeight:String;
  LogoWidth :String;
  IncludeLogo:String[1];
  LogoPosition:String;
  }
implementation

uses
  vtMulti,vtCommon,vtDialogs,vtChild,vtMain,
  T3_2026,T3_2026Common,T3_2026Fees,
//T3_2026SetDisplay,T3_2026SetPgmPsw,T3_2026ChildWinNew,
//T3_2026PopList,T3_2026SelectFile,T3_2026selectDir,
  T3_2026Calc,
  T3_2026Main,T3_2026Features,
//keep last
  vtHelperManager, //20190228 Igor
  vtTrimStr, vtShared;

{$R *.DFM}



Function TOptionsFrmT3_2026.SaveOptions:Boolean;
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
     MainFormT3.ShowMostRecentReturns;
 end;
end;

Function TOptionsFrmT3_2026.ValidateOptions:Boolean;
Var TempList:TStringList;
begin
Try
 Result:=False;
 If IsDataDirectoryGood(Dir_Cur.Text) = False then exit;
 If IsDataDirectoryGood(Dir_Deflt.Text) = False then exit;

 //If IsDataDirectoryGood(Dir_Planner.Text) = False then exit;
 {$I-}
 if DirectoryExists(Dir_Cur.Text) and
   not FileExists(Dir_Cur.Text+'\' + ClientsDBLite) then //20150923 Igor
        if InitDataBase(AppDir,Dir_Cur.Text) = false then
            begin
             ShowMessage('Data Base cannot be created');
             Dir_Cur.SetFocus;
             Exit;
            end;

  if (EditDirectory(Dir_Cur.Text)) and
     (EditDirectory(Dir_Deflt.Text)) and
     (EditDirectory(Dir_LastYr.Text, true)) and //20160229 Igor
     (EditDirectory(Dir_ClientDocs.text)) and  //20230312
     (EditDirectory(BackUpDir.text))
     then
  begin
      {initialize data bases}
      If FileExists(Dir_Cur.Text+'\' + ClientsDBLite) = false then //20150923 Igor
        if InitDataBase(AppDir,Dir_Cur.Text) = false then
            begin
             ShowMessage('Data Base cannot be created');
             Dir_Cur.SetFocus;
             Exit;
            end;
      If FileExists(Dir_Deflt.Text+'\' + ClientsDBLite) = false then //20150923 Igor
        if InitDataBase(AppDir,Dir_Deflt.Text) = false then
            begin
             ShowMessage('Data Base cannot be created');
             Dir_Deflt.SetFocus;
             Exit;
            end;
            If FileExists(Dir_Deflt.Text+'\' + ClientsDBLite) = false then //20150923 Igor
  end
  else
    exit;

 except
 end;
  //20160226 Igor >>>>
 if (dir_DbfData.Text <> '') AND
    not directoryExists(dir_DbfData.Text) then
 Begin
   ShowMessage('Invalid data directory of the T3-2023 production data (prior to Multi-App) '+ //20160305 Igor
                dir_DbfData.Text +' (it does not exist)');
   PageControl1.ActivePage := TabSheet3;
   Dir_DbfData.SetFocus;
   Exit;
 end;
 if (dir_DbfData.Text <> '') AND
    not FileExists(dir_DbfData.Text+'\'+ClientsTable_dbf) then
 Begin
   ShowMessage('Invalid data directory of the T3-2023 production data (prior to Multi-App) '+  //20160305 Igor
                dir_DbfData.Text +' (file "'+ClientsTable_dbf+'" does not exist).');  //does not exist //20171206 CON
   PageControl1.ActivePage := TabSheet3;
   Dir_DbfData.SetFocus;
   Exit;
 end;
 if (dir_DbfData.Text <> '') AND (dir_DbfData.Text = dir_Cur.Text) then
 Begin
   ShowMessage('Invalid data directory of the T3-2023 production data (prior to Multi-App) '+  //20160305 Igor
                dir_DbfData.Text +' (Current Directory and data directory of the T3-2023 production data (prior to Multi-App)'+
                ' cannot be the same)');
   PageControl1.ActivePage := TabSheet3;
   Dir_DbfData.SetFocus;
   Exit;
 end;
//20160226 Igor <<<<<
 If ValidEMail(PrP_EMail.text)=False then
 begin
   ShowMessage('Please enter a valid EMail (Preparer Section)');
   Prp_EMail.SetFocus;
   Exit;
 end;
 If ValidEMail(Reviewer_EMail.text)=False then
 begin
   ShowMessage('Please enter a valid Reviewer EMail (Preparer Section)');
   Reviewer_EMail.SetFocus;
   Exit;
 end;
 //20130523
 If AllTrim(Prp_Postal.text)>'' then
 Begin
  If ValidPostal(0,Prp_Postal.text)=False then
  begin
    ShowMessage('Please enter a valid Postal Code (Preparer Section)');
    Prp_Postal.SetFocus;
    Exit;
  end;
 End;


 //jz//20250323 - proabaly is not good enough , should be properly validated
 If (Length(Prp_TransmitterNo.text) <> 9) and (Length(Prp_TransmitterNo.text) <> 15)  then   //Length(Prp_TransmitterNo.text) <>6
 begin
  ShowMessage('Transmitter Account must be entered (999999999xx0001)'); // or 999999999 //or enter 555555 (Preparer Section)
  //exit;
 end;
 //jz//20250324
 If Length(Prp_TransmitterAccountRepId.text) <> 7 then
 begin
  //ShowMessage('Transmitter Account Rep ID must be entered correctly');
  //exit;
 end;



 If AllTrim(Prp_VSFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_VSFee.Text)) then
  begin
   ShowMessage('Please enter a valid amount');
   Prp_VSFee.SetFocus;
   Exit;
  end;
 end;

 If AllTrim(Prp_SFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_SFee.Text)) then
  begin
   ShowMessage('Please enter a valid amount');
   Prp_SFee.SetFocus;
   Exit;
  end;
 end;

 If AllTrim(Prp_AFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_AFee.Text)) then
  begin
   ShowMessage('Please enter a valid amount');
   Prp_AFee.SetFocus;
   Exit;
  end;
 end;

 If AllTrim(Prp_CFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_CFee.Text)) then
  begin
   ShowMessage('Please enter a valid amount');
   Prp_CFee.SetFocus;
   Exit;
  end;
 end;

 If AllTrim(UpdateFrequency.Text)>'' then
 begin
  If (Not Numeric(UpdateFrequency.Text)) then
  begin
   ShowMessage('Please enter a valid number');
   UpdateFrequency.SetFocus;
   Exit;
  end;
 end;


 If AllTrim(Prp_VCFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_VCFee.Text)) then
  begin
   ShowMessage('Please enter a valid amount');
   Prp_VCFee.SetFocus;
   Exit;
  end;
 end;

 If AllTrim(Prp_Hour.Text)>'' then
 begin
  If (Not RealNumeric(Prp_Hour.Text)) then
  begin
   ShowMessage('Please enter a valid amount');
   Prp_Hour.SetFocus;
   Exit;
  end;
 end;


 If AllTrim(Opr_GstHst.Text)>'' then
 begin
  If (Not RealNumeric(Opr_GstHst.Text))
  or (Vl(Opr_GstHst.Text)>100) then
  begin
   ShowMessage('Please enter a valid percentage');
   Opr_GstHst.SetFocus;
   Exit;
  end;
 end;


 Result:=True;
end;


Function TOptionsFrmT3_2026.CheckBoxToText(ACheckBox:TCheckBox):String;
begin
 If ACheckBox.Checked then result:='X' else Result:='';
end;


procedure TOptionsFrmT3_2026.SaveOptionsToFile;
Var i,j,jj:Integer; ABox:TEdit;AControl:TControl;TempList:TStringList;s:String;
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
   SaveOptionValue(Dir_PgmLastYr.Name,Dir_PgmLastYr.Text,TempList);//20160629 Igor
   SaveOptionValue(Dir_DBFData.Name,Dir_DBFData.Text,TempList);

   SaveOptionValue(Prp_Name.Name,Prp_Name.Text,TempList);

   SaveOptionValue(Prp_ContactName.Name,Prp_ContactName.Text,TempList);

   SaveOptionValue(Prp_TransmitterNo.Name,          Prp_TransmitterNo.Text,         TempList);
   SaveOptionValue(Prp_TransmitterAccountRepId.Name,Prp_TransmitterAccountRepId.Text,TempList);
   //SaveOptionValue(Prp_TransmitterType.Name,LeftStr(Prp_TransmitterType.Text,1),TempList);   //jz//20250323 - field removed

   SaveOptionValue(Prn_LMargin.Name,Prn_LMargin.Text,TempList);
   SaveOptionValue(Prn_RMargin.Name,Prn_RMargin.Text,TempList);
   SaveOptionValue(Prn_FontIncr.Name,Prn_FontIncr.Text,TempList);

   SaveOptionValue(Prp_EMail.Name,Prp_EMail.Text,TempList);
   SaveOptionValue(Prp_BusNo.Name,Prp_BusNo.Text,TempList);
   SaveOptionValue(Prp_RepresentativeId.Name,Prp_RepresentativeId.Text,TempList); //20230101
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
   //compens
   s:='1';
   If Capitalization.ItemIndex =0  then s:='UpperCase'
   else If Capitalization.ItemIndex =1  then s:='ProperCase';
   SaveOptionValue(Capitalization.Name,s,TempList);

   SaveOptionValue(Prn_NameH.Name,CheckBoxToText(Prn_NameH),TempList);
   SaveOptionValue(Prn_SinH.Name,CheckBoxToText(Prn_SinH),TempList);
   SaveOptionValue(Prn_DateH.Name,CheckBoxToText(Prn_DateH),TempList);
   SaveOptionValue(Prn_Disclm.Name,Prn_Disclm.Text,TempList);

   SaveOptionValue(Opr_Close.Name,CheckBoxToText(Opr_Close),TempList);
   SaveOptionValue(Opr_GstHst.Name,Opr_GstHst.Text,TempList);

   SaveOptionValue(UseFastPrint.Name,CheckBoxToText(UseFastPrint),TempList);
   SaveOptionValue(UseProperName.Name,CheckBoxToText(UseProperName),TempList);
   SaveOptionValue(NoTypeAhead.Name,CheckBoxToText(NoTypeAhead),TempList);
   SaveOptionValue(ShowInvoiceWarning.Name,CheckBoxToText(ShowInvoiceWarning),TempList);

   SaveOptionValue(UpdateFrequency.Name,UpdateFrequency.Text,TempList);
   SaveOptionValue(InvFoot1.Name,InvFoot1.Text,TempList);
   SaveOptionValue(InvFoot2.Name,InvFoot2.Text,TempList);
   SaveOptionValue(InvFoot3.Name,InvFoot3.Text,TempList);
   SaveOptionValue(InvFoot4.Name,InvFoot4.Text,TempList);
   SaveOptionValue(InvFoot5.Name,InvFoot5.Text,TempList);

   SaveOptionValue(ActiveBoxColor.Name,ActiveBoxColor.Text,TempList);

   SaveOptionValue(DataInBold.Name,CheckBoxToText(DataInBold),TempList);
   SaveOptionValue(HideMostRecent.Name,CheckBoxToText(HideMostRecent),TempList);
   SaveOptionValue(ShowUsedForms.Name,CheckBoxToText(ShowUsedForms),TempList);
   SaveOptionValue(OpenAtLastForm.Name,CheckBoxToText(OpenAtLastForm),TempList);
   SaveOptionValue(NoBarCode.Name,CheckBoxToText(NoBarCode),TempList);
   SaveOptionValue(SingleLoginId.Name,SingleLoginId.Text,TempList);
   SaveOptionValue(RolloverProgram.Name,RolloverProgram.Text,TempList);
   SaveOptionValue(SkipLogin.Name,CheckBoxToText(SkipLogin),TempList);
   SaveOptionValue(FormZoom.Name,FormZoom.Text,TempList);
   MainOptions.Skin := TSkin(Skin.ItemIndex);//20180118 Igor
   MainOptions.ActiveTabColor := ActiveTabColor.Brush.Color; //20180111 Igor

  TempList.SaveToFile(AppDir+'\'+OptionsFlName);
  TempList.Free;
  MainOptions.Save; //20170127 Igor

  Screen.Cursor:=crDefault;
  ShowMessage('Saved');
end;


procedure TOptionsFrmT3_2026.LoadOptionsToForm;
Var i:Integer; TempList:TStringList;s:String;
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
   Dir_PgmLastYr.Text:=GetOptionValue('Dir_PgmLastYr',TempList); //20160629 Igor
   Dir_DBFData.Text:=GetOptionValue('Dir_DBFData',TempList);

   Prp_Name.Text:=GetOptionValue('Prp_Name',TempList);

   Prp_ContactName.Text:=GetOptionValue('Prp_ContactName',TempList);

   Prn_LMargin.Text:=GetOptionValue('Prn_LMargin',TempList);
   Prn_RMargin.Text:=GetOptionValue('Prn_RMargin',TempList);
   Prn_FontIncr.Text:=GetOptionValue('Prn_FontIncr',TempList);
   Prp_EMail.Text:=GetOptionValue('Prp_EMail',TempList);
   Prp_BusNo.Text:=GetOptionValue('Prp_BusNo',TempList);
   Prp_RepresentativeId.Text:=GetOptionValue('Prp_RepresentativeId',TempList); //20230101

   Prp_TransmitterNo.Text           :=GetOptionValue('Prp_TransmitterNo',TempList);
   Prp_TransmitterAccountRepId.Text :=GetOptionValue('Prp_TransmitterAccountRepId',TempList);   //jz//20250324 - field added
   //Prp_TransmitterType.Text:=GetOptionValue('Prp_TransmitterType',TempList);                  //jz//20250323 - field removed

   Reviewer_Name.Text:=GetOptionValue('Reviewer_Name',TempList);
   Reviewer_EMail.Text:=GetOptionValue('Reviewer_EMail',TempList);
   Reviewer_Area.Text:=GetOptionValue('Reviewer_Area',TempList);
   Reviewer_Tel.Text:=GetOptionValue('Reviewer_Tel',TempList);

   Prp_Street.Text:=GetOptionValue('Prp_Street',TempList);
   Prp_City.Text:=GetOptionValue('Prp_City',TempList);
   Prp_Prov.Text:=GetOptionValue('Prp_Prov',TempList);
   Prp_Postal.Text:=GetOptionValue('Prp_Postal',TempList);
   Prp_Countr.Text:=GetOptionValue('Prp_Countr',TempList);
   if Prp_Countr.Text = '' then Prp_Countr.Text := 'CAN';
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
   else Capitalization.ItemIndex:=0;

   Prn_NameH.Checked:=StringToBoolean(GetOptionValue('Prn_NameH',TempList));
   Prn_SinH.Checked:=StringToBoolean(GetOptionValue('Prn_SinH',TempList));
   Prn_DateH.Checked:=StringToBoolean(GetOptionValue('Prn_DateH',TempList));
   Prn_Disclm.Text:=GetOptionValue('Prn_Disclm',TempList);
   Opr_Close.Checked:=StringToBoolean(GetOptionValue('Opr_Close',TempList));
   Opr_GstHst.Text:=GetOptionValue('Opr_GstHst',TempList);

   UseFastPrint.Checked:=StringToBoolean(GetOptionValue('UseFastPrint',TempList));
   UseProperName.Checked:=StringToBoolean(GetOptionValue('UseProperName',TempList));
   NoTypeAhead.Checked:=StringToBoolean(GetOptionValue('NoTypeAhead',TempList));

   ShowInvoiceWarning.Checked:=StringToBoolean(GetOptionValue('ShowInvoiceWarning',TempList));
   ActiveBoxColor.Text:=GetOptionValue('ActiveBoxColor',TempList);
   UpdateFrequency.Text:=GetOptionValue('UpdateFrequency',TempList);
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
   ShowUsedForms.Checked:=StringToBoolean(GetOptionValue('ShowUsedForms',TempList));
   OpenAtLastForm.Checked:=StringToBoolean(GetOptionValue('OpenAtLastForm',TempList));
   NoBarCode.Checked:=StringToBoolean(GetOptionValue('NoBarCode',TempList));
   SingleLoginId.Text:=GetOptionValue('SingleLoginId',TempList);
   RolloverProgram.Text:=GetOptionValue('RolloverProgram',TempList);
   SkipLogin.Checked:=StringToBoolean(GetOptionValue('SkipLogin',TempList));
   FormZoom.Text:=GetOptionValue('FormZoom',TempList);
   Skin.ItemIndex := Integer(MainOptions.Skin);//20180118 Igor
   ActiveTabColor.Brush.Color := MainOptions.ActiveTabColor; //20180111 Igor

   TempList.Free;
end;

procedure TOptionsFrmT3_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
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
  // CurDirLbl.Caption := IntToStr(StrToInt(AppYear));
  // Prior1Lbl.Caption := IntToStr(StrToInt(AppYear)-1);

   LoadOptionsToForm;
   //20180503 Igor >>>
   if CheckIsCloud(true) then
   begin
      CreateNewDirBtn.Enabled := False;
      Dir_Cur.Enabled := False;
      SelectCurBtn.Enabled := False;
      SelectDefBtn.Enabled := False;
      Dir_Deflt.Enabled := False;
      Dir_ClientDocs.Enabled := False; //20230312
      LastBackupDir.Enabled := False;
      Dir_DBFData.Enabled := False;
      SelectLYPrgmDir.Enabled := False;
      SelectDBFBtn.Enabled := False;
      Dir_LastYr.Enabled := False;
      SelectL1Btn.Enabled := False;
      Dir_PgmLastYr.Enabled := False;
      SelectBackupDirBtn.Enabled := False;
      BackupDir.Enabled := False;
   end;
   //20230312
   if CheckIsCloud(true) then
   begin
     If Dir_ClientDocs.text='' then Dir_ClientDocs.text := TPath.Combine(AppDir, 'Client Documents');
     If BackUpDir.text='' then BackUpDir.text := TPath.Combine(AppDir, 'BackupTax');
   end
   else
   begin
     If Dir_ClientDocs.text='' then Dir_ClientDocs.text:='C:\VT\T3-'+AppYear+'\Client Documents';
     //If Dir_ClientDocs.text='' then Dir_ClientDocs.text:='C:\T3-'+IntToStr(MyStrToInt(AppYear))+'\Client Documents'+'-'+IntToStr(MyStrToInt(AppYear));
     If BackUpDir.text='' then BackUpDir.text:='C:\BackupTax\'+AppName+'-'+AppYear;
   end;

   //If AllTrim(PRP_TransmitterNo.text)='' then Prp_TransmitterNo.text:='555555';   //jz//20250323 - field changed, not 5s any more
   (* screen default text
   If PRP_TransmitterNo.text='' then PPP_TransmitterNo.text:='0000';
   If PRP_TransmitterType.text='' then PPP_TransmitterType.Text:='2 - Preparing for others';
   *)

   If Prn_FontIncr.Text='' then Prn_FontIncr.Text:='1';
   If Prn_LMargin.text='' then Prn_LMargin.text:='1.0';
   If Prn_RMargin.text='' then Prn_RMargin.text:='0.75';
   If Prn_FontIncr.text='' then Prn_FontIncr.text:='1';
   If FormZoom.text='' then FormZoom.text:=IntToStr(GetDefaultScaling);
   If BackUpFrequency.text='' then BackUpFrequency.text:='5';
   //20180503 Igor >>>
   If BackUpDir.text='' then
    if CheckIsCloud(true) then
      BackUpDir.text := TPath.Combine(AppDir, 'BackupTax')
    else
      BackUpDir.text:='C:\BackupTax\'+AppName+'-'+AppYear;
   //20180503 Igor <<<
  // If LicenseLevel='T1 Limited' then Dir_Planner.text:=LimitedVersionDir;
   LinkedBoxColor.Text:=IntToStr(BrightGreen); //(RGB(151,255,151));
   LinkedBoxColor.Color:=BrightGreen; //RGB(151,255,151);
   LinkedBoxColor.Font.Color:=BrightGreen; //RGB(151,255,151);

   ProtectedBoxColor.Text:=IntToStr(DarkShade); //IntToStr(Rgb(130,130,130));
   ProtectedBoxColor.Color:=DarkShade; //Rgb(130,130,130);
   ProtectedBoxColor.Font.Color:=DarkShade; //Rgb(130,130,130);

   //ColorsPanel.Color:=Clr0.Color;
   //If LogoFile.Text='' then LogoFile.Text:=AppDir+'\'+'MyLogo.bmp';
   LoadPluginSettings(AppT3_2026.AppId, UserName, Self, PageControl1); //20190228 Igor
end;

procedure TOptionsFrmT3_2026.SelectCurBtnClick(Sender: TObject);
Var DirSelected:String; //20150805 Igor
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

procedure TOptionsFrmT3_2026.SelectDBFBtnClick(Sender: TObject); //20160226 Igor
Var DirSelected:String;
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   Dir_DbfData.Text:=DirSelected;
end;

procedure TOptionsFrmT3_2026.SelectDefBtnClick(Sender: TObject);
Var DirSelected:String; //20150805 Igor
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

procedure TOptionsFrmT3_2026.SelectDirClientDocBtnClick(Sender: TObject); //20230312
Var DirSelected: String;
begin
if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
   Dir_ClientDocs.Text := DirSelected;
end;


procedure TOptionsFrmT3_2026.SelectL1BtnClick(Sender: TObject);
Var DirSelected:String; //20150805 Igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   Dir_LastYr.Text:=DirSelected;

end;

Function TOptionsFrmT3_2026.EditDirectory(DirName: string; ALastYearDir: Boolean = False): boolean; //20160229 Igor
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
   if DirectoryExists(DirName) then exit;
   If DirName='' then exit; {no directory}

  {Does Not exist}
   if MessageDlg('Directory: '+ DirName +
     ' does not exist. Create?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin {replied mrYes to create}
        {$I-}   {so that the ioresult can be effective}
        ForceDirectories(DirName); {MkDir(DirName);}
        if IOResult = 0 then
           begin
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


procedure TOptionsFrmT3_2026.FeesBtnClick(Sender: TObject);
begin

 If RetInMem>0 then
  begin ShowMessage('Close all returns first');exit;end;
 Application.CreateForm(TFeesT3_2026,Fees);
 Fees.ShowModal;
 Fees.Free;
end;

procedure TOptionsFrmT3_2026.ListBox1Click(Sender: TObject);
begin
 Prp_bill.Text := AllTrim(IntToStr(ListBox1.ItemIndex));
end;



(*
procedure TOptionsFrm.SetupEOLPBtnClick(Sender: TObject);
begin
 Application.CreateForm(TEOLPSetup,EOLPSetup);
 EOLPSetup.ShowModal;
 EOLPSetup.Free;
end;
*)
procedure TOptionsFrmT3_2026.SelectLYPrgmDirClick(Sender: TObject); //20160629 Igor
Var
  DirSelected:String;
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   Dir_PgmLastYr.Text:=DirSelected;
end;

procedure TOptionsFrmT3_2026.BitBtn2Click(Sender: TObject);
begin
ShowHelp('TfHelp','Configuration');
end;

procedure TOptionsFrmT3_2026.BitBtn3Click(Sender: TObject);
begin
//howHelp('Data Directories');
end;

procedure TOptionsFrmT3_2026.SetActiveTabColorClick(Sender: TObject); //20180111 Igor
begin
  ColorDialog1.Color := ActiveTabColor.Brush.Color;
  if ColorDialog1.Execute then
    ActiveTabColor.Brush.Color := ColorDialog1.Color;
end;

procedure TOptionsFrmT3_2026.SetPgmPswBtnClick(Sender: TObject);
begin
  SetThePgmPsw;
end;

procedure TOptionsFrmT3_2026.RemovePgmPswBtnClick(Sender: TObject);
begin
 RemovePgmPsw;
 ShowTimedMsg('Program Password Removed',1000);
end;

procedure TOptionsFrmT3_2026.FormPaint(Sender: TObject);
begin
 ActiveBoxColor.Font.Color :=ActiveBoxColor.Color;
 If Dir_ClientDocs.text='' then
   Dir_ClientDocs.text:='C:\VT\T3-'+AppYear+'\Client Documents';
 {
 If LeftStr(LicenseLevel,8) = 'T1 Multi' then
 begin
  SkipLogin.Checked := False;
  SkipLogin.Enabled := False;
 end;
 }
end;

function TOptionsFrmT3_2026.GetRetNo: Integer; //20160223 Igor
begin
  Result := GetCurrentRetNo;
end;

procedure TOptionsFrmT3_2026.ExitBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TOptionsFrmT3_2026.FormClose(Sender: TObject; var Action: TCloseAction);
var
  MyChild: TMyChild;
begin
 if MessageDlg('Save options?',mtWarning, [mbYes, mbNo], 0) = mrYes then
     SaveOptions;

 MainFormT3.ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
 If (RetInMem>0) AND (RetNo > 0) then //20160223 Igor
 begin
  MyChild := RetList[RetNo].MyChild;
  //RetNo:=GetCurrentRetNo;
  Calc(RetNo,'T3'); //for capitalization
  MyChild.ShowFormData(MyChild.FormName,MyChild.FormNo);
  MainForm.RefreshAuditPanel(RetNo);
 end;
end;


procedure TOptionsFrmT3_2026.UseDefaultBoxColorClick(Sender: TObject);
begin
 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Select a color';
 SomeList.Add('1. Light Blue (for color consistency');
 SomeList.Add('2. Light Red (for greater visibility)');
 SomeList.Add('3. Select your own (use a light color)');
  SelectedString := PopSomeList(SomeList,SomeCaption);
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
procedure TOptionsFrmT3_2026.Clr0Click(Sender: TObject);
begin
// SeFirstReturnColor(Sender);
 {
 FirstReturnColor.Caption:=IntToStr(clr0.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 }
end;

procedure TOptionsFrmT3_2026.clr7Click(Sender: TObject);
begin
 (*
 FirstReturnColor.Caption:=IntToStr(clr7.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT3_2026.clr8Click(Sender: TObject);
begin
(*
FirstReturnColor.Caption:=IntToStr(clr8.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT3_2026.Clr9Click(Sender: TObject);
begin
(*
FirstReturnColor.Caption:=IntToStr(clr9.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT3_2026.Clr10Click(Sender: TObject);
begin
(*
 FirstReturnColor.Caption:=IntToStr(clr10.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT3_2026.Clr11Click(Sender: TObject);
begin
(*
 FirstReturnColor.Caption:=IntToStr(clr11.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmT3_2026.CreateNewDirBtnClick(Sender: TObject);
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
procedure TOptionsFrmT3_2026.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:=ValidateOptions;
end;

procedure TOptionsFrmT3_2026.LogoFileExit(Sender: TObject);
begin
 FormPaint(Sender);
end;

procedure TOptionsFrmT3_2026.LogoFileKeyPress(Sender: TObject; var Key: Char);
begin
 If Key=#13 then FormPaint(Sender);
end;

procedure TOptionsFrmT3_2026.FormKeyPress(Sender: TObject; var Key: Char);
begin
EXIT;  //good but needs work
  if Key = #13 then
  begin
    Key := #0;
    //if (Sender is TDBGrid) then  TDBGrid(Sender).Perform(WM_KeyDown,VK_Tab,0) else
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;



procedure TOptionsFrmT3_2026.SelectBackupDirBtnClick(Sender: TObject);
Var DirSelected:String;   //20150805 Igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   BackupDir.Text:=DirSelected;
end;

procedure TOptionsFrmT3_2026.SaveBtnClick(Sender: TObject);
begin
 SaveOptions;
end;

procedure TOptionsFrmT3_2026.Prn_FontIncrChange(Sender: TObject);
begin
 If MyStrToInt(Prn_FontIncr.Text) >1 then Prn_FontIncr.Text:='1';
end;

procedure TOptionsFrmT3_2026.FixMessage(const msg: string;
  FocusElm: TWinControl);
var
  pg: TWinControl;
begin
(* show message and focus elm to fix.
  Must make page visible before SetFocus!
*)
  UserMsg(msg);
  pg := FocusElm.Parent;
  while not (pg is TTabSheet) do
    pg := pg.Parent;
  PageControl1.ActivePage := TTabSheet(pg);
  FocusElm.SetFocus;
end;

end.
