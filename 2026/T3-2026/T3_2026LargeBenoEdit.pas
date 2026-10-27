unit T3_2026LargeBenoEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Dialogs,
  ExtCtrls, Menus, ComCtrls, OleCtrls, Buttons, ToolWin,
  ActnList, ImgList, shdocvw, Printers, Db, DBTables, ActiveX,
  T3_2026Declare, T3_2026TrimStr, T3_2026Common,
  T3_2026Common2, ShellApi, T3_2026ChildWinNew, FileCtrl,
  StrUtils, uADCompClient, Variants, IOUtils, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, Vcl.Mask, Vcl.DBCtrls;

type
  TLargeBenoEditT3_2026 = class(TForm)
    PanelBottom: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    dsQ: TDataSource;
    Q: TADQuery;
    pnlContent: TPanel;
    rgEntityAction: TDBRadioGroup;
    rgEntityType: TDBRadioGroup;
    rgEntityClassification: TDBRadioGroup;
    gbEntityName: TGroupBox;
    edName: TDBEdit;
    gbFirstName: TGroupBox;
    edFirstName: TDBEdit;
    gbLastName: TGroupBox;
    edLastName: TDBEdit;
    gbDateOfBirth: TGroupBox;
    edDateOfBirth: TDBEdit;
    qProvince: TADMemTable;
    qCountry: TADMemTable;
    gbTaxIdentificationNumber: TGroupBox;
    rbSIN: TRadioButton;
    rbTTN: TRadioButton;
    rbITN: TRadioButton;
    rbBN: TRadioButton;
    rbTN: TRadioButton;
    rbInternational: TRadioButton;
    edTaxIdentificationNumber: TDBEdit;
    gbCountryOfResidence: TGroupBox;
    lcbCountryOfResidence: TDBLookupComboBox;
    GroupBox7: TGroupBox;
    edAddress: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    lcbCountry: TDBLookupComboBox;
    Label3: TLabel;
    edCity: TDBEdit;
    Label4: TLabel;
    lcbProvince: TDBLookupComboBox;
    Label5: TLabel;
    edGlobalPostalZipCode: TDBEdit;
    cbEntityAssociationEndAction: TDBCheckBox;
    qCountryCode: TStringField;
    qCountryName: TStringField;
    qProvinceCode: TStringField;
    qProvinceName: TStringField;
    dsProvince: TDataSource;
    dsCountry: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbSINClick(Sender: TObject);
  private
    { Private declarations }
    FID: integer;
    FTrustAccountNumber: string;
    FTrustName: string;
    FNeedRefresh: boolean;
    FRefreshing: boolean;
    procedure InitDicts;
    procedure QRefresh;
    function CheckEdit(const AOk: Boolean): boolean;
  public
    { Public declarations }
    class function Execute(var AID: Integer; AConnection: TADConnection; ATrustAccountNumber, ATrustName: string): boolean;
  end;

implementation

{$R *.dfm}

function TLargeBenoEditT3_2026.CheckEdit(const AOk: Boolean): boolean;
var nResult : Integer;
begin
  Result := false;
  OkBtn.SetFocus;
  if (Q.State = dsEdit) or (Q.State = dsInsert) then
  begin
    if AOk then
    begin
      if MessageDlg('Data was changed. Do you want to save it ?',
                  mtWarning, mbYesNo, 0) = mrYes then
        nResult := mrOk
      else
        nResult := mrNo;
    end
    else
      nResult := mrOk;
    if (Q.State = dsEdit) or (Q.State = dsInsert) then
    begin
      if nResult = mrOk then
      begin
        if Q.FieldByName('EntityAction').AsString.IsEmpty then
        begin
          rgEntityAction.SetFocus;
          ShowMessage('You need to enter Entity Action');
          Result := False;
        end
        else if Q.FieldByName('EntityType').AsString.IsEmpty then
        begin
          rgEntityType.SetFocus;
          ShowMessage('You need to enter Entity Type');
          Result := False;
        end
        else if Q.FieldByName('EntityClassification').AsString.IsEmpty then
        begin
          rgEntityClassification.SetFocus;
          ShowMessage('You need to enter Entity Classification');
          Result := False;
        end
        else if (Q.FieldByName('EntityClassification').AsString <> 'N')
                and
                Q.FieldByName('NotNaturalPersonEntityName').AsString.IsEmpty then
        begin
          edName.SetFocus;
          ShowMessage('You need to enter Name');
          Result := False;
        end
        else if (Q.FieldByName('EntityClassification').AsString = 'N')
                and
                Q.FieldByName('NaturalPersonGivenName').AsString.IsEmpty then
        begin
          edFirstName.SetFocus;
          ShowMessage('You need to enter First Name');
          Result := False;
        end
        else if (Q.FieldByName('EntityClassification').AsString = 'N')
                and
                Q.FieldByName('NaturalPersonFamilyName').AsString.IsEmpty then
        begin
          edLastName.SetFocus;
          ShowMessage('You need to enter Last Name');
          Result := False;
        end
        else if (Q.FieldByName('EntityClassification').AsString = 'N')
                and
                Q.FieldByName('NaturalPersonBirthDate').AsString.IsEmpty then
        begin
          edDateOfBirth.SetFocus;
          ShowMessage('You need to enter Date of birth');
          Result := False;
        end
        else
        begin
          try
            Result := True;
            Q.Post;
            FNeedRefresh := true;
          except on E: Exception do
            begin
              ShowMessage(E.Message);
              Result := False;
              Exit;
            end;
          end;
          FID := Q.FieldByName('Id').AsInteger;
        end;
      end
      else
      begin
        Q.Cancel;
        Result := True;
      end;
    end
  end
  else
    Result := True;
