unit vtScrollBox;

interface

uses
  WinAPI.Windows, WinAPI.Messages, System.SysUtils, System.Classes, Graphics, Controls, Forms, Dialogs;

type
  TvtScrollBox = class(TScrollBox)
  private
    { Private declarations }
   FCaption : String;
   FScrollBoxId : String;
   FOldCtreateOrder : Boolean;
   FPixelsPerInch : Integer;
   FTextHeight : Integer;
   procedure SetVtCaption(const Value: String);
   procedure SetScrollBoxId(const Value: String);
   procedure SetVtPixelsPerInch(const Value: Integer);
   procedure SetVtTextHeight(const Value: Integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Caption        : String  read FCaption         write SetVtCaption;
    property vtScrollBoxId    : String  read FScrollBoxId      write SetScrollBoxId;
    property OldCreateOrder : Boolean read FOldCtreateOrder write FOldCtreateOrder;
    property PixelsPerInch  : Integer read FPixelsPerInch   write SetVtPixelsPerInch;
    property TextHeight     : Integer read FTextHeight      write SetVtTextHeight;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Standard', [TvtScrollBox]);
end;

procedure TvtScrollBox.SetVtCaption(const Value: String);
begin
// exit; //20160718 Igor
  if FCaption <> Value then
  begin
    FCaption := Value;
    RecreateWnd;
  end;
end; (*SetVtCaption*)

procedure TvtScrollBox.SetScrollBoxId(const Value: String);
begin
// exit; //20160718 Igor
  if FScrollBoxId <> Value then
  begin
    FScrollBoxId := Value;
    RecreateWnd;
  end;
end; (*SetVtCaption*)

procedure TvtScrollBox.SetVtPixelsPerInch(const Value: Integer);
begin
// exit; //20160718 Igor
  if FPixelsPerInch <> Value then
  begin
    FPixelsPerInch := Value;
    RecreateWnd;
  end;
end; (*SetVtPixelsPerInch*)

procedure TvtScrollBox.SetVtTextHeight(const Value: Integer);
begin
// exit; //20160718 Igor
  if FTextHeight <> Value then
  begin
    FTextHeight := Value;
    RecreateWnd;
  end;
end; (*SetVtTextHeight*)
end.
