unit FP_2027GenRTns;

interface
uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,ShellApi;

    function LTrim(Const Str: String): String;
    function RTrim(Str: String): String;
    function AllTrim(Str: String): String;
    function RightStr(Const Str: String; Size: Word): String;
    function LeftStr(Const Str: String; Size: Word): String;
    function MidStr(Const Str: String;StartPos: Word; Size: Word): String;
    Function FilledStr(Count: Word; ch: char):String;
    Function Space(Count: Word):String;
    Function BigSpace(Count: Word):AnsiString;
    Function JustRight(S:String;MaxLength: integer): string;
    Function PaddCount(s: string;maxLength: integer):Integer;
    Function PaddR(S: string;MaxLength: integer):String;
    Function PaddZero(S:string;MaxLength:Integer):string;
    Function RmvLeadingZeros(S:string):string;
    Function RemoveCommas(s: string):String; {remove 3 commas}
    Function RemoveChar(S:string;Ch:String):string;
    Function PrintAListing(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;

implementation

function LTrim(Const Str: String): String;
  var i,Len:Integer;
  {var len: Byte absolute Str;
      i: Integer;}
  begin
    i := 1;Len := Length(Str);
    while (i <= len) and (Str[i] = ' ') do Inc(i);
    {LTrim} Result := Copy(Str,i,len);
  end {LTrim};

  function RTrim(Str: String): String;
  var i,Len:integer;
 { var len: Byte absolute Str;}
  begin
    Len := Length(Str);
    i   :=Len;
    If i <1 then begin Result:='';exit;end;
    while (Str[i] = ' ') do Dec(i);
    {Result := Str;}
    result := Copy(Str,1,i);
  end {RTrim};

  function AllTrim(Str: String): String;
  begin
    Result := LTrim(RTrim(Str))
  end {Trim};

  function RightStr(Const Str: String; Size: Word): String;
  Var Len:Integer;
  {var len: Byte absolute Str;}
  begin
    Len := Length(Str);
    if Size > len then Size := len;
    Result := Copy(Str,len-Size+1,Size)
    {RightStr := Copy(Str,len-Size+1,Size)}
  end {RightStr};

  function LeftStr(Const Str: String; Size: Word): String;
  begin
    {LeftStr := Copy(Str,1,Size)}
    Result := Copy(Str,1,Size)
  end {LeftStr};

  function MidStr(Const Str: String;StartPos: Word; Size: Word): String;
  Var Len:Integer;
  {var len: Byte absolute Str;}
  begin
    Result := Copy(Str,StartPos,Size);
  end {MidStr};

  Function FilledStr(Count: Word; ch: char):String;
   {returns a string with Count spaces, or other character}
    var
     S: string; //[80];
    begin
     { Set a string to all spaces }
      FillChar(S, Count+1, ch);
      S[0] := Chr(Count); 		{ Set length byte }
      Result := S;
  end;

 Function Space(Count: Word):String;
   {returns a string with Count spaces}
    var
     S: string; //[80];
    begin
      FillChar(S, Count+1, ' ');
      S[0] := Chr(Count); 		{ Set length byte }
      Result := S;
  end;

  Function BigSpace(Count: Word):AnsiString;
   {returns a string with Count spaces}
    var
     i:integer; S: AnsiString;
    begin
     s:='';
     For i:=1 to count do s:=s+' ';
     Result := S;
  end;


Function JustRight(S:String;MaxLength: integer): string;
begin
 S := Ltrim(RTrim(s));
 Result := FilledStr(PaddCount(S,MaxLength),' ') + S;
end;

Function PaddCount(s: string;maxLength: integer):Integer;
{how many characters to reach to mx length}
begin
 Result := MaxLength - Length(s);
 If Result <0 then result := 0;
end;

Function PaddR(S: string;MaxLength: integer):String;
{Fill to the end with blanks}
begin
 S := Ltrim(RTrim(s));
 Result := s + FilledStr(PaddCount(S,MaxLength), ' ');
end;

Function PaddZero(S:string;MaxLength:Integer):string;
Begin
  Result := FilledStr(PaddCount(S,MaxLength), '0')+S;
End;

Function RmvLeadingZeros(S:string):string;
Var I:integer;
Begin
 Result := S;
 For i := 1 to Length(S) do
  If S[i] ='0' then Result := MidStr(S,i+1,255) else exit;
End;


Function RemoveCommas(s: string):String; {remove 3 commas}
Var i,k:Integer;
begin
  k:=Pos(',',s);
  If k<> 0 then delete(s,k,1) else begin result:=s;exit;end;

  k:=Pos(',',s);
  If k<> 0 then delete(s,k,1) else begin result:=s;exit;end;;

  k:=Pos(',',s);
  If k<> 0 then delete(s,k,1) else begin result:=s;exit;end;;
end;

Function RemoveChar(S:string;Ch:String):string;
Var i:integer;
begin
 Result:='';
 For i:=1 to Length(s) do
   If s[i] <>Ch then result:=result+s[i];
end;

Function PrintAListing(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;
var
  i,LineCnt,MxLinesPerPage,PageCnt:integer;PrnFile: TextFile;
  {TempList:TstringList;}
  XPos :LongInt;PageX, PageY : LongInt;
  ScMult : Integer; s:string;
  F1 :TextFile;
  ScaleX, ScaleY : Word;
  FirstTimeSw:boolean;
begin
  AssignFile(F1, FileNm);
  Reset(F1);

  FirstTimeSw := true;
  LineCnt:=0;PageCnt :=0;MxLinesPerPage :=60;
  {now print}
  Printer.BeginDoc;
  XPos := 70;
  ScMult :=10;
  PageX:= Printer.PageWidth;
  PageY :=Printer.PageHeight;
  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
  ScaleY := (PageY * ScMult) div 1000; {formheight}

  Repeat
   If (FirstTimeSw) or (LineCnt >MxLinesPerPage) then
   begin  {print headers}
     LineCnt:=1;
     Inc(PageCnt);
     If not FirstTimeSw then Printer.NewPage;

     Printer.Canvas.Font.Name := 'Arial';
     Printer.Canvas.Font.Size := 10;
     Printer.Canvas.Font.Style := [fsBold];
     Printer.Canvas.TextOut(
       (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,
        Hdr1+' Page: '+IntToStr(PageCnt));

     Inc(LineCnt); {leave empty line}
     Printer.Canvas.Font.Name := 'Courier New';
     Printer.Canvas.Font.Size := 8;
     Printer.Canvas.Font.Style := [];
     Inc(LineCnt);
     Printer.Canvas.TextOut(
        (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr2);

     Inc(LineCnt);
     Printer.Canvas.TextOut(
        (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr3);
     Inc(LineCnt,1);
   end; {headers}
   FirstTimeSw := False;
   Printer.Canvas.Font.Style := [];
   Readln(F1,s);
   Printer.Canvas.TextOut(
    (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,
          s);
   Inc(LineCnt);
  until Eof(F1);
  CloseFile(F1);
  Printer.EndDoc;
  Result := True;
end;

end.
