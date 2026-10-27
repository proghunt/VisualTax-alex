unit T1_2026Calc2;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls, T1_2026Declare, T1_2026common,
  T1_2026common2, T1_2026TrimStr, T1_2026T1Rtns, T1_2026T1Rtns2;

  Procedure S6(RetNo: integer; FName: string; FNo: integer);
  //procedure UHT(RetNo: integer; FName: String;FNo: integer); //20230610 //20240717 Igor
  procedure T2200S(RetNo: integer; FName: String;FNo: integer);  //20230309
  //procedure T2039(RetNo: integer; FName: String;FNo: integer);    //20240104
  procedure T2043(RetNo: integer; FName: String;FNo: integer);
  procedure T2043A(RetNo: integer; FName: String;FNo: integer);
  Procedure CONSENT(RetNo:integer;FName:string;FNo:integer);  //29200211
  Procedure TX19(RetNo:integer;FName:string;FNo:integer);
  Procedure DEATH(RetNo:integer;FName:string;FNo:integer);
  procedure T81(RetNo: integer; FName: String;FNo: integer);
  procedure T1223(RetNo: integer; FName: String;FNo: integer);
  procedure T1198(RetNo: integer; FName: String;FNo: integer);
  procedure T1241(RetNo: integer; FName: String;FNo: integer);
  procedure T1256(RetNo: integer; FName: String;FNo: integer);
  procedure T12561(RetNo: integer; FName: String;FNo: integer);
  procedure T12562(RetNo: integer; FName: String;FNo: integer);
  procedure T1258(RetNo: integer; FName: String;FNo: integer);
  Procedure T1221(RetNo:integer;FName:string;FNo:integer);
  procedure TRANSF(RetNo: integer; FName: String;FNo: integer);
  Procedure T1231(RetNo:integer;FName:string;FNo:integer);
  Function GetElgblCapGains(RetNo:integer):real;
  Procedure T1013(RetNo:integer;FName:string;FNo:integer);
  Procedure T1037(RetNo:integer;FName:string;FNo:integer);
  Procedure T1023(RetNo:integer;FName:string;FNo:integer);
  Procedure T1A(RetNo:integer;FName:string;FNo:integer);
  Procedure T2017(RetNo:integer;FName:string;FNo:integer);
  Procedure T2036(RetNo:integer;FName:string;FNo:integer);
  Procedure T2038(RetNo:integer;FName:string;FNo:integer);
  Procedure T2038I(RetNo:integer;FName:string;FNo:integer);
  Procedure T2091(RetNo:integer;FName:string;FNo:integer);
  Procedure T1255(RetNo:integer;FName:string;FNo:integer);  //20180303
  Procedure T209W(RetNo:integer;FName:string;FNo:integer);
  Procedure T2097(RetNo:integer;FName:string;FNo:integer);
  Procedure T2202A(RetNo:integer;FName:string;FNo:integer);
  Procedure T2204(RetNo:integer;FName:string;FNo:integer);
  Procedure T2209(RetNo:integer;FName:string;FNo:integer);
  Procedure T2222(RetNo:integer;FName:string;FNo:integer);
  Procedure T691(RetNo:integer;FName:string;FNo:integer);
  Procedure T746(RetNo:integer;FName:string;FNo:integer);
  Procedure T778(RetNo:integer;FName:string;FNo:integer);
  Procedure TL2(RetNo:integer;FName:string;FNo:integer);
  Procedure FPCHECK(RetNo:integer;FName:string;FNo:integer);

  //jz//20260325//MJCERT2025
  {
  procedure ABMJ(RetNo: integer; FName: String;FNo: integer);
  procedure ONMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NLMJ(RetNo: integer; FName: String;FNo: integer);
  procedure PEMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NSMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NBMJ(RetNo: integer; FName: String;FNo: integer);
  procedure MBMJ(RetNo: integer; FName: String;FNo: integer);
  procedure SKMJ(RetNo: integer; FName: String;FNo: integer);
  procedure BCMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NTMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NUMJ(RetNo: integer; FName: String;FNo: integer);
  procedure YTMJ(RetNo: integer; FName: String;FNo: integer);  //202411222 duplicate
  } 
implementation

uses
  vtCommon, T1_2026, T1_2026Calc, vtTrimStr, vtShared;

//20251008 Igor >>>
procedure T691(RetNo:integer;FName:string;FNo:integer);
var
  i: Integer;
  InclRate: Real;
  x: Real;
  S3FNo, T1170FNo: Integer;
begin
  T1170FNo:= GetFormNo('T1170');
  S3FNo:= GetFormNo('S3');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    {// put back //20250219
    //20250219
    for i:= 1 to 250 do
    begin
      Tv[i]:= 0;

      SaveTv(RetNo, FName, FNo);
      Exit;
    end; }
    //Page 1
    Tv[1]:= SelectTaxableIncomeAmount(RetNo);//20250223 //Lnn[26000];//20241223  //Lnn[15000]-Lnn[23300] - Lnn[23500]-Lnn[25700];

    //If IsSection216(RetNo) then Tv[1]:= Vl(FetchElm(RetNo, 'T1159', 37));
    {Film}
    Tv[8]:= Vl(FetchElm(RetNo, 'OTHDED', 12));

    //if (Lnn[22100] + MaxR(0, Lnn[23200] - Vl(FetchElm(RetNo, 'OTHDED', 60))) > 0) and (Tv[8] = 0) then Tv[8]:= 1; //jz//20260102 - should be done in efrules or just using efmemo, remove

    Tv[10]:= MaxR(0, (Tv[8] - Tv[9]));
    Tv[11]:= Tv[10];
    Tv[38]:= 0; //Vl(FetchElm(RetNo,'S4',64));  //20150321
    x:= TotMultiple(RetNo, 'T776', 105);
    if (x > 0) then Tv[38]:= x;

    Tv[39]:= TotMultiple(RetNo, 'T776', 100); //MaxR(0,TotMultiple(RetNo,'T776',100)-Vl(FetchElm(RetNo,'S4',64))); //20150321

    if (Tv[38] = 0) then Tv[39]:= 0;

    Tv[40]:= MaxR(0, Tv[38] - Tv[39]);

    if (Tv[38] > 0) and (Tv[39] = Tv[38]) then Tv[40]:= 1;           //jz//20260327//MJCERT2025 - why is this?? have to override in CERT MJ3
    if (Ret[RetNo].Lnn[12600] < 0) and (Tv[40] = 0) then Tv[40]:= 1; //if loss then at least 1

    Tv[41]:= Tv[40];
    {tax shelters and lmt partnerships}
    Tv[15]:= GetL122LossForMinTax(RetNo) + GetTaxShelterLossT776T2042(RetNo);
    Tv[12]:= Vl(FetchElm(RetNo, 'S4', 64));

    if (Tv[13] = 0) then Tv[13]:= Vl(FetchElm(RetNo, 'S4', 65));

    Tv[16]:= Tv[15] + Tv[13] + Tv[12];
    Tv[17]:= Tv[16];
    Tv[34]:=Tv[1] + Tv[11] + Tv[41] + Tv[17];

    //Page 2
    Tv[37]:= Tv[34];
    TV[175]:= Tv[171];  //20250223
    //??? Tv[164]:=Tv[171]; //20250111
    Tv[25]:= Vl(Fetchelm(RetNo, 'S3', 293)); //20251203 Igor // Vl(Fetchelm(RetNo, 'S3', 293)) + Vl(Fetchelm(RetNo, 'S3', 96));//20241230
    Tv[26]:= Vl(FetchElmFno(RetNo, S3FNo, 195)) + Vl(FetchElmFno(RetNo, S3FNo, 264)); //20251203 Igor // Vl(FetchElmFno(RetNo, S3FNo, 195)) + Vl(FetchElmFno(RetNo, S3FNo, 264)) + Vl(FetchElmFno(RetNo, S3FNo, 122)) + Vl(FetchElmFno(RetNo, S3FNo, 72)); //20250129 CZ
    //Tv[26] [27], [5]?? should  elm[26] be calc or user like the others? //jz 20250127
    Tv[30]:= Tv[26] + Tv[27] + Tv[6];
    Tv[31]:= Tv[30];
    Tv[32]:= Tv[25] - Tv[31]; //accept negative
    Tv[4]:= Ret[RetNo].Lnn[12700];
    Tv[18]:= Tv[32] - Tv[4]; //accept nrg

    if (Tv[32] > 0) then Tv[33]:= Tv[18] else Tv[33]:= Tv[4];

    Tv[19]:= Vl(FetchElmFNo(RetNo, T1170Fno, 32)) + Vl(FetchElmFNo(RetNo, T1170Fno, 77)); //20251216 Igor // + Vl(FetchElmFNo(RetNo, T1170Fno, 68)) + Vl(FetchElmFNo(RetNo, T1170Fno, 71));
    Tv[47]:= Vl(FetchElmFNo(RetNo, T1170Fno, 76))
            +Vl(FetchElmFNo(RetNo, T1170Fno, 79)); //20260217 cz
             //20251216 Igor 68251??? In T691 field caption told 68231, but in final redaction of T1170 68231 not found 68251 only //Ret[RetNo].Lnn[12701];
    Tv[24]:= Tv[19] - Tv[47]; //20251216 Igor
    Tv[48]:= Tv[24] * 0.30; //20251216 Igor
    Tv[20]:= Tv[37] + Tv[175] + Tv[33] + Tv[48]; //20250111
    Tv[21]:= TotMultiple(RetNo, 'T4', 28) + TotMultiple(RetNo, 'T4', 70) + TotMultiple(RetNo, 'T4', 73); //20251212 Igor - second box 91 value added //jz//20250330 - added box 91 totals  //?? + box 91?  //missing from T4

    Tv[22]:= Vl(FetchElm(RetNo, 'T1212', 7)) * 0.50; //jz//20260215 - the 50% should not have been removed //20251216 Igor // Vl(FetchElm(RetNo, 'T1212', 5)) * 0.50 + Vl(FetchElm(RetNo, 'T1212', 3)) * 0.333383; //20251203 Igor

    //asks for lines 2, 3 from T1212, but with conitions, should this be user then?
    //or get it from line 24900 as it seems to be the same conditions

    Tv[23]:= Tv[21] + Tv[22];

    // CZ: There is no way right now. We will put by default to period elm 35
    //Tv[24]:= ??  //again, should this be user?? //jz 20250127
    //Tv[29]:=Tv[24]*40/100; //20251021 Igor
    //Tv[162]:=Tv[23]-Tv[29]; //20251021 Igor

    //Tv[35]:=Ret[RetNo].Lnn[24900];  Do not allocate it. but issue a warning.
    //Tv[35]:= Ret[RetNo].Lnn[24900]; //20251216 Igor
    //Tv[35]:= ?? //and again, should this be vtuser?? //jz//20250127

    //Tv[35]:= vtuser //jz//20251217 - changed form to vtuser

    Tv[36]:= Tv[35] * 0.40;
    Tv[42]:= MaxR(0, Tv[23] - Tv[36]);
    Tv[43]:= Tv[42];
    Tv[53]:= Tv[20] + Tv[43];

    //Page 3
    Tv[44]:= Tv[53];
    Tv[130]:= TotMultiple(RetNo, 'T4', 12) + TotMultiple(RetNo, 'T4', 71) + TotMultiple(RetNo, 'T4', 74); //20251212 Igor - second box 92 value added //20250129
    //Tv[130], 142,143:=?? user?? or just get all T4 boxes 41 and 92?? //jz 20250127
    //Tv[142]:=;Tv[143]:  = user input
    Tv[144]:= Tv[130] + Tv[142] + Tv[143];
    //Tv[141]:= Ret[RetNo].Lnn[24901];
    //Tv[137]:= Tv[144] + Tv[141];
    Tv[138]:= Tv[144];
    //jz 20250157 //Tv[2]Tv[6]Tv[14]Tv[50] //user input
    //both Tv[2] and Tv[6] cannot be populated
    if (Tv[2] > 0) then Tv[6]:= 0 else
    if (Tv[6] > 0) then Tv[2]:= 0;

    Tv[28]:= Tv[2] + Tv[6] + Tv[14] + Tv[50];
    Tv[104]:= Tv[28];
    Tv[106]:= Tv[44] + Tv[138] + Tv[104];
    Tv[51]:= Ret[RetNo].Lnn[25200];  //?? says from 25100 not 25100 //jz 20250127
    Tv[3]:= MaxR(Tv[2], Tv[6]);
    Tv[7]:= Tv[51] - Tv[3];
    Tv[54]:= Tv[7];
    Tv[55]:= Ret[RetNo].Lnn[25200]; //??
    Tv[56]:= Tv[14];
    Tv[57]:= Tv[55] - Tv[56];
    Tv[58]:= Tv[57];
    Tv[59]:= Ret[RetNo].Lnn[21200];
    Tv[61]:= Ret[RetNo].Lnn[21400];
    Tv[62]:= Tv[54] + Tv[58] + Tv[59] + Tv[61];

    //Page 4
    Tv[63]:= Tv[62];
    Tv[60]:= Ret[RetNo].Lnn[21500];
    Tv[64]:= Ret[RetNo].Lnn[21900];
    Tv[65]:= Ret[RetNo].Lnn[22200];
    Tv[66]:= Ret[RetNo].Lnn[22215];
    Tv[67]:= Ret[RetNo].Lnn[22300];  // QC only
    Tv[68]:= Ret[RetNo].Lnn[23100];
    Tv[69]:= Ret[RetNo].Lnn[24400]; //jz 20250107
    Tv[70]:= Ret[RetNo].Lnn[25500];
    Tv[71]:= Tv[63] + Tv[60] + Tv[64] + Tv[65] + Tv[66] + Tv[67] + Tv[68] + Tv[69] + Tv[70];
    Tv[72]:= Tv[71];

    //jz//20251203 - same issue as last year, profile gets from t777, otherdeductions, etc but for now changed unassigned calced editboxes to vtuser
    //mising assignments 73 to 76   //they say included in 22100, should be user input?? //jz 20250127
    //Tv[73]:= Ret[RetNo].Lnn[];  Tv[74]:=Ret[RetNo].Lnn[];  Tv[75]:=Ret[RetNo].Lnn[];

    Tv[76]:= Tv[73] + Tv[74] + Tv[75] + Tv[141]; //20251216 Igor
    Tv[95]:= Tv[76];
    Tv[77]:= Ret[RetNo].Lnn[22900];

    //jz//20251203 - same issue as last year, profile gets from t777, otherdeductions, etc but for now changed unassigned calced editboxes to vtuser
    //umassigned boxes ?? user input  //asks if user input but boxes are not user input, change form?? //jz 20250127

    //[78][79][80][81][82][83] := vtUser

    Tv[84]:= 0;
    for i:= 78 to 83 do Tv[84]:= Tv[84] + Tv[i];

    Tv[85]:= Tv[84]; //0; //why 0? //jz 20250127
    Tv[86]:= Tv[77] - Tv[85];
    Tv[87]:= TV[86];
    Tv[88]:= Tv[72] + Tv[95] + Tv[87];
    Tv[89]:= Tv[88] * 0.50;
    Tv[90]:= Tv[106];
    Tv[91]:= Tv[89] + Tv[90];

    //Page 5
    Tv[52]:= Tv[91];
    Tv[108]:= Ret[RetNo].Lnn[12000];
    Tv[105]:= Ret[RetNo].Lnn[12010];
    Tv[107]:= Tv[105] * 0.130435;
    Tv[145]:= Tv[108] - Tv[105];
    Tv[92]:= Tv[145] * 0.275362;
    //20250402
    Tv[97]:= Tv[107] + Tv[92];
    Tv[112]:= Tv[97];
    Tv[164]:= Ret[RetNo].Lnn[25400]; //, Tv[35]); //is this correct ?? //jz 20250127
    Tv[172]:= Tv[164] * 0.40;
    Tv[111]:= Tv[112] + TV[172];
    Tv[94]:= Ret[RetNo].Lnn[25395];
    TV[173]:= Tv[94] * 2;
    Tv[174]:= Ret[RetNo].Lnn[25395];
    Tv[116]:= Tv[173] - Tv[174]; //20251021 Igor //MaxR(0, Tv[173] - Tv[174]);//20250403
    Tv[117]:= Tv[116];
    Tv[118]:= Tv[111] + Tv[117];
    Tv[120]:= Tv[118];
    Tv[124]:= MaxR(0, Tv[52] - Tv[120]);
    Tv[125]:= 177882; //20251203 Igor //173205;
    Tv[129]:= MaxR(0, Tv[124] - Tv[125]);
    Tv[128]:= Tv[129] * 0.205;

    //[45]:= Tv[128];//20251203 Igor
    Tv[98]:= 0;//Tv[98]:= Ret[RetNo].Lnn[35000]; //20251216 Igor
    Tv[99]:= 0;//Tv[99]:= Ret[RetNo].Lnn[34900]; //20251216 Igor
    //Tv[100]:= Tv[98] - Tv[99]; //20251216 Igor
    Tv[93]:= Ret[RetNo].Lnn[33800]; //20251216 Igor //Tv[99]; //20251021 Igor //Tv[100];
    Tv[101]:= Tv[93] * 0.50;  //missing on the form the Tv[172] and the x50% //jz 20250107
    Tv[96]:= Ret[RetNo].Lnn[34900]; //20251216 Igor //Tv[99];
    Tv[102]:= Tv[96] * 0.80; //20250222 //missing on the form the Tv[173] and the x50% //jz 20250107
    Tv[122]:= Vl(FetchElm(RetNo, 'T1', 149)); //20250222
    //Tv[103]:=?? //what to do with this? //jz 20250107
    Tv[113]:= Tv[101] + Tv[102] + Tv[122] + Tv[103];
    Tv[119]:= Tv[113];
    Tv[131]:= MaxR(0, Tv[128] - Tv[119]); //20251203 Igor

    //Page 6. Part 2
    Tv[214]:= Ret[RetNo].Lnn[40400];
    Tv[215]:= Ret[RetNo].Lnn[35000];
    Tv[217]:= Ret[RetNo].Lnn[40425];
    Tv[218]:= Tv[215] + Tv[217];
    Tv[219]:= Tv[218];
    Tv[220]:= MaxR(0, Tv[214] - Tv[219]);
    Tv[221]:= Tv[321]; //20161210 Vl(FetchElm(RetNo,'T691',321));
    xx:= Tv[220] - Tv[221];
    Tv[206]:= Tv[220] - Tv[221];

    //Page 6. Ppart 3
    Tv[46]:= Tv[206];
    Tv[223]:= 0;

    if Ret[RetNo].Province.Equals('ZZ') then Tv[223]:= Tv[46] * 0.48; //20251216 Igor
    if IsMultJurisdiction(RetNo) then Tv[132]:= Tv[223] * Vl(FetchElm(RetNo, 'T2203', 92)); //20251216 Igor
    if (Tv[132] > 0) then Tv[133]:= Tv[132] else //20251216 Igor
    if (UpperCase(FetchElm(RetNo, 'INFO', 276)).Equals('X') or UpperCase(FetchElm(RetNo, 'INFO', 220)).Equals('X')) then Tv[133]:= Tv[223] else Tv[133]:= 0; //20251216 Igor

    Tv[251]:= Vl(FetchElm(RetNo, 'T2038', 74)); //20251216 Igor
    Tv[224]:= Tv[46] + Tv[133] + Tv[251];
    Tv[225]:= Vl(FetchElm(RetNo, 'T2209#1', 18)) + Vl(FetchElm(RetNo, 'T2209#2', 18)) + Vl(FetchElm(RetNo, 'T2209#3', 18));

    if (Tv[225] > Ret[RetNo].Lnn[42900]) then Tv[225]:= Ret[RetNo].Lnn[42900]; //20210508

    Tv[253]:= FedLoggingTaxCredit(RetNo, Vl(FetchElm(RetNo, 'DIRECT', 10)) + Vl(FetchElm(RetNo, 'DIRECT', 12)), Vl(FetchElm(RetNo, 'DIRECT', 11)) + Vl(FetchElm(RetNo, 'DIRECT', 13)));
    Tv[254]:= Tv[225] + Tv[253];
    Tv[255]:= Tv[254];
    Tv[226]:= MaxR(0, Tv[224] - Tv[255]);
    Tv[227]:= Ret[RetNo].Lnn[41000];
    Tv[228]:= Vl(FetchElm(RetNo, 'T2038', 84)); //20240409/  ret[RetNo].Lnn[41200];  If Tv[256]>0 then Tv[228]:=Tv[256];
    Tv[229]:= Ret[RetNo].Lnn[41400];
    Tv[230]:= Tv[227] + Tv[228] + Tv[229];
    Tv[231]:= Tv[230];
    Tv[250]:= Tv[226] - Tv[231];

    //Page 7. Part 4
    Tv[232]:= Vl(FetchElm(RetNo, 'FORINC', 207)) + Vl(FetchElm(RetNo, 'FORINC', 209)) + Vl(FetchElm(RetNo, 'FORINC', 211));
    Tv[233]:= Vl(FetchElm(RetNo, 'FORINC', 157)) + Vl(FetchElm(RetNo, 'FORINC', 159)) + Vl(FetchElm(RetNo, 'FORINC', 161));
    Tv[134]:= MaxR(0, MinR(Tv[134], Tv[33])); //20250413also, where from? should it be user input?? //jz 20250127
    Tv[234]:= Tv[232] + Tv[233]+ Tv[134]; //jz 20250127
    Tv[222]:= 20.5;
    Tv[238]:= Tv[234] * Tv[222] / 100;
    Tv[235]:= Vl(FetchElm(RetNo, 'FORINC', 158)) + Vl(FetchElm(RetNo, 'FORINC', 160)) + Vl(FetchElm(RetNo, 'FORINC', 162));
    Tv[236]:= Tv[235] * 0.666667;
    Tv[237]:= Vl(FetchElm(RetNo, 'FORINC', 208)) + Vl(FetchElm(RetNo, 'FORINC', 210)) + Vl(FetchElm(RetNo, 'FORINC', 212));
    Tv[239]:= MaxR(0, Tv[236] + Tv[237]);
    Tv[240]:= MinR(Tv[238], Tv[239]);
    Tv[241]:= MaxR(Tv[225], Tv[240]);

    //Page 8. Part 5
    Tv[242]:= Tv[131]; //jz//20260112 - should not have been changed from 131 to 103, change back to 131//20251216 Igor //Vl(FetchElm(RetNo,'T691',131));  //29241230
    Tv[243]:= Tv[241];
    Tv[244]:= MaxR(0, Tv[242] - Tv[243]);
    Tv[245]:= Tv[250];
    Tv[246]:= Tv[133]; //jz 20250127 //Tv[223];
    Tv[247]:= MaxR(0, Tv[245] - Tv[246]);
    Tv[248]:= Tv[247];
    Tv[249]:= MaxR(0, Tv[244] - Tv[248]);
    //jz 20250127
    Tv[135]:= Tv[228];
    Tv[136]:= Vl(FetchElm(RetNo, 'T2038', 92));
    Tv[139]:= MaxR(0, Tv[135] - Tv[136]);
    Tv[140]:= Tv[139];
    Tv[147]:= MaxR(0, Tv[249] - Tv[140]);

    //Page 8. Part 6
    if (Tv[147] > 0) then
    begin
      Tv[201]:= Tv[206];
      Tv[202]:= Vl(FetchElm(RetNo, 'T1206', 61)); //note: on form T1206 the line number is wrong //jz 20250127 //20220220 //Vl(FetchElm(RetNo,'T1206',6));
      Tv[203]:= MaxR(0, Tv[201] - Tv[202]);
      Tv[204]:= Tv[131]; //jz 20250127 //Vl(FetchElm(RetNo,'T691',129)); //20090207 //Tv[42];
      Tv[205]:= MaxR(Tv[203], Tv[204]);
      Tv[207]:= Vl(FetchElm(RetNo, 'T1206', 61));//Vl(FetchElm(RetNo,'T1206',6));
      Tv[208]:= Tv[205] + Tv[207];
      Tv[209]:= Tv[244];
      //jz 20250127 is there a reason these are left blank??

      Tv[148]:= Tv[208] * 0.48; //20250403
      //xx:=Tv[148];
      TV[210]:=0;
      if IsMultJurisdiction(RetNo) then
      Begin
        Tv[149]:= Tv[148]* Vl(FetchElm(RetNo, 'T2203', 92))/100;
        If Tv[149]>0 then Tv[210]:=Tv[149];
       //If Non -resident income outside cabada could be from SA if not MJ? Or T2203?
      end
      Else
      Begin
       If UpperCase(FetchElm(RetNo, 'INFO', 228)).Equals('X') then //NR or Deemed resident
         Tv[210]:=Tv[148];
        // yy:=Tv[210];
      End;

      Tv[211]:= Tv[209] + Tv[210];
      Tv[212]:= Vl(FetchElm(RetNo, 'T1206', 8)); //Vl(FetchElm(RetNo,'T1206',12));
      Tv[213]:= MaxR(Tv[211], Tv[212]);

      //Page 9. Part 7
      Tv[307]:= Tv[131]; //jz//20260112 - should not have been changed to 103 from 131, change back to 131//Tv[307]:= Tv[103]; //20251216 Igor
      Tv[308]:= Tv[206];
      Tv[150]:= Vl(FetchElm(RetNo, 'T2038', 74)); //20251216 Igor
      Tv[151]:= Tv[308] + Tv[150];

      //if Ret[RetNo].Province.Equals('QC') then Tv[152]:= Vl(FetchElm(RetNo, 'T1', 123)) else Tv[152]:= Vl(FetchElm(RetNo, 'T1', 149)); //20251021 Igor
      if Ret[RetNo].Province.Equals('QC') then Tv[152]:= Vl(FetchElm(RetNo, 'T1', 52)) else Tv[152]:= Vl(FetchElm(RetNo, 'T1', 125)); //20251216 Igor

      Tv[153]:= Ret[RetNo].Lnn[41600];
      Tv[154]:= Tv[152] + Tv[153];
      Tv[155]:= Tv[154];
      Tv[156]:= Tv[151] - Tv[155];
      Tv[309]:= Tv[241];
      Tv[310]:= Tv[225];
      Tv[311]:= MaxR(0, Tv[309] - Tv[310]);
      Tv[163]:= Tv[311];
      Tv[312]:= Tv[239]; //jz 20250107 //Vl(FetchElm(RetNo,'T691',239));
      Tv[354]:= Tv[235] + Tv[237]; //jz 20250107 //Vl(FetchElm(RetNo,'T691',235))+Vl(FetchElm(RetNo,'T691',237));

      if (Tv[354] > 0) then Tv[313]:= Tv[311] * (Tv[312] / Tv[354]) else Tv[313]:= 0;

      Tv[314]:= Tv[156] + Tv[313]; //20250403
      Tv[315]:= Tv[314];
      Tv[316]:= MaxR(0, Tv[307] - Tv[315]);
    end
    else
    begin
      for i:= 201 to 205 do Tv[i]:= 0; //jz/20250223 [206] was not part of part 6, should not be blanked, remove
      for i:= 207 to 209 do Tv[i]:= 0;
      for i:= 148 to 149 do Tv[i]:= 0;
      for i:= 210 to 213 do Tv[i]:= 0;
      for i:= 307 to 308 do Tv[i]:= 0;
      for i:= 150 to 156 do Tv[i]:= 0;
      for i:= 309 to 316 do Tv[i]:= 0;

      Tv[163]:= 0;
      Tv[354]:= 0;
    end;

    //Page 10. Part 8
    Tv[317]:= Vl(FetchElm(RetNo, 'CFR', 39));
    Tv[318]:= Tv[220]; //jz 20250127 //Vl(FetchElm(RetNo,'T691',220));
    Tv[305]:= Vl(FetchElm(RetNo, 'T2038', 74)); //20251216 Igor //Vl(FetchElm(RetNo, 'T2038', 51));//20250222
    //Vl(FetchElm(RetNo,'T1206',52));//20220225//Vl(FetchElm(RetNo,'T1206',4));
    Tv[306]:= Tv[318] + Tv[305];
    Tv[157]:= Vl(FetchElm(RetNo, 'T1206', 52)); //20251021 Igor

    //if Ret[RetNo].Province.Equals('QC') then Tv[158]:= Vl(FetchElm(RetNo, 'T1', 123)) else Tv[158]:= Vl(FetchElm(RetNo, 'T1', 149)); //20251021 Igor
    if Ret[RetNo].Province.Equals('QC') then Tv[158]:= Vl(FetchElm(RetNo, 'T1', 52)) else Tv[158]:= Vl(FetchElm(RetNo, 'T1', 125)); //20251216 Igor

    Tv[49]:= Ret[RetNo].Lnn[41600];
    Tv[159]:= Tv[157] + Tv[158] + Tv[49]; //jz 20240127
    Tv[160]:= Tv[159];
    Tv[161]:= Tv[306] - Tv[160];
    Tv[319]:= Tv[131]; //jz//20260112 - should not have been changed from 131 to 103, change back to 131 //Tv[103]; //20251216 Igor //Vl(FetchElm(RetNo,'T691',131));
    Tv[320]:= MaxR(0, (Tv[161] - Tv[319])); //jz 20250127 //also, what does it mean override line 124 on the form??

    //jz 20250127 change to do what it seems it was trying to do:
    //if is not blank make sure the user input is not more than max allowed
    if (Tv[321] > 0) then
      Tv[321]:= MinR(Tv[321], MinR(Tv[317], Tv[320]))       //If Tv[321] > Tv[317] then Tv[321] :=Tv[317];  doesnt do enough //20110422
    else // if nothing entered auto fill the max amount allowed
      Tv[321]:= MinR(Tv[317], Tv[320]);

    Tv[322]:= MaxR(0, Tv[317] - Tv[321]);
    Tv[323]:= Tv[316]; //Tv[151]; //jz//20250404 error on our form, should be be from part 7 line 14 (tv[316]), NOT line 4 (tv[151])
    Tv[301]:= Tv[322] + Tv[323]; //jz20250127 was missing
    //Tv[302]:= user
    Tv[324]:= MaxR(0, Tv[301] - Tv[302]);

    //Page 10. Part 9
    //Tv[165] := Vl(FetchElm(RetNo,'T1',313)) + Vl(FetchElm(RetNo,'T1',314)) + Vl(FetchElm(RetNo,'T1',317)) ;
    //Tv[165] := ret[RetNo].Lnn[22100] + ret[RetNo].Lnn[22400] + ret[RetNo].Lnn[23200];

    Tv[166]:= maxR(0, Tv[166]); //user input
    Tv[167]:= maxR(0, Tv[167]); //user input
    Tv[168]:= maxR(0, Tv[168]); //user input
    Tv[169]:= Tv[166] + Tv[167] + Tv[168];
    Tv[170]:= Tv[169];
    Tv[171]:= maxR(0, Tv[165] - Tv[170]);
    Tv[175]:= Tv[171];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<

