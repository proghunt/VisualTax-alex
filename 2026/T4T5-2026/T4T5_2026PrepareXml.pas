unit T4T5_2026PrepareXml;

interface

Uses
  Classes, vtTrimStr, T4T5_2026Declare, vtMulti;


  Procedure WriteIt(Var F1: TextFile; S: String);
  Procedure PrepareXmitterinfo(ARetNo: Integer; Var F1: TextFile;
    DataTypeCode: String; SubmitRef: String);

  procedure PrepareT4XML(ARetNo: Integer; Var F1: TextFile; DataTypeCode: String);
  Procedure PrepareT4Info(ARetNo: Integer; AFRec: TFRec; Var F1: TextFile;
    DataTypeCode: String);
  Procedure PrepareT4SumInfo(ARetNo: Integer; Var F1: TextFile;
    DataTypeCode: String);

  procedure PrepareT4AXML(ARetNo: Integer; Var F1: TextFile; DataTypeCode: String);
  Function GetTheT4ABoxNameTag(ACD: String; AAmt: Real): String;
  Procedure PrepareT4AInfo(ARetNo: Integer; AFRec: TFRec; Var F1: TextFile;
    DataTypeCode: String);
  Procedure PrepareT4ASumInfo(ARetNo: Integer; Var F1: TextFile;
    DataTypeCode: String);

  procedure PrepareT5XML(ARetNo: Integer; Var F1: TextFile; DataTypeCode: String);
  Procedure PrepareT5Info(ARetNo: Integer; AFRec: TFRec; Var F1: TextFile;
    DataTypeCode: String);
  Procedure PrepareT5SumInfo(ARetNo: Integer; Var F1: TextFile;
    DataTypeCode: String);

Implementation

uses
  vtCommon, T4T5_2026, T4T5_2026TrimStr, System.SysUtils, System.Math, System.StrUtils;
const
 indent = 10;
 indentM = 15;
 indentMM = 20;
 indentMMM = 25;
 indentMMMM = 30;

 Var
   FlNm: String;
   SubRef: String;

function ConcatStr(AString: string; AValue: string): string;
begin
  Result := AString;
  if not AValue.IsEmpty then
    Result := Result + IfThen(Result.IsEmpty, '', #10#13) + AValue;
end;

Procedure WriteIt(Var F1: TextFile; S: String);
Begin
  If S > '' then
    WriteLn(F1, S);
end;
//20260107 Igor >>>
Procedure PrepareXmitterinfo(ARetNo: Integer; Var F1: TextFile;
  DataTypeCode: String; SubmitRef: String);
Var
  S, Info, Lang: String;
begin
  SubRef := SubmitRef; //SubmissionPrefixBox.Text+SubmissionSeqBox.Text;
  // FlNm:=DiskFrm.FlNm.Text;
  s := '<?xml version="1.0" encoding="UTF-8"?>';
  WriteIt(F1, s);

  s := '<Submission xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';  //20250122
  WriteIt(F1, s);

  //s := 'xsi:noNamespaceSchemaLocation="layout-topologie.xsd">'; WriteIt(F1, s);

  //220250104
  s := Space(indent) + '<T619>';
  WriteIt(F1, s);
  //-------------------------------------
  If AllTrim(OptRec.Prp_TransmitterNo)>'' then
  Begin
   s := Space(indent) + '<TransmitterAccountNumber>';
   WriteIt(F1, s);
   s:=OptRec.Prp_TransmitterNo;
   If Length(s)=9 then
    s:=Space(indent)+'<bn9>'+OptRec.Prp_TransmitterNo+'</bn9>'  //20250114
   Else
    s:=Space(indent)+'<bn15>'+OptRec.Prp_TransmitterNo+'</bn15>';    //20250116
   WriteIt(F1, s);

   //20250105 Igor >>> //If we will use Trust or NR4 numbers we should add one of the next tag:
   //<trust></trust> //- 1 alpha (must be upper case), 8 numeric, example: T00000000
   //<nr4></nr4>//- 3 alpha (must be upper case), 6 numeric, example: AAA000000
   //20250105 Igor <<<

   s := Space(indent) + '</TransmitterAccountNumber>';
   WriteIt(F1, s);
  End;

  //20250204
  If OptRec.Prp_RepId>'' then
  Begin
   S:='<TransmitterRepID>';
   WriteIt(F1, s);
    s:=Space(indent)+'<RepID>'+OptRec.Prp_RepId+'</RepID>';  //20250116
    WriteIt(F1, s);
   S:='</TransmitterRepID>';
   WriteIt(F1, s);
  End;

  //=============================
   //20260108
   s := Space(indentM) + '<sbmt_ref_id>' + SubRef + '</sbmt_ref_id>';
   WriteIt(F1, s);
  { //20260108
  //? required 8
  If OptRec.Prp_RepId='' then //do not show referenca No //20250129
  Begin
   s := Space(indentM) + '<sbmt_ref_id>' + SubRef + '</sbmt_ref_id>';
   WriteIt(F1, s);
  End;
 }
  //[29] required 6 numeric
  s := Space(indentM) + '<summ_cnt>' + '1' + '</summ_cnt>';
  WriteIt(F1, s);

  Lang := 'E';
  (* Default only to 'E'  = English
  {TODO : check form T619_1}
  If FetchElm(ARetNo, 'T619_1',28) > '' then
    Lang:='F';
  *)
  s := Space(indentM) + '<lang_cd>' + Lang + '</lang_cd>';
  WriteIt(F1,s);

  //------------------  transmitter name
  s:=Space(indentM) + '<TransmitterName>';
  WriteIt(F1,s);

  info := ReplaceReservedXMLCharactersAndTruncate(AppT4T5_2026.Prp_name, 30);
  //[2] required first 30 alphanumeric
  s:=Space(indentMM) + '<l1_nm>' + info + '</l1_nm>';
  WriteIt(F1,s);

  //20260105 Igor >>> - no longer allows second line
  {info := ReplaceReservedXMLCharactersAndTruncate(MidStr(AppT4T5_2026.Prp_name, 31, 30), 30);
  //[2] required second 30 alphanumeric
  If info > '' then
  begin
    s := Space(indentMM) + '<l2_nm>' + info + '</l2_nm>';
    WriteIt(F1, s);
  end;}
  //20260105 Igor <<<

  s := Space(indentM) + '</TransmitterName>';
  WriteIt(F1, s);

  //? required 3 alphanumeric
  s := Space(indentM) + '<TransmitterCountryCode>' + 'CAN' + '</TransmitterCountryCode>'; //20260202 Igor
  WriteIt(F1, s);

  s:=Space(indentM) + '<CNTC>';
  WriteIt(F1,s);

  //[8] required 22 alphanumeric, omit titles
  info := ReplaceReservedXMLCharactersAndTruncate(AppT4T5_2026.Prp_ContactName, 22);
  s:=Space(indentMM) + '<cntc_nm>' + info + '</cntc_nm>';
  WriteIt(F1, s);

  //[6] - first 3 numbers
  s := Space(indentMM) + '<cntc_area_cd>' + LeftStr(AppT4T5_2026.Prp_Area, 3) + '</cntc_area_cd>';   //20180104
  WriteIt(F1,s);

  //[6] - last 7 numbers 3 then '-' then last 4  - needs validation on input
  s := Space(indentMM) + '<cntc_phn_nbr>' + LeftStr(AppT4T5_2026.Prp_Tel, 8) + '</cntc_phn_nbr>';   //20180104
  WriteIt(F1,s);

  //20250526 Igor >>>
  if AppT4T5_2026.Prp_Email > '' then  //20250121
  begin
    s:= Space(indentMM) + '<cntc_email_area>' + AppT4T5_2026.Prp_Email + '</cntc_email_area>'; //20260202 Igor
    //s := Space(indentM) + '<cntc_email_area>' + GetEmailAddr + '</cntc_email_area>';
    WriteIt(F1, s);
  end;
  //20250526 Igor <<<

  s := Space(indentM) + '</CNTC>';
  WriteIt(F1, s);

  s := Space(indent) + '</T619>';
  WriteIt(F1, s);
end;
//20260107 Igor <<<
{$REGION 'T4'}
procedure PrepareT4XML(ARetNo: Integer; Var F1: TextFile; DataTypeCode: String);
var
  S: String;
  FInstForms: TFRecArray;
  I: Integer;
begin
  FInstForms := FList.GetAllInstForms('T4');
  // start return tag
  s := Space(indent) + '<Return>';
  WriteIt(F1, s);

  s := Space(indentM) + '<T4>';
  WriteIt(F1, s);
  {loop for slips}
  for I := Low(FInstForms) to High(FInstForms) do
    PrepareT4Info(ARetNo, FInstForms[I], F1, DataTypeCode);

  PrepareT4SumInfo(ARetNo, F1, DataTypeCode);

  s := Space(indentM) + '</T4>';
  WriteIt(F1, s);

  s := Space(indent) + '</Return>';
  WriteIt(F1,s);

  s:= '</Submission>';
  WriteIt(F1,s);
end;

Procedure PrepareT4Info(ARetNo: Integer; AFRec: TFRec; Var F1: TextFile;
  DataTypeCode: String);
Const
  Format1 = '########0.00';
Var
  i, n: Integer;
  S28A, S28B, S28C, SinString, s, info: String;
  BoxArray: array[1..6] of string;
  BoxAmounts: array[1..6] of real;
  LIsExistsOtherInfo: boolean; //20250213 Igor
  LAMTString: string; //20250213 Igor
  XmlList: TStringList; //20260116 Igor
begin
  BoxArray[1] := PaddZero(FetchElm(ARetNo, AFRec.FormNo, T4_BOXCODE1), 2);
  BoxArray[2] := PaddZero(FetchElm(ARetNo, AFRec.FormNo, T4_BOXCODE2), 2);
  BoxArray[3] := PaddZero(FetchElm(ARetNo, AFRec.FormNo, T4_BOXCODE3), 2);
  BoxArray[4] := PaddZero(FetchElm(ARetNo, AFRec.FormNo, T4_BOXCODE4), 2);
  BoxArray[5] := PaddZero(FetchElm(ARetNo, AFRec.FormNo, T4_BOXCODE5), 2);
  BoxArray[6] := PaddZero(FetchElm(ARetNo, AFRec.FormNo, T4_BOXCODE6), 2);

  BoxAmounts[1] := MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Amount1));
  BoxAmounts[2] := MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Amount2));
  BoxAmounts[3] := MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Amount3));
  BoxAmounts[4] := MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Amount4));
  BoxAmounts[5] := MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Amount5));
  BoxAmounts[6] := MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Amount6));

  if FetchElm(ARetNo,AFrec.FormNo,11)='' then exit; //20180114 NO name on T4

  s := Space(indentMM) + '<T4Slip>';
  WriteIt(F1, s);

  s:=Space(indentMMM) + '<EMPE_NM>';
  WriteIt(F1, s);

  // replace special characters
  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4_LASTNAME), 20);
  s := Space(indentMMMM) + '<snm>'+ info +'</snm>'; //required
  WriteIt(F1, s);

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4_FirstName), 12);
  if info <> '' then
  begin
    s := Space(indentMMMM) + '<gvn_nm>'+ info + '</gvn_nm>'; //required
    WriteIt(F1,s);
  end;

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4_Initials), 1);
  if info <> '' then
  Begin
    s := Space(indentMMMM) + '<init>' + info + '</init>';
    WriteIt(F1, s);
  end;

  s := Space(indentMMM) + '</EMPE_NM>';
  WriteIt(F1, s);

  s:=Space(indentMMM) + '<EMPE_ADDR>';
  WriteIt(F1, s);

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4_Street), 30);
  if info <> '' then
  begin
    s := Space(indentMMMM) + '<addr_l1_txt>' + info + '</addr_l1_txt>';
    WriteIt(F1, s);
  end;

  info := ReplaceReservedXMLCharactersAndTruncate(MidStr(FetchElm(ARetNo, AFRec.FormNo, T4_Street), 31, 30),30);
  if info <> '' then
  begin
    s := Space(indentMMMM) + '<addr_l2_txt>' + info + '</addr_l2_txt>';
    WriteIt(F1, s);
  end;

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4_City), 28);
  if info <> '' then
  begin
    s := Space(indentMMMM) + '<cty_nm>' + info + '</cty_nm>';
    WriteIt(F1, s);
  end;


  info := UpperCase(alltrim(LeftStr(FetchElm(ARetNo, AFRec.FormNo, 17), 2)));    //20200302
  //info := UpperCase(alltrim(LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4_PROVINCE), 2)));

  s:=Space(indentMMMM) + '<prov_cd>' + info + '</prov_cd>';
  WriteIt(F1, s);
{TODO : Check COUNTRY}
{
  If FetchElm(ARetNo, AFRec.FormNo, T4_Country) > '' then
  begin
    s := Space(indentMMMM) + '<cntry_cd>' + alltrim(LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4_Country),3)) + '</cntry_cd>';
    WriteIt(F1,s);
  end;
}
{TODO : Check POSTAL}
{
  If FetchElm(ARetNo, AFRec.FormNo, T4_Postal) > '' then
  begin
    s := Space(indentMMMM) + '<pstl_cd>' + alltrim(FixPostal(FetchElm(ARetNo, AFRec.FormNo, T4_Postal))) + '</pstl_cd>';
    WriteIt(F1,s);
  end;
}
  s := Space(indentMMM) + '</EMPE_ADDR>';
  WriteIt(F1,s);

  SinString := FetchElm(ARetNo, AFRec.FormNo, T4_SIN);
  if (SinString = '') or (LeftStr(SinString, 1) = 'D') then
    SinString := '000000000';
  s := Space(indentMMM) + '<sin>' + SinString + '</sin>';
  WriteIt(F1, s);

