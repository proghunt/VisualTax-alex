unit T2_2027trnsmtr;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,T2_2027Declare,T2_2027TrimStr;

type
  TTransmitterT2_2027 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Name: TEdit;
    EFileNo: TEdit;
    Street: TEdit;
    City: TEdit;
    Province: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Postal: TEdit;
    Phone: TEdit;
    Label10: TLabel;
    Fax: TEdit;
    OKBtn: TBitBtn;
    BitBtn2: TBitBtn;
    Label11: TLabel;
    MailToName: TEdit;
    Label12: TLabel;
    Country: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Label17: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Transmitter: TTransmitterT2_2027;

implementation

{$R *.DFM}

procedure TTransmitterT2_2027.BitBtn2Click(Sender: TObject);
begin
Close;
end;

procedure TTransmitterT2_2027.FormCreate(Sender: TObject);
begin
 Name.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Name');
 EfileNo.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','EFileNo');
 MailToName.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','MailToName');
 Street.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Street');
 City.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','City');
 Province.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Province');
 Postal.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Postal');
 Country.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Country');
 If Country.Text ='' then Country.Text := 'CA'; 
 Phone.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Phone');
 Fax.Text := GetWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Fax');

end;

procedure TTransmitterT2_2027.OKBtnClick(Sender: TObject);
begin
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Name',Name.text);
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','EfileNo',EFileNo.text);
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','MailToName',MailToName.text);
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Street',Street.text);
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','City',City.text);
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Province',Province.text);
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Postal',Postal.text);
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Country',Country.text);
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Phone',Phone.text);
 WriteWinIniString(AppDir+'\'+'Transm.d','TRANSMITTER','Fax',Fax.text);
 ShowMessage('Data saved');
 Close;
end;

end.
