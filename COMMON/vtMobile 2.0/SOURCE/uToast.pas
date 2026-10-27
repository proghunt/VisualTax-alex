unit uToast;

interface

{$IFDEF  ANDROID}
type
  TToastLength = (LongToast, ShortToast);
procedure Toast(const Msg: string; duration: TToastLength);
{$ENDIF}

implementation
{$IFDEF  ANDROID}
uses
  FMX.Platform.Android, Androidapi.JNI.Widget, Androidapi.Helpers,
  FMX.Helpers.Android, AndroidAPI.JNI.JavaTypes;

procedure Toast(const Msg: string; duration: TToastLength);
var
  ToastLength: Integer;
begin
  if duration = ShortToast then
    ToastLength := TJToast.JavaClass.LENGTH_SHORT
  else
    ToastLength := TJToast.JavaClass.LENGTH_LONG;

  CallInUiThread (
    procedure
    begin
      TJToast.JavaClass.makeText (TAndroidHelper.Context,
          StrToJCharSequence(Msg), ToastLength).show
    end
  );
end;
{$ENDIF}

end.
