unit uefileFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,FileCtrl,
  UDeclare,Trimstr,UPopList,ShellApi;

Const ElemSep = '*';
      LineSep = '!';
      GenericAgent = 'B6671';
      EfileSoftCode='99AA';
      CertifDate='2001/08/30';
  {
Type
 TSA = Record
   Pay_dt       : String[10];
 end;
}
type
  TEfileFrm = class(TForm)
    HeaderPanel: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SinBox: TEdit;
    BirthDateBox: TEdit;
    FileNameBox: TEdit;
    RefundBox: TRadioButton;
    Label4: TLabel;
    CreateBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ShowBtn: TBitBtn;
    TransmitBtn: TPanel;
    WorldButton: TImage;
    Label5: TLabel;
    ProdOrTestBox: TRadioGroup;
    Panel2: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    FileListBox1: TFileListBox;
    DataDirBox: TEdit;
    DoAllBtn: TBitBtn;
    LoadallfilesBox: TCheckBox;
    Label12: TLabel;
    NameBox: TEdit;
    Panel3: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    BuildBtn: TBitBtn;
    Panel4: TPanel;
    Label19: TLabel;
    Label20: TLabel;
    URLBox: TEdit;
    Label6: TLabel;

    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CreateBtnClick(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure TransmitBtnClick(Sender: TObject);
    Function CanItBeNetfiled(RetNo:Integer):Boolean;
    procedure CreateFile(FlName:String;POrT:String;FlType:String);

    {Hdr}
    Procedure BuildISA(RetNo:Integer;PorT:String);
    Procedure BuildGS(RetNo:Integer);

    Procedure BuildHdrST010(RetNo:Integer);
    Procedure BuildHdrBTI020(RetNo:Integer);
    Procedure BuildHdrDTM030(RetNo:Integer);
    Procedure BuildHdrTIA040(RetNo:Integer);
    Procedure BuildHdrREF050(RetNo:Integer);
    Procedure BuildHdrTRN060(RetNo:Integer);
    Procedure BuildHdrN1070(RetNo:Integer);
    Procedure BuildHdrN2080(RetNo:Integer);
    Procedure BuildHdrIN2085(RetNo:Integer);
    Procedure BuildHdrN3090(RetNo:Integer);
    Procedure BuildHdrN4100(RetNo:Integer);
    Procedure BuildHdrPER105(RetNo:Integer);

    Procedure BuildDtlTFS010(RetNo:Integer);
    Procedure BuildDtlFGS100(RetNo:Integer);
    Procedure BuildDtlN1130(RetNo:Integer);
    Procedure BuildDtlTIA180(RetNo:Integer);
    Procedure BuildDtlFGS210(RetNo:Integer);
    Procedure BuildDtlTIA290(RetNo:Integer);
    Procedure BuildDtlTFS320(RetNo:Integer);
   // Procedure BuildDtlFGS410(RetNo:Integer); //20170525
    Procedure BuildDtlFGS420(RetNo:Integer;GT,IJ,M8,M9:String);
    Procedure BuildDtlDTM430(RetNo:Integer;D1,D2:String);
    Procedure BuildDtlN1440(RetNo:Integer;BusName:String);
    Procedure BuildDtlN3470(RetNo:Integer;BusAddress,BusPostal:String);
    Procedure BuildDtlTIA490(RetNo:Integer;ACM,BTC,FYB,PSB,TAF,TAO:String);
    Procedure BuildDtlFGS520(RetNo:Integer;PNo:Integer);
    Procedure BuildDtlN1550(RetNo:Integer;Sin:String);
    Procedure BuildDtlIN2570(RetNo:Integer;PFirstNm,PLastNm:String);
    Procedure BuildDtlTIA600(RetNo:Integer;PPerCent:String);
    Procedure BuildDtlFGS740(RetNo:Integer);
    Procedure BuildDtlTIA820(RetNo:Integer;LLineString:String;s:String);

    Procedure BuildSE(RetNo:Integer);
    Procedure BuildGE(RetNo:Integer);
    Procedure BuildIEA(RetNo:Integer);

    procedure Panel1Click(Sender: TObject);
    procedure WorldButtonClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    Function GetProdOrTest:String;
    Function GetNetFileDir:String;
    procedure DoAllBtnClick(Sender: TObject);
    procedure DoAll;
    procedure BuildBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EfileFrm: TEfileFrm;
  {FileNm :String;}
  F1:TextFile;
  SfdNo : Integer;
  EFlines  : TStringList;
  ProdOrTest:String[1];
  CrLf  :String;
  SegmentCnt:Integer;
  NetFileDir:String;
implementation

uses main;

{$R *.DFM}

procedure TEfileFrm.CancelBtnClick(Sender: TObject);
begin
Close;
end;

Function TEfileFrm.GetNetFileDir:String;
begin
Result:='';
Try
 If Not DirectoryExists(AppDir+'\'+'NetFile') then
 begin
  CreateDir(AppDir+'\'+'NetFile');
  Result:= AppDir+'\'+'NetFile';
 end
 else
  Result:= AppDir+'\'+'NetFile';
 except
  ShowMessage('Unable to create Directory'+
  Chr(13)+AppDir+'\'+'NetFile');
 end; {try}
end;

Procedure TEfileFrm.BuildHdrIN2085(RetNo:Integer);
begin
 {}
end;

Procedure TEfileFrm.BuildHdrN3090(RetNo:Integer);
begin
 {}
end;

Procedure TEfileFrm.BuildHdrN4100(RetNo:Integer);
begin
 {}
end;


Procedure TEfileFrm.BuildHdrTRN060(RetNo:Integer);
begin
 {}
end;

procedure TEfileFrm.FormCreate(Sender: TObject);
begin
 (*
 UrlBox.Text:='http://www.netfile.gc.ca/agent-ready-e.html';

 If NetSoftCode = '064B' then
   HeaderPanel.Caption := 'VisualTax NETFILE-PRO (For professional preparers)'
 else
   HeaderPanel.Caption := 'VisualTax NETFILE (For individuals)';

 If LoadAllFilesBox.Checked then
 begin
  DataDirBox.Text := CfgRec.Dir_Cur;
  FileListBox1.Directory := DataDirBox.Text;
  FileListBox1.Mask := '*.*';
  FileListBox1.ItemIndex :=0;
end;
 NameBox.Text := GetFirstName(RetNo)+' '+GetLastName(RetNo);
 SinBox.Text :=GetSinNo(RetNo);
 BirthDateBox.Text := FetchElm(RetNo,'T2',9);
 NetFileDir:=GetNetFileDir;
 FileNameBox.Text := NetFileDir+'\'+GetSinNo(RetNo)+'.TAX';
 If Ret[RetNo]^.Balance <0 then
  RefundBox.Checked := True
 else
  RefundBox.Checked := False;
 ProdOrTestBox.ItemIndex :=0;
 *)
end;


procedure TEfileFrm.CreateBtnClick(Sender: TObject);
Var FileNm:String;
begin
 {FileNm :=NetFileDir+'\'+GetSinNo(RetNo)+'.TAX';}
 CreateFile(FileNm,GetProdOrTest,'P');
 ShowMessage('Done');
end;

Function TEfileFrm.GetProdOrTest:String;
begin
 If ProdOrTestBox.itemIndex =0 then
   Result:='P'
 else
   Result :='T';
end;

procedure TEfileFrm.CreateFile(FlName:String;POrT:String;FlType:String);
Var Rec:String;
begin
 If CanItBeNetFiled(RetNo) = False then exit;
 Screen.Cursor := CrHourGlass;
 SegmentCnt :=0;
 If FlType = 'T' then
   crlf:=Chr(13)+Chr(10)
 else
   CrLf  :='';


 AssignFile(F1,FlName);
 Rewrite(F1);

 BuildISA(RetNo,POrT);
 BuildGS(RetNo);
 BuildHdrST010(RetNo);
 BuildHdrBTI020(RetNo);
 BuildHdrDTM030(RetNo);
 BuildHdrTIA040(RetNo);
 {BuildHdr2TIA(RetNo);}
 BuildHdrREF050(RetNo);
 BuildHdrTRN060(RetNo);
 BuildHdrN1070(RetNo);
 BuildHdrN2080(RetNo);
 BuildHdrIN2085(RetNo);
 BuildHdrN3090(RetNo);
 BuildHdrN4100(RetNo);
 BuildHdrPER105(RetNo);

 BuildDtlTFS010(RetNo);
 BuildDtlFGS100(RetNo);
 BuildDtlN1130(RetNo);
 BuildDtlTIA180(RetNo);
 BuildDtlFGS210(RetNo);
 BuildDtlTIA290(RetNo);

 {SFD}
{ BuildSfds(RetNo);}

 {Trailing}
 BuildSE(RetNo);
 BuildGE(RetNo);
 BuildIEA(RetNo);
 {Write(F1,Space(12));}
 CloseFile(F1);
 Screen.Cursor := CrDefault;
end;

procedure TEfileFrm.ShowBtnClick(Sender: TObject);
Var Flnm:String;
begin
 Try
  Flnm :=Appdir+'\'+'Temp.TAX';
  CreateFile(Flnm,GetProdOrTest,'T');
  SomeList.Clear; // := TStringList.Create; //20160704 Igor
  SomeCaption := 'NetFile contents';
  SomeList.LoadFromFile(Flnm);
  Application.CreateForm(TPoplist,PopList);
  {PopList.Width := 800;}
  PopList.ShowModal;
 Finally
  //SomeList.Free; //20160704 Igor
  PopList.Release;
 end;
end;

procedure TEfileFrm.TransmitBtnClick(Sender: TObject);
Var h:THandle;FileNm:String;
begin
  Screen.Cursor :=crHourGlass;

  FileNm := FileNameBox.Text;
  If Not FileExists(FileNm) then
  begin
   ShowMessage('File '+FileNm+' has not been built or invalid directory');
   exit;
  end;

  CreateFile(FileNm,GetProdOrTest,'P');

  {If SoftCode = '064B' then}
  h := ShellExecute(MainForm.Handle,'open',PChar(UrlBox.text),Nil,Nil,Sw_Show);
 { h := ShellExecute(MainForm.Handle,'open','HTTP://www.NetFile.GC.CA/',Nil,Nil,Sw_Show);}

  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;

end;

(*
Function TEFile.GetNumberOfSFDs(RetNo:Integer):Integer;
Var RentSfds,BusSfds,ProfSfds,FarmSfds,FishSfds : Integer;
begin
end;
*)
Function TEfileFrm.CanItBeNetfiled(RetNo:Integer):Boolean;
begin
(*
 IF GetNumberOfSfds(RetNo) > 6 THEN
 begin
  Result := False;
  ShowMessage('More than 6 SFDs in return of'+Chr(13)+
                 GetFirstName(RetNo)+' '+GetLastName(RetNo)+Chr(13)+
                 'It will be rejected by NetFile');
  exit;
 end;
 *)
end;

Procedure TEfileFrm.BuildISA(RetNo:Integer;PorT:String);
Var Rec:String;Dt:String;Tm:String;
begin
 Dt := FormatDateTime('yyyy/mm/dd',Now);
 Dt := MidStr(Dt,3,2)+MidStr(Dt,6,2)+RightStr(Dt,2);
 Tm:=GetTheTime(Now);
 Rec:= 'ISA'+ElemSep
     +'00'+ElemSep        {1}
     +Space(10)+ElemSep   {2}
     +'00'+ElemSep        {3}
     +Space(10)+ElemSep   {4}
     +'ZZ'+ElemSep        {5}
     +'T2813TPID'+Space(6)+ElemSep  {6}
     +'ZZ'+ElemSep        {7}
     +'REVCANTRT2813TPID'+Space(6)+ElemSep  {8}
     +Dt+ElemSep        {9}
     +Tm+ElemSep        {10}
     +'U'+ElemSep        {11}
     +'0401'+ElemSep        {12}
     +'000000955'+ElemSep        {13}
     +'0'+ElemSep        {14}
     +GetProdOrTest+ElemSep    {15}
     +'~'+LineSep              {16}
     +Crlf;

     (*
     +NetSoftCode+Space(6)+ElemSep  {2}
     +'00'+ElemSep                  {3}
     +Space(10)+ElemSep             {4}
     +'ZZ'+ElemSep                  {5}
     +GenericAgent+Space(10)+ElemSep     {6}
     +'ZZ'+ElemSep                  {7}
     +'CCRAADRCPR'+Space(5)+ElemSep  {8}
     +Dt+ElemSep             {9}
     +Tm+ElemSep               {10}
     +'U'+ElemSep               {11}
     +'00401'+ElemSep               {12}
     {+GetSinNo(RetNo)+ElemSep }        {13}
     +'0'+ElemSep       {14}
     +GetProdOrTest+ElemSep                   {15}
     +'~'+LineSep              {16}
     +Crlf;
    *)
  Write(F1,Rec);
end;

Procedure TEfileFrm.BuildGS(RetNo:Integer);
Var Rec:String;Tm:String;
begin
 Tm:=GetTheTime(Now);
 Rec:= 'GS'+ElemSep
     +'TF'+ElemSep        {1}
     +GetCorpBusNo(RetNo)+ElemSep  {2}
    { +GenericAgent+ElemSep}  {2}
     +'GCRCCETT2'+ElemSep                {3}
     +RemoveChar(DateToYYYYMMDD(Now),'/')+ElemSep             {4}
     + Tm+ElemSep                  {5}
     +'555'+ElemSep    {6}
     {+GetSinNo(RetNo)+ElemSep }    {6}
     +'X'+ElemSep                  {7}
     +'4010'+LineSep              {8}
     +Crlf;
   Write(F1,Rec);
end;

Procedure TEfileFrm.BuildHdrST010(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'ST'+ElemSep
     +'813'+ElemSep        {1}
     +'1234'+LineSep       {2}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildHdrBTI020(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'BTI'+ElemSep
     +'T6'+ElemSep        {1}
     +'T2'+ElemSep  {2}
     +'47'+ElemSep                  {3}
     +'RC'+ElemSep             {4}
     +{RemoveChar(DateToYYYYMMDD(Now),'/')}ElemSep {5}
     +ElemSep        {6}
     +'FI'+ElemSep           {7}
     +GetCorpBusNo(RetNo)+ElemSep                {8}
     +ElemSep     {9}
     +ElemSep     {10}
     {+GenericAgent+ElemSep}                  {10}
     +'94'+ElemSep              {11}
     +EfileSoftCode+LineSep              {11}
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildHdrDTM030(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'DTM'+ElemSep
     +'097'+ElemSep        {1}
     +RemoveChar(DateToYYYYMMDD(Now),'/')+LineSep {2}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

 Rec:= 'DTM'+ElemSep
     +'193'+ElemSep        {1}   {sart yr}
     +RemoveChar(GetBegYearEnd(RetNo),'/')+LineSep {2}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);


  Rec:= 'DTM'+ElemSep
     +'194'+ElemSep        {1}   {sart yr}
     +RemoveChar(GetYearEnd(RetNo),'/')+LineSep {2}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);


  Rec:= 'DTM'+ElemSep
     +'467'+ElemSep        {1}   {certf date}
     +RemoveChar(CertifDate)+LineSep {2}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

  If FetchElm(RetNo,'T2',18)>'' then
  begin
   Rec:= 'DTM'+ElemSep
      +'801'+ElemSep        {1}
      +RemoveChar(FetchElm(RetNo,'T2',18),'/')+LineSep {2} {Acq control}
      +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
  end;
end;

Procedure TEfileFrm.BuildHdrTIA040(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'TIA'+ElemSep
     +'INR'+ElemSep        {1}
     +ElemSep          {2}
     +'1'+LineSep           {3}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;

(*
Procedure TEFile.BuildHdr2TIA(RetNo:Integer);
Var Rec:String;
begin
 If GetNumberOfSfds(RetNo) >0 then
 begin
   Rec:= 'TIA'+ElemSep
     +'SFD'+ElemSep        {1}
     +ElemSep          {2}
     +AllTrim(IntToStr(GetNumberOfSfds(RetNo)))+LineSep           {3}
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;
end;
*)

Procedure TEfileFrm.BuildHdrN1070(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'N1'+ElemSep
     +'TP'+ElemSep        {1}
     +ElemSep          {2}
     +'34'+ElemSep           {3}
     {+GetSinNo(RetNo)+LineSep }   {4}
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildHdrN2080(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'N2'+ElemSep
     +ElemSep+ElemSep+ElemSep+ElemSep        {1,2,3,4}
     +'TX'+ElemSep           {5}
     +Ret[RetNo]^.Province+LineSep    {6}
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildHdrPER105(RetNo:Integer);
Var Tel:String;Rec:String;
begin
 Tel := FetchElm(RetNo,'T2',341)
        +RemoveChar(FetchElm(RetNo,'T2',342),'-');
 If Tel='' then Tel:='0000000000';
 Rec:= 'PER'+ElemSep
     +'TP'+ElemSep           {1}
     +ElemSep          {2}
     +'TE'+ElemSep           {3}
     +Tel+LineSep    {4}
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;


Procedure TEfileFrm.BuildHdrREF050(RetNo:Integer);
Var Rec:String;
begin
 (*
 If GetFirstNationNumber(RetNo) >'' then
 begin
  Rec:= 'REF'+ElemSep
      +'U1'+ElemSep {}
      +GetFirstNationNumber(RetNo)+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 *)
end;


Procedure TEfileFrm.BuildDtlTFS010(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'TFS'+ElemSep
     +'T6'+ElemSep           {1}
     +'DTR'+LineSep    {4}
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildDtlFGS100(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'FGS'+ElemSep
     +'FX'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildDtlN1130(RetNo:Integer);
Var Rec,SpouseSIN,SpouseFirstNm:String;
begin
(*
 SpouseSIN   := FetchElm(RetNo,'T2',4);
 IF SpouseSIN ='' THEN SpouseSIN:='000000000';
 SpouseFirstNm:=LeftStr(FetchElm(RetNo,'T2',20),4);
 If SpouseFirstNm='' then SpouseFirstNm :=Space(1);
 if SpouseFirstNm+SpouseSin>'' then
 begin
  Rec:= 'N1'+ElemSep
      +'SY'+ElemSep
      +SpouseFirstNm+ElemSep
      +'34'+ElemSep
      +SpouseSin+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 *)
end;


Procedure TEfileFrm.BuildDtlFGS210(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'FGS'+ElemSep
     +'FF'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildDtlTIA290(RetNo:Integer);
Var Rec:String; i, Rule, LLine,ElmNo:integer;
   LType : string[1]; FName :string[9]; S : string;
   LLineString:String[4];
   EFlines:TstringList;
begin
(*
  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFLINE.D');

  For i := 0 to Eflines.Count - 1 do
  begin
    LLine := MyStrToInt(AllTrim(LeftStr(Eflines[i],4)));
    If LLine = 9999 then break; {???????????????}
    LType := UpperCase(MidStr(Eflines[i],5,1));
    FName := AllTrim(MidStr(Eflines[i],7,9));
    ElmNo := MyStrToInt(AllTrim(MidStr(Eflines[i],17,3)));
    If MidStr(Eflines[i],21,1) = 'R' then
      Rule := MyStrToInt(AllTrim(MidStr(Eflines[i],22,4)))
    else
      Rule := 0;
    If ((LLine>0) and (ElmNo >0)) or ((LLine>0) and (Rule >0)) then
    begin
       S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);

       If (LLine = 490) then s:='2';  {preparer code}
       If LLine = 463 then s:='';  {t1dd field}
       If LLine = 6509 then s:='';  {disc date}
       If (LLine = 260) and (LeftStr(s,1) = '-')  then s:='0';

       If (FName = 'T1DD') or (FName = 'RC71_1') then s:='';
       If (FName = 'T2') and (ElmNo=49)  then s:='00';  {Alt address}
       If (FName = 'T2') and (ElmNo=53) then s:='';  {CV}

       If S > '' then
       begin
         If LLine <100 then
            LLineString := PaddZero(IntToStr(LLine),3)
         else
            LLineString :=IntToStr(LLine);


         If Ltype = 'N' then
           Rec:= 'TIA'+ElemSep
           +LLineString+ElemSep
           +ElemSep
           +s+LineSep  {3}
           +Crlf
         else
          Rec:= 'TIA'+ElemSep
           +LLineString+ElemSep
           +S+LineSep  {3}
           +Crlf;
         Write(F1,Rec);
         Inc(SegmentCnt);
       end; {s>''}
    end; {if line or value exists}
  end; {i}
 *)
end;

Procedure TEfileFrm.BuildDtlTIA180(RetNo:Integer);
Var Rec:String;Lang,GstYesNo,Election:String;KidsUnder19:String;
    SpouseNetInc,SSE:String;
begin
(*
 Rec:= 'TIA'+ElemSep+'MRS'+ElemSep+ElemSep+IntToStr(Ret[RetNo]^.MarStatus)
       +LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 If (UpperCase(FetchElm(RetNo,'T2',29)) = 'X') then
  GstYesNo := '1'
 else
  GstYesNo := '2';
 Rec:= 'TIA'+ElemSep+'GST'+ElemSep+ElemSep+GstYesNo+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 SSE:=FetchElm(RetNo,'T2',50); {Spouse self empl}
 Rec:= 'TIA'+ElemSep+'SSE'+ElemSep+ElemSep+SSE+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 If FetchElm(RetNo,'T2',34) >'' then Lang := '1' else Lang := '2';
 Rec:= 'TIA'+ElemSep+'COR'+ElemSep+ElemSep+Lang+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 KidsUnder19 :=RmvLeadingZeros(AllTrim(FetchElm(RetNo,'T2',31)));
 If Vl(KidsUnder19) >0 then
 begin
  Rec:= 'TIA'+ElemSep+'NOC'+ElemSep+ElemSep+KidsUnder19+LineSep+Crlf;
  Write(F1,rec);
  Inc(SegmentCnt);
 end;

 If (Ret[RetNo]^.MarStatus <3)
 and
  (UpperCase(FetchElm(RetNo,'T2',29)) ='X') THEN {CLAIM GST}
 begin
   IF SpouseIncome(RetNo) >0 then
   Begin
    SpouseNetInc:=AllTrim(NoDecimal(FloatToStr(SpouseIncome(RetNo))));
    Rec:= 'TIA'+ElemSep+'SNI'+ElemSep+SpouseNetInc+LineSep+Crlf;
    Write(F1,rec);
    Inc(SegmentCnt);
   end;
 end;

 If UpperCase(FetchElm(RetNo,'T2',43)) >'' then
    Election := '01'
 else
    Election := '02';
 Rec:= 'TIA'+ElemSep+'ECR'+ElemSep+ElemSep+Election+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);
*)
end;
(*
Procedure TEFile.BuildSfds(RetNo:Integer);
Var i:Integer;Rec:String;
begin
 If GetNumberOfSFDs(RetNo) <1 then exit;

 For i:= 1 to 5 do
 begin
  SFD.PRec[i].PFirstName := '';
  SFD.PRec[i].PLastName  := '';
  SFD.PRec[i].PSin       := '';
  SFD.PRec[i].PPerCent   := '';
 end;

 SfdNo:=0;
 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If ((Frec^.FormInst>'') and (Ret[RetNo]^.FrmHasData[Frec^.FormNo])) then
   begin
     If Frec^.FormName = 'T776_1'  then
      begin
      Inc(SfdNo);
      BuildRental(Frec^.FormInst);
      end
     Else If Frec^.FormName = 'T2124_1' then
      begin Inc(SfdNo);BuildBusiness(Frec^.FormInst);end
     Else If Frec^.FormName = 'T2032_1' then
      begin Inc(SfdNo);BuildProfession(Frec^.FormInst);end
     Else If Frec^.FormName = 'T2042_1' then
      begin Inc(SfdNo);BuildFarming(Frec^.FormInst);end
     Else If Frec^.FormName = 'T2121_1' then
      begin Inc(SfdNo);BuildFishing(Frec^.FormInst);end;
   end;
 end;
end;
*)

Procedure TEfileFrm.BuildSE(RetNo:Integer);
Var Rec:String;
begin
 Inc(SegmentCnt);
 Rec:= 'SE'+ElemSep
     +AllTrim(IntToStr(SegmentCnt))+ElemSep
     +'0001'+LineSep
     +Crlf;
 Write(F1,Rec);
end;


Procedure TEfileFrm.BuildDtlTFS320(RetNo:Integer);
Var Rec:String;
Begin
 Rec:= 'TFS'+ElemSep
     +'1Z'+ElemSep
     +'SFD'+ElemSep
     +'55'+ElemSep
     +AllTrim(IntToStr(SfdNo))+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

{//20170525
Procedure TEfileFrm.BuildDtlFGS410(RetNo:Integer);
Var Rec:String;
Begin
 Rec:= 'FGS'+ElemSep
     +'X2'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;
}
Procedure TEfileFrm.BuildDtlFGS420(RetNo:Integer;GT,IJ,M8,M9:String);
Var Rec:String; {GT=GST no, IJ=SIC M8=Partnerhip id    M9=Tax Shelterno}
begin
 If AllTrim(GT) >'' then
 begin
  Rec:= 'REF'+ElemSep
      +'GT'+ElemSep
      +GT+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 
 Rec:= 'REF'+ElemSep
     +'IJ'+ElemSep
     +IJ+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);

 If (AllTrim(M8) >'')  then
 begin
  Rec:= 'REF'+ElemSep
      +'M8'+ElemSep
      +M8+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 If (AllTrim(M9) >'') then
 begin
  Rec:= 'REF'+ElemSep
      +'M9'+ElemSep
      +M9+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
end;

Procedure TEfileFrm.BuildDtlDTM430(RetNo:Integer;D1,D2:String);
Var Rec:String;
begin
 Rec:='DTM'+ElemSep
     +'193'+ElemSep
     +D1+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);

 Rec:='DTM'+ElemSep
     +'194'+ElemSep
     +D2+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);

end;

Procedure TEfileFrm.BuildDtlN1440(RetNo:Integer;BusName:String);
Var Rec:String;
begin
 If BusName = '' then BusName := ' ';
 Rec:= 'N1'+ElemSep
     +'DH'+ElemSep
     +AllTrim(BusName)+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildDtlN3470(RetNo:Integer;BusAddress,BusPostal:String);
Var Rec:String;
begin
 If AllTrim(BusAddress)+AllTrim(BusPostal) >'' then
 begin
  Rec:= 'N3'+ElemSep
       +AllTrim(BusAddress)+ElemSep
       +AllTrim(BusPostal)+LineSep
       +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;
end;

Procedure TEfileFrm.BuildDtlTIA490(RetNo:Integer;ACM,BTC,FYB,PSB,TAF,TAO:String);
Var Rec:String;
begin
 Rec:= 'TIA'+ElemSep
     +'ACM'+ElemSep
     +ElemSep
     +Acm+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);

 Rec:= 'TIA'+ElemSep
     +'BTC'+ElemSep
     +ElemSep
     +BTC+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);

 If FYB='1' then
 begin
  Rec:= 'TIA'+ElemSep
     +'FYB'+ElemSep
     +ElemSep
     +FYB+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 If PSB <> '0000' then
 begin
  Rec:= 'TIA'+ElemSep
     +'PSB'+ElemSep
     +ElemSep+ElemSep+ElemSep+ElemSep
     +PSB+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 If (TAF>'') then
 begin
  Rec:= 'TIA'+ElemSep
      +'TAF'+ElemSep+ElemSep+ElemSep
      +TAF+ElemSep
      +'AC'+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 If (TAO>'') then
 begin
   Rec:= 'TIA'+ElemSep
    +'TAO'+ElemSep+ElemSep+ElemSep
     +TAO+ElemSep
     +'AC'+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;
end;

Procedure TEfileFrm.BuildDtlFGS520(RetNo:Integer;PNo:Integer);
Var Rec:String;
begin
 Rec:= 'FGS'+ElemSep
     +'P'+AllTrim(IntToStr(PNo))+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildDtlN1550(RetNo:Integer;Sin:String);
Var Rec:String;
begin
 Rec:= 'N1'+ElemSep
     +'2K'+ElemSep+ElemSep
     +'34'+ElemSep
     +Sin+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildDtlIN2570(RetNo:Integer;PFirstNm,PLastNm:String);
Var Rec:String;
begin
 If  AllTrim(PFirstNm) >'' then
 begin
  Rec:= 'IN2'+ElemSep
      +'02'+ElemSep
      +AllTrim(PFirstNm)+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 If  AllTrim(PLastNm) >'' then
 begin
  Rec:= 'IN2'+ElemSep
      +'05'+ElemSep
      +AllTrim(PLastNm)+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
end;

Procedure TEfileFrm.BuildDtlTIA600(RetNo:Integer;PPerCent:String);
Var Rec:String;
begin
 Rec:= 'TIA'+ElemSep
     +'POP'+ElemSep
     +ElemSep+ElemSep+ElemSep+ElemSep
     +PPercent+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure TEfileFrm.BuildDtlFGS740(RetNo:Integer);
Var Rec:String;
Begin
 Rec:= 'FGS'+ElemSep
     +'F2'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;


Procedure TEfileFrm.BuildDtlTIA820(RetNo:Integer;LLineString:String;s:String);
Var Rec:String;
begin
  Rec:= 'TIA'+ElemSep
       +LLineString+ElemSep
       +S+LineSep  {3}
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;

procedure TEfileFrm.Panel1Click(Sender: TObject);
 Var h:THandle;
begin
 {
 If MessageDlg('Any update downloaded from the Internet such as T1UPDxxx'+Chr(13)+
   'should be applied after you exit the program'+Chr(13)+
   'i.e. find it with your Windows Explorer and double click on it'+
   Chr(13)+
   'Ensure that the item Work Offline of your Browser is unchecked'+
   Chr(13)+'Proceed?', mtInformation, [mbYes, mbNo], 0) = mrYes then
  }
 begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(MainForm.Handle,'open','HTTP://www.NetFile.GC.CA',Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
 end;
end;

procedure TEfileFrm.WorldButtonClick(Sender: TObject);
begin
TransmitBtnClick(Sender);
end;

procedure TEfileFrm.Label5Click(Sender: TObject);
begin
TransmitBtnClick(Sender);
end;

Procedure TEfileFrm.BuildGE(RetNo:Integer);
Var Rec:String;
begin
(*
 Rec:= 'GE'+ElemSep
     +'1'+ElemSep
     +GetSinNo(RetNo)+LineSep
     +Crlf;
 Write(F1,Rec);
*)
end;

Procedure TEfileFrm.BuildIEA(RetNo:Integer);
Var Rec:String;
begin
(*
 Rec:= 'IEA'+ElemSep
     +'1'+ElemSep
     +GetSinNo(RetNo)+LineSep
     +Crlf;
 Write(F1,Rec);
 *)
end;

procedure TEfileFrm.DoAllBtnClick(Sender: TObject);
begin
{
If RetNo>0 then
begin
 ShowMessage('Please close all returns first');
 Exit;
end;
}
DataDirBox.Text := CfgRec.Dir_Cur;
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
DoAll;

end;

procedure TEfileFrm.DoAll;
var i:integer;
TmpList :TstringList;
FileNm,s:string;
begin
end;


procedure TEfileFrm.BuildBtnClick(Sender: TObject);
Var FileNm:String;
begin
 FileNm := FileNameBox.Text;
 CreateFile(FileNm,GetProdOrTest,'P');
 ShowMessage('Done');
end;

end.
