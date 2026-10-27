Unit TF_2019T5013Efile;

interface
uses
  SysUtils,FileCtrl,WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,Printers,
  TF_2019Declare,TF_2019TrimStr, ExtCtrls,
  Math,  TF_2019Calc, vtLabel, //UEFSECURE,//20130622
  //webservices
  //ComObj,MsXml2_TLB,ShellApi, OleCtrls, SHDocVw, vtLabel;



  StrUtils, Types,



  TF_2019Common

  ;



const
  delim = '|';

type
  TXMLTagImportance = (isOptional, isRequired, isOptionalPreviousOptional, isOptionalDepending);
  TXMLTagType = (dataTag, beginTag, endTag, skipTag);



Type
 AXMLLoopRec  = Record
  looping       : boolean;
  startPos      : integer;
  i             : integer;
  increment     : integer;
  count         : integer;

  tagNm         : string;

  loopEnd       : integer;

 End;

Type
 AXMLFormRec           = Record
  formName          : string;
  
  formInstanceNum   : integer;
  formInstCount     : integer;
  formIsMultiInst   : boolean;
  multiInstTagNm    : string;

  multiInstStartPos : integer;
  currentPos        : integer;
 
 End;

Type
 AXMLTagRec           = Record
  tag                 : string;
  tagType           : TXMLTagType;
  tagImportance     : TXMLTagImportance;
  value             : string;
  lnNum             : integer;
  formName          : string;

  formIsMultiInst   : boolean;
  currentPos        : integer;

  elms              : string;
  elm               : integer;
  valType           : string;
  vallength         : string;

  defaultVal        : string;

  previousTag       : string;

  dependingElms     : string;
  isREQDepending    : boolean;
  isOptDepending    : boolean;
  isOptIfNo         : boolean;

  hasPreviousTag    : boolean;
  isConcant         : boolean;
  isMapped          : boolean;
  isDirectValue     : boolean;

  format            : string;

  isSingleLoop      : boolean;
  isNestedLoop      : boolean;

  loopStartElm      : integer;
  loopEndElm        : integer;
  loopInc           : integer;
  loopForNumOfTags  : integer;

  getMidStrValue    : boolean;
  midStrStartPos    : integer;
  midStrLength      : integer;

  endOfData         : boolean;
end;



type
  TT5013EfleT4T5_2019 = class(TForm)
    RsiFrmList: TListBox;
    PrintDialog1: TPrintDialog;
    HeaderBox: TPanel;
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    ShowBarCodeDataBtn: TBitBtn;
    WebServiceEfileBtn: TBitBtn;
    testingIndicator: TPanel;
    corFileClickLbl: TvtLabel;
    Label6: TLabel;
    URLForWebServicesBox: TEdit;
    FileLocationBox: TEdit;
    Label1: TLabel;
    SubmissionPrefixBox: TEdit;
    SubmissionSeqBox: TEdit;
    Label3: TLabel;
    xmlInfoFileInputBox: TEdit;
    xmlInfoFileBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    T619xmlInfoFileInputBox: TEdit;
    Image1: TImage;

    procedure FormCreate(Sender: TObject);
    procedure ShowBarCodeDataBtnClick(Sender: TObject);

    procedure prepareXML(xmlFile:string; var T5013list: Tstringlist);

    Procedure PrepareXmitterinfo(ARetNo: Integer; Var F1: TextFile; DataTypeCode: String; SubmitRef: String; var T5013xmlList:Tstringlist);
    procedure createT5013xml(aRetNo:integer;var T5013xmlFileList:Tstringlist;DataTypeCode: String);
    procedure PrepareT5013Slip(ARetNo: Integer; FormNo:integer; Var T5013xmlList:TStringlist; DataTypeCode: String);

    procedure AddBTag(AIndent: integer; AName: string; var fList:TStringlist);
    procedure AddETag(AIndent: integer; AName: string; TagImportance: TXMLTagImportance; var fList:TStringlist);

    //procedure AddTag(AIndent: integer; AName, AValue: string; TagImportance: TXMLTagImportance; var fList:TStringlist);
    //procedure AddBTag(AIndent: integer; AName: string; var fList:TStringlist);
    //procedure AddTag(ATag, AValue: string; required: boolean; var AList:TStringlist);
    //procedure addEndTag(eTag: string; required: boolean; var aList:TStringlist);


    //procedure AddTag(ATag, AValue: string; importance: TXMLTagImportance; var AList:TStringlist);
    procedure AddTag(XMLTag:AXMLTagRec; var AList:TStringlist);

    //procedure AddBeginTag(AIndent: integer; AName: string; var fList:TStringlist);
    procedure addEndTag(eTag: string; importance: TXMLTagImportance; var aList:TStringlist);



    function ReplacePredefinedXMLEntities(info: string): string;
    procedure WebServiceEfileBtnClick(Sender: TObject);
    procedure xmlInfoFileBtnClick(Sender: TObject);

    //Procedure fillEditFromMemo(RetNo:Integer);
    //procedure PrepareData(Sender: TObject);

    //Function ExcludeInvalidCharacters(s:string):string;

    //procedure WebServiceEfileBtnClick(Sender: TObject);
    //procedure WebServiceEfile();

    //function CanEfileValidation:boolean;


    //procedure CreateSoapMessage(var SoapMsg:AnsiString;multiPartName:String);
    //Function CreateSoapEnvelope() :ansistring;
    //Function CreateSoapContent():ansistring;

    //Procedure SubmitSoapMsg(SoapMsg:AnsiString;multiPartName:String);
    //Procedure parseXmlResponse(rString:ansistring);


//______________________________________________________________________________
//WEBSERVICES END
//------------------------------------------------------------------------------



  private
    function GetEFillDir: String;
    property EFillDir: String read GetEFillDir;
    { Private declarations }
  public
    { Public declarations }
  end;


