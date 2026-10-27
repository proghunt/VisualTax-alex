{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryCCITT.pas                              }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryCCITT;

{$I DebenuPDFLibraryDefines.inc}

(*
 * From package com.sun.pdfview.decode;
 * http://www.jarvana.com/jarvana/view/org/swinglabs/pdf-renderer/1.0.5/pdf-renderer-1.0.5-sources.jar!/com/sun/pdfview/decode/CCITTFaxDecoder.java?format=ok
 *
 * Based on the SUN code (see license beyond) changes are made to handle CCITTFax encoded
 * data in a PDF image. This may or may not apply to real world CCITT documents.
 *
 * Copyright (c) 2007, intarsys consulting GmbH
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 *
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * - Neither the name of intarsys nor the names of its contributors may be used
 *   to endorse or promote products derived from this software without specific
 *   prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * Copyright (c) 2001 Sun Microsystems, Inc. All Rights Reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * -Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * -Redistribution in binary form must reproduct the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of Sun Microsystems, Inc. or the names of contributors may
 * be used to endorse or promote products derived from this software without
 * specific prior written permission.
 *
 * This software is provided "AS IS," without a warranty of any kind. ALL
 * EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND WARRANTIES, INCLUDING ANY
 * IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR
 * NON-INFRINGEMENT, ARE HEREBY EXCLUDED. SUN AND ITS LICENSORS SHALL NOT BE
 * LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING
 * OR DISTRIBUTING THE SOFTWARE OR ITS DERIVATIVES. IN NO EVENT WILL SUN OR ITS
 * LICENSORS BE LIABLE FOR ANY LOST REVENUE, PROFIT OR DATA, OR FOR DIRECT,
 * INDIRECT, SPECIAL, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER
 * CAUSED AND REGARDLESS OF THE THEORY OF LIABILITY, ARISING OUT OF THE USE OF
 * OR INABILITY TO USE SOFTWARE, EVEN IF SUN HAS BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGES.
 *
 * You acknowledge that Software is not designed,licensed or intended for use in
 * the design, construction, operation or maintenance of any nuclear facility.
 *)

interface

uses
  Classes, Math;

type
  TCCITTByteArray = array of ShortInt;
  TCCITTShortArray = array of SmallInt;
  TCCITTIntegerArray = array of Integer;

  TQPLCCITTDecoder = class
  private
    FBitPointer: Integer;
    FBytePointer: Integer;
    FCompData: TCCITTByteArray;
    FWidth: Integer;
    FHeight: Integer;
    FBitsPerComponent: Integer;
    FEncodedByteAlign: Boolean;
    FFillOrder: Integer;
    FFillBits: Boolean;
    FEOLIs8Bit: Boolean;

    // Data structures needed to store changing elements for the previous and the current scanline
    ChangingElemSize: Integer;
    PrevChangingElems: TCCITTIntegerArray;
    CurrChangingElems: TCCITTIntegerArray;

    // Element at which to start search in getNextChangingElement
    LastChangingElement: Integer;
  private
    function AlignToByte: Boolean;
    function DecodeBlackCodeWord: Integer;
    function DecodeWhiteCodeWord: Integer;
    function GetNextChangingElement(a0: Integer; IsWhite: Boolean): TCCITTIntegerArray;
    function NextLesserThan8Bits(BitsToGet: Integer): Integer;
    function NextNBits(BitsToGet: Integer): Integer;
    function ReadEOL(isFirstEOL: Boolean): Integer;
    function SeekEOL: Boolean;
    procedure SetToBlack(var Buffer: TCCITTByteArray; LineOffset, BitOffset, NumBits: Integer);
    procedure UpdatePointer(BitsToMoveBack: Integer);
    function ConsumeEOL: Boolean;
    function DecodeNextScanline(var Buffer: TCCITTByteArray; LineOffset, BitOffset: Integer): Boolean;
  public
    constructor Create(AWidth, AHeight, AFillOrder: Integer; AAlign, AFillBits: Boolean; BitsPerComponent: Integer);
    function DecodeT41D(var Buffer: TCCITTByteArray; CompData: TCCITTByteArray): Boolean;
    procedure DecodeT42D(var Buffer: TCCITTByteArray; Compdata: TCCITTByteArray);
    function DecodeT6(var Buffer: TCCITTByteArray; CompData: TCCITTByteArray): Boolean;
  end;

