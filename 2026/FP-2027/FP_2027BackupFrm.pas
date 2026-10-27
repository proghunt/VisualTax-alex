unit FP_2027BackupFrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,FileCtrl,FP_2027Declare;

type
  TBackupFrmFP_2012 = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    Labelx: TLabel;
    LastBackupDirBox: TEdit;
    Label3: TLabel;
    LastDateTakenBox: TEdit;
    NewBackupDirBox: TEdit;
    OkBtn: TBitBtn;
    Exit: TBitBtn;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BackupFrm: TBackupFrmFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TBackupFrmFP_2012.ExitClick(Sender: TObject);
begin
Close;
end;

procedure TBackupFrmFP_2012.FormCreate(Sender: TObject);
Var LastBackup:String; intFileAge: LongInt;
begin
 LastBackUp:=optRec.LastBackUpDir;
 LastBackUpDirBox.Text:=LastBackUp;
 NewBackupDirBox.Text:=IncrementlastBackUpDir(LastBackUp, OptRec.BackUpDir); //20160602 Igor
// If LastBackup='' then
//  NewBackupDirBox.Text:=OptRec.BackUpDir+'\'+'Backup01'
// else
//  NewBackupDirBox.Text:=IncrementlastBackUpDir(LastBackUp);

 intFileAge := FileAge(LastBackUp);
 if intFileAge = -1 then
   LastDateTakenBox.Text:=''
  else
   LastDateTakenBox.Text:= DateToStr(FileDateToDateTime(intFileAge));
end;

procedure TBackupFrmFP_2012.OkBtnClick(Sender: TObject);
Var
//20160805 Igor >>>
//  i:Integer;
//  TempList:TstringList;
//  DoneOk:Boolean;
//  Dir:String;
  Err: String;
begin
  if BackUpData(OptRec.Dir_Cur, NewBackupDirBox.Text, Err) then
  Begin
    SaveSingleOption('LastBackUpDir',NewBackupDirBox.Text);
    LoadOptionsFileToMem;
    ShowMessage('Backup was successfully created as '+NewBackupDirBox.Text);
  End
  else
    ShowMessage('Backup failed! Error: '+Err);
// DoneOk:=False;
// Dir:=NewBackupDirBox.Text;
// If Not DirectoryExists(Dir) then ForceDirectories(Dir);
// TempList:=TstringList.Create;
// TempList:=GetFileList(OptRec.Dir_Cur+'\','*.*');
// Screen.Cursor:=crHourGlass;
// For i:=0 to templist.count-1 do
// begin
//  DoneOk:=False;
//  If CopyFile(Templist[i],Dir+'\'+ExtractFileName(TempList[i])) = True then
//   DoneOk:=True;
//  end;
// Screen.Cursor:=crDefault;
// If DoneOk=True then
// begin
//  SaveSingleOption('LastBackUpDir',Dir);
//  LoadOptionsFileToMem;
//  ShowMessage('Backup was successfully created as '+Dir);
// end
// Else
//  ShowMessage('Backup failed!');
// TempList.Free;
// Close;
//20160805 Igor <<<
end;

end.
