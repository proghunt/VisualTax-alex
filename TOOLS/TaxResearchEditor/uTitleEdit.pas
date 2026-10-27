unit uTitleEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uADStanIntf, uADStanOption,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf,
  uADStanAsync, uADDAptManager, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Data.DB,
  uADCompDataSet, uADCompClient, System.UITypes;

type
  TTitleEdit = class(TForm)
    Q: TADQuery;
    dsQ: TDataSource;
    Label1: TLabel;
    edTitle: TDBEdit;
    btnOk: TButton;
    btnCancel: TButton;
    QId: TADAutoIncField;
    QTitle: TStringField;
    QParentTitleId: TIntegerField;
    QSeqNo: TIntegerField;
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

function EditTitle(AID, AParentTitleId: integer): boolean;

implementation

{$R *.dfm}

uses uData;

function EditTitle(AID, AParentTitleId: integer): boolean;
var
  TitleEdit: TTitleEdit;
begin
  TitleEdit := TTitleEdit.Create(Screen.ActiveForm);
  try
    TitleEdit.Id := AID;
    TitleEdit.ParentTitleId := AParentTitleId;
    TitleEdit.ShowModal;
    Result := TitleEdit.NeedRefresh;
  finally
    TitleEdit.Free;
  end;
end;

function TTitleEdit.CheckEdit(const AOk: Boolean): boolean;
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
        if Q.FieldByName('Title').AsString = '' then
        begin
          edTitle.SetFocus;
          ShowMessage('You need to specify Title.');
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

procedure TTitleEdit.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TTitleEdit.FormShow(Sender: TObject);
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
    Q.FieldByName('SeqNo').AsInteger := dmData.GetMaxTitleSeqNo(ParentTitleId) + 1;
  end;
end;

end.
