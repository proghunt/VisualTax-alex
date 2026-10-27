unit T1_2026eolsetup;
//updated 07-28

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,FileCtrl;

Const ElemSep = '*';

type
  TEOLSetUpT1_2026 = class(TForm)
  
    EfileType: TPanel;  CancelBtn: TBitBtn;
    SaveBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    OnlineNoBox: TEdit;
    PasswordBox: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    NetfileDirBox: TEdit;
    Label2: TLabel;
    ProdOrTestBox: TRadioGroup;
    Label3: TLabel;
    Label7: TLabel;
    UrlLabel: TLabel;
    URLBox: TEdit;
    Label5: TLabel;
    PasswordBox2: TEdit;
    Label6: TLabel;

    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure CreateBtnClick(Sender: TObject);
    //procedure ShowBtnClick(Sender: TObject);
    //procedure Panel1Click(Sender: TObject);
    //Function GetProdOrTest:String;
    procedure SaveBtnClick(Sender: TObject);
    procedure AssignUrl;
    procedure ProdOrTestBoxClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EOLSetUp: TEOLSetUpT1_2026;
  OnLineNo,PassWord,FileName,Url,Refund,OnLineMethod:String;  //to be used bu the uhtmlEfOnline
  F1:TextFile;
  SfdNo : Integer;
  EFlines  : TStringList;
  ProdOrTest:string; //[1];
  CrLf  :String;
  SegmentCnt:Integer;
  NetFileDir:String;

implementation

{$R *.DFM}

uses vtDialogs,T1_2026Declare,T1_2026Trimstr,T1_2026main;

procedure TEOLSetUpT1_2026.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TEOLSetUpT1_2026.FormCreate(Sender: TObject);
begin
 If IsHomeUse then
  UrlLabel.Caption:='  NetFile Web site (URL):'
 else
  UrlLabel.Caption:='EFile On-line Web site (URL):';
 If IsHomeUse then GroupBox1.visible:=False;

 If IsHomeUse then
  EfileType.caption:='NetFile setup'
 else
  EfileType.caption:='EFILE ON-LINE (EOL) SETUP';
 OnLineMethod:='EOL';
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 OnLineNoBox.Text:=OnlineNo;
 PasswordBox.Text  := Password;
 PasswordBox2.Text := Password; //jz//20260219 - add so don't have to re-enter it every time if not changed
 UrlBox.Text:=Url;
 NetFileDirBox.Text:=NetFileDir;
 If NetFileDirBox.Text='' then NetFileDirBox.Text:=GetDefaultNetFileDir;
 NetFileDir:=NetFileDirBox.Text;
 AssignUrl;
 If IsHomeUse then begin UrlBox.Text:='http://www.netfile.gc.ca/rdy-eng.html';Url:=UrlBox.text;end;
 UrlBox.Refresh;
end;

//220250312
procedure TEOLSetUpT1_2026.SaveBtnClick(Sender: TObject);
begin
  //20250312
 if UpperCase(PasswordBox.Text) <> UpperCase(PasswordBox2.Text) then  //20250309
 Begin
  ShowMessage('The password on the second box is not the same with the one on the first box. Please re-enter it');
  Exit;
 End;

 If NetFileDirBox.Text = '' then NetFileDirBox.Text := GetDefaultNetFileDir;
 Try
  If Not DirectoryExists(NetFileDirBox.Text) then ForceDirectories(NetFileDirBox.Text);
  NetFileDir:=NetFileDirBox.Text;
  OnLineNo:=OnlineNobox.Text;
  Password:=PasswordBox.Text;
  If ProdOrTestBox.itemIndex=0 then ProdOrTest:='P';
  If ProdOrTestBox.itemIndex=1 then ProdOrTest:='T';
  AssignUrl;
  If IsHomeUse then begin UrlBox.Text:='http://www.netfile.gc.ca/rdy-eng.html';Url:=UrlBox.text;end;
  Url:=UrlBox.Text;
  SaveEOLParms(OnLineNo,Password,Url,NetFileDir);
  ShowTimedMsg('Setup saved...Click on Exit',1000);

 except
  ShowMessage('Unable to create Directory'+Chr(13)+NetFileDirBox.Text);
 end; //try
end;

procedure TEOLSetUpT1_2026.AssignUrl;
Begin
  If ProdOrTestBox.ItemIndex =1 then  //test
   UrlBox.text:='https://apps-ct.cra-arc.gc.ca/ebci/pfeo/ws/services/EolService?wsdl'
  else //production
   UrlBox.text:='https://apps.cra-arc.gc.ca/ebci/pfeo/ws/services/EolService?wsdl';
end;

procedure TEOLSetUpT1_2026.ProdOrTestBoxClick(Sender: TObject);
begin
  AssignUrl;
  Refresh;
end;

procedure TEOLSetUpT1_2026.FormPaint(Sender: TObject);
begin
UrlBox.Update;
end;

end.



