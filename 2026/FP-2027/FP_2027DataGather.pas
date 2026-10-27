unit FP_2027DataGather;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,
  StdCtrls,ExtCtrls,Menus,FP_2027Declare,Buttons,ComCtrls,

  rxRichEd; //20160819 Igor (Must be last)

  //20150817 igor
  {UDevelopActionPlan,
  UNetWorth,UAssets,ULiabilities,ChildWin, ComCtrls, OleCtrls, SHDocVw;}

type
  TDataGatherFP_2012 = class(TForm)
    RichEdit1: TRichEdit;
    Panel3: TPanel;
    Panel1: TPanel;
    NewtBtn: TBitBtn;
    OpenBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
    procedure NewtBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataGather: TDataGatherFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,FP_2027Main,vtTrimStr,vtShared;

procedure TDataGatherFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TDataGatherFP_2012.NewtBtnClick(Sender: TObject);
begin
 FileNew;
 Close;
end;

procedure TDataGatherFP_2012.OpenBtnClick(Sender: TObject);
begin
 MainFormFP.FileOpenItemClick(Sender);
 Close;
end;

end.
