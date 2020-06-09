unit uImprimirDefinirOrientacaoImpressao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, jpeg, uRotinasGerais, Buttons;

type
  TfrmImprimirDefinirOrientacaoImpressao = class(TForm)
    pnlImprimirDefinirOrientacaoImpressao: TPanel;
    pnlSuperior: TPanel;
    shpRetrato: TShape;
    imgRetrato: TImage;
    shpPaisagem: TShape;
    imgPaisagem: TImage;
    lblEscolha: TLabel;
    rdbPaisagem: TRadioButton;
    rdbRetrato: TRadioButton;
    pnlInferior: TPanel;
    spdBotaoNao: TSpeedButton;
    lblLegendaNao: TLabel;
    spdBotaoSim: TSpeedButton;
    lblLegendaSim: TLabel;
    procedure shpRetratoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shpPaisagemMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgRetratoDblClick(Sender: TObject);
    procedure imgPaisagemDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure shpRetratoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure shpPaisagemMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure rdbRetratoClick(Sender: TObject);
    procedure rdbPaisagemClick(Sender: TObject);
    procedure shpRetratoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shpPaisagemMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure spdBotaoNaoClick(Sender: TObject);
    procedure spdBotaoSimClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmImprimirDefinirOrientacaoImpressao: TfrmImprimirDefinirOrientacaoImpressao;

implementation

uses
  uPrincipal;

{$R *.DFM}

procedure TfrmImprimirDefinirOrientacaoImpressao.shpRetratoMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  rdbRetrato.Checked := True;
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.shpPaisagemMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  rdbPaisagem.Checked := True;
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.imgRetratoDblClick(
  Sender: TObject);
begin
  rdbRetrato.Checked := True;
  ModalResult := mrOK;

  spdBotaoSimClick( Sender );
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.imgPaisagemDblClick(
  Sender: TObject);
begin
  rdbPaisagem.Checked := True;
  ModalResult := mrOK;

  spdBotaoSimClick( Sender );
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.FormCreate(
  Sender: TObject);
begin
  {Preparar Opções De Acordo Com As Últimas Que Foram Feitas Pelo Usuário:}
  if ( Configuracao_Inicial_Listagem_Orientacao_Padrao = 0 ) then
    rdbRetrato.Checked := True
  else
    rdbPaisagem.Checked := True;

  pnlSuperior.Color := CorParteSuperiorFormsDialogoComuns;
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.shpRetratoMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  shpRetrato.Pen.Style := psDash;
  shpRetrato.Brush.Color := clLime;

  shpPaisagem.Pen.Style := psClear;
  shpPaisagem.Brush.Color := clGreen;

  rdbRetrato.Checked := True;
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.shpPaisagemMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  shpRetrato.Pen.Style := psClear;
  shpRetrato.Brush.Color := clGreen;

  shpPaisagem.Pen.Style := psDash;
  shpPaisagem.Brush.Color := clLime;

  rdbPaisagem.Checked := True;
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.rdbRetratoClick(
  Sender: TObject);
begin
  shpRetrato.Pen.Style := psDash;
  shpRetrato.Brush.Color := clLime;

  shpPaisagem.Pen.Style := psClear;
  shpPaisagem.Brush.Color := clGreen;
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.rdbPaisagemClick(
  Sender: TObject);
begin
  shpRetrato.Pen.Style := psClear;
  shpRetrato.Brush.Color := clGreen;

  shpPaisagem.Pen.Style := psDash;
  shpPaisagem.Brush.Color := clLime;
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.shpRetratoMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  imgRetratoDblClick( Sender );
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.shpPaisagemMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  imgPaisagemDblClick( Sender );
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.FormShow(Sender: TObject);
begin
  {Ajustar Janela, Caso Esteja Rodando Em Navegador Web:}
  frmPrincipal.AjustarDimensoesPanelFundoComFormParent( pnlImprimirDefinirOrientacaoImpressao );

  Left := Round( ( Screen.Width - Width ) / 2 );
  Top := Round( ( Screen.Height - Height ) / 2 );
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.spdBotaoNaoClick(
  Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmImprimirDefinirOrientacaoImpressao.spdBotaoSimClick(
  Sender: TObject);
begin
  {Gravar As Opções Feitas Pelo Usuário Para Utiliza-las Como Padrão Na Próxima Utilização:}
  if ( rdbRetrato.Checked ) then
    Configuracao_Inicial_Listagem_Orientacao_Padrao := 0
  else
    Configuracao_Inicial_Listagem_Orientacao_Padrao := 1;
  GravarConfiguracaoInicial;

  ModalResult := mrOK;
end;

end.
