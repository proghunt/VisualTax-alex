unit vtRichmemobox;

// copied  and modified from vtMemoBox on Feb 3, 2011
interface

uses
  WinAPI.Windows, WinAPI.Messages, System.SysUtils, System.Classes,
  VCL.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls,

  RxRichEd; //20160819 Igor (It must be the last)

type
  TvtRichMemo = class(TRichEdit)
  private
    { Private declarations }
    FMaxLines: Integer;
    procedure SetMaxLines(const Value: Integer);
    procedure SendRichMemoToSave;
    procedure ValidateLinesChar;
  protected
    { Protected declarations }
      //procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
    procedure LoadFromFile(AFileName: TFileName); //20170410 Igor
  published
    { Published declarations }
    property vtMaxLines: Integer read FMaxLines write SetMaxLines default 0;
  end;

procedure Register;

implementation

uses //childwinnew;
  vtForm;

procedure TvtRichMemo.SendRichMemoToSave;
var
  MyBox: TvtForm;
begin
  (* save new memo text after (repeated) keys pressed,
    not (only) when exiting the memo
    (otherwise implement vtMemo.DoExit
  *)
   //ChildWinNew.OnExitRichMemo(self);
    //ValidateLinesChar;
   //SendMemoToSave;
  MyBox := GetVtForm(self);
  if assigned(mybox) then
  begin
    MyBox.SendMemoToSave(self); //MyBox knows about FormName/No
    Modified := False;
  end;
  inherited;
end;

procedure TvtRichMemo.ValidateLinesChar;
var
  i, memoLineCount: integer;
begin
  if (self.Lines.Count > FMaxLines) and (FMaxLines > 0) then
  begin
    memoLineCount := self.Lines.Count;
    for i := memoLineCount downto FMaxLines do
      self.Lines.Delete(i);
  end

end;

procedure TvtRichMemo.SetMaxLines(const Value: Integer);
begin

  if FMaxLines <> Value then
  begin
    FMaxLines := Value;
    RecreateWnd;
  end;

end;

procedure TvtRichMemo.DoExit;
begin
  ValidateLinesChar;
  SendRichMemoToSave;
  //self.color := clwhite;
  inherited;
end; (*DoExit*)

procedure TvtRichMemo.KeyUp(var Key: Word; Shift: TShiftState);
begin
  ValidateLinesChar;
  SendRichMemoToSave;
  inherited;
end;

procedure TvtRichMemo.LoadFromFile(AFileName: TFileName); //20170410 Igor
begin
  Lines.LoadFromFile(AFileName);
  Application.ProcessMessages;
end;

procedure TvtRichMemo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('A')) and (ssCtrl in Shift) then
  begin
    SelectAll;
    Key := 0;
  end;
  inherited;
end;

procedure Register;
begin
  RegisterComponents('VisualTax', [TvtRichMemo]);
end;

end.
