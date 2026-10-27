unit T1_2026ExportData;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls,Db,Grids,DBGrids,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TExportDataT1_2026 = class(TForm)
    Panel3: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    DataSource1: TDataSource;
    Panel5: TPanel;
    TemplateBox: TEdit;
    Panel6: TPanel;
    Label3: TLabel;
    ExportFileBox: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    SaveBtn: TBitBtn;
    Label9: TLabel;
    Memo1: TMemo;
    SelectBtn: TBitBtn;
    CancelBtn: TBitBtn;
    SaveDialog1: TSaveDialog;
    SelectedReturns: TListBox;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    DataDirBox: TEdit;
    FromDateBox: TEdit;
    ToDateBox: TEdit;
    DiscountedBox: TCheckBox;
    Label11: TLabel;
    ExportBtn: TBitBtn;
    SaveAsBox: TEdit;
    DataList: TMemo;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    FDConnection: TADConnection;
    Table1: TADTable;
    procedure SelectBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    Function ShowReturns: Boolean;
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadTemplate;
    Function ValidateTemplate:Boolean;
    Function GetFrmName(S:String):String;
    Function GetElmNo(S:String):Integer;
    procedure TemplateBoxExit(Sender: TObject);
    procedure GetTheData(Retno:Integer);
    procedure ExportBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ExportFileBoxExit(Sender: TObject);
  private
    { Private declarations }
  public
    InitialDir : string; //[66];
    RetNo:Integer;
    {ExpDir     : String;}
  end;

var
  ExportData: TExportDataT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026Calc,vtTrimStr,vtShared, vtDataBase;

procedure TExportDataT1_2026.SelectBtnClick(Sender: TObject);
var i,j:integer; FlName:string; //[12];
begin
 If ValidateTemplate = false then exit;
 Screen.Cursor := crHourGlass;
 SelectedReturns.Clear;
 DataList.Clear;
 Table1.First;
 Repeat
  If DiscountedBox.Checked = true then
  begin
   If (Table1.FieldByName('Updated_dt').AsString >= FromDateBox.Text)
   and (Table1.FieldByName('Updated_dt').AsString <= ToDateBox.Text)
   and (Table1.FieldByName('Discounted').AsString = 'Y')
   then
    SelectedReturns.Items.Add(Table1.FieldByName('Sin').AsString
            +' '+Table1.FieldByName('Last_Name').AsString
            +' '+Table1.FieldByName('First_Name').AsString);

  end
  else
  begin
   If (Table1.FieldByName('Updated_dt').AsString >= FromDateBox.Text)
   and (Table1.FieldByName('Updated_dt').AsString <= ToDateBox.Text)
   then
    SelectedReturns.Items.Add(Table1.FieldByName('Sin').AsString
            +' '+Table1.FieldByName('Last_Name').AsString
            +' '+Table1.FieldByName('First_Name').AsString);
  end;
  Table1.Next;
 until Table1.Eof;
 Screen.Cursor := crDefault;
 If SelectedReturns.Items.count =0 then ShowMessage('No returns selected');
end;

procedure TExportDataT1_2026.GetTheData(Retno:Integer);
Var i:Integer;FrmName:String; s:String; CleanData:String;
Elm:Integer;
begin
 s:='';
 For i:=0 to Memo1.lines.Count-1 do
 begin
  FrmName := GetFrmName(Memo1.Lines[i]);
  Elm := GetElmNo(Memo1.Lines[i]);
  CleanData := AllTrim(ReplaceChar(FetchElm(RetNo,FrmName,Elm),',',' '));
  if i=0 then
    s:=CleanData
  else
    s:=s+','+CleanData;
 end;
 DataList.Lines.Add(s);
end;

