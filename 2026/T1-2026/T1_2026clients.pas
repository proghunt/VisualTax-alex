unit T1_2026clients;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  Forms,DBCtrls,DB,Mask,ExtCtrls,Grids,Dialogs,DBGrids,Buttons,Menus,
  Printers, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TclientsT1_2026 = class(TForm)
    DataSource1: TDataSource;
    SelectAllBtn: TBitBtn;
    RadioGroup1: TRadioGroup;
    DBGrid1: TDBGrid;
    RemoveBtn: TBitBtn;
    ListBox1: TListBox;
    BitBtn1: TBitBtn;
    DataDirBox: TEdit;
    AutoLbl: TLabel;
    SelectedLbl: TLabel;
    Label1: TLabel;
    BitBtn2: TBitBtn;
    OpenDialog1: TOpenDialog;
    RtuPanel: TPanel;
    RtuLabelsLbl: TLabel;
    PrintCurrentRtuBtn: TBitBtn;
    PrintOtherRtu: TBitBtn;
    PrintBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PrintRtuListBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    EfileBtn: TBitBtn;
    Label2: TLabel;
    ProdRtuBtn: TBitBtn;
    ProductionSENDBtn: TBitBtn;
    TestT1Btn: TBitBtn;
    TestSendBtn: TBitBtn;
    DevelpmentT1Btn: TBitBtn;
    DevelopmentSendBtn: TBitBtn;
    ShowLinesOtherBtn: TBitBtn;
    ShowCurrentLinesBtn: TBitBtn;
    Label3: TLabel;
    RtuLbl: TLabel;
    Panel1: TPanel;
    FormLbl: TLabel;
    BarPrintBtn: TBitBtn;
    FDConnection: TADConnection;
    Query1: TADQuery;
    Procedure ShowRTULines(FlName:string);
    Procedure Encrypt(FlName: string; RTUOrSend:string;ProdOrTest:String);
    procedure CancelClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure FilterBoxChange(Sender: TObject);
    Function ExistsInList(AString: String):Boolean;
    procedure ListBox1DblClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    Procedure RefreshScreen(FilterDescr: string);
    Function  OpenQuery(DBName: string;QryName: string): boolean;
    Function  MkSelectedStr: String;
    procedure RadioGroup1Click(Sender: TObject);
    procedure SelectAllBtnClick(Sender: TObject);
    procedure PrintCurrentRtuBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    Function  DoOperation(Operation: string): boolean;
    procedure RemoveBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure PrintOtherRtuClick(Sender: TObject);
    procedure PrintRtuListBtnClick(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure EfileBtnClick(Sender: TObject);
    procedure ProdRtuBtnClick(Sender: TObject);
    procedure TestT1BtnClick(Sender: TObject);
    procedure DevelpmentT1BtnClick(Sender: TObject);
    procedure ProductionSENDBtnClick(Sender: TObject);
    procedure TestSendBtnClick(Sender: TObject);
    procedure DevelopmentSendBtnClick(Sender: TObject);
    Function  RecsSelected:Boolean;
    procedure ShowLinesOtherBtnClick(Sender: TObject);
    procedure ShowCurrentLinesBtnClick(Sender: TObject);
    procedure BarPrintBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    RetNo:Integer;
  public

  end;

var
  clients: TclientsT1_2026;

procedure ClientsBatch(Oper,Filter: string);

implementation

{$R *.DFM}

uses ShellApi,vtMulti,vtCommon,vtDialogs,T1_2026,T1_2026Declare,T1_2026TrimStr,
  T1_2026RTU,T1_2026Common,T1_2026Common2,T1_2026BarDataGen,T1_2026Calc,
  T1_2026Print,T1_2026T1Rtns,T1_2026T1Rtns2,T1_2026SQlFilt,T1_2026Main,
  T1_2026PrintReturnFrm,vtTrimStr,vtShared,
  vtDataBase;//20150909 Igor

var
  //clients: TclientsT1_2026;
  PrintTemplate : string; //[20];
  DestinationDir : string; //[50];
  FilterDescr   :string; //[40];

procedure ClientsBatch(Oper,Filter: string);
begin
  Screen.Cursor := crHourglass;
  clients := TclientsT1_2026.Create(Application);
  with clients do
  begin
    BatchOper := Oper;
    BatchFilter := Filter;
    ShowModal;
    Free;
  end;
  clients := nil;
  Screen.Cursor := crDefault;
end;

procedure TclientsT1_2026.CancelClick(Sender: TObject);
begin
 Close;
end;


Procedure TclientsT1_2026.RefreshScreen(FilterDescr: string);
begin
 AutoLbl.Caption :=
 '('+FilterDescr+')'+'  No. of returns: '+IntToStr(Query1.RecordCount);
 AutoLbl.Refresh;
 SelectedLbl.Caption := 'Selected: '+IntToStr(ListBox1.Items.Count);
 ListBox1.Refresh;
end;

Function TclientsT1_2026.OpenQuery(DBName: string;QryName: string): boolean;
begin
 try
   SqlLoadDBFromFile(FDConnection, Query1, DBName + '\' + ClientsDBLite, AppDir+'\'+QryName);//20150909 Igor
   Query1.Open;
   Query1.FetchAll; //20170130 Igor
   Result := True;
 except
 on EdataBaseError do Result := False; end;

end;


procedure TclientsT1_2026.FormShow(Sender: TObject);
//procedure TclientsT1_2026.FormCreate(Sender: TObject);
const
 separator = '====================';
var i : integer;

begin
 Caption := BatchFilter;
 Panel1.Caption := BatchFilter;
 RtuLbl.Caption := RTUNumber;
 If BatchFilter = 'EF Ready For EFILE' then
   begin
   PrintBtn.Visible :=False;
   RadioGroup1.Items.Add(BatchFilter);
   RadioGroup1.Items.Add('All');
   end
 else If BatchFilter = 'EF Ready For SEND' then
   begin
   PrintBtn.Visible :=False;
   RadioGroup1.Items.Add(BatchFilter);
   RadioGroup1.Items.Add('All');
   end
 else If BatchFilter = 'Ready To Print' then
   begin
   RtuPanel.Visible := False;
   RadioGroup1.Items.Add('Ready To Print');
   RadioGroup1.Items.Add('All');
   end;
 {initialize other controls}
 DataDirBox.Text := OptRec.Dir_Cur;
 RadioGroup1.ItemIndex := RadioGroup1.Items.IndexOf(BatchFilter);
 FilterDescr := RadioGroup1.Items[RadioGroup1.ItemIndex];
 {AutoLbl.Caption := FilterDescr+' Count: '+IntToStr(Query1.RecordCount);}
 OptRec.Dir_Cur := DataDirBox.Text;
 {add horiz. scroll bar to listbox}
 SendMessage(ListBox1.Handle,LB_SetHorizontalExtent,300,LongInt(0));

 OpenQuery(DataDirBox.Text,GetQueryName(FilterDescr)+'.QRY');
 RefreshScreen(FilterDescr);
 Screen.Cursor := crDefault;
end;

procedure TclientsT1_2026.CancelBtnClick(Sender: TObject);
begin
 Query1.Free;
 Close;
end;

procedure TclientsT1_2026.DBGrid1DblClick(Sender: TObject);
begin
(*
If ((BatchOper <> 'Print') and (Query1.FieldByName('EF_Status').AsString = '02'))   {acceptd}
 or ((BatchOper <> 'Print') and (Query1.FieldByName('EF_Status').AsString = '04'))   {waiting ack}
then
begin
   ShowMessage(Query1.FieldByName('Last_Name').AsString
   + ' ' +LeftStr(Query1.FieldByName('First_Name').AsString,1)+'.'
   + CHR(13)+ 'Already Efile accepted or waiting Ack!')
end
else
begin
*)
 If ExistsInList(MkSelectedStr)
 then
   ShowMessage(Query1.FieldByName('Last_Name').AsString
    + ' ' +LeftStr(Query1.FieldByName('First_Name').AsString,1)+'.'
    + CHR(13)+ 'Already selected!')
 else
  begin
   ListBox1.Items.Add(MkSelectedStr);
   RefreshScreen(FilterDescr);
  end;
// end;
end;

Function TclientsT1_2026.MkSelectedStr: String;
Const
 PartNameLen = 14;
Var
 S : string; //[80];
begin
    Result :=
     LeftStr(Query1.FieldByName('Last_Name').AsString,PartNameLen)
     + ' ' +LeftStr(Query1.FieldByName('First_Name').AsString,1)
     + '.'
     + FilledStr(
       PartNameLen+3-Length(LeftStr(Query1.FieldByName('Last_Name').AsString,PartNameLen))
       + 1 + Length(LeftStr(Query1.FieldByName('First_Name').AsString,1))+1
       ,' ')
     + '\'+Query1.FieldByName('File_Name').AsString
end;


Function TclientsT1_2026.ExistsInList(Astring:String):Boolean;
var
i : integer;
begin
   Result := False;
   For i := 0 to ListBox1.Items.Count-1 do
   if Astring = ListBox1.Items[i] then
    begin
     Result := True;
     exit
    end;
end;


procedure TclientsT1_2026.ClearBtnClick(Sender: TObject);
begin
ListBox1.Clear;
RefreshScreen(FilterDescr);
end;


procedure TclientsT1_2026.FilterBoxChange(Sender: TObject);
var
 QueryName : string; //[30];
begin
 If FilterDescr = 'All' then QueryName := 'All'
 else if RadioGroup1.Items[RadioGroup1.ItemIndex] = 'User Defined' then QueryName := 'User'
 else QueryName := GetQueryName(RadioGroup1.Items[RadioGroup1.ItemIndex]);
If QueryName >'' then
 If OpenQuery(DataDirBox.Text,QueryName+'.QRY') = False then
   begin
    ShowMessage('Cannot open data base');
    exit;
   end
 else
   RefreshScreen(FilterDescr);
end;

procedure TclientsT1_2026.ListBox1DblClick(Sender: TObject);
begin
  ListBox1.Items.Delete(ListBox1.ItemIndex);
  RefreshScreen(FilterDescr);
end;


procedure TclientsT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
If (ChangeDataDir(DataDirBox.Text) = False)
 or (OpenQuery(DataDirBox.Text,'All.QRY') = False)
 then
  begin
   DataDirBox.Text := OptRec.Dir_Cur;
   DataDirBox.Refresh;
   exit;
  end
 else
   begin
    OptRec.Dir_Cur := DataDirBox.Text;
    ClearBtnClick(Sender);
    RefreshScreen('All');
   end;

end;

(*
If DataDirBox.Text = AppDir then
  begin
   ShowMessage('You cannot use the Program Directory as Data Directory');
   DataDirBox.Text := CfgRec.Dir_Cur;
   exit;
  end;

If DataDirBox.Text = CfgRec.Dir_Cur then exit;
If FileExists(DataDirBox.Text+'\'+ClientsTable) then
 begin
   If OpenQuery(DataDirBox.Text,'AllClnts.QRY') = False then
     begin
      ShowMessage('Cannot open data base in specified directory');
      DataDirBox.Text := CfgRec.Dir_Cur;
      RefreshScreen('All Clients');
      exit;
     end
   else
     begin
      CfgRec.Dir_Cur := DataDirBox.Text;
      ClearBtnClick(Sender);
      RefreshScreen('All Clients');
     end
 end
 else
 begin
  ShowMessage(DataDirBox.Text + CHR(13)+'is not a tax data directory');
  DataDirBox.Text := CfgRec.Dir_Cur;
  RefreshScreen('All Clients');
 end;

end;
*)
procedure TclientsT1_2026.RadioGroup1Click(Sender: TObject);
var
 QueryName : string; //[30];
begin
 FilterDescr := RadioGroup1.Items[RadioGroup1.ItemIndex];
 QueryName := GetQueryName(RadioGroup1.Items[RadioGroup1.ItemIndex]);
 If QueryName >'' then
  If OpenQuery(DataDirBox.Text,QueryName+'.QRY') = False then
   begin
    ShowMessage('Cannot open data base');
    exit;
   end
 else
   RefreshScreen(FilterDescr);
end;

procedure TclientsT1_2026.SelectAllBtnClick(Sender: TObject);
begin
  ListBox1.Clear;
  Query1.First;
  while not Query1.EOF do
  begin
   DBGrid1DblClick(Sender);
   Query1.Next;
  end;
end;

procedure TclientsT1_2026.PrintCurrentRtuBtnClick(Sender: TObject);
Var FlName: String;
begin
If RTUNumber >'' then
 RtuReport(OptRec.EF_datadir+'\'+RtuNumber+'.RTU')
else
begin
ShowMessage('No RTU created in this session');
exit;
end;
end;

procedure TclientsT1_2026.PrintBtnClick(Sender: TObject);
begin
 If DoOperation('Print') then
 Begin
   CancelBtnClick(Sender);
 end;
end;

Function TclientsT1_2026.DoOperation(Operation: string): boolean;
Var
 i,j,k,FCopies,FNo :integer; FlName,FName, Template:string;
 FormsToPrint:TstringList;s:String;
 ConfigBarCodeIndicator:Boolean;
begin
 Result := False;
 If ListBox1.Items.Count = 0 then
   begin ShowMessage('No records selected');exit;end;
 If Operation = 'RTU' then
 Begin
    If (BatchOper = 'PRTU') and (LicenseLevel =llDemo) then    {demo}
    begin
     ShowMessage('The Demo version does not allow Production T1 RTUs');
     exit;
    end;

    SomeList.Clear; // := TStringList.Create;
    SomeList.Add(DataDirBox.Text); {Data dir as first entry}
    For i :=0 to ListBox1.Items.Count-1 do
       SomeList.Add(ExtractFileName(ListBox1.Items[i]));  {works, string has \ }
    RtuRoutine;  {in URTU}
    RtuLbl.Caption := RTUNumber;  RtuLbl.Refresh;
    //SomeList.Free; //20160301 Igor
    exit;
 end;

 If Operation = 'Print' then
 begin
   Template := GetBatchPrintTemplate;

   If Template ='' then exit;
   If PrintDialog1.Execute =false then  exit;
   For i :=0 to ListBox1.Items.Count-1 do
   begin
       If AbortSw then begin AbortSw:=False;exit;end;
       FlName := ExtractFileName(ListBox1.Items[i]);  {works, string has \ }
       ListBox1.ItemIndex :=i;
       ListBox1.Refresh;

      RetNo := ReadReturn(DataDirBox.Text,FlName);
      if RetNo > 0 then
      begin
        CalcAll(RetNo);
        UpdateAllDataIndicators(RetNo);

        FormsToPrint := TstringList.Create;
        GetFormsToPrint(RetNo,Template,FormsToPrint);
        If UpperCase(Template)<>'CRASET.D' then //20111227
        Begin
         FastPrint:=False; //otherwise it abends
         for j :=0 to (FormsToPrint.Count - 1) do
         begin
          Application.ProcessMessages;  {allows abort click on progrees screen }
          FName := Midstr(FormsToPrint[j],5,10);
          FCopies := MyStrToInt(Midstr(FormsToPrint[j],4,1));
          Calc(RetNo,FName);
          FormLbl.Visible := True;
          FormLbl.Caption:=FName;
          For k:=1 to FCopies do
            PrintForm(RetNo,FName,99,'');  //20110208  1 to 99
         end; //j
         FormsToPrint.Free;
         //20120315
         Ret[RetNo].Frm[GetFormNo( 'STATUS')].Strings[4] := '03';
         Ret[RetNo].PrpStatus :='03';

         //20170311 CON
         SaveReturn(RetNo,DataDirBox.Text,FlName,True,True);
         UpdateClientsTable(RetNo,DataDirBox.Text,FlName);
         //MainFormT1.UpdatePrintDate(RetNo,DataDirBox.Text,FlName);  //20170311
        end
        Else
        begin  //cra copy
         PrintReturnFrm.PrintFilingCopyInBatch(DataDirBox.Text,FlName,RetNo,FormsToPrint);
        end;
      end  //read return
      Else
      begin
         ShowMessage('Problem with Return: '+DataDirBox.Text+'\'+FlName);
         FormsToPrint.Free;
         RemoveReturnFromMemory(RetNo);
         exit;
      end;
    If (RetNo>0) and (UpperCase(Template)<>'CRASET.D') then    //20120307
       RemoveReturnFromMemory(RetNo);  //20120307
   end; {i List of returns}
   ShowMessage('Batch Printing completed');

 end; {print}
end;

Function TclientsT1_2026.RecsSelected:Boolean;
begin
  If ListBox1.Items.Count = 0 then
  begin
    ShowMessage('No records selected');
    result :=false;
  end;
 Result := true;
end;

procedure TclientsT1_2026.RemoveBtnClick(Sender: TObject);
begin
ListBox1DblClick(Sender);
end;

procedure TclientsT1_2026.AddBtnClick(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;

procedure TclientsT1_2026.BitBtn1Click(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;

Procedure TclientsT1_2026.Encrypt(FlName: string; RTUOrSend:string;ProdOrTest:String);
Var FromFl,ToFl:String;
  PgmParms,PgmPath,EFileDir: string;
  EncrPgm : string; //[20];
  EncrPgmZ: Array[0..21] of Char;
  PgmParmsZ : Array[0..254] of Char;
  PgmPathZ : Array[0..254] of Char;
  h :Thandle;
  NewExt   : string;
Begin
 PgmPath := AllTrim(OptRec.EF_EncDir);
 EFileDir   := AllTrim(OptRec.EF_DataDir);
 If RTUOrSend = 'RTU' then NewExt := 'ENC' else NewExt := 'SEN';
 FromFl   := EFileDir+'\'+FLName;
 ToFl     := EFileDir+'\'+LeftStr(FlName,Length(FlName)-4)+'.'+NewExt;
 If ProdOrTest = 'PROD' then
  EncrPgm := 'ENC.EXE'
 else
   If ProdOrTest = 'TEST' then  EncrPgm := 'ENC93B.EXE';
 PgmParms :='/n '+FromFl+' '+ToFl;

 If Not FileExists(PgmPath+'\'+EncrPgm) then
 begin
  ShowMessage('Encryption program '+PgmPath+'\'+EncrPgm + ' was not found');
  exit;
 end;

 StrPCopy(EncrPgmZ,EncrPgm);
 StrPCopy(PgmParmsZ,PgmParms);
 StrPCopy(PgmPathZ,PgmPath);

 h := ShellExecute(Application.MainForm.Handle, Nil, EncrPgmZ, PgmParmsZ,
  PgmPathZ, SW_RESTORE);

 If H > 32 then
    ShowMessage('RTU '+RtuNumber +' and its Encryption succesfully completed')
 else
    ShowMessage('Encryption failed. '+'Error Code '+intToStr(h));
 {h:= ShellExecute(Wnd: HWnd; Operation, FileName, Parameters,
  Directory: PChar; ShowCmd: Integer): THandle;}

 (*
 {using delphi ExecuteFile }
 ExecuteFile(EncrPgm,PgmParms,PgmPath,SW_SHOW);
 If FileExists(ToFl) then
   ShowMessage('Encryption succesfully completed')
   else
    ShowMessage('Encryption failed');
 *)

 (*
 {using the EXECFILE component}
 If Not FileExists(PgmPath+'\'+EncrPgm) then
 begin
  ShowMessage('Encryption program '+PgmPath+'\'+EncrPgm + ' was not found');
  exit;
 end;

 ExecFile1.FileName := PgmPath+'\'+EncrPgm;
 ExecFile1.FilePath := EfileDir; {working directory}
 ExecFile1.Parameters := PgmParms;
 ExecFile1.Wait := True;
 ExecFile1.WindowStyle := wsMinimize;  {Normal;}
 If not ExecFile1.IsWaiting then
  begin
   If ExecFile1.Execute then
    ShowMessage('RTU '+RtuNumber +' and its Encryption succesfully completed')
   else
    ShowMessage('Encryption failed');
  end
  else
    ShowMessage('Encryption is already running');
*)
end;



procedure TclientsT1_2026.BitBtn2Click(Sender: TObject);
begin
ListBox1.Clear;
end;

procedure TclientsT1_2026.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #32 then
begin
 DBGrid1DblClick(Application);
 Query1.Next;
end;
end;

procedure TclientsT1_2026.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #32 then ListBox1DblClick(Application);
end;

procedure TclientsT1_2026.PrintOtherRtuClick(Sender: TObject);
Var FlName:String;
begin
 OpenDialog1.InitialDir := OptRec.EF_DataDir;
 OpenDialog1.Filter :=  'RTU Lines|*.RTU|RTX files|*.RTX';
 {OpenDialog1.Filter :=  'RTU Lines|*.LIN';}
 if OpenDialog1.Execute then
 begin
  FlName := OpenDialog1.FileName;
  {ShowRtuLines(FlName);}
  RtuReport(FlName);
 end;
end;


procedure TclientsT1_2026.PrintRtuListBtnClick(Sender: TObject);
Var i:integer;FileNm,Hdr1,Hdr2,Hdr3:string; F1:textFile; S:string;
begin
   If (ListBox1.Items.Count =0) then
   begin
    ShowMessage('No RTU names selected in this session');
    exit;
  end;
 Hdr1 := Space(30)+'RTU Listing - '+PaddR(RTUNumber,15)+PaddR(DateToMonthDayYear(Date),20);
 Hdr2 := PaddR('Name',25)+PaddR('File',13);
 Hdr3 := FilledStr(80,'=')+FilledStr(14,'=');
 {open output file}
 FileNm:=AppDir+'\'+'TempFile';
 AssignFile(F1,FileNm);
 Rewrite(F1);
 For i:=0 to ListBox1.Items.Count-1 do WriteLn(F1,ListBox1.Items[i]);
 CloseFile(F1);
 If PrintDialog1.Execute then
 begin
  If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
 end;


end;

procedure TclientsT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DataDirBoxExit(Application);
end;

procedure TclientsT1_2026.EfileBtnClick(Sender: TObject);
Var h : THandle; ClickedOK : Boolean;EFMethod:string;
begin

If RTUNumber ='' then
 begin
  if MessageDlg('No RTU created in this session'+
   Chr(13)+ 'Proceed anyway?',
    mtInformation, [mbYes, mbNo], 0) = mrNo
   then exit;
 end;

 ShowMessage('Please use Efile | One step EFile session'+
    Chr(13) + 'from the Main Menu');
 Query1.Free;
 Close;
 {OnestepEFile;}

end;

procedure TclientsT1_2026.ProdRtuBtnClick(Sender: TObject);
begin
 BatchOper := 'PRTU';
 If DoOperation('RTU') then CancelBtnClick(Sender);
end;

procedure TclientsT1_2026.TestT1BtnClick(Sender: TObject);
begin
 BatchOper := 'TRTU';
 If DoOperation('RTU') then CancelBtnClick(Sender);
end;

procedure TclientsT1_2026.DevelpmentT1BtnClick(Sender: TObject);
begin
 BatchOper := 'DRTU';
 If DoOperation('RTU') then CancelBtnClick(Sender);
end;


procedure TclientsT1_2026.ProductionSENDBtnClick(Sender: TObject);
Var i:integer;FlName:String;
begin
 SomeList.Clear;  // :=TStringList.Create;
 For i :=0 to ListBox1.Items.Count-1 do
 begin
   FlName :=ExtractFileName(ListBox1.Items[i]);
   If ValidateSend(DataDirBox.Text,FlName)= false then
    begin
     ShowMessage(LeftStr(ListBox1.Items[i],14) + ' is not a discounted return. Please remove');
     // SomeList.Free; //20160301 Igor
     exit;
    end;
 end;
 //SomeList.Free; //20160301 Igor //20160628 Igor
 BatchOper := 'PSEND';
 If DoOperation('RTU') then CancelBtnClick(Sender);
end;

procedure TclientsT1_2026.TestSendBtnClick(Sender: TObject);
begin
 BatchOper := 'TSEND';
 If DoOperation('RTU') then CancelBtnClick(Sender);
end;

procedure TclientsT1_2026.DevelopmentSendBtnClick(Sender: TObject);
begin
 BatchOper := 'DSEND';
 If DoOperation('RTU') then CancelBtnClick(Sender);
end;

procedure TclientsT1_2026.ShowLinesOtherBtnClick(Sender: TObject);
begin
 OpenDialog1.InitialDir := OptRec.EF_DataDir;
 OpenDialog1.Filter :=  'RTU Lines|*.LIN';
 if OpenDialog1.Execute then ShowRtuLines(OpenDialog1.FileName);
end;

procedure TclientsT1_2026.ShowCurrentLinesBtnClick(Sender: TObject);
Var FlName:String;
begin
If RTUNumber ='' then
begin
 ShowMessage('No RTU created in this session');
 exit;
end;
FlName :=OptRec.EF_datadir+'\'+RtuNumber+'.Lin';
ShowRtuLines(FlName);
end;

Procedure TclientsT1_2026.ShowRTULines(FlName:string);
begin
 If Not FileExists(FlName) then
 begin
  ShowMessage('RTU lines file does not exist');
  exit;
 end;

 PopSomeFile(FlName,'RTU Lines: '+ RTUNumber);
end;

procedure TclientsT1_2026.BarPrintBtnClick(Sender: TObject);
Var i:Integer;
begin
  If LicenseLevel =llDemo then    {demo}
  begin
    ShowMessage('The Demo version does not allow pinting of Barcoded returns');
    exit;
  end;

  If ListBox1.Items.Count = 0 then begin ShowMessage('No records selected');exit;end;

  SomeList.Clear; // := TStringList.Create;
  SomeList.Add(DataDirBox.Text); {Data dir as first entry}
  For i :=0 to ListBox1.Items.Count-1 do
       SomeList.Add(ExtractFileName(ListBox1.Items[i]));  {works, string has \ }

  //BarDataRoutine(RetNo);  {in URTU}

  //RtuLbl.Caption := RTUNumber;
  //RtuLbl.Refresh;
  //SomeList.Free; 20160301 Igor
  exit;

end;

end.

