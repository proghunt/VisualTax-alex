unit FP_2027GENERALACTIONPLAN;

interface

uses SysUtils,Windows,Messages,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,Menus,ComCtrls,ClipBrd,ToolWin,ActnList,ImgList,ShellApi,
  DBCtrls,Db,RichEdit,Grids,DBGrids, System.Actions;//20150819 Igor QuickRpt,qrextra;

Const
  RulerAdj = 4/3;
  GutterWid = 6;

type
  TGeneralActionPlan = class(TForm)
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    Label1: TLabel;
    DeleteBtn: TBitBtn;
    GroupBox1: TGroupBox;
    DbRichEdit1: TDBRichEdit;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FilePrintItem: TMenuItem;
    N4: TMenuItem;
    FileExitItem: TMenuItem;
    EditMenu: TMenuItem;
    EditUndoItem: TMenuItem;
    N2: TMenuItem;
    EditCutItem: TMenuItem;
    EditCopyItem: TMenuItem;
    EditPasteItem: TMenuItem;
    N5: TMenuItem;
    miEditFont: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    FontDialog1: TFontDialog;
    ToolbarImages: TImageList;
    ActionList1: TActionList;
    FileNewCmd: TAction;
    FileOpenCmd: TAction;
    FileSaveCmd: TAction;
    FilePrintCmd: TAction;
    FileExitCmd: TAction;
    FileSaveAsCmd: TAction;
    ActionList2: TActionList;
    EditUndoCmd: TAction;
    EditCutCmd: TAction;
    EditCopyCmd: TAction;
    EditPasteCmd: TAction;
    EditFontCmd: TAction;
    StandardToolBar: TToolBar;
    ToolButton1: TToolButton;
    OpenButton: TToolButton;
    SaveButton: TToolButton;
    PrintButton: TToolButton;
    ToolButton5: TToolButton;
    CutButton: TToolButton;
    CopyButton: TToolButton;
    PasteButton: TToolButton;
    UndoButton: TToolButton;
    ToolButton10: TToolButton;
    FontName: TComboBox;
    ToolButton11: TToolButton;
    FontSize: TEdit;
    UpDown1: TUpDown;
    ToolButton2: TToolButton;
    BoldButton: TToolButton;
    ItalicButton: TToolButton;
    UnderlineButton: TToolButton;
    ToolButton16: TToolButton;
    LeftAlign: TToolButton;
    CenterAlign: TToolButton;
    RightAlign: TToolButton;
    ToolButton20: TToolButton;
    BulletsButton: TToolButton;
    Ruler: TPanel;
    FirstInd: TLabel;
    LeftInd: TLabel;
    RulerLine: TBevel;
    RightInd: TLabel;
    Bevel1: TBevel;
    Editor: TRichEdit;
    SaveBtn: TBitBtn;
    Panel3: TPanel;
    PrintBtn: TBitBtn;

    (*
    {------}
    procedure GetFontNames;
    procedure SetupRuler;
    procedure SetEditRect;
    procedure SetModified(Value: Boolean);
    function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
      FontType: Integer; Data: Pointer): Integer; stdcall;
    {-----}

    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenQuery;
    procedure DeleteBtnClick(Sender: TObject);
    procedure DbRichEdit1KeyPress(Sender: TObject; var Key: Char);
    //procedure DBRichEdit2KeyPress(Sender: TObject; var Key: Char);
    //procedure Query1NewRecord(DataSet: TDataSet);

    {Rich edit functions}
    procedure RulerItemMouseDown(Sender: TObject; Button: TMouseButton;
     Shift: TShiftState; X, Y: Integer);
    procedure RulerItemMouseMove(Sender: TObject; Shift: TShiftState;
     X, Y: Integer);
    procedure FirstIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LeftIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RightIndMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FontSizeChange(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure SelectFont(Sender: TObject);
    procedure RulerResize(Sender: TObject);
    procedure FontNameChange(Sender: TObject);
    procedure miEditFontClick(Sender: TObject);
    function CurrText: TTextAttributes;
    procedure EditUndoItemClick(Sender: TObject);
    procedure EditCutItemClick(Sender: TObject);
    procedure EditCopyItemClick(Sender: TObject);
    procedure EditPasteItemClick(Sender: TObject);
    procedure SelectionChange(Sender: TObject);
    procedure UpdateCursorPos;
    procedure BoldButtonClick(Sender: TObject);
    procedure UnderlineButtonClick(Sender: TObject);
    procedure LeftAlignClick(Sender: TObject);
    procedure CenterAlignClick(Sender: TObject);
    procedure RightAlignClick(Sender: TObject);
    procedure BulletsButtonClick(Sender: TObject);
    procedure CutButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure PasteButtonClick(Sender: TObject);
    procedure UndoButtonClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
 *)
  private
    { Private declarations }
    {
    FUpdating: Boolean;
    FDragOfs: Integer;
    FDragging: Boolean;
    procedure GetFontNames;
    procedure SetupRuler;
    procedure SetEditRect;
    procedure SetModified(Value: Boolean);
    function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
      FontType: Integer; Data: Pointer): Integer; stdcall;
    }
  public
    { Public declarations }
  end;

