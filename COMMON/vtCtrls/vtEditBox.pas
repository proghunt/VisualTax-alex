unit vteditbox;
(* An edit box with many added features.
  Captures on OnEnterField, OnExitField,OnVtEditDblClick

Check: Refresh really required?
*)

(* Expected behaviour:
  Modifications are stored when a field is left with Enter or up/down.
  Checkboxes (grouped) set the text to 'X' on Y, Space or (left) mouse button.
  Other checkboxes clear on N, set on Y, toggle on Space or LMB.
*)

 {$DEFINE SharedCanvas} //using one Canvas object for all controls?

interface

//20170407 Igor >>>
{$R vtEditBox.RES}
//20170407 Igor <<<
uses
  System.SysUtils, System.Classes, VCL.Controls, VCL.StdCtrls,
  VCL.Graphics, WinAPI.Windows, WinAPI.Messages, VCL.Forms, VCL.dialogs,
  VCL.mask,
  VCL.extctrls, vtControlIntf, Vcl.Buttons, System.Generics.Collections; //, vtDeclare; //20170127 Igor //20170407 Igor

var //adjustable in UpdateEditProps
  FontColor: TColor = clBlack;
  BackColor: TColor = clWhite;
  //for dito
  LastValue: string;
  //unused
    //ActiveColor: TColor = $FFFF40;  // RGB($40, $FF, $FF);
//20170407 Igor >>>
const
  STR_BTN_INSERTROW = 'INSERTROW';
  STR_BTN_ROWUP = 'ROWUP';
  STR_BTN_ROWDOWN = 'ROWDOWN';
  STR_BTN_DELETEROW = 'DELETEROW';
  STR_BTN_MOVE = 'ROWMOVE'; //20170411 Igor
  STR_BTN_ARROWMOVEDOWN = 'ARROWMOVEDOWN'; //20170411 Igor
  STR_BTN_ARROWMOVEUP = 'ARROWMOVEUP'; //20170411 Igor
  //20170609 Igor >>>
  UM_RELEASETABLEBUTTONS = WM_USER + 1;
  UM_INSERTROW = WM_USER + 2;
  UM_ROWUP = WM_USER + 3;
  UM_ROWDOWN = WM_USER + 4;
  UM_DELETEROW = WM_USER + 5;
//20170407 Igor <<<

type
  TvtLocationVariables = class(TPersistent)
  private
    FvtTableNum: Integer;
    FvtTableColumnNum: Integer;
    FvtTableRowNum: Integer;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property vtTableNum: Integer read FvtTableNum write FvtTableNum;
    property vtTableColumnNum: Integer read FvtTableColumnNum write FvtTableColumnNum;
    property vtTableRowNum: Integer read FvtTableRowNum write FvtTableRowNum;
  end; //type TvtLocationVariables

type
  TvtPopData = class(TPersistent)
  private
    FvtPopCaption: string;
    FvtPopFileName: string;
    FvtPopValues: TStrings;
    FvtPopFieldLength: Integer;

    procedure setVtPopValues(Value: TStrings);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property vtPopCaption: string read FvtPopCaption write FvtPopCaption;
    property vtPopFileName: string read FvtPopFileName write FvtPopFileName;
    property vtPopFieldLength: Integer read FvtPopFieldLength write FvtPopFieldLength;
    property vtPopValues: TStrings read FvtPopValues write setVtPopValues;
  end;

type
  (* Input checking, special behaviour
  *)
  { TODO -oCon : specify the meaning of these items }
  TInputType = (
    vtString, //anything, unchecked
    vtNumber, //digits only
    vtPhoneNumber, //specify in Mask(?)
    vtDollar, //only real values. 0.0 is stored and displayed as empty string.
    vtDateT1, //show yyyy-mm-dd, store yyyymmdd
    vtDateT2, //show yyyy/mm/dd, store yyyymmdd
    vtSin, //9 digits
    vtPostal,
    vtZip,
    vtBN, // Business Number (Mask: 999999999RC0001)
    vtDropDownBox, //what? (vtDataSource=vtPopupList?)
    vtCheckBox, // empty or X, may be grouped by vtRadioGroup
    vtYesOrNo, //Y or N
    vtPercent //0..100 only
    );
  TCheckBoxTypes = vtCheckBox..vtYesOrNo;

  { TODO -oCon : specify the meaning of these items }
  TTypeAhead = (
    vtNoTypeAhead,
    vtCharity,
    vtCities,
    vtDoctors,
    vtEmployerNames,
    vtFinancialInstitutions,
    vtFirstNames,
    vtMedicalExpenses
    );
const
  PredictFile: array[TTypeAhead] of string = (
    '', 'Charity.txt', 'Cities.txt', 'Doctors.txt', 'Employers.txt',
    'Banks.txt', 'FirstNm.txt', 'MedExp.txt'
    );

