unit frmKeyItems;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, vtKeyList;

type
  TfrmKey = class(TForm)
    pnlMain: TPanel;
    aList: TListView;
    pnlButton: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    KeyItems: array of integer;
    procedure LoadListView(aAppID: string);
  end;

function ShowKeyItems(const AppID: string; out aKeyItems: TArrInteger): boolean;

implementation

function ShowKeyItems(const AppID: string; out aKeyItems: TArrInteger): boolean;
var
  frm: TfrmKey;
  i: integer;
begin
  frm := TfrmKey.Create(Application.MainForm);
  try
    frm.LoadListView(AppID);
    if frm.ShowModal = mrOk then
    begin
      SetLength(aKeyItems, Length(frm.KeyItems));
      for i := 0 to Length(frm.KeyItems) - 1 do
        aKeyItems[i] := frm.KeyItems[i];
      Result := True;
    end
    else
      Result := False;
  finally
    frm.Free;
  end;
end;

{$R *.DFM}

{ TfrmKey }

procedure TfrmKey.LoadListView(aAppID: string);
var
  Item: TListItem;
  i: Integer;
begin
  aList.Columns.Clear;
  aList.Items.Clear;
  aList.Columns.Add.Caption := 'Name';
  aList.Columns[0].Width := -1;
  aList.Columns.Add.Caption := 'Desc';
  aList.Columns[1].Width := -1;
  for I := 0 to Length(KeyList) - 1 do
  begin
    if KeyList[i].AppID = AAppID then
    begin
      Item := aList.Items.Add;
      Item.Data := Pointer(KeyList[i].ID);
      Item.Caption := KeyList[i].ShortName;
      Item.SubItems.Add(ArrToString(KeyList[i].FormList));
    end;
  end;
end;

procedure TfrmKey.btnOkClick(Sender: TObject);
var
  i: integer;
begin
  SetLength(KeyItems, 0);
  for i := 0 to aList.Items.Count - 1 do
    if aList.Items[i].Checked then begin
      SetLength(KeyItems, Length(KeyItems) + 1);
      KeyItems[Length(KeyItems) - 1] := Integer(aList.Items[i].Data);
    end;
end;

end.
