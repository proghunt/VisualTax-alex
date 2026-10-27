unit T2_2027rollctxt2;

(*
Comments:
Input RollCtxT1.d  format: 005,002S=SIN PAGE 1^1
output in TempDir  Format: above+ ^+value
*)

interface

uses
  TlHelp32, Windows, SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, DB, StdCtrls, Grids, DBGrids, DBCtrls,
  Menus, Buttons, FileCtrl, ShellApi, Mask, ComCtrls,
  VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, ComObj, //20150622
  olectnrs, OleServer, vtEditBox, vtCtxReader, T2_2027OptionsFrm;

const
  TempFlExtension = 'EXP';
  FieldsFlName = 'RollCtxT2.d';
  //FieldsFlName     = 'tempShortenedRollCtxT1.d';
  TempDirName = 'TempDir';

type
  TRollCtxT2T2_2027 = class(TForm)
    OpenDialog1: TOpenDialog;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    OpenBtn: TBitBtn;
    FileListBox1: TFileListBox;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    LinkToOptionsLbl: TLabel;
    Label5: TLabel;
    ReplaceOptionBox: TRadioGroup;
    CanTaxExtensionBox: TComboBox;
    FromDirBox: TEdit;
    SelectDirBtn1: TBitBtn;
    ToDirBox: TEdit;
    SelectDirBtn2: TBitBtn;
    Label6: TLabel;
    SaveOrOpenOptionBox: TRadioGroup;
    Chart1: TChart;
    Label7: TLabel;
    Button1: TButton;
    ConvertingLbl: TLabel;

    procedure SpCaptureCCALastYear(RetNo: Integer);
    function getCantaxFieldInfo(formField: string; CanTaxInfoList: TStringList): string;
    function getCantaxFieldInfo1(formField: string; CanTaxInfo: string): string; //20150702

    function LoadStringFromFile(const filename: string): AnsiString;
    function GetEXPInfo(ValuName, ConvertedFlName: string): string;
    //Function GetNumberOfTableRows(CanTaxFrmNm,CanTaxTableNm:String):Integer;
    procedure CheckDateFormat;
    function GetVisualExt(VtYearEnd: string): string;
    function GetCanTaxFldName(S: string; ClientOrSpouse: string): string;
    function HexToStr(AStr: string): string;
    function TransChar(AChar: Char): Integer;
    function ConvertOne(CanTaxFlName: string): Integer;
    function ConvertProvOfRes(Valu: string): string;
    function ConvertProvShort(Valu: string): string;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ImportAllBtnClick(Sender: TObject);
    procedure SaveIt(FlName: string);
    procedure StoreData(ConvList: TStringList);
    function ImportOne(ConvertedValues: TStringlist): Integer;
    procedure HelpBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SelectDirBtn1Click(Sender: TObject);
    procedure SelectDirBtn2Click(Sender: TObject);
    procedure ShowFiles;
    procedure FromDirBoxExit(Sender: TObject);
    procedure FromDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure CanTaxExtensionBoxChange(Sender: TObject);

    procedure FixBusPercent(RetNo: Integer);

    //Function FindAStringInCanTax(CanTaxFlName:String):Integer;
    procedure FindAStringInCanTax(CanTaxFlName: string);
    procedure FindBtnClick(Sender: TObject);
    //Function  ShowLOVInForm(CanTaxFlName:String):Integer;
    procedure ShowLOVInForm(CanTaxFlName: string);
    procedure LovBtnClick(Sender: TObject);
    //Function  FixMarStatus(Valu:String):Integer;
    procedure FixMarStatus(Valu: string);

    procedure FixAfterImport(RetNo: Integer);
    function GetConvertedFlName(CanTaxFlName: string): string;
    procedure BitBtn1Click(Sender: TObject);
    procedure LinkToOptionsLblClick(Sender: TObject);
    procedure FileListBox1Change(Sender: TObject);
    procedure FileListBox1KeyPress(Sender: TObject; var Key: Char);
    function fixValu(valu, valuType, FName: string; Elm: Integer): string;
    procedure Button1Click(Sender: TObject);
  private
    Tables: TCtxItem; //the loaded database
    Selector: RIndex; //the current selector

    { Private declarations }
  public
    { Public declarations }
  end;

var
  RollCtxT2T2_2027: TRollCtxT2T2_2027;
  RetNo: Integer;
  CtxAppName: string;
  TxtFailed: Boolean; //if the text file with c/f created or not

  ClientOrSpouse: string;
  UnclaimedRrspCF: Real;

  ButtonClicked: string;
  CanTaxFlName, ConvertedFlName, VisualFlName: string;
  CanTaxExtension: string;
  CanTaxYearEnd, VTYearEnd: string; //[10];
  Cnt: integer;
  InitialRowCount: integer;

  TmpList: TStringList;
  StmNo: Integer;
  TempDir: string;

implementation

{$R *.DFM}

uses
  vtMain, vtMulti, vtDialogs, vtCommon,
  //T2_2027SelectDir,
  T2_2027, T2_2027Main,
  T2_2027Declare, T2_2027TrimStr, T2_2027Common, T2_2027Common2, T2_2027ChildWinNEW,
  T2_2027Calc,
  vtTrimStr, vtShared;

procedure TRollCtxT2T2_2027.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  ButtonClicked := '';
  Convertinglbl.caption := '';
  ToDirBox.Text := OptRec.Dir_Cur;

  FromDirBox.Text := OptRec.Dir_LastYr;
  //FromDirBox.Text:= 'C:\Documents and Settings\User\My Documents\My Received Files\DoDi';

  CanTaxExtensionBox.items.add('.c**');
  CanTaxExtensionBox.items.add('.*');
  //CanTaxExtensionBox.items.add('*');
  CanTaxExtensionBox.Text := CanTaxExtensionBox.items[0];

  CanTaxExtension := CanTaxExtensionBox.Text;

  TempDir := AppDir + '\' + TempDirName;
  if SysUtils.DirectoryExists(TempDir) then //20150702
  else
    MkDir(TempDir);

  ShowFiles;
end;

procedure TRollCtxT2T2_2027.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TRollCtxT2T2_2027.ImportAllBtnClick(Sender: TObject);
var
  i, k, EndPos: Integer;
  Ext: string;
