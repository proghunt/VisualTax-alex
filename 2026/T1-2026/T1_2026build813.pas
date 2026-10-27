unit T1_2026build813;
//updated 07-18

// creates a *.TED or *.tax file
{
 ISA
 GS
   ST

   SE

   ST


   SE

 GE
 IEA
}


interface

uses Windows,Messages,SysUtils,Classes,Controls,Forms,Dialogs,StdCtrls,ExtCtrls,
  FileCtrl,T1_2026Declare;

Const ElemSep = '*';
      LineSep = EfDelim;
      GenericAgent = 'B6671';  //for efile on-line only
     //20231221  SoftReleaseDate='20231221'; //20231221'20210220';//20220513
      SoftReleaseDateEOL=EfileSoftReleaseDate; //'20110327';
      SoftReleaseDateNetFile=EfileSoftReleaseDate;//20231221 //'20110327'; //'20110215';
    Function  GetNumberOfBarCodesfds(RetNo:Integer):Integer; //20231221
    Procedure ClearPartnersInfo;
    Function GetMinutesAndSeconds:String;
    Function GetISACtrlNo:String;
    Function GetGroupCtrlNo:String;


    Function GetNumberOfSFDs(RetNo:Integer):Integer;
    Function GetNumberOfSFDsForBarcode(RetNo:Integer):Integer;  //20210218

    Function CanItBeNetfiled(RetNo:Integer):Boolean;
    procedure CreateFile(RetNo:Integer;EolTaxFlName:String;TedFlName:String;POrT:String;FlType:String;FirstLast:String;OnLineMethod:String;DcnSeqNo:String);
    Procedure  BuildISA(RetNo:Integer;PorT:String;OnLineMethod:String);
    Procedure  BuildGS(RetNo:Integer;OnLineMethod:String);
    Procedure BuildPswRef(RetNo:Integer;OnLineMethod:String);  //eol only
    Procedure BuildHdrST010(RetNo:Integer);
    Procedure  BuildHdrBTI020(RetNo:Integer;OnLineMethod:String;DCNSeqNo:String);
    Procedure BuildHdrDTMBirthDate(RetNo:Integer);
    Procedure BuildHdrDTM030(RetNo:Integer;OnlineMethod:String);
    Procedure BuildHdrTIA040(RetNo:Integer);
    Procedure BuildHdr2TIA(RetNo:Integer);
    Procedure BuildHdrREF043(RetNo:Integer;OnLineMethod:String;TedFlName:String);
    Procedure BuildHdrN1050(RetNo:Integer);
    Procedure BuildHdrN2City(RetNo:Integer);
    Procedure BuildHdrN3Street(RetNo:Integer);
    Procedure BuildHdrIN2LastName(RetNo:Integer);
    Procedure BuildHdrIN2FirstName(RetNo:Integer);
    Procedure BuildHdrN4090(RetNo:Integer);
    Procedure BuildHdrPER100(RetNo:Integer);

    Procedure BuildDtlTFS010(RetNo:Integer);
    Procedure BuildDtlFGS100(RetNo:Integer);
    Procedure BuildDtlDTM120(RetNo:Integer);
    Procedure BuildDtlN1130(RetNo:Integer);
    Procedure BuildDtlTIA180(RetNo:Integer);
    Procedure BuildDtlFGS210(RetNo:Integer);
    Procedure BuildDtlTIA290(RetNo:Integer);

    {Sfd routines}
    Procedure BuildSfds(RetNo:Integer);
    Procedure BuildDtlTFS320(RetNo:Integer);
    Procedure BuildDtlFGS410(RetNo:Integer);
    Procedure BuildDtlFGS420(RetNo:Integer;GT,IJ,M8,M9:String);
    Procedure BuildDtlDTM430(RetNo:Integer;D1,D2:String);
    Procedure BuildDtlN1440(RetNo:Integer;BusName:String);
    Procedure BuildDtlN3470(RetNo:Integer;BusAddress,BusPostal:String);
    Procedure BuildDtlTIA490(RetNo:Integer;ACM,BTC,FYB,PSB,TAF,TAO:String);


    Procedure  BuildDtlFGS850(RetNo:Integer); //fgs pp

    Procedure  BuildDtlTFS900(RetNo:Integer);
    Procedure  BuildDtlFGS990(RetNo:Integer);
    Procedure  BuildDtlTIA1020forT777(RetNo:Integer);
    Procedure  BuildDtlTIA1020forTL2(RetNo:Integer);
    Procedure  BuildDtlFGS1100(RetNo:Integer);

    Procedure BuildSE(RetNo:Integer);
    Procedure BuildGE(RetNo:Integer;OnLineMethod:String);

    Procedure  BuildIEA(RetNo:Integer;OnLineMethod:String);

    Procedure BuildRental(RetNo:Integer;FInst:String);
    Procedure BuildT777(RetNo:Integer;FInst:String);
  //  Procedure BuildT777S(RetNo:Integer;FInst:String); //20210220
    Procedure BuildTL2(RetNo:Integer;FInst:String);
    Procedure BuildBusiness(RetNo:Integer;FInst:String);
    Procedure BuildFarming(RetNo:Integer;FInst:String);
    Procedure BuildT1163(RetNo:Integer;FInst:String);
    Procedure BuildNISAProfile(RetNo:Integer;FName:String);
    Procedure BuildT1273Profile(RetNo:Integer;FName:String);
    Procedure BuildT1273LikeNisa(RetNo:Integer;FInst:String);
    Procedure BuildT1273Additional(RetNo:Integer;FInst:String);
    Procedure BuildFishing(RetNo:Integer;FInst:String);
    Procedure BuildDtlFGS520(RetNo:Integer;PNo:Integer);
    Procedure BuildDtlN1550(RetNo:Integer;Sin:String);
    Procedure BuildDtlIN2570(RetNo:Integer;PFirstNm,PLastNm:String);
    Procedure BuildDtlTIA600(RetNo:Integer;PPerCent:String);
    Procedure BuildDtlFGS740(RetNo:Integer);
    Procedure BuildDtlTIA820(RetNo:Integer;LLineString:String;s:String);
    Procedure BuildDtlTIA1180(RetNo:Integer;LLineString:String;s:String);

   // Procedure BuildDtlTIA1490(RetNo:Integer;FInst:String);
    Function  Format1273Numerics(s:String;DecimalPlaces:Integer):String;
    Function BuildCrop(RetNo:Integer;Fno:Integer;FromElm,ToElm,byElm:Integer;k:Integer):Integer;
    Function BuildLiveStock(RetNo:Integer;Fno:Integer;FromElm,ToElm,byElm:Integer;k:Integer):Integer;
    Procedure BuildAdditionalLivestock(RetNo:Integer;FNo:Integer;Line:String;valu:String);
    Procedure BuildT1273ALI(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer);
    Function BuildT1273PI(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer):Integer;
    Function BuildT1273DI(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer):Integer;
    Function BuildT1273AP(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer):Integer;

    Function FGSHasData(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer):Boolean;

 var
  OnLineNo,PassWord,FileName,Url,Refund:String;  //to be used by the uhtmlEfOnline
  DcnNo:Integer;
  F1:TextFile;
  SfdNo : Integer;
  EFlines  : TStringList;
  CrLf  :String;
  SegmentCnt:Integer;
  GroupCtrlNo:String;
  ISACtrlNo : String;
  NetFileDir:String;
  TxSetCnt:Integer;
  
implementation

uses vtMulti,vtCommon,T1_2026,T1_2026Trimstr,T1_2026T1rtns,T1_2026Calc,
  T1_2026T1Rtns2,T1_2026RTU,T1_2026HtmlEol,T1_2026EolP,vtTrimStr,vtShared;

procedure CreateFile(RetNo:Integer;EolTaxFlName:String;TedFlName:String;POrT:String;FlType:String;FirstLast:String;OnLineMethod:String;DcnSeqNo:String);
Var Rec:String;
begin
 If CanItBeNetFiled(RetNo) = False then exit;
 If OnlineMethod = 'EOL' then GetEOLParms(OnlineNo,Password,Url,NetFileDir);

 SegmentCnt :=0;
 If ((OnlineMethod = 'EOLP') and (FirstLast='F'))
 or (FirstLast='B')
 or (OnlineMethod = 'EOL') then
 begin
  ISACtrlNo  :=GetISACtrlNo;
  GroupCtrlNo:=GetGroupCtrlNo;
  TxSetCnt :=0;
 end;

 If FlType = 'T' then
   crlf:=Chr(13)+Chr(10)
 else
   CrLf  :='';

 AssignFile(F1,EolTaxFlName);
 Rewrite(F1);

 If (OnlineMethod = 'EOL') then
 begin
  BuildISA(RetNo,POrT,OnLineMethod);
  BuildGS(RetNo,OnLineMethod);
 end;

 If ((OnlineMethod = 'EOLP') and (FirstLast = 'F'))
 Or (FirstLast = 'B')
 then
 begin
  BuildISA(RetNo,POrT,OnLineMethod);
  BuildGS(RetNo,OnLineMethod);
 end;

 BuildHdrST010(RetNo);
 BuildHdrBTI020(RetNo,OnlineMethod,DcnSeqNo);
 BuildHdrDTMBirthDate(RetNo);
 BuildHdrDTM030(RetNo,OnlineMethod);
 BuildHdrTIA040(RetNo);
 BuildHdr2TIA(RetNo);
 BUILDPSWREF(RetNo,OnLineMethod);   //eol only
 BuildHdrREF043(RetNo,OnlineMethod,TedFlName);
 BuildHdrN1050(RetNo);
 BuildHdrN2City(RetNo);
 BuildHdrIN2LastName(RetNo);
 BuildHdrIN2FirstName(RetNo);
 BuildHdrN3Street(RetNo);
 BuildHdrN4090(RetNo);
 BuildHdrPER100(RetNo);

 BuildDtlTFS010(RetNo);
 BuildDtlFGS100(RetNo);
 BuildDtlDTM120(RetNo);
 BuildDtlN1130(RetNo);
 BuildDtlTIA180(RetNo);
 BuildDtlFGS210(RetNo);
 BuildDtlTIA290(RetNo);

 {SFD}
 BuildSfds(RetNo);

 {Trailing}
 BuildSE(RetNo);

 If (OnlineMethod = 'EOL')
 or ((OnlineMethod = 'EOLP') and (FirstLast = 'L'))
 Or (FirstLast = 'B')
 then
 begin
  BuildGE(RetNo,OnLineMethod);
  BuildIEA(RetNo,OnLineMethod);
 end;
 CloseFile(F1);
end;


Function  GetProdOrTest:String;
begin
 Result:='P';
 // Result :='T';
end;


Function GetNumberOfSFDs(RetNo:Integer):Integer;
Var RentSfds,BusSfds,ProfSfds,FarmSfds,FishSfds,NisaSfds,HCaisSfds,T777Sfds,TL2Sfds,T2091Sfds,T1255Sfds:Integer;  //2-210123
begin
 RentSfds:=0;BusSfds:=0;ProfSfds:=0;FarmSfds:=0;FishSfds:=0;NISASfds:=0;HCaisSfds:=0;
 T777Sfds:=0;Tl2Sfds:=0;T2091Sfds:=0;
 CountSfds(RetNo,RentSfds,BusSfds,ProfSfds,FarmSfds,FishSfds,NisaSfds,HCaisSfds,T777Sfds,TL2Sfds,T2091Sfds,T1255Sfds); //20180304
 Result := RentSfds+BusSfds+ProfSfds+FarmSfds+FishSfds+NisaSfds+HCaisSfds+T777Sfds+TL2Sfds+T2091Sfds;
 If IsPreBankruptcyReturn(RetNo) then result:=0;
end;

Function  GetNumberOfSFDsForBarcode(RetNo:Integer):Integer;  //20210218
Var RentSfds,BusSfds,ProfSfds,FarmSfds,FishSfds,NisaSfds,HCaisSfds,T777Sfds,TL2Sfds,T2091Sfds,T1255Sfds:Integer;
begin
 RentSfds:=0;BusSfds:=0;ProfSfds:=0;FarmSfds:=0;FishSfds:=0;NISASfds:=0;HCaisSfds:=0;
 T777Sfds:=0;Tl2Sfds:=0;
 T2091Sfds:=0; //20180115
 T1255Sfds:=0; //20180304
 //T777sSfds:=0;
 CountSfdsForBarCode(RetNo,RentSfds,BusSfds,ProfSfds,FarmSfds,FishSfds,NisaSfds,HCaisSfds,T777Sfds,TL2Sfds,T2091Sfds,T1255Sfds); //20210218
 Result := RentSfds+BusSfds+ProfSfds+FarmSfds+FishSfds+NisaSfds+HCaisSfds+T777Sfds+TL2Sfds+T2091Sfds+T1255Sfds;  //20240120
 If IsPreBankruptcyReturn(RetNo) then result:=0;
end;


Function  CanItBeNetfiled(RetNo:Integer):Boolean;
begin
 IF GetNumberOfSfds(RetNo) > 6 THEN
 begin
  Result := False;
  ShowMessage('More than 6 SFDs in return'
               +Chr(13)+'Including Self Employment, T777 and TL2'
               +Chr(13)+'for taxpayer: '+GetFirstName(RetNo)+' '+GetLastName(RetNo)
               +Chr(13)+'It will be rejected by EFile');
  exit;
 end;
  UndefMsg('CanItBeNetfiled');
  Result := True; //???
end;

Procedure  BuildISA(RetNo:Integer;PorT:String;OnLineMethod:String);
Var Rec:String;Dt:String;Tm:String;
   ISA01,ISA02,ISA06,ISA08,ISA13:String;
begin
 If OnlineMethod='EOLP' then
 begin
   ISA01:='00';
   ISA02:=Space(10);
   ISA06:=TransmitterNo+Space(10);
   //ISA08:= 'CCRAADRCPR';   //production
   If PorT='P' then
     ISA08:= 'CCRAADRCPR'   //production
   else
     ISA08:='CCRAADRCTR'; //test   CCRAADRCTR
   ISA13 := ISACtrlNo;
 end
 else
 begin
   ISA01:='03';
   ISA02:=NetSoftCode+Space(6);
   ISA06:=GenericAgent+Space(10);
   ISA08:= 'CCRAADRCPR';
   ISA13 := GetSinNo(RetNo);
 end;
 Dt := FormatDateTime('yyyy-mm-dd',Now);
 Dt := MidStr(Dt,3,2)+MidStr(Dt,6,2)+RightStr(Dt,2);
 Tm:=GetTheTime(Now);
 Rec:= 'ISA'+ElemSep
     +ISA01+ElemSep        {1}
     +ISA02+ElemSep  {2}
     +'00'+ElemSep                  {3}
     +Space(10)+ElemSep             {4}
     +'ZZ'+ElemSep                  {5}
     +ISA06+ElemSep     {6}
     +'ZZ'+ElemSep                  {7}
     +ISA08+Space(5)+ElemSep  {8}
     +Dt+ElemSep             {9}
     +Tm+ElemSep               {10}
     +'U'+ElemSep               {11}
     +'00401'+ElemSep               {12}
     +ISA13+ElemSep       {13}
     +'0'+ElemSep       {14}
     +GetProdOrTest+ElemSep                   {15}
     +'~'+LineSep              {16}
     +Crlf;
  Write(F1,Rec);
