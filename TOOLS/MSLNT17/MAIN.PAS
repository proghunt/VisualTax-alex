unit Main;
(*
{Null terminated strings and pointer to a string
 Var ZString := Array[0..80] of Char;
     PZString : Pchar;
  Begin
    PZString := StrPCopy(ZString,anyPascalString);
*)
interface  

uses WinTypes,FileCtrl, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ShellApi,
   Grids, Calendar, ColorGrd, Gauges, DBTables,Printers,
  UDeclare,TrimStr,Uabout,
  UTimedMsg,//Upoplist,
  UWarning, UFixDb,
  {Report,} UUsers, UTips,
  UMPswd,
  Spin, UProgres,
  UClients,UReadEMail; {UMclnt;}
  

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    FileCloseItem: TMenuItem;
    Window: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    OpenDialog: TOpenDialog;
    Edit: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    ToolBar: TPanel;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    Forms: TMenuItem;
    N2: TMenuItem;
    ImportLastYear: TMenuItem;
    Clearcurrentform: TMenuItem;
    SelectForm: TMenuItem;
    Options1: TMenuItem;
    Print1: TMenuItem;
    Utilities: TMenuItem;
    Help2: TMenuItem;
    N14: TMenuItem;
    Preparer: TMenuItem;
    PrinterSetup: TMenuItem;
    PrintDialogItem: TPrintDialog;
    OptionsBtn: TSpeedButton;
    CloseBtn: TSpeedButton;
    AboutPanel: TPanel;
    StatusBar: TPanel;
    NetIncBfrLabel: TLabel;
    TxblIncLabel: TLabel;
    NetIncBfrPanel: TPanel;
    TxblIncPanel: TPanel;
    BalancePanel: TPanel;
    ColorDialog1: TColorDialog;
    PrintForm1: TMenuItem;
    CreateDataDirectory1: TMenuItem;
    N13: TMenuItem;
    N19: TMenuItem;
    TipsBtn: TSpeedButton;
    N24: TMenuItem;
    N25: TMenuItem;
    ShowCellNumbers1: TMenuItem;
    DataDirectories1: TMenuItem;
    Operational1: TMenuItem;
    ChangeDataDirectory1: TMenuItem;
    VTaxPanel: TPanel;
    Label20: TLabel;
    Label19: TLabel;
    ProgramIcon: TImage;
    Switchforms1: TMenuItem;
    N31: TMenuItem;
    Calculator1: TMenuItem;
    Appointments2: TMenuItem;
    PrintManager1: TMenuItem;
    CurrentPage1: TMenuItem;
    Image1: TImage;
    Label2: TLabel;
    Label1: TLabel;
    BalanceLbl: TLabel;
    TotIncLabel: TLabel;
    TotIncPanel: TPanel;
    NetIncAftLabel: TLabel;
    NetIncAftPanel: TPanel;
    N6: TMenuItem;
    Label4: TLabel;
    OpenEmpl: TMenuItem;

    AdminBtn: TSpeedButton;
    N1: TMenuItem;
    SpeedButton1: TSpeedButton;
    BitBtn1: TBitBtn;

    Function ButtonInactive:Boolean;
    procedure WindowCascadeItemClick(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure WindowTileItemClick(Sender: TObject);
    procedure WindowArrangeItemClick(Sender: TObject);
    //procedure FileOpenItemClick(Sender: TObject);
    procedure CutItemClick(Sender: TObject);
    procedure CopyItemClick(Sender: TObject);
    procedure PasteItemClick(Sender: TObject);
    procedure MinimizeAllClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RestoreAllClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PrinterSetupClick(Sender: TObject);


    procedure TileBtnClick(Sender: TObject);
    procedure CascadeBtnClick(Sender: TObject);
    procedure MiniBtnClick(Sender: TObject);
    procedure RestoreBtnClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);

    procedure AboutPanelClick(Sender: TObject);


    procedure Calendar1Click(Sender: TObject);
    procedure Appointments1Click(Sender: TObject);
    procedure CreateDataDirectory1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure DataDictionary1Click(Sender: TObject);
    procedure ShowCellNumbers1Click(Sender: TObject);
    procedure UserSetUp1Click(Sender: TObject);

    procedure TipsBtnClick(Sender: TObject);
    procedure Tips1Click(Sender: TObject);

    procedure CopyForm1Click(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure ImportLastYearClick(Sender: TObject);

    procedure ShowWarnings;

    procedure UserSetUp2Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure Calculator1Click(Sender: TObject);
    procedure Appointments2Click(Sender: TObject);

    procedure Contents2Click(Sender: TObject);
    procedure SearchForHelpOnClick(Sender: TObject);
    procedure MenuHelpItenClick(Sender: TObject);
    procedure Allforms1Click(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure FileExitItemClick(Sender: TObject);


  private
    { Private declarations }
    {procedure CreateMDIChild(Formno: integer);}
    procedure ShowHint(Sender: TObject);

  public
    { Public declarations }

  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}


Function TMainForm.ButtonInactive:Boolean;
begin
 If RetInMem <1 then
  Begin
  Result := True;
  ShowMessage('You must open a return first');
  end
 Else
  Result := false;
end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
 { StatusLine.Caption := Application.Hint;}
end;


procedure TMainForm.ShowWarnings;
begin
    Application.CreateForm(TWarning,Warning);
    Warning.ShowModal;
    Warning.Free;
    exit;
end;


procedure TMainForm.CutItemClick(Sender: TObject);
begin
  {cut selection to clipboard}
end;

procedure TMainForm.CopyItemClick(Sender: TObject);
begin
  {copy selection to clipboard}
end;

procedure TMainForm.PasteItemClick(Sender: TObject);
begin
  {paste from clipboard}
end;


procedure TMainForm.WindowTileItemClick(Sender: TObject);
begin
  Tile;
  {ReOpenForm(RetNo,ActiveHandle);}

end;

procedure TMainForm.WindowCascadeItemClick(Sender: TObject);
Var CurHandle : Thandle;
begin
  Cascade;
  {ReOpenForm(RetNo,ActiveHandle);}

end;

procedure TMainForm.WindowArrangeItemClick(Sender: TObject);
begin
  ArrangeIcons;

end;

procedure TMainForm.MinimizeAllClick(Sender: TObject);
var
  I: Integer;
begin
  { Must be done backwards through the MDIChildren array }
  for I := (MainForm.MDIChildCount - 1) downto 0 do
      MainForm.MDIChildren[I].WindowState := wsMinimized;

end;



procedure TMainForm.UpdateMenuItems(Sender: TObject);
Var i,SectionLeft :integer;
begin
  OpenBtn.Enabled := RetInMem <1;
  {
  T4Btn.Enabled := (EmployerNo > '');
  T4ABtn.Enabled := (EmployerNo > '');
  T5Btn.Enabled := (EmployerNo > '');
  }
  AboutPanel.Visible := RetInMem =0;
  {invisible page buttons}
  Forms.Enabled := retInMem >0;
  CutItem.Enabled := MDIChildCount > 0;
  WindowCascadeItem.Enabled := MDIChildCount > 0;
  WindowTileItem.Enabled := MDIChildCount > 0;
  WindowArrangeItem.Enabled := MDIChildCount > 0;
  {MinimizeAll.Enabled := MDIChildCount > 0;}
  Screen.Cursor := crDefault;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
end;


procedure TMainForm.RestoreAllClick(Sender: TObject);
var
i : Integer;
CurHandle : Thandle;
begin
   for i :=0 to (FormList.Count - 1) do
   begin
        FormRec := FormList.Items[i];
        if IsIconic(FormRec^.FormHandle) then
           ShowWindow(FormRec^.FormHandle,SW_SHOWNORMAL);
   end;

end;


procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

If Key = VK_F1 then
  
end;

  (*
function ShellExecute(Wnd: HWnd; Operation, FileName, Parameters,
  Directory: PChar; ShowCmd: Integer): THandle;

The ShellExecute function opens or prints the specified file.

Parameter	Description

Wnd	The parent window. This window receives any message boxes an
application produces.
Operation	Points to a null-terminated string specifying the operation to perform. This
string can be "open" or "print". If this parameter is NIL, "open" is the
default value.
FileName	Points to a null-terminated string specifying the file to open.
Parameters	Points to a null-terminated string specifying parameters passed to the
application when the FileName parameter specifies an executable file. If
FileName points to a string specifying a document file, this parameter is
NIL.
Directory	Points to a null-terminated string specifying the default directory.
ShowCmd	Whether the application window is to be shown when the application is
opened. This parameter can be one of the following values:

Value	Meaning

SW_HIDE	Hides the window and passes
activation to another window.
SW_MINIMIZE	Minimizes the specified window and
activates the top-level window in the
system's list.
SW_RESTORE	Activates and displays a window. If the
window is minimized or maximized,
Windows restores it to its original size
and position (same as
SW_SHOWNORMAL).
SW_SHOW	Activates a window and displays it in
its current size and position.
SW_SHOWMAXIMIZED	Activates a window and displays it as
a maximized window.
SW_SHOWMINIMIZED	Activates a window and displays it as
an icon.
SW_SHOWMINNOACTIVE	Displays a window as an icon. The
window that is currently active remains
active.
SW_SHOWNA	Displays a window in its current state.
The window that is currently active
remains active.
SW_SHOWNOACTIVATE	Displays a window in its most recent
size and position. The window that is
currently active remains active.
SW_SHOWNORMAL	Activates and displays a window. If the
window is minimized or maximized,
Windows restores it to its original size
and position (same as
SW_RESTORE).

*)




procedure TMainForm.PrinterSetupClick(Sender: TObject);
begin
  PrintDialogItem.Execute;
end;



procedure TMainForm.TileBtnClick(Sender: TObject);
begin
WindowTileItemClick(Sender);
end;

procedure TMainForm.CascadeBtnClick(Sender: TObject);
begin
WindowCascadeItemClick(Sender);
end;

procedure TMainForm.MiniBtnClick(Sender: TObject);
begin
MinimizeAllClick(Sender);
end;

procedure TMainForm.RestoreBtnClick(Sender: TObject);
begin
RestoreAllClick(Sender);
end;

procedure TMainForm.AboutItemClick(Sender: TObject);
begin
Application.CreateForm(TAbout,About);
About.ShowModal;
About.Free;
end;


procedure TMainForm.AboutPanelClick(Sender: TObject);
begin
MainForm.Canvas.TextOut(10,500,'1255555');
end;




procedure TMainForm.Calendar1Click(Sender: TObject);
begin
GetCalendar;
end;

procedure TMainForm.Appointments1Click(Sender: TObject);
begin
(*
Application.CreateForm(TClientBook,ClientBook);
ClientBook.Visible := False;  {else it abends}
ClientBook.ShowModal;
ClientBook.Free;
*)
end;



procedure TMainForm.CreateDataDirectory1Click(Sender: TObject);
var
DataDir : string[60];
Result : integer;
ClickedOK: String;
begin
  DataDir := Appdir+'\Data';
  ClickedOk :=InputBox('Input Box', 'Prompt', 'DataDir');
  {
  InputQuery('Create Data Directory',
    'Enter Full path', DataDir);
    }
  if DataDir>'' then
   begin
      Result := MakeDataDirectory(DataDir);
      Case Result of
        0 : ShowMessage('Directory successfully created');
        -1: ShowMessage('Directory already exists!');
        -3: ShowMessage('Directory cannot be created');
      end;
      If CopyBlankDBFs(AppDir,DataDir) = False then
       ShowMessage('Some data bases existed already'+
       chr(13)+'or could not be initialized');
   end;
end;




(*

procedure TMainForm.RemovecurrentreturnOverridesClick(Sender: TObject);
Var I,FNo:integer;
begin
  If RetNo >0 then {RemoveRetOverrides(RetNo);}
  begin
   If OverList.Count =0 then exit;
   i :=0;
   Repeat
     OverRec := OverList.Items[i];
     if OverRec^.RetNo = RetNo then
       begin
       FNo := OverRec^.FormNo;
       OverList.Remove(OverRec);
       Calc(RetNo,GetFormName(FNo));
       CalcAll(RetNo);
       end
     else
      inc(i);
   until i > OverList.Count - 1;
   OverList.Pack;
  end;
  ChildWin.MyChild.FormPaint(Sender);
end;

procedure TMainForm.RemovecurrentfieldoverrideClick(Sender: TObject);
begin
 If (RetNo >0) and (FormNo >0) and (FieldId >0) then
  begin
   RemoveFieldOverride(RetNo,FormNo,FieldId);
   Calc(RetNo,FormName);
   CalcAll(RetNo);
   ChildWin.MyChild.FormPaint(Sender);
   {InvalidateRect(GetFormHandle(RetNo, FormNo),Nil,TRUE);}
  end;

end;

procedure TMainForm.SetCurrentFieldOverrideClick(Sender: TObject);
begin
 If (RetNo >0) and (FormNo >0) and (FieldId >0) then
    If IsAProtectedField(FormNo,FieldId) then
     SetFieldOverride(RetNo,FormNo,FieldId)
    else
     ShowMessage('You can only Override or Lock '+
     chr(13)+'Calculated and Linked fields');
end;

procedure TMainForm.Lockamountoncurrentfield1Click(Sender: TObject);
begin
If (RetNo >0) and (FormNo >0) and (FieldId >0) then
   SetFieldOverride(RetNo,FormNo,FieldId);
end;
*)
procedure TMainForm.SpeedButton6Click(Sender: TObject);
begin
{Modem1Click(Sender);}
end;



procedure TMainForm.DataDictionary1Click(Sender: TObject);
begin
 FixDbName := 'DataDict.dbf';
 Application.CreateForm(TFixDBForm,FixDBForm);
 FixDbForm.ShowModal;
 FixDbForm.Free;
end;







(*
Procedure TMainForm.GetFormsToPrint(RetNo:integer;Template:string;var FormsToPrint:TstringList;WhichFormType:string);
var i,j,FNo:integer;Copies :string[1];
    TemplList,TemplForms,TemplCopies:TstringList;
begin
 If not FileExists(AppDir+'\'+Template) then
  begin
   ShowMessage('Print Template: '+AppDir+'\'+Template+
             chr(13)+'does not exist');
   exit;
  end;
  TemplList:= TStringList.Create;
  TemplCopies:= TStringList.Create;
  TemplForms:= TStringList.Create;
  {split: templist has nFFFFFF where n=copies and FFFF=form without instance}
  TemplList.LoadFromFile(AppDir+'\'+Template);
  For i:=0 to TemplList.Count-1 do
   begin
     TemplCopies.Add(LeftStr(TemplList[i],1));
     TemplForms.Add(MidStr(TemplList[i],2,10));
   end;

  For i:=0 to FList.Count-1 do {run thru all forms available}
  begin
   FRec := FList.Items[i];
   FNo :=Frec^.FormNo;
   If Ret[RetNo]^.FrmHasData[FNo] then {has data and it is in template}
    If IsInList(Frec^.FormName,TemplForms) then
     If GetFormType(Frec^.FormName) = WhichFormType then
      FormsToPrint.Add(Frec^.FormName+Frec^.FormInst);
  end;
  {match and attach number of copies}
  For i:=0 to FormsToPrint.Count-1 do
   FormsToPrint[i]:=
    GetCopiesToPrint(FormsToPrint[i],TemplForms,TemplCopies)+FormsToPrint[i];

  TemplList.Free;
  TemplForms.Free;
  TemplCopies.Free;
end;
*)







procedure TMainForm.ShowCellNumbers1Click(Sender: TObject);
begin
 ShowCellNumbers1.Checked := not ShowCellNumbers1.Checked;
 ShowFieldIdSw := ShowCellNumbers1.Checked;
 If RetInMem >0 then
   {SendMessage(GetFormHandle(RetNo, FormNo),WM_PAINT,0,0);}
  InvalidateRect(GetFormHandle(RetNo, FormNo),Nil,TRUE);
 end;





procedure TMainForm.UserSetUp1Click(Sender: TObject);
begin
Application.CreateForm(TUserSetup,UserSetUp);
UserSetUp.ShowModal;
UserSetUp.Free;
end;


procedure TMainForm.TipsBtnClick(Sender: TObject);
begin
Tips1Click(Sender);
end;

procedure TMainForm.Tips1Click(Sender: TObject);
begin
Application.CreateForm(TTip,Tip);
Tip.ShowModal;
Tip.Free;

end;


procedure TMainForm.CopyForm1Click(Sender: TObject);
begin
 (*
 If ButtonInactive then exit;
 Application.CreateForm(TCopyFrm,CopyFrm);
 CopyFrm.ShowModal;
 CopyFrm.Free;
 *)
end;

procedure TMainForm.CopyBtnClick(Sender: TObject);
begin
CopyForm1Click(Sender);
end;


procedure TMainForm.ImportLastYearClick(Sender: TObject);
begin
If not FileExists(CfgRec.Dir_Cur+'\'+'EMPL.DBF') then
  begin
   ShowMessage('You must define a data directory first (Config)');
   exit;
end;

If RetInMem >0 then {otherwise it does not work!!!}
     MainForm.MDIChildren[0].WindowState := wsNormal;

(*
Application.CreateForm(TImportT4,ImportT4);
ImportT4.ShowModal;
ImportT4.Free;
*)
end;



procedure TMainForm.UserSetUp2Click(Sender: TObject);
begin
If StrToInt(LicenseLevel) = 3 then
 begin
   Application.CreateForm(TMPswd,MPswd);
   MPswd.ShowModal;
   MPswd.Free;
   If UpperCase(MasterPswd) <> 'RFCON2' then exit;
 end;
Application.CreateForm(TUserSetup,UserSetUp);
UserSetUp.ShowModal;
UserSetUp.Free;
end;

procedure TMainForm.HelpBtnClick(Sender: TObject);
begin
  Application.HelpFile := 'T4Help.HLP';
  Application.HelpCommand(HELP_CONTENTS, 0);

end;

procedure TMainForm.Calculator1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calc.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainForm.Appointments2Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calendar.Exe', Nil,
  Nil, SW_RESTORE);
end;


procedure TMainForm.Contents2Click(Sender: TObject);
begin
  Application.HelpFile := 'T1Help.HLP';
 {Application.HelpJump('After you file');}
 {Application.HelpContext(50);}
 Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TMainForm.SearchForHelpOnClick(Sender: TObject);
begin
 Application.HelpFile := 'T4Help.HLP';
 {Application.HelpJump('After you file');}
 Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TMainForm.MenuHelpItenClick(Sender: TObject);
begin
HelpBtnClick(Application);
end;



procedure TMainForm.Allforms1Click(Sender: TObject);
Var I:integer;
begin
 If ButtonInactive then exit;
 ShowFieldIdSw := True;
 If PrintDialogItem.Execute then
 begin
   for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If Frec^.FormNo > 0 then
      begin
      If FRec^.FormInst < '#2' then
       {ShowMessage(Frec^.FormName+Frec^.FormInst);}
        {? PrintForm(RetNo,Frec^.FormName+Frec^.FormInst,1)};
      end;
    end;
 end;
end;

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
Close;
end;

procedure TMainForm.FileExitItemClick(Sender: TObject);
begin
 Close;
end;

Initialization
 begin
  RY :=0; {Rate year = current year}
  AppDir := ExtractFilePath(Application.ExeName); {where the Exe is}
  AppDir := LeftStr(AppDir,Length(AppDir)-1); {Remove slash at end}
  Application.HelpFile := AppDir;

  AlreadyLogged:=False;
  InitParms;

  Application.CreateForm(TClients, Clients);
  Clients.ShowModal;
  Clients.Free;
  AlreadyLogged:=False;  //20141003
  If FileExists(AppDir+'\'+'DbInUse') then
   Sysutils.DeleteFile(AppDir+'\'+'DbInUse');
 end;
end.