(*
Procedure T691(RetNo:integer;FName:string;FNo:integer);
Var I:Integer;InclRate:Real;x:Real; S3FNo,T1170FNo:Integer;
begin
 T1170FNo:=GetFormNo('T1170');
 S3FNo:=GetFormNo('S3');
 LoadTv(RetNo,FName,FNo);


 with ret[RetNo], ret[RetNo].Frm[FNo] do
 begin
  { // put back  //20250219
  //=======================
  //20250219
   for i:=1 to 250 do
   begin
     Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
   end;
 //==========================
 }
      //t691 page 1
        Tv[1] := SelectTaxableIncomeAmount(RetNo);//20250223 //Lnn[26000];//20241223  //Lnn[15000]-Lnn[23300] - Lnn[23500]-Lnn[25700];
      //  If IsSection216(RetNo) then Tv[1]:=Vl(FetchElm(RetNo,'T1159',37));
        {Film}
        Tv[8]:=Vl(FetchElm(RetNo,'OTHDED',12));
        If (Lnn[22100]+MaxR(0,Lnn[23200]-Vl(FetchElm(RetNo,'OTHDED',60)))>0) and (Tv[8]=0) then Tv[8]:=1;
        Tv[10] := MaxR(0,(Tv[8] - Tv[9]));
          Tv[11] := Tv[10];

        {rental}
        Tv[38]:=0; //Vl(FetchElm(RetNo,'S4',64));  //20150321
        x:=TotMultiple(RetNo,'T776',105);
        If x>0 then
          Tv[38]:=Tv[38]+x;
        Tv[39]:=TotMultiple(RetNo,'T776',100); //MaxR(0,TotMultiple(RetNo,'T776',100)-Vl(FetchElm(RetNo,'S4',64))); //20150321
        If Tv[38]=0 then
          Tv[39]:=0;

        Tv[40] := MaxR(0,Tv[38]-Tv[39]);
        If (Tv[38]>0) and (Tv[39]=Tv[38]) then Tv[40]:=1;
        If (ret[RetNo].Lnn[12600]<0) and (Tv[40]=0) then Tv[40]:=1; //if loss then at least 1
        Tv[41] := Tv[40];
        {tax shelters and lmt partnerships}
        Tv[15]:=GetL122LossForMinTax(RetNo)+GetTaxShelterLossT776T2042(RetNo);

        Tv[12]:=Vl(FetchElm(RetNo,'S4',64));
        If Tv[13]=0 then Tv[13]:=Vl(FetchElm(RetNo,'S4',65));  //20150321
        Tv[16] := Tv[15]+Tv[13]+Tv[12];
        Tv[17] := Tv[16];
        Tv[34]:=Tv[1]+Tv[11]+Tv[41]+Tv[17];

        //page 2
        Tv[37]:= Tv[34];
        TV[175]:=Tv[171];  //20250223
        //??? Tv[164]:=Tv[171]; //20250111

        Tv[25]:=Vl(Fetchelm(RetNo,'S3',293))+Vl(Fetchelm(RetNo,'S3',96));//20241230
        //20250129 CZ
        Tv[26]:=Vl(FetchElmFno(RetNo,S3FNo,195))+Vl(FetchElmFno(RetNo,S3FNo,264))
                            +Vl(FetchElmFno(RetNo,S3FNo,122))+Vl(FetchElmFno(RetNo,S3FNo,72));
        //Tv[26] [27], [5]?? should  elm[26] be calc or user like the others? //jz 20250127

        Tv[30]:=Tv[26]+Tv[27]+Tv[6];
        Tv[31]:=Tv[30];
        Tv[32]:=Tv[25]-Tv[31]; //accept negative
        Tv[4]:=Ret[RetNo].Lnn[12700];
        Tv[18]:=Tv[32]-Tv[4]; //accept nrg
        if Tv[32]>0 then
         Tv[33]:=Tv[18]
        Else
         Tv[33]:=Tv[4];

        Tv[47]:=Ret[RetNo].Lnn[12701];
        Tv[19]:=Vl(FetchElmFNo(RetNo,T1170Fno,32))+
                Vl(FetchElmFNo(RetNo,T1170Fno,77))+
                Vl(FetchElmFNo(RetNo,T1170Fno,68))+
                Vl(FetchElmFNo(RetNo,T1170Fno,71));

        Tv[48]:=Tv[19]*30/100;
        Tv[20]:=Tv[37]+Tv[175]+Tv[33]+Tv[48]; //20250111

       //---------------------------------
       // 21 to 54   NOT DONE
         //????

       //========================


        Tv[21]:=TotMultiple(RetNo,'T4',28); //?? + box 91?  //missing from T4
        //jz 20250127
        Tv[22]:=Vl(FetchElm(RetNo,'T1212',5)) * 50/100+Vl(FetchElm(RetNo,'T1212',3))*33.3383/100; //20250129 CZ
        //asks for lines 2, 3 from T1212, but with conitions, should this be user then?
        //or get it from line 24900 as it seems to be the same conditions
        Tv[23]:=Tv[21]+Tv[22];
        //Tv[24]:=??
        // CZ: There is no way right now. We will put by default to period elm 35
        //Tv[24]:= ??  //again, should this be user?? //jz 20250127
        //Tv[35]:=Ret[RetNo].Lnn[24900];  Do not allocate it. but issue a warning.

        Tv[29]:=Tv[24]*40/100;
        Tv[162]:=Tv[23]-Tv[29];

        //Tv[35]:= ?? //and again, should this be user?? //jz 20250127
        Tv[36]:=Tv[35]*5/100;

        Tv[42]:=MaxR(0,Tv[162]-Tv[36]);
        Tv[43]:=Tv[42];
        Tv[53]:=Tv[20]+Tv[43];
 end;

 //Page 3
 with ret[RetNo], ret[RetNo].Frm[FNo] do
 Begin
  Tv[44]:=Tv[53];
  Tv[130]:=TotMultiple(RetNo,'T4',12)+TotMultiple(RetNo,'T4',71); //20250129
  //Tv[130], 142,143:=?? user?? or just get all T4 boxes 41 and 92?? //jz 20250127
  //Tv[142]:=;Tv[143]:  = user input

  Tv[144]:=Tv[130]+Tv[142]+Tv[143];
  Tv[141]:=Ret[RetNo].Lnn[24901];
  Tv[137]:=Tv[144]+Tv[141];
  Tv[138]:=Tv[137];

  //jz 20250157
  //Tv[2]Tv[6]Tv[14]Tv[50] //user input
  //both Tv[2] and Tv[6] cannot be populated
  if Tv[2] > 0 then
    Tv[6] := 0
  else if Tv[6] > 0 then
    Tv[2] := 0;

  Tv[28]:=Tv[2]+Tv[6]+Tv[14]+Tv[50];
  Tv[104]:=Tv[28];
  Tv[106]:=Tv[44]+Tv[138]+Tv[104];

  Tv[51]:=Ret[RetNo].Lnn[25200];  //?? says from 25100 not 25100 //jz 20250127
  Tv[3]:=MaxR(Tv[2],Tv[6]);
  Tv[7]:=Tv[51]-Tv[3];
  Tv[54]:=Tv[7];

  Tv[55]:=Ret[RetNo].Lnn[25200]; //??
  Tv[56]:=Tv[14];
  Tv[57]:=Tv[55]-Tv[56];
  Tv[58]:=Tv[57];
  Tv[59]:=Ret[RetNo].Lnn[21200];
  Tv[61]:=Ret[RetNo].Lnn[21400];
  Tv[62]:=Tv[54]+Tv[58]+Tv[59]+Tv[61];
 end;

 // page 4
 with ret[RetNo], ret[RetNo].Frm[FNo] do
 Begin
  Tv[63]:=Tv[62];
  Tv[60]:=Ret[RetNo].Lnn[21500];
  Tv[64]:=Ret[RetNo].Lnn[21900];
  Tv[65]:=Ret[RetNo].Lnn[22200];
  Tv[66]:=Ret[RetNo].Lnn[22215];
  Tv[67]:=Ret[RetNo].Lnn[22300];  // QC only
  Tv[68]:=Ret[RetNo].Lnn[23100];

  Tv[69]:=Ret[RetNo].Lnn[24400]; //jz 20250107

  Tv[70]:=Ret[RetNo].Lnn[25500];
  Tv[71]:=Tv[60];
  for i:=63 to 70 do begin Tv[71]:=Tv[71]+Tv[i];end;
  Tv[72]:=Tv[71];

  //mising assignments 73 to 76   //they say included in 22100, should be user input?? //jz 20250127
  //Tv[73]:=Ret[RetNo].Lnn[];  Tv[74]:=Ret[RetNo].Lnn[];  Tv[75]:=Ret[RetNo].Lnn[];

  Tv[76]:=Tv[73]+Tv[74]+Tv[75];
  Tv[95]:=Tv[76];
  Tv[77]:=Ret[RetNo].Lnn[22900];

  //umassigned boxes ?? user input  //asks if user input but boxes are not user input, change form?? //jz 20250127

  Tv[84]:=0;
  for i:=78 to 83 do begin Tv[84]:=Tv[84]+Tv[i];end;

  Tv[85]:= Tv[84]; //0; //why 0? //jz 20250127
  Tv[86]:=Tv[77]-Tv[85];
  Tv[87]:=TV[86];
  Tv[88]:=Tv[72]+Tv[95]+Tv[87];
  Tv[89]:=Tv[88]*50/100;
  Tv[90]:=Tv[106];
  Tv[91]:=Tv[89]+Tv[90];
 end; //with

 //Page 5
 with ret[RetNo], ret[RetNo].Frm[FNo] do
 Begin
  Tv[52]:=Tv[91];
  Tv[108]:=Ret[RetNo].Lnn[12000];
  Tv[105]:=Ret[RetNo].Lnn[12010];
  Tv[107]:=Tv[105]*13.0435/100;
  Tv[145]:=Tv[108]-Tv[105];
  Tv[92]:=Tv[145]*27.5362/100;
  Tv[96]:=Tv[92];

  Tv[146] := MinR(Ret[RetNo].Lnn[25400], Tv[24]); //is this correct ?? //jz 20250127 //?? from T657
  Tv[93]:=Tv[146]*40/100;
  Tv[109]:=Tv[96]+Tv[93];

  TV[110]:= MinR(Ret[RetNo].Lnn[25400], Tv[35]); //is this correct ?? //jz 20250127
  Tv[111]:=Tv[110]*5/100;
  Tv[112]:=Tv[109]-Tv[111];
  //-----------------------
  //20250223
  Tv[164]:=Ret[RetNo].LNN[25400];
  Tv[172]:=Tv[164]*40/100;
  Tv[111]:=Tv[112]+Tv[172];
  Tv[94]:=Ret[RetNo].Lnn[25395];
  Tv[173]:=Tv[94] *2;
  Tv[174]:=Ret[RetNo].Lnn[25395];
  Tv[116]:=Tv[173]-Tv[174];
  Tv[117]:=Tv[116];
  Tv[118]:=Tv[111]+Tv[117];
  Tv[120]:=Tv[118];
  Tv[124]:=MaxR(0,Tv[52]-Tv[120]);
  Tv[125]:=173205;
  Tv[129]:=MaxR(0,Tv[124]-Tv[125]);
  Tv[128]:=Tv[129]*20.5/100;
  {
  Tv[97]:=+Tv[94]*Tv[163]; // not sure what is happening here //jz 20250127
  if Tv[126]>0 then
   Tv[114]:=Tv[94]/Tv[126]
  Else
   Tv[114]:=0;

  Tv[115]:=Ret[RetNo].Lnn[25395];


  TV[118]:=Tv[112]+Tv[117]; //jz 20250127 changed - to +

  Tv[121]:=MaxR(0,Tv[52]-Tv[120]);
  Tv[123]:=Ret[RetNo].Lnn[25999];

  Tv[125]:=173205; //where is this from? surely should be a var that comes from somewhere //jz 20250127
  Tv[129]:=MaxR(0,Tv[124]-Tv[125]);
  }
  //Tv[127]:=20.5;   //rate  should be a var that comes from somewhere //jz 20250127
 end; //with

 //page 6
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  Begin
   Tv[45]:=Tv[128];
   Tv[98]:=Ret[RetNo].Lnn[35000];
   Tv[99]:=Ret[RetNo].Lnn[34900];
   Tv[100]:=Tv[98]-Tv[99];
   //20250223
   //Tv[172]:=Tv[100];
   Tv[93]:=Tv[100];
   Tv[101]:=Tv[93]*50/100;  //missing on the form the Tv[172] and the x50% //jz 20250107
   Tv[96]:=Tv[99];
   Tv[102]:=Tv[96]*80/100; //20250222 //missing on the form the Tv[173] and the x50% //jz 20250107

   Tv[122]:=Vl(FetchElm(RetNo,'T1',149)); //20250222
    {
   //old 225
    Tv[122]:=Vl(FetchElm(RetNo,'T2209#1',18))+
           Vl(FetchElm(RetNo,'T2209#2',18))+
           Vl(FetchElm(RetNo,'T2209#3',18));
    }
   //Tv[103]:=?? //what to do with this? //jz 20250107
   Tv[113]:=Tv[101]+Tv[102]+Tv[122]+Tv[103];
   Tv[119]:=Tv[113];
   Tv[131]:=MaxR(0,Tv[45]-Tv[119]);


   //part 2
   Tv[214] := Ret[RetNo].Lnn[40400];
   Tv[215] := Ret[RetNo].Lnn[35000];
   Tv[217] := Ret[RetNo].Lnn[40425];
   Tv[218] := Tv[215]+Tv[217];
   Tv[219] := Tv[218];
   Tv[220] := MaxR(0,Tv[214] - Tv[219]);
   Tv[221] := Tv[321]; //20161210 Vl(FetchElm(RetNo,'T691',321));


   Tv[222]:=20.5;
   Tv[238]:= Tv[234]*Tv[222]/100;
   //Tv[235]:=???
   Tv[236]:=Tv[235]*66.6667/100;
   Tv[239]:=MaxR(0,Tv[36]+Tv[37]);
   Tv[240]:=MinR(Tv[238],Tv[239]);
   Tv[241]:=MaxR(Tv[225],Tv[240]);

   { //is this old elms?? comment all out //jz 20250107
   Tv[222]:=20.5;  //20250127
   Tv[238]:= MaxR(0,Tv[234]*Tv[234]*Tv[222]/100;
   //20250127
   //Tv[235]:=???
   Tv[236]:=Tv[235]*66.6667/100;
   //Tv[237]:=
   //Tv[237]:=???
   Tv[239]:=MaxR(0,TV[236]+Tv[237];
   Tv[240]:=MinR(Tv[238],Tv[239]);
   Tv[241]:=MaxR(Tv[225],Tv[240]);
   //==============================
   // ????  below
   }

   xx:=Tv[220] - Tv[221];
   Tv[206] := Tv[220] - Tv[221];


   //part 3
   Tv[46]:=Tv[206];
   Tv[223]:=0;
   If ret[RetNo].Province = 'ZZ' then Tv[223] := Tv[206] * 0.48;

   If IsMultJurisdiction(RetNo) then
   begin
     Tv[132] := Vl(FetchElm(RetNo,'T2203',203));  //??
   end;
   if Tv[132]>0  then Tv[133]:=Tv[132] else Tv[133]:=0;
   Tv[251]:=Vl(FetchElm(RetNo,'T2038',73));
   Tv[224] := Tv[46]+Tv[133]+Tv[251];
   Tv[225] := Vl(FetchElm(RetNo,'T2209#1',18))+
              Vl(FetchElm(RetNo,'T2209#2',18))+
              Vl(FetchElm(RetNo,'T2209#3',18));
   if Tv[225]>Ret[RetNo].Lnn[42900] then Tv[225]:=Ret[RetNo].Lnn[42900]; //20210508

   Tv[253]:=FedLoggingTaxCredit(RetNo,Vl(FetchElm(RetNo,'DIRECT',10))+Vl(FetchElm(RetNo,'DIRECT',12)),
                   Vl(FetchElm(RetNo,'DIRECT',11))+Vl(FetchElm(RetNo,'DIRECT',13)));  //20111126
   Tv[254] := Tv[225]+Tv[253];
   Tv[255] := Tv[254];
   Tv[226] := MaxR(0,Tv[224]-Tv[255]);
   Tv[227] := ret[RetNo].Lnn[41000];

   Tv[228] := Vl(FetchElm(RetNo,'T2038',84)); //20240409/  ret[RetNo].Lnn[41200];  If Tv[256]>0 then Tv[228]:=Tv[256];
   Tv[229] := ret[RetNo].Lnn[41400];
     Tv[230] := Tv[227] + Tv[228] + Tv[229];
     Tv[231] := Tv[230];
   Tv[250] := Tv[226]-Tv[231];
  end; //with

  //Page 7
  //Part 4
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  Begin
    {sp. foreign tx cr}
   Tv[232] := Vl(FetchElm(RetNo,'FORINC',207))+
                  Vl(FetchElm(RetNo,'FORINC',209))+
                  Vl(FetchElm(RetNo,'FORINC',211));

   Tv[233] := Vl(FetchElm(RetNo,'FORINC',157))+
                  Vl(FetchElm(RetNo,'FORINC',159))+
                  Vl(FetchElm(RetNo,'FORINC',161));

   Tv[134]:=  MinR(Tv[134], Tv[33]+Tv[47]); //also, where from? should it be user input?? //jz 20250127

   Tv[234] := Tv[232] + Tv[233]+ Tv[134]; //jz 20250127
   //Tv[222] := Vl(Constant[RY].Rate1);  //20250222
   Tv[238] := Tv[234] * 20.50/100; //202502230.16;
   Tv[235] := Vl(FetchElm(RetNo,'FORINC',158))+
                  Vl(FetchElm(RetNo,'FORINC',160))+
                  Vl(FetchElm(RetNo,'FORINC',162));
   Tv[236] := Tv[235] * 66.6666/100;
   Tv[237] := Vl(FetchElm(RetNo,'FORINC',208))+
                  Vl(FetchElm(RetNo,'FORINC',210))+
                  Vl(FetchElm(RetNo,'FORINC',212));
   Tv[239] := Tv[236] + Tv[237];
   Tv[240] := MinR(Tv[238],Tv[239]);
   Tv[241] := MaxR(Tv[240],Tv[225]);
  end;  //with

 //page 8
 //part 5
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  Begin
      Tv[242] := Tv[131]; //jz 20250127  //Vl(FetchElm(RetNo,'T691',131));  //29241230
      Tv[243] := Tv[241];
      Tv[244] := MaxR(0,Tv[242] - Tv[243]);
      Tv[245] := Tv[250];
      Tv[246] := Tv[133]; //jz 20250127 //Tv[223];
      Tv[247] := MaxR(0,Tv[245] - Tv[246]);
      Tv[248] := Tv[247];
      Tv[249] := MaxR(0,(Tv[244] - Tv[248]));

    //jz 20250127
    Tv[135] := Tv[228];
    Tv[136] := Vl(FetchElm(RetNo,'T2038',92));
    Tv[139] := MaxR(0,(Tv[135] - Tv[136]));
    Tv[140] := Tv[139];
    Tv[147] := MaxR(0,(Tv[249] - Tv[140]));

    if Tv[147]>0 then
    Begin
    //part 6
    Tv[201] := Tv[206];
    Tv[202] := Vl(FetchElm(RetNo,'T1206',61)); //note: on form T1206 the line number is wrong //jz 20250127 //20220220 //Vl(FetchElm(RetNo,'T1206',6));
    Tv[203] := MaxR(0,Tv[201]-Tv[202]);
    Tv[204] := Tv[131]; //jz 20250127 //Vl(FetchElm(RetNo,'T691',129)); //20090207 //Tv[42];
    Tv[205] := MaxR(Tv[203],Tv[204]);
    Tv[207] := Vl(FetchElm(RetNo,'T1206',61));//Vl(FetchElm(RetNo,'T1206',6));
    Tv[208] := Tv[205]+Tv[207];
    Tv[209] := Tv[244];

    //jz 20250127 is there a reason these are left blank??
    //Tv[148] :=
    //Tv[149] :=

    Tv[210]:=0;
    If ret[RetNo].Province = 'ZZ' then Tv[210] := Tv[208] * 0.48;
    If IsMultJurisdiction(RetNo) then Tv[210] := Vl(FetchElm(RetNo,'T2203',203));
    Tv[211]:=Tv[209]+Tv[210];
    Tv[212] :=Vl(FetchElm(RetNo,'T1206',8)); //Vl(FetchElm(RetNo,'T1206',12));
    Tv[213]:= MaxR(Tv[211],Tv[212]);
    End
    Else
    Begin
     for i:=201 to 209 do begin Tv[i]:=0;end;
     Tv[148] :=0;
     Tv[149] :=0;
     for i:=210 to 213 do begin Tv[i]:=0;end;
    End;
  end; //with

  //part 7
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
   Tv[307]:=Tv[131];
   Tv[308]:=Tv[206];
   Tv[150] := Vl(FetchElm(RetNo,'T2203',51));    //jz 20250127
   Tv[151]:=Tv[308]+Tv[150];

   //Tv[152]:=??  T2038 //make user??//jz 20250127

   Tv[153]:=ret[RetNo].Lnn[41600];
   Tv[154]:=Tv[152]+Tv[153];
   Tv[155]:=Tv[154];
   Tv[156]:=Tv[151]-Tv[155];
   Tv[309]:=Tv[241];
   Tv[310]:=TV[225];
   Tv[311]:=MaxR(0,Tv[309]-Tv[310]);

   Tv[163]:=Tv[311];
   Tv[312] := Tv[239]; //jz 20250107 //Vl(FetchElm(RetNo,'T691',239));
   Tv[354] := Tv[235]+Tv[237]; //jz 20250107 //Vl(FetchElm(RetNo,'T691',235))+Vl(FetchElm(RetNo,'T691',237));
   If Tv[354]>0 then
    Tv[313] := Tv[311] * (Tv[312]/Tv[354])
   else
    Tv[313] :=0;

   Tv[314] := Tv[158] + Tv[313]; //20220206//Tv[304] + Tv[313];
     Tv[315] := Tv[314];
     Tv[316] := MaxR(0,(Tv[307] - Tv[315]));
  end;  //WITH

  //page 10
  //Part 8
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    Tv[317] := Vl(FetchElm(RetNo,'CFR',39));
    Tv[318] := Tv[220]; //jz 20250127 //Vl(FetchElm(RetNo,'T691',220));
    Tv[305] :=Vl(FetchElm(RetNo,'T2028',51));//20250222
          //Vl(FetchElm(RetNo,'T1206',52));//20220225//Vl(FetchElm(RetNo,'T1206',4));
    Tv[306] := MaxR(0,Tv[318]-Tv[305]);

    //Tv[157]:= t1208   ?
    //Tv[158]:=  ??
    Tv[49]  := Ret[RetNo].Lnn[41600];
    Tv[159] := Tv[157]+Tv[158]+Tv[49]; //jz 20240127
    Tv[160] := Tv[159];
    Tv[161] := Tv[306]-Tv[160];
    Tv[319] := Tv[131];  //Vl(FetchElm(RetNo,'T691',131));
      Tv[320] := MaxR(0,(Tv[161] - Tv[319])); //jz 20250127 //also, what does it mean override line 124 on the form??

    //jz 20250127 change to do what it seems it was trying to do:
    //if is not blank make sure the user input is not more than max allowed
    if Tv[321] > 0 then
      Tv[321] := MinR(Tv[321], MinR(Tv[317],Tv[320]))       //If Tv[321] > Tv[317] then Tv[321] :=Tv[317];  doesnt do enough //20110422
    else // if nothing entered auto fill the max amount allowed
      Tv[321] := MinR(Tv[317],Tv[320]);

      Tv[322] := MaxR(0,Tv[317] - Tv[321]);
      Tv[323] := Tv[151];

    Tv[301] :=Tv[322]+Tv[323];     //jz20250127 was missing
    //Tv[301] := user
    Tv[324]:=MaxR(0,Tv[301]-Tv[302]);
  end; //with

  //20250111
  //jz 20250127
  //page 10 part 9
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    //Tv[165] := Vl(FetchElm(RetNo,'T1',313)) + Vl(FetchElm(RetNo,'T1',314)) + Vl(FetchElm(RetNo,'T1',317)) ;
    //Tv[165] := ret[RetNo].Lnn[22100] + ret[RetNo].Lnn[22400] + ret[RetNo].Lnn[23200];

    Tv[166] := maxR(0,Tv[166]); //user input
    Tv[167] := maxR(0,Tv[167]); //user input
    Tv[168] := maxR(0,Tv[168]); //user input

    Tv[169] := Tv[166] + Tv[167] + Tv[168];
    Tv[170] := Tv[169];
    Tv[171] := maxR(0, Tv[165] - Tv[170]);
  end;

 SaveTv(RetNo,FName,FNo);
end;
*)





Procedure T2222(RetNo:integer;FName:string;FNo:integer);
var i: integer;
    D1,D2,Dt1,Dt2 : string[10];
    x,y : integer; Zone:String;
    DaysA,DaysB:Integer;
Begin
   LoadTv(RetNo,FName,FNo);
   with ret[RetNo].Frm[FNo]  do
   begin
    DaysA:=0;
    DaysB:=0;
    Strings[21]:=AppYear;
    If Strings[30]='' then Strings[30]:='A';
    If ret[RetNo].T4NorthA>0 then Strings[30]:='A';
    If ret[RetNo].T4NorthB>0 then Strings[30]:='B';
    Dt1 :=Strings[22];
    Dt2 :=Strings[23];
    If (Dt1>'') and (Dt2>'') then
    Begin
     If LeftStr(Strings[22],4) < Appyear then  Dt1 := AppYear+'-01-01';
     If LeftStr(Strings[23],4) > Appyear then  Dt2 := AppYear+'-12-31';
     D1 :=YYYYMMDDToDDMMYYYY(Dt1);
     D2 :=YYYYMMDDToDDMMYYYY(Dt2);
      If Strings[30]='A' then DaysA:=DaysA+DateDiffMDY(D1,D2)+1; //20120130 //20160119 Igor
      If Strings[30]='B' then DaysB:=DaysB+DateDiffMDY(D1,D2)+1; //20120130 //20160119 Igor
     end;

    i:=43;
    Repeat
     Dt1 :=Strings[i];
     Dt2 :=Strings[i+1];
     If (Dt1>'') and (Dt2>'') then
     Begin
      D1 :=YYYYMMDDToDDMMYYYY(Dt1);
      D2 :=YYYYMMDDToDDMMYYYY(Dt2);
       If Strings[i-3]='A' then DaysA:=DaysA+DateDiffMDY(D1,D2)+1; //20120130 //20160119 Igor
       If Strings[i-3]='B' then DaysB:=DaysB+DateDiffMDY(D1,D2)+1; //20120130 //20160119 Igor
     end;
     Inc(i,5);
    until i>58;

    If DaysA>0 then
    Begin
     Strings[1]:=IntToStr(DaysA);
     Tv[2] := Vl(Strings[1]) * 11; //8.25;  //20161119
     Tv[4] := Vl(Strings[3]) * 11;  //20161119 8.25;
     Tv[5] := Tv[2]+Tv[4];
    //Tv[6] := ret[RetNo].T4NorthA+ret[RetNo].T4ANorthA;  //20180210 Manual
     Tv[7] := MaxR(0,Tv[5]-Tv[6]);
     Tv[8] := Tv[7];
    end
    Else
    Begin
     For i:=1 to 8 do begin Tv[i]:=0;Strings[i]:='';end;  //20120130
    end;


   If DaysB>0 then
   begin
    Strings[9]:=IntToStr(DaysB);
    Tv[10] := Vl(Strings[9]) * 5.50; ////20161119  4.125;
    Tv[12] := Vl(Strings[11]) * 5.50; //20161119  4.125;
    Tv[13] := Tv[10]+Tv[12];
    //Tv[14] := ret[RetNo].T4NorthB+ret[RetNo].T4ANorthB; //20180210  //manual entry
    Tv[15] := MaxR(0,Tv[13]-Tv[14]);
    Tv[16] := Tv[15];
   end
   else
   Begin
     For i:=9 to 16 do begin Tv[i]:=0;Strings[i]:='';end;  //20120130
   end;

    Tv[17] := Tv[8]+Tv[16];

    Tv[18] := ret[RetNo].Lnn[23600];
    Tv[19] := MaxR(0,Tv[18] * 0.20);
    Tv[20] := MinR(Tv[17],Tv[19]);
   end;

   //pg 2
    //20220218
    with ret[RetNo].Frm[FNo] do
    begin
     TV[24]:= Tv[62]+Tv[64]+Tv[66];If Tv[24]>1200 then Tv[24]:=1200;
     TV[25]:= Tv[68]+Tv[70]+Tv[72];If Tv[25]>1200 then Tv[25]:=1200;
     TV[28]:= Tv[74]+Tv[76]+Tv[78];If Tv[28]>1200 then Tv[28]:=1200;
     TV[29]:= Tv[80]+Tv[82]+Tv[84];If Tv[29]>1200 then Tv[29]:=1200;


     i:=113;
     Tv[270]:=Tv[272];
     Tv[271]:=Tv[273];
     Repeat
      //If Tv[i]+Tv[i+1]+Tv[i+2]>0 then Strings[i-2]:='' else Strings[i-2]:=''; //20120130
      If Strings[i-2]='A' then
      begin
       Tv[I+3]:=MinR(Tv[i+2],MinR(Tv[i],Tv[i+1]));
       Tv[i+4]:=0;    //20220219 B column
       Tv[270]:=Tv[270]+Tv[i+3];
      end
      Else If Strings[i-2]='B' then
      begin
        Tv[i+4]:=MinR(Tv[i+2],MinR(Tv[i],Tv[i+1]));
        Tv[i+3]:=0;    //20220219  A column
        Tv[271]:=Tv[271]+Tv[i+4];
      end;
      Inc(i,8);
     until i>265;

     i:=191;  //20220219;
     Repeat
      if Strings[i]>'' then Strings[I+1]:='M' else Strings[I+1]:= '';
      Inc(i,8);
     Until i>264;

     Tv[101]:=Tv[270];
     Tv[102]:=Tv[271];
     Tv[103]:=Tv[102]*0.50;
    // Tv[104]:=Tv[101]+Tv[103];
     Tv[105]:=Tv[101]+Tv[103];

     Tv[106]:=Vl(FetchElm(RetNo,'T2222',20));
     Tv[107]:=Tv[105];
    // Tv[108]:=Tv[106]+Tv[107];
     Tv[109]:=Tv[106]+Tv[107];
    end;

    //pg 3
    with ret[RetNo].Frm[FNo] do
    begin
     Strings[301]:=AppYear;
    end;
    //pg 4
    with ret[RetNo].Frm[FNo] do
    begin
     Strings[401]:=AppYear;
    end;

  SaveTv(RetNo,FName,FNo);
End;

(* old
Procedure T657(RetNo:integer;FName:string;FNo:integer);
Var i,S3FNo,CfrFNo:Integer; IR:Real;
    AnnualGainsLimit, CumulativeGainsLimit,TotalEligibleCapGain, x:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1]:=AppYear;
  end;
  S3FNo:=GetFormNo('S3');
  CfrFNo:=GetFormNo('CFR');  //20190419

 //pg 2
   with ret[RetNo], ret[RetNo].Frm[FNo] do
   begin
     {annual gains limit}
     Tv[101] := GetElgblCapGains(RetNo);
     Tv[16]:=Vl(FetchElm(RetNo,'T2017',21))+Vl(FetchElm(RetNo,'T2017',22));  //20141225
     Tv[102]:=MaxR(0,Tv[101]+Tv[16]);
     Tv[135] := Tv[102];
     Tv[129] := Tv[135] * 1/2;
     Tv[104] := Vl(FetchElm(RetNo,'S3',97)); {total}
     Tv[137]:= Vl(FetchElm(RetNo,'S3',127)); {t3}
     Tv[138]:= MaxR(0,Tv[137]/2);
     Tv[139] := MaxR(0,Tv[104]-Tv[138]);
     Tv[107] := MinR(Tv[129],Tv[139]);
     Tv[108] := Tv[107];
     Tv[130] := Lnn[25300];
     Tv[131] := Vl(FetchElm(RetNo,'T936',7));
     Tv[132] := MaxR(0,(Tv[130] - Tv[131]));
     Tv[109] := Tv[132];
     Tv[110] := Lnn[21700];
     Tv[111] := Tv[109]+Tv[110];
     Tv[112] := Tv[111];
     Tv[113] := MaxR(0,(Tv[108] - Tv[112]));
     AnnualGainsLimit:=Tv[113];
     {cumulative gains limit}
     Tv[114] :=Vl(FetchElmFNo(RetNo,CFRFNo,1))
                 +Vl(FetchElmFNo(RetNo,CFRFNo,2))
                 +Vl(FetchElmFNo(RetNo,CFRFNo,3));

      Tv[284]:=Tv[108]; //20221219
      //Tv[196]:=Tv[108]; //20201017
      //Tv[267]:=Tv[108];   //20211222

      Tv[136]:=Tv[141]+Tv[142]+Tv[143]+Tv[144]+Tv[145]+Tv[146]+Tv[2]
          +Tv[4]+Tv[3]+Tv[26]+Tv[73]+Tv[19]+Tv[38]
          +Tv[154]
          +Tv[196]  //20201017
          +Tv[267] //20211221
          +Tv[284]; //20211219
        Tv[118] := Tv[114] + Tv[115] + Tv[116] + Tv[117]+Tv[133]+Tv[134]+Tv[140]+Tv[136];
      	Tv[119] := Tv[118];
        Tv[120] :=Vl(FetchElmFNo(RetNo,CFRFNo,409));
      	If Tv[120] >2000 then TV[120] := 2000;

        {abil prior years}
        Tv[121]:=0;
        //20140407   (21 to 25)
        Tv[121]:=Tv[121]
                      +Vl(FetchElmFNo(RetNo,CFRFNo,21))
                      +Vl(FetchElmFNo(RetNo,CFRFNo,22))
                      +Vl(FetchElmFNo(RetNo,CFRFNo,23))
                      +Vl(FetchElmFno(RetNo,CFRFNo,24))
                      +Vl(FetchElmFno(RetNo,CFRFNo,25))
                      +Vl(FetchElmFno(RetNo,CFRFNo,37))
                      +Vl(FetchElmFno(RetNo,CFRFNo,45))
                      +Vl(FetchElmFno(RetNo,CFRFNo,50))
                      +Vl(FetchElmFno(RetNo,CFRFNo,57))
                      +Vl(FetchElmFno(RetNo,CFRFNo,61))
                      +Vl(FetchElmFno(RetNo,CFRFNo,70))
                      +Vl(FetchElmFno(RetNo,CFRFNo,71))
                      +Vl(FetchElmFno(RetNo,CFRFNo,81))
                      +Vl(FetchElmFno(RetNo,CFRFNo,87))
                      +Vl(FetchElmFno(RetNo,CFRFNo,92))
                      +Vl(FetchElmFno(RetNo,CFRFNo,97)) //20140407
                      +Vl(FetchElmFno(RetNo,CFRFNo,267))
                      +Vl(FetchElmFno(RetNo,CFRFNo,272))
                      +Vl(FetchElmFno(RetNo,CFRFNo,277))
                      +Vl(FetchElmFno(RetNo,CFRFNo,282))  //20151116
                      +Vl(FetchElmFno(RetNo,CFRFNo,287))  //20161210
                      +Vl(FetchElmFno(RetNo,CFRFNo,292))  //20190921
                      +Vl(FetchElmFno(RetNo,CFRFNo,297))  //20190921
                      +Vl(FetchElmFno(RetNo,CFRFNo,302))  //20201017
                      +Vl(FetchElmFno(RetNo,CFRFNo,307))  //20201017
                      +Vl(FetchElmFno(RetNo,CFRFNo,312))  //20211221
                      +Vl(FetchElmFno(RetNo,CFRFNo,317))  //20221219
                      +Vl(FetchElmFno(RetNo,CFRFNo,322))  //20231111
                      ;

	Tv[122] :=Tv[389]; //20141225   Vl(FetchElm(RetNo,'T657',389));//20120730 Vl(FetchElm(RetNo,'T657',489));
	Tv[123] := Tv[112];
        Tv[124] := MaxR(0,Vl(FetchElm(RetNo,'T936',150)));
        Tv[125] :=0;
        For i:=16 to 20 do Tv[125] :=Tv[125]+Vl(FetchElmFNo(RetNo,CFRFNo,i));
        Tv[125]:=Tv[125]
                     +Vl(FetchElmFNo(RetNo,CfrFNo,36))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,44))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,49))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,56))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,62))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,69))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,60))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,80))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,86))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,91))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,96))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,266))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,271))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,276))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,281)) //20170419
                     +Vl(FetchElmFNo(RetNo,CfrFNo,286))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,291))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,296))
                     +Vl(FetchElmFNo(RetNo,CfrFNo,301))  //20201017
                     +Vl(FetchElmFNo(RetNo,CfrFNo,306))  //20201017
                     +Vl(FetchElmFNo(RetNo,CfrFNo,311))  //20201017
                     +Vl(FetchElmFNo(RetNo,CfrFNo,316))  //20201017
                     +Vl(FetchElmFNo(RetNo,CfrFNo,321))  //20231111
                     ;

	Tv[126] := 0;
	for i := 120 to 125 do
		Tv[126] := Tv[126] + Tv[i];
	Tv[127] := Tv[126];
	Tv[128] := MaxR(0,(Tv[119] - Tv[127]));
  CumulativeGainsLimit:=Tv[128];
   //20151121
    AnnualGainsLimit:=Tv[113];
    CumulativeGainsLimit:=Tv[128];
   end;
   //questionnare
   with ret[RetNo].Frm[FNo] do  //20141225
   Begin
    if Strings[74]+Strings[75]='' then Strings[75]:='X';
    if Strings[76]+Strings[77]='' then Strings[77]:='X';
    if Strings[9]+Strings[10]='' then Strings[10]:='X';
    if Strings[27]+Strings[28]='' then Strings[28]:='X';
    if Strings[29]+Strings[30]='' then Strings[30]:='X';
    if Strings[5]+Strings[6]='' then Strings[6]:='X';
    if Strings[22]+Strings[23]='' then Strings[23]:='X';
    if Strings[35]+Strings[37]='' then Strings[37]:='X';
    if Strings[7]+Strings[8]='' then Strings[8]:='X';
    if Strings[40]+Strings[41]='' then Strings[41]:='X';
    if Strings[171]+Strings[172]='' then Strings[172]:='X';
    if Strings[173]+Strings[174]='' then Strings[174]:='X';
    if Strings[248]+Strings[249]='' then Strings[249]:='X';
    if Strings[260]+Strings[251]='' then Strings[251]:='X';
    if Strings[197]+Strings[198]='' then Strings[198]:='X';
    if Strings[199]+Strings[200]='' then Strings[200]:='X';
    if Strings[285]+Strings[286]='' then Strings[286]:='X';
    if Strings[287]+Strings[288]='' then Strings[288]:='X';

    //20230408
    If Vl(FetchElm(RetNo,'S3',106))<>0   //QSBCS dispositions
    then begin Strings[285]:='X';Strings[286]:='';end;

    //20210305
    {//20230408
    If Vl(FetchElm(RetNo,'S3',106))<>0   //QSBCS dispositions
    then  begin Strings[197]:='X';Strings[198]:='';end;

    If Vl(FetchElm(RetNo,'S3',114))<>0   //QFPP dispositions
    then  begin Strings[197]:='X';Strings[198]:='';end;


    If Vl(FetchElm(RetNo,'S3',114))<>0   //QFPP dispositions
    then  begin Strings[199]:='X';Strings[200]:='';end;  //not 198 for No
    }

    //if Vl(FetchElm(RetNo,'T2017',31)) <>0 then begin Strings[22]:='X';Strings[23]:='';end; //20190420
    {    //20210305
    If Vl(FetchElm(RetNo,'S3',114))<>0   //QFPP dispositions
    then
     begin Strings[173]:='X';Strings[174]:='';end
    Else
      begin Strings[173]:='';Strings[174]:='X';end
    }
  end;

  //PART 3A
  with ret[RetNo].Frm[FNo] do  //20141225
  Begin

   if Strings[74]>'' then
   begin
   	Tv[201] := 375000; // 20171212 250000; //406800; //20151116 //400000; //375000; //20141225
	  {?t657-2 chart 3 is it 64}
    Tv[202] := Tv[402]; //Vl(FetchElm(RetNo,'T657',402)); //20141225
   	Tv[203] := MaxR(0,(Tv[201] - Tv[202]));
    Tv[204] := Tv[203];
    //20190223
    if UpperCase(Strings[39]) <> 'Y' then
       Tv[78]:= Vl(FetchElm(RetNo,'T2017',3)); //20171212 elm 3 instead of 1
    if UpperCase(Strings[49]) <> 'Y' then
       Tv[79]:= Vl(FetchElm(RetNo,'T2017',22)); //22 instead of 5 //20171212
    Tv[80]:=Tv[78]+Tv[79];
    Tv[81]:=Tv[80]/2;
    Tv[82]:=MinR(Tv[204],Tv[81]);
   end
   Else
   Begin
     for i:=201 to 204 do Tv[i]:=0;
     for i:=78 to 82 do Tv[i]:=0;
   End;

  //PART 3B
        If Strings[76]>'' then //see pg3 questions
        begin
         Tv[210]:=400000; //375000;
         Tv[211]:=Tv[402]; ////20141225  Vl(FetchElm(RetNo,'T657',402));
         Tv[212]:=MaxR(0,Tv[210]-Tv[211]);
         Tv[213]:=Tv[212];

         If ret[RetNo].Frm[FNo].Strings[24]<>'Y' then Tv[214]:=Vl(FetchElm(RetNo,'T2017',3)); //20150228  A
         If ret[RetNo].Frm[FNo].Strings[25]<>'Y' then Tv[215]:=Vl(FetchElm(RetNo,'T2017',22)); //20150218  D
         Tv[216]:=MaxR(0,Tv[214]+Tv[215]);
         Tv[217]:=Tv[216]/2;
         Tv[218]:=MinR(Tv[213],Tv[217]);
         Tv[219]:=MaxR(0,Tv[82]);
         Tv[220]:=Tv[218]+Tv[219];
        end
        Else
        Begin
          For i:=210 to 220 do Tv[i]:=0;
        end;

  //PART 3C
        If Strings[9]>'' then
        begin
         Tv[11]:=406800; //400000;
         Tv[12]:=Tv[402];
         Tv[13]:=MaxR(0,Tv[11]-Tv[12]);
         Tv[14]:=Tv[13];
         If UpperCase(ret[RetNo].Frm[FNo].Strings[55])<>'Y' then Tv[15]:=Vl(FetchElm(RetNo,'T2017',21)); //20171212 21 instead of 3
         If UpperCase(ret[RetNo].Frm[FNo].Strings[56])<>'Y' then Tv[17]:=Vl(FetchElm(RetNo,'T2017',22)); //instead of
         Tv[83]:=MaxR(0,Tv[15]+Tv[17]);
         Tv[84]:=Tv[83]/2;
         Tv[85]:=MinR(Tv[14],Tv[84]);

         if Tv[220]>0 then Tv[86]:=Tv[220]
         Else if Tv[82]>0 then Tv[86]:=Tv[82];

         Tv[87]:=Tv[85]+Tv[86];   //20150228  //Tv[20]+Tv[21];
        end
        Else
        begin
         For i:=11 to 15 do Tv[i]:=0;
         Tv[17]:=0;
         For i:=83 to 87 do Tv[i]:=0;
        end;

    //PART 3D
        //20151116
        If Strings[27]>'' then  //questionnaire
        begin
         if (AnnualGainsLimit >= Tv[14]) //in 3C
         and (CumulativeGainsLimit >= Tv[14]) //in 3C
         and (Tv[87] >= Tv[14])   //in 3c
         Then
         Begin
         Tv[31]:=500000; //406800;
         Tv[32]:=Tv[402];
         Tv[88]:=MaxR(0,Tv[31]-Tv[32]-Tv[87]); //20190224
         Tv[89]:=Tv[88];
         if UpperCase(Strings[93])<>'Y' then  //20180223
            Tv[33]:= vl(FetchElm(RetNo,'T2017',8));
         Tv[44]:=Tv[33]/2;
         Tv[90]:= MinR(Tv[89],Tv[44]); //vl(FetchElm(RetNo,'T2017',7));
        // Tv[91]:=Tv[33]+Tv[90];
         Tv[34]:=Tv[87]; //Tv[91] /2;
         Tv[92]:=Tv[90]+Tv[34];  //MinR(Tv[89],Tv[34]);
         Tv[94]:=MinR(Tv[44],Tv[92]); //Tv[92]+Tv[93];
         end
        end
        Else
        Begin
         For i:=31 to 34 do Tv[i]:=0;
         Tv[88]:=0;Tv[89]:=0;
         Tv[90]:=0; Tv[92]:=0;Tv[94]:=0; //For i:=90 to 94 do Tv[i]:=0;
        end;

    //PART 3E
        If Strings[29]>'' then
        begin
         Tv[42]:= 412088; //500000;
         Tv[43]:=Tv[402];
         if UpperCase(Strings[103])<>'Y' then
           Tv[95]:=MaxR(0,Tv[42]-Tv[43]);
         Tv[96]:=Tv[95];

         if UpperCase(Strings[105])<>'Y' then
           Tv[97]:=vl(FetchElm(RetNo,'T2017',8));
         if UpperCase(Strings[106])<>'Y' then
          Tv[45]:=vl(FetchElm(RetNo,'T2017',22));
         Tv[46]:=MaxR(0,Tv[97]+Tv[45]);
         Tv[98]:=Tv[46]/2;

         Tv[52]:=MinR(Tv[96],Tv[98]);
         //20190224
         if Tv[94]>0 then      Tv[53]:=Tv[94]
         Else if Tv[87]>0 then Tv[53]:=Tv[87]
         Else if Tv[220]>0 then Tv[53]:=Tv[220]
         Else if Tv[82]>0 then Tv[53]:=Tv[82];
         Tv[54]:=Tv[52]+Tv[53];
       end
       Else
       Begin
        For i:=42 to 43 do Tv[i]:=0;
        For i:=45 to 46 do Tv[i]:=0;
        For i:=52 to 54 do Tv[i]:=0;
        For i:=95 to 98 do Tv[i]:=0;
       End;

    //PART 3F
       if (Strings[5]>'')
       and ((Tv[113]>=Tv[96]) and (Tv[128]>=Tv[96]) and (Tv[54]>=Tv[96])) then
       Begin
        Tv[61]:=500000-Tv[54]; //412088;
        Tv[62]:=Tv[402];
        Tv[99]:=MaxR(0,Tv[61]-Tv[62]);
        Tv[100]:=Tv[99];

        Tv[47]:=Vl(FetchElm(RetNo,'T2017',8));  //20190419
        Tv[48]:=Tv[47]/2;

        Tv[147]:=MinR(Tv[100],Tv[48]); //Vl(FetchElm(RetNo,'S3',106));
        Tv[148]:=Tv[54]; //Vl(FetchElm(RetNo,'S3',114));
        Tv[149]:=Tv[147]+Tv[148]; //Vl(FetchElm(RetNo,'S3',122));
        Tv[150]:=MinR(Tv[48],Tv[149]); //Vl(FetchElm(RetNo,'T2017',8));
       End
       Else
       Begin
        For i:=61 to 62 do Tv[i]:=0;
        For i:=47 to 48 do Tv[i]:=0;
        For i:=99 to 100 do Tv[i]:=0;
        For i:=147 to 150 do Tv[i]:=0;
       End;

   //PART 3G
      if (Strings[22]>'') //Or (Strings[40]>'')
      then
      Begin
        Tv[68]:=417858;
        Tv[69]:=Tv[402];
        if UpperCase(Strings[151]) <> 'Y'  then
        Begin
          Tv[158]:=MaxR(0,Tv[68]-Tv[69]); //-Tv[157]); //20170429  //MaxR(0,Tv[68]-Tv[69]);
          //20190419
          x:=0;
          if     Tv[150]>0 then x:=Tv[150]
          else if Tv[54]>0 then x:=Tv[54]
          else if Tv[94]>0 then x:=Tv[94]
          Else if Tv[87]>0 then x:=Tv[87]
          Else if Tv[220]>0 then x:=Tv[220]
          Else if Tv[82]>0 then x:=Tv[82];
          Tv[158]:=MaxR(0,Tv[158]-x);
        end;

        Tv[159]:=Tv[158];

        if UpperCase(Strings[152]) <> 'Y'  then
          Tv[162]:=Vl(FetchElm(RetNo,'T2017',8));
        if UpperCase(Strings[153]) <> 'Y'  then
         Tv[50]:=Vl(FetchElm(RetNo,'T2017',22));
        Tv[70]:=MaxR(0,Tv[162]+Tv[50]);
        Tv[72]:=Tv[70]/2;

        Tv[166]:=MinR(Tv[159],Tv[72]);
        //20200116
        x:=0;
        if     Tv[150]>0 then x:=Tv[150] //38 bold no on form
        else if Tv[54]>0 then x:=Tv[54]  //47
        else if Tv[94]>0 then x:=Tv[94]  //56
        Else if Tv[87]>0 then x:=Tv[87]  //64
        Else if Tv[220]>0 then x:=Tv[220] //73
        Else if Tv[82]>0 then x:=Tv[82];  //81
        Tv[167]:=x;
        Tv[168]:=Tv[166]+Tv[167];
      End
      Else
      Begin
       For i:=68 to 70 do Tv[i]:=0;
       Tv[72]:=0;
       Tv[50]:=0;
       For i:=158 to 159 do Tv[i]:=0;
       For i:=166 to 168 do Tv[i]:=0;
      End;

  //PART 3H
      if (Strings[35]>'')
       and (Tv[113]>=Tv[159])
       and (Tv[128]>=Tv[159])
       and (Tv[168]>=Tv[159]) then
       Begin
        Tv[20]:=500000;
        Tv[21]:=Tv[402];
        Tv[51]:=MaxR(0,Tv[20]-Tv[21]);
        Tv[57]:=Tv[51];
        Tv[58]:=Vl(FetchElm(RetNo,'T2017',8));
        Tv[36]:=Tv[58]/2;
        Tv[59]:=MinR(Tv[57],Tv[36]);
        Tv[60]:=Tv[168];
        Tv[63]:=Tv[59]+Tv[60];
        Tv[64]:=MinR(Tv[36],Tv[63]);
       End
       Else
       Begin
        For i:=20 to 21 do Tv[i]:=0;
        Tv[51]:=0;
        For i:=57 to 60 do Tv[i]:=0;
        Tv[63]:=0;
        Tv[64]:=0;
       End;

   //PART 3I
   if Strings[7]>'' then
   begin
    Tv[327]:=424126;
    Tv[335]:=Tv[402];
    // -------------
    Tv[343]:=MaxR(0,Tv[327]-Tv[335]);  //see below
    //what to subtract
    x:=0;
    //if True then
    if   Tv[64]>0 then           x:=Tv[64]    //20190419
         else if Tv[168]>0 then  x:=Tv[168]   //20190419
         else if Tv[150]>0 then  x:=Tv[150]
         else if Tv[54]>0 then   x:=Tv[54]
         else if Tv[94]>0 then   x:=Tv[94]
         Else if Tv[87]>0 then   x:=Tv[87]
         Else if Tv[220]>0 then  x:=Tv[220]
         Else if Tv[82]>0 then   x:=Tv[82];
    Tv[343]:=Maxr(0,Tv[343]-x);  //footnote 21

    Tv[351]:=Tv[343];
    Tv[304]:=Vl(FetchElm(RetNo,'T2017',8));  //20190419
    Tv[313]:=Vl(FetchElm(RetNo,'T2017',22)); //amount D ]//MinR(Tv[351],Tv[305]);
    Tv[66] :=MaxR(0,Tv[304]+Tv[313]);
    Tv[321]:=Round(Tv[66]/2);
    Tv[65]:=MinR(Tv[351],tv[321]); //Tv[313]+Tv[321];

    x:=0;
    if     Tv[150]>0 then x:=Tv[150] //38 bold no on form
    else if Tv[54]>0 then x:=Tv[54]  //47
    else if Tv[94]>0 then x:=Tv[94]  //56
    Else if Tv[87]>0 then x:=Tv[87]  //64
    Else if Tv[220]>0 then x:=Tv[220] //73
    Else if Tv[82]>0 then x:=Tv[82]  //81
    Else if Tv[168]>0 then x:=Tv[168]  //90
    Else if Tv[64]>0 then x:=Tv[64];  //98

    Tv[175]:=x;
    Tv[176]:=Tv[65]+Tv[175];
   end
   Else
   Begin
    Tv[327]:=0;
    Tv[335]:=0;
    Tv[343]:=0;
    Tv[351]:=0;
    Tv[304]:=0;
    Tv[313]:=0;
    Tv[66] :=0;
    Tv[321]:=0;
    Tv[65]:=0;
    Tv[175]:=0;
    Tv[176]:=0;
   End;

  //PART 3J
   if (Strings[40]>'')
   AND ((Tv[113]>Tv[351]) and (Tv[128]>Tv[351]) and (Tv[65]>Tv[351]))  //20190419 instead of OR
   then
   begin
    Tv[306]:=MaxR(0,500000 - Tv[65]);  //note 24
    Tv[314]:=Tv[402];
    Tv[322]:=MaxR(0,Tv[306]-Tv[314]);
    Tv[345]:=Tv[322];

    Tv[353]:=Vl(FetchElm(RetNo,'S3',114));
    Tv[361]:=Vl(FetchElm(RetNo,'S3',122));

    Tv[369]:=Vl(FetchElm(RetNo,'T2017',8));  //20190417
    //Tv[377]:=Tv[353]+Tv[361]+Tv[369];
    //Tv[66]:=Tv[377]/2;
    Tv[71]:=Round(Tv[369]/2);
    Tv[67]:=MinR(Tv[345],Tv[71]);
    Tv[178]:=Tv[176];
    Tv[179]:=Tv[67]+Tv[178];
    Tv[91]:=MinR(Tv[71],Tv[179]); //Tv[67]+Tv[71];
   end
   Else
   Begin
    Tv[306]:=0;
    Tv[314]:=0;
    Tv[322]:=0;
    Tv[345]:=0;

    Tv[369]:=0;
    Tv[71]:=0;
    Tv[67]:=0;
    Tv[178]:=0;
    Tv[179]:=0;
    Tv[91]:=0;
   End;

   //PART 3K
   if (Strings[171]>'')  //if (Strings[17]>'') //20200414
   then
   Begin
    Tv[181]:=433456;
    Tv[182]:=Tv[402]; //line kchart 2
    Tv[183]:=MaxR(0,Tv[181]-Tv[182]);
    Tv[184]:=Tv[183];
    Tv[185]:=Vl(FetchElm(RetNo,'S3',106));
    Tv[186]:=Vl(FetchElm(RetNo,'S3',114));
    Tv[187]:=Vl(FetchElm(RetNo,'S3',122));

    Tv[188]:=Vl(FetchElm(RetNo,'T2017',8));   //line B
    Tv[189]:=Vl(FetchElm(RetNo,'T2017',22)); //line D
    Tv[191]:=MaXR(0,Tv[185]+Tv[186]+Tv[187]+Tv[188]+Tv[189]);  //20200413

    Tv[192]:=Round(Tv[191]/2);
    Tv[193]:=MinR(Tv[184],Tv[192]);
   //20200116
    x:=0;
    if     Tv[150]>0 then x:=Tv[150] //38 bold no on form
    else if Tv[54]>0 then x:=Tv[54]  //47
    else if Tv[94]>0 then x:=Tv[94]  //56
    Else if Tv[87]>0 then x:=Tv[87]  //64
    Else if Tv[220]>0 then x:=Tv[220] //73
    Else if Tv[82]>0 then x:=Tv[82]  //81
    Else if Tv[168]>0 then x:=Tv[168]  //90
    Else if Tv[64]>0 then x:=Tv[64]  //98
    Else if Tv[176]>0 then x:=Tv[176]  //107
    Else if Tv[115]>0 then x:=Tv[115];  //91
    Tv[194]:=x;
    Tv[195]:=Tv[193]+Tv[194];
   End
   else   //20211228
   Begin
    For i:=182 to 189 do Tv[i]:=0;
    For i:=191 to 193 do Tv[i]:=0;
    Tv[195]:=0;
   End;


  //PART 3L
   if (Strings[173]>'') then
   Begin
    Tv[165]:=500000;
    Tv[164]:= Tv[402];
    Tv[163]:=MaxR(0,Tv[165]-Tv[164]-Tv[195]);
    Tv[161]:=Tv[163];
    Tv[160]:=Vl(FetchElm(RetNo,'S3',114));
    Tv[157]:=Vl(FetchElm(RetNo,'S3',122));
    Tv[156]:=Vl(FetchElm(RetNo,'T2017',8)); //line B
    Tv[155]:=Tv[160]+Tv[157]+Tv[156];
    Tv[169]:=Tv[155]/2;
    Tv[170]:=MinR(Tv[161],Tv[169]);
    Tv[177]:=Tv[195];
    Tv[180]:=Tv[170]+Tv[177];
    Tv[205]:=MinR(Tv[169],Tv[180]);  //20210305
   End
   Else
   Begin
    For i:=63 to 65 do Tv[i]:=0;
    Tv[161]:=0;
    Tv[160]:=0;
    For i:=155 to 157 do Tv[i]:=0;
    Tv[169]:=0;
    Tv[170]:=0;
    Tv[177]:=0;
    Tv[180]:=0;
    Tv[205]:=0;
   End;

 //PART 3M    New  //20210305
  if (Strings[248]>'') then  //20211228
  Begin
   Tv[206]:=441692;
   Tv[207]:=Tv[402];
   x:=0;
   If Tv[82]>0 then x:=Tv[82]  //38
   Else if Tv[220]>0 then x:=Tv[220]
   Else if Tv[220]>0 then x:=Tv[220]
   Else if Tv[87]>0 then x:=Tv[87]
   Else if Tv[94]>0 then x:=Tv[94]
   Else if Tv[54]>0 then x:=Tv[54]
   Else if Tv[150]>0 then x:=Tv[150]
   Else if Tv[168]>0 then x:=Tv[168]
   Else if Tv[64]>0 then x:=Tv[64]
   Else if Tv[176]>0 then x:=Tv[176]
   Else if Tv[91]>0 then x:=Tv[91]
   Else if Tv[195]>0 then x:=Tv[195]
   Else if Tv[205]>0 then x:=Tv[205];
   Tv[208]:=MaxR(0,Tv[206]-Tv[207]-x);  //20210307
   Tv[209]:=Tv[208];
   Tv[225]:= vl(FetchElm(RetNo,'T2017]',6));
   Tv[226]:= vl(FetchElm(RetNo,'T2017]',22));
   Tv[227]:=Tv[225]+Tv[226]; //20211221 //MaxR(0,Tv[222]+Tv[223]+Tv[224]+Tv[225]+Tv[226]);   //20210520
   Tv[228]:=Tv[227]/2;
   Tv[229]:=MinR(Tv[209],Tv[228]);
   x:=0;
   If Tv[82]>0 then x:=Tv[82]  //38
   Else if Tv[220]>0 then x:=Tv[220]
   Else if Tv[220]>0 then x:=Tv[220]
   Else if Tv[87]>0 then x:=Tv[87]
   Else if Tv[94]>0 then x:=Tv[94]
   Else if Tv[54]>0 then x:=Tv[54]
   Else if Tv[150]>0 then x:=Tv[150]
   Else if Tv[168]>0 then x:=Tv[168]
   Else if Tv[64]>0 then x:=Tv[64]
   Else if Tv[176]>0 then x:=Tv[176]
   Else if Tv[91]>0 then x:=Tv[91]
   Else if Tv[195]>0 then x:=Tv[195]
   Else if Tv[205]>0 then x:=Tv[205];
   Tv[230]:=x;
   Tv[231]:=Tv[229]+Tv[230];
  end
  Else
  Begin
   Tv[207]:=0;
   Tv[82]:=0;
   Tv[208]:=0;
   Tv[209]:=0;
   for i:=225 to 231 do Tv[i]:=0;
  End;
 //end of M ---------------------------

  TotalEligibleCapGain:=Tv[231];   //20210307

 //PART 3N    New  //20210305
  if (Strings[199]>'') then
  Begin
   If CumulativeGainsLimit >= 441692 then
   Begin
    Tv[232]:=500000;
    Tv[233]:=Tv[402];
    Tv[234]:=MaxR(0,+Tv[232]-Tv[233]-TotalEligibleCapGain);  //20210307
    Tv[235]:=Tv[234];
    Tv[240]:=Vl(FetchElm(RetNo,'T2017',6)); //20211221//Tv[236]+Tv[237]+Tv[238];
    Tv[241]:=Tv[240]/2;
    Tv[242]:=MinR(Tv[235],Tv[241]);
    Tv[243]:=Tv[231];
    Tv[244]:=Tv[242]+Tv[243];
   End;
  end;
  Tv[268]:=MinR(Tv[242],Tv[244]); //20230402

 //End of 3N=====================

 //Part 3o  //20211221
 Tv[252]:=446109;
 Tv[253]:=Tv[402];
 Tv[254]:=MaxR(0,Tv[252]-Tv[253]);
 Tv[255]:=Tv[254];
 //20221219
 Tv[289]:=Vl(FetchElm(RetNo,'T2017',6));
 Tv[290]:=Vl(FetchElm(RetNo,'T2017',22));

 Tv[261]:=Tv[289]+Tv[290]; //20230331
 Tv[262]:=Tv[261]/2 ;
 Tv[263]:=MinR(Tv[255],Tv[262]);

 x:=0;
 If Tv[82]>0 then x:=Tv[82]  //38
 Else if Tv[220]>0 then x:=Tv[220]
 Else if Tv[87]>0 then x:=Tv[87]
 Else if Tv[94]>0 then x:=Tv[94]
 Else if Tv[54]>0 then x:=Tv[54]
 Else if Tv[150]>0 then x:=Tv[150]
 Else if Tv[168]>0 then x:=Tv[168]
 Else if Tv[64]>0 then x:=Tv[64]
 Else if Tv[176]>0 then x:=Tv[176]
 Else if Tv[91]>0 then x:=Tv[91]
 Else if Tv[195]>0 then x:=Tv[195]
 Else if Tv[205]>0 then x:=Tv[205]
 Else if Tv[231]>0 then x:=Tv[231]
 Else if Tv[268]>0 then x:=Tv[268]
 ;

 Tv[264]:=x;
 Tv[265]:=MaxR(0,Tv[263]-Tv[264]);

 //Part 3P //20211221
   if (Vl(FetchElm(RetNo,'S3',113))>0)
   and (Strings[199]>'')  //qff dispositions
   // and (Tv[113]>Tv[255]) and (Tv[128]>Tv[255]) and (Tv[165]>Tv[255])
   then
   Begin
    Tv[156]:=500000;
    Tv[157]:=Tv[402];
    Tv[160]:=MaxR(0,Tv[156]-Tv[157]-Tv[265]);
    Tv[185]:=Tv[160];
    Tv[187]:=Vl(FetchElm(RetNo,'T2017',6)); //20230408  //Tv[246]+Tv[247]+Tv[186];
    Tv[266]:=Tv[187]/2;
    Tv[190]:=MinR(Tv[185],Tv[266]);
    Tv[239]:=Tv[265];
    Tv[291]:=Tv[190]+Tv[239]; //20221219
    Tv[245]:=MinR(Tv[190],Tv[239]);//20221219//Tv[190]+Tv[239];
    {
    if UpperCase(Ret[RetNo].Frm[FNo].Strings[18])<>'Y' then
      Tv[221]:=MinR(Tv[113],MinR(Tv[128],Tv[291])); //20221219  //final for jacket
    }
   End
   Else
   Begin
    Tv[156]:=0;
    Tv[145]:=0;
    Tv[245]:=0;
    if UpperCase(Ret[RetNo].Frm[FNo].Strings[18])<>'Y' then
     Tv[221]:=MinR(Tv[113],MinR(Tv[128],Tv[265]));  //final for jacket
   End;


  //Part 3q  Lines 163 to 169 New page in 2022 elms 132 to 272
   Tv[132]:=456815;
   //20230331
   Tv[222]:=Tv[402];
   Tv[223]:=MaxR(0,Tv[132]-Tv[222]);
   Tv[224]:=Tv[223];
   Tv[236]:=Vl(FetchElm(RetNo,'S3',106));
   Tv[237]:=Vl(FetchElm(RetNo,'S3',114));
   Tv[238]:=Vl(FetchElm(RetNo,'S3',122));
   Tv[293]:=Vl(FetchElm(RetNo,'T2017',6));
   Tv[294]:=Vl(FetchElm(RetNo,'T2017',22));
   Tv[295]:=MaxR(0,Tv[236]+Tv[237]+Tv[238]+Tv[293]+Tv[294]);
   Tv[269]:=Tv[295]/2;
   Tv[270]:=MinR(Tv[224],Tv[269]);

   x:=0;
   If Tv[82]>0 then x:=Tv[82]  //38
   Else if Tv[220]>0 then x:=Tv[220]
   Else if Tv[87]>0 then x:=Tv[87]
   Else if Tv[94]>0 then x:=Tv[94]
   Else if Tv[54]>0 then x:=Tv[54]
   Else if Tv[150]>0 then x:=Tv[150]
   Else if Tv[168]>0 then x:=Tv[168]
   Else if Tv[64]>0 then x:=Tv[64]
   Else if Tv[176]>0 then x:=Tv[176]
   Else if Tv[91]>0 then x:=Tv[91]
   Else if Tv[195]>0 then x:=Tv[195]
   Else if Tv[205]>0 then x:=Tv[205]
   Else if Tv[231]>0 then x:=Tv[231]
   Else if Tv[268]>0 then x:=Tv[268]  //???
   ;
   Tv[271]:=x;  //20230402
   Tv[272]:=Tv[270]+Tv[271];

  //Part 3r  Lines 170 to 176  Elms 273 to w98
  // Tv[273]:=MaxR(0,500000 - Tv[172]); //20230408
   Tv[273]:=500000;
   //20230402
   Tv[274]:=Tv[402];
   Tv[275]:=MaxR(0,Tv[273]-Tv[274]-Tv[272]); //this causes problems//Tv[273]:=MaxR(0,500000
   Tv[276]:=Tv[275];
   Tv[277]:= Vl(FetchElm(RetNo,'S3',114));
   Tv[278]:= Vl(FetchElm(RetNo,'S3',122));
   Tv[279]:= Vl(FetchElm(RetNo,'T2017',6));
   Tv[280]:=Tv[277]+Tv[278]+Tv[279];
   Tv[281]:=Tv[280]/2;
   Tv[282]:=MinR(Tv[276],Tv[281]);
   Tv[283]:=Tv[272];
   Tv[296]:=Tv[282]+Tv[283];

   if UpperCase(Ret[RetNo].Frm[FNo].Strings[18])<>'Y' then
     // Tv[221]:=MinR(Tv[113],MinR(Tv[128],Tv[291])); //20221219  //final for jacket
   Tv[221]:=MinR(Tv[113],MinR(Tv[128],Tv[296])); //20230402 //final for jacket
  //Chart1
   Tv[389] := 0;

   Tv[307]:=Tv[303];
   Tv[308]:=MaxR(0,Tv[302]-Tv[307]);
   Tv[315]:=Tv[311];
   Tv[316]:=MaxR(0,Tv[310]-Tv[315]);

   Tv[323]:=Tv[319];
   Tv[324]:=MaxR(0,Tv[318]-Tv[323]);

   Tv[330]:=MaxR(0,Tv[328]-Tv[329]);
   Tv[331]:=Tv[330];
   Tv[332]:=MaxR(0,Tv[326]-Tv[331]);

   Tv[338]:=MaxR(0,Tv[336]-Tv[337]);
   Tv[339]:=Tv[338];
   Tv[340]:=MaxR(0,Tv[334]-Tv[339]);

   i:=342;
   Repeat
    Tv[i+4] := Tv[i+2];
    Tv[i+5] := Tv[i+4];
    Tv[i+6] := MaxR(0,Tv[i] - Tv[i+5]);
    Tv[389] := Tv[389]+Tv[i+6];
    Inc(i,8);
   until i>374;

   // CHART 2
   Tv[390] := Vl(FetchElm(RetNo,'CFR',16));  {85,86,87}
   Tv[391] := MaxR(0,
              Vl(FetchElm(RetNo,'CFR',17))  {88-89}
             -Vl(FetchElm(RetNo,'CFR',26))
             -Vl(FetchElm(RetNo,'CFR',27)));
   Tv[392] := Tv[391]/4;
   Tv[393] := MaxR(0,Vl(FetchElm(RetNo,'CFR',17))- Tv[391]);
   Tv[393] := MinR(Tv[93],Vl(FetchElm(RetNo,'CFR',26))
                        +Vl(FetchElm(RetNo,'CFR',27)));
   Tv[396] := Tv[393] * (1/3);

   Tv[394] := Vl(FetchElm(RetNo,'CFR',18))+ {90-99}
             Vl(FetchElm(RetNo,'CFR',19))+
             Vl(FetchElm(RetNo,'CFR',20));
   Tv[395]:= Tv[394]/3;

   Tv[397]:= Vl(FetchElm(RetNo,'CFR',36)); {ded in 2000}
   Strings[398]:=FetchElm(RetNo,'CFR',40);   //FAILS 20201017
   IR:=Vl(Strings[398])/100;

   If IR >0 then
    Tv[400] := Tv[397] * (1-(1/(2*IR)))
   else
    Tv[400] :=0;
   Tv[401]:= vl(FetchElmFNo(RetNo,CfrFno,44))
            +vl(FetchElmFNo(RetNo,CfrFno,49))
            +vl(FetchElmFNo(RetNo,CfrFno,56))
            +vl(FetchElmFNo(RetNo,CfrFno,62))
            +vl(FetchElmFNo(RetNo,CfrFno,69))
            +vl(FetchElmFNo(RetNo,CfrFno,60))
            +vl(FetchElmFNo(RetNo,CfrFno,80))
            +vl(FetchElmFNo(RetNo,CfrFno,86))
            +vl(FetchElmFNo(RetNo,CfrFno,91))
            +vl(FetchElmFNo(RetNo,CfrFno,96))
            +vl(FetchElmFNo(RetNo,CfrFno,266))
            +Vl(FetchElmFNo(RetNo,CfrFno,271))
            +Vl(FetchElmFNo(RetNo,CfrFno,276))
            +Vl(FetchElmFNo(RetNo,CfrFno,281))
            +Vl(FetchElmFNo(RetNo,CfrFno,286))
            +Vl(FetchElmFNo(RetNo,CfrFno,291))
            +Vl(FetchElmFNo(RetNo,CfrFno,296))   //20190108
            +Vl(FetchElmFNo(RetNo,CfrFno,301))   //20200517
            +Vl(FetchElmFNo(RetNo,CfrFno,306))   //20201017
            +Vl(FetchElmFNo(RetNo,CfrFno,311))   //2023111
            +Vl(FetchElmFNo(RetNo,CfrFno,316))   //2023111
            +Vl(FetchElmFNo(RetNo,CfrFno,321))   //2023111
            ;

   Tv[402]:= MaxR(0,Tv[390]+Tv[391]-Tv[392]+Tv[393]-Tv[396]+Tv[394]
            -Tv[395]+Tv[397]-Tv[400]+Tv[401]);
 End;
 SaveTv(RetNo,FName,FNo);
