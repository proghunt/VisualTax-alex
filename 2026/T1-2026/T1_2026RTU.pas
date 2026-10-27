unit T1_2026rtu;
//updated 07-18

{Notes:
Inputs: BatchOper: PRTU, TRTU, PSEND, TSEND
SomeList : First entry has the data directory
         i.e: C:\Data
               12345678.9
               45434567.1
           and then the Names of files for RTU
           IT MUST be copied to RetFiles list(defined here) because
           SomeList is used concurrently by the OpenReturn
}

interface

uses SysUtils,FileCtrl,WinTypes,Messages,Classes,Controls,Forms,StdCtrls,
  Dialogs;

Const SOFTRELEASE  = '20260214'; //20260214 ;;'20190214'; //20220513
Const DEVELOPER    = '064';  {Visual Tax}
Const CrLf         =  Chr(13)+Chr(10);
Const NisaBytes1   = 127;
Const NisaBytes2   = 28;
Const NisaBytes3   = 20; {11;}
Const FixedFormatLength  =361; //in 2009=359; //332+27  //332 in 2007; {280 in 2000} {T1 records}
Const FixedSFDLength  = 530; {528 in 2000}
Type
 PartnerRec = Record
  PFirstName    :string; //[30];
  PLastName     :string; //[30];
  PSin          :string; //[9];
  PPerCent      :string; //[6];  //new 2005
end;

Type
 AHDR = Record
  RECLEN         : string; //[4];
  RECTYPE        : string; //[2];
  TRANSMTYPE     : string; //[2];
  TRANSMITTERNO  : string; //[5];
  PREPARERID     : string; //[5];
  INDRES1        : string; //[10];
  INDRES2        : string; //[10];
  DATE           : string; //[8];
  TIME           : string; //[6];
  TRANSFLNO      : string; //[8];
  FILLER1        : string; //[40];
 end;

 Type
  AFX  = Record
  {T1REC FIXED PART}
  RECLEN          : string; //[4];
  RECTYPE         : string; //[2];
  PREPARERNO      : string; //[5];
  SEQNO           : string; //[8];
  PREPPSWD        : string; //[7];
  DISCNUMBER      : string; //[8];
  SIN             : string; //[9];
  BIRTHYYYY       : string; //[4];
  BIRTHMM         : string; //[2];
  BIRTHDD         : string; //[2];
  PRVOFRES        : string; //[2];
  PRVOFTAX        : string; //[2];
  MARSTATUS       : string; //[1];
  SPOUSESIN       : string; //[9];
  SPOUSENAME      : string; //[4];
  FIRSTNAME       : string; //[30];
  LASTNAME        : string; //[30];
  CAREOFNAME      : string; //[26];
  STREET          : string; //[60];
  CITY            : string; //[50];
  PROVINCE        : string; //[2];
  POSTAL          : string; //[6];
  CLAREA          : string; //[3];
  CLPHONE         : string; //[7];
  NAMECHANGE      : string; //[1];
  ALTADDR         : string; //[2];
  LANGUAGE        : string; //[1];
  GSTYESNO        : string; //[1];
  SPOUSENETINC    : string; //[9];
  SPOUSEUCCB      : string; //[9];

  //new in 2008  27 bytes
  ISDECEASED      : string; //[1];
  DATEOFDEATH     : string; //[8];
  ISPREBANKRUPT   : string; //[1];
  POSTBANKRUPTNI  : string; //[9];
  DATEOFBANKRUPTCY:string; //[8];
  //
  SFDRECS         : string; //[2];
  DEVELOPER       : string; //[3];
  SOFTCODE        : string; //[1];
  SOFTRELEASE     : string; //[8];
 // FILLER1         : string; //[9];   //????? OUT?  //done
  FDEADLINE       : string; //[1];
  CLAUTHORIZE     : string; //[1];
  AUTHORIZEEXPIRY : string; //[8];  //new in 2010 yyyymmdd    //DONE
  PREASSESSMENT   : string; //[1];  //New in 2010  //done
  POSTASSESSMENT  : string; //[1];  //New in 2010  //done
  CANCITIZEN      : string; //[1];  //New  //done
  ElectionsCanada : string; //[2];
  FNCValue        : string; //[1];  //new  //aboriginal land
  FIRSTNation     : string; //[5];
  CitizenFN       : string; //[1];   //20121225  NEW  Renamed From YT  //20170108
  ProvEffectiveDate : string; //[10];  //20121226  NEW
  PresentPrv      : string; //[2];
end;

 Type
  ASfd   = Record
  {SFD FIXEDTYPE}
  RECLEN         : string; //[4];
  RECTYPE        : string; //[2];
  PREPARERNO     : string; //[5];
  SEQNO          : string; //[8];
  SFDREC         : string; //[2];
  BUSTYPE        : string; //[1];
  SIC            : string; //[6];
  SIN            : string; //[9];
  BUSNAME        : string; //[30];
  BUSADDRESS     : string; //[30];
  BUSPOSTAL      : string; //[6];
  BUSFISCSTART   : string; //[8];
  BUSFISCEND     : string; //[8];
  ACROWNED       : string; //[9];
  ACRFARMED      : string; //[9];
  ACCMETHOD      : string; //[1];
  BUSPARTNID     : string; //[9];
  BUSPERCENT     : string; //[4];   {was}
  BUSTAXSHELTNO  : string; //[8];
  BUSFINALYR     : string; //[1];
  GSTACCNO       : string; //[15];

  PRec : Array[1..6] of PartnerRec;

end;

 Type
  ASEND   = Record
 {SEND}
  RECLEN        : string; //[4];
  RECTYPE       : string; //[2];
  PREPARERNO    : string; //[5];
  SEQNO         : string; //[8];
  PREPPSWD      : string; //[7];
  DISCNUMBER    : string; //[8];
  SIN           : string; //[9];
  BIRTHYYYY     : string; //[4];
  BIRTHMM       : string; //[2];
  BIRTHDD       : string; //[2];
  FIRSTNAME     : string; //[30];
  LASTNAME      : string; //[30];
  NAMECHANGE    : string; //[1];
  DEVELOPER     : string; //[3];
  SOFTCODE      : string; //[1];
  SOFTRELEASE   : string; //[8];
  FILLER1       : string; //[9];
  FILLER2       : string; //[4];
