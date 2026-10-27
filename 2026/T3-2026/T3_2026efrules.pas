unit T3_2026Efrules;

interface

function DoRules(RetNo, RuleId: Integer): string;

Implementation

uses
  vtCommon, vtTrimStr, vtShared, T3_2026TrimStr,T3_2026Declare, T3_2026;

function DoRules(RetNo, RuleId: Integer): string;
begin
  Result := '';
end;

end.


