unit T3_2026eolsetup;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,FileCtrl;

Const ElemSep = '*';

type
  TEOLSetUpT3_2026 = class(TForm)
  
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
  EOLSetUp: TEOLSetUpT3_2026;
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

uses vtDialogs,T3_2026Declare,T3_2026Trimstr,T3_2026main;

procedure TEOLSetUpT3_2026.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TEOLSetUpT3_2026.FormCreate(Sender: TObject);
begin
 UrlLabel.Caption:='EFile On-line Web site (URL):';
 EfileType.caption:='EFILE ON-LINE (EOL) SETUP';
 OnLineMethod:='EOL';
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 OnLineNoBox.Text:=OnlineNo;
 PasswordBox.Text:= Password;
 UrlBox.Text:=Url;
 NetFileDirBox.Text:=NetFileDir;
 If NetFileDirBox.Text='' then NetFileDirBox.Text:=GetDefaultNetFileDir;
 NetFileDir:=NetFileDirBox.Text;
 AssignUrl;
 UrlBox.Refresh;
end;

procedure TEOLSetUpT3_2026.SaveBtnClick(Sender: TObject);
begin
 If NetFileDirBox.Text = '' then NetFileDirBox.Text := GetDefaultNetFileDir;
 Try
  If Not DirectoryExists(NetFileDirBox.Text) then ForceDirectories(NetFileDirBox.Text);
  NetFileDir:=NetFileDirBox.Text;
  OnLineNo:=OnlineNobox.Text;
  Password:=PasswordBox.Text;
  If ProdOrTestBox.itemIndex=0 then ProdOrTest:='P';
  If ProdOrTestBox.itemIndex=1 then ProdOrTest:='T';
  AssignUrl;
  Url:=UrlBox.Text;
  SaveEOLParms(OnLineNo,Password,Url,NetFileDir);
  ShowTimedMsg('Setup saved...Click on Exit',1000);

 except
  ShowMessage('Unable to create Directory'+Chr(13)+NetFileDirBox.Text);
 end; //try
end;

procedure TEOLSetUpT3_2026.AssignUrl;
Begin
  If ProdOrTestBox.ItemIndex =1 then  //test
   UrlBox.text:='https://apps-ct.cra-arc.gc.ca/ebci/pfeo/ws/services/EolService?wsdl'
  else //production
   UrlBox.text:='https://apps.cra-arc.gc.ca/ebci/pfeo/ws/services/EolService?wsdl';
end;

procedure TEOLSetUpT3_2026.ProdOrTestBoxClick(Sender: TObject);
begin
  AssignUrl;
  Refresh;
end;

procedure TEOLSetUpT3_2026.FormPaint(Sender: TObject);
begin
  UrlBox.Update;
end;

end.



