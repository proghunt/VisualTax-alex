unit vtGroupBox;

interface

uses
  System.Classes, System.Types, Vcl.Controls, Vcl.StdCtrls, vcl.Graphics,
  Winapi.Windows, Winapi.Messages, vcl.Forms, vtControlIntf, vtConditionValues; //20170127 Igor
type
  //Border type
  TvtBoxBorder = (vtbbNone, vtbbSingle, vtbbThick, vtbbDouble);
  TvtCustomGroupBox = class(TCustomControl, IvtControl, IvtConditionalControl) //20170127 Igor
  private
    FvtBoxBorder: TvtBoxBorder;
    FvtBorderColor: TColor;
    FvtMoveOuterComponent: Boolean;
    FvtIsPrintable: Boolean;
    FvtDisplayed: Boolean;

    //20170321 Igor >>>
    FvtTransparent: Boolean;
    FConditionalPrintable: TConditionalBoolean;
    FConditionalDisplayed: TConditionalBoolean;
    FConditionalVisible: TConditionalBoolean;
    FLockUpdate: Integer;
    //20170321 Igor <<<

    procedure SetvtBoxBorder(Value: TvtBoxBorder);
    function GetvtBoxBorder: TvtBoxBorder;
    procedure SetvtBorderColor(Value: TColor);
    function GetvtBorderColor: TColor;
    procedure SetVisible(Value: Boolean);
    function GetVisible: Boolean;
    procedure SetHeight(Value: Integer);
    function GetHeight: Integer;

    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure MoveControls(DX: Integer);

    {  (Visible -> InVisible) + (vtMoveOuterComponent = true)
        all components which Top >= (vtGroupBox.top+vtGroupBox.height) will be upp to vtGroupBox.height

      (InVisible -> Visible) + (vtMoveOuterComponent = true)
        all components which Top >= (vtGroupBox.top) will be down to vtGroupBox.height
    }
    function GetvtIsPrintable: Boolean; //20170127 Igor
    //20170321 Igor >>>
    procedure SetvtTransparent(const Value: Boolean);
    procedure InvalidateConditionalValues(ASender: TObject);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure SetvtDisplayed(const Value: Boolean);
    procedure SetvtIsPrintable(const Value: Boolean);
    //20170321 Igor <<<
  protected
    procedure Paint; override;
    procedure AdjustClientRect(var Rect: TRect); override; //20160415 Igor
    procedure Loaded; override; //20170321 Igor
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override; //20170321 Igor
    //border type
    property vtBoxBorder: TvtBoxBorder read GetvtBoxBorder write SetvtBoxBorder default vtbbSingle;
    //border color
    property vtBorderColor: TColor read GetvtBorderColor Write SetvtBorderColor default clBlack; //20170321 Igor
    //if we change visible then MoveControls procedure will be called
    property Visible: Boolean read GetVisible write SetVisible default true;
    property vtConditionalVisible: TConditionalBoolean read FConditionalVisible write FConditionalVisible; //20170321 Igor
    //On and Off moving conponents below this control
    property vtMoveOuterComponent: Boolean read FvtMoveOuterComponent write FvtMoveOuterComponent default true;
    property Height: Integer read GetHeight write SetHeight;
    //On and Off component visible during the print
    property vtIsPrintable: Boolean read GetvtIsPrintable write SetvtIsPrintable default True; //20170321 Igor
    property vtConditionalPrintable: TConditionalBoolean read FConditionalPrintable write FConditionalPrintable; //20170321 Igor
    //On and Off component visible on the Form in Runtime
    property vtDisplayed: Boolean read FvtDisplayed write SetvtDisplayed default True; //20170321 Igoe
    property vtConditionalDisplayed: TConditionalBoolean read FConditionalDisplayed write FConditionalDisplayed; //20170321 Igor
    // Transparent
    property vtTransparent: Boolean read FvtTransparent write SetvtTransparent default True;
    // Draw component
    procedure Draw(ACanvas: TCanvas; R: TRect; AScaleX: TScaledFunct = nil;
      AScaleY: TScaledFunct = nil; AScMult: Integer = 1); //20170212 Igor
    //vtGroupBox and all his children are printed and are displayed if it and it parents has vtIsPrintable/vtDisplayed = true
  published
  end;


  TvtGroupBox = class(TvtCustomGroupBox)
  private
  protected
  public
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Padding;
    property ParentBackground default True;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property Visible;
    property vtConditionalVisible; //20170321 Igor
    property StyleElements;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDockDrop;
    property OnDockOver;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnGetSiteInfo;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
    property vtBoxBorder;
    property vtBorderColor;
    property vtMoveOuterComponent;
    property vtIsPrintable;
    property vtConditionalPrintable;//20170321 Igor
    property vtDisplayed;
    property vtConditionalDisplayed;//20170321 Igor
    property vtTransparent; //20170321 Igor
  end;

  procedure Register;
