unit TaxCycleUtil;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  {$WARN UNIT_PLATFORM OFF}vcl.FileCtrl,{$WARN UNIT_PLATFORM ON}
  ZLib, System.Generics.Collections, System.Generics.Defaults,
  System.RegularExpressions, Vcl.ComCtrls, Vcl.Samples.Spin, Math, Vcl.ImgList,
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, vtMulti, vtCommon, vtMain,
  Vcl.Grids, Vcl.ValEdit, TaxCycleMap, Vcl.Menus, StrUtils, IniFiles, DateUtils,
  VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart;

type
  TParam = class;
  TParamList = class(TObjectList<TParam>)
  private
    FOwnerParam: TParam;
    procedure SetOwnerParam(const Value: TParam);
  public
    property OwnerParam: TParam read FOwnerParam write SetOwnerParam;
  end;

  TvtGroup = class
  private
    FFormName: String;
    FElements: TArray<Integer>;
    procedure SetFormName(const Value: String);
    procedure SetElements(const Value: TArray<Integer>);

  public
    constructor Create(ASourceStr: String);
    property Elements: TArray<Integer> read FElements write SetElements;
    function InRadioGroup(const AElement: Integer): Boolean;
    property FormName: String read FFormName write SetFormName;
  end;

  TvtGroups = class(TObjectList<TvtGroup>)
  public
    Constructor Create(AApp: TApp);
    function InRadioGroup(const AForm: String; const AElement: Integer; out AGroup: TvtGroup): Boolean;
  end;

  TParam = Class(TObject)
  private
    FName: String;
    FParent: TParamList;
    FDopData: TBytes;
    FItems: TParamList;
    FKind: Byte;
    FData: TBytes;
    FVarLengthData: Integer;
    FStringData: String;
    FDateData: TDateTime;
    FDecimalData: Real;
    FLevel: Byte;
    FVisualTaxReturnNo: Integer;
    FRowNumber: word;
    FPath: String;
    FSlipNo: Integer;
    procedure SetData(const Value: TBytes);
    procedure SetDopData(const Value: TBytes);
    procedure SetItems(const Value: TParamList);
    procedure SetKind(const Value: Byte);
    procedure SetName(const Value: String);
    procedure SetParent(const Value: TParamList);
    procedure SetVarLengthData(const Value: Integer);
    procedure SetStringData(const Value: String);
    procedure SetDateData(const Value: TDateTime);
    procedure SetDecimalData(const Value: Real);
    function GetFullName: String;
    procedure SetLevel(const Value: Byte);
    procedure SetVisualTaxReturnNo(const Value: Integer);
    procedure SetRowNumber(const Value: word);
    function GetSlipNo: Integer;
    procedure SetSlipNo(const Value: Integer);
    function MatchEvalElement(const Match: TMatch): string;
  protected
  public
    constructor Create(AParent: TParamList);
    destructor Destroy; override;
    property Name: String read FName write SetName;
    property Kind: Byte read FKind write SetKind;
    Property Data: TBytes read FData write SetData;
    property DopData: TBytes read FDopData write SetDopData;
    property Items: TParamList read FItems write SetItems;
    property Parent: TParamList read FParent write SetParent;
    property StringData: String read FStringData write SetStringData;
    property VarLengthData: Integer read FVarLengthData write SetVarLengthData;
    property DateData: TDateTime read FDateData write SetdateData;
    property DecimalData: Real read FDecimalData write SetDecimalData;
    property Fullname: String read GetFullName;
    property Level: Byte read FLevel write SetLevel;
    property RowNumber: word read FRowNumber write SetRowNumber;
    function ValueAsString: String;
    function FullDescription: String;
    function Path: String;
    property VisualTaxReturnNo: Integer read FVisualTaxReturnNo write SetVisualTaxReturnNo;
    function IsLastRow: Boolean;
    function RowNo: Integer;
    property SlipNo: Integer read GetSlipNo write SetSlipNo;
    function FindChild(APath: String): TParam;
    function FindChilds(const APath: String): TParamList; overload;
    procedure FindChilds(const APath: String; AList: TParamList); overload;

  end;

  TTaxCycleFile = class(TObject)
  private
    FHeaderComment: String;
    FVendor: String;
    FHeaderComment2Type: Byte;
    FHeaderComment2: String;
    FFileversion: Byte;
    FBPart1: TBytesStream;
    SubParts2: Array of TBytes;
    FUnknownSection: TBytes;

    FParams: TParamList;
    FSourceFileName: String;
    FCurrYear: integer; //20240103 Igor
    function DoLoadFromStream(AStream: TStream): Boolean;

    procedure SetHeaderComment(const Value: String);
    procedure SetVendor(const Value: String);
    procedure SetHeaderComment2Type(const Value: Byte);
    procedure SetHeaderComment2(const Value: String);
    procedure SetFileversion(const Value: Byte);
    procedure SetParams(const Value: TParamList);
    procedure SetSourceFileName(const Value: String);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromFile(AFileName: String): Boolean;
    function LoadFromStream(AStream: TStream): Boolean;
    procedure ExportToTree(ATreeView: TTreeView; AMap: IXMLTaxCycleMapType);

    property Params: TParamList read FParams write SetParams;
    property Fileversion: Byte read FFileversion write SetFileversion;
    property HeaderComment: String read FHeaderComment write SetHeaderComment;
    property HeaderComment2Type: Byte read FHeaderComment2Type write SetHeaderComment2Type;
    property HeaderComment2: String read FHeaderComment2 write SetHeaderComment2;
    property Vendor: String read FVendor write SetVendor;
    property SourceFileName: String read FSourceFileName write SetSourceFileName;
    property CurrYear: Integer read FCurrYear write FCurrYear; //20240103 Igor

  end;

  TfrmTaxCycleUtil = class(TForm)
    Panel1: TPanel;
    flbMain: TFileListBox;
    pnlToolsDeveloper: TPanel;
    btnReadCurrent: TButton;
    pnlTree: TPanel;
    TreeView1: TTreeView;
    Panel3: TPanel;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    mmoNodeData: TMemo;
    Splitter2: TSplitter;
    btnMappingMode: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tsMap: TTabSheet;
    edTaxCyclePath: TEdit;
    Label1: TLabel;
    edVisualTaxFormName: TEdit;
    Label2: TLabel;
    veTransform: TValueListEditor;
    Label3: TLabel;
    rgValue: TRadioGroup;
    Label4: TLabel;
    Label5: TLabel;
    edVisualTaxElementNo: TSpinEdit;
    btnSaveMapElement: TButton;
    btnConvert: TButton;
    btnFillProvince: TButton;
    btnPhone: TButton;
    Label7: TLabel;
    btnReadSelected: TButton;
    btnReadAll: TButton;
    imgSlip: TImage;
    chbSlipToMuliSlip: TCheckBox;
    lblNumberOfForms: TLabel;
    edtNumberOfForms: TSpinEdit;
    lblShift: TLabel;
    edtShift: TSpinEdit;
    imgTableRow: TImage;
    pmNode: TPopupMenu;
    mniClearLink: TMenuItem;
    btnRolloverSelected: TButton;
    pnlSearch: TPanel;
    edtSearch: TEdit;
    btnSearchNext: TSpeedButton;
    btnSearchPrior: TSpeedButton;
    chbUseDynTarget: TCheckBox;
    btnDynTarget: TSpeedButton;
    tsDynTarget: TTabSheet;
    Panel2: TPanel;
    Panel4: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    lvDynTarget: TListView;
    Panel5: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edTCFromRowNo: TSpinEdit;
    edvtFormName: TEdit;
    edVTFromElementNo: TSpinEdit;
    edVTShift: TSpinEdit;
    btnDynMapAdd: TSpeedButton;
    btnDynMapApply: TSpeedButton;
    btnDynMapDelete: TSpeedButton;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    chAutolink: TCheckBox;
    Label14: TLabel;
    chbSkipLastRow: TCheckBox;
    Label15: TLabel;
    btnFillProvince2: TButton;
    btnFillProvince3: TButton;
    GroupBox1: TGroupBox;
    lblCurrOfTotal: TLabel;
    lblStage: TLabel;
    lblStageName: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    lblElement: TLabel;
    lbNotSavedReturns: TListBox;
    Label18: TLabel;
    Chart1: TChart;
    Label19: TLabel;
    SaveOrOpenOptionBox: TRadioGroup;
    ReplaceOptionBox: TRadioGroup;
    Label6: TLabel;
    Label8: TLabel;
    LinkToOptionsLbl: TLabel;
    edtSourcePath: TEdit;
    cbFileExt: TComboBox;
    edtTargetPath: TEdit;
    btnSelectVTDir: TSpeedButton;
    Label9: TLabel;
    btnSelectTaxCycleDir: TSpeedButton;
    Label20: TLabel;
    Label21: TLabel;
    cbDeveloperMode: TCheckBox;
    btnGenerateDFile: TButton; //20180122 Igor
    procedure btnSelectTaxCycleDirClick(Sender: TObject);
    procedure edtSourcePathChange(Sender: TObject);
    procedure btnReadCurrentClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure btnMappingModeClick(Sender: TObject);
    procedure btnSaveMapElementClick(Sender: TObject);
    procedure edTaxCyclePathChange(Sender: TObject);
    procedure veTransformValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: string);
    procedure TreeView1Changing(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure btnConvertClick(Sender: TObject);
    procedure btnFillProvinceClick(Sender: TObject);
    procedure btnPhoneClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mniClearLinkClick(Sender: TObject);
    procedure LinkToOptionsLblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSearchNextClick(Sender: TObject);
    procedure btnSearchPriorClick(Sender: TObject);
    procedure chbUseDynTargetClick(Sender: TObject);
    procedure btnDynTargetClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnDynMapAddClick(Sender: TObject);
    procedure btnDynMapApplyClick(Sender: TObject);
    procedure btnDynMapDeleteClick(Sender: TObject);
    procedure lvDynTargetSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvDynTargetChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure lbNotSavedReturnsDblClick(Sender: TObject);
    procedure cbFileExtChange(Sender: TObject);
    procedure cbDeveloperModeClick(Sender: TObject); //20180122 Igor
    procedure btnGenerateDFileClick(Sender: TObject); //20190730 Igor
  private
    type
      TDynTargetRec = record
        TCFromRowNo: Integer;
        VTFormName: String;
        VTFromElementNo: Integer;
        VTShift: Integer;
      end;
  private
    { Private declarations }

    TCFiles: TObjectList<TTaxCycleFile>;
    FApp: TApp;
    FFileExt: String;
    FMappingMode: Boolean;
    XMLMap: IXMLTaxCycleMapType;
    FMapElementChanged: Boolean;
    FGroups: TvtGroups;
    FDevelopMode: Boolean;
    NotSavedReturns: TArray<Integer>;
    FDynTargetBuf: TArray<TDynTargetRec>;
    FUsedForms: TStringList;
    FCommonSourceParam: TParam;
    IsDeveloper: boolean; //20180122 Igor
    procedure Init;
    function RollOverOne(AFileName: String): Boolean;
    procedure SaveMap;
    procedure ClearMapPanel;
    procedure UpdateMapPanel(AParam: TParam);
    procedure FillDynTarget;
    procedure SaveMapElement;
    procedure DoFill(AParamList: TParamList; ARetNo: Integer; AReplace, AOpen: Boolean);
    procedure DoFill2(AParam: TParam; AReplace, Aopen: Boolean; ALastYearShift: integer); //20240103 Igor
    procedure SyncronizeTree;
    procedure SetDevelopMode(const Value: Boolean);
    procedure DoConvertAll;
    function NextNode(ANode: TTreeNode; ADown: Boolean): TTreeNode;
    property DevelopMode: Boolean read FDevelopMode write SetDevelopMode;
    procedure DoRollOver(AList: TStrings);
    function YtoDigit(const Match: TMatch): String;
    function MatchEvaluatorElementNo(const Match: TMatch): string;

  protected
    FOriginalActiveControlChanged: TNotifyEvent;
    procedure ActiveControlChanged(Sender: TObject);
  public
    { Public declarations }
  end;

procedure RollOverFromTaxCycle(AApp: TApp; AFileExt: String = '*.*');

implementation

{$R *.dfm}

uses
  System.RTLConsts, fVTNoSplash, vtEditBox, vtForm, vtTrimStr, vtShared;

const
  c_TaxCycleMap = 'TaxCycleMap.d';
  c_TaxCycleMap2 = 'rolltc1.d';
  c_TaxCycleD = 'rolltc1_export.d'; //20190730 Igor
  c_LevelFile = $00;
  c_LevelReturn = $01;
  c_LevelForm = $02;
  c_LevelFormPart = $03;
  c_LevelValue = $04;
  c_LevelSlipPart = $05;
  c_LevelRowValue = $06;
  c_LevelLink = $07;
  c_LevelSlipGroup = $08;
  c_LevelTableLine = $09;

  c_ValueKind_String = $00;
  c_ValueKind_Decimal = $01;
  c_ValueKind_Date = $02;
  c_ValueKind_VariableLengthField = $03;
  c_ValueKind_Note = $14;
  c_ValueKind_StringWithOutDopData = $51;

function CurrAppYear: integer; //20240103 Igor
begin
  Result := StrToIntDef(Copy(ExeYear, 4, 4), 0);
end;

//var
//  mymmoBytes: TMemo;
//
//procedure WriteBytes(AStream: TStream);
//var
//  p, i: Integer;
//  S: String;
//  B: Byte;
//begin
//  p := AStream.Position;
//  try
//    S := '';
//    for I := 0 to 255 do
//    begin
//      if AStream.Position >= AStream.Size then
//        break;
//      AStream.ReadData(B);
//      S := S + ' ' + IntToHex(B, 2);
//    end;
//    mymmoBytes.lines.Add(S);
//  finally
//    AStream.Position := p;
//  end;
//end;

function MyConcat(const S1, S2, Delim: String): String;
begin
  if S1.Trim.IsEmpty or S2.Trim.IsEmpty then
    Result := S1 + S2
  else
    Result := S1 + Delim + S2;
end;

procedure SkipPrefix(AStream: TStream);
var
  b: Byte;
begin
  while AStream.Position < AStream.Size do
  begin
    AStream.ReadData(B);
    if B < $80 then
    begin
      AStream.Position := AStream.Position - 1;
      exit;
    end;
  end;
end;

function BytesToRawByteString(const Bytes: TBytes): RawByteString;
begin
  if Length(Bytes) = 0 then
    exit('');
  SetLength(Result, Length(Bytes));
  Move(Bytes[0], Result[1], Length(Bytes))
end;

function BytesToReal(ABytes: TBytes): Real;
var
  I: Int64;
  J, K, L: Integer;
  E, E1, E2: Extended;
begin
  E := 0;
  K := 0;
  for J := 0 to 11 do
  begin
    E1 := ABytes[J];
    if K > 0 then
    begin
      E2 := 2;
      for L := 2 to (K * 8) do
        E2 := E2 * 2;
    end
    else
      E2 := 1;
    E := E + E1 * E2;
    inc(K);
  end;

  J := ABytes[14];
  while J > 0 do
  begin
    E := E / 10;
    Dec(J);
  end;
  //20190902 Igor >>>
  if ABytes[15] and 128 = 128 then
    Result := -E
  else
    Result := E;
  //20190902 Igor <<<
end;

procedure RollOverFromTaxCycle(AApp: TApp; AFileExt: String = '*.*');
begin
  With TfrmTaxCycleUtil.Create(Application) do
  begin
    FApp := AApp;
    FFileExt := AFileExt;
    Visible := False;
    //20240103 Igor >>>
    if DebugHook = 0 then
      FormStyle := fsStayOnTop;
    init;
    ShowModal;
    //20240103 Igor <<<
  end;
end;

function BytesToHex(ABytes: TBytes): String;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to length(ABytes) - 1 do
    Result := Result + IntToHex(ABytes[I], 2) + ' ';
end;

procedure SaveStreamPart(AStream: TStream; AStart, ALength: Int64; AFileName: String);
var
  X: int64;
  B: TBytes;
begin
  if not System.SysUtils.ForceDirectories(ExtractFileDir(AFileName)) then
    exit;
  X := AStream.Position;
  try
    AStream.Position := AStart;
    SetLength(B, ALength);
    AStream.Read(B, ALength);
    With TBytesStream.Create(B) do
    begin
      try
        SaveToFile(AFileName);
      finally
        Free;
      end;
    end;
  finally
    AStream.Position := X;
  end;
end;

function CSharpToDateTime(const csDateTime: UInt64): TDateTime;
const
  // Number of 100ns ticks per time unit
  TicksPerMillisecond = Int64(10000);
  TicksPerSecond = Int64(TicksPerMillisecond * 1000);
  TicksPerMinute = Int64(TicksPerSecond * 60);
  TicksPerHour = Int64(TicksPerMinute * 60);
  TicksPerDay = Int64(TicksPerHour * 24);

  // Number of milliseconds per time unit
  MillisPerSecond = 1000;
  MillisPerMinute = MillisPerSecond * 60;
  MillisPerHour = MillisPerMinute * 60;
  MillisPerDay = MillisPerHour * 24;

  // Number of days in a non-leap year
  DaysPerYear = 365;
  // Number of days in 4 years
  DaysPer4Years = DaysPerYear * 4 + 1;       // 1461
  // Number of days in 100 years
  DaysPer100Years = DaysPer4Years * 25 - 1;  // 36524
  // Number of days in 400 years
  DaysPer400Years = DaysPer100Years * 4 + 1; // 146097

  // Number of days from 1/1/0001 to 12/31/1600
  DaysTo1601 = DaysPer400Years * 4;          // 584388
  // Number of days from 1/1/0001 to 12/30/1899
  DaysTo1899 = DaysPer400Years * 4 + DaysPer100Years * 3 - 367;
  // Number of days from 1/1/0001 to 12/31/1969
  DaysTo1970 = DaysPer400Years * 4 + DaysPer100Years * 3 + DaysPer4Years * 17 + DaysPerYear; // 719,162
  // Number of days from 1/1/0001 to 12/31/9999
  DaysTo10000 = DaysPer400Years * 25 - 366;  // 3652059

  DoubleDateOffset = Int64(DaysTo1899 * TicksPerDay);
  // The minimum OA date is 0100/01/01 (Note it's year 100).
  // The maximum OA date is 9999/12/31
  OADateMinAsTicks = Int64((DaysPer100Years - DaysPerYear) * TicksPerDay);
  // All OA dates must be greater than (not >=) OADateMinAsDouble
  OADateMinAsDouble = -657435.0;
  // All OA dates must be less than (not <=) OADateMaxAsDouble
  OADateMaxAsDouble = 2958466.0;

var
  Ticks: UInt64;
  Millis: Int64;
  Frac: Int64;
begin
  Result := 0;
  Ticks := csDateTime and $3FFFFFFFFFFFFFFF;
  if Ticks = 0 then
    Exit; // Returns OleAut's zero'ed date Ticks.
  //if Ticks < TicksPerDay then // This is a fix for VB. They want the default day to be 1/1/0001 rathar then 12/30/1899.
  //  Inc(Ticks, DoubleDateOffset); // We could have moved this fix down but we would like to keep the bounds check.
  if Ticks < OADateMinAsTicks then
    raise Exception.Create(sArgumentInvalid);
  // Currently, our max date == OA's max date (12/31/9999), so we don't
  // need an overflow check in that direction.
  Millis := (Ticks  - DoubleDateOffset) div TicksPerMillisecond;
  if Millis < 0 then
  begin
    Frac := Millis mod MillisPerDay;
    if Frac <> 0 then
      Dec(Millis, (MillisPerDay + Frac) * 2);
  end;
  Result := Millis / MillisPerDay;
end;


procedure TfrmTaxCycleUtil.ActiveControlChanged(Sender: TObject);
var
  C: TWinControl;
  E: TvtEdit;
  O: TObject;
  I: Integer;
  G: TvtGroup;
  P: TParam;
begin
  if Application.Terminated then
    exit;
  if Assigned(FOriginalActiveControlChanged) then
    FOriginalActiveControlChanged(Sender);
  if chAutolink.Checked and
     Assigned(Sender) and
     (Sender is TScreen) AND
     Assigned(TScreen(Sender).ActiveControl) and
     (TreeView1.Selected <> nil) and
     (TreeView1.Selected.Data <> nil) and
     (TParam(TreeView1.Selected.Data).Level in [c_LevelValue, c_LevelRowValue, c_LevelSlipGroup]) then
  begin
    C := TScreen(Sender).ActiveControl;
    if C is TvtEdit then
    begin
      E := TvtEdit(C);
      if E.Owner is TvtForm then
        edVisualTaxFormName.Text := TvtForm(E.Owner).FormName
      else
        raise Exception.Create('Can''nt identify Form');
      if edVisualTaxElementNo.Value = E.FieldId then
        exit;
      edVisualTaxElementNo.Value := E.FieldId;
      case e.vtInputType of
        vtString: rgValue.ItemIndex := c_Value_AsIs;
        vtNumber:
          begin
            if (TreeView1.Selected <> nil) and
               (TreeView1.Selected.Data <> nil) and
               (TParam(TreeView1.Selected.Data).Kind = c_ValueKind_Date) then
              rgValue.ItemIndex := c_Value_DateTime
            else
              rgValue.ItemIndex := c_Value_AsIs;
          end;
        vtPhoneNumber: rgValue.ItemIndex := c_Value_AsIs;
        vtDollar: rgValue.ItemIndex := c_Value_InDollar;
        vtDateT1: rgValue.ItemIndex := c_Value_DateTime;
        vtDateT2: rgValue.ItemIndex := c_Value_DateTime;
        vtSin: rgValue.ItemIndex := c_Value_AsIs;
        vtPostal: rgValue.ItemIndex := c_Value_AsIs;
        vtZip: rgValue.ItemIndex := c_Value_AsIs;
        vtBN: rgValue.ItemIndex := c_Value_AsIs;
        vtDropDownBox: rgValue.ItemIndex := c_Value_Transform;
        vtCheckBox:
          begin
            if FGroups.InRadioGroup(edVisualTaxFormName.Text, E.FieldId, G) then
            begin
              rgValue.ItemIndex := c_Value_RadioGroup;
              veTransform.Strings.Clear;
              for I := 0 to length(G.Elements) - 1 do
                veTransform.Strings.Add(IntToStr(I) + '=' + IntToStr(G.Elements[I]));
            end
            else
              rgValue.ItemIndex := c_Value_Check
          end;
        vtYesOrNo: rgValue.ItemIndex := c_Value_YesOrNot;
        vtPercent: rgValue.ItemIndex := c_Value_Percent;
      end;
    end;
  end;
end;

procedure TfrmTaxCycleUtil.DoFill(AParamList: TParamList; ARetNo: Integer; AReplace, AOpen: Boolean);
var
  P: TParam;
  AMapElement: IXMLElementType;
  FormName, S, S1: String;
  ElementNo, I, StrStart, StrCount, FormNo, TCRowNo, TCSlipNo, Dummy, X: Integer;
  TargetFileName: String;
  C: char; //20190723 Igor

  function IntToYesOrNot(AByteData: Integer): String;
  begin
    case AByteData of
      $00: Result := 'N';
      $01: Result := 'Y';
    else
      Result := '';
    end;
  end;
  function IntToX(AByteData: Integer): String;
  begin
    case AByteData of
      $01: Result := 'X';
    else
      Result := '';
    end;
  end;

  procedure PreFillElement(AFormName: String; AElementNo: Integer; AValue: String);
  begin
    if AFormName.StartsWith('ASSETSB#') then
    begin
      if (AElementNo = 170) and (AValue <> '') then
        StoreElm(ARetNo, AFormName, 13, 'X')
      else
      if (AElementNo = 177) and (AValue <> '') then
        StoreElm(ARetNo, AFormName, 206, 'X');
      if (AElementNo = 27) and (AValue <> '') then
        StoreElm(ARetNo, AFormName, 28, 'X');
    end
    else
    if AFormName.StartsWith('AUTOS#') then
    begin
      if AElementNo = 173 then
        StoreElm(ARetNo, AFormName, 206, 'X');
    end;
  end;
  procedure PreFillForm(APrm: TParam; AFormName: String);
  var
    SS: String;
    lP, lp2: TParam;
    SlipNo: Integer;
  begin
    if AFormName.StartsWith('ASSETSB#') then
    begin
      SS := APrm.Path;
      if pos('T2042Forms.Group of form #', SS) > 0 then
      begin
        Delete(SS, 1, length('T2042Forms.Group of form #'));
        SS := copy(SS, 1, pos('.', SS) - 1);
        StoreElm(ARetNo, AFormName, 215, 'T2042#' + SS);
        StoreElm(ARetNo, AFormName, 216, '100');
        StoreElm(ARetNo, AFormName, 4, '100');
      end;
    end;
    if AFormName.StartsWith('AUTOS#') then
    begin
      lP := APrm;
      while Assigned(lP) do
      begin
        if lP.Name = 'Allocation' then
          break;
        if Assigned(lp.Parent) then
          lp := lp.Parent.OwnerParam
        else
          lp := nil;
      end;
      if Assigned(lp) then
      begin
        lp2 := lp.FindChild('Table row #1.Slip.Link #1');
        if Assigned(lp2) then
        begin
          S := lp2.StringData;
          Delete(S, 1, pos('.', S));
          if S.StartsWith('T2042Forms') then
          begin
            Delete(S, 1, length('T2042Forms.'));
            SlipNo := strToInt(copy(S, 1, pos('.', S) - 1)) + 1;
            StoreElm(ARetNo, AFormName, 215, 'T2042#' + SlipNo.ToString);
            StoreElm(ARetNo, AFormName, 216, '100');
          end;
        end;
      end;
    end;
  end;

  procedure PostFillForm(AFormName: String);
  begin

  end;

begin
  for P in AParamList do
  begin
    if P.Level = c_LevelReturn then
    begin
      if (P.VisualTaxReturnNo = 0) or
         not Assigned(RetList[P.VisualTaxReturnNo]) or
         (RetList[P.VisualTaxReturnNo].Destroying) then
      begin
        ARetNo := FApp.InitNewReturn(True);
        if ARetNo <= 0 then
          raise Exception.Create('Can''t create new return')
        else
          P.VisualTaxReturnNo := ARetNo;
      end
      else
        ARetNo := P.VisualTaxReturnNo;
    end
    else
    if P.Level in [c_LevelValue, c_LevelRowValue] then
    begin
      lblElement.Caption := P.Path;
      lblElement.Repaint;
      AMapElement := XMLMap.Elements.FindElementByTaxCyclePath(P.Path);
      if (AMapElement <> nil) then
      begin
        FormName := AMapElement.RealVisualTaxFormName(P.Path, P.SlipNo);
        if FormName = '' then
          Continue;

        ElementNo := AMapElement.VisualTaxPath.ElementNo;
        if AMapElement.isTableRowElement then
        begin
          if AMapElement.SkipLastRow and P.IsLastRow then
            Continue;
          if AMapElement.UseDynTarget then
          begin
            TCRowNo := P.RowNo;
            I := AMapElement.DynTarget.Count - 1;
            if (AMapElement.DynTarget.Count > 0) and
               (AMapElement.DynTarget[I].TaxCycleFromRowNo = -1) then
            begin
              if P.IsLastRow then
              begin
                if AMapElement.DynTarget[I].VisualTaxFormName <> '*' then
                  FormName := AMapElement.DynTarget[I].VisualTaxFormName;
                TCRowNo := TCRowNo - AMapElement.DynTarget[I].TaxCycleFromRowNo;
                ElementNo := AMapElement.DynTarget[I].VisualTaxStartElementNo + TCRowNo * AMapElement.DynTarget[I].VisualTaxShift;
                X := 0;
              end
              else
                X := 2;
            end
            else
              X := 1;
            if X > 0 then
              for I := AMapElement.DynTarget.Count - X DownTo 0 do
              begin
                if ((I = (AMapElement.DynTarget.Count - 1)) AND
                    (AMapElement.DynTarget[I].TaxCycleFromRowNo = -1) AND
                     P.IsLastRow)
                   or
                   (TCRowNo >= AMapElement.DynTarget[I].TaxCycleFromRowNo) then
                begin
                  if AMapElement.DynTarget[I].VisualTaxFormName <> '*' then
                    FormName := AMapElement.DynTarget[I].VisualTaxFormName;
                  TCRowNo := TCRowNo - AMapElement.DynTarget[I].TaxCycleFromRowNo;
                  ElementNo := AMapElement.DynTarget[I].VisualTaxStartElementNo + TCRowNo * AMapElement.DynTarget[I].VisualTaxShift;
                  break;
                end;
              end;
          end
          else
          if (AMapElement.Shift > 0) then
            ElementNo := ElementNo + ((AMapElement.GetTableRowNo(P.Path) - 1) * AMapElement.Shift);
        end
        else
        if AMapElement.IsSlipsElement AND AMapElement.UseDynTarget then
        begin
          TCSlipNo := P.SlipNo;
          I := AMapElement.DynTarget.Count - 1;
          for I := AMapElement.DynTarget.Count - 1 DownTo 0 do
          begin
            if (TCSlipNo >= AMapElement.DynTarget[I].TaxCycleFromRowNo) then
            begin
              if AMapElement.DynTarget[I].VisualTaxFormName <> '*' then
                FormName := AMapElement.DynTarget[I].VisualTaxFormName;
              TCSlipNo := TCSlipNo - AMapElement.DynTarget[I].TaxCycleFromRowNo;
              ElementNo := AMapElement.DynTarget[I].VisualTaxStartElementNo + TCSlipNo * AMapElement.DynTarget[I].VisualTaxShift;
              break;
            end;
          end;
        end
        else
        if IsFormMultiInst(FormName) AND (AMapElement.Shift > 0) and AMapElement.GetParentSlipToMultiSlip then
          ElementNo := ElementNo + (((P.SlipNo mod AMapElement.GetNumberOfForms) - 1) * AMapElement.Shift);

        FormNo := FApp.FList.ByFormName(FormName).FormNo;
        if FormNo < 1 then
        begin
          if IsFormMultiInst(FormName) then
          begin
            FormNo := FApp.FList.AddPageInstance(ARetNo,
              vtTrimStr.ExtractNonInstFormName(FormName),
              vtTrimStr.ExtractFormInst(FormName));
          end;
          if FormNo < 1 then
            continue;
        end;

        if FUsedForms.IndexOf(FormName) = -1 then
        begin
          if FUsedForms.Count > 0 then
            PostFillForm(FUsedForms[FUsedForms.Count - 1]);
          FUsedForms.Add(FormName);
          ClearForm(ARetNo, FormName);
          PreFillForm(P, FormName);
        end;
        PreFillElement(FormName, ElementNo, P.ValueAsString);
        case AMapElement.Value.Kind of
          c_Value_AsIs:
            begin
              if ElementNo <> 0 then
                StoreElm(ARetNo, FormNo, ElementNo, P.ValueAsString);
            end;
          c_Value_InDollar:
            begin
              if ElementNo <> 0 then
                StoreElm(ARetNo, FormNo, ElementNo, FormatFloat('0.00', P.DecimalData));
            end;
          c_Value_YesOrNot:
            begin
              if ElementNo <> 0 then
                StoreElm(ARetNo, FormNo, ElementNo, IntToYesOrNot(P.VarLengthData));
            end;
          c_Value_Check:
            begin
              if ElementNo <> 0 then
                StoreElm(ARetNo, FormNo, ElementNo, IntToX(P.VarLengthData));
            end;
          c_Value_RadioGroup:
            begin
              for I := 0 to AMapElement.Value.Transform.Count - 1 do
              begin
                if P.VarLengthData = StrToInt(AMapElement.Value.Transform[I].TaxCycleValue) then
                  StoreElm(ARetNo, FormNo, StrToInt(AMapElement.Value.Transform[I].VisualTaxValue), 'X')
                else
                  StoreElm(ARetNo, FormNo, StrToInt(AMapElement.Value.Transform[I].VisualTaxValue), '');
              end;
            end;
          c_Value_DateTime:
            begin
              if P.DateData <> 0 then
                StoreElm(ARetNo, FormNo, ElementNo, FormatDateTime('YYYY-MM-DD', P.DateData))
              else
                StoreElm(ARetNo, FormNo, ElementNo, '');
            end;
          c_Value_Transform:
            begin
              for I := 0 to AMapElement.Value.Transform.Count - 1 do
              begin
                if P.ValueAsString = AMapElement.Value.Transform[I].TaxCycleValue then
                begin
                  StoreElm(ARetNo, FormNo, ElementNo, AMapElement.Value.Transform[I].VisualTaxValue);
                  Break;
                end;
              end;
            end;
          c_Value_Split:
            begin
              if P.ValueAsString <> '' then
              begin
                X := 1;
                for I := 0 to AMapElement.Value.Transform.Count - 1 do
                begin
                  S := VarToStr(AMapElement.Value.Transform[I].TaxCycleValue);
                  S1 := Copy(S, 1, pos(':', S) - 1);
                  if not TryStrToInt(S1, StrStart) then
                  begin
                    StrStart := StrUtils.PosEx(S1, P.ValueAsString, X) - 1;
                    if StrCount < 0 then
                      Continue;
                  end;
                  S1 := Copy(S, pos(':', S) + 1, MaxInt);
                  if not TryStrToInt(S1, StrCount) then
                  begin
                    StrCount := StrUtils.PosEx(S1, P.ValueAsString, StrStart) - 1;
                    if StrCount < 0 then
                      StrCount := length(P.ValueAsString);
                  end;
                  X := StrStart + StrCount;
                  S := Copy(P.ValueAsString, StrStart, StrCount);
                  StoreElm(ARetNo, FormNo, StrToInt(AMapElement.Value.Transform[I].VisualTaxValue), S);
                end;
              end;
            end;
          c_Value_Percent:
            begin
              if ElementNo <> 0 then
              begin
                StoreElm(ARetNo, FormNo, ElementNo, FormatFloat('0.00', P.DecimalData * 100));
              end;
            end;
          c_Value_Cumulative:
            begin
              if ElementNo <> 0 then
              begin
                StoreElm(ARetNo, FormNo, ElementNo, FormatFloat('0.00', P.DecimalData + VL(FetchElm(ARetNo, FormNo, ElementNo))))
              end;
            end;
          c_Value_Concat:
            begin
              if ElementNo <> 0 then
              begin
                S := FetchElm(ARetNo, FormNo, ElementNo);
                if S <> '' then
                  S := S + ', ';
                StoreElm(ARetNo, FormNo, ElementNo, S + P.ValueAsString);
              end;
            end;
          //20190723 Igor >>>
          c_Value_Extract:
            begin
              if ElementNo <> 0 then
              begin
                S := '';
                for C in P.ValueAsString do
                  if CharInSet(C, ['0','1','2','3','4','5','6','7','8','9','.']) then
                    S := S + C
                  else
                    break;
                StoreElm(ARetNo, FormNo, ElementNo, S);
              end;
            end;
          //20190723 Igor <<<
        end;
      end;
    end;
    DoFill(P.Items, ARetNo, AReplace, AOpen);
    if P.Level = c_LevelReturn then
    begin
      if FUsedForms.Count > 0 then
        PostFillForm(FUsedForms[FUsedForms.Count - 1]);
      for I := 0 to FUsedForms.Count - 1 do
      begin
        RetList[ARetNo].FormHasData[FUsedForms[I]] := True;
        RetList[ARetNo].Calc(ARetNo, FUsedForms[I]);
      end;
      RetList[ARetNo].CalcAll;
      RetList[ARetNo].Changed := True;
      if AOpen then
      begin
        OpenForm(ARetNo, FApp.FirstForm, 0);
        MainForm.GuiCommand(gcRefreshAuditPanel);
        MainForm.GuiCommand(gcFormPaint);
      end
      else
      begin
        TargetFileName := RetList[ARetNo].GetDefaultFileName;
        If not FileExists(IncludeTrailingPathDelimiter(edtTargetPath.Text) + TargetFileName)
           or AReplace then
        begin
          ApplicationState := ApplicationState + [asSilentSave];
          try
            if RetList[ARetNo].DoSave then
              RetList[ARetNo].Close(True)
            else
            begin
              if not TArray.BinarySearch<Integer>(NotSavedReturns, ARetNo, Dummy) then
              begin
                SetLength(NotSavedReturns, length(NotSavedReturns) + 1);
                NotSavedReturns[length(NotSavedReturns) - 1] := ARetNo;
              end;
            end;
          finally
            ApplicationState := ApplicationState - [asSilentSave];
          end;
        end;
      end;
    end;
  end;
end;

function IsComment(ALine: String): Boolean;
begin
  Result := ALine.StartsWith('//');
end;

procedure TfrmTaxCycleUtil.DoFill2(AParam: TParam; AReplace, Aopen: Boolean; ALastYearShift: integer); //20240103 Igor
var
  Map: TMemIniFile;
  WorkRetNo, Dummy: Integer;
  SL, UsedForms: TStringList;
  TargetFileName, S: String;
  StartMapSection: boolean;
  AddYearInc: boolean; //20240103 Igor

  function GetTargetFormName(ASource: TParam; ARule: String; out ATargetFormName: String): Boolean;
  var
    M: TMatch;
    R: Integer;
  begin
    Result := True;
    M := TRegEx.Match(ARule, '\#y[\d]{0,}$', [roIgnoreCase]);
    if M.Success then
    begin
      FCommonSourceParam := ASource;
      if not TryStrToInt(YtoDigit(M), R) then
        exit(false);
      ATargetFormName := copy(ARule, 1, M.Index) + IntToStr(R);
    end
    else
      ATargetFormName := ARule;
  end;

  function GetTargetElementNo(ASource: TParam; ATarget: String; out ATargetElementNo: Integer): Boolean;
  var
    A: TArray<String>;
    TransformList, TransformKey: String;
    P: TParam;
    M:TMatch;
    R: Integer;
  begin
    Result := tryStrToInt(ATarget, ATargetElementNo);
    if Result then
      exit;
    if StartsText('Transform:', ATarget) then
    begin
      A := ATarget.Split([':']);
      if length(A) <= 1 then
        exit(False);
      TransformList := A[1];
      if Length(A) > 2 then
      begin
        TransformKey := A[2];
        if TransformKey.StartsWith('<') and TransformKey.EndsWith('>') then
        begin
          TransformKey := Copy(TransformKey, 2, length(TransformKey) - 2);
          FCommonSourceParam := ASource;
          TransformKey := TRegEx.Replace(TransformKey, '\[Y[\d]{0,}\]', MatchEvaluatorElementNo, [roIgnoreCase]);
          P := AParam.FindChild(TransformKey);
          if P <> nil then
            TransformKey := P.ValueAsString
          else
            TransformKey := '';
        end;
      end
      else
        TransformKey := ASource.ValueAsString;
      Result := TryStrToInt(Map.ReadString(A[0] + ':' + A[1], TransformKey, ''), ATargetElementNo);
    end
    else
    begin
      M := TRegEx.Match(ATarget, '^Y[\d]{0,}:', [roIgnoreCase]);
      if M.Success then
      begin
        FCommonSourceParam := ASource;
        if not TryStrToInt(YtoDigit(M), R) then
          exit(false);
        //20240103 Igor >>>
        if AddYearInc then
          R := R + ALastYearShift;
        //20240103 Igor <<<
        A := copy(ATarget, pos(':', ATarget) + 1, MaxInt).Split([',']);
        Result := (R >= 0) and (R < length(A)) and TryStrToInt(A[R], ATargetElementNo);
      end
      else
        Result := False;
    end

  end;

  function Transform(ASource, AValue: String): String;
  var
    A: TArray<String>;
    S: String;
  begin
    if ASource.StartsWith('[') and ASource.EndsWith(']') then
    begin
      A := copy(ASource, 2, length(ASource) - 2).Split([',']);
      for S in A do
        if StartsText(AValue+'=', S) then
          Exit(copy(S, pos('=', S) + 1, MaxInt));
      Result := '';
    end
    else
      Result := Map.ReadString('Transform:' + ASource, AValue, '');
  end;

  procedure Radio(ASource, AValue: String; out ATargetValue: String; out ATargetElementNo: Integer);
  var
    A: TArray<String>;
    S: String;
  begin
    ATargetValue := '';
    ATargetElementNo := 0;
    if ASource.StartsWith('[') and ASource.EndsWith(']') then
    begin
      A := copy(ASource, 2, length(ASource) - 2).Split([',']);
      for S in A do
        if StartsText(AValue+'=', S) then
        begin
          if TryStrToInt(copy(S, pos('=', S) + 1, MaxInt), ATargetElementNo) then
            ATargetValue := 'X';
          exit;
        end;
    end
    else
    if TryStrToInt(Map.ReadString('Radio:' + ASource, AValue, ''), ATargetElementNo) then
      ATargetValue := 'X';
  end;

  procedure FillElement(AValue: TParam; ARule, AFormName, AElement: String);
  var
    TargetValue, TargetFormName, OneRule: String;
    TargetFormNo, TargetElementNo: Integer;
    C: Char;
    ApplyRule1: Boolean;
  begin
    if not GetTargetFormName(AValue, AFormName, TargetFormName) or
       not GetTargetElementNo(AValue, AElement, TargetElementNo) then
      exit;

    if ARule <> '' then
    begin
      ApplyRule1 := False;
      for OneRule in ARule.Split(['|']) do
      begin
        if SameText('SIN', OneRule) then
        begin
          TargetValue := '';
          for C in AValue.ValueAsString do
            if CharInSet(C, ['0','1','2','3','4','5','6','7','8','9']) then
              TargetValue := TargetValue + C;
          ApplyRule1 := True;
        end
        else
        if SameText('DATE', OneRule) then
        begin
          TargetValue := AValue.ValueAsString;
          ApplyRule1 := True;
        end
        else
        if SameText('INCYEAR', OneRule) then
        begin
          if AValue.DateData <> 0 then
            TargetValue := FormatDateTime('YYYY-MM-DD', IncYear(AValue.DateData))
          else
            TargetValue := '';
          ApplyRule1 := True;
        end
        else
        if SameText('UPPERCASE', OneRule) then
        begin
          TargetValue := AValue.ValueAsString.ToUpper;
          ApplyRule1 := True;
        end
        else
        if SameText('AREA', OneRule) then
        begin
        //20190103 Igor>>>
          TargetValue := AValue.ValueAsString.Substring(0, 3);
        //20190103 Igor<<<
          ApplyRule1 := True;
        end
        else
        if SameText('PHONE', OneRule) then
        begin
        //20190103 Igor>>>
          TargetValue := AValue.ValueAsString.Substring(3, 7);
        //20190103 Igor<<<
          ApplyRule1 := True;
        end
        else
        if StartsText('Transform:', OneRule) then
        begin
          TargetValue := Transform(copy(OneRule, length('Transform:') + 1, MaxInt), AValue.ValueAsString);
          ApplyRule1 := True;
        end
        else
        if StartsText('Radio:', OneRule) then
        begin
          Radio(copy(OneRule, length('Radio:') + 1, MaxInt), AValue.ValueAsString, TargetValue, TargetElementNo);
          ApplyRule1 := True;
        end
        else
        if SameText('X', OneRule) then
        begin
          if AValue.ValueAsString = '1' then
            TargetValue := 'X'
          else
            TargetValue := '';
          ApplyRule1 := True;
        end
        //20190723 Igor >>>
        else if SameText('EXTRACT', OneRule) then
        begin
          TargetValue := '';
          for C in AValue.ValueAsString do
            if CharInSet(C, ['0','1','2','3','4','5','6','7','8','9','.']) then
              TargetValue := TargetValue + C
            else
              break;
          ApplyRule1 := True;
        end
        //20190723 Igor <<<
        else
          TargetValue := AValue.ValueAsString;
        if ApplyRule1 then
          Break;
      end;
    end
    else
      TargetValue := AValue.ValueAsString;
    TargetFormNo := FApp.FList.ByFormName(TargetFormName).FormNo;
    if TargetFormNo < 1 then
    begin
      if IsFormMultiInst(TargetFormName) then
      begin
        TargetFormNo := FApp.FList.AddPageInstance(WorkRetNo,
          vtTrimStr.ExtractNonInstFormName(TargetFormName),
          vtTrimStr.ExtractFormInst(TargetFormName));
      end;
    end;
    if (TargetFormNo > 0) and (TargetElementNo > 0) then
    begin
      UsedForms.Add(TargetFormName);
      for OneRule in ARule.Split(['|']) do
      begin
        if SameText(OneRule, '+') then
          TargetValue := FormatFloat('0.00', VL(TargetValue) + VL(FetchElm(WorkRetNo, TargetFormNo, TargetElementNo)))
        else
        if SameText(OneRule, '%') then
          TargetValue := FormatFloat('0.00', VL(TargetValue) * 100)
        else
        if SameText(OneRule, '&') then
          TargetValue := MyConcat(FetchElm(WorkRetNo, TargetFormNo, TargetElementNo), TargetValue, ', ');
      end;

      StoreElm(WorkRetNo, TargetFormNo, TargetElementNo, TargetValue);
    end;
  end;

  procedure FillLine(ALine: String);
  var
    B: TArray<String>;
    TCPath, VTPath: String;
    L: TParamList;
    P: TParam;
    ElementNo, J: Integer;
  const
    c_note = 0;
    c_Rule = 1;
    c_FormName = 2;
    c_ElementNo = 3;
  begin
    ALine := ALine.Trim;
    //20240103 Igor >>>
    AddYearInc := (Pos('T2FiveYearSummary', ALine) > 0)
                  or
                  (Pos('T15YearSummary', ALine) > 0);
    //20240103 Igor <<<
    if ALine.IsEmpty or IsComment(ALine) then
      exit;
    J := pos('=', ALine);
    if J = 0 then
      exit;
    TCPath := Copy(ALine, 1, J - 1).Trim;
    VTPath := Copy(ALine, J + 1, MaxInt).Trim;
    if TCPath.IsEmpty or VTPath.IsEmpty then
      exit;
    L := AParam.FindChilds(TCPath);
    try
      if (L.Count = 0) then
        Exit;
      B := VTPath.Split(['^']);
      if (Length(B) <> 4) then
        raise Exception.Create('Bad map! Line: "' + ALine + '"');
      for P in L do
        FillElement(P, B[c_Rule], B[c_FormName], B[c_ElementNo]);
    finally
      L.Free;
    end;

  end;

begin
  assert(AParam.Level = c_LevelReturn);
  Assert(FileExists(IncludeTrailingPathDelimiter(FApp.AppDir) + c_TaxCycleMap2));
  if (AParam.VisualTaxReturnNo = 0) or
     not Assigned(RetList[AParam.VisualTaxReturnNo]) or
     (RetList[AParam.VisualTaxReturnNo].Destroying) then
  begin
    WorkRetNo := FApp.InitNewReturn(True);
    if WorkRetNo <= 0 then
      raise Exception.Create('Can''t create new return')
    else
      AParam.VisualTaxReturnNo := WorkRetNo;
  end
  else
    WorkRetNo := AParam.VisualTaxReturnNo;
  UsedForms := TStringList.Create;
  try
    UsedForms.Sorted := True;
    UsedForms.Duplicates := dupIgnore;
    SL := TStringList.Create;
    try
      SL.LoadFromFile(IncludeTrailingPathDelimiter(FApp.AppDir) + c_TaxCycleMap2);
      Map := TMemIniFile.Create(IncludeTrailingPathDelimiter(FApp.AppDir) + c_TaxCycleMap2);
      try
        StartMapSection := False;
        for S in SL do
        begin
          if not StartMapSection AND SameText(S.Trim, '[MAP]') then
            StartMapSection := True
          else
          if StartMapSection AND StartsText('[', S.Trim) then
            break
          else
          if StartMapSection then
            FillLine(S);
        end;
      finally
        Map.Free;
      end;
    finally
      SL.Free;
    end;

    for S in UsedForms do
    begin
      RetList[WorkRetNo].FormHasData[S] := True;
      RetList[WorkRetNo].Calc(WorkRetNo, S);
    end;
    RetList[WorkRetNo].CalcAll;
    RetList[WorkRetNo].Changed := True;
    if AOpen then
    begin
//      for S in UsedForms do
//        OpenForm(WorkRetNo, S, 0);
      OpenForm(WorkRetNo, FApp.FirstForm, 0);
      MainForm.GuiCommand(gcRefreshAuditPanel);
      MainForm.GuiCommand(gcFormPaint);
    end
    else
    begin
      TargetFileName := RetList[WorkRetNo].GetDefaultFileName;
      If not FileExists(IncludeTrailingPathDelimiter(edtTargetPath.Text) + TargetFileName)
         or AReplace then
      begin
        ApplicationState := ApplicationState + [asSilentSave];
        try
          if RetList[WorkRetNo].DoSave then
             RetList[WorkRetNo].Close(True)
          else
          begin
            if not TArray.BinarySearch<Integer>(NotSavedReturns, WorkRetNo, Dummy) then
            begin
              SetLength(NotSavedReturns, length(NotSavedReturns) + 1);
              NotSavedReturns[length(NotSavedReturns) - 1] := WorkRetNo;
            end;
          end;
        finally
          ApplicationState := ApplicationState - [asSilentSave];
        end;
      end;
    end;
  finally
    UsedForms.Free;
  end;
end;

procedure TfrmTaxCycleUtil.DoRollOver(AList: TStrings);
var
  I: Integer;
begin
  TCFiles.Clear;
  lblStageName.Caption := 'Read TaxCycle file(s)';
  lblStageName.Repaint;
  for I := 0 to AList.Count - 1 do
  begin
    lblCurrOfTotal.Caption := IntToStr(I + 1) + ' of ' + IntToStr(AList.Count);
    lblCurrOfTotal.Repaint;
    RollOverOne(AList[I]);
  end;
  lblStageName.Caption := 'done';
end;

procedure TfrmTaxCycleUtil.BitBtn1Click(Sender: TObject);
begin
  PageControl1.ActivePage := tsMap;
end;

procedure TfrmTaxCycleUtil.BitBtn2Click(Sender: TObject);
begin
  if lvDynTarget.Tag > 0 then
    FillDynTarget;
  PageControl1.ActivePage := tsMap;
end;

procedure TfrmTaxCycleUtil.BitBtn3Click(Sender: TObject);
var
  I: Integer;
begin
  SetLength(FDynTargetBuf, 0);
  for I := 0 to lvDynTarget.Items.Count - 1 do
  begin
    SetLength(FDynTargetBuf, length(FDynTargetBuf) + 1);
    with FDynTargetBuf[length(FDynTargetBuf) - 1] do
    begin
      TCFromRowNo := StrToInt(lvDynTarget.Items[I].Caption);
      VTFormName := lvDynTarget.Items[I].SubItems[0];
      VTFromElementNo := StrToInt(lvDynTarget.Items[I].SubItems[1]);
      VTShift := StrToInt(lvDynTarget.Items[I].SubItems[2]);
    end;
  end;
end;

procedure TfrmTaxCycleUtil.BitBtn4Click(Sender: TObject);
var
  I: TDynTargetRec;
begin
  lvDynTarget.Clear;
  for I in FDynTargetBuf do
  begin
    with lvDynTarget.Items.Add do
    begin
      Caption := I.TCFromRowNo.ToString;
      SubItems.Add(I.VTFormName);
      SubItems.Add(I.VTFromElementNo.ToString);
      SubItems.Add(I.VTShift.ToString);
    end;
  end;
end;

procedure TfrmTaxCycleUtil.btnConvertClick(Sender: TObject);
begin
  if FMapElementChanged then
    SaveMapElement;
  DoConvertAll;
end;

procedure TfrmTaxCycleUtil.btnDynTargetClick(Sender: TObject);
begin
  PageControl1.ActivePage := tsDynTarget;
end;

procedure TfrmTaxCycleUtil.DoConvertAll;
var
  OldDecimalSeparator: Char;
  TC: TTaxCycleFile;
  P: TParam;
  R: Integer;

begin
  lbNotSavedReturns.Clear;
  lblStageName.Caption := 'Convert to VT return(s)';
  lblStageName.Repaint;
  OldDecimalSeparator := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';
  try
    FUsedForms := TStringList.Create;
    try
      FUsedForms.Sorted := True;
      FUsedForms.Duplicates := dupIgnore;
      R := 1;
      for TC in TCFiles do
      begin
        lblCurrOfTotal.Caption := IntToStr(R) + ' of ' + IntToStr(TCFiles.Count);
        lblCurrOfTotal.Repaint;
        inc(R);
        FUsedForms.Clear;
        //DoFill(TC.Params, 0, ReplaceOptionBox.ItemIndex = 0, SaveOrOpenOptionBox.ItemIndex = 0);
        for P in TC.Params do
          DoFill2(P, ReplaceOptionBox.ItemIndex = 0, SaveOrOpenOptionBox.ItemIndex = 0, CurrAppYear - TC.CurrYear); //20240103 Igor
      end;
      lblStageName.Caption := 'Convert done';
      lblStageName.Repaint;
    finally
      FreeAndNil(FUsedForms);
    end;
  finally
    FormatSettings.DecimalSeparator := OldDecimalSeparator;
  end;
  if length(NotSavedReturns) > 0 then
  begin
    MessageDlg('Some returns were not saved due to errors in mandatory fields. '+
               'They will be open in memory. Please correct they and save manually.',
      mtWarning, [mbOk], 0);
    for R in NotSavedReturns do
      if (RetList[R] <> nil) and not RetList[R].Destroying then
        lbNotSavedReturns.Items.AddObject(RetList[R].GetReturnCaption, TObject(R));
  end;
end;

procedure TfrmTaxCycleUtil.btnMappingModeClick(Sender: TObject);
begin
  FMappingMode := Not FMappingMode;
  if FMappingMode then
  begin
    btnMappingMode.Caption := 'Make map';
    vtnosplash.AdoptMe(Self, [FApp.AppId], []);//20170727 Igor
    PageControl1.ActivePageIndex := 1;
    FOriginalActiveControlChanged := Screen.OnActiveControlChange;
    Screen.OnActiveControlChange := ActiveControlChanged;
  end
  else
  begin
    btnMappingMode.Caption := 'Mapping mode';
    vtnosplash.UnAdoptMe(Self);
    PageControl1.ActivePageIndex := 0;
    SaveMap;
    Screen.OnActiveControlChange := FOriginalActiveControlChanged;
  end;
end;

procedure TfrmTaxCycleUtil.btnPhoneClick(Sender: TObject);
begin
  veTransform.Strings.Clear;
  veTransform.Strings.Text :=
    '1:3=?' + #13#10 +
    '4:7=?' + #13#10 +
    '11:3=?';
end;

procedure TfrmTaxCycleUtil.btnReadCurrentClick(Sender: TObject);
var
  I: Integer;
  SL: TStringList;
begin
  //20180122 Igor >>>
  if flbMain.SelCount = 0 then
  begin
    ShowMessage('Please select one or more files first');
    Exit;
  end;
  //20180122 Igor <<<
  SL := TStringList.Create;
  try
    if Sender = btnReadCurrent then
    begin
      if flbMain.ItemIndex = -1 then
        exit;
      SL.Add(IncludeTrailingPathDelimiter(edtSourcePath.Text) + flbMain.Items[flbMain.ItemIndex]);
    end
    else
    if Sender = btnReadSelected then
    begin
      lblCurrOfTotal.Caption := '0 of 1';
      for I := 0 to flbMain.Count - 1 do
        if flbMain.Selected[I] then
          SL.Add(IncludeTrailingPathDelimiter(edtSourcePath.Text) + flbMain.Items[I]);
    end
    else
    if Sender = btnReadAll then
    begin
      for I := 0 to flbMain.Count - 1 do
        SL.ADD(IncludeTrailingPathDelimiter(edtSourcePath.Text) + flbMain.Items[I]);
    end
    else
    if Sender = btnRolloverSelected then
    begin
      for I := 0 to flbMain.Count - 1 do
        if flbMain.Selected[I] then
          SL.Add(IncludeTrailingPathDelimiter(edtSourcePath.Text) + flbMain.Items[I]);
    end;
    DoRollOver(SL);
    if DevelopMode then
      SyncronizeTree;
    if Sender = btnRolloverSelected then
    begin
      DoConvertAll;
      if not DevelopMode AND (lbNotSavedReturns.Count = 0) then
        Close;
    end;
  finally
    SL.Free;
  end;
end;

procedure TfrmTaxCycleUtil.btnSaveMapElementClick(Sender: TObject);
begin
  SaveMapElement;
end;

procedure TfrmTaxCycleUtil.btnFillProvinceClick(Sender: TObject);
begin
  veTransform.Strings.Clear;
  if Sender = btnFillProvince then
    veTransform.Strings.Text :=
      'Alberta=AB' + #13#10 +
      'British Columbia=BC' + #13#10 +
      'Manitoba=MB' + #13#10 +
      'New Brunswick=NB' + #13#10 +
      'Newfoundland and Labrador=NL' + #13#10 +
      'Northwest Territories=NT' + #13#10 +
      'Nova Scotia=NS' + #13#10 +
      'Nunavut=NU' + #13#10 +
      'Ontario=ON' + #13#10 +
      'Prince Edward Island=PE' + #13#10 +
      'Quebec=QC' + #13#10 +
      'Saskatchewan=SK' + #13#10 +
      'Yukon=YT'
  else
  if Sender = btnFillProvince2 then
    veTransform.Strings.Text :=
      '1=Alberta' + #13#10 +
      '2=British Columbia' + #13#10 +
      '3=Manitoba' + #13#10 +
      '4=New Brunswick' + #13#10 +
      '5=Newfoundland and Labrador' + #13#10 +
      '6=Northwest Territories' + #13#10 +
      '7=Nova Scotia' + #13#10 +
      '8=Nunavut' + #13#10 +
      '9=Ontario' + #13#10 +
      '10=Prince Edward Island' + #13#10 +
      '11=Quebec' + #13#10 +
      '12=Saskatchewan' + #13#10 +
      '13=Yukon'
  else
  if Sender = btnFillProvince3 then
    veTransform.Strings.Text :=
      '1=AB' + #13#10 +
      '2=BC' + #13#10 +
      '3=MB' + #13#10 +
      '4=NB' + #13#10 +
      '5=NL' + #13#10 +
      '6=NT' + #13#10 +
      '7=NS' + #13#10 +
      '8=NU' + #13#10 +
      '9=ON' + #13#10 +
      '10=PE' + #13#10 +
      '11=QC' + #13#10 +
      '12=SK' + #13#10 +
      '13=YT';
end;

procedure TfrmTaxCycleUtil.btnGenerateDFileClick(Sender: TObject); //20190730 Igor
var L: TStringList;
    Node: TTreeNode;
    cValue, cGroup: string;
begin
  L := TStringList.Create;
  try
    cGroup := '';
    for Node in TreeView1.Items do
      if Node.Data <> nil then
      begin
        if Node.HasChildren then continue;
        cValue := TParam(Node.Data).Fullname;
        cValue := Copy(cValue, Pos('.', cValue) + 1, Length(cValue));
        if Pos('.', cValue) = 0 then continue;
        cValue := ReplaceStr(cValue, '.Table row #0', '[y]');
        if Pos('.Table row #', cValue) > 0 then continue;
        if cGroup <> Copy(cValue, 1, Pos('.', cValue) - 1) then
        begin
          cGroup := Copy(cValue, 1, Pos('.', cValue) - 1);
          L.Add('');
          L.Add('// '+ cGroup);
          L.Add('');
        end;
        L.Add(cValue);
      end;
    L.SaveToFile(IncludeTrailingPathDelimiter(FApp.AppDir) + c_TaxCycleD);
  finally
    L.Free;
  end;
end;

procedure TfrmTaxCycleUtil.ClearMapPanel;
begin
  edTaxCyclePath.Text := '';
  edVisualTaxFormName.Text := '';
  edVisualTaxElementNo.Value := 0;
  rgValue.ItemIndex := 0;
  edtShift.Value := 0;
  chbSlipToMuliSlip.Checked := False;
  veTransform.Strings.Clear;
  lvDynTarget.Clear;
  FMapElementChanged := False;
  imgSlip.Visible := False;
  imgTableRow.Visible := False;
  chbSkipLastRow.Checked := False;
  chbSkipLastRow.Enabled := False;
  chbUseDynTarget.Enabled := False;
  chbUseDynTarget.Checked := False;
  btnDynTarget.Enabled := False;
  edVisualTaxFormName.Enabled := True;
  edVisualTaxElementNo.Enabled := True;
  rgValue.Enabled := True;
  veTransform.Enabled := True;
  chbSlipToMuliSlip.Enabled := False;
  lblNumberOfForms.Enabled := False;
  edtNumberOfForms.Enabled := False;
end;

procedure TfrmTaxCycleUtil.edTaxCyclePathChange(Sender: TObject);
begin
  FMapElementChanged := True;
  btnFillProvince.Enabled := rgValue.ItemIndex = c_Value_Transform;
end;

procedure TfrmTaxCycleUtil.edtSourcePathChange(Sender: TObject);
begin
  if System.SysUtils.DirectoryExists(edtSourcePath.Text) then
  begin
    flbMain.Directory := edtSourcePath.Text;
    flbMain.Update;
  end
  else
    flbMain.Clear;
end;

procedure TfrmTaxCycleUtil.FillDynTarget;
var
  E: IXMLElementType;
  I: Integer;
  P: TParam;
begin
  if edTaxCyclePath.Text = '' then
    exit;
  if TreeView1.Selected = nil then
    exit;
  P := TParam(TreeView1.Selected.Data);
  E := XMLMap.Elements.ElementByTaxCyclePath(edTaxCyclePath.Text);
  lvDynTarget.Clear;
  for I := 0 to E.DynTarget.Count - 1 do
  begin
    with lvDynTarget.Items.Add do
    begin
      Caption := E.DynTarget[I].TaxCycleFromRowNo.ToString;
      SubItems.Add(E.DynTarget[I].VisualTaxFormName);
      SubItems.Add(E.DynTarget[I].VisualTaxStartElementNo.ToString);
      SubItems.Add(E.DynTarget[I].VisualTaxShift.ToString);
    end;
  end;
  lvDynTarget.Tag := 0;
end;

procedure TfrmTaxCycleUtil.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmTaxCycleUtil.FormCreate(Sender: TObject);
begin
  TCFiles := TObjectList<TTaxCycleFile>.Create(True);
  IsDeveloper := false; //20180122 Igor
end;

procedure TfrmTaxCycleUtil.FormDestroy(Sender: TObject);
begin
  TreeView1.Items.Clear;
  FreeAndNil(TCFiles);
  FreeAndNil(FGroups);
end;

procedure TfrmTaxCycleUtil.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl, ssShift]) and (Key = VK_F2) then
    DevelopMode := Not DevelopMode;
