unit FP_2027OptionsFrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,ComCtrls,Db,Buttons,DBCtrls,Mask,FileCtrl,ColorGrd,vtLabel,
  vtEditBox,vtShape, System.IOUtils;
  {UCompLogo;}

type
  TOptionsFrmFP_2012 = class(TForm)
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
    Label45: TLabel;
    Label31: TLabel;
    Panel5: TPanel;
    ScrollBox4: TScrollBox;
    Panel19: TPanel;
    ScrollBox5: TScrollBox;
    DefaultsPanel: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Prp_Dates: TCheckBox;
    ShowInvoiceWarning: TCheckBox;
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
    FontPanel: TPanel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Prn_FontIncr: TEdit;
    NoTypeAhead: TCheckBox;
    UseProperName: TCheckBox;
    Capitalization: TRadioGroup;
    Label11: TLabel;
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
    Label32: TLabel;
    Label33: TLabel;
    SelectT1Dir: TBitBtn;
    T1DataDir: TEdit;
    Label38: TLabel;
    Label43: TLabel;
    Label145: TLabel;
    Dir_DBFData: TEdit;
    SelectDBFBtn: TBitBtn;
    Label138: TLabel;
    Dir_PgmLastYr: TEdit;
    SelectLYPrgmDir: TBitBtn;
    //20180123 Igor >>>
    GroupBox2: TGroupBox;
    ActiveTabColor: TShape;
    SetActiveTabColor: TBitBtn;
    //20180123 Igor <<<
    //20180206 Igor >>>
    GroupBox1: TGroupBox;
    Skin: TComboBox;
    Label28: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    //20180206 Igor <<<
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
   // procedure SetupEOLBtnClick(Sender: TObject);
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
    procedure SelectT1DirClick(Sender: TObject);
    procedure SelectDBFBtnClick(Sender: TObject);
    procedure SelectLYPrgmDirClick(Sender: TObject);
    procedure SetActiveTabColorClick(Sender: TObject); //20180123 Igor

    //Procedure SaveAGroupControl(AControl:TControl;TempList:TStringList);
  private
    procedure FixMessage(const msg: string; FocusElm: TWinControl);
  public
    { Public declarations }
  end;

var
  OptionsFrm: TOptionsFrmFP_2012;

implementation

{$R *.DFM}

uses vtMulti,vtDialogs,vtMain,vtChild,vtCommon,FP_2027,FP_2027TrimStr,
  FP_2027Declare,FP_2027Common,FP_2027Fees,FP_2027ChildWinNew,FP_2027PopList,
  FP_2027SelectFile,FP_2027Calc,fSelectDir,FP_2027Main,FP_2027Features,
  vtHelperManager, //20190228 Igor
  vtTrimStr,vtShared;

Function TOptionsFrmFP_2012.SaveOptions:Boolean;
Var TempList:TStringList;
begin
 Result:= ValidateOptions;
{$IFDEF debug}
  //always save
{$ELSE}
 if Result = True then
{$ENDIF}
 begin
     SaveOptionsToFile;
     LoadOptionsFileToMem;
     TempList:=TStringList.Create;
     TempList.Add(Dir_Cur.Text);
     TempList.Add(Dir_LastYr.Text);
     TempList.Add(Dir_DBFData.Text); //20160226 Igor
     TempList.SaveToFile(AppDir+'/'+'DIRS.d');
     TempList.Free;
     MainFormFP.ShowMostRecentReturns;
 end;
end;

