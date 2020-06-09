{

Este aplicativo foi escrito por Rudolfo Horner Jr em Junho de 2020 meramente como Teste em
processo da Infosistemas. Todas as Funções e Eventualmente Classes Foram Produzidas Exclusivamente
Pelo Autor, Assim Como Usuários e Senhas de Serviços Que São Do Seu Acesso Exclusivo.

Assim, nenhum dos códigos, funções, procedimentos, bancos de daods ou seus recursos poderão ser
utilizados para outros fins que não exclusivamente o Teste requisitado.

Rudolfo Horner Jr
Belo Horizonte, 09 / 06 / 2020

}

unit uPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, JPeg, uRotinasGerais, OleCtrls, ComCtrls, CommCtrl,
  Math, StrUtils, StdCtrls, Buttons, Colsel, DBXpress, DB, SqlExpr, uRotinasBancoDados,
  AppEvnts, VrControls, VrLabel, FMTBcd, XMLDoc, XMLIntf;

const
  {Sobre}
  NomeDestePrograma                                                     = 'Infosistemas CRUD Clientes';

  {Comunicações Mensagens Email SMTP}
  NomeUsuarioSMTPParaEnvioDeMensagensDeEmail                            = 'sitemonitor@melhorsoft.com';
  SenhaUsuarioSMTPParaEnvioDeMensagensDeEmail                           = 'r_34AgyZ_2dXy';
  NomeServidorSMTPParaEnvioDeMensagensDeEmail                           = 'smtp.melhorsoft.com';
  PortaServidorSMTPParaEnvioDeMensagensDeEmail                          = 587;
  ServidorSMTPExigeAutenticarUsuario                                    = True;
  ServidorSMTPExigeAutenticarSSL                                        = False;

  {Comunicações Mensagens Email Que Serão Copiadas}
  EnderecoEmailQueRecebeCopiaDasMensagensEnviadas                       = 'sitemonitormelhorsoft@gmail.com';
  SenhaEnderecoEmailQueRecebeCopiaDasMensagensEnviadas                  = 'sitemonitor';

  {Usuário e Senha Do Banco de Dados Padrão:}
  UsuarioBancoDados                                                     = 'SYSDBA';
  SenhaBancoDados                                                       = 'masterkey';

  {Cor De Fundo Da Parte Superior Dos "Forms" De Diálogo:}
  CorParteSuperiorFormsDialogoComuns                                    = TColor( $F2A78A );
  {Esta Cor Acima Equivale a "clCornFlowerBlue" Ajustada Com Um Pouco Mais De Claridade}

  {Logotipos De Negócios Usados Na Aplicação}
  Logo_QuantidadeTotalLogotiposExistentesPossiveis                      = 001;
  Logo_OrdemLogotipoPadraoInicial                                       = 000;

  {Outros}
  PolegadaEmMilimetro                                                   = 25.4;
  ChavePadraoCriptograficaSimetricaParaSistemaAcessosPermissoes         = '>!x#rC(?au~E&*Q-X@mkj)_N^fvS+=:<H/gO$\l|%';

