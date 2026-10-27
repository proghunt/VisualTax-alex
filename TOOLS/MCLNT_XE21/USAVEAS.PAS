unit Usaveas;

interface

uses
  SysUtils, FileCtrl,WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,
  UDeclare,TrimStr;

type
  TSaveAs = class(TForm)
    Panel1: TPanel;
    StatusGroup: TRadioGroup;
    Panel2: TPanel;
    FLNameBox: TEdit;
    Label1: TLabel;
    statuslbl: TLabel;
    DataDirBox: TEdit;
    noteslbl: TLabel;
    ClearBtn: TBitBtn;
    RetNameLbl: TLabel;
    Label2: TLabel;
    Notes: TEdit;
    Panel3: TPanel;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label3: TLabel;
    FlDescrBox: TEdit;
    BitBtn1: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SaveCloseBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Const HelpTopic = 'Save_a_return';
var
  SaveAs: TSaveAs;

implementation

{$R *.DFM}

procedure TSaveAs.CancelBtnClick(Sender: TObject);
begin
release;
end;

procedure TSaveAs.FormCreate(Sender: TObject);
var
i : integer;
begin
RetNameLbl.Caption := GetReturnName(RetNo);
RetNameLbl.Color := GetRetColor(RetNo);
If GetFormsType(RetNo) = 'T3' then
begin
 FlNameBox.Text := LeftStr(GetAccountNumber(RetNo),8)+'.'+
                  MidStr(GetYearEnd(RetNo),3,2);
 If Length(GetAccountNumber(RetNo)) =0 then
  FlNameBox.Text :=RemoveSpaces(LeftStr(GetReturnName(RetNo),8))+'.'+
                  MidStr(GetYearEnd(RetNo),3,2);
 end
 else
  FlNameBox.Text:='xxxxxxxx';

FlNameBox.Text := Ret[RetNo]^.SourceFlName;
FlDescrBox.Text := GetReturnName(RetNo);

If Ret[RetNo]^.SourceDataDir = '' then
 DataDirBox.Text := CfgRec.Dir_Cur
else
 DataDirBox.Text := Ret[RetNo]^.SourceDataDir;
Notes.Text := Ret[RetNo]^.Notes;

For i :=0 to High(PrpStatusDescr) do
     StatusGroup.Items.Add(PrpStatusDescr[i]);
If Ret[RetNo]^.PrpStatus = '' then Ret[RetNo]^.PrpStatus := '00';
StatusGroup.ItemIndex := StrToInt(Ret[RetNo]^.PrpStatus); {when retrieved}
end;

procedure TSaveAs.ClearBtnClick(Sender: TObject);
begin
 Notes.Text := '';
end;

procedure TSaveAs.SaveBtnClick(Sender: TObject);
begin
If FlNameBox.Text = '' then
  begin
  ShowMessage('You must specify a File Name');
  FlNameBox.SetFocus;
  Exit;
  End;
If DirectoryExists(DataDirBox.Text) = False then
  begin
   ShowMessage('Directory does not exist');
   DataDirBox.SetFocus;
   Exit;
  End;
If FileExists(DataDirBox.Text+'\'+ClientsTable) = False then
  begin
   ShowMessage('Directory was not initialized for tax returns');
   DataDirBox.SetFocus;
   Exit;
  End;

If SaveReturn(RetNo,DataDirBox.Text,FlNameBox.Text,False) = 0 then
    begin
     Ret[RetNo]^.SourceDataDir := DataDirBox.Text;
     Ret[RetNo]^.SourceFlName := FlNameBox.Text;
     (*
     if MessageDlg(
      'Return Saved'+Chr(13)+' Close it?',
       mtInformation, [mbYes, mbNo], 0) = mrYes then
       CloseReturn(retNo);
     *)
     Close;
    end
  else
     begin
      ShowMessage('Return was not saved... Press any key');
      exit;
     end;
end;

procedure TSaveAs.SaveCloseBtnClick(Sender: TObject);
begin
 SaveBtnClick(Sender);
 CloseReturn(RetNo);
end;

procedure TSaveAs.BitBtn1Click(Sender: TObject);
begin
ShowHelp(HelpTopic);
end;

procedure TSaveAs.BitBtn2Click(Sender: TObject);
begin
If FileNameValid(FlNameBox.Text) = false then
  begin
  ShowMessage('You must specify a File Name'+Chr(13)
   +'of no more than 8 characters' + Chr(13)
   + 'i.e. xxxxxxxx or xxxxxxxx.xxx');
  FlNameBox.SetFocus;
  Exit;
  End;

If DirectoryExists(DataDirBox.Text) = False then
  begin
   ShowMessage('Directory does not exist');
   DataDirBox.SetFocus;
   Exit;
  End;
If FileExists(DataDirBox.Text+'\'+ClientsTable) = False then
  begin
   ShowMessage('Directory was not initialized for tax returns');
   DataDirBox.SetFocus;
   Exit;
  End;

{put changed STATUS form data}
 with Ret[RetNo]^.Frm[GetFormNo('STATUS')] do
 begin
  Strings[4]  := PrpStatusCodes[StatusGroup.ItemIndex];
  Strings[14] := Notes.Text;
  {last update}
  Strings[11] := UserName;
  Strings[12] := DateToStr(Date);
  Strings[13] := TimeToStr(Time);
 end;
 FileDescr := FlDescrBox.Text; {global var to be used in save return}
 If SaveReturn(RetNo,DataDirBox.Text,FlNameBox.Text,False) = 0 then
    begin
     Ret[RetNo]^.SourceDataDir := DataDirBox.Text;
     Ret[RetNo]^.SourceFlName := FlNameBox.Text;
     (*
     if MessageDlg(
      'Return Saved'+Chr(13)+' Close it?',
       mtInformation, [mbYes, mbNo], 0) = mrYes then
       CloseReturn(retNo);
     *)
     Close;
    end
  else
     begin
      ShowMessage('Return was not saved... Press any key');
      exit;
     end;
end;

end.
