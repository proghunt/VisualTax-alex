unit FP_2027CntErr;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,StdCtrls,Dialogs;

Function CountDiagnostics(RetNo: integer):Integer;

implementation

uses vtMulti,vtCommon,FP_2027,FP_2027TrimStr,FP_2027Declare,FP_2027Common,
  FP_2027Common2,vtTrimStr,vtShared;

{ //20150731
Procedure SaveDiagnostic(RetNo:Integer;FrmNm: string; ElmNo : integer; Category:char; ErrMsg:string); overload;
Begin
  RetList[RetNo].AddAudit(Category,ErrMsg,FrmNm,ElmNo);
End;

Procedure SaveDiagnostic(RetNo:Integer;FrmNm: string; ElmNo : integer; ErrMsg:string); overload;
Begin
  //SaveDiagnostic(RetNo,FrmNm,ElmNo,ErrMsg[1],MidStr(ErrMsg,3,60));
  SaveDiagnostic(RetNo,FrmNm,ElmNo,ErrMsg[1],MidStr(ErrMsg,3,Length(ErrMsg)));
End;
}

//Function CountDiagnostics(RetNo: integer):Integer;
//Var i,FNo,ElmNo : integer; FrmNm : string;
//  ErrMsg : string;
// F1,F2,F3:TextFile;
//begin
//  Result := 0;
//with Ret[RetNo] do
//begin
//  ClearDiagnostics;
//  FrmNm := FirstFormName;
//  If FetchElm(RetNo,FirstFormName,1) = '' then
//     SaveDiagnostic(RetNo,'PROFILE',1,'M-First Name missing');
//  // SaveDiagnostic(RetNo,   'INFO',1, 'M-Taxing Province required');
//  If FetchElm(RetNo,FirstFormName,2) = '' then
//    SaveDiagnostic(RetNo,FrmNm,2,'M-Last Name missing');
//  If FetchElm(RetNo,FirstFormName,3) = '' then
//    SaveDiagnostic(RetNo,FirstFormName,3,'M-SIN required');
//  If not ValidSin(FetchElm(RetNo,FirstFormName,3))  then
//    SaveDiagnostic(RetNo,FirstFormName,3,'E-Invalid SIN');
//  If FetchElm(RetNo,FirstFormName,27) = '' then
//   SaveDiagnostic(RetNo,FirstFormName,27,'M-Birth Date missing');
//  If Ret[RetNo].MarStatus = 0 then
//    SaveDiagnostic(RetNo,FirstFormName,9,'M-Marital Status missing');
//
//  If Ret[RetNo].MarStatus <3 then
//  begin
//   If FetchElm(RetNo,FirstFormName,29) = '' then
//       SaveDiagnostic(RetNo,FirstFormName,29,'E-Spouse birthdate missing');
//   If FetchElm(RetNo,FirstFormName,4) = '' then
//      SaveDiagnostic(RetNo,FirstFormName,4,'E-Spouse SIN missing');
//   If FetchElm(RetNo,FirstFormName,17) = '' then
//      SaveDiagnostic(RetNo,FirstFormName,17,'E-Spouse First Name missing');
//   If FetchElm(RetNo,FirstFormName,82) = '' then
//      SaveDiagnostic(RetNo,FirstFormName,82,'E-Spouse Last Name missing');
//  end;
//
//
//  FNo:=GetFormNo('LIFEEVENTS');
//  i:=4;
//  Repeat
//   If ((FetchElmFNo(RetNo,FNo,i)>'') and (Length(FetchElmFNo(RetNo,FNo,i))<4)) then
//      SaveDiagnostic(RetNo,'LIFEEVENTS',i,'E-Life Events-Full year expected');
//   If ((FetchElmFNo(RetNo,FNo,i+1)>'') and (Length(FetchElmFNo(RetNo,FNo,i+1))<4)) then
//      SaveDiagnostic(RetNo,'LIFEEVENTS',i+1,'E-Life Events-Full year expected');
//   Inc(i,9);
//  until i>157;
//
//  {Review Marks}
//  for i :=0 to (ReviewList.Count - 1) do
//  begin
//  ReviewRec := ReviewList.Items[i];
//  if (ReviewRec.RetNo = RetNo) then
//   SaveDiagnostic(RetNo,GetFormName(ReviewRec.FormNo),ReviewRec.FieldId,'R-RvMark'+' '+ GetFormName(ReviewRec.FormNo));
//  end;
//
//  {FldTapes/FLDMEM}
//  for i :=0 to (FList.Count - 1) do
//  begin
//   FRec := FList.Items[i];
//   If Frec.FormName = 'FLDTAPE' then
//   begin
//     FrmNm:=Frec.FormInstName;
//     If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
//     begin
//      SaveDiagnostic(RetNo,FrmNm,126,'A-Tape'+' '+FetchElm(RetNo,FrmNm,121));
//     end;
//   end;
//   If Frec.FormName = 'FLDMEM' then
//   begin
//     FrmNm:=Frec.FormInstName;
//     If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
//     begin
//      SaveDiagnostic(RetNo,FrmNm,17,'N-Note'+' '+FetchElm(RetNo,FrmNm,17));
//     end;
//   end;
//  end; {i}
//
//  Result := ErrorCount;
//end; //with
//End;

Function CountDiagnostics(RetNo: integer):Integer;
Var i,FNo,ElmNo : integer; FrmNm : string[10];
  ErrMsg : string[100];
 F1,F2,F3:TextFile;
