unit T4T5_2026ImportDbfData;
//20170123 Igor Update all pas and dfm
interface

uses
  SysUtils,
  {$WARN UNIT_PLATFORM OFF}FileCtrl,{$WARN UNIT_PLATFORM ON} //20170612 Igor
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.DBGrids, Data.DB,
  Vcl.ComCtrls, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;

  type
  TMode = (mImport, mRollOver); //20170123 Igor

  TImportDBFT4T5_2026 = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    DbfData_Dir: TEdit;
    Label3: TLabel;
    Cur_Dir: TEdit;
    Image1: TImage;
    AllBtn: TBitBtn;
    RetCntLabel: TLabel;
    FileListBox1: TFileListBox;
    grEmpl: TDBGrid;
    OverrideOption: TRadioGroup;
    Label2: TLabel;
    SearchBox: TEdit;
    Chart1: TChart;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    dsEmpl: TDataSource;
    ProgressBar: TProgressBar;  //20160229 Igor
    LabelProgressBar: TLabel;
    MemoLog: TMemo;
    ButtonCloseLog: TButton;   //20160229 Igor
    btnHelp: TBitBtn;
    Connection: TADConnection;
    tblEmpl: TADTable;
    grpDBFData: TGroupBox;
    pnlTools: TPanel;
    pnlSearch: TPanel;
    pgcDBFDetailData: TPageControl;
    spl1: TSplitter;
    tsT4: TTabSheet;
    tsT4A: TTabSheet;
    tsT5: TTabSheet;
    grT4: TDBGrid;
    grT4A: TDBGrid;
    grT5: TDBGrid;
    tblT4: TADTable;
    dsT4: TDataSource;
    tblT4A: TADTable;
    dsT4A: TDataSource;
    tblT5: TADTable;
    dsT5: TDataSource; //200160713 Igor
    procedure FilesToShow;
    procedure CalcImported(RetNo:Integer);
    Function ValidDirectories:Boolean;
    function ConvertCurrentEmpl: Integer;
//    procedure SaveIt(FlName:String); //20160627 Igor
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure AllBtnClick(Sender: TObject);
    procedure DbfData_DirExit(Sender: TObject);
    procedure DbfData_DirKeyPress(Sender: TObject; var Key: Char);
    procedure grEmplDblClick(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure tblEmplFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonCloseLogClick(Sender: TObject); //20160229 Igor
    procedure btnHelpClick(Sender: TObject); //20160713 Igor
    procedure FormShow(Sender: TObject); //20170123 Igor

   { procedure FindSinBtnClick(Sender: TObject);}  {Screen, element, valu}
  private
    { Private declarations }
    WorkRetNo: Integer;
    StartProcess: Boolean;
    FCurrentDir: string;
    FMode: TMode; //20170123 Igor
    procedure SetMode(const Value: TMode); //20170123 Igor
    procedure SetEnabledControlElements(AValue: Boolean); //20160229 Igor
    procedure AddLog(AText: String);
    procedure CloseAllTables;
    function GetDefaultFileName: string;
  public
    { Public declarations }
    property Mode: TMode read FMode write SetMode; //20170123 Igor
  end;

var
  ImportDBFT4T5_2026: TImportDBFT4T5_2026;
  FlName: String; //[60]; //20170609 igor
  Cnt   : integer;
  InitialRowCount :integer;

const
  ModeStr: array [TMode] of String =  ('Import', 'RollOver'); //20170123 Igor

implementation

{$R *.DFM}
uses T4T5_2026Main, T4T5_2026, vtShared, T4T5_2026TrimStr, vtDialogs, T4T5_2026Common2,
  T4T5_2026Common, vtTrimStr, vtMain, vtMulti, vtCommon, T4T5_2026Declare,
  vtDBF_SQLite; //20161202 Igor

const
  c_ImportToMultiAppHelp = 'www.visualtax.com/vtImportToMultiApp.asp'; //20160713 Igor

procedure TImportDBFT4T5_2026.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);  //20160229 Igor
begin
  CanClose := not StartProcess;
end;

procedure TImportDBFT4T5_2026.FormCreate(Sender: TObject);
begin
  FlName := '';
  //20170123 Igor >>>
  Mode := mImport;
//  OverrideOption.itemIndex :=0;
//  DbfData_Dir.Text := OptRec.Dir_DBFData;
//  Cur_Dir.Text := OptRec.Dir_Cur;
//  FCurrentDir := DbfData_Dir.Text;
//  FilesToShow;
//20170123 Igor <<<
  //20180503 Igor >>>
  if CheckIsCloud(true) then
    DbfData_Dir.Enabled := False;
  //20180503 Igor <<<
