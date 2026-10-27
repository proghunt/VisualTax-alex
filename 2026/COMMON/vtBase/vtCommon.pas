unit vtCommon;

interface

uses
  SysUtils, Classes, Forms, Windows, Controls, ExtCtrls, Vcl.StdCtrls, Vcl.Graphics, //20190222 Igor
  vtMulti, vtForm, uADCompClient, System.Generics.Collections, System.IOUtils;//20171215 Igor  //20210203 Igor

const
  //box background color
  DarkShade = $00B4B4B4; //rgb(180,180,180);
  brightGreen = $0097FF97; //rgb(151,255,151
  LightGreen = $00D2FFFF; //$00A7FCE2; //$00C0FEEF; //$00DFFFBF;
  PinkishColor = $00AEAEFF; //$008080FF; //255,174,174 //rgb(255,128,128)
  BluishColor = $00FADDA0; //rgb (160,221,250)
  FirstRetColor = $00FFFFC3; //Rgb(195,255,255)
  //----
  MyBlue = $00AC7400;
  MyBlueGrey = $00E3DCCC;
  MyLightBlue = $00FFFFCA; //T2:$00FFFFE1; //$00FFFF80; //$00FFFFE1;
  MyBeige = $00C8D0D8;
  MyBronze = $A6CAF0;
  MyYellow = $00C5EEFE;
  MyLightYellow = $00DBFFFF;
  NoteColor = $00E7CFCF; //light haki
  TapeColor = clPurple; //$009098A8; //light brown //20220121 Igor
  PrintShade = $00ECECEC; //: TColor;  // = RGB(236,236,236);//RGB(230,230,230);  //20110119

  KeyWDelimiter1 {: String [1]} = '\';
  KeyWDelimiter2 {: String [1]} = '\';

  ProgramsAndPhonesDB = 'ProgrammsAndPhones.db';  //20180216 Igor
  HTTP_TimeOut = 5000; //20190513 Igor
  vtCourierIni = 'vtCourier.ini'; //20201026 Igor
  AFRStringDelimiter = '¦'; //20201126 Igor

type
  ErrLogMode = (
    elmFile,
    elmUser,
    elmBoth
    );

procedure ErrorMsg(const msg: string; mode: ErrLogMode = elmBoth);
procedure ExceptMsg(e: Exception);
procedure UserMsg(const msg: string);
procedure UndefMsg(const ProcName: string);
procedure NotImp(const ProcName: string);
procedure BugMsg(const msg: string; mode: ErrLogMode = elmBoth);

function ConnectToWeb(const Url: string): Boolean;
function ExecuteForm(AFormClass: TFormClass): TModalResult;

//production compatible
var
  GetCurrentRetNo: integer;
  //function  GetFormNo(RetNo: integer; FormName: string): integer; overload;
  //function  GetFormNo(RetNo: integer; FormName: string): integer;
function GetRetColor(RetNo: integer): integer;
function GetSourceDir(RetNo: Integer): string;
function GetFirstName(RetNo: integer): string;
function GetLastName(RetNo: integer): string;

function GetWindowsFontSize(FormHandle: HWND): Integer;
function GetWindowsUserName(var CurrentUserName: string): Boolean;
function GetWinBootDir: string;

//handling of dynamic data in virtual methods, common checks and error handling
function FetchElmFNo(RetNo, FNo, ElmNo: integer): string;
procedure StoreElmFNo(RetNo, FNo, ElmNo: integer; valu: string);
function FetchElm(RetNo: integer; FName: string; ElmNo: integer): string; overload;
procedure StoreElm(RetNo: integer; FName: string; ElmNo: integer; value: string); overload;
function FetchElm(RetNo, FNo, ElmNo: integer): string; overload;
procedure StoreElm(RetNo, FNo, ElmNo: integer; valu: string); overload;

function FetchMemoData(RetNo, FNo, ElmNo: integer): string; //20160421 Igor

procedure DeEnlistReturn(RetNo: integer);
function DeleteReturn(Dir, FlName: string): Boolean; //from Clients DB
function IsReturnOpen(RNo: Integer): Boolean;
function IsReturnLocked(RNo: integer): boolean;
procedure LockReturn(RNo: Integer);
procedure UnLockReturn(RNo: Integer);
function CountUnsavedReturns: Integer;

function OpenForm(RetNo, FormNo, FieldNo: integer): boolean; overload;
//multi-app
function OpenForm(RetNo: Integer; FName: string; FieldNo: integer): TvtForm; overload;
function OpenFormNo(RetNo, FormNo, FieldNo: integer): TvtForm;
function OpenTaxForm(RetNo: Integer; FName: string; MyChildStyle: TFormStyle; ParentForm: TWinControl): TvtForm;
function OpenFormAtPos(RetNo: Integer; FName: string; LblTop: integer): boolean;
//20170717 Igor >>>
function OpenForeignForm(const AApp: TApp; const ADir, AFile, AForm: String; const AElement: Integer): TFormData; overload;
function OpenForeignForm(const ADir, AFile, AForm: String; const AElement: Integer): TFormData; overload;
function OpenForeignForm(const ADir, AFile, AForm: String): TFormData; overload;
function OpenForeignForm(const AApp: TApp; const ADir, AFile, AForm: String): TFormData; overload;
function OpenForeignForm(const AAppName, ADir, AFile, AForm: String; const AElement: Integer): TFormData; overload;
function OpenForeignForm(const AAppName, ADir, AFile, AForm: String): TFormData; overload;
//20170717 Igro <<<
//20170719 Igro >>>
function GetForeignForm(const AApp: TApp; const ADir, AFile, AForm: String; const AOpenMode: TOpenMode = TOpenMode.omHidden): TFormData; overload;
function GetForeignForm(const AAppName, ADir, AFile, AForm: String; const AOpenMode: TOpenMode = TOpenMode.omHidden): TFormData; overload;
function GetForeignForm(const ADir, AFile, AForm: String; const AOpenMode: TOpenMode = TOpenMode.omHidden): TFormData; overload;
//20170719 Igro <<<

procedure OpenNextPage(RetNo: integer; FormName: string);
procedure OpenPrevPage(RetNo: integer; FormName: string);
function AddNewInstance(RetNo: integer; FormName: string): integer; //20171228 Igor
procedure DeleteInstance(RetNo: integer; FormName: string); //20180102 Igor
procedure OpenNextInstance(RetNo: integer; FormName: string);
procedure OpenPrevInstance(RetNo: integer; FormName: string);

procedure ShowFormData(RetNo: integer; FormName: string; FormNo: integer);
//better: OpenForm?
procedure MDIPaint(RetNo: integer); //replace WM_PAINT

function ReadAppFile(const FName: string; SomeList: TStrings; MyApp: TApp): boolean;
function ReadPgmFile(const FName: string; SomeList: TStrings; MyApp: TApp = nil): boolean;
function ReadAppFileLine(const FName: string; ALine: integer = 0; MyApp: TApp = nil): string;
function ReadPgmFileLine(const FName: string; ALine: integer = 0; MyApp: TApp = nil): string;

procedure WriteAppFile(const FName: string; SomeList: TStrings; MyApp: TApp);
procedure WritePgmFile(const FName: string; SomeList: TStrings; MyApp: TApp = nil);
procedure WriteAppFileLine(const FName, ALine: string; MyApp: TApp = nil);
procedure WritePgmFileLine(const FName, ALine: string; MyApp: TApp = nil);

procedure GetFileList(FDirectory, Filter: TFileName; SomeList: TStrings);
function GetInstalledAppDir(const AppName: string): string;
function IsFileEmpty(FileName: string): boolean;

function GetRegistryValue(RootName: HKEY; KeyName: string; KeyValueName: string): string;
function SetRegistryValue(RootName: HKEY; KeyName: string; KeyValueName: string; NewValue: string): Boolean;
function GetWinIniString(IniFileName: string; Sect: string; Ident: string): string;
procedure SetShortDateFormat;
procedure Delay(ms: Cardinal);
function ReturnFileExists(const AFileName: String): boolean;//20160415 Igor
function CountClientsRecordWithoutThisReturnFile(AApp: TApp; ADir, AFileName: String): Integer; //20170502 Igor
procedure UpdateSlipsCount(const ARetNo: Integer; const AConnection: TADConnection; const AFileName: String);//20171215 Igor
//20180216 Igor >>>
function GetPhoneByProgramNumber(AProgramNumber: integer; var APhone: string; var ADescription: string; ADelim: string = '; '): boolean;
function GetPhoneByProgramCode(AProgramCode: string; var APhone: string; var ADescription: string; ADelim: string = '; '): boolean;
//20180216 Igor <<<
function LoadResourceFontByName(const ResourceName : string; ResType: PChar; AClass: TClass) : Boolean; //20180307 Igor
function CheckIsCloud(ASilent: boolean = false): boolean; //20180503 Igor
procedure AdjustLabelHeight(ALabel: TLabel); //20190222 Igor

