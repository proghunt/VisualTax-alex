unit vtChild;
(* Declares the basic MDI child window and tax form types.

Every ChildWin is related to a return and its forms.
It manages the content, appearance and behaviour of the tax form controls.

A ScrollBox shows a tax form, related to a specific return.
It can be either a child of a ChildWin or some other container.

Scaling is done in the vtScrollBox. When required (zoom changed) the
controls are destroyed, the DFM file is reloaded and scaled.
Then eventual dynamic arrays are added to the form,
and the form is re-populated.

Global event handling???
Double and Right clicks should invoke the ChildWin(?) handlers, at least for
clicks outside an EditBox. For floating forms the handlers should be part of
the ScrollBox!
--> The ScrollBox should call the ChildWin.OnVtEdit...Click handlers,
with a NIL Sender when not invoked from an EditBox.
*)

(*
// Detect Keys: Enter in FormKeyPress.
//              Tab is not detected (causes OnExitField)
//              Up/Down in FormKeyDown
//              Other keys i.e. Ctrl A in FormKeyDown via Keys
    Change keys (Enter, Up/Down) set ExitCtrl and move the focus.
    OnExitField detects valid exit (ExitCtrl) and valid strings.
// ExitingField is triggered by Enter, Key up, Key Don, pgup, etc CTRL keys
// etc. It does validation of the current field and it may stop the tab
//
// buttons: formbuttonClick, app-specific
// Mouse events         `
//    right click in FormMouseDown (via rightclick rtn)
//    EditboxMouseDown captures mouse events on editbox
        (left click here, right click app-specific)
//    Double click OnVtEditDblClick
// tab sheet click

*)

{$DEFINE dynamic} //dynamic fields implemented?
{$DEFINE scaling} //scaling implemented?

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons, Contnrs,
  vtForm, //vtMemoBox,
  vtEditBox,
  vtGroupBox, //20160407 Igor
  System.IOUtils, System.Types,//20170927 igor
(* !!! cannot use FRec, vtMulti here would cause circular references!!!
*)

  RxRichEd, fColouredPageTabControl; //20160819 Igor (It must be the last)

type
  TMyChild = class;

  TBoxRow = array of TvtEdit;
  TBoxRows = array of TBoxRow;
  TBoxArray = record
    MaxBox: integer;
    //Row0Top, Row0Bottom: integer; //for MoveComponents !scaled values!
    Rows: TBoxRows;
  end;
  TBoxArrays = array of TBoxArray;
  TMoveDirection = (mdUp, mdDown, mdRemove, mdWithRequest); //20170407 Igor //20170411 Igor
  TvtScrollBox = class(TvtForm)
  private
    FNoCompare: integer; //20160320 Igor
    FStartUsedWidth: Integer; //20160720 Igor
    FisAppendix: Boolean; //20161129 Igor
    FDRAFTLabel: TLabel; //20161130 Igor
    FDFMPath: String;//20170719 Igor
    procedure OVR(MethName: string); //show error message
    procedure SyncRows(FieldId: integer);
    function GetNoCompare: Boolean; //20160320 Igor
    procedure vtEditChange(Sender: TObject); //20160805 Igor
  protected
    FMyZoom: integer; //default: 100(%) after DFM load
    MyChild: TMyChild;
    DynArrays: TBoxArrays;
    NumArrays: integer;
    function NoChild: boolean;
    function FormZoom: integer;
    function RightZoom: integer; //20160209 Igor
    //20170407 Igor >>>
    procedure InsertDynamicRowBefore(AEdit: TvtEdit);
    procedure MoveDynamicRow(AEdit: TvtEdit; ADirrection: TMoveDirection); overload;
    procedure MoveDynamicRow(AEdit1, AEdit2: TvtEdit); overload;

    //20170407 Igor <<<
    procedure AddDynamicRowsToForm;
    procedure AddRows(ArrayNo, NewTop: integer);
    procedure InitRow(ArrayNo, RowNo, BoxesPerRow: integer);
    procedure PushComponentsUpOrDown(StartingSpot, PushAmount: Integer);
  public
    //unique!
    procedure OnEnterField(MyEditBox: TvtEdit); override; //virtual; abstract;
  protected
    procedure BuildSuperEntry(Value: string; FlName: string);
    procedure ChangeEditBoxText(MyEditBox: TvtEdit; Value: string);
    procedure ChangeAndMove(MyEditBox: TvtEdit; Value: string; fBack: boolean = False);
    function ExitingField(MyEditBox: TVtEdit): Boolean;
    function IsInRadioGroup(FieldId: integer): string; //virtual;
    function GetPopUpFile(FldId: Integer): string; //virtual;
    procedure UpdateAfterSave;
  protected //override!
    procedure ChangeProperties(MyEditBox: TvtEdit; Elm: Integer); virtual;
    procedure DataChangeRtn; virtual;
    function IsProtectedField(MyEditBox: TvtEdit): boolean; virtual;
    procedure FormatDollar(MyEditBox: TvtEdit; str: string); virtual; //abstract;
    procedure FormatEditBoxText(MyEditBox: TvtEdit; str: string); virtual; //abstract;
    procedure FormButtonClick(Sender: TObject); virtual;
    function GetLinkedForm(FieldId: Integer; var TargetLinkedField: Integer): string; virtual;
    function GetValueFromList(MyEditBox: TvtEdit; FieldId: integer): string; virtual; abstract;
    function SetEditBoxBackColor(MyEditBox: TvtEdit): TColor; virtual; //abstract;
    function ValidateField(FieldId: integer; var Value: string): boolean; virtual;

    procedure WMVScroll(var Msg: TMessage); message WM_VSCROLL; //20160312 Igor
    procedure WMHScroll(var Msg: TMessage); message WM_HSCROLL; //20160312 Igor
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);override; //20160312 Igor
    function GetisDraft: Boolean; virtual; //20161130 Igor
    function AllowEditVertSeparator: Boolean; virtual; //20171226 Igor
  protected //Form handlers
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //virtual;
    procedure FormKeyPress(ActiveControl: TControl; var Key: Char); virtual;
{$IFDEF old}
    procedure FormClick(Sender: TObject); virtual;
    procedure Keys(var Key: Word; Shift: TShiftState); virtual;
{$ELSE}
{$ENDIF}
    //20170411 Igor >>>
    function SameTable(AField1, AField2: Integer): Boolean; virtual;
    function SameColumn(AField1, AField2: Integer): Boolean; virtual;
    function isLastRow(AFieldID: Integer): Boolean; virtual;
    //20170411 Igor <<<
  public //Edit handlers, FormName etc. set
    procedure EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override; // virtual;
    procedure OnExitField(MyEditBox: TvtEdit); override; //virtual;
    //procedure OnVtEditDblClick(MyEditBox:TvtEdit); virtual; abstract;
    //procedure OnVtEditRightClick(MyEditBox:TvtEdit); virtual; abstract;
    procedure SaveEditBoxText(FieldId: Integer; Value: string);
    //procedure SendMemoToSave(MyMemoBox: TvtMemo); virtual; //abstract;
    procedure SendMemoToSave(MyMemoBox: TCustomMemo); override;

    procedure ShowFieldData(MyEditBox: TvtEdit); virtual;
    procedure CompareEditBoxLastYear(MyEditBox: TvtEdit); //20160316 Igor
    procedure ShowFormData; virtual; //from global/ChildWin ShowFormData
    procedure ShowMemoData(MyMemoBox: TMemo; Fld: Integer); virtual;
    procedure ShowRichData(ARichEdit: TRichEdit; Fld: Integer); virtual;
    procedure ShowOther(cmp: TComponent); virtual;
    procedure PopulateFormWithData; virtual; //abstract;
    procedure CompareFormLastYear; virtual; //20160316 Igor
    function ReplaceString(FieldId: Integer; NewString: string): boolean; virtual;

    procedure ToggleOverride(MyEditBox: TvtEdit);
    procedure ToggleReview(MyEditBox: TvtEdit);
  public
    constructor Create(AParent: TWinControl; RNo, FNo: integer); reintroduce;
    procedure AfterOpenForm(ADestination: TvtDestination = vtdDisplay); override;
    procedure Activated(fRefresh: boolean; ACallActiveFormChange: Boolean = True);
    function GetFieldByTabOrder(tOrder: Integer): TWinControl;
    property MyZoom: integer read FMyZoom;
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure Repaint; override;
    procedure Update; override;
    property NoCompare: Boolean Read GetNoCompare; //20160320 Igor
    procedure RebuildDynamicRows; //20160527 Igor
    property StartUsedWidth: Integer read FStartUsedWidth; //20160720 Igor
    procedure BeforeReadComponentResFile; //20161130 Igor
    procedure AfterReadComponentResFile; //20160720 Igor
    property isAppendix: Boolean read FisAppendix write FisAppendix; //20161129 Igor
    property isDRAFT: Boolean read GetisDraft; //20161129 Igor
  published //???
    property vtScrollBoxId;

  end;

  TvtFormClass = class of TvtScrollBox;

  TMyChild = class(TForm)
  private
    FRetNo: integer;
    FMyPageControl: TPageControl;
    AMouseDown : Boolean;  //20160314 Igor
    FControlHides: Boolean; //20170717 Igor
    FDifferedOpenForms: TArray<String>; //20170719 Igor
    procedure OVR(MethName: string); //show error message
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean); //20160720 Igor
  protected
    FormClass: TvtFormClass;
    function GetHeaderFrame: TFrame; virtual; abstract; //20160226 Igor
    function GetMonitorFrame: TFrame; virtual; abstract; //20160226 Igor
  public //Form handlers, nothing known about FormName etc.
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //virtual;
    procedure FormKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure Keys(var Key: Word; Shift: TShiftState); virtual;
  public
    procedure DetachReturn;
    property RetNo: integer read FRetNo;
    property MyPageControl: TPageControl read FMyPageControl;
    property Pages: TPageControl read FMyPageControl;
    procedure PageControlMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer); //20160314 Igor
    procedure PageControlDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);//20160113 Igor
    procedure PageControlDragDrop(Sender, Source: TObject; X, Y: Integer);//20160113 Igor
    procedure MyPageControlChange(Sender: TObject);
    procedure MyPageControlChanging(Sender: TObject; var AllowChange: Boolean);
  public //protected //for internal use only! (headerFrame!?)
{$IFDEF old}
    FormName: string;
    FormNo: integer;
    procedure FormNameNo(FName: string; FNo: integer);
    //procedure FormNameNo(RNo: integer; FName: string);
{$ELSE}
    function FormName: string;
    function FormNo: integer;
{$ENDIF}
    function ActiveForm: TvtScrollBox;
  public
{$IFDEF flicker}
    procedure Repaint; override;
    procedure Update; override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
{$ELSE}
{$ENDIF}
    constructor CreateNew(AOwner: TComponent; RNo: Integer); override;
    destructor Destroy; override;  //20170606 Igor
    function CreateNewTab(FNo: integer; FName: string): TTabSheet;
    procedure AddPropertiesAndEvents; virtual;
    procedure AfterOpenForm(MyScrollBox: TvtScrollBox); virtual;
    procedure BringExistingTabSheetToFront(FName: string; FNo, Elm: Integer);
    procedure RescaleAllForms; //20160209 Igor
    function GetActiveTabSheet: boolean;
    function CreateForm(ParentForm: TWinControl; FNo: integer): TvtScrollBox; virtual;
    function GetForm(FNo: integer; MakeActive: boolean): TvtScrollBox;
    function GetPageScrollBox(APage: TTabSheet): TvtScrollBox;
    function GetScrollbox(FName: string): TvtScrollBox; overload;
    function GetScrollbox(FNo: integer): TvtScrollBox; overload;
    procedure RefreshActiveForm;
    procedure ShowUsedForms;
    procedure UpdateAfterSave(FormName: string);
    procedure HideAllControls; //20170130 Igor
    procedure ShowAllControls(ADeferred: Boolean = True); //20170718 Igor
  public //override
    procedure CloseActiveForm(Sender: TObject); virtual;
    procedure SetColor(clr: TColor); virtual;
    procedure ShowFormData(FName: string; FNo: Integer); virtual;
    procedure UpdateChildTaxPanel; virtual;
    procedure UpdateFormHeaderFrame; virtual;
    procedure UpdateFrames; //header and tax panel
    //sections
    procedure Pg1Click(Sender: TObject); virtual;
    procedure GetFormSections(FName: string; SomeList: TstringList);
    function GoToSection(ExceptForm: string = ''): string; //virtual;
    function UpdateSectionButtons(MyFormHeaderFrame: TFrame): boolean;
    property HeaderFrame: TFrame Read GetHeaderFrame; //20160227 Igor
    property MonitorFrame: TFrame Read GetMonitorFrame; //20160227 Igor
    procedure AddDeferredOpenForm(const AFormName: String); //20170719 Igor
   //20170606 Igor >>>
  strict private
    class constructor Create;
  public
    class var
      ChildCount: Integer;
   //20170606 Igor <<<
  end;
 //20170606 Igor >>>
//var
//  ChildCount: integer; //count of alive MDI forms\
 //20170606 Igor <<<
var
  MyTabSheet: TTabSheet;
  //MyScrollBox:TvtScrollbox; - usage?

function CreateNewMDIChild(RetNo: Integer; const FName: string): TMyChild;
function GetActiveChild: TMyChild;
function GetChild(RetNo: integer): TMyChild;
function GetActiveForm: TvtScrollBox;
function GetScrollbox(MyChild: TMyChild; FName: string): TvtScrollBox;
function GetMyScrollBox(AChild: TControl): TvtScrollBox;
function GetFieldId(const EditBoxName: string): Integer;

function ValidateAmountField(s: Char): boolean; overload;
//20170904 Igor>>>
function ValidateAmountField(s: Char; AText: string; ASelStart, ASelLength: Integer): boolean; overload;
//20170904 Igor<<<
function ValidateNumericField(s: Char): boolean;

procedure ReScaleAllOpenedForms; //20160209 Igor

procedure BringExistingTabSheetToFront(RetNo: Integer; FName: string; FNo, Elm: Integer);
procedure SwitchForms;
//procedure SaveSwitchForms(OldBox: TvtScrollBox);
procedure SaveSwitchForms(OldBox: Tvtform);

function GetPredictiveFile(RetNo: integer; FrmNm: string; FldId: Integer): string;

function SetEditBoxFontColor(MyEditBox: TvtEdit): TColor;

procedure Register;

// --------------- dynamics ---------------------

//global entries
//Procedure ShowDynamicData(RetNo:Integer;FName:String;MyScrollBox:TvtScrollBox);
  //used by print - drop?
//Procedure DeleteDynamicRow(RetNo:Integer;FName:String;FieldId:Integer;VtScrollBox:TvtScrollBox);
procedure DeleteDynamicRow(MyScrollBox: TvtScrollBox; FieldId: integer);
procedure AddDynamicRow(MyScrollBox: TvtScrollBox; FieldId: integer);

implementation

{.$R *.DFM}
uses
  TypInfo, Printers,
  vtLabel, vtShape, //wwRichEd,
  vtMulti, vtCommon, vtMain, vtDialogs,
  //keep last
  vtDynData, vtTrimStr, vtShared,
  System.Rtti, //20160720 Igor
  vtControlIntf;

var
  PrevFormName: String; //20170215 Igor

procedure Register;
begin
  RegisterComponents('VisalTax', [TvtScrollBox]);
end;

function CreateNewMDIChild(RetNo: Integer; const FName: string): TMyChild;
var
  MyChild: TMyChild absolute result;
  MyApp: TApp;
begin
  (* return must exist!
  *)
  MyChild := RetList[RetNo].MyChild;
  if MyChild <> nil then
    exit;
  MyChild := RetList[RetNo].NewChild;
  //RetList[RetNo].MyChild := MyChild;
 //MyChild.Visible := True; - no no no!
  if Application.MainForm.FormStyle <> fsMDIForm then
  begin
    ErrorMsg('MainForm not MDI: ' + Application.MainForm.Caption);
    Application.MainForm.FormStyle := fsMDIForm;
  end;
  MyChild.FormStyle := fsMDIChild; //makes it visible
  //Result:=MyChild;
end;

function GetActiveChild: TMyChild;
begin
  (* What if no child open?
  *)
  //get the active MDI child
  TObject(Result) := Application.MainForm.ActiveMDIChild; // as TMyChild;
  if Result = nil then
  begin
    ErrorMsg('bad call to GetActiveChild - please inspect the call stack');
    DebugBreak;
  end;
end;

function GetChild(RetNo: integer): TMyChild;
var
  MyRet: RetPtr;
begin
  Result := nil; //invalid RetNo?
  //FormNameNo(RetNo,
  if TMyChild.ChildCount = 0 then //20170606 igor
    exit;
  MyRet := RetList[retNo];
  if MyRet <> nil then
    Result := MyRet.MyChild;
