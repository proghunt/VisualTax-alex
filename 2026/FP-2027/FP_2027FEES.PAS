unit FP_2027FEES;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,DB,Grids,DBGrids,ExtCtrls,DBCtrls,
  FP_2027Declare, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;

type
  TFeesFP_2012 = class(TForm)
    DataSource1: TDataSource;
    Label1: TLabel;
    PrintDialog1: TPrintDialog;
    Panel2: TPanel;
    Panel1: TPanel;
    Label2: TLabel;
    ImportBtn: TBitBtn;
    ExportBtn: TBitBtn;
    FlBox: TEdit;
    PrintBtn: TBitBtn;
    Panel3: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    BitBtn1: TBitBtn;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Panel5: TPanel;
    SortBy: TRadioGroup;
    FDConnection: TADConnection;
    Table1: TADTable;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure SortByClick(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    Function  PostTxtFeesToDB(FlName:String):Boolean;
    procedure SaveToTxt(FlName:String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fees: TFeesFP_2012;

implementation

{$R *.DFM}

uses vtCommon,vtDialogs,FP_2027Common,FP_2027TrimStr,vtTrimStr,vtShared,
     vtDataBase;  // 20150919 Igor;

procedure TFeesFP_2012.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;

end;

procedure TFeesFP_2012.FormCreate(Sender: TObject);
begin

 If FileExists(AppDir+'\'+'Fees.txt') = false then
   CopyFile(AppDir+'\'+'SamplFee.d', AppDir+'\'+'Fees.txt');

 FlBox.Text := AppDir+'\'+'Fees.Txt';
 If not Table1.Active then
 begin
  //20150919 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, '');

  SortBy.ItemIndex :=1;
  SortByClick(Sender);
  Table1.Open;
  Table1.Edit;
  Table1.First;
 end;
 Table1.Close;
 PostTxtFeesToDB(AppDir+'\'+'Fees.txt');
   //db always
end;

procedure TFeesFP_2012.OKBtnClick(Sender: TObject);
begin
 Table1.Edit;
 Table1.Post;
 Close;
 //Flist.Clear;
 // also save it to TXT
 SaveToTxt(AppDir+'\'+'Fees.txt');
 InitFormsTable; {reinit the form specs}
 ShowTimedMsg('Done',1500);
end;

procedure TFeesFP_2012.SortByClick(Sender: TObject);
begin
 Case SortBy.ItemIndex of
 0: Table1.IndexName := 'FormName';
 1: Table1.IndexName := 'Fee';
 else
 Table1.IndexName := 'FormName';
 end;
If Table1.Active then Table1.First;
end;

procedure TFeesFP_2012.ExportBtnClick(Sender: TObject);
Begin
 If not DirectoryExists(ExtractFilePath(FlBox.Text)) then
 begin
  ShowMessage('Path does not exist');
  FlBox.SetFocus;
  exit;
 end;
 SaveToTxt(FlBox.Text);
 ShowMessage('Done');
end;

procedure TFeesFP_2012.SaveToTxt(FlName:String);
Var ListNdx:integer;Templist:TStringList; S,S1,S2,S3,S4:string;
begin
 LockWindowUpdate(Handle);
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
     s4 :=Table1.FieldByName('FormABREV').AsString;
     s :=PaddR(s1,15)
         +PaddR(s2,7)
         +PaddR(s3,7)
         +PaddR(s4,30);
     TempList.Add(s);
    end;
    Table1.Next;
  end;
  TempList.SaveToFile(FlBox.Text);
  TempList.Free;
  Table1.First;
  LockWindowUpdate(0);
end;


procedure TFeesFP_2012.ImportBtnClick(Sender: TObject);
begin
 If PostTxtFeesToDB(FlBox.Text)= True then
 begin
  ShowMessage('Fees imported');
  CopyFile(FlBox.Text,AppDir+'\'+'Fees.txt');
 end
 else
  ShowMessage('Import Fees Failed');
end;

Function TFeesFP_2012.PostTxtFeesToDB(flName:String):Boolean;
Var i:integer;Templist:TStringList;
  FrmNm,FrmFee,FrmAddFee : String;
begin
 If not FileExists(FlName) then
 begin
   TempList := TstringList.Create;
   TempList.SaveToFile(AppDir+'\'+'Fees.txt');
   TempList.Free;
 end;
 Result:=False;
 If not FileExists(FlName) then
 begin
  ShowMessage('Fees directory or file does not exist');
  exit;
 end;
 Screen.Cursor := crHourGlass;
 TempList := TstringList.Create;
 TempList.LoadFromFile(FlName);

 //20150919 Igor
 SetTableName(FDConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FORMNAME');

 For i:=0 to TempList.Count-1 do
 begin
   FrmNm     := AllTrim(LeftStr(TempList[i],15));
   FrmFee    := AllTrim(MidStr(TempList[i],16,7));
   FrmAddFee := AllTrim(MidStr(TempList[i],23,7));
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

 Table1.IndexName := 'Fee';
 SortBy.ItemIndex :=1;

 Table1.First;
 Screen.Cursor := crDefault;
 Result:=True;
end;

procedure TFeesFP_2012.PrintBtnClick(Sender: TObject);
Var i:integer;FileNm,Hdr1,Hdr2,Hdr3:string; F1:textFile; S:string;
begin
 FileNm := FlBox.Text;
 If not fileExists(FlBox.Text) then
 begin
  ShowMessage('Fee Schedule file does not exit. Please export fees first');
  exit;
 end;
 Hdr1 := PaddR('FEE SCHEDULE - File Name:',30)+
         PaddR(UpperCase(FlBox.Text),30)+PaddR(DateToMonthDayYear(Date),20);;
 Hdr2 := PaddR('FORM',15)
         +PaddR('FEE/ADDITIONAL',20)
         +PaddR('DESCRIPTION',50);
 Hdr3 := FilledStr(80,'=');;

 If PrintDialog1.Execute then
 begin
  If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
 end;

end;
(*
Var FileNm,Hdr1,Hdr2,Hdr3:string;
begin
 FileNm := FlBox.Text;
 If not fileExists(FlBox.Text) then
 begin
  ShowMessage('Fee Schedule file does not exit. Please export fees first');
  exit;
 end;
 Screen.Cursor := crHourGlass;
 Hdr1 := PaddR('FEE SCHEDULE - File Name: ',30)+
         PaddR(UpperCase(FlBox.Text),30)+PaddR(DateToMonthDayYear(Date),20);;
 Hdr2 := PaddR('FORM',10)
         +PaddR('FEE',10)
         +PaddR('ADDITIONAL',10)
         +PaddR('DESCRIPTION',50);
 Hdr3 := FilledStr(80,'=');;
 If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
  ShowMessage('Printing Completed');
 Screen.Cursor := crDefault;
end;
*)
procedure TFeesFP_2012.BitBtn1Click(Sender: TObject);
begin
 ShowHelp('FpHelp','Fee_schedule');
end;

end.
