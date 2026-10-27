unit fSignOffWarnings;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type
  TSignOffWarnings = class(TForm)
    Panel2: TPanel;
    ListBox1: TListBox;
    AllBtn: TBitBtn;
    OneOnlyBtn: TBitBtn;
    CancelBtn: TBitBtn;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    ReverseSignOffBtn: TBitBtn;
    LocateFormBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure OneOnlyBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure InitListBox;
    procedure AllBtnClick(Sender: TObject);
    procedure ReverseSignOffBtnClick(Sender: TObject);
    procedure LocateFormBtnClick(Sender: TObject);
  private
  public
    RetNo: integer;
  end;

function SignOffWarnings(RNo: integer): boolean;

implementation

{$R *.DFM}

uses
  vtMulti,
  vtCommon, vtMain,
  vtTrimStr, vtShared;

function SignOffWarnings(RNo: integer): boolean;
begin
  with TSignOffWarnings.Create(Application) do
  begin
    RetList[RNo].AuditList.BeginUpdate;
    RetNo := RNo;
    Result := ShowModal = mrOK;
    Release;
    RetList[RNo].AuditList.EndUpdate; //update everything
  end;
end;

procedure TSignOffWarnings.FormShow(Sender: TObject);
begin
  InitListBox;
end;

procedure TSignOffWarnings.InitListBox;
var
  i: integer;
begin
  ListBox1.Items.clear;
  with RetList[RetNo] do
  begin
    for i := 0 to AuditList.Count - 1 do
    begin
      if AuditRec[i].Category = 'W' then
        ListBox1.Items.AddObject(AuditRec[i].Description, AuditRec[i]);
    end;
  end;
  if ListBox1.items.count > 0 then
    ListBox1.ItemIndex := 0;
end;

procedure TSignOffWarnings.OneOnlyBtnClick(Sender: TObject);
var
  i: integer;
begin
  if ListBox1.ItemIndex < 0 then
  begin
    UserMsg('Please select an item or double click to sign off');
    Exit;
  end;

  for i := ListBox1.Items.Count - 1 downto 0 do
  begin
    if ListBox1.Selected[i] then
    begin
      //SignItOff(ListBox1.Items[i]);
      SignOffAWarning(RetNo, TAuditRec(ListBox1.Items.Objects[i]));
      ListBox1.Items.Delete(i);
      //If ListBox1.items.Count>0 then ListBox1.ItemIndex:=0;
    end;
  end;
end;

procedure TSignOffWarnings.ListBox1DblClick(Sender: TObject);
begin
  OneOnlyBtnClick(Sender);
end;

procedure TSignOffWarnings.AllBtnClick(Sender: TObject);
var
  k: Integer;
begin
  for k := 0 to RetList[Retno].AuditList.Count - 1 do
  begin
    if RetList[RetNo].AuditRec[k].Category = 'W' then
    begin
      RetList[RetNo].AuditRec[k].Category := 'O';
      RetList[RetNo].AuditList.Changed := True;
    end;
  end;
  Close;
end;

procedure TSignOffWarnings.ReverseSignOffBtnClick(Sender: TObject);
var
  k: integer;
begin
  for k := 0 to RetList[Retno].AuditList.Count - 1 do
  begin
    if RetList[RetNo].AuditRec[k].Category = 'O' then
    begin
      RetList[RetNo].AuditRec[k].Category := 'W';
      RetList[RetNo].AuditList.Changed := True;
    end;
  end;
  Close;
end;

procedure TSignOffWarnings.LocateFormBtnClick(Sender: TObject);
var
  i: Integer;
  AuditRec: TAuditRec;
begin
  i := ListBox1.ItemIndex;
  if i < 0 then
  begin
    ShowMessage('Please select an item or double click to sign off');
    Exit;
  end;

  TObject(AuditRec) := ListBox1.Items.Objects[i];
  OpenForm(RetNo, AuditRec.Form, AuditRec.Elm);
  Close;
end;

end.