end;

function GetActiveForm: TvtScrollBox;
var
  MyChild: TMyChild;
begin
  MyChild := GetActiveChild;
  if MyChild = nil then
    Result := nil
  else
    Result := MyChild.ActiveForm;
end;

function GetChildWin(AChild: TControl): TMyChild;
var
  cmp: TWinControl;
begin
  (* get the scrollbox (vtForm) for AChild
  *)
  Result := nil;
  if AChild = nil then
    exit;
  cmp := AChild.Parent;
  while assigned(cmp) and not (cmp is TMyChild) do
    cmp := cmp.Parent;
  Result := TMyChild(cmp);
end;

function GetScrollbox(MyChild: TMyChild; FName: string): TvtScrollBox;
begin
  Result := MyChild.GetScrollBox(FName);
end;

//procedure SaveSwitchForms(OldBox: TvtScrollBox);

procedure SaveSwitchForms(OldBox: TvtForm);
var
  //NewBox: TvtScrollBox;
  MyChild: TMyChild;
begin
  (* Called from OpenForm
  *)
  MyChild := GetChildWin(OldBox);
  if MyChild = nil then
    exit; //no previous form
  //if TryGetActiveForm ?
  PrevRetNo := OldBox.RetNo;
  PrevFormName := OldBox.FormName;
  //PrevFormNo := OldBox.FormNo;
{
  if MyChild.ActiveControl = nil then
    PrevElmNo := 0
  else
    PrevElmNo := ExtractNum(MyChild.ActiveControl.Name);
}
end;

procedure SwitchForms;
begin
  (* switch current and previous RetNo and FormNo.
  *)
    //If ButtonInactive then exit;
    //If (RetList[PrevRetNo] <> nil) and (PrevFormNo>0) then
  if (RetList[PrevRetNo] <> nil) and (PrevFormName <> '') then
  begin
    OpenForm(PrevRetNo, PrevFormName, 0); //PrevElmNo);
    {done in OpenForm
      if (MyBox <> nil) then //and RetNo/FormNo <>?
      begin
        PrevRetNo := MyBox.RetNo;
        PrevFormNo := MyBox.FormNo;
        PrevElmNo := Elm;
      end;
    }
  end;
end;

procedure BringExistingTabSheetToFront(RetNo: Integer; FName: string; FNo, Elm: Integer);
begin
  RetList[RetNo].MyChild.BringExistingTabSheetToFront(FName, FNo, Elm);
end;

function AppDir(RetNo: integer): string;
begin
  Result := RetList[RetNo].MyApp.AppDir;
end;
//20170927 igor>>>
type
  TPredicative = record
    Path: String;
    Content: TStringDynArray;
  end;
  TPredicativeMap = TArray<TPredicative>;
var
  FPredicativeMap: TPredicativeMap;

function GetPredictiveMap(ADir: String): TStringDynArray;
var
  P: TPredicative;
begin
  for P in FPredicativeMap do
    if SameText(P.Path, ADir) then
      Exit(P.Content);
  SetLength(FPredicativeMap, Length(FPredicativeMap) + 1);
  FPredicativeMap[High(FPredicativeMap)].Path := ADir;
  if TFile.Exists(TPath.Combine(ADir, 'Predict.d')) then
    FPredicativeMap[High(FPredicativeMap)].Content := TFile.ReadAllLines(TPath.Combine(ADir, 'Predict.d'));
  Result := FPredicativeMap[High(FPredicativeMap)].Content;
end;

function GetPredictiveFile(RetNo: integer; FrmNm: string; FldId: Integer): string;
var
  A: TStringDynArray;
  S: string;
begin
  FrmNm := ExtractNonInstFormName(FrmNm); //20180313 Igor
  Result := '';
  A := GetPredictiveMap(AppDir(RetNo));
  for S in A do
    if FrmNm = UpperCase(RTrim(LeftStr(S, 10))) then
    begin
      if IsInRange(FldId,
        MyStrToInt(AllTrim(MidStr(S, 11, 3))),
        MyStrToInt(AllTrim(MidStr(S, 15, 3))),
        MyStrToInt(AllTrim(MidStr(S, 19, 3)))) then
      begin
        Result := AllTrim(MidStr(S, 23, 15));
        break;
      end;
    end;
end;
//20170927 igor<<<

function GetPredictiveValue(RetNo: integer; PredictFile: string; FrmNm: string; FldId: Integer; OldString: string): string;
var
  i: Integer;
  TempList: TStringList;