const
  indent0 = 0;
  indent1 = 3;
  indent2 = 6;
  indent3 = 9;
  indent4 = 12;
  indent5 = 15;

  indent        = '';
  indentM       = '   ';
  indentMM      = '      ';
  indentMMM     = '         ';
  indentMMMM    = '            ';
  indentMMMMM   = '               ';


var
  T5013EfleT4T5_2019: TT5013EfleT4T5_2019;

  RetNo:Integer;
  sURL:string;   //20130530
  InvalidCharactersList:TStringList;   //20140706
  Efiling:Boolean;
  SkipIt:Boolean;
  BarDataArray: array of AnsiString;

  FieldDelim: String;
  RecordDelim: String;

  WList :TStringList;



implementation

uses TF_2019main, vtTrimStr, vtMain, vtMulti, vtCommon, TF_2019;

{$R *.DFM}


procedure TT5013EfleT4T5_2019.FormCreate(Sender: TObject);
begin
  T619xmlinfoFileInputBox.text:=AppDir+'\t619xml.xml'; //20200713   //C:\XE-WIP\2019\DistrFl\TF-2019\t619xml.xml
  RetNo := GetCurrentRetNo;

  If URLForWebServicesBox.text = '' then
    URLForWebServicesBox.text := 'https://apps.cra-arc.gc.ca/ebci/leb0/upload/pub/entry-e.do';

  If xmlInfoFileInputBox.text = '' then
    xmlInfoFileInputBox.text := AppDir + '\t5013xmlTestBuild.xml';

  If FileLocationBox.text = '' then
  begin
    FileLocationBox.text := AppDir + '\t5013xmlTestSubmission.xml';

    {
    If Not ForceDirectories(EFillDir) then
    begin
      MessageDlg('Can''t create directory "' + EFillDir + '"', mtError, [mbOk], 0);
      close;
      exit;
    end;
    //MkFileLocation;
    }
  end;

  //TypeOfReturnBtn.ItemIndex := 0;

end;


function TT5013EfleT4T5_2019.GetEFillDir: String;
begin
 Result := IncludeTrailingPathDelimiter(AppDir) + 'Efile';
end;

procedure TT5013EfleT4T5_2019.ShowBarCodeDataBtnClick(Sender: TObject);
var
  T5013list   : Tstringlist;
  DataTypeCode: String;
  F1 : TextFile;
  FRetNo: integer;
  SubmitRef:String;

begin

//create and pass main stringlist
T5013list   := Tstringlist.create;

//prepareXML(T619xmlInfoFileInputBox.text,T5013list);
prepareXML(xmlInfoFileInputBox.text,T5013list);

T5013list.SaveToFile(FileLocationBox.Text);
T5013list.free;

exit;


   FRetNo := GetCurrentRetNo;


  {
  //if Not CheckPrepare then exit;

  Case DataTypeBtn.itemindex of
    0: DataTypeCode := 'O'; //original
    1: DataTypeCode := 'A'; //Amended
    2: DataTypeCode := 'C'; //Cancelled
  else
    DataTypeCode := '';
  end;
  }

  DataTypeCode := '';

  //SubmissionPrefixBox.Text:=MkReferenceNo;

{
  AssignFile(F1, FileLocationBox.text);
  ReWrite(F1);
  try
}

{
    SubmitRef := SubmissionPrefixBox.Text + SubmissionSeqBox.Text;


    T5013xmlFileList:=Tstringlist.create;

    PrepareXmitterinfo(FRetNo, F1, DataTypeCode, SubmitRef, T5013xmlFileList);

    createT5013xml(FRetNo, T5013xmlFileList,DataTypeCode);

    T5013xmlFileList.SaveToFile(FileLocationBox.Text);


}

{
  finally
    CloseFile(F1);
  end;
}
  MessageDlg('XML file has been completed and saved as ' + FileLocationBox.Text, mtInformation, [mbOk], 0);

end;


procedure TT5013EfleT4T5_2019.WebServiceEfileBtnClick(Sender: TObject);
var
NonInstFormName:string;
begin

//

            NonInstFormName := 'PS2';
            showmessage(inttostr(CountMxInst(NonInstFormName)));
            showmessage(inttostr(GetHighestInst(NonInstFormName)));


            NonInstFormName := 'T5013FIN';
            showmessage(inttostr(CountMxInst(NonInstFormName)));
            showmessage(inttostr(GetHighestInst(NonInstFormName)));


end;

procedure TT5013EfleT4T5_2019.xmlInfoFileBtnClick(Sender: TObject);
begin

  OpenDialog1.Filter := 'XML (*.XML)|*.XML';

  if xmlInfoFileInputBox.text = '' then
    OpenDialog1.InitialDir := IncludeTrailingPathDelimiter(AppDir)
  else
    OpenDialog1.InitialDir :=  ExtractFilePath(xmlInfoFileInputBox.Text);

  If OpenDialog1.Execute then
  begin
    xmlInfoFileInputBox.Text := OpenDialog1.FileName;
  end;
end;

