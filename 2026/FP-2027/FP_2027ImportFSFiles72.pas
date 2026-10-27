unit FP_2027ImportFSFiles72;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,Grids,StdCtrls,Buttons,FileCtrl,Db,ComCtrls,ExtCtrls,DBGrids,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TImportFSFiles72FP_2012 = class(TForm)
    DataSource2: TDataSource;
    FileTypeBox: TRadioGroup;
    GroupBox1: TGroupBox;
    StringGrid1: TStringGrid;
    Panel3: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    DataDirBox: TEdit;
    ArchiveDirBox: TEdit;
    FileListBox1: TFileListBox;
    Panel2: TPanel;
    CancelBtn: TBitBtn;
    ProcessAllBtn: TBitBtn;
    ProcessFileBtn: TBitBtn;
    ArchiveBtn: TBitBtn;
    ArchiveAllBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    FDConnection: TADConnection;
    SuppliersTbl: TADTable;
    Procedure DrawGrid;
    Procedure GetFileNames;
    procedure FormCreate(Sender: TObject);
    procedure ProcessAllBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    {procedure StringGrid1DblClick(Sender: TObject);}
    Function GetFileDescr(FileCode,FileName:String):String;
    Function GetFundCoName(FundCoCode:String):String;
    {procedure PageControl1Change(Sender: TObject);}
    procedure FileTypeBoxClick(Sender: TObject);
    {procedure ProcessPricesBtnClick(Sender: TObject);}
    {Procedure ProcessPriceFile(FileName:String);}
    procedure ProcessFileBtnClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure ArchiveBtnClick(Sender: TObject);
    Function GetFileCode(FileName:String):String;
    {Function ConvertFSMonthCode(MonthCode:String):String;}
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImportFSFiles72: TImportFSFiles72FP_2012;
  FsInDirectory :String;
  FileName:String;
  FileCode:string; //[3];

implementation

{$R *.DFM}

uses
  vtCommon,
  FP_2027,FP_2027TrimStr,FP_2027Declare,FP_2027Response,
{$IFDEF ADO}
  FP_2012ProcessFsPrices,
{$ELSE}
{$ENDIF}
  FP_2027TransactionReconciliation,
  vtTrimStr;

Procedure TImportFSFiles72FP_2012.GetFileNames;
begin
  Case FileTypeBox.ItemIndex of
   0: FileListBox1.Mask := '*.*';
   1: FileListBox1.Mask := '???U????.*';
   2: FileListBox1.Mask := 'Prices.*';
   3: FileListBox1.Mask := 'T*.*';
   4: FileListBox1.Mask := 'F'+HoRec.DealerCode+'*.*';
   5: FileListBox1.Mask := '*.ZIP';
   6: FileListBox1.Mask := '???H????.*';
   7: FileListBox1.Mask := '???A????.*';
  end;
  FileListBox1.Directory := DataDirBox.Text;
end;

Procedure TImportFSFiles72FP_2012.DrawGrid;
Var i:integer;FileDate,FundCoName : string;
  FileType,FileDescr,FundCoCode,FileExt :String;
begin
  Screen.Cursor := crHourGlass;
  StringGrid1.FixedColor :=$00A6CAF0;
  StringGrid1.RowCount :=FileListBox1.Items.Count+1;

  With StringGrid1 do
  begin
   for i:=0 to FileListBox1.Items.Count-1 do
   begin
      FileName   := FileListBox1.items[i];
      FileCode   := GetFileCode(FileName);
      FileDescr  := GetFileDescr(FileCode,FileName);
      FundCoCode := UpperCase(LeftStr(FileName,3));
      FileExt    := ExtractFileExt(FileName);
      FileDate   := ConvertFsMonthCode(MidStr(FileExt,2,1))+
                    ' '+RightStr(FileExt,2);

      If (FileCode = 'ZIP') or (FileCode = 'STL') then
       FundCoName := 'N/A'
      else  If UpperCase(LeftStr(FileName,6)) = 'PRICES' then
           FundCoName := 'ALL'
      else FundCoName := GetFundCoName(FundCoCode);


      Cells[0,i+1] := FileName;
      Cells[1,i+1] := FileDescr;
      Cells[2,i+1] := FundCoName;
      Cells[3,i+1] := FileDate;
      Cells[4,i+1] := FileCode;

   end; {listbox}
  end; {stringlist}
  Screen.Cursor := crDefault;
end;

