unit T2_2027datadictFrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  vtLabel,ExtCtrls,vtChild,T2_2027ChildWinNew,T2_2027Declare,T2_2027TrimStr,
  Buttons,vtForm
  {, vtScrollBox}; //20150622

type
  TDatadictFrmT2_2027 = class(TForm)
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
  DatadictFrmT2_2027: TDatadictFrmT2_2027;

implementation

{$R *.DFM}

procedure TDatadictFrmT2_2027.OpenFormBtnClick(Sender: TObject);
Var FName:String;AForm:TForm; DfmFileName:String;
begin
   FName:='INFO';
   AScrollBox.Align:=alClient;
   ReadComponentResFile(GetDfmFileName(FName), AScrollBox);
   //AForm.ScaleBy(120,100);
end;

end.
