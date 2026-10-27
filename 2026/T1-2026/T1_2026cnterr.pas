Unit T1_2026cnterr;

interface

uses
  // SysUtils,FileCtrl, WinTypes, WinProcs, Messages, Classes,StdCtrls,Dialogs,
  WinTypes, FileCtrl, WinProcs, SysUtils, Classes, Graphics, Forms, Controls,
  Menus,
  vtDynData,   //20230801 CON
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls,
  T1_2026TrimStr, T1_2026T1Rtns, T1_2026T1Rtns2, T1_2026Declare, T1_2026Common,
  // 20160119 Igor
  T1_2026Common2, T1_2026CalcBus,
  System.Generics.Collections, System.Generics.Defaults  //jz//20260421//CCAv11 - for array sort
  ;
Var
  Inst: String;

  Procedure checkT776CCALoss(RetNo:integer); //jz//20260421//CCAv11

  Procedure ValidateResidencyType(RetNo:integer;s:string); //20240126  s=residencetype such as '1', '2' etc
  // 20200126 All WITB text renamed to CWB
  Procedure ValidateT1134(RetNo:Integer;Fno:Integer);
  Procedure ValidateT1134S(RetNo:Integer;Fno,FInst:Integer); //20230510 Igor
  Procedure ValidateT1135MaxYearEnd(RetNo: integer; Fno: integer); //20239214
  Function CountDiagnostics(RetNo: integer): integer;
  Procedure SaveEFileDiagnostic(RetNo: integer; FrmNm: string; ElmNo: integer;
    ErrMsg: string);
  // Procedure SaveReviewMarksDiagnostic(RetNo:Integer;FrmNm: string; ElmNo : integer; ErrMsg:string);
  Function LastYearYSumAvailable(ValueList: TStringList): Boolean;
  Function InterestDistribution(RetNo: integer): Boolean;

  // 20160126
  Procedure ValidateT1013(RetNo: integer; Fno: integer; Inst: String);
  Procedure ValidateCONSENT(RetNo: integer; Fno: integer; Inst: String);
  Procedure ValidateT1135(RetNo: integer; Fno: integer);
  Procedure RemoveT1135SectionAdata(RetNo: integer; Fno: integer);
  Procedure RemoveT1135SectionBdata(RetNo: integer; Fno: integer);
  Procedure ValidateT1135SectionAdata(RetNo: integer; Fno: integer);
  Procedure ValidateT1135SectionBdata(RetNo: integer; Fno: integer);
  Procedure ValidateT183(RetNo: integer; Fno: integer); // 20190114
  Procedure ValidateS6(RetNo: integer);
  Function AnyT3WithElectionAmount(RetNo:Integer;Amt:Real):Boolean;

  procedure ValidateT106(RetNo: Integer); //20251223 Igor
  procedure ValidateT106SL(RetNo: Integer); //20251223 Igor
  procedure ValidateAT106SLip(RetNo: Integer; SlFName: string; SlipFNo: Integer); //20251223 Igor

implementation

Uses vtMulti, vtCommon, vtMain, // 20160119 Igor
  T1_2026, T1_2026Main, T1_2026ChildWinNew, T1_2026Calc,
  vtTrimStr, vtShared;

Procedure SaveEFileDiagnostic(RetNo: integer; FrmNm: string; ElmNo: integer;
  ErrMsg: string);
Var
  k: integer;
Begin

  with Ret[RetNo] do
  begin
    If MidStr(ErrMsg, 2, 1) = '-' then
      Inc(EfileErrorCount); { FW- vs F- }
    AuditList.Add(TAuditRec.Create('F', ErrMsg, FrmNm, ElmNo)); // 20160119 Igor
  end;
End;

Function CountDiagnostics(RetNo: integer): integer;
Var
  i,ii,iii,I0,J0,j,jj,jjj,j4, k, K1, K2, K3, K4, ElmNo, Fno, AssetsFNo, SpRetNo: integer;
  FrmNm, PostalCode: string[10];

  fName:string[10];fElm:integer; //jz//20260421//CCAv12

  ErrMsg: string[100];
  s:String; //20240126
  x, y: real;
  WordList: TStringList;
  RentSfds, BusSfds, ProfSfds, FarmSfds, FishSfds, NisaSfds, HCaisSfds,
    T777Sfds, TL2Sfds, T2091Sfds, T1255Sfds: integer; // 20210123
  LinesList, ValueList, Comp2YrList: TStringList;
  FlName: String;
  FInst: String[4];
  Dt1, Dt2: TDateTime; // String[10];
  Dt: TDate;
  tempAuditRec: array of TAuditRec;
  S3FNo: integer;
  S6Frm:String; //20191215
  SNResAFNo:Integer;

  HaveEligibleSpouse, EligibleSpouseClaimingCWB: boolean;
begin

  //SET HINT POPUP SPEED AND TIME IT STAYS
  xx := Application.HintPause;          //original is 500
  xx := Application.HintHidePause;      //original is 2500
  Application.HintPause := 200;         //pop up faster
  Application.HintHidePause := 12500;   //stay 5 times as long


  RESULT := 0;
  S3FNo:=GetFormNo('S3');
  S6Frm := 'S6'; if Ret[RetNo].Province = 'QC' then S6Frm := 'S6QC'; //20191215

  If RetNo > 0 then
  Begin
    If Ret[RetNo].IsLastYearReturn then
    Begin
      // SetLength(tempAuditRec,length(Ret[RetNo].AuditRec));
      Exit;
    End;
  end;

  If (Ret[RetNo].CouplingSw) then  SpRetNo:=GetSpRetNo(RetNo) else spRetNo:=0; //20200420

  FormatSettings.DecimalSeparator := '.';
  AssetsFNo := GetFormNo('ASSETSB#1');
  If RetNo = 0 then
    Exit;
  If RetInMem < 1 then
    Exit;

  //Ret[RetNo].TapesList.Clear;
  ClearDiagnostics(RetNo); // 20160119 Igor

  //20251223 Igor >>>
  ValidateT106(RetNo);
  ValidateT106SL(RetNo);
  //20251223 Igor <<<

  {does not work
  //202600326
  x:=TotMultiple(RetNo,'T4',76));
  If (x>0) and (Vl(FetchElm(RetNo,'T90',15)<x) then
    SaveDiagnostic(RetNo, 'T4#1',76,'W-You have amount(s) on box 94. You must enter it on the T90 fom Line 19');
  }

  if Ret[RetNo].Province='QC' then  //20250317
  Begin
   SaveDiagnostic(RetNo, 'INFO', 1, 'W-QC returns can only be used for Federal purposes and without technical support.');
  End;


  //20240428C
  if (IsSection116(RetNo))
  Or (GetResidencytype(retNo)='7')  //20240515
  then
  Begin
    SNRESAFNo:=GetFormNo('SNRESA');
    if (Vl(FetchElmFno(RetNo,SnResAFNo,1))=Vl(FetchElmFno(RetNo,SnResAFNo,6)))
    Or (Vl(FetchElmFno(RetNo,SnResAFNo,15))=0) then
    Begin
     SaveDiagnostic(RetNo, 'SNRESA', 2, 'W-REVIEW SCHEDULE A:'); //20240428C
     SaveDiagnostic(RetNo, 'SNRESA', 2, 'W- Canadian and Outside Canada sources'); //20240428C
     SaveDiagnostic(RetNo, 'SNRESA', 2, 'W- to consider if additional income');
     SaveDiagnostic(RetNo, 'SNRESA', 2, 'W- needs to be reported');
    End;
  End;

  //20260315 cz/
  if FetchElmFNo(RetNo,INfoFNo,1)='' then
    SaveDiagnostic(RetNo, 'INFO', 1,'E-INFO- You must select a Province');

  //20260503
  if (isSection115(RetNo)=True) and (FetchElmFNo(RetNo,INfoFNo,249)='') then
    SaveDiagnostic(RetNo, 'INFO', 249,'E-INFO- You must select a Province');


  if FetchElmFNo(RetNo,INfoFNo,253)>'' then
   SaveDiagnostic(RetNo, 'INFO', 253,'W-The return must be submitted via paper filing');
  if FetchElmFNo(RetNo,INfoFNo,231)>'' then
   SaveDiagnostic(RetNo, 'INFO', 231,'W-Residency Type 6 is NOT eligible for EFILE ');
  if FetchElmFNo(RetNo,INfoFNo,232)>'' then
   SaveDiagnostic(RetNo, 'INFO', 232,'W-Residency Type 7 is NOT eligible for EFILE');
  //jz//20250422 >>
  //20250308
  if FetchElmFNo(RetNo,INfoFNo,39)>'' then
  Begin
   SaveDiagnostic(RetNo, 'INFO', 39,'W-  ');
   SaveDiagnostic(RetNo, 'INFO', 39,'W- MARITAL STATUS CHANGE');
   SaveDiagnostic(RetNo, 'INFO', 39,'W-  Since your client’s marital status has changed, their benefit and credit');
   SaveDiagnostic(RetNo, 'INFO', 39,'W-  payments may be impacted if they did not previously inform the Canada');
   SaveDiagnostic(RetNo, 'INFO', 39,'W-  Revenue Agency (CRA). The CRA will send your client a redetermination');
   SaveDiagnostic(RetNo, 'INFO', 39,'W-  notice if a recalculation determines that they were paid too much or too little.');
   SaveDiagnostic(RetNo, 'INFO', 39,'W-  Your client can go to the benefits calculator to estimate any potential changes');
   SaveDiagnostic(RetNo, 'INFO', 39,'W-  to their payments.');
   SaveDiagnostic(RetNo, 'INFO', 39,'W-  ');
   SaveDiagnostic(RetNo, 'INFO', 39,'W-  ');
  End;



  //20260217
  If TotMultiple(RetNo,'T4A',98)>0 then  //20250308
  Begin
    SaveDiagnostic(RetNo, 'T1', 317,'W-  ');
    SaveDiagnostic(RetNo, 'T1', 317,'W- DEDUCTION FOR REPAYMENTS OF FEDERAL COVID-19 BENEFITS');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  There is an entry at line 23200 of the T1');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  Please note that if any portion of the amount at line 23200');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  includes a deduction for Federal Covid-19 benefits received in a prior year,');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  and repaid in 2025.');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  The total amount of Federal Covid-19 benefits repaid in 2025');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  can only be claimed as a deduction on the taxpayer’s 2025 tax return.');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  No amount can be claimed on the return for the year in which the');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  Federal Covid-19 benefits were received.');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  Provincial or territorial Covid-19 benefits: Any amounts repaid can only');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  be deducted on the tax return for the year in which they were repaid.');
    SaveDiagnostic(RetNo, 'T1', 317,'W-  ');
  end;


{
  If TotMultiple(RetNo,'RC210',1)>0 then  //20240216
  Begin
    SaveDiagnostic(RetNo, 'RC210', 1,'W-   ');
    SaveDiagnostic(RetNo, 'RC210', 1,'W- ACWB and RC210');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  If either or both spouse(s) receive an RC210 slip with an amount in Box 10,');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  the individual claiming the basic CWB must report their spouse’s Box 10');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  amount on Schedule 6. If neither spouse is claiming the basic CWB, they can');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  choose who will report the amounts in Box 10 of the RC210 slip.');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  can only be claimed as a deduction on the taxpayer’s 2023 tax return.');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-   ');
  end;
}

  //jz//20260220 - supporting info for prompt CRA wants:
                   //RC210 is included in the return, RC210 prompt should also be available when the taxpayer with an eligible spouse is claiming the Basic CWB
  HaveEligibleSpouse        := ( fetchElm(RetNo, 'S6', 3 ) > ''  );
  EligibleSpouseClaimingCWB := ( fetchElm(RetNo, 'S2', 1 ) = 'Y' ); //add indicator on s2 to find if spouse claiming CWB (as profile does, but should it be on s6??)
  //if (ret[RetNo].MarStatus < 3) and (ret[RetNo].CouplingSw = True) then SpRetNo:= GetSpRetNo(RetNo) else SpRetNo:= 0;
  //EligibleSpouseClaimingCWB := ( vl(fetchElm(SpRetNo, 'S6', 29)) > ''  ); //get from spouses return if claiming CWB (line 38102)

  If ( TotMultiple(RetNo,'RC210',1)>0 ) or
     ( HaveEligibleSpouse and EligibleSpouseClaimingCWB ) //jz//20260220
  then  //20240216
  Begin
    SaveDiagnostic(RetNo, 'RC210', 1,'W-   ');
    SaveDiagnostic(RetNo, 'RC210', 1,'W- ACWB and RC210');

    SaveDiagnostic(RetNo, 'RC210', 1,'W-  If you have a spouse or common-law partner, only the person claiming the basic CBW should');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  report the amount from box 10 of all the RC210 received. If you and your spouse or common-law');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  partner are not claiming the basic CWB, one of you must report the amount from box 10 or all');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  RC210 slips as if you were claiming it.');

    SaveDiagnostic(RetNo, 'RC210', 1,'W-   ');

    SaveDiagnostic(RetNo, 'RC210', 1,'W-  If either or both spouse(s) receive an RC210 slip with an amount in Box 10,');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  the individual claiming the basic CWB must report their spouse’s Box 10');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  amount on Schedule 6. If neither spouse is claiming the basic CWB, they can');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  choose who will report the amounts in Box 10 of the RC210 slip.');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-  can only be claimed as a deduction on the taxpayer’s tax return.');
    SaveDiagnostic(RetNo, 'RC210', 1,'W-   ');

  end;


  Fno := GetFormNo('T183'); // 20190113
  ValidateT183(RetNo, Fno);
  //------------------------------------------------
  //flipping      //20240217
  //sale of real eastate
  If (Vl(fetchElmFNo(RetNo,S3FNo,36))<>0)  // ln 13800
  or (Vl(fetchElmFNo(RetNo,S3FNo,81))<>0)  //ln 15800   //sale of real estate
  then
  Begin
   If fetchElmFNo(RetNo,S3FNo,157)+fetchElmFNo(RetNo,S3FNo,158)='' then  //dispose unit
    Begin
     SaveDiagnostic(RetNo, 'S3', 157,'W-   ');
     SaveDiagnostic(RetNo, 'S3', 157,'W- RESIDENTIAL PROPERTY FLIPPING');
     SaveDiagnostic(RetNo, 'S3', 157,'W-  Please answer the question on regarding flipped');
     SaveDiagnostic(RetNo, 'S3', 157,'W-  property at line 17905 of Schedule 3');
     SaveDiagnostic(RetNo, 'S3', 157,'W-   ');       //was s15 20240227
    End
    Else
    begin     //20240318
     if (FetchElmFno(RetNo,S3FNo,157)>'')  //yes disposed
     and (FetchElmFno(RetNo,S3FNo,136)='') then  //question answered for ln 17905
     Begin
      SaveDiagnostic(RetNo, 'S3', 157,'W-   ');
      SaveDiagnostic(RetNo, 'S3', 157,'W- RESIDENTIAL PROPERTY FLIPPING');
      // SaveDiagnostic(RetNo, 'S3', 157,'W-  Please answer the question on regarding flipped');
     // if FetchElmFno(RetNo,S3FNo,136)>'' then  //question answered for ln 17905
      //ok
       SaveDiagnostic(RetNo, 'S3', 157,'W-  You have answered yes to the question at F17905 on Schedule 3,');
       SaveDiagnostic(RetNo, 'S3', 157,'W-  however, you have not chosen a life event at F17906.');
       SaveDiagnostic(RetNo, 'S3', 157,'W-  Therefore, The amount of gain or loss from the flipped property');
       SaveDiagnostic(RetNo, 'S3', 157,'W-  must be reported on a T2125 as business income');
       SaveDiagnostic(RetNo, 'S3', 157,'W-  If the disposition of the flipped property results in a loss,');
       SaveDiagnostic(RetNo, 'S3', 157,'W-  the return must be paper filed.');
       SaveDiagnostic(RetNo, 'S3', 157,'W-   ');
     End;
    end;

  end; //sale of real eastate

  //20260212
  If Vl(fetchElm(RetNo,'DON',88))>0 then
  Begin
    SaveDiagnostic(RetNo, 'DON', 88,'W-   ');
    SaveDiagnostic(RetNo, 'DON', 88,'W- DONATIONS');
    SaveDiagnostic(RetNo, 'DON', 88,'W-  If you already claimed certain eligible amounts');
    SaveDiagnostic(RetNo, 'DON', 88,'W-  on your 2024 return for donations or gifts made');
    SaveDiagnostic(RetNo, 'DON', 88,'W-  between January 1 and February 28, 2025,');
    SaveDiagnostic(RetNo, 'DON', 88,'W-  you cannot claim the same amounts on your 2025 return');
    SaveDiagnostic(RetNo, 'DON', 88,'W-  For more information, go to canada.ca/line-34900.');
    SaveDiagnostic(RetNo, 'S15', 88,'W-   ');
  end;



  If fetchElm(RetNo,'S15',2)='' then  //202503214 no check box = OPened FHSA this year //20240218  //20260212
  Begin
    SaveDiagnostic(RetNo, 'S15', 2,'W-   ');
    SaveDiagnostic(RetNo, 'S15', 2,'W- FHSA');
    SaveDiagnostic(RetNo, 'S15', 2,'W-  The client opened their first FHSA in 2025');
    SaveDiagnostic(RetNo, 'S15', 2,'W-  The client did not open an FHSA in 2024 or 2025');
    SaveDiagnostic(RetNo, 'S15', 2,'W-  but they became a successor holder in 2025');
    SaveDiagnostic(RetNo, 'S15', 2,'W-  FHSA - First Home Savings Account');
    SaveDiagnostic(RetNo, 'S15', 2,'W-  If the taxpayer opened an FHSA account in the tax year,');
    SaveDiagnostic(RetNo, 'S15', 2,'W-  please tick the box at F68930 on the Schedule 15.');
    SaveDiagnostic(RetNo, 'S15', 2,'W-   ');
  end;


  If (fetchElm(RetNo,'S3',157)='') and (fetchElm(RetNo,'S3',158)='') then
  Begin
    SaveDiagnostic(RetNo, 'S3', 157,'W-  ----- ');
    SaveDiagnostic(RetNo, 'S3', 157,'W-   ');
    SaveDiagnostic(RetNo, 'S3', 157,'W- FLIPPED PROPERTY');
    SaveDiagnostic(RetNo, 'S3', 157,'W-  Did the client dispose of a housing unit (including a rental property) in the tax year?');
    SaveDiagnostic(RetNo, 'S3', 157,'W-   ');
  End;

  //20260224
  If (Vl(fetchElm(RetNo,'CFR',39)) > 0) and (FetchElm(RetNo,'CFR',332) ='') then
  Begin
     SaveDiagnostic(RetNo, 'CFR',39,'E-  ----- ');
     SaveDiagnostic(RetNo, 'CFR',39,'E-    ');
     SaveDiagnostic(RetNo, 'CFR',39,'E- CARRYOVER FROM LAST YEAR');
     SaveDiagnostic(RetNo, 'CFR',39,'E-  Check the Minimum Tax Carryover. If it is invalid, delete it from the CFR form');
     SaveDiagnostic(RetNo, 'CFR',39,'E-  Otherwise, confirm it is ok');
     SaveDiagnostic(RetNo, 'CFR',39,'E-  If it happens often, see Help -> FAQ -> Minimum Tax Carryover');
     SaveDiagnostic(RetNo, 'CFR',39,'E-  Or contact VisualTax by Email');
     SaveDiagnostic(RetNo, 'CFR',39,'E-   ');
  End;


  If fetchElmFno(RetNo,InfoFNo,173)='' then  //20240216  Indicator
  Begin
    SaveDiagnostic(RetNo, 'INFO', 173,'W-   ----- ');
    SaveDiagnostic(RetNo, 'INFO', 173,'W-    ');
    SaveDiagnostic(RetNo, 'INFO', 173,'W- NON-CANADIAN MAILING ADDRESS');
    SaveDiagnostic(RetNo, 'INFO', 173,'W-  If taxpayer has a Non-Canadian Mailing addresss tick the related box on the Address box,');
    SaveDiagnostic(RetNo, 'INFO', 173,'W-  select the proper Residency Type on the top of the INFO form,');
    SaveDiagnostic(RetNo, 'INFO', 173,'W-  and complete the Non-Canadian Mailing addresss section');
    SaveDiagnostic(RetNo, 'INFO', 173,'W-   ');
  end
  Else
  Begin
    SaveDiagnostic(RetNo, 'S3', 157,'W-   ----- ');
    SaveDiagnostic(RetNo, 'INFO', 173,'W-   ');
    SaveDiagnostic(RetNo, 'INFO', 173,'W- NON-CANADIAN MAILING ADDRESS');
    SaveDiagnostic(RetNo, 'INFO', 173,'W-  You ticked the Non-Canadian Mailing addresss on the INFO form');
    SaveDiagnostic(RetNo, 'INFO', 173,'W-  select the proper Residency Type on the top of the INFO form (boxes (1) to (7),');
    if (FetchElmFNo(RetNo,InfoFNo,159)='') or (FetchElmFNo(RetNo,InfoFNo,161)='') then
      SaveDiagnostic(RetNo, 'INFO', 159,'W-   and complete the Non-Canadian Mailing addresss section');
    SaveDiagnostic(RetNo, 'INFO', 159,'W-    ');
  end;

  If (fetchElmFno(RetNo,InfoFNo,173)>'')  //non can address  //20240328
  and (fetchElmFno(RetNo,InfoFNo,161)='') then  //country missing
   SaveDiagnostic(RetNo, 'INFO', 179, 'E-Non-canadian address. Please enter Country name');

  {
  if Vl(FetchElmFNo(RetNo,INFoFNo,156))>0 then //20250309
  begin
    SaveDiagnostic(RetNo, 'INFO', 1,'W-   ');
    SaveDiagnostic(RetNo, 'INFO', 156,'W-  DECEASED TAXPAYER-A subsection 104(13.4) election has been made');
    SaveDiagnostic(RetNo, 'INFO', 156,'W-   Please ensure to include the amount $'
     +FormatFloat('##,###,###.##',Vl(FetchElmFNo(RetNo,INFoFNo,156)))+' on a T3 slip');
    SaveDiagnostic(RetNo, 'INFO', 156,'W-   ');
  end;
  }

  //20240214
  If FetchElmFNo(RetNo, InfoFNo, 259) > '' then  //104 election  /20230214
  Begin
    if FetchElmFNo(RetNo, InfoFNo, 24)='' then  //no death
     SaveDiagnostic(RetNo, 'INFO', 24, 'E-A subsection 104(13.4) election has been made. Please enter date of death or remove the election');
    if Vl(FetchElmFNo(RetNo, InfoFNo, 156))=0 then  //no amount+
     SaveDiagnostic(RetNo, 'INFO', 156, 'E-No amount entered for election 104(13.4). Enter amount on the Info form and also on a T3 slip as other income');
  End;

  if Vl(FetchElmFNo(RetNo, InfoFNo, 156))>0 then  //104 amount present
  begin
   If FetchElmFNo(RetNo, InfoFNo, 259)='' then  //no election made
    SaveDiagnostic(RetNo, 'INFO', 156, 'E-Amount entered for election 104(13.4) but mo Election made. Please remove the amount');
  end;


  If FetchElmFNo(RetNo, InfoFNo, 1) = '' then
    SaveDiagnostic(RetNo, 'INFO', 1, 'M-Taxing Province required');
  If FetchElmFNo(RetNo, InfoFNo, 3) = '' then
    SaveDiagnostic(RetNo, 'INFO', 3,
      'M-SIN required. If not assigned by CRA, enter 9 zeros');
  If Length(FetchElmFNo(RetNo, InfoFNo, 9)) <> 10 then
    SaveDiagnostic(RetNo, 'INFO', 9, 'M-Birth Date missing or incorrect');

  //validate residencetype
  s:=GetResidencytype(RetNo);
  ValidateResidencyType(RetNo,s);

  (* does not work
  //20260412
  if (Vl(FetchElm(RetNo,'T3MULT',82)) <> 0) and (Vl(FetchElm(RetNo,'T936',134)) = 0) then
   SaveDiagnostic(RetNo, 'T936',124,'W-T936-You may need to enter(override) box 68140 and 68150 on the T936');
  *)
  ValidateS6(RetNo);

  // 20140208  //moved here //20260112
  Fno := GetFormNo('T1DD');
  // 20140217
  If (FetchElmFNo(RetNo, Fno, 33) = '') // not submitted last year
    and (FetchElmFNo(RetNo, Fno, 32) = '') then // not prepare this year
    Begin
     //SaveDiagnostic(RetNo, 'T1DD', 32,'W-    '); // 20260112
     SaveDiagnostic(RetNo, 'T1DD', 32,'W- DIRECT Deposit (T1DD)');
     SaveDiagnostic(RetNo, 'T1DD', 32,'W-  T1DD-Consider Direct Deposit.'); //20260212
     //SaveDiagnostic(RetNo, 'T1DD', 32,'W-  T1DD-Consider Direct Deposit. Mailed cheques may stop'); // 20140217
     SaveDiagnostic(RetNo, 'T1DD', 32,'W-    '); // 20260112
    end;
  {
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    If FetchElmFNo(RetNo, Fno, 32) > '' then // prepare this year
    begin
      If (FetchElmFNo(RetNo, Fno, 2) = '') or (FetchElmFNo(RetNo, Fno, 3) = '')
        or (FetchElmFNo(RetNo, Fno, 4) = '') then
       Begin
        SaveDiagnostic(RetNo, 'T1DD', 2,'W-     '); // 20260112
        SaveDiagnostic(RetNo, 'T1DD', 2, 'E-T1DD-Complete fully Part C');
        SaveDiagnostic(RetNo, 'T1DD', 2,'W-         '); // 20260112
       End;
    end;
  end;
  }

  //----------------------------------------------
  //Election on 70(1) Deceased  return //20200211
  if FetchElmFNo(RetNo,InfoFNo,259)>'' then //election made
  Begin
    if FetchElmFNo(RetNo,InfoFNo,24)='' then
     SaveDiagnostic(RetNo, 'INFO', 156, 'E-A subsection 104(13.4) election made. Date of death is required');

    if LeftStr(FetchElmFNo(RetNo,InfoFNo,24),4)<>AppYear then
     SaveDiagnostic(RetNo, 'INFO', 24, 'E-A subsection 104(13.4) election made. Date of death must be in '+AppYear);

    if Vl(FetchElmFNo(RetNo,InfoFNo,156))<2 then
     SaveDiagnostic(RetNo, 'INFO', 156, 'E-A subsection 104(13.4) election made. Amount must be more than $1');

    If AnyT3WithElectionAmount(RetNo,Vl(FetchElmFNo(RetNo,InfoFNo,156)))=false then
      SaveDiagnostic(RetNo, 'T3MULT', 17, 'E-A subsection 104(13.4) election made. Election income not reported on a T3 slip');
  End
  Else  //no election
  Begin
    if Vl(FetchElmFNo(RetNo,InfoFNo,156))>0 then
     SaveDiagnostic(RetNo, 'INFO', 156, 'E-A subsection 104(13.4) election was NOT made. Amount must be removed');
  End;

  //end Election on 70(1) Deceased  return

  (*20240324
  //20210115
  if (FetchElmFNo(RetNo, InfoFNo, 173) > '')  then //20220218
  begin
   if (FetchElmFNo(RetNo, InfoFNo, 175)='')
   and (FetchElmFNo(RetNo, InfoFNo, 176)='')
   and (FetchElmFNo(RetNo, InfoFNo, 177)='') then
   Begin
    SaveDiagnostic(RetNo, 'INFO', 175, 'E-INFO-You indicated foreign mailing address. Please complete the Residency status');
    SaveDiagnostic(RetNo, 'INFO', 176, 'E-INFO-You indicated foreign mailing address. Please complete the Residency status');
    SaveDiagnostic(RetNo, 'INFO', 177, 'E-INFO-You indicated foreign mailing address. Please complete the Residency status');
   End;
  *)

  {Not needed By default picks up all in one oeriod
  //20250331
  if  (Vl(FetchElm(RetNo, 'ABIL',65))>0)
  and (Vl(FetchElm(RetNo, 'ABIL',52))=0)
  and (Vl(FetchElm(RetNo, 'ABIL',55))=0) then
   SaveDiagnostic(RetNo, 'ABIL', 55, 'E-ABIL - Enter amounts for periods 1 and 2');
  }
    //NCA USA zip code //20220216
   if (LeftStr(FetchElmFNo(RetNo, InfoFNo, 161),3)='USA') then
   Begin
    if Length(FetchElmFNo(RetNo, InfoFNo, 172))<>5 then
       SaveDiagnostic(RetNo, 'INFO', 172, 'E-INFO-Non-Canadian Address - A 5-digit USA Zip code is required');

    if ValidateUsaZipCode(FetchElmFNo(RetNo, InfoFNo, 172))=False then
     SaveDiagnostic(RetNo, 'INFO', 172, 'E-INFO-Non-Canadian Address-Provide a 5 digit USA ZIP Code');
   end;
 // End;

  if (FetchElmFNo(RetNo, InfoFNo, 173) > '')  then //20220218
  begin
   if FetchElmFNo(RetNo, InfoFNo, 159)='' then  SaveDiagnostic(RetNo, 'INFO', 159, 'E-You indicated foreign mailing address. Please complete it fully');
   if UpperCase(FetchElmFNo(RetNo, InfoFNo, 161))='USA' then  //20220405
   Begin
     if FetchElmFNo(RetNo, InfoFNo, 174)='' then  SaveDiagnostic(RetNo, 'INFO', 174, 'E-Please enter a valid US State as 2 character code');
   End;
   if FetchElmFNo(RetNo, InfoFNo, 160)='' then  SaveDiagnostic(RetNo, 'INFO', 160, 'E-Please enter the Municipality'); //20220405
   if FetchElmFNo(RetNo, InfoFNo, 161)='' then  SaveDiagnostic(RetNo, 'INFO', 161, 'E-Please enter the Country Name');
   if (FetchElmFNo(RetNo, InfoFNo, 159) > '')  then //20211223
   begin
    if FetchElmFNo(RetNo, InfoFNo, 173)='' then
     SaveDiagnostic(RetNo, 'INFO', 173, 'E-INFO-You entered a foreign mailing address. Please enter X on the indicator');
   end;
  end;

  //bc Tsaww
  if (FetchElmFNo(RetNo, InfoFNo, 190) > '')  then //20200130
  begin
   if (FetchElmFNo(RetNo, InfoFNo, 194)+FetchElmFNo(RetNo, InfoFNo, 195)='') then
    SaveDiagnostic(RetNo, 'INFO', 194,'E-INFO: Please select the BC Tsawwassen first Nation option');
  end;

  if (FetchElmFNo(RetNo, InfoFNo, 141) > '')  then //20200130
  begin
    SaveDiagnostic(RetNo, 'INFO', 141,'W- Multiple tax year');
    SaveDiagnostic(RetNo, 'INFO', 141,'W-  INFO: Multiple tax year returns is indicated.');
    SaveDiagnostic(RetNo, 'INFO', 141,'W-  The returns must be filed in chronological order,');
    SaveDiagnostic(RetNo, 'INFO', 141,'W-  and enter the same indicator on all prior years returns.');
    SaveDiagnostic(RetNo, 'INFO', 141,'W-      ');
  end;

  if (FetchElmFNo(RetNo, InfoFNo, 24) > '')
  and (FetchElmFNo(RetNo, InfoFNo,142)='')
  then  //20200130
  Begin
    SaveDiagnostic(RetNo, 'INFO', 024,'M-INFO: Deceased taxpayer. Confirm in the box below the date of death');
    SaveDiagnostic(RetNo, 'INFO', 142,'M- Confirm the SIN is for the deceased person (check the box)');
  End;


  if (FetchElmFNo(RetNo, InfoFNo, 24) > '') and
    (FetchElmFNo(RetNo, InfoFNo, 24) = FetchElmFNo(RetNo, InfoFNo, 65)) then
  // date of death TP
  Begin
    SaveDiagnostic(RetNo, 'INFO', 65,
      'W-INFO: DATE OF DEATH is the same for both spouses.');
    SaveDiagnostic(RetNo, 'INFO', 65,
      'W-  If one of them is incorrect, it may suspend federal and provincial benefits.');
    SaveDiagnostic(RetNo, 'INFO', 65,
      'W-  Please verify and correct, if applicable');
    SaveDiagnostic(RetNo, 'INFO', 65, 'W-     ');
  End;


  If (IsMultJurisdiction(RetNo)) and (Ret[RetNo].MarStatus <3) then
  Begin
    If Ret[RetNo].CouplingSw=False then  //202200517
     SaveDiagnostic(RetNo, 'T2203', 110, 'W-T2203-Multiple Jurisdiction-Use coupling for more accuracy');
  end;

  //20220408
  if (FetchElmFNo(RetNo, InfoFNo, 276) > '') and (Vl(FetchElm(RetNo, 'SNRESB', 6))=0) then
   SaveDiagnostic(RetNo, 'SNRESA',0, 'E-SNRESA - You must complete Non-Res SA and SB');

  //20260221
  If (FetchElmFNo(RetNo, InfoFNo, 86) > '') and (Ret[RetNo].FrmHasData[GetFormNo('T1135')]=False)
  then
   SaveDiagnostic(RetNo, 'T1135', 36, 'E-T1135 - complete form T1135 as you indicated on the INFO form.');
   // SaveDiagnostic(RetNo, 'DIAGNO', 0, 'E-T1135 - You must complete T1135. Click to see the error message');


  If (UpperCase(FetchElmFNo(RetNo, InfoFNo, 198)) = 'Y')  //need T1134
  and (Ret[RetNo].FrmHasData[GetFormNo('T1134')]=False)
  then
    SaveDiagnostic(RetNo, 'T1134', 294, 'E-T1134-complete form T1134 as you indicated on the INFO form (bottom).');
  //--------------------------------------------------------


 //20260219
   If (UpperCase(FetchElmFNo(RetNo, InfoFNo, 198)) = 'Y')
   or (UpperCase(FetchElmFNo(RetNo, InfoFNo, 198)) = 'N') then
  //ok
   Else
    SaveDiagnostic(RetNo, 'INFO', 198, 'W-INFO-T1134 CRA requirement: Enter Yes/No (bottom of INFO form)'); //20260304

  //20200412
  If IsMultJurisdiction(RetNo) then
  Begin
    If LeftStr(FetchElmFNo(RetNo, InfoFNo, 21),8) <>'MULTIPLE' then  //20220517
      SaveDiagnostic(RetNo, 'INFO', 21, 'W-T2203-Province should be Multiple Jursdictions');
  end
  Else //non-mj
  Begin
    If LeftStr(FetchElmFNo(RetNo, InfoFNo, 21),8)='MULTIPLE' then
      SaveDiagnostic(RetNo, 'INFO', 21, 'E-T2203-Province shoud not be Multiple Jursdictions');
  End;

 //20200505
 If FetchElmFNo(RetNo, InfoFNo, 32) > '' then  //spouse caregiver
  begin
    x:=Ret[RetNo].Lnn[30000]+Constant[RY].FCAAmount;  //20201118
    //Constant[RY].BasicPersonalAmount+Constant[RY].FCAAmount;
    If Vl(FetchElmFNo(RetNo, InfoFNo, 19)) > X
    then
      SaveDiagnostic(RetNo, 'INFO', 32, 'W-Spouse Caregiver may be ineligible as N.I. is greater than $'
         + FormatFloat('###,###.##',X));
  end;


  If FetchElmFNo(RetNo, InfoFNo, 164) > '' then
  begin
    If FetchElmFNo(RetNo, InfoFNo, 43) + FetchElmFNo(RetNo, InfoFNo, 44) = ''
    then
      SaveDiagnostic(RetNo, 'INFO', 43, 'W-Elections Canada not entered');
  end;

  //20191212 compensation
  If FetchElmFNo(RetNo, InfoFNo, 100)
  + FetchElmFNo(RetNo, InfoFNo, 101)
  + FetchElmFNo(RetNo, InfoFNo, 102)
  + FetchElmFNo(RetNo, InfoFNo, 103)='' then  //profeesional did it
     SaveDiagnostic(RetNo, 'INFO', 100, 'E-You must complete the Preparation/Compensation type');
  If FetchElmFNo(RetNo, InfoFNo, 100) > '' then  //profeesional did it
  begin
    If FetchElmFNo(RetNo, InfoFNo, 104) = '' then
      SaveDiagnostic(RetNo, 'INFO', 104, 'W-If prepared for a fee, tick the proper box');
  end;
  //--------

  //relocated from above //20200126
  If FetchElmFNo(RetNo, InfoFNo, 164) + FetchElmFNo(RetNo, InfoFNo, 165) + FetchElmFNo(RetNo, InfoFNo, 178) = ''
  then  SaveDiagnostic(RetNo, 'INFO', 164,'E-INFO-Canadian Citizen indicator missing'); // 20090406

  //Signature
   If UpperCase(FetchElmFNo(RetNo, InfoFNo, 144))='Y' then
   Begin
    If AllTrim(FetchElm(RetNo, InfoFNo, 153))='' then
      SaveDiagnostic(RetNo, 'INFO', 153,'E-Signature Date is required (YYYY-MM-DD)'); // 20090406
    If AllTrim(FetchElm(RetNo, InfoFNo, 155))='' then
      SaveDiagnostic(RetNo, 'INFO', 155,'E-Signature Time is required (HH:MM:SS)'); // 20090406

    //validate date time of e-signature //20201227
    s:=FetchElmFNo(RetNo, InfoFNo, 153);

    If (Length(s)>10) or (MidStr(s,5,1) <>'-') then
     SaveDiagnostic(RetNo, 'INFO', 153, 'E signature Date must be in format YYYY-MM-DD');

    s:=AllTrim(FetchElmFNo(RetNo, InfoFNo, 155));  //20200211
    If (Length(s)<>8) or (MidStr(s,3,1) <>':') then          //20200211
      SaveDiagnostic(RetNo, 'INFO', 155, 'E signature Time must be in format HH:MM:SS');
   End;

  // 20180428
  // NR with empl

  If (FetchElmFNo(RetNo, InfoFNo, 276) > '') //NR with Empl
  Or (IsSection216(RetNo))
  or (FetchElmFNo(RetNo, InfoFNo, 246) > '')   //17700 has val =4  //20240428B
  then
  begin
    If FetchElmFNo(RetNo, InfoFNo, 69) = '' then
      SaveDiagnostic(RetNo, 'INFO', 69, 'E-INFO-Enter non-residence country');
  end;

  If (FetchElmFNo(RetNo, InfoFNo, 220) > '') or
    (FetchElmFNo(RetNo, InfoFNo, 221) > '') then // NR with empl
  begin
    SaveDiagnostic(RetNo, 'INFO', 220,
      'W-INFO-These fields are obsolete now. Use the one above them');
    SaveDiagnostic(RetNo, 'INFO', 221,
      'W-INFO-These fields are obsolete now. Use the one above them');
  end;

  If IsSection115(RetNo) then  //20240413
  Begin
   If FetchElmFNo(RetNo, InfoFNo, 69) = '' then
      SaveDiagnostic(RetNo, 'INFO', 69, 'E-INFO-Enter non-residence country');
  End;

  if FetchElm(RetNo,'T1',504)>'' then //20240426
  Begin
   If FetchElmFNo(RetNo, InfoFNo, 69) = '' then
      SaveDiagnostic(RetNo, 'INFO', 69, 'E-INFO-Enter non-residence country');
  End;

  // 20190124
  if IsForEfile(RetNo) = True then  //20240215
  Begin
    If FetchElm(RetNo, 'T183', 13) + FetchElm(RetNo, 'T183', 18) +
      FetchElm(RetNo, 'T183', 19)= ''
    then
    Begin
      SaveDiagnostic(RetNo, 'T183', 13,'E-NOA delivery option is required on the T183 form'); //20200126
      SaveDiagnostic(RetNo, 'T183', 18,'E-NOA delivery option is required on the T183 form'); //20200126
      SaveDiagnostic(RetNo, 'T183', 19,'E-NOA delivery option is required on the T183 form'); //20200126
    end;
  end;

  (*
  if IsForEfile(RetNo) = True then
  Begin
    If FetchElmFNo(RetNo, InfoFNo, 180) + FetchElmFNo(RetNo, InfoFNo, 181) +
      FetchElmFNo(RetNo, InfoFNo, 182) + FetchElmFNo(RetNo, InfoFNo, 183) = ''
    then
      SaveDiagnostic(RetNo, 'INFO', 180,
        'E-NOA delivery option is required on the INFO form'); //20200126
  end;
  *)

  // -------------------------------------------

  If FetchElmFNo(RetNo, InfoFNo, 102) > '' then // 20180312
    SaveDiagnostic(RetNo, 'INFO', 102,
      'W-INFO-Discounted: This return is prepared/filed under the Discounting Act');

  //20240430
  If Vl(FetchElm(RetNo, 'T4RSP#1',4))>0 then //Box 18
  begin
    if Vl(FetchElm(RetNo,'T4RSP#1',4))>0  then
    Begin
     if Vl(FetchElm(RetNo,'RRSP',71))=0  then
      SaveDiagnostic(RetNo, 'RRSP', 71,'W-T4RSP box 18 may qualify as a transfer. Enter on Line (A)');
    End;
  end;



  // 20190217
  If (Ret[RetNo].Lnn[11300] > 0) and (Ret[RetNo].Age < 65) then   //20190220
    SaveDiagnostic(RetNo, 'T4AOAS#1', 2,'W-INFO-OAS has been claimed for taxpayer under 75. Please review T4A(OAS) slips');

 // 20260709 ------------------------------------------
  If (Ret[RetNo].Lnn[15000]=0) and (FetchElm(Retno,'EFMEMO',54)='') then   //20260709
  Begin
    SaveDiagnostic(RetNo, 'EFMEMO', 54,'W-TOTAL INCOME: If no entry on any line fron 10100 to 15000, enter 1 on EFMEMO Line 9915');
  End;

  If (Ret[RetNo].Lnn[15000]<>0) and (FetchElm(Retno,'EFMEMO',54)>'') then   //20260709
  Begin
    SaveDiagnostic(RetNo, 'EFMEMO', 54,'W-TOTAL INCOME: Remove the value from EFMEMO Line 9915');
  End;
  //----------------------------------------------------
  If Ret[RetNo].FrmHasData[GetFormNo('RC151')] then  //20230330
  Begin
   If Length(FetchElm(RetNo,'RC151',36))<>10 then  //new comer entry
     SaveDiagnostic(RetNo, 'RC151', 36,'W-Date should be YYYY-MM-DD.  Please complete it');
  End;


  (* //20260212
  //s14 20220402
  if FetchElmFno(RetNo,InfoFNo,26)>'' then  //new comer entry
  Begin
   if Vl(Fetchelm(RetNo,'S14EST',11))>0 then
    SaveDiagnostic(RetNo, 'S14EST', 11,'W-CAI calculated for Newcomer. Click the CAIS INFO Button');
  End;

  if (Ret[RetNo].Age<19) and (Vl(FetchElm(RetNo,'S14EST',11))>0) then  //20230307
   SaveDiagnostic(RetNo, 'S14EST', 20,'W-CAI not allowed normally for age under 19. See CRA guides');
  *)

  // 20160318  Code 5773  //20160505 Igor
  If (Ret[RetNo].MarStatus = 3) or (Ret[RetNo].MarStatus = 5) then
  // widow or separated
  Begin
    If (FetchElmFNo(RetNo, InfoFNo, 39) + FetchElmFNo(RetNo, InfoFNo, 40) > '')
      and (FetchElmFNo(RetNo, InfoFNo, 188) = '') then
    // mar stats changed and no 5773
    Begin
      If (Ret[RetNo].Lnn[11600] > 0) or (Ret[RetNo].Lnn[21000] > 0) or
        (Ret[RetNo].Lnn[32600] > 0)
      // or (Ret[RetNo].Lnn[423]>0) //20161117
      then
        SaveDiagnostic(RetNo, 'INFO', 188,
          'W-INFO-If widowed in the tax year, or separated for less than 90 days, check (X) the 5773 box');
    end;
  end;
  If ((Ret[RetNo].MarStatus <> 3) and (Ret[RetNo].MarStatus <> 5)) and
    (FetchElmFNo(RetNo, InfoFNo, 188) > '') then // widow or separated
    SaveDiagnostic(RetNo, 'INFO', 188,
      'E-INFO-The 5773 indicator is not applicable. Please remove it');

  // 20180301
  If FetchElmFNo(RetNo, InfoFNo, 223) > '' then
    SaveDiagnostic(RetNo, 'INFO', 223,
      'W-INFO-This return has been flagged for Refile. If not correct, remove the indicator');

  // ---------------------------------------

  // 20141020
  If FetchElmFNo(RetNo, InfoFNo, 169) > '' then
  begin
    If (FetchElmFNo(RetNo, InfoFNo, 171) = '')
    // Or (ValidDate(FetchElmFNo(RetNo,InfoFNo,171))=False)
    then // 20141020
      SaveDiagnostic(RetNo, 'INFO', 171, 'W-INFO-Enter a correct moving date');
  end;

{ jz//20250426 - no longer applicable, these fields are now used for non res
  If FetchElmFNo(RetNo, InfoFNo, 202) > '' then // 20131125
  begin
    If (FetchElmFNo(RetNo, InfoFNo, 204) = '') and
      (FetchElmFNo(RetNo, InfoFNo, 205) = '') then
    begin
      SaveDiagnostic(RetNo, 'INFO', 204,
        'E-INFO-Enter BC Citizen question (Y/N)');
      SaveDiagnostic(RetNo, 'INFO', 205,
        'E-INFO-Enter BC Citizen question (Y/N)');
    end;
  end;
}

  // 20140217
  If (FetchElmFNo(RetNo, InfoFNo, 26) + FetchElmFNo(RetNo, InfoFNo, 25) > '')
  or (FetchElmFNo(RetNo, InfoFNo, 28) + FetchElmFNo(RetNo, InfoFNo, 29) > '')  //20240406
  then
  begin
    //20240604
    If Vl(FetchElmFNo(RetNo, InfoFNo, 211)) = 0 then
      SaveDiagnostic(RetNo, 'INFO', 211,
        'E-INFO-Box 52920: If zero enter $1, otherwise enter real amount');
    // 20140217
    If Vl(FetchElmFNo(RetNo, InfoFNo, 212)) = 0 then
      SaveDiagnostic(RetNo, 'INFO', 212,
         'E-INFO-Box 52930: If zero enter $1, otherwise enter real amount');
    // 20140217
  end;

  // 20140312
  If FetchElmFNo(RetNo, InfoFNo, 215) + FetchElmFNo(RetNo, InfoFNo, 216) > ''
  then
  begin
    If Vl(FetchElmFNo(RetNo, InfoFNo, 213)) = 0 then
      SaveDiagnostic(RetNo, 'INFO', 213,
        'W-INFO-Newcomer: Enter income if applicable');
    If Vl(FetchElmFNo(RetNo, InfoFNo, 214)) = 0 then
      SaveDiagnostic(RetNo, 'INFO', 214,
        'W-INFO-Newcomer: Enter income if applicable');
  end;

  If Pos('#', FetchElmFNo(RetNo, InfoFNo, 6)) > 0 then
    SaveDiagnostic(RetNo, 'INFO', 6,
      'E-INFO-Please remove # from client address boxes');
  If Pos('#', FetchElmFNo(RetNo, InfoFNo, 22)) > 0 then
    SaveDiagnostic(RetNo, 'INFO', 22,
      'E-INFO-Please remove # from client address boxes');
  If Pos('#', FetchElmFNo(RetNo, InfoFNo, 68)) > 0 then
    SaveDiagnostic(RetNo, 'INFO', 68,
      'E-INFO-Please remove # from client address boxes');
  If Pos('#', FetchElmFNo(RetNo, InfoFNo, 163)) > 0 then
    SaveDiagnostic(RetNo, 'INFO', 163,
      'E-INFO-Please remove # from client address boxes');
  If (FetchElmFNo(RetNo, InfoFNo, 163) > '') and
    (UpperCase(LeftStr(FetchElmFNo(RetNo, InfoFNo, 163), 2)) <> 'RR') then   //20200208
    SaveDiagnostic(RetNo, 'INFO', 163, 'E-INFO-Please include prefix RR');

  If Pos(EfDelim, FetchElmFNo(RetNo, InfoFNo, 6)) > 0 then
    SaveDiagnostic(RetNo, 'INFO', 6,
      'E-INFO-Please remove ! from client address boxes');
  If Pos(EfDelim, FetchElmFNo(RetNo, InfoFNo, 22)) > 0 then
    SaveDiagnostic(RetNo, 'INFO', 22,
      'E-INFO-Please remove ! from client address boxes');
  If Pos(EfDelim, FetchElmFNo(RetNo, InfoFNo, 68)) > 0 then
    SaveDiagnostic(RetNo, 'INFO', 68,
      'E-INFO-Please remove ! from client address boxes');
  If Pos(EfDelim, FetchElmFNo(RetNo, InfoFNo, 163)) > 0 then
    SaveDiagnostic(RetNo, 'INFO', 163,
      'E-INFO-Please remove ! from client address boxes');

  If (Ret[RetNo].MarStatus = 1) or (Ret[RetNo].MarStatus = 2) then
  begin
    If FetchElmFNo(RetNo, InfoFNo, 3) = FetchElmFNo(RetNo, InfoFNo, 4) then
      SaveDiagnostic(RetNo, 'INFO', 4, 'E-INFO-Spouse SIN same with taxpayer');
  end;

  If FetchElmFNo(RetNo, InfoFNo, 11) + FetchElmFNo(RetNo, InfoFNo, 12) +
    FetchElmFNo(RetNo, InfoFNo, 13) + FetchElmFNo(RetNo, InfoFNo, 16) +
    FetchElmFNo(RetNo, InfoFNo, 17) + FetchElmFNo(RetNo, InfoFNo, 18) = '' then
    SaveDiagnostic(RetNo, 'INFO', 18, 'M-INFO-Select one of the Marital Status codes'); //20260219

  // 20101206
  If (Optrec.Nfl_Efile = True) and (IsEFiledReturn(RetNo) = false) then
    SaveDiagnostic(RetNo, 'INFO', 46,
      'W-INFO-Return Not set for Efile-Global Configuration setting is Yes');
  If (Optrec.Nfl_Efile = false) and (IsEFiledReturn(RetNo) = True) then
    SaveDiagnostic(RetNo, 'INFO', 46,
      'W-INFO-Return set for Efile-Global Configuration setting is No');

  If IsEFiledReturn(RetNo)=True then
  Begin
   //check NOA options
   if  (FetchElm(RetNo,'T183',13)='')
   and (FetchElm(RetNo,'T183',18)='')
   and (FetchElm(RetNo,'T183',19)='') then
   SaveDiagnostic(RetNo, 'T183',13,'E-T183-Please select your NOA Delivery option');
  End;


  // 20101217
  If (Optrec.Prp_DiscNo = '') and (FetchElmFNo(RetNo, InfoFNo, 102) > '') then
    SaveDiagnostic(RetNo, 'INFO', 102,
      'E-INFO-Discounter return-Need Discounter Number in Configure-Preparer');


  //start EMAIL ---- <<

  If FetchElmFNo(RetNo, InfoFNo, 64) > '' then
  begin
    If ValidEMail(FetchElmFNo(RetNo, InfoFNo, 64)) = false then
      SaveDiagnostic(RetNo, 'INFO', 64, 'E-INFO-Email for CRA is incorrect')
  end;

  // 20180408
  If (FetchElmFNo(RetNo, InfoFNo, 64) > '') and
    (FetchElmFNo(RetNo, InfoFNo, 275) = '') then
  begin
    If ValidEMail(FetchElmFNo(RetNo, InfoFNo, 275)) = false then
      SaveDiagnostic(RetNo, 'INFO', 275,
        'W-INFO-Email for CRA is incorrect. CRA requires you to re-enter it');
  end;

  If UpperCase(FetchElmFNo(RetNo, InfoFNo, 64)) <>
    UpperCase(FetchElmFNo(RetNo, InfoFNo, 275)) then
    SaveDiagnostic(RetNo, 'INFO', 275,
      'W-INFO-Email for CRA must be the same in both boxes. Do not Copy and Paste');

  //jz//20250314
  If (FetchElmFNo(RetNo, InfoFNo, 64) = '') or (FetchElmFNo(RetNo, InfoFNo, 64) > '') then
  begin
    //20260217
    SaveDiagnostic(RetNo, 'INFO', 64,  'W-INFO-By providing your clients email address, they' + #13#10 +
                                       'will stop receiving paper mail from the CRA and will' + #13#10 +
                                       'instead receive an email notification when mail is'   + #13#10 +
                                       'available in My Account.'                             + #13#10 + #13#10 +
                                       'You will need to advise your client to register for'  + #13#10 +
                                       'a CRA Account to access My Account to view their Notice '+ #13#10 +
                                       'of Assessment or Reassessment, and any other CRA mail that is available online.');
  end;

  // 20150131
  If FetchElmFNo(RetNo, InfoFNo, 140) = '' then
    SaveDiagnostic(RetNo, 'INFO', 140, 'W-INFO-Personal Email not entered')
  Else
  begin
    If ValidEMail(FetchElmFNo(RetNo, InfoFNo, 140)) = false then
      SaveDiagnostic(RetNo, 'INFO', 140, 'E-INFO Personal Email is incorrect')
  end;

  //end EMAIL ---- >>

  if TosiInEffect(RetNo) then // 20190210
  begin
    SaveDiagnostic(RetNo, 'T1206', 0,
      'W-T1206-*** TOSI IS IN EFFECT *** Several Federal and Provincial calculations use the TOSI Adjusted Net or Taxable income');
  end;

  //---//from john //20250218---------------------------
   //donor //20221222
  if (Ret[RetNo].Province='ON')
  or (Ret[RetNo].Province='NU')
  or (Ret[RetNo].Province='BC') then //jz//20250216 add BC, doesnt seem neccessay as is forced in T1 Calc
  Begin
   If (FetchElm(RetNo,'T1',505)='') and (FetchElm(RetNo,'T1',506)='') then
   begin
    SaveDiagnostic(RetNo, 'T1',505,'E-T1-Select your option for organ and tissue donor');
   end;
  End;

  (*
  //donor  //20221222
  if (Ret[RetNo].Province='ON')
  or (Ret[RetNo].Province='NU') Then
  Begin
   If (FetchElm(RetNo,'T1',505)='') and (FetchElm(RetNo,'T1',506)='') then
   begin
    SaveDiagnostic(RetNo, 'T1',505,'E-T1-Select your option for organ and tissue donor');
   end;
  End;
  *)
  { //20240229
  if Ret[RetNo].Province='BC' then //20240228
  begin
    if Vl(FetchElm(RetNo,'BC479',45))<6 then
      SaveDiagnostic(RetNo, 'BC479',45,'E-BC-Renter tax credit. Number of months must be at least 6 to claim this credit');
  end;
  }

  if ret[RetNo].Lnn[31240]>0 then //search rescu in federal //20221225
  Begin
   if Ret[RetNo].Province='NL' then
   begin
    if Vl(FetchElm(RetNo,'NL428',48))=0 then
     SaveDiagnostic(RetNo, 'NL428',48,'E-NL-Search and Rescue: Enter the amount on box 58316 of NL428');
   end;

   if Ret[RetNo].Province='MB' then
   begin
    if Vl(FetchElm(RetNo,'MB428',78))=0 then
     SaveDiagnostic(RetNo, 'NB428',78,'E-MB-Search and Rescue: Enter the amount on box 58316 of MB428');
   end;

   if Ret[RetNo].Province='BC' then
   begin
    if Vl(FetchElm(RetNo,'BC428',87))=0 then
     SaveDiagnostic(RetNo, 'BC428',87,'E-BC-Search and Rescue: Enter the amount on box 58316 of BC428');
   end;
  End;


  //20200308----------
  If AllowSaSb(RetNo) then
  Begin
   if Vl(FetchElm(RetNo,'SNRESB',2))<90 then  //20230318
     //20220301//if Vl(FetchElm(RetNo,'SNRESB',3))<90 then  //20220301
   //if Vl(FetchElm(RetNo,'SNRESB',2))<90 then
   Begin  //20220301  it was 142 instead of 55
     SaveDiagnostic(RetNo, 'SNRESB', 2,'W-Non-Resident Rule of 90 not in effect, and');//SaveDiagnostic(RetNo, 'T1', 55,'W-Non-Resident Rule of 90 not in effect, and');
     SaveDiagnostic(RetNo, 'SNRESB', 2,'W-  only partial Non-refundable credits were used. See Schedule SB: (SNRESB)');//SaveDiagnostic(RetNo, 'T1', 55,'W-  only partial Non-refundable credits were used. See Schedule SB: (SNRESB)');
   End;
  End;

  {
  if (Ret[RetNo].lnn[10100]>0) and (Ret[RetNo].FrmHasData[GetFormNo('T777S#1')]=false) then   //20210227
     SaveDiagnostic(RetNo, 'T777S#1', 0,'W-COVID-19-Any Employment Expenses for working from home?');
  }

 {
 //----------- start t777s
  If (TotMultiple(RetNo, 'T777', 24)>0)
  and (TotMultiple(RetNo,'T777S', 6)>0) then
    SaveDiagnostic(RetNo, 'T777S#1', 18,'W-You claimed both T777 and T777S. Ensure you do not double deducting expenses');
  }

  //20210118  T777
  for k:=1 to 5 do
  Begin
   Fno := GetFormNo('T777#'+IntToStr(k));
   if FNo>0 then
   Begin
    //20210514
    If (Vl(FetchElmFNo(RetNo, Fno, 51))>0)
    and (Vl(FetchElmFNo(RetNo, Fno, 2))=0) then
      SaveDiagnostic(RetNo, 'T777#'+IntToStr(k), 2,'E-T777-Enter the Employment income related to this claim');

    //20210403
    If (UpperCase(FetchElmFNo(RetNo, Fno, 86))='Y') then //detail method
    Begin
     if Vl(FetchElmFNo(RetNo, Fno, 46))>0 then  //20210403 Expenses entered
     Begin
      If (FetchElmFNo(RetNo, Fno, 77)='') or (FetchElmFNo(RetNo, Fno, 78)='') then //detail method
      Begin
        SaveDiagnostic(RetNo, GetFormName(RetNo,FNo),77,'E-T777 Home Work Space not entered');
        SaveDiagnostic(RetNo, GetFormName(RetNo,FNo),78,'E-T777 Home Work Space not entered');
      End;
      If (FetchElmFNo(RetNo, Fno, 84)+FetchElmFNo(RetNo, Fno, 85)='') then //detail method
      Begin
        SaveDiagnostic(RetNo, GetFormName(RetNo,FNo),84,'E-T777 Select Home Space type');
        SaveDiagnostic(RetNo, GetFormName(RetNo,FNo),85,'E-T777 Select Home Space type');
      End;
     End; //expenses entered
    End //detail method
    Else
    Begin
      if Ret[RetNo].FrmHasData[FNo] then    //20210409
        SaveDiagnostic(RetNo, GetFormName(RetNo,FNo),71,'W-T777 You used manual entry of Line 37. Please inspect the amount');
    End;
   //option 2  //20210402
    If (UpperCase(FetchElmFNo(RetNo, Fno, 62))='Y') then
    Begin
     If (UpperCase(FetchElm(RetNo, 'GST370', 51))<>'Y') then
      SaveDiagnostic(RetNo, 'GST370',51,'E-GST370 Indicator must be Y, to accept the GST Rebate from T777');
    end;
   end; //Fno
  end; //k

 //-------------------------------------
  Fno := GetFormNo('STLOAN');  // 20220520
  If (Vl(FetchElmFNo(RetNo, Fno, 35)) > Vl(FetchElmFNo(RetNo, Fno, 34))) then // 20220520
     SaveDiagnostic(RetNo, 'STLOAN', 35,'E-STLOAN-Student Loan interest claim exceeds the total available');

   If (Vl(FetchElmFNo(RetNo, Fno, 35)) = 0) and (Vl(FetchElmFNo(RetNo, FNo, 34)) >0) then //20220522
     SaveDiagnostic(RetNo, 'STLOAN', 35,'W-STLOAN-Student Loan Interest was not claimed');

   //-------------------------------------
  Fno := GetFormNo('T1206');
  S3FNo := GetFormNo('S3');
  if (Ret[RetNo].Age < 18) and
    (Vl(FetchElmFNo(RetNo, Fno, 1)) < Vl(FetchElmFNo(RetNo, Fno, 26))) then // 20190210
    SaveDiagnostic(RetNo, 'T1206', 1,'E-T1206-Ensure that Line 6835 includes amount on Line G (Client age less than 18)');

  //20190221
  x:=Vl(FetchElmFNo(RetNo,FNo,26))*1.16; //x:=Vl(FetchElm(RetNo,'S4',5));
  if Vl(FetchElmFNo(RetNo,FNo,1)) > Ret[RetNo].Lnn[12000] then
     SaveDiagnostic(RetNo, 'T1206', 1,'E-T1206-Line 6835 exceeds Line 120 of S4 Worksheet ($'+FormatFloat('#####,###.##',Ret[RetNo].Lnn[12000])+')');
  {
  if (Ret[RetNo].Age < 18) and (Vl(FetchElmFNo(RetNo,FNo,1)) < X) then
     SaveDiagnostic(RetNo, 'T1206', 1,'E-T1206-Line 6835 is less than Line G * 1.16 ($'+FormatFloat('#####,###.##',X)+')');
  }

  if Vl(FetchElmFNo(RetNo,FNo,17))> Ret[RetNo].Lnn[12010] then
     SaveDiagnostic(RetNo, 'T1206',17,'E-T1206-Line 6834 exceeds Line 180 of S4 Worksheet($'+FormatFloat('#####,###.##',Ret[RetNo].Lnn[12010])+')');
  if Vl(FetchElmFNo(RetNo,FNo,17))> Vl(FetchElmFNo(RetNo,FNo,1)) then
     SaveDiagnostic(RetNo, 'T1206',17,'E-T1206-Line 6834 exceeds Line 6835');
  {
  if (Ret[RetNo].Age < 18) and (Vl(FetchElmFNo(RetNo,FNo,17)) < X) then
     SaveDiagnostic(RetNo, 'T1206', 17,'E-T1206-Line 6835 is less than Line G * 1.16 (#'+FormatFloat('#####,###.##',X)+')');
  }


  if Vl(FetchElmFNo(RetNo, Fno, 26)) > 0 then // 20190210 Line G
  Begin
    if (Ret[RetNo].Age >= 18) then
    Begin
      // 20190211
      if Vl(FetchElm(RetNo, 'T1206', 2)) = 0 then
        SaveDiagnostic(RetNo, 'T1206', 2, 'E-T1206-Enter 50% of Line G =$' +
          FormatFloat('###,###.##', Vl(FetchElmFNo(RetNo, Fno, 26)) / 2));

      if Vl(FetchElm(RetNo, 'T1206', 2)) < (Vl(FetchElmFNo(RetNo, Fno, 26)) / 2)
      then
        SaveDiagnostic(RetNo, 'T1206', 2,
          'E-T1206-Line 3 is less that Line G /2');

      If (Vl(FetchElmFNo(RetNo, S3FNo, 32)) + Vl(FetchElmFNo(RetNo, S3FNo, 48))
        + Vl(FetchElmFNo(RetNo, S3FNo, 57)) = 0) then
      Begin
        SaveDiagnostic(RetNo, 'S3', 32,
          'E-S3-Please complete one of the T1206 lines to report Line G from T1206 of '
          + FormatFloat('###,###.##', Vl(FetchElmFNo(RetNo, Fno, 26))));
        SaveDiagnostic(RetNo, 'S3', 48,
          'E-S3-Please complete one of the T1206 lines to report Line G from T1206 of '
          + FormatFloat('###,###.##', Vl(FetchElmFNo(RetNo, Fno, 26))));
        SaveDiagnostic(RetNo, 'S3', 57,
          'E-S3-Please complete one of the T1206 lines to report Line G from T1206 of '
          + FormatFloat('###,###.##', Vl(FetchElmFNo(RetNo, Fno, 26))));
      end;
    End;
  End;
  //  t1206 ------------------------------------


  //T90 //20191211
  if Vl(FetchElm(RetNo,'T90',16))>0 then
  Begin
    if FetchElmFNo(RetNo,INFOFNo,128)='' then
      SaveDiagnostic(RetNo, 'INFO',128,'E-T90 Indian Exempt income on form T90. Enter Yes')
  End
  Else
   begin
     if FetchElmFNo(RetNo,INFOFNo,128)>'' then
      SaveDiagnostic(RetNo, 'INFO',128,'E-Complete T90-Indian Exempt income or enter No');
   end;

  //20260328
  x:=TotMultiple(RetNo,'T4',76);  //box 94 on the T4 RRP
  if Vl(FetchElm(RetNo,'T90',15))<x then
     SaveDiagnostic(RetNo, 'T90',15,'W-T90-Ensure Box 94 from T4 slips in included in the T90 form');


   //t185 PAD
  Fno := GetFormNo('T185'); // 20190113

  if Vl(FetchElmFNo(RetNo, Fno, 14)) > 0 then // amount of PAD
  Begin
    if FetchElmFNo(RetNo, Fno, 15) = '' then
      SaveDiagnostic(RetNo, 'T185', 15, 'E-T185-PAD Payment Date is required.');
    if FetchElmFNo(RetNo, Fno, 27) = '' then
      SaveDiagnostic(RetNo, 'T185', 27,
        'E-T185-PAD Signature Date must be entered on T185.');
  End;

  if FetchElmFNo(RetNo, Fno, 15) > '' then // payment date
  Begin
    if ValidatePadPaymentDate(FetchElm(RetNo, 'T185', 27),
      FetchElm(RetNo, 'T185', 15)) = 1 then
      SaveDiagnostic(RetNo, 'T185', 15,
        'E-T185-PAD Payment Date is a holiday. Please correct.');

    if ValidatePadPaymentDate(FetchElmFNo(RetNo, Fno, 27),
      FetchElmFNo(RetNo, Fno, 15)) = 2 then
      SaveDiagnostic(RetNo, 'T185', 15,
        'E-T185-PAD Payment Date must be at least 5 business days ahead.');

    if Vl(FetchElmFNo(RetNo, Fno, 14)) < 2 then // 20190208
      SaveDiagnostic(RetNo, 'T185', 14,
        'E-T185-PAD amount is required, not less than $2)');

    // 20190208
    if Vl(FetchElmFNo(RetNo, Fno, 14)) > 24999999.99 then
      SaveDiagnostic(RetNo, 'T185', 14,
        'E-T185-PAD amount exceeds maximum of $24,999.999.99');
  End;
 // -----------------

{
  // max amount not is not Constant[RY].BasicCppExemption,  error stopping efiling when the calc is correct, REMOVED
  //https://www.canada.ca/en/revenue-agency/services/tax/individuals/topics/about-your-tax-return/tax-return/completing-a-tax-return/deductions-credits-expenses/line-30800-cpp-qpp-contributions-through-employment.html
  // 20150221
  If Ret[RetNo].Lnn[30800] + Ret[RetNo].Lnn[31000] > Constant[RY].BasicCppExemption
  then
    SaveDiagnostic(RetNo, 'RC381', 0, 'E-Line 30800 and 31000 cannot exceed ' +
      FormatFloat('##,###.##', Constant[RY].BasicCppExemption));
}


  {//20240104
  //20200525
   If (ret[RetNo].Lnn[12200] + ret[RetNo].Lnn[13500] + ret[RetNo].Lnn[13700]
     +ret[RetNo].Lnn[13900] + ret[RetNo].Lnn[14100] + ret[RetNo].Lnn[14300]=0)
   and (Vl(FetchElm(RetNo,'RC381',46))<>0) then
     SaveDiagnostic(RetNo, 'RC381', 46, 'E-RC381 still shows self employment, Please remove it');
  }


  // 20140126
  If (Ret[RetNo].Age = 63) or (Ret[RetNo].Age = 64) then
  begin
    SaveDiagnostic(RetNo, 'INFO', 9,
      'W-INFO-Age 63/64. Discuss options for application of OAS and CPP')
  end;



 // 20210418
  if IsMultJurisdiction(RetNo) = True then
  Begin
    if Ret[RetNo].Lnn[30400] > 0 then
    Begin
      //20210414
      if Vl(FetchElm(RetNo, 'S5', 20)) = 0 then SaveDiagnostic(RetNo, 'S5', 20,
         'E-S5-Eligible Dependant Net Income is zero. On S5, Right click it and set it to $1, as required by CRA');
    End;
  end;



  // 20180327
  if IsMultJurisdiction(RetNo) = True then
  Begin
    if Ret[RetNo].Lnn[30425] > 0 then
    Begin
      //20210414
      if Vl(FetchElm(RetNo, 'S5', 60)) = 0 then SaveDiagnostic(RetNo, 'S5', 60,
         'E-S5-Eligible Dependant Net Income is zero. Right Click it and Set Override to $1');
    End;
  end;



  // 20170623
  If Vl(FetchElm(RetNo, 'T1OVP', 17)) > 0 then
  begin
    If FetchElm(RetNo, 'T1OVP', 1) = '' then
      SaveDiagnostic(RetNo, 'T1OVP', 1, 'E-T1OVP-Last Name missing');
    If FetchElm(RetNo, 'T1OVP', 2) = '' then
      SaveDiagnostic(RetNo, 'T1OVP', 2, 'E-T1OVP-First Name missing');
    If FetchElm(RetNo, 'T1OVP', 3) = '' then
      SaveDiagnostic(RetNo, 'T1OVP', 3, 'E-T1OVP-SIN missing');
    if RealNumeric(FetchElm(RetNo, 'T1OVP', 3)) = false then
      SaveDiagnostic(RetNo, 'T1OVP', 3, 'E-T1OVP-SIN enter mumbers only');
    if ValidSin(FetchElm(RetNo, 'T1OVP', 3)) = false then
      SaveDiagnostic(RetNo, 'T1OVP', 3, 'E-T1OVP-Invalid SIN');
  end;

  //----------------------------------------
  Fno:=GetFormNo('T5008#1');  //20200531
  If (FetchElmFNo(RetNo,FNo,214)>'') then  //missing rates
     SaveDiagnostic(RetNo,'T5008#1',214,'W-Auto-fill My Return -T5008-These Foreign Exchange Rates need to be added');

  //----------------------------------------
  FNo:=GetFormNo('RC381');  //20200102
  if (UpperCase(FetchElmFNo(RetNo,FNo,202))='Y')
  or (UpperCase(FetchElmFNo(RetNo,FNo,205))='Y')
  then
    SaveDiagnostic(RetNo, 'RC381', 202, 'W-RC381-You have overrides on the RC381 form');

  //ont child care relief
  If (Ret[RetNo].Lnn[21400] >0) and (Ret[RetNo].Province='ON') then  //child care claimed
  Begin
   if (EligibleForChildCareRelief(RetNo)=True) and (UpperCase(FetchElm(RetNo,'ON479A', 13))<>'Y') then
       SaveDiagnostic(RetNo, 'ON479A', 13, 'W-ON479A-ChildCare Relief not completed - You may qualify');
  end;

  // ------------------------------
  // 20170528
  Fno := GetFormNo('T1223');
  If (Vl(FetchElmFNo(RetNo, Fno, 118)) > 0) And
    (Vl(FetchElmFNo(RetNo, Fno, 119)) > 0) then
    SaveDiagnostic(RetNo, 'T1223', 118,
      'W-T1223-Clergy: Normally you are only allowed to claim Box (A) or (B). Check/override?');

  // 20170128
  If Vl(FetchElm(RetNo, 'DIRECT', 3)) > 0 then
    SaveDiagnostic(RetNo, 'DIRECT', 3,
      'E-Enter Educator School Supplies Expense in Form SchSupl form');

  //20200409
  If VL(FetchElm(RetNo, 'CFRAFILL',6))>0 then
  Begin
    SaveDiagnostic(RetNo, 'CFRAFILL', 6,'W-Auto-fill My Return Federal TUITION C/F imported via Auto-fill My Return. If legitimate C/F then enter them on S11');
  End;
  If VL(FetchElm(RetNo, 'CFRAFILL', 7))>0 then
  Begin
    SaveDiagnostic(RetNo, 'CFRAFILL', 7,'W-Auto-fill My Return -Prov TUITION C/F imported via Auto-fill My Return. If legitimate C/F then enter them on S11PRV');
  End;

  // 20160213
  Fno := GetFormNo('CDE');
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    SaveDiagnostic(RetNo, 'CDE', 0,
      'W-Auto-fill My Return CDE-Please review the CDE (Client Data Enquiry) form');
  end;
  If TotMultiple(RetNo, 'T4', 64) > 0 then
    SaveDiagnostic(RetNo, 'T4#1', 64,
      'W-Auto-fill my Return T4: Ensure that Box 85 should be entered on the Premiums paid.. of the Medical form');
  // 20160213 box 85
  If TotMultiple(RetNo, 'T4', 66) > 0 then
    SaveDiagnostic(RetNo, 'T4#1', 66,
      'W-Auto-fill My Return T4: Box 87 shows the exempt amount for emergency volunteers. See the T1 Guide');
  // 20160213 87 volunteer

  If (CountT5008DtlSlips(RetNo) > 0) and
    (Ret[RetNo].FrmHasData[GetFormNo('T5008')] = false) then
  Begin
    SaveDiagnostic(RetNo, 'T5008#1', 1,
      'W-Auto-fill My Return T5008DTL slips are not in T5008 Summary');
  end;
  If (Vl(FetchElm(RetNo, 'RRSP', 183)) > 0) or
    (Vl(FetchElm(RetNo, 'RRSP', 184)) > 0) then
    SaveDiagnostic(RetNo, 'RRSP', 103,
      'W-Auto-fill My Return RRSP: Ensure amounts are included in contributions');
  // ------------------

  // 20190209
  x := TotMultiple(RetNo, 'T1204', 3) + TotMultiple(RetNo, 'T1204', 4);
  Begin
    if TotMultiple(RetNo, 'T2125', 85) <> x then
    Begin
      SaveDiagnostic(RetNo, 'T1204#1', 3,
        'E-T1204 income is not reported on a T2125 business statement');
      // 20160213 box 85
      SaveDiagnostic(RetNo, 'T1204#1', 4,
        'E-T1204 income  is not reported on a T2125 business statement');
      // 20160213 box 85
    end;
  end;

  // 20150307
  Fno := GetFormNo('S4');
  If Vl(FetchElmFNo(RetNo, Fno, 49)) > 0 then
    SaveDiagnostic(RetNo, 'S4', 49,
      'E-S4-Safety Deposit not allowed. Delete it with DEL key');

  // 20130419
  Fno := GetFormNo('CFR');
  If Vl(FetchElmFNo(RetNo, Fno, 408)) > Vl(FetchElmFNo(RetNo, Fno, 425)) then
    SaveDiagnostic(RetNo, 'CFR', 408,
      'W-CFR-Applied losses exceed Capital gains (ln 6)');

  If IsHomeUse then
    // no error
  else
  begin
    If FetchElmFNo(RetNo, InfoFNo, 105) + FetchElmFNo(RetNo, InfoFNo, 106) = ''
    then // 20131212
      SaveDiagnostic(RetNo, 'INFO', 105,
        'E-Pre-assessment indicator is not set (or use Configure)'); // 20151224
    If FetchElmFNo(RetNo, InfoFNo, 134) + FetchElmFNo(RetNo, InfoFNo, 135) = ''
    then
      SaveDiagnostic(RetNo, 'INFO', 134,
        'E-Post-assessment indicator is not set (or use Configure)');
    // 20151224
  end;

  // ONBEN  //20101211
  If Ret[RetNo].Province = 'ON' then
  Begin
    Fno := GetFormNo('ONBEN');
    {trial
    //20230220
    If (ret[RetNo].Age <64)
        and (CalcAge(GetSpouseBirthDate(RetNo)) >=64)
        and (UpperCase(FetchElmFNo(RetNo,FNo,31)) <> 'X')
        and (IsSpouseNonResident(RetNo) = false)     //20110322  //20120229 //non resident
        then
        begin
        SaveDiagnostic(RetNo, 'ONBEN', 42,
          'W-ONBEN-The credit must be claimed by the spouse over 64)'); // 20151224
        end;

    }
    If (Ret[RetNo].Age >= 64) and (Ret[RetNo].Province = 'ON') and
      (IsDeceased(RetNo) = false) and (Vl(FetchElmFNo(RetNo, Fno, 8)) > 0)
    { 6112:property tax }
      and (FetchElmFNo(RetNo, Fno, 42) > '') // apply ben
    then
    begin
      If FetchElmFNo(RetNo, Fno, 4) = '' then
        SaveDiagnostic(RetNo, 'ONBEN', 4,
          'W-ONBEN-64 or older-Apply for OSHPTG?)');
    end;
    // 20170128
    if Vl(FetchElmFNo(RetNo, Fno, 8)) > 10000 then
      SaveDiagnostic(RetNo, 'ONBEN', 8, 'W-ONBEN-Property tax of $' +
        FormatFloat('####,###.##', Vl(FetchElmFNo(RetNo, Fno, 8))) +
        ' paid seems excessive. Check');

    if Vl(FetchElmFNo(RetNo, Fno, 7)) > 30000 then
      SaveDiagnostic(RetNo, 'ONBEN', 7, 'W-ONBEN-Rent paid of $' +
        FormatFloat('####,###.##', Vl(FetchElmFNo(RetNo, Fno, 7))) +
        ' seems excessive. Check');

    // 20101211
    If IsDeceased(RetNo) = false and (Ret[RetNo].Age >= 16) // 20110104
      and ((Vl(FetchElmFNo(RetNo, Fno, 7)) + Vl(FetchElmFNo(RetNo, Fno, 8)) +
      Vl(FetchElmFNo(RetNo, Fno, 12)) + Vl(FetchElmFNo(RetNo, Fno, 13)) > 0) or
      (FetchElmFNo(RetNo, Fno, 10) > '')) // stud resid
      and (UpperCase(FetchElmFNo(RetNo, Fno, 42)) = 'Y')
    then
    begin // 20120301
      If FetchElmFNo(RetNo, Fno, 6) = '' then
      Begin
        if ret[RetNo].MarStatus<3 then
          SaveDiagnostic(RetNo, 'ONBEN', 6,'W-ONBEN-Apply for ON-BEN/OEPTC? (unless the spouse did)')
        Else
          SaveDiagnostic(RetNo, 'ONBEN', 6,'W-ONBEN-Apply for ON-BEN/OEPTC if you meet the conditions?'); //20230218
      End;
    end;

    If FetchElmFNo(RetNo, Fno, 31) > '' then
    begin
      If FetchElmFNo(RetNo, Fno, 35) = '' then
        SaveDiagnostic(RetNo, 'ONBEN', 35,
          'E-ONBEN-Complete address in Part C');
    end;
    If Vl(FetchElmFNo(RetNo, Fno, 78)) = 0 then
      SaveDiagnostic(RetNo, 'ONBEN', 0,
        'W-ONBEN-Any Ontario credits (Rent, Property taxes?)');

    // 20111225
    If (FetchElmFNo(RetNo, Fno, 6) > '') or (FetchElmFNo(RetNo, Fno, 9) > '') or
      (FetchElmFNo(RetNo, Fno, 4) > '') then
    begin
      If (Vl(FetchElmFNo(RetNo, Fno, 7)) + Vl(FetchElmFNo(RetNo, Fno, 8)) +
        Vl(FetchElmFNo(RetNo, Fno, 12)) + Vl(FetchElmFNo(RetNo, Fno, 13)) = 0)
        and (FetchElmFNo(RetNo, Fno, 10) = '') // 20120301
      then
        SaveDiagnostic(RetNo, 'ONBEN', 0, 'E-ONBEN-Complete part A and B');
    end;
    // 20120126
    If (Vl(FetchElmFNo(RetNo, Fno, 78)) <> Vl(FetchElmFNo(RetNo, Fno, 7)) +
      Vl(FetchElmFNo(RetNo, Fno, 8)) + Vl(FetchElmFNo(RetNo, Fno, 12)) +
      Vl(FetchElmFNo(RetNo, Fno, 13))) and
      (UpperCase(FetchElm(RetNo, 'ONBEN', 42)) = 'Y')
    // claim by self  //20120127
    then
      SaveDiagnostic(RetNo, 'ONBEN', 78,
        'E-ONBEN-Payments not balanced with Part A - Do not enter pennies?');  //20230223

    If FetchElmFNo(RetNo, Fno, 4) > '' then
    // applied for senior grant  //20120219
    begin
      If Vl(FetchElm(RetNo, 'OEPTC', 82)) = 0 then
        SaveDiagnostic(RetNo, 'OEPTC', 82, 'W-OEPTC-Any amount received in ' +
          AppYear + ' ?');
    end;
  end; // end on ben

  // 20110407
  If (Ret[RetNo].Lnn[147] > 0) and (Ret[RetNo].Lnn[14600] > 0) and
    (Ret[RetNo].Lnn[23500] > 0) // clwaback
    and (Vl(FetchElm(RetNo, 'OTHDED', 55)) > 0) // adjustment
  then
    SaveDiagnostic(RetNo, 'OTHDED', 55,
      'W-OTHDED-Ln 250-You may want to verify adjustment with CRA');


  {//20230304  out it is not reliable
  If Ret[RetNo].Lnn[40425] > FedTaxBfrDividendTaxCredit(RetNo) then
   SaveDiagnostic(RetNo, 'T1', 143, //SaveDiagnostic(RetNo, 'S1', 105,  //20230304
      'W-Dividend Tax Credit exceeds Fed Tax. See Tax tip, T1Guide/Ln12000');  //20200530
  }

  // 20170623
  // 20140812

  If (Ret[RetNo].Lnn[31240] > 0) and (Ret[RetNo].Lnn[31220] > 0) then
    SaveDiagnostic(RetNo, 'T1',109, //SaveDiagnostic(RetNo, 'S1', 79,
    'E-Line 31220 and 31240: cannot be both claimed');  //'E-Line 36200 and 395: cannot be both claimed'); //20191220

  If (Ret[RetNo].Lnn[31220] > 0) and (Ret[RetNo].Lnn[31220] <> 6000) then
    SaveDiagnostic(RetNo, 'T1', 109, 'W-Line 31220 max can be $6,000');   //20250131

  If (Ret[RetNo].Lnn[31240] > 0) and (Ret[RetNo].Lnn[31240] <> 6000) then
    SaveDiagnostic(RetNo, 'T1', 110, 'W-Line 31240 max can be $6,000');  //20250131

  If (UpperCase(FetchElmFNo(RetNo, InfoFNo, 87)) = 'Y') and
    (UpperCase(FetchElmFNo(RetNo, InfoFNo, 85)) = 'Y') and
    (FetchElmFNo(RetNo, InfoFNo, 89) < AppYear) then
  begin
    SaveDiagnostic(RetNo, 'INFO', 89, 'W-Disability approval required (T2201)');
  end;

  If Ret[RetNo].MarStatus = 0 then
    SaveDiagnostic(RetNo, 'INFO', 11, 'M-Marital Status required');


  If FetchElmFNo(RetNo, InfoFNo, 2) = '' then
    SaveDiagnostic(RetNo, 'INFO', 2, 'W-First Name required. (If first-time-filer you may enter X');  //20231214
  //first time filer
  if IsFirstTimeFiler(RetNo) then  //first time filer  //20240223
  Begin
   if Uppercase(FetchElmFNo(RetNo, InfoFNo,235))='X' then
     SaveDiagnostic(RetNo, 'INFO', 235, 'W-INFO-FIRST TIME FILER-Enter a real Second Name if the client has one');  //20231214

   If FetchElmFNo(RetNo, InfoFNo, 56)>'' then  //Last Name change  //20230306
    SaveDiagnostic(RetNo, 'INFO', 56, 'E-First-time filer - Remove the Last Name change indicator');
  End;


  If FetchElmFNo(RetNo, InfoFNo, 5) = '' then
    SaveDiagnostic(RetNo, 'INFO', 5, 'M-Last Name required. (If first-time-filer and No name, you may enter X');

  If FetchElmFNo(RetNo, InfoFNo, 89) > '' then { yr to disability }
  begin
    k := MyStrToInt(FetchElmFNo(RetNo, InfoFNo, 89));
    If (k < StrToInt(AppYear)) or (k > 2050) then
      SaveDiagnostic(RetNo, 'INFO', 89, 'E-Invalid year');
  end;

  If Ret[RetNo].FrmHasData[GetFormNo('PRIVAT#1')] = True then
    SaveDiagnostic(RetNo, 'PRIVAT#1', 0, 'W-Private Notepad has notes');

  If FetchElmFNo(RetNo, InfoFNo, 110) > '' then { first time disab }
  begin
    If Ret[RetNo].FrmHasData[GetFormNo('T2201')] = false then
      SaveDiagnostic(RetNo, 'INFO', 110, 'W-T2201 should be prepared/filed');
  end;

  (* 20150305
    If FetchElmFNo(RetNo,InfoFNo,102) > '' then  //discounted
    begin
    If FetchElmFNo(RetNo,InfoFNo,48) = '' then
    SaveDiagnostic(RetNo,'INFO',48,'W-Discounted return. Include your name as Care Of?');
    end;
  *)
  If ValidFirstLastName(FetchElmFNo(RetNo, InfoFNo, 2)) = false then
    SaveDiagnostic(RetNo, 'INFO', 2, 'W-First name may be invalid');

  If ValidFirstLastName(FetchElmFNo(RetNo, InfoFNo, 5)) = false then
    SaveDiagnostic(RetNo, 'INFO', 5, 'W-Last name may be invalid');

  // 20150404
  If not ValidSin(FetchElmFNo(RetNo, InfoFNo, 4)) then
  begin
    SaveDiagnostic(RetNo, 'INFO', 4, 'E-Spouse SIN is invalid');
  end;

  If Ret[RetNo].Province <> 'ZZ' then
  begin
    If not ValidSin(FetchElmFNo(RetNo, InfoFNo, 3)) then
      SaveDiagnostic(RetNo, 'INFO', 3, 'M-SIN is invalid');
  end;

  if FetchElmFNo(RetNo, InfoFNo, 173)='' then //no foreign address  //20240328
  Begin
   If FetchElmFNo(RetNo, InfoFNo, 6) + FetchElmFNo(RetNo, InfoFNo, 68) +
     FetchElmFNo(RetNo, InfoFNo, 163) = '' then
     SaveDiagnostic(RetNo, 'INFO', 6, 'E-Address missing');
  End;

  If (Ret[RetNo].Lnn[45300] > 0) and (IsDeceased(RetNo) = false) then
  begin
    If FetchElm(RetNo, 'RC201', 87) = '' then
      SaveDiagnostic(RetNo, 'RC201', 87,
        'T-RC201-Consider application for CWB next year');
  end;

  // 20150627
  Fno := GetFormNo('T1033');
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    If Vl(FetchElmFNo(RetNo, Fno, 45)) > 0 then
      SaveDiagnostic(RetNo, 'T1033', 45, 'W-T1033-Instalments are due');
  end;
  // ----------------

  { //20170126
    Fno:=GetFormNo('RC310');
    If Ret[RetNo].FrmHasData[Fno] then
    begin
    If FetchElmFNo(RetNo,FNo,3) ='' then
    SaveDiagnostic(RetNo,'RC310',3,'E-RC310-tax year of disposition is missing');
    end;
  }
  Fno := GetFormNo('T1231'); // 20130114
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    If Vl(FetchElmFNo(RetNo, Fno, 14)) > Vl(FetchElmFNo(RetNo, Fno, 10)) then
      SaveDiagnostic(RetNo, 'T1231', 14,
        'E-T1231-Carry-back cannot exceed the availabale credit');
  end;

  Fno := GetFormNo('PADINFO');
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    If Length(FetchElmFNo(RetNo, Fno, 1)) <> 3 then
      SaveDiagnostic(RetNo, 'PADINFO', 1,
        'E-PadInfo-Institution must be 3 characters');
    If Length(FetchElmFNo(RetNo, Fno, 2)) <> 5 then
      SaveDiagnostic(RetNo, 'PADINFO', 2,
        'E-PadInfo-Branch must be 5 characters');
    If Length(FetchElmFNo(RetNo, Fno, 3)) < 3 then
      SaveDiagnostic(RetNo, 'PADINFO', 3,
        'E-PadInfo-Account is incorrect. Enter up to 12 characters');
    If (Length(FetchElmFNo(RetNo, Fno, 1)) = 0) or
      (Length(FetchElmFNo(RetNo, Fno, 2)) = 0) or
      (Length(FetchElmFNo(RetNo, Fno, 3)) = 0) then
      SaveDiagnostic(RetNo, 'PADINFO', 1,
        'E-PadInfo-Complete all bank boxes, or delete them all');    //20200408
  end;

  // 200121215
  Fno := GetFormNo('CPT20');
  If UpperCase(FetchElmFNo(RetNo, Fno, 80)) = 'Y' then
  begin
    If Vl(FetchElmFNo(RetNo, Fno, 19)) = 0 then
      SaveDiagnostic(RetNo, 'CPT20', 19,
        'W-CPT20-You may enter amount of election');

    If Vl(FetchElmFNo(RetNo, Fno, 19)) > MinR(Vl(FetchElmFNo(RetNo, Fno, 12)),
      Vl(FetchElmFNo(RetNo, Fno, 18))) then
      SaveDiagnostic(RetNo, 'CPT20', 19,
        'W-CPT20-Election exceeds allowable amount'); // 20140203
  end;

  If (FetchElmFNo(RetNo, InfoFNo, 33) = '') and (ShowSalutationWarning = True)
  then
    SaveDiagnostic(RetNo, 'INFO', 33,
      'W-INFO-Salutation title (Mr., Mrs..) missing');

  { 20110714
    If (Length(FetchElmFNo(RetNo,InfoFNo,14)) < 3)
    and (not ValidShortProvince(FetchElmFNo(RetNo,InfoFNo,14)))
    and (Ret[RetNo].Province <> 'ZZ')
    then
    SaveDiagnostic(RetNo,'INFO',14,'E-INFO-Prov code invalid (use two character code or full name');
  }
  If (Ret[RetNo].Province = 'ZZ')
  and (GetResidencytype(RetNo)<>'7')  //20240515
  then
  begin
    If FetchElmFNo(RetNo, InfoFNo, 81) + FetchElmFNo(RetNo, InfoFNo, 82) +
      FetchElmFNo(RetNo, InfoFNo, 83) + FetchElmFNo(RetNo, InfoFNo, 84) = ''
    then
      SaveDiagnostic(RetNo, 'INFO', 81, 'E-Non resident type required');
  end;

  //and (GetResidencytype(retno)<>'6') and (GetResidencytype(RetNo)<>'7')  //20240426


  If (Length(FetchElmFNo(RetNo, InfoFNo, 14)) > 2) then
    SaveDiagnostic(RetNo, 'INFO', 14,
      'E-Prov Name invalid, use two character code');

  If FetchElmFNo(RetNo, InfoFNo, 4) = '' then
    If (Ret[RetNo].MarStatus = 1) or (Ret[RetNo].MarStatus = 2) then
      SaveDiagnostic(RetNo, 'INFO', 4, 'W-Spouse SIN missing');

  If FetchElmFNo(RetNo, InfoFNo, 20) = '' then
    If (Ret[RetNo].MarStatus = 1) or (Ret[RetNo].MarStatus = 2) then
      SaveDiagnostic(RetNo, 'INFO', 20, 'W-Spouse name missing');

  If Vl(FetchElmFNo(RetNo, InfoFNo, 19)) = 0 then
  Begin
    If (Ret[RetNo].MarStatus < 3) and (FetchElmFNo(RetNo, InfoFNo, 123) = '')
    then
      SaveDiagnostic(RetNo, 'INFO', 19,
        'E-Spouse income not entered (see Schedule 2)');
  end;

  If Ret[RetNo].Lnn[10120] > Ret[RetNo].Lnn[10100] then
    SaveDiagnostic(RetNo, 'T1', 204, 'E-Line 102 exceeds line 101');

  If (Ret[RetNo].Lnn[11700] > 0) and (Ret[RetNo].Lnn[11701] > 0) then
    SaveDiagnostic(RetNo, 'T1', 238,
      'E-UCCB. Cannot have amounts in both Line 117 and 185');

  { 20180211
    If CountKidsUnder18(RetNo) >0 then  //20160219 //20160223 Igor
    begin
    If Ret[RetNo].Lnn[11700] + Vl(FetchElmFNo(RetNo,InfoFNo,131))+Ret[RetNo].Lnn[11701]=0 then
    SaveDiagnostic(RetNo,'RC62#1',0,'W-UCCB not entered');
    end;
  }
  If (FetchElmFNo(RetNo, InfoFNo, 11) + FetchElmFNo(RetNo, InfoFNo, 12) > '')
    and (FetchElmFNo(RetNo, InfoFNo, 59) = '') then
    SaveDiagnostic(RetNo, 'INFO', 59, 'W-Spouse Birthdate missing');

  Fno := GetFormNo('DON');
  If (Vl(FetchElmFNo(RetNo, Fno, 172)) > 0) and
    (Vl(FetchElmFNo(RetNo, Fno, 173)) = 0) and (Ret[RetNo].MarStatus > 2)
  // 20150320  single
  then
    SaveDiagnostic(RetNo, 'DON', 173, 'W-DON-Cultural gifts not claimed');

  (*
   //20210315
  if Vl(FetchElmFNo(RetNo, Fno, 191))>0 then
  Begin
   If Vl(FetchElmFNo(RetNo, Fno, 191)) <> Vl(FetchElmFNo(RetNo, Fno, 110)) then
   Begin
     SaveDiagnostic(RetNo, 'DON', 191, 'W-DON-Total claim not matching detail claims. Override the Claim column');
     SaveDiagnostic(RetNo, 'DON', 110, 'W-DON-Total claim not matching detail claims. Override the Claim column');
   End;
  End;
  *)
  If Vl(FetchElmFNo(RetNo, Fno, 139)) > 0 then // 20120406
  begin
    SaveDiagnostic(RetNo, 'DON', 138,
      'W-DON-Enter the C/f as Expired. Cannot be claimed next year');
  end;

  (* 20190316
  If (Vl(FetchElmFNo(RetNo, Fno, 88)) > 0) And
    (UpperCase(FetchElmFNo(RetNo, Fno, 182)) <> 'Y') // 20150217
  then // 20140212
  begin
    If Vl(FetchElmFNo(RetNo, Fno, 186)) = 0 then
      SaveDiagnostic(RetNo, 'DON', 186,
        'W-DON-Can you claim the first-time donor?');
  end;
  *)

  If (Vl(FetchElmFNo(RetNo, Fno, 185)) > 0) // us Donations
    and (Vl(FetchElmFNo(RetNo, Fno, 123)) = 0) then // us NI
    SaveDiagnostic(RetNo, 'DON', 123,
      'W-DON-US Donations but US income not entered');

  Fno := GetFormNo('RPP');
  If (FetchElmFNo(RetNo, Fno, 7) > '') and (Vl(FetchElmFNo(RetNo, Fno, 7)) < 1)
  then
    SaveDiagnostic(RetNo, 'RPP', 7,
      'W-RPP-Number of years should be a whole number');
  //---------------
  Fno := GetFormNo('FORINC');
  If (Vl(FetchElmFNo(RetNo, Fno, 109)) > 0) and (FetchElmFNo(RetNo, Fno, 1) = '')
  then
    SaveDiagnostic(RetNo, 'FORINC', 1,
      'E-Foreign Income-Enter country name (For US enter US)');
  If (Vl(FetchElmFNo(RetNo, Fno, 111)) > 0) and (FetchElmFNo(RetNo, Fno, 2) = '')
  then
    SaveDiagnostic(RetNo, 'FORINC', 2,
      'E-Foreign Income-Enter country name (For US enter US)');
  If (Vl(FetchElmFNo(RetNo, Fno, 113)) > 0) and (FetchElmFNo(RetNo, Fno, 2) = '')
  then
    SaveDiagnostic(RetNo, 'FORINC', 3,
      'E-Foreign Income-Enter country name (For US enter US)');

  //20200504      //20210418
  If (Vl(FetchElmFNo(RetNo, Fno, 157)) > 0) and (VL(FetchElmFNo(RetNo, Fno, 158)) =0) then
   SaveDiagnostic(RetNo, 'FORINC', 157,'E-Foreign Income-There is no tax paid. Override the INCOME with Shift F2 and enter 0)');
  If (Vl(FetchElmFNo(RetNo, Fno, 158)) > 0) and (VL(FetchElmFNo(RetNo, Fno, 158)) <1) then
   SaveDiagnostic(RetNo, 'FORINC', 158,'E-Foreign Income-Tax less than $1. Override the TAX with Shift F2 and enter 0)');


  If (Vl(FetchElmFNo(RetNo, Fno, 159)) > 0) and (VL(FetchElmFNo(RetNo, Fno, 160)) =0) then
   SaveDiagnostic(RetNo, 'FORINC', 159,'E-Foreign Income-There is no tax paid. Override the INCOME with Shift F2 and enter 0)');
  If (Vl(FetchElmFNo(RetNo, Fno, 160)) > 0) and (VL(FetchElmFNo(RetNo, Fno, 160)) <1) then
   SaveDiagnostic(RetNo, 'FORINC', 160,'E-Foreign Income-Tax less than $1. Override the TAX with Shift F2 and enter 0)');


  If (Vl(FetchElmFNo(RetNo, Fno, 161)) > 0) and (VL(FetchElmFNo(RetNo, Fno, 162)) =0) then
   SaveDiagnostic(RetNo, 'FORINC', 161,'E-Foreign Income-There is no tax paid. Override the INCOME with Shift F2 and enter 0)');
  If (Vl(FetchElmFNo(RetNo, Fno, 162)) > 0) and (VL(FetchElmFNo(RetNo, Fno, 162)) <1) then
   SaveDiagnostic(RetNo, 'FORINC', 162,'E-Foreign Income-Tax less than $1. Override the TAX with Shift F2 and enter 0)');

  //


  Fno := GetFormNo('RC62#1');
  If (FetchElmFNo(RetNo, Fno, 7) > '') and (FetchElmFNo(RetNo, Fno, 9) = '')
  then
    SaveDiagnostic(RetNo, 'RC62#1', 9, 'E-UCCB-Enter name of kid');

  // 20130316    If (FetchElmFNo(RetNo,FNo,7)>'') then SaveDiagnostic(RetNo,'DEPEND',0,'W-UCCB-Ensure Dependant reports UCCB income');

  S := FetchElmFNo(RetNo, Fno, 10); // depend id
  j := (MyStrToInt(RightStr(S, 1)) - 1) * 15 + 5 + 8;
  If (S > '') // dependant id
    and (GetNetIncomeForDependantId(RetNo, S) < TotMultiple(RetNo, 'RC62', 22))
  // inc <=UCCB
  then
    SaveDiagnostic(RetNo, 'DEPEND', j, 'E-UCCB-Income of ' + FetchElmFNo(RetNo,
      Fno, 8) + ' does not include designated UCCB');

  // 20170127
  Fno := GetFormNo('S9');
  if Vl(FetchElmFNo(RetNo, Fno, 24)) > Vl(FetchElmFNo(RetNo, Fno, 11)) then
    SaveDiagnostic(RetNo, 'S9', 24, 'E-Line 19 cannot exceed Line 16');  //20200216
  if Vl(FetchElmFNo(RetNo, Fno, 16)) < 0 then
    SaveDiagnostic(RetNo, 'S9', 16, 'E-Line 1 cannot be negative');

  Fno := GetFormNo('TOOLEXP');
  If UpperCase(FetchElmFNo(RetNo, Fno, 54)) = 'Y' then
  begin
    If (Vl(FetchElmFNo(RetNo, Fno, 32)) = 0) then
      SaveDiagnostic(RetNo, 'TOOLEXP', 32,
        'E-Tools deduction-Enter cost of tools as apprentice');
  end;

  // t1032
  Fno := GetFormNo('T1032');
  If Ret[RetNo].MarStatus < 3 then
  begin
    If (Vl(FetchElm(RetNo, 'PNSDED', 3)) > 0) then
    begin
      If FetchElmFNo(RetNo, Fno, 34) <> 'Y' then
        SaveDiagnostic(RetNo, 'T1032', 0,
          'T-T1032-Consider splitting the pension income');
    end;
  end;

  // 20180607 Allow the automatic Y in Re-file
  (*
    //20180301
    if UpperCase(FetchElmFNo(RetNo,FNo,38))='Y' then //override in pensin split form
    Begin
    if FetchElm(RetNo,'INFO',223)>'' then  //i.e. R1 etc
    SaveDiagnostic(RetNo,'T1032',38,'E-T1032-This is a refiled return.  You cannot change the Pension Split. Remove the Y');
    End;
  *)

  // 20150314
  If (Vl(FetchElmFNo(RetNo, Fno, 64)) > 0) and
    (Vl(FetchElmFNo(RetNo, Fno, 63)) = 0)
  // [64] is not visible=what it should be in [63]
  then // a non visible field has the expected approximate value
    SaveDiagnostic(RetNo, 'T1032', 63,
      'W-T032-Any tax related to Box 17 of pensioner T4ARCA?');
  If UpperCase(FetchElmFNo(RetNo, Fno, 50)) = 'Y' then
    SaveDiagnostic(RetNo, 'T1032', 50,
      'W-T032-Override used on line K. Please check');
  If (MarStatusChanged(RetNo)) or (IsDeceased(RetNo)) then
  begin
    If (UpperCase(FetchElmFNo(RetNo, Fno, 34)) = 'Y') then
    begin
      If (FetchElmFNo(RetNo, Fno, 11) = '') or
        (FetchElmFNo(RetNo, Fno, 11) = '12') or // 20110320
        (FetchElmFNo(RetNo, Fno, 31) = '') then
        SaveDiagnostic(RetNo, 'T1032', 11,
          'W-T1032-Marital status changed or deceased spouse. Revise months');
    end;
  end;
  If (UpperCase(FetchElmFNo(RetNo, Fno, 34)) = 'Y') then
  begin
    If (Vl(FetchElmFNo(RetNo, Fno, 32)) = 0) then
      SaveDiagnostic(RetNo, 'T1032', 32, 'E-T1032-Split % not entered');

    If (FetchElmFNo(RetNo, Fno, 42) = '') and (FetchElmFNo(RetNo, Fno, 45) = '')
    then
    begin
      SaveDiagnostic(RetNo, 'T1032', 42, 'E-T1032-Pensioner not defined');
      SaveDiagnostic(RetNo, 'T1032', 45, 'E-T1032-Pensioner not defined');
    end;
  end;

  If (Vl(FetchElmFNo(RetNo, Fno, 32)) > 0) and
    (Vl(FetchElmFNo(RetNo, Fno, 10)) = 0) then
    SaveDiagnostic(RetNo, 'T1032', 10,
      'W-T1032-Pensioner eligible pension is missing');

  If (Vl(FetchElmFNo(RetNo, Fno, 32)) > 0) and
    (Vl(FetchElmFNo(RetNo, Fno, 24)) = 0) then
    SaveDiagnostic(RetNo, 'T1032', 24, 'W-T1032-Enter tax withheld');
  // end T1032

  If SubjectToMinTax(RetNo) then
  begin
   SaveDiagnostic(RetNo, 'T1', 126, 'W-Minimum Tax applied'); //SaveDiagnostic(RetNo, 'S1', 126, 'W-Minimum Tax applied');
  end;

  If UpperCase(FetchElm(RetNo, 'S11', 28)) = 'Y' then
    SaveDiagnostic(RetNo, 'S11', 28,
      'W-S11-CRA may not accept override. Check with CRA first');

  //20230328
  If (Vl(FetchElm(RetNo, 'S11', 15)) >0)
  and(Vl(FetchElm(RetNo, 'S11', 27)) = 0) then
    SaveDiagnostic(RetNo, 'S11', 27,'W-S11-CTC-Canada Training Credit- Claim it on S11');

  If Not EditLongPrv(FetchElmFNo(RetNo, InfoFNo, 1)) then
    SaveDiagnostic(RetNo, 'INFO', 1, 'E-Prov of residence-invalid');


  // If Ret[RetNo].Lnn[31800]+Ret[RetNo].Lnn[32400]>0  //20190407  //out again
  If (AnyDisabledDependant(RetNo) = True)
  then
  begin
    If Ret[RetNo].Lnn[31800] = 0 then // 20150413
      SaveDiagnostic(RetNo, 'TRANSF', 71,
        'W-TRANSF-Any disability transfer from dependants?'); // 20190407  //insted of 4
  end;

  Fno := GetFormNo('TRANSF');
  If UpperCase(FetchElmFNo(RetNo, Fno, 1)) = 'Y' then  //Names automatically
  Begin
      k := 0;   // 20190407  Tuition/disab  diagnostics
      Repeat
      //tuition
      if Vl(FetchElmFNo(RetNo, Fno, 41 + k))>0 then  //tot tution
      Begin
           If (Vl(FetchElmFNo(RetNo, Fno, 59 + k)) =0) then
              SaveDiagnostic(RetNo, 'TRANSF', 59 + k,'E-TRANSF-Enter amount from Dependant T1, lines 1 to 20 At least $'
                 +FormatFloat('##,###.##',Ret[RetNo].Lnn[30000])); //(RetNo))); //Constant[RY].BasicPersonalAmount)); //20201122
           If (Vl(FetchElmFNo(RetNo, Fno, 110 + k)) =0) then
              SaveDiagnostic(RetNo, 'TRANSF', 110 + k,'W-TRANSF-Enter any amount claimed by student');
      end;
      Inc(k, 1);
      until k > 5;


     k:=0;      //Disability section //20190410
     Repeat
     If (FetchElmFNo(RetNo, Fno, 11 + k) >'') then //disabled dependant //20100410
     Begin
        If (Vl(FetchElmFNo(RetNo, Fno, 87 + k))=0) then
          SaveDiagnostic(RetNo, 'TRANSF', 87 + k,'W-TRANSF-Any child care for disabled dependant?');

        If (Vl(FetchElmFNo(RetNo, Fno, 93 + k)) = 0) then
          SaveDiagnostic(RetNo, 'TRANSF', 93 + k,'W-TRANSF-Any attendant care claimed for dependant?');

        if Vl(FetchElmFNo(RetNo, Fno, 128 + k))=0 then
          SaveDiagnostic(RetNo, 'TRANSF', 128 + k,'E-TRANSF-Enter amount from Dependant T1, lines 1 to 18 At least $'
              +FormatFloat('##,###.##',Ret[RetNo].Lnn[30000])); //GetPersonalAmount(RetNo)));//Constant[RY].BasicPersonalAmount)); //20201118

     End;
     Inc(k, 1);
     until k > 5;
  end;

  Fno := GetFormNo('PTRANSF');
  // 20190410  Tuition/disab  diagnostics
  If UpperCase(FetchElmFNo(RetNo, Fno, 1)) = 'Y' then    //names auto
  Begin
      //tuition section
      k := 0;
      Repeat
        //tuition
        if Vl(FetchElmFNo(RetNo, Fno, 41 + k))>0 then
        Begin
           If (Vl(FetchElmFNo(RetNo, Fno, 59 + k)) =0) then
              SaveDiagnostic(RetNo, 'PTRANSF', 59 + k,'W-PTRANSF-Enter amount from Dependant tax form, lines 58040 to 58480 At least $'
                 +FormatFloat('##,###.##',PrvConstant[RY].PrvPersAmount)); //20200401 E to W    //20200425 58480
           If (Vl(FetchElmFNo(RetNo, Fno, 110 + k)) =0) then
              SaveDiagnostic(RetNo, 'PTRANSF', 110 + k,'W-PTRANSF-Enter any amount claimed by student');
        End;
        Inc(k, 1);
        until k > 5;

      //Disabilty Section
      k:=0;
      Repeat
         if (FetchElmFNo(RetNo, Fno, 11 + k)>'')   //20190410
         and (Vl(FetchElmFNo(RetNo, Fno, 128 + k))=0) then
            SaveDiagnostic(RetNo, 'PTRANSF', 128 + k,'W-PTRANSF-Enter amount from Dependant tax form, lines 58040 to 58440 At least $'
                 +FormatFloat('##,###.##',PrvConstant[RY].PrvPersAmount)); //20200401   //20200425 58440
      Inc(k, 1);
      until k > 5;
  end;


  If (IsSelfEmployed(RetNo)) and (FetchElmFNo(RetNo, InfoFNo, 21) = '') then
    SaveDiagnostic(RetNo, 'INFO', 21, 'E-Province of Self Employment required');

  If Ret[RetNo].Province = 'QC' then
  begin
    If (GetSelfEmplIncome(RetNo) > 2000) and (Vl(FetchElm(RetNo, 'S10', 17)) = 0)
    then
      SaveDiagnostic(RetNo, 'S10', 17,
        'W-S10-Province QC. No Self-employment entered');

    If (GetSelfEmplIncome(RetNo) > 0) and (Vl(FetchElm(RetNo, 'S8Q', 1)) = 0)
    then
      SaveDiagnostic(RetNo, 'S8Q', 1,
        'W-S8Q-Province QC. No Self-employment entered');
  end;

  If (FetchElmFNo(RetNo, InfoFNo, 21) > '') and (IsSelfEmployed(RetNo) = false)
  then
  begin
    SaveDiagnostic(RetNo, 'INFO', 21,
      'E-Province of S/E entered but no S/E income');
  end;

  //20220128
  Fno:=GetFormNo('T2091#1');
  if (Vl(FetchElmFNo(RetNo,FNo,12))>0)
  and (Vl(FetchElmFNo(RetNo,FNo,14))=0)
  and (FetchElm(RetNo,'S3',139)='')   //not all option  //20220222
  then  SaveDiagnostic(RetNo, 'T2091#1', 14,'E-T2091#1 Adjusted Cost Base was not entered');

  Fno:=GetFormNo('T2091#2');
  if FNo>0 then
  begin
   if (Vl(FetchElmFNo(RetNo,FNo,12))>0)
   and (Vl(FetchElmFNo(RetNo,FNo,14))=0)
  // and (FetchElm(RetNo,'S3',139)='')   //not all option  //20220222
   then  SaveDiagnostic(RetNo, 'T2091#2', 14,'E-T2091#2 Adjusted Cost Base was not entered');
  end;

  Fno:=GetFormNo('T1255#1');  //princ deceased
  if FNo>0 then
  begin
   if (Vl(FetchElmFNo(RetNo,FNo,12))>0)
   and (Vl(FetchElmFNo(RetNo,FNo,14))=0)
   and (FetchElm(RetNo,'S3',139)='')   //is not option 1 all option  //20220229
   then  SaveDiagnostic(RetNo, 'T1255#1', 14,'E-T1255#1 Adjusted Cost Base was not entered');
  end;

  Fno:=GetFormNo('T1255#2');  //princ deceased
  if FNo>0 then
  begin
   if (Vl(FetchElmFNo(RetNo,FNo,12))>0)
   and (Vl(FetchElmFNo(RetNo,FNo,14))=0)
   then  SaveDiagnostic(RetNo, 'T1255#2', 14,'E-T1255#2 Adjusted Cost Base was not entered');
  end;
  //-------------------------

  {
  Fno := GetFormNo('S3');
  if FetchElmFNo(RetNo, Fno, 139) + FetchElmFNo(RetNo, Fno, 140) +
    FetchElmFNo(RetNo, Fno, 148) = '' then
  Begin
    If (Ret[RetNo].FrmHasData[GetFormNo('T2091#1')] = True) Or
      (Ret[RetNo].FrmHasData[GetFormNo('T1255#1')] = True) then
      SaveDiagnostic(RetNo, 'S3', 139,
        'E-S3-T2091 or T1255 Principal residence used. Complete Box 179');
  End;

  If Vl(FetchElm(RetNo, 'T2091#1', 137)) > Vl(FetchElmFNo(RetNo, Fno, 81))
  // 20180304
  then
    SaveDiagnostic(RetNo, 'S3', 73,
      'W-T2091 gain was not added to S3, Personal Property'); // 20170420

  If Vl(FetchElm(RetNo, 'T1255#1', 137)) > Vl(FetchElmFNo(RetNo, Fno, 81))
  // 20180304
  then
    SaveDiagnostic(RetNo, 'S3', 73,
      'W-T1255 gain was not added to S3, Personal Property');
  }


  {
  //20200209
  If Optrec.T1013Warn = 'Never' then
    // do nothing
  else If Optrec.T1013Warn = 'Always' then
  begin
    If (FetchElm(RetNo, 'AuthRep#1', 26) = '') then
      SaveDiagnostic(RetNo, 'AuthRep#1', 26, 'W-  //AuthRep was not prepared');
  end
  Else // only if not prepared last year
  begin
    If (FetchElm(RetNo, 'AuthRep#1', 26) = '') then
    begin
      If FetchElm(RetNo, 'AuthRep#1', 11) = '' then
        SaveDiagnostic(RetNo, 'AuthRep#1', 26, 'W-AuthRep was not prepared');
    end;
  end;
  }


  //jz//20260128
  if Ret[RetNo].FormHasData['T2048#1'] then
    if (FetchElm(RetNo, 'T2048#1', 103) = '') and (FetchElm(RetNo, 'T2048#1', 104) = '') then
        SaveDiagnostic(RetNo, 'T2048#1', 103, 'W-T2048: please select an election type');


  // 20180114
  Fno := GetFormNo('T2091#1');
  // 20180304
  if IsDeceased(RetNo) then
  Begin
    If Ret[RetNo].FrmHasData[GetFormNo('T2091#1')] then
      SaveDiagnostic(RetNo, 'T2091#1', 1,
        'E-T2091-Principal Residence. For deceased taxpayers, clear T2091 and fill form T1255');
  End;

  If Ret[RetNo].FrmHasData[Fno] then
  begin
    If (FetchElmFNo(RetNo, Fno, 1) = '') then
      SaveDiagnostic(RetNo, 'T2091#1', 1, 'E-T2091: Street is required');
    // yr 20180116
    If Length(FetchElmFNo(RetNo, Fno, 23)) <> 4 then
      SaveDiagnostic(RetNo, 'T2091#1', 23, 'E-T2091: Valid year is required');

    for k := 19 to 22 do
    Begin
      If (FetchElmFNo(RetNo, Fno, k) = '') then
        SaveDiagnostic(RetNo, 'T2091#1', k,
          'E-T2091: Property address is required');
    End;
  end;

  // 20180304
  Fno := GetFormNo('T1255#1');
  begin
    if IsDeceased(RetNo) = false then
    Begin
      If Ret[RetNo].FrmHasData[GetFormNo('T1255#1')] then
        SaveDiagnostic(RetNo, 'T1255#1', 1,
          'E-T1255-Principal Residence. For Non-deceased taxpayers, clear T1255 and fill form T2091');
    End;
    If (IsDeceased(RetNo) = True) and (Ret[RetNo].FrmHasData[Fno]) then
    begin
      If (FetchElmFNo(RetNo, Fno, 1) = '') then
        SaveDiagnostic(RetNo, 'T1255#1', 1, 'E-T1255: Street is required');
      // yr 20180116
      If Length(FetchElmFNo(RetNo, Fno, 23)) <> 4 then
        SaveDiagnostic(RetNo, 'T1255#1', 23, 'E-T1255: Valid year is required');

      for k := 19 to 22 do
      Begin
        If (FetchElmFNo(RetNo, Fno, k) = '') then
          SaveDiagnostic(RetNo, 'T1255#1', k,
            'E-T1255: Property address is required');
      End;
    end;
  end;
//---------------------------
  Fno := GetFormNo('CONSENT#1');
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    Inst := '#1';
    ValidateCONSENT(RetNo, Fno, Inst);
  end;
  Fno := GetFormNo('CONSENT#2');
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    Inst := '#2';
    ValidateCONSENT(RetNo, Fno, Inst);
  end;

  If Ret[RetNo].FrmHasData[GetFormNo('ADOPT#1')] then
  begin
    If FetchElm(RetNo, 'ADOPT#1', 2) = '' then
      SaveDiagnostic(RetNo, 'ADOPT#1', 2, 'E-Adoption birthdate required');
    // If (CalcAge(FetchElm(RetNo,'ADOPT#1',2)) =0)
    If (CalcAge(FetchElm(RetNo, 'ADOPT#1', 2)) > 17) then
      SaveDiagnostic(RetNo, 'ADOPT#1', 2,
        'E-Adopted child age must be less than 18');
  end;

  For k := 1 to 3 do // for 3 instances
  begin
    FInst := '#' + AllTrim(IntToStr(k));
    Fno := GetFormNo('S3SUPL' + FInst);
    If Fno > 0 then // 20101220
    Begin
      If Ret[RetNo].FrmHasData[Fno] then
      begin
        i := 153;
        j := 173;
        Repeat
          If Vl(FetchElmFNo(RetNo, Fno, i)) + Vl(FetchElmFNo(RetNo, Fno, j)) > 100
          then
            SaveDiagnostic(RetNo, 'S3SUPL' + FInst, j,
              'E-S3 Supplementary: Percent (%) error');
          Inc(i, 1);
          Inc(j, 1);
        until i > 172;
      End;
    End;
  End;

  For k := 1 to 3 do // for 3 instances
  begin
    FInst := '#' + AllTrim(IntToStr(k));
    Fno := GetFormNo('S3QSUPL' + FInst);
    If Fno > 0 then // 20101220
    Begin
      If Ret[RetNo].FrmHasData[Fno] then
      begin
        i := 187;
        j := 213;
        Repeat
          If Vl(FetchElmFNo(RetNo, Fno, i)) + Vl(FetchElmFNo(RetNo, Fno, j)) > 100
          then
            SaveDiagnostic(RetNo, 'S3QSUPL' + FInst, j,
              'E-S3 Supplementary: Percent (%) error');
          Inc(i, 1);
          Inc(j, 1);
        until i > 212;
      End;
    end;
  End;

  For k := 1 to 30 do // for 30 instances
  begin
    FInst := '#' + AllTrim(IntToStr(k));
    Fno := GetFormNo('ACBFRM' + FInst);
    If Fno > 0 then // 20101219
    Begin
      If Ret[RetNo].FrmHasData[Fno] then
      begin
        If FetchElmFNo(RetNo, Fno, 4) = '' then
          SaveDiagnostic(RetNo, 'ACBFRM' + FInst, 4,
            'E-ACB Property type required');

        If FetchElmFNo(RetNo, Fno, 5) = '' then
          SaveDiagnostic(RetNo, 'ACBFRM' + FInst, 5, 'W-ACB % required');

        If FetchElmFNo(RetNo, Fno, 16) > '' then
        begin
          If (UpperCase(FetchElmFNo(RetNo, Fno, 16)) <> 'BUY') and
            (FetchElmFNo(RetNo, Fno, 8) = '') then // begin balance
            SaveDiagnostic(RetNo, 'ACBFRM' + FInst, 8,
              'W-ACB beginning balance not entered');
        end;

        j := 24;
        Repeat
          If FetchElmFNo(RetNo, Fno, j) > '' then
          begin
            If FetchElmFNo(RetNo, Fno, j) < FetchElmFNo(RetNo, Fno, j - 9) then
              SaveDiagnostic(RetNo, 'ACBFRM' + FInst, j,
                'E-ACB date out of sequence. Fix or Right click to sort');
          end;
          Inc(j, 9);
        until j > 420;
      end;
    end;
  end;

  // -----rrsp related
  Fno := GetFormNo('RRSP');
  If (Vl(FetchElmFNo(RetNo, Fno, 73)) = 0) and
    (Vl(FetchElm(RetNo, 'CFR', 51)) > 0) then
    SaveDiagnostic(RetNo, 'RRSP', 73, 'W-HBP amount repaid last year');
  If (Vl(FetchElmFNo(RetNo, Fno, 82)) > 0) { balance }
    and (FetchElmFNo(RetNo, Fno, 83) = '') then
    SaveDiagnostic(RetNo, 'RRSP', 83, 'W-HBP may not be fully completed');

  // 20130205
  If (Vl(FetchElmFNo(RetNo, Fno, 11)) = 0) { limit }
    and (Vl(FetchElmFNo(RetNo, Fno, 70)) > 0) then // contr made
    SaveDiagnostic(RetNo, 'RRSP', 1,
      'W-RRSP contributions made but deduction limit missing');
  // LLP
  If (Vl(FetchElmFNo(RetNo, Fno, 86)) > 0) { balance }
    and (FetchElmFNo(RetNo, Fno, 87) = '') and
    (UpperCase(FetchElmFNo(RetNo, Fno, 88)) <> 'Y') // 20180219
  then
    SaveDiagnostic(RetNo, 'RRSP', 87, 'W-LLP may not be fully completed');

  // llp
  If (Vl(FetchElmFNo(RetNo, Fno, 76)) = 0) and
    (Vl(FetchElm(RetNo, 'CFR', 52)) > 0) then
    SaveDiagnostic(RetNo, 'RRSP', 76, 'W-LLP amount repaid last year');
  // HBP designation
  If Vl(FetchElmFNo(RetNo, Fno, 73)) > Vl(FetchElmFNo(RetNo, Fno, 70)) +
    Vl(FetchElmFNo(RetNo, Fno, 71)) + Vl(FetchElm(RetNo, 'S7', 1)) then
    SaveDiagnostic(RetNo, 'RRSP', 73,
      'E-HBP designation exceeds RRSP contributions');

  // LLP designation
  If Vl(FetchElmFNo(RetNo, Fno, 76)) > 0 then
  begin
    If Vl(FetchElmFNo(RetNo, Fno, 70)) + Vl(FetchElmFNo(RetNo, Fno, 71)) = 0
    then // contrib
      SaveDiagnostic(RetNo, 'RRSP', 76,
        'W-LLP repayment but no RRSP contribution');
  end;


  //jz//20260421//CCAv11
  checkT776CCALoss(RetNo);

  // ASSETSB ------------------
  For k := 1 to 20 do // for 20 instances
  begin
    FInst := '#' + AllTrim(IntToStr(k));
    Fno := GetFormNo('ASSETSB' + FInst);
    If Fno > 0 then // 20101020
    Begin
      If Ret[RetNo].FrmHasData[Fno] then
      begin
        //20260221
        if (FetchElmFNo(RetNo, Fno, 134)>'')  //class entered
        and (FetchElmFNo(RetNo, Fno, 1)='') //Name is empty
        Then SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 1,'E-ASSETSB-Enter some Asset Name');

        //20260425
        s:=LeftStr(FetchElmFNo(RetNo, Fno, 38),1);
        if (FetchElmFNo(RetNo, Fno, 134)>'')  //class entered
        and (s>'') //factor has something
        and (s<'0') Or (S>'9')
         then SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 38,'E-ASSETSB-Factor 1  is invalid');

       {
        //20260221
        s:=LeftStr(FetchElmFNo(RetNo, Fno, 9),1);
        if (FetchElmFNo(RetNo, Fno, 134)>'')  //class entered
        and (s>'') //factor has something
        and (s<'0') Or (S>'9')
         then SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 9,'E-ASSETSB-Factor 1  is invalid');
       }
        //20260221
       s:=LeftStr(FetchElmFNo(RetNo, Fno, 58),1);  //20260425
        //s:=LeftStr(FetchElmFNo(RetNo, Fno, 17),1);
        if (FetchElmFNo(RetNo, Fno, 134)>'')  //class entered
        and (s>'') //factor has something
        and (s<'0') Or (S>'9')
         then SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 17,'E-ASSETSB-Factor 2 is invalid');

        //20200507
        if (Vl(FetchElmFNo(RetNo, Fno, 191))+Vl(FetchElmFNo(RetNo, Fno, 158)) >0) then  //ucc or additions
        begin
         if FetchElmFNo(RetNo, Fno, 215)='' then SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 215,'W-ASSETSB-Enter existing Statement');
         if FetchElmFNo(RetNo, Fno, 216)='' then SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 216,'W-ASSETSB-Enter allocation %');
        end;

        //20260422
        if VL(FetchElmFNo(RetNo, Fno, 12))>0 then
           SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 12,'W-ASSETSB-Col 12-If not valid, revove it. It may belong to Col 3');

        //20230516
        if VL(FetchElmFNo(RetNo, Fno, 44))>0 then  //AIIP eligible
        Begin
         if (Vl(FetchElmFNo(RetNo, Fno, 48))=0)
         then SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 48,'W-ASSETSB-Any amount for Immediate Expensing on Column 9?');
        end;

       {//20230518 duplicate
        //20230516
        if (FetchElmFNo(RetNo, Fno, 41))>'' then  //diep eligible
        Begin
         if (Vl(FetchElmFNo(RetNo, Fno, 50))=0) then
          SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 50,'W-ASSETSB-Any amount ?');
        end;
       }
        {//20230423
        if (Vl(FetchElmFNo(RetNo, Fno, 158))>0)  //additions
        and (FetchElmFNo(RetNo, Fno, 41)+FetchElmFNo(RetNo, Fno, 42)='') then
        SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 41,'E-ASSETSB-Please enter the AIIP eligibility');
        }
        //-------------
        If (AllTrim(FetchElmFNo(RetNo, Fno, 134)) ='54')
        or (AllTrim(FetchElmFNo(RetNo, Fno, 134)) ='55')  then
        begin
           SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 134,
              'W-ASSETSB-Zero emmision classes 54/55: You may take up to 100% CCA the first year. Override Rate');
        end;

        If FetchElmFNo(RetNo, Fno, 215) > '' then
        begin
          If (FetchElmFNo(RetNo, Fno, 215) = FetchElmFNo(RetNo, Fno, 221)) or
            (FetchElmFNo(RetNo, Fno, 215) = FetchElmFNo(RetNo, Fno, 227)) then
            SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 215,
              'E-ASSETS allocation statement entered twice');
        end;
        // if cca used
        If (Vl(FetchElmFNo(RetNo, Fno, 191)) > 0) or
          (Vl(FetchElmFNo(RetNo, Fno, 12)) > 0) or
          (Vl(FetchElmFNo(RetNo, Fno, 167)) <> 0) then
        begin
          If FetchElmFNo(RetNo, Fno, 134) = '' then
            SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 134,
              'E-Assets-Class required');
        end;
        If LeftStr(FetchElmFNo(RetNo, Fno, 137), 4) = AppYear then
        begin
          If (Vl(FetchElmFNo(RetNo, Fno, 191)) > 0) then
            SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 191,
              'W-Assets-UCC entered for asset bought in tax year');
        end;
        If FetchElmFNo(RetNo, Fno, 221) > '' then
        begin
          If (FetchElmFNo(RetNo, Fno, 221) = FetchElmFNo(RetNo, Fno, 215)) or
            (FetchElmFNo(RetNo, Fno, 221) = FetchElmFNo(RetNo, Fno, 227)) then
            SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 221,
              'E-Assets-Allocation statement entered twice');
        end;
        If FetchElmFNo(RetNo, Fno, 227) > '' then
        begin
          If (FetchElmFNo(RetNo, Fno, 227) = FetchElmFNo(RetNo, Fno, 215)) or
            (FetchElmFNo(RetNo, Fno, 227) = FetchElmFNo(RetNo, Fno, 221)) then
            SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 227,
              'E-Assets-Allocation statement entered twice');
        end;

        If (FetchElmFNo(RetNo, Fno, 137) > '') and
          (LeftStr(FetchElmFNo(RetNo, Fno, 137), 4) < AppYear) then
        begin
          If Vl(FetchElmFNo(RetNo, Fno, 191)) = 0 then
            SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 191,
              'W-Assets-Beginning UCC may be missing');
        end;

        If Vl(FetchElmFNo(RetNo, Fno, 2)) > 100 then
          SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 2,
            'E-Assets-Total allocation % exceeds 100');

        //20190310
        If (FetchElmFNo(RetNo,FNo,41)>'')  //eligible AIIP
        and (Vl(FetchElmFNo(RetNo,FNo,158)) > 0)  //additions
        and (Vl(FetchElmFNo(RetNo,FNo,49)) > 0)  //additions
        then
        Begin
           If Vl(FetchElmFNo(RetNo,FNo,50))=0 then //Col 10
           SaveDiagnostic(RetNo,'ASSETSB'+FInst,50,'W-ASSETSB-Enter any amount on Column 11?'); //20230518
        End;

        If ((FetchElmFNo(RetNo, Fno, 134) = '10') and
          (FetchElmFNo(RetNo, Fno, 35) = '')) then
          SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 35,
            'W-Assets-If Automobile, enter it on the AUTOS form');

        If (FetchElmFNo(RetNo, Fno, 134) = '10.1') then
          SaveDiagnostic(RetNo, 'ASSETSB' + FInst, 134,
            'E-Assets-Enter automobiles on the AUTOS form');
      end;
    end;
  end;

  // Autos  ------------------
  For k := 1 to 7 do // for 7 instances
  begin
    FInst := '#' + AllTrim(IntToStr(k));
    Fno := GetFormNo('AUTOS' + FInst);
    If Fno > 0 then // 20101219
    Begin
      If Ret[RetNo].FrmHasData[Fno] then
      begin
        //20200514
        if FetchElmFNo(RetNo,FNo,1)='' then
         SaveDiagnostic(RetNo, 'AUTOS', 1, 'E-AUTOS' + FInst +' requires a description');

        if FetchElmFNo(RetNo,FNo,215)='' then
         SaveDiagnostic(RetNo, 'AUTOS'+FInst,215,'W-AUTOS' + FInst +' Enter Allocation Statement to be claimed on');

        //20260422
        if VL(FetchElmFNo(RetNo, Fno, 12))>0 then
           SaveDiagnostic(RetNo, 'AUTOS' + FInst, 12,'W-AUTOS-Col 12-If not valid, revove it. It may belong to Col 3');

        if Vl(FetchElmFNo(RetNo,FNo,2))>0 then  //20230717
        Begin
         if Vl(FetchElmFNo(RetNo,FNo,2))<>100 then
          SaveDiagnostic(RetNo, 'AUTOS'+FInst,2,'E-AUTOS' + FInst +' Allocation to statements must be 100%');
        End;


        if (FetchElmFNo(RetNo,FNo,215)>'') and (FetchElmFNo(RetNo,FNo,216)='') then
         SaveDiagnostic(RetNo, 'AUTOS'+FInst,216,'W-AUTOS' + FInst +' Enter % Allocation to statement');


        //20230516
        if FetchElmFNo(RetNo, Fno, 41)>'' then  //DIEP eligible
        Begin
         if (Vl(FetchElmFNo(RetNo, Fno, 44))>=0)  //diep additions
         and (Vl(FetchElmFNo(RetNo, Fno, 26))=0)
         then SaveDiagnostic(RetNo, 'AUTOS' + FInst, 26,'W-AUTOS-Any amount for Immediate Expensing on Column 9?');
        end;

        //20230516
        if (FetchElmFNo(RetNo, Fno, 55))>'' then  //aiip eligible     //20230518
        Begin
         if (Vl(FetchElmFNo(RetNo, Fno, 158))>0) //addition
         and (Vl(FetchElmFNo(RetNo, Fno, 49))>0) //col 10
         and (Vl(FetchElmFNo(RetNo, Fno, 50))=0) then  //col 11
          SaveDiagnostic(RetNo, 'AUTOS' + FInst, 50,'W-AUTOS-Any amount for Column 11?');
        end;

       {
        //20230503
        if FetchElm(RetNo,'AUTOS'+FInst,41) >'' then
        Begin
          IsDiepEligible(FetchElm(RetNo,'AUTOS'+FInst,134),FetchElm(RetNo,'AUTOS'+FInst,137)=false) then  //class and Purch date
            SaveDiagnostic(RetNo, 'AUTOS'+FInst,41,'E-AUTOS' + FInst +' This class/purchase date is not eligible for DIEP');
        End;
       }

        //20230515
        If (Vl(FetchElm(RetNo,'AUTOS'+FInst,143))>0)   //cost purchased this year
        and (Vl(FetchElm(RetNo,'AUTOS'+FInst,33))>1)   //allowable max cost //20230515
         then SaveDiagnostic(RetNo, 'AUTOS'+FInst,143,'E-AUTOS' + FInst +' Either enter the cost in prior year or this year');

        //20200909
        if ((FetchElm(RetNo,'AUTOS'+FInst,134)='54') or (FetchElm(RetNo,'AUTOS'+FInst,134)='55'))
        and (Vl(FetchElm(RetNo,'AUTOS'+FInst,194))>55000)   //allowable max cost
        and (FetchElm(RetNo,'AUTOS'+FInst,44)='')
         then SaveDiagnostic(RetNo, 'AUTOS'+FInst,44,'W-AUTOS' + FInst +' Please enter Y or N on the Autos/CCA');

        //s:=FetchElm(RetNo,'AUTOS'+FInst,137);
        if ((FetchElm(RetNo,'AUTOS'+FInst,134)='54') or (FetchElm(RetNo,'AUTOS'+FInst,134)='55'))
        and (FetchElm(RetNo,'AUTOS'+FInst,137)<='2019-03-18')
        then SaveDiagnostic(RetNo, 'AUTOS'+FInst,137,'E-AUTOS' + FInst +' CCA class 54 or 55: Purchase date must be after March 18, 2019');
       //-----------------------------------------

        If Vl(FetchElmFNo(RetNo, Fno, 4)) <= 1 then
        begin
          SaveDiagnostic(RetNo, 'AUTOS' + FInst, 4,
            'W-Autos actual kilometers not entered');
        end;

        If FetchElmFNo(RetNo, Fno, 215) > '' then
        begin
          If (FetchElmFNo(RetNo, Fno, 215) = FetchElmFNo(RetNo, Fno, 221)) or
            (FetchElmFNo(RetNo, Fno, 215) = FetchElmFNo(RetNo, Fno, 227)) then
            SaveDiagnostic(RetNo, 'AUTOS' + FInst, 215,
              'E-Autos allocation statement entered twice');
        end;
        // if cca used
        If (Vl(FetchElmFNo(RetNo, Fno, 191)) > 0) or
          (Vl(FetchElmFNo(RetNo, Fno, 6)) > 0) or
          (Vl(FetchElmFNo(RetNo, Fno, 167)) <> 0) then
        begin
          If FetchElmFNo(RetNo, Fno, 134) = '' then
            SaveDiagnostic(RetNo, 'AUTOS' + FInst, 134,
              'E-Autos-Class required');
          If FetchElmFNo(RetNo, Fno, 137) = '' then
            SaveDiagnostic(RetNo, 'AUTOS' + FInst, 137,
              'E-Autos-Date acquired is required'); // 20171217
        end;

        If FetchElmFNo(RetNo, Fno, 221) > '' then
        begin
          If (FetchElmFNo(RetNo, Fno, 221) = FetchElmFNo(RetNo, Fno, 215)) or
            (FetchElmFNo(RetNo, Fno, 221) = FetchElmFNo(RetNo, Fno, 227)) then
            SaveDiagnostic(RetNo, 'AUTOS' + FInst, 221,
              'E-Autos allocation statement entered twice');
        end;

        If FetchElmFNo(RetNo, Fno, 227) > '' then
        begin
          If (FetchElmFNo(RetNo, Fno, 227) = FetchElmFNo(RetNo, Fno, 215)) or
            (FetchElmFNo(RetNo, Fno, 227) = FetchElmFNo(RetNo, Fno, 221)) then
            SaveDiagnostic(RetNo, 'AUTOS' + FInst, 227,
              'E-Autos allocation statement entered twice');
        end;

        If (FetchElmFNo(RetNo, Fno, 137) > '') and
          (LeftStr(FetchElmFNo(RetNo, Fno, 137), 4) < AppYear) then
        begin
          If Vl(FetchElmFNo(RetNo, Fno, 140)) = 0 then
            SaveDiagnostic(RetNo, 'AUTOS' + FInst, 140,
              'W-Autos-Beginning UCC may be missing');
        end;

        If Vl(FetchElmFNo(RetNo, Fno, 2)) > 100 then
          SaveDiagnostic(RetNo, 'AUTOS' + FInst, 2,
            'E-Autos total allocation % exceeds 100');
      
        If (Vl(FetchElmFNo(RetNo, Fno, 149)) > 0) and
          (Vl(FetchElmFNo(RetNo, Fno, 197)) = 0) then
          SaveDiagnostic(RetNo, 'AUTOS' + FInst, 197,
            'W-Autos GST/HST rate missing');

        If (Vl(FetchElmFNo(RetNo, Fno, 149)) > 0) and
          (Vl(FetchElmFNo(RetNo, Fno, 200)) = 0) then
          SaveDiagnostic(RetNo, 'AUTOS' + FInst, 200,
            'W-Autos PST rate missing');

        if ((FetchElm(RetNo,'AUTOS'+FInst,134)='10.1')
        and ((Vl(FetchElm(RetNo,'AUTOS'+FInst,143))<34000) and (Vl(FetchElm(RetNo,'AUTOS'+FInst,143))>1)))   //allowable max cost //20230515
         then SaveDiagnostic(RetNo, 'AUTOS'+FInst,143,'E-AUTOS' + FInst +' Cost before taxes must be at least $34,000 or use class 10');

        {
        If (FetchElmFNo(RetNo, Fno, 134) = '10') and
          (Vl(FetchElmFNo(RetNo, Fno, 143)) > 34000) then
          SaveDiagnostic(RetNo, 'AUTOS' + FInst, 134,
            'W-Passenger Vehicle? Cost > $30,000. Class should be 10.1?');
        }
        If (FetchElmFNo(RetNo, Fno, 134) = '10.1') and
          (Vl(FetchElmFNo(RetNo, Fno, 143)) <= 34000) and
          (Vl(FetchElmFNo(RetNo, Fno, 143)) > 0) and
          (Vl(FetchElmFNo(RetNo, Fno, 140)) = 0)  //ucc exists
           then
          SaveDiagnostic(RetNo, 'AUTOS' + FInst, 134,
            'W-Passenger Vehicle? Cost < $34,000. Class should be 10?');

        If (FetchElmFNo(RetNo, Fno, 134) = '10.1') and
          (Vl(FetchElmFNo(RetNo, Fno, 140)) > 0) and
          (Vl(FetchElmFNo(RetNo, Fno, 12)) > 0) then
          SaveDiagnostic(RetNo, 'AUTOS' + FInst, 134,
            'E-Autos: You should create a new class for 10.1');
      end;
    End;
  end;

  // Auto777
  For k := 1 to 7 do // for 7 instances
  begin
    FInst := '#' + AllTrim(IntToStr(k));
    Fno := GetFormNo('AUTO777' + FInst);
    If Fno > 0 then // 20101219
    begin
      If Ret[RetNo].FrmHasData[Fno] then
      begin
       //20200514
        if FetchElmFNo(RetNo,FNo,1)='' then SaveDiagnostic(RetNo, 'AUTO777'+FInst, 1, 'E-AUTO777' + FInst +' requires a description'); //20200515
        if FetchElmFNo(RetNo,FNo,215)='' then
         SaveDiagnostic(RetNo, 'AUTO777'+FInst,215,'W-AUTO777' + FInst +' Enter Allocation Statement to be claimed on');
        if (FetchElmFNo(RetNo,FNo,215)>'') and (FetchElmFNo(RetNo,FNo,216)='') then
         SaveDiagnostic(RetNo, 'AUTO777'+FInst,216,'W-AUTO777' + FInst +' Enter % Allocation to statement');

        If Vl(FetchElmFNo(RetNo, Fno, 4)) <= 1 then
        begin
          if Vl(FetchElmFNo(RetNo, Fno, 134))<>8 then //other than class 8
           SaveDiagnostic(RetNo, 'AUTO777' + FInst, 4,'W-AUTO777 actual kilometers not entered');
        end;
        {
        // 20200514
        If Vl(FetchElmFNo(RetNo, Fno, 4)) > 1 then
        begin
          If FetchElmFNo(RetNo, Fno, 1) = '' then
            SaveDiagnostic(RetNo, 'AUTO777' + FInst, 1,'E-Auto777 Auto description required');
        end;
        }
        // if cca used
        If (Vl(FetchElmFNo(RetNo, Fno, 191)) > 0) or
          (Vl(FetchElmFNo(RetNo, Fno, 6)) > 0) or
          (Vl(FetchElmFNo(RetNo, Fno, 167)) <> 0) then
        begin
          If FetchElmFNo(RetNo, Fno, 134) = '' then
            SaveDiagnostic(RetNo, 'AUTO777' + FInst, 134,'E-Auto777-Class required');
          If FetchElmFNo(RetNo, Fno, 137) = '' then
            SaveDiagnostic(RetNo, 'AUTO777' + FInst, 137,'E-Auto777 Date acquired is required');
        end;

        If (FetchElmFNo(RetNo, Fno, 137) > '') and
          (LeftStr(FetchElmFNo(RetNo, Fno, 137), 4) < AppYear) then
        begin
          If Vl(FetchElmFNo(RetNo, Fno, 140)) = 0 then
            SaveDiagnostic(RetNo, 'AUTO777' + FInst, 140,'W-Auto777-Beginning UCC may be missing');
        end;

        If Vl(FetchElmFNo(RetNo, Fno, 2)) > 100 then
          SaveDiagnostic(RetNo, 'AUTO777' + FInst, 2,'E-Autos total allocation % exceeds 100');

        If (Vl(FetchElmFNo(RetNo, Fno, 149)) > 0) and
          (Vl(FetchElmFNo(RetNo, Fno, 197)) = 0) then
          SaveDiagnostic(RetNo, 'AUTO777' + FInst, 197,'W-Auto777 GST/HST rate missing');
        {//20200519
        If (Vl(FetchElmFNo(RetNo, Fno, 149)) > 0) and
          (Vl(FetchElmFNo(RetNo, Fno, 200)) = 0) then
          SaveDiagnostic(RetNo, 'AUTO777' + FInst, 200,'W-Auto777 PST rate missing');
        }
        If (FetchElmFNo(RetNo, Fno, 134) = '10') and
          (Vl(FetchElmFNo(RetNo, Fno, 12)) > 30000) then
          SaveDiagnostic(RetNo, 'AUTO777' + FInst, 12,'W-Auto777 Vehicle cost > $30,000. Class should be 10.1?');

        If (FetchElmFNo(RetNo, Fno, 134) = '10.1')
        and (Vl(FetchElmFNo(RetNo, Fno, 12)) <= 30000.01)
        and (Vl(FetchElmFNo(RetNo, Fno, 140)) = 0)    //20200512
        then
          SaveDiagnostic(RetNo, 'AUTO777' + FInst, 140,'W-Auto777 Vehicle cost <= $30,000. Class should be 10?');

        If (FetchElmFNo(RetNo, Fno, 134) = '10.1') and
          (Vl(FetchElmFNo(RetNo, Fno, 140)) > 0) and
          (Vl(FetchElmFNo(RetNo, Fno, 12)) > 0) then
          SaveDiagnostic(RetNo, 'AUTO777' + FInst, 12,'E-Auto777: You should create a new class (page) for 10.1');
      end;
    End;
  end;

  For k := 1 to 5 do // for 5 instances
  begin
    FInst := '#' + AllTrim(IntToStr(k));
    Fno := GetFormNo('T4' + FInst);
    If Fno > 0 then // 20101219
    Begin
      // 20180101
      if (k < 3) and (FetchElmFNo(RetNo, Fno, 7) > '') then // CPP exempt
      Begin
        if Vl(FetchElm(RetNo, 'RC381', 40)) > 0 then
          SaveDiagnostic(RetNo, 'RC381', 44,
            'W-RC381-CPP exempt. You may need to override pensionable weeks to zero');
      End;

      If (Vl(FetchElmFNo(RetNo, Fno, 9)) < Vl(FetchElmFNo(RetNo, Fno, 2))) and
        (Vl(FetchElmFNo(RetNo, Fno, 9)) <> Constant[RY].MaxUIEarn52) and
        (FetchElmFNo(RetNo, Fno, 18) = '') then
        SaveDiagnostic(RetNo, 'T4' + FInst, 9,
          'W-T4 EI Earnings less than gross');

      If (Vl(FetchElmFNo(RetNo, Fno, 2)) > 0) and
        (Vl(FetchElmFNo(RetNo, Fno, 3)) = 0) and
        (UpperCase(FetchElmFNo(RetNo, Fno, 20)) <> 'QC') // 20131214
        and (FetchElmFNo(RetNo, Fno, 7) = '') // cpp/qpp exempt
      then
        SaveDiagnostic(RetNo, 'T4' + FInst, 3, 'W-T4 CPP not entered');

      // 20131214
      If (Vl(FetchElmFNo(RetNo, Fno, 2)) > 0) and
        (Vl(FetchElmFNo(RetNo, Fno, 4)) = 0) // qpp
        and (UpperCase(FetchElmFNo(RetNo, Fno, 20)) = 'QC') and
        (FetchElmFNo(RetNo, Fno, 7) = '') then
        SaveDiagnostic(RetNo, 'T4' + FInst, 4, 'W-T4 QPP not entered');

      If (Vl(FetchElmFNo(RetNo, Fno, 2)) > 2000) and
        (Vl(FetchElmFNo(RetNo, Fno, 5)) = 0) and
        (FetchElmFNo(RetNo, Fno, 18) = '') then
        SaveDiagnostic(RetNo, 'T4' + FInst, 5, 'W-T4 EI not entered');

      If (Vl(FetchElmFNo(RetNo, Fno, 2)) > 0) and
        (Vl(FetchElmFNo(RetNo, Fno, 8)) = 0) then
        SaveDiagnostic(RetNo, 'T4' + FInst, 8, 'W-T4 Tax not entered-check');

      If (Vl(FetchElmFNo(RetNo, Fno, 39)) + Vl(FetchElmFNo(RetNo, Fno, 40)) +
        +Vl(FetchElmFNo(RetNo, Fno, 41)) + +Vl(FetchElmFNo(RetNo, Fno, 42)) > 0)
        and (Ret[RetNo].FrmHasData[GetFormNo('T2222')] = false) then
        SaveDiagnostic(RetNo, 'T2222', 22,
          'W-T2222-Not claimed as per T4 box 32/33)');
    end;
  end;

  If (TotMultiple(RetNo, 'T4', 11) > 0) // 20101202
    and (Ret[RetNo].FrmHasData[GetFormNo('S13')]) // box 71 indians
  then
  begin
    If Vl(FetchElm(RetNo, 'S13', 3)) = 0 then
      SaveDiagnostic(RetNo, 'S13', 3,
        'W-S13-Any tax exempt self-employment income?');
  end;

  For k := 1 to 5 do // for 5 instances
  begin
    FInst := '#' + AllTrim(IntToStr(k));
    Fno := GetFormNo('T4PS' + FInst);
    If Fno > 0 then // 20101219
    Begin
      If (Vl(FetchElmFNo(RetNo, Fno, 15)) > 0) // contribution
        and (FetchElmFNo(RetNo, Fno, 10) > '') // specified empl
        and (FetchElmFNo(RetNo, Fno, 14) = '') // Empl Name
      then
        SaveDiagnostic(RetNo, 'T4PS' + FInst, 14,
          'E-T4PS-Box 41.Enter Employer Name');

      If (Vl(FetchElmFNo(RetNo, Fno, 15)) > 0) // contribution
        and (FetchElmFNo(RetNo, Fno, 10) > '') // specified empl
        and (UpperCase(FetchElm(RetNo, 'RC359#1', 21)) = 'Y') // Auto Rc359
      then
        SaveDiagnostic(RetNo, 'RC359#1', 21,
          'W-RC359-Manually ensure EmployerName entered on related T4/T4A');

    end;

  end; // k

 (*
  //20220225
  FNo:=GetFormNo('S12SK');
  If ret[RetNo].FrmHasData[Fno] then
  begin
    if (Vl(FetchElmFNo(RetNo,FNo,161))>0)
    and (Vl(FetchElmFNo(RetNo,FNo,171))+Vl(FetchElmFNo(RetNo,FNo,172))=0)
    then SaveDiagnostic(RetNo, 'S12SK', 171,'E-S12SK-Please enter % of Home Renovation expenses');
  end;
 *)

  If Vl(FetchElm(RetNo, 'RRSP', 71)) = 0 then // 20110207
  begin
    x := TotMultiple(RetNo, 'T4', 49);
    If x > 0 then
      SaveDiagnostic(RetNo, 'RRSP', 71, 'W-RRSP-Any transfers? (T4 has $' +
        FormatFloat('###,###.##', x) + ' of retiring allowance)');
    x := TotMultiple(RetNo, 'T4A', 6);
    If x > 0 then
      SaveDiagnostic(RetNo, 'RRSP', 71, 'W-RRSP-Any transfers? (T4A has $' +
        FormatFloat('###,###.##', x) + ' of retiring allowance)');
  end;

  Fno := GetFormNo('T4E#1');
  If (Vl(FetchElmFNo(RetNo, Fno, 8)) > 0) and
    (Vl(FetchElmFNo(RetNo, Fno, 2)) = 0) then
    SaveDiagnostic(RetNo, 'T4E#1', 2, 'W-T4E-Box 15 entered but not Box 14');

  If (Ret[RetNo].Province = 'ZZ') and
    (Vl(FetchElm(RetNo, 'SNRESB', 3)) < 90) { 90% }
   // (Vl(FetchElm(RetNo, 'SNRESB', 2)) < 90) { 90% }
  then
  begin
    If Ret[RetNo].Lnn[32100] + Ret[RetNo].Lnn[32200] > 0 then
      SaveDiagnostic(RetNo, 'S11', 15,
        'E-S11-NR of less that 90%. Educ. not allowed');
  end;
  { Periods }
  S := FetchElmFNo(RetNo, InfoFNo, 2);
  For i := 1 to Length(S) do
  begin
    If MidStr(S, i, 1) = '.' then
      SaveDiagnostic(RetNo, 'INFO', 2,
        'W-Period not allowed in Name(If EFiled)');
  end;

  S := FetchElmFNo(RetNo, InfoFNo, 5);
  For i := 1 to Length(S) do
  begin
    If MidStr(S, i, 1) = '.' then
      SaveDiagnostic(RetNo, 'INFO', 5,
        'W-Period not allowed in Name(If EFiled)');
  end;

  S := FetchElmFNo(RetNo, InfoFNo, 6);
  For i := 1 to Length(S) do
  begin
    If MidStr(S, i, 1) = '.' then
      SaveDiagnostic(RetNo, 'INFO', 6,
        'W-Period not allowed in Address(If EFiled)');
  end;

  If (FetchElmFNo(RetNo, InfoFNo, 86) > '') then
  begin
    If Ret[RetNo].FrmHasData[GetFormNo('T1135')] = false then
      SaveDiagnostic(RetNo, 'INFO', 86, 'W-INFO-Foreign Income-Prepare T1135');
    // 20140227
  end
  else
  begin
    If Ret[RetNo].FrmHasData[GetFormNo('T1135')] = True then
      SaveDiagnostic(RetNo, 'INFO', 86,
        'E-T1135 completed. Set indicator to X');
  end;

  If Ret[RetNo].FrmHasData[GetFormNo('T1135')] = True then // 20140227
  begin
    If FetchElm(RetNo, 'T1135', 39) = '' then // 20150226
      SaveDiagnostic(RetNo, 'T1135', 1,
        'W-T1135 must be Efiled or mailed as per instructions');
  end;


  // ----------------

  If FetchElmFNo(RetNo, InfoFNo, 54) = '' then
    SaveDiagnostic(RetNo, 'INFO', 54, 'W-Tel area missing (not mandatory)');  //20220218 )
  If FetchElmFNo(RetNo, InfoFNo, 55) = '' then
    SaveDiagnostic(RetNo, 'INFO', 55, 'W-Telephone no missing (not mandatory)');

  If FetchElmFNo(RetNo, InfoFNo, 54) + FetchElmFNo(RetNo, InfoFNo, 55) > '' then
  // 20120301
  begin
    If (Length(FetchElmFNo(RetNo, InfoFNo, 54)) <> 3) or
      (Numeric(FetchElmFNo(RetNo, InfoFNo, 54)) = false) then // 20141020
      SaveDiagnostic(RetNo, 'INFO', 54,
        'E-Area code is incorrect (3 digits) or remove it');
    If ValidPhone(FetchElmFNo(RetNo, InfoFNo, 55)) = false then
      SaveDiagnostic(RetNo, 'INFO', 55,
        'E-Telephone is incorrect (7 digits or 999-9999) or remove it');
  end;

  If Ret[RetNo].Province = 'NS' then
  begin
    If (CountKidsUnder6(RetNo) > 0) and (Vl(FetchElm(RetNo, 'NS428', 73)) = 0)
      and (IsLowerIncomeSpouse(RetNo)) then
      SaveDiagnostic(RetNo, 'NS428', 73,
        'W-NS428 Claim amount for kids under 6? (except Eligible dependant)');
    // 20181128
  end;

  If Ret[RetNo].Province = 'NU' then
  begin
    If (CountKidsUnder6(RetNo) > 0) and (Vl(FetchElm(RetNo, 'NU428', 75)) = 0)
      and (IsLowerIncomeSpouse(RetNo)) then
      SaveDiagnostic(RetNo, 'NU428', 75,
        'W-NU428 Claim amount for kids under 6?');
  end;

  If Ret[RetNo].Province = 'PE' then
  begin
    If (CountKidsUnder6(RetNo) > 0) and (Vl(FetchElm(RetNo, 'PE428', 67)) = 0)
      and (IsLowerIncomeSpouse(RetNo)) then
      SaveDiagnostic(RetNo, 'PE428', 67,
        'W-PE428 Claim amount for kids under 6?');
  end;

  // T2203 ---------------------
  If (FetchElm(RetNo, 'T2203', 110) > '') { mult jursid }
    and (Vl(FetchElm(RetNo, 'T2203', 2)) = 0) then
  begin
    SaveDiagnostic(RetNo, 'T2203', 110,
      'E-T2203. Remove X, there is no self-empl Net income');
  end;
  // 20170422
  If (FetchElm(RetNo, 'T2203', 110) > '') and
    (Vl(FetchElm(RetNo, 'T2203', 2)) > 0) then
  Begin
    if Vl(FetchElm(RetNo, 'T2203', 2)) <> Vl(FetchElm(RetNo, 'T2203', 96)) then
      SaveDiagnostic(RetNo, 'T2203', 96,
        'E-T2203 Total Income not equal to income on line 2');
  end;

  // 20170422
  (*
    If (FetchElmFNo(RetNo,InfoFNo,21) = 'MULTIPLE') then
    begin
    If FetchElm(RetNo,'T2203',110)= '' then
    SaveDiagnostic(RetNo,'INFO',21,'E-T2203 should be completed');
    end;
  *)
  // --------------------------------------77
  {
  If Vl(FetchElm(RetNo, 'NS479', 3)) > MaxR(0, Vl(FetchElm(RetNo, 'NS479', 17))
    - Vl(FetchElm(RetNo, 'NS479', 19))) then
    SaveDiagnostic(RetNo, 'NS479', 20,
      'E-NS Carry back cannot exceed Ln 9 minus Ln 13');
  }
  If Vl(FetchElm(RetNo, 'CTB', 70)) > 0 then
  begin
    SaveDiagnostic(RetNo, 'CTB', 71, 'W-Info-CTB claimed on this return');
  end;

  // 20160126
  Fno := GetFormNo('T1135');
  ValidateT1135(RetNo, Fno); // 20160126

  //20230801 Con
  FNo:=GetFormNo('T1134');
  ValidateT1134(RetNo,FNo);  //20180703

  //20230801 Con copied from T2
  //20230510 Igor >>>
  For i:=1 to 10 do
  begin
   FNo:=GetFormNo('T1134S#'+IntToStr(i));
   If FNo>0 then
    ValidateT1134S(RetNo,FNo, i);
  end;
  //20230510 Igor <<<

  //20200227
  if Ret[RetNo].Province='ON' then
  Begin
   FNo:=GetFormNo('ON428A');
   if (Vl(FetchElmFNo(RetNo,FNo,20))+Vl(FetchElmFNo(RetNo,FNo,41))>0)
   and (Uppercase(FetchElmFNo(RetNo,FNo,48))<>'Y') then
    SaveDiagnostic(RetNo, 'ON428A', 48,'W-LIFT-Low Income Credit can be claimed. Confirm eligibility');
  End;

  Fno := GetFormNo('INVOICE');
  //20220422
  If (FetchElmFNo(RetNo,Fno,289)+FetchElmFNo(RetNo, Fno, 223) + FetchElmFNo(RetNo, Fno, 224) +
    FetchElmFNo(RetNo, Fno, 225) + FetchElmFNo(RetNo, Fno, 282) +
    FetchElmFNo(RetNo, Fno, 271) + FetchElmFNo(RetNo, Fno, 286) = '') and
    (ShowInvoiceWarning = True) then
    SaveDiagnostic(RetNo, 'INVOICE', 223,
      'W-Invoice (paid by) has not been prepared');

  // DEPEND
  // tip for kids =18}
  Fno := GetFormNo('DEPEND');
  If (UpperCase(FetchElmFNo(RetNo, Fno, 140)) = 'Y') and
    (Ret[RetNo].FrmHasData[Fno]) then
  begin
    If Vl(FetchElmFNo(RetNo, Fno, 160)) = 0 then
      SaveDiagnostic(RetNo, 'DEPEND', 160,
        'W-Dependants-Claim entered but not percentage');
  end;
  i := 5;
  k := 191; // index to FCA
  K1 := 163; // Index to young kis for line 367
  K2 := 141; // index to caregiver 20130213
  K3 := 263;
  K4 := 191;
  Repeat
    If (FetchElmFNo(RetNo, Fno, i) > '') and
      (FetchElmFNo(RetNo, Fno, i + 5) = '') then // 20101207
      SaveDiagnostic(RetNo, 'DEPEND', i + 5,
        'E-Dependant Birthdate is required');

    If (FetchElmFNo(RetNo, Fno, i) > '') and
      (FetchElmFNo(RetNo, Fno, i + 2) = '') then // no SIN
    Begin
      If (UpperCase(FetchElmFNo(RetNo, Fno, i + 14)) = 'Y') Or
        (UpperCase(FetchElmFNo(RetNo, Fno, K4)) = 'Y')
      // 20180225  caregiver indicator
      // and (UpperCase(FetchElmFNo(RetNo,FNo,K2))='Y') //20180225 infirm indicator
      then // 20130209
        SaveDiagnostic(RetNo, 'DEPEND', i + 2,
          'W-Unique SIN required if Eligible or Caregiver claim. You may use dummy numbers: 111111118,870001377, 870000122, 666666664');
      // 20180505
    end;
    // 20170608
    If (UpperCase(FetchElmFNo(RetNo, Fno, k)) = 'Y') and
      (UpperCase(FetchElmFNo(RetNo, Fno, K2)) <> 'Y') then // caregiver
    Begin
      if ((FetchElmFNo(RetNo, Fno, i + 6) = 'Parent') or
        (FetchElmFNo(RetNo, Fno, i + 6) = 'GrandParent')) and
        (CalcAge(FetchElmFNo(RetNo, Fno, i + 5)) >= 65) then
        // ok
      Else
        SaveDiagnostic(RetNo, 'DEPEND', k,
          'W-Caregiver claimed: Allowed only if dependant is infirm');
      // 20180121
    End;

    // 201711
    If (Vl(FetchElmFNo(RetNo, Fno, K3)) >= 18) and
      (FetchElmFNo(RetNo, Fno, i + 2) = '') // but no SIN
    then
      SaveDiagnostic(RetNo, 'DEPEND', i + 2,
        'E-Dependant age is 18 or over. Unique SIN is required even if not correct');

    If (UpperCase(FetchElmFNo(RetNo, Fno, K2)) = 'Y') // infirm
      and (UpperCase(FetchElmFNo(RetNo, Fno, k)) <> 'Y') // but no claim
    then // caregiver
      SaveDiagnostic(RetNo, 'DEPEND', k,
        'W-Caregiver: Dependant infirm but no claim made. Please review');
    // 2017125

    // 20121118  claim on s5>0 not claime kids
    If (FetchElmFNo(RetNo, Fno, i) > '') and
      (CalcAge(FetchElmFNo(RetNo, Fno, i + 5)) < 18) and
      (Vl(FetchElmFNo(RetNo, Fno, 160)) > 0) // claim on S5
      and (UpperCase(FetchElmFNo(RetNo, Fno, K1)) <> 'Y') // no kids claim
    then // 20121118
      SaveDiagnostic(RetNo, 'DEPEND', K1,
        'W-DEPEND-Claim kids=NO. Review or change if justified');

    If (Ret[RetNo].MarStatus < 3) and
      (UpperCase(FetchElmFNo(RetNo, Fno, i + 14)) = 'Y') and
      (FetchElm(RetNo, 'INFO', 39) = '') then
      SaveDiagnostic(RetNo, 'DEPEND', i + 14,
        'W-Elig. Dependant allowed only if single or under special cases');
    // 20140109

    i := i + 15;
    k := k + 1;
    K1 := K1 + 1;
    K2 := K2 + 1;
    K3 := K3 + 1;
  until i > 125;

  If Vl(FetchElmFNo(RetNo, Fno, 3)) > 1 then // 20121215
    SaveDiagnostic(RetNo, 'DEPEND', 19,
      'E-DEPEND-Cannot have more than 1 Eligible dependants');
  // -------------
   (* 20251117
   //20250420
   xx:=Vl(FetchElm(RetNo, 'ABIL', 38));
   yy:=Vl(FetchElm(RetNo, 'ABIL', 58))+Vl(FetchElm(RetNo, 'ABIL', 61));
   If ( xx <> yy ) and ( xx + yy > 0) //jz//20250409 must have entries
   then
   Begin
          SaveDiagnostic(RetNo, 'ABIL', 58,'E-ABIL The sum of the losses in the two periods must equal the total loss');
          SaveDiagnostic(RetNo, 'ABIL', 61,'E-ABIL The sum of the losses in the two periods must equal the total loss');
   end;
  *)

  //===================================================================
  // T3Slips

  for J:=1 to 7 do  //20250409
  Begin
   Fno := GetFormNo('T3MULT#'+AllTrim(IntToStr(J))); // 2025140105
   k := 0;
   Repeat
     If ((Vl(FetchElmFNo(RetNo, Fno, 107 + k)) > 0) Or
       (Vl(FetchElmFNo(RetNo, Fno, 113 + k)) > 0) Or
       (Vl(FetchElmFNo(RetNo, Fno, 125 + k)) > 0) Or
       (Vl(FetchElmFNo(RetNo, Fno, 131 + k)) > 0)) and
       (FetchElmFNo(RetNo, Fno, 53 + k) = '') then
       SaveDiagnostic(RetNo, 'T3MULT#'+AllTrim(IntToStr(J)), 53 + k,'E-T3 slips:Specify foreign country (1,2,3)');

      {//20260107
     //check total box 21 against boxes 52 and 53  periods //20250404
     //20250409
     xx:=Vl(FetchElmFNo(RetNo, Fno, 77+k));
     yy:=Vl(FetchElmFNo(RetNo, Fno, 293+K))+Vl(FetchElmFNo(RetNo, Fno, 299+K));
     If ( xx <> yy ) and ( xx + yy > 0) //jz//20250409 must have entries
     then
     Begin  //20250425
          SaveDiagnostic(RetNo, 'T3MULT#'+AllTrim(IntToStr(J)), 293+k,'E-T3 slips: Box21 must be = to box52+Box53 Or enter Box21 on box52 only');
          SaveDiagnostic(RetNo, 'T3MULT#'+AllTrim(IntToStr(J)), 299+k,'E-T3 slips: Box21 must be = to box52+Box53 Or enter Box21 on box52 only');
     end;
     }

     Inc(k, 1);
   until k > 4;
  End;

  //=============================================================

  // 20130917
  x := TotMultiple(RetNo, 'T3MULT', 208) + TotMultiple(RetNo, 'T3MULT', 202);
  If (x > 0) and (TotMultiple(RetNo, 'T3MULT', 82) < x) then
    SaveDiagnostic(RetNo, 'T3MULT#1', 82,
      'E-T3 slips:Cap Gains (box 21) is less than Eligible cap gains (box30)');

  // 20130131
  x := TotMultiple(RetNo, 'T3MULT', 112);
  If x <> 0 then
    SaveDiagnostic(RetNo, 'T2125#1', 26, 'W-T3 Bus. income $' +
      AllTrim(FormatFloat('###,###.##', x)) +
      ' ensure you entered it on its own statement such as T2125');  //20200311

  If Vl(FetchElm(RetNo, 'T5007#1', 4)) > 1 then
    SaveDiagnostic(RetNo, 'T5007#1', 4,
      'E-T5007 MB factor should not exceed 1');

  // 20160328 //20160505 Igor
  If (Ret[RetNo].Province <> 'MB') and (FetchElm(RetNo, 'T5007#1', 9) > '') then
  begin
    SaveDiagnostic(RetNo, 'T5007#1', 4,
      'E-T5007 MB data do not apply to your province. Remove them');
    SaveDiagnostic(RetNo, 'T5007#1', 9,
      'E-T5007 MB data do not apply to your province. Remove them');
  end;
  If Vl(FetchElm(RetNo, 'T2038', 18)) < Vl(FetchElm(RetNo, 'T1229', 71)) then
    SaveDiagnostic(RetNo, 'T1229', 71,
     'W-T1229 Amount should be entered on T2038-Line 6717');

  //t1229
  FNo:=GetFormNo('T1229');
  if (Vl(FetchElm(REtno,Fno,101))>0) Or (Vl(FetchElm(REtno,Fno,103))>0)
  or (Vl(FetchElm(REtno,Fno,104))>0) Or (Vl(FetchElm(REtno,Fno,106))>0) then
  Begin
   if Vl(FetchElm(REtno,Fno,52))+Vl(FetchElm(REtno,Fno,4))=0 then
   Begin
    SaveDiagnostic(RetNo, 'T1229', 52,'W-T1229 Any amount qualifying for ITC?');
    SaveDiagnostic(RetNo, 'T1229', 4,'W-T1229 Any amount qualifying for ITC?');
   End;
  end;
  if (Vl(FetchElm(REtno,Fno,4))>0) and (Vl(FetchElm(REtno,Fno,28))=0) then
    SaveDiagnostic(RetNo, 'T1229', 28,'W-T1229 Any Provincial flow-through share tax credit claimed?');
  //==========================

  { medical } //20210301 E to W re dates
  Fno := GetFormNo('MEDICAL');
  if VL(FetchelmFNo(RetNo, Fno, 4))>0 then //medical expenses present //20251125
  begin
    if Vl(FetchElmFNo(RetNo, Fno, 233))+Vl(FetchElmFNo(RetNo, Fno, 236))>0 then //no %
     //ok
    Else
    begin
      SaveDiagnostic(RetNo, 'MEDICAL', 233, 'W-Medical expenses reported but no % specified');   //20260214
      SaveDiagnostic(RetNo, 'MEDICAL', 236, 'W-Medical expenses reported but no % specified');    //20260214
    end;
  end;

  i := 1;
  If EditDateYYYYMMDD(FetchElmFNo(RetNo, Fno, i), MyStrToInt(AppYear) + 1) = false
  then
    SaveDiagnostic(RetNo, 'MEDICAL', i, 'E-Medical date incorrect');
  i := 3;
  If EditDateYYYYMMDD(FetchElmFNo(RetNo, Fno, i), MyStrToInt(AppYear) + 1) = false
  then
    SaveDiagnostic(RetNo, 'MEDICAL', i, 'W-Medical end period incorrect');
  If (FetchElmFNo(RetNo, Fno, 3) > AppYear + '-12-31') then
    SaveDiagnostic(RetNo, 'MEDICAL', 3, 'W-Medical end period should fall into '
      + AppYear);

  // If (DateDiff(YYYY_mm_ddToMMDDYYYY(FetchElmFNo(RetNo,FNo,1)),
  // YYYY_mm_ddToMMDDYYYY(FetchElmFNo(RetNo,FNo,3)))>366)
  If (DateDiff(YMDtoDate(FetchElmFNo(RetNo, Fno, 1)), // 20160119 Igor
    YMDtoDate(FetchElmFNo(RetNo, Fno, 3))) > 366) // 20160119 Igor
    and (IsDeceased(RetNo) = false) then
    SaveDiagnostic(RetNo, 'MEDICAL', 1,
      'W-Medical periods exceed 12 months (unless deceased)');
  i := 5;
  Repeat
    If EditDateYYYYMMDD(FetchElmFNo(RetNo, Fno, i), MyStrToInt(AppYear) + 1) = false
    then
      SaveDiagnostic(RetNo, 'MEDICAL', i, 'W-Medical date incorrect');
    i := i + 5;
  until i > 105;

  { end medical }

  If (IsBankruptcyReturn(RetNo) = True) and
    (Ret[RetNo].FrmHasData[GetFormNo('BANKRPT')] = false) then
  begin
    SaveDiagnostic(RetNo, 'BANKRPT', 1, 'E-Bankruptcy info not completed');
  end;

  If Vl(FetchElm(RetNo, 'T778', 64)) > 0 then
  begin
    If (FetchElm(RetNo, 'T778', 3) = '') and (FetchElm(RetNo, 'T778', 77) = '')
      and (FetchElm(RetNo, 'T778', 83) = '') then
      SaveDiagnostic(RetNo, 'T778', 3,
        'E-T778-Specify who claims or remove expenses');
  end;

  If Ret[RetNo].MarStatus < 3 then
  begin
    // 20091231
    If (Vl(FetchElm(RetNo, 'T778', 64)) > 0) and
      (FetchElm(RetNo, 'T778', 77) + FetchElm(RetNo, 'T778', 83) = '') then
      SaveDiagnostic(RetNo, 'T778', 77,
        'W-T778-Since married expected check mark on this box');

    // If (FetchElm(RetNo,'T778',83) >'')  {higher income claiming}  //20091231
    If (Ret[RetNo].Lnn[23600] > Vl(FetchElmFNo(RetNo, InfoFNo, 19))) and
      (Vl(FetchElm(RetNo, 'T778', 64)) > 0) then
      SaveDiagnostic(RetNo, 'T778', 33,
        'W-T778-Child care entered on the higher inc\ome spouse');
  end;

  Fno := GetFormNo('T778');
  If (Ret[RetNo].FrmHasData[Fno] = True) then
  begin
    i := 33;
    k := 84;
    Repeat
      If (Vl(FetchElmFNo(RetNo, Fno, i)) > Vl(FetchElmFNo(RetNo, Fno, k))) and
        (Vl(FetchElmFNo(RetNo, Fno, i + 2)) > 0) then
        SaveDiagnostic(RetNo, 'T778', i,
          'W-T778-Exceeds camp max unless it includes babysitting');
      Inc(i, 4);
      Inc(k, 1);
    until i > 57;
  end;

  {
  If (IsSection216(RetNo)) and (UpperCase(FetchElmFNo(RetNo, InfoFNo, 73))
    <> 'X') then
    SaveDiagnostic(RetNo, 'INFO', 73,
      'E-NR-Section 216. Zero non-refundable credits');
  If IsSection216(RetNo) then
    SaveDiagnostic(RetNo, 'T1159', 1,
      'W-NR-Section 216. Only T1159 form is in effect');
   }
  (* //202340430
  If (IsSection216(RetNo)) and (Ret[RetNo].FrmHasData[GetFormNo('T1159')
    ] = false) then
  begin
    SaveDiagnostic(RetNo, 'T1159', 1,
      'W-T1159-Section 216 does not show any income');
  end;
  *)
  If (Ret[RetNo].MarStatus = 3) and (FetchElmFNo(RetNo, InfoFNo, 39) > '') and
    (Ret[RetNo].Lnn[30300] = 0) then
  begin
    SaveDiagnostic(RetNo, 'T1', 38,//SaveDiagnostic(RetNo, 'S1', 44,  //20191220
      'T-Spouse died during year. You may be able to claim the spouse');
  end;

  If (Vl(FetchElm(RetNo, 'T5006', 51)) > 0) // 20131127
    and (Vl(FetchElm(RetNo, 'ON428', 114)) = 0) and (Ret[RetNo].Province = 'ON')
  then
  begin
    SaveDiagnostic(RetNo, 'ON428', 123,
      'W-?Labor Spons. credit(Provincial)-You may be entitled');
  end;
  // ---------T4A-------------------------------------------
  For i := 1 to 10 do
  begin
    S := AllTrim(IntToStr(i));
    Fno := GetFormNo('T4A#' + S);
    IF Fno > 0 then // 20101219
    begin
      If Vl(FetchElmFNo(RetNo, Fno, 46)) > Vl(FetchElmFNo(RetNo, Fno, 31)) then
        SaveDiagnostic(RetNo, 'T4A#' + S, 46,
          'E-T4A-Scholarship deduction more than gross amount');
      If (Vl(FetchElmFNo(RetNo, Fno, 31)) > 0) and
        (Vl(FetchElmFNo(RetNo, Fno, 46)) = 0) then
        SaveDiagnostic(RetNo, 'T4A#' + S, 46,
          'W-T4A-Enter scholarship deduction if not already claimed');
    end;
  end;

  //20210315 COVID
  //x:=TotMultiple(RetNo, 'T4A', 97); //Covid income
  if (Ret[RetNo].T4ACovidIncome>0) //(Ret[RetNo].T4ACovidIncome>0)
  and (Vl(FetchElm(RetNo,'EFMEMO',2)) < Ret[RetNo].T4ACovidIncome) //income
  and (TotMultiple(RetNo, 'T4A', 4)>0)  //thrre is tax
  then
    SaveDiagnostic(RetNo, 'EFMEMO', 2,
    'W-T4A-COVID income $'+FormatFloat('#,###.###.##',Ret[RetNo].T4ACovidIncome)+' must be included on box 53450 of EFMEMO');

  x := TotMultiple(RetNo, 'T4A', 20);
  If x > 0 then { elig retiring allowances }
  begin
    If Vl(FetchElm(RetNo, 'RRSP', 71)) = 0 then
      SaveDiagnostic(RetNo, 'RRSP', 71, 'W-RRSP transfer from T4A not in RRSP');
  end;


  // 20151207
  x := TotMultiple(RetNo, 'T4A', 43); // box 40 AIP for T1172
  If (x > 0) and (Vl(FetchElm(RetNo, 'T1172', 104)) = 0) then
  begin
    SaveDiagnostic(RetNo, 'T1172', 117,
      'W-T1172 s/b completed due to T4A-Box40');
  end;

  // 20160129
  x := TotMultiple(RetNo, 'T4A', 87); // box 196
  If (x > 0) and (Vl(FetchElm(RetNo, 'OTHDED', 64)) = 0) then
  begin
    SaveDiagnostic(RetNo, 'OTHDED', 64,
      'W-OTHDED-LN 256-You may claim tuition assistance that is more than the scholarship exemption you can claim for this tuition assistance');
  end;
  // -----
  If CountScholarships(RetNo) > 1 then
  begin
    SaveDiagnostic(RetNo, 'T4A#1', 7,
      'W-T4A-Multiple T4A scholarships. Combine them in T4A#1');
  end;
  // ------------------------ end  t4a
  If (Vl(FetchElm(RetNo, 'T4RIF#1', 2)) > 0) and
    (Vl(FetchElm(RetNo, 'T4RIF#1', 4)) > 0) then
  begin
    SaveDiagnostic(RetNo, 'T4RIF#1', 4,
      'W-RIF-?double-entering(box 16 and 20)');
  end;

  // 20121213
  Fno := GetFormNo('T4AP#1');
  If Vl(FetchElmFNo(RetNo, Fno, 11)) > 0 then // ret amount
  begin
    If Vl(FetchElmFNo(RetNo, Fno, 8)) = 0 then
      SaveDiagnostic(RetNo, 'T4AP#1', 8, 'E-T4AP-Months required');
  end;
  If Vl(FetchElmFNo(RetNo, Fno, 8)) > 0 then // ret amount
  begin
    If Vl(FetchElmFNo(RetNo, Fno, 11)) = 0 then
      SaveDiagnostic(RetNo, 'T4AP#1', 8, 'E-T4AP-Months not required');
  end;

  (*
    If (Vl(FetchElm(RetNo,'T4AP#1',4)) >0)
    and
    ((Vl(FetchElm(RetNo,'T4AP#1',11)) >0)
    or (Vl(FetchElm(RetNo,'T4AP#1',13)) >0))
    and (Vl(FetchElm(RetNo,'T4AP#1',8)) =0) then
    SaveDiagnostic(RetNo,'T4AP#1',8,'E-T4AP-Months required');
  *)
  (*
    If (Vl(FetchElm(RetNo,'T4AP#1',4)) >0)  //cpp benefits
    and (Vl(FetchElm(RetNo,'T4AP#1',11))+Vl(FetchElm(RetNo,'T4AP#1',13)) =0) //no retir or disabi
    then
    begin
    If Vl(FetchElm(RetNo,'T4AP#1',8)) >0 then   //months
    SaveDiagnostic(RetNo,'T4AP#1',8,'W-T4AP-Months are not required');
    end;
  *)
  If (Vl(FetchElmFNo(RetNo, Fno, 8)) > 12) then
    SaveDiagnostic(RetNo, 'T4AP#1', 8, 'E-T4AP-Months exceed 12');

  If (Vl(FetchElmFNo(RetNo, Fno, 3)) > 12) then // 20121116
    SaveDiagnostic(RetNo, 'T4AP#1', 3, 'E-T4AP-Months exceed 12');

  If TotMultiple(RetNo, 'T4AP', 11) + Ret[RetNo].Lnn[11410] - Ret[RetNo].Lnn[11400] > 0.01
  then
    SaveDiagnostic(RetNo, 'T4AP#1', 11,
      'W-T4AP-Retirement/Disab. benefits exceed Line 114');

  IF (Ret[RetNo].Age >= 65) and (Ret[RetNo].Lnn[11300] = 0) then
  begin
    SaveDiagnostic(RetNo, 'T4AOAS#1', 11, 'W-OAS has not been claimed');
  end;

  IF (Ret[RetNo].Age < 65) and (Ret[RetNo].Lnn[11300] > 0) then
  begin
    SaveDiagnostic(RetNo, 'T4AOAS#1', 2,
      'W-OAS has been claimed for age under 65');
  end;

  { //20150131
    If (FetchElm(RetNo,'GSTC',1) = 'Y') then
    begin
    If Ret[RetNo].Age <19 then
    SaveDiagnostic(RetNo,'INFO',29,'W-GST Credit-Age less than 19. May not be entitled');
    end;
  }
  { 20150131
    If Ret[RetNo].CouplingSw = false then
    begin
    If (CalcGstc(RetNo,'GSTC',GetFormNo('GSTC')) >0)
    and (FetchElmFNo(RetNo,InfoFNo,29) ='')
    and (Ret[RetNo].Age >18)
    and (IsDeceased(RetNo)=False)  then
    SaveDiagnostic(RetNo,'INFO',29,'W-GST Credit not claimed. Tick Yes or No');
    end;
  }
  If (Vl(FetchElm(RetNo, 'T1M#1', 124)) > 0) and
    (Vl(FetchElm(RetNo, 'T1M#1', 127)) = 0) then
    SaveDiagnostic(RetNo, 'T1M#1', 127, 'W-T1M-Moving expenses-Income missing');
  // 20120411 E to W

  If (Vl(FetchElm(RetNo, 'T1M#1', 124)) > 0) and
    (Vl(FetchElm(RetNo, 'T1M#1', 22)) + Vl(FetchElm(RetNo, 'T1M#1', 23)) = 0)
  then
    SaveDiagnostic(RetNo, 'T1M#1', 22, 'E-T1M-Moving exp. Kilometers missing');

  If (Vl(FetchElm(RetNo, 'S11', 30)) > 0) and (Ret[RetNo].Lnn[32700] = 0) then
    SaveDiagnostic(RetNo, 'S11', 10,
      'T-S11-Consider transferring unused tuition/education');

  If (FetchElm(RetNo, 'S11', 26) > '') and
    (ValidSin(FetchElm(RetNo, 'S11', 26)) = false) then
    SaveDiagnostic(RetNo, 'S11', 26, 'E-S11-Invalid SIN for tuition transfer');

  {//20201215 ??? threis no 15
  If Vl(FetchElm(RetNo, 'S11', 15)) + Vl(FetchElm(RetNo, 'S11', 12)) > 12 then
    SaveDiagnostic(RetNo, 'S11', 15,
      'E-S11-Full and part-time months exceed 12');
  }

  If FetchElm(RetNo, 'S11', 15) + FetchElm(RetNo, 'S11', 12) > '' then
  begin
    If Vl(FetchElm(RetNo, 'S11', 1)) = 0 then
      SaveDiagnostic(RetNo, 'S11', 1, 'W-S11-Tuition fees may be missing');
  end;

  If (Ret[RetNo].Lnn[32700] > 0) { xfer tuition }
    and (UpperCase(FetchElm(RetNo, 'S11', 25)) <> 'Y') and
    (FetchElm(RetNo, 'S11', 26) = '') then
    SaveDiagnostic(RetNo, 'S11', 26,
      'W-S11-Specify beneficiary of the tuition transfer (OPTIONAL)');

  If (Ret[RetNo].Lnn[22900] > 0) and (Ret[RetNo].Lnn[45700] = 0) then
    SaveDiagnostic(RetNo, 'GST370', 51, 'W-GST370 Rebate not claimed');   //text 20210323

  If Ret[RetNo].Lnn[10120] > Ret[RetNo].Lnn[10100] then
    SaveDiagnostic(RetNo, 'T1', 204,
      'W-Ln101-Empl. Commissions exceed empl income at line 101');


  If (Ret[RetNo].Age + 1 > 71) and (Vl(FetchElm(RetNo, 'RRSPNXT', 2)) > 0) and
    (Vl(FetchElm(RetNo, 'RRSPNXT', 1)) = 0) then
    SaveDiagnostic(RetNo, 'RRSPNXT', 1,
      'W-RRSP next year is NIL (Age> 71). Override if Spouse < 72');

  { Multi office }
  ErrMsg := 'M-Invoice: Please enter explanation on invoice';
  // If LeftStr(LicenseLevel,8) = 'T1 Multi' then
  If LicenseLevel in anyMulti then // 20160119 Igor
  begin
    If ((Vl(FetchElm(RetNo, 'INVOICE', 218)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 227) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 227, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 242)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 240) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 240, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 243)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 241) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 241, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 256)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 253) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 253, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 257)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 254) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 254, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 258)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 255) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 255, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 261)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 259) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 259, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 262)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 260) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 260, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 265)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 263) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 263, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 266)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 264) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 264, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 269)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 267) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 267, ErrMsg);

    If ((Vl(FetchElm(RetNo, 'INVOICE', 270)) <> 0) and
      (FetchElm(RetNo, 'INVOICE', 268) = '')) then
      SaveDiagnostic(RetNo, 'INVOICE', 268, ErrMsg);

    i := 234;
    repeat
      If (Vl(FetchElm(RetNo, 'INVOICE', i)) <> 0) and
        (FetchElm(RetNo, 'INVOICE', i - 6) = '') then
        SaveDiagnostic(RetNo, 'INVOICE', i - 6, ErrMsg);
      Inc(i, 1);
    until i > 239;
  end;
  // rental
  For i := 1 to 10 do
  begin
    FInst := '#' + AllTrim(IntToStr(i));
    Fno := GetFormNo('T776' + FInst);
    If Fno > 0 then
    begin
      If (Ret[RetNo].FrmHasData[Fno]) and
        (UpperCase(FetchElmFNo(RetNo, Fno, 113)) = 'Y') and
        (FetchElmFNo(RetNo, Fno, 11) + FetchElmFNo(RetNo, Fno, 13) = '') then
        SaveDiagnostic(RetNo, 'T776' + FInst, 11,
          'W-T776-Enter Partnership No or Tax Shelter No');

      // 20101206
      If (Ret[RetNo].FrmHasData[Fno]) and (FetchElmFNo(RetNo, Fno, 15) > '')
      then
      begin
        If Length(FetchElmFNo(RetNo, Fno, 15)) <> 15 then
          SaveDiagnostic(RetNo, 'T776' + FInst, 15,
            'E-T776' + FInst + ' Account number must be 15 characters');
      end;

      If (Ret[RetNo].FrmHasData[Fno]) then // 20170503
      begin
        If Vl(FetchElmFNo(RetNo, Fno, 18)) = 0 then
          SaveDiagnostic(RetNo, 'T776' + FInst, 18,
            'E-T776' + FInst +
            ' Statement has zero %. Right click and Clear Form');
      end;

      // 20120227
      If (Ret[RetNo].FrmHasData[Fno]) and (FetchElmFNo(RetNo, Fno, 11) > '')
      then
      begin
        If Length(FetchElmFNo(RetNo, Fno, 11)) <> 9 then
          SaveDiagnostic(RetNo, 'T776' + FInst, 11,
            'E-T776' + FInst + ' Partnership Business Number is incorrect');
      end;

      // 20120213
      If (Ret[RetNo].FrmHasData[Fno]) then
      begin
        If FetchElmFNo(RetNo, Fno, 109) = '' then
          SaveDiagnostic(RetNo, 'T776' + FInst, 109,
            'E-T776' + FInst + ' Business Name required (or your Name)');
        If FetchElmFNo(RetNo, Fno, 110) = '' then
          SaveDiagnostic(RetNo, 'T776' + FInst, 110,
            'E-T776' + FInst + ' Street required');
        If FetchElmFNo(RetNo, Fno, 112) = '' then
          SaveDiagnostic(RetNo, 'T776' + FInst, 112,
            'E-T776' + FInst + ' City required');
        If FetchElmFNo(RetNo, Fno, 111) = '' then
          SaveDiagnostic(RetNo, 'T776' + FInst, 111,
            'E-T776' + FInst + ' Postal Code required');
      end;

      j := 28; // 20170708
      Repeat
        If Vl(FetchElmFNo(RetNo, Fno, j)) > 0 then
        begin
          If FetchElmFNo(RetNo, Fno, j - 3) = '' then
            SaveDiagnostic(RetNo, 'T776' + FInst, j - 3,
              'E-T776' + FInst +
              ' Enter full partner info (First/Last/address)');
          If FetchElmFNo(RetNo, Fno, j - 2) = '' then
            SaveDiagnostic(RetNo, 'T776' + FInst, j - 2,
              'E-T776' + FInst +
              ' Enter full partner info (First/Last/address)');
        end;
        Inc(j, 4);
      until j > 44;
      // 20120324
      If Vl(FetchElmFNo(RetNo, Fno, 28)) > 0 then
      begin
        If FetchElmFNo(RetNo, Fno, 121) = '' then
          SaveDiagnostic(RetNo, 'T776' + FInst, 121,
            'E-T776' + FInst + ' Enter full partner info (First/Last/address)');
      end;

      // 20170708
      If Vl(FetchElmFNo(RetNo, Fno, 32)) > 0 then
      begin
        If FetchElmFNo(RetNo, Fno, 123) = '' then
          SaveDiagnostic(RetNo, 'T776' + FInst, 123,
            'E-T776' + FInst + ' Enter full partner info (First/Last/address)');
      end;
      { see above
        //20110420
        If (Ret[RetNo].FrmHasData[FNo]) and (FetchElmFNo(RetNo,FNo,109) = '') then
        SaveDiagnostic(RetNo,'T776'+FInst,109,'W-T776'+FInst+' Enter Business name or Client Name and address');
      }
      // T776 partners
      If Ret[RetNo].FrmHasData[Fno] then
      begin
        x := 100 - Vl(FetchElmFNo(RetNo, Fno, 18)); // left for for partners
        y := Vl(FetchElmFNo(RetNo, Fno, 143));

       //20260427      143 not 24
        If y - x > 0.01 then // 20140101
          SaveDiagnostic(RetNo, 'T776' + FInst, 143,
            'E-T776' + FInst + ' Partners % exceeds expected by ' +
            FormatFloat('###0.0000', y - x) + '%');
        If x - y > 0.01 then
          SaveDiagnostic(RetNo, 'T776' + FInst, 143,
            'E-T776' + FInst + ' Partners % less than expected by ' +
            FormatFloat('###0.0000', x - y) + '%');
      end;


      //jz//20260421//CCAv12//T776 CCA MAX - remove
      {
      //20260419
      If (Ret[RetNo].FrmHasData[Fno]) then
      begin
        If  (Vl(FetchElmFNo(RetNo, Fno, 105)) > 0) and
            (Vl(FetchElmFNo(RetNo, Fno, 105)) > TotMultiple(RetNo, 'T776', 100))  //(TotMultiple(RetNo, 'T776', 105)) > TotMultiple(RetNo, 'T776', 100))
        then
        begin
          SaveDiagnostic(RetNo, 'T776' + FInst, 105,'E-T776-CCA created loss. Reduce CCA in Assets or Autos form');
        end;
      end;

      //jz//20260420 -
      If (Ret[RetNo].FrmHasData[Fno]) then
      begin
         xx:=GetTotalT776IncomeBeforeCCA(RetNo);  //elm 100 on T776
         If //(
              //(Vl(FetchElmFNo(RetNo, Fno, 105)) > 0) and                                  //specific statement has CCA and
              //(Vl(FetchElmFNo(RetNo, Fno, 100)) - Vl(FetchElmFNo(RetNo, Fno, 105)) < 0 )  //that CCA causes loss in that statement
            //)
            //OR
            (
              (xx<0) or                                                                   //there is already overall loss regardless of any CCA
              (xx-TotMultiple(RetNo, 'T776',105)<0)                                       //overall CCA causes over all loss
            )
         then
         begin
           SaveDiagnostic(RetNo, 'T776' + FInst, 105,'E-T776-CCA created loss. Reduce CCA in AssetsB Or Autos form ');
           //SaveDiagnostic(RetNo, 'ASSETSB#1',216,'E-T776-CCA created loss. Reduce CCA in AssetsB Or Autos form '
           /// +'by allocating less % or no percent in one or more AssetsB or Autos');
         end;
      end;
      }




      If (Ret[RetNo].FrmHasData[Fno]) then
      begin
        If (FetchElmFNo(RetNo, Fno, 110) > '') and
          (FetchElmFNo(RetNo, Fno, 112) = '') then
          SaveDiagnostic(RetNo, 'T776' + FInst, 112,
            'E-T776' + FInst + '-Rental: Complete the address fully');
      end;

      If (Ret[RetNo].FrmHasData[Fno]) then
      begin
        If (FetchElmFNo(RetNo, Fno, 112) > '') // province
          and (FetchElmFNo(RetNo, Fno, 110) = '') then
          SaveDiagnostic(RetNo, 'T776' + FInst, 110,
            'E-T776' + FInst + '-Rental: Complete the address fully');
      end;

      If (Ret[RetNo].FrmHasData[Fno]) then
      begin
        If (FetchElmFNo(RetNo, Fno, 111) > '') // postal
          and (FetchElmFNo(RetNo, Fno, 110) = '') then // str
          SaveDiagnostic(RetNo, 'T776' + FInst, 110,
            'E-T776' + FInst + '-Rental: Complete the address fully');

        If (FetchElmFNo(RetNo, Fno, 110) > '') // str
        // And (UpperCase(FetchElmFNo(RetNo,FNo,120))<>'ZZ')  //20180416
          and (ValidPostal(RetNo, FetchElmFNo(RetNo, Fno, 111)) = false) then
          // postal
          SaveDiagnostic(RetNo, 'T776' + FInst, 111,
            'E-T776' + FInst + '-Rental: Postal code invalid');
      end;

      If (Ret[RetNo].FrmHasData[Fno]) then
      begin
        If Vl(FetchElmFNo(RetNo, Fno, 56)) = 0 then
          SaveDiagnostic(RetNo, 'T776' + FInst, 47,
            'E-T776' + FInst + '-Rental has $0 gross. Clear it or complete it');
      end;

      // 20130129
      If (Ret[RetNo].FrmHasData[Fno]) then
      begin
        If (Vl(FetchElmFNo(RetNo, Fno, 56)) = 0) and
          (Vl(FetchElmFNo(RetNo, Fno, 106)) = 0) then
          SaveDiagnostic(RetNo, 'T776' + FInst, 56,
            'E-T776' + FInst +
            '-Rental has Zero Gross and Net. Clear it or complete it');
      end;

    end;
  end; // i  //rental


   //jz//20260421//CCAv12//T776 CCA MAX - remove
  {
   //20260419 cz
   xx:=GetTotalT776IncomeBeforeCCA(RetNo);  //elm 100 on T776
   If (xx<0) or  //it is a loss before CCA
      (xx-TotMultiple(RetNo, 'T776',105)<0)
   then   //Total CCA taken
      SaveDiagnostic(RetNo, 'ASSETSB#1',216,'E-T776-CCA created loss. Reduce CCA in AssetsB Or Autos form '
     //SaveDiagnostic(RetNo, 'T776' + FInst, 105,'E-T776-CCA created loss. Reduce CCA in Assets form '
       +'by allocating less % or no percent in one or more AssetsB or Autos');
  // );
  }
 //---------------------------



  If (Ret[RetNo].FrmHasData[GetFormNo('T2042#1')]) and
    (UpperCase(FetchElm(RetNo, 'T2042#1', 68)) = 'Y') and
    (FetchElm(RetNo, 'T2042#1', 18) + FetchElm(RetNo, 'T2042#1', 20) = '') then
    SaveDiagnostic(RetNo, 'T2042#1', 18,
      'W-T2042-Partnership No or Tax Shelter No');
  If GetFormNo('T2042#2') > 0 then // 20101020
  begin
    If (Ret[RetNo].FrmHasData[GetFormNo('T2042#2')]) and
      (UpperCase(FetchElm(RetNo, 'T2042#2', 68)) = 'Y') and
      (FetchElm(RetNo, 'T2042#2', 18) + FetchElm(RetNo, 'T2042#2', 20) = '')
    then
      SaveDiagnostic(RetNo, 'T2042#2', 18,
        'W-T2042-Partnership No or Tax Shelter No');
  end;

  If FetchElmFNo(RetNo, InfoFNo, 173) = '' then //no foreign address //20240328
  Begin
   If FetchElmFNo(RetNo, InfoFNo, 15) = '' then
    SaveDiagnostic(RetNo, 'INFO', 15, 'E-POSTAL code required');
  End;

  // If FetchElmFNo(RetNo,InfoFNo,14) <> 'ZZ' then
  If IsCanadianProvince(FetchElmFNo(RetNo, InfoFNo, 14)) = True then // 20120222
  begin
    If ValidPostal(RetNo, FetchElmFNo(RetNo, InfoFNo, 15)) = false then
      SaveDiagnostic(RetNo, 'INFO', 15,
        'E-POSTAL code-format ANANAN (A=Alpha, N=Numeric)');
  end;

  //20200519
  For i := 1 to 5 do
  begin
    FInst := '#' + AllTrim(IntToStr(i));
    Fno := GetFormNo('T777' + FInst);
    If (Fno > 0) then
    begin
      If (FetchElmFNo(RetNo, Fno, 62)='') and (Vl(FetchElmFNo(RetNo, Fno, 46))>0) then   //20210323
          SaveDiagnostic(RetNo, 'T777'+FInst, 62,'W-T777-GST370-Enter Y/N for work-space-in-home');

      if (Ret[RetNo].FrmHasData[FNo]) and (Vl(FetchElmFNo(RetNo,FNo,24))=0)
      and (FetchElmFNo(RetNo,FNo,68)>'')
      then
        SaveDiagnostic(RetNo, 'T777'+FInst,68,'W-T777' + FInst +' not used. Please enter expenses or remove the Employer Name');
    end;
   end;


  // naics and address, tot income and Partners % for 5 statements
  ErrMsg := 'NAICS Industry Code is invalid';
  For i := 1 to 5 do
  begin
    FInst := '#' + AllTrim(IntToStr(i));
    // 20100129
    Fno := GetFormNo('T2125' + FInst);
    If Fno = 0 then
    begin
      If GetT4AIncomeForT2125(RetNo, FInst) > 0 then
        SaveDiagnostic(RetNo, 'T2125#1', 0, 'E-T2125' + FInst +
          ' not completed to report income from T4A slip(s)');
    end;

    If Fno > 0 then // 20101219
    begin
      If Pos(EfDelim, FetchElmFNo(RetNo, Fno, 8)) > 0 then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 8,
          'E-T2125' + FInst + ' Remove ! from business Name');
      If Pos(EfDelim, FetchElmFNo(RetNo, Fno, 10)) > 0 then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 10,
          'E-T2125' + FInst + ' Remove # from address');

      // 20100129
      If Vl(FetchElmFNo(RetNo, Frec.FormNo, 76)) <> GetT4AIncomeForT2125(RetNo,
        FInst) then
        T2125(RetNo, 'T2125' + FInst, Fno); // calc
      // SaveDiagnostic(RetNo,'BSUM'+FInst,76,'E-T2125'+FInst' open income not defined income from T4A slip(s)');

      // 20120201
      If Vl(FetchElmFNo(RetNo, Fno, 24)) < 0 then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 24,
          'W-T2125' + FInst + ' PST, GST/HST is negative. Please verify');

      // 20101206
      If (Ret[RetNo].FrmHasData[Fno]) and (FetchElmFNo(RetNo, Fno, 19) > '')
      then
      begin
        If Length(FetchElmFNo(RetNo, Fno, 19)) <> 15 then
          SaveDiagnostic(RetNo, 'T2125' + FInst, 19,
            'E-T2125' + FInst + ' Account number must be 15 characters');
      end;

      // 20170503
      If (Ret[RetNo].FrmHasData[Fno]) then // 20170503
      begin
        If Vl(FetchElmFNo(RetNo, Fno, 18)) = 0 then
          SaveDiagnostic(RetNo, 'T2125' + FInst, 18,
            'E-T2125' + FInst +
            ' Statement has zero %. Right click and Clear Form');
      end;

      // 20130406
      If (Ret[RetNo].FrmHasData[Fno]) and (FetchElmFNo(RetNo, Fno, 35) > '')
      then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 35,
          'W-T2125' + FInst +
          ' Indicator on T5013 has been set. Remove unless valid');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (FetchElmFNo(RetNo, Fno, 4) <> AppYear + '-01-01') then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 4,
          'W-T2125' + FInst + ' You entered Short fiscal periods or or non-calendar year');  //20230518
      If (Ret[RetNo].FrmHasData[Fno]) and
        (FetchElmFNo(RetNo, Fno, 5) <> AppYear + '-12-31') then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 5,
          'W-T2125' + FInst + ' You entered Short fiscal periods or or non-calendar year');  //20230518
      If (Ret[RetNo].FrmHasData[Fno]) and (Vl(FetchElmFNo(RetNo, Fno, 32)) = 0)
      then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 28,
          'W-T2125' + FInst + ' has zero gross income'); // 20110207

      // 20130129
      If (Ret[RetNo].FrmHasData[Fno]) and (Vl(FetchElmFNo(RetNo, Fno, 32)) = 0)
        and (Vl(FetchElmFNo(RetNo, Fno, 106)) = 0) then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 32,
          'E-T2125' + FInst + ' has Zero in both Gross and Net'); // 20110207

      // 20170517
      If (Ret[RetNo].FrmHasData[Fno]) and (Vl(FetchElmFNo(RetNo, Fno, 32)) < 0)
      then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 32,
          'E-T2125' + FInst + ' has Gross income less than a dollar');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (ABS(Vl(FetchElmFNo(RetNo, Fno, 106))) < 1) then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 106,
          'W-T2125' + FInst + ' has Net Income (+ or -) less than a dollar');
      // 20170731 E -> W
      // ----------------------

      If (Ret[RetNo].FrmHasData[Fno]) and
        (InvalidNaics(FetchElmFNo(RetNo, Fno, 12)) = True)
      // (Length(FetchElmFNo(RetNo,FNo,12)) <6)
      then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 12, 'E-T2125' + FInst + ' '
          + ErrMsg);
      If (Ret[RetNo].FrmHasData[Fno]) and
        (Length(FetchElmFNo(RetNo, Fno, 10)) = 0) then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 10,
          'E-T2125' + FInst + ' Address incomplete');
      If (Ret[RetNo].FrmHasData[Fno]) and
        (Length(FetchElmFNo(RetNo, Fno, 13)) = 0) then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 13,
          'E-T2125' + FInst + ' Address incomplete');
      If (Ret[RetNo].FrmHasData[Fno]) and
        (Length(FetchElmFNo(RetNo, Fno, 14)) = 0) then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 14,
          'E-T2125' + FInst + ' Address incomplete');
      If (Ret[RetNo].FrmHasData[Fno]) and // 201171216
        (Length(FetchElmFNo(RetNo, Fno, 53)) = 0) then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 53,
          'E-T2125' + FInst + ' Address incomplete');
      If (Ret[RetNo].FrmHasData[Fno]) and
        (ValidPostal(RetNo, FetchElmFNo(RetNo, Fno, 14)) = false) then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 14,
          'E-T2125' + FInst + ' Invalid Postal code');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (ValidTaxShelterNo(FetchElmFNo(RetNo, Fno, 16)) = false) then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 16,
          'E-T2125' + FInst + ' Invalid TaxShelter (Format AAnnnn)');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (ValidPartnershipNo(FetchElmFNo(RetNo, Fno, 15)) = false) then
        SaveDiagnostic(RetNo, 'T2125' + FInst, 15,
          'E-T2125' + FInst +
          ' Invalid Partnership Number (Format 9 numerics)');

      // 20120324
      If Vl(FetchElmFNo(RetNo, Fno, 241)) > 0 then
      begin
        If (FetchElmFNo(RetNo, Fno, 258) = '') Or
          (FetchElmFNo(RetNo, Fno, 248) = '') Or
          (FetchElmFNo(RetNo, Fno, 245) = '') then
        Begin
          SaveDiagnostic(RetNo, 'T2125' + FInst, 258,
            'E-T2125' + FInst + ' Enter full partner information and address');
          SaveDiagnostic(RetNo, 'T2125' + FInst, 248,
            'E-T2125' + FInst + ' Enter full partner information and address');
          SaveDiagnostic(RetNo, 'T2125' + FInst, 245,
            'E-T2125' + FInst + ' Enter full partner information and address');
        end;
      end;

      If (Ret[RetNo].FrmHasData[Fno]) then // cca   //20101206
      begin
        If (Vl(FetchElmFNo(RetNo, Fno, 228)) > 0) and
          (Vl(FetchElmFNo(RetNo, Fno, 254)) = 0) then
          SaveDiagnostic(RetNo, 'T2125' + FInst, 254,
            'W-T2125' + FInst + ' Home use expenses but not personal use %');
      end;
      // 20101206
      If Ret[RetNo].FrmHasData[Fno] then // cca
      begin
        If (UpperCase(FetchElmFNo(RetNo, Fno, 178)) = 'Y') then
          SaveDiagnostic(RetNo, 'T2125' + FInst, 178,
            'W-T2125' + FInst + ' Automobile expenses entered via override');
      end;

      If (Ret[RetNo].FrmHasData[Fno]) then // cca  //20101206
      begin
        j := 301;
        Repeat
          If IsValidCCA(FetchElmFNo(RetNo, Fno, j)) = false then
            SaveDiagnostic(RetNo, 'T2125' + FInst, j,
              'E-T2125' + FInst + ' CCA class is invalid');
          Inc(j, 10);
        until j > 371;
      end;

      If Vl(FetchElmFNo(RetNo, Fno, 382)) <> 0 then
      begin
        If UpperCase(FetchElmFNo(RetNo, AssetsFNo, 10)) <> 'Y' then
          SaveDiagnostic(RetNo, 'CCALIST', 0,
            'E-CCA-Assets not entered on the Assets forms');
      end;
      // T2125 partners
      If (Ret[RetNo].FrmHasData[Fno]) // 20101206
        and (FetchElmFNo(RetNo, Fno, 35) = '') // 20101206
      then
      begin
        x := 100 - Vl(FetchElmFNo(RetNo, Fno, 18)); // 20101206
        y := Vl(FetchElmFNo(RetNo, Fno, 204)); // 20101206
        If y - x > 0.01 then // If y > X then
          SaveDiagnostic(RetNo, 'T2125' + FInst, 238,
            'E-T2125' + FInst + ' Partners % exceeds expected by ' +
            FormatFloat('###0.0000', y - x) + '%'); // 20111208
        If x - y > 0.01 then // y< x then //If y< x then
          SaveDiagnostic(RetNo, 'T2125' + FInst, 238,
            'E-T2125' + FInst + ' Partners % less than expected by ' +
            FormatFloat('###0.0000', x - y) + '%'); // 20111208

      end;

    end;
    // end the T2125 FNo

    // farming
    Fno := GetFormNo('T2042' + FInst);
    If Fno > 0 then // 20101219
    begin
      If Pos(EfDelim, FetchElmFNo(RetNo, Fno, 8)) > 0 then
        SaveDiagnostic(RetNo, 'T2042' + FInst, 8,
          'E-T2042' + FInst + ' Remove ! from Farm Name');

      If Pos(EfDelim, FetchElmFNo(RetNo, Fno, 10)) > 0 then
        SaveDiagnostic(RetNo, 'T2042' + FInst, 10,
          'E-T2042' + FInst + ' Remove # from address');

      // 20101206
      If (Ret[RetNo].FrmHasData[Fno]) and (FetchElmFNo(RetNo, Fno, 21) > '')
      then
      begin
        If Length(FetchElmFNo(RetNo, Fno, 21)) <> 15 then
          SaveDiagnostic(RetNo, 'T2042' + FInst, 21,
            'E-T2042' + FInst + ' Account number must be 15 characters');
      end;

      //20190516
      If (Ret[RetNo].FrmHasData[Fno]) and (UpperCase(FetchElmFNo(RetNo, Fno, 67)) = 'Y')
      and (UpperCase(FetchElm(RetNo, 'BUSSUM',162)) = 'Y')     //restr indicator in both
      then SaveDiagnostic(RetNo, 'T2042' + FInst, 67,'E-T2042' + FInst + ' Remove the Restricted loss indicator. It is on the BUSSUM form');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (FetchElmFNo(RetNo, Fno, 4) <> AppYear + '-01-01') then
        SaveDiagnostic(RetNo, 'T2042' + FInst, 4,
          'W-T2042' + FInst + ' Short fiscal periods or non-calendar year');
      If (Ret[RetNo].FrmHasData[Fno]) and
        (FetchElmFNo(RetNo, Fno, 5) <> AppYear + '-12-31') then
        SaveDiagnostic(RetNo, 'T2042' + FInst, 5,
          'W-T2042' + FInst + ' Short fiscal periods or non-calendar year');

      If (Ret[RetNo].FrmHasData[Fno]) and (Vl(FetchElmFNo(RetNo, Fno, 66)) = 0)
      then
        SaveDiagnostic(RetNo, 'T2042' + FInst, 26,
          'W-T2042' + FInst + ' has zero gross income');

      // 20130129
      If (Ret[RetNo].FrmHasData[Fno]) and (Vl(FetchElmFNo(RetNo, Fno, 66)) = 0)
        and (Vl(FetchElmFNo(RetNo, Fno, 148)) = 0) then
        SaveDiagnostic(RetNo, 'T2042' + FInst, 66,
          'E-T2042' + FInst + ' has Zero in both Gross and Net');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (InvalidNaics(FetchElmFNo(RetNo, Fno, 17)) = True) // 20141007
      // (Length(FetchElmFNo(RetNo,FNo,17)) <6)
      then
        SaveDiagnostic(RetNo, 'T2042' + FInst, 17, 'E-T2042' + FInst + ' '
          + ErrMsg);

      If UpperCase(FetchElmFNo(RetNo, Fno, 68)) <> 'Y' then
      // not from T5013 //20121224
      Begin
        If (Ret[RetNo].FrmHasData[Fno]) and
          (Length(FetchElmFNo(RetNo, Fno, 10)) = 0) then
          SaveDiagnostic(RetNo, 'T2042' + FInst, 10,
            'E-T2042' + FInst + ' Address incomplete');
        If (Ret[RetNo].FrmHasData[Fno]) and
          (Length(FetchElmFNo(RetNo, Fno, 12)) = 0) then
          SaveDiagnostic(RetNo, 'T2042' + FInst, 12,
            'E-T2042' + FInst + ' Address incomplete');
        If (Ret[RetNo].FrmHasData[Fno]) and
          (Length(FetchElmFNo(RetNo, Fno, 13)) = 0) then
          SaveDiagnostic(RetNo, 'T2042' + FInst, 13,
            'E-T2042' + FInst + ' Address incomplete');
        // 20180204
        If (Ret[RetNo].FrmHasData[Fno]) and
          (Length(FetchElmFNo(RetNo, Fno, 71)) = 0) then
          SaveDiagnostic(RetNo, 'T2042' + FInst, 71,
            'E-T2042' + FInst + ' Address incomplete');

        If (Ret[RetNo].FrmHasData[Fno]) and
          (ValidPostal(RetNo, FetchElmFNo(RetNo, Fno, 13)) = false) then
          SaveDiagnostic(RetNo, 'T2042' + FInst, 13,
            'E-T2042' + FInst + ' Invalid Postal code');
      end;

      If (Ret[RetNo].FrmHasData[Fno]) and
        (ValidTaxShelterNo(FetchElmFNo(RetNo, Fno, 20)) = false) then
        SaveDiagnostic(RetNo, 'T2042' + FInst, 20,
          'E-T042' + FInst + ' Invalid TaxShelter (Format AAnnnn)');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (ValidPartnershipNo(FetchElmFNo(RetNo, Fno, 18)) = false) then
        SaveDiagnostic(RetNo, 'T2042' + FInst, 18,
          'E-T2042' + FInst +
          ' Invalid Partnership Number (Format 9 numerics)');

      If (Ret[RetNo].FrmHasData[Fno]) then
      // cca  // 201020 GetFormNo('T2042'+FInst)
      begin
        j := 401;
        Repeat
          If IsValidCCA(FetchElmFNo(RetNo, Fno, j)) = false then // 20101020
            SaveDiagnostic(RetNo, 'T2042' + FInst, j,
              'E-T2042' + FInst + ' CCA class is invalid');
          Inc(j, 10);
        until j > 471;
      end;
      If Vl(FetchElmFNo(RetNo, Fno, 482)) <> 0 then // 20101020
      begin
        If UpperCase(FetchElmFNo(RetNo, AssetsFNo, 10)) <> 'Y' then
          SaveDiagnostic(RetNo, 'CCALIST', 0,
            'E-CCA-Assets not entered on the Assets forms');
      end;
      // T2042 partners
      If Ret[RetNo].FrmHasData[Fno] then // 20101020
      begin
        x := 100 - Vl(FetchElmFNo(RetNo, Fno, 24)); // 20101020
        y := Vl(FetchElmFNo(RetNo, Fno, 611)); // 20101020
        If y - x > 0.01 then // 20120227
          SaveDiagnostic(RetNo, 'T2042' + FInst, 642,
            'E-T2042' + FInst + ' Partners % exceeds expected by ' +
            FormatFloat('###0.0000', y - x) + '%');
        If x - y > 0.01 then // y< x then
          SaveDiagnostic(RetNo, 'T2042' + FInst, 642,
            'E-T2042' + FInst + ' Partners % less than expected by ' +
            FormatFloat('###0.0000', x - y) + '%');
      end;

      j := 646; // 20120324
      Repeat
        If UpperCase(FetchElmFNo(RetNo, Fno, 68)) <> 'Y' then // 20121224
        Begin
          If Vl(FetchElmFNo(RetNo, Fno, j)) > 0 then
          begin
            If (FetchElmFNo(RetNo, Fno, j - 2) = '') or
              (FetchElmFNo(RetNo, Fno, j + 1) = '') then
            Begin
              SaveDiagnostic(RetNo, 'T2042' + FInst, j - 2,
                'E-T2042' + FInst +
                ' Enter full partner information and address');
              SaveDiagnostic(RetNo, 'T2042' + FInst, j + 1,
                'E-T2042' + FInst +
                ' Enter full partner information and address');
            end;
          end;
        End;
        Inc(j, 4);
      until j > 662;

    end; // Fno>0 for t2042

    // Fishing
    Fno := GetFormNo('T2121' + FInst);
    If Fno > 0 then // 20101219
    begin
      If (Ret[RetNo].FrmHasData[Fno]) and
        (FetchElmFNo(RetNo, Fno, 4) <> AppYear + '-01-01') then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 4,
          'W-T2121' + FInst + ' Short fiscal periods or non-calendar year');
      If (Ret[RetNo].FrmHasData[Fno]) and
        (FetchElmFNo(RetNo, Fno, 5) <> AppYear + '-12-31') then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 5,
          'W-T2121' + FInst + ' Short fiscal periods or non-calendar year');

      If (Ret[RetNo].FrmHasData[Fno]) and // 20120203
        (FetchElmFNo(RetNo, Fno, 8) = '') then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 8,
          'E-T2121' + FInst + ' Enter Boat Name');
      // 20101206
      If (Ret[RetNo].FrmHasData[Fno]) and (FetchElmFNo(RetNo, Fno, 15) > '')
      then
      begin
        If Length(FetchElmFNo(RetNo, Fno, 15)) <> 15 then
          SaveDiagnostic(RetNo, 'T2121' + FInst, 15,
            'E-T2121' + FInst + ' Account number must be 15 characters');
      end;

      // 20180204
      If (Ret[RetNo].FrmHasData[Fno]) and
        (Length(FetchElmFNo(RetNo, Fno, 61)) = 0) then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 61,
          'E-T2121' + FInst + ' Address incomplete');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (Length(FetchElmFNo(RetNo, Fno, 89)) = 0) then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 89,
          'E-T2121' + FInst + ' Address incomplete');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (Length(FetchElmFNo(RetNo, Fno, 75)) = 0) then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 75,
          'E-T2121' + FInst + ' Address incomplete');

      // 20130129
      If (Ret[RetNo].FrmHasData[Fno]) and (Vl(FetchElmFNo(RetNo, Fno, 35)) = 0)
        and (Vl(FetchElmFNo(RetNo, Fno, 74)) = 0) then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 35,
          'E-T2121' + FInst + ' Statement has Zero in both Gross and Net');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (ValidTaxShelterNo(FetchElmFNo(RetNo, Fno, 14)) = false) then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 14,
          'E-T2121' + FInst + ' Invalid TaxShelter (Format AAnnnn)');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (ValidPartnershipNo(FetchElmFNo(RetNo, Fno, 12)) = false) then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 12,
          'E-T2121' + FInst +
          ' Invalid Partnership Number (Format 9 numerics)');

      If (Ret[RetNo].FrmHasData[Fno]) and
        (InvalidNaics(FetchElmFNo(RetNo, Fno, 11)) = True) // 20141007
      // (Length(FetchElmFNo(RetNo,FNo,11)) <6)
      then
        SaveDiagnostic(RetNo, 'T2121' + FInst, 11, 'E-T2121' + FInst + ' '
          + ErrMsg);
      If (Ret[RetNo].FrmHasData[GetFormNo('T2121' + FInst)]) then // cca
      begin
        j := 137;
        Repeat
          If IsValidCCA(FetchElmFNo(RetNo, Fno, j)) = false then // 20101020
            SaveDiagnostic(RetNo, 'T2121' + FInst, j,
              'E-T2121' + FInst + ' CCA class is invalid');
          Inc(j, 10);
        until j > 207;
      end;

      If Vl(FetchElmFNo(RetNo, Fno, 218)) <> 0 then // 20101020
      begin
        If UpperCase(FetchElmFNo(RetNo, AssetsFNo, 10)) <> 'Y' then
          SaveDiagnostic(RetNo, 'CCALIST', 0,
            'E-CCA-Assets not entered on the Assets forms');
      end;
      // T2121 partners
      If Ret[RetNo].FrmHasData[Fno] then // 20101020
      begin
        x := 100 - Vl(FetchElmFNo(RetNo, Fno, 18));
        y := Vl(FetchElmFNo(RetNo, Fno, 547)); // 20101216  it was 504
        If y - x > 0.01 then
          SaveDiagnostic(RetNo, 'T2121' + FInst, 547,
            'E-T2121' + FInst + ' Partners % exceeds expected by ' +
            FormatFloat('###0.0000', y - x) + '%');
        If x - y > 0.01 then // 20120227
          SaveDiagnostic(RetNo, 'T2121' + FInst, 547,
            'E-T2121' + FInst + ' Partners % less than expected by ' +
            FormatFloat('###0.0000', x - y) + '%');
      end;

      j := 509; // 20120324
      Repeat
        If Vl(FetchElmFNo(RetNo, Fno, j)) > 0 then
        begin
          If (FetchElmFNo(RetNo, Fno, j - 2) = '') or
            (FetchElmFNo(RetNo, Fno, j + 1) = '') then
          Begin
            SaveDiagnostic(RetNo, 'T2121' + FInst, j - 2,
              'E-T2121' + FInst +
              ' Enter full partner information and address');
            SaveDiagnostic(RetNo, 'T2121' + FInst, j + 1,
              'E-T2121' + FInst +
              ' Enter full partner information and address');
          end;
        end;
        Inc(j, 4);
      until j > 521;

    end; // FNo>0 for T2121

    // T1163
    Fno := GetFormNo('T1163' + FInst);
    If Fno > 0 then // 20101219
    Begin
      If Ret[RetNo].FrmHasData[Fno] then
      begin
        If FetchElmFNo(RetNo, Fno, 201) = '' then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 201,
            'E-T1163' + FInst + ' Farm Name required');
        If FetchElmFNo(RetNo, Fno, 203) = '' then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 203,
            'E-T1163' + FInst + ' Address required');
        If FetchElmFNo(RetNo, Fno, 204) = '' then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 204,
            'E-T1163' + FInst + ' City required');
        If FetchElmFNo(RetNo, Fno, 205) = '' then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 205,
            'E-T1163' + FInst + ' Province required');
        If FetchElmFNo(RetNo, Fno, 206) = '' then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 206,
            'E-T1163' + FInst + ' Postal code required');
        // 20110507
        If (Vl(FetchElmFNo(RetNo, Fno, 632)) > 0) and
          (FetchElmFNo(RetNo, Fno, 634) = '') then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 634,
            'E-T11163' + FInst + ' Partner PIN required (or 00000000)');
        If (Vl(FetchElmFNo(RetNo, Fno, 637)) > 0) and
          (FetchElmFNo(RetNo, Fno, 639) = '') then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 639,
            'E-T1163' + FInst + ' Partner PIN required (or 00000000)');
        If (Vl(FetchElmFNo(RetNo, Fno, 642)) > 0) and
          (FetchElmFNo(RetNo, Fno, 644) = '') then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 644,
            'E-T1163' + FInst + ' Partner PIN required (or 00000000)');
        If (Vl(FetchElmFNo(RetNo, Fno, 647)) > 0) and
          (FetchElmFNo(RetNo, Fno, 649) = '') then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 649,
            'E-T1163' + FInst + ' Partner PIN required (or 00000000)');
        If (Vl(FetchElmFNo(RetNo, Fno, 652)) > 0) and
          (FetchElmFNo(RetNo, Fno, 654) = '') then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 654,
            'E-T1163' + FInst + ' Partner PIN required (or 00000000)');
        If (Vl(FetchElmFNo(RetNo, Fno, 657)) > 0) and
          (FetchElmFNo(RetNo, Fno, 659) = '') then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 659,
            'E-T1163' + FInst + ' Partner PIN required (or 00000000)');

        x := Vl(FetchElmFNo(RetNo, Fno, 619));
        If x > 100 then
          SaveDiagnostic(RetNo, 'T1163' + FInst, 632,
            'E-T1163' + FInst + ' Total partners % exceeds 100%');

        If x < 100 then // 20120227
        Begin
          If Vl(FetchElmFNo(RetNo, Fno, 210)) < 100 then // 20120222
            SaveDiagnostic(RetNo, 'T1163' + FInst, 632,
              'E-T1163' + FInst + ' Total partners % less than 100%');
        end;

        If ValidEMail(FetchElmFNo(RetNo, Fno, 4)) = false then // 20190117
          SaveDiagnostic(RetNo, 'T1163' + FInst, 4,
            'E-T1163-Email is incorrect')

      end; // has data

      j := 637; // 20120324
      Repeat
        If (Vl(FetchElmFNo(RetNo, Fno, j)) > 0) and
          (FetchElmFNo(RetNo, Fno, k) = '') then
        begin
          If (FetchElmFNo(RetNo, Fno, j - 2) = '') or
            (FetchElmFNo(RetNo, Fno, j - 1) = '') then
          Begin
            SaveDiagnostic(RetNo, 'T1163' + FInst, j - 2,
              'E-T1163' + FInst + ' Enter full partner information');
            SaveDiagnostic(RetNo, 'T1163' + FInst, j - 1,
              'E-T1163' + FInst + ' Enter full partner information');
          end;
        end;
        Inc(j, 5); // Inc(j,4);   //20131226
      until j > 647; // 20131226

      // 20131226
      If (Vl(FetchElmFNo(RetNo, Fno, 652)) > 0) and
        (FetchElmFNo(RetNo, Fno, 660) = '') then
      begin
        If (FetchElmFNo(RetNo, Fno, 650) = '') or
          (FetchElmFNo(RetNo, Fno, 651) = '') then
        Begin
          SaveDiagnostic(RetNo, 'T1163' + FInst, 650,
            'E-T1163' + FInst + ' Enter full partner information');
          SaveDiagnostic(RetNo, 'T1163' + FInst, 651,
            'E-T1163' + FInst + ' Enter full partner information');
        end;
      end;

      If (Vl(FetchElmFNo(RetNo, Fno, 657)) > 0) and
        (FetchElmFNo(RetNo, Fno, 661) = '') then
      begin
        If (FetchElmFNo(RetNo, Fno, 655) = '') or
          (FetchElmFNo(RetNo, Fno, 654) = '') then
        Begin
          SaveDiagnostic(RetNo, 'T1163' + FInst, 655,
            'E-T1163' + FInst + ' Enter full partner information');
          SaveDiagnostic(RetNo, 'T1163' + FInst, 656,
            'E-T1163' + FInst + ' Enter full partner information');
        end;
      end;

    end; // t1163

    // T1273 partners
    Fno := GetFormNo('T1273' + FInst);
    If Fno > 0 then // 20101219
    Begin
      If Ret[RetNo].FrmHasData[Fno] then // 20101020
      begin
        // 20160128
        j := 41;
        If Not ValidPin(FetchElmFNo(RetNo, Fno, j)) then
          SaveDiagnostic(RetNo, 'T1273' + FInst, j,
            'E-T1273' + FInst + ' Invalid Pin Number');
        For j := 52 to 54 do
        Begin
          If Not ValidPin(FetchElmFNo(RetNo, Fno, j)) then
            SaveDiagnostic(RetNo, 'T1273' + FInst, j,
              'E-T1273' + FInst + ' Invalid Pin Number');
        end;

        If ValidEMail(FetchElmFNo(RetNo, Fno, 3)) = false then // 20190117
          SaveDiagnostic(RetNo, 'T1273' + FInst, 3,
            'E-T1273-Email is incorrect');

        // 20110507
        If (Vl(FetchElmFNo(RetNo, Fno, 632)) > 0) and
          (FetchElmFNo(RetNo, Fno, 634) = '') then
          SaveDiagnostic(RetNo, 'T1273' + FInst, 634,
            'E-T1273' + FInst + ' Partner PIN required (or 00000000)');
        If (Vl(FetchElmFNo(RetNo, Fno, 637)) > 0) and
          (FetchElmFNo(RetNo, Fno, 639) = '') then
          SaveDiagnostic(RetNo, 'T1273' + FInst, 639,
            'E-T1273' + FInst + ' Partner PIN required (or 00000000)');
        If (Vl(FetchElmFNo(RetNo, Fno, 642)) > 0) and
          (FetchElmFNo(RetNo, Fno, 644) = '') then
          SaveDiagnostic(RetNo, 'T1273' + FInst, 644,
            'E-T1273' + FInst + ' Partner PIN required (or 00000000)');
        If (Vl(FetchElmFNo(RetNo, Fno, 647)) > 0) and
          (FetchElmFNo(RetNo, Fno, 649) = '') then
          SaveDiagnostic(RetNo, 'T1273' + FInst, 649,
            'E-T1273' + FInst + ' Partner PIN required (or 00000000)');
        If (Vl(FetchElmFNo(RetNo, Fno, 652)) > 0) and
          (FetchElmFNo(RetNo, Fno, 654) = '') then
          SaveDiagnostic(RetNo, 'T1273' + FInst, 654,
            'E-T1273' + FInst + ' Partner PIN required (or 00000000)');
        x := Vl(FetchElmFNo(RetNo, Fno, 659)); // 20101020
        If x > 100 then
          SaveDiagnostic(RetNo, 'T1273' + FInst, 632,
            'E-T1273' + FInst + ' Total partners % exceeds 100%');
        If (x < 100) and (Vl(FetchElmFNo(RetNo, Fno, 210)) < 100) // 20120222
        then
          SaveDiagnostic(RetNo, 'T1273' + FInst, 632,
            'E-T1273' + FInst + ' Total partners % less than 100%');
      end;

      j := 632; // 20120324
      Repeat
        If Vl(FetchElmFNo(RetNo, Fno, j)) > 0 then
        begin
          // 20140316
          If (FetchElmFNo(RetNo, Fno, j + 2) = '') then
            SaveDiagnostic(RetNo, 'T1273' + FInst, j + 2,
              'E-T1273' + FInst + ' Enter PIN Number');
          If FetchElmFNo(RetNo, Fno, j - 2) = '' then // First nm
          Begin
            If FetchElmFNo(RetNo, Fno, j + 1) = '' then // no corp nm
              SaveDiagnostic(RetNo, 'T1273' + FInst, j - 2,
                'E-T1273' + FInst + ' Enter First Name');
          end;
          If FetchElmFNo(RetNo, Fno, j - 1) = '' then // Last nm
          Begin
            If FetchElmFNo(RetNo, Fno, j + 1) = '' then // no corp nm
              SaveDiagnostic(RetNo, 'T1273' + FInst, j - 1,
                'E-T1273' + FInst + ' Enter Last Name');
          end;

        end;
        Inc(j, 5);
      until j > 652;
      // end;  //t1273

    end; // FNo>0
  end; // i 1 to 5 statements

  // -----------------------------------------------------------------
  ErrMsg := '';
  For i := 1 to 5 do // free standing CCA
  begin
    FInst := '#' + AllTrim(IntToStr(i));
    Fno := GetFormNo('CCAMULT' + FInst);
    If Fno > 0 then
    Begin
      If (Ret[RetNo].FrmHasData[Fno]) then // cca
      begin
        j := 1;
        Repeat
          If IsValidCCA(FetchElmFNo(RetNo, Fno, j)) = false then
            SaveDiagnostic(RetNo, 'CCAMULT' + FInst, j,
              'E-CCA class is invalid');
          Inc(j, 10);
        until j > 71;
      end;
    end;
  end;

  For i := 1 to 5 do // CAIS
  begin
    FInst := '#' + AllTrim(IntToStr(i));
    Fno := GetFormNo('T1175' + FInst);
    If Fno > 0 then
    begin
      // 20110420 If Vl(FetchElmFNo(RetNo,FNo,215))>0 then SaveDiagnostic(RetNo,'T1175'+FInst,215,'W-T1175-Terminal loss. Claim in T1163');

      If (Ret[RetNo].FrmHasData[Fno]) then // cca
      begin
        j := 1;
        Repeat
          If IsValidCCA(FetchElmFNo(RetNo, Fno, j)) = false then
            SaveDiagnostic(RetNo, 'T1175' + FInst, j,
              'E-T1175-CCA class is invalid');
          Inc(j, 10);
        until j > 71;
      end;
    end;
  end;

  For i := 1 to 5 do // CAIS
  begin
    FInst := '#' + AllTrim(IntToStr(i));
    Fno := GetFormNo('T1175H' + FInst);
    If Fno > 0 then // 20101219
    Begin
      // 20110505 If Vl(FetchElmFNo(RetNo,FNo,215))>0 then SaveDiagnostic(RetNo,'T1175H'+FInst,215,'W-T1175H-Terminal loss. Claim in T1273');
      If (Ret[RetNo].FrmHasData[Fno]) then // cca
      begin
        j := 1;
        Repeat
          If IsValidCCA(FetchElmFNo(RetNo, Fno, j)) = false then
            SaveDiagnostic(RetNo, 'T1175H' + FInst, j,
              'E-T1175H-CCA class is invalid');
          Inc(j, 10);
        until j > 71;
      end;
    end;
  end; // i

  // ???? s/b above
  // T1163
  Fno := GetFormNo('T1163#1');
  FInst := ExtractFormInst('T1163#1');
  If FetchElmFNo(RetNo, Fno, 23) > '' then
  begin
    For j := 10 to 17 do
    Begin
      If FetchElmFNo(RetNo, Fno, j) = '' then
        SaveDiagnostic(RetNo, 'T1163#1', j,
          'W-T1163: Enter Contact information'); // 20131226
    end;
  end;
  If (Ret[RetNo].FrmHasData[Fno]) and
    (InvalidNaics(FetchElmFNo(RetNo, Fno, 34)) = True) // 20141007
  // (Length(FetchElm(RetNo,'T1163#1',34)) <6)
  then
    SaveDiagnostic(RetNo, 'T1163#1', 34, 'E-T1163-NAICS code is invalid');
  If (Ret[RetNo].FrmHasData[Fno]) and (FetchElm(RetNo, 'T1163#1', 15) > '') and
    (ValidPostal(RetNo, FetchElm(RetNo, 'T1163#1', 15)) = false) then
    SaveDiagnostic(RetNo, 'T1163#1', 15, 'E-T1163 Invalid Postal');
  If (Ret[RetNo].FrmHasData[Fno]) and (Length(FetchElmFNo(RetNo, Fno, 20)) < 8)
  then
    SaveDiagnostic(RetNo, 'T1163#1', 20,
      'W-T1163 PIN number must be 8 characters');
  If (FetchElmFNo(RetNo, Fno, 206) > '') and
    (ValidPostal(RetNo, FetchElmFNo(RetNo, Fno, 206)) = false) then
    SaveDiagnostic(RetNo, 'T1163#1', 206, 'E-T1163 Invalid Postal code');

  If (Ret[RetNo].FrmHasData[Fno]) and
    (ValidPartnershipNo(FetchElmFNo(RetNo, Fno, 624)) = false) then
    SaveDiagnostic(RetNo, 'T1163' + FInst, 624,
      'E-T1163' + FInst + ' Invalid Partnership Number (Format 9 numerics)');

  // t1273
  Fno := GetFormNo('T1273#1');
  FInst := ExtractFormInst('T1273#1');
  If Fno > 0 then // 20101219
  Begin
    // 20110320
    If (Ret[RetNo].FrmHasData[Fno]) then
    begin
      If FetchElmFNo(RetNo, Fno, 64) > '' then
      begin
        If FetchElmFNo(RetNo, Fno, 50) + FetchElmFNo(RetNo, Fno, 51) = '' then
          SaveDiagnostic(RetNo, 'T1273#1', 50,
            'E-T1273#1: Enter COB to contact (Yes or No)');
        For j := 10 to 17 do
        Begin
          If FetchElmFNo(RetNo, Fno, j) = '' then
            SaveDiagnostic(RetNo, 'T1273#1', j,
              'E-T1273: Enter Contact information');
        end;
      end;
      If (Length(FetchElmFNo(RetNo, Fno, 20)) < 8) then
        SaveDiagnostic(RetNo, 'T1273#1', 20,
          'W-T1273 PIN number must be 8 characters');
      If (FetchElmFNo(RetNo, Fno, 15) > '') and
        (ValidPostal(RetNo, FetchElmFNo(RetNo, Fno, 15)) = false) then
        SaveDiagnostic(RetNo, 'T1273#1', 15, 'E-T1273 Invalid Postal');
      If AllTrim(FetchElmFNo(RetNo, Fno, 27)) = '' then // 20120222
        SaveDiagnostic(RetNo, 'T1273#1', 27, 'W-T1273 District required');

      If (FetchElmFNo(RetNo, Fno, 32) = 'MB') then
      begin
        If (FetchElmFNo(RetNo, Fno, 29) + FetchElmFNo(RetNo, Fno, 30) +
          FetchElmFNo(RetNo, Fno, 31) + FetchElmFNo(RetNo, Fno, 37) +
          FetchElmFNo(RetNo, Fno, 38) = '') then
          SaveDiagnostic(RetNo, 'T1273#1', 29,
            'W-T1273 Legal description required');
        For j := 29 to 31 do // 20120309
        begin
          If FetchElmFNo(RetNo, Fno, j) > '' then
          begin
            If Length(FetchElmFNo(RetNo, Fno, j)) <> 2 then
              SaveDiagnostic(RetNo, 'T1273#1', j,
                'E-T1273 Legal land must be 2 characters');
          end;
        end;

        For j := 37 to 38 do // 20120309
        begin
          If FetchElmFNo(RetNo, Fno, j) > '' then
          begin
            If Length(FetchElmFNo(RetNo, Fno, j)) <> 2 then
              SaveDiagnostic(RetNo, 'T1273#1', j,
                'E-T1273 Legal land must be 2 characters');
          end;
        end;

      end;

      If FetchElmFNo(RetNo, Fno, 204) = '' then
        SaveDiagnostic(RetNo, 'T1273#1', 204, 'E-T1273 Enter Street on Page 3');
    end;
  end;

  If FetchElm(RetNo, 'T1273#1', 206) > '' then
  begin
    If ValidPostal(RetNo, FetchElm(RetNo, 'T1273#1', 206)) = false then
      SaveDiagnostic(RetNo, 'T1273#1', 206, 'E-T1273 Invalid Postal Code');
  end;
  If (Ret[RetNo].FrmHasData[Fno]) and
    (ValidPartnershipNo(FetchElmFNo(RetNo, Fno, 624)) = false) then
    SaveDiagnostic(RetNo, 'T1273' + FInst, 624,
      'E-T1273' + FInst + ' Invalid Partnership Number (Format 9 numerics)');


  //---------------------------
  //Fno := GetFormNo('T2043'); //20220614
  //If Vl(FetchElmFNo(RetNo, Fno,2))<25000 then SaveDiagnostic(RetNo, 'T2043',2,'E-T2043-Farming expenses must be $25,000 or more to claim this credit');

  {
  if (Vl(FetchElmFNo(RetNo, Fno,2)) >0)  //there is credit
  and (Vl(RetNo,'T2043A#1',58))+Vl(RetNo,'T2043A#1',59))+Vl(RetNo,'T2043A#1',60))+Vl(RetNo,'T2043A#1',67)) then //but no income reported
    SaveDiagnostic(RetNo, 'T2043',58,'E-T2043-'+The credit $'+FetchElmFNo(RetNo, Fno,2)
      +' must entered as income on the corresponding Statement(s)');
    }
  //----------------
  Fno := GetFormNo('T2222');
  If (Ret[RetNo].FrmHasData[Fno]) then
  begin
    // 20180210
    If Ret[RetNo].T4NorthA + Ret[RetNo].T4ANorthA + Ret[RetNo].T4NorthB +
      Ret[RetNo].T4ANorthB > 0 then
    begin
      if Vl(FetchElmFNo(RetNo, Fno, 6)) + Vl(FetchElmFNo(RetNo, Fno, 14)) = 0
      then // no deductionclaimed
      Begin
        SaveDiagnostic(RetNo, 'T2222', 6,
          'W-T2222-Board and Lodging in T4 or T4A. Please check and enter deduction if applicable');
        SaveDiagnostic(RetNo, 'T2222', 14,
          'W-T2222-Board and Lodging in T4 or T4A. Please check and enter deduction if applicable');
      End;
    end;
    // -------------

    If (MyStrToInt(FetchElmFNo(RetNo, Fno, 1)) + MyStrToInt(FetchElmFNo(RetNo,
      Fno, 9)) > 365) and (IsLeapYear(StrToInt(AppYear)) = false) then
      // 20130205
      SaveDiagnostic(RetNo, 'T2222', 1,
        'E-T2222-Total days in zones A and B exceed 365 days');

    If (MyStrToInt(FetchElmFNo(RetNo, Fno, 1)) + MyStrToInt(FetchElmFNo(RetNo,
      Fno, 9)) > 366) and (IsLeapYear(StrToInt(AppYear)) = True) then
      // 20130205
      SaveDiagnostic(RetNo, 'T2222', 1,
        'E-T2222-Total days in zones A and B exceed 366 days');

    If (FetchElmFNo(RetNo, Fno, 22) > '') and (FetchElmFNo(RetNo, Fno, 23) > '')
    then
    begin
      Dt1 := YMDtoDate(FetchElmFNo(RetNo, Fno, 22));
      Dt2 := YMDtoDate(FetchElmFNo(RetNo, Fno, 23));
      If DateDiff(Dt1, Dt2) + 1 < 183 then // 20120131
        SaveDiagnostic(RetNo, 'T2222', 22,
          'W-T2222-Less than 6 consecutive months');
    end;
    i := 43;
    Repeat
      If (FetchElmFNo(RetNo, Fno, i) > '') and
        (FetchElmFNo(RetNo, Fno, i + 1) > '') then
      begin
        Dt1 := YMDtoDate(FetchElmFNo(RetNo, Fno, i));
        Dt2 := YMDtoDate(FetchElmFNo(RetNo, Fno, i + 1));
        If DateDiff(Dt1, Dt2) + 1 < 183 then // 20120131
          SaveDiagnostic(RetNo, 'T2222', i,
            'W-T2222-Less than 6 consecutive months');
      end;
      Inc(i, 5);
    until i > 58;
    i := 113; // 20120130
    Repeat
      If Vl(FetchElmFNo(RetNo, Fno, i)) + Vl(FetchElmFNo(RetNo, Fno, i + 1)) +
        Vl(FetchElmFNo(RetNo, Fno, i + 3)) > 0 then
      begin
        If FetchElmFNo(RetNo, Fno, i - 2) = '' then
          SaveDiagnostic(RetNo, 'T2222', i - 2, 'E-T2222-Zone required');
      end;
      Inc(i, 8);
    until i > 265;
  end; // has data

  If Ret[RetNo].Lnn[33099] > 0 then
  begin
    If Vl(FetchElm(RetNo, 'T1', 41)) < Vl(FetchElm(RetNo, 'T1', 42)) then  //20191220
      SaveDiagnostic(RetNo, 'MEDICAL', 112,
        'W-Medical cannot be claimed. Expenses less than 3% of NI');
  end;

  {//20260228  ..difficult to dermine / enforce  needed for certif only?
  If ((Ret[RetNo].Lnn[22100] >= 1) or (Ret[RetNo].Lnn[23200] >= 1)) and
    (Vl(FetchElm(RetNo, 'T691', 10)) = 0) then
  begin
    If Ret[RetNo].Lnn[22100] + Ret[RetNo].Lnn[23200] >
      Vl(FetchElm(RetNo, 'OTHDED', 60)) then
      SaveDiagnostic(RetNo, 'T691', 8,
        'W-T691-Ln 221/232 claimed. Check or enter $1 in Ln 2');
  end;
  }

  If (Ret[RetNo].Lnn[22400] > 0) and (Vl(FetchElm(RetNo, 'T691', 18)) = 0) then
    SaveDiagnostic(RetNo, 'T691', 18,
      'W-T691-Expl exp on Ln 224. Check or enter $1 in Ln 12');

  //20250129
  If (Ret[RetNo].Lnn[24900] > 0) then
  Begin
   If (Vl(FetchElm(RetNo, 'T691', 35)) = 0) and (Vl(FetchElm(RetNo, 'T691', 24)) = 0)
   then
    SaveDiagnostic(RetNo, 'T691', 24,'W-T691-Ensure you allocate any securities to the proper period if applicable');
  end;

  If (Ret[RetNo].Lnn[30300] > 0) and (Ret[RetNo].Lnn[30400] > 0) then  //201200103 not 30425
    SaveDiagnostic(RetNo, 'DEPEND', 19,
      'E-Spouse/Eligible dependant-Both claimed');

  Fno := GetFormNo('MB479');
  If ((Vl(FetchElmFNo(RetNo, Fno, 151)) > 0) // owner prop taxes
    and (Vl(FetchElmFNo(RetNo, Fno, 134)) = 0) // school taxes
    and (Vl(FetchElmFNo(RetNo, Fno, 44)) < 23800))
  // family income    //20170410
  then
    SaveDiagnostic(RetNo, 'MB479', 134, 'W-MB Any school taxes paid?');

  If Ret[RetNo].Province = 'MB' then // 20101223
  begin
    If ((Ret[RetNo].Age >= 19) or (Ret[RetNo].MarStatus < 3)) and
      (FetchElmFNo(RetNo, Fno, 50) = 'N') and (Ret[RetNo].CouplingSw = false)
    then
      SaveDiagnostic(RetNo, 'MB479', 50,
        'W-MB479 claim for Personal Tax credit was set to No');

    If Vl(FetchElm(RetNo, 'T1005', 13)) > 0 then
      SaveDiagnostic(RetNo, 'T1005', 13,
        'W-MB-T1005: Verify amounts as form has been changed this year');

  end;

  {
  If ((Vl(FetchElm(RetNo, 'MB428', 70)) > 0) // line 6086
    and (Vl(FetchElm(RetNo, 'MB479', 80)) > 0)) // Line 6145
  then
    SaveDiagnostic(RetNo, 'MB479', 80,
      'E-MB479 Ln 6145 not allowed if Ln 6086 claimed on MB428');
  }
  (* 20101213
    If (Ret[RetNo].Age<19) and (Ret[RetNo].MarStatus>2) //not married
    then
    begin
    If Vl(FetchElm(RetNo,'MB479',4))>0 then {pers tax credit claimed}
    SaveDiagnostic(RetNo,'MB479',50,'W-MB Personal credit claimed for age under 19. Review');
    end;
  *)
  //20250309
  If Ret[RetNo].Lnn[44800] > 2 then
  begin
    SaveDiagnostic(RetNo, 'T4#1', 3, 'W-CPP OVERPAYMENT of ' + '$' +
      FormatFloat('###,###.##', Ret[RetNo].Lnn[44800]) + ' was calculated. Please review T4 slip(s) if entered incorrectly');

    SaveDiagnostic(RetNo, 'T4#1', 3, 'W-  (Note: Overpayment is not allowed if filed after 4 years)');

  end;

  //20250309
  If Ret[RetNo].Lnn[45000] > 2 then
  begin
    SaveDiagnostic(RetNo, 'T4#1', 5, 'W-EI OVERPAYMENT of ' +'$' +
       FormatFloat('###,###.##', Ret[RetNo].Lnn[45000]) + ' calculated. Please review T4 slip(s) if entered incorrectly');

    SaveDiagnostic(RetNo, 'T4#1', 5, 'W-  (Note: Overpayment is not allowed if filed after 3 years)');
  end;

  If (ThereIsNetCapLossThisYear(RetNo)) and
    (not NetCapLossCarryBackClaimed(RetNo)) then
  begin
    //SaveDiagnostic(RetNo, 'T1A', 119,
     SaveDiagnostic(RetNo, 'T1A', 121,
      'T-T1A - Consider carrying back the Net Capital losss');
  end;

  If IsDeceased(RetNo) then
  begin
    If Ret[RetNo].Lnn[12700] < 0 then
      SaveDiagnostic(RetNo, 'T1', 216,
        'T-Deceased: Cap loss allowed this year');
  end;

  If (IsDeceased(RetNo)) and (Ret[RetNo].FrmHasData[GetFormNo('TX19')] = false)
  then
    SaveDiagnostic(RetNo, 'TX19', 24,
      'T-Deceased: You may need TX19 if not filing a T3 return');
  If (IsDeceased(RetNo)) then
    SaveDiagnostic(RetNo, 'Tip', 1,
      'T-Deceased: Consider Rights and Things return');

  If (IsDeceased(RetNo)) and (FetchElm(RetNo, 'DEATH', 31) = '') then
    SaveDiagnostic(RetNo, 'DEATH', 31,
      'W-Deceased: Review Deceased Worksheet/Enter X');

  If (Ret[RetNo].Lnn[12600] < 0) then
  begin
    If Vl(FetchElm(RetNo, 'T691', 40)) = 0 then
      SaveDiagnostic(RetNo, 'T691', 38,
        'W-T691-Rental Loss. Check or enter $1');
  end;

  If Ret[RetNo].Lnn[13000] < 0 then
    SaveDiagnostic(RetNo, 'OTHINC', 25,
      'W-Line 130 is expected to be positive only');
  If (Ret[RetNo].Age < 18) and (Ret[RetNo].Lnn[12000] > 0) and
    (SplitIncome(RetNo) = false) then
  begin
    SaveDiagnostic(RetNo, 'T1206', 16, 'W-T1206-?Split Income?');
  end;

  If (Ret[RetNo].Lnn[12600] <> 0) and (Ret[RetNo].Lnn[12599] = 0) then
    SaveDiagnostic(RetNo, 'T1', 214,
      'W-Rental statement has 0 gross income. Check or enter $1');

  If (Ret[RetNo].Lnn[13500] <> 0) and (Ret[RetNo].Lnn[13499] = 0) then
    SaveDiagnostic(RetNo, 'T1', 221,
      'W-Business statement has 0 gross income Check or enter $1');

  If (Ret[RetNo].Lnn[13700] <> 0) and (Ret[RetNo].Lnn[13699] = 0) then
    SaveDiagnostic(RetNo, 'T1', 223,
      'W-Prof. statement has 0 gross income. Check or enter $1');

  If (Ret[RetNo].Lnn[13900] <> 0) and (Ret[RetNo].Lnn[13899] = 0) then
    SaveDiagnostic(RetNo, 'T1', 225,
      'W-Commission statement has 0 gross income. Check or enter $1');

  If (Ret[RetNo].Lnn[14100] <> 0) and (Ret[RetNo].Lnn[14099] = 0) then
    SaveDiagnostic(RetNo, 'T1', 227,
      'W-Farming statement has 0 gross income. Check or enter $1');

  If (Ret[RetNo].Lnn[14300] <> 0) and (Ret[RetNo].Lnn[14299] = 0) then
    SaveDiagnostic(RetNo, 'T1', 229,
      'W-Fishing statement has 0 gross income. Check or enter $1');

  If Ret[RetNo].Province = 'PE' then
  begin
    If (Ret[RetNo].Lnn[31220] > 0) and (Vl(FetchElm(RetNo, 'PE428', 86)) = 0) then
      SaveDiagnostic(RetNo, 'PE428', 86,
        'W-PE428:You may qualify for the $500 Firefighter Credit');
  end;

  Fno := GetFormNo('T4AOAS#1'); // 20091226
  If (Vl(FetchElmFNo(RetNo, Fno, 10)) > 0) or
    (Vl(FetchElmFNo(RetNo, Fno, 4)) > 0) then
  begin
    If Vl(FetchElmFNo(RetNo, Fno, 2)) = 0 then
      SaveDiagnostic(RetNo, 'T4AOAS#1', 2, 'W-T4AOAS:Box 18 may be missing');
  end;

  Fno := GetFormNo('T4AP#1');
  If (Vl(FetchElmFNo(RetNo, Fno, 4)) > 0) and
    (Vl(FetchElmFNo(RetNo, Fno, 11)) + Vl(FetchElmFNo(RetNo, Fno, 14)) +
    Vl(FetchElmFNo(RetNo, Fno, 13)) + Vl(FetchElmFNo(RetNo, Fno, 16)) +
    Vl(FetchElmFNo(RetNo, Fno, 15)) + Vl(FetchElmFNo(RetNo, Fno, 5)) = 0) then
    SaveDiagnostic(RetNo, 'T4AP#1', 11, 'E-T4AP:Box 14-19, amount needed');

  Fno := GetFormNo('DEPEND'); // 20101206
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    i := 14;
    Repeat
      If ((UpperCase(FetchElmFNo(RetNo, Fno, i)) > '') and
        (UpperCase(FetchElmFNo(RetNo, InfoFNo, 6)) <>
        UpperCase(FetchElmFNo(RetNo, Fno, i)))) or
        ((UpperCase(FetchElmFNo(RetNo, Fno, i + 1)) > '') and
        (UpperCase(FetchElmFNo(RetNo, InfoFNo, 10)) <>
        UpperCase(FetchElmFNo(RetNo, Fno, i + 1)))) or
        ((UpperCase(FetchElmFNo(RetNo, Fno, i + 3)) > '') and
        (UpperCase(FetchElmFNo(RetNo, InfoFNo, 14)) <>
        UpperCase(FetchElmFNo(RetNo, Fno, i + 3)))) or
        ((RemoveChar(UpperCase(FetchElmFNo(RetNo, Fno, i + 4)), ' ') > '') and
        (RemoveChar(UpperCase(FetchElmFNo(RetNo, InfoFNo, 15)), ' ') <>
        RemoveChar(UpperCase(FetchElmFNo(RetNo, Fno, i + 4)), ' '))) then
        SaveDiagnostic(RetNo, 'DEPEND', i, 'W-Address of ' +
          UpperCase(FetchElmFNo(RetNo, Fno, i - 9)) +
          ' different than parent(See DEPEND form)');
      Inc(i, 15);
    until i > 134;

    i := 5;
    Repeat
      If (FetchElmFNo(RetNo, Fno, i) > '') and
        (FetchElmFNo(RetNo, Fno, i + 2) > '') then // sin
      begin
        If not ValidSin(FetchElmFNo(RetNo, Fno, i + 2)) then
          SaveDiagnostic(RetNo, 'DEPEND', i + 2, 'E-Dependant SIN is invalid');
      end;
      Inc(i, 15);
    until i > 125;
  end; // depend

  // If (LeftStr(LicenseLevel,8) = 'T1 Multi')
  if (LicenseLevel in anyMulti) // 20160119 Igor
    and (ShowFinancialWarning = True) and
    (Vl(FetchElm(RetNo, 'FPCHECK', 35)) = 0) and
    (Vl(FetchElm(RetNo, 'FPCHECK', 36)) > 0) then
    SaveDiagnostic(RetNo, 'FPCHECK', 37,
      'W-FINANCIAL PLANNING ASSISTANCE may be required');

  // Super audit
  If MainForm.SuperAuditBox.Checked = True then
  begin
    LinesList := TStringList.Create;
    ValueList := TStringList.Create;
    Comp2YrList := TStringList.Create;

    GetPrevYearLinesFromYRSum(LinesList, ValueList);
    Comp2YrList.LoadFromFile(AppDir + '\' + 'Comp2Yr.d');
    If LastYearYSumAvailable(ValueList) then
    begin
      For i := 0 to LinesList.count - 1 do
      begin
        If (Vl(ValueList[i]) <> 0) and
          (Ret[RetNo].Lnn[MyStrToInt(LinesList[i])] = 0) then
        Begin
          k := LineIsInCompList(LinesList[i], Comp2YrList);
          If k > -1 then
          begin
            FrmNm := AllTrim(MidStr(Comp2YrList[k], 49, 10));
            If LinesList[i] = '47900' then //20190709 Igor
              FrmNm := WhichCreditForm(RetNo, Ret[RetNo].Province);
            SaveDiagnostic(RetNo, FrmNm,
              MyStrToInt(AllTrim(MidStr(Comp2YrList[k], 59, 5))),
              'S-L' + LinesList[i] + '-' + AllTrim(LeftStr(Comp2YrList[k], 40)
              ) + '...');
          end;
        end;
      end; // lineslist
    end // ysum available
    else
      SaveDiagnostic(RetNo, 'YRSUM', 1, 'S-?Last Year' + Chr(39) +
        's data not found-Form renamed or return not found'); // 20101210

    LinesList.Free;
    ValueList.Free;
    Comp2YrList.Free;
  end; // super audit

  { Review Marks }
  for i := 0 to (ReviewList.count - 1) do
  begin
    ReviewRec := ReviewList.Items[i];
    if (ReviewRec.RetNo = RetNo) then
      // SaveDiagnostic(RetNo,GetFormName(ReviewRec.FormNo),ReviewRec.FieldId,'R-RvMark'+' '+ GetFormName(ReviewRec.FormNo));
      SaveDiagnostic(RetNo, GetFormName(RetNo, ReviewRec.FormNo),
        ReviewRec.FieldId, 'R-RvMark' + ' ' + GetFormName(RetNo,
        ReviewRec.FormNo)); // 20160119 Igor
  end;

  { FldTapes/FLDMEM }
  for i := 0 to (FList.count - 1) do
  begin
    Frec := FList.Items[i];
    If Frec.FormName = 'FLDTAPE' then
    begin
      FrmNm := Frec.FormName + Frec.FormInst;
      If Ret[RetNo].FrmHasData[Frec.FormNo] = True then
      begin
        // 20101207
        If FetchElmFNo(RetNo, Frec.FormNo, 123) = '' then
          SaveDiagnostic(RetNo, FrmNm, 123, 'W-Tape' + '-' + FrmNm +
            'has amounts but is set to NO posting');

        SaveDiagnostic(RetNo, FrmNm, 126,
          'D-Tape' + ' ' + PaddR(FetchElm(RetNo, FrmNm, 121), 12) + ' ' +
          FetchElm(RetNo, FrmNm, 122));
      end;
    end;
    If Frec.FormName = 'FLDMEM' then
    begin
      FrmNm := Frec.FormName + Frec.FormInst;
      If Ret[RetNo].FrmHasData[Frec.FormNo] = True then
      begin
        SaveDiagnostic(RetNo, FrmNm, 17,
          'N-Note' + ' ' + PaddR(FetchElm(RetNo, FrmNm, 17), 12) + ' ' +
          FetchElm(RetNo, FrmNm, 18));
      end;
    end;
  end; { i }

  { EFile diagnostics }
  If IsEFiledReturn(RetNo) then
  begin
    { 20140112
      If (TotMultiple(RetNo,'T4',48)>0)
      and (FetchElm(RetNo,'EFMEMO',23) <> '371') then //20120413
      SaveDiagnostic(RetNo,'EFMEMO',23,'W-T4 with code 11. Enter 371 =1 or =Other Self-empl. income');
    }

    // 20170528
    If IsMultJurisdiction(RetNo) then
    begin
      // SaveDiagnostic(RetNo,'T2203',110,'F-T2203-You cannot currently Efile a Multi-jurisdiction return');
    end;

    // 20130312
    If (Ret[RetNo].Lnn[10100] + Ret[RetNo].Lnn[10400] + Ret[RetNo].Lnn[11300] +
      Ret[RetNo].Lnn[11400] + Ret[RetNo].Lnn[11500] + Ret[RetNo].Lnn[11900] +
      Ret[RetNo].Lnn[12900] = 0) and (Ret[RetNo].Lnn[13000] > 0) and
      (Ret[RetNo].Lnn[43700] > 0) // tax witheld
    then // 20121206
    begin
      If Vl(FetchElm(RetNo, 'EFMEMO', 2)) = 0 then
        SaveDiagnostic(RetNo, 'EFMEMO', 2,
          'W-EFMEMO-Inspect line 5345. You may need to report an amount');
    end;
    // 20100205
    If ((FetchElmFNo(RetNo, InfoFNo, 105) > '') or
      (FetchElmFNo(RetNo, InfoFNo, 134) > '')
      // or (FetchElmFNo(RetNo,InfoFNo,104)>'') or (FetchElmFNo(RetNo,InfoFNo,133)>''))   //20170405
      and (FetchElmFNo(RetNo, InfoFNo, 58) = '')) then
      SaveDiagnostic(RetNo, 'INFO', 58,
        'W-Preparer set as the Contact. Should allow representation');

    If FetchElmFNo(RetNo, InfoFNo, 8) > '' then // 20120209
    begin
      if Pos('&', FetchElmFNo(RetNo, InfoFNo, 8)) > 0 then
        SaveDiagnostic(RetNo, 'INFO', 8,
          'F-C/O line: Please remove/replace the & character');
    end;

    If (Ret[RetNo].Lnn[12200] <> 0) and (FetchElm(RetNo, 'EFMEMO', 42) = '') then
      SaveDiagnostic(RetNo, 'EFMEMO', 42,
        'F-Ln 122 income. Enter partnership type');

    If Ret[RetNo].Lnn[13000] < 0 then
      SaveDiagnostic(RetNo, 'OTHINC', 25, 'F-Line 130 is negative');


   { //20240412
    If (LeftStr(FetchElmFNo(RetNo, InfoFNo, 3), 2) = '09')
    // 20130105 //instead of 0
      or (LeftStr(FetchElmFNo(RetNo, InfoFNo, 3), 1) = '') then
      SaveEFileDiagnostic(RetNo, 'INFO', 3,
        'F-SIN starts with 09 or blank. It cannot be Efiled');
   }
    If IsBankruptcyReturn(RetNo) then
    begin
      If IsPreBankruptcyReturn(RetNo) = false then
        SaveEFileDiagnostic(RetNo, 'BANKRPT', 5,
          'F-Only Pre-Banckruptcy can be Efiled');
    end;

    (* //20120227
      FNo:=GetFormNo('T1163#1');
      If FetchElmFNo(RetNo,Fno,216)>'' then  //20120130
      begin
      If (Vl(FetchElmFNo(RetNo,FNo,305))>0) or (Vl(FetchElmFNo(RetNo,FNo,349))>0) then
      SaveEFileDiagnostic(RetNo,'T1163#1',216,'F-Return with Crop Share (Landlord) cannot be Efiled');
      end;
    *)
    Fno := GetFormNo('T1273#1');
    If FetchElmFNo(RetNo, Fno, 216) > '' then // 20120130
    begin
      If (Vl(FetchElmFNo(RetNo, Fno, 305)) > 0) or
        (Vl(FetchElmFNo(RetNo, Fno, 349)) > 0) then
        SaveEFileDiagnostic(RetNo, 'T1173#1', 216,
          'F-Return with Crop Share (Landlord) cannot be Efiled');
    end;

    If IsPreBankruptcyReturn(RetNo) = True then
    begin
      If Vl(FetchElm(RetNo, 'BANKRPT', 13)) = 0 then
        SaveEFileDiagnostic(RetNo, 'BANKRPT', 13,
          'E-Pre-bankruptcy return. Enter NI of Post bankruptcy ($1?)');

      If Ret[RetNo].FrmHasData[GetFormNo('T2222')] then
      begin
        If Vl(FetchElm(RetNo, 'T2222', 3)) > Vl(FetchElm(RetNo, 'BANKRPT', 2))
        then
          SaveEFileDiagnostic(RetNo, 'T2222', 3,
            'E-Pre-bankruptcy return. Days exceed pre-bankruptcy days');
        If Vl(FetchElm(RetNo, 'T2222', 11)) > Vl(FetchElm(RetNo, 'BANKRPT', 2))
        then
          SaveEFileDiagnostic(RetNo, 'T2222', 11,
            'E-Pre-bankruptcy return. Days exceed pre-bankruptcy days');
      end;
    end;

    If IsPostBankruptcyReturn(RetNo) = True then
    begin
      If Ret[RetNo].Province = 'ON' then
      begin
        If Vl(FetchElm(RetNo, 'BANKRPT', 18)) = 0 then
          SaveEFileDiagnostic(RetNo, 'BANKRPT', 18,
            'W-Post-bankruptcy return. Taxable income required ($1?)');
        If Vl(FetchElm(RetNo, 'BANKRPT', 17)) = 0 then
          SaveEFileDiagnostic(RetNo, 'BANKRPT', 17,
            'W-Post-bankruptcy return. Taxable income required ($1?)');
      end;
    end;

    If Ret[RetNo].Province = 'ZZ' then  //20240323
    Begin
      if (FetchElm(RetNo,InfoFNo,231)>'')
      Or (FetchElm(RetNo,InfoFNo,232)>'') then
         SaveEFileDiagnostic(RetNo, 'INFO', 1, 'F-Non residency types 6 or 7 cannot be Efiled');
    End;

    CountSfds(RetNo, RentSfds, BusSfds, ProfSfds, FarmSfds, FishSfds, NisaSfds,
      HCaisSfds, T777Sfds, TL2Sfds, T2091Sfds, T1255Sfds);

{   CountSFDS(RetNo:Integer; Var RentSfds:integer; Var BusSfds:Integer;Var ProfSfds:integer; Var FarmSfds:Integer;
     Var FishSfds:Integer; Var NisaSfds:Integer;
     Var HCaisSfds:Integer; Var T777Sfds:Integer;Var TL2Sfds:Integer;Var T2091Sfds:Integer;Var T1255Sfds:Integer);  //20210123
}


   //201210123
    If (RentSfds + BusSfds + ProfSfds + FarmSfds + FishSfds + NisaSfds
       +HCaisSfds+ T777Sfds+ TL2Sfds+ T2091Sfds+ T1255Sfds) > 12 then
      SaveEFileDiagnostic(RetNo, 'INFO', 2,'F-Self-Employment plus Rental PLus Other SFD statements exceed 12');

    (* //20260709  Use the new box below
    IF (Ret[RetNo].Age >= 65) and (Ret[RetNo].Lnn[11300] = 0) and
      (FetchElm(RetNo, 'EFMEMO', 8) <> '1') THEN
      SaveEFileDiagnostic(RetNo, 'EFMEMO', 8,
        'F-OAS-Confirm that indeed was not received');
    *)
     //20260709  Use the new box below
     IF (Ret[RetNo].Age >= 65) and (Ret[RetNo].Lnn[11300] = 0) and
     (FetchElm(RetNo, 'EFMEMO', 56) <> '1') THEN  //not 8 but 56 here and below //20260709
      SaveEFileDiagnostic(RetNo, 'EFMEMO', 56,
        'F-OAS-Confirm that indeed was not received');

    If (Ret[RetNo].FrmHasData[GetFormNo('T1163#1')]) and
      (UpperCase(FetchElmFNo(RetNo, InfoFNo, 46)) = 'Y') and
      (UpperCase(FetchElmFNo(RetNo, InfoFNo, 79)) = 'X') // proprietary
    then
      SaveEFileDiagnostic(RetNo, 'INFO', 79,
        'F-CAIS/NISA-Proprietary cannot be Efiled');

    { If FetchElmFNo(RetNo,InfoFNo,25)  //20131130
      +FetchElmFNo(RetNo,InfoFNo,26)
    }

    {
    If FetchElmFNo(RetNo, InfoFNo, 27) + FetchElmFNo(RetNo, InfoFNo, 28) > ''
    then
      SaveEFileDiagnostic(RetNo, 'INFO', 27,
        'F-Emigrant. Not eligible for EFILE');
    }
    // 20170413
    // If FetchElm(RetNo,'T2203',110) > '' then SaveEFileDiagnostic(RetNo,'T2203',110,'F-Multiple jurisdictions in effect');

    // If Ret[RetNo].FrmHasData[GetFormNo('T626#1')] then SaveEFileDiagnostic(RetNo,'T626#1',101,'F-T626 in effect');

    {//20260320
    If (Ret[RetNo].FrmHasData[GetFormNo('T1198')]) then
      SaveEFileDiagnostic(RetNo, 'T1198', 1, 'F-T1198 used');
    }

    Fno := GetFormNo('T183');
    If UpperCase(FetchElm(RetNo, 'EFMEMO', 9)) <> 'Y' then
    begin
      If Ret[RetNo].Province = 'QC' then
        SaveEFileDiagnostic(RetNo, 'EFMEMO', 9,
          'FW-EFMemo-Review Quebec related entries');

      If (FetchElm(RetNo, 'ON479', 116) > '') and
        (FetchElm(RetNo, 'ON479', 118) = '') then
        SaveEFileDiagnostic(RetNo, 'ON479', 118,
          'FW-ONCR-Enter Business Number in Ont Credits form');
    end;
  End; // efiled

  // COUPLING DIAGNOSTICS

  If (Ret[RetNo].CouplingSw) and (GetSpRetNo(RetNo) > 0) then
  begin
    SpRetNo := GetSpRetNo(RetNo);

    //20200903
    If HasDeceasedSpouse(RetNo) then
    Begin
     if (FetchElmFNo(RetNo,InfoFNo,39)='') or (FetchElmFNo(RetNo,InfoFNo,40)='') then //20210510
     Begin
       SaveDiagnostic(RetNo, 'INFO', 39,'E-INFO: Taxpayer has deceased spouse. Enter MM/DD of marital status changed'); //20210510
       SaveDiagnostic(RetNo, 'INFO', 40,'E-INFO: Taxpayer has deceased spouse. Enter MM/DD of marital status changed'); //20210510
     End;
    End;



    Fno := GetFormNo('OPTIMIZE');
    If ((RetNo = GetPensionerRetNo(RetNo)) and
      (Ret[RetNo].FrmHasData[GetFormNo('T1032')]) and (Ret[RetNo].Age >= 65) and
      (Ret[SpRetNo].Age < 65) and (Vl(FetchElm(RetNo, 'T1032', 21)) < 2000)) and
      (FetchElm(RetNo, 'T1032WS', 9) = '') then
    begin
      SaveDiagnostic(RetNo, 'T1032', 22,
        'W-T1032-Verify line M. Line L<$2,000 and Spouse<65)');
      // 20160304 //20160505 Igor
    end;

    //T1032 months  //20200503
    if FetchElm(RetNo,'T1032',11)<>FetchElm(spRetNo,'T1032',11) then
       SaveDiagnostic(RetNo, 'T1032', 11,'E-T1032-Number of months must be the same in both spouses');


    //20190407
    If (EligibleForWIB(RetNo)) Or (EligibleForWIB(SpRetNo)) then
    Begin
     if (Ret[RetNo].Lnn[45300]=0) and (Ret[SpRetNo].Lnn[45300]=0) then
       SaveDiagnostic(RetNo, S6Frm, 66,'W-S6-CWB not claimed');
    End;

    If (Ret[RetNo].Lnn[14500] > 0) and (Ret[SpRetNo].Lnn[14500] > 0) then // 20131023
    begin
      SaveDiagnostic(RetNo, 'T5007#1', 3,
        'W-T5007-Enter total of box 11 on the higher income spouse');
    end;

    // 20140217
    If (Ret[SpRetNo].Lnn[31600] > 0) and (FetchElm(RetNo, 'INFO', 32) = '') then
      // 20140217
      SaveDiagnostic(RetNo, 'INFO', 32, 'W-INFO-Spouse FCA should be ticked');
    If (Ret[SpRetNo].Lnn[31600] = 0) and (FetchElm(RetNo, 'INFO', 32) > '') then
      // 20140217
      SaveDiagnostic(RetNo, 'INFO', 32,
        'W-INFO-Spouse FCA should not be ticked');

    If (Vl(FetchElmFNo(RetNo, Fno, 24)) > 0) then
      SaveDiagnostic(RetNo, 'OPTIMIZE', 24, 'W-PENSION SPLIT IS IN EFFECT');
    If (Vl(FetchElmFNo(RetNo, Fno, 35)) > 0) then
      SaveDiagnostic(RetNo, 'OPTIMIZE', 35, 'W-PENSION SPLIT IS IN EFFECT');

    If (Ret[RetNo].Lnn[11500] > 0) and
      (Vl(FetchElm(RetNo, 'OPTIMIZE', 24)) + Vl(FetchElm(RetNo, 'OPTIMIZE', 35)
      ) = 0) then
    begin
      SaveDiagnostic(RetNo, 'OPTIMIZE', 24,
        'T-Consider splitting the pension between spouses');
    end;

    If (FetchElm(RetNo, 'T778', 83) > '') { higher income claiming }
      and (Ret[RetNo].MarStatus < 3) { Married }
      and (NetIncBfrChCare(RetNo) > NetIncBfrChCare(SpRetNo)) and
      (Vl(FetchElm(RetNo, 'T778', 64)) > 0) then
    begin
      SaveDiagnostic(RetNo, 'T778', 33,
        'W-T778-Child care entered on the higher income spouse');
    end;


    (* 20220312         *
    //20220103
    if (UpperCase(FetchElm(RetNo,'S14',7))>'')
    and (UpperCase(FetchElm(SpRetNo,'S14',7))>'') then
    Begin
      SaveDiagnostic(RetNo, 'S14', 7,'E-S14-Climate S14 entered on both spouses');
    End;
    *)

    // 20110319                         -
    If FetchElm(SpRetNo, 'INFO', 24) > '' then // deceased spouse
    begin
      If FetchElm(RetNo, 'INFO', 65) = '' then // spouse's date of death
        SaveDiagnostic(RetNo, 'INFO', 65,
          'E-INFO-Spouse deceased. Enter date of his/her death');
    end;
    If FetchElm(RetNo, 'INFO', 65) > '' then // deceased spouse
    begin
      If (Ret[RetNo].MarStatus = 3) // widow(er)
        and (FetchElmFNo(RetNo, InfoFNo, 39) + FetchElmFNo(RetNo, InfoFNo, 40)
        = '') then // spouse's date of death
      Begin
        SaveDiagnostic(RetNo, 'INFO', 39, 'W-INFO-Marital Status Changed');
        SaveDiagnostic(RetNo, 'INFO', 40, 'W-INFO-Marital Status Changed');
      end;
    end;

    //20220620
    Fno := GetFormNo('ON428');
    if (Vl(FetchElmFNo(RetNo, Fno, 104)) > 0) and (Vl(FetchElmFNo(SpRetNo, Fno, 104)) > 0)  then
      SaveDiagnostic(RetNo, 'ON428', 104, 'E-ON428 tax reduction for kids claimed by both spouses');
    if (Vl(FetchElmFNo(RetNo, Fno, 106)) > 0) and (Vl(FetchElmFNo(SpRetNo, Fno, 106)) > 0)  then
      SaveDiagnostic(RetNo, 'ON428', 106, 'E-ON428 tax reduction for kids claimed by both spouses');

    // 20170419
    Fno := GetFormNo('T1032');
    if Vl(FetchElmFNo(SpRetNo, Fno, 59)) > 0 then
    Begin
      If Vl(FetchElmFNo(RetNo, Fno, 59)) = 0 then
        SaveDiagnostic(RetNo, 'T1032', 59, 'E-T1032: T4A-RCA amount of ' + '$' +
          FormatFloat('###,###.##', Vl(FetchElmFNo(SpRetNo, Fno, 59))) +
          ' must be entered in both spouses');
    end;

    // Donations  //20170225
    Fno := GetFormNo('DON');
    if Vl(FetchElmFNo(RetNo, Fno, 179)) + Vl(FetchElmFNo(SpRetNo, Fno, 179)) > 100
    then
      SaveDiagnostic(RetNo, 'DON', 179,
        'E-DONATIONS-Claim by both spouses exceeds 100%)');

    if Vl(FetchElmFNo(RetNo, Fno, 179)) + Vl(FetchElmFNo(SpRetNo, Fno, 179)) < 100
    then
      SaveDiagnostic(RetNo, 'DON', 179,
        'E-DONATIONS-The other spouse could claim ' + FormatFloat('##,###.##',
        100 - Vl(FetchElmFNo(RetNo, Fno, 179))) + '%');
    // --------------------

    If Ret[RetNo].Province = 'NB' then
    begin
      Fno := GetFormNo('S12NB');
      if (Vl(FetchElmFNo(RetNo, Fno, 170))>0)   //20221225
      and (Vl(FetchElmFNo(RetNo, Fno, 170)) = Vl(FetchElmFNo(SpRetNo, Fno, 170)))
      then
          SaveDiagnostic(RetNo, 'S12NB', 170,
            'E-S12NB-Home Renovation Credit claimed by both spouses. Adjust line 4 in S12NB');
    end;


    // onben  //20110210
    If Ret[RetNo].Province = 'ON' then
    begin
      Fno := GetFormNo('ONBEN');
      If UpperCase(FetchElmFNo(RetNo, Fno, 31)) = 'Y' then
      begin
        If Vl(FetchElmFNo(RetNo, Fno, 78)) = Vl(FetchElmFNo(SpRetNo, Fno, 78))
        then
          SaveDiagnostic(RetNo, 'ONBEN', 78,
            'W-ONBEN-Payments identical in both spouses');
        If FetchElmFNo(RetNo, Fno, 35) = FetchElmFNo(SpRetNo, Fno, 35) then
          SaveDiagnostic(RetNo, 'ONBEN', 35,
            'W-ONBEN-Address is identical in both spouses');
      end;
    end;

    // 20160317 //20160505 Igor
    If Ret[RetNo].Province = 'PE' then
    begin
      Fno := GetFormNo('PE428');
      If (Vl(FetchElmFNo(RetNo, Fno, 151)) = 0) and
        (Vl(FetchElmFNo(SpRetNo, Fno, 136)) > 0) then
      // unused reduction from othe spouse
      begin
        SaveDiagnostic(RetNo, 'PE428', 151,
          'W-PE428-You could use unused Low Incone Tax reduction from ' +
          GetFirstName(SpRetNo) + ' of ' + FormatFloat('##,###.##',
          Vl(FetchElmFNo(SpRetNo, Fno, 136))));
      end;

      If (Vl(FetchElmFNo(RetNo, Fno, 151)) > 0) and
        (Vl(FetchElmFNo(SpRetNo, Fno, 136)) = 0) then
      // no unused reduction from othe spouse
      begin
        SaveDiagnostic(RetNo, 'PE428', 151,
          'W-PE428-Unused Low Incone Tax reduction from ' +
          GetFirstName(SpRetNo) + ' of ' + FormatFloat('##,###.##',
          Vl(FetchElmFNo(RetNo, Fno, 151))) + ' maybe invalid');
      end;

    end;

    // 20120606
    If (UpperCase(FetchElm(RetNo, 'S11', 25)) = 'Y') // fed s11 xfer to souse
      and (UpperCase(FetchElm(RetNo, 'S11PRV', 25)) <> 'Y') then
    Begin
      SaveDiagnostic(RetNo, 'S11PRV', 25,
        'W-S11 transferred to spouse, but not the provincial');
    end;

    // 20150320
    Fno := GetFormNo('DON');
    If (Vl(FetchElmFNo(RetNo, Fno, 172)) > 0) and
      (Vl(FetchElmFNo(RetNo, Fno, 173)) + Vl(FetchElmFNo(SpRetNo, Fno, 173)) = 0)
    then
      SaveDiagnostic(RetNo, 'DON', 173,
        'W-DON-Cultural gifts not claimed by either spouse');

    // 20101206
    Fno := GetFormNo('MB479');
    If (Vl(FetchElmFNo(RetNo, Fno, 83)) > 0) and
      (Vl(FetchElmFNo(SpRetNo, Fno, 83)) > 0) then
      SaveDiagnostic(RetNo, 'MB479', 83,
        'E-MB479 - Both spouses have claimed Fertility. Remove one');
    If (UpperCase(FetchElmFNo(RetNo, Fno, 50)) = 'N') and
      (UpperCase(FetchElmFNo(SpRetNo, Fno, 50)) = 'N') then // 20101223
      SaveDiagnostic(RetNo, 'MB479', 50,
        'W-MB479 - No spouse is claiming the Personal Tax Credit');

    // 20110411
    If (Ret[RetNo].Lnn[11700] > 0) and (Ret[SpRetNo].Lnn[11700] > 0) then
      SaveDiagnostic(RetNo, 'RC62#1', 1,
        'W-UCCB - Both spouses claimed it. Adjust/Override');

   {
    If (FetchElm(RetNo, S6Frm, 29) > '') and (FetchElm(SpRetNo, S6Frm, 29) > '')
    then
    Begin
     SaveDiagnostic(RetNo, 'INFO', 151, 'E-CWB-S6-Both spouses set to claim it. Remove it from this or the other spouse');   //20200420
      //SaveDiagnostic(RetNo, 'S6', 29, 'E-CWB-S6-Both spouses claimed it- Remove it from this or the other spouse');   //20200420
    end;
    }
    if Ret[RetNo].Province = 'QC' then
    Begin
      If (FetchElm(RetNo, S6Frm, 29) > '') and
        (FetchElm(SpRetNo, S6Frm, 29) > '') then
         SaveDiagnostic(RetNo, 'INFO', 151, 'E-CWB-S6-Both spouses set to claim it- Remove it from this or the other spouse');   //20200420
        //SaveDiagnostic(RetNo, S6Frm, 29,
        //SaveDiagnostic(RetNo, 'INFO', 151, 'E-CWB-S6-Both spouses claimed it')   //20200420
        // 'E-CWB-S6-Remove claim from this or the other spouse');  //20200420
        //'E-CWB-S6-Both spouses claimed the Basic amount');  //20190504
    end;

    If (Ret[RetNo].Lnn[31800] > 0) and (Ret[SpRetNo].Lnn[31800] > 0) then
      SaveDiagnostic(RetNo, 'TRANSF', 1,
        'W-Both spouses transfer from dependants');

    If (Vl(FetchElm(RetNo, 'PTRANSIT', 79)) > 0) and
      (Vl(FetchElm(RetNo, 'PTRANSIT', 79)) < 100) then
      SaveDiagnostic(RetNo, 'PTRANSIT', 79,
        'E-Public Transit cannot be split by spouses. Claim 100% on one of them');

    If (UpperCase(FetchElm(RetNo, 'TRANSF', 158)) = 'Y') and
      (UpperCase(FetchElm(RetNo, 'PTRANSF', 158)) <> 'Y') then
      // 20130323  //20130328
      SaveDiagnostic(RetNo, 'PTRANSF', 158,
        'W-Transfer must be manual in Fed and Provincial');

    If FetchElmFNo(RetNo, InfoFNo, 59) <> FetchElmFNo(SpRetNo, InfoFNo, 9) then
    begin
      SaveDiagnostic(RetNo, 'INFO', 59,
        'E-Spouse Birthdate is different in spouse return');
    end;

    // moved also outside coupling
    If (FetchElm(RetNo, 'T778', 77) > '') { case b }
      and (Ret[RetNo].Lnn[21400] > 0) and
      (NetIncBfrChCare(RetNo) > NetIncBfrChCare(SpRetNo)) then
    begin
      SaveDiagnostic(RetNo, 'T778', 33,
        'W-T778 - Higher income spouse claimed the child care');
    end;

    If (Ret[RetNo].MarStatus < 3) { Married }
      and (Ret[RetNo].FrmHasData[GetFormNo('DEPEND')] = True)
    { with dependants }
      and (UpperCase(FetchElm(RetNo, 'DEPEND', 140)) = 'Y') { claiming kids }
      and (Vl(FetchElm(RetNo, 'DEPEND', 160)) > 0) { claiming % }   // 20101205
      and (Ret[RetNo].Lnn[23600] < Ret[SpRetNo].Lnn[23600]) { lower income }
    then
    begin
      SaveDiagnostic(RetNo, 'DEPEND', 140,
        'T-Dependants better claimed by the higher income spouse');
    end;

    If (FetchElm(RetNo, S6Frm, 29) > '') and (FetchElm(SpRetNo, S6Frm, 29) > '')
    then
     SaveDiagnostic(RetNo, 'INFO', 151,
      //SaveDiagnostic(RetNo, S6Frm, 29,
        'E-CWB-S6-Both spouses Set to claim CWB. Remove from this or the other spouse'); //20200420

    If (Ret[RetNo].Lnn[21400] > 0) and (Ret[SpRetNo].Lnn[21400] > 0) then
      SaveDiagnostic(RetNo, 'T778', 33,
        'W-T778-Both spouses claimed child care');
    (*  20230219
    { married }
    If Ret[RetNo].Province = 'ON' then
    begin
      If (Vl(FetchElm(RetNo, 'ON479', 20)) > 0) and { sales tax credit }
        (Vl(FetchElm(SpRetNo, 'ON479', 20)) > 0) then
        SaveDiagnostic(RetNo, 'ON479', 1,
          'W-ONCR-Both spouses claimed Sales tax credits');
    end;
    *)

    If (Vl(FetchElm(RetNo, 'CFR', 283)) > 0) { cap loss cf from 2000 }
      and (Vl(FetchElm(RetNo, 'CFR', 40)) = 0) { 2000 incl rate } then
      SaveEFileDiagnostic(RetNo, 'CFR', 40,
        'E-Inclusion rate for 2000 required');

    If (FetchElmFNo(RetNo, InfoFNo, 6) <> FetchElmFNo(SpRetNo, InfoFNo, 6)) or
      (FetchElmFNo(RetNo, InfoFNo, 10) <> FetchElmFNo(SpRetNo, InfoFNo, 10)) or
      (FetchElmFNo(RetNo, InfoFNo, 14) <> FetchElmFNo(SpRetNo, InfoFNo, 14)) or
      (FetchElmFNo(RetNo, InfoFNo, 15) <> FetchElmFNo(SpRetNo, InfoFNo, 15))
    then
      SaveDiagnostic(RetNo, 'INFO', 6,
        'W-Spouses have different addresses. Right click the street box');

    For i := 1 to 5 do
    begin
      FInst := '#' + AllTrim(IntToStr(i));
      Fno := GetFormNo('T2125' + FInst);
      If Fno > 0 then // 20101219
      begin
        // check % of ownership
        If (Vl(FetchElmFNo(RetNo, Fno, 18)) = 100) and
          (Ret[RetNo].FrmHasData[Fno]) and
          (Vl(FetchElmFNo(SpRetNo, Fno, 18)) = 100) and
          (Ret[SpRetNo].FrmHasData[Fno]) then
          SaveDiagnostic(RetNo, 'T2125' + FInst, 18,
            'E-T2125' + FInst +
            '-Spouses 100% of same statement (use #1, #2, etc)');
      end;
    end;
  end; { coupling }

  // ShowMessage('ending Length of audit records= '+IntToStr(Length(Ret[RetNo].AuditRec)));
  RESULT := Ret[RetNo].ErrorCount;

End; // end CountDiagnostics //------------------------------------------------------------------------------------------------------------------------------------------------------------

Function LastYearYSumAvailable(ValueList: TStringList): Boolean;
Var
  i: integer;
begin
  RESULT := false;
  For i := 0 to ValueList.count - 1 do
    If Vl(ValueList[i]) <> 0 then
    begin
      RESULT := True;
      Exit;
    end;
end;

Function InterestDistribution(RetNo: integer): Boolean;
Var
  x: real;
begin
  RESULT := True;
  x := Vl(FetchElm(RetNo, 'EFMEMO', 37)) + Vl(FetchElm(RetNo, 'EFMEMO', 38)) +
    Vl(FetchElm(RetNo, 'EFMEMO', 39)) + Vl(FetchElm(RetNo, 'EFMEMO', 41));

  If (Ret[RetNo].Lnn[12100] > 0) and (x = 0) then
  begin
    RESULT := false;
    Exit;
  end;

  If x - Ret[RetNo].Lnn[12100] > 0.02 then // 20110226
  // If X > Ret[retNo].Lnn[12100] then
  begin
    RESULT := false;
    Exit;
  end;

end;

Procedure ValidateT1013(RetNo: integer; Fno: integer; Inst: String);
Var
  i: integer;
  S: String;
  Dt: TDate; // Inst:String;
  Fname: String;
Begin
  Fname := 'T1013' + Inst;
  If Ret[RetNo].FrmHasData[Fno] = false then
    Exit;

  If (FetchElmFNo(RetNo, Fno, 26) > '') // x on prepare but no other info
  then
  begin
    if FetchElmFNo(RetNo, Fno, 20) + FetchElmFNo(RetNo, Fno, 21) +
      FetchElmFNo(RetNo, Fno, 30) = '' then
    begin
      SaveDiagnostic(RetNo, Fname, 20,
        'E-T1013 Please select one of the options');
      SaveDiagnostic(RetNo, Fname, 21,
        'E-T1013 Please select one of the options');
      SaveDiagnostic(RetNo, Fname, 30,
        'E-T1013 Please select one of the options');
    end;
  end;

  if FetchElmFNo(RetNo, Fno, 20) > '' then // sectionA
  Begin
    If (FetchElmFNo(RetNo, Fno, 27) + FetchElmFNo(RetNo, Fno, 28) = '') and
      (FetchElmFNo(RetNo, Fno, 8) = 'G') // this is considered empty
    then
    begin
      SaveDiagnostic(RetNo, Fname, 27,
        'E-T1013 Please enter one of the options');
      SaveDiagnostic(RetNo, Fname, 8,
        'E-T1013 Please enter one of the options');
      SaveDiagnostic(RetNo, Fname, 28,
        'E-T1013 Please enter one of the options');
    end;

    if FetchElmFNo(RetNo, Fno, 27) > '' then // rep id
    Begin
      If Length(FetchElmFNo(RetNo, Fno, 27)) <> 7 then
        SaveDiagnostic(RetNo, Fname, 27, 'E-T1013 Invalid RepId');
      If FetchElmFNo(RetNo, Fno, 34) = '' then
        SaveDiagnostic(RetNo, Fname, 34, 'E-T1013 Enter First Name');
      If FetchElmFNo(RetNo, Fno, 35) = '' then
        SaveDiagnostic(RetNo, Fname, 35, 'E-T1013 Enter Last Name');
    End;

    if Length(FetchElmFNo(RetNo, Fno, 8)) > 1 then // group
    Begin
      If (Length(FetchElmFNo(RetNo, Fno, 8)) <> 6) or
        (UpperCase(LeftStr(FetchElmFNo(RetNo, Fno, 8), 1)) <> 'G') then
        SaveDiagnostic(RetNo, Fname, 8, 'E-T1013 Invalid GroupId');
      If FetchElmFNo(RetNo, Fno, 36) = '' then
        SaveDiagnostic(RetNo, Fname, 36, 'E-T1013 Enter Group Name');
    End;

    If Length(FetchElmFNo(RetNo, Fno, 8)) > 1 then // GroupId  //20180201
    begin
      If (Length(FetchElmFNo(RetNo, Fno, 8)) <> 6) or
        (UpperCase(LeftStr(FetchElmFNo(RetNo, Fno, 8), 1)) <> 'G') then
        SaveDiagnostic(RetNo, Fname, 8, 'E-T1013 Invalid GroupId');
    end;

    if FetchElmFNo(RetNo, Fno, 28) > '' then // BN
    Begin
      If (Length(FetchElmFNo(RetNo, Fno, 28)) <> 9) then
        SaveDiagnostic(RetNo, Fname, 28, 'E-T1013 Invalid Business Number');
      If FetchElmFNo(RetNo, Fno, 38) = '' then
        SaveDiagnostic(RetNo, Fname, 38, 'E-T1013 Enter Business Name');
    End;

    if FetchElmFNo(RetNo, Fno, 32) = '' then // authorization
      SaveDiagnostic(RetNo, Fname, 32,
        'W-T1013 Level of Authorization is assumed 1 unless you enter 2');
  End; // sectionA

  // Section B
  if FetchElmFNo(RetNo, Fno, 21) > '' then
  Begin
    if FetchElmFNo(RetNo, Fno, 103) = '' then // authorization
      SaveDiagnostic(RetNo, Fname, 103,
        'W-T1013 Level of Authorization is assumed 1 unless you enter 2');

    If FetchElmFNo(RetNo, Fno, 15) + FetchElmFNo(RetNo, Fno, 22) +
      FetchElmFNo(RetNo, Fno, 17) = '' then
      SaveDiagnostic(RetNo, Fname, 15,
        'W-T1013 Please enter at least one of the options');

    If (FetchElmFNo(RetNo, Fno, 15) > '') then
      SaveDiagnostic(RetNo, Fname, 15,
        'W-T1013 You cannot Efile it if Part B is used');

    If (FetchElmFNo(RetNo, Fno, 17) > '') then
      SaveDiagnostic(RetNo, Fname, 17,
        'W-T1013 You cannot Efile it if Part B is used');
  end;

  // part 4 - cancellation
  if FetchElmFNo(RetNo, Fno, 30) > '' then
  Begin
    If FetchElmFNo(RetNo, Fno, 14) + FetchElmFNo(RetNo, Fno, 16) = '' then
    Begin
      SaveDiagnostic(RetNo, Fname, 14, 'E-T1013-Select one of the options');
      SaveDiagnostic(RetNo, Fname, 16, 'E-T1013-Select one of the options');
    End;

    if FetchElmFNo(RetNo, Fno, 16) > '' then
    Begin
      If (FetchElmFNo(RetNo, Fno, 6) + FetchElmFNo(RetNo, Fno, 7) = '') and
        (Length(FetchElmFNo(RetNo, Fno, 10)) = 1) then
      Begin
        SaveDiagnostic(RetNo, Fname, 6, 'E-T1013-Select one of the options');
        SaveDiagnostic(RetNo, Fname, 10, 'E-T1013-Select one of the options');
        SaveDiagnostic(RetNo, Fname, 7, 'E-T1013-Select one of the options');
      End;

      If FetchElmFNo(RetNo, Fno, 6) > '' then
      Begin
        If Length(FetchElmFNo(RetNo, Fno, 6)) <> 7 then
          SaveDiagnostic(RetNo, Fname, 6, 'E-T1013 Invalid RepId');
        If FetchElmFNo(RetNo, Fno, 1) = '' then
          SaveDiagnostic(RetNo, Fname, 1, 'E-T1013-Enter First Name');
        If FetchElmFNo(RetNo, Fno, 31) = '' then
          SaveDiagnostic(RetNo, Fname, 31, 'E-T1013-Enter Last Name');
      End;

      If Length(FetchElmFNo(RetNo, Fno, 10)) > 1 then // GroupId //20180201
      begin
        If (Length(FetchElmFNo(RetNo, Fno, 10)) <> 6) or
          (UpperCase(LeftStr(FetchElmFNo(RetNo, Fno, 10), 1)) <> 'G') then
          SaveDiagnostic(RetNo, Fname, 10, 'E-T1013 Invalid GroupId');
      end;

      If FetchElmFNo(RetNo, Fno, 7) > '' then // B/N
      begin
        If (Length(FetchElmFNo(RetNo, Fno, 7)) <> 9) then
          SaveDiagnostic(RetNo, Fname, 7, 'E-T1013 Invalid Business Number');
        If FetchElmFNo(RetNo, Fno, 2) = '' then
          SaveDiagnostic(RetNo, Fname, 2, 'E-T1013-Enter Group Name');
      end;
    End;
  end;

  // date
  If (FetchElmFNo(RetNo, Fno, 131) > '') then
  begin
    If UpperCase(FetchElmFNo(RetNo, Fno, 26)) = 'X' then
    // submit this year  //20140201
    Begin
      If FetchElmFNo(RetNo, Fno, 131) > FormatDateTime('yyyy-mm-dd', Date) then
        SaveDiagnostic(RetNo, Fname, 131, 'E-T1013-Date is after today' +
          Chr(39) + 's date');
      Dt := IncMonth(Date, -6);
      If FetchElmFNo(RetNo, Fno, 131) < FormatDateTime('yyyy-mm-dd', Dt) then
        SaveDiagnostic(RetNo, Fname, 131,
          'E-T1013-Date is not within 6 months');
    end;
    If Length(FetchElmFNo(RetNo, Fno, 131)) <> 10 then
      SaveDiagnostic(RetNo, Fname, 131, 'E-T1013-Date must be yyyy-mm-dd');
    // 20120112
  end;

end;

// 20160123
Procedure RemoveT1135SectionAdata(RetNo: integer; Fno: integer);
Var
  i: integer;
  S: String;
Begin
  For i := 46 to 50 do
  begin
    If FetchElmFNo(RetNo, Fno, i) > '' then
      SaveDiagnostic(RetNo, 'T1135', i,
        'E-T1135-Remove Type of property in Part A');
  end;
  If FetchElmFNo(RetNo, Fno, 53) > '' then
    SaveDiagnostic(RetNo, 'T1135', 53,
      'E-T1135-Remove Type of property in Part A');
  If FetchElmFNo(RetNo, Fno, 55) > '' then
    SaveDiagnostic(RetNo, 'T1135', 55,
      'E-T1135-Remove Type of property in Part A');

  If FetchElmFNo(RetNo, Fno, 57) > '' then
    SaveDiagnostic(RetNo, 'T1135', 57, 'E-T1135-Remove Country code in Part A');
  If FetchElmFNo(RetNo, Fno, 58) > '' then
    SaveDiagnostic(RetNo, 'T1135', 58, 'E-T1135-Remove Country code in Part A');
  If FetchElmFNo(RetNo, Fno, 59) > '' then
    SaveDiagnostic(RetNo, 'T1135', 59, 'E-T1135-Remove Country code in Part A');
  If FetchElmFNo(RetNo, Fno, 60) > '' then
    SaveDiagnostic(RetNo, 'T1135', 60, 'E-T1135-Remove Income in Part A');
  If FetchElmFNo(RetNo, Fno, 64) > '' then
    SaveDiagnostic(RetNo, 'T1135', 64, 'E-T1135-Remove Gain/Loss in Part A');

end;

Procedure RemoveT1135SectionBdata(RetNo: integer; Fno: integer);
Var
  i: integer;
Begin
  i := 1;
  Repeat
    If (FetchElmFNo(RetNo, Fno, i * 10001) > '') then
      SaveDiagnostic(RetNo, 'T1135', i * 10001,
        'E-T1135-Delete all data from Part B');
    Inc(i, 1);
  until i > 7;
end;

Procedure ValidateT1135SectionAdata(RetNo: integer; Fno: integer);
Var
  i: integer;
  S: String;
Begin
  S := '';
  For i := 46 to 50 do
  begin
    S := S + FetchElmFNo(RetNo, Fno, i);
  End;
  S := S + FetchElmFNo(RetNo, Fno, 53) + FetchElmFNo(RetNo, Fno, 55);
  If S = '' then
  begin
    SaveDiagnostic(RetNo, 'T1135', 46,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 47,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 48,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 49,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 50,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 53,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 55,
      'E-T1135-Part A: please select at least one Type of property');
  end;
  S := FetchElmFNo(RetNo, Fno, 57) + FetchElmFNo(RetNo, Fno, 58) +
    FetchElmFNo(RetNo, Fno, 59);
  If S = '' then
  begin
    SaveDiagnostic(RetNo, 'T1135', 57,
      'E-T1135-Part A: Please select at least one Country code');
    SaveDiagnostic(RetNo, 'T1135', 58,
      'E-T1135-Part A: Please select at least one Country code');
    SaveDiagnostic(RetNo, 'T1135', 59,
      'E-T1135-Part A: Please select at least one Country code');
  end;

  (* not efective
    //20180506
    If (FetchElmFNo(RetNo,FNo,34)+FetchElmFNo(RetNo,FNo,86)>'')
    and (FetchElmFNo(RetNo,FNo,36)+FetchElmFNo(RetNo,FNo,42)='') then
    Begin
    SaveDiagnostic(RetNo,'T1135',36,'E-T1135-Please select a box  on the left side');
    SaveDiagnostic(RetNo,'T1135',42,'E-T1135-Please select a box  on the left side');
    End;
  *)

  If FetchElmFNo(RetNo, Fno, 60) = '' then
    SaveDiagnostic(RetNo, 'T1135', 60,
      'E-T1135-Part A: please enter an amount in the Income from all' + Chr(13)
      + ' specified foreign property field. If nil enter 0.');

  If FetchElmFNo(RetNo, Fno, 64) = '' then
    SaveDiagnostic(RetNo, 'T1135', 64,
      'E-T1135-Part A: please enter an amount in the Gain/Loss from the disposition from'
      + Chr(13) + 'all specified foreign property field. If nil enter 0.');

end;

Procedure ValidateT1135SectionBdata(RetNo: integer; Fno: integer);
Var
  i: integer;  //array number
  S: String;
  Cnt: integer;
Begin
  Cnt := 0; // count entries in section B
  i := 1;
  Repeat
    If (FetchElmFNo(RetNo, Fno, i * 10000 + 1) > '') then
      Cnt := Cnt + 1; // 20160325 //20160505 Igor
    Inc(i, 1);
  until i > 7;
  If Cnt = 0 then
    SaveDiagnostic(RetNo, 'T1135', 10001,
      'E-T1135-Specified foreign property has been divided into 7 categories. At least one row must be fully completed in one of the 7 tables provided');
  // 20160325 //20160505 Igor
  // check country code
  i := 1;
  Repeat
    If (FetchElmFNo(RetNo, Fno, i * 10000 + 1) > '') and
      (FetchElmFNo(RetNo, Fno, i * 10000 + 2) = '') then
      SaveDiagnostic(RetNo, 'T1135', 0,
        'E-T1135-Part B: If you enter Name, you must also enter Country Code');
    {
    If Vl(FetchElmFNo(RetNo, Fno, i * 10000 + 4)) > Vl(FetchElmFNo(RetNo, Fno, i * 10000 + 3)) then //20230214
       SaveDiagnostic(RetNo, 'T1135', i * 10000 + 4,
        'E-T1135-Part B: Funds held at year end must not exceed Maximum funds during the year');
    }

    Inc(i, 1);
  until i > 7;

end;

Procedure ValidateT1135(RetNo: integer; Fno: integer);
// Var s:String;
Var i, Elm, ArrayNo, BoxesPerRow: integer; //20220211 Igor
begin
  // T1135  brand new 20160124  REDO
  If Ret[RetNo].FrmHasData[Fno] = True then
  Begin
    // s:='';
    // 20160123
    If FetchElmFNo(RetNo, Fno, 2) = '' then
      SaveDiagnostic(RetNo, 'T1135', 2, 'E-T1135-First Name is required');
    If FetchElmFNo(RetNo, Fno, 3) = '' then
      SaveDiagnostic(RetNo, 'T1135', 3, 'E-T1135-Last Name is required');
    If FetchElmFNo(RetNo, Fno, 5) = '' then
      SaveDiagnostic(RetNo, 'T1135', 5, 'E-T1135-SIN is required');

    //20220218

    If FetchElmFNo(RetNo, Fno, 15) = '' then
      SaveDiagnostic(RetNo, 'T1135', 15, 'E-T1135-Street address is required');

    //20220211
    If FetchElmFNo(RetNo, Fno, 16) = '' then
      SaveDiagnostic(RetNo, 'T1135', 16,'E-T1135-Postal code is required');

    If FetchElmFNo(RetNo, Fno, 28) = 'CAN' then
    Begin
      If ValidPostal(RetNo, FetchElmFNo(RetNo, Fno, 16)) = false then
         SaveDiagnostic(RetNo, 'T1135', 16,'E-T1135-Postal code is incorrect');
    End;
    //-----

    If FetchElmFNo(RetNo, Fno, 17) = '' then
      SaveDiagnostic(RetNo, 'T1135', 17, 'E-T1135-City is required');
    If FetchElmFNo(RetNo, Fno, 63) = '' then
      SaveDiagnostic(RetNo, 'T1135', 63,
        'E-T1135-Province or territory is required');
    If FetchElmFNo(RetNo, Fno, 16) = '' then
      SaveDiagnostic(RetNo, 'T1135', 16,
        'E-T1135-Postal or Zip code is required');
    If FetchElmFNo(RetNo, Fno, 28) = '' then
      SaveDiagnostic(RetNo, 'T1135', 28, 'E-T1135-Country Code is required');
    If FetchElmFNo(RetNo, Fno, 28) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 28,
        'E-T1135-Country Code cannot be OTH in Address');

    If FetchElmFNo(RetNo, Fno, 70) = '' then
      SaveDiagnostic(RetNo, 'T1135', 70,
        'E-T1135-Certification section - Name is required');

    // tbl 1
    If FetchElmFNo(RetNo, Fno, 10002) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 10002,
        'E-T1135-Country Code cannot be OTH in Part B-Table 1'); // 20160123
    If FetchElmFNo(RetNo, Fno, 10007) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 10007,
        'E-T1135-Country Code cannot be OTH in Part B-Table 1'); // 20160123
    If FetchElmFNo(RetNo, Fno, 10012) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 10012,
        'E-T1135-Country Code cannot be OTH in Part B-Table 1'); // 20160123
    // tbl 5
    If FetchElmFNo(RetNo, Fno, 50002) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 50002,
        'E-T1135-Country Code cannot be OTH in Part B-Table 5'); // 20160123
    If FetchElmFNo(RetNo, Fno, 50007) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 50007,
        'E-T1135-Country Code cannot be OTH in Part B-Table 5'); // 20160123
    If FetchElmFNo(RetNo, Fno, 50012) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 50012,
        'E-T1135-Country Code cannot be OTH in Part B-Table 5'); // 20160123
    // -----------------------

    If FetchElmFNo(RetNo, Fno, 36) + FetchElmFNo(RetNo, Fno, 42) = '' then
      // if not B select A or the election to use B
      SaveDiagnostic(RetNo, 'T1135', 36,
        'E-T1135-Please check the appropriate box; Total Cost of foreign property exceeds $100,000 but less than $250,000 OR Total Cost of foreign property is $250,000 or more.');

    If (FetchElmFNo(RetNo, Fno, 36) > '') And (FetchElmFNo(RetNo, Fno, 86) = '')
    // Strictly A
    then
    begin
      RemoveT1135SectionBdata(RetNo, Fno); // 20160123
      ValidateT1135SectionAdata(RetNo, Fno); // 20160123
    end;

    // use section B
    If (FetchElmFNo(RetNo, Fno, 42) > '') // >=$250,000
      Or ((FetchElmFNo(RetNo, Fno, 36) > '') And (FetchElmFNo(RetNo, Fno, 86) > '')) then
    Begin
      RemoveT1135SectionAdata(RetNo, Fno);
      ValidateT1135SectionBdata(RetNo, Fno);

      ValidateT1135MaxYearEnd(RetNo, Fno); //20230214
    end;
    //20200505
    if UpperCase(FetchElmFNo(RetNo, Fno, 29)) = 'Y' then
    Begin
     If FetchElmFNo(RetNo, Fno, 75)='' then SaveDiagnostic(RetNo, 'T1135', 75,'E-T1135-Preparer Address is required');
     If FetchElmFNo(RetNo, Fno, 76)='' then SaveDiagnostic(RetNo, 'T1135', 76,'E-T1135-Preparer Postal or zip is required');
    End;

    // 20190417
    if FetchElmFNo(RetNo, Fno, 72) > '' then
      if (Length(FetchElmFNo(RetNo, Fno, 72)) < 14)
      Or (ValidateT1135phone(FetchElmFNo(RetNo, Fno, 72))=False) //20220209
       then
        SaveDiagnostic(RetNo, 'T1135', 72,'W-T1135-Phone should be in the format (999)999-9999');

    if FetchElmFNo(RetNo, Fno, 77) > '' then
      if (Length(FetchElmFNo(RetNo, Fno, 77)) < 14)
      Or (ValidateT1135phone(FetchElmFNo(RetNo, Fno, 77))=False) //20220209
      then
        SaveDiagnostic(RetNo, 'T1135', 77,'W-T1135-Phone should be in the format (999)999-9999');

    //20220211 Igor>>>
    ArrayNo := 1;
    BoxesPerRow := 5;
    Elm := ArrayNo * 10000 + 1;
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      if (FetchElmFNo(RetNo, FNo, Elm) <> '') and (FetchElmFNo(RetNo, FNo, Elm + 1) = '') then
        SaveDiagnostic(RetNo, 'T1135', Elm + 1,
          'E-T1135-Country is not selected');
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 2;
    BoxesPerRow := 6;
    Elm := ArrayNo * 10000 + 1;
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      if (FetchElmFNo(RetNo, FNo, Elm) <> '') and (FetchElmFNo(RetNo, FNo, Elm + 1) = '') then
        SaveDiagnostic(RetNo, 'T1135', Elm + 1,
          'E-T1135-Country is not selected');
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 3;
    BoxesPerRow := 6;
    Elm := ArrayNo * 10000 + 1;
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      if (FetchElmFNo(RetNo, FNo, Elm) <> '') and (FetchElmFNo(RetNo, FNo, Elm + 1) = '') then
        SaveDiagnostic(RetNo, 'T1135', Elm + 1,
          'E-T1135-Country is not selected');
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 4;
    BoxesPerRow := 7;
    Elm := ArrayNo * 10000 + 1;
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      if (FetchElmFNo(RetNo, FNo, Elm) <> '') and (FetchElmFNo(RetNo, FNo, Elm + 1) = '') then
        SaveDiagnostic(RetNo, 'T1135', Elm + 1,
          'E-T1135-Country is not selected');
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 5;
    BoxesPerRow := 6;
    Elm := ArrayNo * 10000 + 1;
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      if (FetchElmFNo(RetNo, FNo, Elm) <> '') and (FetchElmFNo(RetNo, FNo, Elm + 1) = '') then
        SaveDiagnostic(RetNo, 'T1135', Elm + 1,
          'E-T1135-Country is not selected');
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 6;
    BoxesPerRow := 6;
    Elm := ArrayNo * 10000 + 1;
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      if (FetchElmFNo(RetNo, FNo, Elm) <> '') and (FetchElmFNo(RetNo, FNo, Elm + 1) = '') then
        SaveDiagnostic(RetNo, 'T1135', Elm + 1,
          'E-T1135-Country is not selected');
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 7;
    BoxesPerRow := 6;
    Elm := ArrayNo * 10000 + 1;
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      if (FetchElmFNo(RetNo, FNo, Elm) <> '') and (FetchElmFNo(RetNo, FNo, Elm + 1) = '') then
        SaveDiagnostic(RetNo, 'T1135', Elm + 1,
          'E-T1135-Country is not selected');
      Elm := Elm + BoxesPerRow;
    end;
    //20220211 Igor <<<
  end;
end;

Procedure ValidateT183(RetNo: integer; Fno: integer);  //fno=the t183fno
Var
  i: integer;
  S: String;
Begin
  SaveDiagnostic(RetNo, 'T183', 999, 'W-  ---------- ');
  SaveDiagnostic(RetNo, 'T183', 999, 'W-   ');
  SaveDiagnostic(RetNo, 'T183', 999, 'W-  T183 and NOA DIAGNOSTICS');
  if (FetchElmFNo(RetNo, FNo, 13) > '') and (FetchElmFNo(RetNo, FNo, 18) > '') then
  Begin
    SaveDiagnostic(RetNo, 'T183', 13,'E-T183-Please select Box #1 or Box #2 but no both');
    SaveDiagnostic(RetNo, 'T183', 18,'E-T183-Please select Box #1 or Box #2 but no both');
  End;
  if (FetchElmFNo(RetNo, FNo, 13) > '') and (FetchElmFNo(RetNo, FNo, 19) > '') then
  Begin
    SaveDiagnostic(RetNo, 'T183', 13,'E-T183-Please select either Electronic delivery Or paper, but not both)');
    SaveDiagnostic(RetNo, 'T183', 19,'E-T183-Please select either Electronic delivery Or paper, but not both)');
  End;
  if (FetchElmFNo(RetNo, FNo, 18) > '') and (FetchElmFNo(RetNo, FNo, 19) > '') then
  Begin
    SaveDiagnostic(RetNo, 'T183', 18,'E-T183-Please select either Electronic delivery Or paper, but not both)');
    SaveDiagnostic(RetNo, 'T183', 19,'E-T183-Please select either Electronic delivery Or paper, but not both)');
  End;

  // box 1 only or Box #1 and #2
  if FetchElmFNo(RetNo, Fno, 13) > '' then // 20180115 taxpayer to receive it
  Begin
    if FetchElmFNo(RetNo, Fno, 10) > '' then // email provided
    begin
      SaveDiagnostic(RetNo, 'T183', 13,
        'W- -NOA Box #1 selected and Email provided, stating that taxpayer is already');
      SaveDiagnostic(RetNo, 'T183', 13,
        'W-  registered to receive email notifications.')
    end
    Else
      SaveDiagnostic(RetNo, 'T183', 13,
        'W- -You selected NOA Box #1, stating taxpayer is already registered for online access.');

    if FetchElmFNo(RetNo, Fno, 10) > '' then
      SaveDiagnostic(RetNo, 'T183', 13,
        'W- -The CRA email address will be updated with the one provided on section A of the T183.');
    SaveDiagnostic(RetNo, 'T183', 13,
      'W- -Taxpayer will view and access their notices online through MyAccount.');

    If FetchElmFNo(RetNo, Fno, 18) > '' then // box #2 ALSO
    Begin
      SaveDiagnostic(RetNo, 'T183', 18,
        'W- -Box #2 electronic delivery of the notices in the software has ALSO been selected');
      SaveDiagnostic(RetNo, 'T183', 18,
        'W   authorizing you to receive the Taxpayer' + '''' + 's NOA');
      SaveDiagnostic(RetNo, 'T183', 18,
        'W- -A valid Form AuthRep must be on file with CRA');  //20200209
      SaveDiagnostic(RetNo, 'T183', 18,
        'W-  authorizing you to receive the Taxpayer' + '''' + 's NOA');
      SaveDiagnostic(RetNo, 'T183', 18,
        'W- -You will be providing a copy of the NOA to the taxpayer');
    End;
    SaveDiagnostic(RetNo, 'T183', 13,
      'W- -Paper notices will not be mailed to the taxpayer from the CRA.');
  End;

  // --------------------------------------------------------
  // box 2 only tax preparer   //20200126
  If (FetchElmFNo(RetNo, Fno, 18) > '') //and (FetchElmFNo(RetNo, Fno, 13) = '')
  then // box 2
  begin
    SaveDiagnostic(RetNo, 'T183', 18,'W- -NOA box #2, Electronic delivery of the notices in the software has been selected.');
    SaveDiagnostic(RetNo, 'T183', 18,'W- -A valid request authorizing you as a representative must be on file with the CRA,');
    SaveDiagnostic(RetNo, 'T183', 18,'W   for you to receive the taxpayer’s notices electronically in the software,');
    SaveDiagnostic(RetNo, 'T183', 18,'W   and provide them with a copy.');
    SaveDiagnostic(RetNo, 'T183', 13,'W- -Paper notices will not be mailed to the taxpayer from the CRA');
  end;

  if FetchElmFNo(RetNo, FNo, 19) > '' then     //20250308 //NOT IN EFFECT in 2024
  Begin
      SaveDiagnostic(RetNo, 'T183', 19,'W- -Paper notices has been selected and will only be mailed from the CRA if');
      SaveDiagnostic(RetNo, 'T183', 19,'W   the taxpayer is not registered for email notifications.');
  End;
  //==========================
  {
  // box 3
  if FetchElmFNo(RetNo, T183FNo, 19) > '' then // 20180115 Canada Post  //paper mail
  Begin
    if FetchElmFNo(RetNo, Fno, 13) = '' then
    Begin
      SaveDiagnostic(RetNo, 'T183', 19,
        'W-Delivery of the paper notices has been selected.');
      SaveDiagnostic(RetNo, 'T183', 19,
        'W-Paper notices will be mailed to the taxpayer from the CRA.');
    End;
  end;
  }

  if FetchElmFNo(RetNo, Fno, 21) > '' then
  Begin
    if ValidateDCN(RetNo) = false then
      SaveDiagnostic(RetNo, 'T183', 21,
        'E-The DCN Number is incorrect. Please correct before Efiling');
  End;
  //=================
  if Vl(FetchElm(RetNo, 'TAXSUM', 130)) > 0 then // Balance due
  Begin // 20180130
    SaveDiagnostic(RetNo, 'T183', 15,'W- -There is Balance due. If you want to use Pre-authorized Debit (PAD), open the PADINFO form'); //20210417
  end;

  // 20180115
  if Vl(FetchElmFNo(RetNo, Fno, 14)) > 0 then // amount of PAD
  Begin
    if FetchElmFNo(RetNo, Fno, 15) = '' then
      SaveDiagnostic(RetNo, 'T183', 15, 'E-T183-PAD Payment Date is required.');
    if FetchElmFNo(RetNo, Fno, 27) = '' then
      SaveDiagnostic(RetNo, 'T183', 27,
        'E-T183-PAD Signature Date must be entered on T183.');
  End;

  if FetchElmFNo(RetNo, Fno, 15) > '' then // payment date
  Begin
    if ValidatePadPaymentDate(FetchElm(RetNo, 'T183', 27),
      FetchElm(RetNo, 'T183', 15)) = 1 then
      SaveDiagnostic(RetNo, 'T183', 15,
        'E-T183-PAD Payment Date is a holiday. Please correct.');

    if ValidatePadPaymentDate(FetchElmFNo(RetNo, Fno, 27),
      FetchElmFNo(RetNo, Fno, 15)) = 2 then
      SaveDiagnostic(RetNo, 'T183', 15,
        'E-T183-PAD Payment Date must be at least 5 business days ahead.');

    if Vl(FetchElmFNo(RetNo, Fno, 14)) < 2 then // 20190208
      SaveDiagnostic(RetNo, 'T183', 14,
        'E-T183-PAD amount is required, not less than $2)');

    // 20190208
    if Vl(FetchElmFNo(RetNo, Fno, 14)) > 24999999.99 then
      SaveDiagnostic(RetNo, 'T183', 14,
        'E-T183-PAD amount exceeds maximum of $24,999.999.99');
  End;


  If FetchElmFNo(RetNo, InfoFNo, 58) > '' then
    SaveDiagnostic(RetNo, 'T183', 22,
      'W-Declaration/Authorization: Ensure client signs Part F of the T183 form.');  //20230309 F not D
  // 20190114

  If (FetchElmFNo(RetNo, Fno, 27) > '') then
  begin
    If FetchElmFNo(RetNo, Fno, 27) < FormatDateTime('yyyy-mm-dd', Date) then
      SaveDiagnostic(RetNo, 'T183', 27, 'D-T183-Date prior than today');
    // 20140208
  end;

  If ((FetchElm(RetNo, 'STATUS', 15) <> '02') // not EF accepted
    and (FetchElm(RetNo, 'STATUS', 15) <> '04')) // not EF waiting ack
  then
  begin
    If Ret[RetNo].FrmHasData[GetFormNo('T183')] then
    begin
      If Length(FetchElm(RetNo, 'T183', 21)) <> 13 then
      begin
        If Length(GetEOLAgentNo) <> 5 then // 20140208
          SaveDiagnostic(RetNo, 'T183', 21,
            'G-T183-Enter Efiler No. in EFileOnLine|Setup EOL AND EOLP');
        SaveDiagnostic(RetNo, 'T183', 21,
          'G-T183-To fix the DCN, erase it and press Enter');
        SaveDiagnostic(RetNo, 'T183', 21,
          'G-T183-DCN must be 13 characters (EFilerNo+8)');
      end;
    end;

  end;
  SaveDiagnostic(RetNo, 'T183', 999,
    'W------------------------------------------------------------------------------');
end;



Procedure ValidateS6(RetNo: integer); // 20170121
Var
  i: integer;
  S: String;
  Fno: integer;
  S6Frm: String;
  WitbIncThreshold: real;
  WorkingInc: real;
Begin
  S6Frm := 'S6';
  if Ret[RetNo].Province = 'QC' then S6Frm := 'S6QC';
  Fno := GetFormNo(S6Frm);
  WitbIncThreshold := Vl(FetchElmFNo(RetNo, Fno, 93));
  WorkingInc := Vl(FetchElmFNo(RetNo, Fno, 15));
  If InitialWITBEligibility(RetNo) = True then
  begin
    if (FetchElmFNo(RetNo, InfoFNo, 145) + FetchElmFNo(RetNo, InfoFNo, 146)='')
    Or (FetchElmFNo(RetNo, InfoFNo, 147) + FetchElmFNo(RetNo, InfoFNo, 148)='')
    Or (FetchElmFNo(RetNo, InfoFNo, 149) + FetchElmFNo(RetNo, InfoFNo, 150)='') then
   Begin  //20200425
      SaveDiagnostic(RetNo, 'INFO', 146,'E-CWB-INFO-Please complete ALL CWB questions');  //20
      Exit;
   End;
  End;

  //20240110
  if FetchElm(RetNo,'S6',66)>'' then //EligibleForWiBPerCRA(RetNo) then //20240111
  Begin
   if FetchElm(RetNo,'S6',29)+FetchElm(RetNo,'S6',30)='' then
   begin
     SaveDiagnostic(RetNo, 'S6', 29,'E-S6-Please enter Yes or No for the basic CWB');
   end;
  End;


  //20250307
  if EligibleForWiBPerCRA(RetNo)=False then
    Begin
    SaveDiagnostic(RetNo, 'INFO', 145,'W-----------'); // 220250307
    SaveDiagnostic(RetNo, 'INFO', 145,'W-S6-This return is not eligible for CWB,'); // 20170127
    SaveDiagnostic(RetNo, 'INFO', 145,'W-   as per CRA questionnaire on INFO form'); // 20190504
    SaveDiagnostic(RetNo, 'INFO', 145,'W------------'); // 220250307
    //Exit; //20240111
  end;
  //20190222
  if (EligibleForWibPerCRA(RetNo)=True)
  and (EligibleForWib(RetNo)=True)  //20190504
  then
  Begin
    //20250307
    if (FetchElm(RetNo,S6Frm,66)+FetchElm(RetNo,S6Frm,67)='')
    and ((FetchElm(RetNo,InfoFNo,26)<>'01') and (FetchElm(RetNo,InfoFNo,25)<>'01')) //only Jan 01
    then
    Begin
     SaveDiagnostic(RetNo, 'INFO', 145,'W-----------'); // 220250307
     SaveDiagnostic(RetNo, S6Frm, 145,'W-S6-CWB This return may be eligible for CWB as per CRA Questionnaire.');
     SaveDiagnostic(RetNo, S6Frm, 66,'W-S6-Please confirm/complete S6 eligibility to activate calculations'); //s6frm
     SaveDiagnostic(RetNo, 'INFO', 145,'W-----------'); // 220250307
    end;
  end;


  //20190504
  If (EligibleForWIB(RetNo) = false)
  and (Ret[RetNo].Lnn[45300]>0)   //20190504
  then
  Begin
      SaveDiagnostic(RetNo, S6Frm, 66, 'E-S6-Not Eigible for CWB. Does not meet the conditions');
      SaveDiagnostic(RetNo, S6Frm, 66, 'E-S6-  such as Age,Residence,more than 13 weeks Full time Student ');
      SaveDiagnostic(RetNo, S6Frm, 66, 'E-S6-  Earned income, Prison, etc');
  End;

  //20260420
  If (FetchElmFNo(RetNo, Fno, 66) > '') //CLAIM IT
  AND (HasEligibleDependantForWIB(RetNo) = True)
  AND (FetchElm(RetNo,'S6',1)+FetchElm(RetNo,'S6',2)='')
  then
  Begin
   SaveDiagnostic(RetNo, S6Frm, 1, 'E-S6-Please complete the eligible dependant Y/N)');
   SaveDiagnostic(RetNo, S6Frm, 2, 'E-S6-Please complete the eligible dependant Y/N)');
  End;

  If FetchElmFNo(RetNo, Fno, 66) > '' then
  begin
    If EligibleForWIB(RetNo) = false then
    Begin
      SaveDiagnostic(RetNo, S6Frm, 66, 'E-S6-Taxpayer does not meet all the CWB conditions (Age,Residence,Prison,Student, Empl Income, etc)');
      //20190408
      StoreElm(RetNo,FNo,66,'');
      StoreElm(RetNo,FNo,67,'X');
    End;

    // 20170120

    If (FetchElmFNo(RetNo, Fno, 1) > '') and (FetchElmFNo(RetNo, Fno, 3) > '')
    then
    begin
      SaveDiagnostic(RetNo, S6Frm, 1, 'W-S6 CWB-One of the boxes should be No, unless both conditions apply ');
      SaveDiagnostic(RetNo, S6Frm, 3, 'W-S6 CWB-One of the boxes should be No, unless both conditions apply');
    end;


    If (FetchElmFNo(RetNo, Fno, 3) = '') and (FetchElmFNo(RetNo, Fno, 4) = '')
    then
    begin
      SaveDiagnostic(RetNo, S6Frm, 3, 'E-S6 CWB-Please complete this box');
      SaveDiagnostic(RetNo, S6Frm, 4, 'E-S6 CWB-Please complete this box');
    end;

    If (FetchElmFNo(RetNo, Fno, 3) > '') and (Ret[RetNo].MarStatus > 2) then
      SaveDiagnostic(RetNo,S6Frm, 3, 'W-S6 Marital status may be incorrect');
  end; // s6
end;



//Procedure ValidateConsent(RetNo: integer; Fno: integer; Inst: String); //20200215
//Var
Procedure ValidateConsent(RetNo: integer; Fno: integer; Inst: String);
Var
  i: integer;
  S: String;
  Dt: TDate; // Inst:String;
  Fname: String;
  AuthorizeSw, CancelSw:Boolean;
Begin
  if FetchElmFNo(RetNo,FNo,66)='' then exit;
  Fname := 'CONSENT' + Inst;
  If Ret[RetNo].FrmHasData[Fno] = false then Exit;
  if FetchElmFno(RetNo,FNo,13)+FetchElmFNo(RetNo,FNo,34)='' then  //20180728
  Begin
    SaveDiagnostic(RetNo,FNAME,13,'E-CONSENT-Please select option: Authorize or Cancel');
  End;


  AuthorizeSw:=FetchElm(RetNo,FNo,13)>'';
  CancelSw:=FetchElm(RetNo,FNo,34)>'';
  if (FetchElm(RetNo,FNo,1)='') then
      SaveDiagnostic(RetNo,FNAME,1,'E-CONSENT-Business Name is required');

  if (FetchElm(RetNo,FNo,2)='') then SaveDiagnostic(RetNo,FNAME,2,'E-CONSENT-Business number is required');
  if Length(FetchElm(RetNo,FNo,2))<>9 then SaveDiagnostic(RetNo,FNAME,2,'E-CONSENT-Business number must be 9 digits');

  //if ValidSin(FetchElm(RetNo,FNo,2))=False then  SaveDiagnostic(RetNo,FNAME,9,'E-CONSENT-Business number is invalid');



  if AuthorizeSw then
  Begin
  //20200211
   if FetchElmFNo(RetNo,FNo,10)+FetchElmFNo(RetNo,FNo,57)+FetchElmFNo(RetNo,FNo,20)='' then
   Begin
      SaveDiagnostic(RetNo,FNAME,10,'E-CONSENT-Please enter Representative information');
      SaveDiagnostic(RetNo,FNAME,57,'E-CONSENT-Please enter Representative information');
      SaveDiagnostic(RetNo,FNAME,20,'E-CONSENT-Please enter Representative information');
   end;

   //20200302
   if (FetchElmFNo(RetNo,FNo,10)>'') and (FetchElmFNo(RetNo,FNo,20)>'') then
   Begin
     SaveDiagnostic(RetNo,FNAME,10,'E-CONSENT-Enter either RepId or Business Number, not both');
     SaveDiagnostic(RetNo,FNAME,20,'E-CONSENT-Enter either RepId or Business Number, not both');
   End;


   //20200924
   if (FetchElmFNo(RetNo,FNo,21)='') then SaveDiagnostic(RetNo,FNAME,21,'E-CONSENT-Area and Phone are required');
   If (FetchElmFNo(RetNo,FNo,27)='') then      SaveDiagnostic(RetNo,FNAME,27,'E-CONSENT-Area and Phone are required');

   if FetchElmFNo(RetNo,FNo,12)+FetchElmFNo(RetNo,FNo,17)='' then //20180824 CON
   Begin
    SaveDiagnostic(RetNo,FNAME,12,'E-CONSENT-Please complete Option 1, or Option 2 Authorization');
    SaveDiagnostic(RetNo,FNAME,17,'E-CONSENT-Please complete Option 1, or Option 2 Authorization');
   End;
   if (FetchElmFNo(RetNo,FNo,10)>'') and (Length(FetchElmFNo(RetNo,FNo,10))<>7) then  //20180728
    SaveDiagnostic(RetNo,FNAME,10,'E-CONSENT-Representative Id must be 7 alhanumeric characters');

   if (FetchElmFNo(RetNo,FNo,12)>'') and (FetchElmFNo(RetNo,FNo,16)='') then  //20180728
        SaveDiagnostic(RetNo,FNAME,16,'E-CONSENT-Select Authorization level 1, 2 or 3');
   //programs
   //if (FetchElm(RetNo,FNo,12)>'') and (FetchElm(RetNo,FNo,16)='') then  //20180728
 End; //authorize

 if CancelSw=True  then
 Begin
  if (FetchElmFNo(RetNo,FNo,34)>'')  //cancel
    and (FetchElmFNo(RetNo,FNo,47)+FetchElmFNo(RetNo,FNo,46)='') then  //20180728
     SaveDiagnostic(RetNo,FNAME,47,'E-CONSENT-Select Cancel All or Specific representative');

  {
  if (FetchElmFNo(RetNo,FNo,47)='') and (FetchElmFNo(RetNo,FNo,48)+FetchElmFNo(RetNo,FNo,50)+FetchElm(RetNo,FNo,49)='') then  //20180728
     SaveDiagnostic(RetNo,FNAME,47,'E-CONSENT-Select Cancel All or Specific representative');
   }
  if (FetchElmFNo(RetNo,FNo,46)>'') then //cancel specific rep  //20200214
  Begin
   If (FetchElmFNo(RetNo,FNo,48)+FetchElmFNo(RetNo,FNo,50)+FetchElm(RetNo,FNo,49)='') then  //20180728
   Begin
    SaveDiagnostic(RetNo,FNAME,48,'E-CONSENT-Select Rep id, Group Id or BN below');
    SaveDiagnostic(RetNo,FNAME,50,'E-CONSENT-Select Rep id, Group Id or BN below');
    SaveDiagnostic(RetNo,FNAME,49,'E-CONSENT-Select Rep id, Group Id or BN below');
   End;

  End;

  if (FetchElmFNo(RetNo,FNo,48)>'') and (FetchElmFNo(RetNo,FNo,45)='') then
    SaveDiagnostic(RetNo,FNAME,45,'E-CONSENT-Enter Name/Surname');
  if (FetchElmFNo(RetNo,FNo,48)>'') and (FetchElmFNo(RetNo,FNo,51)='') then
    SaveDiagnostic(RetNo,FNAME,51,'E-CONSENT-Enter Surname');


  if (FetchElmFNo(RetNo,FNo,49)>'') and (FetchElmFNo(RetNo,FNo,42)='') then
    SaveDiagnostic(RetNo,FNAME,42,'E-CONSENT-Enter Business Name');

 end;

 //Signature
 if FetchElm(RetNo,FNo,41)+FetchElm(RetNo,FNo,35)='' then //20180824 CON
   SaveDiagnostic(RetNo,FNAME,41,'E-CONSENT-Please select who signes');
   //certification

 if FetchElmFNo(RetNo,FNo,55)='' then StoreElm(RetNo,FNo,55,FormatDateTime('yyyy-mm-dd', Date));

 if (FetchElm(RetNo,FNo,12)>'') and (FetchElm(RetNo,FNo,17)>'') then
 Begin
      SaveDiagnostic(RetNo,FNAME,12,'E-CONSENT-Use Option 1 or Option 2');
      SaveDiagnostic(RetNo,FNAME,17,'E-CONSENT-Use Option 1 or Option 2');
 End;
End;

Function AnyT3WithElectionAmount(RetNo:Integer;Amt:Real):Boolean;
Var i:Integer;
Begin
 Result:=False;
 if TotMultiple(RetNo,'T3MULT',76)=Amt then Begin Result:=True;Exit; end;
 if TotMultiple(RetNo,'T3MULT',82)=Amt then Begin Result:=True;Exit; end;
 if TotMultiple(RetNo,'T3MULT',88)=Amt then Begin Result:=True;Exit; end;
 if TotMultiple(RetNo,'T3MULT',100)=Amt then Begin Result:=True;Exit; end; //other income
 i:=94;
 Repeat
   if TotMultiple(RetNo,'T3MULT',i)=Amt then Begin Result:=True;Exit; end;
   Inc(i,6);
 until i>142;
 if TotMultiple(RetNo,'T3MULT',232)=Amt then Begin Result:=True;Exit; end;
End;


Procedure ValidateT1135MaxYearEnd(RetNo: integer; Fno: integer); //20239214
Var
  ArrayNo,BoxesPerRow,i: integer;  //array number
  Elm1,Elm2:Integer;
  S: String;
  Cnt: integer;
Begin
  ArrayNo := 1;
  BoxesPerRow := 5;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Funds held at year end must not exceed Maximum funds during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;
  // second form   I can see the logic now....  So I will contnue  its not hard
  ArrayNo := 2;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: The cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;

  ArrayNo := 3;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Indebtedness owed by non-resident cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;

 ArrayNo := 3;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Indebtedness owed by non-resident cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;

  ArrayNo := 4;
  BoxesPerRow := 7;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Interests in non-resident trusts cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;


 ArrayNo := 5;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Real property outside Canada cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;

 ArrayNo := 6;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Other property outside Canada cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;


 ArrayNo := 7;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Property held in an account with a Canadian registered securities dealer or a Canadian trust company cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;

 end;


 //20180703
Procedure ValidateT1134(RetNo:Integer;Fno:Integer); //20230510 Igor
var ArrayNo, BoxesPerRow, RowCount, I, Elm: integer;
    Value: string;
    UniqueList: TStringList;

    function MandatoryCheck(AElmId: Integer; AError: string): boolean;
    begin
      Result := true;
      If FetchElmFNo(RetNo,FNo,AElmId)='' then
      begin
        SaveDiagnostic(RetNo,'T1134',AElmId,'E-T1134-'+ AError);
        Result := false;
      end;
    end;

    function MandatoryYesNoCheck(AElm1Id, AElm2Id: Integer; AError: string): boolean;
    begin
      Result := true;
      If FetchElmFNo(RetNo,FNo,AElm1Id) + FetchElmFNo(RetNo,FNo,AElm2Id) = '' then
      begin
        SaveDiagnostic(RetNo,'T1134',AElm1Id,'E-T1134-'+ AError);
        Result := false;
      end;
    end;

Begin
  UniqueList := TStringList.Create;
  try
    if Ret[RetNo].FrmHasData[FNo] then
    begin
      MandatoryCheck(25, 'Action is required'); //20230601 Igor
      If FetchElmFNo(RetNo,FNo,31) + FetchElmFNo(RetNo,FNo,32) = '' then
        SaveDiagnostic(RetNo,'T1134',31,'E-T1134-You must specify if the T1134 Summary is filed for one entity or a group');
      MandatoryCheck(30, 'Address number is required');
      MandatoryCheck(15, 'Street Address is required');
      MandatoryCheck(16, 'City is required');
      MandatoryCheck(17, 'Province or territory is required');
      if MandatoryCheck(18, 'Postal or Zip code is required') then
        if not ValidPostal(RetNo, FetchElmFNo(RetNo,FNo,18), FetchElmFNo(RetNo,FNo,141)) then
          SaveDiagnostic(RetNo,'T1134',18,'E-T1134-Postal-Invalid Format of Postal/Zip code, please try again');
      MandatoryCheck(141, 'Country is required');
      If FetchElmFNo(RetNo,FNo,40) + FetchElmFNo(RetNo,FNo,41) + FetchElmFNo(RetNo,FNo,42) + FetchElmFNo(RetNo,FNo,43) = '' then
        SaveDiagnostic(RetNo,'T1134',40,'E-T1134-At least 1 valid NAICS code is required');
      MandatoryCheck(19, 'Taxation Year “From” Date is required');
      MandatoryCheck(20, 'Taxation Year “To” Date is required');
      MandatoryYesNoCheck(21, 22, 'YES or NO is required');

      MandatoryCheck(143, 'First Name is required');
      MandatoryCheck(144, 'Last Name is required');
      If FetchElmFNo(RetNo,FNo,145) + FetchElmFNo(RetNo,FNo,146) = '' then
        SaveDiagnostic(RetNo,'T1134',145,'E-T1134-Telephone Number is required');
      MandatoryCheck(23, 'Certifier Name is required');
      MandatoryCheck(147, 'Date of signature is required');
      MandatoryCheck(148, ' Title of Certifier is required');

      UniqueList.Add(FetchElmFNo(RetNo,FNo,8));

      // individuals check
      ArrayNo := 1;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'First name of Individual within related group is required');
        MandatoryCheck(Elm + 2, 'Initial of Individual within related group is required'); //20230619 Igor
        MandatoryCheck(Elm + 3, 'Last name of Individual within related group is required');
        MandatoryCheck(Elm + 4, 'Address number is required');
        MandatoryCheck(Elm + 5, 'Street is required');
        MandatoryCheck(Elm + 6, 'City is required');
        MandatoryCheck(Elm + 7, 'Province/Territory is required');
        MandatoryCheck(Elm + 8, 'Postal Code is required');
        MandatoryCheck(Elm + 9, 'Country Code is required');
        if MandatoryCheck(Elm + 10, 'SIN is required') then
        begin
          Value := FetchElmFNo(RetNo, FNo, Elm + 10);
          if not ValidSin(Value) then
            SaveDiagnostic(RetNo,'T1134',Elm + 10,'E-T1134-SIN is not valid')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 10,'E-T1134-SIN is already used in the list')
          else
            UniqueList.Add(Value);
        end;

        Elm := Elm + BoxesPerRow;
      end;

      // corporation check
      ArrayNo := 2;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of Corporations within related group is required');
        MandatoryCheck(Elm + 2, 'Address number is required');
        MandatoryCheck(Elm + 3, 'Street is required');
        MandatoryCheck(Elm + 4, 'City is required');
        MandatoryCheck(Elm + 5, 'Province/Territory is required');
        MandatoryCheck(Elm + 6, 'Postal Code is required');
        MandatoryCheck(Elm + 7, 'Country Code is required');

        {//20230801
        if MandatoryCheck(Elm + 8, 'Business Number is required') then
        begin
          Value := FetchElmFNo(RetNo, FNo, Elm + 8);
          if not ValidBusNumber(RetNo, Value) then SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Business Number is not valid')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Business Number is already used in the list')
          else
            UniqueList.Add(Value);
        end;
        }
        if FetchElmFNo(RetNo,FNo,Elm + 9) + FetchElmFNo(RetNo,FNo,Elm + 10) + FetchElmFNo(RetNo,FNo,Elm + 11) + FetchElmFNo(RetNo,FNo,Elm + 12) = '' then
          SaveDiagnostic(RetNo,'T1134',Elm + 9,'E-T1134-At least 1 valid NAICS code is required');

        Elm := Elm + BoxesPerRow;
      end;

      // trust check
      ArrayNo := 3;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of Trusts within related group is required');
        MandatoryCheck(Elm + 2, 'Address number is required');
        MandatoryCheck(Elm + 3, 'Street is required');
        MandatoryCheck(Elm + 4, 'City is required');
        MandatoryCheck(Elm + 5, 'Province/Territory is required');
        MandatoryCheck(Elm + 6, 'Postal Code is required');
        MandatoryCheck(Elm + 7, 'Country Code is required');
        {//20230801
        if MandatoryCheck(Elm + 8, 'Trust Account Number is required') then
        begin
          Value := FetchElmFNo(RetNo, FNo, Elm + 8);
          if not IsValidTrustNo(Value) then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Trust Account Number is not valid')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Trust Account Number is already used in the list')
          else
            UniqueList.Add(Value);
        end;
        }
        if FetchElmFNo(RetNo,FNo,Elm + 9) + FetchElmFNo(RetNo,FNo,Elm + 10) + FetchElmFNo(RetNo,FNo,Elm + 11) + FetchElmFNo(RetNo,FNo,Elm + 12) = '' then
          SaveDiagnostic(RetNo,'T1134',Elm + 9,'E-T1134-At least 1 valid NAICS code is required');

        Elm := Elm + BoxesPerRow;
      end;


      // partnership check
      ArrayNo := 4;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of Partnerships within related group is required');
        MandatoryCheck(Elm + 2, 'Address number is required');
        MandatoryCheck(Elm + 3, 'Street is required');
        MandatoryCheck(Elm + 4, 'City is required');
        MandatoryCheck(Elm + 5, 'Province/Territory is required');
        MandatoryCheck(Elm + 6, 'Postal Code is required');
        MandatoryCheck(Elm + 7, 'Country Code is required');
       {//20230801
        if MandatoryCheck(Elm + 8, 'Partnership''s Number is required') then
        begin
          Value := FetchElmFNo(RetNo, FNo, Elm + 8);
          if not ValidPartnershipNumber(RetNo, Value) then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Partnership''s Number is not valid')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Partnership''s Number is already used in the list')
          else
            UniqueList.Add(Value);
        end;
        MandatoryCheck(Elm + 9, 'Partnership Code is required');
        }
        if FetchElmFNo(RetNo,FNo,Elm + 10) + FetchElmFNo(RetNo,FNo,Elm + 11) + FetchElmFNo(RetNo,FNo,Elm + 12) + FetchElmFNo(RetNo,FNo,Elm + 13) = '' then
          SaveDiagnostic(RetNo,'T1134',Elm + 10,'E-T1134-At least 1 valid NAICS code is required');

        Elm := Elm + BoxesPerRow;
      end;

      // each entity information
      ArrayNo := 5;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Was the entity directly involved in a subsection 85(1) rollover?');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Was the entity directly or indirectly involved in a subsection 85.1(3) transaction?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the entity file a section 86.1 election?');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Was the entity involved in a section 87 amalgamation?');
        MandatoryYesNoCheck(Elm + 10, Elm + 11, 'Was the entity involved in a subsection 88(1) winding up?');

        Elm := Elm + BoxesPerRow;
      end;

      MandatoryYesNoCheck(28, 29, 'Response to If the reporting entity is submitting a group Org chart');

      UniqueList.Clear;

      // related corporation
      ArrayNo := 6;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of related corporation is required');
        MandatoryCheck(Elm + 2, 'Country code of residence of corporation is required');
        Value := FetchElmFNo(RetNo, FNo, Elm + 3);
        if MandatoryCheck(Elm + 3, 'Name of FA is required') then
          if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 3,'E-T1134-Name of FA is already used in the list')
          else
            UniqueList.Add(Value);

        MandatoryCheck(Elm + 5, 'Country code of residence of FA is required');
        MandatoryCheck(Elm + 6, 'Corporation''s equity % in FA is required');
        MandatoryCheck(Elm + 7, 'Corporation''s direct equity % in FA is required');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Supplement NOT filed due to dormancy threshold?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear; //20230601 Igor

      // related affiliate
      ArrayNo := 7;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm + 1);
        if MandatoryCheck(Elm + 1, 'Name of FA is required') then
          if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 1,'E-T1134-Name of FA is already used in the list')
          else
            UniqueList.Add(Value);
        MandatoryCheck(Elm + 3, 'Country code of residence of FA is required');
        MandatoryCheck(Elm + 4, 'Name of other FAs is required');
        MandatoryCheck(Elm + 6, 'Country code of residence of other FAs is required');
        MandatoryCheck(Elm + 7, 'FA''s equity percentage in other FA is required');
        MandatoryCheck(Elm + 8, 'FA''s direct equity percentage in other FA is required');
        MandatoryYesNoCheck(Elm + 9, Elm + 10, 'Supplement NOT filed due to dormancy threshold?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear; //20230601 Igor

      // partner
      ArrayNo := 8;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of partnership within related group is required');
        MandatoryCheck(Elm + 2, 'Address of partner is required');
        MandatoryCheck(Elm + 3, 'Country code of country of residence is required');

        Elm := Elm + BoxesPerRow;
      end;

      // partnership foreign affiliate
      ArrayNo := 9;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Partnership name is required');
        MandatoryCheck(Elm + 2, 'Address of partnership is required');
        MandatoryCheck(Elm + 3, 'Country code of country of residence is required');
        MandatoryCheck(Elm + 4, 'Foreign affiliate is required');
        MandatoryCheck(Elm + 5, 'FA''s interest percentage in the partnership is required');

        Elm := Elm + BoxesPerRow;
      end;

      // dormant foreign affiliate
      ArrayNo := 10;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 2, 'Cost Amount is required');
        MandatoryCheck(Elm + 3, 'Gross receipts is required');
        MandatoryCheck(Elm + 4, 'Gross revenue is required');

        Elm := Elm + BoxesPerRow;
      end;

      // NonControlledForeignAffiliate
      ArrayNo := 11;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm + 1);
        if MandatoryCheck(Elm + 1, 'Name of FA is required') then
          if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 1,'E-T1134-Name of FA is already used in the list')
          else
            UniqueList.Add(Value);

        Elm := Elm + BoxesPerRow;
      end;

    end;
  finally
    UniqueList.Free;
  end;
End;

Procedure ValidateT1134S(RetNo:Integer;Fno,FInst:Integer); //20230510 Igor
var ArrayNo, BoxesPerRow, RowCount, I, J, Elm, Temp, LastElm, FormNo: integer; //20230601 Igor
    FName, Value: string;
    UniqueList, GroupList: TStringList; //20230619 Igor

    function MandatoryCheck(AElmId: Integer; AError: string): boolean;
    begin
      Result := true;
      If FetchElmFNo(RetNo,FNo,AElmId)='' then
      begin
        SaveDiagnostic(RetNo,FName,AElmId,'E-T1134S-'+ AError);
        Result := false;
      end;
    end;

    function MandatoryYesNoCheck(AElm1Id, AElm2Id: Integer; AError: string): boolean;
    begin
      Result := true;
      If FetchElmFNo(RetNo,FNo,AElm1Id) + FetchElmFNo(RetNo,FNo,AElm2Id) = '' then
      begin
        SaveDiagnostic(RetNo,FName,AElm1Id,'E-T1134S-'+ AError);
        Result := false;
      end;
    end;

begin
  FName := 'T1134S#' + IntToStr(FInst);
  If Ret[RetNo].FrmHasData[FNo] then
  Begin
    //20230601 Igor >>>
    MandatoryCheck(3, 'Action is required');
    Value := FetchElmFNo(RetNo,FNo,35);
    For i:=1 to 10 do
    begin
     if i = FInst then continue;
     FormNo:=GetFormNo('T1134S#'+IntToStr(i));
     If FormNo>0 then
       if SameText(FetchElmFNo(RetNo, FormNo, 35), Value) then
       begin
         SaveDiagnostic(RetNo,FName,35,'E-T1134S-Foreing affiliate name is already used in T1134S#'+IntToStr(i));
         break;
       end;
    end;
    //20230601 Igor <<<
    UniqueList := TStringList.Create;
    GroupList := TStringList.Create; //20230619 Igor
    try
      PopulateT1134GroupList(RetNo, GroupList, false); //20230619 Igor
      if (Trim(FetchElmFNo(RetNo,FNo,3))='4') then
        MandatoryCheck(175, 'Reason for the deletion of this supplement must be selected');
      MandatoryCheck(35, 'Name of FA is required');
      MandatoryCheck(36, 'Address of Head Office is required');
      If FetchElmFNo(RetNo,FNo,40) + FetchElmFNo(RetNo,FNo,41) + FetchElmFNo(RetNo,FNo,42) + FetchElmFNo(RetNo,FNo,43) = '' then
        SaveDiagnostic(RetNo,FName,40,'E-T1134S-At least 1 valid NAICS code is required');
      If FetchElmFNo(RetNo,FNo,44) + FetchElmFNo(RetNo,FNo,45) + FetchElmFNo(RetNo,FNo,46) + FetchElmFNo(RetNo,FNo,47) = '' then
        SaveDiagnostic(RetNo,FName,44,'E-T1134S-At least one country code is required for where the foreign affiliate either carries on a business or has other income earning activity');
      If FetchElmFNo(RetNo,FNo,5) + FetchElmFNo(RetNo,FNo,6) + FetchElmFNo(RetNo,FNo,7) + FetchElmFNo(RetNo,FNo,8) = '' then
        SaveDiagnostic(RetNo,FName,5,'E-T1134S-At least one Country code to which income tax was paid/payable is required');
      MandatoryCheck(48, 'The country code of residence for the foreign affiliate is required');
      MandatoryYesNoCheck(1, 2, 'First time the reporting entity has filed form T1134 for this foreign affiliate is required.');
      MandatoryYesNoCheck(49, 50, 'Is it a controlled foreign affiliate as defined in subsection 95(1) is required.');
      MandatoryYesNoCheck(9, 10, ' Does the FA have more than one tax year ended in the RE''s tax year?');

      // direct share holders
      ArrayNo := 1;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        for J in [2,3,4,5] do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + J);
          if not Value.IsEmpty then
            break;
        end;
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-At least one account number is required per row')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 6, 'Year Corporation became a foreign affiliate is required');
        MandatoryYesNoCheck(Elm + 7, Elm + 8, 'Did the corporation cease to be a foreign affiliate of the reporting entity in the year is required');
        MandatoryYesNoCheck(Elm + 9, Elm + 10, 'Was a subsection 93(1) or 93(1.2) election made or will such an election be made for the disposition of shares of the foreign affiliate?');
        if not FetchElmFNo(RetNo,FNo,Elm + 9).IsEmpty then
        begin
          MandatoryCheck(Elm + 11, 'Please provide the actual or estimate amount elected on');
          MandatoryCheck(Elm + 12, 'The currency code of the Elected amount on is required');
        end;

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // common shares
      ArrayNo := 2;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 2, 'Ownership % is required');
        MandatoryCheck(Elm + 3, 'ACB of Common Shares is required');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did the ACB increase at any time during the tax year?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the ACB decrease at any time during the tax year?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // preferred shares
      ArrayNo := 3;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 2, 'Ownership % is required');
        MandatoryCheck(Elm + 3, 'ACB of Preferred Shares is required');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did the ACB increase at any time during the tax year?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the ACB decrease at any time during the tax year?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // foreign affiliate other information
      ArrayNo := 5;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 2, 'Percentage is required');
        MandatoryCheck(Elm + 3, 'Percentage is required');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Qualifying Interest in the FA at beginning of year?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Qualifying Interest in the FA at the end of year?');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Has the gross amount the RE owed to the FA been reported on a T106?');
        if not FetchElmFNo(RetNo,FNo,Elm + 9).IsEmpty then
          MandatoryCheck(Elm + 10, 'Gross amount of debt is required');
        MandatoryYesNoCheck(Elm + 11, Elm + 12, 'Has the gross amount the FA owed to the RE been reported on a T106?');
        if not FetchElmFNo(RetNo,FNo,Elm + 12).IsEmpty then
          MandatoryCheck(Elm + 13, 'Gross amount of debt is required');

        MandatoryYesNoCheck(Elm + 16, Elm + 17, 'Did the reporting entity have a "tracking interest" in this foreign affiliate as defined in subsection 95(8) at any time in the year?');
        MandatoryYesNoCheck(Elm + 18, Elm + 19, 'Was this foreign affiliate a controlled foreign affiliate of the reporting entity because of subsection 95(11)?');
        MandatoryYesNoCheck(Elm + 20, Elm + 21, 'Was this foreign affiliate a controlled foreign affiliate of the reporting entity because of subsection 95(12)?');
        MandatoryYesNoCheck(Elm + 22, Elm + 23, 'Is this reporting entity a party to a joint election under subsection 91(1.4) of the Act?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // foreign dumping rules
      ArrayNo := 6;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Did 212.3(2) apply in respect of an investment in the FA during the year?');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did 212.3(2) not apply in respect of an investment in the FA during the year because of the 75% threshold');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did 212.3(2) not apply in respect of an investment in the FA during the year because of 212.3(16)?');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Did 212.3(2) not apply in respect of an investment in the FA during the year because of 212.3(18)?');
        MandatoryYesNoCheck(Elm + 10, Elm + 11, 'Did any member of the related group file with the Minister the information required in subparagraph 212.3(7)(d)(i) in respect of the FA during the year?');
        MandatoryYesNoCheck(Elm + 12, Elm + 13, 'Was a dividend under 212.3(7)(d)(ii) deemed to have been paid in respect of an investment in the FA in the year?');
        MandatoryYesNoCheck(Elm + 14, Elm + 15, 'Was PUC of any class of shares of the FA increased under 212.3(9) in the year?');
        MandatoryYesNoCheck(Elm + 16, Elm + 17, 'Did the RE make an investment in the year in preferred shares of the FA that are described in subsection 212.3(19)?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      MandatoryCheck(62, 'Taxation year (From) of the FA is required.');
      MandatoryCheck(63, 'Taxation year (To) of the FA is required.');

      MandatoryYesNoCheck(64, 65, 'Does the RE or any member of the related group hold at least 20% of the voting shares in this FA?');
      if not FetchElmFNo(RetNo,FNo, 64).IsEmpty then
        MandatoryYesNoCheck(11, 12, 'Are the unconsolidated FS (including the notes to the FS) available to you as a shareholder at the time this information return is filed?');
      if not FetchElmFNo(RetNo,FNo, 11).IsEmpty then
        MandatoryYesNoCheck(13, 14, 'Have you attached the unconsolidated FS (including notes to the FS) of the FA with this information return?');

      MandatoryYesNoCheck(76, 77, 'Did the reporting entity receive a dividend on a share of the capital stock of the foreign affiliate any time within the taxation year?');

      // exempt surplus
      ArrayNo := 7;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of exempt surplus is required');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // hybrid surplus
      ArrayNo := 8;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of hybrid surplus is required');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // taxable surplus
      ArrayNo := 9;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of taxable surplus is required');
        MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Was any election made pursuant to Regulation 5900(2)?');
        MandatoryYesNoCheck(Elm + 5, Elm + 6, 'Was any election made pursuant to Regulation 5901(1.1)?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // taxable surplus
      ArrayNo := 9;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of taxable surplus is required');
        MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Was any election made pursuant to Regulation 5900(2)?');
        MandatoryYesNoCheck(Elm + 5, Elm + 6, 'Was any election made pursuant to Regulation 5901(1.1)?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // preacquisition surplus
      ArrayNo := 10;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of pre-acquisition surplus is required');
        MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Was any election made pursuant to Regulation 5901(2)(b)?');
        MandatoryYesNoCheck(Elm + 5, Elm + 6, 'Was any election made pursuant to Regulation 5901(2.1)?');
        MandatoryYesNoCheck(Elm + 7, Elm + 8, 'Was any qualifying return of capital (QROC) election made pursuant to Regulation 5911(6) as defined in subsection 90(3)?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      //20230601 Igor >>>
      if not FetchElmFNo(RetNo,FNo, 76).IsEmpty then
      begin
        MandatoryCheck(15, 'Amount of dividends in Cash or in Kind is required');
        MandatoryCheck(16, 'Currency Code is required');
        MandatoryCheck(17, 'Amount of dividend in stock');
        MandatoryCheck(18, 'Currency Code is required');
      end;

      MandatoryYesNoCheck(19, 20, 'Was the FA involved in ant transaction in respect of which 93(1.11)/(1.3) applied?');
	  //20230601 Igor <<<

      // upstream loan rules
      ArrayNo := 11;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Did a "specified debtor" (as defined in subsection 90(15)) in respect of the reporting entity or of any member of the Canadian related group owe an amount to the FA or a partnership of which the FA was a member?');
        if not FetchElmFNo(RetNo,FNo, Elm + 2).IsEmpty then
        begin
          MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did subsection 90(6) apply to that debt?');
          if not FetchElmFNo(RetNo,FNo, Elm + 5).IsEmpty then
            MandatoryYesNoCheck(Elm + 6, Elm + 7, 'If subsection 90(6) did not apply, was that because of subsection 90(8)?');
        end;
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Was the FA an ''eligible bank affiliate'' that is owed an ''upstream deposit''?');
        if not FetchElmFNo(RetNo,FNo, Elm + 8).IsEmpty then
          MandatoryYesNoCheck(Elm + 10, Elm + 11, 'Was the FA deemed to make a loan to a reporting entity under subsection 90(8.1)');
        MandatoryYesNoCheck(Elm + 12, Elm + 13, 'Was the FA involved in an upstream loan arrangement in respect of which a deduction under subsection 90(9) was claimed?');
        MandatoryYesNoCheck(Elm + 14, Elm + 15, 'Was the FA involved in an upstream loan arrangement in respect of which an income inclusion under subsection 90(12) was required?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      if not FetchElmFNo(RetNo,FNo, 49).IsEmpty then
      begin
        MandatoryYesNoCheck(21, 22, 'Was the reporting entity involved in a subsection 88(3) liquidation and dissolution in respect of the FA?');
        if not FetchElmFNo(RetNo,FNo, 21).IsEmpty then
          MandatoryYesNoCheck(23, 24, 'Was a subsection 88(3.1), 88(3.3), or 88(3.5) election made?');
        MandatoryYesNoCheck(25, 26, 'Was the reporting entity involved in a section 51 convertible property exchange in respect of the FA?');

        // transaction involved entity
        ArrayNo := 12;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          //20230619 Igor >>>
          Value := FetchElmFNo(RetNo,FNo,Elm + 2);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
          else
            UniqueList.Add(Value);
          //20230619 Igor <<<

          { //20230601 Igor
          Value := '';
          for J in [3,4,5,6,7] do
            Value := Value + FetchElmFNo(RetNo,FNo,Elm + J);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 3,'E-T1134S-At least one selected checkbox is required');
          }

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        //20230725 //jz
        if not (FetchElmFNo(RetNo,FNo,13).IsEmpty) then
        begin
          SaveDiagnostic(RetNo,FName,13,
          'W-You have selected “Yes” to the question “Unconsolidated Financial Statements attached?” on the T1134 Supplement ' +
          '(section 3). Do you want to submit the supporting documentation electronically? If yes, you must attach the '     +
          ' financial statements of the foreign affiliate file(s).');
        end;


        MandatoryYesNoCheck(27, 28, 'Part II, Section 3(B), Q2 YES or NO is required');

        // foreign affiliate transaction involved entity
        ArrayNo := 13;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + 2);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
          //20230619 Igor >>>
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
          //20230619 Igor <<<
          else
            UniqueList.Add(Value);

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        //20230601 Igor >>>
        if not FetchElmFNo(RetNo,FNo, 27).IsEmpty then
        begin
          MandatoryYesNoCheck(29, 30, 'Was subsection 91(1.1) applicable with respect to the foreign affiliate?');
          MandatoryYesNoCheck(31, 32, 'Was the foreign affiliate involved in any transaction in respect of which paragraph 95(2)(c) was applicable?');
          MandatoryYesNoCheck(33, 34, 'Was the foreign affiliate involved in any transaction in respect of which paragraph 95(2)(d) was applicable?');
          MandatoryYesNoCheck(37, 38, 'Was the foreign affiliate involved in any transaction in respect of which paragraph 95(2)(e) was applicable?');
          MandatoryYesNoCheck(39, 51, 'Was an election filed in respect of the relevant cost base (as defined in subsection 95(4)) of any property of the foreign affiliate pursuant to Regulation 5911(5)?');
        end;
        //20230601 Igor <<<

        // changes in entity and surplus entitlement percentage
        ArrayNo := 14;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + 1);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
          //20230619 Igor >>>
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
          //20230619 Igor <<<
          else
            UniqueList.Add(Value);

          MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Did the reporting entity''s surplus entitlement percentage in this foreign affiliate change?');
          MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did the equity percentage of a foreign affiliate of the reporting entity in respect of this foreign affiliate increase or decrease at any time?');
          MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the equity percentage of this foreign affiliate in respect of another foreign affiliate of the reporting entity increase or decrease at any time?');

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        MandatoryYesNoCheck(52, 53, 'Did the FA dispose of a share in another FA that was excluded property or an interest in a partnership that was excluded property?');
        MandatoryYesNoCheck(54, 55, 'Did the FA dispose of capital property that was excluded property?');
        MandatoryYesNoCheck(56, 57, 'Was the reporting entity or any foreign affiliate of the reporting entity involved in?');

        // other transaction entity list
        ArrayNo := 15;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + 2);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
          //20230619 Igor >>>
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
          //20230619 Igor <<<
          else
            UniqueList.Add(Value);

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        Value := '';
        for J in [60, 61, 66, 67, 68, 69] do
          Value := Value + FetchElmFNo(RetNo,FNo,J);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,60,'E-T1134S-Number of Employees is required');
        MandatoryYesNoCheck(70, 71, 'Did the operator rely on the services?');

        MandatoryYesNoCheck(72, 73, 'Indicate if you are providing a breakdown of each income category between arm''s length and non-arm''s length sources');

        if FetchElmFNo(RetNo,FNo,74) + FetchElmFNo(RetNo,FNo,75) + FetchElmFNo(RetNo,FNo,78) > '' then
          MandatoryCheck(79,'Gross Revenue Currency Code is empty');
        if FetchElmFNo(RetNo,FNo,80) + FetchElmFNo(RetNo,FNo,81) + FetchElmFNo(RetNo,FNo,82) > '' then
          MandatoryCheck(83,'Interest Currency Code is required');
        if FetchElmFNo(RetNo,FNo,84) + FetchElmFNo(RetNo,FNo,85) + FetchElmFNo(RetNo,FNo,86) > '' then
          MandatoryCheck(87,'Dividends Currency Code is required');
        if FetchElmFNo(RetNo,FNo,88) + FetchElmFNo(RetNo,FNo,89) + FetchElmFNo(RetNo,FNo,90) > '' then
          MandatoryCheck(91,'Royalties Currency Code is required');
        if FetchElmFNo(RetNo,FNo,92) + FetchElmFNo(RetNo,FNo,93) + FetchElmFNo(RetNo,FNo,94) > '' then
          MandatoryCheck(95,'Rental & Leasing Currency Code is required');
        if FetchElmFNo(RetNo,FNo,96) + FetchElmFNo(RetNo,FNo,97) + FetchElmFNo(RetNo,FNo,98) > '' then
          MandatoryCheck(99,'Loans or Lending Currency Code is required');
        if FetchElmFNo(RetNo,FNo,100) + FetchElmFNo(RetNo,FNo,101) + FetchElmFNo(RetNo,FNo,102) > '' then
          MandatoryCheck(103,'Insurance or reinsurance Currency Code is required');
        if FetchElmFNo(RetNo,FNo,104) + FetchElmFNo(RetNo,FNo,105) + FetchElmFNo(RetNo,FNo,106) > '' then
          MandatoryCheck(107,'Factoring of trade accounts receivable Currency Code is required');
        if FetchElmFNo(RetNo,FNo,108) + FetchElmFNo(RetNo,FNo,109) + FetchElmFNo(RetNo,FNo,110) > '' then
          MandatoryCheck(111,'Disposition of Investment Property Currency Code is required');

        MandatoryYesNoCheck(250, 251, 'Did the foreign affiliate earn FAPI in any taxation year of the affiliate that ended in the reporting entity''s taxation year?');
        MandatoryYesNoCheck(112, 113, 'Did the foreign affiliate earn FAPL in any taxation year of the affiliate that ended in the reporting entity''s taxation year?');
        MandatoryYesNoCheck(114, 115, 'Did the foreign affiliate earn FAPI from transactions resulting in capital gains in any taxation year of the affiliate that ended in the reporting entity''s taxation year?');
        MandatoryYesNoCheck(116, 117, 'Did the foreign affiliate earn FACL from transactions resulting in capital losses in any taxation year of the affiliate that ended in the reporting entity''s taxation year?');
        MandatoryYesNoCheck(118, 119, 'Did the foreign affiliate apply any FAPL incurred in a previous taxation year in calculating its FAPI incurred in the current taxation year?');
        MandatoryYesNoCheck(120, 121, 'Did the foreign affiliate apply any FACL incurred in a previous taxation year in calculating its FAPI incurred in the current taxation year?');
        MandatoryYesNoCheck(122, 123, 'Did the foreign affiliate apply any current year FAPL in calculating its FAPI incurred in a previous taxation year?');
        MandatoryYesNoCheck(124, 125, 'Did the foreign affiliate apply any current year FACL in calculating its FAPI incurred in a previous taxation year?');
        MandatoryYesNoCheck(126, 127, 'Was an election filed under 95(2.44) in respect of the FA for the year?');

        // reporting entity participation percentage
        ArrayNo := 16;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + 1);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
          //20230619 Igor >>>
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
          //20230619 Igor <<<
          else
            UniqueList.Add(Value);

          MandatoryCheck(Elm + 2, 'Reporting entity (-ies) total participating percentage is required');
          MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Did the participating percentage of the reporting entity or member of the related Canadian group in respect of this FA increase or decrease at any time?');

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        MandatoryYesNoCheck(147, 148, 'Part III, Section 4, Q1 YES or NO is required');
        if not FetchElmFNo(RetNo,FNo,147).IsEmpty then
        begin
          MandatoryYesNoCheck(149, 150, 'Because of subparagraph 95(2)(a)(i) to 95(2)(a)(vi) of the Act?');
          MandatoryYesNoCheck(151, 152, 'Because of type of business carried on… 95(1) of the Act?');
          MandatoryYesNoCheck(153, 154, 'Because of subparagraph 95(2)(I)(i) to (iii) of the Act?');
          //20230601 Igor >>>
          {
          Temp := 0;
          LastElm := 149;
          for J in [149,151,153] do
            if not FetchElmFNo(RetNo,FNo,J).IsEmpty then
            begin
              inc(Temp);
              LastElm := J;
            end;
          if (Temp = 0) or (Temp > 1) then
            SaveDiagnostic(RetNo,FName,LastElm,'E-T1134S-There must be one YES between these three questions');
          }
          //20230601 Igor <<<
        end;
        MandatoryYesNoCheck(155, 156, 'Part III, Section 4, Q2 YES or NO is required');
        if not FetchElmFNo(RetNo,FNo,155).IsEmpty then
        begin
          MandatoryYesNoCheck(157, 158, 'Because of 90% test in paragraphs 95(2)(a.1) through (a.4) of the Act?');
          MandatoryYesNoCheck(159, 160, 'Because of subsection 95(2.3) of the Act?');
          MandatoryYesNoCheck(161, 162, 'Because of subsection 95(2.4) of the Act?');
          MandatoryYesNoCheck(163, 164, 'Because of subsection 95(3)?');
          MandatoryYesNoCheck(165, 166, 'Because of subsection 95(3.01)?');
          //20230601 Igor >>>
          {
          Temp := 0;
          LastElm := 157;
          for J in [157,159,161,163,165] do
            if not FetchElmFNo(RetNo,FNo,J).IsEmpty then
            begin
              inc(Temp);
              LastElm := J;
            end;
          if (Temp = 0) or (Temp > 1) then
            SaveDiagnostic(RetNo,FName,LastElm,'E-T1134S-There must be one YES between these three questions');
          }
          //20230601 Igor <<<
        end;
      end;

      MandatoryYesNoCheck(288, 289, 'Is any information requested in this return not available?');
      if not FetchElmFNo(RetNo,FNo,288).IsEmpty then
      begin
        Value := FetchElmFNo(RetNo,FNo,290) + FetchElmFNo(RetNo,FNo,291) + FetchElmFNo(RetNo,FNo,292) + FetchElmFNo(RetNo,FNo,293);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,290,'E-T1134S- Please specify information not available.');
      end;
    finally
      UniqueList.Free;
    end;
  End;
end;


Procedure ValidateResidencyType(RetNo:integer;s:string); //20240126  s=residencetype such as '1', '2' etc
var FNo,i,T1248FNo:Integer;ss:string; ResSection:String;
begin
 T1248FNo:=GetFormNo('T1248');
 //20240323
 if (FetchElmFNo(RetNo,InfoFNo,238)>'')
 or (FetchElmFNo(RetNo,InfoFNo,253)>'')  //20240324
 or (FetchElm(RetNo,'T1',504)>'')  //17700  //20240426
 or ((getResidencyType(RetNo)='3') and (FetchElmFNo(RetNo,INFOFNO,246)>''))  //20240428C
 or (getResidencyType(RetNo)='7')  //20240515
 then  //NR with Cap gains
 Begin
  if FetchElmFNo(RetNo,InfoFNo,69)='' then        //country on Dec 31
     SaveDiagnostic(RetNo,'INFO',69,'E-INFO-Non Resident: Enter Country on Dec 31'); //20240428C
 End;



 {
 if (s='3') and (ss<>'NON RESIDENT') then
    SaveDiagnostic(RetNo,'INFO',1,'E-INFO-Your Residency type is Non Resident. The taxing Province should also be Non-resident');
 }
 if s='3' then
 Begin
   if (FetchElmFNo(RetNo,InfoFNo,251)='')
   and (FetchElmFNo(RetNo,InfoFNo,252)='')
   and (FetchElmFNo(RetNo,InfoFNo,253)='')
   and (FetchElmFNo(RetNo,InfoFNo,254)='')
   then
   Begin
    for i:=251 to 254 do
    Begin
     SaveDiagnostic(RetNo,'INFO',i,'E-INFO-Residency type is 3 - Select 1, 2, 3 or 4');
    End;
   end;
   if (FetchElmFNo(RetNo,InfoFNo,251)>'')  //1 o2 selected
   or (FetchElmFNo(RetNo,InfoFNo,252)>'')
   //or (FetchElmFNo(RetNo,InfoFNo,244)<>'')  //20240517 Only of N/A is blank show error
   then
   Begin
     if  (FetchElmFNo(RetNo,InfoFNo,237)='')
     and (FetchElmFNo(RetNo,InfoFNo,238)='')
     and (FetchElmFNo(RetNo,InfoFNo,239)='')
     and (FetchElmFNo(RetNo,InfoFNo,240)='')
     and (FetchElmFNo(RetNo,InfoFNo,241)='') then
     Begin
       for i:=237 to 241 do
         SaveDiagnostic(RetNo,'INFO',i,'E-INFO-Residency type is 3 (1 or 2).Select one of the 5 sections'); //20240331
     End;
   End;

   ResSection:=GetResidencySection(RetNo);  //20240229  ResSection instead of S
   if ResSection>'' then
   Begin
    If IsSection116(RetNo) then     //20240214  Capital gains ony    //20240428C
    begin
     if Ret[RetNo].Lnn[15000]<>Ret[retNo].Lnn[12700] then //22230214
     Begin
     if Ret[RetNo].Lnn[15000]<>Ret[retNo].Lnn[12700] then //22230214
      Begin
      SaveDiagnostic(RetNo,'TAXSUM',63,'E-INFO-NR Section 116. Report only on line 12700 or paper file it');
      end;
     end;
    end;

   If ResSection='216' then
   begin
    if Ret[RetNo].Lnn[15000]<>Ret[retNo].Lnn[12600] then //22230214
     SaveDiagnostic(RetNo,'INFO',239,'E-INFO-NR Section 216. The only income allowed is Rental Income');
   end
   Else
    SaveDiagnostic(RetNo,'INFO',0,'W-Section '+S+' is an Efile exclusion. You must Paper file it');
  End;
 End //s=3
 Else
 begin
   for i:=251 to 254 do begin StoreElm(RetNo,InfoFNo,i,'');end;
   for i:=237 to 241 do begin StoreElm(RetNo,InfoFNo,i,'');end;
 end;

 if (FetchElmFNo(RetNo, INFOFNo, 93) > '') and (s<>'3') then
     SaveDiagnostic(RetNo,'INFO',1,'E-INFO-Residency type selection must be Non Resident');

 if (FetchElmFNo(RetNo, InfoFNo, 94) > '') and (s<>'3') then
     SaveDiagnostic(RetNo,'INFO',1,'E-INFO-Residency type selection must be Non Resident');

 (* //20260317
 //20260315
 If (FetchElmFNo(RetNo,InfoFNo, 253)>'')  //deemed 183 days
// Or (FetchElmFNo(RetNo,InfoFNo, 254)>'')  //deemed other
 then
 begin
  If UpperCase(FetchElmFNo(RetNo, InfoFNo, 1))='NON RESIDENT' then
  begin
    SaveDiagnostic(RetNo,'INFO',1,'M-INFO-For Deemed residents click Type (1) Canadian Resident'); //20240513
    SaveDiagnostic(RetNo,'INFO',1,'M-INFO- and select a Canadian Taxing Province'); //20240513
   end;
 end;
 *)

 if s='4' then //immigrant
 begin
  if (FetchElmFNo(RetNo,InfoFNo,26)='') or (FetchElmFNo(RetNo,InfoFNo,25)='') then
  begin
    SaveDiagnostic(RetNo,'INFO',26,'E-INFO-Residency Type is Immigrant. Please complete Date of Entry');
    SaveDiagnostic(RetNo,'INFO',25,'E-INFO-Residency Type is Immigrant. Please complete Date of Entry');
  end;
 end;

 if s='5' then //Emigrant
 begin
  if (FetchElmFNo(RetNo,InfoFNo,28)='') Or (FetchElmFNo(RetNo,InfoFNo,27)='')then
  Begin
    SaveDiagnostic(RetNo,'INFO',28,'E-INFO-Residency Type is Emigrant. Please complete fully Date of Departure');
    SaveDiagnostic(RetNo,'INFO',27,'E-INFO-Residency Type is Emigrant. Please complete fully Date of Departure');
  End;

  if (FetchElmFNo(RetNo,InfoFNo,171)>'') then //moved to new province //20240410
    SaveDiagnostic(RetNo,'INFO',171,'E-INFO-Emigrant: Remove the new province info');

  if (FetchElmFNo(RetNo,InfoFNo,66)>'') then //moved to new province //20240410
    SaveDiagnostic(RetNo,'INFO',171,'E-INFO-Emigrant: Remove the new province info');
 end; //emigrant

 //reverse check
  if (S<>'4') and ((FetchElmFNo(RetNo,InfoFNo,26)>'') or (FetchElmFNo(RetNo,InfoFNo,25)>'')) then
  begin
    SaveDiagnostic(RetNo,'INFO',26,'E-INFO-Residency Type is not Immigrant. Please remove Date of Entry');
    SaveDiagnostic(RetNo,'INFO',25,'E-INFO-Residency Type is not Immigrant. Please remove Date of Entry');
  end;

  if (S<>'5') and ((FetchElmFNo(RetNo,InfoFNo,28)>'') or (FetchElmFNo(RetNo,InfoFNo,27)>'')) then
  begin
    SaveDiagnostic(RetNo,'INFO',28,'E-INFO-Residency Type is not Emigrant. Please remove Date of Departure');
    SaveDiagnostic(RetNo,'INFO',27,'E-INFO-Residency Type is not Emigrant. Please remove Date of Departure');
  end;
end;

//20251223 Igor >>>
procedure ValidateT106(RetNo: Integer);
var
  s: string;
  i, T106FNo: Integer;
begin
  T106FNo:= GetFormNo('T106');

  if not UpperCase(FetchElmFNo(RetNo, T106FNo, 61)).Equals('Y') then Exit;

  //Section 1- Reporting Person/Partnership Identification ----------------------
  if FetchElmFNo(RetNo, T106FNo, 5).Equals('') then SaveDiagnostic(RetNo, 'T106', 5, 'E-T106-Summary Information Section 1, Corporation Name required');
  if FetchElmFNo(RetNo, T106FNo, 6).Equals('') then SaveDiagnostic(RetNo, 'T106', 6, 'E-T106-Summary Information Section 1, Business Number required');
  if FetchElmFNo(RetNo, T106FNo, 23).Equals('') then SaveDiagnostic(RetNo, 'T106', 23, 'E-T106-Street Address is required');
  if FetchElmFNo(RetNo, T106FNo, 24).Equals('') then SaveDiagnostic(RetNo, 'T106', 24, 'E-T106-Summary - City is required”');
  if FetchElmFNo(RetNo, T106FNo, 25).Equals('') then SaveDiagnostic(RetNo, 'T106', 25, 'E-T106-Summary - Province or territory is required');
  if FetchElmFNo(RetNo, T106FNo, 26).Equals('') then SaveDiagnostic(RetNo, 'T106', 26, 'E-T106-Summary - Postal or Zip code is required');
  if FetchElmFNo(RetNo, T106FNo, 2).Equals('') then SaveDiagnostic(RetNo, 'T106', 2, 'E-Summary - Country is required');

  //Section 2 – Summary Information ---------------------------------------------
  //'Summary – Section 2, Question 1: Taxation Year “To” and "From" Date required'
  s:= FetchElmFNo(RetNo, T106FNo, 29) + FetchElmFNo(RetNo, T106FNo, 30);
  if s.Equals('') then SaveDiagnostic(RetNo, 'T106', 39, 'E-T106-Summary – Section 2, Question 2: Yes or No is required for “Is this the first time you have filed a T106 form?');
  if not FetchElmFNo(RetNo, T106FNo, 30).Equals('') and FetchElmFNo(RetNo, T106FNo, 31).Equals('') then SaveDiagnostic(RetNo, 'T106', 31, 'E-T106-Summary – Section 2, Question 2: Date of last tax year/fiscal period end reporting person/partnership filed a T106 is required');
  if (Vl(FetchElmFNo(RetNo, T106FNo, 32)) = 0) then SaveDiagnostic(RetNo, 'T106', 32, 'E-T106-Summary – Section 2: T106 slips need to be prepared');

  s:= FetchElmFNo(RetNo, T106FNo, 35) + FetchElmFNo(RetNo, T106FNo, 36) + FetchElmFNo(RetNo, T106FNo, 37) + FetchElmFNo(RetNo, T106FNo, 38);
  if s.Equals('') then SaveDiagnostic(RetNo, 'T106', 35, 'E-T106-Summary – Section 2: At least 1 NAICS code is required');

  s:= FetchElmFNo(RetNo, T106FNo, 39) + FetchElmFNo(RetNo, T106FNo, 40);
  if s.Equals('') then SaveDiagnostic(RetNo, 'T106', 39, 'E-T106-Summary – Section 2, Question 7: Yes or No is required');

  //'Summary – Section 2, Question 8: Yes or No is required', 'Summary – Section 2, Question 9.1: Yes or No is required'
  if not FetchElmFNo(RetNo, T106FNo, 66).Equals('') and FetchElmFNo(RetNo, T106FNo, 67).Equals('') then
    SaveDiagnostic(RetNo, 'T106', 67, 'E-T106-Summary – Section 2, Question 9.2: Country Code is required');

  //'Summary – Section 2, Question 10.1: Name of the MNE group'
  if not FetchElmFNo(RetNo, T106FNo, 68).Equals('') and FetchElmFNo(RetNo, T106FNo, 73).Equals('') then
    SaveDiagnostic(RetNo, 'T106', 73, 'E-T106-Summary – Section 2, Question 10.2: Name of the MNE group is required');

  //'Summary – Section 2, Question 10.3: Yes or No is required'
  if not FetchElmFNo(RetNo, T106FNo, 70).Equals('') and FetchElmFNo(RetNo, T106FNo, 72).Equals('') then
    SaveDiagnostic(RetNo, 'T106', 72, 'E-T106-Summary – Section 2, Question 10.4: Jurisdiction where the CbCR is filed is required');

  if not FetchElmFNo(RetNo, T106FNo, 45).Equals('') and (FetchElmFNo(RetNo, T106FNo, 47) + FetchElmFNo(RetNo, T106FNo, 48)).Equals('') then
  begin
    SaveDiagnostic(RetNo, 'T106', 47, 'E-T106 - At least one account number is required');
    SaveDiagnostic(RetNo, 'T106', 48, 'E-T106 - At least one account number is required');
  end;

  s:= FetchElmFNo(RetNo, T106FNo, 47) + FetchElmFNo(RetNo, T106FNo, 48) + FetchElmFNo(RetNo, T106FNo, 74) + FetchElmFNo(RetNo, T106FNo, 75) + FetchElmFNo(RetNo, T106FNo, 76) + FetchElmFNo(RetNo, T106FNo, 77);

  if not FetchElmFNo(RetNo, T106FNo, 45).Equals('') and s.Equals('') then SaveDiagnostic(RetNo, 'T106', 47, 'E-T106-Enter primary account(s)');
  for i:= 53 to 59 do if FetchElmFNo(RetNo, T106FNo, i).Equals('') then SaveDiagnostic(RetNo, 'T106', i, 'E-T106-Full Certification data are required');
end;

procedure ValidateT106SL(RetNo: Integer);
var
  i, SlipFNo: Integer;
  SlFName: string;
begin
  if not UpperCase(FetchElm(RetNo, 'T106', 61)).Equals('Y') then Exit;

  for i:= 0 to pred(FList.Count) do
  begin
    FRec:= FList.Items[i];

    if Frec.FormName.Equals('T106SL') then
    begin
      if Ret[RetNo].FrmHasData[FRec.FormNo] = True then
      begin
        SlFName:= FRec.FormName + Frec.FormInst;
        SlipFNo:= FRec.FormNo;

        if not FetchElmFNo(RetNo, SlipFNo, 10).Equals('') then ValidateAT106Slip(RetNo, SlFName, SlipFNo);
      end;
    end;
  end;
end;

procedure ValidateAT106SLip(RetNo: Integer; SlFName: string; SlipFNo: Integer);
var
  i: Integer;
  s: string;
begin
  if not FetchElmFNo(RetNo, SlipFNo, 10).Equals('') then
  begin
    if FetchElmFNo(RetNo, SlipFNo, 110).Equals('') then SaveDiagnostic(RetNo,SlFName,110,'E-T106 Slip - Enter action code'); //action
    if LeftStr(FetchElmFNo(RetNo, SlipFNo, 110), 1).Equals('4') and FetchElmFNo(RetNo, SlipFNo, 175).Equals('') then //delete slip and //delete reason
      SaveDiagnostic(RetNo, SlFName, 175, 'E-T106 Slip - Enter reason for deleting Country code');
    if FetchElmFNo(RetNo, SlipFNo, 10).Equals('') then SaveDiagnostic(RetNo, SlFName, 10, 'E-T106 Slip - Enter Non resident Name');
    if FetchElmFNo(RetNo, SlipFNo, 11).Equals('') then SaveDiagnostic(RetNo, SlFName, 11, 'E-T106 Slip - Residence address is required');
    if FetchElmFNo(RetNo, SlipFNo, 13).Equals('') then SaveDiagnostic(RetNo, SlFName, 13, 'E-T106 Slip - Country Code is required');
    if (FetchElmFNo(RetNo, SlipFNo, 19) + FetchElmFNo(RetNo, SlipFNo, 20) + FetchElmFNo(RetNo, SlipFNo, 21) + FetchElmFNo(RetNo, SlipFNo, 22)).Equals('') then SaveDiagnostic(RetNo, SlFName, 19, 'E-T106 Slip - At least 1 valid NAICS code is required');
    if (FetchElmFNo(RetNo, SlipFNo, 24) + FetchElmFNo(RetNo, SlipFNo, 25) + FetchElmFNo(RetNo, SlipFNo, 26) + FetchElmFNo(RetNo, SlipFNo, 27)).Equals('') then SaveDiagnostic(RetNo, SlFName, 24, 'E-T106 Slip - At least 1 Country Code is required');
    if (FetchElmFNo(RetNo, SlipFNo, 17) + FetchElmFNo(RetNo, SlipFNo, 18)).Equals('') then SaveDiagnostic(RetNo, SlFName, 17, 'E-T106 Slip -  "Is the non-resident treated differently for tax purposes in its jurisdiction of residency than the classification in question 4?" is required');
    if not FetchElmFNo(RetNo, SlipFNo, 17).IsEmpty then SaveDiagnostic(RetNo, SlFName, 17, 'W-T106 Slip - You have selected “Yes” “the question “if (1), is the non-resident in a country with which Canada does not have ' +
      'a tax treaty?” on the T106 Slip (Part II, question 3). Do you want to submit the supporting documentation ' +
      'electronically? If yes, you must attach the financial statements of the non-resident file(s) now.');

    s:= FetchElmFNo(RetNo, SlipFNo, 185) + FetchElmFNo(RetNo, SlipFNo, 186) + FetchElmFNo(RetNo, SlipFNo, 187) + FetchElmFNo(RetNo, SlipFNo, 188) + FetchElmFNo(RetNo, SlipFNo, 189);
    if s.Equals('') then SaveDiagnostic(RetNo,SlFName,185,'E-T106 Slip - “Type of non-resident under foreign law governing the non-resident” is required.');

    s:= FetchElmFNo(RetNo, SlipFNo, 14) + FetchElmFNo(RetNo, SlipFNo, 15) + FetchElmFNo(RetNo, SlipFNo, 16) + FetchElmFNo(RetNo, SlipFNo, 190);
    if s.Equals('') then SaveDiagnostic(RetNo, SlFName, 14, 'E-T106 Slip - Type of Relationship is required');

    s:= FetchElmFNo(RetNo, SlipFNo, 28) + FetchElmFNo(RetNo, SlipFNo, 29);
    if s.Equals('') then SaveDiagnostic(RetNo, SlFName, 28, 'E-T106 Slip - Please select Yes or No');

    s:= FetchElmFNo(RetNo, SlipFNo, 30) + FetchElmFNo(RetNo, SlipFNo, 31);
    if s.Equals('') then SaveDiagnostic(RetNo, SlFName, 30, 'E-T106 Slip - Please select Yes or No');
  end;
end;
//20251223 Igor <<<



//jz//20260421//CCAv11
procedure checkT776CCALoss(RetNo:integer);
type
   TT776errors =  record
     //errorfNo : integer;
     errorfName : string;
     errorElm   : integer;
     errorAmt   : real;
   end;
const
  AllocToBStatementElm : array[1..3] of integer = (215, 221, 227);
  AmtToBStatementElm   : array[1..3] of integer = (218, 224, 230);
var
  i,j,k:integer;
  FInst:string;
  fNo,fElm:integer;
  fName:string;
  TotalT776IncomeBeforeCCA, TotalT776CCAClaimed: real;
  eElms : TArray<TT776errors>;//array of TT776errors;
  CCAReduceAmt:real;
  diagnosticMsg:string;
begin
  //jz//20260421//CCAv12 - ASSETSB and AUTOS T776 CCA MAX ======================
  TotalT776IncomeBeforeCCA  :=GetTotalT776IncomeBeforeCCA(RetNo); //elm 100 on T776
  TotalT776CCAClaimed       :=GetTotalT776CCAClaimed(RetNo);      //20260421
  if (TotalT776IncomeBeforeCCA<0) or                              //there is already overall loss regardless of any CCA
     (TotalT776IncomeBeforeCCA-TotMultiple(RetNo, 'T776',105)<0)  //overall CCA causes over all loss
  then
  begin
      SetLength(eElms, 1);

      //if already loss or CCA created loss find T776 CCA entries and load into array
      for k := 1 to 2 do // once for assetsb, once for autos
      begin
        for i := 1 to 20 do // for 20 instances
        begin
            FInst := '#' + AllTrim(IntToStr(i));
            if k=1 then begin fNo := GetFormNo('ASSETSB' + FInst); fName:=  'ASSETSB' + FInst; fElm:= 8; end
                   else begin fNo := GetFormNo('AUTOS'   + FInst); fName:=  'AUTOS'   + FInst; fElm:= 3; end;

            If Fno > 0 then // 20101020
            begin
              If (Ret[RetNo].FrmHasData[Fno]) and
                 (pos('T776', ( FetchElmFNo(RetNo, fNo, AllocToBStatementElm[1]) +   // if alloc to T776
                                FetchElmFNo(RetNo, fNo, AllocToBStatementElm[2]) +
                                FetchElmFNo(RetNo, fNo, AllocToBStatementElm[3])
                               )
                     ) > 0
                 )
              then
              begin
                for j := low(AllocToBStatementElm) to high(AllocToBStatementElm)  do
                begin
                  if ( pos('T776', FetchElmFNo(RetNo, fNo, AllocToBStatementElm[j])) > 0 ) and    //alloc is to T776
                     ( vl(FetchElmFNo(RetNo, fNo, AmtToBStatementElm[j])) > 0 )                   //alloc amount is more than 0
                  then
                  begin
                    SetLength(eElms, length(eElms) + 1);
                    eElms[high(eElms)].errorfName := fName;
                    eElms[high(eElms)].errorElm   := AmtToBStatementElm[j];
                    eElms[high(eElms)].errorAmt   := vl(FetchElmFNo(RetNo, fNo, AmtToBStatementElm[j]));
                  end;
                end;
              end;
            end;
        end; //for 20 instances
      end; //k

      //sort errorElms
      TArray.Sort<TT776errors>(eElms, TComparer<TT776errors>.Construct(
        function(const Left, Right: TT776errors): integer
        begin
          if      Left.errorAmt < Right.errorAmt then Result :=  1
          else if Left.errorAmt > Right.errorAmt then Result := -1
          else    Result := 0;
        end));

      CCAReduceAmt:= abs(TotalT776IncomeBeforeCCA - TotalT776CCAClaimed);
      if TotalT776IncomeBeforeCCA < 0 then
      begin
        diagnosticMsg:= 'E-T776-NO CCA claim is allowed when total T776 income is already negative.' +
                        Chr(13)+' '+
                        Chr(13)+'Remove all CCA allocated to any T776 statements from ASSETSB or AUTO items.'+
                        Chr(13)+'You may adjust T776 CCA to ZERO by adjusting:' +
                        Chr(13)+' - the % allocated to T776'     +
                        Chr(13)+' - the amount claimed'          +
                        Chr(13)+' - Col 21 with overrride';
      end
      else
      begin
        diagnosticMsg:= 'E-T776-Total Rental CCA taken is ' + ' $'+Formatfloat('#,###,###.##',TotalT776CCAClaimed)+', creating a loss.'  +
                        Chr(13)+' '+
                        Chr(13)+'Total T776 loss cannot be created by CCA.'+
                        Chr(13)+'Reduce any CCA claim from any ASSETSB or AUTO items allocated to any T776 by $'+Formatfloat('#,###,##0.##',CCAReduceAmt) +
                        Chr(13)+'You can start with big items such as buildings' +
                        Chr(13)+'To reduce T776 CCA you may change:'      +
                        Chr(13)+' - the % allocated to T776'              +
                        Chr(13)+' - the amount claimed with overrride'    +
                        Chr(13)+' - Col 21 with overrride'                +
                        Chr(13)+'REMOVE OTHER OVERRIDES YOU MAY HAVE ENTERED. See overrides on the left panel';
      end;

      //post errors in order
      for i := low(eElms) to high(eElms) do
      begin
        if  eElms[i].errorfName > '' then
        begin
                  //20260421CZ
                  SaveDiagnostic(RetNo,eElms[i].errorfName, eElms[i].errorElm, diagnosticMsg);
                  //SaveDiagnostic(RetNo,fName, fElm,'E-T776-TOTAL loss created bty CCA. Reduce TOTAL CCA claimed from any ASSETSB or AUTO item.');
        end;
      end;
  end; //if there is loss or CCA created loss
end;

end.
