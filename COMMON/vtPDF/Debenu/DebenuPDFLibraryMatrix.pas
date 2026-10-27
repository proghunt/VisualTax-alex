{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryMatrix.pas                             }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryMatrix;

{$I DebenuPDFLibraryDefines.inc}

interface

type
  TPDFDoublePoint = record
    X: Double;
    Y: Double;
  end;

  TPDFXForm = record
    eM11: Double;
    eM12: Double;
    eM21: Double;
    eM22: Double;
    eDx: Double;
    eDy: Double;
  end;

const
  TPDFXFormIdentity: TPDFXForm = (eM11: 1; eM12: 0; eM21: 0; eM22: 1; eDx: 0; eDy: 0);
  TPDFXFormEMSize = SizeOf(Double) * 4;
  TPDFXformEDSize = SizeOf(Double) * 2;

procedure CombinePDFXForm(var MR, M1, M2: TPDFXForm);
function DoPDFXForm(var Mat: TPDFXForm; var P: TPDFDoublePoint): TPDFDoublePoint;

implementation

procedure CombinePDFXForm(var MR, M1, M2: TPDFXForm);
var
  Tmp: TPDFXForm;
begin
  Tmp.eM11 := M1.eM11 * M2.eM11 + M1.eM12 * M2.eM21;
  Tmp.eM12 := M1.eM11 * M2.eM12 + M1.eM12 * M2.eM22;
  Tmp.eM21 := M1.eM21 * M2.eM11 + M1.eM22 * M2.eM21;
  Tmp.eM22 := M1.eM21 * M2.eM12 + M1.eM22 * M2.eM22;
  Tmp.eDx := M1.eDx * M2.eM11 + M1.eDy * M2.eM21 + M2.eDx;
  Tmp.eDy := M1.eDx * M2.eM12 + M1.eDy * M2.eM22 + M2.eDy;

  Move(Tmp, MR, SizeOf(MR));
end;

function DoPDFXForm(var Mat: TPDFXForm; var P: TPDFDoublePoint): TPDFDoublePoint;
begin
  Result.X := Mat.eM11 * P.X + Mat.eM21 * P.Y + Mat.eDx;
  Result.Y := Mat.eM12 * P.X + Mat.eM22 * P.Y + Mat.eDy;
end;

end.
