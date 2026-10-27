unit T4T5_2026HeaderFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons,vtLabel,vtChild;


type
  THeaderFrameT4T5_2026 = class(TFrame)
    Bevel1: TBevel;
    Panel2: TPanel;
    FormNameLbl: TLabel;
    Panel3: TPanel;
    Pg1: TPanel;
    Pg2: TPanel;
    Pg3: TPanel;
    Pg4: TPanel;
    Pg5: TPanel;
    Pg6: TPanel;
    Panel1: TPanel;
    MultipleDnBtn: TSpeedButton;
    MultipleUpBtn: TSpeedButton;
    ListMultipleBtn: TSpeedButton;
    SectionBtn: TSpeedButton;
    Panel4: TPanel;
    CloseTabBtn: TvtLabel;
    Pg7: TPanel;
    Pg8: TPanel;
    Pg9: TPanel;
    Pg10: TPanel;
    Pg11: TPanel;
    Pg12: TPanel;
    Pg13: TPanel;
    Pg14: TPanel;
    Pg15: TPanel;
    Pg16: TPanel;
    Pg17: TPanel;
    Pg18: TPanel;
    Pg19: TPanel;
    Pg20: TPanel;
    NewSlipBtn: TSpeedButton;
    DeleteSlipBtn: TSpeedButton;
    SortTabsDescendingBtn: TSpeedButton;
    SortTabsAscendingBtn: TSpeedButton;
    procedure MultipleUpBtnClick(Sender: TObject);
    procedure MultipleDnBtnClick(Sender: TObject);
    procedure ListMultipleBtnClick(Sender: TObject);
    procedure CloseTabBtnClick(Sender: TObject);
    procedure PageBtnClick(Sender: TObject);
    procedure SectionBtnClick(Sender: TObject);
    procedure NewSlipBtnClick(Sender: TObject);
    procedure DeleteSlipBtnClick(Sender: TObject);
    procedure SortTabsAscendingBtnClick(Sender: TObject);
  public
    MyChild: TMyChild;
  end;

implementation

{$R *.DFM}

uses vtCommon,T4T5_2026Declare,T4T5_2026Main,T4T5_2026TrimStr,T4T5_2026Common,
  T4T5_2026ChildWinNew,vtTrimStr,vtShared;


procedure THeaderFrameT4T5_2026.MultipleUpBtnClick(Sender: TObject);
begin
  //20171230
 if IsFormMultiInst(MyChild.FormName) = false  then
 Begin
  ShowMessage('Next applies only to multi-instance forms, such as Slips');
  Exit;
 End;
 OpenNextInstance(MyChild.RetNo, MyChild.FormName);
end;

procedure THeaderFrameT4T5_2026.MultipleDnBtnClick(Sender: TObject);
begin
  //20171230
 if IsFormMultiInst(MyChild.FormName) = false  then
 Begin
  ShowMessage('Previous applies only to multi-instance forms, such as Slips');
  Exit;
 End;
 OpenPrevInstance(MyChild.RetNo, MyChild.FormName);
end;


procedure THeaderFrameT4T5_2026.ListMultipleBtnClick(Sender: TObject);
begin
   //20171230
 if IsFormMultiInst(MyChild.FormName) = false  then
 Begin
  ShowMessage('List applies only to multi-instance forms, such as Slips');
  Exit;
 End;

 MainFormT4T5.ListMultipleBtnClick(Sender);
end;

procedure THeaderFrameT4T5_2026.CloseTabBtnClick(Sender: TObject);
begin
  MyChild.CloseActiveForm(Sender);
end;

procedure THeaderFrameT4T5_2026.PageBtnClick(Sender: TObject);
begin
  MyChild.Pg1Click(Sender);
end;

procedure THeaderFrameT4T5_2026.SectionBtnClick(Sender: TObject);
begin
  MyChild.GoToSection;
end;

procedure THeaderFrameT4T5_2026.SortTabsAscendingBtnClick(Sender: TObject);
begin
  MyChild.SortTabsAscDesc(Sender);
end;

procedure THeaderFrameT4T5_2026.NewSlipBtnClick(Sender: TObject);
begin
 //20171230
 if IsFormMultiInst(MyChild.FormName) = false  then
 Begin
  ShowMessage('New applies only to multi-instance forms, such as Slips');
  Exit;
 End;
 AddNewInstance(MyChild.RetNo,MyChild.FormName);
end;

procedure THeaderFrameT4T5_2026.DeleteSlipBtnClick(Sender: TObject);
Var i:Integer; RNo:Integer;
begin
 //20171230
 if IsFormMultiInst(MyChild.FormName) = false  then
 Begin
  ShowMessage('Delete applies only to multi-instance forms, such as Slips');
  Exit;
 End;

 //20171231
 if MessageDlg('Delete all data from this form?',mtInformation, [mbYes, mbNo], 0) = mrYes then
 Begin
  RNo:=GetCurrentRetNo;
  //20180102 Igor>>>
  DeleteInstance(RNo, MyChild.FormName);
//  for i:=0 to 100 do StoreElm(RNo,MyChild.FormNo,i,'');
//  OpenForm(RNo,MyChild.FormName,0)
 // ShowMessage('Right click and select Clear Current Form');
 //20180102 Igor<<<
 End;
end;

end.
