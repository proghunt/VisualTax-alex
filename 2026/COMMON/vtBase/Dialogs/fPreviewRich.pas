unit fPreviewRich;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  StdCtrls, //ComCtrls, //T1_2012Declare,
  Menus, Printers, //vtRichMemoBox;  //wwriched;

  RxRichEd; //20160819 Igor (It must be the last)

type
  TPreviewRich = class(TForm)
    MainMenu1: TMainMenu;
    Exit1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);//20160819 Igor
  private
    RichText1: TrxRichEdit; //20160819 Igor

  public

  end;

var
  //PreviewRich: TPreviewRich;
  QrLtrName: string;
  {
    LogoHeight:String;
    LogoWidth :String;
    IncludeLogo:String[1];
    LogoPosition:String;
  }

implementation

{$R *.DFM}

procedure TPreviewRich.FormCreate(Sender: TObject);
begin
//20160819 igor >>>
  RichText1 := TrxRichEdit.Create(Self);
  RichText1.Parent := Self;
  RichText1.align := alClient;
//20160819 igor <<<
  if FileExists(QrLtrName) then
    RichText1.Lines.LoadFromFile(QrLtrName)
  else
    ShowMessage('Letter not found: ' + QrLtrName);
end;

procedure TPreviewRich.FormDestroy(Sender: TObject); //20160819 Igor
begin
  freeAndNil(RichText1);
end;

procedure TPreviewRich.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.

