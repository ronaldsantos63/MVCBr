program ServerSideViewsPrimer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  IdHTTPWebBrokerBridge,
  {$IFDEF MSWINDOWS}
  Winapi.ShellApi,
  Winapi.Windows,
  {$ENDIF }
  Web.WebReq,
  Web.WebBroker,
  WebModuleU in 'WebModuleU.pas' {WebModule1: TWebModule},
  WebSiteControllerU in 'WebSiteControllerU.pas',
  DAL in 'DAL.pas';

{$R *.res}

procedure RunServer(APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
begin
  ReportMemoryLeaksOnShutdown := True;
  Writeln(Format('Starting HTTP Server on port %d', [APort]));
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := APort;
    LServer.Active := True;
    Writeln('Press RETURN to stop the server');

    {$IFDEF MSWINDOWS}

    ShellExecute(0, 'open', 'http://localhost:8080', nil, nil, SW_SHOW);

    {$ENDIF}

    ReadLn;
  finally
    LServer.Free;
  end;
end;

begin
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    RunServer(8080);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end

end.