end;

Procedure  BuildGS(RetNo:Integer;OnLineMethod:String);
Var Rec:String;
    GS02:String;
    GS03:String;
    GS06:String;
begin
 If OnlineMethod='EOLP' then
 begin
   GS02:=TransmitterNo;
   GS03:='CCRAT1EFL';
   GS06:= GroupCtrlNo;
 end
 else
 begin
   GS02:=GenericAgent;
   GS03:='GCRCNETFILE';
   GS06:=GetSinNo(RetNo);
 end;

 Rec:= 'GS'+ElemSep
     +'TF'+ElemSep        {1}
     +GS02+ElemSep  {2}
     +GS03+ElemSep                  {3}
     +RemoveChar(DateToYYYYMMDD(Now),'/')+ElemSep             {4}
     +'1331'+ElemSep                  {5}
     +GS06+ElemSep     {6}
     +'X'+ElemSep                  {7}
     +'004010'+LineSep              {8}
     +Crlf;
   Write(F1,Rec);
end;

Procedure  BuildHdrST010(RetNo:Integer);
Var Rec:String;StCtrlNo:String;
begin
 TxSetCnt:=TxSetCnt+1;
 StCtrlNo:=AddLeadingZeros(AllTrim(IntToStr(TxSetCnt)),4);

 Rec:= 'ST'+ElemSep
     +'813'+ElemSep        {1}
     +StCtrlNo+LineSep       {2}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;

Procedure  BuildHdrBTI020(RetNo:Integer;OnLineMethod:String;DCNSeqNo:String);
Var Rec:String;
  BTI07,BTI08,BTI10,BTI12:string;
begin
 BTI07:='';
 BTI08:='';
 BTI10:='';
 BTI12:=NetSoftCode;
 If OnlineMethod='EOLP' then
 begin
  BTI07:='45';
  BTI08:= DcnSeqNo;
  BTI10:=TransmitterNo;
 end
 else
 begin
  BTI07:='45';
  BTI08:=DcnSeqNo;
  BTI10:=OnLineNo; //it should be TransmitterNo in 2003; //GenericAgent;
 end;

 If isHomeUse then begin BTI07:='';BTI08:='';end;

 Rec:= 'BTI'+ElemSep
     +'T6'+ElemSep        {1}
     +'T1'+ElemSep  {2}
     +'47'+ElemSep                  {3}
     +'RCCET'+ElemSep             {4}
     +RemoveChar(DateToYYYYMMDD(Now),'/')+ElemSep {5}
     +ElemSep  //6
     +BTI07+ElemSep       //7
     +BTI08+ElemSep       //8
     +'46'+ElemSep        //9
     +BTI10+ElemSep          //10
     +'94'+ElemSep             //11
     +BTI12+LineSep      //12
     +Crlf;

 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildHdrDTMBirthDate(RetNo:Integer);
Var Rec:String;
begin
 If IsHomeUse then Exit;
 Rec:= 'DTM'+ElemSep
     +'222'+ElemSep        {1}
     +RemoveChar(FetchElm(RetNo,'INFO',9),'-')+LineSep {2}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;

Procedure  BuildHdrDTM030(RetNo:Integer;OnlineMethod:String);
Var Rec:String;SoftDate:String;
begin
 //20090128
 If OnlineMethod = 'EOL' THEN
  SoftDate:=EfileSoftReleaseDate //20231221 SoftReleaseDateEOL
 else
  SoftDate:=EfileSoftReleaseDate;

 If IsHomeUse then SoftDate:=SoftReleaseDateNetFile;

 Rec:= 'DTM'+ElemSep
     +'168'+ElemSep        {1}
     +SoftDate+LineSep {2}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;

Procedure  BuildHdrTIA040(RetNo:Integer);
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

Procedure  BuildHdr2TIA(RetNo:Integer);
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

