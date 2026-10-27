  eLicenseLevel = (
    llNone, //not licensed
    llDemo,
    llHome, //~NetFile
    llLimited,
    llLimEfile,
    llStd,
    llPower,
    llMulti,
    //T2 only
    llMultiPower,
    //FP only
    llAgStd,
    llAgPower,
    llDealer,
    llLimited1Returns,
    llLimited2Returns,
    llLimited3Returns,
    llLimited4Returns,
    llLimited5Returns
    );

  sLicenseLevel = set of eLicenseLevel;

  eLicenseCapabilities = (
    //required by the IDE
    lcLimited, //limited version --> not lcMultiData, limited returns
    lcMultiData, //multiple Data directories
    lcMultiDrive, //more than ABCD: ?
    lcSuperAudit, //= lcSuperVerification?
    lcEFile, //EFile, applies not to Limited, but Limited EFile
    //others
    lcLetter //client letters (Demo, Power, Multi)
    );
  sLicenseCapabilities = set of eLicenseCapabilities;

  RPgmLicenseData = record
    Name: String;
    Id: String;
    Factor: Byte;
    Level: eLicenseLevel;
    Caps: sLicenseCapabilities;
    Caption: string;
  end;