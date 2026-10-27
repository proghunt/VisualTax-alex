unit T2_2027PrivacyAgreement;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl,
  T2_2027TrimStr, T2_2027Declare, Db, DBTables, Grids, DBGrids,   //20150120 Igor
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, System.IOUtils; //20110129  NEEDED for connection and the response handler //20240222 Igor

type
  TPrivacyAgreementT2_2027 = class(TForm)
    headerPanel: TPanel;
    RichEdit1: TRichEdit;
    Panel1: TPanel;
    continueBTN: TButton;
    cancelBTN: TButton;
    DoNotShowAgainCheckBox: TCheckBox;
    formHeaderLbl: TLabel;
    Label2: TLabel;
    procedure continueBTNClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);


  private
    { Private declarations }
    RetNo:Integer;   //20160120 Igor
  public
    { Public declarations }
  end;

var
  PrivacyAgreement: TPrivacyAgreementT2_2027;
  PrivacyAgreementdoNotShowPathandFileName : string;

//const
//  doNotShowPrivacyAgreementFileName = 'doNotShowPrivacyAgreementMessage.d'; // added to uDeclare


implementation

uses vtDataBase, vtMulti,vtCommon,vtMain, vtTrimStr, T2_2027, T2_2027main,
  vtShared, vtDynData{,childwinnew}; //20150120 Igor

{$R *.DFM}



procedure TPrivacyAgreementT2_2027.continueBTNClick(Sender: TObject);
var
  i : integer;
  doNotShowPrivacyAgreementList : TStringList;

begin
  if DoNotShowAgainCheckBox.Checked then
  begin

    if not FileExists(PrivacyAgreementDoNotShowPathandFileName) then
    begin
      doNotShowPrivacyAgreementList := TStringlist.create;
    end //if not FileExists
    else
    begin
      doNotShowPrivacyAgreementList := TStringlist.create;
      doNotShowPrivacyAgreementList.loadfromfile(PrivacyAgreementDoNotShowPathandFileName);
    end;

    try
      doNotShowPrivacyAgreementList.Add(formHeaderLbl.caption);  //formHeaderLbl.caption should be the form name that is passed when this unit is called
      doNotShowPrivacyAgreementList.SaveToFile(PrivacyAgreementDoNotShowPathandFileName);
    finally
      doNotShowPrivacyAgreementList.Free;
    end; //try

  end; //if DoNotShowAgainCheckBox.Checked

end;

procedure TPrivacyAgreementT2_2027.FormActivate(Sender: TObject);
begin
  //richedit1.Perform( WM_VSCROLL, MakeWParam(SB_Top,0),0);
  //SendMessage(RichEdit1.handle, WM_VSCROLL, SB_TOP, 0);

  //RichEdit1.SetFocus;
  //RichEdit1.SelStart := RichEdit1.GetTextLen;
  //RichEdit1.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TPrivacyAgreementT2_2027.FormCreate(Sender: TObject);
begin
  PrivacyAgreementDoNotShowPathandFileName := appdir + '\' + PrivacyAgreementDoNotShowFileName;
  RichEdit1.Lines.LoadFromFile(appdir + '\' + 'PrivacyAgreementMessageText.rft');
end;

end.