{TODO : CHECK NUMBER}
{
  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4_NUMBER), 20);
  if info <> '' then
  begin
    s := Space(indentMMM) + '<empe_nbr>' + info + '</empe_nbr>';
    WriteIt(F1,s);
  end;
}

  //is required but prompt does not force entry
  s := Space(indentMMM) + '<bn>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_ACCOUNTT4), 15) + '</bn>';
  WriteIt(F1, s);

  if LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4_Box50), 7) <> '' then
  begin
    s := Space(indentMMM) + '<rpp_dpsp_rgst_nbr>' + LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4_Box50),7) + '</rpp_dpsp_rgst_nbr>';
    WriteIt(F1,s);
  end;

  If (FetchElm(ARetNo, AFRec.FormNo, T4_Box28A) = 'X') or
     (FetchElm(ARetNo, AFRec.FormNo, T4_Box28A) = 'Y') then
    S28A := '1'
  else
    S28A := '0';
  If (FetchElm(ARetNo, AFRec.FormNo, T4_Box28B) = 'X') or
     (FetchElm(ARetNo, AFRec.FormNo, T4_Box28B) = 'Y') then
    S28B := '1'
  else
    S28B := '0';
  If (FetchElm(ARetNo, AFRec.FormNo, T4_Box28C) = 'X') or
     (FetchElm(ARetNo, AFRec.FormNo, T4_Box28C) = 'Y') then
    S28C := '1'
  else
    S28C := '0';

  s := Space(indentMMM) + '<cpp_qpp_xmpt_cd>' + LeftStr(S28A, 1) + '</cpp_qpp_xmpt_cd>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<ei_xmpt_cd>' + LeftStr(S28B, 1) + '</ei_xmpt_cd>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<prov_pip_xmpt_cd>' + LeftStr(S28C, 1) + '</prov_pip_xmpt_cd>';
  WriteIt(F1, s);

  if (LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4_EmplCode), 2) >= '11') and
     (LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4_EmplCode), 2) <= '16') then
  begin
    s := Space(indentMMM) + '<empt_cd>' + LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4_EmplCode), 2) + '</empt_cd>';
    WriteIt(F1, s);
  end;

  //for amendmennts must save file on disk and send to Magnetic media group
  s := Space(indentMMM) + '<rpt_tcd>' + DataTypeCode + '</rpt_tcd>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<empt_prov_cd>' + UpperCase(LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4_Province), 2)) + '</empt_prov_cd>';
  WriteIt(F1, s);

  //20260202 Igor >>>
  if not FetchElm(ARetNo, AFRec.FormNo, 49).IsEmpty then
  begin
    s:= Space(indentMMMM) + '<empr_dntl_ben_rpt_cd>' + LeftStr(FetchElm(ARetNo, AFRec.FormNo, 49), 1) + '</empr_dntl_ben_rpt_cd>';
    WriteIt(F1, s);
  end;
  //20260202 Igor <<<

  //20260116 Igor >>>
  XmlList:= TStringList.Create;
  try
    //20250213 Igor >>>
    LAMTString := '';

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box14)) <> 0 then
    begin
      s := Space(indentMMMM) + '<empt_incamt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box14))) + '</empt_incamt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box16)) <> 0 then
    begin
      s := Space(indentMMMM) + '<cpp_cntrb_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box16))) + '</cpp_cntrb_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box16e)) <> 0 then //20250124
    begin
      s := Space(indentMMMM) + '<cppe_cntrb_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box16e))) + '</cppe_cntrb_amt>'; //20250124
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box17)) <> 0 then
    begin
      s := Space(indentMMMM) + '<qpp_cntrb_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box17))) + '</qpp_cntrb_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box18)) <>  0 then
    begin
      s := Space(indentMMMM) + '<empe_eip_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box18))) + '</empe_eip_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box20)) <> 0 then
    begin
      s := Space(indentMMMM) + '<rpp_cntrb_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box20))) + '</rpp_cntrb_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box22)) <> 0 then
    begin
      s := Space(indentMMMM) + '<itx_ddct_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box22))) + '</itx_ddct_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box24)) <> 0 then
    begin
      s := Space(indentMMMM) + '<ei_insu_ern_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box24))) + '</ei_insu_ern_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end else
    begin
      s:= Space(indentMMMM) + '<ei_insu_ern_amt>0.00</ei_insu_ern_amt>';
      XmlList.Add(s);
      LAMTString:= ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box26)) <> 0 then
    begin
      s := Space(indentMMMM) + '<cpp_qpp_ern_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box26))) + '</cpp_qpp_ern_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end else
    begin
      s:= Space(indentMMMM) + '<cpp_qpp_ern_amt>0.00</cpp_qpp_ern_amt>';
      XmlList.Add(s);
      LAMTString:= ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box44)) <> 0 then
    begin
      s := Space(indentMMMM) + '<unn_dues_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box44))) + '</unn_dues_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box46)) <> 0 then
    begin
      s := Space(indentMMMM) + '<chrty_dons_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box46))) + '</chrty_dons_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box52)) <> 0 then
    begin
      s := Space(indentMMMM) + '<padj_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box52))) + '</padj_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box55)) <> 0 then
    begin
      s := Space(indentMMMM) + '<prov_pip_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box55))) + '</prov_pip_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box56)) <> 0 then
    begin
      s := Space(indentMMMM) + '<prov_insu_ern_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4_Box56))) + '</prov_insu_ern_amt>';
      XmlList.Add(s);
      LAMTString := ConcatStr(LAMTString, s);
    end;

    {if not LAMTString.IsEmpty then
    begin
      s := Space(indentMMM) + '<T4_AMT>';
      WriteIt(F1, s);

      WriteIt(F1, LAMTString);

      s := Space(indentMMM) + '</T4_AMT>';
      WriteIt(F1, s);
    end;}

    if (XmlList.Count > 0) then
    begin
      s := Space(indentMMM) + '<T4_AMT>';
      WriteIt(F1, s);

      for i:= 0 to pred(XmlList.Count) do WriteIt(F1, XmlList[i]);

      s := Space(indentMMM) + '</T4_AMT>';
      WriteIt(F1, s);
    end;
  finally
    XmlList.Free;
  end;
  //20260116 Igor <<<

  //20250213 Igor >>>
  LIsExistsOtherInfo := False;
  for n  := 1 to 6 do
  if RoundTo(BoxAmounts[n], -2) <> 0 then
  begin
    LIsExistsOtherInfo := True;
    Break;
  end;

  if LIsExistsOtherInfo then
  begin
  //20250213 Igor <<<
    s:=Space(indentMMM) + '<OTH_INFO>';
    WriteIt(F1, s);

    for n := 1 to 6 do      //loop through other information
    begin
      //20260202 Igor. This is wrong tag position should be placed upper. //20250213 Igor >>>
      {if BoxArray[n] = '45' then
      begin
        s := Space(indentMMMM) + '<empr_dntl_ben_rpt_cd>' + FormatFloat(Format1, BoxAmounts[n]) + '</empr_dntl_ben_rpt_cd>';
        WriteIt(F1, s);
      end;   }
      //20250213 Igor <<<

      if BoxArray[n] = '30' then
      begin
        s := Space(indentMMMM) + '<hm_brd_lodg_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</hm_brd_lodg_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '31' then
      begin
        s := Space(indentMMMM) + '<spcl_wrk_site_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</spcl_wrk_site_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '32' then
      begin
        s := Space(indentMMMM) + '<prscb_zn_trvl_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</prscb_zn_trvl_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '33' then
      begin
        s := Space(indentMMMM) + '<med_trvl_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</med_trvl_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '34' then
      begin
        s := Space(indentMMMM) + '<prsnl_vhcl_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</prsnl_vhcl_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '35' then
      begin
        s := Space(indentMMMM) + '<rsn_per_km_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</rsn_per_km_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '36' then
      begin
        s := Space(indentMMMM) + '<low_int_loan_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</low_int_loan_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '37' then
      begin
        s := Space(indentMMMM) + '<empe_hm_loan_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</empe_hm_loan_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '97' then
      begin
        s := Space(indentMMMM) + '<stok_opt_ben_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</stok_opt_ben_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '38' then
      begin
        s := Space(indentMMMM) + '<sob_a00_feb_amt >' + FormatFloat(Format1, BoxAmounts[n]) + '</sob_a00_feb_amt >';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '98' then
      begin
        s := Space(indentMMMM) + '<shr_opt_d_ben_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</shr_opt_d_ben_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '39' then
      begin
        s := Space(indentMMMM) + '<sod_d_a00_feb_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</sod_d_a00_feb_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '40' then
      begin
        s := Space(indentMMMM) + '<oth_tx_ben_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</oth_tx_ben_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '99' then
      begin
        s := Space(indentMMMM) + '<shr_opt_d1_ben_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</shr_opt_d1_ben_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '41' then
      begin
        s := Space(indentMMMM) + '<sod_d1_a00_feb_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</sod_d1_a00_feb_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '42' then
      begin
        s := Space(indentMMMM) + '<empt_cmsn_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</empt_cmsn_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '43' then
      begin
        s := Space(indentMMMM) + '<cfppa_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</cfppa_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '53' then
      begin
        s := Space(indentMMMM) + '<dfr_sob_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</dfr_sob_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '66' then
      begin
        s := Space(indentMMMM) + '<elg_rtir_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</elg_rtir_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '67' then
      begin
        s := Space(indentMMMM) + '<nelg_rtir_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</nelg_rtir_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '68' then
      begin
        s := Space(indentMMMM) + '<indn_elg_rtir_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</indn_elg_rtir_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '69' then
      begin
        s := Space(indentMMMM) + '<indn_nelg_rtir_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</indn_elg_rtir_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '70' then
      begin
        s := Space(indentMMMM) + '<mun_ofcr_examt>' + FormatFloat(Format1, BoxAmounts[n]) + '</mun_ofcr_examt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '71' then
      begin
        s := Space(indentMMMM) + '<indn_empe_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</indn_empe_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '72' then
      begin
        s := Space(indentMMMM) + '<oc_incamt>' + FormatFloat(Format1, BoxAmounts[n]) + '</oc_incamt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '73' then
      begin
        s := Space(indentMMMM) + '<oc_dy_cnt>' + FormatFloat(Format1, BoxAmounts[n]) + '</oc_dy_cnt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '74' then
      begin
        s := Space(indentMMMM) + '<pr_90_cntrbr_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</pr_90_cntrbr_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '75' then
      begin
        s := Space(indentMMMM) + '<pr_90_ncntrbr_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</pr_90_ncntrbr_amt>';
        WriteIt(F1, s);
      end;

      if BoxArray[n] = '77' then
      begin
        s := Space(indentMMMM) + '<cmpn_rpay_empr_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</cmpn_rpay_empr_amt>';
        WriteIt(F1, s);
      end;
      if BoxArray[n] = '78' then
      begin
        s := Space(indentMMMM) + '<fish_gro_ern_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</fish_gro_ern_amt>';
        WriteIt(F1, s);
      end;
      if BoxArray[n] = '79' then
      begin
        s := Space(indentMMMM) + '<fish_net_ptnr_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</fish_net_ptnr_amt>';
        WriteIt(F1, s);
      end;
      if BoxArray[n] = '80' then
      begin
        s := Space(indentMMMM) + '<fish_shr_prsn_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</fish_shr_prsn_amt>';
        WriteIt(F1, s);
      end;
      if BoxArray[n] = '81' then
      begin
        s := Space(indentMMMM) + '<plcmt_emp_agcy_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</plcmt_emp_agcy_amt>';
        WriteIt(F1, s);
      end;
      if BoxArray[n] = '82' then
      begin
        s := Space(indentMMMM) + '<drvr_taxis_oth_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</drvr_taxis_oth_amt>';
        WriteIt(F1, s);
      end;
      if BoxArray[n] = '83' then
      begin
        s := Space(indentMMMM) + '<brbr_hrdrssr_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</brbr_hrdrssr_amt>';
        WriteIt(F1, s);
      end;
      if BoxArray[n] = '84' then
      begin
        s := Space(indentMMMM) + '<pub_trnst_pass_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</pub_trnst_pass_amt>';
        WriteIt(F1, s);
      end;
      if BoxArray[n] = '85' then
      begin
        s := Space(indentMMMM) + '<epaid_hlth_pln_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</epaid_hlth_pln_amt>';
        WriteIt(F1, s);
      end;
     //20131224
      if BoxArray[n] = '88' then
      begin
        s := Space(indentMMMM) + '<indn_txmpt_sei_amt>' + FormatFloat(Format1, BoxAmounts[n]) + '</indn_txmpt_sei_amt>';
        WriteIt(F1, s);
      end;

     //20210107
      if BoxArray[n] = '57' then
      begin
        s := Space(indentMMMM) + '<empt_inc_amt_covid_prd1>' + FormatFloat(Format1, BoxAmounts[n]) + '</empt_inc_amt_covid_prd1>';
        WriteIt(F1, s);
      end;
    //20210107
      if BoxArray[n] = '58' then
      begin
        s := Space(indentMMMM) + '<empt_inc_amt_covid_prd2>' + FormatFloat(Format1, BoxAmounts[n]) + '</empt_inc_amt_covid_prd2>';
        WriteIt(F1, s);
      end;
    //20210107
      if BoxArray[n] = '59' then
      begin
        s := Space(indentMMMM) + '<empt_inc_amt_covid_prd3>' + FormatFloat(Format1, BoxAmounts[n]) + '</empt_inc_amt_covid_prd3>';
        WriteIt(F1, s);
      end;
    //20210107
      if BoxArray[n] = '60' then
      begin
        s := Space(indentMMMM) + '<empt_inc_amt_covid_prd4>' + FormatFloat(Format1, BoxAmounts[n]) + '</empt_inc_amt_covid_prd4>';
        WriteIt(F1, s);
      end;
    end; // end other info loop
    s := Space(indentMMM) + '</OTH_INFO>';
    WriteIt(F1, s);
  end; //20250213 Igor

  s := Space(indentMM) + '</T4Slip>';
  WriteIt(F1, s);
