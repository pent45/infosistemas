unit uLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Jpeg, StdCtrls, DBXpress, DB, SqlExpr, FMTBcd, StrUtils,
  uRotinasGerais, Buttons;

type
  TfrmLogin = class(TForm)
    pnlDialogoLogin: TPanel;
    pnlBotaoSair: TPanel;
    sqlConnectionUsuariosLogin: TSQLConnection;
    imgDialogoLogin: TImage;
    lblUsuario: TLabel;
    edtUsuario: TEdit;
    lblSenha: TLabel;
    edtSenha: TEdit;
    lblAlertaCapsLock: TLabel;
    spdBotaoEntrar: TSpeedButton;
    lblLegendaSim: TLabel;
    sqlQueryUsuarios: TSQLQuery;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    function ConferirAutenticacaoUsuarioComSenhaDataValidadePermissao(
      Usuario, Senha: String;
      Codigo_Permissao: Integer ): Boolean;
    function ConferirAutenticacaoUsuarioComPermissao(
      Codigo_Permissao: Integer ): Boolean;
    function AutenticarUsuario(
      Usuario, Senha: String ): Boolean;
    procedure IdentificarUsuarioAdministradorSetandoSeusDadosParaLoginAutomaticoSeNaoForNavegadorWeb;
    procedure FormShow(Sender: TObject);
    procedure edtSenhaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pnlBotaoSairClick(Sender: TObject);
    procedure spdBotaoEntrarClick(Sender: TObject);
    procedure edtSenhaEnter(Sender: TObject);
    procedure edtSenhaExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UsuarioAutenticado: Boolean;
    ContadorDeTentativas: Integer;
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  uRotinasBancoDados, uPrincipal;

{$R *.dfm}

procedure TfrmLogin.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( Key = VK_RETURN ) then
    FindNextControl( ActiveControl, True, True, False ).SetFocus;
end;

function TfrmLogin.ConferirAutenticacaoUsuarioComSenhaDataValidadePermissao(
  Usuario, Senha: String;
  Codigo_Permissao: Integer ): Boolean;
var
  SenhaCorretaCadastrada: String;
  TextoOuChaveSenhaComCaracteresInvalidos: Boolean;
  Data_Validade: TDate;
  sqlQueryUsuarios: TSQLQuery;
