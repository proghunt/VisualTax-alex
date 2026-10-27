unit fPopList;
{displays a list and returns the selected string}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  //uMultiApp, //UDeclare,
  //CommonRtns,
  Buttons, ExtCtrls;

type
  TPopList = class(TForm)
    ListBox1: TListBox;
    BottomPanel: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PrintBtn: TBitBtn;
    lbFiltered: TListBox;
    pnlFilter: TPanel;
    edtFilter: TEdit;
    lblFilter: TLabel;
    btnClearFilter: TSpeedButton;
    //20170312 Igor <<<
    procedure OKBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    //procedure ListBox1KeyPress(Sender: TObject; var Key: Char); //20170312 Igor
    procedure PrintBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbFilteredDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState); //20170312 Igor
    procedure FormKeyPress(Sender: TObject; var Key: Char); //20170312 Igor
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);  //20170312 Igor
    procedure btnClearFilterClick(Sender: TObject); //20170317 Igor
    procedure edtFilterChange(Sender: TObject);  //20170317 Igor
  private
    SelectedString: string;
    FSearchStr: string; //20170312 Igor
    FAllowFilter: Boolean;
    function GetSorted: boolean;
    procedure SetSorted(const Value: boolean);
    procedure Refilter; //20170312 Igor
    function DoSearch(ADown: Boolean = True; ARestart: Boolean = True): Boolean; //20170312 Igor
    function GetAllowFilter(AControl: TControl): Boolean;//20170313 Igor
  public
    SelIdx: integer;
    NearCtrl: TControl;
    function SomeList: TStrings;
    property Selected: string read SelectedString;
    property Sorted: boolean read GetSorted write SetSorted;
  end;

implementation

{$R *.DFM}

uses
  vtMulti, vtTrimStr, vtForm;

procedure TPopList.OKBtnClick(Sender: TObject);
begin
//20170312 Igor >>>
  if lbFiltered.ItemIndex >= 0 then
  begin
    SelIdx := Integer(lbFiltered.Items.Objects[lbFiltered.ItemIndex]);
    SelectedString := AllTrim(lbFiltered.Items[lbFiltered.ItemIndex])
  end
  else
  begin
    SelIdx := -1;
    SelectedString := '';
  end;

//  SelIdx := ListBox1.ItemIndex;
//  if ListBox1.ItemIndex > -1 then
//    SelectedString := AllTrim(ListBox1.Items[ListBox1.ItemIndex])
//  else
//    SelectedString := '';
//20170312 Igor <<<
  ModalResult := mrOK;
end;

procedure TPopList.ListBox1DblClick(Sender: TObject);
{Selected item is a global variable}
begin
  OKBtnClick(Sender);
end;

function TPopList.DoSearch(ADown: Boolean = True; ARestart: Boolean = True): Boolean;
var
  I: Integer;
  function isEnd: Boolean;
  begin
    if ADown then
      Result := I >= lbFiltered.Items.Count
    else
      Result := I < 0;
  end;
  procedure Next;
  begin
    if ADown then
      inc(I)
    else
      Dec(I);
  end;
begin
  if ARestart then
    if ADown then
      I := 0
    else
      I := lbFiltered.Items.Count
  else
    if ADown then
      I := lbFiltered.ItemIndex + 1
    else
      I := lbFiltered.ItemIndex - 1;
  while not isEnd do
  begin
    if Pos(LowerCase(FSearchStr), LowerCase(lbFiltered.Items[I])) = 1 then
    begin
      lbFiltered.ItemIndex := I;
      Exit(True);
    end;
    Next;
  end;
  Result :=False;
end;

procedure TPopList.edtFilterChange(Sender: TObject);  //20170317 Igor
begin
   if ActiveControl <> Sender then
     Exit;
   FSearchStr := edtFilter.Text;
   Refilter;
   DoSearch;
end;