end; // end PrepareT4Info

Procedure PrepareT4SumInfo(ARetNo: Integer; Var F1: TextFile;
    DataTypeCode: String);
Const
  Format1 = '########0.00';
Var
  i: Integer;
  s: String;
  info: String;
  T4Sum: TT4Sum;
  LT4TAMT: string; //20250213 Igor
  XmlList: TStringList; //20260116 Igor
begin
  SummarizeT4Slips(ARetNo, T4Sum);

  s := Space(indentMM) + '<T4Summary>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<bn>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_ACCOUNTT4), 15) + '</bn>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<EMPR_NM>';
  WriteIt(F1, s);

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_Empl_Name), 30);
  s := Space(indentMMMM) + '<l1_nm>' + info + '</l1_nm>';
  WriteIt(F1, s);

  info := ReplaceReservedXMLCharactersAndTruncate(MidStr(FetchElm(ARetNo, 'EMPL', EMPL_Empl_Name), 31, 30),30);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<l2_nm>' + info + '</l2_nm>';
    WriteIt(F1, s);
  end;

 //s:=Space(indentMM) + '<l3_nm>' + '' + '</l3_nm>';
 //WriteIt(F1,s);

  s := Space(indentMMM) + '</EMPR_NM>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<EMPR_ADDR>';
  WriteIt(F1, s);

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_Street), 30);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<addr_l1_txt>' + info + '</addr_l1_txt>';
    WriteIt(F1, s);
  end;

  info := ReplaceReservedXMLCharactersAndTruncate(MidStr(FetchElm(ARetNo, 'EMPL', EMPL_Street), 31, 30),30);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<addr_l2_txt>' + info + '</addr_l2_txt>';
    WriteIt(F1, s);
  end;

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_City), 28);
  s := Space(indentMMMM) + '<cty_nm>' + info + '</cty_nm>';
  WriteIt(F1, s);

  s := Space(indentMMMM) + '<prov_cd>' + UpperCase(LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Prov), 2)) + '</prov_cd>';
  WriteIt(F1, s);

  if Length(FetchElm(ARetNo, 'EMPL', EMPL_Country)) > 0 then
  begin
    s := Space(indentMMMM) + '<cntry_cd>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Country), 3) + '</cntry_cd>';
    WriteIt(F1, s);
  end;

  s := Space(indentMMMM) + '<pstl_cd>' + LeftStr(FixPostal(FetchElm(ARetNo, 'EMPL', EMPL_Postal)), 10) + '</pstl_cd>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '</EMPR_ADDR>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<CNTC>';
  WriteIt(F1, s);

 //20110209
  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_FirstName) + ' ' + FetchElm(ARetNo, 'EMPL', EMPL_LastName), 22);
  s := Space(indentMMMM) + '<cntc_nm>' + info + '</cntc_nm>';
  WriteIt(F1, s);

  if FetchElm(ARetNo, 'EMPL', EMPL_AreaCode) > '' then
  begin
    s := Space(indentMMMM) + '<cntc_area_cd>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_AreaCode), 3) + '</cntc_area_cd>';
    WriteIt(F1, s);
  end;

  if FetchElm(ARetNo, 'EMPL', EMPL_Telephone) > '' then
  begin
    s := Space(indentMMMM) + '<cntc_phn_nbr>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Telephone), 3) + '-' + RightStr(FetchElm(ARetNo, 'EMPL', EMPL_Telephone), 4) + '</cntc_phn_nbr>';
    WriteIt(F1, s);
  end;
{TODO : Check EMPL_Extension}
{  if FetchElm(ARetNo, 'EMPL', EMPL_Extension) > '' then
  begin
    s := Space(indentMMMM) + '<cntc_extn_nbr>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Extension), 4) + '</cntc_extn_nbr>';
    WriteIt(F1, s);
  end;}

  s := Space(indentMMM) + '</CNTC>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<tx_yr>' + AppYear + '</tx_yr>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<slp_cnt>' + T4Sum.NumSlips + '</slp_cnt>'; //jz 20190502
  WriteIt(F1, s);

  if (FetchElm(ARetNo, 'EMPL', EMPL_PropSin1) > '') or (FetchElm(ARetNo, 'EMPL', EMPL_PropSin2) > '') then
  begin
    s := Space(indentMMM) + '<PPRTR_SIN>';
    WriteIt(F1, s);

    if FetchElm(ARetNo, 'EMPL', EMPL_PropSin1) > '' then
    begin
      s := Space(indentMMMM) + '<pprtr_1_sin>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_PropSin1), 9) + '</pprtr_1_sin>';
      WriteIt(F1, s);
    end;

    if FetchElm(ARetNo, 'EMPL', EMPL_PropSin2) > '' then
    begin
      s := Space(indentMMMM) + '<pprtr_2_sin>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_PropSin2), 9) + '</pprtr_2_sin>';
      WriteIt(F1, s);
    end;

    s := Space(indentMMM) + '</PPRTR_SIN>';
    WriteIt(F1, s);
  end;

  s := Space(indentMMM) + '<rpt_tcd>' + DataTypeCode + '</rpt_tcd>';
  WriteIt(F1, s);

  //20260116 Igor >>>
  XmlList:= TStringList.Create;
  try
    // 20250213 Igor >>>
    LT4TAMT := '';

    if T4Sum.TotBox14 <> 0 then
    begin
      s := Space(indentMMMM) + '<tot_empt_incamt>' + FormatFloat(Format1, T4Sum.TotBox14) + '</tot_empt_incamt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    if T4Sum.TotBox16 <> 0 then
    begin
      s := Space(indentMMMM) + '<tot_empe_cpp_amt>' + FormatFloat(Format1, T4Sum.TotBox16) + '</tot_empe_cpp_amt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    if T4Sum.TotBox16e <> 0 then  //20240124
    begin
      s := Space(indentMMMM) + '<tot_empe_cppe_amt>' + FormatFloat(Format1, T4Sum.TotBox16e) + '</tot_empe_cppe_amt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    if T4Sum.TotBox18 <> 0 then
    begin
      s := Space(indentMMMM) + '<tot_empe_eip_amt>' + FormatFloat(Format1, T4Sum.TotBox18) + '</tot_empe_eip_amt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    if T4Sum.TotBox20 <> 0 then
    begin
      s := Space(indentMMMM) + '<tot_rpp_cntrb_amt>' + FormatFloat(Format1, T4Sum.TotBox20) + '</tot_rpp_cntrb_amt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    if T4Sum.TotBox22 <> 0 then
    begin
      s := Space(indentMMMM) + '<tot_itx_ddct_amt>' + FormatFloat(Format1, T4Sum.TotBox22) + '</tot_itx_ddct_amt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    if T4Sum.TotBox52 <> 0 then
    begin
      s := Space(indentMMMM) + '<tot_padj_amt>' + FormatFloat(Format1, T4Sum.TotBox52) + '</tot_padj_amt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    if T4Sum.EmployerCPP <> 0 then
    begin
      s := Space(indentMMMM) + '<tot_empr_cpp_amt>' + FormatFloat(Format1, T4Sum.EmployerCPP) + '</tot_empr_cpp_amt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    if T4Sum.EmployerCPPe <> 0 then  //20250124
    begin
      s := Space(indentMMMM) + '<tot_empr_cppe_amt>' + FormatFloat(Format1, T4Sum.EmployerCPPe) + '</tot_empr_cppe_amt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    T4Sum.EmployerEI:=T4Sum.TotBox18 * 1.40; //20260304 //Vl(FetchElm(RetNo,'EMPL', 21) // 1.40;

    if T4Sum.EmployerEI <> 0 then
    begin
      s := Space(indentMMMM) + '<tot_empr_eip_amt>' + FormatFloat(Format1, T4Sum.EmployerEI) + '</tot_empr_eip_amt>';
      XmlList.Add(s);
      LT4TAMT := ConcatStr(LT4TAMT, s);
    end;

    {if not LT4TAMT.IsEmpty then
    begin
      s := Space(indentMMM) + '<T4_TAMT>';
      WriteIt(F1, s);

      WriteIt(F1, LT4TAMT);

      s := Space(indentMMM) + '</T4_TAMT>';
      WriteIt(F1, s);
    end;}
    //20250213 Igor <<<

    if (XmlList.Count > 0) then
    begin
      s:= Space(indentMMM) + '<T4_TAMT>';
      WriteIt(F1, s);

      for i:= 0 to pred(XmlList.Count) do WriteIt(F1, XmlList[i]);

      s:= Space(indentMMM) + '</T4_TAMT>';
      WriteIt(F1, s);
    end;
  finally
    XmlList.Free;
  end;
  //20260116 Igor <<<

  s := Space(indentMM) + '</T4Summary>';
  WriteIt(F1, s);
