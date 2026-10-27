{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O-,P+,Q-,R+,S-,T-,U-,V+,W+,X+,Y+,Z1}
unit vtMemoBox;
(* D5 memo bug!
  memo.Text:=s doesn't init memo.Lines.Count
Workaround:
  SomeList.Text:=s;
  memo.Lines.Assign(SomeList);
*)

interface

uses
  System.SysUtils, System.Classes, VCL.Controls, VCL.StdCtrls, WinAPI.Messages; //,vtDeclare;

type
  TvtMemo = class(TMemo)
  private
    FMaxLines: Integer;
    procedure SetMaxLines(const Value: Integer);
    procedure ValidateLinesChar;
  protected
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  published
    property vtMaxLines: Integer read FMaxLines write SetMaxLines default 0;
  end;

procedure Register;

implementation

uses
  vtForm;

procedure Register;
begin
  RegisterComponents('VisualTax', [TvtMemo]);
end;

{ TvtMemo }

procedure TvtMemo.KeyUp(var Key: Word; Shift: TShiftState);
var
  MyBox: TvtForm;
begin
  (* save new memo text after (repeated) keys pressed,
    not (only) when exiting the memo
    (otherwise implement vtMemo.DoExit
  *)
  ValidateLinesChar;
  //SendMemoToSave;
  MyBox := GetVtForm(self);
  if assigned(mybox) then
  begin
    MyBox.SendMemoToSave(self); //MyBox knows about FormName/No
    Modified := False;
  end;
  inherited;
end;

procedure TvtMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('A')) and (ssCtrl in Shift) then
  begin
    SelectAll;
    Key := 0;
  end;
  inherited;
end;

procedure TvtMemo.SetMaxLines(const Value: Integer);
begin
  FMaxLines := Value;
end;

procedure TvtMemo.ValidateLinesChar;
var
  i: integer;
begin
  if FMaxLines = 0 then
    exit; //no limit
  for i := Lines.Count - 1 downto FMaxLines do
    self.Lines.Delete(i);
end;

end.
