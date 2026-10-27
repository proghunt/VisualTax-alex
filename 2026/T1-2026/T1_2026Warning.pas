unit T1_2026Warning;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons;

type
  TWarningT1_2026 = class(TForm)
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ReviewBtn: TBitBtn;
    ExitBtn: TBitBtn;
    Label1: TLabel;
    RetNameLbl: TLabel;
    SwapBtn: TBitBtn;
    procedure ShowErrors(RetNo:Integer);
    procedure FormCreate(Sender: TObject);
    Procedure ListError(FrmNm: string; Elm : integer; ErrMsg:string);
    procedure ExitBtnClick(Sender: TObject);
    procedure ReviewBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure SwapBtnClick(Sender: TObject);
   { Function CountDiagnostics(RetNo: integer):Integer;}
  private
    RetNo:Integer;
    //F1, F2, F3: TextFile; {to store error info}
  public
    { Public declarations }
  end;

//var  Warning: TWarningT1_2026;

procedure Warning(RNo: integer);

implementation

{$R *.DFM}

uses vtMulti,vtCommon,T1_2026Declare,T1_2026Common,T1_2026Common2,
  T1_2026ChildWinNEW,T1_2026TrimStr,T1_2026CntErr,T1_2026Main,vtTrimStr,
  vtShared;

procedure Warning(RNo: integer);
begin
  with TWarningT1_2026.Create(Application) do
  begin
    RetNo := RNo;
    ShowModal;
    Free;
  end;
end;


Procedure TWarningT1_2026.ListError(FrmNm: string; Elm : integer; ErrMsg:string);
Begin
  ListBox1.Items.Add(ErrMsg);
  ListBox2.Items.Add(FrmNm);
  ListBox3.Items.Add(IntToStr(Elm));
End;


procedure TWarningT1_2026.FormCreate(Sender: TObject);
 begin
  RetNo:=GetCurrentRetNo;
  ShowErrors(RetNo);
 end;


procedure TWarningT1_2026.ShowErrors(RetNo:Integer);
Var
Elm : integer; ErrMsg, FrmNm : String;
begin
 RetNameLbl.Caption := GetRetName(RetNo);
 RetNameLbl.Color := GetRetColor(RetNo);
 ListBox1.Clear;
 ListBox1.Items.LoadFromFile(AppDir+'\'+'FWMsg.Tmp');
 ListBox1.Refresh;
 ListBox1.ItemIndex := 0;
 ListBox2.Items.LoadFromFile(AppDir+'\'+'FWFrm.Tmp');
 ListBox3.Items.LoadFromFile(AppDir+'\'+'FWElm.Tmp');
end;


procedure TWarningT1_2026.ExitBtnClick(Sender: TObject);
begin
Close;
end;

procedure TWarningT1_2026.ReviewBtnClick(Sender: TObject);
var
  OpenAtFieldId: integer;
begin
If ListBox1.ItemIndex > -1 then
  Begin
   OpenAtFieldId := StrToInt(ListBox3.Items[ListBox1.ItemIndex]);
   OpenForm(RetNo,ListBox2.Items[ListBox1.ItemIndex],OpenAtFieldId);
   Close;
  end;
end;

procedure TWarningT1_2026.ListBox1DblClick(Sender: TObject);
begin
ReviewBtnClick(Sender);
end;

procedure TWarningT1_2026.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then ReviewBtnClick(Application);
end;

procedure TWarningT1_2026.SwapBtnClick(Sender: TObject);
begin
 If RetInMem=1 then
 begin ShowMessage('This is the only return in memory!');exit;end;
 MainFormT1.SwapReturns1Click(Sender);
 UpdateAllDataIndicators(RetNo);
 {PrepareForm; }
 SendMessage(Application.MainForm.Handle,WM_PAINT,0,0);
 CountDiagnostics(RetNo);
 ShowErrors(RetNo);
end;

end.
