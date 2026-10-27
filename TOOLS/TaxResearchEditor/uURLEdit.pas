unit uURLEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uADStanIntf, uADStanOption,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf,
  uADStanAsync, uADDAptManager, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Data.DB,
  uADCompDataSet, uADCompClient, System.UITypes;

type
  TURLEdit = class(TForm)
    Q: TADQuery;
    dsQ: TDataSource;
    Label1: TLabel;
    edCaption: TDBEdit;
    btnOk: TButton;
    btnCancel: TButton;
    QId: TADAutoIncField;
    QCaption: TStringField;
    QURL: TStringField;
    QParentTitleId: TIntegerField;
    QSeqNo: TIntegerField;
    Label2: TLabel;
    edURL: TDBEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    NeedRefresh: boolean;
    ID: integer;
    ParentTitleId: integer;
  public
    { Public declarations }
    function CheckEdit(const AOk : Boolean): boolean;
  end;

function EditURL(AID, AParentTitleId: integer): boolean;

implementation

{$R *.dfm}

uses uData;

function EditURL(AID, AParentTitleId: integer): boolean;
var
  URLEdit: TURLEdit;
begin
  URLEdit := TURLEdit.Create(Screen.ActiveForm);
  try
    URLEdit.Id := AID;
    URLEdit.ParentTitleId := AParentTitleId;
    URLEdit.ShowModal;
    Result := URLEdit.NeedRefresh;
  finally
    URLEdit.Free;
  end;
end;

function TURLEdit.CheckEdit(const AOk: Boolean): boolean;
var nResult : Integer;
begin
  Result := false;
  btnCancel.SetFocus;
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
        if Q.FieldByName('Caption').AsString = '' then
        begin
          edCaption.SetFocus;
          ShowMessage('You need to specify Title.');
          Result := False;
        end
        else if Q.FieldByName('URL').AsString = '' then
        begin
          edURL.SetFocus;
          ShowMessage('You need to specify URL.');
          Result := False;
        end
        else
        begin
          try
            Result := True;
            Q.Post;
            NeedRefresh := true;
          except
            Result := False;
            Exit;
          end;
          ID := Q.FieldByName('Id').AsInteger;
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

procedure TURLEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (ModalResult = mrOk) then
  begin
    if not CheckEdit(False) then
    begin
      ModalResult := 0;
      Action := caNone;
    end;
  end else
  begin
    if not CheckEdit(True) then
    begin
      ModalResult := 0;
      Action := caNone;
    end;
  end;
end;

procedure TURLEdit.FormShow(Sender: TObject);
begin
  NeedRefresh := false;
  Q.Close;
  Q.ParamByName('ID').Value := ID;
  Q.Open;
  if Q.RecordCount = 0 then
  begin
    Q.Append;
    if ParentTitleId <> 0 then
      Q.FieldByName('ParentTitleId').Value := ParentTitleId;
    Q.FieldByName('SeqNo').AsInteger := dmData.GetMaxURLSeqNo(ParentTitleId) + 1;
  end;
end;

end.