end; //end PrepareT4SumInfo
{$ENDREGION}


{$REGION 'T4A'}

procedure PrepareT4AXML(ARetNo: Integer; Var F1: TextFile; DataTypeCode: String);
const
  Format1 = '#########.##';
var
  I: Integer;
  s: string;
  InstForms: TFRecArray;
begin
  s := Space(indent) + '<Return>';
  WriteIt(F1, s);

  s := Space(indentM) + '<T4A>';
  WriteIt(F1, s);

  InstForms := FList.GetAllInstForms('T4A');
 {loop for slips}
  for I := Low(InstForms) to High(InstForms) do
    PrepareT4AInfo(ARetNo, InstForms[I], F1,  DataTypeCode);
  PrepareT4ASumInfo(ARetNo, F1, DataTypeCode);

  s := Space(indentM) + '</T4A>';
  WriteIt(F1, s);
  s := Space(indent) + '</Return>';
  WriteIt(F1, s);

  s := '</Submission>';
  WriteIt(F1, s);

end;

//20260120 Igor >>>
//https://www.canada.ca/en/revenue-agency/services/e-services/filing-information-returns-electronically-t4-t5-other-types-returns-overview/t619-2026/t4a-2026.html
procedure PrepareT4AInfo(ARetNo: Integer; AFRec: TFRec; Var F1: TextFile; DataTypeCode: string);
const
  Format1 = '########0.00';

var
  SinString: string; //[9]; //20170612 Igor
  s, info, LastNm, RecipBnString, CorpLastNm: string;
  i, n: Integer;
  BoxArray: array[1..6] of string[2];
  BoxAmounts: array[1..6] of real;
  Bx: string;
  LT4AATM: string;//20250213 Igor
  lCountryCode: string; //20260120 Igor

  //20250207 Igor >>>
  function CheckCDAndAmt(ACD, AAmt: Integer): boolean;
  var
    CD: String;
    Amt: Real;
  begin
    Cd := FetchElm(ARetNo, AFRec.FormNo, ACD);
    Amt := MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, AAmt));
    Result := not GetTheT4ABoxNameTag(Cd, Amt).IsEmpty;
  end;
  //20250207 Igor <<<

  procedure WriteCDAndAmt(ACD, AAmt: Integer);
  var
    CD: String;
    Amt: Real;
    NameTag: string;
  begin
    Cd := FetchElm(ARetNo, AFRec.FormNo, ACD);
    Amt := MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, AAmt));
    NameTag := GetTheT4ABoxNameTag(Cd, Amt);
    if NameTag > '' then
    begin
      s := Space(indentMMMM) + '<' + NameTag + '>' + FormatFloat(Format1, Amt) + '</' + NameTag + '>';
      WriteIt(F1, s);
    end;
  end;
