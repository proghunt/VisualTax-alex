unit FP_2027CalcT1Import;

interface
Uses
 SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,ExtCtrls,fSelectDir,Grids,DB,DBGrids; //, ADODB;

    procedure ImportT1(RetNo: integer; FromDataDir:String;FlName:String);
    Procedure ImportT1Values(RetNo:Integer;FromDataDir:String;FlName:String;FormsNeeded:TstringList;Whom:Integer);
   // procedure FromDataDirBoxExit(Sender: TObject);
   // procedure FlNameBoxChange(Sender: TObject);
    procedure ImportToPlanner(RetNo:Integer);
    procedure ImportToPl1(RetNo:Integer;FNo:Integer);
    procedure ImportToPl2(RetNo:Integer;FNo:Integer);
    procedure ReformatSomeT1Data(RetNo:Integer);
    Procedure CaptureSpecificT1Data(RetNo:integer;FromFrmName:string;
          FromElmNo:Integer;Valu:String;Whom:integer);
    Procedure TransferT1ElmData(RetNo,ToFrmNo,ToElmNo:Integer;Valu:String);
   // procedure FormClose(Sender: TObject; var Action: TCloseAction);
   // procedure FormPaint(Sender: TObject);
   // procedure FromDataDirBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
   // procedure SelectCurBtnClick(Sender: TObject);
   // procedure FromDataDirBoxKeyPress(Sender: TObject; var Key: Char);

 Var
   //RetNo:Integer; //20150228
   SpouseSin:String;
   RRSPEarned:Real;SpRrspEarned:Real;
   RRSPUnusedRoom,SpRRSPUnusedRoom:Real;
   RRSPPA,SpRRSPPA:Real;
   RRSpDedLimit,SpRRSPDedLimit:Real;
   //CfRrspRoom,SpCfRrspRoom:Real;

implementation
uses
  vtCommon,FP_2027,FP_2027Declare,FP_2027ChildWinNew,FP_2027TrimStr,
  FP_2027Calc,FP_2027Common2,vtTrimStr,vtShared, vtFileStorage,
  vtMulti; //20170313 Igor

