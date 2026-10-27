unit T1_2026OpFlNm;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,ExtCtrls;

type
  TOpenFlNameT1_2026 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    FlNameBox: TEdit;
    DataDirBox: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    ShowSw: boolean; //to be set before ShowModal
    FlName : String;
  end;

var
  OpenFlName: TOpenFlNameT1_2026;

implementation

{$R *.DFM}

uses vtCommon,vtMain,T1_2026,T1_2026Declare,T1_2026Common,T1_2026Common2,
  T1_2026TrimStr,T1_2026ChildWinNEW,T1_2026CntErr,T1_2026Cpl,T1_2026Main,
  vtTrimStr,vtShared;

procedure TOpenFlNameT1_2026.FormCreate(Sender: TObject);
begin
  FlName := '';
  FlNameBox.Text := '';
  DataDirBox.Text := OptRec.Dir_Cur;
  ShowSw := true; //20161216 Igor
  DataDirBox.Enabled := not CheckIsCloud(true); //20181130 Igor
end;

procedure TOpenFlNameT1_2026.OKBtnClick(Sender: TObject);
var
  sin:String;
  RetNo:Integer;
begin
 Sin:=FlNameBox.Text;
 FlName := LeftStr(Sin,8)+'.'+RightStr(Sin,1);
  OpenReturnCoupled(DataDirBox.Text,FlName,ShowSw);
end;

procedure TOpenFlNameT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
