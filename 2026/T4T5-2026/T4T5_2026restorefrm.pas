unit T4T5_2026restorefrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,
  {$WARN UNIT_PLATFORM OFF}FileCtrl;{$WARN UNIT_PLATFORM ON} //20170612 Igor

type
  TRestoreFrmT4T5_2026 = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    Labelx: TLabel;
    LastBackupDirBox: TEdit;
    Label3: TLabel;
    LastDateTakenBox: TEdit;
    RestoreToDirBox: TEdit;
    OkBtn: TBitBtn;
    Exit: TBitBtn;
    procedure ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RestoreFrm: TRestoreFrmT4T5_2026;

implementation

{$R *.DFM}

uses T4T5_2026,T4T5_2026TrimStr,T4T5_2026Declare,vtTrimStr,vtShared;

procedure TRestoreFrmT4T5_2026.ExitClick(Sender: TObject);
begin
Close;
end;

procedure TRestoreFrmT4T5_2026.FormCreate(Sender: TObject);
//20170612 igor >>>
Var
  LastBackup: String;
  Age: TDateTime;
begin
  LastBackUp := optRec.LastBackUpDir;
  LastBackUpDirBox.Text := LastBackUp;
  if not FileAge(LastBackUp, Age) then
    LastDateTakenBox.Text := ''
  else
    LastDateTakenBox.Text := DateToStr(Age);
  RestoreToDirBox.Text := OptRec.Dir_Cur;
//20170612 igor <<<
end;

procedure TRestoreFrmT4T5_2026.OkBtnClick(Sender: TObject);
Var i:Integer;TempList:TstringList; DoneOk:Boolean;Dir:String;
begin
 //if MessageDlg('This will replace all data files with the ones from the last backup. Are you sure?',
  //  mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
 DoneOk:=False;
 Dir:=RestoreToDirBox.Text;
 If Not SysUtils.DirectoryExists(Dir) then SysUtils.ForceDirectories(Dir); //20170612 Igor
 TempList:=TstringList.Create;
 TempList:=GetFileList(LastBackUpDirBox.Text+'\','*.*');
 Screen.Cursor:=crHourGlass;
 For i:=0 to templist.count-1 do
 begin
  DoneOk:=False;
  If CopyFile(Templist[i],Dir+'\'+ExtractFileName(TempList[i])) = True then
   DoneOk:=True;
  end;
 Screen.Cursor:=crDefault;
 If DoneOk=True then
 begin
  ShowMessage('Data has been successfully restored from '+LastBackUpDirBox.Text);
 end
 Else
  ShowMessage('Restore failed!');
 TempList.Free;
 Close;
end;

end.
