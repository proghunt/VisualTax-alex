program ForDFM;

uses
  Vcl.Forms,
  mainUnit in 'mainUnit.pas' {Form2},
  UCanFlagFrame in '..\vtBase\Flags\UCanFlagFrame.pas' {canFlagFrame: TFrame},
  uFlagFrameAB in '..\vtBase\Flags\uFlagFrameAB.pas' {FlagFrameAB: TFrame},
  uFlagFrameBC in '..\vtBase\Flags\uFlagFrameBC.pas' {FlagFrameBC: TFrame},
  uFlagFrameCan in '..\vtBase\Flags\uFlagFrameCan.pas' {FlagFrameCan: TFrame},
  uFlagFrameCanada in '..\vtBase\Flags\uFlagFrameCanada.pas' {FlagFrameCanada: TFrame},
  uFlagFrameMB in '..\vtBase\Flags\uFlagFrameMB.pas' {FlagFrameMB: TFrame},
  uFlagFrameMBMCT in '..\vtBase\Flags\uFlagFrameMBMCT.pas' {FlagFrameMBMCT: TFrame},
  uFlagFrameNB in '..\vtBase\Flags\uFlagFrameNB.pas' {FlagFrameNB: TFrame},
  uFlagFrameNF in '..\vtBase\Flags\uFlagFrameNF.pas' {FlagFrameNF: TFrame},
  uFlagFrameNS in '..\vtBase\Flags\uFlagFrameNS.pas' {FlagFrameNS: TFrame},
  uFlagFrameNU in '..\vtBase\Flags\uFlagFrameNU.pas' {FlagFrameNU: TFrame},
  uFlagFrameNW in '..\vtBase\Flags\uFlagFrameNW.pas' {FlagFrameNW: TFrame},
  uFlagFrameON in '..\vtBase\Flags\uFlagFrameON.pas' {FlagFrameON: TFrame},
  uFlagFramePE in '..\vtBase\Flags\uFlagFramePE.pas' {FlagFramePE: TFrame},
  uFlagFrameSK in '..\vtBase\Flags\uFlagFrameSK.pas' {FlagFrameSK: TFrame},
  uFlagFrameYK in '..\vtBase\Flags\uFlagFrameYK.pas' {FlagFrameYK: TFrame},
  T1_2014FrameElections in '..\vtFrames\T1_2014FrameElections.pas' {FrameElectionsT1_2014: TFrame},
  T1_2014SlipsFrame in '..\vtFrames\T1_2014SlipsFrame.pas' {SlipsFrameT1_2014: TFrame},
  T1_2015FrameElections in '..\vtFrames\T1_2015FrameElections.pas' {FrameElectionsT1_2015: TFrame},
  T1_2015SlipsFrame in '..\vtFrames\T1_2015SlipsFrame.pas' {SlipsFrameT1_2015: TFrame},
  uFrameElections in '..\vtFrames\uFrameElections.pas' {FrameElections: TFrame},
  USlipsFrame in '..\vtFrames\USlipsFrame.pas' {SlipsFrame: TFrame},
  HelperAppSettingsFrame in '..\vtFrames\HelperAppSettingsFrame.pas' {frameHelperAppSettings: TFrame},
  HelperSettionsFrame in '..\vtFrames\HelperSettionsFrame.pas' {frameHelperSettings: TFrame},
  HelperAppUserSettingsFrame in '..\vtFrames\HelperAppUserSettingsFrame.pas' {frameHelperAppUserSettings: TFrame},
  ManagerHelperSettingsFrame in '..\vtFrames\ManagerHelperSettingsFrame.pas' {frameManagerHelperSettings: TFrame},
  T1_2016FrameElections in '..\vtFrames\T1_2016FrameElections.pas' {FrameElectionsT1_2016: TFrame}, //20161224 Ifor
  T1_2016SlipsFrame in '..\vtFrames\T1_2016SlipsFrame.pas' {SlipsFrameT1_2016: TFrame};             //20161224 Ifor

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
