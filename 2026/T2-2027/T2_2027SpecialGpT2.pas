unit T2_2027specialgpt2;
// revision 2014-07-29

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
  FileCtrl, ShellApi, Mask, ComCtrls, VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, ComObj, olectnrs,
  OleServer, T2_2027Profile_TLB;

const
  ThisPackage = 'T2';
  TempFlExtension = 'EXP';
  FieldsFlName = 'SpecialGpT2-2009.d';
  TempDirName = 'TempDir';

type
  TSpecialGpT2_2027 = class(TForm)
    OpenDialog1: TOpenDialog;
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
    HelpBtn: TBitBtn;
    Label8: TLabel;
    Label4: TLabel;
    HowManyBox: TEdit;
    Label5: TLabel;
    statuslbl: TLabel;
    ProfileVersionBox: TRadioGroup;

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
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SpecialGpT2_2027: TSpecialGpT2_2027;

  ProfileFile1: IProfileFile; //  Variant;  //20100204
  ProfileClient1: IProfileClient; //Variant;        //20100204
  {
  ProfileFile1:Variant;
  ProfileClient1:Variant;
  }
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

procedure TSpecialGpT2_2027.FormCreate(Sender: TObject);
var
  i: Integer;
begin

  ButtonClicked := '';
  ToDirBox.Text := OptRec.Dir_Cur; //20100905 //'C:\Documents and Settings\User\My Documents\My VisualTax RolledOver Files'; //OptRec.Dir_Cur;
  ProfileExtensionBox.Text := 'GT2'; {ProfileExtension;}
  ProfileExtension := ProfileExtensionBox.Text;
  {remove it}

  HowManyBox.Text := '10';

  FromDirBox.Text := OptRec.Dir_LastYr;
  TempDir := AppDir + '\' + TempDirName;
  if SysUtils.DirectoryExists(TempDir) then //20150701
  else
    MkDir(TempDir);

  ShowFiles;
end;

procedure TSpecialGpT2_2027.CancelBtnClick(Sender: TObject);
begin
  Close;

end;

procedure TSpecialGpT2_2027.ImportAllBtnClick(Sender: TObject);
var
  i, k: Integer;
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

  k := FileListBox1.Itemindex;
  FileListBox1.Refresh;

  for i := k to FileListBox1.Items.Count - 1 do
  begin

    if i > k - 1 + Vl(HowManyBox.Text) then
      break;

    if Flist.Count > 5 then
    begin
      Flist.Free;
      InitFormsTable;
    end;

    FileListBox1.ItemIndex := i;
    //  FileListBox1.Selected[i] := true;
    FileListBox1.Refresh;

    GPFlName := FromDirBox.Text + '\' + FileListBox1.Items[FileListBox1.ItemIndex];

    statuslbl.caption := 'Importing: ' + GpFlName;
    statuslbl.refresh;
    delay(500);

    if ConvertOne(GpFlName) = 0 then
      ImportOne(ConvertedFlName);
  end;
  Screen.Cursor := crDefault;

  statuslbl.caption := 'Complete';

  ShowMessage('Total returns imported= ' + IntToStr(cnt)
    + Chr(13) + 'You can now Exit and use Open from the VisualTax Main Menu');
  ButtonClicked := '';
end;

function TSpecialGpT2_2027.GetVisualExt(VtYearEnd: string): string;
var
  i: Integer;
  TwoDigitYE: string; //[2];
begin
  TwoDigitYE := MidStr(VTYearEnd, 3, 2);
  Result := FillLeftZeros(AllTrim(TwoDigitYE), 2);
end;

procedure TSpecialGpT2_2027.SaveIt(FlName: string);
begin
  if not SaveReturn(RetNo, ToDirBox.Text, FlName, True, True) = 0 then
    ShowMessage('Save of data failed')
  else
    Inc(Cnt);
end;

procedure TSpecialGpT2_2027.ShowFiles;
begin
  FileListBox1.Directory := FromDirBox.Text;
  FileListBox1.Mask := '*.' + ProfileExtensionBox.text;

  //FileListBox1.Selected[0] := true;

  FileListBox1.ItemIndex := 0;

  FilesGroupBox.Caption := 'FILES: ' + IntTostr(FileListBox1.Items.count);
