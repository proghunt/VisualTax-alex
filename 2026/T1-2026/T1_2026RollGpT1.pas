unit T1_2026RollGpT1;
// updated 07-28

{ distribution RollGpT1.d }
(*
  Comments:
  Input RollGpT1.d  format: T1.S[2]=SIN^PAGE^1
  output in TempDir  Format: above+ ^+value
*)

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, StdCtrls, Grids, DBGrids, DBCtrls, Menus, Buttons,
  FileCtrl, ShellApi, Mask, ComCtrls, T1_2026Common, VclTee.TeeProcs,
  VclTee.TeEngine, VclTee.Chart, ComObj,
  olectnrs, OleServer, VclTee.TeeGDIPlus, T1_2026Profile_TLB; // 20181116

Const
  TempFlExtension = 'EXP';
  FieldsFlName = 'RollGpT1.d';
  TempDirName = 'TempDir';

type
  TRollGpT1_2026 = class(TForm)
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
    PopupMenu1: TPopupMenu;
    Label8: TLabel;
    HelpBtn: TBitBtn;
    ProcessingLbl: TLabel;
    Label5: TLabel;
    HowManyBox: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    SpouseBox: TCheckBox;
    LinkToOptionsLbl: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Psw: TEdit;
    Chart1: TChart;
    Label4: TLabel;


    // Procedure AddExtraSchedules;
    // Procedure SpecialPopulateAssets(RetNo:Integer);  //from ccalist

    Procedure ConsolIntoT2125(RetNo: Integer; ReverseCCA: Boolean);
    // one time routine
    Procedure ReviseAssetsLinks(RetNo: Integer; ReverseCCA: Boolean);
    Procedure SpCaptureCCALastYear(RetNo: Integer);
    procedure GetHBPandLLP(RetNo: Integer);
    // Procedure CheckDateFormat; //20170731 Igor
    Function FixMarStatus(Valu: String): Integer;
    Function FixValu(FName, Valu: String; FNo, Elm: Integer): String;
    Function ConvertDepRelationship(Valu: String): String;
    Function ConvertProvOfRes(Valu: String): String;
    Function GetVisualExt(VtYearEnd: String): String;
    function GetValue(FldName: WideString): String;
    Function ConvertOne(GpFlName: String; ClientOrSpouse: String): Integer;
    Function FldNameIsString(FldName: String): Boolean;

    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ImportAllBtnClick(Sender: TObject);
    procedure ImportAll;
    procedure SaveIt(FlName: String);
    procedure StoreData(ConvertedFlName: String);
    Function ImportOne(ConvertedFlName: String; ClientOrSpouse: String)
      : Integer;
    procedure HelpBtnClick(Sender: TObject);
    Function GetSinNo(ClientOrSpouse: string): String;
    procedure OpenBtnClick(Sender: TObject);
    procedure SelectDirBtn1Click(Sender: TObject);
    procedure SelectDirBtn2Click(Sender: TObject);
    procedure ShowFiles;
    procedure FromDirBoxExit(Sender: TObject);
    procedure FromDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure ProfileExtensionBoxChange(Sender: TObject);
    Procedure FixBusStatements(RetNo: Integer);
    Procedure FixRefundLine(RetNo: Integer);
    Procedure SplitFldLists;
    Procedure ReplaceNdxWithStm(Var TmpList: TStringList; StmId: String;
      StmNo: Integer);
    Function IsBusStatement(FldName: String): Boolean;
    Function OpenAReturn(GpFlName: String; ClientOrSpouse: String): Boolean;
    procedure BitBtn1Click(Sender: TObject);
    Procedure FixNISASin(RetNo: Integer);
    procedure LinkToOptionsLblClick(Sender: TObject);
  private
    { Private declarations }
  public
    RetNo: Integer;
    SpousePrefix: String;
    ProfileFile1: IProfileFile;
    ProfileClient1: IProfileClient;

    FldList, T2125List, T2121List, T2042List, T776List: TStringList;
    T2125CCAList, T2121CCAList, T2042CCAList, T776CCAList { ,T1164CCAList }
      : TStringList;
    ButtonClicked: String;
    GpFlName, ConvertedFlName, VisualFlName: String;
    ProfileExtension: String;
    GPYearEnd, VtYearEnd: string; // [10];
    Cnt: Integer;
    InitialRowCount: Integer;

    TempDir: String;
  end;

var
  RollGpT1: TRollGpT1_2026;

implementation

{$R *.DFM}

uses vtMulti, vtCommon, vtDialogs, vtMain, T1_2026, T1_2026Declare,
  T1_2026TrimStr,
  T1_2026Common2, T1_2026ChildWinNEW, T1_2026Calc, T1_2026CalcBus,
  T1_2026OptionsFrm, T1_2026T1Rtns, T1_2026Main, vtTrimStr,
  vtShared, Variants;

procedure TRollGpT1_2026.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  // ShortDateFormat:='MM/dd/yyyy';
  SpousePrefix := '';
  ProcessingLbl.Caption := '';
  HowManyBox.Text := '10';
  SplitFldLists;
  ButtonClicked := '';
  ToDirBox.Text := OptRec.Dir_Cur;
  ProfileExtensionBox.Text := '24T';
  // 202500129 // 40126 //20221216 from 20T to 21T //20181111 {ProfileExtension;} //20170418 Igor  //20211220 Igor
  ProfileExtension := ProfileExtensionBox.Text;
  { remove it }
  FromDirBox.Text := OptRec.Dir_LastYr;
  TempDir := AppDir + '\' + TempDirName;
  If DirectoryExists(TempDir) then
  else
    MkDir(TempDir);

  ShowFiles;
end;

procedure TRollGpT1_2026.CancelBtnClick(Sender: TObject);
begin
  FldList.Free;
  Close;
end;

function TRollGpT1_2026.GetValue(FldName: WideString): String;
// Var label TryAgain;
begin
  Result := '';
  If FldName = '' then
    exit;
  try
    Result := ProfileClient1.Field[SpousePrefix + FldName];
  except
    on E: Exception do
    begin
      If UpperCase(E.Message) = 'INVALID FORM NAME.' then
      begin
        ShowMessage('FldName in error=' + SpousePrefix + FldName);
        exit;
      end;

      MessageDlg(E.Message, mtError, [mbok], 0);
      Try
        Result := FloatToStr(ProfileClient1.Field[SpousePrefix + FldName]);
        If Result = '0' then
          Result := '';
        ShowMessage('FldName in error=' + SpousePrefix + FldName);
      except
        Result := '';
      end; // second try
    end;
  end; // first try
end;

procedure TRollGpT1_2026.ImportAllBtnClick(Sender: TObject);
Begin
  // ShowMessage('Batch rollover will be released with the production version');
  // Exit;

  If RetInMem > 0 then
  begin
    ShowMessage('Please Exit this form and Close all returns first');
    exit;
  end;
  // CheckDateFormat; //20170731 Igor
  ImportAll;
end;

procedure TRollGpT1_2026.ImportAll;
Var
  i, k: Integer;
  Rslt: Integer;
  ClientOrSpouse: String;
  FNo: Integer;
begin
  If RetInMem > 0 then
  begin
    ShowMessage('Please close all returns first');
    exit;
  end;

  If FileListBox1.Items.Count <= 0 then
  begin
    ShowMessage('No files are available for Roll-over');
    exit;
  end;

  if MessageDlg('Batch conversion. Are you sure?', mtInformation, [mbYes, mbNo],
    0) = mrNo then
    exit;

  ButtonClicked := 'IMPORT ALL';
  Screen.Cursor := crHourGlass;
  Cnt := 0;
  k := FileListBox1.Itemindex;
  FileListBox1.Refresh;
  ClientOrSpouse := 'C';
  For i := k to FileListBox1.Items.Count - 1 do
  begin
    Try
      If i > k - 1 + Vl(HowManyBox.Text) then
        break;
      FileListBox1.Itemindex := i;
      FileListBox1.Refresh;
      ProcessingLbl.Caption := 'Processing No :' + IntToStr(i + 1);
      ProcessingLbl.Refresh;
      GpFlName := FromDirBox.Text + '\' + FileListBox1.Items[i];
      ClientOrSpouse := 'C';
      If ConvertOne(GpFlName, ClientOrSpouse) = 0 then
      begin
        Rslt := ImportOne(ConvertedFlName, ClientOrSpouse);
        FNo := GetFormNo('ASSETSB#1');
        if Ret[RetNo].Frm[FNo].Count = 0 then
          InitFormData(RetNo, FNo);
        StoreElm(RetNo, 'ASSETSB#1', 10, 'N');
        StoreElm(RetNo, 'STATUS', 4, '01'); // not started
        Ret[RetNo].PrpStatus := '01';

        If RetNo > 0 then
          RemoveReturnFromMemory(RetNo);
      end;

      If (SpouseBox.Checked) and (ProfileClient1.Field['Spouse.T1Info.S[1]'] >
        '') then // there is spouse data in file
      // If (SpouseBox.Checked) and (GetValue('Spouse.T1Info.S[1]') >'') then //there is spouse data in file
      begin
        ClientOrSpouse := 'S';
        Rslt := ConvertOne(GpFlName, ClientOrSpouse);
        If Rslt = 0 then
        begin
          ImportOne(ConvertedFlName, ClientOrSpouse);
          FNo := GetFormNo('ASSETSB#1');
          if Ret[RetNo].Frm[FNo].Count = 0 then
            InitFormData(RetNo, FNo);
          StoreElm(RetNo, 'ASSETSB#1', 10, 'N');
          StoreElm(RetNo, 'STATUS', 4, '01'); // not started
          Ret[RetNo].PrpStatus := '01';
          FixBusStatements(RetNo);
          FixRefundLine(RetNo);
          StoreElm(RetNo, 'ASSETSB#1', 10, 'Y');
          ReviseAssetsLinks(RetNo, True);
          ConsolIntoT2125(RetNo, True); // one time routine
          RecalcEverything(RetNo);
          If RetNo > 0 then
            RemoveReturnFromMemory(RetNo);
          Try
          except
          end; // try
        end; // convertone
      end; // spouse
    Except
    end; // try
    Screen.Cursor := crHourGlass;
  end; // i
  ProcessingLbl.Caption := '';
  ProcessingLbl.Refresh;
  Screen.Cursor := crDefault;
  ShowMessage('Total returns rolled-over= ' + IntToStr(Cnt) + Chr(13) +
    'You can now Exit and use Open from the VisualTax Main Menu');
  ButtonClicked := '';
end;

Function TRollGpT1_2026.GetVisualExt(VtYearEnd: String): String;
Var
  i: Integer;
  TwoDigitYE: string; // [2];
begin
  TwoDigitYE := MidStr(VtYearEnd, 3, 2);
  Result := FillLeftZeros(AllTrim(TwoDigitYE), 2);
end;