const
	Table1: array[0..8] of Integer = ( $00, // 0 bits are left in first byte - SHOULD NOT HAPPEN
			$01, // 1 bits are left in first byte
			$03, // 2 bits are left in first byte
			$07, // 3 bits are left in first byte
			$0f, // 4 bits are left in first byte
			$1f, // 5 bits are left in first byte
			$3f, // 6 bits are left in first byte
			$7f, // 7 bits are left in first byte
			$ff);// 8 bits are left in first byte

	Table2: array[0..8] of Integer = ( $00, // 0
			$80, // 1
			$c0, // 2
			$e0, // 3
			$f0, // 4
			$f8, // 5
			$fc, // 6
			$fe, // 7
			$ff);// 8

	// Table to be used when fillOrder = 2, for flipping bytes.
	FlipTable: array[0..255] of ShortInt =
	  ( 0, -128, 64, -64, 32, -96, 96, -32, 16, -112,
			80, -48, 48, -80, 112, -16, 8, -120, 72, -56, 40, -88, 104, -24,
			24, -104, 88, -40, 56, -72, 120, -8, 4, -124, 68, -60, 36, -92,
			100, -28, 20, -108, 84, -44, 52, -76, 116, -12, 12, -116, 76, -52,
			44, -84, 108, -20, 28, -100, 92, -36, 60, -68, 124, -4, 2, -126,
			66, -62, 34, -94, 98, -30, 18, -110, 82, -46, 50, -78, 114, -14,
			10, -118, 74, -54, 42, -86, 106, -22, 26, -102, 90, -38, 58, -70,
			122, -6, 6, -122, 70, -58, 38, -90, 102, -26, 22, -106, 86, -42,
			54, -74, 118, -10, 14, -114, 78, -50, 46, -82, 110, -18, 30, -98,
			94, -34, 62, -66, 126, -2, 1, -127, 65, -63, 33, -95, 97, -31, 17,
			-111, 81, -47, 49, -79, 113, -15, 9, -119, 73, -55, 41, -87, 105,
			-23, 25, -103, 89, -39, 57, -71, 121, -7, 5, -123, 69, -59, 37,
			-91, 101, -27, 21, -107, 85, -43, 53, -75, 117, -11, 13, -115, 77,
			-51, 45, -83, 109, -19, 29, -99, 93, -35, 61, -67, 125, -3, 3,
			-125, 67, -61, 35, -93, 99, -29, 19, -109, 83, -45, 51, -77, 115,
			-13, 11, -117, 75, -53, 43, -85, 107, -21, 27, -101, 91, -37, 59,
			-69, 123, -5, 7, -121, 71, -57, 39, -89, 103, -25, 23, -105, 87,
			-41, 55, -73, 119, -9, 15, -113, 79, -49, 47, -81, 111, -17, 31,
			-97, 95, -33, 63, -65, 127, -1
		);

	// The main 10 bit white runs lookup table
	White: array[0..1023] of SmallInt = (
	// 0 - 7
			6430, 6400, 6400, 6400, 3225, 3225, 3225, 3225,
			// 8 - 15
			944, 944, 944, 944, 976, 976, 976, 976,
			// 16 - 23
			1456, 1456, 1456, 1456, 1488, 1488, 1488, 1488,
			// 24 - 31
			718, 718, 718, 718, 718, 718, 718, 718,
			// 32 - 39
			750, 750, 750, 750, 750, 750, 750, 750,
			// 40 - 47
			1520, 1520, 1520, 1520, 1552, 1552, 1552, 1552,
			// 48 - 55
			428, 428, 428, 428, 428, 428, 428, 428,
			// 56 - 63
			428, 428, 428, 428, 428, 428, 428, 428,
			// 64 - 71
			654, 654, 654, 654, 654, 654, 654, 654,
			// 72 - 79
			1072, 1072, 1072, 1072, 1104, 1104, 1104, 1104,
			// 80 - 87
			1136, 1136, 1136, 1136, 1168, 1168, 1168, 1168,
			// 88 - 95
			1200, 1200, 1200, 1200, 1232, 1232, 1232, 1232,
			// 96 - 103
			622, 622, 622, 622, 622, 622, 622, 622,
			// 104 - 111
			1008, 1008, 1008, 1008, 1040, 1040, 1040, 1040,
			// 112 - 119
			44, 44, 44, 44, 44, 44, 44, 44,
			// 120 - 127
			44, 44, 44, 44, 44, 44, 44, 44,
			// 128 - 135
			396, 396, 396, 396, 396, 396, 396, 396,
			// 136 - 143
			396, 396, 396, 396, 396, 396, 396, 396,
			// 144 - 151
			1712, 1712, 1712, 1712, 1744, 1744, 1744, 1744,
			// 152 - 159
			846, 846, 846, 846, 846, 846, 846, 846,
			// 160 - 167
			1264, 1264, 1264, 1264, 1296, 1296, 1296, 1296,
			// 168 - 175
			1328, 1328, 1328, 1328, 1360, 1360, 1360, 1360,
			// 176 - 183
			1392, 1392, 1392, 1392, 1424, 1424, 1424, 1424,
			// 184 - 191
			686, 686, 686, 686, 686, 686, 686, 686,
			// 192 - 199
			910, 910, 910, 910, 910, 910, 910, 910,
			// 200 - 207
			1968, 1968, 1968, 1968, 2000, 2000, 2000, 2000,
			// 208 - 215
			2032, 2032, 2032, 2032, 16, 16, 16, 16,
			// 216 - 223
			10257, 10257, 10257, 10257, 12305, 12305, 12305, 12305,
			// 224 - 231
			330, 330, 330, 330, 330, 330, 330, 330,
			// 232 - 239
			330, 330, 330, 330, 330, 330, 330, 330,
			// 240 - 247
			330, 330, 330, 330, 330, 330, 330, 330,
			// 248 - 255
			330, 330, 330, 330, 330, 330, 330, 330,
			// 256 - 263
			362, 362, 362, 362, 362, 362, 362, 362,
			// 264 - 271
			362, 362, 362, 362, 362, 362, 362, 362,
			// 272 - 279
			362, 362, 362, 362, 362, 362, 362, 362,
			// 280 - 287
			362, 362, 362, 362, 362, 362, 362, 362,
			// 288 - 295
			878, 878, 878, 878, 878, 878, 878, 878,
			// 296 - 303
			1904, 1904, 1904, 1904, 1936, 1936, 1936, 1936,
			// 304 - 311
			-18413, -18413, -16365, -16365, -14317, -14317, -10221, -10221,
			// 312 - 319
			590, 590, 590, 590, 590, 590, 590, 590,
			// 320 - 327
			782, 782, 782, 782, 782, 782, 782, 782,
			// 328 - 335
			1584, 1584, 1584, 1584, 1616, 1616, 1616, 1616,
			// 336 - 343
			1648, 1648, 1648, 1648, 1680, 1680, 1680, 1680,
			// 344 - 351
			814, 814, 814, 814, 814, 814, 814, 814,
			// 352 - 359
			1776, 1776, 1776, 1776, 1808, 1808, 1808, 1808,
			// 360 - 367
			1840, 1840, 1840, 1840, 1872, 1872, 1872, 1872,
			// 368 - 375
			6157, 6157, 6157, 6157, 6157, 6157, 6157, 6157,
			// 376 - 383
			6157, 6157, 6157, 6157, 6157, 6157, 6157, 6157,
			// 384 - 391
			-12275, -12275, -12275, -12275, -12275, -12275, -12275, -12275,
			// 392 - 399
			-12275, -12275, -12275, -12275, -12275, -12275, -12275, -12275,
			// 400 - 407
			14353, 14353, 14353, 14353, 16401, 16401, 16401, 16401,
			// 408 - 415
			22547, 22547, 24595, 24595, 20497, 20497, 20497, 20497,
			// 416 - 423
			18449, 18449, 18449, 18449, 26643, 26643, 28691, 28691,
			// 424 - 431
			30739, 30739, -32749, -32749, -30701, -30701, -28653, -28653,
			// 432 - 439
			-26605, -26605, -24557, -24557, -22509, -22509, -20461, -20461,
			// 440 - 447
			8207, 8207, 8207, 8207, 8207, 8207, 8207, 8207,
			// 448 - 455
			72, 72, 72, 72, 72, 72, 72, 72,
			// 456 - 463
			72, 72, 72, 72, 72, 72, 72, 72,
			// 464 - 471
			72, 72, 72, 72, 72, 72, 72, 72,
			// 472 - 479
			72, 72, 72, 72, 72, 72, 72, 72,
			// 480 - 487
			72, 72, 72, 72, 72, 72, 72, 72,
			// 488 - 495
			72, 72, 72, 72, 72, 72, 72, 72,
			// 496 - 503
			72, 72, 72, 72, 72, 72, 72, 72,
			// 504 - 511
			72, 72, 72, 72, 72, 72, 72, 72,
			// 512 - 519
			104, 104, 104, 104, 104, 104, 104, 104,
			// 520 - 527
			104, 104, 104, 104, 104, 104, 104, 104,
			// 528 - 535
			104, 104, 104, 104, 104, 104, 104, 104,
			// 536 - 543
			104, 104, 104, 104, 104, 104, 104, 104,
			// 544 - 551
			104, 104, 104, 104, 104, 104, 104, 104,
			// 552 - 559
			104, 104, 104, 104, 104, 104, 104, 104,
			// 560 - 567
			104, 104, 104, 104, 104, 104, 104, 104,
			// 568 - 575
			104, 104, 104, 104, 104, 104, 104, 104,
			// 576 - 583
			4107, 4107, 4107, 4107, 4107, 4107, 4107, 4107,
			// 584 - 591
			4107, 4107, 4107, 4107, 4107, 4107, 4107, 4107,
			// 592 - 599
			4107, 4107, 4107, 4107, 4107, 4107, 4107, 4107,
			// 600 - 607
			4107, 4107, 4107, 4107, 4107, 4107, 4107, 4107,
			// 608 - 615
			266, 266, 266, 266, 266, 266, 266, 266,
			// 616 - 623
			266, 266, 266, 266, 266, 266, 266, 266,
			// 624 - 631
			266, 266, 266, 266, 266, 266, 266, 266,
			// 632 - 639
			266, 266, 266, 266, 266, 266, 266, 266,
			// 640 - 647
			298, 298, 298, 298, 298, 298, 298, 298,
			// 648 - 655
			298, 298, 298, 298, 298, 298, 298, 298,
			// 656 - 663
			298, 298, 298, 298, 298, 298, 298, 298,
			// 664 - 671
			298, 298, 298, 298, 298, 298, 298, 298,
			// 672 - 679
			524, 524, 524, 524, 524, 524, 524, 524,
			// 680 - 687
			524, 524, 524, 524, 524, 524, 524, 524,
			// 688 - 695
			556, 556, 556, 556, 556, 556, 556, 556,
			// 696 - 703
			556, 556, 556, 556, 556, 556, 556, 556,
			// 704 - 711
			136, 136, 136, 136, 136, 136, 136, 136,
			// 712 - 719
			136, 136, 136, 136, 136, 136, 136, 136,
			// 720 - 727
			136, 136, 136, 136, 136, 136, 136, 136,
			// 728 - 735
			136, 136, 136, 136, 136, 136, 136, 136,
			// 736 - 743
			136, 136, 136, 136, 136, 136, 136, 136,
			// 744 - 751
			136, 136, 136, 136, 136, 136, 136, 136,
			// 752 - 759
			136, 136, 136, 136, 136, 136, 136, 136,
			// 760 - 767
			136, 136, 136, 136, 136, 136, 136, 136,
			// 768 - 775
			168, 168, 168, 168, 168, 168, 168, 168,
			// 776 - 783
			168, 168, 168, 168, 168, 168, 168, 168,
			// 784 - 791
			168, 168, 168, 168, 168, 168, 168, 168,
			// 792 - 799
			168, 168, 168, 168, 168, 168, 168, 168,
			// 800 - 807
			168, 168, 168, 168, 168, 168, 168, 168,
			// 808 - 815
			168, 168, 168, 168, 168, 168, 168, 168,
			// 816 - 823
			168, 168, 168, 168, 168, 168, 168, 168,
			// 824 - 831
			168, 168, 168, 168, 168, 168, 168, 168,
			// 832 - 839
			460, 460, 460, 460, 460, 460, 460, 460,
			// 840 - 847
			460, 460, 460, 460, 460, 460, 460, 460,
			// 848 - 855
			492, 492, 492, 492, 492, 492, 492, 492,
			// 856 - 863
			492, 492, 492, 492, 492, 492, 492, 492,
			// 864 - 871
			2059, 2059, 2059, 2059, 2059, 2059, 2059, 2059,
			// 872 - 879
			2059, 2059, 2059, 2059, 2059, 2059, 2059, 2059,
			// 880 - 887
			2059, 2059, 2059, 2059, 2059, 2059, 2059, 2059,
			// 888 - 895
			2059, 2059, 2059, 2059, 2059, 2059, 2059, 2059,
			// 896 - 903
			200, 200, 200, 200, 200, 200, 200, 200,
			// 904 - 911
			200, 200, 200, 200, 200, 200, 200, 200,
			// 912 - 919
			200, 200, 200, 200, 200, 200, 200, 200,
			// 920 - 927
			200, 200, 200, 200, 200, 200, 200, 200,
			// 928 - 935
			200, 200, 200, 200, 200, 200, 200, 200,
			// 936 - 943
			200, 200, 200, 200, 200, 200, 200, 200,
			// 944 - 951
			200, 200, 200, 200, 200, 200, 200, 200,
			// 952 - 959
			200, 200, 200, 200, 200, 200, 200, 200,
			// 960 - 967
			232, 232, 232, 232, 232, 232, 232, 232,
			// 968 - 975
			232, 232, 232, 232, 232, 232, 232, 232,
			// 976 - 983
			232, 232, 232, 232, 232, 232, 232, 232,
			// 984 - 991
			232, 232, 232, 232, 232, 232, 232, 232,
			// 992 - 999
			232, 232, 232, 232, 232, 232, 232, 232,
			// 1000 - 1007
			232, 232, 232, 232, 232, 232, 232, 232,
			// 1008 - 1015
			232, 232, 232, 232, 232, 232, 232, 232,
			// 1016 - 1023
			232, 232, 232, 232, 232, 232, 232, 232
		);

	// Additional make up codes for both White and Black runs
	AdditionalMakeup: array[0..15] of SmallInt  =
	  (  28679, 28679, 31752,  SmallInt(32777),
			SmallInt(33801), SmallInt(34825), SmallInt(35849), SmallInt(36873),
			SmallInt(29703), SmallInt(29703), SmallInt(30727), SmallInt(30727),
			SmallInt(37897), SmallInt(38921), SmallInt(39945), SmallInt(40969)
    );

	// Initial black run look up table, uses the first 4 bits of a code
	InitBlack: array[0..15] of SmallInt =
	(
	// 0 - 7
			3226, 6412, 200, 168, 38, 38, 134, 134, // 8 - 15
			100, 100, 100, 100, 68, 68, 68, 68
	);

	//
	TwoBitBlack: array[0..3] of SmallInt = ( 292, 260, 226, 226 );    // 0 - 3

	// Main black run table, using the last 9 bits of possible 13 bit code
	Black: array[0..511] of SmallInt = (
	// 0 - 7
			62, 62, 30, 30, 0, 0, 0, 0,
			// 8 - 15
			0, 0, 0, 0, 0, 0, 0, 0,
			// 16 - 23
			0, 0, 0, 0, 0, 0, 0, 0,
			// 24 - 31
			0, 0, 0, 0, 0, 0, 0, 0,
			// 32 - 39
			3225, 3225, 3225, 3225, 3225, 3225, 3225, 3225,
			// 40 - 47
			3225, 3225, 3225, 3225, 3225, 3225, 3225, 3225,
			// 48 - 55
			3225, 3225, 3225, 3225, 3225, 3225, 3225, 3225,
			// 56 - 63
			3225, 3225, 3225, 3225, 3225, 3225, 3225, 3225,
			// 64 - 71
			588, 588, 588, 588, 588, 588, 588, 588,
			// 72 - 79
			1680, 1680, 20499, 22547, 24595, 26643, 1776, 1776,
			// 80 - 87
			1808, 1808, -24557, -22509, -20461, -18413, 1904, 1904,
			// 88 - 95
			1936, 1936, -16365, -14317, 782, 782, 782, 782,
			// 96 - 103
			814, 814, 814, 814, -12269, -10221, 10257, 10257,
			// 104 - 111
			12305, 12305, 14353, 14353, 16403, 18451, 1712, 1712,
			// 112 - 119
			1744, 1744, 28691, 30739, -32749, -30701, -28653, -26605,
			// 120 - 127
			2061, 2061, 2061, 2061, 2061, 2061, 2061, 2061,
			// 128 - 135
			424, 424, 424, 424, 424, 424, 424, 424,
			// 136 - 143
			424, 424, 424, 424, 424, 424, 424, 424,
			// 144 - 151
			424, 424, 424, 424, 424, 424, 424, 424,
			// 152 - 159
			424, 424, 424, 424, 424, 424, 424, 424,
			// 160 - 167
			750, 750, 750, 750, 1616, 1616, 1648, 1648,
			// 168 - 175
			1424, 1424, 1456, 1456, 1488, 1488, 1520, 1520,
			// 176 - 183
			1840, 1840, 1872, 1872, 1968, 1968, 8209, 8209,
			// 184 - 191
			524, 524, 524, 524, 524, 524, 524, 524,
			// 192 - 199
			556, 556, 556, 556, 556, 556, 556, 556,
			// 200 - 207
			1552, 1552, 1584, 1584, 2000, 2000, 2032, 2032,
			// 208 - 215
			976, 976, 1008, 1008, 1040, 1040, 1072, 1072,
			// 216 - 223
			1296, 1296, 1328, 1328, 718, 718, 718, 718,
			// 224 - 231
			456, 456, 456, 456, 456, 456, 456, 456,
			// 232 - 239
			456, 456, 456, 456, 456, 456, 456, 456,
			// 240 - 247
			456, 456, 456, 456, 456, 456, 456, 456,
			// 248 - 255
			456, 456, 456, 456, 456, 456, 456, 456,
			// 256 - 263
			326, 326, 326, 326, 326, 326, 326, 326,
			// 264 - 271
			326, 326, 326, 326, 326, 326, 326, 326,
			// 272 - 279
			326, 326, 326, 326, 326, 326, 326, 326,
			// 280 - 287
			326, 326, 326, 326, 326, 326, 326, 326,
			// 288 - 295
			326, 326, 326, 326, 326, 326, 326, 326,
			// 296 - 303
			326, 326, 326, 326, 326, 326, 326, 326,
			// 304 - 311
			326, 326, 326, 326, 326, 326, 326, 326,
			// 312 - 319
			326, 326, 326, 326, 326, 326, 326, 326,
			// 320 - 327
			358, 358, 358, 358, 358, 358, 358, 358,
			// 328 - 335
			358, 358, 358, 358, 358, 358, 358, 358,
			// 336 - 343
			358, 358, 358, 358, 358, 358, 358, 358,
			// 344 - 351
			358, 358, 358, 358, 358, 358, 358, 358,
			// 352 - 359
			358, 358, 358, 358, 358, 358, 358, 358,
			// 360 - 367
			358, 358, 358, 358, 358, 358, 358, 358,
			// 368 - 375
			358, 358, 358, 358, 358, 358, 358, 358,
			// 376 - 383
			358, 358, 358, 358, 358, 358, 358, 358,
			// 384 - 391
			490, 490, 490, 490, 490, 490, 490, 490,
			// 392 - 399
			490, 490, 490, 490, 490, 490, 490, 490,
			// 400 - 407
			4113, 4113, 6161, 6161, 848, 848, 880, 880,
			// 408 - 415
			912, 912, 944, 944, 622, 622, 622, 622,
			// 416 - 423
			654, 654, 654, 654, 1104, 1104, 1136, 1136,
			// 424 - 431
			1168, 1168, 1200, 1200, 1232, 1232, 1264, 1264,
			// 432 - 439
			686, 686, 686, 686, 1360, 1360, 1392, 1392,
			// 440 - 447
			12, 12, 12, 12, 12, 12, 12, 12,
			// 448 - 455
			390, 390, 390, 390, 390, 390, 390, 390,
			// 456 - 463
			390, 390, 390, 390, 390, 390, 390, 390,
			// 464 - 471
			390, 390, 390, 390, 390, 390, 390, 390,
			// 472 - 479
			390, 390, 390, 390, 390, 390, 390, 390,
			// 480 - 487
			390, 390, 390, 390, 390, 390, 390, 390,
			// 488 - 495
			390, 390, 390, 390, 390, 390, 390, 390,
			// 496 - 503
			390, 390, 390, 390, 390, 390, 390, 390,
			// 504 - 511
			390, 390, 390, 390, 390, 390, 390, 390
    );

	  TwoDCodes: array[0..127] of ShortInt = (
	    // 0 - 7
			80, 88, 23, 71, 30, 30, 62, 62,
			// 8 - 15
			4, 4, 4, 4, 4, 4, 4, 4,
			// 16 - 23
			11, 11, 11, 11, 11, 11, 11, 11,
			// 24 - 31
			11, 11, 11, 11, 11, 11, 11, 11,
			// 32 - 39
			35, 35, 35, 35, 35, 35, 35, 35,
			// 40 - 47
			35, 35, 35, 35, 35, 35, 35, 35,
			// 48 - 55
			51, 51, 51, 51, 51, 51, 51, 51,
			// 56 - 63
			51, 51, 51, 51, 51, 51, 51, 51,
			// 64 - 71
			41, 41, 41, 41, 41, 41, 41, 41,
			// 72 - 79
			41, 41, 41, 41, 41, 41, 41, 41,
			// 80 - 87
			41, 41, 41, 41, 41, 41, 41, 41,
			// 88 - 95
			41, 41, 41, 41, 41, 41, 41, 41,
			// 96 - 103
			41, 41, 41, 41, 41, 41, 41, 41,
			// 104 - 111
			41, 41, 41, 41, 41, 41, 41, 41,
			// 112 - 119
			41, 41, 41, 41, 41, 41, 41, 41,
			// 120 - 127
			41, 41, 41, 41, 41, 41, 41, 41 );