end;


procedure TImportDBFT4T5_2026.FormShow(Sender: TObject); //20170123 Igor
begin
  FlName := '';
  OverrideOption.itemIndex :=0;
  if Mode = mImport then
    DbfData_Dir.Text := OptRec.Dir_DBFData
  else
    DbfData_Dir.Text := OptRec.Dir_LastYr;
  Cur_Dir.Text := OptRec.Dir_Cur;
  FCurrentDir := DbfData_Dir.Text;
  FilesToShow;
end;

function TImportDBFT4T5_2026.GetDefaultFileName: string;
begin
  if tblEmpl.FieldByName('EMPL_NAME').AsString = '' then
    Result := GetCorrectFileName('(Un-named)') //20171231 + '-'+AppT4T5_2026.AppYear)
  else
    Result := GetCorrectFileName(tblEmpl.FieldByName('EMPL_NAME').AsString); //20171231 + '-' + AppT4T5_2026.AppYear);

 //20171231
 if Pos(Result,'&')>0 then Result:=RePlaceChar(Result,'&','-'); //It avoids the Firedack error if it has &

end;

procedure TImportDBFT4T5_2026.ButtonCloseLogClick(Sender: TObject);
begin
  MemoLog.Visible := not MemoLog.Visible;
end;

procedure TImportDBFT4T5_2026.CalcImported(RetNo: Integer);
begin
  Calc(WorkRetNo,AppT4T5_2026.FirstForm);
  CalcAll(WorkRetNo);
end;

