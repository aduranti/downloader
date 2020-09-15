object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Downloader'
  ClientHeight = 138
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblLink: TLabel
    Left = 15
    Top = 8
    Width = 92
    Height = 13
    Caption = 'Link para download'
  end
  object edLink: TEdit
    Left = 15
    Top = 27
    Width = 706
    Height = 21
    TabOrder = 0
    Text = 
      'https://az764295.vo.msecnd.net/stable/78a4c91400152c0f27ba4d363e' +
      'b56d2835f9903a/VSCodeUserSetup-x64-1.43.0.exe'
  end
  inline frameProgressBar: TframeProgressBar
    Left = 8
    Top = 54
    Width = 734
    Height = 26
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = 54
    ExplicitWidth = 734
    inherited ProgressBar: TProgressBar
      Left = 7
      Width = 706
      Height = 10
      ExplicitLeft = 7
      ExplicitWidth = 706
      ExplicitHeight = 10
    end
  end
  object pnlBnt: TPanel
    Left = 0
    Top = 82
    Width = 750
    Height = 56
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 123
    ExplicitWidth = 769
    object btnHistorico: TButton
      Left = 551
      Top = 14
      Width = 170
      Height = 25
      Caption = 'Exibir hist'#243'rico de downloads'
      TabOrder = 0
      OnClick = btnHistoricoClick
    end
    object btnExibirMensagem: TButton
      Left = 367
      Top = 14
      Width = 170
      Height = 25
      Caption = 'Exibir mensagem'
      TabOrder = 1
      OnClick = btnExibirMensagemClick
    end
    object btnParar: TButton
      Left = 191
      Top = 14
      Width = 170
      Height = 25
      Caption = 'Parar download'
      TabOrder = 2
      OnClick = btnPararClick
    end
    object btnInicial: TButton
      Left = 15
      Top = 14
      Width = 170
      Height = 25
      Caption = 'Iniciar Download'
      TabOrder = 3
      OnClick = btnInicialClick
    end
  end
  object SaveDialog: TSaveDialog
    Left = 456
    Top = 40
  end
end
