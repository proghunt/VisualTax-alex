unit FP_2027actionplan;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,VCLTee.TeEngine,
  VCLTee.Series,StdCtrls,VCLTee.TeeProcs,VCLTee.Chart,ExtCtrls,Menus,FP_2027TrimStr,FP_2027Declare,
  Buttons,ComCtrls,

  rxRichEd; //20160819 Igor (Must be last)

type
  TActionPlan = class(TForm)
    RichEdit1: TRichEdit;
    Panel3: TPanel;
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ActionPlan: TActionPlan;

implementation

{$R *.DFM}

procedure TActionPlan.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
