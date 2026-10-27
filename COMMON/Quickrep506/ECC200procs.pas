unit ECC200procs;
{===============================================================================
 DataMatrix Barcode standard ECC200.

 (c) 2012 QBS Software Ltd

 http://www.qbs.co.uk

================================================================================}

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, ECC200consts, dialogs;

var
   nrow, ncol : integer;
   barray : array of integer;
   matrixsize : integer;
   modulesize : integer;
   _globalQZflag : boolean;
   procedure MakeBitPlacementArray( matrixrows, matrixcols : integer);
   procedure DrawFrame(x : integer; y : integer; acanvas : TCanvas);
   procedure RandomBC(x : integer; y : integer; acanvas : TCanvas);
   procedure DrawModule( x : integer; y : integer; acanvas : TCanvas);
   procedure ECC200Code;
   procedure PaintRandomBC(x , y , matrixrows : integer; destrect : TRect; quietzone : boolean; acanvas : TCanvas);
   procedure DrawRandomBC(x , y , matrixrows : integer; destrect : TRect; acanvas : TCanvas);
   procedure RenderBarcode( textdata : string; GS1 : Boolean ; FNCChar : char; xpos, ypos : integer; matrixrows : TMatrixsize; destrect : TRect; quietzone : boolean; acanvas : TCanvas);
   procedure AscEncodeText( databits : TvarInt; dtext : string ; GS1 : Boolean ; FNCChar : char; maxindex : integer; var datalength : integer);

implementation
uses math, ECC200ReedSolomon;


procedure DrawModule( x : integer; y : integer; acanvas : TCanvas);
begin
    acanvas.Rectangle(x, y,x+modulesize, y+modulesize);
end;

procedure DrawModulex( x : integer; y : integer; acanvas : TCanvas);
Var
   Half : Integer;
begin
    Half := modulesize div 2;
    acanvas.Rectangle(x-Half, y-Half,x-Half+modulesize, y-Half+modulesize);
end;

procedure DrawFrame(x : integer; y : integer; acanvas : TCanvas);
var
   k, n, savematrixsize : integer;
begin
    aCanvas.Brush.Style := bsSolid;
    aCanvas.Pen.Style := psSolid;
    aCanvas.Brush.Color := clBlack;
    aCanvas.Pen.Color := clBlack;
    n := 0;
    if matrixsize > 24 then n := 2;
    for k := 0 to (matrixsize+1+n) do
    begin
       drawmodule( x + (k*modulesize),y, acanvas);
       drawmodule( x,y - (k*modulesize), acanvas);
       if ( k mod 2 ) =0 then
       begin
         drawmodule( x +(k*modulesize), y - ((matrixsize+1+n)*modulesize), acanvas);
         drawmodule( x +(matrixsize+1+n)*modulesize, y - (k*modulesize), acanvas);
       end;
    end;
    if matrixsize <= 24 then exit;
    // put in aligment modules
    savematrixsize := matrixsize;
    matrixsize := (matrixsize div 2);
    DrawFrame( x, y, acanvas);
    DrawFrame( x + ((matrixsize+2)*modulesize), y, acanvas);

    DrawFrame( x, y-((matrixsize+2)*modulesize), acanvas);
    DrawFrame( x + ((matrixsize+2)*modulesize), y-((matrixsize+2)*modulesize), acanvas);

    matrixsize := savematrixsize;
end;

procedure RandomBC(x : integer; y : integer; acanvas : TCanvas);
var
    r : double;
    row, col : integer;
begin
     aCanvas.Brush.Style := bsSolid;
     aCanvas.Pen.Style := psSolid;
     aCanvas.Brush.Color := clBlack;
     aCanvas.Pen.Color := clBlack;
     for row := 1 to matrixsize do
       for col := 1 to matrixsize do
       begin
            r := random;
            if r < 0.5 then continue;
            drawmodule( x + (row*modulesize),y - (col*modulesize), acanvas);
       end;
end;

procedure PaintRandomBC(x , y , matrixrows : integer; destrect : TRect; quietzone : boolean; acanvas : TCanvas);
var
    pixwid : integer;
    StartY, Xoff : Integer;
