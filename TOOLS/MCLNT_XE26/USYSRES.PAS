unit Usysres;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Menus, ExtCtrls,
  frmAbout, TabNotBk, FileCtrl, Gauges,
  readme, VBXCtrl, Gauge;

type
  TfrmNmfiMain = class(TForm)
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label10: TLabel;
    Label15: TLabel;
    txtMathCo: TEdit;
    txtCPU: TEdit;
    txtPageMem: TEdit;
    txtWinMode: TEdit;
    txtWinVer: TEdit;
    txtDosVer: TEdit;
    GroupBox1: TGroupBox;
    gageGDI: TGauge;
    Label11: TLabel;
    gageUser: TGauge;
    Label12: TLabel;
    Label16: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    txtSysMem: TEdit;
    pnlWinDir: TPanel;
    pnlWinSysDir: TPanel;
    cmdCompact: TBitBtn;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Gauge1: TGauge;
    cbDrive: TDriveComboBox;
    txtDriveType: TEdit;
    txtDriveSize: TEdit;
    txtDriveFree: TEdit;
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    cbOnTop: TCheckBox;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbExitClick(Sender: TObject);
    procedure sbAboutClick(Sender: TObject);
    procedure cbDriveChange(Sender: TObject);
    procedure cmdCompactClick(Sender: TObject);
    procedure cbOnTopClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
    FileNeedsToBeSaved : BOOLEAN;
    FileName : string;
    AppTitle : string;

  public
    { Public declarations }
    procedure    GetSystemInformation;
    procedure    GetDiskInfo(szDisk : char);
    procedure    GetMemoryInformation;
  end;

var
  frmNmfiMain: TfrmNmfiMain;

implementation

{$R *.DFM}

procedure TfrmNmfiMain.GetDiskInfo(szDisk : char);
   function DriveType(ltr : char) : string;
   var d : integer;
   begin
   d := ord(UpCase(ltr)) - ORD('A');
   if d in [0..25] then
   begin
      d := GetDriveType(d);
      case d of
      DRIVE_REMOVABLE  : Result := 'Floppy Drive';
      DRIVE_FIXED      : Result := 'Hard Drive';
      DRIVE_REMOTE     : Result := 'CD or Network Drive';
      else Result := 'Unknown Drive Type';
      end; { case }
   end
   else
      Result := ltr + ' is a bad Drive letter.'
   end;
var    lReturn, Factor  :longint;
       aLabel           : string[2];
const  KB = 1024;
begin
     szDisk := (UpCase(szDisk));

     txtDriveType.text := DriveType(szDisk);

     lReturn := DiskSize( ord(szDisk) - ord('A') + 1 );
     if lReturn > (10 * (KB * KB)) then
     begin
          factor := (KB * KB);
          aLabel := 'MB';
     end
     else
     begin
         factor := kb;
         aLabel := 'KB';
     end;

     txtDriveSize.Text := IntToStr( lReturn div factor ) + alabel;
     Gauge1.MaxValue := lReturn div factor ;

     lReturn := DiskFree( ord(szDisk) - ord('A') + 1 );
     txtDriveFree.Text := IntToStr( lReturn div factor ) + alabel;
     Gauge1.Progress := lReturn  div factor ;

     Caption := AppTitle + ' - ' + IntToStr(Gauge1.PercentDone) + '% Free Disk Space';
     Application.Title := Caption;
end;

procedure TfrmNmfiMain.GetMemoryInformation;
begin
  { Global Heap }
  txtSysMem.Text := IntToStr(GetFreeSpace(0) DIV 1024) + 'K';
  { System Resources }
  Caption := AppTitle + ' - ' +
          IntToStr(GetFreeSystemResources(GFSR_SYSTEMRESOURCES)) + '% Free Resources';
  Application.Title := Caption;

  gageUSER.Progress := GetFreeSystemResources(GFSR_USERRESOURCES);
  gageGDI.Progress := GetFreeSystemResources(GFSR_GDIRESOURCES);
  
end;