begin
  if RetInMem > 0 then
  begin
    ShowMessage('Please close all returns first');
    exit;
  end;

  if FileListBox1.Items.Count <= 0 then
  begin
    ShowMessage('No files are available for inport');
    exit;
  end;

  if MessageDlg('Roll-over ' + 'howmanybox.text' + ' starting from selected return? Are you sure?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit;

  ButtonClicked := 'IMPORT ALL';
  Screen.Cursor := crHourGlass;

  OpenBtn.Enabled := False;

  K := filelistbox1.itemindex;
  Cnt := 0;

  OpenBtn.Enabled := True;

  Screen.Cursor := crDefault;
  ShowMessage('Total returns Rolled Over = ' + IntToStr(cnt)
    + Chr(13) + 'You can now Exit and use Open from the VisualTax Main Menu');
  ButtonClicked := '';

  //Close active return
  //   AppActivate( pchar('' + CtxAppName) );
  //  SendKeys('%{F3}',True);
end;

function TRollCtxT2T2_2027.GetVisualExt(VtYearEnd: string): string;
var
  i: Integer;
  TwoDigitYE: string; //[2];
begin
  TwoDigitYE := MidStr(VTYearEnd, 3, 2);
  Result := FillLeftZeros(AllTrim(TwoDigitYE), 2);
end;

procedure TRollCtxT2T2_2027.SaveIt(FlName: string);
begin
  CalcFed(RetNo);
  CalcOnt(RetNo);
  CalcAlb(RetNo);
  if not SaveReturn(RetNo, ToDirBox.Text, FlName, True, True) = wrDone then
    ShowMessage('Save of data failed')
  else
    Inc(Cnt);
end;

procedure TRollCtxT2T2_2027.ShowFiles;
begin
  FileListBox1.Directory := FromDirBox.Text;
  FileListBox1.Mask := '*' + CanTaxExtensionBox.text;
  FileListBox1.ItemIndex := 0;
  //FilesGroupBox.Caption := 'FILES: '+IntTostr(FileListBox1.Items.count);
end;

function TRollCtxT2T2_2027.fixValu(valu, valuType, FName: string; Elm: Integer): string;
var
  FNo: integer;
begin

  Result := Valu;

  if valuType = 'SIN' then
  begin
    Result := AllTrim(RemoveChar(Valu, ' ')); //sin
    Result := AllTrim(RemoveChar(Result, '-')); //sin
  end;

  if valuType = 'UPPERCASE' then
    Result := Uppercase(valu);

  if valuType = 'PROVINCE' then
    Result := ConvertProvOfRes(Valu);

  if valuType = 'PROVSHORT' then
    Result := ConvertProvShort(Valu);

  if valuType = 'YESNO' then
    if Valu = '0' then
      Result := 'N'
    else
      Result := 'Y';

  if valuType = 'X' then
    if Valu = '1' then
      Result := 'X'
    else
      Result := '';

  if valuType = 'REVERSEX' then
    if Valu = '2' then
      Result := 'X'
    else
      Result := '';

  if valuType = 'DATE' then
    if Valu <> '0' then
      Result := CanTaxJulianDaysToYYYYMMDD(Valu)
    else
      Result := '';

  if valuType = 'AREA' then
  begin
    valu := RemoveChar(valu, ' ');
    valu := RemoveChar(valu, '-');
    if Length(valu) > 7 then
      Result := LeftStr(valu, 3)
    else
      Result := '';
  end;

  if valuType = 'PHONE' then
  begin
    Result := RemoveChar(valu, ' ');
    Result := RemoveChar(Result, '-');
    if Length(valu) > 7 then
      Result := MidStr(Result, 4, 10);

  end;

  if valuType = 'INCYEAR' then
  begin
    //Result:=IncrYear(Result); //doesnt work?
    Result := IntToStr(MyStrToInt(Result) + 365);
    Result := CanTaxJulianDaysToYYYYMMDD(result);
  end;

  if valuType = 'ADDRC' then
  begin
    if valu > '' then
      Result := result + 'RC0001';
  end;

  if FName = 'T2' then
  begin
    FNo := GetFormNo(FName);
    case Elm of
      51:
        begin //corp type
          if Valu < '2' then
          begin result := 'X';
            StoreElm(RetNo, FNo, 51, 'X');
          end
          else if Valu = '2' then
          begin result := 'X';
            StoreElm(RetNo, FNo, 56, 'X');
          end
          else if Valu = '3' then
          begin result := 'X';
            StoreElm(RetNo, FNo, 59, 'X');
          end
          else if Valu = '4' then
          begin result := 'X';
            StoreElm(RetNo, FNo, 57, 'X');
          end
          else if Valu = '5' then
          begin result := 'X';
            StoreElm(RetNo, FNo, 57, 'X');
          end
          else if Valu = '6' then
          begin result := 'X';
            StoreElm(RetNo, FNo, 52, 'X');
          end;
          result := '';
        end;
      53:
        begin //exempt case
          if Valu = '1' then
          begin Result := 'X';
            StoreElm(RetNo, FNo, 53, 'X');
          end
          else if Valu = '2' then
          begin Result := 'X';
            StoreElm(RetNo, FNo, 54, 'X');
          end
          else if Valu = '3' then
          begin Result := 'X';
            StoreElm(RetNo, FNo, 55, 'X');
          end
          else if Valu = '4' then
          begin Result := 'X';
            StoreElm(RetNo, FNo, 58, 'X');
          end;
          result := '';
        end;
    end;
  end;
  if FName = 'OPG_3' then
  begin
    if Elm = 20 then
    begin
      result := ''; {below does nor work for all}
    end;

  end;
  if valu = '0' then
    Result := '';

end;

procedure TRollCtxT2T2_2027.StoreData(ConvList: TStringList);
var
  i, j, FNo, Elm, AssetFNo: Integer;
  FName, valuType, Valu: string;
  WList: TStringList;
  ZString: array[0..80] of Char;
  PZString: Pchar;
begin
  WList := TStringList.Create;

  // 20150702 reorganized try except to be inside for loop
  for i := 0 to ConvList.Count - 1 do
  begin
    try
      if AllTrim(ConvList[i]) > '' then
      begin
        valu := '';
        FNo := 0;
        try
          ParseWords(ConvList[i] + '^', '^', WList); {added a last delim in case no value}

          valuType := AllTrim(WList[1]);
          FName := AllTrim(WList[2]);
          Elm := MyStrToInt(AllTrim(Wlist[3]));
          Valu := AllTrim(WList[4]);

          // IF valuType = 'TEST' then showmessage(FName + ' ' + Wlist[3]);
          //IF pos('Dep#', ConvList[i]) > 0 then showmessage(ConvList[i]);
          //IF Elm = 4 then showmessage('stop elm:' + inttostr(Elm));
          //if fname = 'S360' then showmessage('stop');
          //if (fname = 'S8#1') and (elm=6) then showmessage('stop');

          if WList.Count >= 3 then
            Valu := fixValu(Valu, valuType, FName, Elm)
          else
            Valu := '';

        except
          on E: Exception do
            MessageDlg(ConvList[i] + ' ' +
              E.Message, mtError, [mbok], 0);
        end;

        FNo := GetFormNo(FName);
        if (FNo > 0) then
        begin
          if (Ret[RetNo].Frm[Fno].Count = 0) then
            InitFormData(RetNo, FNo);
        end;

        if (FNo = 0) and (IsFormMultiInst(FName)) then
        begin
          Fno := AddPageInstance(RetNo, ExtractNonInstFormName(FName), ExtractFormInst(FName));
          AddOtherPagesInstance(RetNo, ExtractNonInstFormName(FName), ExtractFormInst(FName));
          //Fno := GetFormNo(FName); {get it again}
          InitFormData(RetNo, FNo); //June 2002
        end;

        Ret[RetNo].FrmHasData[FNo] := False;

        if (FNo > 0) and (Valu > '') then
        begin
          try
            StoreElm(RetNo, FNo, Elm, Valu);
          except
            on E: Exception do
              MessageDlg(ConvList[i] + ' ' +
                E.Message, mtError, [mbok], 0);
          end;
          if Valu > '' then
            Ret[RetNo].FrmHasData[FNo] := True;
        end; {valu > ''}
      end; {alltrim of temp rec}
    except
      on E: Exception do
        MessageDlg(ConvList[i] + ' ' + E.Message, mtError, [mbok], 0);
    end; {Try}
  end; {i}

  WList.free;
end;

procedure TRollCtxT2T2_2027.HelpBtnClick(Sender: TObject);
begin
  ShowHelp(AppList.AppFromName('T1').ModuleHelpUpdFile, 'Converting_from_CanTax', True); //20160801 Igor
  {
  Application.HelpFile := AppDir+'\'+'T1UPDHLP.HLP';
  Application.HelpJump('Converting_from_CanTax');
  }
end;

procedure TRollCtxT2T2_2027.OpenBtnClick(Sender: TObject);
var
  FNo, j, i: Integer;
  SelectedCount: Integer;
begin
  if not SysUtils.DirectoryExists(FromDirBox.Text) then //20150702
  begin
    ShowMessage('From Directory ' + FromDirBox.Text + ' does not exist');
    exit;
  end;
  if FileListBox1.ItemIndex < 0 then
  begin
    ShowMessage('You must select a file first');
    exit;
  end;

  // CheckDateFormat;

  FileListBox1.enabled := False;
  ButtonClicked := 'OPEN';

  SelectedCount := 0;
  for i := 0 to (FileListBox1.Items.Count - 1) do
  begin
    if FileListBox1.Selected[i] then
      Inc(selectedCount, 1);
  end;

  if (Selectedcount > 1) and (SaveOrOpenOptionBox.ItemIndex = 0) then
  begin
    ShowMessage('You must set the option Save Rerturns Directly to file');
    LockWindowUpdate(0);
    exit;
  end;

  Screen.Cursor := crHourGlass;

  for i := 0 to (FileListBox1.Items.Count - 1) do
  begin
    if FileListBox1.Selected[i] then
    begin
      CanTaxFlName := FromDirBox.Text + '\' + FileListBox1.Items[i];
      ConvertingLbl.Caption := '';
      ConvertingLbl.Update;
      ConvertingLbl.Caption := FileListBox1.Items[i];
      ConvertingLbl.Update;
      if ConvertOne(CanTaxFlName) = 0 then
      begin
        Screen.Cursor := crHourGlass;
      end;
    end; //if selected
  end; //for FileListBox1.Items.Count
  if SaveOrOpenOptionBox.ItemIndex = 1 then
    ShowMessage('Done.' + Chr(13) + 'Now you can open any of the rolled-over returns');

  Screen.Cursor := crDefault;
  Close;
  ButtonClicked := '';
  LockWindowUpdate(0);
end;

procedure TRollCtxT2T2_2027.SelectDirBtn1Click(Sender: TObject);
var
  DirSelected: string;
begin
  if SelectDirectory('Select a folder:', '', DirSelected, []) then
    FromDirBox.Text := DirSelected;
  ShowFiles;
end;

procedure TRollCtxT2T2_2027.SelectDirBtn2Click(Sender: TObject);
var
  DirSelected: string;
begin
  if SelectDirectory('Select a folder:', '', DirSelected, []) then
    ToDirBox.Text := DirSelected;
end;

function TRollCtxT2T2_2027.ConvertProvOfRes(Valu: string): string;
var
  n: Integer;
begin
  Result := '';
  n := MyStrToInt(AllTrim(Valu));
  case n of
    1: Result := 'Newfoundland';
    2: Result := 'Prince Edward Island';
    3: Result := 'Nova Scotia';
    4: Result := 'New Brunswick';
    5: Result := 'Quebec';
    6: Result := 'Ontario';
    7: Result := 'Manitoba';
    8: Result := 'Saskatchewan';
    9: Result := 'Alberta';
    10: Result := 'British Columbia';
    11: Result := 'Yukon Territory';
    12: Result := 'Northwest Territories';
    13: Result := 'Nunavut';
    14: Result := 'Multiple';
    15: Result := 'N.S. Offshore';
    16: Result := 'Outside Canada';
    17: Result := 'NFLD Offshore';
    18: Result := 'Nunavut';
  end;
  //Result:=UpperCase(Result); //doesnt work with uppercase...
end;

function TRollCtxT2T2_2027.ConvertProvShort(Valu: string): string;
var
  n: Integer;
begin
  Result := '';
  n := MyStrToInt(AllTrim(Valu));
  case n of
    1: Result := 'NL';
    2: Result := 'PE';
    3: Result := 'NS';
    4: Result := 'NB';
    5: Result := 'QC';
    6: Result := 'ON';
    7: Result := 'MB';
    8: Result := 'SK';
    9: Result := 'AB';
    10: Result := 'BC';
    11: Result := 'YT';
    12: Result := 'NT';
    13: Result := 'NU';
    14: Result := 'MJ';
    15: Result := 'NO';
    16: Result := 'OC';
    17: Result := 'X0';
    18: Result := 'NU';
  end;
  Result := UpperCase(Result);
end;

procedure TRollCtxT2T2_2027.FromDirBoxExit(Sender: TObject);
begin
  ShowFiles;
end;

procedure TRollCtxT2T2_2027.FromDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ShowFiles;
end;

function TRollCtxT2T2_2027.GetCanTaxFldName(S: string; ClientOrSpouse: string): string;
var
  WList: TStringList;
begin
  if s = '' then
  begin Result := '';
    exit;
  end;
  if LeftStr(s, 2) = '//' then
  begin result := '';
    Exit;
  end;
  WList := TstringList.Create;
  ParseWords(S, '=', WList);
  Result := Wlist[0];
  WList.Free;
end;

(*
Function TRollCtxT1.GetNumberOfTableRows(CanTaxFrmNm,CanTaxTableNm:String):Integer;
var i,FCount:Integer;
begin
  FCount:=CanTaxClient1.FormCount[CanTaxFrmNm];
  Result:=0;
  For i:=0 to FCount-1 do
  begin
   Result:=Result+CanTaxClient1.TableItemCount[CanTaxTableNm,i];
  end;
end;
*)

function TRollCtxT2T2_2027.getCantaxFieldInfo(formField: string; CanTaxInfoList: TStringList): string;
var
  i, StartPos, EndPos, EndPos2, EndPos3: Integer;
  temp: string;
begin
  result := '';
  for i := 0 to CanTaxInfoList.count - 1 do
  begin
    if Pos(uppercase(formField), uppercase(CanTaxInfoList[i])) > 0 then
    begin
      temp := CanTaxInfoList[i];
      StartPos := pos(formField, temp) + Length(formField) + 1;
      temp := alltrim(midstr(temp, StartPos, Length(temp)));

      EndPos := Pos('     ', temp);
      EndPos2 := Pos('FC', temp);
      EndPos3 := Pos('|', temp);
      if (EndPos3 > 0) then
        temp := alltrim(LeftStr(temp, EndPos3))
      else if EndPos > 0 then
        temp := alltrim(LeftStr(temp, EndPos))
      else if EndPos2 > 0 then
        temp := alltrim(LeftStr(temp, EndPos2));

      result := temp;
      exit;
    end;
  end;
end;

function TRollCtxT2T2_2027.getCantaxFieldInfo1(formField: string; CanTaxInfo: string): string;
var
  i, StartPos, EndPos, EndPos2, EndPos3, tempfrontPos: Integer;
  temp, tempFront: string; //20150702
begin
  result := '';
  FormField := UpperCase(FormField);
  StartPos := pos(formField, CanTaxInfo);
  if StartPos > 0 then
  begin
    StartPos := StartPos + Length(formField) + 1;
    tempFront := midStr(CanTaxInfo, StartPos, Length(CanTaxInfo));
    EndPos := Pos('|', tempFront) - 1;
    temp := alltrim(LeftStr(tempFront, EndPos));
    if temp = '' then
    begin
      tempfrontPos := Pos('|(', tempfront);
      if (tempfrontPos > 0) and (tempfrontPos < 3) then
      begin
        StartPos := tempfrontPos + 2;
        tempFront := midStr(tempfront, StartPos, Length(tempFront));
        EndPos := Pos('|)', tempFront) - 1;
        temp := alltrim(LeftStr(tempFront, EndPos));
      end;
    end;
    //temp := ConvertToProper(temp);
    result := temp;
    exit;
  end;
end;

function GetWindowExeName(Handle: THandle): string;
{Given a window handlew, return the program name}
var
  PE: TProcessEntry32;
  Snap: THandle;
  ProcessId: cardinal;
begin
  result := '???';
  pe.dwsize := sizeof(PE);
  GetWindowThreadProcessId(Handle, @ProcessId);
  Snap := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap <> 0 then
  begin
    if Process32First(Snap, PE) then
      if PE.th32ProcessID = ProcessId then
        Result := string(PE.szExeFile)
      else
        while Process32Next(Snap, PE) do
          if PE.th32ProcessID = ProcessId then
          begin
            Result := string(PE.szExeFile);
            break;
          end;
    CloseHandle(Snap);
  end;
end;

function TRollCtxT2T2_2027.LoadStringFromFile(const filename: string): AnsiString;
var
  fs: TFilestream;
begin
  fs := TFileStream.Create(filename, fmOpenRead or fmShareDenyNone);
  try
    SetLength(Result, fs.Size);
    fs.ReadBuffer(Result[1], Length(Result));
  finally
    fs.free
  end;
end; { LoadStringFromFile }

function TRollCtxT2T2_2027.HexToStr(AStr: string): string;
var
  I: Integer;
  CharValue: Word;
begin
  Result := '';
  for I := 1 to Trunc(Length(Astr) / 2) do
  begin
    Result := Result + ' ';
    CharValue := TransChar(AStr[2 * I - 1]) * 16 + TransChar(AStr[2 * I]);
    Result[I] := Char(CharValue);
  end;
end;

function TRollCtxT2T2_2027.TransChar(AChar: Char): Integer;
begin
  if CharInSet(AChar, ['0'..'9']) then //20150702
    Result := Ord(AChar) - Ord('0')
  else
    Result := 10 + Ord(AChar) - Ord('A');
end;

function TRollCtxT2T2_2027.ConvertOne(CanTaxFlName: string): Integer;
var
  i, c, n, CantaxFormNumber, CloneCount: integer;
  okay: boolean;
  CantaxFieldCode, tempCantaxFieldCode, VisualTaxFieldCode: string;
  ClientInFile, CanTaxInfoList, ConvertedValuesList: TStringList;
begin
  CanTaxInfoList := TStringList.Create;
  ConvertedValuesList := TStringList.Create;

  //CanTaxInfoList.LoadFromFile(AppDir+'\rollctxt1.d');
  CanTaxInfoList.LoadFromFile(AppDir + '\' + FieldsFlName);

  ClientInFile := TStringList.Create; // 20150702
  try
    //load the file
    Tables.Free;
    Tables := LoadCtx(CanTaxFlName);
    Tables.PutClients(ClientInFile);
    UndefMsg('TRollCtxT2T2_2027.ConvertOne');
    Result := 0; //???
  except
    Showmessage('error loading file');
    result := -1;
    //exit;
  end;

  for c := 0 to ClientInFile.count - 1 do
  begin
    try
      ConvertedValuesList.clear;
      for i := 0 to CanTaxInfoList.Count - 1 do
      begin
        if (Copy(CanTaxInfoList[i], 0, 2) <> '//') and (CanTaxInfoList[i] > '') then
        begin
          CantaxFieldCode := Copy(CanTaxInfoList[i], 0, Pos('=', CanTaxInfoList[i]) - 1);

          //if i > 177 then showmessage(inttostr(i));

          CantaxFormNumber := strtoint(Copy(CantaxFieldCode, 3, 3));

          CloneCount := Tables.CloneCount(c, CantaxFormNumber);

          n := 1;
          repeat //check first instance and repeat if has clones
            tempCantaxFieldCode := CantaxFieldCode;
            if n > 1 then
            begin
              Insert('#' + inttostr(n), tempCantaxFieldCode, 6);
            end;
            okay := ParseKey(tempCantaxFieldCode, c, Selector);
            //write value
            if okay and Assigned(Tables) then
            begin
              VisualTaxFieldCode := Copy(CanTaxInfoList[i], Pos('=', CanTaxInfoList[i]) + 1, Length(CanTaxInfoList[i]));
              VisualTaxFieldCode := StringReplace(VisualTaxFieldCode, '#y', '#' + inttostr(n), [rfReplaceAll, rfIgnoreCase]);

              try
                case Selector.ft of
                  ftCurr: ConvertedValuesList.Add(VisualTaxFieldCode + '^' + CurrToStr(Tables.GetReal(Selector)));
                  ftByte: ConvertedValuesList.Add(VisualTaxFieldCode + '^' + IntToStr(Tables.GetByte(Selector)));
                  ftInt: ConvertedValuesList.Add(VisualTaxFieldCode + '^' + IntToStr(Tables.GetLong(Selector)));
                  ftStr: ConvertedValuesList.Add(VisualTaxFieldCode + '^' + Tables.GetString(Selector));
                end;
              except
                //showmessage('Failed to read code ' + tempCantaxFieldCode);
              end;

            end; //if okay and Assigned(Tables)

            inc(n);
          until n >= clonecount + 1;

        end; //<> '//'
      end; //CanTaxInfoList

    except
    end;

    ConvertedFlName := GetConvertedFlName(TempDir + '\' + ClientInFile[c]);
    ConvertedValuesList.savetoFile(ConvertedFlName);

    ImportOne(ConvertedValuesList);
  end; //for clientsInFile

  CanTaxInfoList.free;
  ConvertedValuesList.free;
  //showmessage('Cantax Values File Created');

end;

function TRollCtxT2T2_2027.GetConvertedFlName(CanTaxFlName: string): string;
var
  s: string;
begin
  s := CanTaxFlName;
  s := ExtractFileName(CanTaxFlName);
  s := ChangeFileExt(s, '.' + TempFlExtension);
  result := TempDir + '\' + s;
end;

function TRollCtxT2T2_2027.ImportOne(ConvertedValues: TStringlist): Integer;
var
  i, j, FNo, AssetFNo: integer;
  Msg: string;
  PrPStatus, EfStatus, Notes, LastYrDir, Sin: string;
  CanTaxYearend, VtYearEnd: string;
  MyRet: TRetT2_2027;
begin
  Result := 9;
  if SaveOrOpenOptionBox.ItemIndex = 0 then
  begin
    //open
    RetNo := FileNew;
  end
  else //save
  begin
    RetNo := CreateNewReturn;
    if RetNo < 1 then
    begin ShowOpenReturnFailure(RetNo, '', '');
      exit;
    end;
  end;

  try
    Ret[RetNo].SourceDataDir := ToDirBox.Text; {fooli t}

    StoreData(ConvertedValues);
    UpdateAllDataIndicators(RetNo);

  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;

  FixAfterImport(RetNo);
  CalcFed(RetNo);
  CalcOnt(RetNo);
  CalcAlb(RetNo);

  if SaveOrOpenOptionBox.ItemIndex = 0 then
  begin
    //open
    OpenForm(RetNo, GetFormNo('T2'), 0);
    mainform.RefreshAuditPanel(RetNo);
    Ret[RetNo].Changed := True;
  end
  else
  begin
    //save to file
    Sin := GetEXPInfo('BN', ConvertedFlName);
    if Sin = '' then
    begin
      ShowMessage('Cannot Import this file.' + Chr(13) + 'Business Number cannot be established');
      Result := 1; {no account No}
      exit;
    end;

    VtYearEnd := GetEXPInfo('endYear', ConvertedFlName);
    VtYearEnd := CanTaxJulianDaystoYYYYMMDD(VtYearEnd);
    VisualFlName := LeftStr(Sin, 9) + '.' + GetVisualExt(VtYearEnd);

    if (FileExists(ToDirBox.Text + '\' + VisualFlName)) and (ReplaceOptionBox.ItemIndex = 1) then
      ShowTimedMsg('File: ' + Chr(13) + CanTaxFlName + Chr(13) + 'already exists', 1500)
    else
    begin
      if RetNo > 0 then
      begin
        //not working
        if Ret[RetNo].Province <> 'NB' then
          Ret[RetNo].FrmHasData[GetFormNo('S360')] := False;
        if Ret[RetNo].Province <> 'MB' then
          Ret[RetNo].FrmHasData[GetFormNo('S380')] := False;
      end;
      SaveIt(VisualFlName);
    end;

    if RetNo > 0 then
      RemoveReturnFromMemory(RetNo);
    RetNo := 0; //RetINmem :=0;
    //SendMessage(MDIHandle,WM_PAINT,0,0);
  end;
  Result := 0;
end;

procedure TRollCtxT2T2_2027.FileListBox1DblClick(Sender: TObject);
begin
  OpenBtnClick(Sender);
end;

procedure TRollCtxT2T2_2027.CanTaxExtensionBoxChange(Sender: TObject);
begin
  CanTaxExtension := CanTaxExtensionBox.text;
  ShowFiles;
end;

procedure TRollCtxT2T2_2027.FindBtnClick(Sender: TObject);
begin
  CanTaxFlName := FromDirBox.Text + '\' + FileListBox1.Items[FileListBox1.ItemIndex];
  FindAStringInCanTax(CanTaxFlName);
end;

procedure TRollCtxT2T2_2027.FindAStringInCanTax(CanTaxFlName: string);
//Function TRollCtxT2T2_2027.FindAStringInCanTax(CanTaxFlName:String):Integer;
var
  s: string;
  FldName, FldType: string;
  Item: Variant;
  FNo, ElmNo: Integer;
  OutList: TStringList;
  i, j, ii, VisualInst, VisualIncr, FCount, TableRows, MaxVisualRowsPerInst: Integer;
  CanTaxFrmNm, VisualFrmNm, CanTaxTableNm, VisualFldDescr, CanTaxInstance: string;

  Txt: string;
  FromFNo, ToFNo, Elms: Integer;
begin
  (*
    Result:=9;
    Try
     If CanTaxAppCreated = false then
     begin
      CanTaxFile1:= T1W_tlb.CoCanTaxT1App.Create;
      CanTaxAppCreated := True;
      CanTaxFile1.MinimizeApp;
      CanTaxFile1.LoadTaxReturn(CanTaxFlName);
      CanTaxData1:= T1W_tlb.CoCanTaxT1Data.Create;
     end;
    except
     ShowMessage('CanTax cannot be started properly');
    end;
    //GENERAL SEARCH FOR A STRING in cantax:
    //check 300 form no and 1500 elements

    Txt:= UpperCase(InputBox('Input Box', 'Input text', ''));
    If Txt='' then exit;
    FromFNo:= MyStrToInt(UpperCase(InputBox('Input Box', 'From FNo', '1')));
    ToFNo:= MyStrToInt(UpperCase(InputBox('Input Box', 'To FNo', '100')));

    SomeList := TStringList.Create;
    ShowMessage('Starting loop');
    Screen.Cursor := crHourGlass;
    i:=FromFNo;
    Repeat
      j:=1;
      Repeat
      Try
       s:= CanTaxData1.GetString(i,j);

       If LeftStr(UpperCase(S),Length(Txt)) = UpperCase(Txt) then
           SomeList.Add('Form='+IntToStr(i)+' '+'Elm='+IntToStr(j)+' '+s);

      Except
        on EOLESysError do
        begin
         //ShowMessage('ERROR: i='+IntToStr(i)+' '+'Elm='+IntToStr(j));
         ii:=i;  //handled
        end;
      end;  //try
      Inc(j);
      until j>300; //5000;  //1500;
    Inc(i);
    until i>ToFNo;
    Screen.Cursor := crDefault;
    SomeList.SaveToFile('C:\test\Cantax.txt');
    Application.CreateForm(TPoplist,PopList);
    PopList.ShowModal;
    SomeList.Free;
    PopList.Release;
  *)
end;

procedure TRollCtxT2T2_2027.LovBtnClick(Sender: TObject);
begin
  CanTaxFlName := FromDirBox.Text + '\' + FileListBox1.Items[FileListBox1.ItemIndex];
  ShowLovInForm(CanTaxFlName);
end;

procedure TRollCtxT2T2_2027.ShowLOVInForm(CanTaxFlName: string);
//Function TRollCtxT2T2_2027.ShowLOVInForm(CanTaxFlName:String):Integer;
var
  s: string;
  FldName, FldType: string;
  Item: Variant;
  FNo, ElmNo: Integer;
  OutList: TStringList;
  i, j, ii, VisualInst, VisualIncr, FCount, TableRows, MaxVisualRowsPerInst: Integer;
  CanTaxFrmNm, VisualFrmNm, CanTaxTableNm, VisualFldDescr, CanTaxInstance: string;

  Txt: string;
  FromFNo, ToFNo, FromElm, Elms: Integer;
begin
  (*
   Result:=9;
   Try
    If CanTaxAppCreated = false then
    begin
     CanTaxFile1:= T1W_tlb.CoCanTaxT1App.Create;
     CanTaxAppCreated := True;
     CanTaxFile1.MinimizeApp;
     CanTaxFile1.LoadTaxReturn(CanTaxFlName);
     CanTaxData1:= T1W_tlb.CoCanTaxT1Data.Create;
    end;
   except
    ShowMessage('CanTax cannot be started properly');
   end;
   //GENERAL SEARCH FOR A STRING in cantax:
   //check 300 form no and 1500 elements

   FromFNo:= MyStrToInt(UpperCase(InputBox('Input Box', 'From FNo', '')));
   If FromFNo=0 then exit;
   ToFNo:= MyStrToInt(UpperCase(InputBox('Input Box', 'To FNo', '23')));
   FromElm:= MyStrToInt(UpperCase(InputBox('Input Box', 'From Elm', '1')));
   Elms:= MyStrToInt(UpperCase(InputBox('Input Box', 'HowMany Elms', '1500')));

   SomeList := TStringList.Create;
   //SomeList.Sorted := True;

   Screen.Cursor := crHourGlass;
   ShowMessage('Starting loop');
   i:=FromFNo;
   Repeat
     j:=FromElm;
     Repeat
     Try

      s:= CanTaxData1.GetString(i,j);
      If (Length(s)>0) and (Length(s)<20) then
        SomeList.Add('Form='+IntToStr(i)+' '+'ElmString='+IntToStr(j)+' '+s);

     Except
       on EOLESysError do ii:=i;  //handled
     end;  //try
     Inc(j);
     until j>FromElm+Elms;
   Inc(i);
   until i>ToFNo;
   Screen.Cursor := crDefault;
   SomeList.SaveToFile('C:\test\Cantax-LOV.txt');
   Application.CreateForm(TPoplist,PopList);
   PopList.ShowModal;
   SomeList.Free; PopList.Release;
   *)
end;

procedure TRollCtxT2T2_2027.FixMarStatus(Valu: string);
//Function TRollCtxT2T2_2027.FixMarStatus(Valu:String):Integer;
var
  n: Integer;
begin
  (*
  n:=MyStrToInt(AllTrim(Valu));
  Case n of
    0:  Result:=11;
    1:  Result:=12;
    2:  Result:=13;
    3:  Result:=16;
    4:  Result:=17;
    5:  Result:=18;
   end;  {case}
 *)
end;

procedure TRollCtxT2T2_2027.FixAfterImport(RetNo: Integer);
var
  s: string;
  FNo: Integer;
  Fname: string;
begin

  FName := 'T2';
  FNo := GetFormNo(FName);
  if FNo > 0 then
  begin
    StoreElm(RetNo, FNo, 10, ReplaceChar(FetchElmFNo(RetNo, FNo, 10), '-', '/'));
    StoreElm(RetNo, FNo, 11, ReplaceChar(FetchElmFNo(RetNo, FNo, 11), '-', '/'));
  end;
end;

procedure TRollCtxT2T2_2027.BitBtn1Click(Sender: TObject);
begin
  ShowHelp('T1Help', 'Conversion_from_CanTax');
  {
  Application.HelpFile := AppDir+'\'+'T1Help.HLP';
  Application.HelpJump('Conversion_from_CanTax');
  }
end;

procedure TRollCtxT2T2_2027.CheckDateFormat;
var
  WinBootDir: string;
begin
  (*
   WinBootDir:=GetWinBootDir;
   If (UpperCase(GetWinIniString(WinBootDir+'\'+'Win.Ini','intl','sShortDate'))
       <> 'MM/DD/YYYY')
   then
    ShowMessage('For best rollover of BirthDates etc. the Date format in the Windows'+
      Chr(13)+'Control Panel should be MM/DD/YYYY'
      +Chr(13)+'See Control Panel -> Regional Settings -> Customize -> Date -> Short Date Format');
  *)
end;

procedure TRollCtxT2T2_2027.LinkToOptionsLblClick(Sender: TObject);
begin
  ExecuteForm(TOptionsFrmT2_2027);
  Close;
end;

procedure TRollCtxT2T2_2027.FixBusPercent(RetNo: Integer);
var
  i, FNo: Integer;
  x: Real;
  s, Fname: string;
  Inst: string;
begin
  (*
  For i:=1 to 9 do
  begin
       Inst:='#'+AllTrim(IntToStr(i));
       FName:='T2125_3'+Inst;
       FNo:=GetFormNo(FName);
       If FNo >0 then
       begin
        //ShowMessage('sp percent='+FetchElmFNo(RetNo,FNo,38));
        x:=vl(FetchElmFNo(RetNo,FNo,38))
        +vl(FetchElmFNo(RetNo,FNo,41))
        +vl(FetchElmFNo(RetNo,FNo,44))
        +vl(FetchElmFNo(RetNo,FNo,47))
        +vl(FetchElmFNo(RetNo,FNo,50));
        s:=FormatFloat('###.##',100-x);
        //ShowMessage(s);
        StoreElm(RetNo,GetFormNo('T2125_1'+Inst),18,s);
       end;
  end;
  *)
end;

procedure TRollCtxT2T2_2027.FileListBox1Change(Sender: TObject);
begin
  if FileListBox1.SelCount > 0 then
    OpenBtn.enabled := true
  else
    OpenBtn.enabled := false;
end;

procedure TRollCtxT2T2_2027.FileListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0; //prevent beep
    OpenBtnClick(nil);
  end;
end;

procedure TRollCtxT2T2_2027.SpCaptureCCALastYear(RetNo: Integer);
var
  i, rowndx, FNo: Integer;
begin
  (*
   FNo:=GetFormNo('CCALIST');
   InitFormData(RetNo,FNo);  //20090129
   For i:=1 to 171 do begin StoreElm(RetNo,FNo,i,'');end;  //init
   RowNdx:=1;
   //Other
   ExtractCCAList(RetNo,RowNdx,'T776_2',1,37,9);
   ExtractCCAList(RetNo,RowNdx,'T2125_4',1,71,10);
   ExtractCCAList(RetNo,RowNdx,'T2125_4',1,71,10);   //20090201
   ExtractCCAList(RetNo,RowNdx,'T2121_2',37,107,10);
   ExtractCCAList(RetNo,RowNdx,'T2042_4',1,71,10);
   ExtractCCAList(RetNo,RowNdx,'T1175_1',1,71,10);
   ExtractCCAList(RetNo,RowNdx,'T1175H_1',1,71,10);
 *)
end;

function TRollCtxT2T2_2027.GetEXPInfo(ValuName, ConvertedFlName: string): string;
var
  i: Integer;
  ConvList, WList: TStringList;
begin
  Result := '';
  ConvList := TStringList.Create;
  WList := TStringList.Create;

  ConvList.LoadFromFile(ConvertedFlName);
  for i := 0 to ConvList.Count - 1 do
  begin
    ParseWords(ConvList[i], '^', WList);
    if WList[0] = ValuName then
    begin
      ParseWords(ConvList[i], '^', WList);
      Result := LeftStr(AllTrim(RemoveChar(WList[4], ' ')), 9);
      Break;
    end;
  end;
  ConvList.Free;
  WList.Free;
end;

procedure TRollCtxT2T2_2027.Button1Click(Sender: TObject);
var
  s: string;
  FldName, FldType: string;
  Item: Variant;
  FNo, ElmNo: Integer;
  FldList, OutList: TStringList;
  i, j, ii, VisualInst, VisualIncr, FCount, TableRows, MaxVisualRowsPerInst: Integer;
  CanTaxFrmNm, VisualFrmNm, CanTaxTableNm, VisualFldDescr, CanTaxInstance: string;
  h: THandle;
begin
  //create list of fields captured in the program....

  fldlist := TStringList.Create;

  //S2_3 - Donations
  VisualFrmNm := 'S2'; //pg3
  VisualIncr := 5;
  j := 204; //fld in visualtax
  i := 31; //row in CanTax: start at second row due to increase in year
  repeat
    FldName := '006,' + AllTrim(IntToStr(i)) + 'R';
    //'T2S2[' + AllTrim(IntToStr(i))+']';
    FldList.add(FldName + '=don year^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := '006,' + AllTrim(IntToStr(i + 18)) + 'R';
    //'T2S2[' + AllTrim(IntToStr(i+50))+']';
    FldList.add(FldName + '=don end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));
    Inc(i);
    Inc(j, VisualIncr);
  until J > 229;

  //S2_3 - Gifts
  VisualFrmNm := 'S2'; //pg3
  VisualIncr := 5;
  j := 238; //fld in visualtax
  i := 31; //row in CanTax: start at second row due to increase in year
  repeat
    FldName := '006,' + AllTrim(IntToStr(i)) + 'R';
    //'T2S2[' + AllTrim(IntToStr(i))+']';
    FldList.add(FldName + '=gifts year^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := '006,' + AllTrim(IntToStr(i + 107)) + 'R';
    //'T2S2[' + AllTrim(IntToStr(i+50))+']';
    FldList.add(FldName + '=gifts end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));
    Inc(i);
    Inc(j, VisualIncr);
  until J > 263;

  //S2_3 - Cultural
  VisualFrmNm := 'S2'; //pg3
  VisualIncr := 5;
  j := 272; //fld in visualtax
  i := 31; //row in CanTax: start at second row due to increase in year
  repeat
    FldName := '006,' + AllTrim(IntToStr(i)) + 'R';
    //'T2S2[' + AllTrim(IntToStr(i))+']';
    FldList.add(FldName + '=cult year^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := '006,' + AllTrim(IntToStr(i + 131)) + 'R';
    //'T2S2[' + AllTrim(IntToStr(i+50))+']';
    FldList.add(FldName + '=cult end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));
    Inc(i);
    Inc(j, VisualIncr);
  until J > 297;

  //S2_3 - ecolog
  VisualFrmNm := 'S2'; //pg3
  VisualIncr := 5;
  j := 306; //fld in visualtax
  i := 31; //row in CanTax: start at second row due to increase in year
  repeat
    FldName := '006,' + AllTrim(IntToStr(i)) + 'R';
    //'T2S2[' + AllTrim(IntToStr(i))+']';
    FldList.add(FldName + '=ecol year^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := '006,' + AllTrim(IntToStr(i + 155)) + 'R';
    //'T2S2[' + AllTrim(IntToStr(i+50))+']';
    FldList.add(FldName + '=ecol end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));
    Inc(i);
    Inc(j, VisualIncr);
  until J > 331;

  //S8
  TableRows := 49;
  VisualInst := 1;
  VisualFrmNm := 'S8';
  VisualIncr := 16;
  MaxVisualRowsPerInst := 13;
  //CCA class
  j := 6; //cca fld in visualtax
  i := 1; //row -1 in CanTax table
  repeat
    //Fld name depends on row and column of table
    if i > MaxVisualRowsPerInst * VisualInst then
    begin j := 6;
      Inc(VisualInst);
    end; //new inst
    FldName := '011,' + AllTrim(IntToStr(i)) + 'R';
    FldList.add(FldName
      + '=CCA class^' + VisualFrmNm + '#' + IntToStr(VisualInst) + '^' + IntToStr(j));

    FldName := '011,' + AllTrim(IntToStr(i + 500)) + 'R';
    FldList.add(FldName +
      '=CCA UCC^' + VisualFrmNm + '#'
      + IntToStr(VisualInst) + '^' + IntToStr(j + 1));

    Inc(j, VisualIncr);
    Inc(i);
  until i > TableRows;

  //S8LH  {first}  //20260718
  //CanTaxFrmNm:='S8L';CanTaxTableNm:='T2S8LTable';
  TableRows := 15; {GetNumberOfTableRows(CanTaxFrmNm,CanTaxTableNm);}
  //VisualInst:=1; not multiple
 (*
  VisualFrmNm := 'S8LH';
  VisualIncr := 11;
  MaxVisualRowsPerInst := 12;
  //CCA class
  j := 1; //fld in visualtax
  i := 1; //row -1 in CanTax table
  repeat
    if i > MaxVisualRowsPerInst * VisualInst then
      break;

    FldName := '010,' + AllTrim(IntToStr(i)) + 'R'; //start date
    FldList.add(FldName
      + '=CCA-L start yr^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := '010,' + AllTrim(IntToStr(i + 15)) + 'R'; //end date
    FldList.add(FldName
      + '=CCA-L end yr^' + VisualFrmNm + '^' + IntToStr(j + 1));

    FldName := '010,' + AllTrim(IntToStr(i + 30)) + 'R'; //orig cost
    FldList.add(FldName +
      '=CCA-L orig cost^' + VisualFrmNm + '^' + IntToStr(j + 2));

    FldName := '010,' + AllTrim(IntToStr(i + 150)) + 'R'; //orig cost
    FldList.add(FldName +
      '=CCA-L ucc^' + VisualFrmNm + '^' + IntToStr(j + 3));

    Inc(j, VisualIncr);
    Inc(i);
    //end;
  until i >= TableRows; //needs 2 less
 *)
  //S9
  VisualFrmNm := 'S9';
  VisualIncr := 9;
  j := 4; //fld in visualtax
  i := 1; //cantax
  repeat
    //Fld name depends on row and column of table
    if J > 130 then
      Break;
    FldName := '034,' + AllTrim(IntToStr(i)) + 'S'; //name
    FldList.add(FldName + '=Shareholder^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := '034,' + AllTrim(IntToStr(i + 15)) + 'S';
    FldList.add(FldName + '=Country^' + VisualFrmNm + '^' + IntToStr(j + 1));

    FldName := '034,' + AllTrim(IntToStr(i + 30)) + 'S';
    FldList.add(FldName + '=Bus No^' + VisualFrmNm + '^' + IntToStr(j + 2));

    FldName := '034,' + AllTrim(IntToStr(i)) + 'B';
    FldList.add(FldName + '=Code^' + VisualFrmNm + '^' + IntToStr(j + 3));

    FldName := '034,' + AllTrim(IntToStr(i)) + 'R';
    FldList.add(FldName + '=Comm shares^' + VisualFrmNm + '^' + IntToStr(j + 4));

    FldName := '034,' + AllTrim(IntToStr(i + 15)) + 'R';
    FldList.add(FldName + '=Comm shares%^' + VisualFrmNm + '^' + IntToStr(j + 5));

    FldName := '034,' + AllTrim(IntToStr(i + 30)) + 'R';
    FldList.add(FldName + '=Pref shares^' + VisualFrmNm + '^' + IntToStr(j + 6));

    FldName := '034,' + AllTrim(IntToStr(i + 45)) + 'R';
    FldList.add(FldName + '=Pref shares%^' + VisualFrmNm + '^' + IntToStr(j + 7));

    FldName := '034,' + AllTrim(IntToStr(i + 60)) + 'R';
    FldList.add(FldName + '=Bk Val Cap stock^' + VisualFrmNm + '^' + IntToStr(j + 8));

    Inc(j, VisualIncr);
    Inc(i);
  until J >= 130;

  //S13-cap gains
  VisualFrmNm := 'S13';
  VisualIncr := 4;
  j := 4; //fld in visualtax
  i := 1; //row in CanTax: start at second row due to increase in year
  repeat
    FldName := '012,' + AllTrim(IntToStr(i)) + 'S'; //name
    FldList.add(FldName + '=descr^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := '012,' + AllTrim(IntToStr(i + 30)) + 'R'; //name
    FldList.add(FldName + '=end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));

    Inc(i);
    Inc(j, VisualIncr);
  until J > 24;

  //S13-other reserves
  VisualFrmNm := 'S13';
  VisualIncr := 3;
  j := 31; //fld in visualtax
  i := 135; //row in CanTax: start at second row due to increase in year
  repeat
    FldName := '012,' + AllTrim(IntToStr(i)) + 'R'; //name
    FldList.add(FldName + '=end bal^' + VisualFrmNm + '^' + IntToStr(j));
    Inc(i, 1);
    Inc(j, VisualIncr);
  until J > 49;

  //S50
  VisualFrmNm := 'S50';
  VisualIncr := 5;
  j := 4; //fld in visualtax
  i := 1; //CanTax table
  repeat
    //Fld name depends on row and column of table
    if J > 124 then
      Break;
    FldName := '149,' + AllTrim(IntToStr(i)) + 'S'; //name
    FldList.add(FldName + '=Shareholder^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := '149,' + AllTrim(IntToStr(i + 17)) + 'S';
    FldList.add(FldName + '=Bus No^' + VisualFrmNm + '^' + IntToStr(j + 1));

    FldName := '149,' + AllTrim(IntToStr(i + 34)) + 'S';
    FldList.add(FldName + '=sin^' + VisualFrmNm + '^' + IntToStr(j + 2));

    FldName := '149,' + AllTrim(IntToStr(i)) + 'R';
    FldList.add(FldName + '=Percent common^' + VisualFrmNm + '^' + IntToStr(j + 3));

    FldName := '149,' + AllTrim(IntToStr(i + 17)) + 'R';
    FldList.add(FldName + '=Percent pref^' + VisualFrmNm + '^' + IntToStr(j + 4));

    Inc(j, VisualIncr);
    Inc(i);
  until J >= 49; //cantax has less lines

  FldList.SaveToFile('C:\Delphi\T2WIP\TempDir\extrafldlist.d');

  {
    OutList:=TStringList.Create;

    For i:=0 to FldList.Count-1 do
    begin
     FldName:=GetCanTaxFldName(FldList[i]);
     If FldName>'' then
     begin
       Try
        s:=GetValue(FldName);
        OutList.add(FldList[i]+''+S);
       except
        ShowMessage('Error in FldList '+FldList[i]);
       end; //try
     end; //fldname
    end; //i
  }
end;

end.

