unit OpenPDF;
interface
 uses
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  FMX.Helpers.Android,
  Androidapi.Helpers,
  Androidapi.JNI.App, Androidapi.JNI.Net, System.SysUtils;

  procedure OpenFile(FileName, Extension: String);
implementation
  procedure OpenFile(FileName, Extension: String);
var
  Intent: JIntent;
 begin
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setDataAndType(StrToJURI('file:///' + FileName),  StringToJString('application/' + Extension));
  TAndroidHelper.Activity.startActivity(Intent);
 end;
 end.
