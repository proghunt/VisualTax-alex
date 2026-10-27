unit T3_2026prt5013;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,CheckLst;

type
  TPrT5013T3_2026 = class(TForm)
    Label2: TLabel;
    NumOfT5013Slips: TEdit;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    ListBox1: TListBox;
    Label1: TLabel;
    SlipSelected: TRadioGroup;
    Label5: TLabel;
    CopySelected: TRadioGroup;
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

var
  PrT5013: TPrT5013T3_2026;

implementation

{$R *.DFM}
uses
  vtMulti, vtCommon,
  T3_2026, T3_2026Main,T3_2026ChildWinNew,T3_2026Declare,T3_2026TrimStr,
  vtTrimStr, vtShared,
  Printers; //20160905 igor

procedure TPrT5013T3_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TPrT5013T3_2026.OkBtnClick(Sender: TObject);
Var {SlipToPrint:String[5];}CopyId:String;j,NumberOfSlips:Integer;
  RetNo:Integer;
  SlipInstanceToPrint:String;
begin
  NumberOfSlips :=MyStrToInt(NumOfT5013Slips.Text);
  
  RetNo:=GetCurrentRetNo;
  If NumberOfSlips =0 then
   begin
    ShowMessage('There are no T5013 slips for printing');
    exit;
   end;

 If SlipSelected.ItemIndex=0 then
  SlipInstanceToPrint:=RightStr(ListBox1.Items[ListBox1.ItemIndex],3)
 else
 If SlipSelected.ItemIndex=1 then SlipInstanceToPrint:='ALL';

 CopyId:=IntToStr(CopySelected.ItemIndex+1);
 If CopyId='5' then CopyId:='ALL';
 Screen.Cursor := crHourGlass;
 If UpperCase(SlipInstanceToPrint) = 'ALL'  then
 begin
   If PrintDialog1.Execute then
   For j:=0 to ListBox1.Items.count-1 do
    MainFormT3.PrintT5013Slip(RetNo,RightStr(ListBox1.Items[j],3),CopyId);
 end
 else  {single slip}
  If PrintDialog1.Execute then
      MainFormT3.PrintT5013Slip(RetNo,RightStr(ListBox1.Items[ListBox1.ItemIndex],3),CopyId);
 if Printer.Printing then //20160905 Igor
   Printer.EndDoc;        //20160905 Igor
 Screen.Cursor := crDefault;
end;

procedure TPrT5013T3_2026.FormCreate(Sender: TObject);
Var i,j:Integer;
begin
  FRetNo := GetCurrentRetNo; 
 NumOfT5013Slips.Text :=FetchElm(RetNo,'T5013FIN',45);

 ListBox1.Clear;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName = 'T5013') then
   begin
    If (FetchElmFNo(RetNo,Frec.FormNo,15)>'')   //20120321     //there is name
    then
     ListBox1.Items.Add(PaddR(FetchElmFNo(RetNo,Frec.FormNo,15),40)+Frec.FormInst);
   end;
 end;
 If ListBox1.Items.count>0 then
 begin
  ListBox1.ItemIndex:=0;
  SlipSelected.ItemIndex:=0;
  CopySelected.ItemIndex:=0;
 end;
end;

end.
