unit T2_2027BuildGPHist;
{distribution ConvGpT2}
(*
Comments:
Input ConvGpT2  format: T2.S[2]=BN^PAGE 1^1
output in TempDir  Format: above+ ^+value

*)

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, StdCtrls, Grids, DBGrids, DBCtrls, Menus, Buttons,
  FileCtrl, ShellApi, ComObj, olectnrs, OleServer, Mask, ComCtrls,
  VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart;

const
  ThisPackage = 'T2';
  TempFlExtension = 'EXP';
  FieldsFlName = 'ConvGpT2.D';
  TempDirName = 'TempDir';

type
  TBuildGPHistT2_2027 = class(TForm)
    OpenDialog1: TOpenDialog;
    Chart1: TChart;
    OptionsGroupBox: TGroupBox;
    ReplaceOptionBox: TRadioGroup;
    ActionsGroupBox: TGroupBox;
    OKBtn: TBitBtn;
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
    Profile2005Box: TCheckBox;
    Label7: TLabel;

    function GetNumberOfTableRows(ProfileFrmNm, ProfileTableNm: string): Integer;
    function GetVisualExt(VtYearEnd: string): string;
    function GetProfileFldName(S: string): string;
    function GetValue(FldName: WideString): string;
    function ConvertOne(GpFlName: string): Integer;
    function FldNameIsString(FldName: string): Boolean;
    function FixValu(FName, Valu: string; FNo, Elm: Integer): string;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveIt(FlName: string);
    procedure StoreData(ConvertedFlName: string);
    function ImportOne(ConvertedFlName: string): Integer;
    {procedure HelpBtnClick(Sender: TObject);}
    function GetSinNo(ConvertedFlName: string): string;
    procedure OKBtnClick(Sender: TObject);
    procedure SelectDirBtn1Click(Sender: TObject);
    procedure SelectDirBtn2Click(Sender: TObject);
    procedure ShowFiles;
    procedure FromDirBoxExit(Sender: TObject);
    procedure FromDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure ProfileExtensionBoxChange(Sender: TObject);
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

var
  BuildGPHist: TBuildGPHistT2_2027;

  ProfileFile1: Variant;
  ProfileClient1: Variant;

  GPFlName, ConvertedFlName, VisualFlName: string;
  ProfileExtension: string; //'GT2';
  GPYearEnd, VTYearEnd: string; //[10];
  {RetNo : integer;}
  Cnt: integer;
  InitialRowCount: integer;

  TempDir: string;

implementation

{$R *.DFM}

uses
  vtCommon, vtDialogs,
  //T2_2027SelectDir,
  T2_2027, T2_2027Main, T2_2027Declare,
  T2_2027TrimStr, T2_2027Common, T2_2027Common2, T2_2027ChildWinNew, T2_2027Calc,
  T2_2027DirOpt, T2_2027Profile_TLB,
  vtTrimStr, vtShared;

procedure TBuildGPHistT2_2027.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FRetNo := GetCurrentRetNo;
  ToDirBox.Text := OptRec.Dir_Cur;
  ProfileExtensionBox.Text := 'GT2'; {ProfileExtension;}
  ProfileExtension := ProfileExtensionBox.Text;
  {remove it}
  FromDirBox.Text := OptRec.Dir_LastYr;
  TempDir := AppDir + '\' + TempDirName;
  if SysUtils.DirectoryExists(TempDir) then //20150702
  else
    MkDir(TempDir);

  ShowFiles;
end;

procedure TBuildGPHistT2_2027.CancelBtnClick(Sender: TObject);
begin
  Close;

end;

function TBuildGPHistT2_2027.GetVisualExt(VtYearEnd: string): string;
var
  i: Integer;
  TwoDigitYE: string; //[2];
begin
  TwoDigitYE := MidStr(VTYearEnd, 3, 2);
  Result := FillLeftZeros(AllTrim(TwoDigitYE), 2);
end;

procedure TBuildGPHistT2_2027.SaveIt(FlName: string);
begin
  if not SaveReturn(RetNo, ToDirBox.Text, FlName, True, True) = 0 then
    ShowMessage('Save of data failed')
  else
    Inc(Cnt);
end;

procedure TBuildGPHistT2_2027.ShowFiles;
begin
  FileListBox1.Directory := FromDirBox.Text;
  FileListBox1.Mask := '*.' + ProfileExtensionBox.text;
  FileListBox1.ItemIndex := 0;
  FilesGroupBox.Caption := 'FILES: ' + IntTostr(FileListBox1.Items.count);
end;

procedure TBuildGPHistT2_2027.StoreData(ConvertedFlName: string);
var
  i, j, FNo, Elm: Integer;
  FName, Valu: string;
  ConvList, WList: TStringList;
begin
  ConvList := TStringList.Create; // 20150702
  WList := TStringList.Create;
  ConvList.LoadFromFile(ConvertedFlName);

  // 20150702 reorganized try except block to be inside loop
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
            MessageDlg(ConvList[i] + ' ' + E.Message, mtError, [mbok], 0);
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
          {
          StoreElm(RetNo,FNo,14,'VisualTax');
          For j:=15 to 18 do StoreElm(RetNo,FNo,j,'Profile');
         }
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

