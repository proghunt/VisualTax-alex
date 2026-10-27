{***************************************************************************}
{                                                                           }
{ Unit containst interface and implementation TvtColumnVisible component    }
{                                                                           }
{    TvtColumnVisible - component, which allowed to user show and hide      }
{   columns in a grid                                                       }
{                                                                           }
{***************************************************************************}
unit vtColumnVisible;

interface

uses
  Windows, SysUtils, Classes, FMX.Forms, FMX.Grid, fmFieldsSetting, FMX.Types,
  System.UITypes;

type
  ///	<summary>
  ///	TvtColumnVisible - component, which allowed to user show and hide columns in a grid  
  ///	</summary>
  TvtColumnVisible = class(TComponent)
  private
    // Grid, where user can change columns visible
    FGrid: TGrid;
    // Store the Grid.OnMouseDown event
    FOnMouseDown: TMouseEvent;
    // Show Column editor on Mouse click
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Single);
    procedure SetGrid(Value: TGrid);
    // Check the ability to change columns visible
    function Work: boolean;
    // 
    procedure ShowFieldsSettingForm;
  published
    property Grid: TGrid read FGrid write SetGrid;
  end;

// Register component on Delphi
procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('vtComponent', [TvtColumnVisible]);
end;

procedure TvtColumnVisible.ShowFieldsSettingForm;
begin
  if Work then
    with TFieldsSettingForm.Create(nil) do begin
       try
         ShowFieldsSetting(Grid);
       finally
         Free;
       end;
    end;
end;

procedure TvtColumnVisible.OnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  // if Grid has OnMouseDown event then call it
  if Assigned(FOnMouseDown) then
     FOnMouseDown(Sender, Button, Shift, X, Y);
  // Show Fieds Form on Right mouse click
  if (TMouseButton.mbRight = Button) then
     ShowFieldsSettingForm;
end;

function TvtColumnVisible.Work: boolean;
begin
  Result := false;
  // Open Settings form if Grid defined and it consists columns
  if Assigned(FGrid) then
     if FGrid.ColumnCount <> 0 then
        Result := true;
end;

procedure TvtColumnVisible.SetGrid(Value: TGrid);
begin
  FGrid := Value;
  if Assigned(FGrid) then begin
     // After FGrid destroing FGrid will be set to nill
     FGrid.FreeNotification(Self);
     // Store FGrid Mouse Event 
     FOnMouseDown := FGrid.OnMouseDown;
     // Put our Event to Grid 
     FGrid.OnMouseDown := Self.OnMouseDown;
  end;
end;

end.