procedure TRollGpT1_2026.SaveIt(FlName: String);
begin
  // If FlName='' then FlName:='00000000.0';
  If not SaveReturn(RetNo, ToDirBox.Text, FlName, True, True) = 0 then
    ShowMessage('Save of data failed')
  else
    Inc(Cnt);
end;

procedure TRollGpT1_2026.ShowFiles;
begin
  FileListBox1.Directory := FromDirBox.Text;
  FileListBox1.Mask := '*.' + ProfileExtensionBox.Text;
  FileListBox1.Itemindex := 0;
  FilesGroupBox.Caption := 'FILES: ' + IntToStr(FileListBox1.Items.Count);
end;

procedure TRollGpT1_2026.HelpBtnClick(Sender: TObject);
begin
  ShowHelp(AppT1_2026.ModuleHelpUpdFile, 'Converting_from_Profile', True);
  // 20160801 Igor
end;

Function TRollGpT1_2026.GetSinNo(ClientOrSpouse: String): String;
Var
  i: Integer;
  ConvList, WList: TStringList;
  Sin: String;
begin
  If ClientOrSpouse = 'C' then
    Sin := ProfileClient1.Field['T1Info.S[1]']
  Else
    Sin := ProfileClient1.Field['Spouse.T1Info.S[1]'];
  Result := LeftStr(AllTrim(RemoveChar(Sin, ' ')), 9);
end;

procedure TRollGpT1_2026.OpenBtnClick(Sender: TObject);
Var
  i: Integer;
  Rslt: Boolean;
  AssetFNo: Integer;
begin
  (*
    //TESTING an CONVERTED FILE AFTER CONVERTONE  20090128
    ConvertedFlName:='C:\Delphi\T1\TempDir\A ROLLOVER - Keep.exp';
    MainForm.FileNewItemClick(Application);
    RetNo:=GetCurrentRetNo;
    StoreElm(RetNo,GetFormNo('ASSETSB#1'),10,'N');
    StoreData(ConvertedFlName);
    RecalcEverything(RetNo);   //needed

    ButtonClicked:='';
    Close;
    EXIT;
    //-------------------------
  *)

  If Not DirectoryExists(FromDirBox.Text) then
  begin
    ShowMessage('From Directory ' + FromDirBox.Text + ' does not exist');
    exit;
  end;
  If FileListBox1.Itemindex < 0 then
  begin
    ShowMessage('You must select a file first');
    exit;
  end;

  // CheckDateFormat;//20170731 Igor
  GpFlName := FromDirBox.Text + '\' + FileListBox1.Items
    [FileListBox1.Itemindex];
  Rslt := OpenAReturn(GpFlName, 'C');
  If Rslt then
  begin
    If (SpouseBox.Checked) and (ProfileClient1.Field['Spouse.T1Info.S[1]'] > '')
    then // there is spouse data in file
    begin
      ShowTimedMsg('Now opening spousal return', 1200);
      ButtonClicked := 'OPEN';
      OpenAReturn(GpFlName, 'S');
      // 20090406
      ShowMessage('You can now Couple the returns');
      MainFormT1.StartCoupling1Click(Sender);
      // ShowMessage('Both spouses are now open'+ Chr(13)+'You may save (F3), swap (F8) or start coupling');
    end;
  end;
  ButtonClicked := '';
  Close;
end;

Function TRollGpT1_2026.OpenAReturn(GpFlName: String;
  ClientOrSpouse: String): Boolean;
Var
  i, FNo: Integer;
begin
  Result := False;
  ButtonClicked := 'OPEN';
  Screen.Cursor := crHourGlass;
  try
    If (ConvertOne(GpFlName, ClientOrSpouse) = 0) and
      (ImportOne(ConvertedFlName, ClientOrSpouse) = 0) then
    begin
      FNo := GetFormNo('ASSETSB#1');
      if Ret[RetNo].Frm[FNo].Count = 0 then
        InitFormData(RetNo, FNo);
      StoreElm(RetNo, 'ASSETSB#1', 10, 'N');
      StoreElm(RetNo, 'STATUS', 4, '01'); // not started
      Ret[RetNo].PrpStatus := '01';

      FixBusStatements(RetNo);
      FixRefundLine(RetNo);
      FixNISASin(RetNo);
      StoreElm(RetNo, 'ASSETSB#1', 10, 'Y');
      ReviseAssetsLinks(RetNo, True);
      ConsolIntoT2125(RetNo, True); // one time routine
      RecalcEverything(RetNo);
      UpdateAllDataIndicators(RetNo);
      // If MainForm.AuditPanel.Visible then
      MainForm.RefreshAuditPanel(RetNo);
      OpenForm(RetNo, 'INFO', 0);
      Ret[RetNo].Changed := True;
      Result := True;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TRollGpT1_2026.SelectDirBtn1Click(Sender: TObject);
Var
  DirSelected: String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    FromDirBox.Text := DirSelected;
  ShowFiles;

end;

procedure TRollGpT1_2026.SelectDirBtn2Click(Sender: TObject);
// 20170803 Igor>>>
Var
  DirSelected, Err: String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    ToDirBox.Text := DirSelected;
  // 20150826 igor
  If Not FileExists(IncludeTrailingPathDelimiter(ToDirBox.Text) + ClientsDbLite)
  then
  begin
    If not InitDataBase(ToDirBox.Text, Err) then // 20171017 igor
    begin
      ShowMessage(Err);
      exit;
    end;
  end;
  // 20170811 Igor<<<
end;

procedure TRollGpT1_2026.FromDirBoxExit(Sender: TObject);
begin
  ShowFiles;
end;

procedure TRollGpT1_2026.FromDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then
    ShowFiles;
end;

(*
  Function TRollGpT1.GetNumberOfTableRows(ProfileFrmNm,ProfileTableNm:String):Integer;
  var i,FCount:Integer;
  begin
  FCount:=ProfileClient1.FormCount[ProfileFrmNm];
  //ShowMessage('Form count='+IntToStr(FCount));
  Result:=0;
  For i:=0 to FCount-1 do
  begin
  Result:=Result+ProfileClient1.TableItemCount[ProfileTableNm,i];
  //Showmessage('Table items='+IntToStr(TableRows));
  end;
  end;
*)

Function TRollGpT1_2026.ImportOne(ConvertedFlName: String;
  ClientOrSpouse: String): Integer;
Var
  i, j, FNo, AssetFNo: Integer;
  Msg: string;
  PrpStatus, EfStatus, Notes, LastYrDir, Sin: String;