procedure ImportT1(RetNo: integer; FromDataDir:String;FlName:String);
Var  FNo :integer;FormsNeeded : TStringList; X:real;
begin
     //RetNo:=GetCurrentRetNo;  //20150228

     RRSPEarned:=0;
     SpRRSPEarned:=0;
     FormsNeeded := TstringList.Create;    //T1 forms
     FormsNeeded.Add('T1');   //20110510
  // FormsNeeded.Add('PAGE_4');
     FormsNeeded.Add('DEPEND');
     FormsNeeded.Add('TXSUM_1');
     FormsNeeded.Add('TXSUM_2');
     FormsNeeded.Add('RRSP');
     FormsNeeded.Add('RRSPNXT');
     FormsNeeded.Add('S7');
     Screen.Cursor := crHourGlass;

     //IMPORT FOR SELF
      FNo:=GetFormNo('PROFILE');
      StoreElm(RetNo,FNo,3,RemoveChar(FlName,'.'));
      ImportT1Values(RetNo,FromDataDir,FlName,FormsNeeded,0);  {0:self}
      if FetchElmFNo(RetNo,FNo,41)='366' then StoreElm(RetNo,FNo,41,'365'); //IntToStr(Constant[0].FullYear));     //20190303 //did not work
      Calc(RetNo,'PROFILE');  //it astablishes Mar stat and spouse sin

      //store values in Cashflow
      FNo :=GetFormNo('CASHFLOW');
      x:=Ret[RetNo].Ln[101]+Ret[RetNo].Ln[104];
      StoreElm(RetNo,FNo,5,IntToStr(Round(x)));
      StoreElm(RetNo,FNo,8,FloatToStr(Ret[RetNo].Ln[114]));  //cpp
      StoreElm(RetNo,FNo,11,FloatToStr(Ret[RetNo].Ln[113])); //oas
      StoreElm(RetNo,FNo,14,FloatToStr(Ret[RetNo].Ln[115])); //oth pens
      StoreElm(RetNo,FNo,160,FloatToStr(Ret[RetNo].Ln[117])); //UCCB
      StoreElm(RetNo,FNo,20,FloatToStr(Ret[RetNo].Ln[121])); //interest
      StoreElm(RetNo,FNo,23,FloatToStr(Ret[RetNo].Ln[120]*1.25/100)); //dividends
      //StoreElm(RetNo,FNo,26,FloatToStr(Ret[RetNo].Ln[xxx])); //other inv
      StoreElm(RetNo,FNo,85,FloatToStr(Ret[RetNo].Ln[126])); //net rental
      x:=Ret[RetNo].Ln[135]+Ret[RetNo].Ln[137]+Ret[RetNo].Ln[139]
      +Ret[RetNo].Ln[141]+Ret[RetNo].Ln[143];
      StoreElm(RetNo,FNo,32,FloatToStr(x)); //net self empl
      //StoreElm(RetNo,FNo,35,FloatToStr(Ret[RetNo].Ln[xxx])); //priv div
      StoreElm(RetNo,FNo,38,FloatToStr(Ret[RetNo].Ln[119])); //empl insur
      StoreElm(RetNo,FNo,41,FloatToStr(Ret[RetNo].Ln[122])); //net lmt partn
      StoreElm(RetNo,FNo,44,FloatToStr(Ret[RetNo].Ln[128])); //taxable support
      StoreElm(RetNo,FNo,47,FloatToStr(Ret[RetNo].Ln[144])); //workers compens
      StoreElm(RetNo,FNo,50,FloatToStr(Ret[RetNo].Ln[145]+Ret[RetNo].Ln[146])); //soc assist/fed supl
      //StoreElm(RetNo,FNo,53,FloatToStr(Ret[RetNo].Ln[xxx])); //non txbl inc
      StoreElm(RetNo,FNo,56,FloatToStr(Ret[RetNo].Ln[130])); //other income
      // ?? abends StoreElm(RetNo,FNo,109,'Y'); //to cause T1 inerface via CalcAll
      Calc(RetNo,'CASHFLOW');
      {rrsp earned}
      With Ret[RetNo] do
      ImportToPlanner(RetNo);

     //IMPORT FOR SPOUSE  SpouseIN populated in ImportT1 data
      FlName :=LeftStr(SpouseSin,8)+'.'+RightStr(SpouseSin,1);
      if FileExists(FromDataDir+'\'+FlName) = True then
      begin
       ImportT1Values(RetNo,FromDataDir,FlName,FormsNeeded,1); {1=spouse}
       // spouse's cash flow
       Fno:=GetFormNo('CASHFLOW');
       x:=Ret[RetNo].LnSpouse[101]+Ret[RetNo].LnSpouse[104];
       StoreElm(RetNo,FNo,6,IntToStr(Round(x)));
       StoreElm(RetNo,FNo,9,FloatToStr(Ret[RetNo].LnSpouse[114]));  //cpp
       StoreElm(RetNo,FNo,12,FloatToStr(Ret[RetNo].LnSpouse[113])); //oas
       StoreElm(RetNo,FNo,15,FloatToStr(Ret[RetNo].LnSpouse[115])); //oth pens
       StoreElm(RetNo,FNo,158,FloatToStr(Ret[RetNo].LnSpouse[117])); //UCCB
       StoreElm(RetNo,FNo,21,FloatToStr(Ret[RetNo].LnSpouse[121])); //interest
       StoreElm(RetNo,FNo,24,FloatToStr(Ret[RetNo].LnSpouse[120]*1.25/100)); //dividends
       //StoreElm(RetNo,FNo,27,FloatToStr(Ret[RetNo].LnSpouse[xxx])); //other inv
       StoreElm(RetNo,FNo,86,FloatToStr(Ret[RetNo].LnSpouse[126])); //net rental
       x:=Ret[RetNo].LnSpouse[135]+Ret[RetNo].LnSpouse[137]+Ret[RetNo].LnSpouse[139]
          +Ret[RetNo].LnSpouse[141]+Ret[RetNo].LnSpouse[143];
       StoreElm(RetNo,FNo,33,FloatToStr(x)); //net self empl
       //StoreElm(RetNo,FNo,36,FloatToStr(Ret[RetNo].LnSpouse[xxx])); //priv div
       StoreElm(RetNo,FNo,39,FloatToStr(Ret[RetNo].LnSpouse[119])); //empl insur
       StoreElm(RetNo,FNo,42,FloatToStr(Ret[RetNo].LnSpouse[122])); //net lmt partn
       StoreElm(RetNo,FNo,45,FloatToStr(Ret[RetNo].LnSpouse[128])); //taxable support
       StoreElm(RetNo,FNo,48,FloatToStr(Ret[RetNo].LnSpouse[144])); //workers compens
       StoreElm(RetNo,FNo,51,FloatToStr(Ret[RetNo].LnSpouse[145]+Ret[RetNo].LnSpouse[146])); //soc assist/fed supl
       StoreElm(RetNo,FNo,57,FloatToStr(Ret[RetNo].LnSpouse[130])); //other income
       Calc(RetNo,'CASHFLOW');
       {spouse Rrsp}
       With Ret[RetNo] do
       {
       SpRrspEarned := SpRrspEarned+
        Ret[RetNo].LnSpouse[101]+Ret[RetNo].LnSpouse[104]
        +Ret[RetNo].LnSpouse[126]+Ret[RetNo].LnSpouse[128]
        +Ret[RetNo].LnSpouse[135]+Ret[RetNo].LnSpouse[137]
        +Ret[RetNo].LnSpouse[139]+Ret[RetNo].LnSpouse[141]
        +Ret[RetNo].LnSpouse[143];
        }
      end;

     ReformatSomeT1Data(RetNo);

     TransferT1ElmData(RetNo,GetFormNo('INVESTSTRATEGY'),6,FloatToStr(RrspEarned));
     TransferT1ElmData(RetNo,GetFormNo('INVESTSTRATEGY'),7,FloatToStr(SpRrspEarned));
     If RRSPEarned=0 then
     begin
       TransferT1ElmData(RetNo,GetFormNo('INVESTSTRATEGY'),14,FloatToStr(RRSPDedLimit));
       TransferT1ElmData(RetNo,GetFormNo('INVESTSTRATEGY'),18,'Y');
     end;

     If SpRRSPEarned=0 then
     begin
       TransferT1ElmData(RetNo,GetFormNo('INVESTSTRATEGY'),15,FloatToStr(RRSPDedLimit));
     end;

     TransferT1ElmData(RetNo,GetFormNo('INVESTSTRATEGY'),4,FloatToStr(RRSPUnusedRoom));
     TransferT1ElmData(RetNo,GetFormNo('INVESTSTRATEGY'),5,FloatToStr(SpRRSPUnusedRoom));

     TransferT1ElmData(RetNo,GetFormNo('INVESTSTRATEGY'),40,FloatToStr(RrspPA));
     TransferT1ElmData(RetNo,GetFormNo('INVESTSTRATEGY'),41,FloatToStr(SpRrspPA));

     Calc(RetNo,'TXSUM_1');
     Calc(RetNo,'TXSUM_2');
     Calc(RetNo,'CASHFLOW');
     Calc(RetNo,'INVESTSTRATEGY');
     CalcAll(RetNo);
     Screen.Cursor := crDefault;
     FormsNeeded.Free;
     Ret[RetNo].Changed := True;
end;

procedure ReformatSomeT1Data(RetNo:Integer);
Var i,FNo:Integer;
begin
FNo := GetFormNo('PROFILE');
StoreElm(RetNo,FNo,99,PrvLongToShort(FetchElmFNo(RetNo,FNo,99))); {province}
{Birthdate dates}
StoreElm(RetNo,FNo,27,FetchElmFNo(RetNo,FNo,27));
{spouse birthdate}
StoreElm(RetNo,FNo,29,FetchElmFNo(RetNo,FNo,29));
If FetchElm(RetNo,'PROFILE',82) = ''  then {spouse last name missing}
  StoreElm(RetNo,FNo,82,FetchElmFNo(RetNo,FNo,2)); {use husband's lastnm}
{dependants birthdates}
i:=45;
repeat
 StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i));
 Inc(i,4);
