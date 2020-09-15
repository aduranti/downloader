unit UIObserver;

interface


type
  TNotificacao = record
    PercentualDownload: integer;
    Finalizado: boolean;
  end;

type
  IObserver = interface
    ['{24560D9B-A582-488F-A7E4-AE0AC136CF4A}']
    procedure Atualizar(Notificacao: TNotificacao);
  end;

implementation

end.