procedure TT5013EfleT4T5_2019.prepareXML(xmlFile:string; var T5013list: Tstringlist);


        function getDirectValue(XMLTag:AXMLTagRec): string;
        var
          s : string;
        begin
          s := StringReplace(XMLTag.elms, '==', '',[rfReplaceAll, rfIgnoreCase]);
          s := trim(s);
          result := s;
        end;

        function getMappedValue(retNo:integer; XMLTag:AXMLTagRec; loop:AXMLLoopRec): string;
        const
          delim1 = '/';delim2 = '-';
        var
          mapString : string;
          parsedMapArray, mappedValues : TStringDynArray;
          i,j,elm : integer;
        begin
          mapString := StringReplace(XMLTag.elms, '>', '',[rfReplaceAll, rfIgnoreCase]);
          parsedMapArray  := SplitString(mapString,delim1);
          result          := '';
          for i := 0 to length(parsedMapArray)-1 do
          begin
            mappedValues        := SplitString(parsedMapArray[i],delim2);

            elm := strtoint(trim(mappedValues[0])) + loop.i*loop.Increment;

            if FetchElm(RetNo, XMLTag.formName, elm) > '' then
            begin
                result := trim(mappedValues[1]);
                exit;
            end;
          end;
        end;

        function concatenateValue(retNo:integer; XMLTag:AXMLTagRec; loop:AXMLLoopRec): string;
        const
          delim = '+';
        var
          parsedElmArray  : TStringDynArray;
          i, parsedElmArrayLength, elm : integer;
        begin
          parsedElmArray        := SplitString(XMLTag.elms,delim);
          parsedElmArrayLength  := length(parsedElmArray);

          result := '';
          for i := 0 to parsedElmArrayLength-1 do
          begin
            elm := strtoint(parsedElmArray[i]) + loop.i*loop.Increment;
            result := result + FetchElm(RetNo, XMLTag.formName, elm) + ' ';
          end;
        end;

        function formatVal(var XMLTag:AXMLTagRec):string;
        begin

          if (XMLTag.value = '') and (XMLTag.defaultVal > '') then
          begin
            XMLTag.value := XMLTag.defaultVal;
          end
          else
          begin
            if      XMLTag.valType = 'AN'   then begin end
            else if XMLTag.valType = 'N'    then begin end
            else if XMLTag.valType = 'A'    then begin end
            else if XMLTag.valType = 'Y/N'  then
            begin
              if uppercase(XMLTag.value) = 'X' then XMLTag.value := '1' else XMLTag.value := '2';
              if (XMLTag.isOptIfNo) and (XMLTag.value = '2') then XMLTag.value := '';
            end
            else if XMLTag.valType = '$'    then begin end
            else if XMLTag.valType = 'D'    then begin end
            else if XMLTag.valType = 'P'    then begin end;

            if XMLTag.getMidStrValue then
            begin
              XMLTag.value := MidStr(XMLTag.value, XMLTag.midStrStartPos, XMLTag.midStrLength)
            end;

          end;



          result := XMLTag.value;
        end;

        function doDependantTagsHaveValue(retNo:integer;XMLTag:AXMLTagRec;loop:AXMLLoopRec):boolean;
        const
          delim = ',';
        var
          parsedElmArray  : TStringDynArray;
          i, parsedElmArrayLength, elm : integer;
          v : string;
        begin

          result := false;
          if XMLTag.isOptDepending or XMLTag.isReqDepending then
          begin
            parsedElmArray        := SplitString(XMLTag.dependingElms,delim);
            parsedElmArrayLength  := length(parsedElmArray);

            for i := 0 to parsedElmArrayLength-1 do
            begin
              elm := strtoint(parsedElmArray[i]) + + loop.i*loop.Increment;
              v   := v + fetchElm(retNo,XMLTag.formName,elm);
            end;

            if trim(v) > '' then
              result := true;

          end;
        end;


        function getXMLValue(retno:integer;var XMLTag:AXMLTagRec;loop:AXMLLoopRec):string;
        var
           val : string;
           elm: integer;
        begin

          XMLTag.value := '';
          if (Ret[RetNo].FrmHasData[GetFormNo(XMLTag.formName)])then
          begin
              if (XMLTag.isOptDepending) and (not dodependantTagsHaveValue(retNo,XMLTag,loop)) then
                begin result := XMLTag.value; exit; end;

              if (XMLTag.isReqDepending) and (dodependantTagsHaveValue(retNo,XMLTag,loop)) then
                begin XMLTag.tagImportance := isRequired; end;


              if XMLTag.isDirectValue then
                begin XMLTag.value := getDirectValue(XMLTag); end
              else if XMLTag.isConcant then
                begin XMLTag.value := concatenateValue(retNo,XMLTag,loop); end
              else if XMLTag.isMapped then
                begin XMLTag.value := getMappedValue(retNo,XMLTag,loop); end
              else
              begin
                elm := strtoint(XMLTag.elms) + loop.i*loop.Increment; //XMLTag.loopIteration*XMLTag.loopInc;
                XMLTag.value := FetchElm(RetNo, XMLTag.formName,elm)
              end;

            XMLTag.value := formatVal(XMLTag);

          end;

          result := XMLTag.value

        end;

        function sectValidated(sectId:string;sectArray:TStringDynArray;xmlLine:string):boolean;
        var
          i,sectArrayLength:integer;
          s:string;

        begin
          result := true;

          sectArrayLength:=length(sectArray);
          for i := 0 to sectArrayLength-1 do
            begin s:= s + sectArray[i]; end;
          if pos('?',s)>0 then
            begin result := false; exit; end;

          if       sectId = 'LINE'      then begin if sectArrayLength <> 1 then begin showmessage(sectId + ' error, in ' + xmlLine); result := false; end; end
          //else if  sectId = '=='      then begin if sectArrayLength <> 1 then begin showmessage(sectId + ' error, in ' + xmlLine); result := false; end; end
          else if  sectId = 'FETCH'     then begin if sectArrayLength <> 2 then begin showmessage(sectId + ' error, in ' + xmlLine); result := false; end; end
          else if  sectId = 'LOOPNESTED'then begin if sectArrayLength <> 3 then begin showmessage(sectId + ' error, in ' + xmlLine); result := false; end; end
          else if  sectId = 'LOOP'      then begin if sectArrayLength <> 4 then begin showmessage(sectId + ' error, in ' + xmlLine); result := false; end; end

          else if  sectId = 'TYPE'      then begin if sectArrayLength <> 2 then begin showmessage(sectId + ' error, in ' + xmlLine); result := false; end; end

          //else if  sectId = 'FORMAT'  then begin if sectArrayLength <> 1 then showmessage(sectId + ' error, in ' + xmlLine); result := false;end
        end;

        function parseXMLLineInfo(xmlLine:string):AXMLTagRec;
        const
          sectDelim = ',';
        var

          s,sect,sectValues,id  : string;
          i,j                   : integer;
          parsedValArray        : TStringDynArray;
          parsedSectArray       : TStringDynArray;
          parsedValArrayLength  : integer;
          parsedValItem         : integer;
          XMLTag                : AXMLTagRec;
        begin
          //is blank line or comment so skip
          if (trim(xmlLine) = '') or (pos('//',xmlLine)>0) then
            begin XMLTag.tagType    := skipTag; result := XMLTag;   exit; end;

          //ignore evertything after endofdata
          if (pos('ENDOFDATA',xmlLine)>0) then
            begin XMLTag.endOfData  := true;    result := XMLTag;   exit; end;


          parsedValArray        := SplitString(xmlLine,delim);
          parsedValArrayLength  := length(parsedValArray);

          XMLTag.tag            := trimRight(parsedValArray[0]);
          XMLTag.tagImportance  := isOptional;

          //begintag ------------------------------------------------------------------------------------------------------------------------------
          if (pos('><',XMLTag.tag)=0) and (pos('</',XMLTag.tag)=0) then begin       XMLTag.tagType := beginTag; end
          //endtag ---------------------------------------------------------------
          else if (pos('><',XMLTag.tag)=0) and (pos('</',XMLTag.tag)>0) then begin  XMLTag.tagType := endTag; end
          else                                                                      XMLTag.tagType := dataTag;


          for i := 1 to parsedValArrayLength-1 do
          begin
            sect := parsedValArray[i];

            id := 'DESCR';
            if      pos(id,sect) > 0          then
            begin
              //if      pos('LOOP',sect) > 0 then showmessage('loop in descr');
              continue;
            end;


            if pos('REQ',sect) > 0       then
            begin
              XMLTag.tagImportance  := isRequired;

              id := 'REQIF';
              if      pos(id,uppercase(sect)) > 0          then
              begin
                sectValues := trim(stringReplace(sect, id, '',[]));
                //parsedSectArray := SplitString(sectValues,sectDelim);
                //if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                      XMLTag.isREQDepending     := true;
                                                      XMLTag.dependingElms      := sectValues; //trim(parsedSectArray[0]);
              end;

            end;

            //==================================================================
            if pos('OPT',sect) > 0       then
            begin
                                                          XMLTag.tagImportance  := isOptional;

              sectValues := sect;

              id := 'PREVOPT';
              if      pos(id,uppercase(sectValues)) > 0          then
              begin
                sectValues := trim(stringReplace(sect, id, '',[]));
                                                          XMLTag.tagImportance  := isOptionalPreviousOptional;
              end;

              id := 'OPTIFNO';
              if      pos(id,uppercase(sectValues)) > 0          then
              begin
                sectValues := trim(stringReplace(sect, id, '',[]));
                //parsedSectArray := SplitString(sectValues,sectDelim);
                //if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                      XMLTag.isOptIfNo          := true;

              end;

              id := 'OPTIF';
              if      pos(id,uppercase(sectValues)) > 0          then
              begin
                sectValues := trim(stringReplace(sect, id, '',[]));
                //parsedSectArray := SplitString(sectValues,sectDelim);
                //if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                      XMLTag.isOptDepending     := true;
                                                      XMLTag.dependingElms      := sectValues; //trim(parsedSectArray[0]);
              end;

              continue;
            end;


            //==================================================================
            id := 'DEFAULTVALUE';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                          XMLTag.defaultVal     := trim(parsedSectArray[0]);

            end;

            //==================================================================
            id := 'ELM';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                          XMLTag.elms           := trim(parsedSectArray[0]);

              if pos('+',XMLTag.elms)  > 0 then
                                                          XMLTag.isConcant      := true
              else if pos('->',XMLTag.elms) > 0 then
                                                          XMLTag.isMapped       := true
              else if pos('==',XMLTag.elms) > 0 then
                                                          XMLTag.isDirectValue  := true;

                                                          continue;
            end;

            //==================================================================
            id := 'LINE';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                          XMLTag.lnNum          := strtoint(trim(parsedSectArray[0]));
                                                          continue;
            end;

            //==================================================================
            id := 'FORM';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                          XMLTag.formName       := ExtractNonInstFormName(trim(parsedSectArray[0]));
              if pos('#',parsedSectArray[0]) > 0 then     XMLTag.formIsMultiInst:= true; //IsFormMultiInst(FormName: string): Boolean; //checks for number after, decieded not to use
{
                                                          XMLTag.multiInstTagNm := stringReplace(XMLTag.tag, '>', '',[]);
                                                          XMLTag.multiInstTagNm := trim(stringReplace(XMLTag.multiInstTagNm, '<', '',[]));
                                                       XMLTag.multiInstStartPos := XMLTag.currentPos;
                                                          XMLTag.formInstCount  := CountMxInst(ExtractNonInstFormName(XMLTag.formName));             //GetHighestInst(NonInstFormName: String): Integer; //does samething?
}
                                                          continue;
            end;

            //==================================================================
            id := 'LOOPNESTED';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                          XMLTag.isNestedLoop   := true;

                                                          XMLTag.loopStartElm   := strtoint(trim(parsedSectArray[0]));
                                                          XMLTag.loopEndElm     := strtoint(trim(parsedSectArray[1]));
                                                          XMLTag.loopInc        := strtoint(trim(parsedSectArray[2]));

                                                          continue;
            end;
            //==================================================================
            id := 'LOOP';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                        XMLTag.isSingleLoop     := true;

                                                        XMLTag.loopStartElm     := strtoint(trim(parsedSectArray[0]));
                                                        XMLTag.loopEndElm       := strtoint(trim(parsedSectArray[1]));
                                                        XMLTag.loopInc          := strtoint(trim(parsedSectArray[2]));
                                                        XMLTag.loopForNumOfTags := strtoint(trim(parsedSectArray[3]));
                                                        continue;
            end;

            //==================================================================
            id := 'MIDSTR';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                        XMLTag.getMidstrValue   := true;
                                                        XMLTag.midStrStartPos   := strtoint(trim(parsedSectArray[0]));
                                                        XMLTag.midStrLength     := strtoint(trim(parsedSectArray[1]));
                                                        continue;
            end;

            //==================================================================
            id := 'TYPE';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                          XMLTag.valType        := trim(parsedSectArray[0]);
                                                          XMLTag.vallength      := trim(parsedSectArray[1]);

                                                          continue;
            end;

            //==================================================================


            {
            id := 'PREVTAG';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;
                                                          XMLTag.hasPreviousTag := true;
                                                          XMLTag.previousTag    := trim(parsedSectArray[0]);
                                                          continue;
            end;

            //==================================================================
            id := 'FORMAT';
            if      pos(id,sect) > 0          then
            begin
              sectValues := trim(stringReplace(sect, id, '',[]));
              parsedSectArray := SplitString(sectValues,sectDelim);
              if not (sectValidated(id,parsedSectArray,xmlLine)) then begin XMLTag.tagType  := skipTag; continue; end;

                                                          XMLTag.format          := trim(parsedSectArray[0]);
                                                          continue;
            end;
}

          end;

          result := XMLTag;

        end;


        procedure setFormInfo(iteration:integer; var TagInfo:AXMLTagRec; var formInfo:AXMLFormRec);
        begin
          if tagInfo.formIsMultiInst then
          begin

            formInfo.formIsMultiInst    := tagInfo.formIsMultiInst;
            formInfo.multiInstTagNm     := stringReplace(TagInfo.tag, '>', '',[]);
            formInfo.multiInstTagNm     := trim(stringReplace(formInfo.multiInstTagNm, '<', '',[]));
            formInfo.multiInstStartPos  := iteration; //TagInfo.currentPos;
            formInfo.formInstCount      := CountMxInst(ExtractNonInstFormName(TagInfo.formName));             //GetHighestInst(NonInstFormName: String): Integer; //does samething?

            if formInfo.formInstanceNum = 0 then formInfo.formInstanceNum := 1;

            tagInfo.formName := ExtractNonInstFormName(tagInfo.formName) + '#'+inttostr(formInfo.formInstanceNum);
            formInfo.formname :=  tagInfo.formName;
          end
          else
          begin
            formInfo.formname :=  tagInfo.formName;
          end;
        end;

        procedure updateFormInfo(var i:integer;tagInfo:AXMLTagRec;var formInfo:AXMLFormRec);
        begin
          //update instance info
          if formInfo.formIsMultiInst and (pos(formInfo.multiInstTagNm,tagInfo.tag) > 0) then
          begin
            if (formInfo.formInstanceNum < formInfo.formInstCount) then
            begin
              inc(formInfo.formInstanceNum,1);
              i:= formInfo.multiInstStartPos-1; //-1 because i adds one after
              //continue;
            end
            else if (formInfo.formInstanceNum = formInfo.formInstCount) then
              begin formInfo.formInstanceNum := 0; end;
          end;
        end;
        procedure setNestedLoopInfo(iteration:integer; var tagInfo:AXMLTagRec; var loopInfo:AXMLLoopRec);
        begin
          if tagInfo.isNestedLoop then
          begin
            loopInfo.looping    := true;

            //fyi single looping inside group causes problems, do not allow it
            if loopInfo.i = 0 then
            begin
              loopInfo.tagNm        := stringReplace(tagInfo.tag, '>', '',[]);
              loopInfo.tagNm        := trim(stringReplace(loopInfo.tagNm, '<', '',[]));
              loopInfo.startPos     := iteration;
              loopInfo.increment    := tagInfo.loopInc;
              loopInfo.count        := (tagInfo.loopEndElm - tagInfo.loopStartElm) div tagInfo.loopInc;
            end;
          end;
        end;
        procedure updateNestedLoopInfo(var i:integer;tagInfo:AXMLTagRec;var loopInfo:AXMLLoopRec);
        begin
          if loopInfo.looping and (pos(loopInfo.TagNm,tagInfo.tag) > 0) then
          begin

            if (loopInfo.i < loopInfo.Count) then
            begin
              inc(loopInfo.i,1);
              i:= loopInfo.StartPos - 1; //-1 because i adds one after
            end
            else if (loopInfo.i = loopInfo.Count) then
            begin
              loopInfo.looping      := false;
              loopInfo.StartPos     := 0;
              loopInfo.i            := 0;
              loopInfo.Count        := 0;
              loopInfo.tagNm        := '';
            end;

          end;
        end;

        procedure setSingleLoopInfo(iteration:integer; var tagInfo:AXMLTagRec; var loopInfo:AXMLLoopRec);
        begin
          if (tagInfo.isSingleLoop) and (not loopInfo.looping) then
          begin
            loopInfo.looping    := true;

            //fyi single looping inside group causes problems, do not allow it
            if loopInfo.i = 0 then
            begin

              loopInfo.tagNm        := stringReplace(tagInfo.tag, '>', '',[]);
              loopInfo.tagNm        := trim(stringReplace(loopInfo.tagNm, '<', '',[]));
              loopInfo.startPos     := iteration;
              loopInfo.increment    := tagInfo.loopInc;
              loopInfo.count        := (tagInfo.loopEndElm - tagInfo.loopStartElm) div tagInfo.loopInc;

              loopInfo.loopEnd     := iteration + tagInfo.loopForNumOfTags;
            end;
          end;
        end;

        function updateSingleLoopInfo(var i:integer;tagInfo:AXMLTagRec;var loopInfo:AXMLLoopRec):boolean;
        begin
          result := true;

          if loopInfo.looping then
          begin

            if (i = loopInfo.loopEnd  ) then
            begin
                if (loopInfo.i < loopInfo.Count) then
                begin
                  inc(loopInfo.i,1);
                  i:= loopInfo.StartPos - 1; //-1 because i adds one after
                result := false
                end
                else if (loopInfo.i = loopInfo.Count) then
                begin
                  loopInfo.looping     := false;
                  loopInfo.StartPos    := 0;
                  loopInfo.i           := 0;
                  loopInfo.Count       := 0;
                  loopInfo.tagNm       := '';
                  loopInfo.loopEnd     := 0;
                  result := true;
                end;
            end;
          end;


        end;