//20201224 Igor >>>
function TColorToWeb(AColor: TColor): string;
function WebToTColor(AColor: string): TColor;
//20201224 Igor <<<

//20210203 Igor >>>
procedure OpenTeamViewer(ATeamViewerId: string = '');
procedure OpenUltraViewer(AUltraViewerId: string = '');
//20210203 Igor <<<

function CalcTextHeight(AFont: TFont; AText: string; AWidth: integer): integer; //20210204 Igor

function GetInternalPhoneByProgramNumber(AProgramNumber: string; var APhone: string; var ADescription: string; ADelim: string = '; '): Boolean; //20260214 Igor

var
  InStartup: boolean = True; //hide bunch of messages
  MessageShowing: boolean; //true while ErrorMsg shown

implementation

uses Dialogs, ShellApi, Registry, IniFiles,
     vtChild, vtMain, //vtEditBox,
     //keep last
     vtTrimStr, vtShared
   , vtDataBase, DateUtils, //20171215 Igor
   fCaseDo, vtEditBox; //20170609 igor


(* Options - $DEFINE
debug: suppress startup error messages
noBugMsg: suppress VT error messages
fast: suppress all except UserMsg

Optimization=ON skips all empty subroutines!
*)

var
  DebugOff: boolean;

procedure AdjustLabelHeight(ALabel: TLabel); //20190222 Igor
var R: TRect;
    S: String;
begin
  if ALabel.AutoSize then
    ALabel.Autosize := false;
  R.Left := 0;
  R.Right := ALabel.Width;
  R.Top := 0;
  R.Bottom := 0;
  S := ALabel.Caption;

  ALabel.Canvas.TextRect(R, S, [tfCalcRect, tfWordBreak]);
  ALabel.Height := R.Bottom;
end;

function CheckIsCloud(ASilent: boolean = false): boolean; //20180503 Igor
begin
  Result := false;
  if StartParams.isCloud then
  begin
    if not ASilent then
      MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Result := true;
  end;
end;

function LoadResourceFontByName(const ResourceName : string; ResType: PChar; AClass: TClass) : Boolean; //20180307 Igor
var
  ResStream : TResourceStream;
  FontsCount : DWORD;
begin
  ResStream := TResourceStream.Create(FindClassHInstance(AClass), ResourceName, ResType);
  try
    Result := (AddFontMemResourceEx(ResStream.Memory, ResStream.Size, nil, @FontsCount) <> 0);
  finally
    ResStream.Free;
  end;
end;

procedure ErrorMsg(const msg: string; mode: ErrLogMode = elmBoth);
begin
{$IFDEF fast}
  //don't show/log anything
{$ELSE}
  if DebugOff then
    exit;
  if mode in [elmFile, elmBoth] then
    Errors.Log(msg);
  //if InStartup then exit; //hide message
  if mode in [elmUser, elmBoth] then
  begin
    MessageShowing := True;
    ShowMessage(msg); //log?
    MessageShowing := False;
  end;
{$ENDIF}
end;

procedure UserMsg(const msg: string);
begin
  //ErrorMsg(msg, elmUser); //log?
  MessageShowing := True;
  ShowMessage(msg); //log?
  MessageShowing := False;
end;

procedure BugMsg(const msg: string; mode: ErrLogMode = elmBoth);
begin
  EXIT; //20150527   STOP messages
  //show error in debug mode (set breakpoint here)
{$IFDEF noBugMsg}
  //nothing at all
{$ELSE}
{$IFDEF debug}
  ErrorMsg(msg); //show and log
{$ELSE}
  ErrorMsg(msg, elmFile); //log only
{$ENDIF}
{$ENDIF}
end;

procedure UndefMsg(const ProcName: string);
begin
{$IFDEF debug}
{$ELSE}
  ErrorMsg('Undefined Result: ' + ProcName);
{$ENDIF}
end;

procedure NotImp(const ProcName: string);
begin
  ErrorMsg('Implement: ' + ProcName);
end;

procedure ExceptMsg(e: Exception);
begin
  //set breakpoint here for debugging
  BugMsg('Unhandled exception: ' + e.Message);
  DebugBreak;
end;

function IsFileEmpty(FileName: string): boolean;
//function FileLength(FileName: string): integer;
var
  FindData: TWin32FindData;
  Handle: THandle;
begin
  (* True if file exists and is empty
    See SysUtils.FileAge
  *)
  Handle := FindFirstFile(PChar(FileName), FindData);
  Result := Handle <> INVALID_HANDLE_VALUE;
  if Result then
  begin
    Windows.FindClose(Handle);
    Result := (FindData.nFileSizeLow = 0) and (FindData.nFileSizeHigh = 0);
  end;
end;

function ExecuteForm(AFormClass: TFormClass): TModalResult;
var j: Integer;
begin
  with AFormClass.create(Application) do
  begin
    Screen.cursor := crDefault;
    //20160519 Igor >>>
    for J := 0 to ComponentCount - 1 do
    Begin
      if Components[j] is TPanel then
        (Components[j] as TPanel).ParentBackground := False;
    End;
    //20160519 Igor <<<
    Result := ShowModal;
    Free;
  end;
end;

function ConnectToWeb(const Url: string): Boolean;
var
  h: THandle;
begin
  Result := True;
  Screen.Cursor := crHourGlass;
  h := ShellExecute(Application.MainForm.Handle, 'open', Pchar('' + Url), nil, nil, Sw_Show);
  Screen.Cursor := crDefault;
  if H <= 32 then
  begin ShowMessage('Connection failed');
    Result := False;
  end;
end;

function GetFormNo(RetNo: integer; FormName: string): integer;
begin
  //test: overloads okay?
  Result := RetList[RetNo].GetFormNo(FormName);
end;

function GetSourceDir(RetNo: Integer): string;
//Function TCoupleT1_2012.GetSourceDir(RetNo:Integer):String;
begin
  Result := RetList[RetNo].SourceDataDir; //OptRec.Dir_Cur;
end;

function GetRetColor(RetNo: integer): integer;
begin
  (* Beware: this function can have 2 meanings:
    - init return color <--- must be explicitly in constructor
    - current return color
  *)
  Result := RetList[RetNo].RetColor;
end;

function GetFirstName(RetNo: integer): string;
begin
  Result := RetList[RetNo].GetFirstName; //20160125 Igor
end;

function GetLastName(RetNo: integer): string;
begin
  Result := RetList[RetNo].GetLastName; //20160125 Igor
end;

procedure StoreElmFNo(RetNo, FNo, ElmNo: integer; valu: string);
begin
  RetList[RetNo].Frm[FNo].Elms[ElmNo] := valu;
  //20161028 Igor >>>
  if valu <> '' then
  begin
    if (ElmNo = RetList[RetNo].MyApp.PswElm) AND (GetFormNo(RetNo, 'STATUS') = FNo) then
    begin
      if not assigned(screen.ActiveForm) or
         (pos(LowerCase('SetFilePsw'), LowerCase(screen.ActiveForm.ClassName)) = 0) then
      begin
        MessageDlg('Warning! Write return password without SetPassword Form. contact developer.', mtWarning,[mbOk], 0);
      end;
    end;
  end;
  //20161028 Igor <<<
end;

function FetchElm(RetNo, FNo, ElmNo: integer): string;
begin
  (* use virtual method for handling dynamic data
  *)
  if (FNo < 1)
    or (RetNo < 1)
    or (RetList[RetNo].Frm[FNo].Count <= ElmNo) then
    result := ''
  else
    Result := RetList[RetNo].Frm[FNo].Elms[ElmNo];
  //or: Result := RetList[RetNo].FetchElmFNo(FNo,ElmNo);
end;

function FetchMemoData(RetNo, FNo, ElmNo: integer): string; //20160421 Igor
Begin
  if (FNo < 1) or (RetNo < 1) or (length(RetList[RetNo].Frm[FNo].Memos) <= ElmNo) then
    result := ''
  else
    Result := RetList[RetNo].Frm[FNo].Memos[ElmNo];
End;

procedure StoreElm(RetNo, FNo, ElmNo: integer; valu: string);
var
  FRec: TFRec;
  MyRet: TRetData;
  MyForm: TFormData;
  //20170609 igor >>>
  ovr: TOverRec;
  sb: TvtScrollBox;
  Ed: TComponent;
  //20170609 igor <<<
