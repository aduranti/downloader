unit UHttpDownloader;

interface

uses
 Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
 System.SysUtils, Vcl.Forms, System.Types,
 IdSSLOpenSSL, IdSSL, IdSSLOpenSSLHeaders, IdCTypes, UISubject, UIObserver, System.Generics.Collections,
  ULogDownload, ULogDownloadDAO;


type
  THttpDownloader = class(TIdHTTP, ISubject)
    private
      FProgress: Integer;
      FBytesToTransfer: Int64;
      FOnChange: TNotifyEvent;
      FObservers: TList<IObserver>;
      FFinalizado: Boolean;
      FCancel: boolean;
      FLogDownload: TLogDownload;
      FLogDownloadDAO: TLogDownloadDAO;
      procedure WorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
      procedure Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
      procedure WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
      procedure SetProgress(const Value: Integer);
      procedure SetOnChange(const Value: TNotifyEvent);
      procedure OnStatusInfoEx(ASender: TObject; const AsslSocket: PSSL; const AWhere, Aret: TIdC_INT;
                const AType, AMsg: String);
    public
      constructor Create(AOwner: TComponent);
      procedure DownloadArquivo(const Origem: string; const Destino: String);
      function isConectadeInternet():boolean;
      procedure AdicionarObserver(Observer: IObserver);
      procedure RemoverObserver(Observer: IObserver);
      procedure Notificar;
   published
      property Progress: Integer read FProgress write SetProgress;
      property BytesToTransfer: Int64 read FBytesToTransfer;
      property OnChange: TNotifyEvent read FOnChange write SetOnChange;
      property Cancel: boolean read FCancel write FCancel;
  end;

implementation

uses
  WinInet;

{ THttpDownloader }

procedure THttpDownloader.AdicionarObserver(Observer: IObserver);
begin
  FObservers.Add(Observer);
end;

constructor THttpDownloader.Create(AOwner: TComponent);
begin
  FObservers := TList<IObserver>.Create;
  IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  with IOHandler as TIdSSLIOHandlerSocketOpenSSL do begin
    OnStatusInfoEx := Self.OnStatusInfoEx;
    SSLOptions.Method := sslvSSLv23;
    SSLOptions.SSLVersions := [sslvTLSv1_2, sslvTLSv1_1, sslvTLSv1];
  end;

  OnWork := Work;
  OnWorkBegin := WorkBegin;
  OnWorkEnd := WorkEnd;
  inherited Create(AOwner);
end;

procedure THttpDownloader.DownloadArquivo(const Origem, Destino: String);
var
  LDestStream: TFileStream;
  aPath: String;
begin
  Progress := 0;
  FBytesToTransfer := 0;

  if Assigned(FLogDownloadDAO) then
    FreeAndNil(FLogDownloadDAO);

  FLogDownloadDAO:= TLogDownloadDAO.Create;


  if Assigned(FLogDownload) then
    FreeAndNil(FLogDownload);

  FLogDownload := TLogDownload.Create;
  FLogDownload.Url := Origem;
  FLogDownload.Codigo := FLogDownloadDAO.GetKeyValue;



  aPath := ExtractFilePath(Destino);
  if aPath <> '' then
    ForceDirectories(aPath);

  LDestStream := TFileStream.Create(Destino, fmCreate);
  try
    Get(Origem, LDestStream);
  finally
    FreeAndNil(LDestStream);
    FLogDownloadDAO.Insert(FLogDownload);
  end;
end;

function THttpDownloader.isConectadeInternet: boolean;
var
  Flags: DWORD;
begin
  result := InternetGetConnectedState(@Flags, 0);
end;

procedure THttpDownloader.Notificar;
var
  Notificacao: TNotificacao;
  Observer: IObserver;
begin
  Notificacao.PercentualDownload := Progress;
  Notificacao.Finalizado := (Progress = 100);
  for Observer in FObservers do
  begin
    Observer.Atualizar(Notificacao);
  end;
end;

procedure THttpDownloader.OnStatusInfoEx(ASender: TObject;
  const AsslSocket: PSSL; const AWhere, Aret: TIdC_INT; const AType,
  AMsg: String);
begin
  SSL_set_tlsext_host_name(AsslSocket, Request.Host);
end;

procedure THttpDownloader.RemoverObserver(Observer: IObserver);
begin
  FObservers.Delete(FObservers.IndexOf(Observer));
end;

procedure THttpDownloader.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure THttpDownloader.SetProgress(const Value: Integer);
begin
  FProgress := Value;
  if Assigned(FOnChange) then
    FOnChange(Self);

  Notificar;
end;

procedure THttpDownloader.Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  { Evento interno responsável por informar o progresso atual }
  if BytesToTransfer = 0 then // No Update File
    Exit;

  Progress := Round((AWorkCount / BytesToTransfer) * 100);

  if FCancel then
  begin
    FCancel := False;
    Abort;
  end;

end;

procedure THttpDownloader.WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
   FBytesToTransfer := AWorkCountMax;
   FLogDownload.DataInicio := now;
end;

procedure THttpDownloader.WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  FBytesToTransfer := 0;
  Progress := 100;
  FLogDownload.DataFim := now;
end;

end.