begin
  Result := 9;
  Sin := GetSinNo(ClientOrSpouse);
  If Sin = '' then
  begin
    ShowMessage('This return does not have a SIN');
    Sin := '000000000';
  end;

  VisualFlName := LeftStr(Sin, 8) + '.' + RightStr(Sin, 1);
  // GetVisualExt(VtYearEnd);
  If (FileExists(ToDirBox.Text + '\' + VisualFlName)) and
    (ReplaceOptionBox.Itemindex = 1) and (ButtonClicked <> 'OPEN') then
  begin
    ShowTimedMsg('Already exists in VisualTax. Skipped', 700);
    Result := 2;
    exit;
  end;

  If ButtonClicked = 'OPEN' then
    RetNo := FileNew
  else
    RetNo := CreateNewReturn;
  if RetNo < 1 then
  begin
    ShowOpenReturnFailure(RetNo, '', '');
    exit;
  end;

  Try
    StoreElm(RetNo, 'ASSETSB#1', 10, 'N');
    GetHBPandLLP(RetNo);
    Ret[RetNo].SourceDataDir := ToDirBox.Text; { fooli t }
    StoreData(ConvertedFlName);
    FNo := GetFormNo('STATUS');
    // created
    StoreElm(RetNo, 'STATUS', 4, '01'); // not started
    Ret[RetNo].PrpStatus := '01';
    For j := 5 to 5 do
      StoreElm(RetNo, FNo, j, 'CONV-PROF');
    For j := 6 to 6 do
      StoreElm(RetNo, FNo, j, FormatDateTime('yyyy-mm-dd', Date));
    For j := 7 to 7 do
      StoreElm(RetNo, FNo, j, TimeToStr(Time));
    // updated
    For j := 11 to 11 do
      StoreElm(RetNo, FNo, j, User.UserName); // 20170112 Igor
    For j := 12 to 12 do
      StoreElm(RetNo, FNo, j, FormatDateTime('yyyy-mm-dd', Date));
    For j := 13 to 13 do
      StoreElm(RetNo, FNo, j, TimeToStr(Time));
    RecalcEverything(RetNo); // needed
    If ButtonClicked <> 'OPEN' then
    begin
      FixBusStatements(RetNo);
      FixRefundLine(RetNo);
      FixNISASin(RetNo);
      StoreElm(RetNo, 'ASSETSB#1', 10, 'Y');
      ReviseAssetsLinks(RetNo, True);
      ConsolIntoT2125(RetNo, True); // one time routine
      RecalcEverything(RetNo);
      UpdateAllDataIndicators(RetNo);
      SaveIt(VisualFlName);
    end;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;
  // If ButtonClicked <> 'OPEN' then
  // begin
  // If RetNo > 0 then
  // //RemoveReturnFromMemory(RetNo);  //causes errors
  // end;
  Result := 0;
end;

Function TRollGpT1_2026.FldNameIsString(FldName: String): Boolean;
Var
  i: Integer;
  // coming in as xxx.s[
begin
  Result := False;
  For i := 1 to Length(FldName) do
    If FldName[i] = '[' then
    begin
      If UpperCase(FldName[i - 1]) = 'S' then
      begin
        Result := True;
        exit;
      end;
    end;
end;

procedure TRollGpT1_2026.FileListBox1DblClick(Sender: TObject);
begin
  OpenBtnClick(Sender);
end;

procedure TRollGpT1_2026.ProfileExtensionBoxChange(Sender: TObject);
begin
  ProfileExtension := ProfileExtensionBox.Text;
  ShowFiles;
end;

Function TRollGpT1_2026.FixValu(FName, Valu: String; FNo, Elm: Integer): String;
begin
  Result := Valu;

  If FName = 'INFO' then
  begin
    Case Elm of
      1:
        Result := GetLongPrv(ConvertProvOfRes(UpperCase(Valu)));
      14:
        Result := UpperCase(Valu);
      15:
        Result := UpperCase(Valu);
      9:
        Result := JulianDaysToBirthDate(Valu); { birthdate }
      59:
        Result := JulianDaysToBirthDate(Valu); { sp birthdate }
      23:
        If MyStrToInt(Valu) = 1 then
          Result := 'M'
        else
          Result := 'F';
      3, 4:
        Result := RemoveChar(Valu, ' '); { Sin }
      46:
        If AllTrim(Valu) = '1' then
          Result := 'Y'
        else
          Result := 'N'; { efile }
      58:
        If AllTrim(Valu) = '1' then
          Result := 'Y'
        else
          Result := 'N'; { represent }
      49:
        If Length(Valu) = 1 then
          Result := '0' + Valu; { NOA }
      43:
        If Valu = '1' then
          Result := 'X'
        else
          Result := ''; { elections }
      47:
        If Valu = '1' then
          Result := '3'
        else
          Result := '1'; { discounting }
      87:
        begin
          If AllTrim(Valu) = '1' then
            Result := 'X'
          else
            Result := ''; { disability }
        end;
      54:
        Result := MidStr(Valu, 2, 3); { ph area }
      55:
        Result := RightStr(Valu, 8); { phone }
      62:
        Result := MidStr(Valu, 2, 3); { fax area }
      63:
        Result := RightStr(Valu, 8); { fax no }
    end;
  end;

  If FName = 'DEPEND' then
  begin
    Case Elm of
      10, 25, 40, 55:
        Result := JulianDaysToBirthDate(Valu); { birthdate }
      7, 22, 37, 52:
        Result := RemoveChar(Valu, ' '); { sin }
      11, 26, 41, 56:
        Result := ConvertDepRelationship(Valu);
      19, 34, 49, 64, 79, 94, 109, 124, 139:
        If Valu = '1' then
          Result := 'Y'
        else
          Result := ''; // equiv to spouse
    end;
  end; // depend

  If (FName = 'DISAB18') and (Elm = 26) then
  begin
    If Valu = '1' then
      Result := 'Y'
    else
      Result := ''; // disability
  end;

  If LeftStr(FName, 5) = 'T2125' then // 20110313
  begin
    Case Elm of
      4, 5:
        begin
          Result := JulianDaysToBirthDate(Valu);
          If Result = '2001-01-00' then
            Result := '2000-12-31';
          If Result = '2002-01-00' then
            Result := '2001-12-31';
          If Result = '2003-01-00' then
            Result := '2002-12-31';
          If Result = '2004-01-00' then
            Result := '2003-12-31';
          If Result = '2013-01-00' then
            Result := '2012-12-31'; // 20131210
          Result := IncrYear(Result);
        end;
      19:
        begin
          StoreElm(RetNo, FNo, 19, LeftStr(Valu, 5));
          StoreElm(RetNo, FNo, 20, MidStr(Valu, 6, 4));
          StoreElm(RetNo, FNo, 21, RightStr(Valu, 6));
        end;
    end;
  end;

  If LeftStr(FName, 5) = 'T2121' then // 20110313
  begin
    Case Elm of
      4, 5:
        begin
          Result := JulianDaysToBirthDate(Valu);
          If Result = '2001-01-00' then
            Result := '2000-12-31';
          If Result = '2002-01-00' then
            Result := '2001-12-31';
          If Result = '2003-01-00' then
            Result := '2002-12-31';
          If Result = '2004-01-00' then
            Result := '2003-12-31';
          Result := IncrYear(Result);
        end;
      15:
        begin
          StoreElm(RetNo, FNo, 15, LeftStr(Valu, 5));
          StoreElm(RetNo, FNo, 16, MidStr(Valu, 6, 4));
          StoreElm(RetNo, FNo, 17, RightStr(Valu, 6));
        end;
    end;
  end;

  If LeftStr(FName, 5) = 'T2042' then
  begin
    Case Elm of
      4, 5:
        begin
          Result := JulianDaysToBirthDate(Valu);
          If Result = '2001-01-00' then
            Result := '2000-12-31';
          If Result = '2002-01-00' then
            Result := '2001-12-31';
          If Result = '2003-01-00' then
            Result := '2002-12-31';
          If Result = '2004-01-00' then
            Result := '2003-12-31';
          Result := IncrYear(Result);
        end;
      21:
        begin
          StoreElm(RetNo, FNo, 21, LeftStr(Valu, 5));
          StoreElm(RetNo, FNo, 22, MidStr(Valu, 6, 4));
          StoreElm(RetNo, FNo, 23, RightStr(Valu, 6));
        end;
    end;
  end;

  If LeftStr(FName, 4) = 'T776' then
  begin
    Case Elm of
      3, 6:
        begin
          Result := JulianDaysToBirthDate(Valu);
          If Result = '2001-01-00' then
            Result := '2000-12-31';
          If Result = '2002-01-00' then
            Result := '2001-12-31';
          If Result = '2003-01-00' then
            Result := '2002-12-31';
          If Result = '2004-01-00' then
            Result := '2003-12-31';
          Result := IncrYear(Result);
        end;

      15:
        begin
          StoreElm(RetNo, FNo, 15, LeftStr(Valu, 5));
          StoreElm(RetNo, FNo, 16, MidStr(Valu, 6, 4));
          StoreElm(RetNo, FNo, 17, RightStr(Valu, 6));
        end;
      45: // ,48,51: {in one spot}
        begin
          // owMessage('BEFORE='+FetchElmFNo(RetNo,FNo,elm)+Chr(13)+'NEW VAL='+valu);
          Result := LeftStr(FetchElmFNo(RetNo, FNo, Elm) + ' ' + Valu, 70);
          // StoreElm(RetNo,FNo,Elm,FetchElmFNo(RetNo,FNo,elm)+' '+Valu);
          // owMessage('After='+ FetchElmFNo(RetNo,FNo,elm));
        end;
    end; { case }
  end;
end;

Function TRollGpT1_2026.ConvertProvOfRes(Valu: String): String;
Var
  n: Integer;
begin
  Result := Valu;
  n := MyStrToInt(AllTrim(Valu));
  Case n of
    0:
      Result := 'NA';
    1:
      Result := 'BC';
    2:
      Result := 'AB';
    3:
      Result := 'SK';
    4:
      Result := 'MB';
    5:
      Result := 'ON';
    6:
      Result := 'QC';
    7:
      Result := 'NB';
    8:
      Result := 'NS';
    9:
      Result := 'PE';
    10:
      Result := 'NL';
    11:
      Result := 'YK';
    12:
      Result := 'NT';
    13:
      Result := 'ZZ';
    14:
      Result := 'ZZ';
    15:
      Result := 'ZZ';
    16:
      Result := 'ZZ';
    17:
      Result := 'NU';
  end;
end;

Function TRollGpT1_2026.ConvertDepRelationship(Valu: String): String;
Var
  n: Integer;
begin
  n := MyStrToInt(AllTrim(Valu));
  Case n of
    0:
      Result := 'NA';
    1:
      Result := 'Son';
    2:
      Result := 'Daughter';
    3:
      Result := 'Parent';
    4:
      Result := 'GrandParent';
    5:
      Result := 'GrandChild';
    6:
      Result := 'Brother';
    7:
      Result := 'Sister';
  end;
end;

Function TRollGpT1_2026.FixMarStatus(Valu: String): Integer;
{ returns the right elm for the X indicator }
Var
  n: Integer;
begin
  n := MyStrToInt(AllTrim(Valu));
  Case n of
    1:
      Result := 11;
    2:
      Result := 12;
    3:
      Result := 13;
    4:
      Result := 16;
    5:
      Result := 17;
    6:
      Result := 18;
  end; { case }
end;

Procedure TRollGpT1_2026.FixRefundLine(RetNo: Integer);
Var
  i: Integer;
  inst: String;
  FName: String;
  FNo: Integer;
begin
  FNo := GetFormNo('YRSUM');
  For i := 744 to 747 do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, i)) < 0 then
    begin
      StoreElm(RetNo, FNo, i - 5, FormatFloat('###,###,###.##',
        ABS(Vl(FetchElmFNo(RetNo, FNo, i)))));
      StoreElm(RetNo, FNo, i, '')
    end;
  end;
end;

Procedure TRollGpT1_2026.FixBusStatements(RetNo: Integer);
Var
  i, j: Integer;
  inst: String;
  FInst: String;
  FName: String;
  FNo: Integer;
  OldStmt: String;
