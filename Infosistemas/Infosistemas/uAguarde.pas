unit uAguarde;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uPrincipal, uRotinasGerais, Buttons,
  GIFImage, jpeg, pngimage;

type
  TfrmAguarde = class(TForm)
    pnlAguarde: TPanel;
    imgAguarde: TImage;
    procedure FormShow(Sender: TObject);
    procedure LigarDesligarFormMensagemAguarde(
      Ligar: Boolean;
      var FormQueEstaPorBaixo: TForm );
    procedure TravarAtualizacaoTela;
    procedure DestravarAtualizacaoTela;
  private
    { Private declarations }
  public
    { Public declarations }
    Resultado: TModalResult;
  end;

var
  frmAguarde: TfrmAguarde;

implementation

{$R *.dfm}

procedure TfrmAguarde.FormShow(Sender: TObject);
begin
  {Ajustar Janela, Caso Esteja Rodando Em Navegador Web:}
  frmPrincipal.AjustarDimensoesPanelFundoComFormParent( pnlAguarde );

  Left := Round( ( Screen.Width - Width ) / 2 );
  Top := Round( ( Screen.Height - Height ) / 2 );
end;

procedure TfrmAguarde.LigarDesligarFormMensagemAguarde(
  Ligar: Boolean;
  var FormQueEstaPorBaixo: TForm );
begin
  if ( frmAguarde.Visible <> Ligar ) then
  begin
    frmAguarde.Visible := Ligar;
    frmAguarde.Repaint;

    if Ligar then
    begin
      TravarAtualizacaoTela;
    end
    else
    begin
      DestravarAtualizacaoTela;

      if ( FormQueEstaPorBaixo <> Nil ) then
      begin
        FormQueEstaPorBaixo.SetFocus;
      end;
    end;
  end;
end;

procedure TfrmAguarde.TravarAtualizacaoTela;
begin
  {Na Linha Abaixo, Se Pode Usar o Comando "SendMessage", Que Aguarda Na Fila De Mensagens
   Pela Sua Vez De Ser Executado, Ou o Comando "PostMessage", Que Envia a Mensagem De Modo
   Imediato. Em Tese o "PostMessage" Seria Então Mais Adequado Para a Finalidade Desejada.
   Contudo, Observou-se Problemas Com o Uso Desta Forma Quando a Aplicação Está Sendo
   Executada Em Modo Web:}
  SendMessage( Application.Handle, WM_SETREDRAW, WPARAM( False ), 0 );
end;

procedure TfrmAguarde.DestravarAtualizacaoTela;
begin
  {Na Linha Abaixo, Se Pode Usar o Comando "SendMessage", Que Aguarda Na Fila De Mensagens
   Pela Sua Vez De Ser Executado, Ou o Comando "PostMessage", Que Envia a Mensagem De Modo
   Imediato. Em Tese o "PostMessage" Seria Então Mais Adequado Para a Finalidade Desejada.
   Contudo, Observou-se Problemas Com o Uso Desta Forma Quando a Aplicação Está Sendo
   Executada Em Modo Web:}
  SendMessage( Application.Handle, WM_SETREDRAW, WPARAM( True ), 0 );
end;

end.
