unit FP_2027EditRich;

interface

uses SysUtils,Windows,Messages,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ComCtrls,ExtCtrls,Menus,ActnList,ToolWin,ImgList,ClipBrd,AppEvnts,Buttons,
  ShellApi, Vcl.ExtDlgs, System.Actions, vtRichmemobox, {QuickRpt,qrextra} //20150818 igor  //wwriched,
  vtChild,

  rxRichEd; //20160819 Igor (Must be last)

type
  TEditRichFP_2027 = class(TForm)
    FontDialog: TFontDialog;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Font1: TMenuItem;
    Bold1: TMenuItem;
    Italic1: TMenuItem;
    Paragraph1: TMenuItem;
    LeftAligned1: TMenuItem;
    Centered1: TMenuItem;
    RightAligned1: TMenuItem;
    SaveDialog: TSaveDialog;
    More1: TMenuItem;
    ColorDialog: TColorDialog;
    ActionList: TActionList;
    acCentered: TAction;
    acUndo: TAction;
    acCut: TAction;
    acPaste: TAction;
    acCopy: TAction;
    acBold: TAction;
    acItalic: TAction;
    acRightAligned: TAction;
    acLeftAligned: TAction;
    acSave: TAction;
    Undo1: TMenuItem;
    acFont: TAction;
    acCountChars: TAction;
    Images: TImageList;
    SizeMenu: TPopupMenu;
    Small1: TMenuItem;
    Medium1: TMenuItem;
    Large1: TMenuItem;
    HintColor1: TMenuItem;
    ControlBar: TControlBar;
    ToolBarFile: TToolBar;
    ToolButton20: TToolButton;
    ToolButton4: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton12: TToolButton;
    ToolButton17: TToolButton;
    ToolBarEdit: TToolBar;
    ToolBarFont: TToolBar;
    ComboFont: TComboBox;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    BarMenu: TPopupMenu;
    ToolBarMenu: TToolBar;
    Timer: TTimer;
    acExit: TAction;
    ApplicationEvents1: TApplicationEvents;
    Panel2: TPanel;
    Savespecificallyforthisclient1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenDialog1: TOpenDialog;
    ExitBtn: TBitBtn;
    SaveBtn: TBitBtn;
    InsertFileBtn: TBitBtn;
    PrintBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    RichEdit1: TvtRichMemo;
    procedure InsertFileBtnClick(Sender: TObject);
    Function  InDesign:Boolean;
    procedure BoldExecute(Sender: TObject);
    procedure ItalicExecute(Sender: TObject);
    procedure ChangeAlignment(Sender: TObject);
    procedure ExitExecute(Sender: TObject);
    procedure BackColorExecute(Sender: TObject);
    procedure FontExecute(Sender: TObject);
    procedure CountCharsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NewExecute(Sender: TObject);
    procedure SaveExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PrintExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure acBoldUpdate(Sender: TObject);
    procedure acItalicUpdate(Sender: TObject);
    procedure RichEdit1Change(Sender: TObject);
    procedure acCountcharsUpdate(Sender: TObject);
    procedure acCutExecute(Sender: TObject);
    procedure acCutUpdate(Sender: TObject);
    procedure acCopyExecute(Sender: TObject);
    procedure acPasteExecute(Sender: TObject);
    procedure acPasteUpdate(Sender: TObject);
    procedure acUndoExecute(Sender: TObject);
    procedure acUndoUpdate(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ToolButton17Click(Sender: TObject);
    procedure SetFontSize(Sender: TObject);
    procedure ComboFontClick(Sender: TObject);
    procedure RichEdit1SelectionChange(Sender: TObject);
    procedure acHintColorExecute(Sender: TObject);
    procedure BarMenuPopup(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ControlBarLowerDockOver(Sender: TObject;Source: TDragDockObject;
      X, Y: Integer; State: TDragState;var Accept: Boolean);
    procedure ShowHint(Sender: TObject);

    {Client letter}
    procedure InsertFileIntoRtf(ARichEdit:TRichEdit;InPos:Integer;FileName:String);
    procedure ExitBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Savespecificallyforthisclient1Click(Sender: TObject);
    procedure ComboFontChange(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
  private
    FileName: string;
    Modified: Boolean;
    FRetNo: Integer;
  public
    function SaveChanges: Boolean;
    function Save(FileName:String): Boolean;
    function SaveAs: Boolean;
    procedure BarMenuClick (Sender: TObject);
    procedure CheckCapslock;
    property RetNo:Integer read FRetNo;
  end;

procedure EditRich(RNo: integer; LtrName: string);

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,FP_2027Declare,FP_2027PopList,FileCtrl,
  FP_2027RtfForm,FP_2027QRLetter,FP_2027SelectFile,FP_2027PreviewRich,
  FP_2027ChildWinNew,FP_2027Main,vtTrimStr,vtShared;

var
  //EditRich: TEditRichFP_2012;
  //20150818 igor Report : TQuickRep;
  DefaultExtension : String; //[3];
  TemplateDir : String;
  MousePosOnMemo :integer;
  LtrErrorSw : boolean;
  cursor_position:integer;
  KeyWLength : Byte;
  ReplaceString:string;
  ValidateLetterflag:boolean;
  DesignMode : Boolean;

const
  sbpMessage = 0;
  sbpCaps = 1;
  sbpPosition = 2;

procedure EditRich(RNo: integer; LtrName: string);
begin
  with TEditRichFP_2027.Create(Application) do
  begin
    FRetNo := RNo;
  //prepare letter
    If (RNo > 0) and FileExists(LtrName) then
      GetInterpretedRichEdit(RetNo,LetterName, RichEdit1);
    //If RetNo>0 then RichEdit1.Lines.LoadFromFile('TempFinishedLtr.Rtf');
    ShowModal;
  end;
end;

// Font operations
procedure TEditRichFP_2027.BoldExecute(Sender: TObject);
begin
  If Not InDesign then exit;
  with RichEdit1.SelAttributes do
    if fsBold in Style then
      Style := Style - [fsBold]
    else
      Style := Style + [fsBold];
end;


procedure TEditRichFP_2027.ItalicExecute(Sender: TObject);
begin
  If Not InDesign then exit;
  with RichEdit1.SelAttributes do
    if fsItalic in Style then
      Style := Style - [fsItalic]
    else
      Style := Style + [fsItalic];
end;

procedure TEditRichFP_2027.FontExecute(Sender: TObject);
begin
  FontDialog.Font.Assign (RichEdit1.SelAttributes);
  if FontDialog.Execute then
  begin
    RichEdit1.SelAttributes.Assign (FontDialog.Font);
    RichEdit1SelectionChange (Self);
  end;
end;

procedure TEditRichFP_2027.ChangeAlignment(Sender: TObject);
begin
   If Not InDesign then exit;
  // change paragraph alignment using the TAlignment
  // value saved in the tag of the action
  RichEdit1.Paragraph.Alignment := TParaAlignment ( //20160819 Igor
    (Sender as TAction).Tag);
end;

Function TEditRichFP_2027.InDesign:Boolean;
begin
 Result :=True;
 If DesignMode = false then
 begin
  ShowMessage('Please select Design mode first');
  result := False;
 end;
end;

procedure TEditRichFP_2027.NewExecute(Sender: TObject);
begin
  if (not Modified) or (SaveChanges) then
  begin
    RichEdit1.Text := '';
    Modified := False;
    FileName := '';
   // GroupBox1.Caption := '[Untitled]';
  end;
end;

procedure TEditRichFP_2027.ExitExecute(Sender: TObject);
begin
  If DesignMode = False then
  begin
   RichEdit1.Clear;
   If FileExists(TemplateDir+'\'+'tempWip') then
   begin
   RichEdit1.Lines.LoadFromFile(TemplateDir+'\'+'tempWip');
   DesignMode :=True;
   Invalidate;
   end;
  end;
  Close;
end;

function TEditRichFP_2027.SaveChanges: Boolean;
begin
  case MessageDlg (
    'The document ' + filename + ' has changed.' +
    #13#13 + 'Do you want to save the changes?',
    mtConfirmation, mbYesNoCancel, 0) of
  idYes:
    // call Save and return its result
    Result := SaveAs;
  idNo:
    // do not save and continue
    Result := True;
  else // idCancel:
    // do not save and abort operation
    Result := False;
  end;
end;

// return False means the SaveAs has been aborted
function TEditRichFP_2027.Save(FileName:String): Boolean;
begin
    RichEdit1.Lines.SaveToFile(FileName);
    Modified := False;
    Result := True;
end;

// return False if SaveAs dialog box is cancelled
function TEditRichFP_2027.SaveAs: Boolean;
begin
  if SaveDialog.Execute then
  begin
    Filename := SaveDialog.FileName;
    Save(FileName);
    Result := True;
    Modified := False;
  end
  else
    Result := False;
end;

procedure TEditRichFP_2027.SaveExecute(Sender: TObject);
begin
  if Modified then Save(FileName);
end;

procedure TEditRichFP_2027.PrintExecute(Sender: TObject);
begin
 RichEdit1.Print (FileName);
end;

procedure TEditRichFP_2027.RichEdit1Change(Sender: TObject);
begin
  // enables save operations
  Modified := True;
end;


procedure TEditRichFP_2027.BackColorExecute(Sender: TObject);
begin
  ColorDialog.Color := RichEdit1.Color;
  if ColorDialog.Execute then
    RichEdit1.Color := ColorDialog.Color;
end;

procedure TEditRichFP_2027.CountCharsExecute(Sender: TObject);
begin
  MessageDlg (Format (
    'The text has %d characters', [RichEdit1.GetTextLen]),
    mtInformation, [mbOK], 0);
end;

procedure TEditRichFP_2027.FormCreate(Sender: TObject);
var
  I,j, ToolSize: Integer;
  mItem: TMenuItem;
  tb: TToolButton;
begin
  Modified := False;
  ComboFont.Items := Screen.Fonts;
  ComboFont.ItemIndex := ComboFont.Items.IndexOf(RichEdit1.Font.Name);
  DesignMode := True;
  // populate the control bar menu
  for I := 0 to ControlBar.ControlCount - 1 do
  begin
    mItem := TMenuItem.Create (Self);
    mItem.Caption := ControlBar.Controls [I].Name;
    mItem.Tag := Integer (ControlBar.Controls [I]);
    mItem.OnClick := BarMenuClick;
    BarMenu.Items.Add (mItem);
  end;

  // create the buttons of the menu toolbar
  ToolSize := 0;
  for I := MainMenu.Items.Count - 1 downto 0 do
  begin
    tb := TToolButton.Create (ToolBarMenu);
    tb.Parent := ToolBarMenu;
    tb.AutoSize := True;
    tb.Grouped := True;
    tb.Caption := MainMenu.Items[I].Caption;
    tb.MenuItem := MainMenu.Items[I];
    Inc (ToolSize, tb.Width);
  end;
  // size the menu toolbar
  ToolBarMenu.Width := ToolSize;
  // hide the standard menu, using the form's Menu property
  Menu := nil;
  Screen.Cursor := crDefault;
end;

procedure TEditRichFP_2027.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  // short-circuit evaluation: if not modified
  // doesn't even try to save. Doesn't close if
  // save request is cancelled
  CanClose := (not Modified) or (SaveChanges);
end;

// update events for actions

procedure TEditRichFP_2027.acSaveUpdate(Sender: TObject);
begin
  acSave.Enabled := Modified;
end;

procedure TEditRichFP_2027.acBoldUpdate(Sender: TObject);
begin
  acBold.Checked := fsBold in RichEdit1.SelAttributes.Style;
end;

procedure TEditRichFP_2027.acItalicUpdate(Sender: TObject);
begin
  acItalic.Checked := fsItalic in RichEdit1.SelAttributes.Style;
end;

procedure TEditRichFP_2027.acCountcharsUpdate(Sender: TObject);
begin
  acCountChars.Enabled := RichEdit1.GetTextLen > 0;
end;

procedure TEditRichFP_2027.acCutExecute(Sender: TObject);
begin
  If Not InDesign then exit;
  RichEdit1.CutToClipboard;
end;

procedure TEditRichFP_2027.acCutUpdate(Sender: TObject);
begin
  acCut.Enabled := RichEdit1.SelLength > 0;
  acCopy.Enabled := acCut.Enabled;
end;

procedure TEditRichFP_2027.acCopyExecute(Sender: TObject);
begin
  RichEdit1.CopyToClipboard;
end;

procedure TEditRichFP_2027.acPasteExecute(Sender: TObject);
begin
  RichEdit1.PasteFromClipboard;
end;

procedure TEditRichFP_2027.acPasteUpdate(Sender: TObject);
begin
//  acPaste.Enabled := SendMessage(RichEdit1.Handle, em_CanPaste, 0, 0) <> 0;
end;

procedure TEditRichFP_2027.acUndoExecute(Sender: TObject);
begin
  RichEdit1.Undo;
end;

procedure TEditRichFP_2027.acUndoUpdate(Sender: TObject);
begin
  acUndo.Enabled := RichEdit1.CanUndo;
end;

procedure TEditRichFP_2027.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  // check the proper paragraph alignment
  case RichEdit1.Paragraph.Alignment of
    paLeftJustify: acLeftAligned.Checked := True; //20160819 Igor
    paRightJustify: acRightAligned.Checked := True; //20160819 Igor
    paCenter: acCentered.Checked := True; //20160819 Igor
  end;
  // checks the caps lock status
  CheckCapslock;
end;

procedure TEditRichFP_2027.ToolButton17Click(Sender: TObject);
begin
  If Not InDesign then exit;
  RichEdit1.SelAttributes.Size := RichEdit1.SelAttributes.Size + 2;
end;

procedure TEditRichFP_2027.SetFontSize(Sender: TObject);
begin
  RichEdit1.SelAttributes.Size := (Sender as TMenuItem).Tag;
end;

procedure TEditRichFP_2027.ComboFontClick(Sender: TObject);
begin
  RichEdit1.SelAttributes.Name := ComboFont.Text;
end;

procedure TEditRichFP_2027.RichEdit1SelectionChange(Sender: TObject);
begin
  // select the current font name in the font combo box
  ComboFont.ItemIndex := ComboFont.Items.IndexOf (RichEdit1.SelAttributes.Name);
end;

procedure TEditRichFP_2027.acHintColorExecute(Sender: TObject);
begin
  ColorDialog.Color := Application.HintColor;
  if ColorDialog.Execute then Application.HintColor := ColorDialog.Color;
end;

procedure TEditRichFP_2027.BarMenuClick(Sender: TObject);
var
  aCtrl: TControl;
begin
  aCtrl := TControl ((Sender as TComponent).Tag);
  aCtrl.Visible := not aCtrl.Visible;
end;

procedure TEditRichFP_2027.BarMenuPopup(Sender: TObject);
var
  I: Integer;
begin
  // update the menu checkmarks
  for I := 0 to BarMenu.Items.Count - 1 do
    BarMenu.Items [I].Checked :=TControl (BarMenu.Items [I].Tag).Visible;
end;

procedure TEditRichFP_2027.ShowHint(Sender: TObject);
begin
  // show hint in the status bar message panel
 { StatusBar.Panels[sbpMessage].Text := Application.Hint;}
end;

procedure TEditRichFP_2027.CheckCapslock;
begin
 (*
  // show status in caps panel
  if Odd (GetKeyState (VK_CAPITAL)) then
    StatusBar.Panels[sbpCaps].Text := 'CAPS'
  else
    StatusBar.Panels[sbpCaps].Text := '';
 *)
end;

procedure TEditRichFP_2027.TimerTimer(Sender: TObject);
begin
  CheckCapslock;
end;

procedure TEditRichFP_2027.ControlBarLowerDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := Source.Control is TToolbar;
end;

procedure TEditRichFP_2027.ExitBtnClick(Sender: TObject);
begin
 ExitExecute(Sender);
end;

procedure TEditRichFP_2027.FormPaint(Sender: TObject);
begin
If DesignMode then
  RichEdit1.ReadOnly := False
else       {preview mode}
  RichEdit1.ReadOnly := True;
end;


procedure TEditRichFP_2027.Savespecificallyforthisclient1Click(Sender: TObject);
Var s:String;
begin
 SaveDialog.FileName := GetClientLettersDir+'\'+MkClientLetterName(RetNo);
 SaveDialog.DefaultExt := '*RTF';
 SaveAs;
end;

procedure TEditRichFP_2027.ComboFontChange(Sender: TObject);
begin
  If Not InDesign then exit;
end;



procedure TEditRichFP_2027.SaveBtnClick(Sender: TObject);
begin
 Savespecificallyforthisclient1Click(Sender);
end;

procedure TEditRichFP_2027.InsertFileBtnClick(Sender: TObject);
Var FileName:String;InPos:Integer;h:THandle;
Begin
 If Not InDesign then exit;
 Application.CreateForm(TRTFFormFP_2027,RtfForm);
 RtfForm.ShowModal;
 RtfForm.Free;
end;

procedure TEditRichFP_2027.InsertFileIntoRtf(ARichEdit:TRichEdit;InPos:Integer;FileName:String);
Var TempRtf:TRichEdit;
begin
 ARichEdit.Lines.Clear;
 ARichEdit.Lines.LoadFromFile(FileName);
 Modified:=True;
end;


end.