end;
*)


Function GetElgblCapGains(RetNo:integer):real;
begin
  result :=Vl(FetchElm(RetNo,'S3',106))+Vl(FetchElm(RetNo,'S3',114))
           +Vl(FetchElm(RetNo,'S3',122));
end;

//20251008 Igor >>>
procedure T2209(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
  x: Real;
begin
  LoadTv(RetNo, FName, FNo);

  if ExtractFormInst(FName).Equals('#1') then k:= 0 else
  if ExtractFormInst(FName).Equals('#2') then k:= 2 else
  if ExtractFormInst(FName).Equals('#3') then k:= 4 else exit; {ignore more than three}

  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    if (k = 0) then Frm[Fno].Strings[39]:= FetchElm(RetNo, 'FORINC', 1) else
    if (k = 2) then Frm[Fno].Strings[39]:= FetchElm(RetNo, 'FORINC', 2) else
    if (k = 4) then Frm[Fno].Strings[39] := FetchElm(RetNo, 'FORINC', 3);

    Tv[1]:= Vl(FetchElm(RetNo, 'FORINC', 158 + k));
    Tv[2]:= Vl(FetchElm(RetNo, 'FORINC', 157 + k));
    Tv[5]:= MaxR(0, SelectNetIncomeAmount(RetNo) //20250222  //Lnn[23600]
            + Vl(FetchElm(RetNo, 'T1206', 3)) - Lnn[24400] - Lnn[24900] - Lnn[25000] - Lnn[25300] - Lnn[25400] - Vl(FetchElm(RetNo, 'OTHDED', 22)));

    if (Tv[2] > Tv[5]) then Tv[2]:= Tv[5];

    if not Ret[RetNo].Province.Equals('YT') then Ret[RetNo].Lnn[44100]:= 0;

    Tv[3]:= MaxR(0, Ret[RetNo].Lnn[42900] + Ret[RetNo].Lnn[40425] + Vl(FetchElm(RetNo, 'T1', 53)) - Ret[RetNo].Lnn[44000] - Ret[RetNo].Lnn[44100]);

    if Ret[RetNo].Province.Equals('YT') then //abatement based on before minim tax then Foreign tax credit
    begin
      Tv[3]:= MaxR(0, Vl(FetchElm(RetNo, 'T691', 206)) + ret[RetNo].Lnn[40425] + Ret[RetNo].Lnn[42600] + Vl(FetchElm(RetNo, 'T1', 53)) - Ret[RetNo].Lnn[44000]); //qc

      if SubjectToMinTax(RetNo) then Tv[3]:= MaxR(0, Tv[3] - Vl(FetchElm(RetNo, 'YT432', 1))); //use the before min tax abatement //20091224
    end;

    if Ret[RetNo].Province.Equals('QC') then
      Tv[3]:= MaxR(0, Vl(FetchElm(RetNo, 'T691', 206)) + Ret[RetNo].Lnn[40425] + Ret[RetNo].Lnn[42600] + Vl(FetchElm(RetNo, 'T1', 53)) - GetQuebecAbat(RetNo, True)); //use the before min tax abatement  //20091224

    if (Tv[5] > 0) then Tv[4]:= (Tv[2] / Tv[5]) * Tv[3] else Tv[4]:=0;
    if (Tv[4] > Tv[3]) then Tv[4]:= Tv[3];

    Tv[6]:= MinR(Tv[1], Tv[4]);
    Tv[6]:= MinR(Tv[6], Ret[RetNo].Lnn[42900]); //jz//20250301 - cannot be more than line 42900 as per form
    Tv[7]:= Vl(FetchElm(RetNo, 'FORINC', 208 + k)) + Vl(FetchElm(RetNo, 'FORINC', 213 + k)); {? k not correct}
    Tv[8]:= Vl(FetchElm(RetNo, 'FORINC', 207 + k));
    TV[11]:= Tv[5];
    Tv[9]:= Ret[RetNo].Lnn[42900] + Ret[RetNo].Lnn[40425] + Ret[RetNo].Lnn[42600];

    if (Tv[11] > 0) then Tv[10]:= (Tv[8] / Tv[11]) * Tv[9] else Tv[10]:= 0;
    if (Tv[10] > Tv[9]) then Tv[10]:= Tv[9];

    Tv[12]:= Vl(FetchElm(RetNo, 'T1', 53));  //surtax// Vl(FetchElm(RetNo,'S1',110)); //20190922
    Tv[13]:= Tv[10] + Tv[12];
    Tv[14]:= tV[9] + Tv[12];
    Tv[15]:= Tv[6];
    Tv[16]:= MaxR(0, Tv[14] - Tv[15]);
    Tv[19]:= Tv[16];
    Tv[17]:= MinR(Tv[19], MinR(Tv[7], Tv[13]));
    Tv[21]:= Tv[6];
    Tv[20]:= Tv[21];
    Tv[18]:= Tv[17] + Tv[20];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<

Procedure T778(RetNo:integer;FName:string;FNo:integer);
var i,j,n1,n2,k:Integer;
F9921,AnyAgeInfirm,Under7NotInfirm,NotInfirm,F768,F770:integer;
ChCareOldKids,ChCareSmallKids,F9971,F9972:Real;
TheOnlySupporting:Boolean;SpRetNo:Integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    If Strings[91]>'' then
    begin
      For i:=1 to 90 do begin Strings[i]:='';Tv[i]:=0;end;
      SaveTv(RetNo,FName,FNo);
      Exit;
    end;

    If (ret[RetNo].MarStatus >2) and (not SeparatedThisYear(RetNo))
    and (Strings[77]+Strings[83] = '')  then
    begin
      Strings[3] := 'X'; {single etc}
      Strings[77]:='';
      Strings[83]:='';
    end;
   {bring Children from dependans list}
   If Strings[2] ='' then strings[2] :='Y';
   If UpperCase(Strings[2]) = 'Y' then
   begin
       i := 4;j:=5;
       If ret[RetNo].FormHasData['DEPEND'] then
       repeat
         If (FetchElm(RetNo,'DEPEND',j+6) ='Child')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Son')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Daughter') then
         begin
           Strings[i]   := FetchElm(RetNo,'DEPEND',j); {first nm}
           Strings[i+28]:= FetchElm(RetNo,'DEPEND',j); {first nm} {second tbl}
           Strings[i+1] := FetchElm(RetNo,'DEPEND',j+1); {lastNM}
           Strings[i+3] := FetchElm(RetNo,'DEPEND',j+5); {birthdate}
           If UpperCase(FetchElm(RetNo,'DEPEND',j+7)) = 'Y' then {infirmity}  //20121115
             Strings[i+2] := 'Y'
           else
             Strings[i+2] :='';
           inc(i,4);
         end;
       Inc(j,15);
       until (i>28) or (j>125);
     end;

     //20231215  //================
     Strings[96]:=FetchElm(RetNo,'DEPEND',110); //first nm
    // Strings[97]:=//last nmFetchElm(RetNo,'DEPEND',110); //first nm
     If FetchElm(RetNo,'DEPEND',117)='Y' then
      Strings[98]:='Y' //disability
     Else
      Strings[98]:=''; //disability
     Strings[99]:= FetchElm(RetNo,'DEPEND',115); //firthdate
     //================

    {calc claim}
	Tv[64] := 0;
        ChCareOldKids:=0; ChCareSmallkids:=0;
        Under7notInfirm :=0;NotInfirm:=0;
        AnyAgeInfirm:=0; F9921:=0;
        F768:=0; F770:=0;F9971:=0;F9972:=0;

        i := 33;   {first expense}
        k:=84;
	repeat
                If Vl(Strings[i+2])>0 then
                 Tv[k]:=GetCampLimit(CalcAge(Strings[i-26]),MyStrToInt(Strings[i+2]),
                    Strings[I-27])
                 else
                 Tv[k]:=0;

              	Tv[64] := Tv[64] + Tv[i];
                If Strings[i-1] > '' then {first nm}
                begin
                 If (CalcAge(Strings[i-26]) <7) then   // <7
                 begin
                   If (UpperCase(Strings[I-27]) = 'Y') then
                    Inc(AnyAgeInfirm)
                   else
                    Inc(Under7NotInfirm);
                 end
                 Else  // >6
                 begin
                   If UpperCase(Strings[I-27]) = 'Y' then
                    Inc(AnyAgeInfirm)
                   else
                   Begin
                      If CalcAge(Strings[i-26]) < 17 then Inc(NotInfirm);   // >6
                      F9971:=F9971+Tv[i];
                   end;
                 end;  //first nm

                 If (CalcAge(Strings[i-26]) <7) then F768 := F768+1;
                 If (UpperCase(Strings[I-27]) = 'Y') then
                 begin
                  Inc(F9921);
                  F9972 := F9972+Tv[i];
                 end;
                 If (CalcAge(Strings[i-26]) >=7) and
                    (CalcAge(Strings[i-26]) <=16) then
                    F770 := F770+1;
                 If (CalcAge(Strings[i-26]) >= 18) then
                   ChCareOldKids := ChCareOldKids + Tv[i];
                 If (CalcAge(Strings[i-26]) < 7) then
                    ChCareSmallKids := ChCareSmallKids + Tv[i];
                end;
	    	i := i + 4;
        Inc(k,1);
  	until i > 57;
   //==8th kid===================================
         If Strings[146] > '' then {first nm}
         begin
                 If (CalcAge(Strings[99]) <7) then   // <7
                 begin
                   If (UpperCase(Strings[98]) = 'Y') then
                    Inc(AnyAgeInfirm)
                   else
                    Inc(Under7NotInfirm);
                 end
                 Else  // >6
                 begin
                   If UpperCase(Strings[98]) = 'Y' then
                    Inc(AnyAgeInfirm)
                   else
                   Begin
                      If CalcAge(Strings[99]) < 17 then Inc(NotInfirm);   // >6
                      F9971:=F9971+Tv[147];
                   end;
         end;  //first nm

         If (CalcAge(Strings[99]) <7) then F768 := F768+1;
         If (UpperCase(Strings[98]) = 'Y') then
         begin
                  Inc(F9921);
                  F9972 := F9972+Tv[147];
                 end;
                 If (CalcAge(Strings[99]) >=7) and
                    (CalcAge(Strings[99]) <=16) then
                    F770 := F770+1;
                 If (CalcAge(Strings[99]) >= 18) then
                   ChCareOldKids := ChCareOldKids + Tv[147];
                 If (CalcAge(Strings[99]) < 7) then
                    ChCareSmallKids := ChCareSmallKids + Tv[147];
         end;
   //=============================

   Tv[64]:=Tv[64]+Tv[147]; //20231213

   Strings[65] := IntToStr(Under7NotInfirm);
   Strings[61] := IntToStr(AnyAgeInfirm);
   Strings[67] := IntToStr(NotInfirm);
   Strings[78] := IntToStr(F768);
   Strings[79] := IntToStr(F770);
   Tv[71] := ChCareSmallKids; //ChCareOldKids; //20141126
   Tv[62] := F9971;
   Strings[63]:= IntToStr(F9921);
   Tv[81] := F9972;

   //20150627  -------------
  Tv[66] := Vl(ret[RetNo].Frm[FNo].Strings[65]) * 8000;  //20161117  same
  Tv[60] := Vl(ret[RetNo].Frm[FNo].Strings[61]) * 11000;   //20161117  same

  Tv[68] := Vl(ret[RetNo].Frm[FNo].Strings[67]) * 5000;   //20161117  same
  //---------------------------
	Tv[69] := Tv[66] + Tv[60]+Tv[68];
 	Tv[70] := Tv[64];

  //if (UpperCase([82])<>'Y')  Or (UpperCase([82])<>'N' then Strings[82]:='';  //20220130 It ued to be
  //20220120
  if Strings[92]='' then Strings[92]:='N';
  if UpperCase(Strings[92]) <>'Y' then
   Tv[72] := Lnn[10100] + Lnn[10400]+ Lnn[13500]+Lnn[13700]+Lnn[13900]+Lnn[14100]+ Lnn[14300]
                 +Ret[RetNo].T4ACovidIncome;   //20210327 //82 out
	Tv[73] := Tv[72] * 2/3;
	Tv[74] := MinR(Tv[73],MinR(Tv[69],Tv[70]));

  Tv[76] := MaxR(0,(Tv[74] - Tv[75]));
	Lnn[21400] := Tv[76];
  Tv[1] := ChCareSmallKids;
  If Tv[64] =0 then
  begin
       For i:=60 to 76 do  Begin Strings[i]:=''; Tv[i] :=0; end;
       For i:=78 to 80 do  Begin Strings[i]:=''; Tv[i] :=0; end;
     end;
  end;

  //pg 2
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
     If FetchElm(RetNo,'T778',77) > '' then  //lower inc spouse
     begin
       For i:=101 to 140 do begin Frm[FNo].Strings[i]:='';Tv[i]:=0;end;
       SaveTv(RetNo,FName,FNo);
       Exit;
     end;

     If FetchElm(RetNo,'T778',3) > '' then TheOnlySupporting:=True
      else TheOnlySupporting :=False;

     If (FetchElm(RetNo,'T778',83)>'')
     and (UpperCase(Frm[FNo].Strings[109]) = 'Y')
     then  //higher inc
     begin
        Frm[FNo].Strings[101]:= GetSpouseFirstName(RetNo)+' '+GetSpouseLastName(RetNo);
        Frm[FNo].Strings[102]:= GetSpouseSin(RetNo);
        Tv[103]:=SpouseIncome(RetNo);
     end;

	Tv[110] := Vl(FetchElm(RetNo,'T778',69));
        Tv[112]:= Tv[110] * 2.5/100;
        If Vl(Frm[FNo].Strings[135]) >52 then Frm[FNo].Strings[135]:= '52'; //20220130
        If Vl(Frm[FNo].Strings[114]) >12 then Frm[FNo].Strings[114]:= '12';
        If Vl(Frm[FNo].Strings[135]) <0 then Frm[FNo].Strings[135]:= '';
        If Vl(Frm[FNo].Strings[114]) <0 then Frm[FNo].Strings[114]:= '';
        Tv[136] := Tv[112] * Vl(Frm[FNo].Strings[135]);
	Tv[137] := Tv[112] * Vl(Frm[FNo].Strings[114]);
        Tv[115] := Tv[136]+Tv[137];
	Tv[116] := MinR(Tv[115],Tv[74]);
        If TheOnlySupporting =False then
          ret[RetNo].Lnn[21400] := Tv[116]
        else
          begin Tv[115]:=0;Tv[116]:=0;end;

        If (FetchElm(RetNo,'T778',83) = '')  //no higher income
        then
        begin
         For i:=101 to 105 do Frm[FNo].Strings[i]:='';
         For i:=107 to 108 do Frm[FNo].Strings[i]:='';
         Tv[112]:=0; Tv[136]:=0;Tv[137]:=0;Tv[115]:=0;Tv[116]:=0;
        end;

        {Part D}
        If (TheOnlySupporting = True)
        and (Tv[74]=Tv[73])
        then
        begin
          Frm[FNo].Strings[106] :='X';
          Frm[FNo].Strings[132] :=''
        end;


        If Tv[74] <> Tv[73] then
         begin Frm[FNo].Strings[106] :='';Frm[FNo].Strings[132] :=''end;

        //Part D not for lower income
        If Frm[FNo].Strings[77] >'' then //lower income)
        begin
          Frm[FNo].Strings[132] :='';
          Frm[FNo].Strings[106] :='';
        end;

        If (Frm[FNo].Strings[106] >'') or
           (Frm[FNo].Strings[132] >'') then
        begin
         Frm[FNo].Strings[117] :=
           IntToStr(
             MyStrToInt(FetchElm(RetNo,'T778',65))+
             MyStrToInt(FetchElm(RetNo,'T778',61)));

         Tv[118] := Vl(FetchElm(RetNo,'T778',69));
         Tv[120] := Tv[118] * 2.5/100;
         Tv[139] := Tv[120] * Vl(Frm[FNo].Strings[138]);
         Tv[141] := Tv[120] * Vl(Frm[FNo].Strings[140]);
         Tv[123] := Tv[139]+Tv[141];
         If TheOnlySupporting =True then
           Tv[124] := MaxR(0,Vl(FetchElm(RetNo,'T778',69))
               -Vl(FetchElm(RetNo,'T778',76)))
         else
           Tv[124] := Tv[116];

         If TheOnlySupporting =True then
           Tv[127]:= MaxR(0,Vl(FetchElm(RetNo,'T778',70))
               -Vl(FetchElm(RetNo,'T778',76)))
         else
           Tv[127] := Tv[116];

         Tv[125] :=Tv[126] * 2/3;
         Tv[126] := MaxR(0,
                 ret[RetNo].Lnn[15000]
                 - ret[RetNo].Lnn[20700]
                 - ret[RetNo].Lnn[20800]
                 - ret[RetNo].Lnn[21200]
                 - ret[RetNo].Lnn[21500]
                 - ret[RetNo].Lnn[21700]
                 - ret[RetNo].Lnn[21900]
                 - ret[RetNo].Lnn[22000]
                 - ret[RetNo].Lnn[22100]
                 - ret[RetNo].Lnn[22400]
                 - ret[RetNo].Lnn[22900]);

         If Tv[133] >0 then tv[126] :=Tv[133];
         Tv[128] := MaxR(0,Tv[115] - Vl(FetchElm(RetNo,'T778',73)));
         Tv[129] :=MinR(MinR(Tv[123],Tv[124]),MinR(Tv[125],Tv[127]));
         If TheOnlySupporting =False then
          Tv[129] :=MinR(Tv[129],Tv[128]);
         If TheOnlySupporting =True then
           Tv[130]:= Vl(FetchElm(RetNo,'T778',76))
         else
           Tv[130]:= Tv[116];

         Tv[131] :=MinR(Vl(FetchElm(RetNo,'T778',64)),Tv[129]+Tv[130]);

         If Frm[FNo].Strings[106]+Frm[FNo].Strings[132]>'' then
           ret[RetNo].Lnn[21400] := Tv[131];
        end
        else
        For i:=117 to 131 do Tv[i] :=0;
  end;
  SaveTv(RetNo,FName,FNo);
