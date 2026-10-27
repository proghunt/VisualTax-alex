unit T2_2027AutoFillFrm;

interface

// 20171205 Igor (Sin to BN)

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, vtLabel, Buttons, ExtCtrls,
  ShellAPI,
  T2_2027declare, T2_2027trimstr, T2_2027ChildWinNew, T2_2027Common2, Grids,
  CheckLst, ComCtrls,
  DB, DBTables,
  vtEditBox,
  T2_2027Calc, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart,
  uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager,
  uADCompClient, uADCompDataSet, Generics.Collections, Variants, DateUtils, //20231211 Igor
  //uADCompClient, uADCompDataSet, Generics.Collections, Variants,
  // 20180518 Igor
  vtMulti, vtDynData; // 20180529 Igor

const
  WM_FILERECEIVED = WM_USER + 100;
  CHECKBOX_COL = 5; // 20180518 Igor

  // 20180518 Igor >>>
type
  TBox = record
    BoxId: string;
    ElmId: integer;
    BoxName: string;
    FieldType: string; // 20180525 Igor
    vtDataSource: Variant;
  end;

type
  TCorData = record
    BoxId: string;
    ElmId: integer;
    BoxName: string;
    // 20180525 Igor >>>
    FieldType: string;
    CurrValue: string;
    // 20180525 Igor <<<
    Value: string;
    vtDataSource: Variant;
    vtSourceType: string;
    // 20180529 Igor >>>
    ArrayNo: integer;
    // 20180529 Igor <<<
  end;

type
  TScheduleSelection = record
    Name: string;
    Checked: boolean;
  end;
  // 20180518 Igor <<<

// 20180525 Igor >>>
type
  TGroupBoxData = record
    BoxId: string;
    ElmIDs: array of integer;
  end;
// 20180525 Igor >>>

// 20180529 Igor >>>
type
  TLinkFormBox = record
    BoxId: string;
    LinkFormName: string;
    ElmId: integer;
  end;
// 20180529 Igor <<<

type
  TAutoFillFrmT2_2027 = class(TForm)
    OpenDialog: TOpenDialog;
    Label7: TLabel;
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
    NameLbl: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RecreateAutofillElmTypesBtn: TBitBtn;
    AFRHELPBTN: TBitBtn; // 20180612 Igor

    procedure ExitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure LoadBNDataBtnClick(Sender: TObject);
    procedure TabControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure LoadBNData(BN: String);
    procedure AutoFillAcceptGroupClick(Sender: TObject);
    procedure DataGroupsClick(Sender: TObject);
    procedure AutoFillBtnClick(Sender: TObject);
    procedure Exit2BtnClick(Sender: TObject);
    Function RenameIncomingData(S: String): String;
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState);
    Function GetVtValue(RNo: integer; FName: String; Elm: integer;
      DataName: String; SubSection: String): String;
    procedure HelpBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    // 20180518 Igor >>>
    procedure DataGroupsClickCheck(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    // 20180518 Igor <<<
    procedure RecreateAutofillElmTypesBtnClick(Sender: TObject);
    procedure AFRHELPBTNClick(Sender: TObject); // 20180612 Igor
  private
    { Private declarations }

    FWaitingFile: boolean;
    // 20180518 Igor >>>
    FRSI: TDictionary<String, TList<TBox>>;
    FAutoFillForms: TStringList;
    FCorData: TDictionary<String, TList<TCorData>>;
    FScheduleSelection: array of TScheduleSelection;
    // 20180518 Igor <<<
    FormGroupBoxData: TDictionary<String, TList<TGroupBoxData>>; // 20180525 Igor
    // 20180529 Igor >>>
    LinkFormBoxData: TDictionary<String, TList<TLinkFormBox>>;
    LoopFormBoxes: TStringList;
    // 20180529 Igor <<<
    FReceivedTaxYearEnd: TDateTime; //20231211 Igor
    Procedure GetBNSReceived(ReceivedFile: String;
      Var TddBNReceived: TStringList);
    Procedure ExtractBNData(ReceivedFile: String; BN: String;
      Var ExtractedBNData: TStringList);
    Procedure ExtractBNSubCodeData(SubSectionCode: String;
      ExtractedBNData: TStringList; Var ExtractedBNSubCodeData: TStringList);
    Procedure ExtractALLBNSubCodeData(SubSectionCode: String;
      ExtractedBNData: TStringList; Var ExtractedData: TStringList);
    procedure ExtractAndShowGroupData(GroupIndex: integer);
    procedure UpdateTaxReturn(BN: String; RNo: integer);
    Procedure UpdateATaxReturnField(RNo: integer; DataGroup, DataName, Instance,
      CraValue: String);
    Function AllGroups(DataGroup: String): boolean;
    procedure OpenTheTddElmsTable;
    Function AnyDataGroupsAccepted: boolean;
    Procedure FixInstance(Var DataList: TStringList; SlipName: String);
    Function CountTDDSlips(DataList: TStringList): integer;
    // Procedure ShowTddStatus;

    Function IsDataGroupInList(Astring: String; SomeList: TStringList): integer;
    Function CountDataGroupsAccepted: integer;
    Procedure PopulateStringGridHeaders;
    Procedure PopulateStringGridData(SubSection: String; DataList: TStringList;
      Var R: integer); // r=Row of grid
    procedure AutoSizeCol(Grid: TStringGrid; Column: integer);
    Procedure ClearStringGrid;
    procedure SetColumnFullWidth(Grid: TStringGrid; ACol: integer);
    // 20180518 Igor >>>
    procedure InitRSI;
    function GetScheduleSelection(AScheduleName: string): boolean;
    function GetScheduleSelectionIndex(AScheduleName: string): integer;
    procedure UpdateScheduleSelection(AChecked: boolean);
    // 20180518 Igor <<<
    // 20180525 Igor >>>
    procedure InitFormGroupBoxData;
    function GetValueFromForm(ARetNo: integer; FName: string; AElmId: integer;
      ABoxId: string; AFieldType: string): string;
    procedure SetValueFromForm(ARetNo: integer; FName: string; AElmId: integer;
      ABoxId, AFieldType, AValue: string; vtDataSource: Variant); // 20180529 Igor
    function ExceptionalBoxes(DataGroup, FormName, BoxNumber: string; ElmId: integer;
      CraValue: string): boolean;
    function ExceptionalBoxes_GetValue(DataGroup, FormName, BoxNumber: string; ElmId: integer;
      var Value: string): boolean;
    // 20180525 Igor <<<

  public
    { Public declarations }
    FileName: string;
    DivDeductible:Real;  //used for S7 property calculation
  end;

function AutoFillToVtAddr(const ASection, ASubSection: String;
  out AVTAddr: TVTMapElement): boolean;

// 20180529 Igor >>>
function GetRSI100(ARetNo: integer): string;
function GetRSI125(ARetNo: integer): string;
function GetRSILoop(AList: TStringList; ALoopFormBoxes: TStringList = nil): string;
// 20180529 Igor <<<

var
  cTDDReceivedTxtFileName: String;
  cTDDReceivedXmlFileName: String;

  AutoFillFrm: TAutoFillFrmT2_2027;
  TddPlainRetList: TStringList;
  TestOrProduction: String;
  AcceptedReturns: TStringList;
  RNo: integer;
  TddElmsConnection: TADConnection;
  TddElmsTable: TADTable;

  IncomingSlipCnt: integer;
  ReceivedFile: String;
  ReceivedCorFile: string; // 20180518 Igor
  BN: String;
  ReceivedData: TStringList;
  ExtractedBNData: TStringList;
  ExtractedBNDataGroups: TStringList;
  ExtractedBNSubCodeData: TStringList;

implementation

uses T2_2027main, vtTrimStr, vtCommon, vtShared, T2_2027, vtMain,
  vtDataBase, System.Generics.Collections, System.Generics.Defaults,
  T2_2027BarDataGen; // 20180518 Igor

var
  hThread: THandle;

  FMapInit: boolean = False;
  FAutoFillMap: TDictionary<String, TVTMapElement>;

{$R *.DFM}

const
  c_IncreaseFont = 1;
  c_TextMargin = 2;

function GetRSILoop(AList: TStringList; ALoopFormBoxes: TStringList = nil): string; // 20180529 Igor
var L: TStringList;
    nElmStart, nElmEnd, nElmInc, I, BoxNum: integer;
    cStr, cForm, cBox, cFieldType: string;
begin
  L := TStringList.Create;
  try
    for I := 0 to AList.Count - 1 do
    begin
      cStr := AList.Strings[I];
      cBox := Trim(Copy(cStr, 2, 11));
      cForm := Trim(Copy(cStr, 13, 9));
      nElmStart := StrToIntDef(Trim(Copy(cStr, 22, 6)), -1);
      nElmEnd := StrToIntDef(Trim(Copy(cStr, 28, 6)), -1);
      nElmInc := StrToIntDef(Trim(Copy(cStr, 34, 3)), -1);
      cFieldType := Trim(Copy(cStr, 62, 5));
      if (nElmStart = -1) or (nElmEnd = -1) or (nElmInc = -1) then continue;
      if Assigned(ALoopFormBoxes) then
        if ALoopFormBoxes.IndexOf(cForm + '_' + cBox) = -1 then
          ALoopFormBoxes.Add(cForm + '_' + cBox);
      BoxNum := 1;
      while nElmStart <= nElmEnd do
      begin
        L.Add(Space(1) + PaddR(cBox + '.' + IntToStr(BoxNum), 12) + PaddR(cForm, 8) +
              PaddR(AllTrim(IntToStr(nElmStart)), 41) + cFieldType);
        nElmStart := nElmStart + nElmInc;
        inc(BoxNum);
      end;
    end;
    Result := L.Text;
    //L.SaveToFile(AppDir + '\' + 'RSILoop.d');
  finally
    L.Free;
  end;
end;

function GetRSI100(ARetNo: integer): string; // 20180529 Igor
Var
  ArrayNo, BoxesPerRow, MaxRowsPerArray, ArrayElm: Integer;
  FormElm: Integer;
  i, j, FNo: Integer;
  FName, Ln, Value: String;
  TempSpecs: TStringList;

  Function IsBsLineMandatory(Ln: String): Boolean;
  begin
    result := False;
    If (Ln = '1000') or (Ln = '2600') or (Ln = '3500') or (Ln = '3660') then
      result := True;
  end;

begin
  // 20160402 Replaced fully due to change of Gifi100 from old GIfi form to new dynamic form
  TempSpecs := TStringList.Create;
  try
    FName := 'S100';
    FNo := GetFormNo(FName);
    For ArrayNo:=1 to 8 do
    Begin
     BoxesPerRow := 4;
     MaxRowsPerArray := DynamicRowCount(ARetNo, FNo, ArrayNo); //80; //20160430 Igor//MaxRowsPerArray := 80;
     ArrayElm := ArrayNo * 10000 + StrToInt('1');
     For i := 0 to MaxRowsPerArray do
     begin
       Ln := AllTrim(FetchElmFNo(ARetNo, FNo, ArrayElm + 1));
       FormElm := ArrayElm+2;
       Value:=FetchElmFNo(ARetNo, FNo, ArrayElm + 2); //
       if ((Value > '') and (Ln > '')) or (IsBsLineMandatory(Ln)) then
          TempSpecs.Add(MkRsiAmountRec(ARetNo, Ln, FName, FNo,FormElm));
       ArrayElm := ArrayElm + BoxesPerRow;
     end;  //i
    End;  //arrayno

    //add in between the fixed elements of each array
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,10), FName, FNo,11));    //curr assets
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,13), FName, FNo,14)); //tang assets
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,16), FName, FNo,17)); //Accum amoort tang assets
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,19), FName, FNo,20)); //intang assets
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,25), FName, FNo,26)); //Accum amort int
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,22), FName, FNo,23)); //long term
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,46), FName, FNo,47)); //i trust
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,88), FName, FNo,89)); //Tot assets
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,31), FName, FNo,32)); //Tot curr liab
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,4), FName, FNo,5)); //long term liab
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,56), FName, FNo,57)); //in trust
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,7), FName, FNo,8)); //tot Liab
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,28), FName, FNo,29)); //comm sh
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,34), FName, FNo,35)); //Ret earn
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,37), FName, FNo,38)); //Tot equ
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,40), FName, FNo,41)); //Tot equ
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,43), FName, FNo,44)); //3660
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,50), FName, FNo,51)); //Tot equ
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,53), FName, FNo,54)); //Tot ret earnings

    Result := TempSpecs.Text;
  finally
    TempSpecs.Free;
  end;
