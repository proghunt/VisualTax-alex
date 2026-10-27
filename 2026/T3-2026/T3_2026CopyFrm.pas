unit T3_2026CopyFrm;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons;

type
  TCopyFrmT3_2026 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    CopyBtn: TBitBtn;
    BitBtn2: TBitBtn;
    MoveBtn: TBitBtn;
    Panel2: TPanel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label2: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Frmlist: TListBox;
    ListBoxLbl: TLabel;
    CurFormBox: TLabel;
    Label3: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure FrmlistClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

var
  CopyFrm: TCopyFrmT3_2026;
  FromRetNo,ToRetNo : integer;

implementation

{$R *.DFM}

uses vtMulti,vtCommon,
  T3_2026,T3_2026Common,T3_2026Common2,T3_2026TrimStr,
  T3_2026Declare,T3_2026calc,T3_2026ChildWinNew,vtTrimStr,vtShared;

procedure TCopyFrmT3_2026.BitBtn2Click(Sender: TObject);
begin
Close;
end;

procedure TCopyFrmT3_2026.FormCreate(Sender: TObject);
Var I: integer; FNm : String;
begin
  FRetNo := GetCurrentRetNo;
   for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if FRec.FormNo <= 0 then  Continue; //20170130 Igor
      FrmList.Items.Add(FRec.FormInstName);
    end;
   for i :=1 to (RetList.Count - 1) do
   begin
    RetRec := RetList.Items[i];
     //20170130 Igor >>>
     if not Assigned(RetRec) or
        RetRec.Destroying or
        (RetRec.MyApp <> CurrentApp) then
       Continue;
     //20170130 Igor <<<

    ListBox1.Items.add(GetRetName(RetRec.RetNo));
    ListBox2.Items.add(IntToStr(RetRec.RetNo));
    ListBox3.Items.add(GetRetName(RetRec.RetNo));
    ListBox4.Items.add(IntToStr(RetRec.RetNo));
   end;
   {Position in current Formname}
   //Fnm := GetFormName(FormNo); {at time of entering copy} - local var!
   FrmList.ItemIndex  :=0;
   ListBox1.ItemIndex := 0;
   ListBox3.ItemIndex := 0;
   FrmlistClick(Sender);

end;

procedure TCopyFrmT3_2026.CopyBtnClick(Sender: TObject);
var
  FormName: string;
begin
  If ListBox1.ItemIndex <0 then exit;
  FormName := CurFormBox.Caption;
  FromRetNo :=StrToInt(ListBox2.Items[ListBox1.ItemIndex]);
  ToRetNo :=StrToInt(ListBox4.Items[ListBox3.ItemIndex]);
  CloneForm(FromRetNo,FormName, ToRetNo); {fromR,FromF,ToR}
  ShowMessage('Form has been copied and return recalculated.'+
    Chr(13)+'Press any key...');
  Calc(ToRetNo,FormName); // CurFormBox.Caption);
  CalcAll(RetNo);
  FRetNo := ToRetNo;
  //OpenForm(ToRetNo,GetFormNo(CurFormBox.Caption),0);
  OpenForm(ToRetNo,FormName,0);
end;

procedure TCopyFrmT3_2026.FrmlistClick(Sender: TObject);
Var I :integer;
begin
  for i :=0 to (FList.Count - 1) do
  begin
     FRec := FList.Items[i];
     If FrmList.Items[FrmList.ItemIndex] = FRec.FormInstName
      then
      begin
      CurFormBox.Caption :=FRec.FormInstName;
      ListBoxLbl.Caption := FRec.FormAbrev;
      end;
   end;
end;

procedure TCopyFrmT3_2026.FormPaint(Sender: TObject);
begin
If ListBox1.ItemIndex > -1 then
  begin CopyBtn.Enabled := True;MoveBtn.Enabled := True;end
  else begin CopyBtn.Enabled := False;MoveBtn.Enabled := False;end;
end;

end.
