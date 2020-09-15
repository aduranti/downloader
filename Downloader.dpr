program Downloader;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {frmPrincipal},
  UHttpDownloader in 'UHttpDownloader.pas',
  UIObserver in 'interfaces\UIObserver.pas',
  UISubject in 'interfaces\UISubject.pas',
  UFrameProgressBar in 'UFrameProgressBar.pas' {frameProgressBar: TFrame},
  UFrmHistoricoDownload in 'UFrmHistoricoDownload.pas' {frmHistoricoDownload},
  UConnection in 'dao\UConnection.pas',
  ULogDownload in 'dao\ULogDownload.pas',
  ULogDownloadDAO in 'dao\ULogDownloadDAO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