var
  i,j,inst:integer;

  xmlInfolist : Tstringlist;

  xmlLine : string;

  fNameInst    : string;
  valueString : TStringDynArray;
  vallength   : integer;

  XMLTagInfo        : AXMLTagRec;
  XMLFormInfo       : AXMLFormRec;
  XMLLoopGroupInfo  : AXMLLoopRec;
begin

  xmlInfolist :=Tstringlist.create;


  //xmlInfolist.LoadFromFile(AppDir + '\t5013xml.xml');//xmlInfolist.LoadFromFile(AppDir + '\t5013xmlTest.xml'); //xmlInfolist.LoadFromFile(AppDir + '\t5013xmlBuild.xml');
  xmlInfolist.LoadFromFile(xmlFile);

  while i <= xmlInfolist.Count-1 do
  begin
    xmlLine:=xmlInfolist[i];
    XMLTagInfo := parseXMLLineInfo(xmlLine);

    if XMLTagInfo.endOfData then break;

    //if not specified formname on line then use 'global' formname on form beginning tag line
    if XMLTagInfo.formName = '' then XMLTagInfo.formName := XMLFormInfo.formName;


    if XMLTagInfo.tagType <> skipTag then
    begin
      if XMLTagInfo.tagType = beginTag then
      begin
                                           setFormInfo(i,XMLTagInfo, XMLFormInfo);
        if XMLTagInfo.isNestedLoop    then setNestedLoopInfo(i,XMLTagInfo, XMLLoopGroupInfo);
        T5013list.Add(XMLTagInfo.tag);
        //testforEndTag(XMLFormInfo,XMLLoopGroupInfo);
      end

      else if XMLTagInfo.tagType = endTag then
      begin
        addEndTag(XMLTagInfo.tag, XMLTagInfo.tagImportance, T5013list);
        updateFormInfo(i,XMLTagInfo,XMLFormInfo);
        updateNestedLoopInfo(i,XMLTagInfo,XMLloopGroupInfo);

      end
      else if XMLTagInfo.tagType = dataTag then
      begin

        setSingleLoopInfo(i,XMLTagInfo, XMLLoopGroupInfo);

        XMLTagInfo.value := getXMLValue(retno,XMLTagInfo,XMLloopGroupInfo);
        AddTag(XMLTagInfo, T5013list);

        updateSingleLoopInfo(i,XMLTagInfo,XMLloopGroupInfo);

      end //end is datatag
      else showmessage('unknown tag');

    end; //skiptag

    inc(i,1);
  end; //end for xmlInfolist

  xmlInfolist.free;

  showmessage('done');

