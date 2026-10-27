unit T2_2027taxbyte;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,ExtCtrls,DB,StdCtrls,Grids,DBGrids,DBCtrls,Menus,Buttons,
  Mask,ComCtrls, VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADCompDataSet, uADCompClient;


type
  TTaxbyteT2_2027 = class(TForm)
    MonitorPlanBtn: TChart;
    Label3: TLabel;
    CancelBtn: TBitBtn;
    ConvertOneBtn: TBitBtn;
    ConvertAllBtn: TBitBtn;
    ToDirBox: TEdit;
    ReplaceOptionBox: TRadioGroup;
    ShowFilesBtn: TBitBtn;
    BookBack: TShape;
    RPanel: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    LPanel: TPanel;
    DBGrid1: TDBGrid;
    Panel6: TPanel;
    Image3: TImage;
    Image1: TImage;
    Image2: TImage;
    DataSource1: TDataSource;
    HelpBtn: TBitBtn;
    ClientsQ: TADQuery;

    Function MkFlName:String;
    procedure FormCreate(Sender: TObject);
    procedure OpenClientsQ;
    procedure CancelBtnClick(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure ShowClients;
    procedure ConvertAllBtnClick(Sender: TObject);
    procedure SaveIt(FlName:String);
    procedure MapData(FlName:String);
    procedure ConvertOne(FlName:String);
    procedure ConvertAll;
    procedure ConvertOneBtnClick(Sender: TObject);
    procedure ShowFilesBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TaxbyteT2_2027: TTaxbyteT2_2027;

  FlName: string; //[60];
  RetNo : integer;
  Cnt   : integer;
  InitialRowCount :integer;


implementation

{$R *.DFM}

uses vtMulti,vtCommon,T2_2027,T2_2027Declare,T2_2027TrimStr,T2_2027Common,
  T2_2027Common2,T2_2027ChildWinNew,T2_2027Calc,vtTrimStr,vtShared;

procedure TTaxbyteT2_2027.FormCreate(Sender: TObject);
var
 i:Integer;
begin
 ToDirBox.Text:=OptRec.Dir_Cur;
 OpenTaxByteDB('');
 If taxbyteDb.Connected then
  begin
   {ShowMessage('Data Base opened successfully');}
   Screen.Cursor := crHourGlass;
   ShowClients;
   Screen.Cursor := crDefault;
  end
  else
   ShowMessage('Cannot open the TaxByte Data Base');
end;

procedure TTaxbyteT2_2027.OpenClientsQ;
Var WhereClause:String;
begin
 ClientsQ.Connection:=TaxByteDb; //20150923 Igor
 ClientsQ.Close;
 ClientsQ.SQL.Clear;
 WhereClause:='';
 Try
  With ClientsQ do
  begin
  SQL.Add('Select * from '+ClientsTableLite); //20150923 Igor
  SQL.Add( WhereClause);
  SQL.Add( 'ORDER BY CorpName');
  Prepare;
  open;
  end;
 except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end; {end try}
end;

procedure TTaxbyteT2_2027.CancelBtnClick(Sender: TObject);
begin
 If ClientsQ.Active then ClientsQ.Close;
 TaxByteDb.Close;
 {CloseDataBase(TaxByteDb);}
 Close;
 ShowMessage('The T2 program will now be closed'+
  Chr(13)+
  'Please run it again once conversion is completed');
 Application.terminate;
end;

procedure TTaxbyteT2_2027.ShowClients;
begin
OpenClientsQ;
Screen.Cursor := crDefault;

If ClientsQ.RecordCount = 0 then
 begin
  ShowMessage('No clients found');
 end;
end;

procedure TTaxbyteT2_2027.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
{ If Key = #13 then OpenClientsQ;}
end;



procedure TTaxbyteT2_2027.ConvertAllBtnClick(Sender: TObject);
begin
 Cnt:=0;
 ConvertAll;
 ShowMessage('Import completed.'+Chr(13)+
    'Total returns converted/added= '+IntTostr(cnt));
 {SendMessage(MDIHandle,WM_PAINT,0,0);}
end;

Function TTaxbyteT2_2027.MkFlName:String;
Var FlName,YearEnd:String;
begin
  FlName := ClientsQ.FieldByName('CorpNum').AsString;
  YearEnd:= ClientsQ.FieldByName('YearEndDat').AsString;
  result:=LeftStr(FlName,8)+'.'+MidStr(FlName,9,1)+RightStr(YearEnd,2);
end;

procedure TTaxbyteT2_2027.ConvertOneBtnClick(Sender: TObject);
Var FlName:String;
begin
  Cnt:=0;
  FlName:=MkFlName;
  {
  FlName := ClientsQ.FieldByName('CorpNum').AsString;
  YearEnd:= ClientsQ.FieldByName('YearEndDat').AsString;
  FlName:=LeftStr(FlName,8)+'.'+MidStr(FlName,9,1)+RightStr(YearEnd,2);
  }
  ConvertOne(FlName);
  ShowMessage('Import completed.'+Chr(13)+
    'Total returns converted/added= '+IntTostr(cnt));
  {SendMessage(MDIHandle,WM_PAINT,0,0);}
end;

procedure TTaxbyteT2_2027.ConvertOne(FlName:String);
Var
  i,j,FNo: integer; Msg:string;
  PrPStatus,EfStatus, Notes,LastYrDir:String;
  MyRet: TRetT2_2027;
begin
 If RetInMem>0 then
 begin
  ShowMessage('Please close all returns first');
  exit;
 end;

  {FlName:=LeftStr(sin,8)+'.'+RightStr(sin,1);}
  If FlName = '' then exit;
    RetNo:=CreateNewReturn;
    if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;
  Try
      Ret[RetNo].SourceDataDir := ToDirBox.Text; {fooli t}
      MapData(FlName);

      CalcFed(RetNo);
      FNo :=GetFormNo('STATUS');
      For j:=8 to 10 do StoreElm(RetNo,FNo,j,'');
      For j:=18 to 30 do StoreElm(RetNo,FNo,j,'');
      For j:=16 to 16 do StoreElm(RetNo,FNo,j,'');
      For j:=14 to 14 do StoreElm(RetNo,FNo,j,'');
      For j:=31 to 31 do StoreElm(RetNo,FNo,j,'');

      For j:=11 to 11 do StoreElm(RetNo,FNo,j,User.UserName); //20170112 Igor
      For j:=12 to 12 do StoreElm(RetNo,FNo,j,FormatDateTime('yyyy/mm/dd',Date));
      {DateToStr(Date));}
      For j:=13 to 13 do StoreElm(RetNo,FNo,j,TimeToStr(Time));


      If FileExists(ToDirBox.Text+'\'+FlName) then
      begin
       if ReplaceOptionBox.ItemIndex=0 then SaveIt(FlName);
      end
      else
       SaveIt(FlName);
  except
  end;
  If RetNo >0 then RemoveReturnFromMemory(RetNo);
  RetNo :=0; //RetINmem :=0;
  //SendMessage(MDIHandle,WM_PAINT,0,0);
end;


procedure TTaxbyteT2_2027.ConvertAll;
Var i,j,FNo: integer; FlName : string;Msg:string;
PrPStatus,EfStatus,Notes,LastYrDir:String;
begin
 if MessageDlg('Import all. Are you sure?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;
 Cnt :=0;
 If RetInMem>0 then
 begin
  ShowMessage('Please close all returns first');
  exit;
 end;

 ClientsQ.First;
 Repeat
  FlName := MkFlName;
  ConvertOne(FlName);
  RetNo :=0; //RetINmem :=0;
  ClientsQ.Next;
 until ClientsQ.Eof;
end;

procedure TTaxbyteT2_2027.SaveIt(FlName:String);
begin
 If not SaveReturn(RetNo,ToDirBox.Text,FlName,True,True) =0 then
   ShowMessage('Return cannot be saved')
 else
  Inc(Cnt);
end;

procedure TTaxbyteT2_2027.MapData(FlName:String);
Var FNo:Integer;CorpType,Jurisdict:string; PrvNdx:integer;
begin
 Try
  With ClientsQ do
  begin
   FNo:=GetFormNo('T2');
   StoreElm(RetNo,FNo,3,FieldByName('CorpName').AsString);
   StoreElm(RetNo,FNo,1,FieldByName('CorpNum').AsString);
   StoreElm(RetNo,FNo,10,FormatDateTime('yyyy/mm/dd',FieldByName('YearStDat').AsDateTime));
   StoreElm(RetNo,FNo,11,FormatDateTime('yyyy/mm/dd',FieldByName('YearEndDat').AsDateTime));

   Jurisdict:=FieldByName('Jurisdict').AsString;
   StoreElm(RetNo,FNo,2,PrvLong[GetPrvNdx(Jurisdict)]);

   StoreElm(RetNo,FNo,12,FieldByName('Address').AsString);
   StoreElm(RetNo,FNo,13,FieldByName('Address2').AsString);
   StoreElm(RetNo,FNo,16,FieldByName('City').AsString);
   StoreElm(RetNo,FNo,17,FieldByName('Prov').AsString);
   StoreElm(RetNo,FNo,20,FieldByName('PCode').AsString);
   If UpperCase(FieldByName('Country').AsString) <> 'CA' then
    StoreElm(RetNo,FNo,19,FieldByName('Country').AsString);

   StoreElm(RetNo,FNo,26,FieldByName('MailAdd').AsString);
   StoreElm(RetNo,FNo,27,FieldByName('MailAdd2').AsString);
   StoreElm(RetNo,FNo,32,FieldByName('MailCity').AsString);
   StoreElm(RetNo,FNo,33,FieldByName('MailProv').AsString);
   StoreElm(RetNo,FNo,35,FieldByName('MailPCode').AsString);
   If UpperCase(FieldByName('MailCntry').AsString) <> 'CA' then
    StoreElm(RetNo,FNo,34,FieldByName('MailCntry').AsString);

   StoreElm(RetNo,FNo,15,FieldByName('Contact').AsString);
   StoreElm(RetNo,FNo,15,FieldByName('Phone').AsString);

   CorpType:=FieldByName('CorpType').AsString;
   If CorpType = 'Canadian-controlled Private Corporation' then
          StoreElm(RetNo,FNo,51,'X')
   else If CorpType = 'Other Private Corporation' then StoreElm(RetNo,FNo,56,'X')
   else If CorpType = 'Public' then StoreElm(RetNo,FNo,59,'X')
   else If CorpType = 'Other' then StoreElm(RetNo,FNo,57,'X');

   {StoreElm(RetNo,FNo,15,FieldByName('SignOffcr').AsString);}

   If AllTrim(FieldByName('AbAcctNum').AsString) >'' then
   begin
    FNo:=GetFormNo('AT1');
    if Ret[RetNo].Frm[Fno].Count = 0 then InitFormData(RetNo,FNo);
    StoreElm(RetNo,FNo,1,FieldByName('AbAcctNum').AsString);
    Ret[RetNo].FrmHasData[FNo] := True;
   End;
  end;
 except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;


procedure TTaxbyteT2_2027.ShowFilesBtnClick(Sender: TObject);
begin
  If taxbyteDb.Connected then
  begin
   Screen.Cursor := crHourGlass;
   ShowClients;
   Screen.Cursor := crDefault;
  end
  else
   ShowMessage('Cannot open the Data Base');

end;

procedure TTaxbyteT2_2027.DBGrid1DblClick(Sender: TObject);
begin
 ConvertOneBtnClick(Sender);
end;

procedure TTaxbyteT2_2027.HelpBtnClick(Sender: TObject);
begin
  ShowHelp(AppT2.ModuleHelpUpdFile, 'Converting_from_Taxbyte_T2', True); //20160801 Igor
end;

end.