implementation

constructor TQPLCCITTDecoder.Create(AWidth, AHeight, AFillOrder: Integer;
  AAlign, AFillBits: Boolean; BitsPerComponent: Integer);
begin
  FEncodedByteAlign := AAlign;
  ChangingElemSize := 0;
  LastChangingElement := 0;
  FFillBits := AFillBits;

  FFillOrder := AFillOrder;
  FWidth := AWidth;
  FHeight := AHeight;
  FEOLIs8Bit := False;
  FBitsPerComponent := BitsPerComponent;

  FBitPointer := 0;
  FBytePointer := 0;
  SetLength(PrevChangingElems, Max(2, FWidth));
  SetLength(CurrChangingElems, Max(2, FWidth));
end;

function TQPLCCITTDecoder.AlignToByte: Boolean;
begin
  Result := False;
  if (FEncodedByteAlign) and (FBitPointer <> 0) then
  begin
    Inc(FBytePointer);
    FBitPointer := 0;
    Result := True;
  end;
end;

function TQPLCCITTDecoder.ConsumeEOL: Boolean;
var
  Next12Bits: Integer;
begin
  Next12Bits := nextNBits(12);
  if (Next12Bits = 1) then
  begin
    Result := True;
  end else
  begin
    UpdatePointer(12);
    Result := False;
  end;
