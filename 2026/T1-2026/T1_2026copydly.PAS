unit T1_2026copydly;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,Buttons;

type
  TCopyDlyT1_2026 = class(TForm)
    SourceFileBox: TEdit;
    Label1: TLabel;
    DestinationDirBox: TEdit;
    Label2: TLabel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyDly: TCopyDlyT1_2026;

implementation

{$R *.DFM}

uses vtMulti,vtCommon,T1_2026Declare,T1_2026TrimStr,T1_2026Logging,vtTrimStr,
  vtShared, T1_2026; //20170112 Igor

procedure TCopyDlyT1_2026.CancelBtnClick(Sender: TObject);
begin
exit;
end;

procedure TCopyDlyT1_2026.FormCreate(Sender: TObject);
begin
 SourceFileBox.Text := MkLogDirName(User.M_Office, User.Code)+'\'+
                       MkLogFileName(User.M_Office, User.Code);
 DestinationDirBox.Text := User.OverloadProperty[AppT1_2026, 'Br_Dir']; //20170112 Igor
   { 'G:\CashDay';}
end;

procedure TCopyDlyT1_2026.OkBtnClick(Sender: TObject);
begin
 If not FileExists(SourceFileBox.Text) then
 begin
  ShowMessage('File does not exist');
  SourceFileBox.SetFocus;
  exit;
 end;

 If not DirectoryExists(DestinationDirBox.Text) then
 begin
  ShowMessage('Destination directory does not exist');
  DestinationDirBox.SetFocus;
  exit;
 end;


 If FileExists(DestinationDirBox.Text+'\'
               +MkLogFileName(User.M_Office,User.Code)) then
 begin
  if MessageDlg('File exists in the destination directory. Replace it?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;
 end;

If CopyFile(SourceFileBox.Text,
    DestinationDirBox.text+'\'
    +MkLogFileName(User.M_Office,User.Code)) = false then
begin
 ShowMessage('File cannot be copied');
 exit;
end
else
 ShowMessage('File copied');
end;

end.
