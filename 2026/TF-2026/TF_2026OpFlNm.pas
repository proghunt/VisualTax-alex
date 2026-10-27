unit TF_2026OpFlNm;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons;

type
  TOpenFlNameTF_2026 = class(TForm)
    Label1: TLabel;
    FlNameBox: TEdit;
    Label2: TLabel;
    DataDirBox: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OpenFlName: TOpenFlNameTF_2026;
  FlName : String;

implementation

{$R *.DFM}

uses vtCommon,TF_2026,TF_2026Declare,TF_2026Common,TF_2026Common2,
  TF_2026TrimStr,TF_2026ChildWinNew,vtTrimStr,vtShared;

procedure TOpenFlNameTF_2026.FormCreate(Sender: TObject);
begin
  FlName := '';
  FlNameBox.Text := '';
  DataDirBox.Text := OptRec.Dir_Cur;
end;

procedure TOpenFlNameTF_2026.OKBtnClick(Sender: TObject);
var RetNo:Integer;
begin
 FlName := FlNameBox.Text;
 If IsRetInMemory(FlName) then
 begin
  if MessageDlg('Return is already in memory.'+chr(13)+'Create duplicate copy?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;
 end;

 If Length(FlName) = 9 then FlName := LeftStr(FlName,8)+'.'+RightStr(FlName,1);
 If FlName = '' then
  begin
  ShowMessage('You must specify a File Name');
  FlNameBox.SetFocus;
  Exit;
  End;
If DirectoryExists(DataDirBox.Text) = False then
  begin
   ShowMessage('Directory does not exist');
   DataDirBox.SetFocus;
   Exit;
  End;
 RetNo:=OpenReturn(DataDirBox.Text,FlName,True);
 If RetNo < 1 then
   Close;
end;

procedure TOpenFlNameTF_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
