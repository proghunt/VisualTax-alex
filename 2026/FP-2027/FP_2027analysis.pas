unit FP_2027analysis;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,
  StdCtrls,ExtCtrls,Menus,FP_2027TrimStr,FP_2027Declare,
  Buttons,ComCtrls,

  rxRichEd; //20160819 Igor (Must be last)

  //20150817 igor


type
  TAnalysis = class(TForm)
    Panel3: TPanel;
    RichEdit1: TRichEdit;
    procedure CancelBtnClick(Sender: TObject);
    private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Analysis: TAnalysis;

implementation

{$R *.DFM}

procedure TAnalysis.CancelBtnClick(Sender: TObject);
begin
Close;
end;


end.
