unit T2_2027ABList;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls;
//20170411 Igor All Module and dfm
type
  TABListT2_2027 = class(TForm)
    Panel2: TPanel;
    ShowBox: TRadioGroup;
    Label2: TLabel;
    OpenBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FindBox: TEdit;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FindBoxChange(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CancelBtnClick(Sender: TObject);
    procedure SingleMouseClick(Sender: TObject);
    procedure DoubleMouseClick(Sender: TObject);
    Function IsFormSelected(FName:String):Boolean;
    procedure OpenIt(FName:String);
    procedure UpdateSelectedForms(FName:string);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure FindBoxKeyPress(Sender: TObject; var Key: Char);
    procedure ShowBoxClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FindBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FRetNo: integer;
    procedure SelectedFormsChange(Sender: TObject);
    Function ExtractFormName(const AIndex: Integer):String;
    Procedure LoadTheForms;
  public
    FormName: string;
    FormNo: integer;
    FSelectedForms: TStringList;
  end;


implementation

{$R *.DFM}

uses
  vtTrimStr, vtCommon, T2_2027Declare, T2_2027Common;

procedure TABListT2_2027.FormCreate(Sender: TObject);
begin
  FSelectedForms := TStringList.Create;
  FSelectedForms.Sorted := True;
  FSelectedForms.OnChange := SelectedFormsChange;
  ShowBox.ItemIndex := 0;
  LoadTheForms;
end;

procedure TABListT2_2027.FormDestroy(Sender: TObject);
begin
  FSelectedForms.Free;
end;

Function TABListT2_2027.IsFormSelected(FName: String): Boolean;
Var
  I: integer;
begin
  If FName = '' then
    exit(False);
  Result := FSelectedForms.IndexOf(FName) >= 0;
end;

procedure TABListT2_2027.UpdateSelectedForms(FName: string);
Var
  i: Integer;
Begin
  I := FSelectedForms.IndexOf(FName);
  if I >= 0 then
    FSelectedForms.Delete(I)
  else
    FSelectedForms.Add(FName);
end;


procedure TABListT2_2027.SingleMouseClick(Sender: TObject);
Var
  FName :string; //[10];
begin
  FName := ExtractFormName(ListBox1.ItemIndex);
  UpdateSelectedForms(FName);
end;

procedure TABListT2_2027.DoubleMouseClick(Sender: TObject);
Var
  FName: string; //[10];
begin
  FName := ExtractFormName(ListBox1.ItemIndex);
  Close;
  OpenIt(FName);
end;

Function TABListT2_2027.ExtractFormName(const AIndex: Integer): String;
begin
  if (AIndex >= 0) AND (AIndex < ListBox1.Items.Count) then
    Result := UpperCase(MidStr(ListBox1.Items[AIndex], 37, 10))
  else
    Result := '';
end;

procedure TABListT2_2027.OpenIt(FName:String);
Var
  FNo: Integer;
begin
  FNo := GetFormNo(FName);
  If FNo = 0 then
    FNo :=GetFormNo(FName+'#1');
  if FNo > 0 then
    OpenForm(GetCurrentRetNo, FNo, 0)
  else
    raise Exception.Create('Form "' + FName + '" not found!');
end;

procedure TABListT2_2027.FindBoxChange(Sender: TObject);
Var
  WhichItem: string; //[20];
  I: integer;
begin
  WhichItem := UpperCase(FindBox.Text);
  For i := 0 to ListBox1.Items.Count-1 do
  begin
    If WhichItem = UpperCase(LeftStr(ListBox1.Items[i],Length(WhichItem))) then
    begin
      ListBox1.ItemIndex := i;
      ListBox1.Refresh;
      exit;
    end;
  end;
end;

procedure TABListT2_2027.OpenBtnClick(Sender: TObject);
Var
  FName: String;
  I: integer;
begin
  Close;
  For i := 0 to FSelectedForms.Count-1 do
  begin
    FName := FSelectedForms[i];
    OpenIt(FName);
  end;
end;

procedure TABListT2_2027.ListBox1DblClick(Sender: TObject);
begin
  DoubleMouseClick(Sender);
end;

procedure TABListT2_2027.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  if Index >= 0 then
    if IsFormSelected(ExtractFormName(Index)) then
    begin
      if odSelected in State then
      begin
        ListBox1.Canvas.Brush.Color := clHighlight;
        ListBox1.Canvas.Font.Color := clWhite;
      end
      else
      begin
        ListBox1.Canvas.Brush.Color := clWhite;
        ListBox1.Canvas.Font.Color := clGreen;
      end;
      ListBox1.Canvas.FillRect(Rect);
      if odFocused in State then
        ListBox1.Canvas.DrawFocusRect(Rect);
      ListBox1.Canvas.Font.Style := [fsBold];
      ListBox1.Canvas.TextOut(Rect.Left, Rect.Top, ListBox1.Items[Index]);
    end
    else
    begin
      if odSelected in State then
      begin
        ListBox1.Canvas.Brush.Color := clHighlight;
        ListBox1.Canvas.Font.Color := clWhite;
      end
      else
      begin
        ListBox1.Canvas.Brush.Color := clWhite;
        ListBox1.Canvas.Font.Color := clDefault;
      end;
      ListBox1.Canvas.FillRect(Rect);
      if odFocused in State then
        ListBox1.Canvas.DrawFocusRect(Rect);
      ListBox1.Canvas.Font.Style := [];
      ListBox1.Canvas.TextOut(Rect.Left, Rect.Top, ListBox1.Items[Index]);
    end;
end;

procedure TABListT2_2027.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SingleMouseClick(Sender);
end;

procedure TABListT2_2027.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TABListT2_2027.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then
    DoubleMouseClick(Sender)
  else
  If Key = #32 then
    SingleMouseClick(Sender);
end;

procedure TABListT2_2027.FindBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) or (Key = VK_Up) then
  Begin
    ActiveControl := ListBox1;
    SendMessage(ListBox1.Handle, WM_SYSKEYDOWN, KEY, 0);
  End;
