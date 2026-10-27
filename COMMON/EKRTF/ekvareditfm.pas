unit ekvareditfm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ekbasereport;

type
  TEkVarEditForm = class(TForm)
    EdName: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    DataTypeBox: TComboBox;
    StaticText3: TStaticText;
    OkBtn: TButton;
    CanceBtn: TButton;
    Notebook1: TNotebook;
    EdString: TEdit;
    EdNumber: TEdit;
    BoolGroup: TRadioGroup;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    UseTime: TCheckBox;
    procedure DataTypeBoxChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure Notebook1PageChanged(Sender: TObject);
    procedure UseTimeClick(Sender: TObject);
  private
     FVariable:TEkReportVariable;
     FMode:integer;
     FLastPage:integer;
     FmtSett: TFormatSettings;
  protected
      procedure SetVariable(Value:TEkReportVariable);
  public
    constructor Create(AOwner:TComponent);override;
    property Variable:TEkReportVariable read FVariable write SetVariable;
    property Mode:integer read FMode write FMode;
  end;

//var
//  EkVarEditForm: TEkVarEditForm;

implementation

{$R *.DFM}

constructor TEkVarEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVariable:=nil;
  DateTimePicker1.Date:=Now();
  DateTimePicker1.Time:=0;
  FLastPage:=-1;
  FmtSett:= TFormatSettings.Create;
end;//create

procedure TEkVarEditForm.DataTypeBoxChange(Sender: TObject);
var n:integer;
begin
   n:=DataTypeBox.ItemIndex;
   if n>-1 then Notebook1.PageIndex:=n;
end;//DataTypeBoxChange

procedure TEkVarEditForm.SetVariable(Value: TEkReportVariable);
var n:integer;
    d1:TDateTime;
begin
  if FVariable<>Value then begin
     FVariable:=Value;
     Caption:=FVariable.Name;
     EdName.Text:=FVariable.Name;
     n:=FVariable.DataTypeNumber;
     DataTypeBox.ItemIndex:=n;

     if n=-1 then Notebook1.PageIndex:=0;
     if n>-1 then Notebook1.PageIndex:=n;
     FLastPage:=n;

     case n of
      -1,0: begin //string
             EdString.Text:=FVariable.AsString;
            end;
         1: begin //Number
             EdNumber.Text:=FVariable.AsString;
            end;
         2:begin //Boolean
             if FVariable.AsBoolean then BoolGroup.ItemIndex:=0
                else BoolGroup.ItemIndex:=1;
           end;
         3:begin //DateTime
            d1:=FVariable.AsDateTime;
            DateTimePicker1.DateTime:=int(d1);
            DateTimePicker2.Time:=frac(d1);
              if frac(d1)>0 then begin
                   UseTime.Checked:=true;
                   DateTimePicker2.Enabled:=true;
                 end else begin
                   UseTime.Checked:=false;
                   DateTimePicker2.Enabled:=false;
                 end;
           end;//3
     end;

  end;//if
end;//SetVariable

procedure TEkVarEditForm.FormShow(Sender: TObject);
begin
  tag:=0;
  if Mode=0 then begin  //Edit mode
     case Notebook1.PageIndex of
       0:EdString.SetFocus;
       1:EdNumber.SetFocus;
       2:BoolGroup.SetFocus;
       3:DateTimePicker1.SetFocus;
     end;//case
  end;
end;

procedure TEkVarEditForm.OkBtnClick(Sender: TObject);
var n,pdc:integer;
    s:string;
begin
  if trim(EdName.Text)<>Variable.Name then
     begin
      Variable.ChangeVarName(trim(EdName.Text));
     end;
  n:=DataTypeBox.ItemIndex;

  if n>-1 then begin

    case n of
     0:Variable.AsString:=EdString.Text;
     1:begin
         s:=EdNumber.Text;
         if FmtSett.DecimalSeparator<>'.' then begin
            pdc:=pos('.',s);
            if pdc>0 then s[pdc]:= FmtSett.DecimalSeparator;
         end;
         Variable.AsFloat:=StrToFloat(s);
       end;
     2:Variable.AsBoolean:=BoolGroup.ItemIndex=0;
     3:begin
        if UseTime.Checked then begin
           Variable.AsDateTime:=int(DateTimePicker1.Date)+frac(DateTimePicker2.Time);
           end else Variable.AsDate:=DateTimePicker1.Date;
       end;//3
    end;//case
    tag:=1;
    Close;
  end else begin
             showmessage('Specify variable type, please.');
             DataTypeBox.SetFocus;
           end;

end;//OkBtnClick

procedure TEkVarEditForm.Notebook1PageChanged(Sender: TObject);
var n,m,pdc:integer;
    s:string;
begin
   n:=FLastPage; //old page
   m:=NoteBook1.PageIndex; //new page
   case n of
   0:begin
       if m=1 then begin //String to Number
          try
           s:=EdString.Text;
            if FmtSett.DecimalSeparator<>'.' then begin
               pdc:=pos('.',s);
               if pdc>0 then s[pdc]:=FmtSett.DecimalSeparator;
            end;
           EdNumber.Text:=FloatToStr(StrToFloat(s));
          except EdNumber.Text:='0'; end;
       end;
       if m=2 then begin //String to Boolean
          if (uppercase(trim(EdString.Text))='TRUE')
             then BoolGroup.ItemIndex:=0 else BoolGroup.ItemIndex:=1;
       end;
       if m=3 then begin //String to Date
          try
            DateTimePicker1.Date:=int(StrToDateTime(EdString.Text));
            DateTimePicker2.Time:=frac(StrToDateTime(EdString.Text));
            if DateTimePicker2.Time>0 then UseTime.Checked:=true else UseTime.Checked:=false;
            DateTimePicker2.Enabled:=UseTime.Checked;
          except end;
       end;
     end;//0

   1:begin
       if m=0 then begin //Number to String
          EdString.Text:=EdNumber.Text;
       end;
     end;//1

   2:begin
       if m=0 then begin //Boolean to String
          if BoolGroup.ItemIndex=0 then EdString.Text:='True'
             else EdString.Text:='False';
       end;
       if m=1 then EdNumber.Text:='0';
     end;//2

   3:begin
       if m=0 then begin //Date to String
          try
            if UseTime.Checked then begin
              EdString.Text:=DateTimeToStr(int(DateTimePicker1.Date)+frac(DateTimePicker2.Time));
            end else begin
              EdString.Text:=DateToStr(DateTimePicker1.Date);
            end;
          except end;
       end;
       if m=1 then EdNumber.Text:='0';
     end;//3
   end;//case

   FLastPage:=NoteBook1.PageIndex;
end;

procedure TEkVarEditForm.UseTimeClick(Sender: TObject);
begin
  DateTimePicker2.Enabled:=UseTime.Checked;
end;

end.