Procedure  BuildHdrN1050(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'N1'+ElemSep
     +'TP'+ElemSep        {1}
     +ElemSep          {2}
     +'34'+ElemSep           {3}
     +GetSinNo(RetNo)+LineSep    {4}
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;


Procedure  BuildHdrIN2FirstName(RetNo:Integer);
Var Rec:String;
begin
 If IsHomeUse then Exit;
 Rec:= 'IN2'+ElemSep
     +'02'+ElemSep
     +UpperCase(FetchElm(RetNo,'INFO',2))  {firstname}
     +LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildHdrIN2LastName(RetNo:Integer);
Var Rec:String;
begin
 If IsHomeUse then Exit;
 Rec:= 'IN2'+ElemSep
     +'05'+ElemSep
     +UpperCase(FetchElm(RetNo,'INFO',5))  {lastName}
     +LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildHdrN2City(RetNo:Integer);
Var Rec:String;
begin
If IsHomeUse then Exit;
 Rec:= 'N2'+ElemSep
     +UpperCase(FetchElm(RetNo,'INFO',10))  {lastName}
     +LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildHdrN3Street(RetNo:Integer);
Var Rec:String;S,Str1,Str2:String;coLine:String;
begin
 If IsHomeUse then Exit;
 S:=AllTrim(GetStreet(RetNo));
 Str1:=AllTrim(Leftstr(S,30));
 If Length(S) > 30 then Str2:=AllTrim(MidStr(S,31,30)) else Str2:='';
 CoLine:=UpperCase(FetchElm(RetNo,'INFO',8));
 If CoLine='' then
 begin
  Rec:= 'N3'+ElemSep
      +Str1
      +LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end
 else
 begin
  Rec:= 'N3'+ElemSep
      +Str1+ElemSep+CoLine
      +LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 If Str2>'' then
 begin
   Rec:= 'N3'+ElemSep
       +Str2
       +LineSep
       +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

end;


Procedure  BuildHdrN4090(RetNo:Integer);
Var Rec:String;
begin
  If IsHomeUse then
  begin
    Rec:= 'N4'+ElemSep
      +ElemSep
      +ElemSep
      +ElemSep+ElemSep+'TX'+ElemSep           {5}
      +Ret[RetNo].Province+LineSep    {6}
      +Crlf;
    Write(F1,Rec);
    Inc(SegmentCnt);
    exit;
  end;

  Rec:= 'N4'+ElemSep
      +ElemSep
      +FetchElm(RetNo,'INFO',14)
      +ElemSep+RemoveChar(FetchElm(RetNo,'INFO',15),' ')    {postal}
      +ElemSep+ElemSep+'TX'+ElemSep           {5}
      +Ret[RetNo].Province+LineSep    {6}
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;

Procedure  BuildHdrPER100(RetNo:Integer);
Var Tel:String;Rec:String;
begin
 Tel := FetchElm(RetNo,'T1',441)
        +RemoveChar(FetchElm(RetNo,'T1',442),'-');
 Tel := RemoveChar(Tel,' ');
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


Procedure  BuildHdrREF043(RetNo:Integer;OnLineMethod:String;TedFlName:String);
Var Rec:String;PresentPrv:String;
begin

 If OnlineMethod = 'EOLP' then  //first resource fld
 begin
  Rec:= 'REF'+ElemSep
      +'IP'+ElemSep   //1
      + 'ABCDEFGHIJKLMNO'+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;


 If OnlineMethod = 'EOLP' then  //first resource fld
 begin
  Rec:= 'REF'+ElemSep
      +'BT'+ElemSep   //1
      + LeftStr(TedFlName,8)+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 If OnlineMethod = 'EOLP' then  //second resource fld
 begin
  If User.UserName > '' then //20170112 Igor
  begin
    Rec:= 'REF'+ElemSep
        +'FN'+ElemSep   //1
        + User.UserName+LineSep //20170112 Igor
        +Crlf;
    Write(F1,Rec);
    Inc(SegmentCnt);
  end;
 end;

 If IsReturnDiscounted(RetNo) then
 begin
  Rec:= 'REF'+ElemSep
      +'NM'+ElemSep //1
      + OptRec.Prp_DiscNo+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 If GetFirstNationNumber(RetNo) >'' then
 begin
  Rec:= 'REF'+ElemSep
      +'U1'+ElemSep {}
      +GetFirstNationNumber(RetNo)+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 If OnlineMethod = 'EOLP' then
 begin
  Rec:= 'REF'+ElemSep
      +'VU'+ElemSep   //1
      + Password+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 PresentPrv := FetchElm(RetNo,'INFO',66);
 If PresentPrv>'' then
 begin
   Rec:= 'REF'+ElemSep
      +'ZZ'+ElemSep
      +ElemSep
      +PresentPrv+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

end;


Procedure  BuildDtlTFS010(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'TFS'+ElemSep
     +'T6'+ElemSep           {1}
     +'DTR'+LineSep    {4}
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildDtlFGS100(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'FGS'+ElemSep
     +'FX'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildDtlDTM120(RetNo:Integer);
Var Rec:String;
begin
 If IsHomeUse then exit;

 If FetchElm(RetNo,'T183',27)>'' then
 begin
  Rec:= 'DTM'+ElemSep
      +'197'+ElemSep        {1}
      + RemoveChar(FetchElm(RetNo,'T183',27),'-')+LineSep {2}
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;


 //If IsDeceased(RetNo) then
 If FetchElm(RetNo,'INFO',24)>'' then   //20100420
 begin
  Rec:= 'DTM'+ElemSep
      +'442'+ElemSep        {1}
      + RemoveChar(FetchElm(RetNo,'INFO',24),'-')+LineSep {2}
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;


end;


Procedure  BuildDtlN1130(RetNo:Integer);
Var Rec,SpouseSIN,SpouseFirstNm:String;
begin
 SpouseSIN   := FetchElm(RetNo,'INFO',4); //20090310
 If Ret[RetNo].MarStatus > 2 then
 begin
  If spouseSin='' then Exit;
 end;
 SpouseFirstNm:=UpperCase(LeftStr(FetchElm(RetNo,'INFO',20),4));
 //SpouseSIN   := FetchElm(RetNo,'INFO',4);
 if SpouseFirstNm+SpouseSin>'' then
 begin
  IF SpouseSIN ='' THEN SpouseSIN:='000000000';
  Rec:= 'N1'+ElemSep
      +'SY'+ElemSep
      +SpouseFirstNm+ElemSep
      +'34'+ElemSep
      +SpouseSin+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
end;


Procedure  BuildDtlFGS210(RetNo:Integer);
Var Rec:String;
begin
 Rec:= 'FGS'+ElemSep
     +'FF'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildDtlTIA290(RetNo:Integer);
Var Rec:String; i, Rule, LLine,ElmNo:integer;
   LType, FName,S,LLineString:String;
   EFlines:TstringList;
begin
  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+GetEfileDname(RetNo)); //'EFLINE.D');

  For i := 0 to Eflines.Count - 1 do
  begin
    LLine := MyStrToInt(AllTrim(LeftStr(Eflines[i],4)));

  //  if lline=58340 then Showmessage('58340'); //20220419

    LType := UpperCase(MidStr(Eflines[i],5,1));
    FName := AllTrim(MidStr(Eflines[i],7,9));
    ElmNo := MyStrToInt(AllTrim(MidStr(Eflines[i],17,3)));
    If MidStr(Eflines[i],21,1) = 'R' then
      Rule := MyStrToInt(AllTrim(MidStr(Eflines[i],22,4)))
    else
      Rule := 0;
    If (LLine>0) then
    //If ((LLine>0) and (ElmNo >0)) or ((LLine>0) and (Rule >0)) then //20191129
    begin
       S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
       If (LLine>0) and (LType='$') and (Vl(s) =0) then s:='';
       If (LLine>0) and (LType='C') and (Vl(s) =0) then s:='';
       (*
       {skip discounting}
       If (FName = 'RC71') then s:='';
       If LLine = 6509 then s:='';  {disc date}
       If (LLine = 490) and (s='3') then s:='1';  {preparer code/no discounter}
       *)
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
end;

Procedure  BuildDtlTIA180(RetNo:Integer);
Var Rec:String;Lang,GstYesNo,Election:String;KidsUnder19:String;
    SpouseNetInc,PostBankruptNetInc,SpouseUCCB,SpouseUCCBRepay,SSE,POMValue,FNCValue:String;  //NTF,LIL,
    AltAddr,ClAuthorize,ContactValue,NameChange,CanCitizen:String;
    PostBankNI:Real;
begin

 If FetchElm(RetNo,'INFO',104) >'' then ContactValue:='1'
  Else If FetchElm(RetNo,'INFO',105) >'' then ContactValue:='2'
  Else If FetchElm(RetNo,'INFO',106) >'' then ContactValue:='3';
  If IsHomeUse then ContactValue:='0';

 If FetchElm(RetNo,'INFO',133) >'' then POMValue:='1'
  Else If FetchElm(RetNo,'INFO',134) >'' then POMValue:='2'
  Else If FetchElm(RetNo,'INFO',135) >'' then POMValue:='3';
 If IsHomeUse then POMValue:='0';

 FNCValue:='';
 FncValue:=GetFncValue(RetNo);
 (*
 IF (Ret[RetNo].Province='NL') then
 begin
  If FetchElm(RetNo,'INFO',127) >'' then FNCValue:='1' else FNCValue:='0';
  If FetchElm(RetNo,'INFO',136) >'' then FNCValue:='2';
 end;

 If Ret[RetNo].Province='NT' then
 begin
  If FetchElm(RetNo,'INFO',90) >'' then FNCValue:='1'  else FNCValue:='0';
  If FetchElm(RetNo,'INFO',137) >'' then FNCValue:='2';
 end;
 If Ret[RetNo].Province='YT' then
 begin
  If FetchElm(RetNo,'INFO',132) >'' then FNCValue:='1' else FNCValue:='0';
  If FetchElm(RetNo,'INFO',138) >'' then FNCValue:='2';
 end;
 *)

 AltAddr := '00';
 If      FetchElm(RetNo,'INFO',95) > '' then AltAddr := '00'
 Else If FetchElm(RetNo,'INFO',96) > '' then AltAddr := '01'
 Else If FetchElm(RetNo,'INFO',97) > '' then AltAddr := '02'
 Else If FetchElm(RetNo,'INFO',98) > '' then AltAddr := '03'
 Else If FetchElm(RetNo,'INFO',99) > '' then AltAddr := '04';
 If IsHomeUse then AltAddr:='00';

 If (UpperCase(FetchElm(RetNo,'T183',25)) = 'Y')
   or (UpperCase(FetchElm(RetNo,'T183',25)) = 'X') then
   ClAuthorize := '1'
 else
   ClAuthorize := '0';


 If UpperCase(FetchElm(RetNo,'INFO',56)) > '' then  {changed name}
   NAMECHANGE := '2'
 else
   NAMECHANGE := '1';


 If FNCValue>'' then
 begin
   Rec:= 'TIA'+ElemSep+'FNC'+ElemSep+ElemSep+FncValue+LineSep+Crlf;
   Write(F1,rec);
   Inc(SegmentCnt);
 end;

 If IsHomeUse = false then // n/a to netfile
 begin
  Rec:= 'TIA'+ElemSep+'AAA'+ElemSep+ElemSep+AltAddr+LineSep+Crlf;
  Write(F1,rec);
  Inc(SegmentCnt);

  If ClAuthorize >'0' then
  begin
   Rec:= 'TIA'+ElemSep+'PPC'+ElemSep+ElemSep+ClAuthorize+LineSep+Crlf;
   Write(F1,rec);
   Inc(SegmentCnt);
  end;

  Rec:= 'TIA'+ElemSep+'PCM'+ElemSep+ElemSep+ContactValue+LineSep+Crlf;
  Write(F1,rec);
  Inc(SegmentCnt);

  Rec:= 'TIA'+ElemSep+'POM'+ElemSep+ElemSep+POMValue+LineSep+Crlf;
  Write(F1,rec);
  Inc(SegmentCnt);
 end;

 If NameChange > '1' then
 begin
   Rec:= 'TIA'+ElemSep+'SNC'+ElemSep+ElemSep+NameChange+LineSep+Crlf;
   Write(F1,rec);
   Inc(SegmentCnt);
 end;

 Rec:= 'TIA'+ElemSep+'MRS'+ElemSep+ElemSep+IntToStr(Ret[RetNo].MarStatus)+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 If (UpperCase(FetchElm(RetNo,'INFO',29)) = 'X') then
  GstYesNo := '1'
 else
  GstYesNo := '2';
 Rec:= 'TIA'+ElemSep+'GST'+ElemSep+ElemSep+GstYesNo+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 SSE:=FetchElm(RetNo,'INFO',36); {Spouse self empl}
 If SSE>'' then SSE:='1' else SSE:='0';
 Rec:= 'TIA'+ElemSep+'SSE'+ElemSep+ElemSep+SSE+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 If FetchElm(RetNo,'INFO',34) >'' then Lang := '1' else Lang := '2';
 Rec:= 'TIA'+ElemSep+'COR'+ElemSep+ElemSep+Lang+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 SpouseNetInc:=AllTrim(NoDecimal(FloatToStr(SpouseIncome(RetNo))));
 Rec:= 'TIA'+ElemSep+'SNI'+ElemSep+SpouseNetInc+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 SpouseUCCB:=AllTrim(NoDecimal(FloatToStr(GetSpouseUCCB(RetNo))));
 Rec:= 'TIA'+ElemSep+'UCB'+ElemSep+SpouseUCCB+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 SpouseUCCBRepay:=AllTrim(NoDecimal(FloatToStr(Vl(FetchElm(RetNo,'INFO',162)))));
 Rec:= 'TIA'+ElemSep+'UCR'+ElemSep+SpouseUCCBRepay+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 If UpperCase(FetchElm(RetNo,'INFO',164)) >'' then
    CanCitizen := '1'
 else
    CanCitizen := '2';
 Rec:= 'TIA'+ElemSep+'ECC'+ElemSep+ElemSep+CanCitizen+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 If UpperCase(FetchElm(RetNo,'INFO',43)) >'' then
    Election := '01'
 else
    Election := '02';
 Rec:= 'TIA'+ElemSep+'ECR'+ElemSep+ElemSep+Election+LineSep+Crlf;
 Write(F1,rec);
 Inc(SegmentCnt);

 If (IsDeceased(RetNo)) or (FetchElm(RetNo,'INFO',24) >'')then
 begin
  Rec:= 'TIA'+ElemSep+'RDP'+ElemSep+ElemSep+'1'+LineSep+Crlf;
  Write(F1,rec);
  Inc(SegmentCnt);
 end;

 If IsPreBankruptcyReturn(RetNo) then
 begin
  Rec:= 'TIA'+ElemSep+'CPR'+ElemSep+ElemSep+'1'+LineSep+Crlf;
  Write(F1,rec);
  Inc(SegmentCnt);

  PostBankNI:=Vl(FetchElm(RetNo,'BANKRPT',13));
  If PostBankNI >0 then
  begin
   PostBankruptNetInc:=AllTrim(NoDecimal(FloatToStr(PostBankNI)));
   Rec:= 'TIA'+ElemSep+'CPI'+ElemSep+PostBankruptNetInc+LineSep+Crlf;
   Write(F1,rec);
   Inc(SegmentCnt);
  end;
 end; //prebabkr

end;

Procedure  BuildSfds(RetNo:Integer);
Var i:Integer;Rec:String;  FInst:String;
begin
 If GetNumberOfSFDs(RetNo) <1 then exit;

 ClearPartnersInfo;
 SfdNo:=0;
 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If Ret[RetNo].FormHasData[Frec.FormName+Frec.FormInst] then    //20160813
   begin
     If (Frec.FormName = 'T776') and (Frec.FormInst>'') then
      begin
      Inc(SfdNo);
      ClearPartnersInfo;
      BuildRental(RetNo,Frec.FormInst);
      end
     Else If (Frec.FormName = 'T2125')  and (Frec.FormInst>'')  then
      begin Inc(SfdNo);ClearPartnersInfo;BuildBusiness(RetNo,Frec.FormInst);end
     Else If (Frec.FormName = 'T2042') and (Frec.FormInst>'')  then
      begin Inc(SfdNo);ClearPartnersInfo;BuildFarming(RetNo,Frec.FormInst);end
     Else If (Frec.FormName = 'T2121') and (Frec.FormInst>'')  then
      begin Inc(SfdNo);ClearPartnersInfo;BuildFishing(RetNo,Frec.FormInst);end

     Else If (Frec.FormName = 'T1163') and (Frec.FormInst>'')  then
      begin
      Inc(SfdNo);ClearPartnersInfo; BuildT1163(RetNo,Frec.FormInst);
      end

     Else If (Frec.FormName = 'T1273') and (Frec.FormInst>'')  then
      begin
      Inc(SfdNo);
      Finst:=Frec.FormInst;  //it loses it!
      ClearPartnersInfo;
      BuildT1273LikeNisa(RetNo,FInst); //(RetNo,Frec.FormInst);
      Inc(SfDNo);
      BuildT1273Additional(RetNo,FInst); //(RetNo,Frec.FormInst);
      end
      //SEquence: for t777 to be after T1273 the T777 form no must be higher than T1273
     Else If (Frec.FormName = 'T777') and (Frec.FormInst>'') then   //20210220
      begin Inc(SfdNo);ClearPartnersInfo;BuildT777(RetNo,Frec.FormInst);end

     {
     Else If (Frec.FormName = 'T777S') and (Frec.FormInst>'') then   //20210220
      begin Inc(SfdNo);ClearPartnersInfo;BuildT777S(RetNo,Frec.FormInst);end
     }
     Else If (Frec.FormName = 'TL2') and (Frec.FormInst>'')  then
      begin Inc(SfdNo);ClearPartnersInfo;BuildTL2(RetNo,Frec.FormInst);end
   end;
 end;
end;

Procedure  BuildSE(RetNo:Integer);
Var Rec:String;StCtrlNo:String;
begin
 StCtrlNo:=AddLeadingZeros(AllTrim(IntToStr(TxSetCnt)),4);
 Inc(SegmentCnt);
 Rec:= 'SE'+ElemSep
     +AllTrim(IntToStr(SegmentCnt))+ElemSep
     +StCtrlNo+LineSep
     +Crlf;
 Write(F1,Rec);
end;

Procedure  BuildRental(RetNo:Integer;FInst:String);
 Var I,LLine,ElmNo,Rule:integer;
   LType,FName,S : string;
begin
 If IsPreBankruptcyReturn(RetNo) then exit;
  SFD.RECTYPE:='03';
  SFD.PREPARERNO:=FX.PREPARERNO;
  SFD.SEQNO:=FX.SEQNO;
  SfdRecNumber:=SfdRecNumber+1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber),2);
  SFD.BUSTYPE := '1';
  SFD.BUSNAME:=FetchElm(RetNo,'T776'+FInst,109);  //20101209
  //If AllTrim(SFD.BUSNAME)='' then SFD.BUSNAME := GetFirstName(RetNo)+' '+GetLastName(RetNo);

  SFD.BUSADDRESS:= FetchElm(RetNo,'T776'+FInst,110);
  SFD.BUSPOSTAL:=  MTrim(FetchElm(RetNo,'T776'+FInst,111));
  SFD.BUSFISCSTART:=RemoveHyphens(FetchElm(RetNo,'T776'+FInst,3));
  SFD.BUSFISCEND :=RemoveHyphens(FetchElm(RetNo,'T776'+FInst,6));
  SFD.AcrOwned :='';
  SFD.AcrFarmed:='';

  If AllTrim(FetchElm(RetNo,'T776'+FInst,4))>'' THEN
    SFD.AccMethod:='1'
  ELSE
    SFD.AccMethod:='2';
  SFD.SIC:=FetchElm(RetNo,'T776'+FInst,19);
  SFD.SIN :=RemoveHyphens(FetchElm(RetNo,'INFO',3));
  SFD.BUSPARTNID:=FetchElm(RetNo,'T776'+FInst,11);
  SFD.BUSPERCENT:=FormatFourDigitPercent(FetchElm(RetNo,'T776'+FInst,18));
  SFD.BUSTAXSHELTNO:=FetchElm(RetNo,'T776'+FInst,13);
  If AllTrim(FetchElm(RetNo,'T776'+FInst,9))>'' THEN
    SFD.BUSFINALYR:='1'
  ELSE
    SFD.BUSFINALYR:='2';
  SFD.GSTACCNO :=FetchElm(RetNo,'T776'+FInst,15);
                 {
                 +
                 FetchElm(RetNo,'T776'+FInst,16)+
                 FetchElm(RetNo,'T776'+FInst,17);
                }

  i:=0;
  If Vl(FetchElm(RetNo,'T776'+FInst,24)) >0 then
  begin
   Inc(i);
   SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T776'+FInst,22),30);
   SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T776'+FInst,117),30);
   //20090123
   SFD.Prec[i].PSin       := '00000000';
   SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T776'+FInst,24));
  end;
  If Vl(FetchElm(RetNo,'T776'+FInst,28)) >0 then
  begin
  Inc(i);
  SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T776'+FInst,25),30);
  SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T776'+FInst,26),30);
  SFD.Prec[i].PSin       := '00000000';
  SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T776'+FInst,28));
  end;
  If Vl(FetchElm(RetNo,'T776'+FInst,32)) >0 then
  begin
  Inc(i);
  SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T776'+FInst,29),30);
  SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T776'+FInst,30),30);
  SFD.Prec[i].PSin       := '00000000';
  SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T776'+FInst,32));
  end;
  If Vl(FetchElm(RetNo,'T776'+FInst,36))>0 then
  begin
  Inc(i);
  SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T776'+FInst,33),30);
  SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T776'+FInst,34),30);
  SFD.Prec[i].PSin       := '00000000';
  SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T776'+FInst,36));
  end;
  If Vl(FetchElm(RetNo,'T776'+FInst,40))>0 then
  begin
  Inc(i);
  SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T776'+FInst,37),30);
  SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T776'+FInst,38),30);
  SFD.Prec[i].PSin       := '00000000';
  SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T776'+FInst,40));
  end;
  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFRLINE.D');

  {----}
 BuildDtlTFS320(RetNo);
 BuildDtlFGS410(RetNo);
 BuildDtlFGS420(RetNo,SFD.GSTACCNO,SFD.SIC,SFD.BUSPARTNID,SFD.BusTaxSheltNo);
 BuildDtlDTM430(RetNo,SFD.BUSFISCSTART,SFD.BUSFISCEND);
 BuildDtlN1440(RetNo,SFD.BusName);
 BuildDtlN3470(RetNo,SFD.BusAddress,SFD.BusPostal);

 BuildDtlTIA490(RetNo,SFD.AccMethod,SFD.BUSTYPE,SFD.BUSFINALYR,
                SFD.BUSPERCENT,SFD.AcrFarmed,SFD.AcrOwned);

 For i:= 1 to 5 do
 begin
  If SFD.PRec[i].PPerCent > '' then
  begin
   BuildDtlFGS520(RetNo,i);
   BuildDtlN1550(RetNo,SFD.PRec[i].PSin);
   BuildDtlIN2570(RetNo,SFD.PRec[i].PFirstName,SFD.PRec[i].PLastName);
   BuildDtlTIA600(RetNo,SFD.PRec[i].PPerCent);
   {630-710 is for NISA}
  end;
 end;
 {Free format SFD}
 BuildDtlFGS740(RetNo);  //fgs F2    
   {      12345678901234567890123
  {Format nnnn $ fffffffff elm rrr}
 For i := 0 to Eflines.Count - 1 do
 begin
    LLine := myStrToInt(LeftStr(Eflines[i],4));
    LType := MidStr(Eflines[i],6,1);
    FName := AllTrim(MidStr(Eflines[i],8,9))+FInst;
    ElmNo := myStrToInt(MidStr(Eflines[i],17,3));
    If MidStr(Eflines[i],22,3) = '' then
         Rule := 0
    else
      Rule := MyStrToInt(MidStr(Eflines[i],22,3));

    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If LLine = 9946 then
    begin
     If (s ='') and (Vl(FetchElm(RetNo,'T776'+FInst,56)) <>0) then s:='1';
    end;
    If S > '' then BuildDtlTIA820(RetNo,AllTrim(IntToStr(LLine)),s); 
 end;
 EFLines.Free;
end;

Procedure  BuildBusiness(RetNo:Integer;FInst:String);
 Var I,LLine,ElmNo,Rule:integer;
   LType, FName,S : string;
begin
 If IsPreBankruptcyReturn(RetNo) then exit;

  SFD.RECTYPE:='03';
  SFD.PREPARERNO:=FX.PREPARERNO;
  SFD.SEQNO:=FX.SEQNO;
  SfdRecNumber:=SfdRecNumber+1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber),2);
  If FetchElm(RetNo,'T2125'+FInst,82)>'' then
    SFD.BUSTYPE := '2'
  else If FetchElm(RetNo,'T2125'+FInst,90)>'' then
    SFD.BUSTYPE := '3';
  SFD.BUSNAME:=FetchElm(RetNo,'T2125'+FInst,8);
  If AllTrim(SFD.BUSNAME)='' then
    SFD.BUSNAME := GetFirstName(RetNo)+' '+GetLastName(RetNo);

  SFD.BUSADDRESS:=FetchElm(RetNo,'T2125'+FInst,10);
  SFD.BUSPOSTAL:=MTrim(FetchElm(RetNo,'T2125'+FInst,14));
  SFD.BUSFISCSTART:=RemoveHyphens(FetchElm(RetNo,'T2125'+FInst,4));
  SFD.BUSFISCEND :=RemoveHyphens(FetchElm(RetNo,'T2125'+FInst,5));
  SFD.AcrOwned :='';
  SFD.AcrFarmed:='';

  //20190201
  SFD.AccMethod:='1'; //accrual be default
  If AllTrim(FetchElm(RetNo,'T2125'+FInst,22))>'' THEN  SFD.AccMethod:='2';
  {
  If AllTrim(FetchElm(RetNo,'T2125'+FInst,11))>'' THEN
    SFD.AccMethod:='1'
  ELSE
    SFD.AccMethod:='2';
  }
  SFD.SIC:=FetchElm(RetNo,'T2125'+FInst,12);
  SFD.SIN :=RemoveHyphens(FetchElm(RetNo,'INFO',3));
  SFD.BUSPARTNID:=FetchElm(RetNo,'T2125'+FInst,15);
  SFD.BUSPERCENT:=FormatFourDigitPercent(FetchElm(RetNo,'T2125'+FInst,18));
  SFD.BUSTAXSHELTNO:=FetchElm(RetNo,'T2125'+FInst,16);
  If AllTrim(FetchElm(RetNo,'T2125'+FInst,6))>'' THEN
    SFD.BUSFINALYR:='1'
  ELSE
    SFD.BUSFINALYR:='2';
  SFD.GSTACCNO :=FetchElm(RetNo,'T2125'+FInst,19);
  i:=0;
  If Vl(FetchElm(RetNo,'T2125'+FInst,238))>0 then
  begin
  Inc(i);
  SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T2125'+FInst,257),30);
  SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T2125'+FInst,239),30);
  SFD.Prec[i].PSin       := '00000000';
  SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2125'+FInst,238));
  end;
  If Vl(FetchElm(RetNo,'T2125'+FInst,241))>0 then
  begin
  Inc(i);
  SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T2125'+FInst,258),30);
  SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T2125'+FInst,248),30);
  SFD.Prec[i].PSin       := '00000000';
  SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2125'+FInst,241));
  end;
  If Vl(FetchElm(RetNo,'T2125'+FInst,244))>0 then
  begin
  Inc(i);
  SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T2125'+FInst,259),30);
  SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T2125'+FInst,264),30);
  SFD.Prec[i].PSin       := '00000000';
  SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2125'+FInst,244));
  end;
  If Vl(FetchElm(RetNo,'T2125'+FInst,247))>0 then
  begin
  Inc(i);
  SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T2125'+FInst,260),30);
  SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T2125'+FInst,267),30);
  SFD.Prec[i].PSin       := '00000000';
  SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2125'+FInst,247));
  end;
  If Vl(FetchElm(RetNo,'T2125'+FInst,250))>0 then
  begin
  Inc(i);
  SFD.Prec[i].PFirstName := PaddR(FetchElm(RetNo,'T2125'+FInst,261),30);
  SFD.Prec[i].PLastName  := PaddR(FetchElm(RetNo,'T2125'+FInst,270),30);
  SFD.Prec[i].PSin       := '00000000';
  SFD.Prec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2125'+FInst,250));
  end;
  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFBLINE.D');

  {---common---}
 BuildDtlTFS320(RetNo);
 BuildDtlFGS410(RetNo);
 BuildDtlFGS420(RetNo,SFD.GSTACCNO,SFD.SIC,SFD.BUSPARTNID,SFD.BusTaxSheltNo);
 BuildDtlDTM430(RetNo,SFD.BUSFISCSTART,SFD.BUSFISCEND);
 BuildDtlN1440(RetNo,SFD.BusName);
 BuildDtlN3470(RetNo,SFD.BusAddress,SFD.BusPostal);
 BuildDtlTIA490(RetNo,SFD.AccMethod,SFD.BUSTYPE,SFD.BUSFINALYR,
                SFD.BUSPERCENT,SFD.AcrFarmed,SFD.AcrOwned);

 For i:= 1 to 5 do
 begin
  If SFD.PRec[i].PPerCent > '' then
  begin
   BuildDtlFGS520(RetNo,i);
   BuildDtlN1550(RetNo,SFD.PRec[i].PSin);
   BuildDtlIN2570(RetNo,SFD.PRec[i].PFirstName,SFD.PRec[i].PLastName);
   BuildDtlTIA600(RetNo,SFD.PRec[i].PPerCent);
   {630-710 is for NISA}
  end;
 end;
 {Free format SFD}
 BuildDtlFGS740(RetNo);
   {      12345678901234567890123
  {Format nnnn $ fffffffff elm rrr}
 For i := 0 to Eflines.Count - 1 do
 begin
    LLine := myStrToInt(LeftStr(Eflines[i],4));
    LType := MidStr(Eflines[i],6,1);
    FName := AllTrim(MidStr(Eflines[i],8,9))+FInst;
    ElmNo := myStrToInt(MidStr(Eflines[i],17,3));
    If MidStr(Eflines[i],22,3) = '' then
         Rule := 0
    else
      Rule := MyStrToInt(MidStr(Eflines[i],22,3));

    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If LLine = 9946 then
    begin
     If (s ='') and (Vl(FetchElm(RetNo,'T2125'+FInst,32)) <>0) then s:='1';
    end;
    If LLine = 9369 then
    begin
     If (s ='') and (Vl(FetchElm(RetNo,'T2125'+FInst,32)) <>0)
     and (FetchElm(RetNo,'T2125'+FInst,35)='')  //no t5013
     then s:='1';
    end;
    If S > '' then BuildDtlTIA820(RetNo,AllTrim(IntToStr(LLine)),s);  
 end;
 EFLines.Free;
end;

Procedure  BuildFarming(RetNo:Integer;FInst:String);
 Var I,LLine,ElmNo,Rule:integer;
   LType, FName,S : string;
begin
 If IsPreBankruptcyReturn(RetNo) then exit;
  SFD.RECTYPE:='03';
  SFD.PREPARERNO:=FX.PREPARERNO;
  SFD.SEQNO:=FX.SEQNO;
  SfdRecNumber:=SfdRecNumber+1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber),2);
  SFD.BUSTYPE := '5';
  SFD.BUSNAME:=FetchElm(RetNo,'T2042'+FInst,8);
  If AllTrim(SFD.BUSNAME)='' then
    SFD.BUSNAME := GetFirstName(RetNo)+' '+GetLastName(RetNo);

  SFD.BUSADDRESS:=FetchElm(RetNo,'T2042'+FInst,10);
  SFD.BUSPOSTAL:=MTrim(FetchElm(RetNo,'T2042'+FInst,13));
  SFD.BUSFISCSTART:=RemoveHyphens(FetchElm(RetNo,'T2042'+FInst,4));
  SFD.BUSFISCEND :=RemoveHyphens(FetchElm(RetNo,'T2042'+FInst,5));
  SFD.AcrOwned :=FetchElm(RetNo,'T2042'+FInst,9);
  SFD.AcrFarmed:=FetchElm(RetNo,'T2042'+FInst,11);
  If AllTrim(FetchElm(RetNo,'T2042'+FInst,15))>'' THEN
    SFD.AccMethod:='1'
  ELSE
    SFD.AccMethod:='2';
  SFD.SIC:=FetchElm(RetNo,'T2042'+FInst,17);
  SFD.SIN :=RemoveHyphens(FetchElm(RetNo,'INFO',3));
  SFD.BUSPARTNID:=FetchElm(RetNo,'T2042'+FInst,18);
  SFD.BUSPERCENT:=FormatFourDigitPercent(FetchElm(RetNo,'T2042'+FInst,24));
  SFD.BUSTAXSHELTNO:=FetchElm(RetNo,'T2042'+FInst,20);
  If AllTrim(FetchElm(RetNo,'T2042'+FInst,6))>'' THEN
    SFD.BUSFINALYR:='1'
  ELSE
    SFD.BUSFINALYR:='2';
  SFD.GSTACCNO :=FetchElm(RetNo,'T2042'+FInst,21);
  i:=0;
  If Vl(FetchElm(RetNo,'T2042'+FInst,642))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2042'+FInst,640),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2042'+FInst,664),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2042'+FInst,642));
  end;
  If Vl(FetchElm(RetNo,'T2042'+FInst,646))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2042'+FInst,644),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2042'+FInst,666),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2042'+FInst,646));
  end;
  If Vl(FetchElm(RetNo,'T2042'+FInst,650))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2042'+FInst,648),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2042'+FInst,668),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2042'+FInst,650));
  end;
  If Vl(FetchElm(RetNo,'T2042'+FInst,654))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2042'+FInst,652),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2042'+FInst,670),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2042'+FInst,654));
  end;

  If Vl(FetchElm(RetNo,'T2042'+FInst,658))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2042'+FInst,656),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2042'+FInst,672),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2042'+FInst,658));
  end;
  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFFLINE.D');


 {---common---}
 BuildDtlTFS320(RetNo);
 BuildDtlFGS410(RetNo);
 BuildDtlFGS420(RetNo,SFD.GSTACCNO,SFD.SIC,SFD.BUSPARTNID,SFD.BusTaxSheltNo);
 BuildDtlDTM430(RetNo,SFD.BUSFISCSTART,SFD.BUSFISCEND);
 BuildDtlN1440(RetNo,SFD.BusName);
 BuildDtlN3470(RetNo,SFD.BusAddress,SFD.BusPostal);
 BuildDtlTIA490(RetNo,SFD.AccMethod,SFD.BUSTYPE,SFD.BUSFINALYR,
                SFD.BUSPERCENT,SFD.AcrFarmed,SFD.AcrOwned);

 For i:= 1 to 5 do
 begin
  If SFD.PRec[i].PPerCent > '' then
  begin
   BuildDtlFGS520(RetNo,i);
   BuildDtlN1550(RetNo,SFD.PRec[i].PSin);
   BuildDtlIN2570(RetNo,SFD.PRec[i].PFirstName,SFD.PRec[i].PLastName);
   BuildDtlTIA600(RetNo,SFD.PRec[i].PPerCent);
   {630-710 is for NISA}
  end;
 end;
 {Free format SFD}
 BuildDtlFGS740(RetNo);
   {      12345678901234567890123
  {Format nnnn $ fffffffff elm rrr}
 For i := 0 to Eflines.Count - 1 do
 begin
    LLine := myStrToInt(LeftStr(Eflines[i],4));
    LType := MidStr(Eflines[i],6,1);
    FName := AllTrim(MidStr(Eflines[i],8,9))+FInst;
    ElmNo := myStrToInt(MidStr(Eflines[i],17,3));
    If MidStr(Eflines[i],22,3) = '' then
         Rule := 0
    else
      Rule := MyStrToInt(MidStr(Eflines[i],22,3));

    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If LLine = 9946 then
    begin
     If (s ='') and (Vl(FetchElm(RetNo,'T2042'+FInst,66)) <>0) then s:='1';
    end;

    If LLine = 9899 then
    begin
     If (s ='')
     and (Vl(FetchElm(RetNo,'T2042'+FInst,66)) <>0)
     and (Vl(FetchElm(RetNo,'T2042'+FInst,148)) =0)
     then s:='1';
    end;

    If LLine = 9946 then    {restricted farm loss}
      begin
       If (s >'') and (Vl(FetchElm(RetNo,'T2042'+FInst,150)) <>0) then
       begin
         s:=AllTrim(IntToStr(Round(Vl(FetchElm(RetNo,'T2042'+FInst,149)))));
       end;
    end;

    If S > '' then BuildDtlTIA820(RetNo,AllTrim(IntToStr(LLine)),s);
 end;
 EFLines.Free;
end;

Procedure  BuildT1163(RetNo:Integer;FInst:String);
 Var I,LLine,ElmNo,Rule,FNo:integer;
   LType, FName,S, cd,Rec:String;
begin
 If IsPreBankruptcyReturn(RetNo) then exit;
  SFD.RECTYPE:='03';
  SFD.PREPARERNO:=FX.PREPARERNO;
  SFD.SEQNO:=FX.SEQNO;
  SfdRecNumber:=SfdRecNumber+1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber),2);
  SFD.BUSTYPE := '6'; //done
  SFD.BUSNAME:=FetchElm(RetNo,'T1163'+FInst,201); //?

  SFD.BUSADDRESS:=FetchElm(RetNo,'T1163'+FInst,203);
  SFD.BUSPOSTAL:=MTrim(FetchElm(RetNo,'T1163'+FInst,206));
  SFD.BUSFISCSTART:=RemoveHyphens(FetchElm(RetNo,'T1163'+FInst,213));
  SFD.BUSFISCEND :=RemoveHyphens(FetchElm(RetNo,'T1163'+FInst,214));
  SFD.AcrOwned :=FetchElm(RetNo,'T1163'+FInst,217);
  SFD.AcrFarmed:=FetchElm(RetNo,'T1163'+FInst,219);
  //? rented
  SFD.AccMethod:=AllTrim(FetchElm(RetNo,'T1163'+FInst,212));

  SFD.SIC:=FetchElm(RetNo,'T1163'+FInst,34);
  SFD.BUSPARTNID:=FetchElm(RetNo,'T1163'+FInst,624);
  SFD.BUSPERCENT:=FormatFourDigitPercent(FetchElm(RetNo,'T1163'+FInst,210));
  If AllTrim(FetchElm(RetNo,'T1163'+FInst,27))>'' THEN
    SFD.BUSFINALYR:='1'
  ELSE
    SFD.BUSFINALYR:='2';

  SFD.GSTACCNO :='';  //20110520
  i:=0;
  If Vl(FetchElm(RetNo,'T1163'+FInst,632))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1163'+FInst,630),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1163'+FInst,631),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1163'+FInst,634),8);
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1163'+FInst,632));
  end;

  If Vl(FetchElm(RetNo,'T1163'+FInst,637))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1163'+FInst,635),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1163'+FInst,636),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1163'+FInst,639),8);
  //20100123
  If FetchElm(RetNo,'T1163'+FInst,648)>'' then
  begin
    SFD.PRec[i].PFirstName:='';
    SFD.PRec[i].PLastName  :=PaddR(FetchElm(RetNo,'T1163'+FInst,648),30);
  end;
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1163'+FInst,637));
  end;

  If Vl(FetchElm(RetNo,'T1163'+FInst,642))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1163'+FInst,640),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1163'+FInst,641),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1163'+FInst,644),8);
  //20100123
  If FetchElm(RetNo,'T1163'+FInst,653)>'' then
  begin
    SFD.PRec[i].PFirstName:='';
    SFD.PRec[i].PLastName  :=PaddR(FetchElm(RetNo,'T1163'+FInst,653),30);
  end;
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1163'+FInst,642));
  end;

  If Vl(FetchElm(RetNo,'T1163'+FInst,647))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1163'+FInst,645),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1163'+FInst,646),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1163'+FInst,649),8);
  //20100123
  If FetchElm(RetNo,'T1163'+FInst,658)>'' then
  begin
    SFD.PRec[i].PFirstName:='';
    SFD.PRec[i].PLastName  :=PaddR(FetchElm(RetNo,'T1163'+FInst,658),30);
  end;
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1163'+FInst,647));
  end;

  If Vl(FetchElm(RetNo,'T1163'+FInst,652))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1163'+FInst,650),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1163'+FInst,651),30);
  //20100123
  If FetchElm(RetNo,'T1163'+FInst,660)>'' then
  begin
    SFD.PRec[i].PFirstName:='';
    SFD.PRec[i].PLastName  :=PaddR(FetchElm(RetNo,'T1163'+FInst,660),30);
  end;
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1163'+FInst,654),8);
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1163'+FInst,652));
  end;

  If Vl(FetchElm(RetNo,'T1163'+FInst,657))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1163'+FInst,655),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1163'+FInst,656),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1163'+FInst,659),8);
  //20100123
  If FetchElm(RetNo,'T1163'+FInst,661)>'' then
  begin
    SFD.PRec[i].PFirstName:='';
    SFD.PRec[i].PLastName  :=PaddR(FetchElm(RetNo,'T1163'+FInst,661),30);
  end;
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1163'+FInst,657));
  end;

  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFNLINE.D');


 {---common---}
 BuildDtlTFS320(RetNo);
 BuildDtlFGS410(RetNo);
 BuildDtlFGS420(RetNo,SFD.GSTACCNO,SFD.SIC,SFD.BUSPARTNID,'');
   //last one is taxShelt No, not used in NISA
 BuildDtlDTM430(RetNo,SFD.BUSFISCSTART,SFD.BUSFISCEND);
 BuildDtlN1440(RetNo,SFD.BusName);
 BuildDtlN3470(RetNo,SFD.BusAddress,SFD.BusPostal);
 BuildDtlTIA490(RetNo,SFD.AccMethod,SFD.BUSTYPE,SFD.BUSFINALYR,
                SFD.BUSPERCENT,'',''); //last are acres TAF,TAO n/a in NISA

 For i:= 1 to 5 do
 begin
  If SFD.PRec[i].PPerCent > '' then
  begin
   BuildDtlFGS520(RetNo,i);
   BuildDtlN1550(RetNo,SFD.PRec[i].PSin);
   BuildDtlIN2570(RetNo,SFD.PRec[i].PFirstName,SFD.PRec[i].PLastName);
   BuildDtlTIA600(RetNo,SFD.PRec[i].PPerCent);
   {630-710 is for NISA}
  end;
 end;
 {Free format SFD}


 If Ret[RetNo].FormHasData['T1163#1'] then BuildNisaProfile(RetNo,'T1163#1');
 BuildDtlFGS740(RetNo);
   {      12345678901234567890123
  {Format nnnn $ fffffffff elm rrr}


 //9950 $ T1163  169
   FNo:=GetFormNo('T1163'+FInst);
   LLine := 9950;
   LType := '$';
   FName := 'T1163'+FInst;
   ElmNo := 305;
   Rule:=0;
   S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
   If S > '' then BuildDtlTIA820(RetNo,AddLeadingZeros(AllTrim(IntToStr(LLine)),3),s);

 //details Codes and amounts for 9950
 i:=219;
 FNo:=GetFormNo('T1163'+FInst);
 Repeat
    LLine := myStrToInt(FetchElmFNo(RetNo,FNo,i));
    LType := '$';
    FName := 'T1163'+FInst;
    ElmNo := i+1;
    Rule:=0;
    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If S > '' then BuildDtlTIA820(RetNo,AddLeadingZeros(AllTrim(IntToStr(LLine)),3),s);
  Inc(i,3);
 until i>303;

 // 9960 $ T1163  065
   FNo:=GetFormNo('T1163'+FInst);
   LLine := 9960;
   LType := '$';
   FName := 'T1163'+FInst;
   ElmNo := 458;
   Rule:=0;
   S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
   If S > '' then BuildDtlTIA820(RetNo,AddLeadingZeros(AllTrim(IntToStr(LLine)),3),s);

 i:=402;
 FNo:=GetFormNo('T1163'+FInst);
 Repeat
    LLine := myStrToInt(FetchElmFNo(RetNo,FNo,i));
    LType := '$';
    FName := 'T1163'+FInst;
    ElmNo := i+1;
    Rule:=0;
    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If S > '' then BuildDtlTIA820(RetNo,AddLeadingZeros(AllTrim(IntToStr(LLine)),3),s);
  Inc(i,3);
 until i>456;

 For i := 0 to Eflines.Count - 1 do
 begin
    LLine := myStrToInt(LeftStr(Eflines[i],4));
    LType := MidStr(Eflines[i],6,1);
    FName := AllTrim(MidStr(Eflines[i],8,9))+FInst;
    ElmNo := myStrToInt(MidStr(Eflines[i],17,3));
    If MidStr(Eflines[i],22,3) = '' then
         Rule := 0
    else
      Rule := MyStrToInt(MidStr(Eflines[i],22,3));

    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If LLine = 9946 then
    begin
     If (s ='') and (Vl(FetchElm(RetNo,'T1163'+FInst,352)) <>0) then s:='1';
    end;

    If LLine = 9946 then
    begin
     If (Vl(FetchElm(RetNo,'T1163'+FInst,676)) >0) //rest farm loss
     and (Vl(FetchElm(RetNo,'T1163'+FInst,616)) <0)  then
        s:=AllTrim(IntToStr(Round(Vl(FetchElm(RetNo,'T1163'+FInst,675)))));
    end;

    If LLine = 9969 then //ni before adj
    begin
     If (s ='') and (Vl(FetchElm(RetNo,'T1163'+FInst,601)) <>0)
     then s:='1';
    end;
    If S > '' then BuildDtlTIA820(RetNo,AllTrim(IntToStr(LLine)),s);
 end;
 EFLines.Free;
end;


Procedure  BuildFishing(RetNo:Integer;FInst:String);
 Var I,LLine,ElmNo,Rule:integer;
   LType, FName,S : string;
begin
 If IsPreBankruptcyReturn(RetNo) then exit;
  SFD.RECTYPE:='03';
  SFD.PREPARERNO:=FX.PREPARERNO;
  SFD.SEQNO:=FX.SEQNO;
  SfdRecNumber:=SfdRecNumber+1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber),2);
  SFD.BUSTYPE := '4';

  SFD.BUSNAME:=FetchElm(RetNo,'T2121'+FInst,8);  //20101209
 // If AllTrim(SFD.BUSNAME)='' then SFD.BUSNAME := GetFirstName(RetNo)+' '+GetLastName(RetNo); //20101209
  SFD.BUSADDRESS:='';
  SFD.BUSPOSTAL:='';

  SFD.BUSFISCSTART:=RemoveHyphens(FetchElm(RetNo,'T2121'+FInst,4));
  SFD.BUSFISCEND :=RemoveHyphens(FetchElm(RetNo,'T2121'+FInst,5));

  SFD.AcrOwned :='';
  SFD.AcrFarmed:='';

  If AllTrim(FetchElm(RetNo,'T2121'+FInst,19))>'' THEN
    SFD.AccMethod:='1'
  ELSE
    SFD.AccMethod:='2';
  SFD.SIC:=FetchElm(RetNo,'T2121'+FInst,11);
  SFD.SIN :=RemoveHyphens(FetchElm(RetNo,'INFO',3));
  SFD.BUSPARTNID:=FetchElm(RetNo,'T2121'+FInst,12);
  SFD.BUSPERCENT:=FormatFourDigitPercent(FetchElm(RetNo,'T2121'+FInst,18));
  SFD.BUSTAXSHELTNO:=FetchElm(RetNo,'T2121'+FInst,14);
  If AllTrim(FetchElm(RetNo,'T2121'+FInst,6))>'' THEN
    SFD.BUSFINALYR:='1'
  ELSE
    SFD.BUSFINALYR:='2';
  SFD.GSTACCNO :=FetchElm(RetNo,'T2121'+FInst,15);
                 (*
                 +
                 FetchElm(RetNo,'T2121'+FInst,16)+
                 FetchElm(RetNo,'T2121'+FInst,17);
                 *)
  i:=0;
  If Vl(FetchElm(RetNo,'T2121'+FInst,505))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2121'+FInst,503),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2121'+FInst,537),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2121'+FInst,505));
  end;
  If Vl(FetchElm(RetNo,'T2121'+FInst,509))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2121'+FInst,507),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2121'+FInst,539),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2121'+FInst,509));
  end;
  If Vl(FetchElm(RetNo,'T2121'+FInst,513))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2121'+FInst,511),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2121'+FInst,541),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2121'+FInst,513));
  end;
  if Vl(FetchElm(RetNo,'T2121'+FInst,517))>0 then  {?}
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2121'+FInst,515),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2121'+FInst,543),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2121'+FInst,517));
  end;

  If Vl(FetchElm(RetNo,'T2121'+FInst,521))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T2121'+FInst,519),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T2121'+FInst,545),30);
  SFD.PRec[i].PSin       := '00000000';
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T2121'+FInst,521));
  end;

  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFILINE.D');

  {---common---}
 BuildDtlTFS320(RetNo);
 BuildDtlFGS410(RetNo);
 BuildDtlFGS420(RetNo,SFD.GSTACCNO,SFD.SIC,SFD.BUSPARTNID,SFD.BusTaxSheltNo);
 BuildDtlDTM430(RetNo,SFD.BUSFISCSTART,SFD.BUSFISCEND);
 BuildDtlN1440(RetNo,SFD.BusName);
 BuildDtlN3470(RetNo,SFD.BusAddress,SFD.BusPostal);

 BuildDtlTIA490(RetNo,SFD.AccMethod,SFD.BUSTYPE,SFD.BUSFINALYR,
                SFD.BUSPERCENT,SFD.AcrFarmed,SFD.AcrOwned);

 For i:= 1 to 5 do
 begin
  If SFD.PRec[i].PPerCent > '' then
  begin
   BuildDtlFGS520(RetNo,i);
   BuildDtlN1550(RetNo,SFD.PRec[i].PSin);
   BuildDtlIN2570(RetNo,SFD.PRec[i].PFirstName,SFD.PRec[i].PLastName);
   BuildDtlTIA600(RetNo,SFD.PRec[i].PPerCent);
   {630-710 is for NISA}
  end;
 end;
 {Free format SFD}
 BuildDtlFGS740(RetNo);
   {      12345678901234567890123
  {Format nnnn $ fffffffff elm rrr}
 For i := 0 to Eflines.Count - 1 do
 begin
    LLine := myStrToInt(LeftStr(Eflines[i],4));
    LType := MidStr(Eflines[i],6,1);
    FName := AllTrim(MidStr(Eflines[i],8,9))+FInst;
    ElmNo := myStrToInt(MidStr(Eflines[i],17,3));
    If MidStr(Eflines[i],22,3) = '' then
         Rule := 0
    else
      Rule := MyStrToInt(MidStr(Eflines[i],22,3));

    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If LLine = 9946 then
    begin
     If (s ='') and (Vl(FetchElm(RetNo,'T2121'+FInst,35)) <>0) then s:='1';
    end;
    If S > '' then BuildDtlTIA820(RetNo,AllTrim(IntToStr(LLine)),s);
 end;
 EFLines.Free;
end;

Procedure  BuildDtlTFS320(RetNo:Integer);
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


Procedure  BuildDtlTFS900(RetNo:Integer);
Var Rec:String;
Begin
 Rec:= 'TFS'+ElemSep
     +'ZZ'+ElemSep
     +'EXC'+ElemSep
     +'55'+ElemSep
     +AllTrim(IntToStr(SfdNo))+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;


Procedure  BuildDtlFGS410(RetNo:Integer);
Var Rec:String;
Begin
 Rec:= 'FGS'+ElemSep
     +'X2'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildDtlFGS850(RetNo:Integer);
Var Rec:String;
Begin
 Rec:= 'FGS'+ElemSep
     +'PP'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);



