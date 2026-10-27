unit T1_2026CopyFromDraftFrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,FileCtrl;

type
  TCopyFromDraftFrmT1_2026 = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    Labelx: TLabel;
    FromDirBox: TEdit;
    ToDirBox: TEdit;
    OkBtn: TBitBtn;
    Exit: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BitBtn1: TBitBtn;
    procedure ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyFromDraftFrm: TCopyFromDraftFrmT1_2026;

implementation

uses vtCommon,T1_2026,T1_2026TrimStr,T1_2026Declare,T1_2026main,vtTrimStr,
  vtShared;

{$R *.DFM}

procedure TCopyFromDraftFrmT1_2026.ExitClick(Sender: TObject);
begin
Close;
end;

procedure TCopyFromDraftFrmT1_2026.FormCreate(Sender: TObject);
Var LastBackup:String; intFileAge: LongInt;
begin
 If FromDirBox.Text='' then FromDirBox.Text:='C:\T1Draft'+RightStr(AppYear,2)+'\data';
 If ToDirBox.Text='' then ToDirBox.Text:=OptRec.Dir_Cur;
end;

procedure TCopyFromDraftFrmT1_2026.OkBtnClick(Sender: TObject);
Var i:Integer;TempList:TstringList; DoneOk:Boolean;Dir:String;
  ToDir,FromDir:String; TempList2:TStringList;
begin
 DoneOk:=False;
 FromDir:=FromDirBox.Text;
 ToDir:=ToDirBox.Text;
 If Not DirectoryExists(ToDir) then ForceDirectories(ToDir);
 TempList:=TstringList.Create;
 GetFileList(FromDirBox.text+'\','*.*',TempList); //20090131
 TempList2:=TstringList.Create;
 GetFileList(ToDirBox.text+'\','*.*',TempList2); //20090131
 //TempList:=GetFileList(OptRec.Dir_Cur+'\','*.*');
 Screen.Cursor:=crHourGlass;
 If Templist2.count>2 then
 begin
  TempList2.Free;
  ShowMessage('The production data directory does not seem to be empty. Copying not done');
  TempList.Free;
  Close;
 end
 Else
 begin
  For i:=0 to templist.count-1 do
  begin
   DoneOk:=False;
   If CopyFile(Templist[i],ToDir+'\'+ExtractFileName(TempList[i])) = True then
    DoneOk:=True;
   end;
  Screen.Cursor:=crDefault;
  If DoneOk=True then
  begin
 // SaveSingleOption('LastBackUpDir',Dir);
 // LoadOptionsFileToMem;
  ShowMessage('Draft returns were successfully created in '+ToDir);
  end
  Else
   ShowMessage('Copying failed!');
  TempList.Free;
  TempList2.Free;
  Close;
 end;
end;

procedure TCopyFromDraftFrmT1_2026.BitBtn1Click(Sender: TObject);
begin
 If ToDirBox.Text='' then ToDirBox.Text:=OptRec.Dir_Cur;
 MainFormT1.RecalculateandsaveALLtaxreturns1Click(Sender);
end;

end.
