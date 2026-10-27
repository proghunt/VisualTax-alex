unit T1_2026ytdcash;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls;

type
  TYTDCashFrmT1_2026 = class(TForm)
    YtdDirBox: TEdit;
    Label1: TLabel;
    DayDirBox: TEdit;
    Label2: TLabel;
    ConsolidateBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FileListBox1: TFileListBox;
    ListfileBtn: TBitBtn;
    PrintBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    OptionGroup: TRadioGroup;
    DateBox: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ConsolidateBtnClick(Sender: TObject);
    Procedure ListFiles;
    procedure ListfileBtnClick(Sender: TObject);
    Function EditDirectories:Boolean;
    procedure PrintBtnClick(Sender: TObject);
    Procedure InitReportTotals;
    procedure SummarizeRecords(FlName:String);
    procedure AddToOffice(OfficeId:String;Amount:Real;OfficeNames:TstringList);
    procedure AddToAgent(AgentId:String;Amount:Real;AgentNames:TstringList);
    Procedure PrintReport(ReportingDate:String);
    procedure CancelBtnClick(Sender: TObject);
    Function ValidDate(Dt:String):boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  YTDCashFrm: TYTDCashFrmT1_2026;
  OfficeNames : TstringList;
  OfficeTotals: TStringList;

  AgentTotals : TStringList;
  AgentNames  : TStringList;

  GrandTotal:Real;
  PrintOption :Integer;
  ReportingDate :string; //[10];

implementation

{$R *.DFM}

uses vtCommon,T1_2026Declare,T1_2026TrimStr,T1_2026T1Rtns2,vtTrimStr,vtShared;

Procedure TYTDCashFrmT1_2026.InitReportTotals;
Var i:Integer;
begin
   OfficeNames.Clear;
   OfficeTotals.Clear;
   AgentNames.Clear;
   AgentTotals.Clear;
   GrandTotal :=0;
end;

procedure TYTDCashFrmT1_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 If not FileExists(AppDir+'\'+'YTDSetUp.CFG') then
 begin
  ShowMessage('Please use the YTD set-up screen first');
  exit;
 end;
 Screen.Cursor := crHourGlass;
 DateBox.text := FormatDateTime('yyyy-mm-dd',Date);
  {DateToYYYYMMDD(Date);}
 OptionGroup.ItemIndex :=0;
 OfficeNames :=TstringList.Create;
 OfficeTotals :=TstringList.Create;
 AgentNames :=TstringList.Create;
 AgentTotals :=TstringList.Create;

 TempList := TstringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'YTDSetUp.CFG');
 YtdDirBox.Text := TempList[0];
 DayDirBox.Text := TempList[1];
 ListFiles;
 Screen.Cursor := crDefault;
end;