end;

procedure TSpecialGpT2_2027.StoreData(ConvertedFlName: string);
var
  i, j, FNo, Elm: Integer;
  FName, Valu: string;
  ConvList, WList: TStringList;
begin
  ConvList := TStringList.Create;
  WList := TStringList.Create;
  ConvList.LoadFromFile(ConvertedFlName);

  // 20150702 reorganized try except to be inside loop
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

procedure TSpecialGpT2_2027.HelpBtnClick(Sender: TObject);
begin
  //Application.HelpFile :=AppDir+'\'+'T2UpdHlp.HLP';
  ShowHelp(AppT2.ModuleHelpFile, 'RolloverFromProfile', True); //20170112 Igor
end;

function TSpecialGpT2_2027.GetSinNo(ConvertedFlName: string): string;
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
      ParseWords(ConvList[i], '', WList);
      Result := LeftStr(AllTrim(RemoveChar(WList[3], ' ')), 9);
      Break;
    end;
  end;
  ConvList.Free;
  WList.Free;
end;

procedure TSpecialGpT2_2027.OpenBtnClick(Sender: TObject);
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
  if (ConvertOne(GpFlName) = 0) and (ImportOne(ConvertedFlName) = 0) then
  begin
    {ShowMessage('Done');}
    MainFormT2.RecalcBtnClick(Application);
    OpenForm(RetNo, GetFormNo('T2'), 0);
    Ret[RetNo].Changed := True;
    Screen.Cursor := crDefault;
    Close;
  end;
  ButtonClicked := '';
end;

procedure TSpecialGpT2_2027.SelectDirBtn1Click(Sender: TObject);
var
  DirSelected: string; //20150622
const
  SELDIRHELP = 1000;

begin
  DirSelected := fromDirBox.text;

  if SelectDirectory(DirSelected, [sdAllowCreate, sdPerformCreate, sdPrompt], SELDIRHELP) then
  begin
    FromDirBox.Text := DirSelected;
  end;
  ShowFiles;
end;

procedure TSpecialGpT2_2027.SelectDirBtn2Click(Sender: TObject);
var
  DirSelected: string;
begin
  if SelectDirectory('Select a folder:', '', DirSelected, []) then
  begin
    ToDirBox.Text := DirSelected;
  end;
  ShowFiles;

  {
   Application.CreateForm(TDirOpt,DirOpt);
   DirOpt.ShowModal;
   DirOpt.Free;
   ToDirBox.Text:=OptRec.Dir_Cur;
  }
end;