end;

// Returns run length
function TQPLCCITTDecoder.DecodeBlackCodeWord: Integer;
var
  Current: Integer;
  Entry: Integer;
  Bits: Integer;
  IsT: Integer;
  Code: Integer;
  RunLength: Integer;
  IsWhite: Boolean;
begin
  // code := -1;
  RunLength := 0;
  IsWhite := False;

  while (not IsWhite) do
  begin
    Current := NextLesserThan8Bits(4);
    Entry := InitBlack[Current];

    // Get the 3 fields from the entry
    // isT := entry and $0001;
    Bits := (Entry shr 1) and $000f;
    Code := (Entry shr 5) and $07ff;

    if (Code = 100) then
    begin
      Current := NextNBits(9);
      Entry := Black[Current];

      // Get the 3 fields from the entry
      IsT := Entry and $0001;
      Bits := (Entry shr 1) and $000f;
      Code := (Entry shr 5) and $07ff;

      if (Bits = 12) then
      begin
        // Additional makeup codes
        UpdatePointer(5);
        Current := NextLesserThan8Bits(4);
        Entry := AdditionalMakeup[Current];
        Bits := (Entry shr 1) and $07; // 3 bits 0000 0111
        Code := (Entry shr 4) and $0fff; // 12 bits
        RunLength := RunLength + Code;
        UpdatePointer(4 - Bits);
      end else
      if (Bits = 15) then
      begin
        // EOL code
        raise EInvalidOperation.Create('EOL code word encountered in Black run.'); //$NON-NLS-1$
      end else
      begin
        RunLength := RunLength + Code;
        UpdatePointer(9 - Bits);
        if (IsT = 0) then
        begin
          IsWhite := True;
        end;
      end;
    end else
    if (Code = 200)  then
    begin
      // Is a Terminating code
      Current := NextLesserThan8Bits(2);
      Entry := TwoBitBlack[Current];
      Code := (Entry shr 5) and $07ff;
      RunLength := RunLength + Code;
      Bits := (Entry shr 1) and $0f;
      UpdatePointer(2 - Bits);
      IsWhite := True;
    end else
    begin
      // Is a Terminating code
      RunLength := RunLength + Code;
      UpdatePointer(4 - bits);
      IsWhite := True;
    end;
  end;

  Result := RunLength;
end;

function TQPLCCITTDecoder.DecodeNextScanline(var Buffer: TCCITTByteArray; LineOffset, BitOffset: Integer): Boolean;
var
  Bits: Integer;
  Code: Integer;
  IsT: Integer;
  Current: Integer;
  Entry: Integer;
  TwoBits: Integer;
  IsWhite: Boolean;
