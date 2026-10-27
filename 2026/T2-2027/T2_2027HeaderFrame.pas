unit T2_2027HeaderFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons,vtLabel,vtChild;


type
  THeaderFrameT2_2027 = class(TFrame)
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
    SortTabsAscendingBtn: TSpeedButton;
    SortTabsDescendingBtn: TSpeedButton;
    procedure MultipleUpBtnClick(Sender: TObject);
    procedure MultipleDnBtnClick(Sender: TObject);
    procedure ListMultipleBtnClick(Sender: TObject);
    procedure SortTabsAscendingBtnClick(Sender: TObject);
  private
    FMyChild: TMyChild;
    procedure SetMyChild(const Value: TMyChild);
  public
    property MyChild: TMyChild read FMyChild write SetMyChild;
  end;

implementation

{$R *.DFM}
uses T2_2027Declare,T2_2027Main,T2_2027TrimStr,T2_2027Common,T2_2027ChildWinNew,
  vtCommon,vtTrimStr,vtShared;

procedure THeaderFrameT2_2027.MultipleUpBtnClick(Sender: TObject);
begin
 OpenNextInstance(MyChild.RetNo, MyChild.FormName);
end;

procedure THeaderFrameT2_2027.SortTabsAscendingBtnClick(Sender: TObject);
begin
  MyChild.SortTabsAscDesc(Sender);
end;

procedure THeaderFrameT2_2027.MultipleDnBtnClick(Sender: TObject);
begin
 OpenPrevInstance(MyChild.RetNo, MyChild.FormName);
end;

procedure THeaderFrameT2_2027.ListMultipleBtnClick(Sender: TObject);
begin
 MainFormT2.ListMultipleBtnClick(Sender);
end;

procedure THeaderFrameT2_2027.SetMyChild(const Value: TMyChild);
begin
  FMyChild := Value;
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
 Pg11.onClick := MyChild.Pg1Click;
 Pg12.onClick := MyChild.Pg1Click;
 Pg13.onClick := MyChild.Pg1Click;
 Pg14.onClick := MyChild.Pg1Click;
 Pg15.onClick := MyChild.Pg1Click;
 Pg16.onClick := MyChild.Pg1Click;
 Pg17.onClick := MyChild.Pg1Click;
 Pg18.onClick := MyChild.Pg1Click;
 Pg19.onClick := MyChild.Pg1Click;
 Pg20.onClick := MyChild.Pg1Click;
end;

end.
