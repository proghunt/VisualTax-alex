unit vtRunArc;
// 20151030 Igor

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TvtRunArcForm = class(TForm)
    ListView: TListView;
    Label1: TLabel;
    procedure ListViewDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewClick(Sender: TObject);
  private
    fPathList:TStringList;
  public
    function Execute:Boolean;
  end;


implementation
{$R *.dfm}
uses ShellAPI, Winapi.ShlObj, ActiveX, SHFolder
   , vtTrimStr, vtMulti; //20160719 Igor

function TvtRunArcForm.Execute : Boolean;
var
  LStr: array[0 .. MAX_PATH] of Char;
  searchResult : TSearchRec;
  NewColumn: TListColumn;
  ListItem: TListItem;
  AppId:String;
  sl: TStringList; //20160719 Igor
  I: Integer; //20160719 Igor
  tmpSl: TStringList; //20161212 Igor
begin

  sl := GetVTLinks(''); //20160719 Igor
  try
    fPathList:=TStringList.Create;
    ListView.Items.Clear;
    ListView.Columns.Clear;
    NewColumn := ListView.Columns.Add;
    NewColumn.Caption := '';
    NewColumn.Autosize:=true;
    //20160719 Igor >>>
    I := 0;
    while I < sl.Count do
    begin
      AppId := GetAppIdFromExeName(ExtractFileName(sl[I+1]));
      if not Assigned(AppList.AppFromId(AppId)) and
         (fPathList.IndexOf(sl[I+1]) = -1) and
         (not sametext(ExtractFileName(sl[I+1]), extractFileName(Application.ExeName))) then //20161212 Igor
      begin
        //20161212 Igor >>>
        if (pos('vt-', lowercase(AppId)) = 1) and FileExists(ExtractFilePath(sl[I+1])+InstallFile) then
        begin
          tmpSL := TStringList.Create;
          try
            tmpSL.LoadFromFile(ExtractFilePath(sl[I+1])+InstallFile);
            AppID := AppID + ' (' + tmpSL.CommaText + ')';
          finally
            tmpSL.Free;
          end;
        end;
        //20161212 Igor <<<
        fPathList.Add(sl[I+1]);
        ListItem:=ListView.Items.Add;
        ListItem.Caption:=AppId;
      end;
      i := I + 2;
    end;
  finally
    sl.free;
  end;
//   SetLastError(ERROR_SUCCESS);
//     if SHGetFolderPath(0, 2, 0, 0, @LStr) = S_OK then
//       if FindFirst(LStr + '\VisualTax\*.*', faAnyFile, searchResult) = 0
//       then begin
//                 AppId:= ReplaceStr(searchResult.Name, ExtractFileExt(searchResult.Name), '');
//                 if (not Assigned(AppList.AppFromId(AppId)))and(searchResult.Name <> '.')and(searchResult.Name <> '..') then
//                 begin
//                      fPathList.Add(LStr + '\VisualTax\' + searchResult.Name);
//                      ListItem:=ListView.Items.Add;
//                      ListItem.Caption:=AppId;
//                 end;
//                 //
//                 while FindNext (searchResult) = 0
//                 do begin
//                         AppId:= ReplaceStr(searchResult.Name, ExtractFileExt(searchResult.Name), '');
//                         if (not Assigned(AppList.AppFromId(AppId)))and(searchResult.Name <> '.')and(searchResult.Name <> '..')
//                         then
//                         begin
//                              fPathList.Add(LStr + '\VisualTax\' + searchResult.Name);
//                              ListItem:=ListView.Items.Add;
//                              ListItem.Caption:=AppId;
//                         end;
//                    end;
//       end;
//20160719 Igor <<<

     if ListView.Items.Count = 0
     then begin
               ShowMessage ('<Old Year`s> does not exist'); //20190222 Igor
               Result:= false;
     end
     else Result:= ShowModal = mrOK;
     //
     fPathList.Free;
end;

procedure TvtRunArcForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = 27 then ModalResult:= mrCancel;

end;

procedure ShellExecuteG(const AWnd: HWND; const AOperation, AFileName: String; const AParameters: String = ''; const ADirectory: String = ''; const AShowCmd: Integer = SW_SHOWNORMAL);
var
  ExecInfo: TShellExecuteInfo;
  NeedUninitialize: Boolean;
begin
  Assert(AFileName <> '');

  NeedUninitialize := SUCCEEDED(CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE));
  try
    FillChar(ExecInfo, SizeOf(ExecInfo), 0);
    ExecInfo.cbSize := SizeOf(ExecInfo);

    ExecInfo.Wnd := AWnd;
    ExecInfo.lpVerb := Pointer(AOperation);
    ExecInfo.lpFile := PChar(AFileName);
    ExecInfo.lpParameters := Pointer(AParameters);
    ExecInfo.lpDirectory := Pointer(ADirectory);
    ExecInfo.nShow := AShowCmd;
    ExecInfo.fMask := SEE_MASK_NOASYNC { = SEE_MASK_FLAG_DDEWAIT для старых версий Delphi }
                   or SEE_MASK_FLAG_NO_UI;
    {$IFDEF UNICODE}
    // Необязательно, см. http://www.transl-gunsmoker.ru/2015/01/what-does-SEEMASKUNICODE-flag-in-ShellExecuteEx-actually-do.html
    ExecInfo.fMask := ExecInfo.fMask or SEE_MASK_UNICODE;
    {$ENDIF}

    {$WARN SYMBOL_PLATFORM OFF}
    Win32Check(ShellExecuteEx(@ExecInfo));
    {$WARN SYMBOL_PLATFORM ON}
  finally
    if NeedUninitialize then
      CoUninitialize;
  end;
end;


procedure TvtRunArcForm.ListViewClick(Sender: TObject);
begin
  Label1.Caption := fPathList[ListView.Selected.Index];
end;

procedure TvtRunArcForm.ListViewDblClick(Sender: TObject);
//20160719 Igor >>>
//var lFile:String;
begin
  ShellExecuteG(0, 'open', fPathList[ListView.Selected.Index]);

//  if GetFileNameFromLink(fPathList[ListView.Items.IndexOf(ListView.Selected)],
//  lFile) then begin
//     if Pos(#0, lFile) > 0 then
//        lFile := Copy(lFile, 1, Pos(#0, lFile) - 1);
//     ShellExecuteG(0, 'open', lFile);
//  end;
//20160719 Igor <<<
  //
  ModalResult:= mrOk;

end;

end.
