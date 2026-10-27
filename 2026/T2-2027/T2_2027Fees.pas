unit T2_2027fees;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,DB,Grids,DBGrids,ExtCtrls,DBCtrls,
  T2_2027,T2_2027Declare,T2_2027Common,T2_2027TrimStr, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TFeesT2_2027 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    SortBy: TRadioGroup;
    ExportBtn: TBitBtn;
    FlBox: TEdit;
    ImportBtn: TBitBtn;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;
    Table1FORMNO: TIntegerField;
    Table1FORMNAME: TStringField;
    Table1RSINAME: TStringField;
    Table1FEE: TStringField;
    Table1FEEADDITEM: TStringField;
    Table1FORMABREV: TStringField;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure SortByClick(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Const HelpTopic ='Fee_schedule';
var
  Fees: TFeesT2_2027;

implementation

{$R *.DFM}

uses vtMulti, vtTrimStr, vtShared, vtDataBase;

procedure TFeesT2_2027.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;

end;

procedure TFeesT2_2027.FormCreate(Sender: TObject);
begin
FlBox.Text := AppDir+'\'+'Fees.Txt';
If not Table1.Active then
 begin
  //20150920 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, ''); {'Fees';}

  SortBy.ItemIndex :=1;
  SortByClick(Sender);

  Table1.Edit;
  Table1.First;
  end;
end;

procedure TFeesT2_2027.OKBtnClick(Sender: TObject);
begin
ExportBtnClick(Sender);
Table1.Edit;
Table1.Post;
Close;
Flist.Clear; InitFormsTable; {reinit the form specs}
ShowMessage('Fees saved on the data Base');
end;

procedure TFeesT2_2027.SortByClick(Sender: TObject);
begin
 Case SortBy.ItemIndex of
 0: Table1.IndexName := UpperCase('FormName'); // 20150920 Igor
 1: Table1.IndexName := UpperCase('Fee');      // 20150920 Igor
 else
 Table1.IndexName := UpperCase('FormName'); // 20150920 Igor
 end;
If Table1.Active then Table1.First;
end;

procedure TFeesT2_2027.ExportBtnClick(Sender: TObject);
Var ListNdx:integer;Templist:TStringList; S,S1,S2,S3,S4:string;
begin
 If not SysUtils.DirectoryExists(ExtractFilePath(FlBox.Text)) then //20150702
 begin
  ShowMessage('Path does not exist. Fees not exported for back-up');
  FlBox.SetFocus;
  exit;
 end;

 TempList := TstringList.Create;
 TempList.Sorted := True;
 Table1.First;
 while not Table1.EOF do
  begin
    If (Table1.FieldByName('Fee').AsString > '')
    or (Table1.FieldByName('FeeAddItem').AsString > '') then
    begin
     S1:=Table1.FieldByName('FormName').AsString;
     S2 :=Table1.FieldByName('Fee').AsString;
     s3 :=Table1.FieldByName('FeeAddItem').AsString;
     s4 :=Table1.FieldByName('FormAbrev').AsString;
     s :=s1+Space(PaddCount(s1,8))
         +s2+Space(PaddCount(s2,7))
         +s3+Space(PaddCount(s3,7))
         +s4+Space(PaddCount(s2,30));
     TempList.Add(s);
    end;
    Table1.Next;
  end;
  TempList.SaveToFile(FlBox.Text);
  TempList.Free;
  ShowMessage('Fee schedule successfully exported to the designated file');
  Table1.First;
end;

procedure TFeesT2_2027.ImportBtnClick(Sender: TObject);
Var i:integer;Templist:TStringList;
  FrmNm,FrmFee,FrmAddFee : String;
begin
If not FileExists(FlBox.Text) then
 begin
  ShowMessage('Fees directory or file does not exist.'+
     Chr(13)+'Start with file ...\Fees.d');    //20160821
  exit;
 end;
 Screen.Cursor := crHourGlass;
 TempList := TstringList.Create;
 TempList.LoadFromFile(FlBox.Text);
 Table1.IndexName := UpperCase ('FormName'); // 20150920 Igor
 For i:=0 to TempList.Count-1 do
 begin
   FrmNm     := trim(LeftStr(TempList[i],8)); //20160830 Igor
   FrmFee    := trim(MidStr(TempList[i],9,7)); //20160830 Igor
   FrmAddFee := trim(MidStr(TempList[i],16,7)); //20160830 Igor
   if Table1.FindKey([FrmNm]) then
    begin
     Table1.Edit;
     Table1.FieldByName('Fee').AsString := Alltrim(FrmFee);
     Table1.FieldByName('FeeAddItem').AsString := AllTrim(FrmAddFee);
     Table1.Post;
    end
   else
    ShowMessage('Form '+FrmNm+' not found on data base');
 end;
 TempList.Free;
 InitFormsTable;
 Table1.IndexName := UpperCase ('Fee'); // 20150920 Igor;
 SortBy.ItemIndex :=1;

 Table1.First;
 Screen.Cursor := crDefault;
 ShowMessage('Fee schedule successfully imported');
end;


procedure TFeesT2_2027.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T2Help',HelpTopic);
end;

end.