end;

procedure TfrmTaxCycleUtil.Init;
var
  I: Integer;
begin
  DevelopMode := False;
  for I := 0 to PageControl1.PageCount - 1 do
    PageControl1.Pages[I].TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  with FApp.GetOptions do
    try
      edtSourcePath.Text := Values['Dir_LastYr'];
    finally
      Free;
    end;
  edtTargetPath.Text := FApp.Dir_Cur;
  cbFileExt.Items.AddStrings(FFileExt.Split([';',',',' ']));
  cbFileExt.Items.Add('*.*');
  cbFileExt.ItemIndex := 0;
  cbFileExtChange(nil);
  //edtPathChange(nil);
  FMappingMode := False;
  if FileExists(IncludeTrailingPathDelimiter(FApp.AppDir) + c_TaxCycleMap) then
    XMLMap := LoadTaxCycleMap(IncludeTrailingPathDelimiter(FApp.AppDir) + c_TaxCycleMap)
  else
    XMLMap := NewTaxCycleMap;

  FGroups := TvtGroups.Create(FApp);
end;

procedure TfrmTaxCycleUtil.LinkToOptionsLblClick(Sender: TObject);
begin
  Close;
  PostMessage(Application.MainForm.Handle, UM_EXECUTEFORM, NativeUInt(FApp.AppIdx), EF_OPTIONS);
