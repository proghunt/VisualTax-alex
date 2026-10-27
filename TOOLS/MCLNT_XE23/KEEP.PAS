(* --------- Keep for reference -----}
DFMPtr, DFMTextPtr : pointer;

if MaintSw then
   begin
    (*
    Fclass := TT1PG1A;
    FormObject := T1PG1A; {GetFormObject(FormName);}
    Application.CreateForm(FClass, FormObject);
    DFMPtr     := AllocMem(5000);
    DFMTextPtr := AllocMem(5000);
    {ShowMessage('Puting form data and text in memory');}
    PutDFMInMem(DFMPtr,FormObject);
    PutDFMTextInMem(DFMTextPtr,FormObject);
    {FormObject.Show;}
    FormPtr := DFMPtr;  {Load from actual DFM form}
    TextPtr := DFMTextPtr;  {pointer to text-null}
    FormObject.Release;
   end;

   Procedure TMyChild.PutDFMInMem(DFMPtr: pointer; FormObject: TForm);
var
LabelPtr,LinePtr,FieldPtr  : ^integer;
TextPtr : PChar;
StartLineBucket,EndLineBucket,StartFieldBucket,EndFieldBucket :integer;
i,j,k,l,x,y: Integer;
LabelBucket,LineBucket,FieldBucket : integer;
incr : integer;
Rect : TRect;
hdc: THandle;
StartY, EndY: integer;
HResource : THandle;
PResource : Pointer;
PFormName  : PChar;
PChar1 : PChar;  {ptr to null terminated string}
Pointer1 : pointer;  {ptr to pascal string}
Pointer2 : ^String;
s1,s2 : string[12];
begin
 FormHeight := 0; {arbitrary}
 HeaderRec := DFMPtr;
  for I := 0 to FormObject.ComponentCount -1 do
   begin
     if FormObject.Components[I] is TLabel then
       begin inc(NumbLabels);
           if TLabel(FormObject.Components[I]).Top> FormHeight then
              FormHeight := TLabel(FormObject.Components[I]).Top;
       end;
     if FormObject.Components[I] is TDBEdit then
       begin inc(NumbFields);
           if TEdit(FormObject.Components[I]).Top> FormHeight then
              FormHeight := TEdit(FormObject.Components[I]).Top;
       end;

     if FormObject.Components[I] is TShape then
        inc(NumbLines);

  end;
  inc(FormHeight,100);
 {Write(F1, HeaderRec^);}
  HeaderRec^.NumbLabels := NumbLabels;
  HeaderRec^.NumbLines  := NumbLines;
  HeaderRec^.NumbFields := NumbFields;
  HeaderRec^.FormHeight := FormHeight;
  LabelBucket:= 1;
  LineBucket := NumbLabels * LabelProperties + 1;
  FieldBucket:= NumbLabels * LabelProperties + NumbLines * LineProperties +1;
  J := LabelBucket;
  k := FieldBucket;
  l := LineBucket;
  for I := 0 to (FormObject.ComponentCount -1) do
  begin
     if FormObject.Components[I] is TLabel then
       begin
       HeaderRec^.Bucket[j]   := TLabel(FormObject.Components[I]).Left;
       HeaderRec^.Bucket[j+1] := TLabel(FormObject.Components[I]).Top;
       HeaderRec^.Bucket[j+2] := TLabel(FormObject.Components[I]).Font.Size;

       HeaderRec^.Bucket[j+3] := 0; {initialize fontid}
       HeaderRec^.Bucket[j+4] := 0; {Initialize fontstyle}
       HeaderRec^.Bucket[j+5] := 0; {Initialize fontcolor}
       if TLabel(FormObject.Components[I]).Font.Name = 'System' then {FontId}
         HeaderRec^.Bucket[j+3] := 1
       else
         HeaderRec^.Bucket[j+3] := 0;

       if TLabel(FormObject.Components[I]).Font.Style = [fsItalic,fsBold] then  {FontStyle}
         begin
         HeaderRec^.Bucket[j+4] := 1; {style}
         HeaderRec^.Bucket[j+5] := 1; {color}
         end;
       if TLabel(FormObject.Components[I]).Font.Style = [fsItalic] then  {FontStyle}
         begin
         HeaderRec^.Bucket[j+4] := 1;
         HeaderRec^.Bucket[j+5] := 0;
         end;
       if TLabel(FormObject.Components[I]).Font.Style = [fsBold] then  {FontStyle}
         begin
         HeaderRec^.Bucket[j+4] := 0;  {style}
         HeaderRec^.Bucket[j+5] := 1;  {color}
         end;

       if TLabel(FormObject.Components[I]).Visible = Visible then
         HeaderRec^.Bucket[j+6] := 1
       else
         HeaderRec^.Bucket[j+6] := 0;

       inc(j,LabelProperties);
       end;

     if FormObject.Components[I] is TShape then
         begin
         HeaderRec^.Bucket[l]   :=TShape(FormObject.Components[I]).Top;
         HeaderRec^.Bucket[l+1] :=TShape(FormObject.Components[I]).Left;
         HeaderRec^.Bucket[l+2] :=TShape(FormObject.Components[I]).Width; {X2}
         HeaderRec^.Bucket[l+3] :=TShape(FormObject.Components[I]).Height; {Y2}
         HeaderRec^.Bucket[l+4] := 0; {pen:  TShape(FormObject.Components[I]).Height;}
         HeaderRec^.Bucket[l+5] := 1; {visible}
         end;


     if FormObject.Components[I] is TDBEdit then
       begin
       HeaderRec^.Bucket[k] :=TDBEdit(FormObject.Components[I]).Left;
       HeaderRec^.Bucket[k+1] :=TDBEdit(FormObject.Components[I]).Top;
       If TDBEdit(FormObject.Components[I]).MaxLength =0 then
          HeaderRec^.Bucket[k+2] :=12  {length 12 dummy}
       else
          HeaderRec^.Bucket[k+2] :=TDBEdit(FormObject.Components[I]).MaxLength;

       s1 :=TDBEdit(FormObject.Components[I]).Name;
       if Copy(S1,1,6) <> 'DBEdit' then
          begin
            ShowMessage('Field name must be DBEdit in '+
                    IntToStr(TDBEdit(FormObject.Components[I]).Top));
            exit;
          end;
       S2 := Copy(s1,7,Length(s1)-6); {get the xxx from DBEDitxxx}
       HeaderRec^.Bucket[k+3] :=StrToInt(s2); {Fieldid}

       HeaderRec^.Bucket[k+4] := (TDBEdit(FormObject.Components[I]).TabOrder+1); {taborder}

       if TDBEdit(FormObject.Components[I]).TabStop = True then
         HeaderRec^.Bucket[k+5] := 1
       else
         HeaderRec^.Bucket[k+5] := 0;
       if TDBEdit(FormObject.Components[I]).TabStop = True then {tabstop}
         HeaderRec^.Bucket[k+6] := 1
       else
           HeaderRec^.Bucket[k+6] := 0;
       if TDBEdit(FormObject.Components[I]).Tag = 0 then
         HeaderRec^.Bucket[k+6] := 0 {alphanumeric}
       else
         HeaderRec^.Bucket[k+6] :=TDBEdit(FormObject.Components[I]).Tag; {Mask}

       HeaderRec^.Bucket[k+7] :=TDBEdit(FormObject.Components[I]).Width;
       if TDBEdit(FormObject.Components[I]).Visible = True then {visible}
          HeaderRec^.Bucket[k+8] := 1
       else
          HeaderRec^.Bucket[k+8] := 0;

       HeaderRec^.Bucket[k+9] :=TDBEdit(FormObject.Components[I]).HelpContext;     {Link}

       if TDBEdit(FormObject.Components[I]).Font.Style = [fsBold] then {style}
         HeaderRec^.Bucket[k+10] :=1
       else
         HeaderRec^.Bucket[k+10] :=0;


       inc(k,FieldProperties);
       end;


   end;
end;
*)
(*
{----------------------Write text strings  ----------}
hdc :=  Self.Canvas.Handle;
Procedure TMyChild.PutDFMTextInMem(DFMTextPtr: Pointer;FormObject: TForm);
var
PResource : Pointer;
TextPtr : PChar;
I : Integer;
begin
  TextPtr := DFMTextPtr;
  for I := 0 to (FormObject.ComponentCount -1) do
   begin
      if FormObject.Components[I] is TLabel then
       begin
       StrPCopy(TextPtr,TLabel(FormObject.Components[I]).Caption);
       inc(TextPtr,StrLen(TextPtr)+1);
       end;
   end;
end;
*)

(*
     { API method for strings}
     NewRect.Left   := FieldRec^.Left;
     NewRect.Top    := FieldRec^.Top;
     NewRect.Right  := FieldRec^.Left+ FieldRec^.Width;
     NewRect.Bottom := FieldRec^.Top+ BoxHeight;
    *)
    (*
     { ExtTextOut}
     PRect := Addr(NewRect);
     SetTextAlign(hdc,TA_LEFT);
     ExtTextOut(hdc,FieldRec^.Left, FieldRec^.Top,
        ETO_OPAQUE,
        PRect, StrPCopy(s,Ret[RetNo]^.Frm[FormNo].Strings[k]),
        Length(Ret[RetNo]^.Frm[FormNo].Strings[k]),
        NIL); {spacing}
     *)
    (*

     FillRect(hdc,NewRect,GetStockObject(0)); {white brush}
     SetTextAlign(hdc,TA_RIGHT);
     TextOut(hdc,FieldRec^.Left+FieldRec^.Width, FieldRec^.Top,
        StrPCopy(s,Ret[RetNo]^.Frm[FormNo].Strings[k]),
        Length(Ret[RetNo]^.Frm[FormNo].Strings[k]));

    *)