begin
  if FetchElm(ARetNo, AFrec.FormNo, 6).IsEmpty then Exit; //If no name on t4A - Exit

  s:= Space(indentMM) + '<T4ASlip>';
  WriteIt(F1, s);

  RecipBnString:= AllTrim(FetchElm(ARetNo, AFRec.FormNo, T4A_RECIP_BN)); //20260120 Igor
  SinString:= LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4A_SIN), 9);
  if (SinString = '') or (LeftStr(SinString, 1) = 'D') then SinString:= '000000000';

  if not SinString.Equals('000000000') then //20260120 Igor
  begin
    s:= Space(indentMMM) + '<RCPNT_NM>';
    WriteIt(F1, s);

    LastNm:= ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4A_LastName), 20); //20260120 Igor
    s:= Space(indentMMMM) + '<snm>' + LastNm + '</snm>'; //required
    WriteIt(F1, s);

    // replace special characters
    info:= ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4A_FirstName), 12);
    if not info.IsEmpty then
    begin
      s:= Space(indentMMMM) + '<gvn_nm>' + info + '</gvn_nm>';
      WriteIt(F1, s);
    end;

    info:= ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, 8), 1); //20260120 Igor
    if not info.IsEmpty then
    begin
      s:= Space(indentMMMM) + '<init>' + info + '</init>';
      WriteIt(F1, s);
    end;

    s:= Space(indentMMM) + '</RCPNT_NM>';
    WriteIt(F1, s);

    s:= Space(indentMMM) + '<sin>' + SinString + '</sin>';
    WriteIt(F1, s);

    s:= Space(indentMMM) + '<rcpnt_bn>' + '000000000RP0000' + '</rcpnt_bn>';    // if no business # store zeros
    WriteIt(F1, s);
  end else
  if not RecipBnString.IsEmpty then //20260120 Igor
  begin
    s:= Space(indentMMM) + '<rcpnt_bn>' + RecipBnString + '</rcpnt_bn>';
    WriteIt(F1, s);

    s:= Space(indentMMM) + '<sin>' + '000000000' + '</sin>';  //if no SIN store zeros
    WriteIt(F1, s);

    s:= Space(indentMMM) + '<RCPNT_CORP_NM>';
    WriteIt(F1, s);

    CorpLastNm:= ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4A_LastName), 30); //20260120 Igor
    if not CorpLastNm.IsEmpty then
    begin
      s:= Space(indentMMMM) + '<l1_nm>' + CorpLastNm + '</l1_nm>'; //required
      WriteIt(F1, s);
    end;

    info:= ReplaceReservedXMLCharactersAndTruncate(midstr(FetchElm(ARetNo, AFRec.FormNo, T4A_LastName), 31, 30), 30); //20260120 Igor
    if not info.IsEmpty then
    begin
      s:= Space(indentMMMM) + '<l2_nm>' + info + '</l2_nm>';
      WriteIt(F1, s);
    end;

    s:= Space(indentMMM) + '</RCPNT_CORP_NM>';
    WriteIt(F1, s);
  end;

  if not LeftStr(LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4A_Street), 30), 30).IsEmpty or
     not MidStr(FetchElm(ARetNo, AFRec.FormNo, T4A_Street), 31, 30).IsEmpty or
     not LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4A_City), 28).IsEmpty or
     not LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4A_Prov), 2).IsEmpty or
     not LeftStr(FetchElm(ARetNo, AFRec.FormNo, 13), 3).IsEmpty or //20260120 Igor
     not LeftStr(FixPostal(FetchElm(ARetNo, AFRec.FormNo, T4A_Postal)), 10).IsEmpty then //20260120 Igor
  begin
    s:= Space(indentMMM) + '<RCPNT_ADDR>';
    WriteIt(F1, s);

    info:= ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4A_Street), 30);
    if not info.IsEmpty then
    begin
      s := Space(indentMMMM) + '<addr_l1_txt>' + info + '</addr_l1_txt>';
      WriteIt(F1, s);
    end;

    info:= MidStr(FetchElm(ARetNo, AFRec.FormNo, T4A_Street), 31, 30);
    info:= ReplaceReservedXMLCharactersAndTruncate(info, 30);
    if not info.IsEmpty then
    begin
      s:= Space(indentMMMM) + '<addr_l2_txt>' + info + '</addr_l2_txt>';
      WriteIt(F1, s);
    end;

    info:= ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T4A_City), 28);
    if not info.IsEmpty then
    begin
      s:= Space(indentMMMM) + '<cty_nm>' + info + '</cty_nm>';
      WriteIt(F1, s);
    end;

    info:= UpperCase(LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4A_Prov), 2));
    lCountryCode:= UpperCase(LeftStr(FetchElm(ARetNo, AFRec.FormNo, 13), 3)); //20260120 Igor
    if lCountryCode.IsEmpty then lCountryCode:= 'CAN'; //20260120 Igor
    if not info.IsEmpty then
    begin
      if lCountryCode.Equals('CAN') or lCountryCode.Equals('USA') then //20260120 Igor
        s:= Space(indentMMMM) + '<prov_cd>' + info + '</prov_cd>'
      else
        s:= Space(indentMMMM) + '<prov_cd>ZZ</prov_cd>'; //20260120 Igor

      WriteIt(F1, s);
    end;

    //20260120 Igor >>>
    if not lCountryCode.IsEmpty then
    begin
      s:= Space(indentMMMM) + '<cntry_cd>' + lCountryCode + '</cntry_cd>';
      WriteIt(F1, s);
    end;
    //20260120 Igor <<<

    info:= LeftStr(FixPostal(FetchElm(ARetNo, AFRec.FormNo, T4A_Postal)), 10);
    if not info.IsEmpty then
    begin
      s:= Space(indentMMMM) + '<pstl_cd>' + info + '</pstl_cd>';
      WriteIt(F1, s);
    end;

    s:= Space(indentMMM) + '</RCPNT_ADDR>';
    WriteIt(F1, s);
  end;
  {TODO : check T4A_PensionNo}
  {info := FetchElm(ARetNo, AFRec.FormNo, T4A_PensionNo);
  if info <> '' then
  begin
    s := Space(indentMMM) + '<rcpnt_nbr>' + info + '</rcpnt_nbr>';
    WriteIt(F1, s);
  end;}

  //required
  s:= Space(indentMMM) + '<bn>' + leftstr(FetchElm(ARetNo, 'EMPL', EMPL_ACCOUNTT4A), 15) + '</bn>';
  WriteIt(F1, s);

  (* 20260107CZ
  //20260120 Igor >>>
  //required if box16 is not empty
  if not FetchElm(ARetNo, AFRec.FormNo, T4A_BOX16).IsEmpty then
  begin
    s:= Space(indentMMM) + '<payr_dntl_ben_rpt_cd>' + FetchElm(ARetNo, AFRec.FormNo, 45) + '</payr_dntl_ben_rpt_cd>';
    WriteIt(F1, s);
  end;
  *)

  //TODO: Box 036
  //info:= ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, {???}), 28);
  //if not info.IsEmpty then
  //begin
    //s:= Space(indentMMM) + '<ppln_dpsp_rgst_nbr></ppln_dpsp_rgst_nbr>'; //Plan or DPSP registration number. - up to 7 numeric. - T4A slip, code 036. - enter the registration number issued by the CRA for the plan where the most amount of pension adjustment was reported
    //WriteIt(F1, s);
  //end;
  //20260120 Igor <<<

  //required
  s:= Space(indentMMM) + '<rpt_tcd>' + DataTypeCode + '</rpt_tcd>';
  WriteIt(F1, s);

  //20250213 Igor >>>
  LT4AATM:= '';

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box16)) <> 0 then
  begin
    s := Space(indentMMMM) + '<pens_spran_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box16))) + '</pens_spran_amt>';
    LT4AATM := ConcatStr(LT4AATM, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box18)) <> 0 then
  begin
    s := Space(indentMMMM) + '<lsp_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box18))) + '</lsp_amt>';
    LT4AATM := ConcatStr(LT4AATM, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box20)) <> 0 then
  begin
    s := Space(indentMMMM) + '<self_empl_cmsn_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box20))) + '</self_empl_cmsn_amt>';
    LT4AATM := ConcatStr(LT4AATM, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box22)) <> 0 then
  begin
    s := Space(indentMMMM) + '<itx_ddct_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box22))) + '</itx_ddct_amt>';
    LT4AATM := ConcatStr(LT4AATM, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box24)) <> 0 then
  begin
    s := Space(indentMMMM) + '<annty_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box24))) + '</annty_amt>';
    LT4AATM := ConcatStr(LT4AATM, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box48)) <> 0 then
  begin
    s := Space(indentMMMM) + '<fee_or_oth_srvc_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T4A_Box48))) + '</fee_or_oth_srvc_amt>';
    LT4AATM := ConcatStr(LT4AATM, s);
  end;

  if not LT4AATM.IsEmpty then
  begin
    s := Space(indentMMM) + '<T4A_AMT>';
    WriteIt(F1, s);

    WriteIt(F1, LT4AATM);

    s := Space(indentMMM) + '</T4A_AMT>';
    WriteIt(F1, s);
  end;
  //20250213 Igor <<<


 // Now al the OTH Info amounts  //not fixed boxes
  //20250207 Igor >>>
  if CheckCDAndAmt(T4A_FT_CD1, T4A_FT_AMT1) or CheckCDAndAmt(T4A_FT_CD2, T4A_FT_AMT2) or CheckCDAndAmt(T4A_FT_CD3, T4A_FT_AMT3) or
    CheckCDAndAmt(T4A_FT_CD4, T4A_FT_AMT4) or CheckCDAndAmt(T4A_FT_CD5, T4A_FT_AMT5) or CheckCDAndAmt(T4A_FT_CD6, T4A_FT_AMT6) or
    CheckCDAndAmt(T4A_FT_CD7, T4A_FT_AMT7) or CheckCDAndAmt(T4A_FT_CD8, T4A_FT_AMT8) or CheckCDAndAmt(T4A_FT_CD9, T4A_FT_AMT9) or
    CheckCDAndAmt(T4A_FT_CD10, T4A_FT_AMT10) or CheckCDAndAmt(T4A_FT_CD11, T4A_FT_AMT11) or CheckCDAndAmt(T4A_FT_CD12, T4A_FT_AMT12) then
  begin
  //20250207 Igor <<<
    s := Space(indentMMM) + '<OTH_INFO>';
    WriteIt(F1, s);
   //all oth info amounts here
    WriteCDAndAmt(T4A_FT_CD1, T4A_FT_AMT1);
    WriteCDAndAmt(T4A_FT_CD2, T4A_FT_AMT2);
    WriteCDAndAmt(T4A_FT_CD3, T4A_FT_AMT3);
    WriteCDAndAmt(T4A_FT_CD4, T4A_FT_AMT4);
    WriteCDAndAmt(T4A_FT_CD5, T4A_FT_AMT5);
    WriteCDAndAmt(T4A_FT_CD6, T4A_FT_AMT6);
    WriteCDAndAmt(T4A_FT_CD7, T4A_FT_AMT7);
    WriteCDAndAmt(T4A_FT_CD8, T4A_FT_AMT8);
    WriteCDAndAmt(T4A_FT_CD9, T4A_FT_AMT9);
    WriteCDAndAmt(T4A_FT_CD10, T4A_FT_AMT10);
    WriteCDAndAmt(T4A_FT_CD11, T4A_FT_AMT11);
    WriteCDAndAmt(T4A_FT_CD12, T4A_FT_AMT12);

    s := Space(indentMMM) + '</OTH_INFO>';
    WriteIt(F1, s);
  end; //20250207 Igor

  //20260120 Igor >>>
  if UpperCase(LeftStr(FetchElm(ARetNo, AFRec.FormNo, T4A_Prov), 2)).Equals('SK') then
  begin
    //s:= Space(indentMMM) + '<ADD_INFO>'; //Note: For Saskatchewan Government use only
    //WriteIt(F1, s);
    //s:= Space(indentMMMM) + '<spp_sps_cntrb_ind></spp_sps_cntrb_ind>'; //Saskatchewan Pension Plan spousal contributor indicator. - 1 numeric (0 for No or 1 for Yes)
    //WriteIt(F1, s);
    //s:= Space(indentMMMM) + '<spp_sps_cntrbr_sin></spp_sps_cntrbr_sin>'; //Saskatchewan Pension Plan spousal contributor social insurance number. - 9 numeric.
    //WriteIt(F1, s);
    //s:= Space(indentMMM) + '</ADD_INFO>';
    //WriteIt(F1, s);
  end;
  //20260120 Igor <<<

  s:= Space(indentMM) + '</T4ASlip>';
  WriteIt(F1, s);
end;
//20260120 Igor <<<

function GetTheT4ABoxNameTag(ACD: string; AAmt: Real): string;
begin
  if (ACD = '026') and (AAmt > 0) then
    Result := 'elg_rtir_amt'
  else
  if (ACD = '027') and (AAmt > 0) then
    Result := 'nelg_rtir_amt'
  else
  if (ACD = '028') and (AAmt > 0) then
    Result := 'oth_incamt'
  else
  if (ACD = '030') and (AAmt > 0) then
    Result := 'ptrng_aloc_amt'
  else
  if (ACD = '032') and (AAmt > 0) then
    Result := 'rpp_past_srvc_amt'
  else
  if (ACD = '034') and (AAmt > 0) then
    Result := 'padj_amt'
  else   //202010107
  if (ACD = '037') and (AAmt > 0) then
    Result := 'alda_amt'
  else
  if (ACD = '040') and (AAmt > 0) then
    Result := 'resp_aip_amt'
  else
  if (ACD = '042') and (AAmt > 0) then
    Result := 'resp_educt_ast_amt'
  else
  if (ACD = '046') and (AAmt > 0) then
    Result := 'chrty_dons_amt'
  else
  if (ACD = '102') and (AAmt > 0) then
    Result := 'nr_lsp_trnsf_amt'
  else
  if (ACD = '104') and (AAmt > 0) then
    Result := 'rsch_grnt_amt'
  else
  if (ACD = '105') and (AAmt > 0) then
    Result := 'brsy_amt'
  else
  if (ACD = '106') and (AAmt > 0) then
    Result := 'dth_ben_amt'
  else
  if (ACD = '107') and (AAmt > 0) then
    Result := 'wag_ls_incamt'
  else
  if (ACD = '108') and (AAmt > 0) then
    Result := 'lsp_rpp_nelg_amt'
  else
  if (ACD = '109') and (AAmt > 0) then
    Result := 'nrgst_ppln_amt'
  else
  if (ACD = '110') and (AAmt > 0) then
    Result := 'pr_71_acr_lsp_amt'
  else
  if (ACD = '111') and (AAmt > 0) then
    Result := 'inc_avg_annty_amt'
  else
  if (ACD = '115') and (AAmt > 0) then
    Result := 'dpsp_ins_pay_amt'
  else
  if (ACD = '116') and (AAmt > 0) then
    Result := 'med_trvl_amt'
  else
  if (ACD = '117') and (AAmt > 0) then
    Result := 'loan_ben_amt'
  else
  if (ACD = '118') and (AAmt > 0) then
    Result := 'med_prem_ben_amt'
  else
  if (ACD = '119') and (AAmt > 0) then
    Result := 'grp_trm_life_amt'
  else
  if (ACD = '122') and (AAmt > 0) then
    Result := 'resp_aip_oth_amt'
  else
  if (ACD = '123') and (AAmt > 0) then
    Result := 'ins_rvk_dpsp_amt'
  else
  if (ACD = '124') and (AAmt > 0) then
    Result := 'brd_wrk_site_amt'
  else
  if (ACD = '125') and (AAmt > 0) then
    Result := 'dsblt_ben_amt'
  else
  if (ACD = '126') and (AAmt > 0) then
    Result := 'pr_90_rpp_amt'
  else
  if (ACD = '127') and (AAmt > 0) then
    Result := 'vtrn_ben_amt'
  else
  if (ACD = '129') and (AAmt > 0) then
    Result := 'tx_dfr_ptrng_dvamt'
  else
  if (ACD = '130') and (AAmt > 0) then
    Result := 'atp_inctv_grnt_amt'
  else
  if (ACD = '131') and (AAmt > 0) then
    Result := 'rdsp_amt'
  else
  if (ACD = '132') and (AAmt > 0) then
    Result := 'wag_ptct_pgm_amt'
  else
  if (ACD = '133') and (AAmt > 0) then
    Result := 'var_pens_ben_amt'
  else
  if (ACD = '134') and (AAmt > 0) then
    Result := 'tfsa_tax_amt'
  else
  if (ACD = '135') and (AAmt > 0) then
    Result := 'rcpnt_pay_prem_phsp_amt'
  else
  if (ACD = '136') and (AAmt > 0) then
    Result := 'pmmc_isg_amt'
  else
  if (ACD = '142') and (AAmt > 0) then
    Result := 'indn_elg_rtir_amt'
  else
  if (ACD = '143') and (AAmt > 0) then
    Result := 'indn_nelg_rtir_amt'
  else
  if (ACD = '144') and (AAmt > 0) then
    Result := 'indn_oth_incamt'
  else
  if (ACD = '146') and (AAmt > 0) then
    Result := 'indn_xmpt_pens_amt'
  else
  if (ACD = '148') and (AAmt > 0) then
    Result := 'indn_xmpt_lsp_amt'
  else
  if (ACD = '150') and (AAmt > 0) then
    Result := 'lbr_adj_ben_aprpt_act_amt'
  else
  if (ACD = '152') and (AAmt > 0) then
    Result := 'subp_qlf_amt'
  else
  if (ACD = '154') and (AAmt > 0) then
    Result := 'csh_awrd_pze_payr_amt'
  else
  if (ACD = '156') and (AAmt > 0) then
    Result := 'bkcy_sttl_amt'
  else
  if (ACD = '158') and (AAmt > 0) then
    Result := 'lsp_nelg_trnsf_amt'
  else
  if (ACD = '162') and (AAmt > 0) then
    Result := 'ncntrbr_prr_pspp_cnamt'
  else
  if (ACD = '180') and (AAmt > 0) then
    Result := 'lsp_dpsp_nelg_amt'
  else
  if (ACD = '190') and (AAmt > 0) then
    Result := 'lsp_nrgst_pens_amt'
  else
  if (ACD = '194') and (AAmt > 0) then
    Result := 'prpp_tx_inc_pamt'
  else
  if (ACD = '195') and (AAmt > 0) then
    Result := 'prpp_txmpt_inc_pamt'
  //20210107 new codes added
  else
  if (ACD = '200') and (AAmt > 0) then
    Result := 'prov_trty_emrg_ben_amt'

  else
    Result := '';
