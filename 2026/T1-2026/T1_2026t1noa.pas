unit T1_2026eolp;
//imported 07-28

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  Forms,DBCtrls,DB,Mask,ExtCtrls,Grids,Dialogs,DBGrids,Buttons,Menus,
  T1_2026Declare,T1_2026TrimStr,//T1_2026Poplist,
  T1_2026RTU,T1_2026Common,
  T1_2026Common2,T1_2026Calc,T1_2026Print,T1_2026T1Rtns,T1_2026T1Rtns2,ShellApi,
  FileCtrl,T1_2026Build813,T1_2026EFILErtns,vtLabel,vtPanel,T1_2026T1Efile,
  T1_2026Eolpack, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;

type
  TEOLPT1_2026 = class(TForm)
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
    PrintRtuListBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    ShowLinesOtherBtn: TBitBtn;
    ShowCurrentLinesBtn: TBitBtn;
    Label3: TLabel;
    HeaderPanel: TPanel;
    LoginInfoPanel: TPanel;
    Label6: TLabel;
    URLBox: TEdit;
    ProdOrTestBox: TRadioGroup;
    SetupBtn: TBitBtn;
    TransmitBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DelayBox: TEdit;
    Label2: TLabel;
    PrintBtn: TBitBtn;
    Label4: TLabel;
    FDConnection: TADConnection;
    Query1: TADQuery;
    Function GetTransmissionId:String;
    procedure BuildAllXMLs(Sender: TObject);  //only to generate for testing purposes
    Procedure ShowRTULines(FlName:string);
    procedure CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
    procedure RemoveBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ExecFile1Fail(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure PrintOtherRtuClick(Sender: TObject);
    procedure PrintRtuListBtnClick(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    Function  RecsSelected:Boolean;
    procedure ShowLinesOtherBtnClick(Sender: TObject);
    procedure ShowCurrentLinesBtnClick(Sender: TObject);
 //   Function  MakeEolPFileName(LicenseLevel:string):string;
    procedure OnlineNoBoxExit(Sender: TObject);
    Function  GetProductionOrTest:String;
    //Function  GetDcnSeqNoEOLP(i:Integer):String;
    Function  GetDcnSeqNoEOLP(RetNo:Integer;i:Integer):String;
 //   Function  GetFirstDcnNoEolP:Integer;
    procedure SetupBtnClick(Sender: TObject);
    procedure TransmitBtnClick(Sender: TObject);
    procedure TransmitOneByOne(RetFiles:TStringList);
    procedure PrintBtnClick(Sender: TObject);
    procedure Query1AfterOpen(DataSet: TDataSet); //20161228 Igor
  private
    RetNo:Integer;
    OnLineNo,PassWord,FileName,Url,OnlineMethod:String;  //to be used bu the uhtmlEfOnline
    NetFileDir:String;
   // DCNSeqNo:String;
    DCNNo:Integer;
    POrT:String[1];
    PrintTemplate : string[20];
    DestinationDir : String[50];
    FilterDescr   :String[40];
  public
    { public declarations }
  end;

var
  EOLPT: TEOLPT1_2026;
  TransmitterNo: string;

implementation

{$R *.DFM}

uses
  vtMulti,vtCommon,vtDialogs,
  T1_2026,T1_2026SQlFilt,T1_2026Main,
  vtTrimStr,vtShared,
  vtDataBase;//20150909 Igor


procedure TEOLPT1_2026.CancelClick(Sender: TObject);
begin
 Close;
end;


Procedure TEOLPT1_2026.RefreshScreen(FilterDescr: string);
begin
 AutoLbl.Caption :=
 '('+FilterDescr+')'+'  No. of returns: '+IntToStr(Query1.RecordCount);
 AutoLbl.Refresh;
 SelectedLbl.Caption := 'Selected: '+IntToStr(ListBox1.Items.Count);
 ListBox1.Refresh;
end;

Function TEOLPT1_2026.OpenQuery(DBName: string;QryName: string): boolean;
begin
 try
   SqlLoadDBFromFile(FDConnection, Query1, DBName + '\' + ClientsDBLite, AppDir+'\'+QryName);//20150909 Igor
   Query1.Open;
   Result := True;
 except
 on EdataBaseError do Result := False; end;

end;

procedure TEOLPT1_2026.FormCreate(Sender: TObject);
const
 separator = '====================';
var i : integer;
begin
 //20180502 Igor >>>
 if not Assigned(XmlList) then
   XmlList := TStringList.Create;
 XmlList.Clear;
 //20180502 Igor <<<
 RtuNumber:='';
 If DelayBox.Text<'200' then DelayBox.text:='200';
// ProdOrTestBox.itemIndex:=1;
// DcnNo:=0;
 Screen.Cursor:=crHourGlass;
 BatchOper := 'Create Efile RTU';
 BatchFilter := 'EF Ready For EFILE';

 GetEOLPParms(OnlineNo,TransmitterNo,Password,Url,NetFileDir);
 UrlBox.Text:=Url;
 DataDirBox.Text := OptRec.Dir_Cur;

// ProdOrTestBox.ItemIndex :=1;

 If BatchFilter = 'EF Ready For EFILE' then
 begin
   RadioGroup1.Items.Add(BatchFilter);
   RadioGroup1.Items.Add('All');
 end;

 {initialize other controls}
 DataDirBox.Text := OptRec.Dir_Cur;
 RadioGroup1.ItemIndex := RadioGroup1.Items.IndexOf(BatchFilter);
 FilterDescr := RadioGroup1.Items[RadioGroup1.ItemIndex];
 OptRec.Dir_Cur := DataDirBox.Text;
 {add horiz. scroll bar to listbox}
 SendMessage(ListBox1.Handle,LB_SetHorizontalExtent,300,LongInt(0));

 OpenQuery(DataDirBox.Text,GetQueryName(FilterDescr)+'.QRY');
 RefreshScreen(FilterDescr);
 Screen.Cursor := crDefault;
end;

procedure TEOLPT1_2026.CancelBtnClick(Sender: TObject);
begin
 Query1.Free;
 Url:=UrlBox.Text;
 Close;
end;

procedure TEOLPT1_2026.DBGrid1DblClick(Sender: TObject);
begin
 (* cannot be done now. only after opening returns
 If LeftStr(LicenseLevel,8)  = 'T1 Multi' then
 begin
  If ret[RetNo].Saved = false then
  begin
   ShowMessage('Please Save the return first');
   Exit;
  end;

  If IsReturnPaid(RetNo)=False then
  begin
   ShowMessage('Return must be set to Paid before Efiling');
   exit;
  end;
 end;
 *)
 If (Query1.FieldByName('EF_Status').AsString = '02')   {accepted}
 or (Query1.FieldByName('EF_Status').AsString = '04')   {waiting ack}
 then
 begin
  ShowMessage(Query1.FieldByName('Last_Name').AsString
   + ' ' +LeftStr(Query1.FieldByName('First_Name').AsString,1)+'.'
   + CHR(13)+ 'Already Efile accepted or waiting Ack!')
 end
 else
 begin
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
 end;

end;

Function TEOLPT1_2026.MkSelectedStr: String;
Const
 PartNameLen = 14;
Var
 S : string[80];
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


Function TEOLPT1_2026.ExistsInList(Astring:String):Boolean;
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


procedure TEOLPT1_2026.ClearBtnClick(Sender: TObject);
begin
ListBox1.Clear;
RefreshScreen(FilterDescr);
end;


procedure TEOLPT1_2026.FilterBoxChange(Sender: TObject);
var
 QueryName : String[30];
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

procedure TEOLPT1_2026.ListBox1DblClick(Sender: TObject);
begin
  ListBox1.Items.Delete(ListBox1.ItemIndex);
  RefreshScreen(FilterDescr);
end;


procedure TEOLPT1_2026.DataDirBoxExit(Sender: TObject);
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

procedure TEOLPT1_2026.RadioGroup1Click(Sender: TObject);
var
 QueryName : String[30];
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

procedure TEOLPT1_2026.SelectAllBtnClick(Sender: TObject);
begin
  ListBox1.Clear;
  Query1.First;
  while not Query1.EOF do
  begin
   DBGrid1DblClick(Sender);
   Query1.Next;
  end;
end;

procedure TEOLPT1_2026.PrintCurrentRtuBtnClick(Sender: TObject);
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

Function TEOLPT1_2026.RecsSelected:Boolean;
begin
  If ListBox1.Items.Count = 0 then
  begin
    ShowMessage('No records selected');
    result :=false;
  end;
 Result := true;
end;

procedure TEOLPT1_2026.RemoveBtnClick(Sender: TObject);
begin
ListBox1DblClick(Sender);
end;

procedure TEOLPT1_2026.AddBtnClick(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;

procedure TEOLPT1_2026.BitBtn1Click(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;

procedure TEOLPT1_2026.ExecFile1Fail(Sender: TObject);
begin
 {
 ShowMessage('Error code: '+IntToStr(ExecFile1.ErrorCode));
 If ExecFile1.ErrorCode =2 then
  ShowMessage('File not found')
 else If ExecFile1.ErrorCode =3 then
  ShowMessage('Directory not found');
  }
end;

procedure TEOLPT1_2026.BitBtn2Click(Sender: TObject);
begin
ListBox1.Clear;
end;

procedure TEOLPT1_2026.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #32 then
begin
 DBGrid1DblClick(Application);
 Query1.Next;
end;
end;

procedure TEOLPT1_2026.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #32 then ListBox1DblClick(Application);
end;

procedure TEOLPT1_2026.PrintOtherRtuClick(Sender: TObject);
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


procedure TEOLPT1_2026.PrintRtuListBtnClick(Sender: TObject);
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

procedure TEOLPT1_2026.Query1AfterOpen(DataSet: TDataSet); //20161228 Igor
begin
  Query1.FetchAll;
end;

procedure TEOLPT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DataDirBoxExit(Application);
end;

procedure TEOLPT1_2026.ShowLinesOtherBtnClick(Sender: TObject);
begin
 OpenDialog1.InitialDir := OptRec.EF_DataDir;
 OpenDialog1.Filter :=  'RTU Lines|*.LIN';
 if OpenDialog1.Execute then ShowRtuLines(OpenDialog1.FileName);
end;

procedure TEOLPT1_2026.ShowCurrentLinesBtnClick(Sender: TObject);
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

Procedure TEOLPT1_2026.ShowRTULines(FlName:string);
begin
 If Not FileExists(FlName) then
 begin
  ShowMessage('RTU lines file does not exist');
  exit;
 end;
 SomeCaption := 'RTU Lines: '+ RTUNumber;
  SelectedString := PopSomeFile(FlName,SomeCaption);
end;


(*
Function TEOLP.MakeEolPFileName(LicenseLevel:string):string;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec : string[2];
begin
  DecodeDate(Now,YYYY,MM,DD);
  DecodeTime(Now,Hour,Min,Sec,Msec);
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SMin  := LTrim(RTrim(IntToStr(Min)));
  SSec := LTrim(RTrim(IntToStr(sec)));
  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SMin)  =1 then SMin  := '0'+SMin;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  If LeftStr(LicenseLevel,8) = 'T1 Multi' then
   Result := LeftStr(UserName,4)+SDD+SSec {User.M_Office+SDD+SSec}
  Else
   Result := SMM + SDD+ SMin+SSec;
end;
*)
procedure TEOLPT1_2026.OnlineNoBoxExit(Sender: TObject);
begin
//If TransmitterNoBox.Text='' then TransmitterNoBox.Text:=OnlineNoBox.Text;
end;

Function TEOLPT1_2026.GetProductionOrTest:String;
Begin
 If ProdOrTestBox.ItemIndex=0 then
   result:='P'
 else
   result:='T';
end;

(*  20140120
Function TEOLP.GetFirstDcnNoEolP:Integer;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec : string[2];
begin
  DecodeDate(Now,YYYY,MM,DD);
  DecodeTime(Now,Hour,Min,Sec,Msec);
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SMin  := LTrim(RTrim(IntToStr(Min)));
  SSec  := LTrim(RTrim(IntToStr(sec)));

  If Length(SMM)   =0 then SMM   := '00';
  If Length(SDD)   =0 then SDD   := '00';
  If Length(SMin)  =0 then SMin  := '00';
  If Length(SSec)  =0 then SSec  := '00';

  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SMin)  =1 then SMin  := '0'+SMin;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  //mm skipped
  Result:=StrToInt(AllTrim(SDD+SMin+SSec));
end;
*)

Function TEOLPT1_2026.GetDcnSeqNoEOLP(RetNo:Integer;i:Integer):String;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec,SMSec : string[2];SInt:String[2];
 Syyyy:String[4];
begin
  Result:=MidStr(FetchElm(RetNo,'T183',21),6,8);     //same with eol
end;



procedure TEOLPT1_2026.SetupBtnClick(Sender: TObject);
begin
 (*
 Application.CreateForm(TEOLPSetup,EOLPSetup);
 EOLPSetup.ShowModal;
 EOLPSetup.Free;
 Get the prms again as in htmleol below
 *)
 (*
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 UrlBox.Text:=Url;
 If UrlBox.Text='' then UrlBox.text:='http://www.netfile.gc.ca/pro';
 Urls.Text:=UrlBox.Text;
 DataDirBox.Text := CfgRec.Dir_Cur;
  *)
end;

procedure TEOLPT1_2026.BuildAllXMLs(Sender: TObject);  //only to generate for testing purposes
Var
 i,j,k,ReturnCode:integer; FName : string[12];//Template:string[12];
 RetFiles:TStringList;
  S:String;
  h:Word;FileNm,OnLineMethod,DcnSeqNo:String;
  ProdOrTest,OnlineNo,Password,Url,NetFileDir:String;
begin
 ShowMessage('Routine Not in effect');
(*  Temp
 If ListBox1.Items.Count = 0 then begin ShowMessage('No records selected');exit;end;
 Screen.Cursor := crHourGlass;
 Retfiles := TstringList.Create;
 For i :=0 to ListBox1.Items.Count-1 do RetFiles.Add(ExtractFileName(ListBox1.Items[i]));  {works, string has \ }

 For i := 0 to RetFiles.Count -1 do
 begin
   ListBox1.ItemIndex :=i;
   ListBox1.Refresh;
   RetFile := RetFiles[i];
   RetNo:=InitNewReturn;
   ReturnCode:=ReadReturn(RetNo,DataDirBox.Text,RetFile);
   If ReturnCode <> 0 then  {it calcs all}
   begin
    RemoveReturnFromMemory(RetNo);
    ShowOpenReturnFailure(ReturnCode,DataDirBox.Text,RetFile);
    CloseFile(F1);
    ShowMessage('Batch file has NOT been created');
    exit;
   end;
      If UpperCase(LeftStr(FetchElm(RetNo,'T183',21),5)) <> UpperCase(TransmitterNo) then
   begin
    ShowMessage('Return: '+GetFirstName(RetNo)+ ' '+GetLastName(RetNo)+Chr(13)
     +' T183: The DCN (at the bottom) does not have your current Transmitter number');
    RemoveReturnFromMemory(RetNo);
    Exit;
   end;
   UpdateAllDataIndicators(RetNo);
   OnLineMethod:='EOL';
   GetEOLParms(OnlineNo,Password,Url,NetFileDir);
   DcnSeqNo:=MidStr(FetchElm(RetNo,'T183',21),6,8);  //20111208
   FileNm :=MkXmlFileName(RetNo,NetFileDir);
   PorT:='P';
   //CheckBeforeEfile(RetNo);
   CreateXmlDataFile(RetNo,FileNm,'',PorT,'P','',OnLineMethod,DcnSeqNo);
 //  h := ShellExecute(Self.Handle,'open',Pchar(''+FileNm),Nil,Nil,Sw_Show);
 //  If H<=32 then ShowMessage('File not found');

 //  EolTaxFlName:=NetFileDir+'\'+RemoveChar(RetFile,'.')+'.TAX';
 //  UBuild813.CreateFile(RetNo,EolTaxFlName,TedFlName,PorT,'P',FirstLast,OnLineMethod,DcnSeqNo);
   // update the client file with the DCN No

   RemoveReturnFromMemory(RetNo);
 end;  //i
 RetFiles.Free;
 Screen.Cursor := crDefault;
 ShowMessage('Done');
 *)
end;


Function TEOLPT1_2026.GetTransmissionId:String;
Var Dt:String;
SHours, SMinutes,SSeconds,SMSeconds : string[2];
    Hour,Min,Sec,Msec :word;
begin
//20111216
  Dt := FormatDateTime('yyyy-mm-dd',Now);
  Dt := MidStr(Dt,6,2)+RightStr(Dt,2);   //MMDD
  DecodeTime(Now,Hour,Min,Sec,Msec);
  sMinutes := AllTrim(IntToStr(Min));  If Length(sMinutes) =1 then SMinutes := '0'+SMinutes;
  sSeconds := AllTrim(IntToStr(Sec));  If Length(SSeconds) =1 then SSeconds := '0'+SSeconds;
  sMSeconds:= AllTrim(IntToStr(MSec));  If Length(SMSeconds)>1 then SMSeconds:= RightStr(SMSeconds,1);
  result:='B'+Dt+SMinutes+SSeconds+SMSeconds;  //10 characters long
end;

procedure TEOLPT1_2026.TransmitBtnClick(Sender: TObject);
Var i:Integer;RetFiles:TStringList;ReturnCode:Integer; RetFile:String;
  //TedFile: File of TAckRec;  //20161226 Igor
begin
 If LicenseLevel in anyMulti+[llPower] then
 Begin
  If (OnLineNo='')  or (TransmitterNo='')  or (Password='') then
  begin
   ShowMessage('Please complete the EFile Setup first');
   Exit;
  end;
 end
 else
 Begin
  ShowTimedMsg('EOL Plus available in the T1 Power version only',1200);
 end;

 If ListBox1.Items.Count = 0 then begin ShowMessage('No records selected');exit;end;
 If ProdOrTestBox.itemIndex =0 then
   ProdOrTest:='P'
 else
   ProdOrTest:='T';

 OnlineMethod:='EOLP';

 Screen.Cursor := crHourGlass;
 //create a file to hold returns submitted in btch  //20140118
 EolPFileName:=NetFileDir+'\'+MakeEolPFileName(LicenseLevel)+'.Ack';
 AssignFile(T1_2026t1efile.TedFile, EolPFileName);  //the
 ReWrite(T1_2026t1efile.TedFile);  //ready to write to

 Retfiles := TstringList.Create;
 For i :=0 to ListBox1.Items.Count-1 do
       RetFiles.Add(ExtractFileName(ListBox1.Items[i]));  {works, string has \ }
 TransmitOneByOne(RetFiles);
 RetFiles.Free;
 CloseFile(T1_2026t1efile.TedFile);  //close the batch file
 PrintBtn.Enabled:=True;
 ShowMessage('Done. You may print the Acknowledgement Report now');
end;


procedure TEOLPT1_2026.TransmitOneByOne(RetFiles:TStringList);
Var
 i,j,k:integer; FName : string; // [12];
 FirstLast:String;s:String;
 ProdOtTest:String;
begin
  (* Where we capture this error?
   //20140126
   If UpperCase(OnlineNo) <> UpperCase(LeftStr(FetchElm(RetNo,'T183',21),5)) then
   Begin
    ShowMessage(Query1.FieldByName('Last_Name').AsString
     +Chr(13)+'The DCN in T183 '+UpperCase(LeftStr(FetchElm(RetNo,'T183',21),5))
     +Chr(13)+'does not agree with the Efiler No '+ UpperCase(OnlineNo) +' in the EOL Plus set up screen');
    Exit;
   end;
 *)

 For i := 0 to RetFiles.Count -1 do
 begin
   ListBox1.ItemIndex :=i;
   ListBox1.Refresh;
   RetFile := RetFiles[i];
   //RetNo:=InitNewReturn;

   RetNo := ReadReturn(DataDirBox.Text,RetFile);
   //ReturnCode:=RetNo;
   //If ReturnCode <> 0 then  {it calcs all}
   If RetNo < 1 then  {it calcs all}
   begin
    //RemoveReturnFromMemory(RetNo);
    ShowOpenReturnFailure(RetNo,DataDirBox.Text,RetFile);
    CloseFile(F1);
    exit;
   end;
   CalcFullReturn(RetNo);   //20120117
   UpdateAllDataIndicators(RetNo);

   Screen.Cursor:=CrDefault;
   XmlList.Clear; //20111212

  If ProdOrTestBox.itemIndex =0 then
   ProdOrTest:='P'
  else
   ProdOrTest:='T';

  T1Efile.CreateSoapMessage(RetNo,ProdOrTest,OnLineMethod);

  If SoapMsg = '' then
  Begin
   ShowMessage('No data available for submission');
   Exit;
  end;
  TransmitDelay:=MyStrToInt(DelayBox.text);
 // Delay(TransmitDelay);  //20131217
  T1Efile.SubmitSoapMsg(RetNo,SoapMsg,ProdOrTest,T1Efile.MkSubmittedFileName(RetNo),OnlineMethod);
  XmlList.Clear;
  // update the client file with the DCN No  ??

  //20140127
  If not SaveReturn(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName,True,False) =0
           then ShowMessage('Return cannot be saved');

   RemoveReturnFromMemory(RetNo);
 end;  //i
 Screen.Cursor := crDefault;
end;

(*
Function TEOLP.MakeEolPFileName(LicenseLevel:string):string;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec : string[2];
begin
  DecodeDate(Now,YYYY,MM,DD);
  DecodeTime(Now,Hour,Min,Sec,Msec);
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SMin  := LTrim(RTrim(IntToStr(Min)));
  SSec := LTrim(RTrim(IntToStr(sec)));
  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SMin)  =1 then SMin  := '0'+SMin;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  If LeftStr(LicenseLevel,8) = 'T1 Multi' then
   Result := LeftStr(UserName,4)+SDD+SSec {User.M_Office+SDD+SSec}
  Else
   Result := SMM + SDD+ SMin+SSec;
end;
*)


procedure TEOLPT1_2026.PrintBtnClick(Sender: TObject);
begin
  ReadAckFileHeaderInfo(EolPFileName);
  SelectAckReport(EolPFileName);
end;

end.