end;



{TL2}
Procedure TL2(RetNo:integer;FName:string;FNo:integer);
var i,k:integer; TotUsForGst:Real;
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] :=GetLastName(RetNo);
    Strings[2] :=GetFirstName(RetNo);
    Strings[3] :=GetSinNo(RetNo);
    If Strings[4] ='' then Strings[4] := AppYear;
    If Strings[95]='' then Strings[95]:='Y';
    If Strings[136]='' then Strings[136]:='1.3497';//'1.3013'; //20230317
    If Strings[95]='Y' then Tv[137]:=23 * Vl(Strings[136]);  //20200208

    TotUsForGST:=0;
    i:=19;k:=122;
    Repeat
     //20100101
     If i>19 then
     begin
      If (IsDitto(Strings[i-3])) then Strings[i-3]:=Strings[i-3-10];
      If (IsDitto(Strings[i-2])) then Strings[i-2]:=Strings[i-2-10];
      If (IsDitto(Strings[i-1])) then Strings[i-1]:=Strings[i-1-10];
     end;

     If UpperCase(Strings[95])='Y' then
     begin
      If UpperCase(Strings[k]) = 'X' then
      begin
        Tv[i+1]:=Vl(Strings[i]) * Tv[137];
        TotUsForGst:=TotUsForGst+ (Tv[i+1]) * 50/100+Tv[i+3];
      end
      else
        Tv[i+1]:=Vl(Strings[i]) * 23; //17;  //20200208
     end;
     Inc(i,10);
     Inc(k);
    until i>89;

    i:=150;
    Repeat
 //20100101
     If i>150 then
     begin
      If (IsDitto(Strings[i-3])) then Strings[i-3]:=Strings[i-3-11];
      If (IsDitto(Strings[i-2])) then Strings[i-2]:=Strings[i-2-11];
     end;
     
     If UpperCase(Strings[95])='Y' then
     begin
      If UpperCase(Strings[i+1]) = 'X' then
      begin
        Tv[i+2]:=Vl(Strings[i]) * Tv[137];
        TotUsForGst:=TotUsForGst+ (Tv[i+2]) * 80/100+Tv[i+4];  //20110326
       // TotUsForGst:=TotUsForGst+ (Tv[i+2]) * 70/100+Tv[i+4];
      end
      else
        Tv[i+2]:=Vl(Strings[i]) * 23; //17; //20200208
     end;
     Inc(i,11);
    until i>227; //221;   //20120213

    Tv[97]:=0; I := 20;
    repeat
      Tv[97] := Tv[97] +Tv[i];
      i := i+10;
    until i>90;
    Tv[99] := Tv[97] - Tv[98];
    Tv[100]:=Tv[99] * 50/100;
    Tv[9] := Tv[97];

    Tv[138]:=0; I := 152;
    repeat
      Tv[138] := Tv[138] +Tv[i];
      i := i+11;
    until i>229;
    Tv[140] := Tv[138] - Tv[139];
    Tv[141]:=Tv[140] * 80/100;
    Tv[232]:=Tv[138];

    {lodging}
    Tv[101]:=0; I := 22;
    repeat
      Tv[101] := Tv[101] +Tv[i];
      i := i+10;
    until i>92;
    Tv[93] := Tv[101];

    Tv[142]:=0; I := 154;
    repeat
      Tv[142] := Tv[142] +Tv[i];
      i := i+11;
    until i>231;
    Tv[233] := Tv[142];

    Tv[143] := Tv[101] + Tv[142];

    Tv[103] := Tv[143] - Tv[102];
    Tv[104] := Tv[103];
    Tv[105] := Tv[100] + Tv[141] + Tv[104];

    If Strings[130]='' then Strings[130]:='N';
    If UpperCase(Strings[130])='Y' then
    begin
      Tv[134]:=Tv[105];
      Tv[135]:=TotUsForGst;
      Tv[131]:=MaxR(0,Tv[134]-Tv[135]);
    end
    else
    begin
     Tv[134]:=0;
     Tv[135]:=0;
     Tv[131]:=0;
    end;
    Strings[8] := AppYear;  //certification
    If Strings[7]='' then Strings[7] := DateToMonthDayYear(Date);
  end;
  SaveTv(RetNo,FName,FNo);
End;


