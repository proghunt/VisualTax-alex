unit vtIntDemoUserDB;

interface
type
  IInterfaceDemoUserDB = interface
    function Connect(const aConnectStr: string; const aPwdArr: variant;
      const aCanCreate: boolean; out aErrorString: string): boolean;
    function PrepareDataBase(out aErrorString: string): boolean;
    function AddUser(const aEmail, aPhone, aName: string; out aErrorString: string): boolean;
    function SetPassword(const aEmail, aPassword: string; out aErrorString: string): boolean;
    function SetEndDate(const aPassword: string; const aEndDate: TDateTime; out aErrorString: string): boolean;
    function SendRegMail(const aPassword: string; out aErrorString: string): boolean;
    function SetExeDir(const aPassword, aExeDir: string; out aErrorString: string): boolean;
    function GetExeDir(const aPassword: string;out aExeDir: string; out aErrorString: string): boolean;
    function BlockUser(const aPassword: string; out aErrorString: string): boolean;
    function UnBlockUser(const aPassword: string; out aErrorString: string): boolean;
    function LogOn(const aPassword: string; out aErrorString: string): boolean;
  end;

implementation

end.
