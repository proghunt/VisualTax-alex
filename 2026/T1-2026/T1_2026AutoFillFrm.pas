unit T1_2026AutoFillFrm;

// Tddelms.db  This species data categories and how to place AFR data into the program
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, vtLabel, Buttons, ExtCtrls,
  ShellAPI,
  T1_2026declare, T1_2026trimstr, T1_2026ChildWinNew, T1_2026Common2, Grids,
  CheckLst, ComCtrls,
  DB, DBTables,
  vtEditBox,
  T1_2026Calc, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart,
  // 20160721 Igor >>>
  uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager,
  uADCompClient, uADCompDataSet,
  vtMulti; // 20170726 Igor

// 20160721 Igor <<<
const
  // 20151225 igor
  WM_FILERECEIVED = WM_USER + 100;
  CHECKBOX_COL = 5; // 20180216 Igor
  { made it variable to allowa bit of testing Con
    //20151226 con
    cTDDReceivedTxtFileName = 'TddReceived-last6.txt'; //20151229 for testing TDDReceived.txt';   //20151229
    cTDDReceivedXmlFileName = 'TDDReceived.xml';
  }

  // 20180216 Igor >>>
type
  TSlipSelection = record
    Name: string;
    Checked: boolean;
  end;
  // 20180216 Igor <<<

type
  TAutoFillFrmT1_2026 = class(TForm)
    OpenDialog: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    TabControl1: TTabControl;
    GroupBox5: TGroupBox;
    FillReturnFromFileBtn: TBitBtn;
    ExitBtn2: TBitBtn;
    ViewReturnBtn: TBitBtn;
    AutoFillSectionsGroup: TGroupBox;
    DataGroups: TCheckListBox;
    AutoFillAcceptGroup: TRadioGroup;
    AutoFillBtn: TBitBtn;
    GridGroup: TGroupBox;
    StringGrid1: TStringGrid;
    Exit2Btn: TBitBtn;
    Label3: TLabel;
    Label1: TLabel;
    HelpBtn: TBitBtn;
    Panel1: TPanel;

    procedure ExitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    // procedure CreateTDDParmsFile;
    procedure TDDRetListClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure LoadSinDataBtnClick(Sender: TObject);
    procedure TabControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LoadSinData(Sin: String);
    procedure AutoFillAcceptGroupClick(Sender: TObject);
    procedure DataGroupsClick(Sender: TObject);
    procedure AutoFillBtnClick(Sender: TObject);
    // procedure ShowCurrentSlipsBtnClick(Sender: TObject);
    // procedure StatusBtnClick(Sender: TObject);
    procedure Exit2BtnClick(Sender: TObject);
    Function RenameIncomingData(S: String): String;
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState); // 20160213 //20160216 Igor
    Function GetVtValue(RNo: Integer; FName: String; Elm: Integer;
      DataName: String; SubSection: String): String; // 20160214 //20160216 Igor
    procedure HelpBtnClick(Sender: TObject); // 20160216 Igor
    procedure FormDestroy(Sender: TObject); // 20160721 Igor
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    // 20170727 Igor
    // 20180216 Igor >>>
    procedure StringGrid1Click(Sender: TObject);
    procedure DataGroupsClickCheck(Sender: TObject);
    // 20180216 Igor <<<
    // Function SubstituteElmName(XmlElmName:String):String;  //20170303

  private
    { Private declarations }

    FWaitingFile: boolean; // 20160216 Igor
    FSlipSelection: array of TSlipSelection; // 20180216 Igor

    Procedure GetSINSReceived(ReceivedFile: String;
      Var TddSinsReceived: TStringList); // 20151229
    Procedure ExtractSinData(ReceivedFile: String; Sin: String;
      Var ExtractedSinData: TStringList);
    Procedure ExtractSinSubCodeData(SubSectionCode: String;
      ExtractedSinData: TStringList; Var ExtractedSinSubCodeData: TStringList);
    // 20160111
    Procedure ExtractALLSinSubCodeData(SubSectionCode: String;
      ExtractedSinData: TStringList; Var ExtractedData: TStringList);
    procedure ExtractAndShowGroupData(GroupIndex: Integer);
    procedure UpdateTaxReturn(Sin: String; RNo: Integer);
    Procedure UpdateATaxReturnField(RNo: Integer; DataGroup, DataName, Instance,
      CraValue: String);
    Function AllGroups(DataGroup: String): boolean;
    procedure OpenTheTddElmsTable;
    Function AnyDataGroupsAccepted: boolean;
    Procedure FixInstance(Var DataList: TStringList; SlipName: String);
    // Function  IsDataGroupASlip(DataGroup:String):Boolean;
    Function CountTDDSlips(DataList: TStringList): Integer;
    Procedure UpdateTddStatus(Sin: String);
    Procedure ShowTddStatus;

    Function IsDataGroupInList(Astring: String; SomeList: TStringList): Integer;
    // 20160216 Igor
    Function CountDataGroupsAccepted: Integer;
    Procedure PopulateStringGridHeaders;
    Procedure PopulateStringGridData(SubSection: String; DataList: TStringList;
      Var R: Integer); // r=Row of grid
    procedure AutoSizeCol(Grid: TStringGrid; Column: Integer);
    Procedure ClearStringGrid;
    procedure SetColumnFullWidth(Grid: TStringGrid; ACol: Integer);

    Function GetT3MultFname(RNo: Integer; IncomingFName: String;
      Instance: String; Var Elm: Integer): String;
    Function GetT5MultFname(RNo: Integer; IncomingFName: String;
      Instance: String; Var Elm: Integer): String; // 20160113
    Procedure UncheckSomeGroups; // 20160222 //20160223 Igor
    // 20180216 Igor >>>
    procedure InitSlipSelection;
    function GetSlipSelectionIndex(ASlipName: string): Integer;
    procedure UpdateSlipSelection(AChecked: boolean; ASlipName: string = '');
    function GetSlipSelection(ASlipName: string): boolean;
    // 20180216 Igor <<<
  public
    { Public declarations }
    FileName: string;
  end;

function AutoFillToVtAddr(const ASection, ASubSection: String;
  out AVTAddr: TVTMapElement): boolean;

var
  // 20151230 con
  cTDDReceivedTxtFileName: String;
  // = 'TddReceived-last6.txt'; //20151229 for testing TDDReceived.txt';   //20151229
  cTDDReceivedXmlFileName: String; // = 'TDDReceived.xml';

  AutoFillFrm: TAutoFillFrmT1_2026;
  TddPlainRetList: TStringList;
  TestOrProduction: String;
  AcceptedReturns: TStringList;
  RNo: Integer;
  TddElmsConnection: TADConnection; // 20160721 Igor
  TddElmsTable: TADTable; // 20160721 Igor

  IncomingSlipCnt: Integer;

  SetoffNdx: Integer; // 20180204

  // 20151230
  ReceivedFile: String;
  Sin: String;
  ReceivedData: TStringList;
  ExtractedSinData: TStringList;
  ExtractedSinDataGroups: TStringList;
  ExtractedSinSubCodeData: TStringList; // 20160111

implementation

uses T1_2026main, vtTrimStr, vtCommon, vtShared, T1_2026, vtMain, // 20160204
  vtDataBase, // 20160721 Igor
  System.Generics.Collections, System.Generics.Defaults; // 20170726 Igor

var
  hThread: THandle;

  FMapInit: boolean = False;
  FAutoFillMap: TDictionary<String, TVTMapElement>;

  // TddCapGainLossDeductionIndicator: Boolean; //20170306 Igor  //already in declare 20170306 Con
{$R *.DFM}

const
  c_IncreaseFont = 1; // 2; //20160216 Igor
  c_TextMargin = 2;

procedure WorkThread(Form: TAutoFillFrmT1_2026); stdcall;
begin
  repeat
    sleep(1000);
  until FileExists(Form.FileName);
  PostMessage(Form.Handle, WM_FILERECEIVED, 0, 0);
end;

procedure TAutoFillFrmT1_2026.ExitBtn1Click(Sender: TObject);
begin
  // 20160107
  If TddSinsReceived = Nil then
    exit;
  If TddSinsReceived.count > 0 then
    MainFormT1.ShowTddStatus;
  Close;
end;

procedure TAutoFillFrmT1_2026.FormCreate(Sender: TObject);
Var
  i: Integer;
begin
  // 20160109
  OpenTheTddElmsTable;
  // 20160721 Igor >>>
  if not assigned(TddElmsTable) then
  begin
    MessageDlg(TddElmsDBLite + ' is missing', mtError, [mbOk], 0);
    Close;
    exit;
  end;
  // 20160721 Igor <<<

  RNo := TddRNo; // 20160109
  // NameLbl.Caption := GetLastName(RNo) + ', ' + GetFirstName(RNo); // 20160110 //20210208 Igor
  Sin := GetSinno(RNo);
  ReceivedFile := MkTddFileName(RNo, Sin);
  TddCapGainLossDeductionIndicator := False; // 201170305
  // memo1.lines.add(ReceivedFile);
  ExtractSinData(ReceivedFile, Sin, ExtractedSinData);
  InitSlipSelection; // 20180216 Igor
  ClearStringGrid;
  DataGroups.Items.clear;
  For i := 0 to ExtractedSinDataGroups.count - 1 do
  Begin
    DataGroups.Items.add(ExtractedSinDataGroups[i]);
    // populate the subsection list1
    If AutoFillAcceptGroup.itemIndex = 0 then
      DataGroups.Checked[i] := True;
  end;

  AutoFillAcceptGroup.itemIndex := 0; // 20160204 //20160216 Igor
  UncheckSomeGroups; // 20160222 //20160223 Igor
end;

procedure TAutoFillFrmT1_2026.FormDestroy(Sender: TObject); // 20160721 Igor
begin
  if assigned(TddElmsTable) then
    freeAndNil(TddElmsTable);
  if assigned(TddElmsConnection) then
    freeAndNil(TddElmsConnection);
end;

procedure TAutoFillFrmT1_2026.TDDRetListClick(Sender: TObject);
begin
  // CreateTddParmsFile;
end;

procedure TAutoFillFrmT1_2026.FormClose(Sender: TObject;
  var Action: TCloseAction); // 20170727 Igor
begin
  if not(fsModal in Self.FormState) then
    Action := TCloseAction.caFree;
end;