end;

procedure TfrmTaxCycleUtil.lbNotSavedReturnsDblClick(Sender: TObject);
var
  R: Integer;
begin
  if lbNotSavedReturns.ItemIndex >= 0 then
  begin
    R := Integer(lbNotSavedReturns.Items.Objects[lbNotSavedReturns.ItemIndex]);
    if RetList[R] = nil then
    begin
      lbNotSavedReturns.Items.Delete(lbNotSavedReturns.ItemIndex);
      exit;
    end;
    OpenForm(R, FApp.FirstForm, 0);
    MainForm.GuiCommand(gcRefreshAuditPanel);
    MainForm.GuiCommand(gcFormPaint);
  end;
end;

procedure TfrmTaxCycleUtil.lvDynTargetChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  lvDynTarget.Tag := 1;
end;

procedure TfrmTaxCycleUtil.lvDynTargetSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected and Assigned(Item) then
  begin
    edTCFromRowNo.Value := StrToInt(Item.Caption);
    edvtFormName.Text := Item.SubItems[0];
    edVTFromElementNo.Value := StrToInt(Item.SubItems[1]);
    edVTShift.Value := StrToInt(Item.SubItems[2]);
  end
  else
  begin
    edTCFromRowNo.Value := 0;
    edvtFormName.Text := '';
    edVTFromElementNo.Value := 0;
    edVTShift.Value := 0;
  end;
