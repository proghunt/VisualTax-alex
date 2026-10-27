unit vtDynData;
(* Helper routines for dynamic data.
  Should use FRec instead of FormName
*)

interface

uses
  vtMulti,
  SysUtils,Dialogs;  //20150825

var //calculated by SplitDynId (ElmNo)
  ArrayNo, //dyn array index
  DynElmIdx, //element index in dyn array data  //20150823 it appears to be the column No? i.e 10003-10000=3? (Con)
  RowNo, //row number of element [0..n]
  ColNo, //column number of element [0..n]
  TopRow, //highest row in array
  BoxesPerRow, //columns in dyn array
  MaxElm: integer; //high index in dyn array data

function SplitDynId(RetNo, FNo, ElmNo: integer): boolean; //True if element exists
function DynamicRowHasData(RetNo: Integer; FRec: TFRec; ArrayNo, RowNo: Integer): Boolean;
function DynamicFieldRowHasData(RetNo: integer; FRec: TFRec; ElmNo: integer): boolean;
function isFormDynamic(RetNo: integer; FName: string): Boolean;
function SumOfColumn(RetNo, FNo, FieldId: integer): real;
function DynamicRowCount(RetNo, FNo, ArrayNo: Integer): Integer; //20160430 Igor
procedure ClearDynColumn(RetNo, FNo, FieldId: integer); //20190225 Igor

implementation

uses
  vtTrimStr; //VL()

function SplitDynId(RetNo, FNo, ElmNo: integer): boolean; //True if element exists
begin
  Result := RetList[RetNo].Frm[FNo].SplitId(ElmNo, False, false); //don't extend! //20160212 Igor
end;

function isFormDynamic(RetNo: integer; FName: string): Boolean;
begin
  Result := RetList[RetNo].Form[FName].Dyn <> nil; //dyn data allocated?
end;

function DynamicRowHasData(RetNo: Integer; FRec: TFRec; ArrayNo, RowNo: Integer): Boolean;
//Function DynamicRowHasData(RetNo:Integer;FName:String;ArrayNo,RowNo:Integer):Boolean;
var
  //BoxesPerRow, - use global
  FromElm, i: integer;
begin
  (* Purpose: When to add/remove a row from a form.
    Add a row when the last row becomes non-empty,
    remove any empty row (except the last one).

    By definition a row is empty when the first field is empty?
  *)
  Result := True;
  with RetList[RetNo].Frm[FRec.FormNo] do
  begin
    BoxesPerRow := FRec.BoxesPerRow[ArrayNo];
    FromElm := RowNo * BoxesPerRow + ElmBase;
    for i := FromElm to FromElm + BoxesPerRow - 1 do
      if Dyn[ArrayNo, i] <> '' then
        exit; //found non-empty elm
  end;
  //not found
  Result := False; //no data
end;

function DynamicFieldRowHasData(RetNo: integer; FRec: TFRec; ElmNo: integer): boolean;
begin
  Result := SplitDynId(RetNo, FRec.FormNo, ElmNo);
  if Result then
    Result := DynamicRowHasData(RetNo, FRec, ArrayNo, RowNo);
end;

function SumOfColumn(RetNo, FNo, FieldId: integer): real;
var
  i: integer;
begin
  Result := 0;
  if not SplitDynId(RetNo, FNo, FieldId) then
  begin
    ShowMessage('Not a dynamic field in FNo='+IntToStr(FNo)+' FieldId='+IntToStr(FieldId)); //20150825
    exit; //not dynamic?
  end;
  with RetList[RetNo].Frm[FNo] do
    while DynElmIdx <= MaxElm do
    begin
      Result := Result + VL(Dyn[ArrayNo, DynElmIdx]);
      inc(DynElmIdx, BoxesPerRow);
    end;
end;

function DynamicRowCount(RetNo, FNo, ArrayNo: Integer): Integer; //20160430 Igor
var
  BoxPerRow: Integer;
  MaxElm: Integer;
Begin
  BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
  MaxElm := high(RetList[RetNo].Frm[FNo].Dyn[ArrayNo]);
  Result := (MaxElm - ElmBase) div BoxesPerRow;
End;

procedure ClearDynColumn(RetNo, FNo, FieldId: integer); //20190225 Igor
var
  i: integer;
begin
  if not SplitDynId(RetNo, FNo, FieldId) then
  begin
    ShowMessage('Not a dynamic field in FNo='+IntToStr(FNo)+' FieldId='+IntToStr(FieldId));
    exit; //not dynamic?
  end;
  with RetList[RetNo].Frm[FNo] do
    while DynElmIdx <= MaxElm do
    begin
      Dyn[ArrayNo, DynElmIdx] := '';
      inc(DynElmIdx, BoxesPerRow);
    end;
end;

end.

