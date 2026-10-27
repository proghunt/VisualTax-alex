unit FP_2027previewrich;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,ComCtrls,FP_2027Declare,Menus,Printers,vtRichmemobox;

type
  TPreviewRichFP_2027 = class(TForm)
    MainMenu1: TMainMenu;
    Exit1: TMenuItem;
    RichText1: TvtRichMemo;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PreviewRich: TPreviewRichFP_2027;
  LogoHeight:String;
  LogoWidth :String;
  IncludeLogo:string; //[1];
  LogoPosition:String;

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,FP_2027Main,vtTrimStr,vtShared;

procedure TPreviewRichFP_2027.FormCreate(Sender: TObject);
begin
 If FileExists(QrLtrName) then
  RichText1.Lines.LoadFromFile(QrLtrName)
 else
  ShowMessage('Letter not found: '+ QrLtrName);
end;

procedure TPreviewRichFP_2027.Exit1Click(Sender: TObject);
begin
Close;
end;


end.
