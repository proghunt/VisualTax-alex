unit T1_2026HeaderFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons,vtLabel,vtChild;


type
  THeaderFrameT1_2026 = class(TFrame)
    Bevel1: TBevel;
    Panel2: TPanel;
    ReturnNameLbl: TLabel;
    FormNameLbl: TLabel;
    CplBtn: TPanel;
    LastYearIndicator: TPanel;
    PageContainer: TPanel;
    Pg1: TPanel;
    Pg2: TPanel;
    Pg3: TPanel;
    Pg4: TPanel;
    Pg5: TPanel;
    Pg6: TPanel;
    Panel4: TPanel;
    CloseTabBtn: TvtLabel;
    Pg7: TPanel;
    Pg8: TPanel;
    Pg9: TPanel;
    Pg10: TPanel;
    MinTaxBtn: TPanel;
    Panel1: TPanel;
    MultipleDnBtn: TSpeedButton;
    MultipleUpBtn: TSpeedButton;
    SectionBtn: TSpeedButton;
    ListMultipleBtn: TSpeedButton;
    SortTabsDescendingBtn: TSpeedButton;
    SortTabsAscendingBtn: TSpeedButton;
    procedure MultipleUpBtnClick(Sender: TObject);
    procedure MultipleDnBtnClick(Sender: TObject);
    procedure ListMultipleBtnClick(Sender: TObject);
    procedure CplBtnClick(Sender: TObject);
    procedure MinTaxBtnClick(Sender: TObject);

    procedure CloseTabBtnClick(Sender: TObject);
    procedure SortTabsAscendingBtnClick(Sender: TObject);
  private
    FMyChild: TMyChild;
    procedure SetMyChild(const Value: TMyChild);
  public
    property MyChild: TMyChild read FMyChild write SetMyChild;
  end;

implementation

{$R *.DFM}
uses vtCommon,T1_2026,T1_2026Declare,T1_2026Main,T1_2026TrimStr,T1_2026Common,
  T1_2026ChildWinNew,vtTrimStr,vtShared;


procedure THeaderFrameT1_2026.MultipleUpBtnClick(Sender: TObject);
begin
 If ret[MyChild.RetNo].IsLastYearReturn then
  begin MultipleUpBtn.Visible:=False;Exit;End  //20110227
  else
   MultipleUpBtn.Visible:=True;  //20110227
 OpenNextInstance(MyChild.RetNo, MyChild.FormName);
end;

procedure THeaderFrameT1_2026.SortTabsAscendingBtnClick(Sender: TObject);
begin
  MyChild.SortTabsAscDesc(Sender);
end;

procedure THeaderFrameT1_2026.MultipleDnBtnClick(Sender: TObject);
begin
  If ret[MyChild.RetNo].IsLastYearReturn then
   begin MultipleDnbtn.Visible:=False;Exit;End  //20110227
  else
   MultipleDnbtn.Visible:=True;  //20110227
  OpenPrevInstance(MyChild.RetNo, MyChild.FormName);
end;

procedure THeaderFrameT1_2026.ListMultipleBtnClick(Sender: TObject);
begin
 If ret[MyChild.RetNo].IsLastYearReturn then
  begin ListMultipleBtn.Visible:=False;Exit;End  //20110227
 else
  ListMultipleBtn.Visible:=True;  //20110227
 MainFormT1.ListMultipleBtnClick(Sender);
end;

procedure THeaderFrameT1_2026.CplBtnClick(Sender: TObject);
begin
  Ret[MyChild.RetNo].CouplingSw := False;
  CplBtn.Visible:=False;
  MainFormT1.EndCoupling1Click(Sender);
end;

procedure THeaderFrameT1_2026.MinTaxBtnClick(Sender: TObject);
begin
 OpenForm(MyChild.RetNo,'T691',0);
end;

procedure THeaderFrameT1_2026.CloseTabBtnClick(Sender: TObject);
begin
//not used any more
  //MyChild.CloseActiveForm(Sender);
end;

procedure THeaderFrameT1_2026.SetMyChild(const Value: TMyChild);
begin
  FMyChild := Value;
//init handlers
 Pg1.onClick := MyChild.Pg1Click;
 Pg2.onClick := MyChild.Pg1Click;
 Pg3.onClick := MyChild.Pg1Click;
 Pg4.onClick := MyChild.Pg1Click;
 Pg5.onClick := MyChild.Pg1Click;
 Pg6.onClick := MyChild.Pg1Click;
 Pg7.onClick := MyChild.Pg1Click;
 Pg8.onClick := MyChild.Pg1Click;
 Pg9.onClick := MyChild.Pg1Click;
 Pg10.onClick := MyChild.Pg1Click;
end;

end.
