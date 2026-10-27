unit FP_2027removenullvalues;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
     Buttons,Db,FP_2027Declare,FP_2027TrimStr
   , vtDataBase, uADCompClient; // 20150923 Igor

type
  TRemoveNullValues = class(TForm)
    ListBox1: TListBox;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DoAllBtn: TBitBtn;
    Label1: TLabel;
    ListBox2: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    Procedure DoOne(TblName:String);
    procedure DoAllBtnClick(Sender: TObject);
    Procedure DoIt(Tbl:TADTable);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RemoveNullValues: TRemoveNullValues;
  TblName:String;
implementation

{$R *.DFM}

procedure TRemoveNullValues.CancelBtnClick(Sender: TObject);
 begin
Close;
end;

procedure TRemoveNullValues.OkBtnClick(Sender: TObject);
begin
 ListBox2.Items.Clear;
 TblName :=ListBox1.Items[ListBox1.ItemIndex];
 Screen.Cursor := crHourGlass;
 DoOne(TblName);
 Screen.Cursor := crDefault;
end;

procedure TRemoveNullValues.DoOne(TblName:String);
Var ADConnection: TADConnection;
    Tbl: TADTable;
begin
 //20150923 Igor
 ADConnection:= TADConnection.Create(Application);
 Tbl := TADTable.Create(Application);
 SetTableName(ADConnection, Tbl, cfgClientsDbLite_noUse, TblName, '');

 DoIt(Tbl);
 Tbl.Close;
 Tbl.Free;
 ADConnection.Free;
end;

Procedure TRemoveNullValues.DoIt(Tbl:TADTable);
Var i:Integer;
begin
 Tbl.Active := False;
 repeat { until successful or Cancel button is pressed }
  try
    Tbl.Exclusive := True; { See if it will open }
    Tbl.Active := True;
    Break; { If no error, exit the loop }
  except
    on EDatabaseError do
     begin
     ShowMessage('Could not open the table '+Tbl.TableName+ ' exclusively');
     Break;
     end;
    {
      if Application.MessageBox(
        'Could not open the table '+Tbl.TableName+ ' exclusively - Try again?',
        'Open Error',
        MB_OKCANCEL + MB_DEFBUTTON1) <> IDOK then
        raise;
   }
 {Otherwise resume the repeat loop }
  end;
 until False;


 With Tbl do
 begin
  Tbl.First;
  Repeat
     for I := 0 to FieldCount - 1 do
     begin
      If (Fields[i].Value = 0)//20150819  Igor Null)
       or (Length(Fields[i].Value) =0) then
      begin
       Edit;
       If ((Fields[I].DataType = ftString)
         or (Fields[I].DataType = ftFixedChar)
         or (Fields[I].DataType = ftWideString)) then
         begin
          If Fields[I].DataSize <2 then Fields[I].Value := '?'
          else If Fields[I].DataSize =2 then Fields[I].Value := '??'
          else Fields[I].Value := 'N/A';
         end
       else If Fields[I].DataType = ftFloat then  Fields[I].Value := 0.0
       else If Fields[I].DataType = ftInteger then  Fields[I].Value := 0
       else If Fields[I].DataType = ftSmallInt then  Fields[I].Value := 0
       else If Fields[I].DataType = ftLargeInt then  Fields[I].Value := 0
       else If Fields[I].DataType = ftWord then  Fields[I].Value := 0
       else If Fields[I].DataType = ftCurrency then  Fields[I].Value := '$0';
       {
       else If Fields[I].DataType = ftWideString then  Fields[I].Value := ''
       else If Fields[I].DataType = ftFixedChar then  Fields[I].Value := '';
       }
       {else If Fields[I].DataType = ftUnknown then  Fields[I].Value := '';}
       Try
        Post;
       Except
        on E: Exception do
        begin
         If MessageDlg(E.Message+Chr(13)+' Exit/redo from beginning? ', mtError, [mbYes,mbNo], 0) = mrYes
         then Abort;
         Abort;
         break;
        end;
       end; {Try}
      end; {null value}
     end; {loop i}
   Next;
  until Tbl.Eof;
 end; {with tbl}
 ListBox2.Items.Add(TblName + ' done');
end;

procedure TRemoveNullValues.DoAllBtnClick(Sender: TObject);
Var I:Integer;
begin
 ListBox2.Items.Clear;
 Screen.Cursor := crHourGlass;
 For i:=0 to ListBox1.Items.Count-1 do
 begin
  ListBox1.ItemIndex := i;
  TblName :=ListBox1.Items[i];
  If (UpperCase(TblName) <> 'ACCOUNTS')
  and (UpperCase(TblName) <> 'TRANSACTIONS')
  then
  DoOne(TblName);
 end;
 Screen.Cursor := crDefault;
 ShowMessage('Done');
end;

procedure TRemoveNullValues.FormCreate(Sender: TObject);
begin
ListBox1.ItemIndex := 0;
end;


end.
