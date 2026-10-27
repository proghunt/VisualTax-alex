unit FP_2027pdffrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,ShellApi,FP_2027Declare;

type
  TPDFFrmFP_2012 = class(TForm)
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
  PDFFrm: TPDFFrmFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,FP_2027PrSet,FP_2027Main,vtTrimStr,vtShared;

procedure TPDFFrmFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
 //PdfPrint:=False;
end;


procedure TPDFFrmFP_2012.FinePrintLblClick(Sender: TObject);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(Application.MainForm.Handle,'open','HTTP://www.fineprint.com',Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

end.
