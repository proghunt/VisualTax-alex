unit FP_2027frmtree;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons;

type
  TFrmTreeFP_2012 = class(TForm)
    ListBox1: TListBox;
    CancelBtn: TBitBtn;
    Label15: TLabel;
    FormBox: TEdit;
    Label1: TLabel;
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    //procedure FormBoxExit(Sender: TObject);
    procedure FindIt(ThisForm:String);
    procedure FormBoxKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    RetNo: integer;
  end;

var
  FrmTree: TFrmTreeFP_2012;

implementation

{$R *.DFM}

uses vtCommon,vtDialogs,FP_2027,FP_2027Declare,FP_2027TrimStr,FP_2027PopList,
  FP_2027Main,FP_2027ChildWinNew,vtTrimStr,vtShared;

procedure TFrmTreeFP_2012.ListBox1Click(Sender: TObject);
Var FName:string;ndx:integer;FType :String;
begin

 {If ButtonInactive then exit;}
 Ndx := ListBox1.ItemIndex;
 Fname := AllTrim(FrmTreeForms[ndx]);
 Ftype := AllTrim(FrmTreeFType[Ndx]);
 If Ftype = 'M' then
  begin
   MainFormFP.OpenDelphiForm(RetNo,FName);
   exit;
  end;
 If FName >'' then OpenForm(RetNo,GetFormNo(FName),0);

end;

procedure TFrmTreeFP_2012.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
 DrawFormList(RetNo,ListBox1,Index,Rect,State);
end;

procedure TFrmTreeFP_2012.FormCreate(Sender: TObject);
Var i:integer;
begin
  RetNo := GetCurrentRetNo;
 Width :=ListBox1.Width +30;
 For i:=0 to FrmTreeDescr.Count-1 do
  ListBox1.Items.Add(FrmTreeDescr[i]);
 {ListBox1.Items.LoadFromFile(AppDir+'\'+'FrmTree.d');}
end;

procedure TFrmTreeFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TFrmTreeFP_2012.ListBox1DblClick(Sender: TObject);
Var FName:string;ndx:integer;FType :String;
begin
 {If ButtonInactive then exit;}
 Ndx := ListBox1.ItemIndex;
 Fname := AllTrim(FrmTreeForms[ndx]);
 Ftype := AllTrim(FrmTreeFType[Ndx]);
 If Ftype = 'M' then
  begin
   MainFormFP.OpenDelphiForm(RetNo,FName);
   exit;
  end;
 If FName >'' then OpenForm(RetNo,GetFormNo(FName),0);
end;

procedure TFrmTreeFP_2012.FindIt(ThisForm:String); //20170418 Igor
(*Var i,Elm,FNo,TheLength:Integer;FName:String;FormRecs,ResultsList:TStringList;
    List1:TStringList;
*)
begin
  if QuickFormFind(RetNo, ThisForm) then
    Close;

(*
  //load the firms
  List1:=TStringList.Create;
  List1.Clear;
  List1.Sorted := True;
  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If Frec.FormShow then
    Begin
      If (AllTrim(Frec.FormAbrev)>'')
         //and (Uppercase(AllTrim(Frec.DELPHIForm))<>'Y')
         and (Frec.DELPHIForm<>True) then
        List1.Add(PaddR(Frec.FormAbrev,80) + Frec.FormInstName);
    end;
  end; //i
  ThisForm:=UpperCase(ThisForm);

  TheLength:=Length(ThisForm);

  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If ThisForm=AllTrim(ExtractFormRootName(Frec.FormName)) then
    begin
      FNo := FRec.FormNo;
      If FNo>0 then
      begin
        OpenForm(RetNo,FNo,0);
        Close;
        List1.Free;
        exit;
      end;
    end;
  end;
  //not found as formname
  ResultsList:=TStringList.Create;
  FormRecs:=TStringList.Create;
  SomeList.Clear; //:=TStringList.Create;
  For i:=0 to List1.count -1 do
    FormRecs.Add(List1[i]);
  IsAnyWhereInList(ThisForm,FormRecs,ResultsList);
  For i:=0 to ResultsList.Count-1 do
    SomeList.Add(ResultsList[i]);
  If ResultsList.Count=0 then
  begin
    //SomeList.Free; //20160519 Igor
    ResultsList.Free;
    FormRecs.Free;
    ShowTimedMsg('Not found!',1300);
    List1.Free;
    Exit;
  end;


  List1.Free;
  SomeCaption := 'Form or KeyWord found in following';
  Application.CreateForm(TPoplistFP_2012,PopList);
  PopList.ShowModal;
  //SomeList.Free; //20160519 Igor
  PopList.Release;
  ResultsList.Free;
  FormRecs.Free;
  If SelectedString > '' then
  begin
    FName:=UpperCase(AllTrim(MidStr(SelectedString,85,20)));
    FNo := GetFormNo(FName);
    If FNo>0 then
    begin
      OpenForm(RetNo,FNo,0);
      Close;
      exit;
    end;
  end;
*)
end;

procedure TFrmTreeFP_2012.FormBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then
 begin
  If FormBox.Text>'' then FindIt(FormBox.Text);
 end;
end;

end.
