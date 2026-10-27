unit TF_2026copymovefrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,FileCtrl;

type
  TCopyMoveFrmTF_2026 = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    Labelx: TLabel;
    FromDirBox: TEdit;
    ToDirBox: TEdit;
    CopyBtn: TBitBtn;
    Exit: TBitBtn;
    MoveBtn: TBitBtn;
    FileDescrLbl: TLabel;
    BrowseBtn: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BrowseFromBtn: TBitBtn;
    procedure ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure BrowseBtnClick(Sender: TObject);
    Function  IsValid(Dir:String):Boolean;
    procedure BrowseFromBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyMoveFrm: TCopyMoveFrmTF_2026;

implementation

{$R *.DFM}

uses TF_2026TrimStr,TF_2026Declare,TF_2026Main,vtTrimStr,vtShared;

procedure TCopyMoveFrmTF_2026.ExitClick(Sender: TObject);
begin
Close;
end;

procedure TCopyMoveFrmTF_2026.FormCreate(Sender: TObject);
Var LastBackup:String; intFileAge: LongInt;
begin
 FileDescrLbl.Caption:=SomeCaption;
 FromDirBox.Text:=SomeString;
 ToDirBox.Text:='A:\Data';
end;

procedure TCopyMoveFrmTF_2026.CopyBtnClick(Sender: TObject);
begin
 If IsValid(ToDirBox.Text)=False then
 begin
  ToDirBox.SetFocus;
  //exit;
 end;
 Screen.Cursor:=crHourGlass;
 SomeResult:=CopyMoveReturn('C',FromDirBox.Text,ToDirBox.Text,SomeFile);
 Screen.Cursor:=crDefault;
 Close;
end;

procedure TCopyMoveFrmTF_2026.MoveBtnClick(Sender: TObject);
begin
 If IsValid(ToDirBox.Text)=False then
 begin
  ToDirBox.SetFocus;
  //exit;
 end;
 Screen.Cursor:=crHourGlass;
 SomeResult:=CopyMoveReturn('M',FromDirBox.Text,ToDirBox.Text,SomeFile);
 Screen.Cursor:=crDefault;
 Close;
end;

procedure TCopyMoveFrmTF_2026.BrowseBtnClick(Sender: TObject);
Var DirSelected:String; //20150805 Igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   ToDirBox.Text:= DirSelected;
end;

Function TCopyMoveFrmTF_2026.IsValid(Dir:String):Boolean;
begin
 result:=True;
 If ((UpperCase(LeftStr(Dir,1)) = 'A') or (UpperCase(LeftStr(Dir,1)) = 'B'))
 and (Length(Dir) <4) then
 begin
  Result:=False;
  ShowMessage('We recommend you use a sub-directory after the drive letter, such as A:\Data');
 end;
end;

procedure TCopyMoveFrmTF_2026.BrowseFromBtnClick(Sender: TObject);
Var DirSelected:String;     //20150805 Igor
begin
if SelectDirectory('Select a folder:', '', DirSelected) then
   FromDirBox.Text:= DirSelected;
end;

end.