type
  { TODO -oCon : specify the meaning of these items }
  TDataSource = (
    vtUser, //input, according to InputType
    vtLinked, //show related form(s) on keypress - show WHAT as value???
    vtCalc, //how? (means: value copied from somewhere else?)
    vtPopuplist, //which one? TvtPopData?
    vtAddingTape, //use AddingTape form for input
    vtOverride //overridden field
    );

  //box frame, used in WMPaint
  TBorderType = (
    vtnoBorder,
    vtFull, //TLBR
    vtSides, //LR ???
    vtUnderline, //B
    vtDoubleUnderLine, //B double line
    vtTopBottomLine //TB
    );

  //text vertical align
  TLayout = (vtTop, vtBottom, vtMiddle);

  //20170407 Igor >>>
  TTableAction = (taInsertRow, taUP, taDown, taDelete, taMove);
  TTableActions = set of TTableAction;

  TvtButtonEx = class;
  //20170407 Igor <<<

  TvtErrorState = (esNone, esMandatory, esError, esWarning); //20160301 Igor
  TvtCompareState = (csNoCompare, csOutdated, csEqual, csNotEqual); //20160314 Igor
  TDrawMoveArrow = (dmaNone, dmaUp, dmaDown); //20170411 Igor
  TDrawMoveLine = (dmlNone, dmlUp, dmlDown); //20170411 Igor
  TRoundKind = (rkNone, rkMath, rkUp, rkDown); //20170612 Igor
  TvtEdit = class(TMaskEdit, IvtControl, IvtPopupedControl) //20170127 Igor //20170407 Igor
  private
    FFieldId: integer;
    FvtLVars: TvtLocationVariables;
    FvtPopData: TvtPopData;
    FOldBackColor: TColor;
    FColorOnEnter: TColor;
    FAlignment: TAlignment;
    FTabOnEnter: boolean;

    FShadedDec: boolean;
    FisPrintable: boolean;
    FAllowNegative: boolean;
    FinputType: TinputType;

    Fprefix: string;
    FRadioGroup: string;

    FdataSource: TdataSource;
    FtypeAhead: TtypeAhead;
    FBorderType: TBorderType;

    FPenThickness: Integer;
    FDecimalPlaces: Integer;
    FvtLowBound: integer;
    FvtHighBound: integer;

    FVertSeparator: Boolean;
    FReviewOn: Boolean;
    FLayout: TLayout;

    FBorderFocusColor: TColor;
    FBorderColor: TColor;
{$IFDEF SharedCanvas}
{$ELSE}
    //Canvas: TCanvas; // 20151105 igor
{$ENDIF}
    FvtErrorState: TvtErrorState; //20160301 Igor;
    FvtCompareState: TvtCompareState; //20160301 Igor
    FvtOldValue: String; //20170219 Igor
    //20170407 Igor >>>
    FvTTableActions: TTableActions;
    FButtons: TObjectList<TvtButtonEx>;
    //20170407 Igor <<<
    FDrawMoveArrow: TDrawMoveArrow; //20170411 Igor
    FDrawMoveLine: TDrawMoveLine; //20170411 Igor
    //20170612 igor >>>
    FvtAllowOverride: Boolean;
    FvtRoundKind: TRoundKind;
    FvtSyncCleaning: TStrings;
    //20170612 igor <<<
    FvtWordWrap: boolean; //20180220 Igor
    //20230411 Igor >>>
    FDynamicRow: Integer;
    FDynamicFirstElmId: Integer;
    //20230411 Igor <<<
    procedure SetInputType(const Value: TinputType);
    procedure SetPrefix(const Value: string);
    procedure SetRadioGroup(const Value: string);
    procedure SetBorderType(const Value: TBorderType);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetDataSource(const Value: TDataSource);
    procedure SetPenThickness(const Value: Integer);
    procedure SetDecimalPlaces(const Value: Integer);
    procedure SetVertSeparator(Value: Boolean);
    procedure SetLayout(Value: TLayout);
    procedure _RecreateWnd;
    procedure SetvtHighBound(const Value: integer);
    procedure SetvtLowBound(const Value: integer);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    function GetFieldId: integer;
    procedure SetCompareState(Value: TvtCompareState);
    procedure SetColor(Value: TColor);
    function GetColor: TColor;
    function GetAllowNegative: boolean;
    function GetvtIsPrintable: boolean; //20170127 Igor
    function GetvtOldValue: String; //20170219 Igor
    procedure SetvtOldValue(const Value: String); //20170219 Igor
    //20170407 Igor >>>
    procedure IniTTableActions;
    procedure ReleaseTableButtons;
    //20170407 Igor <<<
    procedure SetDrawMoveArrow(const Value: TDrawMoveArrow); //20170411 Igor
    procedure SetDrawMoveLine(const Value: TDrawMoveLine); //20170411 Igor
    //20170612 igor >>>
    procedure SetvtAllowOverride(const Value: Boolean);
    procedure SetvtRoundKind(const Value: TRoundKind);
    procedure DoRoundValue;
    procedure SetvtSyncCleaning(const Value: TStrings);
    procedure DoSyncClean;
    //20170612 igor <<<
  protected
    procedure SetName(const NewName: TComponentName); override;

    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DblClick; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure CreateParams(var Params: TCreateParams); override;

    procedure setVtPopData(const Value: TvtPopData);

    procedure SetBorderColor(AColor: TColor);
    procedure SetBorderFocusColor(AColor: TColor);
    procedure SetvtLVars(const Value: TvtLocationVariables);
    //20170407 Igor >>>
    procedure CMMOUSEENTER(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMOUSELEAVE(var Message: TMessage); message CM_MOUSELEAVE;
    //20170609 Igor >>>
    procedure UMRELEASETABLEBUTTONS(var Message: TMessage); message UM_RELEASETABLEBUTTONS;
    procedure UMINSERTROW(var Message: TMessage); message UM_INSERTROW;
    procedure UMROWUP(var Message: TMessage); message UM_ROWUP;
    procedure UMROWDOWN(var Message: TMessage); message UM_ROWDOWN;
    procedure UMDELETEROW(var Message: TMessage); message UM_DELETEROW;
    //20170609 Igor <<<
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function MouseNotLeave: Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override; //20170407 Igor
    function AdditionalMenuItems: TAdditionalMenuItems;
    function GetActionByTableButton(ATableButton: TTableAction): TNotifyEvent;
    procedure TableAction(AAtction: TEditButtonAction; Sender: TObject = nil); //20170411 Igor
    procedure TableActionInsertRow(Sender: TObject);
    procedure TableActionRowUp(Sender: TObject);
    procedure TableActionRowDown(Sender: TObject);
    procedure TableActionDeleteRow(Sender: TObject);
    //20170407 Igor <<<
    procedure TableActionMove(Sender: TObject); //20170411 Igor
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Clone: TvtEdit;
  public //some properties
    AddingTape: TForm;
    property FieldId: integer read GetFieldId write FFieldId;
    property vtErrorState: TvtErrorState read FvtErrorState write FvtErrorState default esNone; //20160301 Igor
    property vtCompareState: TvtCompareState read FvtCompareState write SetCompareState default csNoCompare; //20160301 Igor
    property vtOldValue: String read GetvtOldValue write SetvtOldValue; //20170219 Igor
    function SameValues(AValue1, AValue2: String): Boolean; //20170408 Igor
    property DrawMoveArrow: TDrawMoveArrow read FDrawMoveArrow write SetDrawMoveArrow;//20170411 Igor
    property DrawMoveLine: TDrawMoveLine read FDrawMoveLine write SetDrawMoveLine;//20170411 Igor
    //20230411 Igor >>>
    property DynamicRow: Integer read FDynamicRow write FDynamicRow;
    property DynamicFirstElmId: integer read FDynamicFirstElmId write FDynamicFirstElmId;
    //20230411 Igor <<<
  published
    property vtPopData: TvtPopData read FvtPopData write FvtPopData;

    property vtAlignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property vtColorOnEnter: TColor read FColorOnEnter write FColorOnEnter stored False;
    property vtTabOnEnter: boolean read FTabOnEnter write FTabOnEnter;
    property vtShadedDec: boolean read FShadedDec write FShadedDec default False;
    property vtIsPrintable: boolean read GetvtIsPrintable write FisPrintable default True; //20170127 Igor
    property vtAllowNegative: boolean read GetAllowNegative write FAllowNegative default True;
    property vtDataSource: TdataSource read FdataSource write SetDataSource;
    property vtTypeAhead: TtypeAhead read FtypeAhead write FtypeAhead;
    property vtInputType: TinputType read FinputType write SetInputType;
    property vtPrefix: string read FPrefix write SetPrefix;
    property vtRadioGroup: string read FRadioGroup write SetRadioGroup stored False; //wront type!
    property vtOldBackColor: TColor read FOldBackColor write FOldBackColor stored False;
    property vtBorderType: TBorderType read FBorderType write SetBorderType;
    property vtPenThickness: Integer read FPenThickness write SetPenThickness default 1;
    property vtDecimalPlaces: Integer read FDecimalPlaces write SetDecimalPlaces default 2;
    property vtReviewOn: Boolean read FReviewOn write FReviewOn default false;
    property vtLayout: TLayout read FLayout write SetLayout;
    property vtVertSeparator: Boolean read FVertSeparator write SetVertSeparator default false; //FVertSeparator
    property BorderColor: TColor read FBorderColor write SetBorderColor default clWindowFrame;
    property BorderFocusColor: TColor read FBorderFocusColor write SetBorderFocusColor default clRed;

    property vtLVars: TvtLocationVariables read FvtLVars write FvtLVars;
    property vtRangeLow: integer read FvtLowBound write SetvtLowBound default 0;
    property vtRangeHigh: integer read FvtHighBound write SetvtHighBound default 0;
    property Color: TColor read GetColor write SetColor;

    property vTTableActions: TTableActions read FvTTableActions write FvTTableActions default []; //20170407 Igor
    //20170612 Igor >>>
    property vtAllowOverride: Boolean read FvtAllowOverride write SetvtAllowOverride default True;
    property vtRoundKind: TRoundKind read FvtRoundKind write SetvtRoundKind default rkNone;
    property vtSyncCleaning: TStrings read FvtSyncCleaning write SetvtSyncCleaning;
    //20170612 Igor <<<
    property vtWordWrap: boolean read FvtWordWrap write FvtWordWrap default false; //20180220 Igor
  end;
  //20170407 Igor >>>
  TvtButtonEx = class(TBitBtn)
  private
    FTableButton: TTableAction;
    FEdit: TvtEdit;
    //20170411 Igor >>>
    FMove: Boolean;
    FStartX: Integer;
    FStartY: Integer;
    FTargetEdit: TvtEdit;
    FAbortClick: Boolean;
    FButtonClickEvent: TNotifyEvent;
    procedure SetButtonClickEvent(const Value: TNotifyEvent);
    //20170411 Igor <<<
  protected
    procedure CMMOUSEENTER(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMOUSELEAVE(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    //20170411 Igor >>>
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    //20170411 Igor <<<
  public
    constructor CreateBtn(AOwner: TvtEdit; ATableButton: TTableAction);
    property TableButton: TTableAction read FTableButton write FTableButton;
    property AbortClick: Boolean read FAbortClick write FAbortClick;
    property ButtonClickEvent: TNotifyEvent read FButtonClickEvent write SetButtonClickEvent;
  end;
  //20170407 Igor <<<
  //moved out of CommonRtns
function VL(s: string): Real;
function ShowFieldId(const FieldId: string): string;
function Unformat(AVal: String): String;//20170904 Igor

const
  vtSinChars = ['0'..'9'];
  vtNumberChars = ['0'..'9', '-'];
  vtDollarChars = vtNumberChars + ['.'];
  YesNoSet = ['Y', 'N', ' '];
  //20170407 Igor >>>
  C_EditButtonAction: array [TTableAction] of TEditButtonAction =
    (ebaInsertRow, ebaRowUp, ebaRowDown, ebaDeleteRow, ebaMove); //20170411 Igor
  C_Res: array[TTableAction] of string =
    (
      STR_BTN_INSERTROW,
      STR_BTN_ROWUP,
      STR_BTN_ROWDOWN,
      STR_BTN_DELETEROW,
      STR_BTN_MOVE
    );
  C_Captions: array[TTableAction] of string =
    (
      'Insert new line before this line.',
      'Move this line up.',
      'Move this line down.',
      'Delete this line.',
      'Move this line manualy (press mouse button, drag and drop or click and type new row number).'
    );
  //20170407 Igor <<<

procedure Register;

implementation

uses
  vtForm, VCL.Themes, WinApi.Dwmapi, winApi.UxTheme, VCL.Menus; //20170407 Igor

{$IFDEF SharedCanvas}
//var
  //Canvas: TControlCanvas;
{$ELSE}
{$ENDIF}

//20170612 Igor >>>
function Unformat(AVal: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to length(AVal) do
  begin
    //20170904 Igor>>>
    if CharInSet(AVal[I], ['0','1','2','3','4','5','6','7','8','9'])
       or
       (
         CharInSet(AVal[I], ['.','-','+'])
         AND
         not(Result.Contains(AVal[I]))
       )  then
    //20170904 Igor<<<
      Result := Result + AVal[I];
  //20170904 Igor<<<
  end;
end;
//20170612 Igor <<<

function FindvtEditAtPos(AParent: TWinControl; APoint: TPoint): TvtEdit;
var
  I: Integer;
begin
  for I := 0 to AParent.ControlCount - 1 do
    if AParent.Controls[I] is TvtEdit then
      if PtInRect(Rect(AParent.Controls[I].Left,
                       AParent.Controls[I].Top,
                       AParent.Controls[I].Left + AParent.Controls[I].Width,
                       AParent.Controls[I].Top + AParent.Controls[I].Height), APoint) then
        Exit(TvtEdit(AParent.Controls[I]));
  Result := nil;
end;

function SameTable(AEdit1, AEdit2: TvtEdit): Boolean;
var
  I: IvtForm;
Begin
  if AEdit1.Parent <> AEdit2.Parent then
    Exit(False);
  if AEdit1.Parent = nil then
    Exit(False);
  if AEdit1.Parent.GetInterface(IvtForm, I) then
  Begin
    Result := I.SameTable(AEdit1.FieldId, AEdit2.FieldID);
  End
  else
    Result := False;
End;

function SameColumn(AEdit1, AEdit2: TvtEdit): Boolean;
var
  I: IvtForm;
Begin
  if AEdit1.Parent <> AEdit2.Parent then
    Exit(False);
  if AEdit1.Parent = nil then
    Exit(False);
  if AEdit1.Parent.GetInterface(IvtForm, I) then
  Begin
    Result := I.SameColumn(AEdit1.FieldId, AEdit2.FieldID);
  End
  else
    Result := False;
End;

function isLastRow(AEdit: TvtEdit): Boolean;
var
  I: IvtForm;
Begin
  if AEdit.Parent = nil then
    Exit(False);
  if AEdit.Parent.GetInterface(IvtForm, I) then
  Begin
    Result := I.isLastRow(AEdit.FieldId);
  End
  else
    Result := False;
End;

function VL(s: string): Real;
var
  Code: integer;
begin
  if s = '' then
  begin Result := 0;
    exit;
  end;
  s := StringReplace(s, ',', '', [rfReplaceAll, rfIgnoreCase]);
  Val(s, Result, Code);
end;

function ShowFieldId(const FieldId: string): string;
begin
  Result := '[' + FieldId + ']'
end;

procedure Register;
begin
  RegisterComponents('VisualTax', [TvtEdit]);
end;

{ TvtEdit }

constructor TvtEdit.Create(AOwner: TComponent);
begin
  inherited;
  FvtSyncCleaning := TStringList.Create; //20170612 Igor
  FvtLVars := TvtLocationVariables.Create();
  FvtPopData := TvtPopData.Create;
  FvtPopData.FvtPopValues := TStringList.Create; //must be tstringlist not Tstrings to avoid 'abstract error'...

  if csDesigning in ComponentState then //20160522 Igor
  begin
    Text := '';
    FColorOnEnter := clWhite; //clInfobk;
    FAlignment := taLeftJustify;
    FTabOnEnter := True;
    FShadedDec := False;
    FisPrintable := True;
    Color := clWhite;
    FBorderType := vtUnderline;
    Font.style := [];
    Font.Name := 'Arial';
    Font.Size := 8;
    FinputType := vtString;
    Height := 14;
    FPenThickness := 1;
    {Default Colors...}
    // FBorderFocusColor := clRed;
    FBorderColor := clWindowFrame;
    ShowHint := True;
  end;
  vtErrorState := esNone; //20160301 Igor
  FShadedDec := False;
  FisPrintable := True;
  BorderStyle := bsnone; //we want to draw the borders ourselves
  FAllowNegative := True; //20160527 Igor
  //20170612 Igor >>>
  FvtAllowOverride := True;
  vtRoundKind := rkNone;
  //20170612 Igor <<<
  //AutoSelect := True; //DEL will erase everything (after entering?)
{We need a Canvas to do the trick...}
{$IFDEF SharedCanvas}
{$ELSE}
  Canvas := TControlCanvas.Create;
  TControlCanvas(Canvas).Control := self;
{$ENDIF}
   //20170407 Igor >>>
  FvTTableActions := [];
  FButtons := TObjectList<TvtButtonEx>.Create(False);
   //20170407 Igor <<<
end; (*Create*)

destructor TvtEdit.Destroy;
begin
  FvtLVars.Free;

  FvtPopData.FvtPopValues.Free;
  FvtPopData.Free;
{$IFDEF SharedCanvas}
{$ELSE}
  Canvas.Free;
{$ENDIF}
//20170407 Igor >>>
  ReleaseTableButtons;
  FreeAndNil(FButtons);
//20170407 Igor <<<
  FreeAndNil(FvtSyncCleaning); //20170612 Igor
  inherited Destroy;
end; {Destroy}

procedure TvtEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array[TAlignment] of DWORD = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or Alignments[FAlignment];
  end;
  //AdjustClientRect() - inherited from TWinControl.
  //there: WM_NCCALCSIZE performs our BorderWidth logic
end; (*CreateParams*)

procedure TvtEdit._RecreateWnd;
begin
  (* called by changed settings.
    Except for vtAlignment NO RecreateWnd is required.
    Only request update, don't paint with every single change.
  *)
  Invalidate;
end;

function TvtEdit.GetAllowNegative: boolean;
begin
  Result := FAllowNegative;
end;

function TvtEdit.GetColor: TColor;
begin
//20160314 Igor
  if vtCompareState = csNotEqual then
    Result := $00BFFFFF
  else
    Result := inherited Color;
end;

function TvtEdit.GetFieldId: integer;
var
  i: integer;
begin
  (* Optimized get number from end of an string
  *)
  Result := FFieldId;
  if Result > 0 then
    exit; //already calculated
  for i := 1 to length(Name) do
  begin
    if CharInSet(Name[i], ['0'..'9']) then  //20150701
      Result := Result * 10 + ord(Name[i]) - ord('0')
    else
      Result := 0; //restart with next digit
  end;
  FFieldId := Result;
end;

function TvtEdit.GetvtIsPrintable: boolean; //20170127 Igor
begin
  Result := FisPrintable;
end;

function TvtEdit.GetvtOldValue: String;
begin
  Result := FvtOldValue;//20170220 Igor
end;

procedure TvtEdit.DoEnter;
var
  MyBox: TvtForm;
begin
  FvtOldValue := Text; //20170219 Igor
  MyBox := GetVtForm(self);
  if assigned(mybox) then
    MyBox.OnEnterField(self);
  SelectAll;
  //LastActive := Self; - occurs BEFORE Click
  inherited;
  //RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_INTERNALPAINT or RDW_FRAME);
  Invalidate;
  //Repaint;
end; (*DoEnter*)

procedure TvtEdit.DoExit;
var
  MyBox: TvtForm;
begin
  DoRoundValue; //20170612 Igor
  MyBox := GetVtForm(self);
  if assigned(mybox) then
    MyBox.OnExitField(self);
  DoSyncClean; //20170612 Igor
  inherited;
  //RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_INTERNALPAINT or RDW_FRAME);
  Invalidate;
  //Repaint;
  FvtOldValue := Text; //20170219 Igor
end;

procedure TvtEdit.DoRoundValue; //20170612 Igor
var
  C, C1: Real;
  OldDecimalSeparator: Char;
begin
  if (FvtOldValue <> Text) AND (vtRoundKind <> rkNone) AND  (vtInputType = vtDollar) AND (Text <> '') then
  begin
    C := VL(Unformat(Text));
    C1 := Round(C);
    case vtRoundKind of
      rkUp:
        begin
          if C1 < C then
            C1 := C1 + 1;
        end;
      rkDown:
        begin
          if C1 > C then
            C1 := C1 - 1;
        end;
    end;
    if C1 <> C then
    begin
      OldDecimalSeparator := FormatSettings.DecimalSeparator;
      FormatSettings.DecimalSeparator := '.';
      try
        Text := FloatToStr(C1);
      finally
        FormatSettings.DecimalSeparator := OldDecimalSeparator;
      end;
    end;
  end;
end;

procedure TvtEdit.DoSyncClean; //20170612 Igor
var
  S, TargetEditName: String;
  ID: Integer;
  C: TComponent;
begin
  if (FvtOldValue <> Text) AND (Text = '') AND Assigned(Self.Owner) then
  begin
    for S in FvtSyncCleaning do
    begin
      if trim(S) = '' then
        Continue;
      if (S[1] = '+') or (S[1] = '-') then //Relative addressing
      begin
        if TryStrToInt(trim(S), ID) then
        begin
          ID := Self.FieldId + ID;
          TargetEditName := 'vtEdit' + IntToStr(ID);
        end;
      end
      else
      if TryStrToInt(trim(S), ID) then //Absolute FieldID
        TargetEditName := 'vtEdit' + IntToStr(ID)
      else //Absolute EditName
        TargetEditName := trim(S);
      C := Self.Owner.FindComponent(TargetEditName);
      if Assigned(C) and (C is TvtEdit) and (TvtEdit(C).Text <> '') then
      begin
        TvtEdit(C).FvtOldValue := TvtEdit(C).Text;
        TvtEdit(C).Text := '';
        TvtEdit(C).DoExit;
      end;
    end;
  end;
end;

(*DoExit*)

procedure TvtEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  MyBox: TvtForm;
begin
  inherited MouseDown(Button, Shift, X, Y); //20170408 Igor
  ReleaseTableButtons; //20170407 Igor;
  MyBox := GetVtForm(self);
  if assigned(mybox) then
    MyBox.EditBoxMouseDown(Self, Button, Shift, X, Y);
end;

procedure TvtEdit.DblClick;
var
  MyBox: TvtForm;
begin
  (* double click or keypress on vtLinked, vtPopUp, vtAddingTape field
  *)
  ReleaseTableButtons; //20170407 Igor;
  MyBox := GetVtForm(self);
  if assigned(mybox) then
  begin
    MyBox.OnVtEditDblClick(Self);
  end;
  inherited;
end;

//20170407 Igor >>>
procedure TvtEdit.CMMOUSEENTER(var Message: TMessage);
begin
  inherited;
  IniTTableActions;
end;

function TvtEdit.MouseNotLeave: Boolean;
  function MouseOverControl(AControl: TControl): Boolean;
  var
    P: TPoint;
    R: TRect;
  begin
    if AControl = nil then
      Exit(false);
    P := AControl.ClientToScreen(Point(0,0));
    R.Left := P.X;
    R.Top := P.Y;
    R.Right := P.X + AControl.Width;
    R.Bottom := P.Y + AControl.Height;
    Result := PtInRect(R, Mouse.CursorPos);
  end;
var
  B: TvtButtonEx;
begin
  for B in FButtons do
    if MouseOverControl(B) then
      Exit(True);
  Result := MouseOverControl(Self);
end;

procedure TvtEdit.CMMOUSELEAVE(var Message: TMessage);
begin
  inherited;
  if MouseNotLeave then
    Exit;
  ReleaseTableButtons;
end;

procedure TvtEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and
     (AComponent is TvtButtonEx) and
     FButtons.Contains(TvtButtonEx(AComponent)) then
    FButtons.Remove(TvtButtonEx(AComponent));
end;

procedure TvtEdit.IniTTableActions;
var
  L: Integer;
const
  c_btnWidth = 12;
  procedure InitButton(ATableButton: TTableAction);
  var
    Button: TvtButtonEx;
  begin
    //Button := nil; //20170612 igor
    for Button in FButtons do
      if Button.TableButton = ATableButton then
        Exit;

    Button := TvtButtonEx.CreateBtn(Self, ATableButton);
    if ATableButton = taMove then
    begin
      Button.SetBounds(Self.Left + Self.Width - Self.Height,
                       Self.Top + 1, Self.Height - 2, Self.Height - 2);

    end
    else
    begin
      Button.SetBounds(Self.Left + L, Self.Top - (c_btnWidth div 2), c_btnWidth, c_btnWidth);
      inc(L, c_btnWidth);
    end;
    Button.Parent := Self.Parent;
    Button.ButtonClickEvent := GetActionByTableButton(ATableButton);
    FButtons.Add(Button);
  end;
var
  tb: TTableAction;
begin
  L := 0;
  for tb := Low(TTableAction) to High(TTableAction) do
    if tb in FvTTableActions then
      InitButton(tb);
end;

procedure TvtEdit.KeyDown(var Key: Word; Shift: TShiftState); //20170407 Igor
begin
  ReleaseTableButtons;
  inherited KeyDown(Key, Shift);
end;

procedure TvtEdit.ReleaseTableButtons;
begin
  while FButtons.Count > 0 do
    FButtons[0].Free;
  FButtons.Clear;
end;

function TvtEdit.AdditionalMenuItems: TAdditionalMenuItems;
  procedure AddMenuItem(ATableButton: TTableAction);
  var
    MI: TMenuItem;
  begin
    SetLength(Result, Length(Result) + 1);
    MI := TMenuItem.Create(Self);
    MI.Caption := C_Captions[ATableButton];
    MI.OnClick := GetActionByTableButton(ATableButton);
    MI.Tag := C_VtControlsMenuTag;
    Result[Length(Result) - 1] := MI;
  end;
var
  tb: TTableAction;
Begin
  SetLength(Result, 0);
  for tb := Low(TTableAction) to High(TTableAction) do
    if tb in FvTTableActions then
      AddMenuItem(tb);
End;

function TvtEdit.GetActionByTableButton(ATableButton: TTableAction): TNotifyEvent;
Begin
  case ATableButton of
    taInsertRow:
      Result := TableActionInsertRow;
    taUP:
      Result := TableActionRowUp;
    taDown:
      Result := TableActionRowDown;
    taDelete:
      Result := TableActionDeleteRow;
//20170411 Igor >>>
    taMove:
      Result := TableActionMove;
//20170411 Igor <<<
  else
    Result := nil;
  end;
End;

procedure TvtEdit.TableAction(AAtction: TEditButtonAction; Sender: TObject = nil);
var
  I: IvtForm;
begin
  if Self = nil then
    exit;
  //20170612 igor >>>
  if Sender is TvtButtonEx then
    Sender := nil;
  //20170612 igor <<<
  ReleaseTableButtons;
  if (Owner <> nil) and
     Owner.GetInterface(IvtForm, I) then

    I.EditButtonClick(Self, AAtction, Sender);
end;

//20170609 Igor >>>
procedure TvtEdit.TableActionInsertRow(Sender: TObject);
begin
  PostMessage(Self.Handle, UM_INSERTROW, 0, 0);
end;

procedure TvtEdit.TableActionRowUp(Sender: TObject);
begin
  PostMessage(Self.Handle, UM_ROWUP, 0, 0);
end;

procedure TvtEdit.UMDELETEROW(var Message: TMessage);
begin
  TableAction(ebaDeleteRow);
end;

procedure TvtEdit.UMINSERTROW(var Message: TMessage);
begin
  TableAction(ebaInsertRow);
end;

procedure TvtEdit.UMRELEASETABLEBUTTONS(var Message: TMessage);
begin
  Self.ReleaseTableButtons;
end;

procedure TvtEdit.UMROWDOWN(var Message: TMessage);
begin
  TableAction(ebaRowDown);
end;

procedure TvtEdit.UMROWUP(var Message: TMessage);
begin
  TableAction(ebaRowUp);
end;

procedure TvtEdit.TableActionRowDown(Sender: TObject);
begin
  PostMessage(Self.Handle, UM_ROWDOWN, 0, 0);
end;

procedure TvtEdit.TableActionDeleteRow(Sender: TObject);
begin
  PostMessage(Self.Handle, UM_DELETEROW, 0, 0);
end;
//20170609 Igor <<<

procedure TvtEdit.TableActionMove(Sender: TObject);
//20170612 Igor >>>
//var
//  I: IvtForm;
//20170612 Igor <<<
begin
  if (Sender is TvtButtonEx) and
     (Sender as TvtButtonEx).AbortClick then
  Begin
    (Sender as TvtButtonEx).AbortClick := False;
    Exit;
  End;
  TableAction(ebaMove, Sender);
end;

procedure TvtEdit.WMPaint(var Message: TWMPaint);
var
  R: TRect;
  DC: HDC;
  PS: TPaintStruct;
  AlignTopBottomVar: Integer;
  NameText: string;
  Canvas: TCanvas;
  DeltaLeft: Integer; //20161115 igor
  MoveArrowX, MoveArrowY: Integer; //20170411 Igor
  BMP: VCL.Graphics.TBitmap; //20170411 Igor
  poligon: Array of TPoint;
begin
  Canvas := TCanvas.Create; // 20151105 igor
  if csDesigning in ComponentState then
  begin
    text := '';
    NameText := Name;
    Hint := '';
  end
  else
    NameText := Text;


  try
    //Need this to start painting...
    DC := Message.DC;
    if (DC = 0) then
      DC := BeginPaint(Handle, PS);

    Canvas.Handle := DC;
    Canvas.Font := Font;

    Canvas.Brush.Color:=Color;      // 20151210 Igor
    //20160314 Igor
    if vtCompareState = csNotEqual then
      Canvas.Font.Color := clRed;

    Canvas.Pen.Color:=FBorderColor; // 20151210 Igor
    R := ClientRect;
    Canvas.FillRect(R); // 20151105 igor

    with Canvas do
    begin
      Brush.Style := bsClear;
      Brush.Color := Color; //Brush.Style := bsClear;
      Pen.Color := FBorderColor;

      if self.Focused then
        AlignTopBottomVar := R.Top
      else
      begin
        if FLayout = vtTop then
          AlignTopBottomVar := R.Top
        else if FLayout = vtMiddle then
          AlignTopBottomVar := (Height div 2) - (TextHeight(NameText) div 2)
        else //if FLayout = vtBottom then
          AlignTopBottomVar := R.Bottom - TextHeight(NameText);
      end;

      if FAlignment = taLeftJustify then
      begin
        SetTextAlign(dc, TA_LEFT);
        Canvas.Textout(2, AlignTopBottomVar, NameText);
        //20161115 Igor >>>
        if (SelLength <> 0) and Focused then
        begin
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Color := clNavy;
          Canvas.Font.Color := clWhite;
          DeltaLeft := Canvas.TextWidth(copy(NameText, 1, SelStart{ - 1}));
          Canvas.Textout(2 + DeltaLeft , AlignTopBottomVar, SelText);
        end;
        //20161115 Igor <<<
      end
      else if FAlignment = taRightJustify then
      begin
        SetTextAlign(dc, TA_RIGHT);
        Canvas.Textout(R.Left + Width - 3, AlignTopBottomVar, NameText);
        //20161115 Igor >>>
        if (SelLength > 0) and Focused then
        begin
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Color := clNavy;
          Canvas.Font.Color := clWhite;
          DeltaLeft := Width - Canvas.TextWidth(copy(NameText, SelStart + 1 + SelLength, MaxInt)) - 3; //20170408 Igor
          Canvas.Textout(R.Left + DeltaLeft, AlignTopBottomVar, SelText); //20170408 Igor
        end;
        //20161115 Igor <<<

      end
      else if FAlignment = taCenter then
      begin
        SetTextAlign(dc, TA_CENTER);
        Canvas.Textout(Width div 2, AlignTopBottomVar, NameText);
        //20161115 Igor >>>
        if (SelLength > 0) and Focused then
        begin
          Canvas.Brush.Style := bsSolid;
          Canvas.Brush.Color := clNavy;
          Canvas.Font.Color := clWhite;
          DeltaLeft := (Width div 2)
            - (TextWidth(NameText) div 2)
            + TextWidth(copy(NameText, 1, SelStart))
            + (TextWidth(copy(NameText, SelStart + 1, SelLength)) div 2); //20170408 Igor
          Canvas.Textout(R.Left + DeltaLeft, AlignTopBottomVar, SelText); //20170408 Igor
        end;
        //20161115 Igor <<<

      end;
    end; //with

    // add prefix i.e some text + - +- etc
    if (FinputType in [vtDollar, vtNumber]) AND (FPrefix <> '') then //20180128 Igor
    begin
      SetTextAlign(dc, TA_LEFT);
      Canvas.Textout(0, AlignTopBottomVar, FPrefix);
    end;

    //draw vertical Line
    if vtVertSeparator = True then
    begin
      Canvas.Pen.Width := 1;
      if fBorderType = vtDoubleUnderLine then
        Canvas.Rectangle(R.Right - Canvas.TextWidth(' 00') - 1, 0, R.Right - Canvas.TextWidth(' 00') - 2, 0 + Height - 3) //Canvas.Rectangle(R.Right - 17, 0, R.Right - 18, 0 + Height -3)
      else
        Canvas.Rectangle(R.Right - Canvas.TextWidth(' 00') - 1, 0, R.Right - Canvas.TextWidth(' 00') - 2, 0 + Height); //Canvas.Rectangle(R.Right - 17, 0, R.Right - 18, 0 + Height);
    end;

    // Paint the Border
    if fBorderType = vtUnderline then
    begin
      Canvas.Pen.Width := vtPenThickness;
      Canvas.Brush.Style := bsClear;
      Canvas.Rectangle(R.Left, R.Bottom - 1, R.Right, R.Bottom);
    end
    else if fBorderType = vtsides then
    begin
      Canvas.Pen.Width := vtPenThickness;
      Canvas.Brush.Style := bsClear;
      Canvas.Rectangle(0, -5, 0 + Width, 0 + Height);
    end
    else if fBorderType = vtFull then
    begin
      Canvas.Pen.Width := vtPenThickness;
      Canvas.Brush.Style := bsClear;
      Canvas.Rectangle(R);
    end
    else if fBorderType = vtDoubleUnderLine then
    begin
      Canvas.Pen.Width := vtPenThickness;
      Canvas.Brush.Style := bsClear;
      Canvas.Rectangle(R.Left, R.Bottom - 1, R.Right, R.Bottom);
      Canvas.Rectangle(R.Left, R.Bottom - 3, R.Right, R.Bottom - 2);
    end
    else if fBorderType = vtTopBottomLine then
    begin
      Canvas.Pen.Width := vtPenThickness;
      Canvas.Brush.Style := bsClear;
      Canvas.Rectangle(R.Left, R.Bottom - 1, R.Right, R.Bottom);

      Canvas.Rectangle(R.Left, R.Top + 1, R.Right, R.Top);
    end
    else if fBorderType = vtNoBorder then
    begin
      //no action
    end;
//20171208 Igor>>
    case vtErrorState of
      esNone, esWarning: ;
      esMandatory, esError:
        begin
          Canvas.Pen.Width := 2;
          Canvas.Pen.Color := clRed;
          Canvas.Brush.Style := bsClear;
          Canvas.Rectangle(R.Left+1, R.Top+1, R.Right, R.Bottom);
        end;
    end;
    //Paint Error state
     //20160301 Igor >>>>
{    case vtErrorState of
      esNone: ;
      esMandatory:
        Begin
//          Canvas.Pen.Width := 2;
//          Canvas.Pen.Color := $008080FF;
//          Canvas.Brush.Style := bsClear;
//          Canvas.Rectangle(R.Left+1, R.Top+1, R.Right, R.Bottom);
        end;
      esError:
        Begin
          Canvas.Pen.Width := 2;
          Canvas.Pen.Color := clRed;
          Canvas.Brush.Style := bsClear;
          Canvas.Rectangle(R.Left+1, R.Top+1, R.Right, R.Bottom);
        end;
      esWarning:
        Begin
//          Canvas.Pen.Width := 2;
//          Canvas.Pen.Color := clGreen;
//          Canvas.Brush.Style := bsClear;
//          Canvas.Rectangle(R.Left+1, R.Top+1, R.Right, R.Bottom);
        end;
    end;}
//    case vtCompareState of
//      csNoCompare: ;
//      csOutdated:
//        Begin
//          Canvas.Pen.Width := 1;
//          Canvas.Pen.Color := clGray;
//          Canvas.Brush.Color := clGray;
//          Canvas.Brush.Style := bsSolid;
//          Canvas.Rectangle(R.Left+2, R.Top+2, R.Left + 6, R.Top + 6);
//        end;
//      csEqual:
//        Begin
//          Canvas.Pen.Width := 1;
//          Canvas.Pen.Color := $00B9FFB9;
//          Canvas.Brush.Color := $00B9FFB9;
//          Canvas.Brush.Style := bsSolid;
//          Canvas.Rectangle(R.Left+2, R.Top+2, R.Left + 6, R.Top + 6);
//        end;
//      csNotEqual:
//        Begin
//          Canvas.Pen.Width := 1;
//          Canvas.Pen.Color := $00BFBFFF;
//          Canvas.Brush.Color := $00BFBFFF;
//          Canvas.Brush.Style := bsSolid;
//          Canvas.Rectangle(R.Left+2, R.Top+2, R.Left + 6, R.Top + 6);
//        end;
//    end;
     //20160301 Igor <<<<<
     //20161115 Igor
//20170411 Igor >>>
//20171208 Igor<<
    case FDrawMoveArrow of
      dmaNone: ;
      dmaUp, dmaDown:
        begin
          BMP := VCL.Graphics.TBitmap.Create;
          try
            if FDrawMoveArrow = dmaUp then
              BMP.LoadFromResourceName(HInstance, STR_BTN_ARROWMOVEUP)
            else
              BMP.LoadFromResourceName(HInstance, STR_BTN_ARROWMOVEDOWN);
            MoveArrowX := ClientRect.Left + ClientRect.Width - BMP.Width - 2;
            MoveArrowY := ClientRect.Top + ((ClientRect.Height - BMP.Height) div 2);
            Canvas.Draw(MoveArrowX, MoveArrowY, BMP);
          finally
            BMP.Free;
          end;
        end;
    end;
    case FDrawMoveLine of
      dmlNone: ;
      dmlDown:
        begin
          Canvas.Pen.Color := clRed;
          Canvas.Brush.Color := clRed;
          SetLength(poligon, 6);
          poligon[0].X := ClientRect.Left + 1;
          poligon[0].Y := ClientRect.Top + ClientRect.Height - 1;
          poligon[1].X := ClientRect.Left + ClientRect.Width - 1;
          poligon[1].Y := ClientRect.Top + ClientRect.Height - 1;
          poligon[2].X := ClientRect.Left + ClientRect.Width - 1;
          poligon[2].Y := ClientRect.Top + ClientRect.Height - 5;
          poligon[3].X := ClientRect.Left + ClientRect.Width - 5;
          poligon[3].Y := ClientRect.Top + ClientRect.Height - 2;
          poligon[4].X := ClientRect.Left + 5;
          poligon[4].Y := ClientRect.Top + ClientRect.Height - 2;
          poligon[5].X := ClientRect.Left + 1;
          poligon[5].Y := ClientRect.Top + ClientRect.Height - 5;
          Canvas.Polygon(poligon);
        end;
      dmlUp:
        begin
          Canvas.Pen.Color := clRed;
          Canvas.Brush.Color := clRed;
          SetLength(poligon, 6);
          poligon[0].X := ClientRect.Left + 1;
          poligon[0].Y := ClientRect.Top + 1;
          poligon[1].X := ClientRect.Left + ClientRect.Width - 1;
          poligon[1].Y := ClientRect.Top + 1;
          poligon[2].X := ClientRect.Left + ClientRect.Width - 1;
          poligon[2].Y := ClientRect.Top + 5;
          poligon[3].X := ClientRect.Left + ClientRect.Width - 5;
          poligon[3].Y := ClientRect.Top + 2;
          poligon[4].X := ClientRect.Left + 5;
          poligon[4].Y := ClientRect.Top + 2;
          poligon[5].X := ClientRect.Left + 1;
          poligon[5].Y := ClientRect.Top + 5;
          Canvas.Polygon(poligon);
        end;
    end;
//20170411 Igor <<<
  finally
    if (Message.DC = 0) then
    EndPaint(Handle, PS);
    Canvas.Handle := 0;
    Canvas.Free; // 20151105 igor
  end;

end; //WMPaint

procedure TvtEdit.SetInputType(const Value: TinputType);
begin
  if FinputType <> Value then
  begin
    FinputType := Value;
    _RecreateWnd;
  end;
end; (*SetInputType*)

procedure TvtEdit.SetBorderColor(AColor: TColor);
begin
  if (FBorderColor = AColor) then
    EXIT;
  FBorderColor := AColor;
  Repaint;
end; {SetBorderColor}

procedure TvtEdit.SetLayout(Value: TLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    _RecreateWnd;
  end;
  Repaint;
end; //Layout

procedure TvtEdit.SetVertSeparator(Value: Boolean);
begin
  if FVertSeparator <> Value then
  begin
    FVertSeparator := Value;
    _RecreateWnd;
  end;
  Repaint;
end; {SetVertSeparator}

procedure TvtEdit.SetBorderFocusColor(AColor: TColor);
begin
  if (FBorderFocusColor = AColor) then
    EXIT;
  FBorderFocusColor := AColor;
  Repaint;
end; {SetBorderFocusColor}

procedure TvtEdit.SetName(const NewName: TComponentName);
begin
  inherited;
  if csDesigning in ComponentState then
    self.Repaint;
end;

procedure TvtEdit.SetvtOldValue(const Value: String);//20170219 Igor
begin
  FvtOldValue := Value;
end;

function TvtEdit.SameValues(AValue1, AValue2: String): Boolean; //20170612 Igor
//20170612 Igor >>>
//var
//  vl1, vl2: Real;
//  function Unformat(AVal: String): String;
//  var
//    I: Integer;
//  begin
//    Result := '';
//    for I := 1 to length(AVal) do
//    begin
//      if CharInSet(AVal[I], ['0','1','2','3','4','5','6','7','8','9','.']) then
//        Result := Result + AVal[I];
//    end;
//  end;
//20170612 Iogor
begin
  if Self.FinputType = vtDollar then
    Result := VL(Unformat(AValue1)) = VL(Unformat(AValue2))
  else
    Result := AValue1 = AValue2;
end;

procedure TvtEdit.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd; //here: Alignment is CreateParam
  end;
end; (*SetAlignment*)

procedure TvtEdit.SetPenThickness(const Value: Integer);
begin
  if FPenThickness <> Value then
  begin
    FPenThickness := Value;
    _RecreateWnd;
  end;
end;

procedure TvtEdit.SetDecimalPlaces(const Value: Integer);
begin
  if FDecimalPlaces <> Value then
  begin
    FDecimalPlaces := Value;
    _RecreateWnd;
  end;
end;

procedure TvtEdit.SetDrawMoveArrow(const Value: TDrawMoveArrow); //20170411 Igor
begin
  FDrawMoveArrow := Value;
  Repaint;
end;

procedure TvtEdit.SetDrawMoveLine(const Value: TDrawMoveLine); //20170411 Igor
begin
  FDrawMoveLine := Value;
  Repaint;
end;

procedure TvtEdit.SetBorderType(const Value: TBorderType);
begin
  if FBorderType <> Value then
  begin
    FBorderType := Value;
    _RecreateWnd;
  end;
end;

procedure TvtEdit.SetColor(Value: TColor);
begin
  inherited color := Value;
end;

procedure TvtEdit.SetCompareState(Value: TvtCompareState);
begin
  if FvtCompareState = Value then exit;
  FvtCompareState := Value;
  Repaint;
end;

procedure TvtEdit.SetDataSource(const Value: TDataSource);
begin
  if FDataSource <> Value then
  begin
    //20170612 Igor >>>
    if not vtAllowOverride AND (Value = TDataSource.vtOverride) then
      Exit;
    //20170612 Igor <<<
    FDataSource := Value;
    _RecreateWnd;
  end;
end;

procedure TvtEdit.SetPrefix(const Value: string);
begin
  if FPrefix <> Value then
  begin
    FPrefix := Value;
    _RecreateWnd;
  end;
end;

procedure TvtEdit.SetRadioGroup(const Value: string);
begin
  if FRadioGroup <> Value then
  begin
    FRadioGroup := Value;
    _RecreateWnd;
  end;
end;

procedure TvtEdit.SetvtPopData(const Value: TvtPopData);
begin
  FvtPopData.Assign(Value);
end;

procedure TvtEdit.SetvtRoundKind(const Value: TRoundKind); //20170612 Igor
begin
  if FvtRoundKind <> Value then
  begin
    FvtRoundKind := Value;
    DoRoundValue;
  end;
end;

procedure TvtEdit.SetvtSyncCleaning(const Value: TStrings);
begin
  FvtSyncCleaning.Assign(Value);
end;

procedure TvtEdit.SetvtLVars(const Value: TvtLocationVariables);
begin
  FvtLVars.Assign(Value);
end;

procedure TvtPopData.setVtPopValues(Value: TStrings);
begin
  if Assigned(Value) then
    fvtPopValues.Assign(Value);
end;

procedure TvtPopData.Assign(Source: TPersistent);
begin
  if Source is TvtPopData then
    with TvtPopData(Source) do
    begin
      Self.vtPopCaption := vtPopCaption;
      Self.vtPopFileName := vtPopFileName;
      Self.vtPopValues := vtPopValues;
      Self.vtPopFieldLength := vtPopFieldLength;
    end
  else
    inherited; //raises an exception
end;

procedure TvtLocationVariables.Assign(Source: TPersistent);
begin
  if Source is TvtLocationVariables then
    with TvtLocationVariables(Source) do
    begin
      Self.vtTableNum := vtTableNum;
      Self.vtTableColumnNum := vtTableColumnNum;
      Self.vtTableRowNum := vtTableRowNum;

      //      Self.vtEditElmNum  := vtEditElmNum;
      //      Self.vtEditFrmInst := vtEditFrmInst;
      //      Self.vtEditFrmNum  := vtEditFrmNum;
      //      Self.vtEditFrmName := vtEditFrmName;
            //This actually assigns
    end
  else
    inherited; //raises an exception
end;

procedure TvtEdit.SetvtAllowOverride(const Value: Boolean); //20170612 Iogr
begin
  FvtAllowOverride := Value;
end;

procedure TvtEdit.SetvtHighBound(const Value: integer);
begin
  FvtHighBound := Value;
end;

procedure TvtEdit.SetvtLowBound(const Value: integer);
begin
  FvtLowBound := Value;
end;

{
const
  PropsToClone: array[0..25] of string = (
    'Name','Top','Left','Height','Width', 'Font',
    'TabOrder','TabStop', 'Tag','OnClick',
    'vtPopData', 'vtAlignment', 'vtShadedDec', 'vtIsPrintable',
    'vtAllowNegative', 'vtDataSource','vtTypeAhead','vtInputType','vtPrefix',
    'vtBorderType', 'vtPenThickness', 'vtDecimalPlaces','vtLayout',
    //'vtRadioGroup', - cannot clone
    'vtVertSeparator',
    //'vtColorOnEnter', - unused
    'vtRangeLow', 'vtRangeHigh'
  );
}

function TvtEdit.Clone: TvtEdit;
begin
  Result := TvtEdit.Create(Owner);
  {these properties must be adjusted later
    Result.Tag
    Result.Name
    Result.Top := top+Height +2; //dist?
    Result.TabOrder
  }
  Result.Left := Left;
  Result.Height := Height;
  Result.Width := Width;
  Result.Font := Font;
  Result.vtBorderType := vtBorderType;
  Result.vtInputType := vtInputType;
  Result.vtDataSource := vtDataSource;
  Result.vtIsPrintable := vtIsPrintable;
  Result.vtLayout := vtLayout;
  Result.vtPenThickness := vtPenThickness;
  //Result.vtRadioGroup - cannot clone
  //Result.vtColorOnEnter - unused
  Result.vtVertSeparator := vtVertSeparator;
  Result.TabStop := TabStop;
  Result.OnClick := OnClick;
  //more?
  Result.vtRangeLow := vtRangeLow;
  Result.vtRangeHigh := vtRangeHigh;
  Result.vtPopData.Assign(vtPopData); //must clone
  Result.vtAlignment := vtAlignment;
  Result.vtShadedDec := vtShadedDec;
  Result.vtAllowNegative := vtAllowNegative;
  Result.vtTypeAhead := vtTypeAhead;
  Result.vtPrefix := vtPrefix;
  Result.vtDecimalPlaces := vtDecimalPlaces;
  Result.vTTableActions := vTTableActions; //20170407 Igor
  //20170612 Igor >>>
  Result.vtAllowOverride := vtAllowOverride;
  Result.vtRoundKind := vtRoundKind;
  Result.vtSyncCleaning := vtSyncCleaning;
  //20170612 Igor <<<
end;

//20170407 Igor >>>
{ TvtButtonEx }

procedure TvtButtonEx.CMMOUSEENTER(var Message: TMessage);
begin
  inherited;
end;

procedure TvtButtonEx.CMMOUSELEAVE(var Message: TMessage);
begin
//20170609 Igor >>>
  if not FEdit.MouseNotLeave then
    PostMessage(FEdit.Handle, UM_RELEASETABLEBUTTONS, 0, 0);
//20170609 Igor <<<
end;

constructor TvtButtonEx.CreateBtn(AOwner: TvtEdit; ATableButton: TTableAction);
begin
  inherited Create(AOwner);
  FEdit := TvtEdit(AOwner);
  FTableButton := ATableButton;
  Glyph.LoadFromResourceName(HInstance, C_Res[ATableButton]);
  ShowHint := True;
  Hint := C_Captions[ATableButton];
end;
//20170411 Igor >>>
procedure TvtButtonEx.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  //20170609 Igor >>>
  FMove := not isLastRow(FEdit) AND
    (Button = TMouseButton.mbLeft) AND
    (FTableButton = TTableAction.taMove);
  if FMove then
  begin
    FStartX := X;
    FStartY := Y;
  end;
  //20170609 Igor <<<
end;

procedure TvtButtonEx.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  C: TvtEdit;
//  OldTargetEdit: TvtEdit; //20170612 Igor
begin
  inherited;
  if not FMove or ((X = FStartX) and (Y = FStartY))  then //20170612 Igor
    exit;
  AbortClick := True;
  P := ClientToParent(Point(X, Y), Parent);
  C := FindvtEditAtPos(Parent, P);
  if C = nil then
    exit;

  if not SameTable(C, FEdit) or Not SameColumn(C, FEdit) or isLastRow(C) then
    exit;

  if Assigned(FTargetEdit) then
    FTargetEdit.DrawMoveLine := dmlNone;
  FTargetEdit := C;
  SetBounds(Left, C.Top + 1, Width, Height);

  if FTargetEdit <> FEdit then
  begin
    if FTargetEdit.FieldID > FEdit.FieldId then
    begin
      FEdit.DrawMoveArrow := dmaDown;
      FTargetEdit.DrawMoveLine := dmlDown;
    end
    else
    begin
      FEdit.DrawMoveArrow := dmaUp;
      FTargetEdit.DrawMoveLine := dmlUp;
    end;
  end
  else
  Begin
    FEdit.DrawMoveArrow := dmaNone;
  End;
end;

procedure TvtButtonEx.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if FMove then
  Begin
    FMove := False;
    FEdit.DrawMoveArrow := dmaNone;
    if Assigned(FTargetEdit) then
      FTargetEdit.DrawMoveLine := dmlNone;
    try
      if FTargetEdit <> FEdit then
      Begin
        if Assigned(ButtonClickEvent) then
          ButtonClickEvent(FTargetEdit)
      End
      else
        if Assigned(ButtonClickEvent) then
          ButtonClickEvent(Self);
    finally
      FTargetEdit := nil;
    end;
  End
  //20170609 Igor >>>
  else
    if Assigned(ButtonClickEvent) then
      ButtonClickEvent(Self);
  //20170609 Igor <<<
end;
//20170411 Igor <<<

procedure TvtButtonEx.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FEdit) then
    FEdit := nil;
end;
procedure TvtButtonEx.SetButtonClickEvent(const Value: TNotifyEvent);
begin
  FButtonClickEvent := Value;
end;

//20170407 Igor <<<

end.