procedure TfrmNmfiMain.GetSystemInformation;
var
   dwSysflags,
   dwAvailable,
   dwVersion           : longint;
   wDosVer, wWinVer    : WORD;
   b : array[0..144] of char;

begin
  Caption := AppTitle;
  Application.Title := Caption;

  { Win & DOS Versions }
  dwVersion := GetVersion;
  wWinVer := LoWord(dwVersion);
  txtWinVer.Text := IntToStr(LoByte(wWinVer)) + '.' + IntToStr(HiByte(wWinVer));
  wDosVer := HiWord(dwVersion);
  txtDosVer.Text := IntToStr(HiByte(wDosVer)) + '.' + IntToStr(LoByte(wDosVer));

  { WinFlags }
  dwSysFlags := GetWinFlags;

  if (dwSysFlags and WF_WIN386) = WF_WIN386 then txtWinMode.Text := '386 Enhanced'
  else txtWinMode.Text := 'Standard';

  if (dwSysFlags and WF_80x87) = WF_80x87 then txtMathCo.Text := 'Yes'
  else txtMathCo.Text := 'No';

  if (dwSysFlags and WF_Paging) = WF_Paging then txtPageMem.Text := 'Yes'
  else txtPageMem.Text := 'No';

  if (dwSysFlags and WF_CPU286) = WF_CPU286 then
      txtCPU.Text := '80286'
  else
  if (dwSysFlags and WF_CPU386) = WF_CPU386 then
      txtCPU.Text := '80386'
  else
  if (dwSysFlags and WF_CPU486) = WF_CPU486 then
      txtCPU.Text := '80486 or better'
  else        txtCPU.Text := 'unknown type';
{ Win directory locations }
  GetWindowsDirectory(b,sizeof(b));
  pnlWinDir.Caption := strpas(b);

  GetSystemDirectory(b,sizeof(b));
  pnlWinSysDir.Caption := strpas(b);
end;

procedure TfrmNmfiMain.Exit1Click(Sender: TObject);
begin
self.close;
end;

procedure TfrmNmfiMain.FormCreate(Sender: TObject);
begin
  FileNeedsToBeSaved := FALSE;
  FileName := '';
  AppTitle := Application.Title;
  self.top := (Screen.Height - self.height) div 4  ;
  self.left := (Screen.Width - self.Width) div 4 ;
  GetSystemInformation;
  GetDiskInfo(cbDrive.Drive);
  GetMemoryInformation;
end;

procedure TfrmNmfiMain.sbExitClick(Sender: TObject);
begin
self.Close;
end;

procedure TfrmNmfiMain.sbAboutClick(Sender: TObject);
var StayOnTop : boolean;
    f : TfrmNmfiAbout;
begin
 {
  StayOnTop := cbOnTop.Checked;
  if cbOnTop.Checked then cbOnTop.Checked := false;
  try
  f := TfrmNmfiAbout.Create(self);
  f.ShowModal;
  finally
  f.free;
  end;
  if StayOnTop then cbOnTop.Checked := True;
  }
end;


procedure TfrmNmfiMain.cbDriveChange(Sender: TObject);
begin
     GetDiskInfo(cbDrive.Drive);
end;

procedure TfrmNmfiMain.cmdCompactClick(Sender: TObject);
var mem : longint;
begin
  Screen.Cursor := crHourglass;
(*  mem := GlobalCompact(0); { how much is there to free? } *)
  mem := $ffffff;
  GlobalCompact(mem); { free it }
  GetMemoryInformation;
  Screen.Cursor := crDefault;
end;

procedure TfrmNmfiMain.cbOnTopClick(Sender: TObject);
begin
  if cbOnTop.checked then frmNmfiMain.FormStyle := fsStayOnTop
  else frmNmfiMain.FormStyle := fsNormal;
end;

procedure TfrmNmfiMain.SpeedButton1Click(Sender: TObject);
var f : TfrmReadMe;
begin
  try
  f := TfrmReadMe.Create(self);
  f.showmodal;
  finally
  f.Free;
  end;
end;

procedure TfrmNmfiMain.CancelBtnClick(Sender: TObject);
begin
self.Close;
end;

end.
