unit FP_2027datadictFrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  vtLabel,ExtCtrls,vtChild,Buttons;

type
  TDatadictFrmFP_2012 = class(TForm)
    Panel12: TPanel;
    vtLabel1: TvtLabel;
    Panel1: TPanel;
    OpenFormBtn: TBitBtn;
    procedure OpenFormBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DatadictFrm: TDatadictFrmFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027ChildWinNew,FP_2027Declare,FP_2027TrimStr,vtTrimStr,
  vtShared;

procedure TDatadictFrmFP_2012.OpenFormBtnClick(Sender: TObject);
Var FName:String;AForm:TForm; DfmFileName:String;
  AScrollBox: TvtScrollBox;
begin
   FName:='INFO';
   AScrollBox := TFormFP_2027.Create(self,0,0);
   AScrollBox.Parent := Panel1;
   AScrollBox.Align:=alClient;
   Try  //20101216
    ReadComponentResFile(GetDfmFileName(FName), AScrollBox);
    Except
     ShowMessage('Form '+FName + ' is damaged. Contact VisualTax');
    end;
   //AForm.ScaleBy(120,100);
end;

end.
