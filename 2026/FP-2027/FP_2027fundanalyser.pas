unit FP_2027fundanalyser;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,ExtCtrls,FileCtrl,ComCtrls,Menus,
  ShellApi,{Psock,NMHttp,} //20150817 igor
  OleCtrls,SHDocVw,ToolWin, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;
  //Psock, NMHttp;
  //QuickRpt,UFundReport2;

type
  TFundAnalyserFP_2012 = class(TForm)
    MainMenu1: TMainMenu;
    DataSource1: TDataSource;
    Memo1: TMemo;
    Label7: TLabel;
    ExchangeBox: TComboBox;
    Panel2: TPanel;
    Panel3: TPanel;
    HeaderBox: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image2: TImage;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    FundCodeBox: TEdit;
    SearchBtn: TBitBtn;
    FavoriteBox: TCheckBox;
    RemoveFilterBtn: TBitBtn;
    CancelBtn: TBitBtn;
    AnalyseBtn: TBitBtn;
    Splitter1: TSplitter;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    DocumentHeaderPanel: TPanel;
    Label6: TLabel;
    Label9: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    FindBtn: TBitBtn;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    BackBtn: TToolButton;
    ForwardBtn: TToolButton;
    StopBtn: TToolButton;
    RefreshBtn: TToolButton;
    URLs: TComboBox;
    HighlightBox: TEdit;
    HighlightBtn: TBitBtn;
    WebBrowser1: TWebBrowser;
    FDConnection: TADConnection;
    Query1: TADQuery;
    procedure FormCreate(Sender: TObject);
    procedure CloseQueries;
    //Function  GetFilterClause:String;
   // procedure AddToPortFolioBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    //procedure PortFChartBtnClick(Sender: TObject);
    procedure SelectFundTypeBtnClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    //procedure RemoveFilterBtnClick(Sender: TObject);
    //procedure RemoveFilter;
    //procedure DBGrid4DblClick(Sender: TObject);
    Function GetFundCode:String;
    Procedure OpenQuery1;
    //procedure OKBtnClick(Sender: TObject);
    procedure AnalyseBtnClick(Sender: TObject);
    procedure FavoriteBoxClick(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure RemoveFilterBtnClick(Sender: TObject);
    //procedure GetTheHtmlDoc(Url:String;CaptureFileName:String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FundAnalyser: TFundAnalyserFP_2012;
  FundType :string; //[2];
  FilterClause:String;
  FundCode:String;
  CaptureFileName:String;
  //Report : TQuickRep;
implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027TrimStr,FP_2027Declare,FP_2027SelectFundType,
  FP_2027PopList,vtTrimStr,vtShared;

procedure TFundAnalyserFP_2012.FormCreate(Sender: TObject);
begin
 CaptureWebDir:=AppDir+'\'+'WebData';
 ForceDirectories(CaptureWebDir);
 ExchangeBox.Text:='TO';
 //RemoveFilterBtnClick(Application);
 //ObjectiveBox.ItemIndex :=1;
// PeriodBox.ItemIndex :=1;
 //ReturnOperatorBox.ItemIndex :=0;
 //PercentBox.ItemIndex :=0;
 OpenQuery1;
End;

Procedure TFundAnalyserFP_2012.OpenQuery1;
Var WhereClause:String;FavoriteValue:string; //[1];
begin
 Screen.Cursor:=CrHourGlass;
 If FundCodeBox.text >'' then FavoriteBox.Checked:=False;
 If FavoriteBox.Checked then FavoriteValue:='Y' else FavoriteValue:='*';
 If FavoriteBox.Checked then FundCodeBox.Text:='';

 WhereClause :='';

 If FavoriteValue='Y' then
   WhereClause := ' Where '
   +'(' + 'Favorite LIKE ' + '"' +  FavoriteValue + '"' +')'
 else
 begin
  If FundCodeBox.text >'' then
  begin
  If RightStr(FundCodeBox.text,1) <> '*' then FundCodeBox.text:=FundCodeBox.text+'*';
  WhereClause := ' Where '
  +'('
  + 'Trim(FundCode) LIKE ' + '"' +  FundCodeBox.Text + '"'
  +')';
  end;
 end;

// Query1.ConnectionString:=FundBaseConnectionString;
 With query1 do
 begin
  If Active then Close;
  SQL.Clear;
  Try
   SQL.Add('Select * from '+FundsTableLite); // 20150922 Igor
   SQL.Add( WhereClause);
   SQL.Add( 'ORDER BY FundCode');
   //Prepare;
   open;
  except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
 end;
 Screen.Cursor:=CrDefault;
end;


Function TFundAnalyserFP_2012.GetFundCode:String;
begin
 FundCode := query1.FieldByName('FundCode').AsString;
 Result := FundCode;
end;


procedure TFundAnalyserFP_2012.CancelBtnClick(Sender: TObject);
begin
 //SelectedItem.Text :='';
 CloseQueries;
 Close;
end;


procedure TFundAnalyserFP_2012.DBGrid1DblClick(Sender: TObject);
begin
 AnalyseBtnClick(Sender);
//AddToPortFolioBtnClick(Sender);
end;

procedure TFundAnalyserFP_2012.SelectFundTypeBtnClick(Sender: TObject);
begin
 (*
 Application.CreateForm(TSelectFundType,SelectFundType);
 SelectFundType.ShowModal;
 If SelectedItem.Text ='' then exit;
 FundTypeBox.Text :=SelectFundType.SelectedItem.Text;
 SelectFundType.Free;
 *)
end;


procedure TFundAnalyserFP_2012.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
//If Key = Char(13) then AddToPortFolioBtnClick(Sender);
end;



procedure TFundAnalyserFP_2012.CloseQueries;
begin
 If query1.Active then query1.Close;
end;


procedure TFundAnalyserFP_2012.AnalyseBtnClick(Sender: TObject);
Var FundCode,FundId,WebPageId:String;Exchange:String;
    TempString : array[0..79] of char; h:THandle;
    Url:String; FndName:String;
    ZString : Array[0..150] of Char;
    Ptr : Pchar;

begin
  (*
  If (IsAgentVersion = false) and (IsDealerVersion = false)
  and (IsAgentDemo = False)
  then
   begin
   ShowMessage('Available only in the Investment Agent/dealer version of the program');
   exit;
  end;
 *)
 (*
 SomeList := TStringList.Create;
 SomeList.Sorted := False;
 SomeCaption := 'Fund Analysis from Internet';
 SomeList.Add('Profile');
 SomeList.Add('Performance');
 SomeList.Add('Holdings');
 SomeList.Add('3m chart');
 SomeList.Add('6m chart');
 SomeList.Add('1y chart');
 SomeList.Add('2y chart');
 SomeList.Add('3y chart');
 SomeList.Add('5y chart');
 SomeList.Add('my chart (max years)');

 // SomeList.Add('-------------------');
 // SomeList.Add('Get Current Price');

 ExecuteForm(TPopList);
 SomeList.Free;

 If SelectedString = '' then exit;
 *)
 FundCode:= Query1.FieldByName('FundCode').AsString;
 Url:='http:\\sympaticodb.globeinvestor.com/invest/investSQL/syma.fundquote?pi_symbol='
   +FundCode+'&iaction=Go';
 Ptr := StrPCopy(ZString,Url);
 If Url>'' then
  h := ShellExecute(0,'open',Ptr,Nil,Nil,Sw_Show);
 If H<=32 then ShowMessage('Connection failed');

 EXIT;

 //remaining from Yahoo is not used
 If LeftStr(SelectedString,3) = 'Get' then
 begin
  FndName:=ReplaceChar(
           UpperCase(AllTrim(Query1.FieldByName('Supplier').AsString)) + ' '
          +Query1.FieldByName('FundTypeDescr').AsString,' ','+');
  //Url:='http://sympaticodb.globeinvestor.com/invest/investSQL/symp.fund_pro?fundname='+FndName;
  // STOCK QUOUT HARD to DECYPHER: Url:=http://sympaticodb.globeinvestor.com/invest/investSQL/syma.fundquote?pi_symbol=AGF934&iaction=Go
  //Url:='http://sympaticodb.globeinvestor.com/invest/investSQL/symp.fund_pro?fundname=AGF+Canadian+Balanced';
 { CaptureFileName:= CaptureWebDir+'\'
       +Query1.FieldByName('FundCode').AsString+'_'+ 'BriefProfile'+'.Htm';}
  //GetTheHtmlDoc(Url,CaptureFileName);
  ShowMessage('Price ='+GetValueFromInternet(Url,'Current Price:'));
  Exit;
 end;

 WebPageId:=SelectedString;
 Exchange:='TO';
 FundId:= Query1.FieldByName('FundId').AsString;
 AnalyseAFundFromYahoo(WebPageId,FundId,Exchange);

end;

procedure TFundAnalyserFP_2012.FavoriteBoxClick(Sender: TObject);
begin
OpenQuery1;
end;

procedure TFundAnalyserFP_2012.SearchBtnClick(Sender: TObject);
begin
OpenQuery1;
end;

procedure TFundAnalyserFP_2012.RemoveFilterBtnClick(Sender: TObject);
begin
FundCodeBox.Text:='';
FavoriteBox.Checked:=False;
OpenQuery1;
end;

end.