begin
  // T2125
  Try
    For i := 1 to ProfileClient1.FormCount['T2125'] + 1 do
    begin
      inst := '#' + AllTrim(IntToStr(i));
      FName := 'T2125' + inst;
      FNo := GetFormNo(FName);
      If FNo > 0 then
      begin
        If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
        begin
          If FetchElmFNo(RetNo, FNo, 73) = '0' then
          begin
            StoreElm(RetNo, FNo, 73, 'X');
            StoreElm(RetNo, FNo, 74, '');
          end
          else If FetchElmFNo(RetNo, FNo, 73) = '1' then
          begin
            StoreElm(RetNo, FNo, 73, '');
            StoreElm(RetNo, FNo, 74, 'X');
          end;

          If FetchElmFNo(RetNo, FNo, 82) = '0' then
          begin
            StoreElm(RetNo, FNo, 82, 'X');
            StoreElm(RetNo, FNo, 90, '');
          end
          else If FetchElmFNo(RetNo, FNo, 82) = '1' then
          begin
            StoreElm(RetNo, FNo, 82, '');
            StoreElm(RetNo, FNo, 90, 'X');
          end;

          If Vl(FetchElmFNo(RetNo, FNo, 23)) <> 0 then
          begin
            StoreElm(RetNo, FNo, 23, ''); // remove amount
            If FetchElmFNo(RetNo, FNo, 8) = '' then
              StoreElm(RetNo, FNo, 8, '???');
          end;
          StoreElm(RetNo, FNo, 19, LeftStr(FetchElmFNo(RetNo, FNo, 19), 5));
          StoreElm(RetNo, FNo, 20, MidStr(FetchElmFNo(RetNo, FNo, 20), 6, 4));
          If Length(FetchElmFNo(RetNo, FNo, 21)) = 15 then
            StoreElm(RetNo, FNo, 21, RightStr(FetchElmFNo(RetNo, FNo, 21), 6))
            { i.e. rc0001 }
          else
            StoreElm(RetNo, FNo, 21, '');
          Calc(RetNo, 'T2125' + inst);
        end; // has data
      end; // Fno>0
    end; // i
  except
    //
  end;

  // T2121
  // ShowMessage('fixing T2121');
  Try
    For i := 1 to ProfileClient1.FormCount['T2121'] + 1 do
    begin
      inst := '#' + AllTrim(IntToStr(i));
      FName := 'T2121' + inst;
      FNo := GetFormNo(FName);

      If FNo > 0 then
      begin
        If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
        begin
          If Vl(FetchElmFNo(RetNo, FNo, 20)) <> 0 then
          begin
            StoreElm(RetNo, FNo, 20, ''); // remove amount
            If FetchElmFNo(RetNo, FNo, 61) = '' then
              StoreElm(RetNo, FNo, 61, '???');
          end;
          StoreElm(RetNo, FNo, 15, LeftStr(FetchElmFNo(RetNo, FNo, 15), 5));
          StoreElm(RetNo, FNo, 16, MidStr(FetchElmFNo(RetNo, FNo, 16), 6, 4));
          If Length(FetchElmFNo(RetNo, FNo, 17)) = 15 then
            StoreElm(RetNo, FNo, 17, RightStr(FetchElmFNo(RetNo, FNo, 17), 6))
          else
            StoreElm(RetNo, FNo, 17, '');

        end;
      end; // Fno
    end;
  except
    //
  end;

  // T2042
  // ShowMessage('fixing T2042');
  Try
    For i := 1 to ProfileClient1.FormCount['T2042'] + 1 do
    begin
      inst := '#' + AllTrim(IntToStr(i));
      FName := 'T2042' + inst;
      FNo := GetFormNo(FName);
      If FNo > 0 then
      begin
        If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
        begin
          If Vl(FetchElmFNo(RetNo, FNo, 26)) <> 0 then
          begin
            StoreElm(RetNo, FNo, 26, ''); // remove amount
            If FetchElmFNo(RetNo, FNo, 8) = '' then
              StoreElm(RetNo, FNo, 8, '???');
          end;
          StoreElm(RetNo, FNo, 21, LeftStr(FetchElmFNo(RetNo, FNo, 21), 5));
          StoreElm(RetNo, FNo, 22, MidStr(FetchElmFNo(RetNo, FNo, 22), 6, 4));
          If Length(FetchElmFNo(RetNo, FNo, 23)) = 15 then
            StoreElm(RetNo, FNo, 23, RightStr(FetchElmFNo(RetNo, FNo, 23), 6))
          else
            StoreElm(RetNo, FNo, 23, '');
        end;
      end; // FNo
    end;
  except
    //
  end;

  // T1163 Convert to T1273 of T1163.B[0,30] is 1
  If Ret[RetNo].FormHasData['T1163#1'] then
  begin
    If GetValue('T1163.B[0,30]') = '1' then // T1273
    begin // move T1163 to T1273 and CCA etc.
      ClearForm(RetNo, 'T1163#1');
      Ret[RetNo].FormHasData['T1163#1'] := False;

      // remove from assetsb
      for i := 0 to (FList.Count - 1) do
      begin
        FRec := FList.Items[i];
        FNo := FRec.FormNo;
        If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
        begin
          // AssetsB
          if FRec.FormName = 'ASSETSB' then
          begin
            OldStmt := FetchElmFNo(RetNo, FNo, 215);
            // ShowMessage('Old stmt before checking T1175='+OldStmt);
            If OldStmt > '' then
            begin
              If LeftStr(OldStmt, 5) = 'T1163' then
              begin
                // ShowMessage('old link='+OldStmt);
                FInst := AllTrim(MidStr(OldStmt, 6, 2));
                StoreElm(RetNo, FNo, 215, '');
                ClearForm(RetNo, GetFormName(RetNo, FNo));
                // Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
              end;
            end;
            // Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]:=True;
            Calc(RetNo, FRec.FormName);
          end;
        end; // Assets has data
      end; // i

    end;
  end;

  (*
    If Ret[RetNo].FrmHasData[GetFormNo('T1273SUM#1')] then
    begin
    If GetValue('T11645Year.B[0,30]') = '0' then  //T1163 only
    begin
    ClearForm(RetNo,'T1273SUM#1');
    Ret[RetNo].FrmHasData[GetFormNo('T1273SUM#1')]:=False;
    end;
  *)
  If Ret[RetNo].FormHasData['T1273#1'] then
  begin
    If GetValue('T1163.B[0,30]') = '0' then // T1163 only
    begin
      ClearForm(RetNo, 'T1273#1');
      Ret[RetNo].FormHasData['T1273#1'] := False;

      // remove from assetsb
      for i := 0 to (FList.Count - 1) do
      begin
        FRec := FList.Items[i];
        FNo := FRec.FormNo;
        If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
        begin
          // AssetsB
          if FRec.FormName = 'ASSETSB' then
          begin
            OldStmt := FetchElmFNo(RetNo, FNo, 215);
            // ShowMessage('Old stmt before checking T1175='+OldStmt);
            If OldStmt > '' then
            begin
              If LeftStr(OldStmt, 5) = 'T1273' then
              begin
                // ShowMessage('old link='+OldStmt);
                FInst := AllTrim(MidStr(OldStmt, 6, 2));
                StoreElm(RetNo, FNo, 215, '');
                ClearForm(RetNo, GetFormName(RetNo, FNo));
                // Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] := True;
              end;
            end;
            // Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]:=True;
            Calc(RetNo, FRec.FormName);
          end;
        end; // Assets has data
      end; // i

    end;
  end;

  // T776
  // ShowMessage('fixing T776');
  Try
    For i := 1 to ProfileClient1.FormCount['T776'] + 1 do
    begin
      inst := '#' + AllTrim(IntToStr(i));
      FName := 'T776' + inst;
      FNo := GetFormNo(FName);
      If FNo > 0 then
      begin
        If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
        begin
          If Vl(FetchElmFNo(RetNo, FNo, 47)) <> 0 then
          begin
            StoreElm(RetNo, FNo, 47, ''); // remove amount
            If FetchElmFNo(RetNo, FNo, 109) = '' then
              StoreElm(RetNo, FNo, 109, GetFirstName(RetNo) + ' ' +
                GetLastName(RetNo));
          end;

          If Vl(FetchElmFNo(RetNo, FNo, 47)) <> 0 then
            StoreElm(RetNo, FNo, 47, ''); // remove amount
          If Vl(FetchElmFNo(RetNo, FNo, 50)) <> 0 then
            StoreElm(RetNo, FNo, 50, ''); // remove amount
          If Vl(FetchElmFNo(RetNo, FNo, 53)) <> 0 then
            StoreElm(RetNo, FNo, 53, ''); // remove amount
          StoreElm(RetNo, FNo, 15, LeftStr(FetchElmFNo(RetNo, FNo, 15), 5));
          StoreElm(RetNo, FNo, 16, MidStr(FetchElmFNo(RetNo, FNo, 16), 6, 4));
          StoreElm(RetNo, FNo, 17, RightStr(FetchElmFNo(RetNo, FNo, 17), 6));

        end;
      end; // FNo
    end; // i
  except
    //
  end;

end;

Procedure TRollGpT1_2026.SplitFldLists;
var
  i: Integer;
  FullList: TStringList;
