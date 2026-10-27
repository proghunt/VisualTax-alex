unit FP_2027CopyFrm;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons;

type
  TCopyFrmFP_2012 = class(TForm)
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
    Label3: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure FrmlistClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    FromRetNo,ToRetNo : integer;
    FromFormName :string;
  end;

var
  CopyFrm: TCopyFrmFP_2012;

implementation

{$R *.DFM}

uses vtCommon,vtMulti,FP_2027,FP_2027Common,FP_2027Common2,FP_2027TrimStr,
  FP_2027Declare,FP_2027calc,FP_2027ChildWinNew,vtTrimStr,vtShared;

var
  RetNo: boolean; //force errors

procedure TCopyFrmFP_2012.BitBtn2Click(Sender: TObject);
begin
Close;
end;

procedure TCopyFrmFP_2012.FormCreate(Sender: TObject);
Var I: integer; 
begin
   If RetInMem=1 then MoveBtn.Enabled :=false;
   for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if FRec.FormNo <= 0 then  Continue; //20170130 Igor
      If RetInMem=1 then
       begin
       if Frec.FormInst>'' then
         FrmList.Items.Add(FRec.FormInstName);
       end
      else
       FrmList.Items.Add(FRec.FormInstName);
    end;
   for i :=0 to (RetList.Count - 1) do
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
   FrmList.ItemIndex  :=0;
   //FromFormName := FormName; {at time of entering copy}
   For i:=0 to FrmList.Items.Count-1 do
      If FromFormName = FrmList.Items[i] then
       begin FrmList.ItemIndex :=i;break;end;
   ListBox1.ItemIndex := 0;
   ListBox3.ItemIndex := 0;
   FrmlistClick(Sender); {in case not found}
end;

procedure TCopyFrmFP_2012.CopyBtnClick(Sender: TObject);
Var ToFormName:String;
begin
 If FromFormName ='' then exit;
 ToFormName:=FromFormName;
 FromRetNo :=StrToInt(ListBox2.Items[ListBox1.ItemIndex]);
 ToRetNo :=StrToInt(ListBox4.Items[ListBox3.ItemIndex]);
 If Ret[FromRetNo].FormHasData[FromFormName] then
 begin
   CloneForm(FromRetNo,FromFormName, ToRetNo,ToFormName); {fromR,FromF,ToR}
   CalcAll(ToRetNo);
   ShowMessage('Form has been copied and file recalculated.'+
     Chr(13)+'Press any key...');
   //RetNo := ToRetNo;
   OpenForm(ToRetNo,GetFormNo(ToFormName),0);
 end
 Else
   ShowMessage('Form: '+FromFormName+' is empty'+Chr(13)+'Data not copied');
end;

procedure TCopyFrmFP_2012.MoveBtnClick(Sender: TObject);
Var ToFormName:String;
begin
 FromRetNo :=StrToInt(ListBox2.Items[ListBox1.ItemIndex]);
 ToRetNo :=StrToInt(ListBox4.Items[ListBox3.ItemIndex]);
 ToFormName:=FromFormName;
 If Ret[FromRetNo].FRmHasData[GetFormNo(FromFormName)] then
 begin
  MoveForm(FromRetNo,FromFormName,ToRetNo,ToFormName);
  ShowMessage('Form data moved and files recalculated.'+
   Chr(13)+'Press any key...');
  //RetNo := ToRetNo;
  OpenForm(ToRetNo,GetFormNo(ToFormName),0);
 end
 Else
  ShowMessage('Form: '+FromFormName+' is empty'+Chr(13)+'Data not moved');
end;

procedure TCopyFrmFP_2012.FrmlistClick(Sender: TObject);
Var I :integer;
begin
  for i :=0 to (FList.Count - 1) do
  begin
     FRec := FList.Items[i];
     If FrmList.Items[FrmList.ItemIndex] = FRec.FormInstName
      then
      begin
      FromFormName :=FRec.FormInstName;
      {CurFormBox.Caption :=FromFormName;}
      ListBoxLbl.Caption := FRec.FormDescr;
      end;
   end;
end;

procedure TCopyFrmFP_2012.FormPaint(Sender: TObject);
begin
If ListBox1.ItemIndex > -1 then
  begin CopyBtn.Enabled := True;MoveBtn.Enabled := True;end
  else begin CopyBtn.Enabled := False;MoveBtn.Enabled := False;end;
end;


end.
