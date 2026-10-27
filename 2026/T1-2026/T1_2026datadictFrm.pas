unit T1_2026datadictFrm;
{ TODO : panel should contain TvtScrollBox (TvtForm) }
//    AScrollBox: TvtScrollBox;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  vtLabel,ExtCtrls,T1_2026Declare,Buttons;

type
  TDatadictFrmT1_2026 = class(TForm)
    Panel12: TPanel;
    vtLabel1: TvtLabel;
    Panel1: TPanel;
    OpenFormBtn: TBitBtn;
    procedure OpenFormBtnClick(Sender: TObject);
  private
    property AScrollBox: TPanel read Panel1;
  public
    { Public declarations }
  end;

var
  DatadictFrm: TDatadictFrmT1_2026;

implementation

{$R *.DFM}

uses vtCommon,vtChild,T1_2026TrimStr,T1_2026ChildWinNew,vtTrimStr,vtShared;

procedure TDatadictFrmT1_2026.OpenFormBtnClick(Sender: TObject);
Var FName:String;AForm:TForm; DfmFileName:String;
  AScrollBox: TvtScrollBox;
begin
   FName:='INFO';
   AScrollBox := TFormT1_2026.Create(self,0,0);
   AScrollBox.Parent := Panel1;
   AScrollBox.Align:=alClient;
   Try  //20101216
    ReadComponentResFile(GetDfmFileName(FName), AScrollBox);
    Except
     ShowMessage('Form '+FName + ' is damaged. Contact VisualTax');
    end;
end;

end.