implementation

procedure Register;
begin
  RegisterComponents('VisualTax', [TvtGroupBox]);
end;

{ TvtCustomGroupBox }

procedure TvtCustomGroupBox.AdjustClientRect(var Rect: TRect); //20160415 Igor
begin
  inherited AdjustClientRect(Rect);
  Canvas.Font := Font;
  if Text <> '' then
  Begin
    Inc(Rect.Top, Canvas.TextHeight('0'));
    InflateRect(Rect, -1, -1);
  End;
  if Ctl3d then InflateRect(Rect, -1, -1);
end;

procedure TvtCustomGroupBox.BeginUpdate;
begin
  Inc(FLockUpdate);
end;

procedure TvtCustomGroupBox.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
  Realign;
end;

procedure TvtCustomGroupBox.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      SelectFirst;
      Result := 1;
    end else
      inherited;
end;

procedure TvtCustomGroupBox.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
  Realign;
end;

constructor TvtCustomGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //20170321 Igor >>>
  FLockUpdate := 0;
  FConditionalPrintable := TConditionalBoolean.Create(Self, 'Printable');
  FConditionalPrintable.Value := True;
  FConditionalDisplayed := TConditionalBoolean.Create(Self, 'Displayed');
  FConditionalDisplayed.Value := True;
  FConditionalVisible := TConditionalBoolean.Create(Self, 'Visible');
  FConditionalVisible.Value := True;
  //20170321 Igor <<<
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csDoubleClicks, csReplicatable, csParentBackground, csGestures];
  Width := 185;
  Height := 105;
  FvtBoxBorder := vtbbSingle;
  FvtBorderColor := clBlack; //20170321 Igor
  FvtMoveOuterComponent := True;
//20170321 Igor >>>
  FvtTransparent := True;
//  vtIsPrintable := True; //20160411 Igor
//  vtDisplayed := True;
//20170321 Igor <<<
end;

function TvtCustomGroupBox.GetHeight: Integer;
begin
  Result := Inherited Height;
end;

function TvtCustomGroupBox.GetVisible: Boolean;
begin
  Result := inherited Visible;
end;

function TvtCustomGroupBox.GetvtBorderColor: TColor;
begin
  Result := FvtBorderColor;
end;

function TvtCustomGroupBox.GetvtBoxBorder: TvtBoxBorder;
begin
  Result := FvtBoxBorder;
end;

function TvtCustomGroupBox.GetvtIsPrintable: Boolean; //20170127 Igor
begin
  Result := FvtIsPrintable;
end;

procedure TvtCustomGroupBox.InvalidateConditionalValues(ASender: TObject); //20170321 Igor
begin
  if ASender = nil then
  begin
    BeginUpdate;
    try
      FConditionalPrintable.Invalidate;
      FConditionalDisplayed.Invalidate;
      FConditionalVisible.Invalidate;
    finally
      EndUpdate;
    end;
    Exit;
  end
  else
  if (ASender = FConditionalPrintable) then
    vtIsPrintable := FConditionalPrintable.Value
  else
  if (ASender = FConditionalDisplayed) then
    vtDisplayed := FConditionalDisplayed.Value
  else
  if (ASender = FConditionalVisible) then
    Visible := FConditionalVisible.Value
  else
    Exit;
  if FLockUpdate = 0 then
    Repaint;
end;