end;



Procedure WriteIt(Var F1: TextFile; S: String);
Begin
  If S > '' then
    WriteLn(F1, S);
end;



procedure TT5013EfleT4T5_2019.createT5013xml(aRetNo:integer;var T5013xmlFileList:Tstringlist;DataTypeCode: String);
const
  Format1 = '#########.##';
var
  i: Integer;
  s: string;
  formInstances: TFRecArray;
begin

end;






procedure TT5013EfleT4T5_2019.addBTag(AIndent: integer; AName: string; var fList:TStringlist);
begin
  fList.Add(Space(AIndent) + '<'+ AName +'>');
end;

procedure TT5013EfleT4T5_2019.addETag(AIndent: integer; AName: string; TagImportance: TXMLTagImportance; var fList:TStringlist);
begin
  if (TagImportance = isOptional) and SameText(Trim(FList.Strings[FList.Count - 1]), '<'+ AName +'>') then
    FList.Delete(FList.Count - 1)
  else
    FList.Add(Space(AIndent) + '</'+ AName +'>');
end;


procedure TT5013EfleT4T5_2019.addEndTag(eTag: string; importance: TXMLTagImportance; var aList:TStringlist);
var
  tagName,prevTagName : string;
begin
  if importance = isOptional then
  begin
    tagName     := StringReplace(trim(eTag), '/', '',[]);
    prevTagName := Trim(AList.Strings[aList.Count - 1]);
    if SameText(prevTagName, tagName) then
        aList.Delete(aList.Count - 1)
    else
        aList.add(eTag);
  end
  else
    aList.add(eTag);