end;

procedure PrepareT4ASumInfo(ARetNo: Integer; Var F1: TextFile;
  DataTypeCode: String);
const
  Format1 = '########0.00';
var
  T4ASum: TT4ASum;
  s: string;
  info: string;
  infoN: Real;
  LT4ATAMT: string; //20250213 Igor
begin

  SummarizeT4ASlips(ARetNo, T4ASum);

  s := Space(indentMM) + '<T4ASummary>';
  WriteIt(F1, s);

 //required
  s := Space(indentMMM) + '<bn>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_ACCOUNTT4A), 15) + '</bn>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<PAYR_NM>';
  WriteIt(F1, s);

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_Empl_Name), 30);
  s := Space(indentMMMM) + '<l1_nm>' + info + '</l1_nm>';
  WriteIt(F1, s);

  info := MidStr(FetchElm(ARetNo, 'EMPL', EMPL_Empl_Name), 31, 30);
  info := ReplaceReservedXMLCharactersAndTruncate(info,30);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<l2_nm>' + info + '</l2_nm>';
    WriteIt(F1, s);
  end;

  s := Space(indentMMM) + '</PAYR_NM>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<PAYR_ADDR>';
  WriteIt(F1, s);
  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_Street), 30);
  if info <> '' then
  begin
    s := Space(indentMMMM) + '<addr_l1_txt>' + info + '</addr_l1_txt>';
    WriteIt(F1, s);
  end;

  info := MidStr(FetchElm(ARetNo, 'EMPL', EMPL_Street), 31, 30);
  info := ReplaceReservedXMLCharactersAndTruncate(info,30);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<addr_l2_txt>' + info + '</addr_l2_txt>';
    WriteIt(F1, s);
  end;

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_City), 28);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<cty_nm>' + info + '</cty_nm>';
    WriteIt(F1, s);
  end;

 //required
  info := UpperCase(LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Prov), 2));
  if info > '' then
  begin
    s := Space(indentMMMM) + '<prov_cd>' + info + '</prov_cd>';
    WriteIt(F1, s);
  end;

  info := LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Country), 3);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<cntry_cd>' + info + '</cntry_cd>';
    WriteIt(F1, s);
  end;

  info := LeftStr(FixPostal(FetchElm(ARetNo, 'EMPL', EMPL_Postal)), 10);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<pstl_cd>' + info + '</pstl_cd>';
    WriteIt(F1, s);
  end;

  s := Space(indentMMM) + '</PAYR_ADDR>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<CNTC>';
  WriteIt(F1, s);

  //20180106
  s := Space(indentMMMM) + '<cntc_nm>' + LeftStr(FetchElm(ARetNo,'EMPL',7)+' '+FetchElm(ARetNo,'EMPL',8),22) + '</cntc_nm>';
  //s := Space(indentMMMM) + '<cntc_nm>' + LeftStr(AppT4T5_2026.Prp_TName, 22) + '</cntc_nm>';
  WriteIt(F1, s);

 //[6] - first 3 numbers
  s := Space(indentMMMM) + '<cntc_area_cd>' + LeftStr(FetchElm(ARetNo,'EMPL',9),3)+'</cntc_area_cd>';
  WriteIt(F1, s);

 //[6] - last 7 numbers 3 then '-' then last 4
  s := Space(indentMMMM) + '<cntc_phn_nbr>' + LeftStr(FetchElm(ARetNo,'EMPL',10),8) + '</cntc_phn_nbr>';
  WriteIt(F1, s);

  If FetchElm(ARetNo,'EMPL',41)>'' then
  Begin
   s := Space(indentMMMM) + '<cntc_extn_nbr>' + LeftStr(FetchElm(ARetNo,'EMPL',41),5) + '</cntc_extn_nbr>';
   WriteIt(F1, s);
  End;

  s := Space(indentMMM) + '</CNTC>';
  WriteIt(F1, s);

 //required
  s := Space(indentMMMM) + '<tx_yr>' + AppYear + '</tx_yr>';
  WriteIt(F1, s);

  //required
  s := Space(indentMMMM) + '<slp_cnt>' + T4ASum.NumSlips + '</slp_cnt>'; //jz 20190502
  WriteIt(F1, s);

  if (FetchElm(ARetNo, 'EMPL', EMPL_RppNum1) > '') or
     (FetchElm(ARetNo, 'EMPL', EMPL_RppNum2) > '') or
     (FetchElm(ARetNo, 'EMPL', EMPL_RppNum3) > '') then
  begin
    s := Space(indentMMM) + '<RPP_NBR>';
    WriteIt(F1, s);

    info := FetchElm(ARetNo, 'EMPL', EMPL_RppNum1);
    if info > '' then
    begin
      s := Space(indentMMMM) + '<rpp_rgst_1_nbr>' + info + '</rpp_rgst_1_nbr>';
      WriteIt(F1, s);
    end;

    info := FetchElm(ARetNo, 'EMPL', EMPL_RppNum2);
    if info > '' then
    begin
      s := Space(indentMMMM) + '<rpp_rgst_2_nbr>' + info + '</rpp_rgst_2_nbr>';
      WriteIt(F1, s);
    end;

    info := FetchElm(ARetNo, 'EMPL', EMPL_RppNum3);
    if info > '' then
    begin
      s := Space(indentMMMM) + '<rpp_rgst_3_nbr>' + info + '</rpp_rgst_3_nbr>';
      WriteIt(F1, s);
    end;

    s := Space(indentMMM) + '</RPP_NBR>';
    WriteIt(F1, s);
  end;

  if (FetchElm(ARetNo, 'EMPL', EMPL_PropSin1) > '') or
     (FetchElm(ARetNo, 'EMPL', EMPL_PropSin2) > '') then
  begin
    s := Space(indentMMM) + '<PPRTR_SIN>';
    WriteIt(F1, s);

    info := FetchElm(ARetNo, 'EMPL', EMPL_PropSin1);
    if info > '' then
    begin
      s := Space(indentMMMM) + '<pprtr_1_sin>' + info + '</pprtr_1_sin>';
      WriteIt(F1, s);
    end;

    info := FetchElm(ARetNo, 'EMPL', EMPL_PropSin2);
    if info > '' then
    begin
      s := Space(indentMMMM) + '<pprtr_2_sin>' + info + '</pprtr_2_sin>';
      WriteIt(F1, s);
    end;

    s := Space(indentMMM) + '</PPRTR_SIN>';
    WriteIt(F1, s);
  end;

  s := Space(indentMMM) + '<rpt_tcd>' + DataTypeCode + '</rpt_tcd>';
  WriteIt(F1, s);

  //20250213 Igor >>>
  LT4ATAMT := '';

  infoN := T4ASum.TotBox16;
  if infoN <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_pens_spran_amt>' + FormatFloat(Format1, infoN) + '</tot_pens_spran_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  infoN := T4ASum.TotBox18;
  if infoN <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_lsp_amt>' + FormatFloat(Format1, infoN) + '</tot_lsp_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  infoN := T4ASum.TotBox20;
  if infoN <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_self_cmsn_amt>' + FormatFloat(Format1, infoN) + '</tot_self_cmsn_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  infoN := T4ASum.TotBox30;
  if infoN <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_ptrng_aloc_amt>' + FormatFloat(Format1, infoN) + '</tot_ptrng_aloc_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  if T4ASum.TotBox32 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_past_srvc_amt>' + FormatFloat(Format1, T4ASum.TotBox32) + '</tot_past_srvc_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  if T4ASum.TotBox24 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_annty_incamt>' + FormatFloat(Format1, T4ASum.TotBox24) + '</tot_annty_incamt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  if T4ASum.TotBox28 <> 0 then
  begin
    s := Space(indentMMMM) + '<totr_incamt>' + FormatFloat(Format1, T4ASum.TotBox28) + '</totr_incamt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  if T4ASum.TotBox34 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_padj_amt>' + FormatFloat(Format1, T4ASum.TotBox34) + '</tot_padj_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  if T4ASum.TotBox40 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_resp_aip_amt>' + FormatFloat(Format1, T4ASum.TotBox40) + '</tot_resp_aip_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  if T4ASum.TotBox42 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_resp_amt>' + FormatFloat(Format1, T4ASum.TotBox42) + '</tot_resp_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  if T4ASum.TotBox48 <> 0 then
  begin
    s := Space(indentMMMM) + '<rpt_tot_fee_srvc_amt>' + FormatFloat(Format1, T4ASum.TotBox48) + '</rpt_tot_fee_srvc_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  if T4ASum.TotBox101 <> 0 then
  begin
    s := Space(indentMMMM) + '<rpt_tot_oth_info_amt>' + FormatFloat(Format1, T4ASum.TotBox101) + '</rpt_tot_oth_info_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  //20230130
  if T4ASum.TotBox22 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_itx_dedn_amt>' + FormatFloat(Format1, T4ASum.TotBox22) + '</tot_itx_dedn_amt>'; //20230201
    //s := Space(indentMMMM) + '<tot_itx_ddct_amt>' + FormatFloat(Format1, T4ASum.TotBox22) + '</tot_itx_ddct_amt>';
    LT4ATAMT := ConcatStr(LT4ATAMT, s);
  end;

  if not LT4ATAMT.IsEmpty then
  begin
    s := Space(indentMMM) + '<T4A_TAMT>';
    WriteIt(F1, s);

    WriteIt(F1, LT4ATAMT);

    s := Space(indentMMM) + '</T4A_TAMT>';
    WriteIt(F1, s);
  end;

  s := Space(indentMM) + '</T4ASummary>';
  WriteIt(F1, s);
end;

{$ENDREGION}

{$REGION 'T5'}
procedure PrepareT5XML(ARetNo: Integer; Var F1: TextFile; DataTypeCode: String);
const
  Format1 = '########0.00';
var
  i: Integer;
  s: string;
  InstForms: TFRecArray;
begin
  s := Space(indent) + '<Return>';
  WriteIt(F1, s);

  s := Space(indentM) + '<T5>';
  WriteIt(F1, s);
  InstForms := FList.GetAllInstForms('T5'); //20180104
 // InstForms := FList.GetAllInstForms('T4A');
 {loop for slips}
  for I := Low(InstForms) to High(InstForms) do
    PrepareT5Info(ARetNo, InstForms[I], F1, DataTypeCode);
  PrepareT5SumInfo(ARetNo, F1, DataTypeCode);

  s := Space(indentM) + '</T5>';
  WriteIt(F1, s);
  s := Space(indent) + '</Return>';
  WriteIt(F1, s);

  s := '</Submission>';
  WriteIt(F1, s);