procedure TImportDBFT4T5_2026.CancelBtnClick(Sender: TObject);
begin
  if StartProcess then
  Begin
    if MessageDlg('Cancel operation?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    Begin
      SetEnabledControlElements(True);
      Close;
    End
  End
  else
    Close;
end;

procedure TImportDBFT4T5_2026.CloseAllTables;
begin
  tblEmpl.Close;
  tblT4.Close;
  tblT4A.Close;
  tblT5.Close;
end;

procedure TImportDBFT4T5_2026.StringGrid1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;

procedure TImportDBFT4T5_2026.tblEmplFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := (SearchBox.Text = '') or
            (Pos(AnsiUpperCase(SearchBox.Text), AnsiUpperCase(DataSet.FieldByName('EMPL_NAME').asString))>0);
end;

Function TImportDBFT4T5_2026.ValidDirectories:Boolean;
Var
  i,j: integer;
  Sin : string;
begin
  Result := False;
  If Not SysUtils.DirectoryExists(Cur_Dir.Text) then//20170609 Igor
  begin
    ShowMessage('Directory does not exist');
    Cur_Dir.SetFocus;
    exit;
  end;
  If Not SysUtils.DirectoryExists(DBFData_Dir.Text) then //20170609 Igor
  begin
    ShowMessage('Directory does not exist');
    DBFData_Dir.SetFocus;
    exit;
  end;
  If Not FileExists(Cur_Dir.Text+'\'+ClientsDbLite) then
  begin
    ShowMessage('Data catalog does not contain the database file to a new(DB) format.'+
                 Chr(13)+
                 'Use Configure | Data Directories');
    Cur_Dir.SetFocus;
    exit;
  end;
  If Not FileExists(DBFData_Dir.Text+'\Empl.dbf') then
  begin
    ShowMessage('Data catalog does not contain the database file to a old(DBF) format.'+
                 Chr(13)+
                 'Use Configure | Data Directories');
    DBFData_Dir.SetFocus;
    exit;
  end;
  Result := True;
end;

procedure TImportDBFT4T5_2026.OKBtnClick(Sender: TObject);
var
  NewRet: Integer;
Begin
  if tblEmpl.IsEmpty then
    Exit;
  FlName := GetDefaultFileName;
  If FileExists(Cur_Dir.text+'\'+FLName) then
  begin
    if MessageDlg('This return is already on this year'+Chr(39)+'s folder: '+Cur_Dir.text
                  +Chr(13)+
                  ModeStr[Mode] + ' it over again?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then   //20170123 Igor
      Exit;
  end;
  NewRet := ConvertCurrentEmpl;
  if NewRet > 0 then
    OpenForm(NewRet, 'Empl', 0);
  Close;
end;


function TImportDBFT4T5_2026.ConvertCurrentEmpl: Integer;
var
  myRet: TRetT4T5_2026;
  CurrTable: TADTable;
  CurrForm: String;
  FNo: Integer;
  procedure AssignValue(const AFieldName: String; const AElementNo: Integer);
  begin
    if (AElementNo > 0) and (CurrTable.FindField(AFieldName) <> nil) then //20170215 Igor
      myRet.Form[CurrForm].Elms[AElementNo] := CurrTable.FieldByName(AFieldName).asString;
  end;
begin
  Result := CreateNewReturn;
  if Result <= 0 then
    Exit;
  myRet := Ret[Result];
  if not Assigned(myRet) then
    Exit(-1);

  CurrTable := tblEmpl;
  CurrForm := 'EMPL';  //'empl'  //20171224
//20170126 Igor >>>
  AssignValue('EMPL_NAME',   EMPL_EMPL_NAME);
  AssignValue('EMPLNO',      EMPL_EMPLNO);
  AssignValue('REMITT4',     EMPL_REMITT4);
  AssignValue('PAYPERIODS',  EMPL_PAYPERIODS);
  AssignValue('REMITT4A',    EMPL_REMITT4A);

  myRet.Form[CurrForm].Elms[21]:=''; //20171230  //to be replaced by logic
  // AssignValue('UIRATE',      EMPL_UIRATE);

  AssignValue('AREACODE',    EMPL_AREACODE);
  AssignValue('TELEPHONE',   EMPL_TELEPHONE);
  AssignValue('FIRSTNAME',   EMPL_FIRSTNAME);
  AssignValue('LASTNAME',    EMPL_LASTNAME);
  AssignValue('DISTRICT',    EMPL_DISTRICT);
  AssignValue('TAXCENTRE',   EMPL_TAXCENTRE); //20171231
  AssignValue('STREET',      EMPL_STREET);
  AssignValue('CITY',        EMPL_CITY);
  AssignValue('PROV',        EMPL_PROV);
  AssignValue('POSTAL',      EMPL_POSTAL);
  AssignValue('BUS_NUMBER',  EMPL_ACCOUNTT4);
  AssignValue('BUS_NUMBER',  EMPL_ACCOUNTT4A);
//  AssignValue('ACCOUNTT4',   EMPL_ACCOUNTT4);
//  AssignValue('ACCOUNTT4A',  EMPL_ACCOUNTT4A);
  AssignValue('T5FILER',     EMPL_T5FILER);
  AssignValue('T2CORPNO',    EMPL_T2CORPNO);
  AssignValue('PROPSIN1',    EMPL_PROPSIN1);
  AssignValue('PROPSIN2',    EMPL_PROPSIN2);
  AssignValue('RPPNUM1',     EMPL_RPPNUM1);
  AssignValue('RPPNUM2',     EMPL_RPPNUM2);
  AssignValue('RPPNUM3',     EMPL_RPPNUM3);
  AssignValue('AUTHNAME',    EMPL_AUTHNAME);  //20171224 CON
  AssignValue('POSITION',    EMPL_POSITION);
  AssignValue('COUNTRY',     EMPL_COUNTRY);

  //put it in Last name Elm instead of First name [11] //20171224
  myRet.Form[CurrForm].Elms[12]:=myRet.Form[CurrForm].Elms[11];
  myRet.Form[CurrForm].Elms[11]:='';
  //20171230 remove remittances during rollover
  myRet.Form[CurrForm].Elms[23]:='';
  myRet.Form[CurrForm].Elms[25]:='';
  myRet.Form[CurrForm].Elms[33]:='';
  myRet.Form[CurrForm].Elms[37]:='';
  myRet.Form[CurrForm].Elms[38]:='';

  //-----------------------------
  //myRet.Form[CurrForm].Elms[12]:=tblT4.FieldByName('EMPL_AUTHNAME').AsString; //EMPL_AUTHNAME; //20171224 it goes to last name
//20170126 Igor <<<
{ not found
  AssignValue('T4_CNT',     -1);
  AssignValue('STATUS',     -1);
  AssignValue('T4A_CNT',    -1);
  AssignValue('T5_CNT',     -1);
  AssignValue('PREP_BY',    -1);
  AssignValue('BUS_NUMBER', -1);
  AssignValue('ACCOUNTT5',  -1);
  AssignValue('T5_AMMEND',  -1);
  AssignValue('T5_ADDIT',   -1);
  AssignValue('T5_BEFORE',  -1);
  AssignValue('SAME_ADDR',  -1);
  AssignValue('OLD_STREET', -1);
  AssignValue('OLD_CITY',   -1);
  AssignValue('OLD_PROV',   -1);
  AssignValue('OLD_POSTAL', -1);
  AssignValue('T5_UNCLDIV', -1);
  AssignValue('T5_UNCLTAX', -1);
  AssignValue('IN_USE_BY',  -1);
  AssignValue('OPERATION',  -1);
  AssignValue('NEWHIRES',   -1);
  AssignValue('TAXCENTRE',  -1);
  AssignValue('ENCLOSET4',  -1);
  AssignValue('ENCLOSET4A', -1);
  AssignValue('GOVFILER',   -1);
  AssignValue('TRANSITNO',  -1);
  AssignValue('EXTENSION',  -1);
  AssignValue('NHIRES_FLG', -1);
  AssignValue('T4_STATUS',  -1);
  AssignValue('T4A_STATUS', -1);
  AssignValue('T5_STATUS',  -1);
}

  CurrTable := tblT4;
  CurrTable.First;
  while not CurrTable.eof do
  begin
    FNo := AddPageInstance(Result, 'T4', '#' + IntToStr(CurrTable.RecNo));
    if FNo <= 0 then
    begin
      UserMsg('Can''t create new instanse for T4. Operation aborted.');
      CloseReturn(Result, True);
      Exit(-1);
    end;
    CurrForm := myRet.GetFormName(FNo);

    //20170126 Igor >>>
    AssignValue('SIN',         T4_SIN);
    myRet.Form[CurrForm].Elms[T4_YEAR] := AppT4T5_2026.AppYear;
    AssignValue('LASTNAME',    T4_LASTNAME);
    AssignValue('FIRSTNAME',   T4_FIRSTNAME);
    AssignValue('INITIALS',    T4_INITIALS);
    AssignValue('PROVINCE',    T4_PROVINCE);
    AssignValue('EMPLCODE',    T4_EMPLCODE);
    myRet.Form[CurrForm].Elms[T4_BOTTOMCOLONTITUL] := '              1 - Return with T4 Summary';
    myRet.Form[CurrForm].Elms[T4_ACCOUNT] := tblEmpl.FieldByName('ACCOUNTT4').AsString;
    AssignValue('STREET',      T4_STREET);
    AssignValue('CITY',        T4_CITY);

    //20171224 CON
    myRet.Form[CurrForm].Elms[T4_PROV_POSTAL] := tblT4.FieldByName('POSTAL').AsString;
    myRet.Form[CurrForm].Elms[17] := tblT4.FieldByName('PROV').AsString;
    //myRet.Form[CurrForm].Elms[T4_PROVINCE] := tblT4.FieldByName('PROV').AsString;
    //myRet.Form[CurrForm].Elms[T4_PROV_POSTAL] := tblT4.FieldByName('PROV').AsString + ', ' + tblT4.FieldByName('POSTAL').AsString;

    myRet.Form[CurrForm].Elms[T4_EMPL_NAME] := tblEmpl.FieldByName('EMPL_NAME').AsString;
    if FMode = mImport then
    begin
      AssignValue('BOXCODE1',    T4_BOXCODE1);
      AssignValue('AMOUNT1',     T4_AMOUNT1);
      AssignValue('BOXCODE2',    T4_BOXCODE2);
      AssignValue('AMOUNT2',     T4_AMOUNT2);
      AssignValue('BOXCODE3',    T4_BOXCODE3);
      AssignValue('AMOUNT3',     T4_AMOUNT3);
      AssignValue('BOXCODE4',    T4_BOXCODE4);
      AssignValue('AMOUNT4',     T4_AMOUNT4);
      AssignValue('BOXCODE5',    T4_BOXCODE5);
      AssignValue('AMOUNT5',     T4_AMOUNT5);
      AssignValue('BOXCODE6',    T4_BOXCODE6);
      AssignValue('AMOUNT6',     T4_AMOUNT6);
      AssignValue('BOX14',       T4_BOX14);
      AssignValue('BOX16',       T4_BOX16);
      AssignValue('BOX17',       T4_BOX17);
      AssignValue('BOX18',       T4_BOX18);
      AssignValue('BOX20',       T4_BOX20);
      AssignValue('BOX22',       T4_BOX22);
      AssignValue('BOX24',       T4_BOX24);
      AssignValue('BOX26',       T4_BOX26);
      AssignValue('BOX28A',      T4_BOX28A);
      AssignValue('BOX28B',      T4_BOX28B);
      AssignValue('BOX28C',      T4_BOX28C);
      AssignValue('BOX44',       T4_BOX44);
      AssignValue('BOX46',       T4_BOX46);
      AssignValue('BOX50',       T4_BOX50);
      AssignValue('BOX52',       T4_BOX52);
      AssignValue('BOX55',       T4_BOX55);
      AssignValue('BOX56',       T4_BOX56);
    end;
    //20170126 Igor <<<
{ not found
    AssignValue('NUMBER', -1); //20170217 Igor
    AssignValue('CPPPERIODS', -1);
    AssignValue('UIPERIODS',  -1);
    AssignValue('TOTPERIODS', -1);
    AssignValue('ADJCPP',     -1);
    AssignValue('ADJUI',      -1);
    AssignValue('ADJTAX',     -1);
    AssignValue('ADJAPPL',    -1);
    AssignValue('ADJAPPLCPP', -1);
    AssignValue('ADJAPPLUI',  -1);
    AssignValue('NETPAY',     -1);
    AssignValue('NETCALC',    -1);
    AssignValue('BOX30',      -1);
    AssignValue('BOX32',      -1);
    AssignValue('BOX34',      -1);
    AssignValue('BOX36',      -1);
    AssignValue('BOX38',      -1);
    AssignValue('BOX40',      -1);
    AssignValue('BOX42',      -1);
    AssignValue('BOX48',      -1);
    AssignValue('FOOTNOTE1',  -1);
    AssignValue('FOOTNOTE2',  -1);
    AssignValue('SERIAL_NO',  -1);
    AssignValue('EMPLNO',     -1);
    AssignValue('EMPL_NAME',  -1);
    AssignValue('UNIQUE_ID',  -1);
    AssignValue('NONCPPAMT',  -1);
    AssignValue('AUTOPE',     -1);
    AssignValue('COUNTRY',     -1);
    AssignValue('VOID',        -1);
}
    CurrTable.Next;
  end;

  CurrTable := tblT4A;
  CurrTable.First;
  while not CurrTable.eof do
  begin
    FNo := AddPageInstance(Result, 'T4A', '#' + IntToStr(CurrTable.RecNo));
    if FNo <= 0 then
    begin
      UserMsg('Can''t create new instanse for T4A. Operation aborted.');
      CloseReturn(Result, True);
      Exit(-1);
    end;
    CurrForm := myRet.GetFormName(FNo);
    //20170126 Igor >>>
    myRet.Form[CurrForm].Elms[T4A_YEAR] := AppT4T5_2026.AppYear;
    myRet.Form[CurrForm].Elms[T4A_BOTTOMCOLONTITUL] := '1 - Return with T4A Summary return';
    myRet.Form[CurrForm].Elms[T4A_ACCOUNT] := tblEmpl.FieldByName('ACCOUNTT4A').AsString;
    AssignValue('RECIP_BN',    T4A_RECIP_BN);
    if FMode = mImport then
    begin
      AssignValue('BOX16',       T4A_BOX16);
      AssignValue('BOX18',       T4A_BOX18);
      AssignValue('BOX20',       T4A_BOX20);
      AssignValue('BOX22',       T4A_BOX22);
      AssignValue('BOX48',       T4A_BOX48);
      AssignValue('BOX24',       T4A_BOX24);
    end;
    AssignValue('SIN',         T4A_SIN);
    AssignValue('LASTNAME',    T4A_LASTNAME);
    AssignValue('FIRSTNAME',   T4A_FIRSTNAME);
    AssignValue('STREET',      T4A_STREET);{?}
    AssignValue('CITY',        T4A_CITY);{?}
    AssignValue('PROV',        T4A_PROV);{?}
    AssignValue('POSTAL',      T4A_POSTAL);{?}
    myRet.Form[CurrForm].Elms[T4A_EMPL_NAME] := tblEmpl.FieldByName('EMPL_NAME').AsString;
    if FMode = mImport then
    begin
      AssignValue('FT_CD1',      T4A_FT_CD1);
      AssignValue('FT_AMT1',     T4A_FT_AMT1);
      AssignValue('FT_CD2',      T4A_FT_CD2);
      AssignValue('FT_AMT2',     T4A_FT_AMT2);
      AssignValue('FT_CD3',      T4A_FT_CD3);
      AssignValue('FT_AMT3',     T4A_FT_AMT3);
      AssignValue('FT_CD4',      T4A_FT_CD4);
      AssignValue('FT_AMT4',     T4A_FT_AMT4);
      AssignValue('FT_CD5',      T4A_FT_CD5);
      AssignValue('FT_AMT5',     T4A_FT_AMT5);
      AssignValue('FT_CD6',      T4A_FT_CD6);
      AssignValue('FT_AMT6',     T4A_FT_AMT6);
      AssignValue('FT_CD7',      T4A_FT_CD7);
      AssignValue('FT_AMT7',     T4A_FT_AMT7);
      AssignValue('FT_CD8',      T4A_FT_CD8);
      AssignValue('FT_AMT8',     T4A_FT_AMT8);
      AssignValue('FT_CD9',      T4A_FT_CD9);
      AssignValue('FT_AMT9',     T4A_FT_AMT9);
      AssignValue('FT_CD10',     T4A_FT_CD10);
      AssignValue('FT_AMT10',    T4A_FT_AMT10);
      AssignValue('FT_CD11',     T4A_FT_CD11);
      AssignValue('FT_AMT11',    T4A_FT_AMT11);
      AssignValue('FT_CD12',     T4A_FT_CD12);
      AssignValue('FT_AMT12',    T4A_FT_AMT12);
    end;
    //20170126 Igor <<<
(* Not found
    AssignValue('COUNTRY',     -1);
    AssignValue('INITIALS',    -1);
    AssignValue('BOX101',     -1);
    AssignValue('BOX133',     -1);
    AssignValue('BOX135',     -1);
    AssignValue('PENSIONNO',  -1);
    AssignValue('EMPLNO',     -1);
    AssignValue('EMPL_NAME',  -1);
    AssignValue('SERIAL_NO',  -1);
    AssignValue('FT_BOX1',    -1);
    AssignValue('FT_BOX2',    -1);
    AssignValue('FT_BOX3',    -1);
    AssignValue('FT_BOX4',    -1);
    AssignValue('FT_BOX5',    -1);
    AssignValue('FT_BOX6',    -1);
    AssignValue('FT_BOX7',    -1);
    AssignValue('FT_BOX8',    -1);
    AssignValue('_DBASELOCK', -1);
    AssignValue('FT_BOX9',    -1);
    AssignValue('FT_BOX10',   -1);
    AssignValue('FT_BOX11',   -1);
    AssignValue('FT_BOX12',   -1);
*)
    CurrTable.Next;
  end;

  CurrTable := tblT5;
  CurrTable.First;
  while not CurrTable.eof do
  begin
    FNo := AddPageInstance(Result, 'T5', '#' + IntToStr(CurrTable.RecNo));
    if FNo <= 0 then
    begin
      UserMsg('Can''t create new instanse for T5. Operation aborted.');
      CloseReturn(Result, True);
      Exit(-1);
    end;
    CurrForm := myRet.GetFormName(FNo);

    myRet.Form[CurrForm].Elms[T5_YEAR] := AppT4T5_2026.AppYear;
    myRet.Form[CurrForm].Elms[T5_LASTNAME_FIRSTNAME] := tblT5.FieldByName('LASTNAME').AsString + ' ' + tblT5.FieldByName('FIRSTNAME').AsString;
    myRet.Form[CurrForm].Elms[T5_BOTTOMCOLONTITUL1] := 'RC-01-448';
    myRet.Form[CurrForm].Elms[T5_BOTTOMCOLONTITUL2] := '              1 - Return with T5 Summary';
    AssignValue('STREET',     T5_STREET);
    AssignValue('CITY',       T5_CITY);
    //20171224 CON
    myRet.Form[CurrForm].Elms[22] := tblT5.FieldByName('PROV').AsString;
    myRet.Form[CurrForm].Elms[23] := tblT5.FieldByName('POSTAL').AsString;
    myRet.Form[CurrForm].Elms[32] := ''; //Country
   // myRet.Form[CurrForm].Elms[T5_PROV_POSTAL] := tblT5.FieldByName('PROV').AsString + ', ' + tblT5.FieldByName('POSTAL').AsString;
   //----------------
    myRet.Form[CurrForm].Elms[T5_EMPL_NAME] := tblEmpl.FieldByName('EMPL_NAME').AsString;
    myRet.Form[CurrForm].Elms[T5_EMPL_STREET] := tblEmpl.FieldByName('STREET').AsString;
    myRet.Form[CurrForm].Elms[T5_EMPL_CITY] := tblEmpl.FieldByName('CITY').AsString;
    //20171224 CON
    myRet.Form[CurrForm].Elms[T5_EMPL_PROV_POSTAL] :=tblEmpl.FieldByName('POSTAL').AsString;
    //myRet.Form[CurrForm].Elms[T5_EMPL_PROV] := tblEmpl.FieldByName('PROV').AsString + ', ' + tblEmpl.FieldByName('POSTAL').AsString;
    //myRet.Form[CurrForm].Elms[T5_EMPL_PROV_POSTAL] := tblEmpl.FieldByName('PROV').AsString + ', ' + tblEmpl.FieldByName('POSTAL').AsString;

    AssignValue('CURRENCY',   T5_CURRENCY);
    AssignValue('TRANSIT',    T5_TRANSIT);
    AssignValue('RECACCOUNT', T5_RECACCOUNT);
    if FMode = mImport then
    begin
      AssignValue('BOX24',      T5_BOX24);
      AssignValue('BOX25',      T5_BOX25);
      AssignValue('BOX26',      T5_BOX26);
      AssignValue('BOX13',      T5_BOX13);
      AssignValue('BOX18',      T5_BOX18);
      AssignValue('BOX10',      T5_BOX10);
      AssignValue('BOX11',      T5_BOX11);
      AssignValue('BOX12',      T5_BOX12);
    end;
    AssignValue('RECCODE',    T5_RECCODE);
    AssignValue('SIN',        T5_SIN);
    AssignValue('RECTYPE',    T5_RECTYPE);
    myRet.Form[CurrForm].Elms[T5_BOX14_NUMBER] := '14';
    if FMode = mImport then
      AssignValue('BOX14',      T5_BOX14);
    myRet.Form[CurrForm].Elms[T5_BOX15_NUMBER] := '15';
    if FMode = mImport then
      AssignValue('BOX15',      T5_BOX15);
    myRet.Form[CurrForm].Elms[T5_BOX17_NUMBER] := '17';
    if FMode = mImport then
      AssignValue('BOX17',      T5_BOX17);

(* Not found
    AssignValue('COUNTRY',    -1);
    AssignValue('BOX16',      -1);
    AssignValue('BOX19',      -1);
    AssignValue('BOX20',      -1);
    AssignValue('FOOTNOTE1',  -1);
    AssignValue('FOOTNOTE2',  -1);
    AssignValue('VOID',       -1);
    AssignValue('EMPLNO',     -1);
    AssignValue('EMPL_NAME',  -1);
    AssignValue('INITIALS',   -1);
    AssignValue('BOX40',      -1);
    AssignValue('BOX41',      -1);
*)
    CurrTable.Next;
  end;

  myRet.CalcAll;
  myRet.Changed := True;
  UpdateAllDataIndicators(Result);
end;

procedure TImportDBFT4T5_2026.AddLog(AText: String);
begin
  MemoLog.Lines.Add({'***'+DateTimeToStr(Now)+':   '+}AText); //20160305 Igor
  MemoLog.Repaint;
end;

procedure TImportDBFT4T5_2026.AllBtnClick(Sender: TObject);
var
  NewReturn: Integer;
begin


  if MessageDlg(ModeStr[Mode] + ' all. Are you sure?', //20170123 Igor
                mtInformation, [mbYes, mbNo], 0) = mrNo then exit;

  Cnt :=0;

  tblEmpl.First;
  SetEnabledControlElements(False);
  AddLog('Start');
  try
    InitFormsTable;
    while not tblEmpl.eof do
    Begin
      Application.ProcessMessages;  //20160229 Igor
      if Not StartProcess then
      Begin
        AddLog('Process terminated by user');
        exit;
      end;
      FlName := GetDefaultFileName;
      if not FileExists(IncludeTrailingPathDelimiter(Cur_Dir.Text)+GetDefaultFileName) or
         (OverrideOption.ItemIndex = 1) then
      begin
        AddLog('File in progress: "'+FlName+'"');
        NewReturn := ConvertCurrentEmpl;
        if NewReturn > 0 then
        begin
          SaveReturn(NewReturn, Cur_Dir.Text, FlName, OverrideOption.ItemIndex = 1, True);
          CloseReturn(NewReturn, True);
          inc(cnt);
        end;
      end
      else
        AddLog('File "'+FlName+'" exists in work directory. Skipped.');
      tblEmpl.Next;
      ProgressBar.Position := tblEmpl.RecNo;
      LabelProgressBar.Caption := IntToStr(tblEmpl.RecNo) + ' of ' +IntToStr(tblEmpl.RecordCount);
    End;
    Addlog('End. Total returns converted/added= '+IntTostr(cnt));
  finally
    SetEnabledControlElements(true);  //20160229 Igor
  end;
  ShowMessage(ModeStr[Mode] + ' completed.'+Chr(13)+ //20170123 Igor
              'Total returns converted/added= '+IntTostr(cnt));
  SendMessage(MainForm.Handle, WM_PAINT,0,0);
  Close;
end;

procedure TImportDBFT4T5_2026.btnHelpClick(Sender: TObject); //20160713 Igor
begin
  ShowHelp(c_ImportToMultiAppHelp,'', true);
end;

procedure TImportDBFT4T5_2026.FilesToShow;
begin
  Connection.Close;
  CloseAllTables;
  SetODBCConnect(Connection, DBFData_Dir.Text);
  Connection.LoginPrompt := false;
  Connection.Open;
  tblEmpl.Open;
  tblEmpl.First;
  tblT4.Open;
  tblT4A.Open;
  tblT5.Open;
end;

procedure TImportDBFT4T5_2026.DbfData_DirExit(Sender: TObject);
begin
  if SameText(DbfData_Dir.text, FCurrentDir) then
    Exit;
  FCurrentDir := DbfData_Dir.text;
  If not SysUtils.DirectoryExists(DbfData_Dir.text) then
  begin
    ShowMessage('Directory '+ DbfData_Dir.text+ ' does not exist');
    DbfData_Dir.text := OptRec.Dir_DbfData;
  end;
  if AppT4T5_2026.LicenseLevel in anyMulti then
    if not User.EqualOverloadProperty(AppT4T5_2026, 'Dir_DBFData', DbfData_Dir.Text, True) then
      if not YouKnowTheAdminPassword then
        DbfData_Dir.Text := OptRec.Dir_DbfData;
  FilesToShow;
end;

procedure TImportDBFT4T5_2026.DbfData_DirKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
    DbfData_DirExit(DbfData_Dir);
end;

procedure TImportDBFT4T5_2026.grEmplDblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;


procedure TImportDBFT4T5_2026.SearchBoxChange(Sender: TObject);
begin
  if SearchBox.Text <> '' then
  Begin
    tblEmpl.Filtered := False;
    tblEmpl.Filtered := True;
    tblEmpl.First;
  end
  else tblEmpl.Filtered := False;
end;

procedure TImportDBFT4T5_2026.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
    OKBtnClick(Sender);
end;

procedure TImportDBFT4T5_2026.SetEnabledControlElements(AValue: Boolean);  //20160229 Igor
begin
  StartProcess := not AValue;
  GroupBox1.Enabled := AValue;
  OverrideOption.Enabled := AValue;
  SearchBox.Enabled := AValue;
  grEmpl.Enabled := AValue;
  OKBtn.Enabled := AValue;
  AllBtn.Enabled := AValue;
  ProgressBar.Visible := not AValue;
  if ProgressBar.Visible then //20160305 Igor
  Begin
    ProgressBar.Max := tblEmpl.RecordCount;
    ProgressBar.Position :=0;
  End;

  LabelProgressBar.Visible := not AValue;
  if not AValue then
  Begin
    MemoLog.SetBounds(grEmpl.Left,grEmpl.Top,
                      grEmpl.Width, grEmpl.Height);
    MemoLog.Clear;
    MemoLog.Visible := True;
    MemoLog.BringToFront;
    ButtonCloseLog.Visible := true;
  End;

  if not AValue then
    LockWindowUpdate(MainFormT4T5.Handle)
  else
    LockWindowUpdate(0);   //no impact

end;

procedure TImportDBFT4T5_2026.SetMode(const Value: TMode); //20170123 Igor
begin
  FMode := Value;
  case FMode of
    mImport:
      begin
        Label4.Caption := 'Import old data base format VisualTax T4-2017 Tax return Data ';
        OverrideOption.Caption := 'Options (when importing All)';
        grpDBFData.Caption := 'Old format data';
        OKBtn.Caption := 'Import the Selected return';
        AllBtn.Caption := 'Import All returns';
      end;
    mRollOver:
      begin
        Label4.Caption := 'RollOver VisualTax T4-2016 Tax return Data ';  //20171224
        OverrideOption.Caption := 'Options (when RollOver All)';
        grpDBFData.Caption := 'Last year data';
        OKBtn.Caption := 'RollOver the Selected return';
        AllBtn.Caption := 'RollOver All returns';
      end;
  end;

end;

end.
