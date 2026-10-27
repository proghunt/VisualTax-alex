unit T3_2026pdffrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,ShellApi;

type
  TPDFFrmT3_2026 = class(TForm)
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
  PDFFrm: TPDFFrmT3_2026;

implementation

{$R *.DFM}

uses vtMain,T3_2026Declare,T3_2026TrimStr,T3_2026PrSet,T3_2026Main;

procedure TPDFFrmT3_2026.CancelBtnClick(Sender: TObject);
begin
Close;
 //PdfPrint:=False;
end;

procedure TPDFFrmT3_2026.OKBtnClick(Sender: TObject);
begin
 //PdfPrint:=True;
 //MainForm.PrintTemplates1Click(Sender);
 Close;
end;

procedure TPDFFrmT3_2026.FinePrintLblClick(Sender: TObject);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(MainForm.Handle,'open','HTTP://www.fineprint.com',Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

end.
