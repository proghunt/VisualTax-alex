unit fColouredPageTabControl;
//20180122 Igor Whole file update

interface

uses ComCtrls, Types, Classes, Windows, Vcl.Graphics;

//20180104 Igor >>>
type
  TTabControl = class(ComCtrls.TTabControl)
  protected
    procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

type
  TPageControl = class(ComCtrls.TPageControl)
  protected
    procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;
  
implementation

uses vtMulti; //20180111 Igor

//20180104 Igor >>>

function ActiveTabColor: TColor;
begin
  Result :=  MainOptions.ActiveTabColor; //20180111 Igor
end;
{ TTabControl }

constructor TTabControl.Create(AOwner: TComponent);
begin
  inherited;
  OwnerDraw := true;
end;

procedure TTabControl.DrawTab(TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
var FImageMargin, FImageW, FImageH: integer;

  procedure DrawImage;
  var X, Y: integer;
      FImageIndex: integer; //20180105 Igor
  begin
    //20180105 Igor >>>
    FImageIndex := TabIndex;
    if Assigned(OnGetImageIndex) then
      OnGetImageIndex(Self, TabIndex, FImageIndex);
    if FImageIndex < Images.Count then
    //20180105 Igor <<<
    begin
      if TabPosition = tpLeft then
      begin
        X := Rect.Left + FImageMargin;
        Y := Rect.Bottom - FImageH - FImageMargin;
      end
      else if TabPosition = tpRight then
      begin
        X := Rect.Left + FImageMargin;
        Y := Rect.Top + FImageMargin;
      end
      else if TabPosition = tpTop then
      begin
        X := Rect.Left + FImageMargin + 2;
        if Active then
          Y := Rect.Top + FImageMargin
        else
          Y := Rect.Bottom - FImageW - FImageMargin + 2;
      end
      else if TabPosition = tpBottom then
      begin
        X := Rect.Left + FImageMargin + 2;
        if Active then
          Y := Rect.Top + FImageMargin
        else
          Y := Rect.Bottom - FImageW - FImageMargin - 2;
      end;
      Images.Draw(Canvas, X, Y, FImageIndex, true); //20180105 Igor
    end;
  end;

  procedure DrawText;
  var
    FSavedDC, X, Y, Angle, H, W: Integer;
    FCaption: string;
  begin
    FCaption := Tabs[TabIndex];
    H := Canvas.TextHeight(Tabs[TabIndex]);
    W := Canvas.TextWidth(Tabs[TabIndex]);
    if TabPosition = tpLeft then
    begin
      X := Rect.Left + (Rect.Right - Rect.Left) div 2 - H div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 + W div 2 - FImageH + FImageMargin;
      Angle := 900;
    end
    else if TabPosition = tpRight then
    begin
      X := Rect.Left + (Rect.Right - Rect.Left) div 2 + H div 2;
      Y := FImageH - FImageMargin + Rect.Top + (Rect.Bottom - Rect.Top) div 2 - W div 2;
      Angle := -900;
    end
    else if TabPosition = tpTop then
    begin
      X := FImageW - FImageMargin + Rect.Left + (Rect.Right - Rect.Left - FImageW) div 2 - W div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - H div 2;
      Angle := 0;
    end
    else if TabPosition = tpBottom then
    begin
      X := FImageW - FImageMargin + Rect.Left + (Rect.Right - Rect.Left - FImageW) div 2 - W div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - H div 2 - 2;
      Angle := 0;
    end;
    FSavedDC := SaveDC(Canvas.Handle);
    try
      SetBkMode(Canvas.Handle, TRANSPARENT);
      Canvas.Font.Orientation := Angle;
      Canvas.TextOut(X, Y, Tabs[TabIndex]);
    finally
      RestoreDC(Canvas.Handle, FSavedDC);
    end;
  end;

begin
  inherited;
  if Active then
    Canvas.Brush.Color := ActiveTabColor
  else
    Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(Rect);
  FImageMargin := 0;
  FImageW := 0;
  FImageH := 0;
  if Images <> nil then
  begin
    FImageW := Images.Width;
    FImageH := Images.Height;
    if (TabPosition = tpLeft) or (TabPosition = tpRight) then
      FImageMargin := (Rect.Right - Rect.Left - Images.Width) div 2
    else
      FImageMargin := (Rect.Bottom - Rect.Top - Images.Height) div 2;
    DrawImage;
  end;
  DrawText;
  Canvas.Brush.Color := clBtnFace;
end;

{ TPageControl }

constructor TPageControl.Create(AOwner: TComponent);
begin
  inherited;
  OwnerDraw := true;
end;

procedure TPageControl.DrawTab(TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
var FImageMargin, FImageW, FImageH, FPageIndex: integer;

  procedure DrawImage;
  var X, Y: integer;
  begin
    if Pages[FPageIndex].ImageIndex < Images.Count then
    begin
      if TabPosition = tpLeft then
      begin
        X := Rect.Left + FImageMargin;
        Y := Rect.Bottom - Images.Height - FImageMargin;
      end
      else if TabPosition = tpRight then
      begin
        X := Rect.Left + FImageMargin;
        Y := Rect.Top + FImageMargin;
      end
      else if TabPosition = tpTop then
      begin
        X := Rect.Left + FImageMargin + 2;
        if Active then
          Y := Rect.Top + FImageMargin
        else
          Y := Rect.Bottom - FImageW - FImageMargin + 2;
      end
      else if TabPosition = tpBottom then
      begin
        X := Rect.Left + FImageMargin + 2;
        if Active then
          Y := Rect.Top + FImageMargin
        else
          Y := Rect.Bottom - FImageW - FImageMargin - 2;
      end;
      Images.Draw(Canvas, X, Y, Pages[FPageIndex].ImageIndex, true);
    end;
  end;

  procedure DrawText;
  var
    FSavedDC, X, Y, Angle, H, W: Integer;
    FCaption: string;
  begin
    FCaption := Pages[FPageIndex].Caption;
    H := Canvas.TextHeight(FCaption);
    W := Canvas.TextWidth(FCaption);
    if TabPosition = tpLeft then
    begin
      X := Rect.Left + (Rect.Right - Rect.Left) div 2 - H div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 + W div 2 - FImageH + FImageMargin;
      Angle := 900;
    end
    else if TabPosition = tpRight then
    begin
      X := Rect.Left + (Rect.Right - Rect.Left) div 2 + H div 2;
      Y := FImageH - FImageMargin + Rect.Top + (Rect.Bottom - Rect.Top) div 2 - W div 2;
      Angle := -900;
    end
    else if TabPosition = tpTop then
    begin
      X := FImageW - FImageMargin + Rect.Left + (Rect.Right - Rect.Left) div 2 - W div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - H div 2;
      Angle := 0;
    end
    else if TabPosition = tpBottom then
    begin
      X := FImageW - FImageMargin + Rect.Left + (Rect.Right - Rect.Left) div 2 - W div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - H div 2;
      Angle := 0;
    end;
    FSavedDC := SaveDC(Canvas.Handle);
    try
      SetBkMode(Canvas.Handle, TRANSPARENT);
      Canvas.Font.Orientation := Angle;
      Canvas.TextOut(X, Y, FCaption);
    finally
      RestoreDC(Canvas.Handle, FSavedDC);
    end;
  end;

  function PageIndexFromTabIndex(TabIndex: Integer): Integer;
  var
    I, FTabIndex: Integer;
  begin
    FTabIndex := -1;
    Result := TabIndex;
    for i := 0 to PageCount - 1 do
    begin
      if FTabIndex = TabIndex then Break;
      if not Pages[i].TabVisible then
        Inc(Result)
      else
        Inc(FTabIndex);
    end;
  end;

begin
  inherited;
  FPageIndex := PageIndexFromTabIndex(TabIndex);
  //if not Pages[FPageIndex].TabVisible then Exit;
  if Active then
    Canvas.Brush.Color := ActiveTabColor
  else
    Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(Rect);
  FImageMargin := 0;
  FImageW := 0;
  FImageH := 0;
  if Images <> nil then
  begin
    FImageW := Images.Width;
    FImageH := Images.Height;
    if (TabPosition = tpLeft) or (TabPosition = tpRight) then
      FImageMargin := (Rect.Right - Rect.Left - Images.Width) div 2
    else
      FImageMargin := (Rect.Bottom - Rect.Top - Images.Height) div 2;
    DrawImage;
  end;
  DrawText;
  Canvas.Brush.Color := clBtnFace;
end;
//20180104 Igor <<<

end.  