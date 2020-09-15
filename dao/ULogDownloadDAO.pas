unit ULogDownloadDAO;

interface

uses
  Uni, SysUtils, Contnrs, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, ULogDownload, FireDAC.Comp.Client,
  FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Intf,  generics.collections;

type
  TLogDownloadDAO = class
  protected
    FQry: TFDQuery;
  private
    procedure SetParametros(AObj: TLogDownload; AInsert: Boolean);
    procedure SetFields(AObj: TLogDownload);
    function CreateQry: TFDQuery;
  public
    function GetKeyValue(): Integer;
    function Insert(var AObj: TLogDownload): Boolean;
    function Update(AObj: TLogDownload): Boolean;
    function Delete(AObj: TLogDownload): Boolean;
    function Search(ACod: Double = 0): TObjectList<TLogDownload>;
  end;

implementation

uses
 UConnection;

function TLogDownloadDAO.CreateQry: TFDQuery;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  qry.Connection := TConnection.GetInstance.Connection;
  qry.SQL.Clear;
  Result := qry;
end;

function TLogDownloadDAO.Delete(AObj: TLogDownload): Boolean;
begin
  Result := True;
  if FQry <> nil then
    FreeAndNil(FQry);
  FQry := CreateQry;
  try
    FQry.SQL.Add('DELETE LogDownload');
    FQry.SQL.Add(' WHERE codigo = :codigo');

    FQry.ParamByName('codigo').AsFloat  := AObj.Codigo;

    FQry.ExecSQL;
    FQry.Close;
  except
    on e: Exception do
      begin
        Result := False;
        raise Exception.Create(e.Message);
      end;
  end;
  FreeAndNil(FQry);
end;

function TLogDownloadDAO.GetKeyValue(): Integer;
begin
  Result := 0;
  if FQry <> nil then
    FreeAndNil(FQry);
  FQry := CreateQry;
  try
    FQry.SQL.Add('SELECT coalesce(MAX(codigo),0) ultimo_codigo FROM logdownload');
    FQry.Open;
    Result := FQry.FieldByName('ultimo_codigo').AsInteger + 1 ;
    FQry.Close;
  except
    on e: Exception do
      begin
        Result := 0;
        raise Exception.Create(e.Message);
      end;
  end;
  FreeAndNil(FQry);
end;

function TLogDownloadDAO.Insert(var AObj: TLogDownload): Boolean;
begin
  Result := True;
  if FQry <> nil then
    FreeAndNil(FQry);
  FQry := CreateQry;
  try
    FQry.SQL.Add('INSERT INTO logdownload');
    FQry.SQL.Add('(codigo, url, datainicio, datafim)');
    FQry.SQL.Add('VALUES');
    FQry.SQL.Add('(:codigo, :url, :datainicio, :datafim)');

    SetParametros(AObj, true);

    FQry.ExecSQL;
    FQry.Close;
  except
    on e: Exception do
      begin
        Result := False;
        raise Exception.Create(e.Message);
      end;
  end;
  FreeAndNil(FQry);
end;

function TLogDownloadDAO.Search(ACod: Double): TObjectList<TLogDownload>;
var
  obj: TLogDownload;
begin
  Result := TObjectList<TLogDownload>.Create;
  if FQry <> nil then
    FreeAndNil(FQry);
  FQry := CreateQry;
  try
    FQry.SQL.Add('SELECT *');
    FQry.SQL.Add('  from logdownload');
    FQry.SQL.Add(' where 1=1');

    if (ACod > 0) then
      begin
        FQry.SQL.Add('and codigo = :codigo');
        FQry.ParamByName('codigo').AsFloat := ACod;
      end;

    FQry.SQL.Add('order by codigo');

    FQry.Open;
    while ( not FQry.Eof ) do
      begin
        obj := TLogDownload.Create;
        SetFields(obj);
        Result.Add(obj);
        FQry.Next;
      end;
    FQry.Close;
  except
    on e: Exception do
      begin
        Result := nil;
        raise Exception.Create(e.Message);
      end;
  end;
  FreeAndNil(FQry);

end;

procedure TLogDownloadDAO.SetFields(AObj: TLogDownload);
begin
  AObj.Codigo := FQry.FieldByName('codigo').AsFloat;
  AObj.Url := FQry.FieldByName('url').AsString;
  AObj.Datainicio := StrToDateTime(FQry.FieldByName('datainicio').AsString);
  AObj.Datafim := StrToDateTime(FQry.FieldByName('datafim').AsString);
end;

procedure TLogDownloadDAO.SetParametros(AObj: TLogDownload; AInsert: Boolean);
begin
  inherited;

  if AInsert then
    FQry.ParamByName('codigo').AsFloat := AObj.Codigo;

  FQry.ParamByName('url').AsString := AObj.Url;
  FQry.ParamByName('datainicio').AsString := FormatDateTime('YYYY-MM-DD hh:mm:ss', AObj.Datainicio);
  FQry.ParamByName('datafim').AsString := FormatDateTime('YYYY-MM-DD hh:mm:ss', AObj.Datafim);
end;

function TLogDownloadDAO.Update(AObj: TLogDownload): Boolean;
begin
  Result := True;
  if FQry <> nil then
    FreeAndNil(FQry);
  FQry := CreateQry;
  try
    FQry.SQL.Add('UPDATE logdownload SET');
    FQry.SQL.Add('url = :url, datainicio = :datainicio, datafim = :datafim');
    FQry.SQL.Add('WHERE codigo = :codigo');

    FQry.ParamByName('codigo').AsFloat  := AObj.Codigo;

    SetParametros(AObj, false);

    FQry.ExecSQL;
    FQry.Close;
  except
    on e: Exception do
      begin
        Result := False;
        raise Exception.Create(e.Message);
      end;
  end;
  FreeAndNil(FQry);
end;

end.
