unit TF_2026pdffrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,ShellApi;

type
  TPDFFrmTF_2026 = class(TForm)
    Panel3: TPanel;
    OKBtn: TBitBtn;
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
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FinePrintLblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PDFFrm: TPDFFrmTF_2026;

implementation

{$R *.DFM}

uses vtMain,TF_2026Declare,TF_2026TrimStr,TF_2026PrSet,TF_2026Main;

procedure TPDFFrmTF_2026.CancelBtnClick(Sender: TObject);
begin
Close;
 //PdfPrint:=False;
end;

procedure TPDFFrmTF_2026.OKBtnClick(Sender: TObject);
begin
 //PdfPrint:=True;
 //MainForm.PrintTemplates1Click(Sender);
 Close;
end;

procedure TPDFFrmTF_2026.FinePrintLblClick(Sender: TObject);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(MainForm.Handle,'open','HTTP://www.fineprint.com',Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

end.