Function TOptionsFrmFP_2012.ValidateOptions:Boolean;
Var TempList:TStringList;
begin
Try
 Result:=False;
 If IsDataDirectoryGood(Dir_Cur.Text) = False then exit;
 If IsDataDirectoryGood(Dir_Deflt.Text) = False then exit;
 If (Dir_Cur.Text >'') and (UpperCase(Dir_Cur.Text) = UpperCase(T1DataDir.text)) then
 begin
  FixMessage('The FP and T1 data directory cannot be the same', T1DataDir);
  Exit;
 end;
 If T1DataDir.text>'' then
 begin
  If FileExists(T1DataDir.text+'\'+ClientsDBLite('T1')) = false then //20150922 Igor
  begin
   FixMessage('The T1 data directory does not contain T1 data',T1DataDir);
   Exit;
  end;
 end;
 {$I-}
 if DirectoryExists(Dir_Cur.Text) and
   not FileExists(Dir_Cur.Text+'\'+ClientsDBLite) then //20150922 Igor
        if InitDataBase(AppDir,Dir_Cur.Text) = false then
            begin
             FixMessage('Data Base cannot be created',Dir_Cur);
             Exit;
            end;

  if (EditDirectory(Dir_Cur.Text)) and
     (EditDirectory(Dir_Deflt.Text)) and
     (EditDirectory(Dir_LastYr.Text, True)) and //20160229 Igor
     (EditDirectory(BackUpDir.text))
  then
  begin
      {initialize data bases}
      If FileExists(Dir_Cur.Text+'\'+ClientsDBLite) = false then //20150922 Igor
        if InitDataBase(AppDir,Dir_Cur.Text) = false then
            begin
             FixMessage('Data Base cannot be created',Dir_Cur);
             Exit;
            end;
      If FileExists(Dir_Deflt.Text+'\'+ClientsDBLite) = false then //20150922 Igor
        if InitDataBase(AppDir,Dir_Deflt.Text) = false then
            begin
             FixMessage('Data Base cannot be created',Dir_Deflt);
             Exit;
            end;
  end
  else
    exit;

 except
 end;
  //20160226 Igor >>>>
 if (dir_DbfData.Text <> '') AND
    not directoryExists(dir_DbfData.Text) then
 Begin
   ShowMessage('Invalid data directory of the FP-2020 production data (prior to Multi-App) '+ //20160305 Igor
                dir_DbfData.Text +' (it does not exist)');
   PageControl1.ActivePage := TabSheet3;
   Dir_DbfData.SetFocus;
   Exit;
 end;
 if (dir_DbfData.Text <> '') AND
    not FileExists(dir_DbfData.Text+'\'+ClientsTable_dbf) then
 Begin
   ShowMessage('Invalid data directory of the FP-2020 production data (prior to Multi-App) '+ //20160305 Igor
                dir_DbfData.Text +' (file "'+ClientsTable_dbf+'" does not exist).');    //not exists  //20171206 Con
   PageControl1.ActivePage := TabSheet3;
   Dir_DbfData.SetFocus;
   Exit;
 end;
 if (dir_DbfData.Text <> '') AND (dir_DbfData.Text = dir_Cur.Text) then
 Begin
   ShowMessage('Invalid data directory of the FP-2020 production data (prior to Multi-App) '+  //20160305 Igor
                dir_DbfData.Text +' (Current Directory and data directory of the FP-2020 production data (prior to Multi-App)'+
                ' cannot be the same)');
   PageControl1.ActivePage := TabSheet3;
   Dir_DbfData.SetFocus;
   Exit;
 end;
//20160226 Igor <<<<<
 If ValidEMail(PrP_EMail.text)=False then
 begin
   FixMessage('Please enter a valid EMail',Prp_EMail);
   Exit;
 end;
 If ValidEMail(Reviewer_EMail.text)=False then
 begin
   FixMessage('Please enter a valid Reviewer EMail',Reviewer_EMail);
   Exit;
 end;


 If AllTrim(Prp_VSFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_VSFee.Text)) then
  begin
   FixMessage('Please enter a valid amount',Prp_VSFee);
   Exit;
  end;
 end;

 If AllTrim(Prp_SFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_SFee.Text)) then
  begin
   FixMessage('Please enter a valid amount',Prp_SFee);
   Exit;
  end;
 end;

 If AllTrim(Prp_AFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_AFee.Text)) then
  begin
   FixMessage('Please enter a valid amount',Prp_AFee);
   Exit;
  end;
 end;

 If AllTrim(Prp_CFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_CFee.Text)) then
  begin
   FixMessage('Please enter a valid amount',Prp_CFee);
   Exit;
  end;
 end;

 If AllTrim(UpdateFrequency.Text)>'' then
 begin
  If (Not Numeric(UpdateFrequency.Text)) then
  begin
   FixMessage('Please enter a valid number',UpdateFrequency);
   Exit;
  end;
 end;


 If AllTrim(Prp_VCFee.Text)>'' then
 begin
  If (Not RealNumeric(Prp_VCFee.Text)) then
  begin
   FixMessage('Please enter a valid amount',Prp_VCFee);
   Exit;
  end;
 end;

 If AllTrim(Prp_Hour.Text)>'' then
 begin
  If (Not RealNumeric(Prp_Hour.Text)) then
  begin
   FixMessage('Please enter a valid amount',Prp_Hour);
   Exit;
  end;
 end;


 If AllTrim(Opr_GstHst.Text)>'' then
 begin
  If (Not RealNumeric(Opr_GstHst.Text))
  or (Vl(Opr_GstHst.Text)>100) then
  begin
   FixMessage('Please enter a valid percentage',Opr_GstHst);
   Exit;
  end;
 end;


 Result:=True;
end;


Function TOptionsFrmFP_2012.CheckBoxToText(ACheckBox:TCheckBox):String;
begin
 If ACheckBox.Checked then result:='X' else Result:='';
end;


procedure TOptionsFrmFP_2012.SaveOptionsToFile;
Var i,j,jj:Integer; ABox:TEdit;AControl:TControl;TempList:TStringList;s:String;
begin
 TempList:=TStringList.Create;
 Screen.Cursor:=crHourGlass;
 //save values
   SaveOptionValue(Dir_Cur.Name,Dir_Cur.Text,TempList);
   SaveOptionValue(BackUpFrequency.Name,BackUpFrequency.Text,TempList);
   SaveOptionValue(BackupDir.Name,BackUpDir.Text,TempList);
   SaveOptionValue(LastBackupDir.Name,LastBackUpDir.Text,TempList);
   SaveOptionValue(Dir_Deflt.Name,Dir_Deflt.Text,TempList);
   SaveOptionValue(T1DataDir.Name,T1DataDir.Text,TempList);
   SaveOptionValue(Dir_LastYr.Name,Dir_LastYr.Text,TempList);
   SaveOptionValue(Dir_PgmLastYr.Name,Dir_PgmLastYr.Text,TempList);//20160704 Igor
   SaveOptionValue(Dir_DBFData.Name,Dir_DBFData.Text,TempList);

   SaveOptionValue(Prp_Name.Name,Prp_Name.Text,TempList);

   SaveOptionValue(Prn_LMargin.Name,Prn_LMargin.Text,TempList);
   SaveOptionValue(Prn_RMargin.Name,Prn_RMargin.Text,TempList);
   SaveOptionValue(Prn_FontIncr.Name,Prn_FontIncr.Text,TempList);

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
   else If Capitalization.ItemIndex =1  then s:='ProperCase';
   SaveOptionValue(Capitalization.Name,s,TempList);

   SaveOptionValue(Prn_NameH.Name,CheckBoxToText(Prn_NameH),TempList);
   SaveOptionValue(Prn_SinH.Name,CheckBoxToText(Prn_SinH),TempList);
   SaveOptionValue(Prn_DateH.Name,CheckBoxToText(Prn_DateH),TempList);
   SaveOptionValue(Opr_GstHst.Name,Opr_GstHst.Text,TempList);

   //other options
   SaveOptionValue(UseFastPrint.Name,CheckBoxToText(UseFastPrint),TempList);
   SaveOptionValue(UseProperName.Name,CheckBoxToText(UseProperName),TempList);
   SaveOptionValue(NoTypeAhead.Name,CheckBoxToText(NoTypeAhead),TempList);
   SaveOptionValue(ShowInvoiceWarning.Name,CheckBoxToText(ShowInvoiceWarning),TempList);

   SaveOptionValue(InvFoot1.Name,InvFoot1.Text,TempList);
   SaveOptionValue(InvFoot2.Name,InvFoot2.Text,TempList);
   SaveOptionValue(InvFoot3.Name,InvFoot3.Text,TempList);
   SaveOptionValue(InvFoot4.Name,InvFoot4.Text,TempList);
   SaveOptionValue(InvFoot5.Name,InvFoot5.Text,TempList);

   SaveOptionValue(ActiveBoxColor.Name,ActiveBoxColor.Text,TempList);

   SaveOptionValue(DataInBold.Name,CheckBoxToText(DataInBold),TempList);
   SaveOptionValue(HideMostRecent.Name,CheckBoxToText(HideMostRecent),TempList);

//shared options
   //SaveOptionValue(FormZoom.Name,FormZoom.Text,TempList);
    //not here
   //SaveOptionValue(SingleLoginId.Name,SingleLoginId.Text,TempList);
   MainOptions.SingleLoginId := SingleLoginId.Text;
   //SaveOptionValue(SkipLogin.Name,CheckBoxToText(SkipLogin),TempList);
   MainOptions.SkipLogin := SkipLogin.Checked;
   //SaveOptionValue(UpdateFrequency.Name,UpdateFrequency.Text,TempList);
   MainOptions.UpdateFrequency := StrToInt(UpdateFrequency.Text);
   MainOptions.Skin := TSkin(Skin.ItemIndex);//20180206 Igor
   MainOptions.ActiveTabColor := ActiveTabColor.Brush.Color; //20180123 Igor
   MainOptions.Save; //20170127 Igor

 TempList.SaveToFile(AppDir+'\'+OptionsFlName);
 TempList.Free;
 Screen.Cursor:=crDefault;
 ShowMessage('Saved');
end;


procedure TOptionsFrmFP_2012.LoadOptionsToForm;
Var i:Integer; TempList:TStringList;s:String;
Begin
 TempList:=TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+ OptionsFlName);
  //Read Values
   Dir_Cur.Text:=GetOptionValue('Dir_Cur',TempList);
   BackUpFrequency.Text:=GetOptionValue('BackUpFrequency',TempList);
   BackUpDir.Text:=GetOptionValue('BackUpDir',TempList);
   LastBackUpDir.Text:=GetOptionValue('LastBackUpDir',TempList);
   Dir_Deflt.Text:=GetOptionValue('Dir_Deflt',TempList);
   T1DataDir.Text:=GetOptionValue('T1DataDir',TempList);
   Dir_LastYr.Text:=GetOptionValue('Dir_LastYr',TempList);
   Dir_PgmLastYr.Text:=GetOptionValue('Dir_PgmLastYr',TempList); //20160704 Igor
   Dir_DBFData.Text:=GetOptionValue('Dir_DBFData',TempList);

   Prp_Name.Text:=GetOptionValue('Prp_Name',TempList);
   Prn_LMargin.Text:=GetOptionValue('Prn_LMargin',TempList);
   Prn_RMargin.Text:=GetOptionValue('Prn_RMargin',TempList);
   Prn_FontIncr.Text:=GetOptionValue('Prn_FontIncr',TempList);
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
   Opr_GstHst.Text:=GetOptionValue('Opr_GstHst',TempList);

   //other options
   UseFastPrint.Checked:=StringToBoolean(GetOptionValue('UseFastPrint',TempList));
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

//shared options
   //FormZoom.Text:=GetOptionValue('FormZoom',TempList);
   FormZoom.Text := IntToStr(MainOptions.FormZoom);
   //SingleLoginId.Text:=GetOptionValue('SingleLoginId',TempList);
   SingleLoginId.Text:=MainOptions.SingleLoginId;
   //SkipLogin.Checked:=StringToBoolean(GetOptionValue('SkipLogin',TempList));
   SkipLogin.Checked:=MainOptions.SkipLogin;
   //UpdateFrequency.Text:=GetOptionValue('UpdateFrequency',TempList);
   UpdateFrequency.Text:= IntToStr(MainOptions.UpdateFrequency);
   Skin.ItemIndex := Integer(MainOptions.Skin);//20180206 Igor
   ActiveTabColor.Brush.Color := MainOptions.ActiveTabColor; //20180123 Igor
   TempList.Free;
end;

procedure TOptionsFrmFP_2012.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 //Enter as Tab
 KeyPreview:=True;
 //set all form's buttons property Default to False
 //Create an OnKeyPress event for the form like this:

  PageControl1.ActivePage:=TabSheet1;
 (*
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
 *)
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
      T1DataDir.Enabled := False;
      SelectT1Dir.Enabled := False;
      SelectLYPrgmDir.Enabled := False;
      Dir_DBFData.Enabled := False;
      SelectDBFBtn.Enabled := False;
//      Dir_PermanentDocs.Enabled := False;
//      btnSelectPermanentDir.Enabled := False;
      Dir_LastYr.Enabled := False;
      SelectL1Btn.Enabled := False;
      Dir_PgmLastYr.Enabled := False;
      SelectBackupDirBtn.Enabled := False;
      BackupDir.Enabled := False;
      //btnUploadLastYearData.Visible := True; //20180111 Igor
   end;
   //20180503 Igor <<<
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
   If T1DataDir.text='' then
    if CheckIsCloud(true) then
      T1DataDir.text := TPath.Combine(AppDir, 'Data')
    else
      T1DataDir.text:='C:\vt-2015\T1-'+IntToStr(StrToInt(AppYear)-1)+'\Data';
   If Dir_LastYr.text='' then
    if CheckIsCloud(true) then
      Dir_LastYr.text := ''
    else
      Dir_LastYr.text:='C:\Fp-2015\Data';
   //20180503 Igor <<<
   LinkedBoxColor.Text:=IntToStr(BrightGreen); //(RGB(151,255,151));
   LinkedBoxColor.Color:=BrightGreen; //RGB(151,255,151);
   LinkedBoxColor.Font.Color:=BrightGreen; //RGB(151,255,151);

   ProtectedBoxColor.Text:=IntToStr(DarkShade); //IntToStr(Rgb(130,130,130));
   ProtectedBoxColor.Color:=DarkShade; //Rgb(130,130,130);
   ProtectedBoxColor.Font.Color:=DarkShade; //Rgb(130,130,130);

   LoadPluginSettings(AppFP.AppId, UserName, Self, PageControl1); //20190228 Igor
end;

procedure TOptionsFrmFP_2012.SelectCurBtnClick(Sender: TObject);
Var DirSelected: String; //20150817 igor
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

procedure TOptionsFrmFP_2012.SelectDBFBtnClick(Sender: TObject);
Var DirSelected: String; // 20150817 igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   Dir_DBFData.Text:=DirSelected;
end;

procedure TOptionsFrmFP_2012.SelectDefBtnClick(Sender: TObject);
Var DirSelected: String; // 20150817 igor
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

procedure TOptionsFrmFP_2012.SelectL1BtnClick(Sender: TObject);
Var DirSelected: String; //20150817 igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   Dir_LastYr.Text:=DirSelected;

end;

procedure TOptionsFrmFP_2012.SelectLYPrgmDirClick(Sender: TObject);
Var
  DirSelected:String;
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   Dir_PgmLastYr.Text:=DirSelected;
end;

Function TOptionsFrmFP_2012.EditDirectory(DirName: string; ALastYearDir: Boolean = False): boolean; //20160229 Igor
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


procedure TOptionsFrmFP_2012.FeesBtnClick(Sender: TObject);
begin
{
 If LeftStr(LicenseLevel,8) = 'T1 Multi' then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 If RetInMem>0 then
  begin ShowMessage('Close all returns first');exit;end;
 }
 Application.CreateForm(TFeesFP_2012,Fees);
 Fees.ShowModal;
 Fees.Free;
end;

procedure TOptionsFrmFP_2012.ListBox1Click(Sender: TObject);
begin
 Prp_bill.Text := AllTrim(IntToStr(ListBox1.ItemIndex));
end;

procedure TOptionsFrmFP_2012.SetActiveTabColorClick(Sender: TObject); //20180123 Igor
begin
  ColorDialog1.Color := ActiveTabColor.Brush.Color;
  if ColorDialog1.Execute then
    ActiveTabColor.Brush.Color := ColorDialog1.Color;
end;

procedure TOptionsFrmFP_2012.SetDisplayBtnClick(Sender: TObject);
begin
  MainForm.SetDisplayBtnClick(Sender);
end;


procedure TOptionsFrmFP_2012.BitBtn2Click(Sender: TObject);
begin
ShowHelp('FpHelp','Configuration');
end;

procedure TOptionsFrmFP_2012.BitBtn3Click(Sender: TObject);
begin
//howHelp('Data Directories');
end;

procedure TOptionsFrmFP_2012.SetPgmPswBtnClick(Sender: TObject);
begin
  SetThePgmPsw;
end;

procedure TOptionsFrmFP_2012.RemovePgmPswBtnClick(Sender: TObject);
begin
 RemovePgmPsw;
 ShowTimedMsg('Program Password Removed',1000);
end;

procedure TOptionsFrmFP_2012.FormPaint(Sender: TObject);
begin

 ActiveBoxColor.Font.Color :=ActiveBoxColor.Color;
 //If LeftStr(LicenseLevel,8) = 'T1 Multi' then
 If LicenseLevel in anyMulti then
 begin
  SkipLogin.Checked := False;
  SkipLogin.Enabled := False;
 end;

end;

procedure TOptionsFrmFP_2012.ExitBtnClick(Sender: TObject);
begin
  SaveOptions;
  ModalResult := mrOK;  // Close;
end;

procedure TOptionsFrmFP_2012.FormClose(Sender: TObject; var Action: TCloseAction);
var
  RetNo: integer;
begin
 MainFormFP.ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';

 If RetInMem>0 then
 begin
  RetNo:=GetCurrentRetNo;
  Calc(RetNo,'PAGE_1'); //for capitalization
  if assigned(RetList[RetNo]) AND Assigned(RetList[RetNo].MyChild) then  //20161031 Igor
  begin
    RetList[RetNo].MyChild.RefreshActiveForm;
    MainForm.RefreshAuditPanel(RetNo);
  end;
 end;
end;


procedure TOptionsFrmFP_2012.UseDefaultBoxColorClick(Sender: TObject);
begin
 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Select a color';
 SomeList.Add('1. Light Blue (for color consistency');
 SomeList.Add('2. Light Red (for greater visibility)');
 SomeList.Add('3. Select your own (use a light color)');

 Application.CreateForm(TPoplistFP_2012,PopList);
 PopList.ShowModal;
 //SomeList.Free; //20160704 Igor
 PopList.Release;
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
procedure TOptionsFrmFP_2012.Clr0Click(Sender: TObject);
begin
// SeFirstReturnColor(Sender);
 {
 FirstReturnColor.Caption:=IntToStr(clr0.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 }
end;

procedure TOptionsFrmFP_2012.clr7Click(Sender: TObject);
begin
 (*
 FirstReturnColor.Caption:=IntToStr(clr7.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmFP_2012.clr8Click(Sender: TObject);
begin
(*
FirstReturnColor.Caption:=IntToStr(clr8.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmFP_2012.Clr9Click(Sender: TObject);
begin
(*
FirstReturnColor.Caption:=IntToStr(clr9.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmFP_2012.Clr10Click(Sender: TObject);
begin
(*
 FirstReturnColor.Caption:=IntToStr(clr10.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmFP_2012.Clr11Click(Sender: TObject);
begin
(*
 FirstReturnColor.Caption:=IntToStr(clr11.color);
 FirstReturnColor.Color:=StrToInt(FirstReturnColor.Caption);
 FirstReturnColor.Font.Color:=StrToInt(FirstReturnColor.Caption);
 *)
end;

procedure TOptionsFrmFP_2012.CreateNewDirBtnClick(Sender: TObject);
Var s:String;
begin
 s:=CreateNewDataDir;
 If s>'' then  Dir_Cur.Text:=s;
end;

procedure TOptionsFrmFP_2012.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 if MessageDlg('Save options?',mtWarning, [mbYes, mbNo], 0) = mrYes then
   CanClose := SaveOptions;
  //CanClose:=ValidateOptions;
end;

procedure TOptionsFrmFP_2012.LogoFileExit(Sender: TObject);
begin
 FormPaint(Sender);
end;

procedure TOptionsFrmFP_2012.LogoFileKeyPress(Sender: TObject; var Key: Char);
begin
 If Key=#13 then FormPaint(Sender);
end;

procedure TOptionsFrmFP_2012.FormKeyPress(Sender: TObject; var Key: Char);
begin
EXIT;  //good but needs work
  if Key = #13 then
  begin
    Key := #0;
    //if (Sender is TDBGrid) then  TDBGrid(Sender).Perform(WM_KeyDown,VK_Tab,0) else
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;



procedure TOptionsFrmFP_2012.SelectBackupDirBtnClick(Sender: TObject);
Var DirSelected: String; //20150817 igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   BackupDir.Text:=DirSelected;
end;

procedure TOptionsFrmFP_2012.SaveBtnClick(Sender: TObject);
begin
 SaveOptions;
end;

procedure TOptionsFrmFP_2012.Prn_FontIncrChange(Sender: TObject);
begin
 If MyStrToInt(Prn_FontIncr.Text) >1 then Prn_FontIncr.Text:='1';

end;

procedure TOptionsFrmFP_2012.SelectT1DirClick(Sender: TObject);
Var DirSelected: String; //20150817 igor
begin
if SelectDirectory('Select a folder:', '', DirSelected) then
   T1DataDir.Text:=DirSelected;
end;

procedure TOptionsFrmFP_2012.FixMessage(const msg: string;
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
