unit fSetBN;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, SysUtils;

type
  TSetBN = class(TForm)
    meBN: TMemo;
    pnlButtons: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
  public
  end;

  function DoSetBN(var AValue: string): boolean;

implementation

{$R *.DFM}

function DoSetBN(var AValue: string): boolean;
var F: TSetBN;
begin
  F := TSetBN.Create(Screen.ActiveForm);
  try
    F.meBN.Text := AValue;
    Result := F.ShowModal = mrOk;
    if Result then
      AValue := F.meBN.Text;
  finally
    F.Free;
  end;
end;

end.

