unit TR_2026Declare;

interface

uses
  Classes, SysUtils, TR_2026;

const
  AppRelease = '1.0';
  AppUpdateDate = '2026/08/26'; //'2023/01/11'; //20230107 //'2019/12/27';
  AppYear = '2026';

  (*
    changing "AppYear" changes the download variables:
    HomePage      = 'http://www.visualtax.com/TR/TRGuide/TRGuide-' + AppYear + '.htm';
    remoteflname := 'TRDLDIR'+AppYear+'.ZIP';
    localflname  := 'TRDLDIR'+AppYear+'.ZIP';

    must update the corresponding files on the server to the updated year
  *)

  AppName = 'TR';
  AppTitle = 'Visual Tax - '+ AppName;   {for win caption}
  AuthorizationPosition = 9;
  MyBlue  = $00AC7400;
  MyLightBlue = $00FFFFE1;
  MyBeige =$00C8D0D8;
  MyBronze = $A6CAF0;
  LightGreen=$00D2FFFF; //$00A7FCE2; //$00C0FEEF; //$00DFFFBF;
  MyYellow =$00C5EEFE;
  ActivationFile = 'LVerf.EX_';
  ITAFlName = 'ITA.htm';
  ITAMenuFlName = 'ITAMenu.txt';
  HomePage = 'https://www.visualtax.com/TR/TRGuide/TRGuide-' + AppYear + '.htm';

 {============================== VARIABLES ======================}
 var
//  DelayMsg: String;
  AppDir : String;
//  Licensee : String;
  License: RPgmLicenseData;
//
//  {Somelist : create and free in any unit}
  SomeList: TstringList;
  SomeCaption: string;
  SelectedString: string;
//  SomeFilter: string;
//  SomeFileMask: string;
//  SomeDir: string;
//  SomeFile: string;
//  SomeLabel: string;

implementation

initialization
  SomeList := TStringList.Create;

finalization
  FreeAndNil(SomeList);

end.
