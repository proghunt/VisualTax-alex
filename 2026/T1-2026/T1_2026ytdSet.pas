unit T1_2026ytdSet;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,T1_2026Declare,T1_2026TrimStr;

type
  TYTDSetUpT1_2026 = class(TForm)
    YtdDirBox: TEdit;
    Label1: TLabel;
    DayDirBox: TEdit;
    Label2: TLabel;
    CancelBtn: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    SaveBtn: TBitBtn;
    Label15: TLabel;
    Label16: TLabel;
    procedure FormCreate(Sender: TObject);
    Function EditDirectories:Boolean;
    procedure SaveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  YTDSetUp: TYTDSetUpT1_2026;

implementation

{$R *.DFM}

procedure TYTDSetUpT1_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 If FileExists(AppDir+'\'+'YtDSetUp.CFG') then
 begin
  TempList := TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'YtDSetUp.CFG');
  YtdDirBox.Text := TempList[0];
  DayDirBox.Text := TempList[1];
 end
 else
 begin
 YtdDirBox.Text := 'C:\CashYtd';
 DayDirBox.Text := 'C:\CashDay';
 end;
end;

Function TYTDSetUpT1_2026.EditDirectories:Boolean;
begin
 Result := False;
 If not DirectoryExists(DayDirBox.Text) then
 begin
  if MessageDlg('Daily Directory does not exist. Create it?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit
  else
  begin
    {$I-}   {so that the ioresult can be effective}
    MkDir(DayDirBox.Text);
    if IOResult <> 0 then
    begin
      ShowMessage('Daily Directory cannot be created');
      exit;
    end;
  end; {proceed with dir}
 end; {does not exist}

 If not DirectoryExists(YTDDirBox.Text) then
 begin
  if MessageDlg('YTD Directory does not exist. Create it?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit
  else
  begin
    {$I-}   {so that the ioresult can be effective}
    MkDir(YTDDirBox.Text);
    if IOResult <> 0 then
    begin
      ShowMessage('YTD Directory cannot be created');
      exit;
    end;
  end; {proceed with dir}
 end; {does not exist}

 {$I-}   {so that the ioresult can be effective}
 If not DirectoryExists(YTDDirBox.Text+'\'+'CashHist') then
 begin
  MkDir(YTDDirBox.Text+'\'+'CashHist');
  if IOResult <> 0 then
   begin
    ShowMessage('Daily history directory cannot be created');
    exit;
   end;
 end;
  Result := true;

end;


procedure TYTDSetUpT1_2026.SaveBtnClick(Sender: TObject);
Var FYtd :TextFile; YtDFile:string; //[60];
TempList :TstringList;
begin
If EditDirectories = true then
begin
 YtdFile  := YtdDirBox.Text+'/'+'CashYtd';
 AssignFile(FYtd, YtDFile);
 Rewrite(FYtD);  {initializethe Ytd file}
 TempList :=TstringList.Create;
 TempList.Add(YtdDirBox.text);
 TempList.Add(DayDirBox.text);
 TempList.SaveToFile(AppDir+'\'+'YtDSetup.cfg');
 TempList.Free;
 ShowMessage('Set-up completed');
end;
end;

end.