{T1023}
Procedure T1023(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
    {Load the numeric fields of a form into the Temporary Variables array}
    LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    {Calc this form}
    Tv[3] := ret[RetNo].Lnn[10100] + ret[RetNo].Lnn[10400];
    Tv[4] := ret[RetNo].Lnn[21200];
    Tv[5] := ret[RetNo].Lnn[22900];
    Tv[6] := Tv[4] + Tv[5];
    Tv[7] := Tv[6];
    Tv[8] := Tv[3] - Tv[7];
    Tv[9] := Tv[8];
    {? Tv[10]}
    {?t1023 Tv[11]}
    Tv[12] := ret[RetNo].Lnn[10400];
    Tv[13] := ret[RetNo].Lnn[12600];
    Tv[14] := ret[RetNo].Lnn[12800];
    Tv[15] := ret[RetNo].Lnn[10400];
    Tv[16] := ret[RetNo].Lnn[10400];
    {?t1023 Tv[17]}
    Tv[18] := 0;
    for i:= 9 to 17 do
        Tv[18] := Tv[18] + Tv[i];
    Tv[19] := Tv[18];
    {?t1023 Tv[20]}
    Tv[21] := ret[RetNo].Lnn[12600];
    Tv[22] := ret[RetNo].Lnn[22000];
    Tv[23] := Tv[20] + Tv[21] + Tv[22];
    Tv[24] := Tv[23];
    Tv[25] := MinR(0,(Tv[19] - Tv[24]));
  end;
  {save data}
  SaveTv(RetNo,FName,FNo);
End;

//20251008 Igor >>>
procedure T2204(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  Cpt30Date: string;
  MaxUI, CPPProrate, x: Real;
  TE, TP: Real;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    MaxUi:= Constant[RY].MaxUIEarn52;
    Tv[7]:= T4UIEarnings;
    Tv[8]:= Vl(FetchElm(RetNo, 'S13', 1));
    Tv[13]:= MinR(MaxUi, Tv[7] + Tv[8]);
    Tv[15]:= Ret[RetNo].T4UIPremium;
    Tv[18]:= Vl(FetchElm(RetNo, 'S13', 16)); //non qc //20211128

    if (Tv[18] = 0) then Tv[18]:= Vl(FetchElm(RetNo, 'S13', 10)); //QC

    Tv[27]:= Tv[15] + Tv[18];
    Tv[28]:= Tv[27];
    Tv[17]:= Tv[13]; //20220126
    Tv[14]:= MaxR(0, Tv[17] - 2000); //20220126 //Tv[14]:=MaxR(0,Tv[13]-2000);
    Tv[29]:= MaxR(0, Tv[28] - Tv[14]);
    Tv[30]:= Tv[15];

    if not Ret[RetNo].Province.Equals('QC') then
    begin
      Tv[1]:= Tv[7];
      Tv[2]:= Constant[RY].UIRate *100;
      Tv[3]:= MinR(Constant[RY].MaxUI52, Tv[1] * Tv[2] / 100);
      Tv[9]:= Tv[3];
      Tv[4]:= 0;
      Tv[5]:= 0;
      Tv[6]:= 0;
    end else //QC
    begin
      Tv[4]:= Tv[7];
      Tv[5]:= Constant[RY].QCUIRate * 100;
      Tv[6]:= MinR(Constant[RY].QCMaxUI52, Tv[4] * Tv[5] / 100);
      Tv[9]:= Tv[6];
      Tv[1]:= 0;
      Tv[2]:= 0;
      Tv[3]:= 0;
    end;
    //Tv[9]:= MinR(Constant[RY].MaxUI52, Tv[13] * Constant[RY].UIRate);
    //If ret[RetNo].Province = 'QC' then Tv[9]:= MinR(Constant[RY].QCMaxUI52, Tv[13] * Constant[RY].QCUIRate); //20171127

    if (Tv[13] < 2000) then Tv[9]:= 0;

    Tv[16]:= MaxR(0, Tv[30] - Tv[9]);
    Tv[12]:= MaxR(Tv[29], Tv[16]); //20220126
    Tv[10]:= MinR(Tv[30], Tv[12]);//20220127 //MaxR(Tv[29],Tv[16]);

    if IsPreBankruptcyReturn(RetNo) then Tv[10]:= 0;

    Lnn[45000]:= 0;
    if (Tv[10] > 1) then Lnn[45000]:= Tv[10];
    if (Tv[10] > Tv[30]) then Lnn[45000]:= Tv[30];

    //20121217
    Lnn[31200]:= MinR(Tv[14], MinR(Tv[30], Tv[9])) + Vl(FetchElm(RetNo, 'T1SALDIV', 8));  //20200829

    if (Tv[7] < 2000) then Lnn[31200]:= MaxR(0, Tv[30] - Tv[10]); //20120108

    Tv[11]:=Lnn[31200]; // MinR(Tv[14],MinR(Tv[30],Tv[9]))+Vl(FetchElm(RetNo,'T1SALDIV',8));  //20200829
    // If Tv[7]<2000 then Lnn[31200]:=MaxR(0,Tv[30]-Tv[10]); //20120108
  end;

  SaveTv(RetNo, FName, FNo);
End;
//20251008 Igor <<<

{T2036}
Procedure T2036(RetNo:integer;FName:string;FNo:integer);
Var k,T2209FNo:Integer;//ThisFrm:string[10];
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    {Calc this form}
    ret[RetNo].Frm[Fno].Strings[1] :=FetchElm(RetNo,'FORINC',1);
    ret[RetNo].Frm[Fno].Strings[12] :=FetchElm(RetNo,'FORINC',2);
    ret[RetNo].Frm[Fno].Strings[23] :=FetchElm(RetNo,'FORINC',3);
    K:=0;   //overrides increase by 11 also 36,47 and 58
    Repeat
     If k=0 then T2209FNo:=GetFormNo('T2209#1')
     else if k=11 then T2209FNo:=GetFormNo('T2209#2')
     else if k=22 then T2209FNo:=GetFormNo('T2209#3');

    If T2209FNo>0 then  //20101220
    begin
     If ret[RetNo].Frm[T2209FNo].Count=0 then InitFormData(RetNo,T2209FNo);
     Tv[2+k] := Vl(FetchElmFNo(RetNo,T2209FNo,1));
     if UpperCase(ret[RetNo].Frm[FNo].Strings[36+k])<>'Y' then
      Tv[3+k] := Vl(FetchElmFNo(RetNo,T2209FNo,6));

     //20180506
     if (k=0)  //how about 2 an 3countries?
     and (SubjectToMinTax(RetNo))
     and (Tv[3+k]=0) //20180506
     and (UpperCase(ret[RetNo].Frm[FNo].Strings[36+k])<>'Y') then
       Tv[3+k]:=Vl(FetchElm(RetNo,'T691',236));

     if (Ret[RetNo].Province='BC') then
      Vl(FetchElmFNo(RetNo,T2209FNo,6));     //Tv[3+k]:=0;  //20190531
    end;

    Tv[6+k] := MaxR(0,(Tv[2+k] - Tv[3+k]));

    If T2209FNo>0 then Tv[7+k] := Vl(FetchElmFNo(RetNo,T2209FNo,2)); //only non bus foreign inc //20101220
    Tv[8+k] :=  Vl(FetchElm(RetNo,'T2209#1',5));

    if IsMultJurisdiction(RetNo) then  //20220425
    Begin
      If Ret[RetNo].Province='ON' then Tv[8+k]:=Vl(FetchElm(RetNo,'T2203',42))
      //???? more prov;
    End;

    If Uppercase(ret[RetNo].Frm[FNo].Strings[35]) <> 'Y' then
     Tv[9+k] := PrvTaxBfrT2036(RetNo);
    If Tv[8+k] = 0 then
        Tv[10+k] :=0
    Else
        Tv[10+k] := (Tv[7+k] / Tv[8+k]) * Tv[9+k];
    If Tv[10+k] > Tv[9+k] then Tv[10+k] := Tv[9+k];
    Tv[11+k] := MinR(Tv[6+k],Tv[10+k]);
    {t2036 other countries}
    Inc(K,11);
    until k >23;
    Tv[34] := Tv[11]+Tv[22]+Tv[33];

    ret[RetNo].Frm[FNo].Strings[101]:=AppYear;
  end;
  {save data}
  SaveTv(RetNo,FName,FNo);
End;


{T2097}
Procedure T2097(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
  {Load the numeric fields of a form into the Temporary Variables array}
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    {Calc this form}
    Tv[10] := 0;
    for i:= 1 to 9 do
        Tv[10] := Tv[10] + Tv[9];
  end;
  {save data}
  SaveTv(RetNo,FName,FNo);
End;


Procedure T1A(RetNo:integer;FName:string;FNo:integer);
var i: integer; x:real;IR:real;S:string[20];
Begin
    {Load the numeric fields of a form into the Temporary Variables array}
   LoadTv(RetNo,FName,FNo);
   With ret[RetNo], ret[RetNo].Frm[FNo] do
   begin
    //Frm[FNo].Strings[1] := GetLastName(RetNo)+', '+GetFirstName(RetNo);
    Frm[FNo].Strings[1] := GetLastName()+', '+GetFirstName(); //20160119 Igor
    Frm[FNo].Strings[2] := GetSinNo(RetNo);
    Frm[FNo].Strings[5] := GetFullAddress(RetNo);
    Frm[FNo].Strings[3] := GetPrvYear(AppYear,3);
    Frm[FNo].Strings[4] := GetPrvYear(AppYear,2);
    Frm[FNo].Strings[50] := GetPrvYear(AppYear,1);
    For i:=6 to 10 do Tv[i] :=0; For i:=12 to 23 do Tv[i] :=0;  //11 excluded
    x := Lnn[10100] + Lnn[10400]- Lnn[20700] - Lnn[21200]- Lnn[22900];
    If x>0 then Tv[6] :=x else Tv[7]:=ABS(x);

    x:= Lnn[12000] + Lnn[12100] - Lnn[22100];
    If x>0 then Tv[8] :=x else Tv[9]:=ABS(x);
    If Lnn[12200]>0 then Tv[10] := Lnn[12200] else
    begin
     If UpperCase(Frm[FNo].Strings[42]) <> 'Y' then Tv[11] := Abs(Lnn[12200]);
    end;
    If Lnn[12600]>0 then Tv[12] :=Lnn[12600] else Tv[13]:=ABS(Lnn[12600]);
    If Lnn[13500]>0 then Tv[14] :=Lnn[13500] else Tv[15]:=ABS(Lnn[13500]);
    If Lnn[13700]>0 then Tv[16] :=Lnn[13700] else Tv[17]:=ABS(Lnn[13700]);
    If Lnn[13900]>0 then Tv[18] :=Lnn[13900] else Tv[19]:=ABS(Lnn[13900]);
    If Lnn[14100]>0 then Tv[20] :=Lnn[14100] else Tv[21]:=ABS(Lnn[14100]);
    If Lnn[14300]>0 then Tv[22] :=Lnn[14300] else Tv[23]:=ABS(Lnn[14300]);
    Tv[24] := Lnn[12700];
    Tv[25] := Lnn[14700];

    Tv[26] := Lnn[25400];
    Tv[27] := Lnn[25300];
    Tv[28] := Lnn[21700];
    Tv[41] := Lnn[24400];
  //  Tv[29] := Lnn[248];     //20181109
    Tv[30] := Lnn[24900];
    Tv[30]:=Tv[30]+Lnn[24901];  //20241212
    Tv[31] := Lnn[25000];
    {?Tv[32] := exempt by treaty}
    Tv[33] := Lnn[11300] + Lnn[11400]+Lnn[11500]+Lnn[11700]+Lnn[11900]+Lnn[12500]+Lnn[12800]+Lnn[12900]+Lnn[13000]+Lnn[11600]; //20100501  //ln 116

    Tv[34] := 0;
    Tv[35] := 0;
    i := 6;
    repeat
      Tv[34] := Tv[34] + Tv[i];
      Tv[35] := Tv[35] + Tv[i+1];
      Inc(i,2);
    until i = 24;

    Tv[34] := Tv[34] + Tv[24] + Tv[25] + Tv[33];

    for i := 26 to 32 do Tv[35] := Tv[35] + Tv[i];


    Tv[35]:=Tv[35]+Tv[41];

    {//20250330
    //20241212
    Tv[60]:=Ret[RetNo].Lnn[12701];
    Tv[61]:=Ret[RetNo].Lnn[25395];
    Tv[35]:=Tv[35]+Tv[60]+Tv[61];  //20241212
    }
    //2nd page
    Tv[58]:=Tv[35];
    Tv[59]:=Tv[34];
    //20240131
    Tv[36] := Lnn[20800]
             +Lnn[20805]  //20241212
             +Lnn[21000]+Lnn[21300]+Lnn[21400]+Lnn[21500]+Lnn[21900]
             +Lnn[22000]+Lnn[22200]+Lnn[22215]+Lnn[22300]
             +Lnn[23200]+Lnn[23500]
             +Tv[51]; //adjustments    //  +LNN[23210] out on //20231124
    Tv[37] := MaxR(0,(Tv[59] - Tv[36]));
    Tv[38] := Tv[37];
    Tv[39] := MaxR(0,(Tv[58] - Tv[38]));

    //20180210
    x:= Lnn[14100]+Lnn[14300];
    If x<0 then
     begin Tv[102] := ABS(x);Tv[103] :=0; end
    else
     begin Tv[102] :=0;Tv[103] :=x;end;

    Tv[52]:=MaxR(0,Tv[102]-Tv[103]);  //20180210
    Tv[53] := MinR(Tv[39],Tv[52]);
    Tv[43] := MaxR(0,(Tv[39] - Tv[53]));
    //-------------------------
    if IsForRefile(RetNo) then  //keep original non cp carry back
    Begin
     Tv[44]:=Vl(FetchElm(RetNo,'REFILEQ',107));
     Tv[45]:=Vl(FetchElm(RetNo,'REFILEQ',108));
     Tv[46]:=Vl(FetchElm(RetNo,'REFILEQ',109));
    end;

    Tv[47] := Tv[44] + Tv[45] + Tv[46];
    Tv[48] := Tv[47];
    Tv[49] := MaxR(0,(Tv[43] - Tv[48]));
    //-------------------------------------
    //frming fishing
    IR:=1/2;
    Tv[104]:=Tv[53];  //20180210

    Tv[116] := Tv[111] + Tv[113] + Tv[115];
    Tv[117] := Tv[116];
    Tv[118] := MaxR(0,(Tv[104] - Tv[117]));
    //------------------------
    {Restr farm}
    Tv[139] := TotMultiple(RetNo,'T2042',150)
             +TotMultiple(RetNo,'T1163',676)
             +TotMultiple(RetNo,'T1273',656);
    Tv[146] := Tv[141] + Tv[143] + Tv[145];
    Tv[147] := Tv[146];
    Tv[148] := MaxR(0,(Tv[139] - Tv[147]));
    //----------------------

    //part 5 Page 3

    x:= Vl(FetchElm(RetNo,'S3',339)); //20241212 // x:= Vl(FetchElm(RetNo,'S3',97));
    If x<0 then Tv[63] := ABS(x) else Tv[63] :=0;

    {net cap loss}
    Frm[FNo].Strings[120] := GetPrvYear(AppYear,3);
    Frm[FNo].Strings[122] := GetPrvYear(AppYear,2);
    Frm[FNo].Strings[124] := GetPrvYear(AppYear,1);
    Tv[127] :=Tv[121]+Tv[123]+Tv[125];
    Tv[105]:=Tv[127];
    Tv[128]:=MaxR(0,Tv[63]-Tv[105]); //MaxR(0,Tv[119]-Tv[105]);
    //-------------------------------
    { Listed prop}
    Frm[FNo].Strings[130] := GetPrvYear(AppYear,3);
    Frm[FNo].Strings[132] := GetPrvYear(AppYear,2);
    Frm[FNo].Strings[134] := GetPrvYear(AppYear,1);

    Tv[136] := Tv[131] + Tv[133] + Tv[135];
    Tv[137] := Tv[136];
    Tv[138] := MaxR(0,(Tv[129] - Tv[137]));
  end;

  With ret[RetNo].Frm[FNo] do
  begin
     Strings[152] := GetAreaCode(RetNo);
     Strings[153] := GetPhoneNo(RetNo);
     If strings[154] ='' then
     begin
     Strings[154]:= FormatDateTime('yyyy-mm-dd',Date);
     end;
  end; {with}
  SaveTv(RetNo,FName,FNo);
End;

Procedure DEATH(RetNo:integer;FName:string;FNo:integer);
Var i,SomeFNo:Integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin

   If IsDeceased(RetNo)=False then
   begin
    For i:=1 to 44 do begin Tv[i]:=0;Strings[i]:='';end;
    SaveTv(RetNo,FName,FNo);
    Exit;
   end;

   Tv[42]:=MaxR(0,Vl(FetchElm(RetNo,'S3',339)));//20250405
     //MaxR(0,Vl(FetchElm(RetNo,'S3',97)));
   SomeFNo:=GetFormNo('T1A');
   Tv[1]:=Vl(FetchElmFNo(RetNo,SomeFNo,63)); //20250320 //Vl(FetchElmFNo(RetNo,SomeFNo,119));
   Strings[2]:=FetchElmFNo(RetNo,SomeFNo,120);
   Tv[3]:=Vl(FetchElmFNo(RetNo,SomeFNo,121));
   Strings[4]:=FetchElmFNo(RetNo,SomeFNo,122);
   Tv[5]:=Vl(FetchElmFNo(RetNo,SomeFNo,123));
   Strings[6]:=FetchElmFNo(RetNo,SomeFNo,124);
   Tv[7]:=Vl(FetchElmFNo(RetNo,SomeFNo,125));
   Tv[8]:=Vl(FetchElmFNo(RetNo,SomeFNo,127));
   Tv[9]:=Tv[8];
   Tv[10]:=Vl(FetchElmFNo(RetNo,SomeFNo,128)); //20150316 //Vl(FetchElmFNo(RetNo,SomeFNo,28));

   Tv[20]:=Vl(FetchElm(RetNo,'CFR',407)); //Tv[40];

   Tv[22]:=Tv[10]+Tv[20];
   Tv[43]:=MinR(Tv[42],Tv[22]);   //20150316
   //20150316  Tv[43]:=0; //Tv[43]:=Vl(FetchElm(RetNo,'CFR',408));   //taxbl gain //20110814
   Tv[44]:=MaxR(0,Tv[22]-Tv[43]);

   SomeFNo:=GetFormNo('CFR');
   Tv[23]:=0;
   For i:=16 to 20 do Tv[23]:=Tv[23]+Vl(FetchElmFNo(RetNo,SomeFNo,i));
   Tv[23]:=Tv[23]+Vl(FetchElmFNo(RetNo,SomeFNo,36))
                 +Vl(FetchElmFNo(RetNo,SomeFNo,44))
                 +Vl(FetchElmFNo(RetNo,SomeFNo,49))
                 +Vl(FetchElmFNo(RetNo,SomeFNo,56))
                 +Vl(FetchElmFNo(RetNo,SomeFNo,62))
                 +Vl(FetchElmFNo(RetNo,SomeFNo,69))
                 +Vl(FetchElmFNo(RetNo,SomeFNo,60)) //20110814
                 +Vl(FetchElmFNo(RetNo,SomeFNo,80)) //20110814
                 +Vl(FetchElmFNo(RetNo,SomeFNo,86)) //20110814
                 +Vl(FetchElmFNo(RetNo,SomeFNo,91)) //20110814
                 +Vl(FetchElmFNo(RetNo,SomeFNo,96)) //20150315
                 +Vl(FetchElmFNo(RetNo,SomeFNo,266)) //20150315
                 +Vl(FetchElmFNo(RetNo,SomeFNo,271)) //20150315
                 +Vl(FetchElmFNo(RetNo,SomeFNo,276)) //20150315
                 +Ret[RetNo].Lnn[25400];

   If Tv[23]<0 then Tv[23]:=0;
   Tv[24]:=MaxR(0,Tv[44]-Tv[23]);

   Strings[25]:=AppYear;
   Strings[27]:=AppYear;
   Strings[12]:=AppYear;
   Strings[29]:=Strings[6];
   //to prior year
   If Tv[30]<0 then Tv[30]:=0;
   If Tv[30]>Tv[24] then Tv[30]:=Tv[24];

   //20110310
   If Strings[13] = '' then Strings[13]:='N';
   If Strings[13] <> 'Y' then
   begin
    Tv[28]:=Tv[24];
    Tv[11]:=Tv[42]-Tv[43];  //20150316
   end;
  end;
  SaveTv(RetNo,FName,FNo);
End;

Procedure TX19(RetNo:integer;FName:string;FNo:integer);
Var i,SomeFNo:Integer;IR,X:Real;
Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
   If (FetchElm(RetNo,'INFO',24)>'') and (UpperCase(Strings[24])='X') then  //20160221 //20160223 Igor
   begin
     Strings[1]:= GetLastName(RetNo)+', '+GetFirstName(RetNo);
     Strings[2]:=FetchElm(RetNo,'INFO',6)+' '+
                 FetchElm(RetNo,'INFO',22)+', '+
                 FetchElm(RetNo,'INFO',68)+' '+
                 FetchElm(RetNo,'INFO',10)+', '+
                 FetchElm(RetNo,'INFO',14)+', '+
                 FetchElm(RetNo,'INFO',15);
     Strings[3]:=GetSinNo(RetNo);
     Strings[4]:=FetchElm(RetNo,'INFO',24);
     Strings[11]:='X';      //20160221 //20160223 Igor
     If Strings[18]='' then Strings[18]:= FormatDateTime('yyyy-mm-dd',Date);
   end;
  end;
  SaveTv(RetNo,FName,FNo);
End;

Procedure T1037(RetNo:integer;FName:string;FNo:integer);
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
   begin
    //Frm[Fno].Strings[1] := GetLastName(RetNo);
    //Frm[Fno].Strings[2] := GetFirstName(RetNo);
    Frm[Fno].Strings[1] := GetLastName(); //20160119 Igor
    Frm[Fno].Strings[2] := GetFirstName(); //20160119 Igor
    Frm[Fno].Strings[3] := GetSinNo(RetNo);
    Frm[Fno].Strings[4] := FetchElm(RetNo,'INFO',6)+' '+FetchElm(RetNo,'INFO',22);
    Frm[Fno].Strings[5] := FetchElm(RetNo,'INFO',10);
    Frm[Fno].Strings[6] := FetchElm(RetNo,'INFO',14)+', '+
                          FetchElm(RetNo,'INFO',15);
    Frm[Fno].Strings[9] := GetAreaCode(RetNo);
    Frm[Fno].Strings[10] := GetPhoneNo(RetNo);

    {Tv[13] := Tv[11] +Tv[12];}
    {Tv[14] := Tv[13];}
    Tv[18] := Tv[12]+Tv[13]+Tv[15]+Tv[16]+Tv[17];
    Tv[19] := Tv[18];

    Tv[20] := MaxR(0,Tv[11] - TV[19]);
    Tv[21] := TV[20];
    TV[23] :=MinR(TV[21],TV[22]);
    If TV[24] > TV[23] then Tv[24] := TV[23];
    Tv[26] := Tv[24];
    Tv[27] := MaxR(0,Tv[25] - Tv[26]);
   end;
  {save data}
  SaveTv(RetNo,FName,FNo);
End;



//20260122 Igor >>>  Alex
procedure T2017(RetNo: Integer; FName: string; FNo: Integer);
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[27]:= Tv[1] + Tv[2] + Tv[7]+Tv[3];  //20260322
    Tv[29]:= Tv[27];
    Tv[30]:= Tv[25] - Tv[29];
    Tv[19]:= Tv[35] + Tv[36] + Tv[8] + Tv[4]; //20260322
    Tv[37]:= Tv[19];
    Tv[38]:= Tv[31] - Tv[37];
    Tv[39]:= Tv[38];
    Tv[40]:= Tv[30] + Tv[39];

    //Page 2
    Tv[34]:= Tv[40];
    Tv[12]:= Tv[10] - Tv[11];
    Tv[13]:= Tv[12];
    Tv[33]:= Tv[34] + Tv[13];
    Tv[28]:= Tv[23] - Tv[73];
    Tv[32]:= Tv[28];
    Tv[5]:= Tv[3] - Tv[4];
    // Tv[6]:= Tv[5]; //user
    Tv[7]:=Tv[5]-Tv[6];
    Tv[8]:=Tv[7];  //20260322
    Tv[16]:=Tv[14]-Tv[15];
    Tv[17]:=Tv[16];
    Tv[18]:= Tv[33] +Tv[32] +Tv[8] +Tv[17];
    Tv[125]:= Tv[18] + Tv[121];
  end;

  SaveTv(RetNo, FName, FNo);
End;
//20260122 Igor <<<  Alex

{
//20251008 Igor >>>
procedure T2017(RetNo: Integer; FName: string; FNo: Integer);
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[27]:= Tv[1] + Tv[2];
    Tv[29]:= Tv[27];
    Tv[30]:= Tv[25] - Tv[29];
    Tv[19]:= Tv[35] + Tv[36];
    Tv[37]:= Tv[19];
    Tv[38]:= Tv[31] - Tv[37];
    Tv[39]:= Tv[38];
    Tv[40]:= Tv[30] + Tv[39];
    Tv[12]:= Tv[10] - Tv[11];
    Tv[13]:= Tv[12];
    Tv[33]:= Tv[40] + Tv[13];

    //Page 2
    Tv[34]:= Tv[33];
    Tv[28]:= Tv[23] + Tv[73];
    Tv[32]:= Tv[28];
    Tv[16]:= Tv[14] - Tv[15];
    Tv[17]:= Tv[16];
    Tv[18]:= Tv[34] + Tv[32] + Tv[17];
    Tv[125]:= Tv[18] + Tv[121];
  end;

  SaveTv(RetNo, FName, FNo);
End;
//20251008 Igor <<<
}
(*
Procedure T2017(RetNo:integer;FName:string;FNo:integer);
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
   begin
    //20161128
     Tv[3]:=Tv[28]-Tv[9];
     Tv[5]:=Tv[3];  //20210306  new fillds

     Tv[8]:=Tv[25]-Tv[4];
     Tv[6]:=Tv[8];

     Tv[21]:=Tv[3]+Tv[8];    //20210310
     //Tv[21]:=Tv[29];  //20210310 29 out

     Tv[7]:=Tv[31]-Tv[19];
     //Tv[32]:=Tv[5]+Tv[7];
     Tv[22]:=Tv[7];
     Tv[20]:=Tv[21]+Tv[22];   //20210307

     TV[12] := TV[10] - TV[11];
     Tv[26]:=Tv[20];

     TV[13] := TV[12];

     TV[16] := TV[14] - TV[15];
     TV[17] := TV[16];
     TV[18] := Tv[26]+Tv[13]+Tv[17]; //20210306 //Tv[21]+Tv[22]+Tv[13]+Tv[17];
   end;
   //pg 2
   with ret[RetNo].Frm[FNo] do
   begin
    Tv[133]:=Tv[18];
    TV[125] := TV[133] + TV[121];
   end;
  SaveTv(RetNo,FName,FNo);
End;
*)


Procedure T2038(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  // Frm[FNo].Strings[1] := AppYear;
  // Tv[4] := Tv[3] * 0.30; //20140913
   Tv[8] := Tv[7] * 0.15; //0.20;  //20140913

   Tv[33] :=Tv[32] * 0.15; //0.20;          //20140913
   Tv[12] := Tv[11] * 0.10;

   //Tv[15] := Tv[14] * 0.05; ////0.15;  //jz//20250306 [15] doest belong here removed
   Tv[16] := Tv[8]+Tv[33]+Tv[1]+Tv[12];  //jz//20250306 [15] removed   +Tv[15]; //Tv[4]+Tv[8]+Tv[33]+Tv[12]+Tv[15];

   Tv[34]:=Vl(FetchElm(RetNo,'T1229',71));
   Tv[18]:=Tv[34]+Tv[35];     //???
   Tv[46] := Tv[18] * 0.15;
   Tv[10]:=Vl(FetchElm(RetNo,'T1229',24)); //20240409
   Tv[13]:=Tv[10]*0.30; //20230117

   i:=54;
   Repeat
    If Tv[i]>20000 then Tv[i]:=20000;
    Inc(i,3);
   until i>63;

   Tv[44] :=Tv[54]+Tv[57]+Tv[60]+Tv[63]; //vl(FetchElm(RetNo,'AJCTC',101));
   Tv[43] :=  Tv[44] * 0.10;
   //20241214

   //jz//20250306
   //Tv[2]
   Tv[14]:=Tv[2]*0.20;
   //Tv[15]
   Tv[19]:=Tv[15]*0.15;
   Tv[21]:=Tv[14]+Tv[19];
   Tv[22]:= Tv[21];

   Tv[42]:=Tv[46]+Tv[13]+Tv[43]+Tv[22];   //20241214

   //jz//20260228 this section does not seem to exist, gives wrong value in [19] which is calced above
   {
   //child care spaces
   Tv[66] := Vl(Frm[FNo].Strings[65]) * 40000;
   Tv[49] := MinR(Tv[64],Tv[66]);
   Tv[48] := Tv[49] * 0.25;
   Tv[19] := Tv[46]+Tv[43]+Tv[48];

   Tv[72]:=MinR(Tv[70],Tv[71]);
   Tv[73]:=Tv[69]+Tv[72];
   }


   //Page 3 --------------------------------------------------------------------

   //recapture of ICT
   Tv[28] := Tv[20] * 0.15; //0.30; //20140913
   Tv[41] := Tv[39] * 0.20;
   Tv[74]:=Tv[28]+Tv[41];

   //20251124 Tv[51] := Tv[74]+Tv[73]; //Tv[28]+Tv[41]; //20140209

   //2p240225
  //  modified in 2023========= ==============
   Tv[3]:=Tv[16];
   Tv[17]:=Tv[42];
   Tv[45]:=Tv[3]+Tv[17];
   Tv[50]:=Tv[45];
   Tv[67]:=Tv[137]+Tv[50];
   //Tv[66]:=?? T3?
   Tv[77]:=Tv[67]-Tv[66];


   Tv[78]:=Ret[RetNo].LNN[40600];
   Tv[79]:=Ret[RetNo].LNN[41000];
   Tv[80]:=MaxR(0,Tv[78]-Tv[79]);
   Tv[81]:=Ret[RetNo].LNN[41400];
   Tv[82]:=MaxR(0,Tv[80]-Tv[81]);
   Tv[83]:=Tv[82];
   Tv[84]:=MinR(Tv[77],Tv[83]);


   if (SubjectToMinTax(RetNo))
   and (Vl(FetchElm(RetNo,'T691',249))>0) //20250404
   then
   begin
    Tv[85]:=Tv[83];
    Tv[86]:=Ret[RetNo].LNN[40500];
    Tv[87]:=Tv[85]+Tv[86];

    //jz//20250404 - form descr wrong , should be from line 108 elm 131 not elm 129
    Tv[88]:=Vl(FetchElm(RetNo,'T691',131)); //Vl(FetchElm(RetNo,'T691',129));

    Tv[89]:=MaxR(0,Tv[87]-Tv[88]); //20240226 //MaxR(0,Tv[87]-Tv[86]);
    Tv[90]:=Tv[89];
    Tv[91]:=MinR(Tv[77],Tv[90]);
    Tv[92]:=Tv[91];
   end
   else
   begin
    for i:=85 to 91 do Tv[i]:=0;  //20240226
    Tv[92]:=Tv[84];
   end;

    Ret[RetNo].LNN[41200]:=Tv[92];


   //===============
   Tv[4]:=Tv[77];
   Tv[5]:=Tv[137];
   Tv[9]:=MaxR(0,Tv[4]-Tv[5]);
   Tv[93]:=Tv[9];
   Tv[94]:=MaxR(Tv[84],Tv[91]);
   Tv[95]:=Tv[137];
   Tv[96]:=MaxR(0,Tv[94]-Tv[95]);
   Tv[97]:=Tv[96];   //20240226
   Tv[98]:=Tv[93]-Tv[97];      //20240226
   //Carry back request
   Frm[FNo].Strings[105] := IntToStr(StrToInt(AppYear)-3);
   Frm[FNo].Strings[107] := IntToStr(StrToInt(AppYear)-2);
   Frm[FNo].Strings[109] := IntToStr(StrToInt(AppYear)-1);
   Tv[111]:=Tv[106]+Tv[108]+Tv[110];

   // Part E2
   Tv[6]:=Tv[16];
   Tv[99]:=Tv[66];
   Tv[100]:=Tv[6]-Tv[99];

   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
    //20240226
   Tv[120]:=Tv[92];
   Tv[126]:=Tv[137];
   Tv[127]:=Tv[120]-Tv[126];
   Tv[128]:=Tv[111];
   Tv[129]:=Tv[127]+Tv[128];
   Tv[130]:=Tv[42];
   Tv[131]:=MaxR(0,Tv[129]-Tv[130]);
   Tv[132]:=Tv[131]; //20240121
   Tv[133]:=MaxR(0,Tv[101]-Tv[132]);

   Tv[134]:=Tv[133];
   if Tv[134]>Tv[133] then Tv[134]:=Tv[133];
   Tv[135]:=Tv[134]*0.40;

   Tv[136]:=Tv[77];

   Tv[139]:=Tv[92];
   Tv[141]:=Tv[111];
   Tv[144]:=Tv[135];
   Tv[147]:=Tv[139]+Tv[141]+Tv[144];
   Tv[148]:=Tv[147];
   Tv[146]:=MaxR(0,Tv[136]-Tv[148]);

   Lnn[45400] := Tv[135]; //20240410
  End;
  SaveTv(RetNo,FName,FNo);
End;


Procedure T2038I(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo] do
  begin
   Frm[FNo].Strings[1] := AppYear;
  End;
  SaveTv(RetNo,FName,FNo);
End;

Procedure T81(RetNo:integer;FName:string;FNo:integer);
Begin
 LoadTv(RetNo,FName,FNo);
 With ret[RetNo].Frm[FNo] do
 begin
  Strings[5]:=AppYear;
  Tv[4]:=Tv[2]-Tv[3];
  If Strings[6]='' then Strings[6]:=FormatDateTime('yyyy-mm-dd',Date);
 end;
 SaveTv(RetNo,FName,FNo);

End;


Procedure T2091(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;  Finst:String;
Begin
 LoadTv(RetNo,FName,FNo);
 With ret[RetNo].Frm[FNo] do
 begin
  //20210412
  if IsDeceased(RetNo) then
  Begin
   for i:=1 to 152 do begin Strings[i]:='';Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   Exit;
  End;

  FInst:=ExtractFormInst(FName);  //20120126
  if Tv[4]>100 then Tv[4]:=100; //20220129 spouse %

  Strings[26]:=AppYear;  //20180114
  Strings[18]:=GetSinNo(RetNo);
  If Strings[2]='' then Strings[2]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
  If Strings[5]='' then Strings[5]:=FormatDateTime('yyyy-mm-dd',Date);
  Strings[25]:=IntToStr(MyStrToINt(Strings[6])+MyStrToINt(Strings[7]));  //20171203
  //Strings[25]:=AddLeadingZeros(Strings[25],2);  //20171203
  Strings[11]:=IntToStr(MyStrToInt(Strings[9])+MyStrToINt(Strings[10]));
  Tv[12]:=Tv[24]; //20220125
  Strings[8]:=Strings[25]; //20180221

  if (Strings[22]='') or (UpperCase(Strings[22])='CA') then Strings[22]:='CAN';  //20180116
 end;

 //pg 2
  With ret[RetNo].Frm[FNo] do
 begin
  Tv[140]:=Tv[12];
  Tv[141]:=Tv[14];
  Tv[142]:=Tv[13];
  Tv[143]:=Tv[141]+Tv[142];
  Tv[144]:=Tv[143];
  Tv[145]:=MaxR(0,Tv[140]-TV[144]);

  Tv[146]:=Tv[145];
  Strings[147]:=IntToStr(MyStrToInt(Strings[8])+1);
  Tv[148]:=Tv[146]*Vl(Strings[147]);
  Strings[149]:=Strings[11];
  If Vl(Strings[149])>0 then
    Tv[150]:=Tv[148]/Vl(Strings[149])
  else
    Tv[150]:=0;
  Tv[151]:=Tv[150];
  Tv[152]:=MaxR(0,Tv[145]-Tv[151]);

  if UpperCase(Strings[3])='Y' then  //20220115
  Begin
   Tv[101]:=Tv[16];
   Tv[102]:=Tv[15];
   Tv[103]:=MaxR(0,Tv[101]-Tv[102]); //20110410 //Tv[103]:=MaxR(0,Tv[1]-Tv[2]);
   Tv[104]:=Tv[103];
   Strings[105]:=IntToStr(MyStrToInt(Strings[6])+1);
   Tv[106]:=Tv[104]*Vl(Strings[105]);
   Strings[107]:=Strings[9];
   If Vl(Strings[107])>0 then
    Tv[108]:=Tv[106]/Vl(Strings[107])
   else
    Tv[108]:=0;
   Tv[109]:=Tv[108];
   Tv[110]:=MaxR(0,Tv[103]-Tv[109]);
  End
  Else
  Begin
   for i:=101 to 110 do Tv[i]:=0;
   Strings[105]:='';
   Strings[107]:='';
  End;

 Tv[111]:=Tv[12];
 Tv[112]:=Tv[16];
 If Tv[112]>Tv[111] then
 begin
  For i:=112 to 124 do begin Tv[i]:=0;Strings[i]:='';end
 end
 else
 begin
  Tv[113]:=Tv[17];
  Tv[114]:=Tv[13];
  Tv[115]:=Tv[112]+Tv[113]+Tv[114];
  Tv[116]:=Tv[115];
  Tv[117]:=Tv[111]-Tv[116];

  Tv[118]:=Tv[117];
  Strings[119]:=Strings[7];
  Tv[120]:=Tv[118]*Vl(Strings[119]);
  Strings[121]:=Strings[10];
  If Vl(Strings[121])>0 then
  Tv[122]:=Tv[120]/Vl(Strings[121])
  else
   Tv[122]:=0;
  Tv[123]:=Tv[122];
  Tv[124]:=MaxR(0,Tv[117]-Tv[123]);
 end;
 Tv[125]:=Tv[16];
 Tv[126]:=Tv[12];
 Tv[127]:=MaxR(0,Tv[125]-Tv[126]);

 Tv[128]:=Tv[110];
 Tv[129]:=Tv[124];
 Tv[130]:=Tv[128]+Tv[129];
 Tv[131]:=Tv[127];
 Tv[132]:=MaxR(0,Tv[130]-Tv[131]);
 Tv[133]:=Tv[132];

 If UpperCase(Strings[138])<>'Y' then
 begin
  For i:=101 to 133 do begin Strings[i]:='';Tv[i]:=0;end;
 end;

 If UpperCase(Strings[138])='Y' then
  Tv[134]:=MinR(Tv[133],Tv[152])  //MinR(Tv[152],Tv[133])  //20230401
 else
  Tv[134]:=Tv[152];

 Tv[135]:=0;   //20220129
 Tv[137]:=0;   //20220129

 Tv[136]:=vl(FetchElm(RetNo,'T209W'+Finst,144));  //20220127
 if Tv[136]>0 then
 begin
  Tv[135]:=Tv[134];
  Tv[137]:=MaxR(0,Tv[135]-Tv[136]);
 end;

 end;
 SaveTv(RetNo,FName,FNo);
End;

Procedure T209W(RetNo:integer;FName:string;FNo:integer);
Var i,OtherFNo:Integer;FInst:String;
Begin
 LoadTv(RetNo,FName,FNo);
 With ret[RetNo].Frm[FNo] do
 begin
   if UpperCase(Strings[30])<>'Y' then  //20220125
   Begin
    for i:=1 to 144 do Begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    Exit;
   End;
   //20171128
   FInst:=ExtractFormInst(FName);  //20171128
   OtherFNo:=GetFormNo('T2091'+Finst);
   if IsDeceased(RetNo) then OtherFNo:=GetFormNo('T1255'+Finst); //20220129
   if OtherFNo=0 then exit;
   //-----------------------
   //Strings[2]:= user
   Strings[1]:= FetchElmFNo(RetNo,OtherFNo,6);
   Strings[3]:=IntToStr(MyStrToInt(Strings[2])+MyStrToInt(Strings[1]));

   Strings[4]:= FetchElmFNo(RetNo,OtherFNo,9);//FetchElmFNo(RetNo,OtherFNo,10); //20220131
   //Strings[5]:= Strings[2]; //user input //FetchElmFNo(RetNo,OtherFNo,2); //20220128
   strings[6]:=IntToStr(MyStrToINt(Strings[5])+MyStrToINt(Strings[4]));
   //strings[7]:=IntToStr(MyStrToINt(Strings[4])+MyStrToINt(Strings[5]));
   Tv[4]:=Vl(FetchElmFNo(RetNo,OtherFNo,9)); //20220127
   Tv[9]:=Vl(FetchElmFNo(RetNo,OtherFNo,15));
   Tv[11]:=Vl(FetchElmFNo(RetNo,OtherFNo,16));

   If Tv[7]>Tv[10] then
   begin
   Tv[14]:=Tv[10];
   Tv[15]:=Tv[7];
   Tv[16]:=Tv[14] * 1.1;
   Tv[17]:=MaxR(0,Tv[15]-Tv[16]);
   Tv[18]:=Tv[17];
   Tv[19]:=MaxR(0,Tv[14]-Tv[18]);
   end
   else
   begin
    For i:=14 to 19 do Tv[i]:=0;
   end;

   if Tv[14]>0  then  //20220127 /used chart 1
     Tv[20]:=Tv[19]
    else
     Tv[20]:=Tv[10];
    Tv[21]:=Tv[8];
    Tv[22]:=MaxR(0,Tv[20]-Tv[21]);
    Tv[23]:=Tv[22];
    Strings[24]:=IntToStr(MyStrToInt(Strings[3])+1);
    Tv[25]:=Tv[23] * MyStrToInt(Strings[24]); ///100;  //20220127
    Strings[26]:=Strings[6];
    If Vl(Strings[26])>0 then
      Tv[27]:=Tv[25]/Vl(Strings[26])
    else
      Tv[27]:=0;
    Tv[28]:=Tv[27];
    Tv[29]:=MaxR(0,Tv[22]-Tv[28]);
   {
   End;
   Else
   Begin
     for i:=20 to 29 do begin Strings[i]:='';Tv[i]:=0;end;
   End;
   }
 end;

 // pg 2
 With ret[RetNo].Frm[FNo] do
 begin
  Strings[145]:=FetchElm(RetNo,'T2091',138);
  //OtherFNo:=GetFormNo('T209W');
  If UpperCase(Strings[145])='Y' then
  begin
   Tv[101]:=Tv[11]; //=Vl(FetchElmFNo(RetNo,OtherFNo,11));
   Tv[102]:=Tv[9]; //Vl(FetchElmFNo(RetNo,OtherFNo,9));
   Tv[103]:=Tv[101]-Tv[102];

   Tv[104]:=Tv[103];
   Strings[105]:= IntToStr(MyStrToInt(Strings[1])+1);  //20171128
   Tv[106]:=Tv[104]*Vl(Strings[105]);
   If Strings[107]='' then Strings[107]:= Strings[4]; //FetchElmFNo(RetNo,OtherFNo,4); //20220131
   If Vl(Strings[107])>0 then
   Tv[108]:=Tv[106]/Vl(Strings[107])
   else
    Tv[108]:=0;
   Tv[109]:=Tv[108];
   Tv[110]:=MaxR(0,Tv[103]-Tv[109]);

   Tv[111]:=Tv[20]; //Vl(FetchElmFNo(RetNo,OtherFNo,20));
   Tv[112]:=Tv[11]; //Vl(FetchElmFNo(RetNo,OtherFNo,11));
   If Tv[112]>Tv[111] then
   begin
    For i:=112 to 123 do begin Tv[i]:=0; Strings[i]:='';end;
   end
   else
   begin
    Tv[113]:=Tv[12]; //Vl(FetchElmFNo(RetNo,OtherFNo,12));
    Tv[114]:=Tv[112]+Tv[113];
    Tv[115]:=Tv[114];
    Tv[116]:=Tv[111]-Tv[115];

    Tv[117]:=Tv[116];
    Strings[118]:=Strings[2]; //FetchElmFNo(RetNo,OtherFNo,2);
    Tv[119]:=Tv[117]*Vl(Strings[118]);
    Strings[120]:=Strings[5]; //FetchElmFNo(RetNo,OtherFNo,5);
    If vl(Strings[120])>0 then
     Tv[121]:=Tv[119]/Vl(Strings[120])
    else
     Tv[121]:=0;
    Tv[122]:=Tv[121];
    Tv[123]:=MaxR(0,Tv[116]-Tv[122]);
   end;

   Tv[124]:=Tv[11]; //Vl(FetchElmFNo(RetNo,OtherFNo,11));
   Tv[125]:=Tv[20]; //Vl(FetchElmFNo(RetNo,OtherFNo,20));
   Tv[126]:=MaxR(0,Tv[124]-Tv[125]);

   Tv[127]:=Tv[110];

   Tv[128]:=Tv[123];
   Tv[129]:=Tv[127]+Tv[128];
   Tv[130]:=Tv[126];
   //Tv[131]:=MaxR(0,Tv[129]-Tv[130]);
   Tv[132]:=MaxR(0,Tv[129]-Tv[130]);

   Tv[133]:=Tv[29]; //Vl(FetchElmFNo(RetNo,OtherFNo,29));
   Tv[134]:=Tv[132];
   Tv[135]:=MinR(Tv[133],Tv[134]);
  end  //complete part 2
  else
  begin
   For i:=101 to 135 do begin Tv[i]:=0;Strings[i]:='';end;
  end;

  Tv[136]:=Tv[135];
  If Tv[135]=0 then Tv[136]:=Tv[29]; //Vl(FetchElmFNo(RetNo,OtherFNo,29));
  Tv[138]:=Tv[136] * vl(Strings[137]);

  If Vl(Strings[139])>0 then
    Tv[140] := Tv[138]/Vl(Strings[139])
  else
    Tv[140]:=0;
  Tv[141]:=Tv[140];
  Tv[142]:=MaxR(0,Tv[136]-Tv[141]);
  Tv[143]:=Tv[13]; //Vl(FetchElmFNo(RetNo,OtherFNo,13));

  Tv[144]:=MinR(Tv[142],Tv[143]);
 end;

 SaveTv(RetNo,FName,FNo);
End;

//copied from T2091 routine EXCEPT IsDeceased
Procedure T1255(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;  Finst:String;
Begin
 FInst:=ExtractFormInst(FName);  //20120126 from below
{
 if FInst>'#1' then  //20220429
 Begin
  FNo:=GetFNo(FName);
  if FNo=0 then
  Begin
   FNo:=GetFormNo(FName);
   if FNo>0 then InitFormdata(RetNo,FNo);
  End;
 End;
}
 LoadTv(RetNo,FName,FNo);
 With ret[RetNo].Frm[FNo] do
 begin
  Strings[26]:=AppYear;  //20220222
  //20210412
  if IsDeceased(RetNo)=False then   //
  Begin
   for i:=1 to 152 do begin Strings[i]:='';Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   Exit;
  End;
  //FInst:=ExtractFormInst(FName);  //20120126
  if Tv[4]>100 then Tv[4]:=100; //20220129 spouse %

  Strings[26]:=AppYear;  //20180114
  Strings[18]:=GetSinNo(RetNo);
  If Strings[2]='' then Strings[2]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
  If Strings[5]='' then Strings[5]:=FormatDateTime('yyyy-mm-dd',Date);
  Strings[25]:=IntToStr(MyStrToINt(Strings[6])+MyStrToINt(Strings[7]));  //20171203
  //Strings[25]:=AddLeadingZeros(Strings[25],2);  //20171203
  Strings[11]:=IntToStr(MyStrToInt(Strings[9])+MyStrToINt(Strings[10]));
  Tv[12]:=Tv[24]; //20220125
  Strings[8]:=Strings[25]; //20180221

  if (Strings[22]='') or (UpperCase(Strings[22])='CA') then Strings[22]:='CAN';  //20180116
 end;

 //pg 2
  With ret[RetNo].Frm[FNo] do
 begin
  Tv[140]:=Tv[12];
  Tv[141]:=Tv[14];
  Tv[142]:=Tv[13];
  Tv[143]:=Tv[141]+Tv[142];
  Tv[144]:=Tv[143];
  Tv[145]:=MaxR(0,Tv[140]-TV[144]);

  Tv[146]:=Tv[145];
  Strings[147]:=IntToStr(MyStrToInt(Strings[8])+1);
  Tv[148]:=Tv[146]*Vl(Strings[147]);
  Strings[149]:=Strings[11];
  If Vl(Strings[149])>0 then
    Tv[150]:=Tv[148]/Vl(Strings[149])
  else
    Tv[150]:=0;
  Tv[151]:=Tv[150];
  Tv[152]:=MaxR(0,Tv[145]-Tv[151]);

  if UpperCase(Strings[3])='Y' then  //20220115
  Begin
   Tv[101]:=Tv[16];
   Tv[102]:=Tv[15];
   Tv[103]:=MaxR(0,Tv[101]-Tv[102]); //20110410 //Tv[103]:=MaxR(0,Tv[1]-Tv[2]);
   Tv[104]:=Tv[103];
   Strings[105]:=IntToStr(MyStrToInt(Strings[6])+1);
   Tv[106]:=Tv[104]*Vl(Strings[105]);
   Strings[107]:=Strings[9];
   If Vl(Strings[107])>0 then
    Tv[108]:=Tv[106]/Vl(Strings[107])
   else
    Tv[108]:=0;
   Tv[109]:=Tv[108];
   Tv[110]:=MaxR(0,Tv[103]-Tv[109]);
  End
  Else
  Begin
   for i:=101 to 110 do Tv[i]:=0;
   Strings[105]:='';
   Strings[107]:='';
  End;

 Tv[111]:=Tv[12];
 Tv[112]:=Tv[16];
 If Tv[112]>Tv[111] then
 begin
  For i:=112 to 124 do begin Tv[i]:=0;Strings[i]:='';end
 end
 else
 begin
  Tv[113]:=Tv[17];
  Tv[114]:=Tv[13];
  Tv[115]:=Tv[112]+Tv[113]+Tv[114];
  Tv[116]:=Tv[115];
  Tv[117]:=Tv[111]-Tv[116];

  Tv[118]:=Tv[117];
  Strings[119]:=Strings[7];
  Tv[120]:=Tv[118]*Vl(Strings[119]);
  Strings[121]:=Strings[10];
  If Vl(Strings[121])>0 then
  Tv[122]:=Tv[120]/Vl(Strings[121])
  else
   Tv[122]:=0;
  Tv[123]:=Tv[122];
  Tv[124]:=MaxR(0,Tv[117]-Tv[123]);
 end;
 Tv[125]:=Tv[16];
 Tv[126]:=Tv[12];
 Tv[127]:=MaxR(0,Tv[125]-Tv[126]);

 Tv[128]:=Tv[110];
 Tv[129]:=Tv[124];
 Tv[130]:=Tv[128]+Tv[129];
 Tv[131]:=Tv[127];
 Tv[132]:=MaxR(0,Tv[130]-Tv[131]);
 Tv[133]:=Tv[132];

 If UpperCase(Strings[138])<>'Y' then
 begin
  For i:=101 to 133 do begin Strings[i]:='';Tv[i]:=0;end;
 end;
 If UpperCase(Strings[138])='Y' then
  Tv[134]:=MinR(Tv[133],Tv[152])  //MinR(Tv[152],Tv[133])  //20230401
  //Tv[134]:=MinR(Tv[152],Tv[133])
 else
  Tv[134]:=Tv[152];

 Tv[135]:=0;   //20220129
 Tv[137]:=0;

 Tv[136]:=vl(FetchElm(RetNo,'T209W'+Finst,144));  //20220127
 if Tv[136]>0 then
 begin
  Tv[135]:=Tv[134];
  Tv[137]:=MaxR(0,Tv[135]-Tv[136]);
 end;

 end;
 SaveTv(RetNo,FName,FNo);
End;


(*
//OLD T1255 20180303
Procedure T1255(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
Begin
 LoadTv(RetNo,FName,FNo);
 With ret[RetNo].Frm[FNo] do
 begin
   //20210412
  if IsDeceased(RetNo)=False then
  Begin
   for i:=1 to 152 do begin Strings[i]:='';Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   Exit;
  End;

  if Tv[4]>100 then TV[4]:=100; //20220129 then

  Strings[26]:=AppYear;  //20180114
  Strings[18]:=GetSinNo(RetNo);
  //20180304
  //If Strings[2]='' then Strings[2]:=GetFirstName(RetNo)+' '+GetLastName(RetNo); //**** FOR DECEASED is the Legal rep
  Strings[3]:=GetFirstName(RetNo)+' '+GetLastName(RetNo); //**** Taxpayer
  If Strings[5]='' then Strings[5]:=FormatDateTime('yyyy-mm-dd',Date);
  Strings[25]:=IntToStr(MyStrToINt(Strings[6])+MyStrToINt(Strings[7]));  //20171203
  Strings[11]:=IntToStr(MyStrToInt(Strings[9])+MyStrToINt(Strings[10]));
  Strings[8]:=Strings[25]; //20180221
  if (Strings[22]='') or (UpperCase(Strings[22])='CA') then Strings[22]:='CAN';  //20180116
 end;

 //pg 2
  With ret[RetNo].Frm[FNo] do
 begin
  Tv[140]:=Tv[12];
  Tv[141]:=Tv[14];
  Tv[142]:=Tv[13];
  Tv[143]:=Tv[141]+Tv[142];
  Tv[144]:=Tv[143];
  Tv[145]:=MaxR(0,Tv[140]-TV[144]);

  Tv[146]:=Tv[145];
  Strings[147]:=IntToStr(MyStrToInt(Strings[8])+1);
  Tv[148]:=Tv[146]*Vl(Strings[147]);
  Strings[149]:=Strings[11];
  If Vl(Strings[149])>0 then
    Tv[150]:=Tv[148]/Vl(Strings[149])
  else
    Tv[150]:=0;
  Tv[151]:=Tv[150];
  Tv[152]:=MaxR(0,Tv[145]-Tv[151]);

  Tv[101]:=Tv[16];
  Tv[102]:=Tv[15];
  Tv[103]:=MaxR(0,Tv[101]-Tv[102]); //20110410 //Tv[103]:=MaxR(0,Tv[1]-Tv[2]);
  Tv[104]:=Tv[103];
  Strings[105]:=IntToStr(MyStrToInt(Strings[6])+1);
  Tv[106]:=Tv[104]*Vl(Strings[105]);
  Strings[107]:=Strings[9];
  If Vl(Strings[107])>0 then
   Tv[108]:=Tv[106]/Vl(Strings[107])
  else
   Tv[108]:=0;
 Tv[109]:=Tv[108];
 Tv[110]:=MaxR(0,Tv[103]-Tv[109]);

 Tv[111]:=Tv[12];
 Tv[112]:=Tv[16];
 If Tv[112]>Tv[111] then
 begin
  For i:=112 to 124 do begin Tv[i]:=0;Strings[i]:='';end
 end
 else
 begin
  Tv[113]:=Tv[17];
  Tv[114]:=Tv[13];
  Tv[115]:=Tv[112]+Tv[113]+Tv[114];
  Tv[116]:=Tv[115];
  Tv[117]:=Tv[111]-Tv[116];

  Tv[118]:=Tv[117];
  Strings[119]:=Strings[7];
  Tv[120]:=Tv[118]*Vl(Strings[119]);
  Strings[121]:=Strings[10];
  If Vl(Strings[121])>0 then
  Tv[122]:=Tv[120]/Vl(Strings[121])
  else
   Tv[122]:=0;
  Tv[123]:=Tv[122];
  Tv[124]:=MaxR(0,Tv[117]-Tv[123]);
 end;
 Tv[125]:=Tv[16];
 Tv[126]:=Tv[12];
 Tv[127]:=MaxR(0,Tv[125]-Tv[126]);

 Tv[128]:=Tv[110];
 Tv[129]:=Tv[124];
 Tv[130]:=Tv[128]+Tv[129];
 Tv[131]:=Tv[127];
 Tv[133]:=MaxR(0,Tv[130]-Tv[131]);
 //Tv[133]:=Tv[132];   //132 out  //20210310

 If UpperCase(Strings[138])<>'Y' then
 begin
  For i:=101 to 133 do begin Strings[i]:='';Tv[i]:=0;end;
 end;
 If UpperCase(Strings[138])='Y' then
  Tv[134]:=MinR(Tv[152],Tv[133])
 else
  Tv[134]:=Tv[152];

 Tv[135]:=Tv[134];
 TV[136]:=TotMultiple(RetNo,'T2091W',144);

 Tv[137]:=MaxR(0,Tv[135]-Tv[136]);
 end;
 SaveTv(RetNo,FName,FNo);
End;
*)


Procedure T2202A(RetNo: integer;FName:string;FNo:integer);
Begin

End;

Procedure T746(RetNo:integer;FName:string;FNo:integer);
Begin
   LoadTv(RetNo,FName,FNo);
   With ret[RetNo].Frm[FNo] do
   begin
    //20230205
    Strings[15]:=GetLastName(RetNo);
    Strings[16]:=GetFirstName(RetNo);
    Strings[17]:=GetSinNo(RetNo);

    Tv[4]:=MaxR(0,Tv[2]-Tv[3]);
    If Strings[5]='' then Strings[5]:=AppYear;
    Tv[6]:=TotMultiple(RetNo,'T4RSP',5);
    Tv[7]:=TotMultiple(RetNo,'T4RSP',6);
    Tv[8]:=TotMultiple(RetNo,'T4RIF',8);
    Tv[12]:=Tv[6]+Tv[7]+Tv[8]+Tv[9]+Tv[10];
    //20150118
    Tv[13]:= Tv[6]+Tv[7]+Tv[8]+Tv[9]+Tv[10]+Tv[14]; //20150128
    Tv[11]:=MinR(Tv[4],Tv[13]);

   end;
   SaveTv(RetNo,FName,FNo);
End;


Procedure T1013(RetNo:integer;FName:string;FNo:integer);
var i:integer;//IsT3:Boolean;
SectionA,SectionB,SectionCancel:Boolean;
// ===========   NOT USED ===========  see below
   Procedure ClearSectionA;
   Begin
     With Ret[RetNo].Frm[FNo] do
     Begin
      Strings[5]:='';
      Strings[27]:='';
      Strings[34]:='';
      Strings[35]:='';
      Strings[8]:='';
      Strings[36]:='';
      Strings[28]:='';
      Strings[38]:='';
      Strings[32]:='';
      Strings[13]:='';
     End;
   end;

   Procedure ClearSectionB;
   var i:integer;
   Begin
     With Ret[RetNo].Frm[FNo] do
     Begin
       Strings[15]:='';
       Strings[22]:='';
       Strings[17]:='';
       Strings[18]:='';
       Strings[19]:='';
       Strings[23]:='';
       Strings[24]:='';
       Strings[25]:='';
       Strings[101]:='';  //a and B
       Strings[132]:='';
       For i:=105 to 124 do Strings[i]:='';
    End;
  end;

  Procedure ClearSectionCancel;
  Begin
    With Ret[RetNo].Frm[FNo] do
    Begin
      //part 4
      Strings[14]:='';
      Strings[16]:='';
      Strings[6]:='';
      Strings[1]:='';
      Strings[31]:='';
      Strings[10]:='';
      Strings[7]:='';
      Strings[2]:='';
    end;
  end;
//----------------------------------
Begin
 LoadTv(RetNo,FName,FNo);
 EXIT;  //  =====================================  NOT USED ==========================
 (*
 With ret[RetNo].Frm[FNo] do
 begin
   if Strings[20]>'' then begin SectionA:=True;SectionB:=False;SectionCancel:=False;End;
   if Strings[21]>'' then begin SectionA:=False;SectionB:=True;SectionCancel:=False;End;
   if Strings[30]>'' then begin SectionA:=False;SectionB:=False;SectionCancel:=True;End;

   //20180201
   // Strings[12]:='T'; //Strings[41]:='';  //Trust not allowed here
   if Strings[8]=''  then Strings[8]:='G';

   //part 1
   Strings[9] := GetSinNo(RetNo);
   Strings[3] := GetFirstName(RetNo);
   Strings[4] := GetLastName(RetNo);

   if Length(Strings[12])>1 then //isT3
   begin
     Strings[3]:='';
     Strings[4]:='';
     Strings[9]:='';
   end
   Else
   Begin
     Strings[12]:='T'; Strings[41]:='';  //Trust not allowed here
   End;

   //20190126
   if SectionA  then  begin ClearSectionB; ClearSectionCancel;end;
   if SectionB  then  begin ClearSectionA; ClearSectionCancel;end;
   if SectionCancel  then  begin ClearSectionA; ClearSectionB;end;


   //SECTION A
   if Strings[8]='' then Strings[8]:='G';
   If UpperCase(Strings[5])='Y' then  //bring from
   begin
     Strings[27] := OptRec.Prp_RepId;
     Strings[34] := OptRec.Prp_FirstName;
     Strings[35] := OptRec.Prp_LastName;
   end;
   //20160307
   If UpperCase(Strings[37])='Y' then  //bring from
   Begin
     Strings[28] := OptRec.Prp_BusNo;
     Strings[38]:=OptRec.Prp_Name;
   end; //20131217

   If Length(Strings[8])>1 then
   begin
     Strings[27]:='';Strings[28]:='';
   end; //20180201

   //level auth
   if Vl(Strings[32])>2 then Strings[32]:='';

   //Section B
   if Vl(Strings[103])>2 then Strings[103]:='';


   //Part 4  //20110114
   if Strings[10]='' then Strings[10]:='G';
   if Strings[14] > '' then  //cancel all
   begin
     Strings[1] := ''; Strings[31] := ''; Strings[2] := '';
     Strings[6] := ''; Strings[10] :=  ''; Strings[7] := '';
   end;

   //Part 5
   If Strings[133] = '' then Strings[133] :=  GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[133]:=UpperCase(Strings[133]); //20141228
   If Strings[131] = '' then Strings[131] :=  FormatDateTime('yyyy-mm-dd',Date);
 end; //with
 SaveTv(RetNo,FName,FNo);
 *)
End;


Procedure T1013I(RetNo:integer;FName:string;FNo:integer);
Begin
   LoadTv(RetNo,FName,FNo);
   With ret[RetNo].Frm[FNo] do
   begin
    Strings[1]:=AppYear;
   end;
   SaveTv(RetNo,FName,FNo);
End;


Procedure FPCHECK(RetNo:integer;FName:string;FNo:integer);
Var i,Cnt:Integer;
Begin
 LoadTv(RetNo,FName,FNo);
 With ret[RetNo].Frm[FNo] do
 begin
    Strings[37]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
    Strings[38] := GetSinNo(RetNo);
    Strings[39] := FetchElm(RetNo,'INFO',54)+' '+FetchElm(RetNo,'INFO',55);

    i:=1;
    Repeat
     If (i=9) Or (i=10) then
     //keep manual
     else
     Strings[i]:='';
     Inc(i,2);
    until i>25;

    { 20140218
    If Ret[RetNo].Province='ON' then
    Begin
     If Vl(FetchElm(RetNo,'ONBEN',8))>0 then Strings[9]:='Y' else Strings[9]:='N';  //prop taxes
     If Vl(FetchElm(RetNo,'ONBEN',7))>0 then Strings[10]:='Y' else Strings[10]:='N';
    end;
    }

   {mortgage ins}
   If UpperCase(FetchElm(RetNo,'INFO',56)) = 'X' then
    Strings[1] := 'X';
   If (ChildBornThisYear(RetNo))
     and (Vl(FetchElm(RetNo,'ONBEN',7)) > 0) {property taxes}  //20120207
    // and (Vl(FetchElm(RetNo,'ON479',8)) > 0) {property taxes}
   then
      Strings[1] := 'X';
   {RESP and life}
   {kids over 18}
   i:=5;
   Repeat
    If (FetchElm(RetNo,'DEPEND',i) >'')
    and (CalcAge(FetchElm(RetNo,'DEPEND',i+5)) >=18) then
     Strings[3]:='X';
    Inc(i,15);
   until i>125;
  {RRSP planning}
   If ((ret[RetNo].Lnn[10100]>0)
   or (ret[RetNo].Lnn[10400]>0)
   or (ret[RetNo].Lnn[12600]>0)
   or (ret[RetNo].Lnn[13500]>0)
   or (ret[RetNo].Lnn[13700]>0)
   or (ret[RetNo].Lnn[13900]>0)
   or (ret[RetNo].Lnn[14100]>0)
   or (ret[RetNo].Lnn[14300]>0))
   and (ret[RetNo].Lnn[20800]=0)
   then Strings[5] :='X';
   {RRSP contr}
   If (Vl(FetchElm(RetNo,'RRSP',11)) >0)
   and (ret[RetNo].Lnn[24500]=0)   {tot contr}
   then Strings[7] :='X';
   {Employer pension plan}
   If  (Vl(FetchElm(RetNo,'T4#1',2)) >0) {empl income}
   and (Vl(FetchElm(RetNo,'T4#1',6)) =0)
   and (Vl(FetchElm(RetNo,'T4#1',16)) =0)
   then Strings[11] := 'X';
   If GetFormNo('T4#2')>0 then
   Begin
    If  (Vl(FetchElm(RetNo,'T4#2',2)) >0)
    and (Vl(FetchElm(RetNo,'T4#2',6)) =0)
    and (Vl(FetchElm(RetNo,'T4#2',16)) =0)
    then Strings[11] := 'X';
   end;
   {life insurance}
   If (UpperCase(FetchElm(RetNo,'INFO',11)) = 'X')
   and (ret[RetNo].Lnn[21200] >0)
   then Strings[13] :='X';
   {need financ investments}
   If (ret[RetNo].Lnn[12000] >500)
   or (ret[RetNo].Lnn[12100] >500)
   or (ret[RetNo].Lnn[12200] >500)
   or (ret[RetNo].Lnn[12700] >500)
   then Strings[15] :='X';

   {need financ Retiring allowances}
   If (TotMultiple(RetNo,'T4A',6)>0)  {elig ret allow}
   and (ret[RetNo].Lnn[24640] =0)
   then Strings[17] :='X';

   {disabil insur}
   If (ret[RetNo].Lnn[13500] >0)
   or (ret[RetNo].Lnn[13700] >0)
   or (ret[RetNo].Lnn[13900] >0)
   or (ret[RetNo].Lnn[14100] >0)
   or (ret[RetNo].Lnn[14300] >0)
   then Strings[19] :='X';
   {CI insurance}
   If (ret[RetNo].Lnn[30600] >0)
   then Strings[21] :='X';
   {large gifts}
   If (ret[RetNo].Lnn[34900] >8000)
   then Strings[23] :='X';
   {Tax shelt-ul ins}
   If (ret[RetNo].Lnn[12000]+ret[RetNo].Lnn[12100] >0)
   and (Vl(FetchElm(RetNo,'DEPEND',1))
       +Vl(FetchElm(RetNo,'DEPEND',2))
       +Vl(FetchElm(RetNo,'DEPEND',4))>0)
   then Strings[25] :='X';

   {count responses}
   Cnt:=0;
   i:=2;
   Repeat
    If UpperCase(Strings[i]) <> '' then Inc(Cnt);
    Inc(i,2);
   until i>26;
   Strings[35] :=IntToStr(Cnt);
   If Cnt=0 then Strings[35] :='';
   {count recommended}
   Cnt:=0;
   i:=1;
   Repeat
    If UpperCase(Strings[i]) = 'X' then Inc(Cnt);
    Inc(i,2);
   until i>25;
   Strings[36] :=IntToStr(Cnt);
   If Cnt=0 then Strings[36] :='';
 end;
 SaveTv(RetNo,FName,FNo);
End;

Procedure T1221(RetNo:integer;FName:string;FNo:integer);
var i,k:integer;s:String;SlipFNo:Integer;FrmNm:String;
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   //For i:=1 to 54 do begin Strings[i]:='';Tv[i]:=0;end; //20230131
   Strings[1]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[2]:=GetSinNo(RetNo);
   Strings[3]:= FetchElm(RetNo,'INFO',6);
   Strings[5]:=AppYear;
   s:=FetchElm(RetNo,'INFO',22);
   If S>'' then s:='Apt: '+s;
   Strings[4]:= FetchElm(RetNo,'INFO',68)
               +' '+FetchElm(RetNo,'INFO',10)
               +' '+FetchElm(RetNo,'INFO',14)
               +' '+FetchElm(RetNo,'INFO',15);

   Tv[54]:=Tv[7]+Tv[9]+Tv[11];  //20230131
   (*  //20230131
   {Collect from T101 and T5013}
   k:=6;
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];
      If (Frec.FormName = 'T101')
      and (Vl(FetchElmFNo(RetNo,Frec.FormNo,23))>0) then
      begin
       strings[k]:=FetchElmFNo(RetNo,Frec.FormNo,1);
       Tv[k+1]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,23));
       Inc(k,2);
      end;
      If (Frec.FormName = 'T5013')
      and (Vl(FetchElmFNo(RetNo,Frec.FormNo,59))>0) then
      begin
       strings[k]:='(T5013 slip)';
       Tv[k+1]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,59));
       Inc(k,2);
      end;
      If K>52 then Break;
   end;
   Tv[54]:=AddColumns(7,53,2);
  *)
  end;
  SaveTv(RetNo,FName,FNo);
End;

Procedure T1231(RetNo:integer;FName:string;FNo:integer);
var i:integer;X:Real;
Begin
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'BC') = false  then
  begin
   For i:=1 to 19 do begin ret[RetNo].Frm[FNo].Tv[i]:=0;ret[RetNo].Frm[FNo].Strings[i]:='';end;
   exit;
  end;

  with ret[RetNo].Frm[FNo] do
  begin
    Tv[1]:=TotMultiple(RetNo,'T101',21)+TotMultiple(RetNo,'T101',11)+TotMultiple(RetNo,'T5013',57); //20240409
    //If X>0 then Tv[1]:=x;   ???//20240409
    Tv[2]:=20.00;
    Tv[3]:=Tv[1] * Tv[2]/100;
    Tv[4]:=Tv[3];
    Tv[19]:=Tv[4]+Tv[18];

    Tv[5]:=Vl(FetchElm(RetNo,'BC428',101));
    Tv[6]:=MinR(Tv[19],Tv[5]);
    Tv[7]:=Tv[6];

    Tv[8]:=Tv[19];
    Tv[9]:=Tv[7];
    Tv[10]:=MaxR(0,Tv[8]-Tv[9]);

    Tv[14]:=Tv[11]+Tv[12]+Tv[13];  //20130114 with err if exceeds Tv[10]
    //Tv[14]:=MinR(Tv[10],Tv[11]+Tv[12]+Tv[13]);

    Tv[15]:=Tv[14];
    Tv[16]:=MaxR(0,Tv[10]-Tv[15]);

    If Strings[17]='' then Strings[17] := FormatDateTime('yyyy-mm-dd',Date);
  end;
    {save data}
    SaveTv(RetNo,FName,FNo);
End;

procedure TRANSF(RetNo: integer; FName: String;FNo: integer);

            Function ClearAutoFields:Boolean;  //function within procedure
            Var i:Integer;
            begin
             For i:=1 to 157 do
             begin
              Case i of
               158,3,4,2: //do nothing
               Else begin Ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0; end;
              end;
             end;
            end;

Var  i,k,j,jj,RNo,DependFNo,DisabFNo: integer;Dsblty,
     Edctn,X:real;PercentClaim:Real;
     Txbl:Real;  //20181223
     s50,S70:string;
     spRetNo:Integer;
    // TotUnused, MaxXfer: real; //20200310  not used
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
   //20170611
   if Ret[RetNo].MarStatus>2 then
   Begin
    Tv[70]:=100;  //at 100% taxpayer
    Tv[50]:=0;  //other spouse
    Tv[69]:=100;  //at 100% taxpayer
    Tv[48]:=0;  //other spouse
   end;

    If Strings[1]='' then Strings[1] :='N';
    If Strings[79]='' then Strings[79] :='N';
    If UpperCase(Strings[158])='Y' then ClearAutoFields;      //20110320


    {
    //202400312
    SpRetNo := GetSpRetNo(RetNo);
    If (Ret[RetNo].CouplingSw) and (SpRetNo > 0) then
    Begin
     if (UpperCase(FetchElmFNo(SpRetNo,FNo,1))='Y')
     and (UpperCase(FetchElmFNo(SpRetNo,FNo,79))='Y') then
     Begin
      Strings[1]:='N';
      Strings[79]:='N';
      Tv[116]:=0;
      Tv[146]:=0;
     end;
    end;
    }


    //20240312
    // reverse % if necessary so both the same //20240306
    SpRetNo := GetSpRetNo(RetNo);
    If (Ret[RetNo].CouplingSw) and (SpRetNo > 0) then
    Begin
     //tuition
     Strings[70]:=IntToStr(100-myStrToInt(FetchElmFNo(SpRetNo,FNo,70)));  //upper %
     Strings[50]:=IntToStr(100-MyStrToInt(FetchElmFNo(SpRetNo,FNo,50)));  //Lower %
     //diability
     Strings[69]:=IntToStr(100-myStrToInt(FetchElmFNo(SpRetNo,FNo,69)));  //upper %
     Strings[48]:=IntToStr(100-MyStrToInt(FetchElmFNo(SpRetNo,FNo,48)));  //Lower %

     {
     if (s70>'') or (S50>'') then
     Begin
      //reverse
      Strings[70]:=S70; //S50;
      Strings[50]:=s50; //S70;
      }
    end;

    Tv[71] :=0;Tv[72] :=0;
    {Bring from dependants}
    DisabFNo := GetFormNo('DISAB');
    DependFNo :=GetFormNo('DEPEND');

    If UpperCase(Strings[1]) = 'Y' then  {Fill dependand's names and Sins}
    begin
     i:=5;j:=5;k:=73;jj:=150; //jj=indx to txbl income
     For i:=0 to 5 do
     begin
       Strings[5+i] := FetchElmFNo(RetNo,DependFNo,j); {Dep name}
       Strings[k] := FetchElmFNo(RetNo,DependFNo,j+2); {Dep SIN}
       If Strings[5+i]>'' then
       begin
        If CalcAge(FetchElmFNo(RetNo,DependFNo,j+5)) < 18 then
         Strings[101+i] := 'X'
        else
          Strings[101+i] := '';
       end
       Else //20140117
       Begin
        Strings[23+i]:='';  //months
        Strings[29+i]:='';
        Strings[122+i]:='';
        TV[81+i]:=0;
        Tv[35+i]:=0;
        Tv[41+i]:=0;
        Tv[59+i]:=0;
        Tv[110+i]:=0;
        Tv[140+i]:=0;
        Tv[116+i]:=0;
        Tv[146+i]:=0;
        Strings[11+i]:='';  //disability
       end;
       If (Uppercase(FetchElmFNo(RetNo,DependFNo,j+7)) ='Y') {disabled}
      // and (Uppercase(FetchElmFNo(RetNo,DependFNo,i+141))<>'Y'))      //20170509   //20170511
       then
         Strings[11+i] := 'X'
       else
         Strings[11+i] := '';

       Tv[53+i]:= vl(FetchElmFNo(RetNo,DependFNo,jj)); //txbl //If Tv[i+53]=0 then Tv[i+53]:= vl(FetchElmFNo(RetNo,DependFNo,jj)); //txbl
       //RNo:=FindReturnNoFromSin(Strings[i+73]);

       //20110814
       If Strings[5+i]='' then Tv[128+i]:=0; //If Strings[i+5]='' then Tv[i+128]:=0;
       Inc(j,15);
       Inc(k);
       Inc(jj);
      end;
     end;

     If UpperCase(Strings[79]) = 'Y' then  {Fill the rest if return found}
     begin
     k:=5;{j:=11;} {i=Dep SIn elm,K=indx to dep name in DEP,J=Disab lm}
     For i:=0 to 5 do
     begin
       RNo:=FindReturnNoFromSin(Strings[i+73]);
       If RNo>0 then  //coupling return
       begin
         Tv[53+i] := Ret[RNo].Lnn[26000]+Vl(FetchElm(RNo,'OTHDED',4)); //taxable before TOSI deduction 20181223    //Tv[53+i] := Ret[RNo].Lnn[26000]; {txbl}
         If TosiInEffect(RNo) then Txbl:=Tv[53+i]+Vl(FetchElm(RNo,'T1206',43));  //20181223
         if Strings[5+i]>'' then  //20180414
          Tv[128+i]:=L300ToL314(RNo)  //20180319
         Else
         ;  // Tv[128+i]:=0;  //20190410

         //Education columns   //20130319
         If FetchElm(RNo,'S11',26) = GetSinNo(RetNo) then //transfered to this parent SIN
         Begin
          Tv[134+i]:= Vl(FetchElm(RNo,'S11',13));
          Strings[23+i] :=FetchElm(RNo,'S11',42); //20180412  fulltime months
          Tv[29+i]:= Ret[RNo].Lnn[322];   {Educ at full rate}
          Strings[122+i] :=FetchElm(RNo,'S11',35); //20180412  part time months
          Tv[81+i] := Ret[RNo].Lnn[32100];   {Educ at $60}
          Tv[35+i] := Ret[RNo].Lnn[32000]+Ret[RNo].Lnn[32001];   {Tuition} //20200406
          Tv[59+i] := L300ToL318(RNo);  //20180319
          Tv[110+i]:= Vl(FetchElm(RNo,'S11',21));
          Tv[116+i] := Vl(FetchElm(RNo,'S11',10));
         End
         Else
         Begin
          Tv[134+i]:=0;
          Strings[23+i]:='';
          Tv[29+i]:=0;
          Strings[122+i]:='';
          Tv[81+i] := 0;
          Tv[35+i] := 0;
          Tv[59+i] := 0;
          Tv[110+i]:= 0;
          Tv[116+i] :=0;
         end;
       end;
       Inc(k,15);
      end;
     end;  //autofillfrom coupling

    {Calculations}
     {Disability}
    For i := 0 to 5 do
    begin
     RNo:=FindReturnNoFromSin(Strings[i+73]);
     If RNo>0 then
     Begin
      If (Strings[i+5] > '') {Name present}
      and (UpperCase(Strings[11+i]) = 'X') then
      Begin
       Txbl:=Tv[53+i]+GetDependantTosiTaxableIncome(RetNo,i,DependFNo);
                                              {under 18,   ChCare    Attcare txbl  Lines 1-21}
       Tv[17+i] :=CalcFedDisabilityXfer(RNo,Strings[101+i],Tv[87+i],Tv[93+i],Txbl,Tv[128+i]) //20180320 Rno
         // Tv[17+i] :=CalcFedDisabilityXfer(RNo,Strings[101+i],Tv[87+i],Tv[93+i],Tv[53+i],Tv[128+i]) //20180320 Rno
      end
      else
        Tv[17+i] := 0; //20180326

      If Tv[152+i]>0 then  Tv[17+i]:=Tv[152+i];  //20200401
      {
      //20200401
      //new
      If (Tv[152+i] >0) and (Tv[152+i]<=Tv[17+i]) then Tv[17+i]:=Tv[152+i];
      If Tv[152+i] >Tv[17+i] then Tv[152+i] :=0;
      }
     end //rno
     Else //20180328
     Begin  //Rno not loaded
      Txbl:=Tv[53+i]+GetDependantTosiTaxableIncome(RetNo,i,DependFNo);
      If ((Strings[i+5] > '')  and (UpperCase(Strings[11+i]) = 'X')) then
       Tv[17+i] :=CalcFedDisabilityXfer(RetNo,Strings[101+i],Tv[87+i],Tv[93+i],Txbl,Tv[128+i]) //20180320 Rno //20181223
       //Tv[17+i] :=CalcFedDisabilityXfer(RetNo,Strings[101+i],Tv[87+i],Tv[93+i],Tv[53+i],Tv[128+i]) //20180320 Rno
      Else
       Tv[17+I]:=0;  //no name, not disabled
     end;
     If Tv[152+i]>0 then  Tv[17+i]:=Tv[152+i];  //20200401
    end; //i

    {Education}
    For i := 0 to 5 do
    begin
      If Vl(Strings[23+i]) > 0 then
       Tv[29+I] := Vl(Strings[23+i]) * (Constant[RY].EducPerMonth)  //20180308
       // Tv[29+I] := Vl(Strings[23+i]) * (Constant[RY].EducPerMonth +65)
      else
        Tv[29+i] := 0;
      If Vl(Strings[122+i]) > 0 then
        Tv[81+I] := Vl(Strings[122+i]) * (Constant[RY].PartEducPerMonth) //20180308
       // Tv[81+I] := Vl(Strings[122+i]) * (Constant[RY].PartEducPerMonth + 20)
      else
        Tv[81+I] := 0;
    end;

    {tot education}
    For i := 0 to 5 do
    begin
      Tv[41+i] := Tv[29+i] +Tv[35+i]+Tv[81+i];
      If (UpperCase(Strings[79]) = 'Y') then
      begin
         RNo:=FindReturnNoFromSin(Strings[i+73]);
         If RNo>0 then {claim} Tv[110+i]:= Vl(FetchElm(RNo,'S11',21))
      end
      else
      {Claim} Tv[110+i] := MinR(Tv[110+i],
                           CalcFedEducClaim(Tv[134+i],Tv[41+i],Tv[53+i],Tv[59+i]));
                                            //unused , thisyr,   Txbl,   L300To318}

      If (UpperCase(Strings[79]) = 'Y') then
      begin
         RNo:=FindReturnNoFromSin(Strings[i+73]);
        {override}
        If (RNo>0) and (UpperCase(FetchElm(RNo,'S11',36)) = 'Y') {xfer to parent}
          then Tv[146+i] := Vl(FetchElm(RNo,'S11',10));
      end;

      Tv[116+i]  :=MaxR(0,MinR(5000,Tv[41+i])); //20200310
      //20200406
      if (RNo>0) and (Tv[116+i]>Vl(FetchElm(RNo,'S11',30))) then
       Tv[116+i]:=Vl(FetchElm(RNo,'S11',30));
       //20200401
      If Tv[146+i]>0 then Tv[116+i]:=Tv[146+i]; //MinR(5000,Tv[146+i]);

      {      //20200401
      If (Tv[146+i] >0) and (Tv[146+i]<=Tv[116+i]) then Tv[116+i]:=Tv[146+i];
      If Tv[146+i] >Tv[116+i] then Tv[146+i] :=0;
      }
    end;

    For i := 0 to 5 do
    begin
     Tv[71] := Tv[71] + Tv[17+i];
     Tv[72] := Tv[72] + Tv[116+i];
    end;

    //20240312
    Tv[71]:=Tv[71] * Tv[69]/100;
    Tv[72]:=Tv[72] * Tv[70]/100;

    //Tv[71] //20131215  //done altready in GetFedDisability
    If Rule90(RetNo)<90 then Tv[72]:=Tv[72] * ret[RetNo].PartYear;  //20121215


    Strings[51]:=GetFirstName(RetNo);
    Strings[52]:=Strings[51];
    Strings[47]:=GetSpouseFirstName(RetNo);
    Strings[49]:=Strings[47];
    Tv[69]:=MinR(100,Tv[69]);
    Tv[70]:=MinR(100,Tv[70]);
    If (Tv[70]>0) and (Tv[70]<100) then Tv[70]:=100;
    Tv[48]:=100-Tv[69];
    Tv[50]:=100-Tv[70];

    //April 20 2008
    If UpperCase(Strings[158])='Y' then
    begin
      Tv[72]:=Tv[3];
      Tv[71]:=Tv[4];
      Tv[70]:=100;Tv[50]:=0;
      Tv[69]:=100;Tv[48]:=0;
      Strings[1]:='N';
      Strings[79]:='N';
    end
    Else
    begin
     Tv[3]:=0;
     Tv[4]:=0;
    end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);

  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked=False) then
  begin
    with ret[RetNo].Frm[FNo] do
    begin
     StoreElm(RetNo,GetFormNo('OPTIMIZE'),46,FormatFloat('###.##',Tv[69]));
     StoreElm(RetNo,GetFormNo('OPTIMIZE'),47,FormatFloat('###.##',100-Tv[69]));
     StoreElm(RetNo,GetFormNo('OPTIMIZE'),62,FormatFloat('###.##',Tv[70]));
     StoreElm(RetNo,GetFormNo('OPTIMIZE'),63,FormatFloat('###.##',100-Tv[70]));
    end;
  end;
