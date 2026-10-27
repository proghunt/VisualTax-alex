unit T1_2026eolpack;
//imported 07-28

interface

uses SysUtils,Dialogs,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,
  Controls,Forms,StdCtrls,Printers,T1_2026TrimStr,T1_2026T1Rtns,
  T1_2026Declare,T1_2026Common,T1_2026Common2,
  //T1_2026Progres,
  T1_2026Calc,
  T1_2026ResMeter,//T1_2026PopList,
  T1_2026T1rtns2,T1_2026MSXML2_TLB,comobj;

Const DesignPixelsPerInch = 96;
Const ScMult = 10;  {Scale Multiplier to get accuracy}
Const MxFrmHeight = 980; {960}




Type
 PAckNamesList      = ^AAckRec;
 aAckRec = Record
  GivenName: String[20];
  FamilyName:String[40];
  EfilerNumber:String[5];
  DocumentNo :String[13];
  Accepted : Boolean;
  ErrorClues: Array[1..8] of String[8];
end;



 TYPE
  ACKHTYPE    = record
  TRANSMITTERNO     :STRING[5];
  PREPARERID        :STRING[5];
  BatchId           :String[20];
  //INDRES1           :STRING[10];
  //INDRES2           :STRING[10];
  TransmissionDateTime: String[25];
  TRANSMDATETime     :STRING[20];  //8
  //TRANSMTIME        :STRING[6];
  TRANSFLNO         :STRING[18];
  TRANSMRECS        :STRING[4];
  ACCEPTEDRECS      :STRING[4];
  RejectedRECS      :STRING[4];
//  FILLER            :STRING[62];
 END;

 TYPE
  ACKATYPE   = Record
  DOCUMENTNO  :STRING[13];
  NAME   :STRING[60];
  FILLER      :STRING[9];
 END;


 TYPE
  ACKNTYPE = record
  DOCUMENTNO     :STRING[13];
  NAME           :STRING[60];
  FILLER         :STRING[9];
  ERRCODE1       :STRING[6];
  ERRCODE2       :STRING[6];
  ERRCODE3       :STRING[6];
  ERRCODE4       :STRING[6];
  ERRCODE5       :STRING[6];
  ERRCODE6       :STRING[6];
  ERRCODE7       :STRING[6];
  ERRCODE8       :STRING[6];
 END;

Function GetXmlValue(XmlTag:String;XmlBuffer:String;Var PosFound:Integer):String;
Procedure PrintAckReport(FlName:string;WhichType:String);
Function FindString(S:String;aBuf:String):Integer;
Function GetUntilHitDelimiter(S:String):String;
function ReadFiletoString(fname:string; var abuf:String): boolean;
//function ReadFiletoString (fname:string; var abuf:String): boolean;

Function ScalePrX(X: Longint):LongInt;
Function ScalePrY(Y: Longint):LongInt;

Procedure ReadAckFileHeaderInfo(FlName:String);
// Functions for EFile}
// Procedure BreakAckHdr(FlName:String;A:string);

//Procedure EOLAccReport(FlName:string);
Procedure SelectAckReport(FlName:string);
//Procedure EOLAccNonAcceptedReport(FlName:string);
Procedure EOLAccSUBHEADER;
Procedure EOLNonSUBHEADER;
Procedure EOLClearErrorCodes;

procedure UpdateFromAck(FlNm:String);
//Function UpdateAckStatusFromEOLP(RNo:Integer;SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo:String):boolean;
Function BackUpAckFile(NetFileDir,FileName:String):Boolean;
Function BackUpTedFile(NetFileDir,FlName:String):Boolean;
//Function LoadReturn(RNo:Integer;DataDir:String;FlName:string):Boolean;
Function LoadReturn(DataDir:String;FlName:string):integer;
Function ProcessTransmittedFiles(FlName:string):Boolean;
Procedure ShowTransmittedFiles(FlName:string);
Procedure PrintTransmittedFile(FlName:String);
Function UptoDelim(S:String):String;
{-----------------------------------------}
Var
ScaleX, ScaleY : Word;
//RetNo:Integer;
AckHDR      : ACKHTYPE;
EolOKREC    : ACKATYPE;
EolNOTOKREC : ACKNTYPE;

AckNamesList : TList;
AckRec       : PAckNamesList;

PFile    : TextFile;
HeaderType : String[1];
PRINTCNT, PGNO : Integer;


implementation

uses
  vtMulti,vtCommon,vtDialogs,
  T1_2026,
  T1_2026Main,
  vtTrimStr, vtShared, vtDataBase,
  uADCompClient, // 20150821 igor
  Data.DB; //20170223 Igor

type
  TAskFileVersion = (afvAckRec, afvAckRec2); //20161228 Igor
{-----------------------------------------}

Function ScalePrX(X: Longint):LongInt;
Begin
 Result := (X * ScaleX) div ScMult;
end;

Function ScalePrY(Y: Longint):LongInt;
Begin
 Result := (Y * ScaleY) div ScMult;
end;

Procedure SelectAckReport(FlName:string);
begin
 If Vl(AckHdr.AcceptedRecs)>0 then
  PrintAckReport(FlName,'A');
 If Vl(AckHdr.RejectedRecs)>0 then
  PrintAckReport(FlName,'R');
end;

//20161228 Igor >>>
function FileSize(fileName : String) : Int64;
var
  sr : TSearchRec;
begin
  if FindFirst(fileName, faAnyFile, sr ) = 0 then
    result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
  else
    result := -1;
  SysUtils.FindClose(sr) ;
end;

function CheckAskFileVersion(AFileName : String): TAskFileVersion;
var
  fSize, RecSize, Rec2Size: Int64;
begin
  Result := afvAckRec;
  fSize := FileSize(AFileName);
  RecSize := SizeOf(TAckRec);
  Rec2Size := SizeOf(TAckRec2);
  if ((fSize mod Rec2Size) = 0) and
     ((fSize mod RecSize) <> 0) then
    Result := afvAckRec2;
end;
//20161228 Igor <<<

Procedure PrintAckReport(FlName:string;WhichType:String);
Const
  Delim='*';
Var
//20161228 Igor >>>
  AckRec2: TAckRec2;
  TedFile2: File of TAckRec2;
  AckRec: TAckRec;
  TedFile: File of TAckRec;
  AskFileVersion: TAskFileVersion;
//20161228 Igor <<<
  i: Integer;
  F1: TextFile;
  hdc: THandle;
  PageX, PageY: LongInt;
  Msg, TransDate, TransTime: string;
  x, y, YIncr: Longint;
  A: string;
  MXCNT, TOTPAGES: Integer;
  Tab1, Tab2, Tab3, Tab4, Tab1b: integer;
  DateTime: String[30];
  Title1: string[30];
  WList: TStringList;
  s: String;