begin
    pixwid := destrect.Right-destrect.Left;
    if pixwid > abs(destrect.Bottom-destrect.Top) then pixwid := abs(destrect.Bottom-destrect.Top);
    modulesize := pixwid div ( matrixrows + 2 );
    if modulesize < 2 then exit;
    matrixsize := matrixrows;
    StartY :=  (matrixrows + 1)* modulesize;
    if quietzone then
    begin
        modulesize := pixwid div ( matrixrows + 4 );
        xoff := modulesize;
    end
    else
    begin
        modulesize := pixwid div ( matrixrows + 2 );
        xoff := 0;
    end;
    DrawFrame( x+xoff, StartY+y, acanvas);
    RandomBC ( x+xoff, StartY+y, acanvas);
end;

function IsDigit( cc : char) : boolean;
begin
     result := (cc>='0') and (cc<='9');
end;

procedure AscEncodeText( databits : TvarInt; dtext : string ; GS1:Boolean ; FNCChar : char; maxindex : integer; var datalength : integer);
var
   tindex, i, dtlen : integer;
begin
     dtlen := length(dtext);
     i := 1;
     tindex := 0;
     while i <= dtlen do
     begin
           // In GS1 mode FNCChar will be encoded as FNC1 (232) code
           if GS1 And (dtext[i]=FNCChar) Then
           begin
             databits[tindex] := ascFNC;
             inc(tindex);
           End
           Else
           // end GS1 support
           if ord(dtext[i])<127  then
           begin
              if (i<dtlen) then
              begin
                if IsDigit(dtext[i]) and IsDigit(dtext[i+1]) then
                begin
                     // combine digits into 1 byte
                     databits[tindex] := (ord(dtext[i])-ord('0') )*10 +  ord(dtext[i+1])-ord('0') + 130;
                     inc(tindex);
                     if tindex = maxindex then break;
                     inc(i,2); // skipping
                     continue;
                end;
             end;
             databits[tindex] := ord(dtext[i])+1;
             inc(tindex);
           end
           else
           begin
               // chars 128-255 need a bump in front
               if (maxindex-tindex)<2 then break; // no space for ascUpperShift+charcode
               databits[tindex] := ascUpperShift;
               inc(tindex);
               databits[tindex] := ord(dtext[i])-127;
               inc(tindex);
           end;
           if tindex = maxindex then break;
           inc(i);
     end;
     // return the actual length
     datalength := tindex;
end;

function GetBit16( inword : word; bitno : integer) : boolean;
begin
   // assuming bit 0 = msb
   result :=  ( (inword and $00FF) and ( 128 shr (bitno-1)) ) > 0;
end;

procedure DrawRandomBC(x , y , matrixrows : integer; destrect : TRect; acanvas : TCanvas);
var
    pixwid : integer;
begin
    pixwid := destrect.Right-destrect.Left;
    if pixwid > abs(destrect.Bottom-destrect.Top) then pixwid := abs(destrect.Bottom-destrect.Top);
    modulesize := pixwid div ( matrixrows + 2 );
    if modulesize < 2 then exit;
    matrixsize := matrixrows;
    DrawFrame( x+modulesize, y+pixwid-modulesize, acanvas);
    RandomBC( x+modulesize, y+pixwid-modulesize, acanvas);
end;

procedure BlankBC( xpos, ypos : integer; quietzone : boolean; nregions : integer; acanvas : TCanvas);
var
    doff : integer;
    nalign : integer;
begin
   aCanvas.Brush.Style := bsSolid;
   aCanvas.Pen.Style := psSolid;
   aCanvas.Brush.Color := clWhite;
   aCanvas.Pen.Color := clWhite;
   nalign := 0;
   if nregions = 4 then nalign := 2* modulesize;
   if quietzone then
   begin
       doff := (matrixsize + 2 ) * modulesize;
       acanvas.Rectangle( xpos-modulesize, ypos+(modulesize*2), xpos + doff + modulesize + nalign, ypos - doff-nalign );
   end
   else
   begin
       doff := (matrixsize + 1 ) * modulesize;
       acanvas.Rectangle( xpos, ypos + modulesize, xpos + doff + modulesize + nalign, ypos - doff - nalign );
   end;
end;

procedure RenderBarcode( textdata : string; GS1 : Boolean ; FNCChar : char; xpos, ypos : integer; matrixrows : TMatrixsize; destrect : TRect; quietzone : boolean; acanvas : TCanvas);
var
    datastr : string;
    dmbits, dmbitscopy : TVarInt;
    i, j, z : integer;
    nrow, ncol : integer;
    databytes, eccbytes : integer;
    drow, dcol, datalen, blocknum : integer;
    pixwid, eccregions, regionsize, TempPad : integer;
    StartY : Integer;