procedure TvtCustomGroupBox.Loaded; //20170321 Igor
begin
  inherited;
  if not (csDesigning in Self.ComponentState) then
    Exit;
  if (FConditionalPrintable <> nil) and (FConditionalPrintable.Identificator = '') then
    FConditionalPrintable.SetDefaultIdentificator;
  if (FConditionalDisplayed <> nil) and (FConditionalDisplayed.Identificator = '') then
    FConditionalDisplayed.SetDefaultIdentificator;
  if (FConditionalVisible <> nil) and (FConditionalVisible.Identificator = '') then
    FConditionalVisible.SetDefaultIdentificator;
end;

procedure TvtCustomGroupBox.MoveControls(DX: Integer);
var
  P: TWinControl;
  C: TControl;
  I: Integer;
begin
  if not FvtMoveOuterComponent then exit;
  P := Parent;
  if not assigned(P) then exit;
  LockWindowUpdate(P.Handle);
  try
    for I := 0 to P.ControlCount - 1 do
    Begin
      C := P.Controls[I];
      if C = self then continue;
      if ((DX < 0) AND (C.Top >= Top+Height)) or
         ((DX > 0) AND (C.Top >= Top)) then
        C.Top := C.Top + DX;
    End;
  finally
    LockWindowUpdate(0);
  end;
end;

destructor TvtCustomGroupBox.Destroy; //20170321 Igor
begin
  FConditionalPrintable.Free;
  FConditionalDisplayed.Free;
  FConditionalVisible.Free;
  inherited;
end;

procedure TvtCustomGroupBox.Draw(ACanvas: TCanvas; R: TRect; AScaleX: TScaledFunct = nil;
  AScaleY: TScaledFunct = nil; AScMult: Integer = 1); //20170212 Igor
var
  K, H: Integer;
  Flags: Longint;
  F: TFont; //20160413 Igor
  AbsoluteTop: Integer; //20170321 Igor
  TextR: TRect;
  //20170321 Igor >>>
  function DoScaleX(AValue: Longint): Longint;
  begin
    if Assigned(AScaleX) then
      Result := AScaleX(AValue)
    else
      Result := AValue;
  end;
  function DoScaleY(AValue: Longint): Longint;
  begin
    if Assigned(AScaleY) then
      Result := AScaleY(AValue)
    else
      Result := AValue;
  end;
  procedure DrawBorderLine;
  begin
    with ACanvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := FvtBorderColor;
      if Text = '' then
      begin
        MoveTo(R.Left, R.Top);
        LineTo(R.Left, R.Bottom - 1);
        LineTo(R.Right - 1, R.Bottom - 1);
        LineTo(R.Right - 1, R.Top);
        LineTo(R.Left, R.Top);
      end
      else
      begin
        MoveTo(TextR.Left - 1, R.Top);
        LineTo(R.Left, R.Top);
        LineTo(R.Left, R.Bottom - 1);
        LineTo(R.Right - 1, R.Bottom - 1);
        LineTo(R.Right - 1, R.Top);
        LineTo(TextR.Right + 1, R.Top);
      end;
    end;
  end;
  //20170321 Igor <<<

