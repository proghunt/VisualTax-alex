unit FP_2027ClientBook;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Db,
  ExtCtrls,Grids,DBGrids,StdCtrls,Mask,DBCtrls,ComCtrls,Buttons,
  VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart,FileCtrl,ComObj,MAPI,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TClientBookFP_2012 = class(TForm)
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
    Label28: TLabel;
    DBEdit31: TDBEdit;
    Bevel1: TBevel;
    Label30: TLabel;
    DBEdit33: TDBEdit;
    Label31: TLabel;
    DBEdit34: TDBEdit;
    Label32: TLabel;
    DBEdit35: TDBEdit;
    SelectCurBtn: TBitBtn;
    EmailBtn: TBitBtn;
    CopyBtn: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;
    Table1LAST_NAME: TStringField;
    Table1FIRST_NAME: TStringField;
    Table1PLANDATE: TStringField;
    Table1AREA: TStringField;
    Table1PHONE: TStringField;
    Table1FAX: TStringField;
    Table1MARSTATUS: TSmallintField;
    Table1PRP_STATUS: TStringField;
    Table1CREATED_BY: TStringField;
    Table1CREATED_DT: TStringField;
    Table1CREATED_TM: TStringField;
    Table1UPDATED_BY: TStringField;
    Table1UPDATED_DT: TStringField;
    Table1UPDATED_TM: TStringField;
    Table1ACKRCVD_BY: TStringField;
    Table1ACKRCVD_DT: TStringField;
    Table1ACKRCVD_TM: TStringField;
    Table1PRINTED_BY: TStringField;
    Table1PRINTED_DT: TStringField;
    Table1PRINTED_TM: TStringField;
    Table1SIN: TStringField;
    Table1BIRTHDATE: TStringField;
    Table1STREET: TStringField;
    Table1APARTMENT: TStringField;
    Table1CITY: TStringField;
    Table1PROVINCE: TStringField;
    Table1POSTAL: TStringField;
    Table1COUNTRY: TStringField;
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
    Table1TITLE: TStringField;
    Table1EMAIL: TStringField;
    Table1TAXPROV: TStringField;
    Table1GENDER: TStringField;
    Table1CATEGORY: TStringField;
    Table1FILE_NAME: TStringField;
    Table1PrpStatusDescr: TStringField;
    Table1CalcMarStatus: TStringField;
    Function  ShowReturns: Boolean;
    {procedure OpenTable1;}
    procedure Table1CalcFields(DataSet: TDataSet);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
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
    procedure FindOtherBtnClick(Sender: TObject);
    procedure EmailBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientBook: TClientBookFP_2012;
 // RetNo:Integer;
  InitialDir : string; //[66];

implementation

uses vtMulti,vtCommon,vtMain,vtDialogs,FP_2027,FP_2027Declare,FP_2027TrimStr,
  FP_2027common,FP_2027Common2,FP_2027ChildWinNEW,FP_2027Calc,FP_2027Features,
  FP_2027PopList,FP_2027CntErr,FP_2027CopyMoveFrm,FP_2027main,fSelectDir,
  vtTrimStr, vtShared, vtDataBase,
  vtDBF_SQLite, vtChild;//20170310 Igor //20170515 Igor

{$R *.DFM}

procedure TClientBookFP_2012.FormCreate(Sender: TObject);
var
 i:Integer;
begin
 //RetNo:=GetCurrentRetNo;
 //If RetNo=0 then RetNo:=InitNewReturn;
 PageControl1.ActivePage := Tabsheet1;
 DataDirBox.Text := OptRec.Dir_Cur;
 Screen.Cursor := crHourGlass;
 ShowReturns;
 Screen.Cursor := crDefault;
 ActiveControl := SearchBox; //20160719 Igor
 //20170412 Igor >>>
 if asConvertFromLastYear in ApplicationState then
 begin
   Label14.Caption := 'Select last year''s return for rollover';
   MonitorPlanBtn.Gradient.EndColor := $00C184FF;
 end;
 //20170412 Igor <<<
 //20180503 Igor >>>
 if CheckIsCloud(true) then
 begin
   DataDirBox.enabled := False;
   SelectCurBtn.enabled := False;
   CopyBtn.Enabled := False;
 end;
//20180503 Igor <<<
end;

procedure TClientBookFP_2012.Table1CalcFields(DataSet: TDataSet);
begin
 Table1PrpStatusDescr.Value := PrpStatusDescr[MyStrToInt(Table1['Prp_Status'])];
//Table1EfStatusDescr.Value := EFStatusDescr[MyStrToInt(Table1['EF_Status'])];

(*
If Table1['Last_Name'] <> Null then
 Table1ClientName.Value := AllTrim(Table1['Last_Name'])
else
 Table1ClientName.Value := '';
If Table1['First_Name'] <> Null then
 Table1ClientName.Value := Table1ClientName.Value
     +', '+AllTrim(Table1['First_Name']);
*)
Table1CalcMarStatus.Value := MarDescr[StrToInt(Table1['MarStatus'])];
end;