procedure TImportFSFiles72FP_2012.FormCreate(Sender: TObject);
begin
 FsInDirectory := HoRec.FsInDir;
 DataDirBox.Text := FsInDirectory;
 ArchiveDirBox.Text := HoRec.FsInArchive;
 If not DirectoryExists(DataDirBox.Text) then
  begin ShowMessage('Invalid In Folder'); end;

 If not DirectoryExists(ArchiveDirBox.Text) then
   begin ShowMessage('Invalid Archive Folder'); end;

 With StringGrid1 do
 begin
  ColWidths[0] := StringGrid1.DefaultColWidth+20;
  ColWidths[1] := StringGrid1.DefaultColWidth*3;
  ColWidths[2] := StringGrid1.DefaultColWidth*3;
  Cells[0,0] := 'FILE';
  Cells[1,0] := 'DESCRIPTION';
  Cells[2,0] := 'FUND COMPANY';
  Cells[3,0] := 'DATE';
  Cells[4,0] := 'FILE CODE';
 end;
 FileTypeBox.ItemIndex :=0;
 GetFileNames;
 DrawGrid;
 //20180503 Igor >>>
 if CheckIsCloud(true) then
 begin
   DataDirBox.Enabled := False;
   ArchiveDirBox.Enabled := False;
 end;
 //20180503 Igor <<<
end;

procedure TImportFSFiles72FP_2012.ProcessAllBtnClick(Sender: TObject);
Var i,j:Integer; Msg:TLabel;
begin
 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;

 Msg :=TLabel.Create(ImportFSFiles72);
 Msg.Parent := ImportFSFiles72;
 Msg.Left :=0;
 Msg.Top :=0;
 {
 Msg.Left := FsInfiles.Width div 3;
 Msg.Top := FsInfiles.Height div 2;
 }
 Msg.Color := clRed;
 Msg.Font.Size := 10;
 Msg.Caption := '';
 Msg.BringToFront;
 for i:=1 to StringGrid1.RowCount-1 do
  begin
     FileName := StringGrid1.Cells[0,i];
     Msg.Caption := 'Processing... '+FileName;
     Msg.Refresh;
     {Preview(FileName);}
  end;
 Msg.Free;
end;

procedure TImportFSFiles72FP_2012.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = HoRec.FsInDir then exit;
If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
GetFileNames;
DrawGrid;
end;

Function TImportFSFiles72FP_2012.GetFileDescr(FileCode,FileName:String):String;
begin
 If UpperCase(LeftStr(FileName,6)) = 'PRICES' then
  begin result :='Prices from all Fund Companies'; exit; end;

 If UpperCase(ExtractFileExt(FileName)) = '.ZIP' then
  begin result :='Double click to Unzip'; exit; end;

 If (UpperCase(LeftStr(FileName,1)) = 'F')
 and
  (MidStr(FileName,2,4) = HoRec.DealerCode) then
 begin
   result :='Settlement Instruction created by CSS';
   exit;
 end;
 If (UpperCase(MidStr(FileName,4,1)) = 'A')
 and(RightStr(FileName,4) = HoRec.DealerCode) then
 begin
  result := 'Account Reconciliation';
  exit;
 end;

 Result := '????????';
 {If      FileCode = 'A' then result := 'Account Reconciliation'}
 if FileCode = 'U' then result := 'CSS Error File'
 else if FileCode = 'M' then result := 'Month End Reconciliation'
 else if FileCode = 'N' then result := 'Non Financial Review'
 else if FileCode = 'O' then result := 'Order Entry'
 else if FileCode = 'K' then result := 'Order Entry Error'
 else if FileCode = 'R' then result := 'Order Entry Response'
 else if FileCode = 'P' then result := 'Price/Distribution Rate'
 else if FileCode = 'W' then result := 'Sales Commission'
 else if FileCode = 'S' then result := 'Service Fees'
 else if FileCode = 'F' then result := 'Settlement Instruction'
 else if FileCode = 'Q' then result := 'Settlement Instruction'
 else if FileCode = 'T' then result := 'Trans Reconciliation'
 else if FileCode = 'H' then result := 'History '
 else if FileCode = 'D' then result := 'Trans Reconciliation - Distribution'
 else if FileCode = 'Z' then result := 'Trans Reconciliation - Reorg';
end;

Function TImportFSFiles72FP_2012.GetFundCoName(FundCoCode:String):String;
Var FundCd:String;
begin
  With SuppliersTbl do
  begin
  if not Active then Open;
  IndexFieldNames := 'Supplier';
  If FindKey([FundCoCode])
   then result := FieldByName('Name').AsString
  else
   result := '???? Not in Fund Companies Data Base ????';
 end;
end;

procedure TImportFSFiles72FP_2012.FileTypeBoxClick(Sender: TObject);
begin
 GetFileNames;
 DrawGrid;
end;