end;

class function TLargeBenoEditT3_2026.Execute(var AID: Integer; AConnection: TADConnection;
  ATrustAccountNumber, ATrustName: string): boolean;
begin
  with Self.Create(Application) do
  begin
    try
      FID := AID;
      FTrustAccountNumber := ATrustAccountNumber;
      FTrustName := ATrustName;
      Q.Connection := AConnection;
      ShowModal;
      Result := FNeedRefresh;
      if Result then
        AID := FID;
    finally
      Free;
    end;
  end;
end;

procedure TLargeBenoEditT3_2026.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CancelBtn.SetFocus;
  if (ModalResult = mrOk) then
  begin
    if not CheckEdit(False) then
    begin
      ModalResult := 0;
      Action := caNone;
    end;
  end else
  begin
    if (Q.State = dsInsert) and Q.FieldByName('EntityAction').IsNull then
      Exit;
    if not CheckEdit(True) then
    begin
      ModalResult := 0;
      Action := caNone;
    end;
  end;
end;

procedure TLargeBenoEditT3_2026.FormShow(Sender: TObject);
begin
  edName.SetFocus;
  if FID = 0 then
    Caption := 'Add new Beno Entity'
  else
    Caption := 'Edit Beno Entity';
  InitDicts;
  QRefresh;
end;

procedure TLargeBenoEditT3_2026.InitDicts;
var L: TStringList;
    LCode, LName: string;
    I, J: integer;
begin
  L := TStringList.Create;
  try
    qCountry.Close;
    qCountry.Open;
    L.LoadFromFile(AppDir+'\'+'FCountry.d');
    for J := 1 to 3 do
      for I := 0 to L.Count - 1 do
      begin
        LCode := Copy(L.Strings[I], 1, 3);
        LName := L.Strings[I];
        if LCode.IsEmpty then continue;
        if J = 1 then
        begin
          if SameText(LCode, 'CAN') then
          begin
            qCountry.Append;
            qCountry.FieldByName('Code').AsString := LCode;
            qCountry.FieldByName('Name').AsString := LName;
            qCountry.Post;
            break;
          end;
        end
        else if J = 2 then
        begin
          if SameText(LCode, 'USA') then
          begin
            qCountry.Append;
            qCountry.FieldByName('Code').AsString := LCode;
            qCountry.FieldByName('Name').AsString := LName;
            qCountry.Post;
            break;
          end;
        end
        else
        begin
          if not SameText(LCode, 'CAN') and not SameText(LCode, 'USA') then
          begin
            qCountry.Append;
            qCountry.FieldByName('Code').AsString := LCode;
            qCountry.FieldByName('Name').AsString := LName;
            qCountry.Post;
          end;
        end
      end;

    qProvince.Close;
    qProvince.Open;
    L.LoadFromFile(AppDir+'\'+'State.d');
    for I := 0 to L.Count - 1 do
    begin
      LCode := Copy(L.Strings[I], 1, 2);
      LName := L.Strings[I];
      if LCode.IsEmpty then continue;
      qProvince.Append;
      qProvince.FieldByName('Code').AsString := LCode;
      qProvince.FieldByName('Name').AsString := LName;
      qProvince.Post;
    end;
  finally
    L.Free;
  end;
end;

procedure TLargeBenoEditT3_2026.QRefresh;
begin
  FRefreshing := true;
  try
    Q.Close;
    Q.ParamByName('ID').Value := FID;
    Q.Open;
    if Q.RecordCount = 0 then
    begin
      Q.Append;
      Q.FieldByName('TrustAccountNumber').AsString := FTrustAccountNumber;
      Q.FieldByName('TrustName').AsString := FTrustName;
      Q.FieldByName('EntityAssociationEndAction').AsBoolean := false;
    end;
    rbSIN.Checked := SameText(Q.FieldByName('TaxIdentificationNumberType').AsString, 'SIN');
    rbTTN.Checked := SameText(Q.FieldByName('TaxIdentificationNumberType').AsString, 'TTN');
    rbITN.Checked := SameText(Q.FieldByName('TaxIdentificationNumberType').AsString, 'ITN');
    rbBN.Checked := SameText(Q.FieldByName('TaxIdentificationNumberType').AsString, 'BN');
    rbTN.Checked := SameText(Q.FieldByName('TaxIdentificationNumberType').AsString, 'TN');
    rbInternational.Checked := SameText(Q.FieldByName('TaxIdentificationNumberType').AsString, 'INTERNATIONAL');
  finally
    FRefreshing := false;
  end;
end;

procedure TLargeBenoEditT3_2026.rbSINClick(Sender: TObject);
var LValue: string;
begin
  if FRefreshing then Exit;
  LValue := '';
  if Sender = rbSIN then
    LValue := 'SIN'
  else if Sender = rbTTN then
    LValue := 'TTN'
  else if Sender = rbITN then
    LValue := 'ITN'
  else if Sender = rbBN then
    LValue := 'BN'
  else if Sender = rbTN then
    LValue := 'TN'
  else if Sender = rbInternational then
    LValue := 'INTERNATIONAL';
  if not (Q.State in [dsInsert, dsEdit]) then
    Q.Edit;
  Q.FieldByName('TaxIdentificationNumberType').Value := LValue;
end;

end.
