unit T2_2027ReportMenu;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Db,T2_2027TrimStr,T2_2027Declare, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef,
  uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet;
  {,QuickRpt, T2_2027RepClientList,qrextra;} //20150622

type
  TReportMenuT2_2027 = class(TForm)
    Preview: TButton;
    Print: TButton;
    Exit: TButton;
    GroupBox1: TGroupBox;
    ClientList: TRadioButton;
    Table1: TADTable;
    FDConnection: TADConnection;
    procedure PreviewClick(Sender: TObject);
    //procedure PrintClick(Sender: TObject); //20170311 Igor
    procedure ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    //FReport : TQuickRep; //20150622
    //procedure SetReport(Value : TQuickRep); //20150622
  public
    //property Report : TQuickRep read FReport write SetReport; //20150622
  end;

var
  ReportMenu: TReportMenuT2_2027;

implementation

{$R *.DFM}

uses
  vtPDFPrinter, vtDataBase, T2_2027, vtShared, vtMulti; //20170311 Igor
{procedure TReportMenuT2_2027.SetReport(Value : TQuickRep); //20150622
begin
  FReport:=Value;
end;}

procedure TReportMenuT2_2027.ExitClick(Sender: TObject);
begin
  //RepClientList.Free; //20150622
  Close;
end;

procedure TReportMenuT2_2027.PreviewClick(Sender: TObject);//20170311 Igor
begin
  SetTableName(FDConnection, Table1, IncludeTrailingPathDelimiter(AppT2.Dir_Cur) + AppT2.ClientsDBLite,
    ClientsTableLite, 'CORP_NAME');
  with TvtPDFPrinter.Create(AppT2) do
  begin
    try
      PrintDataSet('Corporate Clients List', 'Corporate Clients List',
        ['Date print: ' + DateToStr(Now),
         'User: ' + User.UserName],
        ['Name', 'Year End', 'Account', 'Contact', 'Area', 'Phone'],
        ['CORP_NAME', 'YEAR_END', 'ACCOUNT', 'CONTACT', 'AREA', 'PHONE'],
        [50, 10, 11, 15, 5, 8],
        Table1, Sender = Preview);

    finally
      free;
    end;
  end;
   //Report := RepClientList.QuickRep1; //20150622
   //Report.Preview;
end;
(*//20170311 Igor
procedure TReportMenuT2_2027.PrintClick(Sender: TObject);
begin
 //Report.Print; //20150622
end;*)

procedure TReportMenuT2_2027.FormCreate(Sender: TObject);
begin
 //Application.CreateForm(TRepClientListT2_2027,RepClientList); //20150622
end;

end.
