Unit vtVirtualTaxOfficeOffice;

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DBCtrls,
  Vcl.Mask, vteditbox, vtLabel, vtShape, ShellApi, System.Generics.Collections,
  System.IOUtils, Data.DBXJSON, vtVirtualTaxOffice, Vcl.ComCtrls;

type
  TvtVirtualTaxOfficeOffice = class(TForm)
    shHeader: TvtShape;
    vtLabel37: TvtLabel;
    pnlMain: TPanel;
    gbLogin: TGroupBox;
    lbCyberId: TLabel;
    edCyberId: TEdit;
    edContact: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    edEmail: TEdit;
    gbAddress: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edStreet: TEdit;
    edCity: TEdit;
    edProvince: TEdit;
    edPostal: TEdit;
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
    Label14: TLabel;
    edTeamviewerID: TEdit;
    Label15: TLabel;
    edVirtualMeetingAlarm: TEdit;
    cbZoomVideoID: TCheckBox;
    Label16: TLabel;
    edTaxSoftwareNames: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    Label17: TLabel;
    edBusinessName: TEdit;
    Label18: TLabel;
    edWebSiteUrl: TEdit;
    lbCRAEfilerName: TLabel;
    edCRAEfilerName: TEdit;
    cbHaveCRAEfilerNumber: TCheckBox;
    GroupBox2: TGroupBox;
    cbT1: TCheckBox;
    cbT2: TCheckBox;
    Label4: TLabel;
    edYearsInBusiness: TEdit;
    cbT3: TCheckBox;
    cbT4T5: TCheckBox;
    cbNR4: TCheckBox;
    cbT3010: TCheckBox;
    cbT5013: TCheckBox;
    cbT5018: TCheckBox;
    cbvtNOA: TCheckBox;
    cbOther: TCheckBox;
    Label19: TLabel;
    edOtherServiceDescription: TEdit;
    Label20: TLabel;
    edExperience: TMemo;
    Label2: TLabel;
    edUltraViewerId: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    FCyberId: string; //20201216 Igor
  public
    { Public declarations }
    procedure LoadProfile;
    function SaveProfile: boolean;
  end;

  procedure EditVirtualTaxOfficeOffice(ACyberId: string = ''); //20201216 Igor

implementation

{$R *.dfm}

Uses
  vtMulti, vtCommon, vtDialogs, vtMain, vtTrimStr, vtShared, vtDataBase,
  Variants;

procedure EditVirtualTaxOfficeOffice(ACyberId: string = ''); //20201216 Igor
var
  FVirtualTaxOfficePayer: TvtVirtualTaxOfficeOffice;
begin
  FVirtualTaxOfficePayer := TvtVirtualTaxOfficeOffice.Create(Application);
  try
    //20201216 Igor >>>
    if not ACyberId.IsEmpty then
      FVirtualTaxOfficePayer.FCyberId := ACyberId
    else
      FVirtualTaxOfficePayer.FCyberId := VirtualTaxOfficeInfo.CyberId;
    //20201216 Igor <<<
    FVirtualTaxOfficePayer.ShowModal;
  finally
    FVirtualTaxOfficePayer.Free;
  end;
end;

{ TvtVirtualTaxOfficeOffice }

procedure TvtVirtualTaxOfficeOffice.btnSaveClick(Sender: TObject);
begin
  if SaveProfile then
    ModalResult := mrOk;
end;

procedure TvtVirtualTaxOfficeOffice.FormShow(Sender: TObject);
var I: integer;
begin
  //20201216 Igor >>>
  if not SameText(FCyberId, VirtualTaxOfficeInfo.CyberId) then
  begin
    for I := 0 to ComponentCount - 1 do
      if Components[I] is TEdit then
        TEdit(Components[I]).ReadOnly := true
      else if Components[I] is TMemo then
        TMemo(Components[I]).ReadOnly := true
      else if Components[I] is TCheckBox then
        TCheckBox(Components[I]).Enabled := false;
    btnSave.Enabled := false;
    cbHaveCRAEfilerNumber.Visible := false;
    lbCRAEfilerName.Visible := false;
    edCRAEfilerName.Visible := false;
  end;
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TEdit then
    begin
      if TEdit(Components[I]).ReadOnly then
        TEdit(Components[I]).Color := ReadonlyColor
    end
    else if TMemo(Components[I]).ReadOnly then
    begin
      if TMemo(Components[I]).ReadOnly then
        TMemo(Components[I]).Color := ReadonlyColor;
    end;
  //20201216 Igor <<<
  LoadProfile;
  edCyberId.Text := FCyberId; //20201221 Igor
end;

procedure TvtVirtualTaxOfficeOffice.LoadProfile;
var FParams: TParamList;
    Res: TJSONObject;