//20161228 Igor >>>
  procedure OpenFileForRead;
  Begin
    case AskFileVersion of
      afvAckRec:
        Begin
          AssignFile(TedFile, FlName);
          Reset(TedFile);
        End;
      afvAckRec2:
        Begin
          AssignFile(TedFile2, FlName);
          Reset(TedFile2);
        End;
    end;
  End;
  function ReadNext: Boolean;
  var
    k: Integer;
  begin
    case AskFileVersion of
      afvAckRec:
        Begin
          Result := not Eof(TedFile);
          if Result then
            Read(Tedfile, AckRec);
        End;
      afvAckRec2:
        Begin
          Result := not Eof(TedFile2);
          if Result then
          begin
            Read(Tedfile2, AckRec2);
            AckRec.returnTypeName       := AckRec2.returnTypeName;
            AckRec.CVIndicator          := AckRec2.CVIndicator;
            AckRec.FamilyName           := AckRec2.FamilyName;
            AckRec.GivenName            := AckRec2.GivenName;
            AckRec.TransmitBatchName    := AckRec2.TransmitBatchName;
            AckRec.ResultCode           := AckRec2.ResultCode;
            AckRec.DateTransmitted      := AckRec2.DateTransmitted;
            AckRec.TimeTransmitted      := AckRec2.TimeTransmitted;
            AckRec.DateReceived         := AckRec2.DateReceived;
            AckRec.TimeReceived         := AckRec2.TimeReceived;
            AckRec.EfilerNumber         := AckRec2.EfilerNumber;
            AckRec.DocumentNo           := AckRec2.DocumentNo;
            AckRec.TransmissionNo       := AckRec2.TransmissionNo;
            for k := 1 to 6 do
              AckRec.ErrorCode[k]       := AckRec2.ErrorCode[k];
            AckRec.EFresultType         := AckRec2.EFresultType;
          end;
        End;
    end;
  end;
  procedure CloseAskFile;
  Begin
    case AskFileVersion of
      afvAckRec:
        CloseFile(TedFile);
      afvAckRec2:
        CloseFile(TedFile2);
    end;
  End;