procedure TClientBookFP_2012.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then OpenBtnClick(Application);
end;




procedure TClientBookFP_2012.OpenBtnClick(Sender: TObject);
var
  //result : integer;
  FlName: string;
  sin: string;
  //s: String; //20170515 Igor
  RetNo: Integer;
begin
  FlName := Table1.FieldByName('File_Name').AsString;
  Sin := Table1.FieldByName('SIN').AsString;
  If IsOkToOpenReturn(DataDirBox.Text,FlName,Sin) = False then
  begin
    Close;
    Exit;
  end;
  Screen.Cursor := crHourGlass;
  //20170515 Igor >>>
  try
    //20170515 Igor <<<
    RetNo := OpenReturn(DataDirBox.Text,FlName,False);
    If RetNo > 0 then
    begin
      //20170515 Igor >>>
      vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
      try
      //20170515 Igor <<<
        LockWindowUpdate(Application.MainForm.Handle);
        CountDiagnostics(RetNo);
        //MainForm.LeftPanel.Visible:=True;
        MainForm.GuiCommand(gcShowLeftPanel);
        MainForm.ReduceTutorialHeight(Application);
        OpenForm(RetNo,'PROFILE',0);
        CalcAll(RetNo);
        OpenOtherImportantForms(RetNo);
        MainForm.FormPaint(Application);
        Table1.Close;
        ModalResult := mrOk; //20160612 Igor
        CloseModal;
        //LockWindowUpdate(0);

        //MainForm.RecalcBtnClick(Application);  //20060328
        //MyChild.UpdateChildTaxPanel(GetCurrentRetNo);
//20170515 Igor >>>
      finally
        vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
      end;
    end;
  finally
    Screen.Cursor:=crHourGlass;
  end;
//20170515 Igor <<<
end;

procedure TClientBookFP_2012.DeleteBtnClick(Sender: TObject);
Var FlName:String;
begin
  //If LeftStr(LicenseLevel,8)  = 'FP Multi' then
  If LicenseLevel in anyMulti then
  begin
    //  If YouKnowTheAdminPassword = false then exit;
  end;

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
end;

