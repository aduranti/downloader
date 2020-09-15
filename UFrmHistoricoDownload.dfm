object frmHistoricoDownload: TfrmHistoricoDownload
  Left = 0
  Top = 0
  Caption = 'Hist'#243'ricos de Downloads'
  ClientHeight = 398
  ClientWidth = 687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBnt: TPanel
    Left = 0
    Top = 349
    Width = 687
    Height = 49
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 152
    ExplicitWidth = 651
    object btnFechar: TButton
      Left = 296
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Fechar'
      ModalResult = 8
      TabOrder = 0
      OnClick = btnFecharClick
    end
  end
  object memoHistoricos: TMemo
    Left = 0
    Top = 0
    Width = 687
    Height = 349
    Align = alClient
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object cdsHistorico: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 496
    Top = 32
    object cdsHistoricocodigo: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'codigo'
    end
    object cdsHistoricoURL: TStringField
      FieldName = 'URL'
      Size = 600
    end
    object cdsHistoricoDataInicio: TDateField
      FieldName = 'DataInicio'
    end
    object cdsHistoricoDataFim: TDateField
      FieldName = 'DataFim'
    end
  end
  object dsHistorico: TDataSource
    DataSet = cdsHistorico
    Left = 512
    Top = 104
  end
end
