unit Uoutline;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Grids, Outline,
  UDeclare,TrimStr, ExtCtrls;

type
  TOutlnList = class(TForm)
    Outline1: TOutline;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Outline1DblClick(Sender: TObject);
    procedure Outline1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OutlnList: TOutlnList;

implementation

{$R *.DFM}

procedure TOutlnList.OKBtnClick(Sender: TObject);
Var
i :integer;
begin
If Outline1.SelectedItem >-1 then
  SelectedString := Outline1.Items[Outline1.SelectedItem].Text
Else SelectedString :='';
Close;
end;

procedure TOutlnList.CancelBtnClick(Sender: TObject);
begin
SelectedString := '';
Close;
end;

procedure TOutlnList.FormCreate(Sender: TObject);
var
i : integer;
begin
 {Outline1.Top := Self.Top + 30;}
 OutlnList.Caption := SomeCaption;
 For i:= 0 to SomeList.Count -1 do
  Outline1.Lines.Add(SomeList[i]);
 OutLine1.FullExpand;
 Outline1.SelectedItem := 0;
end;

procedure TOutlnList.Outline1DblClick(Sender: TObject);
begin
OKBtnClick(Sender);
end;

procedure TOutlnList.Outline1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then Outline1DblClick(Sender);
end;

end.
