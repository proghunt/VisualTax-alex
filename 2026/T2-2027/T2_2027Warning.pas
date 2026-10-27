unit T2_2027WARNING;
//imported 08-02

{ TODO : really show warnings }

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,vtMulti,vtCommon,T2_2027Declare,T2_2027Common,
  T2_2027Common2,T2_2027ChildWinNew,T2_2027TrimStr;

type
  TWarningT2_2027 = class(TForm)
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
    procedure ReviewBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
   { Function CountDiagnostics(RetNo: integer):Integer;}
  private
    RetNo: integer;
  public
    { Public declarations }
  end;


procedure Warning(RNo: integer);

implementation

{$R *.DFM}

procedure Warning(RNo: integer);
begin
  with TWarningT2_2027.Create(Application) do
  begin
    RetNo := RNo;
    ShowModal;
    Free;
  end;
end;

Procedure TWarningT2_2027.ListError(FrmNm: string; Elm : integer; ErrMsg:string);
Begin
  ListBox1.Items.Add(ErrMsg);
  ListBox2.Items.Add(FrmNm);
  ListBox3.Items.Add(IntToStr(Elm));
End;


procedure TWarningT2_2027.FormCreate(Sender: TObject);
Var
Elm : integer; ErrMsg, FrmNm : String;
begin
  RetNo := GetCurrentRetNo;
 RetNameLbl.Caption := GetRetName(RetNo);
 RetNameLbl.Color := GetRetColor(RetNo);
 ListBox1.Clear;
 ListBox1.Items.LoadFromFile(AppDir+'\'+'FWMsg.Tmp');
 ListBox1.Refresh;
 ListBox1.ItemIndex := 0;
 ListBox2.Items.LoadFromFile(AppDir+'\'+'FWFrm.Tmp');
 ListBox3.Items.LoadFromFile(AppDir+'\'+'FWElm.Tmp');
end;

procedure TWarningT2_2027.ExitBtnClick(Sender: TObject);
begin
Close;
end;

procedure TWarningT2_2027.ReviewBtnClick(Sender: TObject);
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

procedure TWarningT2_2027.ListBox1DblClick(Sender: TObject);
begin
ReviewBtnClick(Sender);
end;

end.
