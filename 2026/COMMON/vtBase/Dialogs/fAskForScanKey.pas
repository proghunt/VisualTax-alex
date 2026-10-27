unit fAskForScanKey;
(* The scan key file must reside in the ExeDir, no AppId available here!
*)

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,
  //TrimStr,UDeclare,
  //T1rtns;
  vtMulti;

type
  TAskType = (atScan, atArch); //20241024 Igor

  TAskForScanKey = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Edit1: TEdit;
    OKBtn: TBitBtn;
    CancelProgramBtn: TBitBtn;
    //  procedure DemoBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelProgramBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    ValidKey: Boolean;
    MyApp: TApp;
  public
    Id: string;
    LicenseString: string;
    AskType: TAskType; //20241024 Igor
  end;
  //var AskForScanKey: TAskForScanKey;

  //function AskForScanKey(const ScanId: string): string;
function AskForScanKey(TheApp: TApp): string;
function AskForArchKey(TheApp: TApp): string; //20241024 Igor

implementation

{$R *.DFM}

uses //Main;
  vtAuthorization,
  vtCommon; //, T1_2011;

//function AskForScanKey(const ScanId: string): string;

function AskForScanKey(TheApp: TApp): string;
begin
  Result := '';
  if TheApp.ScanId = '' then
    exit; //no license applicable
  with TAskForScanKey.Create(Application) do
  begin
    AskType := atScan; //20241024 Igor
    MyApp := TheApp;
    Id := TheApp.ScanId;
    Caption := TheApp.ScanId;
    if ShowModal = mrOk then
      Result := LicenseString;
    Release;
  end;
end;

//20241024 Igor >>>
function AskForArchKey(TheApp: TApp): string;
begin
  Result := '';
  if TheApp.ArchiveID = '' then
    exit;
  with TAskForScanKey.Create(Application) do
  begin
    AskType := atArch;
    MyApp := TheApp;
    Id := TheApp.ArchiveID;
    Caption := TheApp.ArchiveID;
    GroupBox1.Caption := 'Enter the vtArchives Authorization key you received when purchased the vtArchives option';
    if ShowModal = mrOk then
      Result := LicenseString;
    Release;
  end;
end;
//20241024 Igor <<<
(*
procedure TAskForScanKey.DemoBtnClick(Sender: TObject);
begin
 Edit1.Text := '3418-6470-6dx7-a013';
 OKBtnClick(Application);
 Close;
end;
*)

procedure TAskForScanKey.OKBtnClick(Sender: TObject);
begin
  //If ValidateScanKey(Edit1.Text,PgmNames,ProductIds,PgmFactors) = False then
  if AskType = atScan then //20241024 Igor
  begin
    if MyApp.ValidateScanKey(Edit1.Text) = False then
    begin
      ShowMessage('Invalid Key');
      ValidKey := false;
      LicenseString := '';
      MyApp.ScanLicenseLevel := llNone;
      exit;
    end;
  end
  //20241024 Igor >>>
  else if AskType = atArch then
  begin
    if MyApp.ValidateArchKey(Edit1.Text) = False then
    begin
      ShowMessage('Invalid Key');
      ValidKey := false;
      LicenseString := '';
      MyApp.ArchLicenseLevel := llNone;
      exit;
    end;
  end;
  //20241024 Igor <<<

  //Edit1.Text := PaddR(Edit1.Text,40);
  LicenseString := Edit1.Text;
  //LicenseLevel := GetProductName(LeftStr(s,4),PgmNames,ProductIds,PgmFactors);
  //LicenseLevel := GetProductName(LeftStr(s,4));
  //Licensee := MidStr(S,41,40);
  //WriteAppFileLine(ScanActivationFile, s, nil);
  UpdateLicenseFile(Id, LicenseString);
  ValidKey := True;
  //20241024 Igor >>>
  if AskType = atScan then
    MyApp.ScanLicenseLevel := llStd
  else
    MyApp.ArchLicenseLevel := llStd;
  //20241024 Igor <<<
  ModalResult := mrOk; // Close;
end;

procedure TAskForScanKey.CancelProgramBtnClick(Sender: TObject);
begin
  Close;
  //Application.Terminate;
end;

procedure TAskForScanKey.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //If ValidKey =False then Close; //Application.Terminate;
  Action := caFree;
end;

procedure TAskForScanKey.FormCreate(Sender: TObject);
//Var TempList:TStringList;
begin
  ValidKey := False;
  //Edit1.Text:= ReadAppFileLine(ScanActivationFile);
  LicenseString := LicenseList.Values[Id];
  Edit1.Text := LicenseString;
end;

end.

