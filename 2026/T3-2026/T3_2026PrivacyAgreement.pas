unit T3_2026PrivacyAgreement;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl,
  T3_2026TrimStr, T3_2026Declare, Db, DBTables, Grids, DBGrids,   //20260817 Alex
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, System.IOUtils; //20110129  NEEDED for connection and the response handler //20240222 Igor

type
  TPrivacyAgreementT3_2026 = class(TForm)
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
  PrivacyAgreement: TPrivacyAgreementT3_2026;
  PrivacyAgreementdoNotShowPathandFileName: string;

implementation

uses
  vtDataBase, vtMulti, vtCommon, vtMain, vtTrimStr, T3_2026, T3_2026Main,
  vtShared, vtDynData;

{$R *.DFM}

procedure TPrivacyAgreementT3_2026.continueBTNClick(Sender: TObject);
var
  i: integer;
  doNotShowPrivacyAgreementList: TStringList;
begin
  if DoNotShowAgainCheckBox.Checked then
  begin
    if not FileExists(PrivacyAgreementDoNotShowPathandFileName) then
    begin
      doNotShowPrivacyAgreementList:= TStringlist.create;
    end else
    begin
      doNotShowPrivacyAgreementList:= TStringlist.create;
      doNotShowPrivacyAgreementList.loadfromfile(PrivacyAgreementDoNotShowPathandFileName);
    end;

    try
      doNotShowPrivacyAgreementList.Add(formHeaderLbl.caption);
      doNotShowPrivacyAgreementList.SaveToFile(PrivacyAgreementDoNotShowPathandFileName);
    finally
      doNotShowPrivacyAgreementList.Free;
    end;
  end;
end;

procedure TPrivacyAgreementT3_2026.FormActivate(Sender: TObject);
begin
  //richedit1.Perform( WM_VSCROLL, MakeWParam(SB_Top,0),0);
  //SendMessage(RichEdit1.handle, WM_VSCROLL, SB_TOP, 0);

  //RichEdit1.SetFocus;
  //RichEdit1.SelStart := RichEdit1.GetTextLen;
  //RichEdit1.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TPrivacyAgreementT3_2026.FormCreate(Sender: TObject);
begin
  PrivacyAgreementDoNotShowPathandFileName:= AppDir + '\' + PrivacyAgreementDoNotShowFileName;
  RichEdit1.Lines.LoadFromFile(AppDir + '\' + 'PrivacyAgreementMessageText.rft');
end;

end.