begin
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'LOAD_PROFILE');
    FParams.AddParam('CyberId', FCyberId); //20201216 Igor
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText( GetJSONValue(Res, 'success'), 'true') then
      begin
        edBusinessName.Text := GetJSONValue(Res, 'BusinessName');
        edEmail.Text := GetJSONValue(Res, 'Email');
        edWebSiteUrl.Text := GetJSONValue(Res, 'WebSiteUrl');
        cbHaveCRAEfilerNumber.Checked := SameText(GetJSONValue(Res, 'HaveCRAEfilerNumber'), 'Y');
        edContact.Text := GetJSONValue(Res, 'Contact');
        edCRAEfilerName.Text := GetJSONValue(Res, 'CRAEfilerName');
        edArea.Text := GetJSONValue(Res, 'Area');
        edPhone.Text := GetJSONValue(Res, 'Phone');
        edCell.Text := GetJSONValue(Res, 'Cell');
        edFax.Text := GetJSONValue(Res, 'Fax');
        edStreet.Text := GetJSONValue(Res, 'Street');
        edCity.Text := GetJSONValue(Res, 'City');
        edProvince.Text := GetJSONValue(Res, 'Province');
        edPostal.Text := GetJSONValue(Res, 'Postal');
        edYearsInBusiness.Text := GetJSONValue(Res, 'YearsInBusiness');
        cbT1.Checked := SameText(GetJSONValue(Res, 'T1'), 'Y');
        cbT2.Checked := SameText(GetJSONValue(Res, 'T2'), 'Y');
        cbT3.Checked := SameText(GetJSONValue(Res, 'T3'), 'Y');
        cbT4T5.Checked := SameText(GetJSONValue(Res, 'T4T5'), 'Y');
        cbNR4.Checked := SameText(GetJSONValue(Res, 'NR4'), 'Y');
        cbT3010.Checked := SameText(GetJSONValue(Res, 'T3010'), 'Y');
        cbT5013.Checked := SameText(GetJSONValue(Res, 'T5013'), 'Y');
        cbT5018.Checked := SameText(GetJSONValue(Res, 'T5018'), 'Y');
        cbvtNOA.Checked := SameText(GetJSONValue(Res, 'vtNOA'), 'Y');
        cbOther.Checked := SameText(GetJSONValue(Res, 'Other'), 'Y');
        edOtherServiceDescription.Text := GetJSONValue(Res, 'OtherServiceDescription');
        edExperience.Text := GetJSONValue(Res, 'Experience');
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

function TvtVirtualTaxOfficeOffice.SaveProfile: boolean;
var FParams: TParamList;
    Res: TJSONObject;
begin
  Result := false;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'SAVE_PROFILE');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('BusinessName', edBusinessName.Text);
    FParams.AddParam('Email', edEmail.Text);
    FParams.AddParam('WebSiteUrl', edWebSiteUrl.Text);
    FParams.AddParam('Contact', edContact.Text);
    FParams.AddParam('Area', edArea.Text);
    FParams.AddParam('Phone', edPhone.Text);
    FParams.AddParam('Cell', edCell.Text);
    FParams.AddParam('Fax', edFax.Text);
    FParams.AddParam('Street', edStreet.Text);
    FParams.AddParam('City', edCity.Text);
    FParams.AddParam('Province', edProvince.Text);
    FParams.AddParam('Postal', edPostal.Text);
    FParams.AddParam('HaveCRAEfilerNumber', GetCheckValue(cbHaveCRAEfilerNumber));
    FParams.AddParam('CRAEfilerName', edCRAEfilerName.Text);
    FParams.AddParam('YearsInBusiness', edYearsInBusiness.Text);
    FParams.AddParam('T1', GetCheckValue(cbT1));
    FParams.AddParam('T2', GetCheckValue(cbT2));
    FParams.AddParam('T3', GetCheckValue(cbT3));
    FParams.AddParam('T4T5', GetCheckValue(cbT4T5));
    FParams.AddParam('NR4', GetCheckValue(cbNR4));
    FParams.AddParam('T3010', GetCheckValue(cbT3010));
    FParams.AddParam('T5013', GetCheckValue(cbT5013));
    FParams.AddParam('T5018', GetCheckValue(cbT5018));
    FParams.AddParam('vtNOA', GetCheckValue(cbvtNOA));
    FParams.AddParam('Other', GetCheckValue(cbOther));
    FParams.AddParam('OtherServiceDescription', edOtherServiceDescription.Text);
    FParams.AddParam('Experience', edExperience.Text);
    FParams.AddParam('TeamviewerID', edTeamviewerID.Text);
    FParams.AddParam('VirtualMeetingAlarm', edVirtualMeetingAlarm.Text);
    FParams.AddParam('ZoomVideoID', GetCheckValue(cbZoomVideoId));
    FParams.AddParam('UltraViewerID', edUltraViewerId.Text); //20201221 Igor
    FParams.AddParam('TaxSoftwareNames', edTaxSoftwareNames.Text);

    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        Result := true
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