end;

function TfrmTaxCycleUtil.MatchEvaluatorElementNo(const Match: TMatch): string;
var
  S: String;
begin
  S := YtoDigit(Match);
  if S <> '' then
    Result := '[' + S + ']'
  else
    Result := Match.Value;
end;

procedure TfrmTaxCycleUtil.mniClearLinkClick(Sender: TObject);
var
  P: TParam;
  E: IXMLElementType;
begin
  if treeView1.Selected = nil then
    exit;
  if treeView1.Selected.Data = nil then
    exit;
  P := TParam(treeView1.Selected.Data);
  E := XMLMap.Elements.FindElementByTaxCyclePath(P.Path);
  if E = nil then
    exit;
  XMLMap.Elements.Remove(E);
  TreeView1.Selected.StateIndex := -1;
  ClearMapPanel;
  UpdateMapPanel(P);
end;

function TfrmTaxCycleUtil.RollOverOne(AFileName: String): Boolean;
var
  TC: TTaxCycleFile;
begin
  TreeView1.Items.Clear;
  for TC in TCFiles do
    if SameText(TC.SourceFileName, AFileName) then
    begin
      TCFiles.Remove(TC);
      break;
    end;
  TC := TTaxCycleFile.Create;
  TC.CurrYear := CurrAppYear; //20240103 Igor
  TCFiles.Add(TC);
  Result := TC.LoadFromFile(AFileName);