var
  GeneralActionPlan: TGeneralActionPlan;

  FUpdating: Boolean;
  FDragOfs: Integer;
  FDragging: Boolean;

 //20150819 Igor Report : TQuickRep;

implementation

{$R *.DFM}

(*
uses FP_2027Declare,FP_2027TrimStr,FP_2012RepGeneralActionPlan;

procedure TGeneralActionPlan.FormCreate(Sender: TObject);
Var i:Integer;
begin
 OpenQuery;
 Editor.Clear;
 For i:=0 to DbRichEdit1.Lines.Count -1 do
  Editor.Lines.Add(DbRichEdit1.Lines[i]);
  {
  FontName.Text := 'Arial';
  UpDown1.Position :=9;
  }
  GetFontNames;
  SetupRuler;
  SelectionChange(Self);

  CurrText.Name := DefFontData.Name;
  CurrText.Size := -MulDiv(DefFontData.Height, 72, Screen.PixelsPerInch);
end;


procedure TGeneralActionPlan.OpenQuery;
Var WhereClause:String;
begin
end;

procedure TGeneralActionPlan.CancelBtnClick(Sender: TObject);
begin
{Query1.Edit;
Query1.Post;}
Close;
end;

procedure TGeneralActionPlan.DeleteBtnClick(Sender: TObject);
begin
 if MessageDlg('Delete? ',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
 Query1.Edit;
 Query1.Delete;
end;


procedure TGeneralActionPlan.DbRichEdit1KeyPress(Sender: TObject;
  var Key: Char);
begin
end;


procedure TGeneralActionPlan.miEditFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(Editor.SelAttributes);
  if FontDialog1.Execute then
    CurrText.Assign(FontDialog1.Font);
  SelectionChange(Self);
  Editor.SetFocus;
end;

function TGeneralActionPlan.CurrText: TTextAttributes;
begin
  if Editor.SelLength > 0 then Result := Editor.SelAttributes
  else Result := Editor.DefAttributes;
end;



procedure TGeneralActionPlan.EditUndoItemClick(Sender: TObject);
begin
 with Editor do
    if HandleAllocated then SendMessage(Handle, EM_UNDO, 0, 0);
end;

procedure TGeneralActionPlan.EditCutItemClick(Sender: TObject);
begin
 Editor.CutToClipboard;
end;

procedure TGeneralActionPlan.EditCopyItemClick(Sender: TObject);
begin
Editor.CopyToClipboard;
end;

procedure TGeneralActionPlan.EditPasteItemClick(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TGeneralActionPlan.SelectionChange(Sender: TObject);
begin
  with Editor.Paragraph do
  try
    FUpdating := True;
    FirstInd.Left := Trunc(FirstIndent*RulerAdj)-4+GutterWid;
    LeftInd.Left := Trunc((LeftIndent+FirstIndent)*RulerAdj)-4+GutterWid;
    RightInd.Left := Ruler.ClientWidth-6-Trunc((RightIndent+GutterWid)*RulerAdj);
    BoldButton.Down := fsBold in Editor.SelAttributes.Style;
    ItalicButton.Down := fsItalic in Editor.SelAttributes.Style;
    UnderlineButton.Down := fsUnderline in Editor.SelAttributes.Style;
    BulletsButton.Down := Boolean(Numbering);
    FontSize.Text := IntToStr(Editor.SelAttributes.Size);
    FontName.Text := Editor.SelAttributes.Name;
    case Ord(Alignment) of
      0: LeftAlign.Down := True;
      1: RightAlign.Down := True;
      2: CenterAlign.Down := True;
    end;
    UpdateCursorPos;
  finally
    FUpdating := False;
  end;
end;

procedure TGeneralActionPlan.UpdateCursorPos;
var
  CharPos: TPoint;
begin

  CharPos.Y := SendMessage(Editor.Handle, EM_EXLINEFROMCHAR, 0,
    Editor.SelStart);
  CharPos.X := (Editor.SelStart -
    SendMessage(Editor.Handle, EM_LINEINDEX, CharPos.Y, 0));

  Inc(CharPos.Y);
  Inc(CharPos.X);
  {StatusBar.Panels[0].Text := Format(sColRowInfo, [CharPos.Y, CharPos.X]);}
end;


{ Ruler Indent Dragging }

procedure TGeneralActionPlan.RulerItemMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragOfs := (TLabel(Sender).Width div 2);
  TLabel(Sender).Left := TLabel(Sender).Left+X-FDragOfs;
  FDragging := True;
end;

procedure TGeneralActionPlan.RulerItemMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDragging then
    TLabel(Sender).Left :=  TLabel(Sender).Left+X-FDragOfs
end;

procedure TGeneralActionPlan.FirstIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  Editor.Paragraph.FirstIndent := Trunc((FirstInd.Left+FDragOfs-GutterWid) / RulerAdj);
  LeftIndMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TGeneralActionPlan.LeftIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  Editor.Paragraph.LeftIndent := Trunc((LeftInd.Left+FDragOfs-GutterWid) / RulerAdj)-Editor.Paragraph.FirstIndent;
  SelectionChange(Sender);
end;

procedure TGeneralActionPlan.RightIndMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
  Editor.Paragraph.RightIndent := Trunc((Ruler.ClientWidth-RightInd.Left+FDragOfs-2) / RulerAdj)-2*GutterWid;
  SelectionChange(Sender);
end;

procedure TGeneralActionPlan.FontSizeChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Size := StrToInt(FontSize.Text);
end;

procedure TGeneralActionPlan.ItalicButtonClick(Sender: TObject);
begin
  if FUpdating then Exit;
  if ItalicButton.Down then
    CurrText.Style := CurrText.Style + [fsItalic]
  else
    CurrText.Style := CurrText.Style - [fsItalic];
end;

procedure TGeneralActionPlan.SelectFont(Sender: TObject);
begin
  FontDialog1.Font.Assign(Editor.SelAttributes);
  if FontDialog1.Execute then
    CurrText.Assign(FontDialog1.Font);
  SelectionChange(Self);
  Editor.SetFocus;
end;

procedure TGeneralActionPlan.RulerResize(Sender: TObject);
begin
  RulerLine.Width := Ruler.ClientWidth - (RulerLine.Left*2);
end;

procedure TGeneralActionPlan.FontNameChange(Sender: TObject);
begin
  if FUpdating then Exit;
  CurrText.Name := FontName.Items[FontName.ItemIndex];
end;

procedure TGeneralActionPlan.GetFontNames;
var  DC: HDC;
 i:Integer;
begin

 For i:= 1 to Screen.Fonts.Count do
  FontName.Items.Add(Screen.Fonts.Strings[i-1]);
  FontName.Text := 'Arial';
 {
  DC := GetDC(0);
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(FontName.Items));
  ReleaseDC(0, DC);
  FontName.Sorted := True;
 }
end;

procedure TGeneralActionPlan.SetupRuler;
var
  I: Integer;
  S: String;
begin
  SetLength(S, 201);
  I := 1;
  while I < 200 do
  begin
    S[I] := #9;
    S[I+1] := '|';
    Inc(I, 2);
  end;
  Ruler.Caption := S;
end;

procedure TGeneralActionPlan.SetEditRect;
var
  R: TRect;
begin
  with Editor do
  begin
    R := Rect(GutterWid, 0, ClientWidth-GutterWid, ClientHeight);
    SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
  end;
end;

procedure TGeneralActionPlan.SetModified(Value: Boolean);
begin
 {
  if Value then StatusBar.Panels[1].Text := sModified
  else StatusBar.Panels[1].Text := '';
 }
end;

function TGeneralActionPlan.EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;


procedure TGeneralActionPlan.BoldButtonClick(Sender: TObject);
begin
 if FUpdating then Exit;
  if BoldButton.Down then
    CurrText.Style := CurrText.Style + [fsBold]
  else
    CurrText.Style := CurrText.Style - [fsBold];
end;

procedure TGeneralActionPlan.UnderlineButtonClick(Sender: TObject);
begin
 if FUpdating then Exit;
  if UnderlineButton.Down then
    CurrText.Style := CurrText.Style + [fsUnderline]
  else
    CurrText.Style := CurrText.Style - [fsUnderline];
end;

procedure TGeneralActionPlan.LeftAlignClick(Sender: TObject);
begin
 if FUpdating then Exit;
 Editor.Paragraph.Alignment := TAlignment(TControl(Sender).Tag);
end;

procedure TGeneralActionPlan.CenterAlignClick(Sender: TObject);
begin
 if FUpdating then Exit;
  Editor.Paragraph.Alignment := TAlignment(TControl(Sender).Tag);
end;

procedure TGeneralActionPlan.RightAlignClick(Sender: TObject);
begin
if FUpdating then Exit;
  Editor.Paragraph.Alignment := TAlignment(TControl(Sender).Tag);
end;

procedure TGeneralActionPlan.BulletsButtonClick(Sender: TObject);
begin
if FUpdating then Exit;
  Editor.Paragraph.Numbering := TNumberingStyle(BulletsButton.Down);
end;

procedure TGeneralActionPlan.CutButtonClick(Sender: TObject);
begin
 Editor.CutToClipboard;
end;

procedure TGeneralActionPlan.CopyButtonClick(Sender: TObject);
begin
 Editor.CopyToClipboard;
end;

procedure TGeneralActionPlan.PasteButtonClick(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TGeneralActionPlan.UndoButtonClick(Sender: TObject);
begin
  with Editor do
    if HandleAllocated then SendMessage(Handle, EM_UNDO, 0, 0);
end;

procedure TGeneralActionPlan.SaveBtnClick(Sender: TObject);
Var i:Integer;
begin
  Query1.Edit;
  {
  DbRichEdit1.Clear;
  For i:=0 to Editor.Lines.Count -1 do
    DbRichEdit1.Lines.Add(Editor.Lines[i]);
  }
  Try
  Query1.Post;
  except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;

end;

procedure TGeneralActionPlan.PrintBtnClick(Sender: TObject);
begin

Application.CreateForm(TRepGeneralActionPlan,RepGeneralActionPlan);
    Report := RepGeneralActionPlan.QuickRep1;
    Report.Preview;
    RepGeneralActionPlan.Free;
end;

procedure TGeneralActionPlan.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;
*)
end.