begin
 if RetNo=0 then Exit;   //20160811  //con

  (* called by LoadReturn
  *)
  MyRet := RetList[RetNo];
  MyForm := MyRet.Frm[FNo];
  if MyForm = nil then
  begin
    //if FNo > 0 then - create form/instance?
    BugMsg('no such form: ' + IntToStr(FNo));
    exit; //???check calling code!
  end;

  if ElmNo > ArrayMul then //20170609 Igor
  begin
    //dynamic, handle in Elms[]?
  end
  else if ElmNo >= MyForm.Count then
  begin
    if valu = '' then
      exit; //ignore empty field
    //silent diagnostics
      //BugMsg(Format('%s StoreElm %s Elm=%d > %d',[myRet.MyApp.AppId, GetRetFormName(RetNo,FNo), ElmNo, MyForm.Count-1]),elmFile);  //t0150527
    //remember excess field
    FRec := MyRet.MyApp.FList.ByFormNoNil(FNo);
    FRec.FormFields := ElmNo;
    if ElmNo >= MyForm.Capacity then
      MyForm.Capacity := ElmNo + 10;
    repeat
      MyForm.Add('');
    until MyForm.Count > ElmNo;
  end;
  //20170609 Igor >>>
  // Check overrides
  if not (asLoadReturn in ApplicationState) then
    ovr := OverList.OvrOn(MyForm.RetNo, MyForm.FormNo, ElmNo)
  else
    ovr := nil;
  //20210423 Igor >>>
  if Assigned(ovr) then
  begin
    sb := RetList[MyForm.RetNo].MyChild.GetScrollbox(MyForm.FormNo);
    if Assigned(sb) then
    begin
      Ed := sb.FindComponent('vtEdit' + ElmNo.ToString);
      if Assigned(Ed) AND (Ed is TvtEdit) then
        sb.ToggleOverride(TvtEdit(Ed))
      else
        RemoveFieldOverride(MyForm.RetNo, MyForm.FormNo, ElmNo);
    end
    else
      RemoveFieldOverride(MyForm.RetNo, MyForm.FormNo, ElmNo);
    MyForm.Elms[ElmNo] := valu;
    {
    CaseDo(Format('While updating the data on the form, the program encountered the following situation:'+ #13 +
      'Element #%d on form "%s" is overridden!', [ElmNo, MyForm.FormDataRec.FormName]),
      ['Save the new value <' + valu + '> as normal and RESET override <' + ovr.Value + '>. (Recomended)',
       'Save the new value <' + valu + '> as normal and LEAVE override <' + ovr.Value + '>.',
       'Save the new value <' + valu + '> as override. (Not recommended)'],
      function(const ACaseID: Integer): Boolean
      begin
        Result := True;
        case ACaseID of
          0:
            begin
              sb := RetList[MyForm.RetNo].MyChild.GetScrollbox(MyForm.FormNo);
              if Assigned(sb) then
              begin
                Ed := sb.FindComponent('vtEdit' + ElmNo.ToString);
                if Assigned(Ed) AND (Ed is TvtEdit) then
                  sb.ToggleOverride(TvtEdit(Ed))
                else
                  RemoveFieldOverride(MyForm.RetNo, MyForm.FormNo, ElmNo);
              end
              else
                RemoveFieldOverride(MyForm.RetNo, MyForm.FormNo, ElmNo);
              MyForm.Elms[ElmNo] := valu;
            end;
          1:
            begin
              MyForm.DisableSaveOverride;
              try
                MyForm.Elms[ElmNo] := valu;
              finally
                MyForm.EnableSaveOverride;
              end;
            end;
          2:
            MyForm.Elms[ElmNo] := valu;
        end;
      end)
    }
  end
  //20210423 Igor <<<
  else
  //20170609 Igor <<<
    MyForm.Elms[ElmNo] := valu;
end;

function FetchElm(RetNo: integer; FName: string; ElmNo: integer): string;
var
  FNo: integer;
begin
  Result := '';
  if (RetNo < 1)
    or (FName = '') then
    exit;
{$IFDEF debug}
  FNo := RetList[RetNo].MyApp.FList.GetFormNo(FName, False);
  if FNo < 1 then
    exit; //else too many messages :-(
{$ELSE}
{$ENDIF}
  Result := FetchElmFNo(RetNo, GetFormNo(RetNo, FName), ElmNo);
end;

function FetchElmFNo(RetNo, FNo, ElmNo: integer): string;
begin
  (* use virtual method for handling dynamic data - don't check ElmNo!
  *)
  result := '';
  if (FNo < 1)
    or (RetNo < 1) then
    exit;
  //20160710 Igor
  if not assigned(RetList[RetNo]) or
     not Assigned(RetList[RetNo].Frm[FNo]) then exit;


  Result := RetList[RetNo].Frm[FNo].Elms[ElmNo];
  //or: Result := RetList[RetNo].FetchElmFNo(FNo,ElmNo);
end;

procedure StoreElm(RetNo: integer; FName: string; ElmNo: integer; value: string);
begin
  StoreElmFNo(RetNo, GetFormNo(RetNo, FName), ElmNo, value);
end;

procedure DeEnlistReturn(RetNo: integer);
begin
  (* after all app-specific links have been broken: destroy the return
  *)
  if RetList[RetNo].Destroying then
    exit; //no recursive calls allowed!
  RetList.RemoveReturn(RetNo);
end;