end;

Type
 ATrl   = Record
 {TRL}
  RECLEN         : string; //[4];
  RECTYPE        : string; //[2];
  RETURNS        : string; //[4];
  SFDRECS        : string; //[4];
  TRANSMRECS     : string; //[4];
end;


Function GetStreet(RetNo:Integer):String; //20171220
Function GetNetFileAmount(RetNo: integer;LLine: integer; LType: string;
    FName: string;ElmNo: integer;Rule:integer):String;

ProCedure RtuRoutine;
Procedure PrepareTrl;
Procedure AppendSend;
Procedure AppendT1Rec;
Procedure AddStringToBuffers(LLine:Integer;s:String);
Procedure RemoveLastDashFromBuffers;
Procedure EmptyTheBuffers;
Procedure PrepareSfds(RetNo:integer);
Procedure PrepareBusiness(FInst:String);
Procedure PrepareProfession(FInst:String);
Procedure PrepareFarming(FInst:String);
Procedure PrepareFishing(FInst:String);
Procedure PrepareRental(FInst:String);
Procedure AppendSfdRec;
//Procedure PrepareSend;
Procedure PrepareSend(RetNo: integer);
//Function IsEfOverride(Lline:Integer):Boolean;
//Function GetEfOverride(Lline:Integer):real;
Procedure PrepareHdr;
//Procedure PrepareT1Rec;
Procedure PrepareT1Rec(RetNo: integer);
{Function DoRules(Rule:Integer): Real;}
Function GetAmount(RetNo: integer;LLine: integer; LType: string;
    FName: string;ElmNo: integer;Rule:integer):String;
Function FormatFourDigitPercent(s:string):String;
Function FormatSixDigitPercent(s:string):String;
Function FormatBusPercent(s:string):String;
{Function IsRoomInBuffer(Buff:String;S:String):Boolean;}

Var
 Hdr  : AHdr;
 Fx   : AFx;
 SFD  : ASfd;
 SEND : ASEND;
 TRL  : ATRL;
 EFlines        : TStringList;
 TRANSMTYPE     : string; //[2];
 RTUNumber      : string; //[10];
 BatchOper      : String;
 DCNSeqNo       : Integer;
 DataDir        : string;
 EFileDir       : String;
 EncDir         : String;
 FlName         : string; //[12];  {the output RTU}
 RetFile        : string; //[12]; {the return file being processed}
 F1             : TextFile;    {output file}
 TotT1Recs      : Integer;
 SfdRecNumber   : Integer; {sfd counter on each return}
 SfdRecs,TotSfdRecs     : Integer;

 HdrRec, {FxRec1,FxRec2,SfDRec1,SfdRec2,SfdRec3,}SendRec, TrlRec : String; {pascal strings}
 FreeBuffer,FxRec,SfdRec:AnsiString;
 {FreeBuff1,FreeBuff2,FreeBuff3,FreeBuff4,FreeBuff5,FreeBuff6 :String;}
 RetFiles       : TStringList;
 RTUContents    : TstringList;

Implementation

uses vtMulti,vtCommon,vtDialogs,T1_2026,T1_2026TrimStr,T1_2026T1Rtns,
  T1_2026Declare,T1_2026Common,T1_2026Common2,T1_2026EFRules,T1_2026Clients,
  vtTrimStr,vtShared;