begin
  with ACanvas do
  begin
    F := TFont.Create; //20160413 Igor
    try
      F.Assign(Font); //20160413 Igor
      Font.Assign(Self.Font); //20160413 Igor

      //20170321 Igor >>>
      R.Left := DoScaleX(R.Left);
      R.Right := DoScaleX(R.Right);
      R.Top := DoScaleY(R.Top);
      R.Bottom := DoScaleY(R.Bottom);
      AbsoluteTop := R.Top;

      if not FvtTransparent then
      begin
        Brush.Color := Color;
        Brush.Style := bsSolid;
        FillRect(R);
      end;

      if Text <> '' then
      Begin
        H := TextHeight('0');
        R.Top := R.Top + (H div 2) + 1;
      End
      else
      Begin
        H := 0;
      End;

      //20170321 Igor <<<
      if csDesigning in ComponentState then
      Begin
        if not Visible then
        Begin
          Brush.Style := bsDiagCross;
          Brush.Color := $00EEEEEE;
          SetBkColor(Handle, ColorToRGB(Color));
          FillRect(R);
        End;
      End
      //20170207 Igor >>>
      else
      begin
        //20170321 Igor >>>
        if FvtTransparent then
          Brush.Style := bsClear
        else
        begin
          Brush.Style := bsSolid;
          SetBkColor(Handle, ColorToRGB(Color));
          FillRect(R);
        end;
        //20170321 Igor <<<
      end;
      //20170207 Igor <<<

      //20160411 Igor >>>
      if Text <> '' then
      begin
        //20170321 Igor >>>
        if Self.Canvas = ACanvas then
        begin
          if not UseRightToLeftAlignment then
            TextR := Rect(DoScaleX(8), 0, width, H)
          else
            TextR := Rect(R.Right - Self.Canvas.TextWidth(Text) - DoScaleX(8), 0, 0, H);
        end
        else
        begin
          if not UseRightToLeftAlignment then
            TextR := Rect(R.Left + DoScaleX(8), AbsoluteTop, 0, AbsoluteTop + H)
          else
            TextR := Rect(R.Right - TextWidth(Text) - DoScaleX(8), AbsoluteTop, 0, AbsoluteTop + H);
        end;
        //20170321 Igor <<<

        Flags := DrawTextBiDiModeFlags(DT_SINGLELINE);
        DrawText(Handle, Text, Length(Text), TextR, Flags or DT_CALCRECT); //20170321 Igor
        if not FvtTransparent then
        begin
          Brush.Color := Color;
          Brush.Style := bsSolid;
        end
        else
        begin
          Brush.Style := bsClear;
        end;
        DrawText(Handle, Text, Length(Text), TextR, Flags); //20170321 Igor
        Font.Assign(F);
      end;

      case FvtBoxBorder of
        vtbbNone:
          Begin
          end;
        vtbbSingle:
          Begin
            DrawBorderLine;
          end;
        vtbbThick:
          Begin
            DrawBorderLine;
            K := R.Left + DoScaleX(1);//20170321 Igor
            while R.Left < K do
            Begin
              InflateRect(R, -1, -1);
              DrawBorderLine;
            End;
          end;
        vtbbDouble:
          Begin
            DrawBorderLine;
            InflateRect(R, DoScaleX(2), DoScaleY(2));
            DrawBorderLine;
          end;
      end;

      //20160411 Igor<<<
    finally
      F.Free; //20160413 Igor
    end;
  end;
End;

procedure TvtCustomGroupBox.EndUpdate;
begin
  Dec(FLockUpdate);
  if FLockUpdate = 0 then
    Repaint;
end;

procedure TvtCustomGroupBox.Paint;
var
  R: TRect;
begin
  R := Rect(0, 0, Width, Height);
  Draw(Canvas, R);
end;

procedure TvtCustomGroupBox.SetHeight(Value: Integer);
var
  DX: Integer;
begin
  if (inherited Height) <> Value then
  Begin
    DX := Value - (inherited Height);
    inherited Height := Value;
    Repaint;
    MoveControls(DX)
  End;
end;

procedure TvtCustomGroupBox.SetVisible(Value: Boolean);
begin
  if (inherited Visible) <> Value then
  Begin
    inherited Visible := Value;
    Repaint;
    if Value then
      MoveControls(Height)
    else
      MoveControls(-Height);
    FConditionalVisible.Value := Value; //20170321 Igor
  End;
end;

procedure TvtCustomGroupBox.SetvtBorderColor(Value: TColor);
begin
  if Value <> FvtBorderColor then
  Begin
    FvtBorderColor := Value;
    RePaint;
  End;
end;

procedure TvtCustomGroupBox.SetvtBoxBorder(Value: TvtBoxBorder);
begin
  if Value <> FvtBoxBorder then
  Begin
    FvtBoxBorder := Value;
    RePaint;
  End;
end;

procedure TvtCustomGroupBox.SetvtDisplayed(const Value: Boolean);
begin
  if FvtDisplayed <> Value then
  begin
    FvtDisplayed := Value;
    FConditionalDisplayed.Value := Value;
  end;
end;

procedure TvtCustomGroupBox.SetvtIsPrintable(const Value: Boolean);
begin
  if FvtIsPrintable <> Value then
  begin
    FvtIsPrintable := Value;
    FConditionalPrintable.Value := Value;
  end;
end;

procedure TvtCustomGroupBox.SetvtTransparent(const Value: Boolean);
begin
  if FvtTransparent <> Value then
  begin
    FvtTransparent := Value;
    Repaint;
  end;
end;

procedure TvtCustomGroupBox.WMSize(var Message: TWMSize);
begin
  inherited;
  Invalidate;
end;

end.