begin
  IsWhite := True;
  Result := True;

  // Initialize starting of the changing elements array
  ChangingElemSize := 0;

  // While scanline not complete
  while (BitOffset < FWidth) do
  begin
    while (IsWhite) do
    begin
      // White run
      Current := NextNBits(10);
      Entry := White[Current];

      // Get the 3 fields from the entry
      IsT := Entry and $0001;
      Bits := (Entry shr 1) and $0f;

      if (Bits = 12) then
      begin // Additional Make up code
        // Get the next 2 bits
        TwoBits := NextLesserThan8Bits(2);
        // Consolidate the 2 new bits and last 2 bits into 4 bits
        Current := ((Current shl 2) and $000c) or TwoBits;
        Entry := AdditionalMakeup[Current];
        Bits := (Entry shr 1) and $07; // 3 bits 0000 0111
        Code := (Entry shr 4) and $0fff; // 12 bits
        BitOffset := BitOffset + Code; // Skip white run

        UpdatePointer(4 - Bits);
      end else
      if (Bits = 0) then
      begin // ERROR
        raise EInvalidOperation.Create('Invalid code encountered.');
        //Result := False;
      end else
      if (bits = 15) then
      begin
        // EOL recover
        // move bits back...
        UpdatePointer(10);
        Result := False;
        Exit;
      end else
      begin
        // 11 bits - 0000 0111 1111 1111 = $07ff
        Code := (Entry shr 5) and $07ff;
        BitOffset := BitOffset + Code;

        UpdatePointer(10 - Bits);
        if (IsT = 0) then
        begin
          IsWhite := False;
          CurrChangingElems[ChangingElemSize] := BitOffset;
          Inc(ChangingElemSize);
        end;
      end;
    end;

    // Check whether this run completed one width, if so
    // advance to next byte boundary for compression = 2.
    if (BitOffset = FWidth) then
    begin
      AlignToByte;
      Break;
    end;

    while (not IsWhite) do
    begin
      // Black run
      Current := NextLesserThan8Bits(4);
      Entry := InitBlack[Current];

      // Get the 3 fields from the entry
      // isT := entry and $0001;
      Bits := (Entry shr 1) and $000f;
      Code := (Entry shr 5) and $07ff;

      if (Code = 100) then
      begin
        Current := NextNBits(9);
        Entry := Black[Current];

        // Get the 3 fields from the entry
        IsT := Entry and $0001;
        Bits := (Entry shr 1) and $000f;
        Code := (Entry shr 5) and $07ff;

        if (Bits = 12) then
        begin
          // Additional makeup codes
          UpdatePointer(5);
          Current := NextLesserThan8Bits(4);
          Entry := AdditionalMakeup[Current];
          Bits := (Entry shr 1) and $07; // 3 bits 0000 0111
          Code := (Entry shr 4) and $0fff; // 12 bits

          SetToBlack(Buffer, LineOffset, BitOffset, Code);
          BitOffset := BitOffset + Code;

          UpdatePointer(4 - Bits);
        end else
        if (Bits = 15) then
        begin
          // EOL recover
          // unread bits ???
          UpdatePointer(9);
          Exit;
        end else
        begin
          SetToBlack(Buffer, LineOffset, BitOffset, Code);
          BitOffset := BitOffset + Code;

          UpdatePointer(9 - Bits);
          if (IsT = 0) then
          begin
            IsWhite := True;
            CurrChangingElems[ChangingElemSize] := BitOffset;
            Inc(ChangingElemSize);
          end;
        end;
      end else
      if (Code = 200) then
      begin
        // Is a Terminating code
        Current := NextLesserThan8Bits(2);
        Entry := TwoBitBlack[Current];
        Code := (Entry shr 5) and $07ff;
        Bits := (Entry shr 1) and $0f;

        SetToBlack(Buffer, LineOffset, BitOffset, Code);
        BitOffset := BitOffset + Code;

        UpdatePointer(2 - Bits);
        IsWhite := True;
        CurrChangingElems[ChangingElemSize] := BitOffset;
        Inc(ChangingElemSize);
      end else
      begin
        // Is a Terminating code
        SetToBlack(Buffer, LineOffset, BitOffset, Code);
        BitOffset := BitOffset + Code;

        UpdatePointer(4 - Bits);
        IsWhite := True;
        CurrChangingElems[ChangingElemSize] := BitOffset;
        Inc(ChangingElemSize);
      end;
    end;

    // Check whether this run completed one width
    if (BitOffset = FWidth) then
    begin
      AlignToByte;
      Break;
    end;
  end;

  CurrChangingElems[ChangingElemSize] := BitOffset;
  Inc(ChangingElemSize);
end;

// One-dimensional decoding methods
function TQPLCCITTDecoder.DecodeT41D(var Buffer: TCCITTByteArray; CompData: TCCITTByteArray): Boolean;
var
  I: Integer;
  ScanLineStride: Integer;
  LineOffset: Integer;
begin
  Result := True;
  try
    FCompData := CompData;
    ScanlineStride := (FWidth + 7) div 8;
    FBitPointer := 0;
    FBytePointer := 0;

    LineOffset := 0;
    for I := 0 to FHeight - 1 do
    begin
      ConsumeEOL;
      if (not DecodeNextScanline(Buffer, LineOffset, 0)) then
      begin
        Result := False;
        Exit;
      end;
      LineOffset := LineOffset + ScanlineStride;
    end;
  except
    //FillChar(Buffer[0], Length(Buffer), 0);
    Result := False;
  end;
end;

// Two-dimensional decoding methods
procedure TQPLCCITTDecoder.DecodeT42D(var Buffer: TCCITTByteArray; CompData: TCCITTByteArray);
var
  a0: Integer;
  a1: Integer;
  b1: Integer;
  b2: Integer;
  b: TCCITTIntegerArray;
  ScanlineStride: Integer;
  Entry: Integer;
  Code: Integer;
  Bits: Integer;
  IsWhite: Boolean;
  CurrIndex: Integer;
  Temp: TCCITTIntegerArray;
  Lines: Integer;
  Number: Integer;
  LineOffset: Integer;
  BitOffset: Integer;
begin
  SetLength(Temp, 0);
  FCompData := CompData;
  ScanlineStride := (FWidth + 7) div 8;
  FBitPointer := 0;
  FBytePointer := 0;

  SetLength(b, 2);

  // The data must start with an EOL code
  if (ReadEOL(True) <> 1) then
  begin
    raise EInvalidOperation.Create('First scanline must be 1D encoded.'); //$NON-NLS-1$
  end;

  LineOffset := 0;

  // Then the 1D encoded scanline data will occur, changing elements
  // array gets set.
  DecodeNextScanline(Buffer, LineOffset, 0);
  LineOffset := LineOffset + ScanlineStride;

  for Lines := 1 to FHeight - 1 do
  begin
    // Every line must begin with an EOL followed by a bit which
    // indicates whether the following scanline is 1D or 2D encoded.
    if (ReadEOL(False) = 0) then
    begin
      // 2D encoded scanline follows

      // Initialize previous scanlines changing elements, and
      // initialize current scanline's changing elements array
      Temp := PrevChangingElems;
      PrevChangingElems := CurrChangingElems;
      CurrChangingElems := Temp;
      CurrIndex := 0;

      // a0 has to be set just before the start of this scanline.
      a0 := -1;
      IsWhite := True;
      BitOffset := 0;

      LastChangingElement := 0;

      while (BitOffset < FWidth) do
      begin
        // Get the next changing element
        b := GetNextChangingElement(a0, IsWhite);

        b1 := b[0];
        b2 := b[1];

        // Get the next seven bits
        Entry := NextLesserThan8Bits(7);

        // Run these through the 2DCodes table
        Entry := (TwoDCodes[Entry] and $ff);

        // Get the code and the number of bits used up
        Code := (Entry and $78) shr 3;
        Bits := Entry and $07;

        if (Code = 0) then
        begin
          if (not IsWhite) then
          begin
            SetToBlack(Buffer, LineOffset, BitOffset, b2 - BitOffset);
          end;
          a0 := b2;
          BitOffset := a0;

          // Set pointer to consume the correct number of bits.
          UpdatePointer(7 - Bits);
        end else
        if (Code = 1) then
        begin
          // Horizontal
          UpdatePointer(7 - Bits);

          // identify the next 2 codes.
          if (IsWhite) then
          begin
            Number := DecodeWhiteCodeWord;
            BitOffset := BitOffset + Number;
            CurrChangingElems[CurrIndex] := BitOffset;
            Inc(CurrIndex);

            Number := DecodeBlackCodeWord;
            SetToBlack(Buffer, LineOffset, BitOffset, Number);
            BitOffset := BitOffset + Number;
            CurrChangingElems[CurrIndex] := BitOffset;
            Inc(CurrIndex);
          end else
          begin
            Number := DecodeBlackCodeWord;
            SetToBlack(Buffer, LineOffset, BitOffset, Number);
            BitOffset := BitOffset + Number;
            CurrChangingElems[CurrIndex] := BitOffset;
            Inc(CurrIndex);

            Number := DecodeWhiteCodeWord;
            BitOffset := BitOffset + Number;
            CurrChangingElems[CurrIndex] := BitOffset;
            Inc(CurrIndex);
          end;

          a0 := BitOffset;
        end else
        if (Code <= 8) then
        begin
          // Vertical
          a1 := b1 + (Code - 5);

          CurrChangingElems[CurrIndex] := a1;
          Inc(CurrIndex);

          // We write the current color till a1 - 1 pos,
          // since a1 is where the next color starts
          if (not IsWhite) then
          begin
            SetToBlack(Buffer, LineOffset, BitOffset, a1 - BitOffset);
          end;
          a0 := a1;
          BitOffset := a0;
          IsWhite := not IsWhite;  // ????

          UpdatePointer(7 - Bits);
        end else
        begin
          raise EInvalidOperation.Create('Invalid code encountered while decoding 2D group 3 compressed data.'); //$NON-NLS-1$
        end;
      end;

      // Add the changing element beyond the current scanline for the
      // other color too
      if (CurrIndex < FWidth) then
      begin
        CurrChangingElems[CurrIndex] := BitOffset;
        Inc(CurrIndex);
      end else
      begin
        Exit;
      end;
      ChangingElemSize := CurrIndex;
    end else
    begin
      // 1D encoded scanline follows
      DecodeNextScanline(Buffer, LineOffset, 0);
    end;

    LineOffset := LineOffset + ScanlineStride;
  end;
