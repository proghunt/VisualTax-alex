unit Efer;
{
The TddMaster.dbf is build and updated from text files.
i.e. the Tddmaster1.txt created by using the TXT file produced by
running the AutoFill program with several files to capture the data fields returned by CRA
These text files could also be created manually by adding lines to them
Logic: if the line (FullField dos not exist the add it to the data base

The dbf provides the valid data fields used by TDD and specifies the formName and EmNo
where it will be saved on the tax return
}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, Mask, ExtCtrls,Dialogs,
  {MyStr,}UDecl,{TrimStr,UDeclare,} Grids, DBGrids, Buttons, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanExprFuncs, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient,
  uADPhysSQLite, uADGUIxFormsWait, uADCompGUIx,
  strUtils, Data.DB, Vcl.DBCtrls;

type
  TMainForm = class(TForm)
    DBNavigator: TDBNavigator;
    Panel1: TPanel;
    DataSource1: TDataSource;
    UpdateBtn: TButton;
    CancelBtn: TButton;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    EmptyBtn: TButton;
    DataSource2: TDataSource;
    ADConnection1: TADConnection;
    ADConnection2: TADConnection;
    ADPhysSQLiteDriverLink1: TADPhysSQLiteDriverLink;
    tddElms: TADTable;
    TddMessages: TADTable;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    procedure FormCreate(Sender: TObject);
    procedure UpdateBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure EmptyBtnClick(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AppDir:String;
  MainForm: TMainForm;
  FList:TStringList;
  Flist2:TStringList;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
Var
  TXTFileName: String;
  TXTFileName2: String;
  myList: TStringList;
begin
  AppDir := ExtractFilePath(Application.ExeName);
  TxtFileName:= 'TddElms.txt';
  TxtFileName2:='TddMessages.txt';

  Flist:=TStringList.Create;
  FList.Loadfromfile(AppDir+TxtFileName);

  Flist2:=TStringList.Create;
  Flist2.LoadFromFile(AppDir+TxtFileName2);

  If tddElms.Active then tddElms.Close;
  if TddMessages.Active then TddMessages.Close;
  myList := TStringList.Create;
  try

    ADConnection1.Params.Values['DataBase'] := AppDir + '\TddElms.db';
    ADConnection1.Open;
    ADConnection1.GetTableNames('','','', myList);
    if MyList.IndexOf('TddElms') = -1 then
    begin
      ADConnection1.ExecSQL('CREATE TABLE TddElms ('+
        'FIELDKEY VARCHAR(80),'+
        'BOXNO VARCHAR(3) NOT NULL, '+
        'YEAR VARCHAR(4), '+
        'ISDOLLAR VARCHAR(1), '+
        'FORMNAME VARCHAR(14), '+
//        '_DBASELOCK VARCHAR(16), '+ //20170222 Igor
        'ELMNO VARCHAR(3), '+
        'SECTION VARCHAR(50), '+
        'GROUPNAME VARCHAR(50), '+
        'FIELDNAME VARCHAR(50),'+
        'ELMS VARCHAR(255))');

        ADConnection1.ExecSQL('CREATE INDEX FIELDKEY ON TddElms (FIELDKEY)');
    end;
    tddElms.Open;
    tddElms.IndexName := 'FIELDKEY';
  //    Table1.DataBaseName := AppDir;
  //    Table1.TableName := 'TddElms.dbf';
  //    Table1.IndexName := 'FieldKey';      //Subsection-and-data element
  //    Table1.Open;
  //    Table1.First;
  //    Table1.Edit;
    myList.Clear;
    ADConnection2.GetTableNames('','','', myList);
    ADConnection2.Params.Values['DataBase'] := AppDir + '\TddMessages.db';
    ADConnection2.Open;
    ADConnection2.GetTableNames('','','', myList);
    if MyList.IndexOf('TddMessages') = -1 then
    begin
      ADConnection2.ExecSQL('CREATE TABLE TddMessages ('+
        'FIELDKEY VARCHAR(50),'+
        'TDDMESSAGE VARCHAR(20))');

      ADConnection2.ExecSQL('CREATE INDEX FIELDKEY ON TddMessages (FIELDKEY)');
    end;
    TddMessages.Open;
    TddMessages.IndexName := 'FIELDKEY';
//    If Table2.Active then Table2.Close;
//    If not Table2.Active then
//     begin
//      Table2.DataBaseName := AppDir;
//      Table2.TableName := 'TddMessages.dbf';
//      Table2.IndexName := 'FieldKey';      //Subsection-and-data element
//      Table2.Open;
//      Table2.First;
//      Table2.Edit;
//     end;
  finally
    myList.Free;
  end;

   DbGrid1.Refresh;
end;

procedure TMainForm.UpdateBtnClick(Sender: TObject);
Var
  i:integer;
  s:String;

  TddMessage:String;
  GroupName,FieldName,FieldKey,BoxNo,Section,FormName,ElmNo,IsDollar:string;
begin
 For i:=0 to Flist.count-1 do
 Begin
  s:=Flist[i];
  GroupName     := Trim(Copy(s,46,35));
  FieldName     := Trim(Copy(s,81,60));
  FieldKey      := GroupName + '-' + FieldName;
  BoxNo         := Trim(Copy(s,141,3));
  Section       := Trim(LeftStr(s,45));
  FormName      := Trim(Copy(s,145,14));
  ElmNo         := Trim(Copy(s,162,4));

  If MidStr(s,160,1)='$' then
    IsDollar    := 'Y'
  else
    IsDollar    :=' ';

  if FieldName > '' then
  Begin
  //20170301 Igor >>>
    if tddElms.Locate('FieldKey', FieldKey, []) then
      tddElms.Edit
    else
      tddElms.Append;
    tddElms.FieldByName('FieldKey').AsString := FieldKey;
    tddElms.FieldByName('BoxNo').AsString := BoxNo;
    tddElms.FieldByName('YEAR').AsString := ' ';
    tddElms.FieldByName('ISDOLLAR').AsString := ISDOLLAR;
    tddElms.FieldByName('FORMNAME').AsString := FORMNAME;
    tddElms.FieldByName('ELMNO').AsString := ELMNO;
    tddElms.FieldByName('SECTION').AsString := SECTION;
    tddElms.FieldByName('GROUPNAME').AsString := GROUPNAME;
    tddElms.FieldByName('FIELDNAME').AsString := FIELDNAME;

//    tddElms.InsertRecord([
//        FieldKey      ,
//        BoxNo         ,
//        ' '           ,//year
//        IsDollar      ,
//        FormName      ,
//        ElmNo         ,
//        Section       ,
//        GroupName     ,
//        FieldName
//    ]);

  //20170301 Igor <<<
    tddElms.Post;
  end;
  //application.processmessages;
  //sleep(1000);


(*
  s:=Flist[i];
  Table1.FieldByName('Section').AsString := AllTrim(LeftStr(s,45));  //Major data section boxno
  Table1.FieldByName('GroupName').AsString :=AllTrim(MidStr(s,46,35));
  Table1.FieldByName('FieldName').AsString :=AllTrim(MidStr(s,81,60));

  if Table1.FieldByName('FieldName').AsString>'' then
  Begin
    FieldKey:=Table1.FieldByName('GroupName').AsString+'-'+Table1.FieldByName('FieldName').AsString;
    //DBF's do not accept keys more than 100 bytes

    If Table1.FindKey([FieldKey]) then
      Table1.Edit
    else
      Table1.Insert;

    Table1.FieldByName('FieldKey').AsString      := FieldKey;                    //fieldkey
    Table1.FieldByName('BoxNo').AsString         := AllTrim(MidStr(s,141,3));    //boxno
    Table1.FieldByName('FormName').AsString      := AllTrim(MidStr(s,145,14));   //FormName

    If MidStr(s,160,1)='$' then                                 //Is dollar
      Table1.FieldByName('IsDollar').AsString    := 'Y'
    else
      Table1.FieldByName('IsDollar').AsString    :=' ';

    Table1.FieldByName('ElmNo').AsString:=       AllTrim(MidStr(s,162,4));       //ElmNo

    If Table1.FieldByName('FieldName').AsString='EmployerName' then
    Begin
      ShowMessage('field key='+FieldKey);
      ShowMessage('Section='+Table1.FieldByName('Section').AsString);
      ShowMessage('GroupName='+Table1.FieldByName('Groupname').AsString);
      ShowMessage('FieldName='+Table1.FieldByName('FieldName').AsString);
    End;

    Table1.Post;
    end;  //if Table1.FieldByName('FieldName').AsString>''
 *)

 end; //For i:=0 to Flist.count-1


 //update the tddmessages now
 For i:=0 to Flist2.count-1 do
 Begin
  TddMessages.Edit;
  s:=Flist2[i];
  If S>'' then
  Begin
   FieldKey:=Trim(LeftStr(s,80));
   TddMessage:=Trim(MidStr(s,81,200));    //btddmessage

   If TddMessages.FindKey([FieldKey]) then
    TddMessages.Edit
   else
    TddMessages.Insert;

   TddMessages.FieldByName('FieldKey').AsString := FieldKey;
   TddMessages.FieldByName('TddMessage').AsString :=TddMessage;
   TddMessages.Post;
  end; //s
 end; //i

 DbGrid1.Refresh;
 ShowMessage('Done. NOW copy tddElms.db to vt directory');
end;


procedure TMainForm.CancelBtnClick(Sender: TObject);
begin
TddMessages.Close;
Close;
end;





procedure TMainForm.EmptyBtnClick(Sender: TObject);
begin
//MsgDialog('Delete?'Are you sur
tddElms.first;
While not tddElms.Eof do
 Begin
  tddElms.Edit;
  tddElms.Delete;
 end;

TddMessages.first;
While not TddMessages.Eof do
 Begin
  TddMessages.Edit;
  TddMessages.Delete;
 end;

end;

end.