unit T2_2027restorefrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,FileCtrl;

type
  TRestoreFrmT2_2027 = class(TForm)
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
  RestoreFrm: TRestoreFrmT2_2027;

implementation

{$R *.DFM}

uses T2_2027,T2_2027TrimStr,T2_2027Declare,vtTrimStr,vtShared;

procedure TRestoreFrmT2_2027.ExitClick(Sender: TObject);
begin
Close;
end;

procedure TRestoreFrmT2_2027.FormCreate(Sender: TObject);
Var LastBackup:String; intFileAge: LongInt;
    aDT: TDateTime;
begin
 LastBackUp:=optRec.LastBackUpDir;
 LastBackUpDirBox.Text:=LastBackUp;

 //intFileAge := FileAge(LastBackUp);

 if not(FileAge(LastBackup, aDT)) then //20150702
   LastDateTakenBox.Text:=''
  else
   LastDateTakenBox.Text:= DateToStr(aDT); // FileDateToDateTime(intFileAge)); //20150702
 RestoreToDirBox.Text:=OptRec.Dir_Cur;
end;

procedure TRestoreFrmT2_2027.OkBtnClick(Sender: TObject);
Var i:Integer;TempList:TstringList; DoneOk:Boolean;Dir:String;
begin
 //if MessageDlg('This will replace all data files with the ones from the last backup. Are you sure?',
  //  mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
 DoneOk:=False;
 Dir:=RestoreToDirBox.Text;
 If Not SysUtils.DirectoryExists(Dir) then SysUtils.ForceDirectories(Dir); //20150702
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
