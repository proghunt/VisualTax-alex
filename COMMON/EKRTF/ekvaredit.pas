unit ekvaredit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, ToolWin, ekbasereport, ActnList, ImgList,
  Menus, System.Actions;

type
  TEkVarListForm = class(TForm)
    ToolBar1: TToolBar;
    AddBtn: TSpeedButton;
    DelBtn: TSpeedButton;
    ListView1: TListView;
    EditBtn: TSpeedButton;
    UpBtn: TSpeedButton;
    DnBtn: TSpeedButton;
    ToolButton1: TToolButton;
    ActionList1: TActionList;
    EditVar: TAction;
    AddVar: TAction;
    DelVar: TAction;
    MoveUp: TAction;
    MoveDown: TAction;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    AddMenu: TMenuItem;
    DelMenu: TMenuItem;
    EditMenu: TMenuItem;
    MoveUpMenu: TMenuItem;
    MovedownMenu: TMenuItem;
    procedure EditVarExecute(Sender: TObject);
    procedure AddVarExecute(Sender: TObject);
    procedure DelVarExecute(Sender: TObject);
    procedure MoveUpExecute(Sender: TObject);
    procedure MoveDownExecute(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
  private
     FCnt:integer;
     FMode:integer;
     FBaseReport:TEkBaseReport;
  protected
   procedure SetBaseReport(Value:TEkBaseReport);
  public
    constructor Create(AOwner:TComponent);override;
    procedure OpenForm;
    property BaseReport:TEkBaseReport read FBaseReport write SetBaseReport;
  end;

//var
//  Form1: TEkVarListForm;

implementation
uses ekvareditfm;
{$R *.DFM}



{ TEkVarListForm }

constructor TEkVarListForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FMode:=0;
  FCnt:=0;
  FBaseReport:=nil;

end;


procedure TEkVarListForm.SetBaseReport(Value: TEkBaseReport);
var f:integer;
    vname:string;
begin
 if FBaseReport<>Value then begin

  FBaseReport:=Value;
  FCnt:= FBaseReport.VarList.Count;
  Caption:=FBaseReport.Name+' variables';


  if FBaseReport.VarList<>nil then
       begin
       With ListView1 do begin
         Items.Clear;
         for f:=0 to FCnt-1 do begin
             Items.Add;
             vname:=FBaseReport.VarList.Names[f];
             Items[f].Caption:=vname;
             Items[f].SubItems.Add(FBaseReport.VarByName(vname).DataTypeText);
             Items[f].SubItems.Add(FBaseReport.VarByName(vname).AsString);
        end;//for
        ToolBar1.Enabled:=true;
        ListView1.Visible:=true;
       end;//with

    end; //if


  end;//if
end;

procedure TEkVarListForm.EditVarExecute(Sender: TObject);
begin
//edit form
    FMode:=0;
    OpenForm;
    ListView1.SetFocus;
end;//EditVar

procedure TEkVarListForm.AddVarExecute(Sender: TObject);
var f:integer;
    varname:string;
    SelItem:integer;
begin
//add var
    f:=1;
    while (f<High(integer)) and (BaseReport.GetVarNumber('var'+trim(inttostr(f)))<>0) do inc(f);
    varname:='var'+trim(inttostr(f));
    BaseReport.CreateVar(varname,'');
    With ListView1 do begin
         SelItem:=Items.IndexOf(Items.Add);
         Items[SelItem].Caption:=varname;
         Items[SelItem].SubItems.Add('String');
         Items[SelItem].SubItems.Add('');
         Selected:=Items[SelItem];
     end;//with
    FMode:=1;
    OpenForm;
    ListView1.SetFocus;
end;


procedure TEkVarListForm.OpenForm;
var edfrm:TEkVarEditForm;
    SelName:string;
    SelItem:integer;
begin

 if (ListView1.Items.Count>0) and (ListView1.Items.IndexOf(ListView1.Selected)>-1) then begin
    SelName:=ListView1.Selected.Caption;
    SelItem:=ListView1.Selected.Index;
    edfrm:=TEkVarEditForm.Create(nil);
    edfrm.Variable:=BaseReport.VarByName(SelName);
    edfrm.Mode:=FMode; //edit
  try

   edfrm.ShowModal;

    //if edfrm.ModalResult=mrOk then begin
    if edfrm.tag=1 then begin
       With ListView1 do begin
         Items[SelItem].Caption:=edfrm.Variable.Name;
         Items[SelItem].SubItems[0]:=edfrm.Variable.DataTypeText;
         Items[SelItem].SubItems[1]:=edfrm.Variable.AsString;
       end;//with
    end;//if

  finally
    edfrm.free;
  end;

 end;//if
end;


procedure TEkVarListForm.DelVarExecute(Sender: TObject);
var SelName:string;
    SelItem:integer;
begin
//DelVar
 if (ListView1.Items.Count>0) and (ListView1.Items.IndexOf(ListView1.Selected)>-1) then begin
    SelName:=ListView1.Selected.Caption;
    SelItem:=ListView1.Selected.Index;
 if MessageDlg('Delete variable '+SelName+' ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
     BaseReport.FreeVar(SelName);
     ListView1.Selected.Delete;
     if ListView1.Items.Count>=SelItem then ListView1.Selected:=ListView1.Items[SelItem];
   end;//if
 end;//if
end;

procedure TEkVarListForm.MoveUpExecute(Sender: TObject);
var SelItem,SelPrev:integer;
    s1,s2,s3:string;
begin
//MoveUp
 if (ListView1.Items.Count>1) and (ListView1.Items.IndexOf(ListView1.Selected)>0) then begin
    SelItem:=ListView1.Selected.Index;
    SelPrev:=SelItem-1;
    BaseReport.VarList.Exchange(SelPrev,SelItem);
       With ListView1 do begin
         Selected:=Items[SelPrev];
         s1:=Items[SelItem].Caption;
         s2:=Items[SelItem].SubItems[0];
         s3:=Items[SelItem].SubItems[1];

         Items[SelItem].Caption:=Items[SelPrev].Caption;
         Items[SelItem].SubItems[0]:=Items[SelPrev].SubItems[0];
         Items[SelItem].SubItems[1]:=Items[SelPrev].SubItems[1];

         Items[SelPrev].Caption:=s1;
         Items[SelPrev].SubItems[0]:=s2;
         Items[SelPrev].SubItems[1]:=s3;
       end;//with

 end;//if
end;

procedure TEkVarListForm.MoveDownExecute(Sender: TObject);
var SelItem,SelNext:integer;
    s1,s2,s3:string;
begin
//MoveDown
 if (ListView1.Items.Count>1) and (ListView1.Items.IndexOf(ListView1.Selected)>-1)
     and (ListView1.Items.IndexOf(ListView1.Selected)<ListView1.Items.Count-1) then begin
    SelItem:=ListView1.Selected.Index;
    SelNext:=SelItem+1;
    BaseReport.VarList.Exchange(SelNext,SelItem);
       With ListView1 do begin
         Selected:=Items[SelNext];
         s1:=Items[SelItem].Caption;
         s2:=Items[SelItem].SubItems[0];
         s3:=Items[SelItem].SubItems[1];

         Items[SelItem].Caption:=Items[SelNext].Caption;
         Items[SelItem].SubItems[0]:=Items[SelNext].SubItems[0];
         Items[SelItem].SubItems[1]:=Items[SelNext].SubItems[1];

         Items[SelNext].Caption:=s1;
         Items[SelNext].SubItems[0]:=s2;
         Items[SelNext].SubItems[1]:=s3;
       end;//with

 end;//if

end;



procedure TEkVarListForm.ListView1DblClick(Sender: TObject);
begin
EditVarExecute(Self);
end;

end.
