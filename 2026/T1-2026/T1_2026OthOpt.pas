unit T1_2026OthOpt;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls;

type
  TOthOptT1_2026 = class(TForm)
    Memo1: TMemo;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OthOptT1_2026: TOthOptT1_2026;

implementation

{$R *.DFM}

uses vtMulti,vtMain,T1_2026TrimStr,T1_2026Declare,T1_2026ChildWinNew,
  T1_2026Main,vtTrimStr,vtShared;

procedure TOthOptT1_2026.CancelBtnClick(Sender: TObject);
 begin
Close;
end;

procedure TOthOptT1_2026.FormCreate(Sender: TObject);
Var i:Integer; TempList:TStringList;IsRollover:Boolean;
begin
 IsRollover:=False;
 TempList:=TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'OthOpt.D');
 For i:=0 to TempList.Count-1 do
 begin
   If LeftStr(TempList[i],4) ='Roll' then begin IsRollOver:=True;break;End;
 end;

 If IsRolloVer=False then
 begin
  TempList.Add(PaddR('Rollover names of T4/T5',29)+'Y'+ '   (Option in Roll-over from last year)');
  TempList.SaveToFile(AppDir+'\'+'OthOpt.D');
 end;
 TempList.Free;

 Memo1.Lines.LoadFromFile(AppDir+'\'+'OthOpt.D');
end;

procedure TOthOptT1_2026.SaveBtnClick(Sender: TObject);
begin
 With Memo1 do
 begin
   Lines.SaveToFile(AppDir+'\'+'OthOpt.D');
   If UpperCase(MidStr(Lines[0],30,1)) = 'Y' then
    begin
    {$IFDEF main}
     MainForm.VerticalSplitter1.Align := alNone;
     MainForm.VerticalSplitter1.Left := 100;
     MainForm.VerticalSplitter1.Align := alLeft;
    {$ELSE}
    {$ENDIF}
    //20160220 Igor >>>
//    MainForm.LeftPanel.Visible := RetInMem>0;
//    MainForm.LeftPanel.Width := Screen.width div 7;
    if RetInMem>0 then
       MainForm.GuiCommand(gcShowLeftPanel)
     else
       MainForm.GuiCommand(gcHideLeftPanel);
     //20160220 Igor <<<
     ShowTreeView :=True;
    end
   else
    ShowTreeView :=False;

   If UpperCase(MidStr(Lines[1],30,1)) = 'Y' then
    ShowFinancialWarning :=True
   else
    ShowFinancialWarning :=False;

   If UpperCase(MidStr(Lines[2],30,1)) = 'Y' then
    ShowConsultantOnInvoice :=True
   else
    ShowConsultantOnInvoice :=False;

    (*
   If UpperCase(MidStr(Lines[8],30,1)) = 'Y' then
    ShowOpenedForms :=True
   else
    ShowOpenedForms :=False;
   *)
 end;
 //MainForm.AdjustFontSize; - NOP!
 //MainForm.UpdateMenuItems(GetCurrentRetNo);
 Close;
end;

procedure TOthOptT1_2026.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then Key:=Chr(0);
end;

end.
