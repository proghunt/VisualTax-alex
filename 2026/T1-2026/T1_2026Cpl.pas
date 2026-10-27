unit T1_2026cpl;
//updated 07-28

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,StdCtrls,
  ExtCtrls,Forms,Buttons,Dialogs,Grids;

type
  TCoupleT1_2026 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    CurRetLbl: TLabel;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    Label2: TLabel;
    Label7: TLabel;
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel2: TPanel;
    ButtonsPanel: TPanel;
    CancelBtn: TBitBtn;
    OKBtn: TBitBtn;
    Label19: TLabel;
    Label22: TLabel;
    WarnLbl: TLabel;
    Label23: TLabel;
    Label18: TLabel;
    Image2: TImage;
    Label20: TLabel;
    CplBtn: TPanel;
    Label5: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    //Function  GetSourceDir(RetNo:Integer):String;
    procedure ShowDependants(RNo:integer);
    //Procedure DoCoupling(RetNo:Integer);
    //Function  CreateSpouse(SourceDir:String;ParentRetNo:Integer;CplSin:String):Integer;
    //Function  CreateDependantsReturn(SourceDir:String;ParentRetNo:Integer;CplSin:String):Integer;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure LoadFamSetToStringList(RNo:Integer);
    Procedure SaveSetUp(RNo:Integer;Member,Nm,Sin,LinkIndicator:String;j:Integer);
  private
    RetNo: integer;
  end;

var
  Couple: TCoupleT1_2026;
  SourceDir:String;
 // RetNo:Integer;  //global for thids unit

Type
  PCplList  = ^ACplRec;
  ACplRec = Record
   Member       : string; //[20];
   Name         : string; //[20];
   SIN          : string; //[9];
   LinkIndicator:string; //[1];
   RetNo        : Integer; //20170606 Igor
   Filename     : string; //20200914 Igor
  end;
  TCplList = class(TList)
  public
    destructor Destroy; override;
  end;
var
   //CplList   : TList;     {behaves like base object TList}
   CplRec    : PCplList;
Procedure DoCoupling(RetNo:Integer);

implementation

{$R *.DFM}

uses vtMulti,vtCommon,vtMain,vtDialogs,T1_2026,T1_2026Declare,T1_2026Common,
  T1_2026Common2,T1_2026TrimStr,T1_2026CalcCpl,T1_2026T1Rtns,T1_2026T1rtns2,
  T1_2026Main,T1_2026Calc,T1_2026ChildWinNEW,vtTrimStr,vtShared,System.IOUtils, //20190528 Igor
  vtChild; //20170130 Igor

function GetCplFileName(SourceDir: string; RetNo: integer; CplIndex: integer): string; //20200914 Igor
var FNo: integer;
    SIN, LastName, FirstName: string;
begin
  if CplIndex = 0 then
  begin
    FNo := GetFormNo('INFO');
    SIN := FetchElmFNo(RetNo,FNo,4);
    LastName := FetchElmFNo(RetNo,FNo,45);
    FirstName := FetchElmFNo(RetNo,FNo,20);
    Result := GenerateCloudFileName(SIN, LastName, FirstName, OptRec.FileNameFormat); //20200921 Igor
  end
  else
  begin
    FNo := GetFormNo('DEPEND');
    SIN := FetchElmFNo(RetNo,FNo, 7 + (CplIndex - 1) * 15);
    LastName := FetchElmFNo(RetNo,FNo, 302 + (CplIndex - 1) * 7);
    FirstName := FetchElmFNo(RetNo,FNo, 5 + (CplIndex - 1) * 15);
    Result := GenerateCloudFileName(SIN, LastName, FirstName, OptRec.FileNameFormat); //20200921 Igor
  end;
end;

Procedure LoadCPLList(RetNo:Integer;CplList:TCplList); //20200914 Igor
Var i,FNo, nLine:Integer;
    SourceDir: string;
Begin
 FNo:=GetFormNo('FAMSET');
 SourceDir:=GetSourceDir(RetNo);
 With Ret[RetNo].Frm[FNo] do
 begin
  i:=1;
  nLine := 0;
  Repeat
    New(CplRec);
    CplRec.Member:=FetchElmFNo(RetNo,FNo,i);
    CplRec.Name:=FetchElmFNo(RetNo,FNo,i+1);
    CplRec.Sin:=FetchElmFNo(RetNo,FNo,i+2);
    CplRec.LinkIndicator:=FetchElmFNo(RetNo,FNo,i+3);
    CplRec.Filename:=GetCplFileName(SourceDir,RetNo,nLine); //20200819 Igor
    CplRec.RetNo := 0; //20170606 Igor
    Cpllist.Add(CplRec);
    Inc(i,4);
    Inc(nLine);
  until i>41;
 end; //with