begin
  Result := False;

  if ( Trim( Usuario ) <> '' ) then
  begin
    sqlQueryUsuarios := TSQLQuery.Create( Self );
    sqlQueryUsuarios.SQLConnection := sqlConnectionUsuariosLogin;

    sqlQueryUsuarios.Close;
    sqlQueryUsuarios.SQL.Clear;
    sqlQueryUsuarios.SQL.Add( 'SELECT' );
    sqlQueryUsuarios.SQL.Add( '  AU.GRUPO,' );
    sqlQueryUsuarios.SQL.Add( '  AU.USUARIO,' );
    sqlQueryUsuarios.SQL.Add( '  AU.SENHA,' );
    sqlQueryUsuarios.SQL.Add( '  AU.DATA_VALIDADE,' );
    sqlQueryUsuarios.SQL.Add( '  APC.CODIGO_PERMISSAO' );
    sqlQueryUsuarios.SQL.Add( 'FROM' );
    sqlQueryUsuarios.SQL.Add( '  ACESSO_USUARIOS AS AU,' );
    sqlQueryUsuarios.SQL.Add( '  ACESSO_PERMISSOESCONCEDIDAS AS APC' );
    sqlQueryUsuarios.SQL.Add( 'WHERE' );
    sqlQueryUsuarios.SQL.Add( '  AU.USUARIO = ' + QuotedStr( Usuario ) + ' AND' );
    sqlQueryUsuarios.SQL.Add( '  APC.CODIGO_PERMISSAO = ' + IntToStr( Codigo_Permissao ) +  ' AND' );
    sqlQueryUsuarios.SQL.Add( '  AU.GRUPO = APC.GRUPO' );
    sqlQueryUsuarios.Open;

    {Conferir Se o Usuário Existe:}
    if ( Usuario = sqlQueryUsuarios.FieldByName( 'USUARIO' ).AsString ) then
    begin
      {Conferir Se o Usuário Existente Está Com a Senha Correta:}
      SenhaCorretaCadastrada :=
        CriptografarDescriptografarSenhaUsandoChaveSimetrica(
          False,
          sqlQueryUsuarios.FieldByName( 'SENHA' ).AsString,
          ChavePadraoCriptograficaSimetricaParaSistemaAcessosPermissoes,
          TextoOuChaveSenhaComCaracteresInvalidos );
      if ( Senha = SenhaCorretaCadastrada ) then
      begin
        {Conferir Se o Usuário Existente e Com a Senha Correta Está Na Data de Validade Aceitável:}
        Data_Validade :=
          EncodeDate(
            StrToInt( RightStr( sqlQueryUsuarios.FieldByName( 'DATA_VALIDADE' ).AsString, 4 ) ),
            StrToInt( Copy( sqlQueryUsuarios.FieldByName( 'DATA_VALIDADE' ).AsString, 4, 2 ) ),
            StrToInt( LeftStr( sqlQueryUsuarios.FieldByName( 'DATA_VALIDADE' ).AsString, 2 ) ) );
        if ( Date <= Data_Validade ) then
        begin
          {Conferir Se o Usuário Existente, Com a Senha Correta e Na Data de Validade Aceitável, Tem a Permissão Necessária:}
          Result := ( Codigo_Permissao = sqlQueryUsuarios.FieldByName( 'CODIGO_PERMISSAO' ).AsInteger );
        end;
      end;
    end;

    sqlQueryUsuarios.Close;
    sqlQueryUsuarios.Free;
  end;
end;

function TfrmLogin.ConferirAutenticacaoUsuarioComPermissao(
  Codigo_Permissao: Integer ): Boolean;
begin
  sqlQueryUsuarios.SQL.Clear;
  sqlQueryUsuarios.SQL.Add( 'SELECT' );
  sqlQueryUsuarios.SQL.Add( '  AU.GRUPO,' );
  sqlQueryUsuarios.SQL.Add( '  AU.USUARIO,' );
  sqlQueryUsuarios.SQL.Add( '  APC.CODIGO_PERMISSAO,' );
  sqlQueryUsuarios.SQL.Add( '  AP.DESCRICAO' );
  sqlQueryUsuarios.SQL.Add( 'FROM' );
  sqlQueryUsuarios.SQL.Add( '  ACESSO_USUARIOS AS AU,' );
  sqlQueryUsuarios.SQL.Add( '  ACESSO_PERMISSOESCONCEDIDAS AS APC,' );
  sqlQueryUsuarios.SQL.Add( '  ACESSO_PERMISSOES AS AP' );
  sqlQueryUsuarios.SQL.Add( 'WHERE' );
  sqlQueryUsuarios.SQL.Add( '  AU.USUARIO = ' + QuotedStr( edtUsuario.Text ) + ' AND' );
  sqlQueryUsuarios.SQL.Add( '  APC.CODIGO_PERMISSAO = ' + IntToStr( Codigo_Permissao ) +  ' AND' );
  sqlQueryUsuarios.SQL.Add( '  AU.GRUPO = APC.GRUPO AND' );
  sqlQueryUsuarios.SQL.Add( '  APC.CODIGO_PERMISSAO = AP.CODIGO_PERMISSAO' );
  sqlQueryUsuarios.Open;

  {Conferir Se o Usuário Existente, Com a Senha Correta e Na Data de Validade Aceitável, Já Conferidos Antes,
   Tem a Permissão Necessária:}
  Result := ( Codigo_Permissao = sqlQueryUsuarios.FieldByName( 'CODIGO_PERMISSAO' ).AsInteger );

  {Gravar Log:}
  if Result then
    GravarLinhaNoLogHistoricoDeEventos( 'Concedido [' + sqlQueryUsuarios.FieldByName( 'DESCRICAO' ).AsString + ']' );
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  {Preparar Destaque Para Painéis Que Funcionam Como Botões Quando São Apontados Pelo Mouse:}
  pnlBotaoSair.PrepararDestaqueParaPanelQueFuncionaComoButtonDeSaidaQuandoForApontadoPeloMouse;

  UsuarioAutenticado := False;
  ContadorDeTentativas := 0;

  lblUsuario.Color := clDarkGoldenRod;
  lblSenha.Color := lblUsuario.Color;

  IdentificarUsuarioAdministradorSetandoSeusDadosParaLoginAutomaticoSeNaoForNavegadorWeb;
