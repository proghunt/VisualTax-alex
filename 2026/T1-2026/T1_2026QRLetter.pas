unit T1_2026QRLetter;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,//20150727QuickRpt,
  //20150727Qrctrls,
  ExtCtrls,Db,T1_2026Declare,StdCtrls,ComCtrls,Printers;

type
  TQRLetterT1_2026 = class(TForm)
    procedure FormCreate(Sender: TObject);
//20150727    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;var PrintReport: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  QRLetter: TQRLetterT1_2026;

  LogoFile:String;
  LogoHeight:String;
  LogoWidth :String;
  IncludeLogo:string; //[1];
  LogoPosition:String;

implementation

uses vtCommon,T1_2026TrimStr,T1_2026main,vtTrimstr,vtShared;

{$R *.DFM}

procedure TQRLetterT1_2026.FormCreate(Sender: TObject);
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


//20150727procedure TQRLetterT1_2026.QuickRep1BeforePrint(Sender: TCustomQuickRep;
//20150727  var PrintReport: Boolean);
//20150727  Var TempList:TStringList;i:Integer;
//20150727 begin
 //no impact QuickRep1.Zoom := 100;
//20150727end;
end.