procedure TPopList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);  //20170317 Igor
begin
  if Key = VK_ESCAPE then
  begin
    if ActiveControl = edtFilter then
      btnClearFilterClick(nil)
    else
      CancelBtnClick(nil);
    Key := 0;
  end
  else
  if Key = VK_DOWN then
    if ActiveControl = edtFilter then
    begin
      if lbFiltered.ItemIndex < lbFiltered.Items.Count - 1 then
        lbFiltered.ItemIndex := lbFiltered.ItemIndex + 1;
      Key := 0;
    end
    else
  else
  if Key = VK_UP then
    if ActiveControl = edtFilter then
    begin
      if lbFiltered.ItemIndex > 0 then
        lbFiltered.ItemIndex := lbFiltered.ItemIndex - 1;
      Key := 0;
    end
    else
  else
  if (Key = Ord('F')) AND (Shift = [ssCtrl])  then
    if pnlFilter.Visible then
      ActiveControl := edtFilter;
end;

procedure TPopList.FormKeyPress(Sender: TObject; var Key: Char); //20170312 Igor
begin
  if Key = #13 then
  begin
    Key := #0;
    OKBtnClick(nil);
  end
  else
  //20170313 Igor >>>
  if FAllowFilter AND (ActiveControl = lbFiltered) then
  begin
    //20170317 Igor >>>
    if Key = #$1B then
      exit
    else
    //20170317 Igor<<<
    if Key = #8 then
      if Length(FSearchStr) > 0 then
        System.Delete(FSearchStr, Length(FSearchStr), 1)
      else
    else
     FSearchStr := FSearchStr + Key;
    Key := #0;
    lbFiltered.Items.BeginUpdate;
    try
      Refilter;
      if lbFiltered.Items.Count = 0 then
      begin
        System.Delete(FSearchStr, Length(FSearchStr), 1);
        Refilter;
      end;
      //20170317 Igor>>>
      edtFilter.Text := FSearchStr;
      pnlFilter.Visible := FSearchStr <> '';
      //20170317 Igor<<<
      DoSearch;
    finally
      lbFiltered.Items.EndUpdate;
    end;
    lbFiltered.Repaint;
  end;
  //20170313 Igor <<<
end;

procedure TPopList.FormShow(Sender: TObject);
var
  t, b, I: integer;
  maxWidth: Integer;  //20160305 Igor
  P: TPoint;
begin
  // MainForm.SetHorScrollBarInListBox(ListBox1,600);
  //PopList.Caption := SomeCaption;
  // Width:=GetLongestLengthItem(SomeList)* 6+100;
  //20160305 Igor >>>>>
  maxWidth := 0;
  for I := 0 to ListBox1.Count - 1 do
    if ListBox1.Canvas.TextWidth(ListBox1.Items[I]) > maxWidth then
      maxWidth := ListBox1.Canvas.TextWidth(ListBox1.Items[I]);
  if MaxWidth < Length(Caption) * 7 then
    MaxWidth := Length(Caption) * 7 + 60 //20;
  else
  if MaxWidth > (self.Monitor.Width div 3) then
    MaxWidth := (self.Monitor.Width div 3);
  Width := MaxWidth + 20;
  //20160305 Igor <<<<<<

  Height := BottomPanel.Height * 2 + SomeList.Count * 16 + 30;
  if Height < 200 then
    Height := 200;
  if Height > Screen.Height * 2 div 3 then
    Height := Screen.Height * 2 div 3;
  if Width < 300 then //20170312 Igor
    Width := 300;     //20170312 Igor

  ListBox1.ItemIndex := 0;
  //20170313 Igor >>>
  FAllowFilter := GetAllowFilter(NearCtrl);
  if NearCtrl <> nil then
  begin
    p := NearCtrl.ClientOrigin;
    Top := p.y + NearCtrl.Height;
    Left := p.x;
    //Left := NearCtrl.Left;
    //T := NearCtrl.Top + NearCtrl.Height;
    b := P.Y + Height;
    if b > Screen.Height then
    begin
      P.Y := Screen.Height - Height;
      if P.Y < 0 then
        P.Y := 0;
    end;
    Top := P.Y; // NearCtrl.Top+NearCtrl.Height;
    NearCtrl := nil; //place only once
  end;
  //20160305 Igor >>>>>
  if (Top+Height) > (Self.Monitor.Top + Self.Monitor.WorkareaRect.Height)  then
    Top := (Self.Monitor.Top + Self.Monitor.WorkareaRect.Height) - Height;
  if (Left+Width) > (Self.Monitor.Left + Self.Monitor.WorkareaRect.Width)  then
    Left := (Self.Monitor.Left + Self.Monitor.WorkareaRect.Width) - Width;
  //20160305 Igor <<<<<<
  FSearchStr := '';
  pnlFilter.Visible := False;//20170317 Igor
  Refilter;
  ActiveControl := lbFiltered;
  //20170313 Igor <<<
