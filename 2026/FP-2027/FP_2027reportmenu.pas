unit FP_2027reportmenu;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Db,FP_2027Declare,//20150819 IgorQuickRpt,qrextra,
  Buttons;

type
  TReportMenuFP_2012 = class(TForm)
    Preview: TButton;
    Print: TButton;
    Exit: TButton;
    ReportList: TRadioGroup;
    procedure PreviewClick(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    
  private
   {
    FReport : TQuickRep;
    procedure SetReport(Value : TQuickRep);
   }
  public
   { property Report : TQuickRep read FReport write SetReport;}

  end;

var
  ReportMenu: TReportMenuFP_2012;
//20150819 Igor  Report : TQuickRep;
  
implementation

{$R *.DFM}

uses vtCommon,FP_2027,
{$IFDEF ADO}
  FP_2012RepClientList,FP_2012RepALLTransactions,
{$ELSE}
{$ENDIF}
  FP_2027TrimStr,vtTrimStr,vtShared;

{
procedure TReportMenu.SetReport(Value : TQuickRep);
begin
  FReport:=Value;
end;
}
procedure TReportMenuFP_2012.ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TReportMenuFP_2012.PreviewClick(Sender: TObject);
begin
 Case ReportList.ItemIndex of
 0:
   begin
   {$IFDEF ADO}
    Application.CreateForm(TRepClientList,RepClientList);
    Report := RepClientList.QuickRep1;
    Report.Preview;
    RepClientList.Free;
   {$ELSE}
    ADOmsg('RepClientList');
   {$ENDIF}
   end;
  {
  2:
   begin
    Application.CreateForm(TRepPortfolios,RepPortfolios);
    Report := RepPortfolios.QuickRep1;
    Report.Preview;
    RepPortfolios.Free;
   end;
  }
   3:
   begin
   {$IFDEF ADO}
    Application.CreateForm(TRepALLTransactions,RepALLTransactions);
    Report := RepALLTransactions.QuickRep1;
    Report.Preview;
    RepALLTransactions.Free;
   {$ELSE}
    ADOmsg('RepALLTransactions');
   {$ENDIF}
   end;
  end;
end;

procedure TReportMenuFP_2012.PrintClick(Sender: TObject);
begin
 //20150819 Igor Report.Print;
end;

end.