begin
  FullList := TStringList.Create;
  FldList := TStringList.Create;
  T2125List := TStringList.Create;
  T2121List := TStringList.Create;
  T2042List := TStringList.Create;
  T776List := TStringList.Create;

  T2125CCAList := TStringList.Create;
  T2121CCAList := TStringList.Create;
  T2042CCAList := TStringList.Create;
  T776CCAList := TStringList.Create;
  // T1164CCAList:=TStringList.Create;

  FullList.LoadFromFile(AppDir + '\' + FieldsFlName);
  For i := 0 to FullList.Count - 1 do
  begin
    // normal statements
    If ((LeftStr(FullList[i], 5) = 'T2125') and
      (LeftStr(FullList[i], 13) <> 'T2125CCAClass')) then
      T2125List.Add(FullList[i])
    Else If ((LeftStr(FullList[i], 5) = 'T2121') and
      (LeftStr(FullList[i], 13) <> 'T2121CCAClass')) then
      T2121List.Add(FullList[i])
    Else If ((LeftStr(FullList[i], 5) = 'T2042') and
      (LeftStr(FullList[i], 13) <> 'T2042CCAClass')) then
      T2042List.Add(FullList[i])

    Else If ((LeftStr(FullList[i], 4) = 'T776') and
      (LeftStr(FullList[i], 12) <> 'T776CCAClass')) then
      T776List.Add(FullList[i])
      // now cca
    Else if LeftStr(FullList[i], 13) = 'T2125CCAClass' then
      T2125CCAList.Add(FullList[i])
    Else if LeftStr(FullList[i], 13) = 'T2121CCAClass' then
      T2121CCAList.Add(FullList[i])
    Else if LeftStr(FullList[i], 13) = 'T2042CCAClass' then
      T2042CCAList.Add(FullList[i])

      // Else if LeftStr(FullList[i],13) = 'T1164CCAClass' then
      // T1164CCAList.Add(FullList[i])

    Else if LeftStr(FullList[i], 12) = 'T776CCAClass' then
      T776CCAList.Add(FullList[i])
    else
      FldList.Add(FullList[i]);
  end;
  FullList.Free;
end;

Function TRollGpT1_2026.ConvertOne(GpFlName: String;
  ClientOrSpouse: String): Integer;
var
  k: Integer;
  s: String;
  GpSin: String;
  Percent: Real;
  FldName: String;
  x: Real;
  Item: Variant;
  OutList, TmpList: TStringList;
  i, j, ii, StmNo, VisualInst, VisualIncr, FCount, TableRows,
    MaxVisualRowsPerInst: Integer;
  ProfileFrmNm, VisualFrmNm, ProfileTableNm, VisualFldDescr,
    ProfileInstance: String;

  SnapShotList: IProfileSnapShotList;
  SnapShot: IProfileSnapShot;
  SnapShotItem: IProfileSnapShotItem;
  Field: IProfileField;
  SS, SS2: Integer;
  SH: TStringList;
begin
  If ClientOrSpouse = 'C' then
    SpousePrefix := ''
  else
    SpousePrefix := 'Spouse.';

  Result := 9;

  (*
    //20161226 added 12 to 16  //con
    If ProfileExtensionBox.Text = '16T' then  //20131210
    begin
    ProfileFile1:={Profile_tlb.}CoT2016T1File.Create;
    If Psw.text>'' then ProfileFile1.FilePassword:=Psw.text;
    end;
  *)
  // 20170418 Igor >>>
  // 20211220 Igor >>>
  // 20240103 Igor >>>

  //20260130 Igor >>>
  If ProfileExtensionBox.Text = '24T' then
  begin
    ProfileFile1 := CoT2024T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end
  //20260130 Igor <<<

  Else If ProfileExtensionBox.Text = '23T' then
  begin
    ProfileFile1 := CoT2023T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end

  Else If ProfileExtensionBox.Text = '22T' then
  begin
    ProfileFile1 := CoT2022T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end
  // 20240103 Igor <<<

  Else If ProfileExtensionBox.Text = '21T' then
  begin
    ProfileFile1 := CoT2021T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end

  Else If ProfileExtensionBox.Text = '20T' then
  begin
    ProfileFile1 := CoT2020T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end

  Else If ProfileExtensionBox.Text = '19T' then
  begin
    ProfileFile1 := CoT2019T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end

  Else If ProfileExtensionBox.Text = '18T' then // 20200104
  begin
    ProfileFile1 := CoT2018T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end
  // 20211220 Igor <<<

  Else if ProfileExtensionBox.Text = '17T' then
  begin
    ProfileFile1 := CoT2017T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end

  else if ProfileExtensionBox.Text = '16T' then
  begin
    ProfileFile1 := CoT2016T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end

  else If ProfileExtensionBox.Text = '15T' then // 20131210
  begin
    ProfileFile1 := CoT2015T1File.Create;
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end

  else If ProfileExtensionBox.Text = '*' then
  begin
    ProfileFile1 := CoT2017T1File.Create; // 20200104
    // ProfileFile1 := CoT2015T1File.Create;   //20170203
    If Psw.Text > '' then
      ProfileFile1.FilePassword := Psw.Text;
  end

  else
    exit;

  ProfileClient1 := ProfileFile1.Client;
  ProfileFile1.LoadFile(GpFlName, True);
  ProfileClient1.Calculate;

  // SH := TStringList.Create;
  // try
  // for SS := 0 to 1000 do
  // Begin
  // fldName := 'T1[' + IntToStr(SS)+']';
  // Field := nil;
  // try
  // Field := ProfileClient1.ProfileField[fldName];
  // except
  // end;
  // if Field <> nil then
  // begin
  // SH.Add('Field');
  // SH.Add('FieldCode :' + Field.FieldCode);
  // SH.Add('Value     :' + VarToStr(Field.Value));
  // SH.Add('Attribute :' + IntToStr(Integer(Field.Attribute)));
  // SH.Add('Memo      :' + Field.Memo);
  // SH.Add('CFMemo    :' + BoolToStr(Field.CFMemo));
  // SH.Add('ReviewMark:' + IntToStr(Integer(Field.ReviewMark)));
  // end;
  // End;
  // for SS := 0 to 1000 do
  // Begin
  // fldName := 'T1.S[' + IntToStr(SS)+']';
  // Field := nil;
  // try
  // Field := ProfileClient1.ProfileField[fldName];
  // except
  // end;
  // if Field <> nil then
  // begin
  // SH.Add('Field');
  // SH.Add('FieldCode :' + Field.FieldCode);
  // SH.Add('Value     :' + VarToStr(Field.Value));
  // SH.Add('Attribute :' + IntToStr(Integer(Field.Attribute)));
  // SH.Add('Memo      :' + Field.Memo);
  // SH.Add('CFMemo    :' + BoolToStr(Field.CFMemo));
  // SH.Add('ReviewMark:' + IntToStr(Integer(Field.ReviewMark)));
  // end;
  // End;
  // for SS := 0 to 1000 do
  // Begin
  // fldName := 'T1.B[' + IntToStr(SS)+']';
  // Field := nil;
  // try
  // Field := ProfileClient1.ProfileField[fldName];
  // except
  // end;
  // if Field <> nil then
  // begin
  // SH.Add('Field');
  // SH.Add('FieldCode :' + Field.FieldCode);
  // SH.Add('Value     :' + VarToStr(Field.Value));
  // SH.Add('Attribute :' + IntToStr(Integer(Field.Attribute)));
  // SH.Add('Memo      :' + Field.Memo);
  // SH.Add('CFMemo    :' + BoolToStr(Field.CFMemo));
  // SH.Add('ReviewMark:' + IntToStr(Integer(Field.ReviewMark)));
  // end;
  // End;
  // SH.SaveToFile('D:\VT\Profile\Fields.txt');
  // SH.Clear;
  // SnapShotList := ProfileClient1.SnapShotList;
  // for SS := 0 to SnapShotList.Count - 1 do
  // begin
  // SnapShot := SnapShotList.Items[SS];
  // SH.Add('SnapShot');
  // SH.Add('  Description: ' + SnapShot.Description);
  // SH.Add('  Date: ' + VarToStr(SnapShot.Date));
  // for SS2 := 0 to SnapShot.Count - 1 do
  // begin
  // SnapShotItem := SnapShot.Items[SS2];
  // SH.Add('  SnapShotItem');
  // SH.Add('    FieldCode:' + SnapShotItem.FieldCode);
  // SH.Add('    LineNumber:' + SnapShotItem.LineNumber);
  // SH.Add('    Description:' + SnapShotItem.Description);
  // SH.Add('    Value:' + VarToStr(SnapShotItem.Value));
  // end;
  // end;
  // SH.SaveToFile('D:\VT\Profile\Snapshot.txt');
  // finally
  // SH.Free;
  // end;
  // If ClientOrSpouse='C' then ShowMessage('Birthdate='+GetValue('T1[5]'));

  (*
    // example
    If ClientOrSpouse = 'C' then
    ShowMessage('Birthdate=' + GetValue('T1[5]'))
    else
    ShowMessage('Birthdate=' + GetValue('Spouse.T1[5]'));
  *)
  OutList := TStringList.Create;
  try

    // s:=ProfileClient1.FieldMemo('T1Info.S[1]');
    // ShowMessage('Memo= '+ProfileClient1.FieldMemo('T1Info.S[1]'));

    // s11prv cf
    // ONS11[16]=S11PrvCFS11PRV13
    (*
      FldName := 'T1.B[6]'; // 'T1Info.B[11]';   //prov  //20170203
      k := MyStrToInt(GetValue(FldName));
      FldName:='';
      Case k of
      1: FldName:='BCS11[16]'; //Result:='BC';
      2: FldName:='ABS11[16]'; //Result:='AB';
      3: FldName:='SKS11[16]'; //Result:='SK';
      4: FldName:='MBS11[16]'; //Result:='MB';
      5: FldName:='ONS11[16]'; //Result:='ON';
      //6: FldName:='BCS11[16]'; //Result:='QC';
      7: FldName:='NBS11[16]'; //Result:='NB';
      8: FldName:='NSS11[16]'; //Result:='NS';
      9: FldName:='PES11[16]'; //Result:='PE';
      10:FldName:='NLS11[16]'; //Result:='NF';
      11:FldName:='YTS11[16]'; //Result:='YT';
      12:FldName:='NTS11[16]'; //Result:='NT';
      13:FldName:='NUS11[16]'; //Result:='NU';
      end;
      //FldList.add(Fldname+'=S11 Prv'+'^'+'S11PRV'+'^'+'13');  //20170203
    *)
    For i := 0 to FldList.Count - 1 do
    begin
      FldName := GetProfileFldName(FldList[i], ClientOrSpouse);
      If (FldName > '') and (Not IsBusStatement(FldName)) then
      begin
        // ShowMessage(FldName);
        s := GetValue(FldName);
        OutList.Add(FldList[i] + '^' + s);
        // OutList.add(FldList[i]+''+S);   //20170203
      end;
    end;

    // T2125
    // ShowMessage('T2125');
    // Fcount := 0;
    Try
      TmpList := TStringList.Create;
      try
        FCount := ProfileClient1.FormCount['T2125'];
        For StmNo := 0 to FCount - 1 do
        begin
          x := Vl(GetValue('T2125[' + IntToStr(StmNo) + ',19]'));
          s := GetValue('T2125.S[' + IntToStr(StmNo) + ',3]');
          Percent := Vl(GetValue('T2125Owners[' + IntToStr(StmNo) + ',0,0]'));
          If Percent > 0 then
          begin
            ReplaceNdxWithStm(TmpList, 'T2125', StmNo); // modified temp list
            For i := 0 to TmpList.Count - 1 do
            begin
              FldName := GetProfileFldName(TmpList[i], ClientOrSpouse);
              If FldName > '' then
              begin
                s := GetValue(FldName);
                OutList.Add(TmpList[i] + '^' + s);
                // ??????? OutList.add(TmpList[i] + '' + S);
              end;
            end; // i
          end; // applicable
        end; // stm
      finally
        TmpList.Free;
      end;
    except
    end;

    (* 20170203
      //T2125SUM  //20101223
      //ShowMessage('T1125SUM');
      //Fcount := 0;
      Try
      TmpList := TstringList.Create;
      try
      FCount := ProfileClient1.FormCount['T21255year'];
      //ShowMessage('Profile T2125SUM Fcount='+IntToStr(FCount));
      For StmNo := 0 to FCount - 1 do
      begin
      ReplaceNdxWithStm(TmpList, 'T2125SUM', StmNo);  //modified temp list
      For i := 0 to TmpList.Count - 1 do
      begin
      FldName := GetProfileFldName(TmpList[i], ClientOrSpouse);
      If FldName > '' then
      begin
      s := GetValue(FldName);
      OutList.add(TmpList[i]+'^'+S);//????????? OutList.add(TmpList[i]+''+S)
      end;
      end; //i
      end; //stm
      finally
      TmpList.Free;
      end;
      except
      //ShowMessage('Error in importing 5 year T2125 Summary');
      end;
    *)

    // T2121
    // FCount:=0;
    Try
      TmpList := TStringList.Create;
      try
        FCount := ProfileClient1.FormCount['T2121'];
        For StmNo := 0 to FCount - 1 do
        begin
          x := Vl(GetValue('T2121[' + IntToStr(StmNo) + ',17]'));
          s := GetValue('T2121.S[' + IntToStr(StmNo) + ',3]');
          Percent := Vl(GetValue('T2121Owners[' + IntToStr(StmNo) + ',0,0]'));
          If Percent > 0 then
          begin
            ReplaceNdxWithStm(TmpList, 'T2121', StmNo); // modified temp list
            For i := 0 to TmpList.Count - 1 do
            begin
              FldName := GetProfileFldName(TmpList[i], ClientOrSpouse);
              If FldName > '' then
              begin
                s := GetValue(FldName);
                OutList.Add(TmpList[i] + '^' + s);
                // ????????? OutList.add(TmpList[i]+''+S);
              end;
            end; // i
          end; // applicable
        end; // stm
      finally
        TmpList.Free;
      end;
    except
    end;

    // T2042
    // FCount:=0;
    Try
      TmpList := TStringList.Create;
      try
        FCount := ProfileClient1.FormCount['T2042'];
        For StmNo := 0 to FCount - 1 do
        begin

          x := Vl(GetValue('T2042[' + IntToStr(StmNo) + ',43]'));
          s := GetValue('T2042.S[' + IntToStr(StmNo) + ',3]');
          Percent := Vl(GetValue('T2042Owners[' + IntToStr(StmNo) + ',0,0]'));
          If Percent > 0 then
          begin
            ReplaceNdxWithStm(TmpList, 'T2042', StmNo); // modified temp list
            For i := 0 to TmpList.Count - 1 do
            begin
              FldName := GetProfileFldName(TmpList[i], ClientOrSpouse);
              If FldName > '' then
              begin
                s := GetValue(FldName);
                OutList.Add(TmpList[i] + '^' + s);
                // ???????? OutList.add(TmpList[i]+''+S);
              end;
            end; // i
          end; // applicable
        end; // stm
      finally
        TmpList.Free;
      end;
    except
    end;

    // T776
    // FCount := 0;
    Try
      TmpList := TStringList.Create;
      try
        FCount := ProfileClient1.FormCount['T776'];
        For StmNo := 0 to FCount - 1 do
        begin
          x := Vl(GetValue('T776[' + IntToStr(StmNo) + ',31]'));
          Percent := Vl(GetValue('T776Owners[' + IntToStr(StmNo) + ',0,0]'));
          If Percent > 0 then
          begin
            ReplaceNdxWithStm(TmpList, 'T776', StmNo); // modified temp list
            For i := 0 to TmpList.Count - 1 do
            begin
              FldName := GetProfileFldName(TmpList[i], ClientOrSpouse);
              If FldName > '' then
              begin
                s := GetValue(FldName);
                OutList.Add(TmpList[i] + '^' + s);
                // ???????? OutList.add(TmpList[i] + '' + S);
              end;
            end; // i
          end; // applicable
        end; // stm
      finally
        TmpList.Free;
      end;
    except
    end;

    // T2125CCA
    // FCount:=0;
    Try
      TmpList := TStringList.Create;
      try
        FCount := ProfileClient1.FormCount['T2125CCA'];
        For StmNo := 0 to FCount - 1 do
        begin
          If StmNo = 0 then
          begin
            x := Vl(GetValue('T2125[0,12]'));
            s := GetValue('T2125.S[0,3]'); // ????????   ",5" or ",3"
          end
          else
          begin
            x := Vl(GetValue('T2125[' + IntToStr(StmNo) + ',12]'));
            s := GetValue('T2125.S[' + IntToStr(StmNo) + ',5]');
            // ????????   ",5" or ",3"
          end;
          If (x <> 0) or (s > '') then // sales><0 or bus name present
          begin
            ReplaceNdxWithStm(TmpList, 'T2125CCA', StmNo); // modified temp list
            For i := 0 to TmpList.Count - 1 do
            begin
              FldName := GetProfileFldName(TmpList[i], ClientOrSpouse);
              If FldName > '' then
              begin
                s := GetValue(FldName);
                OutList.Add(TmpList[i] + '^' + s);
                // ??????? OutList.add(TmpList[i] + '' + S);
              end;
            end; // i
          end; // applicable
        end; // stm
      finally
        TmpList.Free;
      end;
    except
    end;

    // T2121CCA
    // FCount:=0;
    Try
      TmpList := TStringList.Create;
      try
        FCount := ProfileClient1.FormCount['T2121CCA'];
        For StmNo := 0 to FCount - 1 do
        begin
          x := Vl(GetValue('T2121[' + IntToStr(StmNo) + ',17]'));
          s := GetValue('T2121.S[' + IntToStr(StmNo) + ',3]');
          If (x <> 0) or (s > '') then // sales><0 or bus name present
          begin
            ReplaceNdxWithStm(TmpList, 'T2121CCA', StmNo); // modified temp list
            For i := 0 to TmpList.Count - 1 do
            begin
              FldName := GetProfileFldName(TmpList[i], ClientOrSpouse);
              If FldName > '' then
              begin
                s := GetValue(FldName);
                OutList.Add(TmpList[i] + '^' + s);
                // ??????????  OutList.add(TmpList[i]+''+S);
              end;
            end; // i
          end; // applicable
        end; // stm
      finally
        TmpList.Free;
      end;
    except
    end;

    // T2042CCA
    // FCount:=0;
    Try
      FCount := ProfileClient1.FormCount['T2042CCA'];
      TmpList := TStringList.Create;
      try
        // If Vl(GetValue('T1[43]')) <=0 then FCount:=0;
        For StmNo := 0 to FCount - 1 do
        begin
          x := Vl(GetValue('T2042[' + IntToStr(StmNo) + ',43]'));
          s := GetValue('T2042.S[' + IntToStr(StmNo) + ',3]');
          If (x <> 0) or (s > '') then // sales><0 or bus name present
          begin
            ReplaceNdxWithStm(TmpList, 'T2042CCA', StmNo); // modified temp list
            For i := 0 to TmpList.Count - 1 do
            begin
              FldName := GetProfileFldName(TmpList[i], ClientOrSpouse);
              If FldName > '' then
              begin
                s := GetValue(FldName);
                OutList.Add(TmpList[i] + '^' + s);
                // ????????? OutList.add(TmpList[i] + '' + S);
              end;
            end; // i
          end; // applicable
        end; // stm
      finally
        TmpList.Free;
      end;
    except
    end;

    // T776CCA
    // FCount:=0;
    Try
      TmpList := TStringList.Create;
      try
        FCount := ProfileClient1.FormCount['T776CCA'];
        For StmNo := 0 to FCount - 1 do
        begin
          x := Vl(GetValue('T776[' + IntToStr(StmNo) + ',31]'));
          If (x <> 0) { or (s > '') } then // sales><0 or bus name present
          begin
            ReplaceNdxWithStm(TmpList, 'T776CCA', StmNo); // modified temp list
            For i := 0 to TmpList.Count - 1 do
            begin
              FldName := GetProfileFldName(TmpList[i], ClientOrSpouse);
              If FldName > '' then
              begin
                s := GetValue(FldName);
                OutList.Add(TmpList[i] + '^' + s);
                // ???????? OutList.add(TmpList[i] + '' + S);
              end;
            end; // i
          end; // applicable
        end; // stm
      finally
        TmpList.Free;
      end;
    except
    end;

    // ShowMessage('convert one finished');
    ConvertedFlName := GpFlName;
    ConvertedFlName := ExtractFileName(GpFlName);
    If ClientOrSpouse = 'S' then
      ConvertedFlName := 'S-' + ConvertedFlName;
    ConvertedFlName := ChangeFileExt(ConvertedFlName, '.' + TempFlExtension);
    ConvertedFlName := TempDir + '\' + ConvertedFlName;

    OutList.SaveToFile(ConvertedFlName);
    Result := 0;
  finally
    OutList.Free;
  end;
end;

Procedure TRollGpT1_2026.ReplaceNdxWithStm(Var TmpList: TStringList;
  StmId: String; StmNo: Integer);
Var
  i: Integer;
  j, k: Integer;
  s, StmStr: String;
begin
  StmStr := AllTrim(IntToStr(StmNo));
  If StmStr = '' then
    StmStr := '0';
  TmpList.Clear;

  If StmId = 'T2125' then
  begin
    For i := 0 to T2125List.Count - 1 do
    begin
      // profile fldname ndx
      k := Pos('[x', T2125List[i]);
      If k > 0 then
        s := LeftStr(T2125List[i], k - 1) + '[' + StmStr +
          MidStr(T2125List[i], k + 2, 255)
      else
        s := T2125List[i];
      // visualtax stm
      k := Pos('#y', s);
      If k > 0 then
        s := LeftStr(s, k - 1) + '#' + AllTrim(IntToStr(StmNo + 1)) +
          MidStr(s, k + 2, 255);
      TmpList.Add(s);
    end;
  end; // t2125

  If StmId = 'T2121' then
  begin
    For i := 0 to T2121List.Count - 1 do
    begin
      // profile fldname ndx
      k := Pos('[x', T2121List[i]);
      If k > 0 then
        s := LeftStr(T2121List[i], k - 1) + '[' + StmStr +
          MidStr(T2121List[i], k + 2, 255)
      else
        s := T2121List[i];
      // visualtax stm
      k := Pos('#y', s);
      If k > 0 then
        s := LeftStr(s, k - 1) + '#' + AllTrim(IntToStr(StmNo + 1)) +
          MidStr(s, k + 2, 255);
      TmpList.Add(s);
    end;
  end; // T2121

  If StmId = 'T2042' then
  begin
    For i := 0 to T2042List.Count - 1 do
    begin
      // profile fldname ndx
      k := Pos('[x', T2042List[i]);
      If k > 0 then
        s := LeftStr(T2042List[i], k - 1) + '[' + StmStr +
          MidStr(T2042List[i], k + 2, 255)
      else
        s := T2042List[i];
      // visualtax stm
      k := Pos('#y', s);
      If k > 0 then
        s := LeftStr(s, k - 1) + '#' + AllTrim(IntToStr(StmNo + 1)) +
          MidStr(s, k + 2, 255);
      TmpList.Add(s);
    end;
  end; // T2042

  If StmId = 'T776' then
  begin
    For i := 0 to T776List.Count - 1 do
    begin
      // profile fldname ndx
      k := Pos('[x', T776List[i]);
      If k > 0 then
        s := LeftStr(T776List[i], k - 1) + '[' + StmStr +
          MidStr(T776List[i], k + 2, 255)
      else
        s := T776List[i];
      // visualtax stm
      k := Pos('#y', s);
      If k > 0 then
        s := LeftStr(s, k - 1) + '#' + AllTrim(IntToStr(StmNo + 1)) +
          MidStr(s, k + 2, 255);
      TmpList.Add(s);
    end;
  end; // t776

  If StmId = 'T2125CCA' then
  begin
    For i := 0 to T2125CCAList.Count - 1 do
    begin
      // profile fldname ndx
      k := Pos('[x', T2125CCAList[i]);
      If k > 0 then
        s := LeftStr(T2125CCAList[i], k - 1) + '[' + StmStr +
          MidStr(T2125CCAList[i], k + 2, 255)
      else
        s := T2125CCAList[i];
      // visualtax stm
      k := Pos('#y', s);
      If k > 0 then
        s := LeftStr(s, k - 1) + '#' + AllTrim(IntToStr(StmNo + 1)) +
          MidStr(s, k + 2, 255);
      TmpList.Add(s);
    end;
  end; // t2125CCA

  If StmId = 'T2121CCA' then
  begin
    For i := 0 to T2121CCAList.Count - 1 do
    begin
      // profile fldname ndx
      k := Pos('[x', T2121CCAList[i]);
      If k > 0 then
        s := LeftStr(T2121CCAList[i], k - 1) + '[' + StmStr +
          MidStr(T2121CCAList[i], k + 2, 255)
      else
        s := T2121CCAList[i];
      // visualtax stm
      k := Pos('#y', s);
      If k > 0 then
        s := LeftStr(s, k - 1) + '#' + AllTrim(IntToStr(StmNo + 1)) +
          MidStr(s, k + 2, 255);
      TmpList.Add(s);
    end;
  end; // T2121CCA

  If StmId = 'T2042CCA' then
  begin
    For i := 0 to T2042CCAList.Count - 1 do
    begin
      // profile fldname ndx
      k := Pos('[x', T2042CCAList[i]);
      If k > 0 then
        s := LeftStr(T2042CCAList[i], k - 1) + '[' + StmStr +
          MidStr(T2042CCAList[i], k + 2, 255)
      else
        s := T2042CCAList[i];
      // visualtax stm
      k := Pos('#y', s);
      If k > 0 then
        s := LeftStr(s, k - 1) + '#' + AllTrim(IntToStr(StmNo + 1)) +
          MidStr(s, k + 2, 255);
      TmpList.Add(s);
    end;
  end; // T2042CCA

  {
    If StmId = 'T1164CCA' then
    begin
    For i:=0 to T1164CCAList.count -1 do
    begin
    //profile fldname ndx
    k:=Pos('[x',T1164CCAList[i]);
    If k>0 then
    s:=LeftStr(T1164CCAList[i],k-1)+'['+StmStr+MidStr(T1164CCAList[i],k+2,255)
    else
    s:=T1164CCAList[i];
    //visualtax stm
    k:=Pos('#y',s);
    If k>0 then
    s:=LeftStr(s,k-1)+'#'+Alltrim(IntToStr(StmNo+1))+MidStr(s,k+2,255);
    TmpList.Add(s);
    end;
    end; //t1164CCA
  }

  If StmId = 'T776CCA' then
  begin
    For i := 0 to T776CCAList.Count - 1 do
    begin
      // profile fldname ndx
      k := Pos('[x', T776CCAList[i]);
      If k > 0 then
        s := LeftStr(T776CCAList[i], k - 1) + '[' + StmStr +
          MidStr(T776CCAList[i], k + 2, 255)
      else
        s := T776CCAList[i];
      // visualtax stm
      k := Pos('#y', s);
      If k > 0 then
        s := LeftStr(s, k - 1) + '#' + AllTrim(IntToStr(StmNo + 1)) +
          MidStr(s, k + 2, 255);
      TmpList.Add(s);
    end;
  end; // T776CCA

end;

Function TRollGpT1_2026.IsBusStatement(FldName: String): Boolean;
begin
  Result := False;
  If (LeftStr(FldName, 5) = 'T2125') or (LeftStr(FldName, 5) = 'T2121') or
    (LeftStr(FldName, 5) = 'T2042') or (LeftStr(FldName, 4) = 'T776') or
    (LeftStr(FldName, 12) = 'Spouse.T2125') or
    (LeftStr(FldName, 12) = 'Spouse.T2121') or
    (LeftStr(FldName, 12) = 'Spouse.T2042') or
    (LeftStr(FldName, 11) = 'Spouse.T776') then
    Result := True;

end;

procedure TRollGpT1_2026.BitBtn1Click(Sender: TObject);
begin
  // 20190220
  ShellExecute(0, 'open',
    PWideChar('http://www.visualtax.com/Vt2018HELP/T1Help/Website/T1Help.html'),
    nil, nil, SW_SHOW);
  // ShowHelp('T1Help','Conversion_from_Profile');
  { Application.HelpFile :=AppDir+'\'+'T1Help.HLP';
    Application.HelpJump('Conversion_from_Profile');
  }
end;

// 20170731 Igor >>>
// Procedure TRollGpT1_2026.CheckDateFormat;
// Var WinBootDir:String;
// Begin
(*
  If (UpperCase(ShortDateFormat) <> 'MM/DD/YYYY')
  then
  ShowMessage('For best rollover of BirthDates etc. the Date format in the Windows'+
  Chr(13)+'Control Panel should be MM/DD/YYYY'
  +Chr(13)+'See Control Panel -> Regional Settings -> Customize -> Date -> Short Date Format');
*)
// WinBootDir:=GetWinBootDir;
// If (UpperCase(GetWinIniString(WinBootDir+'\'+'Win.Ini','intl','sShortDate')) <> 'MM/DD/YYYY')
// then
// ShowMessage('For best rollover of BirthDates etc. the Date format in the Windows'+
// Chr(13)+'Control Panel should be MM/DD/YYYY.'
// +Chr(13)+'See Control Panel -> Regional Settings -> Customize -> Date -> Short Date Format');
// end;
// 20170731 Igor <<<

Procedure TRollGpT1_2026.FixNISASin(RetNo: Integer);
Var
  i, FNo: Integer;
  FName: String;
Begin
  FName := 'T1163#1';
  FNo := GetFormNo(FName);
  If FNo > 0 then
  begin
    If Ret[RetNo].FormHasData['T1163#1'] then
    begin
      i := 634;
      Repeat // remove blanks from sin
        If FetchElmFNo(RetNo, FNo, i) > '' then
          StoreElm(RetNo, FNo, i, RemoveChar(FetchElmFNo(RetNo, FNo, i), ' '));
        Inc(i, 5);
      until i > 654;
    end;
  end;
end;

procedure TRollGpT1_2026.LinkToOptionsLblClick(Sender: TObject);
begin
  ExecuteForm(TOptionsFrmT1_2026);
  Close;
end;

procedure TRollGpT1_2026.GetHBPandLLP(RetNo: Integer);
Var
  FNo: Integer;
  FldName, s: String;
begin
  // HBP
  FNo := GetFormNo('RRSP');
  If Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);

  StoreElm(RetNo, FNo, 81, FormatFloat('######0.00',
    Vl(GetValue('T1RRSPDeduction[56]')) + Vl(GetValue('T1RRSPDeduction[57]'))));
  // LLP
  FNo := GetFormNo('RRSP');
  If Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
  // with drawals

  StoreElm(RetNo, FNo, 85, FormatFloat('######0.00',
    Vl(GetValue('T1RRSPDeduction[79]')) + Vl(GetValue('T1RRSPDeduction[80]'))));