end;

procedure T1198(RetNo: integer; FName: String;FNo: integer);
Var i,j,TaxFNo1:Integer;
T2203FNo:Integer;
Begin
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin
  //20110311
  Strings[1]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
  Strings[2]:=GetSinno(RetNo);
  If Strings[39]='' then Strings[39]:= FormatDateTime('yyyy-mm-dd',Date);
  If Uppercase(Strings[48]) <> 'Y' then
  Begin
   Strings[3]:=AppYear;
   Tv[6]:=0;
   For i:=10 to 36 do Tv[6]:=Tv[6]+Tv[i];
   Tv[6]:=Tv[6]+Tv[40]+Tv[41]+Tv[42]+Tv[43]+Tv[44]+Tv[45]+Tv[46]+Tv[47]+Tv[49]+Tv[50]
     +Tv[51]+Tv[52]
     +Tv[53]
     +Tv[54];  //20200208
   Tv[8]:=Tv[6]-Tv[54];//20200208;
  end;
 end;
 SaveTv(RetNo,FName,FNo);
end;




procedure T1241(RetNo: integer; FName: String;FNo: integer);
Var i,j:Integer;
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
   Strings[11]:=AppYear;
   Tv[1]:= TotMultiple(RetNo, 'T101', 24) + TotMultiple(RetNo, 'T5013', 40)(* + TotMultiple(RetNo, 'T5013', {243???})*); //20251219 Igor
   Tv[2]:=30;
   Tv[13]:=Tv[1]*Tv[2]/100;
   Tv[14]:=Tv[13];
   Tv[3]:=Tv[12]+Tv[14];

   Tv[5]:=Vl(FetchElm(RetNo,'MB428',116));
   Tv[4]:=MinR(Tv[3],Tv[5]);

   Tv[6]:=Tv[4];
   If UpperCase(Strings[17]) = 'Y' then Tv[6]:=Tv[18];

   Tv[7]:=Tv[3];
   Tv[8]:=Tv[6];
   Tv[15]:=MaxR(0,Tv[7]-Tv[8]);
   If Strings[10]='' then Strings[10]:=FormatDateTime('yyyy-mm-dd',Date);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure T1256(RetNo: integer; FName: String;FNo: integer);