Procedure RtuRoutine;
Var i, RetNo :integer; s:String;
RentSfds,BusSfds,ProfSfds,FarmSfds,FishSfds,NisaSfds,HCaisSfds,T777Sfds,TL2Sfds,T2091Sfds,T1255Sfds:integer;  //20210223
begin
 If LeftStr(BatchOper,1) = 'D' then
   DcnSeqNo :=
    MyStrToInt(InputBox('Input Box', 'Enter starting DCN no.', '001'));

 Retfiles := TstringList.Create;
 For i:= 0 to SomeList.Count -1 do  RetFiles.Add(Somelist[i]);

 DataDir    := RetFiles[0];
 EFileDir   := LTRIM(RTRIM(OptRec.EF_DataDir));
 EncDir     := LTRIM(RTRIM(OptRec.EF_EncDir));
 TotT1Recs  := 0; {incr with each append}
 TotSfdRecs := 0;  {Incr with each apend}
 SfdRecs :=0;SfdRecNumber :=0;
 If not DirectoryExists(EfileDir) then
   begin
    ShowMessage('Efile directory '+EfileDir +' does not exist');
    exit;
   end;
 If (OptRec.Ef_PrepNo = '') or
    (OptRec.Ef_TransNo = '') or
    (OptRec.Ef_PsWord = '') or
    (OptRec.Ef_EncDir = '') or
    (OptRec.Ef_TransNo = '') or
    (OptRec.Ef_TransNo = '') or
    (OptRec.Ef_TransNo = '') then
   begin
   ShowMessage('Missing EFile set up data. Please complete them first');
   exit;
   end;
 RtuNumber := MakeEFFileName(LicenseName);  //(LicenseLevel);
 {RtuNumber := InputBox('EFile','Enter Rtu Name (8 continuous characters','');}

 If RtuNumber  = '' then exit;
 If (BatchOper = 'PRTU') or   {Production/Test RTU}
    (BatchOper = 'TRTU') or
    (BatchOper = 'DRTU') then
     FlName := RtuNumber +'.RTU'
 Else
   FlName := RtuNumber +'.RTS';

 If (FileExists(EfileDir+'\'+RtuNumber+'.RTU'))
  or (FileExists(EfileDir+'\'+RtuNumber+'.RTS'))
  or (FileExists(EfileDir+'\'+RtuNumber+'.RTX'))
 then
 begin
  ShowMessage('RTU '+RtuNumber+' name already exists. Try again');
  exit;
 end;

 RtuContents := TstringList.Create;
 AssignFile(F1, EfileDir + '\'+FlName);
 ReWrite(F1);
 PrepareHdr;
 {Read each file from the list}
 For i := 1 to RetFiles.Count -1 do {I=0 contains the datadir}
 begin
   Clients.ListBox1.ItemIndex :=i;
   Clients.ListBox1.Refresh;
   If DCNSeqNo >0 then DcnSeqNo := DcnSeqNo +1; {only if assigned}
   RetFile := RetFiles[i];

   if CheckReturnAndPsw(DataDir,RetFile, AppT1_2026.SQLLitePassword.PassRFArray) = False then //20160415 Igor
   begin
     //ShowTimedMsg('Invalid Password',900);
     //RemoveReturnFromMemory(RetNo);
     CloseFile(F1);
     SysUtils.DeleteFile(EfileDir+'\'+FlName);
     ShowMessage('RTU has NOT been created');
     exit;
   end;

   RetNo := ReadReturn(DataDir,RetFile);
   if RetNo < 1 then  {it calcs all}
   begin
      //RemoveReturnFromMemory(RetNo);
      ShowOpenReturnFailure(RetNo,DataDir,RetFile);
      CloseFile(F1);
      SysUtils.DeleteFile(EfileDir+'\'+FlName);
      ShowMessage('RTU has NOT been created');
      exit;
     end;
   UpdateAllDataIndicators(RetNo);
   {check number of SFD's}
   RentSfds:=0;BusSfds:=0;ProfSfds:=0;FarmSfds:=0;FishSfds:=0;TL2Sfds:=0;
   CountSfds(RetNo,RentSfds,BusSfds,ProfSfds,FarmSfds,FishSfds,NisaSfds,HCaisSfds,T777Sfds,Tl2Sfds,T2091Sfds,T1255Sfds);
   SfdRecs := RentSfds+BusSfds+ProfSfds+FarmSfds+FishSfds+NisaSfds+T777Sfds+TL2Sfds;
   IF SfdRecs > 6 THEN
     ShowMessage('More than 6 SFDs in return of'+Chr(13)+
                 GetFirstName(RetNo)+' '+GetLastName(RetNo)+Chr(13)+
                 'It will be rejected by EFile');
   IF RightStr(BatchOper,3) ='RTU' THEN
     begin
      PrepareT1Rec(RetNo);
      AppendT1Rec;
      PrepareSfds(RetNo);
     end;
   IF RightStr(BatchOper,4) ='SEND' THEN begin PrepareSend(RetNo);AppendSend;end;
   RemoveReturnFromMemory(RetNo);
 End;
 PrepareTrl;
 CloseFile(F1);
 {
 if MessageDlg('RTU '+RtuNumber+' has been created'+Chr(13)+
    'Encrypt it?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
 begin
 }
 Screen.Cursor := crHourGlass;
 IF BatchOper      ='PRTU' then Clients.Encrypt(FlName,'RTU','PROD')
 else if BatchOper ='TRTU' then Clients.Encrypt(FlName,'RTU','TEST')
 else if BatchOper ='PSEND' then Clients.Encrypt(FlName,'SEND','PROD')
 else if BatchOper ='TSEND' then Clients.Encrypt(FlName,'SEND','TEST')
 else iF BatchOper ='DRTU' then Clients.Encrypt(FlName,'RTU','TEST')
 else if BatchOper ='DSEND' then Clients.Encrypt(FlName,'SEND','TEST');
 {end;}
 SendRec := '';
 TrlRec  := '';
 SfdRec  :='';
 {
 SfdRec1  := '';
 SfdRec2  := '';
 SfdRec3  := '';
 }
 RetFiles.Free;
 If MidStr(BatchOper,2,3) = 'RTU' then
   RtuContents.SaveToFile(OptRec.Ef_datadir+'\'+RTuNumber+'.LIN');
 RtuContents.Free;
 Screen.Cursor := crDefault;
end;

Procedure PrepareHdr;
Var I : integer;
begin
 HDRREC:='';
 HDR.RECLEN        :='0100';
 HDR.RECTYPE       :='01';

 IF BatchOper      = 'PRTU' THEN HDR.TRANSMTYPE   := '01'
 ELSE if BatchOper = 'TRTU' THEN HDR.TRANSMTYPE   := '02'
 ELSE if BatchOper = 'PSEND' THEN HDR.TRANSMTYPE   := '11'
 ELSE if BatchOper = 'TSEND' THEN HDR.TRANSMTYPE   := '12'
 ELSE if BatchOper = 'DRTU' THEN HDR.TRANSMTYPE   := '07'
 ELSE if BatchOper = 'DSEND' THEN HDR.TRANSMTYPE   := '17';
 HDR.TRANSMITTERNO := OptRec.Ef_TRANSNo;
 HDR.PREPARERID    := OptRec.Ef_PrepNo;
 HDR.INDRES1       := RTUNUMBER+'0000000000';
 HDR.INDRES2       := LeftStr(User.UserName,4)+'000000'; {'0000000000';} //20170112 Igor
 HDR.DATE          := '00000000';
 HDR.TIME          := '000000';
 HDR.TRANSFLNO     := '00000000';
 HDR.FILLER1       := '0000000000000000000000000000000000000000';

 HDRREC := '0100'+PaddR(HDR.RECTYPE,2)+PaddR(HDR.TRANSMTYPE,2)+
           PaddR(HDR.TRANSMITTERNO,5)+PaddR(HDR.PREPARERID,5);
 HDRREC := HDRREC+PaddR(HDR.INDRES1,10)+PaddR(HDR.INDRES2,10)+PaddR(HDR.DATE,8)+
                PaddR(HDR.TIME,6)+PaddR(HDR.TRANSFLNO,8)+HDR.FILLER1;
 For i := 1 to Length(HdrRec) do
  Write(F1,MidStr(HDRRec,i,1));

 Write(F1, Chr(13));
 Write(F1, Chr(10));

 {Write(F1,Crlf);}
 HDRREC :='';
end;

Procedure PrepareT1Rec(RetNo: integer);
Var i, Rule, LLine,ElmNo:integer;
  LType, FName, S, LLineString:String;
Begin
   EmptyTheBuffers;
   SfdRecNumber :=0;
  {FIXED PART}
   FX.RECTYPE       := '02';
   FX.PREPARERNO    := OptRec.Ef_PrepNo;
   FX.PREPPSWD      := OptRec.Ef_PsWord;
   If FetchElm(RetNo,'T1',47) ='3' then {discounted return}
     FX.DISCNUMBER  := OptRec.Prp_DiscNo
   ELSE
     FX.DISCNUMBER  := '00000000';
   FX.SIN         := RemoveHyphens(FetchElm(RetNo,'T1',3));
   FX.SEQNO       := LEFTStr(FX.SIN,8);

     If (LeftStr(BatchOper,1) = 'D') and (DcnSeqNo >0) then
       FX.SEQNO := PaddZero(IntToStr(DcnSeqNo),8);
     FX.BIRTHYYYY   := PaddZero(LeftStr(FetchElm(RetNo,'T1',9),4),4);
     FX.BIRTHMM     := PaddZero(MidStr(FetchElm(RetNo,'T1',9),6,2),2);
     FX.BIRTHDD     := PaddZero(RightStr(FetchElm(RetNo,'T1',9),2),2);

     FX.PRVOFRES    := Ret[RetNo].Province;
     FX.PRVOFTAX    := Ret[RetNo].PROVince;
     FX.MARSTATUS   := IntToStr(Ret[RetNo].MarStatus);
     FX.SPOUSESIN   := FetchElm(RetNo,'T1',4);
     IF FX.SPOUSESIN ='' THEN FX.SPOUSESIN:='000000000';
     FX.SPOUSENAME  := FetchElm(RetNo,'T1',20);
     FX.FIRSTNAME   := FetchElm(RetNo,'T1',2);
     FX.LASTNAME    := LeftStr(FetchElm(RetNo,'T1',5),30);
     FX.CAREOFNAME    := FetchElm(RetNo,'T1',8);
     FX.STREET        :=GetStreet(RetNo);

     FX.CITY          := FetchElm(RetNo,'T1',10);
     If Length(FetchElm(RetNo,'T1',14)) = 2 then
      FX.PROVINCE  := FetchElm(RetNo,'T1',14)
     else
       FX.PROVINCE := GetShortPrv(FetchElm(RetNo,'T1',14));
     {If FX.PROVINCE = 'NU' then FX.PROVINCE := 'NT';}
     FX.POSTAL        := Mtrim(FetchElm(RetNo,'T1',15));
     FX.CLAREA:= PaddZero(FetchElm(RetNo,'T1',441),3);
     FX.CLPHONE:= PaddZero(RemoveHyphens(MTrim(FetchElm(RetNo,'T1',442))),7);
     If UpperCase(FetchElm(RetNo,'T1',56)) = 'Y' then  {changed name}
      FX.NAMECHANGE := '2'
     else
      FX.NAMECHANGE := '1';

   If (UpperCase(FetchElm(RetNo,'T1',29)) = 'X') then
      FX.GSTYESNO := '1'
   else
      FX.GSTYESNO := '2';


   If FetchElm(RetNo,'T1',49) = '' then
     FX.ALTADDR := '00'
   else
     FX.ALTADDR := FetchElm(RetNo,'T1',49);

  If FetchElm(RetNo,'T1',34) >'' then
     FX.LANGUAGE := '1'
   else
     FX.LANGUAGE := '2';

  Fx.SPOUSENETINC := PaddZero(NoDecimal(FloatToStr(Vl(FetchElmFNo(RetNo,InfoFno,19)))), 9); //20190131
  //FX.SPOUSENETINC:=PaddZero(NoDecimal(FloatToStr(SpouseIncome(RetNo))),9);
  IF SpouseIncome(RetNo) <= 0 THEN FX.SPOUSENETINC :='000000000';
  If (Ret[RetNo].MarStatus > 2) and
    (FetchElm(RetNo,'T1',65) ='') then FX.SPOUSENETINC :='000000000'; {death}

  // new in 2008
  If IsDeceased(RetNo) then
  begin
        FX.ISDECEASED  :='1';
        FX.DATEOFDEATH :=ReplaceChar(FetchElm(RetNo,'INFO',24),'-','')
  end
  else
  begin
        FX.ISDECEASED  :='0';
        FX.DATEOFDEATH :='00000000';
  end;

  If IsPreBankruptcyReturn(RetNo) then
  begin
        FX.ISPREBANKRUPT    :='1';
        FX.POSTBANKRUPTNI   := PaddZero(NoDecimal(FloatToStr(Vl(FetchElm(RetNo,'BANKRPT',13)))),9);
        FX.DATEOFBANKRUPTCY :=ReplaceChar(FetchElm(RetNo,'BANKRPT',1),'-','')

  end
  else
  begin
        FX.ISPREBANKRUPT    :='0';
        FX.POSTBANKRUPTNI   :='000000000';
        FX.DATEOFBANKRUPTCY :='00000000';
  end;

   FX.SFDRECS          := PaddZero(IntToStr(SfdRecs),2);
   FX.DEVELOPER        := DEVELOPER;
   FX.SOFTCODE         := ' ';
   FX.SOFTRELEASE      := SOFTRELEASE;
  // FX.FILLER1          := '000000000';
   If FetchElm(RetNo,'T1',36) > '' then
      FX.FDEADLINE := '1'
   else
      FX.FDEADLINE := '0';

   If (UpperCase(FetchElm(RetNo,'T183',25)) = 'Y')
   or (UpperCase(FetchElm(RetNo,'T183',25)) = 'X')
    then
      FX.ClAuthorize := '1'
   else
      FX.ClAuthorize := '0';

   If FetchElm(RetNo,'T183',22)>'' then
     FX.AUTHORIZEEXPIRY:=ReplaceChar(FetchElm(RetNo,'T183',22),'-','')
   else
     FX.AUTHORIZEEXPIRY:='00000000';

   FX.PREASSESSMENT := '0';
   If FetchElm(RetNo,'INFO',104) >'' then FX.PREASSESSMENT:='1'
   Else If FetchElm(RetNo,'INFO',105) >'' then FX.PREASSESSMENT:='2'
   Else If FetchElm(RetNo,'INFO',106) >'' then FX.PREASSESSMENT:='3';

   FX.POSTASSESSMENT := '0';
   If FetchElm(RetNo,'INFO',133) >'' then FX.POSTASSESSMENT:='1'
   Else If FetchElm(RetNo,'INFO',134) >'' then FX.POSTASSESSMENT:='2'
   Else If FetchElm(RetNo,'INFO',135) >'' then FX.POSTASSESSMENT:='3';

   If FetchElm(RetNo,'INFO',164) >'' then
      FX.CANCITIZEN := '1'
   else
      FX.CANCITIZEN := '2';

   If UpperCase(FetchElm(RetNo,'T1',43)) >'' then
      FX.ElectionsCanada := '01'
   else
      FX.ElectionsCanada := '02';


   FX.FncValue :='0';
   FX.FncValue :=GetFncValue(RetNo);

   If GetFirstNationNumber(RetNo) >'' then
    FX.FirstNation := GetFirstNationNumber(RetNo)
   else
    FX.FirstNation := '00000';

  // FX.ContactValue := FetchElm(RetNo,'T1',53);

   FX.PresentPrv := FetchElm(RetNo,'T1',66);

  {FREE FORMAT PART}
  Eflines := TstringList.Create;
  EfLines.LoadFromFile(AppDir+'\'+GetEfileDname(RetNo)); //'EFLINE.D');
   {      12345678901234567890123
  {Format nnn $ fffffffff elm rrr}
  RtuContents.Add(' ---------------------------------');
  RtuContents.Add(FX.LastName+','+FX.FirstName);
  RtuContents.Add('SIN='+FX.SIN);
  RtuContents.Add('RTU='+RtuNumber);


  For i := 0 to Eflines.Count - 1 do
   begin
    //20190709 Igor >>>
    LLine := MyStrToInt(AllTrim(LeftStr(Eflines[i],5)));
    //If lline=6156 then ShowMessage(Eflines[i]);
    If LLine = 9999 then break; {???????????????}
    LType := UpperCase(MidStr(Eflines[i],6,1));
    FName := AllTrim(MidStr(Eflines[i],8,9));
    ElmNo := MyStrToInt(AllTrim(MidStr(Eflines[i],18,3)));
    If MidStr(Eflines[i],22,1) = 'R' then
      Rule := MyStrToInt(AllTrim(MidStr(Eflines[i],23,4)))
    else
      Rule := 0;
    //20190709 Igor <<<
    If LLine>0 then  //20191129
    //If ((LLine>0) and (ElmNo >0)) or ((LLine>0) and (Rule >0))  //20191129
    begin
       S := GetAmount(RetNo,LLine,LType,FName,ElmNo,Rule);

       If S > '' then
        begin
         If LLine <100 then
            LLineString := PaddZero(IntToStr(LLine),3)
         else
            LLineString :=IntToStr(LLine);

         FREEBuffer := FREEBuffer + LLineString+s+ '-';

         RtuContents.Add(LLineString+'='+s);
        end;
    end;
   end;

  IF      RIGHTStr(FREEBuffer,1) = '-' THEN
    FreeBuffer := LeftStr(FREEBuffer,LENGTH(FREEBuffer)-1);
  EFLines.Free;
End;

Procedure PrepareSend(RetNo: integer);
Begin
   SEND.RECLEN      := '0137';
   SEND.RECTYPE     := '04';
   SEND.PREPARERNO  := OptRec.Ef_PrepNo;
   SEND.SIN         := FetchElm(RetNo,'T1',3);
   SEND.SEQNO       := LEFTStr(SEND.SIN,8);
   If LeftStr(BatchOper,1) = 'D' then
     SEND.SEQNO  := PaddZero(IntToStr(DcnSeqNo),8);

   SEND.PREPPSWD    := OptRec.EF_PsWord;
   SEND.DISCNUMBER  := OptRec.Prp_DISCNo;

   SEND.BIRTHYYYY   := PaddZero(LeftStr(FetchElm(RetNo,'T1',9),4),4);
   SEND.BIRTHMM     := PaddZero(MidStr(FetchElm(RetNo,'T1',9),6,2),2);
   SEND.BIRTHDD     := PaddZero(RightStr(FetchElm(RetNo,'T1',9),2),2);

   SEND.FIRSTNAME   := FetchElm(RetNo,'T1',2);
   SEND.LASTNAME    := LeftStr(FetchElm(RetNo,'T1',5),30);
   If UpperCase(FetchElm(RetNo,'T1',56)) = 'Y' then  {change Name}
      SEND.NAMECHANGE := '2'
   else
      SEND.NAMECHANGE := '1';
   SEND.DEVELOPER   := DEVELOPER;
   SEND.SOFTCODE    := ' ';
   SEND.SOFTRELEASE := SOFTRELEASE;
   SEND.FILLER1     := '000000000';
   SEND.FILLER2     := '0000';
end;

Procedure PrepareTrl;
Var i,TransmRecs : integer;
Begin
 TRLREC         := '';
 TRL.RECLEN     :='0018';
 TRL.RECTYPE    :='99';
 Trl.Returns    := PaddZero(IntToStr(TotT1Recs),4);
 Trl.SfdRecs    := PaddZero(IntToStr(TotSfdRecs),4);
 IF RightStr(BatchOper,4) = 'SEND' THEN TRL.SFDRECS:='0000';
 TransmRecs     := TotT1Recs+ TotSfdRecs;
 Trl.TransmRecs := PaddZero(IntToStr(TransmRecs),4);
 TRLREC:=TRL.RECLEN+TRL.RECTYPE+PaddZero(TRL.RETURNS,4)+
         PaddZero(TRL.SFDRECS,4)+PaddZero(TRL.TRANSMRECS,4);
 For i := 1 to Length(TrlRec) do
   Write(F1,MidStr(TrlRec,i,1));

 Write(F1,Chr(13));
 Write(F1,Chr(10));
 
 TRLREC :='';
end;

Procedure PrepareSfds(RetNo:Integer);
Var i:Integer;
begin
 For i:= 1 to 6 do
 begin
  SFD.PRec[i].PFirstName := '';
  SFD.PRec[i].PLastName  := '';
  SFD.PRec[i].PSin       := '000000000';
  SFD.PRec[i].PPerCent   := '00';
 end;

 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If ((Frec.FormInst>'') and (Ret[RetNo].FormHasData[Frec.FormName+Frec.FormInst])) then  //20160813
   begin
     If Frec.FormName = 'T776'  then
      begin PrepareRental(Frec.FormInst);AppendSfdRec;end
     Else If Frec.FormName = 'T2124' then
      begin PrepareBusiness(Frec.FormInst);AppendSfdRec;end
     Else If Frec.FormName = 'T2042' then
      begin PrepareFarming(Frec.FormInst);AppendSfdRec;end
     Else If Frec.FormName = 'T2121' then
      begin PrepareFishing(Frec.FormInst);AppendSfdRec;end;
   end;
 end;
end;


Procedure AppendT1Rec;
Var I :integer;s:string;
Begin
  i := FixedFormatLength+Length(FreeBuffer);

  {
  i := FixedFormatLength+Length(FreeBuff1)+Length(FreeBuff2)+Length(FreeBuff3)
       +Length(FreeBuff4)+Length(FreeBuff5)+Length(FreeBuff6);
  }
  Fx.RecLen := PaddZero(IntToStr(i),4);{JustRight(IntToStr(i),4);}
  If LeftStr(Fx.RecLen,1) = ' '  then Fx.RecLen := '0'+Ltrim(Fx.RecLen);

  FXREC     := FX.RECLEN+ PaddR(FX.RECTYPE,2)+PaddR(FX.PREPARERNO,5)+
               PaddR(FX.SEQNO,8)+PaddR(FX.PREPPSWD,7)+
               PaddR(FX.DISCNUMBER,8)+PaddR(FX.SIN,9);

  FXREC     := FXREC+PaddR(FX.BIRTHYYYY,4)+PaddR(FX.BIRTHMM,2)+
               PaddR(FX.BIRTHDD,2)+PaddR(FX.PRVOFRES,2)+
               PaddR(FX.PRVOFTAX,2);
  FXREC     := FXREC+PaddR(FX.MARSTATUS,1)+PaddR(FX.SPOUSESIN,9)+
               PaddR(FX.SPOUSENAME,4)+PaddR(FX.FIRSTNAME,30)+
               PaddR(FX.LASTNAME,30);
  FXREC     := FXREC+PaddR(FX.CAREOFNAME,26)+PaddR(FX.STREET,60)+
               PaddR(FX.CITY,50)+PaddR(FX.PROVINCE,2)+PaddR(FX.POSTAL,6)+
               PaddR(FX.CLAREA,3)+PaddR(FX.CLPHONE,7);
  FXREC     := FXREC+PaddR(FX.NAMECHANGE,1)+PaddR(FX.ALTADDR,2)+
               PAddR(FX.LANGUAGE,1)+PaddR(FX.GSTYESNO,1)+{PaddR(FX.KIDSUNDER19,2)+}
               PaddR(FX.SPOUSENETINC,9);
  //new 2008
  FXREC     := FxRec+PaddZero(FX.ISDECEASED,1)+PaddZero(FX.DATEOFDEATH,8)+PaddZero(FX.ISPREBANKRUPT,1)+PaddZero(FX.POSTBANKRUPTNI,9)
               +PaddZero(FX.DATEOFBANKRUPTCY,8);

  FXREC     := FxRec+PaddR(FX.SFDRECS,2)+PaddR(FX.DEVELOPER,3)+FX.SOFTCODE +PaddR(FX.SOFTRELEASE,8)
               +PaddR(FX.FDEADLINE,1)+PaddR(Fx.ClAuthorize,1)+PaddZero(FX.AUTHORIZEEXPIRY,8)
               +PaddR(Fx.PREASSESSMENT,1)+PaddR(Fx.POSTASSESSMENT,1)+PaddR(Fx.CANCITIZEN,1)+PaddR(Fx.ElectionsCanada,2)
               +PaddR(Fx.FnCValue,1)+PaddR(Fx.FirstNation,5)+PaddR(Fx.PresentPrv,2);

 For i := 1 to Length(FxRec) do
  Write(F1,MidStr(FxRec,i,1));
 For i := 1 to Length(FreeBuffer) do
  Write(F1,MidStr(FreeBuffer,i,1));

 Write(F1, Chr(13));
 Write(F1, Chr(10));
    {appendinf t1recs}
 EmptyTheBuffers;
 Inc(TotT1Recs);
end;


Procedure AppendSend;
Var I : integer;
begin
  SENDREC:=SEND.RECLEN+SEND.RECTYPE+PaddR(SEND.PREPARERNO,5)+
           PaddR(SEND.SEQNO,8)+PaddR(SEND.PREPPSWD,7);
  SENDREC:=SENDREC+PaddR(SEND.DISCNUMBER,8)+PaddR(SEND.SIN,9)+
           PaddR(SEND.BIRTHYYYY,4)+PaddR(SEND.BIRTHMM,2)+
           PaddR(SEND.BIRTHDD,2);
  SENDREC:=SENDREC+PaddR(SEND.FIRSTNAME,30)+PaddR(SEND.LASTNAME,30)+
           PaddR(SEND.NAMECHANGE,1)+PaddR(SEND.DEVELOPER,3)+
           PaddR(SEND.SOFTCODE,1)+PaddR(SEND.SOFTRELEASE,8);
  SENDREC:=SENDREC+PaddR(SEND.FILLER1,9)+PaddR(SEND.FILLER2,4);
 For i := 1 to Length(SendRec) do
    Write(F1,MidStr(SendRec,i,1));

 Write(F1,Chr(13));
 Write(F1,Chr(10));

 {Write(F1,Crlf);}
 Inc(TotT1Recs);
 SendRec   := '';
end;

Function GetAmount(RetNo: integer;LLine: integer; LType: string;
    FName: string;ElmNo: integer;Rule:integer):String;
Var LAmount : real;LSAmount:String;FNo:Integer;
begin

 case rule of
 0: begin
     FName := LTrim(RTrim(FName));
     If LType ='N' then
     begin
      If FName = '' then
      begin
       result := FloatToStr(Ret[RetNo].Lnn[ElmNo])
      end
      else
       result:= Ltrim(Rtrim(FetchElm(RetNo,FName, ElmNo)));

      If Vl(result)=0 then result :='';

      If Vl(result)<0 then
        result := '&'+MidStr(result,2,30);
      exit;
     end;

     IF FName = '' THEN
       LAmount := Ret[RetNo].Lnn[ElmNo]
     ELSE
     begin
       LAmount := Vl(FetchElm(RetNo,FName, ElmNo));
     end;
    end;
 else
  LAmount :=DoRules(RetNo,Rule); {RETURNS LAMOUNT}
 end;

 If (LLine>0) then
   if IsEFOverride(RetNo,LLine) then
     LAmount := GetEFOverride(RetNo,LLine);

 If (LAmount=0) and (Fname='') and (ElmNo=260) then
  begin result :='0';exit;end;
 IF LAmount =0 THEN begin Result := '';exit;end;

 {Convert LAMOUNT to String}
 IF (LTYPE = '$') THEN
    begin
     Result := IntToStr(Round(LAmount)); {CENTS}
    end;
 IF (LTYPE = 'N') then
    Result := IntToStr(Round(Lamount));

 IF LTYPE = 'C' THEN
 begin
   result := IntToStr(Round(LAmount * 100)); {CENTS}
 end;

 Result := AllTrim(result);
 If LAmount <0 then Result := '&'+MidStr(Result,2,30);

end;


Procedure PrepareProfession(FInst:String);
begin
End;

Procedure PrepareFarming(FInst:String);
begin
End;

Procedure EmptyTheBuffers;
begin
 FreeBuffer:='';
end;

Procedure PrepareBusiness(FInst:String);
begin
End;

Procedure RemoveLastDashFromBuffers;
begin
  If  RIGHTStr(FREEBuffer,1) = '-' THEN
    FreeBuffer := LeftStr(FREEBuffer,LENGTH(FREEBuffer)-1);
end;


Procedure AddStringToBuffers(LLine:Integer;s:String);
begin
      FREEBuffer := FREEBuffer + IntToStr(LLine)+s+ '-';
end;

Procedure PrepareFishing(FInst:String);
begin
End;

Procedure PrepareRental(FInst:String);
begin
End;


Procedure AppendSfdRec;
Var I:integer;
begin
 {Asseble the record}
 i:= FixedSfdLength+NisaBytes1+NisaBytes2+NisaBytes3+Length(FreeBuffer);
 Sfd.RecLen := PaddZero(IntToStr(i),4);
 If LeftStr(Sfd.RecLen,1) = ' '  then Sfd.RecLen := '0'+Ltrim(Sfd.RecLen);

 SFDREC:=SFD.RECLEN+PaddR(SFD.RECTYPE,2)+PaddR(SFD.PREPARERNO,5)+
         PaddR(SFD.SEQNO,8)+PaddR(SFD.SFDREC,2);
 SFDREC:=SFDREC+PaddR(SFD.BUSTYPE,1)+PaddR(SFD.SIC,6)+PaddR(SFD.SIN,9);
 SFDREC:=SFDREC+PaddR(SFD.BUSNAME,30)+PaddR(SFD.BUSADDRESS,30)+
         PaddR(SFD.BUSPOSTAL,6);
 SFDREC:=SFDREC+PaddR(SFD.BUSFISCSTART,8)+PaddR(SFD.BUSFISCEND,8)+
         PaddR(SFD.ACROWNED,9)+PaddR(SFD.ACRFARMED,9)+
         PaddR(SFD.ACCMETHOD,1)+PaddR(SFD.BUSPARTNID,9);
 SFDREC:=SFDREC+PaddR(SFD.BUSPERCENT,4)+PaddR(SFD.BUSTAXSHELTNO,8)+
         PaddR(SFD.BUSFINALYR,1)+PaddR(SFD.GSTACCNO,15);

 SFDREC:= SfdRec+PaddR(SFD.Prec[1].PFirstName,30)+PaddR(SFD.Prec[1].PLastName,30)+
         PaddR(SFD.Prec[1].PSin,9)+PaddR(SFD.Prec[1].PPerCent,2);
 SFDREC:= SFDREC+PaddR(SFD.Prec[2].PFirstName,30)+PaddR(SFD.Prec[2].PLastName,30)+
         PaddR(SFD.Prec[2].PSin,9)+PaddR(SFD.Prec[2].PPerCent,2);
 SFDREC:= SFDREC+PaddR(SFD.Prec[3].PFirstName,30)+PaddR(SFD.Prec[3].PLastName,30)+
         PaddR(SFD.Prec[3].PSin,9)+PaddR(SFD.Prec[3].PPerCent,2);
 SFDREC:= SfdRec+PaddR(SFD.Prec[4].PFirstName,30)+PaddR(SFD.Prec[4].PLastName,30)+
         PaddR(SFD.Prec[4].PSin,9)+PaddR(SFD.Prec[4].PPerCent,2);
 SFDREC:= SfdRec+PaddR(SFD.Prec[5].PFirstName,30)+PaddR(SFD.Prec[5].PLastName,30)+
         PaddR(SFD.Prec[5].PSin,9)+PaddR(SFD.Prec[5].PPerCent,2);


 For i := 1 to Length(SfdRec) do
  Write(F1,MidStr(SfdRec,i,1));
 For i := 1 to NisaBytes1 do  Write(F1,' ');
 For i := 1 to NisaBytes2 do  Write(F1,'0');
 For i := 1 to NisaBytes3 do  Write(F1,'0');


 For i := 1 to Length(FreeBuffer) do
   Write(F1,MidStr(FreeBuffer,i,1));
 Write(F1, Chr(13));
 Write(F1, Chr(10));

 {Write(F1,Crlf);}
 Inc(TotSfdRecs);
 EmptyTheBuffers;
end;

Function FormatFourDigitPercent(s:string):String;
Var s1:String;x:real;
begin
 If Vl(s)>=100 then begin result :='0000';exit;end;
 x:= 100 * Vl(s);
 S1:= FloatToStr(x);
 Result:=AllTrim(PaddZero(ExtractIntegerPart(s1),4));
end;

//jz //20230206
Function FormatSixDigitPercent(s:string):String;
Var s1:String;x:real;
begin
 If Vl(s)>100 then begin result :='000000';exit;end;
 x:= 10000 * Vl(s);
 S1:= FloatToStr(x);
 Result:=AllTrim(PaddZero(ExtractIntegerPart(s1),6));
end;

Function FormatBusPercent(s:string):String;
Var s1:String;x:Real;
begin
 If Vl(s)=100 then begin result :='00';exit;end;
 Result:=FormatFloat('000000',Vl(s) * 10000); //4 decimals
end;

Function GetNetFileAmount(RetNo: integer;LLine: integer; LType: string;
    FName: string;ElmNo: integer;Rule:integer):String;
Var LAmount : real;LSAmount:String;FNo:Integer;
begin
 Result:='';   //20121208

 case rule of
 0: begin
     FName := LTrim(RTrim(FName));
     If LType ='N' then
     begin
      If FName = '' then
      begin
       result := FloatToStr(Ret[RetNo].Lnn[ElmNo])
      end
      else
      begin
       result:= Ltrim(Rtrim(FetchElm(RetNo,FName, ElmNo)));
       If lline=9956 then result:=AddLeadingZeros(result,2);  //20171203
      end;

      If Vl(result)=0 then result :='';
      {If Vl(result)<0 then result := '&'+MidStr(result,2,30);}
      exit;
     end;

     IF FName = '' THEN
     begin
      If (ElmNo>=lnLowBound) and (ElmNo<=lnHighBound) then
       //If (ElmNo>='10100' and (ElmNo<='48500') then       //20190728  not needed for current year
        LAmount := Ret[RetNo].Lnn[ElmNo]
     end
     ELSE
     begin
       LAmount := Vl(FetchElm(RetNo,FName, ElmNo));
     end;
    end;
 else
  LAmount :=DoRules(RetNo,Rule); {RETURNS LAMOUNT}
 end;

 If (LLine>0) then
   if IsEFOverride(RetNo,LLine) then
     LAmount := GetEFOverride(RetNo,LLine);

 If (LAmount=0) and (Fname='') and (ElmNo=26000) then  //20190728
 //If (LAmount=0) and (Fname='') and (ElmNo=260) then
  begin result :='0';exit;end;
 IF LAmount =0 THEN begin Result := '';exit;end;

 {Convert LAMOUNT to String}
 IF (LTYPE = '$') THEN
    begin
     Result := IntToStr(Round(LAmount)); {CENTS}
    end;
 IF (LTYPE = 'N') then
    Result := AllTrim(IntToStr(Round(Lamount)));

 IF LTYPE = 'C' THEN
 begin
   result := AllTrim(IntToStr(Round(LAmount * 100))); {CENTS}
 end;

 Result := AllTrim(result);

end;

//20171220
Function GetStreet(RetNo:Integer):String;
//Var InfoFNo:Integer;
Begin
//20180116
 //InfoFNo:=GetFormNo('INFO');
 Result:='';
 If FetchElmFNo(RetNo,InfoFNo,163)>'' then result:=FetchElmFNo(RetNo,InfoFNo,163)+' ';        //rr
 If FetchElmFNo(RetNo,InfoFNo,68)>'' then result:=Result+FetchElmFNo(RetNo,InfoFNo,68)+' ';   //po box
 If FetchElmFNo(RetNo,InfoFNo,22)>'' then Result:=Result+FetchElmFNo(RetNo,InfoFNo,22)+'-';   //apt No. //jz//20260119 - add dash back again //jz//20260105 remove dash, have just space, causes problems if have to remove, can always add if needed //add dash bewteen apt number and address//jz 20250127
 Result:=Result+FetchElmFNo(RetNo,InfoFNo,6); //str;
 //Result:=Result+FetchElmFNo(RetNo,InfoFNo,6); //str
end;
(*
Function GetStreet(RetNo:Integer):String;
Begin
 Result := FetchElm(RetNo,'T1',6);
 If FetchElm(RetNo,'T1',22)>'' then  result:=Result+' '+FetchElm(RetNo,'T1',22); //apartm
 If FetchElm(RetNo,'T1',68)>'' then result:=result+' '+FetchElm(RetNo,'T1',68);  //PO box
 If FetchElm(RetNo,'T1',163)>'' then result:=result+' '+FetchElm(RetNo,'T1',163);  //RR
end;
*)
end.