end;

Function CreateSpouse(SourceDir:String;ParentRetNo:Integer;CplSin,CplName,CplFileName:String):Integer; //20190528 Igor //20200914 Igor
//Function TCoupleT1_2026.CreateSpouse(SourceDir:String;ParentRetNo:Integer;CplSin:String):Integer;
Var i,SpRetNo,RetNoBak:integer;FlName,s:string;
  RetNo: integer;
  FormName, cFile: string; //20190529 Igor
  FormNo: integer;
begin
  Result:=0;
  FlName := CplFileName; //20200914 Igor
 {from disk}
 //20170315 Igor >>>
  StartSilentRead;
  try
    //20190528 Igor >>>
    cFile := '';
    if CheckIsCloud(true) then
      if not FileExists(TPath.Combine(SourceDir, FlName)) then
      begin
        cFile := MainFormT1.GetCoupleFromCloud(SourceDir, CplFileName); //20200914 Igor
        if not cFile.IsEmpty then
          FlName := cFile;
      end;
    //20190528 Igor <<<
    Result := OpenReturn(SourceDir,FlName,False);
    //20190528 Igor >>>
    if CheckIsCloud(true) and FileExists(TPath.Combine(SourceDir, cFile)) then
      TFile.Delete(TPath.Combine(SourceDir, cFile));
    //20190528 Igor <<<
  finally
    EndSilentRead;
  end;
  //20170315 Igor <<<
  if Result > 0 then
  begin
    RetNo := Result;
     Ret[RetNo].CouplingSw := True;
     //SpRetNo :=GetSpRetNo(RetNo); //and then???
     exit;
  end;
  if Result <> iorFileName then
    begin ShowOpenReturnFailure(Result,SourceDir,CplSin);exit; end;

  {create in memory}
  // ShowTimedMsg('Spouse'+Chr(39)+'s return is created for the first time',1500);
   RetNo:=CreateNewReturn;
   Result:=RetNo;
   if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;
   FormName := 'INFO';
   FormNo := GetFormNo(FormName);   //this goes back to RetNo 1 !!! //20110226
   Calc(RetNo,'INFO');
   {Copy Ident data}
   For i := 1 to 20 do
     Ret[Retno].Frm[FormNo].Strings[i] := Ret[ParentRetNo].Frm[FormNo].Strings[i];
   Ret[Retno].Frm[FormNo].Strings[22] :=  Ret[ParentRetNo].Frm[FormNo].Strings[22];  {aptm}

   If Ret[ParentRetNo].Frm[FormNo].Strings[45] > '' then  {last nm}
    Ret[Retno].Frm[FormNo].Strings[5] := Ret[ParentRetNo].Frm[FormNo].Strings[45];

   For i := 54 to 55 do
        Ret[Retno].Frm[FormNo].Strings[i] := Ret[ParentRetNo].Frm[FormNo].Strings[i];

 // SEE INFO Ret[Retno].Frm[FormNo].Strings[24] :=  Ret[ParentRetNo].Frm[FormNo].Strings[65]; //20120129  //  DATE OF DEATH //20110319
 // SEE INFO Ret[Retno].Frm[FormNo].Strings[65] :=  Ret[ParentRetNo].Frm[FormNo].Strings[24]; //20120129  //  DATE OF DEATH //20110319

   Ret[Retno].Frm[FormNo].Strings[59] :=  Ret[ParentRetNo].Frm[FormNo].Strings[9];  {spouse birthdate}

   Ret[Retno].Frm[FormNo].Strings[37] := 'N'; {head of house}

   For i := 43 to 44 do
        Ret[Retno].Frm[FormNo].Strings[i] := Ret[ParentRetNo].Frm[FormNo].Strings[i];
   For i := 46 to 49 do
        Ret[Retno].Frm[FormNo].Strings[i] := Ret[ParentRetNo].Frm[FormNo].Strings[i];
   Ret[Retno].Frm[FormNo].Strings[58] := Ret[ParentRetNo].Frm[FormNo].Strings[58];
   Ret[Retno].Frm[FormNo].Strings[51] := Ret[ParentRetNo].Frm[FormNo].Strings[51];

   Ret[Retno].Province :=Ret[ParentRetNo].Province;

   {Swap}
    Ret[Retno].Frm[FormNo].Strings[3] := Ret[ParentRetNo].Frm[FormNo].Strings[4]; {SIN}
    Ret[Retno].Frm[FormNo].Strings[4] := Ret[ParentRetNo].Frm[FormNo].Strings[3]; {SIN}
    Ret[Retno].Frm[FormNo].Strings[2] := Ret[Retno].Frm[FormNo].Strings[20];{fname}

    If Ret[Retno].Frm[FormNo].Strings[5] <>  Ret[ParentRetNo].Frm[FormNo].Strings[5] then  {diff last nm}
     Ret[Retno].Frm[FormNo].Strings[45]:=  Ret[ParentRetNo].Frm[FormNo].Strings[5];

    Ret[Retno].Frm[FormNo].Strings[20] := Ret[ParentRetNo].Frm[FormNo].Strings[2];{fname}
    Ret[RetNo].CouplingSw:=True;

    Ret[Retno].Frm[FormNo].Strings[9] := FetchElm(ParentRetNo,'INFO',59);    {birthdates}

    //20131130
    Ret[Retno].Frm[FormNo].Strings[26] := FetchElm(ParentRetNo,'INFO',215);    //date of entry
    Ret[Retno].Frm[FormNo].Strings[25] := FetchElm(ParentRetNo,'INFO',216);    //date of entry


    Ret[Retno].MarStatus:=1;  //March 5 2008
