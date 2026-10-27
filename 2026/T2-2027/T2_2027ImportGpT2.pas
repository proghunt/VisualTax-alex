unit T2_2027importgpt2;
//revision 2014-07-29

{distribution ConvGpT2.d}
(*

Comments:
Input ConvGpT2.d  format: T2.S[2]=BN^PAGE 1^1
output in TempDir  Format: above+ ^+value

*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, StdCtrls, Grids, DBGrids, DBCtrls, Menus, Buttons,
  FileCtrl, ShellApi, VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, Mask, ComCtrls, ComObj, olectnrs,
  OleServer,
  {Profile_TLB;,} T2_2027Profile_TLB;  //20240126 CON  added Profile_tlb from Profile download done 20181110
const
  ThisPackage = 'T2';
  TempFlExtension = 'EXP';
  FieldsFlName = 'ConvGpT2.d';
  {DriverFlName     = 'Conv.d';}
  TempDirName = 'TempDir';

type
  TImportGpT2_2027 = class(TForm)
    OpenDialog1: TOpenDialog;
    Chart1: TChart;
    OptionsGroupBox: TGroupBox;
    ReplaceOptionBox: TRadioGroup;
    ActionsGroupBox: TGroupBox;
    OpenBtn: TBitBtn;
    ImportAllBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FilesGroupBox: TGroupBox;
    FileListBox1: TFileListBox;
    ProfileExtensionBox: TComboBox;
    Label1: TLabel;
    FromDirBox: TEdit;
    SelectDirBtn1: TBitBtn;
    Label3: TLabel;
    ToDirBox: TEdit;
    SelectDirBtn2: TBitBtn;
    Label2: TLabel;
    Label4: TLabel;
    HelpBtn: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    ProfileVersionBox: TRadioGroup;
    Label7: TLabel;

    function GpDatetoYYYYMMDD(Valu: string): string;
    function GetNumberOfTableRows(ProfileFrmNm, ProfileTableNm: string): Integer;
    function GetVisualExt(VtYearEnd: string): string;
    function GetProfileFldName(S: string): string;
    function GetValue(FldName: WideString): string;
    function ConvertOne(GpFlName: string): Integer;
    function FldNameIsString(FldName: string): Boolean;
    function ConvertProvOfRes(Valu: string): string;
    function FixValu(FName, Valu: string; FNo, Elm: Integer): string;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ImportAllBtnClick(Sender: TObject);
    procedure SaveIt(FlName: string);
    procedure StoreData(ConvertedFlName: string);
    function ImportOne(ConvertedFlName: string): Integer;
    procedure HelpBtnClick(Sender: TObject);
    function GetSinNo(ConvertedFlName: string): string;
    procedure OpenBtnClick(Sender: TObject);
    procedure SelectDirBtn1Click(Sender: TObject);
    procedure SelectDirBtn2Click(Sender: TObject);
    procedure ShowFiles;
    procedure FromDirBoxExit(Sender: TObject);
    procedure FromDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure ProfileExtensionBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImportGpT2_2027: TImportGpT2_2027;
  LastEndingRetEarnings: Real;
  ProfileFile1: IProfileFile; //  Variant;  //20100204
  ProfileClient1: IProfileClient; //Variant;        //20100204

  ButtonClicked: string;
  GPFlName, ConvertedFlName, VisualFlName: string;
  ProfileExtension: string; //'GT2';
  GPYearEnd, VTYearEnd: string; //[10];
  RetNo: integer;
  Cnt: integer;
  InitialRowCount: integer;

  TempDir: string;

implementation

{$R *.DFM}

uses
  vtMulti, vtMain, vtCommon, vtDialogs,
  T2_2027,
  //T2_2027SelectDir,
  T2_2027Main,
  T2_2027Declare, T2_2027TrimStr, T2_2027Common, T2_2027Common2, T2_2027ChildWinNew,
  T2_2027Calc, T2_2027DirOpt,
  vtTrimStr, vtShared;

procedure TImportGpT2_2027.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  ButtonClicked := '';
  ToDirBox.Text := OptRec.Dir_Cur;
  ProfileExtensionBox.Text := 'GT2'; {ProfileExtension;}
  ProfileExtension := ProfileExtensionBox.Text;
  {remove it}
  FromDirBox.Text := OptRec.Dir_LastYr;
  TempDir := AppDir + '\' + TempDirName;
  if SysUtils.DirectoryExists(TempDir) then //20150701
  else
    MkDir(TempDir);

  ShowFiles;
 //20180503 Igor >>>
  if CheckIsCloud(true) then
    FromDirBox.Enabled := False;
  //20180503 Igor <<<
end;

procedure TImportGpT2_2027.CancelBtnClick(Sender: TObject);
begin
  Close;

end;

procedure TImportGpT2_2027.ImportAllBtnClick(Sender: TObject);
var
  i: Integer;
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

  if MessageDlg('Import all. Are you sure?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit;

  ButtonClicked := 'IMPORT ALL';
  Screen.Cursor := crHourGlass;
  Cnt := 0;
  for i := 0 to FileListBox1.Items.Count - 1 do
  begin
    FileListBox1.ItemIndex := i;
    GPFlName := FromDirBox.Text + '\' + FileListBox1.Items[FileListBox1.ItemIndex];
    ShowTimedMsg('Importing: ' + GpFlName, 1000);
    if ConvertOne(GpFlName) = 0 then
      ImportOne(ConvertedFlName);
  end;
  Screen.Cursor := crDefault;
  ShowMessage('Total returns imported= ' + IntToStr(cnt)
    + Chr(13) + 'You can now Exit and use Open from the VisualTax Main Menu');
  ButtonClicked := '';
end;

function TImportGpT2_2027.GetVisualExt(VtYearEnd: string): string;
var
  i: Integer;
  TwoDigitYE: string; //[2];
begin
  TwoDigitYE := MidStr(VTYearEnd, 3, 2);
  Result := FillLeftZeros(AllTrim(TwoDigitYE), 2);
end;

procedure TImportGpT2_2027.SaveIt(FlName: string);
begin
  if not SaveReturn(RetNo, ToDirBox.Text, FlName, True, True) = 0 then
    ShowMessage('Save of data failed')
  else
    Inc(Cnt);
end;

procedure TImportGpT2_2027.ShowFiles;
//20170707 Igor >>>
var
  DirSelected: String;
begin
  while (FromDirBox.Text = '') or not SysUtils.DirectoryExists(FromDirBox.Text) do
  begin
    if SelectDirectory('Select a folder:', '', DirSelected, []) then
      FromDirBox.Text := DirSelected
    else
    begin
      FromDirBox.Text := FileListBox1.Directory;
      exit;
    end;
  end;
  FileListBox1.Directory := FromDirBox.Text;
  FileListBox1.Mask := '*.' + ProfileExtensionBox.text;
  FileListBox1.ItemIndex := 0;
  FilesGroupBox.Caption := 'FILES: ' + IntTostr(FileListBox1.Items.count);
//20170707 Igor <<<
end;

procedure TImportGpT2_2027.StoreData(ConvertedFlName: string);
var
  i, j, FNo, Elm: Integer;
  FName, Valu: string;
  ConvList, WList: TStringList;
begin
  ConvList := TStringList.Create;
  WList := TStringList.Create;
  ConvList.LoadFromFile(ConvertedFlName);

  // 20150702 try except moved inside loop
  for i := 0 to ConvList.Count - 1 do
  begin
    try
      if AllTrim(ConvList[i]) > '' then
      begin
        valu := '';
        FNo := 0;
        try
          ParseWords(ConvList[i] + '^', '^', WList); {added a last delim in case no value}
          FName := AllTrim(WList[1]);
          Elm := MyStrToInt(AllTrim(Wlist[2]));
          if WList.Count >= 3 then
            Valu := AllTrim(WList[3])
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
        if Fname = 'COMPSUM' then
        begin
          StoreElm(RetNo, FNo, 14, 'VisualTax');
          for j := 15 to 18 do
            StoreElm(RetNo, FNo, j, 'Profile');
        end;
        if (FNo > 0) and (Valu > '') then
        begin
          Valu := FixValu(FName, Valu, FNo, Elm);
          try
            StoreElm(RetNo, FNo, Elm, Valu);
            Calc(RetNo, FName);
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
end;

procedure TImportGpT2_2027.HelpBtnClick(Sender: TObject);
begin
  //Application.HelpFile :=AppDir+'\'+'T2UpdHlp.HLP';
  ShowHelp('T2Help', 'RolloverFromProfile');
end;

function TImportGpT2_2027.GetSinNo(ConvertedFlName: string): string;
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
    ParseWords(ConvList[i], '=', WList);
    if LeftStr(WList[1], 2) = 'BN' then
    begin
      ParseWords(ConvList[i], '^', WList);
      Result := LeftStr(AllTrim(RemoveChar(WList[3], ' ')), 9);
      Break;
    end;
  end;
  ConvList.Free;
  WList.Free;
end;

procedure TImportGpT2_2027.OpenBtnClick(Sender: TObject);
begin
  if not SysUtils.DirectoryExists(FromDirBox.Text) then //20150701
  begin
    ShowMessage('From Directory ' + FromDirBox.Text + ' does not exist');
    exit;
  end;

  if FileListBox1.ItemIndex < 0 then
  begin
    ShowMessage('You must select a file first');
    exit;
  end;

  ButtonClicked := 'OPEN';
  Screen.Cursor := crHourGlass;
  GPFlName := FromDirBox.Text + '\' + FileListBox1.Items[FileListBox1.ItemIndex];
  //20090613  Temp for testing a converted file in \tempdir
  //ConvertedFlName:=TempDir+'\'+'5150736 MANITOBA LTD (20070630).EXP';
  // If ImportOne(ConvertedFlName) = 0 then
  if (ConvertOne(GpFlName) = 0) and (ImportOne(ConvertedFlName) = 0) then
  begin
    MainFormT2.RecalcBtnClick(Application);
    OpenForm(RetNo, 'T2', 0);
    Ret[RetNo].Changed := True;
    Screen.Cursor := crDefault;
    Close;
  end;
  ButtonClicked := '';
end;

procedure TImportGpT2_2027.SelectDirBtn1Click(Sender: TObject);
var
  DirSelected: string; //20150622
begin
  if SelectDirectory('Select a folder:', '', DirSelected, []) then //20150622
  begin
    FromDirBox.Text := DirSelected;
  end;
  ShowFiles;
end;

procedure TImportGpT2_2027.SelectDirBtn2Click(Sender: TObject);
begin
  ExecuteForm(TDirOptT2_2027);
  ToDirBox.Text := OptRec.Dir_Cur;
end;

function TImportGpT2_2027.FixValu(FName, Valu: string; FNo, Elm: Integer): string;
begin
  Result := Valu;
  if FName = 'T2' then
  begin
    case Elm of
      1: result := AllTrim(RemoveChar(Valu, ' ')); //BN
      2:
        begin
          // ShowMessage('prov='+valu);
          Result := ConvertProvOfRes(Valu);
        end;

      10, 11:
        result := AdvanceYearEnd(GpDateToYYYYMMDD(Valu)); //20090517 AdvanceYearEnd(MMDDYYYYToYYYYMMDD(Valu));
      28..31: result := '';
      61:
        result := GpDateToYYYYMMDD(Valu); //20090517 MMDDYYYYToYYYYMMDD(Valu);
      24: if Valu = '1' then
        begin result := '';
          StoreElm(RetNo, FNo, 24, 'X');
          StoreElm(RetNo, FNo, 25, '');
        end
        else if Valu = '2' then
        begin result := '';
          StoreElm(RetNo, FNo, 24, '');
          StoreElm(RetNo, FNo, 25, 'X');
        end;

      48: if Valu = '1' then
        begin result := '';
          StoreElm(RetNo, FNo, 48, 'X');
          StoreElm(RetNo, FNo, 49, '');
        end
        else if Valu = '2' then
        begin result := '';
          StoreElm(RetNo, FNo, 48, '');
          StoreElm(RetNo, FNo, 49, 'X');
        end;

      63: if Valu = '1' then
        begin Result := '';
          StoreElm(RetNo, FNo, 63, 'X');
          StoreElm(RetNo, FNo, 64, '');
        end
        else if Valu = '2' then
        begin
          Result := '';
          StoreElm(RetNo, FNo, 63, '');
          StoreElm(RetNo, FNo, 64, 'X');
        end;

      51:
        begin {corp type}
          if Valu = '1' then
            StoreElm(RetNo, FNo, 51, 'X')
          else if Valu = '2' then
            StoreElm(RetNo, FNo, 56, 'X')
          else if Valu = '3' then
            StoreElm(RetNo, FNo, 59, 'X')
          else if Valu = '4' then
            StoreElm(RetNo, FNo, 52, 'X')
          else if Valu = '5' then
            StoreElm(RetNo, FNo, 57, 'X')
          else
            result := '';
        end;
      53:
        begin {exempt case}
          if Valu = '1' then
          begin Result := 'X';
            StoreElm(RetNo, FNo, 53, 'X');
          end
          else if Valu = '2' then
          begin Result := '';
            StoreElm(RetNo, FNo, 54, 'X');
          end
          else if Valu = '3' then
          begin Result := '';
            StoreElm(RetNo, FNo, 55, 'X');
          end
          else if Valu = '4' then
          begin Result := '';
            StoreElm(RetNo, FNo, 58, 'X');
          end
          else
            result := '';
        end;
    end;
  end;

  //???
  if FName = 'T2' then
  begin
    case elm of
      55:
        begin
          result := RemoveChar(valu, '(');
          result := RemoveChar(result, ')');
          result := RemoveChar(result, ' '); //phone as 999888-8888
          if Length(Result) > 3 then
            StoreElm(RetNo, FNo, 746, MidStr(Result, 4, 8));
          result := LeftStr(Result, 3); //are only
        end;
    end;
  end;

  if LeftStr(FName, 2) = 'S2' then {BN}
  begin
    if valu = '0' then
      result := '';
  end;

  if LeftStr(FName, 2) = 'S8' then {BN}
  begin
    if valu = '0' then
      result := '';
  end;

  if LeftStr(FName, 3) = 'S8L' then
  begin
    case Elm of
      1, 12, 23, 34, 45, 56, 67, 78, 89, 100, 111, 122:
        result := GpDateToYYYYMMDD(valu); //20090517 DDMMYYYYToYYYYMMDD(Valu);
      2, 13, 24, 35, 46, 57, 68, 79, 90, 101, 112, 123:
        result := GpDateToYYYYMMDD(valu); //20090517 DDMMYYYYToYYYYMMDD(Valu);
    end;
    if valu = '0' then
      result := '';
  end;

  if LeftStr(FName, 3) = 'S12' then {BN}
  begin
    if valu = '0' then
      result := '';
  end;

  if LeftStr(FName, 3) = 'S10' then {BN}
  begin
    if valu = '0' then
      result := '';
  end;

  if LeftStr(FName, 3) = 'S13' then {BN}
  begin
    if valu = '0' then
      result := '';
  end;

  if LeftStr(FName, 3) = 'S16' then {BN}
  begin
    if valu = '0' then
      result := '';
  end;

  if LeftStr(FName, 3) = 'S31' then {BN}
  begin
    if valu = '0' then
      result := '';
  end;

  {//20170525
  if LeftStr(FName, 3) = 'S37' then
  begin
    if valu = '0' then
      result := '';
  end;
 }
  if LeftStr(FName, 4) = 'T661' then {BN}
  begin
    if valu = '0' then
      result := '';
  end;

  if FName = 'S9' then {BN}
  begin
    case Elm of
      6, 15, 24, 33, 42, 51, 60, 69, 78, 87, 96, 105, 114, 123, 132:
        Result := RemoveChar(Valu, ' ');
    end;
    if Valu = '0' then
      result := ''; {all}
  end;

  if FName = 'S50' then {BN}
  begin
    case Elm of
      5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90,
        95, 100, 105, 110, 115, 120, 125:
        Result := RemoveChar(Valu, ' ');
    end;
    case Elm of
      6, 11, 16, 21, 26, 30, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91,
        96, 101, 106, 111, 116, 121, 126:
        Result := RemoveChar(Valu, ' ');
    end;
    if Valu = '0' then
      result := ''; {all}
  end;


  if (FName = 'S321')
    or (FName = 'S340')
    // or (FName='S344')
  or (FName = 'S360')
    or (FName = 'S380')
    or (FName = 'S381')
    or (FName = 'S402')
    or (FName = 'S403')
  //  or (FName = 'S426')  //20170525
   // or (FName = 'S460') then
    //or (FName='S480')
  then
  begin
    if valu = '0' then
      result := '';
  end;
end;

function TImportGpT2_2027.ConvertProvOfRes(Valu: string): string;
var
  n: Integer;
begin
  Result := '';
  if Valu = 'NL' then
    Result := 'Newfoundland';
  if Valu = 'PE' then
    Result := 'Prince Edward Island';
  if Valu = 'NS' then
    Result := 'Nova Scotia';
  if Valu = 'NB' then
    Result := 'New Brunswick';
  if Valu = 'QC' then
    Result := 'Quebec';
  if Valu = 'ON' then
    Result := 'Ontario';
  if Valu = 'MB' then
    Result := 'Manitoba';
  if Valu = 'SK' then
    Result := 'Saskatchewan';
  if Valu = 'AB' then
    Result := 'Alberta';
  if Valu = 'BC' then
    Result := 'British Columbia';
  if Valu = 'YT' then
    Result := 'Yukon Territory';
  if Valu = 'NT' then
    Result := 'Northwest Territories';
  if Valu = 'MJ' then
    Result := 'Multiple';
  if Valu = 'NO' then
    Result := 'N.S. Offshore';
  if Valu = 'OC' then
    Result := 'Outside Canada';
  if Valu = 'XO' then
    Result := 'NFLD Offshore';
  if Valu = 'NU' then
    Result := 'Nunavut';
end;

procedure TImportGpT2_2027.FromDirBoxExit(Sender: TObject);
begin
  ShowFiles;
end;

procedure TImportGpT2_2027.FromDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ShowFiles;
end;

function TImportGpT2_2027.GetProfileFldName(S: string): string;
var
  WList: TStringList;
begin
  if (s = '') or (LeftStr(s, 2) = '//') then
  begin Result := '';
    exit;
  end;
  WList := TstringList.Create;
  ParseWords(S, '=', WList);
  Result := Wlist[0];
  WList.Free;
end;

function TImportGpT2_2027.GetNumberOfTableRows(ProfileFrmNm, ProfileTableNm: string): Integer;
var
  i, FCount: Integer;
begin
  FCount := ProfileClient1.FormCount[ProfileFrmNm];
  Result := 0;
  for i := 0 to FCount - 1 do
  begin
    Result := Result + ProfileClient1.TableItemCount[ProfileTableNm, i];
    {Showmessage('Table items='+IntToStr(TableRows));}
  end;
end;

function TImportGpT2_2027.ConvertOne(GpFlName: string): Integer;
var
  s: string;
  Dt: TDate;
  FldName: string;
  Item: Variant;
  FldList, OutList: TStringList;
  i, j, ii, VisualInst, VisualIncr, FCount, TableRows, MaxVisualRowsPerInst: Integer;
  ProfileFrmNm, VisualFrmNm, ProfileTableNm, VisualFldDescr, ProfileInstance: string;
begin
  Result := 9;
  //ProfileFile1:=CoT2019T2File.Create;    //20200104
  //ProfileFile1:=CoT2018T2File.Create;    //20181110
  //20200104
  //20211222 Igor >>>
  case ProfileVersionBox.Itemindex of   //20240101
    //20230102
    //20240226
    //20260714 Alex >>>
    0: ProfileFile1:= CoT2026T2File.Create;
    1: ProfileFile1:= CoT2025T2File.Create;
    2: ProfileFile1:= CoT2024T2File.Create;
    3: ProfileFile1:= CoT2023T2File.Create;
    4: ProfileFile1:= CoT2022T2File.Create;
    5: ProfileFile1:= CoT2021T2File.Create; //20171214
    6: ProfileFile1:= CoT2020T2File.Create; //20171214
    7: ProfileFile1:= CoT2019T2File.Create; //20120201
    8: ProfileFile1:= CoT2018T2File.Create; //20120201
    9: CoT2017T2File.Create; //20120201
    {0: ProfileFile1:=CoT2023T2File.Create;
    1: ProfileFile1:=CoT2022T2File.Create;
    //---
    2: ProfileFile1:=CoT2021T2File.Create; //20171214
    3: ProfileFile1:=CoT2020T2File.Create; //20171214
    4: ProfileFile1:=CoT2019T2File.Create; //20120201
    5: ProfileFile1:=CoT2018T2File.Create; //20120201
    6: CoT2017T2File.Create; //20120201}
    //20260714 Alex <<<
  end;
  //20211222 Igor <<<

  (*
   //now try to create a newer version, nothing changed on an exception
   try
     Case ProfileVersionBox.Itemindex of
       0:
         begin
          ProfileFile1  :=  Profile_tlb.CoT2012T2File.Create; //20100905
         end;
       1: ProfileFile1  :=  Profile_tlb.CoT2011T2File.Create; //20100905
       else
          ProfileFile1  := Profile_tlb.CoT2008T2File.Create;
       end;
   except
     on E: Exception do begin
       Application.ShowException(E);
       ShowTimedMsg('Problem creating T2010 interface',1500);   //20110131
     end;
   end;
  *)
  ProfileFile1.LoadFile(GpFlName, True);
  ProfileClient1 := ProfileFile1.Client; {property}
  //this one can throw the Catastrophic exception
  if False then
  begin
    try
      ProfileClient1.Calculate;
    except
      on E: Exception do
      begin
        //Application.ShowException(E);
        ShowMessage('Profile Calculate: ' + E.Message);
      end;
    end;
  end;
  (*
   Case ProfileVersionBox.Itemindex of
     0:ProfileFile1  :=  Profile_tlb.CoT2009T2File.Create;
   else
   ProfileFile1  := Profile_tlb.CoT2008T2File.Create;
   end; //case

   If Profile2008Box.Checked then
     ProfileFile1  :=  Profile_tlb.CoT2008T2File.Create
   else If Profile2009Box.Checked then
     ProfileFile1  :=  Profile_tlb.CoT2009T2File.Create
   else
    ProfileFile1  := Profile_tlb.CoT2007T2File.Create;


 //  ProfileClient1:= ProfileFile1.Client;  {property} //20100204
   ProfileFile1.LoadFile(GpFlName,True);
   ProfileClient1.Calculate;
   *)
   //get values of fields

   //GPYearEnd:= MMDDYYYYToYYYYMMDD(GetValue('T2Info[2]')); //20090517
  GPYearEnd := GpDateToYYYYMMDD(GetValue('T2Info[2]')); //20090517
  //ShowMessage(GpYearEnd);
  LastEndingRetEarnings := vl(GetValue('T2S100[7]')); //20090517
  //ShowMessage(LastEndingRetEarnings); //20090517
  VTYearEnd := AdvanceYearEnd(GPYearEnd);
  FldList := TStringList.Create;
  FldList.LoadFromFile(AppDir + '\' + FieldsFlName);

  // add special schedules to Fldlist
  //S2_3 - Donations
  VisualFrmNm := 'S2'; //pg3
  VisualIncr := 5;
  j := 204; //fld in visualtax
  i := 32; //row in profile: start at second row due to increase in year
  repeat
    FldName := 'T2S2[' + AllTrim(IntToStr(i)) + ']';
    FldList.add(FldName + '=don year^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := 'T2S2[' + AllTrim(IntToStr(i + 50)) + ']';
    FldList.add(FldName + '=don end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));
    Inc(i);
    Inc(j, VisualIncr);
  until J > 229;

  //S2_3 - Gifts
  VisualFrmNm := 'S2'; //pg3
  VisualIncr := 5;
  j := 238; //fld in visualtax
  i := 102; //row in profile: start at second row due to increase in year
  repeat
    FldName := 'T2S2[' + AllTrim(IntToStr(i)) + ']';
    FldList.add(FldName + '=gifts year^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := 'T2S2[' + AllTrim(IntToStr(i + 50)) + ']';
    FldList.add(FldName + '=gifts end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));
    Inc(i);
    Inc(j, VisualIncr);
  until J > 263;

  //S2_3 - Cultural
  VisualFrmNm := 'S2'; //pg3
  VisualIncr := 5;
  j := 272; //fld in visualtax
  i := 172; //row in profile: start at second row due to increase in year
  repeat
    FldName := 'T2S2[' + AllTrim(IntToStr(i)) + ']';
    FldList.add(FldName + '=cult year^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := 'T2S2[' + AllTrim(IntToStr(i + 50)) + ']';
    FldList.add(FldName + '=cult end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));
    Inc(i);
    Inc(j, VisualIncr);
  until J > 297;

  //S2_3 - ecolog
  VisualFrmNm := 'S2'; //pg3
  VisualIncr := 5;
  j := 306; //fld in visualtax
  i := 242; //row in profile: start at second row due to increase in year
  repeat
    FldName := 'T2S2[' + AllTrim(IntToStr(i)) + ']';
    FldList.add(FldName + '=ecol year^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := 'T2S2[' + AllTrim(IntToStr(i + 50)) + ']';
    FldList.add(FldName + '=ecol end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));
    Inc(i);
    Inc(j, VisualIncr);
  until J > 331;

  //S8
  ProfileFrmNm := 'S8';
  ProfileTableNm := 'T2S8Table';
  TableRows := GetNumberOfTableRows(ProfileFrmNm, ProfileTableNm);
  VisualInst := 1;
  VisualFrmNm := 'S8';
  VisualIncr := 16;
  MaxVisualRowsPerInst := 13;
  //CCA class
  j := 6; //cca fld in visualtax
  i := -1; //row -1 in profile table
  ii := 0;
  repeat
    //Fld name depends on row and column of table
    Inc(i);
    if i = MaxVisualRowsPerInst * VisualInst then
    begin j := 6;
      Inc(VisualInst);
    end; //new inst
    FldName := GetProfileFldName
      ('T2S8Table.S[' + AllTrim(IntToStr(i)) + ',1]'); //1=CCA class
    FldList.add(FldName
      + '=CCA class^' + VisualFrmNm + '#' + IntToStr(VisualInst) + '^' + IntToStr(j));

    FldName := GetProfileFldName
//      ('T2S8Table[' + AllTrim(IntToStr(i)) + ',26]'); //26=CCA UCC //20260715 Alex
      ('T2S8Table[' + AllTrim(IntToStr(i)) + ', 24]'); //21=CCA UCC //20260715 Alex
    FldList.add(FldName +
      '=CCA UCC^' + VisualFrmNm + '#'
      + IntToStr(VisualInst) + '^' + IntToStr(j + 1));

    Inc(j, VisualIncr);
  until i >= TableRows - 2; //needs 2 less


  (*
  //S8LH  {first}
  ProfileFrmNm := 'S8L';
  ProfileTableNm := 'T2S8LTable';
  TableRows := 12; {GetNumberOfTableRows(ProfileFrmNm,ProfileTableNm);}
  VisualInst := 1;
  VisualFrmNm := 'S8LH';
  VisualIncr := 11;
  MaxVisualRowsPerInst := 12;
  ProfileInstance := '0';
  //CCA class
  j := 1; //fld in visualtax
  i := -1; //row -1 in profile table
  repeat
    //Fld name depends on row and column of table
    Inc(i);
    if i > MaxVisualRowsPerInst * VisualInst then
      break;

    FldName := GetProfileFldName
      ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',18]'); //ucc
    if Vl(GetValue(FldName)) > 0 then {only if UCC move to next row}
    begin
      FldList.add(FldName +
        '=CCA-L UCC^' + VisualFrmNm +
        '^' + IntToStr(j + 3));
      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',2]'); //start yr
      FldList.add(FldName
        + '=CCA-L start yr^' + VisualFrmNm + '^' + IntToStr(j));

      FldName := GetProfileFldName('T2S8L[' + ProfileInstance + ',0]'); //end yr
      FldList.add(FldName
        + '=CCA-L end yr^' + VisualFrmNm + '^' + IntToStr(j + 1));

      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',1]'); //orig cost
      FldList.add(FldName +
        '=CCA-L UCC^' + VisualFrmNm +
        '^' + IntToStr(j + 2));

      Inc(j, VisualIncr);
    end;
  until i >= TableRows - 2; //needs 2 less

  //S8LH  {instances 1}
  ProfileFrmNm := 'S8L';
  ProfileTableNm := 'T2S8LTable';
  TableRows := 12; {GetNumberOfTableRows(ProfileFrmNm,ProfileTableNm);}
  VisualInst := 1;
  VisualFrmNm := 'S8LH';
  VisualIncr := 11;
  MaxVisualRowsPerInst := 12;
  ProfileInstance := '1';
  //CCA class
  j := J; //fld in visualtax
  i := -1; //row -1 in profile table
  repeat
    //Fld name depends on row and column of table
    Inc(i);
    if i > MaxVisualRowsPerInst * VisualInst then
      break;

    FldName := GetProfileFldName
      ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',18]'); //ucc
    if Vl(GetValue(FldName)) > 0 then {only if UCC move to next row}
    begin
      FldList.add(FldName +
        '=CCA-L UCC^' + VisualFrmNm +
        '^' + IntToStr(j + 3));
      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',2]'); //start yr
      FldList.add(FldName
        + '=CCA-L start yr^' + VisualFrmNm + '^' + IntToStr(j));

      FldName := GetProfileFldName('T2S8L[' + ProfileInstance + ',0]'); //end yr
      FldList.add(FldName
        + '=CCA-L end yr^' + VisualFrmNm + '^' + IntToStr(j + 1));

      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',1]'); //orig cost
      FldList.add(FldName +
        '=CCA-L UCC^' + VisualFrmNm +
        '^' + IntToStr(j + 2));

      Inc(j, VisualIncr);
    end;
  until i >= TableRows - 2; //needs 2 less

  //S8LH  {instances 2}
  ProfileFrmNm := 'S8L';
  ProfileTableNm := 'T2S8LTable';
  TableRows := 12; {GetNumberOfTableRows(ProfileFrmNm,ProfileTableNm);}
  VisualInst := 1;
  VisualFrmNm := 'S8LH';
  VisualIncr := 11;
  MaxVisualRowsPerInst := 12;
  ProfileInstance := '2';
  //CCA class
  j := J; //fld in visualtax
  i := -1; //row -1 in profile table
  repeat
    //Fld name depends on row and column of table
    Inc(i);
    if i > MaxVisualRowsPerInst * VisualInst then
      break;

    FldName := GetProfileFldName
      ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',18]'); //ucc
    if Vl(GetValue(FldName)) > 0 then {only if UCC move to next row}
    begin
      FldList.add(FldName +
        '=CCA-L UCC^' + VisualFrmNm +
        '^' + IntToStr(j + 3));
      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',2]'); //start yr
      FldList.add(FldName
        + '=CCA-L start yr^' + VisualFrmNm + '^' + IntToStr(j));

      FldName := GetProfileFldName('T2S8L[' + ProfileInstance + ',0]'); //end yr
      FldList.add(FldName
        + '=CCA-L end yr^' + VisualFrmNm + '^' + IntToStr(j + 1));

      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',1]'); //orig cost
      FldList.add(FldName +
        '=CCA-L UCC^' + VisualFrmNm +
        '^' + IntToStr(j + 2));

      Inc(j, VisualIncr);
    end;
  until i >= TableRows - 2; //needs 2 less

  //S8LH  {instances 3}
  ProfileFrmNm := 'S8L';
  ProfileTableNm := 'T2S8LTable';
  TableRows := 12; {GetNumberOfTableRows(ProfileFrmNm,ProfileTableNm);}
  VisualInst := 1;
  VisualFrmNm := 'S8LH';
  VisualIncr := 11;
  MaxVisualRowsPerInst := 12;
  ProfileInstance := '3';
  //CCA class
  j := J; //fld in visualtax
  i := -1; //row -1 in profile table
  repeat
    //Fld name depends on row and column of table
    Inc(i);
    if i > MaxVisualRowsPerInst * VisualInst then
      break;

    FldName := GetProfileFldName
      ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',18]'); //ucc
    if Vl(GetValue(FldName)) > 0 then {only if UCC move to next row}
    begin
      FldList.add(FldName +
        '=CCA-L UCC^' + VisualFrmNm +
        '^' + IntToStr(j + 3));
      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',2]'); //start yr
      FldList.add(FldName
        + '=CCA-L start yr^' + VisualFrmNm + '^' + IntToStr(j));

      FldName := GetProfileFldName('T2S8L[' + ProfileInstance + ',0]'); //end yr
      FldList.add(FldName
        + '=CCA-L end yr^' + VisualFrmNm + '^' + IntToStr(j + 1));

      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',1]'); //orig cost
      FldList.add(FldName +
        '=CCA-L UCC^' + VisualFrmNm +
        '^' + IntToStr(j + 2));

      Inc(j, VisualIncr);
    end;
  until i >= TableRows - 2; //needs 2 less

*)
  //S9
  VisualFrmNm := 'S9';
  VisualIncr := 9;
  j := 4; //fld in visualtax
  i := -1; //row -1 in profile table
  ii := -1;
  repeat
    //Fld name depends on row and column of table
    Inc(i);
    if J > 130 then
      Break;
    FldName := 'T2S9.S[' + AllTrim(IntToStr(i)) + ',0]';
    FldList.add(FldName + '=Shareholder^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := 'T2S9.S[' + AllTrim(IntToStr(i)) + ',1]';
    FldList.add(FldName + '=Country^' + VisualFrmNm + '^' + IntToStr(j + 1));

    FldName := 'T2S9.S[' + AllTrim(IntToStr(i)) + ',2]';
    FldList.add(FldName + '=Bus No^' + VisualFrmNm + '^' + IntToStr(j + 2));

    FldName := 'T2S9.B[' + AllTrim(IntToStr(i)) + ',0]';
    FldList.add(FldName + '=Code^' + VisualFrmNm + '^' + IntToStr(j + 3));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',0]';
    FldList.add(FldName + '=Comm shares^' + VisualFrmNm + '^' + IntToStr(j + 4));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',1]';
    FldList.add(FldName + '=Comm shares%^' + VisualFrmNm + '^' + IntToStr(j + 5));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',2]';
    FldList.add(FldName + '=Pref shares^' + VisualFrmNm + '^' + IntToStr(j + 6));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',3]';
    FldList.add(FldName + '=Pref shares%^' + VisualFrmNm + '^' + IntToStr(j + 7));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',4]';
    FldList.add(FldName + '=Bk Val Cap stock^' + VisualFrmNm + '^' + IntToStr(j + 8));

    Inc(j, VisualIncr);
  until J >= 130;

  //S13-cap gains
  VisualFrmNm := 'S13';
  VisualIncr := 4;
  j := 4; //fld in visualtax
  i := 0; //row in profile: start at second row due to increase in year
  repeat
    FldName := 'T2S13CapitalGains.S[' + AllTrim(IntToStr(i)) + ',0]';
    FldList.add(FldName + '=descr^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := 'T2S13CapitalGains[' + AllTrim(IntToStr(i)) + ',2]';
    FldList.add(FldName + '=end bal^' + VisualFrmNm + '^' + IntToStr(j + 1));

    Inc(i);
    Inc(j, VisualIncr);
  until J > 24;

  //S13-other reserves
  VisualFrmNm := 'S13';
  VisualIncr := 3;
  j := 31; //fld in visualtax
  i := 7; //row in profile: start at second row due to increase in year
  repeat
    FldName := 'T2S13[' + AllTrim(IntToStr(i)) + ']';
    FldList.add(FldName + '=end bal^' + VisualFrmNm + '^' + IntToStr(j));
    Inc(i, 3);
    Inc(j, VisualIncr);
  until J > 49;

  //S50
  VisualFrmNm := 'S50';
  VisualIncr := 5;
  j := 4; //fld in visualtax
  i := -1; //row -1 in profile table
  ii := -1;
  repeat
    //Fld name depends on row and column of table
    Inc(i);
    Inc(ii);
    if J > 124 then
      Break;
    FldName := 'T2S50.S[' + AllTrim(IntToStr(i)) + ',0]';
    FldList.add(FldName + '=Shareholder^' + VisualFrmNm + '^' + IntToStr(j));

    FldName := 'T2S50.S[' + AllTrim(IntToStr(i)) + ',1]';
    FldList.add(FldName + '=Bus No^' + VisualFrmNm + '^' + IntToStr(j + 1));

    FldName := 'T2S50.S[' + AllTrim(IntToStr(i)) + ',2]';
    FldList.add(FldName + '=sin^' + VisualFrmNm + '^' + IntToStr(j + 2));


    FldName := 'T2S50[' + AllTrim(IntToStr(i)) + ',0]';
    FldList.add(FldName + '=Bus No^' + VisualFrmNm + '^' + IntToStr(j + 3));

    FldName := 'T2S50[' + AllTrim(IntToStr(i)) + ',1]';
    FldList.add(FldName + '=Bus No^' + VisualFrmNm + '^' + IntToStr(j + 4));

    Inc(j, VisualIncr);
  until J >= 124; //needs 2 less

  OutList := TStringList.Create;

  for i := 0 to FldList.Count - 1 do
  begin
    FldName := GetProfileFldName(FldList[i]);
    if FldName > '' then
    begin
      s := GetValue(FldName);
      OutList.add(FldList[i] + '^' + S);
    end;
  end;

  ConvertedFlName := GpFlName;
  ConvertedFlName := ExtractFileName(GpFlName);
  ConvertedFlName := ChangeFileExt(ConvertedFlName, '.' + TempFlExtension);
  ConvertedFlName := TempDir + '\' + ConvertedFlName;
  OutList.SaveToFile(ConvertedFlName);
  FldList.Free;
  OutList.Free;
  Result := 0;

  //Application.Terminate;  ///remove
end;

function TImportGpT2_2027.ImportOne(ConvertedFlName: string): Integer;
var
  i, j, FNo, FormNo: integer;
  Msg,s: string;
  PrPStatus, EfStatus, Notes, LastYrDir, FormName, Sin: string;
begin
  Result := 9;
  Sin := GetSinNo(ConvertedFlName);
  if Sin = '' then
  begin
    ShowMessage('Cannot Import this file.' + Chr(13) +
      'Business Number cannot be established');
    Result := 1; {no account No}
    exit;
  end;

  VisualFlName := LeftStr(Sin, 9) + '.' + GetVisualExt(VtYearEnd);
  if (FileExists(ToDirBox.Text + '\' + VisualFlName))
    and (ReplaceOptionBox.ItemIndex = 1)
    and (ButtonClicked <> 'OPEN') then
  begin
    ShowTimedMsg('File ' + gpFlName +
      Chr(13) + 'already exists in VisualTax. Skipped', 2000);
    result := 2;
    Exit;
  end;

  if ButtonClicked = 'OPEN' then
  begin
    RetNo := CreateNewReturn;
    if RetNo < 1 then
    begin ShowOpenReturnFailure(RetNo, '', '');
      exit;
    end;
    if RetNo > 0 then
    begin
      Busy; //LockWindowUpdate(MainForm.Handle);
      FormName := 'T2';
      FormNo := GetFormNo(FormName);
      InitFormData(RetNo, FormNo);
      OpenForm(RetNo, FormName, 0); //new child
      UpdateAllDataIndicators(RetNo);
      Ret[RetNo].SourceDataDir := OptRec.Dir_Cur; {fool it}
      Ret[RetNo].Changed := True;
      Busy(False);
    end;
  end
  else
  begin
    RetNo := CreateNewReturn;
    if RetNo < 1 then
    begin ShowOpenReturnFailure(RetNo, '', '');
      exit;
    end;
  end;
  try
    Ret[RetNo].SourceDataDir := ToDirBox.Text; {fooli t}

    StoreData(ConvertedFlName);

    //20171217
    s:=FetchElm(RetNo,'T2',10);
    If MidStr(s,5,1)='-' then begin s:=ReplaceChar(S,'-','/'); StoreElm(RetNo,GetFormNo('T2'),10,s);end;
      s:=FetchElm(RetNo,'T2',11);
      If MidStr(s,5,1)='-' then begin s:=ReplaceChar(S,'-','/'); StoreElm(RetNo,GetFormNo('T2'),11,s);end;

    CalcFed(RetNo);
    FNo := GetFormNo('STATUS');
    for j := 11 to 11 do
      StoreElm(RetNo, FNo, j, User.UserName); //20170112 Igor
    for j := 12 to 12 do
      StoreElm(RetNo, FNo, j, FormatDateTime('yyyy/mm/dd', Date));
    for j := 13 to 13 do
      StoreElm(RetNo, FNo, j, TimeToStr(Time));

    if ButtonClicked <> 'OPEN' then
      SaveIt(VisualFlName);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;
  if ButtonClicked <> 'OPEN' then
  begin
    if RetNo > 0 then
      RemoveReturnFromMemory(RetNo);
  end;
  Result := 0;
  MainForm.GuiCommand(gcShowLeftPanel); //MainForm.LeftPanel.Visible := True; //20160222 Igor
end;

function TImportGpT2_2027.FldNameIsString(FldName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to Length(FldName) do
    if FldName[i] = '[' then
    begin
      if UpperCase(FldName[i - 1]) = 'S' then
      begin result := True;
        exit;
      end;
    end;
end;

function TImportGpT2_2027.GetValue(FldName: WideString): string;
begin
  Result := '';
  try
    result := ProfileClient1.Field[FldName]
  except
    result := FloatToStr(ProfileClient1.Field[FldName]);
    if result = '0' then
      result := '';
  end;
end;

procedure TImportGpT2_2027.FileListBox1DblClick(Sender: TObject);
begin
  OpenBtnClick(Sender);
end;

procedure TImportGpT2_2027.ProfileExtensionBoxChange(Sender: TObject);
begin
  ProfileExtension := ProfileExtensionBox.text;
  ShowFiles;
end;

function TImportGpT2_2027.GpDatetoYYYYMMDD(Valu: string): string;
//20170731 Igor >>>
begin
  Result := FormatDateTime('yyyy/mm/dd', StrToDateTime(Valu, TFormatSettings.Create));
//20170731 Igor<<<
end;

end.

