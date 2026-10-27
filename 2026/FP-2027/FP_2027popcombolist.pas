unit FP_2027popcombolist;
{Uses a pre-populated SomeString and SomeCaption, displays it
on a list and returns the selected string}

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FP_2027Declare,Buttons;

type
  TPopComboListFP_2012 = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    //procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure SetComboDropDownWidth(ComboBox: TComboBox; Width: Integer = -1);
    procedure ComboBox1Enter(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    //procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PopComboList: TPopComboListFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027common,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TPopComboListFP_2012.OKBtnClick(Sender: TObject);
Var
i :integer;
begin
 SelectedString:=Combobox1.text;
{
If ListBox1.ItemIndex >-1 then SelectedString := AllTrim(SomeList[ListBox1.ItemIndex])
Else SelectedString :='';
}
//ShowMessage(SelectedString);
Close;
end;

procedure TPopComboListFP_2012.ListBox1DblClick(Sender: TObject);
{Selected item is a global variable}
begin
OKBtnClick(Sender);
end;

procedure TPopComboListFP_2012.FormCreate(Sender: TObject);
var
i : integer;
begin
 //ListBox1.Top := Self.Top + 30;
 Caption := SomeCaption;
 For i:= 0 to SomeList.Count -1 do
 begin
   //ListBox1.Items.Add(SomeList[i]);
   ComboBox1.Items.Add(SomeList[i]);
 end;
 //ListBox1.ItemIndex := 0;
 SetComboDropDownWidth(ComboBox1, -1);
 ComboBox1.ItemIndex:=0;
 //ComboBox1.Text:='';
 end;

procedure TPopComboListFP_2012.CancelBtnClick(Sender: TObject);
begin
SelectedString := '';
Close;
end;

(*
procedure TPopComboList.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
 //if Key = #13 then ListBox1DblClick(Sender);
end;
*)

procedure TPopComboListFP_2012.SetComboDropDownWidth(ComboBox: TComboBox; Width: Integer = -1);
var
  I, TextLen: Longint;
  lf: LOGFONT;
  f: HFONT;
begin
  if Width < ComboBox.Width then begin
    FillChar(lf,SizeOf(lf),0);
    StrPCopy(lf.lfFaceName, ComboBox.Font.Name);
    lf.lfHeight := ComboBox.Font.Height;
    lf.lfWeight := FW_NORMAL;
    if fsBold in ComboBox.Font.Style then
      lf.lfWeight := lf.lfWeight or FW_BOLD;

    f := CreateFontIndirect(lf);
    if (f <> 0) then
    begin
      try
        ComboBox.Canvas.Handle := GetDC(ComboBox.Handle);
        SelectObject(ComboBox.Canvas.Handle,f);
        try
          for I := 0 to ComboBox.Items.Count -1 do begin
            TextLen := ComboBox.Canvas.TextWidth(ComboBox.Items[I]);
            if TextLen > Width then
              Width := TextLen;
          end;
          (* Standard ComboBox drawing is Rect.Left + 2,
          adding the extra spacing offsets this *)
          Inc(Width, GetSystemMetrics(SM_CYVTHUMB) +
            GetSystemMetrics(SM_CXVSCROLL));
        finally
          ReleaseDC(ComboBox.Handle, ComboBox.Canvas.Handle);
        end;
      finally
        DeleteObject(f);
      end;
    end;
  end;
  SendMessage(ComboBox.Handle, CB_SETDROPPEDWIDTH, Width, 0);
end;

procedure TPopComboListFP_2012.ComboBox1Enter(Sender: TObject);
begin
 SendMessage(ComboBox1.handle, CB_SHOWDROPDOWN, Integer(True), 0);
end;

(*
procedure TPopComboList.ComboBox1KeyPress(Sender: TObject; var Key: Char);
var
   Found: boolean;
   j,SelSt: Integer;
   TmpStr: string;
begin
EXIT;
   { first, process the keystroke to obtain the current string }
   { This code requires all items in list to be uppercase}
   if Key in ['a'..'z'] then Dec(Key,32) ; {Force Uppercase only!}
   with (Sender as TComboBox) do
   begin
     SelSt := SelStart;
     if (Key = Chr(vk_Back)) and (SelLength <> 0) then
      TmpStr := Copy(Text,1,SelStart)+Copy(Text,SelLength+SelStart+1,255)

     else if Key = Chr(vk_Back) then {SelLength = 0}
      TmpStr := Copy(Text,1,SelStart-1)+Copy(Text,SelStart+1,255)
     else {Key in ['A'..'Z', etc]}
      TmpStr := Copy(Text,1,SelStart)+Key+Copy(Text,SelLength+SelStart+1,255) ;
     if TmpStr = '' then Exit;
     { update SelSt to the current insertion point }

     if (Key = Chr(vk_Back)) and (SelSt > 0) then Dec(SelSt)

     else if Key <> Chr(vk_Back) then Inc(SelSt) ;
     Key := #0; { indicate that key was handled }
     if SelSt = 0 then
     begin
       Text:= '';
       Exit;
     end;

    {Now that TmpStr is the currently typed
     string, see if we can locate a match }

     Found := False;
     for j := 1 to Items.Count do
       if Copy(Items[j-1],1,Length(TmpStr)) = TmpStr then
       begin
         Text := Items[j-1]; { update to the match that was found }
         ItemIndex := j-1;
         Found := True;
         Break;
       end;
     if Found then { select the untyped end of the string }
     begin
       SelStart := SelSt;
       SelLength := Length(Text)-SelSt;
     end
     else ShowTimedMsg('Not found',1500);//Beep;
   end;
end;
*)
procedure TPopComboListFP_2012.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
//If Key=#13 then OKBtnClick(Sender);
end;

end.