function TSpecialGpT2_2027.FixValu(FName, Valu: string; FNo, Elm: Integer): string;
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
        result := MMDDYYYYToYYYYMMDD(Valu); //result:=AdvanceYearEnd(MMDDYYYYToYYYYMMDD(Valu));
      61:
        result := MMDDYYYYToYYYYMMDD(Valu);

      24: if Valu = '1' then
        begin result := 'X';
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
        begin
          Result := 'X';
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

  if FName = 'T2' then
  begin
    case Elm of
      203:
        begin
          if Valu = '1' then
          begin
            Result := 'X';
            StoreElm(RetNo, FNo, 3, 'X');
          end
        end;
    end;
  end;

  //pg8
  if FName = 'T2' then
  begin
    case elm of
      747:
        begin
          if Valu = '1' then
          begin
            Result := 'X';
            StoreElm(RetNo, FNo, 747, 'X');
          end;
          if Valu = '0' then
          begin
            Result := '';
            StoreElm(RetNo, FNo, 748, 'X');
          end;
        end;

      755:
        begin
          result := RemoveChar(valu, '(');
          result := RemoveChar(result, ')');
          result := RemoveChar(result, ' '); //phone as 999888-8888
          if Length(Result) > 3 then
            StoreElm(RetNo, FNo, 746, MidStr(Result, 4, 8));
          result := LeftStr(Result, 3); //are only
        end;

      756:
        begin
          result := RemoveChar(valu, '(');
          result := RemoveChar(result, ')');
          result := RemoveChar(result, ' '); //phone as 999888-8888
          if Length(Result) > 3 then
            StoreElm(RetNo, FNo, 750, MidStr(Result, 4, 8));
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
        result := DDMMYYYYToYYYYMMDD(Valu);
      2, 13, 24, 35, 46, 57, 68, 79, 90, 101, 112, 123:
        result := DDMMYYYYToYYYYMMDD(Valu);
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

  { //20170525
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

  if FName = 'OPG_1' then {inc date}
  begin
    if elm = 38 then
    begin
      if (valu <> '') and (valu <> '0') then
        result := MMDDYYYYToYYYYMMDD(Valu);
    end;
  end;

  if (FName = 'S321')
    or (FName = 'S340')
    // or (FName='S344')  //20121207
  or (FName = 'S360')
    or (FName = 'S380')
    or (FName = 'S381')
    or (FName = 'S402')
    or (FName = 'S403')
   // or (FName = 'S426')   //20170525
   // or (FName = 'S460')  //20181114
   //or (FName='S480') then
  then
  begin
    if valu = '0' then
      result := '';
  end;
end;

function TSpecialGpT2_2027.ConvertProvOfRes(Valu: string): string;
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

procedure TSpecialGpT2_2027.FromDirBoxExit(Sender: TObject);
begin
  ShowFiles;
end;

procedure TSpecialGpT2_2027.FromDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ShowFiles;
end;

function TSpecialGpT2_2027.GetProfileFldName(S: string): string;
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

function TSpecialGpT2_2027.GetNumberOfTableRows(ProfileFrmNm, ProfileTableNm: string): Integer;
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

function TSpecialGpT2_2027.ConvertOne(GpFlName: string): Integer;
var
  s: string;
  FldName: string;
  Item: Variant;
  FldList, OutList: TStringList;
  i, j, ii, VisualInst, VisualIncr, FCount, TableRows, MaxVisualRowsPerInst: Integer;
  ProfileFrmNm, VisualFrmNm, ProfileTableNm, VisualFldDescr, ProfileInstance: string;
begin
  Result := 9;

  ProfileFile1 := {Profile_tlb.} CoT2010T2File.Create; //20100905
  // ProfileFile1  :=  Profile_tlb.CoT2008T2File.Create;  //20100204
   //now try to create a newer version, nothing changed on an exception
  try
    case ProfileVersionBox.Itemindex of
      0:
        begin
          ProfileFile1 := {Profile_tlb.} CoT2010T2File.Create; //20100905
          //ProfileFile1  :=  Profile_tlb.CoT2009T2File.Create;
        end;
      1:
        begin
          //
        end;
      2:
        begin
          ProfileFile1 := {Profile_tlb.} CoT2011T2File.Create; //20120328
        end;
    else
      //ProfileFile1  := Profile_tlb.CoT2008T2File.Create;
    end;
  except
    on E: Exception do
    begin
      Application.ShowException(E);
      ShowTimedMsg('Problem creating T2009 interface', 1500);
    end;
  end;

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
    If Profile2008Box.Checked then
      ProfileFile1  :=  Profile_tlb.CoT2009T2File.Create
    else
     ProfileFile1  := Profile_tlb.CoT2008T2File.Create;

    ProfileClient1:= ProfileFile1.Client;  {property}
    ProfileFile1.LoadFile(GpFlName,True);
    ProfileClient1.Calculate;

    *)

    //get values of fields
  GPYearEnd := MMDDYYYYToYYYYMMDD(GetValue('T2Info[2]'));

  //VTYearEnd:= AdvanceYearEnd(GPYearEnd);
  VTYearEnd := GPYearEnd; //do not advance for the special

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
    FldList.add(FldName + '=don year' + VisualFrmNm + '' + IntToStr(j));

    FldName := 'T2S2[' + AllTrim(IntToStr(i + 50)) + ']';
    FldList.add(FldName + '=don end bal' + VisualFrmNm + '' + IntToStr(j + 1));
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
    FldList.add(FldName + '=gifts year' + VisualFrmNm + '' + IntToStr(j));

    FldName := 'T2S2[' + AllTrim(IntToStr(i + 50)) + ']';
    FldList.add(FldName + '=gifts end bal' + VisualFrmNm + '' + IntToStr(j + 1));
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
    FldList.add(FldName + '=cult year' + VisualFrmNm + '' + IntToStr(j));

    FldName := 'T2S2[' + AllTrim(IntToStr(i + 50)) + ']';
    FldList.add(FldName + '=cult end bal' + VisualFrmNm + '' + IntToStr(j + 1));
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
    FldList.add(FldName + '=ecol year' + VisualFrmNm + '' + IntToStr(j));

    FldName := 'T2S2[' + AllTrim(IntToStr(i + 50)) + ']';
    FldList.add(FldName + '=ecol end bal' + VisualFrmNm + '' + IntToStr(j + 1));
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
    //get class id
    FldName := GetProfileFldName('T2S8Table.S[' + AllTrim(IntToStr(i)) + ',1]'); //1=CCA class
    FldList.add(FldName + '=CCA class' + VisualFrmNm + '#' + IntToStr(VisualInst) + '' + IntToStr(j));
    //get UCC start of year
    FldName := GetProfileFldName('T2S8Table[' + AllTrim(IntToStr(i)) + ',11]'); //26]'); //26=CCA UCC
    FldList.add(FldName + '=CCA UCC' + VisualFrmNm + '#' + IntToStr(VisualInst) + '' + IntToStr(j + 1));

    Inc(j, VisualIncr);
  until i >= TableRows - 2; //needs 2 less

  //S8LH  first
  ProfileFrmNm := 'S8L';
  ProfileTableNm := 'T2S8LTable';
  TableRows := 12; //GetNumberOfTableRows(ProfileFrmNm,ProfileTableNm);
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

    FldName := GetProfileFldName('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',6]'); //18]');  //ucc
    if Vl(GetValue(FldName)) > 0 then //only if UCC move to next row
    begin
      FldList.add(FldName + '=CCA-L UCC' + VisualFrmNm + '' + IntToStr(j + 3));
      FldName := GetProfileFldName('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',2]'); //start yr
      FldList.add(FldName + '=CCA-L start yr' + VisualFrmNm + '' + IntToStr(j));

      FldName := GetProfileFldName('T2S8L[' + ProfileInstance + ',0]'); //end yr
      FldList.add(FldName + '=CCA-L end yr' + VisualFrmNm + '' + IntToStr(j + 1));

      FldName := GetProfileFldName('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',1]'); //orig cost
      FldList.add(FldName + '=CCA-L UCC' + VisualFrmNm + '' + IntToStr(j + 2));
      Inc(j, VisualIncr);
    end;
  until i >= TableRows - 2; //needs 2 less

  //S8LH  instances 1
  ProfileFrmNm := 'S8L';
  ProfileTableNm := 'T2S8LTable';
  TableRows := 12; //GetNumberOfTableRows(ProfileFrmNm,ProfileTableNm);
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

    FldName := GetProfileFldName('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',6]'); //18]');  //ucc
    if Vl(GetValue(FldName)) > 0 then //only if UCC move to next row
    begin
      FldList.add(FldName +
        '=CCA-L UCC' + VisualFrmNm +
        '' + IntToStr(j + 3));
      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',2]'); //start yr
      FldList.add(FldName
        + '=CCA-L start yr' + VisualFrmNm + '' + IntToStr(j));

      FldName := GetProfileFldName('T2S8L[' + ProfileInstance + ',0]'); //end yr
      FldList.add(FldName
        + '=CCA-L end yr' + VisualFrmNm + '' + IntToStr(j + 1));

      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',1]'); //orig cost
      FldList.add(FldName +
        '=CCA-L UCC' + VisualFrmNm +
        '' + IntToStr(j + 2));

      Inc(j, VisualIncr);
    end;
  until i >= TableRows - 2; //needs 2 less

  //S8LH  instances 2
  ProfileFrmNm := 'S8L';
  ProfileTableNm := 'T2S8LTable';
  TableRows := 12; //GetNumberOfTableRows(ProfileFrmNm,ProfileTableNm);
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

    FldName := GetProfileFldName('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',6]'); //18]');  //ucc
    if Vl(GetValue(FldName)) > 0 then //only if UCC move to next row
    begin
      FldList.add(FldName +
        '=CCA-L UCC' + VisualFrmNm +
        '' + IntToStr(j + 3));
      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',2]'); //start yr
      FldList.add(FldName
        + '=CCA-L start yr' + VisualFrmNm + '' + IntToStr(j));

      FldName := GetProfileFldName('T2S8L[' + ProfileInstance + ',0]'); //end yr
      FldList.add(FldName
        + '=CCA-L end yr' + VisualFrmNm + '' + IntToStr(j + 1));

      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',1]'); //orig cost
      FldList.add(FldName +
        '=CCA-L UCC' + VisualFrmNm +
        '' + IntToStr(j + 2));

      Inc(j, VisualIncr);
    end;
  until i >= TableRows - 2; //needs 2 less

  //S8LH  instances 3
  ProfileFrmNm := 'S8L';
  ProfileTableNm := 'T2S8LTable';
  TableRows := 12; //GetNumberOfTableRows(ProfileFrmNm,ProfileTableNm);
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

    FldName := GetProfileFldName('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',6]'); //18]');  //ucc
    if Vl(GetValue(FldName)) > 0 then //only if UCC move to next row
    begin
      FldList.add(FldName +
        '=CCA-L UCC' + VisualFrmNm +
        '' + IntToStr(j + 3));
      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',2]'); //start yr
      FldList.add(FldName
        + '=CCA-L start yr' + VisualFrmNm + '' + IntToStr(j));

      FldName := GetProfileFldName('T2S8L[' + ProfileInstance + ',0]'); //end yr
      FldList.add(FldName
        + '=CCA-L end yr' + VisualFrmNm + '' + IntToStr(j + 1));

      FldName := GetProfileFldName
        ('T2S8LTable[' + ProfileInstance + ',' + AllTrim(IntToStr(i)) + ',1]'); //orig cost
      FldList.add(FldName +
        '=CCA-L UCC' + VisualFrmNm +
        '' + IntToStr(j + 2));

      Inc(j, VisualIncr);
    end;
  until i >= TableRows - 2; //needs 2 less

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
    FldList.add(FldName + '=Shareholder' + VisualFrmNm + '' + IntToStr(j));

    FldName := 'T2S9.S[' + AllTrim(IntToStr(i)) + ',1]';
    FldList.add(FldName + '=Country' + VisualFrmNm + '' + IntToStr(j + 1));

    FldName := 'T2S9.S[' + AllTrim(IntToStr(i)) + ',2]';
    FldList.add(FldName + '=Bus No' + VisualFrmNm + '' + IntToStr(j + 2));

    FldName := 'T2S9.S[' + AllTrim(IntToStr(i)) + ',3]';
    FldList.add(FldName + '=Code' + VisualFrmNm + '' + IntToStr(j + 3));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',0]';
    FldList.add(FldName + '=Comm shares' + VisualFrmNm + '' + IntToStr(j + 4));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',1]';
    FldList.add(FldName + '=Comm shares%' + VisualFrmNm + '' + IntToStr(j + 5));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',2]';
    FldList.add(FldName + '=Pref shares' + VisualFrmNm + '' + IntToStr(j + 6));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',3]';
    FldList.add(FldName + '=Pref shares%' + VisualFrmNm + '' + IntToStr(j + 7));

    FldName := 'T2S9[' + AllTrim(IntToStr(i)) + ',4]';
    FldList.add(FldName + '=Bk Val Cap stock' + VisualFrmNm + '' + IntToStr(j + 8));

    Inc(j, VisualIncr);
  until J >= 130;

  //S13-cap gains
  VisualFrmNm := 'S13';
  VisualIncr := 4;
  j := 4; //fld in visualtax
  i := 0; //row in profile: start at second row due to increase in year
  repeat
    FldName := 'T2S13CapitalGains.S[' + AllTrim(IntToStr(i)) + ',0]';
    FldList.add(FldName + '=descr' + VisualFrmNm + '' + IntToStr(j));

    FldName := 'T2S13CapitalGains[' + AllTrim(IntToStr(i)) + ',0]'; //2]';
    FldList.add(FldName + '=end bal' + VisualFrmNm + '' + IntToStr(j + 1));

    Inc(i);
    Inc(j, VisualIncr);
  until J > 24;

  //S13-other reserves
  VisualFrmNm := 'S13';
  VisualIncr := 3;
  j := 31; //fld in visualtax
  i := 5; //7; //row in profile: start at second row due to increase in year
  repeat
    FldName := 'T2S13[' + AllTrim(IntToStr(i)) + ']';
    FldList.add(FldName + '=end bal' + VisualFrmNm + '' + IntToStr(j));
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
    FldList.add(FldName + '=Shareholder' + VisualFrmNm + '' + IntToStr(j));

    FldName := 'T2S50.S[' + AllTrim(IntToStr(i)) + ',1]';
    FldList.add(FldName + '=Bus No' + VisualFrmNm + '' + IntToStr(j + 1));

    FldName := 'T2S50.S[' + AllTrim(IntToStr(i)) + ',2]';
    FldList.add(FldName + '=sin' + VisualFrmNm + '' + IntToStr(j + 2));

    FldName := 'T2S50[' + AllTrim(IntToStr(i)) + ',0]';
    FldList.add(FldName + '=Bus No' + VisualFrmNm + '' + IntToStr(j + 3));

    FldName := 'T2S50[' + AllTrim(IntToStr(i)) + ',1]';
    FldList.add(FldName + '=Bus No' + VisualFrmNm + '' + IntToStr(j + 4));

    Inc(j, VisualIncr);
  until J >= 124; //needs 2 less

  OutList := TStringList.Create;

  for i := 0 to FldList.Count - 1 do
  begin
    FldName := GetProfileFldName(FldList[i]);
    //if (FldName = 'T2Info.S[87]') or (FldName = 'T1092[3]') or (FldName = 'T1092[2]') then showmessage(FldName);
    if FldName > '' then
    begin
      s := GetValue(FldName);
      OutList.add(FldList[i] + '' + S);
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

