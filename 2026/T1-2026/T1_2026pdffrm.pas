unit T1_2026pdffrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,ShellApi,T1_2026Declare,T1_2026TrimStr,T1_2026PrSet;

type
  TPDFFrmT1_2026 = class(TForm)
    Panel3: TPanel;
    CancelBtn: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    FinePrintLbl: TLabel;
    Label1: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    //procedure OKBtnClick(Sender: TObject);
    procedure FinePrintLblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PDFFrm: TPDFFrmT1_2026;

implementation

{$R *.DFM}

uses T1_2026Main;

procedure TPDFFrmT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
 //PdfPrint:=False;
end;


procedure TPDFFrmT1_2026.FinePrintLblClick(Sender: TObject);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(Application.MainForm.Handle,'open','HTTP://www.fineprint.com',Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

end.