begin
  Result := '';
  if RetList[RetNo].MyApp.NoTypeAhead = True then
    exit;
  OldString := UpperCase(OldString);
  FrmNm := ExtractNonInstFormName(FrmNm);
  TempList := TstringList.Create;
  TempList.LoadFromFile(AppDir(RetNo) + '\' + PredictFile);
  for i := 0 to TempList.Count - 1 do
  begin
    if OldString = UpperCase(LeftStr(TempList[i], Length(OldString))) then
    begin
      result := TempList[i];
      break;
    end;
  end;
  TempList.Free;
end;

function ValidateAmountField(s: Char): boolean;
begin
  Result := CharInSet(s, ['0'..'9', '.', '-']); //20150701
end;
//20170904 Igor>>>
function ValidateAmountField(s: Char; AText: string; ASelStart, ASelLength: Integer): boolean;
var
  Preffix, Suffix: string;
  function ContainsAny(AStr: string; AChars: TSysCharSet): Boolean;
  var
    C: Char;
  begin
    for C in AChars do
      if AStr.Contains(C) then
        Exit(True);
    Result := False;
  end;
begin
  Result := CharInSet(S, ['0'..'9', '.', '-', '+']);
  if not Result then
    Exit;
  Preffix := Copy(AText, 1, ASelStart);
  Suffix := Copy(AText, ASelStart + ASelLength + 1, MaxInt);
  if CharInSet(S, ['-','+']) and (ASelStart <> 0) then
    Exit(False);
  if CharInSet(S, ['-','+']) and ContainsAny(Preffix + Suffix, ['-','+']) then
    Exit(False);
  if CharInSet(S, ['.']) and ContainsAny(Preffix + Suffix, ['.']) then
    Exit(False);
end;
//20170904 Igor<<<

function ValidateNumericField(s: Char): boolean;
begin
  Result := CharInSet(s, ['0'..'9', '-']); //20150701
end;

{ TvtScrollBox }

constructor TvtScrollBox.Create(AParent: TWinControl; RNo, FNo: integer);
var
  FRec: TFRec;
begin
  (* Only derived classes can be created!
  *)
  if ClassType = TvtScrollBox then
    raise Exception.Create('Illegal create of bare TvtScrollBox');

  if AParent = nil then
    inherited Create(Application) //!!duplicate Names? !!!
  else
    inherited Create(AParent);
  init;
  //FNo problem?
  FRec := RetList[RNo].Frm[FNo].FormDataRec;
  if FRec.FormNo <> FNo then
  begin
    //missing FormInit (not created?)
    ErrorMsg('wrong FREC???');
  end;
  //OnKeyDown := edit
  RetNo := RNo;
  FormNo := FNo;
  FormName := GetRetFormName(RetNo, FormNo);
  FDFMPath := '';//20170719 Igor
  Parent := AParent;
  FMyZoom := 100;
  MyChild := RetList[RetNo].MyChild;
  if assigned(MyChild) then
  begin
    PopupMenu := MyChild.PopupMenu;
    OnContextPopup := FormContextPopup;
  end;
  //before or after Parent?
  AutoScroll := True;
  Align := alClient;
  //20190117 Igor >>>
  if CheckIsCloud(true) then
  begin
    VertScrollBar.Tracking := False;
    HorzScrollBar.Tracking := False;
  end
  else
  begin
    VertScrollBar.Tracking := True;
    HorzScrollBar.Tracking := True;
  end;
  //20190117 Igor <<<
  if AParent = nil then
    FloatingForms.RegisterForm(self, False)
  else
    Parent := AParent;
  FNoCompare := -1; //20160320 Igor
end;

procedure TvtScrollBox.Activated(fRefresh: boolean; ACallActiveFormChange: Boolean = True);
//procedure TvtScrollBox.Rescale(zoom: integer; const
var
  zoom: integer;
  //ADFM: string; //20170719 Igor
  R: Boolean;
begin
  (* Form activated, check scaling, color... and refresh data
    problem: labels (all fonts?) seem not to rescale with ScaleBy(zoom,MyZoom);
    problem: WM_SETREDRAW eats all updates!
  *)
  if Application.terminated then exit; //20160704 Igor
  if (Self.RetNo < 0) or (Self.RetNo >= RetList.Count) then exit; //20160711 Igor

  if not assigned(RetList[Self.RetNo]) then exit; //20160608 Igor

  //20160209 Igor >>>>
  //20161129 Igor >>>
//  if (Self.Parent is TTabSheet) AND
//     ((Self.Parent as TTabSheet).Parent is TPageControl) And
//     (((Self.Parent as TTabSheet).Parent as TPageControl).Align = alRight) then
  if Self.isAppendix then
  //20161129 Igor <<<
  begin
    zoom := RightZoom;
    R := True;
  end
  else
  begin
    zoom := FormZoom;
    R := False;
  end;
 //20160209 Igor <<<<<<
  if Self.Visible then //20160711 Igor
    LockWindowUpdate(Self.Handle);
  Color := RetList[RetNo].RetColor;
  //20160316Igor >>>>
  //20160407 Igor  (((  Dpi > 100%
//  if zoom <> MyZoom then
//  begin
//    ScaleBy(100, MyZoom);
//    ScaleBy(zoom, 100);
//    FMyZoom := zoom;
//  end;
//20170719 Igor>>>
  if (zoom <> MyZoom) or (FDFMPath = '') then
  begin
    if (MyZoom <> 100) or (FDFMPath = '') then
    begin
      fRefresh := True; //must reload data
      //clear and load DFM file - same procedure as in OpenForm!!!
      FDFMPath := RetList[RetNo].GetDfmFileName(FormName);
      DestroyComponents;
      DynArrays := nil;
      ReadComponentResFile(FDFMPath, self);
      FMyZoom := 100;
      //restore properties
      Color := GetRetColor(RetNo);
      //add dynamic components?
        //...
    end;
    //rescale form, current zoom factor is 100%
    if zoom <> 100 then
      ScaleBy(zoom, 100);
    FMyZoom := zoom;
    AfterOpenForm; //rescaled page breaks
  end;
  //20170719 Igor<<<

  //20160316 Igor<<<
  if fRefresh then
    PopulateFormWithData;
  //RetList[RetNo].MyChild.PopulateFormWithData(self);
  //20160711 Igor
  if (WindowLocks > 0) AND Self.Visible AND not R then
  Begin
    WindowLocks := 0;
    Windows.LockWindowUpdate(0);
  End;
  //Application.ProcessMessages; //20160314 Igor
  if ACallActiveFormChange and Not R then
    MainForm.GuiCommand(gcActiveFormChange); //20160305 Igor
  CompareFormLastYear; //20160316 Igor
end;

function TvtScrollBox.NoChild: boolean;
begin
  //init global variables?
    //MyScrollBox := self;
    //FormNameNo(RetNo,FormName); //???
  MyChild := RetList[RetNo].MyChild;
  Result := MyChild = nil;
{$IFDEF old}
  if Result then
    exit; //failed!

  MyChild.FormNameNo(FormName, FormNo);
{$ELSE}
  //somehting like currentChild, for use by ChildWin?
{$ENDIF}
end;

function TvtScrollBox.getFieldByTabOrder(tOrder: Integer): TWinControl;
var
  j: integer;
begin
  for j := 0 to ControlCount - 1 do
  begin
    TObject(Result) := Controls[j];
    if (Result is TwinControl)
      and (Result.TabOrder = tOrder) then
      exit;
  end; //end sBox.ComponentCount
  //not found
  result := nil;
end;

function TvtScrollBox.GetisDraft: Boolean;
begin
  Result := False;
end;

procedure TvtScrollBox.FormContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  s: string;
begin
  (* configure the popup - sender is always the ChildWin
    This works, but should delegate to ChildWin.FormContextPopup
  *)
  s := Sender.ClassName;
  if NoChild then
    //if NoFormInfo(TControl(Sender)) then
  begin
    Handled := True;
    exit;
  end;
  MyChild.OnContextPopup(Sender, MousePos, Handled);
end;

function TvtScrollBox.FormZoom: integer;
begin
  (* handle private/shared FormZoom option here?
    --> handled in TApp!
  *)
  //if private:
  if assigned(MyChild) AND Assigned(RetList[MyChild.RetNo].MyApp) then //20160608 Igor
    Result := RetList[MyChild.RetNo].MyApp.FormZoom
  else
    Result := 100;
end;

function TvtScrollBox.RightZoom: integer; //20160209 Igor
begin
  //20160704 Igor >>>
  result := 100;
  if not assigned(MyChild) then exit;
  if not assigned(RetList[MyChild.RetNo]) then exit;
  if not assigned(RetList[MyChild.RetNo].MyApp) then exit;
  //20160704 Igor <<<
  Result := RetList[MyChild.RetNo].MyApp.RightZoom;
end;

procedure TvtScrollBox.AfterOpenForm(ADestination: TvtDestination = vtdDisplay);
var
  I: Integer;
  CC: IvtConditionalControl; //20170321 Igor
begin
  (* detect page breaks (inherited) - after every ReadComponentResFile!
    add dynamic rows
    add image for mouse clicks
  *)
  //find page breaks
  inherited AfterOpenForm; //must determine MyChild!
  //add dynamic arrays
    //if (DynArrays = nil) and isFormDynamic(RetNo,FormName) then
  AddDynamicRowsToForm; //first row only, if not already initialized
  //20160314 Igor >>>>
  if RetList[Self.RetNo].IsLastYearReturn or RetList[Self.RetNo].isAppendix then
  Begin
    Self.ReadOnly := true;
    for I := 0 to Self.ComponentCount - 1 do
      if Self.Components[I] is TvtEdit then
        TvtEdit(Self.Components[I]).ReadOnly := true;
  End;
  //20160314 Igor <<<<
  //20170321 Igor >>>
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[I].GetInterface(IvtConditionalControl, CC) then
      CC.InvalidateConditionalValues(nil);
  end;
  //20170321 Igor <<<
  //20160407 Igor >>>>
  for I := 0 to Self.ComponentCount - 1 do
  begin
    if Self.Components[I] is TvtEdit then                       //20160805 Igor
      (Self.Components[I] as TvtEdit).OnChange := vtEditChange; //20160805 Igor
    if Self.Components[I] is TvtGroupBox then
    Begin
      if ADestination = vtdDisplay then
      Begin
        if TvtGroupBox(Self.Components[I]).Visible AND
           not TvtGroupBox(Self.Components[I]).vtDisplayed then
        Begin
          TvtGroupBox(Self.Components[I]).Visible := False;
        End
        else
        if not TvtGroupBox(Self.Components[I]).Visible AND
           TvtGroupBox(Self.Components[I]).vtDisplayed then
        Begin
          TvtGroupBox(Self.Components[I]).Visible := True;
        End
      End
      else
      if ADestination = vtdPrint then
      Begin
       if TvtGroupBox(Self.Components[I]).Visible AND
           not TvtGroupBox(Self.Components[I]).vtIsPrintable then
        Begin
          TvtGroupBox(Self.Components[I]).Visible := False;
        End
        else
        if not TvtGroupBox(Self.Components[I]).Visible AND
           TvtGroupBox(Self.Components[I]).vtIsPrintable then
        Begin
          TvtGroupBox(Self.Components[I]).Visible := True;
        End
      End;
    End;
  end;
  //20160407 Igor <<<<
end;

procedure TvtScrollBox.BeforeReadComponentResFile; //20161130 Igor
begin
  FDRAFTLabel := nil;
end;

procedure TvtScrollBox.AfterReadComponentResFile; //20160720 Igor

  function GetMaxWigthPlusScroll: Integer;
  var
    MaxX, J: Integer;
    ctx: TRttiContext;
    objType: TRttiType;
    Prop: TRttiProperty;
  Begin
    MaxX := 0;
    ctx := TRttiContext.Create;
    for J := 0 to Self.ControlCount - 1 do
    Begin
      if ((Self.Controls[J].Left + Self.Controls[J].Width) > MaxX)
          AND Self.Controls[J].Visible
          AND (Self.Controls[J].Align <> alTop)
          AND (Self.Controls[J].Align <> alBottom) then
      begin
        //20160612 Igor

        //exclude panels
        if Self.Controls[J] is TPanel then
          Continue;
        //Exclude noPrint Component
        objType := ctx.GetType(Self.Controls[J].ClassInfo);
        Prop := objType.GetProperty('vtIsPrintable');
        if Assigned(Prop) and
           not Prop.GetValue(Self.Controls[J]).AsBoolean then
          Continue;

        MaxX := Self.Controls[J].Left + Self.Controls[J].Width;
      end;
    End;
    Result := MaxX + GetSystemMetrics(SM_CXVSCROLL) + 16;
    ctx.Free;
  End;
begin
  FStartUsedWidth := GetMaxWigthPlusScroll;
  //20161130 Igor >>>
  if isDRAFT and not assigned(FDRAFTLabel) then
  begin
    FDRAFTLabel := TLabel.Create(Self);
    FDRAFTLabel.Font.Orientation := 30;
    FDRAFTLabel.Font.Size := 100;
    FDRAFTLabel.Font.Name := 'Times New Roman';
    FDRAFTLabel.Font.Style := [fsBold];
    FDRAFTLabel.Font.Color := RGB(200, 200, 200);
    FDRAFTLabel.AutoSize := true;
    FDRAFTLabel.Caption := 'D R A F T';
    FDRAFTLabel.Left := (Self.StartUsedWidth - FDRAFTLabel.Width) div 2;
    FDRAFTLabel.Top := 200;
    FDRAFTLabel.Parent := Self;
    FDRAFTLabel.Visible := False;
    FDRAFTLabel.SendToBack;
    FDRAFTLabel.Visible := True;
    FDRAFTLabel.Name := 'DRAFTLabel'; //20190122 Igor
  end;
  //20161130 Igor <<<

end;

function TvtScrollBox.AllowEditVertSeparator: Boolean;//20171226 Igor
begin
  Result := False;
end;

procedure TvtScrollBox.InitRow(ArrayNo, RowNo, BoxesPerRow: integer);
var
  i, n: integer;
  arr: TBoxRows;
begin
  arr := dynarrays[arrayNo].Rows;
  n := Length(arr);
  assert(n > RowNo, 'insufficient rows');
  SetLength(self.DynArrays[ArrayNo].Rows[RowNo], BoxesPerRow + 1); //include dummy [0]
  for i := 0 to BoxesPerRow do
    DynArrays[ArrayNo].Rows[RowNo, i] := nil;
end;

//20170407 Igor >>>

function CalcRowCount(const AForm: TvtScrollBox; const ATableNo, ABoxesPerRow: Integer): Integer;
var
  C: TObject;
  FieldID: Integer;
  MaxtTableElementID: Integer;
begin
  MaxtTableElementID := -1;
  for C in AForm do
  begin
    if C is TvtEdit then
    begin
      FieldID := TvtEdit(C).FieldId;
      if (FieldID >= (ArrayMul * ATableNo)) AND
         (FieldID < (ArrayMul * (ATableNo + 1))) AND
         (FieldID > MaxtTableElementID) then
        MaxtTableElementID := FieldID;
    end;
  end;
  Result := (((MaxtTableElementID mod ArrayMul) - 1) div ABoxesPerRow) + 1;
end;
//20170411 Igor >>>
function InitDynamic(const AForm: TvtScrollBox; var AData: TFormData;
  const AField: Integer; var AWorkTableNo, AWorkRow, AWorkCol, ARowCount: Integer): Boolean; overload;
var
  CellNo: Integer;
begin
  with AForm do
  begin
    if not isFormDynamic(RetNo, FormName) then
      exit;
    if DynArrays = nil then
      exit;
    if AField < ArrayMul then
      Exit(False);

    AData := RetList[RetNo].Frm[FormNo];

    AWorkTableNo := AField div ArrayMul;
    CellNo := AField mod ArrayMul;
    AWorkRow := ((CellNo - 1) div AData.FormDataRec.BoxesPerRow[AWorkTableNo]) + 1;
    AWorkCol := (CellNo mod AData.FormDataRec.BoxesPerRow[AWorkTableNo]);
    ARowCount := CalcRowCount(AForm, AWorkTableNo, AData.FormDataRec.BoxesPerRow[AWorkTableNo]);
    Result := True;
  end;
end;


function InitDynamic(const AForm: TvtScrollBox; var AData: TFormData;
  const AEdit: TvtEdit; var AWorkTableNo, AWorkRow, ARowCount: Integer): Boolean; overload;
var
  ColNo: Integer;
begin
  with AForm do
  begin
    if not Assigned(AEdit) then
      Exit;
    Result:= InitDynamic(AForm, AData, AEdit.FieldId, AWorkTableNo, AWorkRow, ColNo, ARowCount);
  end;
end;
//20170411 Igor <<<

procedure TvtScrollBox.InsertDynamicRowBefore(AEdit: TvtEdit);
var
  FData: TFormData;
  WorkTable, WorkRow, RowCount: Integer;
begin
  if not InitDynamic(Self, FData, AEdit, WorkTable, WorkRow, RowCount) then
    Exit;
  FData.InsertBeforeRowData(WorkTable, WorkRow);
  SyncRows(AEdit.FieldId);
  UpdateAfterSave;
end;
procedure TvtScrollBox.MoveDynamicRow(AEdit1, AEdit2: TvtEdit);
var
  FData: TFormData;
  WorkTable1, WorkRow1, RowCount1: Integer;
  WorkTable2, WorkRow2, RowCount2: Integer;
begin
  if not InitDynamic(Self, FData, AEdit1, WorkTable1, WorkRow1, RowCount1) then
    Exit;
  if not InitDynamic(Self, FData, AEdit2, WorkTable2, WorkRow2, RowCount2) then
    Exit;
  FData.MoveRow(WorkTable1, WorkRow1, WorkRow2);
  SyncRows(AEdit1.FieldId);
  UpdateAfterSave;
end;

procedure TvtScrollBox.MoveDynamicRow(AEdit: TvtEdit; ADirrection: TMoveDirection);
var
  FData: TFormData;
  WorkTable, WorkRow, RowCount: Integer;
  NewRow: array of string;
begin
  if not InitDynamic(Self, FData, AEdit, WorkTable, WorkRow, RowCount) then
    Exit;
  case ADirrection of
    mdUp:
      begin
        if (WorkRow = 1) or
           (WorkRow = RowCount) then
          exit;
        FData.SwapRow(WorkTable, WorkRow, WorkRow - 1);
      end;
    mdDown:
      begin
        if WorkRow >= (RowCount - 1) then
          exit;
        FData.SwapRow(WorkTable, WorkRow, WorkRow + 1);
      end;
    mdRemove:
      begin
        if WorkRow = RowCount then
        begin
          MessageDlg('You can not delete the last row in the table.', mtWarning, [mbOk], 0);
          exit;
        end;
        if MessageDlg('Delete row?', mtConfirmation, [mbYes, mbCancel], 0) <> mrYes then
          exit;
        FData.DeleteRowData(AEdit.FieldId);
      end;
//20170411 Igor >>>
    mdWithRequest:
      begin
        if RowCount <= 2 then
          Exit;
        if WorkRow = RowCount then
          Exit;
        SetLength(NewRow, 1);
        NewRow[0] := IntToStr(WorkRow);
        if InputQuery('Move row', ['New position (min - 1; max - '+IntToStr(RowCount - 1)+')'], NewRow,
          function (const Values: array of string): Boolean
          var
            NRow: Integer;
          begin
            if not TryStrToInt(Values[0], NRow) then
            Begin
              MessageDlg('Please, enter correct line number.', mtError, [mbOk], 0);
              exit(False);
            End;
            if (NRow < 1) or (NRow > (RowCount - 1)) then
            begin
              MessageDlg('Please, enter line number between 1 and '+IntToStr(RowCount - 1)+'.', mtError, [mbOk], 0);
              exit(false);
            end;
            if (NRow = WorkRow) then
            begin
              MessageDlg('Please enter a line number that is different from the current.', mtError, [mbOk], 0);
              exit(false);
            end;
            Result := True;
          end) then
        Begin
          FData.MoveRow(WorkTable, WorkRow, StrToInt(NewRow[0]));
        End;
//20170411 Igor <<<
      end;
  end;
  SyncRows(AEdit.FieldId);
  UpdateAfterSave;
end;
//20170407 Igor <<<

//20170411 Igor >>>
function TvtScrollBox.SameTable(AField1, AField2: Integer): Boolean;
var
  FData: TFormData;
  WorkTable1, WorkRow1, WorkCol1, RowCount1: Integer;
  WorkTable2, WorkRow2, WorkCol2, RowCount2: Integer;
begin
  if not InitDynamic(Self, FData, AField1, WorkTable1, WorkRow1, WorkCol1, RowCount1) then
    Exit(False);
  if not InitDynamic(Self, FData, AField2, WorkTable2, WorkRow2, WorkCol2, RowCount2) then
    Exit(False);
  Result := WorkTable1 = WorkTable2;
end;

function TvtScrollBox.SameColumn(AField1, AField2: Integer): Boolean;
var
  FData: TFormData;
  WorkTable1, WorkRow1, WorkCol1, RowCount1: Integer;
  WorkTable2, WorkRow2, WorkCol2, RowCount2: Integer;
begin
  if not InitDynamic(Self, FData, AField1, WorkTable1, WorkRow1, WorkCol1, RowCount1) then
    Exit(False);
  if not InitDynamic(Self, FData, AField2, WorkTable2, WorkRow2, WorkCol2, RowCount2) then
    Exit(False);
  Result := WorkCol1 = WorkCol2;
end;

function TvtScrollBox.isLastRow(AFieldID: Integer): Boolean;
var
  FData: TFormData;
  WorkTable, WorkRow, WorkCol1, RowCount: Integer;
begin
  if not InitDynamic(Self, FData, AFieldID, WorkTable, WorkRow, WorkCol1, RowCount) then
    Exit(False);
  Result := WorkRow = RowCount;
end;
//20170411 Igor <<<

procedure TvtScrollBox.AddDynamicRowsToForm;
var
  FRec: TFRec;
  FData: TFormData;
  ia, ir, i, ElmNo, BoxesPerRow, MaxRow: integer;
  cmp: TComponent;
  MyEditBox: TvtEdit absolute cmp;
  //arr: TBoxArray;
begin
  (* Init dyn data array management
    add dynamic rows
    after rescale: create additional/delete excess rows?
  *)
  if not isFormDynamic(RetNo, FormName) then
    exit;
  if DynArrays <> nil then
    exit; //already initialized

  FData := RetList[RetNo].Frm[FormNo];
  FRec := FData.FormDataRec;
  //create and init all arrays in the form
  DynArrays := nil; //destroy old arrays
  NumArrays := high(FRec.BoxesPerRow);
  SetLength(DynArrays, NumArrays + ArrayBase);
  //init arrays and first(?) row
  for ia := 1 to NumArrays do
  begin
    MaxRow := FData.MaxRow(ia);
    BoxesPerRow := FRec.BoxesPerRow[ia];
    with DynArrays[ia] do
    begin
      MaxBox := BoxesPerRow;
      //Row0Top := maxint;
      //Row0Bottom := 0;
      //SetLength(Rows, MaxRow+1); //alloc all rows, zero based
      SetLength(Rows, 1); //alloc first row only, extend when controls are created!
    end;
    //init first row
    InitRow(ia, 0, BoxesPerRow); //set to Nil
  end;
  //move components into array - assume 1 row only existing?
  for i := 0 to ComponentCount - 1 do
  begin
    cmp := Components[i];
    if cmp.ClassType <> TvtEdit then
      continue;
    ElmNo := MyEditBox.FieldId;
    if ElmNo < ArrayMul then
      continue; //not in array
    SplitDynId(RetNo, FormNo, ElmNo);
    //assert(RowNo=0,'invalid dynamic FieldId '+MyEditBox.Name);
    //if RowNo > 0 then continue? //ignore, for now???
    with DynArrays[ArrayNo] do
    begin
      Rows[RowNo, DynElmIdx] := MyEditBox;
    end;
  end;
  //adjust boxes within frame
  for ia := 1 to NumArrays do
  begin
    //add rows as required
    MaxRow := FData.MaxRow(ia); // high(FData.Dyn[ia]);
    if MaxRow > 0 then //row 0 already initialized
      AddRows(ia, MaxRow);
  end;
end;

procedure TvtScrollBox.AddRows(ArrayNo, NewTop: integer);
//procedure TvtScrollBox.AddRows(r0: TvtDynRow; NewTop: integer);
var
  i, TopRow, RowDiff: integer;
  ir, FieldId: integer;
  arr: TBoxArray; //NOT valid for SetLength!
  r0Box, MyEditBox: TvtEdit;
begin
  (* add or delete as many rows to the array as required,
    move further components down.

    For internal and external use.
    Array data insert/remove must be handled by caller!
  *)
  //sanity check
  if NewTop < 0 then
  begin
    ErrorMsg('Cannot delete dynamic array');
    exit;
  end;

  arr := DynArrays[ArrayNo];
  TopRow := high(arr.Rows); //DynArrays[r0.ArrayNo]);
  RowDiff := NewTop - TopRow; //+ expand down
  if RowDiff = 0 then
    exit; //nothing to do
  if NewTop < TopRow then
  begin //shrink
    //destroy excess rows, shrink DynArray
    for ir := TopRow downto NewTop + 1 do
    begin
      for i := 1 to high(arr.Rows[ir]) do
        arr.Rows[ir, i].Free;
    end;
    SetLength(DynArrays[ArrayNo].Rows, NewTop + 1);
    //move components up
    MyEditBox := arr.Rows[NewTop, 1];
    PushComponentsUpOrDown(MyEditBox.Top, MyEditBox.Height * (NewTop - TopRow));
    exit;
  end;

  //extend
  //move components down
  MyEditBox := arr.Rows[TopRow, 1];
  if assigned(MyEditBox) then //20160516 Igor
    PushComponentsUpOrDown(MyEditBox.Top, MyEditBox.Height * (NewTop - TopRow));
  //extend DynArrays
  SetLength(DynArrays[ArrayNo].Rows, NewTop + 1);
  //create as many clones as needed, up to RNo
  for ir := TopRow + 1 to NewTop do
  begin
    SetLength(DynArrays[ArrayNo].Rows[ir], arr.MaxBox + 1); // ,NewTop+1);
    //arr := DynArrays[ArrayNo].Rows[ir];
    for i := 0 to arr.MaxBox do // high(arr.Rows[ir]) do
    begin
      r0Box := arr.Rows[0, i];
      if r0Box = nil then
        continue; //gaps?
      FieldId := ArrayNo * ArrayMul + arr.MaxBox * ir + i;
      MyEditBox := r0Box.Clone;
      DynArrays[ArrayNo].Rows[ir, i] := MyEditBox;
      MyEditBox.Name := 'vtEdit' + IntToStr(FieldId);
      MyEditBox.Top := r0Box.top + ir * r0Box.Height; //!scaled values!
      MyEditBox.Parent := self; //required to enable TabStop/TabOrder
      MyEditBox.Color := r0Box.Color; //20160405 Igor
      MyEditBox.Font.Assign(r0Box.Font); //20160405 Igor
      if r0Box.TabStop then
      begin
        MyEditBox.TabStop := True;
        MyEditBox.TabOrder := r0Box.TabOrder + ir * arr.MaxBox;
      end;
      //MyEditBox.Tag:=FirstRowBoxes[k].Tag + BoxesPerRow;  //20111231
      MyEditBox.Text := FetchElm(RetNo, FormNo, FieldId); //bring existing value
      MyEditBox.Visible := True;
      //20170609 igor >>>
      if r0Box.vtDataSource = TDataSource.vtOverride then
      Begin
        MyEditBox.vtDataSource := TDataSource.vtCalc;
        MyEditBox.vtPrefix := '';
      End;
      //20170609 igor <<<
    end;
    //PushComponentsUpOrDown(MyEditBox.Top, MyEditBox.Height);
  end;
end;

procedure TvtScrollBox.SyncRows(FieldId: integer);
begin
  (* called after row data have been adjusted
  *)
  if SplitDynId(RetNo, FormNo, FieldId) then
  begin
    AddRows(ArrayNo, TopRow); //as determined from RetData
    MyChild.UpdateAfterSave(FormName);
  end;
end;

procedure TvtScrollBox.PushComponentsUpOrDown(StartingSpot,
  PushAmount: Integer);
var
  i: integer;
  cmp: TComponent;
  ctl: TControl absolute cmp;
  wctl: TWinControl;

  NextPageBrack: Integer; //20160203 Igor
  NextPageFooter: Integer; //20160203 Igor

  z: Integer; //20160404 Igor
  function AllowMove(ACtrl: TControl):Boolean;  //20160203 Igor
  Begin
    if (ACtrl is TvtShape) then
      if (ACtrl as TvtShape).vtPageBreak or
         (ACtrl as TvtShape).vtPageFooter then
      Begin
        result := False;
        exit;
      End;
    if ((ACtrl is TRichEdit) AND
        ((ACtrl as TRichEdit).Name = '')) then
    Begin
      result := False;
      exit;
    End;
    Result := (ACtrl.Top > StartingSpot) AND (ACtrl.Top < NextPageBrack) AND (ACtrl.Top < NextPageFooter);
  end;
begin
  NextPageBrack := MaxInt; //20160203 Igor
  NextPageFooter := MaxInt; //20160203 Igor
  for i:= ComponentCount-1 DownTo 0 do //20160203 Igor
  Begin
    if (Components[i] is TvtShape) then
     if (Components[i] as TvtShape).top > StartingSpot then
       if (Components[i] as TvtShape).vtPageBreak AND
          ((Components[i] as TvtShape).Top < NextPageBrack) then
          NextPageBrack := (Components[i] as TvtShape).Top
        else
        if (Components[i] as TvtShape).vtPageFooter AND
           ((Components[i] as TvtShape).Top < NextPageFooter) then
          NextPageFooter := (Components[i] as TvtShape).Top;
  end;

  for i := 0 to ComponentCount - 1 do
  begin
    cmp := Components[i];
    if not (cmp is TControl) then
      continue;
    if AllowMove(ctl) then //20160203 Igor
    begin
      if ctl is TvtLabel then //20160405 Igor
        TvtLabel(ctl).Top := TvtLabel(ctl).Top + PushAmount
      else
        ctl.Top := ctl.Top + PushAmount;
      if (ctl.Top + ctl.Height) > min(NextPageBrack,NextPageFooter) then
      Begin
        for z := ComponentCount-1 downto 0 do
        Begin
          if (Components[z] is TControl) AND
             (Components[z] <> cmp)  AND
             ((Components[z] as TControl).Top >= min(NextPageBrack,NextPageFooter)) then
          Begin
            if not((Components[z] is TRichEdit) AND
                   ((Components[z] as TRichEdit).Name = '')) then
            Begin
              if Components[z] is TvtLabel then  //20160405 Igor
                TvtLabel(Components[z]).Top := TvtLabel(Components[z]).Top + PushAmount
              else
                (Components[z] as TControl).Top := (Components[z] as TControl).Top + PushAmount;
            end;
          end;
        end;
        if NextPageBrack <> MaxInt then
          NextPageBrack := NextPageBrack + PushAmount;
        if NextPageFooter <> MaxInt then
          NextPageFooter := NextPageFooter + PushAmount;
      end;
    end;
  end;

end;

procedure TvtScrollBox.ShowFormData;
begin
  PopulateFormWithData;
end;

procedure TvtScrollBox.FormatDollar(MyEditBox: TvtEdit; str: string);
begin
  OVR('FormatDollar');
end;

{$IFDEF old}

procedure TvtScrollBox.FormClick(Sender: TObject);
begin
  ...
end;

procedure TvtScrollBox.Keys(var Key: Word; Shift: TShiftState);
begin

end;
{$ELSE}
{$ENDIF}

function TvtScrollBox.GetLinkedForm(FieldId: Integer;
  var TargetLinkedField: Integer): string;
begin
  OVR('GetLinkedForm');
end;

function TvtScrollBox.GetNoCompare: Boolean; //20160320 Igor
var
  SL: TStringList;
begin
  if FNoCompare = -1 then
  Begin
    if FileExists(RetList[Self.RetNo].MyApp.AppDir+'\'+NoCompareD) then
    Begin
      SL := TStringList.Create;
      SL.LoadFromFile(RetList[Self.RetNo].MyApp.AppDir+'\'+NoCompareD);
      SL.Text := AnsiUpperCase(SL.Text);
      if SL.IndexOf(AnsiUpperCase(ExtractNonInstFormName(Self.FormName)))>=0 then
        FNoCompare := 1
      else
        FNoCompare := 0
    End
    else
      FNoCompare := 0;
  End;
  Result := FNoCompare = 1;
end;

procedure TvtScrollBox.RebuildDynamicRows; //20160527 Igor
var
  ia, MaxRow: Integer;
begin
  for ia := 1 to NumArrays do
  begin
    MaxRow := RetList[RetNo].Frm[FormNo].MaxRow(ia);
    AddRows(ia, MaxRow);
  end;
end;

procedure TvtScrollBox.Repaint;
begin
  if WindowLocks = 0 then
    inherited Repaint;
end;

procedure TvtScrollBox.Update;
begin
  if WindowLocks = 0 then
    inherited;
end;

procedure TvtScrollBox.FormatEditBoxText(MyEditBox: TvtEdit; str: string);
begin
  (* override for special formatting
  *)
  case MyEditBox.vtInputType of
    vtDollar: //app specific!!!
      FormatDollar(MyEditBox, str);
    vtSin:
      MyEditBox.Text := ReformatSin(str);
  else //case
    MyEditBox.Text := str;
  end;
end;

{ TMyChild }

constructor TMyChild.CreateNew(AOwner: TComponent; RNo: Integer);
begin
  inherited;
  TMyChild.ChildCount := TMyChild.ChildCount + 1; //20170606 Igor
  FRetNo := RNo;
  RetList[RNo].MyChild := self;
  FMyPageControl := TPageControl.Create(self);
  MyPageControl.Align := alClient;
  MyPageControl.Parent := self;
  //MyPageControl.OnChange := OnTabChange;
  MyPageControl.OnChange := MyPageControlChange;
  MyPageControl.OnChanging := MyPageControlChanging;
  Self.OnMouseWheel := FormMouseWheel;  //20160720 Igor
  AddPropertiesAndEvents;
//  inc(ChildCount);//20170606 Igor
  MainForm.TileMaximize; //always create maximized - delay to prevent flicker!!!
end;

procedure TMyChild.PageControlMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);  //20160314 Igor
begin
  if not Assigned(Self) then exit;
  if Assigned(RetList[RetNo]) and SameText((Sender as TPageControl).ActivePage.Caption, RetList[RetNo].MyApp.FirstForm) then Exit; //20180111 Igor
  if not(Sender as TWinControl).Dragging AND (GetKeyState(VK_LBUTTON) < 0) then
  Begin
    AMouseDown := False;
    (Sender as TWinControl).BeginDrag(true);
  End;
end;


//20160113 Igor
procedure TMyChild.PageControlDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=True;
end;
//20160113 Igor
procedure TMyChild.PageControlDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  i, FNo: integer;
  FName: string;
begin
  if Source is TTabControl then
  Begin
    if Source <> Sender then
    begin
      i := TTabControl(Source).TabIndex;
      FName := TTabControl(Source).Tabs[i];
      if FName = '' then
        exit; //what?
      FNo := RetList[RetNo].GetFormNo(FName);
      OpenForm(RetNo,FName,0);

      TTabControl(Source).Tabs.Delete(i);
      TTabControl(Source).TabIndex := I - 1;
      for I := TPageControl(sender).PageCount - 1 downto 0 do
        if TPageControl(sender).Pages[i].Tag = -123 then
          TPageControl(sender).Pages[i].Free;
      RetList[RetNo].MyApp.DelReviewDynamicForm(FName); //20160220 Igor
      for i := TTabControl(Source).Parent.ComponentCount - 1 downto 0 do
      begin
        if TTabControl(Source).Parent.Components[i] is TvtScrollBox then
        begin
          if (TvtScrollBox(TTabControl(Source).Parent.Components[i]).FormNo = FNo) then
          Begin
            TvtScrollBox(TTabControl(Source).Parent.Components[i]).Free;
            break;
          End;
        end;
      end;
      TTabControl(Source).OnChange(Source);
    end;
  End;
end;

function TMyChild.CreateNewTab(FNo: integer; FName: string): TTabSheet;
var
  MyTabSheet: TTabSheet;
begin
  //create a new TabSheet for a tax form
  MyTabSheet := TTabSheet.Create(Self); //?
  MyTabSheet.Visible := True;
  MyTabSheet.PageControl := Pages;
  MyTabSheet.Caption := FName;
  MyTabSheet.parent := Pages;
  MyTabSheet.Tag := FNo; //remember the form number?

//  MyTabSheet.onMouseDown:=PageControlMouseDown;
//  MyTabSheet.onMouseUp:=PageControlMouseUp; //20160314 Igor
//  MyTabSheet.onMouseMove:=PageControlMouseMove; //20160314 Igor
//  MyTabSheet.onDragOver:=PageControlDragOver;
//  MyTabSheet.onDragDrop:=PageControlDragDrop;
//  Pages.onMouseDown:=PageControlMouseDown;
//  Pages.onMouseUp:=PageControlMouseUp;  //20160314 Igor
  Pages.onMouseMove:=PageControlMouseMove; //20160314 Igor
  Pages.onDragOver:=PageControlDragOver;
  Pages.onDragDrop:=PageControlDragDrop;

  //MyTabSheet.DragMode:=dmAutomatic;
  //Pages.DragMode:=dmAutomatic;

  //Pages.Dragging:=true;
  //MyTabSheet.Dragging:=true;
  //Pages.
  //MyTabSheet.al


  Pages.ActivePage := MyTabSheet;
  Result := MyTabSheet;
{$IFDEF old}
  //init globals?
    //vtShared.FormNameNo(RetNo,FName); //may be required in further processing?
  FormNameNo(FName, FNo);
  UpdateFormHeaderFrame;
{$ELSE}
  //ensure called when child/tab is activated!
{$ENDIF}
end;

function TMyChild.ActiveForm: TvtScrollBox;
var
  Sheet: TTabSheet;
  i: integer;
begin
  Result := nil;
  if Self = nil then
    exit;
  if not assigned(Pages) then
    exit;
  Sheet := Pages.ActivePage;
  if Sheet <> nil then
  begin
    for i := 0 to Sheet.ControlCount - 1 do
    begin
      if Sheet.Controls[i] is TvtScrollBox then
        Result := TvtScrollBox(Sheet.Controls[i]);
      exit;
    end;
  end;
end;

function TMyChild.FormName: string; //20180104 Igor
begin
  if Assigned(Pages) then
    Result := Pages.ActivePage.Caption
  else
    Result := '';
end;

function TMyChild.FormNo: integer; //20180104 Igor
begin
  if Assigned(Pages) then
    Result := Pages.ActivePage.Tag
  else
    Result := 0;
end;

function TMyChild.GetForm(FNo: integer; MakeActive: boolean): TvtScrollBox;
var
  i: integer;
begin
  (* Return an already existing form, Nil if not exists yet.
    If MakeActive then activate the page
  *)
  for i := 0 to Pages.PageCount - 1 do
  begin
    if Pages.Pages[i].Tag = FNo then
    begin
      Result := Pages.Pages[i].Controls[0] as TvtScrollBox;
      if MakeActive then
        Pages.ActivePageIndex := i;
      exit;
    end;
  end;
  //not found
  Result := nil;
end;

function TMyChild.GetPageScrollBox(APage: TTabSheet): TvtScrollBox;
var
  j: integer;
  ctl: TControl;
begin
  for j := 0 to APage.ControlCount - 1 do
  begin
    ctl := APage.Controls[j];
    if ctl is TvtScrollBox then
    begin
      Result := TvtScrollBox(ctl);
      exit;
    end;
  end;
  //not found
  Result := nil;
end;

function TMyChild.GetScrollbox(FName: string): TvtScrollBox;
var
  i: integer;
begin
  for i := 0 to Pages.PageCount - 1 do
  begin
    if Pages.Pages[i].Caption = FName then
    begin
      Result := GetPageScrollBox(Pages.Pages[i]);
      exit;
    end;
  end;
  //not found
  Result := nil;
end;

function TMyChild.GetScrollbox(FNo: integer): TvtScrollBox;
var
  i: integer;
begin
  for i := 0 to Pages.PageCount - 1 do
  begin
    if Pages.Pages[i].Tag = FNo then
    begin
      Result := GetPageScrollBox(Pages.Pages[i]);
      exit;
    end;
  end;
  //not found
  Result := nil;
end;

procedure TMyChild.OVR(MethName: string);
begin
  ErrorMsg('Override ' + ClassName + '.' + MethName);
end;

procedure TvtScrollBox.OVR(MethName: string);
begin
  ErrorMsg('Override ' + ClassName + '.' + MethName);
end;

procedure TvtScrollBox.DataChangeRtn;
begin
  (* Override to perform calculations...
  *)
  OVR('DataChangeRtn');
end;

procedure TvtScrollBox.ChangeProperties(MyEditBox: TvtEdit; Elm: Integer);
begin
  if OvrOn(RetNo, FormNo, MyEditBox.FieldId) then
  begin
    MyEditBox.vtDataSource := vtOverride;
    //20170612 Igor >>>
    // if not allowed override
    if MyEditBox.vtDataSource <> vtOverride then
      RemoveFieldOverride(RetNo, FormNo, MyEditBox.FieldId)
    else
    //20170612 Igor <<<
      MyEditBox.vtPrefix := '*';
  end;
end;

procedure TvtScrollBox.CompareFormLastYear;
var
  I: Integer;
begin
  if Self.LYRetNo <> 0 then
  Begin
    for I := 0 to Self.ComponentCount - 1 do
      if Self.Components[I] is TvtEdit then
        CompareEditBoxLastYear(TvtEdit(Self.Components[I]));
  End
  else
  if (RetList[Self.RetNo].IsLastYearReturn or RetList[Self.RetNo].IsAppendix) then //20160608 Igor
    if RetList[GetCurrentRetNo].LastYearRetNo = Self.RetNo then
      if Assigned(RetList[GetCurrentRetNo].MyChild) AND
         (RetList[GetCurrentRetNo].MyChild.ActiveForm <> nil) AND
         (RetList[GetCurrentRetNo].MyChild.ActiveForm.LYFormNo = Self.FormNo) then
        RetList[GetCurrentRetNo].MyChild.ActiveForm.CompareFormLastYear;
end;

procedure TMyChild.UpdateChildTaxPanel;
begin
  OVR('UpdateChildTaxPanel');
end;

procedure TMyChild.UpdateFormHeaderFrame;
begin
  (* Every AppId has its own FormHeaderFrame, MUST override!
    Use UpdateSectionButtons for common handling
  *)
  OVR('UpdateFormHeaderFrame');
end;

function TMyChild.UpdateSectionButtons(MyFormHeaderFrame: TFrame): boolean;
var
  i, MxPg: integer;
  cmp: TComponent;
  sbox: TvtScrollBox;
  FormName: string;
  FormNo: integer;
begin
  (* Common part of UpdateFormHeaderFrame
  *)
  Result := False;
  if RetNo < 1 then
    exit;
  if Pages.ActivePageIndex < 0 then
    exit;

  FormName := Pages.ActivePage.Caption;
  FormNo := Pages.ActivePage.Tag;

  sbox := GetScrollbox(FormName);
  if sbox = nil then
    exit; //MxPg:=GetFormMxPg(FormName); //unreliable!
  MxPg := sbox.GetMaxPg;

  Result := True; //valid

  i := 1;
  { TODO : loop over components? }
  while i < 30 do
  begin
    cmp := MyFormHeaderFrame.FindComponent('Pg' + IntTostr(i));
    if cmp = nil then
      break; //no more page buttons
    with cmp as TPanel do
    begin
      Font.Color := $00041D80;  //20160721 Igor
      if MxPg < 2 then
        visible := False
      else
        Visible := i <= MxPg;
    end;
    inc(i);
  end;
end;

function TvtScrollBox.ValidateField(FieldId: integer; var Value: string): boolean;
begin
  (* Validate/reformat value
  *)
  OVR('ValidateField');
  Result := False; //deny exit...
end;

procedure TvtScrollBox.vtEditChange(Sender: TObject); //20160805 Igor
begin
  if TvtEdit(Sender).Focused AND
     IsProtectedField(TvtEdit(Sender)) and
     TvtEdit(Sender).Modified then
  begin
    if TvtEdit(Sender).vtDataSource = vtCalc then
    begin
      //which field types can be overridden? --> vtCalc only
      //2070612 Igor >>>
      if TvtEdit(Sender).vtAllowOverride AND
         (MessageDlg('Protected field - override?', mtConfirmation, mbOKCancel, 0) = mrOk) then //start override
        ToggleOverride(TvtEdit(Sender))
      else
      begin
        TvtEdit(Sender).OnChange := Nil;
        TvtEdit(Sender).Undo;
        TvtEdit(Sender).ClearUndo;
        TvtEdit(Sender).Modified := False;
        TvtEdit(Sender).OnChange := vtEditChange;
      end;
      //2070612 Igor <<<
    end
    else
    begin
      TvtEdit(Sender).OnChange := Nil;
      TvtEdit(Sender).Undo;
      TvtEdit(Sender).ClearUndo;
      TvtEdit(Sender).Modified := False;
      TvtEdit(Sender).OnChange := vtEditChange;
      ShowTimedMsg('Protected field', 1000);
    end;
  end;
end;

procedure TvtScrollBox.WMHScroll(var Msg: TMessage);
begin
  Inherited;
  ScrollSender := Self.Handle;
  MainForm.GuiCommand(gcScroll);
end;

procedure TvtScrollBox.WMVScroll(var Msg: TMessage);
begin
  Inherited;
  ScrollSender := Self.Handle;
  MainForm.GuiCommand(gcScroll);
end;

procedure TMyChild.AddDeferredOpenForm(const AFormName: String);//20170719 Igor
var
  s: String;
begin
  for S in FDifferedOpenForms do
    if SameText(S, AFormName) then
      exit;
  SetLength(FDifferedOpenForms, length(FDifferedOpenForms) + 1);
  FDifferedOpenForms[length(FDifferedOpenForms) - 1] := AFormName;
end;

procedure TMyChild.AddPropertiesAndEvents;
begin
  //must override
  VertScrollBar.Tracking := True;
  HorzScrollBar.Tracking := True;
  VertScrollBar.Position := 0;
  KeyPreview := True;
  //OnDblClick := FormDblClick;
  OnKeyDown := FormKeyDown;
  OnKeyPress := FormKeyPress;
{$IFDEF old}
  OnClick := FormClick; //also in ScrollBox!
{$ELSE}
{$ENDIF}
  OnClose := FormClose;
  OnActivate := FormActivate;
end;

procedure TMyChild.SetColor(clr: TColor);
var
  i, j: integer;
  MyScrollBox: TvtForm;
  Sheet: TTabSheet;
begin
  (* no need to override
  *)
  Color := clr;
  for i := 0 to Pages.PageCount - 1 do
  begin
    Sheet := Pages.Pages[i];
    for j := 0 to Sheet.ControlCount - 1 do
    begin
      if Sheet.Controls[j] is TvtForm then
      begin
        MyScrollBox := TvtForm(Sheet.Controls[j]);
        MyScrollBox.Color := clr;
        break;
      end;
    end;
  end;
  //20160523 Igor >>>
  for I := 0 to FloatingForms.Count - 1 do
  Begin
    if Assigned(FloatingForms.GetForm(I)) then
      FloatingForms.GetForm(I).Color := clr;
  End;
  //20160523 Igor <<<

end;

procedure TMyChild.BringExistingTabSheetToFront(FName: string; FNo,
  Elm: Integer);
var
  MyScrollBox: TvtForm;
begin
  MyScrollbox := GetForm(FNo, True); //also activate it
  CalcNo(RetNo, FNo);
  ShowFormData(FName, FNo);
  MyScrollBox.FocusOnElm(Elm);
end;

function TvtScrollBox.ReplaceString(FieldId: Integer; NewString: string): boolean;
//Procedure ReplaceString(FormNo:integer;FieldId:Integer;NewString:string);
begin
  Result := NewString <> '';
  if not Result then
    exit;

  with RetList[RetNo] do
  begin
    StoreElm(RetNo, FormNo, FieldId, NewString); //2004
    Changed := True;
    CalcStatus := False; //T2: all provinces
    Calc(RetNo, FormName, FormNo); //T1: CalcAll
  end;
end;

procedure TMyChild.ShowAllControls(ADeferred: Boolean = True); //20170718 Igor
var
  I: Integer;
begin
  if ADeferred then
    MainForm.GuiCommand(gcShowAllControls)
  else
  begin
    for I := 0 to Self.ControlCount - 1 do
      Self.Controls[I].Visible := True;
    //20170619 Igor >>>
    if Self <> Application.MainForm.ActiveMDIChild then
      Self.BringToFront;
    //20170619 Igor <<<
    FControlHides := False;
  end;
end;

procedure TMyChild.ShowFormData(FName: string; FNo: Integer);
var
  MyScrollBox: TvtScrollBox;
begin
  (* override to show last year data (T1)
    Somewhat equivalent to OpenForm, but ignored when the form is not already shown.
  *)
  {moved into OnExit
    Caption:=RetList[RetNo].GetReturnCaption;
    MainForm.GuiCommand(gcReturns);
  }
  MyScrollBox := GetForm(FNo, True);
  if MyScrollBox = nil then
    exit; //something wrong after add/remove dynamic row!
  //If IsFormAClientLetter(FName) then MyScrollBox.Color:=clWhite; - T1!
  //made this another method, usable with floating forms
//PopulateFormWithData(MyScrollBox);
  MyScrollBox.Activated(True);
  //ShowAllReviewMarks(self,RetNo,FName,FNo);
end;

procedure TMyChild.RefreshActiveForm;
begin
  GetActiveForm.Activated(True);
end;

procedure TvtScrollBox.ShowFieldData(MyEditBox: TvtEdit);
var
  //fld,jj,PenWidth,HowToFormat:Integer;R:TRect;
  fld: Integer;
  //FormattedAmount:String;
  ErrMsg: TAuditRec; //:String;
  EditBoxColr: TColor;
  ErrState: TvtErrorState; //20160301 Igor

  //Function GetFieldFontColor(MyEditBox:TVtEdit;FieldMsg:String;FormColor:TColor):TColor;

  function GetFieldFontColor: TColor;
  begin
    case ErrMsg.Category of
      'M',
        'E': result := clYellow;
      'W': Result := LightGreen
    else
      Result := clWhite;
    end;
  end;
  function GetErrorState: TvtErrorState; //20160301 Igor
  Begin
    case ErrMsg.Category of
      'M': Result := esMandatory;
      'E': result := esError;
      'W': Result := esWarning;
    else
      Result := esNone;
    end;
  End;
begin
//20170427 Igor >>>
  if Application.Terminated then
    exit;
//20170427 Igor <<<
  (* take into account audits: edit.Hint, back color
  *)
  Fld := MyEditBox.FieldId;
  MyEditBox.Font.color := SetEditBoxFontColor(MyEditBox);

  ErrMsg := RetList[RetNo].AuditList.GetHint(FormName, fld);
  if ErrMsg = nil then
  begin
    MyEditBox.Hint := '';
    EditBoxColr := clWhite;
    ErrState:= esNone; //20160301 Igor
  end
  else
  begin
    MyEditBox.Hint := ErrMsg.Description;
    EditBoxColr := GetFieldFontColor; //(MyEditBox,ErrMsg);
    ErrState := GetErrorState; //20160301 Igor
  end;
  //SetAttributesWhenDepends(MyEditBox,RetNo,GetFormName(FNo),FNo,Fld);
  ChangeProperties(MyEditBox, Fld);

  if ReviewOn(RetNo, FormNo, fld) then
  Begin
    MyEditBox.Color := ReviewMarkColor;
    MyEditBox.vtErrorState := esNone; //20160301 Igor
  end
  else
  Begin
    MyEditBox.Color := EditBoxColr;
    MyEditBox.vtErrorState := ErrState; //20160301 Igor
  end;

  if ShowFieldIdSw then
    MyEditBox.Text := '[' + IntToStr(Fld) + ']'
  else
  begin
{$IFDEF old}
    MyEditBox.Text := FetchElmFNo(RetNo, FormNo, Fld); //for proper reformat!
    case MyEditBox.vtInputType of
      vtDollar: //app specific!!!
        FormatDollar(MyEditBox);
      vtSin:
        MyEditBox.Text := ReformatSin(MyEditBox.Text);
      //else //case
        //MyEditBox.Text:= FetchElmFNo(RetNo,FNo,Fld);
    end;
{$ELSE}
    FormatEditBoxText(MyEditBox, FetchElmFNo(RetNo, FormNo, Fld)); //fully virtual
{$ENDIF}

    if RetList[RetNo].MyApp. {OptRec.} DataInBold = True then
      MyEditBox.Font.Style := [fsBold]
    else
      MyEditBox.Font.Style := [];
  end;
  MyEditBox.Refresh;

  //20160314 Igor >>>>>
  if RetList[RetNo].LastYearRetNo <> 0 then
  Begin
    CompareEditBoxLastYear(MyEditBox);
  end;
  //20160314 Igor <<<<

end;

procedure TvtScrollBox.CompareEditBoxLastYear(MyEditBox: TvtEdit); //20160316 Igor
var
  LYEditBox: TvtEdit; //20160314 Igor
  LYForm: TvtScrollBox; //20160314 Igor
Begin
  if Self.NoCompare then exit;

  LYForm := FloatingForms.FindForm(Self.LYRetNo, Self.LYFormNo); //20160316 Igor

  if Assigned(LYForm) then
  Begin
    LYEditBox := nil;
    if Assigned(LYForm.FindComponent(MyEditBox.Name)) AND
       (LYForm.FindComponent(MyEditBox.Name) is TvtEdit) then
      LYEditBox := (LYForm.FindComponent(MyEditBox.Name) as TvtEdit);
    if Assigned(LYEditBox) then
    Begin
      if sameText(RetList[LYForm.RetNo].Frm[LYForm.FormNo].Elms[LYEditBox.FieldId], //20160320 Igor
                  RetList[Self.RetNo].Frm[Self.FormNo].Elms[MyEditBox.FieldId]) then
//      if sameText(LYEditBox.Text, MyEditBox.Text) then
        LYEditBox.vtCompareState := csEqual
      else
      Begin
//        ShowMessage(RetList[LYForm.RetNo].Frm[LYForm.FormNo].Elms[LYEditBox.FieldId]+
//                    #13+ RetList[Self.RetNo].Frm[Self.FormNo].Elms[MyEditBox.FieldId]);
        LYEditBox.vtCompareState := csNotEqual;
      End;
    End;
  end;
end;

procedure TMyChild.FormClose(Sender: TObject; var Action: TCloseAction);
//var  RNo: integer;
begin
  (* Only close by code, when RetNo has been cleared before.
    Safe place for dec(ChildCount), but maybe too late! (delayed Free)
  *)
  if RetNo > 0 then
  begin //in OnCloseQuery?
    UserMsg('You cannot close the window'
      + Chr(13) + 'You can close the Return instead');
    Action := caNone;
  end
  else
  begin
    //dec(ChildCount); //in FormDestroy?
    Action := caFree;
  end;
end;

function GetMyScrollBox(AChild: TControl): TvtScrollBox;
var
  cmp: TWinControl;
begin
  (* get the scrollbox (vtForm) for AChild
  *)
  if AChild is TWinControl then
    cmp := TWinControl(AChild) //.Parent;
  else
    cmp := AChild.Parent;
  while assigned(cmp) and not (cmp is TvtScrollBox) do
    cmp := cmp.Parent;
  Result := TvtScrollBox(cmp);
end;

function GetFieldId(const EditBoxName: string): Integer;
var
  i: Integer;
  c: char;
begin
  //get numeric part from Editnnn
  Result := 0;
  for i := 7 to length(EditBoxName) do
  begin
    c := EditBoxName[i];
    if (c >= '0') and (c <= '9') then
      Result := Result * 10 + ord(c) - ord('0')
    else
      Result := 0; //restart with next digit
  end;
end;

procedure AdjustRadioGroupValues(RetNo: Integer; FNo: Integer; FieldId: Integer; RadioElms: string);
var
  i: Integer;
  WList: TStringList;
begin
  WList := TStringList.Create;
  WList.CommaText := RadioElms;
  //ParseWords(RadioElms+',',',',WList);
  for i := 0 to Wlist.Count - 1 do
  begin
    if FieldId <> MyStrToInt(Wlist[i]) then
      StoreElm(RetNo, FNo, MyStrToInt(Wlist[i]), '');
  end; //i
  WList.Free;
end;

// ---------------------- scaling --------------------

procedure ScaleItMyWay(AControl: TControl; M, D: Integer);
var
  X, Y, W, H: Integer;
  Flags: TScalingFlags;
  R: TRect;
  Ratio, FontRatio: Real;
begin
  Ratio := m / d;
  FontRatio := Ratio; //???
  if m > 100 then
    FontRatio := (100 + (m - 100) / 2) / d;
  with AControl as TControl do
  begin
    AControl.Top := Round(AControl.Top * Ratio);
    AControl.Left := Round(AControl.Left * Ratio);
    AControl.Width := Round(AControl.Width * Ratio);
    AControl.Height := Round(AControl.Height * Ratio);

    if AControl is TLabel then
      (AControl as TLabel).Font.Size :=
        Round((AControl as TLabel).Font.Size * FontRatio);
    if AControl is TVtEdit then
      (AControl as TvtEdit).Font.Size :=
        Round((AControl as TvtEdit).Font.Size * FontRatio);
  end;
end;

procedure DoMyScaling(MyScrollBox: TvtScrollBox; M, D: Integer);
const
  SWP_HIDE = SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_HIDEWINDOW;
  SWP_SHOW = SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_SHOWWINDOW;
var
  i: Integer;
  IsVisible: Boolean;
  R: TRect;
begin
  with MyScrollBox do
  begin
    IsVisible := HandleAllocated and IsWindowVisible(Handle);
    if IsVisible then
      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDE);
    for i := MyScrollBox.ComponentCount - 1 downto 0 do
      if MyScrollBox.Components[i] is TControl then
        ScaleItMyWay(MyScrollBox.Components[i] as TControl, M, D);
    if IsVisible then
      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_SHOW);
  end;