//20161228 Igor <<<
Begin

  if Printer.Printing then
  begin
    if MessageDlg('Acc report. Printer temporarily busy. Try again?',
      mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit;
  end;

   // if not printer.printdialog.execute then exit;  //20140130
  If MainFormT1.PrintDialogItem.Execute =false then exit;  //20140126  not available here


  Printer.BeginDoc;
  Try
    PageX  := Printer.PageWidth;
    PageY  := Printer.PageHeight;
    ScaleX := (PageX * ScMult) div 614; {to get the decimals}
    ScaleY := (PageY * ScMult) div MxFrmHeight;

    hdc :=  Printer.Canvas.Handle;
    Printer.Canvas.Font.Name := DefFontName;
    YIncr := 20;
    X := 20;
    Y :=20;

    With Printer.Canvas do
    begin
      PGNO := 0;
      MXCNT := 35;  {single lines on page}
      If WhichType='A' then
        Title1 :='ACCEPTED RECORDS'
      Else
        Title1 :='NON-ACCEPTED RECORDS';

      TOTPAGES := StrToInt(AckHDR.ACCEPTEDRECS) div MXCNT + 1;
      PRINTCNT :=0; PGNO := PGNO + 1;
      Font.Size := 10; Font.Style := [];
      TextOut(ScalePrX(x),ScalePrY(Y),DateToYYYYMMDD(NOW));
      Font.Size := 12; Font.Style := [fsBold];
      TextOut(ScalePrX(230),ScalePrY(Y),Title1);
      Font.Size := 10; Font.Style := [];
      TextOut(ScalePrX(500),ScalePrY(Y), 'Page ' + IntToStr(PgNo) + ' of ' + IntToStr(TOTPAGES));
      y := Y + YIncr;
      // TextOut(ScalePrX(160),ScalePrY(Y), 'CRA TRANSMISSION CONFIRMATION NUMBER: ' + AckHdr.TransmitterNo+AckHdr.TRANSFLNO); y := Y + YIncr;
      TextOut(ScalePrX(220),ScalePrY(Y), 'For transmitted file: ' + AllTrim(AckHdr.BatchId)); y:=Y+YIncr;
      TextOut(ScalePrX(220),ScalePrY(Y), 'Transmitted number of returns: ' + AllTrim(AckHdr.TRANSMRECS));
      Font.Size := 10;
      Font.Style := [];
      y := Y + YIncr *2;
      Tab1 := 150;
      Tab2 := 200;
      Tab3 := 300;
      Tab4 := 400;
      //Tab1 := 100; Tab2 := 200; Tab3 := 300; Tab4 := 400;
      TextOut(ScalePrX(Tab1),ScalePrY(Y),'Transmitter');
      //TextOut(ScalePrX(Tab2),ScalePrY(Y),'Preparer');
      TextOut(ScalePrX(Tab3),ScalePrY(Y),'Transmission');
      TextOut(ScalePrX(Tab4),ScalePrY(Y),'Number of Returns');
      y := Y + YIncr;
      TextOut(ScalePrX(Tab1),ScalePrY(Y),'Number');
      //  TextOut(ScalePrX(Tab2),ScalePrY(Y),'Number');
      TextOut(ScalePrX(Tab3),ScalePrY(Y),'Date & Time ');
      If WhichType='A' then
        TextOut(ScalePrX(Tab4),ScalePrY(Y),'Accepted')
      else
        TextOut(ScalePrX(Tab4),ScalePrY(Y),'Rejected');
      y := Y + YIncr;
      TextOut(ScalePrX(Tab1),ScalePrY(Y),'============');
      TextOut(ScalePrX(Tab2),ScalePrY(Y),'============');
      TextOut(ScalePrX(Tab3),ScalePrY(Y),'============');
      TextOut(ScalePrX(Tab4),ScalePrY(Y),'============');

      {ACCSUBHEADER; }
      DATETIME := AckHdr.TransmissionDateTime;
      y := Y + YIncr;
      TextOut(ScalePrX(Tab1),ScalePrY(Y), AckHdr.TRANSMITTERNO);
      // TextOut(ScalePrX(Tab2),ScalePrY(Y), AckHdr.PREPARERID);
      TextOut(ScalePrX(Tab3),ScalePrY(Y), DATETIME);
      If WhichType='A' then
      Begin
        s:=FormatAccNonAccRecordCnt(AckHdr.ACCEPTEDRECS);
        TextOut(ScalePrX(Tab4+25),ScalePrY(Y),s);
      end
      Else
      Begin
        s:=FormatAccNonAccRecordCnt(AckHdr.RejectedRECS);
        TextOut(ScalePrX(Tab4+25),ScalePrY(Y),s);
      end;
      y := Y + YIncr * 2;
      Tab1 := 50; Tab1b:=150;Tab2 := 300; Tab3 := 400;  //20140130 tab2:=200
      TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Document Control');
      TextOut(ScalePrX(Tab1b),ScalePrY(Y), 'Transmission No');
      TextOut(ScalePrX(Tab2),ScalePrY(Y), 'Client'+Chr(39)+'s First Name');
      TextOut(ScalePrX(Tab3),ScalePrY(Y), 'Client'+Chr(39)+'s Last Name');

      y := Y + YIncr;
      TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Number');
      y := Y + YIncr;
      TextOut(ScalePrX(Tab1),ScalePrY(Y), '================');
      TextOut(ScalePrX(Tab1b),ScalePrY(Y), '================');
      TextOut(ScalePrX(Tab2),ScalePrY(Y), '================');
      TextOut(ScalePrX(Tab3),ScalePrY(Y), '================');

//20161228 Igor >>>
      AskFileVersion := CheckAskFileVersion(FlName);
      OpenFileForRead;
      //AssignFile(TedFile, FlName);
      //Reset(TedFile);
      //while not Eof(TedFile) do
      while ReadNext do
      begin
        //Read(Tedfile, AckRec);
//20161228 Igor <<<
        //  AckRec:=AckNamesList.Items[i];
        //now print the record
        //If (WhichType='A') and (AckRec.accepted=False) then  continue  //skip the remaing logic in loop
        //Else If (WhichType='R') and (AckRec.accepted=True) then Continue;  //skip remaining logic in loop
        //20140124
        If (WhichType='A') and (AckRec.EFresultType <> EFaccepted){(AckRec.accepted=False)} then
          continue  //skip the remaing logic in loop
        Else
        If (WhichType='R') and (AckRec.EFresultType=EFaccepted){(AckRec.accepted=True)} then
          Continue;  //skip remaining logic in loop

        y := Y + YIncr;
        TextOut(ScalePrX(Tab1),ScalePrY(Y),AckRec.DOCUMENTNO);
        TextOut(ScalePrX(Tab1b),ScalePrY(Y),AckRec.TransmissionNo);  //20140130
        TextOut(ScalePrX(Tab2),ScalePrY(Y),RTRIM(LEFTStr(AckRec.GivenName,30)));
        TextOut(ScalePrX(Tab3),ScalePrY(Y),RTRIM(LeftStr(AckRec.FamilyName,30)));
        If WhichType='R' then
        Begin
          y := Y + YIncr;
          TextOut(ScalePrX(Tab1),ScalePrY(Y),'Error Codes');
          TextOut(ScalePrX(Tab2),ScalePrY(Y),
            AckRec.ERRorCode[1]+ '  '+
            AckRec.ERRorCode[2]+ '  '+
            AckRec.ERRorCode[3]+ '  '+
            AckRec.ERRorCode[4]+ '  '+
            AckRec.ERRorCode[5]+ '  '+
            AckRec.ERRorCode[6]+ '  ');
              { 20120215
              +
              AckRec^.ERRorClues[7]+ '  '+
              AckRec^.ERRorClues[8]+ '  ');
              }
          y := Y + YIncr;
          PRINTCNT := PRINTCNT + 1;
        end;
        PRINTCNT := PRINTCNT + 1;

        IF PRINTCNT >= MXCNT THEN  //print report header
        begin
          X := 20;
          Y :=20;
          Printer.NewPage;
          PrintCnt :=0;
          Inc(PgNo);
          Font.Size := 10;
          Font.Style := [];
          TextOut(ScalePrX(x),ScalePrY(Y),DateToYYYYMMDD(NOW));
          Font.Size := 12; Font.Style := [fsBold];
          TextOut(ScalePrX(230),ScalePrY(Y),Title1);
          Font.Size := 10; Font.Style := [];
          TextOut(ScalePrX(500),ScalePrY(Y),
            'Page ' + IntToStr(PgNo) + ' of ' + IntToStr(TOTPAGES));
          y := Y + YIncr;
          TextOut(ScalePrX(180),ScalePrY(Y), 'TRANSMISSION FILE NUMBER ' +
            AckHdr.TRANSFLNO); y := Y + YIncr;
          TextOut(ScalePrX(220),ScalePrY(Y), 'For transmitted file: ' +
            AckHdr.BatchId+'.XML');
          Font.Size := 10; Font.Style := [];
          y := Y + YIncr *2;
          Tab1 := 100; Tab2 := 200; Tab3 := 300; Tab4 := 400;
          TextOut(ScalePrX(Tab1),ScalePrY(Y),'Transmitter');
          TextOut(ScalePrX(Tab2),ScalePrY(Y),'Preparer');
          TextOut(ScalePrX(Tab3),ScalePrY(Y),'Transmission');
          TextOut(ScalePrX(Tab4),ScalePrY(Y),'Number of Returns');
          y := Y + YIncr;
          TextOut(ScalePrX(Tab1),ScalePrY(Y),'Number');
          TextOut(ScalePrX(Tab2),ScalePrY(Y),'Number');
          TextOut(ScalePrX(Tab3),ScalePrY(Y),'Date & Time ');
          If WhichType='A' then
            TextOut(ScalePrX(Tab4),ScalePrY(Y),'Accepted')
          else
            TextOut(ScalePrX(Tab4),ScalePrY(Y),'Rejected');

          y := Y + YIncr;
          TextOut(ScalePrX(Tab1),ScalePrY(Y),'============');
          TextOut(ScalePrX(Tab2),ScalePrY(Y),'============');
          TextOut(ScalePrX(Tab3),ScalePrY(Y),'============');
          TextOut(ScalePrX(Tab4),ScalePrY(Y),'============');

          {ACCSUBHEADER; }
          DATETIME :=AckHdr.TransmDateTime;
          y := Y + YIncr;
          TextOut(ScalePrX(Tab1),ScalePrY(Y), AckHdr.TRANSMITTERNO);
          TextOut(ScalePrX(Tab2),ScalePrY(Y), AckHdr.PREPARERID);
          TextOut(ScalePrX(Tab3),ScalePrY(Y), DATETIME);
          TextOut(ScalePrX(Tab4),ScalePrY(Y),'    '+FormatAccNonAccRecordCnt(AckHdr.ACCEPTEDRECS));
          y := Y + YIncr * 2;
          Tab1 := 50; Tab2 := 200; Tab3 := 400; {Tab4 := 400;}
          TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Document Control');
          TextOut(ScalePrX(Tab2),ScalePrY(Y), 'Client'+Chr(39)+'s First Name');
          TextOut(ScalePrX(Tab3),ScalePrY(Y), 'Client'+Chr(39)+'s Last Name');
          y := Y + YIncr;
          TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Number');
          y := Y + YIncr;
          TextOut(ScalePrX(Tab1),ScalePrY(Y), '================');
          TextOut(ScalePrX(Tab2),ScalePrY(Y), '================');
          TextOut(ScalePrX(Tab3),ScalePrY(Y), '================');
        end; //print header
      end;  //i  //repeat  //20140119
    end; //printer canvas
    //Printer.EndDoc; //Do not close here}
    //except
  Finally
    Printer.EndDoc; //Do not close here}
    //on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end; //try
//20161228 Igor >>>
  CloseAskFile;
  //Close(TedFile);
//20161228 Igor <<<
end;

Procedure EOLClearErrorCodes;
begin
  EolNotOkRec.ErrCode1:=Space(6);
  EolNotOkRec.ErrCode2:=Space(6);
  EolNotOkRec.ErrCode3:=Space(6);
  EolNotOkRec.ErrCode4:=Space(6);
  EolNotOkRec.ErrCode5:=Space(6);
  EolNotOkRec.ErrCode6:=Space(6);
  EolNotOkRec.ErrCode7:=Space(6);
  EolNotOkRec.ErrCode8:=Space(6);
end;