Function TClientBookFP_2012.ShowReturns: Boolean;
begin
//20170310 Igor >>>
  If Not FileExists(DataDirBox.Text + '\' + ClientsTable_dbf) then
  begin
    If Not FileExists(DataDirBox.Text + '\' + ClientsDBLite) then
    begin
      ShowMessage('There is no Clients data base in this directory' + Chr(13) +
                  'Use Configure -> General Options -> Data Directories');
      result :=false;
      exit;
    end
    else
    begin
      Try
        SetTableName(FDConnection, Table1,
          DataDirBox.Text + '\' + ClientsDBLite, ClientsTableLite, 'LAST_Name',
          SameText(DataDirBox.Text, OptRec.Dir_Deflt));
      except on EdataBaseError do
        begin
          ShowMessage('Data Base cannot be opened ');
          result := False;
          exit;
        end;
      end;
    end;
  end
  else
  begin
    Try
      SetODBCConnect(FDConnection, DataDirBox.Text + '\' + ClientsTable_dbf);
      Table1.TableName := ChangeFileExt(ClientsTable_dbf, '');
      //Table1.IndexName := 'LAST_Name'; //20170412 Igor
      Table1.Open;
    except on EdataBaseError do
      begin
        ShowMessage('Data Base cannot be opened ');
        result := False;
        exit;
      end;
    end; {except}
    //20170412 Igor >>>
    try
      if Table1.Indexes.FindIndex('LAST_Name') <> nil then
        Table1.IndexName := 'LAST_Name'
      else
      if Table1.FindField('LAST_Name') <> nil then
        Table1.IndexFieldNames := 'LAST_Name';
    except
    end;
    //20170412 Igor <<<
  end;
  //20170310 Igor <<<
  Screen.Cursor := crDefault;
  If Table1.RecordCount = 0 then
  begin
    ShowMessage('DataBase is empty. Press Close');
    exit;
  end;
  DBGrid1.Update;
end;

procedure TClientBookFP_2012.HelpBtnClick(Sender: TObject);
begin
 ShowHelp('FpHelp','Open_Return_by_Name');  //2008/10/10
end;

procedure TClientBookFP_2012.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TClientBookFP_2012.SearchBoxChange(Sender: TObject);
begin
//20170522 Igor >>>
  Table1.Locate('LAST_NAME', SearchBox.Text, [loCaseInsensitive, loPartialKey]);

// with Table1 do
//  begin
//  SetKey;
//  FieldByName('Last_Name').AsString := UpperCase(SearchBox.Text);
//  GotoNearest;
//  end;
//20170522 Igor <<<
end;

procedure TClientBookFP_2012.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Table1.Close;
end;

procedure TClientBookFP_2012.DataDirBoxExit(Sender: TObject);
begin
//  If DataDirBox.Text = OptRec.Dir_Cur then
//    exit;
  If (ChangeDataDir(DataDirBox.Text) = False) then
  begin
    DataDirBox.Text := OptRec.Dir_Cur;
    DataDirBox.Refresh;
    exit;
  end
  else
  begin
    //20170310 Igor >>>
    ShowReturns;
//    OptRec.Dir_Cur := DataDirBox.Text;
//    Try
//      //20150920 Igor
//      SetTableName(FDConnection, Table1, DataDirBox.Text + '\' + ClientsDBLite, ClientsTableLite, 'LAST_Name');
//      DbGrid1.Refresh;
//    except on EdataBaseError do
//      begin
//        ShowMessage('Open data Base failed');
//      end;
//    end; {except}
    //20170310 Igor <<<
  end;
end;

procedure TClientBookFP_2012.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then DataDirBoxExit(Application);
end;

procedure TClientBookFP_2012.DBGrid1DblClick(Sender: TObject);
begin
OpenBtnClick(Sender);
end;

procedure TClientBookFP_2012.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then OpenBtnClick(Sender);
end;

procedure TClientBookFP_2012.SelectCurBtnClick(Sender: TObject);
Var DirSelected: String; //20150817 igor
begin
 //If LeftStr(LicenseLevel,8) = 'FP Multi' then
 If LicenseLevel in anyMulti then
 begin
   {
   If YouKnowTheAdminPassword = false then
    Begin
     ShowMessage('Only the ADMINistrator can select other directories');
     exit;
    end;
   }
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


procedure TClientBookFP_2012.FindOtherBtnClick(Sender: TObject);
Var i:Integer;
begin
for i:=0 to Table1.Fields.count-1 do
 ShowMessage(Table1.Fields[i].FieldName);
end;



procedure TClientBookFP_2012.EmailBtnClick(Sender: TObject);
Var i:Integer;Dir,FlName:String; AListItem:TListItem;
SomeSubject,SomeRecipientEMail,SomeSenderEMail,SomeAttachment:String;
SomeText:String;
begin
 FlName:=Table1.FieldByName('File_Name').AsString;
 Dir:=DataDirBox.Text;

 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Double an item';
 SomeList.Add('1. Email the client FP file (raw data file) to your own EMail...');
 SomeList.Add('2. Email the client FP file (raw data file) to FP Reviewer...');
 SomeList.Add('3. Email the client FP file (raw data file) to VisualTax support...');
 SomeList.Add('4. Email the client FP file (raw data file) to any Email address...');
 SomeList.Add('________________________________________________________________');
 SomeList.Add('5. EMail the FP Printout to any Email address...');
 SomeList.Add('   See also: Print|Email current form...(after opening the file)');

 Application.CreateForm(TPoplistFP_2012,PopList);
 PopList.ShowModal;
 //SomeList.Free; //20160704 Igor
 PopList.Release;
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

  If SelectedString='3' then SomeRecipientEmail:='VisualTax@Sympatico.ca';
  If SelectedString='4' then SomeRecipientEmail:='';
 end;
  SomeSenderEmail:='';  //default?  'VisualTax@Sympatico.ca';
  SomeSubject:='A Financial Plan';
  SomeAttachment:=Dir+'\'+FlName;
  SomeText:=Chr(13)
                +'The Financil Plan is attached'
                +Chr(13)+' '
                +Chr(13)+' '
                +Chr(13)+'Thank you '
                +Chr(13)+' '
                +Chr(13)+OptRec.Prp_Name
                +Chr(13)+' ('+OptRec.Prp_Area+') '+OptRec.Prp_Tel;
   MainFormFP.SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEMail);
end;

procedure TClientBookFP_2012.CopyBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;
begin
  //If LeftStr(LicenseLevel,8)  = 'FP Multi' then
  If LicenseLevel in anyMulti then
  begin
//   If YouKnowTheAdminPassword = false then exit;
  end;

  SomeFile:= Table1.FieldByName('File_Name').AsString;
  SomeString:= DataDirBox.Text;//from dir
  SomeCaption:= Table1.FieldByName('First_Name').AsString + ' '+
      Table1.FieldByName('Last_Name').AsString; //return name
  Application.CreateForm(TCopyMoveFrmFP_2027,CopyMoveFrm);//20160327 Igor
  CopyMoveFrm.ShowModal;
  CopyMoveFrm.Free;
  If SomeResult=True then
    ShowMessage('Done')
  Else
   ShowMessage('Failed!');
  ShowReturns;
  self.BringToFront; //20160226 Igor
end;

end.
