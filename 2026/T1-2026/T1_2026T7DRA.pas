unit T1_2026t7dra;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,DBCtrls,Mask,vtEditBox,vtShape,vtLabel,Buttons,
  Printers;

type
  TT7DRAT1_2026 = class(TForm)
    vtLabel1:TvtLabel;
    vtLabel3:TvtLabel;
    vtLabel11:TvtLabel;
    vtLabel12:TvtLabel;
    vtLabel13:TvtLabel;
    vtLabel14:TvtLabel;
    vtLabel15:TvtLabel;
    vtLabel16:TvtLabel;
    vtLabel17:TvtLabel;
    vtLabel18:TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel4: TvtLabel;
    PrintBtn: TBitBtn;
    CancelBtn: TBitBtn;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    Shape1: TShape;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    PrintDialog1: TPrintDialog;
    vtLabel10: TvtLabel;
    vtLabel19: TvtLabel;
    Vers: TRadioGroup;
    vtLabel20: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel23: TvtLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    RetNo: integer;
  public
    { Public declarations }
  end;
var
  T7DRA: TT7DRAT1_2026;

implementation

{$R *.DFM}

uses vtCommon,vtTrimStr,T1_2026,T1_2026TrimStr,T1_2026Declare,T1_2026Print,
  T1_2026ChildWinNew;

procedure TT7DRAT1_2026.CancelBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TT7DRAT1_2026.PrintBtnClick(Sender: TObject);
Var TempList:TstringList;PrintOwing:Boolean;
begin
 PrintOwing:=False;
 TempList:=TStringList.Create;
 TempList.Add(Edit1.Text);
 TempList.Add(Edit2.Text);
 TempList.Add(IntToStr(Vers.ItemIndex));
 TempList.SaveToFile(AppDir+'\'+'T7DRADJ.txt');

 If not PrintDialog1.Execute then exit;

 If Ret[RetNo].Lnn[48600]=0 then
 begin
  if MessageDlg('No Payment amount indicated on Page 4. Use amount owing?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then
     PrintOwing:=True
    else
     PrintOwing:=False;
 end;

// XAdj:=
 Printer.BeginDoc;
 PrintT7DRA(RetNo,Vl(Edit1.text),Vl(Edit2.text),IntToStr(Vers.ItemIndex),PrintOwing);
 Printer.EndDoc;
 Close;
end;

procedure TT7DRAT1_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 FormatSettings.DecimalSeparator:='.'; // 20150727
 Vers.itemIndex:=1;
 If AllTrim(Edit1.text)='' then Edit1.text:='0.0';
 If AllTrim(Edit2.text)='' then Edit2.text:='0.0';

 RetNo := GetCurrentRetNo;
 edit3.text := GetFirstName(RetNo);
 edit4.text := GetLastName(RetNo);
 edit5.text := FetchElm(RetNo,'INFO',6)+' '+FetchElm(RetNo,'INFO',22);
 edit6.text := FetchElm(RetNo,'INFO',68);
 edit7.text := FetchElm(RetNo,'INFO',10);
 edit8.text := alltrim(FetchElm(RetNo,'INFO',14));
 edit9.text := alltrim(FetchElm(RetNo,'INFO',15));
 edit10.text := GetSinNo(RetNo);
 edit11.text := justright(FormatFloat('#,###,###.00',Ret[RetNo].Lnn[48600]),13);

 TempList:=TStringList.Create;
 If FileExists(AppDir+'\'+'T7DRADJ.txt') then
 begin
  TempList.LoadFromFile(AppDir+'\'+'T7DRADJ.txt');
  Edit1.Text:=TempList[0];
  Edit2.Text:=TempList[1];
  If TempList.Count>2 then Vers.ItemIndex:=MyStrToInt(TempList[2]);
 end;
 TempList.Free;
end;

end.