end;

function TQPLCCITTDecoder.DecodeT6(var Buffer: TCCITTByteArray; CompData: TCCITTByteArray): Boolean;
var
  a0: Integer;
  a1: Integer;
  b1: Integer;
  b2: Integer;
  b: TCCITTIntegerArray;
  Entry: Integer;
  Code: Integer;
  Bits: Integer;
  IsWhite: Boolean;
  CurrIndex: Integer;
  Temp: TCCITTIntegerArray;
  Lines: Integer;
  Number: Integer;
  CCE: TCCITTIntegerArray;
  LineOffset: Integer;
  BitOffset: Integer;
  Zeros: Integer;
  MustExit: Boolean;
  ScanLineStride: Integer;
  DecodeError: Boolean;
begin
  Result := True;
  SetLength(Temp, 0);
  SetLength(CCE, 0);
  try
    FCompData := CompData;
    ScanlineStride := (FWidth + 7) div 8;
    FBitPointer := 0;
    FBytePointer := 0;

    // Return values from getNextChangingElement
    SetLength(b, 2);

    // uncompressedMode - have written some code for this, but this
    // has not been tested due to lack of test images using this optional

    // Local cached reference
    CCE := CurrChangingElems;

    // Assume invisible preceding row of all white pixels and insert
    // both black and white changing elements beyond the end of this
    // imaginary scanline.
    ChangingElemSize := 0;
    CCE[ChangingElemSize] := FWidth;
    Inc(ChangingElemSize);
    CCE[ChangingElemSize] := FWidth;
    Inc(ChangingElemSize);

    LineOffset := 0;

    Lines := 0;
    DecodeError := False;
    while ((Lines <= (FHeight - 1) * FBitsPerComponent) and (not DecodeError)) do
    begin
      // a0 has to be set just before the start of the scanline.
      a0 := -1;
      IsWhite := True;

      // Assign the changing elements of the previous scanline to
      // prevChangingElems and start putting this new scanline's
      // changing elements into the currChangingElems.
      Temp := PrevChangingElems;
      PrevChangingElems := CurrChangingElems;
      CurrChangingElems := Temp;
      CCE := CurrChangingElems;
      CurrIndex := 0;

      // Start decoding the scanline at startX in the raster
      BitOffset := 0;

      // Reset search start position for getNextChangingElement
      LastChangingElement := 0;

      // Till one whole scanline is decoded
      while (BitOffset < FWidth) do
      begin
        // Get the next changing element
        b := GetNextChangingElement(a0, IsWhite);
        b1 := b[0];
        b2 := b[1];

        // Get the next seven bits
        Entry := NextLesserThan8Bits(7);
        // Run these through the 2DCodes table
        Entry := (TwoDCodes[Entry] and $ff);

        // Get the code and the number of bits used up
        Code := (Entry and $78) shr 3;
        Bits := Entry and $07;

        if (Code = 0) then
        begin // Pass
          // We always assume WhiteIsZero format for fax.
          if (not IsWhite) then
          begin
            if (b2 > FWidth) then
            begin
              b2 := FWidth;
            end;
            SetToBlack(Buffer, LineOffset, BitOffset, b2 - BitOffset);
          end;
          a0 := b2;
          BitOffset := a0;

          // Set pointer to only consume the correct number of bits.
          UpdatePointer(7 - Bits);
        end else
        if (Code = 1) then
        begin // Horizontal
          // Set pointer to only consume the correct number of bits.
          UpdatePointer(7 - Bits);

          // identify the next 2 alternating color codes.
          if (IsWhite) then
          begin
            // Following are white and black runs
            Number := DecodeWhiteCodeWord;
            BitOffset := BitOffset + Number;
            CCE[CurrIndex] := BitOffset;
            Inc(CurrIndex);

            Number := DecodeBlackCodeWord;
            if (Number > FWidth - BitOffset) then
            begin
              Number := FWidth - BitOffset;
            end;
            SetToBlack(Buffer, LineOffset, BitOffset, Number);
            BitOffset := BitOffset + Number;
            CCE[CurrIndex] := BitOffset;
            Inc(CurrIndex);
          end else
          begin
            // First a black run and then a white run follows
            Number := DecodeBlackCodeWord;
            if (Number > FWidth - BitOffset) then
            begin
              Number := FWidth - BitOffset;
            end;
            SetToBlack(Buffer, LineOffset, BitOffset, Number);
            Inc(BitOffset, Number);
            CCE[CurrIndex] := BitOffset;
            Inc(CurrIndex);

            Number := DecodeWhiteCodeWord;
            Inc(BitOffset, Number);
            CCE[CurrIndex] := BitOffset;
            Inc(CurrIndex);
          end;

          a0 := BitOffset;
        end else
        if ((Code <= 8) and (CurrIndex < FWidth)) then
        begin // Vertical
          a1 := b1 + (code - 5);
          CCE[CurrIndex] := a1;
          Inc(CurrIndex);

          // We write the current color till a1 - 1 pos,
          // since a1 is where the next color starts
          if (not IsWhite) then
          begin
            if (a1 > FWidth) then
            begin
              a1 := FWidth;
            end;
            SetToBlack(Buffer, LineOffset, BitOffset, a1 - BitOffset);
          end;
          a0 := a1;
          BitOffset := a0;
          IsWhite := not IsWhite;

          UpdatePointer(7 - Bits);
        end else
        if (Code = 11) then
        begin
          if (NextLesserThan8Bits(3) <> 7) then
          begin
            raise EInvalidOperation.Create('Invalid code encountered while ' +
              'decoding 2D group 4 compressed data.'); //$NON-NLS-1$
          end;

          Zeros := 0;
          MustExit := False;

          while (not MustExit) do
          begin
            while (NextLesserThan8Bits(1) <> 1) do
            begin
              Inc(zeros);
            end;

            if (zeros > 5) then
            begin
              // Exit code

              // Zeros before exit code
              zeros := zeros - 6;

              if (not IsWhite) and (zeros > 0) then
              begin
                CCE[CurrIndex] := BitOffset;
                Inc(CurrIndex);
              end;

              // Zeros before the exit code
              BitOffset := BitOffset + zeros;
              if (zeros > 0) then
              begin
                // Some zeros have been written
                IsWhite := True;
              end;

              // Read in the bit which specifies the color of
              // the following run
              if (NextLesserThan8Bits(1) = 0) then
              begin
                if (not IsWhite) then
                begin
                  CCE[CurrIndex] := BitOffset;
                  Inc(CurrIndex);
                end;
                IsWhite := True;
              end else
              begin
                if (IsWhite) then
                begin
                  CCE[CurrIndex] := BitOffset;
                  Inc(CurrIndex);
                end;
                IsWhite := False;
              end;

              MustExit := True;
            end;

            if (zeros = 5) then
            begin
              if (not IsWhite) then
              begin
                CCE[CurrIndex] := BitOffset;
                Inc(CurrIndex);
              end;
              BitOffset := BitOffset + zeros;

              // Last thing written was white
              IsWhite := True;
            end else
            begin
              BitOffset := BitOffset + zeros;

              CCE[CurrIndex] := BitOffset;
              Inc(CurrIndex);
              SetToBlack(Buffer, LineOffset, BitOffset, 1);
              Inc(BitOffset);

              // Last thing written was black
              IsWhite := False;
            end;
          end;
        end else
        begin
          // break line - seems to be a common failure
          // unread
          UpdatePointer(7 - Bits);
          // and mark lines as complete
          BitOffset := FWidth;
          // throw new RuntimeException(
          // "Invalid code encountered while decoding 2D group 4
          // compressed data."); //$NON-NLS-1$
          DecodeError := True;
          Result := False;
        end;
      end;

      AlignToByte;

      // Add the changing element beyond the current scanline for the
      // other color too
      // make sure that the index does not exceed the bounds of the array
      if (CurrIndex < FWidth) then
      begin
        CCE[CurrIndex] := BitOffset;
        Inc(CurrIndex);
      end else
      begin
        //raise EInvalidOperation.Create('Invalid code encountered while ' +
        //   'decoding 2D group 4 compressed data.'); //$NON-NLS-1$
        DecodeError := True;
        Result := False;
      end;

      // Number of changing elements in this scanline.
      ChangingElemSize := CurrIndex;

      LineOffset := LineOffset + scanlineStride;
      Inc(Lines);
    end;
  except
    FillChar(Buffer[0], Length(Buffer), 0);
    Result := False;
  end;
