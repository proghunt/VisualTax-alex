unit GT3Func;

interface
   uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 UDeclare,TrimStr, UPopList, UCalndr;
   Function CalcAllowablePolit (Province:String; TotalContrib:Real) :Real;
   Function GetProvince (RetNo:integer) :String;
implementation

   Function CalcAllowablePolit (Province:String; TotalContrib:Real) :Real;
   Var
      Temp:LongInt;
   begin
   Result := 0.0;
   Temp   := Round (TotalContrib);
   if (Province = 'MN') OR (Province = 'BC') OR (Province = 'PE')
   OR (Province = 'NS') OR (Province = 'YT')
   {Fed political contrib is calculated as if it were MN. If you change MN calculations revise S11 line 1119}
   then
     begin
           case Temp Of
           0..100: result := TotalContrib * 0.75;
           101..550: result:= (100.00 * 0.75) + ((TotalContrib - 100.00) * 0.50);
           else
           result:= MinR (500.00, ( (100.0 * 0.75) +
                                  ( (550 - 100.00) * 0.50) +
                                  ( (TotalContrib - 550.00) * 0.333)) );
           end;
     end;
   if Province = 'AB' then
     begin
           case Temp Of
           0..150: result := TotalContrib * 0.75;
           151..825: result:= (150.0 * 0.75) + ((TotalContrib - 150.00) * 0.50);
           else
           result:= MinR (750.00, ( (150.0 * 0.75) +
                                  ( (825 - 150.00) * 0.50) +
                                  ( (TotalContrib - 825.00) * 0.333)) );
           end;

     end;
   if Province = 'NT' then
     begin
           case Temp Of
           0..100: result := TotalContrib * 1.00;
           else
           result:= MinR (500.00, ( (100.0 * 1.00) +
                                  ( (TotalContrib - 100.00) * 0.50)) );
           end;

     end;
   end;

 Function GetProvince (RetNo:integer) :String;
 begin
 Result := Ret[RetNo]^.Province;
 end;


end.
 