end;

procedure TfrmTaxCycleUtil.SaveMap;
begin
  XMLMap.SaveToFile(IncludeTrailingPathDelimiter(FApp.AppDir) + c_TaxCycleMap);
end;

procedure TfrmTaxCycleUtil.SaveMapElement;
var
  E: IXMLElementType;
  I, TCRowNo, VTElementNo, VTShift: Integer;
  P: TParam;
begin
  if edTaxCyclePath.Text = '' then
    exit;

  if TreeView1.Selected = nil then
    exit;
  P := TParam(TreeView1.Selected.Data);
  E := XMLMap.Elements.ElementByTaxCyclePath(edTaxCyclePath.Text);
  E.VisualTaxPath.FormName := edVisualTaxFormName.Text;
  if P.Level in [c_LevelValue, c_LevelRowValue] then
  begin
    E.Value.Kind := rgValue.ItemIndex;
    E.VisualTaxPath.ElementNo := edVisualTaxElementNo.Value;
    E.Shift := edtShift.Value;
    E.UseDynTarget := chbUseDynTarget.Checked;
    E.SkipLastRow := chbSkipLastRow.Checked;
    for I := E.Value.Transform.Count - 1 downto 0 do
      E.Value.Transform.Delete(I);
    for I := 1 to veTransform.RowCount - 1 do
    begin
      if veTransform.Keys[I] = '' then
        continue;
      with E.Value.Transform.Add do
      begin
        TaxCycleValue := veTransform.Keys[I];
        VisualTaxValue := veTransform.Cells[1, I];
      end;
    end;
    for I := E.DynTarget.Count - 1 downto 0 do
      E.DynTarget.Delete(I);
    for I := 0 to lvDynTarget.Items.Count - 1 do
    begin
      if not tryStrToInt(lvDynTarget.Items[I].Caption, TCRowNo) or
         (lvDynTarget.Items[I].SubItems[0] = '') or
         not tryStrToInt(lvDynTarget.Items[I].SubItems[1], VTElementNo) or
         not tryStrToInt(lvDynTarget.Items[I].SubItems[2], VTShift) then
      begin
        PageControl1.ActivePage := tsDynTarget;
        MessageDlg('Bad configuration!', mtError, [mbOk], 0);
        exit;
      end;
      with E.DynTarget.Add do
      begin
        TaxCycleFromRowNo := TCRowNo;
        VisualTaxFormName := lvDynTarget.Items[I].SubItems[0];
        VisualTaxStartElementNo := VTElementNo;
        VisualTaxShift := VTShift;
      end;
    end;
  end
  else
  if P.Level in [c_LevelSlipGroup] then
  begin
    E.SlipToMuliSlip := chbSlipToMuliSlip.Checked;
    E.NumberOfForms := edtNumberOfForms.Value;
  end;
  TreeView1.Selected.StateIndex := 8;
  FMapElementChanged := False;
  lvDynTarget.Tag := 0;
end;

procedure TfrmTaxCycleUtil.SetDevelopMode(const Value: Boolean);
begin
  FDevelopMode := Value;
  pnlToolsDeveloper.Visible := FDevelopMode;
  pnlTree.Visible := FDevelopMode;
  Splitter1.Visible := FDevelopMode;
  Splitter1.Top := 0;
end;

procedure TfrmTaxCycleUtil.btnDynMapAddClick(Sender: TObject);
begin
  with lvDynTarget.Items.Add do
  begin
    Caption := edTCFromRowNo.Value.ToString;
    SubItems.Add(edvtFormName.Text);
    SubItems.Add(edVTFromElementNo.Value.ToString);
    SubItems.Add(edVTShift.Value.ToString);
  end;
  lvDynTarget.ItemIndex := lvDynTarget.Items.Count - 1;
end;

procedure TfrmTaxCycleUtil.btnDynMapApplyClick(Sender: TObject);
begin
  if lvDynTarget.Items.Count = 0 then
    btnDynMapAddClick(btnDynMapAdd)
  else
  begin
    with lvDynTarget.ItemFocused do
    begin
      Caption := edTCFromRowNo.Value.ToString;
      SubItems.Clear;
      SubItems.Add(edvtFormName.Text);
      SubItems.Add(edVTFromElementNo.Value.ToString);
      SubItems.Add(edVTShift.Value.ToString);
    end;
  end;
end;

procedure TfrmTaxCycleUtil.btnDynMapDeleteClick(Sender: TObject);
begin
  if lvDynTarget.ItemFocused <> nil then
    lvDynTarget.DeleteSelected;
end;