Procedure EOLAccSUBHEADER;
Var DateTime : string;
Begin
  DATETIME :=AckHdr.TRANSMDATETime;
  {
  MidStr(AckHdr.TRANSMDATE, 3, 2) + '/'
           + MidStr(AckHdr.TRANSMDATE, 5, 2) +
           '/' + RIGHTStr(AckHdr.TRANSMDATE, 2) + ' ' +
           LeftStr(AckHdr.TRANSMTIME, 2) + ':' +
           MidStr(AckHdr.TRANSMTIME, 3, 2) + ':' +
           RIGHTStr(AckHdr.TRANSMTIME, 2);
 }
End;

Procedure EOLNonSUBHEADER;
Var DateTime : string;
Begin
  DATETIME :=AckHdr.TRANSMDATETime;
  {
  LEFTStr(AckHdr.TRANSMDATE, 4) + '/' +
           MidStr(AckHdr.TRANSMDATE, 5, 2) +
           '/' + RightStr(AckHdr.TRANSMDATE, 2) +
            ' ' + LeftStr(AckHdr.TRANSMTIME, 2) +
           ':' + MidStr(AckHdr.TRANSMTIME, 3, 2) +
            ':' + RightStr(AckHdr.TRANSMTIME, 2);
  }
End;

(*
Procedure BreakAckHdr(FlName:String;A:string);
Const Delim='*';
Var i,AcceptedReturns,NonAcceptedReturns:integer;
    Wlist:TStringList;
    F1 : TextFile;
    s:String;
begin
{
  AcceptedReturns:=0;
  NonAcceptedReturns:=0;
  AckHdr.TRANSFLNO  := ExtractFileName(FlName);
}
 {
  Assign(F1,FlName);
  Reset(F1);
  ReadLn(F1, A);  //First ISA - 997?
  Repeat
   ReadLn(F1, A);
   ShowMessage(A);
 }

   If LeftStr(A,3) ='GS'+Delim then
   begin
     Wlist := TStringList.Create;
     ParseWords(A,Delim,WList);
     AckHdr.TRANSMITTERNO := WList[3];
     WList.Free;
   end;

   If LeftStr(A,4) ='BTA'+Delim then
   begin
     Wlist := TStringList.Create;
     ParseWords(A,Delim,WList);
     If WList[1] = 'AT' then
      Inc(AcceptedReturns)
     Else
      Inc(NonAcceptedReturns);
     WList.Free;
   end;

   If LeftStr(A,4) ='BTI'+Delim then
   begin
     Wlist := TStringList.Create;
     ParseWords(A,Delim,WList);
     AckHdr.PreparerId  := LeftStr(Wlist[8],5);
     WList.Free;
   end;

   If LeftStr(A,7) ='REF'+Delim+'TN'+Delim then
   begin
     Wlist := TStringList.Create;
     ParseWords(A,Delim,WList);
     AckHdr.TRANSMDATE    := LeftStr(WList[2],8);
     AckHdr.TRANSMTIME    := MidStr(WList[2],9,6);
     WList.Free;
   end;

   If LeftStr(A,7) ='REF'+Delim+'BT'+Delim then
   begin
     Wlist := TStringList.Create;
     ParseWords(A,Delim,WList);
     AckHdr.IndRes1  := WList[2];
     WList.Free;
   end;

//  until EOF(F1);

{
  AckHdr.AcceptedRecs  := IntToStr(AcceptedReturns);
  AckHdr.RejectedRecs := IntToStr(NonAcceptedReturns);
}
//  CloseFile(F1);
end;
*)

Function LoadReturn(DataDir:String;FlName:string):integer;
var
  //20150821 igor
  FDConnection: TADConnection;
  Table: TADTable;
