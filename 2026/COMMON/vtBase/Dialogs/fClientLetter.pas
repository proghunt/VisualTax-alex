unit fClientLetter;

interface

uses
  SysUtils, Windows, Messages,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ComCtrls,ExtCtrls, Menus,ActnList,ToolWin,ImgList,ClipBrd,AppEvnts,Buttons,
  ShellApi, RichEdit, ExtDlgs,FileCtrl,
  vtMulti, vtRichmemobox, System.Actions,

  RxRichEd; //20160819 Igor (It must be the last)

type
  TLetterEditor = class(TForm)
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
    procedure ExitBtnClick(Sender: TObject);
    //procedure FormPaint(Sender: TObject);////20170410 igor 
    procedure InsertKeyWBtnClick(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
    procedure TemplateTypeBoxClick(Sender: TObject);
    procedure LetterHeadBoxClick(Sender: TObject);
    procedure Savespecificallyforthisclient1Click(Sender: TObject);
    procedure Deletethistemplate1Click(Sender: TObject);
    procedure ModeBoxClick(Sender: TObject);
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
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormShow(Sender: TObject); //20170417 Igor
  private
    DataDict: TDataDictList;
    procedure LoadDataDict;
    Procedure GoToKeyWInError({ARichEdit:TRichEdit;}KeyW:String);
    procedure HighLightKeyWords;  //(ARichEdit:TRichEdit);
    procedure UnHighLightKeyWords;  //(ARichEdit:TRichEdit);
    Procedure UnHighLightAKeyWord(KeyW: String; ARichEdit: TvtRichMemo); //20170409 Igor
    Procedure HighLightAKeyWord(KeyW: String; ARichEdit: TRichEdit); //20170409 Igor
    Function  InDesign:Boolean;

    {Client letter}
  {$IFDEF unused}
    procedure InsertFileIntoRtf(ARichEdit:TRichEdit;InPos:Integer;FileName:String);
  {$ELSE}
  {$ENDIF}
    Function ValidateLetter:String;
    procedure Preview;  //(ARichEdit:TRichEdit);
    Procedure LoadTemplateList;
    Procedure LoadTemplate(FlName:String);
  private
    FileName: string;
    Modified: Boolean;
    MyApp: TApp;
    //20170409 Igor >>>
    FUpdate: Integer;
    FCurrentOperate: Integer;
    FOldAppOnIddle: TIdleEvent;
    procedure BeginUpdate;
    procedure EndUpdate;
    //20170409 Igor <<<

  private
    FRetNo: integer;
    DefaultExtension : string; //[3];
    TemplateDir : String;
    DesignMode : Boolean;
    TempLtrName : String;
    procedure SetRetNo(const Value: Integer);
  {$IFDEF unused}
    Report : TQuickRep;
    {For client Letter}
    {FileName : string; //[40];}
    MousePosOnMemo :integer;
    LtrErrorSw : boolean;
    cursor_position:integer;
    KeyWLength : Byte;
    ReplaceString:string;
    ValidateLetterflag:boolean;
  {$ELSE}
  {$ENDIF}
  public
    property RetNo:Integer read FRetNo write SetRetNo;
    function SaveChanges: Boolean;
    function Save(FileName:String): Boolean;
    function SaveAs: Boolean;
    procedure BarMenuClick (Sender: TObject);
    procedure CheckCapslock;
  end;

var
 // RetNo:Integer;
  LetterEditor: TLetterEditor;

implementation

{$R *.DFM}

uses
  vtCommon,vtDialogs,vtMain,
  vtTrimStr,vtRichText,
  vtShared;

const
  sbpMessage = 0;
  sbpCaps = 1;
  sbpPosition = 2;


procedure TLetterEditor.HighLightKeyWords; //20170410 Igor
Var
  i: Integer;
  KeyWList: TStringList;
begin
  BeginUpdate;
  KeyWList := TStringList.Create;
  try
    If GetKeyWListfromRichEdit(DataDict, RichEdit1, KeyWList) = False then
    begin
      ShowMessage('Keyword opening and closing brackets are not in pairs');
      Exit;
    end;
    For i := 0 to KeyWList.Count - 1 do
      HighLightAKeyWord(KeyWList[i], RichEdit1);
  finally
    KeyWList.Free;
    EndUpdate;
  end;
end;

procedure TLetterEditor.UnHighLightKeyWords; //20170410 Igor
Var
  i: Integer;
  KeyWList: TStringList;
Begin
  BeginUpdate;
  KeyWList := TStringList.Create;
  try
    If GetKeyWListfromRichEdit(DataDict, RichEdit1, KeyWList) = False then
    begin
      ShowMessage('Keyword opening and closing brackets are not in pairs');
      Exit;
    end;
    For i := 0 to KeyWList.Count - 1 do
      UnHighLightAKeyWord(KeyWList[i], RichEdit1);
  finally
    KeyWList.Free;
    EndUpdate;
  end;
  With RichEdit1 do
  begin
    SelStart := Perform(EM_LINEINDEX, 0, 0) ;
    SelLength:=0;
    //ArichEdit.Font.Color:=clBlack;   //20090406 does not doi it
  end;
end;

Procedure TLetterEditor.HighLightAKeyWord(KeyW: String; ARichEdit: TRichEdit);//20170410 Igor
Var
  k: Integer;
  EndPos: Integer;
Begin
  With ARichEdit do
  begin
    k := 0;
    EndPos := length(Text) ;
    k := FindText(KeyW, k, EndPos, []) ;
    while k <> -1 do
    begin
      If k<> -1 then
      begin
        SelStart := k;
        SelLength := Length(KeyW);
        If UpperCase(LeftStr(Keyw,4))='FIMG' then
          SelAttributes.Color := clGreen //$00750075  //clpurple
        else
          SelAttributes.Color := clBlue;
        If DataDict.InDataDict(KeyW) = False then
          SelAttributes.Color := clRed;
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

Procedure TLetterEditor.UnHighLightAKeyWord(KeyW: String; ARichEdit: TvtRichMemo); //20170410 Igor
Var
  k: Integer;
  EndPos: Integer;
Begin
  With ARichEdit do
  begin
    k := 0;
    EndPos := length(Text) ;
    k := FindText(KeyW, k, EndPos, []) ;
    while k <> -1 do
    begin
      If k<> -1 then
      begin
        SelStart := k;
        SelLength := Length(KeyW);
        SelAttributes.Color := clBlack;
      end;
      k := FindText(KeyW,k + length(KeyW),EndPos, []);
    end;
  end;
end;

Procedure TLetterEditor.GoToKeyWInError(KeyW:String);
Var i:Integer;ToEnd:Integer;
Begin
 ToEnd:=Length(RichEdit1.Text);
 i := RichEdit1.FindText(KeyW, 0, ToEnd, []) ;
 If i<>-1 then
 begin
  RichEdit1.SetFocus;
  RichEdit1.SelStart := i;
  RichEdit1.SelLength := Length(KeyW);
  RichEdit1.SelAttributes.Color := clRed;
 end;
end;

// Font operations
procedure TLetterEditor.BoldExecute(Sender: TObject);
begin
  If Not InDesign then exit;
  with RichEdit1.SelAttributes do
    if fsBold in Style then
      Style := Style - [fsBold]
    else
      Style := Style + [fsBold];
end;

Function TLetterEditor.ValidateLetter():String; //20170410 Igor
begin
  BeginUpdate;
  try
    Result := DataDict.ValidateLetter(RichEdit1);
  finally
    EndUpdate;
  end;
end;

procedure TLetterEditor.ItalicExecute(Sender: TObject);
begin
  If Not InDesign then exit;
  with RichEdit1.SelAttributes do
    if fsItalic in Style then
      Style := Style - [fsItalic]
    else
      Style := Style + [fsItalic];
end;

procedure TLetterEditor.FontExecute(Sender: TObject);
begin
  FontDialog.Font.Assign (RichEdit1.SelAttributes);
  if FontDialog.Execute then
  begin
    RichEdit1.SelAttributes.Assign (FontDialog.Font);
    RichEdit1SelectionChange (Self);
  end;
end;

procedure TLetterEditor.ChangeAlignment(Sender: TObject);
begin
   If Not InDesign then exit;
  // change paragraph alignment using the TAlignment
  // value saved in the tag of the action
  RichEdit1.Paragraph.Alignment := TParaAlignment ( //20160819 Igor
    (Sender as TAction).Tag);
end;

Function TLetterEditor.InDesign:Boolean;
begin
 Result :=DesignMode;
 If DesignMode = false then
   ShowMessage('Please select Design mode first');
end;

procedure TLetterEditor.AboutExecute(Sender: TObject);
begin
end;

/////////// File menu

procedure TLetterEditor.NewExecute(Sender: TObject);
begin
  if (not Modified) or (SaveChanges) then
  begin
    RichEdit1.Text := '';
    Modified := False;
    FileName := '';
    GroupBox1.Caption := '[Untitled]';
  end;
end;

procedure TLetterEditor.ExitExecute(Sender: TObject);
begin
  If DesignMode = False then
  begin
   RichEdit1.Clear;
   If FileExists(TemplateDir+'\'+'tempWip') then
   begin
   RichEdit1.LoadFromFile(TemplateDir+'\'+'tempWip');//20170410 Igor
   DesignMode :=True;
   Invalidate;
   end;
  end;
  Close;
end;

function TLetterEditor.SaveChanges: Boolean;
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
function TLetterEditor.Save(FileName:String): Boolean;
begin
    RichEdit1.Lines.SaveToFile(FileName);
    Modified := False;
    Result := True;
end;

// return False if SaveAs dialog box is cancelled
function TLetterEditor.SaveAs: Boolean;
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

procedure TLetterEditor.SaveExecute(Sender: TObject);
begin
  if Modified then Save(FileName);
end;

procedure TLetterEditor.SaveAsExecute(Sender: TObject);
Var s:String;
begin
 If InDesign = false then exit;
 s:=ValidateLetter();
 if S>'' then
 begin
  ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
  GoToKeyWInError(s);
  exit;
 end;
 RichEdit1.Visible:=False;
 UnHighLightKeyWords();
 SaveDialog.FileName := Filename;
 SaveDialog.InitialDir := MyApp.AppDir;
 SaveAs;
 Modified := False;
 HighLightKeyWords();
 RichEdit1.Visible:=True;
 With RichEdit1 do
 begin
  SetFocus;
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
 end;
end;

procedure TLetterEditor.PrintExecute(Sender: TObject);
begin
 RichEdit1.Print (FileName);
end;

procedure TLetterEditor.RichEdit1Change(Sender: TObject);
begin
  // enables save operations
  Modified := True;
end;

/////////// Options menu

procedure TLetterEditor.BackColorExecute(Sender: TObject);
begin
  ColorDialog.Color := RichEdit1.Color;
  if ColorDialog.Execute then
    RichEdit1.Color := ColorDialog.Color;
end;

procedure TLetterEditor.CountCharsExecute(Sender: TObject);
begin
  MessageDlg (Format (
    'The text has %d characters', [RichEdit1.GetTextLen]),
    mtInformation, [mbOK], 0);
end;

/////////// Form events

procedure TLetterEditor.FormCreate(Sender: TObject); //20170410 Igor
var
  I, ToolSize: Integer;
  mItem: TMenuItem;
  tb: TToolButton;
begin
//multi-app specific
  FUpdate := 0;
  if DesignMode then
  begin
    InsertKeyWBtn.Enabled := True;
    RichEdit1.ReadOnly := False;
  end
  else       {preview mode}
  begin
    InsertKeyWBtn.Enabled := False;
    RichEdit1.ReadOnly := True;
  end;

  if RetNo < 1 then
    RetNo := GetCurrentRetNo;
  if RetNo > 0 then
    MyApp := RetList[RetNo].MyApp
  else
    MyApp := CurrentApp;

  case MyApp.LicenseLevel of
    llHome, llLimited, llLimEfile, llStd:
      LogoBtn.Enabled := False;
  end;

  TemplateDir := MyApp.AppDir;
  TempLtrName := TemplateDir + '\' + 'TempLtr.rtf';
  DefaultExtension := 'RTF';
  SaveDialog.DefaultExt := DefaultExtension;
  Modified := False;
  ComboFont.Items := Screen.Fonts;
  ComboFont.ItemIndex := ComboFont.Items.IndexOf(RichEdit1.Font.Name);

  ModeBox.ItemIndex := 0;
  DesignMode := True;
// populate the control bar menu
  for i := 0 to ControlBar.ControlCount - 1 do
  begin
    mItem := TMenuItem.Create(Self);
    mItem.Caption := ControlBar.Controls[i].Name;
    mItem.Tag := Integer(ControlBar.Controls[i]);
    mItem.OnClick := BarMenuClick;
    BarMenu.Items.Add(mItem);
  end;

// create the buttons of the menu toolbar
  ToolSize := 0;
  for i := MainMenu.Items.Count - 1 downto 0 do
  begin
    tb := TToolButton.Create(ToolBarMenu);
    tb.Parent := ToolBarMenu;
    tb.AutoSize := True;
    tb.Grouped := True;
    tb.Caption := MainMenu.Items[i].Caption;
    tb.MenuItem := MainMenu.Items[i];
    Inc(ToolSize, tb.Width);
  end;
// size the menu toolbar
  ToolBarMenu.Width := ToolSize;
// hide the standard menu, using the form's Menu property
  Menu := nil;

  
end;

procedure TLetterEditor.FormShow(Sender: TObject); //20170417 Igor
var
  J: Integer;
begin
  BeginUpdate;
  try
    DataDict := MyApp.LoadDataDict;

 //LoadDataDict; - in FormCreaete
 //BorderIcons := [];
    if RetNo > 0 then
    begin
    //FileName :=GetClientLettersDir(MyApp)+'\'+MkClientLetterName(RetNo);
      FileName := MkClientLetterName(RetNo, True);
      if FileExists(FileName) then
      begin
        TemplateTypeBox.ItemIndex := 1;  {specific}
    //j:=GetPositionInList(MkClientLetterName(RetNo),FileListBox1);
        j := FileListBox1.Items.IndexOf(MkClientLetterName(RetNo));
        if j >= 0 then
          FileListBox1.ItemIndex := j;
        RichEdit1.LoadFromFile(FileName);
        Modified := False;
        GroupBox1.Caption := FileName;
        RichEdit1.Invalidate;
    //RichEdit1.SelStart:=0;
        with RichEdit1 do
        begin
//          SetFocus;
          SelStart := Perform(EM_LINEINDEX, 0, 0);
          SelLength := 0;
        end;
      end
      else
      begin
        TemplateTypeBox.ItemIndex := 0;
        ModeBox.ItemIndex := 0;
      end;
    end
    else
    begin
      TemplateTypeBox.ItemIndex := 0;
      ModeBox.ItemIndex := 0;
    end;
    Screen.Cursor := crDefault;
  finally
    endUpdate;
  end;
end;

procedure TLetterEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  // short-circuit evaluation: if not modified
  // doesn't even try to save. Doesn't close if
  // save request is cancelled
  CanClose := (not Modified) or (SaveChanges);
end;

// update events for actions

procedure TLetterEditor.acSaveUpdate(Sender: TObject);
begin
//20170410 igor >>>
  if FUpdate > 0 then
    exit;
//20170410 igor <<<
  acSave.Enabled := Modified;
end;

procedure TLetterEditor.acBoldUpdate(Sender: TObject);
begin
//20170410 igor >>>
  if FUpdate > 0 then
    exit;
//20170410 igor <<<
  acBold.Checked := fsBold in RichEdit1.SelAttributes.Style;
end;

procedure TLetterEditor.acItalicUpdate(Sender: TObject);
begin
//20170410 igor >>>
  if FUpdate > 0 then
    exit;
//20170410 igor <<<
  acItalic.Checked := fsItalic in RichEdit1.SelAttributes.Style;
end;

procedure TLetterEditor.acCountcharsUpdate(Sender: TObject);
begin
//20170410 igor >>>
  if FUpdate > 0 then
    exit;
//20170410 igor <<<
  acCountChars.Enabled := RichEdit1.GetTextLen > 0;
end;

procedure TLetterEditor.acCutExecute(Sender: TObject);
begin
  If Not InDesign then exit;
  RichEdit1.CutToClipboard;
end;

procedure TLetterEditor.acCutUpdate(Sender: TObject);
begin
//20170410 igor >>>
  if FUpdate > 0 then
    exit;
//20170410 igor <<<
  acCut.Enabled := RichEdit1.SelLength > 0;
  acCopy.Enabled := acCut.Enabled;
end;

procedure TLetterEditor.acCopyExecute(Sender: TObject);
begin
  RichEdit1.CopyToClipboard;
end;

procedure TLetterEditor.acPasteExecute(Sender: TObject);
begin
  RichEdit1.PasteFromClipboard;
end;

procedure TLetterEditor.acPasteUpdate(Sender: TObject);
begin
//  acPaste.Enabled := SendMessage(RichEdit1.Handle, em_CanPaste, 0, 0) <> 0;
end;

procedure TLetterEditor.acUndoExecute(Sender: TObject);
begin
  RichEdit1.Undo;
end;

procedure TLetterEditor.acUndoUpdate(Sender: TObject);
begin
//20170410 igor >>>
  if FUpdate > 0 then
    exit;
//20170410 igor <<<
  acUndo.Enabled := RichEdit1.CanUndo;
end;

procedure TLetterEditor.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
//20170410 igor >>>
  if FUpdate > 0 then
    exit;
//20170410 igor <<<
  // check the proper paragraph alignment
  case RichEdit1.Paragraph.Alignment of
    paLeftJustify: acLeftAligned.Checked := True; //20160819 Igor
    paRightJustify: acRightAligned.Checked := True; //20160819 Igor
    paCenter: acCentered.Checked := True; //20160819 Igor
  end;
  // checks the caps lock status
  CheckCapslock;
end;

procedure TLetterEditor.ToolButton17Click(Sender: TObject);
begin
  If Not InDesign then exit;
  RichEdit1.SelAttributes.Size :=
    RichEdit1.SelAttributes.Size + 2;
end;

procedure TLetterEditor.SetFontSize(Sender: TObject);
begin
  RichEdit1.SelAttributes.Size :=
    (Sender as TMenuItem).Tag;
end;

procedure TLetterEditor.SetRetNo(const Value: Integer);
begin
//20150815 problem with GUI RetNo: can be zero!?
  if Value > 0 then
    FRetNo := Value;
end;

procedure TLetterEditor.ComboFontClick(Sender: TObject);
begin
  RichEdit1.SelAttributes.Name :=
    ComboFont.Text;
end;

procedure TLetterEditor.RichEdit1SelectionChange(Sender: TObject);
begin
//20170410 igor >>>
  if FUpdate > 0 then
    exit;
//20170410 igor <<<
  // select the current font name in the font combo box
  ComboFont.ItemIndex :=
    ComboFont.Items.IndexOf (RichEdit1.SelAttributes.Name);
  (*
  // update the position in the status bar
  StatusBar.Panels[sbpPosition].Text := Format ('%d/%d',
    [RichEdit1.CaretPos.Y + 1, RichEdit1.CaretPos.X + 1]);
  *)
end;

procedure TLetterEditor.acHintColorExecute(Sender: TObject);
begin
  ColorDialog.Color := Application.HintColor;
  if ColorDialog.Execute then
    Application.HintColor := ColorDialog.Color;
end;

procedure TLetterEditor.BarMenuClick(Sender: TObject);
var
  aCtrl: TControl;
begin
  aCtrl := TControl ((Sender as TComponent).Tag);
  aCtrl.Visible := not aCtrl.Visible;
end;

procedure TLetterEditor.BarMenuPopup(Sender: TObject);
var
  I: Integer;
begin
  // update the menu checkmarks
  for I := 0 to BarMenu.Items.Count - 1 do
    BarMenu.Items [I].Checked :=
      TControl (BarMenu.Items [I].Tag).Visible;
end;

procedure TLetterEditor.BeginUpdate; //20170410 Igor
begin
  if FUpdate = 0 then
  begin
    RichEdit1.OnSelectionChange := Nil;
    RichEdit1.OnChange := Nil;
    RichEdit1.Lines.BeginUpdate;
    RichEdit1.Visible := False;
    GroupBox1.Visible := False;
    FOldAppOnIddle := Application.OnIdle;
    Application.OnIdle := nil;
//    Application.ProcessMessages; //20170417 Igor
  end;
  inc(FUpdate);
end;

procedure TLetterEditor.ShowHint(Sender: TObject);
begin
  // show hint in the status bar message panel
 { StatusBar.Panels[sbpMessage].Text := Application.Hint;}
end;

procedure TLetterEditor.CheckCapslock;
begin
 (*
  // show status in caps panel
  if Odd (GetKeyState (VK_CAPITAL)) then
    StatusBar.Panels[sbpCaps].Text := 'CAPS'
  else
    StatusBar.Panels[sbpCaps].Text := '';
 *)
end;

procedure TLetterEditor.TimerTimer(Sender: TObject);
begin
  CheckCapslock;
end;

procedure TLetterEditor.ControlBarLowerDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
  {ControlBarLower.BevelKind := bkTile;}
end;

procedure TLetterEditor.ControlBarLowerUnDock(Sender: TObject;
  Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin
 {
  if ControlBarLower.DockClientCount = 1 then
    ControlBarLower.BevelKind := bkNone;}
end;

procedure TLetterEditor.ControlBarLowerDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := Source.Control is TToolbar;
end;



procedure TLetterEditor.EndUpdate; //20170410 Igor
begin
  Dec(FUpdate);
  if FUpdate <= 0 then
  Begin
    RichEdit1.Lines.EndUpdate;
    RichEdit1.OnSelectionChange := RichEdit1SelectionChange;
    RichEdit1.OnChange := RichEdit1Change;
    RichEdit1.Visible := True;
    RichEdit1.ReadOnly := False; //20170417 Igor
    GroupBox1.Visible := True;
    Application.OnIdle := FOldAppOnIddle;
  End;
end;

procedure TLetterEditor.ExitBtnClick(Sender: TObject);
begin
 ExitExecute(Sender);
end;

(*//20170410 igor >>>
procedure TLetterEditor.FormPaint(Sender: TObject);
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

  case MyApp.LicenseLevel of
  llHome,llLimited,llLimEfile,llStd: LogoBtn.Enabled := False;
  end;
  //If MyApp.LicenseLevel in [llHome,llStd]+anyLimited then  LogoBtn.Enabled := False;
end;*)

procedure TLetterEditor.InsertKeyWBtnClick(Sender: TObject);
Var
  //i:Integer;
  SelectedString: string;
begin
 If Not InDesign then exit;
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := 'Key Words';
 {LoadDataDict;}
 SelectedString := PopSomeList(DataDict,SomeCaption);
 If SelectedString > '' then
 begin
    If InputBox('Input Box',
    'If Keyword is part of a If statement, enter N', 'Y') = 'Y' then
     RichEdit1.SelText := '['+SelectedString+']'+' '
    else
     RichEdit1.SelText := SelectedString+' ';
    Modified:=True;
    //LoadDataDict;
 end;
 HighLightKeyWords();
end;

procedure TLetterEditor.FileListBox1Click(Sender: TObject); //20170410 Igor
var
  s: string;
begin
  BeginUpdate;
  try
    if not InDesign then
      exit;
    if (Modified = False) or ((Modified = True and (MessageDlg('Letter Changed. Save it?', mtInformation, [mbYes, mbNo], 0) = mrNo))) then
    begin
      FileName := FileListBox1.Items[FileListBox1.ItemIndex];
      if FileName > '' then
      begin
        LoadTemplate(TemplateDir + '\' + FileName);
        s := ValidateLetter();
        if s > '' then
        begin
          //ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
          GoToKeyWInError(s);
          exit;
        end;
      end;
    end;
    RichEdit1.SelStart := 0;
    RichEdit1.SelLength := 0;
  finally
    EndUpdate;
  end;
end;

Procedure TLetterEditor.LoadTemplate(FlName:String); //20170410 Igor
begin
  BeginUpdate;
  try
    RichEdit1.LoadFromFile(FlName);
    HighLightKeyWords();
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
  finally
    EndUpdate;
  end;

end;

procedure TLetterEditor.TemplateTypeBoxClick(Sender: TObject);
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

procedure TLetterEditor.LetterHeadBoxClick(Sender: TObject);
//Var i:Integer;
begin
 (*
 If LetterheadBox.Checked then
 begin
  RichEdit1.SelStart :=0;
  For i:=1 to 6 do RichEdit1.SelText := '\par'+Chr(13);
 end;
 *)
end;

procedure TLetterEditor.Savespecificallyforthisclient1Click(Sender: TObject);
Var s:String;
begin
If RetInMem(CurrentApp) = 0 then  //20161216 Igor
 begin
  ShowMessage('You must open a return first');
  exit;
 end;
 If not InDesign then exit;

 s:=ValidateLetter();
 if S>'' then
 begin
  ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
  GoToKeyWInError(s);
  exit;
 end;

 //If ValidateLetter(RichEdit1) = false then exit;
 UnHighLightKeyWords; //(RichEdit1);
 //SaveDialog.FileName := GetClientLettersDir(MyApp)+'\'+MkClientLetterName(RetNo);
 SaveDialog.FileName := MkClientLetterName(RetNo, True);
 SaveDialog.DefaultExt := '*RTF';
 SaveAs;
 HighLightKeyWords; //(RichEdit1);
 TemplateTypeBoxClick(Sender);
 With RichEdit1 do
 begin
  SetFocus;
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
 end;

end;

procedure TLetterEditor.Deletethistemplate1Click(Sender: TObject);
begin

 If Not inDesign then exit;

if MessageDlg('Delete Letter '+FileName+'?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;

 If FileExists(TemplateDir+'\'+FileName) then
   SysUtils.DeleteFile(TemplateDir+'\'+FileName);
 TemplateTypeBoxClick(Sender);
end;

Procedure TLetterEditor.LoadTemplateList;
begin
 Case TemplateTypeBox.ItemIndex of
  -1: begin
      TemplateTypeBox.ItemIndex:=0;
      TemplateDir := MyApp.AppDir;
      FileListBox1.Mask := 'PaperFiledLetter.rtf;EfiledLetter.rtf;EngagementLetter.rtf;PIPEDALetter.rtf;CUSTINVLetter.rtf';
      end;
  0: begin
     TemplateDir := MyApp.AppDir;
     FileListBox1.Mask := 'PaperFiledLetter.rtf;EfiledLetter.rtf;EngagementLetter.rtf;PIPEDALetter.rtf;CUSTINVLetter.rtf';
     end;
  1: begin
     TemplateDir := GetClientLettersDir(MyApp);
     FileListBox1.Mask := '*.'+DefaultExtension;
  end;
  2: begin
      TemplateDir := MyApp.AppDir;
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

procedure TLetterEditor.ModeBoxClick(Sender: TObject);
begin
  If ModeBox.ItemIndex =0 then
  begin
   RichEdit1.Enabled := True;
   RichEdit1.Clear;
   If FileExists(TemplateDir+'\'+'tempWip') then
    RichEdit1.LoadFromFile(TemplateDir+'\'+'tempWip'); //20170410 igor 
   DesignMode :=True;
   Invalidate;
   Modified := False;
  end;
end;

procedure TLetterEditor.PreviewBtnClick(Sender: TObject); //20170410 Iogr
Var
  s: String;
  KeyWList: TStringList;
begin
  BeginUpdate;
  try
    If RetInMem(CurrentApp) = 0 then  //20161216 Igor
    begin
      ShowMessage('You must open a return with some data '+
                  Chr(13)+ 'before you can preview the letter');
      exit;
    end;



    KeyWList:=TStringList.Create;
    try
      If GetKeyWListfromRichEdit(DataDict, RichEdit1, KeyWList) = False then
      begin
        ShowMessage('Keyword opening and closing brackets are not in pairs');
        Exit;
      end;
    finally
      KeyWList.Free;
    end;
    s := ValidateLetter();
    if S > '' then
    begin
      ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
      GoToKeyWInError(s);
      exit;
    end;
    //RichEdit1.Visible := False;
    UnHighLightKeyWords();
    RichEdit1.Lines.SaveToFile(MyApp.AppDir+'\'+'NonInterpreted.rtf');  //un-interpter //20160819 Igor
    GetInterpetedRichEdit(RetNo,MyApp.AppDir+'\'+'NonInterpreted.rtf', RichEdit1);      //20160819 Igor
    //now ARichEdit has the interpreted
    RichEdit1.Lines.SaveToFile(TempLtrName);  //interpreted
    Preview();
    RichEdit1.Clear;
    RichEdit1.LoadFromFile(MyApp.AppDir+'\'+'NonInterpreted.rtf');
    Modified := False;
    HighLightKeyWords();
  finally
    EndUpdate;
    With RichEdit1 do
    begin
  //    Visible := True;
      SetFocus;
      SelStart := Perform(EM_LINEINDEX, 0, 0) ;
      SelLength:=0;
    end;
  end;
end;

//procedure TLetterEditor.Preview(ARichEdit:TRichEdit);
procedure TLetterEditor.Preview;
//Var i,j:integer;  AList: TstringList;txt :string; //ErrorC : boolean;
begin
  PreviewRichText(TempLtrName);
end;

procedure TLetterEditor.ComboFontChange(Sender: TObject);
begin
//20170410 igor >>>
  if FUpdate > 0 then
    exit;
//20170410 igor <<<
  If Not InDesign then exit;
end;

procedure TLetterEditor.Save1Click(Sender: TObject);
Var S:String;
begin
 If InDesign = false then exit;
 s:=ValidateLetter();
 if S>'' then
 begin
  ShowMessage('Keyword: '+s +' not in Data Dictionary. Please remove or replace');
  GoToKeyWInError(s);
  exit;
 end;
 UnHighLightKeyWords();
 RichEdit1.Visible:=False;
 SaveDialog.FileName := TemplateDir+'\'+Filename;

 SaveDialog.DefaultExt := '*.RTF';
 SaveDialog.InitialDir := TemplateDir;

 Save(TemplateDir+'\'+FileName);
 Modified := False;
 HighLightKeyWords();
 ShowTimedMsg('Saved',1200);
 With RichEdit1 do
 begin
  SetFocus;
  SelStart := Perform(EM_LINEINDEX, 0, 0) ;
  SelLength:=0;
 end;
end;


procedure TLetterEditor.LogoBtnClick(Sender: TObject);
//Var LogoName,IncludeLogo,LogoHeight,LogoWidth,LogoPosition:String;
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

procedure TLetterEditor.HelpBtnClick(Sender: TObject);
begin
  MyApp.HelpOnClientLetter;
end;

procedure TLetterEditor.DataDictBtnClick(Sender: TObject);
begin
 FixDbForm(MyApp.AppDir, DictDBLite, DictTableLite, dbtDataDict);//20150918 Igor    //redid in 20151010
// FixDbForm(MyApp.AppDir, DictTable, dbtDataDict);
 LoadDataDict;
end;

procedure TLetterEditor.ConvertLetterClick(Sender: TObject);
begin
 ConvertOldLetter(RichEdit1);
end;

procedure TLetterEditor.SlashToLeftBracketBtnClick(Sender: TObject);
begin
// ReplaceRtfDelimiters(RichEdit1,'\','[');
end;

procedure TLetterEditor.SlashToRightBracketBtnClick(Sender: TObject);
begin
// ReplaceRtfDelimiters(RichEdit1,']','\');
end;

procedure TLetterEditor.InsertGraphicBtnClick(Sender: TObject);
begin
 //RichEdit1.Execute;
 If Not InDesign then exit;
 With OpenPictureDialog1 do
 begin
  OpenPictureDialog1.InitialDir:=MyApp.AppDir;
  OpenPictureDialog1.Title:='Select a graphics file from any folder';
  If OpenPictureDialog1.Execute then
  begin
   If fileName>'' then
   begin
    RichEdit1.SelText := '[FImg ('+Chr(39)+FileName+Chr(39)+')]';
    HighLightKeyWords();
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



procedure TLetterEditor.SaveBtnClick(Sender: TObject);
begin
 If TemplateTypeBox.ItemIndex =1 then
   Savespecificallyforthisclient1Click(Sender)
 else
   Save1Click(Sender);
end;

procedure TLetterEditor.InsertFileBtnClick(Sender: TObject);
Begin
 If Not InDesign then exit;
 ShowFileViewer(MyApp);
end;

{$IFDEF unused}
procedure TLetterEditor.InsertFileIntoRtf(ARichEdit:TRichEdit;InPos:Integer;FileName:String);
begin
 RichEdit1.Lines.Clear;
 RichEdit1.LoadFromFile(FileName);//20170410 igor
 If UpperCase(ExtractFileExt(FileName))='.LTR' then
 begin
  ConvertOldLetter(RichEdit1);
 end;
 Modified:=True;
end;
{$ELSE}
{$ENDIF}

procedure TLetterEditor.PrintBtnClick(Sender: TObject);
var
  LetterName: string;
begin

 If RetInMem(CurrentApp) = 0 then  //20161216 Igor
 begin
  ShowMessage('You must open a return with some data '+
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
  If MainForm.PrintDialogItem.execute then
    RetList[RetNo].StartPrintForm({Retno,}'ALETTER',99);
 end;
end;

procedure TLetterEditor.LoadDataDict;
begin
{$IFDEF reload}
  DataDict := MyApp.LoadDataDict;
{$ELSE}
{$ENDIF}
end;

end.