end;

// Returns run length
function TQPLCCITTDecoder.DecodeWhiteCodeWord: Integer;
var
  Current: Integer;
  Entry: Integer;
  Bits: Integer;
  IsT: Integer;
  TwoBits: Integer;
  Code: Integer;
  RunLength: Integer;
  IsWhite: Boolean;
begin
  RunLength := 0;
  IsWhite := True;

  while (IsWhite) do
  begin
    Current := NextNBits(10);
    Entry := White[Current];

    // Get the 3 fields from the entry
    IsT := Entry and $0001;
    Bits := (Entry shr 1) and $0f;

    if (Bits = 12) then
    begin // Additional Make up code
      // Get the next 2 bits
      TwoBits := NextLesserThan8Bits(2);
      // Consolidate the 2 new bits and last 2 bits into 4 bits
      Current := ((Current shl 2) and $000c) or TwoBits;
      Entry := AdditionalMakeup[Current];
      Bits := (Entry shr 1) and $07; // 3 bits 0000 0111
      Code := (Entry shr 4) and $0fff; // 12 bits
      Inc(RunLength, Code);
      UpdatePointer(4 - Bits);
    end else
    if (Bits = 0) then
    begin // ERROR
      raise EInvalidOperation.Create('Invalid code encountered.'); //$NON-NLS-1$
    end else
    if (Bits = 15) then
    begin // EOL
      raise EInvalidOperation.Create('EOL code word encountered in White run.'); //$NON-NLS-1$
    end else
    begin
      // 11 bits - 0000 0111 1111 1111 = $07ff
      Code := (Entry shr 5) and $07ff;
      Inc(RunLength, Code);
      UpdatePointer(10 - Bits);
      if (isT = 0) then
      begin
        IsWhite := False;
      end;
    end;
  end;

  Result := RunLength;
end;

function TQPLCCITTDecoder.GetNextChangingElement(a0: Integer; IsWhite: Boolean): TCCITTIntegerArray;
var
  PCE: TCCITTIntegerArray;
  CES: Integer;
  Start: Integer;
  I: Integer;
  Temp: Integer;
begin
  // Local copies of instance variables
  PCE := PrevChangingElems;
  CES := ChangingElemSize;

  // If the previous match was at an odd element, we still
  // have to search the preceeding element.
  // int start = lastChangingElement and ~$1;
  // start := (lastChangingElement > 0) ? (lastChangingElement - 1) : 0;
  Start := 0;
  if ((LastChangingElement > 0)) then
  begin
    Start := (LastChangingElement - 1);
  end;

  if (IsWhite) then
  begin
    Start := Start and (not $1); // Search even numbered elements
  end else
  begin
    Start := Start or $1; // Search odd numbered elements
  end;

  I := Start;
  while (I < CES) do
  begin
    Temp := PCE[I];
    if (Temp > a0) then
    begin
      LastChangingElement := I;
      Result[0] := Temp;
      Break;
    end;
    Inc(I, 2);
  end;

  if ((I + 1) < CES) then
  begin
    Result[1] := PCE[I + 1];
  end;
end;

function TQPLCCITTDecoder.NextLesserThan8Bits(BitsToGet: Integer): Integer;
var
  b: ShortInt;
  Next: ShortInt;
  L: Integer;
  TempBytePointer: Integer;
  BitsLeft: Integer;
  BitsFromNextByte: Integer;
  Shift: Integer;
  i1: Integer;
  i2: Integer;
begin
  L := Length(FCompData) - 1;
  TempBytePointer := FBytePointer;

  if (FFillOrder = 1) then
  begin
    b := FCompData[TempBytePointer];
    if (TempBytePointer = l) then
    begin
      Next := $00;
    end else
    begin
      Next := FCompData[TempBytePointer + 1];
    end;
  end else
  if (FFillOrder = 2) then
  begin
    b := FlipTable[FCompData[TempBytePointer] and $ff];
    if (TempBytePointer = l) then
    begin
      Next := $00;
    end else
    begin
      Next := FlipTable[FCompData[TempBytePointer + 1] and $ff];
    end;
  end else
  begin
    raise EInvalidOperation.Create('tag must be either 1 or 2.'); //$NON-NLS-1$
  end;

  BitsLeft := 8 - FBitPointer;
  BitsFromNextByte := BitsToGet - BitsLeft;

  Shift := BitsLeft - BitsToGet;
  if (Shift >= 0) then
  begin
    i1 := (b and Table1[BitsLeft]) shr Shift;
    FBitPointer := FBitPointer + BitsToGet;
    if (FBitPointer = 8) then
    begin
      FBitPointer := 0;
      Inc(FBytePointer);
    end;
  end else
  begin
    i1 := (b and Table1[BitsLeft]) shl (-Shift);
    i2 := (Next and Table2[BitsFromNextByte]) shr (8 - BitsFromNextByte);

    i1 := i1 or i2;
    Inc(FBytePointer);
    FBitPointer := BitsFromNextByte;
  end;

  Result := i1;
end;

function TQPLCCITTDecoder.NextNBits(BitsToGet: Integer): Integer;
var
  b: ShortInt;
  Next: ShortInt;
  Next2Next: ShortInt;
  L: Integer;
  TempBytePointer: Integer;
  BitsLeft: Integer;
  BitsFromNextByte: Integer;
  BitsFromNext2NextByte: Integer;
  i1: Integer;
  i2: Integer;
  i3: Integer;