function TBuildGPHistT2_2027.GetSinNo(ConvertedFlName: string): string;
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

procedure TBuildGPHistT2_2027.OKBtnClick(Sender: TObject);
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

  Screen.Cursor := crHourGlass;
  GPFlName := FromDirBox.Text + '\' + FileListBox1.Items[FileListBox1.ItemIndex];
  if (ConvertOne(GpFlName) = 0) and (ImportOne(ConvertedFlName) = 0) then
  begin
    OpenForm(RetNo, 'COMPSUM', 0);
    Ret[RetNo].Changed := True;
    Screen.Cursor := crDefault;
    Close;
  end;
end;

procedure TBuildGPHistT2_2027.SelectDirBtn1Click(Sender: TObject);
begin
  SelectedDir := SelectDir;
  //ExecuteForm(TSelectDirT2_2027);
  if SelectedDir > '' then
    FromDirBox.Text := SelectedDir;
  ShowFiles;
end;

procedure TBuildGPHistT2_2027.SelectDirBtn2Click(Sender: TObject);
begin
  ExecuteForm(TDirOptT2_2027);
  ToDirBox.Text := OptRec.Dir_Cur;
end;

function TBuildGPHistT2_2027.FixValu(FName, Valu: string; FNo, Elm: Integer): string;
begin
  Result := Valu;
  {
  If (FName='S321')
  or (FName='S480') then
  begin
   If valu ='0' then result:='';
  end;
  }
end;

procedure TBuildGPHistT2_2027.FromDirBoxExit(Sender: TObject);
begin
  ShowFiles;
end;

procedure TBuildGPHistT2_2027.FromDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ShowFiles;
end;

function TBuildGPHistT2_2027.GetProfileFldName(S: string): string;
var
  WList: TStringList;
begin
  if s = '' then
  begin Result := '';
    exit;
  end;
  WList := TstringList.Create;
  ParseWords(S, '=', WList);
  Result := Wlist[0];
  WList.Free;
end;

function TBuildGPHistT2_2027.GetNumberOfTableRows(ProfileFrmNm, ProfileTableNm: string): Integer;
var
  i, FCount: Integer;
begin
  FCount := ProfileClient1.FormCount[ProfileFrmNm];
  Result := 0;
  for i := 0 to FCount - 1 do
  begin
    Result := Result + ProfileClient1.TableItemCount[ProfileTableNm, i];
  end;
end;

function TBuildGPHistT2_2027.ConvertOne(GpFlName: string): Integer;
var
  s: string;
  FldName: string;
  Item: Variant;
  FldList, OutList: TStringList;
  i, j, ii, VisualInst, VisualIncr, FCount, TableRows, MaxVisualRowsPerInst: Integer;
  ProfileFrmNm, VisualFrmNm, ProfileTableNm, VisualFldDescr: string;
begin
  Result := 9;

  if Profile2005Box.Checked then
    ProfileFile1 := {Profile_tlb.} CoT2004T2File.Create
  else
    ProfileFile1 := {Profile_tlb.} CoT2002T2File.Create;

  // ProfileFile1  :=  Profile_tlb.CoT1998T2File.Create;

  ProfileClient1 := ProfileFile1.Client; {property}
  ProfileFile1.LoadFile(GpFlName, True);
  ProfileClient1.Calculate;
  //get values of fields
  GPYearEnd := MMDDYYYYToYYYYMMDD(GetValue('T2Info[2]'));
  VTYearEnd := AdvanceYearEnd(GPYearEnd);

  FldList := TStringList.Create;
  FldList.LoadFromFile(AppDir + '\' + FieldsFlName);

  OutList := TStringList.Create;

  for i := 0 to FldList.Count - 1 do
  begin
    FldName := GetProfileFldName(FldList[i]);
    if LeftStr(FldName, 9) = 'T2Summary' then
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
end;

function TBuildGPHistT2_2027.ImportOne(ConvertedFlName: string): Integer;
var
  i, j, FNo: integer;
  Msg: string;
  PrPStatus, EfStatus, Notes, LastYrDir, Sin: string;
begin
  Result := 9;
  Sin := RemoveChar(GetValue('T2.S[2]'), ' ');
  if Sin <> GetCorpBusNo(RetNo) then
  begin
    if MessageDlg('Current B/N is ' + GetCorpBusNo(RetNo) +
      Chr(13) +
      'The imported B/N is ' + Sin + ' Proceed anyway?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    begin
      ShowMessage('Import cancelled');
      Result := 1; {no account No}
      exit;
    end;
  end;
  try
    {Ret[RetNo].SourceDataDir := ToDirBox.Text;}{fooli t}
    StoreData(ConvertedFlName);
    CalcFed(RetNo);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;
  Result := 0;
end;

function TBuildGPHistT2_2027.FldNameIsString(FldName: string): Boolean;
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

function TBuildGPHistT2_2027.GetValue(FldName: WideString): string;
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

procedure TBuildGPHistT2_2027.FileListBox1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;

procedure TBuildGPHistT2_2027.ProfileExtensionBoxChange(Sender: TObject);
begin
  ProfileExtension := ProfileExtensionBox.text;
  ShowFiles;
end;

end.

