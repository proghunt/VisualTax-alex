unit vtPanel;

interface

uses
  WinAPI.Windows, WinAPI.Messages, System.SysUtils, System.Classes,
  VCL.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls;

type
  TvtPanel = class(TPanel)
  private
    FTableNumber: Integer;
    FRowNumber: Integer;
    procedure SetTableNumber(const Value: Integer);
    procedure SetRowNumber(const Value: Integer);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    property vtTableNumber: Integer read FtableNumber write SetTableNumber;
    property vtRowNumber: Integer read FRowNumber write SetRowNumber;
    { Published declarations }
  end;

procedure Register;

implementation

uses
  Vcl.StdCtrls, System.StrUtils;
procedure Register;
begin
  RegisterComponents('VisualTax', [TvtPanel]);
end;

procedure TvtPanel.SetTableNumber(const Value: Integer);
begin
  if FTableNumber <> Value then
  begin
    FTableNumber := Value;
    RecreateWnd;
  end;
end;

procedure TvtPanel.SetRowNumber(const Value: Integer);
begin
  if FRowNumber <> Value then
  begin
    FRowNumber := Value;
    RecreateWnd;
  end;
end;

end.
