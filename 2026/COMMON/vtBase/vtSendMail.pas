unit vtSendMail;

interface

uses System.SysUtils, IdSSLOpenSSL, IdSMTP, IdMessage, IdText, IdExplicitTLSClientServerBase,
  Classes, IdGlobal, IdComponent; //20180503 Igor

  type
    TSendMail = class
    public
      function SendMail(const aFrom, aTo, aSubj, aMessage: string; out aErrorMessage: string): boolean;
      //20180503 Igor >>>	
      procedure IdSMTP1Status(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
      procedure IdSSLIOHandlerSocketStatusInfo(const AMsg: string);
      //20180503 Igor <<<
    end;

implementation

{ TSendMail }

procedure AddToLog(AMsg: string); //20180503 Igor
begin
  with TStringList.Create do
  begin
    if FileExists('Sendmail.log') then
      LoadFromFile('Sendmail.log');
    Add(AMsg);
    SaveToFile('Sendmail.log');
    Free;
  end;
end;

procedure TSendMail.IdSSLIOHandlerSocketStatusInfo(const AMsg: String); //20180503 Igor
begin
  AddToLog('IdSSLIOHandlerSocket: '+ AMsg);
end;

procedure TSendMail.IdSMTP1Status(ASender: TObject; const AStatus: TIdStatus; //20180503 Igor
  const AStatusText: string);
begin
  AddToLog('IdSMTP: ' + AStatusText);
end;

function TSendMail.SendMail(const aFrom, aTo, aSubj, aMessage: string;
  out aErrorMessage: string): boolean;
var
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
begin
  // 20180616 Igor >>>
  //IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdSMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);

  try
    {
    //20180503 Igor >>>
    with IdSSLIOHandlerSocket do
    begin
      Destination := 'smtp.gmail.com:587';
      Host := 'smtp.gmail.com';
      MaxLineAction := maException;
      Port := 587;
      DefaultPort := 0;
      SSLOptions.Mode := sslmUnassigned;
      SSLOptions.VerifyMode := [];
      SSLOptions.VerifyDepth := 0;
      //OnStatusInfo := IdSSLIOHandlerSocketStatusInfo;
    end;

    with IdSMTP do
    begin
      IOHandler := IdSSLIOHandlerSocket;
      Host := 'smtp.gmail.com';
      Password := 'vtSecret2015';
      Port := 587;
      UseTLS := utUseExplicitTLS;
      Username := 'VisualTaxCanada@gmail.com';
      //OnStatus := IdSMTP1Status;
    end;
    //20180503 Igor <<<
    }

    IdSMTP.Host := 'smtpout.secureserver.net';
    IdSMTP.Username := 'virtualui@visualtax.com';
    IdSMTP.Password := 'virtualuipassword';
    IdSMTP.Port := 25;

    IdMessage.From.Address := 'virtualui@visualtax.com'; //20180503 Igor
    IdMessage.From.Name := 'VisualTax';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := aTo;
    IdMessage.Subject := aSubj;
    IdMessage.Encoding := meMIME;
    // 20180616 Igor <<<

    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add(aMessage);
    IdText.ContentType := 'text/plain; charset=iso-8859-1';

    try
      IdSMTP.Connect;
      IdSMTP.Send(IdMessage);
      IdSMTP.Disconnect; //20180503 Igor
    except
      on E:Exception do
      begin
        aErrorMessage := 'Error while send email: ' + E.Message;
        AddToLog(aErrorMessage); //20180503 Igor
        Result := False;
        Exit;
      end;
    end;

//20180503 Igor >>>
//    try
//      IdSMTP.Send(IdMessage);
//    except
//      On E:Exception do
//      begin
//        aErrorMessage := 'Error while sending a message: ' + E.Message;
//        Result := False;
//        Exit;
//      end;
//    end;
//20180503 Igor <<<
  finally
    FreeAndNil(IdMessage);
    //FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
  Result := True;
end;

end.