end;


{
procedure TT5013EfleT4T5_2019.AddTag(AIndent: integer; AName, AValue: string; TagImportance: TXMLTagImportance; var fList:TStringlist);
begin
  if SameText(Trim(AValue), '')  and (TagImportance = isOptional) then Exit;
  if SameText(Trim(AValue), '0') and (TagImportance = isOptional) then Exit;  //20180709 CON
  AValue := ReplacePredefinedXMLEntities(AValue);
  if SameText(Trim(AValue), '') then
    FList.Add(Space(AIndent) + '<'+ AName +'/>')
  else
    FList.Add(Space(AIndent) + '<'+ AName +'>' + AValue + '</'+ AName +'>');
end;
}

//procedure TT5013EfleT4T5_2019.AddTag(aTag, aValue: string; importance: TXMLTagImportance; var aList:TStringlist);
procedure TT5013EfleT4T5_2019.AddTag(XMLTag:AXMLTagRec; var AList:TStringlist);
var
  tagName:string;
begin
  if (SameText(Trim(XMLTag.value), '') or SameText(Trim(XMLTag.value), '0')) and (XMLTag.tagImportance = isOptional) then Exit;
  if (SameText(Trim(XMLTag.value), '') or SameText(Trim(XMLTag.value), '0')) and (XMLTag.tagImportance = isOptionalPreviousOptional) then
  begin
    aList.Delete(aList.Count - 1);
    Exit;
  end;

  XMLTag.value := ReplacePredefinedXMLEntities(XMLTag.value);

  if XMLTag.hasPreviousTag then
    aList.Add(XMLTag.previousTag);

  aList.Add(StringReplace(XMLTag.tag, '></', '>'+XMLTag.value+'</',[]));

  {
  //tagName := AnsiMidStr(ATag, pos('<',ATag), pos('></',ATag)-2);
  if SameText(Trim(AValue), '') then
  begin
    aList.Add('<'+ tagName +'/>');
  end
  else
  begin
    aList.Add('<'+ tagName +'>' + AValue + '</'+ tagName +'>');
  end;
  }


