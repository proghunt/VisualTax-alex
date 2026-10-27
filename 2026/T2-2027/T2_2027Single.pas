unit T2_2027Single;
(* Contains routines not used any more in the multi-app version.
  For reference purpose when inconsistencies are found,
   between single- and multi-app programs.
*)

interface

implementation

// ------------- TrimStr 2014-07-29 ------------------

Procedure BuildPropertiesFile;
var
 i,CompIndex,k,n,FNo,Elm,NumForms,NumEditBoxes:integer;
 FormsDir,DfmFileName,FName:string;
 AForm:Tform;
 TempList:TStringList;
 ADConnection: TADConnection;
 Table1: TADTable;
 FormFields:Integer;
 CursorPos:Integer;
 AEditBox:TvtEdit;
 ALabel:TVtLabel;
 AShape:TvtShape;
 PrevCursorTop:Integer;
 PrevCursorLeft:Integer;
 LblSectList:TStringList;
 YesNoLabelsList:TStringList;
 FormHeight,PrevFormHeight:Integer;

 PagebreakPos: array of Integer;
 p,j,tmp,formNumPages,PagebreakHeight:Integer;
 pageHeightList:TStringList;

begin
 TestAllForms;
 //ShowMessage('all Forms passed');  //20130530
 Try
 Screen.Cursor:=crHourGlass;
 pageHeightList := TStringList.Create;
 TempList:=TStringList.Create;
 LblSectList:=TStringList.Create;
 YesNoLabelsList:=TStringList.Create;
 FormsDir:=GetDfmFormsDir;
 //open T1Scr to store the cursor position and num of fields
 //20150923 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FormNo');

 TempList := TstringList.Create;
 TempList.Sorted := True;
 for i:=0 to FList.count - 1 do
 begin
  FormHeight:=0;
  PrevFormHeight:=0;
  FormFields:=0;
  CursorPos:=0;
  PrevCursorTop:=10000;
  PrevCursorLeft:=1000;
  AForm := Tform.Create(Application);
  FRec := FList.Items[i];
  FName:=Frec^.FormName+Frec^.FormInst;

  SetLength(PagebreakPos, 1);
  formNumPages := 0;
  PagebreakPos[0] := 0;

  If AllTrim(Frec^.FormInst) <'#2' then
  begin
   FNo:=Frec^.FormNo;
   DfmFileName:=GetDfmFileName(FName);
   If FileExists(DfmFileName) then
   Begin
    Try
    ReadComponentResFile(DfmFileName,AForm);
    except
     ShowMessage('Unable to read '+DfmFileName);
     AForm.free; //20120902
     break;
    end;
    LblSectList.Add(FName);  //header for each form
    //find cursor default
    for CompIndex := 0 to AForm.ComponentCount - 1 do
    begin
     if AForm.Components[CompIndex] is TvtEdit then
     begin
      AEditBox:=AForm.Components[CompIndex] As TvtEdit;
      Elm:=GetFieldId((AForm.Components[CompIndex] as TvtEdit).Name);
      If Elm > FormFields then FormFields:=Elm;
      if (AForm.Components[CompIndex] as TvtEdit).vtinputType = vtDollar then
       TempList.add(PaddR(FName,10)+PaddR(IntToStr(FNo),4)+PaddR(IntToStr(Elm),4)+'vtDollar');
      //find the most top, left unprotected field for cursor postionsing
      If ((AEditBox.vtDataSource = vtUser) Or (AEditBox.vtDataSource = vtPopupList))
        and (AEditBox.Visible = True)
       and (AEditBox.Top <= PrevCursorTop)
      then
      begin
        if AEditBox.Top = PrevCursorTop then
        begin
         if AEditBox.Left < PrevCursorLeft then
         begin
          PrevCursorTop:=AEditBox.Top;
          PrevCursorLeft:=AEditBox.Left;
          CursorPos:=Elm;
         end;
        end
        else
        begin
         PrevCursorTop:=AEditBox.Top;
         PrevCursorLeft:=AEditBox.Left;
         CursorPos:=Elm;
        end
      end;
      //form height
      If AEditBox.Visible = True then
      begin
        if (AEditBox.Top + AEditBox.Height) > PrevFormHeight then
        begin
         FormHeight := AEditBox.Top + AEditBox.Height;
         PrevFormHeight := FormHeight;
        end;
      end; //form height

     end; //vtEdit

     if AForm.Components[CompIndex] is TvtLabel then
     begin
      ALabel:=AForm.Components[CompIndex] As TvtLabel;
      If ALabel.vtIsSelectionLabel then  {section labels}
        LblSectList.Add(' '+PaddR(ALabel.Caption,80)+PaddR(FName,10)+IntToStr(ALabel.Top));

      If (Pos(UpperCase('y/n'),ALabel.Caption) >0 ) //<> -1)
      {Or (Pos('Y/N',ALabel.Caption) <> -1)}
      then
       YesNoLabelsList.Add('Y/N Label '+FName+' '+IntToStr(ALabel.Top));
      //form height
      If ALabel.Visible = True then
      begin
        if (ALabel.Top + ALabel.Height) > PrevFormHeight then
        begin
         FormHeight := ALabel.Top + ALabel.Height;
         PrevFormHeight := FormHeight;
        end;
      end; //form height

     end; //vtlabel

     if AForm.Components[CompIndex] is TvtShape then
     begin
      AShape:=AForm.Components[CompIndex] As TvtShape;


      if AShape.vtPageBreak then
      begin
       //page height
       SetLength(PagebreakPos, length(PagebreakPos)+1);
       formNumPages := formNumPages + 1;
       PagebreakPos[formNumPages] := AShape.Top;
      end;

      //form height
      If AShape.Visible = True then
      begin
        if (AShape.Top + AShape.Height) > PrevFormHeight then
        begin
         FormHeight := AShape.Top + AShape.Height;
         PrevFormHeight := FormHeight;
        end;
      end; //form height
     end; //vtShape

    end; //CompINdex
   end  //file exists
   else //file does not exist
    ShowTimedMsg('Form '+FName+' not found',1000);
  end;
  AForm.free;
  //update forms table
  if Table1.FindKey([FNo]) then
  begin
   Table1.edit;
   Table1.FieldByName('FormFields').AsInteger := FormFields;
   Table1.FieldByName('CursorPos').AsInteger:=CursorPos;
   Table1.FieldByName('FormHeight').AsInteger:=FormHeight;
   Table1.Post;
  end;


  //sort array
  for p := high(PagebreakPos)-1 Downto low(PagebreakPos) do
  begin
   for j := p to high(PagebreakPos)-1 do
   begin
    if PagebreakPos[j] > PagebreakPos[j + 1] then
    begin
     tmp := PagebreakPos[j];
     PagebreakPos[j] := PagebreakPos[j + 1];
     PagebreakPos[j + 1] := tmp;
    end;
   end;
  end;
  //find short pages
  for j := high(PagebreakPos)-1 Downto low(PagebreakPos) do
  begin
    if PagebreakPos[j + 1] - PagebreakPos[j] <= 970 then
    begin
       //showmessage('pg '+inttostr(j+1)+' short : '  + FName + ' - ' +DfmFileName);
       pageHeightList.add( paddR( DfmFileName, 40 ) + paddR(FName,10)  + 'pg '+inttostr(j+1)+' short : ' + inttostr(PagebreakPos[j + 1] - PagebreakPos[j])  );
       //break;
    end;
  end;

 end; //i, flist;

 Except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
 Screen.Cursor:=crDefault;
 pageHeightList.SaveToFile(AppDir+'\'+'PageHeight.d');
 TempList.SaveToFile(AppDir+'\'+'T2Prop.d');
 LblSectList.SaveToFile(AppDir+'\'+'LblSect.d');
 YesNoLabelsList.SaveToFile(AppDir+'\'+'YesNoLabels.Txt');

 pageHeightList.Free;
 LblSectList.Free;
 YesNoLabelsList.Free;
 TempList.Free;
 Table1.Close;
 Screen.Cursor:=crDefault;
 ShowTimedMsg('Done. Check YersNoLabels.txt',1200);
end;

Procedure TestAllForms;
var
 i,CompIndex,k,n,FNo,Elm,NumForms,NumEditBoxes:integer;
 FormsDir,DfmFileName,FName:string;
 AForm:Tform;
 TempList:TStringList;
 ADConnection: TADConnection;
 Table1: TADTable;
 FormFields:Integer;
 CursorPos:Integer;
 AEditBox:TvtEdit;
 ALabel:TVtLabel;
 AShape:TvtShape;
 PrevCursorTop:Integer;
 PrevCursorLeft:Integer;
 LblSectList:TStringList;
 YesNoLabelsList:TStringList;
 FormHeight,PrevFormHeight:Integer;

begin
 Screen.Cursor:=crHourGlass;
 TempList:=TStringList.Create;
 FormsDir:=GetDfmFormsDir;
 //open T1Scr to store the cursor position and num of fields
  //20150923 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FormNo');

 TempList := TstringList.Create;
 TempList.Sorted := True;
 for i:=0 to FList.count - 1 do
 begin
  AForm := Tform.Create(Application);
  FRec := FList.Items[i];
  FName:=Frec^.FormName+Frec^.FormInst;
  If AllTrim(Frec^.FormInst) <'#2' then
  begin
   FNo:=Frec^.FormNo;
   DfmFileName:=GetDfmFileName(FName);
   try
   If FileExists(DfmFileName) then
   begin
     ReadComponentResFile(DfmFileName,AForm);
     AForm.free;
   end
   else //file does not exist
   Begin
    ShowTimedMsg('Form '+FName+' not found',1000);
    AForm.free;
   end;
   except
    on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
   end;
  end;
 end; //i, flist;
// ShowMessage('Done reading all forms');
end;

Procedure CheckVtComponents;
var
 i,CompIndex,k,n,FNo,Elm,NumForms,NumEditBoxes:integer;
 pgBreakPos,componentPos :integer;
 
 FormsDir,DfmFileName,FName:string;
 AForm:Tform;
 TempList:TStringList;
begin
 Screen.Cursor:=crHourGlass;
 TempList:=TStringList.Create;
 FormsDir:=GetDfmFormsDir;
 //TempList := TstringList.Create;
 TempList.add('*** View FILE: CheckComp.txt  ***');
 Try
 for i:=0 to FList.count - 1 do
 begin
  AForm := Tform.Create(Application);
  FRec := FList.Items[i];
  FName:=Frec^.FormName+Frec^.FormInst;
  FNo:=Frec^.FormNo;
  DfmFileName:=GetDfmFileName(FName);
  If FileExists(DfmFileName) then
  Begin
    ReadComponentResFile(DfmFileName,AForm);
    If AForm.VertScrollBar.Position>0 then
    begin
     TempList.add('*** SET SCROLLBAR to TOP*** '+PaddR(FName,10));
     //showmessage(FormName);
    end;
 
    pgBreakPos := -1;
    componentPos := -1;
 
    for CompIndex := 0 to AForm.ComponentCount - 1 do
    begin
       if (AForm.Components[CompIndex]  is TEdit = True)
       and (AForm.Components[CompIndex] is TLabel = True)
       and (AForm.Components[CompIndex] is TShape = True)
       then
       begin
         TempList.add(PaddR(FName,10)+(AForm.Components[CompIndex]).Name);
       end;
 
       if (AForm.Components[CompIndex] is TvtShape = True) and ((AForm.Components[CompIndex] as TvtShape).vtpagebreak = True) then
       begin
         if pgBreakPos < (AForm.Components[CompIndex] as TControl).Top then
            pgBreakPos := (AForm.Components[CompIndex] as TControl).Top;
       end
       else
         if componentPos < ( (AForm.Components[CompIndex] as TControl).Top + (AForm.Components[CompIndex] as TControl).height ) then
            componentPos := (AForm.Components[CompIndex] as TControl).Top + (AForm.Components[CompIndex] as TControl).height;
 
    end; //CompINdex
 

  end  //file exists
  else //file does not exist
   ShowTimedMsg('Form '+FName+' not found',1000);
 
  if pgBreakPos = -1 then
    TempList.add(PaddR(FName,10)+'no page break on form')
  else if pgBreakPos < componentPos then
    TempList.add(PaddR(FName,10)+'page break not at end of form');

  AForm.free;
 end; //i, flist;
 Except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
 Screen.Cursor:=crDefault;
 TempList.SaveToFile(AppDir+'\'+'CheckComp.txt');
 If TempList.Count>0 then ShowMessage('Non Vt components found. See CheckComp.Txt');
 SomeList.Clear; //:=TStringList.Create; //20160704 Igor
 For i:=0 to templist.count-1 do SomeList.Add(TempList[i]);
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 //SomeList.Free; //20160704 Igor
 PopList.Release;
 TempList.Free;
 Screen.Cursor:=crDefault;
 showmessage('Done');

end;

end.
