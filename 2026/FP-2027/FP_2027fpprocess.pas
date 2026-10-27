unit FP_2027fpprocess;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,VCLTee.TeEngine,
  VCLTee.Series,StdCtrls,VCLTee.TeeProcs,VCLTee.Chart,ExtCtrls,Menus,Buttons,FP_2027Declare,ComCtrls,//20150819 Igor
  OleCtrls,SHDocVw;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  TfpProcessFP_2012 = class(TForm)
    WebBrowser1: TWebBrowser;
    Panel3: TPanel;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    URLs: TComboBox;
    procedure NetWorthBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DispIncBtnClick(Sender: TObject);
    procedure WillBtnClick(Sender: TObject);
    procedure ColaBtnClick(Sender: TObject);
    procedure IdentBtnClick(Sender: TObject);
    procedure IncNeedsBtnClick(Sender: TObject);
    procedure InsBtnClick(Sender: TObject);
    procedure TaxSum1BtnClick(Sender: TObject);
    procedure TaxSum2BtnClick(Sender: TObject);
    procedure TaxPlannerBtnClick(Sender: TObject);
    procedure AssetsBtnClick(Sender: TObject);
    procedure LiabilitiesBtnClick(Sender: TObject);
    procedure DISABLTBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure FindAddress;
  public
    RetNo: integer;
  end;

var
  fpProcess: TfpProcessFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027DevelopActionPlan,FP_2027TrimStr,FP_2027Liabilities,
  FP_2027ChildWinNew,vtTrimStr,vtShared;

procedure TfpProcessFP_2012.NetWorthBtnClick(Sender: TObject);
begin
//ExecuteForm(TNetWort);
end;

procedure TfpProcessFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TfpProcessFP_2012.DispIncBtnClick(Sender: TObject);
begin
OpenForm(RetNo,GetFormNo('INVESTSTRATEGY'),0);
end;

procedure TfpProcessFP_2012.WillBtnClick(Sender: TObject);
begin
 OpenForm(RetNo,GetFormNo('WILLS'),0);
end;

procedure TfpProcessFP_2012.ColaBtnClick(Sender: TObject);
begin
 OpenForm(RetNo,GetFormNo('LIVINGEXP_1'),0);
end;

procedure TfpProcessFP_2012.IdentBtnClick(Sender: TObject);
begin
OpenForm(RetNo,GetFormNo('PROFILE'),0);
end;

procedure TfpProcessFP_2012.IncNeedsBtnClick(Sender: TObject);
begin
OpenForm(RetNo,GetFormNo('ANNINC'),0);
end;

procedure TfpProcessFP_2012.InsBtnClick(Sender: TObject);
begin
 OpenForm(RetNo,GetFormNo('INSNeed'),0);
end;

procedure TfpProcessFP_2012.TaxSum1BtnClick(Sender: TObject);
begin
 OpenForm(RetNo,GetFormNo('TXSUM_1'),0);
end;

procedure TfpProcessFP_2012.TaxSum2BtnClick(Sender: TObject);
begin
OpenForm(RetNo,GetFormNo('TXSUM_2'),0);
end;

procedure TfpProcessFP_2012.TaxPlannerBtnClick(Sender: TObject);
begin
 OpenForm(RetNo,GetFormNo('TAXPL_1'),0);
end;

procedure TfpProcessFP_2012.AssetsBtnClick(Sender: TObject);
begin
//ExecuteForm(TAssets);
end;

procedure TfpProcessFP_2012.LiabilitiesBtnClick(Sender: TObject);
begin
ExecuteForm(TLiabilities);
end;

procedure TfpProcessFP_2012.DISABLTBtnClick(Sender: TObject);
begin
OpenForm(RetNo,GetFormNo('DISABLT'),0);
end;

procedure TfpProcessFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
  AppDir := ExtractFilePath(Application.ExeName); {where the Exe is}
  URLs.Text := 'File://'+AppDir+'FpProcess.Htm';
   {d:\delphitests\htms\default.htm';}
  {URLs.Text := 'http://www.visualTax.com';}
  FindAddress;
end;

procedure TfpProcessFP_2012.FindAddress;
var
  Flags: OLEVariant;
begin
  Flags := 0;
  {UpdateCombo := True;}
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;


end.
