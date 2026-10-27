unit FP_2027calc2;

interface
uses
 SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  StdCtrls,Dialogs,DBctrls,ExtCtrls,FP_2027Declare,FP_2027common,FP_2027common2,
  FP_2027TrimStr;


  {Procedure T1013(RetNo:integer;FName:string;FNo:integer);}

implementation
Uses FP_2027Calc;

 {---------------  Tuok's procedures  ----------------}
(*
Procedure T691_2(RetNo:integer;FName:string;FNo:integer);
Begin
   LoadTv(RetNo,FName,FNo);
 with Ret[RetNo]^ do
 begin
  	Tv[1] := Ret[RetNo]^.Ln[207];
        {Tv[2] := Ret[RetNo]^.Ln[208];}
   end;
	{save data}
	SaveTv(RetNo,FName,FNo);
End;
*)


end.