begin
   matrixsize := PatternInfo[matrixrows].matrixdim;
   databytes := PatternInfo[matrixrows].databytes;
   eccbytes := PatternInfo[matrixrows].ECCbytes;
   eccregions := PatternInfo[matrixrows].regions;
   regionsize := PatternInfo[matrixrows].regionsize;
   nrow := matrixsize;
   ncol := matrixsize;

   if databytes = 0 then
   begin
        showmessage( 'Size not supported');
        exit;
   end;
   pixwid := destrect.Right-destrect.Left;
   if pixwid > abs(destrect.Bottom-destrect.Top) then pixwid := abs(destrect.Bottom-destrect.Top);
   if quietzone then
   begin
       if eccregions = 4 then
          modulesize := pixwid div ( matrixsize + 6 )
       else
          modulesize := pixwid div ( matrixsize + 4 )
   end
   else
   begin
       if eccregions = 4 then
          modulesize := pixwid div ( matrixsize + 4 )
       else
          modulesize := pixwid div ( matrixsize + 2 );
   end;

   if modulesize < 2 then exit;

   if quietzone then
   begin
       if eccregions = 4 then
               StartY :=  (matrixsize + 4)* modulesize
       else
               StartY :=  (matrixsize + 2)* modulesize;
       BlankBC( xpos+modulesize, ypos + StartY, quietzone, eccregions, acanvas);
       DrawFrame( xpos+modulesize, ypos + StartY, acanvas);
   end
   else
   begin
       if eccregions = 4 then
            StartY :=  (matrixsize + 2)* modulesize
       else
            StartY :=  (matrixsize + 1)* modulesize;
       BlankBC( xpos, ypos + StartY,quietzone, eccregions, acanvas);
       DrawFrame( xpos, ypos + StartY, acanvas);
   end;

   datastr := Textdata;
   if trim(datastr) = '' then exit;
   setlength(dmbits,databytes+eccbytes+1);
   datalen := length(datastr); // overwritten in AscEncodeText
   AscEncodeText( dmbits, datastr, GS1, FNCChar, databytes, datalen);
   // pad databytes  // Bruno
   for i := (datalen) to  (databytes-1) do
   Begin
     if i=DataLen Then
     Begin
       dmbits[i] := ascPad;
     End Else
     Begin
       // From second pad, it must be 253 state randomized
       TempPad := ascPad + ( ( 149 * (i+1) ) mod 253 ) + 1 ;
       If TempPad<=254 then
         dmbits[i] := TempPad
       Else
         dmbits[i] := TempPad-254
     End;
   End;

   // puts eecbytes into dmbits
   ReedSolomonD( dmbits, databytes, eccbytes, 256, 301);
   dmbits[High(dmbits)]:=255;
   // make interleaved blocks
   if blocknum = 2 then
   begin
       setlength(dmbitscopy,databytes+eccbytes+1);
       for i := 0 to databytes+eccbytes-1 do
       begin
           if (i mod 2) = 0 then
             dmbitscopy[i div 2] := dmbits[i]
           else
             dmbitscopy[ ((databytes+eccbytes) div 2) + (i div 2)] := dmbits[i]
       end;
       for i := 0 to databytes+eccbytes-1 do dmbits[i] := dmbitscopy[i];
   end;

   // get a bit placement array in barray
   MakeBitPlacementArray(nrow,ncol);
   aCanvas.Brush.Color := clBlack;
   aCanvas.Pen.Color := clBlack;

   // make pattern by scanning placement array and extracting indicated bits
   for i := 0 to nrow-1 do
   begin
       for j := 0 to ncol-1 do
       begin
            drow := j + 1;
            dcol := ncol - (i + 1) +1;
            if matrixsize > 24 then
            begin
               if drow > (ncol div 2) then inc(drow, 2);
               if dcol > (ncol div 2) then inc(dcol, 2);
            end;
            z := barray[i*ncol+j];
            if getBit16( dmbits[(z div 10)-1], z mod 10 ) then
            begin
               if quietzone then inc(drow);
               drawmodule( xpos  + ( drow*modulesize), ypos + StartY - ( dcol*modulesize), aCanvas);
            end;
       end;
   end;
end;

//================================= begin bit placement code ==================
procedure module( row : integer; col : integer; chr : integer; bit : integer);
begin
    if (row < 0) then
    begin
       row := row + nrow;
       col := col + 4 - ((nrow+4) mod 8);
    end;
    if (col < 0)  then
    begin
       col := col + ncol;
       row := row + 4 - ((ncol+4) mod 8);
    end;
    barray[row*ncol+col] := 10*chr + bit;