end;

procedure TRollGpT1_2026.StoreData(ConvertedFlName: String);
Var
  i, j, FNo, AssetFNo, Elm: Integer;
  FName, Valu: String;
  ConvList, WList: TStringList;
begin
  Try
    ConvList := TStringList.Create;
    try
      WList := TStringList.Create;
      try
        ConvList.LoadFromFile(ConvertedFlName);
        For i := 0 to ConvList.Count - 1 do
        begin
          If AllTrim(ConvList[i]) > '' then
          begin
            Valu := '';
            FNo := 0;

            ParseWords(ConvList[i] + '^', '^', WList);
            { added a last delim in case no value }
            // 20170203
            If WList.Count >= 1 then
            Begin
              FName := AllTrim(WList[1]);
              Elm := MyStrToInt(AllTrim(WList[2]));
            End;
            If WList.Count >= 3 then
              Valu := AllTrim(WList[3])
            else
              Valu := '';

            FNo := GetFormNo(FName);
            If (FNo > 0) then
            begin
              If (Ret[RetNo].Frm[FNo].Count = 0) then
                InitFormData(RetNo, FNo);
            end;

            If (FNo = 0) and (IsFormMultiInst(FName)) then
            begin
              FNo := AddPageInstance(RetNo, ExtractNonInstFormName(FName),
                ExtractFormInst(FName));
              AddOtherPagesInstance(RetNo, ExtractNonInstFormName(FName),
                ExtractFormInst(FName));
              // Fno := GetFormNo(FName); {get it again}
              InitFormData(RetNo, FNo); // June 2002
            end;

            Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] := False;

            If (FNo > 0) and (Valu > '') then
            begin
              If (FName = 'INFO') and (Elm = 11) then
              begin
                Elm := FixMarStatus(Valu);
                Valu := 'X';
              end;
              Valu := FixValu(FName, Valu, FNo, Elm);
              StoreElm(RetNo, FNo, Elm, Valu);
              // If LeftStr(FName, 5) <> 'YRSUM' then Calc(RetNo, FName); //bad!
              If Valu > '' then
                Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] := True;
            end; { valu > '' }
          end; { alltrim of temp rec }
        end; { i }
        // 20090128
        For i := 1 to 15 do
        begin
          AssetFNo := GetFormNo('ASSETSB#' + AllTrim(IntToStr(i)));
          If AssetFNo > 0 then
            InitFormData(RetNo, AssetFNo);
        end;
        StoreElm(RetNo, GetFormNo('ASSETSB#1'), 10, 'N');
        SpCaptureCCALastYear(RetNo);
        PopulateAssets(RetNo);
      finally
        WList.Free;
      end;
    Finally
      ConvList.Free;
    End;
  except
    on E: Exception do
      MessageDlg(ConvList[i] + ' ' + E.Message, mtError, [mbok], 0);
  end; { Try }
