unit ULogDownload;

interface

type
  TLogDownload = class
  private
    FCodigo: Double;
    FUrl: String;
    FDataInicio : TDateTime;
    FDataFim : TDateTime;
  public
    constructor Create();overload;
    constructor Create(AUrl: String; ADataInicio, ADataFim : TDateTime);overload;

    destructor Destroy();

    property Codigo: Double read FCodigo write FCodigo;
    property Url: String read FUrl write FUrl;
    property DataInicio: TDateTime read FDataInicio write FDataInicio;
    property DataFim: TDateTime read FDataFim write FDataFim;

    procedure pLimparDados();
    procedure pCopiarDados(AObj: TLogDownload);
  end;

implementation

{ TLogDownload }

constructor TLogDownload.Create;
begin
  pLimparDados();
  inherited;
end;

constructor TLogDownload.Create(AUrl: String; ADataInicio, ADataFim: TDateTime);
begin
  self.FUrl := AUrl;
  self.FDataInicio := ADataInicio;
  self.FDataFim := ADataFim;
end;

destructor TLogDownload.Destroy;
begin
  inherited;
end;

procedure TLogDownload.pCopiarDados(AObj: TLogDownload);
begin
  Codigo:= AObj.Codigo;
  Url:= AObj.Url;
  DataInicio := AObj.DataInicio;
  DataFim := AObj.DataFim;
end;

procedure TLogDownload.pLimparDados;
begin
  Codigo:= 0;
  Url:= '';
  DataInicio := 0;
  DataFim := 0;
end;

end.
