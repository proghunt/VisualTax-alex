unit vtDragAndDrop;

interface

uses
  Vcl.Controls;

type

  IDragTarget = interface(IUnknown)
  ['{2490FE74-AFB5-41B3-9102-F2798B4C35F2}']
    procedure DragEnter;
    procedure DragLeave;
  end;

  TOperatorKind = (okDBField, okFormField, okConst);

  TDragElement = class(TDragControlObject)
  private
    FElementKind: TOperatorKind;
    FElementFullName: string;
    FOriginalSender: TObject;
    procedure SetElementFullName(const Value: string);
    procedure SetElementKind(const Value: TOperatorKind);
    function GetElementFullName: string;
    function GetElementKind: TOperatorKind;
    procedure SetOriginalSender(const Value: TObject);
  protected
  public
    property OriginalSender: TObject read FOriginalSender write SetOriginalSender;
    property ElementKind: TOperatorKind read GetElementKind write SetElementKind;
    property ElementFullName: string read GetElementFullName write SetElementFullName;
  end;
implementation

{ TDragElement }

function TDragElement.GetElementFullName: string;
begin
  Result := FElementFullName;
end;

function TDragElement.GetElementKind: TOperatorKind;
begin
  Result := FElementKind;
end;

procedure TDragElement.SetElementFullName(const Value: string);
begin
  FElementFullName := Value;
end;

procedure TDragElement.SetElementKind(const Value: TOperatorKind);
begin
  FElementKind := Value;
end;

procedure TDragElement.SetOriginalSender(const Value: TObject);
begin
  FOriginalSender := Value;
end;

end.
