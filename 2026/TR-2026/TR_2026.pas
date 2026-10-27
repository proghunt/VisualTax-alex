unit TR_2026;

interface

Type

{$I ../../COMMON/vtBase/CommonTypes.inc}

const
  //20260826 Alex >>>
  TRF2_2023 = 63;

  PgmLicenses: array[0..3] of RPgmLicenseData = (
    (Name:'TR Demo';     Id: 'TR00'; Factor: 71; Level: llDemo;  Caps: [lcLimited]),
    (Name:'TR Standard'; Id: 'TR01'; Factor: 72; Level: llStd;   Caps: []),
    (Name:'TR Power';    Id: 'TR02'; Factor: 73; Level: llPower; Caps: [lcMultiData]),
    (Name:'Unlicensed';  Id: '';     Factor:0;   Level: llNone;  Caps: [])
  );
  //20260826 Alex <<<

implementation

end.