(* Example if it was a pure typed file
Procedure TFSINFILES.ProcessPriceFile(FileNm:String);
{price layout from fS}
 Type
  TPriceRec = Record
  RecordID     :Array[1..6] of char;
  RecordType   :Array[1..3] of char;
  PriceStatus  :Array[1..1] of char;
  Supplier     :Array[1..3] of char;
  FundNo       :Array[1..5] of char;
  PriceDate    :Array[1..8] of char;
  PriceRate    :Array[1..11] of char;
  PosNeg       :Array[1..1] of char;
  DistrPayDate :Array[1..8] of char;
  Currency     :Array[1..2] of char;
  FundSpecific :Array[1..3] of char;
  Filler       :Array[1..9] of char;
 end;
Var PriceRec:TPriceRec;
     PriceFile : file of TPriceRec;
     Price :Real;
     Dt:String[10];
     FundId:String[10];
begin
 Screen.Cursor := crHourGlass;
 AssignFile(PriceFile,FileNm);
 Reset(PriceFile);
 Repeat
   Read(PriceFile,PriceRec);
   If PriceRec.RecordId = 'PRIDTL' then
   begin
      If MutualFundsTbl.FindKey([FundId]) then
      begin
       Price := Vl(LeftStr(PriceRec.PriceRate,7))/10000;
       Dt := LeftStr(PriceRec.PriceDate,4)+'/'+
       MidStr(PriceRec.PriceDate,5,2)+'/'+
       RightStr(PriceRec.PriceDate,2);

       FundId := AllTrim(PriceRec.Supplier)+AllTrim(PriceRec.FundNo);
       MutualFundsTbl.Edit;
       MutualFundsTbl.FieldByName('UnitPrice').AsFloat := Price;
       MutualFundsTbl.FieldByName('PriceDate').AsString := Dt;
       MutualFundsTbl.Post;
      end;
   end;
   Seek(PriceFile,FilePos(PriceFile)+1);
 Until EOF(PriceFile);
 Screen.Cursor := crDefault;
 ShowMessage('Completed');
end;
*)


procedure TImportFSFiles72FP_2012.ProcessFileBtnClick(Sender: TObject);
Var Psw:string; //[20];
begin
 FileName := StringGrid1.Cells[0,StringGrid1.Row];
 Case FileTypeBox.ItemIndex of
  1: ExecuteForm(TResponse);
  2:
  {$IFDEF ADO}
    ExecuteForm(TProcessFsPrices);
  {$ELSE}
    ADOMsg('TProcessFsPrices');
  {$ENDIF}
  4:
    ExecuteForm(TTransactionReconciliationFP_2012);
  5:
  Begin
   OpenDialog1.FileName := FlName;
   OpenDialog1.Execute;
  end;
  {UnzipAFile(Self.Handle,FlName);}
  6: {history}
   Begin
      ExecuteForm(TTransactionReconciliationFP_2012);
   end;
  7:
  {$IFDEF ADO}
    ExecuteForm(TAccountReconciliation);
  {$ELSE}
    ADOMsg('TAccountReconciliation');
  {$ENDIF}
 end;
end;

procedure TImportFSFiles72FP_2012.StringGrid1DblClick(Sender: TObject);
begin
 ProcessFileBtnClick(Sender);
end;

procedure TImportFSFiles72FP_2012.ArchiveBtnClick(Sender: TObject);
Var FileName:String; FileNameZ:Array[0..40] of Char;
begin
 FileName := StringGrid1.Cells[0,StringGrid1.Row];
 StrPCopy(FileNameZ,FileName);
 If CopyFile(DataDirBox.Text+'\'+FileName, ArchiveDirBox.Text+'\'+FileName) then
  Begin
   SysUtils.DeleteFile(DataDirBox.Text+'\'+FileName);
   GetFileNames;
   ShowMessage('Done');
  end
 else
   ShowMessage('File could not be archived. Directory missing or full');
end;



Function TImportFSFiles72FP_2012.GetFileCode(FileName:String):String;
begin
 If Uppercase(LeftStr(FileName,6)) = 'PRICES' then
 begin
   result :='PRI';
   exit;
 end;
 If UpperCase(ExtractFileExt(FileName)) = '.ZIP' then
 begin
   result :='ZIP';
   exit;
 end;

 If (UpperCase(LeftStr(FileName,1)) = 'F')
 and
  (MidStr(FileName,2,4) = HoRec.DealerCode) then
 begin
   result :='STL';
   exit;
 end;

 If (UpperCase(MidStr(FileName,4,1)) = 'H')
 and
  (MidStr(FileName,5,8) = HoRec.DealerCode) then
 begin
   result :='HIS';
   exit;
 end;
 {
 If UpperCase(LeftStr(FileName,1)) = 'K' then
  begin result :='K';exit;end;
 If UpperCase(LeftStr(FileName,1)) = 'U' then
  begin result :='U';exit;end;
 }
 result := UpperCase(Midstr(FileName,4,1));
end;

end.
