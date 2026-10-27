unit FP_2027monitorplan;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,VCLTee.TeEngine,
  VCLTee.Series,StdCtrls,VCLTee.TeeProcs,VCLTee.Chart,ExtCtrls,Menus,FP_2027TrimStr,FP_2027Declare,
  Buttons,ComCtrls,

  rxRichEd; //20160819 Igor (Must be last)

type
  TMonitorPlan = class(TForm)
    Panel3: TPanel;
    RichEdit1: TRichEdit;
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MonitorPlan: TMonitorPlan;

implementation

{$R *.DFM}

procedure TMonitorPlan.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
