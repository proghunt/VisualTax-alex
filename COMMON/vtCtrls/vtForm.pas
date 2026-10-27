unit vtForm;
(* Base class for VT forms, to be extended into vtScrollBox.
  TvtForm contains all properties and methods used by the VT controls.
*)

{$DEFINE Wheel } //using private MouseWheel handler?

interface

uses
  WinAPI.Windows, VCL.Graphics, VCL.Controls, VCL.StdCtrls, VCL.Forms,
  WinAPI.Messages, System.Classes,
  vtEditBox, vtMemoBox;

type
  TvtDestination = (vtdDisplay,vtdPrint);
  TvtForm = class(TScrollBox)
  private
    { Private declarations }
    FCaption: string;
    FOldCtreateOrder: Boolean;
    FPixelsPerInch: Integer;
    FTextHeight: Integer;
    FFormNo: integer;
    FRetNo: integer;
    FReadOnly: boolean;
    FFormName: string;
//    FClientWidth: Integer; //20170303 Igor
//    FClientHeight: Integer;  //20170303 Igor

    FLYFormName: string; //20160316 Igor
    FLYFormNo: integer; //20160316 Igor
    FLYRetNo: integer; //20160316 Igor
    //20170511 Igor >>>
    FActiveControl: String;
    function GetActiveControl: String;
    procedure SetActiveControl(const Value: String);
    //20170511 Igor <<<
    procedure SetVtCaption(const Value: string);
    procedure SetVtPixelsPerInch(const Value: Integer);
    procedure SetVtTextHeight(const Value: Integer);
    procedure SetFormNo(const Value: integer);
    procedure SetReadOnly(const Value: boolean);
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure WMPaint(var Message: TMessage); message WM_PAINT; //20170504 Igor
  protected
    LastPos: TPoint; //after last explicit scroll
//{$IFDEF popup}
//{$ELSE}
//    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
//{$ENDIF}
    procedure SetRetNo(const Value: integer); virtual;
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean); Virtual; //20160312 Igor
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override; //20170504 Igor
  public
    pgBreaks: TStringList;
    procedure Init; virtual;
    constructor Create(AOwner: TComponent); override; //20170511 Igor
    destructor Destroy; override;
    function GetMaxPg: integer;
    procedure AfterOpenForm(ADestination: TvtDestination = vtdDisplay); virtual;
    procedure ScrollToPage(pgNo: integer);
    procedure FocusOnElm(Elm: integer);

    procedure OnExitField(MyEditBox: TvtEdit); virtual;
    procedure OnEnterField(MyEditBox: TvtEdit); virtual;
    procedure SendMemoToSave(MyMemoBox: TCustomMemo); virtual; //abstract;
    procedure OnVtEditDblClick(MyEditBox: TvtEdit); virtual;
    procedure EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
    procedure ScrollSiblings(OrgBox: TvtForm); virtual;
  public //added VT tax form properties
    property FormName: string read FFormName write FFormName; //component.Name cannot include '#'
    property FormNo: integer read FFormNo write SetFormNo;
    property RetNo: integer read FRetNo write SetRetNo;
    property vtScrollBoxId: string read FFormName;
    //property vtScrollBoxId    : String  read FScrollBoxId      write SetScrollBoxId;
    property ReadOnly: boolean read FReadOnly write SetReadOnly;
    property ActiveControl: String read GetActiveControl write SetActiveControl; //20170511 Igor
  public //lastYear links
    property LYFormName: string read FLYFormName write FLYFormName; //20160316 Igor
    property LYFormNo: integer read FLYFormNo write FLYFormNo;      //20160316 Igor
    property LYRetNo: integer read FLYRetNo write FLYRetNo;         //20160316 Igor
    class procedure SafeSetFocus(AControl: TControl);//20170803 Igor
  published
    { Published declarations, required to load Form DFM }
    property Caption: string read FCaption write SetVtCaption;
    property OldCreateOrder: Boolean read FOldCtreateOrder write FOldCtreateOrder;
    property PixelsPerInch: Integer read FPixelsPerInch write SetVtPixelsPerInch;
    property TextHeight: Integer read FTextHeight write SetVtTextHeight;
    // 20150815 igor
    property ClientHeight; //: Integer read FClientHeight write FClientHeight;  //20170303 Igor
    property ClientWidth; //: Integer read FClientWidth write FClientWidth;     //20170303 Igor

  end;
  //TvtScrollBox = TvtForm;