end;

function TfrmLogin.AutenticarUsuario(
  Usuario, Senha: String ): Boolean;
var
  NomeArquivoDados: String;
begin
  NomeArquivoDados := Trim( ExtractFilePath( Application.ExeName ) ) + 'Operacao\Dados_Gerais\BD_BASE.GDB';

  if not FileExists( NomeArquivoDados ) then
    frmPrincipal.ConverterNomeCompletoArquivoOperacaoParaOperacaoShared( NomeArquivoDados );

  ConectarBancoDados_IB_FB_SeJaNaoConectado(
    NomeArquivoDados,
    UsuarioBancoDados,
    SenhaBancoDados,
    sqlConnectionUsuariosLogin );

  UsuarioAutenticado :=
    ConferirAutenticacaoUsuarioComSenhaDataValidadePermissao(
    Usuario,
    Senha,
    4 );

  sqlConnectionUsuariosLogin.Close;

  Result := UsuarioAutenticado;
end;

procedure TfrmLogin.IdentificarUsuarioAdministradorSetandoSeusDadosParaLoginAutomaticoSeNaoForNavegadorWeb;
begin
  edtUsuario.Text := 'RUDOLFO';
  edtSenha.Text := 'lickme';
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  {Ajustar Janela, Caso Esteja Rodando Em Navegador Web:}
  frmPrincipal.AjustarDimensoesPanelFundoComFormParent( pnlDialogoLogin );

  lblUsuario.Top := edtUsuario.Top - lblUsuario.Height;
  lblSenha.Top := edtSenha.Top - lblSenha.Height;
end;

procedure TfrmLogin.edtSenhaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  lblAlertaCapsLock.Visible := CapsLockLigado;

  if ( Key = VK_RETURN ) then
    spdBotaoEntrarClick( Sender );
end;

procedure TfrmLogin.pnlBotaoSairClick(Sender: TObject);
begin
  try
    Close;
  except
    {Nada}
  end;
end;

procedure TfrmLogin.spdBotaoEntrarClick(Sender: TObject);
begin
  AutenticarUsuario( edtUsuario.Text, edtSenha.Text );
  ContadorDeTentativas := ContadorDeTentativas + 1;

  if not UsuarioAutenticado then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'Entrada Não Permitida Devido a Usuário Inexistente Ou Senha de Acesso Incorreta' + RetornoDeCarro( 01 ) +
      'Ou Fora da Data de Validade Ou Sem Permissão Válida Para Acesso.',
      '',
      '',
      'Prosseguir',
      False );
  end;

  if ( UsuarioAutenticado ) or ( ContadorDeTentativas >= 3 ) then
    Close;
end;

procedure TfrmLogin.edtSenhaEnter(Sender: TObject);
begin
  lblAlertaCapsLock.Visible := CapsLockLigado;
end;

procedure TfrmLogin.edtSenhaExit(Sender: TObject);
begin
  lblAlertaCapsLock.Visible := False;
end;

procedure TfrmLogin.FormResize(Sender: TObject);
begin
  frmPrincipal.AjustarDimensoesPanelFundoComFormParent( pnlDialogoLogin );
end;

end.
