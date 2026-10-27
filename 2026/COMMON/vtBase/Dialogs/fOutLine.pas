unit fOutLine;

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, Outline, ExtCtrls;

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

  public
    RetNo: Integer;
    Selected: string;
  end;

  //var  OutlnList: TOutlnListT1_2012;

implementation

{$R *.DFM}

uses
  vtCommon,
  //T1_2012Declare,T1_2012TrimStr,T1_2012Common,
  //T1_2012ChildWinNew,
  vtTrimStr, vtShared;

procedure TOutlnList.FormCreate(Sender: TObject);
//var i : integer;
begin
  {
   RetNo:=GetCurrentRetNo;
   OutlnList.Color := GetRetColor(RetNo);
   OutlnList.Caption := SomeCaption;
   For i:= 0 to SomeList.Count -1 do Outline1.Lines.Add(SomeList[i]);
   OutLine1.FullExpand;
   Outline1.SelectedItem := 0;
  }
end;

procedure TOutlnList.OKBtnClick(Sender: TObject);
begin
  if Outline1.SelectedItem > -1 then
    Selected := Outline1.Items[Outline1.SelectedItem].Text
  else
    Selected := '';
  Close;
end;

procedure TOutlnList.CancelBtnClick(Sender: TObject);
begin
  Selected := '';
  Close;
end;

procedure TOutlnList.Outline1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;

procedure TOutlnList.Outline1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    Outline1DblClick(Sender);
end;

end.