function GetVtForm(AChild: TControl): TvtForm;
function ExtractFieldId(AChild: TControl): string;

implementation

uses
  System.SysUtils, VCL.Dialogs, //Beep...
  vtShape, VCL.ExtCtrls, ComCtrls;//20170803 Igor

function GetVtForm(AChild: TControl): TvtForm;
var
  cmp: TWinControl;
begin
  (* get the scrollbox (vtForm) for AChild
  *)
  if AChild is TWinControl then
    cmp := TWinControl(AChild) //.Parent;
  else
    cmp := AChild.Parent;
  while assigned(cmp) and not (cmp is TvtForm) do
    cmp := cmp.Parent;
  Result := TvtForm(cmp);
end;

function ExtractFieldId(AChild: TControl): string;
var
  i: integer;
  n: string;
const
  Digits = ['0'..'9'];
begin
  n := AChild.Name;
  for i := Length(n) downto 1 do
  begin
    if not (CharInSet(n[i], Digits)) then //20150701
    begin
      Result := Copy(n, i + 1, 255);
      exit;
    end;
  end;

  Result := n; // '';
end;

{ TvtForm }

procedure TvtForm.OnEnterField(MyEditBox: TvtEdit);
begin
  (* Do whatever is required when an EditBox gets the focus.
    (only EditBox???)
    Here: do nothing application related, what requires units outside the package.
    Everything else must be done in a derived class (TvtScrollBox).
  *)
  ShowMessage('override OnEnterField');
end;

procedure TvtForm.OnExitField(MyEditBox: TvtEdit);
begin
  (* Do whatever is required when an EditBox looses the focus.
    (only EditBox???)
    Here: do nothing application related, what requires units outside the package.
    Everything else must be done in a derived class (TvtScrollBox).
  *)
  ShowMessage('override OnExitField');
end;

procedure TvtForm.SendMemoToSave(MyMemoBox: TCustomMemo);
begin
  //must override to handle both ordinary memo and rich text
end;

procedure TvtForm.OnVtEditDblClick(MyEditBox: TvtEdit);
begin
  (* Override to react on double click on a vtEditBox.
    Also: keypress in vtLinked, vtPopUp, vtAddingTape fields
  *)
  ShowMessage('override OnVtEditDblClick');
end;

procedure TvtForm.SetReadOnly(const Value: boolean);
begin
  FReadOnly := Value;
end;

procedure TvtForm.SetVtCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    //RecreateWnd; //why?
  end;
end; (*SetVtCaption*)

procedure TvtForm.SetVtPixelsPerInch(const Value: Integer);
begin
  if FPixelsPerInch <> Value then
  begin
    FPixelsPerInch := Value;
    RecreateWnd;
  end;
end; (*SetVtPixelsPerInch*)

procedure TvtForm.SetVtTextHeight(const Value: Integer);
begin
  if FTextHeight <> Value then
  begin
    FTextHeight := Value;
    RecreateWnd;
  end;
end; (*SetVtTextHeight*)

procedure TvtForm.SetActiveControl(const Value: String); //20170511 Igor
var
  C: TWinControl;
begin
  if (Self.FindChildControl(Value) <> nil) and
     (Self.FindChildControl(Value) is TWinControl) then
  begin
    C := Self.FindChildControl(Value) as TWinControl;
    if C.CanFocus then
      C.SetFocus
    else
    if not Self.CanFocus then
      FActiveControl := Value;
  end;