end;



function TT5013EfleT4T5_2019.ReplacePredefinedXMLEntities(info: string): string;
begin
  info := Trim(info);
  info := HTMLEscape(info);
  info := ReplaceChar(info, '''', '&apos;');
  Result := info;
end;


{
procedure TInternetFrmT4T5_2019.MkFileLocation;
Begin
  FlNm.Text := IncludeTrailingPathDelimiter(GetEFillDir) +
    GetCorrectFileName(TypeOfReturnBtn.Items[TypeOfReturnBtn.ItemIndex] + ' ' +
        FetchElm(RetNo, 'EMPL' , EMPL_EMPL_NAME) + '.XML');   //20180114
                      // FetchElm(RetNo, 'EMPL' , EMPL_EMPLNO) + '.XML');
end;
}


Procedure TT5013EfleT4T5_2019.PrepareXmitterinfo(ARetNo: Integer; Var F1: TextFile; DataTypeCode: String; SubmitRef: String; var T5013xmlList:Tstringlist);
Var
  S, Info, Lang: String;
begin
  //SubRef := SubmitRef; //SubmissionPrefixBox.Text+SubmissionSeqBox.Text;
  // FlNm:=DiskFrm.FlNm.Text;
(*
  T5013xmllist.add('<?xml version="1.0" encoding="UTF-8"?>');
  T5013xmllist.add('<Submission xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  T5013xmllist.add('xsi:noNamespaceSchemaLocation="layout-topologie.xsd">');

  addBTag(indent0,'T619',T5013xmlList);

    addTag(indent1,'sbmt_ref_id', '???'{SubmitRef},isRequired,T5013xmllist);  //? required 8
    addTag(indent1,'rpt_tcd',     '???'{DataTypeCode},isRequired,T5013xmllist); //need code to find selected: [23][24][25] required 1 alpha
    addTag(indent1,'trnmtr_nbr',  'MM' + LeftStr(OptRec.Prp_TransmitterNo, 6),isOptional,T5013xmllist);   //[1] 2 alpha (MM), 6 numeric
    addTag(indent1,'trnmtr_tcd',  '???'{OptRec.Prp_TransmitterType},isRequired,T5013xmllist);    //? required 1 numeric, 1,2,3,4
    addTag(indent1,'summ_cnt',    '???'{'1'},isRequired,T5013xmllist);  //[29] required 6 numeric
    addTag(indent1,'lang_cd',     'E',isRequired,T5013xmllist); //required 1 alpha e, f  //Default only to 'E'  = English {TODO : check form T619_1}  If FetchElm(ARetNo, 'T619_1',28) > '' then    Lang:='F';

    addBTag(indent1,'TRNMTR_NM',T5013xmlList);
      addTag(indent2,'l1_nm',   '???'{LeftStr(AppTF_2019.Prp_name, 30)},isRequired,T5013xmllist);        //[2] required first 30 alphanumeric
      addTag(indent2,'l2_nm',   '???'{MidStr(AppT4T5_2019.Prp_name, 31, 30)},isOptional,T5013xmllist);   //[2] second 30 alphanumeric
    addETag(indent1,'TRNMTR_NM',isRequired,T5013xmllist);

    addBTag(indent1,'TRNMTR_ADDR',T5013xmlList);
      addTag(indent2,'addr_l1_txt', '???'{LeftStr(AppT4T5_2019.Prp_Street, 30)},isRequired,T5013xmllist);   //[3] required 1st 30 alphanumeric
      addTag(indent2,'addr_l2_txt', '???'{MidStr(AppT4T5_2019.Prp_Street, 31, 30)},isOptional,T5013xmllist); //[3] 2nd 30 alphanumeric
      addTag(indent2,'cty_nm',      '???'{LeftStr(AppT4T5_2019.Prp_City, 28)},isRequired,T5013xmllist);   //[30] required 28 alphanumeric
      addTag(indent2,'prov_cd',     UpperCase('???'{LeftStr(AppT4T5_2019.Prp_Prov,2)}),isRequired,T5013xmllist);  //[4] required 2 alpha
      addTag(indent2,'cntry_cd',    'CAN',isRequired,T5013xmllist); //? required 3 alphanumeric
      addTag(indent2,'pstl_cd',     '???'{LeftStr(FixPostal(AppT4T5_2019.Prp_Postal), 10)},isRequired,T5013xmllist); //[5] required 10 alphanumeric
    addETag(indent1,'TRNMTR_ADDR',isRequired,T5013xmllist);

    addBTag(indent1,'CNTC',T5013xmlList);
      addTag(indent2,'cntc_nm',         '???'{AppT4T5_2019.Prp_ContactName},isRequired,T5013xmllist);   //[8] required 22 alphanumeric, omit titles
      addTag(indent2,'cntc_area_cd',    '???'{LeftStr(AppT4T5_2019.Prp_Area, 3)},isRequired,T5013xmllist);  //[6] - first 3 numbers
      addTag(indent2,'cntc_phn_nbr',    '???'{LeftStr(AppT4T5_2019.Prp_Tel, 8)},isRequired,T5013xmllist); //[6] - last 7 numbers 3 then '-' then last 4  - needs validation on input
      addTag(indent2,'cntc_email_area', '???'{AppT4T5_2019.Prp_Email},isRequired,T5013xmllist);
    addETag(indent1,'CNTC',isRequired,T5013xmllist);

  addETag(indent1,'T619',isRequired,T5013xmllist);
*)
End;



procedure TT5013EfleT4T5_2019.PrepareT5013Slip(ARetNo: Integer; FormNo:integer; Var T5013xmlList:TStringlist; DataTypeCode: String);
var
  i:integer;

begin

(*

  addBTag(indent1,'T5013SlipInformation',T5013xmlList);

  if true then //???
  begin
    addBTag(indent2,'RecipientName',T5013xmlList);
      addTag(indent3,'FamilyName>'      , FetchElm(ARetNo, FormNo, 15) ,isRequired,T5013xmllist);   //Required
      addTag(indent3,'GivenName>'       , FetchElm(ARetNo, FormNo, 80) ,isRequired,T5013xmllist);
      addTag(indent3,'NameInitialText>' , FetchElm(ARetNo, FormNo, 81) ,isRequired,T5013xmllist);
    addETag(indent2,'RecipientName',isRequired,T5013xmllist);

    addTag(indent2,'RecipientSIN' , '000000000' ,isRequired,T5013xmllist); //??? //Required,
  end
  else
  begin
    addBTag(indent2,'BusinessName',T5013xmlList);
      addTag(indent3,'BusinessNameLine1Text',   '???' ,isRequired,T5013xmllist); //Required
      addTag(indent3,'BusinessNameLine2Text',   '???' ,isRequired,T5013xmllist);
    addETag(indent2,'BusinessName',isRequired,T5013xmllist);

    addTag(indent2,'RecipientBusinessNumber'     ,  '???' ,isRequired,T5013xmllist); //Required, 15 alphanumeric, 9 digits RZ 4 digits, example 000000000RZ0000
    addTag(indent2,'RecipientTrustAccountNumber' ,  '???' ,isRequired,T5013xmllist); //when the recipient has failed to provide a "Trust account number", enter T00000000 in the field
  end;

    addBTag(indent2,'RecipientAddress',T5013xmlList);
      addTag(indent3,'AddressLine1Text'   , FetchElm(ARetNo, FormNo, 16) ,isRequired,T5013xmllist);
      //addTag(indent3,'AddressLine2Text'  , FetchElm(ARetNo, AFRec.FormNo, 17) ,isRequired,T5013xmllist); //do not have a second line??
      addTag(indent3,'CityName'           , FetchElm(ARetNo, FormNo, 17) ,isRequired,T5013xmllist);
      addTag(indent3,'ProvinceStateCode'  , FetchElm(ARetNo, FormNo, 18) ,isRequired,T5013xmllist);
      addTag(indent3,'CountryCode>'       , FetchElm(ARetNo, FormNo, 20) ,isRequired,T5013xmllist);
      addTag(indent3,'PostalZipCode>'     , FetchElm(ARetNo, FormNo, 19) ,isRequired,T5013xmllist); //Required - 10 alphanumeric
    addETag(indent2,'RecipientAddress',isRequired,T5013xmllist);

    addTag(indent2,'SlipFilerAccountNumber'       , '???' ,isRequired,T5013xmllist); //Required, 15 alphanumeric, 9 digits RZ 4 digits, example 000000000RZ0000
    addTag(indent2,'SlipReportTypeCode'           , '???' ,isRequired,T5013xmllist);
    addTag(indent2,'PartnershipPartnerCode'       , FetchElm(ARetNo, FormNo, 11) ,isRequired,T5013xmllist);        //Required, 1 numeric
    addTag(indent2,'PartnerResidenceCountryCode'  , FetchElm(ARetNo, FormNo, 10) ,isRequired,T5013xmllist);   //- Required, 3 alpha
    addTag(indent2,'RecipientTypeCode'            , FetchElm(ARetNo, FormNo, 28) ,isRequired,T5013xmllist);            //Required, 1 numeric
    addTag(indent2,'PartnerOwnershipPercent>'     , '???' ,isRequired,T5013xmllist);                              //Required, 3 numeric, decimal, 6 numeric (i.e. 000.000000)

    addBTag(indent2,'T5013Amounts',T5013xmlList);                      //Note: If negative amounts are being reported, include the "–"indicator before the dollar only amount.
      addTag(indent3,'LimitedPartnerBusinessIncomeAmount' , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);
      addTag(indent3,'NetBusinessIncomeAmount'            , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);
      addTag(indent3,'CapitalGainLossAmount'              , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);
      addTag(indent3,'CapitalCostAllowanceAmount'         , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);
    addETag(indent2,'T5013Amounts',isRequired,T5013xmllist);

    addBTag(indent1,'T5013SlipFinancialDetails',T5013xmlList);
      addTag(indent3,'FinancialDetailsFieldCode'          , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);
      addTag(indent3,'FinancialDetailsJurisdictionCode'   , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);
      addTag(indent3,'FinancialDetailsFieldAmount'        , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);
    addETag(indent2,'T5013SlipFinancialDetails',isRequired,T5013xmllist);

    addBTag(indent2,'T5013SlipOtherInformation',T5013xmlList);
      addTag(indent3,'OtherInformationFieldCode'          , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);  //- Required, 3 numeric
      addTag(indent3,'OtherInformationJurisdictionCode'   , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);
      addTag(indent3,'OtherInformationFieldText'          , '?'{FetchElm(ARetNo, FormNo, ??)} ,isRequired,T5013xmllist);
    addETag(indent2,'T5013SlipOtherInformation',isRequired,T5013xmllist);

  addETag(indent1,'T5013SlipInformation',isRequired,T5013xmllist);

  *)

end;






end.