procedure TExportDataT1_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
   //20150904 igor
  FDConnection.Params.Values['Password'] := OptRec.SQLLitePassword.CurrentPassword; //20160226 Igor
 ExportFileBox.Text:='';
 TempList:= TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'ExpDir.d');
 ExportFileBox.Text:=Templist[0];
 {
 else
  ExpDir :=AppDir+'\'+'ExportedData';
  }
 (*
 If Not DirectoryExists(ExtractFilePath(ExpDir)) then
 begin
  {$I-}
  MkDir(ExtractFilePath(ExpDir));
  if IOResult <> 0 then
    MessageDlg('Cannot create directory '+ExtractFilePath(ExpDir), mtWarning, [mbOk], 0);
 end;
 *)
 DiscountedBox.Checked := True;
 FromDateBox.Text:=FormatDateTime('yyyy-mm-dd',Now);
 ToDateBox.Text:=FormatDateTime('yyyy-mm-dd',Now);
 TemplateBox.Text := AppDir+'\'+'ExportTpl1.Txt';
 SaveAsBox.Text := TemplateBox.Text;
 {ExportFileBox.Text := ExpDir;} {+'\'+'T1Export.Txt';}
 {ExportFileBox.Text := ExpDir+'\'+'T1Export.Txt';}
 ShowReturns;
 LoadTemplate;
 {
 TempList.Clear;
 TempList.Add( ExportFileBox.Text);
 TempList.SaveToFile(AppDir+'\'+'Expdir.d');
 }
 TempList.Free;
end;

procedure TExportDataT1_2026.LoadTemplate;
begin
 If not FileExists(TemplateBox.Text) then
 begin
  ShowMessage('Template '+TemplateBox.Text + ' not found');
  exit;
 end;
 Memo1.Clear;
 Memo1.Lines.LoadFromFile(TemplateBox.Text);
end;

procedure TExportDataT1_2026.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TExportDataT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
If (ChangeDataDir(DataDirBox.Text) = False) then
  begin
   DataDirBox.Text := OptRec.Dir_Cur;
   DataDirBox.Refresh;
   exit;
  end
 else
   begin
   OptRec.Dir_Cur := DataDirBox.Text;
   Try

   Table1.Close;
   //20150826 igor
   SetTableName(FDConnection, Table1,
                       DataDirBox.Text + '\' + ClientsDbLite, ClientsTableLite, 'Last_Name');
   except
   on EdataBaseError do MessageBeep(0); end;
 end;

end;

procedure TExportDataT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then DataDirBoxExit(Application);
end;

Function TExportDataT1_2026.ShowReturns: Boolean;
begin
 If Not FileExists(OptRec.Dir_Cur+'\'+ClientsDbLite) then
 begin
  ShowMessage('There is no Clients data base in this directory'+
    Chr(13)+'Use Configure | Data Directories');
    result :=false;
    exit;
 end;
 Result := true;
 If Table1.Active then Table1.Close;
 //20150826 igor
 SetTableName(FDConnection, Table1,
                       OptRec.Dir_Cur + '\' + ClientsDbLite, ClientsTableLite, 'Last_Name');

  Try
    Table1.Open
  except
   on EdataBaseError do
     begin
      ShowMessage('Data Base cannot be opened'+
         Chr(13)+'Use Configure | Data Directories and save configuration');
      result := False;
      exit;
     end;
  end;
  DataDirBox.Text := OptRec.Dir_Cur;
  Screen.Cursor := crDefault;
  If Table1.RecordCount = 0 then
  begin
   ShowMessage('DataBase is empty. Press Close');
   exit;
  end;
end;

procedure TExportDataT1_2026.SaveBtnClick(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(SaveAsBox.Text);
  ShowMessage('Saved');
end;

Function TExportDataT1_2026.ValidateTemplate:Boolean;
var i:Integer;FrmName:String;Elm:Integer;
begin
 For i :=0 to Memo1.lines.count-1 do
 begin
  FrmName:= GetFrmName(Memo1.lines[i]);
  Elm := GetElmNo(Memo1.lines[i]);
  If GetFormNo(FrmName)=0 then
  begin
   ShowMessage('Form name (pos. 1-10) '+FrmName+' is invalid');
   result := false;
   exit;
  end;
  If Elm=0 then
  begin
   ShowMessage('Cell No (Pos. 11-13) '+IntToStr(Elm)+' is missing or not numeric');
   result := false;
   exit;
  end;
  Result := True;
 end;
end;

Function TExportDataT1_2026.GetFrmName(S:String):String;
begin
  Result := UpperCase(AllTrim(LeftStr(s,10)));
end;

Function TExportDataT1_2026.GetElmNo(S:String):Integer;
begin
  Result := MyStrToInt(UpperCase(AllTrim(MidStr(s,11,3))));
end;


procedure TExportDataT1_2026.TemplateBoxExit(Sender: TObject);
begin
 If Not FileExists(TemplateBox.Text) then
 begin
  ShowMessage('Template '+TemplateBox.Text +' does not exist');
  exit;
 end;
end;

procedure TExportDataT1_2026.ExportBtnClick(Sender: TObject);
Var i:Integer;FlName:String;
begin
 Screen.Cursor := crDefault;

 If ExtractFileName(ExportFileBox.Text) ='' then
  begin
   ShowMessage('File Name must be entered in the path');
   exit;
  end;

 If FileExists(ExportFileBox.Text) then
 begin
 if MessageDlg('Replace existing file?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
 end
 else
 begin
  If not DirectoryExists(ExtractFilePath(ExportFileBox.Text)) then
  begin
   ShowMessage('Directory does not exist');
   exit;
  end;
 end;



 If SelectedReturns.Items.count =0 then
 begin
  ShowMessage('No returns selected');
  exit;
 end;



 for i:=0 to SelectedReturns.Items.Count -1 do
  begin
     SelectedReturns.ItemIndex :=i;
     SelectedReturns.Refresh;
     FlName := LeftStr(SelectedReturns.Items[i],8)
     +'.'+MidStr(SelectedReturns.Items[i],9,1);
     If (UpperCase(SelectedReturns.Items[i]) <> ClientsDbLite) then
     try
        RetNo:=ReadReturn(DataDirBox.Text,FlName);
        if RetNo > 0 then
         begin
          Label7.Caption := '#'+IntToStr(i+1);
          Label7.Refresh;
          GetTheData(RetNo);
         end
        except
        end;
     If RetNo >0 then RemoveReturnFromMemory(RetNo);
     RetNo :=0; //RetINmem :=0;
  end;
  DataList.Lines.SaveToFile(ExportFileBox.Text);
  ShowMessage('completed');
  Screen.Cursor := crDefault;
end;

procedure TExportDataT1_2026.BitBtn1Click(Sender: TObject);
begin
 If Not FileExists(TemplateBox.Text) then
 begin
  ShowMessage('Template '+TemplateBox.Text +' does not exist');
  exit;
 end;
end;

procedure TExportDataT1_2026.ExportFileBoxExit(Sender: TObject);
Var TempList:TStringList;
begin
 If Not DirectoryExists(ExtractFilePath(ExportFileBox.Text)) then
 begin
  {$I-}
  MkDir(ExtractFilePath(ExportFileBox.Text));
  if IOResult <> 0 then
    MessageDlg('Cannot create directory '+ExtractFilePath(ExportFileBox.Text), mtWarning, [mbOk], 0);
 end;

 TempList:=TStringList.Create;
 TempList.Add(ExportFileBox.Text);
 TempList.SaveToFile(AppDir+'\'+'Expdir.d');
 TempList.Free;
end;

end.