end;

procedure TvtForm.SetFormNo(const Value: integer);
begin
  if FFormNo <> 0 then
    exit; //error: assign only once!
  FFormNo := Value;
end;

procedure TvtForm.SetRetNo(const Value: integer);
begin
  (* Prevent redefinition of RetNo,
    except when the return tells us that it is being destroyed (Value=-1)
  *)
  if (FRetNo <> 0) and (Value >= 0) then
    exit; //error: assign only once!
  FRetNo := Value;
end;

procedure TvtForm.WMHScroll(var Message: TWMHScroll);
var
  OldPos: integer;
begin
  OldPos := HorzScrollBar.Position;
  inherited;
  if (HorzScrollBar.Position = OldPos) then
    exit; //unchanged
  //update LastPos
  LastPos.x := HorzScrollBar.Position;
  //scroll siblings?
  ScrollSiblings(self);
end;

procedure TvtForm.WMPaint(var Message: TMessage); //20170511 Igor
var
  S: String;
  C: TWinControl;
begin
  inherited;
  if FActiveControl <> '' then
  Begin
    S := FActiveControl;
    FActiveControl := '';
    if (Self.FindChildControl(S) <> nil) and
       (Self.FindChildControl(S) is TWinControl) then
    begin
      C := Self.FindChildControl(S) as TWinControl;
      if C.CanFocus then
      try
        C.SetFocus;
      except
      end;
    end;
  End;
end;

procedure TvtForm.WMVScroll(var Message: TWMVScroll);
var
  OldPos: integer;
begin
  OldPos := VertScrollBar.Position;
  inherited;
  if (VertScrollBar.Position = OldPos) then
    exit;
  //update LastPos
  LastPos.y := VertScrollBar.Position;
  //scroll siblings?
  ScrollSiblings(self);
end;

procedure TvtForm.CMFocusChanged(var Message: TCMFocusChanged);
var
  F: Boolean; //20160320 Igor
begin
  //this message arrives, whenever the focus moves to another control.
  inherited; //does NOT change the scrollbar Position
  //20160320 Igor >>>
  F:= False;
   if Assigned(VertScrollBar) then
     if (LastPos.y <> VertScrollBar.Position) then
     Begin
       F := True;
       LastPos.y := VertScrollBar.Position;
     End;

  if Assigned(HorzScrollBar) then
    if (LastPos.x <> HorzScrollBar.Position) then
     Begin
       F := True;
       LastPos.x := HorzScrollBar.Position;
     End;
  if F then
    ScrollSiblings(self);
  //20160320 Igor <<<
end;

constructor TvtForm.Create(AOwner: TComponent); //20170511 Igor
begin
  inherited;
  FActiveControl := '';
end;

procedure TvtForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  //VertScrollBar.Position := VertScrollBar.Position + WheelDelta * 50;
  with VertScrollBar do
    Position := Position - {50 *} WheelDelta;
  ScrollSiblings(self);
  Handled := True;
end;

class procedure TvtForm.SafeSetFocus(AControl: TControl);//20170803 Igor
var
  C: TWinControl;
begin
  if not AControl.Enabled or
     not AControl.Visible then
    exit;
  try
    C := AControl.Parent;
    while Assigned(C) AND C.Visible AND C.Enabled do
    begin
      if C is TTabSheet then
        if Assigned(TTabSheet(C).PageControl) then
          if TTabSheet(C).PageControl.ActivePage <> TTabSheet(C) then
            TTabSheet(C).PageControl.ActivePage := TTabSheet(C)
          Else
            Exit;
      C := C.Parent;
    end;
    if C.CanFocus then
      C.SetFocus;
  except
    //no error message
  end;
end;