end;


Procedure  BuildDtlFGS990(RetNo:Integer);
Var Rec:String;
Begin
 Rec:= 'FGS'+ElemSep
     +'X3'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildDtlFGS1100(RetNo:Integer);
Var Rec:String;
Begin
 Rec:= 'FGS'+ElemSep
     +'F3'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildDtlFGS420(RetNo:Integer;GT,IJ,M8,M9:String);
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

Procedure  BuildDtlDTM430(RetNo:Integer;D1,D2:String);
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

Procedure  BuildDtlN1440(RetNo:Integer;BusName:String);
Var Rec:String;
begin
 If BusName='' then exit;
 If BusName = '' then BusName := ' ';
 Rec:= 'N1'+ElemSep
     +'DH'+ElemSep
     +AllTrim(BusName)+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildDtlN3470(RetNo:Integer;BusAddress,BusPostal:String);
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

Procedure  BuildDtlTIA490(RetNo:Integer;ACM,BTC,FYB,PSB,TAF,TAO:String);
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

Procedure  BuildDtlFGS520(RetNo:Integer;PNo:Integer);
Var Rec:String;
begin
 Rec:= 'FGS'+ElemSep
     +'P'+AllTrim(IntToStr(PNo))+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildDtlN1550(RetNo:Integer;Sin:String);