until i>77;
end;

Procedure ImportT1Values(RetNo:Integer;FromDataDir:String;FlName:String;FormsNeeded:TstringList;Whom:Integer);
  Var
  i, j, k, FNo, SNo, BxNo: integer;
  F1: TextFile;
  CurFrmName: string[10];
  Ndx: Array [1 .. 3] of byte;
  S: String[16];
  InputLin, Var1, Var2, Var3, Var4: String;
  MapList, T1DataFrmNames, T1DataElmNos, T1DataValues: TstringList;
  FromFrmName: string[10];
  FromElmNo: integer;
  ToFrmName: String;
  ToFrmNo, ToElmNo: integer;

  F: TFileStorage; // 20160323 Igor
  AppT1: TApp;
  FPRetNo, T1RetNo: Integer;
begin
  { load map list }
  AppT1 := AppList.AppFromID('T1-'+T1AppYear);
  if not Assigned(AppT1) then
    Exit;
  FPRetNo := GetCurrentRetNo;
  T1RetNo := AppT1.OpenReturn(FromDataDir, FlName, False, False);
  if T1RetNo <= 0 then
    Exit;
  try
    MapList := TstringList.Create;
    try
      MapList.LoadFromFile(Appdir + '\' + 'MapData.d');

      For i := 0 To MapList.Count - 1 do
      begin
        { get each record fro the maplist }
        FromFrmName := Rtrim(MidStr(MapList.Strings[i], 14, 9));
        FromElmNo := MyStrToInt(MidStr(MapList.Strings[i], 23, 3));

        ToFrmName := Rtrim(LeftStr(MapList.Strings[i], 9));
        ToFrmNo := GetFormNo(ToFrmName);
        ToElmNo := MyStrToInt(MidStr(MapList.Strings[i], 10, 3));

        StoreElm(FPRetNo, ToFrmNo, ToElmNo, FetchElm(T1RetNo, FromFrmName, FromElmNo));
      end;
    finally
      FreeAndNil(MapList);
    end;
  finally
    RetList[T1RetNo].Close(true);
  end;
  (* //20170313 Igor
  if CheckReturnPsw(FromDataDir, FlName) <> iorReported then  // 20160323 Igor
    exit;

  MapList := TstringList.Create;
  T1DataFrmNames := TstringList.Create;
  T1DataElmNos := TstringList.Create;
  T1DataValues := TstringList.Create;
  MapList.LoadFromFile(Appdir + '\' + 'MapData.d');
  { read file line by line }

  F := TFileStorage.Create(FromDataDir, FlName, fsRead); // 20160323 Igor
  if not F.ReadLine(Var1, Var2, Var3, Var4) then  // 20160323 Igor
    exit;
  // AssignFile(F1, FromDataDir + '\'+ FlName);
  // ReSet(F1);
  // Readln(F1, InputLin);
  { Break up into variables }
  // j := 0;
  // for i :=1 to Length(InputLin) do
  // begin
  // if InputLin[i] = Delimiter then begin inc(j);ndx[j] :=i; end;
  // end;

  // Var1 := Copy(InputLin,1,Ndx[1]-1);
  // Var2 := Copy(InputLin,Ndx[1]+1,Ndx[2]-Ndx[1]-1);
  // Var3 := Copy(InputLin,Ndx[2]+1,Ndx[3]-Ndx[2]-1);
  // Var4 := Copy(InputLin,Ndx[3]+1,255);
  If (Var1 <> 'T1') or (MyStrToInt(Var2) > MyStrToInt(AppYear) + 1) then
  begin
    ShowMessage('Selected file cannot be imported' + Chr(13) +
      'Tax data must be up to year year ' + IntToStr(MyStrToInt(AppYear) + 1));
    CloseFile(F1);
    MapList.Free;
    T1DataFrmNames.Free;
    T1DataElmNos.Free;
    T1DataValues.Free;
    exit;
  end;
  { Store T1data as a list of Formname,Elm,Value }
  // While not EOF(F1) do
  While F.ReadLine(Var1, Var2, Var3, Var4) do   // 20160323 Igor
  begin
    // Readln(F1, InputLin);
    // {break it}
    // j := 0;
    // for i :=1 to Length(InputLin) do
    // begin
    // if InputLin[i] = Delimiter then begin inc(j);ndx[j] :=i; end;
    // end;
    // Var1 := Copy(InputLin,1,Ndx[1]-1);
    // Var2 := Copy(InputLin,Ndx[1]+1,Ndx[2]-Ndx[1]-1);
    // Var3 := Copy(InputLin,Ndx[2]+1,Ndx[3]-Ndx[2]-1);
    // Var4 := Copy(InputLin,Ndx[3]+1,255);
    { Load T1 data lines into 3 lists (form, Elms, Values }
    { only whats needed }
    if Var1 = 'F' then
      CurFrmName := Var2 { Form record }
    else if (Var1 = 'D') then
    begin
      if (IsInList(CurFrmName, FormsNeeded) >= 0) then
      begin
        T1DataFrmNames.Add(CurFrmName);
        T1DataElmNos.Add(Var2);
        T1DataValues.Add(Var3);
        CaptureSpecificT1Data(RetNo, CurFrmName, MyStrToInt(Var2), Var3, Whom);
        If (CurFrmName = 'T1') // 20110510
          and (MyStrToInt(Var2) = 4) and (Whom = 0) then
          SpouseSin := Var3;
      end
    end
    else if Var1 = 'L' then { store Line numbers }
    begin
      If Whom = 0 then
        Ret[RetNo].LnTaxPayer[StrToInt(Var2)] := vl(Var3) { client }
        // 20110510
        // If Whom =0 then Ret[RetNo].Ln[StrToInt(Var2)] := vl(Var3) {client}
      else
        Ret[RetNo].LnSpouse[StrToInt(Var2)] := vl(Var3) { spouse lines }
    end
    else if Var1 = 'O' then
      CurFrmName := '' { ignore Overrides }
    else if Var1 = 'R' then
      CurFrmName := ''; { ignore Review marks }
  end;
  If Whom = 0 { self } then { automatic form data transfer via map list }
  begin
    For i := 0 To MapList.Count - 1 do
    begin
      { get each record fro the maplist }
      FromFrmName := Rtrim(MidStr(MapList.Strings[i], 14, 9));
      FromElmNo := MyStrToInt(MidStr(MapList.Strings[i], 23, 3));

      ToFrmName := Rtrim(LeftStr(MapList.Strings[i], 9));
      ToFrmNo := GetFormNo(ToFrmName);
      ToElmNo := MyStrToInt(MidStr(MapList.Strings[i], 10, 3));
      { scan thru the T1 data to find it }
      For j := 0 to T1DataFrmNames.Count - 1 do
      begin
        If (FromFrmName = T1DataFrmNames[j]) and
          (FromElmNo = MyStrToInt(T1DataElmNos[j])) then
          TransferT1ElmData(RetNo, ToFrmNo, ToElmNo, T1DataValues[j]);
      end;
    end; { end transfer via maplist }
  end; { end self }

  // CloseFile(F1);
  F.Free; // 20160323 Igor
  // Now save the LnTaxpayer into TxSum_1
  SaveT1LineDataInTXSUM(RetNo, 0); // 20110510
  // Now save the LnSpouse into TxSum_2
  SaveT1LineDataInTXSUM(RetNo, 1);
  For i := LnLowBound to LnHighBound do
    Ret[RetNo].Ln[i] := Ret[RetNo].LnTaxPayer[i]; // 20110510
  MapList.Free;
  T1DataFrmNames.Free;
  T1DataElmNos.Free;
  T1DataValues.Free;
  *)
end;

Procedure CaptureSpecificT1Data(RetNo:integer;FromFrmName:string;
          FromElmNo:Integer;Valu:String;Whom:integer);
begin
 If (FromFrmName = 'RRSPNXT') then
 begin

  If FromElmNo = 2 then
  begin
   If Whom =0 then
    RRSPEarned:=Vl(valu)
   else
    SpRRSPEarned:=Vl(valu);
  end;

  If FromElmNo = 7 then
  begin
   If Whom =0 then
    RRSPPA:=Vl(valu)
   else
    SpRRSPPA:=Vl(valu);
  end;



  If FromElmNo = 10 then
  begin
   If Whom =0 then
    RRSPUnusedRoom:=Vl(valu)
   else
    SpRRSPUnusedRoom:=Vl(valu);
  end;

  If FromElmNo = 11 then
  begin
   If Whom =0 then
    RRSPDedLimit:=Vl(valu)
   else
    SpRRSPDedLimit:=Vl(valu);
  end;

end;
end;

Procedure TransferT1ElmData(RetNo,ToFrmNo,ToElmNo:Integer;Valu:String);
begin
 If Ret[RetNo].Frm[ToFrmNo].Count =0 then InitFormData(RetNo,ToFrmNo);
 StoreElm(RetNo,ToFrmNo,ToElmNo,Valu);
 If Valu > '' then Ret[RetNo].FrmHasData[ToFrmNo] := True;
end;

procedure ImportToPl1(RetNo:Integer;FNo:Integer);
Var x:Real;
begin
EXIT;  //old form

  with Ret[RetNo] do
  begin
  x:=Ln[101]+Ln[104];
  StoreElm(RetNo,FNo,27,IntToStr(Round(x)));  {tot Empl Income}
  StoreElm(RetNo,FNo,30,IntToStr(Round(Ln[113])));
  StoreElm(RetNo,FNo,33,IntToStr(Round(Ln[114])));
  StoreElm(RetNo,FNo,36,IntToStr(Round(Ln[115])));
  StoreElm(RetNo,FNo,39,IntToStr(Round(Ln[120])));
  StoreElm(RetNo,FNo,42,IntToStr(Round(Ln[121])));
  StoreElm(RetNo,FNo,45,IntToStr(Round(Ln[128])));
  x:=Ln[135]+Ln[137]+Ln[139]+Ln[141]+Ln[143];
  StoreElm(RetNo,FNo,48,IntToStr(Round(x)));  {tot self-Empl Income}
  StoreElm(RetNo,FNo,51,IntToStr(Round(Ln[119])));
  StoreElm(RetNo,FNo,54,IntToStr(Round(Ln[122])));

  StoreElm(RetNo,FNo,57,IntToStr(Round(Ln[126])));
  StoreElm(RetNo,FNo,60,IntToStr(Round(Ln[128])));
  StoreElm(RetNo,FNo,63,IntToStr(Round(Ln[129])));
  StoreElm(RetNo,FNo,66,IntToStr(Round(Ln[130])));
  StoreElm(RetNo,FNo,69,IntToStr(Round(Ln[150])));

  StoreElm(RetNo,FNo,72,IntToStr(Round(Ln[207])));
  StoreElm(RetNo,FNo,75,IntToStr(Round(Ln[208])));
  StoreElm(RetNo,FNo,78,IntToStr(Round(Ln[209])));
  StoreElm(RetNo,FNo,81,IntToStr(Round(Ln[212])));
  StoreElm(RetNo,FNo,84,IntToStr(Round(Ln[214])));
  StoreElm(RetNo,FNo,87,IntToStr(Round(Ln[215])));
  StoreElm(RetNo,FNo,90,IntToStr(Round(Ln[217])));
  StoreElm(RetNo,FNo,93,IntToStr(Round(Ln[219])));
  StoreElm(RetNo,FNo,96,IntToStr(Round(Ln[220])));
  StoreElm(RetNo,FNo,99,IntToStr(Round(Ln[221])));
  StoreElm(RetNo,FNo,102,IntToStr(Round(Ln[224])));
  StoreElm(RetNo,FNo,105,IntToStr(Round(Ln[229])));
  StoreElm(RetNo,FNo,108,IntToStr(Round(Ln[232])));
  StoreElm(RetNo,FNo,111,IntToStr(Round(Ln[235])));
  StoreElm(RetNo,FNo,114,IntToStr(Round(Ln[236])));

  {StoreElm(RetNo,FNo,117,IntToStr(Round(Ln[237])));}
  StoreElm(RetNo,FNo,120,IntToStr(Round(Ln[245])));
  StoreElm(RetNo,FNo,123,IntToStr(Round(Ln[249])));
  StoreElm(RetNo,FNo,126,IntToStr(Round(Ln[251])));
  StoreElm(RetNo,FNo,129,IntToStr(Round(Ln[252])));
  StoreElm(RetNo,FNo,132,IntToStr(Round(Ln[253])));
  StoreElm(RetNo,FNo,135,IntToStr(Round(Ln[254])));
  StoreElm(RetNo,FNo,138,IntToStr(Round(Ln[255])));
  StoreElm(RetNo,FNo,141,IntToStr(Round(Ln[256])));
  StoreElm(RetNo,FNo,144,IntToStr(Round(Ln[260])));
  end;
end;

procedure ImportToPl2(RetNo:Integer;FNo:Integer);
Var x:Real;
begin
EXIT;  //old form

  with Ret[RetNo] do
  begin
  StoreElm(RetNo,FNo,27,IntToStr(Round(Ln[300])));
  StoreElm(RetNo,FNo,30,IntToStr(Round(Ln[301])));
  StoreElm(RetNo,FNo,33,IntToStr(Round(Ln[303])));
  StoreElm(RetNo,FNo,36,IntToStr(Round(Ln[305])));
  StoreElm(RetNo,FNo,39,IntToStr(Round(Ln[306])));
  StoreElm(RetNo,FNo,42,IntToStr(Round(Ln[308])));
  StoreElm(RetNo,FNo,45,IntToStr(Round(Ln[307])));
  StoreElm(RetNo,FNo,48,IntToStr(Round(Ln[310])));
  StoreElm(RetNo,FNo,51,IntToStr(Round(Ln[312])));
  StoreElm(RetNo,FNo,54,IntToStr(Round(Ln[314])));
  StoreElm(RetNo,FNo,57,IntToStr(Round(Ln[316])));
  StoreElm(RetNo,FNo,60,IntToStr(Round(Ln[318])));
  StoreElm(RetNo,FNo,63,IntToStr(Round(Ln[323])));
  StoreElm(RetNo,FNo,66,IntToStr(Round(Ln[324])));
  StoreElm(RetNo,FNo,69,IntToStr(Round(Ln[326])));
  StoreElm(RetNo,FNo,72,IntToStr(Round(Ln[330])));
  StoreElm(RetNo,FNo,75,IntToStr(Round(Ln[332])));
  StoreElm(RetNo,FNo,78,IntToStr(Round(Ln[338])));
  x:=Ln[340]+Ln[342];
  StoreElm(RetNo,FNo,81,IntToStr(Round(x)));  {donations}
  StoreElm(RetNo,FNo,84,IntToStr(Round(Ln[349])));
  StoreElm(RetNo,FNo,87,IntToStr(Round(Ln[350])));

  StoreElm(RetNo,FNo,117,IntToStr(Round(Ln[410])));
  StoreElm(RetNo,FNo,120,IntToStr(Round(Ln[412])));
  StoreElm(RetNo,FNo,123,IntToStr(Round(Ln[414])));
  StoreElm(RetNo,FNo,150,IntToStr(Round(Ln[479])));
  StoreElm(RetNo,FNo,153,IntToStr(Round(Ln[457])));

  StoreElm(RetNo,FNo,162,IntToStr(Round(Ln[315]))+
                         IntToStr(Round(Ln[319])));
  end;
end;

procedure ImportToPlanner(RetNo:Integer);
Var FNo :Integer;x: Real;
begin
(*
 with Ret[RetNo] do
 begin
  FNo :=GetFormNo('TAXPL_1');
  If Frm[FNo].Count =0 then InitFormData(RetNo,FNo);
  ImportToPl1(RetNo,FNo);

  FNo :=GetFormNo('TAXPL_2');
  If Frm[FNo].Count =0 then InitFormData(RetNo,FNo);
  ImportToPl2(RetNo,FNo);

 end; {with}
*)
end;

end.
