unit vtGif;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.GIFImg;

type
  TGifForm = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
  public
    Gif: TGifImage;
  end;

  TGifThread = class(TThread)
  private
    FForm: TGifForm;
  public
    constructor Create;
    procedure Execute; override;
  end;

var GifThread : TGifThread;

implementation
{$R *.dfm}
uses vtFileStorage,vtCommon,vtMain;

constructor TGifThread.Create;
begin
  FForm := TGifForm.Create(nil);
  inherited Create(true);
end;

procedure TGifThread.Execute;
begin
//  FreeOnTerminate := false;
  // thread runs until it or the application is terminated
  //GifThread.Terminated:=false;
  //Priority:=tpHighest;

  FForm.Show;

  //while true do if GifThread.Terminated then break;
  while not Terminated do ;

//  sleep(1000);

  FForm.Gif.Animate := false;
  FForm.Close;
end;


procedure TGifForm.FormCreate(Sender: TObject);
begin
   Gif := TGifImage.Create;
   Gif.LoadFromFile('load.gif');
   Gif.Animate := True;
   Gif.AnimateLoop := glEnabled;
   //
   Image1.Picture.Assign(Gif);
end;

initialization
  GifThread:= TGifThread.Create;
  GifThread.Priority:=tpHighest;
finalization
  GifThread.Free;
end.
