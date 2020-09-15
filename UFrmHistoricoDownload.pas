unit UFrmHistoricoDownload;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.DB, Datasnap.DBClient, ULogDownloadDAO,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.SQLite;

type
  TfrmHistoricoDownload = class(TForm)
    pnlBnt: TPanel;
    btnFechar: TButton;
    cdsHistorico: TClientDataSet;
    dsHistorico: TDataSource;
    cdsHistoricocodigo: TIntegerField;
    cdsHistoricoURL: TStringField;
    cdsHistoricoDataInicio: TDateField;
    cdsHistoricoDataFim: TDateField;
    memoHistoricos: TMemo;

    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FLogDownloadDAO: TLogDownloadDAO; //TObjectList<TLogDownload>
    procedure PreencherMemo;
  public
    { Public declarations }
  end;

var
  frmHistoricoDownload: TfrmHistoricoDownload;

implementation

uses
  System.RTTI, ULogDownload, System.Generics.Collections;

{$R *.dfm}

procedure TfrmHistoricoDownload.btnFecharClick(Sender: TObject);
begin
  close;
end;

procedure TfrmHistoricoDownload.FormShow(Sender: TObject);
begin
  PreencherMemo;
end;

procedure TfrmHistoricoDownload.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  frmHistoricoDownload := nil;
end;

procedure TfrmHistoricoDownload.FormCreate(Sender: TObject);
begin
  FLogDownloadDAO:=  TLogDownloadDAO.Create;
end;

procedure TfrmHistoricoDownload.PreencherMemo();
var
  LogDownload: TLogDownload;
  ListaHistoricos: TObjectList<TLogDownload>;
begin
  try
    ListaHistoricos := FLogDownloadDAO.Search();

    for LogDownload in ListaHistoricos do
    begin
      memoHistoricos.Lines.Add('Código: ' + FloatToStr(LogDownload.Codigo));
      memoHistoricos.Lines.Add('URL: '+ LogDownload.Url);
      memoHistoricos.Lines.Add('Data Inicial: ' + DateTimeToStr(LogDownload.DataInicio) + '    ' +
                               'Data Final: ' + DateTimeToStr(LogDownload.DataFim));
      memoHistoricos.Lines.Add('=================================================================');
      memoHistoricos.Lines.Add('');
    end;

  finally
    FreeAndNil(ListaHistoricos);
  end;
end;

end.