procedure TAutoFillFrmT1_2026.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  /// 20151225 igor
  if FWaitingFile then
  begin // 20160107
    if MessageDlg
      ('Application is waiting for file from CRA. Are you sure that you want to close form?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
      FWaitingFile := False
    else
      CanClose := False
  end;

end;

// 20160109  //only one sin per file
Procedure TAutoFillFrmT1_2026.ExtractSinData(ReceivedFile: String; Sin: String;
  Var ExtractedSinData: TStringList);
Var
  i, j, k: Integer;
  S, Section, SubSection, DataElmName, Instance, Value: String;
  A: TArray<string>; // 20210208 Igor
Begin
  ReceivedData := TStringList.Create;
  ExtractedSinData := TStringList.Create;
  ExtractedSinDataGroups := TStringList.Create;
  // ReceivedFile:=TddFilesDir + '\' + cTDDReceivedTxtFileName; //20160109
  ReceivedData.LoadFromFile(ReceivedFile);

  i := -1;
  Repeat
    Inc(i, 1);
    If i > ReceivedData.count - 1 then
      exit;

    // s:=ReceivedData[i];  //20160119
    S := RenameIncomingData(ReceivedData[i]);
    // 20210208 Igor >>>
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 5 then
      continue;
    SubSection := AllTrim(A[1]);
    DataElmName := AllTrim(A[2]);
    Instance := AllTrim(A[3]);
    Value := AllTrim(A[4]);
    // Section := LeftStr(S, 45);
    // SubSection := MidStr(S, 46, 35);
    //
    // DataElmName := AllTrim(MidStr(S, 81, 60));
    // Instance := MidStr(S, 141, 2);
    // Value := MidStr(S, 144, 100); // 20151230 //MidStr(S,144,9);
    // 20210208 Igor <<<
    ExtractedSinData.add(S);

    If IsDataGroupInList(SubSection, ExtractedSinDataGroups) = -1 then
    // not found in list
    begin
      ExtractedSinDataGroups.add(AllTrim(SubSection));
    end;
  Until (i > ReceivedData.count - 1);

  // 20160109
  For i := 0 to ExtractedSinData.count - 1 do
  begin
    // Memo1.Lines.add(ExtractedSinData[i]);
  end;
end;

procedure TAutoFillFrmT1_2026.InitSlipSelection; // 20180216 Igor
var
  S, SubSection, DataElmName, Instance: string;
  i, j: Integer;
  Data: TStringList;
  A: TArray<string>; // 20210208 Igor
begin
  Data := TStringList.Create;
  try
    for i := 0 to ExtractedSinDataGroups.count - 1 do
    begin
      SubSection := ExtractedSinDataGroups[i];
      if IsDataGroupASlip(SubSection) then
      begin
        Data.clear;
        ExtractSinSubCodeData(SubSection, ExtractedSinData, Data);
        FixInstance(Data, SubSection);
        for j := 0 to Data.count - 1 do
        begin
          // 20210208 Igor >>>
          A := Data[j].Split([AFRStringDelimiter]);
          if Length(A) < 3 then
            continue;
          // 20210208 Igor <<<
          Instance := '#' + AllTrim(A[1]);
          DataElmName := AllTrim(A[0]);

          if SameText(DataElmName, 'TaxYear') then // 20210208 Igor
          begin
            SetLength(FSlipSelection, Length(FSlipSelection) + 1);
            FSlipSelection[Length(FSlipSelection) - 1].Name := SubSection
              + Instance;
            FSlipSelection[Length(FSlipSelection) - 1].Checked := False;
          end;
        end;
      end;
    end;
  finally
    Data.Free;
  end;
end;

// 20160204 added to replace isInList
Function TAutoFillFrmT1_2026.IsDataGroupInList(Astring: String;
  SomeList: TStringList): Integer; // 20160216 Igor
var
  i, LengthOfKeyWord: Integer;
begin
  Result := -1;
  If SomeList.count = 0 then
    exit;
  Astring := UpperCase(AllTrim(Astring));
  LengthOfKeyWord := Length(Astring);
  For i := 0 to SomeList.count - 1 do
    if Astring = AllTrim(UpperCase(AllTrim(SomeList[i]))) then
    // if Astring = UpperCase(LeftStr(AllTrim(SomeList[i]),LengthOfKeyWord)) then
    // problem Reassessments and reassessmentsInProgress lokked the same before
    begin
      Result := i;
      exit;
    end;
end;

// 20151229
Procedure TAutoFillFrmT1_2026.ExtractSinSubCodeData(SubSectionCode: String;
  ExtractedSinData: TStringList; Var ExtractedSinSubCodeData: TStringList);
Var
  i, j: Integer;
  S, Section, SubSection, DataElmName, Instance, Value: String;
  A: TArray<string>; // 20210208 Igor
Begin
  For i := 0 to ExtractedSinData.count - 1 do
  begin
    S := ExtractedSinData[i];
    // 20210208 Igor >>>
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 5 then
      continue;
    SubSection := AllTrim(A[1]);
    DataElmName := AllTrim(A[2]);
    Instance := AllTrim(A[3]);
    Value := AllTrim(A[4]);
    // SubSection := AllTrim(MidStr(S, 46, 35));
    // DataElmName := AllTrim(MidStr(S, 81, 60));
    // Instance := AllTrim(MidStr(S, 141, 2));
    // Value := AllTrim(MidStr(S, 144, 100));
    If SubSectionCode = SubSection then
      ExtractedSinSubCodeData.add(DataElmName + AFRStringDelimiter + Instance +
        AFRStringDelimiter + Value);
    // 20210208 Igor <<<
  end;
end;

// 20151229
Procedure TAutoFillFrmT1_2026.ExtractALLSinSubCodeData(SubSectionCode: String;
  ExtractedSinData: TStringList; Var ExtractedData: TStringList);
Var
  i, j: Integer;
  S, Section, SubSection, DataElmName, Instance, Value: String;
  PrevSubSection: String;
  A: TArray<string>; // 20210208 Igor
Begin
  PrevSubSection := '';
  For i := 0 to ExtractedSinData.count - 1 do
  begin
    S := ExtractedSinData[i];
    // 20210208 Igor >>>
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 5 then
      continue;
    SubSection := AllTrim(A[1]);
    DataElmName := AllTrim(A[2]);
    Instance := AllTrim(A[3]);
    Value := AllTrim(A[4]);
    // Section:=LeftStr(s,45];
    // SubSection := AllTrim(MidStr(S, 46, 35));
    // DataElmName := AllTrim(MidStr(S, 81, 60));
    // Instance := AllTrim(MidStr(S, 141, 2));
    // Value := AllTrim(MidStr(S, 144, 100));
    // AllTrim(MidStr(S,144,9)); //20160101
    If SubSection > PrevSubSection then
    Begin
      If PrevSubSection > '' then
        ExtractedData.add('            ');
      ExtractedData.add(UpperCase(SubSection));
      PrevSubSection := SubSection;
    end;
    ExtractedData.add(DataElmName + AFRStringDelimiter + Instance +
      AFRStringDelimiter + Value)
    // 20210208 Igor <<<
  end;
end;

procedure TAutoFillFrmT1_2026.TabControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  ExtractedSinData.Free;
  ExtractedSinDataGroups.Free;
  ExtractedSinSubCodeData.Free; // 20160111
  // ExtractedSinSubSectionData.Free;

  Sin := TabControl1.tabs[TabControl1.tabindex];
  RNo := GetRetNoFromSin(Sin); // 20160102
  LoadSinData(Sin);
  ExtractAndShowGroupData(0); // first group = ALL
  // StringGrid1.vertScrollBar.Top:=0;   //20160104
end;

procedure TAutoFillFrmT1_2026.AutoSizeCol(Grid: TStringGrid; Column: Integer);
var
  i, W, WMax: Integer;
begin
  WMax := 200; // 0
  for i := 0 to (StringGrid1.RowCount - 1) do
  begin
    W := Grid.Canvas.TextWidth(StringGrid1.Cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  StringGrid1.ColWidths[Column] := WMax + 5;
end;

Procedure TAutoFillFrmT1_2026.ClearStringGrid;
Var
  i: Integer;
Begin
  for i := 0 to StringGrid1.ColCount - 1 do
    StringGrid1.Cols[i].clear;
  PopulateStringGridHeaders;
end;

// 20151229   This button was added to be able to test with existing tXT file without connecting to CRA
procedure TAutoFillFrmT1_2026.LoadSinDataBtnClick(Sender: TObject);
Var
  i: Integer;
  ReceivedFile: String;
  SubSectionCode: String;
begin
  // LoadSindata(Sin)
end;

// 20151229  NEW routines
Procedure TAutoFillFrmT1_2026.GetSINSReceived(ReceivedFile: String;
  Var TddSinsReceived: TStringList);
Var
  i: Integer;
  S, Sin, FoundNotFound, DataElmName, Value: String;
  A: TArray<string>; // 20210208 Igor
begin
  ReceivedData := TStringList.Create;
  ReceivedData.LoadFromFile(ReceivedFile);
  i := -1;
  DataElmName := '';
  Repeat
    Inc(i, 1);
    If (i > ReceivedData.count - 1) or (i > 46) then
    begin
      ReceivedData.Free;
      exit;
    end; // more than enough
    S := ReceivedData[i];
    // 20210208 Igor >>>
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 5 then
      continue;
    DataElmName := AllTrim(A[2]);
    // Section:=LeftStr(s,45];
    // SubSection:=MidStr(S,46,35);
    // DataElmName:=AllTrim(MidStr(S,81,60));
    // Instance:=MidStr(S,141,2);

    // If i>46 then begin ReceivedData.Free;exit;end;  //more than enough
    // If (i>ReceivedData.count-1) or (i>46) then begin ReceivedData.Free;exit;end;  //more than enough
    // DataElmName := AllTrim(MidStr(S, 81, 60));
    If DataElmName = 'ReferencedIndividualTaxpayerIdentifier' then
    begin
      Value := AllTrim(A[4]);
      Sin := Value;

      Inc(i, 1);
      // read next to get the Found or any other such as NO-DATA response
      S := ReceivedData[i];
      A := S.Split([AFRStringDelimiter]);
      if Length(A) < 5 then
        continue;
      DataElmName := AllTrim(A[2]);
      Value := AllTrim(A[4]);
      // DataElmName := AllTrim(MidStr(S, 81, 60));
      // Value := MidStr(S, 144, 9);
      // 20210208 Igor <<<
      FoundNotFound := Value;
      If UpperCase(FoundNotFound) = 'FOUND' then
        TddSinsReceived.add(Sin + ' ' + PaddR(FoundNotFound, 10) + ' ' +
          'TDD Received. Not Auto-filled yet')
      Else
      begin
        // ShowMessage('SIN '+sin+' maybe incorrect. No data returned by CRA');
        RNo := GetRetNoFromSin(Sin); // 20160102
        // 20160107
        If RNo > 0 then
          ShowMessage('SIN ' + Sin + ' ' + GetFirstName(RNo) + ' ' +
            GetLastName(RNo) + Chr(13) +
            'maybe incorrect or not in CRA server. No data returned by CRA');
      end;
    end;
  until (i > ReceivedData.count - 1) or (i > 46);
end;

function TAutoFillFrmT1_2026.GetSlipSelection(ASlipName: string): boolean;
// 20180216 Igor
var
  i: Integer;
begin
  Result := False;
  i := GetSlipSelectionIndex(ASlipName);
  if i >= 0 then
    Result := FSlipSelection[i].Checked;
end;

function TAutoFillFrmT1_2026.GetSlipSelectionIndex(ASlipName: string): Integer;
// 20180216 Igor
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Length(FSlipSelection) - 1 do
    if SameText(FSlipSelection[i].Name, ASlipName) then
    begin
      Result := i;
      break;
    end;
end;

procedure TAutoFillFrmT1_2026.LoadSinData(Sin: String);
Var
  i: Integer;
  ReceivedFile: String;
  SubSectionCode: String;
  // TempList:TStringList;
begin
  Sin := LeftStr(TabControl1.tabs[TabControl1.tabindex], 9);
  RNo := GetRetNoFromSin(Sin);

  ClearStringGrid;
  ExtractSinData(ReceivedFile, Sin, ExtractedSinData);
  // start with first SIN/tab and also the groups of data (subsection)

  DataGroups.Items.clear;
  // DataGroups.Items.Add('ALL DATA GROUPS');   //20160102   //removed : It does not work properly

  { Uknown solution to sort descending
    TempList:=TStringList.Create; //use it to get a sorthed grouplist, as the cheklist is hard to sort?
    For i:=0 to ExtractedSinDataGroups.count-1 do TempList.Add(ExtractedSinDataGroups[i]);
    TempList.Sorted:=True;
    For i:=0 to TempList.count-1 do DataGroups.Items.add(TempList[i]); //populate the datagroups list (subsections)
    Templist.free;
  }

  For i := 0 to ExtractedSinDataGroups.count - 1 do
  Begin
    DataGroups.Items.add(ExtractedSinDataGroups[i]);
    // populate the subsection list1
    If AutoFillAcceptGroup.itemIndex = 0 then
      DataGroups.Checked[i] := True;
  end;

end;

procedure TAutoFillFrmT1_2026.AutoFillAcceptGroupClick(Sender: TObject);
Var
  i: Integer;
begin
  // 20180216 Igor >>>
  Case AutoFillAcceptGroup.itemIndex of
    0:
      begin
        For i := 0 to DataGroups.Items.count - 1 do
          DataGroups.Checked[i] := True;
        UpdateSlipSelection(True);
      end;
    2:
      begin
        For i := 0 to DataGroups.Items.count - 1 do
          DataGroups.Checked[i] := False;
        UpdateSlipSelection(False);
      end;
  end;
  // 20180216 Igor <<<
  UncheckSomeGroups; // 20160222 //20160223 Igor
  DataGroups.Refresh;
end;

procedure TAutoFillFrmT1_2026.DataGroupsClick(Sender: TObject); // 20151231
Var
  i: Integer;
  SubSectionCode: String;
  DataList: TStringList; // 20151230
begin
  if DataGroups.itemIndex = -1 then
    exit; // 20240205 Igor
  ExtractAndShowGroupData(DataGroups.itemIndex);
  // 20160222
  UncheckSomeGroups; // 20160223 Igor
  DataGroups.Refresh; // 20160223 Igor
end;

procedure TAutoFillFrmT1_2026.DataGroupsClickCheck(Sender: TObject);
// 20180216 Igor
begin
  if DataGroups.itemIndex <> -1 then
    UpdateSlipSelection(DataGroups.Checked[DataGroups.itemIndex],
      DataGroups.Items[DataGroups.itemIndex]);
end;

procedure TAutoFillFrmT1_2026.ExtractAndShowGroupData(GroupIndex: Integer);
Var
  i: Integer;
  SubSectionCode: String;
  DataList: TStringList; // 20151230
  C, R: Integer; // grid colmn and Row
begin
  ExtractedSinSubCodeData := TStringList.Create; // 20160111
  SubSectionCode := AllTrim(DataGroups.Items[GroupIndex]);
  GridGroup.Caption := SubSectionCode;
  If RNo > 0 then
    GridGroup.Caption := SubSectionCode; // 20160116

  If AllGroups(SubSectionCode) then
  begin
    (* show one by one to navigate   LATER
      C:=0;R:=0;
      ClearStringGrid;  //20160102
      For i:=1 to DataGroups.Items.count-1 do
      Begin
      ExtractSinSubCodeData(SubSectionCode,ExtractedSinData,ExtractedSinSubSectionData);
      ClearStringGrid;  //20151230
      R:=0;  //20160101
      PopulateStringGridData(SubSectionCode,ExtractedSinSubSectionData,R);
      Sleep(1000);
      //ShowMessage(Click
      end
    *)
  end
  (* LATER
    begin
    //R:=R+1;StringGrid1.cells[C,R]:=UpperCase(DataGroups.Items[i]); //20160102  //group header
    // R:=R+1;
    ExtractSinSubCodeData(DataGroups.Items[i],ExtractedSinData,ExtractedSinSubSectionData);
    PopulateStringGridData(DataGroups.Items[i],ExtractedSinSubSectionData,R); //20160102
    StringGrid1.TopRow:=1;  //20160101
    R:=R+1;StringGrid1.cells[C,R]:='  '; //20160102  //group separator headr
    end;
  *)
  Else
  Begin
    ExtractSinSubCodeData(SubSectionCode, ExtractedSinData,
      ExtractedSinSubCodeData);
    If IsDataGroupASlip(SubSectionCode) then
      FixInstance(ExtractedSinSubCodeData, SubSectionCode); // 20160111
    ClearStringGrid; // 20151230
    R := 0;
    PopulateStringGridData(SubSectionCode, ExtractedSinSubCodeData, R);
    // 20160111
  end;
end;

procedure TAutoFillFrmT1_2026.SetColumnFullWidth(Grid: TStringGrid;
  ACol: Integer);
var
  i: Integer;
  FixedWidth: Integer;
begin
  with Grid do
    if ACol >= FixedCols then
    begin
      FixedWidth := 0;
      for i := 0 to FixedCols - 1 do
        Inc(FixedWidth, ColWidths[i] + GridLineWidth);
      ColWidths[ACol] := ClientWidth - FixedWidth - GridLineWidth;
    end;
end;

procedure TAutoFillFrmT1_2026.OpenTheTddElmsTable;
begin
  // 20160721 Igor >>>
  TddElmsConnection := TADConnection.Create(nil);
  TddElmsTable := TADTable.Create(nil);
  if not SetTableName(TddElmsConnection, TddElmsTable,
    IncludeTrailingPathDelimiter(AppDir) + TddElmsDBLite, TddElmsTableLite,
    'FIELDKEY') then
  begin
    freeAndNil(TddElmsConnection);
    freeAndNil(TddElmsTable);
  end;

  // TddElmsTable := TTable.Create(Application);
  // TddElmsTable.DataBaseName := AppDir;
  // TddElmsTable.TableName := 'TddElms.dbf';
  // TddElmsTable.IndexName := 'FieldKey';      //Subsection-and-data element
  // If TddElmsTable.Active then TddElmsTable.Close;
  // If not TddElmsTable.Active then TddElmsTable.Open;
  // 20160721 Igor <<<

end;

Function TAutoFillFrmT1_2026.AllGroups(DataGroup: String): boolean;
Begin
  Result := False;
  If UpperCase(LeftStr(DataGroup, 3)) = 'ALL' then
    Result := True;
end;

(*
  procedure TAutoFillFrm.ShowCurrentSlipsBtnClick(Sender: TObject);
  Var FrmName:String;
  begin
  RNo:=GetRetNoFromSin(SIN);
  If RNo=0 then
  Begin
  ShowMessage('The tax return is not loaded');
  Exit;
  End;
  ShowAForm(RNo,'T4SUM#1');
  end;
*)

Procedure TAutoFillFrmT1_2026.PopulateStringGridHeaders;
Var
  i, MaxW, AvgW, NarrowColumnsW, RemainingW: Integer;
begin
  // 20160216 Igor
  // 20180216 Igor >>>
  MaxW := GroupBox5.width - AutoFillSectionsGroup.width -
    GetSystemMetrics(SM_CXVSCROLL) - GetSystemMetrics(SM_CXEDGE) * 2;
  With StringGrid1 do
  Begin
    AvgW := MaxW div ColCount;
    ColWidths[1] := AvgW Div 2; // Box
    ColWidths[2] := AvgW Div 2; // instance
    NarrowColumnsW := ColWidths[1] + ColWidths[2]; // +ColWidths[5];
    RemainingW := MaxW - NarrowColumnsW;
    ColWidths[0] := Trunc(RemainingW / 3) + 150; // fixed
    RemainingW := RemainingW - ColWidths[0];
    ColWidths[3] := Trunc(RemainingW / 2.1) - 10;
    // Trunc(RemainingW / 1.5); //20160214
    ColWidths[4] := ColWidths[3] - 5; // 20160214
    ColWidths[5] := 25; // 20160214
    StringGrid1.Canvas.Font.Style := [fsBold];
    StringGrid1.Cells[0, 0] := 'Data Name';
    StringGrid1.Cells[1, 0] := 'Box No';
    StringGrid1.Cells[2, 0] := 'Slip No'; // 'Instance No';   //20160117
    StringGrid1.Cells[3, 0] := 'Value provided by CRA';
    StringGrid1.Cells[4, 0] := 'Currently in tax return'; // 20160214
    StringGrid1.Cells[5, 0] := '';
  End;
  // 20180216 Igor <<<
  (*
    MaxW:=PageControl1.width-AutoFillSectionsGroup.width;
    With StringGrid1 do
    Begin
    AvgW:=MaxW div ColCount;
    ColWidths[1]:=AvgW Div 2;  //Box
    ColWidths[2]:=AvgW Div 2;  //instance
    NarrowColumnsW:=ColWidths[1]+ColWidths[2]; //+ColWidths[5];
    RemainingW:=MaxW-NarrowColumnsW;
    ColWidths[0]:=Trunc(RemainingW / 3)+150; //fixed
    RemainingW:=RemainingW-ColWidths[0];
    ColWidths[3]:=Trunc(RemainingW / 1.5); //2.5); //fixed //Value Cra  //20160119
    // ColWidths[4]:=Trunc(RemainingW / 2.5); //fixed  //Value VT

    StringGrid1.Canvas.Font.Style := [fsBold];
    StringGrid1.cells[0,0]:='Data Name';
    StringGrid1.cells[1,0]:='Box No';
    StringGrid1.cells[2,0]:='Slip No'; //'Instance No';   //20160117
    StringGrid1.cells[3,0]:='Value provided by CRA';

    StringGrid1.cells[4,0]:='Currently in tax return';  //20160214
    // StringGrid1.cells[5,0]:='Accept(Y/N)';
    End;
  *)
end;

Procedure TAutoFillFrmT1_2026.PopulateStringGridData(SubSection: String;
  DataList: TStringList; Var R: Integer);
Var
  i, C: Integer;
  DataName: String;
  Instance: String;
  CraValue: String;
  FieldKey: String;
  BoxNo: String;
  FName: String;
  Elm: Integer;
  vtValue: String;
  IsDollar: boolean; // to get vt data
  A: TArray<string>; // 20210208 Igor
begin
  StringGrid1.RowCount := ExtractedSinData.count + 10; // 20160108
  // If DataList.count>StringGrid1.rowCount then
  // StringGrid1.RowCount := StringGrid1.RowCount + DataList.count-StringGrid1.rowCount;  //20151230
  C := 0;
  // R:=R+1;StringGrid1.cells[C,R]:=UpperCase(SubSection); //20160102  //group separator headr  //20160116

  for i := 0 to DataList.count - 1 do // for each data elent
  begin
    // 20210208 Igor >>>
    A := DataList[i].Split([AFRStringDelimiter]);
    if Length(A) < 3 then
      continue;
    DataName := AllTrim(A[0]);
    // 20160117
    if IsDataGroupASlip(SubSection) then
      Instance := '#' + AllTrim(A[1])
    else
      Instance := '';

    CraValue := AllTrim(A[2]);
    // 20210208 Igor <<<

    // get the rest from the tddElms data base i.e boxno

    FieldKey := SubSection + '-' + DataName;
    // FieldKey:=SubSection+'-'+SubstituteElmName(DataName);  //20170303

    if TddElmsTable.FindKey([FieldKey]) = True then
    begin
      FName := TddElmsTable.FieldByName('FormName').AsString;
      if UpperCase(TddElmsTable.FieldByName('Section').AsString) = 'SLIPS' then
        FName := FName + Instance
      else
        Instance := '';

      BoxNo := TddElmsTable.FieldByName('BoxNo').AsString;
      // 20160216 Igor
      // 20160214
      if AllTrim(TddElmsTable.FieldByName('IsDollar').AsString) = 'Y' then
        IsDollar := True
      else
        IsDollar := False;

      // 20210208 Igor >>>
      if IsDollar = True then
        CraValue := FormatFloat('###,###,###.00', vl(AllTrim(A[2]))) // 20160214
      else
        CraValue := AllTrim(A[2]); // 20160214
      // 20210208 Igor <<<

      // 20160214
      {
        If AllTrim(TddElmsTable.FieldByName('ElmNo').AsString)='$' then
        IsDollar:=True else IsDollar:=False;
      }

      if Numeric(TddElmsTable.FieldByName('ElmNo').AsString) then
        Elm := StrToInt(TddElmsTable.FieldByName('ElmNo').AsString)
      else
        Elm := 0;

      RNo := GetRetNoFromSin(Sin);
      // 20160214
      if IsDollar = True then
        vtValue := FormatFloat('###,###,###.00',
          vl(GetVtValue(RNo, FName, Elm, DataName, SubSection)))
      else
        vtValue := GetVtValue(RNo, FName, Elm, DataName, SubSection);
      // 20160214

      { 20160214
        If (RNo>0) and (Fname>'') and (Elm>0) then
        vtValue:=FetchElm(RNo,FName,Elm)
        Else
        vtValue:=' ';
      }
    end // fieldkey
    else // key npt found
    begin
      vtValue := '';
      if AllGroups(SubSection) = False then
      begin
        // Memo1.Lines.add('Field name '+FieldKey+' was not found - Contact ViualTax');
        // ShowMessage('Field name '+FieldKey+' was not found - Contact ViualTax');
      end;
    end;
    // now show on the grid
    R := R + 1; // increase row for each data element
    if not SameText(DataName, 'TaxYear') then // 20210208 Igor
    begin
      C := 0;
      StringGrid1.Cells[C, R] := DataName;
    end
    else
    begin
      R := R + 1;
      C := 0;
      StringGrid1.Cells[C, R] := DataName;
      // 20180216 Igor >>>
      if IsDataGroupASlip(SubSection) then
        StringGrid1.Cells[CHECKBOX_COL, R] :=
          IntToStr(GetSlipSelectionIndex(SubSection + Instance));
      // 20180216 Igor <<<
    end;

    C := 1;
    StringGrid1.Cells[C, R] := BoxNo; // box
    C := 2;
    StringGrid1.Cells[C, R] := Instance; // instance
    C := 3;
    StringGrid1.Cells[C, R] := CraValue;
    C := 4;
    StringGrid1.Cells[C, R] := vtValue; // vt value  //20160214
  end; // i
end;

procedure TAutoFillFrmT1_2026.AutoFillBtnClick(Sender: TObject);
Var
  i, k: Integer;
  Msg: String;
  DataGroup: String; // 20170419
begin
  If (CountDataGroupsAccepted > 0) and
    (CountDataGroupsAccepted < DataGroups.Items.count) then // 20160120
  Begin
    if MessageDlg('Only some data are selected for Auto-fill My Return' + Chr(13) +
      'Proceed?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      // ok
    Else
      exit;
  End;

  If CountDataGroupsAccepted = 0 then // 20160120
  begin
    if MessageDlg('No data groups checked for Autofill My Return.' + Chr(13) +
      'Exit without Auto-filling My Return?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
      // ok
    Else
      exit;
  End;

  RNo := GetRetNoFromSin(Sin);
  If RNo = 0 then
  Begin
    ShowMessage('The tax return is not loaded. No update done.');
    exit;
  End;

  StoreElm(RNo,InfoFNo,143,FormatDateTime('yyyy-mm-dd', date)); //20260214 CZ

  // 20170419
  For i := 0 to DataGroups.Items.count - 1 do
  begin
    DataGroup := DataGroups.Items[i];

    If (DataGroups.Checked[i] = True) and (Ret[RNo].MarStatus < 3) then
    // 20160109  //ONLY if CHECKED AS ACCEPTED
    Begin
      if (UpperCase(DataGroup) = 'T3SLIP') Then
      Begin
        If MessageDlg('If you Autofilled the spouse already for T3' + Chr(13) +
          'you should un-tick the T3 from this spouse and handle it manually' +
          Chr(13) + 'Un-tick them now?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
        then
        Begin
          exit;
        End;
      End;
    End;
  end;

  // 20170419
  For i := 0 to DataGroups.Items.count - 1 do
  begin
    DataGroup := DataGroups.Items[i];
    If (DataGroups.Checked[i] = True) and (Ret[RNo].MarStatus < 3) then
    // 20160109  //ONLY if CHECKED AS ACCEPTED
    Begin
      if (UpperCase(DataGroup) = 'T5SLIP') Then
      Begin
        If MessageDlg('If you Autofilled the spouse already for T5' + Chr(13) +
          'you should un-tick the T5 from this spouse and handle it manually' +
          Chr(13) + 'Un-tick them now?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
        then
        Begin
          exit;
        End;
      End;
    End;
  end;

  UpdateTaxReturn(Sin, RNo);
  // ShowMessage('Tax return has been updated');
  UpdateTddStatus(Sin);

  // in case T4a and T1204 coming in with Business income //20190209
  if vl(FetchElm(RNo, 'T4A#1', 3)) > 0 then
    StoreElm(RNo, 'T4A', 12, '1'); // 20190223
  if vl(FetchElm(RNo, 'T4A#1', 62)) > 0 then
    StoreElm(RNo, 'T4A', 11, '1'); // 20190223

  if vl(FetchElm(RNo, 'T1204#1', 3)) + vl(FetchElm(RNo, 'T1204#1', 4)) > 0 then
    StoreElm(RNo, 'T1204#1', 17, '1'); // 20190223
  // if FetchElm(RNo,'T1204#1',17)='' then StoreElm(RNo,'T1204#1',17,'1');//20190223
  Calc(RNo, 'T4A#1');
  Calc(RNo, 'T1204#1');
  Calc(RNo, 'T2125#1');

  MainFormT1.RecalcBtnClick(Sender); // FullReturn(RNo);   //20160113

  Ret[RNo].Changed := True; // 20170301 Igor

  OpenForm(RNo, GetFormNo('CDE'), 0); // 20170204


  //20260214
  if Ret[RNo].FrmHasData[GetFormNo('T5008DTL#1')] then
  Begin
    ShowMessage('T5008 retrieved via Auto-fill My Return are not posted automatically to Schedule 3'+ chr(13)+
     ' They are all captured in T5008DTL form(s)'+
     ' But you may need to Review them first before posting them to Schedule 3:'+Chr(13)+
       '1. Open Form T5018, click the button LIST All T5008 Auto-fill My Return slips,'+
         ' scroll the List down and mark down Dispositions Box 21 and Capital Gains Box 20 total amounts.'+Chr(13)+
       '2. Then enter these totals on the Summary section of the T5008 form'+
         ' on the designated line for Auto-fill My Return totals. They will be posted automatically on S3');

     if MessageDlg('Review them now?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
      OpenForm(RNo, GetFormNo('T5008'), 0);
   end;
  {  //20260214
  if Ret[RNo].FrmHasData[GetFormNo('T5008DTL#1')] then
    if MessageDlg(Review them now?'T5008 slip(s) from Auto-fill were captured in T5008DTL' +
      Chr(13) + 'They are not updating the T5008 Summary automatically. Review them now?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
      OpenForm(RNo, GetFormNo('T5008DTL#1'), 0); // 20170204
  }

  //20260216
  If TddCapGainLossDeductionIndicator = True then // 201170305
  begin
    if MessageDlg('There is data received via Auto-fill My Return, relevant to' + Chr(13) +
      'Capital Gains and Losses or Capital Gains Deduction or Non-Capital Losses.'
      + Chr(13) + ' ' + Chr(13) +
      'You may have received Capital Gains amounts that cannot be posted on'+
      ' Schedule 3 directly as such amounts are calculated by the program'+
      ' from other data entry amounts' +
      Chr(13)+' Please use Schedule 3 and/or CFR form to enter such amounts to arrive at the calculated amounts.' +
      Chr(13) + 'Review them now and mark them down?', mtInformation, [mbYes, mbNo], 0) = mrYes
    then
      OpenForm(RNo, GetFormNo('CFRAFILL'), 0); // 20170204
  end;
  Close; // 20160117
end;

procedure TAutoFillFrmT1_2026.UpdateTaxReturn(Sin: String; RNo: Integer);
Var
  FNo, CFRAFillFNo, CDEFNo: Integer;
  i, j, J1, J2: Integer;
  X: real; // 20180219
  UnfiledCnt, UnfiledNdx, ReassessmentCnt, ReassessmentNdx,
    ReassessmentInProgressCnt, ReassessmentInProgressNdx: Integer;
  DataGroup: String;
  DataElmName: String;
  Instance: String;
  CraValue: String;
  NonCapitalLossIndex, CapitalGainDeductionIndex, CapitalGainLossIndex: Integer;
  RRSPFNo, RRSPIndex1, RRSPIndex2: Integer;
  SlipIndex: Integer; // 20180216 Igor
  S: String; // 20200213
  A: TArray<string>; // 20210208 Igor
  ProgramNo: Integer; //20260214 Igor
  FPhone, FDesc: string; //20260214 Igor
begin
  StoreElm(RNo, 'INFO', 143, FormatDateTime('yyyy-mm-dd', Date)); // 20200212
  UnfiledCnt := 0;
  UnfiledNdx := 103 - 1; // 13 - 1; // 1 less //20190206

  ReassessmentCnt := 0;
  ReassessmentNdx := 23 - 1;

  ReassessmentInProgressCnt := 0;
  ReassessmentInProgressNdx := 43 - 1;

  CFRAFillFNo := GetFormNo('CFRAFILL');
  RRSPFNo := GetFormNo('RRSP');
  ExtractedSinSubCodeData := TStringList.Create;
  try
    NonCapitalLossIndex := 65 - 4; // starting line for saving

    CapitalGainLossIndex := 153 - 6;
    CapitalGainDeductionIndex := 285 - 5;
    RRSPIndex1 := 103 - 3;
    RRSPIndex2 := 133 - 5; // 133-10 ?
    For i := 0 to DataGroups.Items.count - 1 do
    begin
      DataGroup := DataGroups.Items[i];
      If DataGroups.Checked[i] then // ONLY if CHECKED AS ACCEPTED
      Begin
        IncomingSlipCnt := 0;
        SetoffNdx := 75 - 7;

        ExtractedSinSubCodeData.clear;
        // only one slip in the ExtractedSinSubCodeData
        ExtractSinSubCodeData(DataGroup, ExtractedSinData,
          ExtractedSinSubCodeData);

        For j := 0 to ExtractedSinSubCodeData.count - 1 do
        begin
          // 20210208 Igor >>>
          A := ExtractedSinSubCodeData[j].Split([AFRStringDelimiter]);
          if Length(A) < 3 then
            continue;
          DataElmName := AllTrim(A[0]);
          // DataElmName := AllTrim(LeftStr(ExtractedSinSubCodeData[j], 62));
          If IsDataGroupASlip(DataGroup) and SameText(DataElmName, 'TaxYear')
          then
          Begin
            IncomingSlipCnt := IncomingSlipCnt + 1;
            Instance := '#' + AllTrim(IntToStr(IncomingSlipCnt));
          End;
          // 20180216 Igor >>>
          If IsDataGroupASlip(DataGroup) and
            not GetSlipSelection(DataGroup + Instance) then
            continue;
          // 20180216 Igor <<<

          CraValue := AllTrim(A[2]);
          // 20210208 Igor <<<

          // T5013   //20220217
          If DataGroup = 'T5013Slip' then
          Begin
            If DataElmName = 'PartnerCode' Then
              StoreElm(RNo, GetFormNo('T5013#1'), 1, CraValue);
            If DataElmName = 'CountryCode' Then
              StoreElm(RNo, GetFormNo('T5013#1'), 6, CraValue);
            If DataElmName = 'RecipientType' Then
              StoreElm(RNo, GetFormNo('T5013#1'), 46, CraValue);

            If DataElmName = 'PartnerPercentageShareOfPartnership' Then
              StoreElm(RNo, GetFormNo('T5013#1'), 36, CraValue);

            If DataElmName = 'TotalLimitedPartnerBusinessIncomeOrLoss' Then
              StoreElm(RNo, GetFormNo('T5013#1'), 47, CraValue);
            If DataElmName = 'TotalBusinessIncomeOrLoss' Then
              StoreElm(RNo, GetFormNo('T5013#1'), 49, CraValue);
            If DataElmName = 'TotalCapitalGainsOrLosses' Then
              StoreElm(RNo, GetFormNo('T5013#1'), 51, CraValue);

            If DataElmName = 'CapitalCostAllowance' Then
              StoreElm(RNo, GetFormNo('T5013#1'), 35, CraValue);
          End;

          // rrsp
          If DataGroup = 'RegisteredRetirementSavingsPlan' then
          Begin
            If DataElmName = 'DeductionLimitAmount' Then
            Begin
              StoreElm(RNo, GetFormNo('CFRAFILL'), 2, CraValue);
              StoreElm(RNo, RRSPFNo, 1, CraValue);
            end;
            If DataElmName = 'UnusedContributionAmount' Then
            Begin
              StoreElm(RNo, GetFormNo('CFRAFILL'), 1, CraValue);
              StoreElm(RNo, GetFormNo('CFR'), 31, CraValue);
            End;
          end

          // 20180205
          Else If DataGroup = 'ManitobaRentAssistSlip' then
          Begin
            If DataElmName = 'ManitobaShelterBenefitAmount' Then
            Begin
              StoreElm(RNo, GetFormNo('MB479'), 145, CraValue);
              StoreElm(RNo, CDEFNo, 8, CraValue)
            end;
          end

          // 20180204
          Else If DataGroup = 'DisabilityEligibilities' then
          Begin
            If DataElmName = 'DisabilityAmountEligibilityCode' Then
            Begin
              If CraValue = 'SELF' then
                StoreElm(RNo, GetFormNo('INFO'), 87, 'X');
              StoreElm(RNo, CDEFNo, 8, CraValue)
            end;
          end

          // 20220214
          Else if DataGroup = 'TuitioFednEducationTextBookAmount' then
          Begin
            // ShowMessage('Tution unused amount');
            If DataElmName = 'CarryFordAvailableAmount' Then
            begin
              StoreElm(RNo, GetFormNo('S11'), 13, CraValue);
              StoreElm(RNo, GetFormNo('CFRAFILL'), 6, CraValue);
            end;
          end

          Else if DataGroup = 'TuiProvtionEducationTextBookAmount' then
          Begin
            // ShowMessage('Tution unused amount');
            If DataElmName = 'CarrwardAvailableAmount' Then
            begin
              StoreElm(RNo, GetFormNo('S11PRV'), 13, CraValue);
              StoreElm(RNo, GetFormNo('CFRAFILL'), 7, CraValue);
            end;
          end

          Else If DataGroup = 'HomeBuyerPlanRequiredRepaymentAmount' Then
          // 20220214
          Begin
            If DataElmName = 'RequiredRepayment' Then
            Begin
              StoreElm(RNo, RRSPFNo, 88, 'Y');
              StoreElm(RNo, RRSPFNo, 72, CraValue);
            End;
          end

          Else If DataGroup = 'HomeBuyerPlan' Then // 20220214
          Begin
            If DataElmName = 'HomeBuyerPlanRepayableBalanceAmount' Then
            Begin
              StoreElm(RNo, RRSPFNo, 80, CraValue);
            End;
            If DataElmName = 'HomeBuyerPlanRemainingamount' Then
            Begin
              StoreElm(RNo, RRSPFNo, 91, CraValue);
            End;
          end
          {
            Else If DataGroup = 'HomeBuyerPlan' Then // 20180105
            Begin
            If DataElmName = 'HomeBuyerPlanRequiredRepaymentAmount' Then
            Begin
            // StoreElm(RNo, GetFormNo('CFRAFILL'), 3, CraValue); not there  //20220214
            StoreElm(RNo, RRSPFNo, 88, 'Y');
            StoreElm(RNo, RRSPFNo, 72, CraValue);
            End;
            If DataElmName = 'HomeBuyerPlanOutstandingBalanceAmount' Then
            Begin
            StoreElm(RNo, GetFormNo('CFRAFILL'), 10, CraValue);
            StoreElm(RNo, RRSPFNo, 88, 'Y');
            StoreElm(RNo, RRSPFNo, 80, CraValue);
            End;
            end
          }

          // 20230121
          Else If DataGroup = 'LifeLongLearningPlan' then
          Begin
            // 20230121
            If DataElmName =
              'LifeLongLearningPlanRequiredRepaymentRemainingAmount' Then
            Begin
              StoreElm(RNo, GetFormNo('CFRAFILL'), 4, CraValue);
              StoreElm(RNo, RRSPFNo, 75, CraValue);
              StoreElm(RNo, RRSPFNo, 88, 'Y');
            end;
            If DataElmName = 'LifeLongLearningPlanRepayableBalanceAmount' Then
            Begin
              StoreElm(RNo, GetFormNo('CFRAFILL'), 11, CraValue);
              StoreElm(RNo, RRSPFNo, 84, CraValue);
            End;
          end

          { //20230121
            // LLLP //20180205
            Else If DataGroup = 'LifeLongLearningPlan' then
            Begin
            If DataElmName = 'LifeLongLearningPlanRequiredRepaymentAmount' Then
            Begin
            StoreElm(RNo, GetFormNo('CFRAFILL'), 4, CraValue);
            StoreElm(RNo, RRSPFNo, 75, CraValue);
            StoreElm(RNo, RRSPFNo, 88, 'Y');
            end;
            If DataElmName = 'LifeLongLearningPlanOutstandingBalanceAmount' Then
            Begin
            StoreElm(RNo, GetFormNo('CFRAFILL'), 11, CraValue);
            StoreElm(RNo, RRSPFNo, 84, CraValue);
            End;
            end
          }
          Else If DataGroup = 'Client' then
          Begin
            CDEFNo := GetFormNo('CDE');
            If DataElmName = 'RefundExaminationIndicator' Then
              StoreElm(RNo, CDEFNo, 1, CraValue)
            else If DataElmName = 'GSTHSTReturnIndicator' Then
              StoreElm(RNo, CDEFNo, 2, CraValue)
            else If DataElmName = 'WorkingIncomeTaxBenefitIndicator' Then
              StoreElm(RNo, CDEFNo, 3, CraValue)
            else If DataElmName = 'CurrentYearReturnIndicator' Then
              StoreElm(RNo, CDEFNo, 4, CraValue)
            else If DataElmName = 'BankruptIndicator' Then
              StoreElm(RNo, CDEFNo, 5, CraValue)
            else If DataElmName = 'ImmigrationDate' Then
              StoreElm(RNo, CDEFNo, 6, CraValue)
            else If DataElmName = 'EmigrationDate' Then
              StoreElm(RNo, CDEFNo, 7, CraValue)
              // else If DataElmName = 'DisabilityAmountEligibilityCode' Then
              // StoreElm(RNo, CDEFNo, 8, CraValue)
            else If DataElmName = 'RefundSetoffCode' Then
              StoreElm(RNo, CDEFNo, 9, CraValue)
            else If DataElmName = 'BalancingOwingAmount' Then
              StoreElm(RNo, CDEFNo, 10, CraValue);
          end // client

          Else If DataGroup = 'UnfiledReturn' then
          begin
            If SameText(DataElmName, 'TaxYear') Then // 20210208 Igor
            begin
              UnfiledCnt := UnfiledCnt + 1;
              UnfiledNdx := UnfiledNdx + 1;
              If UnfiledCnt < 13 then // 20190205
                StoreElm(RNo, CDEFNo, UnfiledNdx, CraValue);
            end;
          end

          Else If (DataGroup = 'Reassessment') and (ReassessmentCnt < 11) then
          begin
            If SameText(DataElmName, 'TaxYear') Then // 20210208 Igor
            Begin
              ReassessmentCnt := ReassessmentCnt + 1;
              ReassessmentNdx := ReassessmentNdx + 1;
              StoreElm(RNo, CDEFNo, ReassessmentNdx, CraValue);
            end
            Else If DataElmName = 'ReassessmentDate' Then
              StoreElm(RNo, CDEFNo, ReassessmentNdx + 10, CraValue);
          end

          Else If (DataGroup = 'ReassessmentInProgress') and
            (ReassessmentInProgressCnt < 11) then
          begin
            If DataElmName = 'ReassessmentInProgressIndicator' Then
            Begin
              ReassessmentInProgressCnt := ReassessmentInProgressCnt + 1;
              ReassessmentInProgressNdx := ReassessmentInProgressNdx + 1;
              StoreElm(RNo, CDEFNo, ReassessmentInProgressNdx, CraValue);
            end
            Else If DataElmName = 'ReassessmentTaxYear' Then
            begin
              StoreElm(RNo, CDEFNo, ReassessmentInProgressNdx + 10, CraValue);
            end;
          end

          Else If DataGroup = 'Summary' then
          Begin
            If DataElmName = 'InstalmentAmount' then
              StoreElm(RNo, GetFormNo('DIRECT'), 4, CraValue);
            If (DataElmName = 'ForeignPropertyDeclaredIndicator') and
              (CraValue = 'true') then
              StoreElm(RNo, InfoFNo, 86, 'X'); // 20200121
          end

          // 20200212
          Else If DataGroup = 'T2202Slip' then
          Begin
            If DataElmName = 'TotalEligibleTuitionFeesAmount' Then
              StoreElm(RNo, GetFormNo('T2202'), 2, CraValue);
            If DataElmName = 'TotalNumberOfPartTimeMonthsCount' Then
              StoreElm(RNo, GetFormNo('T2202'), 3, CraValue);
            If DataElmName = 'TotalNumberOfFullTimeMonthsCount' Then
              StoreElm(RNo, GetFormNo('T2202'), 4, CraValue);
          end

          Else If DataGroup = 'FedTuitionEducationTextBookAmount' then
          Begin
            If DataElmName = 'CarryForwardAvailableAmount' Then
            Begin
              // 20200408
              StoreElm(RNo, GetFormNo('CFRAFILL'), 6, CraValue);
              // StoreElm(RNo, GetFormNo('S11'), 13, CraValue); Do not Post them
            end;
          end

          Else If DataGroup = 'ProvTuitionEducationTextBookAmount' then
          Begin
            If DataElmName = 'CarryForwardAvailableAmount' Then
            Begin
              // 20200408
              StoreElm(RNo, GetFormNo('CFRAFILL'), 7, CraValue);
              // StoreElm(RNo, GetFormNo('S11PRV'), 13, CraValue); //do not post them
            end;
          end

          Else If DataGroup = 'NonCapitalLoss' then
          Begin
            If SameText(DataElmName, 'TaxYear') then // 20210208 Igor
            begin
              Inc(NonCapitalLossIndex, 4);
              StoreElm(RNo, CFRAFillFNo, NonCapitalLossIndex, CraValue);
            end
            Else If DataElmName = 'CurrentYearNonCapitalLossAmount' then
              StoreElm(RNo, CFRAFillFNo, NonCapitalLossIndex + 1, CraValue)
            Else If DataElmName = 'PriorYearNonCapitalLossAmount' then
              StoreElm(RNo, CFRAFillFNo, NonCapitalLossIndex + 2, CraValue)
            Else If DataElmName = 'SubsequentYearNonCapitalLossAmount' then
              StoreElm(RNo, CFRAFillFNo, NonCapitalLossIndex + 3, CraValue);
            TddCapGainLossDeductionIndicator := True;
          end

          Else If DataGroup = 'CapitalGainLoss' then
          Begin
            If SameText(DataElmName, 'TaxYear') then // 20210208 Igor
            begin
              Inc(CapitalGainLossIndex, 6);
              StoreElm(RNo, CFRAFillFNo, CapitalGainLossIndex, CraValue);
            end
            Else If DataElmName = 'InclusionRate' then
              StoreElm(RNo, CFRAFillFNo, CapitalGainLossIndex + 1, CraValue)
            Else If DataElmName = 'TaxableCapitalGainAmount' then
              // 'Taxable' then  //20180206
              StoreElm(RNo, CFRAFillFNo, CapitalGainLossIndex + 2, CraValue)
            Else If DataElmName = 'UnappliedNetLossAmount' then
              StoreElm(RNo, CFRAFillFNo, CapitalGainLossIndex + 3, CraValue)
            Else If DataElmName = 'PriorYearNetLossAmount' then
              StoreElm(RNo, CFRAFillFNo, CapitalGainLossIndex + 4, CraValue)
            Else If DataElmName = 'SubsequentYearNetLossAmount' then
              StoreElm(RNo, CFRAFillFNo, CapitalGainLossIndex + 5, CraValue);
            TddCapGainLossDeductionIndicator := True;
          end

          Else If DataGroup = 'CapitalGainDeduction' then
          Begin
            If SameText(DataElmName, 'TaxYear') then // 20210208 Igor
            begin
              Inc(CapitalGainDeductionIndex, 5);
              StoreElm(RNo, CFRAFillFNo, CapitalGainDeductionIndex, CraValue);
            end
            Else If DataElmName = 'CapitalGainDeductionAmount' then
              StoreElm(RNo, CFRAFillFNo, CapitalGainDeductionIndex +
                1, CraValue)
            Else If DataElmName = 'NetCapitalGainLossAmount' then
              StoreElm(RNo, CFRAFillFNo, CapitalGainDeductionIndex +
                2, CraValue)
            Else If DataElmName = 'NetFarmPropertyDispositionAmount' then
              StoreElm(RNo, CFRAFillFNo, CapitalGainDeductionIndex +
                3, CraValue)
            Else If DataElmName = 'NetSmallBusinessShareDispositionAmount' then
              StoreElm(RNo, CFRAFillFNo, CapitalGainDeductionIndex + 4,
                CraValue);
            TddCapGainLossDeductionIndicator := True;
          end

          // 20180215
          Else If DataGroup = 'RRSPContributionReceiptSlip' then
          Begin
            If SameText(DataElmName, 'TaxYear') then // 20210208 Igor
            begin
              // 20170726 Igor>>>
              Inc(RRSPIndex1, 3); // original: Inc(RRSPIndex1, 1);
              Inc(RRSPIndex2, 5); // 20180219
              // 20170726 Igor<<<
              StoreElm(RNo, RRSPFNo, RRSPIndex1, CraValue);
            end
            Else If DataElmName = 'IssuerName' then
              StoreElm(RNo, RRSPFNo, RRSPIndex1 + 1, CraValue)
            Else If DataElmName = 'SlipVersionDescription' then
              StoreElm(RNo, RRSPFNo, RRSPIndex1 + 2, CraValue)
            Else
              // 20170726 Igor >>>
              If DataElmName = 'RRSPNumber' then
              begin
                Inc(RRSPIndex2, 5); // 20180215
                StoreElm(RNo, RRSPFNo, RRSPIndex2, CraValue)
              end
              Else If DataElmName = 'RRSPContractNumber' then
                StoreElm(RNo, RRSPFNo, RRSPIndex2 + 1, CraValue) // 20180215
              Else If DataElmName = 'RRSPSpouseContributionIndicator' then
                StoreElm(RNo, RRSPFNo, RRSPIndex2 + 2, CraValue)
              Else If DataElmName = 'PriorYearRRSPContributionAmount' then
                StoreElm(RNo, RRSPFNo, RRSPIndex2 + 3, CraValue)
              Else If DataElmName = 'CurrentYearRRSPContributionAmount' then
                StoreElm(RNo, RRSPFNo, RRSPIndex2 + 4, CraValue)
                // 20170726 Igor<<<
          end

          Else If DataGroup = 'DisabilityEligibilities' then
          Begin
            If DataElmName = 'DisabilityAmountEligibilityCode' then
            Begin
              StoreElm(RNo, GetFormNo('CDE'), 8, CraValue);
            End;
          End

          Else If DataGroup = 'RefundSetoff' then
          Begin
            CDEFNo := GetFormNo('CDE');
            If DataElmName = 'RefundSetoffProgramCode' then
            Begin
              // Inc(SetoffCnt,1);
              if (SetoffNdx = 13) then SetoffNdx:= 18 else //20260214 Igor
              if (SetoffNdx = 96) then SetoffNdx:= 13 else //20260214 Igor
              Inc(SetoffNdx, 7);
            End;
            // StoreElm(RNo, CDEFNo ,SetoffNdx, IntToStr(SetoffCnt));
            If DataElmName = 'RefundSetoffProgramCode' then
            Begin
              StoreElm(RNo, CDEFNo, SetoffNdx, CraValue);
              StoreElm(RNo, CDEFNo, SetoffNdx + 3,
                'Outstanding debt with government program');
            End
            else If DataElmName = 'RefundSetoffProgramAmount' then
              StoreElm(RNo, CDEFNo, SetoffNdx + 1, CraValue)
            else If DataElmName = 'RefundSetoffProgramNumber' then
              StoreElm(RNo, CDEFNo, SetoffNdx + 2, '#' + CraValue)
            //20260214 Igor >>>
            else
            if DataElmName.Equals('RefundSetoffProgramID') then
            begin
              ProgramNo:= StrToIntDef(CraValue, 0);
              if (ProgramNo > 0) and GetPhoneByProgramNumber(ProgramNo, FPhone, FDesc) then
                StoreElm(RNo, CDEFNo, SetoffNdx + 4, FPhone) //Add program phone number by program number for external
              else
              if not CraValue.IsEmpty and GetInternalPhoneByProgramNumber(CraValue, FPhone, FDesc) then
                StoreElm(RNo, CDEFNo, SetoffNdx + 4, FPhone); //Add program phone number by program number for internal

              if not CraValue.IsEmpty then
              begin
                StoreElm(RNo, CDEFNo, SetoffNdx + 2, CraValue); //Add program number
                if not FDesc.IsEmpty then StoreElm(RNo, CDEFNo, SetoffNdx + 3, FDesc); //Add program descr by program number
              end;
            end
            ;
            //20260214 Igor <<<
          End

          Else // other data groups
            UpdateATaxReturnField(RNo, DataGroup, DataElmName, Instance,
              CraValue);
        end; // update fields
      end // checked
    end; // i
  finally
    ExtractedSinSubCodeData.Free;
  end;
  StoreElm(RNo, GetFormNo('INFO'), 222, 'X'); // Autofilled indicator
  // 20180219 //copy CRA rrsp contr to the normal part of the VT RRSP screen

  i := 135; // index to CRA RRSP Contribution data
  J1 := 17; // Index to VT RRSP prior yer data
  J2 := 44; // Index to VT RRSP prior yer data
  FNo := GetFormNo('RRSP');
  Repeat
    if FetchElmFNo(RNo, FNo, i) <> '1' then // spousal  i.e fld 135
    Begin // own
      StoreElm(RNo, FNo, J1, FetchElmFNo(RNo, FNo, i + 1)); // 136 to 17
      StoreElm(RNo, FNo, J2, FetchElmFNo(RNo, FNo, i + 2)); // 137 to
    End
    Else
    Begin
      StoreElm(RNo, FNo, J1 + 1, FetchElmFNo(RNo, FNo, i + 1));
      StoreElm(RNo, FNo, J2 + 1, FetchElmFNo(RNo, FNo, i + 2));
    End;
    Inc(i, 5);
    // 20180219
    Inc(J1, 4);
    Inc(J2, 4);
  Until i > 160; // we cannot handle more than 6 lines
  // 20180219  Qustionable for Test #2
  if (vl(FetchElm(RNo, FNo, 41)) > 0) and (vl(FetchElm(RNo, FNo, 84)) > 0) then
    StoreElm(RNo, FNo, 98, 'X');

  Calc(RNo, 'RRSP'); // 20180215

  // 20180219
  X := vl(FetchElm(RNo, 'PRPP#1', 4));
  if X > 0 then
    StoreElm(RNo, GetFormNo('PRPP#1'), 7, FormatFloat('#######.##', X / 2));
  // 20180219

  // need to apply exchage rate and recalc the T5 here? Calc(RNo,'T5MULT#1');  //20230305
  Calc(RNo, 'CFR');
  CalcFullReturn(RNo);
  MainForm.RefreshAuditPanel(RNo);
end;

Procedure TAutoFillFrmT1_2026.UpdateATaxReturnField(RNo: Integer;
  DataGroup, DataName, Instance, CraValue: String);

Var
  FNo: Integer;
  FieldKey: String;
  BoxNo: String;
  FName: String;
  Elm: Integer;
  IncomingFName: String;
Begin

  If (DataGroup = '') Or (DataName = '') then
    exit;
  FieldKey := DataGroup + '-' + DataName;
  If TddElmsTable.FindKey([FieldKey]) = True then
  Begin
    FName := UpperCase(TddElmsTable.FieldByName('FormName').AsString);
    If UpperCase(TddElmsTable.FieldByName('Section').AsString) = 'SLIPS' then
      FName := FName + Instance
    Else
      Instance := '';
    IncomingFName := FName;
    BoxNo := TddElmsTable.FieldByName('BoxNo').AsString;
    If Numeric(TddElmsTable.FieldByName('ElmNo').AsString) then
      Elm := StrToInt(TddElmsTable.FieldByName('ElmNo').AsString)
    else
      Elm := 0;
  end;
  // Look after multicolumn slips i.e. T3Mult and T5Mult
  If Elm > 0 then
  Begin
    If (LeftStr(IncomingFName, 3) = 'T5#') then
    begin
      IncomingFName := ExtractNonInstFormName(IncomingFName) + '#' +
        AllTrim(IntToStr(IncomingSlipCnt));
      FName := GetT5MultFname(RNo, IncomingFName, Instance, Elm);
      // change fname, and elm due to multiple
    end
    else If (LeftStr(IncomingFName, 3) = 'T3#') then
    begin
      IncomingFName := ExtractNonInstFormName(IncomingFName) + '#' +
        AllTrim(IntToStr(IncomingSlipCnt));
      FName := GetT3MultFname(RNo, IncomingFName, Instance, Elm);
      // change fname, and elm due to multiple
    end;

    FNo := GetFormNo(FName);
    If (FNo = 0) and (IsFormMultiInst(FName)) then
    begin
      AddPageInstance(RNo, ExtractNonInstFormName(FName),
        ExtractFormInst(FName));
      FNo := GetFormNo(FName); { get it again }
      If FNo > 0 then
        InitFormData(RNo, FNo);
    end;
    If FNo > 0 then
    begin
      StoreElm(RNo, FNo, Elm, CraValue);
      Calc(RNo, FName);
      If CraValue > '' then
        Ret[RNo].FrmHasData[FNo] := True;
    end;
  end;
end;

procedure TAutoFillFrmT1_2026.UpdateSlipSelection(AChecked: boolean;
  // 20180216 Igor
  ASlipName: string);
var
  i: Integer;
begin
  for i := 0 to Length(FSlipSelection) - 1 do
    if (ASlipName = '') or SameText(Copy(FSlipSelection[i].Name, 1,
      Length(ASlipName)), ASlipName) then
      FSlipSelection[i].Checked := AChecked;
  StringGrid1.Invalidate;
end;

Function TAutoFillFrmT1_2026.AnyDataGroupsAccepted: boolean;
Var
  i: Integer;
Begin
  For i := 0 to DataGroups.Items.count - 1 do
    If DataGroups.Checked[i] then
      exit(True);
  Result := False;
end;

Function TAutoFillFrmT1_2026.CountDataGroupsAccepted: Integer;
Var
  i: Integer;
Begin
  Result := 0;
  For i := 0 to DataGroups.Items.count - 1 do
  begin
    If DataGroups.Checked[i] then
      Result := Result + 1;
  end;
end;

Function TAutoFillFrmT1_2026.CountTDDSlips(DataList: TStringList): Integer;
// DataList is a string list with only a specific type of slip
// DataList contains only a single type of slip such as T3Slip
// each one separated by a TAXYEAR
Var
  i: Integer;
  S: String;
  A: TArray<string>; // 20210208 Igor
Begin
  Result := 0;
  For i := 0 to DataList.count - 1 do
  Begin
    S := UpperCase(DataList[i]);
    // 20210208 Igor >>>
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 3 then
      continue;
    If SameText(AllTrim(A[0]), 'TAXYEAR') then
      Result := Result + 1;
    // 20210208 Igor <<<
  end;
End;

Procedure TAutoFillFrmT1_2026.FixInstance(Var DataList: TStringList;
  SlipName: String);
// if the section is Slips, the subsection has T4Slip, T4ASlip atc
// instance always comes as 01
Var
  i, j, InstNo: Integer;
  S: String;
  Value: String;
  FirstRec: boolean;
  DataElmName, Instance: String;
  A: TArray<string>; // 20210208 Igor
begin
  If CountTDDSlips(DataList) < 1 then // 20210208 Igor
    exit; // no need to do anything
  InstNo := 0;
  i := 0;
  FirstRec := True;
  Repeat
    S := DataList[i];
    // 20210208 Igor >>>
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 3 then
      continue;
    DataElmName := AllTrim(A[0]);
    Instance := AllTrim(A[1]);
    If SameText(DataElmName, 'TAXYEAR') THEN
    // means another slip of same type or a slip of diferent type
    Begin
      If FirstRec then // beginning of Slips subsection =First slip
      begin
        InstNo := InstNo + 1; // increment each time a TAXYEAR is encountered
        S := DataList[i];
        Instance := IntToStr(InstNo);
        DataList[i] := A[0] + AFRStringDelimiter + Instance +
          AFRStringDelimiter + A[2];
        i := i + 1;
        FirstRec := False;
      end
      Else // not first taxyear  (not first slip)
      Begin
        InstNo := InstNo + 1;
        S := DataList[i];
        Instance := IntToStr(InstNo);
        DataList[i] := A[0] + AFRStringDelimiter + Instance +
          AFRStringDelimiter + A[2];
        i := i + 1;
      end;
    end // first rec of each instance of s slip
    Else
    begin
      S := DataList[i];
      Instance := IntToStr(InstNo);
      DataList[i] := A[0] + AFRStringDelimiter + Instance +
        AFRStringDelimiter + A[2];
      Inc(i, 1);
    end;
    // 20210208 Igor <<<
  until i > DataList.count - 1;
end;

Procedure TAutoFillFrmT1_2026.UpdateTddStatus(Sin: String);
Begin
End;

procedure TAutoFillFrmT1_2026.Exit2BtnClick(Sender: TObject);
begin
  Close; // 20160110
end;

Procedure TAutoFillFrmT1_2026.ShowTddStatus;
begin
  MainFormT1.ShowTddStatus;
end;

// 14022016 //20160216 Igor
Function TAutoFillFrmT1_2026.GetT3MultFname(RNo: Integer; IncomingFName: String;
  Instance: String; Var Elm: Integer): String;
Var
  i, k: Integer;
  InstNoForElm, InstNo: Integer;
  FNo: Integer;
  IncomingElm: Integer;
  Inst: String;
  // 20160120
begin
  Inst := AllTrim(MidStr(ExtractFormInst(IncomingFName), 2, 3));
  InstNo := StrToInt(Inst);

  If InstNo > 5 then // find proper column instance
    if InstNo mod 5 = 0 then
      InstNoForElm := 5
    else
      InstNoForElm := InstNo mod 5
  else
    InstNoForElm := InstNo;

  Elm := Elm + (InstNoForElm - 1) * 1; // seems all elms increment by one

  If InstNo > 5 then
    // the instance should change and the Elm should change . I.e. first five slips are on T3MULT#1, Next 5 on T3Mult#2, etc
    if InstNo mod 5 = 0 then
      InstNo := (InstNo div 5) // if div evenly handle differently
    else
      InstNo := (InstNo div 5) + 1
  else
    InstNo := 1;

  Result := ExtractNonInstFormName(IncomingFName) + 'MULT' + '#' +
    AllTrim(IntToStr(InstNo)); // came in as #3, ends up as #1 (5 per inst)

end;

// 20160214  //14022016 //20160216 Igor
Function TAutoFillFrmT1_2026.GetT5MultFname(RNo: Integer; IncomingFName: String;
  Instance: String; Var Elm: Integer): String;
Var
  i, k: Integer;
  InstNoForElm, InstNo: Integer;
  FNo: Integer;
  IncomingElm: Integer;
  Inst: String;
  // original instance comes as is #1, #2, etc
  // this converts the the T5MULTFname to #1
begin
  Inst := AllTrim(MidStr(ExtractFormInst(IncomingFName), 2, 3));
  // should be incoming fname
  InstNo := StrToInt(Inst); // inst per slip  //20160113

  If InstNo > 5 then // find proper column instance
    if InstNo mod 5 = 0 then
      InstNoForElm := 5
    else
      InstNoForElm := InstNo mod 5
  else
    InstNoForElm := InstNo;

  IncomingElm := Elm; // for testing //201601Fname

  // 20170420
  if Elm = 168 then
  // fields from 168 column not incremented consistently on the form, remove 168 from Case statement
  begin
    if InstNoForElm > 1 then // if first column leave it, otherwise
      Elm := Elm + 1 + (InstNoForElm - 1) * 1; // add one and increment by 1
  end;

  Case Elm of
    1, 6, 7, 8, 9, 10, 11, 12, 13, 16, 18, 19, 20, 180, 181:
      Elm := Elm + (InstNoForElm - 1) * 22; // increment by 22
    141, 150, 156, 162, 168, 182:
      Elm := Elm + (InstNoForElm - 1) * 1; // increment by 1
  end; // case

  If InstNo > 5 then
    // the instance should change and the Elm should change . I.e. first five slips are on T3MULT#1, Next 5 on T3Mult#2, etc
    if InstNo mod 5 = 0 then
      InstNo := (InstNo div 5) // if div evenly handle differently
    else
      InstNo := (InstNo div 5) + 1
  else
    InstNo := 1;

  Result := ExtractNonInstFormName(IncomingFName) + 'MULT' + '#' +
    AllTrim(IntToStr(InstNo)); // came in as #3, ends up as #1 (5 per inst)

  // ShowMessage('Incoming and resulting Fname and Elm=' +Chr(13)+IncomingFName+'     Elm='+IntToStr(IncomingElm)
  // +Chr(13)+Result+' elm='+IntToStr(Elm));

end;

Function TAutoFillFrmT1_2026.RenameIncomingData(S: String): String;
// Renamed subsection
Const
  LongPRPP = 'PooledRegisteredPensionPlan';

Var
  k: Integer;
  Section, SubSection: String;
  IncomingElmName, NewElmName: String;

  SlipAndValue: String;

Begin
  Result := S;
  Section := LeftStr(S, 45);
  SubSection := MidStr(S, 46, 35);
  IncomingElmName := AllTrim(MidStr(S, 81, 60));
  If LeftStr(Section, 14) = 'FederalTuition' then
  begin
    SubSection := 'Fed' + SubSection;
    Result := Section + LeftStr(SubSection, 35) + MidStr(S, 81, 170);
  end
  Else If LeftStr(Section, 17) = 'ProvincialTuition' then
  begin
    SubSection := 'Prov' + SubSection;
    S := Section + LeftStr(SubSection, 35) + MidStr(S, 81, 170);
    Result := Section + LeftStr(SubSection, 35) + MidStr(S, 81, 170);
  end;
  // 20170304
  if (AllTrim(UpperCase(SubSection)) = 'PRPPSLIP') and
    (AllTrim(LeftStr(IncomingElmName, 8)) = 'Employee') // 20180119
  then
  begin
    S := AllTrim(ReplaceStr(S, LongPRPP, 'PRPP'));
    k := Pos('Amount', S); // smaller now
    if k > 0 then
    Begin
      SlipAndValue := lTrim(MidStr(S, k + 6, 30));
      S := MidStr(S, 1, k + 5);
      S := PaddR(S, 141);
      S := S + SlipAndValue;
    End;
    Result := S;
  end;
End;

// 20160216 Igor
procedure TAutoFillFrmT1_2026.HelpBtnClick(Sender: TObject);
begin
  MainFormT1.HelpByVisualTax1Click(Application);
end;

procedure TAutoFillFrmT1_2026.StringGrid1Click(Sender: TObject);
// 20180216 Igor
var
  SlipIndex: Integer;
begin
  if (StringGrid1.Col = CHECKBOX_COL) and
    (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] <> '') then
  begin
    SlipIndex := StrToIntDef(StringGrid1.Cells[StringGrid1.Col,
      StringGrid1.Row], -1);
    if SlipIndex >= 0 then
    begin
      FSlipSelection[SlipIndex].Checked := not FSlipSelection
        [SlipIndex].Checked;
      StringGrid1.Invalidate;
      if FSlipSelection[SlipIndex].Checked and not DataGroups.Checked
        [DataGroups.itemIndex] then
        DataGroups.Checked[DataGroups.itemIndex] := True;
    end;
  end;
end;

// 20160114 //20160216 Igor
procedure TAutoFillFrmT1_2026.StringGridDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  HighlightCell = 4;
  HighlightCompareCell = 3;

  // 20180216 Igor >>>
var
  SlipIndex, cbStyle: Integer;
  R: TRect;
  // 20180216 Igor <<<

begin
  // Change header font 2016/02/13 Igor
  with TStringGrid(Sender) do
  Begin
    if ARow < FixedRows then
    begin
      // Set font style
      Canvas.Font.Style := [fsBold];
      Canvas.Font.Size := Font.Size + c_IncreaseFont;
      // Draw Text
      Canvas.TextOut(Rect.Left + c_TextMargin, Rect.Top + c_TextMargin,
        Cells[ACol, ARow]);
    end;

    // 20180216 Igor >>>
    if ACol = CHECKBOX_COL then
    begin
      SlipIndex := StrToIntDef(Cells[ACol, ARow], -1);
      if SlipIndex >= 0 then
      begin
        Canvas.FillRect(Rect);
        R := Rect;
        InflateRect(R, -2, -2);
        R.Right := R.Right - 2;
        if FSlipSelection[SlipIndex].Checked then
          cbStyle := DFCS_BUTTONCHECK + DFCS_CHECKED
        else
          cbStyle := DFCS_BUTTONCHECK;
        DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, cbStyle);
      end;
    end
    else
      // 20180216 Igor <<<
      // highlight differences: added by con  20140214  BUT fixed by IGOR on 20160214
      If (ARow >= FixedRows) and (ACol = HighlightCell) then
      begin
        If (Cells[HighlightCell, ARow] <> Cells[HighlightCompareCell, ARow]) and
          (LeftStr(UpperCase(Cells[HighlightCell, ARow]), 3) <> 'N/A') and
          (UpperCase(LeftStr(Cells[HighlightCell, ARow], 3)) <> 'SEE') and
          (UpperCase(LeftStr(Cells[HighlightCell, ARow], 6)) <> 'REVIEW') then
        Begin
          /// Fill Background
          // Canvas.Brush.Color := clYellow;
          // Canvas.FillRect(Rect);
          // Change Font Color
          Canvas.Font.Color := clRed;
          Canvas.TextOut(Rect.Left + c_TextMargin, Rect.Top + c_TextMargin,
            Cells[HighlightCell, ARow]);
        end;
      end;
  end; // with
end;

// 20160216 Igor
Function TAutoFillFrmT1_2026.GetVtValue(RNo: Integer; FName: String;
  Elm: Integer; DataName: String; SubSection: String): String;
Var
  Inst, SingleInst, MultiInst: String;
  InstNo, InstNoForElm: Integer;
Begin
  If (SubSection = 'FedTuitionEducationTextBookAmount') and
    (DataName = 'CarryForwardAvailableAmount') then
  begin
    FName := 'S11';
    Elm := 13;
  End;

  If (SubSection = 'ProvTuitionEducationTextBookAmount') and
    (DataName = 'CarryForwardAvailableAmount') then
  begin
    FName := 'S11PRV';
    Elm := 13;
  End;

  If DataName = 'DeductionLimitAmount' then
  begin
    FName := 'RRSP';
    Elm := 11;
  end;
  If DataName = 'HomeBuyerPlanRequiredRepaymentAmount' then
  begin
    FName := 'RRSP';
    Elm := 72;
  end;
  // If DataName='LifeLongLearningPlanRequiredRepaymentAmount' then begin FName:='RRSP'; Elm:=75;end;

  If (LeftStr(FName, 3) = 'T3#') or (LeftStr(FName, 3) = 'T5#') then
  begin
    Inst := AllTrim(MidStr(ExtractFormInst(FName), 2, 3));
    // should be incoming fname
    InstNo := StrToInt(Inst); // inst per slip  //20160113
    FName := LeftStr(FName, 2) + 'MULT';
    Case InstNo of
      1 .. 5:
        FName := FName + '#1';
      6 .. 10:
        FName := FName + '#2';
      11 .. 15:
        FName := FName + '#3';
      16 .. 20:
        FName := FName + '#4';
      21 .. 25:
        FName := FName + '#5';
      26 .. 30:
        FName := FName + '#6';
      31 .. 35:
        FName := FName + '#7';
    end;

  end;

  if InstNo > 5 then // find proper column number
    if InstNo mod 5 = 0 then
      InstNoForElm := 5
    else
      InstNoForElm := InstNo mod 5
  else
    InstNoForElm := InstNo;

  if (LeftStr(FName, 2) = 'T5') then
  begin
    Case Elm of
      1, 6, 7, 8, 9, 10, 11, 12, 13, 16, 18, 19, 20, 21, 180, 181:
        Elm := Elm + (InstNoForElm - 1) * 22;
      // increment by 22 141,150,156,162,168:Elm:=Elm+(InstNoForElm-1)*1; //increment by 1
    end; // case
  end
  else if (LeftStr(FName, 2) = 'T3') then
  begin
    Elm := Elm + (InstNoForElm - 1) * 1; // seems all elms increment by one
  end;

  if (RNo > 0) and (FName > '') and (Elm > 0) then
    Result := FetchElm(RNo, FName, Elm)
  Else
    Result := '';

  If SubSection = 'T5008Slip' then
    Result := 'Review T5008 Summary'; // 20180215
  If DataName = 'UnfiledReturn' then
    Result := 'N/A';
  If SubSection = 'Client' then
    Result := 'N/A (See CDE form)';
  If SubSection = 'ReassessmentInProgress' then
    Result := 'N/A';
  If SubSection = 'Reassessment' then
    Result := 'N/A';

  If SubSection = 'RRSPContributionReceiptSlip' then
    Result := 'See form RRSP';
  If SubSection = 'NonCapitalLoss' then
    Result := 'See forms CFR/CFRAFill';
  If SubSection = 'CapitalGainLoss' then
    Result := 'See forms CFR/CFRAFill';
  If SubSection = 'CapitalGainDeduction' then
    Result := 'See forms CFR/CFRAFill';
  If SubSection = 'NonCapitalLoss' then
    Result := 'See forms CFR/CFRAFill';

end;

Procedure TAutoFillFrmT1_2026.UncheckSomeGroups; // 20160222 //20160223 Igor
// Procedure TAutoFillFrmT1_2026. UncheckSomeGroups;  //20160222 //20160223 Igor
Var
  i: Integer;
Begin
  For i := 0 to DataGroups.Items.count - 1 do
  Begin
    { 20170302
      If (DataGroups.Items[i]='CapitalGainDeduction')
      Or (DataGroups.items[i]='CapitalGainLoss') then
      begin DataGroups.checked[i]:=False;DataGroups.refresh;end;
    }
  end;
end;

procedure InitMap;
var
  T: TADTable;
  Con: TADConnection;
  ElmNo: Integer;
  // ME: TVTMapElement;
begin
  FAutoFillMap.clear;
  Con := TADConnection.Create(nil);
  try
    T := TADTable.Create(nil);
    try
      T.Connection := Con;
      if not SetTableName(Con, T, IncludeTrailingPathDelimiter(AppDir) +
        TddElmsDBLite, TddElmsTableLite, 'FIELDKEY') then
        exit;
      T.First;
      while not T.Eof do
      begin
        // 20170729 Igor>>>
        if (T.FieldByName('FORMNAME').AsString <> '') then
        begin
          ElmNo := StrToIntDef(T.FieldByName('ELMNO').AsString, 0);
          FAutoFillMap.add(T.FieldByName('FIELDKEY').AsString.ToLower,
            TArray<TVTElement>.Create
            (TVTElement.Create(T.FieldByName('FORMNAME').AsString,
            T.FieldByName('BOXNO').AsString, ElmNo))); // 20170729 Igor
        end;
        // 20170729 Igor<<<
        T.Next;
      end;
    finally
      T.Free;
    end;
  finally
    Con.Free;
  end;

  // >>>>>>>>>>>>>>>>>>>>>>
  // 20170729 Igor>>>
  FAutoFillMap.AddOrSetValue
    (Lowercase('RegisteredRetirementSavingsPlan-DeductionLimitAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 2),
    TVTElement.Create('RRSP', '', 1)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('RegisteredRetirementSavingsPlan-UnusedContributionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 1),
    TVTElement.Create('CFR', '', 31)));

  FAutoFillMap.AddOrSetValue(Lowercase('Client-RefundExaminationIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 1)));
  FAutoFillMap.AddOrSetValue(Lowercase('Client-GSTHSTReturnIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 2)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('Client-WorkingIncomeTaxBenefitIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 3)));
  FAutoFillMap.AddOrSetValue(Lowercase('Client-CurrentYearReturnIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 4)));
  FAutoFillMap.AddOrSetValue(Lowercase('Client-BankruptIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 5)));
  FAutoFillMap.AddOrSetValue(Lowercase('Client-ImmigrationDate'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 6)));
  FAutoFillMap.AddOrSetValue(Lowercase('Client-EmigrationDate'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 7)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('Client-DisabilityAmountEligibilityCode'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 8)));
  FAutoFillMap.AddOrSetValue(Lowercase('Client-RefundSetoffCode'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 9)));
  FAutoFillMap.AddOrSetValue(Lowercase('Client-BalancingOwingAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 10)));

  FAutoFillMap.AddOrSetValue(Lowercase('UnfiledReturn-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 13)));

  FAutoFillMap.AddOrSetValue(Lowercase('Reassessment-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 23)));
  FAutoFillMap.AddOrSetValue(Lowercase('Reassessment-ReassessmentDate'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 33)));

  FAutoFillMap.AddOrSetValue
    (Lowercase('ReassessmentInProgress-ReassessmentInProgressIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 43)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('ReassessmentInProgress-ReassessmentTaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 53)));

  FAutoFillMap.AddOrSetValue
    (Lowercase('Summary-HomeBuyerPlanRequiredRepaymentAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 3),
    TVTElement.Create('RRSP', '', 88, 1, 'Y'), TVTElement.Create('RRSP',
    '', 72)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('Summary-LifeLongLearningPlanRequiredRepaymentAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 4),
    TVTElement.Create('RRSP', '', 75)));
  FAutoFillMap.AddOrSetValue(Lowercase('Summary-InstalmentAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('DIRECT', '', 4)));

  FAutoFillMap.AddOrSetValue
    (Lowercase('FedTuitionEducationTextBookAmount-CarryForwardAvailableAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 6),
    TVTElement.Create('S11', '', 13)));

  FAutoFillMap.AddOrSetValue
    (Lowercase
    ('ProvTuitionEducationTextBookAmount-CarryForwardAvailableAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 7),
    TVTElement.Create('S11PRV', '', 13)));

  FAutoFillMap.AddOrSetValue(Lowercase('NonCapitalLoss-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 65, 4)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('NonCapitalLoss-CurrentYearNonCapitalLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 66, 4)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('NonCapitalLoss-PriorYearNonCapitalLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 67, 4)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('NonCapitalLoss-SubsequentYearNonCapitalLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 68, 4)));

  FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 153, 6)));
  FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-InclusionRate'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 154, 6)));
  FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-InclusionRate'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 155, 6)));
  FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-Taxable'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 157, 6)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('CapitalGainLoss-UnappliedNetLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 158, 6)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('CapitalGainLoss-PriorYearNetLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 159, 6)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('CapitalGainLoss-SubsequentYearNetLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 160, 6)));

  FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainDeduction-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 285, 5)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('CapitalGainDeduction-CapitalGainDeductionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 286, 5)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('CapitalGainDeduction-NetCapitalGainLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 287, 5)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('CapitalGainDeduction-NetFarmPropertyDispositionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 288, 5)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('CapitalGainDeduction-NetSmallBusinessShareDispositionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 289, 5)));

  FAutoFillMap.AddOrSetValue(Lowercase('RRSPContributionReceiptSlip-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 103, 3)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('RRSPContributionReceiptSlip-IssuerName'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 104, 3)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('RRSPContributionReceiptSlip-SlipVersionDescription'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 105, 3)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('RRSPContributionReceiptSlip-RRSPNumber'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 133, 5)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('RRSPContributionReceiptSlip-RRSPContractNumber'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 134, 5)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('RRSPContributionReceiptSlip-RRSPSpouseContributionIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 135, 5)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('RRSPContributionReceiptSlip-PriorYearRRSPContributionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 136, 5)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('RRSPContributionReceiptSlip-CurrentYearRRSPContributionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 137, 5)));

  FAutoFillMap.AddOrSetValue
    (Lowercase('DisabilityEligibilities-DisabilityAmountEligibilityCode'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 8)));

  FAutoFillMap.AddOrSetValue(Lowercase('RefundSetoff-RefundSetoffProgramCode'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 70)));
  FAutoFillMap.AddOrSetValue
    (Lowercase('RefundSetoff-RefundSetoffProgramAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 10)));
  // 20170729 Igor<<<
  // <<<<<<<<<<<<<<<<<<<<<<
  FMapInit := True;
end;

function AutoFillToVtAddr(const ASection, ASubSection: String;
  out AVTAddr: TVTMapElement): boolean;
begin
  if not FMapInit then
    InitMap;
  Result := FAutoFillMap.TryGetValue
    (Lowercase(ASection + '-' + ASubSection), AVTAddr);
end;

initialization

FMapInit := False;
FAutoFillMap := TDictionary<String, TVTMapElement>.Create;

finalization

freeAndNil(FAutoFillMap);

end.
