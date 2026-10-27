unit T2_2027imageform;
//revision 2014-07-29

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons;

type
  TImageFormT2_2027 = class(TForm)
    ImageBox1: TImage;
    HeaderBox: TPanel;
    CancelBtn: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Procedure CopyTempCanvas;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImageForm: TImageFormT2_2027;
  TempCanvas :TBitMap;

implementation

{$R *.DFM}

//uses T2_2027RsiFrm;

procedure TImageFormT2_2027.FormCreate(Sender: TObject);
begin
 ImageBox1.Height := Self.Height * 2;
 CopyTempCanvas;
end;

procedure TImageFormT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

Procedure TImageFormT2_2027.CopyTempCanvas;
begin
With ImageBox1 do
 begin
  Canvas.CopyMode := cmSrcCopy;
  Canvas.CopyRect(ClientRect,TempCanvas.Canvas,ClientRect);
 end;
end;

end.