end;

Procedure TRollGpT1_2026.SpCaptureCCALastYear(RetNo: Integer);
Var
  i, rowndx, FNo: Integer;
Begin
  FNo := GetFormNo('CCALIST');
  InitFormData(RetNo, FNo); // 20090129
  For i := 1 to 171 do
  begin
    StoreElm(RetNo, FNo, i, '');
  end; // init
  rowndx := 1;
  // Other
  ExtractCCAList(RetNo, rowndx, 'T776', 201, 237, 9);
  ExtractCCAList(RetNo, rowndx, 'T2125', 301, 371, 10);
  ExtractCCAList(RetNo, rowndx, 'T2121', 137, 207, 10);
  ExtractCCAList(RetNo, rowndx, 'T2042', 401, 471, 10);
  ExtractCCAList(RetNo, rowndx, 'T1175', 1, 71, 10);
  ExtractCCAList(RetNo, rowndx, 'T1175H', 1, 71, 10);
End;

Procedure TRollGpT1_2026.ReviseAssetsLinks(RetNo: Integer; ReverseCCA: Boolean);
var
  i, FNo: Integer;
  OldStmt, NewStmt: String;
  TempList: TStringList;
  FInst: String;
Begin
  exit; // 20091213

  // now revise assetsb
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := FRec.FormNo;
    If Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] then
    begin
      // AssetsB
      if FRec.FormName = 'ASSETSB' then
      begin
        OldStmt := FetchElmFNo(RetNo, FNo, 215);
        FInst := AllTrim(MidStr(OldStmt, 6, 2));
        If OldStmt > '' then
        begin
          If LeftStr(OldStmt, 5) = 'T2125' then
          begin
            StoreElm(RetNo, FNo, 215, 'T2125' + FInst);
            Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] := True;
          end;
        end;

        OldStmt := FetchElmFNo(RetNo, FNo, 221);
        FInst := AllTrim(MidStr(OldStmt, 6, 2));
        If OldStmt > '' then
        begin
          If LeftStr(OldStmt, 5) = 'T2125' then
          begin
            StoreElm(RetNo, FNo, 221, 'T2125' + FInst);
            Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] := True;
          end;
        end;

        OldStmt := FetchElmFNo(RetNo, FNo, 227);
        FInst := AllTrim(MidStr(OldStmt, 6, 2));
        If OldStmt > '' then
        begin
          If LeftStr(OldStmt, 5) = 'T2125' then
          begin
            StoreElm(RetNo, FNo, 227, 'T2125' + FInst);
            Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] := True;
          end;

        end;

        Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] := True;
        Calc(RetNo, FRec.FormName);
      end;
    end; // has data
  end; // i
end;

Procedure TRollGpT1_2026.ConsolIntoT2125(RetNo: Integer; ReverseCCA: Boolean);
// one time routine
Var
  i, j, k, FNo, OldFNo: Integer;
  FInst, FromFInst: String;
  FName: String;
  T2125FInst, T2125FNo: Integer;
  TempList: TStringList;
  FromStmt, ToStmt: String;
  NewStmt: String;