end;

procedure TPopList.btnClearFilterClick(Sender: TObject);//20170317 Igor
begin
  FSearchStr := '';
  Refilter;
  ActiveControl := lbFiltered;
  pnlFilter.Visible := False;
end;

procedure TPopList.CancelBtnClick(Sender: TObject);
begin
  SelectedString := '';
  ModalResult := mrCancel;
end;

(* //20170312 Igor
procedure TPopList.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ListBox1DblClick(Sender);
end; *)

procedure TPopList.PrintBtnClick(Sender: TObject);
var
  FlNm: string;
begin
  FlNm := ExeDir + '\Temp.txt';
  ListBox1.Items.SaveToFile(FlNm);

  // PrintSomeFile(FlNm);
  SelectedString := '';
  ModalResult := mrAll; // Close;
  ShowMessage('Saved as ' + FlNm);
end;

procedure TPopList.Refilter;  //20170313 Igor
var
  I: Integer;
  function Like(AText: String): boolean;
  begin
    Result := (FSearchStr = '') OR
      (Pos(LowerCase(FSearchStr), LowerCase(AText)) > 0);
  end;
begin
  lbFiltered.Items.BeginUpdate;
  try
    lbFiltered.Items.Clear;
    for I := 0 to ListBox1.Items.Count - 1 do
      if like(ListBox1.Items[I]) then
        lbFiltered.Items.AddObject(ListBox1.Items[I], TObject(I));
  finally
    lbFiltered.Items.EndUpdate;
  end;
  if lbFiltered.Items.Count > 0 then
    lbFiltered.ItemIndex := 0;
end;

function TPopList.SomeList: TStrings;
begin
  Result := ListBox1.Items;
end;

function TPopList.GetAllowFilter(AControl: TControl): Boolean;//20170313 Igor
var
  P: TWinControl;
  FName: String;
begin
  if AControl = nil then
    Exit(False);
  P := AControl.Parent;
  if not Assigned(P) then
    Exit(False);
  if not (P is TvtForm) then
    exit(False);
  FName := ExtractNonInstFormName(TvtForm(P).FormName);
  Result := SameText(FName, 'S125') or SameText(FName, 'S100');
end;

function TPopList.GetSorted: boolean;
begin
  Result := ListBox1.Sorted;
end;

procedure TPopList.lbFilteredDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);  //20170312 Igor
var
  I: Integer;
  S, Prefix: string;
begin
  with (Control as TListBox).Canvas do
  begin
    if (odSelected In State) or (odFocused In State) then  //20170312 Igor
      Brush.Color := clNavy;

    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
    if odFocused In State then begin
      Brush.Color := ListBox1.Color;
      DrawFocusRect(Rect);
    end;
    //20170313 Igor >>>
    if (FSearchStr <> '') then
    begin
      I := Pos(LowerCase(FSearchStr), LowerCase(lbFiltered.Items[Index]));
      if I > 0 then
      begin
        Font.Color := clRed;
        S := Copy(lbFiltered.Items[Index], I, Length(FSearchStr));
        Prefix := Copy(lbFiltered.Items[Index], 1, I - 1);
        TextOut(Rect.Left + TextWidth(Prefix), Rect.Top, S);
      end;
    end;
    //20170313 Igor <<<
  end;
end;

procedure TPopList.SetSorted(const Value: boolean);
begin
  ListBox1.Sorted := Value;
  lbFiltered.Sorted := Value;
end;

end.

