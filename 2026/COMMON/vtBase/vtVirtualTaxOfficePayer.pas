Unit vtVirtualTaxOfficePayer;

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DBCtrls,
  Vcl.Mask, vteditbox, vtLabel, vtShape, ShellApi, System.Generics.Collections,
  System.IOUtils, Data.DBXJSON, vtVirtualTaxOffice, Vcl.ComCtrls;

type
  TvtVirtualTaxOfficePayer = class(TForm)
    shHeader: TvtShape;
    vtLabel37: TvtLabel;
    pnlMain: TPanel;
    gbLogin: TGroupBox;
    lbCyberId: TLabel;
    edCyberId: TEdit;
    edFirstName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edLastName: TEdit;
    Label3: TLabel;
    edEmail: TEdit;
    Label4: TLabel;
    edTaxOfficeCyberId: TEdit;
    gbAddress: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edStreet: TEdit;
    edCity: TEdit;
    edProvince: TEdit;
    edPostal: TEdit;
    Label9: TLabel;
    edCountry: TEdit;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edArea: TEdit;
    edPhone: TEdit;
    edCell: TEdit;
    edFax: TEdit;
    gbComputer: TGroupBox;
    rbWindows: TRadioButton;
    rbMac: TRadioButton;
    rbOther: TRadioButton;
    Label14: TLabel;
    edTeamviewerID: TEdit;
    Label15: TLabel;
    edVirtualMeetingAlarm: TEdit;
    cbZoomVideoID: TCheckBox;
    Label16: TLabel;
    edUltraViewerId: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    btnShowProfile: TSpeedButton;
    Label17: TLabel;
    edTaxSoftwareNames: TEdit; //20201216 Igor
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnShowProfileClick(Sender: TObject); //20201216 Igor
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadProfile;
    function SaveProfile: boolean;
  end;

  procedure EditVirtualTaxOfficePayer;

implementation

{$R *.dfm}

Uses
  vtMulti, vtCommon, vtDialogs, vtMain, vtTrimStr, vtShared, vtDataBase,
  Variants, vtVirtualTaxOfficeOffice; //20201216 Igor

procedure EditVirtualTaxOfficePayer;
var
  FVirtualTaxOfficePayer: TvtVirtualTaxOfficePayer;
begin
  FVirtualTaxOfficePayer := TvtVirtualTaxOfficePayer.Create(Application);
  try
    FVirtualTaxOfficePayer.ShowModal;
  finally
    FVirtualTaxOfficePayer.Free;
  end;
end;

{ TvtVirtualTaxOfficePayer }

procedure TvtVirtualTaxOfficePayer.btnSaveClick(Sender: TObject);
begin
  if SaveProfile then
    ModalResult := mrOk;
end;

procedure TvtVirtualTaxOfficePayer.btnShowProfileClick(Sender: TObject); //20201216 Igor
begin
  //20210202 Igor >>>
  if String(edTaxOfficeCyberId.Text).IsEmpty then
  begin
    ShowMessage('Virtual Office Id is not specified');
    Exit;
  end;
  //20210202 Igor <<<
  EditVirtualTaxOfficeOffice(edTaxOfficeCyberId.Text);
end;

procedure TvtVirtualTaxOfficePayer.FormShow(Sender: TObject);
var I: integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TEdit then
      if TEdit(Components[I]).ReadOnly then
        TEdit(Components[I]).Color := ReadonlyColor;
  LoadProfile;
  edCyberId.Text := VirtualTaxOfficeInfo.CyberId;
end;

procedure TvtVirtualTaxOfficePayer.LoadProfile;
var FParams: TParamList;
    Res: TJSONObject;
begin
  FParams := TParamList.Create;
  try
    FParams.AddParam('action','LOAD_PROFILE');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        edFirstName.Text := GetJSONValue(Res, 'FirstName');
        edLastName.Text := GetJSONValue(Res, 'LastName');
        edEmail.Text := GetJSONValue(Res, 'Email');
        edTaxOfficeCyberId.Text := GetJSONValue(Res, 'TaxOfficeCyberId');
        edArea.Text := GetJSONValue(Res, 'Area');
        edPhone.Text := GetJSONValue(Res, 'Phone');
        edCell.Text := GetJSONValue(Res, 'Cell');
        edFax.Text := GetJSONValue(Res, 'Fax');
        edStreet.Text := GetJSONValue(Res, 'Street');
        edCity.Text := GetJSONValue(Res, 'City');
        edProvince.Text := GetJSONValue(Res, 'Province');
        edPostal.Text := GetJSONValue(Res, 'Postal');
        edCountry.Text := GetJSONValue(Res, 'Country');

        rbWindows.Checked := SameText(GetJSONValue(Res, 'Computer'), 'W');
        rbMaC.Checked := SameText(GetJSONValue(Res, 'Computer'), 'M');
        rbOther.Checked := SameText(GetJSONValue(Res, 'Computer'), 'O');

        edTeamviewerId.Text := GetJSONValue(Res, 'TeamviewerID');
        edVirtualMeetingAlarm.Text := GetJSONValue(Res, 'VirtualMeetingAlarm');
        cbZoomVideoId.Checked := SameText(GetJSONValue(Res, 'ZoomVideoID'), 'Y');
        edUltraViewerId.Text := GetJSONValue(Res, 'UltraViewerID'); //20201221 Igor
        edTaxSoftwareNames.Text := GetJSONValue(Res, 'TaxSoftwareNames');
      end
      else
        ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

function TvtVirtualTaxOfficePayer.SaveProfile: boolean;
var FParams: TParamList;
    Res: TJSONObject;
begin
  Result := false;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'SAVE_PROFILE');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('FirstName', edFirstName.Text);
    FParams.AddParam('LastName', edLastName.Text);
    FParams.AddParam('TaxOfficeCyberId', edTaxOfficeCyberId.Text);
    FParams.AddParam('Area', edArea.Text);
    FParams.AddParam('Phone', edPhone.Text);
    FParams.AddParam('Cell', edCell.Text);
    FParams.AddParam('Fax', edFax.Text);
    FParams.AddParam('Street', edStreet.Text);
    FParams.AddParam('City', edCity.Text);
    FParams.AddParam('Province', edProvince.Text);
    FParams.AddParam('Postal', edPostal.Text);
    FParams.AddParam('Country', edCountry.Text);
    if rbWindows.Checked then
      FParams.AddParam('Computer','W')
    else if rbMac.Checked then
      FParams.AddParam('Computer','M')
    else if rbOther.Checked then
      FParams.AddParam('Computer','O');

    FParams.AddParam('TeamviewerID', edTeamviewerID.Text);
    FParams.AddParam('VirtualMeetingAlarm', edVirtualMeetingAlarm.Text);
    FParams.AddParam('ZoomVideoID', GetCheckValue(cbZoomVideoId));
    FParams.AddParam('UltraViewerID', edUltraViewerId.Text); //20201221 Igor
    FParams.AddParam('TaxSoftwareNames', edTaxSoftwareNames.Text);

    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        Result := true;
        VirtualTaxOfficeInfo.RefreshTaxOfficeInfo;
      end
      else
        ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

end.
