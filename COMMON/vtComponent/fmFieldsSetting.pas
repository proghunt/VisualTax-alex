{***************************************************************************}
{                                                                           }
{ Unit containst TFieldsSettingForm for TvtColumnVisible component          }
{                                                                           }
{    TFieldsSettingForm - form where user can Show or Hide columns          }
{                                                                           }
{***************************************************************************}
unit fmFieldsSetting;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.StdCtrls, FMX.Layouts, FMX.ListBox, FMX.Grid;

type
  TFieldsSettingForm = class(TForm)
    FieldsListBox: TListBox;
    // Change Column visible on User Click
    procedure FieldsListBoxChangeCheck(Sender: TObject);
  private
    FGrid: TGrid;
  public
    // Show Column settings with curent define
    procedure ShowFieldsSetting(Grid: TGrid);
  end;

implementation

{$R *.fmx}

{ TFieldsSettingForm }

procedure TFieldsSettingForm.FieldsListBoxChangeCheck(Sender: TObject);
begin
  // Change Colum Visible
  FGrid.Columns[FieldsListBox.ItemIndex].Visible := FieldsListBox.ListItems[FieldsListBox.ItemIndex].IsChecked;
end;

procedure TFieldsSettingForm.ShowFieldsSetting(Grid: TGrid);
var i: integer;
begin
  FGrid := Grid;
  // Fill ListBox with Columns values
  for I := 0 to Grid.ColumnCount - 1 do begin
      FieldsListBox.Items.Add(Grid.Columns[i].Header);
      FieldsListBox.ItemByIndex(i).IsChecked := Grid.Columns[i].Visible;
  end;
  ShowModal;
end;

end.
