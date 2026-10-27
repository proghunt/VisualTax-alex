unit ECC200ReedSolomon;

interface
uses ECC200Consts, classes, SysUtils;

procedure ReedSolomonD( wd : TvarInt;  nd , nc, gfparam, pp : integer);

implementation
var
    log : TVarInt;
    alog : TVarInt;
    gf : word;

 // "prod(x,y,log,alog,gf)" returns the product "x" times "y" */
function prod( x,  y : word):integer;
var
   dum : integer;
begin
  dum := (log[x] + log[y]) mod (gf-1);
  if (x=0) or (y=0) then result := 0
  else result := alog[dum];
end;

procedure ReedSolomonD( wd : TvarInt;  nd , nc, gfparam, pp : integer);
var
   i,j,k : integer;
   c : TVarint;
begin
{$ifdef TRACE1}
    loglist := TStringlist.create;
    aloglist := TStringlist.create;
{$endif}
    // allocate, then generate the log & antilog arrays: */
    gf := gfparam;
    setlength( log, gf);
    setlength( alog, gf);
    log[0] := (1-gf);// and $FF;
    alog[0] := 1;
   for i := 1 to gf-1 do
   begin
      alog[i] := alog[i-1] * 2;
      if (alog[i] >= gf) then alog[i] := pp xor alog[i];
      log[alog[i]] := i;
   end;
{$ifdef TRACE1}
   for i := 1 to gf-1 do
   begin
        loglist.Add(inttostr(log[i]));
        aloglist.Add(inttostr(alog[i]));
   end;
   loglist.SaveToFile('logvalsd.txt');
   //aloglist.SaveToFile('alogvalsd.txt');
{$endif}
   // allocate, then generate the generator polynomial coefficients: */
   setlength( c, nc+1);
   for i := 1 to nc do c[i] := 0;
   c[0] := 1;
   for i:=1 to nc do
   begin
      c[i] := c[i-1];
      for j := i-1 downto 1 do
        c[j] := c[j-1] xor prod(c[j],alog[i]);
      c[0] := prod(c[0],alog[i]);
   end;
   // clear, then generate "nc" checkwords in the array wd[] : */
   for i := nd to (nd+nc) do wd[i] := 0;
   for i := 0 to nd-1 do
   begin
    k := wd[nd] xor wd[i];
    for j :=0 to nc-1 do
        wd[nd+j] := wd[nd+j+1] xor prod(k,c[nc-j-1]);
   end;
end;

end.
 