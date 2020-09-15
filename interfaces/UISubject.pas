unit UISubject;

interface

uses
  UIObserver;

type
  ISubject = interface
    ['{A63BAFC4-65D4-459B-A30E-7591131070F3}']
    procedure AdicionarObserver(Observer: IObserver);
    procedure RemoverObserver(Observer: IObserver);
    procedure Notificar;
  end;

implementation

end.