Var i,j:Integer;
Begin
  //20151117  many changes
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
   Strings[12]:=AppYear;
   If Tv[20]>27000 then Tv[20]:=27000;
   Tv[3]:=Tv[1]+Tv[20]; //20151203 //MaxR(0,Tv[1]-Tv[20]); //Tv[19]+Tv[20];
   If Tv[3]>27000 then Tv[3]:=27000;

   Tv[4]:=Tv[20];
   Tv[21]:=MaxR(0,Tv[3]-Tv[4]); //20141206

   Tv[5]:=Vl(FetchElm(RetNo,'MB428',103));
   //jz//MJCERT2024//20250511
   if IsMultJurisdiction(RetNo) then
    Tv[5]:=Vl(FetchElm(RetNo,'MBMJ',146));
   If UpperCase(Strings[18]) <> 'Y' then Tv[6]:=MinR(Tv[21],Tv[5]);

   Tv[7]:=Tv[1]; //Tv[19];
   Tv[8]:=Tv[6];
   Tv[11]:=MaxR(0,Tv[7]-Tv[8]);
   If Strings[13]='' then Strings[13]:= FormatDateTime('yyyy-mm-dd',Date);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure T12561(RetNo: integer; FName: String;FNo: integer);
Var i,j:Integer;
Begin
 //20141117
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
   Strings[1]:=AppYear;
  //20220110
   If Tv[12]>202500 then Tv[12]:=202500;    //20211117
   If Tv[13]>225000 then   Tv[13]:=225000;  //20220119  //20211117
   Tv[10]:=Tv[9]+Tv[12]+Tv[13]; //20220119  //20220110
   If Tv[10]>225000 then Tv[10]:=225000; //120000); //202201
   Tv[11]:=MinR(120000,Tv[10]);
   Tv[3]:=Vl(FetchElm(RetNo,'MB428',116));
   if IsMultJurisdiction(RetNo) then Tv[3]:=Vl(FetchElm(RetNo,'MBMJ',164));  //20251202 CZ
   Tv[4]:=MinR(Tv[11],Tv[3]);

   Tv[5]:=Tv[10];
   Tv[6]:=Tv[3];
   Tv[7]:=MaxR(0,Tv[5]-Tv[6]);
   If Strings[8]='' then Strings[8]:= FormatDateTime('yyyy-mm-dd',Date);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure T12562(RetNo: integer; FName: String;FNo: integer);
Var i,j:Integer;
Begin
 //20141205
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
   Strings[1]:=AppYear;
   If Tv[9]>202500 then Tv[9]:=202500;
   If Tv[2]>27000 then Tv[2]:=27000;
   //20151117
   Tv[22]:=Tv[9]+Tv[2];
   Tv[10]:=Tv[22];
   Tv[21]:=Tv[11]+Tv[10];
   Tv[3]:=MinR(Tv[10],27000);

   Tv[12]:=Vl(FetchElm(RetNo,'MB428',73));
   if IsMultJurisdiction(RetNo) then Tv[12]:=Vl(FetchElm(RetNo,'MBMJ',113));//20251202 cz
   Tv[4]:=Tv[21];
   Tv[13]:=Tv[3];
   Tv[14]:=MaxR(0,Tv[4]-Tv[13]);
   Tv[15]:=Tv[14];

   Tv[16]:=67500;
   Tv[17]:=Tv[3];
   Tv[18]:=MaxR(0,Tv[16]-Tv[17]);
   Tv[19]:=Tv[18];

   Tv[20]:=MinR(Tv[12],MinR(Tv[15],Tv[19]));
   Tv[5]:=Tv[15];
   Tv[6]:=Tv[20];
   Tv[7]:=MaxR(0,Tv[5]-Tv[6]);
   If Strings[8]='' then Strings[8]:= FormatDateTime('yyyy-mm-dd',Date);
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;