End;

function GetRSI125(ARetNo: integer): string; // 20180529 Igor
Var
  ArrayNo, BoxesPerRow, MaxRowsPerArray, ArrayElm: Integer;
  FormElm: Integer;
  i, j, FNo: Integer;
  FName, Ln, Value: String;
  TempSpecs: TStringList;

  Function IsIsLineMandatory(Ln: String): Boolean;
  begin
    result := False;
    If (Ln = '8000') or (Ln = '8300') or (Ln = '8519') or (Ln = '9369')

      or (Ln = '9370') or (Ln = '9660') or (Ln = '9899') or (Ln = '9970') or
      (Ln = '9975') or (Ln = '9976')

      or (Ln = '9980') or (Ln = '9985') or (Ln = '9990') or (Ln = '9995') then
      result := True;
  end;
begin
  // 20160402 Replaced fully due to change of Gifi125 from old GIfi form to new dynamic form
  TempSpecs := TStringList.Create;
  try
    FName := 'S125#1';
    FNo := GetFormNo(FName);
    For ArrayNo:=1 to 6 do
    Begin  //description
     BoxesPerRow := 4;
     MaxRowsPerArray := DynamicRowCount(ARetNo, FNo, ArrayNo); //80; //20160430 IgorMaxRowsPerArray := 80;
     ArrayElm := ArrayNo * 10000 + StrToInt('1');
     For i := 0 to MaxRowsPerArray do
     begin
       Ln := AllTrim(FetchElmFNo(ARetNo, FNo, ArrayElm + 1));
       FormElm := ArrayElm+2;
       Value:=FetchElmFNo(ARetNo, FNo, ArrayElm + 2); //
       if ((Value > '') and (Ln > '')) or (IsIsLineMandatory(Ln)) then
          TempSpecs.Add(MkRsiAmountRec(ARetNo, Ln, FName, FNo,FormElm));
       ArrayElm := ArrayElm + BoxesPerRow;
     end;
    end;  //arrayno

    //add in between the fixed elements of each array
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,10), FName, FNo,11));    //revenue//4TempSpecs.Add(MkRsiAmountRec(RetNo,'8089',FName,FNo));   //20160512
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,13), FName, FNo,14)); //Sales of goods
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,16), FName, FNo,17)); //cost of sales
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,19), FName, FNo,20)); //gross profit
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,25), FName, FNo,26)); //Tot opr expenses
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,22), FName, FNo,23)); //Tot expenses
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,88), FName, FNo,89)); //Net non-farm income
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,28), FName, FNo,29)); //Tot farm revenue
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,31), FName, FNo,32)); //Tot farm exp
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,34), FName, FNo,35)); //Tot liab

    // other fixed comprehensive and Summary fields
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,37), FName, FNo,38)); //Net inc/loss bfr expta items
    i:=40; J:=41;
    Repeat
     TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,i), FName, FNo,j));
     Inc(i,3);
     Inc(j,3);
    until i>82;
    TempSpecs.Add(MkRsiAmountRec(ARetNo, FetchElmFNo(ARetNo,FNo,7), FName, FNo,8)); //Net inc/loss after extra items

    Result := TempSpecs.Text;
  finally
    TempSpecs.Free;
  end;
end;

function ClearAllExceptDigits(AValue: string): string; // 20180525 Igor
var I: integer;
begin
  Result := '';
  for I := 1 to Length(AValue) do
    if CharInSet(AValue[I], ['0'..'9']) then
      Result := Result + AValue[I];
end;

procedure WorkThread(Form: TAutoFillFrmT2_2027); stdcall;
begin
  repeat
    sleep(1000);
  until FileExists(Form.FileName);
  PostMessage(Form.Handle, WM_FILERECEIVED, 0, 0);
end;

procedure TAutoFillFrmT2_2027.ExitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TAutoFillFrmT2_2027.FormCreate(Sender: TObject);
Var
  i: integer;

procedure ExtractTaxYearEnd; //20231211 Igor
  var I: integer;
      L: TStringList;
      Arr: TArray<string>;
  begin
    L := TStringList.Create;
    try
      L.LoadFromFile(ReceivedFile);
      for I := 0 to L.Count - 1 do
      begin
        Arr := L.Strings[I].Split(['¦'], ExcludeEmpty);
        if (Length(Arr) = 5)
           and
           SameText(Arr[0], 'GetCorporationDataResponse')
           and
           SameText(Arr[1], 'T2ReturnData')
           and
           SameText(Arr[2], 'TaxYearEndYearMonthDay') then
        begin
          FReceivedTaxYearEnd := EncodeDate(
            StrToIntDef(Copy(Arr[4], 1, 4), 0),
            StrToIntDef(Copy(Arr[4], 6, 2), 0),
            StrToIntDef(Copy(Arr[4], 9, 2), 0));
          break;
        end;
      end;
    finally
      L.Free;
    end;
  end;
begin
  OpenTheTddElmsTable;
  if not assigned(TddElmsTable) then
  begin
    MessageDlg(TddElmsDBLite + ' is missing', mtError, [mbOk], 0);
    Close;
    exit;
  end;

  RNo := GetCurrentRetNo; // 20171123 Igor
  //20231211 Igor >>>
  // NameLbl.Caption :=GetCorpName(RNo)+' - '+GetBN(RNo);
  //GetLastName(RNo) + ', ' + GetFirstName(RNo);
  //20231211 Igor <<<
  BN := GetBN(RNo);
  ReceivedFile := MkTddFileName(RNo);
  // 20180518 Igor >>>
  ReceivedCorFile := MkTddCorFileName(RNo);
  InitRSI;
  // 20180518 Igor <<<
  InitFormGroupBoxData; // 20180525 Igor
  ExtractBNData(ReceivedFile, BN, ExtractedBNData);

  ExtractTaxYearEnd; //20231211 Igor

  ClearStringGrid;
  DataGroups.Items.clear;
  For i := 0 to ExtractedBNDataGroups.count - 1 do
  Begin
    DataGroups.Items.add(ExtractedBNDataGroups[i]);
    // populate the subsection list1
    If AutoFillAcceptGroup.itemIndex = 0 then
      DataGroups.Checked[i] := True;
  end;

  AutoFillAcceptGroup.itemIndex := 0;
  Screen.Cursor := crDefault; //20180610
end;

procedure TAutoFillFrmT2_2027.FormDestroy(Sender: TObject);
var
  Key: string; // 20180518 Igor
begin
  // 20180529 Igor >>>
  if Assigned(LinkFormBoxData) then
    LinkFormBoxData.Free;
  if Assigned(LoopFormBoxes) then
    LoopFormBoxes.Free;
  // 20180529 Igor <<<
  // 20180525 Igor >>>
  if Assigned(FormGroupBoxData) then
    FormGroupBoxData.Free;
  // 20180525 Igor <<<
  // 20180518 Igor >>>
  for Key in FRSI.Keys do
    TList<TBox>(FRSI.Items[Key]).Free;
  if assigned(FRSI) then
    FreeAndNil(FRSI);

  for Key in FCorData.Keys do
    TList<TCorData>(FCorData.Items[Key]).Free;
  if assigned(FCorData) then
    FreeAndNil(FCorData);

  if assigned(FAutoFillForms) then
    FreeAndNil(FAutoFillForms);
  // 20180518 Igor <<<
  if assigned(TddElmsTable) then
    FreeAndNil(TddElmsTable);
  if assigned(TddElmsConnection) then
    FreeAndNil(TddElmsConnection);
end;

procedure TAutoFillFrmT2_2027.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not(fsModal in Self.FormState) then
    Action := TCloseAction.caFree;
end;

