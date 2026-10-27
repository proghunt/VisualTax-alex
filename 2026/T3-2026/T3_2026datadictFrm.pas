unit T3_2026datadictFrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  vtLabel,ExtCtrls,vtForm,vtChild,Buttons;

type
  TDatadictFrmT3_2026 = class(TForm)
    Panel12: TPanel;
    vtLabel1: TvtLabel;
    Panel1: TPanel;
    AScrollBox: TvtScrollBox;
    OpenFormBtn: TBitBtn;
    procedure OpenFormBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DatadictFrmT3_2026: TDatadictFrmT3_2026;

implementation

{$R *.DFM}

uses vtTrimStr,T3_2026ChildWinNew,T3_2026Declare,T3_2026TrimStr;

procedure TDatadictFrmT3_2026.OpenFormBtnClick(Sender: TObject);
Var FName:String;AForm:TForm; DfmFileName:String;
begin
   FName:='INFO';
   AScrollBox.Align:=alClient;
   ReadComponentResFile(GetDfmFileName(FName), AScrollBox);
   //AForm.ScaleBy(120,100);
end;

end.
