unit UFrameProgressBar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UIObserver, Vcl.ComCtrls;

type
  TframeProgressBar = class(TFrame, IObserver)
    ProgressBar: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
    FProgress: integer;
    procedure Atualizar(Notificacao: TNotificacao);
    procedure ZeraProgressBar;
  end;

implementation

{$R *.dfm}

{ TframeProgressBar }

procedure TframeProgressBar.Atualizar(Notificacao: TNotificacao);
begin
  ProgressBar.Position := Notificacao.PercentualDownload;
end;

procedure TframeProgressBar.ZeraProgressBar;
begin
  ProgressBar.Position := 0;
end;

end.
