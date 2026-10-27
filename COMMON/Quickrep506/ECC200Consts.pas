unit ECC200Consts;
{===============================================================================
 DataMatrix Barcode standard ECC200.

 (c) 2012 QBS Software Ltd

 http://www.qbs.co.uk

================================================================================}

interface
uses classes;

const
{
1 - 128 ASCII data (ASCII value + 1)
129 Pad
130 - 229 2-digit data 00 - 99 (Numeric Value + 130)
230 Latch to C40 encodation
231 Latch to Base 256 encodation
232 FNC1
233 Structured Append
234 Reader Programming
235 Upper Shift (shift to Extended ASCII)
236 05 Macro
237 06 Macro
238 Latch to ANSI X12 encodation
239 Latch to Text encodation
240 Latch to EDIFACT encodation
241 ECI Character
242 - 255 Not to be used in ASCII encodation
}


ascfirst = 1;
asclast = 128;
ascPad = 129;
ascLatchC40 = 230;
ascLatchB256 = 231;
ascUpperShift = 235;
ascFNC = 232;

type

 TMatrixsize = ( m8x8, m10x10, m12x12, m14x14, m16x16, m18x18, m20x20, m22x22, m24x24, m28x28, m32x32, m36x36, m40x40, m44x44);

 TVarByte = array of byte;
 TVarInt = array of integer;

 TPatternInfoRec = record
     matrixdim : integer;
     databytes : integer;
     ECCbytes : integer;
     regions : integer;
     regionsize : integer;
     numBlocks : integer;
     regionNumECC : integer;
 end;

 procedure GetPatternInfo( msize : integer; var datasize : integer; var eccsize : integer; var regions : integer; var regsize : integer; var blocks : integer);

const
// the matrixdim is the size ( rows ) of the DATA area, not including the finder pattern and the quiet zone.
// e.g. 16x16 is physically 18x18 in size.  See page 16 ( 24)
  // PatternInfo : array[0..16] of TPatternInfoRec = (
   PatternInfo : array[TMatrixsize] of TPatternInfoRec = (
( matrixdim : 8; databytes : 3; eccbytes : 5; regions : 1; regionsize : 0 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 10; databytes : 5; eccbytes : 7; regions : 1; regionsize : 0 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 12; databytes : 8; eccbytes : 10; regions : 1; regionsize : 0 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 14; databytes : 12; eccbytes : 12; regions : 1; regionsize : 0 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 16; databytes : 18; eccbytes : 14; regions : 1; regionsize : 0 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 18; databytes : 22; eccbytes : 18; regions : 1; regionsize : 0 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 20; databytes : 30; eccbytes : 20; regions : 1; regionsize : 0 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 22; databytes : 36; eccbytes : 24; regions : 1; regionsize : 0 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 24; databytes : 44; eccbytes : 28; regions : 1; regionsize : 0 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 28; databytes : 62; eccbytes : 36; regions : 4; regionsize : 14 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 32; databytes : 86; eccbytes : 42; regions : 4; regionsize : 16 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 36; databytes : 114; eccbytes : 48; regions : 4; regionsize : 18 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 40; databytes : 144; eccbytes : 56; regions : 4; regionsize : 20 ; numBlocks : 1; regionNumECC : 0),
( matrixdim : 44; databytes : 174; eccbytes : 68; regions : 4; regionsize : 22 ; numBlocks : 1; regionNumECC : 0)//,
//( matrixdim : 48; databytes : 204; eccbytes : 84; regions : 4; regionsize : 24 ; numBlocks : 2; regionNumECC : 0),
//( matrixdim : 56; databytes : 280; eccbytes : 112; regions : 16; regionsize : 14 ; numBlocks : 2; regionNumECC : 0),
//( matrixdim : 64; databytes : 368; eccbytes : 144; regions : 16; regionsize : 16 ; numBlocks : 4; regionNumECC : 0)
);

implementation

procedure GetPatternInfo( msize : integer; var datasize : integer; var eccsize : integer; var regions : integer; var regsize : integer; var blocks : integer);
var
    k : TMatrixsize;
begin
    datasize := -1;
    for K:= m8x8 to m44x44 do
      if msize=Patterninfo[k].matrixdim then
      begin
          datasize := Patterninfo[k].databytes;
          eccsize := Patterninfo[k].ECCbytes;
          regions := Patterninfo[k].regions;
          regsize := PatternInfo[k].regionsize;
          blocks := PatternInfo[k].numBlocks;
          break;
      end;
end;



end.