end;

procedure utah(row : integer; col : integer; chr : integer);
begin
	module(row-2,col-2,chr,1);
  module(row-2,col-1,chr,2);
  module(row-1,col-2,chr,3);
  module(row-1,col-1,chr,4);
  module(row-1,col,chr,5);
  module(row,col-2,chr,6);
  module(row,col-1,chr,7);
  module(row,col,chr,8);
end;

procedure corner1( chr : integer);
begin
  module(nrow-1,0,chr,1);
  module(nrow-1,1,chr,2);
  module(nrow-1,2,chr,3);
  module(0,ncol-2,chr,4);
  module(0,ncol-1,chr,5);
  module(1,ncol-1,chr,6);
  module(2,ncol-1,chr,7);
  module(3,ncol-1,chr,8);
end;

procedure corner2( chr : integer);
begin
  module(nrow-3,0,chr,1);
  module(nrow-2,0,chr,2);
  module(nrow-1,0,chr,3);
  module(0,ncol-4,chr,4);
  module(0,ncol-3,chr,5);
  module(0,ncol-2,chr,6);
  module(0,ncol-1,chr,7);
  module(1,ncol-1,chr,8);
end;

procedure corner3( chr : integer);
begin
  module(nrow-3,0,chr,1);
  module(nrow-2,0,chr,2);
  module(nrow-1,0,chr,3);
  module(0,ncol-2,chr,4);
  module(0,ncol-1,chr,5);
  module(1,ncol-1,chr,6);
  module(2,ncol-1,chr,7);
  module(3,ncol-1,chr,8);
end;

procedure corner4( chr : integer);
begin
  module(nrow-1,0,chr,1);
  module(nrow-1,ncol-1,chr,2);
  module(0,ncol-3,chr,3);
  module(0,ncol-2,chr,4);
  module(0,ncol-1,chr,5);
  module(1,ncol-3,chr,6);
  module(1,ncol-2,chr,7);
  module(1,ncol-1,chr,8);
end;

procedure ECC200Code;
var
   row, col, chr : integer;
begin
    // First, fill the barray[] with invalid entries
    for row := 0 to nrow-1 do
      for col := 0 to ncol-1 do
         barray[row*ncol+col] := 0;
    // Starting in the correct location for character #1, bit 8,...
    chr := 1; row := 4; col := 0;
    // main loop
    repeat
    // repeatedly first check for one of the special corner cases, then... */
    if ((row = nrow) and (col = 0)) then
    begin
       corner1(chr);
       inc(chr);
    end;
    if ((row = (nrow-2)) and (col = 0) and ((ncol mod 4)<>0)) then
    begin
       corner2(chr);
       inc(chr);
    end;
    if ((row = (nrow-2)) and (col = 0) and ((ncol mod 8) = 4)) then
    begin
       corner3(chr);
       inc(chr);
    end;
    if ((row = (nrow+4)) and (col = 2) and ((ncol mod 8)=0)) then
    begin
       corner4(chr);
       inc(chr);
    end;
   // sweep upward diagonally, inserting successive characters,... */
   repeat
      if ((row < nrow) and (col >= 0) and (barray[row*ncol+col]=0)) then
      begin
         utah(row,col,chr);
         inc(chr);
      end;
      row := row - 2; col := col + 2;
   until  not((row >= 0) and (col < ncol));
   inc(row, 1); inc(col,3);

   // & then sweep downward diagonally, inserting successive characters,... */
   repeat
     if ((row >= 0) and (col < ncol) and (barray[row*ncol+col]=0)) then
     begin
         utah(row,col,chr);
         inc(chr);
     end;
     row := row + 2; col := col - 2;
   until not ( ((row < nrow) and (col >= 0)) );
   inc(row, 3); inc(col, 1);
   // ... until the entire array is scanned */
   until ( not ((row < nrow) or (col < ncol)));
   // Lastly, if the lower righthand corner is untouched, fill in fixed pattern */
   if (barray[nrow*ncol-1]=0) then
   begin
         barray[nrow*ncol-1] := chr*10 + 1;
         barray[nrow*ncol-ncol-2] := chr*10 + 1;
   end;
end;

procedure MakeBitPlacementArray( matrixrows, matrixcols : integer);
begin
    nrow := matrixrows;
    ncol := matrixcols;
    setlength( barray, nrow*ncol);
    ECC200Code;
end;


end.