function TfrmTaxCycleUtil.NextNode(ANode: TTreeNode; ADown: Boolean): TTreeNode;
begin
  if ANode = nil then
    Exit(nil);
  if ADown then
  begin
    if ANode.getFirstChild <> nil then
      Exit(ANode.getFirstChild)
    else
    if ANode.getNextSibling <> nil then
      Exit(ANode.getNextSibling)
    else
    if ANode.Parent <> nil then
    begin
      ANode := ANode.Parent;
      while ANode <> nil do
      begin
        if ANode.getNextSibling <> nil then
          exit(ANode.getNextSibling);
        ANode := ANode.Parent;
      end;
    end;
  end
  else
  begin
    if ANode.GetLastChild <> nil then
      Exit(ANode.GetLastChild)
    else
    if ANode.getPrevSibling <> nil then
      Exit(ANode.getPrevSibling)
    else
    if ANode.Parent <> nil then
    begin
      ANode := ANode.Parent;
      while ANode <> nil do
      begin
        if ANode.getPrevSibling <> nil then
          exit(ANode.getPrevSibling);
        ANode := ANode.Parent;
      end;
    end;
  end;
  Result := nil;
end;

procedure TfrmTaxCycleUtil.btnSearchNextClick(Sender: TObject);
var
  N: TTreeNode;
  S: String;
begin
  if edtSearch.Text = '' then
    exit;
  S := LowerCase(edtSearch.Text);
  N := TreeView1.Selected;
  if N = nil then
    N := TreeView1.Items.GetFirstNode
  else
    N := NextNode(N, True);
  while Assigned(N) do
  begin
    if N.Text.ToLower.Contains(S) then
    begin
      TreeView1.Selected := N;
      N.Focused := True;
      exit;
    end;
    N := NextNode(N, True);
  end;
end;

procedure TfrmTaxCycleUtil.btnSearchPriorClick(Sender: TObject);
var
  N: TTreeNode;
  S: String;
begin
  if edtSearch.Text = '' then
    exit;
  S := LowerCase(edtSearch.Text);
  N := TreeView1.Selected;
  if N = nil then
  begin
    N := TreeView1.Items.GetFirstNode;
    while Assigned(N) AND (N.GetNextSibling <> nil) do
      N := N.GetNextSibling;
  end
  else
    N := NextNode(N, False);
  while Assigned(N) do
  begin
    if N.Text.ToLower.Contains(S) then
    begin
      TreeView1.Selected := N;
      N.Focused := True;
      exit;
    end;
    N := NextNode(N, False);
  end;
end;

procedure TfrmTaxCycleUtil.btnSelectTaxCycleDirClick(Sender: TObject);
var
  S: String;
begin
  S := edtSourcePath.Text;
  if not SelectDirectory(S, [], 0) then
    exit;
  if Sender = btnSelectTaxCycleDir then
    edtSourcePath.Text := S
  else
  if Sender = btnSelectVTDir then
    edtTargetPath.Text := S
end;

procedure TfrmTaxCycleUtil.cbDeveloperModeClick(Sender: TObject); //20180122 Igor
var cPassword: string;
begin
  try
    if (Sender as TCheckBox).Checked then
    begin
      if not IsDeveloper then
      begin
        cPassword := '';
        if not InputQuery('Enter password', 'Password', cPassword) then Exit;
        IsDeveloper := SameText(cPassword, 'Igor');
      end;
    end;
  finally
    if (Sender as TCheckBox).Checked and not IsDeveloper then
      (Sender as TCheckBox).Checked := false
    else
      DevelopMode := (Sender as TCheckBox).Checked;
  end;
end;

procedure TfrmTaxCycleUtil.cbFileExtChange(Sender: TObject);
begin
  flbMain.Mask := '*'+cbFileExt.Text;
end;

procedure TfrmTaxCycleUtil.chbUseDynTargetClick(Sender: TObject);
begin
  btnDynTarget.Enabled := chbUseDynTarget.Checked;
  FMapElementChanged := True;
end;

procedure TfrmTaxCycleUtil.SyncronizeTree;
var
  TC: TTaxCycleFile;
begin
  TreeView1.Items.BeginUpdate;
  try
    for TC in TCFiles do
      TC.ExportToTree(TreeView1, XMLMap);
  finally
    TreeView1.Items.EndUpdate;
  end;
end;

procedure TfrmTaxCycleUtil.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if not Assigned(Node) or (Node.Data = nil) then
  begin
    mmoNodeData.Clear;
    if FMappingMode then
      ClearMapPanel;
  end
  else
  begin
    mmoNodeData.Lines.Text := TParam(Node.Data).FullDescription;
    if FMappingMode then
      UpdateMapPanel(TParam(Node.Data));
  end;
end;

