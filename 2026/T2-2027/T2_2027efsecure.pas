unit T2_2027EfSecure;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, vtShape;

type
  TEFSECURET2_2027 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    AgreeBtn: TBitBtn;
    DisagreeBtn: TBitBtn;
    Label4: TLabel;
    vtShape1: TvtShape;
    vtShape2: TvtShape;
    vtShape3: TvtShape;
    vtShape4: TvtShape;
    vtShape5: TvtShape;
    vtShape6: TvtShape;
    vtShape7: TvtShape;
    Shape1: TShape;
    Label5: TLabel;
    procedure DisagreeBtnClick(Sender: TObject);
    procedure AgreeBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EFSECURET2_2027: TEFSECURET2_2027;
  AcceptedSecurity:Boolean;
implementation

{$R *.DFM}

procedure TEFSECURET2_2027.DisagreeBtnClick(Sender: TObject);
begin
// 20160702
AcceptedSecurity:=False;
Close;
Exit;   //20140625
end;

procedure TEFSECURET2_2027.AgreeBtnClick(Sender: TObject);
begin
// 20160702
 AcceptedSecurity:=True;
 Close;
end;

end.
