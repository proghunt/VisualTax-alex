Procedure BSum;
Const TypeCol = 1; NameCol =2; FromCol = 3; ToCol =4;
      PercentCol = 5; GrossCol = 6; NetCol =7;
      Columns = 7; Rows := 25;
Var I:integer; FInst :string[4];HasSw :Boolean; TotGross, TotNet: real;
Begin
 Row :=1;
 HasSw := False;TotGross:=0; TotNet := 0;
 {T2124}
 For i:=1 to MxT2124 do
  begin
   If Ret[RetNo].FrmHasData(?) then
      begin
      HasSw := True; FInst :='#'+IntToStr(i);
      If Row <= Rows-1 then {allow one for the total}
       begin
        Strings[(Row-1) * Columns+TypeCol] :='Bus.-T2124';
        Strings[(Row-1) * Columns+NameCol] :=FetchElm[RetNo,'T2124_1'+FInst,?);
        Strings[(Row-1) * Columns+FromCol] :=FetchElm[RetNo,'T2124_1'+FInst,?);
        Strings[(Row-1) * Columns+ToCol]   := FetchElm[RetNo,'T2124_1'+FInst,?);
        Tv[(Row-1) * Columns+PercentCol]   := Vl(FetchElm[RetNo,'T2124_1'+FInst,?));
        Tv[(Row-1) * Columns+GrossCol]     := Vl(FetchElm[RetNo,'T2124_1'+FInst,?));
        Tv[(Row-1) * Columns+NetCol]       := FetchElm[RetNo,'T2124_1'+FInst,?));
       end;
      TotGross := TotGross + Vl(FetchElm[RetNo,'T2124_1'+FInst,?));
      TotNet   := TotNet + Vl(FetchElm[RetNo,'T2124_1'+FInst,?));
      Inc(Row];
      end;
  end;
  If HasSw then
  begin
      Strings[(Row-1) * Columns+TypeCol] :='T o t a l Bus';
      Tv[(Row-1) * Columns+GrossCol]     := TotGross;
      Tv[(Row-1) * Columns+NetCol]       := TotNet;
      Inc(Row];
  end;
  {----}

  HasSw := False;TotGross:=0; TotNet := 0;
  {T2032}
end;
