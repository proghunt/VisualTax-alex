unit T3_2026ClientBook;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,DB,Grids,DBGrids,StdCtrls,Buttons,ExtCtrls,DBCtrls,FileCtrl,
  MAPI,Mask,ComCtrls,VCLTee.TeeProcs,VCLTee.TeEngine, VCLTee.Chart, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient; //20150805 Igor

type
  TClientBookT3_2026 = class(TForm)
    DataSource1: TDataSource;
    MonitorPlanBtn: TChart;
    Label14: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    DataDirBox: TEdit;
    SearchBox: TEdit;
    OpenBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    HelpBtn: TBitBtn;
    PrintBtn: TBitBtn;
    Panel6: TPanel;
    Image3: TImage;
    Image1: TImage;
    Image2: TImage;
    BookBack: TShape;
    LPanel: TPanel;
    DBGrid1: TDBGrid;
    RPanel: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label13: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    DBEdit12: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit33: TDBEdit;
    GroupBox2: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    GroupBox4: TGroupBox;
    DBEdit16: TDBEdit;
    GroupBox7: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit30: TDBEdit;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    GroupBox5: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Bevel1: TBevel;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit26: TDBEdit;
    DBEdit27: TDBEdit;
    DBEdit31: TDBEdit;
    GroupBox3: TGroupBox;
    Label38: TLabel;
    Label39: TLabel;
    DBEdit13: TDBEdit;
    DBEdit8: TDBEdit;
    Label4: TLabel;
    Label15: TLabel;
    DBEdit1: TDBEdit;
    SelectCurBtn: TBitBtn;
    EmailBtn: TBitBtn;
    CopyMoveBtn: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;
    Table1PrpStatusDescr: TStringField;
    Table1CORP_NAME: TStringField;
    Table1YEAR_END: TStringField;
    Table1FILE_NAME: TStringField;
    Table1CONTACT: TStringField;
    Table1AREA: TStringField;
    Table1PHONE: TStringField;
    Table1FAX: TStringField;
    Table1PRP_STATUS: TStringField;
    Table1CREATED_BY: TStringField;
    Table1CREATED_DT: TStringField;
    Table1CREATED_TM: TStringField;
    Table1UPDATED_BY: TStringField;
    Table1UPDATED_DT: TStringField;
    Table1UPDATED_TM: TStringField;
    Table1PRINTED_BY: TStringField;
    Table1PRINTED_DT: TStringField;
    Table1PRINTED_TM: TStringField;
    Table1ACCOUNT: TStringField;
    Table1STREET: TStringField;
    Table1CITY: TStringField;
    Table1PROVINCE: TStringField;
    Table1POSTAL: TStringField;
    Table1COUNTRY: TStringField;
    Table1COMPL_BY: TStringField;
    Table1COMPL_DT: TStringField;
    Table1COMPL_TM: TStringField;
    Table1DUE_DT: TStringField;
    Table1NOTES: TStringField;
    Table1PAY_AMOUNT: TFloatField;
    Table1PAY_INVNO: TStringField;
    Table1PAY_TYPE: TStringField;
    Table1INV_AMOUNT: TFloatField;
    Table1PAY_DT: TStringField;
    Table1DUE_DATE: TStringField;
    Table1CORPTYPE: TStringField;
    Table1EF_STATUS: TStringField;
    Table1EfStatusDescr: TStringField;
    GroupBox6: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel2: TBevel;
    Label9: TLabel;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit32: TDBEdit;
    Table1RTUSENT_BY: TStringField;
    Table1RTUSENT_DT: TStringField;
    Table1RTUSENT_TM: TStringField;
    Table1ACKRCVD_BY: TStringField;
    Table1ACKRCVD_DT: TStringField;
    Table1ACKRCVD_TM: TStringField;
    Procedure ShowReturns;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    {procedure SearchBtnClick(Sender: TObject);}
    procedure OpenBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
  //  procedure AlphabetMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure SaveBtnClick(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
   { procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);}
    Procedure RefreshStatus;
    {procedure DBGrid1ColEnter(Sender: TObject);}
   { procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);}
  {  procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);}
    procedure DeleteBtnClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure SortGroupClick(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure HelpBtnClick(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure PrintBtnClick(Sender: TObject);
    procedure SelectCurBtnClick(Sender: TObject);
    procedure EmailBtnClick(Sender: TObject);
    procedure CopyMoveBtnClick(Sender: TObject);
    procedure Table1CalcFields(DataSet: TDataSet);
  private
   {
    FReport : TQuickRep;
    procedure SetReport(Value : TQuickRep);
   }
  public
   { property Report : TQuickRep read FReport write SetReport;}
  end;

var
  ClientBook: TClientBookT3_2026;
  InitialDir : string; //[66];

implementation

{$R *.DFM}

uses
  vtMulti,vtCommon,vtDialogs,vtMain,
  T3_2026,T3_2026Declare,T3_2026common,
  T3_2026Common2,T3_2026ChildWinNew,T3_2026TrimStr,T3_2026CntErr,
  T3_2026Features,
//T3_2026PopList,
  T3_2026CopyMoveFrm,T3_2026Main,
  vtTrimStr, vtShared, vtDataBase,
  vtChild; //20170515 Igor

procedure TClientBookT3_2026.FormCreate(Sender: TObject);
begin
  //SortGroup.ItemIndex :=0;
  ShowReturns;
  ActiveControl := SearchBox; //20160719 Igor
  //20180503 Igor >>>
  if CheckIsCloud(true) then
  begin
    DataDirBox.enabled := False;
    SelectCurBtn.enabled := False;
    CopyMoveBtn.Enabled := false;
  end;
  //20180503 Igor <<<
end;

procedure TClientBookT3_2026.ShowReturns;
begin
 Try
  //20150923 Igor
  UpdateDbStructure; //20220324 Igor
  SetTableName(FDConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDBLite, ClientsTableLite, '');
 {
 If SortGroup.ItemIndex =0 then
   Table1.IndexName := 'CORP_NAME'
 else If SortGroup.ItemIndex =1 then
   Table1.IndexName := 'Due_Date'
 else If SortGroup.ItemIndex =2 then
   Table1.IndexName := 'Prp_Status';
 }
 Table1.Open;
except
 on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
end;

(*
StringGrid1.ColWidths[0] := StringGrid1.DefaultColWidth + 18;
StringGrid1.ColWidths[2] := StringGrid1.DefaultColWidth - 9;
StringGrid1.ColWidths[3] := StringGrid1.DefaultColWidth + 18;

Alphabet.Alignment := taLeftJustify;
Alphabet.Font.Name := 'Arial';
Alphabet.Font.Size := 10;
Alphabet.Font.Style := [fsBold];
*)
{DBNavigator.Width := DBGrid1.Width;}
DataDirBox.Text := OptRec.Dir_Cur;
Screen.Cursor := crDefault;
(*
With StringGrid1 do
begin
Cells[0,1] := 'Created';
Cells[1,0] := 'By';
Cells[2,0] := 'M/D/Y';
Cells[3,0] := 'Time';

Cells[0,2] := 'Last Update';
Cells[0,3] := 'Printed';
Cells[0,4] := 'Completed';
end;
*)
If Table1.RecordCount = 0 then
 begin
 ShowMessage('DataBase is empty. Press Cancel');
 exit;
 end;
DBGrid1.Update;
RefreshStatus;
end;

procedure TClientBookT3_2026.CancelBtnClick(Sender: TObject);
begin
Table1.Free;
Close; {Release;}
end;

procedure TClientBookT3_2026.OpenBtnClick(Sender: TObject);
var
 FlName: string;
 Acc: string;
 //RetLimit:Integer;
 RetNo: Integer;
begin
  FlName := Table1.FieldByName('File_Name').AsString;
  If FlName = '' then
    exit;

  Screen.Cursor:= crHourGlass;
  try
    RetNo := OpenReturn(DataDirBox.Text,FlName,True);
    If RetNo < 1 then
      exit;
    Busy; //LockWindowUpdate(MainForm.Handle);
    //20170515 Iogr >>>
    try
      vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
      try
    //20170515 Igor <<<

        CountDiagnostics(RetNo);
        MainForm.ReduceTutorialHeight(Application);
        OpenForm(RetNo,'T3',0);
        //LockWindowUpdate(MainForm.Handle);  //20130217
        If Ret[RetNo].FormHasData['T5013FIN'] then
          OpenForm(RetNo,'T5013FIN',0);
        //20110812
        //LockWindowUpdate(MainForm.Handle);  //20130217
        //LockWindowUpdate(MainForm.Handle);  //20130217
        OpenUsedForms(RetNo);
        //LockWindowUpdate(0);
        Table1.Close;
        ModalResult := mrOk; //20160612 Igor
        CloseModal;
        Ret[RetNo].MyChild.UpdateChildTaxPanel;
        MainForm.FormPaint(Application);
        MainForm.GuiCommand(gcReturns);
      //20170515 Igor >>>
      finally
        vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
      end;
      //20170515 Igor <<<
    finally
      Done;  //LockWindowUpdate(MainForm.Handle);  //20130217 ???
    end;
    MainForm.GuiCommand(gcShowLeftPanel);  // MainForm.LeftPanel.Visible:=True;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TClientBookT3_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
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
   UpdateDbStructure; //20220324 Igor
   //20150923 Igor
   SetTableName(FDConnection, Table1, DataDirBox.Text + '\' + ClientsDBLite, ClientsTableLite, 'Corp_Name');
   DbGrid1.Refresh;
   except
   on EdataBaseError do MessageBeep(0); end;
 end;
end;

 (*
 If DataDir.Text = AppDir then
  begin
   ShowMessage('You cannot use the Program Directory as Data Directory');
   DataDir.Text := CfgRec.Dir_Cur;
   exit;
  end;

 if DataDir.Text <> CfgRec.Dir_Cur then
  If FileExists(DataDir.Text+'\'+ClientsTable) then
  begin
   Try
   Table1.Close;
   Table1.DataBaseName := DataDir.Text;
   Table1.TableName := ClientsTable;
   Table1.IndexName := 'Last_Name';
   Table1.Open;

   DbGrid1.Refresh;
   CfgRec.Dir_Cur := DataDir.Text;
   except
   on EdataBaseError do MessageBeep(0); end;
 end
 else
   ShowMessage('Directory does not exist or not initialized');
 end;

end;
*)

procedure TClientBookT3_2026.SaveBtnClick(Sender: TObject);
var
 tempmemo : TDBMemo;
begin
 (*
 TempMemo := TDBMemo.Create(self);
 TempMemo.Parent := Self;
 TempMemo.Visible := False;
 {TempMemo.Lines.LoadFromFile('c:\delphi\t1\data\11111111');}
 TempMemo.Lines.Add('11zantiris');
 TempMemo.Lines.Add('22jhgjhjh');
 TempMemo.Lines.Add('33jhgjhjh');
 TempMemo.Lines.Add('44jhgjhjh');

 Table1.Edit;
 Table1.FieldByName('Data').Assign(TempMemo.Lines);

 Table1.Post;
 TempMemo.free;
 *)
 end;

procedure TClientBookT3_2026.SearchBoxChange(Sender: TObject);
begin
Table1.Locate('Corp_name', AllTrim(LeftStr(SearchBox.Text,8)), [loCaseInsensitive, loPartialKey]); //20220325
// Table1.Locate('File_Name', AllTrim(LeftStr(SearchBox.Text,8)), [loCaseInsensitive, loPartialKey]); //20211210
end;

procedure TClientBookT3_2026.DBGrid1DblClick(Sender: TObject);
begin
 OpenBtnClick(Sender);
end;

Procedure TClientBookT3_2026.RefreshStatus;
begin
 If Table1.RecordCount = 0 then exit;
 {
 If Numeric(Table1.FieldByName('Prp_Status').AsString) then
   PrpStatusLbl.Caption :=
     PrpStatusDescr[StrToInt(Table1.FieldByName('Prp_Status').AsString)];
     }
{ Memo1.Text := Table1.FieldByName('Notes').AsString;}
(*
 with StringGrid1 do
  begin
   {
   Cells[0,0] := LeftStr(Table1.FieldByName('First_Name').AsString,1)
      + '.'+ Table1.FieldByName('Last_Name').AsString;
   }
   Cells[1,1] := Table1.FieldByName('Created_by').AsString;
   Cells[1,2] := Table1.FieldByName('Updated_by').AsString;
   Cells[1,3] := Table1.FieldByName('Printed_by').AsString;
   Cells[1,4] := Table1.FieldByName('Compl_by').AsString;

   Cells[2,1] := Table1.FieldByName('Created_dt').AsString;
   Cells[2,2] := Table1.FieldByName('Updated_dt').AsString;
   Cells[2,3] := Table1.FieldByName('Printed_dt').AsString;
   Cells[2,4] := Table1.FieldByName('Compl_dt').AsString;

   Cells[3,1] := Table1.FieldByName('Created_tm').AsString;
   Cells[3,2] := Table1.FieldByName('Updated_tm').AsString;
   Cells[3,3] := Table1.FieldByName('Printed_tm').AsString;
   Cells[3,4] := Table1.FieldByName('Compl_tm').AsString;
  end;
 *)
end;

procedure TClientBookT3_2026.DeleteBtnClick(Sender: TObject);
Var FlName:string;
begin
FlName := Table1.FieldByName('File_Name').AsString;
If FlName = '' then exit;
{If Length(FlName) =10 then Acc := LeftStr(FlName,8)+MidStr(FlName,10,1);}
if MessageDlg(Table1.FieldByName('Corp_Name').AsString
   +Chr(13)+ 'Delete?',
   mtInformation, [mbYes, mbNo], 0) = mrYes then
   begin
    Table1.Delete;
    If FileExists(OptRec.Dir_cur+'\'+FlName)
     then SysUtils.DeleteFile(OptRec.Dir_cur+'\'+FlName);
   end;
end;

procedure TClientBookT3_2026.DataSource1DataChange(Sender: TObject; Field: TField);
begin
If (Sender as TDataSource).State = dsBrowse then
 RefreshStatus;
end;
procedure TClientBookT3_2026.SortGroupClick(Sender: TObject);
begin
ShowReturns;
end;

procedure TClientBookT3_2026.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If key = #13 then OpenBtnClick(Application);
end;

procedure TClientBookT3_2026.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
If Key =#13 then OpenBtnClick(Application);
end;

procedure TClientBookT3_2026.HelpBtnClick(Sender: TObject);
begin
ShowHelp('TfHelp','Open_Return_by_Name');
end;

procedure TClientBookT3_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then DataDirBoxExit(Application);
end;

procedure TClientBookT3_2026.PrintBtnClick(Sender: TObject);
begin
 {
 Application.CreateForm(TReportMenu,ReportMenu);
 ReportMenu.ShowModal;
 ReportMenu.Free;
 }
end;

(*
procedure TOpReturn.SetReport(Value : TQuickRep);
begin
 { FReport:=Value;}
end;
*)

procedure TClientBookT3_2026.SelectCurBtnClick(Sender: TObject);
Var DirSelected:String;   //20150805 Igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
 begin
  DataDirBox.Text := DirSelected;
  DataDirBoxExit(Sender);
  SearchBox.SetFocus;
 end;
end;

procedure TClientBookT3_2026.EmailBtnClick(Sender: TObject);
Var i:Integer;Dir,FlName:String; //AListItem:TListItem;
  SomeSubject,SomeRecipientEMail,SomeSenderEMail,SomeAttachment:String;
  SomeText:String;
begin
 FlName := Table1.FieldByName('File_Name').AsString;
 Dir:=DataDirBox.Text;


 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Double click on item 1, 2, 3 or 4';
 SomeList.Add('1. Email the tax return (raw data file) to your own EMail...');
 SomeList.Add('2. Email the tax return (raw data file) to tax return Reviewer...');
 SomeList.Add('3. Email the tax return (raw data file) to VisualTax support...');
 SomeList.Add('4. Email the tax return (raw data file) to any Email address...');
  SelectedString := PopSomeList(SomeList,SomeCaption);
 //SomeList.Free; //20160704 Igor
 If SelectedString > '' then SelectedString:=LeftStr(SelectedString,1);
 If (SelectedString='1') or (SelectedString='2')
 or (SelectedString='3') or (SelectedString='4')
 {or (SelectedString='5')}
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

  SomeSenderEmail:='';  //default?  
  SomeSubject:='A T2 tax return';
  SomeAttachment:=Dir+'\'+FlName;
  SomeText:=Chr(13)
                +'The tax return is attached'
                +Chr(13)+' '
                +Chr(13)+' '
                +Chr(13)+'Thank you '
                +Chr(13)+' '
                +Chr(13)+OptRec.Prp_Name
                +Chr(13)+' ('+OptRec.Prp_Area+') '+OptRec.Prp_Tel;
   MainFormT3.SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEMail);
 end;
end;

procedure TClientBookT3_2026.CopyMoveBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 //RetNo:Integer;
begin


  SomeFile:=Table1.FieldByName('File_Name').AsString;
  SomeString:=DataDirBox.Text;
  SomeCaption:=Table1.FieldByName('Corp_Name').AsString;
  Application.CreateForm(TCopyMoveFrmT3_2026,CopyMoveFrm);
  CopyMoveFrm.ShowModal;
  CopyMoveFrm.Free;
  If SomeResult=True then
    ShowMessage('Done')
  Else
   ShowMessage('Failed!');
 // ShowMostRecentReturns; //updates the main menu
  self.BringToFront; //20160226 Igor
end;

procedure TClientBookT3_2026.Table1CalcFields(DataSet: TDataSet);
begin
  // 20151105 Igor  try ... except
  //20220324 Igor >>>
  try
    Table1PrpStatusDescr.Value :=PrpStatusDescr[MyStrToInt(Table1.FieldByName('PRP_Status').AsString)];
    Table1EfStatusDescr.Value := EFStatusDescr[MyStrToInt(Table1.FieldByName('EF_Status').AsString)];
  except
  end;
  //20220324 Igor <<<

//PrpStatusDescr[MyStrToInt(Table1['PRP_Status'])];
end;

end.
