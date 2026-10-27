unit FP_2027restorefrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,FileCtrl,FP_2027Declare;

type
  TRestoreFrmFP_2012 = class(TForm)
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
  RestoreFrm: TRestoreFrmFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TRestoreFrmFP_2012.ExitClick(Sender: TObject);
begin
Close;
end;

procedure TRestoreFrmFP_2012.FormCreate(Sender: TObject);
Var LastBackup:String; intFileAge: LongInt;
begin
 LastBackUp:=optRec.LastBackUpDir;
 LastBackUpDirBox.Text:=LastBackUp;

 intFileAge := FileAge(LastBackUp);
 if intFileAge = -1 then
   LastDateTakenBox.Text:=''
  else
   LastDateTakenBox.Text:= DateToStr(FileDateToDateTime(intFileAge));
 RestoreToDirBox.Text:=OptRec.Dir_Cur;
end;

procedure TRestoreFrmFP_2012.OkBtnClick(Sender: TObject);
Var i:Integer;TempList:TstringList; DoneOk:Boolean;Dir:String;
begin
 //if MessageDlg('This will replace all data files with the ones from the last backup. Are you sure?',
  //  mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
 DoneOk:=False;
 Dir:=RestoreToDirBox.Text;
 If Not DirectoryExists(Dir) then ForceDirectories(Dir);
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