end;

procedure DeleteDynamicRow(MyScrollBox: TvtScrollBox; FieldId: integer);
begin
  RetList[MyScrollBox.RetNo].Frm[MyScrollBox.FormNo].DeleteRowData(FieldId);
  if RowNo > 0 then //here FieldId of deleted row already invalid!
    dec(FieldId, BoxesPerRow); //in case it was the removed row
  MyScrollBox.SyncRows(FieldId);
end;

procedure AddDynamicRow(MyScrollBox: TvtScrollBox; FieldId: integer);
begin
  RetList[MyScrollBox.RetNo].Frm[MyScrollBox.FormNo].AddRowData(FieldId);
  MyScrollBox.SyncRows(FieldId);
end;

procedure ReScaleAllOpenedForms; //20160209 Igor
var
  i: integer;
  AChild: TMyChild;
begin
  (* called from ZoomButton...Click
  *)
  if (MainOptions.ZoomForm = zfAll) or (MainOptions.ZoomForm = zfCenter) then //20160209 Igor
    for i := Application.MainForm.MDIChildCount - 1 downto 0 do
    begin
      if assigned(Application.MainForm.MdiChildren[i]) and  //20160305 Igor
         (Application.MainForm.MdiChildren[i] is TMyChild) then //20161111 Igor
      Begin
        AChild := (Application.MainForm.MdiChildren[i]) as TMyChild;
        AChild.RescaleAllForms;
      End;
    end;

  if (MainOptions.ZoomForm = zfAll) or (MainOptions.ZoomForm = zfRight) then //20160209 Igor
    for i := 0 to FloatingForms.Count - 1 do
    begin
      if assigned(FloatingForms.GetForm(i)) then //20160305 Igor
        if assigned(FloatingForms.GetForm(i).Parent) then //20160312 Igor
          FloatingForms.GetForm(i).Activated(False, False); //20160711 Igor
    end;