begin
  Result := 0;

  FDConnection := TADConnection.Create(nil);
  Table := TADTable.Create(nil);
  try
    //20150925 igor
    if SetTableName(FDConnection, Table, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name')
    then
      //20170223 Igor >>>
      //if Table.FindKey([FlName]) = True then
      if Table.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
      //201702232 Igor <<<
      begin
        Result := ReadReturn(Datadir,FlName);
      end;
  finally
    FreeAndNil(FDConnection);
    FreeAndNil(Table);
  end;
end;

Function BackUpAckFile(NetFileDir,FileName:String):Boolean;
Var DestDir:String; FlNm:String;
begin
 Result:=False;
 NetFileDir := GetEolPNetFileDir;  //20120213
 DestDir:=NetFileDir+'\'+'Processed';
 FlNm:=ExtractFileName(FileName);
 If DirectoryExists(DestDir) = false then ForceDirectories(DestDir);  //20120213
 If DirectoryExists(DestDir) then
 begin
   If CopyFile(FileName,DestDir+'\'+FLNm) then
   begin
    result:=True;
    ShowMessage(FileName + ' copied to folder: '+DestDir);
    Exit;
   end
   else
   begin
    ShowMessage(FileName + ' was NOT copied again to folder: '+DestDir);
    Result:=False;
   end;
 end
 Else  //no backup directory
 Begin
  ShowMessage('Directory '+NetFileDir+'\'+'Processed' + ' cannot be created');
  Result:=False;
 end;
end;


Procedure ShowTransmittedFiles(FlName:string);
{
Type
 PList      = ^AckRec;
 {
 AnyRec = Record
  GivenName: String[20];
  FamilyName:String[40];

end;
}
Var
 AckRec:TAckRec;
 TedFile:File of TAckRec;
 i,k,m:Integer;RetFileName,LastNm,FirstNm,Sin,Str:String;
   F1 : TextFile; A:String;
    TempList:TStringList;
   aBuf:String;
   aList:TList;
  // aRec  : PList;  //structure of list of records
   PosFound:Integer;
begin
  AssignFile(TedFile, FlName);
  AList:=TList.Create;
  try
    FileMode := fmOpenRead;
    Reset(TedFile);
    try
      // Display the file contents
      while not Eof(TedFile) do
      begin
        Read(Tedfile, AckRec);
        ShowMessage(AckRec.FamilyName);
      end;
    finally
      CloseFile(TedFile); //20161226 Igor
    end;
  finally
    AList.free; //20161226 Igor
  end;
  (*
  //put names into a list
  ReadFiletoString(flName,abuf);
  For i:=1 to 200 do
  Begin
   New(ARec);
   ARec.GivenName:=GetXmlValue('<comm:GivenName',ABuf,PosFound);
   If PosFound>0 then Delete(aBuf,1,PosFound);

   ARec.FamilyName:=GetXmlValue('<comm:FamilyName',ABuf,PosFound);
   If PosFound>0 then Delete(aBuf,1,PosFound);

   If AllTrim(Arec.FamilyName)>'' then
     aList.Add(ARec);
  End;
  *)

 (*
  TempList:=TStringList.Create;
  For i:=0 to aList.Count-1 do
  Begin
   Arec:=Alist[i];
   Templist.Add(PaddR(ARec.FamilyName,30)+PaddR(ARec.GivenName,15)); //+PaddR(Sin,9));
  end;
  alist.free;

  //show in the screen
  SomeList := TStringList.Create;
  SomeList.Sorted := True;
  SomeCaption := 'Files included in TED file';
  For i:=0 to TempList.count-1 do SomeList.Add(TempList[i]);
  TempList.Free;
  Application.CreateForm(TPoplist,PopList);
  PopList.ShowModal;
  Try
   SomeList.Free;
   PopList.Release;
  except
  end;
 *)
end;

Procedure PrintTransmittedFile(FlName:String);
Type
 PList      = ^AnyRec;
 AnyRec = Record
  GivenName: String[20];
  FamilyName:String[40];
end;
Var i,k,m:Integer;RetFileName,LastNm,FirstNm,Sin,Str:String;
   F1 : TextFile; A:String;
    TempList:TStringList;
   aBuf:String;
   aList:TList;
   aRec  : PList;  //structure of list of records
   PosFound:Integer;
   FileNm2,Hdr1,Hdr2,Hdr3,s:string;
begin
{ TODO -oCon : leaks memory, too many copies... }
  //put names into a list
  AList:=TList.Create;
  ReadFiletoString(flName,abuf);
  For i:=1 to 100 do
  Begin
   New(ARec);
   ARec.GivenName:=GetXmlValue('<comm:GivenName',ABuf,PosFound);
   If PosFound>0 then Delete(aBuf,1,PosFound);

   ARec.FamilyName:=GetXmlValue('<comm:FamilyName',ABuf,PosFound);
   If PosFound>0 then Delete(aBuf,1,PosFound);

   If AllTrim(Arec.FamilyName)>'' then
     aList.Add(ARec);
  End;

  TempList:=TStringList.Create;
  For i:=0 to aList.Count-1 do
  Begin
   Arec:=Alist[i];
   Templist.Add(PaddR(ARec.FamilyName,30)+PaddR(ARec.GivenName,15)); //+PaddR(Sin,9));
  end;
  alist.free;

  SomeList.Clear; // := TStringList.Create;
  SomeList.Sorted := True;
  SomeCaption := 'Files included in TED file';
  For i:=0 to TempList.count-1 do SomeList.Add(TempList[i]);
  TempList.Free;

 If SomeList.Count =0 then exit;
 s:='Returns included in TED file';
 Hdr1 := PaddR(S,70)+' '+PaddR(DateToMonthDayYear(Date),20);
 Hdr2 := FlName; //'Name            File Name';
 Hdr3 := FilledStr(80,'=')+FilledStr(14,'=');
 FileNm2:=AppDir+'\'+'TempFile';
 SomeList.SaveToFile(FileNm2);
 // SomeList.Free; //20160301 Igor
 If PrintAListing(FileNm2,Hdr1,Hdr2,Hdr3) = True then
  ShowTimedMsg('Printing Completed',1200);

end;

Function UptoDelim(S:String):String;
Const ElemSep='*'; LineSep=EfDelim;
Var m:Integer;
begin
    result:=s;
    m:=Pos(LineSep,S);
    If m>0 then result:=LeftStr(S,m-1);
    m:=Pos(LineSep,S);
    If m>0 then result:=LeftStr(S,m-1);
end;

Function ProcessTransmittedFiles(FlName:string):Boolean;
Const Delim='*';
Type
 PList      = ^AnyRec;
 anyRec = Record
  GivenName: String[20];
  FamilyName:String[40];
  Sin      :String[9];
end;


var
  //20150821 igor
  FDConnection: TADConnection;
  Table: TADTable;

    i,k:Integer; Reslt:Integer;RetFileName:String;
    F1 : TextFile; A:String; TempList:TStringList;
    WList:TStringList;s:String;
    NetFileDir:String;
    CopyResult:Boolean;
    Alist:TList;
    aRec:Plist;
    aBuf:String;
    PosFound:Integer;

    ClientDB: String;
begin

  //get return data into an list array
  ReadFiletoString(flName,abuf);
  AList:=TList.Create;
  ReadFiletoString(flName,abuf);
  For i:=1 to 80 do
  Begin
   New(ARec);

   ARec.Sin:=GetXmlValue('<tp:TaxpayerSocialInsuranceNumber',ABuf,PosFound);
   If PosFound>0 then Delete(aBuf,1,PosFound);

   ARec.GivenName:=GetXmlValue('<comm:GivenName',ABuf,PosFound);
   If PosFound>0 then Delete(aBuf,1,PosFound);

   ARec.FamilyName:=GetXmlValue('<comm:FamilyName',ABuf,PosFound);
   If PosFound>0 then Delete(aBuf,1,PosFound);

   If AllTrim(Arec.SIN)>'' then
     aList.Add(ARec);
  End;
  //20160226 Igor >>>>
  //20170112 Igor >>> (OptRec have overloaded params after init)
//  If LicenseLevel in anyMulti then
//    ClientDB := User.Tax_Dir + '\' + ClientsDBLite
//  else
  //20170112 Igor <<<
    ClientDB := OptRec.Dir_Cur + '\' + ClientsDBLite;
  if not SetTableName(FDConnection, Table,
                      ClientDB, ClientsTableLite, UpperCase ('File_Name')) then
  Begin
    if assigned(FDConnection) then
      freeAndNil(FDConnection);
    if assigned(Table) then
      freeAndNil(Table);
    exit;
  End;
//  FDConnection := TADConnection.Create(nil);
//  FDConnection.DriverName := 'SQLite';

//  Table := TADTable.Create(nil);
//  Table.Connection := FDConnection;
  try
//    FDConnection.Params.Values['DataBase'] := OptRec.Dir_Cur + '\' + ClientsDBLite;
//
//  //20120222
//   //If LeftStr(LicenseLevel,8)  = 'T1 Multi' then   //??
//   If LicenseLevel in anyMulti then   //??
//      FDConnection.Params.Values['DataBase'] := User.Tax_Dir + '\' + ClientsDBLite;
//
//   Table.TableName := ClientsTableLite;
//   Table.IndexName := UpperCase ('File_Name'); // 20150920 Igor
//   Table.Open;
  //20160226 Igor <<<<<

  For i:=0 to Alist.count-1 do
  Begin
   aRec:=Alist[i];
   RetFileName:=LeftStr(aRec.Sin,8)+'.'+RightStr(aRec.Sin,1);  // only the file name in
   //20170223 Igor >>>
   //If Table.FindKey([RetFileName]) then
   if Table.Locate('FILE_NAME', RetFileName, [loCaseInsensitive]) then
   //20170223 Igor <<<
   begin
     Try
       Table.Edit;
       Table.FieldByName('EF_Status').AsString:='04';
       //get dcn from T183
       TempList:=TStringList.Create;
       s:='';
       s:=GetValueFromDataFile(OptRec.Dir_cur+'\'+RetFileName,'T183',21);
       If Length(s)=13 then
       begin
        Table.FieldByName('DCN_NO').AsString:=RightStr(s,8);
        Table.Post;
       end;
       NetFileDir := GetEolPNetFileDir;
       If BackupTedFile(NetFileDir,FlName) = True then
         ShowTimedMsg('Done...TED File moved to Processed folder',1400);
     finally
      TempList.Free;
     end;
   end
   Else
      ShowTimedMsg('Return '+RetFileName+' not found',1600);
  end; //i
  finally
    FreeAndNil(FDConnection);
    FreeAndNil(Table);
  end;
End;

 (*
  //read ted file;
  Assign(F1,FlName);
  Reset(F1);
  Repeat
   ReadLn(F1, A);
   If A='' then break;  //actually there is only one record
   //If LeftStr(A,3) ='GE'+Delim then break; //eof file
   k:=Pos('N1'+Delim+'TP'+Delim+Delim+'34'+Delim,A);
   if k>0 then
   begin
    RetFileName:=MidStr(A,k+10,9);
    RetFileName:=LeftStr(RetFileName,8)+'.'+RightStr(RetFileName,1);
    //ShowMessage('fl'+RetFileName);
    If Table1.FindKey([RetFileName]) then
     begin
       Table1.Edit;
       Table1.FieldByName('EF_Status').AsString:='04';
       Table1.Post;
     end
     Else
     ShowTimedMsg('Return '+RetFileName+' not found',1200);
   end;   //segment with sin
  until Eof(F1);  //LeftStr(A,3) ='GE'+Delim;
  Table1.Close;
  Table1.Free;
  CloseFile(F1);
  NetFileDir := GetEolPNetFileDir;
  If BackupTedFile(NetFileDir,FlName) = True then
   ShowTimedMsg('Done...TED File moved to Processed folder',1400);
 Except
 on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end; //try
end;
*)

Function BackUpTedFile(NetFileDir,FlName:String):Boolean;
//flname is full path
Var DestDir:String; FlNm,NewFlName:String;DestFullFlNm:String;
  CopyResult:Boolean;
begin
 Result:=False;
 DestDir:=NetFileDir+'\'+'Processed';
 FlNm:=ExtractFileName(FlName);
 DestFullFlNm:=DestDir+'\'+FlNm;
 ForceDirectories(DestDir);
 If DirectoryExists(DestDir) then
 begin
   If MyCopyFile(FlName,DestFullFlNm)=True then
   begin
    Sysutils.DeleteFile(FlName);
    result:=True;
    Exit;
   end
   else
   begin
    Result:=False;
    exit;
   end;
 end
 Else  //no backup directory
 Begin
  ShowMessage('Directory '+DestDir + ' cannot be created');
  Result:=False;
 end;
end;

(*
Function UpdateAckStatusFromEolP(RNo:Integer;SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo:String):boolean;
Var FNo:Integer;
begin
 //ShowTimedMsg('Updating the Ack status',1000);

 Result:=False;
 If RNo>0 then
 begin
   FNo:=GetFormNo('STATUS');
   If Ret[RNo]^.Frm[Fno].Count =0 then InitFormData(RNo,FNo);
   Ret[RNo]^.EfStatus:=Status;
   StoreElm(RNo,FNo,15,Status);
   StoreElm(RNo,FNo,21,AckRcvdDt);
   StoreElm(RNo,FNo,22,AckRcvdDt);
   StoreElm(RNo,FNo,23,AckRcvdTm);
   StoreElm(RNo,FNo,31,ConfirmationNo);  //conf, or ack

   StoreElm(RNo,FNo,16,AckHdr.BatchId+'.Xml');

   StoreElm(RNo,FNo,24,RmvLeadingZeros(EolNOTOKREC.ERRCODE1));
   StoreElm(RNo,FNo,25,RmvLeadingZeros(EolNOTOKREC.ERRCODE2));
   StoreElm(RNo,FNo,26,RmvLeadingZeros(EolNOTOKREC.ERRCODE3));
   StoreElm(RNo,FNo,27,RmvLeadingZeros(EolNOTOKREC.ERRCODE4));
   StoreElm(RNo,FNo,28,RmvLeadingZeros(EolNOTOKREC.ERRCODE5));
   StoreElm(RNo,FNo,29,RmvLeadingZeros(EolNOTOKREC.ERRCODE6));
   StoreElm(RNo,FNo,30,RmvLeadingZeros(EolNOTOKREC.ERRCODE7));
   Ret[RNo].Changed:=True;
   Result:=True;
   Exit;
 end;
end;
*)

Function GetUntilHitDelimiter(S:String):String;
Var i:Integer;
Begin
 Result:='';
 For i:=1 to Length(s) do
 Begin
  If (S[i]= '<') or (S[i]= '>') then
   exit
  else
   result:=Result+S[i];
  end;
end;

Function FindString(S:String;aBuf:String):Integer;
Var i,k:Integer;
Begin
  k:=Pos(s,aBuf);
  If K>0 then
   begin Result:=k;Exit;end
  else
  Result:=0;
end;


function ReadFiletoString(fname:string; var abuf:String): boolean;
var
 strStream: TStringStream;
 FileStream: TFileStream;
begin
  //read the data into the buffer
  FileStream := TFileStream.Create(fname, fmOpenRead);
  strStream := TStringStream.Create('') ;
  strStream.CopyFrom(FileStream, FileStream.Size);
  aBuf:=strStream.DataString;
  FileStream.free;
  StrStream.Free;  //20120120
end;


Procedure ReadAckFileHeaderInfo(FlName:String);  //20120121 NEW John's
//20161228 Igor >>>
Var
  AckRec2: TAckRec2;
  TedFile2: File of TAckRec2;
  AckRec: TAckRec;
  TedFile: File of TAckRec;
  AskFileVersion: TAskFileVersion;
//20161228 Igor <<<
  BatchTotalRecordCount, AcceptedRecs, RejectedRecs: Integer;

  i, j, r: Integer;
  aString: String;
  Valu, s, fullValue: String;
  RejectedReturn: boolean;
  abuf: string;
  ErrorClueCnt: Integer;
  PosFound, nextRetPos: Integer;
  K: String;
//20161228 Igor >>>
  procedure OpenFileForRead;
  Begin
    case AskFileVersion of
      afvAckRec:
        Begin
          AssignFile(TedFile, FlName);
          Reset(TedFile);
        End;
      afvAckRec2:
        Begin
          AssignFile(TedFile2, FlName);
          Reset(TedFile2);
        End;
    end;
  End;
  function ReadNext: Boolean;
  var
    k: Integer;
  begin
    case AskFileVersion of
      afvAckRec:
        Begin
          Result := not Eof(TedFile);
          if Result then
            Read(Tedfile, AckRec);
        End;
      afvAckRec2:
        Begin
          Result := not Eof(TedFile2);
          if Result then
          begin
            Read(Tedfile2, AckRec2);
            AckRec.returnTypeName       := AckRec2.returnTypeName;
            AckRec.CVIndicator          := AckRec2.CVIndicator;
            AckRec.FamilyName           := AckRec2.FamilyName;
            AckRec.GivenName            := AckRec2.GivenName;
            AckRec.TransmitBatchName    := AckRec2.TransmitBatchName;
            AckRec.ResultCode           := AckRec2.ResultCode;
            AckRec.DateTransmitted      := AckRec2.DateTransmitted;
            AckRec.TimeTransmitted      := AckRec2.TimeTransmitted;
            AckRec.DateReceived         := AckRec2.DateReceived;
            AckRec.TimeReceived         := AckRec2.TimeReceived;
            AckRec.EfilerNumber         := AckRec2.EfilerNumber;
            AckRec.DocumentNo           := AckRec2.DocumentNo;
            AckRec.TransmissionNo       := AckRec2.TransmissionNo;
            for k := 1 to 6 do
              AckRec.ErrorCode[k]       := AckRec2.ErrorCode[k];
            AckRec.EFresultType         := AckRec2.EFresultType;
          end;
        End;
    end;
  end;
  procedure CloseAskFile;
  Begin
    case AskFileVersion of
      afvAckRec:
        CloseFile(TedFile);
      afvAckRec2:
        CloseFile(TedFile2);
    end;
  End;
//20161228 Igor <<<
begin
//20161228 Igor >>>
  AskFileVersion := CheckAskFileVersion(FlName);
  OpenFileForRead;
//  AssignFile(TedFile, FlName);
//  FileMode := fmOpenRead;
//  Reset(TedFile);
//20161228 Igor <<<
  // Display the file contents
  BatchTotalRecordCount:=0;
  AcceptedRecs:=0;
  RejectedRecs:=0;
//20161228 Igor >>>
  while ReadNext do
//  while not Eof(TedFile) do
  begin
  //20160329 Igor >>>
//    AckRec.returnTypeName := '';
//    AckRec.CVIndicator := '';
//    AckRec.FamilyName := '';
//    AckRec.GivenName := '';
//    AckRec.TransmitBatchName := '';
//    AckRec.ResultCode := '';
//    AckRec.DateTransmitted := '';
//    AckRec.TimeTransmitted := '';
//    AckRec.DateReceived := '';
//    AckRec.TimeReceived := '';
//    AckRec.EfilerNumber := '';
//    AckRec.DocumentNo := '';
//    AckRec.TransmissionNo := '';
//    for I := 1 to 6 do
//      AckRec.ErrorCode[i] := '';
//    AckRec.EFresultType := EFaccepted;
//    //20160329 Igor<<<
//    Read(Tedfile, AckRec);
//20161228 Igor <<<
    BatchTotalRecordCount:=BatchTotalRecordCount+1;
    //PreparerId:=LeftStr(AckRec.Dcn,5);  ??
    k := IntToStr(BatchTotalRecordCount);
    AckHdr.TransmRecs:= K;

    If (AckRec.EFresultType=EFaccepted) then //If AckRec.Accepted=True then //20140124
      Inc(AcceptedRecs)
    Else
      Inc(RejectedRecs);
    AckHdr.AcceptedRecs:= IntToStr(AcceptedRecs);
    AckHdr.RejectedRecs:= IntToStr(RejectedRecs);
    AckHdr.TransmitterNo := AckRec.EfilerNumber;
    AckHdr.BatchId:= ExtractFileName(AckRec.TransmitBatchName);  //20140130
    AckHdr.TransmissionDateTime := AckRec.DateTransmitted+' '+AckRec.TimeTransmitted;
    AckHdr.TransFlNo := AckRec.TransmissionNo;
  end;
//20161228 Igor >>>
  CloseAskFile;
  //Close(TedFile);
//20161228 Igor <<<
end;

Function GetXmlValue(XmlTag:String;XmlBuffer:String;Var PosFound:Integer):String;
//Generic routine for getting XML value for a known Tag
// The tag must start with < and and must NOT include the ending closing >
// XmlBuffer is the DataString of a xml file (Read file into Filestream then to StringStream)
// it will pick up values up to 256 characters
// it returns the position the tag was found and its value

Var k:Integer;
Begin
 PosFound:=FindString(xmlTag,XmlBuffer);
 If PosFound>0 then
   Result:=GetUntilHitDelimiter(MidStr(xmlBuffer,PosFound+Length(xmlTag)+1,256))
 Else
   Result:='';
end;



(* updatefromack - old
  RetFoundSw:=True;
 { Get SINNO from each return and update ackstatus}
  //read the ack file
  EolClearErrorCodes;
  SinNo:='';
  ConfirmationNo:='';
  RNo:=0;
  NetFileDir:=GetEolPNetFileDir;
  DataDir:=OptRec.Dir_cur;

  Assign(F1,FlNm);
  Reset(F1);
  ReadLn(F1, A);   //isa
  ReadLn(F1, A);   //isa
  ReadLn(F1, A);   //gs
  If LeftStr(A,6) ='ST'+Delim+'864' then
   begin
    ShowMessage('Message 864 - A duplicate transaction has been transmitted'
    +Chr(13)+'and it has been rejected. Contact VisualTax for directions');
    CloseFile(F1);
    Exit;
   end;
  Repeat
   ReadLn(F1, A);
   EolClearErrorCodes;
   If LeftStr(A,3) ='GE'+Delim then break; //eof file
   If LeftStr(A,3) ='ST'+Delim then  //new return
   Repeat
      ReadLn(F1, A);
      If LeftStr(A,3) ='GE'+Delim then break; //eof file

      If LeftStr(A,4) ='BTA'+Delim then
      begin
       Wlist := TStringList.Create;
       ParseWords(A,Delim,WList);
       If Wlist[1] = 'AT' then AcceptedSw:=True else acceptedSw:=False;
       WList.Free;
      end;

      If LeftStr(A,4) ='BTI'+Delim then
      begin
       Wlist := TStringList.Create;
       ParseWords(A,Delim,WList);
       EolOKREC.DOCUMENTNO := Wlist[8];
       WList.Free;
      end;
      If LeftStr(A,7) ='REF'+Delim+'BT'+Delim then
      begin
        Wlist := TStringList.Create;
        ParseWords(A,Delim,WList);
        AckHdr.IndRes1  := WList[2];  //ted file
        WList.Free;
      end;
      If LeftStr(A,7) ='REF'+Delim+'ZZ'+Delim then
      begin
        Wlist := TStringList.Create;
        ParseWords(A,Delim,WList);
        EolOKREC.NAME  := WList[3];
        WList.Free;
      end;

      If LeftStr(A,4) ='PBI'+Delim then
      begin
       //Repeat
       //ShowMessage(A);
       Wlist := TStringList.Create;
       ParseWords(A,Delim,WList);
       If      Alltrim(EolNOTOKREC.ERRCODE1) = '' then EolNOTOKREC.ERRCODE1 := Wlist[1]
       else If Alltrim(EolNOTOKREC.ERRCODE2) = '' then EolNOTOKREC.ERRCODE2 := Wlist[1]
       else If Alltrim(EolNOTOKREC.ERRCODE3) = '' then EolNOTOKREC.ERRCODE3 := Wlist[1]
       else If Alltrim(EolNOTOKREC.ERRCODE4) = '' then EolNOTOKREC.ERRCODE4 := Wlist[1]
       else If Alltrim(EolNOTOKREC.ERRCODE5) = '' then EolNOTOKREC.ERRCODE5 := Wlist[1]
       else If Alltrim(EolNOTOKREC.ERRCODE6) = '' then EolNOTOKREC.ERRCODE6 := Wlist[1]
       else If Alltrim(EolNOTOKREC.ERRCODE7) = '' then EolNOTOKREC.ERRCODE7 := Wlist[1]
       else If Alltrim(EolNOTOKREC.ERRCODE8) = '' then EolNOTOKREC.ERRCODE8 := Wlist[1];
       WList.Free;
      end;

   until LeftStr(A,3) = 'SE'+Delim; //end of a given return in the file

   //now update the return
   If AcceptedSw then Status := '02' else Status := '03';
   SinNo:=GetSinNoFromAck(EolOKREC.DOCUMENTNO);  //if filename has an extension i.e 99999999.9NB it will not be found
   ConfirmationNo:= ExtractFileName(Flnm);  //ack file being processed
   FlName:= LeftStr(SinNo,8)+'.'+RightStr(SinNo,1);
   RetNo:=InitNewReturn;  //starting from current return
   RNo:=RetNo;
   If LoadReturn(RNo,DataDir,FlName) = False then //failed
   begin
     RetFoundSw:=False;
     If RNo>0 then CloseReturn(RNo);
     if MessageDlg('A tax return '+FlName+' was not found. You may have the wrong Data Directory in configuration.'+
     Chr(13)+'Or the file name when return saved was not in the format 99999999.9  Continue?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     //ok
     else
     begin
      Break;
     end;
   end
   else
   begin
     DataDir:=OptRec.Dir_Cur;
     FlName:= LeftStr(SinNo,8)+'.'+RightStr(SinNo,1);
     AckRcvdBy:= UserName;
     AckRcvdDt:=FormatDateTime('yyyy-mm-dd',now);
     AckRcvdTm:=TimeToStr(Now);
     If UpdateAckStatusFromEolP(RNo,SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo) then
     begin
       If SaveReturn(RNo,DataDir,FlName,True,False) <0 then  //override=true, no prompt
         ShowMessage('Return failed to save with acknowledgment data');
     end;
     If RNo>0 then CloseReturn(RNo);
   end; //loaded, saved, closed
  until EOF(F1);
  CloseFile(F1);
  If RetFoundSw=True then //all returns found
  begin
   If BackupAckfile(NetFileDir,FlNm) = True then
   begin
    If FileExists(FlNm) then SysUtils.DeleteFile(FlNm);
   end;
  end
  else //returns not found
  begin
    if MessageDlg('Some return(s) not found in the current data directory. Copy Ack file to Processed folder?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
     If BackupAckfile(NetFileDir,FlNm) = True then
     begin
      If FileExists(FlNm) then SysUtils.DeleteFile(FlNm);
     end;
   end;
  end;
//end;
*)


procedure UpdateFromAck(FlNm:String);
//Const Delim='*';
Var i,RNo,FNo:Integer;
    SinNo,Status,ConfirmationNo,DataDir,AckRcvdBy,AckRcvdDt,AckRcvdTm:String;
    NetFileDir:String;
   // F1 : TextFile;
    A:String;
    WList:TStringList;
    AcceptedSw:Boolean;
    RetFoundSw:Boolean;
    AckNames:TList;
    AckRec:pAckNamesList;
    DcnNo:String;
    RetFileName:String;
begin
 If RetInMem>0 then
 begin
   ShowMessage('Please close All returns first');  //20120123
   Exit;
 end;
 AckNamesList:=TList.Create;
 ReadAckFileHeaderInfo(FlNm);

 RetFoundSw:=True;
 DataDir:=OptRec.Dir_cur;
 //20120222
 //If LeftStr(LicenseLevel,8)  = 'T1 Multi' then DataDir:= User.Tax_Dir;
// If LicenseLevel in anyMulti then DataDir:= User.Tax_Dir; //20170112 Igor (OptRec have overloaded params after init)

 For i:=0 to AckNamesList.count-1 do
 Begin
   AckRec:=AckNamesList.Items[i];
   If AckRec^.Accepted then Status := '02' else Status := '03';
   DcnNo:=AckRec^.DocumentNo; //20120122 //GetSinNoFromAck(EolOKREC.DOCUMENTNO);  //if filename has an extension i.e 99999999.9NB it will not be found
   //ConfirmationNo:= ExtractFileName(Flnm);  //ack file being processed
   RetFileName:=GetRetFileNameViaDCNNO(DcnNo); //:String); //20120122 // LeftStr(SinNo,8)+'.'+RightStr(SinNo,1);
   RNo := LoadReturn(DataDir,RetFileName);
   if RNo < 1 then //failed
   begin
     RetFoundSw:=False;
     If RNo>0 then CloseReturn(RNo);

     if MessageDlg('A tax return '+AckRec^.GivenName+' '+AckRec^.FamilyName+' was not found.'+
     Chr(13)+'You may have the wrong Data Directory in configuration.'+
     Chr(13)+'Or the file that was transmitted was not processed.'+
     Chr(13)+'Continue?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     //ok
     else Break;
   end //return file not found
   else  //return found
   begin
     DataDir:=OptRec.Dir_Cur;
     //If LeftStr(LicenseLevel,8)  = 'T1 Multi' then DataDir:= User.Tax_Dir;
     //If LicenseLevel in anyMulti then DataDir:= User.Tax_Dir;//20170112 Igor (OptRec have overloaded params after init)

     //FlName:= LeftStr(SinNo,8)+'.'+RightStr(SinNo,1);
    // AckRcvdBy:= UserName;
    // AckRcvdDt:=FormatDateTime('yyyy-mm-dd',now);
    // AckRcvdTm:=TimeToStr(Now);

     FNo:=GetFormNo('STATUS');
     If Ret[RNo].Frm[Fno].Count =0 then InitFormData(RNo,FNo);
     Ret[RNo].EfStatus:=Status;
     StoreElm(RNo,FNo,15,Status);
     StoreElm(RNo,FNo,21,User.UserName); //20170112 Igor
     StoreElm(RNo,FNo,22,FormatDateTime('yyyy-mm-dd',now));//AckRcvdDt);
     StoreElm(RNo,FNo,23,TimeToStr(Now)); //AckRcvdTm);
     StoreElm(RNo,FNo,31,ExtractFileName(FlNm));  //conf, or ack

     StoreElm(RNo,FNo,16,AckHdr.BatchId+'.TED');

     StoreElm(RNo,FNo,24,RmvLeadingZeros(AckRec.ErrorClues[1]));
     StoreElm(RNo,FNo,25,RmvLeadingZeros(AckRec.ErrorClues[2]));
     StoreElm(RNo,FNo,26,RmvLeadingZeros(AckRec.ErrorClues[3]));
     StoreElm(RNo,FNo,27,RmvLeadingZeros(AckRec.ErrorClues[4]));
     StoreElm(RNo,FNo,28,RmvLeadingZeros(AckRec.ErrorClues[5]));
     StoreElm(RNo,FNo,29,RmvLeadingZeros(AckRec.ErrorClues[6]));
     StoreElm(RNo,FNo,30,RmvLeadingZeros(AckRec.ErrorClues[7]));
     Ret[RNo].Changed:=True;

    //f UpdateAckStatusFromEolP(RNo,SinNo,Status,AckRcvdBy,AckRcvdDT,AckRcvdTm,ConfirmationNo) then
    //egin
    If SaveReturn(RNo,DataDir,RetFileName,True,False) <0 then  //override=true, no prompt
         ShowMessage('Return failed to save with acknowledgment data');
    //nd;
     If RNo>0 then CloseReturn(RNo);
   end; //loaded, saved, closed
 end; //i

 If RetFoundSw=True then //all returns found
 begin
    If BackupAckfile(NetFileDir,FlNm) = True then
    begin
     If FileExists(FlNm) then SysUtils.DeleteFile(FlNm);
    end;
 end
 else //returns not found
 begin
    if MessageDlg('Some return(s) not found in the current data directory. Copy Ack file to Processed folder?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
     If BackupAckfile(NetFileDir,FlNm) = True then
     begin
      If FileExists(FlNm) then SysUtils.DeleteFile(FlNm);
     end;
    end;
 end;
 AckNamesList.Free;
end; //routine

end.