procedure TvtForm.ScrollSiblings(OrgBox: TvtForm);
begin
  //override to call UprototypeRtns.ScrollSiblings
end;

procedure TvtForm.Init;
begin
{$IFDEF Wheel}
  OnMouseWheel := FormMouseWheel;
{$ELSE}
  //catch somewhere else
{$ENDIF}
  //OnMouseDown := EditBoxMouseDown; - FormMouseDown!
end;

procedure TvtForm.Notification(AComponent: TComponent;
  Operation: TOperation); //20170511 Igor
begin
  inherited;
//  if (AComponent = FActiveControl) and (Operation = opRemove) then
//    FActiveControl := nil;
end;

destructor TvtForm.Destroy;
begin
  FreeAndNil(pgBreaks); //to also signal form as (being) destroyed
  inherited;
end;

{$IFDEF old}

procedure TvtForm.OnRadioButtonChange(MyEditBox: TvtEdit);
begin
  //nop?
  ShowMessage('override OnRadioButtonChange');
end;

function TvtForm.GetPredictiveValue(MyEditBox: TvtEdit; const pat: string): string;
begin
  //override to get an predicted string
  Result := '';
end;

procedure TvtForm.OnVtEditRightClick(MyEditBox: TvtEdit);
begin
  //override to handle RightClick (ContextPopup)
  ShowMessage('override OnVtEditRightClick');
end;
{$ELSE}
{$ENDIF}