end;

procedure TMyChild.RescaleAllForms; //20160209 Igor
var
  sbox: TvtScrollBox;
begin
  (* Only rescale active form (on ZoomBtnClick)
  *)
  sbox := ActiveForm; //20151013 Igor
  if Assigned(sbox) then //20160305 Igor
  Begin
    sbox.Visible:=false;
    sbox.Activated(False, False); //refresh not needed //20160711 Igor
    sbox.Visible:=true; //20151013 Igor
  end;
end;

procedure TMyChild.MyPageControlChange(Sender: TObject);
var
  MyScrollBox: TvtScrollBox;
begin
  (* Update whatever may have changed in between (retcolor,zoom,data...)
    done in Activated
  *)
  MyScrollbox := ActiveForm; // GetScrollbox(FormName);
  if MyScrollBox = nil then
    exit;
  if CalcAlways then
    CalcName(RetNo, FormName);
  MyScrollBox.Activated(True); //scale, refresh...
  //??? header should have been updated???
end;

procedure TMyChild.MyPageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
var
  MyScrollBox: TvtScrollBox;
begin
  //If Application.MainForm.MDIChildCount>0 then
  MyScrollBox := ActiveForm;
  if MyScrollBox = nil then
    exit;
  PrevRetNo := RetNo;
  PrevFormName := MyScrollBox.FormName; //global var
  //PrevFormNo := MyScrollBox.FormNo;      //global var
end;

procedure TMyChild.AfterOpenForm(MyScrollBox: TvtScrollBox);
begin
  (* override to configure the scrollbox
  *)
{$IFDEF old}
  MyScrollBox.OnClick := FormClick; //NOP
{$ELSE}
{$ENDIF}
  ShowMessage('Override AfterOpenForm');
