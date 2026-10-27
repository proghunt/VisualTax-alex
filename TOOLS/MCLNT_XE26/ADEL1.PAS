Function GetCorpName (RetNo:Integer):String;
{Returns Corp Name from PAGE_1}
Begin
Result := FetchElm (RetNo, 'PAGE_1', 3);
end;

Function GetAccountNumber (RetNo:Integer):String;
{Returns Account Number from PAGE_1 if exists otherwise Business Number}
Begin
Result := FetchElm (RetNo, 'PAGE_1', 4);
if Result = '' then Result := FetchElm (RetNo, 'PAGE_1', 5);
end;

Function GetTaxationYear (RetNo:Integer):String;
{Returns Taxation Year as Input in PAGE_1}
Begin
Result := FetchElm (RetNo, 'PAGE_1', 11);
end;

Function GetNumDays (Date_1:String;Date_2:String):Integer;
{Returns signed number of days between date_1 and date_2}
Begin
End;

Procedure PAGE_3 (RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo]^.Frm[FNo] do
  begin
	Strings[1] := GetCorpName (RetNo);
	Strings[2] := GetAccountNumber (RetNo);
 	Strings[5] := GetTaxationYear (RetNo);
 {Section: Taxable income and base amount of Part I tax}
 	Tv[20] := Vl (FetchElm (RetNo, 'S1', 68)); {?}
 	Tv[22] := MinR ( Tv[21], (.20 * Tv[20]));
 	Tv[25] := Vl (FetchElm (RetNo, 'PAGE_8', 4)); {?}
 	Tv[26] := Tv[25] * (9/4);
 	Tv[27] := Vl (FetchElm (RetNo, 'S4_2', 21));
 	Tv[28] := Vl (FetchElm (RetNo, 'S4_2', 18))
 		  + Vl (FetchElm (RetNo, 'S4_2', 30));
 	Tv[29] := Vl (FetchElm (RetNo, 'S4_2', 19));
 	Tv[30] := Vl (FetchElm (RetNo, 'S4_2', 20));
 	Tv[31] := 0;	{initialize if we need to}
 	for i := 22 to 30 do
 	if i != 25 then Tv[31] := Tv[31] + Tv[i];{skip item 25}

 	Tv[32] := MaxR (0, (Tv[20] - Tv[31])); {-ve taxable income not allowed?}
 	Ret[RetNo]^.Ln[111] := Tv[20];
 	Ret[RetNo]^.Ln[113] := Tv[21];
 	Ret[RetNo]^.Ln[115] := Tv[22];
 	Ret[RetNo]^.Ln[117] := Tv[23];
 	Ret[RetNo]^.Ln[119] := Tv[24];
 	Ret[RetNo]^.Ln[120] := Tv[26];
 	Ret[RetNo]^.Ln[121] := Tv[27];
 	Ret[RetNo]^.Ln[123] := Tv[28];
 	Ret[RetNo]^.Ln[125] := Tv[29];
 	Ret[RetNo]^.Ln[126] := Tv[30];
 	Ret[RetNo]^.Ln[127] := Tv[32];
 	Tv[33] := Tv[32];
 	Tv[34] := Vl (FetchElm (RetNo, 'S28', 3));
 	Tv[35] := Tv[33] + Tv[34];
 	Tv[36] := .38 * Tv[35];
 	Ret[RetNo]^.Ln[202] := Tv[36];
 {Section: Small business deductions}
 	{CorpType is a global var of type enum. Value input on PAGE_1}
  if CorpType = CanadianControlledPrivate then
  {adjust value according to definition of enum CorpType ?}
   begin
   	Tv[37] := Vl (FetchElm (RetNo, 'S7_2', 39)); {?}
   	Tv[38] := Tv[32] - ((10/3) * (Vl (FetchElm (RetNo, 'PAGE_6', 40))))
   		  - {?};
   	{Many questions. Cannot complete section ????}
   	Tv[44]:= GetSmlBizDeduction;
   	Ret[RetNo]^.Ln[231]:= Tv[44];
   	else	{ Corp is NOT CanadianControlledPrivate }
   	for i := 37 to 43 do
   		Tv[i] := 0;
   	end;
   end;
   SaveTv (RetNo, Fname, FNo);
