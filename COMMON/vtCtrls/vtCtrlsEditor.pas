unit vtCtrlsEditor;

interface

uses
  DesignIntf, DesignEditors;


  type
  TRichTextProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue:string; override;
    procedure Edit; override;
  end;


implementation

uses System.Classes, Vcl.Forms, vtBox, vtLabel, System.UITypes;

{ TRichTextProperty }

function TRichTextProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog,paReadOnly];
end;

function TRichTextProperty.GetValue: string;
begin
  Result := '(TRichText)';
end;

procedure TRichTextProperty.Edit;
var
  vtBox: TvtBox;
  ms: TStringStream;
  s: string;

begin
  vtBox := TvtBox.Create(application);
  try
    s := String((GetComponent(0) as TvtLabel).RichText);

    ms := TStringStream.Create('');
    try
      ms.WriteString(s);
      ms.position := 0;
      vtBox.RTFControl.lines.LoadFromStream(ms);
    finally
      ms.free;
    end;

    if vtBox.Showmodal = mrOk then
    begin
       ms := TStringStream.Create('');
       try
         vtBox.RTFControl.Lines.SaveToStream(ms);
         s := ms.DataString;
       finally
         ms.Free;
       end;

      (GetComponent(0) as TvtLabel).RichText := AnsiString(s);
      (GetComponent(0) as TvtLabel).Repaint;
      Modified;
    end;
  finally
    vtBox.Free;
  end;
end;

initialization
  RegisterPropertyEditor(TypeInfo(vtLabel.TRichText), TvtLabel, 'RichText', TRichTextProperty);

end.