end;

function TvtScrollBox.SetEditBoxBackColor(MyEditBox: TvtEdit): TColor;
begin
  (* override for further checks
  *)
  Result := clBlack;
  //if NoFormInfo(MyEditBox) then exit;
  case MyEditBox.VtDataSource of
    vtOverride, //special color?
    vtUser: Result := RetList[RetNo].MyApp.ActiveBoxColor;
    vtCalc: Result := DarkShade; {Rgb(130,130,130) //dark}
    vtLinked,
      vtPopUpList: Result := BrightGreen; //RGB(151,255,151); //clGreen
  end;
end;

function SetEditBoxFontColor(MyEditBox: TvtEdit): TColor;
begin
  case MyEditBox.VtDataSource of
    vtUser: result := clBlue;
    vtCalc: Result := clBlack;
    vtLinked: Result := clGreen;
    vtPopUpList: Result := clGreen;
    vtOverride: Result := clRed;
  else
    Result := clBlack;
  end;
end;

procedure TvtScrollBox.OnEnterField(MyEditBox: TvtEdit);
var
  s: string; //MyScrollBox:TvtScrollBox;
  FieldId: Integer;
begin
  FieldId := GetFieldId(MyEditBox.Name);
  {
    if OvrOn(RetNo,FormNo,FieldId) then
      MyEditBox.vtDataSource := vtOverride; //force appropriate color...
  }
  if ShowFieldIdSw = False then
  begin
    //If Ret[RetNo].IsLastYearRetNo = false then   //20110220
    MyEditBox.text := FetchElmFNo(RetNo, FormNo, FieldId);
  end
  else
    MyEditBox.Text := '[' + IntToStr(FieldId) + ']';
  MyEditBox.Modified := False; //just set

  MyEditBox.Font.Color := clBlack;
  MyEditBox.Color := SetEditBoxBackColor(MyEditBox);
  MyEditBox.SelectAll; //original
  ScrollInView(MyEditBox);
  //DrawBorderOnActiveBox(MyScrollBox,MyEditBox);
end;

procedure TvtScrollBox.SaveEditBoxText(FieldId: Integer; Value: string);
var
  FRec: TFRec;
  HasData: boolean;
begin
  (* special purpose?
    Flag return changed and FrmHasData where?
  *)
  //debug: wrong FormNo?
  //FRec := RetList[retNo].frm[formNo].FRec;
  if ShowFieldIdSw then exit; //20160608 Igor
  
  StoreElmFNo(RetNo, FormNo, FieldId, Value); // ??else extremely slow
  //DataChanged:=True;   //user changed via keystroke
  RetList[RetNo].Changed := True; //on every change?
  if Value <> '' then
  begin
    RetList[RetNo].FrmHasData[FormNo] := True;
  end;
  //check dynamic rows
  if SplitDynId(RetNo, FormNo, FieldId) then
  begin
    FRec := RetList[retNo].frm[formNo].FormDataRec;
    HasData := DynamicRowHasData(RetNo, FRec, ArrayNo, RowNo);
    if (RowNo = TopRow) and HasData then
    begin
      //append empty row
      AddDynamicRow(self, FieldId);
    end
    else if (RowNo < TopRow) and not HasData then
    begin
      //remove empty row
      DeleteDynamicRow(self, FieldId);
    end;
  end;
end;

function TvtScrollBox.ExitingField(MyEditBox: TVtEdit): Boolean;
var
  Value: string;
  FieldId: Integer;
begin
  (* Called for valid exit key (Enter...),
    validates the value -> Result
    checks for changes -> DataChanged???
    Store??? -> OnExitField???
    True result means move allowed,
    False prevents move of focus (in FormKeyDown)
  *)
  Result := True; //allow everything on unhandled field/form/return
  //allow certain moves
  FieldId := GetFieldId(MyEditBox.Name);
  if FieldId <= 0 then
    exit;
  if IsReturnLocked(RetNo) = True then
    exit; // DataChanged:=False;

  Value := MyEditBox.Text;
  Value := LTrim(Value);
  if MyEditBox.CharCase = ecUpperCase then
    Value := UpperCase(Value);

  //#16 20140502
  if (MyEditBox.vtInputType = vtDollar)
    and (not MyEditBox.vtAllowNegative)
    and (VL(Value) < 0) then
  begin
    UserMsg('Negative numbers not allowed here');
    Result := False
  end
  else
    Result := ValidateField(FieldId, Value);
end;

procedure TvtScrollBox.ChangeEditBoxText(MyEditBox: TvtEdit; Value: string);
begin
  (* change edit box text, set Modified, refresh?
  *)
  if ShowFieldIdSw then exit; //20160608 Igor

  if MyEditBox.Text = Value then
    exit; //not really changed
  MyEditBox.Text := Value;
  MyEditBox.Modified := True;
  MyEditBox.Refresh; //required?
  SaveEditBoxText(GetFieldId(MyEditBox.Name),Value); //20160713 Igor
end;

procedure TvtScrollBox.ChangeAndMove(MyEditBox: TvtEdit; Value: string;
  fBack: boolean);
begin
  ChangeEditBoxText(MyEditBox, Value);
  if not ExitingField(MyEditBox) then
    exit; //don't leave field with invalid content
  //move focus, Handle must be FORM (ChildWin) handle!
  if fBack then
    PostMessage(GetParentForm(MyEditBox).Handle, WM_NEXTDLGCTL, 1, 0)
  else
    PostMessage(GetParentForm(MyEditBox).Handle, WM_NEXTDLGCTL, 0, 0);
end;

procedure TMyChild.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  MyScrollBox: TvtScrollBox;
begin
  (* Sender is what? --> use ActiveControl!
  *)
  Sender := ActiveControl; //Sender is invalid
  MyScrollBox := self.ActiveForm; // GetScrollBox(FormName);

  {applies to KeyPress?
    If IsReturnLocked(RetNo) then
    Begin
      Key := 0;
       DataChanged := False;
       ShowTimedMsg('Changes not allowed. Return is locked (To unlock click File | Unlock)',1500);
       Exit;
    end;
  }
  //check for PageControl
  if ActiveControl is TPageControl then
  begin
    case Key of
      VK_DOWN:
        begin
          Key := 0;
          PostMessage(Self.Handle, WM_NEXTDLGCTL, 0, 0);
        end;
      VK_UP:
        begin
          Key := 0;
          PostMessage(Self.Handle, WM_NEXTDLGCTL, 1, 0);
        end;
      VK_RETURN:
        begin
          Key := 0;
          if Shift = [ssShift] then
            PostMessage(Self.Handle, WM_NEXTDLGCTL, 1, 0)
          else
            PostMessage(Self.Handle, WM_NEXTDLGCTL, 0, 0);
        end;
      VK_NEXT: {pgdn}
        begin
          Key := 0;
          if (Shift = [ssCtrl]) and (Key = VK_NEXT) then {Ctrl pgdn}
            //{MainFormT1.}PreselNextBtnClick(Sender)
            Pages.SelectNextPage(True)
          else
          begin
            if MyScrollBox.vertscrollbar.Position >= (MyScrollBox.vertscrollbar.Range - MyScrollBox.Height - 1) then
              OpenNextPage(RetNo, MyScrollBox.FormName)
            else
              MyScrollBox.vertscrollbar.Position := MyScrollBox.vertscrollbar.Position + MyScrollBox.Height;
          end;
        end;
      VK_PRIOR: {pgup}
        begin
          Key := 0;
          if (Shift = [ssCtrl]) then
            Pages.SelectNextPage(False)
          else
          begin
            if MyScrollBox.vertscrollbar.Position <= 0 then
              OpenPrevPage(RetNo, MyScrollBox.FormName)
            else
              MyScrollBox.vertscrollbar.Position := MyScrollBox.vertscrollbar.Position - MyScrollBox.Height;
          end;
        end;
    end; //case
  end //page Ctrl
  else
    MyScrollBox.FormKeyDown(Sender, Key, Shift);

  //all unhandled keys
  if Key <> 0 then //if not handled
    Keys(Key, Shift);
end;

procedure TvtScrollBox.ToggleOverride(MyEditBox: TvtEdit);
begin
  case MyEditBox.vtDataSource of
    vtCalc:
      //if MyEditBox.vtDataSource = vtCalc then
      begin
        //20170612 Igor >>>
        MyEditBox.vtDataSource := vtOverride; //allow for input until field exited
        if MyEditBox.vtDataSource = vtOverride then
        begin
          SetFieldOverride(RetNo, FormNo, MyEditBox.FieldId); //destroys previous value!
          MyEditBox.vtPrefix := '* ';
        end;
        //20170612 Igor <<<
      end;
    vtOverride:
      begin
        RemoveFieldOverride(RetNo, FormNo, MyEditBox.FieldId);
        MyEditBox.vtDataSource := vtCalc;
        MyEditBox.vtPrefix := '';
        //must recalc!
        ReCalcEveryThing(RetNo); //CalcAll?
        UpdateAfterSave; //update floating forms, too!
      end;
  else
    exit; //not applicable
  end;
  OnEnterField(MyEditBox); //restore field
  MainForm.RefreshAuditPanel(RetNo); //update GUI
end;

procedure TvtScrollBox.ToggleReview(MyEditBox: TvtEdit);
begin
  if ReviewOn(RetNo, FormNo, MyEditBox.FieldId) then
    //if MyEditBox.vtReviewOn then //reliable???
  begin
    RemoveReviewMark(RetNo, FormNo, MyEditBox.FieldId);
    MyEditBox.vtReviewOn := False;
    MyChild.ShowFormData(FormName, FormNo);
  end
  else
  begin
    SetReviewMark(RetNo, FormNo, MyEditBox.FieldId);
    MyEditBox.vtReviewOn := True;
    MyChild.ShowFormData(FormName, FormNo);
  end;

  RetList[RetNo].Changed := True;
  MainForm.RefreshAuditPanel(RetNo);
  //If MainForm.FormsPanel.Visible then MainForm.RefreshFormsPanel(RetNo);
end;

procedure TvtScrollBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  MyEditBox: TvtEdit absolute sender;
  FieldId: Integer;
  MyControl: TWinControl;
  cBox: TComboBox absolute sender;
  ParentForm: TCustomForm;

  procedure TryMove(fBack: boolean);
  begin
    Key := 0;
    if MyEditBox is TvtEdit then
    begin
      if not ExitingField(MyEditBox) then
        exit; //don't leave field with invalid content
    end;
    //move focus, Handle must be FORM (ChildWin) handle!
    if fBack then
      PostMessage(ParentForm.Handle, WM_NEXTDLGCTL, 1, 0)
    else
      PostMessage(ParentForm.Handle, WM_NEXTDLGCTL, 0, 0);
  end;

begin
  //try ParentForm handle
  if assigned(Sender) then //20160302 Igor
    ParentForm := GetParentForm(cBox)
  else
    ParentForm := Screen.ActiveForm; //20160302 Igor
  //Check for combobox

  //20170303 Igor (Scrolling for any focused control) >>>
  case Key of
    VK_NEXT:
      begin
        Key := 0;
        VertScrollBar.Position := VertScrollBar.Position + ClientHeight;
        exit;
      end;
    VK_PRIOR:
      begin
        Key := 0;
        VertScrollBar.Position := VertScrollBar.Position - ClientHeight;
        exit;
      end;
    VK_END:
      begin
        if Shift = [ssCtrl] then
        begin
          Key := 0;
          VertScrollBar.Position := MaxInt;
          exit;
        end;
      end;
    VK_HOME:
      begin
        if Shift = [ssCtrl] then
        begin
          Key := 0;
          VertScrollBar.Position := 0;
          exit;
        end
      end;
  end;
  //20170303 Igor <<<
  if assigned(Sender) AND (Sender is TComboBox) then
  begin
    //cBox := TComboBox(ActiveControl);
    case Key of
      VK_TAB: // Tab doesnt seem to be captured here?????
        begin
          Key := 0;
          if Shift = [ssShift] then
          begin
            MyControl := GetFieldByTabOrder(cBox.TabOrder - 2);
            FocusOnElm(GetFieldId(MyControl.Name));
            //PostMessage(Self.Handle, WM_NEXTDLGCTL, 1, 0)
          end;
        end;
      VK_DOWN:
        begin
          if not (SendMessage(cBox.Handle, CB_GETDROPPEDSTATE, 0, 0) = 1) then
          begin
            Key := 0;
            PostMessage(ParentForm.Handle, WM_NEXTDLGCTL, 0, 0);
          end;
        end;
      VK_UP:
        begin
          if not (SendMessage(cBox.Handle, CB_GETDROPPEDSTATE, 0, 0) = 1) then
          begin
            Key := 0;
            //PostMessage(Self.Handle, WM_NEXTDLGCTL, 1, 0);
            MyControl := getFieldByTabOrder(cBox.TabOrder - 2);
            FocusOnElm(GetFieldId(MyControl.Name));
          end;
        end;
      VK_RETURN:
        begin
          Key := 0;
          if Shift = [ssShift] then
          begin
            //PostMessage(Self.Handle, WM_NEXTDLGCTL, 1, 0)
            MyControl := getFieldByTabOrder(cBox.TabOrder - 2);
            FocusOnElm(GetFieldId(MyControl.Name));
          end
          else
            PostMessage(ParentForm.Handle, WM_NEXTDLGCTL, 0, 0);
        end;
    end; //case
    exit;
  end //combobox
  else if assigned(Sender) AND (Sender is TvtEdit) then
  begin
    //MyEditBox:=ActiveControl As TvtEdit;
    FieldId := GetFieldId(MyEditBox.Name);
    //Return key in FormKeyPress
    // TAB is not captured
    case Key of
      VK_DELETE:
        { allow to clear popup field?
          Begin
            If GetPopupFile(FormName,FieldId)>'' then
            begin //accept delete on vtPopup type
             MyEditBox.Text:='';
             DataChanged:=True;
             //SaveEditBoxText(FormNo,FieldId,MyEditBox.Text);
             MyEditBox.Refresh;
            end
            else
            begin
               //SaveEditBoxText(FormNo,FieldId,MyEditBox.Text);
            end
         end;
        }
        ; //exit; //accept always?
      VK_RETURN: //handled in KeyPress?
        begin
          key := 0; //stop beep
          exit;
        end;
      VK_DOWN:
        TryMove(False);
      VK_UP:
        TryMove(True);

        //put back 20151010
     //20150811 enable PgUp/Dn
(*//20170303 Igor
      VK_NEXT:
        begin
          Key := 0;
          VertScrollBar.Position := VertScrollBar.Position + ClientHeight;
        end;
      VK_PRIOR:
        begin
          Key := 0;
          VertScrollBar.Position := VertScrollBar.Position - ClientHeight;
        end;
*)



      VK_F2:
        if ssShift in Shift then
        begin //toggle override
          Key := 0; //handled
          ToggleOverride(MyEditBox);
          //SetOverride(MyEditBox.vtDataSource = vtCalc);
          exit;
        end;
      VK_SHIFT, VK_CONTROL, VK_MENU:
        exit; //ignore modifiers only
//20160805 Igor >>>
//    else //case
//      if assigned(Sender) AND IsProtectedField(MyEditBox) then //20160805 Igor
//      begin //not reached?
//        (* remember override field, until left - how?
//          vtDataSource not initialized correctly? (OnEnter-->flag vtOverride!)
//        *)
//        if MyEditBox.vtDataSource = vtCalc then
//        begin
//          //which field types can be overridden? --> vtCalc only
//          case MessageDlg('Protected field - override?', mtConfirmation, mbOKCancel, 0) of
//            mrOk: //start override
//              begin
//                //SetOverride(True);
//                ToggleOverride(MyEditBox);
//              end;
//          else //case, mrCancel
//            key := 0; //does not prevent the key from showing up in the field!
//            //SetOverride(False); //really needed?
//            //OnEnterField(MyEditBox); //restore calculated value?
//          end;
//          //OnEnterField(MyEditBox); //restore proper text and attributes
//        end
//        else
//        begin
//          //ShowTimedMsg('Protected or Calculated field',1000);
//          ShowTimedMsg('Protected field', 1000);
//          Key := 0;
//        end;
//      end;
//20160805 Igor<<<
    end; //case
  end //vtEdit
end;

procedure TMyChild.FormActivate(Sender: TObject);
var
  MyScrollBox: TvtScrollBox;
  I, FormNo: Integer;
begin
  if asDummyFormShow in ApplicationState then
    exit;
  //20170717 Igor >>>
  if FControlHides then
    ShowAllControls;
  //20170718 Igor<<<
  if (RetNo < 1)
    or (RetList[RetNo] = nil) then
  begin
    FRetNo := 0;
    Close;
    MainForm.GuiCommand(gcActiveFormChange); //20160305 Igor
    exit; //closing
  end;
  //20161028 Igor >>>
  if (CurrentApp <> RetList[RetNo].MyApp) then
  begin
    if Screen.ActiveControl.Owner <> Self then
      exit;
  end;
  //20161028 Igor <<<

  Caption := RetList[RetNo].GetReturnCaption;
{$IFDEF old}
  if not GetActiveTabSheet() then
    exit; //init FormName/No
  //FormNameNo(RetNo,Pages.ActivePage.Caption);
{$ELSE}
  //20170719 Igor >>>
  for I := 0 to length(FDifferedOpenForms) - 1 do
  begin
    FormNo := RetList[Self.RetNo].Form[FDifferedOpenForms[I]].FormNo;
    if Self.GetForm(FormNo, I = length(FDifferedOpenForms) - 1) = nil then
    begin
      Self.CreateForm(Self.CreateNewTab(FormNo, FDifferedOpenForms[I]), FormNo);
      Self.GetForm(FormNo, True).Activated(True, I = length(FDifferedOpenForms) - 1);
    end;
  end;
  SetLength(FDifferedOpenForms, 0);
  //20170719 Igor<<<
  MyScrollBox := ActiveForm;
  if MyScrollBox = nil then
  Begin
    GetCurrentRetNo := RetNo;
    exit;
  End;
{$ENDIF}
  UpdateChildTaxPanel;
  ShowFormData(MyScrollBox.FormName, MyScrollBox.FormNo);

  //flicker unecessarily, can it be avoided?//
  if (MainForm.LeftPanel.visible) then
    MainForm.RefreshAuditPanel(RetNo);
  GetCurrentRetNo := RetNo;
  RetNoChanged(RetNo); //?
  MainForm.GuiCommand(gcActiveFormChange); //20160305 Igor
end;

function TMyChild.GetActiveTabSheet: boolean;
var
  MyScrollBox: TvtScrollBox;
begin
{$IFDEF old}
  MyTabSheet := MyPageControl.ActivePage;
  Result := MyTabSheet <> nil;
  if not Result then
    exit;
  FormNameNo(MyTabSheet.Caption, MyTabSheet.Tag);
{$ELSE}
  MyScrollbox := ActiveForm; // GetForm(FormNo, False);  //GetScrollbox(self,FormName);
  Result := MyScrollBox <> nil;
  if not Result then
    exit;
{$ENDIF}
  MyScrollBox.Color := GetRetColor(RetNo);

  UpdateFormHeaderFrame;
end;

procedure TMyChild.FormKeyPress(Sender: TObject; var Key: Char);
var
  MyScrollBox: TvtScrollBox;
begin
  //escape - not handled in KeyDown!
  if (Key = #27) then
  begin //handle in Keys (also in MainForm.FormShortCut!)
    //Key := chr(0);
    exit;
  end;

  MyScrollBox := ActiveForm;
  if MyScrollBox = nil then
    exit;
  //handle form keys
  //delegate to scrollbox
  MyScrollBox.FormKeyPress(ActiveControl, Key);
end;

procedure TMyChild.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean); //20160720 Igor
var
  C: TControl;
  P: TPoint;
  M: TMessage;
begin
  inherited;
  P := ScreenToClient(Mouse.CursorPos);
  C := ControlAtPos(P, True, true, false);
  if assigned(C) then
    repeat
      if C is TvtForm then
      begin
        if WheelDelta < 0 then
        begin
          TvtForm(C).Perform(WM_VSCROLL, SB_LINEDOWN, 0);
          TvtForm(C).Perform(WM_VSCROLL, SB_LINEDOWN, 0);
        end
        else
        begin
          TvtForm(C).Perform(WM_VSCROLL, SB_LINEUP, 0);
          TvtForm(C).Perform(WM_VSCROLL, SB_LINEUP, 0);
        end;
        break;
      end;
      if C is TWinControl then
      begin
        P := C.ParentToClient(P);
        C := TWinControl(C).ControlAtPos(P, True, true, false);
      end
      else
        break;
    until c = nil;
end;

procedure TvtScrollBox.FormKeyPress(ActiveControl: TControl; var Key: Char);
var
  FieldId: Integer;
  FName: string;
  Value, SelectedString: string;
  i: Integer;
  NewString, OldString, TxtToFind: string;
  RadioElms: string;
  OldSelStart: Integer;
  UpKey: Char;
  PredictFile, PopUpFile: string;
  TargetLinkedField: Integer;
  MyEditBox: TvtEdit;
  ParentForm: TCustomForm;
begin
  (* special key handling
    MUST be a form handler - delegate to what???
  *)
  if not (ActiveControl is TvtEdit) then
    exit; //only Editbox here

  MyEditBox := TvtEdit(ActiveControl);
  FieldId := MyEditBox.FieldId;
  ParentForm := GetParentForm(MyEditBox);
  //20160710 Igor
  if not assigned(RetList[RetNo]) then exit;
  if RetList[RetNo].IsLastYearReturn then exit;
  if RetList[RetNo].isAppendix then exit;


  case Key of
    #8: //backspace - what?
      begin
        //20170612 Igor >>>
        if MyEditBox.vtDataSource = vtPopuplist then {Keypress}
        begin
          Key := Chr(0);
          MyEditBox.Text := '';
          MyEditBox.Invalidate;
        end;
        //20170612 Igor <<<
        //SaveEditBoxText(FormNo,FieldId,MyEditBox.Text);
        exit;
      end;
    #13: {Return key}
      begin //reached!
        Key := Chr(0); {stops the beep}
        if ExitingField(MyEditBox) = False then
          exit;
        if HiWord(GetKeyState(VK_SHIFT)) <> 0 then
          PostMessage(ParentForm.Handle, WM_NEXTDLGCTL, 1, 0)
        else
          PostMessage(ParentForm.Handle, WM_NEXTDLGCTL, 0, 0);
        exit;
      end; //return key
  end; //case

{$IFDEF issue29}
  if IsProtectedField(MyEditBox)
    {.vtDataSource=vtCalc)
  or ((FormName='INV') and (IsInvoiceLocked(RetNo)) and (fieldid <> 285))
  } then
  begin
    Key := Chr(0);
    ShowTimedMsg('Protected or Calculated field', 1000);
    Exit;
  end;
{$ELSE}
  //Con: show msg only on KeyDown/Press
{$ENDIF}

  //linked
  if MyEditBox.vtDataSource = vtLinked then {Keypress}
  begin
    Key := Chr(0);
    OnVtEditDblClick(MyEditBox);
    exit;
  end;

  //If last year stop key press
  if IsReturnLocked(RetNo) = True then
  begin
    Key := Chr(0);
    ShowTimedMsg('Changes not allowed. Return is locked', 1500);
    Exit;
  end;

  // popup list
  if MyEditBox.vtDataSource = vtPopuplist then   //20160304 Igor
  begin
        Key:=Chr(0);
        OnVtEditDblClick(MyEditBox);
        exit;
  end;

