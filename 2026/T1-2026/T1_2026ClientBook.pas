unit T1_2026ClientBook;
//updated 07-28

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Db,
  ExtCtrls,Grids,DBGrids,StdCtrls,Mask,DBCtrls,ComCtrls,Buttons,
  VclTee.TeeProcs,VclTee.TeEngine,VclTee.Chart,FileCtrl,ComObj,MAPI,
  vtDataModuleUnit, VclTee.TeeGDIPlus, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager,
  uADCompClient, uADCompDataSet; // 20150820 igor

type
  TClientBookT1_2026 = class(TForm)
    BookBack: TShape;
    RPanel: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    DBEdit2: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit11: TDBEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    GroupBox4: TGroupBox;
    LPanel: TPanel;
    DBGrid1: TDBGrid;
    Panel6: TPanel;
    Image3: TImage;
    Image1: TImage;
    Image2: TImage;
    MonitorPlanBtn: TChart;
    Label17: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    SearchBox: TEdit;
    DataDirBox: TEdit;
    HelpBtn: TBitBtn;
    OpenBtn: TBitBtn;
    OpenSelBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    TabSheet2: TTabSheet;
    DBEdit16: TDBEdit;
    Panel2: TPanel;
    GroupBox5: TGroupBox;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit26: TDBEdit;
    DBEdit27: TDBEdit;
    GroupBox6: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    GroupBox3: TGroupBox;
    Label15: TLabel;
    DBEdit13: TDBEdit;
    GroupBox7: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit30: TDBEdit;
    Label9: TLabel;
    DBEdit8: TDBEdit;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    DBEdit31: TDBEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label29: TLabel;
    DBEdit32: TDBEdit;
    Label30: TLabel;
    DBEdit33: TDBEdit;
    Label31: TLabel;
    DBEdit34: TDBEdit;
    Label32: TLabel;
    DBEdit35: TDBEdit;
    Label33: TLabel;
    DBEdit36: TDBEdit;
    SelectCurBtn: TBitBtn;
    Label34: TLabel;
    SinBox: TEdit;
    Label35: TLabel;
    PhoneBox: TEdit;
    Label36: TLabel;
    StreetBox: TEdit;
    Label37: TLabel;
    FindNextPhoneBtn: TBitBtn;
    FirstNameBox: TEdit;
    Label38: TLabel;
    FindNextFirstNameBtn: TBitBtn;
    Label39: TLabel;
    FindNextStreetBtn: TBitBtn;
    EmailBtn: TBitBtn;
    CopyBtn: TBitBtn;
    TaxPlansBox: TCheckBox;
    HidePhotosBox: TCheckBox;
    EnlargeBtn: TBitBtn;
    GroupBox8: TGroupBox;
    PhotoImage: TImage;
    Table1: TADTable;
    Table1PrpStatusDescr: TStringField;
    Table1EfStatusDescr: TStringField;
    Table1ClientName: TStringField;
    Table1CalcMarStatus: TStringField;
    FDConnection: TADConnection;
    Table1LAST_NAME: TStringField;
    Table1FIRST_NAME: TStringField;
    Table1FILE_NAME: TStringField;
    Table1AREA: TStringField;
    Table1PHONE: TStringField;
    Table1FAX: TStringField;
    Table1MARSTATUS: TIntegerField;
    Table1EF_STATUS: TStringField;
    Table1PRP_STATUS: TStringField;
    Table1CREATED_BY: TStringField;
    Table1CREATED_DT: TStringField;
    Table1CREATED_TM: TStringField;
    Table1UPDATED_BY: TStringField;
    Table1UPDATED_DT: TStringField;
    Table1UPDATED_TM: TStringField;
    Table1RTUSENT_BY: TStringField;
    Table1RTUSENT_DT: TStringField;
    Table1RTUSENT_TM: TStringField;
    Table1ACKRCVD_BY: TStringField;
    Table1ACKRCVD_DT: TStringField;
    Table1ACKRCVD_TM: TStringField;
    Table1PRINTED_BY: TStringField;
    Table1PRINTED_DT: TStringField;
    Table1PRINTED_TM: TStringField;
    Table1DCN_NO: TStringField;
    Table1SIN: TStringField;
    Table1BIRTHDATE: TStringField;
    Table1STREET: TStringField;
    Table1APARTMENT: TStringField;
    Table1CITY: TStringField;
    Table1PROVINCE: TStringField;
    Table1POSTAL: TStringField;
    Table1COUNTRY: TStringField;
    Table1EF_ELGBL: TStringField;
    Table1RTUFILE: TStringField;
    Table1ACKFILE: TStringField;
    Table1COMPL_BY: TStringField;
    Table1COMPL_DT: TStringField;
    Table1COMPL_TM: TStringField;
    Table1DISCOUNTED: TStringField;
    Table1DUE_DT: TStringField;
    Table1NOTES: TStringField;
    Table1PAY_AMOUNT: TFloatField;
    Table1PAY_INVNO: TStringField;
    Table1PAY_TYPE: TStringField;
    Table1INV_AMOUNT: TFloatField;
    Table1PAY_DT: TStringField;
    Table1FAXAREA: TStringField;
    Table1FAMILYHEAD: TStringField;
    Table1CLIENT_ID: TStringField;
    Table1TITLE: TStringField;
    Table1EMAIL: TStringField;
    Table1EMAIL2: TStringField;
    Table1TAXPROV: TStringField;
    Table1GENDER: TStringField;
    Table1CATEGORY: TStringField;
    Function  ShowReturns: Boolean;
    {procedure OpenTable1;}
    procedure Table1CalcFields(DataSet: TDataSet);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure OpenSelBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DataDirBoxExit(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure SelectCurBtnClick(Sender: TObject);
    procedure SinBoxKeyPress(Sender: TObject; var Key: Char);
    procedure PhoneBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FindNextPhoneBtnClick(Sender: TObject);
    procedure FindByPhone;
    procedure FindByFirstName;
    procedure FirstNameBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FindNextFirstNameBtnClick(Sender: TObject);
    procedure FindOtherBtnClick(Sender: TObject);
    procedure StreetBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FindNextStreetBtnClick(Sender: TObject);
    procedure FindByStreet;
    procedure FindBySin;
    procedure EmailBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure TaxPlansBoxClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure EnlargeBtnClick(Sender: TObject);
   // procedure ShowPhotoId;
    procedure ShowPhotoId(PhotoIdFlName:String);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HidePhotosBoxClick(Sender: TObject);
    Function GetPhotoIdFlName(LastName:String;FirstName:String):String;
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FTableFindFirst: String;//20170605 Igor
    procedure FindBy(const ACaption, AValue: String;
      AFieldNames: array of String);//20170518 Igor
    { Private declarations }
  public
   // RetNo:Integer;
    InitialDir : String;
    ShowSw: boolean; //to be set before ShowModal
  end;

var
  ClientBook: TClientBookT1_2026;

implementation

uses vtMulti,vtCommon,vtMain,vtDialogs,T1_2026,T1_2026Declare,T1_2026TrimStr,
  T1_2026common,T1_2026Common2,T1_2026ChildWinNEW,T1_2026T1Rtns,T1_2026Calc,
  T1_2026Features,T1_2026cpl,T1_2026CntErr,T1_2026CopyMoveFrm,T1_2026main,
  vtTrimStr,vtShared,Variants, vtDataBase;

{$R *.DFM}

procedure TClientBookT1_2026.FormCreate(Sender: TObject);
var
 i:Integer;
begin
   //20150904 igor
 FDConnection.Params.Values['Password'] := OptRec.SQLLitePassword.CurrentPassword; //20160226 Igor

 ShowSw := True; //??? show by default?
 PageControl1.ActivePage := Tabsheet1;
 DataDirBox.Text := OptRec.Dir_Cur;
 Screen.Cursor := crHourGlass;
 If HasvtScanLicense = false then HidePhotosBox.Checked:=True;
// PhotoIdLabel.Caption:='Client Photo Id';
 ShowReturns;
 Screen.Cursor := crDefault;
 ActiveControl := SearchBox; //20160719 Igor
//20171031 Igor >>>
 if CheckIsCloud(true) then //20180503 Igor
 begin
   DataDirBox.enabled := False;
   SelectCurBtn.enabled := False;
 end;
//20171031 Igor <<< 
end;

procedure TClientBookT1_2026.Table1CalcFields(DataSet: TDataSet);
Begin
  try
    Table1PrpStatusDescr.Value := PrpStatusDescr[MyStrToInt(Table1['Prp_Status'])];
    Table1EfStatusDescr.Value := EFStatusDescr[MyStrToInt(Table1['EF_Status'])];
  except
  end;

If Table1['Last_Name'] <> Null then
 Table1ClientName.Value := AllTrim(Table1['Last_Name'])
else
 Table1ClientName.Value := '';
If Table1['First_Name'] <> Null then
 Table1ClientName.Value := Table1ClientName.Value
     +', '+AllTrim(Table1['First_Name']);
Table1CalcMarStatus.Value := MarDescr[StrToInt(Table1['MarStatus'])];
end;

procedure TClientBookT1_2026.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then OpenBtnClick(Application);
end;


procedure TClientBookT1_2026.OpenSelBtnClick(Sender: TObject);
begin
  //20170901 Igor>>>
  If AppT1_2026.ExceedsMaxReturnsAllowed(false) then
  begin
    //    ShowMessage('Number of returns exceeds maximum allowed '
    //   +'('+IntToStr(LimitedVersionReturns)+')'+
    //   Chr(13)+' in the T1 Limited version');
    // +Chr(13)+'Please delete some returns');
    Exit;
  end;
  //20170901 Igor<<<

  Table1.Close;
  Close;
  //20171031 Igor >>>
  TThread.CreateAnonymousThread(procedure
    begin
      TThread.Synchronize(nil, procedure
        begin
          MainFormT1.Openselectively1Click(Nil);
        end);
    end).Start;
    //20171031 Igor <<<
end;

procedure TClientBookT1_2026.OpenBtnClick(Sender: TObject);
var
 result : integer;
 FlName : string;
 sin : string;
 s:String;
 RetNo:Integer;
begin
 If OptRec.Dir_Planner = OptRec.Dir_Cur then
 begin
   ShowMessage('Click on Configure | General Options | Data Directories'+
   Chr(13)+'Change the Tax planner Dir to be different than the Current Directory'+
   Chr(13)+'i.e. enter it as C:\T1-'+AppYear+'\Planner');
   Exit;
 end;
  FlName:=Table1.FieldByName('File_Name').AsString;
  ModalResult := mrOk; //20160612 Igor
  CloseModal;
  OpenReturnCoupled(DataDirBox.Text,FlName,ShowSw);
end;

procedure TClientBookT1_2026.DeleteBtnClick(Sender: TObject);
Var FlName:String;
begin
  If LicenseLevel in anyMulti then
  begin
    If YouKnowTheAdminPassword = false then exit;
  end;
  //20170210 Igor >>>
(*
  FlName := Table1.FieldByName('File_Name').AsString;
  If FlName = '' then exit;
  if MessageDlg(Table1.FieldByName('Last_Name').AsString
   +Chr(13)+ 'Delete?',
   mtInformation, [mbYes, mbNo], 0) = mrYes then
   begin
    Table1.Edit;
    Table1.Delete;
    If FileExists(DataDirBox.Text+'\'+FlName)
     then SysUtils.DeleteFile(DataDirBox.Text+'\'+FlName);
   end;
 *)
   T1_2026TrimStr.DeleteReturn(DataDirBox.Text, Table1.FieldByName('File_Name').AsString, Table1);
   //20170210 Igor <<<
end;

Function TClientBookT1_2026.ShowReturns: Boolean;
var DataBaseFile: string;
begin
 DataBaseFile := IncludeTrailingPathDelimiter(DataDirBox.Text) + ClientsDbLite;
 If Not FileExists(DataBaseFile) then
 begin
  ErrorMsg('Missing ' + DataBaseFile);
  ShowMessage('There is no Clients data base in this directory'+
    Chr(13)+'Use Configure | Data Directories');
    result :=false;
    exit;
 end;
 Result := true;

 if not SetTableName(FDConnection, Table1, DataBaseFile, ClientsTableLite, 'LAST_Name') then
    exit;

 //DataDirBox.Text := OptRec.Dir_Cur;
 Screen.Cursor := crDefault;
 If Table1.RecordCount = 0 then
 begin
  ShowMessage('DataBase is empty. Press Close');
  exit;
 end;
 DBGrid1.Update;
end;

procedure TClientBookT1_2026.HelpBtnClick(Sender: TObject);
begin
 ShowHelp('T1Help','Open_Return_by_Name');
end;

procedure TClientBookT1_2026.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TClientBookT1_2026.SearchBoxChange(Sender: TObject);
begin
//20170521 Igor >>>
  FindBy('Last name', SearchBox.Text, ['LAST_NAME']);
// with Table1 do
//  begin
//  SetKey;
//  FieldByName('Last_Name').AsString := UpperCase(SearchBox.Text);
//  GotoNearest;
//  end;
//20170521 Igor <<<
end;

procedure TClientBookT1_2026.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CancelBtnClick(Sender);
end;

procedure TClientBookT1_2026.DataDirBoxExit(Sender: TObject);
begin
  If DataDirBox.Text = OptRec.Dir_Cur then exit;

  If LicenseLevel in anyMulti then
  begin
   If YouknowTheAdminPassword=False then exit;
  end;

  If (ChangeDataDir(DataDirBox.Text) = False) then
    begin
     DataDirBox.Text := OptRec.Dir_Cur;
     DataDirBox.Refresh;
     exit;
    end
   else
    begin
      OptRec.Dir_Cur := DataDirBox.Text;
      Try
      If Table1.Active then
         Table1.Close;
      if FDConnection.Connected then //20150820 igor
        FDConnection.Close;
      //20160226 Igor >>>>
      if not SetTableName(FDConnection, Table1,
                          IncludeTrailingPathDelimiter(DataDirBox.Text) + ClientsDbLite,
                          ClientsTableLite, UpperCase('Last_Name')) then
       exit;
//
//      FDConnection.Params.Values['DataBase'] := IncludeTrailingPathDelimiter(DataDirBox.Text) + ClientsDbLite;
//      Table1.TableName := ClientsTableLite;
//      Table1.IndexName := UpperCase('Last_Name'); // 20150920 Igor
//      Table1.Open;
      //20160226 Igor <<<<<
      DbGrid1.Refresh;
      except
      on EdataBaseError do
       begin
        ShowMessage('Open data Base failed'+
         Chr(13)+'If last year'+Chr(39)+'s directory then use the Import icon');;
       end;
      end; {except}
    end;
end;

procedure TClientBookT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then DataDirBoxExit(Application);
end;

procedure TClientBookT1_2026.DBGrid1DblClick(Sender: TObject);
begin
  OpenBtnClick(Sender);
end;

procedure TClientBookT1_2026.DBGrid1KeyPress(Sender: TObject; var Key: Char);
Var PhotoIdFlName:String;
begin
 If Key = #13 then Begin OpenBtnClick(Sender);Exit;End;
 PhotoIdFlName:=GetPhotoIdFlName(AllTrim(DbEdit12.Text),AllTrim(DbEdit1.text));
 //PhotoIdFlName:=GetPhotoIdFlName(Table1.FieldByName('Last_Name').AsString,Table1.FieldByName('First_Name').AsString);
 ShowPhotoId(PhotoIdFlName);
end;

procedure TClientBookT1_2026.SelectCurBtnClick(Sender: TObject);
Var DirSelected:String;
begin
 If LicenseLevel in anyMulti then
 begin
   If YouKnowTheAdminPassword = false then
    Begin
     ShowMessage('Only the ADMINistrator can select other directories');
     exit;
    end;
 end;

  if SelectDirectory('Select a folder:', '', DirSelected) then
 begin
  DataDirBox.Text := DirSelected;
  DataDirBoxExit(Sender);
  SearchBox.SetFocus;
 end;

 (*
 Application.CreateForm(TSelectDir,SelectDir);
 SelectDir.ShowModal;
 SelectDir.Free;
 If SelectedDir >'' then
 begin
  DataDirBox.Text := SelectedDir;
  DataDirBoxExit(Sender);
  SearchBox.SetFocus;
 end
 *)
end;


procedure TClientBookT1_2026.SinBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If (key=#13) and (SinBox.text>'') then FindBySin;
end;

procedure TClientBookT1_2026.FindBySin;
begin
//20170518 Igor >>>
  If SinBox.Text > '' then
  begin
    if Table1.Locate('SIN', SinBox.text, [loCaseInsensitive]) then
      OpenBtnClick(OpenBtn)
    else
      ShowTimedMsg('Searched to the end. SIN '+SinBox.Text+' was not found', 2000);
//     Table1.First;
//     Repeat
//      If Table1.FieldByName('SIN').AsString = SinBox.text then
//       begin OpenBtnClick(Application);exit;end;
//      Table1.Next;
//     until Table1.Eof;
//     ShowTimedMsg('Searched to the end. SIN '+SinBox.Text+' was not found',2000);
//     Table1.First;
  end; //sin has valu
//20170518 Igor <<<
end;

procedure TClientBookT1_2026.FindBy(const ACaption, AValue: String;
  AFieldNames: array of String);
//20170521 Igor>>>
var
  I: Integer;
  S: String;
  R: Boolean;
begin
  If AValue = '' then
    exit;
  //20170605 Igor >>>
  S := '';
  for I := Low(AFieldNames) to High(AFieldNames) do
  begin
    if S <> '' then
      S := S + ' or ';
    S := S + 'Upper(' + AFieldNames[i] + ') like ' + QuotedStr(UpperCase(AValue) + '%'); //20180320 Igor
  end;
  Table1.Filter := S;
  if FTableFindFirst <> ACaption + AValue then
    R := Table1.FindFirst
  else
    R := Table1.FindNext;
  if R then
  begin
    FTableFindFirst := ACaption + AValue;
    exit;
  end;

//  for I := Low(AFieldNames) to High(AFieldNames) do
//    If Table1.Locate(AFieldNames[I], AValue, [loCaseInsensitive, loPartialKey]) then
//      Exit;

  ShowTimedMsg('Searched to the end. ' + ACaption + ' ' + AValue + ' was not found', 2000);
  //20170605 Igor <<<
//  If AValue > '' then
//  begin
//    Len := Length(AValue);
//    Table1.DisableControls;
//    try
//      while not Table1.Eof do
//      begin
//        for I := Low(AFieldNames) to High(AFieldNames) do
//          If SameText(LeftStr(Table1.FieldByName(AFieldNames[I]).AsString, Len), AValue) then
//            exit;
//        Table1.Next;
//      end;
//      Table1.GotoBookmark(B); //20170521 Igor
//    finally
//      Table1.EnableControls;
//    end;
//    ShowTimedMsg('Searched to the end. ' + ACaption + ' ' + AValue + ' was not found', 2000);
//  end;
//20170521 Igor<<<
end;

procedure TClientBookT1_2026.FindNextPhoneBtnClick(Sender: TObject);
begin
  If PhoneBox.Text = '' then
    exit;
  //Table1.Next;//20170605 Igor
  FindByPhone;
end;

procedure TClientBookT1_2026.PhoneBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If (key=#13) and (PhoneBox.Text>'') then FindByPhone;
end;

procedure TClientBookT1_2026.FindByPhone; //20170518 Igor
begin
  FindBy('Phone', PhoneBox.Text, ['Phone']);
end;

procedure TClientBookT1_2026.FindNextFirstNameBtnClick(Sender: TObject);
begin
 If FirstNameBox.Text='' then exit;
// Table1.Next;//20170605 Igor
 FindByFirstName;
end;

procedure TClientBookT1_2026.FirstNameBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If (key=#13) and (FirstNameBox.text>'') then FindByFirstName;
end;

procedure TClientBookT1_2026.FindByFirstName; //20170518 Igor
begin
  FindBy('First Name', FirstNameBox.Text, ['First_Name'] );
end;

procedure TClientBookT1_2026.StreetBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If (key=#13) and (StreetBox.text>'') then FindByStreet;
end;

procedure TClientBookT1_2026.FindNextStreetBtnClick(Sender: TObject);
begin
 If StreetBox.Text='' then exit;
 //Table1.Next; //20170605 Igor
 FindByStreet;
end;

procedure TClientBookT1_2026.FindByStreet; //20170518 Igor
begin
  FindBy('Street/City', StreetBox.Text, ['Street', 'City'] );
end;

procedure TClientBookT1_2026.FindOtherBtnClick(Sender: TObject);
Var i:Integer;
begin
for i:=0 to Table1.Fields.count-1 do
 ShowMessage(Table1.Fields[i].FieldName);
end;

procedure TClientBookT1_2026.EmailBtnClick(Sender: TObject);
Var i:Integer;Dir,FlName:String; AListItem:TListItem;
SomeSubject,SomeRecipientEMail,SomeSenderEMail,SomeAttachment:String;
SomeText:String;
begin
 FlName:=Table1.FieldByName('File_Name').AsString;
 Dir:=DataDirBox.Text;

 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Double an item';
 SomeList.Add('1. Email the tax return (raw data file) to your own EMail...');
 SomeList.Add('2. Email the tax return (raw data file) to tax return Reviewer...');
 SomeList.Add('3. Email the tax return (raw data file) to VisualTax support...');
 SomeList.Add('4. Email the tax return (raw data file) to any Email address...');
 SomeList.Add('________________________________________________________________');
 SomeList.Add('5. EMail the tax return (Printout only) to any Email address...');
 SomeList.Add('   See also: Print|Email current form...(after opening the return)');

 SelectedString := PopSomeList(SomeList, SomeCaption);
 //SomeList.Free; //20160301 Igor
 If SelectedString > '' then SelectedString:=LeftStr(SelectedString,1);
 If (SelectedString='1') or (SelectedString='2')
 or (SelectedString='3') or (SelectedString='4')
 then
  //ok
 else
 begin
  ShowTimedMsg('Invalid selection',1200);
  Exit;
 end;

 If (SelectedString ='1') or (SelectedString ='2') or (SelectedString ='3')
 or (SelectedString ='4') then
 begin
  If SelectedString='1' then  //yourself
  begin
     SomeRecipientEmail:=OptRec.Prp_Email; //youself
     If SomeRecipientEMail='' then
       ShowMessage('Preparer'+Chr(39)+'s Email not entered.'
         +Chr(13)+'You may enter it in Configure | General Options');
  end;

  If SelectedString='2' then  //to reviewer
  begin
     SomeRecipientEmail:=OptRec.Reviewer_EMail; //reviewer
     If SomeRecipientEMail='' then
       ShowMessage('Reviewer'+Chr(39)+'s Email not entered.'
         +Chr(13)+'You may enter it in Configure | General Options');
  end;

  If SelectedString='3' then SomeRecipientEmail:='visualtax@sympatico.ca';
  If SelectedString='4' then SomeRecipientEmail:='';
 end;
  SomeSenderEmail:='';  //default?  'VisualTax@Sympatico.ca';
  SomeSubject:='A tax return';
  SomeAttachment:=Dir+'\'+FlName;
  SomeText:=Chr(13)
                +'The tax return is attached'
                +Chr(13)+' '
                +Chr(13)+' '
                +Chr(13)+'Thank you '
                +Chr(13)+' '
                +Chr(13)+OptRec.Prp_Name
                +Chr(13)+' ('+OptRec.Prp_Area+') '+OptRec.Prp_Tel;
   MainFormT1.SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEMail);
end;

procedure TClientBookT1_2026.CopyBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;
begin
//20171031 Igor >>>
  if StartParams.IsDemo then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
//20171031 Igor <<<
  If LicenseLevel in anyMulti then
  begin
   If YouKnowTheAdminPassword = false then exit;
  end;

  SomeFile:= Table1.FieldByName('File_Name').AsString;
  SomeString:= DataDirBox.Text;//from dir
  SomeCaption:= Table1.FieldByName('First_Name').AsString + ' '+
      Table1.FieldByName('Last_Name').AsString; //return name
  Application.CreateForm(TCopyMoveFrmT1_2026,CopyMoveFrm);
  CopyMoveFrm.ShowModal;
  CopyMoveFrm.Free;
  If SomeResult=True then
    ShowMessage('Done')
  Else
   ShowMessage('Failed!');
  ShowReturns;
  self.BringToFront; //20160226 Igor
end;


procedure TClientBookT1_2026.TaxPlansBoxClick(Sender: TObject);
begin
 If TaxPlansBox.Checked then
  DataDirBox.Text := OptRec.Dir_Planner
 Else
  DataDirBox.Text := OptRec.Dir_cur;
 Screen.Cursor := crHourGlass;
 ShowReturns;
 Screen.Cursor := crDefault;
end;

//20120127
procedure TClientBookT1_2026.DBGrid1CellClick(Column: TColumn);
Var PhotoIdFlName:String;
  ScaleX, ScaleY: Integer;
  RR: TRect;
  Handle,Hdc,Client:THandle;
  ACanvas:TCanvas;
  P1:TPicture;
  b1:TBitMap;
  ARect:TRect;
begin
 PhotoIdFlName:=GetPhotoIdFlName(AllTrim(DbEdit12.Text),AllTrim(DbEdit1.text));
//The following does not work if key is pressed up and down. It is one row off (so used from buffer)
// PhotoIdFlName:=GetPhotoIdFlName(Table1.FieldByName('Last_Name').AsString,Table1.FieldByName('First_Name').AsString);
 ShowPhotoId(PhotoIdFlName);
end;



procedure TClientBookT1_2026.ShowPhotoId(PhotoIdFlName:String);
Var ScaleX, ScaleY: Integer;
  RR: TRect;
  Handle,Hdc,Client:THandle;
  ACanvas:TCanvas;
  P1:TPicture;
  b1:TBitMap;
  ARect:TRect;
begin
// PhotoIdLabel.Caption:='Client PHOTO ID';

 If HidePhotosBox.Checked then
  Begin PhotoImage.Picture:=Nil;PhotoImage.Refresh;Exit;end;


 If FileExists(PhotoIdFlName) then
 begin
  If hasVtScanLicense then
  Begin
   PhotoImage.Picture.LoadFromFile(PhotoIdFlName);
   PhotoImage.Stretch:=True; //shrinks too much
  End; //valid lic
 end
 Else
 begin
  PhotoImage.Picture:=Nil;
//  PhotoIdLabel.Caption:='Client Photo Id is not available';
 end;
 PhotoImage.Refresh;
end;

procedure TClientBookT1_2026.EnlargeBtnClick(Sender: TObject);
Var PhotoIdFlName:String;
begin
 If HidePhotosBox.Checked then Begin PhotoImage.Picture:=Nil;PhotoImage.Refresh;Exit;end;
 PhotoIdFlName:=GetPhotoIdFlName(AllTrim(DbEdit12.Text),AllTrim(DbEdit1.text));
 If HasvtScanLicense then ShowClientPhotoId(PhotoIdFlName);
end;

procedure TClientBookT1_2026.HidePhotosBoxClick(Sender: TObject);
Var PhotoIdFlName:String;
begin
 PhotoIdFlName:=GetPhotoIdFlName(AllTrim(DbEdit12.Text),AllTrim(DbEdit1.text));
 ShowPhotoId(PhotoIdFlName);
end;

Function TClientBookT1_2026.GetPhotoIdFlName(LastName:String;FirstName:String):String;
Begin
 Result:=OptRec.Dir_ClientDocs+'\'+LastName+','+FirstName+'\Photo Id.bmp';
end;

procedure TClientBookT1_2026.DBGrid1KeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
Var PhotoIdFlName:String;
begin
 PhotoIdFlName:=GetPhotoIdFlName(AllTrim(DbEdit12.Text),AllTrim(DbEdit1.text));
 ShowPhotoId(PhotoIdFlName);

end;

procedure TClientBookT1_2026.DBGrid1KeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
Var PhotoIdFlName:String;
begin
 PhotoIdFlName:=GetPhotoIdFlName(AllTrim(DbEdit12.Text),AllTrim(DbEdit1.text));
 ShowPhotoId(PhotoIdFlName);
end;

end.