procedure TAutoFillFrmT2_2027.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if FWaitingFile then
  begin
    if MessageDlg
      ('Application is waiting for file from CRA. Are you sure that you want to close form?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
      FWaitingFile := False
    else
      CanClose := False
  end;
end;

Procedure TAutoFillFrmT2_2027.ExtractBNData(ReceivedFile: String; BN: String;
  Var ExtractedBNData: TStringList);
Var
  i, j, k: integer;
  S, Section, SubSection, DataElmName, Instance, Value: String;
  // 20180518 Igor >>>
  FCorReceivedData: TStringList;
  cStr, FormName, BoxId, Key: string;
  FBoxList: TList<TBox>;
  FCorDataList: TList<TCorData>;
  R: TCorData;
  // 20180518 Igor <<<
  // 20180529 Igor >>>
  ArrayNo: integer;
  bProcessed: boolean;
  FGroupBoxDataList: TList<TGroupBoxData>;
  // 20180529 Igor <<<
  FAutoFillResFile: TStringList; // 20180530 Igor
  A: TArray<String>; //20201126 Igor

  procedure AddAutoFillResFile(AGroupName, ASubGroupName, AElementName, AInst, AValue: string); // 20180530 Igor
  begin
    if SameText(AElementName, 'EOD') then Exit;
    //20201126 Igor >>>
    FAutoFillResFile.Add(
      AGroupName + AFRStringDelimiter +
      ASubGroupName + AFRStringDelimiter +
      AElementName + AFRStringDelimiter +
      AInst + AFRStringDelimiter +
      AValue);
    //20201126 Igor <<<
  end;

Begin
  ReceivedData := TStringList.Create;
  ExtractedBNData := TStringList.Create;
  ExtractedBNDataGroups := TStringList.Create;
  ReceivedData.LoadFromFile(ReceivedFile);
  i := -1;
  Repeat
    Inc(i, 1);
    If i > ReceivedData.count - 1 then
      break; // 20180518 Igor
    S := RenameIncomingData(ReceivedData[i]);
    //20201126 Igor >>>
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 5 then continue;
    Section := A[0];
    SubSection := A[1];
    DataElmName := AllTrim(A[2]);
    Instance := A[3];
    Value := A[4];
    {Section := LeftStr(S, 45);
    SubSection := MidStr(S, 46, 35);
    DataElmName := AllTrim(MidStr(S, 81, 60));
    Instance := MidStr(S, 141, 2);
    Value := MidStr(S, 144, 100);}
    //20201126 Igor <<<
    ExtractedBNData.add(S);

    If IsDataGroupInList(SubSection, ExtractedBNDataGroups) = -1 then
    // not found in list
    begin
      ExtractedBNDataGroups.add(AllTrim(SubSection));
    end;
  Until (i > ReceivedData.count - 1);
  // 20180518 Igor >>>
  for Key in FCorData.Keys do
    TList<TCorData>(FCorData.Items[Key]).Free;
  FCorData.clear;
  FCorReceivedData := TStringList.Create;
  FAutoFillResFile := TStringList.Create; // 20180530 Igor
  try
    FCorReceivedData.LoadFromFile(ReceivedCorFile);
    for i := 0 to FCorReceivedData.count - 1 do
    begin
      cStr := ReplaceStr(FCorReceivedData.Strings[i], #29, '');
      if FAutoFillForms.IndexOfName(cStr) <> -1 then
      begin
        FormName := FAutoFillForms.Values[cStr];
        // 20180529 Igor >>>
        if GetScheduleSelectionIndex(FormName) = -1 then
        begin
          SetLength(FScheduleSelection, Length(FScheduleSelection) + 1);
          FScheduleSelection[Length(FScheduleSelection) - 1].Name := FormName;
          FScheduleSelection[Length(FScheduleSelection) - 1].Checked := False;
        end;
        if FRSI.ContainsKey(FormName) then
          FBoxList := FRSI.Items[FormName]
        else
          FBoxList := nil;
        if FormGroupBoxData.ContainsKey(FormName) then
          FGroupBoxDataList := FormGroupBoxData.Items[FormName]
        else
          FGroupBoxDataList := nil;
        continue;
      end;      
      bProcessed := false;
      if SameText(FormName, 'S100') or SameText(FormName, 'S125#1') then
      begin
        BoxId := Copy(cStr, 1, 4);
        Value := Copy(cStr, 5, Length(cStr));
      end
      else
      begin
        BoxId := Copy(cStr, 1, 3);
        if LoopFormBoxes.IndexOf(FormName + '_' + BoxId) <> -1 then
        begin
          cStr := FCorReceivedData.Strings[i];
          Value := Copy(cStr, 4, Pos(#29, cStr) - 4);
          BoxId := BoxId + '.' + Copy(cStr, Pos(#29, cStr) + 1, Length(cStr));
        end
        else
          Value := Copy(cStr, 4, Length(cStr));
      end;
      AddAutoFillResFile('T2ReturnData', FormName, BoxId, '', Value); // 20180530 Igor
      if assigned(FBoxList) then
        for j := 0 to FBoxList.count - 1 do
          if SameText(FBoxList.Items[j].BoxId, BoxId) then
          begin
            if not FCorData.ContainsKey(FormName) then
              FCorData.add(FormName, TList<TCorData>.Create);
            FCorDataList := FCorData.Items[FormName];
            R.BoxId := BoxId;
            R.ElmId := FBoxList.Items[j].ElmId;
            R.BoxName := FBoxList.Items[j].BoxName;
            // 20180525 Igor >>>
            R.FieldType := FBoxList.Items[j].FieldType;
            R.CurrValue := GetValueFromForm(RNo, FormName, R.ElmId, R.BoxId, R.FieldType);
            // 20180525 Igor <<<
            R.Value := Value;
            R.vtDataSource := FBoxList.Items[j].vtDataSource;
            if SameText(FormName, 'S100') then
              ArrayNo := StrToIntDef(GetBSArrayNoFromGifiLine(BoxId), 0)
            else if SameText(FormName, 'S125#1') then
              ArrayNo := StrToIntDef(GetISArrayNoFromGifiLine(BoxId), 0)
            else
              ArrayNo := 0;
            if (ArrayNo <> 0) then
              R.vtDataSource := vtUser;

            if (R.vtDataSource = vtUser) then
              R.vtSourceType := 'User'
            else if R.vtDataSource = vtLinked then
              R.vtSourceType := 'Linked'
            else if R.vtDataSource = vtCalc then
              R.vtSourceType := 'Calc'
            else if R.vtDataSource = vtPopuplist then
              R.vtSourceType := 'Popuplist'
            else if R.vtDataSource = vtAddingTape then
              R.vtSourceType := 'AddingTape'
            else if R.vtDataSource = vtOverride then
              R.vtSourceType := 'Override'
            else
              R.vtSourceType := 'NOT FOUND';
            FCorDataList.add(R);
            bProcessed := true;
            break;
          end;
      if not bProcessed then
        if Assigned(FGroupBoxDataList) then
          for j := 0 to FGroupBoxDataList.Count - 1 do
            if SameText(FGroupBoxDataList.Items[j].BoxId, BoxId) then
            begin
              if not FCorData.ContainsKey(FormName) then
                FCorData.add(FormName, TList<TCorData>.Create);
              FCorDataList := FCorData.Items[FormName];

              R.BoxId := BoxId;
              R.ElmId := FGroupBoxDataList.Items[j].ElmIds[0];
              R.FieldType := '';
              R.CurrValue := GetValueFromForm(RNo, FormName, R.ElmId, R.BoxId, R.FieldType);
              R.Value := Value;
              R.vtDataSource := vtUser;
              R.vtSourceType := 'User';
              FCorDataList.add(R);
              bProcessed := true;
              break;
            end;
      if not bProcessed then
      begin
        if SameText(FormName, 'S100') or SameText(FormName, 'S125#1') then
        begin
          if SameText(FormName, 'S100') then
            ArrayNo := StrToIntDef(GetBSArrayNoFromGifiLine(BoxId), 0)
          else if SameText(FormName, 'S125#1') then
            ArrayNo := StrToIntDef(GetISArrayNoFromGifiLine(BoxId), 0)
          else
            ArrayNo := 0;
          if ArrayNo <> 0 then
          begin
            if not FCorData.ContainsKey(FormName) then
              FCorData.add(FormName, TList<TCorData>.Create);
            FCorDataList := FCorData.Items[FormName];
            R.BoxId := BoxId;
            R.ElmId := 0;
            R.BoxName := '';
            R.FieldType := '';
            R.CurrValue := '';
            R.CurrValue := '';
            R.Value := Value;

            R.vtDataSource := vtUser;
            R.vtSourceType := 'User';
            R.ArrayNo := ArrayNo;
            FCorDataList.add(R);
          end;
        end;
      end;
      // 20180529 Igor <<<
    end;
    FAutoFillResFile.SaveToFile(MkTddFileNameAutofill(RNo));  // 20180530 Igor
  finally
    FAutoFillResFile.Free; // 20180530 Igor
    FCorReceivedData.Free;
  end;
  // 20180518 Igor <<<
end;

procedure TAutoFillFrmT2_2027.InitFormGroupBoxData; // 20180525 Igor
var I, J, nElmId: integer;
    A: TArray<string>;
    AutoFillForms: TStringList;
    FList: TList<TGroupBoxData>;
    cStr, cForm, cElms: string;
    R: TGroupBoxData;
    bError: boolean;
    // 20180528 Igor >>>
    nSection: integer;
    L: TLinkFormBox;
    FLinkList: TList<TLinkFormBox>;
    // 20180528 Igor <<<
begin
  FormGroupBoxData := TDictionary<String, TList<TGroupBoxData>>.Create;
  LinkFormBoxData := TDictionary<String, TList<TLinkFormBox>>.Create; // 20180528 Igor
  AutoFillForms := TStringList.Create;
  try
    AutoFillForms.LoadFromFile(AppDir + '\' + 'AutoFillFormGroupBoxes.d');
    nSection := 0; // 20180528 Igor
    for I := 0 to AutoFillForms.Count - 1 do
    begin
      cStr := Trim(ReplaceStr(AutoFillForms.Strings[I], #9, ' '));
      if SameText(Copy(cStr, 1, 2), '//') then continue;
      // 20180528 Igor >>>
      if SameText(Copy(cStr, 1, 14), '%NEXT_SECTION%') then
      begin
        inc(nSection);
        continue;
      end;
      if nSection = 0 then
      begin
        A := cStr.Split([' '], ExcludeEmpty);
        if Length(A) < 3 then continue;
        cForm := A[0];
        R.BoxId := A[1];
        cElms := A[2];
        // splitting elms ids and converting them to array
        A := cElms.Split([','], ExcludeEmpty);
        SetLength(R.ElmIDs, Length(A));
        bError := false;
        for J := 0 to Length(A) - 1 do
        begin
          if not TryStrToInt(A[J], nElmId) then
          begin
            bError := true;
            break;
          end;
          R.ElmIDs[J] := nElmId;
        end;
        if bError then continue;
        // adding data to dictionary
        if not FormGroupBoxData.ContainsKey(cForm) then
          FormGroupBoxData.Add(cForm, TList<TGroupBoxData>.Create);
        FList := FormGroupBoxData.Items[cForm];
        FList.Add(R);
      end
      else if nSection = 1 then
      begin
        A := cStr.Split([' '], ExcludeEmpty);
        if Length(A) < 4 then continue;
        cForm := A[0];
        L.BoxId := A[1];
        L.LinkFormName := A[2];
        if not TryStrToInt(A[3], nElmId) then continue;
        L.ElmId := nElmId;
        // adding data to dictionary
        if not LinkFormBoxData.ContainsKey(cForm) then
          LinkFormBoxData.Add(cForm, TList<TLinkFormBox>.Create);
        FLinkList := LinkFormBoxData.Items[cForm];
        FLinkList.Add(L);
      end;
      // 20180528 Igor <<<
    end;
  finally
    AutoFillForms.Free;
  end;
end;

procedure TAutoFillFrmT2_2027.InitRSI; // 20180518 Igor
var
  L: TStringList;
  i, nElm, FieldId, j: integer;
  S, cBox, cForm, cElm, cName, cFieldType: string; // 20180525 Igor
  FList: TList<TBox>;
  B: TBox;
  F: TForm;
  FullForm: TFormT2_2027;
  LoopList: TStringList; // 20180529 Igor
  // 20180612 Igor >>>
  AutofillElmTypes: TDictionary<String, TDataSource>;
  // 20180612 Igor <<<

  function CheckFormName(AForm: string): boolean;
  var
    i: integer;
    cStr: string;
  begin
    Result := False;
    for i := 0 to FAutoFillForms.count - 1 do
    begin
      cStr := FAutoFillForms.Strings[i];
      if SameText(Copy(cStr, Pos('=', cStr) + 1, Length(cStr)), AForm) then
      begin
        Result := True;
        break;
      end;
    end;
  end;

  procedure InitAutofillElmTypes; // 20180612 Igor
  var List: TStringList;
      I, nTemp: integer;
      cStr, cValue: string;
      nValue: Variant;
  begin
    List := TStringList.Create;
    if FileExists(AppDir + '\' + 'AutoFillElmTypes.d') then
      List.LoadFromFile(AppDir + '\' + 'AutoFillElmTypes.d');
    for I := 0 to List.Count - 1 do
    begin
      if SameText(Copy(List.Strings[I], 1, 2), '//') then continue;
      cStr := Copy(List.Strings[I], 1, Pos('=', List.Strings[I]) - 1);
      cValue := Copy(List.Strings[I], Pos('=', List.Strings[I]) + 1, Length(List.Strings[I]));
      nTemp := StrToIntDef(cValue, -1);
      if nTemp <> -1 then
        nValue := TDataSource(nTemp)
      else
        nValue := NULL;
      AutofillElmTypes.AddOrSetValue(cStr, nValue);
    end;
  end;

  function GetValueType(AForm: string; AElm: integer): Variant; // 20180612 Igor
  var cStr: string;
      nType: integer;
  begin
    Result := NULL;
    cStr := AForm + ':' + IntToStr(AElm);
    if AutofillElmTypes.ContainsKey(cStr) then
      Result := AutofillElmTypes.Items[cStr];
  end;

begin
  FAutoFillForms := TStringList.Create;
  FAutoFillForms.LoadFromFile(AppDir + '\' + 'AutoFillForms.d');

  FRSI := TDictionary < String, TList < TBox >>.Create;
  FCorData := TDictionary < String, TList < TCorData >>.Create;

  L := TStringList.Create;
  // 20180529 Igor >>>
  LoopList := TStringList.Create;
  LoopFormBoxes := TStringList.Create;
  // 20180612 Igor >>>
  AutofillElmTypes := TDictionary<String, TDataSource>.Create;
  InitAutofillElmTypes;
  // 20180612 Igor <<<
  try
    for j := 1 to 4 do
    begin
      if j = 1 then
        L.LoadFromFile(AppDir + '\' + 'RSI.D')
      else if j = 2 then
        L.Text := GetRSI100(RNo)
      else if j = 3 then
        L.Text := GetRSI125(RNo)
      else
        L.Text := GetRSILoop(LoopList, LoopFormBoxes);
      for i := 0 to L.count - 1 do
      begin
        S := L.Strings[i];
        if SameText(Copy(S, 1, 1), '*') then
        begin
          LoopList.Add(S);
          continue;
        end;
        cBox := Trim(Copy(S, 1, 10));
        if SameText(Copy(cBox, 1, 1), 'F') then
          cBox := Copy(cBox, 2, Length(cBox));
        cForm := Trim(Copy(S, 13, 8));
        cElm := Trim(Copy(S, 22, 5));
        cName := Trim(Copy(S, 27, 35));
        cFieldType := Trim(Copy(S, 61, 5)); // 20180525 Igor
        if TryStrToInt(cElm, nElm) and CheckFormName(cForm) then
        begin
          if not FRSI.ContainsKey(cForm) then
            FRSI.add(cForm, TList<TBox>.Create);
          FList := FRSI.Items[cForm];
          B.BoxId := cBox;
          B.ElmId := nElm;
          B.BoxName := ''; // cName; // box name here
          B.vtDataSource := GetValueType(cForm, nElm); //20180612 Igor
          B.FieldType := cFieldType; // 20180525 Igor
          FList.add(B);
        end;
      end;
    end;
    // 20180529 Igor <<<

    SetLength(FScheduleSelection, FRSI.Keys.count);
    i := 0;
    for cForm in FRSI.Keys do
    begin
      FScheduleSelection[i].Name := cForm;
      FScheduleSelection[i].Checked := False;
      Inc(i);
    end;
    // 20180612 Igor >>>
    {
    // init datasource in boxes
    F := TForm.Create(Application);
    try
      F.Visible := False;
      for cForm in FRSI.Keys do
      begin
        FList := FRSI.Items[cForm];
        FullForm := TFormT2_2027.Create(F, RNo, GetFormNo(cForm));
        ReadComponentResFile(GetDFMFileName(RNo, cForm), FullForm);
        try
          for i := 0 to FullForm.ControlCount - 1 do
            if FullForm.Controls[i] is TvtEdit then
            begin
              FieldId := GetFieldId(TvtEdit(FullForm.Controls[i]).Name);
              if FieldId <> 0 then
                for j := 0 to FList.count - 1 do
                  if FList.Items[j].ElmId = FieldId then
                  begin
                    B := FList.Items[j];
                    B.vtDataSource := TvtEdit(FullForm.Controls[i])
                      .vtDataSource;
                    FList.Items[j] := B;
                    break;
                  end;
            end;
        finally
          FullForm.Free;
        end;
      end;
    finally
      F.Free;
    end;
    }
    // 20180612 Igor <<<
  finally
    L.Free; LoopList.Free; // 20180529 Igor
    AutofillElmTypes.Free; // 20180612 Igor
  end;
end;

Function TAutoFillFrmT2_2027.IsDataGroupInList(Astring: String;
  SomeList: TStringList): integer;
var
  i, LengthOfKeyWord: integer;
begin
  Result := -1;
  if SomeList.count = 0 then
    exit;
  Astring := UpperCase(AllTrim(Astring));
  LengthOfKeyWord := Length(Astring);
  for i := 0 to SomeList.count - 1 do
    if Astring = AllTrim(UpperCase(AllTrim(SomeList[i]))) then
    // problem Reassessments and reassessmentsInProgress lokked the same before
    begin
      Result := i;
      exit;
    end;
end;

Procedure TAutoFillFrmT2_2027.ExtractBNSubCodeData(SubSectionCode: String; //20201126 Igor
  ExtractedBNData: TStringList; Var ExtractedBNSubCodeData: TStringList);
var
  i, j: integer;
  S, Section, SubSection, DataElmName, Instance, Value: string;
  A: TArray<string>; 
begin
  for i := 0 to ExtractedBNData.count - 1 do
  begin
    S := ExtractedBNData[i];
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 5 then continue;
    SubSection := AllTrim(A[1]);
    DataElmName := AllTrim(A[2]);
    Instance := AllTrim(A[3]);
    Value := AllTrim(A[4]);
    {SubSection := AllTrim(MidStr(S, 46, 35));
    DataElmName := AllTrim(MidStr(S, 81, 60));
    Instance := AllTrim(MidStr(S, 141, 2));
    Value := AllTrim(MidStr(S, 144, 100));}
    if SubSectionCode = SubSection then
      ExtractedBNSubCodeData.add(DataElmName + AFRStringDelimiter +
                                 Instance + AFRStringDelimiter +
                                 Value);
  end;
end;

Procedure TAutoFillFrmT2_2027.ExtractALLBNSubCodeData(SubSectionCode: String; //20201126 Igor
  ExtractedBNData: TStringList; Var ExtractedData: TStringList);
var
  i, j: integer;
  S, Section, SubSection, DataElmName, Instance, Value: string;
  PrevSubSection: string;
  A: TArray<string>;
begin
  PrevSubSection := '';
  for i := 0 to ExtractedBNData.count - 1 do
  begin
    S := ExtractedBNData[i];
    A := S.Split([AFRStringDelimiter]);
    if Length(A) < 5 then continue;
    SubSection := AllTrim(A[1]);
    DataElmName := AllTrim(A[2]);
    Instance := AllTrim(A[3]);
    Value := AllTrim(A[4]);
    {SubSection := AllTrim(MidStr(S, 46, 35));
    DataElmName := AllTrim(MidStr(S, 81, 60));
    Instance := AllTrim(MidStr(S, 141, 2));
    Value := AllTrim(MidStr(S, 144, 100));}
    if SubSection > PrevSubSection then
    begin
      if PrevSubSection > '' then
        ExtractedData.add('            ');
      ExtractedData.add(UpperCase(SubSection));
      PrevSubSection := SubSection;
    end;
    ExtractedData.add(DataElmName + AFRStringDelimiter +
                      Instance + AFRStringDelimiter +
                      Value)
  end;
end;

procedure TAutoFillFrmT2_2027.TabControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  FreeAndNil(ExtractedBNData);
  FreeAndNil(ExtractedBNDataGroups);
  FreeAndNil(ExtractedBNSubCodeData);

  BN := TabControl1.tabs[TabControl1.tabindex];
  RNo := GetRetNoFromBN(BN);
  LoadBNData(BN);
  ExtractAndShowGroupData(0); // first group = ALL
end;

procedure TAutoFillFrmT2_2027.AutoSizeCol(Grid: TStringGrid; Column: integer);
var
  i, W, WMax: integer;
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

Procedure TAutoFillFrmT2_2027.ClearStringGrid;
Var
  i: integer;
Begin
  for i := 0 to StringGrid1.ColCount - 1 do
    StringGrid1.Cols[i].clear;
  PopulateStringGridHeaders;
end;

// 20151229   This button was added to be able to test with existing tXT file without connecting to CRA
procedure TAutoFillFrmT2_2027.LoadBNDataBtnClick(Sender: TObject);
Var
  i: integer;
  ReceivedFile: String;
  SubSectionCode: String;
begin
  // LoadSindata(Sin)
end;

// 20151229  NEW routines
Procedure TAutoFillFrmT2_2027.GetBNSReceived(ReceivedFile: String;
  Var TddBNReceived: TStringList);
Var
  i: integer;
  S, Sin, FoundNotFound, DataElmName, Value: String;
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
    DataElmName := AllTrim(MidStr(S, 81, 60));
    if DataElmName = 'ReferencedIdentificationNumber' then
    begin
      Value := MidStr(S, 144, 9);
      BN := Value;

      Inc(i, 2);
      // read next to get the Found or any other such as NO-DATA response
      S := ReceivedData[i];
      DataElmName := AllTrim(MidStr(S, 81, 60));
      Value := MidStr(S, 144, 9);
      FoundNotFound := Value;
      if UpperCase(FoundNotFound) = 'FOUND' then
        TddBNReceived.add(BN + ' ' + PaddR(FoundNotFound, 10) + ' ' +
          'TDD Received. Not Auto-filled yet')
      else
      begin
        RNo := GetRetNoFromBN(BN);
        if RNo > 0 then
          ShowMessage('BN ' + BN + ' ' + GetFirstName(RNo) + ' ' +
            GetLastName(RNo) + Chr(13) +
            'maybe incorrect or not in CRA server. No data returned by CRA');
      end;
    end;
  until (i > ReceivedData.count - 1) or (i > 46);
end;

function TAutoFillFrmT2_2027.GetScheduleSelection(AScheduleName: string)
  : boolean; // 20180518 Igor
var
  i: integer;
begin
  Result := False;
  i := GetScheduleSelectionIndex(AScheduleName);
  if i >= 0 then
    Result := FScheduleSelection[i].Checked;
end;

function TAutoFillFrmT2_2027.GetScheduleSelectionIndex(AScheduleName: string)
  : integer; // 20180518 Igor
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Length(FScheduleSelection) - 1 do
    if SameText(FScheduleSelection[i].Name, AScheduleName) then
    begin
      Result := i;
      break;
    end;
end;

procedure TAutoFillFrmT2_2027.LoadBNData(BN: String);
var
  i: integer;
  ReceivedFile: string;
  SubSectionCode: string;
begin
  BN := LeftStr(TabControl1.tabs[TabControl1.tabindex], 9);
  RNo := GetRetNoFromBN(BN);
  ClearStringGrid;
  ExtractBNData(ReceivedFile, BN, ExtractedBNData);
  // start with first SIN/tab and also the groups of data (subsection)
  DataGroups.Items.clear;
  for i := 0 to ExtractedBNDataGroups.count - 1 do
  begin
    DataGroups.Items.add(ExtractedBNDataGroups[i]);
    // populate the subsection list1
    if AutoFillAcceptGroup.itemIndex = 0 then
      DataGroups.Checked[i] := True;
  end;
end;

procedure TAutoFillFrmT2_2027.AutoFillAcceptGroupClick(Sender: TObject);
Var
  i: integer;
begin
  // 20180518 Igor >>>
  case AutoFillAcceptGroup.itemIndex of
    0:
      begin
        for i := 0 to DataGroups.Items.count - 1 do
          DataGroups.Checked[i] := True;
        UpdateScheduleSelection(True);  //select all schedules // 20180529 Igor
      end;
    2:
      begin
        for i := 0 to DataGroups.Items.count - 1 do
          DataGroups.Checked[i] := False;
        UpdateScheduleSelection(False); //unselect all schedules // 20180529 Igor
      end;
  end;
  // 20180518 Igor <<<
  DataGroups.Refresh;
end;

procedure TAutoFillFrmT2_2027.DataGroupsClick(Sender: TObject);
var
  i: integer;
  SubSectionCode: string;
  DataList: TStringList;
begin
  // 20180612 Igor >>>
  if DataGroups.itemIndex <> -1 then
    ExtractAndShowGroupData(DataGroups.itemIndex);
  // 20180612 Igor <<<
  DataGroups.Refresh;
end;

procedure TAutoFillFrmT2_2027.DataGroupsClickCheck(Sender: TObject);
// 20180518 Igor
begin
  // select/unselect all schedules when click on checkbox
  // 20180529 Igor >>>
  if (DataGroups.ItemIndex <> -1) and SameText(DataGroups.Items[DataGroups.ItemIndex], 'T2ReturnData') then
    UpdateScheduleSelection(DataGroups.Checked[DataGroups.ItemIndex]);
  // 20180529 Igor <<<
end;

procedure TAutoFillFrmT2_2027.ExtractAndShowGroupData(GroupIndex: integer);
var
  i: integer;
  SubSectionCode: string;
  DataList: TStringList;
  C, R: integer; // grid colmn and Row
begin
  ExtractedBNSubCodeData := TStringList.Create;
  SubSectionCode := AllTrim(DataGroups.Items[GroupIndex]);
  GridGroup.Caption := SubSectionCode;
  if RNo > 0 then
    GridGroup.Caption := SubSectionCode;

  if not AllGroups(SubSectionCode) then
  begin
    ExtractBNSubCodeData(SubSectionCode, ExtractedBNData,
      ExtractedBNSubCodeData);
    if IsDataGroupASlip(SubSectionCode) then
      FixInstance(ExtractedBNSubCodeData, SubSectionCode);
    ClearStringGrid;
    R := 0;
    PopulateStringGridData(SubSectionCode, ExtractedBNSubCodeData, R);
  end;
end;

procedure TAutoFillFrmT2_2027.SetColumnFullWidth(Grid: TStringGrid;
  ACol: integer);
var
  i: integer;
  FixedWidth: integer;
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

procedure TAutoFillFrmT2_2027.SetValueFromForm(ARetNo: integer; FName: string;
  AElmId: integer; ABoxId, AFieldType, AValue: string; vtDataSource: Variant); // 20180525 Igor  // 20180528 Igor
var I, J: integer;
    FList: TList<TGroupBoxData>;
    R: TGroupBoxData;
    cValue: string;
    // 20180528 Igor >>>
    FLinkList: TList<TLinkFormBox>;
    L: TLinkFormBox;
    // 20180528 Igor <<<

    function GetDate: string;
    begin
      Result := Copy(AValue, 1, 4) + '/' + Copy(AValue, 5, 2 ) + '/' + Copy(AValue, 7, 2); // 20180528 Igor
    end;

    function Get1bValue: string;
    begin
      if SameText(AValue, '1') then
        Result := 'X'
      else
        Result := '';
    end;

begin
  // 20180528 Igor >>>
  if LinkFormBoxData.ContainsKey(FName) then
  begin
    FLinkList := LinkFormBoxData.Items[FName];
    for I := 0 to FLinkList.Count - 1 do
    begin
      L := FLinkList.Items[I];
      if SameText(L.BoxId, ABoxId) then
      begin
        StoreElm(RNo, L.LinkFormName, L.ElmID, AValue);
        Exit;
      end;
    end;
  end;
  // 20180528 Igor <<<
  if FormGroupBoxData.ContainsKey(FName) then
  begin
    FList := FormGroupBoxData.Items[FName];
    for I := 0 to FList.Count - 1 do
    begin
      R := FList.Items[I];
      if SameText(R.BoxId, ABoxId) then
      begin
        for J := 0 to Length(R.ElmIDs) - 1 do
        begin
          if SameText(AValue, IntToStr(J + 1)) then
            cValue := 'X'
          else
            cValue := '';
          StoreElm(RNo, FName, R.ElmIDs[J], cValue);
        end;
        Exit;
      end;
    end;
  end;
  // 20180528 Igor >>>
  if (vtDataSource = vtUser) or (vtDataSource = vtPopuplist) then
  begin
    if SameText(AFieldType, 'D') or SameText(AFieldType, 'D/T') then
      AValue := GetDate
    else if SameText(AFieldType, '1/b') then
      AValue := Get1bValue;
    StoreElm(RNo, FName, AElmId, AValue);
  end;
  // 20180528 Igor <<<
end;

procedure TAutoFillFrmT2_2027.OpenTheTddElmsTable;
begin
  TddElmsConnection := TADConnection.Create(nil);
  TddElmsTable := TADTable.Create(nil);
  if not SetTableName(TddElmsConnection, TddElmsTable,
    IncludeTrailingPathDelimiter(AppDir) + TddElmsDBLite, TddElmsTableLite,
    'FIELDKEY') then
  begin
    FreeAndNil(TddElmsConnection);
    FreeAndNil(TddElmsTable);
  end;
end;

procedure TAutoFillFrmT2_2027.AFRHELPBTNClick(Sender: TObject);
begin
 //20201207
 ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/e-services/e-services-businesses/about-t2-auto-fill.html');
end;

Function TAutoFillFrmT2_2027.AllGroups(DataGroup: String): boolean;
Begin
  Result := False;
  if UpperCase(LeftStr(DataGroup, 3)) = 'ALL' then
    Result := True;
end;

Procedure TAutoFillFrmT2_2027.PopulateStringGridHeaders;
var
  i, MaxW, AvgW, NarrowColumnsW, RemainingW: integer;
begin
  // 20180518 Igor >>>
  MaxW := GroupBox5.width - AutoFillSectionsGroup.width -
    GetSystemMetrics(SM_CXVSCROLL) - GetSystemMetrics(SM_CXEDGE) * 2;
  with StringGrid1 do
  begin
    AvgW := MaxW div ColCount;
    ColWidths[1] := AvgW div 2; // Box
    ColWidths[2] := AvgW div 2; // instance
    NarrowColumnsW := ColWidths[1] + ColWidths[2]; // +ColWidths[5];
    RemainingW := MaxW - NarrowColumnsW;
    ColWidths[0] := Trunc(RemainingW / 3) + 150; // fixed
    RemainingW := RemainingW - ColWidths[0];
    ColWidths[3] := Trunc(RemainingW / 2.1) - 10; // Trunc(RemainingW / 1.5);
    ColWidths[4] := ColWidths[3] - 5;
    ColWidths[5] := 25;
    StringGrid1.Canvas.Font.Style := [fsBold];
    StringGrid1.Cells[0, 0] := 'Data Name';
    StringGrid1.Cells[1, 0] := 'Box No';
    StringGrid1.Cells[2, 0] := 'Instance'; // 'Instance No';  //20180519
    StringGrid1.Cells[3, 0] := 'Value from Auto-fill';
    StringGrid1.Cells[4, 0] := 'Current value in VT'; // 20180519
    StringGrid1.Cells[5, 0] := 'Post';   //20180519
  end;
  // 20180518 Igor <<<
end;

Procedure TAutoFillFrmT2_2027.PopulateStringGridData(SubSection: String;
  DataList: TStringList; Var R: integer);
Var
  i, C: integer;
  DataName: String;
  Instance: String;
  CraValue: String;
  FieldKey: String;
  BoxNo: String;
  FName: String;
  Elm: integer;
  vtValue: String;
  IsDollar: boolean; // to get vt data
  CD: TCorData; // 20180518 Igor
  A: TArray<String>; //20201126 Igor
begin
  StringGrid1.RowCount := ExtractedBNData.count + 10;
  C := 0;
  for i := 0 to DataList.count - 1 do // for each data elent
  begin
  	//20201126 Igor >>>
    A := DataList[I].Split([AFRStringDelimiter]);
    if Length(A) < 3 then continue;

    DataName := A[0];
    if IsDataGroupASlip(SubSection) then
      Instance := '#' + RmvLeadingZeros(A[1])
    else
      Instance := '';
    CraValue := A[2];

    {DataName := AllTrim(LeftStr(DataList[i], 62));

    if IsDataGroupASlip(SubSection) then
      Instance := '#' + RmvLeadingZeros(AllTrim(MidStr(DataList[i], 63, 3)))
    else
      Instance := '';

    CraValue := MidStr(DataList[i], 66, 100);}
    //20201126 Igor <<<

    // get the rest from the tddElms data base i.e boxno

    FieldKey := SubSection + '-' + DataName;

    if TddElmsTable.FindKey([FieldKey]) = True then
    begin
      FName := TddElmsTable.FieldByName('FormName').AsString;
      if UpperCase(TddElmsTable.FieldByName('Section').AsString) = 'INSTANCE' then  //instead of slips //20180521 CON
        FName := FName + Instance
      else
        Instance := '';

      BoxNo := TddElmsTable.FieldByName('BoxNo').AsString;

      if AllTrim(TddElmsTable.FieldByName('IsDollar').AsString) = 'Y' then
        IsDollar := True
      else
        IsDollar := False;

      //20201126 Igor >>>
      {if IsDollar = True then
        CraValue := FormatFloat('###,###,###.00',
          vl(MidStr(DataList[i], 66, 100))) // 20160214
      else
        CraValue := MidStr(DataList[i], 66, 100); // 20160214}
      if IsDollar = True then
        CraValue := FormatFloat('###,###,###.00',
          vl(CraValue));// 20160214
      //20201126 Igor <<<


      if Numeric(TddElmsTable.FieldByName('ElmNo').AsString) then
        Elm := StrToInt(TddElmsTable.FieldByName('ElmNo').AsString)
      else
        Elm := 0;

      RNo := GetRetNoFromBN(BN);
      // 20160214
      // 20180525 Igor >>>
      if not ExceptionalBoxes_GetValue(SubSection, FName, BoxNo, Elm, vtValue) then
      begin
        if IsDollar = True then
          vtValue := FormatFloat('###,###,###.00',
            vl(GetVtValue(RNo, FName, Elm, DataName, SubSection)))
        else
          vtValue := GetVtValue(RNo, FName, Elm, DataName, SubSection);
      end;
      // 20180525 Igor <<<
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
    if DataName <> 'TaxYear' then
    begin
      C := 0;
      StringGrid1.Cells[C, R] := DataName;
    end
    else
    begin
      R := R + 1;
      C := 0;
      StringGrid1.Cells[C, R] := DataName;
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
  // 20180518 Igor >>>
  if SameText(SubSection, 'T2ReturnData') then
  begin
    Inc(R);
    // 20180529 Igor >>>
    for I := 0 to FAutoFillForms.Count - 1 do
    begin
      FName := FAutoFillForms.ValueFromIndex[I];
      // 20180529 Igor <<<
      if not FCorData.ContainsKey(FName) then continue; // 20180606 Igor
      Inc(R);
      if StringGrid1.RowCount <= R then
        StringGrid1.RowCount := StringGrid1.RowCount + 10;
      StringGrid1.Cells[0, R] := FName;
      StringGrid1.Cells[5, R] := IntToStr(GetScheduleSelectionIndex(FName));
      Inc(R);
      for CD in FCorData.Items[FName] do
      begin
        if StringGrid1.RowCount <= R then
          StringGrid1.RowCount := StringGrid1.RowCount + 10;
        StringGrid1.Cells[0, R] := CD.BoxName;
        StringGrid1.Cells[1, R] := CD.BoxId;
        // StringGrid1.cells[2, R] := IntToStr(CD.ElmId);
        StringGrid1.Cells[3, R] := CD.Value;
        StringGrid1.cells[4, R] := CD.CurrValue; //20180525
        StringGrid1.Cells[5, R] := CD.vtSourceType;
        Inc(R);
      end;
    end;
  end;
  StringGrid1.RowCount := R + 1;
  // 20180518 Igor <<<
end;

procedure TAutoFillFrmT2_2027.AutoFillBtnClick(Sender: TObject);
var
  i: integer;
  Msg: string;
  DataGroup: string;
begin
  //20231211 Igor >>>
  if YearOf(FReceivedTaxYearEnd) < GetTaxationYearEndYYYY(GetCurrentRetNo) then
    if MessageDlg('Available CRA autofill data are for tax year ends prior to the year of the tax return being processed. It may be unwise to post this data to the current return.' + Chr(13) + //jz 20241124 added be after may
      'Proceed?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;
  //20231211 Igor <<<

  if (CountDataGroupsAccepted > 0) and
    (CountDataGroupsAccepted < DataGroups.Items.count) then
  begin
    if MessageDlg('Only some data are selected for Autofill' + Chr(13) +
      'Proceed?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      // ok

    else
      exit;
  end;

  if CountDataGroupsAccepted = 0 then
  begin
    if MessageDlg('No data groups checked for Autofill.' + Chr(13) +
      'Exit without Auto-filling the tax return?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
      // ok

    else
      exit;
  end;

  RNo := GetRetNoFromBN(BN);
  if RNo = 0 then
  begin
    ShowMessage('The tax return is not loaded. No update done.');
    exit;
  end;

  UpdateTaxReturn(BN, RNo);
  MainFormT2.RecalcBtnClick(Sender);

  Ret[RNo].Changed := True;

  Close;
end;

procedure TAutoFillFrmT2_2027.UpdateTaxReturn(BN: String; RNo: integer);
Var
  CFRAFillFNo, CDEFNo: integer;
  i, j: integer;
  UnfiledCnt, UnfiledNdx, ReassessmentCnt, ReassessmentNdx,
    ReassessmentInProgressCnt, ReassessmentInProgressNdx: integer;
  DataGroup: String;
  DataElmName: String;
  Instance: String;
  CraValue: String;
  NonCapitalLossIndex, CapitalGainDeductionIndex, CapitalGainLossIndex: integer;
  RRSPFNo, RRSPIndex1, RRSPIndex2: integer;
  // 20180518 Igor >>>
  FormName: string;
  CD: TCorData;
  // 20180518 Igor <<<
  // 20180529 Igor >>>
  Arr: array[1..10] of integer;
  ElmId: integer;
  cForm: string;
  // 20180529 Igor <<<
  A: TArray<string>; //20201130 Igor
begin
  UnfiledCnt := 0;
  UnfiledNdx := 13 - 1; // 1 less

  ReassessmentCnt := 0;
  ReassessmentNdx := 23 - 1;

  ReassessmentInProgressCnt := 0;
  ReassessmentInProgressNdx := 43 - 1;

  { to-do Write code for T2 }

  CFRAFillFNo := GetFormNo('CFRAFILL');
  RRSPFNo := GetFormNo('RRSP');       //NOT such form on T2!
  ExtractedBNSubCodeData := TStringList.Create;
  try
    NonCapitalLossIndex := 65 - 4; // starting line for saving

    CapitalGainLossIndex := 153 - 6;
    CapitalGainDeductionIndex := 285 - 5;
    RRSPIndex1 := 103 - 1;
    RRSPIndex2 := 133 - 1;
    For i := 0 to DataGroups.Items.count - 1 do
    begin
      DataGroup := DataGroups.Items[i];
      If DataGroups.Checked[i] then // ONLY if CHECKED AS ACCEPTED
      Begin
        IncomingSlipCnt := 0;
        ExtractedBNSubCodeData.clear;
        // only one slip in the ExtractedSinSubCodeData
        ExtractBNSubCodeData(DataGroup, ExtractedBNData,
          ExtractedBNSubCodeData);

        For j := 0 to ExtractedBNSubCodeData.count - 1 do
        begin
          //20201130 Igor >>>
          A := ExtractedBNSubCodeData[j].Split([AFRStringDelimiter]);
          if Length(A) < 3 then continue;
          DataElmName := AllTrim(A[0]);
          CraValue := A[2];
          (*
          DataElmName := AllTrim(LeftStr(ExtractedBNSubCodeData[j], 62));
          { TODO: Exclusive T2 mapping }
          CraValue := MidStr(ExtractedBNSubCodeData[j], 66, 100);
          *)
          //20201130 Igor <<<
          UpdateATaxReturnField(RNo, DataGroup, DataElmName, Instance,
            CraValue);
        end; // update fields

        // 20180518 Igor >>>
        if SameText(DataGroup, 'T2ReturnData') then
          for FormName in FCorData.Keys do
          begin
            if not GetScheduleSelection(FormName) then
              continue;
            { 20180519 con
              for CD in FCorData.Items[FormName] do
              if (CD.vtDataSource = vtUser) or (CD.vtDataSource = vtPopuplist) then
              SetValueToForm(RNo, FormName, CD.ElmId, CD.Value);
            }
            //20180529 Igor >>>
            if SameText(FormName, 'S100') or SameText(FormName, 'S125#1') then
              for J := 1 to 10 do Arr[J] := J * 10000 + 1;
            // 20180525 Igor >>>
            for CD in FCorData.Items[FormName] do
            begin
              if ExceptionalBoxes(DataGroup, FormName, CD.BoxId, CD.ElmId, CD.Value) then continue;
              // 20180528 Igor >>>
              if not SameText(CD.Value, CD.CurrValue) then
              begin
                if CD.ElmId = 0 then
                begin
                  if SameText(FormName, 'S100') or SameText(FormName, 'S125#1') then
                  begin
                    ElmId := Arr[CD.ArrayNo];
//                    if SameText(FormName, 'S100') then
//                      cForm := 'S100'
//                    else if SameText(FormName, 'S125') then
//                      cForm := 'S125#1';
                    cForm := FormName;
                    StoreElm(RNo, cForm, ElmId, GetGifiLineDesciption(CD.BoxId));
                    StoreElm(RNo, cForm, ElmId+1, CD.BoxId);
                    StoreElm(RNo, cForm, ElmId+2, CD.Value);
                    Arr[CD.ArrayNo] := ElmId + 4;
                  end
                end
                else
                  SetValueFromForm(RNo, FormName, CD.ElmId, CD.BoxId, CD.FieldType, CD.Value, CD.vtDataSource);
              end;
              // 20180528 Igor <<<
            end;
            // 20180525 Igor <<<
            // 20180529 Igor <<<
          end;
        // 20180518 Igor <<<
      end // checked
    end; // i
  finally
    ExtractedBNSubCodeData.Free;
  end;
  { TODO: Save indicator if need }
  // StoreElm(RNo, GetFormNo('INFO'), 222, 'X');  //Autofilled indicator
  // Calc(RNo, 'CFR');
  CalcFullReturn(RNo);
  MainForm.RefreshAuditPanel(RNo);
end;

Procedure TAutoFillFrmT2_2027.UpdateATaxReturnField(RNo: integer;
  DataGroup, DataName, Instance, CraValue: String);
Var
  FNo: integer;
  FieldKey: String;
  BoxNo: String;
  FName: String;
  Elm: integer;
  IncomingFName: String;
Begin
  If (DataGroup = '') Or (DataName = '') then
    exit;
  //20180522
  if DataName='ReturnMailIndicator' then
  Begin
    if UpperCase(CraValue)='TRUE' then
    ShowMessage('According to CRA records, your Mailing Address is not up to date.'
    +Chr(13)+'Please verify your address and make the necessary updates.');
  End;

//20180522
  if DataName='NonCapitalLossBalanceAmount' then
  Begin
    //craValue:='1234.78';  for testing
    if Vl(CraValue)>0 then
    Begin
    ShowMessage('There is a Non-Capital loss balance of '+FormatFloat('###,###,###',Round(Vl(craValue)))
    +Chr(13)+'Please verify with your own records in form S4WS. You can manually post it if you need to.'
    +Chr(13)+'Please see form AFRBAL');

    StoreElm(RNo,'AFRBAL',7,FormatDateTime('yyyy/mm/dd',Date)); //20201213
    StoreElm(RNo,'AFRBAL',8,CraValue); //20201213
    End;

  End;

  FieldKey := DataGroup + '-' + DataName;
  If TddElmsTable.FindKey([FieldKey]) = True then
  Begin
    FName := UpperCase(TddElmsTable.FieldByName('FormName').AsString);
    If UpperCase(TddElmsTable.FieldByName('Section').AsString) = 'INSTANCE' then   //instead of SLIPS //20180521 CON
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

  If Elm > 0 then
  Begin
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
      // 20180525 Igor >>>
      if not ExceptionalBoxes(DataGroup, FName, BoxNo, Elm, CraValue) then
        StoreElm(RNo, FNo, Elm, CraValue);
      // 20180525 Igor <<<
      Calc(RNo, FName);
      If CraValue > '' then
        Ret[RNo].FrmHasData[FNo] := True;
    end;
  end;
end;

procedure TAutoFillFrmT2_2027.UpdateScheduleSelection(AChecked: boolean);
// 20180518 Igor
var
  i: integer;
begin
  for i := 0 to Length(FScheduleSelection) - 1 do
    FScheduleSelection[i].Checked := AChecked;
  StringGrid1.Invalidate;
end;

Function TAutoFillFrmT2_2027.AnyDataGroupsAccepted: boolean;
Var
  i: integer;
Begin
  For i := 0 to DataGroups.Items.count - 1 do
    If DataGroups.Checked[i] then
      exit(True);
  Result := False;
end;

Function TAutoFillFrmT2_2027.CountDataGroupsAccepted: integer;
Var
  i: integer;
Begin
  Result := 0;
  For i := 0 to DataGroups.Items.count - 1 do
  begin
    If DataGroups.Checked[i] then
      Result := Result + 1;
  end;
end;

Function TAutoFillFrmT2_2027.CountTDDSlips(DataList: TStringList): integer;
// DataList is a string list with only a specific type of slip
// DataList contains only a single type of slip such as T3Slip
// each one separated by a TAXYEAR
Var
  i: integer;
  S: String;
Begin
  Result := 0;
  For i := 0 to DataList.count - 1 do
  Begin
    S := UpperCase(DataList[i]);
    If AllTrim(LeftStr(S, 15)) = 'TAXYEAR' then
      Result := Result + 1;
  end;
End;

Procedure TAutoFillFrmT2_2027.FixInstance(Var DataList: TStringList;
  SlipName: String);
Var
  i, j, InstNo: integer;
  S: String;
  Value: String;
  FirstRec: boolean;
  DataElmName, Instance: String;
begin
  If CountTDDSlips(DataList) <= 1 then
    exit; // no need to do anything
  InstNo := 0;
  i := 0;
  FirstRec := True;
  Repeat
    S := DataList[i];
    DataElmName := UpperCase(AllTrim(LeftStr(S, 62)));
    Instance := PaddZero(MidStr(S, 63, 3), 3);
    If DataElmName = 'TAXYEAR' THEN
    // means another slip of same type or a slip of diferent type
    Begin
      If FirstRec then // beginning of Slips subsection =First slip
      begin
        InstNo := InstNo + 1; // increment each time a TAXYEAR is encountered
        S := DataList[i];
        Instance := PaddZero(IntToStr(InstNo), 3);
        DataList[i] := LeftStr(S, 62) + Instance + MidStr(S, 66, 100);
        i := i + 1;
        FirstRec := False;
      end
      Else // not first taxyear  (not first slip)
      Begin
        InstNo := InstNo + 1;
        S := DataList[i];
        Instance := PaddZero(IntToStr(InstNo), 3);
        DataList[i] := LeftStr(S, 62) + Instance + MidStr(S, 66, 100);
        i := i + 1;
      end;
    end // first rec of each instance of s slip
    Else
    begin
      S := DataList[i];
      Instance := PaddZero(IntToStr(InstNo), 3);
      DataList[i] := LeftStr(S, 62) + Instance + MidStr(S, 66, 100);
      Inc(i, 1);
    end;
  until i > DataList.count - 1;
end;

function TAutoFillFrmT2_2027.ExceptionalBoxes(DataGroup, FormName, BoxNumber: string;
  ElmId: integer; CraValue: string): boolean; // 20180525 Igor
//20180529 Igor >>>
var L: TStringList;
    FElm, I: integer;
    cValue: string;
    x:Real;
//20180529 Igor <<<

  function GetDate(AValue: string): string;
  begin
    Result := Copy(AValue, 1, 4) + '/' + Copy(AValue, 5, 2) + '/' + Copy(AValue, 7, 2); // 20180528 Igor
  end;

  function GetTime(AValue: string): string;
  begin
    Result := Copy(AValue, 9, 2) + ':' + Copy(AValue, 11, 2);
  end;

begin
  {Result indicates that this record is processed in ExceptionalBoxes
   and it is not needed to process it further. So don't forget to set it True}
  Result := false;
  if Datagroup = 'T2ReturnData' then
  begin
    if (FormName = 'T2') then
    Begin
     If BoxNumber = '320' then  //divDeductible //20180531
     begin
      DivDeductible:=Vl(CraValue);
     end;
    //20180601
     If BoxNumber = '060' then
     begin
      StoreElm(RNo, GetFormNo(FormName), 10, ReplaceChar(GetDate(CraValue),'-','/'));
      if GetTime(CraValue) <> '00:00' then
      begin
       StoreElm(RNo, GetFormNo(FormName), 177, GetTime(CraValue));  //only if 66 is 1 etc
       StoreElm(RNo, GetFormNo(FormName), 216, 'Y');
      end;
      Result := true;
     end
     else if BoxNumber = '061' then
     begin
      StoreElm(RNo, GetFormNo(FormName), 11, ReplaceChar(GetDate(CraValue),'-','/'));
      if GetTime(CraValue) <> '23:59' then
      begin
       StoreElm(RNo, GetFormNo(FormName), 207, GetTime(CraValue)); // Only if 66 box is 1 etc
       StoreElm(RNo, GetFormNo(FormName), 216, 'Y');
      end;
      Result := true;
     end
    //done in Autofillgroupboxes.d  //20180601
    // else if BoxNumber = '460' then Begin  StoreElm(RNo,GetFormNo(FormName),527,CraValue); Result := true; end
    // else if BoxNumber = '465' then Begin  StoreElm(RNo,GetFormNo(FormName),528,CraValue); Result := true; end
    // else if BoxNumber = '624' then Begin  StoreElm(RNo,GetFormNo(FormName),628,CraValue); Result := true; end
     else if BoxNumber = '750' then Begin  StoreElm(RNo,GetFormNo(FormName),2,PrvLong[GetPrvNdx(CraValue)]); Result := true; end
     else if BoxNumber = '956' then  //20180531
     Begin
      StoreElm(RNo,GetFormNo(FormName),755,LeftStr(CraValue,3));  //area
      StoreElm(RNo,GetFormNo(FormName),746,MidStr(CraValue,4,8)); //telephone
      Result := true;
     end
     //else if BoxNumber = '604' then Begin  StoreElm(RNo,GetFormNo(FormName),2,PrvLong[GetPrvNdx(CraValue)]); Result := true; end
    end  //t2
    //20180525 //con
   { Done in AutofillFormGroupBoxes
    Else if (FormName = 'S1') then
    Begin
    If BoxNumber = '101' then  Begin  StoreElm(RNo,GetFormNo('S125#1'),77,CraValue); Result := true; end;
    End
   }
    //20180530 //con
    Else if (FormName = 'S7') then
    Begin
     If BoxNumber = '032' then
     Begin
       x:=Vl(CraValue) - DivDeductible; //Vl(FetchElm(RNo,'S7',225));
       StoreElm(RNo,GetFormNo('S7'),253,FormatFloat('#########',x)); //CraValue);
       Result := true;
       end;
    End

    else if (FormName = 'S524') then
    Begin
     If (BoxNumber = '100') then
     begin
      L := TStringList.Create;
      try
        L.Text := '4=1;5=2;6=3;7=4;9=6;11=8;12=9;13=10;14=11;15=12;16=13;17=14;'+
                  '18=15;19=16;20=17;21=18;22=19;23=20;24=21;25=22;26=99';
        L.Text := ReplaceStr(L.Text, ';', #13#10);
        for I := 0 to L.Count - 1 do
        begin
          FElm := StrToIntDef(Copy(L.Strings[I], 1, Pos('=', L.Strings[I]) - 1), 0);
          if FElm = 0 then continue;
          cValue := Copy(L.Strings[I], Pos('=', L.Strings[I]) + 1, Length(L.Strings[I]));
          if StrToInt(Trim(CraValue)) = StrToInt(Trim(cValue)) then
            StoreElm(RNo, GetFormNo(FormName), FElm, 'Y')
          else
            StoreElm(RNo, GetFormNo(FormName), FElm, '');
        end;
      finally
        L.Free;
     end;
    end;
    //20180529 Igor <<<
    end;
  end;
end;

function TAutoFillFrmT2_2027.ExceptionalBoxes_GetValue(DataGroup, FormName,
  BoxNumber: string; ElmId: integer; var Value: string): boolean; // 20180525 Igor
//20180529 Igor >>>
var L: TStringList;
    FElm, I: integer;
    FValue: string;

  function IsChecked(AElmId: integer): boolean;
  begin
    Result := not SameText(FetchElm(RNo, GetFormNo(FormName), AElmId), '');
  end;
//20180529 Igor <<<

begin
  {Result indicates that this record is processed in ExceptionalBoxes
   and it is not needed to process it further. So don't forget to set it True}
  Result := false;

  if Datagroup = 'T2ReturnData' then
  begin
    if (FormName = 'T2') and (BoxNumber = '060') then
    begin
      Value := ClearAllExceptDigits(FetchElm(RNo, GetFormNo(FormName), 10) + FetchElm(RNo, GetFormNo(FormName), 177));
      Result := true;
    end
    else if (FormName = 'T2') and (BoxNumber = '061') then
    begin
      Value := ClearAllExceptDigits(FetchElm(RNo, GetFormNo(FormName), 11) + FetchElm(RNo, GetFormNo(FormName), 207));
      Result := true;
    end
    //20180529 Igor >>>
    else if (FormName = 'T2') and (BoxNumber = '956') then   //20180603
    begin
      Value := ClearAllExceptDigits(FetchElm(RNo, GetFormNo(FormName), 755) + FetchElm(RNo, GetFormNo(FormName), 746));
      Result := true;
    end

    else if (FormName = 'S524') and (BoxNumber = '100') then
    begin
      L := TStringList.Create;
      try
        L.Text := '4=1;5=2;6=3;7=4;9=6;11=8;12=9;13=10;14=11;15=12;16=13;17=14;'+
                  '18=15;19=16;20=17;21=18;22=19;23=20;24=21;25=22;26=99';
        L.Text := ReplaceStr(L.Text, ';', #13#10);
        for I := 0 to L.Count - 1 do
        begin
          FElm := StrToIntDef(Copy(L.Strings[I], 1, Pos('=', L.Strings[I]) - 1), 0);
          if FElm = 0 then continue;
          if IsChecked(FElm) then
          begin
            Value := Copy(L.Strings[I], Pos('=', L.Strings[I]) + 1, Length(L.Strings[I]));
            Result := true;
            break;
          end;
        end;
      finally
        L.Free;
      end;
    //20180529 Igor <<<
    end;
  end;
end;

procedure TAutoFillFrmT2_2027.Exit2BtnClick(Sender: TObject);
begin
 {//20201213does not work
 RNo:=GetCurrentRetNo;
 if  FetchElm(RNo,'AFRBAL',8)>'' then OpenForm(RNo,'AFRBAL',0);
 }
 Close;
end;

// Procedure TAutoFillFrmT2_2027.ShowTddStatus;
// begin
// MainFormT2.ShowTddStatus;
// end;

procedure TAutoFillFrmT2_2027.RecreateAutofillElmTypesBtnClick(Sender: TObject); // 20180612 Igor
var L: TStringList;
    F: TForm;
    FullForm: TFormT2_2027;
    cForm, cStr, cValue: string;
    I, J, FieldId: integer;
begin
  L := TStringList.Create;
  L.Add('// This file is automatically created');
  L.Add('// It contains information about data source types for all elements of forms that are used in autofill');
  L.Add('// 0 - User, 1 - Linked, 2 - Calc, 3 - PopupList, 4 - AddingTape, 5 - Override');
  F := TForm.Create(Application);
  Screen.Cursor := crHourGlass;
  try
    F.Visible := False;
    for J := 0 to FAutoFillForms.Count - 1 do
    begin
      cForm := Trim(Copy(FAutoFillForms.Strings[J], Pos('=', FAutoFillForms.Strings[J]) + 1, Length(FAutoFillForms.Strings[J])));
      if SameText(cForm, '') then continue;
      try
        FullForm := TFormT2_2027.Create(F, RNo, GetFormNo(cForm));
        try
          ReadComponentResFile(GetDFMFileName(RNo, cForm), FullForm);
          for i := 0 to FullForm.ControlCount - 1 do
            if FullForm.Controls[i] is TvtEdit then
            begin
              FieldId := GetFieldId(TvtEdit(FullForm.Controls[i]).Name);
              if FieldId <> 0 then
              begin
                cStr := cForm + ':' + IntToStr(FieldId);
                cValue := IntToStr(Integer(TvtEdit(FullForm.Controls[i]).vtDataSource));
                L.Add(cStr + '=' + cValue);
              end;
            end;
        finally
          FullForm.Free;
        end;
      except
      end;
    end;
    L.SaveToFile(AppDir + '\' + 'AutoFillElmTypes.d');
  finally
    F.Free;
    L.Free;
    Screen.Cursor := crDefault;
    ShowMessage('AutoFillElmTypes.d was successfully recreated!');
  end;
end;

Function TAutoFillFrmT2_2027.RenameIncomingData(S: String): String;
// Renamed subsection
Const  LongPRPP = 'PooledRegisteredPensionPlan';
Var
  k: integer;
  Section, SubSection: String;
  IncomingElmName, NewElmName: String;
  SlipAndValue: String;
Begin
  Result := S;
  // no known cases to rename  //20180530
  (*
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
    (AllTrim(LeftStr(IncomingElmName, 8)) = 'Employee') then
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
 *)
End;

procedure TAutoFillFrmT2_2027.HelpBtnClick(Sender: TObject);
begin
  MainFormT2.actAutoFillGuideExecute(Application);
end;

procedure TAutoFillFrmT2_2027.StringGrid1MouseUp(Sender: TObject;
  // 20180518 Igor
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  ScheduleIndex: integer;
begin
  if Button = mbLeft then
    if (StringGrid1.Col = CHECKBOX_COL) and
      (StringGrid1.Cells[StringGrid1.Col, StringGrid1.Row] <> '') then
    begin
      ScheduleIndex := StrToIntDef(StringGrid1.Cells[StringGrid1.Col,
        StringGrid1.Row], -1);
      if ScheduleIndex >= 0 then
      begin
        FScheduleSelection[ScheduleIndex].Checked := not FScheduleSelection
          [ScheduleIndex].Checked;
        StringGrid1.Invalidate;
        if FScheduleSelection[ScheduleIndex].Checked and not DataGroups.Checked
          [DataGroups.itemIndex] then
          DataGroups.Checked[DataGroups.itemIndex] := True;
      end;
    end;
end;

procedure TAutoFillFrmT2_2027.StringGridDrawCell(Sender: TObject;
  ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
const
  HighlightCell = 4;
  HighlightCompareCell = 3;
  BoxCell = 1; // 20180518 Igor

  // 20180518 Igor >>>
var
  ScheduleIndex, cbStyle: integer;
  R: TRect;
  // 20180518 Igor <<<

begin
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

    // 20180518 Igor >>>
    if ACol = CHECKBOX_COL then
    begin
      ScheduleIndex := StrToIntDef(Cells[ACol, ARow], -1);
      Canvas.FillRect(Rect);
      if ScheduleIndex >= 0 then
      begin
        R := Rect;
        InflateRect(R, -2, -2);
        R.Right := R.Right - 2;
        if FScheduleSelection[ScheduleIndex].Checked then
          cbStyle := DFCS_BUTTONCHECK + DFCS_CHECKED
        else
          cbStyle := DFCS_BUTTONCHECK;
        DrawFrameControl(Canvas.Handle, R, DFC_BUTTON, cbStyle);
      end
    end
    else
      // 20180518 Igor <<<
      If (ARow >= FixedRows) and (ACol = HighlightCell) then
      begin
        If (Cells[HighlightCell, ARow] <> Cells[HighlightCompareCell, ARow]) and
          (LeftStr(UpperCase(Cells[HighlightCell, ARow]), 3) <> 'N/A') and
          (UpperCase(LeftStr(Cells[HighlightCell, ARow], 3)) <> 'SEE') and
          (UpperCase(LeftStr(Cells[HighlightCell, ARow], 6)) <> 'REVIEW') then
        Begin
          Canvas.Font.Color := clRed;
          Canvas.TextOut(Rect.Left + c_TextMargin, Rect.Top + c_TextMargin,
            Cells[HighlightCell, ARow]);
        end;
      end;
    // 20180518 Igor >>>
    if (ARow >= FixedRows) and (ACol = BoxCell) then
    begin
      If not(SameText(Cells[CHECKBOX_COL, ARow], '') or
        SameText(Cells[CHECKBOX_COL, ARow], 'User') or
        SameText(Cells[CHECKBOX_COL, ARow], 'Popuplist')) then
      begin
        if SameText(Cells[CHECKBOX_COL, ARow], 'Linked') then
          Canvas.Brush.Color := Rgb(151, 255, 151)
        else if SameText(Cells[CHECKBOX_COL, ARow], 'Calc') then
          Canvas.Brush.Color := Rgb(180, 180, 180)
        else if SameText(Cells[CHECKBOX_COL, ARow], 'AddingTape') then
          Canvas.Brush.Color := clYellow
        else if SameText(Cells[CHECKBOX_COL, ARow], 'Override') then
          Canvas.Brush.Color := clBlue
        else if SameText(Cells[CHECKBOX_COL, ARow], 'NOT FOUND') then
        begin
          Canvas.Brush.Color := clRed;
          Canvas.Font.Color := clWhite;
        end;
        Canvas.FillRect(Rect);
        Canvas.TextOut(Rect.Left + c_TextMargin, Rect.Top + c_TextMargin,
          Cells[BoxCell, ARow]);
      end;
    end;
    // 20180518 Igor <<<
  end; // with
end;

function TAutoFillFrmT2_2027.GetValueFromForm(ARetNo: integer; FName: string;
  AElmId: integer; ABoxId: string; AFieldType: string): string; // 20180525 Igor
var I, J: integer;
    FList: TList<TGroupBoxData>;
    R: TGroupBoxData;
    cValue: string;

    function ConvertMoneyAmount(AValue: string): string;
    begin
      if SameText(AValue, '') then
        Result := ''
      else
      begin
        try
          // 20180528 Igor >>>
          AValue := ReplaceStr(AValue, '.', FormatSettings.DecimalSeparator);
          AValue := ReplaceStr(AValue, ',', FormatSettings.DecimalSeparator);
          // 20180528 Igor <<<
          Result := FloatToStr(StrToFloat(AValue));
        except
          Result := '';
        end;
      end;
    end;

    function Get1bValue(AValue: string): string;
    begin
      if SameText(AValue, '') then
        Result := ''
      else
        Result := '1';
    end;

begin
  Result := '';

  if ExceptionalBoxes_GetValue('T2ReturnData', FName, ABoxId, AElmId, Result) then Exit; // 20180525 Igor

  if FormGroupBoxData.ContainsKey(FName) then
  begin
    FList := FormGroupBoxData.Items[FName];
    for I := 0 to FList.Count - 1 do
    begin
      R := FList.Items[I];
      if SameText(R.BoxId, ABoxId) then
      begin
        for J := 0 to Length(R.ElmIDs) - 1 do
          if not SameText(FetchElm(ARetNo, FName, R.ElmIDs[J]), '') then
          begin
            Result := IntToStr(J + 1);
            break;
          end;
        Exit;
      end;
    end;
  end;
  {
  // maybe we should somehow control that group box values must be specified in AutoFillFormGroupBoxes.d?
  // if they are specified, then they must return value above and never go to this section
  if SameText(AFieldType, 'Y/N') or
     SameText(AFieldType, '1/2') then
    ShowMessage('There is no data for group box type in AutoFillFormGroupBoxes.d');
  }
  cValue := FetchElm(RNo, FName, AElmId);
  if SameText(AFieldType, 'D') or SameText(AFieldType, 'D/T') then
    cValue := ClearAllExceptDigits(cValue)
  else if SameText(AFieldType, '$') then
    cValue := ConvertMoneyAmount(cValue)
  else if SameText(AFieldType, '1/b') then
    cValue := Get1bValue(cValue);
  Result := cValue;
end;

Function TAutoFillFrmT2_2027.GetVtValue(RNo: integer; FName: String;
  Elm: integer; DataName: String; SubSection: String): String;
Var
  Inst, SingleInst, MultiInst: String;
  InstNo, InstNoForElm: integer;
Begin
  { TODO: Exclusive mapping for T2 }
  if (RNo > 0) and (FName > '') and (Elm > 0) then
    Result := FetchElm(RNo, FName, Elm)
  else
    Result := '';
end;

procedure InitMap;
var
  T: TADTable;
  Con: TADConnection;
  ElmNo: integer;
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
        if (T.FieldByName('FORMNAME').AsString <> '') then
        begin
          ElmNo := StrToIntDef(T.FieldByName('ELMNO').AsString, 0);
          FAutoFillMap.add(T.FieldByName('FIELDKEY').AsString.ToLower,
            TArray<TVTElement>.Create
            (TVTElement.Create(T.FieldByName('FORMNAME').AsString,
            T.FieldByName('BOXNO').AsString, ElmNo)));
        end;
        T.Next;
      end;
    finally
      T.Free;
    end;
  finally
    Con.Free;
  end;
  { to-do Write code for T2 }
  {
    FAutoFillMap.AddOrSetValue(Lowercase('RegisteredRetirementSavingsPlan-DeductionLimitAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 2),
    TVTElement.Create('RRSP', '', 1)));
    FAutoFillMap.AddOrSetValue(Lowercase('RegisteredRetirementSavingsPlan-UnusedContributionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 1),
    TVTElement.Create('CFR', '', 31)));

    FAutoFillMap.AddOrSetValue(Lowercase('Client-RefundExaminationIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 1)));
    FAutoFillMap.AddOrSetValue(Lowercase('Client-GSTHSTReturnIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 2)));
    FAutoFillMap.AddOrSetValue(Lowercase('Client-WorkingIncomeTaxBenefitIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 3)));
    FAutoFillMap.AddOrSetValue(Lowercase('Client-CurrentYearReturnIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 4)));
    FAutoFillMap.AddOrSetValue(Lowercase('Client-BankruptIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 5)));
    FAutoFillMap.AddOrSetValue(Lowercase('Client-ImmigrationDate'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 6)));
    FAutoFillMap.AddOrSetValue(Lowercase('Client-EmigrationDate'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 7)));
    FAutoFillMap.AddOrSetValue(Lowercase('Client-DisabilityAmountEligibilityCode'),
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

    FAutoFillMap.AddOrSetValue(Lowercase('ReassessmentInProgress-ReassessmentInProgressIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 43)));
    FAutoFillMap.AddOrSetValue(Lowercase('ReassessmentInProgress-ReassessmentTaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 53)));

    FAutoFillMap.AddOrSetValue(Lowercase('Summary-HomeBuyerPlanRequiredRepaymentAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 3),
    TVTElement.Create('RRSP', '', 88, 1, 'Y'),
    TVTElement.Create('RRSP', '', 72)));
    FAutoFillMap.AddOrSetValue(Lowercase('Summary-LifeLongLearningPlanRequiredRepaymentAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 4),
    TVTElement.Create('RRSP', '', 75)));
    FAutoFillMap.AddOrSetValue(Lowercase('Summary-InstalmentAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('DIRECT', '', 4)));

    FAutoFillMap.AddOrSetValue(Lowercase('FedTuitionEducationTextBookAmount-CarryForwardAvailableAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 6),
    TVTElement.Create('S11', '', 13)));

    FAutoFillMap.AddOrSetValue(Lowercase('ProvTuitionEducationTextBookAmount-CarryForwardAvailableAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 7),
    TVTElement.Create('S11PRV', '', 13)));

    FAutoFillMap.AddOrSetValue(Lowercase('NonCapitalLoss-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 65, 4)));
    FAutoFillMap.AddOrSetValue(Lowercase('NonCapitalLoss-CurrentYearNonCapitalLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 66, 4)));
    FAutoFillMap.AddOrSetValue(Lowercase('NonCapitalLoss-PriorYearNonCapitalLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 67, 4)));
    FAutoFillMap.AddOrSetValue(Lowercase('NonCapitalLoss-SubsequentYearNonCapitalLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 68, 4)));

    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 153, 6)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-InclusionRate'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 154, 6)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-InclusionRate'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 155, 6)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-Taxable'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 157, 6)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-UnappliedNetLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 158, 6)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-PriorYearNetLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 159, 6)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainLoss-SubsequentYearNetLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 160, 6)));

    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainDeduction-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 285, 5)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainDeduction-CapitalGainDeductionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 286, 5)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainDeduction-NetCapitalGainLossAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 287, 5)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainDeduction-NetFarmPropertyDispositionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 288, 5)));
    FAutoFillMap.AddOrSetValue(Lowercase('CapitalGainDeduction-NetSmallBusinessShareDispositionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CFRAFILL', '', 289, 5)));

    FAutoFillMap.AddOrSetValue(Lowercase('RRSPContributionReceiptSlip-TaxYear'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 103, 3)));
    FAutoFillMap.AddOrSetValue(Lowercase('RRSPContributionReceiptSlip-IssuerName'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 104, 3)));
    FAutoFillMap.AddOrSetValue(Lowercase('RRSPContributionReceiptSlip-SlipVersionDescription'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 105, 3)));
    FAutoFillMap.AddOrSetValue(Lowercase('RRSPContributionReceiptSlip-RRSPNumber'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 133, 5)));
    FAutoFillMap.AddOrSetValue(Lowercase('RRSPContributionReceiptSlip-RRSPContractNumber'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 134, 5)));
    FAutoFillMap.AddOrSetValue(Lowercase('RRSPContributionReceiptSlip-RRSPSpouseContributionIndicator'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 135, 5)));
    FAutoFillMap.AddOrSetValue(Lowercase('RRSPContributionReceiptSlip-PriorYearRRSPContributionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 136, 5)));
    FAutoFillMap.AddOrSetValue(Lowercase('RRSPContributionReceiptSlip-CurrentYearRRSPContributionAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('RRSP', '', 137, 5)));

    FAutoFillMap.AddOrSetValue(Lowercase('DisabilityEligibilities-DisabilityAmountEligibilityCode'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 8)));

    FAutoFillMap.AddOrSetValue(Lowercase('RefundSetoff-RefundSetoffProgramCode'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 70)));
    FAutoFillMap.AddOrSetValue(Lowercase('RefundSetoff-RefundSetoffProgramAmount'),
    TArray<TVTElement>.Create(TVTElement.Create('CDE', '', 10))); }
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

FreeAndNil(FAutoFillMap);

end.