procedure TfrmTaxCycleUtil.TreeView1Changing(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  if FMappingMode and (FMapElementChanged or (lvDynTarget.Tag > 0)) then
  begin
    case MessageDlg('Current map element has bin changed. Save changes?',
                    mtConfirmation, mbYesNoCancel, 0) of
      mrYes: SaveMapElement;
      mrNo:;
      mrCancel: AllowChange := False;
    end;
  end;
end;

procedure TfrmTaxCycleUtil.UpdateMapPanel(AParam: TParam);
var
  E: IXMLElementType;
  I: Integer;
begin
  ClearMapPanel;
  if AParam = nil then
    exit;
  if AParam.Level in [c_LevelValue, c_LevelRowValue] then
  begin
    E := XMLMap.Elements.ElementByTaxCyclePath(AParam.Path);
    edTaxCyclePath.Text := E.TaxCyclePath;
    imgSlip.Visible := E.IsSlipsElement;
    imgTableRow.Visible := E.isTableRowElement;
    edtShift.Enabled := imgSlip.Visible or imgTableRow.Visible;
    chbUseDynTarget.Enabled := imgSlip.Visible or imgTableRow.Visible;
    chbUseDynTarget.Checked := E.UseDynTarget;
    btnDynTarget.Enabled := chbUseDynTarget.Checked;
    chbSkipLastRow.Checked := E.SkipLastRow;
    chbSkipLastRow.Enabled := imgTableRow.Visible;

    edVisualTaxFormName.Text := E.VisualTaxPath.FormName;
    edVisualTaxElementNo.Value := E.VisualTaxPath.ElementNo;
    rgValue.ItemIndex := E.Value.Kind;
    for I := 0 to E.Value.Transform.Count - 1 do
    begin
      veTransform.Values[VarToStr(E.Value.Transform.TransformItem[I].TaxCycleValue)] :=
        E.Value.Transform.TransformItem[I].VisualTaxValue;
    end;
    FillDynTarget;
    edtShift.Value := E.Shift;
    FMapElementChanged := False;
    if (GetCurrentRetNo > 0) and
       Assigned(RetList[GetCurrentRetNo]) and
       not RetList[GetCurrentRetNo].Destroying and
       (E.VisualTaxPath.FormName <> '') and
       (E.VisualTaxPath.ElementNo <> 0) then
      OpenForm(GetCurrentRetNo, E.VisualTaxPath.FormName, E.VisualTaxPath.ElementNo);
  end
  else
  if AParam.Level in [c_LevelSlipGroup] then
  begin
    E := XMLMap.Elements.ElementByTaxCyclePath(AParam.Path);
    edTaxCyclePath.Text := E.TaxCyclePath;
    imgSlip.Visible := E.IsSlipsElement;
    edtShift.Enabled := False;
    edVisualTaxFormName.Enabled := False;
    edVisualTaxElementNo.Enabled := False;
    rgValue.Enabled := False;
    veTransform.Enabled := False;
    chbSkipLastRow.Checked := False;
    chbSkipLastRow.Enabled := False;
    chbSlipToMuliSlip.Enabled := True;
    lblNumberOfForms.Enabled := True;
    edtNumberOfForms.Enabled := True;
    chbSlipToMuliSlip.Checked := E.SlipToMuliSlip;
    edtNumberOfForms.Value := E.NumberOfForms;
    edtShift.Value := E.Shift;
    FMapElementChanged := False;
  end;
end;

procedure TfrmTaxCycleUtil.veTransformValidate(Sender: TObject; ACol,
  ARow: Integer; const KeyName, KeyValue: string);
begin
  FMapElementChanged := True;
end;

function TfrmTaxCycleUtil.YtoDigit(const Match: TMatch): String;
var
  S: String;
  Level, J: Integer;
  L: TObjectList<TParam>;
  P: TParam;
begin
  if FCommonSourceParam = nil then
    exit(Match.Value);
  S := TRegEx.Match(Match.Value, '[\d]{1,}', [roIgnoreCase]).Value;
  if Not TryStrToInt(S, Level) then
    Level := 0;
  P := FCommonSourceParam;
  L := TObjectList<TParam>.Create(False);
  try
    while Assigned(P) AND (P.Level > c_LevelReturn) do
    begin
      L.Insert(0, P);
      if P.Parent <> nil then
        P := P.Parent.OwnerParam
      else
        P := nil;
    end;
    J := -1;
    for P in L do
    begin
      if P.Level in [c_LevelSlipGroup, c_LevelTableLine] then
        inc(J);
      if J = Level then
      begin
        if P.Level = c_LevelSlipGroup then
          exit(P.SlipNo.ToString)
        else
          exit(P.RowNumber.ToString)
      end;
    end;
  finally
    L.Free;
  end;
  Result := '';
end;

{ TTaxCycleFile }

constructor TTaxCycleFile.Create;
begin
  inherited Create;
  FParams := TParamList.Create(False);
  FParams.OwnerParam := nil;
end;

destructor TTaxCycleFile.Destroy;
begin
  FreeAndNil(FBPart1);
  FreeAndNil(FParams);
  inherited;
end;

procedure toBits(AByte: Byte; var ABits: String);
var
  I: Integer;
begin
  for I := 0 to 6 do
    if AByte and (1 shl I) <> 0 then
      ABits := '1' + ABits
    else
      ABits := '0' + ABits;
end;

function BitsToInt(ABits: String): Integer;
var
  I: Integer;
  iValueSize: Integer;
begin
  Result := 0;
  iValueSize := Length(ABits);
  for i := iValueSize downto 1 do
    if ABits[i] = '1' then
      Result := Result + (1 shl (iValueSize - i));
end;

procedure ReadVariableLengthField(AStream: TStream; var Len4: Integer);
var
  B: TBytes;
  Len1: Byte;
  I: Integer;
  Bits: String;
begin
  SetLength(B, 5);
  ZeroMemory(@B[0], 5);
  for I := 0 to 4 do
  begin
    AStream.ReadData(Len1);
    B[I] := Len1;
    if Len1 < $80 then
      break;
  end;
  Bits := '';
  for I := 0 to 4 do
    if B[I] > 0 then
      toBits(B[I], Bits)
    else
      break;
  Len4 := BitsToInt(Bits);
end;

function TTaxCycleFile.DoLoadFromStream(AStream: TStream): Boolean;

var
  ReadSlips: Boolean;
  AllForms: TDictionary<String, Integer>;

  function ReadHeader: Boolean;
  var
    B: TBytes;
    Len2: Word;
    Len1: Byte;
    Len4: Integer;
  begin
    try
      AStream.ReadData(FFileversion);
      if FFileversion > 0 then
      begin
        AStream.ReadData(Len1);
        if Len1 = 1 then
        begin
          ReadVariableLengthField(AStream, Len4);
          SetLength(B, Len4);
          AStream.Read(B, Len4);
          HeaderComment := StringOf(B);
        end;
      end;
      AStream.Position := AStream.Position + 1;
      AStream.ReadData(Len1);
      SetLength(B, Len1);
      AStream.Read(B, Len1);
      Vendor := StringOf(B);
      Result := Vendor = 'TaxCycle';
      if not Result then
        exit;
      AStream.ReadData(FHeaderComment2Type);
      //20181228 Igor >>>
      if Fileversion >= $18 then
      //20181228 Igor <<<
      begin
        AStream.ReadData(Len1);
        if Len1 = 1 then
        begin
          ReadVariableLengthField(AStream, Len4);
          SetLength(B, Len4);
          AStream.Read(B, Len4);
          HeaderComment2 := StringOf(B);
        end;
      end;
      AStream.Position := AStream.Position + 1;
    except ON E: Exception DO
      Result := False;
    end;
  end;

  procedure ReadPart1;
  var
    B: TBytes;
    len4: Integer;
    ZStream: TZDecompressionStream;
    BStream: TBytesStream;
  begin
    AStream.ReadData(Len4);
    SetLength(B, Len4);
    AStream.Read(B, Len4);
    BStream := TBytesStream.Create(B);
    try
      BStream.Position := 0;
      ZStream := TZDecompressionStream.Create(BStream, 31);
      try
        FBPart1 := TBytesStream.Create;
        FBPart1.CopyFrom(ZStream, 0);
        FBPart1.Position := 0;
      finally
        ZStream.Free;
      end;
    finally
      BStream.Free;
    end;
  end;

  procedure ReadPart2;
  var
    len4: Integer;
    ZStream: TZDecompressionStream;
    BStream, BStreamPart: TBytesStream;
    MStream: TMemoryStream;
    B: TBytes;
    PartNo: Integer;
  begin
    SetLength(FUnknownSection, 35);
    AStream.Read(FUnknownSection, 35);
    AStream.ReadData(Len4);
    SetLength(B, Len4);
    AStream.Read(B, Len4);
    BStream := TBytesStream.Create(B);
    try
      SetLength(SubParts2, 0);
      BStream.Position := 0;
      PartNo := -1;
      while (BStream.Position + 4) < BStream.Size do
      begin
        inc(PartNo);
        SetLength(SubParts2, PartNo + 1);
        BStream.ReadData(Len4);
        SetLength(B, Len4);
        BStream.Read(B, Len4);
        BStreamPart := TBytesStream.Create(B);
        try
          BStreamPart.Position := 0;
          ZStream := TZDecompressionStream.Create(BStreamPart, 31);
          ZStream.Position := 0;
          try
            MStream := TMemoryStream.Create;
            try
              MStream.CopyFrom(ZStream, 0);
              MStream.Position := 0;
              SetLength(SubParts2[PartNo], MStream.Size);
              MStream.Read(SubParts2[PartNo], MStream.Size)
            finally
              MStream.Free;
            end;
          finally
            ZStream.Free;
          end;
        finally
          BStreamPart.Free;
        end;
      end;
    finally
      BStream.Free;
    end;
  end;




  procedure ReadValue(AStream: TStream; AParam: TParam);
  var
    Len1, SubLen1: Byte;
    StrLen: Integer;
    B: TBytes;
    W: Word;
  begin
    case AParam.FKind of
      c_ValueKind_String, c_ValueKind_StringWithOutDopData: //shortstring
        begin
          ReadVariableLengthField(AStream, StrLen);
          SetLength(AParam.FData, StrLen);
          AStream.Read(AParam.FData, StrLen);
          AParam.StringData := UTF8ToString(BytesToRawByteString(AParam.FData));
          if AParam.Kind = c_ValueKind_String then
          begin
            SetLength(AParam.FDopData, 5);
            AStream.Read(AParam.FDopData, 5);
          end;
        end;
      c_ValueKind_Decimal: //Decimal
        begin
          SetLength(AParam.FData, 16);
          AStream.Read(AParam.FData, 16);
          AParam.DecimalData := BytesToReal(AParam.FData);
          SetLength(AParam.FDopData, 6);
          AStream.Read(AParam.FDopData, 6);
        end;
      c_ValueKind_Date: //Date
        begin
          SetLength(AParam.FData, 8);
          AStream.Read(AParam.FData, 8);
          AParam.DateData := CSharpToDateTime(PUINT64(@AParam.FData[0])^);
          SetLength(AParam.FDopData, 5);
          AStream.Read(AParam.FDopData, 5);
        end;
      c_ValueKind_VariableLengthField: //Byte
        begin
          ReadVariableLengthField(AStream, AParam.FVarLengthData);
          SetLength(AParam.FDopData, 5);
          AStream.Read(AParam.FDopData, 5);
        end;
      c_ValueKind_Note: //Note
        begin
          AStream.Position := AStream.Position + 16;
          ReadVariableLengthField(AStream, StrLen);
          SetLength(AParam.FData, StrLen);
          AStream.Read(AParam.FData, StrLen);
          AParam.StringData := UTF8ToString(BytesToRawByteString(AParam.FData));
          SetLength(AParam.FDopData, 18);
          AStream.Read(AParam.FDopData, 18);
        end;
    else
      raise exception.Create('Unknown data type ' + IntToHex(AParam.FKind, 2));
    end;
  end;

  procedure ReadLinks(AStream: TStream; AParam: TParam);
  var
    Len1, LinkCount: Byte;
    P, P1: TParam;
    B: TBytes;
  begin
    repeat
      AStream.ReadData(Len1);
      if Len1 = $0 then
        break;
      P := TParam.Create(AParam.Items);
      P.Level := c_LevelLink;
      SetLength(B, Len1);
      AStream.Read(B, Len1);
      P.Name := StringOf(B);
      AStream.ReadData(LinkCount);
      while LinkCount > 0 do
      begin
        AStream.ReadData(Len1);
        case Len1 of
          $0: // string;
            begin
              P1 := TParam.Create(P.Items);
              P1.Level := c_LevelLink;
              P1.Kind := c_ValueKind_StringWithOutDopData;
              P1.Name := 'Link #' + IntToStr(LinkCount);
              ReadValue(AStream, P1);
            end;
        else
          raise Exception.Create('unknown data type for link');
        end;
        LinkCount := LinkCount - 1;
      end;
    until AStream.Position >= AStream.Size - 1;
  end;

  procedure ReadValues(AStream: TStream; AParam: TParam; ALen: Int64);
  var
    Len1: Byte;
    P: TParam;
    B: TBytes;
  begin
    repeat
      AStream.ReadData(Len1);
      if Len1 = $00 then
        break;
      P := TParam.Create(AParam.Items);
      P.Level := c_LevelValue;
      SetLength(B, Len1);
      AStream.Read(B, Len1);
      P.Name := StringOf(B);
      AStream.ReadData(P.FKind);
      ReadValue(AStream, P);
    until AStream.Position >= ALen;
  end;

  procedure ReadRows(AStream: TStream; AParam: TParam);
  var
    Len4: Integer;
    P: TParam;
  begin
    repeat
      ReadVariableLengthField(AStream, Len4);
      if Len4 = $3FFF then
        break;
      P := TParam.Create(AParam.Items);
      P.Level := c_LevelRowValue;
      P.RowNumber := Len4;
      P.Name := 'Element #' + IntToStr(Len4);
      P.Kind := c_ValueKind_Decimal;
      ReadValue(AStream, P);
    until AStream.Position >= AStream.Size - 1;
  end;

  procedure ParsePart1_3(AStream: TStream; AParam: TParam);
  var
    Len4, MaxRow, RowNo: Integer;
    Len1, SlipsCount: Byte;
    B: TBytes;
    P, P1: TParam;
    strm: TBytesStream;
    S: String;
  begin
    AStream.position := 0;
    case AParam.Kind of
      $03: //slips
        begin
          S := TRegEx.Replace(AParam.Path, '#[\d]{1,}', '[X]', [roIgnoreCase]);
          if AllForms.ContainsKey(S) then
            AParam.SlipNo := AllForms.Items[S] + 1
          else
            AParam.SlipNo := 1;
          AllForms.AddOrSetValue(S, AParam.SlipNo);
          SkipPrefix(AStream);
          AStream.Position := AStream.Position + 16;
          ReadLinks(AStream, AParam);
          while AStream.Position < AStream.Size - 1 do
          begin
            AStream.ReadData(Len1);
            SetLength(B, Len1);
            AStream.Read(B, Len1);
            P := TParam.Create(AParam.Items);
            P.Level := c_LevelForm;
            P.Name := StringOf(B);
            AStream.ReadData(P.FKind);
            AStream.ReadData(Len4);
            strm := TBytesStream.Create;
            try
              strm.SetSize(Len4);
              strm.CopyFrom(AStream, Len4);
              ParsePart1_3(strm, P);
            finally
              strm.Free;
            end;
          end;
        end;
      $04: //simple form
        begin
          S := TRegEx.Replace(AParam.Path, '#[\d]{1,}', '[X]', [roIgnoreCase]);
          if AllForms.ContainsKey(S) then
            AParam.SlipNo := AllForms.Items[S] + 1
          else
            AParam.SlipNo := 1;
          AllForms.AddOrSetValue(S, AParam.SlipNo);
          SkipPrefix(AStream);
          AStream.Position := AStream.Position + 1;
          for RowNo := 1 to 3 do
          begin
            AStream.ReadData(Len4);
            AStream.Position := AStream.Position + Len4;
          end;
          ReadLinks(AStream, AParam);
          AStream.ReadData(Len1);
          if Len1 > 0 then
            AStream.Position := AStream.Position + (Len1 * 17);
          while AStream.Position <= AStream.Size do
          begin
            AStream.ReadData(Len1);
            if Len1 = $0 then
              break;
            SetLength(B, Len1);
            AStream.Read(B, Len1);
            P := TParam.Create(AParam.Items);
            P.Level := c_LevelFormPart;
            P.Name := StringOf(B);
            AStream.ReadData(P.FKind);
            AStream.ReadData(Len4);
            strm := TBytesStream.Create;
            try
              strm.SetSize(Len4);
              strm.CopyFrom(AStream, Len4);
              ParsePart1_3(strm, P);
            finally
              strm.Free;
            end;
          end;
        end;
      $07: //FormGroup
        begin
          S := TRegEx.Replace(AParam.Path, '#[\d]{1,}', '[X]', [roIgnoreCase]);
          if AllForms.ContainsKey(S) then
            AParam.SlipNo := AllForms.Items[S] + 1
          else
            AParam.SlipNo := 1;
          AllForms.AddOrSetValue(S, AParam.SlipNo);
          SkipPrefix(AStream);
          AStream.ReadData(Len1);
          if Len1 > $00 then
          begin
            AStream.Position := AStream.Position + 16;
            ReadVariableLengthField(AStream, MaxRow);
            AStream.ReadData(Len1);
            RowNo := $00;
            while RowNo < MaxRow do
            begin
              P := TParam.Create(AParam.Items);
              P.Level := c_LevelSlipGroup;
              P.Name := c_FormGroupCaption + RowNo.ToString;
              P.FKind := Len1;
              P.RowNumber := RowNo;
              SetLength(P.FData, 18);
              AStream.Read(P.FData, 18);
              if AStream.Position >= AStream.Size - 1 then
                break;
              AStream.ReadData(Len4);
              strm := TBytesStream.Create;
              try
                strm.SetSize(Len4);
                strm.CopyFrom(AStream, Len4);
                ParsePart1_3(strm, P);
              finally
                strm.Free;
              end;
              RowNo := RowNo + 1;
            end;
          end;

        end;
      $0A: //FormPart withOut links
        begin
          SkipPrefix(AStream);
          AStream.ReadData(Len1);
          if Len1 > $00 then
          begin
            AStream.Position := AStream.Position + 18;
            ReadVariableLengthField(AStream, MaxRow);
            RowNo := $00;
            while RowNo < MaxRow do
            begin
              P := TParam.Create(AParam.Items);
              P.Level := c_LevelTableLine;
              P.Name := c_TableRowCaption + RowNo.ToString;
              P.RowNumber := RowNo;
              SetLength(P.FData, 16);
              AStream.Read(P.FData, 16);
              AStream.ReadData(Len1);
              AStream.ReadData(Len1);
              if Len1 > $0 then
              begin
                AStream.ReadData(Len4);
                Len4 := Len4 + AStream.Position;
                ReadLinks(AStream, P);
                ReadRows(AStream, P);
//                AStream.ReadData(Len1);
//                if Len1 <> $7F then
//                  raise Exception.Create('unknown terminator');
                ReadValues(AStream, P,  Len4);
                AStream.Position := Len4;
              end;
              RowNo := RowNo + 1;
            end;
          end;
        end;
      $0B: //FormPart with links
        begin
          //read links
          ReadLinks(AStream, AParam);
          //read table data
          ReadVariableLengthField(AStream, MaxRow);
          ReadRows(AStream, AParam);
//          AStream.ReadData(Len1);
//          if Len1 <> $7F then
//            raise Exception.Create('unknown terminator');
          AStream.ReadData(Len1);
          if Len1 > $00 then
            AStream.position := AStream.position + (6 * Len1);
          //Read values
          ReadValues(AStream, AParam,  AStream.Size - 1);
        end
    else
      begin
        raise Exception.Create('unknown form type');
      end;
    end;
  end;

  procedure ParesePart1_2(AStream: TStream; AParam: TParam; AShift: Integer);
  var
    strm: TBytesStream;
    strmPosition: Int64;
    Len4: Integer;
  begin
    strmPosition := AStream.Position;
    try
      AStream.Position := AShift + ROUND(AParam.DecimalData);
      AStream.ReadData(Len4);
      strm := TBytesStream.Create;
      try
        strm.CopyFrom(AStream, Len4);
        strm.Position := 0;
        ParsePart1_3(strm, AParam);
      finally
        strm.Free;
      end;
    finally
      AStream.Position := strmPosition;
    end;
  end;

  procedure ParsePart1_1(AParam: TParam; ALength: Integer);
  var
    strm: TBytesStream;
    Len1, Count: Byte; //20180213 Igor
    ByteValue: Byte; //20180227 Igor
    P: TParam;
    B: TBytes;
    HeaderStart, Len4: Integer;
    I, FormCount, J: Integer; //20180213 Igor
    DataStart: Integer;
  begin
    strm := TBytesStream.Create;
    try
      strm.SetSize(ALength);
      strm.CopyFrom(FBPart1, ALength);
      strm.position := 39;
      ReadVariableLengthField(strm, Len4);
      strm.ReadData(Len4);
      strm.position := strm.position + Len4;
      strm.ReadData(Len4);
      strm.position := strm.position + Len4;
      strm.ReadData(Len4);
      strm.position := strm.position + Len4;
      strm.position := strm.position + 16;
      strm.ReadData(Count);
      for I := 0 to Count - 1 do
      begin
        P := TParam.Create(AParam.Items);
        P.Level := c_LevelValue;
        strm.ReadData(Len1);
        SetLength(B, Len1);
        strm.Read(B, Len1);
        P.Name := StringOf(B);
        strm.ReadData(P.FKind);
        //20180227 Igor >>>
        SetLength(P.FData, 8);
        strm.Read(P.FData, 8);
        strm.ReadData(Len1);
        for J := 0 to Len1 - 1 do
        begin
          strm.ReadData(ByteValue);
          strm.Position := strm.Position + ByteValue + 3;
        end;
        //20180227 Igor <<<
      end;
      //20180213 Igor >>>
      for J := 0 to 1 do
      begin
        strm.ReadData(Len4);
        strm.Position := strm.Position + Len4;
      end;

      //20180213 Igor <<<
      //20201113 Igor >>>
      if Fileversion = 29 then
      begin
        strm.ReadData(Len4);
        strm.Position := strm.Position + Len4;
        DataStart := strm.Position;
        strm.ReadData(HeaderStart);
        strm.Position := strm.Position + HeaderStart - 4;
        strm.ReadData(FormCount);
      end
      else
      begin
        DataStart := strm.Position;
        strm.ReadData(HeaderStart);
        strm.Position := strm.Position + HeaderStart - 4;
        strm.ReadData(FormCount);
      end;
      //20201113 Igor <<<

      for I := 0 to FormCount - 1 do
      begin
        P := TParam.Create(AParam.Items);
        P.Level := c_LevelForm;
        strm.ReadData(Len1);
        SetLength(B, Len1);
        strm.Read(B, Len1);
        P.Name := StringOf(B);
        strm.ReadData(Len4);
        P.DecimalData := Len4;
        strm.ReadData(P.FKind);
        ParesePart1_2(strm, P, DataStart);
      end;
    finally
      strm.Free;
    end;
  end;

  procedure ParesePart1_0;
  var
    Len4: Integer;
    ReturnNo: Byte;
    ReturnCount: Byte;
    P: TParam;
  begin
    FBPart1.Position := 17;
    FBPart1.ReadData(ReturnCount);
    Repeat
      P := TParam.Create(Self.FParams);
      P.Level := c_LevelReturn;
      FBPart1.ReadData(ReturnNo);
      P.Name := 'Return #'+IntToStr(ReturnNo);
      AllForms := TDictionary<String, Integer>.Create;
      try
        FBPart1.ReadData(Len4);
        ParsePart1_1(P, Len4);
      finally
        AllForms.Free;
      end;
    until (FBPart1.Position >= FBPart1.Size) or (ReturnNo >= ReturnCount - 1);
  end;
begin
  if ReadHeader then
    try
      ReadPart1;
//      ReadPart2;
      ParesePart1_0;
      Result := True;
    except ON E: Exception do
      begin
        Result := False;
      end;
    end
  else
    Result := False;
end;

procedure TTaxCycleFile.ExportToTree(ATreeView: TTreeView; AMap: IXMLTaxCycleMapType);
  procedure ExportToNode(AList: TParamList; AParentNode: TTreeNode);
  var
    P: TParam;
    N1: TTreeNode;
  function LevelKindToImageIndex(ALevel, AKind: Byte): Integer;
  begin
    case ALevel of
      c_LevelFile: Result := 0;
      c_LevelReturn: Result := 1;
      c_LevelForm: Result := 2;
      c_LevelFormPart: Result := 3;
      c_LevelSlipGroup: Result := 9;
      c_LevelRowValue: Result := 5;
      c_LevelLink: Result := 10;
      c_LevelTableLine: Result := 12;
    else
      case AKind of
        c_ValueKind_String, c_ValueKind_StringWithOutDopData: Result := 4;
        c_ValueKind_Decimal: Result := 5;
        c_ValueKind_Date: Result := 6;
        c_ValueKind_VariableLengthField: Result := 7;
        4: Result := 3;
        10, 11, 7, 6: Result := 11
      else
        Result := -1;
      end;
    end;
  end;
  begin
    for P in AList do
    begin
      N1 := AtreeView.Items.AddChildObject(AParentNode, P.Name, P);
      N1.ImageIndex := LevelKindToImageIndex(P.Level, P.Kind);
      if P.Level in [c_LevelValue, c_LevelRowValue, c_LevelLink] then
        N1.Text := N1.Text + ': ' + P.ValueAsString;
      N1.SelectedIndex := N1.imageIndex;
      if (P.Level in [c_LevelValue, c_LevelRowValue]) then
        if AMap.Elements.FindElementByTaxCyclePath(P.Path) <> nil then
          N1.StateIndex := 8;

      ExportToNode(P.FItems, N1);
    end;
  end;

var
  N: TTreeNode;
begin
  N := AtreeView.Items.Add(nil, Self.SourceFileName + '<' + Self.Vendor + '>');
  N.ImageIndex := 0;
  ExportToNode(Self.FParams, N);
end;

function TTaxCycleFile.LoadFromFile(AFileName: String): Boolean;
var
  FS: TMemoryStream;
begin
  if not FileExists(AFileName) then
  begin
    MessageDlg('File "' + AFileName + '" not found', mtWarning, [mbOK], 0);
    Exit(False);
  end;
  TryStrToInt(Copy(ExtractFileExt(AFileName), 2, 4), FCurrYear); //20240103 Igor
  SourceFileName := AFileName;
  try
    FS := TMemoryStream.Create;
    try
      FS.LoadFromFile(AFileName);
      FS.Position := 0;
      Result := LoadFromStream(FS);
    finally
      FS.Free;
    end;
  except ON E: Exception do
    Result := False;
  end;
end;

function TTaxCycleFile.LoadFromStream(AStream: TStream): Boolean;
begin
  if AStream = nil then
    exit(False);
  Result := DoLoadFromStream(AStream);
end;

procedure TTaxCycleFile.SetHeaderComment(const Value: String);
begin
  FHeaderComment := Value;
end;

procedure TTaxCycleFile.SetHeaderComment2(const Value: String);
begin
  FHeaderComment2 := Value;
end;

procedure TTaxCycleFile.SetHeaderComment2Type(const Value: Byte);
begin
  FHeaderComment2Type := Value;
end;

procedure TTaxCycleFile.SetParams(const Value: TParamList);
begin
  FParams := Value;
end;

procedure TTaxCycleFile.SetSourceFileName(const Value: String);
begin
  FSourceFileName := Value;
end;

procedure TTaxCycleFile.SetFileversion(const Value: Byte);
begin
  FFileversion := Value;
end;

procedure TTaxCycleFile.SetVendor(const Value: String);
begin
  FVendor := Value;
end;

{ TParam }

constructor TParam.Create(AParent: TParamList);
begin
  inherited Create;
  FParent := AParent;
  if Assigned(FParent) then
    FParent.Add(Self);
  FItems := TParamList.Create(False);
  FItems.OwnerParam := Self;
  FSlipNo := 0;
end;

destructor TParam.Destroy;
begin
  if assigned(FParent) then
    FParent.Remove(Self);
  if Assigned(FItems) then
    while FItems.Count > 0 do
      FItems[0].Free;
  inherited Destroy;
end;

function TParam.FindChild(APath: String): TParam;
var
  S1, SS1, S2: String;
  J: Integer;
  P, P1: TParam;
  N: String;
  M: TMatch;
const
  Pattern = '('+c_FormGroupCaption + '|' + c_TableRowCaption + ')';
begin
  J := pos('.', APath);
  if J = 0 then
  begin
    S1 := APath;
    S2 := '';
  end
  else
  begin
    S1 := copy(APath, 1, J - 1);
    S2 := copy(APath, J + 1, MaxInt);
  end;
  M := TRegEx.Match(S1, '\[[\d]{1,}\]', [roIgnoreCase]);
  if M.Success AND not StartsText('M[', S1) then
  begin
    S1 := copy(S1, 1, M.Index - 1);
    SS1 := Copy(M.Value, 2, M.Length - 2);
  end
  else
    SS1 := '';

  for P in Self.Items do
  begin
    N := TRegEx.Replace(P.Name, 'Element #[\d]{1,}$', MatchEvalElement);
    if SameText(N, S1) then
    begin
      if SS1 <> '' then
      begin
        for P1 in P.Items do
        begin
          N := TRegEx.Replace(P1.Name, Pattern, '');
          if SameText(N, SS1) then
          begin
            if S2 = '' then
              Exit(P1)
            else
              exit(P1.FindChild(S2));
          end;
        end;
      end
      else
      begin
        if S2 = '' then
          Exit(P)
        else
          Exit(P.FindChild(S2));
      end;
    end;
  end;
  Result := nil;
end;

function TParam.FindChilds(const APath: String): TParamList;
begin
  Result := TParamList.Create(False);
  FindChilds(APath, Result);
end;

procedure TParam.FindChilds(const APath: String; AList: TParamList);
var
  S1, SS1, S2: String;
  J: Integer;
  P, P1: TParam;
  N: String;
  M: TMatch;
const
  Pattern = '('+c_FormGroupCaption + '|' + c_TableRowCaption + ')';
begin
  Assert(Assigned(AList));
  J := pos('.', APath);
  if J = 0 then
  begin
    S1 := APath;
    S2 := '';
  end
  else
  begin
    S1 := copy(APath, 1, J - 1);
    S2 := copy(APath, J + 1, MaxInt);
  end;
  M := TRegEx.Match(S1, '\[([\d]{1,}|Y[\d]{0,})\]', [roIgnoreCase]);
  if M.Success AND not StartsText('M[', S1) then
  begin
    S1 := copy(S1, 1, M.Index - 1);
    SS1 := Copy(M.Value, 2, M.Length - 2);
  end
  else
    SS1 := '';

  for P in Self.Items do
  begin
    N := TRegEx.Replace(P.Name, 'Element #[\d]{1,}$', MatchEvalElement);
    if SameText(N, S1) then
    begin
      if SS1 <> '' then
      begin
        for P1 in P.Items do
        begin
          if StartsText('Y', SS1) then
          begin
            if S2 = '' then
              AList.Add(P1)
            else
              P1.FindChilds(S2, AList);
          end
          else
          begin
            N := TRegEx.Replace(P1.Name, Pattern, '');
            if SameText(N, SS1) then
            begin
              if S2 = '' then
                AList.Add(P1)
              else
                P1.FindChilds(S2, AList);
            end;
          end;
        end;
      end
      else
      begin
        if S2 = '' then
          AList.Add(P)
        else
          P.FindChilds(S2, AList);
      end;
    end;
  end;
end;

function TParam.FullDescription: String;
begin
  Result :='Name = ' + Name + #13 +
           'Fullname = ' + Fullname + #13 +
           'Level = ' + IntToStr(Level) + #13 +
           'Kind = ' + IntToStr(Kind) + #13 +
           'Data = ' + BytesToHex(Data) + #13 +
           'DopData = ' + BytesToHex(DopData) + #13 +
           'StringData = ' + StringData + #13 +
           'varLengthData = ' + IntToStr(VarLengthData) + #13 +
           'DateData = ' + DateToStr(DateData) + #13 +
           'DecimalData = ' + FloatToStr(DecimalData) + #13 +
           'ValueAsString = ' + ValueAsString;
end;

function TParam.GetFullName: String;
var
  P: TParam;
begin
  P := Self;
  Result := '';
  while Assigned(P) do
  begin
    Result := P.Name + '.' + Result;
    if Assigned(P.Parent) then
      P := P.Parent.OwnerParam
    else
      P := nil
  end;
  if Length(Result) > 0 then
    Delete(Result, Length(Result), 1);
end;

function TParam.GetSlipNo: Integer;
var
  P: TParam;
begin
  P := Self;
  while P <> nil do
  begin
    if P.FSlipNo > 0 then
      exit(P.FSlipNo);
    if Assigned(P.Parent) then
      P := P.Parent.OwnerParam
    else
      P := nil
  end;
  Result := 1;
end;

function TParam.IsLastRow: Boolean;
var
  P: TParam;
begin
  P := Self;
  while P <> nil do
  begin
    if P.Level = c_LevelTableLine then
      exit(P.Parent.IndexOf(P) = (P.Parent.Count - 1));
    if P.Parent <> nil then
      P := P.Parent.OwnerParam
    else
      break;
  end;
  Result := False;
end;

function TParam.MatchEvalElement(const Match: TMatch): string;
begin
  Result := 'M[' + TRegEx.Match(Match.Value, '[\d]', [roIgnoreCase]).Value + ']';
end;

function TParam.Path: String;
var
  P: TParam;
begin
  if FPath <> '' then
    Exit(FPath);
  P := Self;
  Result := '';
  while Assigned(P) do
  begin
    Result := P.Name + '.' + Result;
    P := P.Parent.OwnerParam;
    if (P <> nil) and (P.Level = c_LevelReturn) then
      Break;
  end;
  if Length(Result) > 0 then
    Delete(Result, Length(Result), 1);
end;

function TParam.RowNo: Integer;
var
  P: TParam;
begin
  P := Self;
  while P <> nil do
  begin
    if P.Level = c_LevelTableLine then
      exit(P.Parent.IndexOf(P) + 1);
    if P.Parent <> nil then
      P := P.Parent.OwnerParam
    else
      break;
  end;
  Result := 0;
end;

procedure TParam.SetVarLengthData(const Value: Integer);
begin
  FVarLengthData := Value;
end;

procedure TParam.SetData(const Value: TBytes);
begin
  FData := Value;
end;

procedure TParam.SetdateData(const Value: TDateTime);
begin
  FDateData := Value;
end;

procedure TParam.SetDopData(const Value: TBytes);
begin
  FDopData := Value;
end;

procedure TParam.SetDecimalData(const Value: Real);
begin
  FDecimalData := Value;
end;

procedure TParam.SetItems(const Value: TParamList);
begin
  FItems := Value;
end;

procedure TParam.SetKind(const Value: Byte);
begin
  FKind := Value;
end;

procedure TParam.SetLevel(const Value: Byte);
begin
  FLevel := Value;
end;

procedure TParam.SetName(const Value: String);
begin
  FName := Value;
  FPath := Path;
end;

procedure TParam.SetParent(const Value: TParamList);
begin
  FParent := Value;
end;

procedure TParam.SetRowNumber(const Value: word);
begin
  FRowNumber := Value;
end;

procedure TParam.SetSlipNo(const Value: Integer);
begin
  FSlipNo := Value;
end;

procedure TParam.SetStringData(const Value: String);
begin
  FStringData := Value;
end;

procedure TParam.SetVisualTaxReturnNo(const Value: Integer);
begin
  FVisualTaxReturnNo := Value;
end;

function TParam.ValueAsString: String;
begin
  if Level = c_LevelRowValue then
    Result := FloatToStr(DecimalData)
  else
  if Level = c_LevelLink then
    Result := StringData
  else

    case FKind of
      0: Result := StringData;
      1: Result := FloatToStr(DecimalData);
      2:
        begin
          if DateData > 0 then
            Result := FormatDateTime('YYYY-MM-DD', DateData)
          else
            Result := '';
        end;
      3: Result := IntToStr(VarLengthData);
    end;
end;

{ TParamList }

procedure TParamList.SetOwnerParam(const Value: TParam);
begin
  FOwnerParam := Value;
end;

{ TvtGroup }

constructor TvtGroup.Create(ASourceStr: String);
var
  SL: TStringList;
  I, J: Integer;
begin
  inherited create;
  FormName := UpperCase(Trim(Copy(ASourceStr, 1, 10)));
  SL := TStringList.Create;
  try
    SL.CommaText := Copy(ASourceStr, 11, MaxInt);
    SetLength(FElements, SL.Count);
    for I := 0 to SL.Count - 1 do
      if TryStrToInt(SL[I], J) then
        Elements[I] := J;
  finally
    SL.Free;
  end;
  TArray.Sort<Integer>(FElements);
end;

function TvtGroup.InRadioGroup(const AElement: Integer): Boolean;
var
  Index: Integer;
begin
  Result := TArray.BinarySearch<Integer>(Elements, AElement, Index);
end;

procedure TvtGroup.SetFormName(const Value: String);
begin
  FFormName := Value;
end;

procedure TvtGroup.SetElements(const Value: TArray<Integer>);
begin
  FElements := Value;
end;

{ TvtGroups }

constructor TvtGroups.Create(AApp: TApp);
var
  SL: TStringList;
  S: String;
  Comparer: IComparer<TvtGroup>;
begin
  Comparer := TDelegatedComparer<TvtGroup>.Create(
    function(const Left, Right: TvtGroup): Integer
    begin
      Result := CompareText(Left.FormName, Right.FormName);
    end);
  inherited Create(Comparer);
  SL := TStringList.Create;
  try
    SL.LoadFromFile(IncludeTrailingPathDelimiter(AApp.AppDir) + 'RadioGrp.d');
    for S in SL do
    begin
      if not S.IsEmpty then
        Add(TvtGroup.Create(S));
    end;
  finally
    SL.Free;
  end;
  Self.Sort;
end;

function TvtGroups.InRadioGroup(const AForm: String;
  const AElement: Integer; out AGroup: TvtGroup): Boolean;
var
  I, J: Integer;
begin
  AGroup := nil;
  for I := 0 to Count - 1 do
  begin
    J := CompareText(AForm, Items[I].FormName);
    if J < 0 then
      exit(False)
    else
    if (J = 0) AND Items[I].InRadioGroup(AElement) then
    begin
      AGroup := Items[I];
      Exit(True);
    end;
  end;
  Result := False;
end;

end.
