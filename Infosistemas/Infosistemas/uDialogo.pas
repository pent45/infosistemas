unit uDialogo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uPrincipal, uRotinasGerais, Buttons;

type
  TfrmDialogo = class(TForm)
    pnlDialogo: TPanel;
    lblDialogo: TLabel;
    pnlInferior: TPanel;
    spdBotaoNao: TSpeedButton;
    spdBotaoSim: TSpeedButton;
    lblLegendaNao: TLabel;
    lblLegendaSim: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure spdBotaoNaoClick(Sender: TObject);
    procedure spdBotaoSimClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Resultado: TModalResult;
  end;

var
  frmDialogo: TfrmDialogo;

implementation

{$R *.dfm}

procedure TfrmDialogo.FormCreate(Sender: TObject);
begin
  Resultado := mrCancel;
end;

procedure TfrmDialogo.FormShow(Sender: TObject);
begin
  {Ajustar Janela, Caso Esteja Rodando Em Navegador Web:}
  frmPrincipal.AjustarDimensoesPanelFundoComFormParent( pnlDialogo );

  Left := Round( ( Screen.Width - Width ) / 2 );
  Top := Round( ( Screen.Height - Height ) / 2 );
end;

procedure TfrmDialogo.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      spdBotaoSimClick( Self );
    VK_ESCAPE:
      spdBotaoNaoClick( Self );
  end;
end;

procedure TfrmDialogo.spdBotaoNaoClick(Sender: TObject);
begin
  Resultado := mrNo;
  Close;
end;

procedure TfrmDialogo.spdBotaoSimClick(Sender: TObject);
begin
  Resultado := mrYes;
  Close;
end;

end.
