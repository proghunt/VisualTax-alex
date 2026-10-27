unit T2_2027eolsetup;
//revision 2014-07-29
interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,FileCtrl,T2_2027Declare,T2_2027Trimstr;

Const ElemSep = '*';
      LineSep = '!';
     
type
  TEOLSetUpT2_2027 = class(TForm)
    HeaderPanel: TPanel;
    CancelBtn: TBitBtn;
    SaveBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Label6: TLabel;
    OnlineNoBox: TEdit;
    PasswordBox: TEdit;
    URLBox: TEdit;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    NetfileDirBox: TEdit;
    Label2: TLabel;
    ProdOrTestBox: TRadioGroup;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;

    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure CreateBtnClick(Sender: TObject);
    //procedure ShowBtnClick(Sender: TObject);
    //procedure Panel1Click(Sender: TObject);
    //Function GetProdOrTest:String;
    procedure SaveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EOLSetUpT2_2027: TEOLSetUpT2_2027;
  OnLineNo,PassWord,FileName,Url,
  //Refund,
  OnLineMethod:String;  //to be used bu the uhtmlEfOnline
  //F1:TextFile;
  //SfdNo : Integer;
  //EFlines  : TStringList;
  //ProdOrTest:string; //[1];
  //CrLf  :String;
  //SegmentCnt:Integer;
  NetFileDir:String;
implementation

uses vtDialogs,T2_2027main;

{$R *.DFM}

procedure TEOLSetUpT2_2027.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TEOLSetUpT2_2027.FormCreate(Sender: TObject);
begin
 ProdOrTestBox.ItemIndex:=0;
 OnLineMethod:='CIF';
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 OnLineNoBox.Text:=OnlineNo;
 PasswordBox.Text:= Password;
   //20130527
  If (OnlineNo>'') and (Password='') then
  Begin
    //20170909 Igor>>>
    ShowMessage('Password is required');
    //20170909 Igor<<<
    Exit;
  end;
 UrlBox.Text:=Url;
 NetFileDirBox.Text:=NetFileDir;
 If NetFileDirBox.Text='' then NetFileDirBox.Text:=GetDefaultNetFileDir;
 NetFileDir:=NetFileDirBox.Text;

 If UrlBox.Text='' then
 begin
  UrlBox.text:=GetEfileUrl;
  //testing url 2009
  //UrlBox.text:='https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2if/connecting-e.jsp';
  //'http://www.ccra-adrc.gc.ca/eservices/tax/business/corpnet/readytofile-e.html#P17_1369';
 //GOOD: else UrlBox.text:='https://198.103.185.30/ef.emod.tierp/pub/index.jsp';
 end;
end;


procedure TEOLSetUpT2_2027.SaveBtnClick(Sender: TObject);
begin
 If NetFileDirBox.Text = '' then
    NetFileDirBox.Text := GetDefaultNetFileDir;
 Try
  If Not SysUtils.DirectoryExists(NetFileDirBox.Text) then //20150701
    SysUtils.ForceDirectories(NetFileDirBox.Text); //20150701
  NetFileDir:=NetFileDirBox.Text;
  OnLineNo:=OnlineNobox.Text;
  Password:=PasswordBox.Text;
  Url:=UrlBox.Text;
  SaveEOLParms(OnLineNo,Password,Url,NetFileDir);
  ShowTimedMsg('Setup saved...Click on Exit',1000);

 except
  ShowMessage('Unable to create Directory'+Chr(13)+NetFileDirBox.Text);
 end; //try
end;

end.