(*  //Is it in the popup list
  PopUpFile := GetPopUpFile(FieldId);
  if (PopUpFile > '') {and (ShowUnconvertedLastYear(RetNo)=False)} then
  begin
    if key = #8 then
    begin
      Key := #0;
      ChangeEditBoxText(MyEditBox, '');
      exit;
    end;
    if MyEditBox.SelStart = 0 then
      ChangeEditBoxText(MyEditBox, '');
    OldString := MyEditBox.Text;
    OldSelStart := MyEditBox.SelStart;
    TxtToFind := LeftStr(OldString, MyEditBox.SelStart) + Key;
    if TxtToFind > '' then
    begin
      NewString := GetPredictiveValue(RetNo, PopUpFile, FormName, FieldId, TxtToFind); //KeyStrokes);
      if NewString > '' then //found
      begin
        key := Chr(0);
        ChangeAndMove(MyEditBox, NewString);
        MyEditBox.SelStart := OldSelStart + 1;
      end
      else //not found. Show poplist
      begin
        key := Chr(0);
        //MyEditBox.Text:='';
        SelectedString := GetValueFromList(MyEditBox, FieldId);
        if SelectedString > '' then
        begin
          ChangeAndMove(MyEditBox, SelectedString);
        end; //not found
      end;
    end; //txt to find
    Exit;
  end; //there is popupfile
*)
  //predictive type ahead, auto complete
  PredictFile := GetPredictiveFile(RetNo, FormName, FieldId);
  if (PredictFile > '') {and (ShowUnconvertedLastYear(RetNo)=False)} then
  begin
    //If key = #8 then exit;
    if key < #32 then
      exit;
    FieldId := GetFieldId(MyEditBox.Name);
    if MyEditBox.SelStart = 0 then
      ChangeEditBoxText(MyEditBox, ''); //begin MyEditBox.Text:='';MyEditBox.Refresh;end;
    OldString := MyEditBox.Text;
    OldSelStart := MyEditBox.SelStart;
    TxtToFind := LeftStr(OldString, MyEditBox.SelStart) + Key;
    if TxtToFind > '' then
    begin
      NewString := GetPredictiveValue(RetNo, PredictFile, FormName, FieldId, TxtToFind); //KeyStrokes);
      if NewString > '' then //found
        ChangeEditBoxText(MyEditBox, NewString) // MyEditBox.Text := NewString;
      else //not found
        ChangeEditBoxText(MyEditBox, TxtToFind); // MyEditBox.Text := TxtToFind;
      key := Chr(0);
      MyEditBox.SelStart := OldSelStart + 1;
      Exit;
    end;
  end; //predictive

  if MyEditBox.vtDataSource = vtPopuplist then
  begin
    Key := Chr(0);
    SelectedString := GetValueFromList(MyEditBox, FieldId);
    if SelectedString > '' then
      ChangeAndMove(MyEditBox, SelectedString);
    Exit;
  end; //popup

  case MyEditBox.vtInputType of
    vtCheckBox: //keypress option
      begin
        MyEditBox.MaxLength := 1;
        UpKey := UpCase(key);
        Key := #0;
        RadioElms := IsInRadioGroup(FieldId);
        if RadioElms > '' then //in radio group
        begin
          if MyEditBox.Text = '' then
          begin
            //If (Value='X') or (Value='Y') or (Value=Chr(32)) then
            if CharInSet(UpKey, ['X', 'Y', ' ']) then
            begin
              Value := 'X'; //Key:=Chr(0);
              //ChangeAndMove(MyEditBox,Value);  //MyEditBox.Text:='X';MyEditBox.Refresh;
              ChangeEditBoxText(MyEditBox, Value);
              //SaveEditBoxText(FieldId, Value); //20160713 Igor (Call from ChangeEditBoxText)
              AdjustRadioGroupValues(RetNo, FormNo, FieldId, RadioElms); //values only!
              //ShowFormData(FormName,FormNo); //update controls, too!
            end
            else
              exit; //unchanged
          end;
        end //radiogroup
        else //plain checkbox
        begin
          if MyEditBox.Text = '' then
          begin
            if CharInSet(UpKey, ['X', 'Y', ' ']) then
              ChangeEditBoxText(MyEditBox, 'X')
            else
              exit;
          end
          else //has something
          begin
            //If (UpperCase(key)='X') or (UpperCase(key)='N') or (key=Chr(32)) then
            if CharInSet(UpKey, ['X', 'N', ' ']) then
              ChangeEditBoxText(MyEditBox, '')
            else
              exit;
          end;
        end; //plain checkbox
        //changed
        UpdateAfterSave();
        Exit;
      end; //checkbox
    vtYesOrNo:
      begin
        MyEditBox.MaxLength := 1;
        UpKey := UpCase(key);
        Value := UpKey;
        Key := #0;
        if not (CharInSet(UpKey, YesNoSet))
          or (ValidateField(FieldId, Value) = False) then
          exit; //key invalidated

        //ChangeAndMove(MyEditBox, Value);
        ChangeEditBoxText(MyEditBox, Value);
        Exit;
      end; //vtYesOrNo
    vtNumber:
      begin
        if ValidateNumericField(key) = False then
          key := CHR(0);
        Exit;
      end;
    vtSin:
      begin
        if NumbersOnly(Key) = false then
          Key := Chr(0);
        Exit;
      end;
    vtDollar:
      begin
        if ValidateAmountField(key, MyEditBox.Text, MyEditBox.SelStart, MyEditBox.SelLength) = False then
          key := CHR(0);
        exit;
      end;
  end; //vtInputType

  {unchanged
    if RetList[RetNo].Frm[FormNo].Strings[FieldId] <> '' then
            RetList[RetNo].FrmHasData[FormNo] := True;
  }
end;

procedure TvtScrollBox.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean); //20160312 Igor
begin
  //20190109 Igor >>>
  if CheckIsCloud(true) then
  begin
    MainForm.GuiCommand(gcNoScroll); //20190115 Igor
    Handled := true;
    Exit;
  end;
  //20190109 Igor <<<

  inherited;
  ScrollSender := Self.Handle;
  MainForm.GuiCommand(gcScroll);
end;

function TvtScrollBox.IsInRadioGroup(FieldId: Integer): string;
var
  NonInstFormName: string;
  i, j: Integer;
  TempList: TStringList;
  RadioElms, Elm: string;
  WList: TStringList;