Var Rec:String;
begin
 Rec:= 'N1'+ElemSep
     +'2K'+ElemSep+ElemSep
     +'50'+ElemSep
     +Sin+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;

Procedure  BuildDtlIN2570(RetNo:Integer;PFirstNm,PLastNm:String);
Var Rec:String;
begin
 If  AllTrim(PLastNm) >'' then  //if there is last nm then firstnm s/b transmitted
 begin
  PFirstNm:=AllTrim(PFirstNm);
  //20100123
  If PFirstNm>'' then
  begin
   Rec:= 'IN2'+ElemSep
       +'02'+ElemSep
       +PFirstNm+LineSep
       +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
  end;
  (*
  If PFirstNm='' then PFirstNm:=' ';
  Rec:= 'IN2'+ElemSep
      +'02'+ElemSep
      +PFirstNm+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
  *)
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

Procedure  BuildDtlTIA600(RetNo:Integer;PPerCent:String);
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

Procedure  BuildNISAProfile(RetNo:Integer;FName:String);
Var Rec:String;FNo:Integer;cd:string;
Begin
 FNo:=GetFormNo(FName);
 //new
 Rec:= 'FGS'+ElemSep
     +'CA'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);

 If (AllTrim(FetchElmFNo(RetNo,FNo,10)) > '')  //firstnm
 or (AllTrim(FetchElmFNo(RetNo,FNo,11)) > '') //last nm
 Or (AllTrim(FetchElmFNo(RetNo,FNo,8)) > '')  //bus nm
 then  //there is name
 begin
  Rec:= 'N1'+ElemSep
     +'N2'+ElemSep+'CI'
     +LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 //contact First nm
 If AllTrim(FetchElmFNo(RetNo,FNo,10)) > '' then
 begin
  Rec:= 'IN2'+ElemSep
     +'02'+ElemSep
     +AllTrim(FetchElmFNo(RetNo,FNo,10))+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 //contact Last nm
 If AllTrim(FetchElmFNo(RetNo,FNo,11)) > '' then
 begin
  Rec:= 'IN2'+ElemSep
      +'05'+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,11))+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 //Business nm
 If AllTrim(FetchElmFNo(RetNo,FNo,8)) > '' then
 begin
  Rec:= 'IN2'+ElemSep
      +'11'+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,8))+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 //contact str
 If AllTrim(FetchElmFNo(RetNo,FNo,12)) > '' then
 begin
  Rec:= 'N3'+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,12))+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 //contact city,prov,postal
 If AllTrim(FetchElmFNo(RetNo,FNo,13)) >'' then
 Begin
  Rec:= 'N4'+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,13))+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,14))+ElemSep
      +RemoveChar(AllTrim(FetchElmFNo(RetNo,FNo,15)),' ') //+ElemSep
      +LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 //bus type code
 If FetchElm(RetNo,'T1163#1',207)>'' then cd:='1' else Cd:='2';
 Rec:= 'TIA'+ElemSep
     +'BCT'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,23));
 If CD>'' then cd:='1' else cd:='2';
 begin
  Rec:= 'TIA'+ElemSep
       +'CNI'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 (*
 Cd:='1';
 If FetchElmFNo(RetNo,FNo,38)>'' then Cd:='3';
 If FetchElmFNo(RetNo,FNo,39)>'' then Cd:='2';
 If cd>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'APP'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 *)

 If FetchElmFNo(RetNo,FNo,35)>'' then cd:='1' else cd:='2';
 If CD>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'CPC'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 cd:='';
 If FetchElmFNo(RetNo,FNo,25)>'' then cd:='1';
 If FetchElmFNo(RetNo,FNo,26)>'' then cd:='2';
 If cd>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'DCP'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;



 cd:=AllTrim(FetchElmFNo(RetNo,FNo,32));
 If CD>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'PMF'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,18)+FetchElmFNo(RetNo,FNo,19));
 cd:=RemoveChar(RemoveChar(cd,' '),'-');
 If CD>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'FAX'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,16)+FetchElmFNo(RetNo,FNo,17));
 cd:=RemoveChar(RemoveChar(cd,' '),'-');
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'PHO'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=FetchElmFNo(RetNo,FNo,20);
 cd:=AddLeadingZeros(cd,8);
 Rec:= 'TIA'+ElemSep
     +'PIN'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

 If FetchElm(RetNo,'T1163#1',216)>'' then cd:='1' else cd:='0';
 Rec:= 'TIA'+ElemSep
     +'LAN'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

 If FetchElm(RetNo,'T1163#1',217)>'' then cd:='1' else cd:='0';
 Rec:= 'TIA'+ElemSep
     +'TEN'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

 If FetchElm(RetNo,'T1163#1',215)>'' then cd:='1' else cd:='0';
 Rec:= 'TIA'+ElemSep
     +'FEE'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);


 cd:=AllTrim(FetchElmFNo(RetNo,FNo,33));
 cd:=AddLeadingzeros(cd,2);
 Rec:= 'TIA'+ElemSep
     +'YRF'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;