procedure T1258(RetNo: integer; FName: String;FNo: integer);
Var i,j:Integer;
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
   Strings[12]:=AppYear;
   If Strings[13]='' then Strings[13]:= FormatDateTime('yyyy-mm-dd',Date);
   Tv[3]:=Tv[1]+Tv[2];
   Tv[4]:=MinR(75000,Tv[3]);  //20090124
   Tv[5]:=Vl(FetchElm(RetNo,'NB428',148));
   Tv[6]:=MinR(Tv[4],Tv[5]);

   Tv[7]:=Tv[3];
   Tv[8]:=Tv[6];
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);

   Tv[15]:=Tv[10]+Tv[14]+Tv[17];
   Tv[16]:=Tv[15];
   If Tv[16]>Tv[9] then Tv[16]:=Tv[9];
   Tv[11]:=MaxR(0,Tv[9]-Tv[16]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20251008 Igor >>>
procedure T1223(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j, T4FNo: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  if (FNo = 0) then exit;

  with Ret[RetNo].Frm[Fno] do
  begin
    //Page 1
    Strings[1]:= GetLastName(RetNo);
    Strings[2]:= GetFirstName(RetNo);
    Strings[3]:= GetSinno(RetNo);
    Strings[31]:= AppYear;
    Strings[4]:= FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO', 22);
    Strings[29]:= FetchElm(RetNo, 'INFO', 68) + ' ' + FetchElm(RetNo, 'INFO', 10) + ' ' + FetchElm(RetNo, 'INFO', 14) + ' ' + FetchElm(RetNo, 'INFO', 15);

    //Page 2
    if not UpperCase(Strings[33]).Equals('Y') then
    begin
      Tv[118]:= 0;

      for i:= 1 to 5 do
      begin
        T4FNo:= GetFormNo('T4' + '#' + AllTrim(IntToStr(i)));

        if (T4FNo > 0) and UpperCase(FetchElmFNo(RetNo, T4FNo, 37)).Equals('Y') then Tv[118]:= Tv[118] + Vl(FetchElmFNo(RetNo, T4FNo, 19));
      end;
    end;

    Tv[107]:= Tv[106] / 3;
    if (Vl(Strings[117]) > 12) then Strings[117]:= '12';
    if (Vl(Strings[108]) > 12) then Strings[108]:= '12';

    Tv[109]:= MinR(Vl(Strings[108]) * 1000, 10000);
    Tv[110]:= MaxR(Tv[107], Tv[109]);
    Tv[113]:= MaxR(0, Tv[111] - Tv[112]);
    Tv[114]:= MinR(Tv[110], Tv[113]);
    //Tv[115]:= MinR(Tv[111], Tv[114]);
    Tv[116]:= MinR(Tv[106], Tv[114]);

    if not UpperCase(Strings[34]).Equals('Y') then Tv[120]:= Tv[118] + Tv[116];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<

Procedure CONSENT(RetNo:integer;FName:string;FNo:integer); //20200212
Var i:Integer; s:String;
Begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    if Strings[66]='' then Exit;  //prepare this year not printed
    if Strings[12]='' then begin Strings[16]:='';Strings[15]:='';end; //20180728  //not all programs
    if Strings[13]>'' then //authorize
    Begin //clear cancellation elms
      For i:=45 to 49 do begin Strings[i]:='';end;
      Strings[42]:='';
      Strings[51]:='';
    End;

    if Uppercase(Strings[65])='Y' then Strings[10]:=OptRec.Prp_RepId;
    if Uppercase(Strings[3])='Y' then Strings[20]:=OptRec.Prp_BusNo;

    if Strings[34]>'' then //authorize
    Begin //clear Auth data
      Strings[10]:='';
      Strings[57]:='';
      Strings[20]:='';
      Strings[21]:='';
      Strings[27]:='';
      Strings[12]:='';
      Strings[16]:='';
      Strings[15]:='';
      Strings[17]:='';
      Strings[24]:='';
      Strings[31]:='';
      Strings[38]:='';
    End;
    //optiona1
    Strings[16]:=LeftStr(Strings[16],2);
    //option 2
    i:=17;
    Repeat
     Strings[i]:=LeftStr(Strings[i],2);
     Strings[i+5]:=LeftStr(Strings[i+5],2);
     if Strings[17]='' then begin Strings[i+5]:='';Strings[i+6]:=''; end;
     Inc(i,7);
    until i>38;

    if Strings[47] > '' then //cancell all
    begin
      Strings[48]:='';Strings[45]:='';Strings[51]:='';Strings[50]:='';Strings[49]:='';Strings[42]:='';
    end;

    if Strings[48] > '' then  //rep id
    begin
      Strings[50]:='';Strings[49]:='';Strings[42]:='';
    end;

    if Strings[50] > '' then //groupid
    begin
      Strings[48]:='';Strings[45]:='';Strings[51]:='';Strings[49]:='';Strings[42]:='';
    end;

    if Strings[49] > '' then     //bus
    begin
      Strings[48]:='';Strings[50]:='';
    end;

    If Strings[41]>'' then //20200218
    Begin
     Strings[53]:=GetFirstName(RetNo);
     Strings[54]:=GetLastName(RetNo);
    end;
    If Strings[55]='' then Strings[55]:=FormatDateTime('yyyy-mm-dd',Date); //FormatDateTime('yyyy/mm/dd',Date); //20210401
  end; //with
End;

//20251008 Igor >>>
procedure T2043A(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  x: Real;
  FInst: string;
  T2203FNo: Integer;
  FarmFName: string;
  FarmFNo: Integer;  //20220423
  Totexp: Real;
  TotMInv: Real;
  TotOInv: Real;
  TotGInc: Real;
  TotSal: Real;
begin
  if FNo = 0 then exit;
  T2203FNo:= GetFormNo('T2203');  //20220416
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    FarmFName:= AllTrim(LeftStr(Alltrim(Strings[69]), 8));
    FarmFNo:= GetFormNo(FarmFName);
    if FarmFNo = 0 then exit;   //20220424
  End; //with

  if Vl(FetchElm(RetNo, 'T2043', 2)) < 25000 then  //20220614
  begin
    for i:= 1 to 95 do
    begin
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;

    SaveTv(RetNo, FName, FNo);
    Exit;
  end;

  GetT2030ACharts(RetNo, FarmFname, FarmFNo, Totexp, TotMInv, TotOInv, TotGInc, TotSal);

  with Ret[RetNo].Frm[Fno] do
  begin
    //Page 1. ChartA
    //20220417
    Tv[1]:= TotExp;
    Tv[2]:= TotMInv;
    Tv[3]:= TotOInv;
    Tv[51]:= Tv[2] + Tv[3] + Tv[4];   //20230203
    Tv[5]:= Tv[51]; //Tv[2]+Tv[3]+Tv[4]; //20230203
    Tv[6]:= MaxR(0, Tv[1] - Tv[51]); //20230203
    //Tv[6]:=MaxR(0,Tv[1]-Tv[5]);   //20230203 //20220417
    Tv[61]:= Tv[6] - Tv[56];

    //Page 2
    Tv[88]:= TotGInc;
    Tv[91]:= TotSal;
    Tv[90]:= TotSal;
    Tv[8]:= TotGInc;
    Tv[17]:= TotGInc;
    Tv[26]:= TotGInc;
    Tv[35]:= TotGInc;
    Tv[11]:= TotSal;
    Tv[20]:= TotSal;
    Tv[29]:= TotSal;
    Tv[38]:= TotSal;

    //Gross inc  minus credit
    Tv[87]:= MaxR(0, TotGInc - Tv[7] - Tv[16] - Tv[25] - Tv[34]); //tot groos all farming
    Tv[90]:= MaxR(0, TotSal - Tv[8] - Tv[17] - Tv[26] - Tv[35] - Tv[34]); //tot groos all farming

    //RAW 3
    if Tv[8] > 0 then Tv[9]:= (Tv[7] / Tv[8]) * 100 else Tv[9]:= 0; //on
    if Tv[17] > 0 then Tv[18]:= (Tv[16] / Tv[17]) * 100 else Tv[18]:= 0; //mb
    if Tv[26] > 0 then Tv[27]:= (Tv[25] / Tv[26]) * 100 else Tv[27]:= 0; //sk
    if Tv[35] > 0 then Tv[36]:= (Tv[34] / Tv[35]) * 100 else Tv[36]:= 0; //ab

    if not UpperCase(Strings[57]).Equals('Y') then  //get salaties
    begin
    end;

    //RAW 5 Salaries  do for each prov //20220416
    if FetchElm(RetNo,'T2043',1).Equals('') then  //NON MULT  //20220428
      if not UpperCase(Strings[57]).Equals('Y') then
      begin
        TotSal:= TotMultiple(RetNo, 'T2042', 115) + TotMultiple(RetNo, 'T1163', 526) + TotMultiple(RetNo, 'T1273', 526);
        Tv[11]:= TotSal;
        Tv[20]:= TotSal;
        Tv[29]:= TotSal;
        Tv[38]:= TotSal;
      end;

    //RAW 6, 7 , 8 , 9
    //ON
    if Tv[11]>0 then Tv[12]:=(Tv[10]/Tv[11])*100 else Tv[12]:=0;
    Tv[13]:=Tv[9]+Tv[12];
    Tv[14]:=Tv[13]*50/100;
    if (Tv[8]=0) or (Tv[11]=0) then Tv[14]:=Tv[13]; //*50/100;
    Tv[15]:=Tv[14]*Tv[6]/100;   //20220416

    //MB
    if Tv[20]>0 then Tv[21]:=(Tv[19]/Tv[20])*100 else Tv[21]:=0;
    Tv[22]:=Tv[18]+Tv[21];
    Tv[23]:=Tv[22]*50/100;
    if (Tv[17]=0) or (Tv[20]=0) then Tv[24]:=Tv[23];
    Tv[24]:=Tv[23]*Tv[6]/100;
    //SK
    if Tv[29]>0 then Tv[30]:=(Tv[28]/Tv[29])*100 else Tv[29]:=0;
    Tv[31]:=Tv[27]+Tv[30];
    Tv[32]:=Tv[31]*50/100;
    if (Tv[26]=0) or (Tv[29]=0) then Tv[32]:=Tv[31];
    Tv[33]:=Tv[32]*Tv[6]/100;
    //AB
    if Tv[38]>0 then Tv[39]:=(Tv[37]/Tv[38])*100 else Tv[39]:=0;
    Tv[40]:=Tv[36]+Tv[39];
    Tv[41]:=Tv[40]*50/100;
    if (Tv[35]=0) or (Tv[38]=0) then Tv[41]:=Tv[40];
    Tv[42]:=Tv[41]*Tv[6]/100;

    //20251009 Igor
    Tv[82]:= Tv[15] * Tv[62];
    Tv[83]:= Tv[24] * Tv[63];
    Tv[84]:= Tv[33] * Tv[64];
    Tv[85]:= Tv[42] * Tv[65];
    Tv[86]:= Tv[112] * Tv[66];
    Tv[96]:= Tv[121] * Tv[78];
    Tv[97]:= Tv[130] * Tv[79];
    Tv[98]:= Tv[139] * Tv[80];
    Tv[99]:= Tv[95] * Tv[81];

    //CHART C //20250213
    for i:=43 to 49 do begin Tv[i]:=0;end; //initialize
    Tv[43]:=Tv[15]; Tv[44]:=Tv[43]*0.229/100;   //on
    Tv[45]:=Tv[24]; Tv[46]:=Tv[45]*0.229/100;   //mb
    Tv[47]:=Tv[33]; Tv[48]:=Tv[47]*0.229/100;   //sk
    Tv[49]:=Tv[42]; Tv[50]:=Tv[49]*0.229/100;   //ab
    //??
    for i:= 70 to 77 do Tv[i]:= 0; //initialize
    Tv[70]:= Tv[112];
    Tv[71]:= Tv[70] * 0.229 / 100;   //ns
    Tv[72]:= Tv[121];
    Tv[73]:= Tv[72] * 0.229 / 100;   //pe
    Tv[74]:= Tv[130];
    Tv[75]:= Tv[74] * 0.229 / 100;   //nl
    Tv[76]:= Tv[139];
    Tv[77]:= Tv[76] * 0.229 / 100;   //nb
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<

//jz//20250213 replaced with CZ version
procedure T2043(RetNo: integer; FName: String;FNo: integer);
  Var i:Integer;OverrideSw:Boolean;
Begin
 LoadTv(RetNo,FName,FNo);
 //20220220
 with ret[RetNo].Frm[Fno] do
  begin
    if Strings[3]='' then Strings[3]:='Y';

   if UpperCase(Strings[3])='Y'  then OverrideSw:=True else OverrideSw:=False;

   if OverrideSw=false then
   Begin
    Tv[2]:=TotMultiple(RetNo,'T2043A',6); //ON total all xxExp

   if Tv[2]<25000 then
   Begin
    for I:=2 to 31 do Begin Tv[i]:=0;end;
    SaveTv(RetNo, FName, FNo);
    Exit;
   End;

    if Strings[1]='' then  //20220428
    Begin
     if Ret[RetNo].Province='ON' then Tv[4]:=Tv[2] else Tv[4]:=0;
     if Ret[RetNo].Province='MB' then Tv[6]:=Tv[2] else Tv[6]:=0;
     if Ret[RetNo].Province='SK' then Tv[8]:=Tv[2] else Tv[8]:=0;
     if Ret[RetNo].Province='AB' then Tv[9]:=Tv[2] else Tv[9]:=0;

     if Ret[RetNo].Province='NS' then Tv[30]:=Tv[2] else Tv[30]:=0;
     if Ret[RetNo].Province='PE' then Tv[39]:=Tv[2] else Tv[39]:=0;
     if Ret[RetNo].Province='NL' then Tv[41]:=Tv[2] else Tv[41]:=0;
     if Ret[RetNo].Province='NB' then Tv[43]:=Tv[2] else Tv[43]:=0;

    end;
   end;

   //20240210
   with ret[RetNo].Frm[Fno] do
   begin
     //20250213
     Tv[5]:=(Tv[4] *0.229)/100;
     Tv[7]:=(Tv[6] *0.229)/100;
     Tv[10]:=(Tv[8] *0.229)/100;
     Tv[11]:=(Tv[9] *0.229)/100;
     Tv[31]:=(Tv[30] *0.229)/100;
     Tv[40]:=(Tv[39] *0.229)/100;
     Tv[42]:=(Tv[41] *0.229)/100;
     Tv[44]:=(Tv[43] *0.229)/100;
   end;

   Tv[12]:=Tv[5]+Tv[7]+Tv[10]+Tv[11]
           +Tv[31]+Tv[40]+Tv[42]+Tv[44];

   if OverrideSw=false then
   Begin
    if UpperCase(Strings[1])='X' then  //multiple
    Begin
     //No part 2
      for i:=4 to 12 do Tv[i]:=0;
     //------Part 3 -----------------
     Tv[13]:=TotMultiple(RetNo,'T2043A',7);  //on
     Tv[14]:=TotMultiple(RetNo,'T2043A',16);  //mb
     Tv[15]:=TotMultiple(RetNo,'T2043A',25);  //sk
     Tv[16]:=TotMultiple(RetNo,'T2043A',34);  //AB

     Tv[50]:=TotMultiple(RetNo,'T2043A',104);  //NS
     Tv[51]:=TotMultiple(RetNo,'T2043A',113);  //pe
     Tv[52]:=TotMultiple(RetNo,'T2043A',122);  //nl
     Tv[53]:=TotMultiple(RetNo,'T2043A',131);  //nb

    end;

    if Strings[1]='' then  //20220428
    Begin
     For i:=14 to 22 do begin Tv[i]:=0;end; //no part 3
    end;
   End;  //override

   //Part 3
   if OverrideSw=false then
   Begin
    Tv[17]:=TotMultiple(RetNo,'T2043A',10);  //on
    Tv[18]:=TotMultiple(RetNo,'T2043A',19);  //mb
    Tv[19]:=TotMultiple(RetNo,'T2043A',28);  //sk
    Tv[20]:=TotMultiple(RetNo,'T2043A',37);  //ab

    Tv[54]:=TotMultiple(RetNo,'T2043A',107);  //ns
    Tv[55]:=TotMultiple(RetNo,'T2043A',116);  //pe
    Tv[56]:=TotMultiple(RetNo,'T2043A',125);  //nl
    Tv[57]:=TotMultiple(RetNo,'T2043A',134);  //nb



    Tv[21]:=TotMultiple(RetNo,'T2043A',8);  //any colmn TotGInc
    Tv[22]:=TotMultiple(RetNo,'T2043A',11);  //any column TotSal

    if UpperCase(Strings[1])='X' then  //multiple
    Begin
     Tv[23]:=TotMultiple(RetNo,'T2043A',44);  //on
     Tv[24]:=TotMultiple(RetNo,'T2043A',46);  //mb
     Tv[25]:=TotMultiple(RetNo,'T2043A',48);  //SK
     Tv[26]:=TotMultiple(RetNo,'T2043A',50);  //ab

     Tv[45]:=TotMultiple(RetNo,'T2043A',71);  //on
     Tv[46]:=TotMultiple(RetNo,'T2043A',73);  //mb
     Tv[47]:=TotMultiple(RetNo,'T2043A',75);  //SK
     Tv[48]:=TotMultiple(RetNo,'T2043A',77);  //ab
    end
    Else
    Begin
      For i:=14 to 20 do begin Tv[i]:=0;end; //no part 3 unless multiple
      For i:=50 to 57 do begin Tv[i]:=0;end; //no part 3 unless multiple
    End;
   end;

   Tv[27]:=Tv[23]+Tv[24]+Tv[25]+Tv[26]
           +Tv[45]+tv[46]+Tv[47]+Tv[48];
   Tv[28]:=Tv[12];
   Tv[29]:=Tv[27];

   // box 237 from T5013
   Tv[32]:=TotMultiple(RetNo,'T5013',56);
   Tv[33]:=TotMultiple(RetNo,'T5013',68);
   Tv[34]:=TotMultiple(RetNo,'T5013',69);
   Tv[35]:=TotMultiple(RetNo,'T5013',70);

   Tv[58]:=TotMultiple(RetNo,'T5013',72);  //20240112
   Tv[59]:=TotMultiple(RetNo,'T5013',73);
   Tv[60]:=TotMultiple(RetNo,'T5013',74);
   Tv[61]:=TotMultiple(RetNo,'T5013',75);

   Tv[36]:=Tv[32]+Tv[33]+Tv[34]+Tv[35]
          +Tv[58]+Tv[59]+Tv[60]+Tv[61]; //20240112

   Tv[+37]:=Tv[36];
   Tv[38]:=Tv[28]+Tv[29]+Tv[37];

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;









(* //20220204
//20221215
procedure T2039(RetNo: integer; FName: String;FNo: integer);
  Var i,j:Integer;
Begin
 //20220220
 LoadTv(RetNo,FName,FNo);
 {
 //20230222
 if UpperCase(ret[RetNo].Frm[Fno].strings[102])<>'N/A' then
 Begin
  //ShowMessage('Invalid Password. DataEntery and calculations are disabled');
  Exit;
 End;
 }
 with ret[RetNo].Frm[Fno] do
  begin
   i:=0;
   J:=93;
   Tv[55]:=0;
   Tv[56]:=0;
   Tv[57]:=0;
   repeat
    if Strings[i+1]='' then begin Tv[i+2]:=0;Tv[i+3]:=0;Tv[i+4]:=0;Tv[i+5]:=0;Tv[i+6]:=0;end;
    Tv[i+4]:=MaxR(0,Tv[i+2]-Tv[i+3]); //tv[4]
   // if Tv[i+4]>10000 then Tv[i+4]:=10000;    //20230214
    Tv[i+6]:=MaxR(0,10000-Tv[i+5]);
    If Strings[i+1]='' then Tv[i+6]:=0;
    Tv[j]:=MinR(tv[i+4],Tv[i+6]);
    Tv[55]:=Tv[55]+Tv[i+4];
    Tv[56]:=Tv[56]+Tv[i+5];
    Tv[57]:=Tv[57]+Tv[j];
    Inc(i,6);
    Inc(j,1);
   until i>50;


   //part2
   Tv[58]:= Tv[57];
   //20230214
   Tv[61]:=100;
   If (Tv[69]>0) and (Tv[69]<100.01) then Tv[61]:=Tv[69];


  // Tv[59]:=Tv[56];
   //20221221
  //???? if (Tv[59]=0) and (Tv[61]=0) then Tv[61]:=100;
   if Tv[61]>100 then Tv[61]:=100;
   if Tv[55]+Tv[56]+Tv[57]=0 then Tv[61]:=0;  //20230218

   Tv[62]:=50000 * Tv[61]/100;
   //if Tv[60]=0 then Tv[61]:=0;  //20221221
   Tv[60]:=MinR(Tv[58],Tv[62]);
   //Tv[61] User enters %
   Tv[64]:=Tv[60];
   Tv[65]:=Tv[64]*25/100;

   Tv[91]:=TotMultiple(RetNo,'T5013',54);  //20230128
   Tv[66]:=Tv[91]+Tv[92];      //20230128
   //Tv[63]:=MinR(Tv[60],Tv[62]);
   Tv[67]:=Tv[65]+Tv[66];

   //part 4
   i:=69;
   Tv[90]:=0;
   repeat
    Tv[90]:=Tv[90]+Tv[i];
    Inc(i,2);
   until i>89;

   {
   Tv[64]:=Tv[63];
   Tv[65]:=Tv[64]*25/100;
   //  Tv[66]:=Tv[90];  //user: llocated by [artnership by letter
   Tv[67]:=Tv[65]+Tv[66];
   }
   Ret[RetNo].Lnn[47557]:=Tv[67];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;
*)

procedure T2200S(RetNo: integer; FName: String;FNo: integer);
Begin
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
  begin
   strings[1]:=GetLastName(RetNo);
   Strings[2]:=GetFirstName(RetNo);
   Strings[3]:=AppYear;

   Strings[19]:= GetFirstName(RetNo)+ ' '+GetLastName(RetNo);
   Strings[20]:=GetSinNo(RetNo);
   if Strings[21]='' then Strings[21]:= FormatDateTime('yyyy-mm-dd',Now);
   Strings[22]:=FetchElmFNo(RetNo,InfoFNo,6)+', '+FetchElmFNo(RetNo,InfoFNo,22)
     +' '+FetchElmFNo(RetNo,InfoFNo,10)+' '+FetchElmFNo(RetNo,InfoFNo,14)+' '+FetchElmFNo(RetNo,InfoFNo,15);
  end;
  SaveTv(RetNo,FName,FNo);
end;


(* See Sers unit
procedure UHT(RetNo: integer; FName: String;FNo: integer); //20230610
var s:string;
Begin
 //if FNo=0 then exit; //20230626
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin
   //20230628
   Strings[2]:=Appyear; //'2022';  //20240226
   Strings[3]:=FetchElmFNo(RetNo,InfoFNo,2)+' '+FetchElmFNo(RetNo,InfoFNo,5);
   Strings[4]:=GetSinNo(RetNo);
   if FetchElmFNo(RetNo,InfoFNo,22)>'' then s:='-' else s:='';
   If Strings[5]='' then Strings[5]:=FetchElmFNo(RetNo,InfoFNo,22)+s+FetchElmFNo(RetNo,InfoFNo,6)+' '+FetchElmFNo(RetNo,InfoFNo,68)
      +' '+FetchElmFNo(RetNo,InfoFNo,63)+' '+FetchElmFNo(RetNo,InfoFNo,10);

   If Strings[8]='' then Strings[8]:=FetchElmFNo(RetNo,InfoFNo,15);
   If Strings[9]='' then Strings[9]:=FetchElmFNo(RetNo,InfoFNo,54)+' '+FetchElmFNo(RetNo,InfoFNo,55);
   If Strings[10]='' then Strings[10]:=FetchElmFNo(RetNo,InfoFNo,113);

   if Tv[41]=0  then Tv[41]:=100;
   if Tv[41]>100 then Tv[41]:=100;

   Tv[70]:=MaxR(Tv[68],Tv[69]);


   Strings[107]:=FormatFloat('###',Vl(strings[99])+Vl(Strings[101])
               +Vl(Strings[103])+Vl(Strings[105])
               -Vl(Strings[106])
               );
   if Vl(Strings[107])<0 then Strings[107]:='';

   if Strings[126]>'' then  //fmv
    Tv[130]:=Tv[128]
   Else
    Tv[130]:=Tv[70];

   Tv[131]:=Tv[41];
   Tv[132]:=Tv[130]*Tv[131]/100;
   Tv[133]:=Tv[132];
   Tv[134]:=Tv[133]*1/100;
   Tv[135]:=Tv[134];  //$ enclosed //20240407
   if Strings[138]='' then Strings[138]:=FormatDateTime('yyyy-mm-dd',Now);
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

//20250929 Igor >>>
procedure S6(RetNo: Integer; FName: string; FNo: Integer);
var
  i, SpRetNo: Integer;
  HaveEligibleDependant, HaveEligibleSpouse, ClaimingBasic, ClaimingDisability: Boolean;
  FamNi1, FamNi2, Step2BaseA, Step2RateA, Step2Am1, Step2Am2, Step2Base1,
  Step2Base2, Step2RateB, FamNi, Step3BaseA, Step3RateA, Step3Am1, Step3Base1,
  Step3Base2, Step3Rate1, Step3Rate2: Real;
  // InfoFNo:Integer;
  excludedElmsSet: set of 0..100;
begin
  //all except ab, nu, qc
  Step2BaseA:= 3000; //2025
  Step2RateA:= 27; //2025 //26;
  Step2Am1:= 1633; //2025 //1590; //20241206//1395; //1381; // 1059; //1043;
  Step2Am2:= 2813; //2025 //2739; //2403; //2379; // 1922; //1894;
  Step2Base1:= 26855; //2025 //26149; //22944; //13064; // 12016; //1206; //11838;   //20181201
  Step2Base2:= 30639; //2025 //29833; //28833; //26177; //17348; // 16593; //16348;
  Step2RateB:= 15; //2025 //12; // 15;

  Step3BaseA:= 1150; //2025
  Step3RateA:= 27; //2025 //26; // 25;
  Step3Am1:= 843; //2025 //821; //720; //713; // 529; //521;
  Step3Base1:= 49389; //2025 //48091; //33018; //32244; //20230118
  Step3Base2:= 37740; //2025 //36748; //43210; //20230118
  Step3Rate1:= 7.5; //2025 //6; // 7.5;
  Step3Rate2:= 15; //2025 //12; // 15;

  if Ret[RetNo].Province.Equals('AB') then
  begin
    Step2BaseA:= 2760; //2025
    Step2RateA:= 21; //2025
    Step2Am1:= 1750; //2025 //1704; //1627; //20231221 //20250127
    Step2Am2:= 2619; //2025 //2551; //2436; //20231221 //2292; //2238; //2216; // 1708; //1683; //1684; //1635; //1620; //1545;
    Step2Base1:= 26159; //2025 //25472; //20250204 25442; //24328; //20231221 22886; //22350; //13451; // 12588; //12402; //12230;//11872; //11766; //11221;
    Step2Base2:= 32772; //2025 //31911; //30478; //20231221 28672; //28000; //18291;
    Step2RateB:= 15; //2025 // 14.8;  //20211212

    Step3BaseA:= 910; //2025 // 910;
    Step3RateA:= 26; //2025 // 25;
    Step3Am1:= 843; //2025 //821; //784; //20240205 737; //720; //713; //20211128
    Step3Base1:= 50232; //2025 //48918; //6718; //20231221 43952; //33093; //32317; //25793;
    Step3Base2:= 37826; //2025 //36832; //35175; //20231221 33093; //43952; //42920; //36758;
    Step3Rate1:= 7.5; //2025 //6; // 7.5;
    Step3Rate2:= 15; //2025 //12; // 15;
  end;

  if Ret[RetNo].Province.Equals('NU') then
  begin
    Step2BaseA:= 6000; //2025
    Step2Am1:= 1621; //2025 //1578; //1507; //418;//1385; //1085; // 655; //659; //640; //620; //592;
    Step2Am2:= 2435; //2025 //2371; //2264; //2130; //2080; //1630; // 1330; //1310; //1319; //1280; //1241; //1183;
    Step2Base1:= 26832; //2025 //26127; //24954; //23475; //22925; //21654;
    Step2Base2:= 36927; //2025 //35957; //34342; //32307; //31550; //29551;
    Step2RateA:= 14; //2025 //4;
    Step2RateB:= 8; //2025

    //rates?
    Step3BaseA:= 4800; //2025
    Step3RateA:= 26; //2025 //28; // 25;
    Step3Am1:= 936; //2025 //912; //871; //819; //800; // 713; // 332; //327; //322; //313; //310; //296;
    Step3Base1:= 67365; //2025 //65595; //62645; //58932; //57550; //48779;
    Step3Base2:= 67357; //2025 //65577; //62637; //58925; //57550; //49926;
    Step3Rate1:= 6; //2025 // 7.5;
    Step3Rate2:= 12; //2025 // 15;
  end;

  // CALCULATIONS START HERE
  if (ret[RetNo].MarStatus < 3) and (ret[RetNo].CouplingSw = True) then
    SpRetNo:= GetSpRetNo(RetNo)
  else
    SpRetNo:= 0;

  with ret[RetNo].Frm[FNo] do
  begin
    LoadTv(RetNo, FName, FNo);

    HaveEligibleSpouse:= (Strings[98] > ''); //20250722
    HaveEligibleDependant:= (Strings[100] > ''); //20250722

    //jz//20251211 replace the previous "if not EligibleForWib(RetNo) or not EligibleForWibPerCra(RetNo) then" code with this, easier to read and is shorter, also added elms
    if not EligibleForWib(RetNo) or not EligibleForWibPerCra(RetNo) then
    begin
      excludedElmsSet :=  [
                            1..2,   //jz//code to set eligible dependant removed do do not clear, let users select

                            3..14,  //keep elms 3 to 14 //20190504
                            33..34, //jz//20250110 - is user input when have elig spouse , keep
                            66..67,
                            82..83, //keep elm 83 override  //20191215
                            86      //keep elm 86 userInput - otherwise always deletes everything when opening  //jz//20251211
                          ];  //keep these elms, do not clear them


      //**INITIALIZE / CLEAR FIELD
      for i:= 1 to 100 do   //jz - why (only) to 100??
      begin
        if i in excludedElmsSet then
          continue;

        Tv[i]:= 0;
        Strings[i]:= '';
      end;
    end;

    {
    if not EligibleForWib(RetNo) or not EligibleForWibPerCra(RetNo) then
    begin
      for i:= 1 to 2 do
      begin
        Tv[i]:= 0;
        Strings[i]:= '';
      end; // 20190504
      for i:= 15 to 65 do
      begin
        Tv[i]:= 0;
        Strings[i]:= '';
      end; // 20190504 //keep 3 to 14
      for i:= 68 to 82 do
      begin
        Tv[i]:= 0;
        Strings[i]:= '';
      end; // 20190504 //keep 83 override  /20191215
      for i:= 84 to 100 do
      begin
        Tv[i]:= 0;
        Strings[i]:= '';
      end; // 20190504
      // for i:=68 to 100 do begin Tv[i]:=0;Strings[i]:='';end;   //20190504
      SaveTv(RetNo, FName, FNo);
      exit;
    end;
    }
    // general fed and ontario etc //20111110 //adjusted family net income
    Tv[88]:= 37742; //2025 //36749; //35095; //33016; //32244; //24573; //20230118
    Tv[89]:= 49393; //2025 //48093; //45934; //43212; //42197; //30511;
    Tv[90]:= 43360; //2025 //42222; //40322; //37932; //37044; // 29407; //28576; //27489; //26218; //20160223 Igor
    Tv[91]:= 55009; //2025 // 53565; //51156; //48124; //46997; // 32937; //32002; //30789; //29363; //20160223 Igor
    Tv[92]:= 60629; //2025 //59038; //6378; //53037; //51797; // 36464; //35429; //34089; //32510; //20160223 Igor
    // all provinces
    Tv[93]:= Step2BaseA;
    Tv[94]:= Step3BaseA;

    if Ret[RetNo].Province.Equals('AB') then // 20111110
    begin
      Tv[88]:= 37826; //2025 //36832;//35175; //33093; //32317; //5793; // 19984; //19717; //18966; //18088;
      Tv[89]:= 50232; //2025 //48918; //46718; //42920; //31735; // 22600; //23144; //22268; //21236;
      Tv[90]:= 43446; //2025 //42306; //40402; //37117; //36758; // 36483; //29407; //27905; //26844; //25601;
      Tv[91]:= 55852; //2025 //54392; //51945; //47720; //42700; // 31772; //31335; //30147; //28751;
      Tv[92]:= 61472; //2025 //59865; //57172; //52520;// 48642; // 35245; //34762; //33447; //31898;
    end;
    if Ret[RetNo].Province.Equals('NU') then // 20111110
    begin
      Tv[88]:= 67357; //2025 //65577; //62637; //58925; //57550; //48779; // 38294; //38311; //36892; //35202;
      Tv[89]:= 67365; //2025 //65595; //62645; //58932; //57550; //54721; // 41076; //40506; //38969; //37167;
      Tv[90]:= 75157; //2025 //73177; //69895; //65750; //64217; //49926; // 45124; //44438; //42788; //40800;
      Tv[91]:= 75165; //2025 //73195; //66903; //65757; //64217; //55868; // 47277; //46621; //44852; //42777;
      Tv[92]:= 82965; //2025 //80795; //77162; //70834; //61810; // 49457; //48768; //46919; //44750;
    end;

    if (Strings[66] > '') and (Ret[RetNo].MarStatus > 2) and (Strings[3] + Strings[4] = '') then
    begin
      Strings[3]:= '';
      Strings[4]:= 'X';

      if (FetchElmFNo(RetNo, InfoFNo, 65) >= AppYear + '-11-30') then //20211228
      begin
        Strings[3]:='X';
        Strings[4]:='';
      end;  //
      {Losing the 38104 no indicator upon re-openung. I Tried this code, It did not help
      //20260110 cz
      if Strings[3]>''  then //have elig spouse
      begin
       if Strings[33]+Strings[34]='' then
        strings[34]:='X';
      end;
      }
    end;

    if Strings[66].Equals('') then // not eligible
    begin
      for i:= 1 to 67 do
      begin
        Strings[i]:= '';
        Tv[i]:= 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    Tv[68]:= FamNi1;
    Tv[69]:= FamNi2;
    Tv[70]:= Step2Am1;
    Tv[71]:= Step2Am2;
    Tv[72]:= Step2Base1;
    Tv[73]:= Step2Base2;
    Tv[74]:= FamNi1;
    Tv[76]:= FamNi2;
    Tv[77]:= Step3Am1;
    Tv[78]:= Step3Base1;
    Tv[79]:= Step3Base2;
    Tv[80]:= Step3Rate1;
    Tv[81]:= Step3Rate2;
    Strings[82]:= '5000-S6';

    if Ret[RetNo].Province.Equals('AB') then Strings[82]:= '5009-S6';
    // If ret[RetNo].Province='BC' then Strings[82]:='5010-S6';   ???
    If ret[RetNo].Province.Equals('NU') then Strings[82]:= '5014-S6';
    If ret[RetNo].Province.Equals('QC') then Strings[82]:= '5005-S6';

    {
    //20260412   //no good : removed it was temp
    if HasEligibleDependantForWIB(RetNo) then
    begin
        Strings[1]:= 'X';
        Strings[2]:= '';
    end
    else
    begin
        Strings[1]:= '';
        Strings[2]:= 'X';
    end;
   }

    //20260420


   //20260420
    {
    if Strings[83].Equals('') then // no override
    begin
      if HasEligibleDependantForWIB(RetNo) then
      begin
        Strings[1]:= 'X';
        Strings[2]:= '';
      end
      else
      begin
        Strings[1]:= '';
        Strings[2]:= 'X';
      end;
    end;

    else
    begin
      Strings[1]:= 'X';
      Strings[2]:= '';
    end;
    }

    if (Ret[RetNo].MarStatus > 2) then
    begin
      Strings[3]:= '';
      Strings[4]:= 'X';

      if (FetchElmFNo(RetNo, InfoFNo, 65) >= AppYear + '-11-30') then //20211228
      begin
        Strings[3]:= 'X';
        Strings[4]:= '';
      end;
    end;

    HaveEligibleSpouse:= (Strings[3] > '');
    HaveEligibleDependant:= (Strings[1] > '');

    if (Strings[31] + Strings[32] = '') then
    begin
      if (Ret[RetNo].Lnn[31600] > 0) then
        Strings[31]:= 'X';
    end;

    if (Vl(FetchElm(RetNo, 'S2', 5)) > 0) then
    begin
      Strings[33]:= 'X';
      Strings[34]:= '';
    end else
    begin
      if (Strings[3] > '') then // if elig spouse
      begin
        //Strings[33]:= '';  //jz//20251231 - if the spouse is eligible why is it auto set to no? remove for now
        //Strings[34]:= 'X';
      end else
      begin
        Strings[33]:= '';
        Strings[34]:= '';
      end;
    end;

    if Strings[3].Equals('') then Strings[84]:= '';

    ClaimingBasic:= (Strings[29] > '');
    ClaimingDisability:= (Strings[31] > '');
    Tv[5]:= Ret[RetNo].Lnn[10100] + Ret[RetNo].Lnn[10400];
    Tv[9]:= GetSelfEmplForWib(RetNo);
    Tv[7]:= TotMultiple(RetNo, 'T4A', 47); // txbl scholarship
    //Tv[11] :=MaxR(0,Vl(FetchElm(RetNo, 'T90', 1))-Vl(FetchElm(RetNo, 'T90', 17))); //20210101 removed causes more niscalcs
    Tv[11]:= Vl(FetchElm(RetNo, 'T90', 4));

    if (Ret[retno].Lnn[10105] > 0) then Tv[11]:= Ret[retno].Lnn[10105] ; //20230113 //Vl(FetchElm(RetNo, 'T90', 1))+Vl(FetchElm(RetNo, 'T90', 17)); //20200102 out again on 20210106  //see .../data
    if not UpperCase(Strings[76]).Equals('Y') then Tv[18]:= vl(FetchElm(RetNo, 'T90', 16));  //Tv[11]+TotMultiple(RetNo, 'T4E',14); // 20100212
    if (Ret[retno].Lnn[10105] > 0) then Tv[18]:= Ret[retno].Lnn[10105];

    Tv[13]:= Tv[5] + Tv[7] + Tv[9] + Tv[11];

    // coupling on
    if (Ret[RetNo].MarStatus < 3) and (Ret[RetNo].CouplingSw = True) then
    begin
      SpRetNo:= GetSpRetNo(RetNo);

      if (SpRetNo > 0) then
      begin
        Tv[6]:= Ret[SpRetNo].Lnn[10100] + Ret[SpRetNo].Lnn[10400];
        Tv[8]:= TotMultiple(SpRetNo, 'T4A', 47); // scholarship
        Tv[10]:= GetSelfEmplForWib(SpRetNo);
        Tv[12]:= TotMultiple(SpRetNo, 'T4', 11);
        // +TotMultiple(SpRetNo,'T4',47);//20191218  //St indian reserve or emerg volunteer
      end;
    end;
    // end of coupling

    if not UpperCase(Strings[3]).Equals('X') then
    begin
      Tv[6]:= 0;
      Tv[8]:= 0;
      Tv[10]:= 0;
      Tv[12]:= 0; // remove sp amounts
    end;

    Tv[14]:= Tv[6] + Tv[8] + Tv[10] + Tv[12];
    Tv[15]:= Tv[13] + Tv[14];

    //Tv[151]:= CalcMortgageForeclosure(ret[RetNo].Lnn[12700], Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 122)), Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 72)));
    //jz//20260215 - fields from s3 have changed, note, wanted to use lnn but seems they dont exist for s3
    Tv[151]:= CalcMortgageForeclosure(ret[RetNo].Lnn[12700], Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 195)), Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 264))); //jz//20260215 - fields from s3 have changed

    Tv[152]:= Vl(FetchElm(RetNo, 'FORECLO', 4));

    //jz//20252021 needs selectNetIncomeAmount somewhere here
    Tv[16]:= MaxR(0, SelectNetIncomeAmount(retno) - Tv[151]); //20250222 //MaxR(0, ret[RetNo].Lnn[23600] - Tv[151]);

    if TosiInEffect(RetNo) then
      Tv[16]:= MaxR(0, GetTosiNetIncome(RetNo) - Tv[151]);

    Tv[20]:= Ret[RetNo].Lnn[21300] + Vl(FetchElm(RetNo, 'OTHDED', 60));
    Tv[22]:= Tv[16] + Tv[18] + Tv[20];
    Tv[24]:= Ret[RetNo].Lnn[11700] + Ret[RetNo].Lnn[12500];
    Tv[26]:= MaxR(0, Tv[22] - Tv[24]);
    Tv[19]:= Tv[12];

    if (Ret[RetNo].MarStatus < 3) and (Ret[RetNo].CouplingSw = True) then
      Tv[19]:= Tv[12] + TotMultiple(SpRetNo, 'T4E', 14); // 20100301

    Tv[21]:= Vl(FetchElm(RetNo, 'INFO', 162)) + Vl(FetchElm(RetNo, 'S2', 34));

    Tv[17]:= MaxR(0, SpouseIncome(RetNo) - Tv[152]); //jz//20260114 - SpouseIncome gets from s2 and accounts for Tosi
      //Tv[17]:= MaxR(0, Vl(FetchElm(RetNo, 'INFO', 19)) - Tv[152]);
      // if TosiInEffect(RetNo) then Tv[17]:=MaxR(0,GetSpouseTosiNetIncome(RetNo,InfoFNo)-Tv[152]); //-Vl(FetchElm(RetNo,'INFO',131))); //20190222
      //if (Vl(FetchElm(RetNo, 'INFO', 29)) > 0) then Tv[17]:= GetSpouseTosiNetIncome(RetNo, InfoFNo); // 20181227

    Tv[23]:= Tv[17] + Tv[19] + Tv[21];
    Tv[25]:= Vl(FetchElm(RetNo, 'INFO', 131)) + Vl(FetchElm(RetNo, 'S2', 33));

    if not UpperCase(Strings[3]).Equals('X') then // no elig spouse
    begin
      Tv[17]:= 0;
      Tv[19]:= 0;
      Tv[21]:= 0;
      Tv[23]:= 0;
      Tv[25]:= 0; // remove sp amounts
    end;

    Tv[27]:= MaxR(0, Tv[23] - Tv[25]);
    //20211114
    Tv[74]:= Tv[26] + Tv[27];

    //20211211
    if (Tv[13] < Tv[14]) then
      Tv[75]:= MinR(Tv[13], Tv[26])
    else
      Tv[75]:= MinR(Tv[14], Tv[27]);

    if (Tv[75] > 16386) then Tv[75]:= 16386;  //20250929 Igor

    Tv[28]:=MaxR(0, Tv[74] - Tv[75]);  //20211127

    if (Strings[29] + Strings[30] = '') then Strings[29]:= 'X';

    if (Ret[RetNo].Lnn[31600] > 0) then // disabled
    begin
      Strings[31]:= 'X';
      Strings[32]:= '';
    end else
    begin
      Strings[31]:= '';
      Strings[32]:= 'X';
    end;

    // Step 2
    if ClaimingBasic then
    begin
      Tv[35]:= Tv[15];
      Tv[36]:= Step2BaseA;
      Tv[37]:= MaxR(0, Tv[35] - Tv[36]);
      Tv[38]:= Step2RateA;

      if Ret[RetNo].Province.Equals('NU') then // 20140913
      begin
        if not HaveEligibleSpouse and not HaveEligibleDependant then Tv[38]:= 10; // 5;  //20171203
        if HaveEligibleSpouse or HaveEligibleDependant then Tv[38]:= 14; // 10;   //20171203
      end;

      Tv[39]:= Tv[37] * Tv[38] / 100;
      Tv[40]:= Step2Am1;

      if HaveEligibleSpouse or HaveEligibleDependant then Tv[40]:= Step2Am2;
     // If (ret[RetNo].MarStatus > 2) and (HaveEligibleDependant = false) then Tv[40] := Step2Am1; //20250722
      xx:= Tv[40];   //20250721
      Tv[41]:= MinR(Tv[39], Tv[40]);
      Tv[42]:= Tv[41];
      Tv[43]:= Tv[28];
      Tv[44]:= Step2Base1;

      if HaveEligibleSpouse or HaveEligibleDependant then Tv[44]:= Step2Base2;
     // If (ret[RetNo].MarStatus > 2) and (HaveEligibleDependant = false) then Tv[44] := Step2Base1; //20250722
      Tv[45]:= MaxR(0, Tv[43] - Tv[44]);
      Tv[46]:= Step2RateB;

      if Ret[RetNo].Province.Equals('NU') then // 20140913
      begin
        Tv[46]:= 4; // 20171203

        if (HaveEligibleSpouse) or (HaveEligibleDependant) then
          Tv[46]:= 8; // 20171203
      end;

      Tv[47]:= Tv[45] * Tv[46] / 100;
      Tv[48]:= Tv[47];
      Tv[49]:= MaxR(0, Tv[42] - Tv[48]);
    end else
      for i:= 35 to 49 do Tv[i]:= 0;

    // Step 3
    if (ClaimingDisability) then
    begin
      Tv[50]:= Tv[13];
      Tv[51]:= Step3BaseA;
      Tv[52]:= MaxR(0, Tv[50] - Tv[51]);
      Tv[53]:= Step3RateA;
      Tv[54]:= Tv[52] * Tv[53] / 100;
      Tv[55]:= MinR(Step3Am1, Tv[54]);
      Tv[56]:= Tv[55];
      Tv[57]:= Tv[28];
     // Tv[58]:= Step3Base1; //20251130

      //20230120
     // Tv[58]:= Step3Base1;  //20250722
      //If (ret[RetNo].MarStatus > 2) and (HaveEligibleDependant = false) then Tv[58] := Step3Base2; //20250722
      if HaveEligibleSpouse or HaveEligibleDependant then //20251130
        Tv[58]:= Step3Base1 //20250722
      else
        Tv[58]:= Step3Base2; //20251130

      Tv[59]:= MaxR(0, Tv[57] - Tv[58]);
      Tv[60]:= Step3Rate2;

      if (HaveEligibleSpouse) and (Vl(FetchElm(RetNo, 'S2', 5)) > 0) then // spouse disability //(Strings[84]>'')
        Tv[60]:= Step3Rate1;

      Tv[61]:= Tv[59] * Tv[60] / 100;
      Tv[62]:= Tv[61];
      Tv[63]:= MaxR(0, Tv[56] - Tv[62]);
    end else
    begin
      for i:= 50 to 63 do
        Tv[i]:= 0;
    end;

    Tv[64]:= Tv[49];
    Tv[65]:= Tv[63] + Tv[64];

    //awcb
    Tv[84]:= MaxR(Tv[49], Tv[65]);   //20231126
    Tv[85]:= TotMultiple(RetNo, 'RC210', 1);
    //Tv[86]:= spouses box 10?
    Tv[87]:= Tv[85] + Tv[86];

    if not ClaimingBasic then //jz//20250307 - if you are not claiming, zero out 44 and 47 as per form instructions
    begin
      Tv[85]:= 0;
      Tv[87]:= 0;
    end;

    Tv[95]:= TotMultiple(RetNo,'RC210', 4); //20240107
    Tv[96]:= Tv[87] + Tv[95];
    Tv[97]:= MinR(Tv[84], Tv[96]);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250929 Igor <<<

end.
