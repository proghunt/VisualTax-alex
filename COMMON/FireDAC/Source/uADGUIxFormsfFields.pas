{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{            FireDAC GUIx Field list editor             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxFormsfFields;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, DB,
  uADGUIxFormsfOptsBase, uADGUIxFormsControls;

type
  TfrmADGUIxFormsFields = class(TfrmADGUIxFormsOptsBase)
    lbFields: TADGUIxFormsDblListBox;
  private
    function GetFields: String;
    procedure SetDSFields(ADataSet: TDataSet; AFields: String);
  public
    class function EditFields(var AFields: String; ADataSet: TDataSet;
      ACaption: String): Boolean;
  end;

var
  frmADGUIxFormsFields: TfrmADGUIxFormsFields;

implementation

uses
  uADStanUtil;

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

{-------------------------------------------------------------------------------}
function TfrmADGUIxFormsFields.GetFields: String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to lbFields.DstItems.Count - 1 do begin
    if Result <> '' then
      Result := Result + ';';
    Result := Result + lbFields.DstItems[i];
  end;
end;

{-------------------------------------------------------------------------------}
{$WARNINGS OFF}
procedure TfrmADGUIxFormsFields.SetDSFields(ADataSet: TDataSet; AFields: String);
var
  j, i: Integer;
  s: String;
begin
  lbFields.DstItems.BeginUpdate;
  lbFields.SrcItems.BeginUpdate;
  try
    lbFields.DstItems.Clear;
    lbFields.SrcItems.Clear;
    if ADataSet <> nil then begin
      ADataSet.GetFieldNames(lbFields.SrcItems);
      i := 1;
      while i <= Length(AFields) do begin
        s := ExtractFieldName(AFields, i);
        j := lbFields.SrcItems.IndexOf(s);
        if j <> -1 then begin
          lbFields.SrcItems.Delete(j);
          lbFields.DstItems.Add(s);
        end;
      end;
    end;
  finally
    lbFields.DstItems.EndUpdate;
    lbFields.SrcItems.EndUpdate;
  end;
end;
{$WARNINGS ON}

{-------------------------------------------------------------------------------}
class function TfrmADGUIxFormsFields.EditFields(var AFields: String;
  ADataSet: TDataSet; ACaption: String): Boolean;
var
  oFrm: TfrmADGUIxFormsFields;
begin
  oFrm := TfrmADGUIxFormsFields.Create(nil);
  try
    oFrm.SetDSFields(ADataSet, AFields);
    oFrm.lblPrompt.Caption := ACaption;
    Result := oFrm.ShowModal = mrOK;
    if Result then
      AFields := oFrm.GetFields;
  finally
    ADFree(oFrm);
  end;
end;

{$IFDEF AnyDAC_FPC}
initialization
  {$I uADGUIxFormsfFields.lrs}
{$ENDIF}

end.