end; //end PrepareT5XML

//20260115 Igor >>>
procedure PrepareT5Info(ARetNo: Integer; AFRec: TFRec; var F1: TextFile; DataTypeCode: string);
const
  Format1 = '########0.00';

var
  s, sinString: string;
  info: string;
begin
  if FetchElm(ARetNo, AFrec.FormNo, T5_LASTNAME_FIRSTNAME).IsEmpty then exit;  //name missing

  s:= Space(indentMM) + '<T5Slip>';
  WriteIt(F1, s);
  //20260115 Igor >>>
  //required
  {TODO : check T5_LastName}
  info:= FetchElmFNo(ARetNo, AFRec.FormNo, T5_LASTNAME_FIRSTNAME);  //Name
  if (FetchElm(ARetNo, AFRec.FormNo, T5_RecType) < '3') then
  begin
    s:= Space(indentMMM) + '<RCPNT_NM>';
    WriteIt(F1, s);
    s:= Space(indentMMMM) + '<snm>' + ReplaceReservedXMLCharactersAndTruncate({FetchElm(ARetNo, 'EMPL', EMPL_LASTNAME)}info, 20) + '</snm>'; //20260226 Igor // Individual Last NM limited to 20 chars
    WriteIt(F1, s);
    //20260226 Igor >>>
    {if not FetchElm(ARetNo, 'EMPL', EMPL_FIRSTNAME).IsEmpty then
    begin
      s:= Space(indentMMMM) + '<gvn_nm>' + ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_FIRSTNAME), 12) + '</gvn_nm>'; //20260115 Igor //Individual recipient first name. - first 12 letters of the recipient's first given name
      WriteIt(F1, s);
    end;}
    //20260226 Igor <<<
    //s:= Space(indentMMMM) + '<init>' + ReplaceReservedXMLCharactersAndTruncate(info, 1) + '</init>'; //20260115 Igor // Individual recipient initial. -1 alphanumeric
    //WriteIt(F1, s); //20260115 Igor

    s := Space(indentMMM) + '</RCPNT_NM>';
    WriteIt(F1, s);

    //20260120 Igor >>>
    {s:= Space(indentMMM) + '<SEC_RCPNT_NM>';
    WriteIt(F1, s);
    s:= Space(indentMMMM) + '<sec_snm></sec_snm>'; //20260115 Igor //Second individual recipient surname. - Required, up to 20 alphanumeric
    WriteIt(F1, s);
    //s:= Space(indentMMMM) + '<sec_gvn_nm></sec_gvn_nm>'; //20260115 Igor //Second individual recipient first name. - up to 12 alphanumeric
    //WriteIt(F1, s); //20260115 Igor
    //s:= Space(indentMMMM) + '<sec_init></sec_init>'; //20260115 Igor //Second individual recipient initial. - 1 alphanumeric
    //WriteIt(F1, s); //20260115 Igor
    s:= Space(indentMMM) + '</SEC_RCPNT_NM>';
    WriteIt(F1, s); }
  end else
  begin
    s:= Space(indentMMM) + '<BUS_NM>';
    WriteIt(F1, s);
    s:= Space(indentMMMM) + '<l1_nm>' + ReplaceReservedXMLCharactersAndTruncate(FetchElmFNo(ARetNo, AFRec.FormNo, 19), 30) + '</l1_nm>';
    WriteIt(F1, s);
    if Length(FetchElmFNo(ARetNo, AFRec.FormNo, 19)) > 30 then
    begin
      s:= Space(indentMMMM) + '<l2_nm>' + ReplaceReservedXMLCharactersAndTruncate(Copy(FetchElmFNo(ARetNo, AFRec.FormNo, 19), 31, 30), 30) + '</l2_nm>';
      WriteIt(F1, s);
    end;
    s:= Space(indentMMM) + '</BUS_NM>';
    WriteIt(F1, s);
  end;
  //20260120 Igor <<<

  SinString:= FetchElm(ARetNo, AFRec.FormNo, T5_SIN);

  if (FetchElm(ARetNo, AFRec.FormNo, T5_RecType) < '3') then //1 or 2. SIN. Box 22
  begin
    s:= Space(indentMMM) + '<sin>' + SinString + '</sin>';
    WriteIt(F1, s);
    s:= Space(indentMMM) + '<slp_rcpnt_bn>' + '000000000RC0000' + '</slp_rcpnt_bn>';  //jz 20200226
    WriteIt(F1, s);
    s:= Space(indentMMM) + '<rcpnt_tr_acct_nbr>T00000000</rcpnt_tr_acct_nbr>';
    WriteIt(F1, s);
  end else
  if (FetchElm(ARetNo, AFRec.FormNo, T5_RecType) = '3') then // BN. Box 22
  begin
   s:= Space(indentMMM) + '<sin>' + '000000000' + '</sin>';
   WriteIt(F1, s);
   s:= Space(indentMMM) + '<slp_rcpnt_bn>' + SinString + '</slp_rcpnt_bn>';
   WriteIt(F1, s);
    s:= Space(indentMMM) + '<rcpnt_tr_acct_nbr>T00000000</rcpnt_tr_acct_nbr>';
    WriteIt(F1, s);
  end else
  if (FetchElm(ARetNo, AFRec.FormNo, T5_RecType) = '4') and (uppercase(leftstr(SinString, 1)) = 'T') then
  begin
    s:= Space(indentMMM) + '<sin>' + '000000000' + '</sin>';
    WriteIt(F1, s);
    s:= Space(indentMMM) + '<slp_rcpnt_bn>' + '000000000RC0000' + '</slp_rcpnt_bn>';  //jz 20200226
    WriteIt(F1, s);
    s:= Space(indentMMM) + '<rcpnt_tr_acct_nbr>' + SinString + '</rcpnt_tr_acct_nbr>';
    WriteIt(F1, s);
  end;

  s:= Space(indentMMM) + '<RCPNT_ADDR>';
  WriteIt(F1, s);

  info:= ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T5_Street), 30);
  if info <> '' then
  begin
    s:= Space(indentMMMM) + '<addr_l1_txt>' + info + '</addr_l1_txt>';
    WriteIt(F1, s);
  end;

  info:= ReplaceReservedXMLCharactersAndTruncate(MidStr(FetchElm(ARetNo, AFRec.FormNo, T5_Street), 31, 30), 30);
  if info <> '' then
  begin
    s:= Space(indentMMMM) + '<addr_l2_txt>' + info + '</addr_l2_txt>';
    WriteIt(F1, s);
  end;

  info:= ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, AFRec.FormNo, T5_City), 28);
  if info <> '' then
  begin
    s:= Space(indentMMMM) + '<cty_nm>' + info + '</cty_nm>';
    WriteIt(F1, s);
  end;

  info:= UpperCase(LeftStr(FetchElmFNo(ARetNo, AFRec.FormNo, 22), 2));//LeftStr(FetchElm(ARetNo, AFRec.FormNo, T5_Prov), 2);
  if info <> '' then
  begin
    s:= Space(indentMMMM) + '<prov_cd>' + info + '</prov_cd>';
    WriteIt(F1, s);
  end;

  info:= FetchElmFNo(ARetNo, AFRec.FormNo, 32); //LeftStr(FetchElm(ARetNo, AFRec.FormNo, T5_Country), 3);
  if info <> '' then
  begin
    s:= Space(indentMMMM) + '<cntry_cd>' + info + '</cntry_cd>';
    WriteIt(F1, s);
  end;

  info:= FetchElmFNo(ARetNo, AFRec.FormNo, 23); //LeftStr(FixPostal(FetchElm(ARetNo, AFRec.FormNo, T5_Postal)), 10);
  if info <> '' then
  begin
    s:= Space(indentMMMM) + '<pstl_cd>' + info + '</pstl_cd>';
    WriteIt(F1, s);
  end;

  s:= Space(indentMMM) + '</RCPNT_ADDR>';
  WriteIt(F1, s);
  //20260115 Igor <<<

  //required
  s := Space(indentMMM) + '<bn>'   + FetchElm(ARetNo, 'EMPL', EMPL_T5Filer) + '</bn>';  //20180106
  // s := Space(indentMMM) + '<bn>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_T5Filer), 9) + 'RZ0001' + '</bn>';  //20160118
  WriteIt(F1, s);

  //required
  info := LeftStr(FetchElm(ARetNo, AFRec.FormNo, T5_Transit), 8);
  if info = '' then info := '00000000';
  s := Space(indentMMM) + '<rcpnt_fi_br_nbr>' + info + '</rcpnt_fi_br_nbr>';
  WriteIt(F1, s);

 //required
  info := LeftStr(FetchElm(ARetNo, AFRec.FormNo, T5_RecAccount), 12);
  if info = '' then info := '000000000000';
  s := Space(indentMMM) + '<rcpnt_fi_acct_nbr>' + info + '</rcpnt_fi_acct_nbr>';
  WriteIt(F1, s);

  info := LeftStr(FetchElm(ARetNo, AFRec.FormNo, T5_RECCODE), 1);
  if info = '0' then info := 'O'
  else if info = '1' then info := 'A';
  s := Space(indentMMM) + '<rpt_tcd>' + info + '</rpt_tcd>';
  WriteIt(F1, s);

 //required T5
  info := FetchElm(ARetNo, AFRec.FormNo, T5_RecType);
  if info = '9' then info := '4';
  s := Space(indentMMM) + '<rcpnt_tcd>' + info + '</rcpnt_tcd>';
  WriteIt(F1, s);

  info := FetchElm(ARetNo, AFRec.FormNo, T5_Currency);
  if info = '' then
  begin
    info := 'CAD';
    s := Space(indentMMM) + '<fgn_crcy_ind>' + info + '</fgn_crcy_ind>';
    WriteIt(F1, s);
  end
  else
  begin
    s := Space(indentMMM) + '<fgn_crcy_ind>' + FetchElm(ARetNo, AFRec.FormNo, T5_Currency) + '</fgn_crcy_ind>';
    WriteIt(F1, s);
  end;

  s := Space(indentMMM) + '<T5_AMT>';
  WriteIt(F1, s);

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box10)) <> 0 then
  begin
    s := Space(indentMMMM) + '<actl_dvnd_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box10))) + '</actl_dvnd_amt>';
    WriteIt(F1, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box11)) <> 0 then
  begin
    s := Space(indentMMMM) + '<tx_dvnd_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box11))) + '</tx_dvnd_amt>';
    WriteIt(F1, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box12)) <> 0 then
  begin
    s := Space(indentMMMM) + '<dvnd_tx_cr_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box12))) + '</dvnd_tx_cr_amt>';
    WriteIt(F1, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box13)) <> 0 then
  begin
    s := Space(indentMMMM) + '<cdn_int_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box13))) + '</cdn_int_amt>';
    WriteIt(F1, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box14)) <> 0 then
  begin
    s := Space(indentMMMM) + '<oth_cdn_incamt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box14))) + '</oth_cdn_incamt>';
    WriteIt(F1, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box15)) <> 0 then
  begin
    s := Space(indentMMMM) + '<fgn_incamt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box15))) + '</fgn_incamt>';
    WriteIt(F1, s);
  end;
  {TODO : check T5_Box16}
  {
  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box16)) <> 0 then
  begin
    s := Space(indentMMMM) + '<fgn_tx_pay_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box16))) + '</fgn_tx_pay_amt>';
    WriteIt(F1, s);
  end;}

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box17)) <> 0 then
  begin
    s := Space(indentMMMM) + '<cdn_royl_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box17))) + '</cdn_royl_amt>';
    WriteIt(F1, s);
  end;

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box18)) <> 0 then
  begin
    s := Space(indentMMMM) + '<cgain_dvnd_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box18))) + '</cgain_dvnd_amt>';
    WriteIt(F1, s);
  end;

  {TODO : check T5_Box19}
  {
  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box19)) <> 0 then
  begin
    s := Space(indentMMMM) + '<acr_annty_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box19))) + '</acr_annty_amt>';
    WriteIt(F1, s);
  end;}

  {TODO : check T5_Box20}
  {
  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box20)) <> 0 then
  begin
    s := Space(indentMMMM) + '<rsrc_alwnc_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box20))) + '</rsrc_alwnc_amt>';
    WriteIt(F1, s);
  end;}

  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box24)) <> 0 then
  begin
    s := Space(indentMMMM) + '<actl_elg_dvamt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box24))) + '</actl_elg_dvamt>';
    WriteIt(F1, s);
  end;
  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box25)) <> 0 then
  begin
    s := Space(indentMMMM) + '<tx_elg_dvnd_pamt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box25))) + '</tx_elg_dvnd_pamt>';
    WriteIt(F1, s);
  end;
  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box26)) <> 0 then
  begin
    s := Space(indentMMMM) + '<enhn_dvtc_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box26))) + '</enhn_dvtc_amt>';
    WriteIt(F1, s);
  end;

  {TODO : check T5_Box40}
  {
  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box40)) <> 0 then
  begin
    s := Space(indentMMMM) + '<cgain_dvnd_1_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box40))) + '</cgain_dvnd_1_amt>';
    WriteIt(F1, s);
  end;}

  {TODO : check T5_Box41}
  {
  if MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box41)) <> 0 then
  begin
    s := Space(indentMMMM) + '<cgain_dvnd_2_amt>' + FormatFloat(Format1, MyStrToFloat(FetchElm(ARetNo, AFRec.FormNo, T5_Box41))) + '</cgain_dvnd_2_amt>';
    WriteIt(F1, s);
  end;}

  //20260115 Igor >>>
  //s:= Space(indentMMMM) + '<lk_nt_acr_intamt></lk_nt_acr_intamt>'; //Equity Linked Notes Interest.- up to 11 numeric. - T5 slip box 30' +
  //WriteIt(F1, s);
  //s:= Space(indentMMMM) + '<cgain_dvnd_jan_to_jun_2024></cgain_dvnd_jan_to_jun_2024>'; //Capital gains dividends – 01/01/2024 to 06/24/2024. - Capital Gain 2024 Period One Dividend Amount. - up to 11 numeric. - T5 slip box 34
  //WriteIt(F1, s);
  //20260115 Igor <<<

  s:= Space(indentMMM) + '</T5_AMT>';
  WriteIt(F1, s);

  s:= Space(indentMM) + '</T5Slip>';
  WriteIt(F1, s);