end;

Procedure PAGE_4 (RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
LoadTv (RetNo, Fname, FNo);
{This page is not applicable since package supports taxation years ending in 1996 ?}
for i:= 1 to 51 do
	Tv[i] := 0;
SaveTv (RetNo, Fname, FNo);
end;

Procedure PAGE_5 (RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
Var i36:Integer;
begin
	LoadTv (RetNo, Fname, FNo);
	with Ret[RetNo]^.Frm[FNo] do
   begin
	Strings[1] := GetCorpName (RetNo);
	Strings[2] := GetAccountNumber (RetNo);
	Strings[3] := GetTaxationYear (RetNo);
	{section: Manufacturing and processing profits tax year after Jun 30, 1995}
	Tv[4] := Vl (FetchElm (RetNo, 'S27_2', 4));
	Ret[RetNo]^.Ln[233] := Tv[4];
	Tv[5] := GetBizLimit (RetNo); {? Do not know how to determine if Biz limit applies. Form T2013 not found}
	Tv[6] := MaxR (0, (Tv[4] - Tv[5]));
	Tv[7] := Tv[6];
	Tv[8] := Vl (FetchElm (RetNo, 'PAGE_3', 32));
	Tv[9] := Tv[5];
	Tv[10]:= 0;
	if CorpType = CanadianControlledPrivate then
  	Tv[10] := Vl (FetchElm (RetNo, 'S7_1', 48));
  	Tv[11]:= Ret[RetNo]^.Ln[213];
  	Tv[12]:= Tv[11] * (10/4);
  	Tv[13]:= Tv[9] + Tv[10] + Tv[12];
  	Tv[14]:= Tv[8] - Tv[13];
  	Ret[RetNo]^.Ln[235] := Tv[14];
  	Tv[15]:= .07 * (MinR (Tv[7], Tv[14]));
  	Ret[RetNo]^.Ln[243] := Tv[15];

  	{section: Refundable portion of Part I tax}
  	if CorpType = CanadianControlledPrivate then
  	Begin
  		Tv[16]:= Tv[10];
  		Ret[RetNo]^.Ln[247] := Tv[16];
  		Tv[17]:= Tv[16] * (80/3);
  		Tv[18]:= Ret[RetNo]^.Ln[211];
  		Tv[19]:= Vl (FetchElm (RetNo, 'S7_1', 47));
  		Ret[RetNo]^.Ln[249] := Tv[19];
  		Tv[20]:= Tv[19] * (28/3);
  		Tv[21]:= MaxR (0, (Tv[18] - Tv[20]));
  		Tv[22]:= Tv[21];
  		Tv[23]:= MaxR (0, (Tv[17] - Tv[22]));
  		Tv[24]:= Tv[8];
  		Tv[25]:= Tv[5];
  		Tv[26]:= Tv[18]; {ie line 211}
  		Tv[27]:= Tv[26] * (25/9);
  		Tv[28]:= Tv[11]; {ie line 213}
  		Tv[29]:= Tv[28] * (10/4);
  		Tv[30]:= Tv[25] + Tv[27] + Tv[29];
  		Tv[31]:= Tv[30];
  		Tv[32]:= Tv[24] - Tv[31];
  		Tv[33]:= Tv[31] * (80/3);
  		Tv[34]:= MinR( Tv[23], Tv[33]);
  		Tv[35]:= Tv[34];
  		i36:= GetNumDays (ToDate('1-7-1995'), {? Need a function}
  			ToDate(FetchElm (RetNo, 'PAGE_1', 8)));
  		if i36 < 0 then i36 := 0; {GetNumDays returns signed value}
  		Strings[36]:= IntToStr (i36);	{?}
  		Strings[38]:= IntToStr(DaysInYear);
  		Tv[37]:= Tv[35] * (i36/DaysInYear) * .25;
  		Tv[39]:= Tv[34] - Tv[37];
  		Tv[40]:= Vl(FetchElm (RetNo, 'PAGE_6', 49);
  		Tv[41]:= Ret[RetNo]^.Ln[209]; {In page 6}
  		Tv[42]:= Tv[40] - Tv[41];
  		Tv[43]:= Tv[42];
  		Tv[44]:= MinR ( Tv[34], Tv[43]);
  		if Tv[36] != 0 then
  			Tv[44]:= MinR ( Tv[44], Tv[39]);
  		end;
  		Ret[RetNo]^.Ln[261] := Tv[44];
		end;
  	SaveTv (RetNo, Fname, Fno);
end;

Procedure PAGE_6 (RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
Var i13:Integer;
begin
  LoadTv (RetNo, Fname, FNo);
  with Ret[RetNo]^.Frm[FNo] do
   begin
	Tv[32]:= Ret[RetNo]^.Ln[231];
	Tv[33]:= {?}
	Tv[34]:= {?}
	Ret[RetNo]^.Ln[205]:= Tv[34];
	Tv[35]:= {?}
	Ret[RetNo]^.Ln[206]:= Tv[35];
	Tv[37]:= {?}
	Ret[RetNo]^.Ln[207:= Tv[37];
	Tv[38]:= Ret[RetNo]^.Ln[243];
		Tv[39]:= Vl (FetchElm (RetNo, 'S21_1', 27));
	Ret[RetNo]^.Ln[211]:= Tv[39];
		Tv[40]:= Vl (FetchElm (RetNo, 'S21_1', 49));
	Ret[RetNo]^.Ln[213]:= Tv[40];
	Tv[41]:= Vl (FetchElm (RetNo, 'S21_1', 62)); {?}
	Ret[RetNo]^.Ln[215]:= Tv[41];
	Tv[42]:= {?}
	Ret[RetNo]^.Ln[217]:= Tv[42];
	Tv[43]:= {?}
	Ret[RetNo]^.Ln[219]:= Tv[43];
	Tv[44]:= Ret[RetNo]^.Ln[458]; {?}
	Ret[RetNo]^.Ln[221]:= Tv[44];
	Tv[45]:= {? T921 not found}
	Ret[RetNo]^.Ln[224]:= Tv[45];
	Tv[46]:= {? T962 not found}
	Ret[RetNo]^.Ln[226]:= Tv[46];
	Tv[47]:= 0;
	for i:= 32 to 46 do
		if (i != 34 AND i != 43) then Tv[47]:= Tv[47] + Tv[i];

	Tv[48]:= Tv[47];

		Tv[1]:= Ret[RetNo]^.Ln[202];
		Tv[2]:= Tv[1];
		Tv[3]:= Ret[RetNo]^.Ln[127] * .10;
		Tv[4]:= Tv[33]; {ie line 203}
		Tv[5]:= Tv[41]; {ie line 215}

		if CorpIsMutualFund then
		{? CorpIsMutualFund is a function which returns boolean}
		Begin
		Tv[6]:= .28 * Ret[RetNo]^.Ln[127];
		Tv[7]:= .28 * {? taxable capital gain}
		Tv[9]:= Tv[1] - Tv[48];
		Tv[8]:= MinR (Tv[9], (MinR (Tv[6], Tv[7]);
		end;		{Assume values 6 through 8 initialized to zero ?}

		Tv[10]:= Tv[3] + Tv[4] + Tv[5] + Tv[8];
		Tv[11]:= Tv[2] - Tv[10];
		Tv[12]:= Tv[11];
		Tv[16]:= Tv[11];

		i13:= GetNumDays (ToDate('28-2-1995'), {? Need a function}
		ToDate(FetchElm (RetNo, 'PAGE_1', 8)));
		if i13 < 0 then i13 := 0; {GetNumDays returns signed value}
		Strings[13]:= IntToStr (i13);	{?}
		Strings[15]:= IntToStr(DaysInYear);
		Tv[14]:= Tv[12] * (i13/DaysInYear) * .03;

		i13:= GetNumDays (ToDate(FetchElm (RetNo, 'PAGE_1', 11)),
					ToDate('27-2-1995));
		if i13 < 0 then i13 := 0; {GetNumDays returns signed value}
		Strings[17]:= IntToStr (i13);	{?}
		Strings[19]:= IntToStr(DaysInYear);
		Tv[18]:= Tv[16] * (i13/DaysInYear) * .04;

		Tv[20]:= Tv[14] + Tv[18];
		Ret[RetNo]^.Ln[209]:= Tv[20];

		Tv[21]:= Ret[RetNo]^.Ln[247];
		Tv[22]:= Ret[RetNo]^.Ln[127];
		Tv[23]:= GetBizLimit;
		Tv[24]:= Tv[22] - Tv[23];
		Tv[25]:= Tv[24];
		Tv[26]:= MinR (Tv[21], Tv[25]);

		i13:= GetNumDays (ToDate(FetchElm (RetNo, 'PAGE_1', 11)),
					ToDate('30-6-1995));
		if i13 < 0 then i13 := 0; {GetNumDays returns signed value}
		Strings[27]:= IntToStr (i13);	{?}
		Strings[29]:= IntToStr(DaysInYear);
		Tv[28]:= Tv[26] * (i13/DaysInYear);
		Tv[30]:= Tv[28] * (20/3);
		Ret[RetNo]^.Ln[212]:= Tv[30];
		Tv[31]:= Tv[1] + Tv[20] + Tv[30];

		Tv[49]:= Tv[31] - Tv[48];
	end;
SaveTv (RetNo, Fname, Fno);
end;

Procedure PAGE_7 (RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
Var i36:Integer;
begin
	LoadTv (RetNo, Fname, FNo);
	with Ret[RetNo]^.Frm[FNo] do
   begin
	Strings[1] := GetCorpName (RetNo);
	Strings[2] := GetAccountNumber (RetNo);
		Strings[3] := GetTaxationYear (RetNo);
{section: Part IV on taxable dividends received}
		Tv[4]:= Vl (FetchElm (RetNo, 'S3_1', 131);
		Ret[RetNo]^.Ln[404]:= Tv[4];
		Tv[5]:= Vl (FetchElm (RetNo, 'S4_2', 18))
			+ Vl (FetchElm (RetNo, 'S4_2', 20)); {?}
		Ret[RetNo]^.Ln[406]:= Tv[5];
		Tv[6]:= MaxR (0, (Tv[4] - Tv[5]));
		Tv[7]:= Tv[6];
		Tv[8]:= Tv[7] * (1/3);
		Tv[9]:= {?}
		Ret[RetNo]^.Ln[419]:= Tv[9];
		Tv[10]:= MaxR (0, (Tv[8] - Tv[9]));
		Tv[11]:= Vl (FetchElm (RetNo, 'S3_1', 130);
		Ret[RetNo]^.Ln[405]:= Tv[11];
		Tv[12]:= Tv[5]; {? Form not clear}
		Tv[13]:= MaxR (0, (Tv[11] - Tv[12]));
		Tv[14:= Tv[13];
		Tv[15]:= Tv[14] * .25;
		Tv[16]:= {?}
		Ret[RetNo]^.Ln[418]:= Tv[16];
		Tv[17]:= MaxR (0, (Tv[15] - Tv[16]));
		Tv[18]:= Tv[10] + Tv[17];

	{section: Refundable dividend tax on hand}
		Tv[19]:= {?}
		Tv[20]:= {?}
		Tv[21]:= MaxR (0, (Tv[19] - Tv[20]));{?}
		Tv[22]:= Tv[21];
		Tv[23]:= Ret[RetNo]^.Ln[261];
		Tv[24]:= Tv[18];
		Tv[25]:= {?}
		Ret[RetNo]^.Ln[465]:= Tv[25];
		Tv[26]:= Tv[23] + Tv[24] + Tv[25];
		Tv[27]:= Tv[26];
		Tv[28]:= Tv[22] + Tv[27];
		Ret[RetNo]^.Ln[411]:= Tv[28];

	{section: Dividend refund}
		{? what is private and subject corp?}
		Tv[29]:= Vl (FetchElm (RetNo, 'S3_2', 15));
		Ret[RetNo]^.Ln[424]:= Tv[29];
		Tv[30]:= Tv[29] * (1/3);
		Tv[31]:= Vl (FetchElm (RetNo, 'S3_2', 14));
		Ret[RetNo]^.Ln[414]:= Tv[31];
		Tv[32]:= Tv[31] * .25;
		Tv[33]:= Tv[30] + Tv[32];
		Tv[34]:= Tv[28];
		Tv[35]:= MinR (Tv[33], Tv[34]);
	end;
SaveTv (RetNo, Fname, Fno);
end;

Procedure PAGE_8 (RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
Var i36:Integer;
begin
	LoadTv (RetNo, Fname, FNo);
	with Ret[RetNo]^.Frm[FNo] do
   begin
		Tv[1]:= Vl (FetchElm (RetNo, 'PAGE_6', 49));
		Ret[RetNo]^.Ln[129]:= Tv[1];
		Tv[2]:= {?}
		Ret[RetNo]^.Ln[130]:= Tv[2];
		Tv[3]:= Vl (FetchElm (RetNo, 'PAGE_7', 18));
		Ret[RetNo]^.Ln[131]:= Tv[3];
		Tv[4]:= {?}
		Ret[RetNo]^.Ln[132]:= Tv[4];
		Tv[5]:= {?}
		Ret[RetNo]^.Ln[134]:= Tv[5];
		Tv[6]:= {?}
		Ret[RetNo]^.Ln[133]:= Tv[6];
		Tv[7]:= {?}
		Ret[RetNo]^.Ln[135]:= Tv[7];
		Tv[8]:= 0;
		for i:= 1 to 7 do
			Tv[8]:= Tv[8] + Tv[i];
		
		Tv[10]:= {?}
		Ret[RetNo]^.Ln[139]:= Tv[10];
		Tv[11]:= {?}
		Ret[RetNo]^.Ln[141]:= Tv[11];
		Tv[12]:= Tv[10] - Tv[11];
		Tv[13]:= Tv[8] + Tv[12];
		Ret[RetNo]^.Ln[143]:= Tv[13];
		
		Tv[15]:= {?}
		Ret[RetNo]^.Ln[145]:= Tv[15];
		{? for 16 two values are candidate depending on certain qualifications}
		Tv[16]:= Vl (FetchElm (RetNo, 'Tv[2038_3', 10)); {? or a lesser amount}
		Ret[RetNo]^.Ln[146]:= Tv[16];
		Tv[17]:= Vl (FetchElm (RetNo, 'PAGE_7', 35));
		Ret[RetNo]^.Ln[147]:= Tv[17];
		Tv[18]:= {?}
		Ret[RetNo]^.Ln[149]:= Tv[18];
		Tv[19]:= {?}
		Ret[RetNo]^.Ln[151]:= Tv[19];
		Tv[20]:= {?}
		Ret[RetNo]^.Ln[152]:= Tv[20];
		Tv[21]:= {?}
		Ret[RetNo]^.Ln[153]:= Tv[21];
		Tv[22]:= {?}
		Ret[RetNo]^.Ln[154]:= Tv[22];
		Tv[23]:= {?}
		Ret[RetNo]^.Ln[155]:= Tv[23];
		Tv[24]:= {?}
		Ret[RetNo]^.Ln[156]:= Tv[24];
		Tv[25]:= {?}
		Ret[RetNo]^.Ln[157]:= Tv[25];
		Tv[26]:= {?}
		Ret[RetNo]^.Ln[158]:= Tv[26];
		Tv[27]:= 0;
		for i:= 15 to 26 do
			Tv[27]:= Tv[27] + Tv[i];
		Tv[28]:= Tv[27];
		Tv[29]:= Tv[13] - Tv[28];
		
		if Tv[29] >= 0 then
		begin
		Tv[30]:= Tv[29];
		Tv[32]:= 0;
		Tv[35]:= 0;
		else
		Tv[30]:= 0;
		Tv[32]:= - Tv[29];
		Tv[35]:= Tv[32];
		end;
		Ret[RetNo]^.Ln[165]:= Tv[30];
		Ret[RetNo]^.Ln[163]:= Tv[32];
		Ret[RetNo]^.Ln[159]:= Tv[35];
	end;
SaveTv (RetNo, Fname, Fno);
end;

