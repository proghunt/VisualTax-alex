unit Uwarning;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,
  UDeclare,TrimStr;

type
  TWarning = class(TForm)
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ReviewBtn: TBitBtn;
    ExitBtn: TBitBtn;
    Label1: TLabel;
    RetNameLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    Procedure ListError(FrmNm: string; Elm : integer; ErrMsg:string);
    procedure ExitBtnClick(Sender: TObject);
   { Function CountDiagnostics(RetNo: integer):Integer;}
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Warning: TWarning;
  F1, F2, F3: TextFile; {to store error info}
implementation

{$R *.DFM}



Procedure TWarning.ListError(FrmNm: string; Elm : integer; ErrMsg:string);
Begin
  ListBox1.Items.Add(ErrMsg);
  ListBox2.Items.Add(FrmNm);
  ListBox3.Items.Add(IntToStr(Elm));
End;


procedure TWarning.FormCreate(Sender: TObject);
Var
Elm : integer; ErrMsg : string[60]; FrmNm : String[10];
begin
 RetNameLbl.Caption := GetReturnName(RetNo);
 RetNameLbl.Color := GetRetColor(RetNo);
 ListBox1.Clear;
 ListBox1.Items.LoadFromFile(AppDir+'\'+'FWMsg.Tmp');
 ListBox1.Refresh;
 ListBox1.ItemIndex := 0;
 ListBox2.Items.LoadFromFile(AppDir+'\'+'FWFrm.Tmp');
 ListBox3.Items.LoadFromFile(AppDir+'\'+'FWElm.Tmp');
end;

procedure TWarning.ExitBtnClick(Sender: TObject);
begin
Close;
end;



end.