end;

procedure TABListT2_2027.FindBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then
    DoubleMouseClick(Sender);
end;

Procedure TABListT2_2027.LoadTheForms;
Var
  i: Integer;
  TempList: TStringList;
Begin
  FSelectedForms.BeginUpdate;
  try
    FSelectedForms.Clear;
  finally
    FSelectedForms.EndUpdate;
  end;
  ListBox1.Items.BeginUpdate;
  try
    TempList := TStringList.Create;
    try
      Case ShowBox.ItemIndex of
        0:  //all
          Begin
            TempList.LoadFromFile(AppDir + '\Alphandx.d');
            ListBox1.Items.Clear;
            For i := 0 to templist.count-1 do
            begin
              //If ((UpperCase(LeftStr(TempList[i],3))<>'ON-')  //20110424
              If (UpperCase(LeftStr(TempList[i], 3)) <> 'AB-') and
                 (UpperCase(LeftStr(TempList[i], 3)) <> '$AL') then
                ListBox1.Items.Add(TempList[i]);
            end;
            ListBox1.ItemIndex :=0;
          end;
        1:  //Ontario
          Begin
            TempList.LoadFromFile(AppDir + '\Alphandx.d');
            ListBox1.Items.Clear;
            For i := 0 to templist.count - 1 do
            begin
              If UpperCase(LeftStr(TempList[i], 3)) = 'ON-' then
                ListBox1.Items.Add(TempList[i]);
            end;
            ListBox1.ItemIndex :=0;
          end;
        2:  //Alberta
          Begin
            TempList.LoadFromFile(AppDir + '\Alphandx.d');
            ListBox1.Items.Clear;
            For i := 0 to templist.count-1 do
            begin
              If UpperCase(LeftStr(TempList[i], 3)) = 'AB-' then
                ListBox1.Items.Add(TempList[i]);
            end;
            ListBox1.ItemIndex :=0;
          end;
      Else
      end; //case
    finally
      TempList.Free;
    end;
  finally
    ListBox1.Items.EndUpdate;
  end;
  ActiveControl := ListBox1;
End;

procedure TABListT2_2027.SelectedFormsChange(Sender: TObject);
begin
  OpenBtn.Enabled := (Sender as TStringList).Count > 0;
  ListBox1.Repaint;
end;

procedure TABListT2_2027.ShowBoxClick(Sender: TObject);
begin
  LoadTheForms;
end;

end.