function TSpecialGpT2_2027.ImportOne(ConvertedFlName: string): Integer;
var
  i, j, FNo, FormNo: integer;
  Msg: string;
  PrPStatus, EfStatus, Notes, LastYrDir, FormName, Sin: string;
  MyRet: TRetT2_2027;
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
    // MainForm.FileNewItemClick(Application)
  begin
    RetNo := CreateNewReturn;
    if RetNo < 1 then
    begin ShowOpenReturnFailure(RetNo, '', '');
      exit;
    end;
    if RetNo > 0 then
    begin
      Busy; //LockWindowUpdate(MainForm.Handle);
      //MainForm.LeftPanel.Visible:=True;
      FormName := 'T2';
      FormNo := GetFormNo(FormName);
      InitFormData(RetNo, FormNo);
      // CountDiagnostics(RetNo);
      OpenForm(RetNo, FormNo, 0); //new child
      UpdateAllDataIndicators(RetNo);
      Ret[RetNo].SourceDataDir := OptRec.Dir_Cur; {fool it}
      Ret[RetNo].Changed := True;
      Done;
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

function TSpecialGpT2_2027.FldNameIsString(FldName: string): Boolean;
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

function TSpecialGpT2_2027.GetValue(FldName: WideString): string;
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

procedure TSpecialGpT2_2027.FileListBox1DblClick(Sender: TObject);
begin
  OpenBtnClick(Sender);
end;

procedure TSpecialGpT2_2027.ProfileExtensionBoxChange(Sender: TObject);
begin
  ProfileExtension := ProfileExtensionBox.text;
  ShowFiles;
end;

procedure TSpecialGpT2_2027.FormPaint(Sender: TObject);
begin
  { does not work
  If (LatestVersion.checked = false)
   and (Profile2005Box.Checked = false)
   then
    LatestVersion.Checked:=True;
   If Profile2005Box.Checked = True then LatestVersion.Checked:=False;
   If LatestVersion.Checked=True then Profile2005Box.Checked:= False;
  }
end;

end.