begin
  exit; // 20091213

  TempList := TStringList.Create;

  T2125FInst := 0;
  // T2125 first
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];

    If FRec.FormName = 'T2125' then
    begin
      OldFNo := FRec.FormNo;
      FromFInst := FRec.FormInst;
      If Ret[RetNo].FormHasData[GetFormName(RetNo, OldFNo)] then
      begin
        FromStmt := ExtractFormRootName(FRec.FormName) + FRec.FormInst;
        Inc(T2125FInst);
        T2125FNo := AddPageInstance(RetNo, 'T2125',
          '#' + AllTrim(IntToStr(T2125FInst)));
        AddOtherPagesInstance(RetNo, 'T2125',
          '#' + AllTrim(IntToStr(T2125FInst)));
        // T2125FNo:=GetFormNo('T2125'+'#'+AllTrim(IntToStr(T2125FInst)));
        InitFormData(RetNo, T2125FNo);
        InitFormData(RetNo, T2125FNo);
        // page
        For j := 73 to 74 do
          StoreElm(RetNo, T2125FNo, j, FetchElmFNo(RetNo, OldFNo, j));
        // commission or not
        For j := 1 to 18 do
          StoreElm(RetNo, T2125FNo, j, FetchElmFNo(RetNo, OldFNo, j)); // ident
        StoreElm(RetNo, T2125FNo, 17, ''); // who prepared
        For j := 23 to 25 do
          StoreElm(RetNo, T2125FNo, j, FetchElmFNo(RetNo, OldFNo, j)); // sales
        For j := 29 to 30 do
          StoreElm(RetNo, T2125FNo, j, FetchElmFNo(RetNo, OldFNo, j)); // sales
        StoreElm(RetNo, T2125FNo, 82, 'X');
        Ret[RetNo].FormHasData[GetFormName(RetNo, T2125FNo)] := True;
        FNo := GetFormNo('T2125' + '#' + AllTrim(IntToStr(T2125FInst)));
        InitFormData(RetNo, FNo);
        For j := 33 to 40 do
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, OldFNo, j));
        // cost of goods
        For j := 44 to 64 do
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, OldFNo, j)); // expenses
        Ret[RetNo].FormHasData[GetFormName(RetNo, FNo)] := True;

        TempList.Add(PaddR(FromStmt, 10) + 'T2125#' + IntToStr(T2125FInst));
        // home use c/f
        FNo := GetFormNo('T2125' + '#' + AllTrim(IntToStr(T2125FInst)));
        InitFormData(RetNo, FNo);
        OldFNo := GetFormNo('T2125' + FromFInst);
        StoreElm(RetNo, FNo, 31, FetchElmFNo(RetNo, OldFNo, 34));
        // partners
        For j := 37 to 50 do
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, OldFNo, j));
        For j := 57 to 61 do
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, OldFNo, j));
        For j := 62 to 71 do
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, OldFNo, j));
        // cec
        FNo := GetFormNo('T2125' + '#' + AllTrim(IntToStr(T2125FInst)));
        InitFormData(RetNo, FNo);
        OldFNo := GetFormNo('T2125' + FromFInst);
        StoreElm(RetNo, FNo, 342, FetchElmFNo(RetNo, OldFNo, 342));
      end; // old form has data
    end; // end T2125
  end; // i;

  // T2125FInst stays as it was
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];

    If FRec.FormName = 'T2125' then
    begin
      OldFNo := FRec.FormNo;
      FromFInst := FRec.FormInst;
      If Ret[RetNo].FormHasData[GetFormName(RetNo, OldFNo)] then
      begin
        FromStmt := ExtractFormRootName(FRec.FormName) + FRec.FormInst;
        Inc(T2125FInst);
        begin
          T2125FNo := AddPageInstance(RetNo, 'T2125',
            '#' + IntToStr(T2125FInst));
          AddOtherPagesInstance(RetNo, 'T2125', '#' + IntToStr(T2125FInst));
          // T2125FNo:=GetFormNo('T2125'+'#'+AllTrim(IntToStr(T2125FInst)));
          InitFormData(RetNo, T2125FNo);
        end;

        // If Ret[RetNo].Frm[Fno].Count =0 then
        If Ret[RetNo].Frm[T2125FNo].Count = 0 then // JZ20090205
          InitFormData(RetNo, T2125FNo);

        // page
        For j := 1 to 4 do
          StoreElm(RetNo, T2125FNo, j, FetchElmFNo(RetNo, OldFNo, j)); // ident
        StoreElm(RetNo, T2125FNo, 8, FetchElmFNo(RetNo, OldFNo, 12)); // bus nm
        StoreElm(RetNo, T2125FNo, 10, FetchElmFNo(RetNo, OldFNo, 14)); // str
        StoreElm(RetNo, T2125FNo, 13, FetchElmFNo(RetNo, OldFNo, 16)); // city
        StoreElm(RetNo, T2125FNo, 14, FetchElmFNo(RetNo, OldFNo, 17)); // postal
        StoreElm(RetNo, T2125FNo, 5, FetchElmFNo(RetNo, OldFNo, 7)); // yr end
        StoreElm(RetNo, T2125FNo, 9, FetchElmFNo(RetNo, OldFNo, 13)); // product
        StoreElm(RetNo, T2125FNo, 16, FetchElmFNo(RetNo, OldFNo, 19));
        // shelter
        StoreElm(RetNo, T2125FNo, 15, FetchElmFNo(RetNo, OldFNo, 18));
        // pertn id
        StoreElm(RetNo, T2125FNo, 18, FetchElmFNo(RetNo, OldFNo, 21));
        // percent
        StoreElm(RetNo, T2125FNo, 19, FetchElmFNo(RetNo, OldFNo, 22)); // bn1
        StoreElm(RetNo, T2125FNo, 20, FetchElmFNo(RetNo, OldFNo, 9)); // bn2
        StoreElm(RetNo, T2125FNo, 21, FetchElmFNo(RetNo, OldFNo, 23)); // bn3
        StoreElm(RetNo, T2125FNo, 12, FetchElmFNo(RetNo, OldFNo, 15));
        // ind code
        StoreElm(RetNo, T2125FNo, 17, FetchElmFNo(RetNo, OldFNo, 20));
        // who prepared

        StoreElm(RetNo, T2125FNo, 39, FetchElmFNo(RetNo, OldFNo, 26)); // fees
        StoreElm(RetNo, T2125FNo, 38, FetchElmFNo(RetNo, OldFNo, 27)); // gst
        StoreElm(RetNo, T2125FNo, 37, FetchElmFNo(RetNo, OldFNo, 28));
        // wip-end
        StoreElm(RetNo, T2125FNo, 92, FetchElmFNo(RetNo, OldFNo, 32));
        // wip-start

        StoreElm(RetNo, T2125FNo, 90, 'X');
        Ret[RetNo].FormHasData[GetFormName(RetNo, T2125FNo)] := True;

        FNo := GetFormNo('T2125' + '#' + AllTrim(IntToStr(T2125FInst)));
        If Ret[RetNo].Frm[FNo].Count = 0 then
          InitFormData(RetNo, FNo);
        For j := 44 to 55 do
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, OldFNo, j - 7));
        // expenses
        StoreElm(RetNo, FNo, 56, FetchElmFNo(RetNo, OldFNo, 70)); // supplies
        For j := 57 to 62 do
          StoreElm(RetNo, FNo, j, FetchElmFNo(RetNo, OldFNo, j - 8));
        // expenses
        StoreElm(RetNo, FNo, 63, FetchElmFNo(RetNo, OldFNo, 55)); // other
        StoreElm(RetNo, FNo, 64, FetchElmFNo(RetNo, OldFNo, 56)); // other
        Ret[RetNo].FormHasData[GetFormName(RetNo, T2125FNo)] := True;

        TempList.Add(PaddR(FromStmt, 10) + 'T2125#' + IntToStr(T2125FInst));
        // home use c/f
        FNo := GetFormNo('T2125' + '#' + AllTrim(IntToStr(T2125FInst)));
        If Ret[RetNo].Frm[FNo].Count = 0 then
          InitFormData(RetNo, FNo);
        OldFNo := GetFormNo('T2125' + FromFInst);
        StoreElm(RetNo, FNo, 31, FetchElmFNo(RetNo, OldFNo, 30));
        // partners
        StoreElm(RetNo, FNo, 57, FetchElmFNo(RetNo, OldFNo, 10));
        StoreElm(RetNo, FNo, 58, FetchElmFNo(RetNo, OldFNo, 35));
        StoreElm(RetNo, FNo, 59, FetchElmFNo(RetNo, OldFNo, 38));
        StoreElm(RetNo, FNo, 60, FetchElmFNo(RetNo, OldFNo, 41));
        StoreElm(RetNo, FNo, 61, FetchElmFNo(RetNo, OldFNo, 44));

        StoreElm(RetNo, FNo, 39, FetchElmFNo(RetNo, OldFNo, 54));
        StoreElm(RetNo, FNo, 48, FetchElmFNo(RetNo, OldFNo, 57));
        StoreElm(RetNo, FNo, 64, FetchElmFNo(RetNo, OldFNo, 60));
        StoreElm(RetNo, FNo, 67, FetchElmFNo(RetNo, OldFNo, 63));
        StoreElm(RetNo, FNo, 70, FetchElmFNo(RetNo, OldFNo, 66));

        StoreElm(RetNo, FNo, 42, FetchElmFNo(RetNo, OldFNo, 55));
        StoreElm(RetNo, FNo, 62, FetchElmFNo(RetNo, OldFNo, 58));
        StoreElm(RetNo, FNo, 65, FetchElmFNo(RetNo, OldFNo, 61));
        StoreElm(RetNo, FNo, 68, FetchElmFNo(RetNo, OldFNo, 64));
        StoreElm(RetNo, FNo, 71, FetchElmFNo(RetNo, OldFNo, 67));

        StoreElm(RetNo, FNo, 37, FetchElmFNo(RetNo, OldFNo, 51));
        StoreElm(RetNo, FNo, 40, FetchElmFNo(RetNo, OldFNo, 36));
        StoreElm(RetNo, FNo, 43, FetchElmFNo(RetNo, OldFNo, 39));
        StoreElm(RetNo, FNo, 46, FetchElmFNo(RetNo, OldFNo, 42));
        StoreElm(RetNo, FNo, 49, FetchElmFNo(RetNo, OldFNo, 45));

        StoreElm(RetNo, FNo, 38, FetchElmFNo(RetNo, OldFNo, 52));
        StoreElm(RetNo, FNo, 41, FetchElmFNo(RetNo, OldFNo, 37));
        StoreElm(RetNo, FNo, 44, FetchElmFNo(RetNo, OldFNo, 40));
        StoreElm(RetNo, FNo, 47, FetchElmFNo(RetNo, OldFNo, 43));
        StoreElm(RetNo, FNo, 50, FetchElmFNo(RetNo, OldFNo, 46));

        StoreElm(RetNo, FNo, 36, FetchElmFNo(RetNo, OldFNo, 56));
        StoreElm(RetNo, FNo, 45, FetchElmFNo(RetNo, OldFNo, 59));
        StoreElm(RetNo, FNo, 63, FetchElmFNo(RetNo, OldFNo, 62));
        StoreElm(RetNo, FNo, 66, FetchElmFNo(RetNo, OldFNo, 65));
        StoreElm(RetNo, FNo, 69, FetchElmFNo(RetNo, OldFNo, 68));

        // cec
        FNo := GetFormNo('T2125' + '#' + AllTrim(IntToStr(T2125FInst)));
        If Ret[RetNo].Frm[FNo].Count = 0 then
          InitFormData(RetNo, FNo);
        OldFNo := GetFormNo('T2125' + FromFInst);
        StoreElm(RetNo, FNo, 342, FetchElmFNo(RetNo, OldFNo, 342));
      end; // old form has data
    end; // end T2125
  end; // i
  TempList.Free;
end;

end.