begin
  Result := 0;
  with Ret[RetNo] do
  begin
    ClearDiagnostics;
    FrmNm := FirstFormName;
    If FetchElm(RetNo,FirstFormName,1) = '' then
       SaveDiagnostic(RetNo,FrmNm,1,'M-First Name missing');
    If FetchElm(RetNo,FirstFormName,2) = '' then
      SaveDiagnostic(RetNo,FrmNm,2,'M-Last Name missing');
    If FetchElm(RetNo,FirstFormName,3) = '' then
      SaveDiagnostic(RetNo,FirstFormName,3,'M-SIN required');
    If not ValidSin(FetchElm(RetNo,FirstFormName,3))  then
      SaveDiagnostic(RetNo,FirstFormName,3,'E-Invalid SIN');
    If FetchElm(RetNo,FirstFormName,27) = '' then
     SaveDiagnostic(RetNo,FirstFormName,27,'M-Birth Date missing');
    If Ret[RetNo].MarStatus = 0 then
      SaveDiagnostic(RetNo,FirstFormName,9,'M-Marital Status missing');

    If Ret[RetNo].MarStatus <3 then
    begin
     If FetchElm(RetNo,FirstFormName,29) = '' then
         SaveDiagnostic(RetNo,FirstFormName,29,'E-Spouse birthdate missing');
     If FetchElm(RetNo,FirstFormName,4) = '' then
        SaveDiagnostic(RetNo,FirstFormName,4,'E-Spouse SIN missing');
     If FetchElm(RetNo,FirstFormName,17) = '' then
        SaveDiagnostic(RetNo,FirstFormName,17,'E-Spouse First Name missing');
     If FetchElm(RetNo,FirstFormName,82) = '' then
        SaveDiagnostic(RetNo,FirstFormName,82,'E-Spouse Last Name missing');
    end;

    //20140225
    If (Vl(FetchElm(RetNo,'INCPROJECTION',9)) =0)
    and (Vl(FetchElm(RetNo,'CASHFLOW',5))>0)
    Then
     SaveDiagnostic(RetNo,'INCPROJECTION',09,'W-Future income may be missing');



    //20130804
    FNo:=GetFormNo('RETPLAN');
    If Vl(FetchElmFNo(RetNo,FNo,23)) <Vl(FetchElmFNo(RetNo,FNo,34)) then
        SaveDiagnostic(RetNo,'RETPLAN',23,'W-Disposable Income not fully allocated');
    If Vl(FetchElmFNo(RetNo,FNo,23)) >Vl(FetchElmFNo(RetNo,FNo,34)) then
        SaveDiagnostic(RetNo,'RETPLAN',23,'E-Disposable Income over-allocated');



    { 20140225
    begin
    end;
    }

    FNo:=GetFormNo('LIFEEVENTS');
    i:=4;
    Repeat
     If ((FetchElmFNo(RetNo,FNo,i)>'') and (Length(FetchElmFNo(RetNo,FNo,i))<4)) then
        SaveDiagnostic(RetNo,'LIFEEVENTS',i,'E-Life Events-Full year expected');
     If ((FetchElmFNo(RetNo,FNo,i+1)>'') and (Length(FetchElmFNo(RetNo,FNo,i+1))<4)) then
        SaveDiagnostic(RetNo,'LIFEEVENTS',i+1,'E-Life Events-Full year expected');
     Inc(i,9);
    until i>157;

    {Review Marks}
    for i :=0 to (ReviewList.Count - 1) do
    begin
    ReviewRec := ReviewList.Items[i];
    if (ReviewRec.RetNo = RetNo) then
     SaveDiagnostic(RetNo,GetFormName(ReviewRec.FormNo),ReviewRec.FieldId,'R-RvMark'+' '+ GetFormName(ReviewRec.FormNo));
    end;

  {FldTapes/FLDMEM}
    for i :=0 to (FList.Count - 1) do
    begin
     FRec := FList.Items[i];
     If Frec.FormName = 'FLDTAPE' then
     begin
       FrmNm:=Frec.FormName+FRec.FormInst;
       If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
       begin
         //20170728 Igor>>>
         If FetchElmFNo(RetNo,Frec.Formno, 123)='' then
          SaveDiagnostic(RetNo,FrmNm,123,'W-Tape'+'-'+FrmNm+ 'has amounts but is set to NO posting');

         SaveDiagnostic(RetNo,FrmNm,126,'D-Tape'+' '+PaddR(FetchElm(RetNo,FrmNm,121),12)+' '+FetchElm(RetNo,FrmNm,122));

         //SaveDiagnostic(RetNo,FrmNm,126,'A-Tape'+' '+FetchElm(RetNo,FrmNm,121));
         //20170728 Igor<<<
       end;
     end;

    (*
    {FldTapes/FLDMEM}
    for i :=0 to (FList.Count - 1) do
    begin
     FRec := FList.Items[i];
     If Frec.FormName = 'FLDTAPE' then
     begin
       FrmNm:=Frec.FormName+FRec.FormInst;
       If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
       begin
        SaveDiagnostic(RetNo,FrmNm,126,'A-Tape'+' '+FetchElm(RetNo,FrmNm,121));
       end;
     end;
  *)
     If Frec.FormName = 'FLDMEM' then
     begin
       FrmNm:=Frec.FormName+FRec.FormInst;
       If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
       begin
        SaveDiagnostic(RetNo,FrmNm,17,'N-Note'+' '+FetchElm(RetNo,FrmNm,17));
       end;
     end;
    end; {i}

    Result := ErrorCount;
  end;
End;



end.
