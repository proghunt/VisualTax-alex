unit FP_2027copymovefrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,FileCtrl,FP_2027Declare;

type
  TCopyMoveFrmFP_2027 = class(TForm)
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
    procedure ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure BrowseBtnClick(Sender: TObject);
    Function  IsValid(Dir:String):Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CopyMoveFrm: TCopyMoveFrmFP_2027; //20160327 Igor

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,FP_2027Main,vtTrimStr,vtShared;

procedure TCopyMoveFrmFP_2027.ExitClick(Sender: TObject);
begin
Close;
end;

procedure TCopyMoveFrmFP_2027.FormCreate(Sender: TObject);
Var LastBackup:String; intFileAge: LongInt;
begin
 FileDescrLbl.Caption:=SomeCaption;
 FromDirBox.Text:=SomeString;
 ToDirBox.Text:='A:\Data';
end;

procedure TCopyMoveFrmFP_2027.CopyBtnClick(Sender: TObject);
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

procedure TCopyMoveFrmFP_2027.MoveBtnClick(Sender: TObject);
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

procedure TCopyMoveFrmFP_2027.BrowseBtnClick(Sender: TObject);
Var DirSelected: String; //20150817 igor
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
   ToDirBox.Text:= DirSelected;
end;

Function TCopyMoveFrmFP_2027.IsValid(Dir:String):Boolean;
begin
 result:=True;
 If ((UpperCase(LeftStr(Dir,1)) = 'A') or (UpperCase(LeftStr(Dir,1)) = 'B'))
 and (Length(Dir) <4) then
 begin
  Result:=False;
  ShowMessage('We recommend you use a sub-directory after the drive letter, such as A:\Data');
 end;
end;

end.