Procedure  BuildDtlFGS740(RetNo:Integer);
Var Rec:String;
Begin
 Rec:= 'FGS'+ElemSep
     +'F2'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
end;


Procedure  BuildDtlTIA820(RetNo:Integer;LLineString:String;s:String);
Var Rec:String;
begin
  Rec:= 'TIA'+ElemSep
       +LLineString+ElemSep
       +S+LineSep  {3}
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;

Procedure  BuildDtlTIA1180(RetNo:Integer;LLineString:String;s:String);
Var Rec:String;
begin
  Rec:= 'TIA'+ElemSep
       +LLineString+ElemSep
       +S+LineSep  {3}
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;


Procedure  BuildDtlTIA1020forT777(RetNo:Integer);
Var Rec:String;Typ:string; //[1];
begin
 Typ:='7';
  Rec:= 'TIA'+ElemSep
       +'EOC'+ElemSep+ElemSep
       +Typ+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;


Procedure  BuildDtlTIA1020forTL2(RetNo:Integer);
Var Rec:String;Typ:string; //[1];
begin
 Typ:='8';
  Rec:= 'TIA'+ElemSep
       +'EOC'+ElemSep+ElemSep
       +Typ+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
end;


Procedure  BuildGE(RetNo:Integer;OnLineMethod:String);
Var Rec:String;GE01,GE02:String;
begin
 If OnlineMethod = 'EOLP' then
 begin
   GE01:=AllTrim(IntToStr(TxSetCnt));   //num of files
   GE02:=GroupCtrlNo    //assigned in the beginning
 end
 else
 begin
   GE01:='1';   //numb of files
   GE02:=GetSinNo(RetNo);
 end;
 Rec:= 'GE'+ElemSep
     +GE01+ElemSep
     +GE02+LineSep
     +Crlf;
 Write(F1,Rec);
end;

Procedure  BuildIEA(RetNo:Integer;OnLineMethod:String);
Var Rec:String; IEA02:String;
begin
 If OnlineMethod = 'EOLP' then
  IEA02:=ISACtrlNo
 else
  IEA02:=GetSinNo(RetNo);

 Rec:= 'IEA'+ElemSep
     +'1'+ElemSep
     + IEA02+LineSep
     +Crlf;
 Write(F1,Rec);
end;

Function GetISACtrlNo:String;
Var Dt:String;
begin
 Dt := FormatDateTime('yyyy-mm-dd',Now);
 Dt := MidStr(Dt,4,1)+MidStr(Dt,6,2)+RightStr(Dt,2);   //YMMDD
 Result:=Dt+GetMinutesAndSeconds;   //YMMDDmmss
end;

Function GetGroupCtrlNo:String;
Var Dt:String;
begin
 Dt := FormatDateTime('yyyy-mm-dd',Now);
 Dt := MidStr(Dt,4,1)+MidStr(Dt,6,2)+RightStr(Dt,2);   //YMMDD
 Result:=Dt+GetMinutesAndSeconds;   //YMMDDmmss
end;

Function GetMinutesAndSeconds:String;
Var SHours, SMinutes,SSeconds : string; //[2];
    Hour,Min,Sec,Msec :word;
begin
  DecodeTime(Now,Hour,Min,Sec,Msec);
  sMinutes := AllTrim(IntToStr(Min));
  sSeconds := AllTrim(IntToStr(Sec));
  //If Length(SHours)   =1 then SHours   := '0'+SHours;
  If Length(sMinutes) =1 then SMinutes := '0'+SMinutes;
  If Length(SSeconds) =1 then SSeconds := '0'+SSeconds;
  Result := SMinutes+SSeconds;
end;


Procedure  BuildT777(RetNo:Integer;FInst:String);
 Var I,LLine,ElmNo,Rule:integer;
   LType,S,FName:string;
begin
 If IsPreBankruptcyReturn(RetNo) then exit;
  SFD.RECTYPE:='03';
  SFD.SEQNO:=FX.SEQNO;
  SfdRecNumber:=SfdRecNumber+1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber),2);
  SFD.BUSTYPE := '7';
  SFD.SIN :=RemoveHyphens(FetchElm(RetNo,'INFO',3));

  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFT777.D');

  {----}

 BuildDtlTFS900(RetNo);
 BuildDtlFGS990(RetNo);
 BuildDtlTIA1020ForT777(RetNo);
 BuildDtlFGS1100(RetNo);

 {Free format SFD fot t777}
   {      12345678901234567890123
  {Format nnnn $ fffffffff elm rrr}
 For i := 0 to Eflines.Count - 1 do
 begin
    //ShowMessage(Eflines[i]);
    LLine := myStrToInt(LeftStr(Eflines[i],4));
    LType := MidStr(Eflines[i],6,1);
    FName := AllTrim(MidStr(Eflines[i],8,9)); //+FInst;
    ElmNo := myStrToInt(MidStr(Eflines[i],17,3));
    If MidStr(Eflines[i],22,3) = '' then
         Rule := 0
    else
      Rule := MyStrToInt(MidStr(Eflines[i],22,3));
    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If (S > '') and (LLine>0) then
     BuildDtlTIA1180(RetNo,AllTrim(IntToStr(LLine)),s);
 end;
 EFLines.Free;
end;

(*
Procedure  BuildT777S(RetNo:Integer;FInst:String);  //20210220
 Var I,LLine,ElmNo,Rule:integer;
   LType,S,FName:string;
begin
 If IsPreBankruptcyReturn(RetNo) then exit;
  SFD.RECTYPE:='03';
  SFD.SEQNO:=FX.SEQNO;
  SfdRecNumber:=SfdRecNumber+1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber),2);
  SFD.BUSTYPE := '7';
  SFD.SIN :=RemoveHyphens(FetchElm(RetNo,'INFO',3));

  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFT777.D');

  {----}

 BuildDtlTFS900(RetNo);
 BuildDtlFGS990(RetNo);
 BuildDtlTIA1020ForT777(RetNo);
 BuildDtlFGS1100(RetNo);

 {Free format SFD fot t777}
   {      12345678901234567890123
  {Format nnnn $ fffffffff elm rrr}
 For i := 0 to Eflines.Count - 1 do
 begin
    //ShowMessage(Eflines[i]);
    LLine := myStrToInt(LeftStr(Eflines[i],4));
    LType := MidStr(Eflines[i],6,1);
    FName := AllTrim(MidStr(Eflines[i],8,9)); //+FInst;
    ElmNo := myStrToInt(MidStr(Eflines[i],17,3));
    If MidStr(Eflines[i],22,3) = '' then
         Rule := 0
    else
      Rule := MyStrToInt(MidStr(Eflines[i],22,3));
    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If (S > '') and (LLine>0) then
     BuildDtlTIA1180(RetNo,AllTrim(IntToStr(LLine)),s);
 end;
 EFLines.Free;
end;
*)

Procedure  BuildTL2(RetNo:Integer;FInst:String);
 Var I,LLine,ElmNo,Rule:integer;
   LType, S,FName:string;