function DeleteReturn(Dir, FlName: string): Boolean;
var
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  Result := False;
  if FileExists(Dir + '\' + FlName) then
    SysUtils.DeleteFile(Dir + '\' + FlName);

  //20150922 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, Dir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name');

  Table1.Open;
  if Table1.FindKey([FlName]) = True then
  begin
    Table1.Edit;
    Table1.Delete;
    Result := True;
  end;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;

function IsReturnOpen(RNo: Integer): Boolean;
begin
  Result := (RetList[RNo] <> nil) and not RetList[RNo].Destroying;
end;

function IsReturnLocked(RNo: integer): boolean;
begin
  Result := (RetList[RNo] = nil) or RetList[RNo].Locked;
end;

procedure LockReturn(RNo: Integer);
begin
  RetList[RNo].Locked := True;
end;

procedure UnLockReturn(RNo: Integer);
begin
  RetList[RNo].Locked := False;
end;

function ReadPgmFile(const FName: string; SomeList: TStrings; MyApp: TApp = nil): boolean;
var
  FileName: string;
begin
  (* Load SomeList from file.
    If fname does not contain an drive specifier, assume file in ExeDir.
  *)
  FileName := FName;
  if Pos(':', FileName) < 2 then
    FileName := ExeDir + '\' + FileName;
  Result := FileExists(FileName);
  if SomeList = nil then
    exit; //only check for file exists
  if Result then
    SomeList.LoadFromFile(FileName)
  else
    SomeList.Clear;
end;

procedure WritePgmFile(const FName: string; SomeList: TStrings; MyApp: TApp);
var
  FileName: string;
begin
  FileName := FName;
  if Pos(':', FileName) < 2 then
    FileName := ExeDir + '\' + FileName;
  SomeList.SaveToFile(FileName);
end;

function GuessAppDir(MyApp: TApp): string;
begin
  if MyApp = nil then
    MyApp := CurrentApp;
  Result := MyApp.AppDir;
end;

procedure WriteAppFile(const FName: string; SomeList: TStrings; MyApp: TApp);
begin
  WritePgmFile(GuessAppDir(MyApp) + '\' + FName, SomeList, MyApp);
end;

function ReadAppFile(const FName: string; SomeList: TStrings; MyApp: TApp): boolean;
begin
  //Result := ReadPgmFile(MyApp.AppDir + '\' + FName);
  Result := ReadPgmFile(GuessAppDir(MyApp) + '\' + FName, SomeList);
end;

function ReadPgmFileLine(const FName: string; ALine: integer = 0; MyApp: TApp = nil): string;
var
  TempList: TStringList;
  FileName: string;
begin
  (* Read a line from an data file.
  *)
  result := '';
  FileName := FName;
  //if MakeAbsolute then
  if Pos(':', FileName) < 2 then
    FileName := ExeDir + '\' + FileName;
  if FileExists(FileName) then
  begin
    TempList := TstringList.Create;
    TempList.LoadFromFile(FileName);
    if ALine < TempList.Count then
      Result := TempList[ALine];
    TempList.Free;
  end;
end;

function ReadAppFileLine(const FName: string; ALine: integer; MyApp: TApp): string;
var
  FileName: string;
begin
  (* Read a line from an app-specific file.
  *)
  FileName := GuessAppDir(MyApp);
  FileName := FileName + '\' + FName;
  Result := ReadPgmFileLine(FileName, ALine);
end;

procedure WritePgmFileLine(const FName, ALine: string; MyApp: TApp);
var
  FileName: string;
  TempList: TStringList;
begin
  FileName := FName;
  //if MakeAbsolute then
  if Pos(':', FileName) < 2 then
    FileName := ExeDir + '\' + FileName;
  TempList := TStringList.Create;
  if FileExists(FileName) then
    TempList.LoadFromFile(FileName);
  if TempList.Count > 0 then
    TempList[0] := ALine
  else
    TempList.Add(ALine);
  TempList.SaveToFile(FileName);
  TempList.Free;
end;

procedure WriteAppFileLine(const FName, ALine: string; MyApp: TApp);
var
  FileName: string;
begin
  FileName := GuessAppDir(MyApp);
  WritePgmFileLine(FileName, ALine, MyApp);
end;

procedure GetFileList(FDirectory, Filter: TFileName; SomeList: TStrings);
var
  ARec: TSearchRec;
  Res: Integer;
begin
  SomeList.Clear;
  if FDirectory[Length(FDirectory)] <> '\' then
    FDirectory := FDirectory + '\';
  Res := FindFirst(FDirectory + Filter, faAnyFile, ARec);
  while Res = 0 do
  begin
    //if FileExists(FDirectory + ARec.Name) then
    if not(((ARec.Attr and faDirectory)=faDirectory) and ((ARec.Name='.')or(ARec.Name='..'))) then //20160602 Igor
      SomeList.Add(FDirectory + ARec.Name);
    Res := FindNext(ARec);
  end;
  SysUtils.FindClose(ARec);
end;

function GetWinIniString(IniFileName: string; Sect: string; Ident: string): string;
var
  SomeIniFile: TIniFile;
begin
  SomeIniFile := TIniFile.Create(IniFileName);
  Result := SomeIniFile.ReadString(Sect, Ident, 'Not Found');
  SomeIniFile.Free;
end;

procedure WriteWinIniString(IniFileName: string; Sect: string; Ident: string; Val: string);
var
  SomeIniFile: TIniFile;
begin
  SomeIniFile := TIniFile.Create(IniFileName);
  SomeIniFile.WriteString(Sect, Ident, Val);
  SomeIniFile.Free;
end;

function GetRegistryValue(RootName: HKEY; KeyName: string; KeyValueName: string): string;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;

  Registry.RootKey := RootName; //HKEY_LOCAL_MACHINE;
  {False because we do not want to create it if it doesn’t exist}
  if Registry.OpenKey(KeyName, False) = True then
    Result := Registry.ReadString(KeyValueName)
  else
  begin
    {ShowMessage('Cannot find it '+KeyName);}
    result := '';
  end;
  Registry.Free;
end;

function SetRegistryValue(RootName: HKEY; KeyName: string; KeyValueName: string; NewValue: string): Boolean;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;

  Registry.RootKey := RootName; //HKEY_LOCAL_MACHINE;
  {False because we do not want to create it if it doesn’t exist}
  if Registry.OpenKey(KeyName, False) = True then
  begin Registry.WriteString(KeyValueName, NewValue);
    Result := True;
  end
  else
  begin
    {ShowMessage('Cannot find it '+KeyName);}
    result := False;
  end;
  Registry.Free;
end;

function GetWinBootDir: string;
begin
  Result := '';
  result := GetRegistryValue(HKEY_LOCAL_MACHINE,
    '\SOFTWARE\Microsoft\Windows\CurrentVersion', 'SystemRoot');
  if result = '' then
  begin
    try
      if GetRegistryValue(HKEY_LOCAL_MACHINE,
        '\SOFTWARE\Microsoft\Windows NT\CurrentVersion',
        'SystemRoot') > '' then
        result := GetRegistryValue(HKEY_LOCAL_MACHINE,
          '\SOFTWARE\Microsoft\Windows NT\CurrentVersion', 'SystemRoot')
    except on e: Exception do
        ExceptMsg(e);
    end; {except}
  end;
end;

function GetWindowsFontSize(FormHandle: HWND): Integer;
var
  DC: hDC;
begin
  (* wrong name: really get screen horizontal resolution
  *)
  DC := GetDC(FormHandle);
  Result := GetDeviceCaps(DC, LOGPIXELSX);
  ReleaseDC(FormHandle, DC);
end;

function GetWindowsUserName(var CurrentUserName: string): Boolean;
var
  BufferSize: DWORD;
  pUser: PChar;
begin
  BufferSize := 0;
  GetUserName(nil, BufferSize);
  pUser := StrAlloc(BufferSize);
  try
    Result := GetUserName(pUser, BufferSize);
    CurrentUserName := StrPas(pUser);
  finally
    StrDispose(pUser);
  end;
end;

//20170728 Igor>>>
//function MMDDYYYYToWinFormat(Dt: string): string;
//var
//  WinDateFormat: string;
//  Sep: string;//[1]; //20150701
//  WinBootDir: string;
//begin
//  Result := Dt;
//  WinBootDir := GetWinBootDir;
//  WinDateFormat := UpperCase(
//    GetWinIniString(WinBootDir + '\' + 'Win.Ini', 'intl', 'sShortDate'));
//  Sep := UpperCase(
//    GetWinIniString(WinBootDir + '\' + 'Win.Ini', 'intl', 'sDate'));
//
//  if LeftStr(WinDateFormat, 1) = 'M' then {to MMDDYY}
//  begin
//    Result := Dt;
//    exit;
//  end
//  else if LeftStr(WinDateFormat, 1) = 'D' then {to DDMMYY}
//  begin
//    Result := MidStr(Dt, 4, 2) + Sep + LeftStr(Dt, 2) + Sep + RightStr(Dt, 4);
//  end
//  else if LeftStr(WinDateFormat, 1) = 'Y' then {to YYMMDD}
//  begin
//    Result := RightStr(Dt, 4) + Sep + LeftStr(Dt, 2) + Sep + MidStr(Dt, 4, 2);
//  end;
//end;

//function YYYYMMDDToWinFormat(Dt: string): string;
//var
//  WinDateFormat: string;
//  Sep: string;//[1]; //20150701
//  WinBootDir: string;
//begin
//  Result := Dt;
//  WinBootDir := GetWinBootDir;
//  WinDateFormat := UpperCase(
//    GetWinIniString(WinBootDir + '\' + 'Win.Ini', 'intl', 'sShortDate'));
//  Sep := UpperCase(
//    GetWinIniString(WinBootDir + '\' + 'Win.Ini', 'intl', 'sDate'));
//
//  if LeftStr(WinDateFormat, 1) = 'M' then {to MMDDYYYY}
//  begin
//    Result := MidStr(Dt, 6, 2) + Sep + RightStr(Dt, 2) + Sep + LeftStr(Dt, 4); //MidStr(Dt,3,2); //20100131
//  end
//  else if LeftStr(WinDateFormat, 1) = 'D' then {to DDMMYYYY}
//  begin
//    Result := RightStr(Dt, 2) + Sep + MidStr(Dt, 6, 2) + Sep + LeftStr(Dt, 4); //MidStr(Dt,3,2); //20100131
//  end
//  else if LeftStr(WinDateFormat, 1) = 'Y' then {to YYYYMMDD}
//  begin
//    Result := LeftStr(Dt, 4) + Sep + MidStr(Dt, 6, 2) + Sep + RightStr(Dt, 2); //20100131
//    //MidStr(Dt,3,2)+Sep+MidStr(Dt,6,2)+Sep+RightStr(Dt,2);
//  end;
//end;
//20170728 Igor<<<

function OpenForm(RetNo: Integer; FName: string; FieldNo: integer): TvtForm; overload; //20170504 Igor
var
  cmp: TComponent;
begin
  ApplicationState := ApplicationState + [asOpenForm];
  try
    cmp := Nil;
    if FName = '' then
      FName := RetList[RetNo].MyApp.FirstForm;
    Result := OpenTaxForm(RetNo, FName, fsmdichild, nil);
    if (Result = nil) then
      exit;
    GetChildWin(RetNo).BringToFront;
    MainForm.GuiCommand(gcActiveFormChange);
    if (FieldNo = 0) then
      FieldNo := RetList[RetNo].GetFormCursorPos(FName);
  finally
    ApplicationState := ApplicationState - [asOpenForm];
    MainForm.GuiCommand(gcUpdateLastYearIfOpenned);
    if FieldNo <> 0 then
      cmp := Result.FindComponent('vtEdit' + IntToStr(FieldNo));
    if Assigned(cmp) AND (cmp is TWinControl) then
      Result.ActiveControl := cmp.Name;
  end;
end;

//20170717 Igor >>>
function OpenForeignForm(const AApp: TApp; const ADir, AFile, AForm: String; const AElement: Integer): TFormData;
begin
  Assert(Assigned(AApp));
  Result := AApp.OpenForeignForm(ADir, AFile, AForm, AElement);
end;

function OpenForeignForm(const ADir, AFile, AForm: String; const AElement: Integer): TFormData;
begin
  Result := OpenForeignForm(CurrentApp, ADir, AFile, AForm, AElement);
end;

function OpenForeignForm(const ADir, AFile, AForm: String): TFormData;
begin
  Result := OpenForeignForm(CurrentApp, ADir, AFile, AForm, 0);
end;

function OpenForeignForm(const AApp: TApp; const ADir, AFile, AForm: String): TFormData;
begin
  Result := OpenForeignForm(AApp, ADir, AFile, AForm, 0);
end;

function OpenForeignForm(const AAppName, ADir, AFile, AForm: String; const AElement: Integer): TFormData;
begin
  Result := OpenForeignForm(AppList.AppFromName(AAppName), ADir, AFile, AForm, AElement);
end;

function OpenForeignForm(const AAppName, ADir, AFile, AForm: String): TFormData;
begin
  Result := OpenForeignForm(AppList.AppFromName(AAppName), ADir, AFile, AForm, 0);
end;
//20170717 Igro <<<

//20170719 Igro >>>
function GetForeignForm(const AApp: TApp; const ADir, AFile, AForm: String;
  const AOpenMode: TOpenMode = TOpenMode.omHidden): TFormData; overload;
begin
  Assert(Assigned(AApp));
  Result := AApp.GetForeignForm(ADir, AFile, AForm, AOpenMode);
end;

function GetForeignForm(const AAppName, ADir, AFile, AForm: String;
  const AOpenMode: TOpenMode = TOpenMode.omHidden): TFormData; overload;
begin
  Result := GetForeignForm(AppList.AppFromName(AAppName), ADir, AFile, AForm, AOpenMode);
end;

function GetForeignForm(const ADir, AFile, AForm: String;
  const AOpenMode: TOpenMode = TOpenMode.omHidden): TFormData; overload;
begin
  Result := GetForeignForm(CurrentApp, ADir, AFile, AForm, AOpenMode);
end;
//20170719 Igro <<<


function OpenForm(RetNo, FormNo, FieldNo: integer): boolean; overload;
begin
  (* This declaration corresponds to the ChildWinNew.OpenForm
  *)
  Result := OpenForm(RetNo, getRetformname(RetNo, FormNo), FieldNo) <> nil;
end;

function OpenFormNo(RetNo, FormNo, FieldNo: integer): TvtForm;
begin
  Result := OpenForm(RetNo, getRetformname(RetNo, FormNo), FieldNo);
end;

function OpenFormAtPos(RetNo: Integer; FName: string; LblTop: integer): boolean;
var
  i: integer;
  cmp: TComponent;
  wc: TWinControl absolute cmp;
  ClosestCtl: TWinControl;
  f: TvtForm;
begin
  f := OpenForm(RetNo, FName, 0);
  Result := f <> nil;
  if not Result then
    exit; //no such form?
  //find closest editbox or other control that can receive the focus
  ClosestCtl := nil;
  if f is TvtScrollBox then
    LblTop := (LblTop * TvtScrollBox(f).MyZoom) div 100; //scaled position
  for i := 0 to f.ComponentCount - 1 do
  begin
    cmp := f.Components[i];
    if not (cmp is TWinControl) then
      continue; //cannot receive focus
    if not wc.TabStop then
      continue; //cannot receive focus
    if (wc.Top < LblTop) then
      continue; //before specified position
    if (ClosestCtl <> nil) then
    begin
      if (ClosestCtl.Top < wc.Top) then
        continue; //worse choice
      if (ClosestCtl.Top = wc.Top) and (ClosestCtl.Left < wc.Left) then
        continue;
    end;
    ClosestCtl := wc; //best choice
  end;
  f.VertScrollBar.Position := LblTop; //scroll to position
  if ClosestCtl <> nil then
    ClosestCtl.SetFocus; //move to control
end;

procedure myTime(old:TDateTime);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     Present:=Now - old;
     DecodeTime(Present, Hour, Min, Sec, MSec);
     ShowMessage(IntToStr(Min) + ':' +  IntToStr(Sec) + ':' + IntToStr(MSec));
end;


function OpenTaxForm(RetNo: Integer; FName: string; MyChildStyle: TFormStyle; ParentForm: TWinControl): TvtForm;
var
  DfmName: string;
  MyChild: TMyChild;
  TestBox,
    MyScrollBox: TvtScrollBox; // TvtForm;
  FNo: integer;
  MyImage: TImage;
  old:TDateTime;
  tmpForm: TMyChild; // 20151029 Igor: Bug:PgUp/PgDn -> need SetFocus
  fIsNewReturn:Boolean;       //20151030 Igor - Bug: Flickering problem
  oldWidth,oldHeight, I: Integer; //20151030 Igor - Bug: Flickering problem
begin
  (* Detect following cases:
    new MDIForm (for RetNo)
    new scrollbox (tax form) in MDIChild:RetNo - create if required?
    independent tax form, in ParentForm

    Perform checks before/after opening the form.
    Every open return must have an MDIChild!
  *)
  MyScrollBox := nil;
  Result := nil; //in case of errors
  if RetNo < 1 then
    exit; //may occur during return destruction
  try //finally: RetNoChanged
    //MDIChild - get or create MDIChild for RetNo
    MyChild := CreateNewMDIChild(RetNo, FName); // 'R' + IntToStr(RetNo));
    //20151030 Igor - Bug: Flickering problem
    fIsNewReturn:= RetList[RetNo].MyChild = nil;
    if fIsNewReturn then
    begin
          oldWidth:=Mychild.Width;
          oldHeight:=Mychild.Height;
          Mychild.Width :=1;
          Mychild.Height:=1;
    end;

    FNo := GetFormNo(RetNo, FName);
    //FName:=GetFormName(FNo);
    DfmName := RetList[RetNo].BeforeOpenForm(FName, FNo);
    if DfmName = '' then
      exit; //open denied
    if not FileExists(DfmName) then
    begin
      ShowMessage('Form ' + DfmName + ' was not found');
      Exit;
    end;

    //allow to fail!
    if Application.MainForm.ActiveMDIChild = nil then
      TestBox := nil
    else
      TestBox := GetActiveForm;

    //try use existing MDIChild
    if MyChildStyle = fsMDIChild then
    begin
      //check for already existing child
      Result := MyChild.GetForm(FNo, True);

      //save currently active
      if TestBox = Result then
      begin
        TestBox := nil; //debug
      end
      else
        SaveSwitchForms(testbox); //should NOT be the new form!

      if Result <> nil then
      //20161128 Igor >>>
      begin
        TvtScrollBox(Result).Activated(True);
        exit; //form does already exist
      end;
      //20161128 Igor <<<
      //add tabsheet?
      ParentForm := MyChild.CreateNewTab(FNo, FName);
    end
    else
    begin
      //..if fIsNewReturn = false then exit; //20151103 Igor: Need tested this exit
      //stand-alone form
      //check for already existing child
      Result := RemoveFormsExcept(ParentForm, RetNo, FNo);
      if Result <> nil then
      //20161128 Igor >>>
      begin
        TvtScrollBox(Result).Activated(True);
        exit; //form already shown
      end;
      //20161128 Igor <<<
    end;
    MyScrollBox := MyChild.CreateForm(ParentForm, FNo); //owner must be ParentForm
    MyScrollBox.isAppendix := MyChildStyle <> fsMDIChild; //20161129 Igor
    MyScrollBox.RetNo := RetNo; //20160314 Igor
    MyScrollBox.Visible:=False;//20151030 Igor
    //MyImage := AddImageCanvas(MyChild,MyScrollBox); - works
    try
      ReadComponentResFile(DfmName, myScrollBox);
      //MyScrollBox.Rescale(MainOptions.FormZoom, DfmName); //create properly scaled
      MyScrollBox.AfterOpenForm; //after controls have been created!
{$IFDEF old}
      MyScrollBox.FormName := UpperCase(FName);
{$ELSE}
{$ENDIF}
      //show or hide the title bar?
      if MyChildStyle = fsMDIChild then
      begin
        //MyScrollBox.BorderStyle := bsNone //hides title bar
        //MyImage := AddImageCanvas(MyChild,MyScrollBox);
      end
      else
      begin
        //MyScrollBox.BorderStyle := bsSizeable; //shows title bar
        FloatingForms.RegisterForm(MyScrollBox, False); //mark floating, read-only
      end;
      //MyScrollBox.Color := RetList[RetNo].RetColor; -> in Activated

      //InitFormData(RetNo, FNo); //required?
      CalcNo(RetNo, FNo); //does first InitFormData

      //CalcFullReturn(RetNo); //propagate into all other forms
      MyScrollBox.Activated(True); //PopulateFormWithData(MyScrollBox);
      //MyScrollBox.ShowFormData;
      //MyScrollBox.Init;
      MyScrollBox.Visible := True; //required! //20160711 Igor
      MyScrollBox.RestoreControlTop; //20210319 Igor
      if WindowLocks > 0 then //20160220 Igor
      Begin
        WindowLocks := 0;
        Windows.LockWindowUpdate(0);
      End;
//      MyScrollBox.Visible := True; //required! //20160711 Igor
{$IFDEF old}
      if MyChildStyle = fsMDIChild then
      begin
        //FormNoChanged(MyScrollBox);
        //MyScrollBox.BoxResize(nil); //why not always???
        UpdateChildTaxPanel(RetNo);
      end;
{$ELSE}
      //in Activated
{$ENDIF}
      Result := MyScrollBox; //the caller expects a tax form
      if MyChildStyle = fsMDIChild then
      begin
        { TODO : set focus on first field }
        if MyScrollBox.CanFocus then //20170130 igor
          MyScrollBox.SetFocus; //always focus MDI (input) forms
      end;

      //AppCommand(acUpdateDiagnostics,RetNo); //RetNoChanged
    except
      on e: Exception do
        BugMsg('OpenForm: ' + e.Message);
    end;
  finally
    RetNoChanged(RetNo);
    // 20151029 Igor: Bug:PgUp/PgDn -> need SetFocus
    tmpForm:=GetChildWin(RetNo);
    if tmpForm.MyPageControl.Visible then //20170130 igor
    begin
      //20170512 Igor >>>
      if (Screen.ActiveControl = nil) or not tmpForm.ContainsControl(Screen.ActiveControl)  then
      begin
        tmpForm.ActiveControl:=tmpForm.MyPageControl.ActivePage;// 20151031 Igor
        tmpForm.ActiveControl:=tmpForm.MyPageControl;
      end;
      //20170512 igor <<<
    end;
    tmpForm.BringToFront; //20160209 Igor


    //20151030 Igor
    if fIsNewReturn then
    begin
         Mychild.Width:=oldWidth;
         Mychild.Height:=oldHeight;
    end;
  end;
end;

function AddNewInstance(RetNo: integer; FormName: string): integer; //20171228 Igor
var
  CInst, NewFNo: integer;
  NewFormName: string;
begin
  Result := 0;
  if RetList[RetNo].FList.ByFormName(ExtractFormRootName(FormName)).InstNo = 0 then
  begin
    UserMsg(FormName + ' is not a multi instance form');
    exit;
  end;

  FormName := ExtractFormRootName(FormName);

  CInst := 1;
  NewFNo := 0;
  while True do
  begin
    NewFormName := ExtractNonInstFormName(FormName) + '#' + IntToStr(CInst);
    NewFNo := GetFormNo(RetNo, NewFormName);
    if (NewFNo = 0) or not RetList[RetNo].FrmHasData[NewFNo] then
      break;
    inc(CInst);
  end;

  if NewFNo = 0 then {instance does not exist}
  begin
{$IFDEF paged}
    if IsFormMultipage(FormName) then {do all pages}
    begin
      AddPageInstance(ExtractFormRootName(FormName) + '_1',
        '#' + IntToStr(CInst));
      AddOtherPagesInstance(ExtractFormRootName(FormName) + '_1',
        '#' + IntToStr(CInst));
      NewFNo := GetFormNo(RetNo,
        ExtractFormRootName(FormName) + '_1' +
        '#' + IntToStr(CInst));
    end
    else
{$ELSE}
    NewFNo := RetList[RetNo].AddPageInstance(ExtractNonInstFormName(FormName),
      '#' + IntToStr(CInst));
{$ENDIF}
  end;
  OpenForm(RetNo, NewFNo, 0);
  Result := NewFNo;
end;

procedure DeleteInstance(RetNo: integer; FormName: string); //20180102 Igor
var
  FRec, FNextRec: TFRec;
  FD: TFormData;
  FFormNo, FInstNo: integer;
  FName: string;
  IsLast: boolean;
begin

  FRec := RetList[RetNo].FList.ByFormName(FormName);
  if FRec.FormNo <> 0 then
  begin

    ClearForm(RetNo, FormName);
    CalcAll(RetNo);
    //RetList[RetNo].MyChild.CloseActiveForm(nil);

    FFormNo := FRec.FormNo;
    FInstNo := FRec.InstNo;
    FName := FRec.FormName;

    IsLast := True;
    while True do
    begin
      inc(FInstNo);
      FNextRec := RetList[RetNo].FList.ByFormName(FName + '#' + IntToStr(FInstNo));
      if FNextRec.FormNo <= 0 then break;
      if RetList[RetNo].FrmHasData[FNextRec.FormNo] then
        IsLast := False;
      RetList[RetNo].Frm[FNextRec.FormNo].ReassignFRec(FRec);
      RetList[RetNo].Frm[FRec.FormNo] := RetList[RetNo].Frm[FNextRec.FormNo];
      RetList[RetNo].FrmHasData[FRec.FormNo] := RetList[RetNo].FrmHasData[FNextRec.FormNo];
      RetList[RetNo].Frm[FNextRec.FormNo] := nil;
      RetList[RetNo].FrmHasData[FNextRec.FormNo] := false;
      FFormNo := FNextRec.FormNo;
      FRec := FNextRec;
    end;
    RetList[RetNo].Frm[FFormNo] := TFormData.Create(RetNo, FFormNo);

    if IsLast then
      FormName := FName + '#1';

    FFormNo := RetList[RetNo].FList.ByFormName(FormName).FormNo;
    if FFormNo > 0 then
      OpenForm(RetNo, FFormNo, 0);
    CalcAll(RetNo);
    MainForm.RefreshAuditPanel(RetNo);
    If MainForm.FormsPanel.Visible then
      MainForm.RefreshFormsPanel(RetNo);
    RetList[RetNo].MyChild.UpdateChildTaxPanel();
    FloatingForms.UpdateForms(RetNo);
  end;
end;

procedure OpenPrevInstance(RetNo: integer; FormName: string);
var
  CInst: integer;
  NewFormName: string;
begin
  (* As opposed to OpenNextInstance, the previous instance (>0) exists already.
  *)
  CInst := StrToInt(MidStr(ExtractFormInst(FormName), 2, 2));
  if CInst > 1 then
  begin
    Dec(CInst);
    NewFormName := ExtractNonInstFormName(FormName) + '#' + IntToStr(CInst);
    OpenForm(RetNo, NewFormName, 0);
  end;
end;

procedure OpenNextInstance(RetNo: integer; FormName: string);
var
  CInst, NewFNo: integer;
  NewFormName: string;
begin
  (* Applicable to multi-inst forms only.
    If next instance doesn't exist, ask/create new one.
  *)
  NewFNo := GetFormNo(RetNo, FormName);
  if (RetList[RetNo].FrmHasData[NewFNo] = False) then
  begin
    if MessageDlg('Current statement has not been used. Show next?',
      mtInformation, [mbYes, mbNo], 0) = mrNo then
      exit;
  end;

  CInst := ExtractFormInstNo(FormName);
  if CInst = 0 then
  begin
    UserMsg(FormName + ' is not a multi instance form');
    exit;
  end;
  NewFormName := ExtractNonInstFormName(FormName) + '#' + IntToStr(CInst + 1);
  NewFNo := GetFormNo(RetNo, NewFormName);
  if NewFNo = 0 then {instance does not exist}
  begin
{$IFDEF paged}
    if IsFormMultipage(FormName) then {do all pages}
    begin
      AddPageInstance(ExtractFormRootName(FormName) + '_1',
        '#' + IntToStr(CInst + 1));
      AddOtherPagesInstance(ExtractFormRootName(FormName) + '_1',
        '#' + IntToStr(CInst + 1));
      NewFNo := GetFormNo(RetNo,
        ExtractFormRootName(FormName) + '_1' +
        '#' + IntToStr(CInst + 1));
    end
    else
{$ELSE}
    NewFNo := RetList[RetNo].AddPageInstance(ExtractNonInstFormName(FormName),
      '#' + IntToStr(CInst + 1));
{$ENDIF}
  end;
  OpenForm(RetNo, NewFNo, 0);
end;

procedure OpenNextPage(RetNo: integer; FormName: string);
begin
  if IsFormMultiInst(FormName) then
    OpenNextInstance(RetNo, FormName);
end;

procedure OpenPrevPage(RetNo: integer; FormName: string);
begin
  if IsFormMultiInst(FormName) then
    OpenPrevInstance(RetNo, FormName);
end;

procedure SetShortDateFormat;
begin
  with FormatSettings do // 20150615, there are no more global ShortDataFormat and similar variables, they're now part of FormatSettings record
  begin
    ShortDateFormat := UpperCase(ShortDateFormat);
    if ShortDateFormat = 'M' + DateSeparator + 'DD' + DateSeparator + 'YY' then
      ShortDateFormat := 'MM' + DateSeparator + 'DD' + DateSeparator + 'YYYY'
    else if ShortDateFormat = 'D' + DateSeparator + 'M' + DateSeparator + 'YY' then
      ShortDateFormat := 'DD' + DateSeparator + 'MM' + DateSeparator + 'YYYY'
    else if ShortDateFormat = 'DD' + DateSeparator + 'MM' + DateSeparator + 'YY' then
      ShortDateFormat := 'DD' + DateSeparator + 'MM' + DateSeparator + 'YYYY'
    else if ShortDateFormat = 'YY' + DateSeparator + 'MM' + DateSeparator + 'DD' then
      ShortDateFormat := 'YYYY' + DateSeparator + 'MM' + DateSeparator + 'DD'
    else if ShortDateFormat = 'D' + DateSeparator + 'M' + DateSeparator + 'YY' then
      ShortDateFormat := 'DD' + DateSeparator + 'MM' + DateSeparator + 'YYYY'
        {
      else If ShortDateFormat='DD'+DateSeparator+'MMM'+DateSeparator+'YY' then
         ShortDateFormat:='DD'+DateSeparator+'MM'+DateSeparator+'YYYY'
      else If ShortDateFormat='DD'+DateSeparator+'MMM'+DateSeparator+'YYYY' then
         ShortDateFormat:='DD'+DateSeparator+'MM'+DateSeparator+'YYYY'
      }
    else if ShortDateFormat = 'YY' + DateSeparator + 'MM' + DateSeparator + 'DD' then
      ShortDateFormat := 'YYYY' + DateSeparator + 'MM' + DateSeparator + 'DD';
  end;
end;

procedure ShowFormData(RetNo: integer; FormName: string; FormNo: integer);
var
  MyApp: TApp;
begin
  (* rather usesless, must also handle floating forms!
  *)
  MyApp := RetList[RetNo].MyApp;
  RetList[RetNo].MyChild.ShowFormData(FormName, FormNo);
end;

procedure MDIPaint(RetNo: integer); //replace WM_PAINT
var
  MyChild: TMyChild;
begin
  MyChild := RetList[RetNo].MyChild;
  if assigned(MyChild) then
    MyChild.Invalidate; //re-init data?
end;

function GetInstalledAppDir(const AppName: string): string;
(* Get installed app
*)
var
  Reg: TRegistry;
  lst: TStringList;
  i: integer;
  key, value: string;
const
  UninstallKey = '\Software\Microsoft\Windows\CurrentVersion\Uninstall';
  UninstallDir = 'UninstallString';
begin
  Result := '';
  //20170927 igor>>>
  if StartParams.isCloud and StartParams.IsDemo then
    Exit;
  //20170927 igor<<<
  lst := nil;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly(UninstallKey) then
    begin
      lst := TStringList.Create;
      Reg.GetKeyNames(lst);
      for i := 0 to lst.Count - 1 do
      begin
        value := lst[i];
        if value[1] <> 'T' then
          continue;
        if LeftStr(value, Length(AppName)) = AppName then
        begin
          key := UninstallKey + '\' + value;
          if not Reg.OpenKeyReadOnly(key) then
            exit; //no such key???
          value := Reg.ReadString(UninstallDir);
          Result := ExtractFileDir(value);
          exit;
        end;
      end;
    end;
  finally
    lst.Free;
    Reg.CloseKey;
    Reg.Free;
  end;
end;

function CountUnsavedReturns: Integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to (RetList.Count - 1) do
  begin
    if (RetList[i] <> nil) and RetList[i].Changed then
      Inc(Result);
  end;
end;

{$IFDEF develop}

// ------------ developers only -------------------

procedure convertDfmtoTxt(Dir: string; FileName: string);
begin
  ShellExecute(Application.Handle, 'open', PChar('' + '"C:\Program Files\Borland\Delphi5\Bin\convert.exe"'), PChar('' + '"' + Dir + '\u' + ExtractFileName(fileName) + '.DFM"'), PChar('' + '"' + Dir + '\u' + ChangeFileExt(ExtractFileName(fileName), 'txt') + '"'), SW_HIDE)
end;

procedure convertTxttoDfm(Dir: string; FileName: string);
begin
  ShellExecute(Application.Handle, 'open', PChar('' + '"C:\Program Files\Borland\Delphi5\Bin\convert.exe"'), PChar('' + '"' + Dir + '\u' + ChangeFileExt(ExtractFileName(fileName), '.txt') + '"'), PChar('' + '"' + Dir + '\u' + ExtractFileName(fileName) + '"'), SW_HIDE)
end;

procedure fixDfms(ADir: string; FileName: string; TempFormName: string);
var
  i, j: integer;
  TempList: TStringList;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(ADir + '\' + ChangeFileExt(ExtractFileName(FileName), '.txt'));
  TempList[0] := 'object ' + TempFormName + ': ' + 'T' + TempFormName;
  i := IsInList('ActiveControl', TempList);
  if i > -1 then
    TempList[i] := '';

  //TempList.savetofile(ADir + '\' + ChangeFileExt(ExtractFileName(FileName),'.txt'));
 //use .txt file in mergePageDfms
  TempList.savetofile(ADir + '\' + ChangeFileExt(ExtractFileName(FileName), '.txt'));
  TempList.Free;
end;

procedure shiftUpDFM(FormName: string);
var
  i, j: Integer;
  StartElm, EndElm, FormsDir: string;
  CurrentPos, StartPos, EndPos, ShiftAmount, SaveForm: LongInt;
  TempList: TStringList;
  AForm: TForm;
begin
  StartPos := 0;
  EndPos := 0; //???

  StartElm := InputBox('Input Box', 'Start Element', '1');
  EndElm := InputBox('Input Box', 'End Element', '300');
  ShiftAmount := StrToInt(InputBox('Input Box', 'Shift Amount', '2'));

  AForm := TForm.create(Application);
  ReadComponentResFile(GetDfmFileName(FormName), AForm);
  //BeforeOpenForm(FName,MyScrollBox);
  //find start and end pos
  for i := 0 to AForm.Controlcount - 1 do
  begin
    if AForm.Components[i] is TControl then
    begin
      if (AForm.Components[i] as TControl).Name = 'vtEdit' + startElm then
        startPos := (AForm.Components[i] as TControl).Top;
      if (AForm.Components[i] as TControl).Name = 'vtEdit' + endElm then
        endPos := (AForm.Components[i] as TControl).Top;
    end;
  end;

  TempList := TStringList.Create;
  TempList.Sorted := True;
  //find all positions in between
  for j := 0 to AForm.Controlcount - 1 do
  begin
    if AForm.Components[j] is TControl then
    begin
      if ((AForm.Components[j] as TControl).Top >= StartPos) and
        ((AForm.Components[j] as TControl).Top <= EndPos) then
      begin
        CurrentPos := (AForm.Components[j] as TControl).Top;
        if IsInList(IntToStr(CurrentPos), TempList) < 0 then
          TempList.Add(IntToStr(currentPos));
      end;
    end;
  end;

  //shift up
  for i := 0 to TempList.count - 1 do
  begin
    for j := 0 to AForm.Controlcount - 1 do
    begin
      if AForm.Components[i] is TControl then
      begin
        if (AForm.Components[j] as TControl).Top > StrToInt(TempList[i]) then
          (AForm.Components[j] as TControl).Top :=
            (AForm.Components[j] as TControl).Top - ShiftAmount;
      end;
    end;
  end;
  WriteComponentResFile('C:\delphi\Experiment3\FormsNew\TestFix.dfm', AForm);
  AForm.ShowModal;
  TempList.Free;

  //save file

  SaveForm := MessageDlg('Save This Form?', mtError, mbOKCancel, 0);

  if SaveForm = mrCancel then
  begin
    showmessage('Form not saved');
    exit;
  end;

  Screen.Cursor := crHourGlass;
  FormsDir := 'C:\WIP\T1\t1forms'; //'C:\WIP\t1forms';
  WriteComponentResFile(FormsDir + '\' + ExtractFileName(GetDfmFileName(FormName)), AForm);
  sleep(1000);
  convertDfmtoTxt(FormsDir, FormName);
  sleep(1500);
  fixDfms(FormsDir, (GetDfmFileName(FormName)), FormName);

  AForm.Free;

  sleep(1500);
  convertTxttoDfm(FormsDir, FormName);
  // sleep(500);

  Screen.Cursor := crDefault;
  showmessage('Form was saved');
end;

{$ELSE}
{$ENDIF}

// -------- keep last in unit, $Q is modified here! ---------------

procedure Delay(ms: Cardinal);
var
  TheTime: Cardinal;
begin
  (* diff. should be correct, even on overflows?
  *)
{$Q-}
  TheTime := GetTickCount; //+Ms;
  while (GetTickCount - TheTime) < ms do
    Application.ProcessMessages;
end;

function ReturnFileExists(const AFileName: String): boolean; //20160415 Igor
Begin
  Result := FileExists(AFileName) or FileExists(AFileName + '.old'); //20160419 Igor
End;

function CountClientsRecordWithoutThisReturnFile(AApp: TApp; ADir, AFileName: String): Integer; //20170502 Igor
var
  Con: TADConnection;
begin
  Con := TADConnection.Create(nil);
  try
    if not SetConnection(Con, ADir + '\' + AApp.ClientsDBLite, ClientsTableLite, False, False) then
      exit(-1);
    result := Con.ExecSQLScalar('SELECT count(*) FROM `' + ClientsTableLite + '` WHERE lower(`FILE_NAME`) <> lower(:FILE_NAME)',
                                [AFileName]);
  finally
    Con.Free;
  end;
end;

procedure UpdateSlipsCount(const ARetNo: Integer; const AConnection: TADConnection; const AFileName: String);//20171215 Igor
  function HasData(ARec: TFRec): Boolean;
  var
    Elm: Integer;
    A: TArray<String>;
    S: string;
  begin
    A := ARec.DataIndic.Split([',']);
    for S in A do
      if SameText(S, 'Y') and
         RetList[ARetNo].FrmHasData[ARec.FormNo] then
        Exit(True)
      else
      if TryStrToInt(S, Elm) then
        If FetchElm(ARetNo, ARec.FormNo, Elm) <> '' then
          Exit(True);
    Result := False;
  end;
var
  SL: TDictionary<string, Integer>;
  P: TPair<string, Integer>;
  I: Integer;
  R: TFRec;
begin
  Assert(Assigned(AConnection) and AConnection.Connected);
  Assert(not AFileName.IsEmpty);
  Assert((ARetNo > 0) and (ARetNo < RetList.Count) and Assigned(RetList[ARetNo]));
  SL := TDictionary<string, Integer>.Create;
  try
    for I := 0 to RetList[ARetNo].FList.Count - 1 do
    begin
      R := RetList[ARetNo].FList.ByIndex(I);
      if R.IsSlip then
      begin
        if HasData(R) then
          if SL.ContainsKey(R.FormName) then
            SL.Items[R.FormName] := SL.Items[R.FormName] + 1
          else
            SL.Add(R.FormName, 1);
      end;
    end;
    //20171221 Igor>>>
    AConnection.ExecSQL('Delete From FormsInfo Where File_Name = ' + QuotedStr(AFileName) +
                          ' AND Kind = ' + QuotedStr(c_FormInfoKind_Count));
    for P in SL do
    begin
      AConnection.ExecSQL('Insert Into FormsInfo(File_Name, Form_Name, Kind, Value) values'+
        '('+QuotedStr(AFileName)+', '+QuotedStr(P.Key)+', '+ QuotedStr(c_FormInfoKind_Count) + ', ' + QuotedStr(P.Value.ToString) +')');
    end;
    //20171221 Igor<<<
  finally
    SL.Free;
  end;
end;

//20180216 Igor >>>
function GetPhoneByFilter(AFilter: string; var APhone: string; var ADescription: string; ADelim: string; aTableName: string = 'DATA'): boolean; //20260214 Igor
var
  Conn: TADConnection;
  Q: TADQuery;
begin
  Result := false;
  Conn := TADConnection.Create(nil);
  Q := TADQuery.Create(Nil);
  try
    SetConnection(Conn, ExeDir + '\' + ProgramsAndPhonesDB, aTableName{'Data'}, False, False); //20260214 Igor
    Q.Connection := Conn;
    Q.SQL.Text :=
      ' SELECT DISTINCT ProgramPhoneNumber '+
      ' FROM ' + aTableName + //' FROM DATA ' //20260214 Igor
      ' WHERE ' + AFilter;
    Q.Open;
    APhone := '';
    if Q.RecordCount = 0 then Exit;
    while not Q.Eof do
    begin
      if APhone <> '' then
        APhone := APhone + ADelim;
      APhone := APhone + Q.FieldByName('ProgramPhoneNumber').AsString;
      Q.Next;
    end;
    Q.Close;
    Q.SQL.Text :=
      ' SELECT DISTINCT ProgNameEng, DeptNameEng '+
      ' FROM ' + aTableName + //' FROM DATA ' //20260214 Igor
      ' WHERE ' + AFilter;
    Q.Open;
    ADescription := '';
    while not Q.Eof do
    begin
      if ADescription <> '' then
        ADescription := ADescription + ADelim;
      ADescription := ADescription + Q.FieldByName('ProgNameEng').AsString + ' - ' + Q.FieldByName('DeptNameEng').AsString;
      Q.Next;
    end;
    Result := True;
  finally
    Q.Free; Conn.Free;
  end;
end;

function GetPhoneByProgramNumber(AProgramNumber: integer; var APhone: string; var ADescription: string; ADelim: string = '; '): boolean;
begin
  Result := GetPhoneByFilter('ProgNbr = ' + IntToStr(AProgramNumber), APhone, ADescription, ADelim);
end;

function GetPhoneByProgramCode(AProgramCode: string; var APhone: string; var ADescription: string; ADelim: string = '; '): boolean;
begin
  Result := GetPhoneByFilter('EngAbbr = ' + QuotedStr(AProgramCode), APhone, ADescription, ADelim);
end;
//20180216 Igor <<<

function TColorToWeb(AColor: TColor): string; //20201224 Igor
begin
  Result := '#' +
    IntToHex(GetRValue(AColor), 2) +
    IntToHex(GetGValue(AColor), 2) +
    IntToHex(GetBValue(AColor), 2);
end;

function WebToTColor(AColor: string): TColor; //20201224 Igor
var nRed, nGreen, nBlue: byte;
begin
  AColor := AColor.Replace('#', '');
  nRed := StrToIntDef('$' + Copy(AColor, 1, 2), 0);
  nGreen := StrToIntDef('$' + Copy(AColor, 3, 2), 0);
  nBlue := StrToIntDef('$' + Copy(AColor, 5, 2), 0);
  Result := Rgb(nRed, nGreen, nBlue);
end;


procedure OpenTeamviewer(ATeamViewerId: string); //20210203 Igor
var cCommand: string;
begin
  cCommand := GetRegistryValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\TeamViewer', 'InstallationDirectory');
  if cCommand.IsEmpty then
    cCommand := GetRegistryValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\WOW6432Node\TeamViewer', 'InstallationDirectory');
  if cCommand.IsEmpty then
  begin
    ShowMessage('It seems that TeamViewer is not installed on your computer');
    Exit;
  end;
  cCommand := TPath.Combine(cCommand, 'Teamviewer.exe');
  if not FileExists(cCommand) then
  begin
    ShowMessage('File '+ cCommand + ' was not found');
    Exit;
  end;
  ATeamViewerId := ATeamViewerId.Replace(' ', '');
  if ATeamViewerId.IsEmpty then
    ShellExecute(0, 'open', PChar(cCommand), nil, nil, SW_SHOWNORMAL)
  else
    ShellExecute(0, 'open', PChar(cCommand), PChar('-i '+ ATeamViewerId), nil, SW_SHOWNORMAL);
end;

procedure OpenUltraViewer(AUltraViewerId: string); //20210203 Igor
var cCommand: string;
begin
  cCommand := GetRegistryValue(HKEY_CLASSES_ROOT, 'UltraViewerRecord\Shell\Open\Command', '');
  if cCommand.IsEmpty then
  begin
    if FileExists('C:\Program Files (x86)\UltraViewer\UltraViewer_Desktop.exe') then
      cCommand := 'C:\Program Files (x86)\UltraViewer\UltraViewer_Desktop.exe'
    else if FileExists('C:\Program Files\UltraViewer\UltraViewer_Desktop.exe') then
      cCommand := 'C:\Program Files\UltraViewer\UltraViewer_Desktop.exe';
  end;
  if cCommand.IsEmpty then
  begin
    ShowMessage('It seems that UltraViewer is not installed on your computer');
    Exit;
  end;
  cCommand := Trim(cCommand.Replace('"%1"', ''));
  if ExtractFileExt(cCommand).IsEmpty then
    cCommand := cCommand + '.exe';
  if not FileExists(cCommand) then
  begin
    ShowMessage('File '+ cCommand + ' was not found');
    Exit;
  end;
  AUltraViewerId := AUltraViewerId.Replace(' ', '');
  if AUltraViewerId.IsEmpty then
    ShellExecute(0, 'open', PChar(cCommand), nil, nil, SW_SHOWNORMAL)
  else
    ShellExecute(0, 'open', PChar(cCommand), PChar('-i:'+ AUltraViewerId), nil, SW_SHOWNORMAL);
end;

function CalcTextHeight(AFont: TFont; AText: string; AWidth: integer): integer; //20210204 Igor
var
  B: Vcl.Graphics.TBitmap;
  R: TRect;
  A: TArray<string>;
  cNewStr, cWord: string;
  I, J, nEnd: integer;
begin
  B := Vcl.Graphics.TBitmap.Create;
  try
    B.Width := 300;
    B.Height := 300;
    B.Canvas.Font.Assign(AFont);
    B.Canvas.Font.Style := [];
    cNewStr := '';
    A := AText.Split([' ']);
    for I := 0 to Length(A) - 1 do
    begin
      cWord := A[I];
      while True do
      begin
        if B.Canvas.TextWidth(cWord) > AWidth then
        begin
          nEnd := Length(cWord);
          for J := 1 to Length(cWord) do
            if B.Canvas.TextWidth(Copy(cWord, 1, J)) > AWidth then
            begin
              nEnd := J - 1;
              break;
            end;
          if not cNewStr.IsEmpty then
            cNewStr := cNewStr + ' ';
          cNewStr := cNewStr + Copy(cWord, 1, nEnd);
          cWord := Copy(cWord, nEnd + 1, Length(cWord));
        end
        else
          break;
      end;
      if not cNewStr.IsEmpty then
        cNewStr := cNewStr + ' ';
      cNewStr := cNewStr + cWord;
    end;

    R := Rect(0, 0, AWidth, 0);
    DrawText(B.Canvas.Handle, PChar(cNewStr), Length(cNewStr), R, DT_CENTER or DT_WORDBREAK or DT_CALCRECT);

    Result := R.Height;
  finally
    B.Free;
  end;
end;
//20260214 Igor >>>
function GetInternalPhoneByProgramNumber(AProgramNumber: string; var APhone: string; var ADescription: string; ADelim: string = '; '): boolean;
begin
  Result:= GetPhoneByFilter('ProgNbr = ''' + AProgramNumber + '''', APhone, ADescription, ADelim, 'INTERNAL_DATA');
end;
//20260214 Igor <<<

end.
