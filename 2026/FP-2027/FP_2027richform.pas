unit FP_2027richform;

interface

uses SysUtils,Windows,Messages,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ComCtrls,ExtCtrls,Menus,ActnList,ToolWin,ImgList,ClipBrd,AppEvnts,Buttons,
  ShellApi,FileCtrl,{ QuickRpt,qrextra,} //20150817 igor //wwriched,
  ExtDlgs,vtChild, vtRichmemobox, System.Actions,

  rxRichEd; //20160819 Igor (Must be last)

type
  TRichFormFP_2012 = class(TForm)
    FontDialog: TFontDialog;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Saveas1: TMenuItem;
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
    Panel3: TPanel;
    TemplateTypeBox: TRadioGroup;
    FileListBox1: TFileListBox;
    InsertKeyWBtn: TBitBtn;
    ExitBtn: TBitBtn;
    Memo1: TMemo;
    Savespecificallyforthisclient1: TMenuItem;
    Deletethistemplate1: TMenuItem;
    ModeBox: TRadioGroup;
    Save1: TMenuItem;
    PreviewBtn: TBitBtn;
    LogoBtn: TBitBtn;
    HelpBtn: TBitBtn;
    DataDictBtn: TBitBtn;
    ConvertLetter: TBitBtn;
    SlashToLeftBracketBtn: TBitBtn;
    SlashToRightBracketBtn: TBitBtn;
    InsertGraphicBtn: TBitBtn;
    SaveBtn: TBitBtn;
    OpenPictureDialog1: TOpenPictureDialog;
    InsertFileBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    PrintBtn: TBitBtn;
    Label1: TLabel;
    RichEdit1: TvtRichMemo;
    procedure InsertFileBtnClick(Sender: TObject);
    Procedure GoToKeyWInError(ARichEdit:TRichEdit;KeyW:String);
    procedure HighLightKeyWords(ARichEdit:TRichEdit);
    procedure UnHighLightKeyWords(ARichEdit:TRichEdit);
    Procedure UnHighLightAKeyWord(ARichEdit:TRichEdit;KeyW:String);
    Procedure HighLightAKeyWord(ARichEdit:TRichEdit;KeyW:String);
    Function  InDesign:Boolean;
    procedure BoldExecute(Sender: TObject);
    procedure ItalicExecute(Sender: TObject);
    procedure ChangeAlignment(Sender: TObject);
    procedure AboutExecute(Sender: TObject);
    procedure ExitExecute(Sender: TObject);
    procedure SaveAsExecute(Sender: TObject);
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
    procedure ControlBarLowerDockDrop(Sender: TObject; Source: TDragDockObject;
      X, Y: Integer);
    procedure ControlBarLowerUnDock(Sender: TObject; Client: TControl;
      NewTarget: TWinControl; var Allow: Boolean);
    procedure ControlBarLowerDockOver(Sender: TObject;
      Source: TDragDockObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure ShowHint(Sender: TObject);

    {Client letter}
    procedure InsertFileIntoRtf(ARichEdit:TRichEdit;InPos:Integer;FileName:String);
    Function ValidateLetter(ARichEdit:TRichEdit):String;
    procedure Preview(ARichEdit:TRichEdit);
    procedure ExitBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure InsertKeyWBtnClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure TemplateTypeBoxClick(Sender: TObject);
    procedure LetterHeadBoxClick(Sender: TObject);
    procedure Savespecificallyforthisclient1Click(Sender: TObject);
    procedure Deletethistemplate1Click(Sender: TObject);
    procedure ModeBoxClick(Sender: TObject);
    Procedure LoadTemplateList;
    Procedure LoadTemplate(FlName:String);
    procedure ComboFontChange(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure PreviewBtnClick(Sender: TObject);
    procedure LogoBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure DataDictBtnClick(Sender: TObject);
    procedure ConvertLetterClick(Sender: TObject);
    procedure SlashToLeftBracketBtnClick(Sender: TObject);
    procedure SlashToRightBracketBtnClick(Sender: TObject);
    procedure InsertGraphicBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
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
    {procedure ReplaceString(SearchStr,NewStr:String);}
    property RetNo:Integer read FRetNo;
  end;

var
 // RetNo:Integer;
  RichForm: TRichFormFP_2012;
  // Report : TQuickRep; //20150817 igor
  DefaultExtension : string; //[3];
  TemplateDir : String;
  {For client Letter}
  {FileName : string; //[40];}
  MousePosOnMemo :integer;
  //KeyWLpos, KeyWRpos : TStringList; {to be freed on cancel}
  LtrErrorSw : boolean;
  cursor_position:integer;
  KeyWLength : Byte;
  ReplaceString:string;
  ValidateLetterflag:boolean;
  DesignMode : Boolean;
  TempLtrName : String;

implementation

{$R *.DFM}

uses vtCommon,vtDialogs,FP_2027RtfForm,FP_2027QRLetter,FP_2027SelectFile,
  FP_2027PreviewRich,FP_2027TrimStr,FP_2027Declare,FP_2027PopList,
  FP_2027ChildWinNew,FP_2027Main,vtTrimStr,vtShared,
  Printers; //20160905 Igor

const
  sbpMessage = 0;
  sbpCaps = 1;
  sbpPosition = 2;


procedure TRichFormFP_2012.HighLightKeyWords(ARichEdit:TRichEdit);
Var i:Integer;KeyWList:TStringList;
begin
 ARichEdit.Visible:=False;
 KeyWList:=TStringList.Create;
 If GetKeyWListfromRichEdit(ARichEdit,KeyWList) = False then
 begin
    ShowMessage('Keyword opening and closing brackets are not in pairs');
    //Exit;
 end;
 For i:=0 to KeyWList.Count-1 do HighLightAKeyWord(ARichEdit,KeyWList[i]);
 KeyWList.Free;
 ARichEdit.Visible:=True;
end;

procedure TRichFormFP_2012.UnHighLightKeyWords(ARichEdit:TRichEdit);
Var i,k,Endpos:Integer;KeyWList:TStringList;
Begin
 ARichEdit.Visible:=False;
 KeyWList:=TStringList.Create;
 If GetKeyWListfromRichEdit(ARichEdit,KeyWList) = False then
 begin
    ShowMessage('Keyword opening and closing brackets are not in pairs');
   // Exit;
 end;
 For i:=0 to KeyWList.Count-1 do UnHighLightAKeyWord(ARichEdit,KeyWList[i]);
 KeyWList.Free;
 With ARichEdit do
 begin
  //SetFocus;
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
 end;
 ARichEdit.Visible:=True;
end;

Procedure TRichFormFP_2012.HighLightAKeyWord(ARichEdit:TRichEdit;KeyW:String);
Var i,k:Integer;EndPos:Integer;
Begin
 With ARichEdit do
 begin
     k := 0;
     EndPos := length(ARichEdit.Text) ;
     k := FindText(KeyW, k, EndPos, []) ;
     while k <> -1 do
     begin
       If k<> -1 then
       begin
        ARichedit.SelStart := k;
        ARichEdit.SelLength := Length(KeyW);
        If UpperCase(LeftStr(Keyw,4))='FIMG' then
         ARichEdit.SelAttributes.Color := clGreen //$00750075  //clpurple
        else
         ARichEdit.SelAttributes.Color := clBlue;

        If InDataDict(KeyW) = False then ARichEdit.SelAttributes.Color := clRed;
       end;
       k := FindText(KeyW,k + length(KeyW),EndPos, []);
     end;
 end;

(*
 KeyW:='['+KeyW+']';
 With ARichEdit do
 begin
     k := 0;
     EndPos := length(ARichEdit.Text) ;
     k := FindText(KeyW, k, EndPos, []) ;
     while k <> -1 do
     begin
       If k<> -1 then
       begin
        ARichedit.SelStart := k;
        ARichEdit.SelLength := Length(KeyW);
        If UpperCase(LeftStr(Keyw,4))='FIMG' then
         ARichEdit.SelAttributes.Color := $00750075  //clpurple
        else
         ARichEdit.SelAttributes.Color := clBlue;

        //If InDataDict(KeyW) = False then ARichEdit.SelAttributes.Color := clRed;
       end;
       k := FindText(KeyW,k + length(KeyW),EndPos, []);
     end;
 end;
*)
end;

Procedure TRichFormFP_2012.UnHighLightAKeyWord(ARichEdit:TRichEdit;KeyW:String);
Var i,k:Integer;EndPos:Integer;
Begin
 With ARichEdit do
 begin
     k := 0;
     EndPos := length(ARichEdit.Text) ;
     k := FindText(KeyW, k, EndPos, []) ;
     while k <> -1 do
     begin
       If k<> -1 then
       begin
        ARichedit.SelStart := k;
        ARichEdit.SelLength := Length(KeyW);
        ARichEdit.SelAttributes.Color := clBlack;
       end;
       k := FindText(KeyW,k + length(KeyW),EndPos, []);
     end;
 end;
end;

Procedure TRichFormFP_2012.GoToKeyWInError(ARichEdit:TRichEdit;KeyW:String);
Var i:Integer;ToEnd:Integer;
Begin
 ToEnd:=Length(ARichEdit.Text);
 i := ARichEdit.FindText(KeyW, 0, ToEnd, []) ;
 If i<>-1 then
 begin
  ARichEdit.SetFocus;
  ARichedit.SelStart := i;
  ARichEdit.SelLength := Length(KeyW);
  ARichEdit.SelAttributes.Color := clRed;
 end;
end;

// Font operations
procedure TRichFormFP_2012.BoldExecute(Sender: TObject);
begin
  If Not InDesign then exit;
  with RichEdit1.SelAttributes do
    if fsBold in Style then
      Style := Style - [fsBold]
    else
      Style := Style + [fsBold];
end;

Function TRichFormFP_2012.ValidateLetter(ARichEdit:TRichEdit):String;
Var KeyWList:TStringList;
 I: integer;
 KeyW:string;
 Buffer:Pchar;
 WorkBuffer:Pchar;
 Size:Word;
 OrdKeyW:integer;
 LineNum:integer;
 J,L: integer;
 MaxLine:integer;
 s:string;
begin
 ARichEdit.SelStart := 0;
 ARichEdit.SelLength := 0;

 result:='';
 KeyWList:=TStringList.Create;
 If GetKeyWListFromRichEdit(ARichEdit,KeyWList) = False then
 begin
    ShowMessage('Keyword opening and closing brackets are not in pairs');
    Exit;
 end;
 LoadDataDict;

 For i:=0 to KeyWList.Count-1 do
 begin
  If InDataDict(KeyWList[i]) = False then
   Begin
    Result:=KeywList[i];
    KeyWList.Free;
    Exit;
   End;
 end;
 Result:='';
 KeyWList.Free;
 ARichEdit.SelStart := 0;
 ARichEdit.SelLength := 0;
end;

procedure TRichFormFP_2012.ItalicExecute(Sender: TObject);
begin
  If Not InDesign then exit;
  with RichEdit1.SelAttributes do
    if fsItalic in Style then
      Style := Style - [fsItalic]
    else
      Style := Style + [fsItalic];
end;

procedure TRichFormFP_2012.FontExecute(Sender: TObject);
begin
  FontDialog.Font.Assign (RichEdit1.SelAttributes);
  if FontDialog.Execute then
  begin
    RichEdit1.SelAttributes.Assign (FontDialog.Font);
    RichEdit1SelectionChange (Self);
  end;
end;

procedure TRichFormFP_2012.ChangeAlignment(Sender: TObject);
begin
   If Not InDesign then exit;
  // change paragraph alignment using the TAlignment
  // value saved in the tag of the action
  RichEdit1.Paragraph.Alignment := TParaAlignment ( //20160819 Igor
    (Sender as TAction).Tag);
end;

Function TRichFormFP_2012.InDesign:Boolean;
begin
 Result :=True;
 If DesignMode = false then
 begin
  ShowMessage('Please select Design mode first');
  result := False;
 end;

end;

procedure TRichFormFP_2012.AboutExecute(Sender: TObject);
begin
end;

/////////// File menu

procedure TRichFormFP_2012.NewExecute(Sender: TObject);
begin
  if (not Modified) or (SaveChanges) then
  begin
    RichEdit1.Text := '';
    Modified := False;
    FileName := '';
    GroupBox1.Caption := '[Untitled]';
  end;
end;

procedure TRichFormFP_2012.ExitExecute(Sender: TObject);
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

function TRichFormFP_2012.SaveChanges: Boolean;
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
function TRichFormFP_2012.Save(FileName:String): Boolean;
begin
    RichEdit1.Lines.SaveToFile(FileName);
    Modified := False;
    Result := True;
end;

// return False if SaveAs dialog box is cancelled
function TRichFormFP_2012.SaveAs: Boolean;
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

procedure TRichFormFP_2012.SaveExecute(Sender: TObject);
begin
  if Modified then Save(FileName);
end;

procedure TRichFormFP_2012.SaveAsExecute(Sender: TObject);
Var s:String;
begin
 If InDesign = false then exit;
 s:=ValidateLetter(RichEdit1);
 if S>'' then
 begin
  ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
  GoToKeyWInError(RichEdit1,s);
  exit;
 end;
 RichEdit1.Visible:=False;
 UnHighLightKeyWords(RichEdit1);
 SaveDialog.FileName := Filename;
 SaveDialog.InitialDir := AppDir;
 SaveAs;
 Modified := False;
 HighLightKeyWords(RichEdit1);
 RichEdit1.Visible:=True;
 With RichEdit1 do
 begin
  SetFocus;
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
 end;
end;

procedure TRichFormFP_2012.PrintExecute(Sender: TObject);
begin
 RichEdit1.Print (FileName);
end;

procedure TRichFormFP_2012.RichEdit1Change(Sender: TObject);
begin
  // enables save operations
  Modified := True;
end;

/////////// Options menu

procedure TRichFormFP_2012.BackColorExecute(Sender: TObject);
begin
  ColorDialog.Color := RichEdit1.Color;
  if ColorDialog.Execute then
    RichEdit1.Color := ColorDialog.Color;
end;

procedure TRichFormFP_2012.CountCharsExecute(Sender: TObject);
begin
  MessageDlg (Format (
    'The text has %d characters', [RichEdit1.GetTextLen]),
    mtInformation, [mbOK], 0);
end;

/////////// Form events

procedure TRichFormFP_2012.FormCreate(Sender: TObject);
var
  I,j, ToolSize: Integer;
  mItem: TMenuItem;
  tb: TToolButton;
begin
  TemplateDir := AppDir;
  TempLtrName := TemplateDir+'\'+'TempLtr.rtf';
  DefaultExtension := 'RTF';
  SaveDialog.DefaultExt := DefaultExtension;
  Modified := False;
  ComboFont.Items := Screen.Fonts;
  ComboFont.ItemIndex := ComboFont.Items.IndexOf(RichEdit1.Font.Name);

  ModeBox.ItemIndex :=0;
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
 LoadDataDict;
 //BorderIcons := [];
 FRetNo:=GetCurrentRetNo;
 If RetNo>0 then
 begin
   If FileExists(GetClientLettersDir+'\'+MkClientLetterName(RetNo)) then
   begin
    TemplateTypeBox.ItemIndex :=1;  {specific}
    FileName :=GetClientLettersDir+'\'+MkClientLetterName(RetNo);
    j:=GetPositionInList(MkClientLetterName(RetNo),FileListBox1);
    If J>=0 then FileListBox1.ItemIndex := j;
    RichEdit1.Lines.LoadFromFile (FileName);
    Modified := False;
    GroupBox1.Caption := FileName;
    RichEdit1.Invalidate;
    //RichEdit1.SelStart:=0;
    With RichEdit1 do
    begin
     SetFocus;
     SelStart := Perform(EM_LINEINDEX, 0, 0) ;
     SelLength:=0;
    end;
   end
   else
   begin
    TemplateTypeBox.ItemIndex :=0;
    ModeBox.ItemIndex :=0;
   end;
 end
 else
 begin
  TemplateTypeBox.ItemIndex :=0;
  ModeBox.ItemIndex :=0;
 end;
 Screen.Cursor := crDefault;
end;



procedure TRichFormFP_2012.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  // short-circuit evaluation: if not modified
  // doesn't even try to save. Doesn't close if
  // save request is cancelled
  CanClose := (not Modified) or (SaveChanges);
end;

// update events for actions

procedure TRichFormFP_2012.acSaveUpdate(Sender: TObject);
begin
  acSave.Enabled := Modified;
end;

procedure TRichFormFP_2012.acBoldUpdate(Sender: TObject);
begin
  acBold.Checked := fsBold in RichEdit1.SelAttributes.Style;
end;

procedure TRichFormFP_2012.acItalicUpdate(Sender: TObject);
begin
  acItalic.Checked := fsItalic in RichEdit1.SelAttributes.Style;
end;

procedure TRichFormFP_2012.acCountcharsUpdate(Sender: TObject);
begin
  acCountChars.Enabled := RichEdit1.GetTextLen > 0;
end;

procedure TRichFormFP_2012.acCutExecute(Sender: TObject);
begin
  If Not InDesign then exit;
  RichEdit1.CutToClipboard;
end;

procedure TRichFormFP_2012.acCutUpdate(Sender: TObject);
begin
  acCut.Enabled := RichEdit1.SelLength > 0;
  acCopy.Enabled := acCut.Enabled;
end;

procedure TRichFormFP_2012.acCopyExecute(Sender: TObject);
begin
  RichEdit1.CopyToClipboard;
end;

procedure TRichFormFP_2012.acPasteExecute(Sender: TObject);
begin
  RichEdit1.PasteFromClipboard;
end;

procedure TRichFormFP_2012.acPasteUpdate(Sender: TObject);
begin
//  acPaste.Enabled := SendMessage(RichEdit1.Handle, em_CanPaste, 0, 0) <> 0;
end;

procedure TRichFormFP_2012.acUndoExecute(Sender: TObject);
begin
  RichEdit1.Undo;
end;

procedure TRichFormFP_2012.acUndoUpdate(Sender: TObject);
begin
  acUndo.Enabled := RichEdit1.CanUndo;
end;

procedure TRichFormFP_2012.ActionListUpdate(Action: TBasicAction;
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

procedure TRichFormFP_2012.ToolButton17Click(Sender: TObject);
begin
  If Not InDesign then exit;
  RichEdit1.SelAttributes.Size :=
    RichEdit1.SelAttributes.Size + 2;
end;

procedure TRichFormFP_2012.SetFontSize(Sender: TObject);
begin
  RichEdit1.SelAttributes.Size :=
    (Sender as TMenuItem).Tag;
end;

procedure TRichFormFP_2012.ComboFontClick(Sender: TObject);
begin
  RichEdit1.SelAttributes.Name :=
    ComboFont.Text;
end;

procedure TRichFormFP_2012.RichEdit1SelectionChange(Sender: TObject);
begin
  // select the current font name in the font combo box
  ComboFont.ItemIndex :=
    ComboFont.Items.IndexOf (RichEdit1.SelAttributes.Name);
  (*
  // update the position in the status bar
  StatusBar.Panels[sbpPosition].Text := Format ('%d/%d',
    [RichEdit1.CaretPos.Y + 1, RichEdit1.CaretPos.X + 1]);
  *)
end;

procedure TRichFormFP_2012.acHintColorExecute(Sender: TObject);
begin
  ColorDialog.Color := Application.HintColor;
  if ColorDialog.Execute then
    Application.HintColor := ColorDialog.Color;
end;

procedure TRichFormFP_2012.BarMenuClick(Sender: TObject);
var
  aCtrl: TControl;
begin
  aCtrl := TControl ((Sender as TComponent).Tag);
  aCtrl.Visible := not aCtrl.Visible;
end;

procedure TRichFormFP_2012.BarMenuPopup(Sender: TObject);
var
  I: Integer;
begin
  // update the menu checkmarks
  for I := 0 to BarMenu.Items.Count - 1 do
    BarMenu.Items [I].Checked :=
      TControl (BarMenu.Items [I].Tag).Visible;
end;

procedure TRichFormFP_2012.ShowHint(Sender: TObject);
begin
  // show hint in the status bar message panel
 { StatusBar.Panels[sbpMessage].Text := Application.Hint;}
end;

procedure TRichFormFP_2012.CheckCapslock;
begin
 (*
  // show status in caps panel
  if Odd (GetKeyState (VK_CAPITAL)) then
    StatusBar.Panels[sbpCaps].Text := 'CAPS'
  else
    StatusBar.Panels[sbpCaps].Text := '';
 *)
end;

procedure TRichFormFP_2012.TimerTimer(Sender: TObject);
begin
  CheckCapslock;
end;

procedure TRichFormFP_2012.ControlBarLowerDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
  {ControlBarLower.BevelKind := bkTile;}
end;

procedure TRichFormFP_2012.ControlBarLowerUnDock(Sender: TObject;
  Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin
 {
  if ControlBarLower.DockClientCount = 1 then
    ControlBarLower.BevelKind := bkNone;}
end;

procedure TRichFormFP_2012.ControlBarLowerDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := Source.Control is TToolbar;
end;




procedure TRichFormFP_2012.ExitBtnClick(Sender: TObject);
begin
 ExitExecute(Sender);
end;

procedure TRichFormFP_2012.FormPaint(Sender: TObject);
begin
If DesignMode then
 begin
  InsertKeyWBtn.Enabled := True;
  RichEdit1.ReadOnly := False;
 end
else       {preview mode}
 begin
  InsertKeyWBtn.Enabled := False;
  RichEdit1.ReadOnly := True;
 end;

 {
  If (LicenseLevel = 'T1 NetFile')
  Or (LicenseLevel = 'T1 Limited')
  Or (LicenseLevel = 'T1 Standard') then  LogoBtn.Enabled := False;
 } 
end;

procedure TRichFormFP_2012.InsertKeyWBtnClick(Sender: TObject);
Var i:Integer;
begin
 If Not InDesign then exit;
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := 'Key Words';
 {LoadDataDict;}
 for i :=0 to (DataDictList.Count - 1) do
   begin
    DataDictRec := DataDictList.Items[i];
    SomeList.Add(DataDictRec.KeyWord);
   end;
 Application.CreateForm(TPoplistFP_2012,PopList);
 PopList.ShowModal;
 //SomeList.Free;
 PopList.Release;
 If SelectedString > '' then
 begin
    If InputBox('Input Box',
    'If Keyword is part of a If statement, enter N', 'Y') = 'Y' then
     RichEdit1.SelText := '['+SelectedString+']'+' '
    else
     RichEdit1.SelText := SelectedString+' ';
    Modified:=True;
    LoadDataDict;
 end;
 HighLightKeyWords(RichEdit1);
end;

procedure TRichFormFP_2012.FileListBox1Click(Sender: TObject);
Var s:String;
begin
 If not InDesign then exit;
 If (Modified = False) or
  ((Modified = True and (MessageDlg('Letter Changed. Save it?',
    mtInformation, [mbYes, mbNo], 0) = mrNo)))
 then
 begin
  FileName := FileListBox1.Items[FileListBox1.ItemIndex];
  If FileName > '' then
  begin
   LoadTemplate(TemplateDir+'\'+FileName);
   s:=ValidateLetter(RichEdit1);
   if S>'' then
   begin
   //ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
    GoToKeyWInError(RichEdit1,s);
    exit;
   end;
  end;
 end;
 RichEdit1.SelStart := 0;
 RichEdit1.SelLength := 0;
end;

Procedure TRichFormFP_2012.LoadTemplate(FlName:String);
begin
  LoadDataDict;
  RichEdit1.Lines.LoadFromFile (FlName);
  HighLightKeyWords(RichEdit1);
  Modified := False;
  GroupBox1.Caption := FlName;
  RichEdit1.Invalidate;
  //RichEdit1.SelStart:=0;
  With RichEdit1 do
  begin
   //SetFocus;
   SelStart := Perform(EM_LINEINDEX, 0, 0) ;
   SelLength:=0;
  end;

end;

procedure TRichFormFP_2012.TemplateTypeBoxClick(Sender: TObject);
begin
  If Not inDesign then exit;
  LoadTemplateList;
  FileListBox1.Directory :=TemplateDir;
  FileListBox1.ApplyFilePath(TemplateDir);
  Modified := False;
  If FileListBox1.Items.Count >0 then
  begin
   FileListBox1.ItemIndex :=0;
   If FileListBox1.Items[FileListBox1.ItemIndex] >'' then
   begin
    FileName :=FileListBox1.Items[FileListBox1.ItemIndex];
    If FileExists(FileName) then  LoadTemplate(FileName);
   end;
  end
  else
   RichEdit1.Clear;
end;

procedure TRichFormFP_2012.LetterHeadBoxClick(Sender: TObject);
Var i:Integer;
begin
 (*
 If LetterheadBox.Checked then
 begin
  RichEdit1.SelStart :=0;
  For i:=1 to 6 do RichEdit1.SelText := '\par'+Chr(13);
 end;
 *)
end;

procedure TRichFormFP_2012.Savespecificallyforthisclient1Click(Sender: TObject);
Var s:String;
begin
If RetInMem = 0 then
 begin
  ShowMessage('You must open a file first');
  exit;
 end;
 If not InDesign then exit;

 s:=ValidateLetter(RichEdit1);
 if S>'' then
 begin
  ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
  GoToKeyWInError(RichEdit1,s);
  exit;
 end;

 //If ValidateLetter(RichEdit1) = false then exit;
 UnHighLightKeyWords(RichEdit1);
 SaveDialog.FileName := GetClientLettersDir+'\'+MkClientLetterName(RetNo);
 SaveDialog.DefaultExt := '*RTF';
 SaveAs;
 HighLightKeyWords(RichEdit1);
 TemplateTypeBoxClick(Sender);
 With RichEdit1 do
 begin
  SetFocus;
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
 end;

end;

procedure TRichFormFP_2012.Deletethistemplate1Click(Sender: TObject);
begin

 If Not inDesign then exit;

if MessageDlg('Delete Letter '+FileName+'?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;

 If FileExists(TemplateDir+'\'+FileName) then
   SysUtils.DeleteFile(TemplateDir+'\'+FileName);
 TemplateTypeBoxClick(Sender);
end;

Procedure TRichFormFP_2012.LoadTemplateList;
begin
 Case TemplateTypeBox.ItemIndex of
  0: begin
      TemplateTypeBox.ItemIndex:=0;
      TemplateDir := AppDir;
      FileListBox1.Mask := 'EXECSUM.rtf;EngagementLetter.rtf;PIPEDALetter.rtf';
      end;

  1: begin
      TemplateDir := AppDir;
      FileListBox1.Mask := '*.'+DefaultExtension;
     end;

  2: begin
     TemplateDir := GetClientLettersDir;
     FileListBox1.Mask := '*.'+DefaultExtension;
  end;
 end;
 FileListBox1.Directory :=TemplateDir;
 FileListBox1.ApplyFilePath(TemplateDir);
 Modified := False;
 If FileListBox1.Items.Count>0 then
 begin
 FileListBox1.ItemIndex :=0;
 FileListBox1.Refresh;
 If FileListBox1.Items[FileListBox1.ItemIndex] >'' then
  begin
   FileName :=FileListBox1.Items[FileListBox1.ItemIndex];
   If FileExists(FileName) then
     LoadTemplate(FileName);
  end;
 end;
end;

procedure TRichFormFP_2012.ModeBoxClick(Sender: TObject);
begin
  If ModeBox.ItemIndex =0 then
  begin
   RichEdit1.Enabled := True;
   RichEdit1.Clear;
   If FileExists(TemplateDir+'\'+'tempWip') then
    RichEdit1.Lines.LoadFromFile(TemplateDir+'\'+'tempWip');
   DesignMode :=True;
   Invalidate;
   Modified := False;
  end;
end;

procedure TRichFormFP_2012.PreviewBtnClick(Sender: TObject);
Var i:Integer;s:String;KeyWList:TStringList;
begin
 If RetInMem = 0 then
 begin
  ShowMessage('You must open a file with some data '+
    Chr(13)+ 'before you can preview the letter');
  exit;
 end;

 KeyWList:=TStringList.Create;
 If GetKeyWListfromRichEdit(RichEdit1,KeyWList) = False then
 begin
    ShowMessage('Keyword opening and closing brackets are not in pairs');
   // Exit;
 end;
 KeyWList.Free;

 s:=ValidateLetter(RichEdit1);
 if S>'' then
 begin
  ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
  GoToKeyWInError(RichEdit1,s);
  exit;
 end;
 RichEdit1.Visible:=False;
 UnHighLightKeyWords(RichEdit1);
 RichEdit1.Lines.SaveToFile(AppDir+'\'+'NonInterpreted.rtf');  //un-interpter //20160819 Igor
 GetInterpretedRichEdit(GetCurrentRetNo,AppDir+'\'+'NonInterpreted.rtf',RichEdit1); //20160819 igor
 //now ARichEdit has the interpreted
 RichEdit1.Lines.SaveToFile(TempLtrName);  //interpreted
 Preview(RichEdit1);
 RichEdit1.Clear;
 RichEdit1.Lines.LoadFromFile(AppDir+'\'+'NonInterpreted.rtf'); //20160819 igor
 Modified := False;
 HighLightKeyWords(RichEdit1);
 With RichEdit1 do
 begin
  Visible:=True;
  SetFocus;
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
 end;
end;

procedure TRichFormFP_2012.Preview(ARichEdit:TRichEdit);
Var i,j:integer;  AList: TstringList;txt :string; //ErrorC : boolean;
begin
  QRLtrName:=TempLtrName;
  Application.CreateForm(TPreviewRichFP_2027,PreviewRich);
  PreviewRich.ShowModal;
  PreviewRich.Free;
end;

procedure TRichFormFP_2012.ComboFontChange(Sender: TObject);
begin
  If Not InDesign then exit;
end;

procedure TRichFormFP_2012.Save1Click(Sender: TObject);
Var S:String;
begin
 If InDesign = false then exit;
 s:=ValidateLetter(RichEdit1);
 if S>'' then
 begin
  ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
  GoToKeyWInError(RichEdit1,s);
  exit;
 end;
 UnHighLightKeyWords(RichEdit1);
 RichEdit1.Visible:=False;
 SaveDialog.FileName := TemplateDir+'\'+Filename;

 SaveDialog.DefaultExt := '*.RTF';
 SaveDialog.InitialDir := TemplateDir;

 Save(TemplateDir+'\'+FileName);
 Modified := False;
 HighLightKeyWords(RichEdit1);
 ShowTimedMsg('Saved',1200);
 With RichEdit1 do
 begin
  SetFocus;
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
 end;
end;


procedure TRichFormFP_2012.LogoBtnClick(Sender: TObject);
Var LogoName,IncludeLogo,LogoHeight,LogoWidth,LogoPosition:String;
begin
 //ShowMessage('Logo disabled for the time being'+ Chr(13)+'It was causing problems in some installations');
 //GetLogoInfo(LogoName,IncludeLogo,LogoHeight,LogoWidth,LogoPosition);
 //IncludeLogo:='N';
 //SaveLogoInfo(LogoName,IncludeLogo,LogoHeight,LogoWidth,LogoPosition);

(*

 Application.CreateForm(TCompLogo,CompLogo);
 CompLogo.ShowModal;
 CompLogo.Free;
 *)
end;

procedure TRichFormFP_2012.HelpBtnClick(Sender: TObject);
begin
  ShowHelp('FpHelp','client_letter');
end;

procedure TRichFormFP_2012.DataDictBtnClick(Sender: TObject);
begin
  FixDbForm(AppDir, DictDBLite, DictTableLite, dbtDataDict);//20150918 Igor
  LoadDataDict;
end;

procedure TRichFormFP_2012.ConvertLetterClick(Sender: TObject);
begin
 ConvertOldLetter(RichEdit1);
end;

procedure TRichFormFP_2012.SlashToLeftBracketBtnClick(Sender: TObject);
begin
// ReplaceRtfDelimiters(RichEdit1,'\','[');
end;

procedure TRichFormFP_2012.SlashToRightBracketBtnClick(Sender: TObject);
begin
// ReplaceRtfDelimiters(RichEdit1,']','\');
end;

procedure TRichFormFP_2012.InsertGraphicBtnClick(Sender: TObject);
begin
 //RichEdit1.Execute;
 If Not InDesign then exit;
 With OpenPictureDialog1 do
 begin
  OpenPictureDialog1.InitialDir:=AppDir;
  OpenPictureDialog1.Title:='Select a graphics file from any folder';
  If OpenPictureDialog1.Execute then
  begin
   If fileName>'' then
   begin
    RichEdit1.SelText := '[FImg ('+Chr(39)+FileName+Chr(39)+')]';
    HighLightKeyWords(RichEdit1);
    Modified:=True;
    LoadDataDict;
   end;
  end;
 end;
 (*
 Application.CreateForm(TSelectFile,SelectFile);
 SelectFile.ShowModal;
 SelectFile.Free;
 If SelectedString>'' then
 begin
  If IsAcceptableGraphicsFile(SelectedString) = false then
  begin
   ShowMessage('Acceptable graphics files are BMP,JPG,WMF');
   SelectedString:='';
   Exit;
  end;
  RichEdit1.SelText := '[FImg ('+Chr(39)+SelectedString+Chr(39)+')]';
  HighLightKeyWords(RichEdit1);
  Modified:=True;
 end;
 *)
end;
 (*
   LogoFile.Text:=SelectedString;
 If IsAcceptableGraphicsFile(LogoFile.Text) = false then
 begin
  ShowMessage('Acceptable graphics files are BMP,JPG,WMF');
  LogoFile.Text:='';
  Exit;
 end;
 If FileExists(LogoFile.Text) then
   LogoImage.Picture.LoadFromFile(LogoFile.Text)
 Else
 begin
   LogoImage.Picture:=Nil;
   Prn_Logo.Checked := False;
 end;
 *)



procedure TRichFormFP_2012.SaveBtnClick(Sender: TObject);
begin
 If TemplateTypeBox.ItemIndex =1 then
   Savespecificallyforthisclient1Click(Sender)
 else
   Save1Click(Sender);
end;

procedure TRichFormFP_2012.InsertFileBtnClick(Sender: TObject);
Var FileName:String;InPos:Integer;h:THandle;
Begin
 If Not InDesign then exit;
 Application.CreateForm(TRTFFormFP_2027,RtfForm);
 RtfForm.ShowModal;
 RtfForm.Free;
 (*
 With OpenDialog1 do
 begin
  OpenDialog1.InitialDir:=AppDir;
  If OpenDialog1.Execute then
  Begin
   FileName:=OpenDialog1.FileName;

   {
   If UpperCase(ExtractFileExt(FileName))='.LTR' then
   begin
    //ChangeFileExt(FileName,'.RTF');
    //h:=ShellExecute(Handle,'open','c:\windows\notepad.exe',Pchar(''+FileName),nil, SW_SHOWNORMAL);
   end
   else
    h := ShellExecute(Self.Handle,'open',Pchar(''+FileName),Nil,Nil,Sw_Show);
   If h<=32 then
    begin ShowMessage('File open failed');end;
   }
  // LoadTemplate(FileName);
   {
   InPos:=RichEdit1.SelStart;
   If FileName>'' then
   begin
    If FileExists(FileName) then
       InsertFileIntoRtf(RichEdit1,InPos,FileName);
   end;
   GroupBox1.Caption := FileName;
   GroupBox1.Refresh;
   RichEdit1.PlainText:=False;
   }
  end;
 end;
 *)
end;

procedure TRichFormFP_2012.InsertFileIntoRtf(ARichEdit:TRichEdit;InPos:Integer;FileName:String);
Var TempRtf:TRichEdit;
begin
 ARichEdit.Lines.Clear;
 ARichEdit.Lines.LoadFromFile(FileName);
 If UpperCase(ExtractFileExt(FileName))='.LTR' then
 begin
  ConvertOldLetter(ARichEdit);
 end;

 {
 TempRtf:=TwwDbRichEdit.Create(Application);
 TempRtf.parent := Self;
 TempRtf.Visible:=False;
 TempRtf.Lines.LoadFromFile(FileName);
 TempRtf.Free;
 }
 Modified:=True;
end;

procedure TRichFormFP_2012.PrintBtnClick(Sender: TObject);
begin

 If RetInMem = 0 then
 begin
  ShowMessage('You must open a file with some data '+
    Chr(13)+ 'before you can print the letter');
  exit;
 end;
 If FileListBox1.ItemIndex<0 then
 begin
  ShowTimedMsg('Please select (click) a letter on the list',1400);
  Exit;
 end;
 if MessageDlg('Printing should be done after saving a modified letter. Print now?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
  LetterName:=FileListBox1.Items[FileListBox1.ItemIndex];
  SomeLetterName:=LetterName;
  If MainFormFP.PrintDialogItem.execute then
  begin
    MainFormFP.StartPrintForm(Retno,'ALETTER',99);
    if Printer.Printing then //20160905 Igor
      Printer.EndDoc;        //20160905 Igor
  end;
 end;
end;

end.