procedure TvtForm.AfterOpenForm;
var
  s: AnsiString; //20150701
{$IFDEF limitPages}
  i, j, nextPageBreakPos: integer;
  Shape, lastPageBreak, newPageBreak: TvtShape;
{$ELSE}
  i, j: integer;
  Shape: TvtShape;
{$ENDIF}
begin
  (* Init page breaks list from vtPageBreak shapes.
    Sort by Top, assign page# to hint.
    What for page #1 - no shape???
    add pagebreak every 1000 pixels
  *)
  if pgBreaks = nil then
    pgBreaks := TStringList.Create
  else
    pgBreaks.Clear; //for proper zoom handling
  //pgBreaks.AddObject('00',TObject(0));
  for j := 0 to ComponentCount - 1 do
  begin
    if Components[j] is TvtShape then
    begin
      Shape := Components[j] as TvtShape;
      //Shape.Hint set in aferOpen()
      //if Shape.vtPageBreak and (Shape.Hint <> '') then
      if (Shape.vtPageBreak)
        {//and (Shape.vtPageBreakType=vtPageBreakPortrait) //display portrait only} then
      begin
        Str(Shape.Top: 6, s); //20160720 Igor
        pgBreaks.AddObject(string(s), Shape); //20150701
      end;
    end; // if is TvtShape
  end; //end sBox.ComponentCount
  pgBreaks.Sort; //topmost=pg2 at [0]?
  //sorting done, allow for random insert
  pgBreaks.Sorted := False;

{$IFDEF limitPages}
  nextPageBreakPos := 0;
  i := 0;
  //add pagebreaks every 1000 pixels - from T1-2013 AddPageBreaks()
  while i < pgBreaks.Count do
  begin
    inc(nextPageBreakPos, 1000);
    TObject(lastPageBreak) := pgBreaks.Objects[i];
    //allow for pages slightly longer than 1000 pixels (bad predefined breaks)
      //while lastPageBreak.Top > nextPageBreakPos do
      //if lastPageBreak.Top > nextPageBreakPos then
    if lastPageBreak.Top > nextPageBreakPos + 200 then
    begin
      newPageBreak := TvtShape.Create(self);
      Str(nextPageBreakPos: 4, s);
      pgBreaks.InsertObject(i, s, newPageBreak);
      newPageBreak.name := lastPageBreak.name + inttostr(nextPageBreakPos);

      newPageBreak.Shape := vtRectangle;

      newPageBreak.Top := nextPageBreakPos; // lastPageBreakPos + 1000;
      newPageBreak.Left := 7;
      newPageBreak.Height := 2;
      newPageBreak.Width := lastPageBreak.Width; // 1000; //too wide!

      newPageBreak.pen.width := 2;
      newPageBreak.pen.color := clBackground;
      newPageBreak.Brush.Style := lastPageBreak.Brush.Style;
      newPageBreak.Brush.Color := clBlack; //lastPageBreak.Brush.Color;

      newPageBreak.vtisprintable := false;
      newPageBreak.vtPageBreak := true; //lastPageBreak.vtPageBreak;
      newPageBreak.vtPageBreakType := vtPageBreakPortrait;

      newPageBreak.Parent := self; // Box; //lastPageBreak.Parent;
      newPageBreak.Visible := lastPageBreak.Visible;

      newPageBreak.BringToFront; //Sendtoback;

      //newPageBreak.refresh; //?
      //newPageBreak.update;

      //lastPageBreakPos := newPageBreak.Top;
      //nextPageBreakPos := lastPageBreak;
    end
    else
      nextPageBreakPos := lastPageBreak.Top; //inc at next iteration
    inc(i);
  end;
{$ELSE}
  //don't insert artificial pagebreaks
{$ENDIF}

  //assign tags by list index (one-based!), insert dummy afterwards --> i+2
  for i := 0 to pgBreaks.Count - 1 do
  begin
    TObject(Shape) := pgBreaks.Objects[i];
    Shape.Tag := i + 2;
    if Shape.Hint = '' then
      Shape.Hint := IntToStr(i + 2);
    Shape.ShowHint := True;
  end;
  //dummy break at [0]=pg1
  pgBreaks.Insert(0, '000001'); //pg1 at [0] //20160720 Igor

  //20160519 Igor >>>
  for J := 0 to self.ComponentCount - 1 do
  Begin
    if Self.Components[j] is TPanel then
      (Self.Components[j] as TPanel).ParentBackground := False;
  End;
  //20160519 Igor <<<

end;

procedure TvtForm.ScrollToPage(pgNo: integer);
var
  Shape: TvtShape;
begin
  if (pgNo < 2) or (pgNo > pgBreaks.Count) then
    VertScrollBar.Position := 0
  else
  begin
    TObject(Shape) := pgBreaks.Objects[pgNo - 1];
    VertScrollBar.Position := 0; //prepare proper scroll!?
    VertScrollBar.Position := Shape.Top + 5;
  end;
end;

procedure TvtForm.FocusOnElm(Elm: integer);
var
  MyEditBox: TvtEdit;
  s: string;
begin
  if Elm = 0 then
    Elm := 1;
  s := 'vtEdit' + IntToStr(Elm);
  TObject(MyEditBox) := FindComponent(s);
  if MyEditBox <> nil then
  begin
    ScrollInView(MyEditBox);
    MyEditBox.setfocus;
    //DrawBorderOnActiveBox(MyScrollBox,MyEditBox); - NOP
  end;
end;

function TvtForm.GetActiveControl: String; //20170511 igor
//20170612 igor >>>
//var
//  C: TWinControl;
//20170612 igor <<<
begin
  if (FActiveControl <> '') AND (Self.FindChildControl(FActiveControl) <> nil) then
    Result := FActiveControl
  else
  if (GetParentForm(Self) <> nil) and
     (GetParentForm(Self).ActiveControl <> nil) and
     Self.ContainsControl(GetParentForm(Self).ActiveControl) then
    Result := GetParentForm(Self).ActiveControl.Name
  else
    Result := '';
end;

function TvtForm.GetMaxPg: integer;
begin
  (* Sometimes an already destroyed form is referenced,
    by FormActivate while the return is being closed.
  *)
  if pgBreaks = nil then
    Result := 0 //being destroyed!
  else
    Result := pgBreaks.Count - 1; //-1? numbered 1..n
end;

end.