begin
  SFD.RECTYPE:='03';
  //SFD.PREPARERNO:=FX.PREPARERNO;
  SFD.SEQNO:=FX.SEQNO;
  SfdRecNumber:=SfdRecNumber+1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber),2);
  SFD.BUSTYPE := '8';
  SFD.SIN :=RemoveHyphens(FetchElm(RetNo,'INFO',3));

  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFTL2.D');

  {----}
 BuildDtlTFS900(RetNo);
 BuildDtlFGS990(RetNo);
 BuildDtlTIA1020ForTL2(RetNo);
 BuildDtlFGS1100(RetNo);

 {Free format SFD fot tl2}
   {      12345678901234567890123
  {Format nnnn $ fffffffff elm rrr}
 For i := 0 to Eflines.Count - 1 do
 begin
    LLine := myStrToInt(LeftStr(Eflines[i],4));
    LType := MidStr(Eflines[i],6,1);
    FName := AllTrim(MidStr(Eflines[i],8,9))+FInst;
    //FName := AllTrim(MidStr(Eflines[i],8,9));
    ElmNo := myStrToInt(MidStr(Eflines[i],17,3));
    If MidStr(Eflines[i],22,3) = '' then
         Rule := 0
    else
      Rule := MyStrToInt(MidStr(Eflines[i],22,3));
    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If S > '' then BuildDtlTIA1180(RetNo,AllTrim(IntToStr(LLine)),s);
 end;
 EFLines.Free;
end;

Procedure  BuildT1273LikeNisa(RetNo:Integer;FInst:String);
//like NISAA
 Var I,LLine,ElmNo,Rule,FNo:integer;
   LType,FName,S,cd,Rec:String;
begin
 If IsPreBankruptcyReturn(RetNo) then exit;
  SFD.RECTYPE:='03';
  SFD.PREPARERNO:=FX.PREPARERNO;
  SFD.SEQNO:=FX.SEQNO;
  SfdRecNumber:=SfdRecNumber+1;
  SFD.SFDREC := PaddZero(IntToStr(SfdRecNumber),2);
  SFD.BUSTYPE := '6';  //same with normal NISA
  SFD.BUSNAME:=FetchElm(RetNo,'T1273'+FInst,201); //?
  // ?If AllTrim(SFD.BUSNAME)='' then SFD.BUSNAME := GetFirstName(RetNo)+' '+GetLastName(RetNo); //?

  SFD.BUSADDRESS:=FetchElm(RetNo,'T1273'+FInst,204);
  SFD.BUSPOSTAL:=MTrim(FetchElm(RetNo,'T1273'+FInst,206));
  SFD.BUSFISCSTART:=RemoveHyphens(FetchElm(RetNo,'T1273'+FInst,213));
  SFD.BUSFISCEND :=RemoveHyphens(FetchElm(RetNo,'T1273'+FInst,214));
  SFD.AcrOwned :=FetchElm(RetNo,'T1273'+FInst,217);
  SFD.AcrFarmed:=FetchElm(RetNo,'T1273'+FInst,219);
  //? rented
  SFD.AccMethod:=AllTrim(FetchElm(RetNo,'T1273'+FInst,212));

  SFD.SIC:=FetchElm(RetNo,'T1273'+FInst,34);
  //SFD.SIN :=RemoveHyphens(FetchElm(RetNo,'T1',3));  //?
  SFD.BUSPARTNID:=FetchElm(RetNo,'T1273'+FInst,624);
  SFD.BUSPERCENT:=FormatFourDigitPercent(FetchElm(RetNo,'T1273'+FInst,210));
  If AllTrim(FetchElm(RetNo,'T1273'+FInst,35))>'' THEN
    SFD.BUSFINALYR:='1'
  ELSE
    SFD.BUSFINALYR:='2';

  SFD.GSTACCNO :='';

  i:=0;
  If Vl(FetchElm(RetNo,'T1273'+FInst,632))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1273'+FInst,630),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1273'+FInst,631),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1273'+FInst,634),8);
  If FetchElm(RetNo,'T1273'+FInst,633)>'' then
     SFD.PRec[i].PSin       := FetchElm(RetNo,'T1273'+FInst,633);
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1273'+FInst,632));
  end;
  If Vl(FetchElm(RetNo,'T1273'+FInst,637))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1273'+FInst,635),30); //20110505
  //SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1273'+FInst,635),630);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1273'+FInst,636),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1273'+FInst,639),8);
  If FetchElm(RetNo,'T1273'+FInst,638)>'' then
     SFD.PRec[i].PSin       := FetchElm(RetNo,'T1273'+FInst,638);
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1273'+FInst,637));
  end;
  If Vl(FetchElm(RetNo,'T1273'+FInst,642))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1273'+FInst,640),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1273'+FInst,641),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1273'+FInst,644),8);
  If FetchElm(RetNo,'T1273'+FInst,643)>'' then
     SFD.PRec[i].PSin       := FetchElm(RetNo,'T1273'+FInst,643);
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1273'+FInst,642));
  end;
  If Vl(FetchElm(RetNo,'T1273'+FInst,647))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1273'+FInst,645),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1273'+FInst,646),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1273'+FInst,649),8);
  If FetchElm(RetNo,'T1273'+FInst,648)>'' then
     SFD.PRec[i].PSin       := FetchElm(RetNo,'T1273'+FInst,648);
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1273'+FInst,647));
  end;

  If Vl(FetchElm(RetNo,'T1273'+FInst,652))>0 then
  begin
  Inc(i);
  SFD.PRec[i].PFirstName := PaddR(FetchElm(RetNo,'T1273'+FInst,650),30);
  SFD.PRec[i].PLastName  := PaddR(FetchElm(RetNo,'T1273'+FInst,651),30);
  SFD.PRec[i].PSin       := PaddZero(FetchElm(RetNo,'T1273'+FInst,654),8);
  If FetchElm(RetNo,'T1273'+FInst,653)>'' then
     SFD.PRec[i].PSin       := FetchElm(RetNo,'T1273'+FInst,653);
  SFD.PRec[i].PPerCent   := FormatBusPercent(FetchElm(RetNo,'T1273'+FInst,652));
  end;

  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+'EFCLINE.D');

 {---common---}
 BuildDtlTFS320(RetNo);
 BuildDtlFGS410(RetNo);
 BuildDtlFGS420(RetNo,SFD.GSTACCNO,SFD.SIC,SFD.BUSPARTNID,'');
   //last one is taxShelt No, not used in T1273
 BuildDtlDTM430(RetNo,SFD.BUSFISCSTART,SFD.BUSFISCEND);
 BuildDtlN1440(RetNo,SFD.BusName);
 BuildDtlN3470(RetNo,SFD.BusAddress,SFD.BusPostal);

 BuildDtlTIA490(RetNo,SFD.AccMethod,SFD.BUSTYPE,SFD.BUSFINALYR,
                SFD.BUSPERCENT,'',''); //last are acres TAF,TAO n/a in T1273

 For i:= 1 to 5 do
 begin
  If SFD.PRec[i].PPerCent > '' then
  begin
   BuildDtlFGS520(RetNo,i);
   BuildDtlN1550(RetNo,SFD.PRec[i].PSin);
   BuildDtlIN2570(RetNo,SFD.PRec[i].PFirstName,SFD.PRec[i].PLastName);
   BuildDtlTIA600(RetNo,SFD.PRec[i].PPerCent);
   {630-710 is for T1273}
  end;
 end;
 {Free format SFD}
 If Ret[RetNo].FormHasData['T1273#1'] then
  BuildT1273Profile(RetNo,'T1273#1');
 BuildDtlFGS740(RetNo);
   {      12345678901234567890123
  {Format nnnn $ fffffffff elm rrr}


 //9950 $ T1273
   FNo:=GetFormNo('T1273'+FInst);
   LLine := 9950;
   LType := '$';
   FName := 'T1273'+FInst;
   ElmNo := 305;
   Rule:=0;
   S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
   If S > '' then BuildDtlTIA820(RetNo,AddLeadingZeros(AllTrim(IntToStr(LLine)),3),s);

 //details Codes and amounts for 9950
 i:=219;
 FNo:=GetFormNo('T1273'+FInst);
 Repeat
    LLine := myStrToInt(FetchElmFNo(RetNo,FNo,i));
    LType := '$';
    FName := 'T1273'+FInst;
    ElmNo := i+1;
    Rule:=0;
    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If S > '' then BuildDtlTIA820(RetNo,AddLeadingZeros(AllTrim(IntToStr(LLine)),3),s);
  Inc(i,3);
 until i>303;


 // 9960 $ T1273   065
   FNo:=GetFormNo('T1273'+FInst);
   LLine := 9960;
   LType := '$';
   FName := 'T1273'+FInst;
   ElmNo := 458;
   Rule:=0;
   S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
   If S > '' then BuildDtlTIA820(RetNo,AddLeadingZeros(AllTrim(IntToStr(LLine)),3),s);

 i:=402;
 FNo:=GetFormNo('T1273'+FInst);
 Repeat
    LLine := myStrToInt(FetchElmFNo(RetNo,FNo,i));
    LType := '$';
    FName := 'T1273'+FInst;
    ElmNo := i+1;
    Rule:=0;
    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If S > '' then BuildDtlTIA820(RetNo,AddLeadingZeros(AllTrim(IntToStr(LLine)),3),s);
  Inc(i,3);
 until i>456;

 For i := 0 to Eflines.Count - 1 do
 begin
    LLine := myStrToInt(LeftStr(Eflines[i],4));
    LType := MidStr(Eflines[i],6,1);
    FName := AllTrim(MidStr(Eflines[i],8,9))+FInst;
    ElmNo := myStrToInt(MidStr(Eflines[i],17,3));
    If MidStr(Eflines[i],22,3) = '' then
         Rule := 0
    else
      Rule := MyStrToInt(MidStr(Eflines[i],22,3));

    S := GetNetFileAmount(RetNo,LLine,LType,FName,ElmNo,Rule);
    If LLine = 9946 then
    begin
     If (s ='') and (Vl(FetchElm(RetNo,'T1273'+FInst,352)) <>0) then s:='1';
    end;

    If LLine = 9946 then
    begin
     If (Vl(FetchElm(RetNo,'T1273'+FInst,656)) >0) //rest farm loss
     and (Vl(FetchElm(RetNo,'T1273'+FInst,616)) <0)  then
     begin
       s:=AllTrim(IntToStr(Round(Vl(FetchElm(RetNo,'T1273'+FInst,655)))));
     end;
    end;

    If LLine = 9969 then //ni before adj
    begin
     If (s ='') and (Vl(FetchElm(RetNo,'T1273'+FInst,601)) <>0)
     then s:='1';
    end;
    If S > '' then BuildDtlTIA820(RetNo,AllTrim(IntToStr(LLine)),s);
 end;
 EFLines.Free;
end;

Procedure  BuildT1273Profile(RetNo:Integer;FName:String);
Var Rec:String;FNo:Integer;cd:string;
Begin
 If IsPreBankruptcyReturn(RetNo) then exit;
 FNo:=GetFormNo(FName);
 //new
 Rec:= 'FGS'+ElemSep
     +'CA'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);

 If (AllTrim(FetchElmFNo(RetNo,FNo,10)) > '')
 or (AllTrim(FetchElmFNo(RetNo,FNo,11)) > '')
 or (AllTrim(FetchElmFNo(RetNo,FNo,65)) > '')
 then  //there is name
 begin
  Rec:= 'N1'+ElemSep
     +'N2'+ElemSep+'CI'
     +LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 //contact First nm
 If AllTrim(FetchElmFNo(RetNo,FNo,10)) > '' then
 begin
  Rec:= 'IN2'+ElemSep
     +'02'+ElemSep
     +AllTrim(FetchElmFNo(RetNo,FNo,10))+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 //contact Last nm
 If AllTrim(FetchElmFNo(RetNo,FNo,11)) > '' then
 begin
  Rec:= 'IN2'+ElemSep
      +'05'+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,11))+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 //Business nm
 If AllTrim(FetchElmFNo(RetNo,FNo,65)) > '' then
 begin
  Rec:= 'IN2'+ElemSep
      +'11'+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,65))+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;


 //contact str
 If AllTrim(FetchElmFNo(RetNo,FNo,12)) > '' then
 begin
  Rec:= 'N3'+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,12))+LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 //contact city,prov,postal
 If AllTrim(FetchElmFNo(RetNo,FNo,13)) >'' then
 Begin
  Rec:= 'N4'+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,13))+ElemSep
      +AllTrim(FetchElmFNo(RetNo,FNo,14))+ElemSep
      +RemoveChar(AllTrim(FetchElmFNo(RetNo,FNo,15)),' ') //+ElemSep
      +LineSep
      +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 //bus type code
 If FetchElm(RetNo,'T1273#1',207)>'' then cd:='1' else Cd:='2';
 Rec:= 'TIA'+ElemSep
     +'BCT'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);


 cd:=AllTrim(FetchElmFNo(RetNo,FNo,64));
 If CD>'' then cd:='1' else cd:='2';
 begin
  Rec:= 'TIA'+ElemSep
       +'CNI'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 Cd:='1';
 //20090319
 If FetchElmFNo(RetNo,FNo,68)>'' then Cd:='2';
 If FetchElmFNo(RetNo,FNo,67)>'' then Cd:='3';
 {
 If FetchElmFNo(RetNo,FNo,67)>'' then Cd:='2';
 If FetchElmFNo(RetNo,FNo,68)>'' then Cd:='3';
 }

 (*
 If cd>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'APP'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 *)

 If FetchElmFNo(RetNo,FNo,69)>'' then cd:='1' else cd:='2';
 If CD>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'CPC'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 cd:='';
 If FetchElmFNo(RetNo,FNo,71)>'' then cd:='1';
 If FetchElmFNo(RetNo,FNo,72)>'' then cd:='2';
 If cd>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'DCP'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;



 cd:=AllTrim(FetchElmFNo(RetNo,FNo,50));
 If Cd>'' then cd:='1' else cd:='2';
 begin
  Rec:= 'TIA'+ElemSep
       +'COB'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;


 cd:=AllTrim(FetchElmFNo(RetNo,FNo,32));
 If CD>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'PMF'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,18)+FetchElmFNo(RetNo,FNo,19));
 cd:=RemoveChar(RemoveChar(cd,' '),'-');
 If CD>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'FAX'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,16)+FetchElmFNo(RetNo,FNo,17));
 cd:=RemoveChar(RemoveChar(cd,' '),'-');
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'PHO'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=FetchElmFNo(RetNo,FNo,20);
 cd:=AddLeadingZeros(cd,8);
 Rec:= 'TIA'+ElemSep
     +'PIN'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

 If FetchElmFNo(RetNo,GetFormNo('T1273#1'),216)>'' then cd:='1' else cd:='0';
 Rec:= 'TIA'+ElemSep
     +'LAN'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

 If FetchElmFNo(RetNo,GetFormNo('T1273#1'),217)>'' then cd:='1' else cd:='0';
 Rec:= 'TIA'+ElemSep
     +'TEN'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

 If FetchElmFNo(RetNo,GetFormNo('T1273#1'),215)>'' then cd:='1' else cd:='0';
 Rec:= 'TIA'+ElemSep
     +'FEE'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);


 cd:=AllTrim(FetchElmFNo(RetNo,FNo,33));
 cd:=AddLeadingzeros(cd,2);
 Rec:= 'TIA'+ElemSep
     +'YRF'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);


 BuildDtlFGS850(RetNo);  //fgs pp
  cd:=FetchElmFNo(RetNo,FNo,41);
 If cd>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'OP1'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

  cd:=FetchElmFNo(RetNo,FNo,56);
  If Cd>'' then cd:='1' else cd:='2';
   Rec:= 'TIA'+ElemSep
       +'AR1'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 (*
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,43));
 If CD>'' then cd:='1' else cd:='';
 If Cd='1' then      //march 20 2008
 begin
  Rec:= 'TIA'+ElemSep
       +'ARM'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;
 *)
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,44));
 If CD>'' then cd:='1' else cd:='';
 If Cd='1' then      //march 20 2008
 begin
  Rec:= 'TIA'+ElemSep
       +'CWB'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 end;


 cd:=FetchElmFNo(RetNo,FNo,52);
 If cd>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'OP2'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

  cd:=FetchElmFNo(RetNo,FNo,58);
  If Cd>'' then cd:='1' else cd:='2';
   Rec:= 'TIA'+ElemSep
       +'AR2'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=FetchElmFNo(RetNo,FNo,53);
 If cd>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'OP3'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

  cd:=FetchElmFNo(RetNo,FNo,60);
  If Cd>'' then cd:='1' else cd:='2';
   Rec:= 'TIA'+ElemSep
       +'AR3'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=FetchElmFNo(RetNo,FNo,54);
 If cd>'' then
 begin
  Rec:= 'TIA'+ElemSep
       +'OP4'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

  cd:=FetchElmFNo(RetNo,FNo,62);
  If Cd>'' then cd:='1' else cd:='2';
   Rec:= 'TIA'+ElemSep
       +'AR4'+ElemSep+ElemSep
       +Cd+LineSep
       +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;


 //additional for harmonized
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,3)+FetchElmFNo(RetNo,FNo,4));
 cd:=RemoveChar(RemoveChar(cd,' '),'-');
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'EPN'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,22)+FetchElmFNo(RetNo,FNo,21));
 cd:=RemoveChar(RemoveChar(cd,' '),'-');
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'CFN'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,26)); //24  20100313
 If CD>'' then cd:='1' else cd:='2';
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'FPO'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 (* 20090115
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,26));
 If CD>'' then cd:='1';
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'CCI'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;
 *)
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,27));
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'DCN'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,28));
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'DCR'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,29));
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'LLQ'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,30));
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'LLS'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,31));
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'LLT'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,37));
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'LLR'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,38));
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'LLM'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,40));
 If CD>'' then cd:='1' else cd:='2';
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'OCA'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;


(* removed in 2006
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,42));
 If CD>'' then cd:='1' else CD:='2';
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'CCL'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;
 *)

(* removed in 2006
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,44));
 If CD>'' then cd:='1';
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'MYC'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;
 *)
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,45));
 If CD>'' then cd:='1';
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'OTH'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 (*
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,47));
 If CD>'' then cd:='1';
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'ATC'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;
 *)

 (*
 cd:=AllTrim(FetchElmFNo(RetNo,FNo,48));
 If CD>'' then cd:='1';
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'PCW'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;
 *)

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,46));
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'OTX'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;

 cd:=AllTrim(FetchElmFNo(RetNo,FNo,49));
 If CD>'' then cd:='1';
 If CD>'' then
 begin
   Rec:= 'TIA'+ElemSep
     +'REC'+ElemSep+ElemSep
     +Cd+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
 end;
end;


Procedure  BuildT1273Additional(RetNo:Integer;FInst:String);  //page 7 and 8
// livestock etc
 Var I,j,K,LLine,ElmNo,Rule,FNo:integer;Valu:String;
   LType, FName,S,cd,Rec:String;
