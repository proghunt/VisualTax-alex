unit FP_2027QRLetter;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,QuickRpt,
  Qrctrls,ExtCtrls,Db,FP_2027Declare,StdCtrls,ComCtrls,Printers;

type
  TQRLetterFP_2012 = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRImage1: TQRImage;
    QRRichText1: TQRRichText;
    procedure FormCreate(Sender: TObject);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;var PrintReport: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QRLetter: TQRLetterFP_2012;

  LogoFile:String;
  LogoHeight:String;
  LogoWidth :String;
  IncludeLogo:string; //[1];
  LogoPosition:String;

implementation

{$R *.DFM}

uses vtCommon,FP_2027TrimStr,FP_2027main,vtTrimStr,vtShared;

procedure TQRLetterFP_2012.FormCreate(Sender: TObject);
Var LogoFile:String;
begin
(*
 QuickRep1.PrinterSettings.PrinterIndex := Printer.PrinterIndex;

 With QRRichText1 do
 begin
  // n/a to qr
  //WantReturns := True;
  //WantTabs := True;
  //WordWrap := True;
  //PlainText := False;
  Width := 775;
  //Font.Assign(MainForm.Font); {must be Arial - why?}
  //Font.Size := 9;
 end;
 GetLogoInfo(LogoFile,IncludeLogo,LogoHeight,LogoWidth,LogoPosition);
 If UpperCase(IncludeLogo) ='Y' then
 begin
   If FileExists(LogoFile) then
   begin
    QrImage1.Picture.LoadFromFile(LogoFile);
    QrBand1.Height := StrToInt(LogoHeight);
    //QrBand1.Width := StrToInt(LogoWidth);
    QrImage1.Height:= StrToInt(LogoHeight);
    QrImage1.Width:= StrToInt(LogoWidth);
    If LogoPosition='Left' then QrImage1.Left:=40;
    If LogoPosition='Center' then
    begin
     If QrBand1.Width - QrImage1.Width >0 then
      QrImage1.Left := (QrBand1.Width - QrImage1.Width) Div 2;
    end;
    If LogoPosition='Right' then
    begin
     If QrBand1.Width - QrImage1.Width >0 then
      QrImage1.Left := QrBand1.Width - QrImage1.Width;
    end;

   end;
 end
 Else
  QrBand1.Height:=0;


 If FileExists(QrLtrName) then
  QRRichText1.Lines.LoadFromFile(QrLtrName)
 else
  ShowMessage('Letter not found: '+ QrLtrName);
*)
end;


procedure TQRLetterFP_2012.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
  Var TempList:TStringList;i:Integer;
begin
 //no impact QuickRep1.Zoom := 100;
end;
end.
