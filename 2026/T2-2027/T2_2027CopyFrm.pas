unit T2_2027CopyFrm;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons,vtMulti;

type
  TCopyFrmT2_2027 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    CopyBtn: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    ListBox1: TListBox;
    Label2: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    ListBox3: TListBox;
    Frmlist: TListBox;
    ListBoxLbl: TLabel;
    CurFormBox: TLabel;
    Label3: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Splitter1: TSplitter;
    procedure BitBtn2Click(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure FrmlistClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    //RetNo: integer;
  public
    FromRet, ToRet: TRetData;
    FromRetNo,ToRetNo : integer;
    FromFormName, ToFormName :string;
  end;

//var  CopyFrmT2_2013: TCopyFrmT2_2013;

procedure CopyFrm(RNo: integer; FName: string);

implementation

{$R *.DFM}

uses vtCommon,T2_2027,T2_2027Common,T2_2027Common2,T2_2027TrimStr,
  T2_2027Declare,T2_2027calc,T2_2027ChildWinNew,vtTrimStr,vtShared;

procedure CopyFrm(RNo: integer; FName: string);
begin
  with TCopyFrmT2_2027.Create(Application) do
  begin
    FromRetNo := RNo;
    FromFormName := FName;
    ShowModal;
    Free;
  end;
end;

procedure TCopyFrmT2_2027.BitBtn2Click(Sender: TObject);
begin
  Close;
end;


procedure TCopyFrmT2_2027.FormShow(Sender: TObject);
//procedure TCopyFrmT2_2013.FormCreate(Sender: TObject);
Var
  I: integer;
  FNm: String;
begin
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormNo < 1 then
      continue;
    FrmList.Items.Add(FRec.FormInstName);
  end;
  for i := 1 to (RetList.Count - 1) do
  begin
    RetRec := RetList[i];
    //20170130 Igor >>>
    if not Assigned(RetRec) or
       RetRec.Destroying or
       (RetRec.MyApp <> CurrentApp) then
      Continue;
    //20170130 Igor <<<
    ListBox1.Items.AddObject(
         GetRetName(RetRec.RetNo)+' - '+
         'YE: '+GetTaxationYearEnd(RetRec.RetNo), RetRec);
    //ListBox2.Items.add(IntToStr(RetRec.RetNo));
    ListBox3.Items.AddObject(GetRetName(RetRec.RetNo)+' - '+
       'YE: '+GetTaxationYearEnd(RetRec.RetNo), RetRec);
    //20170720 Igor>>>
    if RetRec.RetNo = FromRetNo then
      ListBox1.ItemIndex := ListBox1.Items.Count - 1;
    //20170720 Igor<<<

    //ListBox4.Items.add(IntToStr(RetRec.RetNo));
  end;

{ TODO 1 -oCon : compare with T1! }
   {Position in current Formname}
   //Fnm := GetFormName(FormNo); {at time of entering copy}
  FrmList.ItemIndex  := FrmList.Items.IndexOf(FromFormName);
//20170720 Igor>>>
//  ListBox1.ItemIndex := 0;
  if ListBox1.ItemIndex < ListBox1.Items.Count - 1 then
    ListBox3.ItemIndex := ListBox1.ItemIndex + 1
  else
    ListBox3.ItemIndex := ListBox1.ItemIndex - 1;
//20170720 Igor<<<
  FrmlistClick(Sender);
end;

procedure TCopyFrmT2_2027.CopyBtnClick(Sender: TObject);
Var
  FrmNm: string;
begin
  If ListBox1.ItemIndex < 0 then
    exit;
  FrmNm := AllTrim(CurFormBox.Caption);
  if MessageDlg('Copy '+ FrmNm+' ('+ListBoxLbl.Caption+')?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
  TObject(FromRet) := ListBox1.Items.Objects[ListBox1.ItemIndex];
  FromRetNo := FromRet.RetNo;
  TObject(ToRet) := ListBox3.Items.Objects[ListBox3.ItemIndex];
  ToRetNo := ToRet.RetNo;
  CloneForm(FromRetNo, FrmNm, ToRetNo, FrmNm, True);//20170720 Igor
  ShowMessage('Form has been copied and return recalculated.'+
    Chr(13) + 'Press any key...');
  Calc(ToRetNo, FrmNm);
  CalcFed(ToRetNo);
  CalcOnt(ToRetNo);
  CalcAlb(ToRetNo);
  Ret[ToRetNo].Changed := True;
  OpenForm(ToRetNo, FrmNm, 0);
  Screen.Cursor := crDefault;
end;

procedure TCopyFrmT2_2027.FrmlistClick(Sender: TObject);
Var I :integer;
begin
  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FrmList.Items[FrmList.ItemIndex] = FRec.FormInstName then
    begin
      CurFormBox.Caption := FRec.FormInstName;
      ListBoxLbl.Caption := FRec.FormAbrev;
      exit;
    end;
  end;
end;

procedure TCopyFrmT2_2027.FormPaint(Sender: TObject);
begin
  CopyBtn.Enabled := (ListBox1.ItemIndex > -1) AND
    (ListBox1.ItemIndex <> ListBox3.ItemIndex);
end;

end.