begin
  (* return list of fields.
    FP has very long FormNames!
  *)
  Result := '';
  Elm := IntToStr(FieldId);
  NonInstFormName := UpperCase(ExtractNonInstFormName(FormName));
  TempList := TStringList.Create;
  WList := TStringList.Create;
  TempList.LoadFromFile(AppDir(RetNo) + '\' + 'RadioGrp.d');
  for i := 0 to TempList.Count - 1 do
  begin
    if TempList[i] = '' then
      continue; //bad entry
    WList.CommaText := TempList[i];
    if NonInstFormName = UpperCase(WList[0]) then
    begin
      if WList.IndexOf(Elm) > 0 then
      begin
        WList.Delete(0); //FormName
        Result := WList.CommaText;
        break;
      end;
    end;
  end; //i
  TempList.Free;
  Wlist.Free;
end;

function TvtScrollBox.IsProtectedField(MyEditBox: TvtEdit): boolean;
begin
  Result := (MyEditBox.vtDataSource = vtCalc);
  //or ((FormName='INV') and (IsInvoiceLocked(RetNo)) and (fieldid <> 285))
end;

function TvtScrollBox.GetPopUpFile(FldId: Integer): string;
var
  i: Integer;
  TempList: TStringList;
  NonInstFormName: string;
begin
  (* Only T1 has non-empty PopList.d! ???
  *)
  Result := '';
  NonInstFormName := UpperCase(ExtractNonInstFormName(FormName));
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir(RetNo) + '\' + 'PopList.d');
  for i := 0 to TempList.Count - 1 do
  begin
    if NonInstFormName = UpperCase(RTrim(LeftStr(TemplIst[i], 10))) then
    begin
      if IsInRange(FldId,
        MyStrToInt(AllTrim(MidStr(TempList[i], 11, 3))),
        MyStrToInt(AllTrim(MidStr(TempList[i], 15, 3))),
        MyStrToInt(AllTrim(MidStr(TempList[i], 19, 3)))) then
      begin
        Result := AllTrim(MidStr(TempList[i], 23, 15));
        break;
      end; //founf fld
    end; //found form
  end; //i
  TempList.Free;
end;

procedure TvtScrollBox.OnExitField(MyEditBox: TvtEdit);
var
  DPos, FieldId, VLength: integer;
  OldValue, Value, PredictFile: string;
begin
  (* check valid, save or restore value.
    format new value before checks
  *)

  FieldId := GetFieldId(MyEditBox.Name);
  OldValue := MyEditBox.vtOldValue; //FetchElmFNo(RetNo, FormNo, FieldId); //20170219 Igor
  Value := MyEditBox.Text;

  //get/format value - from OnKeyPress
  if MyEditBox.vtInputType = vtDollar then
  begin
    if not (MyEditBox.vtAllowNegative)
      and (vl(Value) < 0) then
    begin
      //UserMsg('Negative numbers not allowed here');
      Value := OldValue; //? skip further processing
      //MyEditBox.SetFocus; //meaningful only when preserving input
    end
    else if RetList[retNo].MyApp.DecimalAssume = true then
    begin
      DPos := pos('.', Value);
      if DPos = 0 then
      begin
        VLength := Length(Value);
        if VLength < 2 then
          Value := '.0' + Value
        else
          Value := leftstr(Value, VLength - 2) + '.' + rightstr(Value, 2);
      end;
    end;
  end;
  //20170904 Igor>>>
  if MyEditBox.vtInputType = vtDollar then
    Value := Unformat(Value);
  //20170904 Igor<<<
  //check valid
  if (MyEditBox.SameValues(Value, OldValue)) //20160121 Igor //20170408 Igor
    or IsReturnLocked(RetNo)
    or not ValidateField(FieldId, Value) or
    ShowFieldIdSw then //20160608 Igor
  begin
    //undo radiogrp?
    ShowFieldData(MyEditBox);
    exit;
  end;
  //change...
  //all done in SaveEditBoxText?
  SaveEditBoxText(FieldId, Value);//20170904 Igor
  MyEditBox.Modified := False;
  //include in DataChangeRtn? UpdateAfterSave?
  if OvrOn(RetNo, FormNo, FieldId) then
  begin
    SaveFieldOverride(RetNo, FormNo, FieldId, Value);
    //MyEditBox.vtDataSource := vtCalc; //switch back to protected field
  end;
  PredictFile := GetPredictiveFile(RetNo, FormName, FieldId);
  if PredictFile > '' then
  begin
    BuildSuperEntry(value, AppDir(RetNo) + '\' + PredictFile);
  end;

  UpdateAfterSave;
end;

procedure TvtScrollBox.UpdateAfterSave;
begin
  (* to be called when a valid editbox value was stored
  *)
  DataChangeRtn; //(FormName);  //done in the Exiting
  CountDiagnostics(RetNo); //for proper color
  ShowFormData;
  FloatingForms.UpdateForms(RetNo);
  RetList[RetNo].MyChild.UpdateAfterSave(FormName);
end;

procedure TMyChild.UpdateAfterSave;
begin
  MainForm.FormPaint(Application); //???
  UpdateFormHeaderFrame;
  UpdateChildTaxPanel;
  if MainForm.LeftPanel.visible then
    MainForm.RefreshAuditPanel(RetNo);
end;

procedure TvtScrollBox.BuildSuperEntry(Value, FlName: string);
var
  i: Integer;
  TempList: TStringList;
begin
//  FlName := AppDir(RetNo) + '\' + FlName; //20170219 Igor
  if not FileExists(FlName) then
    exit; //create???

  TempList := TStringList.Create;
  TempList.LoadFromFile(FlName);
  if IsInList(Value, TempList) < 0 then
  begin
    TempList.Add(Value);
    TempList.SaveToFile(FlName);
  end;
  TempList.Free;
end;

procedure TvtScrollBox.EditBoxMouseDown(MyEditBox: TvtEdit;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  FieldId: integer;
  Value: string;
  RadioElms: string;
begin
  (* default implementation of left click - checkboxes
    Con: store immediately, refresh display...
  *)
  if Button <> mbLeft then
    exit;
  if Shift = [ssLeft, ssDouble] then
    exit;
  if IsReturnLocked(RetNo) then
    exit;

//20160713 Igor/ Read only not only locked(lastYear/appendix) return ((((
  //20160710 Igor
  //if MyEditBox.ReadOnly then
  //  exit;

  if RetList[RetNo].isAppendix then
    exit;

  FieldId := GetFieldId(MyEditBox.Name);
  if IsProtectedField(MyEditBox) then
  begin
    //Key:=Chr(0);
{$IFDEF issue29}
    ShowTimedMsg('Protected or Calculated field', 1000);
{$ELSE}
    //Con: message only on attempt to change the field
{$ENDIF}
    Exit;
  end;

  case MyEditBox.vtInputType of
    vtCheckBox: //simple or radiobutton
      begin
        RadioElms := IsInRadioGroup(FieldId);
        if RadioElms > '' then
        begin
          Value := 'X';
          if MyEditBox.Text = Value then
            exit; //nothing changed
          ChangeEditBoxText(MyEditBox, Value); //MyEditBox.Text:='X';MyEditBox.Refresh;
          SaveEditBoxText(FieldId, Value);
          AdjustRadioGroupValues(RetNo, FormNo, FieldId, RadioElms);
          ShowFormData; //(FormName,FormNo); //update controls, too!
          //Exit; //Con: don't move
        end
        else
        begin //plain checkbox
          if MyEditBox.Text = '' then
            Value := 'X'
          else
            Value := '';
          if ValidateField(FieldId, Value) = False then //cleans radio buttons also
            exit; //MyEditBox.text:='';
          SaveEditBoxText(FieldId, Value);
          //ChangeEditBoxText(MyEditBox,Value);
          //PostMessage(Handle, WM_NEXTDLGCTL, 0, 0);  //needed
        end;
        //Exit;
      end; //VtCheckBox
    //If MyEditBox.vtInputType =
    vtYesOrNo:
      begin
        Value := MyEditBox.Text;
        if Value = '' then
          Value := 'Y'
        else if Value = 'Y' then
          Value := 'N'
        else if Value = 'N' then
          Value := 'Y';
        if ValidateField(FieldId, Value) = False then //cleans radio buttons also
          exit; //MyEditBox.text:='';
        SaveEditBoxText(FieldId, Value);
        //ChangeEditBoxText(MyEditBox,Value); //rest below
        //Exit;
      end; //VtYesOrNo
  else //case
    exit; //handled in OnExit
  end; //case
  //recalc...
  UpdateAfterSave; //(FormName);
  //DataChangeRtn(FormName);
  //ShowFormData(FormName,FormNo); //update controls, too!
end;

procedure TMyChild.Keys(var Key: Word; Shift: TShiftState);
begin
  (* common key handler, could also be moved into FormShortCut
  *)
  case Key of
    VK_ESCAPE:
      begin //reached!
        Key := 0;
        if Printer.Printing then
        begin
          //this is also handled in MainForm ShortCuts
          Printer.Abort;
          MessageDlg('Printing interrupted by user', mtInformation, [mbOK], 0);
        end
        else
        begin
          //20090816
          if IsIconic(GetActiveWindow) = false then //self.Handle?
          begin
            if GetRetFormNo(RetNo, 'TAXSUM') > 0 then
            begin //all but TF
              if MainOptions.EscOption = 'GoToSummary' then
              begin
                CalcAll(RetNo);
                OpenForm(RetNo, 'TAXSUM', 8); //!!! virtual !!!
              end
              else
              begin
                CloseActiveForm(nil);
                //OpenForm(PrevRetNo,PrevFormName,0);
              end;
            end
            else
            begin //TF!
              CloseActiveForm(nil);
              //OpenForm(PrevRetNo,PrevFormName,0);
            end;
            //FormActivate(Sender); //???
          end //TF
        end //IsIconic
      end; //escape
  end; //case
end;

procedure TMyChild.CloseActiveForm(Sender: TObject);
var
//20170224 Igor >>>
  I: Integer;
  ts: TTabSheet;
//  pr: integer;
  pf: string;
//20170224 Igor <<<

begin
  (* override to prevent a specific form from closing
  Problem: back to previous form
  *)
  if MyPageControl.PageCount < 2 then
  begin
    ShowMessage('You cannot close the last form'
      + Chr(13) + 'You can close the Return instead');
    Exit;
  end;
//Previous - MDI child
//20170224 Igor >>>
//  pr := PrevRetNo;
//  pf := PrevFormName;
  ts := MyPageControl.FindNextPage(MyPageControl.ActivePage,
    MyPageControl.ActivePageIndex < (MyPageControl.PageCount - 1), true);
  if ts <> MyPageControl.ActivePage then
    pf := ts.Caption
  else
    pf := CurrentApp.FirstForm;
  MyPageControl.ActivePage.free;
  OpenForm(GetCurrentRetNo, pf, 0);
//  SwitchForms; //right?
//20170224 Igor <<<

  UpdateFrames; //not triggered by manual Free
end;

{$IFDEF old}

procedure TMyChild.FormNameNo(FName: string; FNo: integer);
begin
  FormName := FName;
  FormNo := FNo; // GetRetFormNo(RetNo, FName);
end;
{$ELSE}
{$ENDIF}

destructor TMyChild.Destroy;  //20170606 Igor
begin
  TMyChild.ChildCount := TMyChild.ChildCount - 1;
  inherited;
end;

procedure TMyChild.DetachReturn;
begin
  if retno > 0 then
    RetList[retno].MyChild := nil;
  FRetNo := 0;
//  dec(ChildCount); //before OnIdle, even if Free delayed //20170606 Igor
  Close;
end;

procedure TvtScrollBox.SendMemoToSave(MyMemoBox: TCustomMemo);
var
  FldId: integer;
  s: string;
  ss: TStringStream;
begin
  (* TCustomMemo behaves differently from TRichEdit!
  *)
  FldId := GetFieldId(MyMemoBox.Name);
  if MyMemoBox is TRichEdit then
  begin
    ss := TStringStream.Create(s);
    TRichEdit(MyMemoBox).Lines.SaveToStream(ss); //must typecast!
    s := ss.DataString;
    ss.Free;
    //Application.MainForm.Caption := s; - debug only!
  end
  else
    s := MyMemoBox.Text;
  RetList[RetNo].Frm[FormNo].Memos[FldId] := s;
  //must set FrmHasData
  if s <> '' then
    RetList[RetNo].FrmHasData[FormNo] := True;
end;

procedure TvtScrollBox.ShowMemoData(MyMemoBox: TMemo; Fld: Integer);
var
  fd: TFormData;
begin
  if ShowFieldIdSw then
    MyMemoBox.Text := '[' + IntToStr(Fld) + ']'
  else
  begin
    //20160710 Igor
    if not assigned(RetList[RetNo]) then exit;
    fd := RetList[RetNo].Frm[FormNo];
    if not assigned(fd) then exit;
    if not assigned(fd.Memos) then exit;

    if (Fld >= Low(fd.Memos)) and
       (fld <= High(fd.Memos)) then
      MyMemoBox.Text := fd.Memos[Fld];
    //MyMemoBox.Text := RetList[RetNo].Frm[FormNo].Memos[Fld];
  end;
end;

procedure TMyChild.GetFormSections(FName: string; SomeList: TstringList);
var
  LblSectList: TLabelSectList;
begin
  LblSectList := TLabelSectList.Create(RetList[retNo].MyApp);
  LblSectList.GetFormSections(FName, SomeList);
  LblSectList.Free;
end;

function TMyChild.GoToSection(ExceptForm: string): string;
var
  //I,J,MxPg,k,FNo:Integer;
  FName, FNonInst, FRootName, FInst: string;
  LblTop: Integer;
  FirstLine: string;
  SelectedString: string;
  MyScrollBox: TvtScrollBox;
begin
  (* Formerly: SectionButtonClick(Sender)
    ExceptForm deserves special handling, selected string returned as Result
  *)
  Result := '';
  MyScrollBox := ActiveForm;
  if MyScrollBox = nil then
    exit;

  SomeList.Clear; // := TStringList.Create;
  SomeCaption := 'Form TOC - Table Of Contents';
  GetFormSections(MyScrollBox.FormName, SomeList);

  if IsFormMultiPage(MyScrollBox.FormName) = false then
  begin
    //sort except the top
    FirstLine := SomeList[0];
    SomeList.Delete(0);
    SomeList.Sort; //really sort?
    SomeList.Sorted := False;
    SomeList.Insert(0, FirstLine);
  end;
  SelectedString := OutLnList(RetNo, SomeList, SomeCaption); //FirstLine);
  SomeList.Clear; //.Free

  if AllTrim(SelectedString) = '' then
    exit;

  //in can be INFO     and spaces
  //or bLbl1................................INFO    5
  //or bLbl2................................INFO    9
  if MidStr(SelectedString, 81, 15) = '' then
  begin
    FName := AllTrim(LeftStr(SelectedString, 10));
    if FName > '' then
      OpenForm(RetNo, FName, 0); //could be the second page - paged???
  end
  else //
  begin
    FName := AllTrim(MidStr(SelectedString, 81, 10)); //could be the second page
    if FName = '' then
      exit;
    LblTop := MyStrToInt(AllTrim(MidStr(SelectedString, 91, 5)));
    if FName = ExceptForm then
      Result := SelectedString //deserves special handling
    else
      OpenFormAtPos(RetNo, FName, LblTop);
  end;
end;

procedure TMyChild.HideAllControls; //20170130 Igor
var
  I: Integer;
begin
  for I := 0 to Self.ControlCount - 1 do
    Self.Controls[I].Visible := False;
  FControlHides := True; //20170717 Igor
end;

procedure TvtScrollBox.PopulateFormWithData;
var
  i, Fld: integer;
  cmp: TComponent;
  MyButton: TBitBtn absolute cmp;
  MyEditBox: TVtEdit absolute cmp;
  MyLabel: TvtLabel absolute cmp;
  MyMemoBox: TMemo absolute cmp;
  MyRichEdit: TRichEdit absolute cmp;
  CC: IvtConditionalControl; //20170321 Igor
begin
  (* Show default values for all controls, maybe FldId.
    Override to handle non-tax forms, like client letters.
    Override Show... methods to handle special fields.
  *)
  //20170321 Igor >>>
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[I].GetInterface(IvtConditionalControl, CC) then
      CC.InvalidateConditionalValues(nil);
  end;
  //20170321 Igor <<<

  for i := 0 to ComponentCount - 1 do
  begin
    cmp := Components[i];
    Fld := GetFieldId(cmp.Name);
    if cmp is TvtEdit then
    begin
      if not Self.AllowEditVertSeparator then//20171226 Igor
        MyEditBox.vtVertSeparator := False; //201209/01
      //If MyEditBox.vtDataSource=vtCalc then MyEditBox.TabStop:=False;
      ShowFieldData(MyEditBox);
    end
    else if cmp is TMemo then
    begin
      ShowMemoData(MyMemoBox, Fld);
    end
    else if cmp is TRichEdit then
    begin
      ShowRichData(MyRichEdit, Fld);
    end
    else if cmp is TBitBtn then
    begin
      MyButton.OnClick := FormButtonClick;
    end
    else if cmp is TControl then
      ShowOther(cmp);
  end;
  if MyChild <> nil then//20170719 Igor
    MyChild.UpdateFrames;
  //UpdateChildWin(RetNo);
end;

procedure TvtScrollBox.ShowOther(cmp: TComponent);
begin
  (* override to show special fields
  *)
    //NOP
end;

procedure TvtScrollBox.FormButtonClick(Sender: TObject);
begin
  (* override with actions
  *)
    //NOP
end;

procedure TvtScrollBox.ShowRichData(ARichEdit: TRichEdit; Fld: Integer);
var
  ss: TStringStream;
  s: string;
begin
  (* set Text including all text attributes.
    override to show interpreted text
  *)
  if Fld > 0 then
  begin
    if ShowFieldIdSw then
      ARichEdit.Text := '[' + IntToStr(Fld) + ']'
    else
    begin
      if not assigned(RetList[retNo]) then exit;
      if not assigned(RetList[retNo].Frm[FormNo]) then exit;
      if Fld >= Length(RetList[retNo].Frm[FormNo].Memos) then exit;
      s := RetList[retNo].Frm[FormNo].Memos[Fld];
      ss := TStringStream.Create(s);
      try
        ARichEdit.Lines.LoadFromStream(ss);
      finally
        ss.Free;
      end;
    end;
  end;
end;

procedure TMyChild.ShowUsedForms;
var
  i: integer;
  FRec: TFRec;
  FList: TFList;
begin
  Busy;
  FList := RetList[RetNo].MyApp.FList;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if RetList[RetNo].FormHasData[Frec.FormName+Frec.FormInst] then //20160820 //if RetList[RetNo].FormHasData[Frec.FormName] then
      OpenForm(RetNo, Frec.FormNo, 0);
  end;
  Done;
end;

class constructor TMyChild.Create;  //20170606 Igor
begin
  inherited;
  ChildCount := 0;
end;

function TMyChild.CreateForm(ParentForm: TWinControl; FNo: integer): TvtScrollBox;
begin
  (* Create a form of the right type
  *)
  Result := FormClass.Create(ParentForm, RetNo, FNo);
end;

procedure TMyChild.UpdateFrames;
begin
  if assigned(RetList[Self.RetNo]) AND not RetList[Self.RetNo].isAppendix then //20160704 Igor
  begin
    UpdateFormHeaderFrame;
    UpdateChildTaxPanel;
  end;
end;

procedure TMyChild.Pg1Click(Sender: TObject);
begin
  (* handler for page buttons
  *)
  ActiveForm.ScrollToPage(TPanel(sender).Tag);
end;

{$IFDEF flicker}

procedure TMyChild.Repaint;
begin
  if WindowLocks = 0 then
    inherited Repaint;
end;

procedure TMyChild.Update;
begin
  if WindowLocks = 0 then
    inherited;
end;

procedure TMyChild.WMPaint(var Message: TWMPaint);
begin
  if WindowLocks = 0 then
    inherited //WMPaint(Message)
  else
    Message.Result := -1; //debug
end;
{$ELSE}
{$ENDIF}

end.
