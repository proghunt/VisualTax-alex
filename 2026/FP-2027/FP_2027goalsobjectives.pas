unit FP_2027goalsobjectives;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Menus,
  FP_2027TrimStr,FP_2027Declare,Buttons,StdCtrls,ComCtrls,ExtCtrls,

  rxRichEd; //20160819 Igor (Must be last)

type
  TGoalsObjectives = class(TForm)
    Panel3: TPanel;
    RichEdit1: TRichEdit;
    procedure CancelBtnClick(Sender: TObject);
    private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GoalsObjectives: TGoalsObjectives;

implementation

{$R *.DFM}

procedure TGoalsObjectives.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
