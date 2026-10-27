unit T3_2026HeaderFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons,vtLabel,vtChild;


type
  THeaderFrameT3_2026 = class(TFrame)
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
    SortTabsDescendingBtn: TSpeedButton;
    SortTabsAscendingBtn: TSpeedButton;
    procedure MultipleUpBtnClick(Sender: TObject);
    procedure MultipleDnBtnClick(Sender: TObject);
    procedure ListMultipleBtnClick(Sender: TObject);
    procedure CloseTabBtnClick(Sender: TObject);
    procedure PageBtnClick(Sender: TObject);
    procedure SectionBtnClick(Sender: TObject);
    procedure SortTabsAscendingBtnClick(Sender: TObject);
  public
    MyChild: TMyChild;
  end;

implementation

{$R *.DFM}

uses vtCommon,T3_2026Declare,T3_2026Main,T3_2026TrimStr,T3_2026Common,
  T3_2026ChildWinNew,vtTrimStr,vtShared;


procedure THeaderFrameT3_2026.MultipleUpBtnClick(Sender: TObject);
begin
  OpenNextInstance(MyChild.RetNo, MyChild.FormName);
end;

procedure THeaderFrameT3_2026.SortTabsAscendingBtnClick(Sender: TObject);
begin
  MyChild.SortTabsAscDesc(Sender);
end;

procedure THeaderFrameT3_2026.MultipleDnBtnClick(Sender: TObject);
begin
  OpenPrevInstance(MyChild.RetNo, MyChild.FormName);
end;

procedure THeaderFrameT3_2026.ListMultipleBtnClick(Sender: TObject);
begin
 MainFormT3.ListMultipleBtnClick(Sender);
end;

procedure THeaderFrameT3_2026.CloseTabBtnClick(Sender: TObject);
begin
  MyChild.CloseActiveForm(Sender);
end;

procedure THeaderFrameT3_2026.PageBtnClick(Sender: TObject);
begin
  MyChild.Pg1Click(Sender);
end;

procedure THeaderFrameT3_2026.SectionBtnClick(Sender: TObject);
begin
  MyChild.GoToSection;
end;

end.
