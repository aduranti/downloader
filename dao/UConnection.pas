unit UConnection;

interface

uses
  SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, Data.DB, FireDAC.Comp.Client,
  IWSystem;

type
  TConnection = class
  strict private
    class var FInstance: TConnection;
    constructor CreatePrivate;
  private
    FConnection: TFDConnection;
  public
    property Connection: TFDConnection read FConnection write FConnection;

    procedure StartTransaction();
    procedure RollbackTransaction();
    procedure CommitTransaction();

    function fConectar(var Error: String): Boolean;
    class function GetInstance: TConnection;
  end;

implementation

{ TConnection }

procedure TConnection.CommitTransaction;
begin
  FConnection.Commit;
end;

function TConnection.fConectar(var Error: String): Boolean;
begin
  Result := False;
  try
    FConnection.Connected := False;
    with FConnection.Params do
    begin
      Database := gsAppPath + 'Downloader.db';
      DriverID := 'SQLite';
    end;
    FConnection.Connected := True;
    Result := FConnection.Connected;
  except
    on E:Exception do
    begin
      Result := False;
      Error := 'Houve um problema ao conectar ao banco: ' + #13 + E.Message;
    end;
  end;
end;

constructor TConnection.CreatePrivate;
var
  Error: String;
begin
  inherited Create;
  FConnection := TFDConnection.Create(nil);
  if not (fConectar(Error)) then
    raise Exception.Create(Error);
end;

class function TConnection.GetInstance: TConnection;
begin
  if not Assigned(FInstance) then
    FInstance := TConnection.CreatePrivate;
  Result := FInstance;
end;

procedure TConnection.RollbackTransaction;
begin
  FConnection.Rollback;
end;

procedure TConnection.StartTransaction;
begin
  if not FConnection.InTransaction then
    FConnection.StartTransaction;
end;

end.
