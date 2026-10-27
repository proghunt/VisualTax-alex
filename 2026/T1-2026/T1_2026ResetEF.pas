unit T1_2026ResetEF;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,FileCtrl,Buttons,ExtCtrls,DB;

type
  TResetEFT1_2026 = class(TForm)
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel2: TPanel;
    FileListBox1: TFileListBox;
    DataDirBox: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Panel4: TPanel;
    BackUpBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure DrawList;
    procedure CancelBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure IncreaseYear(Frm:String;Elm:Integer);
    procedure BackUpBtnClick(Sender: TObject);
    Procedure ResetEFInDB(FlName:String);
  private
    RetNo:Integer;
  public
    { Public declarations }
  end;

var
  ResetEF: TResetEFT1_2026;
implementation

uses vtMulti,vtCommon,vtDialogs,T1_2026,T1_2026Declare,T1_2026TrimStr,
  T1_2026Common,T1_2026Common2,T1_2026Calc,T1_2026Features,T1_2026main,
  vtTrimStr,vtShared, uADCompClient, vtDataBase; //20150826 igor

{$R *.DFM}

procedure TResetEFT1_2026.OKBtnClick(Sender: TObject);
var i,j:integer; PrpStatus,EFStatus, Notes, FlName:String;
begin
 If IsDataDirectoryGood(DataDirBox.Text) = False then exit;

 If Not DirectoryExists(DataDirBox.Text) then
 begin
  ShowMessage('Data directory does not exist');
  DataDirBox.SetFocus;
  exit;
 end;

 OKbtn.Enabled:=False; CancelBtn.Enabled:=False;
 for i:=0 to FileListBox1.Items.Count -1 do
  begin
   Try
     If Flist.Count>100 then InitFormsTable;
     FileListBox1.ItemIndex :=i;
     FileListBox1.Refresh;
     If (UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite))              //20150909 Igor
     and(UpperCase(FileListBox1.Items[i]) <> UpperCase(ClientsDBLite) + '-JOURNAL') //20150909 Igor
     then
     try
        RetNo:=ReadReturn(DataDirBox.Text,FileListBox1.Items[i]);
        if RetNo > 0 then
        begin
         // ShowMessage(FileListBox1.Items[i]);
          FlName:=FileListBox1.Items[i];
          ResetEFInDB(FlName);
          //20171221
          Ret[RetNo].Locked:= False;
          //Ret[RetNo].ReadOnly:=False;  //cannot do this property
          Ret[RetNo].isAppendix:=False;

          Label7.Caption := '#'+IntToStr(i+1);
          Label7.Refresh;
          StoreElm(RetNo,'T183',21,'');  //remove the DCN
          //20171220
          StoreElm(RetNo,'T183',36,'');  //remove the DCN
          StoreElm(RetNo,'T183',37,'');  //remove the Confirm
          //---
          StoreElm(RetNo,'STATUS',15,'00');  //wip
          StoreElm(RetNo,'STATUS',37,'');  //remove confirmation //20171220
         // CalcAll(RetNo);  //20171220
          Ret[retNo].Frm[GetFormNo('STATUS')].Strings[11]:=User.UserName; //20170112 Igor
          Ret[retNo].Frm[GetFormNo('STATUS')].Strings[12]:=FormatDateTime('yyyy-mm-dd',Now);
          Ret[retNo].Frm[GetFormNo('STATUS')].Strings[13]:=TimeToStr(Time);
          If not SaveReturn(RetNo,DataDirBox.Text,FileListBox1.Items[i],True,False) =0
           then ShowMessage('Return cannot be saved');
        end;
     except
     end;
     If RetNo >0 then RemoveReturnFromMemory(RetNo);
     RetNo :=0; //RetINmem :=0;
   Except
      ShowMessage(FileListBox1.Items[i]);
   end;
  end; //i
  ShowMessage('Done');
  OKbtn.Enabled:=True; CancelBtn.Enabled:=True;
  InitFormsTable;
  Close;
end;


procedure TResetEFT1_2026.IncreaseYear(Frm:String;Elm:Integer);
Var s:String;
begin
 s:= '1998'+midStr(FetchElm(RetNo,Frm,elm),5,6);
 StoreElm(retNo,Frm,elm,s);
end;

procedure TResetEFT1_2026.FormCreate(Sender: TObject);
begin
Screen.Cursor := crHourGlass;
DataDirBox.Text := OptRec.Dir_Cur;
DrawList;
Screen.Cursor := crDefault;
end;

procedure TResetEFT1_2026.FormPaint(Sender: TObject);
begin
 If DataDirBox.Text <> OptRec.Dir_Cur then
 begin
  If not DirectoryExists(DataDirBox.Text) then
   begin ShowMessage('Invalid Directory');exit; end;
  DrawList;
 end;
end;

procedure TResetEFT1_2026.DrawList;
begin
FileListBox1.Directory := DataDirBox.Text;
FileListBox1.Mask := '*.*';
FileListBox1.ItemIndex :=0;
Label3.Caption := IntToStr(FileListBox1.Items.Count-2);
end;

procedure TResetEFT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TResetEFT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;
//ReCalc.Invalidate; {DrawList;}
end;

procedure TResetEFT1_2026.BackUpBtnClick(Sender: TObject);
begin
 MainFormT1.Backupthetaxdata1Click(Sender);
end;


Procedure TResetEFT1_2026.ResetEFInDB(FlName:String);
//match on file name and store the DcnNo (13 chars) starting at pos 6 on (after the Efiler No)
//Var Table1:TADTable;DcnSeq:String;
//var lPsw:String; //20160303 Igor
var
  FDConnection: TADConnection; //20160303 Igor
begin
//  fGetSQLitePsw(lPsw); //20150925 igor //20160303 Igor

  // FlName:=LeftStr(SinNo,8)+'.'+RightStr(SinNo,1);
  //20150826 igor
  //20160303 Igor >>>
  FDConnection := TADConnection.Create(nil);
//  with TADConnection.Create(nil) do
  try
    if SetConnection(FDConnection,OptRec.Dir_Cur + '\' + ClientsDbLite,ClientsTableLite) then
    Begin
//    DriverName := 'SQLite';
//    Params.Values['DataBase'] := OptRec.Dir_Cur + '\' + ClientsDbLite;
//    //20150904 igor
//    Params.Values['Password'] := lPsw;
      if FDConnection.ExecSQL('UPDATE ' + ClientsTableLite + ' SET EF_STATUS = ''00'' WHERE lower(File_Name) = lower(''' + FlName + ''')') = 0 then//20170223 Igor
        ShowTimedMsg('Return '+FlName+' not found while updating the EF status',1300);
    End;
  finally
    FDConnection.Free;
  end;
  //20160303 Igor  <<<<
{  Table1 := TTable.Create(Application);
  Table1.DataBaseName := OptRec.Dir_Cur;
  Table1.TableName := ClientsTable;
  Table1.IndexName := 'File_Name';
  Table1.Open;
  if Table1.FindKey([FlName]) then
  begin
   Table1.edit;
   Table1.FieldByName('EF_STATUS').AsString := '00';
   Table1.Post;
  end
  Else
  begin
   ShowTimedMsg('Return '+FlName+' not found while updating the EF status',1300);
  end;
  Table1.Close;
  Table1.Free;}
end;


end.