end;

procedure PrepareT5SumInfo(ARetNo: Integer; var F1: TextFile; DataTypeCode: string);
const
  Format1 = '########0.00';
var
  s, info: string;
  T5Sum: TT5Sum;
begin
  SummarizeT5Slips(ARetNo, T5Sum);

  s := Space(indentMM) + '<T5Summary>';
  WriteIt(F1, s);

 //required
  s := Space(indentMMM) + '<bn>' +  FetchElm(ARetNo, 'EMPL', EMPL_T5Filer) + '</bn>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<FILR_NM>';
  WriteIt(F1, s);

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_Empl_Name), 30);
  s := Space(indentMMMM) + '<l1_nm>' + info + '</l1_nm>'; //required
  WriteIt(F1, s);

  if Length(FetchElm(ARetNo, 'EMPL', EMPL_Empl_Name)) > 30 then
  begin
    info := ReplaceReservedXMLCharactersAndTruncate(MidStr(FetchElm(ARetNo, 'EMPL', EMPL_Empl_Name), 31, 30),30);
    s := Space(indentMMMM) + '<l2_nm>' + info + '</l2_nm>';
    WriteIt(F1, s);
  end;

  s := Space(indentMMM) + '</FILR_NM>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<FILR_ADDR>';
  WriteIt(F1, s);

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_Street), 30);
  if info > '' then //20260120 Igor
  begin
    s := Space(indentMMMM) + '<addr_l1_txt>' + info + '</addr_l1_txt>'; //required
    WriteIt(F1, s);
  end;

  info := ReplaceReservedXMLCharactersAndTruncate(MidStr(FetchElm(ARetNo, 'EMPL', EMPL_Street), 31, 30),30);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<addr_l2_txt>' + info + '</addr_l2_txt>';
    WriteIt(F1, s);
  end;

  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_City), 28);
  if info > '' then
  begin
    s := Space(indentMMMM) + '<cty_nm>' + info + '</cty_nm>';
    WriteIt(F1, s);
  end;

  if Length(FetchElm(ARetNo, 'EMPL', EMPL_Prov)) > 0 then
  begin
    s := Space(indentMMMM) + '<prov_cd>' + UpperCase(LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Prov), 2)) + '</prov_cd>';
    WriteIt(F1, s);
  end;

  if Length(FetchElm(ARetNo, 'EMPL', EMPL_Country)) > 0 then
  begin
    s := Space(indentMMMM) + '<cntry_cd>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Country), 3) + '</cntry_cd>';
    WriteIt(F1, s);
  end;

 //required
  s := Space(indentMMMM) + '<pstl_cd>' + LeftStr(FixPostal(FetchElm(ARetNo, 'EMPL', EMPL_Postal)), 10) + '</pstl_cd>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '</FILR_ADDR>';
  WriteIt(F1, s);

  s := Space(indentMMM) + '<CNTC>';
  WriteIt(F1, s);

 //omit titles ie no Mr. Mrs. Dr. etc....
 //required
  info := ReplaceReservedXMLCharactersAndTruncate(FetchElm(ARetNo, 'EMPL', EMPL_FirstName) + ' ' + FetchElm(ARetNo, 'EMPL', EMPL_LastName), 22);
  s := Space(indentMMMM) + '<cntc_nm>' + info + '</cntc_nm>';
  WriteIt(F1, s);


 //required
  s := Space(indentMMMM) + '<cntc_area_cd>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_AreaCode), 3) + '</cntc_area_cd>';
  WriteIt(F1, s);

 //required
  s := Space(indentMMMM) + '<cntc_phn_nbr>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Telephone), 8) + '</cntc_phn_nbr>';
  WriteIt(F1, s);

  {TODO : check EMPL_Extension}
  {
  if FetchElm(ARetNo, 'EMPL', EMPL_Extension) > '' then
  begin
    s := Space(indentMMMM) + '<cntc_extn_nbr>' + LeftStr(FetchElm(ARetNo, 'EMPL', EMPL_Extension), 4) + '</cntc_extn_nbr>';
    WriteIt(F1, s);
  end;}

  s := Space(indentMMM) + '</CNTC>';
  WriteIt(F1, s);

  //20180106
  info := LeftStr(FetchElm(ARetNo, 'EMPL', 34),8);
  if info > '' then
  begin
    s := Space(indentMMM) + '<filr_fi_br_nbr>' + info + '</filr_fi_br_nbr>';
    WriteIt(F1, s);
  end
  else
  begin
    s := Space(indentMMM) + '<filr_fi_br_nbr>' + '00000000' + '</filr_fi_br_nbr>';
    WriteIt(F1, s)
  end;

 //required
  s := Space(indentMMM) + '<tx_yr>' + AppYear + '</tx_yr>';
  WriteIt(F1, s);

 //required
  s := Space(indentMMM) + '<slp_cnt>' + T5Sum.NumSlips + '</slp_cnt>'; //jz 20190502
  WriteIt(F1, s);

 //required
  s := Space(indentMMM) + '<rpt_tcd>' + DataTypeCode + '</rpt_tcd>';
  WriteIt(F1, s);

  //s:= Space(indentMMM) + '<fileramendmentnote></fileramendmentnote>'; //Filer amendment note. - use for report type A only. - up to 1309 alphanumeric
  //WriteIt(F1, s);

  s := Space(indentMMM) + '<T5_TAMT>';
  WriteIt(F1, s);

  if T5Sum.TotBox13 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_cdn_int_amt>' + FormatFloat(Format1, T5Sum.TotBox13) + '</tot_cdn_int_amt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox10 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_actl_dvnd_amt>' + FormatFloat(Format1, T5Sum.TotBox10) + '</tot_actl_dvnd_amt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox11 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_tx_dvnd_amt>' + FormatFloat(Format1, T5Sum.TotBox11) + '</tot_tx_dvnd_amt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox12 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_dvnd_tx_cr_amt>' + FormatFloat(Format1, T5Sum.TotBox12) + '</tot_dvnd_tx_cr_amt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox14 <> 0 then
  begin
    s := Space(indentMMMM) + '<totr_cdn_incamt>' + FormatFloat(Format1, T5Sum.TotBox14) + '</totr_cdn_incamt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox15 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_fgn_incamt>' + FormatFloat(Format1, T5Sum.TotBox15) + '</tot_fgn_incamt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox16 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_fgn_tx_pay_amt>' + FormatFloat(Format1, T5Sum.TotBox16) + '</tot_fgn_tx_pay_amt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox17 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_cdn_royl_amt>' + FormatFloat(Format1, T5Sum.TotBox17) + '</tot_cdn_royl_amt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox18 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_cgain_dvnd_amt>' + FormatFloat(Format1, T5Sum.TotBox18) + '</tot_cgain_dvnd_amt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox19 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_acr_annty_amt>' + FormatFloat(Format1, T5Sum.TotBox19) + '</tot_acr_annty_amt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox24 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_actl_elg_dvamt>' + FormatFloat(Format1, T5Sum.TotBox24) + '</tot_actl_elg_dvamt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox25 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_tx_elg_dvamt>' + FormatFloat(Format1, T5Sum.TotBox25) + '</tot_tx_elg_dvamt>';
    WriteIt(F1, s);
  end;

  if T5Sum.TotBox26 <> 0 then
  begin
    s := Space(indentMMMM) + '<tot_enhn_dvtc_amt>' + FormatFloat(Format1, T5Sum.TotBox26) + '</tot_enhn_dvtc_amt>';
    WriteIt(F1, s);
  end;

  //if T5Sum.TotBox?? <> 0 then
  //begin
    //s:= Space(indentMMMM) + '<tot_rsrc_alwnc_amt>' + FormatFloat(Format1, T5Sum.TotBox??) + '</tot_rsrc_alwnc_amt>'; //Total amount eligible for resource allowance deduction. - accumulated total of recipients' amount eligible for resource allowance deduction, as reported on the T5 slip records filed with this T5 Summary.
    //WriteIt(F1, s);
  //end;

  s := Space(indentMMM) + '</T5_TAMT>';
  WriteIt(F1, s);

  s := Space(indentMM) + '</T5Summary>';
  WriteIt(F1, s);
end;
//20260115 Igor <<<
{$ENDREGION}


end.

