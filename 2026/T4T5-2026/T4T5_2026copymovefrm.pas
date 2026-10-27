unit T4T5_2026copymovefrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,
  {$WARN UNIT_PLATFORM OFF}FileCtrl;{$WARN UNIT_PLATFORM ON} //20170612 Igor

type
  TCopyMoveFrmT4T5_2026 = class(TForm)
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
  CopyMoveFrm: TCopyMoveFrmT4T5_2026;

implementation

{$R *.DFM}

uses T4T5_2026TrimStr,T4T5_2026Declare,T4T5_2026Main,vtTrimStr,vtShared;

procedure TCopyMoveFrmT4T5_2026.ExitClick(Sender: TObject);
begin
Close;
end;

procedure TCopyMoveFrmT4T5_2026.FormCreate(Sender: TObject);
Var LastBackup:String; intFileAge: LongInt;
begin
 FileDescrLbl.Caption:=SomeCaption;
 FromDirBox.Text:=SomeString;
 ToDirBox.Text:='A:\Data';
end;

procedure TCopyMoveFrmT4T5_2026.CopyBtnClick(Sender: TObject);
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

procedure TCopyMoveFrmT4T5_2026.MoveBtnClick(Sender: TObject);
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

procedure TCopyMoveFrmT4T5_2026.BrowseBtnClick(Sender: TObject);
Var DirSelected:String; //20150805 Igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   ToDirBox.Text:= DirSelected;
end;

Function TCopyMoveFrmT4T5_2026.IsValid(Dir:String):Boolean;
begin
 result:=True;
 If ((UpperCase(LeftStr(Dir,1)) = 'A') or (UpperCase(LeftStr(Dir,1)) = 'B'))
 and (Length(Dir) <4) then
 begin
  Result:=False;
  ShowMessage('We recommend you use a sub-directory after the drive letter, such as A:\Data');
 end;
end;

procedure TCopyMoveFrmT4T5_2026.BrowseFromBtnClick(Sender: TObject);
Var DirSelected:String;     //20150805 Igor
begin
if SelectDirectory('Select a folder:', '', DirSelected) then
   FromDirBox.Text:= DirSelected;
end;

end.
