unit FP_2027import;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,ExtCtrls,Buttons,Grids,DB,DBGrids, VCLTee.TeeProcs,
  VCLTee.TeEngine, VCLTee.Chart;

  type
  TImport = class(TForm)
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    LastYearDirBox: TEdit;
    Label3: TLabel;
    ThisYearDirBox: TEdit;
    Image1: TImage;
    AllBtn: TBitBtn;
    RetCntLabel: TLabel;
    Chart1: TChart;
    Label4: TLabel;


   // Function LastYearDirExists(S:string):Boolean;
    procedure CalcImported(RetNo:Integer);
   // Function ValidDirectories:Boolean;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure AllBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Import: TImport;
  FlName: string; //[60];
  {RetNo : integer;}
  Cnt   : integer;
  InitialRowCount :integer;

implementation

{$R *.DFM}
uses
  vtCommon,
  FP_2027,FP_2027Common,FP_2027Declare,FP_2027Common2,FP_2027TrimStr,
  FP_2027ChildWinNew,FP_2027Calc,FP_2027Main,vtTrimStr,vtShared;

procedure TImport.FormCreate(Sender: TObject);
Var slash :string; //[1];
begin
 LastYearDirBox.Text:='C:\FPClients10';
 ThisYearDirBox.Text:='C:\FPClients11';
 //20180503 Igor >>>
 if CheckIsCloud(true) then
    LastYearDirBox.Enabled := False;
 //20180503 Igor <<<
end;

procedure TImport.CalcImported(RetNo:Integer);
Var i ,SlipCode: integer;
begin
 Calc(RetNo,'PAGE_1');
 CalcAll(RetNo);
end;

procedure TImport.CancelBtnClick(Sender: TObject);
begin
Close;
end;


procedure TImport.AllBtnClick(Sender: TObject);
Var i,j,FNo: integer; Sin : string;Msg:string;
  PrPStatus,EfStatus,Notes:String;
LastYrDir:string; //[60];
begin
 If AppFP.CountReturnsInDB > 0 then//20170901 Igor
 begin
  if MessageDlg('This year'+Chr(39)+'s FP Clients DataBase already contains data'
  +Chr(13)+'If you proceed the existing data will be lost. Proceed?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  Begin
   if MessageDlg('Are you sure you only want to keep last year'+Chr(39)+'s plans?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    //proceed
  end
  else
   Exit;
 end;

 If Not FileExists(LastYearDirBox.text+'\'+'FpClients.mdb') then
 begin
  ShowMessage('The folder '+LastYearDirBox.text +' does not have a FP Clients Data Base');
  Exit;
 end;

 If Not FileExists(ThisYearDirBox.text+'\'+'FpClients.mdb') then
 begin
  ShowMessage('The folder '+ThisYearDirBox.text +' does not have a FP Clients Data Base');
  Exit;
 end;

 If CopyFile(LastYearDirBox.text+'\'+'FpClients.mdb',ThisYearDirBox.text+'\'+'FpClients.mdb') then
  ShowMessage('Import done')
 else
  ShowMessage('Import Failed');
end;

procedure TImport.BitBtn1Click(Sender: TObject);
begin
ShowHelp('FpHelp','Conversion');
end;

end.
