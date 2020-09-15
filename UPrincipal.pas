unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, System.Threading,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, UFrameProgressBar,
  Vcl.ExtCtrls,UHttpDownloader, IWSystem;

type
  TfrmPrincipal = class(TForm)
    edLink: TEdit;
    lblLink: TLabel;
    frameProgressBar: TframeProgressBar;
    pnlBnt: TPanel;
    btnHistorico: TButton;
    btnExibirMensagem: TButton;
    btnParar: TButton;
    btnInicial: TButton;
    SaveDialog: TSaveDialog;
    procedure btnInicialClick(Sender: TObject);
    procedure btnExibirMensagemClick(Sender: TObject);
    procedure btnHistoricoClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FTask: ITask;
    FDownload: THttpDownloader;
    FDestino: string;
    function VerificaTaskAtiva: boolean;
    procedure DownloaArquivo;
    procedure ConfirmaFechamentoSistema(var Action: TCloseAction);
    procedure CancelaTask;
    procedure IniciarTask;
    function GetNameFileFromLink(Url: String): String;

  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
   UFrmHistoricoDownload;

{$R *.dfm}

procedure TfrmPrincipal.btnHistoricoClick(Sender: TObject);
begin
  if not Assigned(frmHistoricoDownload) then
    frmHistoricoDownload := TfrmHistoricoDownload.Create(Self);
  frmHistoricoDownload.Show;
end;

procedure TfrmPrincipal.btnInicialClick(Sender: TObject);
begin
  if ( Length( edLink.Text ) <= 0 ) then
    begin
      ShowMessage('Favor adicionar o link!');
      if edLink.CanFocus then edLink.SetFocus;
      Exit;
    end;

  SaveDialog.FileName := GetNameFileFromLink(trim(edLink.Text));
  if SaveDialog.Execute Then
  begin
    FDestino := SaveDialog.FileName;
    IniciarTask;
  end;

end;

procedure TfrmPrincipal.btnPararClick(Sender: TObject);
begin
  CancelaTask;
  frameProgressBar.ZeraProgressBar;
end;

function TfrmPrincipal.GetNameFileFromLink(Url: String): String;
var
   pos: ShortInt;
begin
   pos := LastDelimiter('/', Url);
   Result := Copy(url, pos + 1, MaxInt);
end;

procedure TfrmPrincipal.CancelaTask;
begin
  if VerificaTaskAtiva then
  begin
    FTask.Cancel;
    Fdownload.Cancel := true;
  end
  else
    ShowMessage('Não tem nenhum download sendo executado.');
end;

procedure TfrmPrincipal.IniciarTask;
begin
  FTask := TTask.Run(procedure
  begin
    DownloaArquivo;
  end);
end;

procedure TfrmPrincipal.ConfirmaFechamentoSistema(var Action: TCloseAction);
begin
  if VerificaTaskAtiva then
  begin
     if MessageDlg('Existe um download em andamento, deseja interrompe-lo? [Sim, Não]',mtConfirmation,[mbyes,mbno],0) = mryes then
     begin
       CancelaTask;
       Release;
     end
     else
       Action := caNone;
  end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ConfirmaFechamentoSistema(Action);
end;

procedure TfrmPrincipal.btnExibirMensagemClick(Sender: TObject);
begin
  ShowMessage('Download em andamento, '+ IntToStr(frameProgressBar.ProgressBar.Position) + '% completado.');
end;

procedure TfrmPrincipal.DownloaArquivo;
begin
  if not fdownload.isConectadeInternet then
  begin
    ShowMessage('Verifique a conexão com a internet.');
    exit;
  end;

  FDownload := THttpDownloader.Create(self);
  try
    FDownload.AdicionarObserver(frameProgressBar);
    FDownload.DownloadArquivo(trim(edLink.Text), FDestino);
    ShowMessage('Download Finalizado');
    frameProgressBar.ZeraProgressBar;
  finally
    FreeAndNil(FDownload);
  end;
end;

function TfrmPrincipal.VerificaTaskAtiva: boolean;
begin
  result := Assigned(FTask) and (FTask.Status = TTaskStatus.Running);
end;

end.
