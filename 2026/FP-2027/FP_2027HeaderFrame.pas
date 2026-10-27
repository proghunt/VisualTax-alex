unit FP_2027HeaderFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons,vtLabel,vtChild;


type
  THeaderFrameFP_2027 = class(TFrame)
    Bevel1: TBevel;
    Panel2: TPanel;
    ReturnNameLbl: TLabel;
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
    SortTabsDescendingBtn: TSpeedButton;
    SortTabsAscendingBtn: TSpeedButton;
    procedure MultipleUpBtnClick(Sender: TObject);
    procedure MultipleDnBtnClick(Sender: TObject);
    procedure ListMultipleBtnClick(Sender: TObject);
    procedure SortTabsAscendingBtnClick(Sender: TObject);
  public
    MyChild: TMyChild;
  end;

implementation

{$R *.DFM}

uses vtCommon,FP_2027Declare,FP_2027Main,FP_2027TrimStr,FP_2027Common,
  FP_2027ChildWinNew,vtTrimStr,vtShared;

procedure THeaderFrameFP_2027.MultipleUpBtnClick(Sender: TObject);
begin
 OpenNextInstance(MyChild.RetNo,MyChild.FormName);
end;

procedure THeaderFrameFP_2027.SortTabsAscendingBtnClick(Sender: TObject);
begin
  MyChild.SortTabsAscDesc(Sender);
end;

procedure THeaderFrameFP_2027.MultipleDnBtnClick(Sender: TObject);
begin
 OpenPrevInstance(MyChild.RetNo,MyChild.FormName);
end;

procedure THeaderFrameFP_2027.ListMultipleBtnClick(Sender: TObject);
begin
 MainFormFP.ListMultipleBtnClick(Sender);
end;

end.
