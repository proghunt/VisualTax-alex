unit DropBoxLicense;

interface

uses vtLicense;

//20190306 Igor whole file update

const
  HELPER_NAME = 'DropBox';
  DROPBOX_LicenseKeyPrefix = 'DB';

  // 2017 this comment should not be removed for correct work in Autorize_V2 |
  const
    F2_DROPBOX_2017 = 154;
    PgmLicenses_2017: array[0..2] of RPgmLicenseData = (
      (Name:'DropBox Demo';     Id: 'DB00'; Factor: 162; Level: llDemo;  Caps: [lcLimited]),
      (Name:'DropBox';          Id: 'DB01'; Factor: 163; Level: llStd;   Caps: []),
      (Name:'Unlicensed';  	    Id: '';     Factor:   0; Level: llNone;  Caps: [])
  );

  // 2018 this comment should not be removed for correct work in Autorize_V2 |
  const
    F2_DROPBOX_2018 = 155;
    PgmLicenses_2018: array[0..2] of RPgmLicenseData = (
      (Name:'DropBox Demo';     Id: 'DB00'; Factor: 163; Level: llDemo;  Caps: [lcLimited]),
      (Name:'DropBox';          Id: 'DB01'; Factor: 164; Level: llStd;   Caps: []),
      (Name:'Unlicensed';  	    Id: '';     Factor:   0; Level: llNone;  Caps: [])
  );

  // 2019 this comment should not be removed for correct work in Autorize_V2 |
  const
    F2_DROPBOX_2019 = 156;
    PgmLicenses_2019: array[0..2] of RPgmLicenseData = (
      (Name:'DropBox Demo';     Id: 'DB00'; Factor: 164; Level: llDemo;  Caps: [lcLimited]),
      (Name:'DropBox';          Id: 'DB01'; Factor: 165; Level: llStd;   Caps: []),
      (Name:'Unlicensed';  	    Id: '';     Factor:   0; Level: llNone;  Caps: [])
  );

  // 2020 this comment should not be removed for correct work in Autorize_V2 |
  const
    F2_DROPBOX_2020 = 158;
    PgmLicenses_2020: array[0..2] of RPgmLicenseData = (
      (Name:'DropBox Demo';     Id: 'DB00'; Factor: 165; Level: llDemo;  Caps: [lcLimited]),
      (Name:'DropBox';          Id: 'DB01'; Factor: 166; Level: llStd;   Caps: []),
      (Name:'Unlicensed';  	    Id: '';     Factor:   0; Level: llNone;  Caps: [])
  );
  
  // 2021 this comment should not be removed for correct work in Autorize_V2 |
  const
    F2_DROPBOX_2021 = 159;
    PgmLicenses_2021: array[0..2] of RPgmLicenseData = (
      (Name:'DropBox Demo';     Id: 'DB00'; Factor: 166; Level: llDemo;  Caps: [lcLimited]),
      (Name:'DropBox';          Id: 'DB01'; Factor: 167; Level: llStd;   Caps: []),
      (Name:'Unlicensed';  	    Id: '';     Factor:   0; Level: llNone;  Caps: [])
  );

var
  F2_DROPBOX: integer;
  PgmLicenses: array of RPgmLicenseData;

procedure InitLicenseYear(AYear: integer);

implementation

procedure InitLicenseYear(AYear: integer);
  procedure CopyPgmLicense(ALicenses: array of RPgmLicenseData);
  var I: integer;
  begin
    SetLength(PgmLicenses, Length(ALicenses));
    for I := 0 to Length(ALicenses) - 1 do
      PgmLicenses[I] := ALicenses[I];
  end;
begin
  if AYear = 2017 then
  begin
    F2_DROPBOX := F2_DROPBOX_2017;
    CopyPgmLicense(PgmLicenses_2017);
  end
  else if AYear = 2018 then
  begin
    F2_DROPBOX := F2_DROPBOX_2018;
    CopyPgmLicense(PgmLicenses_2018);
  end
  else if AYear = 2019 then
  begin
    F2_DROPBOX := F2_DROPBOX_2019;
    CopyPgmLicense(PgmLicenses_2019);
  end
  else if AYear = 2020 then
  begin
    F2_DROPBOX := F2_DROPBOX_2020;
    CopyPgmLicense(PgmLicenses_2020);
  end
  else if AYear = 2021 then
  begin
    F2_DROPBOX := F2_DROPBOX_2021;
    CopyPgmLicense(PgmLicenses_2021);
  end;
end;


end.