type
  {O Componente TPageControl Utilizado Neste Form, Mesmo Quando Tem Suas "Tabs"
   Invisíveis, Apresenta Uma Borda de 04 Pixels Que Não Lhe Confere Um Aspecto "Flat"
   Perfeito. Assim, Realiza a Captura do Evento de Redimensionamento da Sua Classe de
   Origem Para Corrigir o Seu Aspecto Final Quando For Necessário:}
  TPageControl = class( ComCtrls.TPageControl )
  private
    procedure TCMAdjustRect( var Msg: TMessage ); message TCM_ADJUSTRECT;
  end;

  TfrmPrincipal = class(TForm)
    pnlPrincipal: TPanel;
    pnlSuperior: TPanel;
    pnlIntermediarioDireito: TPanel;
    imgLogotipo: TImage;
    pnlBotaoSair: TPanel;
    pgcPaginasApresentacoes: TPageControl;
    tshApresentacaoUm: TTabSheet;
    pnlApresentacaoUm: TPanel;
    pnlInferiorEsquerdo: TPanel;
    sqlConnection: TSQLConnection;
    pgcPaginasControles: TPageControl;
    tshControleUm: TTabSheet;
    pnlControleUm: TPanel;
    QueryColoracaoMapaShape: TSQLQuery;
    QueryParametrizadaBuscaShapeIndex: TSQLQuery;
    appAplicacaoEventos: TApplicationEvents;
    lblLegendaVersao: TVrLabel;
    opdImportarArquivoTexto: TOpenDialog;
    sqlConexaoPrincipal: TSQLConnection;
    spdCrudClientes: TSpeedButton;
    lblCrudClientes: TLabel;
    lblControles: TLabel;
    lblApresentacoes: TLabel;
    imgCliqueAqui: TImage;
    function AcionarFormProsseguir(
      Texto, CaptionDialogo, CaptionNegativo, CaptionPositivo: String;
      PrecisaAtencaoEspecial: Boolean ): TModalResult;
    function AcionarFormDialogoCrudClientes: TModalResult;
    procedure pnlBotaoSairClick(Sender: TObject);
    procedure ExecutarProvidenciasSistemicas_Entrada;
    procedure ExecutarProvidenciasSistemicas_Saida;
    procedure FormCreate(Sender: TObject);
    procedure MostrarMensagemImpossibilidadeAcessoServicoGoogleMaps;
    procedure MostrarMensagemErroAusenciaDeUmaImpressoraConfigurada;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ConverterNomeCompletoArquivoOperacaoParaOperacaoShared(
      var NomeCompletoArquivoComRota: String );
    procedure ConectarBancoDados(
      var sqlConnectionTrabalho: TSQLConnection;
      NomeArquivoBancoDados: String );

    function Logo_ResponderEspecificacoesLogotiposExistentesPossiveis(
      const IndiceLogotipoDesejado: Integer;
      const InformacaoDesejada: String ): String;
    function Logo_NomeBaseArquivoLogotipoConformeConfigurado: String;
    function Logo_EnderecoWebSiteConformeConfigurado: String;
    function Logo_EnderecoEmailRetornoConformeConfigurado: String;
    function Logo_InverterCorCarimbarGoogleMapsSateliteConformeConfigurado: Boolean;
    procedure Logo_CarregarLogotipoConformeConfigurado;
    procedure AjustarDimensoesPanelFundoComFormParent(
      Panel: TPanel );
    procedure AjustarDimensoesDosFormsMaximizadosDevidoRedimensionamentoDoBrowserNavegador(
      Sender: TObject;
      var Width, Height: Integer;
      var ResizeMaximized: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure appAplicacaoEventosException(Sender: TObject; E: Exception);
    function Pegar_ID_MapaShapeDoBancoDadosAtual: String;
    procedure spdCrudClientesClick(Sender: TObject);
    procedure imgLogotipoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NomeCompletoDestePrograma, NumeroVersao, NumeroCompletoVersao: String;
    UltimoMesAnoItemIndex: Integer;
    FatorReducaoIntensidadeMaximaComumParaTodosHeatMapsSaturacao: Integer;
  end;

var
  frmPrincipal: TfrmPrincipal;

  Configuracao_Inicial_Emails_Destinatarios, Configuracao_Inicial_SMSs_Destinatarios: WideString;
  Configuracao_Inicial_Listagem_Orientacao_Padrao, Configuracao_Inicial_Logotipo_Sequencial_Padrao: Integer;
  ComoEstavaDefinicao_IntelFloatingPointUnit_8087CW: Word;
  NomePastaParaArquivosTemporariosDestaSessao: String;

  {Identificação Dos Endereços IP e Locais De Acesso Da Rede Local e Do Servidor Web. Estas Variáveis
   Identificadores Não Podem Estar Dentro do Objeto "Form" Principal, Mas Em Variáveis Destacadas à
   Parte. Isto Porque Elas São Assinaladas Por Uma "Thread" De Identificação De Endereços Que é Disparada Na
   Abertura Da Execução Desta Aplicação. E Caso o Usuário Feche a Aplicação Imediatamente Após Abri-la, Pode
   Eventualmente Ocorrer Desta "Thread" De Identificação Ainda Estar Rodando e Fazendo Assim Referências a
   Identificadores Que Já Teriam Sido Destruídos Pelo Fechamento da Aplicação:}
  IPAcessoInternet, IPServidorWeb, LocalAcessoInternet, LocalServidorWeb: String;

implementation

uses
  uLogin, uDialogo, uDialogoCrudClientes, uAguarde;

{$R *.dfm}

procedure TPageControl.TCMAdjustRect( var Msg: TMessage );
begin
  {O Componente TPageControl Utilizado Neste Form, Mesmo Quando Tem Suas "Tabs"
   Invisíveis, Apresenta Uma Borda de 04 Pixels Que Não Lhe Confere Um Aspecto "Flat"
   Perfeito. Assim, Realiza a Captura do Evento de Redimensionamento da Sua Classe de
   Origem Para Corrigir o Seu Aspecto Final Quando For Necessário:}

  inherited;

  if Msg.WParam = 0 then
    InflateRect( PRect( Msg.LParam )^, + 4, + 4 )
  else
    InflateRect( PRect( Msg.LParam )^, - 4, - 4 );
end;

function TfrmPrincipal.AcionarFormProsseguir(
  Texto, CaptionDialogo, CaptionNegativo, CaptionPositivo: String;
  PrecisaAtencaoEspecial: Boolean ): TModalResult;
const
  DistanciaBotaoLegenda = 4;
var
  frmDialogo: TfrmDialogo;
  Esquerda1, Esquerda2: Integer;
begin
  frmDialogo := TfrmDialogo.Create( Self );

  frmDialogo.lblDialogo.WordWrap := False;
  frmDialogo.lblDialogo.Caption := RetornoDeCarro( 01 ) + Trim( Texto ) + RetornoDeCarro( 01 );
  frmDialogo.lblDialogo.WordWrap := True;

  frmDialogo.Caption := Trim( CaptionDialogo );

  if ( Trim( CaptionNegativo ) = '' ) then
  begin
    frmDialogo.lblLegendaNao.Visible := False;
    frmDialogo.spdBotaoNao.Visible := False;

    frmDialogo.lblLegendaSim.Caption := CaptionPositivo;
    frmDialogo.spdBotaoSim.Left :=
      Trunc( ( frmDialogo.pnlInferior.Width - frmDialogo.spdBotaoSim.Width - DistanciaBotaoLegenda - frmDialogo.lblLegendaSim.Width ) / 2 );
    frmDialogo.lblLegendaSim.Left :=
      frmDialogo.spdBotaoSim.Left + frmDialogo.spdBotaoSim.Width + DistanciaBotaoLegenda;
  end
  else
  begin
    frmDialogo.lblLegendaNao.Visible := True;
    frmDialogo.spdBotaoNao.Visible := True;

    frmDialogo.lblLegendaNao.Caption := CaptionNegativo;
    frmDialogo.spdBotaoNao.Left :=
      Trunc( ( frmDialogo.pnlInferior.Width / 2 - frmDialogo.spdBotaoNao.Width - DistanciaBotaoLegenda - frmDialogo.lblLegendaNao.Width ) / 2 );
    frmDialogo.lblLegendaNao.Left :=
      frmDialogo.spdBotaoNao.Left + frmDialogo.spdBotaoNao.Width + DistanciaBotaoLegenda;

    frmDialogo.lblLegendaSim.Caption := CaptionPositivo;
    frmDialogo.spdBotaoSim.Left :=
      Trunc( ( 3 * frmDialogo.pnlInferior.Width / 2 - frmDialogo.spdBotaoSim.Width - DistanciaBotaoLegenda - frmDialogo.lblLegendaSim.Width ) / 2 );
    frmDialogo.lblLegendaSim.Left :=
      frmDialogo.spdBotaoSim.Left + frmDialogo.spdBotaoSim.Width + DistanciaBotaoLegenda;
  end;

  frmDialogo.lblDialogo.Color := CorParteSuperiorFormsDialogoComuns;
  if PrecisaAtencaoEspecial then
  begin
    frmDialogo.Color := clRed;
    frmDialogo.lblDialogo.Color := frmDialogo.Color;
    frmDialogo.lblDialogo.Font.Color := clWhite;

    if ( frmDialogo.spdBotaoNao.Visible ) then
    begin
      {Como Esta Mensagem ao Usuário Requer Atenção Especial, No Caso De Haverem Duas
       Opções De Resposta, Inverte-as Em Relação a Forma Tradicional Para Forçar a Atenção:}
      Esquerda1 := frmDialogo.spdBotaoNao.Left;
      Esquerda2 := frmDialogo.lblLegendaNao.Left;
      frmDialogo.spdBotaoNao.Left := frmDialogo.spdBotaoSim.Left;
      frmDialogo.lblLegendaNao.Left := frmDialogo.lblLegendaSim.Left;
      frmDialogo.spdBotaoSim.Left := Esquerda1;
      frmDialogo.lblLegendaSim.Left := Esquerda2;
    end;
  end;
  frmDialogo.ShowModal;
  Result := frmDialogo.Resultado;
  frmDialogo.Release;
end;

procedure TfrmPrincipal.pnlBotaoSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.ExecutarProvidenciasSistemicas_Entrada;
begin
  {Na Criação Deste Form, Preservar o Estado Original do Controle de Ponto Flutuante da CPU e
   Seta-lo Para Um Estado Que Elimine a Possibilidade de Ocorrência de Divisão Por Zero, o Que
   Eventualmente Se Observa Na Primeira Carga de Shape File, Quando Executado Em Ambiente de
   Servidor Web:}
  ComoEstavaDefinicao_IntelFloatingPointUnit_8087CW := Get8087CW;
  Set8087CW( $133F );

  {Definir Padrão de Emulação Equivalente Ao Internet Explorer Versão 11 Para Componentes WebBrowsers Desta Aplicação:}
  SetarComponentesWebBrowserDestaAplicacaoComPadraoEmulacaoInternetExplorer11;

  {Prevenir Que Aplicação Esteja Rodando em Servidor Web Ou Desktop Que Não Esteja Configurado
   Regionalmente Para Caracteres de Separação de Milhares e Separação de Decimais no Padrão Brasileiro:}
  ThousandSeparator := '.';
  DecimalSeparator := ',';

  {Disparar Thread Para Identificar Números IP e Localização Física Aproximada Tanto da
   Estação Usuária Como Cliente Assim Como do Servidor Web, Caso Esteja Sendo Utilizado na Web:}
  IPAcessoInternet := '';
  LocalAcessoInternet := '';
  IPServidorWeb := '';
  LocalServidorWeb := '';
  TThreadIdentificarLocalizacaoEnderecosIPEmUso.Create( False );
  EsperarSegundos( 2, False );

  {Criar Diretório Para Processamento Temporário De Arquivos:}
  NomePastaParaArquivosTemporariosDestaSessao :=
    Trim( ExtractFilePath( Application.ExeName ) ) + 'Operacao\Temporario\User_' + FormatDateTime( 'yyyymmddhhmmsszzz', Now ) + '\';
  ForceDirectories( NomePastaParaArquivosTemporariosDestaSessao );
end;

procedure TfrmPrincipal.ExecutarProvidenciasSistemicas_Saida;
begin
  {Na Destruição Deste Form, Restabelecer o Estado Original do Controle de Ponto Flutuante da CPU
   Conforme Estava Setado No Momento de Criação do Form, Antes da Carga do Controle Shape File. Isto
   Porque Houve Necessidade de Eliminar a Possibilidade de Ocorrência de Divisão Por Zero, o Que
   Eventualmente Se Observa Na Primeira Carga de Shape File, Quando Executado Em Ambiente de
   Servidor Web:}
  Set8087CW( ComoEstavaDefinicao_IntelFloatingPointUnit_8087CW );

  {Apagar Pasta e Arquivos Temporários Que Possam Ter Sido Criados Durante a Execução Desta Sessão:}
  ApagarPasta( NomePastaParaArquivosTemporariosDestaSessao, False );
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  Posicao: Integer;
begin
  {Preparar Destaque Para Painéis Que Funcionam Como Botões Quando São Apontados Pelo Mouse:}
  pnlBotaoSair.PrepararDestaqueParaPanelQueFuncionaComoButtonDeSaidaQuandoForApontadoPeloMouse;

  {Linhas Estranhas Abaixo, Com Duplicação Da Setagem Da Active Page Para o Mapa Pais Shape,
   Antes e Ao Final Do Bloco, Destina-Se a Impedir Problemas de Execução Que Podem Ocorrer
   Quando, Ainda Em Tempo De Desenvolvimento, o Programa é Compilado Tendo Sido Deixada Como
   Página Inicial Default Alguma Outra Que Não Seja a Própria De Mapa Pais Shape, Que Ocorre
   Devido a Setagem Das Abas Das Pagínas Para Invisíveis Em Tempo de Execução:}
  pgcPaginasApresentacoes.ActivePage := tshApresentacaoUm;
  tshApresentacaoUm.TabVisible := False;
  pgcPaginasApresentacoes.ActivePage := tshApresentacaoUm;

  pgcPaginasControles.ActivePage := tshControleUm;
  tshControleUm.TabVisible := False;
  pgcPaginasControles.ActivePage := tshControleUm;

  {Inicializar Número De Versão Conforme Contida No Executável:}
  NumeroCompletoVersao := PegarVersaoDesteExecutavel;  // Pegar Versão Do Próprio Executável
  {Como a Versão Contida No Executável Contém VERSÃO, SUB-VERSÃO, RELEASE E BUILD, Cuida De
   Separar Apenas a Parte Inicial Que Contém VERSÃO e SUB-VERSÃO:}
  Posicao := Pos( '.', NumeroCompletoVersao );   // Pegar Primeiro Ponto, Que Separa Versão de Sub-Versão
  if ( Posicao > 0 ) then
  begin
    Posicao := PosEx( '.', NumeroCompletoVersao, Posicao + 1 );   // Pegar Segundo Ponto, Que Separa Sub-Versão de Release
    if ( Posicao > 0 ) then
      NumeroVersao := Trim( LeftStr( NumeroCompletoVersao, Posicao - 1 ) );
  end;

  {Mostrar Nome Do Programa e a Sua Versão Na Tela Inicial:}
  NomeCompletoDestePrograma := NomeDestePrograma + ' ' + NumeroVersao;
  frmPrincipal.Caption := NomeDestePrograma + ' v' + NumeroCompletoVersao;
  lblLegendaVersao.AutoSize := True;
  lblLegendaVersao.Caption := frmPrincipal.Caption;
  lblLegendaVersao.AutoSize := False;
  lblLegendaVersao.Left := pnlBotaoSair.Left + pnlBotaoSair.Width - lblLegendaVersao.Width;

  {Executar Providências Sistêmicas de Entrada da Aplicação. Elas Valem Para Todos Os
   Programas Deste Tipo e Definem a Relação Inicial Do Aplicativo Com o Sistema Oepracional
   E Com o Equipamento Computacional Que Está Fazendo a Sua Execução. São Setadas Na Entrada
   E Algumas Delas Precisam Ser Resetadas na Saída:}
  ExecutarProvidenciasSistemicas_Entrada;

  {Ler Configuração De Funcionamento Inicial Do Programa:}
  LerConfiguracaoInicial;
end;

procedure TfrmPrincipal.MostrarMensagemImpossibilidadeAcessoServicoGoogleMaps;
begin
  AcionarFormProsseguir(
    'Neste Momento Não Foi Possível Fazer Acesso ao Serviço Externo Google Maps.' + RetornoDeCarro( 02 ) +
    'Por Favor, Tente Novamente Mais Tarde e Verifique Se a Sua Conexão Com a' + RetornoDeCarro( 01 ) +
    'Internet Está Desimpedida, Estável e Com Desempenho Adequado.',
    '',
    '',
    'Prosseguir',
    False );
end;

procedure TfrmPrincipal.MostrarMensagemErroAusenciaDeUmaImpressoraConfigurada;
begin
  AcionarFormProsseguir(
    'Não é Possível Executar a Impressão Porque Não Há Nenhuma Impressora' + RetornoDeCarro( 01 ) +
    'Atualmente Instalada e Configurada.' + RetornoDeCarro( 02 ) +
    'Por Favor, Instale Uma Impressora, Ou Ao Menos Um Driver De Impressora,' + RetornoDeCarro( 01 ) +
    'Ainda Que Ela Não Esteja Fisicamente Instalada.',
    '',
     '',
     'Prosseguir',
     False );
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  if not frmLogin.UsuarioAutenticado then
  begin
    frmLogin.ShowModal;
    if not frmLogin.UsuarioAutenticado then
    begin
      Close;
      Exit;
    end;

    {Ajustar Janela, Caso Esteja Rodando Em Navegador Web:}
    AjustarDimensoesPanelFundoComFormParent( pnlPrincipal );

    {Gravar Log Histórico De Eventos:}
    GravarLinhaNoLogHistoricoDeEventos( 'Login' );
  end;
end;

procedure TfrmPrincipal.FormResize(Sender: TObject);
begin
  AjustarDimensoesPanelFundoComFormParent( pnlPrincipal );

  Logo_CarregarLogotipoConformeConfigurado;
end;

procedure TfrmPrincipal.ConverterNomeCompletoArquivoOperacaoParaOperacaoShared(
  var NomeCompletoArquivoComRota: String );
var
  ListaPath: TStringList;
  IndiceMudar: Integer;

  function MontaListaPath: String;
  var
    Cont: Integer;
  begin
    Result := '';
    for Cont := 0 to ListaPath.Count - 1 do
      Result := Result + ListaPath.Strings[ Cont ] + '\';
    Result := ExcludeTrailingPathDelimiter( Result );
  end;

begin
  {Eventualmente Alguns Arquivos Auxiliares Ao Funcionamento Deste Aplicativo Estarão
   Gravados Em Uma Sub Pasta Denominada "Operacao" Que Estará Gravada Na Mesma Pasta Do
   Próprio Executável. Contudo, Como Estes Arquivos Auxiliares Também Podem Ser Necessários
   Para Outros Executáveis Similares, Por Razões De Organização e Redução De Espaço De
   Cópias Em Disco, Eles Estarão Normalmente Gravados Na Pasta Pai Daquela Que Contém
   Este Executável. E, Além De Ser Na Pasta Pai, Então, Em Uma Sub Pasta Não Denominada
   Meramente "Operação" Mas Denominada "Operacao Shared". Este Procedimento Destina-se a
   Tratar Esta Situação, Convertendo a Rota de Acesso a Estes Arquivos Auxiliares. Em
   Caso Extremos Ele Buscará a Pasta "Operação Shared" Não Apenas Na Pasta Pai, Mas Em
   Toda a Cadeia de Pastas Pais a Partir Daquela Onde Está Gravado o Executáva, Até
   Chegar Na Própria Pasta Raiz do Disco Utiilizado.}

  {Obter Toda a Cadeia de Pastas Que Compõe a Rota De Acesso Ao Arquivo Desejado:}
  ListaPath := TStringList.Create;
  ListaPath.Clear;
  ExtractStrings( [ '\' ], [], PChar( NomeCompletoArquivoComRota ), ListaPath );
  IndiceMudar := ListaPath.IndexOf( 'Operacao' );
  ListaPath.Strings[ IndiceMudar ] := 'Operacao Shared';  // Mudar de "Operacao" Para "Operacao Shared" 
  ListaPath.Delete( IndiceMudar - 1 );                    // Eliminar o Nome da Própria Sub Pasta Que Contém o Executável

  {Montar a Nova Rota "Path" de Acesso ao Arquivo:}
  NomeCompletoArquivoComRota := MontaListaPath;

  {Verificar Se o Arquivo ou a Pasta Realmente Existem:}
  while ( ( not DirectoryExists( NomeCompletoArquivoComRota ) ) and
          ( not FileExists( NomeCompletoArquivoComRota ) ) and
          ( IndiceMudar > 0 ) ) do
  begin
    {Caso o Arquivo ou a Pasta Não Existirem, Ir Subindo Na Cadeia De Pastas Pai Até
     Encontrar Os Arquivos Auxiliares De "Operacao Shared" Ou Até Chegar Na Pasta Raiz
     Do Disco:}
    IndiceMudar := ListaPath.IndexOf( 'Operacao Shared' );
    if ( IndiceMudar > 0 ) then
    begin
      ListaPath.Delete( IndiceMudar - 1 );
      NomeCompletoArquivoComRota := MontaListaPath;
    end;
  end;
  ListaPath.Free;
end;

procedure TfrmPrincipal.ConectarBancoDados(
  var sqlConnectionTrabalho: TSQLConnection;
  NomeArquivoBancoDados: String );
var
  NomeArquivoDados: String;
begin
  NomeArquivoDados :=
    Trim( ExtractFilePath( Application.ExeName ) ) +
    'Operacao\Dados_GeoShow\' + NomeArquivoBancoDados;

  if not FileExists( NomeArquivoDados ) then
    ConverterNomeCompletoArquivoOperacaoParaOperacaoShared( NomeArquivoDados );

  ConectarBancoDados_IB_FB_SeJaNaoConectado(
    NomeArquivoDados,
    UsuarioBancoDados,
    SenhaBancoDados,
    sqlConnection );
end;

function TfrmPrincipal.Logo_ResponderEspecificacoesLogotiposExistentesPossiveis(
  const IndiceLogotipoDesejado: Integer;
  const InformacaoDesejada: String ): String;
const
  EspecificacoesLogotipos: Packed Array[ 1 .. Logo_QuantidadeTotalLogotiposExistentesPossiveis, 1 .. 4 ] Of String =
  (
    ( 'Infosistemas',
      'http://www.infosistemas.com.br/',
      'sac@infosistemas.com.br',
      '1' )
  );
begin
  Result := '';

  if      ( InformacaoDesejada = 'NomeBaseArquivoLogotipo' ) then
    Result := EspecificacoesLogotipos[ IndiceLogotipoDesejado + 1, 1 ]

  else if ( InformacaoDesejada = 'EnderecoWebSite' ) then
    Result := EspecificacoesLogotipos[ IndiceLogotipoDesejado + 1, 2 ]

  else if ( InformacaoDesejada = 'EnderecoEmailRetorno' ) then
    Result := EspecificacoesLogotipos[ IndiceLogotipoDesejado + 1, 3 ]

  else if ( InformacaoDesejada = 'InverterCorCarimbarGoogleMapsSatelite' ) then
    Result := EspecificacoesLogotipos[ IndiceLogotipoDesejado + 1, 4 ];
end;

function TfrmPrincipal.Logo_NomeBaseArquivoLogotipoConformeConfigurado: String;
begin
  Result :=
    Logo_ResponderEspecificacoesLogotiposExistentesPossiveis(
      Configuracao_Inicial_Logotipo_Sequencial_Padrao,
      'NomeBaseArquivoLogotipo' );
end;

function TfrmPrincipal.Logo_EnderecoWebSiteConformeConfigurado: String;
begin
  Result :=
    Logo_ResponderEspecificacoesLogotiposExistentesPossiveis(
      Configuracao_Inicial_Logotipo_Sequencial_Padrao,
      'EnderecoWebSite' );
end;

function TfrmPrincipal.Logo_EnderecoEmailRetornoConformeConfigurado: String;
begin
  Result :=
    Logo_ResponderEspecificacoesLogotiposExistentesPossiveis(
      Configuracao_Inicial_Logotipo_Sequencial_Padrao,
      'EnderecoEmailRetorno' );
end;

function TfrmPrincipal.Logo_InverterCorCarimbarGoogleMapsSateliteConformeConfigurado: Boolean;
begin
  {Os Logotipos São Utilizados Para Personalizar a Tela Inicial da Aplicação Mas Também São
   Eventualmente Utilizados Para "Carimbar" Telas Contendo Mapas, Por Exemplo, Na Produção De
   Vídeos da Análise Crono Térmica. Neste Caso, Quando os Mapas Estão Em Visão de Satélite, a
   Sua Cor de Fundo é Mais Escura e Isto Pode Prejudicar a Visibilidade do Logotipo Carimbado.
   Este Procedimento Informa, Para Cada Logotipo, Se Em Uma Situação Como Esta é Conveniente
   Aplicar Uma Imagem Com Coloração Invertida do Logotipo Para Obter Uma Visão Melhor Com Outro
   Contraste. As Providências Abaixo Expressas, Para Inverter a Cor ou Não Dos Logotipos, Foi
   Obtida Meramente Por Observação, De Qual Tipo Acaba Ficando Melhor e Melhorando a Visão:}

   Result :=
     ( Logo_ResponderEspecificacoesLogotiposExistentesPossiveis(
         Configuracao_Inicial_Logotipo_Sequencial_Padrao,
         'InverterCorCarimbarGoogleMapsSatelite' ) = '1' );
end;

procedure TfrmPrincipal.Logo_CarregarLogotipoConformeConfigurado;
const
  LarguraMaximaLogotipo = 380;
  AlturaMaximaLogotipo  = 084;
var
  NomeArquivoImagem: String;
  Largura, Altura: Integer;

  procedure AjustarPosicaoHorizontalBotoesControlePainelSuperiorPrincipal;
  const
    MargemMenorEntreBotoes = 15;
    MargemMaiorEntreBotoes = 15;
  var
    LarguraDisponivelParaBotoes, LarguraOcuparBotoes: Double;
  begin
    {Calcular o Espaço Máximo Disponível Para Os Botões Do Painel Superior:}
    LarguraDisponivelParaBotoes := lblLegendaVersao.Left - ( imgLogotipo.Left + LarguraMaximaLogotipo );

    {Há Apenas Um Botãoo De Controle No Painel Superior Principal. Assim, Calcular Espaço De Largura Que
     Os Botões Superiores Ocupam:}
    LarguraOcuparBotoes :=
      01 * spdCrudClientes.Width +   // Computando Espaço De Largura Dos Próprios Botões Existentes (Há Apenas Um Botão Por Enquanto)
      03 * MargemMenorEntreBotoes +  // Computando As Margens Menores Entre Si
      03 * MargemMaiorEntreBotoes;   // Computando As Margens Maiores Entre Si

    {Ajustar a Posição Horizontal Do Botão Posicionado Mais a Esquerda. E, Em Seguida, Ir Ajustando Horizontalmente
     Os Demais Botões Em Sequencia, Cada Um a Partir Do Anterior, Considerando o Espaço Entre Margens Desejado:}
    spdCrudClientes.Left :=
      Round( imgLogotipo.Left + LarguraMaximaLogotipo + ( LarguraDisponivelParaBotoes - LarguraOcuparBotoes ) / 2 );
    lblCrudClientes.Left := spdCrudClientes.Left;

    imgCliqueAqui.Left := spdCrudClientes.Left + spdCrudClientes.Width + MargemMaiorEntreBotoes;
  end;

begin
  NomeArquivoImagem := '';

  NomeArquivoImagem := Logo_NomeBaseArquivoLogotipoConformeConfigurado;
  if ( NomeArquivoImagem <> '' ) then
  begin
    NomeArquivoImagem :=
      Trim( ExtractFilePath( Application.ExeName ) ) + 'Operacao\Imagens_Logotipos\Logo_' + NomeArquivoImagem + '.bmp';

    if ( FileExists( NomeArquivoImagem ) ) then
    begin
      imgLogotipo.Visible := False;
      imgLogotipo.Picture.LoadFromFile( NomeArquivoImagem );

      Largura := LarguraMaximaLogotipo;
      Altura  := Round( imgLogotipo.Picture.Height * ( LarguraMaximaLogotipo / imgLogotipo.Picture.Width ) );
      if ( Altura > AlturaMaximaLogotipo ) then
      begin
        Altura  := AlturaMaximaLogotipo;
        Largura := Round( imgLogotipo.Picture.Width * ( AlturaMaximaLogotipo / imgLogotipo.Picture.Height ) );
      end;

      imgLogotipo.Width := Largura;
      imgLogotipo.Height := Altura;

      imgLogotipo.Left := 18;
      imgLogotipo.Top := Round( ( pnlSuperior.Height - imgLogotipo.Height ) / 2 );

      imgLogotipo.Stretch := True;
      imgLogotipo.Visible := True;

    end;
  end;

  AjustarPosicaoHorizontalBotoesControlePainelSuperiorPrincipal;
end;

procedure TfrmPrincipal.AjustarDimensoesPanelFundoComFormParent(
  Panel: TPanel );
begin
  {Normalmente Este Aplicativo Funciona Dentro De Navegador Web. E Para Que Possa Ser Visto
   Em Sua Totalidade, O Navegador Web Deve Estar Maximizado. Contudo, Eventualmente O Usuário
   Poderá Não Estar Usando O Navegador Maximizado E, Neste Caso, É Necessário Que Haja Um
   Mecanismo Que Permita A Rotação Horizontal E Vertical Do Aplicativo Dentro Dos Limites
   Oferecidos Pelo Navegador, Considerando Afinal Que, Neste Caso, As Dimensões Do Navegador
   Equivalerão Às Que Seriam As Da Própria Área De Trabalho Completa Correspondente Caso O
   Aplicativo Rodasse Em Modo Desktop Comum.

   Esta Situação Afeta Os "Forms" Que Funcionam Naturalmente Maximizados E Não Afeta Aqueles
   Outros, Normalmente Auxiliares, Que Não Cobrem Toda A Área Da Tela. A Técnica Para Resolver
   Isto Conforme Implementada Abaixo Faz Uso De Diversos Detalhes Que Serão Explicados A Seguir.

   Para Que Isto Funcione, Cada "Form" Deverá Conter Um "Panel" Imediatamente Dentro Dele. E
   Este "Panel" É Que Conterá Todos Os Demais Componentes Visuais Daquele "Form". Durante a
   Execução, A Largura E Altura Deste "Panel" Serão Dimensionados Nos Limites Reais Maximizados
   Que Seriam Os Ideais Para A Execução Do Aplicativo. E, Por Sua Vez, O "Form" Que Contém
   Diretamente O "Panel", Este É Que Terá Largura E Altura Dimensionados Conforme A Área
   Efetivamente Disponível Dentro Do Navegador Web. Para Completar, O "Form" Será Setado Com
   "Autoscrolls" Para Que As Barras De Rolagem Horizontal E Vertical Sejam Mostradas Caso o
   Dimensionamento Do Navegador Web Seja Menor Do Que O Efetivamente Necessário Para A Visão
   Completa Do "Panel".

   Menciona-se Ainda Que, Inicialmente, Em Tempo de "Design" da Aplicação, Dentro da IDE do Delphi,
   Os "Forms" Deverão Estar Setados Com Sua Propriedade "Windowstate" em "wsMaximized" ou "wsNormal"
   Conforme Sejam Para Serem Mostrados Maximizados Ou Não Dentro do Navegador Web. E Quando Maximizados,
   Se o Navegador Web Não Puder Conte-los, Então Aparecerão Com as Respectivas Barras de Rolagem.

   E Dentro de Cada Um Destes "Forms", o "Panel" Que Representará Todo o Conteúdo Deste "Form", Deverá
   Estar Inicialmente, no Tempo de "Design", Com "Align" em "alClient".

   Este Procedimento De Ajuste Deve Ser Chamado No "OnShow" De Todos Os "Forms". O "Windowstate"
   De Cada "Form" Já Estará Setado Para Definir Quais Devem Parecem Maximizados e Quais Estarão
   Em Estado Normal. O "Panel" Que Fará Diretamente O Fundo De Cada "Form" Terá a Mesma Dimensão
   Do "Form" Que é Seu Parent Direto, e Terá "Align" Inicial Como "alClient". Por Sinal, Aqui, Dentro
   Deste Procedimento, o "Align" do "Panel" Será Então Colocado Em "alNone". Note Que Esta Necessidade
   Do "Panel" Estar Com "Align" Inicial Em "AlClient" Só é Realmente Necessária Se o "Form" Que o
   Conter For Ser Maximizado. Caso Contrário, o "Align" Inicial do "Panel" Poderá Estar em "alNone" Ou
   Qualquer Outro Estado.}

  if ( Panel.Parent is TForm ) then
    if ( TForm( Panel.Parent ).WindowState = wsMaximized ) then
    begin
      {Foi Confirmado Que Trata-se de Um "Panel" de Fundo de Um "Form" Que é Maximizado Em
       Toda a Área de Tela Disponível. Somente Neste Caso Segue o Procedimento. Atribui-se
       Ao "Panel" Dimensões de Largura e Altura Mínimas Para Conter Todos Os Componentes
       Visuais Necessários:}
      Panel.Align := alNone;
      Panel.Width := Max( 1280, Screen.Width );    // O Número Representa Uma Largura Minima Em Pixels de Uma Tela Adequada
      Panel.Left := 0;
      Panel.Height := Max( 644, Screen.Height );   // O Número Representa Uma Altura Minima Em Pixels de Uma Tela Adequada
      Panel.Top := 0;

      {Verificar Se a Largura do "Form" Que Contém o "Panel" é Suficiente Para Mostrar Todo o
       Seu Conteúdo. O Número Usado no "If" Abaixo Representa o Tamanho das Margens Que As
       Próprias Barras de Rolagem Iriam Consumir do Espaço de Desenho:}
      if ( ( TForm( Panel.Parent ).Width + 16 ) < Panel.Width )  then
      begin
        {As Dimensões do "Form", Que na Prática São As Mesmas Dimensões da Janela do Navegador Web
         Não São Suficiente Para Conter o "Panel" e Todos os Seus Componentes. Então As "Scroolbars"
         No "Form" Que Contém o "Panel" São Necessárias. Primeiro Estas Barras São Desligadas Para
         Provocar Um "Reset" Nos Controle e Em Seguida São Ligadas:}
        TForm( Panel.Parent ).AutoScroll := False;
        TForm( Panel.Parent ).AutoScroll := True;
      end
      else
      begin
        {As Dimensões do "Form", Que na Prática São As Mesmas Dimensões da Janela do Navegador Web
         São Suficiente Para Conter o "Panel" e Todos os Seus Componentes. Ou Seja, Nestas Dimensões
         Não Há Necessidade De Barras de Rolagem Neste "Form":}
        TForm( Panel.Parent ).AutoScroll := False;
        Panel.Left := 0;
        Panel.Top := 0;
      end;

      {Marcar Este "Panel" Para Saber Que Ele é Um Panel de Fundo de Todos os Demais Componentes
       Visuais e Que o Seu "Parent" é o Próprio "Form" Que o Contém. Esta Marcação Será Útil Na Execução
       Do Procedimento de Redimensionamento de "Forms" do Thinfinity Virtual UI. Isto Porque, Quando Ocorre
       Um Redimensionamento do Navegador Web, Não Apenas o "Form" Atualmente Ativo, Mas Todos Os Outros
       "Forms" Maximizados da Aplicação, Embora Não Visíveis Naquele Momento, Poderão Depois Vir a Ser
       Novamente Mostrados e Deverão Estar Dimensionados De Acordo Com o Espaço Disponível do Navegador Web.

       Eventualmente, Embora Não Tenha Sido Testado, Talvez Não Houvesse Necessidade Desta Marcação e Então
       Também Poderia Ser Dispensada a Função de Redimensionamento de "Forms" do Thinfinity Virtual UI. Em
       Contrapartida, Para Assegurar o Redimensionamento dos Outros "Forms" Maximizados Eventualmente Invisíveis, a
       Alternativa Poderia Ser a Chamada Deste Presente Procedimento Não Apenas no No "OnShow" De Todos Os "Forms"
       Mas Também no "OnActivate" de Todos Eles.}
      Panel.Tag := 1;
    end;
end;

procedure TfrmPrincipal.AjustarDimensoesDosFormsMaximizadosDevidoRedimensionamentoDoBrowserNavegador(
  Sender: TObject;
  var Width, Height: Integer;
  var ResizeMaximized: Boolean);
var
  ContForms, ContPanels: Integer;
  Form: TForm;
  EncontrouPanelFundoComFormParent: Boolean;
begin
  {Quando Forms Desta Aplicação Encontram-se no Estado Maximizado Para Que Aparecam Cobrindo Toda a
   Área do Navegador Web Onde Aparecem. E Eventualmente o Próprio Navegador Web Dentro do Qual Roda
   Esta Aplicação Pode Ser Redimensionado. Por Exemplo, Este Navegador Web Que Estava em Janela Menor Foi
   Maximizado Pelo Usuário. Nesta Situação, Como na Prática Isto Não é Um Resize Normal, é Necessário
   Percorrer Todos os Forms Existentes, Que Estejam Criados Naquele Momento, Embora Eventualmente Invisíveis e
   Que Estejam Maximizados, De Forma a Setar as Suas Novas Dimensões Maximizadas:}

  {Percorrer Todos os Componentes da Aplicação:}
  for ContForms := 0 to Application.ComponentCount - 1 do
  begin
    {Verificar Se Este Componente é Um "Form":}
    if ( Application.Components[ ContForms ] is TForm ) then
    begin
      {Verificar Se Este "Form" Está Maximizado:}
      if ( TForm( Application.Components[ ContForms ] ).WindowState = wsMaximized ) then
      begin
        {Verificar Se Este "Form" Maximizado é Outro Que Não o Próprio "Form" Atual. Neste
         Caso Ele Não Precisa Ser Processado Por Que Isto Já Ocorreu No "OnResize" Dele Próprio.
         De Qualquer Forma o "If" a Seguir Destina-se Apenas a Esta Otimização e Poderia Ser
         Dispensado.}
        Form := TForm( Application.Components[ ContForms ] );
        if ( Form <> Self ) then
        begin
          {Este é Um "Form" Maximizado e Que Precisa Ser Redimensionado Conforme Novo Tamanho
           Do Navegador Web Dentro do Qual Está Sendo Rodada a Aplicação. Aqui Será Necessário
           Procurar o "Panel" Contido Neste "Form" e Que Apoiará a Eventual Necessidade de
           Acionar as Barras de Rolagem do "Form":}
          EncontrouPanelFundoComFormParent := False;
          ContPanels := 0;
          while ( ContPanels < Form.ComponentCount - 1 ) and
                ( not EncontrouPanelFundoComFormParent ) do
          begin
            if ( Form.Components[ ContPanels ] is TPanel ) then
            begin
              {Procurar o "Panel" Que Foi Marcado Para Auxiliar o Redimensionamento:}
              EncontrouPanelFundoComFormParent := ( TPanel( Form.Components[ ContPanels ] ).Tag =  1 );
            end;
          end;

          {Embora Seja Obrigatório Que o "Panel" de Dimensionamento Auxiliar Tenha Sido
           Encontrado, Verifica Se Realmente Foi e Aplica o Procedimento de Redimensionamento:}
          if EncontrouPanelFundoComFormParent then
            AjustarDimensoesPanelFundoComFormParent( TPanel( Form.Components[ ContPanels ] ) );
        end;
      end;
    end;
  end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  {Gravar Configuração Inicial do Programa Para Que Possa Ser
   Lida No Início da Próxima Execução:}
  GravarConfiguracaoInicial;

  {Gravar Log Histórico De Eventos:}
  if frmLogin.UsuarioAutenticado then
    GravarLinhaNoLogHistoricoDeEventos( 'Logout')
  else
    GravarLinhaNoLogHistoricoDeEventos( 'Tentativa Login Fracassada Apos ' +
      FormatarInteiroComZerosEsquerda( frmLogin.ContadorDeTentativas, 2 ) + ' Tentativa(s)' );

  sqlConnection.Close;

  {Executar Providências Sistêmicas de Saída da Aplicação. Elas Valem Para Todos Os
   Programas Deste Tipo e Definem a Relação Inicial Do Aplicativo Com o Sistema Oepracional
   E Com o Equipamento Computacional Que o Está Executando. São Setadas Na Entrada e Algumas
   Delas Precisam Ser Resetadas na Saída:}
  ExecutarProvidenciasSistemicas_Saida;
end;

procedure TfrmPrincipal.appAplicacaoEventosException(Sender: TObject;
  E: Exception);
var
  Mensagem01, Mensagem02, MensagemAoUsuario, MensagemDeTituloDoDialogo: String;
  Pos1, Pos2, CodigoDoErro: Integer;
  PrecisaDeAtencaoEspecial_SaidaDoPrograma: Boolean;
  Action: TCloseAction;
begin
  {Verificar e Tratar Outros Casos de Excessões de Execução:}
  PrecisaDeAtencaoEspecial_SaidaDoPrograma := False;

  Mensagem01 := Trim( AnsiUpperCase( E.Message ) );
  RemoverDiacriticos( Mensagem01 );

  if      ( Pos( 'VALOR DE PARAMETRO INCORRECTO', Mensagem01 ) > 0 ) then
  begin
    {Esta Exception Eventualmente Ocorre na Biblioteca GMMap (API Espanhola De
     Acesso ao Google Maps). A Exception Foi Observada Quando Há Pontos
     Marcados Sobre o Mapa Google (Via Classe GMMaker) e Devem Ser Retirados
     Com Carga De Outros Novos. A Exception é Lançada No Redesenho Dos Novos
     Pontos. Ela Ocorre Sem Motivo, Provavelmente Devido "Bug" Na Biblioteca e
     Sua Ocorrência Não Traz Outras Consequências. Assim Ela Pode Ser Totalmente
     Ignorada, Inclusive Dispensando Seu Registro No Log de Eventos da Aplicação:}
    CodigoDoErro := 0;
  end

  else if ( Pos( 'ID DO JAVASCRIPT NA', Mensagem01 ) > 0 ) then
  begin
    {Da Mesma Forma Que a Exception Descrita Acima, Esta Outra Exception
     Eventualmente Ocorre na Biblioteca GMMap (API Espanhola De
     Acesso ao Google Maps). A Exception Foi Observada Quando Há Pontos
     Marcados Sobre o Mapa Google (Via Classe GMMaker) e Devem Ser Retirados
     Com Carga De Outros Novos. A Exception é Lançada No Redesenho Dos Novos
     Pontos. Ela Ocorre Sem Motivo, Provavelmente Devido "Bug" Na Biblioteca e
     Sua Ocorrência Não Traz Outras Consequências. Assim Ela Pode Ser Totalmente
     Ignorada, Inclusive Dispensando Seu Registro No Log de Eventos da Aplicação:}
    CodigoDoErro := 0;
  end

  else if ( ( Pos( 'IS NOT A VALID DATE'                 , Mensagem01 ) > 0 ) or
            ( Pos( 'COULD NOT PARSE SQL TIMESTAMP STRING', Mensagem01 ) > 0 ) ) then
  begin
    CodigoDoErro := 1;

    MensagemAoUsuario :=
      'A Data Informada é Inválida.';
  end

  else if ( Pos( 'MUST HAVE A VALUE', Mensagem01 ) > 0 ) then
    begin
      Pos1 := Pos( '''', Mensagem01 );
      Mensagem02 := Mensagem01;
      Delete( Mensagem02, Pos1, 1 );
      Pos2 := Pos( '''', Mensagem02 );
      Mensagem02 := Copy( Mensagem01, Pos1 + 1, Pos2 - Pos1 );
      CodigoDoErro := 2;

      MensagemAoUsuario :=
        'O Campo ' + Mensagem02 + ' é Obrigatório.';
    end

  else if ( Pos( 'KEY VIOLATION', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 3;

    MensagemAoUsuario :=
      'Houve Violação de Chave Primária.';
  end

  else if ( Pos( 'INPUT VALUE',  Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 4;

    MensagemAoUsuario :=
      'O Valor Informado é Inválido.';
  end

  else if ( Pos( 'IS NOT A VALID TIME', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 5;

    MensagemAoUsuario :=
      'A Hora Informada é Inválida.';
  end

  else if ( Pos( 'O ARQUIVO JA ESTA SENDO USADO', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 6;

    MensagemAoUsuario :=
      'O Banco de Dados Deste Programa Já Está Em Uso Por Outro Aplicativo.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'O SISTEMA NAO PODE ENCONTRAR O ARQUIVO', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 7;

    MensagemAoUsuario :=
      'Não é Possível Encontrar Um Arquivo Que é Necessário Ao Funcionamento Deste Programa. ' +
      'Você Deverá Reinstalar o Aplicativo Para Que Volte a Funcionar!';

      PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'APLICATIVO JA EM EXECUCAO', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 8;

    MensagemAoUsuario :=
      'Este Programa Já Está Em Execução. Utilize a Cópia Que Está Em Funcionamento!';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'GUIA NAO ENCONTRADO', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 9;

    MensagemAoUsuario :=
      'O Arquivo Contendo o Guia Eletrônico Do Usuário Não Está Instalado.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := False;
  end

  else if ( Pos( 'UNAVAILABLE DATABASE', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 10;

    MensagemAoUsuario :=
      'Não é Possível Fazer Acesso Ao Banco De Dados. ' +
      'Possível Ausência da Biblioteca DLL De Acesso.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'NO PERMISSION FOR READ-WRITE', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 11;

    MensagemAoUsuario :=
      'Não é Possível Fazer Acesso Para Escrita No Banco De Dados. ' +
      'Possível Bloqueio "Read-Only" Nos Arquivos de Utilização.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'NAO FOI ENCONTRADA A FUNCAO', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 12;

    MensagemAoUsuario := Mensagem01;
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := False;
  end

  else if ( Pos( 'FAILED TO SET DATA FOR', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 13;

    MensagemAoUsuario :=
      'Não é Possível Instalar Este Aplicativo a Menos Que Se Faça ' +
      'Autenticação de Login Como Usuário Administrador.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'SOCKET ERROR', Mensagem01 ) > 0 ) or
          ( Pos( 'CONEXAO COM O SERVIDOR NAO PODE SER ESTABELECIDA ', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 14;

    MensagemAoUsuario :=
      'Há Algum Problema Relacionado Ao Funcionamento Da Rede, Conexão Ou Acesso a Internet.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := False;
  end

  else if ( Pos( 'ACCESS VIOLATION AT ADDRESS', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 15;

    MensagemAoUsuario :=
      'Acesso a Endereço Indevido No Mapeamento Reservado Da Memória De Execução.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'NAO FOI POSSIVEL CONCLUIR A OPERACAO. ERRO: 80020101', Mensagem01 ) > 0 ) then
  begin
    {Esta Exception Ocorre Quando Há Erro na Execução de Código JavaScript Sobre
     Um Objeto TWebBrowser. Uma Causa Comum é Falta de Conexão ou Instabilidades de
     Conexão Durante o Uso, Por Exemplo, da Biblioteca GMMap (API Espanhola De
     Acesso ao Google Maps).}
    CodigoDoErro := 16;

    MensagemAoUsuario :=
      'Há Falhas Na Conexão Com a Internet Ou Instabilidades de Conexão Que Impedem o Funcionamento.';
  end

  else
  begin
    CodigoDoErro := 10000;   // Erro Genérico

    MensagemAoUsuario := Mensagem01;
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := False;
  end;

  if ( CodigoDoErro > 0 ) then
  begin
    {Gravar Log Histórico De Eventos:}
    GravarLinhaNoLogHistoricoDeEventos( 'Exception ' + QuotedStr( E.Message ) );

    {Formatar a Apresentação Da Mensagem Ao Usuário:}
    MensagemAoUsuario :=
      Trim( 'Ocorreu Excessão De Execução Com a Seguinte Mensagem:' + RetornoDeCarro( 01 ) + MensagemAoUsuario );

    MensagemAoUsuario :=
      WrapText(
        MensagemAoUsuario,
        RetornoDeCarro( 01 ),
        [' ', '.', ':', ';', ',', '-'],
        60 );   // Parte a Mensagem De Erro Em Linhas Com Até 60 Caracteres

    MensagemDeTituloDoDialogo := NomeCompletoDestePrograma + '- Mensagem de Excessão - ';
    if PrecisaDeAtencaoEspecial_SaidaDoPrograma then
    begin
      MensagemDeTituloDoDialogo := MensagemDeTituloDoDialogo + 'Impede Seguimento';
      MensagemAoUsuario := MensagemAoUsuario + RetornoDeCarro( 02 ) + 'A Execução Será Encerrada.';
    end
    else
    begin
      MensagemDeTituloDoDialogo := MensagemDeTituloDoDialogo + 'Não Impede Seguimento';
    end;

    MessageBeep( MB_ICONHAND );

    AcionarFormProsseguir(
      MensagemAoUsuario,
      MensagemDeTituloDoDialogo,
      '',
      'Prosseguir',
      PrecisaDeAtencaoEspecial_SaidaDoPrograma );

    {Se For o Caso, Faz o Encerramento Forçado Da Execução:}
    if PrecisaDeAtencaoEspecial_SaidaDoPrograma then
    begin
      try
        Action := caFree;
        FormClose( Sender, Action );

        Application.Terminate;
        Application.ProcessMessages;
        Exit;
      except
        Halt;
      end;
    end;
  end;
end;

function TfrmPrincipal.Pegar_ID_MapaShapeDoBancoDadosAtual: String;
var
  Query: TSQLQuery;
begin
  Query := TSQLQuery.Create( Self );
  Query.SQLConnection := frmPrincipal.sqlConnection;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add( 'SELECT' );
  Query.SQL.Add( '  ID_MAPA_SHAPE' );
  Query.SQL.Add( 'FROM' );
  Query.SQL.Add( '  CONFIGURACAO' );
  Query.Open;

  Result := Trim( Query.FieldByName( 'ID_MAPA_SHAPE' ).AsString );

  Query.Close;
  Query.Free;
end;

function TfrmPrincipal.AcionarFormDialogoCrudClientes;
begin
  frmDialogoCrudClientes := TfrmDialogoCrudClientes.Create( Self );
  frmDialogoCrudClientes.ShowModal;
  Result := frmDialogoCrudClientes.Resultado;
  frmDialogoCrudClientes.Release;
end;

procedure TfrmPrincipal.spdCrudClientesClick(Sender: TObject);
begin
  AcionarFormDialogoCrudClientes;
end;

procedure TfrmPrincipal.imgLogotipoClick(Sender: TObject);
begin
  {Abrir Link da Pagina Web Correspondente ao Logotipo:}
  ExecutarShellExecute( Logo_EnderecoWebSiteConformeConfigurado );
end;

end.

