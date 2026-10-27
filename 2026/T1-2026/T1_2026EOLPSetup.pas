unit T1_2026eolpsetup;
//updated 07-19

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,FileCtrl;

Const ElemSep = '*';
     
type
  TEOLPSetUpT1_2026 = class(TForm)
    HeaderPanel: TPanel;
    CancelBtn: TBitBtn;
    SaveBtn: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Label6: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    OnlineNoBox: TEdit;
    PasswordBox: TEdit;
    URLBox: TEdit;
    TransmitterNoBox: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    NetfileDirBox: TEdit;
    Label3: TLabel;
    Label7: TLabel;
    ProductionOrTestBox: TRadioGroup;
    Label8: TLabel;
    PasswordBox2: TEdit;

    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Function GetDefaultEolPUrl:String;
    procedure SaveBtnClick(Sender: TObject);
    procedure OnlineNoBoxExit(Sender: TObject);
    procedure ProductionOrTestBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EOLPSetUp: TEOLPSetUpT1_2026;
  OnLineNo,TransmitterNo,PassWord,FileName,Url,Refund,OnLineMethod:String;  //to be used bu the uhtmlEfOnline
  NetFileDir:String;
  F1:TextFile;
  SfdNo : Integer;
  EFlines  : TStringList;
  CrLf  :String;
  SegmentCnt:Integer;

implementation

{$R *.DFM}

uses vtDialogs,T1_2026Declare,T1_2026Trimstr,T1_2026main;

procedure TEOLPSetUpT1_2026.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TEOLPSetUpT1_2026.FormCreate(Sender: TObject);
begin
 OnLineMethod:='EOLP';
 GetEOLPParms(OnlineNo,TransmitterNo,Password,Url,NetFileDir);
 OnLineNoBox.Text:=OnlineNo;
 TransmitterNoBox.Text:=TransmitterNo;
 PasswordBox.Text:= Password;
 UrlBox.Text:=Url;
 NetFileDirBox.Text:=NetFileDir;
 If NetFileDirBox.Text='' then  NetFileDirBox.Text:= GetDefaultEolPNetFileDir;
 NetFileDir:=NetFileDirBox.Text;


 If UrlBox.Text='' then GetDefaultEolPUrl;

end;

procedure TEOLPSetUpT1_2026.SaveBtnClick(Sender: TObject);
begin
 //20250312
 if UpperCase(PasswordBox.Text) <> UpperCase(PasswordBox2.Text) then  //20250309
 Begin
  ShowMessage('The password on the second box is not the same with the one on the first box. Please re-enter it');
  Exit;
 End;

 If UrlBox.text='' then  UrlBox.text:=GetDefaultEolPUrl;
 If NetFileDirBox.Text = '' then NetFileDirBox.Text := GetDefaultEOLPNetFileDir;
 Try
  If Not DirectoryExists(NetFileDirBox.Text) then ForceDirectories(NetFileDirBox.Text);
  NetFileDir:=NetFileDirBox.Text;
  OnLineNo:=OnlineNoBox.Text;
  TransmitterNo:=TransmitterNoBox.Text;
  Password:=PasswordBox.Text;
  Url:=UrlBox.Text;
  SaveEOLPParms(OnLineNo,TransmitterNo,Password,Url,NetFileDir);
  ShowTimedMsg('Setup saved...Click on Exit',1000);

 except
  ShowMessage('Unable to create Directory'+Chr(13)+NetFileDirBox.Text);
 end;
end;

procedure TEOLPSetUpT1_2026.OnlineNoBoxExit(Sender: TObject);
begin
 If TransmitterNoBox.Text='' then TransmitterNoBox.Text:=OnlineNoBox.Text;
end;

Function TEOLPSetUpT1_2026.GetDefaultEolPUrl:String;
begin
  Case ProductionOrTestBox.ItemIndex of
  0: Result:='https://apps.cra-arc.gc.ca/ebci/efes/emod/sec/EmodLogin-e';
  1: Result:='https://apps-ct.cra-arc.gc.ca/ebci/efes/emod/sec/EmodLogin-e';

  // 0: Result:='https://apps.cra-arc.gc.ca/ebci/efes/emod/sec/EmodLogin-e'; //2011
  // 1: Result:='https://apps-ct.cra-arc.gc.ca/ebci/efes/emod/sec/EmodLogin-e'; //2011
 end; //case
// Result:='https://apps.cra-arc.gc.ca/ebci/efes/emod/sec/EmodLogin-e'; //2009
end;


procedure TEOLPSetUpT1_2026.ProductionOrTestBoxClick(Sender: TObject);
begin
 UrlBox.Text:= GetDefaultEolPUrl;
 Url:=UrlBox.Text;
end;

end.