begin
 If IsPreBankruptcyReturn(RetNo) then exit;
 //tfs
 Rec:= 'TFS'+ElemSep
     +'DD'+ElemSep
     +'CASU'+ElemSep
     +'55'+ElemSep
     +AllTrim(IntToStr(SfdNo))+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);

 //fgs
 Rec:= 'FGS'+ElemSep
     +'X4'+LineSep
     +Crlf;
 Write(F1,Rec);
 Inc(SegmentCnt);
 //tia
  Rec:= 'TIA'+ElemSep
       +'CAH'+ElemSep+ElemSep
       +'9'+LineSep
       +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

 //CROP   cr fgs   //fgs 1410

  FNo:=GetFormNo('T1273'+FInst);

  Rec:= 'FGS'+ElemSep
     +'CR'+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
 //contract numbers
 i:=952; ///852;  20110317
 k:=1;
 Repeat
  Valu:=FetchElmFNo(RetNo,FNo,i);
  If FetchElmFNo(RetNo,FNo,i)>'' then
  begin
    Rec:= 'TIA'+ElemSep
    +'A'+AllTrim(IntToStr(k))+'PC'+ElemSep        {1}
     +ElemSep          {2}
     +valu+LineSep           {3}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);
  Inc(k,1);
  end;
  Inc(i,1);
 until i>957;


 //pcodc crop


  If FetchElmFNo(RetNo,FNo,805) >'' then valu:='1' else valu:='2';  //20110317
 // If FetchElmFNo(RetNo,FNo,5) >'' then valu:='1' else valu:='2';
  Rec:= 'TIA'+ElemSep
    +'PCODC'+ElemSep        {1}
     +ElemSep          {2}
     +valu+LineSep           {3}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);


  //k:=BuildCrop(RetNo,FNo,59,143,7,1); //page 7
  k:=BuildCrop(RetNo,FNo,859,943,7,1); //page 7  //20101221
  FNo:=GetFormNo('T1273A1'+FInst);
  If Ret[RetNo].FormHasData[GetFormName(RetNo,FNo)] then BuildCrop(RetNo,FNo,59,143,7,k); //additional crop
  //unfarmable
  FNo:=GetFormNo('T1273'+FInst);
  valu:=FetchElmFNo(RetNo,FNo,958);
  If Valu>'' then
  begin
     Rec:= 'TIA'+ElemSep
    +'NOUA'+ElemSep+ElemSep+ElemSep
     +Format1273Numerics(valu,3)+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
  end;

  valu:=FetchElmFNo(RetNo,FNo,959);  //20101221
  If Valu>'' then
  begin
     Rec:= 'TIA'+ElemSep
    +'NOSA'+ElemSep+ElemSep+ElemSep
     +Format1273Numerics(valu,3)+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
  end;

  valu:=FetchElmFNo(RetNo,FNo,960);    //20101221
  If Valu>'' then
  begin
     Rec:= 'TIA'+ElemSep
    +'NOPA'+ElemSep+ElemSep+ElemSep
     +Format1273Numerics(valu,3)+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
  end;

  valu:=FetchElmFNo(RetNo,FNo,961);
  If Valu>'' then
  begin
     Rec:= 'TIA'+ElemSep
    +'NOWA'+ElemSep+ElemSep+ElemSep
     +Format1273Numerics(valu,3)+LineSep
     +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
  end;

  // fgs lv
  Rec:= 'FGS'+ElemSep
     +'LV'+LineSep
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

  FNo:=GetFormNo('T1273'+FInst);
 //pcodl  livestock
  If FetchElmFNo(RetNo,FNo,950) >'' then valu:='1' else valu:='2';
   Rec:= 'TIA'+ElemSep
    +'PCODL'+ElemSep        {1}
     +ElemSep          {2}
     +valu+LineSep           {3}
     +Crlf;
  Write(F1,Rec);
  Inc(SegmentCnt);

  (* 20090115
  If FetchElmFNo(RetNo,FNo,165)>'' then cd:='1' else cd:='';
  If CD>'' then
  begin
   Rec:= 'TIA'+ElemSep
        +'LVN'+ElemSep+ElemSep
        +Cd+LineSep
        +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
  end;
  *)
  k:=BuildLivestock(RetNo,FNo,807,855,4,1);  //k = last entry on main screen  //20101221
 // k:=BuildLivestock(RetNo,FNo,7,55,4,1);  //k = last entry on main screen  //20110317
  For j:=1 to 9 do
  begin
   FNo:=GetFormNo('T1273A1'+'#'+AllTrim(IntToStr(j))); //FInst;
   If FNo>0 then
   begin
    If (Ret[RetNo].FormHasData[GetFormName(RetNo,FNo)]) and ('#'+FetchElmFNo(RetNo,FNo,3)=FInst)
     then k:=BuildLiveStock(RetNo,FNo,7,55,4,k); //aditional livestock
   end;
  end;

  //AL additional livestock
  FNo:=GetFormNo('T1273'+FInst);
  Rec:= 'FGS'+ElemSep
      +'AL'+LineSep
      +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);

  (* 20090115
   If FetchElmFNo(RetNo,FNo,113)>'' then cd:='1' else cd:='';
   If CD>'' then
   begin
    Rec:= 'TIA'+ElemSep
         +'ALN'+ElemSep+ElemSep
         +Cd+LineSep
         +Crlf;
    Write(F1,Rec);
    Inc(SegmentCnt);
   end;
  *)
  If FgsHasData(RetNo,FNo,1077,1111,1,1) then //AL
  begin
   k:=1;
   Valu:=FetchElmFNo(RetNo,FNo,1077); If valu>'' then
      begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'104',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1078); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'123',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1079); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'145',valu);end;

   Valu:=FetchElmFNo(RetNo,FNo,1080); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'105',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1081); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'106',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1082); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'125',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1083); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'124',valu);end;

   Valu:=FetchElmFNo(RetNo,FNo,1084); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'141',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1085); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'142',valu);end;

   Valu:=FetchElmFNo(RetNo,FNo,1086); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'113',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1087); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'108',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1088); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'109',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1089); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'143',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1090); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'144',valu);end;
   Valu:=FetchElmFNo(RetNo,FNo,1091); If valu>'' then begin Inc(k);BuildAdditionalLiveStock(RetNo,FNo,'128',valu);end;

   BuildT1273ALI(RetNo,FNo,1092,1108,4,1);  //

   For j:=1 to 9 do    //productive capacity
   begin
    FNo:=GetFormNo('T1273A2'+'#'+AllTrim(IntToStr(j))); //FInst;
    If FNo>0 then
    begin
     If (Ret[RetNo].FormHasData[GetFormName(RetNo,FNo)]) and ('#'+FetchElmFNo(RetNo,FNo,3)=FInst)
      then BuildT1273ALI(RetNo,FNo,92,108,4,k);
    end;
   end;
  end; //fgs has data

  //fgs PI
  FNo:=GetFormNo('T1273'+FInst);

  Rec:= 'FGS'+ElemSep
      +'PI'+LineSep
      +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);

  If FgsHasData(RetNo,FNo,1005,1026,3,1) then //Purch inputs
  BEGIN
   FNo:=GetFormNo('T1273'+FInst);
   k:=BuildT1273PI(RetNo,FNo,1005,1026,3,1); //Purch inputs

   For j:=1 to 9 do
   begin
    FNo:=GetFormNo('T1273A2'+'#'+AllTrim(IntToStr(j))); //FInst;
    If FNo>0 then
    begin
     If (Ret[RetNo].FormHasData[GetFormName(RetNo,FNo)]) and ('#'+FetchElmFNo(RetNo,FNo,3)=FInst)
      then k:=BuildT1273PI(RetNo,FNo,5,26,3,k);
    end;
   end;
  END;

  //fgs DI
  FNo:=GetFormNo('T1273'+FInst);

  Rec:= 'FGS'+ElemSep
      +'DI'+LineSep
      +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);

  If FGSHasData(RetNo,FNo,1029,1050,3,1) then
  BEGIN
   FNo:=GetFormNo('T1273'+FInst);
   k:=BuildT1273DI(RetNo,FNo,1029,1050,3,1); //page 9

   For j:=1 to 9 do
   begin
    FNo:=GetFormNo('T1273A2'+'#'+AllTrim(IntToStr(j))); //FInst;
    If FNo>0 then
    begin
     If (Ret[RetNo].FormHasData[GetFormName(RetNo,FNo)]) and ('#'+FetchElmFNo(RetNo,FNo,3)=FInst)
      then k:=BuildT1273DI(RetNo,FNo,29,50,3,k);
      //then k:=BuildT1273PI(RetNo,FNo,29,50,4,k);
    end;
   end;
  END;

  //fgs AP
  FNo:=GetFormNo('T1273'+FInst);
  Rec:= 'FGS'+ElemSep
      +'AP'+LineSep
      +Crlf;
   Write(F1,Rec);
   Inc(SegmentCnt);
  If FGSHasData(RetNo,FNo,1053,1071,3,1) then
  BEGIN
   FNo:=GetFormNo('T1273'+FInst);
   k:=BuildT1273AP(RetNo,FNo,1053,1074,3,1);

   For j:=1 to 9 do
   begin
    FNo:=GetFormNo('T1273A9'+'#'+AllTrim(IntToStr(j))); //FInst;
    If FNo>0 then
    begin
     If (Ret[RetNo].FormHasData[GetFormName(RetNo,FNo)]) and ('#'+FetchElmFNo(RetNo,FNo,3)=FInst)
      then k:=BuildT1273AP(RetNo,FNo,53,74,3,k);
    end;
   end;
  END;
end;

Function BuildCrop(RetNo:Integer;Fno:Integer;FromElm,ToElm,byElm:Integer;k:Integer):Integer;
//returns the last k used (howmany)
Var valu:string;Rec:String;
i:Integer;  //20101221
begin
  i:=FromElm;
  Repeat
   valu:=FetchElmFNo(RetNo,FNo,i); //code
   If valu>'' then
   begin
    //code
    Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'CD'
           +ElemSep+ElemSep+valu+LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    //un
    valu:=AllTrim(LeftStr(FetchElmFNo(RetNo,FNo,i+2),2));
    If valu >'' then
    begin
    Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'UN'
           +ElemSep+ElemSep+ElemSep+valu+LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    end;
    //AC
    valu:=Format1273Numerics(FetchElmFNo(RetNo,FNo,i+3),3);
    If valu >'' then
    begin
    Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'AC'
           +ElemSep+ElemSep+ElemSep+valu+LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    end;
    //QP
    valu:=Format1273Numerics(FetchElmFNo(RetNo,FNo,i+4),3);
    If valu >'' then
    begin
    Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'QP'
           +ElemSep+ElemSep+ElemSep+valu+LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    end;

    //EI
    valu:=Format1273Numerics(FetchElmFNo(RetNo,FNo,i+5),3);
    If valu >'' then
    begin
    Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'EI'
           +ElemSep+ElemSep+ElemSep+valu+LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    end;

    //MV
    valu:=Format1273Numerics(FetchElmFNo(RetNo,FNo,i+6),2);
    If valu >'' then
    begin
    Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'MV'
           +ElemSep+ElemSep+ElemSep+ElemSep+ElemSep+ElemSep+valu+LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    end;
    Inc(k,1);
   end;
   Inc(i,ByElm);
  until i>ToElm;
  result:=k;
end;

Function BuildLiveStock(RetNo:Integer;Fno:Integer;FromElm,ToElm,byElm:Integer;k:Integer):Integer;
//returns the last k used (howmany)
Var valu:string;Rec:String;
i:Integer;
begin
  i:=FromElm;
  Repeat
   valu:=FetchElmFNo(RetNo,FNo,i); //code
   If valu>'' then
   begin
    //code
    Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'TCD'
           +ElemSep+ElemSep+valu+LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);

    //EIL
    valu:=Format1273Numerics(FetchElmFNo(RetNo,FNo,i+2),3);
    If valu>'' then
    begin
     Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'EIL'
            +ElemSep+ElemSep+ElemSep+valu+LineSep+Crlf;
     Write(F1,Rec);Inc(SegmentCnt);
    end;

    //FMV
    valu:=Format1273Numerics(FetchElmFNo(RetNo,FNo,i+3),2);
    If valu>'' then
    begin
    Rec:= 'TIA'+ElemSep+'E'+AddLeadingZeros(IntToStr(k),2)+'FMV'
           +ElemSep+ElemSep+ElemSep+ElemSep+ElemSep+ElemSep+valu+LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    end;

    Inc(k,1);
   end;
   Inc(i,ByElm);
  until i>ToElm;
  result:=k;
end;


Function Format1273Numerics(s:String;Decimalplaces:Integer):String;
// comes as 123 or 1234.56  Needs 2 or 3 three decimals implied
var s1,s2:String;
begin
 s1:=ExtractIntegerPart(s);
 s2:=ExtractDecimalPart(s);
 result:=s1+PaddRZero(s2,DecimalPlaces);
 result:=RmvLeadingZeros(result);
 If result='' then result:='0';
end;

Procedure BuildAdditionalLivestock(RetNo:Integer;FNo:Integer;Line:String;valu:String);
Var Rec:String;
begin
  valu:=Format1273Numerics(valu,3);
  Rec:= 'TIA'+ElemSep+Line+ElemSep+ElemSep+ElemSep+valu+LineSep+Crlf;
  Write(F1,Rec);Inc(SegmentCnt);
end;

Procedure BuildT1273ALI(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer);
Var i:Integer;valu,Rec:String;
begin
  i:=FromElm;
  Repeat
   valu:=FetchElmFNo(RetNo,FNo,i); //code
   If valu>'' then  {code}
   begin
    Valu:=AddLeadingZeros(Valu,4);
    Rec:= 'TIA'+ElemSep+'OTH'+ElemSep+ElemSep+valu+ElemSep
           +Format1273Numerics(FetchElmFNo(RetNo,FNo,i+3),3)
          +LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
  end;
  Inc(i,ByElm);
  until i>ToElm;
end;

Function BuildT1273PI(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer):Integer;
Var valu:string;Rec:String;
i:Integer;  //20101221
begin
  i:=FromElm;
  Repeat
   valu:=FetchElmFNo(RetNo,FNo,i); //code
   If valu>'' then
   begin
    valu:=AddLeadingZeros(Valu,4);
    //SI, code, ending
    Rec:= 'TIA'+ElemSep+'E'+IntToStr(k)+'PI'
           +ElemSep+ElemSep+AddLeadingZeros(valu,3)
           +ElemSep+ElemSep+ElemSep+ElemSep
           +ExtractIntegerPart(FetchElmFNo(RetNo,FNo,i+2))
           +LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    Inc(k,1);
   end;
   Inc(i,ByElm);
  until i>ToElm;
  result:=k;
end;

Function BuildT1273DI(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer):Integer;
Var valu:string;Rec:String;
i:Integer;  //20101221
begin
  i:=FromElm;
  Repeat
   valu:=FetchElmFNo(RetNo,FNo,i); //code
   If valu>'' then
   begin
    //SI, code, ending
    valu:=AddLeadingZeros(Valu,4);
    Rec:= 'TIA'+ElemSep+'E'+IntToStr(k)+'DI'
           +ElemSep+ElemSep+AddLeadingZeros(valu,3)
           +ElemSep+ElemSep+ElemSep+ElemSep
           +ExtractIntegerPart(FetchElmFNo(RetNo,FNo,i+2))
           +LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    Inc(k,1);
   end;
   Inc(i,ByElm);
  until i>ToElm;
  result:=k;
end;

Function BuildT1273AP(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer):Integer;
Var valu:string;Rec:String;
i:Integer;   //20101221
begin
  i:=FromElm;
  Repeat
   valu:=FetchElmFNo(RetNo,FNo,i); //code
   If valu>'' then
   begin
    valu:=AddLeadingZeros(Valu,4);
    Rec:= 'TIA'+ElemSep+'E'+IntToStr(k)+'AP'
           +ElemSep+ElemSep+AddLeadingZeros(valu,3)
           +ElemSep+ElemSep+ElemSep+ElemSep
           +ExtractIntegerPart(FetchElmFNo(RetNo,FNo,i+2))
           +LineSep+Crlf;
    Write(F1,Rec);Inc(SegmentCnt);
    Inc(k,1);
   end;
   Inc(i,ByElm);
  until i>ToElm;
  result:=k;
end;

Procedure BuildPswRef(RetNo:Integer;OnLineMethod:String);  //eol only
Var Rec:String;
begin
 If IsHomeUse then exit;
 If OnlineMethod = 'EOL' then
 begin
   Rec:= 'REF'+ElemSep+'VU'+ElemSep+Password+LineSep+Crlf;
   Write(F1,Rec);Inc(SegmentCnt);
end;
end;



Function FgsHasData(RetNo:Integer;FNo:Integer;FromElm,ToElm,ByElm,k:Integer):Boolean;
Var i: integer; valu:string;Rec:String;
begin
  Result:=False;
  i:=FromElm;
  Repeat
   valu:=FetchElmFNo(RetNo,FNo,i); //code
   If valu>'' then
   begin
     Result:=True;
     Break;
   end;
   Inc(i,ByElm);
  until i>ToElm;
end;

Procedure ClearPartnersInfo;
Var i:Integer;
Begin
 For i:= 1 to 6 do
 begin
  SFD.PRec[i].PFirstName := '';
  SFD.PRec[i].PLastName  := '';
  SFD.PRec[i].PSin       := '';
  SFD.PRec[i].PPerCent   := '';
 end;
end;

Function  GetNumberOfBarCodeSFDs(RetNo:Integer):Integer;
Var RentSfds,BusSfds,ProfSfds,FarmSfds,FishSfds,NisaSfds,HCaisSfds,T777Sfds,TL2Sfds,T2091Sfds,T1255Sfds:Integer; //20210123
begin
 RentSfds:=0;BusSfds:=0;ProfSfds:=0;FarmSfds:=0;FishSfds:=0;NISASfds:=0;HCaisSfds:=0;
 T777Sfds:=0;Tl2Sfds:=0;T2091Sfds:=0; //T777sSFDS:=0;
 CountSfds(RetNo,RentSfds,BusSfds,ProfSfds,FarmSfds,FishSfds,NisaSfds,HCaisSfds,T777Sfds,TL2Sfds,T2091Sfds,T1255Sfds); //20210123
 Result:=RentSfds+BusSfds+ProfSfds+FarmSfds+FishSfds+NisaSfds+HCaisSfds+T777Sfds+TL2Sfds+T2091Sfds+T1255Sfds;  //20190129
 //Result := T777Sfds+TL2Sfds+T2091Sfds+FishSfds+FarmSfds+BusSfds+ProfSfds;
 If IsPreBankruptcyReturn(RetNo) then result:=0;
end;

end.
