unit T1_2026Calc1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,{$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON},
  T1_2026Declare, T1_2026common, T1_2026common2, T1_2026TrimStr, T1_2026T1Rtns,
  T1_2026calc2, T1_2026T1Rtns2; //20160119 Igor //20240305

  //20241110
  procedure LN61545(RetNo:integer;FName:string;FNo:integer);

  //20191127
  procedure T657(RetNo:integer;FName:string;FNo:integer);  //20240305
  procedure T1248(RetNo: integer; FName: String;FNo: integer); //20240112
  procedure T1279(RetNo: integer; FName: String;FNo: integer);
  procedure AssetsB(RetNo: integer; FName: string; FNo: integer);  //20230211
  procedure NS479(RetNo:integer;FName:string;FNo:integer);  //20221211
  //  procedure T1B(RetNo: integer; FName: String;FNo: integer); //20190208
  procedure SK479(RetNo:integer;FName:string;FNo:integer);  //20211229
  procedure NL479(RetNo:integer;FName:string;FNo:integer);  //20211123
  procedure T89(RetNo: integer; FName: String;FNo: integer); //20190208
  procedure T90(RetNo: integer; FName: String;FNo: integer);
  procedure T224(RetNo: integer; FName: String;FNo: integer);
  procedure T225(RetNo: integer; FName: String;FNo: integer);
  procedure T1204(RetNo: integer; FName: String;FNo: integer);
  procedure BCDON(RetNo:integer;FName:string;FNo:integer);  //20201129
  procedure NS5804(RetNo:integer;FName:string;FNo:integer);  //20181123
  procedure NS5812(RetNo:integer;FName:string;FNo:integer);  //20181128
  procedure NS5816(RetNo:integer;FName:string;FNo:integer);  //20181128
  procedure OEPTC(RetNo:integer;FName:string;FNo:integer); //20120125
  procedure T1272(RetNo: integer; FName: String;FNo: integer);
  procedure S3ACB(RetNo: integer; FName: String;FNo: integer);
  //       procedure T746(RetNo: integer; FName: String;FNo: integer);
  procedure T1161(RetNo: integer; FName: String;FNo: integer);
  procedure T1243(RetNo: integer; FName: String;FNo: integer);
  procedure NSLS(RetNo: integer; FName: String;FNo: integer);
  procedure T79(RetNo: integer; FName: String;FNo: integer);
  procedure DIAGNO(RetNo: integer; FName: String;FNo: integer);
  procedure GetPriorYearYSum(RetNo, FNo: Integer; FromDir, FlName: String; TempList, LinesList, ValueList: TStringList; FromElm, ToElm, Yr: Integer);
  // Procedure T1139(RetNo:integer;FName:string;FNo:integer);
  procedure T1139(RetNo:integer;FName:string;FNo:integer);
  procedure T1159(RetNo: integer; FName: String;FNo: integer);
  Procedure YRSUM(RetNo: integer; FName: String;FNo: integer);
  procedure POLIT(RetNo: integer; FName: String;FNo: integer);
  procedure ON428(RetNo:integer;FName:string;FNo:integer);
  procedure ON428A(RetNo:integer;FName:string;FNo:integer);
  procedure ON479(RetNo:integer;FName:string;FNo:integer);
  procedure ON479A(RetNo:integer;FName:string;FNo:integer);
  procedure ONBEN(RetNo:integer;FName:string;FNo:integer);
  procedure BC479(RetNo:integer;FName:string;FNo:integer);
  procedure BC428(RetNo:integer;FName:string;FNo:integer);
  procedure NB428(RetNo:integer;FName:string;FNo:integer);
  procedure NL428(RetNo:integer;FName:string;FNo:integer);
  procedure NT428(RetNo:integer;FName:string;FNo:integer);
  procedure NT479(RetNo:integer;FName:string;FNo:integer);
  procedure PE428(RetNo:integer;FName:string;FNo:integer);
  procedure MB479(RetNo:integer;FName:string;FNo:integer);
  procedure MB428(RetNo:integer;FName:string;FNo:integer);
  procedure MB428WS(RetNo: Integer; FName: string; FNo: Integer); //20250918 Igor
  procedure MB428A(RetNo:integer;FName:string;FNo:integer);
  procedure MBMJA(RetNo:integer;FName:string;FNo:integer);  //20190205
  procedure SK428(RetNo:integer;FName:string;FNo:integer);
  procedure YT428(RetNo:integer;FName:string;FNo:integer);
  procedure YT479(RetNo:integer;FName:string;FNo:integer);
  procedure AB428(RetNo:integer;FName:string;FNo:integer);
  procedure NS428(RetNo:integer;FName:string;FNo:integer);
  procedure NU428(RetNo:integer;FName:string;FNo:integer);
  procedure NU479(RetNo:integer;FName:string;FNo:integer);
  procedure YT432(RetNo:integer;FName:string;FNo:integer);
  procedure T101(RetNo: integer; FName: String;FNo: integer);
  procedure T102(RetNo: integer; FName: String;FNo: integer);
  procedure T1206(RetNo: integer; FName: String;FNo: integer);
  procedure T1285(RetNo: integer; FName: String;FNo: integer);
  //jz//20260328//MJCERT2025 - NOT USED???? MOVED TO CalcMJ2  >>>>>>>>>>>>>>>>>>
  {
  procedure ABMJ(RetNo: integer; FName: String; FNo: integer);
  procedure BCMJ(RetNo: integer; FName: String; FNo: integer);
  procedure MBMJ(RetNo: integer; FName: String; FNo: integer);
  //   Procedure NBMJ(RetNo: integer; FName: String; FNo: integer); //20250425
  procedure NLMJ(RetNo: integer; FName: String; FNo: integer);
  procedure ONMJ(RetNo: integer; FName: String; FNo: integer);

  procedure NSMJ(RetNo: integer; FName: String; FNo: integer);
  procedure NTMJ(RetNo: integer; FName: String; FNo: integer);
  procedure NUMJ(RetNo: integer; FName: String; FNo: integer);
  procedure PEMJ(RetNo: integer; FName: String; FNo: integer);
  procedure SKMJ(RetNo: integer; FName: String; FNo: integer);
  // Procedure YTMJ(RetNo: integer; FName: String; FNo: integer);  //duplicate 20241122
  }
  //jz//20260328//MJCERT2025 - NOT USED???? MOVED TO CalcMJ2  <<<<<<<<<<<<<<<<<<

implementation

uses
  vtCommon, T1_2026, T1_2026Calc,T1_2026CalcBus, vtTrimStr, vtShared,
  T1_2026Calc3 //jz//20260327//MJCERT2025
  ;

//leave it first - easier to debug / find things for On428

//20250918 Igor >>>
procedure ON428(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
  SpRetNo, WhichRetNo: Integer;
  Txbl: Real;
  SurtaxBase1, SurTaxBase2, DepCredit: Real;
  NormalPrvNonRefAmount:Real;
begin
  InitPrvConstants('ON');
  LoadTv(RetNo, FName, FNo);

  if (not CalcThisProvince(RetNo, 'ON'))
	  // and (IsSection115(RetNo)=False)  //20260408
	  //(Uppercase(FetchElmFNo(RetNo,InfoFNo,249))<>'ON')  //20260408 //not Nr with Empl incom
	  // Or (NonResWithEmpl(retNo)=True)    //20230415             not effective  
  then 
  begin
    for i:= 1 to 162 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    for i:= 117 to 124 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end; //20140813

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= ret[RetNo].Lnn[26000];

    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 156 to 162 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 117 to 124 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end; //20140813

    {$region ' Top table '}
    Frm[FNo].Strings[11]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13]:= PrvConstant[RY].PrvRate3;
    Frm[FNo].Strings[159]:= PrvConstant[RY].PrvRate4;
    Frm[FNo].Strings[120]:= PrvConstant[RY].PrvRate5;  //20140813

    Tv[5]:= 0;
    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[157]:= PrvConstant[RY].PrvBracket3;
    Tv[118]:= PrvConstant[RY].PrvBracket4;  //20140813
    Tv[17]:= 0;
    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;
    Tv[161]:= PrvConstant[RY].PrvBracketTax4;
    Tv[123]:= PrvConstant[RY].PrvBracketTax5;  //20140813

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:= 0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket3) and (Tv[1] <= PrvConstant[RY].PrvBracket4) then     //20140813
    begin
      Tv[156]:= Tv[1];
      Tv[157]:= PrvConstant[RY].PrvBracket3;
      Tv[158]:= MaxR(0, Tv[156] - Tv[157]);
      Tv[160]:= Tv[158] * Vl(Frm[FNo].Strings[159]) / 100;
      Tv[161]:= PrvConstant[RY].PrvBracketTax4;
      Tv[162]:= Tv[160] + Tv[161];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket4) then
    begin
      Tv[117]:= Tv[1];
      Tv[118]:= PrvConstant[RY].PrvBracket4;
      Tv[119]:= MaxR(0, Tv[117] - Tv[118]);
      Tv[121]:= Tv[119] * Vl(Frm[FNo].Strings[120]) / 100;
      Tv[123]:= PrvConstant[RY].PrvBracketTax5;
      Tv[124]:= Tv[121] + Tv[123];
    end;
    {$endregion ' Top table '}

    Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear;
    Tv[24]:= MinR(PrvConstant[RY].PrvMaxAgeAmount, Vl(FetchElm(RetNo, 'AGEDED', 17))); //20250922 //20251124
    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear; //20100616
    //Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount;  //20090109

    Tv[26]:= SpouseIncome(RetNo);
    if TosiInEffect(RetNo) then Tv[26]:= GetSpouseTosiNetIncome(RetNo, InfoFNo);   //20181227

    //Tv[28]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[25] - Tv[26]));
    Tv[28]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo))); //20250922 Igor // CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo))); //20221209

    if (UpperCase(Frm[FNo].Strings[64]) = 'Y') then Tv[28]:= Tv[65];

    Tv[27]:= Tv[28];
    //20101111
    Tv[100]:=0;if HasEligibleDependant(RetNo) then  //20251124
      Tv[100]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;//PrvConstant[RY].PrvSpouseBasicAmount;  //20141128

    Tv[99]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
    Tv[29]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[100] - Tv[99]));//20250922 Igor // Vl(FetchElm(RetNo, 'S5PRV', 10));
    Tv[98]:= Tv[29];
    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 98)); //20171128
    Tv[115]:= Tv[23] + Tv[24] + Tv[27] + Tv[98] + Tv[30];  //20201213
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[116]:= Ret[RetNo].Lnn[31217];
    Tv[51]:= TotMultiple(RetNo, 'ADOPT', 68); //20201215
    Tv[127]:= Tv[31] + Tv[32] + Tv[33] + Tv[116] + Tv[51]; //20201213
    Tv[137]:= Tv[127];
    Tv[167]:= Tv[115] + Tv[137];

    //Page 2
    Tv[40]:= Tv[167];
    Tv[34]:= GetPrvPnsDed(RetNo);
    Tv[168]:= Tv[40] + Tv[34];

    // Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));  //??? What is this
    if (Ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));

    Tv[37]:= GetPrvDisabXfer(RetNo);
    Tv[169]:= Tv[168] + Tv[36] + Tv[37];  //20201228

    Tv[38]:= Ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[35]:= Tv[169] + Tv[38] + Tv[39] + Tv[41]; //20250306//+Vl(FetchElm(RetNo,'RC269',10)); //20201228
    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));

    if (UpperCase(Frm[FNo].Strings[67]) = 'Y') then Tv[42]:= Tv[68];

    //20211115
    Tv[170]:= Ret[RetNo].Lnn[23600];
    Tv[171]:= 3;
    Tv[172]:= Tv[170] * Tv[171] / 100;
    Tv[173]:= MinR(Tv[172], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[173]);

    {Tv[66]:= PrvConstant[RY].PrvMedicalLimit;
    Tv[43]:= CalcPrvMedicalLimit(RetNo);
    Tv[44]:= MaxR(0,Tv[42]-Tv[43]);}

    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= Tv[44] + Tv[45];
    Tv[47]:= Tv[46];
    Tv[49]:= Tv[35] + Tv[47] + GetLine51200fromrc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[53]:= GetS9DonLow(RetNo);
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo);
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57] / 100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];
    Tv[101]:= MaxR(Tv[124], MaxR(MaxR(Tv[20], MaxR(Tv[21], Tv[22])), Tv[162])); //20140813

    NormalPrvNonRefAmount:= Tv[61]; //20230116
    Tv[133]:=NormalPrvNonRefAmount; //20260511
    //xx:=Tv[133];
    if AllowSaSb(RetNo) then
       Tv[133]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20260503
    else Tv[133]:=NormalPrvNonRefAmount; //20260511

    yy:=Tv[133];
     //-------------------------
    (* //20260502
    //?? Where is the following come from???
    if IsNonResWithCanEmpl(RetNo) then    //put notes back
      Tv[133]:= (Tv[31] + Tv[33] + Tv[36] + Tv[38] + Tv[39] + Tv[60] + Ret[RetNo].Lnn[31217] + Tv[59]) * PrvConstant[RY].PrvNonRefundRate / 100;
    if AllowSaSb(RetNo) then Tv[133]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo); //20150412
    *)
    //------------------------
    Tv[132]:= MaxR(0, Tv[101] - Tv[133]);//Tv[101]+Tv[131]; //20230116
    if SplitIncome(RetNo) then
      Tv[131]:= GetTOSIPrvTax(RetNo) // Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[131]:= 0;

    // see lowerTv[138]:=Tv[131];  // move lower?

    Tv[125]:= Tv[132] + Tv[131]; //20230125 //MaxR(0,Tv[132]-Tv[131]); //20230116  //20170321 //MaxR(0,Tv[132]-Tv[133]);   //20170321
    Tv[126]:= Tv[132]; //Tv[125];
    Tv[136]:= Vl(FetchElm(RetNo, 'DTC', 9));
    Tv[130]:= MaxR(0, Tv[126] - Tv[136]);
    Tv[96]:= Ret[RetNo].Lnn[40427];
    Tv[97]:= 24.63; //33.67; //40.33;
    Tv[140]:= (Tv[96] * Tv[97]) / 100;
    Tv[135]:= MinR(Tv[130], Tv[140]);
    Tv[139]:= MaxR(0, Tv[125] - Tv[135]);

    //Page 3
    Tv[141]:= Tv[139];
    Tv[142]:= Tv[141];
    Tv[138]:= Tv[131];
    Tv[143]:= MaxR(0, Tv[142] - Tv[138]);

    if (RY = 0) then       //http://www.taxtips.ca/taxrates/on.htm
    begin
      SurTaxBase1:= 5710; //5315  //20241207
      SurtaxBase2:= 7307; //6802  //20231116
    end else
    begin
      SurTaxBase1:= 5710;  //20231116
      SurtaxBase2:= 7307;  //20231116
    end;

    Tv[146]:= Tv[143];
    Tv[147]:= MaxR(0, Tv[146] - SurTaxBase1) * 20 / 100;
    Tv[148]:= Tv[143];
    Tv[149]:= MaxR(0, Tv[148] - SurTaxBase2) * 36 / 100;
    Tv[150]:= Tv[147] + Tv[149];
    Tv[151]:= Tv[150];
    Tv[152]:= Tv[141] + Tv[151];
    Tv[155]:= Tv[136]; //Vl(FetchElm(RetNo,'DTC',9));
    Tv[163]:= MaxR(0, Tv[152] - TV[155]);

    if SubjectToMinTax(Retno) then //20341230
      Tv[144]:= Vl(FetchElm(RetNo, 'ONMTXWS', 14)) //20161231 Tv[128] * Tv[129]/100;
    else
      Tv[144]:= 0;

    Tv[145]:= Tv[163] + Tv[144];
    //Tv[128]:= Vl(FetchElm(RetNo, 'T691', 249)); //20250922 Igor
    //if IsDeceased(RetNo) then Tv[128]:= 0; //20250922 Igor
    //Tv[129]:= PrvConstant[RY].PrvAMTCarryOverRate; //20250922 Igor

    if (Tv[145] <= 0) then
    begin
      for i:= 103 to 113 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
    end else
    begin
      if (RY = 0) then //Ontario
        Tv[102]:= 294 //286 //274 //257 //249 //235  //20211116 //20231126
      else
        Tv[102]:= 294; //286; //274; //49;  //235;  //20231126

      if (Immigrant(RetNo) or Emigrant(RetNo)) or (FetchElmFNo(RetNo, InfoFNo, 276) > '') then //20200307 //NR with Empl
        Tv[102]:= 0; //20131201

      if ((Ret[RetNo].MarStatus < 3) and (GetPrvNetIncome(RetNo, 'ON') >= SpouseIncome(RetNo)) or (Ret[RetNo].MarStatus > 2)) then
      begin
        Frm[FNo].Strings[103]:= FetchElm(RetNo, 'DEPEND', 8); //18 or less

        if (Tv[145] <= 0) then Frm[FNo].Strings[103]:= ''; //20180101

        k:= MystrToInt(FetchElm(RetNo, 'DEPEND', 9));

        if (Vl(FetchElm(RetNo, 'S2PRV', 5)) > 0) and (Vl(FetchElm(RetNo, 'S2PRV', 19)) > 0) then Inc(K); {disabil xferd from spouse}  //20090227

        Frm[FNo].Strings[105]:= IntToStr(k);
      end else
      begin
        Frm[FNo].Strings[103]:= '';
        Frm[FNo].Strings[105]:= '';
      end;

      if IsPrebankruptcyReturn(RetNo) then
      begin
        Frm[FNo].Strings[103]:= '';
        Frm[FNo].Strings[105]:= '';
      end;

      //20211116
      if (RY = 0) then
        DepCredit:= 544 //606 //20241019 506 //475  //20231212
      else
        DepCredit:= 544; //606; //475;  //20210807

      if (Immigrant(RetNo) or Emigrant(RetNo)) then
      begin
        Frm[FNo].Strings[103]:= '';
        Frm[FNo].Strings[105]:= '';
        DepCredit:= 0;
      end; //20131201

      Tv[104]:= Vl(Frm[FNo].Strings[103]) * DepCredit;
      Tv[106]:= Vl(Frm[FNo].Strings[105]) * DepCredit;
      Tv[107]:= Tv[102] + Tv[104] + Tv[106];
      Tv[108]:= Tv[107];
      Tv[109]:= Tv[108] * 2;
      Tv[110]:= Tv[145]; //20251202//Tv[90]; //Tv[152];    //20150211
      Tv[111]:= MaxR(0, Tv[109] - Tv[110]);

      if (Tv[144] > 0) then
        for i:= 102 to 111 do
        begin
          Tv[i]:= 0;
          Frm[FNo].Strings[i]:= '';
        end;

      Tv[112]:= Tv[111];

      if IsPreBankruptcyReturn(RetNo) then Tv[112]:= 0; //20230119

      if (Ret[RetNo].Province <> 'ON') then
        for i:= 102 to 112 do Tv[i]:= 0;

      if (Tv[144] > 0) then //adiitionl min tax
        for i:=102 to 112 do Tv[i]:= 0;

      Tv[113]:= MaxR(0, Tv[145] - Tv[112]); //2025202 MaxR(0, Tv[90] - Tv[112]);
    end;

    Tv[153]:= GetPrvForTaxCredit(RetNo, 'ON'); //20220110 Feed TOSI t1206 col 7?
    Tv[154]:= MaxR(0, Tv[113] - Tv[153]); //20141117 MaxR(0,Tv[90] - Tv[153]);
    //20220110 if (TOSIInEffect(RetNo)) and (Ret[RetNo].Province='ON') then Tv[154]:=Vl(FetchElm(RetNo,'T1206',115));  //20220109

    //Page 4
    Tv[90]:= Tv[154];  //20210306

    //20200228
    if (FetchElm(RetNo, 'ON428A', 48) = 'Y') then
    begin
      if (Ret[RetNo].MarStatus < 3) then
        Tv[48]:= Vl(FetchElm(RetNo, 'ON428A', 41))
      else
        Tv[48]:= Vl(FetchElm(RetNo, 'ON428A', 20));
    end else
      Tv[48]:= 0;

    Tv[114]:= MaxR(0, Tv[90] - Tv[48]);  //20210306 //Tv[114]:=MaxR(0,Tv[154]-Tv[48]);
    Tv[165]:= Tv[166] * 25 / 100;
    Tv[164]:= MaxR(0, Tv[114] - Tv[165]);  //20220110 Feed TOSI t1206 col 8?
    //Tv[174]:= Tv[164]; //20220120 Store it here to be used by the T1206

    if (TOSIInEffect(RetNo)) and (Ret[RetNo].Province = 'ON') then
      Tv[164]:= Vl(FetchElm(RetNo, 'T1206', 115));  //20220120

    {Tv[174]:=Tv[164]; //20220120 Store it here to be used by the T1206
    if (TOSIInEffect(RetNo)) and (Ret[RetNo].Province='ON') then Tv[164]:=Vl(FetchElm(RetNo,'T1206',115));  //20220120}

    //ohip
    for i:= 69 to 89 do Tv[i]:= 0;
    for i:= 92 to 94 do Tv[i]:= 0; //20121124

    TxBl:= Ret[RetNo].Lnn[26000] + Vl(FetchElm(RetNo, 'T1206', 3)); //20241214

    if not AllowSaSb(RetNo) then
    begin
      Tv[95]:= Txbl;

      if (Txbl <= 20000) then
        Tv[69]:= 0
      else
      if (Txbl > 20000) and (Txbl <= 25000) then
      begin
        Tv[80]:= Txbl;
        Tv[81]:= Tv[80] - 20000;
        Tv[70]:= Tv[81] * 0.06;
      end else
      if (Txbl > 25000) and (Txbl <= 36000) then
        Tv[71]:= 300  //20101021
      else
      if (Txbl > 36000) and (Txbl <= 38500) then
      begin
        Tv[82]:= Txbl;
        Tv[83]:= Tv[82] - 36000;
        Tv[84]:= Tv[83] * 0.06;
        Tv[72]:= Tv[84] + 300;
      end else
      if (Txbl > 38500) and (Txbl <= 48000) then
        Tv[73]:= 450
      else
      if (Txbl > 48000) and (Txbl <= 48600) then
      begin
        Tv[85]:= Txbl;
        Tv[86]:= Tv[85] - 48000;
        Tv[87]:= Tv[86] * 0.25;
        Tv[74]:= Tv[87] + 450;
      end else
      if (Txbl > 48600) and (Txbl <= 72000) then
        Tv[75]:= 600
      else
      if (Txbl > 72000) and (Txbl <= 72600) then
      begin
        Tv[88]:= Txbl;
        Tv[89]:= Tv[88] - 72000;
        Tv[91]:= Tv[89] * 0.25;
        Tv[76]:= Tv[91] + 600;
      end else
      if (Txbl > 72600) and (Txbl <= 200000) then
        Tv[77]:= 750
      else
      if (Txbl > 200000) and (Txbl <= 200600) then
      begin
        Tv[92]:= Txbl;
        Tv[93]:= Tv[92] - 200000;
        Tv[94]:= Tv[93] * 0.25;
        Tv[78]:= Tv[94] + 750;
      end else
      if (Txbl > 200600) then Tv[79]:= 900;

      Tv[134]:= AddColumns(69, 79, 1);

      if (Txbl <= 20000) then Tv[134]:= 0;
    end else //Nonres
      Tv[134]:= 0;  //20200310

    Tv[122]:= Tv[164] + Tv[134];
    Lnn[42800]:= Tv[122];
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure BC428(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  Thresh1, Thresh2, Reduction: Real;
  NormalPrvNonRefAmount:Real;  //20260503
begin
  InitPrvConstants('BC');
  LoadTv(RetNo, FName, FNo);


  if not CalcThisProvince(RetNo, 'BC') then //Or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 152 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;
    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= Ret[RetNo].Lnn[26000];
    xx:= Ret[RetNo].Lnn[26000];

    {$region ' Top tables '}
    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 66 to 79 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 90 to 96 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 103 to 109 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    Frm[FNo].Strings[11]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13]:= PrvConstant[RY].PrvRate3;
    Frm[FNo].Strings[69]:= PrvConstant[RY].PrvRate4;
    Frm[FNo].Strings[76]:= PrvConstant[RY].PrvRate5;
    Frm[FNo].Strings[93]:= PrvConstant[RY].PrvRate6;
    Frm[FNo].Strings[106]:= PrvConstant[RY].PrvRate7;

    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;
    Tv[67]:= PrvConstant[RY].PrvBracket3;
    Tv[71]:= PrvConstant[RY].PrvBracketTax4;
    Tv[74]:= PrvConstant[RY].PrvBracket4;
    Tv[78]:= PrvConstant[RY].PrvBracketTax5;
    Tv[91]:= PrvConstant[RY].PrvBracket5;
    Tv[95]:= PrvConstant[RY].PrvBracketTax6;
    Tv[104]:= PrvConstant[RY].PrvBracket6;
    Tv[108]:= PrvConstant[RY].PrvBracketTax7;

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:= 0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket3) and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
    begin
      Tv[66]:= Tv[1];
      Tv[67]:= PrvConstant[RY].PrvBracket3;
      Tv[68]:= MaxR(0, Tv[66] - Tv[67]);
      Tv[70]:= Tv[68] * Vl(Frm[FNo].Strings[69]) / 100;
      Tv[71]:= PrvConstant[RY].PrvBracketTax4;         {?}
      Tv[72]:= Tv[70] + Tv[71];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket4) and (Tv[1] <= PrvConstant[RY].PrvBracket5) then
    begin
      Tv[73]:= Tv[1];
      Tv[74]:= PrvConstant[RY].PrvBracket4;
      Tv[75]:= MaxR(0, Tv[73] - Tv[74]);
      Tv[77]:= Tv[75] * Vl(Frm[FNo].Strings[76]) / 100;
      Tv[78]:= PrvConstant[RY].PrvBracketTax5;
      Tv[79]:= Tv[77] + Tv[78];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket5) and (Tv[1] <= PrvConstant[RY].PrvBracket6) then
    begin
      Tv[90]:= Tv[1];
      Tv[92]:= MaxR(0, Tv[90] - Tv[91]);
      Tv[94]:= Tv[92] * Vl(Frm[FNo].Strings[93]) / 100;
      Tv[95]:= PrvConstant[RY].PrvBracketTax6;
      Tv[96]:= Tv[94] + Tv[95];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket6) then
    begin
      Tv[103]:= Tv[1];
      Tv[105]:= MaxR(0, Tv[103] - Tv[104]);
      Tv[107]:= Tv[105] * Vl(Frm[FNo].Strings[106]) / 100;
      Tv[108]:= PrvConstant[RY].PrvBracketTax7;
      Tv[109]:= Tv[107] + Tv[108];
    end;
    {$endregion ' Top tables '}

    Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear;
    Tv[24]:= Vl(FetchElm(RetNo, 'AGEDED', 17));
    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
    Tv[26]:= SpouseIncome(RetNo);
    Tv[26]:= GetSpouseTosiNetIncome(RetNo, InfoFNo);   //20181227

    //20221209
    //Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
    Tv[65]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo))); //CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo));
    //Tv[65]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, Tv[25] - Tv[26]);

    if UpperCase(Frm[FNo].Strings[64]).Equals('Y') then Tv[65]:= Tv[27];

    Tv[28]:= Tv[65];
    {Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
    Tv[28]:= Tv[27];
    If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];}
    Tv[100]:= PrvConstant[RY].PrvSpouseBasicAmount;
    Tv[99]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
    Tv[98]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[100] - Tv[99]));
    Tv[29]:= Vl(FetchElm(RetNo, 'S5PRV', 10));
    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 90));  //20191204
    Tv[35]:= Tv[23] + Tv[24] + Tv[28] + Tv[29] + Tv[30];  //20210101

    //Page 2
    Tv[83]:= Tv[35]; //20230415
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[82]:= Ret[RetNo].Lnn[31217];
    Tv[51]:= TotMultiple(RetNo, 'ADOPT', 68); //ret[RetNo].Lnn[31300];
    Tv[49]:= Tv[31] + Tv[32] + Tv[33] + Tv[82] + Tv[86] + Tv[87]; //20240111
    Tv[53]:= Tv[49];

    Tv[54]:= Tv[83] + Tv[53] + tv[51];   //20230415
    //Tv[83]:=Tv[54]; //20230415
    Tv[34]:= GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//ret[RetNo].Lnn[31400];
    Tv[55]:= Tv[54] + Tv[34];//Tv[83]+Tv[34];  //20230415

    if (Ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));

    Tv[37]:= GetPrvDisabXfer(RetNo);
    Tv[38]:= Ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[40]:= GetPrvEducXfer(RetNo);
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[57]:= Tv[55] + Tv[36] + Tv[37];
    Tv[56]:= Tv[57] + AddColumns(38, 41, 1) + Vl(FetchElm(RetNo, 'RC269', 10));
    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    //20211115
    Tv[58]:= Ret[RetNo].Lnn[23600];
    Tv[60]:= 3;
    Tv[84]:= Tv[58] * Tv[60] / 100;
    Tv[85]:= MinR(Tv[84], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[85]);
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= Tv[44] + Tv[45];
    Tv[47]:= Tv[46];
    Tv[48]:= Tv[56] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[48] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[59]:= Vl(FetchElm(RetNo, 'BCDON', 15));
    //Tv[60]:= Tv[59];
    Tv[89]:= Tv[52] + Tv[59];  //20211115151124
    Tv[154]:= Tv[153] * 25 / 100;
    Tv[61]:= Tv[89] + Tv[154];

    //Page 3
    Tv[132]:= MaxR(Tv[20], MaxR(Tv[21], Tv[22]));
    Tv[132]:= MaxR(Tv[132], MaxR(TV[72], Tv[79]));
    Tv[132]:= MaxR(Tv[132], Tv[96]); //20181112
    Tv[132]:= MaxR(Tv[132], Tv[109]); //20201108

    if SplitIncome(RetNo) then   //??
      Tv[133]:= GetTOSIPrvTax(RetNo) //Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[133]:=0;

    Tv[134]:= Tv[132] + Tv[133];

    NormalPrvNonRefAmount:= Tv[61];  //20260503
    if AllowSaSb(RetNo) then
     Tv[135]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20260503
    else
     Tv[135]:=NormalPrvNonRefAmount; //20260514

    Tv[152]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[141]:= Ret[RetNo].Lnn[40427];
    Tv[138]:= Vl(FetchElm(RetNo, 'DTC', 9));
    Tv[142]:= Tv[141] * Tv[152] / 100;
    Tv[143]:= Tv[135] + Tv[138] + Tv[142]; //20161119 // Tv[135]+Tv[138]+Tv[140]+Tv[142];
    Tv[144]:= Tv[143];
    Tv[145]:= MaxR(0, Tv[134] - Tv[144]);
    Tv[111]:= 0;
    //If SubjectToMinTax(RetNo) then
    Tv[111]:= MaxR(0, Vl(FetchElm(RetNo, 'T691', 316)));  //20250129 syntax
    //If SubjectToMinTax(RetNo) then Tv[111]:=MaxR(0,Vl(FetchElm(RetNo,'T691',316));
    //- Vl(FetchElm(RetNo,'T1',149))); //20250127
    Tv[112]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[146]:= Tv[111] * Tv[112] / 100;
    Tv[147]:= Tv[145] + Tv[146];

    if not Ret[RetNo].Province.Equals('BC') then
      Tv[148]:= 0
    else
      Tv[148]:= GetPrvForTaxCredit(RetNo, 'BC');

    Tv[149]:= MaxR(0, Tv[147] - Tv[148]);

    if (RY = 0) then
    begin
      Reduction:= 562 * PartYear;
      Thresh1:= 25020 * PartYear;
      Thresh2:= 40807;
    end else
    begin
      Reduction:= 562 * PartYear;
      Thresh1:= 25020 * PartYear;
      Thresh2:= 40807;
    end;

    Tv[81]:= Tv[149];

    if (Ret[RetNo].Lnn[23600] < Thresh2) then
    begin
      Tv[113]:= Reduction;
      Tv[114]:= ret[RetNo].Lnn[23600];

      if (IsPrebankruptcyReturn(RetNo)) then Tv[113]:= Vl(FetchElm(RetNo, 'BANKRPT', 2)) / 366; //chg to 365 next yr
      if TosiInEffect(RetNo) then Tv[114]:= GetTosiNetIncome(RetNo);

      Tv[115]:= Thresh1;
      Tv[116]:= MaxR(0, Tv[114] - Tv[115]);

      if (RY = 0) then
        Tv[117]:= 3.56
      else
        Tv[117]:= 3.56;

      Tv[136]:= Tv[116] * Tv[117] / 100;

     Tv[118]:= Tv[136];
     Tv[119]:= MaxR(0, Tv[113] - Tv[118]);
     Tv[120]:= Tv[119];
    end else
     for i:= 113 to 120 do Tv[i]:= 0;

    Tv[121]:= MaxR(0, Tv[81] - Tv[120]);
    Tv[122]:= BCLoggingTaxCredit(RetNo, Vl(FetchElm(RetNo, 'DIRECT', 10)), Vl(FetchElm(RetNo, 'DIRECT', 11)));
    Tv[123]:= MaxR(0, Tv[121] - Tv[122]);
    // Tv[81]:=Tv[123];  //20210319
    Tv[124]:= GetPrvPolit(RetNo, 'BC');

    if (Tv[124] <= 100) then
      Tv[125]:= Tv[124] * 0.75
    else
    if (Tv[124] > 100) and (Tv[124] <= 550) then
      Tv[125]:= (Tv[124] - 100) * 0.50 + 75
    else
      Tv[125]:= (Tv[124] - 550) * 0.3333 + 300;

    if (Tv[125] > 500) then Tv[125]:= 500;

    Tv[126]:= MaxR(0, Tv[123] - Tv[125]); //20210319
    //Tv[126]:= MaxR(0, Tv[81] - Tv[125]);
    Tv[129]:= MinR(2000, Tv[127] + Tv[128]);
    Tv[130]:= Tv[129];
    Tv[101]:= MaxR(0, Tv[126] - Tv[130]);
    Tv[102]:= Vl(FetchElm(RetNo, 'T1231', 7));
    Tv[131]:= MaxR(0, Tv[101] - Tv[102]);
    Lnn[42800]:= Tv[131];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250918 Igor <<<

//20250916 Igor >>>
procedure BC479(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
  x, y, z: Real;
  SalesTaxCr: Real;
  BirthDt: string;
  FamInc: Real;
begin
  InitPrvConstants('BC');

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    LoadTv(RetNo,FName,FNo);

    if CalcThisProvince(RetNo, 'BC') = False then
    begin
      for i:= 1 to 35 do
      begin
        Ret[RetNo].Frm[FNo].Strings[i]:= '';
        Ret[RetNo].Frm[FNo].Tv[i]:= 0;
      end;

      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    // Page 1
    if (Ret[RetNo].Frm[FNo].Strings[38] = '') and (Ret[RetNo].MarStatus > 2) then Ret[RetNo].Frm[FNo].Strings[38]:= 'Y';
    if (Ret[RetNo].Frm[FNo].Strings[39] = '') then Ret[RetNo].Frm[FNo].Strings[39]:= 'Y';

    //20131221
    //Tv[10] := MaxR(0,Lnn[23600]);  //20131220 hange removed
    Tv[10]:= MaxR(0, SelectNetIncomeAmount(RetNo) //20250222  //20250222//MaxR(0,Lnn[23600]
                  - CalcMortgageForeclosure(Ret[RetNo].Lnn[12700], Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 122)), Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 72))));

    if TosiInEffect(RetNo) then
      Tv[10]:= MaxR(0, GetTosiNetIncome(RetNo) - CalcMortgageForeclosure(ret[RetNo].Lnn[12700], Vl(FetchElmFNo(RetNo,GetFormNo('S3'), 122)), Vl(FetchElmFNo(RetNo,GetFormNo('S3'), 72))));

    Tv[11]:= Ret[RetNo].Lnn[21300] + Vl(FetchElm(RetNo, 'OTHDED', 60));
    Tv[12]:= Tv[10] + Tv[11];
    Tv[13]:= Ret[RetNo].Lnn[11700] + ret[RetNo].Lnn[12500];
    Tv[17]:= MaxR(0, Tv[12] - Tv[13]);

    //lowincome
    Tv[6]:= MaxR(0, Vl(FetchElm(RetNo, 'INFO', 19))) - Vl(FetchElm(RetNo, 'FORECLO', 4)); //20131220
    if TOSIInEffect(RetNo) then MaxR(0, GetSpouseTosiNetIncome(RetNo, InfoFNo) - Vl(FetchElm(RetNo, 'FORECLO', 4))); //20131220

    //spnetincome
    Tv[7]:=Vl(FetchElm(RetNo, 'INFO', 162)) + Vl(FetchElm(RetNo, 'S2', 34));
    Tv[21]:= Tv[6] + Tv[7];
    Tv[24]:= Vl(FetchElm(RetNo, 'INFO', 131)) + Vl(FetchElm(RetNo, 'S2', 33));
    Tv[25]:= MaxR(0, Tv[21] - Tv[24]);

    if (Ret[RetNo].Frm[FNo].Strings[39] = 'N') then
    begin
      Tv[6]:= 0;
      Tv[7]:= 0;
      Tv[21]:= 0;
      Tv[24]:= 0;
      Tv[25]:= 0;
    end;
    Tv[19]:= Tv[17] + Tv[25];

    if (Ret[RetNo].MarStatus < 3) then Tv[20]:= 18000 else Tv[20]:= 15000;

    Tv[5]:= MaxR(0, Tv[19] - Tv[20]);
    Tv[26]:= 75;

    if (Ret[RetNo].MarStatus < 3) then Tv[27]:= 75 else Tv[27]:= 0;
    if IsSpouseNonResident(RetNo) then Tv[27]:= 0; //20131221

    Tv[28]:= Tv[26] + Tv[27];
    Tv[29]:= Tv[5];
    Tv[30]:= Tv[29] * 2 / 100;
    Tv[31]:= Maxr(0, Tv[28] - Tv[30]);

    BirthDt:= FetchElm(RetNo, 'INFO', 9);
    if (UpperCase(Ret[RetNo].Frm[FNo].Strings[38]) <> 'Y')   //20161213
     or (IsDeceased(RetNo))                              //20131221
     or ((CalcAge(BirthDt) < 19) and (AnyDependantUnder18(RetNo) = False) and (MarStatus > 2))  //20161213
     or (IsPreBankruptcyReturn(RetNo)) then
    begin
      Tv[10]:= 0; Tv[11]:= 0; Tv[12]:= 0; Tv[13]:= 0; Tv[17]:= 0;
      Tv[6]:= 0; Tv[7]:= 0; Tv[21]:= 0; Tv[24]:= 0; Tv[25]:= 0;
      Tv[19]:= 0; Tv[20]:= 0; Tv[5]:= 0;

      for i:= 26 to 28 do Tv[i]:= 0;
      for i:= 30 to 31 do Tv[i]:= 0;
    end;

    Tv[1]:= Vl(FetchElm(RetNo, 'S12BC', 170));
    Tv[1]:= MinR(10000, Tv[1]);
    Tv[2]:= Tv[1] * 10 / 100;
    Tv[33]:= Tv[31] + Tv[2];

    // Page 2
    Tv[40]:= Tv[33];

    if (Ret[RetNo].Frm[FNo].Strings[42] > '') and (Tv[9] = 0) then Ret[RetNo].Frm[FNo].Strings[42]:= '';
    if (Ret[RetNo].Frm[FNo].Strings[77] > '') and (Tv[76] = 0) then Ret[RetNo].Frm[FNo].Strings[77]:= '';
    if (Ret[RetNo].Frm[FNo].Strings[32] > '') and (Tv[8] = 0) then Ret[RetNo].Frm[FNo].Strings[32]:= '';

    Tv[75]:= MinR(120000, Tv[41] + Tv[9]);
    Tv[74]:=Tv[75];  //20251122 cz

    Tv[14]:= MinR(300000, Tv[74] + Tv[76] + Tv[8]);
    Tv[15]:= Tv[14];
    Tv[47]:= Tv[43] + Tv[44];
    Tv[46]:= Tv[47];
    Tv[34]:= Vl(FetchElm(RetNo, 'T1014', 16));
    Tv[35]:= Vl(FetchElm(RetNo, 'T10141', 5));
    Tv[3]:= Vl(FetchElm(RetNo, 'T10142', 5));
    Tv[36]:= Tv[34] + Tv[35] + Tv[3];
    Tv[37]:= Tv[36];
    Tv[22]:= Tv[40] + Tv[15] + Tv[16] + Tv[46] + Tv[37];

    // Page 3
    Tv[48]:= Tv[22];

    k:= 0;
    i:= 51;
    repeat
     if (Tv[pred(i)] > 0) then k:= k + MyStrToInt(Strings[i]);
     Inc(i, 4);
    until i > 63;

    Strings[45]:= IntToStr(k);

    //if k=0 then Strings[45]:='';  //20240229

    x:= Tv[50] + Tv[54] + Tv[58] + Tv[62]; //rent paid

    //20241207
    FamInc:= Tv[19];
    if (FamInc < 64764) then
      Tv[72]:= 400 else
    if ((FamInc >= 64764) and (FamInc <= 84764)) then
    begin
      Tv[65]:= 400;
      Tv[66]:= Tv[19];
      Tv[67]:= 64764;
      Tv[68]:= MaxR(0, Tv[66] - Tv[67]);
      Strings[69]:= '2';   //20231212
      Tv[70]:= Tv[68] * Vl(Strings[69]) / 100;
      Tv[71]:= Tv[70];
      Tv[72]:= MaxR(0, Tv[65] - Tv[71]);
    end else
    if (FamInc > 84764) then Tv[72]:= 0;

    if (Vl(Strings[45]) < 6) then Tv[72]:= 0;
    Tv[73]:= Tv[72];
    Tv[18]:= Tv[48] + Tv[73];
    Lnn[47900]:= Tv[18];
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure ON479(RetNo: Integer; FName: string; FNo: Integer);
var
  i, OnBenFNo: Integer;
  x, y, z, Faktor: Real;
  HasSpouseOrQDep: Boolean;
  Percent: Real;
begin
  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    {? Age 16 any impact on ont credits}
    LoadTv(RetNo, FName, FNo);
    OnBenFNo:= GetFormNo('ONBEN');

    if (ret[RetNo].Province <> 'ON') then
    begin
      for i:= 1 to 126 do Tv[i]:= 0;

      SaveTv(RetNo, FName, FNo);
      Exit;
    end;

    Tv[3]:= MinR(5000, Tv[2] * 0.25);
    Tv[1]:= Vl(FetchElm(RetNo, 'ON479A', 19));

    if ((Ret[RetNo].age >= 70)  Or (GetSpouseAge(RetNo) >= 70)) and (IsBankruptcyReturn(RetNo) = false) then
    begin
      Tv[13]:= Vl(FetchElm(RetNo, 'ON428', 46));
      Frm[FNo].Strings[15]:= '25';

      //Tv[16]:= MaxR(1500, Tv[13] * Tv[15] / 100);   //20251125
      Tv[16]:= minR(1500, Tv[13] * vl(Strings[15]) / 100); //jz//20251215 - changed from maxR to minR and TV[15] to Strings[15] //20251125

      //Tv[17]:=Vl(FetchElmFNo(RetNo,T1FNo,22));  //20221127
      Tv[17]:= Ret[RetNo].Lnn[23600]; //jz//20250221 need selectNetIncomeAmount(RetNo); here?? does not say anything in the line info like others

      if TosiInEffect(RetNo) then //jz//20250223
        Tv[17]:= MaxR(0, GetTosiNetIncome(RetNo)); //why maxr??

      Tv[18]:= SelectSpouseNetIncomeAmount(RetNo); //jz//20250224
      Tv[19]:= Tv[17] + Tv[18];

      Tv[20]:= 35000;
      Tv[21]:= MaxR(0, Tv[19] - Tv[20]);
      Frm[FNo].Strings[22]:= '5';
      Tv[23]:= Tv[21] * Vl(Frm[FNo].Strings[22]) / 100;
      Tv[24]:= Tv[23];
      Tv[25]:= MaxR(0, Tv[16] - Tv[24]);
      Tv[26]:= Tv[25];

      if (Tv[19] <= 35000) then
        Tv[26]:= Tv[16]
      else
      if (Tv[19] > 65000) then
        Tv[26]:= 0;
    end else
      for i:= 13 to 26 do
      begin
        Tv[i]:= 0;
        Frm[FNo].strings[i]:= '';
      end;

    //public trans
    if (Tv[6] > 3000) then Tv[6]:= 3000; //1500;  //20190325
    Tv[7]:= Tv[6] * 0.15;

    //Polit
    Tv[102]:= GetPrvPolit(RetNo, 'ON');
    If (IsPrebankruptcyReturn(RetNo)) then Tv[102]:= 0;  //20100429
    Tv[103]:= MinR(1666.82, CalcOnPolit(Tv[102]));  //20271208  //MinR(1330,CalcOnPolit(Tv[102]));  //20231116
    if Tv[102] >= 3793 then Tv[103]:= 1666.82;

    if Ret[RetNo].FormHasData['T1221'] then Tv[127]:= Vl(FetchElm(RetNo, 'T1221', 54));
    if (IsPrebankruptcyReturn(RetNo)) then Tv[127]:= 0;
    Tv[128]:= Tv[127] * 0.05;

    //Tv[4]:= Vl(FetchElm(RetNo, 'ONS12', 7));
    //Tv[5]:= Tv[4] * 0.25;

    Tv[14]:= Tv[3] + Tv[1] + Tv[26] + Tv[7] + Tv[103] + Tv[128];
    Tv[27]:= Tv[14];

    if (Vl(Frm[FNo].Strings[113]) = 0) then Tv[120]:= 0;

    if not IsSelfEmployed(RetNo) then
    begin
      Frm[Fno].Strings[132]:= '';
      Frm[Fno].Strings[113]:= '';
      Frm[Fno].Strings[116]:= '';
      Frm[Fno].Strings[117]:= '';
      Frm[Fno].Strings[119]:= '';
      Tv[131]:= 0;
      Tv[120]:= 0;
    end;

    Tv[126]:= Tv[27] + Tv[120];
    Ret[RetNo].Lnn[47900]:= Tv[126];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250916 Igor <<<
//20251125 Igor >>>
procedure ON428A(RetNo: Integer; FName: string; FNo: Integer);
const
  Maxcredit = 875; //20251125 Igor
  SingleNI = 32500; //20251125 Igor
  famNI = 65000; //20251125 Igor
  percent = 5.05; //20251125 Igor
  cAppRatePercent = 5.00; //20251125 Igor
var
  i, spRetNo: Integer;
begin
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do    //20230223
  begin
    if not Ret[RetNo].Province.Equals('ON') or (CalcDaysInCan(RetNo) < 365) or (FetchElm(RetNo, INFOFNo, 28) > '') or (FetchElm(RetNo, INFOFNo, 26) > '')
       or (FetchElm(RetNo, 'INFO', 166) > '') or (FetchElm(RetNo, 'INFO', 276) > '') or (IsPrebankruptcyReturn(RetNo)) then
    begin
      Frm[FNo].Strings[48]:= 'N';
      for i := 1 to 47 do Tv[i]:= 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    Frm[FNo].Strings[48]:= 'Y';

    if Ret[RetNo].CouplingSw then SpRetNo:= GetSpRetNo(RetNo) else spRetNo:= 0;

    Tv[1]:= Lnn[10100];
    Tv[2]:= Lnn[10400];
    Tv[3]:= Tv[1] + Tv[2];
    Tv[4]:= percent;
    Tv[5]:= MinR(875, (Tv[3] * Tv[4]) / 100);
    Tv[6]:= selectNetIncomeAmount(RetNo); //line 23600 //20250221

    if TosiInEffect(RetNo) then //jz//20250223
      Tv[6]:= MaxR(0, GetTosiNetIncome(RetNo)); //why maxr??

    Tv[7]:= LNN[21300];
    Tv[8]:= Vl(FetchElm(RetNo, 'OTHDED', 60)); //LNN[23200]; //20230328
    Tv[42]:= Tv[6] + Tv[7] + Tv[8];
    Tv[9]:= Tv[42];
    Tv[10]:= LNN[11700];
    Tv[11]:= LNN[12500];
    Tv[43]:= Tv[10] + Tv[11];
    Tv[12]:= Tv[43];
    Tv[13]:= MaxR(0, Tv[9] - Tv[12]);

    if (MarStatus > 2) then  //single
    begin
      for i:= 21 to 41 do Tv[i]:= 0;
      Tv[14]:= MinR(MaxCredit, Tv[5]);
      Tv[15]:= Tv[13];
      Tv[16]:= SingleNI; //20251125 Igor
      Tv[17]:= MaxR(0,Tv[15]-Tv[16]);
      Tv[18]:= cAppRatePercent; //20251125 Igor
      Tv[44]:= (Tv[17] * Tv[18]) / 100;
      Tv[19]:= Tv[44];
      Tv[20]:= MaxR(0, Tv[14] - Tv[19]);
    end else
    begin
      Tv[44]:= 0;
      for i:= 14 to 20 do Tv[i]:= 0; //delete single section
      //Tv[21]:=GetSpouseNetIncome(retNo); //20230418
      Tv[21]:= selectSpouseNetIncomeAmount(RetNo); //jz//20250224 replace as to consolidate

      if (spRetNo > 0) then
      begin
        Tv[21]:= Ret[SpRetNo].LNN[23600];
        Tv[22]:= Ret[SpRetNo].LNN[21300];
        Tv[23]:= Ret[SpRetNo].LNN[23200];
        Tv[25]:= Ret[SpRetNo].LNN[11700];
        Tv[26]:= Ret[SpRetNo].LNN[12500];
      end;

      Tv[45]:= Tv[21] + Tv[22] + Tv[23];
      Tv[24]:= Tv[45];
      Tv[46]:= Tv[25] + Tv[26];
      Tv[27]:= Tv[46];
      Tv[28]:= MaxR(0, Tv[24] - Tv[27]);
      Tv[29]:= MinR(MaxCredit, Tv[5]);
      Tv[30]:= Tv[13];
      Tv[31]:= SingleNI;
      Tv[32]:= MaxR(0, Tv[30] - Tv[31]);
      Tv[33]:= Tv[30];
      Tv[34]:= Tv[28];

      { 20230418
      if (MarStatus <3) and (spRetNo=0)then //spouse not loaded
        Tv[34]:=Vl(FetchElmFNo(RetNo,InfoFNo,157)); //20210313
      StoreElm(RetNo,InfoFNo,157,FormatFloat('########.##',Tv[34])); //20210313 }

      Tv[35]:= Tv[33] + Tv[34];
      Tv[36]:= FamNI; //20251125 Igor
      Tv[37]:= MaxR(0, Tv[35] - Tv[36]);
      Tv[38]:= MaxR(Tv[32], Tv[37]);
      Tv[39]:= cAppRatePercent; //20251125 Igor
      Tv[47]:=(Tv[38] * Tv[39]) / 100;
      Tv[40]:= Tv[47];
      Tv[41]:= MaxR(0, Tv[29] - Tv[40]);
    end;
  end;

  SaveTv(RetNo, FName, FNo);
End;
//20251125 Igor <<<
//20191121
Procedure ON479A(RetNo:integer;FName:string;FNo:integer);
Var i,spRetNo: integer;
Begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   If UpperCase(Ret[RetNo].Frm[FNo].Strings[13])<> 'Y' then
   begin
     for i := 1 to 19 do Tv[i] := 0;
     SaveTv(RetNo,FName,FNo);
     exit;
   end;
   Tv[1]:= selectNetIncomeAmount(RetNo); //jz//20250221 //Ret[RetNo].Lnn[23600];
   if TosiInEffect(RetNo) then //jz//20250223
     Tv[1] := MaxR(0, GetTosiNetIncome(RetNo)); //why maxr??

   Tv[2]:=Ret[RetNo].Lnn[21400];
   Tv[3]:=Ret[RetNo].Lnn[23500];


   //Tv[4]:=Vl(FetchElmFNo(RetNo,InfoFNo,19));  //20220426  //20220426
   Tv[4]:=selectSpouseNetIncomeAmount(RetNo); //jz//20250224

   if UpperCase(Ret[RetNo].Frm[FNo].Strings[14])<>'Y' then //20200224
   Begin
    If Ret[RetNo].CouplingSw then
    begin
      SpRetNo:=GetSpRetNo(RetNo);
      if SpRetNo>0 then
      Begin
       Tv[4]:=Ret[spRetNo].Lnn[23600];
       Tv[5]:=Ret[spRetNo].Lnn[21400];
       Tv[6]:=Ret[spRetNo].Lnn[23500];
      End;
    end;
   End;
   Tv[7]:=MaxR(0,AddColumns(1,3,1));
   Tv[8]:=MaxR(0,Tv[4]+Tv[5]+Tv[6]);  //20200224
   Tv[9]:=Tv[7]+Tv[8];
   Tv[10]:=Tv[2];
   Tv[11]:=GetOn479ARate(Tv[9]);  //20191122

   {
   Tv[15]:=Tv[10]*Tv[11]/100;
   Tv[12]:=Tv[15]; //20220215
   //20211120
   Tv[16]:=20;
   Tv[17]:=Tv[12]*Tv[16]/100;
   Tv[18]:=Tv[17];
   Tv[19]:=Tv[12]+Tv[18];   //20211122
   }
   Tv[19]:=Tv[10]*Tv[11]/100;
 end;
 SaveTv(RetNo,FName,FNo);
End;


Procedure ONBEN(RetNo:integer;FName:string;FNo:integer);
Var I:integer;
  //  x,y,z,Faktor : real;
//  http://www.rev.gov.on.ca/en/credit/stc/index.html  good info
Begin
   With ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
       LoadTv(RetNo,FName,FNo);
       If (ret[RetNo].Province <> 'ON') then
       begin
           for i := 1 to 77 do Tv[i] := 0;
           SaveTv(RetNo,FName,FNo);
           exit;
       end;
       //20101211
       If (ret[RetNo].MarStatus>2) and (Frm[FNo].Strings[42]+Frm[FNo].Strings[43]='') then
        begin Frm[FNo].Strings[42]:='Y'; Frm[FNo].Strings[43]:='N';end;

       //oshptg
       If ret[RetNo].Age <64 then Frm[FNo].Strings[4]:='';

       //20110104   Line 6118
       If (ret[RetNo].Age <16) then  //Appl for next year
       begin
        If ((ret[RetNo].MarStatus <3) or (Vl(FetchElm(RetNo,'DEPEND',1))>0))  //parent
        then
        //ok
        Else
          Frm[FNo].Strings[6]:='';   //do not allow it
       end;

       If (UpperCase(Frm[FNo].Strings[31]) ='Y')
       or (IsSpouseNonResident(RetNo)) then
           Frm[FNo].Strings[43] :='N';

       If IsNonResident(RetNo) then
          begin Frm[FNo].Strings[42]:='N';Frm[FNo].Strings[43]:='Y';end;   //20120229


       If ret[RetNo].MarStatus <3 then  //only one spouse >=64
       begin

        //20140223
        If (ret[RetNo].Age <64)
        and (CalcAge(GetSpouseBirthDate(RetNo)) >=64)
        and (UpperCase(Frm[FNo].Strings[31]) <> 'X')
        and (IsSpouseNonResident(RetNo) = false)     //20110322  //20120229 //non resident
        then
          begin
           Frm[FNo].Strings[42]:='N';
           Frm[FNo].Strings[43]:='Y';  //20120229
          end;

        //20130417
        If (FetchElm(RetNo,'INFO',65) >'')   //deceased
        then
        begin
         Frm[FNo].Strings[42]:='Y';
         Frm[FNo].Strings[43]:='N';  //20120229
        end;
       end;

       //20101202
       If Frm[FNo].Strings[42]='Y' then Frm[FNo].Strings[43]:='N';
       If Frm[FNo].Strings[42]='N' then Frm[FNo].Strings[43]:='Y';

       If IsSpouseNonResident(RetNo) then
       begin
         Frm[FNo].Strings[31] :='';
         Frm[FNo].Strings[35] :='';
         Frm[FNo].Strings[41] :='';
         Frm[FNo].Strings[66] :='';
       end;

      //20120126
      Tv[7]:=0;Tv[8]:=0;Tv[12]:=0;Tv[13]:=0;
      Tv[78]:=0;
      i:=83;
      Repeat
     //  If Frm[FNo].Strings[i]='' then Tv[i+1]:=0;
       Tv[78]:=Tv[78]+Tv[i+1];
       If ((Frm[FNo].Strings[i]='Rent') or (LeftStr(Frm[FNo].Strings[i],7)='Private'))  then Tv[7]:=Tv[7]+Tv[i+1]
       Else If Frm[FNo].Strings[i]='Property Tax' then Tv[8]:=Tv[8]+Tv[i+1]
       Else If Frm[FNo].Strings[i]='Energy on a Reserve' then Tv[12]:=Tv[12]+Tv[i+1]
       else If LeftStr(Frm[FNo].Strings[i],6) ='Public' then Tv[13]:=Tv[13]+Tv[i+1];
       Inc(i,6);
      until i>125;



       If UpperCase(Frm[FNo].Strings[42]) = 'Y' then
       begin
       // InfoFNo:=GetFormNo('INFO');
        If Frm[FNo].Strings[80]='' then
          Frm[FNo].Strings[80]:=FetchElmFNo(RetNo,InfoFNo,6)+
                                ' '+FetchElmFNo(RetNo,InfoFNo,22)+
                                ' '+FetchElmFNo(RetNo,InfoFNo,68)+
                                ' '+FetchElmFNo(RetNo,InfoFNo,163)+
                                ' '+FetchElmFNo(RetNo,InfoFNo,10)+
                                ' '+FetchElmFNo(RetNo,InfoFNo,14);
        If Frm[FNo].Strings[81]='' then
          Frm[FNo].Strings[81]:=FetchElmFNo(RetNo,InfoFNo,15);
      end;

      If UpperCase(Frm[FNo].Strings[42]) <>'Y' then
      begin
        Frm[FNo].Strings[4]:='';
        Frm[FNo].Strings[6]:='';
        Frm[FNo].Strings[7]:='';
        Frm[FNo].Strings[10]:='';
        Frm[FNo].Strings[11]:='';
        Tv[7]:=0;Tv[8]:=0;Tv[12]:=0;Tv[13]:=0;
      end;

      (*
      If (ret[RetNo].MarStatus > 2)
      and (ret[RetNo].Age <16)
      and (HasEligibleDependant(RetNo) = True)
      and (Frm[FNo].Strings[42] >'')   //claim onben
       then Frm[FNo].Strings[11]:='';  //6099 elig dependant


      If (ret[RetNo].Age <15)
      and (ret[RetNo].MarStatus >2)
      And (Frm[FNo].Strings[11] ='') {6099}
        then Frm[FNo].Strings[9]:='';  //6618

      If (ret[RetNo].Age <16)
      and (ret[RetNo].MarStatus >2)
      And (Frm[FNo].Strings[11] ='') {6099}
        then Frm[FNo].Strings[9]:='';  //6619
      *)
      If UpperCase(Frm[FNo].Strings[31])<> 'X' then   //inoluntary //20110210
      begin
        Frm[FNo].Strings[35]:='';Frm[FNo].Strings[41]:='';Frm[FNo].Strings[66]:='';
      end;

      //20101205
      If (IsPreBankruptcyReturn(RetNo)) or (IsDeceased(RetNo)) then
      begin
        Frm[FNo].Strings[7]:='';Tv[7]:=0; //6110
        Frm[FNo].Strings[8]:='';Tv[8]:=0; //6112
        Frm[FNo].Strings[4]:='';Tv[4]:=0; //6113
        Frm[FNo].Strings[10]:='';Tv[10]:=0; //6114
        Frm[FNo].Strings[6]:='';Tv[6]:=0;   //6118
        Frm[FNo].Strings[9]:='';Tv[9]:=0;   //6119
        Frm[FNo].Strings[12]:='';Tv[12]:=0; //6121
        Frm[FNo].Strings[13]:='';Tv[13]:=0; //6123
      end;
  end;
  SaveTv(RetNo,FName,FNo);
End;


//20250918 Igor >>>
procedure NB428(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  x, y, z: Real;
  BasicRed: Real;
  SpRetNo: Integer;
  NormalPrvNonRefAmount:Real;
begin
  if (RY = 0) then
    BasicRed:= 802
  else
    BasicRed:= 802;

  InitPrvConstants('NB');
  LoadTv(RetNo, FName, FNo);

  if not CalcThisProvince(RetNo, 'NB') then
  begin
    for i:= 1 to 150 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo,FName,FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    Tv[1]:= Ret[RetNo].Lnn[26000];

    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    for i:= 66 to 72 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    {$region ' Top table '}
    //20151102
    Tv[67]:= 0;
    // For i:=89 to 93 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end; //2024121
    //For i:=87 to 93 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
    // For i:=94 to 100 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;

    Frm[FNo].Strings[11]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13]:= PrvConstant[RY].PrvRate3;
    Frm[FNo].Strings[70]:= PrvConstant[RY].PrvRate4;
    //20151102
    Frm[FNo].Strings[90]:= PrvConstant[RY].PrvRate5;
    // Frm[FNo].Strings[97] := PrvConstant[RY].PrvRate6;

    //20151102
    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[68]:= PrvConstant[RY].PrvBracket3;
    //Tv[88]:= PrvConstant[RY].PrvBracket4; //20241212
    //Tv[95]:= PrvConstant[RY].PrvBracket5;

    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;
    Tv[72]:= PrvConstant[RY].PrvBracketTax4;
    Tv[92]:= PrvConstant[RY].PrvBracketTax5;
    //Tv[99]:= PrvConstant[RY].PrvBracketTax6;

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:=0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0,Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;

    //20241110
    if (Tv[1] > PrvConstant[RY].PrvBracket3) then
    begin
      Tv[66]:= Tv[1];
      Tv[68]:= PrvConstant[RY].PrvBracket3;
      Tv[69]:= MaxR(0, Tv[66] - Tv[68]);
      Tv[71]:= Tv[69] * Vl(Frm[FNo].Strings[70])/100;
      Tv[72]:= PrvConstant[RY].PrvBracketTax4;
      Tv[67]:= Tv[71] + Tv[72];
    end;
    {$endregion ' Top table '}

    Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear;
    Tv[24]:= Vl(FetchElm(RetNo, 'AGEDED', 17));

    if (Tv[24] > 6037) then Tv[24]:= 6037;

    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
    Tv[26]:= SpouseIncome(RetNo);
    Tv[26]:= GetSpouseTosiNetIncome(retNo, InfoFNo);   //20181227
    Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo)));
    Tv[28]:= Tv[27];

    if (UpperCase(Frm[FNo].Strings[64]) = 'Y') then Tv[28]:= Tv[65];

    //20101111
    Tv[83]:= PrvConstant[RY].PrvSpouseBasicAmount;

    if (FetchElm(RetNo, 'BANKRPT', 45) > '') then  //20221215
      Tv[83]:= Tv[83] * Vl(FetchElm(RetNo, 'BANKRPT', 45));

    Tv[84]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
    Tv[85]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[83] - Tv[84]));
    Tv[29]:= Vl(FetchElm(RetNo, 'S5PRV', 10));
    Tv[48]:= Tv[23] + Tv[24] + Tv[28] + Tv[29] + Tv[30]; //20250922
    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 87));
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[86]:= Ret[RetNo].Lnn[31217];
    Tv[97]:= Tv[31] + Tv[32] + Tv[33] + Tv[86] + Tv[87] + Tv[88];  //20241207
    Tv[98]:= Tv[97];
    Tv[99]:= Tv[48] + Tv[98];

    //Page 2
    Tv[95]:= Tv[99]; //20250922 //Tv[100];
    Tv[34]:= GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//ret[RetNo].Lnn[31400];
    Tv[35]:= Vl(FetchElm(RetNo,'S5PRV',90));
    Tv[100]:= Tv[95] + Tv[34] + Tv[35];

    if (Ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));

    Tv[37]:= GetPrvDisabXfer(RetNo);
    Tv[110]:= Tv[100] + Tv[36] + Tv[37]; //jz//20251203: fix wrong elm, change Tv[95] to [100]

    Tv[38]:= ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo,'S11PRV',21));
    //Tv[48]:=GetPrvEducXfer(RetNo);
    Tv[40]:=GetPrvEducXfer(RetNo);   //20191210
    Tv[41]:= Vl(FetchElm(RetNo,'S2PRV',19));
    Tv[94]:= Tv[110] + AddColumns(38, 41, 1); //20250922 Igor // + Vl(FetchElm(RetNo, 'RC269', 10));  //20191210  48 instead of 40

    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    Tv[113]:= Ret[RetNo].Lnn[23600];
    Tv[116]:= 3;
    Tv[125]:= Tv[113] * Tv[116] / 100;
    Tv[44]:= MinR(Tv[125], PrvConstant[RY].PrvMedicalLimit);
    Tv[153]:= MaxR(0, Tv[42] - Tv[44]);
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= Tv[153] + Tv[45];  //20211119
    Tv[47]:= Tv[46];
    Tv[49]:= Tv[94] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[53]:= GetS9DonLow(RetNo); //Lnn[32005];  //20161126Lnn[32005];
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo);  //20161126  Lnn[347];Lnn[347];
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57] / 100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];
    Tv[101]:= MaxR(MaxR(Tv[20], Tv[21]), MaxR(Tv[22], Tv[67]));
    Tv[101]:= MaxR(Tv[101], Tv[93]);

    if SplitIncome(RetNo) then
      Tv[102]:= GetTOSIPrvTax(RetNo)  //Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[102]:= 0;

    Tv[103]:= Tv[101] + Tv[102];
    NormalPrvNonRefAmount:= Tv[61]; //Vl(FetchElm(RetNo,'NB428',61));
    if AllowSaSb(RetNo) then Tv[104]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20260503
    Else TV[104]:=NormalPrvNonRefAmount;
    Tv[106]:= MaxR(0, Tv[103] - Tv[104]);

    //Page 3
    Tv[96]:= Tv[106];
    Tv[108]:= Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[5] * Tv[7]/100;

    Tv[140]:= ret[RetNo].Lnn[40427];
    Tv[141]:= PrvConstant[RY].PrvAmtCarryOverRate;
    Tv[111]:= Tv[140] * Tv[141] / 100;
    Tv[112]:= Tv[108] + Tv[111];
    Tv[109]:= Tv[112];
    Tv[114]:= MaxR(0, Tv[96] - Tv[109]);
    Tv[131]:= MaxR(0, Vl(FetchElm(RetNo, 'T691', 316)));

    if IsDeceased(RetNo) then Tv[131]:= 0;

    Tv[132]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[115]:= Tv[131] * Tv[132] / 100;
    Tv[117]:= Tv[114] + Tv[115];
    Tv[118]:= GetPrvForTaxCredit(RetNo, 'NB');
    Tv[119]:= MaxR(0, Tv[117] - Tv[118]);

    if IsPrebankruptcyReturn(RetNo) then Tv[120]:= 0;

    Tv[121]:= MaxR(0, Tv[119] - Tv[120]);
    //-------//20260226-----------------------------------------

    //Adjusted family income


    //---------------------------

    if (Frm[FNo].Strings[155] <> 'Y') then
    begin
      if (Ret[RetNo].MarStatus > 2) then
      begin
        Frm[FNo].Strings[137]:= 'X';
        Frm[FNo].Strings[138]:= '';
      end;

      if (Ret[RetNo].CouplingSw = True) and (ret[RetNo].MarStatus < 3) then
      begin
        SpRetNo:=GetSpRetNo(RetNo);

        if (SpRetNo > 0) then
        begin
          if (Tv[78] >= Vl(FetchElmFNo(SpRetNo, FNo, 78))) then
          begin
            Frm[FNo].Strings[137]:= 'X';
            Frm[FNo].Strings[138]:= '';
          end else
          begin
            Frm[FNo].Strings[137]:= '';
            Frm[FNo].Strings[138]:= 'X';
          end;
        end;
      end;
    end;

    Tv[78]:= Tv[121];  //20260219

    if (Frm[FNo].Strings[137] > '') then
    begin
      Tv[151]:= CalcMortgageForeclosure(Ret[RetNo].Lnn[12700], Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 122)), Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 72)));
      Tv[152]:= Vl(FetchElm(RetNo, 'FORECLO', 4));

      Tv[127]:= MaxR(0, SelectNetIncomeAmount(RetNo) - Tv[151]); //20250222 //MaxR(0,Lnn[23600]-Tv[151]);

      if TosiInEffect(RetNo) then Tv[127]:= MaxR(0, GetTosiNetIncome(RetNo) - Tv[151]);

      Tv[128]:= ret[RetNo].Lnn[21300] + Vl(FetchElm(RetNo,'OTHDED',60));
      Tv[107]:= Tv[127] + Tv[128];
      Tv[105]:= ret[RetNo].Lnn[11700] + Ret[RetNo].Lnn[12500]; //+GetRC310Income(RetNo); //20170126
      Tv[154]:= MaxR(0,Tv[107] - Tv[105]);

      Tv[51]:= MaxR(0, Vl(FetchElm(RetNo, 'INFO', 19)) - (Tv[152]));  //spnetincome
      Tv[73]:= Vl(FetchElm(RetNo, 'INFO', 162)) + Vl(FetchElm(RetNo, 'S2', 34)) + Vl(FetchElm(RetNo, 'INFO', 168)); //20101202;
      Tv[75]:= Vl(FetchElm(RetNo, 'INFO', 131)) + Vl(FetchElm(RetNo, 'S2', 33)) + Vl(FetchElm(RetNo, 'INFO', 168)); //20101202;
      Tv[74]:= Tv[51] + Tv[73];
      Tv[76]:= MaxR(0, Tv[74] - Tv[75]);
      Tv[77]:= Tv[154] + Tv[76];

      //Page 4
      //Tv[78]:= Tv[121];  //20260219
      Tv[122]:= BasicRed;

      if (MarStatus < 3) or (LeftStr(FetchElm(RetNo, 'INFO', 65), 4) = AppYear) then //20140330
        Tv[123]:= BasicRed
      else
        Tv[123]:= 0;

      if (Lnn[30400] > 0) then Tv[124]:= BasicRed else Tv[124]:= 0;

      Tv[126]:= MinR(BasicRed * 2, Tv[122] + Tv[123] + Tv[124]);

      if IsPrebankruptcyReturn(RetNo) then
      begin
        Tv[122]:=0;
        Tv[123]:=0;
        Tv[124]:=0;
        Tv[126]:=0;    //20101220
      end;

      if (Frm[FNo].Strings[138] > '') then
      begin
        Tv[122]:= 0;
        Tv[123]:= 0;
        Tv[124]:= 0;
      end; //spouse clains the low inc tax reduction //2041201

      Tv[129]:= TV[77];

      //20181118
      if (RY = 0) then //NB
        Tv[130]:= 21920  //21343 //20385 //19177 //20231124
      else
        Tv[130]:= 21920; //21343; //20385; //19177; //20231124

      Tv[133]:= MaxR(0, Tv[129] - Tv[130]);

      if (RY = 0) then
       Tv[134]:= 3
      else
       Tv[134]:= 3;  //NB

      Tv[135]:= Tv[133] * Tv[134] / 100;
      Tv[136]:= Tv[135];
      Tv[139]:= MaxR(0, Tv[126] - Tv[136]);
      Tv[142]:= Tv[139];
    end else
    begin
      for i:=122 to 124 do Tv[i]:= 0;
      for i:=129 to 130 do Tv[i]:= 0;
      for i:=133 to 136 do Tv[i]:= 0;

      Tv[126]:= 0;
      Tv[139]:= 0;
      Tv[142]:= 0;
    end;

    if (Tv[120] > 0) then
    begin
      for i:= 122 to 124 do Tv[i]:= 0;
      for i:= 129 to 130 do Tv[i]:= 0;
      for i:= 133 to 136 do Tv[i]:= 0;

      Tv[126]:= 0;
      Tv[139]:= 0;
      Tv[142]:= 0;
    end;

    Tv[143]:= MaxR(0, Tv[78] - Tv[142]);
    Tv[144]:= GetPrvPolit(RetNo, 'NB');

    if (Tv[144] <= 200) then
      x:= Tv[144] * 0.75
    else
    if ((Tv[144] > 200) and (Tv[144] <= 550)) then
      x:= (Tv[144] - 200) * 0.50 + 150
    else
    if (Tv[144] > 550) then
      x:= (Tv[144] - 550) * 0.3333 + 325;

    if x >500 then x :=500;

    Tv[145]:= MinR(500, x);
    Tv[146]:= MaxR(0, Tv[143] - Tv[145]);

    if (Tv[147] > 2000) then Tv[147]:= 2000;

    Tv[148]:= MaxR(0, Tv[146] - Tv[147]);
    Tv[149]:= Vl(FetchElm(RetNo, 'T1258', 6));

    if (Tv[149] > 125000) then Tv[149]:= 125000;

    Tv[150]:= MaxR(0, Tv[148] - Tv[149]);
    Lnn[42800]:= Tv[150];
    Tv[79]:= Tv[142];
    Tv[81]:= Tv[119];
    Tv[82]:= MaxR(0, Tv[79] - Tv[81]);
  end;

  SaveTv(RetNo, FName, FNo);
  Ret[RetNo].Lnn[47900]:= Vl(FetchElm(RetNo, 'S12NB', 170));  //20151103
end;

procedure NL428(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j, k, L, m, count, SpRetNo: Integer;
  x, y, z, BasicRed, SpRed, Thres1, Thres2: Real;
  Txbl: Real;
  NormalPrvNonRefAmount:Real;
  //for def reduction
  FromTxbl, ToTxbl, LessAmount, PlusAmount, MaxReduction, TotReduction: Real;
begin
  InitPrvConstants('NL');
  LoadTv(RetNo, FName, FNo);

  if not CalcThisProvince(RetNo, 'NL') or NonResWithEmpl(retNo) then //20230415
  begin
    for i:= 1 to 177 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  Txbl:= Ret[RetNo].Lnn[26000];  //20161130

  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= Txbl;
   //initialize
    for i:= 2 to 22 do begin Tv[i]:= 0; Frm[FNo].Strings[i]:= ''; end;
    for i:= 161 to 167 do begin Tv[i]:= 0; Frm[FNo].Strings[i]:= ''; end; //20150908
    for i:= 171 to 177 do begin Tv[i]:= 0; Frm[FNo].Strings[i]:= ''; end; //20150908
    for i:= 179 to 185 do begin Tv[i]:= 0; Frm[FNo].Strings[i]:= ''; end; //20150908
    for i:= 186 to 192 do begin Tv[i]:= 0; Frm[FNo].Strings[i]:= ''; end; //20150908
    for i:= 193 to 199 do begin Tv[i]:= 0; Frm[FNo].Strings[i]:= ''; end; //20150908

    Frm[FNo].Strings[11]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13]:= PrvConstant[RY].PrvRate3;
    Frm[FNo].Strings[164]:= PrvConstant[RY].PrvRate4;
    Frm[FNo].Strings[174]:= PrvConstant[RY].PrvRate5;
    Frm[FNo].Strings[182]:= PrvConstant[RY].PrvRate6;
    Frm[FNo].Strings[189]:= PrvConstant[RY].PrvRate7;
    Frm[FNo].Strings[196]:= PrvConstant[RY].PrvRate8;

    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[162]:= PrvConstant[RY].PrvBracket3;
    Tv[172]:= PrvConstant[RY].PrvBracket4;
    Tv[180]:= PrvConstant[RY].PrvBracket5;
    Tv[187]:= PrvConstant[RY].PrvBracket6;
    Tv[194]:= PrvConstant[RY].PrvBracket7;

    Tv[17]:= PrvConstant[RY].PrvBracketTax1;  //0
    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;
    Tv[166]:= PrvConstant[RY].PrvBracketTax4;
    Tv[176]:= PrvConstant[RY].PrvBracketTax5;
    Tv[184]:= PrvConstant[RY].PrvBracketTax6;
    Tv[191]:= PrvConstant[RY].PrvBracketTax7;
    Tv[198]:= PrvConstant[RY].PrvBracketTax8;

    if Txbl <= PrvConstant[RY].PrvBracket1 then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:= 0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Txbl > PrvConstant[RY].PrvBracket1) and (Txbl <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Txbl > PrvConstant[RY].PrvBracket2) and (Txbl <= PrvConstant[RY].PrvBracket3) then //20150908
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;

    //20150908
    If (Txbl > PrvConstant[RY].PrvBracket3) and (Txbl <= PrvConstant[RY].PrvBracket4) then //20140813
    begin
      Tv[161]:= Tv[1];
      Tv[162]:= PrvConstant[RY].PrvBracket3;
      Tv[163]:= MaxR(0, Tv[161] - Tv[162]);
      Tv[165]:= Tv[163] * Vl(Frm[FNo].Strings[164]) / 100;
      Tv[166]:= PrvConstant[RY].PrvBracketTax4;
      Tv[167]:= Tv[165] + Tv[166];
    end;

    //20150908
    If (Txbl > PrvConstant[RY].PrvBracket4) and (Txbl <= PrvConstant[RY].PrvBracket5) then
    begin
      Tv[171]:= Tv[1];
      Tv[172]:= PrvConstant[RY].PrvBracket4;
      Tv[173]:= MaxR(0, Tv[171] - Tv[172]);
      Tv[175]:= Tv[173] * Vl(Frm[FNo].Strings[174]) / 100;
      Tv[176]:= PrvConstant[RY].PrvBracketTax5;
      Tv[177]:= Tv[175] + Tv[176];
    end;

    //20221201
    if (Txbl > PrvConstant[RY].PrvBracket5) and (Txbl <= PrvConstant[RY].PrvBracket6) then
    begin
      Tv[179]:= Tv[1];
      Tv[180]:= PrvConstant[RY].PrvBracket5;
      Tv[181]:= MaxR(0, Tv[179] - Tv[180]);
      Tv[183]:= Tv[181] * Vl(Frm[FNo].Strings[182]) / 100;
      Tv[184]:= PrvConstant[RY].PrvBracketTax6;
      Tv[185]:= Tv[183] + Tv[184];
    end;

    if (Txbl > PrvConstant[RY].PrvBracket6) and (Txbl <= PrvConstant[RY].PrvBracket7) then
    begin
      Tv[186]:= Tv[1];
      Tv[187]:= PrvConstant[RY].PrvBracket6;
      Tv[188]:= MaxR(0, Tv[186] - Tv[187]);
      Tv[190]:= Tv[188] * Vl(Frm[FNo].Strings[189]) / 100;
      Tv[191]:= PrvConstant[RY].PrvBracketTax7;
      Tv[192]:= Tv[190] + Tv[191];
    end;

    if (Txbl > PrvConstant[RY].PrvBracket7) then
    begin
      Tv[193]:= Tv[1];
      Tv[194]:= PrvConstant[RY].PrvBracket7;
      Tv[195]:= MaxR(0, Tv[193] - Tv[194]);
      Tv[197]:= Tv[195] * Vl(Frm[FNo].Strings[196]) / 100;
      Tv[198]:= PrvConstant[RY].PrvBracketTax8;
      Tv[199]:= Tv[197] + Tv[198];
    end;

    Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear;
    Tv[24]:= Vl(FetchElm(RetNo, 'AGEDED', 17)); //original
    if Tv[24] > 7064 then Tv[24]:= 7064;
    {Did not work yet
    //--------------  20220516 --AgeDeduction  ------------
    SpRetNo:=GetSpRetNo(RetNo);  //20220516
    Tv[24]:=0;
    Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));    //original
    if (IsMultJurisdiction(RetNo)) and (SpRetNo>0) then
      Tv[24]:=GetAgeDeductionForMJ(spRetNo,'NL');
    }
    //---------------------------------------------
    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
    Tv[26]:= SpouseIncome(RetNo);
    if TosiInEffect(RetNo) then Tv[26]:= GetSpouseTosiNetIncome(retNo, InfoFNo);   //20181227
    Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo))); //20220922 Igor
    //Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[25] - Tv[26]));
    Tv[28]:= Tv[27];

    if UpperCase(Frm[FNo].Strings[64]) = 'Y' then Tv[28]:= Tv[65];
    //20250219
    Tv[85]:= 0;

    if Vl(fetchElm(RetNo,'DEPEND', 3)) > 0 then
      Tv[85]:= PrvConstant[RY].PrvSpouseBasicAmount;

    Tv[86]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
    Tv[87]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[85] - Tv[86]));

    //Tv[87]:=MinR(Tv[87],PrvConstant[RY].PrvMaxSpousalAmount); //20250217
    //MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0,Tv[85]-Tv[86])); //20221209
    Tv[29]:= Tv[87]; //Vl(FetchElm(RetNo,'S5PRV',10));
    //if Tv[29]>PrvConstant[RY].PrvMaxSpousalAmount then Tv[29]:=PrvConstant[RY].PrvMaxSpousalAmount;   //20200329
    //Tv[30]:=???? inform dependant for NL
    Tv[67]:= Tv[23] + Tv[24] + Tv[28] + Tv[29] + Tv[30];  //20211216

    //Page 2
    Tv[95]:= Tv[67]; //20250203
    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 87));
    Tv[31]:= ret[RetNo].Lnn[30800];
    Tv[32]:= ret[RetNo].Lnn[31000];
    Tv[33]:= ret[RetNo].Lnn[31200];
    Tv[89]:= ret[RetNo].Lnn[31217];
    Tv[90]:= ret[RetNo].Lnn[31220];  //20120210
    Tv[90]:= MinR(3000, Tv[90]);
    Tv[91]:= ret[RetNo].Lnn[21400];  //20120210
    Tv[51]:= TotMultiple(RetNo, 'ADOPT', 68); //ret[RetNo].Lnn[31300];
    Tv[98]:= AddColumns(31, 33, 1) + Tv[89] + Tv[90] + Tv[48] + Tv[91] + Tv[51];
    Tv[112]:= Tv[98];
    Tv[113]:= Tv[67] + Tv[112];
    //If Tv[51]>10100 then Tv[51]:=10100;
    Tv[34]:= MinR(PrvConstant[RY].PrvMaxPensionAmount, GetPrvPnsDed(RetNo));//Vl(FetchElm(RetNo,'PNSDED',18));//Lnn[31400];
    Tv[35]:= Vl(FetchElm(RetNo, 'S5PRV', 90));
    Tv[116]:= Tv[113] + Tv[34] + Tv[35]; // 202500217 //Tv[95]+Tv[34]+Tv[35];

    if (ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));

    Tv[37]:= GetPrvDisabXfer(RetNo);
    Tv[117]:= Tv[116] + Tv[36] + Tv[37];

    Tv[38]:= ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[40]:= GetPrvEducXfer(RetNo);
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[88]:= TV[117] + AddColumns(38, 41, 1) + Vl(FetchElm(RetNo, 'RC269', 10));
    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    Tv[118]:= Ret[RetNo].Lnn[23600];
    Tv[129]:= 3;
    Tv[130]:= Tv[118] * Tv[129] / 100;
    Tv[131]:= MinR(Tv[130], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[131]);
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= MaxR(0, Tv[44] + Tv[45]);
    Tv[47]:= Tv[46];
    Tv[49]:= Tv[88] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[53]:= GetS9DonLow(RetNo); //20161126  //Lnn[32005];
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo);  //20161126  Lnn[347];
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57]/100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];

    // Page 3
    Tv[101]:= MaxR(MaxR(Tv[20], MaxR(Tv[21], Tv[22])), MaxR(Tv[167], Tv[177])); //20150908
    Tv[101]:= MaxR(Tv[101], MaxR(Tv[185], MaxR(Tv[192], Tv[199])));  //20221208

    if SplitIncome(RetNo) then
     Tv[102]:= GetTOSIPrvTax(RetNo) // Vl(FetchElm(RetNo,'T1206',103))
    else
     Tv[102]:= 0;

    Tv[103]:= Tv[101] + Tv[102];
    //Tv[96]:= Tv[103]; //2025
    NormalPrvNonRefAmount:= Tv[61]; //Vl(FetchElm(RetNo,'NL428',61));
    if AllowSaSb(RetNo) then Tv[105]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20260503
        Else TV[105]:=NormalPrvNonRefAmount;  //20260514
    Tv[111]:= Vl(FetchElm(RetNo, 'DTC', 9)); //20180121
    Tv[122]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[119]:= ret[RetNo].Lnn[40427];
    Tv[123]:= Tv[119] * Tv[122] / 100;
    Tv[124]:= Tv[105] + Tv[111] + Tv[123]; //20161215//Tv[105]+Tv[111]+Tv[116]+Tv[123];
    Tv[125]:= Tv[124];
    Tv[126]:= MaxR(0, Tv[103] - Tv[125]);
    Tv[145]:= Vl(FetchElm(RetNo, 'T691', 316));

    if IsDeceased(RetNo) then Tv[145]:= 0;

    Tv[146]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[127]:= Tv[145] * Tv[146] / 100;
    Tv[128]:= Tv[126] + Tv[127];

    Tv[132]:= GetPrvForTaxCredit(RetNo, 'NL');
    Tv[133]:= MaxR(0, Tv[128] - Tv[132]);
    Tv[104]:= GetPrvPolit(RetNo, 'NL'); {Vl(FetchElm(RetNo,'POLIT',12));}

    if (Tv[104] <= 100) then
      x:= Tv[104] * 0.75
    else
    if ((Tv[104] > 100) and (Tv[104] <= 550)) then
      x:= (Tv[104] - 100) * 0.50 + 75
    else
    if (Tv[104] > 550) then
      x:= (Tv[104] - 550) * 0.3333 + 300;

    if x > 500 then x:= 500;

    Tv[108]:= x;
    Tv[110]:= MaxR(0, Tv[133] - Tv[108]);
    Tv[114]:= Vl(FetchElm(RetNo, 'T1272', 7));
    Tv[120]:= MaxR(0, Tv[110] - Tv[114]); //MaxR(0,Tv[118]-Tv[114]); //20151117
    Tv[68]:= Vl(FetchElm(RetNo, 'T1297', 6));
    Tv[69]:= MaxR(0, Tv[120] - Tv[68]);
    //2020020
    Tv[99]:= MaxR(0, Tv[92] - Tv[97]);
    Tv[100]:= Tv[99];
    Tv[93]:= MaxR(0, Tv[69] - Tv[100]);
    //----------------------
    if IsPrebankruptcyReturn(RetNo) then Tv[134]:= 0;

    Tv[139]:= MaxR(0, Tv[93] - Tv[134]); //20200107
    //Tv[139]:=MaxR(0,Tv[67]-Tv[134]);
    if UpperCase(Frm[FNo].Strings[115]) = 'Y' then Frm[FNo].Strings[115]:= 'X';

    if Frm[FNo].Strings[84] <> 'Y' then
    begin
      if (ret[RetNo].MarStatus > 2) then
      begin
        Frm[FNo].Strings[115]:= 'X';
        Frm[FNo].Strings[83]:= '';
      end;

      if (ret[RetNo].CouplingSw = True) and (ret[RetNo].MarStatus < 3) then
      begin
        SpRetNo:= GetSpRetNo(RetNo);

        if (SpRetNo > 0) then
        begin
          if Tv[69] >= Vl(FetchElmFNo(SpRetNo, FNo, 69)) then
          begin
            Frm[FNo].Strings[115]:= 'X';
            Frm[FNo].Strings[83]:= '';
          end else
          begin
            Frm[FNo].Strings[115]:= '';
            Frm[FNo].Strings[83]:= 'X';
          end;
        end;
      end;
    end;

    //If ret[RetNo].MarStatus>2 then Strings[15]:='N';
    Tv[82]:= CalcMortgageForeclosure(ret[RetNo].Lnn[12700], Vl(FetchElmFNo(RetNo,GetFormNo('S3'), 122)), Vl(FetchElmFNo(RetNo,GetFormNo('S3'), 72)));
    Tv[75]:= Vl(FetchElm(RetNo, 'FORECLO', 4));

    // Page 4
    Tv[148]:= MaxR(0, SelectNetIncomeAmount(retno) - Tv[82]); //20250222 //MaxR(0,ret[RetNo].Lnn[23600]-Tv[82]);
    if TosiInEffect(RetNo) then Tv[148]:= MaxR(0, GetTosiNetIncome(RetNo) - Tv[82]); //20190115

   // If GetRC310Income(RetNo)>0 then Tv[148]:=Lnn[23600];  //20101221  //20170126
    Tv[149]:= ret[RetNo].Lnn[21300] + Vl(FetchElm(RetNo, 'OTHDED', 60));
    Tv[150]:= Tv[148] + Tv[149];
    Tv[106]:= ret[RetNo].Lnn[11700] + ret[RetNo].Lnn[12500]; //+GetRC310Income(RetNo);  //20170126
    Tv[107]:= MaxR(0, Tv[150] - Tv[106]);

    Tv[70]:= MaxR(0, Vl(FetchElm(RetNo, 'INFO', 19)) - Tv[75]); //foreclosure spouse
    Tv[71]:= Vl(FetchElm(RetNo, 'INFO', 162)) + Vl(FetchElm(RetNo, 'S2', 34));
    Tv[73]:= Vl(FetchElm(RetNo, 'INFO', 131)) + Vl(FetchElm(RetNo, 'S2', 33)) + Vl(FetchElm(RetNo, 'INFO', 168)); //20101202;
    Tv[72]:= Tv[70] + Tv[71];
    Tv[74]:= MaxR(0, Tv[72] - Tv[73]);

    Tv[76] :=Tv[107] + Tv[74];

    Tv[77]:= Tv[139]; //20010309

    if UpperCase(Frm[FNo].Strings[115]) = 'X' then
    begin
      //20211116
      if RY = 0 then  //nl
      begin
        BasicRed:= 997; //974; //936; //886;  //20241207
        SpRed:= 557; //544; //523; //494;   //20231124
      end else
      begin
        BasicRed:= 997; //974; // 886; //20231124
        SpRed:= 557; //544; //494; //479   //20231124
      end;

      Tv[140]:= BasicRed;
      if Tv[77] = 0 then Tv[140]:= 0; //20180101

      if IsPrebankruptcyReturn(RetNo) then Tv[140]:= 0;
      if (ret[RetNo].MarStatus < 3) then Tv[141]:= SpRed else Tv[141]:= 0;
      if IsPrebankruptcyReturn(RetNo) then Tv[141]:= 0;

      if (Tv[29] > 0) then //elg dep
        Tv[142]:= SpRed
      else
        Tv[142]:= 0;

      if IsPrebankruptcyReturn(RetNo) then Tv[142]:= 0;
      if (Frm[FNo].Strings[83] > '') then
      begin
        Tv[140]:= 0;
        Tv[141]:= 0;
        Tv[142]:= 0;
      end; //20141201 Other sp claiming

      Tv[147]:= MinR(BasicRed + SpRed, Tv[140] + Tv[141] + Tv[142]);

      Tv[78]:= Tv[76];

      //20250527
      if RY = 0 then  //nl
      begin
        Thres1:= 23928; //23390; //21196; //19411;
        Thres2:= 40460; //39551; //not 39991 //20240302//35842; //20240219 33898;
      end else
      begin
        Thres1:= 23928; //23390; //1196; //19411; //20240219
        Thres2:= 40460; //39551; //39991; //32824;
      end;

      {//20191203
      if RY = 0 then  //nl
      begin
        Thres1:=22447; //21196; //19411;
        Thres2:=37957; //35842; //20240219 33898;
      end else
      begin
        Thres1:=22447; //1196; //19411; //20240219
        Thres2:=37957; //32824;
      end; }

      if ((Tv[141] > 0) or (Tv[142] > 0)) then
        Tv[151]:= Thres2
      else
        Tv[151]:= Thres1;

      Tv[152]:= MaxR(0, Tv[78] - Tv[151]);
      Tv[153]:= 16;
      Tv[154]:= Tv[152] * Tv[153] / 100;
      Tv[155]:= Tv[154];
      Tv[156]:= MaxR(0, Tv[147] - Tv[155]);
      Tv[157]:= Tv[156];
    end else
    begin
      for i:= 140 to 143 do Tv[i]:= 0;

      Tv[147]:= 0; //20141209

      for i:= 151 to 157 do Tv[i]:= 0;
    end;

    if Tv[134] > 0 then
    begin
      for i:= 140 to 143 do Tv[i]:= 0;

      Tv[147]:= 0; //20150305

      for i:= 151 to 157 do Tv[i]:= 0;
    end;

    Tv[109]:= MaxR(0, Tv[77] - Tv[157]);  //20161124

   // If Txbl <=50000 then Tv[113]:=0 else Tv[113]:=TotReduction; //20201121

    Tv[121]:= Tv[109]; //+Tv[113];  //20201129  //20201202
    Tv[79]:= Tv[157];  //:=Tv[69];
    Tv[80]:= Tv[93]; //Tv[67];  //20200227
    Tv[81]:= MaxR(0, Tv[79] - Tv[80]);

    Lnn[42800]:= Tv[121];
    Lnn[47900]:= Vl(FetchElm(RetNo, 'T1129', 9)); //20131025
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure NT428(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  x, y, z: Real;
  NormalPrvNonRefAmount:Real;
begin
  InitPrvConstants('NT');
  LoadTv(RetNo, FName, FNo);

  if not CalcThisProvince(RetNo, 'NT') then // Or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 148 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo,FName,FNo);
    exit;
  end;

  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= Ret[RetNo].Lnn[26000];

    {$region ' Top table '}
    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 66 to 72 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
    Frm[FNo].Strings[70] := PrvConstant[RY].PrvRate4;

    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;
    Tv[68]:= PrvConstant[RY].PrvBracket3;
    Tv[72]:= PrvConstant[RY].PrvBracketTax4;

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:= 0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket3) then
    begin
      Tv[66]:= Tv[1];
      Tv[68]:= PrvConstant[RY].PrvBracket3;
      Tv[69]:= MaxR(0, Tv[66] - Tv[68]);
      Tv[71]:= Tv[69] * Vl(Frm[FNo].Strings[70]) / 100;
      Tv[72]:= PrvConstant[RY].PrvBracketTax4;
      Tv[67]:= Tv[71] + Tv[72];
    end;
    {$endregion ' Top table '}

    Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear;
    Tv[24]:= Vl(FetchElm(RetNo, 'AGEDED', 17));
    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
    Tv[26]:= SpouseIncome(RetNo);
    Tv[26]:= GetSpouseTosiNetIncome(retNo, InfoFNo);   //20181227
    Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo)));
    Tv[28]:= Tv[27];

    if UpperCase(Frm[FNo].Strings[64]).Equals('Y') then Tv[28]:= Tv[65];

    //Tv[29]:= Vl(FetchElm(RetNo, 'S5PRV', 10));
    //20101111
    //20161219
    if HasEligibleDependant(RetNo) then
    begin
      Tv[73]:= PrvConstant[RY].PrvSpouseBasicAmount;
      Tv[74]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
      Tv[75]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[73] - Tv[74]));
      Tv[29]:= Vl(FetchElm(RetNo, 'S5PRV', 10));
    end else
    begin
      Tv[73]:= 0;
      Tv[74]:= 0;
      Tv[75]:= 0;
      Tv[29]:= 0;
    end;

    Tv[48]:= Tv[23] + Tv[24] + Tv[28] + Tv[29];
    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 87));
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[51]:= Ret[RetNo].Lnn[31217];
    Tv[78]:= Tv[31] + Tv[32] + Tv[33] + Tv[51];
    Tv[79]:= Tv[78];
    Tv[81]:= Tv[48] + Tv[79];

    //Page 2
    Tv[77]:= Tv[81];
    Tv[34]:= GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//ret[RetNo].Lnn[31400];
    Tv[35]:= Vl(FetchElm(RetNo, 'S5PRV', 90));
    Tv[82]:= Tv[77] + Tv[34] + Tv[35];

    if (Ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));

    Tv[37]:= GetPrvDisabXfer(RetNo);
    Tv[83]:= Tv[82] + Tv[36] + Tv[37];
    Tv[38]:= Ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[40]:= GetPrvEducXfer(RetNo);
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[76]:= Tv[83] + AddColumns(38, 41, 1) + Vl(FetchElm(RetNo, 'RC269', 10));
    //Tv[77]:= Tv[76];
    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    //20211115
    Tv[84]:= Ret[RetNo].Lnn[23600];
    Tv[85]:= 3;
    Tv[86]:= Tv[84] * Tv[85] / 100;
    Tv[87]:= MinR(Tv[86], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[87]);
    {Tv[80]:= PrvConstant[RY].PrvMedicalLimit;
    Tv[43]:= CalcPrvMedicalLimit(RetNo);
    Tv[44]:= MaxR(0,Tv[42]-Tv[43]);}
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= MaxR(0, Tv[44] + Tv[45]);
    Tv[47]:= Tv[46];
    Tv[49]:= Tv[76] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[53]:= GetS9DonLow(RetNo); //Lnn[32005];  //20161126Lnn[32005];
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo);  //20161126  Lnn[347];;
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57] / 100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];

    //Page 3
    Tv[101]:= MaxR(MaxR(Tv[20], Tv[21]), MaxR(Tv[22], Tv[67]));
    //MaxR(
    //MaxR(Vl(FetchElm(RetNo,'NT428',20)),Vl(FetchElm(RetNo,'NT428',21))),
    //MaxR(Vl(FetchElm(RetNo,'NT428',22)),Vl(FetchElm(RetNo,'NT428',67))));

    if SplitIncome(RetNo) then
      Tv[102]:= GetTOSIPrvTax(RetNo) //Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[102]:= 0;

    Tv[103]:= Tv[101] + Tv[102];
    NormalPrvNonRefAmount:= Tv[61];   //Vl(FetchElm(RetNo,'NT428',61));
    if AllowSaSb(RetNo) then Tv[104]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20260503
    Else Tv[104]:=NormalPrvNonRefAmount; //20260514

    //Tv[6] := PrvConstant[RY].PrvDivRate;
    //20161119
    // Tv[108] := ret[RetNo].Lnn[426];
    // Tv[109] := PrvConstant[RY].PrvOverseasRate;
    // Tv[110] := Tv[108] * Tv[109]/100;
    Tv[112]:= PrvConstant[RY].PrvAMTCarryOverRate;
    //Tv[5]:= ret[RetNo].Lnn[12000];
    Tv[111]:= Ret[RetNo].Lnn[40427];
    Tv[107]:= Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[5] * Tv[6]/100;
    Tv[113]:= Tv[111] * Tv[112] / 100;
    Tv[114]:= Tv[104] + Tv[107] + Tv[110] + Tv[113];
    Tv[115]:= Tv[114];
    Tv[116]:= MaxR(0, Tv[103] - Tv[115]);
    Tv[121]:= Vl(FetchElm(RetNo, 'T691', 316)); //20250222 //AmountForPrvMinTax(RetNo); //Vl(FetchElm(RetNo,'T691',316));

    if IsDeceased(RetNo) then Tv[121]:= 0;

    Tv[122]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[117]:= Tv[121] * Tv[122] / 100;
    Tv[118]:= Tv[116] + Tv[117];

    if not Ret[RetNo].Province.Equals('NT') then
      Tv[119]:= 0
    else
      Tv[119]:= GetPrvForTaxCredit(RetNo, 'NT');

    Tv[123]:= MaxR(0, Tv[118] - Tv[119]);
    Tv[124]:= GetPrvPolit(RetNo, 'NT'); {Vl(FetchElm(RetNo,'POLIT',12));}

    if (Tv[124] <= 100) then
      x:= MinR(100, Tv[124])
    else
    if (Tv[124] > 100) then
      x:= 100 + MaxR(0, (Tv[124] - 100)) * 0.50;

    Tv[125]:= MinR(500, x);
    Tv[120]:= MaxR(0, Tv[123] - Tv[125]);
    Lnn[42800]:= Tv[120];
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure PE428(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k, count: Integer;
  x, y, z: Real;
  SurTaxBase: Real;
  Prv: string;
  NormalPrvNonRefAmount:Real;
begin
  InitPrvConstants('PE');
  LoadTv(RetNo, FName, FNo);

  if not CalcThisProvince(RetNo, 'PE') then // or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 187 do
    begin
      ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    // Page 1
    Tv[1]:= ret[RetNo].Lnn[26000];

    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    for i:= 116 to 187 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    Frm[FNo].Strings[11]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13]:= PrvConstant[RY].PrvRate3;
    Frm[FNo].Strings[159]:= PrvConstant[RY].PrvRate4;
    Frm[FNo].Strings[184]:= PrvConstant[RY].PrvRate5;

    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[117]:= PrvConstant[RY].PrvBracket3;
    Tv[182]:= PrvConstant[RY].PrvBracket4;

    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;
    Tv[169]:= PrvConstant[RY].PrvBracketTax4;
    Tv[186]:= PrvConstant[RY].PrvBracketTax5;

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:= 0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;

    //20241207
    if (Tv[1] > PrvConstant[RY].PrvBracket3) and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
    begin
      Tv[116]:= Tv[1];
      Tv[117]:= PrvConstant[RY].PrvBracket3;
      Tv[121]:= MaxR(0, Tv[116] - Tv[117]);
     // //Tv[13]:=??
      Tv[164]:= Tv[121] * Vl(Frm[FNo].Strings[159]) / 100;
      Tv[169]:= PrvConstant[RY].PrvBracketTax4;
      Tv[174]:= Tv[164] + Tv[169];
    end;

    //20241207
    if (Tv[1] > PrvConstant[RY].PrvBracket4) then
    begin
      Tv[179]:= Tv[1];
      Tv[182]:= PrvConstant[RY].PrvBracket4;
      Tv[183]:= MaxR(0, Tv[179] - Tv[182]);
      // //Tv[84]:=??
      Tv[185]:= Tv[183] * Vl(Frm[FNo].Strings[184]) / 100;
      Tv[186]:= PrvConstant[RY].PrvBracketTax5;
      Tv[187]:= Tv[185] + Tv[186];
    end;

    Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear;

    if UpperCase(Frm[FNo].Strings[62]) = 'Y' then
      Tv[24]:= Tv[63]
    else
      Tv[24]:= Vl(FetchElm(RetNo, 'AGEDED', 17));

    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
    Tv[26]:= SpouseIncome(RetNo);
    Tv[26]:= GetSpouseTosiNetIncome(retNo, InfoFNo);   //20181227
    Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo)));
    //Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[25] - Tv[26]));
    Tv[28]:= Tv[27];

    if UpperCase(Frm[FNo].Strings[64]) = 'Y' then Tv[28]:= Tv[65];

    // Tv[29]:= Vl(FetchElm(RetNo, 'S5PRV', 10));
    //20101113
    Tv[77]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;   //7474 * PartYear;  //20190117
    Tv[78]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
    Tv[79]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[77] - Tv[78]));
    Tv[29]:= Vl(FetchElm(RetNo, 'S5PRV', 10));
    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 87));
    Frm[FNo].Strings[67]:= FetchElm(RetNo, 'PE428', 181);

    if (Ret[RetNo].MarStatus < 3) then
      if not IsLowerIncomeSpouse(RetNo) then Frm[FNo].Strings[67]:= '';

    Tv[68]:= Vl(Frm[FNo].Strings[67]) * 100;
    Tv[87]:= Tv[23] + Tv[24] + Tv[28] + Tv[29] + Tv[30] + Tv[68];

    //kids 20110116
    i:= 160;
    k:= 0;
    repeat
      if (Vl(Frm[FNo].Strings[i]) > 12) then Frm[FNo].Strings[i]:= '12';
      if (Ret[RetNo].Lnn[23600] > Vl(FetchElm(RetNo, 'INFO', 19))) and (Ret[RetNo].MarStatus < 3) then Frm[FNo].Strings[i]:= '0';

      k:= k + MyStrToInt(Frm[FNo].Strings[i]);
      Inc(i, 5);
    until i > 180;  //20110116

    Frm[FNo].Strings[181]:= IntToStr(k);
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[80]:= Ret[RetNo].Lnn[31217];
    Tv[93]:= Tv[31] + Tv[32] + Tv[33] + Tv[80];
    Tv[95]:= Tv[93];
    Tv[96]:= Tv[87] + Tv[95];

    // Page 2
    Tv[91]:= Tv[96];
    Tv[34]:= GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));
    Tv[35]:= Vl(FetchElm(RetNo, 'S5PRV', 90));
    Tv[97]:= Tv[91] + Tv[34] + Tv[43] + Tv[35];   //20211116

    if (CalcAge(FetchElmFNo(RetNo, InfoFNo, 9)) >= 18) then  //20200410 //If ret[RetNo].Age >=18 then
    begin
      //If IsMultJurisdiction(RetNo) then DISAB18(RetNo,FName,FNo,'PE'); //jz//MJCERT2025v1 - remove, causing errors  //jz//20260327//MJCERT2025 - this might be needed here and everywhere to get correct amounts? not sure...
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14));
    end
    else
    begin
      //If IsMultJurisdiction(RetNo) then DISAB18(RetNo,FName,FNo,Prv); //jz//MJCERT2025v1 - remove, causing errors  //jz//20260327//MJCERT2025 - PRV is blank? shouldn't it be corresponding province?
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));
    end;

    Tv[37]:= GetPrvDisabXfer(RetNo);

    if Tv[75] > 500 then Tv[75]:= 500;

    Tv[98]:= Tv[97] + Tv[36] + Tv[37] + Tv[75];
    Tv[38]:= ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[40]:= GetPrvEducXfer(RetNo);
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[90]:= Tv[98] + AddColumns(38, 41, 1) + Vl(FetchElm(RetNo, 'RC269', 10));

    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    //20211115
    Tv[94]:= Ret[RetNo].Lnn[23600];
    Tv[99]:= 3;
    Tv[100]:= Tv[94] * Tv[99] / 100;
    Tv[113]:= MinR(Tv[100], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0,Tv[42] - Tv[113]);
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= MaxR(0, Tv[44] + Tv[45]);
    Tv[47]:= Tv[46];
    Tv[49]:= Tv[90] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[53]:= GetS9DonLow(RetNo); //Lnn[32005];  //20161126Lnn[32005];
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo);  //20161126  Lnn[347];Lnn[347];
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57] / 100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];
  end;

  //Page 3
  with Ret[RetNo].Frm[FNo] do
  begin
    //20241208
    Tv[101]:= MaxR(TV[20], MaxR(TV[21], TV[22]));
    Tv[101]:= MaxR(Tv[101], Tv[174]);
    Tv[101]:= MaxR(Tv[101], Tv[187]);

    if SplitIncome(RetNo) then
      Tv[102]:= GetTOSIPrvTax(RetNo) //Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[102]:= 0;

    Tv[103]:= Tv[101] + Tv[102];
    NormalPrvNonRefAmount:= TV[61];
    if AllowSaSb(RetNo) then Tv[104]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20260503
      Else TV[104]:=NormalPrvNonRefAmount; //20260514

    Tv[92]:= MaxR(0, Tv[103] - Tv[104]);

    //Tv[93]:=Tv[92];
    Tv[108]:= Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[5] * Tv[7]/100;
    Tv[141]:= PrvConstant[RY].PrvAmtCarryOverRate;
    Tv[140]:= Ret[RetNo].Lnn[40427];
    Tv[142]:= Tv[140] * Tv[141] / 100;
    Tv[143]:= Tv[108] + Tv[142]; //Tv[104]+Tv[108]+Tv[117]+Tv[142];
    Tv[144]:= Tv[143];
    Tv[145]:= MaxR(0, Tv[92] - Tv[144]);

    Tv[131]:= Vl(FetchElm(RetNo, 'T691', 316)); //20250222 //AmountForPrvMinTax(RetNo); //Vl(FetchElm(RetNo,'T691',316));  //20190217

    if IsDeceased(RetNo) then Tv[131]:= 0;

    Tv[132]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[146]:= Tv[131] * Tv[132] / 100;
    Tv[147]:= Tv[145] + Tv[146];

    { //20241208 surtax removed
    Tv[148] := Tv[147];
    If RY=0 then SurTaxBase:=12500 else SurTaxBase:=12500;
    Tv[149] := MaxR(0,Tv[148] - SurTaxBase) * 10/100;
    Tv[150] := Tv[147]+Tv[149];
    }
    if IsPrebankruptcyReturn(RetNo) then Tv[151]:= 0;

    Tv[152]:= MaxR(0, Tv[147] - Tv[151]); //jz 20250202 just the wrong elm //Tv[152] := MaxR(0,Tv[150]-Tv[151]);

    {Step 4}
    if (Strings[137] + Strings[138] = '') then Strings[137]:= 'X'; //claimed by self
    {reduction}
    Tv[139]:= CalcMortgageForeclosure(ret[RetNo].Lnn[12700], Vl(FetchElmFNo(RetNo,GetFormNo('S3'), 122)), Vl(FetchElmFNo(RetNo,GetFormNo('S3'), 72)));
    Tv[155]:= Vl(FetchElm(RetNo, 'FORECLO', 4));

    if UpperCase(Strings[137]) = 'X' then   //claimed by self
    begin
      Tv[122]:= MaxR(0, SelectNetIncomeAmount(RetNo) - Tv[82]); //20250222 //MaxR(0,ret[RetNo].Lnn[23600]-Tv[82]);//MaxR(0,ret[RetNo].Lnn[23600]-Tv[139]);

      if TosiInEffect(RetNo) then Tv[122]:= MaxR(0, GetTosiNetIncome(RetNo) - Tv[139]);

      Tv[123]:= Ret[RetNo].Lnn[21300]; //PE does not add 232
      Tv[124]:= Tv[122] + Tv[123];
      Tv[105]:= Ret[RetNo].Lnn[11700]; //PE does not 125
      Tv[107]:= MaxR(0, Tv[124] - Tv[105]);
      Tv[51]:= MaxR(0, Vl(FetchElm(RetNo, 'INFO', 19)) - Tv[155]); //spnetincome
      Tv[69]:= Vl(FetchElm(RetNo, 'INFO', 162));
      Tv[71]:= Vl(FetchElm(RetNo, 'INFO', 131));
      Tv[70]:= Tv[51] + Tv[69];
      Tv[72]:= MaxR(0, Tv[70] - Tv[71]);
      Tv[73]:= Tv[107] + Tv[72];
      Tv[139]:= CalcMortgageForeclosure(ret[RetNo].Lnn[12700], Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 122)), Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 72)));

      //Page 4
      Tv[109]:= 350; //20161124

      if (IsPrebankruptcyReturn(RetNo)) or (IsDeceased(RetNo)) then Tv[109]:= 0;
      if (Ret[RetNo].Age >= 65) then Tv[89]:= 250 else Tv[89]:= 0; //20150906
      if (Ret[RetNo].MarStatus < 3) then
        Tv[114]:= 350 //spouse
      else
        Tv[114]:= 0; //20150906

      if IsPrebankruptcyReturn(RetNo) then Tv[114]:= 0;

      Tv[88]:= 0;

      if (FetchElm(RetNo, 'INFO', 59) > '') and (Ret[RetNo].MarStatus < 3) and (CalcAge(FetchElm(RetNo, 'INFO', 59)) >= 65) then Tv[88]:= 250; //20151123 SPOUSE AGE
      //NOTE If Married and also Elig pendant then claim spouse only...

      if (Tv[29] > 0) then Tv[115]:= 350 else Tv[115]:= 0; //20150906
      //If ret[RetNo].Lnn[30425]>0 then Tv[115] := 350 else Tv[115] :=0; //20150906

      if (Ret[RetNo].MarStatus < 3) then Tv[115]:= 0;  //20181208

      Strings[118]:= IntToStr(MystrToInt(FetchElm(RetNo, 'DEPEND', 1)) - MystrToInt(FetchElm(RetNo, 'DEPEND', 3)));

      if (Vl(Strings[118]) < 0) then Strings[118]:= '';
      if (Strings[138] > '') then
      begin
        Tv[109]:= 0;
        Tv[114]:= 0;
        Tv[115]:= 0;
        Strings[118]:= '';
      end; //20141201 Other sp claiming

      Tv[119]:= Vl(Ret[RetNo].Frm[FNo].Strings[118]) * 300; //20161124 //200;  //20150906

      if (IsPreBankruptcyReturn(RetNo)) or (IsDeceased(RetNo)) then
      begin
        Tv[109]:= 0;
        Tv[89]:= 0;  //20151117
        Tv[114]:= 0;
        Tv[88]:= 0;  //20151117
        Tv[115]:= 0;
        Tv[119]:= 0;
      end;
      Tv[120]:= Tv[109] + Tv[89] + Tv[114] + Tv[88] + Tv[115] + Tv[119]; //20151117  //Tv[109] + Tv[114] + Tv[115] + Tv[119];

      //PG4
      Tv[74]:= Tv[152];
      // Tv[94]:=Tv[120];   ???? Whatis this? 94 is used in Medical section above

      Tv[76] := MaxR(0,Tv[73]);
      Tv[155]:=Vl(FetchElm(RetNo,'FORECLO',4)); //CalcMortgageForeclosure(SpRetNo);

      if (Ry = 0) then   //20221208
        Tv[125]:= 22650 //20750  //20000
      else
        Tv[125]:= 22650; //20750; //20000;

      Tv[126]:= MaxR(0, (Tv[76] - Tv[125]));
      Tv[127]:= 5;
      Tv[128]:= Tv[126] * Tv[127] / 100;
      Tv[129]:= Tv[128];
      Tv[111]:= MaxR(0, (Tv[120] - Tv[129]));
      Tv[130]:= Tv[111];

      if (Tv[151] > 0) then Tv[130]:= 0;  //20160317  used the unused from the other spouse //20160505 Igor
    end else
    begin
      Tv[109]:= 0;
      Tv[76]:= 0;
      Tv[107]:= 0;
      Tv[89]:= 0;

      for i:= 114 to 115 do Tv[i]:= 0;
      for i:= 118 to 120 do Tv[i]:= 0;
      for i:= 125 to 130 do Tv[i]:= 0;
    end;

    //less than 19, no kids, no spouse
    if (ret[RetNo].Age < 19) and (Tv[114] + Tv[115] + Tv[119] = 0) then
    begin
      Tv[109]:= 0;

      for i:= 114 to 115 do TV[i]:= 0;
      for i:= 119 to 129 do TV[i]:= 0;

      Tv[111]:= 0;
      Tv[130]:= 0;
    end;

    if (Ret[RetNo].Province <> 'PE') then Tv[130]:= 0;
    Tv[74]:= Tv[152];
    Tv[153]:= MaxR(0, Tv[74] - Tv[130]);
    Tv[154]:= GetPrvForTaxCredit(RetNo, 'PE');
    Tv[133]:= MaxR(0, Tv[153] - Tv[154]);

    if ret[RetNo].Province = 'PE' then
    begin
      {Polit}
      Tv[106]:= GetPrvPolit(RetNo, 'PE'); {Vl(FetchElm(RetNo,'POLIT',12));}

      if Tv[106] <=100 then
        x:= Tv[106] * 0.75
      else
      if ((Tv[106] > 100) and (Tv[106] <= 550)) then
        x:= (Tv[106] - 100) * 0.50 + 75
      else
      if (Tv[106] > 550) then
        x:= (Tv[106] - 550) * 0.3333 + 300;

      if (x > 500) then x:=500;

       Tv[110]:= x;
    end;

    Tv[81]:= MaxR(0, Tv[133] - Tv[110]);
    Tv[84]:= Tv[82] + Tv[83];

    if (Tv[84] > 7000) then Tv[84]:= 7000;

    Tv[85]:= Tv[84];
    Tv[112]:= MaxR(0, Tv[81] - Tv[85]);//MaxR(0,Tv[133]-Tv[110]);  //20111104

    if (Tv[86] > 0.01) then Tv[86]:= 1000; //500; //20221203

    Tv[134] := Tv[130];
    Tv[135]:= Tv[150];
    Tv[136]:= MaxR(0, Tv[134] - Tv[135]);

    Ret[RetNo].Lnn[42800]:= Tv[112];
    Ret[RetNo].Lnn[47900]:= Tv[86];

    (*
    // young children
    i:=160;
    k:=0;
    Repeat
     If Vl(Strings[i])>12 then Strings[i]:='12';
     If AppYear='2006' then
     begin
      If Vl(Strings[i])>6 then Strings[i]:='6';
     end;
     If (ret[RetNo].Lnn[23600] > Vl(FetchElm(RetNo,'INFO',19)))
     and (ret[RetNo].MarStatus <3)  then Strings[i-1]:='';
     If Strings[i-1] >'' then  k:=k+MyStrToInt(Strings[i]);
     Inc(i,5);
    until i>180;
    Strings[181]:=IntToStr(k);  *)
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure MB428(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j, k: Integer;
  lValT1_23600: Real;
  NormalPrvNonRefAmount:Real;
begin
  InitPrvConstants('MB');
  LoadTv(RetNo, FName, FNo);

  if not CalcThisProvince(RetNo, 'MB') then // Or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 161 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= Ret[RetNo].Lnn[26000];

    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    {$region ' Top table '}
    Frm[FNo].Strings[11]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13]:= PrvConstant[RY].PrvRate3;
    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:=0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      {ret[RetNo].Frm[FNo].Strings[11]:= OnConstant[RY].OnRate1;}
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;
    {$endregion ' Top table '}

    //Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear; //250922 Igor
    //lValT1_23600:= Vl(FetchElm(RetNo, 'T1', 322));

   {20251224CZ rermoved John notes
    //jz//20251221formatting to make this if/else easier to read
    if (lValT1_23600 < 200000) then
      Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear
    else
    begin
      if ((lValT1_23600 >= 200000) or (lValT1_23600 < 400000)) then
        Tv[23]:= Vl(FetchElm(RetNo, 'MB428WS', 119))
      else
        if (lValT1_23600 >= 400000) then
          Tv[23]:= 0;
    end;
   }

    Tv[23]:= Vl(FetchElm(RetNo, 'MB428WS', 119)); //jz//20260131 - MB428WS 58040 fixed, use it now as other was inadequet
    Tv[24]:= Vl(FetchElm(RetNo, 'AGEDED' , 17));  //20251224 JOHN notes


    {removed as per John notes
    //jz//20251221formatting to make this if/else easier to read
    if (lValT1_23600 < PrvConstant[RY].PrvAgeBaseAmount) then
      Tv[24]:= PrvConstant[RY].PrvMaxAgeAmount
    else
    begin
      if ((lValT1_23600 >= PrvConstant[RY].PrvAgeBaseAmount) or (lValT1_23600 < PrvConstant[RY].PrvAgeNIThreshHold)) then
        Tv[24]:= Vl(FetchElm(RetNo, 'MB428WS', 13))
      else
        if (lValT1_23600 >= PrvConstant[RY].PrvAgeNIThreshHold) then
          Tv[24]:= 0;
    end;
   }

    //Tv[24]:= MinR(PrvConstant[RY].PrvMaxAgeAmount, Vl(FetchElm(RetNo, 'AGEDED', 17)));//250922 Igor
    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
    Tv[26]:= SpouseIncome(RetNo);
    Tv[26]:= GetSpouseTosiNetIncome(retNo,InfoFNo); //20181227
    Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo)));
    //Tv[27]:= MaxR(0, Tv[25] - Tv[26]);
    Tv[28]:= Tv[27];

    if (UpperCase(Frm[FNo].Strings[64]) = 'Y') then Tv[28]:= Tv[65];
    //=======================================
    //20260307
    if HaveEligibleDependant(RetNo)=True then
    begin
     Tv[100]:= PrvConstant[RY].PrvSpouseBasicAmount; //20171113
     Tv[99] := GetEligibleDependantNetIncome(RetNo); //Vl(FetchElm(RetNo, 'S5PRV', 8)); //20260607
     Tv[98]:= MaxR(0, Tv[100] - Tv[99]);
    end
    Else
    begin
     Tv[100]:=0;
     Tv[99]:=0;
     Tv[98]:=0;
    end;

    //Tv[98]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, Vl(FetchElm(RetNo, 'S5PRV', 10))); //20250922 Igor

    (*
    //20260307
    //20251210 Igor >>>
    if (Tv[99] > 0) then
      Tv[98]:= MaxR(0, Tv[100] - Tv[99])
    else
      Tv[98]:= 0;
    //20251210 Igor <<<
    *)

    TV[29]:=Tv[98];  //20260304CZ

    //Tv[30]:= Vl(FetchElm(RetNo, 'MB428WS', 30));  20251224CZ rermoved John notes
    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 87));   //20251224CZ
    Tv[69]:= Tv[23] + Tv[24] + Tv[28] + Tv[29] + Tv[30];
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[68]:= Ret[RetNo].Lnn[31217];

    //20170424
    if (Ret[RetNo].Province= 'MB') then
      Tv[77]:= Vl(FetchElm(RetNo, 'T1', 109)) //20251210 Igor //MinR(3000, Vl(FetchElm(RetNo, 'T1', 109))) //jz//20250306 - max is 3000 //20151102 Vl(FetchElm(RetNo,'S1',79))  //20190922
    else
      Tv[77]:= 0;

    //20170424
    if (Ret[RetNo].Province = 'MB') then
      Tv[78]:= Vl(FetchElm(RetNo, 'T1', 110)) //20251210 Igor //MinR(3000, Vl(FetchElm(RetNo, 'T1', 110))) //jz//20250306 - max is 3000 //20151102 //Vl(FetchElm(RetNo,'S1',25))  //20190922
    else
      Tv[78]:= 0;

    Tv[67]:= Vl(FetchElm(RetNo, 'MBFITNES', 3));
    Tv[74]:= Vl(FetchElm(RetNo, 'MBARTS', 3)); //20161212 //ret[RetNo].Lnn[370];  //20111104
    Tv[51]:= TotMultiple(RetNo, 'ADOPT', 68); //ret[RetNo].Lnn[31300];
    Tv[79]:= Tv[31] + Tv[32] + Tv[33] + Tv[68] + Tv[77] + Tv[78] + Tv[67] + Tv[74] + Tv[51];
    Tv[82]:= Tv[79];
    Tv[83]:= Tv[69] + Tv[82];

    //Page 2
    Tv[80]:= Tv[83];
    Tv[34]:= GetPrvPnsDed(RetNo); //Vl(FetchElm(RetNo,'PNSDED',18));
    tV[35]:=Vl(FetchElm(RetNo,'S5PRV',90)); //20251224CZ
   // Tv[35]:= Vl(FetchElm(RetNo, 'MB428WS', 46)); //250922 Igor //Vl(FetchElm(RetNo,'S5PRV',90)); //not 39
    Tv[48]:= Tv[80] + Tv[34] + Tv[35];

    if (Ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      tV[36]:=Vl(FetchElm(RetNo, 'DISAB18', 24));  //CZ
      //Tv[36]:= Vl(FetchElm(RetNo, 'MB428WS', 55)); //250922 Igor //Vl(FetchElm(RetNo, 'DISAB18', 24));
    Tv[37]:= GetPrvDisabXfer(RetNo);  //30251224
    //Tv[37]:= Vl(FetchElm(RetNo, 'MB428WS', 69)); //250922 Igor //GetPrvDisabXfer(RetNo);
    Tv[81]:= Tv[48] + Tv[36] + Tv[37];
    //Tv[81]:= Tv[48] + Tv[36] + Tv[37];
    Tv[38]:= Ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[40]:= GetPrvEducXfer(RetNo);
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[71]:= Vl(FetchElm(RetNo, 'MB428A', 42));
    Tv[70]:= Tv[81] + Tv[38] + Tv[39] + Tv[40] + Tv[41] + Tv[71];

    {Tv[70]:=Tv[69]+AddColumns(30,33,1)+Tv[68]+Tv[77]+Tv[78]
           +Tv[67]+Tv[74]+Tv[51]  //20111104
           +AddColumns(34,41,1)
           +Tv[71]
           +Vl(FetchElm(RetNo,'RC269',10));  //added in 20150906}
    // Tv[80]:=Tv[70];

    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    //20211115
    Tv[84]:= Ret[RetNo].Lnn[23600];
    Tv[85]:= 3;
    Tv[86]:= Tv[84] * Tv[85] / 100;
    Tv[87]:= MinR(Tv[86], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[87]);
    //Tv[66] := PrvConstant[RY].PrvMedicalLimit;
    //PrvConstant[RY].PrvMedicalLimit
    //Tv[43] := CalcPrvMedicalLimit(RetNo);
    //Tv[44] := MaxR(0,Tv[42]-Tv[43]);
    Tv[45]:=Vl(FetchElm(RetNo, 'MEDPRV', 76)); //CZ
    //Tv[45]:= Vl(FetchElm(RetNo, 'MB428WS', 82)); //250922 Igor //Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= MaxR(0, Tv[44] + Tv[45]);
    Tv[47]:= Tv[46];
    Tv[49]:= Tv[70] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[53]:= GetS9DonLow(RetNo); //Lnn[32005];  //20161126
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo);  //20161126  Lnn[347];Lnn[347];
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57] / 100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];

    //Page 3
    //Tv[1]:= MaxR(MaxR(Vl(FetchElm(RetNo,'MB428',20)),
    Tv[101]:= MaxR(Tv[20], MaxR(Tv[21], Tv[22]));

    if SplitIncome(RetNo) then
      Tv[112]:= GetTOSIPrvTax(RetNo) // Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[112]:= 0;

    Tv[113]:= Tv[101] + Tv[112];
    NormalPrvNonRefAmount:= Tv[61];          //Vl(FetchElm(RetNo,'MB428',61));
    if AllowSaSb(RetNo) then Tv[105]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20150412
       Else Tv[105]:=NormalPrvNonRefAmount; //20260514

    //20161119
    //Tv[108]:= ret[RetNo].Lnn[426];
    //Tv[110]:= PrvConstant[RY].PrvOverseasRate;
    //Tv[162]:= Tv[108] * Tv[110]/100;

    Tv[111]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[163]:= Ret[RetNo].Lnn[40427];
    Tv[107]:=Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[6] * Tv[9]/100;
    //Tv[107]:= Vl(FetchElm(RetNo, 'MB428WS', 88)); //250922 Igor //Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[6] * Tv[9]/100;
    Tv[164]:= Tv[163] * Tv[111] / 100;
    Tv[165]:= Tv[105] + Tv[107] + Tv[164];  //20161127
    Tv[166]:= Tv[165];
    Tv[167]:= MaxR(0, Tv[113] - Tv[166]);
    // Tv[81]:=Tv[167];
    Tv[114]:= Vl(FetchElm(RetNo, 'T691', 316)); //20250222 //AmountForPrvMinTax(RetNo);
    Tv[115]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[118]:= Tv[114] * Tv[115] / 100;
    Tv[119]:= Tv[167] + Tv[118]; //20210101
    Tv[120]:= GetPrvPolit(RetNo, 'MB');

    //MB428ws(RetNo, 'MB428ws', GetFormNo('MB428ws')); //jz//20251219 - not sure if this might be helpful? try without for now

    {
    //jz//20251219 added all the if elses and 0 if there is no amount
    if      (Vl(FetchElm(RetNo, 'MB428WS', 95)) > 0)  then Tv[121]:= Vl(FetchElm(RetNo, 'MB428WS', 95))
    else if (Vl(FetchElm(RetNo, 'MB428WS', 102)) > 0) then Tv[121]:= Vl(FetchElm(RetNo, 'MB428WS', 102))
    else if (Vl(FetchElm(RetNo, 'MB428WS', 109)) > 0) then Tv[121]:= Vl(FetchElm(RetNo, 'MB428WS', 109))
    else Tv[121]:= 0;
    }
    //250922 Igor
    //20251222CZ
    if (Tv[120] <= 400) then
      Tv[121]:= Tv[120] * 0.75
    else
    if (Tv[120] > 400) and (Tv[120] <= 750) then
      Tv[121]:= (Tv[120] - 400) * 0.50 + 300
    else
      Tv[121]:= (Tv[120] - 750) * 0.3333 + 475;

    if (Tv[121] > 650) then Tv[121]:= 650;

    Tv[122]:= MaxR(0, Tv[119] - Tv[121]);
    {lab sp}
    if (Tv[123] > 1800) then Tv[123]:= 1800; //Tv[23] := MinR(750,Tv[23]);
    {equity}
    Tv[127]:= MaxR(0,Tv[122] - Tv[123]);
    Tv[144]:= GetPrvForTaxCredit(RetNo, 'MB');

    if (Tv[118] > 0) then Tv[144]:= 0;  //if min tax

    Tv[103]:= MaxR(0, Tv[127] - Tv[144]);
    Tv[14]:= Vl(FetchElm(RetNo, 'T1241', 6));
    Tv[168]:= Vl(FetchElm(RetNo, 'T1256', 6));

    if (Tv[168] > 9000) then Tv[168]:= 9000;  //20211116  ??

    Tv[116]:= MaxR(0, Tv[103] - Tv[168]); //MaxR(0,Tv[3]-Tv[4]);
    Tv[104]:= Vl(FetchElm(RetNo, 'T1241', 6));
    Tv[72]:= Vl(FetchElm(RetNo, 'T12561', 4));

    if (Tv[72] > 120000) then Tv[72]:= 120000; //20211116 was 67,500?

    Tv[73]:= MaxR(0, Tv[116] - Tv[72]);
    Tv[75]:= Vl(FetchElm(RetNo, 'T12562', 20)); //20160112
    Tv[76]:= MaxR(0, Tv[73] - Tv[75]);
    Tv[145]:= MaxR(0, Tv[76] - Tv[104]);//20181110 //Tv[69]:=MaxR(0,Tv[76]-Tv[104]); TV[70]:=MinR(500,Vl(FetchElm(RetNo,'T1005',11))); Tv[145] := MaxR(0,Tv[69]-Tv[70]);
    Lnn[42800]:= Tv[145];
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure MB428WS(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j, k: Integer;
  lIncomeThreshold: Real;
  lPolitContributionsVal: Real;
begin
  InitPrvConstants('MB');
  LoadTv(RetNo, FName, FNo);

  lIncomeThreshold:= 200000;

  if not CalcThisProvince(RetNo, 'MB') then // Or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 119 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    //58040 --------------------------------------------------------------------
    Tv[110]:= PrvConstant[RY].PrvPersAmount; //jz should there be a partyear here (and below)????
    Tv[111]:= Ret[RetNo].Lnn[23600];
    Tv[112]:= lIncomeThreshold;
    Tv[113]:= MaxR(0, Tv[111] - Tv[112]);
    Tv[114]:= lIncomeThreshold;
    strings[115]:= FormatFloat('0.#######', MaxR(0, Tv[113] / Tv[114])); //jz//20260131 - change to strings to capture all decimal places as too few was giving wrong result
    Tv[116]:= PrvConstant[RY].PrvPersAmount;
    Tv[117]:= MaxR(0, vl(strings[115]) * Tv[116]);
    Tv[118]:= Tv[117];
    Tv[119]:= MaxR(0, Tv[110] - Tv[118]);

    //58080 --------------------------------------------------------------------
    Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount;
    Tv[7]:= Ret[RetNo].Lnn[23600];
    Tv[8]:= PrvConstant[RY].PrvAgeBaseAmount;

    If Age >= 65 then
    begin
      Tv[9]:= MaxR(0, Tv[7] - Tv[8]);
      Tv[10]:= 15;
      Tv[11]:= MaxR(0, Tv[9] * Tv[10] / 100);
      Tv[12]:= Tv[11];
      Tv[13]:= MaxR(0, Tv[6] - Tv[12]);
    end;

    //Page 2
    //58200 --------------------------------------------------------------------
    Tv[15]:= PrvConstant[RY].PrvInfirmDependBase;
    Tv[20]:= PrvConstant[RY].PrvInfirmDependBase;
    Tv[25]:= PrvConstant[RY].PrvInfirmDependBase;

    { //jz//20251218 - wrong, who did this??
    Tv[16]:= Ret[RetNo].Lnn[23600];
    Tv[21]:= Ret[RetNo].Lnn[23600];
    Tv[26]:= Ret[RetNo].Lnn[23600];
    }

    //jz//20251218
    Tv[16]:= Vl(FetchElm(RetNo, 'DEPEND', 13));
    Tv[21]:= Vl(FetchElm(RetNo, 'DEPEND', 28));
    Tv[26]:= Vl(FetchElm(RetNo, 'DEPEND', 43));
    //jz//20251218 - minR, not maxR
    Tv[17]:= minR(PrvConstant[RY].PrvMaxInfirmDependAmount, Tv[15] - Tv[16]);
    Tv[22]:= minR(PrvConstant[RY].PrvMaxInfirmDependAmount, Tv[20] - Tv[21]);
    Tv[27]:= minR(PrvConstant[RY].PrvMaxInfirmDependAmount, Tv[25] - Tv[26]);

    //jz//20251218 - this seems wrong as well, but what should it be?
    Tv[18]:= Vl(FetchElm(RetNo, 'MB428', 98));
    Tv[23]:= Vl(FetchElm(RetNo, 'MB428', 98));
    Tv[28]:= Vl(FetchElm(RetNo, 'MB428', 98));

    Tv[19]:= MaxR(0, Tv[17] - Tv[18]);
    Tv[24]:= MaxR(0, Tv[22] - Tv[23]);
    Tv[29]:= MaxR(0, Tv[27] - Tv[28]);
    Tv[30]:= Tv[19] + Tv[24] + Tv[29];
    //58400
    Tv[31]:= PrvConstant[RY].PrvCareGvrBase;
    Tv[36]:= PrvConstant[RY].PrvCareGvrBase;
    Tv[41]:= PrvConstant[RY].PrvCareGvrBase;


    { //jz//20251218 - very wrong , who did this??
    Tv[32]:= Ret[RetNo].Lnn[23600];
    Tv[37]:= Ret[RetNo].Lnn[23600];
    Tv[42]:= Ret[RetNo].Lnn[23600];
    }

    //jz//20251218
    Tv[32]:= Vl(FetchElm(RetNo, 'DEPEND', 13));
    Tv[37]:= Vl(FetchElm(RetNo, 'DEPEND', 28));
    Tv[42]:= Vl(FetchElm(RetNo, 'DEPEND', 43));
    //jz//20251218 - minR, not maxR
    Tv[33]:= minR(PrvConstant[RY].PrvMaxInfirmDependAmount, Tv[31] - Tv[32]);
    Tv[38]:= minR(PrvConstant[RY].PrvMaxInfirmDependAmount, Tv[36] - Tv[37]);
    Tv[43]:= minR(PrvConstant[RY].PrvMaxInfirmDependAmount, Tv[41] - Tv[42]);

    //jz//20251218 - this block seems wrong as well but what should it be
    Tv[34]:= Vl(FetchElm(RetNo, 'MB428', 98));
    Tv[39]:= Vl(FetchElm(RetNo, 'MB428', 98));
    Tv[44]:= Vl(FetchElm(RetNo, 'MB428', 98));

    Tv[35]:= MaxR(0, Tv[33] - Tv[34]);
    Tv[40]:= MaxR(0, Tv[38] - Tv[39]);
    Tv[45]:= MaxR(0, Tv[43] - Tv[44]);
    Tv[46]:= Tv[35] + Tv[40] + Tv[45];
    //58440
    Tv[47]:= PrvConstant[RY].PrvMaxDisability;
    Tv[48]:= PrvConstant[RY].PrvMaxInfirmDependAmount;
    //Tv[49]:= 0; //??? Filled by user?
    Tv[50]:= PrvConstant[RY].PrvDisabSuplBase;
    Tv[51]:= MaxR(0, Tv[49] - Tv[50]);
    Tv[52]:= Tv[51];
    Tv[53]:= MaxR(0, Tv[48] - Tv[52]);
    Tv[54]:= Tv[53];
    Tv[55]:= MinR(9785, Tv[47] + Tv[54]);

    //Page 3
    //58480 --------------------------------------------------------------------
    Tv[56]:= PrvConstant[RY].PrvMaxDisability;
    Tv[57]:= PrvConstant[RY].PrvMaxInfirmDependAmount;
    //Tv[58]:= 0; //??? Filled by user?
    Tv[59]:= PrvConstant[RY].PrvDisabSuplBase;
    Tv[60]:= MaxR(0, Tv[58] - Tv[59]);
    Tv[61]:= Tv[60];
    Tv[62]:= MaxR(0, Tv[57] - Tv[61]);
    Tv[63]:= Tv[62];
    Tv[64]:= Tv[56] + Tv[63];
    Tv[65]:= Vl(FetchElm(RetNo, 'MB428', 48));
    Tv[66]:= Tv[64] + Tv[65];
    Tv[67]:= Ret[RetNo].Lnn[26000];
    Tv[68]:= MaxR(0, Tv[66] - Tv[67]);
    Tv[69]:= MinR(Tv[64], Tv[68]);
    //58729 --------------------------------------------------------------------
    //Tv[73]:= 0; //??? Filled by user?
    //Tv[74]:= 0; //??? Filled by user?
    //Tv[75]:= 0; //??? Filled by user?
    Tv[76]:= Vl(FetchElm(RetNo, 'MB428', 87));
    Tv[77]:= Vl(FetchElm(RetNo, 'MB428', 87));
    Tv[78]:= Vl(FetchElm(RetNo, 'MB428', 87));
    Tv[79]:= MaxR(0, Tv[73] - Tv[76]);
    Tv[80]:= MaxR(0, Tv[74] - Tv[77]);
    Tv[81]:= MaxR(0, Tv[75] - Tv[78]);
    Tv[82]:= Tv[79] + Tv[80] + Tv[81];
    //61520 --------------------------------------------------------------------
    Tv[83]:= Ret[RetNo].Lnn[12000];
    Tv[84]:= Ret[RetNo].Lnn[12010];
    Tv[86]:= MaxR(0, Tv[83] - Tv[84]);
    Tv[85]:= MaxR(0, Tv[84] * 0.7835);
    Tv[87]:= MaxR(0, Tv[86] * 8.00);
    Tv[88]:= Tv[85] + Tv[87];

    //Page 4

    //58480 //jz//20251219 had to reorder/change all 58480 calc as it was just fundamentally all wrong

    //clear 58480 elms
    for i := 89 to 109 do Tv[i]:=  0;

    //58480 base amounts and rates //put here so values show even when there are no PolitContributions
    Tv[90]:=  0;
    Tv[97]:=  400;
    Tv[104]:= 750;
    Tv[94]:= 0;
    Tv[101]:= 300;
    Tv[108]:= 475;
    //58480 rates
    Tv[92]:=  75.00;
    Tv[99]:=  50.00;
    Tv[106]:= 33.33;

    lPolitContributionsVal:= Vl(FetchElm(RetNo, 'MB428', 120));
    if (lPolitContributionsVal > 0) then
    begin
      if (lPolitContributionsVal <= 400) then
      begin
        Tv[89]:= lPolitContributionsVal;
        Tv[91]:= MaxR(0, Tv[89] - Tv[90]);
        Tv[93]:= Tv[91] * Tv[92] / 100;
        Tv[95]:= Tv[93] + Tv[94];
      end
      else if ((lPolitContributionsVal > 400) and (lPolitContributionsVal <= 750)) then
      begin
        Tv[96]:= lPolitContributionsVal;
        Tv[98]:= MaxR(0, Tv[96] - Tv[97]);
        Tv[100]:= Tv[98] * Tv[99] / 100;
        Tv[102]:= Tv[100] + Tv[101];
      end
      else if (lPolitContributionsVal > 750) then
      begin
        Tv[103]:= lPolitContributionsVal;
        Tv[105]:= MaxR(0, Tv[103] - Tv[104]);
        Tv[107]:= Tv[105] * Tv[106] / 100;
        Tv[109]:= MinR(1000, Tv[107] + Tv[108]); //most can claim is $1000
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250918 Igor <<<

Procedure MB428A(RetNo:integer;FName:string;FNo:integer);
var i,j,k: integer;Mb428FNo:Integer; EligFlag:Boolean;
Begin
 EligFlag:=False;
 InitPrvConstants('MB');
 LoadTv(RetNo,FName,FNo);

 If  (CalcThisProvince(RetNo,'MB') = false)
 And (GetMjAlloc(RetNo,'MB')='')   //20180402
 then
 begin
  For i:=1 to 161 do begin ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 Mb428FNo:=GetFormNo('MB428');
 With ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
     Tv[28] := 2065;
     If vl(FetchElmFNo(RetNo,Mb428FNo,28)) > 0 then Tv[29] := 2065 else Tv[29]:=0;
     If Vl(FetchElmFNo(RetNo,Mb428FNo,29)) > 0 then Tv[30] := 2065 else Tv[30]:=0;
     If Age >= 65 then Tv[31] := 2065 else Tv[31] :=0;


     If (Vl(FetchElm(RetNo,'S2PRV',3))>0) //claimed age xfer  S@PRV NOT S2
     and (Vl(FetchElm(RetNo,'S2PRV',3)) > Vl(FetchElm(RetNo,'S2PRV',18)))
     then  Tv[32]:= 2065 else Tv[32] :=0;

     If (Vl(FetchElm(RetNo,'S2PRV',5))>0) //claimed disab xfer
     and (Vl(FetchElm(RetNo,'S2PRV',19)) > Vl(FetchElm(RetNo,'S2PRV',6)))
     then  Tv[43]:= 2752 else Tv[43] :=0;

     {Higher net income claims the disabled dependants: }
     {?MANTAX  in fact it needs the adjusted income}

     // number of claims on line 5848 (transfers) //<=18 and infirm?
     k:=0;
     If ((ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo))
        or (ret[RetNo].MarStatus>2)) then
     begin  //count transfers
      If Vl(FetchElmFNo(RetNo,Mb428FNo,37)) > 0 then //claime transfers on 5848
         k := StrToInt(FetchElm(RetNo,'DEPEND',2))+
              StrToInt(FetchElm(RetNo,'DEPEND',4));
     end;
     If Vl(FetchElmFNo(RetNo,Mb428FNo,36)) > 0 then k:=k+1; {disability for self}
     If UpperCase(Frm[FNo].Strings[1])<>'Y' then Frm[FNo].Strings[33] := IntTostr(k);
     Tv[34]:=Vl(Frm[FNo].Strings[33])* 2752;

     //REDUCTION FOR DISABLED DEPENDANDS claimed ON LINE 5820 //over 18
     If ((ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo))
        or (ret[RetNo].MarStatus>2))
     and (Vl(FetchElmFNo(RetNo,Mb428FNo,30)) > 0 )   //line 5820
     then
     begin
      k:=MyStrToInt(FetchElm(RetNo,'DEPEND',4)); //infirm over 18
      k:=k-GetInfirmEligDependantsOver18(Retno);
      EligFlag:=True;If k<0 then k:=0;
     end
     Else
      k:=0;
     If UpperCase(Frm[FNo].Strings[1])<>'Y' then Frm[FNo].Strings[35] := IntToStr(k);
     Tv[36]:=Vl(Frm[FNo].Strings[35])* 2752;


     k:=MyStrToInt(FetchElm(RetNo,'DEPEND',1)); {18 or less}
     If (Tv[30]>0) {and (EligFlag=True)} then k:= k-1;  {equiv to spouse} //20090201
     //If Tv[35]>0 then k:= k-1;  {claimed disab on 6074} //20090201
     If k<0 then k:=0;
     If ((ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo))
        or (ret[RetNo].MarStatus>2)) then
        begin
         If UpperCase(Frm[FNo].Strings[1])<>'Y' then Frm[FNo].Strings[37] := IntToStr(k);
        end
     else
        Frm[FNo].Strings[37] := '';
     Tv[38]:=Vl(Frm[FNo].Strings[37])* 2752;

     For i:=46 to 61 do Frm[FNo].Strings[i]:='';
     If vl(Frm[FNo].Strings[37]) >0 then  //dependants
     begin
       i := 46;j:=5;
       If ret[RetNo].FormHasData['DEPEND'] then
       repeat
         If (FetchElm(RetNo,'DEPEND',j+6) ='Child')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Son')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Daughter') then
         begin
           If CalcAge(FetchElm(RetNo,'DEPEND',j+5)) <=18 then
            begin
             Frm[FNo].Strings[i]   := FetchElm(RetNo,'DEPEND',j)+' '+
                             FetchElm(RetNo,'DEPEND',j+1); //first/last
             Frm[FNo].Strings[i+1]:= FetchElm(RetNo,'DEPEND',j+6); //relationship
             Frm[FNo].Strings[i+2] := FetchElm(RetNo,'DEPEND',j+5); //birthdate
             Frm[FNo].Strings[i+3] := FetchElm(RetNo,'DEPEND',j+2); //sin
             Inc(i,4)
            end;
           //inc(i,4);
         end;
       Inc(j,15);
       until (i>58) or (j>125);
     end
     else
      For i:=46 to 61 do Frm[FNo].Strings[i]:='';

     Tv[39]:=0;
     For i := 28 to 32 do Tv[39] := Tv[39] + Tv[i];
     Tv[39] := Tv[39] + Tv[43]+ Tv[34] + Tv[36] + Tv[38];
     Tv[2]:= Lnn[23600];
     If IsPreBankruptcyReturn(RetNo) then Tv[2]:=Vl(FetchElm(RetNo,'BANKRPT',15))+Vl(FetchElm(RetNo,'BaNKRPT',13));
     Tv[40] := Tv[2] * 9/100;
     Tv[42] := MaxR(0,(Tv[39] - Tv[40]))  * ret[RetNo].PartYear;
     If (ret[RetNo].Province <> 'MB')
     And (GetMjAlloc(RetNo,'MB')='')  //20180402
      then
     begin
      for i:=28 to 42 do Tv[i] :=0;
      Tv[43] :=0;
     end;
 end;
   SaveTv(RetNo,FName,FNo);
end;


Procedure MBMJA(RetNo:integer;FName:string;FNo:integer);
var i,j,k: integer;Mb428FNo:Integer; EligFlag:Boolean;
Begin
 EligFlag:=False;
 InitPrvConstants('MB');
 LoadTv(RetNo,FName,FNo);

 If  (CalcThisProvince(RetNo,'MB') = false)
 And (GetMjAlloc(RetNo,'MB')='')   //20180402
 then
 begin
  For i:=1 to 161 do begin ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 if IsMultJurisdiction(RetNo)=False then  //20190205
 Begin
  For i:=1 to 161 do begin ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 End;

 Mb428FNo:=GetFormNo('MB428');
 With ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
     Tv[28] := 2065;
     If vl(FetchElmFNo(RetNo,Mb428FNo,28)) > 0 then Tv[29] := 2065 else Tv[29]:=0;
     If Vl(FetchElmFNo(RetNo,Mb428FNo,29)) > 0 then Tv[30] := 2065 else Tv[30]:=0;
     If Age >= 65 then Tv[31] := 2065 else Tv[31] :=0;


     If (Vl(FetchElm(RetNo,'S2PRV',3))>0) //claimed age xfer  S@PRV NOT S2
     and (Vl(FetchElm(RetNo,'S2PRV',3)) > Vl(FetchElm(RetNo,'S2PRV',18)))
     then  Tv[32]:= 2065 else Tv[32] :=0;

     If (Vl(FetchElm(RetNo,'S2PRV',5))>0) //claimed disab xfer
     and (Vl(FetchElm(RetNo,'S2PRV',19)) > Vl(FetchElm(RetNo,'S2PRV',6)))
     then  Tv[43]:= 2752 else Tv[43] :=0;

     {Higher net income claims the disabled dependants: }
     {?MANTAX  in fact it needs the adjusted income}

     // number of claims on line 5848 (transfers) //<=18 and infirm?
     k:=0;
     If ((ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo))
        or (ret[RetNo].MarStatus>2)) then
     begin  //count transfers
      If Vl(FetchElmFNo(RetNo,Mb428FNo,37)) > 0 then //claime transfers on 5848
         k := StrToInt(FetchElm(RetNo,'DEPEND',2))+
              StrToInt(FetchElm(RetNo,'DEPEND',4));
     end;
     If Vl(FetchElmFNo(RetNo,Mb428FNo,36)) > 0 then k:=k+1; {disability for self}
     If UpperCase(Frm[FNo].Strings[1])<>'Y' then Frm[FNo].Strings[33] := IntTostr(k);
     Tv[34]:=Vl(Frm[FNo].Strings[33])* 2752;

     //REDUCTION FOR DISABLED DEPENDANDS claimed ON LINE 5820 //over 18
     If ((ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo))
        or (ret[RetNo].MarStatus>2))
     and (Vl(FetchElmFNo(RetNo,Mb428FNo,30)) > 0 )   //line 5820
     then
     begin
      k:=MyStrToInt(FetchElm(RetNo,'DEPEND',4)); //infirm over 18
      k:=k-GetInfirmEligDependantsOver18(Retno);
      EligFlag:=True;If k<0 then k:=0;
     end
     Else
      k:=0;
     If UpperCase(Frm[FNo].Strings[1])<>'Y' then Frm[FNo].Strings[35] := IntToStr(k);
     Tv[36]:=Vl(Frm[FNo].Strings[35])* 2752;


     k:=MyStrToInt(FetchElm(RetNo,'DEPEND',1)); {18 or less}
     If (Tv[30]>0) {and (EligFlag=True)} then k:= k-1;  {equiv to spouse} //20090201
     //If Tv[35]>0 then k:= k-1;  {claimed disab on 6074} //20090201
     If k<0 then k:=0;
     If ((ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo))
        or (ret[RetNo].MarStatus>2)) then
        begin
         If UpperCase(Frm[FNo].Strings[1])<>'Y' then Frm[FNo].Strings[37] := IntToStr(k);
        end
     else
        Frm[FNo].Strings[37] := '';
     Tv[38]:=Vl(Frm[FNo].Strings[37])* 2752;

     For i:=46 to 61 do Frm[FNo].Strings[i]:='';
     If vl(Frm[FNo].Strings[37]) >0 then  //dependants
     begin
       i := 46;j:=5;
       If ret[RetNo].FormHasData['DEPEND'] then
       repeat
         If (FetchElm(RetNo,'DEPEND',j+6) ='Child')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Son')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Daughter') then
         begin
           If CalcAge(FetchElm(RetNo,'DEPEND',j+5)) <=18 then
            begin
             Frm[FNo].Strings[i]   := FetchElm(RetNo,'DEPEND',j)+' '+
                             FetchElm(RetNo,'DEPEND',j+1); //first/last
             Frm[FNo].Strings[i+1]:= FetchElm(RetNo,'DEPEND',j+6); //relationship
             Frm[FNo].Strings[i+2] := FetchElm(RetNo,'DEPEND',j+5); //birthdate
             Frm[FNo].Strings[i+3] := FetchElm(RetNo,'DEPEND',j+2); //sin
             Inc(i,4)
            end;
           //inc(i,4);
         end;
       Inc(j,15);
       until (i>58) or (j>125);
     end
     else
      For i:=46 to 61 do Frm[FNo].Strings[i]:='';

     Tv[39]:=0;
     For i := 28 to 32 do Tv[39] := Tv[39] + Tv[i];
     Tv[39] := Tv[39] + Tv[43]+ Tv[34] + Tv[36] + Tv[38];
     Tv[2]:= Lnn[23600];
     If IsPreBankruptcyReturn(RetNo) then Tv[2]:=Vl(FetchElm(RetNo,'BANKRPT',15))+Vl(FetchElm(RetNo,'BaNKRPT',13));
     Tv[40] := Tv[2] * 9/100;
     Tv[42] := MaxR(0,(Tv[39] - Tv[40]))  * ret[RetNo].PartYear;
     If (ret[RetNo].Province <> 'MB')
     And (GetMjAlloc(RetNo,'MB')='')  //20180402
      then
     begin
      for i:=28 to 42 do Tv[i] :=0;
      Tv[43] :=0;
     end;
 end;
   SaveTv(RetNo,FName,FNo);
end;

// 20250916 Igor >>>
procedure MB479(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
  FamInc, x: Real;
  MaxAffordabilityCredit: Real;
  DaysB1, DaysB2: Integer;
begin
  //20260221
  if (RY = 0) then
    MaxAffordabilityCredit:= 1500 //350  //437.50  //20231117
  else
    MaxAffordabilityCredit:= 1500; //350; //437.50;

  InitPrvConstants('MB');
  LoadTv(RetNo, FName, FNo);
  if CalcThisProvince(RetNo, 'MB') = false then
  begin
    for i:= 1 to 163 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //For i:=50 to 51 do If Frm[FNo].Strings[i]='' then Frm[FNo].Strings[i]:='Y'; //20101021
    if (Frm[FNo].Strings[50] = '') then Frm[FNo].Strings[50]:= 'Y';
    if (Frm[FNo].Strings[51] = '') then Frm[FNo].Strings[51]:= 'Y';
    if (Frm[FNo].Strings[53] = '') then Frm[FNo].Strings[53]:= 'Y';
    //20101213
    if (ret[RetNo].Age < 19) then
    begin
      if ((ret[RetNo].MarStatus < 3) or (Vl(FetchElm(RetNo, 'DEPEND', 1)) > 0) or (Tv[36] > 0)) then //parent  or educ
      begin
        for i:= 50 to 51 do Frm[FNo].Strings[i]:= 'Y';

        Frm[FNo].Strings[53]:= 'Y';
      end else
      begin
        for i:= 50 to 51 do Frm[FNo].Strings[i]:= 'N';

        Frm[FNo].Strings[53]:= 'N';
      end;
    end;

    // Page 1
    // Column 1
    Tv[1]:= SelectNetIncomeAmount(RetNo); //20250222 //MaxR(0,Lnn[23600]);
    Tv[39]:= Vl(FetchElm(RetNo, 'INFO', 19));  //spnetincome

    //20230206
    if (TOSIInEffect(RetNo)) and (Ret[RetNo].Province = 'MB') then
    begin
      Tv[1]:= GetTosiNetIncome(RetNo); //20230206
      Tv[39]:= GetSpouseTosiNetIncome(RetNo, InfoFNo); //Vl(FetchElm(RetNo,'INFO',19));  //spnetincome
    end;

    Tv[2]:= Ret[RetNo].Lnn[21300] + Vl(FetchElm(RetNo, 'OTHDED', 60));
    Tv[155]:= Tv[1] + Tv[2];
    Tv[156]:= Ret[RetNo].Lnn[11700] + Ret[RetNo].Lnn[12500];
    Tv[3]:= MaxR(0, Tv[155] - Tv[156]);

    // Column 2
    Tv[40]:= Vl(FetchElm(RetNo, 'INFO', 162)) + Vl(FetchElm(RetNo, 'S2', 34));
    Tv[42]:= Vl(FetchElm(RetNo, 'INFO', 131)) + Vl(FetchElm(RetNo, 'S2', 33));
    Tv[41]:= Tv[39] + Tv[40];
    Tv[43]:= MaxR(0, Tv[41] - Tv[42]);

    if (UpperCase(Frm[FNo].Strings[32]) = 'Y') or (UpperCase(Frm[FNo].Strings[52]) = 'Y') then  //20211207
      for i:= 39 to 43 do Tv[i]:= 0;

    Tv[44]:= Tv[3] + Tv[43];
    FamInc:= Tv[44];  //20221213
    Tv[4]:= 195;

    if Age >= 65 then Tv[5]:= 113 else Tv[5]:= 0;
    if UpperCase(Frm[Fno].Strings[50]) <> 'Y' then
    begin
      Tv[4]:= 0;
      Tv[5]:= 0;
    end;

    if (MarStatus < 3) or ((MarStatus = 3) and (IsSpouseDeceased(RetNo))) then Tv[6]:= 195 else Tv[6]:= 0; {Ask questions}
    if ((MarStatus < 3) or ((MarStatus = 3) and (IsSpouseDeceased(RetNo)))) and (CalcAge(GetSpouseBirthDate(RetNo)) >= 65) then Tv[7]:= 113 else Tv[7]:= 0;
    if SpouseDisabled(RetNo) then Tv[8]:= 113 else Tv[8]:=0;

    Tv[9]:= Tv[6] + Tv[7] + Tv[8];
    Tv[10]:= Tv[9];

    if Vl(FetchElm(RetNo, 'MB428', 29)) > 0 then Tv[11]:= 195 else Tv[11]:= 0;

    Frm[FNo].Strings[12]:= FetchElm(RetNo, 'MB428A', 33);
    if UpperCase(Frm[Fno].Strings[50]) <> 'Y' then Frm[FNo].Strings[12]:= '';

    Tv[13]:= Vl(ret[RetNo].Frm[FNo].Strings[12]) * 113;
    Frm[FNo].Strings[14]:=FetchElm(RetNo,'MB428A',35);
    Tv[15]:= Vl(ret[RetNo].Frm[FNo].Strings[14]) * 62;

    if UpperCase(Frm[FNo].Strings[56])<>'Y' then
      Frm[FNo].Strings[16]:= FetchElm(RetNo, 'MB428A', 37);

    Tv[17]:= Vl(ret[RetNo].Frm[FNo].Strings[16]) * 26;

    if UpperCase(Frm[Fno].Strings[51]) <> 'Y' then
      for i:= 6 to 10 do Tv[i]:= 0;

    if UpperCase(Frm[Fno].Strings[53]) <> 'Y' then
    begin
      Tv[13]:= Vl(ret[RetNo].Frm[FNo].Strings[12]) * 113;
      Tv[15]:= 0;
      Tv[17]:= 0;
      Frm[Fno].Strings[14]:= '';
      Frm[Fno].Strings[16]:= '';
    end;

    Tv[20]:= Tv[4] + Tv[5] + Tv[10] + Tv[11] + Tv[13] + Tv[15] + Tv[17];
    Tv[55]:= Tv[44];

    if IsPreBankruptcyReturn(RetNo) then Tv[55]:= Vl(FetchElm(RetNo, 'BANKRPT', 15)) + Vl(FetchElm(RetNo, 'BANKRPT', 13)); //pre and post
    if UpperCase(Frm[Fno].Strings[50]) <> 'Y' then Tv[55]:= 0;

    Tv[21]:= Tv[55] * 0.01;
    Tv[22]:= MaxR(0, (Tv[20] - Tv[21]));

    if UpperCase(Frm[Fno].Strings[50]) <> 'Y' then Tv[22]:= 0;

    // Page 2 // Homeowners Affordability Tax Credit
    x:= Vl(Frm[Fno].Strings[104]) + Vl(Frm[Fno].Strings[112]) + Vl(Frm[Fno].Strings[120]) + Vl(Frm[Fno].Strings[128]);
    Frm[Fno].Strings[199]:= FloatToStr(x);
    Tv[200]:= Tv[105] + Tv[113] + Tv[121] + Tv[129];
    Tv[25]:= Tv[200];
 	  Tv[26]:= MinR(Tv[26],MaxAffordabilityCredit);  //20260221
 	  Tv[27]:= Tv[25] + Tv[26];
    Tv[66]:= 1500; //20250922 Igor

    Frm[FNo].Strings[196]:= Frm[FNo].Strings[199];
    Tv[197]:= Vl(Frm[FNo].Strings[196]) / 365;
    Tv[198]:= Tv[66] * Tv[197];
    Tv[37]:= MinR(Tv[27], Tv[198]);
    Tv[38]:= Tv[26];
    Tv[36]:= MaxR(0, Tv[37] - Tv[38]);

    //Page 3 // RENTERS TACX CREDIT
    Tv[201]:= Tv[99] + Tv[171] + Tv[176] + Tv[181] + Tv[186] + Tv[191];
    Frm[FNo].Strings[202]:=
      FloatToStr(Vl(Frm[FNo].Strings[100])
      + Vl(Frm[FNo].Strings[172]) + Vl(Frm[FNo].Strings[177])
      + Vl(Frm[FNo].Strings[182]) + Vl(Frm[FNo].Strings[187])
      + Vl(Frm[FNo].Strings[192]));
    Tv[23]:= Tv[36];
    Tv[81]:= Tv[201];

    Tv[82]:= 903.57; //jz//20251218 - add cents .57 //825; //20251206

    Tv[24]:= Tv[44];
    Tv[80]:= MinR(328.57, Tv[24] * 0.8214 / 100);  //20221216
    Tv[28]:= MaxR(0, Tv[82] - Tv[80]);

    if (Frm[FNo].Strings[91] = '') then Frm[FNo].Strings[91]:= '12';
    if (Vl(Frm[FNo].Strings[91]) > 0) then Tv[92]:= Tv[28] / vl(Frm[FNo].Strings[91]);

    if ((Ret[RetNo].MarStatus < 3) and (Age < 65) and (GetSpouseAge(RetNo) < 65)) or ((Ret[RetNo].MarStatus > 2) and (Age < 65)) then //20231125
    begin
      Tv[82]:= 0; //20231125
      Tv[24]:= 0; //20231125
      Tv[80]:= 0; //20231125
      Tv[28]:= 0; //20231125
      Frm[FNo].Strings[91]:= '';
      Tv[92]:= 0;
    end;

    Tv[94]:= MaxR(47.91, Tv[92]);
    Frm[FNo].Strings[95]:= Frm[FNo].Strings[202]; //20221214
    Tv[97]:= Tv[94] * Vl(Strings[95]);  //20260316
    Tv[90]:= MinR(Tv[81], Tv[97]);
    If Tv[90]>575 then Tv[90]:=575; //20251227

    Tv[195]:= Tv[23] + Tv[90]; //20221214

    // Page 4 //seniors school rebate
    Tv[18]:= Tv[195];
    Tv[169]:= 0;  //defaullt unless seniors
    Tv[35]:= Tv[27];

    if (Age >= 65) or (GetSpouseAge(RetNo) >= 65) then Frm[FNo].Strings[65]:= 'X' else Frm[FNo].Strings[65]:= '';   //20221217
    if (Tv[44] < 63500) then Frm[FNo].Strings[72]:= 'X' else Frm[FNo].Strings[72]:= '';   //20221217

    if (Frm[FNo].Strings[64] > '') and (Frm[FNo].Strings[65] > '') and (Frm[FNo].Strings[72] > '') then
    begin
      Tv[89]:= Tv[37];
      Tv[135]:= MinR(235, MaxR(0, Tv[35] - Tv[89]));
      Tv[161]:= FamInc;
      Tv[162]:= 40000;
      Tv[164]:= MaxR(0, Tv[161] - Tv[162]); //20221217
      Tv[165]:= 1; //20221217 //1.15;
      Tv[166]:= Tv[164] * Tv[165] / 100;
      Tv[167]:= Tv[166];
      Tv[69]:= MaxR(0, Tv[135] - Tv[167]);
      Tv[68]:= Tv[197];
      Tv[168]:= MaxR(0, Tv[69] * Tv[68]);
      Tv[169]:= Tv[168];
    end else
    begin
      Tv[35]:= 0;
      Tv[89]:= 0;
      Tv[135]:= 0;
      Tv[161]:= 0;
      Tv[162]:= 9;
      Tv[164]:= 0;
      Tv[165]:= 0;
      Tv[166]:= 0;
      Tv[167]:= 0;
      Tv[69]:= 0;
      Tv[68]:= 0;
      Tv[168]:= 0;
      Tv[169]:= 0;
    end;

    Tv[19]:= Tv[18] + Tv[169];
    Tv[31]:= Tv[22];
    Tv[170]:= Tv[19] + Tv[31];

    //jz//20260117 - simplify code
    Tv[34] := vl(FetchElm(RetNo, 'T5007#1', 4));

    if (Tv[34] = 0) then
      Tv[67]:= Tv[170]
    else
      Tv[67]:= Tv[170] * Tv[34];

    //jz//20260117 - remove as doenst makes sense and is incorrect
    {
    Frm[FNo].Strings[34]:= FetchElm(RetNo, 'T5007#1', 4); //20230318
    if (Frm[FNo].Strings[34] = '') then Tv[67]:= Tv[170]; //20230318

    //20220317
    if (FetchElm(RetNo, 'T5007#1', 4) = '0') or (FetchElm(RetNo, 'T5007#1', 4) = '0.00') then //20230301 Factor
    begin
      //Frm[FNo].Strings[34]:= '0.00';  //jz//20260117 - tv[34] is not vtstring
      //Tv[67]:= 0;                     //jz//20260117 - this is wrong
    end;
    //jz//20260117 - the no more than 1 is handled on form 5007
    else if (Vl(FetchElm(RetNo, 'T5007#1', 4)) > 0) then //20230301 Factor
    begin
      Frm[FNo].Strings[34]:= FetchElm(RetNo, 'T5007#1', 4); //factor
      if (Tv[34] > 1) then Tv[34]:= 1;
      //Tv[67]:= Tv[170] * Tv[34];
    end;
    }

    // Page 5
    Tv[30]:= Tv[67];
    Tv[60]:= Tv[30] + Tv[59];
    Tv[84]:= MinR(16000, Tv[83] * 0.40);

    if IsPreBankruptcyReturn(RetNo) then  //20230114
    begin
      DaysB1:= MyStrToInt(FetchElm(RetNo, 'BANKRPT', 2)); //DateDiff('01/01/'+AppYear,YYYYMMDDtoMMDDYYYY(FetchElm(RetNo,'BANKRPT',1)));
      DaysB2:= Constant[RY].FullYear; //DateDiff('01/01/'+AppYear,'12/31/'+Appyear);
      If (DaysB1 > 0) and (DaysB2 > 0) then Tv[84]:= Tv[84] * DaysB1 / DaysB2;
    end;
    //If Tv[84]>8000 then Tv[84]:=8000;  //2023014

    Tv[85]:= Tv[60] + Tv[84];
    Tv[153]:= Tv[85] + Tv[149];
    Tv[49]:= Tv[153] + Tv[154];
    Tv[47]:= Tv[45] + Tv[46];
    Tv[48]:= Tv[47];
    Tv[57]:= Tv[49] + Tv[48];
    Tv[58]:= TotMultiple(RetNo, 'T1299', 27);
    Tv[87]:= Tv[57] + Tv[58];

    if (Tv[88] > 1100000) then Tv[88]:= 1100000;
    Tv[157]:= Tv[87] + Tv[88];
    Tv[158]:= Vl(FetchElm(RetNo, 'T1256', 4));

    if (Tv[158] > 27000) then Tv[158]:= 27000;
    Tv[159]:= Tv[157] + Tv[158];
    Tv[160]:= Vl(FetchElm(RetNo, 'T12562', 3));

    if (Tv[160] > 27000) then Tv[160]:= 27000;
    Tv[63]:= Tv[159] + Tv[160];

    if (Tv[61] > 1000) then Tv[61]:= 1000;
    Tv[62]:= Tv[61] * 0.15;

    Tv[163]:= Tv[63] + Tv[62]+Tv[70]; //20251206
    Ret[RetNo].Lnn[47900]:= Tv[163];
  end;

  SaveTv(RetNo, FName, FNo);
end;
// 20250916 Igor <<<
//20250918 Igor >>>
procedure SK428(RetNo: Integer; FName: string; FNo: Integer);
Var i, j: Integer;
  DepFNo: Integer;
  KidClaim: Real;
  SeniorClaim: Real;
  NormalPrvNonRefAmount:Real;
begin
  InitPrvConstants('SK');
  LoadTv(RetNo, FName, FNo);

  if not CalcThisProvince(RetNo, 'SK') then // Or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 161 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= Ret[RetNo].Lnn[26000];

    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    {$region ' Top table '}
    Frm[FNo].Strings[11]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13]:= PrvConstant[RY].PrvRate3;
    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:= 0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      {ret[RetNo].Frm[FNo].Strings[11]:= OnConstant[RY].OnRate1;}
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;
    {$endregion ' Top table '}

    Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear;
    Tv[24]:= MinR(PrvConstant[RY].PrvMaxAgeAmount, Vl(FetchElm(RetNo, 'AGEDED', 17)));
    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
    Tv[26]:= SpouseIncome(RetNo);    //Tv[26]:= SpouseIncome(RetNo)* PartYear; //should be proarated
    //Tv[26] := GetSpouseTosiNetIncome(retNo,InfoFNo);   //20181227
    Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo)));//20240111
    //Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[25] - Tv[26]));
    Tv[28]:= Tv[27];

    if (UpperCase(Frm[FNo].Strings[64]) = 'Y') then
    begin
      Tv[27]:= Tv[65];
      Tv[28]:= Tv[65];
    end;

    //20210105
    if (Vl(FetchElm(RetNo, 'DEPEND', 3)) > 0) then  //elig dep
      Tv[100]:= PrvConstant[RY].PrvSpouseBasicAmount
    else
      Tv[100]:= 0;

    Tv[99]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
    Tv[98]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[100] - Tv[99]));
    Tv[40]:= Tv[98];

    if (UpperCase(Frm[FNo].Strings[87]) <> 'Y') then  //20140404
      Tv[40]:= Vl(FetchElm(RetNo, 'S5PRV', 10));

    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 87));
    //Tv[40]:=Tv[23]+Tv[24]+Tv[28]+Tv[29];

    {CLAIM KIDS lower TAXABLE income claims}
    if (MarStatus < 3) then //married
    begin
      if (GetPrvNetIncome(RetNo, 'SK') < SpouseIncome(RetNo)) then
        Frm[FNo].Strings[68]:= IntToStr(MyStrToInt(FetchElm(RetNo, 'DEPEND', 1)) - MyStrToInt(FetchElm(RetNo, 'DEPEND', 3)))
      else
        Frm[FNo].Strings[68]:= '';
    end else  //other mar status
      Frm[FNo].Strings[68]:= IntToStr(MyStrToInt(FetchElm(RetNo, 'DEPEND', 1)) - MyStrToInt(FetchElm(RetNo, 'DEPEND', 3)));

    Frm[FNo].Strings[68]:= AddLeadingZeros(Frm[FNo].Strings[68], 2); //20191211
    if (Vl(Frm[FNo].Strings[68]) < 0) then Frm[FNo].Strings[68]:= '';
    //20170922
    if (RY = 0) then kidClaim:= 7704 else kidClaim:= 7704; //this should be somewhere else or the very least a var on the form so we know it needs to be changed when redoing the form//jz 20250130 //20240111

    Tv[66]:= Vl(Frm[FNo].Strings[68]) * KidClaim * ret[RetNo].PartYear;  //added part year 20100429

    if (UpperCase(Frm[FNo].Strings[89]) = 'N') then
    begin
      Tv[66]:= 0;
      Frm[FNo].Strings[68]:= '';
    end;
    if (IsDeceased(RetNo)) then
    begin
      Tv[66]:= 0;
      Frm[FNo].Strings[68]:= '';
    end;
    if (RY = 0) then SeniorClaim:= 2028 else SeniorClaim:= 2028;

    Tv[67]:= 0;

    if (Age >= 65) then Tv[67]:= SeniorClaim;

    Tv[29]:= Tv[23] + Tv[24] + Tv[28] + Tv[40] + Tv[30] + Tv[66] + Tv[67];

    //Page 2
    Tv[92]:= Tv[29];
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[83]:= Ret[RetNo].Lnn[31217];

    //TV[48] ???  //20201225
    //Tv[49] ???
    //Tv[70] ???
    Tv[84]:= MinR(15000, Tv[84]);
    TV[97]:=Vl(FetchElm(RetNo,'S12SK',174)); //20260103
    Tv[73]:= Tv[31] + Tv[32] + Tv[33] + Tv[83] + Tv[48] + Tv[49] + Tv[70] + Tv[97] + Tv[84];
    Tv[90]:= Tv[73];
    Tv[91]:= Tv[92] + Tv[90];
    Tv[34]:= GetPrvPnsDed(RetNo);
    Tv[35]:= Vl(FetchElm(RetNo, 'S5PRV', 90));
    // If GetSinNo(RetNo)='870000601' then Tv[35]:=9789;  //20230508
    Tv[51]:= Tv[91] + Tv[34] + Tv[35]; //Tv[92]+Tv[34]+Tv[35]; //20211229

    if (Ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));

    Tv[37]:= GetPrvDisabXfer(RetNo);
    Tv[93]:= Tv[51] + Tv[36] + Tv[37];
    Tv[38]:= Ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[94]:= Tv[93] + Tv[38] + Tv[39] + Tv[41];
    //Tv[72]:=Tv[51];
    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    //20211115
    Tv[72]:= Ret[RetNo].Lnn[23600];
    Tv[88]:= 3;
    Tv[95]:= Tv[72] * Tv[88] / 100;
    Tv[96]:= MinR(Tv[95], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[96]);
    {Tv[69]:= PrvConstant[RY].PrvMedicalLimit;
    Tv[43]:= CalcPrvMedicalLimit(RetNo);
    Tv[44]:= MaxR(0,Tv[42]-Tv[43]);}
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= Tv[44] + Tv[45];
    Tv[47]:= Tv[46];
    Tv[71]:= Tv[94] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[71] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[53]:= GetS9DonLow(RetNo); //Lnn[32005];  //20161126 Lnn[32005];Lnn[32005];
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo);  //20161126  Lnn[347];Lnn[347];
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57] / 100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];

    //Page 3
    Tv[101]:= MaxR(Tv[20], MaxR(Tv[21], Tv[22]));
    Tv[142]:= MaxR(0, Tv[101] - Tv[141]);

    if SplitIncome(RetNo) then
      Tv[102]:= GetTOSIPrvTax(RetNo) // Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[102]:= 0;

    Tv[103]:= Tv[142] + Tv[102];
    // Tv[88]:=Tv[103];
    NormalPrvNonRefAmount:= Tv[61];
    if AllowSaSb(RetNo) then Tv[104]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20260503
        Else Tv[104]:=NormalPrvNonRefAmount; //20260514

    Tv[108]:= Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[6] * Tv[7]/100;
    Tv[112]:= Ret[RetNo].Lnn[40427];
    Tv[113]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[114]:= Tv[112] * Tv[113] / 100;
    Tv[115]:= Tv[104] + Tv[108] + Tv[114];
    Tv[116]:= Tv[115];
    Tv[117]:= MaxR(0, Tv[103] - Tv[116]);
    Tv[162]:= Vl(FetchElm(RetNo, 'T691', 316)); //AmountForPrvMinTax(RetNo);

    if IsDeceased(RetNo) then Tv[162]:= 0;

    Tv[163]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[105]:= Tv[162] * Tv[163] / 100;
    Tv[143]:= Tv[117] + Tv[105];
    Tv[118]:= GetPrvForTaxCredit(RetNo, 'SK');
    Tv[119]:= MaxR(0, Tv[143] - Tv[118]);

    Tv[120]:= GetPrvPolit(RetNo, 'SK');

    if (Tv[120] <= 400) then
      Tv[121]:= Tv[120] * 0.75
    else
    if (Tv[120] > 400) and (Tv[120] <= 750) then
      Tv[121]:= (Tv[120] - 400) * 0.50 + 300
    else
    if (Tv[120] > 750) then
      Tv[121]:= (Tv[120] - 750) * 0.3333 + 475;

    if Tv[121] > 1275 then Tv[121]:= 650;

    Tv[122]:= MaxR(0, Tv[119] - Tv[121]);
    Tv[123]:= MinR(875, Tv[123]);
    Tv[124]:= MinR(875, Tv[124]);
    Tv[127]:= MinR(875, Tv[123] + Tv[124]);
    Tv[126]:= Tv[127];
    Tv[125]:= MaxR(0, Tv[122] - Tv[126]);
    //Tv[106]:=TotMultiple(RetNo,'T101',22)+TotMultiple(RetNo,'T101',10)+TotMultiple(RetNo,'T5013',58); //20230117
    //Tv[74]:=Tv[106]*0.10; //20230117  //20231210
    Tv[74]:= Vl(FetchElm(RetNo, 'T1279', 7));
    Tv[75]:= Tv[74] + Tv[134];
    Tv[76]:= Tv[75];
    Tv[86]:= MaxR(0, Tv[125] - Tv[76]);
    Tv[85]:= Vl(FetchElm(RetNo, 'RC360', 20));
    Tv[137]:= MaxR(0, Tv[86] - Tv[85]);

    for i:= 146 to 161 do Frm[FNo].Strings[i]:= '';

    if GetPrvNetIncome(RetNo,'SK')< SpouseIncome(RetNo) then
    begin
      i:= 146;
      j:= 5; {j:index to depend}
      DepFNo:= GetFormNo('DEPEND');
      repeat
        if (FetchElmFNo(RetNo,DepFNo,j) > '') and (CalcAge(FetchElmFNo(RetNo, DepFNo, j + 5)) <= 18) and (
           (FetchElmFNo(RetNo, DepFNo, j + 6) = 'Child') or (FetchElmFNo(RetNo, DepFNo, j + 6) ='Daughter') or (FetchElmFNo(RetNo, DepFNo, j + 6) = 'Son') ) then
        begin
          Frm[FNo].Strings[i]:= FetchElmFNo(RetNo, DepFNo, j) + ' ' + FetchElmFNo(RetNo, DepFNo, j + 1); {Nm}
          Frm[FNo].Strings[i + 1]:= FetchElmFNo(RetNo, DepFNo,j + 6); {Relat}
          Frm[FNo].Strings[i + 2]:= FetchElmFNo(RetNo, DepFNo,j + 5); {birth}
          Frm[FNo].Strings[i + 3]:= FetchElmFNo(RetNo, DepFNo,j + 2); {Nm}

          Inc(i, 4);
        end;

        Inc(j, 15);
      until (j > 125) or (i > 158);
    end;

    Tv[77]:= Tv[76];
    Tv[78]:= Tv[166];

    if (Tv[77] = 0) then Tv[78]:= 0;

    Tv[79]:= MaxR(0, Tv[77] - Tv[78]);

    if (Tv[79] = 0) then
    begin
      Tv[80]:= 0;
      Tv[81]:= 0;
      Tv[82]:= 0;
    end;

    Lnn[42800]:= Tv[137];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250918 Igor <<<

// 20250916 Igor >>>
procedure SK479(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j, j1: Integer;
  DepFNo: Integer;
  KidClaim: Real;
  SeniorClaim: Real;
begin
  InitPrvConstants('SK');
  LoadTv(RetNo, FName, FNo);

  if CalcThisProvince(RetNo,'SK') = false  then
  begin
    for i:= 1 to 82 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    Exit;
  end;

  with ret[RetNo].Frm[FNo], Ret[RetNo].Frm[FNo] do
  begin
    Tv[1]:= SelectNetIncomeAmount(RetNo); //20250222 //MaxR(0,ret[RetNo].Lnn[23600]);
    Tv[2]:= Ret[RetNo].Lnn[21300] + Vl(FetchElm(RetNo, 'OTHDED', 60));
    If (UpperCase(Strings[32]) = 'Y') then Strings[52]:= '';

    Tv[155]:= Tv[1] + Tv[2];
    Tv[156]:= Ret[RetNo].Lnn[11700] + Ret[RetNo].Lnn[12500];
    Tv[3]:= MaxR(0, Tv[155] - Tv[156]);
    Tv[73]:= MaxR(0, Tv[71] - Tv[72]);

    Tv[74]:= Tv[3] + Tv[73];

    i:= 27;
    J1:= 75;
    j:= 4;
    Tv[59]:= 0;

    repeat
      if Strings[i] > '' then
      begin
        Tv[i + 3]:= MinR(MaxR(0, Tv[i + 2] - Tv[j]), 300);
        if (UpperCase(Strings[j1]) = 'Y') then Tv[i + 3]:= MinR(MaxR(0, Tv[i + 2] - Tv[j]), 400);
      end else
        Tv[i + 3]:= 0;

      Tv[59]:= Tv[59] + Tv[i + 3];
      Inc(i, 4);
      Inc(j1, 1);
      Inc(j, 1);
    until i > 55;

    if Tv[74] > 120000 then
      Tv[15]:= 0
    else
      Tv[15]:= Tv[59];

    Tv[13]:= Tv[12] * 0.5;
    if (Tv[13] > 10000) then Tv[13]:= 10000;
    Tv[14]:= Tv[15] + Tv[13];
    Ret[RetNo].Lnn[47900]:= Tv[14];
  end;

  SaveTv(RetNo, FName, FNo);
end;
// 20250916 Igor <<<

// 20250918 Igor >>>
procedure YT428(RetNo: Integer; FName: string; FNo: Integer);
var
  i, count: Integer;
  x, y, z: Real;
  NormalPrvNonRefAmount:Real;
begin
  InitPrvConstants('YT');
  LoadTv(RetNo, FName, FNo);

  if not CalcThisProvince(RetNo, 'YT') then //Or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 141 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= Ret[RetNo].Lnn[26000];

    {$region ' Top table '}
    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 66 to 72 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    for i:= 83 to 89 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    Frm[FNo].Strings[11]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13]:= PrvConstant[RY].PrvRate3;
    Frm[FNo].Strings[70]:= PrvConstant[RY].PrvRate4;
    Frm[FNo].Strings[86]:= PrvConstant[RY].PrvRate5;

    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[68]:= PrvConstant[RY].PrvBracket3;
    Tv[84]:= PrvConstant[RY].PrvBracket4;

    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;
    Tv[72]:= PrvConstant[RY].PrvBracketTax4;
    Tv[88]:= PrvConstant[RY].PrvBracketTax5;

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:=0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket3) and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
    begin
      Tv[66]:= Tv[1];
      Tv[68]:= PrvConstant[RY].PrvBracket3;
      Tv[69]:= MaxR(0, Tv[66] - Tv[68]);
      Tv[71]:= Tv[69] * Vl(Frm[FNo].Strings[70]) / 100;
      Tv[72]:= PrvConstant[RY].PrvBracketTax4;
      Tv[67]:= Tv[71] + Tv[72];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket4) then
    begin
      Tv[83]:= Tv[1];
      Tv[84]:= PrvConstant[RY].PrvBracket4;
      Tv[85]:= MaxR(0, Tv[83] - Tv[84]);
      Tv[87]:= Tv[85] * Vl(Frm[FNo].Strings[86]) / 100;
      Tv[88]:= PrvConstant[RY].PrvBracketTax5;
      Tv[89]:= Tv[87] + Tv[88];
    end;
    {$endregion ' Top table '}

    Tv[23]:= Ret[retNo].Lnn[30000]; //PrvConstant[RY].PrvPersAmount * PartYear; //20201231
    Tv[24]:= MinR(9028, Ret[RetNo].Lnn[30100]); //jz//20260329//MJCERT2025v3 - should this be done in AGEDED??
    Tv[28]:= Ret[RetNo].Lnn[30300];
    Tv[29]:= Ret[RetNo].Lnn[30400]; //20191215 //ret[RetNo].Lnn[30425]; //Vl(FetchElm(RetNo,'S5PRV',10));
    Tv[30]:= Ret[RetNo].Lnn[30425]; // 20171126 //ret[RetNo].Lnn[306]; //Vl(FetchElm(RetNo,'S5PRV',87));
    Tv[35]:= Ret[RetNo].Lnn[30450]; // 20171126 //ret[RetNo].Lnn[315];
    Tv[25]:= Ret[RetNo].Lnn[30500];  //20191215  //Tv[25] := ret[RetNo].Lnn[30400];
    Tv[48]:= Tv[23] + Tv[24] + Tv[28] + Tv[29] + Tv[30] + Tv[35] + Tv[25];
    Tv[31]:= ret[RetNo].Lnn[30800];
    Tv[32]:= ret[RetNo].Lnn[31000];
    Tv[33]:= ret[RetNo].Lnn[31200];
    Tv[64]:= ret[RetNo].Lnn[31217];
    Tv[73]:= ret[RetNo].Lnn[31260];
    Tv[65]:= Vl(FetchElm(RetNo, 'YTARTS', 3)); //20161212//ret[RetNo].Lnn[370];
    Tv[51]:= TotMultiple(RetNo, 'ADOPT', 68); //ret[RetNo].Lnn[31300];
    Tv[62]:= AddColumns(31, 33, 1) + Tv[64] + Tv[73] + Tv[65] + Tv[51];
    Tv[63]:= Tv[62];
    Tv[34]:= GetPrvPnsDed(RetNo);//ret[RetNo].Lnn[31400]; //Vl(FetchElm(RetNo,'PNSDED',18));//ret[RetNo].Lnn[31400];
    Tv[36]:= Ret[RetNo].Lnn[31600];
    Tv[37]:= GetPrvDisabXfer(RetNo); //ret[RetNo].Lnn[31800]; //GetPrvDisabXfer(RetNo);//YT was equal to fed  //20181225
    Tv[74]:= Tv[48] + Tv[63] + Tv[34] + Tv[36] + Tv[37];  //20210101

    //Page 2
    Tv[38]:= Ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[40]:= GetPrvEducXfer(RetNo);
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[27]:= Tv[74];
    Tv[26]:= Tv[27] + AddColumns(38, 41, 1);
    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    //20211115
    Tv[77]:= Ret[RetNo].Lnn[23600];
    Tv[78]:= 3;
    Tv[79]:= Tv[77] * Tv[78] / 100;
    Tv[81]:= MinR(Tv[79], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[81]);
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= Tv[44] + Tv[45];
    Tv[47]:= Tv[46];
    Tv[49]:= Tv[26] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;  //20170126
    Tv[53]:= GetS9DonLow(RetNo); //Lnn[32005];  //20161126 Lnn[32005];Lnn[32005];
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo);  //20161126  Lnn[347];Lnn[347];
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57] / 100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];
    Tv[134]:= MaxR(Tv[89], MaxR(MaxR(Tv[20], Tv[21]), MaxR(Tv[22], Tv[67])));

    if SplitIncome(RetNo) then
      Tv[133]:= GetTOSIPrvTax(RetNo) // Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[133]:= 0;

    Tv[132]:= Tv[134] + Tv[133];
    NormalPrvNonRefAmount:= Tv[61]; //Vl(FetchElm(RetNo,'YT428',61));
    if AllowSaSb(RetNo) then Tv[131]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20150412
        Else Tv[131]:=NormalPrvNonRefAmount; //20260514

    Tv[112]:= PrvConstant[RY].PrvAMTCarryOverRate;
    //Tv[30]:= Ret[RetNo].Lnn[12000];
    Tv[127]:= Ret[RetNo].Lnn[40427];
    Tv[108]:= Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[30] * Tv[6]/100;
    Tv[125]:= Tv[131] + Tv[108] + Tv[126];  //20161217
    Tv[111]:= Tv[125];
    Tv[110]:= MaxR(0, Tv[132] - Tv[111]);
    Tv[102]:= Vl(FetchElm(RetNo, 'T691', 316)); //20250222  //AmountForPrvMinTax(RetNo); //Vl(FetchElm(RetNo,'T691',316));

    if IsDeceased(RetNo) then Tv[102]:= 0;

    Tv[101]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[107]:= Tv[102] * Tv[101] / 100;
    Tv[105]:= Tv[110] + Tv[107];

    //Page 3
    Tv[82]:= Tv[105]; //20221203

    if not Ret[RetNo].Province.Equals('YT') then
      Tv[104] := 0
    else
      Tv[104]:= GetPrvForTaxCredit(RetNo, 'YT');

    Tv[103]:= MaxR(0, Tv[105] - Tv[104]);
    //bus investm credit
    Tv[93]:= Tv[90] + Tv[92];
    Tv[94]:= Tv[103];
    Tv[95]:= MinR(Tv[93], Tv[94]);

    if (Tv[95] > 25000) then Tv[95]:= 25000;

    //unused
    Tv[96]:= Tv[93];
    Tv[97]:= Tv[95];
    Tv[98]:= MaxR(0, Tv[96] - Tv[97]);
    Tv[91]:= Tv[103] - Tv[95];
    Tv[109]:= Vl(FetchElm(RetNo, 'YT432', 10)); //20221203
    Tv[113]:= MaxR(0, Tv[91] - Tv[109]);
    Tv[76]:= GetPrvPolit(RetNo, 'YT');

    if (Tv[76] <= 400) then
      x:= Tv[76] * 0.75
    else
    if ((Tv[76] > 400) and (Tv[76] <= 750)) then
      x:= (Tv[76] - 400) * 0.50 + 300
    else
    if (Tv[76] > 750) then
      x:= (Tv[76] - 750) * 0.3333 + 475;

    if (x > 650) then x:= 650;  //20221203

    Tv[75]:= MinR(650, x);
    Tv[123]:= MaxR(0, Tv[113] - Tv[75]);
    Lnn[42800]:= Tv[123];
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure YT479(RetNo: Integer; FName: string; FNo: Integer);
var
  x, y, z: Real;
  i: Integer;
Begin
  LoadTv(RetNo, FName, FNo);

  if not CalcThisProvince(RetNo, 'YT') then
  begin
    for i:= 1 to 33 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    {polit}
    if (ret[RetNo].Province = 'YT') or (IsMultJurisdiction(RetNo)) then //220240506
    begin
      Tv[13]:= VL(FetchElm(RetNo,'FITNESS',77)); //ret[RetNo].Lnn[458]; //20171205
      Tv[29]:= Tv[13] * 6.4 / 100;
      Tv[20]:= Vl(FetchElm(RetNo,'T1232', 16));  //20120131
      //Tv[2]:= Vl(FetchElm(RetNo,'S14YT', 275));  //20240126  //20251227CZ
      //Tv[34]:= Vl(FetchElm(RetNo,'S14YT', 548)); //20240126  //20251227CZ

      //20251227CZ
      if UpperCase(Frm[FNo].Strings[38])<>'X' Then Strings[38]:='';
      if UpperCase(Frm[FNo].Strings[39])<>'X' Then Strings[39]:='';
      {
      if UpperCase(Frm[FNo].Strings[38]).Equals('') then Frm[FNo].Strings[38]:= 'N';
      if UpperCase(Frm[FNo].Strings[39]).Equals('') then Frm[FNo].Strings[39]:= 'Y';
      if UpperCase(Frm[FNo].Strings[38]).Equals('Y') then
      }

      //jz//20251216 - what is this nonsense??
      {
      if UpperCase(Frm[FNo].Strings[38]).Equals('') then Frm[FNo].Strings[38]:= 'N';
      if UpperCase(Frm[FNo].Strings[39]).Equals('') then Frm[FNo].Strings[39]:= 'Y';
      if UpperCase(Frm[FNo].Strings[38]).Equals('Y') then
      }

      if UpperCase(Frm[FNo].Strings[38]).Equals('X') then  //jz//20251216
        Tv[3]:= MinR(10000, Tv[1] * 0.4)
      else
      begin
        Tv[1]:= 0;
        Tv[3]:= 0;
      end;

      Tv[33]:= Tv[29] + Tv[20] + Tv[34] + Tv[2] + Tv[3]; //20240127
      Lnn[47900]:= Tv[33];
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure AB428(RetNo:integer;FName:string;FNo:integer);
var
  i, DonFNo: Integer;
  x, y, z: Real;
  NormalPrvNonRefAmount:real;
begin
  InitPrvConstants('AB');
  LoadTv(RetNo,FName,FNo);

  if not CalcThisProvince(RetNo, 'AB') then //Or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 165 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[5]:= Ret[RetNo].Lnn[26000];

    if (UpperCase(Frm[FNo].Strings[11]) = 'Y') then Tv[5]:= Tv[12];

    {$region ' Top tables '}
    for i:= 71 to 77 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 131 to 165 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    Frm[FNo].Strings[146]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[147]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[148]:= PrvConstant[RY].PrvRate3;
    Frm[FNo].Strings[74]:= PrvConstant[RY].PrvRate4;
    Frm[FNo].Strings[149]:= PrvConstant[RY].PrvRate5;
    Frm[FNo].Strings[150]:= PrvConstant[RY].PrvRate6;

    Tv[136]:= 0;
    Tv[137]:= PrvConstant[RY].PrvBracket1;
    Tv[138]:= PrvConstant[RY].PrvBracket2;
    Tv[76]:= PrvConstant[RY].PrvBracket3;
    Tv[139]:= PrvConstant[RY].PrvBracket4;
    Tv[140]:= PrvConstant[RY].PrvBracket5;
    Tv[156]:= 0;
    Tv[157]:= PrvConstant[RY].PrvBracketTax2;
    Tv[158]:= PrvConstant[RY].PrvBracketTax3;
    Tv[72]:= PrvConstant[RY].PrvBracketTax4;
    Tv[159]:= PrvConstant[RY].PrvBracketTax5;
    Tv[160]:= PrvConstant[RY].PrvBracketTax6;

    if (Tv[5] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[131]:= Tv[5];
      Tv[136]:= 0;
      Tv[141]:= MaxR(0, Tv[131] - Tv[136]);
      Tv[151]:= Tv[141] * Vl(Frm[FNo].Strings[146]) / 100;
      Tv[156]:= 0;
      Tv[161]:= Tv[151] + Tv[156];
    end;

    if (Tv[5] > PrvConstant[RY].PrvBracket1) and (Tv[5] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[132] := Tv[5];
      Tv[137] := PrvConstant[RY].PrvBracket1;
      Tv[142] := MaxR(0, Tv[132] - Tv[137]);
      Tv[152] := Tv[142] * Vl(Frm[FNo].Strings[147]) / 100;
      Tv[157] := PrvConstant[RY].PrvBracketTax2;
      Tv[162] := Tv[152] + Tv[157];
    end;

    if (Tv[5] > PrvConstant[RY].PrvBracket2) and (Tv[5] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[133]:= Tv[5];
      Tv[138]:= PrvConstant[RY].PrvBracket2;
      Tv[143]:= MaxR(0, Tv[133] - Tv[138]);
      Tv[153]:= Tv[143] * Vl(Frm[FNo].Strings[148]) / 100;
      Tv[158]:= PrvConstant[RY].PrvBracketTax3;
      Tv[163]:= Tv[153] + Tv[158];
    end;

    if (Tv[5] > PrvConstant[RY].PrvBracket3) and (Tv[5] <= PrvConstant[RY].PrvBracket4) then
    begin
      Tv[77]:= Tv[5];
      Tv[76]:= PrvConstant[RY].PrvBracket3;
      Tv[75]:= MaxR(0, Tv[77] - Tv[76]);
      Tv[73]:= Tv[75] * Vl(Frm[FNo].Strings[74]) / 100;
      Tv[72]:= PrvConstant[RY].PrvBracketTax4;
      Tv[71]:= Tv[73] + Tv[72];
    end;

    if (Tv[5] > PrvConstant[RY].PrvBracket4) and (Tv[5] <= PrvConstant[RY].PrvBracket5) then  //jz//20260112 - PrvBracket5, not 4
    begin
      Tv[134]:= Tv[5];
      Tv[139]:= PrvConstant[RY].PrvBracket4;
      Tv[144]:= MaxR(0, Tv[134] - Tv[139]);
      Tv[154]:= Tv[144] * Vl(Frm[FNo].Strings[149]) / 100;
      Tv[159]:= PrvConstant[RY].PrvBracketTax5;
      Tv[164]:= Tv[154] + Tv[159];
    end;

    if (Tv[5] > PrvConstant[RY].PrvBracket5) then
    begin
      Tv[135]:= Tv[5];
      Tv[140]:= PrvConstant[RY].PrvBracket5;
      Tv[145]:= MaxR(0, Tv[135] - Tv[140]);
      Tv[155]:= Tv[145] * Vl(Frm[FNo].Strings[150]) / 100;
      Tv[160]:= PrvConstant[RY].PrvBracketTax6;
      Tv[165]:= Tv[155] + Tv[160];
    end;
    {$endregion ' Top tables '}

    // DonFNo:=GetFormNo('DON');  //20170225
    Tv[23]:= PrvConstant[RY].PrvPersAmount * PartYear;
    Tv[24]:= Vl(FetchElm(RetNo, 'AGEDED', 17));

    if UpperCase(Frm[FNo].Strings[62]).Equals('Y') then Tv[24]:= Tv[63]; //20200326

    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
    Tv[26]:= SpouseIncome(RetNo);

    //jz//20251225//was missing TosiInEffect qualifier BUT - SpouseIncome function already gets spouseTosiNetIncome so why have it extra??
    if TosiInEffect(RetNo) then Tv[26]:= GetSpouseTosiNetIncome(RetNo, InfoFNo);

    //20250511  temp cancelled
    //Tv[27]:= MaxR(0, Tv[25] - Tv[26]);
    //if (Tv[27] > PrvConstant[RY].PrvMaxSpousalAmount) then Tv[27]:= PrvConstant[RY].PrvMaxSpousalAmount;
    //Tv[27]:= MaxR(0, Tv[25] - Tv[26]); //20250922 Igor //
    Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo)));
    Tv[28]:= Tv[27];

    if UpperCase(Frm[FNo].Strings[64]).Equals('Y') then
    begin
      Tv[27]:= Tv[65];
      Tv[28]:= Tv[65];
    end; //20200326

    Tv[1]:= PrvConstant[RY].PrvSpouseBasicAmount;
    Tv[2]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
    Tv[3]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, Vl(FetchElm(RetNo, 'S5PRV', 10)));
    Tv[1]:= PrvConstant[RY].PrvSpouseBasicAmount;
    Tv[2]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
    Tv[3]:= MaxR(0, Tv[1] - Tv[2]);
    Tv[29]:= Vl(FetchElm(RetNo, 'S5PRV', 10));
    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 87));
    Tv[7]:= Tv[23] + Tv[24] + Tv[28] + Tv[29] + Tv[30];

    //Page 2
    Tv[18]:= Tv[7];
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[4]:= Ret[RetNo].Lnn[31217];
    Tv[51]:= TotMultiple(RetNo, 'ADOPT', 68); //ret[RetNo].Lnn[31300];
    Tv[20]:= Tv[31] + Tv[32] + Tv[33] + Tv[4] + Tv[51];
    Tv[57]:= Tv[20];
    Tv[21]:= Tv[18] + Tv[57];
    Tv[34]:= GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));
    Tv[35]:= Vl(FetchElm(RetNo, 'S5PRV', 90));

    if UpperCase(frm[FNo].Strings[14]).Equals('Y') then
       Tv[35]:= Tv[70]; //20230219

    Tv[22]:= Tv[21] + Tv[34] + Tv[35];   //jz//20251217 - from Tv[18] to Tv[21]

    if (Ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));

    Tv[37]:= GetPrvDisabXfer(RetNo);
    Tv[58]:= Tv[22] + Tv[36] + Tv[37];
    Tv[38]:= Ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[40]:= GetPrvEducXfer(RetNo);          //???
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[53]:= Tv[58] + Tv[38] + Tv[39] + Tv[41];
    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    Tv[6]:= Ret[RetNo].Lnn[23600];
    Tv[13]:= 3;
    Tv[17]:= Tv[6] * Tv[13] / 100;
    Tv[40]:= MinR(Tv[17], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[40]);
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= Tv[44] + Tv[45];
    Tv[47]:= Tv[46];  //20250318 //20250223
    Tv[49]:= Tv[53] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    //Tv[23]+Tv[24]+AddColumns(28,33,1)+Tv[4]+Tv[51]+AddColumns(34,41,1)+Tv[47]+Vl(FetchElm(RetNo,'RC269',10));
    //Tv[49]:=Tv[48];
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[10]:=GetS9DonLow(RetNo); //Lnn[32005];  //20161126 Lnn[32005];Lnn[32005];
    // Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[60]:= Tv[10] * PrvConstant[RY].PrvDonRate1 / 100; //Tv[10] * 10/100;  //20231207
    Tv[67]:= GetS9DonHigh(RetNo);  //20161126  Lnn[347];Lnn[347];
    Tv[68]:= Tv[67] * PrvConstant[RY].PrvDonRate2 / 100;   //20231207
    Tv[59]:= Tv[60] + Tv[68];
    Tv[69]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[69];

    //Page 3
    Tv[19]:= MaxR(Tv[161], Tv[162]);
    Tv[19]:= MaxR(Tv[19], Tv[163]);
    Tv[19]:= MaxR(Tv[19], Tv[71]);
    Tv[19]:= MaxR(Tv[19], Tv[164]);
    Tv[19]:= MaxR(Tv[19], Tv[165]);

    if SplitIncome(RetNo) then
      Tv[8]:= GetTOSIPrvTax(RetNo) //Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[8]:= 0;

    Tv[9]:= Tv[19] + Tv[8];
    NormalPrvNonRefAmount:= Tv[61];
    if AllowSaSb(RetNo) then
      Tv[101]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20260503
    else
      Tv[101]:=NormalPrvNonRefAmount; // 20260514

    Tv[103]:= Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[2] * Tv[18]/100;
    Tv[106]:= Lnn[40427];
    Tv[120]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[107]:= Tv[106] * Tv[120] / 100;
    Tv[54]:= Tv[101] + Tv[103] + Tv[107];
    Tv[55]:= Tv[54];
    Tv[110]:= MaxR(0, Tv[9] - Tv[55]);
    //Tv[108]:= Tv[101]+Tv[103]+Tv[105]+Tv[107];
    //Tv[109]:= Tv[108];
    Tv[123]:= Vl(FetchElm(RetNo, 'T691', 316));//20240222 //AmountForPrvMinTax(RetNo);
    Tv[124]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[121]:= Tv[123] * Tv[124] / 100;
    Tv[122]:= Tv[110] + Tv[121];
    Tv[111]:= GetPrvForTaxCredit(RetNo, 'AB');
    Tv[112]:= MaxR(0, Tv[122] - Tv[111]);

    if Ret[RetNo].Province.Equals('AB') then
    begin
      Tv[113]:= GetPrvPolit(RetNo,'AB');

      if (Tv[113] <= 200) then
        Tv[114]:= Tv[113] * 0.75
      else
      if (Tv[113] > 200) and (Tv[113] <= 1100) then
        Tv[114]:= (Tv[113] - 200) * 0.50 + 150
      else
      if (Tv[113] > 1100) and (Tv[113] <= 2300) then
        Tv[114]:= (Tv[113] - 1100) * 0.3333 + 600;

      if (Tv[113] > 2300) then Tv[114]:= 1000;
    end;

    Tv[79]:= MaxR(0, Tv[112] - Tv[114]);
    //by alex
    //Calculation and const values took from the AB428WS of 2025 year
    //Line 1 = Amount from line 58800 of your Form AB428
    //Line 2 = Amount from line 58560 of your Form AB428
   // l61545Line3:= MaxR(0, Tv[49] - Tv[52]); // Line 1 minus line 2
   // l61545Line5:= l61545Line3 * 0.08; // Line 3 multiplied by the percentage from line 4 (8%)
    //Line 6 = 4800.00
   // l61545Line7:= MaxR(0, l61545Line5 - 4800.00); // Line 5 minus line 6 (if negative, enter "0")
    //Line 8 = 25%
   // Tv[78]:= l61545Line7 * 0.25; //Line 7 multiplied by the percentage from line 8
    Tv[78]:=Vl(FetchElm(RetNo,'LN61545',9));
    Tv[117]:= MaxR(0, Tv[79] - Tv[78]);

    if Ret[RetNo].Province.Equals('AB') then
      Lnn[42800]:= Tv[117];

    {//20241125
    if Tv[16]>60000 then Tv[16]:=60000; //20220501
    Tv[56]:=Vl(FetchElm(RetNo,'DIRECT',5)); //20220501
    // Tv[14]:=Tv[16]+Tv[56];  //20220501 //20211120
    //???? Tv[14]:=MinR(60000,Tv[6]+Tv[16]);  //20181112
    Tv[15]:=Tv[16]+Tv[56];
    //20171126
    If Ret[RetNo].Province='AB' then
      Ret[RetNo].Lnn[47900]:=Vl(FetchElm(RetNo,'AB428',15)); //+Vl(FetchElm(RetNo,'DIRECT',5));}
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure LN61545(RetNo:integer;FName:string;FNo:integer); //20251130 CZ
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);

  if not CalcThisProvince(RetNo, 'AB') then //Or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 9 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;
    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
   Tv[1]:=Vl(FetchElm(RetNo,'AB428',49));   //5800
   Tv[2]:=Vl(FetchElm(RetNo,'AB428',39));   //58560
   Tv[3]:=MaxR(0,Tv[1]-Tv[2]);
   Tv[4]:=8;
   Tv[5]:=Tv[3]*Tv[4]/100;
   Tv[6]:=4800;
   Tv[7]:=MaxR(0,Tv[5]-Tv[6]);
   Tv[8]:=25;
   Tv[9]:=Tv[7]*Tv[8]/100;
  end;

  SaveTv(RetNo, FName, FNo);
end;


procedure NS428(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
  MaxVolCredit: Real;
  NormalPrvNonRefAmount:Real;
begin
  InitPrvConstants('NS');
  LoadTv(RetNo,FName,FNo);

  if not CalcThisProvince(RetNo, 'NS') then //or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 172 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= ret[RetNo].Lnn[26000];

    {$region ' Top table '}
    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 66 to 72 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;
    for i:= 166 to 172 do
    begin
      Tv[i]:= 0;
      Frm[FNo].Strings[i]:= '';
    end;

    Frm[FNo].Strings[11]:= PrvConstant[RY].PrvRate1;
    Frm[FNo].Strings[12]:= PrvConstant[RY].PrvRate2;
    Frm[FNo].Strings[13]:= PrvConstant[RY].PrvRate3;
    Frm[FNo].Strings[70]:= PrvConstant[RY].PrvRate4;
    Frm[FNo].Strings[169]:= PrvConstant[RY].PrvRate5;

    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;
    Tv[68]:= PrvConstant[RY].PrvBracket3;
    Tv[167]:= PrvConstant[RY].PrvBracket4;
    Tv[72]:= PrvConstant[RY].PrvBracketTax4;
    Tv[171]:= PrvConstant[RY].PrvBracketTax5;

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:= 0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      Tv[14]:= Tv[8] * Vl(Frm[FNo].Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Frm[FNo].Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) and  (Tv[1] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Frm[FNo].Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket3) and  (Tv[1] <= PrvConstant[RY].PrvBracket4) then
    begin
      Tv[66]:= Tv[1];
      Tv[68]:= PrvConstant[RY].PrvBracket3;
      Tv[69]:= MaxR(0, Tv[66] - Tv[68]);
      Tv[71]:= Tv[69] * Vl(Frm[FNo].Strings[70]) / 100;
      Tv[72]:= PrvConstant[RY].PrvBracketTax4;
      Tv[67]:= Tv[71] + Tv[72];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket4) then
    begin
      Tv[166]:= Tv[1];
      Tv[167]:= PrvConstant[RY].PrvBracket4;
      Tv[168]:= MaxR(0, Tv[166] - Tv[167]);
      Tv[170]:= Tv[168] * Vl(Frm[FNo].Strings[169]) / 100;
      Tv[171]:= PrvConstant[RY].PrvBracketTax5;
      Tv[172]:= Tv[170] + Tv[171];
    end;
    {$endregion ' Top table '}

    Tv[23]:= PrvConstant[RY].PrvMaxSpousalAmount * partyear; //jz//20251215 - add partyear //20251210 Igor // MinR(PrvConstant[RY].PrvMaxSpousalAmount, Vl(FetchElm(RetNo, 'NS5804', 11))); //20250922 // PrvConstant[RY].PrvPersAmount * PartYear;  //20181123

    Tv[24]:= MinR(5734, Vl(FetchElm(RetNo, 'AGEDED', 17)));
    {//20251116
    if (Ret[RetNo].Province = 'NS') then
      Tv[24]:= MinR(5734, Vl(FetchElm(RetNo, 'AGEDED', 31)))
    else //all other provinces
      Tv[24]:= MinR(5734, Vl(FetchElm(RetNo, 'AGEDED', 17)));
    }


    if (Ret[RetNo].MarStatus < 3) then //jz//20251215 - add MarStatus if
    begin
      Tv[83]  := PrvConstant[RY].PrvSpouseBasicAmount;
      Tv[154] := MaxR(874, SpouseIncome(RetNo));  //jz//20260114 - SpouseIncome takes into account TOSI //if SpouseTosiInEffect(RetNo, InfoFNo) then Tv[154]:= GetSpouseTosiNetIncome(retNo, InfoFNo);
      //Tv[154]:= MaxR(874, Vl(FetchElm(RetNo, 'INFO', 19)));//lRealVal;
      Tv[28]  := MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[83] - Tv[154])); //jz//20260113 - this tv[28] commented out and CalcPrvSpousalClaim was used but seems CalcPrvSpousalClaim no longer in use?? giving wrong amount in TC15
      //Tv[28] := MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo)));
    end
    else Tv[28]:= 0; //jz//20260113 - to clear amount if there was one
    Tv[159]:= Tv[28];

    if HasEligibleDependant(RetNo) then //jz//20251215 - add "if HasEligibleDependant" because it just must the case
    begin
      Tv[178] := PrvConstant[RY].PrvSpouseBasicAmount;
      Tv[179] := MaxR(874, Vl(FetchElm(RetNo, 'S5PRV', 8))); //jz//20251215 - no NOT from the spouses income, who wrote this?? is 'S5PRV', 8 correct tho?? //MaxR(874, Vl(FetchElm(RetNo, 'INFO', 19)));
      Tv[29]  := MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[178] - Tv[179]));
    end
    else Tv[29]:= 0; //jz//20260113 - to clear amount if there was one
    Tv[180]:= Tv[29];


    //20201225
    //if (Ret[RetNo].Province = 'NS') then Tv[28]:= Vl(FetchElm(RetNo, 'NS5812', 16)); //20250922
    //if (Ret[RetNo].Province = 'NS') then Tv[29]:= Vl(FetchElm(RetNo, 'NS5816', 16)); //20250922
   {
   //??? but need
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount; // * PartYear; 20090109
   Tv[26] := SpouseIncome(RetNo);
   Tv[26] := GetSpouseTosiNetIncome(retNo,InfoFNo);   //20181227
   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   if Ret[RetNo].Province='NS' then Tv[27]:=Vl(FetchElm(RetNo,'NS5812',16)); //20181128
   if Ret[RetNo].Province='NS' then Tv[29]:=Vl(FetchElm(RetNo,'NS5816',16)); //20181202
   Tv[28]:= Tv[27];      //??? use worksheet
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];
   }
   //Tv[29]:= Vl(FetchElm(RetNo, 'NS5816', 16)); //20250922   //20181202 //Vl(FetchElm(RetNo,'S5PRV',10));    //20181129
   Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 87));
   Frm[FNo].Strings[73]:= Frm[FNo].Strings[158];

   if (Ret[RetNo].MarStatus < 3) and not IsLowerIncomeSpouse(RetNo) then Frm[FNo].Strings[73]:= '';

   Tv[74]:= Vl(Frm[FNo].Strings[73]) * 100;
   Tv[164]:= Tv[23] + Tv[24] + + Tv[159] + + Tv[180] + + Tv[30] + Tv[74];

    //Page 2
    Tv[48]:= Tv[164];
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[161]:= Ret[RetNo].Lnn[31217];
    Tv[165]:= Tv[31] + Tv[32] + Tv[33] + Tv[161];
    Tv[173]:= Tv[165];
    Tv[177]:= Tv[48] + Tv[173];
    {20201226
    // ??????
     Tv[85]:= PrvConstant[RY].PrvSpouseBasicAmount;
     Tv[159]:= Vl(FetchElm(RetNo,'S5PRV',8));
     Tv[154]:= MaxR(0,Tv[85]-Tv[159]); }
    Tv[34]:= GetPrvPnsDed(RetNo);
    Tv[35]:= Vl(FetchElm(RetNo, 'S5PRV', 90));
    Tv[174]:= Tv[177] + Tv[34] + Tv[35];

    if (Ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));

    Tv[37]:= GetPrvDisabXfer(RetNo);
    Tv[175]:= Tv[174] + Tv[36] + Tv[37];
    Tv[38]:= Ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[40]:= GetPrvEducXfer(RetNo);
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[176]:= Tv[175] + AddColumns(38, 41, 1);
    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    //20211115
    Tv[25]:= Ret[RetNo].Lnn[23600];
    Tv[26]:= 3;
    Tv[27]:= Tv[25] * Tv[26] / 100;
    Tv[85]:= MinR(Tv[27], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[85]);
    {Tv[80]:= PrvConstant[RY].PrvMedicalLimit;
    Tv[43]:= CalcPrvMedicalLimit(RetNo);
    Tv[44]:= MaxR(0,Tv[42]-Tv[43]);}
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= Tv[44] + Tv[45];
    Tv[47]:= Tv[46];
    Tv[49]:= Tv[176] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[53]:= GetS9DonLow(RetNo); //Lnn[32005];  //20161126 Lnn[32005];Lnn[32005];
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo);  //20161126  Lnn[347];Lnn[347];
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57] / 100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];

    // Page 3
    Tv[130]:= 0;
    //if Vl(FetchElm(RetNo,'NS428',20)) > 0 then
    if (Tv[20] > 0) then
      Tv[130]:= Tv[20]
    else
    if (Tv[21] > 0) then
      Tv[130]:= Tv[21]
    else
    if (Tv[22] > 0) then
      Tv[130]:= Tv[22]
    else
    if (Tv[67] > 0) then
      Tv[130]:= Tv[67]
    else
    if (Tv[172] > 0) then
      Tv[130]:= Tv[172];     //Vl(FetchElm(RetNo,'NS428',67));

    Tv[106]:= PrvConstant[RY].PrvAmtCarryOverRate;

    if SplitIncome(RetNo) then
      Tv[131]:= GetTOSIPrvTax(RetNo) // Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[131]:=0;

    Tv[132]:= Tv[130] + Tv[131];
    NormalPrvNonRefAmount:= Tv[61]; //Vl(FetchElm(RetNo,'NS428',61));
    if AllowSaSb(RetNo) then Tv[133]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20160503
     Else Tv[133]:=NormalPrvNonRefAmount; //20260514

    Tv[139]:= Ret[RetNo].Lnn[40427];

    if (Ret[RetNo].Province <> 'NS') then
    begin
      Tv[135]:= 0;
      Tv[137]:= 0;
    end;

    Tv[136]:= Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[35] * Tv[4]/100;
    Tv[140]:= Tv[139] * Tv[106] / 100;
    Tv[141]:= Tv[133] + Tv[136] + Tv[140]; //Tv[133]+Tv[136]+Tv[138]+Tv[140];  //20190921
    Tv[142]:= Tv[141];
    Tv[143]:= MaxR(0, Tv[132] - Tv[142]);
    Tv[112]:= Vl(FetchElm(RetNo, 'T691', 316)); //20250222 //AmountForPrvMinTax(RetNo); //Vl(FetchElm(RetNo,'T691',316)); //20190217

    if IsDeceased(RetNo) then Tv[112]:= 0;

    Tv[120]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[144]:= Tv[112] * Tv[120] / 100;
    Tv[145]:= Tv[143] + Tv[144];
    Tv[145]:=Tv[143] + Tv[144];
    Tv[149]:= GetPrvForTaxCredit(RetNo, 'NS');
    Tv[150]:= MaxR(0, Tv[145] - Tv[149]);

    //less than 19, no kids, no spouse
    if (Ret[RetNo].Age < 19) and (Tv[108] + Tv[109] + Tv[110] = 0) then
    begin
      for i:= 107 to 111 do TV[i]:= 0;
      for i:= 113 to 118 do TV[i]:= 0;
      for i:= 126 to 127 do TV[i]:= 0;

      Tv[84]:= 0;
    end;

    Tv[122]:= CalcMortgageForeclosure(ret[RetNo].Lnn[12700], Vl(FetchElmFNo(RetNo,GetFormNo('S3'), 122)), Vl(FetchElmFNo(RetNo,GetFormNo('S3'), 72)));
    Tv[124]:= Vl(FetchElm(RetNo, 'FORECLO', 4)); //CalcMortgageForeclosure(SpRetNo);

    // Column 1
    Tv[113]:= MaxR(0, SelectNetIncomeAmount(RetNo) - Tv[122]);  //MaxR(0,Lnn[23600]-Tv[122]);
    Tv[114]:= Ret[RetNo].Lnn[21300] + Vl(FetchElm(RetNo, 'OTHDED', 60));
    Tv[115]:= Tv[113] + Tv[114];
    Tv[104]:= Ret[RetNo].Lnn[11700] + Ret[RetNo].Lnn[12500]; //+GetRC310Income(RetNo); //20170126
    Tv[125]:= MaxR(0, TV[115] - Tv[104]);

    //Column 2
    //Tv[51]:= MaxR(0, Vl(FetchElm(RetNo, 'INFO', 19)) - Tv[124]);
    Tv[51]:= MaxR(0, SpouseIncome(RetNo) - Tv[124]);  //jz//20260114 - use SpouseIncome so to take into account TOSI
    Tv[76]:= Vl(FetchElm(RetNo, 'INFO', 162)) + Vl(FetchElm(RetNo, 'S2', 34));
    Tv[78]:= Vl(FetchElm(RetNo, 'INFO', 131)) + Vl(FetchElm(RetNo, 'S2', 33)) + Vl(FetchElm(RetNo, 'INFO', 168)); //20101202
    Tv[77]:= Tv[51] + Tv[76];
    Tv[79]:= MaxR(0, Tv[77] - Tv[78]);
    Tv[81]:= Tv[125] + Tv[79];

    if (Frm[FNo].Strings[102] + Frm[FNo].Strings[103] = '') then Frm[FNo].Strings[102]:= 'X';
    if (UpperCase(Frm[FNo].Strings[102]) = 'X') then {reduction claimed}
    begin
      Tv[107] := 300;

      if (MarStatus < 3) then Tv[108]:= 300 else Tv[108]:= 0;
      if (Tv[29] > 0) then Tv[109]:= 300 else Tv[109]:= 0;
      if (Tv[109] > 0) then Tv[108]:= 0;

      Frm[FNo].Strings[121]:= IntToStr(MyStrToInt(FetchElm(RetNo, 'DEPEND', 1)) - MyStrToInt(FetchElm(RetNo, 'DEPEND', 3)));

      if (Vl(Frm[FNo].Strings[121]) < 0) then Frm[FNo].Strings[121]:= '';

      //20090309
      if ((ret[RetNo].Age >= 19) or (MarStatus < 3) or (MyStrToInt(FetchElm(RetNo, 'DEPEND', 1)) > 0)) then //is parent
        //ok
      else
      begin
        Tv[107]:= 0;
        Tv[108]:= 0;
        Tv[109]:= 0;
        Frm[FNo].Strings[121]:= '';
        Tv[110]:= 0;
      end;

      if IsPrebankruptcyReturn(RetNo) then
      begin
        Tv[107]:= 0;
        Tv[108]:= 0;
        Tv[109]:= 0;
        Frm[FNo].Strings[121]:= '';
        Tv[110]:= 0;
      end;

      if (Frm[FNo].Strings[103] > '') then
      begin
        Tv[107]:= 0;
        Tv[108]:= 0;
        Tv[109]:= 0;
        Frm[FNo].Strings[121]:= '';
      end; //20141201 Other sp claiming

      //20140813
      Tv[84]:= MinR(600, Tv[107] + Tv[108] + Tv[109]);

      {?NSTAX  above should exclude if kids were eqiv to spouse}
      Tv[110]:= Vl(Ret[RetNo].Frm[FNo].Strings[121]) * 165;
      Tv[111]:= Tv[84] + Tv[110];
    end else
    begin
      for i:= 107 to 111 do TV[i]:= 0;

      Tv[84]:= 0;
      Frm[FNo].Strings[121]:= '';
    end;

    // Page 4
    Tv[138]:= Tv[150]; //20251210 Igor
    Tv[82]:= Tv[111];

    Tv[160]:= Tv[81];
    Tv[116]:= 15000;
    Tv[117]:= MaxR(0, (Tv[160] - Tv[116]));
    Tv[126]:= 5;
    Tv[127]:= Tv[117] * Tv[126] / 100;
    Tv[118]:= Tv[127];
    Tv[146]:= MaxR(0, (Tv[111] - Tv[118]));
    Tv[119]:= Tv[146];

    if (Ret[RetNo].Province <> 'NS') then Tv[119]:= 0;

    Tv[128]:= MaxR(0, Tv[138] - Tv[119]);
    Tv[129]:= GetPrvPolit(RetNo, 'NS');

    Tv[134]:= MinR(750, Tv[129] * 75 / 100);
    Tv[135]:= MaxR(0, Tv[128] - Tv[134]);

    Tv[105]:= Tv[75] * 25/100;
    Tv[137]:= MaxR(0, Tv[135] - Tv[105]);

    Tv[152]:= MinR(2000, Tv[151] * 20 / 100);
    Tv[153]:= MaxR(0, Tv[137] - Tv[152]);

    Tv[156]:= Vl(FetchElm(RetNo, 'T1285', 6));
    Tv[147]:= MaxR(0, Tv[153] - Tv[156]);

    Tv[155]:= Vl(FetchElm(RetNo, 'T225', 3));
    Tv[157]:= MaxR(0, Tv[147] - Tv[155]);

    Tv[162]:= Vl(FetchElm(RetNo, 'T224', 3));
    Tv[163]:= MaxR(0, Tv[157] - Tv[162]);

    if (Ret[RetNo].Age >= 65) and (Ret[RetNo].Lnn[26000] < 24000) then
     Tv[148]:= 1000
    else
     Tv[148]:= 0;

    Tv[123]:= MaxR(0, Tv[163] - Tv[148]);
    Lnn[42800]:= Tv[123];

    i:= 89;
    k:= 0;
    repeat
      if (Vl(Frm[Fno].Strings[i]) > 12) then Frm[FNo].Strings[i]:= '12';
      if (Ret[RetNo].Lnn[23600] > Vl(FetchElm(RetNo, 'INFO', 19))) and (Ret[RetNo].MarStatus < 3) then Frm[FNo].Strings[i]:= '0';

      k:= k + MyStrToInt(Frm[FNo].Strings[i]);
      Inc(i, 4);
    until i > 101;

    Frm[FNo].Strings[158]:= IntToStr(k);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250918 Igor <<<

//210181123
Procedure NS5804(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
Begin
 InitPrvConstants('NS');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'NS') = false  then
 begin
  For i:=1 to 10 do begin ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Ret[RetNo].Lnn[26000]<=25000 then
   begin
    for i:=1 to 11 do begin Tv[i]:=0;end;
    Tv[11]:=11481 * PartYear;    //20181128
   end

   Else If Ret[RetNo].Lnn[26000]>=75000 then
   begin
    for i:=1 to 11 do  begin Tv[i]:=0;end;
    Tv[11]:=8481 * PartYear; //20231124  PrvConstant[RY].PrvPersAmount * PartYear;  //8,481  //20181128
   end

   Else
   Begin
    Tv[1] :=8481; //20231124 PrvConstant[RY].PrvPersAmount;  //8,481
    Tv[2]:=3000;
    Tv[3]:=Ret[RetNo].Lnn[26000]
          +Vl(FetchElm(RetNo,'BANKRPT',13));  //20181204 +post bank inc
    Tv[4]:=25000;
    Tv[5]:=MaxR(0,Tv[3]-Tv[4]);
    Tv[6]:=6;
    Tv[8]:=Tv[5]*Tv[6]/100;
    Tv[7]:=Tv[8];
    Tv[9]:=MaxR(0,Tv[2]-Tv[7]);
    Tv[10]:=Tv[9];
    Tv[11]:=(MinR(11481,Tv[1]+Tv[10])) * PartYear;  //20181201
   End;
 end;
// ShowMessage('NS5804 after calc= '+FormatFloat('####,###.##',Vl(FetchElm(RetNo,'NS5804',11))));  //20181125
 SaveTv(RetNo,FName,FNo);
// ShowMessage('NS5804 after Save= '+FormatFloat('####,###.##',Vl(FetchElm(RetNo,'NS5804',11))));  //20181125
End;


//210181128
Procedure NS5812(RetNo:integer;FName:string;FNo:integer);
Var i:integer; InfoFormNo:Integer;
Begin
 InitPrvConstants('NS');
 LoadTv(RetNo,FName,FNo);
 If (CalcThisProvince(RetNo,'NS') = false)
 Or (Ret[RetNo].Marstatus >3)   //20220517  //allow widow also to claim deceased husband
 then
 begin
  For i:=1 to 16 do begin ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 If (Ret[RetNo].Marstatus=3) then //widow  //20230309
 begin
  if FetchElmFNo(RetNo,INFOFNo,39)='' then
  Begin
   For i:=1 to 16 do begin ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  End;
 end;



 With ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
    Tv[1] :=PrvConstant[RY].PrvSpouseBasicAmount;
    Tv[2]:=MaxR(848,Vl(FetchElm(RetNo,'INFO',19)));
    If SpouseTosiInEffect(RetNo,GetFormNo('INFO')) then
    Begin
     InfoFormNo:=GetFormNo('INFO');
     Tv[2]:=GetSpouseTosiNetIncome(RetNo,InfoFormNo); //20191202
    end;

    Tv[3]:=MaxR(0,Tv[1]-Tv[2]);
    if Tv[3]>PrvConstant[RY].PrvPersAmount then Tv[3]:=PrvConstant[RY].PrvPersAmount; //8481;  //20200327
    Tv[4]:=Tv[3];
    Tv[5]:=3000;
    Tv[6]:=Ret[RetNo].Lnn[26000];
    Tv[7]:=25000;
    Tv[8]:=MaxR(0,Tv[6]-Tv[7]);
    Tv[9]:=6;
    Tv[10]:=Tv[8]*Tv[9]/100;
    Tv[11]:=Tv[10];
    Tv[12]:=MaxR(0,Tv[5]-Tv[11]);
    Tv[13]:=Vl(FetchElm(RetNo,'INFO',19)); //Spouse NI
    Tv[14]:=MaxR(0,Tv[12]-Tv[13]);
    Tv[15]:=Tv[14];
    Tv[16]:=(Tv[4]+Tv[15]) * PartYear;  //20200327
    if Tv[16]>PrvConstant[RY].PrvMaxSpousalAmount then Tv[16]:=PrvConstant[RY].PrvMaxSpousalAmount;
    //MinR(PrvConstant[RY].PrvSpouseBasicAmount,Tv[4]+Tv[15]) * PartYear;  //20181201
 end;
 SaveTv(RetNo,FName,FNo);
End;

//210181202    Eligible dependant
Procedure NS5816(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
Begin
 InitPrvConstants('NS');
 LoadTv(RetNo,FName,FNo);
 If (HasEligibleDependant(RetNo) = False) //20181202
 //If (FetchElm(RetNo,'DEPEND',3)='')  //no eligible dependant  //20181202
 or (CalcThisProvince(RetNo,'NS') = false)
 then
 begin
  For i:=1 to 16 do begin ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
    Tv[1] :=PrvConstant[RY].PrvSpouseBasicAmount;
    Tv[2]:=MaxR(Vl(FetchElm(RetNo,'S5PRV',8)),848);  //20181128
    Tv[3]:=MaxR(0,Tv[1]-Tv[2]);If Tv[3]>8481 then Tv[3]:=8481;
    Tv[4]:=Tv[3];
    Tv[5]:=3000;
    Tv[6]:=Ret[RetNo].Lnn[26000];
    Tv[7]:=25000;
    Tv[8]:=MaxR(0,Tv[6]-Tv[7]);
    Tv[9]:=6;
    Tv[10]:=Tv[8]*Tv[9]/100;
    Tv[11]:=Tv[10];
    Tv[12]:=MaxR(0,Tv[5]-Tv[11]);
    Tv[13]:=Vl(FetchElm(RetNo,'S5PRV',8));  //20181202
    Tv[14]:=MaxR(0,Tv[12]-Tv[13]);
    Tv[15]:=Tv[14];
    Tv[16]:=MinR(PrvConstant[RY].PrvSpouseBasicAmount,Tv[4]+Tv[15]);
 end;
 SaveTv(RetNo,FName,FNo);
// ShowMessage('NS5804 after Save= '+FormatFloat('####,###.##',Vl(FetchElm(RetNo,'NS5804',11))));  //20181125
End;




procedure POLIT(RetNo: integer; FName: String;FNo: integer);
Var cn,us, percent1: real; I,T2203FNo: integer;SpRetNo:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
   If (ret[RetNo].MarStatus >2) then
   begin
     If ((ret[RetNo].MarStatus=3) and MarStatusChanged(RetNo)) then  //20110326
     //do nothing
     Else
     Begin
      If Tv[19]=0 then Tv[19]:=100;
      If Tv[27]=0 then Tv[27]:=100;
     end;
   end;
   If Tv[19]>100 then Tv[19]:=100;
   If Tv[27]>100 then Tv[27]:=100;
   Tv[1] := ret[RetNo].T5013FedPol;
   Tv[7] := ret[RetNo].T5013ProvPol;

   Strings[26]:='Y';
   If UpperCase(Strings[26])='Y' then
   begin
    If ret[RetNo].CouplingSw = True then
    begin
     SpRetNo:=GetSpRetNo(RetNo);
     If SpRetNo>0 then
     begin
      Tv[21]:=Ret[SpRetNo].T5013FedPol;
      Tv[22]:=Ret[SpRetNo].T5013ProvPol;
     end;
    end; //couplingsw
   end
   else
   begin
    Tv[21]:=0;
    Tv[22]:=0;
   end;

   Tv[20] := Tv[1] +Tv[21]+Tv[3] +Tv[5];
   Tv[6] := Tv[20] * Tv[19]/100;
   Tv[23]:= Tv[7]+Tv[22]+Tv[9] +Tv[11];
   Tv[12]:= Tv[23] * Tv[27]/100;

   Tv[24]:= Tv[14]+Tv[15];
   Tv[16]:= Tv[24] * Tv[27]/100;

   Tv[25] := Tv[20]+Tv[23]+Tv[24];
   Tv[13] := Tv[6]+Tv[12]+Tv[16];

   //multjurisdiction //20240510
   if IsMultJurisdiction(RetNo) then
   Begin
    T2203FNo:=GetFormNo('T2203');
    if Tv[42]=0 then Tv[42]:=100;
    Percent1:=Tv[42]/100;
    Percent1:=Tv[42]/100;
    Tv[41]:=0; Tv[44]:=0;
    for i:=45 to 56 do
    Begin
     Tv[i]:=Tv[i-17] * Percent1;
    End;
    //check alloc
    for i:=45 to 56 do
    Begin
     If Vl(GetMJAlloc(RetNo, 'AB')) =0 then Tv[45]:=0;
     If Vl(GetMJAlloc(RetNo, 'BC')) =0 then Tv[46]:=0;
     If Vl(GetMJAlloc(RetNo, 'MB')) =0 then Tv[47]:=0;
     If Vl(GetMJAlloc(RetNo, 'NS')) =0 then Tv[48]:=0;
     If Vl(GetMJAlloc(RetNo, 'NB')) =0 then Tv[49]:=0;
     If Vl(GetMJAlloc(RetNo, 'NL')) =0 then Tv[50]:=0;
     If Vl(GetMJAlloc(RetNo, 'NT')) =0 then Tv[51]:=0;
     If Vl(GetMJAlloc(RetNo, 'NU')) =0 then Tv[52]:=0;
     If Vl(GetMJAlloc(RetNo, 'ON')) =0 then Tv[53]:=0;
     If Vl(GetMJAlloc(RetNo, 'PE')) =0 then Tv[54]:=0;
     If Vl(GetMJAlloc(RetNo, 'QC')) =0 then Tv[55]:=0;
     If Vl(GetMJAlloc(RetNo, 'SK')) =0 then Tv[56]:=0;
     If Vl(GetMJAlloc(RetNo, 'YT')) =0 then Tv[57]:=0;
    End;
    for i:=28 to 40 do  Begin Tv[41]:=Tv[41]+TV[i];End;
    for i:=45 to 57 do  Begin Tv[44]:=Tv[44]+TV[i];End;
   End
   Else
   begin
    for i:=28 to 41 do  Begin Tv[i]:=0;end;
    for i:=45 to 57 do  Begin Tv[i]:=0;end;
    TV[44]:=0;
   end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked=False) then
  begin
   StoreElm(RetNo,GetFormNo('OPTIMIZE'),15,FormatFloat('###.##',Ret[RetNo].Frm[FNo].Tv[19]));
   StoreElm(RetNo,GetFormNo('OPTIMIZE'),18,FormatFloat('###.##',100-Ret[RetNo].Frm[FNo].Tv[19]));
  end;
end;

Procedure YRSUM(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,jj,FromElm,ToElm,Yr,LnNo:integer;
   LnNoStr:String[4];
   TempList:TstringList;LinesList:TstringList;
   ValueList:TstringList;FlName:string[12];
  //DirList:TStringList; //20170512 igor
   FromDir:String;
begin
 If ShowUnconvertedLastYear(RetNo) then exit;
 If ShowUnconvertedLastYear(RetNo) then exit;
  TempList := TstringList.Create;
  LinesList := TstringList.Create; {Prev year}
  ValueList := TstringList.Create; {Prev year}
  try
    LoadTv(RetNo,FName,FNo);
    Templist.sorted:=True;//20111211
    TempList.LoadFromFile(AppDir+'\'+'YRSUM.D');

  //Initialize
  With ret[RetNo].Frm[Fno] do
  begin
   If (UpperCase(LeftStr(Strings[7],1)) <> 'Y')
   and (UpperCase(LeftStr(Strings[7],1)) <> 'N')
   and (UpperCase(Strings[7]) <> '')
   then  Strings[7]:='';

   If (IsProfileReturn(RetNo)) or (IsCantaxReturn(RetNo)) then
   begin
    i:=8;
    Repeat
     Tv[i]:=0;
     Inc(i,5);
    until i>774; //20160126 772;   //243 //20101206
   end;
  end;  //with

  //populate current year
  with ret[RetNo].Frm[Fno] do
  begin
   Strings[1] := FetchElm(RetNo,'INFO',2)+' '+FetchElm(RetNo,'INFO',5);
   Strings[301] := FetchElm(RetNo,'INFO',2)+' '+FetchElm(RetNo,'INFO',5);
   Strings[601] := FetchElm(RetNo,'INFO',2)+' '+FetchElm(RetNo,'INFO',5);
   //year headings
   Strings[2] := AppYear;
   Strings[3] := IntToStr(StrToInt(AppYear)-1);
   Strings[4] := IntToStr(StrToInt(AppYear)-2);
   Strings[5] := IntToStr(StrToInt(AppYear)-3);
   Strings[6] := IntToStr(StrToInt(AppYear)-4);
   //20091209
   Strings[302] := Strings[2];
   Strings[303] := Strings[3];
   Strings[304] := Strings[4];
   Strings[305] := Strings[5];
   Strings[306] := Strings[6];

   Strings[602] := Strings[2];
   Strings[603] := Strings[3];
   Strings[604] := Strings[4];
   Strings[605] := Strings[5];
   Strings[606] := Strings[6];

   i:=8;
   repeat
   j:=IsInList(AddLeadingZeros(IntToStr(i),3),TempList);
  // if i=268 then ShowMessage('307 on line 268');    //20190324

   If j>-1 then
   begin
    LnNo:=MyStrToInt(MidStr(TempList[j],5,5)); //20190709 Igor
    Tv[i] := ret[RetNo].Lnn[LnNo];
    Tv[273]:=Ret[RetNo].Lnn[22215];  Tv[274]:=0;Tv[275]:=0;Tv[276]:=0;TV[277]:=0; //20200217
   // If LnNo=208 then ShowMessage('Ln 208' + ' '+FormatFloat('######.00',Tv[i]));
   end;
   inc(i,5);
   until i>788; //i>783; //20201215
   //20110308

   //put cf of climate //20200308
   Tv[784]:=CF_Climate2018;
   Tv[785]:=CF_Climate2017;
   //calc line 482
   If UpperCase(Strings[773])<>'Y' then
   Begin
    k:=0;
    Repeat
     Tv[759+k]:=
       Tv[684+k]+
       Tv[689+k]+
       Tv[694+k]+
       Tv[699+k]+
       Tv[724+k]+
       Tv[754+k]+
       Tv[704+k]+
       Tv[709+k]+
       Tv[714+k]+
       Tv[779+k]+            //20160126
       Tv[719+k]+
       Tv[729+k];
       If IsCantaxReturn(RetNo) then Tv[759+k]:=Tv[759+k]+Tv[674+k]; //20110327
     inc(k);
    until k>3;
   end;
   Strings[607]:='Invoice';
   Tv[748]:=Vl(FetchElm(RetNo,'INVOICE',222));

  {Prev year}

  If (IsProfileReturn(RetNo)) or (IsCantaxReturn(RetNo)) then
  begin
   SaveTv(RetNo,FName,FNo);
   Exit;
  end;

 end; {End with}
 SaveTv(RetNo,FName,FNo);
 //20170512 igor >>>
  finally
    TempList.Free;
    LinesList.Free;
    ValueList.Free;
  end;
end;

//20200315
Procedure T1139(RetNo:integer;FName:string;FNo:integer);
Var i,BusFNo:integer;BusFrmName:String[12];Converting:Boolean;
  FInst : String[4];
  BusFrmNo:integer;x,A,B,ABCD:Real;
  C,D:Integer; Dt1,Dt2:String[10];
  BusinessName,BusinessNo:String;
  BusNetIncome:Real;   //20190329
  lPercVal: Extended; //20251208 Igor
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin

   If UpperCase(Strings[1]) = 'Y' then Converting :=true
    else Converting := false;

   For i:=33 to 36 do Strings[i] :='';
   If      LeftStr(Strings[2],5) = 'T2125' then Strings[33] := 'X'
   Else if LeftStr(Strings[2],5) = 'T2032' then Strings[34] := 'X'
   Else if LeftStr(Strings[2],5) = 'T2042' then Strings[35] := 'X'
   Else if LeftStr(Strings[2],5) = 'T2121' then Strings[36] := 'X'
   Else if LeftStr(Strings[2],5) = 'T1163' then Strings[39] := 'X'
   Else if LeftStr(Strings[2],5) = 'T1273' then Strings[12] := 'X';

   BusFrmName := AllTrim(FetchElm(RetNo,'T1139'+FInst,2));
   BusFrmNo := GetFormNo(BusFrmName);

   If BusFrmNo >0 then
   begin
    If (LeftStr(BusFrmName,5) = 'T2125') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,4);
     Dt2 := FetchElm(RetNo,BusFrmName,5);
     //BusNetIncome:=Vl(FetchElm(RetNo,BusFrmNo, 106));
     BusNetIncome:= TotMultiple(RetNo,ExtractNonInstFormName(BusFrmName),106);  //jz//20260115 - account for multiple instances
    end;
    If (LeftStr(BusFrmName,5) = 'T2121') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,4);
     Dt2 := FetchElm(RetNo,BusFrmName,5);
     //BusNetIncome:=Vl(FetchElm(RetNo,BusFrmNo, 74));
     BusNetIncome:= TotMultiple(RetNo,ExtractNonInstFormName(BusFrmName), 74);  //jz//20260115 - account for multiple instances
    end;
    If (LeftStr(BusFrmName,5) = 'T2042') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,4);
     Dt2 := FetchElm(RetNo,BusFrmName,5);
     //BusNetIncome:= Vl(FetchElm(RetNo,BusFrmNo, 148));
     BusNetIncome:= TotMultiple(RetNo,ExtractNonInstFormName(BusFrmName),148);  //jz//20260115 not calcing all the instances, causing error in TC87, change the others too //
    end;
    If (LeftStr(BusFrmName,5) = 'T1163') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,213);
     Dt2 := FetchElm(RetNo,BusFrmName,214);
     BusNetIncome:=Vl(FetchElm(RetNo,BusFrmNo, 616));
     BusNetIncome:= TotMultiple(RetNo,ExtractNonInstFormName(BusFrmName), 616);  //jz//20260115 - account for multiple instances
    end;

    If (LeftStr(BusFrmName,5) = 'T1273') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,213);
     Dt2 := FetchElm(RetNo,BusFrmName,214);
     BusNetIncome:=Vl(FetchElm(RetNo,BusFrmNo, 616));
     BusNetIncome:= TotMultiple(RetNo,ExtractNonInstFormName(BusFrmName), 616);  //jz//20260115 - account for multiple instances
    end;
   end;

    //days
   If dt2<AppYear+'-12-31' then
    C:= DateDiffYMD(Dt2,AppYear+'-12-31')-1
   else
    C:=0;
   If c<0 then C:=0;
   If Dt2 = AppYear+'-12-31' then C:=0;

   If (Dt1 >'') and (Dt2 >'') then
   begin
    D := DateDiffYMD(Dt1,Dt2); //20160119 Igor
   end
   else
    D:=0;


   BusFrmName := AllTrim(Strings[2]);
   BusFNo := GetFormNo(BusFrmName);

   If BusFNo >0 then
   begin
    If Strings[33] = 'X' then  {bus}
      begin
       BusinessName :=FetchElmFNo(RetNo,BusFNo,8);
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,19);
      end;

    If Strings[35] = 'X' then   {farm}
      begin
       BusinessName :=FetchElmFNo(RetNo,BusFNo,8);
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,21);
      end;

      If Strings[39] = 'X' then   {t1163 nisa}
      begin
       //20180424
       BusinessName :=FetchElmFNo(RetNo,BusFNo,201);  //1  //farm name
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,20);  //pin   //2
      end;

    If Strings[36] = 'X' then  {fish}
      begin
       BusinessName :=FetchElmFNo(RetNo,BusFNo,75);
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,15);
      end;
     If Strings[12] = 'X' then   {T1273}
      begin
       //20180424
       BusinessName :=FetchElmFNo(RetNo,BusFNo,201);  //1  //farm name
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,20);  //pin   //2
       {
       BusinessName :=FetchElmFNo(RetNo,BusFNo,1);
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,2);
       }
      end;
   end;

   Strings[55]:=BusinessName;
   Strings[56]:=BusinessNo;

   If strings[1] = '' then Strings[1] := 'N'; //not chamging the period to Dec 31
   if UpperCase(Strings[1])='Y' then converting:=True Else Converting:=False;

   Strings[13]:=GetFirstName(RetNo)+' '+GetLastName(RetNo); //20180211
   Strings[4] :=GetSinNo(RetNo);
   Strings[38]:=BusinessName;
   Strings[5] :=BusinessNo;

   //---------------------------------------------------------------
   // Alternative - Do not change to Dec 31
   // -------------------------------------------------------------
   //If Frm[FNo].Strings[101] = '' then Frm[FNo].Strings[101] :='N';{override}
   //If Frm[FNo].Strings[102] = '' then Frm[FNo].Strings[102] :='N'; {no new bus}


   if Converting = false then Tv[18]:=BusNetIncome  //20190329
      Else Tv[18]:=0;  //20200314
   //Part 2 Not ending in Dec 31
   if LeftStr(Dt2,4)=AppYear then  //ends in current year suc as 2018
   Begin
     Tv[24]:=Ret[RetNo].Lnn[25400];
     Tv[54]:=MinR(Tv[16],Tv[24]);
     Tv[28]:=MaxR(0,Tv[18]-Tv[54]);
     Strings[40] := IntToStr(C);
     Strings[44] := IntToStr(D);
     if Strings[44]>'366' then Strings[44]:='366';  //20201211 allow for leap years
     //if Strings[44]>'365' then Strings[44]:='365';

     //20251208 Igor >>>
     if (Vl(Strings[44]) > 0) then
     begin
       lPercVal:= Vl(Strings[40]) / Vl(Strings[44]);
       Tv[29]:= lPercVal;
       Tv[52]:= Tv[28] * lPercVal;
     end else
     begin
       Tv[29]:= 0;
       Tv[52]:= Tv[28] * Tv[29];
     end;
     //20251208 Igor <<<
   End
   Else if LeftStr(Dt2,4)>AppYear then
   Begin
     Tv[16]:=0;
     Strings[40]:='';
     Strings[44]:='';
     Tv[16]:=0;
     Tv[24]:=0;
     Tv[52]:=0;

     Tv[48]:=Tv[18];
     Tv[49]:=Ret[RetNo].Lnn[25400];
     Tv[30]:=MinR(Tv[57],Tv[49]);
     Tv[41]:=MaxR(0,Tv[48]-Tv[30]);
     Strings[50] := IntToStr(DateDiffYMD(Dt1,AppYear+'-12-31')); //days in Appyear Dt2 is AppYear+1
     if Strings[50]>'365' then Strings[50]:='365'; //20180305
     Strings[51] := IntToStr(DateDiffYMD(Dt1,Dt2));
     if Strings[51]>'365' then Strings[51]:='365';
     If MyStrToInt(Strings[51])>0 then
      Tv[43]:=Vl(Strings[50])/Vl(Strings[51])
     Else
      Tv[43]:=0;
     Tv[53]:=Tv[41]*Tv[43];
   End;
   //Part 3 - death of propritor
   if UpperCase(Strings[59])='Y' then
   Begin
     Tv[58]:=Tv[18];
     Tv[14]:=Ret[RetNo].Lnn[25400];
     Tv[15]:=MinR(Tv[3],Tv[14]);
     Tv[17]:=MaxR(0,Tv[58]-Tv[15]);
     Strings[20] := IntToStr(C);
     Strings[25] := IntToStr(D);
     if Strings[20]>'365' then Strings[20]:='365';
     if Strings[25]>'365' then Strings[25]:='365';

     If Vl(Strings[25])>0  then
       Tv[26]:=Vl(Strings[20])/Vl(Strings[25])
     Else
       Tv[26]:=0;
     Tv[27]:=Tv[17]*Tv[26];
   End
   Else
   Begin
     Tv[58]:=0;
     Tv[14]:=0;
     Tv[14]:=0;
     Tv[15]:=0;
     Tv[17]:=0;
     Strings[20] :='';
     Strings[25] :='';
     Tv[26]:=0;
     Tv[27]:=0;
   End;
   //----------------------------------------
   Tv[19]:=MaxR(Tv[27],MaxR(Tv[52],Tv[53]));
   Tv[21]:=Tv[18]+Tv[19];
   //Tv[22]  from last year
   Tv[23]:=Tv[21]-Tv[22];


   //-------CONVERTING  TO DEC 31-----------------------------------------------------------------
   If Converting then  //clear Part1
   Begin
     Tv[18]:=0;
     Tv[16]:=0;
     Tv[24]:=0;
     Tv[54]:=0;
     Tv[28]:=0;
     Strings[40]:='';
     Strings[44]:='';
     Tv[29]:=0;
     Tv[52]:=0;
     //
     Tv[48]:=0;
     Tv[57]:=0;
     Tv[49]:=0;
     Tv[30]:=0;
     Tv[41]:=0;
     Strings[50]:='';
     Strings[51]:='';
     Tv[43]:=0;
     Tv[53]:=0;
   end;
   If Converting then
   begin
    Tv[9]:=Tv[6]+Tv[7];
    Tv[11] := Tv[9]-Tv[10];
   end
   Else
   Begin
     Tv[6]:=0;Tv[7]:=0;Tv[9]:=0;Tv[10]:=0;Tv[11]:=0;
    End;
  //Certification
   Strings[31]:=GetFirstName(RetNo);
   Strings[45]:=GetLastName(RetNo);
   If strings[32] = '' then Strings[32] := FormatDateTime('yyyy-mm-dd',Now);

 //------------------------------
   if UpperCase(Strings[42])<>'Y' then  //for jacket //20200315
   Begin
      if Tv[23]<>0 then
        Tv[37]:=Tv[23]
      Else
        Tv[37]:=Tv[11];
   end;
  end;
  SaveTv(RetNo,FName,FNo);
end;


(*
//20180218
Procedure T1139(RetNo:integer;FName:string;FNo:integer);
Var i,BusFNo:integer;BusFrmName:String[12];Converting:Boolean;
  FInst : String[4];
  BusFrmNo:integer;x,A,B,ABCD:Real;
  C,D:Integer; Dt1,Dt2:String[10];
  BusinessName,BusinessNo:String;
  BusNetIncome:Real;   //20190329
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin

   If UpperCase(Strings[1]) = 'Y' then Converting :=true
    else Converting := false;

   For i:=33 to 36 do Strings[i] :='';
   If      LeftStr(Strings[2],5) = 'T2125' then Strings[33] := 'X'
   Else if LeftStr(Strings[2],5) = 'T2032' then Strings[34] := 'X'
   Else if LeftStr(Strings[2],5) = 'T2042' then Strings[35] := 'X'
   Else if LeftStr(Strings[2],5) = 'T2121' then Strings[36] := 'X'
   Else if LeftStr(Strings[2],5) = 'T1163' then Strings[39] := 'X'
   Else if LeftStr(Strings[2],5) = 'T1273' then Strings[12] := 'X';

   BusFrmName := AllTrim(FetchElm(RetNo,'T1139'+FInst,2));
   BusFrmNo := GetFormNo(BusFrmName);

   If BusFrmNo >0 then                            //20190329
   begin
    If (LeftStr(BusFrmName,5) = 'T2125') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,4);
     Dt2 := FetchElm(RetNo,BusFrmName,5);
     BusNetIncome:=Vl(FetchElm(RetNo,BusFrmNo, 106));
    end;
    If (LeftStr(BusFrmName,5) = 'T2121') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,4);
     Dt2 := FetchElm(RetNo,BusFrmName,5);
     BusNetIncome:=Vl(FetchElm(RetNo,BusFrmNo, 74));
    end;
    If (LeftStr(BusFrmName,5) = 'T2042') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,4);
     Dt2 := FetchElm(RetNo,BusFrmName,5);
     BusNetIncome:=Vl(FetchElm(RetNo,BusFrmNo, 148));
    end;
    If (LeftStr(BusFrmName,5) = 'T1163') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,213);
     Dt2 := FetchElm(RetNo,BusFrmName,214);
     BusNetIncome:=Vl(FetchElm(RetNo,BusFrmNo, 616));
    end;

    If (LeftStr(BusFrmName,5) = 'T1273') then
    begin
     Dt1 := FetchElm(RetNo,BusFrmName,213);
     Dt2 := FetchElm(RetNo,BusFrmName,214);
     BusNetIncome:=Vl(FetchElm(RetNo,BusFrmNo, 616));
    end;
   end;

    //days
   If dt2<AppYear+'-12-31' then
    C:= DateDiffYMD(Dt2,AppYear+'-12-31')-1
   else
    C:=0;
   If c<0 then C:=0;
   If Dt2 = AppYear+'-12-31' then C:=0;

   If (Dt1 >'') and (Dt2 >'') then
   begin
    D := DateDiffYMD(Dt1,Dt2); //20160119 Igor
   end
   else
    D:=0;


   BusFrmName := AllTrim(Strings[2]);
   BusFNo := GetFormNo(BusFrmName);

   If BusFNo >0 then
   begin
    If Strings[33] = 'X' then  {bus}
      begin
       BusinessName :=FetchElmFNo(RetNo,BusFNo,8);
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,19);
      end;

    If Strings[35] = 'X' then   {farm}
      begin
       BusinessName :=FetchElmFNo(RetNo,BusFNo,8);
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,21);
      end;

      If Strings[39] = 'X' then   {t1163 nisa}
      begin
       //20180424
       BusinessName :=FetchElmFNo(RetNo,BusFNo,201);  //1  //farm name
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,20);  //pin   //2
      end;

    If Strings[36] = 'X' then  {fish}
      begin
       BusinessName :=FetchElmFNo(RetNo,BusFNo,75);
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,15);
      end;
     If Strings[12] = 'X' then   {T1273}
      begin
       //20180424
       BusinessName :=FetchElmFNo(RetNo,BusFNo,201);  //1  //farm name
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,20);  //pin   //2
       {
       BusinessName :=FetchElmFNo(RetNo,BusFNo,1);
       BusinessNo :=FetchElmFNo(RetNo,BusFNo,2);
       }
      end;
   end;

   Strings[55]:=BusinessName;
   Strings[56]:=BusinessNo;

   If strings[1] = '' then Strings[1] := 'N'; //not chamging the period to Dec 31
   if UpperCase(Strings[1])='Y' then converting:=True Else Converting:=False;

   Strings[13]:=GetFirstName(RetNo)+' '+GetLastName(RetNo); //20180211
   Strings[4] :=GetSinNo(RetNo);
   Strings[38]:=BusinessName;
   Strings[5] :=BusinessNo;

   //---------------------------------------------------------------
   // Alternative - Do not change to Dec 31
   // -------------------------------------------------------------
   //If Frm[FNo].Strings[101] = '' then Frm[FNo].Strings[101] :='N';{override}
   //If Frm[FNo].Strings[102] = '' then Frm[FNo].Strings[102] :='N'; {no new bus}


   if Converting = false  then Tv[18]:=BusNetIncome;  //20190329

   if LeftStr(Dt2,4)=AppYear then  //ends in current year suc as 2018
   Begin

     Tv[16]:=Tv[18];
     Tv[24]:=Ret[RetNo].Lnn[25400];
     Strings[40] := IntToStr(C);
     Strings[44] := IntToStr(D);
     if Strings[44]>'365' then Strings[44]:='365';

     x:=MinR(Tv[54],Tv[24]);
     If MyStrToInt(Strings[44])>0 then
       Tv[52]:=MaxR(0,Tv[16]- x)*(MyStrToInt(Strings[40])/MyStrToInt(Strings[44]))
     Else
       Tv[52]:=0;
     //clear other section
     Tv[48]:=0;
     Strings[50]:='';Strings[51]:='';
     Tv[53]:=0;    //20190329
   end  //calc first part C
   Else if LeftStr(Dt2,4)>AppYear then
   Begin
     Tv[16]:=0;
     Strings[40]:='';
     Strings[44]:='';
     Tv[16]:=0;
     Tv[24]:=0;
     Tv[52]:=0;

     Tv[48]:=Tv[18];
     Tv[49]:=Ret[RetNo].Lnn[25400];
     Strings[50] := IntToStr(DateDiffYMD(Dt1,AppYear+'-12-31')); //days in Appyear Dt2 is AppYear+1

     if Strings[50]>'365' then Strings[50]:='365'; //20180305
     Strings[51] := IntToStr(DateDiffYMD(Dt1,Dt2));
     if Strings[51]>'365' then Strings[51]:='365';

     x:=MinR(Tv[57],Tv[49]);
     If MyStrToInt(Strings[51])>0 then
       Tv[53]:=MaxR(0,Tv[48]-X) * (MyStrToInt(Strings[50])/MyStrToInt(Strings[51]))
     Else
       Tv[53]:=0;
   End;

   Tv[19]:=MaxR(Tv[52],Tv[53]);
   Tv[21]:=Tv[18]+Tv[19];
   //Tv[22]  from last year
   Tv[23]:=Tv[21]-Tv[22];

   //1B Certif section
   Strings[27]:=GetFirstName(RetNo);
   Strings[28]:=GetLastName(RetNo);
   If strings[43] = '' then Strings[43] := FormatDateTime('yyyy-mm-dd',Now);

   If Converting then  //clear Part1
   Begin
     Strings[13]:='';Strings[4]:='';
     Strings[38]:=''; Strings[5]:='';
     Tv[18]:=0;
     Tv[16]:=0;Strings[40]:='';Strings[44]:=''; Tv[52]:=0;
     Tv[24]:=0;
     Tv[48]:=0;Tv[49]:=0;Tv[53]:=0; Strings[50]:='';Strings[51]:='';Tv[53]:=0;
     Tv[24]:=0; Tv[49]:=0;
     //certif wipe out
     Strings[3]:='';Strings[14]:='';For i:=27 to 29 do Strings[i]:='';
     Strings[41]:='';
   end;


   //-------CONVERTING  TO DEC 31-----------------------------------------------------------------
   If Converting then
   begin
    BusFNo := GetFormNo(BusFrmName);
    Strings[26]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
    Strings[25]:=GetSinNo(RetNo);
    Strings[15]:=BusinessName;
    Strings[20]:=BusinessNo;

    Tv[9]:=Tv[6]+Tv[7];
    Tv[11] := Tv[9]-Tv[10];
    Strings[31]:=GetFirstName(RetNo);
    Strings[45]:=GetLastName(RetNo);
    If strings[32] = '' then Strings[32] := FormatDateTime('yyyy-mm-dd',Now);
    end
    else
    Begin
     Strings[26]:='';
     Strings[25]:='';
     Strings[15]:='';
     Strings[20]:='';
     Tv[6]:=0;Tv[7]:=0;Tv[9]:=0;Tv[10]:=0;Tv[11]:=0;
     Strings[31]:='';Strings[45]:='';Strings[46]:='';Strings[47]:='';
    End;
   //20180221
   if UpperCase(Strings[42])<>'Y' then
   Begin
     if Tv[23]<>0 then
       Tv[37]:=Tv[23]
     Else
       Tv[37]:=Tv[11];
   End;
  end;
  SaveTv(RetNo,FName,FNo);

end;
*)
Procedure T101(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
    Tv[14] := Tv[2]+Tv[9]-Tv[5];
    Tv[15] := Tv[3]+Tv[11]-Tv[12];
   // Tv[16] := Tv[4]+Tv[13]-Tv[10]; //20230117
  end;

  SaveTv(RetNo,FName,FNo);
end;

Procedure T102(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
  end;
  SaveTv(RetNo,FName,FNo);
end;

//20250918 Igor >>>
procedure NU428(RetNo: Integer; FName: string; FNo: Integer);
Const
  FirefighterClaim = 722; //20250922 Igor 703; //jz//20250301 671

var
  i, j, count: Integer;
  x, y, z: Real;
  NormalPrvNonRefAmount:real;
begin
  InitPrvConstants('NU');
  LoadTv(RetNo,FName,FNo);

  if not CalcThisProvince(RetNo, 'NU') then // Or (NonResWithEmpl(retNo)=True)    //20230415
  begin
    for i:= 1 to 187 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo].Frm[FNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= Ret[RetNo].Lnn[26000];

    {$region ' Top table '}
    for i:= 2 to 22 do
    begin
      Tv[i]:= 0;
      Strings[i]:= '';
    end;
    for i:= 66 to 72 do
    begin
      Tv[i]:= 0;
      Strings[i]:= '';
    end;

    Strings[11]:= PrvConstant[RY].PrvRate1;
    Strings[12]:= PrvConstant[RY].PrvRate2;
    Strings[13]:= PrvConstant[RY].PrvRate3;
    Strings[70]:= PrvConstant[RY].PrvRate4;

    Tv[6]:= PrvConstant[RY].PrvBracket1;
    Tv[18]:= PrvConstant[RY].PrvBracketTax2;
    Tv[7]:= PrvConstant[RY].PrvBracket2;
    Tv[19]:= PrvConstant[RY].PrvBracketTax3;
    Tv[68]:= PrvConstant[RY].PrvBracket3;
    Tv[72]:= PrvConstant[RY].PrvBracketTax4;

    if (Tv[1] <= PrvConstant[RY].PrvBracket1) then
    begin
      Tv[2]:= Tv[1];
      Tv[5]:= 0;
      Tv[8]:= MaxR(0, Tv[2] - Tv[5]);
      Tv[14]:= Tv[8] * Vl(Strings[11]) / 100;
      Tv[17]:= 0;
      Tv[20]:= Tv[14] + Tv[17];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket1) and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
    begin
      Tv[3]:= Tv[1];
      Tv[6]:= PrvConstant[RY].PrvBracket1;
      Tv[9]:= MaxR(0, Tv[3] - Tv[6]);
      Tv[15]:= Tv[9] * Vl(Strings[12]) / 100;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[21]:= Tv[15] + Tv[18];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket2) and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
    begin
      Tv[4]:= Tv[1];
      Tv[7]:= PrvConstant[RY].PrvBracket2;
      Tv[10]:= MaxR(0, Tv[4] - Tv[7]);
      Tv[16]:= Tv[10] * Vl(Strings[13]) / 100;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[22]:= Tv[16] + Tv[19];
    end;

    if (Tv[1] > PrvConstant[RY].PrvBracket3) then
    begin
      Tv[66]:= Tv[1];
      Tv[68]:= PrvConstant[RY].PrvBracket3;
      Tv[69]:= MaxR(0, Tv[66] - Tv[68]);
      Tv[71]:= Tv[69] * Vl(Strings[70]) / 100;
      Tv[72]:= PrvConstant[RY].PrvBracketTax4;
      Tv[67]:= Tv[71] + Tv[72];
    end;
    {$endregion ' Top table '}

    Tv[23]:= PrvConstant[RY].PrvPersAmount * Ret[RetNo].PartYear;
    Tv[24]:= Vl(FetchElm(RetNo, 'AGEDED', 17));
    Tv[25]:= PrvConstant[RY].PrvSpouseBasicAmount * Ret[RetNo].PartYear;
    Tv[26]:= SpouseIncome(RetNo);

    if SpouseTosiInEffect(RetNo, InfoFNo) then Tv[26]:= GetSpouseTosiNetIncome(retNo, InfoFNo);

    Tv[27]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, CalcPrvSpousalClaim(RetNo, SpouseIncome(RetNo)));
    Tv[28]:= Tv[27];

    if UpperCase(Strings[64]).Equals('Y') then Tv[28]:= Tv[65];

    //20101111
    Tv[76]:= PrvConstant[RY].PrvSpouseBasicAmount;
    Tv[77]:= Vl(FetchElm(RetNo, 'S5PRV', 8));
    Tv[78]:= MinR(PrvConstant[RY].PrvMaxSpousalAmount, MaxR(0, Tv[76] - Tv[77]));
    Tv[29]:= Vl(FetchElm(RetNo, 'S5PRV', 10));
    Tv[30]:= Vl(FetchElm(RetNo, 'S5PRV', 87));
    Strings[75]:= FetchElm(RetNo, 'NU428', 105);

    if not IsLowerIncomeSpouse(RetNo) then Strings[75]:='';

    Tv[73]:= Vl(Strings[75]) * 1200;
    Tv[81]:= Tv[23] + Tv[24] + Tv[28] + Tv[29] + Tv[30] + Tv[73];
    //Tv[81]:=Tv[23]+Tv[24]+Tv[28]+Tv[29];
    Tv[31]:= Ret[RetNo].Lnn[30800];
    Tv[32]:= Ret[RetNo].Lnn[31000];
    Tv[33]:= Ret[RetNo].Lnn[31200];
    Tv[79]:= Ret[RetNo].Lnn[31217];
    Tv[84]:= Tv[31] + Tv[32] + Tv[33] + Tv[79];
    Tv[85]:= Tv[84];
    Tv[86]:= Tv[81] + Tv[85];
    //Tv[29]:= Vl(FetchElm(RetNo,'S5PRV',10));

    //kids  20110116
    i:= 159;
    repeat
      if (Vl(Strings[i]) > 12) then Strings[i]:= '12';
      if (Ret[RetNo].Lnn[23600] > Vl(FetchElm(RetNo, 'INFO', 19))) and (ret[RetNo].MarStatus < 3) then Strings[i]:= '0';

      Inc(i, 4);
    until (i > 187);

    //Page 2
    Tv[83]:= Tv[86];
    Tv[34]:= GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//ret[RetNo].Lnn[31400];
    Tv[35]:= Vl(FetchElm(RetNo, 'S5PRV', 90));
    Tv[87]:= Tv[83] + Tv[34] + Tv[35];

    if (Ret[RetNo].Age >= 18) then
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 14))
    else
      Tv[36]:= Vl(FetchElm(RetNo, 'DISAB18', 24));

    Tv[37]:= GetPrvDisabXfer(RetNo);
    Tv[88]:= Tv[87] + Tv[36] + Tv[37];
    Tv[38]:= Ret[RetNo].Lnn[31900];
    Tv[39]:= Vl(FetchElm(RetNo, 'S11PRV', 21));
    Tv[40]:= GetPrvEducXfer(RetNo);
    Tv[41]:= Vl(FetchElm(RetNo, 'S2PRV', 19));
    Tv[82]:= Tv[88] + AddColumns(38, 41, 1) + Vl(FetchElm(RetNo, 'RC269', 10)) + Tv[79];
    Tv[42]:= Vl(FetchElm(RetNo, 'MEDICAL', 112));
    //20211115
    Tv[89]:= Ret[RetNo].Lnn[23600];
    Tv[90]:= 3;
    Tv[91]:= Tv[89] * Tv[90] / 100;
    Tv[92]:= MinR(Tv[91], PrvConstant[RY].PrvMedicalLimit);
    Tv[44]:= MaxR(0, Tv[42] - Tv[92]);
    Tv[45]:= Vl(FetchElm(RetNo, 'MEDPRV', 76));
    Tv[46]:= Tv[44] + Tv[45];
    Tv[47]:= Tv[46];
    Tv[49]:= Tv[82] + Tv[47] + GetLine51200FromRc269(RetNo); //jz//20260203 - ln 58800, add 51200FromRc269(RetNo);
    Tv[50]:= PrvConstant[RY].PrvNonRefundRate;
    //Tv[51]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate / 100;
    Tv[53]:= GetS9DonLow(RetNo); //Lnn[32005]; //20161126 Lnn[32005];ret[RetNo].Lnn[32005];
    Tv[54]:= PrvConstant[RY].PrvDonRate1;
    Tv[55]:= Tv[53] * Tv[54] / 100;
    Tv[56]:= GetS9DonHigh(RetNo); //20161126 Lnn[347];ret[RetNo].Lnn[347];
    Tv[57]:= PrvConstant[RY].PrvDonRate2;
    Tv[58]:= Tv[56] * Tv[57] / 100;
    Tv[59]:= Tv[55] + Tv[58];
    Tv[60]:= Tv[59];
    Tv[61]:= Tv[52] + Tv[60];

    //Page 3
    Tv[101]:= MaxR(MaxR(Tv[20], Tv[21]), MaxR(Tv[22], Tv[67]));

    if SplitIncome(RetNo) then
      Tv[102]:= GetTOSIPrvTax(RetNo) //Vl(FetchElm(RetNo,'T1206',103))
    else
      Tv[102]:= 0;

    Tv[103]:= Tv[101] + Tv[102];
    NormalPrvNonRefAmount:= Tv[61]; //Vl(FetchElm(RetNo,'NU428',61));
    if AllowSaSb(RetNo) then Tv[104]:= GetPrvNonRefundableBasedOnRuleOf90(RetNo,NormalPrvNonRefAmount) //20260503
        Else Tv[104]:=NormalPrvNonRefAmount; //20260514

    Tv[112]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[111]:= Ret[RetNo].Lnn[40427];
    Tv[107]:= Vl(FetchElm(RetNo, 'DTC', 9)); //Tv[5] * Tv[6]/100;
    Tv[113]:= Tv[111] * Tv[112] / 100;
    Tv[114]:= Tv[104] + Tv[107] + Tv[110] + Tv[113];
    Tv[115]:= Tv[114];
    Tv[116]:= MaxR(0, Tv[103] - Tv[115]);
    Tv[121]:= Vl(FetchElm(RetNo, 'T691', 316)); //20250222 AmountForPrvMinTax(RetNo); //Vl(FetchElm(RetNo,'T691',316));

    if IsDeceased(RetNo) then Tv[121]:= 0;

    Tv[122]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[117]:= Tv[121] * Tv[122] / 100;
    Tv[118]:= Tv[116] + Tv[117];

    if not Ret[RetNo].Province.Equals('NU') then
      Tv[119]:= 0
    else
      Tv[119]:= GetPrvForTaxCredit(RetNo, 'NU');

    Tv[51]:= MaxR(0, Tv[118] - Tv[119]);

    if (Tv[74] > FirefighterClaim) then Tv[74]:= FirefighterClaim;

    Tv[120]:= MaxR(0, Tv[51] - Tv[74]);
    Ret[RetNo].Lnn[42800]:= Tv[120];

    j:= 0;
    i:= 156;
    repeat
      if (Strings[i] > '') then Inc(j, 1);

      Inc(i, 4);
    until (i > 184);

    Strings[105]:= AllTrim(IntToStr(j));
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250918 Igor <<<

Procedure YT432(RetNo:integer;FName:string;FNo:integer);
var i,count: integer;x,y,z:real; s:String[30];
Begin
   If (CalcThisProvince(RetNo,'YT') = false)
   And (Vl(FetchElm(RetNo,'T2203',77))=0)  //inc from YT  //20230505 //And instead of Or on 20230513
   then
   Begin
    //20151219
    For i:=1 to 42 do begin Ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    Ret[Retno].Lnn[44100] := 0;
    Ret[Retno].Lnn[43200] := 0;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;
   LoadTv(RetNo,FName,FNo);
   with ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
     //moved ta Kwach
     Frm[FNo].Strings[14] := 'Champagne and Aishihik';
     Frm[FNo].Strings[15] :='11002';

     //moved  20161217
     Frm[FNo].Strings[41] := 'Kwanlin Dun';
     Frm[FNo].Strings[42] :='11004';

     Frm[FNo].Strings[17] := 'Little Salmon/Carmacks';
     Frm[FNo].Strings[18] :='11006';

     Frm[FNo].Strings[20] := 'Nacho Nyak Dun';
     Frm[FNo].Strings[21] :='11007';

     Frm[FNo].Strings[23] := 'Selkirk';
     Frm[FNo].Strings[24] :='11009';

     Frm[FNo].Strings[26] := 'Teslin Tlingit';
     Frm[FNo].Strings[27] :='11011';

     Frm[FNo].Strings[29] := 'Tr'+chr(39)+'ondek Hwech'+Chr(39)+'in';
     Frm[FNo].Strings[30] :='11012';

     Frm[FNo].Strings[32] := 'Vuntut Gwitchin';
     Frm[FNo].Strings[33] :='11013';

     Frm[FNo].Strings[35] := 'Carcross/Tagish';
     Frm[FNo].Strings[36] :='11001';

     Frm[FNo].Strings[38] := 'Kluane';
     Frm[FNo].Strings[39] :='11003';

     Frm[FNo].Strings[44] := 'Ta'+chr(39)+'an Kwach'+Chr(39)+'an';
     Frm[FNo].Strings[45] :='11010';


    // TV[51]:=95;
     Tv[3]:=95;  //default
     Tv[9]:=95;  //20180110
     //20090120
     If ItIsFirstNation(RetNo) then
     begin
      Tv[1]:=Vl(FetchElm(RetNo,'T1',147))*Tv[3]/100; //Basic Fed Tax (42900
          //Vl(FetchElm(RetNo,'S1',109))*Tv[3]/100; //used if min tax
      Tv[2] := Ret[RetNo].LNN[42900]; //20200101 Basic Fed Tax line 50 of t1 //[Vl(FetchElm(RetNo,'T1',147)); //Vl(FetchElm(RetNo,'S1',109));  //20190922 /
      If SubjectToMinTax(RetNo) then Tv[2]:=Vl(FetchElm(RetNo,'T691',208)); //20200109
      Tv[4] :=Tv[2]*Tv[3]/100;  //20191202
      Tv[5] := Tv[4];
      // 20230407  if IsMultJurisdiction(RetNo) then  Tv[5]:=Tv[5] * Vl(FetchElm(RetNo,'T2203',78))/100; //20180313  /%

      Tv[6] :=Vl(FetchElm(RetNo,'YT428',103));  //123  //20151123
      if IsMultJurisdiction(RetNo) then TV[6]:=Vl(FetchElm(RetNo,'YTMJ',91));  //20230507  //20180313
      //20230507 if IsMultJurisdiction(RetNo) then TV[6]:=Vl(FetchElm(RetNo,'YTMJ',144));  //20230507 //20180313
    //  Tv[7] :=Vl(FetchElm(RetNo,'YT479',4));  //20210101
    //  Tv[8] := MaxR(0,Tv[6] - Tv[7]);
      Tv[9] := 95;
      Tv[10] := Tv[6] * Tv[9] /100;
      Tv[11] := Tv[10];
      Tv[12] := Tv[5]+Tv[11];
     end
     else
     Begin  //20151219
      For i:=2 to 12 do Tv[i] :=0;
      Lnn[44100] := 0;
      Lnn[43200] := 0;
     end;
   Lnn[44100] := Tv[5];
   Lnn[43200] := Tv[12];
  End;
  SaveTv(RetNo,FName,FNo);
end;

   (* 2018 yt432
     Tv[3]:=95;  //default
     Tv[9] := 95;  //20180110
     //20090120
     If ItIsFirstNation(RetNo) then
     begin
      //Tv[3]:=95;  //default
      Tv[2] := Vl(FetchElm(RetNo,'S1',109));
      If SubjectToMinTax(RetNo) then Tv[2]:=Vl(FetchElm(RetNo,'T691',208));
      Tv[4] :=Tv[2]*Tv[3]/100;
      Tv[5] := Tv[4];

      if IsMultJurisdiction(RetNo) then  Tv[5]:=Tv[5] * Vl(FetchElm(RetNo,'T2203',78))/100; //20180313  /%
      Tv[1]:= Vl(FetchElm(RetNo,'S1',109))*Tv[3]/100;

      Tv[6] :=Vl(FetchElm(RetNo,'YT428',103));  //123  //20151123
      if IsMultJurisdiction(RetNo) then TV[6]:=Vl(FetchElm(RetNo,'YTMJ',144));  //20180313
      Tv[7] :=Vl(FetchElm(RetNo,'YT479',15));
      Tv[8] := MaxR(0,Tv[6] - Tv[7]);
     // Tv[9] := 95;
      Tv[10] := Tv[8] * Tv[9] /100;
      Tv[11] := Tv[10];
      Tv[12] := Tv[5]+Tv[11];
     end
     else
     Begin  //20151219
      For i:=2 to 12 do Tv[i] :=0;
      Ln[441] := 0;
      Ln[432] := 0;
     end;
     Ln[441] := Tv[5];
     Ln[432] := Tv[12];
    *)


//20181215 //NEW
//20251008 Igor >>>
procedure T1206(RetNo: Integer; FName: string; FNo: Integer);

  function GetHighTaxRate(RetNo: Integer; Prv: string): Real;  //20220422
  begin
    Result:= 0;

    if (Prv = 'AB') then result:= 15 else
    if (Prv = 'BC') then Result:= 20.5 else
    if (Prv = 'MB') then Result:= 17.4 else
    if (Prv = 'NB') then Result:= 19.5 else //20231212 17.4 //20.3 //20231127
    if (Prv = 'NL') then Result:= 21.8 else
    if (Prv = 'NS') then Result:= 21 else
    if (Prv = 'NT') then Result:= 14.05 else
    if (Prv = 'NU') then Result:= 11.5 else
    if (Prv = 'ON') then Result:= 20.53 else
    if (Prv = 'PE') then Result:= 19 else
    if (Prv = 'SK') then Result:= 14.5 else
    if (Prv = 'YT') then Result:= 15;
  end;

  function GetLowTaxRate(RetNo: Integer; Prv: string): string;  //20220422
  begin
    Result:= '';

    if (Prv = 'AB') then Result:= '8' else
    if (Prv = 'BC') then Result:= '5.06' else
    if (Prv = 'MB') then Result:= '10.80' else
    if (Prv = 'NB') then Result:= '9.4' else //'9.68'   //20220107
    if (Prv = 'NL') then Result:= '8.7' else
    if (Prv = 'NS') then Result:= '8.79' else
    if (Prv = 'NT') then Result:= '5.9' else
    if (Prv = 'NU') then Result:= '4' else
    if (Prv = 'ON') then Result:= '5.05' else //'5.06'
    if (Prv = 'PE') then Result:= '9.5' else
    if (Prv = 'SK') then Result:= '10.50' else
    if (Prv = 'YT') then Result:= '6.4';
  end;

  function GetEligDivRate(RetNo: Integer; Prv: string): string;  //20220422
  begin
    Result:= '';

    if (Prv = 'AB') then Result:= '8.12' else
    if (Prv = 'BC') then Result:= '12' else
    if (Prv = 'MB') then Result:= '8' else
    if (Prv = 'NB') then Result:= '14' else //'9.68'   //20220107
    if (Prv = 'NL') then Result:= '6.3' else
    if (Prv = 'NS') then Result:= '8.85' else
    if (Prv = 'NT') then Result:= '11.5' else
    if (Prv = 'NU') then Result:= '5.51' else
    if (Prv = 'ON') then Result:= '10' else //'5.06'
    if (Prv = 'PE') then Result:= '10.5' else
    if (Prv = 'SK') then Result:= '11' else
    if (Prv = 'YT') then Result:= '12.02';
  end;

  function GetNONEligDivRate(RetNo: Integer; Prv: string): string;  //20220422
  begin
    Result:= '';

    if (Prv = 'AB') then Result:= '2.18' else
    if (Prv = 'BC') then Result:= '1.96' else
    if (Prv = 'MB') then Result:= '0.7835' else
    if (Prv = 'NB') then Result:= '2.75' else //'9.68'   //20220107
    if (Prv = 'NL') then Result:= '3.2' else
    if (Prv = 'NS') then Result:= '1.50' else
    if (Prv = 'NT') then Result:= '6' else
    if (Prv = 'NU') then Result:= '2.61' else
    if (Prv = 'ON') then Result:= '2.9863' else
    if (Prv = 'PE') then Result:= '1.30' else //20221212
    if (Prv = 'SK') then Result:= '2.519' else //'1.695'   //20221212
    if (Prv = 'YT') then Result:= '0.67';
  End;

  function GetT2203AllocRate(RetNo: Integer; Prv: string): string; //20220422
  var
    T2203FNo: Integer;
  begin
    T2203FNo:= GetForMNo('T2203');
    Result:= '';

    if (Prv = 'NL') then Result:= FetchElmFNo(RetNo, T2203FNo, 8) else
    if (Prv = 'PE') then Result:= FetchElmFNo(RetNo, T2203FNo, 15) else
    if (Prv = 'NS') then Result:= FetchElmFNo(RetNo, T2203FNo, 22) else
    if (Prv = 'NB') then Result:= FetchElmFNo(RetNo, T2203FNo, 29) else
    if (Prv = 'QC') then Result:= FetchElmFNo(RetNo, T2203FNo, 36) else
    if (Prv = 'ON') then Result:= FetchElmFNo(RetNo, T2203FNo, 43) else
    if (Prv = 'MB') then Result:= FetchElmFNo(RetNo, T2203FNo, 50) else
    if (Prv = 'SK') then Result:= FetchElmFNo(RetNo, T2203FNo, 57) else
    if (Prv = 'AB') then Result:= FetchElmFNo(RetNo, T2203FNo, 64) else
    if (Prv = 'BC') then Result:= FetchElmFNo(RetNo, T2203FNo, 71) else
    if (Prv = 'YT') then Result:= FetchElmFNo(RetNo, T2203FNo, 78) else
    if (Prv = 'NT') then Result:= FetchElmFNo(RetNo, T2203FNo, 85) else
    if (Prv = 'NU') then Result:= FetchElmFNo(RetNo, T2203FNo, 106) else
    if (Prv = 'ZZ') then Result:= FetchElmFNo(RetNo, T2203FNo, 92);
  end;

var
  i: Integer;
  BfrJuly: Real;
  T2203FNo: Integer;//Prv:String;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    if Strings[16].Equals('') then Strings[16]:= 'N';
    if (UpperCase(Strings[16]) = 'N') or (ret[RetNo].Province = 'ZZ') then
    begin
      for i:= 1 to 115 do Tv[i]:= 0;

      Strings[16]:= 'N';  //20150430
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    T2203FNo:= GetFormNo('T2203');

    //Page 1
    if (Tv[36] > 0) then Tv[37]:= Tv[34] * Tv[35] / Tv[36] else Tv[37]:= 0;
    Tv[24]:= Tv[34];
    if (Tv[36] > 0) then Tv[37]:= Tv[34] * Tv[35] / Tv[36] else Tv[37]:= 0;
    if (Tv[24] > 0) and (Tv[38] = 0) then Tv[38]:= 80;
    if (Tv[38] > 100) then Tv[38]:= 0;

    Tv[39]:= Tv[24] * Tv[38] / 100;
    Tv[30]:= MinR(Tv[37], Tv[39]);
    Tv[32]:= Tv[31] - Tv[30];
    Tv[33]:= Tv[32];
    Tv[28]:= Tv[29] + Tv[33];
    Tv[26]:= Tv[28] + Tv[27];

    //Page 2
    Tv[3]:= Tv[1] + Tv[2];
    Tv[51]:= selectNetIncomeAmount(RetNo); //jz//20250221  //Tv[51]:=Ret[RetNo].Lnn[23600];
    Tv[4]:= Tv[3] + Tv[51]; //Tv[3] * 33/100;

    //Page 3
    Tv[42]:= Tv[3];  //20181216
    Tv[52]:= Tv[42] * 0.33;   //20181215
    Tv[44]:= Tv[52];
    Tv[43]:= Tv[44] / 0.145;
    Tv[140]:= Ret[RetNo].LNN[41500];  //20231205
    Tv[141]:= Tv[52] + Tv[140];  //Tv[52]+Tv[9];          //20231209
    Tv[40]:= Ret[RetNo].Lnn[31600];
    Tv[53]:= Ret[RetNo].Lnn[31800];
    Tv[54]:= Tv[40] + Tv[53];
    Tv[45]:= Tv[54] * 0.145;
    Tv[41]:= Tv[45];
    Tv[55]:= MaxR(0, Tv[141] - Tv[41]); //20231205 //MaxR(0,Tv[52]-Tv[41]);
    Tv[56]:= Tv[1];
    Tv[57]:= Tv[17];
    Tv[46]:= (Tv[57]* 9.0301) / 100;  //10.0313)/100;
    Tv[58]:= MaxR(0, Tv[56] - Tv[57]);
    Tv[47]:= (Tv[58] * 15.0198) / 100;
    Tv[59]:= Tv[46] + Tv[47];
    Tv[60]:= Tv[59];
    Tv[61]:= MaxR(0, Tv[55] - Tv[60]);
    Tv[15]:= Ret[RetNo].Lnn[40500]; //Vl(FetchElm(RetNo,'T1',82));; //Ret[RetNo].Lnn[40500]; //20191202 //Vl(FetchElm(RetNo,'T1',182)); //ln 405 //Vl(FetchElm(RetNo,'S1',117)); //ln 405

    if (Tv[14] > 0) then Tv[7]:= (Tv[13] * Tv[15]) / Tv[14] else Tv[7]:= 0;

    Tv[8]:= MaxR(0, Tv[61] - Tv[7]);
    Tv[9]:= Ret[RetNo].Lnn[40600];
    Tv[10]:= Ret[RetNo].Lnn[41600];  //20191010 416
    Tv[11]:= MaxR(0, Tv[9] - Tv[10]);
    Tv[62]:= Ret[RetNo].Lnn[41500];
    Tv[63]:= Tv[11] + Tv[62];
    Tv[12]:= MaxR(Tv[8], Tv[63]);

    //Page 4
    if not IsMultJurisdiction(RetNo) then  //20220421
    begin
      //clear the MJ case
      Tv[5]:= 0;
      Tv[6]:= 0;
      for i:= 18 to 23 do Tv[i]:= 0;
      Tv[25]:= 0;
      Tv[49]:= 0;

      for i:= 81 to 139 do Tv[i]:= 0;

      Tv[101]:= Tv[3]; //Vl(FetchElm(RetNo,'T1206',3));
      Tv[102]:= GetHighTaxRate(RetNo,ret[RetNo].Province); //20220422
      Tv[103]:= Tv[101] * Tv[102] / 100;
      Tv[48]:= Tv[103];

      if (Ret[RetNo].Province = 'ON') then Tv[114]:= Vl(FetchElm(RetNo, 'ON428', 122)); //20181227 did not work

      //20220422
      Strings[50]:= GetLowTaxRate(RetNo, Ret[RetNo].Province);

      if (Vl(Strings[50]) > 0) then Tv[64]:= Tv[48] / (Vl(Strings[50]) / 100) else Tv[64]:= 0; //??? where to use above ratye?

      Tv[104]:= MaxR(Vl(FetchElm(RetNo, 'DISAB18', 14)), Vl(FetchElm(RetNo, 'DISAB18', 24)));  //Prov Disab tax credit

      if (Ret[RetNo].Province = 'YT') then Tv[104]:= Vl(FetchElm(RetNo, 'YT428', 36)); //20231209

      Tv[65]:= MaxR(Vl(FetchElm(RetNo, 'PTRANSF', 71)), Vl(FetchElm(RetNo, 'PTRANSF', 4))); //5858 disab xfer  //20181225 whichever is present
      Tv[66]:= Tv[104] + Tv[65];
      Strings[105]:= Strings[50];
      Tv[107]:= Tv[66] * Vl(Strings[105]) / 100;
      Tv[67]:= Tv[107];
      Tv[68]:= MaxR(0, Tv[103] - Tv[67]);
      Tv[69]:= Tv[58];
      Strings[70]:= GetEligDivRate(RetNo, Ret[RetNo].Province);
      Tv[71]:= Tv[69] * Vl(Strings[70]) / 100;
      Tv[72]:= Tv[71];
      Tv[73]:= Tv[57];
      Strings[74]:= GetNonEligDivRate(RetNo, Ret[RetNo].Province);  //20220422
      Tv[75]:= Tv[73] * (Vl(Strings[74]) / 100);
      Tv[76]:= Tv[75];
      Tv[77]:= Tv[72] + Tv[76];
      Tv[78]:= Tv[77];
      Tv[79]:= MaxR(0, Tv[68] - Tv[78]);
      Tv[80]:= Tv[79];
      Tv[109]:= Tv[13];
      Tv[110]:= Tv[14];
      Tv[111]:= 0;
      Tv[111]:= GetPrvForTaxCredit(RetNo, Ret[RetNo].Province);

      if (Tv[110] > 0) then Tv[112]:= (Tv[109] * Tv[111]) / Tv[110] else Tv[112]:= 0;

      Tv[113]:= MaxR(0, Tv[80] - Tv[112]); //20200208
      Tv[114]:= Ret[RetNo].Lnn[42800];  //prvtax

      if (Ret[RetNo].Province = 'ON') then Tv[114]:= Vl(FetchElm(RetNo, 'ON428', 174)); //20220120

      Tv[115]:= MaxR(Tv[113], Tv[114]);
    end;

    //MJ pages  //20220421
    if IsMultJurisdiction(RetNo) then
    begin
      //clear the plain T1206
      Tv[48]:= 0;
      Tv[64]:= 0;
      Tv[65]:= 0;
      Tv[66]:= 0;
      Tv[107]:= 0;
      Tv[80]:= 0;

      for i:= 65 to 79 do Tv[i]:= 0;
      for i:= 101 to 105 do Tv[i]:= 0;
      for i:= 109 to 115 do Tv[i]:= 0;

      Tv[5]:= Tv[3];
      //20220422
      Tv[6]:=GetHighTaxRate(RetNo,ret[RetNo].Province);  //col 2 of chart high ax rate
      Tv[18]:=Tv[5] * Tv[6]/100;
      //% allocation
      if ((Ret[retno].province = 'AB') or (Ret[retno].province = 'ON')) then //  or (Ret[retno].province='MB')  //20230507
        Tv[19]:= 100
      else
      if (Ret[retno].province = 'NL') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 8)) else
      if (Ret[retno].province = 'PE') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 15)) else
      if (Ret[retno].province = 'NS') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 22)) else
      if (Ret[retno].province = 'NB') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 31)) else
      if (Ret[retno].province = 'QC') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 38)) else
      if (Ret[retno].province = 'MB') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 50)) else
      if (Ret[retno].province = 'SK') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 59)) else
      if (Ret[retno].province = 'AB') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 64)) else
      if (Ret[retno].province = 'BC') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 71)) else
      if (Ret[retno].province = 'YT') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 78)) else
      if (Ret[retno].province = 'NU') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 106)) else
      if (Ret[retno].province = 'ZZ') then Tv[19]:= Vl(FetchElmFNo(RetNo, T2203FNo, 92));

      Tv[20]:= Tv[18] * TV[19] / 100;
      Tv[21]:= Tv[20];
      Tv[22]:= Tv[21];
      Ret[RetNo].Frm[FNo].Strings[23]:=GetLowTaxRate(RetNo,ret[RetNo].Province);

      if (Vl(Ret[RetNo].Frm[FNo].Strings[23]) > 0) then Tv[25]:= (Tv[22] / Vl(Ret[RetNo].Frm[FNo].Strings[23])) * 100 else Tv[25]:= 0;
      //Instructions here to folow?
      //Tv[49]:= ???
      Tv[81]:= Vl(FetchElm(RetNo, 'T2203', 613)); //]RetT22033Ret[RetNo].Lnn[31800];  //202405111
      Tv[82]:= Tv[49] + Tv[81];
      Ret[RetNo].Frm[FNo].Strings[83]:= GetLowTaxRate(RetNo, Ret[Retno].Province);
      Tv[84]:= Tv[82] * Vl(Strings[83]) / 100;
      Strings[85]:= GetT2203AllocRate(RetNo, Ret[Retno].Province);
      Tv[86]:= Tv[84] * vl(Strings[85]) / 100;
      Tv[87]:= Tv[86];
      Tv[88]:= MaxR(0, Tv[21] - Tv[87]);
      Tv[89]:= Tv[58];
      Ret[RetNo].Frm[FNo].Strings[90]:= GetEligDivRate(RetNo, Ret[retno].province);
      Tv[91]:= Tv[89] * Vl(Ret[RetNo].Frm[FNo].Strings[90]) / 100;
      Tv[92]:= Tv[91];
      Tv[93]:= Tv[57]; //Tv[58];    //20230508
      Ret[RetNo].Frm[FNo].Strings[94]:= GetNonEligDivRate(RetNo, Ret[retno].province);
      Tv[95]:= Tv[93] * Vl(Ret[RetNo].Frm[FNo].Strings[94]) / 100;
      Tv[96]:= Tv[95];
      Tv[97]:= Tv[92] + Tv[96];
      Tv[98]:= Tv[97];
      Tv[99]:= MaxR(0, Tv[88] - Tv[98]);

      if (Tv[106] > 0) then Tv[116]:= (Tv[100] / Tv[106]) * Tv[108] else Tv[116]:= 0;

      Tv[117]:= MaxR(0, Tv[99] - Tv[116]);
      //Tv[118]:=??
      Tv[119]:= MaxR(Tv[117], Tv[118]);
      //instr of use //not BC
      if not Ret[RetNo].Province.Equals('BC') then
      begin
        //qualifiers
        Tv[120]:= Tv[3];
        Tv[121]:= Tv[6];
        Tv[122]:= Tv[120] * Tv[121] / 100;
        Ret[RetNo].Frm[FNo].Strings[123]:= FetchElmFNo(RetNo, T2203FNo, 71);
        Tv[124]:= Tv[122] * (Vl(Ret[RetNo].Frm[FNo].Strings[123])) / 100;
        Tv[125]:= Tv[124];
        Tv[126]:= Tv[125];
        //Tv[127]:=??

        if (Tv[127] > 0) then Tv[128]:= (Tv[126] / Tv[127]) * 100;

        //Tv[129]:=??
        //Tv[130]:=??
        Tv[131]:= Tv[129] + Tv[130];
        //Tv[132]:=//
        Tv[133]:= (Tv[131] * Tv[132]) / 100;
        Ret[RetNo].Frm[FNo].Strings[134]:= Ret[RetNo].Frm[FNo].Strings[123];
        Tv[135]:= (Tv[133] * Vl(Ret[RetNo].Frm[FNo].Strings[134])) / 100;
        Tv[136]:= Tv[135];
        Tv[137]:= MaxR(0, Tv[125] - Tv[136]);
        //Tv[138]:=??
        Tv[139]:= MaxR(Tv[137], Tv[138]);
      end else
        for i:= 120 to 139 do Tv[i]:= 0;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<

procedure T1285(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[FNo] do
 Begin
  If CalcThisProvince(RetNo,'NS') = False then
  begin
    For i:=1 to 15 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
  end;
  Strings[16]:=AppYear;
  Tv[3]:=Tv[1]+Tv[2];
  Tv[4]:=MinR(17500,Tv[3]);
  Tv[5]:=Vl(FetchElm(RetNo,'NS428',153)); //20141116 //Vl(FetchElm(RetNo,'NS428',155));  //20120320 //Vl(FetchElm(RetNo,'NS428',165)); //Vl(FetchElm(RetNo,'NS428',155));  //20120320

  Tv[6]:=MinR(Tv[4],Tv[5]);
  Tv[7]:=Tv[3];
  Tv[8]:=Tv[6];
  Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
  Tv[13]:=Tv[10]+Tv[11]+Tv[12];
  Tv[14]:=Tv[13];
  Tv[15]:=MaxR(0,Tv[9]-Tv[14]);
  If Strings[17]='' then Strings[17]:= FormatDateTime('yyyy-mm-dd',Date);
 end;
 SaveTv(RetNo,FName,FNo);
end;

//20251008 Igor >>>
procedure T1159(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  s: string;
  Pg4FNo: Integer;
  TxblInc: Real;
begin
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //20250421
    if not IsSection216(RetNo) and (FetchElmFNo(RetNo, InfoFNo, 239) = '') then  //20250422
    begin
      for i:= 1 to 49 do
      begin
        Strings[i]:= '';
        Tv[i]:= 0;
      end;

      SaveTv(RetNo, FName, FNo);
      Exit;
    end;

    //address etc.
    //For i:=2 to 40 do Strings[i] := FetchElmFNo(RetNo,INFOFNo,i);
    //left column  //20240610
    Strings[2]:= FetchElmFNo(RetNo, INFOFNo, 2);
    Strings[5]:= FetchElmFNo(RetNo, INFOFNo, 5);
    Strings[22]:= FetchElmFNo(RetNo, INFOFNo, 22);
    Strings[6]:= FetchElmFNo(RetNo, INFOFNo, 6);
    Strings[49]:= FetchElmFNo(RetNo, INFOFNo, 68);
    Strings[163]:= FetchElmFNo(RetNo, INFOFNo, 163);
    Strings[10]:= FetchElmFNo(RetNo, INFOFNo, 10);
    Strings[14]:= FetchElmFNo(RetNo, INFOFNo, 14);
    Strings[15]:= FetchElmFNo(RetNo, INFOFNo, 15);
    Strings[47]:= FetchElmFNo(RetNo, INFOFNo, 69); //diff nr info
    Strings[36]:= FetchElmFNo(RetNo, INFOFNo, 64);  //diff
    Strings[3]:= FetchElmFNo(RetNo, INFOFNo, 3);
    Strings[9]:= FetchElmFNo(RetNo, INFOFNo, 9);
    Strings[24]:= FetchElmFNo(RetNo, INFOFNo, 24);
    Strings[34]:= FetchElmFNo(RetNo, INFOFNo, 34);
    Strings[35]:= FetchElmFNo(RetNo, INFOFNo, 35);

    if Strings[17].Equals('') then Strings[17]:= FormatDateTime('yyyy-mm-dd', Now); //20240610

    Strings[46]:= FetchElmFNo(RetNo, INFOFNo, 33); //title
    // Strings[49]:= FetchElmFNo(RetNo,INFOFNo,68);
    Strings[163]:= FetchElmFNo(RetNo, INFOFNo, 163);
    {dd}
    Pg4FNo:= GetFormNo('T1');
    Strings[18]:= FetchElmFNo(RetNo, Pg4FNo, 407);
    Strings[19]:= FetchElmFNo(RetNo, Pg4FNo, 408);
    {Teleph}
    Strings[13]:= FetchElmFNo(RetNo, Pg4FNo, 441);
    Strings[16]:= FetchElmFNo(RetNo, Pg4FNo, 442);
    // Strings[17]:= FetchElmFNo(RetNo,Pg4FNo,443);

    //tax preparer //20190310
    if (FetchElmFNo(RetNo, InfoFNo, 100) > '') then  //fees paid
    begin
      Strings[11]:= OptRec.Prp_Name; // FetchElmFNo(RetNo,Pg4FNo,435);   //437 //20190310
      Strings[44]:= OptRec.Prp_Area; //FetchElmFNo(RetNo,Pg4FNo,439);
      Strings[45]:= OptRec.Prp_Tel;//FetchElmFNo(RetNo,Pg4FNo,440);
    end else
    begin
      Strings[11]:= '';
      Strings[44]:= '';
      Strings[45]:= '';
    end;

    Tv[1]:= Lnn[12599];
    Tv[7]:= Lnn[12600];
    Tv[21]:= Tv[7];
    Tv[23]:= Lnn[20800];
    Tv[25]:= Lnn[21999];
    Tv[26]:= Lnn[22000];
    Tv[27]:= Lnn[23200];
    Tv[29]:= Tv[23] + Tv[4] + Tv[26] + Tv[27]; //20240129
    Tv[30]:= Tv[29];
    Tv[37]:= MaxR(0, Tv[21] - Tv[30]);

    if not IsSection216(RetNo) then
    begin
      for i:= 102 to 135 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;
      for i:= 56 to 62 do
      begin
        Frm[FNo].Strings[i]:= '';
        Tv[i]:= 0;
      end;

      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    TxblInc:= MaxR(0, Tv[37]);
    for i:= 102 to 122 do
    begin
      Frm[FNo].Strings[i]:= '';
      Tv[i]:= 0;
    end;
    for i:= 123 to 129 do
    begin
      Frm[FNo].Strings[i]:= '';
      Tv[i]:= 0;
    end;
    for i:= 56 to 62 do
    begin
      Frm[FNo].Strings[i]:= '';
      Tv[i]:= 0;
    end;

    if (TxblInc <= Constant[RY].Bracket1) then
    begin
      Tv[102]:= TxblInc;
      Tv[105]:= 0;
      Tv[108]:= MaxR(0, Tv[102] - Tv[105]);
      Frm[FNo].Strings[111]:= Constant[RY].Rate1;
      Tv[114]:= Tv[108] * Vl(Frm[FNo].Strings[111]) / 100;
      Tv[117]:= 0;
      Tv[120]:= Tv[114] + Tv[117];
     end;

    if (TxblInc > Constant[RY].Bracket1) and (TxblInc <= Constant[RY].Bracket2) then
    begin
      Tv[103]:= TxblInc;
      Tv[106]:= Constant[RY].Bracket1;
      Tv[109]:= MaxR(0, Tv[103] - Tv[106]);
      Frm[FNo].Strings[112]:= Constant[RY].Rate2;
      Tv[115]:= Tv[109] * Vl(Frm[FNo].Strings[112]) / 100;
      Tv[118]:= Constant[RY].BracketTax2;
      Tv[121]:= Tv[115] + Tv[118];
    end;

    if (TxblInc > Constant[RY].Bracket2) and (TxblInc <=Constant[RY].Bracket3) then
    begin
      Tv[104]:= TxblInc;
      Tv[107]:= Constant[RY].Bracket2;
      Tv[110]:= MaxR(0, Tv[104] - Tv[107]);
      Frm[FNo].Strings[113]:= Constant[RY].Rate3;
      Tv[116]:= Tv[110] * Vl(Frm[FNo].Strings[113]) / 100;
      Tv[119]:= Constant[RY].BracketTax3;
      Tv[122]:= Tv[116] + Tv[119];
    end;

    if (TxblInc > Constant[RY].Bracket3) and (TxblInc <= Constant[RY].Bracket4) then
    begin
      Tv[123]:= TxblInc;
      Tv[124]:= Constant[RY].Bracket3;
      Tv[125]:= MaxR(0, Tv[123] - Tv[124]);
      Frm[FNo].Strings[126]:= Constant[RY].Rate4;
      Tv[127]:= Tv[125] * Vl(Frm[FNo].Strings[126]) / 100;
      Tv[128]:= Constant[RY].BracketTax4;
      Tv[129]:= Tv[127] + Tv[128];
    end;

    if (TxblInc > Constant[RY].Bracket4) then
    begin
      Tv[56]:= TxblInc;
      Tv[57]:= Constant[RY].Bracket4;
      Tv[58]:= MaxR(0, Tv[56] - Tv[57]);
      Frm[FNo].Strings[59]:= Constant[RY].Rate5;
      Tv[60]:= Tv[58] * Vl(Frm[FNo].Strings[59]) / 100;
      Tv[61]:= Constant[RY].BracketTax5;
      Tv[62]:= Tv[60] + Tv[61];
    end;

    Tv[130]:= MaxR(MaxR(Tv[120], Tv[121]), MaxR(Tv[122], Tv[129]));
    Tv[130]:= MaxR(Tv[130], Tv[62]);  //20170127
    Tv[131]:= Lnn[40427];
    Tv[132]:= MaxR(0, Tv[130] - Tv[131]);
    Tv[133]:= Tv[132];
    Tv[134]:= Tv[133] * 0.48;
    Tv[135]:= Tv[132] + Tv[134];
    Tv[38]:= Tv[135];
   // Tv[20]:=Vl(FetchElm(RetNo,'T2039',67));  //  20240104
    Tv[32]:= Tv[39] + Tv[31]; //20221216
    Tv[33]:= Tv[32];
    Tv[40]:= Tv[38] - Tv[33];

    if (Tv[40] > 0) then
    begin
     Tv[41]:= 0;
     Tv[42]:= Tv[40];
    end else
    begin
      Tv[41]:= ABS(Tv[40]);
      Tv[42]:= 0;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<

procedure NT479(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;x:Real;SpRetNo:Integer;
begin
  If CalcThisProvince(RetNo,'NT') = False then
  begin
   For i:=1 to 32 do begin ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   ret[RetNo].Frm[FNo].Strings[24]:='N';
   ret[RetNo].Frm[FNo].Strings[26]:='N';
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  LoadTv(RetNo,FName,FNo);
  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    ////20260503  If UpperCase(Frm[FNo].Strings[26])='N' then Frm[FNo].Strings[26]:='Y'; //20210417
     //If Frm[FNo].Strings[26]='' then Frm[FNo].Strings[26]:='Y';

    if Strings[26]='Y' then
    begin
     Tv[7] := Lnn[23600];
     Tv[8] := Lnn[24400]+Lnn[25000];
     Tv[9] := MaxR(0,Tv[7]-Tv[8]);
     Tv[10] := Vl(FetchElm(RetNo,'OTHDED',22)); //ret[RetNo].Lnn[25600];
     Tv[11] := MaxR(0,Tv[9] - Tv[10]);
    end;

    //6250
    for i:=33 to 39 do Tv[i]:=0;
    for i:=43 to 49 do Tv[i]:=0;
    for i:=53 to 59 do Tv[i]:=0;

    x:=Tv[11];
   if x>66000 then
     Tv[12]:=942
   Else
   Begin
    If x <= 12000 then
    Begin
      Tv[33]:=x;
      Tv[34]:=0;
      Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      Tv[36]:=2.6;
      Tv[37]:=Tv[35]*Tv[36]/100;
      Tv[38]:=0;
      Tv[39]:=Tv[37]+Tv[38];
    end
    Else if ((x >= 12000.01) AND (x <= 48000.00)) then
     Begin
      Tv[43]:=x;
      Tv[44]:=12000;
      Tv[45]:=MaxR(0,Tv[43]-Tv[44]);
      Tv[46]:=1.25;
      Tv[47]:=Tv[45]*Tv[46]/100;
      Tv[48]:=312;
      Tv[49]:=Tv[47]+Tv[48];
     End
    Else if (x >= 48000.01) then
     Begin
      Tv[53]:=x;
      Tv[54]:=48000;
      Tv[55]:=MaxR(0,Tv[53]-Tv[54]);
      Tv[56]:=1;
      Tv[57]:=Tv[55]*Tv[56]/100;
      Tv[58]:=762;
      Tv[59]:=Tv[57]+Tv[58];
     end;
    Tv[12]:=MaxR(Tv[39],MaxR(Tv[49],Tv[59]));
    end;
    if Tv[12]>942 then Tv[12]:=942;

    If UpperCase(Frm[FNo].Strings[26]) <> 'Y' then for i:=7 to 12 do Tv[i]:=0;
    If (IsPrebankruptcyReturn(RetNo)) then Tv[12]:=0;
    {//20260503
    If Frm[FNo].Strings[24]='' then
    begin
      If Ret[RetNo].Age >=18 then
       Frm[FNo].Strings[24]:='Y'
      else
       Frm[FNo].Strings[24]:='N';
    end;
    }
    If Ret[RetNo].Age <18 then Frm[FNo].Strings[24]:='N';
    If ret[RetNo].Province <> 'NT' then Frm[FNo].Strings[24]:='N';

    If UpperCase(Frm[FNo].Strings[24]) = 'Y' then
    begin
      Tv[3]:=350;
      If Ret[RetNo].MarStatus <3 then
       Tv[4]:=350
      else
       Tv[4]:=0;
      If (IsPrebankruptcyReturn(RetNo)) then Tv[4]:=0;
      Tv[5]:=Tv[3]+Tv[4];
      Tv[6]:=Tv[5];
      Tv[17]:=Tv[12];
      SpRetNo :=GetSpRetNo(RetNo);
      If (CouplingSw) and (SpRetNo >0) then
      begin
       Tv[18]:=Vl(FetchElmfNo(SpRetNo,FNo,12));
      end;
      If (IsPrebankruptcyReturn(RetNo)) then Tv[18]:=0;
      Tv[19]:=Tv[17]+Tv[18];
      Tv[20]:=Tv[19];
      Tv[21]:=MaxR(0,Tv[6]-Tv[20]);
      If (IsPrebankruptcyReturn(RetNo)) then Tv[21]:=0;

      Tv[22]:=Tv[21];
    end
    else
    begin
     For i:=3 to 6 do Tv[i]:=0;
     For i:=17 to 22 do Tv[i]:=0;
    end; //nt

    Tv[32]:=MinR(942,Tv[12]+Tv[22]);
    If (IsPrebankruptcyReturn(RetNo)) then Tv[32]:=0;
    Lnn[47900] := Tv[32];
   end; //with
  SaveTv(RetNo,FName,FNo);
end;

procedure NU479(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'NU') = False then
  begin
   For i:=1 to 34 do begin ret[RetNo].Frm[FNo].Strings[i]:='';Ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
        Tv[7] := Lnn[23600];
        if IsMultJurisdiction(RetNo) then Tv[7]:=Vl(FetchElm(RetNo,'T2203',105)); //20170514
        Tv[8] := Lnn[24400]+Lnn[25000];
        Tv[9] := MaxR(0,Tv[7]-Tv[8]);
        Tv[10] := Vl(FetchElm(RetNo,'OTHDED',22));  {exempt}
        If (IsPrebankruptcyReturn(RetNo)) then Tv[10]:=0;
        Tv[11] := MaxR(0,Tv[9]-Tv[10]);

        Tv[3]:=Tv[11];
        Tv[4]:=2;
        Tv[5]:=MinR(1500,Tv[3]*Tv[4]/100); //20190922
        Tv[6]:=Tv[5];


        //20110412
        If Frm[FNo].Strings[23]='' then Frm[FNo].Strings[23]:='N';
        If ret[RetNo].MarStatus <3 then Frm[FNo].Strings[23]:='N';
        If TV[11]<75000.01 then Frm[FNo].Strings[23]:='N';  //20190922

        (*
        If ((ret[RetNo].MarStatus = 6) and (TV[11]>60000)) then
           Frm[FNo].Strings[23]:='Y'
        Else
           Frm[FNo].Strings[23]:='N';
        *)
        If UpperCase(Frm[FNo].Strings[23])='Y' then
        begin
         Tv[17]:=Tv[11];
         Tv[18]:=75000;  //20190922
         Tv[19]:=MaxR(0,Tv[17]-Tv[18]);
         Tv[20]:=2;
         Tv[21]:=MinR(255.12,Tv[19]*Tv[20]/100);
         If (IsPrebankruptcyReturn(RetNo)) then Tv[21]:=0;
         Tv[22]:=Tv[21];
        end
        else
         for i:=17 to 22 do Tv[i]:=0;
        If Tv[11]<=60000 then for i:=17 to 22 do Tv[i]:=0;

        Tv[12] :=Tv[6]+Tv[22]; //CalcNuCola(Tv[11]);
        If (IsPrebankruptcyReturn(RetNo)) then Tv[12]:=0;
        {Polit}
        Tv[13] := GetPrvPolit(RetNo,'NU');
        Tv[14] := CalcNuPolit(Tv[13]);
        Tv[15]:=Vl(FetchElm(RetNo,'NU428',120));
        Tv[1] := Tv[12];
	      Tv[2] := MaxR(0,Tv[15]-Tv[1]);
        Tv[16] := MinR(Tv[14],Tv[2]);

       //Polit Contr //20190117
        Tv[24]:=Tv[13];
        Tv[25]:=100;
        Tv[26]:=MaxR(0,Tv[24]-Tv[25]);
        Tv[27]:=50;
        Tv[28]:=Tv[26]*Tv[27]/100;
        Tv[29]:=100;
        Tv[30]:=MinR(500,Tv[28]+Tv[29]);
        //----------------------
        Tv[34] := Tv[12]+Tv[16]; //+Tv[24];  //20151114
        Lnn[47900] := Tv[34];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure DIAGNO(RetNo: integer; FName: String;FNo: integer);
Var i,j:Integer;Err:String;
begin
  LoadTv(RetNo,FName,FNo);
 // Ret[RetNo].AuditList.Sorted:=True;
  with ret[RetNo].Frm[FNo] do
  begin
   For i:=1 to 196 do Strings[i]:=''; //clear
   Strings[1]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[2]:=AppYear;
   If ShowUnconvertedLastYear(RetNo) then Strings[2]:=GetLastYearTaxYear;
   Strings[4]:=GetSinNo(RetNo);
  // If Ret[RetNo].AuditList.count=0 then exit;
   //If Length(Ret[RetNo].AuditRec)=0 then exit;
   {$IFDEF oldAudit} //20160119 Igor
   If Length(Ret[RetNo].AuditRec)=0 then exit;
   {$ELSE}
   If Ret[RetNo].AuditList.count=0 then exit;
   {$ENDIF}
   i:=5;
   Repeat
    //For j:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do //20130209 //20160119 Igor
    Begin
     Err:=Ret[RetNo].AuditRec[j].Category;
     If Err='M' then Err:='Mandatory'
     Else If Err='E' then Err:='Error'
     else If Err='W' then Err:='Warning'
     else If Err='T' then Err:='Tip'
     else If Err='F' then Err:='Efile'
     else If Err='S' then Err:='SuprAudit'
     else If Err='D' then Err:='AddingTape'
     else If Err='N' then Err:='Note'
     else If Err='0' then Err:='Signed off'  //20130209
     else If Err='R' then Err:='Review';

     Strings[i]:=Err;
     Strings[i+1]:=Ret[RetNo].AuditRec[j].Description;
     Strings[i+2]:=Ret[RetNo].AuditRec[j].Form;
     Strings[i+3]:=IntToStr(Ret[RetNo].AuditRec[j].Elm);
     Inc(i,4);
    end;
    Inc(j,1);
   //until (i>193) or (j>High(Ret[RetNo].AuditRec));
   until (i>193) or (j>=Ret[RetNo].AuditList.Count); //20160119 Igor
   (*

   i:=5;j:=0;
   Repeat
    Err:=LeftStr(Ret[RetNo].AuditList[j],1);
    If Err='M' then Err:='Mandatory'
    Else If Err='E' then Err:='Error'
    else If Err='W' then Err:='Warning'
    else If Err='T' then Err:='Tip'
    else If Err='F' then Err:='Efile'
    else If Err='S' then Err:='SuprAudit'
    else If Err='D' then Err:='AddingTape'
    else If Err='N' then Err:='Note'
    else If Err='R' then Err:='Review';
    Strings[i]:=Err;
    Strings[i+1]:=LeftStr(Ret[RetNo].AuditList[j],60);
    Strings[i+2]:=MidStr(Ret[RetNo].AuditList[j],61,10);
    Strings[i+3]:=MidStr(Ret[RetNo].AuditList[j],70,3);
    Inc(i,4);
    Inc(j,1);
   until (i>193) or (j>Ret[RetNo].AuditList.count-1);
   *)
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure GetPriorYearYSum(RetNo, FNo: integer; FromDir,FlName:String;TempList,LinesList,ValueList:TStringList;
            FromElm,ToElm,Yr:Integer);
Var i,j,jj:Integer;LnNoStr:String[4];
begin
  If (DirectoryExists(FromDir)) and (FileExists(FromDir+'\'+FlName)) then
  begin
   GetPrevYearLines(FlName,FromDir,LinesList,ValueList);
   i:=FromElm;
   repeat
    j:=IsInList(AddLeadingZeros(IntToStr(i),3),TempList);
    LnNoStr:=MidStr(TempList[j],5,3);
    jj:=IsInList(LnNoStr,LinesList);
    If jj>=0 then ret[RetNo].Frm[FNo].Tv[i+Yr] := Vl(ValueList[jj]);
    inc(i,5);
   until i>ToElm;
  end;
end;


procedure T79(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'AB') = False then
  begin
   For i:=1 to 32 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  with ret[RetNo].Frm[FNo] do
  begin
   Strings[1]:=AppYear;
   Tv[8]:=AddColumns(3,7,1);
   Tv[10]:=MaxR(0,Tv[8]-Tv[9]);
   Tv[12]:=MaxR(0,Tv[10]-Tv[11]);
   If Tv[13]=0 then Tv[13]:=100;
   Tv[14]:=Tv[12] * vl(Strings[13])/100;
   Tv[15]:=Tv[14];
   Tv[16]:=Tv[2]+Tv[15];
   Tv[17]:=10;
   Tv[18]:=Tv[16]*Tv[17]/100;
   Tv[19]:=Vl(FetchElm(RetNo,'AB428',115));
   Tv[20]:=MinR(Tv[18],Tv[19]);

   Tv[21]:=Tv[16];
   Tv[22]:=Tv[20];
   Tv[24]:=10;
   Tv[25]:=(Tv[22]/Tv[24]) * 100;
   Tv[26]:=Tv[25];
   Tv[27]:=MaxR(0,Tv[21] - Tv[26]);

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure NSLS(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'NS') = False then
  begin
   For i:=1 to 5 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  with ret[RetNo].Frm[FNo] do
  begin
   Tv[2]:=MinR(525,Tv[1]*15/100);
   Tv[4]:=MinR(1000,Tv[3]*20/100);
   Tv[5]:=MinR(1000,Tv[2]+Tv[4]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure T1161(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   Strings[1]:=GetLastName(RetNo);
   Strings[2]:=GetFirstName(RetNo);
   Strings[3]:=GetSinNo(RetNo);
   If Strings[4]='' then
   begin
    Strings[4]:=FetchElm(RetNo,'INFO',6)
               +' '+FetchElm(RetNo,'INFO',22)
               +' '+FetchElm(RetNo,'INFO',68)
               +', '+FetchElm(RetNo,'INFO',10)
               +', '+FetchElm(RetNo,'INFO',14)
               +', '+FetchElm(RetNo,'INFO',15);
   end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure T1272(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   Strings[1]:=AppYear;
   Tv[4]:=Tv[2]+Tv[3];
   Tv[5]:=MinR(50000,Tv[4]);
   Tv[6]:= Vl(FetchElm(RetNo,'NL428',118));
   Tv[7]:=MinR(Tv[5],Tv[6]);

   Tv[8]:=Tv[4];
   Tv[9]:=Tv[7];
   Tv[10]:=MaxR(0,Tv[8]-Tv[9]);
   Tv[14]:=Tv[11]+Tv[12]+Tv[13];
   Tv[15]:=Tv[14];
   Tv[16]:=MaxR(0,Tv[10]-Tv[15]);
   If Strings[17]='' then Strings[17]:=FormatDateTime('yyyy-mm-dd',Date);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



procedure T1243(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   If Emigrant(RetNo) = false then //20240401
   Begin
    for i:=6 to 75 do
    begin
      Strings[i]:='';
      Tv[i]:=0;
    end;
    Exit;
   End;
   Strings[1]:=GetLastName(RetNo);
   Strings[2]:=GetFirstName(RetNo);
   Strings[3]:=GetSinNo(RetNo);

   Strings[4]:=FetchElm(RetNo,'INFO',6)
               +' '+FetchElm(RetNo,'INFO',22)
               +' '+FetchElm(RetNo,'INFO',68)
               +', '+FetchElm(RetNo,'INFO',10)
               +', '+FetchElm(RetNo,'INFO',14)
               +', '+FetchElm(RetNo,'INFO',15);
   Strings[5]:=AppYear+'-'+FetchElmFNo(RetNo,InfoFNo,28)+'-'+FetchElmFNo(RetNo,InfoFNo,27);
   i:=10;
   Repeat
    Tv[i+2]:=Tv[i]-Tv[i+1];
    Inc(i,7);
   until i>73;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S3ACB(RetNo: integer; FName: String;FNo: integer);
Var i,j,jj:Integer; Percent:Real; //j:ACBFRM, jj:S3ACB
begin
  CopyACBSalesToS3ACB(RetNo);
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   Tv[281]:=0;
   Tv[282]:=0;
   i:=6;
   Repeat
    Tv[281]:=Tv[281]+Tv[i];
    Tv[282]:=Tv[282]+Tv[i+3];
    Inc(i,9);
   until i>276;
  end;
  SaveTv(RetNo,FName,FNo);
end;


procedure T1204(RetNo: integer; FName: String;FNo: integer); //20190208
Var i:Integer; T2125FNo:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    Strings[1]:=AppYear;
    Strings[2]:='1';
    Strings[5]:=GetSinNo(RetNo);
    if Strings[17]='' then Strings[17]:='1';
    Strings[14]:=GetLastName(RetNo);
    Strings[15]:=GetFirstName(RetNo);
  end;
  SaveTv(RetNo,FName,FNo);
end;

//20251210 CZ I put back the 2024 version. The 3-page new T90 is not in cancelled
procedure T90(RetNo: integer; FName: String;FNo: integer); //20190208
Var i:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 With ret[RetNo].Frm[FNo] do
 begin
   if FetchElmFNo(RetNo,InfoFNo,128)>'' then      //20251216 CZ
   begin
    Tv[1]:=TotMultiple(RetNo,'T4',11);
    // Tv[3]:= GetSelfEmplForWib(RetNo); //excludes losses
    Tv[4]:=Tv[1]+Tv[2]+Tv[3];
    Tv[7]:=TotMultiple(RetNo,'T4E',14);
    Tv[14]:=Tv[4]+Tv[5]+Tv[21]+Tv[17]+Tv[6]+Tv[7]+Tv[9]+Tv[10]+Tv[12]+Tv[13];
    Tv[19]:=MaxR(0,Tv[14]-Tv[18]);
    Tv[20]:=MaxR(0,Tv[19]-Tv[11]);
    Tv[16]:=MaxR(0,Tv[20]-Tv[15]);
   end
   Else
   begin
    for i:=1 to 20 do Tv[i]:=0;
   end;
 end;
 SaveTv(RetNo,FName,FNo);
end;

(* //20251210 3 page not in effect  CZ
//20251008 Igor >>>
procedure T90(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= TotMultiple(RetNo, 'T4', 11);
    Tv[24]:= Tv[1] + Tv[2];
    Tv[25]:= Tv[24];
    Tv[26]:= TotMultiple(RetNo, 'T4', 67);
    Tv[27]:= Tv[26] + Tv[3];
    Tv[28]:= Tv[27];
    Tv[4]:= Tv[25] + Tv[28];

    //Page 2
    Tv[23]:= Tv[4];
    Tv[5]:= TotMultiple(RetNo, 'T4AP', 4);
    Tv[29]:= TotMultiple(RetNo, 'T4A', 75);
    Tv[6]:= TotMultiple(RetNo, 'T4A', 76);
    Tv[30]:= TotMultiple(RetNo, 'T4A', 22);
    Tv[31]:= TotMultiple(RetNo, 'T4A', 80);
    Tv[32]:= TotMultiple(RetNo, 'T4', 56);
    Tv[7]:= TotMultiple(RetNo, 'T4E', 14);
    Tv[14]:= Tv[5] + Tv[21] + Tv[22] + Tv[17] + Tv[29] + Tv[6] + Tv[30] + Tv[31] + Tv[32] + Tv[7] + Tv[9] + Tv[10] + Tv[12] + Tv[13];
    Tv[33]:= Tv[14];
    Tv[34]:= Tv[23] + Tv[33];
    Tv[19]:= MaxR(0, Tv[11] + Tv[18]);
    Tv[35]:= Tv[19];
    Tv[20]:= MaxR(0, Tv[34] - Tv[35]);

    //Page 3
    Tv[39]:= Tv[36] + Tv[37] + Tv[38];
    Tv[40]:= Tv[20];
    Tv[15]:= Tv[39];
    Tv[16]:=MaxR(0, Tv[40] - Tv[15]);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<
*)
//20241207
procedure T89(RetNo: integer; FName: String;FNo: integer); //20190208
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
   if Ret[RetNo].Province <>'AB' then
   begin
    for i:=1 to 4 do begin Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    Exit;
   end;
   Tv[2]:= Ret[RetNo].Lnn[42800];
   Tv[3]:=MinR(Tv[1],Tv[2]);
   Tv[4]:=MaxR(0,Tv[1]-Tv[3]);
  end; //with
  SaveTv(RetNo,FName,FNo);
end;


(*
procedure T1B(RetNo: integer; FName: String;FNo: integer); //20190208
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
   Tv[8]:=TotMultiple(RetNo,'T4A',98);
   Tv[1]:=Tv[8]+Tv[9];
   Tv[5]:=Tv[2]+Tv[3]+Tv[4];
   Tv[6]:=Tv[5];
   Tv[7]:=MaxR(0,Tv[1]-Tv[7]);
  end;
  SaveTv(RetNo,FName,FNo);
end;
*)

procedure T224(RetNo: integer; FName: String;FNo: integer); //20190208
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
   if Tv[1]>75000 then Tv[1]:=75000; //20221227

   Tv[9]:=Tv[1]+Tv[7];
   Tv[2]:=Vl(FetchElm(RetNo,'NS428',157));

   Tv[3]:=MinR(Tv[9],Tv[2]);

   Tv[4]:=Tv[9];
   Tv[5]:=Tv[3];
   Tv[6]:=MaxR(0,Tv[4]-Tv[5]);
  end;
  SaveTv(RetNo,FName,FNo);
end;
//20191129
procedure T225(RetNo: integer; FName: String;FNo: integer); //20190208
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
   Tv[9]:=Tv[1]+Tv[8];
   Tv[2]:=Vl(FetchElm(RetNo,'NS428',147));
   Tv[3]:=MinR(Tv[9],Tv[2]);
   if Tv[3]>112500 then Tv[3]:=112500;

   Tv[4]:=Tv[9];
   Tv[5]:=Tv[3];
   Tv[6]:=MaxR(0,Tv[4]-Tv[5]);
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure BCDON(RetNo:integer;FName:string;FNo:integer);  //20201129
Var i:integer;
Begin
 InitPrvConstants('BC');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'BC') = false  then
 begin
  For i:=1 to 16 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With ret[RetNo], ret[RetNo].Frm[FNo] do
 begin
  Tv[1]:=Vl(FetchElm(RetNo,'S9',11)); //change back to tv11 as form was not updated //20250203//jz 20250130 //Tv[1]:=Vl(FetchElm(RetNo,'S9',11));
  //Tv[1]:=Vl(FetchElm(RetNo,'S9',25));  //change from tv11 to tv25, line 16 of s9 as per form instructions//jz 20250130 //Tv[1]:=Vl(FetchElm(RetNo,'S9',11));
  Tv[2]:=MinR(200,Tv[1]);
  if Tv[1]=200 then Tv[2]:=200;  //equal
  //20231222
//Tv[16]:=MaxR(0,Tv[1]-Tv[2]);
  Tv[3]:=MaxR(0,Tv[1]-Tv[2]);
  Tv[4]:=Ret[RetNo].LNN[26000];
  Tv[5]:= 259829.00; //jz//20260106 - income threshold update //252752; //jz//20250203  //jz//20250203 //240716; //20231222 227091; //222420; //20221211
  Tv[6]:=MaxR(0,Tv[4]-Tv[5]);
  Tv[9]:=Tv[3];
  Tv[7]:=MinR(Tv[3],Tv[6]);
  Tv[8]:=Tv[7] * 20.5/100;
  Tv[11]:=MaxR(0,Tv[9]-Tv[7]);
  //Tv[10]:=Tv[7];
  Tv[12]:=Tv[11]*16.8 /100;
  Tv[13]:=Tv[2];
  Tv[14]:=Tv[13] * 5.06/100;
  Tv[15]:=Tv[8]+Tv[12]+Tv[14];
 end;
 SaveTv(RetNo,FName,FNo);
End;

Procedure NL479(RetNo:integer;FName:string;FNo:integer);  //20211123
Var i:integer;
Begin
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[FNo] do
 begin
   If (ret[RetNo].Province <> 'NL') then
   begin
      for i := 1 to 109 do Tv[i] := 0;
      SaveTv(RetNo,FName,FNo);
      exit;
   end;

   i:=5;
   Tv[101]:=0;
   Repeat
    Tv[101]:=Tv[101]+Tv[i];
    Inc(i,5);
   Until i>100;

   Tv[103]:=MinR(2000,MaxR(0,Tv[101]-Tv[102]));
   Tv[105]:=MaxR(0,Tv[103]-Tv[104]);
   Tv[106]:=17.4; //8.7;  20231116
   Tv[107]:=Tv[105] * Tv[106]/100;
   Tv[108]:=Vl(FetchElm(RetNo,'T1129',9));
   Tv[109]:=Tv[107]+Tv[108];
   ret[RetNo].Lnn[47900]:= Tv[109];
 end;
 SaveTv(RetNo,FName,FNo);
End;



Procedure NS479(RetNo:integer;FName:string;FNo:integer);  //20221211
Var i:integer;
Begin
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[FNo] do
 Begin
   if Tv[1]>500 then Tv[1]:=500;  //20231116
   i:=5;
   Tv[2]:=0;
   Repeat
    Tv[i+3]:=MaxR(0,Tv[i+1]-Tv[i+2]);
    if Tv[i+3]>500 then Tv[i+3]:=500;

    Tv[i+5]:=MaxR(0,Tv[i+3]-Tv[i+4]);
    Tv[2]:=Tv[2]+Tv[i+5];
    Inc(i,6);
   Until i>59;
   Tv[65]:=Tv[2]*8.79/100;  //20241207
   Tv[3]:=Tv[65]; //20241207
   Tv[4]:=Tv[1]+Tv[3];
   Ret[RetNo].Lnn[47900]:=Tv[4];
 end;
 SaveTv(RetNo,FName,FNo);
End;

//jz//20260413//CCAv7 - cleaned up comments
//jz//20260419//CCAv10 - move code here rather than use call autos
//**** NOTE **** taken from AUTOS , any time there is a change in either the other should change as well
Procedure AssetsB(RetNo: integer; FName: string; FNo: integer);
const
  //jz//20260405 - add col vars
  Col1 =134;Col2 =191;Col3 =158;Col4 =44;Col5 =18;Col6 =24;Col7 =46;Col8 = 47;Col9 = 26;Col10= 49;Col11=50;
  Col12= 12;Col13= 27;Col14= 52;Col15=53;Col16=15;Col17=14;Col18=30;Col19=167;Col20=170;Col21=173;Col22=176;
  Col21Claimed=65; Col21Tloss=20;Col21Recapt=21;
  Col22T776=59;Col23T776=61;col24T776=62; //jz//20260409//CCAv3 - add col vars for T776
  Col23T776Claimed=67;
Var
  ss:string;
  i, MaxBusDays, BusDays: integer;
  cls:string;
  FInst: String[4];
  Aiipfactor, Riipfactor: Real; //CCAv6//jz//20260406 // 20190215
  k, Gst, Pst: Real;
  Line5K, Line6K, Line7K: Real;
  Yr: String[4];
  TotalDays, DaysBeforeJuly1, DaysAfterJuly1: integer;
  StartLease, ENdLease: String;
  MaxCCA: Real;
  BusPercent: Real;
  //20230417
  IsClassEmpty,AiipEligible,DiepEligible:Boolean; //jz//CCAv6
  col22override:integer; //CCAv11


  AlocToT776:boolean;
  usagePercent:real;      //jz//CCAv5
  fromAssetsB : boolean;  //jz//CCAv5

  allowableCCA:real; //ccav10 - move to main while trying calcBusinessUseMaxCCA inline rather than nested

        procedure calcBusinessUseMaxCCA(RetNo,FNo:integer);
        //var allowableCCA:real;
        begin
          with Ret[RetNo].Frm[FNo] do
          begin
            Tv[93]:=0; //max based on the KM used for business
            //jz//20260405
            //CCAv5 - if is assestsb is personal usage, if autos is km for business use
            if fromAssetsB then  usagePercent := (100 - vl(Ret[RetNo].Frm[FNo].Strings[4]))/100
                           else  usagePercent := vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]);

            //jz//20260405 - have the KM prorated CCA based the overriden value, not instead of it
            allowableCCA := Tv[col21]     * usagePercent;
            Tv[93] := allowableCCA;

            allowableCCA := Tv[Col23T776] * usagePercent;
            Tv[64] := allowableCCA;

            //jz//20260417//CCAv9 put back override - this should be removed for next year
            if strings[206] > '' then  //CCAv11 - must keep as X box // changed to y/n box
            begin
              Tv[93] := Tv[177];
              Tv[64] := Tv[177];
            end;
          end;
        end;

        procedure calcMaxDays();
        begin
            //Prorate
            MaxBusDays := 0;
            If Ret[RetNo].Frm[FNo].Tv[216] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[215]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[215]);
            end;
            If Ret[RetNo].Frm[FNo].Tv[222] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]);
            end;
            If Ret[RetNo].Frm[FNo].Tv[228] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]);
            end;
        end;

Begin

//  Autos(RetNo,FName,FNo);
//  exit;




  fromAssetsB := pos('ASSETSB',uppercase(fname)) > 0;

  // ConvertOldAutoExpDates(RetNo,FNo);
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    //jz//CCAv6 - default to Y on whether to post assets to bus statements
    if (fromAssetsB) and (strings[10]='') then strings[10]:='Y';


    Tv[2]   := Tv[216] + Tv[222] + Tv[228];
    Tv[11]  := Tv[219] + Tv[225] + Tv[231];

    If Strings[129] = '' then
      Strings[129] := 'Business Parking Fees';
    If Strings[130] = '' then
      Strings[130] := 'Supplementary Business Insurance';


    if fromAssetsB then
      Strings[4] := FormatFloat('###.##', maxR(0, minR(100,vl(Strings[4])) ))  //jz//CCAv5
    else
    begin
      If (vl(Strings[4]) = 0) and (vl(Strings[7]) = 0) then //make sure km usage is not zeros
        begin Strings[4] := '1'; Strings[7] := '1'; end;
      If vl(Strings[7]) < vl(Strings[4]) then               //make sure business km usage is not more than total usage
        Strings[7] := Strings[4];
    end;


    //CHART C - Lease ========================================================
    Yr := LeftStr(Strings[57], 4);
    StartLease := Strings[57];
    ENdLease := Strings[60];
    If (StartLease > '') and (ENdLease > '') then
      TotalDays := DateDiff(YMDtoDate(StartLease), YMDtoDate(ENdLease));
    DaysBeforeJuly1 := DateDiff(YMDtoDate(StartLease),
      YMDtoDate(MinString('2006-07-01', ENdLease))); // 20160119 Igor
    DaysAfterJuly1 := DateDiff(YMDtoDate(MaxString('2006-07-01', StartLease)),
      YMDtoDate(ENdLease)); // 20160119 Igor

    If DaysBeforeJuly1 < 0 then
      DaysBeforeJuly1 := 0;
    If DaysAfterJuly1 < 0 then
      DaysAfterJuly1 := 0;
    Line5K := GetLine5K(Yr);
    Gst := Line5K * Tv[126] / 100;
    Pst := Line5K * vl(Strings[63]) / 100;
    If Yr < '1991' then
    begin
      Gst := 0;
      Pst := 0;
    end;
    //-----------------------------------------------
   //removed by CZwhy?  20260329 if Tv[5]=0 then Tv[]:=Tv[75];  //20260329
    //if Tv[6]=0 then Tv[]:=Tv[75];  //20260329

    k := Line5K + Gst + Pst;

    Tv[78] := MaxR(k, Tv[75]) * 0.85;

    Line6K := GetLine6K(Yr);
    Gst := Line6K * Tv[126] / 100;
    Pst := Line6K * vl(Strings[63]) / 100;
    If Yr < '1991' then
    begin
      Gst := 0;
      Pst := 0;
    end;
    k := Line6K + Gst + Pst;
    Tv[81] := MaxR(0, ((k * Tv[72]) / 30) - Tv[69]);

    Line7K := GetLine7K(Yr);
    Gst := Line7K * Tv[126] / 100;
    Pst := Line7K * vl(Strings[63]) / 100;
    If Yr < '1991' then
    begin
      Gst := 0;
      Pst := 0;
    end;
    k := Line7K + Gst + Pst;
    If Tv[78] > 0 then
      Tv[84] := k * Tv[66] / Tv[78]
    else
      Tv[84] := 0;

    Tv[99] := MinR(Tv[81], Tv[84]);

    //Chart B - Interest =====================================================
    If Tv[109] = 0 then
      Tv[109] := 10;
    If vl(Strings[106]) = 0 then
      Tv[109] := 0;
    //20241217
    Tv[109]:=Tv[9]/30;

    Tv[112] := vl(Strings[106]) * Tv[109];
    Tv[115] := MinR(Tv[103], Tv[112]);

    { interest }
    If UpperCase(Strings[28]) <> 'Y' then
      Tv[19] := Tv[115];

    { Lease }
    If UpperCase(Strings[29]) <> 'Y' then
      Tv[16] := Tv[99];

    //Chart A - expenses =====================================================
    Tv[42] := Tv[10] + Tv[19] + Tv[22] + Tv[25] +
                  Tv[13] + Tv[16] + Tv[43] + Tv[32] + Tv[36];   //20210301
    If vl(Strings[7]) > 0 then
      Tv[45] := Tv[42] * (vl(Strings[4]) / vl(Strings[7]))
    else
      Tv[45] := 0;
    Tv[54] := MaxR(0, Tv[45] + Tv[48] + Tv[51]);

  end; //with

  //If Tv[109] = 0 then Tv[109] := 10; // 20241217


  //=========AUTOS CCA ==========================================================
  //cca
  with Ret[RetNo].Frm[FNo] do
  begin
   //20230521
   //20230502
   Cls:=Ret[RetNo].Frm[FNo].Strings[134];  //class

   //jz//CCAv5 move cls='12' condition and changed date '/' to '-' '2018/11/20' then
   if (Ret[RetNo].Frm[FNo].Strings[137]>'2018-11-20') and (trim(cls)<>'12') then
   Begin
    Ret[RetNo].Frm[FNo].Strings[55]:='X';  //aiip
    AiipEligible:=True;
   End
   Else
   Begin
    Ret[RetNo].Frm[FNo].Strings[55]:='';
    AiipEligible:=False;
   End;

   //20230516
   If (Ret[RetNo].Frm[FNo].Strings[6]='') or (UpperCase(Ret[RetNo].Frm[FNo].Strings[6])='X')
   then //ok
   Else Ret[RetNo].Frm[FNo].Strings[6]:='';

   //jz//CCAv6 //20260413
   if Strings[6]>'' then IsClassEmpty:=true
                    else IsClassEmpty:=false;

   //if Ret[RetNo].Frm[FNo].strings[55]>'' then Ret[RetNo].Frm[FNo].Strings[34]:='X'; //if aiip then halh year blank/exempt

   if Ret[RetNo].Frm[FNo].Strings[41]>'' then DiepEligible:=True else DiepEligible:=False; //20230515


   //AUTOS CCA New format with 22  //21 columns now
   // If IsDiepEligible(Cls,Ret[RetNo].Frm[FNo].Strings[137])=false then begin DiepEligible:=False;Ret[RetNo].Frm[FNo].Strings[41]:='';end; //20230515

    Strings[38]:=GetAiipFactor(Cls); //jz//20260406//CCAv2
    Strings[58]:=GetRiipFactor(Cls); //jz//20260406//CCAv2

    //20230515
    if Tv[33]=Tv[40] then Tv[33]:=0; //if cost = AiiFactor then zero it out (error in restructioring with new format of CCA
    //20230429
    Tv[152]:=Tv[143] * Tv[197]/100;
    Tv[155]:=Tv[143] * Tv[200]/100;
    Tv[56]:=MaxR(0,Tv[143]+Tv[152]+Tv[155]-Tv[39]); //jz//20260406//CCAv2

    Tv[col3]:=Tv[56];  //jz//20260406//CCAv2 158  //20230519

    //COLUMNS
    if diepEligible=true then //Ret[RetNo].Frm[FNo].Strings[43]>'' then //diep eligible //20230423
    begin
     if Tv[Col4]=0 then begin Tv[col4]:=Tv[Col3];Tv[44]:=Tv[Col4];end;
     if Tv[Col4]>Tv[col3] then begin Tv[Col4]:=Tv[Col3];Tv[44]:=Tv[Col3];End;
    end
    Else
     Tv[Col4]:=0;

    If Tv[Col5]=0 then Tv[Col6]:=0;  //User if no diep then no dispos of diep //20230516
    Tv[col7]:=Tv[col2]+Tv[Col3]-Tv[col5];
    Tv[col8]:=MaxR(0,Tv[col4]-Tv[col6]);

    If DiepEligible=false then Tv[col9]:=0; //useer?/ immediate expensing
    if Tv[Col9]>1500000 then Tv[col9]:=1500000;

    Tv[col10]:=Tv[col3]-Tv[col9]; //MaxR(0,Tv[col3]-Tv[col4]+Tv[col8]-Tv[col9]);
    Tv[col11]:=Tv[50]; //user
    Tv[col12]:=Tv[12];  //manual MaxR(0,Tv[col7]-Tv[col9]);
    Tv[col13]:=MaxR(0,Tv[col7]-Tv[col9]) ; //-Tv[col10]+Tv[col11]);   //??? //MaxR(0,Tv[col5]-Tv[col6]-Tv[col10]+Tv[col11]);   //???
    Tv[Col14]:=MaxR(0,Tv[col5]-TV[Col10]+Tv[Col11]+Tv[Col12]); //*AiipFactor); //MaxR(0,(Tv[col11]-Tv[col13])*AiipFactor);
    Tv[Col15]:=MaxR(0,(Tv[col11]-Tv[col14]))*Vl(Strings[38]); //factor)   //-Tv[col11]-Tv[col5])*(1/2)) //20230411  //Tv[Col15]:=MaxR(0,(Tv[col10]+Tv[col6]-Tv[col11]-Tv[col5])*(1/2)) //20230411
    Tv[Col16]:=MaxR(0,Tv[col14]-Tv[col11]); //jz//20260424 - wrong cols //MaxR(0,Tv[col12]-Tv[col14]); //Factor 2??
    Tv[Col17]:=MaxR(0,Tv[col12]-Tv[col16])* Vl(strings[58]); //jz//20260405 - form wrong, fix col16 not col14

    if (Strings[34]='') and //not exempt half-year rule
       (Tv[col3]>0)         //jz//20260406//CCAv2 - there are current year adjustments
    then Tv[Col18]:=maxr(0,(Tv[Col10]-Tv[col11]-Tv[col12]-Tv[Col5])* (1/2) )  //jz//20260424 - add maxr for no negative
    else Tv[Col18]:=0;

    Tv[Col19]:=Tv[Col13]+Tv[col15]+Tv[Col17]-Tv[col18];     //jz//20260405 - form wrong, fix - +Tv[Col16]-Tv[col17];

    Ret[RetNo].Frm[FNo].Strings[col20]:=GetCCARate(Cls); //20260405

    Tv[col21] := (tv[col19] * (vl(strings[col20])/100)) + tv[col9];   //jz//20260406//CCAv2 - no more override, strait to col21 instead of 177 first  //jz//20260405 - as per changed form

    //jz//20260420 - NOTE **** adding the claim, overrides and moving elms messes up order, re assign both 'claimed' and last cols here after Override
    //               Tv[col21Claimed] Tv[col23T776Claimed] Tv[col22] Tv[col24T776] re assigned at end as well

    //If not(overrideCCA) then Tv[Col21]:=Tv[177];  //if not override apply amount //jz//20260406//CCAv2
    Tv[col21Claimed] := Tv[8]; //CCAv11 - total amount claimed

    if fromAssetsB  then col22override := 28
                    else col22override := 23;

    //if Strings[col22override]='' then //CCAv11 - put override back  //jz//20260406//CCAv2 - no more col 22 override
      Tv[col22]     := maxR(0,Tv[col7]-Tv[col21Claimed]); //jz//CCAv11 - TV[col21]); //jz//20260407//CCAv2 - cannot be neg - change as per form //Tv[Col19]-TV[177];

    //jz//20260409 - add for T776
    // T776 CHART B begin ======================================================
    strings[588] := strings[col1]; //set same cls
    i := 492; //Tv[427] := 0; //Repeat
      if (strings[i + 1] > '') and (strings[i + 1] <> '0') then
        Tv[i + 2] := Tv[i - 1] * Vl(strings[i]) / Vl(strings[i + 1])
      else
        Tv[i + 2] := 0;
    // T776 CHART B end ========================================================

    Tv[col22T776] := maxR(0,Tv[494]);
    Tv[col23T776] := maxR(0,Tv[col21] - TV[col22T776]);
    Tv[col23T776Claimed] := Tv[8]; //CCAv11 - total amount claimed
    Tv[col24T776] := maxR(0,Tv[col7]  - TV[col23T776Claimed]); //jz//CCAv11 - TV[col23T776]);

    //------------- Summarize on the top summary  -----------------------------

   //Init some totals
    Tv[90]          :=0;  //Tot Expense fot each auto
    Tv[Col21Tloss]  :=0;  //Terminal loss [20]
    Tv[Col21Recapt] :=0;  //Recapture [21]

     xx:=Tv[col21Claimed];

    calcBusinessUseMaxCCA(RetNo,FNo);
    ////jz//20260405 - calcBusinessUseCCAmax based on KM used for business is done above
    //               - if is assetsb, calcs personal use
    //                 there is repittion here of calculating milage max why???
    xx:=Tv[col21Claimed];

        {
        //CCAv10 - try in line as nested breaking override??
        //procedure calcBusinessUseMaxCCA(RetNo,FNo:integer);
        //var allowableCCA:real;
        begin
          with Ret[RetNo].Frm[FNo] do
          begin
            Tv[93]:=0; //max based on the KM used for business
            //jz//20260405
            //CCAv5 - if is assestsb is personal usage, if autos is km for business use
            if fromAssetsB then  usagePercent := (100 - vl(Ret[RetNo].Frm[FNo].Strings[4]))/100
                           else  usagePercent := vl(Ret[RetNo].Frm[FNo].Strings[4]) / vl(Ret[RetNo].Frm[FNo].Strings[7]);

            //jz//20260405 - have the KM prorated CCA based the overriden value, not instead of it
            allowableCCA := Tv[col21]     * usagePercent;
            Tv[93] := allowableCCA;

            allowableCCA := Tv[Col23T776] * usagePercent;
            Tv[64] := allowableCCA;

            xx:=Tv[col21Claimed];

            //jz//20260417//CCAv9 put back override - this should be removed for next year
            if strings[206] > '' then  //CCAv11 - must keep as X box // changed to y/n box
            begin
              Tv[93] := Tv[177];
              Tv[64] := Tv[177];
            end;
          end;
        end;
        }



    //find cca for each business statement
    //20230519
    Tv[90] := Tv[54]; //jz//20260410//CCAv4 - move to before to be populated for b% prorated calc
    Tv[8]:=0; //total CCA takem add up all business //20230610
    //CCAv9 - clears override field that were removed before me
    //    for i:=233 to 235 do Ret[RetNo].Frm[FNo].Strings[i]:=''; //*** NO override allowed here
    i := 215;  //pick it up from tv[173]  = total cca for all
    Repeat
        If (Ret[RetNo].Frm[FNo].Strings[i]   > '')   and
           (Ret[RetNo].Frm[FNo].Strings[i+1] > '')
        then
        begin
          BusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[i]);
          calcMaxDays();

        {
        //CCAv10 - try in line as nested breaking override??
        //        procedure calcMaxDays();
        begin
            //Prorate
            MaxBusDays := 0;
            If Ret[RetNo].Frm[FNo].Tv[216] > 0 then
              MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[215]);
            If Ret[RetNo].Frm[FNo].Tv[222] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[221]);
            end;
            If Ret[RetNo].Frm[FNo].Tv[228] > 0 then
            begin
              If CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]) > MaxBusDays then
                MaxBusDays := CalcBusDays(RetNo, Ret[RetNo].Frm[FNo].Strings[227]);
            end;
        end;
        }

          If MaxBusDays > 0 then
          Begin
            Tv[i + 2] := Tv[90] * Tv[i + 1] / 100; //jz//20260410//CCAv4

            //jz//20260409//CCAv3
            if pos('T776',strings[i]) = 0 then
              Tv[i + 3] := Tv[93] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
            else
            begin
              Tv[i + 3] := Tv[64] * (Tv[i + 1] / 100) * BusDays / MaxBusDays;
              AlocToT776 := true                   //jz//20260410//CCAv4
            end;

            Tv[8]:=Tv[8]+Tv[i+3]; //20230716
          End; //end max days
        end
        Else
        begin
          Tv[i + 2] := 0;
          Tv[i + 3] := 0;
        end;
        Inc(i, 6);
    until i > 227;

    if not AlocToT776 then tv[64] := 0; //jz//20260410//CCAv4 if no alocation to 776 then make zero


    //jz//20260421//CCAv12  - adding the claim and moving elms messes up order, re assign both 'claimed' and last cols here after Override
    //                      - move before Terminal loss or Recapture
    Tv[col21Claimed]      := Tv[8];
    Tv[col23T776Claimed]  := Tv[8];
    Tv[col22]             := maxR(0,Tv[col7]-Tv[col21Claimed]);
    Tv[col24T776]         := maxR(0,Tv[col7]  - TV[col23T776Claimed]);


    //Terminal loss or Recapture begin =======================================
    If IsClassEmpty then //jz//CCAv6 //(Ret[RetNo].Frm[FNo].Strings[6] > '') then //class empty
    begin
      if Cls='10.1' then  //no term loss or recapture
      Begin
        Tv[Col21Tloss] :=0;
        Tv[Col21Recapt]:=0;
      end
      else
      begin
        //jz//20260421//CCAv12  - clear regardless of if Terminal loss or Recapture
        Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309 NO CCA amounts
        Tv[64]:=0; //jz//20260412//CCAv5 - clear T776 CCA amount also

        Tv[col21Claimed]      := 0; //jz//20260421//CCAv12  - clear the claim as well as due to code order won't recalc
        Tv[col23T776Claimed]  := 0;

        If Tv[Col7]<0 then  //IF Recapture //20230501
        begin   //ucc + additions < UCC after dispositions then recapturoe
          //Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309 NO CCA amounts
          //Tv[64]:=0; //jz//20260412//CCAv5 - clear T776 CCA amount also

          Tv[Col21Recapt] := ABS(Tv[Col7]) * usagePercent; //jz//CCAv5 //(Vl(Ret[RetNo].Frm[FNo].Strings[4])/Vl(Ret[RetNo].Frm[FNo].Strings[7])); //prorate by km use//20240309

          //Tv[Col21]    := 0; // max cca  //jz//202604006//CCAv2 - change to col21 from 177 but not in use anymore anyway
          Tv[Col15]      := 0;   //jz//202604006//CCAv2 - still col15????????????????
          Tv[Col16]      := 0;   //Term loss //jz//202604006//CCAv2 -  chnge to Col19 from Col16
          Tv[Col21]      := 0;   //CCA  //jz//202604006//CCAv2 - change to col21 from col8

         Strings[col20]  := '';  //Rate //jz//202604006//CCAv2 - change to col20 from col17
         Tv[Col21Tloss]  := 0;   //jz//202604006//CCAv2 - change to Col21Tloss from 20
        end
        else      //IF Terminal loss
        begin
          //Tv[93]:=0; Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //20240309  NO CCA amounts
          //Tv[64]:=0; //jz//20260412//CCAv5 - clear T776 CCA amount also

          Tv[Col21Tloss] := ABS(Tv[Col7]) * usagePercent; //jz//CCAv5 //(Vl(Ret[RetNo].Frm[FNo].Strings[4])/vl(Ret[RetNo].Frm[FNo].Strings[7]));   //prorate km //20230309

          Tv[col21]       :=0; //Tv[173] := 0; //jz//202604006//CCAv2 - change to col21 from col8
          Tv[col22]       :=0; //Tv[167] := 0; // base amount  //jz//202604006//CCAv2 - change to col22 from col9
          Tv[col23T776]   :=0; //jz//20260412//CCAv5 - clear T776 CCA amounts also - not sure this is rigght, how does col223T776 get handled??
          Tv[col24T776]   :=0; //jz//20260412//CCAv5 - clear T776 CCA amounts also
          Tv[col21Recapt] :=0; //recapture //jz//202604006//CCAv2 - change to col21-Recapt from 21
          Strings[col20]  := '';  //Rate //jz//202604006//CCAv2 - change to col20 from col17 / [170]
          Tv[col22]       :=0; //Tv[176] := 0; //ending ucc 21 //jz//202604006//CCAv2 - change to col22 from 21 which was actually wrong
        end;
      end;
    end;
    //Terminal loss or Recapture end =========================================

  end; //with cca

  SaveTv(RetNo, FName, FNo); //20230501 Igor




end; //end Procedure AssetsB











//jz//20260412//CCAv5 - some changes, not completed
(*
Procedure AssetsB(RetNo: integer; FName: string; FNo: integer);  //20230211
const
  //jz//20260405 - add col vars
  Col1 =134;Col2 =191;Col3 =158;Col4 =44;Col5 =18;Col6 =24;Col7 =46;Col8 = 47;Col9 = 26;Col10= 49;Col11=50;
  Col12= 12;Col13= 27;Col14= 52;Col15=53;Col16=15;Col17=14;Col18=30;Col19=167;Col20=170;Col21=173;Col22=176;
  Col21Tloss=20;Col21Recapt=21;
  Col22T776=59;Col23T776=61;col24T776=62; //jz//20260409//CCAv3 - add col vars for T776

Var

  i, j: integer;
  cls:String;
  FInst: String[4]; // k,Gst,Pst:real;
  { StmList:TStringList; } BPercent: Real;
  BusDays, MaxBusDays: integer;
  MaxCCA: Real;
  BStmFNo: integer;
  BstmFInst: String;
  BstmFName: String;
  //Aiipfactor: Real;  //20260123
  DiepEligible:Boolean;
  isClassEmpty: Boolean;
  AiipEligible:Boolean;  //20230502
  IsTerminalloss,IsRecapture:Boolean;  //20260401
  CcaRate:Real;
Begin

  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    if UpperCase(Strings[10]) = 'X' then
      Strings[10] := 'Y'; // 20200520 compatibility old versions?
    If Strings[10] = '' then
      Strings[10] := 'Y';

    { ????
    If FInst > '#1' then
      Strings[10] := FetchElm(RetNo, 'ASSETSB#1', 10);
    Strings[3] := GetFirstName(RetNo);
    Strings[5] := GetSpouseFirstName(RetNo);
    Strings[9] := GetFirstName(RetNo);
   }

    //20230502
    if Strings[137]>'2018/11/20' then
    Begin
     Strings[41]:='X';
     AiipEligible:=True;
    End
    Else
    Begin
     Strings[41]:='';
     AiipEligible:=False;
    End;

    //20230516 class empty
    If (Ret[RetNo].Frm[FNo].Strings[6]='') or (UpperCase(Ret[RetNo].Frm[FNo].Strings[6])='X')
    then
    //ok
    Else
     Ret[RetNo].Frm[FNo].Strings[6]:='';

    DiepEligible:=false; if Strings[43]>'' then DiepEligible:=true;
    if Strings[6]>'' then IsClassEmpty:=true
                     else IsClassEmpty:=false; //20260124
    //allocation
    // 20200510  Allow only class 8
    if (LeftStr(Strings[215], 5) = 'T777#') and (vl(Strings[134]) <> 8) then
      Strings[215] := '';
    if (LeftStr(Strings[221], 5) = 'T777#') and (vl(Strings[134]) <> 8) then
      Strings[221] := '';
    if (LeftStr(Strings[227], 5) = 'T777#') and (vl(Strings[134]) <> 8) then
      Strings[227] := '';

    //Allocation to statements
    i := 215; // 20091229

    Repeat
      If (Strings[i] > '') or (Strings[i + 1] > '') then
      begin
        BstmFInst := ExtractFormInst(Strings[i]);
        BstmFName := ExtractNonInstFormName(Strings[i]) + BstmFInst;
        BStmFNo := GetFormNo(BstmFName);
        If (BStmFNo = 0) or (ret[RetNo].FormHasData[GetFormName(RetNo, BStmFNo)] = False) then
        begin
          Strings[i + 1] := '';
        end;
      end;
      Inc(i, 6);
    until i > 227;

    i := 216;
    Repeat
      If Tv[i] > 100 then
        Tv[i] := 100;
      If Strings[i - 1] = '' then
        Tv[i] := 0; // no statement
      Tv[i + 2] := Tv[173] * Tv[i] / 100;
      If IsSharedStatement(RetNo, Strings[i - 1]) then
        Tv[i + 3] := Tv[i];
      Inc(i, 6);
    until i > 228;

    Tv[2] := Tv[216] + Tv[222] + Tv[228];   //tot %
    Tv[8] :=Tv[218]+Tv[224]+Tv[230];        //CCAv5 //Tv[3]:=Tv[218]+Tv[224]+Tv[230]; //Tv[3]:=Tv[19]+Tv[24]+Tv[30];
    Tv[11] := Tv[219] + Tv[225] + Tv[231];  //not visible ????



{
    // CCA calculation
   // Strings[131] := Strings[1];    //asset descr //20230404
    Cls:=Strings[134];  //class
    Strings[170]:=GetCCaRate(cls);  //20260221
    //NO ggod Leave it for user blank If IsDiepEligible(Cls,Strings[137])=false then begin DiepEligible:=false; Strings[43]:='';end; //20230503

    if cls='12' then //(Strings[134] = '12') then
    begin
      Strings[41] := '';  //no Aiip  //?? 20230404
    end; // 20200703
    Tv[8] := Tv[12] * Tv[4] / 100; //personal portion

    //COLUMNS
    Tv[c3]:= MaxR(0, Tv[12] - Tv[8]); //net cos for business Tv[158]
    if Strings[43]>'' then //diep eligible //20230423
    begin
     if Tv[C4]=0 then begin Tv[c4]:=Tv[C3];Tv[44]:=Tv[C4];end;
     if Tv[C4]>Tv[c3] then begin Tv[C4]:=Tv[C3];Tv[44]:=Tv[C3];End;
    end;
    Tv[c4]:=Tv[44]; //user
    If Strings[43]='' then Tv[c4]:=0; //NO DIEP
    Tv[C5]:=MaxR(0,Tv[15]-Tv[14]);
    If Tv[C5]=0 then Tv[C6]:=0;  //User if no diep then no dispos of diep //20230516

    Tv[c7]:=Tv[c2]+Tv[C3]-Tv[c5];
    Tv[c8]:=MaxR(0,Tv[c4]-Tv[c6]);
    Tv[C9]:=Tv[48]; //user  //20220515
    If DiepEligible=false then Tv[c9]:=0; //useer?/ immediate expensing
    if Tv[C9]>1500000 then Tv[c9]:=1500000;
    Tv[c10]:=MaxR(0,Tv[c3]-Tv[c4]+Tv[c8]-Tv[c9]);

    if IsClassempty then  //fully disposed/Sold
    Begin
      if Tv[18] < Tv[191]+Tv[158] then //disposition less than UCC + additions
        IsTerminalLoss:=True
      else
        IsTerminalLoss:=False;

      if Tv[18] > Tv[191]+Tv[158] then //disposition less than UCC + additions
        IsRecapture:=True
      else
        IsRecapture:=False;
    end;


    Tv[c13]:=MaxR(0,Tv[c7]-Tv[c9]);


    Tv[c14]:=MaxR(0,Tv[c5]-Tv[c10]+Tv[c11]+Tv[c12]); //ok

    if (strings[41]>'') //aiip property
      and (LeftStr(Strings[137],4)<'2025') //purchased before 2025
    then
       Tv[C15]:=MaxR(0,(Tv[c11]-Tv[c14])*vl(Strings[9]))  //ok
    Else
      Tv[C15]:=0;

    //if Strings[7]>'' then Tv[C15]:=0;  //20230516 exempt from 50% rule
    //Tv[c16]:=MaxR(0, (Tv[C12]-Tv[C14]) * vl(Strings[17]));  //20260221
    Tv[C16]:=Tv[c12]+Tv[c14]-Tv[c15]; //base amount  deduct diep amount -Tv[C4];  //20230411


    Tv[c17]:= MaxR(0,(Tv[C12]-Tv[C16])) * Vl(Strings[17]);  //Vl(Strings[17]); //20260401
    If(LeftStr(Strings[137],4)< '2025') then begin Tv[c17]:=0;end;  //Strings[c17]:=GetCCARate(Cls); //
     //If Strings[13]='' then Strings[c17]:=GetCCARate(Cls); //if no override
    Tv[c18]:=MaxR(0,(Tv[C10]-Tv[C11]-Tv[C12]-Tv[C5])) * 0.50;

    if Strings[7]>'' then Tv[C18]:=0;  //20230516 eIf half year exempt from 50% rule

    Tv[c19]:=MaxR(0,(Tv[C13]+Tv[C15]+Tv[C17]-Tv[C18]));

}
   {
    //Prorate
    MaxBusDays := 0;
    If Tv[216] > 0 then //  % of yitd Statement
      MaxBusDays := CalcBusDays(RetNo, Strings[215]);

    If Tv[222] > 0 then    //  % of second Statement
    begin
      If CalcBusDays(RetNo, Strings[221]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[221]);
    end;

    If Tv[228] > 0 then  //  % of yitd Statement
    begin
      If CalcBusDays(RetNo, Strings[227]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[227]);
    end;
   }
    //Initialize cca, Term loss and Recapture
    //Tv[C18]:=MaxR(0,Tv[c13]+Tv[C15]+Tv[c16]-Tv[c17]); //20260221
    Tv[16]:=0; //term loss
    Tv[19]:=0; //recapture

    CCARate:=Vl(Strings[170]);
    //20260124
    If Strings[206] = '' then
     Tv[177] := Tv[col19] * CCARate/100; //Tv[c18] * CCARate/100; // vl(Strings[C17]) / 100 * MaxBusDays;
    //Tv[177]:=Tv[C18] * vl(Tv[170])/100];
    Tv[173]:=Tv[177]; // * (MaxBusDays/365);
    Tv[176]:=Tv[Col7]-Tv[173];

    if (IsTerminalLoss) and (IsClassEmpty)then
    Begin
      Tv[218]:=0;
      Tv[224]:=0;
      Tv[230]:=0;
      Tv[22]:=0;  //20240309
      Tv[16] := ABS(Tv[Col7]); //Tv[19] := ABS(Tv[C7]); //20230501
      Tv[177] := 0;Tv[173]:=0;Tv[176]:=0;
      tv[col18]:=0; //Tv[173] := 0;
      //Tv[c19]:=0; //Tv[167] := 0; // base amount
      Tv[19]:=0; //recapture
      Strings[col17]:=''; //Strings[170] := ''; // rate
      Tv[col19]:=0; //Tv[176] := 0; // ending ucc
    End;

    if (IsRecapture) and (IsClassempty) then
    Begin   //ucc + additions > UCC after dispositions then terminal loss
        Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[8]:=0;  //CCAv5Tv [218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[3]:=0;  //20240309
        Tv[19] :=ABS(Tv[C7]); //20230501 //Tv[16] :=ABS(Tv[C7]); //Tv[167]; // UCC after additions/disposals
        Tv[177] := 0;Tv[173]:=0;Tv[176]:=0;
        Tv[C15]:=0;
        Tv[C16]:=0; //Term loss
        Tv[C18]:=0; //CCA  Tv[173] := 0; // cca
        //Tv[19]:=0;  //recapture elm
        Strings[c17]:=''; //Rate Strings[170] := ''; // rate
        Tv[c16]:=0; //Tv[176] := 0; // ucc end
     end;

    {
    // prorate the maxCCA for short years   MaxCCA=Tv[177]
    If Strings[206] = '' then
     Tv[177] := Tv[c16] * vl(Strings[C17]) / 100 * MaxBusDays / Constant[RY].FullYear +Tv[c9]; // MAX cca for the year
    xx:=Tv[177];
    Tv[c18]:=Tv[177];

    Tv[173]:=Tv[C18];//202304
    Tv[C19]:=MaxR(0,Tv[C7]-Tv[C18]);  //20230426
    }
    xx:=Tv[C18];
    if Strings[36]='' then //used for CCA not fo record keeping
    Begin
     //20260221
     //copy C[] data into the ELM'sof the form

     Tv[158]:=Tv[C3];
     Tv[44]:=Tv[C4];
     Tv[18]:=Tv[C5];
     Tv[45]:=Tv[C6];
     Tv[46]:=Tv[C7];
     Tv[47]:=Tv[C8];
     Tv[48]:=Tv[C9];
     Tv[50]:=Tv[C11];
     Tv[53]:=Tv[C15];
     Tv[55]:=Tv[C16];
     Tv[5]:=Tv[c17]; //Tv[C16];
     Tv[54]:=Tv[C18];
     Tv[167]:=Tv[c19];
     Tv[170]:=CCARate;
    end
    Else  //record keeping only
    Begin
     Tv[158]:=0;
     Tv[44]:=0;
     Tv[18]:=0;
     Tv[45]:=0;
     Tv[46]:=0;
     Tv[47]:=0;
     Tv[48]:=0;
     Tv[19]:=0;
     Tv[50]:=0;
     Tv[51]:=0;
     Tv[53]:=0;
     Tv[54]:=0;
     Tv[167]:=0;
     Tv[170]:=0;
     Tv[173]:=0;
     Tv[176]:=0;
     Tv[177]:=0;

     Tv[c3]:=0;
     Tv[c4]:=0;
     Tv[c5]:=0;
     Tv[c6]:=0;
     Tv[c7]:=0;
     Tv[c8]:=0;
     Tv[c9]:=0;
     Tv[c12] := 0;
     Tv[c16]:=0;
     Strings[17]:='';  //cca
     Tv[c18] := 0;
     Tv[c19] := 0;
    end;

    Tv[8]:=0;  //CCAv5 Tv[3]:=0;  //20230610
    //??? for i:=233 to 235 do Ret[RetNo].Frm[FNo].Strings[i]:=''; //*** NO override allowed here
    i := 215;
    Repeat
    If Strings[i] > '' then
    begin
      BusDays := CalcBusDays(RetNo, Strings[i]);
      MaxBusDays := 365;         //jz//20260403 //other place populates this amount different but are commented out, just put 365 for now
      If BusDays > 0 then        //jz//20260403 //If MaxBusDays > 0 then //MaxBusDays doesn't seem to make sense, put busdays instead altho also doesnt make much sense
      Begin
          Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays //jz//20260205 - with the overrides removed it is the same statement no matter the condition, simplify code
                    {
                    if (i+3=218) then
                    Begin
                      // If (Ret[RetNo].Frm[FNo].Strings[233]='') then //override
                      Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
                      // Else
                      //  Tv[i + 3] :=Tv[236];
                    End;

                    if (i+3=224) then
                    Begin
                      //If (Ret[RetNo].Frm[FNo].Strings[234]='') then //override
                      Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays;
                      //Else
                      // Tv[i + 3] :=Tv[237];
                    End;

                    if (i+3=230) then
                    Begin
                      //If (Ret[RetNo].Frm[FNo].Strings[235]='') then //override
                      Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
                      //Else
                      // Tv[i + 3] :=Tv[238];
                    End;
                    }
        end  //max bus days
      Else
      begin
        Tv[i + 2] := 0;
        Tv[i + 3] := 0;
      end;
      end;

      //jz//20260205 - Tv[2]:=Tv[2]+TV[i+3];
                      //probably meant Tv[3]:= instead of 2 //CCAv5 now changed to [8] -> Tv[8]:=
                      //and add :=Tv[3] -> :=Tv[8]
                      //and i+2 instead of just 2
      Tv[8]:=Tv[8]+Tv[i+2]+Tv[i+3]; //total CCA Claimed  //CCAv5 Tv[3]:=Tv[3]+Tv[i+2]+Tv[i+3];
      xx:=Tv[i+2];
      xx:=Tv[i+3];
      xx:=Tv[8];
      Inc(i, 6);
    until i > 227;




  end; //End with



  SaveTv(RetNo, FName, FNo);

End;
*)

//20260401
(*

Procedure AssetsB(RetNo: integer; FName: string; FNo: integer);  //20230211
Const
c2=191;
c3=158;
c4=44;
c5=18;

c6=24; //45;
c7=46;   //col6      //20230525 Igor
c8=47;
c9=26; //48;
c10=49;
c11=50;

c12=22; //51; //20260125
c13=51; //51; //52;
c14=52; //53;
c15=53; //54; /
c16=55; //55; //5; //167; //20260221
c17=5; //5; //170;  //20260221

c18=54; //173;
c19=167; //170; //176;

Var

  i, j: integer;
  cls:String;
  FInst: String[4]; // k,Gst,Pst:real;
  { StmList:TStringList; } BPercent: Real;
  BusDays, MaxBusDays: integer;
  MaxCCA: Real;
  BStmFNo: integer;
  BstmFInst: String;
  BstmFName: String;
  //Aiipfactor: Real;  //20260123
  DiepEligible:Boolean;
  isClassEmpty: Boolean;
  AiipEligible:Boolean;  //20230502
  IsTerminalloss,IsRecapture:Boolean;  //20260401
  CcaRate:Real;
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    if UpperCase(Strings[10]) = 'X' then
      Strings[10] := 'Y'; // 20200520 compatibility old versions?
    If Strings[10] = '' then
      Strings[10] := 'Y';

    { ????
    If FInst > '#1' then
      Strings[10] := FetchElm(RetNo, 'ASSETSB#1', 10);
    Strings[3] := GetFirstName(RetNo);
    Strings[5] := GetSpouseFirstName(RetNo);
    Strings[9] := GetFirstName(RetNo);
   }

    //20230502
    if Strings[137]>'2018/11/20' then
    Begin
     Strings[41]:='X';
     AiipEligible:=True;
    End
    Else
    Begin
     Strings[41]:='';
     AiipEligible:=False;
    End;

    //20230516 class empty
    If (Ret[RetNo].Frm[FNo].Strings[6]='') or (UpperCase(Ret[RetNo].Frm[FNo].Strings[6])='X')
    then
    //ok
    Else
     Ret[RetNo].Frm[FNo].Strings[6]:='';

    DiepEligible:=false; if Strings[43]>'' then DiepEligible:=true;
    if Strings[6]>'' then IsClassEmpty:=true
                     else IsClassEmpty:=false; //20260124
    //allocation
    // 20200510  Allow only class 8
    if (LeftStr(Strings[215], 5) = 'T777#') and (vl(Strings[134]) <> 8) then
      Strings[215] := '';
    if (LeftStr(Strings[221], 5) = 'T777#') and (vl(Strings[134]) <> 8) then
      Strings[221] := '';
    if (LeftStr(Strings[227], 5) = 'T777#') and (vl(Strings[134]) <> 8) then
      Strings[227] := '';

    //Allocation to statements
    i := 215; // 20091229

    Repeat
      If (Strings[i] > '') or (Strings[i + 1] > '') then
      begin
        BstmFInst := ExtractFormInst(Strings[i]);
        BstmFName := ExtractNonInstFormName(Strings[i]) + BstmFInst;
        BStmFNo := GetFormNo(BstmFName);
        If (BStmFNo = 0) or (ret[RetNo].FormHasData[GetFormName(RetNo, BStmFNo)] = False) then
        begin
          Strings[i + 1] := '';
        end;
      end;
      Inc(i, 6);
    until i > 227;

    i := 216;
    Repeat
      If Tv[i] > 100 then
        Tv[i] := 100;
      If Strings[i - 1] = '' then
        Tv[i] := 0; // no statement
      Tv[i + 2] := Tv[173] * Tv[i] / 100;
      If IsSharedStatement(RetNo, Strings[i - 1]) then
        Tv[i + 3] := Tv[i];
      Inc(i, 6);
    until i > 228;

    Tv[2] := Tv[216] + Tv[222] + Tv[228];  //tot %
    Tv[3]:=Tv[218]+Tv[224]+Tv[230];
    //Tv[3]:=Tv[19]+Tv[24]+Tv[30];
    Tv[11] := Tv[219] + Tv[225] + Tv[231];  //not visible ????

     autosAssetsCCA(RetNo,FNo,ret[RetNo].Frm[Fno]);

{
    // CCA calculation
   // Strings[131] := Strings[1];    //asset descr //20230404
    Cls:=Strings[134];  //class
    Strings[170]:=GetCCaRate(cls);  //20260221
    //NO ggod Leave it for user blank If IsDiepEligible(Cls,Strings[137])=false then begin DiepEligible:=false; Strings[43]:='';end; //20230503

    if cls='12' then //(Strings[134] = '12') then
    begin
      Strings[41] := '';  //no Aiip  //?? 20230404
    end; // 20200703
    Tv[8] := Tv[12] * Tv[4] / 100; //personal portion

    //COLUMNS
    Tv[c3]:= MaxR(0, Tv[12] - Tv[8]); //net cos for business Tv[158]
    if Strings[43]>'' then //diep eligible //20230423
    begin
     if Tv[C4]=0 then begin Tv[c4]:=Tv[C3];Tv[44]:=Tv[C4];end;
     if Tv[C4]>Tv[c3] then begin Tv[C4]:=Tv[C3];Tv[44]:=Tv[C3];End;
    end;
    Tv[c4]:=Tv[44]; //user
    If Strings[43]='' then Tv[c4]:=0; //NO DIEP
    Tv[C5]:=MaxR(0,Tv[15]-Tv[14]);
    If Tv[C5]=0 then Tv[C6]:=0;  //User if no diep then no dispos of diep //20230516

    Tv[c7]:=Tv[c2]+Tv[C3]-Tv[c5];
    Tv[c8]:=MaxR(0,Tv[c4]-Tv[c6]);
    Tv[C9]:=Tv[48]; //user  //20220515
    If DiepEligible=false then Tv[c9]:=0; //useer?/ immediate expensing
    if Tv[C9]>1500000 then Tv[c9]:=1500000;
    Tv[c10]:=MaxR(0,Tv[c3]-Tv[c4]+Tv[c8]-Tv[c9]);

    if IsClassempty then  //fully disposed/Sold
    Begin
      if Tv[18] < Tv[191]+Tv[158] then //disposition less than UCC + additions
        IsTerminalLoss:=True
      else
        IsTerminalLoss:=False;

      if Tv[18] > Tv[191]+Tv[158] then //disposition less than UCC + additions
        IsRecapture:=True
      else
        IsRecapture:=False;
    end;


    Tv[c13]:=MaxR(0,Tv[c7]-Tv[c9]);


    Tv[c14]:=MaxR(0,Tv[c5]-Tv[c10]+Tv[c11]+Tv[c12]); //ok

    if (strings[41]>'') //aiip property
      and (LeftStr(Strings[137],4)<'2025') //purchased before 2025
    then
       Tv[C15]:=MaxR(0,(Tv[c11]-Tv[c14])*vl(Strings[9]))  //ok
    Else
      Tv[C15]:=0;

    //if Strings[7]>'' then Tv[C15]:=0;  //20230516 exempt from 50% rule
    //Tv[c16]:=MaxR(0, (Tv[C12]-Tv[C14]) * vl(Strings[17]));  //20260221
    Tv[C16]:=Tv[c12]+Tv[c14]-Tv[c15]; //base amount  deduct diep amount -Tv[C4];  //20230411


    Tv[c17]:= MaxR(0,(Tv[C12]-Tv[C16])) * Vl(Strings[17]);  //Vl(Strings[17]); //20260401
    If(LeftStr(Strings[137],4)< '2025') then begin Tv[c17]:=0;end;  //Strings[c17]:=GetCCARate(Cls); //
     //If Strings[13]='' then Strings[c17]:=GetCCARate(Cls); //if no override
    Tv[c18]:=MaxR(0,(Tv[C10]-Tv[C11]-Tv[C12]-Tv[C5])) * 0.50;

    if Strings[7]>'' then Tv[C18]:=0;  //20230516 eIf half year exempt from 50% rule

    Tv[c19]:=MaxR(0,(Tv[C13]+Tv[C15]+Tv[C17]-Tv[C18]));

}
   {
    //Prorate
    MaxBusDays := 0;
    If Tv[216] > 0 then //  % of yitd Statement
      MaxBusDays := CalcBusDays(RetNo, Strings[215]);

    If Tv[222] > 0 then    //  % of second Statement
    begin
      If CalcBusDays(RetNo, Strings[221]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[221]);
    end;

    If Tv[228] > 0 then  //  % of yitd Statement
    begin
      If CalcBusDays(RetNo, Strings[227]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[227]);
    end;
   }
    //Initialize cca, Term loss and Recapture
    //Tv[C18]:=MaxR(0,Tv[c13]+Tv[C15]+Tv[c16]-Tv[c17]); //20260221
    Tv[16]:=0; //term loss
    Tv[19]:=0; //recapture

    CCARate:=Vl(Strings[170]);
    //20260124
    If Strings[206] = '' then
     Tv[177] := Tv[c19] * CCARate/100; //Tv[c18] * CCARate/100; // vl(Strings[C17]) / 100 * MaxBusDays;
    //Tv[177]:=Tv[C18] * vl(Tv[170])/100];
    Tv[173]:=Tv[177]; // * (MaxBusDays/365);
    Tv[176]:=Tv[C7]-Tv[173];

    if (IsTerminalLoss) and (IsClassEmpty)then
    Begin
      Tv[218]:=0;
      Tv[224]:=0;
      Tv[230]:=0;
      Tv[22]:=0;  //20240309
      Tv[16] := ABS(Tv[C7]); //Tv[19] := ABS(Tv[C7]); //20230501
      Tv[177] := 0;Tv[173]:=0;Tv[176]:=0;
      tv[c18]:=0; //Tv[173] := 0;
      //Tv[c19]:=0; //Tv[167] := 0; // base amount
      Tv[19]:=0; //recapture
      Strings[c17]:=''; //Strings[170] := ''; // rate
      Tv[c19]:=0; //Tv[176] := 0; // ending ucc
    End;

    if (IsRecapture) and (IsClassempty) then
    Begin   //ucc + additions > UCC after dispositions then terminal loss
        Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[3]:=0;  //20240309
        Tv[19] :=ABS(Tv[C7]); //20230501 //Tv[16] :=ABS(Tv[C7]); //Tv[167]; // UCC after additions/disposals
        Tv[177] := 0;Tv[173]:=0;Tv[176]:=0;
        Tv[C15]:=0;
        Tv[C16]:=0; //Term loss
        Tv[C18]:=0; //CCA  Tv[173] := 0; // cca
        //Tv[19]:=0;  //recapture elm
        Strings[c17]:=''; //Rate Strings[170] := ''; // rate
        Tv[c16]:=0; //Tv[176] := 0; // ucc end
     end;

    {
    // prorate the maxCCA for short years   MaxCCA=Tv[177]
    If Strings[206] = '' then
     Tv[177] := Tv[c16] * vl(Strings[C17]) / 100 * MaxBusDays / Constant[RY].FullYear +Tv[c9]; // MAX cca for the year
    xx:=Tv[177];
    Tv[c18]:=Tv[177];

    Tv[173]:=Tv[C18];//202304
    Tv[C19]:=MaxR(0,Tv[C7]-Tv[C18]);  //20230426
    }
    xx:=Tv[C18];
    if Strings[36]='' then //used for CCA not fo record keeping
    Begin
     //20260221
     //copy C[] data into the ELM'sof the form
     
     Tv[158]:=Tv[C3];
     Tv[44]:=Tv[C4];
     Tv[18]:=Tv[C5];
     Tv[45]:=Tv[C6];
     Tv[46]:=Tv[C7];
     Tv[47]:=Tv[C8];
     Tv[48]:=Tv[C9];
     Tv[50]:=Tv[C11];
     Tv[53]:=Tv[C15];
     Tv[55]:=Tv[C16];
     Tv[5]:=Tv[c17]; //Tv[C16];
     Tv[54]:=Tv[C18];
     Tv[167]:=Tv[c19];
     Tv[170]:=CCARate;
    end
    Else  //record keeping only
    Begin
     Tv[158]:=0;
     Tv[44]:=0;
     Tv[18]:=0;
     Tv[45]:=0;
     Tv[46]:=0;
     Tv[47]:=0;
     Tv[48]:=0;
     Tv[19]:=0;
     Tv[50]:=0;
     Tv[51]:=0;
     Tv[53]:=0;
     Tv[54]:=0;
     Tv[167]:=0;
     Tv[170]:=0;
     Tv[173]:=0;
     Tv[176]:=0;
     Tv[177]:=0;

     Tv[c3]:=0;
     Tv[c4]:=0;
     Tv[c5]:=0;
     Tv[c6]:=0;
     Tv[c7]:=0;
     Tv[c8]:=0;
     Tv[c9]:=0;
     Tv[c12] := 0;
     Tv[c16]:=0;
     Strings[17]:='';  //cca
     Tv[c18] := 0;
     Tv[c19] := 0;
    end;
    
    Tv[3]:=0;  //20230610
    //??? for i:=233 to 235 do Ret[RetNo].Frm[FNo].Strings[i]:=''; //*** NO override allowed here
    i := 215;
    Repeat
    If Strings[i] > '' then
    begin
      BusDays := CalcBusDays(RetNo, Strings[i]);
      MaxBusDays := 365;         //jz//20260403 //other place populates this amount different but are commented out, just put 365 for now
      If BusDays > 0 then        //jz//20260403 //If MaxBusDays > 0 then //MaxBusDays doesn't seem to make sense, put busdays instead altho also doesnt make much sense
      Begin
          Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays //jz//20260205 - with the overrides removed it is the same statement no matter the condition, simplify code
                    {
                    if (i+3=218) then
                    Begin
                      // If (Ret[RetNo].Frm[FNo].Strings[233]='') then //override
                      Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
                      // Else
                      //  Tv[i + 3] :=Tv[236];
                    End;

                    if (i+3=224) then
                    Begin
                      //If (Ret[RetNo].Frm[FNo].Strings[234]='') then //override
                      Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays;
                      //Else
                      // Tv[i + 3] :=Tv[237];
                    End;

                    if (i+3=230) then
                    Begin
                      //If (Ret[RetNo].Frm[FNo].Strings[235]='') then //override
                      Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
                      //Else
                      // Tv[i + 3] :=Tv[238];
                    End;
                    }
      end  //max bus days
      Else
      begin
        Tv[i + 2] := 0;
        Tv[i + 3] := 0;
      end;
    end;
    
    //jz//20260205 - Tv[2]:=Tv[2]+TV[i+3];
                    //probably meant Tv[3]:= instead of 2
                    //and add :=Tv[3]
                    //and i+2 instead of just 2
    Tv[3]:=Tv[3]+Tv[i+2]+Tv[i+3]; //total CCA Claimed
    xx:=Tv[i+2];
    xx:=Tv[i+3];
    xx:=Tv[3];
    Inc(i, 6);
    until i > 227;




  end; //End with



  SaveTv(RetNo, FName, FNo);

End;
*)

(*
// 2025 version 20260123  QALEX as sent to me
Procedure AssetsB(RetNo: integer; FName: string; FNo: integer);  //20230211
Const col2=191;
col3=158;
col4=44;
col5=18;
col6=45;
col7=46;   //col6      //20230525 Igor
col8=47;
col9=48;
col10=49;
col11=50;

col12=22; //51; //20260125
col13=51; //52;
col14=52; //53;

col15=53; //54; /
col16=55; //5; //167; //20260221
col17=5; //170;  //20260221

col18=167; //173;
col19=170; //176;
Var

  i, j: integer;
  cls:String;
  FInst: String[4]; // k,Gst,Pst:real;
  { StmList:TStringList; } BPercent: Real;
  BusDays, MaxBusDays: integer;
  MaxCCA: Real;
  BStmFNo: integer;
  BstmFInst: String;
  BstmFName: String;
  //Aiipfactor: Real;  //20260123
  DiepEligible:Boolean;
  isClassEmpty: Boolean;
  AiipEligible:Boolean;  //20230502
  IsTerminalloss,IsRecapture:Boolean;
  CcaRate:Real;
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    if UpperCase(Strings[10]) = 'X' then
      Strings[10] := 'Y'; // 20200520 compatibility old versions?
    If Strings[10] = '' then
      Strings[10] := 'Y';

    { ????
    If FInst > '#1' then
      Strings[10] := FetchElm(RetNo, 'ASSETSB#1', 10);
    Strings[3] := GetFirstName(RetNo);
    Strings[5] := GetSpouseFirstName(RetNo);
    Strings[9] := GetFirstName(RetNo);
   }

    //20230502
    if Strings[137]>'2018/11/20' then
    Begin
     Strings[41]:='X';
     AiipEligible:=True;
    End
    Else
    Begin
     Strings[41]:='';
     AiipEligible:=False;
    End;

    //20230516 class empty
    If (Ret[RetNo].Frm[FNo].Strings[6]='') or (UpperCase(Ret[RetNo].Frm[FNo].Strings[6])='X')
    then
    //ok
    Else
     Ret[RetNo].Frm[FNo].Strings[6]:='';

    DiepEligible:=false; if Strings[43]>'' then DiepEligible:=true;
    if Strings[6]>'' then IsClassEmpty:=true
                     else IsClassEmpty:=false; //20260124
    //allocation
    // 20200510  Allow only class 8
    if (LeftStr(Strings[215], 5) = 'T777#') and (vl(Strings[134]) <> 8) then
      Strings[215] := '';
    if (LeftStr(Strings[221], 5) = 'T777#') and (vl(Strings[134]) <> 8) then
      Strings[221] := '';
    if (LeftStr(Strings[227], 5) = 'T777#') and (vl(Strings[134]) <> 8) then
      Strings[227] := '';

    //Allocation to statements
    i := 215; // 20091229

    Repeat
      If (Strings[i] > '') or (Strings[i + 1] > '') then
      begin
        BstmFInst := ExtractFormInst(Strings[i]);
        BstmFName := ExtractNonInstFormName(Strings[i]) + BstmFInst;
        BStmFNo := GetFormNo(BstmFName);
        If (BStmFNo = 0) or (ret[RetNo].FormHasData[GetFormName(RetNo, BStmFNo)] = False) then
        begin
          Strings[i + 1] := '';
        end;
      end;
      Inc(i, 6);
    until i > 227;

    i := 216;
    Repeat
      If Tv[i] > 100 then
        Tv[i] := 100;
      If Strings[i - 1] = '' then
        Tv[i] := 0; // no statement
      Tv[i + 2] := Tv[173] * Tv[i] / 100;
      If IsSharedStatement(RetNo, Strings[i - 1]) then
        Tv[i + 3] := Tv[i];
      Inc(i, 6);
    until i > 228;

    Tv[2] := Tv[216] + Tv[222] + Tv[228];  //tot %
    Tv[3]:=Tv[218]+Tv[224]+Tv[230];
    //Tv[3]:=Tv[19]+Tv[24]+Tv[30];
    Tv[11] := Tv[219] + Tv[225] + Tv[231];  //not visible ????

    // CCA calculation
   // Strings[131] := Strings[1];    //asset descr //20230404
    Cls:=Strings[134];  //class
    Strings[170]:=GetCCaRate(cls);  //20260221
    //NO ggod Leave it for user blank If IsDiepEligible(Cls,Strings[137])=false then begin DiepEligible:=false; Strings[43]:='';end; //20230503

    if cls='12' then //(Strings[134] = '12') then
    begin
      Strings[41] := '';  //no Aiip  //?? 20230404
    end; // 20200703
    Tv[8] := Tv[12] * Tv[4] / 100; //personal portion

    //COLUMNS
    Tv[col3]:= MaxR(0, Tv[12] - Tv[8]); //net cos for business Tv[158]
    if Strings[43]>'' then //diep eligible //20230423
    begin
     if Tv[Col4]=0 then begin Tv[col4]:=Tv[Col3];Tv[44]:=Tv[Col4];end;
     if Tv[Col4]>Tv[col3] then begin Tv[Col4]:=Tv[Col3];Tv[44]:=Tv[Col3];End;
    end;
    Tv[col4]:=Tv[44]; //user
    If Strings[43]='' then Tv[col4]:=0; //NO DIEP
    Tv[Col5]:=MaxR(0,Tv[15]-Tv[14]);
    If Tv[Col5]=0 then Tv[Col6]:=0;  //User if no diep then no dispos of diep //20230516

    Tv[col7]:=Tv[col2]+Tv[Col3]-Tv[col5];
    Tv[col8]:=MaxR(0,Tv[col4]-Tv[col6]);
    Tv[Col9]:=Tv[48]; //user  //20220515
    If DiepEligible=false then Tv[col9]:=0; //useer?/ immediate expensing
    if Tv[Col9]>1500000 then Tv[col9]:=1500000;
    Tv[col10]:=MaxR(0,Tv[col3]-Tv[col4]+Tv[col8]-Tv[col9]);

    if IsClassempty then  //fully disposed/Sold
    Begin
      if Tv[18] < Tv[191]+Tv[158] then //disposition less than UCC + additions
        IsTerminalLoss:=True
      else
        IsTerminalLoss:=False;

      if Tv[18] > Tv[191]+Tv[158] then //disposition less than UCC + additions
        IsRecapture:=True
      else
        IsRecapture:=False;
    end;


    Tv[col13]:=MaxR(0,Tv[col7]-Tv[col9]);
    xx:=Tv[col13];

    Tv[col14]:=MaxR(0,Tv[col5]-Tv[col10]+Tv[col11]+Tv[col12]); //ok

    if (strings[41]>'') //aiip property
      and (LeftStr(Strings[137],4)<'2025') //purchased before 2025
    then
       Tv[Col15]:=MaxR(0,(Tv[col11]-Tv[col14])*vl(Strings[9]))  //ok
    Else
      Tv[Col15]:=0;

    if Strings[7]>'' then Tv[Col15]:=0;  //20230516 exempt from 50% rule
    //Tv[col16]:=MaxR(0, (Tv[Col12]-Tv[Col14]) * vl(Strings[17]));  //20260221
    Tv[Col16]:=Tv[col12]+Tv[col14]-Tv[col15]; //base amount  deduct diep amount -Tv[Col4];  //20230411


    //Tv[col17]:= MaxR(0,(Tv[Col12]-Tv[Col16])) * 0.50; //Vl(Strings[17]); //20260401
    //Tv[54]:=  MaxR(0,(Tv[Col12]-Tv[Col16])) * 0.50; //Vl(Strings[17]); //20260401

    If(LeftStr(Strings[137],4)< '2025') then begin Tv[col17]:=0;end;  //Strings[col17]:=GetCCARate(Cls); //
     //If Strings[13]='' then Strings[col17]:=GetCCARate(Cls); //if no override

    //Prorate
    MaxBusDays := 0;
    If Tv[216] > 0 then
      MaxBusDays := CalcBusDays(RetNo, Strings[215]);
    If Tv[222] > 0 then
    begin
      If CalcBusDays(RetNo, Strings[221]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[221]);
    end;
    If Tv[228] > 0 then
    begin
      If CalcBusDays(RetNo, Strings[227]) > MaxBusDays then
        MaxBusDays := CalcBusDays(RetNo, Strings[227]);
    end;

    //Initialize cca, Term loss and Recapture
    Tv[Col18]:=MaxR(0,Tv[col13]+Tv[Col15]+Tv[col16]-Tv[col17]); //20260221
    xx:=Tv[col18];
    Tv[16]:=0; //term loss
    Tv[19]:=0; //recapture

    CCARate:=Vl(Strings[170]);
    //20260124
    If Strings[206] = '' then
     Tv[177] := Tv[col18] * CCARate/100; // vl(Strings[Col17]) / 100 * MaxBusDays;
    //Tv[177]:=Tv[Col18] * vl(Tv[170])/100];
    Tv[173]:=Tv[177]; // * (MaxBusDays/365);
    Tv[176]:=Tv[Col18]-Tv[173];

    if IsTerminalLoss then
    Begin
      Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[22]:=0;  //20240309
      Tv[16] := ABS(Tv[Col7]); //Tv[19] := ABS(Tv[Col7]); //20230501
      Tv[177] := 0;Tv[173]:=0;Tv[176]:=0;
      tv[col18]:=0; //Tv[173] := 0;
      Tv[col19]:=0; //Tv[167] := 0; // base amount
      Tv[19]:=0; //recapture
      Strings[col17]:=''; //Strings[170] := ''; // rate
      Tv[col19]:=0; //Tv[176] := 0; // ending ucc
    End;

    if IsRecapture then
    Begin   //ucc + additions > UCC after dispositions then terminal loss
        Tv[218]:=0;Tv[224]:=0;Tv[230]:=0;Tv[3]:=0;  //20240309
        Tv[19] :=ABS(Tv[Col7]); //20230501 //Tv[16] :=ABS(Tv[Col7]); //Tv[167]; // UCC after additions/disposals
        Tv[177] := 0;Tv[173]:=0;Tv[176]:=0;
        Tv[Col15]:=0;
        Tv[Col16]:=0; //Term loss
        Tv[Col18]:=0; //CCA  Tv[173] := 0; // cca
        //Tv[19]:=0;  //recapture elm
        Strings[col17]:=''; //Rate Strings[170] := ''; // rate
        Tv[col16]:=0; //Tv[176] := 0; // ucc end
     end;

    {
    // prorate the maxCCA for short years   MaxCCA=Tv[177]
    If Strings[206] = '' then
     Tv[177] := Tv[col16] * vl(Strings[Col17]) / 100 * MaxBusDays / Constant[RY].FullYear +Tv[col9]; // MAX cca for the year
    xx:=Tv[177];
    Tv[col18]:=Tv[177];

    Tv[173]:=Tv[Col18];//202304
    Tv[Col19]:=MaxR(0,Tv[Col7]-Tv[Col18]);  //20230426
    }

    if Strings[36]='' then //used for CCA not fo record keeping
    Begin
     //20260221
     //copy Col[] data into the ELM'sof the form
     xx:=Tv[col13];
     Tv[158]:=Tv[Col3];
     Tv[44]:=Tv[Col4];
     Tv[18]:=Tv[Col5];
     Tv[45]:=Tv[Col6];
     Tv[46]:=Tv[Col7];
     Tv[47]:=Tv[Col8];
     Tv[48]:=Tv[Col9];
     Tv[50]:=Tv[Col11];
     Tv[53]:=Tv[Col15];
     Tv[55]:=Tv[Col16];
     Tv[5]:=Tv[col17]; //Tv[Col16];
     Tv[54]:=Tv[Col17];
     Tv[167]:=Tv[col18];
     Tv[170]:=Tv[Col19];
    end
    Else  //record keeping only
    Begin
     Tv[158]:=0;
     Tv[44]:=0;
     Tv[18]:=0;
     Tv[45]:=0;
     Tv[46]:=0;
     Tv[47]:=0;
     Tv[48]:=0;
     Tv[19]:=0;
     Tv[50]:=0;
     Tv[51]:=0;
     Tv[53]:=0;
     Tv[54]:=0;
     Tv[167]:=0;
     Tv[170]:=0;
     Tv[173]:=0;
     Tv[176]:=0;
     Tv[177]:=0;

     Tv[col3]:=0;
     Tv[col4]:=0;
     Tv[col5]:=0;
     Tv[col6]:=0;
     Tv[col7]:=0;
     Tv[col8]:=0;
     Tv[col9]:=0;
     Tv[col12] := 0;
     Tv[col16]:=0;
     Strings[17]:='';  //cca
     Tv[col18] := 0;
     Tv[col19] := 0;
    end;

    Tv[3]:=0;  //20230610
    //??? for i:=233 to 235 do Ret[RetNo].Frm[FNo].Strings[i]:=''; //*** NO override allowed here
    i := 215;
    Repeat
    If Strings[i] > '' then
    begin
      BusDays := CalcBusDays(RetNo, Strings[i]);
      If MaxBusDays > 0 then
      Begin
          Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays //jz//20260205 - with the overrides removed it is the same statement no matter the condition, simplify code
                    {
                    if (i+3=218) then
                    Begin
                      // If (Ret[RetNo].Frm[FNo].Strings[233]='') then //override
                      Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
                      // Else
                      //  Tv[i + 3] :=Tv[236];
                    End;

                    if (i+3=224) then
                    Begin
                      //If (Ret[RetNo].Frm[FNo].Strings[234]='') then //override
                      Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays;
                      //Else
                      // Tv[i + 3] :=Tv[237];
                    End;

                    if (i+3=230) then
                    Begin
                      //If (Ret[RetNo].Frm[FNo].Strings[235]='') then //override
                      Tv[i + 3] := Tv[177] * (Tv[i + 1] / 100) * BusDays / MaxBusDays
                      //Else
                      // Tv[i + 3] :=Tv[238];
                    End;
                    }
      end  //max bus days
      Else
      begin
        Tv[i + 2] := 0;
        Tv[i + 3] := 0;
      end;
    end;

    //jz//20260205 - Tv[2]:=Tv[2]+TV[i+3];
                    //probably meant Tv[3]:= instead of 2
                    //and add :=Tv[3]
                    //and i+2 instead of just 2
    Tv[3]:=Tv[3]+Tv[i+2]+Tv[i+3]; //total CCA Claimed
    xx:=Tv[i+2];
    xx:=Tv[i+3];
    xx:=Tv[3];
    Inc(i, 6);
    until i > 227;
  end; //End with
  SaveTv(RetNo, FName, FNo);

End;
*)


procedure T1279(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Tv[2]:=TotMultiple(RetNo,'T101',22)+TotMultiple(RetNo,'T101',10)+TotMultiple(RetNo,'T5013',58); //20231212
    Tv[3]:=Tv[2]*30/100;
    Tv[4]:=Tv[3];
    Tv[5]:=Tv[1]+Tv[4];

    Tv[6]:=Vl(FetchElm(RetNo,'SK428',125));  //jz//20260108 - correct line it populates from
    if IsMultJurisdiction(RetNo) then        //jz//20260108 - add if isMJ as per form
      Tv[6]:=Vl(FetchElm(RetNo,'SKMJ',114));

    Tv[7]:=MinR(Tv[5],Tv[6]);
    Tv[8]:=Tv[5];
    Tv[9]:=Tv[7];
    Tv[10]:=MaxR(0,Tv[8]-Tv[9]);

    if Strings[14]='' then Strings[14]:=FormatDateTime('yyyy-mm-dd',Now);

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



procedure T1248(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   //20240323
   for i:=1 to 3 do Strings[i]:='';  //init   //4 option out //20240428b
   //20240428B
   if FetchElmFNo(RetNo,InfoFNo,251)>'' then Strings[1]:='X'; //non Resident
   if FetchElmFNo(RetNo,InfoFNo,252)>'' then Strings[2]:='X'; //deemed non Resident
   if IsFactualResident(RetNo) then Strings[3]:='X';

  // if IsDeemedResident(RetNo) then Strings[4]:='X'; //non Resident other reasons //20240124
   //if FetchElmFNo(RetNo,InfoFNo,253)>'' then Strings[4]:='X'; //non Resident other reasons //20240124
   //if FetchElmFNo(RetNo,InfoFNo,254)>'' then Strings[4]:='X'; //non Resident other reasons
   {
   // *************************************************
   if UpperCase(strings[1]+strings[2])='XX' then Strings[1]:='';
   if UpperCase(strings[1]+strings[3])='XX' then Strings[1]:='';
   if UpperCase(strings[2]+strings[3])='XX' then Strings[2]:='';
   }
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;




//jz//20260328//MJCERT2025 - NOT USED???? MOVED TO CalcMJ2  >>>>>>>>>>>>>>>>>>>>
(*




//20240605
Procedure ABMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=656;  //Spouse credit in T2203
 T2203EligDependantElm=657;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606
 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('AB');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    Tv[46]:=0;
    //find dependands for caregiver from S5PRV.
    i:=18; //index to s5prv
    K:=1;
    while i<=81 do //20240605
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       xx:=Tv[31];
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
       Tv[46]:=Tv[46]+Tv[35];
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
 end;

 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure BCMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=604;  //Spouse credit in T2203
 T2203EligDependantElm=605;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;


 InitPrvConstants('BC');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure MBMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=556;  //Spouse credit in T2203
 T2203EligDependantElm=557;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('MB');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       xx:=Tv[31];
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

{
//20250425 see calc2
//20240605
Procedure NBMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=530;  //Spouse credit in T2203
 T2203EligDependantElm=531;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606


 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('NB');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;
}
//20240605
Procedure NLMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=304;  //Spouse credit in T2203
 T2203EligDependantElm=305;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 T2203FNo:=GetFormNo('T2203'); //20240606
 InitPrvConstants('NL');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure ONMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=504;  //Spouse credit in T2203
 T2203EligDependantElm=505;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('ON');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure PEMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=330;  //Spouse credit in T2203
 T2203EligDependantElm=331;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('PE');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure SKMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=630;  //Spouse credit in T2203
 T2203EligDependantElm=631;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('SK');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure NSMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=356;  //Spouse credit in T2203
 T2203EligDependantElm=357;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('NS');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure NUMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=856;  //Spouse credit in T2203
 T2203EligDependantElm=857;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('NU');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more

 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure NTMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=830;  //Spouse credit in T2203
 T2203EligDependantElm=831;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
  T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('NT');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

*)
//jz//20260328//MJCERT2025 - NOT USED???? MOVED TO CalcMJ2  <<<<<<<<<<<<<<<<<<<<

//20251008 Igor >>>
procedure T657(RetNo: Integer; FName: string; FNo: Integer);
type
  TchartInfo = record
    maxCapGainsDedP1: real;
    maxCapGainsDedP2: real;
    maxClaimElmP1: integer;
    maxClaimElmP2: integer;
 end;

const
  chartYr: array[2016..2025] of TchartInfo = (
    (maxCapGainsDedP1: 412088; maxCapGainsDedP2: 500000; maxClaimElmP1: 41;  maxClaimElmP2: 53),  //2016
    (maxCapGainsDedP1: 417858; maxCapGainsDedP2: 500000; maxClaimElmP1: 66;  maxClaimElmP2: 81),  //2017
    (maxCapGainsDedP1: 424126; maxCapGainsDedP2: 500000; maxClaimElmP1: 94;  maxClaimElmP2: 147), //2018
    (maxCapGainsDedP1: 433456; maxCapGainsDedP2: 500000; maxClaimElmP1: 161; maxClaimElmP2: 173), //2019
    (maxCapGainsDedP1: 441692; maxCapGainsDedP2: 500000; maxClaimElmP1: 190; maxClaimElmP2: 206), //2020
    (maxCapGainsDedP1: 446109; maxCapGainsDedP2: 500000; maxClaimElmP1: 222; maxClaimElmP2: 237), //2021
    (maxCapGainsDedP1: 456815; maxCapGainsDedP2: 500000; maxClaimElmP1: 253; maxClaimElmP2: 269), //2022
    (maxCapGainsDedP1: 485595; maxCapGainsDedP2: 500000; maxClaimElmP1: 286; maxClaimElmP2: 301), //2023
    (maxCapGainsDedP1: 508418; maxCapGainsDedP2: 625000; maxClaimElmP1: 335; maxClaimElmP2: 383), //2024
    (maxCapGainsDedP1: 522145; maxCapGainsDedP2: 625000; maxClaimElmP1: 012; maxClaimElmP2: 183)  //2025 //jz//20260126
  );

    //maxCapitalGainsDeductionPart1 : array[15..24] of real = (406800,412088,417858,424126,433456,
    // 441692,446109,456815,485595,508418);
    //maxCapitalGainsDeductionPart2Pre2024  = 500000;
    //maxCapitalGainsDeductionPart22024     = 625000;

var
  i, S3FNo, CfrFNo: Integer;
  IR: Real;
  AnnualGainsLimit, CumulativeGainsLimit, TotalEligibleCapGain, x: Real;
  line18ofStep1, line17ofStep2: Real;
  chartYrMaxClaim: Real;
  Period1, Period2: Boolean; //if it they have dispositions

  procedure calcT657AnnualGainsLimit();
  begin
    with Ret[RetNo], Ret[RetNo].Frm[FNo] do
    begin
      //annual gains limit
      Tv[101]:= Vl(FetchElmFNo(RetNo, S3FNo, 173)) + Vl(FetchElmFNo(RetNo, S3FNo, 186)) + Vl(FetchElmFNo(RetNo, S3FNo, 195)); //20251203 Igor
      //Tv[101]:= Vl(FetchElmFNo(RetNo, S3FNo, 106)) + Vl(FetchElmFNo(RetNo, S3FNo, 114)) + Vl(FetchElmFNo(RetNo, S3FNo, 122));
               // +TotMultiple(RetNo,'T3MULT',88);   //20250506
      Tv[16]:= Vl(FetchElm(RetNo, 'T2017', 40)); //Vl(FetchElm(RetNo,'T2017',21))+Vl(FetchElm(RetNo,'T2017',22)); //20141225
      //Tv[102]:= Vl(FetchElmFNo(RetNo, S3FNo, 173)) + Vl(FetchElmFNo(RetNo, S3FNo, 186)) + Vl(FetchElmFNo(RetNo, S3FNo, 195));
      TV[411]:= Tv[101] + Tv[16];// + Tv[102];
      //MaxR(0,Tv[101]+Tv[16]);
      //xx:=Tv[101]+Tv[16]+Tv[102];

      //Tv[135]:= Vl(FetchElm(RetNo, 'T2017', 44)) + Vl(FetchElm(RetNo, 'T2017', 77));
      //Tv[139]:= Tv[411] - Tv[135];
      Tv[416]:= Tv[411] / 2; //20251020 Igor //Tv[139] / 2;

      Tv[199]:= Vl(FetchElm(RetNo,'T2048',70));   //lnn17216 //jz//20260128 - adjust elm  //Vl(FetchElm(RetNo,'T2048',??));

      Tv[313]:=Tv[416]-Tv[199];

      Tv[129]:= Vl(FetchElmFNo(RetNo, S3FNo, 339));
      Tv[109]:= Vl(FetchElmFNo(RetNo, S3FNo, 288)); //20251203 Igor // Vl(FetchElmFNo(RetNo, S3FNo, 127)) + Vl(FetchElmFNo(RetNo, S3FNo, 288));
      Tv[104]:= MaxR(0, Tv[109] / 2);
      Tv[137]:= Tv[129] - Tv[104];

      Tv[314]:= Vl(FetchElm(RetNo,'T2048',63));  //lnn17215 //jz//20260128 - adjust elm //Vl(FetchElm(RetNo,'T2048',??));

      Tv[367]:= Tv[137]-Tv[314];
      Tv[107]:= MinR(Tv[313], Tv[367]);         //jz//20260127 - as per form is min not subtraction //Tv[313]-Tv[367];

      Tv[108]:= Ret[RetNo].Lnn[25300];
      Tv[130]:= Vl(FetchElm(RetNo, 'T936', 142));
      Tv[138]:= MaxR(0, Tv[108] - Tv[130]);
      Tv[385]:= Tv[138];
      Tv[110]:= Ret[RetNo].Lnn[21700];
      Tv[409]:= Vl(FetchElm(RetNo,'T2048',74));  //17217 //jz//20260128 - adjust elm //Vl(FetchElm(RetNo,'T2048',??));
      TV[410]:=Tv[110]-Tv[409];
      Tv[111]:= Tv[410]; //Tv[138] + Tv[110];
      Tv[112]:= Tv[385]+Tv[111];
      Tv[412]:= Tv[112];

      Tv[113]:= MaxR(0, Tv[107] - Tv[412]);
      AnnualGainsLimit:= Tv[113];
    end;
  end;

  //20260125
  procedure calcT657CumulativeGainsLimit();
  var
    i: Integer;
  begin
    with ret[RetNo], ret[RetNo].Frm[FNo] do
    begin
      //PART 2 cumulative //cumulative gains limit
      Tv[114]:= Vl(FetchElmFNo(RetNo, CFRFNo, 1)) + Vl(FetchElmFNo(RetNo, CFRFNo, 2)) + Vl(FetchElmFNo(RetNo, CFRFNo, 3));

      { //20250420    Why zero?
        Tv[141]:=0;//Tv[];
        Tv[142]:=0;//Tv[];
        Tv[143]:=0;//Tv[];
        Tv[144]:=0;//Tv[];
        Tv[145]:=0;//Tv[];
        Tv[146]:=0;//Tv[];
        Tv[2]  :=0;//Tv[];
        Tv[4]  :=0;//Tv[];
        Tv[3]  :=0;//Tv[];
        Tv[26] :=0;//Tv[];
        Tv[73] :=0;//Tv[];
        Tv[19] :=0;//Tv[];
        Tv[38] :=0;//Tv[];
        Tv[154]:=0;//Tv[];
        Tv[196]:=0;//Tv[108];
        Tv[267]:=0;//Tv[108];   //20211222
        Tv[284]:=0;
        Tv[186]:=0; }
      Tv[420]:= Tv[416];  //20260106
      Tv[136]:= Tv[141] + Tv[142] + Tv[143] + Tv[144] + Tv[145] + Tv[146] + Tv[2] + Tv[4] + Tv[3] + Tv[26] + Tv[73] + Tv[19] + Tv[38] + Tv[38] + Tv[154] + Tv[196] + Tv[267] + Tv[284] + Tv[186] + Tv[421] + Tv[420];
      Tv[119]:= Tv[114] + Tv[115] + Tv[116] + Tv[117] + Tv[133] + Tv[134] + Tv[140] + Tv[136];
      //Tv[119]:= Tv[118];
      Tv[120]:= MinR(2000, Vl(FetchElmFNo(RetNo, CFRFNo, 409)));

      {abil prior years}
      Tv[121]:= 0;
      Tv[121]:= Tv[121]
             + Vl(FetchElmFNo(RetNo, CFRFNo, 21))
             + Vl(FetchElmFNo(RetNo, CFRFNo, 22))
             + Vl(FetchElmFNo(RetNo, CFRFNo, 23))
             + Vl(FetchElmFno(RetNo, CFRFNo, 24))
             + Vl(FetchElmFno(RetNo, CFRFNo, 25))
             + Vl(FetchElmFno(RetNo, CFRFNo, 37))
             + Vl(FetchElmFno(RetNo, CFRFNo, 45))
             + Vl(FetchElmFno(RetNo, CFRFNo, 50))
             + Vl(FetchElmFno(RetNo, CFRFNo, 57))
             + Vl(FetchElmFno(RetNo, CFRFNo, 61))
             + Vl(FetchElmFno(RetNo, CFRFNo, 70))
             + Vl(FetchElmFno(RetNo, CFRFNo, 71))
             + Vl(FetchElmFno(RetNo, CFRFNo, 81))
             + Vl(FetchElmFno(RetNo, CFRFNo, 87))
             + Vl(FetchElmFno(RetNo, CFRFNo, 92))
             + Vl(FetchElmFno(RetNo, CFRFNo, 97)) //20140407
             + Vl(FetchElmFno(RetNo, CFRFNo, 267))
             + Vl(FetchElmFno(RetNo, CFRFNo, 272))
             + Vl(FetchElmFno(RetNo, CFRFNo, 277))
             + Vl(FetchElmFno(RetNo, CFRFNo, 282))  //20151116
             + Vl(FetchElmFno(RetNo, CFRFNo, 287))  //20161210
             + Vl(FetchElmFno(RetNo, CFRFNo, 292))  //20190921
             + Vl(FetchElmFno(RetNo, CFRFNo, 297))  //20190921
             + Vl(FetchElmFno(RetNo, CFRFNo, 302))  //20201017
             + Vl(FetchElmFno(RetNo, CFRFNo, 307))  //20201017
             + Vl(FetchElmFno(RetNo, CFRFNo, 312))  //20211221
             + Vl(FetchElmFno(RetNo, CFRFNo, 317))  //20221219
             + Vl(FetchElmFno(RetNo, CFRFNo, 322)) //2021 //20231111
             + Vl(FetchElmFno(RetNo, CFRFNo, 327)) //2023 //20251020 Igor
             + Vl(FetchElmFno(RetNo, CFRFNo, 331)); //2024 //20251020 Igor

      Tv[413]:= Vl(FetchElm(RetNo,'T2048',74)); //lnn17217 //jz//20260128 - adjust elm //Vl(FetchElm(RetNo,'T2048',??));
      Tv[414]:= Tv[121]-Tv[413];
      Tv[415]:= Tv[414];
      Tv[122]:= Tv[417]; //Tv[417]; //20250419 //Tv[389]; //20141225 Vl(FetchElm(RetNo,'T657',389));//20120730 Vl(FetchElm(RetNo,'T657',489));
      Tv[123]:= Tv[412];
      Tv[124]:= MaxR(0, Vl(FetchElm(RetNo, 'T936', 150)));

      Tv[125]:= 0;
      for i:= 16 to 20 do Tv[125]:= Tv[125] + Vl(FetchElmFNo(RetNo, CFRFNo, i));
      Tv[125]:= Tv[125]
           + Vl(FetchElmFNo(RetNo, CfrFNo, 36))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 44))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 49))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 56))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 62))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 69))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 60))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 80))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 86))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 91))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 96))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 266))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 271))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 276))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 281)) //20170419
           + Vl(FetchElmFNo(RetNo, CfrFNo, 286))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 291))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 296))
           + Vl(FetchElmFNo(RetNo, CfrFNo, 301))  //20201017
           + Vl(FetchElmFNo(RetNo, CfrFNo, 306))  //20201017
           + Vl(FetchElmFNo(RetNo, CfrFNo, 311))  //20201017
           + Vl(FetchElmFNo(RetNo, CfrFNo, 316))  //20201017
           + Vl(FetchElmFNo(RetNo, CfrFNo, 321))  //20231111
           + Vl(FetchElmFNo(RetNo, CfrFNo, 326)) //2023 //20250419
           + Vl(FetchElmFNo(RetNo, CfrFNo, 330)); //2024 //20251020 Igor

      Tv[126]:=Tv[120]+Tv[415]+Tv[122]+Tv[123]+Tv[124]+Tv[125];
      Tv[127]:= Tv[126];
      Tv[128]:= MaxR(0, (Tv[119] - Tv[127]));
      CumulativeGainsLimit:= Tv[128];
    end;
  end;

  procedure doT657Questionnare();
  begin //questionnare
    with Ret[RetNo].Frm[FNo] do
    begin
      //init Q checkboxes
      if (Strings[426] + Strings[427] = '') then Strings[427] :='X'; //2016
      if (Strings[428] + Strings[429] = '') then Strings[429] :='X'; //2016
      if (Strings[430] + Strings[431] = '') then Strings[431] :='X'; //2017
      if (Strings[432] + Strings[433] = '') then Strings[433] :='X'; //2017
      if (Strings[434] + Strings[435] = '') then Strings[435] :='X'; //2018
      if (Strings[436] + Strings[437] = '') then Strings[437] :='X'; //2018
      if (Strings[438] + Strings[439] = '') then Strings[439] :='X'; //2019
      if (Strings[440] + Strings[441] = '') then Strings[441] :='X'; //2019
      if (Strings[386] + Strings[387] = '') then Strings[387] :='X'; //2020
      if (Strings[388] + Strings[389] = '') then Strings[389] :='X'; //2020
      if (Strings[446] + Strings[447] = '') then Strings[447] :='X'; //2021
      if (Strings[448] + Strings[449] = '') then Strings[449] :='X'; //2021
      if (Strings[450] + Strings[451] = '') then Strings[451] :='X'; //2022
      if (Strings[452] + Strings[453] = '') then Strings[453] :='X'; //2022
      if (Strings[454] + Strings[455] = '') then Strings[455] :='X'; //2023
      if (Strings[456] + Strings[457] = '') then Strings[457] :='X'; //2023
      if (Strings[458] + Strings[459] = '') then Strings[459] :='X'; //2024
      if (Strings[460] + Strings[461] = '') then Strings[461] :='X'; //2024

      if (Strings[458] + Strings[459] = '') then Strings[459] :='X'; //jz//20260125 - 'S3', 153 no longer exists, make manual entry
      if (Strings[460] + Strings[461] = '') then Strings[461] :='X'; //jz//20260125

      //step 3b
      if (Strings[442] + Strings[443] = '') then Strings[443] :='X'; //2025
      if (Strings[418] + Strings[419] = '') then Strings[419] :='X'; //20260125

      //jz//20260130 - 'S3', 153 no longer exists
                     //also dont think these were correct and not used anywhere any more
      {
      //20250412
      if (Vl(FetchElm(RetNo, 'S3', 153)) <> 0) then
      begin
        Strings[458]:= 'X';
        Strings[459]:= '';
        Period1:= True;
      end else
      begin
        Strings[458]:= '';
        Strings[459]:= 'X';
        Period1:= False;
      end;

      if (Vl(FetchElm(RetNo, 'S3', 283)) <> 0) then
      begin
        Strings[460]:= 'X';
        Strings[461]:= '';
        Period2:= True;
      end else
      begin
        Strings[460]:= '';
        Strings[461]:= 'X';
        Period2:= False;
      end;
      }
    end;
  end;

  procedure calcT657CHART2016();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART 2016 part 1
      Tv[28]:= chartYr[2016].maxCapGainsDedP1; //line A

      //CHART 2016 part 2
      Tv[42]:= chartYr[2016].maxCapGainsDedP2; //line A
    end;
  end;

  procedure calcT657CHART2017();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART 2017 part 1
      Tv[54]:= chartYr[2017].maxCapGainsDedP1; //line A

      //CHART 2017 part 2
      Tv[67]:= chartYr[2017].maxCapGainsDedP2; //line A
    end;
  end;

  procedure calcT657CHART2018();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART 2018 part 1
      Tv[82]:= chartYr[2018].maxCapGainsDedP1; //line A

      //CHART 2018 part 2
      Tv[95]:= chartYr[2018].maxCapGainsDedP2; //line A
    end;
  end;

  procedure calcT657CHART2019();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART 2019 part 1
      Tv[148]:= chartYr[2019].maxCapGainsDedP1; //line A

      //CHART 2019 part 2
      Tv[162]:= chartYr[2019].maxCapGainsDedP2; //lineA
    end;
  end;

  procedure calcT657CHART2020();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART 2020 part1 1
      Tv[174]:= chartYr[2020].maxCapGainsDedP1; //line A

      //CHART 2020 part 2
      Tv[191]:= chartYr[2020].maxCapGainsDedP2; //line A
    end;
  end;

  procedure calcT657CHART2021();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART 2021 part 1
      Tv[207]:= chartYr[2021].maxCapGainsDedP1; //line A

      //CHART 2021 part 2
      Tv[223]:= chartYr[2021].maxCapGainsDedP2; //line A
    end;
  end;

  procedure calcT657CHART2022();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART 2022 part 1
      Tv[238]:= chartYr[2022].maxCapGainsDedP1; //line A

      //CHART 2022 part 2
      Tv[254]:= chartYr[2022].maxCapGainsDedP2; //line A
    end;
  end;

  procedure calcT657CHART2023();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART 2023 part 1
      Tv[270]:= chartYr[2023].maxCapGainsDedP1; //lineA
      //Tv[271]:=; //lineB
      Tv[272]:= Tv[270] - Tv[271]; //lineC
      Tv[273]:= Tv[425];   //20250419
      Tv[274]:= maxR(0, Tv[272] - Tv[273]); //lineE
      //Tv[275]:=; //lineF
      //Tv[276]:=; //lineG
      Tv[277]:= maxR(0, Tv[275] + Tv[276]); //lineH
      Tv[278]:= Tv[277] * 0.5; //lineH
      //Tv[279]:=; //lineI
      Tv[280]:= Tv[279] * 0.5; //lineI
      Tv[281]:= Tv[278] + Tv[280]; //lineJ
      Tv[282]:= minR(Tv[274], Tv[281]); //lineK
      Tv[283]:= Tv[271]; //lineL
      Tv[285]:= Tv[282] + Tv[283]; //lineM

      //lineN
      if (Tv[286] = 0) then
        Tv[286]:= minR(Tv[285], MinR(line18ofStep1, line17ofStep2))
      else
        Tv[286]:= minR(Tv[286], (MinR(Tv[285], MinR(line18ofStep1, line17ofStep2))));

      //CHART 2023 part 2
      Tv[287]:= chartYr[2023].maxCapGainsDedP2; //lineA
      //Tv[288]:=; //lineB
      Tv[289]:= Tv[287] - Tv[288]; //lineC
      //Tv[290]:=; //lineD
      Tv[291]:= maxR(0, Tv[289] - Tv[290]); //lineE
      //Tv[292]:=; //lineF
      Tv[293]:= Tv[292] * 0.5; //lineF
      //Tv[294]:=; //lineG
      Tv[295]:= Tv[294] * 0.5; //lineG
      Tv[296]:= Tv[293] + Tv[295]; //lineH
      Tv[297]:= minR(Tv[291], Tv[296]); //20251020 Igor
      Tv[298]:= Tv[288]; //lineJ
      Tv[299]:= Tv[297] + Tv[298]; //lineK
      Tv[300]:= minR(Tv[296], Tv[299]); //lineL

      //lineM
      if (Tv[301] = 0) then
        Tv[301]:= minR(Tv[300], MinR(line18ofStep1, line17ofStep2))
      else
        Tv[301]:= minR(Tv[301], (MinR(Tv[300], MinR(line18ofStep1, line17ofStep2))));
    end;
  end;

  procedure calcT657CHART2024();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART 2024 PART 1
      Tv[304]:= chartYr[2024].maxCapGainsDedP1; //lineA
      //Tv[305]:=???; //lineB
      Tv[18]:= Tv[304] - Tv[305]; //lineC
      Tv[306]:= Tv[425]; //lineD
      Tv[309]:= maxR(0, Tv[18] - Tv[306]); //lineE
      //Tv[313]:= Vl(FetchElm(RetNo, S3FNo, 114)); //lineG
      //Tv[314]:= Vl(FetchElm(RetNo, S3FNo, 122)); //lineH
      Tv[317]:= Vl(FetchElm(RetNo, 'T2017', 32)); //lineI
      Tv[320]:= Vl(FetchElm(RetNo, 'T2017', 39)); //lineJ
      //Tv[312]:= Vl(FetchElm(RetNo, 'T3MULT', ????????????????????????????????)); //lineH
      Tv[321]:= Tv[317] + Tv[320] + Tv[312]; //+ Tv[313] + Tv[314]
      Tv[322]:= Tv[321] * 0.5; //lineK

      //Tv[29]:=  vtUser from T2048 //jz//20260128 - not sure, leave as vtUser for now
      Tv[30]:= Tv[322]-Tv[29];

      Tv[325]:= minR(Tv[309], Tv[30]); //lineL
      Tv[327]:= Tv[305]; //lineM
      Tv[333]:= Tv[325] + Tv[327]; //lineN


      //lineO
      xx:= minR(Tv[333], MinR(AnnualgainsLimit, CumulativeGainsLimit)); //20250411
      Tv[335]:= xx;

      {//jz//20260130 - don't think this was ever correct, remove
      if not Period1 then
      begin
        xx:= 0;
        Tv[335]:= 0;
      end;
      }

      //TV[221]:=Tv[335];     //20250411 DO NOT do it here
      // minR(Tv[333],MinR(AnnualgainsLimit,CumulativeGainsLimit)); //20250411
      {if Tv[335]=0 then
        Tv[335]:= minR(Tv[333],MinR(line18ofStep1,line17ofStep2))
      else
        Tv[335]:= minR(Tv[335],(MinR(Tv[333],MinR(line18ofStep1,line17ofStep2))));       }

      //CHART 2024 PART 2
      Tv[341]:= chartYr[2024].maxCapGainsDedP2;     //lineA
      Tv[343]:= Tv[333];                            //lineB
      Tv[345]:= maxR(0, Tv[341] - Tv[343]);         //lineC
      Tv[349]:= Tv[425];                            //lineD
      Tv[351]:= maxR(0, Tv[345] - Tv[349]);         //lineE
      Tv[365]:= Vl(FetchElm(RetNo, 'T2017', 30));   //lineF
      //Tv[367]:= maxR(0, Tv[361] - Tv[365]);       //lineK
      Tv[369]:= Vl(FetchElm(RetNo, 'T2017', 39));   //lineG
      //Tv[361]:= Vl(FetchElm(RetNo, 'T3MULT', ????????????????????????????????)); //lineH
      Tv[373]:= Tv[365] + Tv[369] + Tv[361];
      //Tv[373]:= maxR(0, Tv[367] - Tv[369]);
      Tv[375]:= Tv[373] * 0.5;                      //lineI
      //Tv[37]:= vtUser from T2048 //jz//20260128 - not sure, leave as vtUser for now
      Tv[37]:= minR(Tv[351], Tv[375]);
      Tv[39]:=Tv[375]-Tv[37];
      Tv[377]:=MinR(Tv[351],Tv[39]);                //lineL

      Tv[381]:= Tv[343];                            //lineM
      Tv[382]:= Tv[377] + Tv[381];                  //lineN

      //Line0//20250411
      xx:= minR(Tv[382], MinR(AnnualgainsLimit, CumulativeGainsLimit)); //20250411
      Tv[383]:= xx;

      {//jz//20260130 - don't think this was ever correct, remove
      if not Period2 then
      begin
        xx:= 0;
        Tv[383]:= 0;
      end; //20250412
      }
      {//lineQ
      if Tv[383]=0 then
        Tv[383]:= minR(Tv[382],MinR(line18ofStep1,line17ofStep2))
      else
        Tv[383]:= minR(Tv[383],(MinR(Tv[382],MinR(line18ofStep1,line17ofStep2))));       }
    end;
  end;

  procedure calcT657CHART2025();
  begin
    with ret[RetNo].Frm[FNo] do
    begin
      //CHART2025 PART 1
      Tv[1]   := chartYr[2025].maxCapGainsDedP1; //lineA
      //Tv[200]:=; //lineB
      Tv[201] := Tv[1] - Tv[200]; //lineC
      Tv[5]   := Tv[425]; //lineD
      Tv[6]   := maxR(0, Tv[201] - Tv[5]); //lineE

        //jz//20260217 - getting from the wrong place, these fetches belong in part 2
        //Tv[353] := Vl(FetchElm(RetNo, S3FNo, 173)); //lineF
        //Tv[357] := Vl(FetchElm(RetNo, S3FNo, 186)); //lineG
        //Tv[359] := Vl(FetchElm(RetNo, S3FNo, 195)); //lineH

      Tv[7]   := Vl(FetchElm(RetNo, 'T2017', 30)); //lineI
      Tv[8]   := Vl(FetchElm(RetNo, 'T2017', 39)); //lineJ
      Tv[9]   := Tv[353] + Tv[357] + Tv[359] + Tv[7] + Tv[8]; //lineI
      Tv[10]  := Tv[9] * 0.5; //lineK

        //Tv[444] := vtUser
      Tv[445] := Tv[10]-Tv[444];        //20260130
      Tv[184] := minR(Tv[6], Tv[445]);  //20260130 Tv[184] := minR(Tv[6], Tv[10]); //lineL

      Tv[185] := Tv[200];           //lineM
      Tv[11]  := Tv[184] + Tv[185]; //lineN

      //lineO 2025 //jz//20260130
      Tv[12]:= minR(Tv[11], MinR(AnnualgainsLimit, CumulativeGainsLimit)); xx:= Tv[12];
    end;

    //jz//20250126 - combine 2025 part 1 and 2
    //CHART2025 PART 2
    with ret[RetNo].Frm[FNo] do
    begin
      Tv[13]  := chartYr[2025].maxCapGainsDedP2; //lineA, part2  //jz//20250126 - change to maxCapGainsDedP2 instead of maxCapGainsDedP1
      xx := Tv[13];
      Tv[15]  :=Tv[13]-Tv[14];
      Tv[17]  :=Tv[425];
      Tv[20]  :=MaxR(0,Tv[15]-Tv[17]);

      //jz//20260217 - get values, need to subtract values from as per form??
      Tv[21] := Vl(FetchElm(RetNo, S3FNo, 173)); //lineF
      Tv[22] := Vl(FetchElm(RetNo, S3FNo, 186)); //lineG
      Tv[23] := Vl(FetchElm(RetNo, S3FNo, 195)); //lineH

      Tv[27]  :=MaxR(0,Tv[21]+Tv[22]+Tv[23]+TV[24]+Tv[25]);
      Tv[74]  :=Tv[27];
      //Tv[75]:= vtUser //jz//20260128 - not sure where from on T2048, leave as vtUser for now
      Tv[102] :=Tv[74]+Tv[75];
      Tv[131] :=MinR(Tv[20],Tv[102]);
      Tv[135] :=Tv[14];
      Tv[139] :=Tv[131]+Tv[135];

      //lineP 2025 //jz//20260130
      Tv[183]:= minR(Tv[139], MinR(AnnualgainsLimit, CumulativeGainsLimit)); xx:=Tv[183];

          //jz//20250126 - this is done after, remove
            //top of the Form
            //Tv[221] :=MinR(Tv[113],MinR(AnnualgainsLimit,CumulativeGainsLimit));
    end;

  end;


  procedure calcT657CHART1();
  begin
    //PAGE 26
    //CHART1
    with ret[RetNo].Frm[FNo] do
    begin
      Tv[417]:= 0;//Tv[389] := 0;  //20250419
      Tv[307]:= Tv[303];
      Tv[308]:= MaxR(0, Tv[302] - Tv[307]);
      Tv[315]:= Tv[311];
      Tv[316]:= MaxR(0, Tv[310] - Tv[315]);
      Tv[323]:= Tv[319];
      Tv[324]:= MaxR(0, Tv[318] - Tv[323]);
      Tv[330]:= MaxR(0, Tv[328] - Tv[329]);
      Tv[331]:= Tv[330];
      Tv[340]:= MaxR(0, Tv[326] - Tv[331]);
      Tv[338]:= MaxR(0, Tv[336] - Tv[337]);
      Tv[339]:= Tv[338];
      Tv[332]:= MaxR(0, Tv[334] - Tv[339]);

      //20250420
      Tv[417]:= Tv[308] + Tv[316] + Tv[324] + Tv[340] + Tv[332];
      i:= 342;
      repeat
        Tv[i + 4]:= Tv[i + 2];
        Tv[i + 5]:= Tv[i + 4];
        Tv[i + 6]:= MaxR(0, Tv[i] - Tv[i + 5]);
        //Tv[417]:= Tv[417] + MaxR(0, Tv[i] - Tv[i + 5]);
        Inc(i, 8);
      until i > 374;

      Tv[417]:= Tv[417] + Tv[348] + Tv[356] + Tv[364] + Tv[372] + Tv[380];
    end;
  end;

  procedure calcT657CHART2();  //20250419
  begin
    // CHART 2  PAGE 27
    with Ret[RetNo].Frm[FNo] do
    begin
      Tv[390]:= Vl(FetchElmFNo(RetNo, CfrFNo, 16)); {85,86,87}
      Tv[391]:= MaxR(0, Vl(FetchElmFNo(RetNo, CfrFNo, 7)) {88-89}
                - Vl(FetchElmFNo(RetNo, CfrFNo, 26))
                - Vl(FetchElmFNo(RetNo, CfrFNo, 27)));
      Tv[392]:= Tv[390] + Tv[391]; //Tv[391]/4;
      Tv[393]:= Tv[391]; //MaxR(0,Vl(FetchElmFNo(RetNo,CfrFNo,17))- Tv[391]);
      Tv[394]:= Tv[393] / 4;
      Tv[395]:= MaxR(0, Tv[392] - Tv[394]);
      Tv[396]:= Vl(FetchElmFNo(RetNo, CfrFNo, 8)) + {90-99}
                 Vl(FetchElmFNo(RetNo, CfrFNo, 9)) +
                 Vl(FetchElmFNo(RetNo, CfrFNo, 10));
      Tv[397]:= Tv[395] + Tv[396];
      Tv[398]:= Tv[396];
      Tv[399]:= Tv[398] / 3;
      Tv[400]:= MaxR(0, Tv[397] - Tv[399]);
      Tv[401]:= Vl(FetchElmFNo(RetNo, CfrFNo, 8))+ {90-99}
                Vl(FetchElmFNo(RetNo, CfrFNo, 9))+
                Vl(FetchElmFNo(RetNo, CfrFNo, 10));
      TV[402]:= Tv[400] + Tv[401];
      Tv[403]:= Tv[401];
      Tv[404]:= Tv[403] / 3;
      Tv[405]:= MaxR(0, Tv[402] - Tv[404]);
      Tv[406]:= Vl(FetchElmFNo(RetNo, CfrFNo, 36));
      Tv[407]:= Tv[405] + Tv[406];
      Tv[408]:= Tv[406];
      Tv[422]:= Tv[408] * Tv[40] / 100;
      Tv[423]:= Tv[407] + Tv[422];
      Tv[424]:= vl(FetchElmFNo(RetNo, CfrFno, 44))
                + vl(FetchElmFNo(RetNo, CfrFno, 49))
                + vl(FetchElmFNo(RetNo, CfrFno, 56))
                + vl(FetchElmFNo(RetNo, CfrFno, 62))
                + vl(FetchElmFNo(RetNo, CfrFno, 69))
                + vl(FetchElmFNo(RetNo, CfrFno, 60))
                + vl(FetchElmFNo(RetNo, CfrFno, 80))
                + vl(FetchElmFNo(RetNo, CfrFno, 86))
                + vl(FetchElmFNo(RetNo, CfrFno, 91))
                + vl(FetchElmFNo(RetNo, CfrFno, 96))
                + vl(FetchElmFNo(RetNo, CfrFno, 266))
                + Vl(FetchElmFNo(RetNo, CfrFno, 271))
                + Vl(FetchElmFNo(RetNo, CfrFno, 276))
                + Vl(FetchElmFNo(RetNo, CfrFno, 281))
                + Vl(FetchElmFNo(RetNo, CfrFno, 286))
                + Vl(FetchElmFNo(RetNo, CfrFno, 291))
                + Vl(FetchElmFNo(RetNo, CfrFno, 296))   //20190108
                + Vl(FetchElmFNo(RetNo, CfrFno, 301))   //20200517
                + Vl(FetchElmFNo(RetNo, CfrFno, 306))   //20201017
                + Vl(FetchElmFNo(RetNo, CfrFno, 311))   //2023111
                + Vl(FetchElmFNo(RetNo, CfrFno, 316))   //2023111
                + Vl(FetchElmFNo(RetNo, CfrFno, 321))   //2023111
                + Vl(FetchElmFNo(RetNo, CfrFno, 326))   //202350419
                + Vl(FetchElmFNo(RetNo, CfrFno, 330)); //20251020 Igor
      Tv[425]:= MaxR(0, Tv[423] + Tv[424]);
    end;
  end; //end CHART2024

  procedure CalcChartYrMaxClaim();
  var
    i: Integer;
  begin
    chartYrMaxClaim := 0; //jz//20260130

    with Ret[RetNo].Frm[FNo] do
      for i:= low(chartYr) to High(chartYr) do
        if (Tv[chartYr[i].maxClaimElmP1] > 0) or (Tv[chartYr[i].maxClaimElmP2] > 0) then
        begin
          chartYrMaxClaim:= Tv[chartYr[i].maxClaimElmP1];
          if (Tv[chartYr[i].maxClaimElmP2] > 0) then chartYrMaxClaim:= Tv[chartYr[i].maxClaimElmP2];
        end;
  end;

begin //main Procedure T657(RetNo:integer;FName:string;FNo:integer);
  LoadTv(RetNo, FName, FNo);

  S3FNo:= GetFormNo('S3');
  CfrFNo:= GetFormNo('CFR');

  calcT657AnnualGainsLimit();
  calcT657CumulativeGainsLimit();

  doT657Questionnare();

  line18ofStep1:= AnnualGainsLimit;
  line17ofStep2:= CumulativeGainsLimit;

  calcT657CHART2016();
  calcT657CHART2017();
  calcT657CHART2018();
  calcT657CHART2019();
  calcT657CHART2020();
  calcT657CHART2021();
  calcT657CHART2022();
  calcT657CHART2023();
  calcT657CHART2024();
  calcT657CHART2025();

  //CAPTITAL GAINS DEDUCTION
  calcChartYrMaxClaim();
  ret[RetNo].Frm[FNo].Tv[221]:= minR(chartYrMaxClaim, minR(AnnualgainsLimit, CumulativeGainsLimit));

  calcT657CHART1();
  calcT657CHART2();

  SaveTv(RetNo,FName,FNo);

 End;

//20251008 Igor <<<

//20180303
Procedure OEPTC(RetNo:integer;FName:string;FNo:integer);
//https://www.canada.ca/en/revenue-agency/services/child-family-benefits/provincial-territorial-programs/2021-ontario-energy-property-tax-credit-optic-calculation-sheets.html
// http://www.cra-arc.gc.ca/E/pub/tg/5006-pc/5006-pc-16e.html#ontario_Trillium
//http://www.cra-arc.gc.ca/bnfts/rltd_prgrms/ntr-eng.html#ptc
//http://www.cra-arc.gc.ca/bnfts/rltd_prgrms/ntr-eng.html#nc
//http://www.cra-arc.gc.ca/bnfts/rltd_prgrms/nc17_clcltn_sht-eng.html   NOEC
Var I,OnBenFNo:integer;
    x,y,z,Faktor : real;
    HasSpouseOrQDep:Boolean;
Begin
   With ret[RetNo], ret[RetNo].Frm[FNo] do
   begin
     {? Age 16 any impact on ont credits}
     LoadTv(RetNo,FName,FNo);
     OnBenFNo:=GetFormNo('ONBEN');
     If (ret[RetNo].Province <> 'ON')
     Or (FetchElmFNo(RetNo,OnBenFNo,6)='')
     then
     begin
         for i := 1 to 101 do Tv[i] := 0;
         SaveTv(RetNo,FName,FNo);
         exit;
     end;
     //adjusted fam income
     Tv[1] := MaxR(0,Lnn[23600]);
     //oshptg
     //If ret[RetNo].Age <64 then Frm[FNo].Strings[4]:='';
     Tv[2] := ret[RetNo].Lnn[21300]+Vl(FetchElm(RetNo,'OTHDED',60));
     Tv[69] := Tv[1] + Tv[2];
     Tv[70]:=Lnn[11700]+Lnn[12500]; //+GetRC310Income(RetNo); //20170126
           // If Bankrupt <> 2 then Tv[5] :=0;  //??
     Tv[3]:=MaxR(0,Tv[69]-Tv[70]);
     If TV[5] >0 then Tv[3] := Tv[5]; {for bunkruptcy returns}

     Tv[72]:=Vl(FetchElm(RetNo,'INFO',19));
     Tv[73]:=Vl(FetchElm(RetNo,'INFO',162))+Vl(FetchElm(RetNo,'S2',34));
     Tv[75]:=Vl(FetchElm(RetNo,'INFO',131))+Vl(FetchElm(RetNo,'S2',33))+Vl(FetchElm(RetNo,'INFO',168)); //20101202
     Tv[74]:=Tv[72]+Tv[73];
     Tv[76]:=MaxR(0,Tv[74]-Tv[75]);

     If (ret[RetNo].MarStatus >2)
     or (OntarioInvoluntarySeparation(RetNo))   //involuntary  //20120324
     or (IsSpouseNonResident(RetNo)) then   //non resident
     begin
      for i:=72 to 76 do Tv[i]:=0;
     end;
     Tv[4]:=Tv[3]+Tv[76];
      //ocupancy
       Tv[6]:=Vl(FetchElmFNo(RetNo,OnBEnFNo,7));
       Tv[7]:=Tv[6]*20/100;
       Tv[8]:=Vl(FetchElmFNo(RetNo,ONBENFNo,8));
       If FetchElmFNo(RetNo,OnBEnFNo,10)>'' then Tv[9]:=25 else Tv[9]:=0;
       Tv[10]:=Tv[7]+Tv[8]+Tv[9];
       If (IsPreBankruptcyReturn(RetNo)) or (IsDeceased(RetNo)) then Tv[10]:=0;

       Tv[13]:=Vl(FetchElmFNo(RetNo,OnBEnFNo,13));
       Tv[15]:=Tv[13]*20/100;

       Tv[16]:=Vl(FetchElmFNo(RetNo,OnBEnFNo,12));
       Tv[17]:=Tv[10];
       Tv[18]:=Tv[15]+Tv[16]+Tv[17];
       Tv[19]:=Tv[9];
       Tv[20]:=MaxR(0,Tv[18]-Tv[19]);
       Tv[21]:=Tv[20];
       Tv[22]:=MinR(290,Tv[21]); //MinR(277,Tv[21]);  //20250317 40228

       If (ret[RetNo].Age <18) then  //energy component
       begin
        If ((ret[RetNo].MarStatus <3) or (Vl(FetchElm(RetNo,'DEPEND',1))>0))  //parent
        then
        //ok
        Else
        begin
          Tv[13]:=0;
          For i:=15 to 22 do Tv[i]:=0;
        end;
       end;

      If (IsPreBankruptcyReturn(RetNo)) or (IsDeceased(RetNo)) then Tv[22]:=0;
       Tv[33]:=Tv[10];
       Tv[12]:=Tv[33]*10/100;
       //20240228
       If (Ret[RetNo].Age < 64) then
        Tv[11] :=MinR(944,Tv[12]) //Tv[11] :=MinR(902,Tv[12])  //20260413
       else
        Tv[11] :=MinR(581,Tv[12]); //MinR(499,Tv[12]); // //20260504
       //20240228
       If (Ret[RetNo].Age < 64) then Tv[87]:=73 else Tv[87]:=617; //20260413

       Tv[80]:=Tv[11]+Tv[87];

       Tv[23]:=MinR(Tv[10],Tv[80]);

       If (ret[RetNo].Age <18) then  //Property tax component
       begin
        If ((ret[RetNo].MarStatus <3) or (Vl(FetchElm(RetNo,'DEPEND',1))>0))  //parent
        then
        //ok
        Else
        begin
          Tv[33]:=0; Tv[12]:=0;Tv[11]:=0;Tv[87]:=0;Tv[80]:=0;
          Tv[23]:=0;
        end;
       end;

       If FetchElm(RetNo,'INFO',166)>'' then //prison 90 days kill both energy and property
       begin
          Tv[13]:=0;
          For i:=15 to 22 do Tv[i]:=0;
          Tv[33]:=0; Tv[12]:=0;Tv[11]:=0;Tv[87]:=0;Tv[80]:=0;
          Tv[23]:=0;
       end;

       Tv[24]:=Tv[22]+Tv[23];
       Tv[101]:=Tv[24];
       Tv[88]:=0;Tv[89]:=0;Tv[34]:=0;Tv[67]:=0;
       Tv[78]:=0;

       HasSpouseOrQDep:=False;    //20120207
       If ret[RetNo].MarStatus <3 then HasSpouseOrQDep:=True;    //20120207
       If HasEligibleDependant(RetNo) then HasSpouseOrQDep:=True;    //20120207

       If UpperCase(FetchElmFNo(RetNo,ONBENFNO,31))='Y' then HasSpouseOrQDep:=False;  //involunt
       If HasDeceasedSpouse(RetNo) then HasSpouseOrQDep:=False;

       If (ret[RetNo].Age < 64)  then     //20140210
       begin
           If HasSpouseOrQDep = false then
           begin
               Tv[88]:=Tv[4];
               Tv[78] :=MaxR(0, Tv[88]-29047) *  0.02; //MaxR(0, Tv[88]-27729) *  0.02; //20240228
             end
           Else
           begin
               Tv[89]:=Tv[4];
               Tv[78] := MaxR(0,Tv[89]-36309) *  0.02;//MaxR(0,Tv[89]-34661) *  0.02; ////20240228
           end;
       end   //les than 65
       ELSE  // > 64 years
        begin
           If HasSpouseOrQDep = false then
           begin
               Tv[34]:=Tv[4];
               Tv[78] := MaxR(0,Tv[34]-36309) *  0.02; //MaxR(0,Tv[34]-34661) *  0.02; //20240228
           end
           Else
           begin
               Tv[67]:=Tv[4];
               Tv[78] := MaxR(0,Tv[67]-43573) *  0.02; //20240228
           end;

        end;
       Tv[91]:= MaxR(0,Tv[101]-Tv[78]);

       If UpperCase(FetchElm(RetNo,'ONBEN',42)) <> 'Y' then
       begin For i:=4 to 92 do Tv[i]:=0;end;

       Tv[81]:=Tv[91];
       If Tv[82]=0 then Tv[82]:=Vl(FetchElm(RetNo,'CFR',98));
       Tv[83]:=Tv[81]+Tv[82];
       Tv[84]:=Tv[22];
       Tv[85]:=MaxR(0,Tv[83]-Tv[84]);
       Tv[79]:=Tv[10];
       If Tv[82]=0 then
       begin
        for i:=81 to 85 Do Tv[i]:=0;
        Tv[79]:=0;Tv[92]:=0;
       end;

       Tv[92] := MaxR(0,Tv[85] - Tv[79]);
       Tv[86]:=Tv[92];
       Tv[14]:=MaxR(0,Tv[91]-Tv[86]);
  end;
  SaveTv(RetNo,FName,FNo);
End;


end.