Function TYTDCashFrmT1_2026.EditDirectories:Boolean;
begin
 Result := False;
 If not DirectoryExists(DayDirBox.Text) then
 begin
  ShowMessage('Daily Cash Directory does not exist');
  exit;
 end;

 If (not DirectoryExists(YTDDirBox.Text))
 or (not FileExists(YTDDirBox.Text+'\'+'CashYtd'))
 then
 begin
  ShowMessage('YTD Cash Directory was not created properly'+
   Chr(13)+'Use Config | YTD Cash reporting set-up');
  exit;
 end;
 Result := true;
end;


Procedure TYTDCashFrmT1_2026.ListFiles;
begin
 If EditDirectories = false then exit;
 FileListBox1.Directory := DayDirBox.Text;
 FileListBox1.Mask := '*.*';
 FileListBox1.ItemIndex :=0;
end;

procedure TYTDCashFrmT1_2026.ConsolidateBtnClick(Sender: TObject);
Var i,j:Integer;LogList:TStringList;
 Ftemp,FYtd: Textfile;YtdFile,DailyFile,TempFile :string; //[60];
 s: string; //[150];
begin
 If EditDirectories = false then exit;
 If FileListBox1.Items.Count =0 then
 begin
  ShowMessage('No files to process');
  exit;
 end;
 Screen.Cursor := crHourGlass;
 YTDFile  := YtdDirBox.Text+'\'+'CashYtd';
 AssignFile(FYtd, YTDFile);
 Try
 Append(FYtd);
 except
 end;
 {Now append all cash files to FYtd}
 LogList := TstringList.Create;
 For i:=0 to FileListBox1.Items.Count-1 do
 begin
  LogList.Clear;
  DailyFile := AllTrim(DayDirBox.Text+'\'+AllTrim(FileListBox1.Items[i]));
  LogList.LoadFromFile(DailyFile);
  For j:=0 to LogList.Count-1 do
   WriteLn(FYTD,LogList[j]); {loglist has detail per cash report}
 end;
 LogList.Free;

 {Now move all processed files to history}
 For i:=0 to FileListBox1.Items.Count-1 do
 begin
  DailyFile := AllTrim(DayDirBox.Text+'\'+AllTrim(FileListBox1.Items[i]));
  If CopyFile(DailyFile,YtdDirBox.Text+'\'+'CashHist'+'\'
     +AllTrim(FileListBox1.Items[i])) = false then
  begin
   ShowMessage('Cannot move cash reports to history directory');
   exit;
  end;
  SysUtils.DeleteFile(DailyFile);
 end;
 FileListBox1.Clear;
 CloseFile(FYtd);
 Screen.Cursor := crDefault;
 ShowMessage('Completed. Processed daily reports moved to History directory');
end;

(*
procedure TYTDCashFrm.ConsolidateBtnClick(Sender: TObject);
Var i,j:Integer;LogList:TStringList;
 Ftemp,FYtd: Textfile;YtdFile,DailyFile,TempFile :string; //[60];
 s: string; //[150];
begin
 If EditDirectories = false then exit;
 If FileListBox1.Items.Count =0 then
 begin
  ShowMessage('No files to process');
  exit;
 end;
 Screen.Cursor := crHourGlass;
 YTDFile  := YtdDirBox.Text+'\'+'CashYtd';
 AssignFile(FYtd, YTDFile);
 {If not FileExists(YtdFile) then Rewrite(FYtd);}

 TempFile := YtdDirBox.Text+'\'+'Temp';
 AssignFile(FTemp, TempFile);

 {copy Fytd to Temp}
 Reset(FYtd);
 Rewrite(FTemp);  {initializethe temp file}
 While Not Eof(FYtd) do
  begin
   Readln(FYtd, S);
   WriteLn(FTemp,s);
  end;
 CloseFile(FYtd); {ftemp still stays open}

 {Now append all cash files to Ftemp}
 LogList := TstringList.Create;
 For i:=0 to FileListBox1.Items.Count-1 do
 begin
  LogList.Clear;
  DailyFile := AllTrim(DayDirBox.Text+'\'+AllTrim(FileListBox1.Items[i]));
  LogList.LoadFromFile(DailyFile);
  For j:=0 to LogList.Count-1 do
   WriteLn(FTemp,LogList[j]); {loglist has detail per cash report}
 end;
 LogList.Free;

 {Now move all processed files to history}
 For i:=0 to FileListBox1.Items.Count-1 do
 begin
  DailyFile := AllTrim(DayDirBox.Text+'\'+AllTrim(FileListBox1.Items[i]));
  If CopyFile(DailyFile,YtdDirBox.Text+'\'+'CashHist'+'\'
     +AllTrim(FileListBox1.Items[i])) = false then
  begin
   ShowMessage('Cannot move cash reports to history directory');
   exit;
  end;
  SysUtils.DeleteFile(DailyFile);
 end;
 FileListBox1.Clear;

 {DeleteFile(YtdFile);}
 CopyFile(TempFile,YtdFile);
 SysUtils.DeleteFile(TempFile);
 Screen.Cursor := crDefault;
 ShowMessage('Completed. Processed daily reports moved to History directory');
end;
*)
procedure TYTDCashFrmT1_2026.ListfileBtnClick(Sender: TObject);
begin
  ListFiles;
end;

procedure TYTDCashFrmT1_2026.PrintBtnClick(Sender: TObject);
begin
 If OptionGroup.ItemIndex = 1 then
 begin
  If not ValidDate(DateBox.Text) then
  begin
   showMessage('Invalid Date');
   exit;
  end;
 end;
 ReportingDate:= AllTrim(DateBox.Text);
 PrintOption:=OptionGroup.ItemIndex;
 InitReportTotals;
 SummarizeRecords(YtdDirBox.Text+'\'+'CASHYTD');
 PrintReport(ReportingDate);
end;

Function TYTDCashFrmT1_2026.ValidDate(Dt:String):boolean;
begin
 Result := false;
 If (MidStr(dt,5,1) <> '-') or (MidStr(dt,8,1) <> '-')
    or (Length(dt) <> 10) then exit;
 Result:=True;
end;

Procedure TYTDCashFrmT1_2026.PrintReport(ReportingDate:String);
Var i:Integer;FileNm,Hdr1,Hdr2,Hdr3,s:string;
TempList:TstringList;
begin
 TempList :=Tstringlist.Create;
 If PrintOption = 0 then
  Hdr1:= 'YTD Revenue by Office'+Space(60)+JustRight(DateToMonthDayYear(Date),20)
 else
  Hdr1 := 'Revenue by Office on ' +ReportingDate+Space(60);
 Hdr2 := Space(20)+'Office'+Space(20)+'Total';
 Hdr3 := FilledStr(80,'=')+FilledStr(14,'=');

 For i:=0 to OfficeNames.Count-1 do
 begin
  s := Space(20)+OfficeNames[i]
       +Space(20)+JustRight(FormatFloat('##,###,###.00',Vl(OfficeTotals[i])),13);
  TempList.Add(s);
  TempList.Add(' ');
 end;
 TempList.Add(Space(20)+Space(5)+Space(20)+JustRight('-------------',13));
 s:=Space(20)+'TOTAL'+Space(20)
    +JustRight(FormatFloat('##,###,###.00',GrandTotal),13);
 TempList.Add(s);

 {by agent}
 TempList.Add(' ');
 TempList.Add(' ');
 TempList.Add(' ');
 TempList.Add(FilledStr(80,'=')+FilledStr(14,'='));
 TempList.Add(Space(20)+'Agent '+Space(20)+'Total');
 TempList.Add(FilledStr(80,'=')+FilledStr(14,'='));
 For i:=0 to AgentNames.Count-1 do
 begin
  s := Space(20)+AgentNames[i]
       +Space(16)+JustRight(FormatFloat('##,###,###.00',Vl(AgentTotals[i])),13);
  TempList.Add(s);
 end;

 FileNm:=YtdDirBox.Text+'\'+'TempFile';
 TempList.SaveToFile(FileNm);

 If PrintDialog1.Execute then
 begin

 If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
  ShowMessage('Printing Completed');
 end;
end;

procedure TYTDCashFrmT1_2026.SummarizeRecords(FlName:String);
Var FYtd:TextFile; S,OfficeId,AgentId:String;
    AmountPaid:Real; TransDate:String;
begin
 AssignFile(FYtd, FlName);
 Reset(FYtd);
 While Not Eof(FYtd) do
 begin
   {     PaddR(LogRec.Pay_dt,10)
         +PaddR(LogRec.OfficeCode,4)
         +PaddR(LogRec.AgentCode,4)
         +PaddR(LogRec.Pay_InvNo,14)
         +PaddR(LogRec.Pay_Type,7)
         +PaddR(LogRec.Pay_amount,9)
         +PAddR(LogRec.ReturnType,1)
         +PAddr(LogRec.RefundOrDue,9)
         +PaddR(LogRec.LastName,30)
         +PaddR(LogRec.FirstName,10)
         +PaddR(LogRec.SinNo,9)
         +PaddR(LogRec.Phone,13)
         +Space(20);
   }

   Readln(FYtd, S);
   OfficeId := UpperCase(AllTrim(MidStr(s,11,4)));
   AgentId := UpperCase(AllTrim(MidStr(s,11,8)));
   AmountPaid := Vl(AllTrim(MidStr(s,40,9)));
   TransDate:= LeftStr(S,10);
   If PrintOption =0 then
   begin
   AddToOffice(OfficeId,AmountPaid,OfficeNames);
   AddToAgent(AgentId,AmountPaid,AgentNames);
   GrandTotal := GrandTotal+AmountPaid;
   end
   else
   begin
     If TransDate = ReportingDate then
     begin
       AddToOffice(OfficeId,AmountPaid,OfficeNames);
       AddToAgent(AgentId,AmountPaid,AgentNames);
       GrandTotal := GrandTotal+AmountPaid;
     end;
   end;
 end; {while}
 CloseFile(FYtd); {ftemp still stays open}
end;

procedure TYTDCashFrmT1_2026.AddToOffice(OfficeId:String;Amount:Real;OfficeNames:TStringList);
Var I,j:Integer;
begin
 i:=IsInList(OfficeId,OfficeNames);
 If i<0 then {not in list}
 begin
   j:=OfficeNames.Count;
   OfficeNames.Add(OfficeId);
   OfficeTotals.Add('0');
   OfficeTotals[j] := FloatToStr(Vl(OfficeTotals[j])+Amount);
   exit;
 end
 else {in list}
 begin
   OfficeTotals[i] := FloatToStr(Vl(OfficeTotals[i])+Amount);
   exit;
 end;

end;

procedure TYTDCashFrmT1_2026.AddToAgent(AgentId:String;Amount:Real;AgentNames:TstringList);
Var I,j:Integer;
begin
 i:=IsInList(AgentId,AgentNames);
 If i<0 then {not in list}
 begin
   j:=AgentNames.Count;
   AgentNames.Add(AgentId);
   AgentTotals.Add('0');
   AgentTotals[j] := FloatToStr(Vl(AgentTotals[j])+Amount);
   exit;
 end
 else {in list}
 begin
   AgentTotals[i] := FloatToStr(Vl(AgentTotals[i])+Amount);
   exit;
 end;

end;


procedure TYTDCashFrmT1_2026.CancelBtnClick(Sender: TObject);
begin
 OfficeNames.Free;
 OfficeTotals.Free;
 AgentNames.Free;
 AgentTotals.Free;
end;

end.