begin
  L := Length(FCompData) - 1;
  TempBytePointer := FBytePointer;

  if (FFillOrder = 1) then
  begin
    b := FCompData[TempBytePointer];

    if (TempBytePointer = l) then
    begin
      Next := $00;
      Next2Next := $00;
    end else
    if ((TempBytePointer + 1) = l) then
    begin
      Next := FCompData[TempBytePointer + 1];
      Next2Next := $00;
    end else
    begin
      Next := FCompData[TempBytePointer + 1];
      Next2Next := FCompData[TempBytePointer + 2];
    end;
  end else
  if (FFillOrder = 2) then
  begin
    b := FlipTable[FCompData[TempBytePointer] and $ff];

    if (TempBytePointer = l) then
    begin
      Next := $00;
      Next2Next := $00;
    end else
    if ((TempBytePointer + 1) = l) then
    begin
      Next := FlipTable[FCompData[TempBytePointer + 1] and $ff];
      Next2Next := $00;
    end else
    begin
      Next := FlipTable[FCompData[TempBytePointer + 1] and $ff];
      Next2Next := FlipTable[FCompData[TempBytePointer + 2] and $ff];
    end;
  end else
  begin
    raise EInvalidOperation.Create('tag must be either 1 or 2.'); //$NON-NLS-1$
  end;

  BitsLeft := 8 - FBitPointer;
  BitsFromNextByte := BitsToGet - BitsLeft;
  BitsFromNext2NextByte := 0;

  if (BitsFromNextByte > 8) then
  begin
    BitsFromNext2NextByte := BitsFromNextByte - 8;
    BitsFromNextByte := 8;
  end;

  Inc(FBytePointer);

  i1 := (b and Table1[BitsLeft]) shl (BitsToGet - BitsLeft);
  i2 := (Next and Table2[BitsFromNextByte]) shr (8 - BitsFromNextByte);

  // i3 := 0;
  if (BitsFromNext2NextByte <> 0) then
  begin
    i2 := i2 shl BitsFromNext2NextByte;
    i3 := (Next2Next and Table2[BitsFromNext2NextByte]) shr (8 - BitsFromNext2NextByte);
    i2 := i2 or i3;
    Inc(FBytePointer);
    FBitPointer := BitsFromNext2NextByte;
  end else
  begin
    if (BitsFromNextByte = 8) then
    begin
      FBitPointer := 0;
      Inc(FBytePointer);
    end else
    begin
      FBitPointer := BitsFromNextByte;
    end;
  end;

  Result := i1 or i2;
end;

function TQPLCCITTDecoder.ReadEOL(IsFirstEOL: Boolean): Integer;
var
  Next12Bits: Integer;
  BitsLeft: Integer;
  Next8: Integer;
begin
  // Seek to the next EOL.
  if (not SeekEOL) then
  begin
    raise EInvalidOperation.Create('EOL not found');
  end;

  if (not FFillBits) then
  begin
    Next12Bits := NextNBits(12);
    if (IsFirstEOL and (Next12Bits = 0)) then
    begin
      // Might have the case of EOL padding being used even
      // though it was not flagged.
      // This was observed to be the case in TIFFs produced
      // by a well known vendor who shall remain nameless.
      if (NextNBits(4) = 1) then
      begin
        // EOL must be padded: reset the fillBits flag.
        FFillBits := True;
        Result := 1;
        Exit;
      end;
    end;
    if (Next12Bits <> 1) then
    begin
      raise EInvalidOperation.Create('Scanline must begin with EOL code word.'); //$NON-NLS-1$
    end;
  end else
  begin
    // First EOL code word xxxx 0000 0000 0001 will occur
    // As many fill bits will be present as required to make
    // the EOL code of 12 bits end on a byte boundary.
    BitsLeft := 8 - FBitPointer;

    if (NextNBits(BitsLeft) <> 0) then
    begin
      raise EInvalidOperation.Create('All fill bits preceding EOL code must be 0.'); //$NON-NLS-1$
    end;

    // If the number of bitsLeft is less than 8, then to have a 12
    // bit EOL sequence, two more bytes are certainly going to be
    // required. The first of them has to be all zeros, so ensure
    // that.
    if (BitsLeft < 4) then
    begin
      if (NextNBits(8) <> 0) then
      begin
        raise EInvalidOperation.Create('All fill bits preceding EOL code must be 0.'); //$NON-NLS-1$
      end;
    end;

    //
    // Some encoders under Group 3 Fax compression 1D writes TIFF
    // files without the fill bits, but say otherwise.
    // Need to check for this here.
    //
    Next8 := NextNBits(8);

    if (IsFirstEOL and ((Next8 and $f0) = $10)) then
    begin
      //
      // Fill bits are not actually used despite what the flag
      // says. So switch fillBits off and then rewind so that
      // only 12 bits have effectively been read.
      //
      FFillBits := False;
      UpdatePointer(4);
    end else
    begin
      //
      // This is the normal case.
      // There might be a random number of fill bytes with 0s, so
      // loop till the EOL of 0000 0001 is found, as long as all
      // the bytes preceding it are 0's.
      //
      while (Next8 <> 1) do
      begin
        // If not all zeros
        if (Next8 <> 0) then
        begin
          raise EInvalidOperation.Create('0 bits expected before EOL');
        end;
        Next8 := NextNBits(8);
      end;
    end;
  end;
  // The next one bit signifies 1D/2D encoding of next line.
  Result := NextLesserThan8Bits(1);
end;

// Seeks to the next EOL in the compressed bitstream.
// Returns 'true' if and only if an EOL is found; if 'false'
// is returned it may be inferred that the EOF was reached first.
function TQPLCCITTDecoder.seekEOL: Boolean;
var
  BitIndexMax: Integer;
  BitIndex: Integer;
  Next12Bits: Integer;
begin
  // Set maximum and current bit index into the compressed data.
  BitIndexMax := Length(FCompData) * 8 - 1;
  BitIndex := FBytePointer * 8 + FBitPointer;

  Result := False;

  // Loop while at least 12 bits are available.
  while (BitIndex <= BitIndexMax - 12) and (not Result) do
  begin
    // Get the next 12 bits.
    Next12Bits := NextNBits(12);
    BitIndex := BitIndex + 12;

    // Loop while the 12 bits are not unity, i.e., while the EOL
    // has not been reached, and there is at least one bit left.
    while (Next12Bits <> 1) and (BitIndex < BitIndexMax) do
    begin
      Next12Bits := ((Next12Bits and $000007ff) shl 1)
          or (NextLesserThan8Bits(1) and $00000001);
      Inc(BitIndex);
    end;

    // If EOL reached, rewind the pointers and return 'true'.
    if (Next12Bits = 1) then
    begin
      UpdatePointer(12);
      Result := True;
    end;
  end;

  // EOL not found: return 'false'.
end;

procedure TQPLCCITTDecoder.SetToBlack(var Buffer: TCCITTByteArray; LineOffset, BitOffset, numBits: Integer);
var
  BitNum: Integer;
  LastBit: Integer;
  ByteNum: Integer;
  Shift: Integer;
  MaskVal: Integer;
  Val: ShortInt;
begin
  BitNum := (8 * LineOffset) + BitOffset;
  LastBit := BitNum + NumBits;

  ByteNum := BitNum shr 3;

  // Handle bits in first byte
  Shift := BitNum and $7;
  if (Shift > 0) then
  begin
    MaskVal := 1 shl (7 - Shift);
    Val := Buffer[ByteNum];
    while ((MaskVal > 0) and (BitNum < LastBit)) do
    begin
      Val := Val or MaskVal;
      MaskVal := MaskVal shr 1;
      Inc(BitNum);
    end;
    Buffer[ByteNum] := Val;
  end;

  // Fill in 8 bits at a time
  ByteNum := BitNum shr 3;
  while (BitNum < (LastBit - 7)) do
  begin
    Buffer[ByteNum] := ShortInt(255);
    Inc(byteNum);
    Inc(BitNum, 8);
  end;

  // Fill in remaining bits
  while (BitNum < LastBit) do
  begin
    ByteNum := BitNum shr 3;
    Buffer[byteNum] := ShortInt(Buffer[byteNum] or (1 shl (7 - (BitNum and $7))));
    Inc(bitNum)
  end;
end;

// Move pointer backwards by given amount of bits
procedure TQPLCCITTDecoder.UpdatePointer(BitsToMoveBack: Integer);
var
  I: Integer;
begin
  if (BitsToMoveBack > 8) then
  begin
    FBytePointer := FBytePointer - BitsToMoveBack div 8;
    BitsToMoveBack := BitsToMoveBack mod 8;
  end;

  I := FBitPointer - BitsToMoveBack;

  if (I < 0) then
  begin
    Dec(FBytePointer);
    FBitPointer := 8 + I;
  end else
  begin
    FBitPointer := I;
  end;
end;

end.
