unit Ufrmgrid;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,
  Udeclare, TrimStr, ChildWin, Grids;
type
  TFrmGrid = class(TForm)
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmGrid: TFrmGrid;

implementation

{$R *.DFM}

procedure TFrmGrid.FormCreate(Sender: TObject);
Var I:integer;
RowCounters : array[0..6] of integer;
begin
 For i:=Low(RowCounters) to High(RowCounters) do
    RowCounters[i]:=0;
 StringGrid1.Cells[0,0] := 'T1/Schedules';
 StringGrid1.Cells[1,0] := 'Prov Tax/Cr';
 StringGrid1.Cells[2,0] := 'Slips';
 StringGrid1.Cells[3,0] := 'Self Empl/Rental';
 StringGrid1.Cells[4,0] := 'T - Forms';
 StringGrid1.Cells[5,0] := 'Misc.';
 StringGrid1.Cells[6,0] := 'Admin';
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec^.FormShow then
   begin
     With StringGrid1 do
     begin
      If Frec^.FormType = 'T1' then
       begin Inc(RowCounters[0]);Cells[0,RowCounters[0]]:=Frec^.FormRlNm;end
      Else If Frec^.FormType = 'CR' then
       begin Inc(RowCounters[1]);Cells[1,RowCounters[1]]:=Frec^.FormRlNm;end
      Else If Frec^.FormType = 'SL' then
       begin Inc(RowCounters[2]);Cells[2,RowCounters[2]]:=Frec^.FormRlNm;end
      Else If Frec^.FormType = 'SE' then
       begin Inc(RowCounters[3]);Cells[3,RowCounters[3]]:=Frec^.FormRlNm;end
      Else If Frec^.FormType = 'TF' then
       begin Inc(RowCounters[4]);Cells[4,RowCounters[4]]:=Frec^.FormRlNm;end
      Else If Frec^.FormType = 'MI' then
       begin Inc(RowCounters[5]);Cells[5,RowCounters[5]]:=Frec^.FormRlNm;end
      Else If Frec^.FormType = 'AD' then
       begin Inc(RowCounters[6]);Cells[6,RowCounters[6]]:=Frec^.FormRlNm;end
      ;
     end;
   end;
 end;
end;

end.