end;

Function CreateDependantsReturn(SourceDir:String;ParentRetNo:Integer;CplSin, CplFileName:String):Integer; //20200914 Igor
//Function TCoupleT1_2026.CreateDependantsReturn(SourceDir:String;ParentRetNo:Integer;CplSin:String):Integer;
Var i,ndx:Integer;FlName,s:string;
  RetNo: integer absolute Result;
  FormName: string;
  FormNo: integer;
begin
 Result:=0;
 FlName := CplFileName; //20200914 Igor
 If FileExists(SourceDir+'\'+FlName) then
 begin {bring from disk}
    RetNo:=OpenReturn(SourceDir,FlName,False);
    if RetNo > 0 then
     begin
      //OpenUsedForms(RetNo);
      Ret[RetNo].CouplingSw:= True;
      Ret[RetNo].Changed := True;
      Exit;  {Close}
      end
    else
    begin ShowOpenReturnFailure(Result,SourceDir,CplSin);exit; end;
 end;

 {create in memory}
  //Mychild.WindowState := wsNormal;
  RetNo:=CreateNewReturn;
   if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;
  FormName := 'INFO';
  FormNo := GetFormNo(FormName);
  OpenForm(RetNo,FormNo,0); //MakeNewChild(FormNo);  {new child}

  For i:=54 to 55 do
    Ret[Retno].Frm[FormNo].Strings[i] :=
        Ret[ParentRetNo].Frm[FormNo].Strings[i];  {phone}
  For i := 46 to 49 do
        Ret[Retno].Frm[FormNo].Strings[i] := Ret[ParentRetNo].Frm[FormNo].Strings[i];
  Ret[Retno].Frm[FormNo].Strings[58] :=Ret[ParentRetNo].Frm[FormNo].Strings[58];
  Ret[Retno].Frm[FormNo].Strings[51] := Ret[ParentRetNo].Frm[FormNo].Strings[51];
  Ret[Retno].Frm[FormNo].Strings[37] := 'N'; {head of house}
  Ret[Retno].Frm[FormNo].Strings[38] := Ret[ParentRetNo].Frm[FormNo].Strings[38];
  {initialize province}
   Ret[Retno].Frm[FormNo].Strings[1] := Ret[ParentRetNo].Frm[FormNo].Strings[1];  {province}
   Ret[Retno].Frm[FormNo].Strings[22] := Ret[ParentRetNo].Frm[FormNo].Strings[22];  {Apartm} //20100210
   Ret[Retno].Frm[FormNo].Strings[68] := Ret[ParentRetNo].Frm[FormNo].Strings[68];   //pobox //20100210
   Ret[Retno].Frm[FormNo].Strings[163] := Ret[ParentRetNo].Frm[FormNo].Strings[163]; //rr //20100210
   Ndx:=GetIndexInDependants(ParentRetNo,CplSin);  {index to SIN}
   If Ndx >-1 then CopyDependToPage1(ParentRetNo,RetNo,Ndx); {fill page -1}
   Ret[RetNo].CouplingSw := True;
   Ret[RetNo].Changed := True;
end;

procedure MyCoupling(RetNo: Integer; CplList: TCplList);
var
  ParentRetNo, i: integer;
  SourceDir: string;
  //x :real;
  CplSin, DependSin, CplName, CplFileName: string; //20190528 Igor //20200914 Igor
begin
  ParentRetNo := RetNo;
  SourceDir := GetSourceDir(RetNo);
  Ret[RetNo].CouplingSw := True;  //march 2007
  //put it into the cpllist
  Screen.Cursor := crHourGlass;
  for i := 0 to CplList.Count - 1 do
  begin
    CplRec := CplList.Items[i];
    if i = 0 then //spouse
    begin
      CplSin := CplRec.Sin;
      CplName := CplRec.Name; //20190528 Igor
      CplFileName := CplRec.FileName; //20200914 Igor
      if (CplSin > '') then
      begin
        Screen.Cursor := crHourGlass;
        if IsRetInMemory(CplSin) = 0 then  //spouse not in memory
          RetNo := CreateSpouse(SourceDir, ParentRetNo, CplSin, CplName, CplFileName) {not in memory,create new RetNo} //20190528 Igor //20200914 Igor
        else
          RetNo := IsRetInMemory(CplSin);  {both in memory}
        //20170315 Igor >>>
        if RetNo <= 0 then
          Exit;
        //20170315 Igor <<<
        CplRec.RetNo := RetNo; //20170606 Igor
        Ret[ParentRetNo].CouplingSw := True;
        Ret[RetNo].CouplingSw := True;
        ApplySharedStatements(ParentRetNo, RetNo);
        CplXfer(ParentRetNo, RetNo);
        CalcFullReturn(RetNo);

        ApplySharedStatements(RetNo, ParentRetNo);
        CplXfer(RetNo, ParentRetNo);
        CalcFullReturn(ParentRetNo);

        ApplySharedStatements(ParentRetNo, RetNo);
        CplXfer(ParentRetNo, RetNo); {0riginal one more time}
        CalcFullReturn(RetNo);

        CreateS2(ParentRetNo, RetNo);
        CreateS2(RetNo, ParentRetNo);

        Calc(RetNo, 'INFO');
        Ret[RetNo].Changed := true;
        Ret[ParentRetNo].Changed := true;
      end; //cplsin>''
    end //spouse
    else
    begin  //dependants
      CplSin := CplRec.Sin;
      CplFileName := CplRec.FileName; //20200914 Igor
      if (CplSin > '') and (UpperCase(CplRec.LinkIndicator) = 'X') then
      begin
        if IsRetInMemory(CplSin) = 0 then  //not in memory
        begin
          RetNo := CreateDependantsReturn(SourceDir, ParentRetNo, CplSin, CplFileName); //20200914 Igor
          //20170315 Igor >>>
          if RetNo <= 0 then
            Exit;
          //20170315 Igor <<<
          CplRec.RetNo := RetNo; //20170606 Igor
          Ret[RetNo].CouplingSw := True;
          Calc(RetNo, 'INFO');
          Ret[RetNo].Changed := true;
          CalcFullReturn(RetNo);
        end;
      end; //cplsin>''
    end; //dependants
  end; //i
 //now open all couples returns
  for i := 0 to CplList.Count - 1 do
  begin
    CplRec := CplList.Items[i];
    //20170606 Igor >>>
    //RetNo := GetRetNoFromSin(CplRec.Sin);
    if CplRec.RetNo > 0 then
    begin
      vtChild.CreateNewMDIChild(CplRec.RetNo, '').HideAllControls;
      try
        OpenForm(CplRec.RetNo, 'INFO', 0);
        OpenUsedForms(CplRec.RetNo);
      finally
        RetList[CplRec.RetNo].MyChild.ShowAllControls;
      end;
    end;
    //20170606 Igor <<<
  end;
  MainForm.FormPaint(Application);
  Screen.Cursor := crDefault;
end;

Procedure DoCoupling(RetNo:Integer);
//Procedure TCoupleT1_2026.DoCoupling(RetNo:Integer);
Var
 //cplsin is the sin of any return being coupled
  CplList: TCplList;
Begin
  ApplicationState := ApplicationState + [asFamilyOpen]; //20160724 Igor
  try
    CplList:=TCplList.Create;
    LoadCPLList(RetNo,CplList);
    //Couple.DoCoupling(RetNo);
    MyCoupling(RetNo,CplList);
    CplList.Free;
  finally
    ApplicationState := ApplicationState - [asFamilyOpen]; //20160724 Igor
  end;
end;

procedure TCoupleT1_2026.FormCreate(Sender: TObject);
Var i,j:integer;SpRetNo:integer;
begin
 RetNo:=GetCurrentRetNo;
 SpRetNo := GetSpRetNo(RetNo);

 WarnLbl.Caption:='If you click OK now, such schedules will be copied from '
 + GetFirstName(RetNo)+ ' and attached  to '+ FetchElm(RetNo,'INFO',20);
 With StringGrid1 do
 begin
   Cells[0,1] := 'Spouse';
   Cells[1,0] := 'Name';
   Cells[2,0] := 'SIN';
   Cells[3,0] := 'LINK [x]';
   If Ret[RetNo].FormHasData['FAMSET'] then
     LoadFamSetToStringList(RetNo)
   else
   begin
    If Ret[RetNo].MarStatus <3 then //20110211
    Begin
     Cells[1,1] := Ret[Retno].Frm[GetFormNo('INFO')].Strings[20];
     Cells[2,1] := Ret[Retno].Frm[GetFormNo('INFO')].Strings[4];
     If Cells[2,1] >'' then Cells[3,1] :='X' else Cells[3,1]:=''; {create ind}
    end;

    If ((Vl(FetchElm(RetNo,'DEPEND',1))+Vl(FetchElm(RetNo,'DEPEND',4)))>0)
    Or (CountAllDependants(RetNo) >0)
    then
     ShowDependants(RetNo)
    else
     If SpRetNo>0 then ShowDependants(SpRetNo);
   end;
 end;
 CurRetLbl.Caption := GetRetName(RetNo);
 CurRetLbl.Color := GetRetColor(RetNo);
end;


procedure TCoupleT1_2026.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TCoupleT1_2026.ShowDependants(RNo:integer);
Var i,j:integer;
begin
 with StringGrid1 do
 begin
  J:=2; {grid row index}
  i:=5; {dependants index}
  Repeat {run thru reltionships}
    If FetchElm(RNo,'DEPEND',i)>'' then
     begin
     Cells[0,j] :=FetchElm(RNo,'DEPEND',i+6); {relationship}
     Cells[1,j] :=FetchElm(RNo,'DEPEND',i); {Name}
     Cells[2,j] :=FetchElm(RNo,'DEPEND',i+2); {Sin}
     Inc(j);
     end;
    Inc(i,15);
  until i >125;
 end;
end;

procedure TCoupleT1_2026.OKBtnClick(Sender: TObject);
Var i,j,RetNo,RNo,ParentRetNo:Integer; //, j,FNo:Integer; //,result,ParentRetNo : Integer;
//x :real;
//CplSin,DependSin : string; //[9];  //cplsin is the sin of any return being coupled
S : string;
  CplList: TCplList;
begin
 //validate
 ApplicationState := ApplicationState + [asFamilyOpen]; //20160822 Igor
 try
   For i:=1 to 15 do
   begin
     If UpperCase(StringGrid1.Cells[3,i])='X' then
     begin
       If (AllTrim(StringGrid1.Cells[2,i])='')
          or (ValidSin(AllTrim(StringGrid1.Cells[2,i]))=False)
          or (UpperCase(StringGrid1.Cells[1,i])='') {Name exists} THEN
       begin
         ShowMessage(StringGrid1.Cells[1,i]+
           ' does not have a valid SIN or Name. Cannot be coupled'+
           Chr(13)+'Please delete the Link (X)');
         exit;
       end;
     end; {end X}
   end;

   RetNo:=GetCurrentRetNo;
   ParentRetNo:=RetNo;
   {$IFDEF ReturnsLimit}
   if RetInMem >= ReturnsLimit then
   begin
     ShowMessage('Exceeded number of concurrent returns allowed');
     exit;
   end;
   {$ELSE}
   {$ENDIF}

   CplList:=TCplList.Create;
   try
     For i:=1 to 10 do
     begin
       With StringGrid1 do
       begin
         New(CplRec);
         CplRec.Member:=Cells[0,i];
         CplRec.Name:=Cells[1,i];
         CplRec.Sin:=Cells[2,i];
         CplRec.LinkIndicator:=Cells[3,i];
         CplRec.RetNo := 0; //20170606 Igor
         CplRec.FileName := GetCplFileName(SourceDir,RetNo,i-1); //20200914 Igor
         Cpllist.Add(CplRec);
       end;
     end;
     MyCoupling(RetNo, CplList);  //shared statements and calcs
     (*
     //now save into family set
     For i:=0 to 15 do
     begin
      With StringGrid1 do
      begin
        New(CplRec);
        CplRec.Member:=Cells[0,i];
        CplRec.Name:=Cells[1,i];
        CplRec.Sin:=Cells[2,i];
        CplRec.LinkIndicator:=Cells[3,i];
        Cpllist.Add(CplRec);
      end;
     end;
     *)
     //now save family setup only in spouses
     j:=1; //index to FamSet
     For i:=0 to CplList.count-1 do
     begin
       CplRec := CplList.Items[i];
       If i=0 then //spouses line
       begin
         //save to original parent
         SaveSetUp(ParentRetNo,'Spouse',CplRec.Name,CplRec.Sin,CplRec.LinkIndicator,j);
         // now save into spouse's return
         RNo:=GetRetNoFromSin(GetSpouseSin(ParentRetNo)); //spouse's retno
         If RNo>0 then
           SaveSetUp(RNo,'Spouse',GetFirstName(ParentRetNo),
                     GetSinNo(ParentRetNo),CplRec.LinkIndicator,j);
       end
       else //kids
       begin
         If CplRec.SIN>'' then
         begin
           SaveSetUp(ParentRetNo,CplRec.Member,CplRec.Name,CplRec.Sin,CplRec.LinkIndicator,j);
           // now save into spouse's return
           RNo:=GetRetNoFromSin(GetSpouseSin(ParentRetNo)); //spouse's retno
           If RNo>0 then
             SaveSetUp(RNo,CplRec.Member,CplRec.Name,CplRec.Sin,CplRec.LinkIndicator,j);
         end;
       end;
       j:=J+4;
     end; //i
   finally //20160822 igor
     CplList.Free;
   end;
   Close;
 finally
   ApplicationState := ApplicationState - [asFamilyOpen]; //20160822 Igor
 end;
end;


procedure TCoupleT1_2026.LoadFamSetToStringList(RNo:Integer);
Var i,j,FamFNo:Integer;
begin
 FamFNo:=GetFormNo('FAMSET');
 if Ret[RNo].Frm[FamFNo].Count = 0 then InitFormData(RNo,FamFNo);

 J:=1;
 For i:=1 to 15 do  {stringlist}
 begin
   StringGrid1.Cells[0,i]:=FetchElmFNo(RNo,FamFNo,j);
   StringGrid1.Cells[1,i]:=FetchElmFNo(RNo,FamFNo,j+1);
   StringGrid1.Cells[2,i]:=FetchElmFNo(RNo,FamFNo,j+2);
   StringGrid1.Cells[3,i]:=FetchElmFNo(RNo,FamFNo,j+3);
   j:=J+4;
 end;
end;


Procedure TCoupleT1_2026.SaveSetUp(RNo:Integer;Member,Nm,Sin,LinkIndicator:String;j:Integer);
Var FNo:Integer; //j is the index to Famset
begin
  FNo:=GetFormNo('FAMSET');
  if Ret[RNo].Frm[FNo].Count = 0 then InitFormData(RNo,FNo);
  StoreElm(RNo,FNo,j,Member);
  StoreElm(RNo,FNo,j+1,Nm);
  StoreElm(RNo,FNo,j+2,SIN);
  StoreElm(RNo,FNo,j+3,LinkIndicator);
end;

{ TCplList }

destructor TCplList.Destroy;
var
  i: integer;
begin
(* destroy the records
*)
  for i := 0 to Count-1 do
    Dispose(pcplList(Items[i]));
  inherited;
end;

end.
