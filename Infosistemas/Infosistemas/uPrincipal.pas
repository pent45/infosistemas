{

Este aplicativo foi escrito por Rudolfo Horner Jr em Junho de 2020 meramente como Teste em
processo da Infosistemas. Todas as Fun��es e Eventualmente Classes Foram Produzidas Exclusivamente
Pelo Autor, Assim Como Usu�rios e Senhas de Servi�os Que S�o Do Seu Acesso Exclusivo.

Assim, nenhum dos c�digos, fun��es, procedimentos, bancos de daods ou seus recursos poder�o ser
utilizados para outros fins que n�o exclusivamente o Teste requisitado.

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

  {Comunica��es Mensagens Email SMTP}
  NomeUsuarioSMTPParaEnvioDeMensagensDeEmail                            = 'sitemonitor@melhorsoft.com';
  SenhaUsuarioSMTPParaEnvioDeMensagensDeEmail                           = 'r_34AgyZ_2dXy';
  NomeServidorSMTPParaEnvioDeMensagensDeEmail                           = 'smtp.melhorsoft.com';
  PortaServidorSMTPParaEnvioDeMensagensDeEmail                          = 587;
  ServidorSMTPExigeAutenticarUsuario                                    = True;
  ServidorSMTPExigeAutenticarSSL                                        = False;

  {Comunica��es Mensagens Email Que Ser�o Copiadas}
  EnderecoEmailQueRecebeCopiaDasMensagensEnviadas                       = 'sitemonitormelhorsoft@gmail.com';
  SenhaEnderecoEmailQueRecebeCopiaDasMensagensEnviadas                  = 'sitemonitor';

  {Usu�rio e Senha Do Banco de Dados Padr�o:}
  UsuarioBancoDados                                                     = 'SYSDBA';
  SenhaBancoDados                                                       = 'masterkey';

  {Cor De Fundo Da Parte Superior Dos "Forms" De Di�logo:}
  CorParteSuperiorFormsDialogoComuns                                    = TColor( $F2A78A );
  {Esta Cor Acima Equivale a "clCornFlowerBlue" Ajustada Com Um Pouco Mais De Claridade}

  {Logotipos De Neg�cios Usados Na Aplica��o}
  Logo_QuantidadeTotalLogotiposExistentesPossiveis                      = 001;
  Logo_OrdemLogotipoPadraoInicial                                       = 000;

  {Outros}
  PolegadaEmMilimetro                                                   = 25.4;
  ChavePadraoCriptograficaSimetricaParaSistemaAcessosPermissoes         = '>!x#rC(?au~E&*Q-X@mkj)_N^fvS+=:<H/gO$\l|%';

type
  {O Componente TPageControl Utilizado Neste Form, Mesmo Quando Tem Suas "Tabs"
   Invis�veis, Apresenta Uma Borda de 04 Pixels Que N�o Lhe Confere Um Aspecto "Flat"
   Perfeito. Assim, Realiza a Captura do Evento de Redimensionamento da Sua Classe de
   Origem Para Corrigir o Seu Aspecto Final Quando For Necess�rio:}
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

  {Identifica��o Dos Endere�os IP e Locais De Acesso Da Rede Local e Do Servidor Web. Estas Vari�veis
   Identificadores N�o Podem Estar Dentro do Objeto "Form" Principal, Mas Em Vari�veis Destacadas �
   Parte. Isto Porque Elas S�o Assinaladas Por Uma "Thread" De Identifica��o De Endere�os Que � Disparada Na
   Abertura Da Execu��o Desta Aplica��o. E Caso o Usu�rio Feche a Aplica��o Imediatamente Ap�s Abri-la, Pode
   Eventualmente Ocorrer Desta "Thread" De Identifica��o Ainda Estar Rodando e Fazendo Assim Refer�ncias a
   Identificadores Que J� Teriam Sido Destru�dos Pelo Fechamento da Aplica��o:}
  IPAcessoInternet, IPServidorWeb, LocalAcessoInternet, LocalServidorWeb: String;

implementation

uses
  uLogin, uDialogo, uDialogoCrudClientes, uAguarde;

{$R *.dfm}

procedure TPageControl.TCMAdjustRect( var Msg: TMessage );
begin
  {O Componente TPageControl Utilizado Neste Form, Mesmo Quando Tem Suas "Tabs"
   Invis�veis, Apresenta Uma Borda de 04 Pixels Que N�o Lhe Confere Um Aspecto "Flat"
   Perfeito. Assim, Realiza a Captura do Evento de Redimensionamento da Sua Classe de
   Origem Para Corrigir o Seu Aspecto Final Quando For Necess�rio:}

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
      {Como Esta Mensagem ao Usu�rio Requer Aten��o Especial, No Caso De Haverem Duas
       Op��es De Resposta, Inverte-as Em Rela��o a Forma Tradicional Para For�ar a Aten��o:}
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
  {Na Cria��o Deste Form, Preservar o Estado Original do Controle de Ponto Flutuante da CPU e
   Seta-lo Para Um Estado Que Elimine a Possibilidade de Ocorr�ncia de Divis�o Por Zero, o Que
   Eventualmente Se Observa Na Primeira Carga de Shape File, Quando Executado Em Ambiente de
   Servidor Web:}
  ComoEstavaDefinicao_IntelFloatingPointUnit_8087CW := Get8087CW;
  Set8087CW( $133F );

  {Definir Padr�o de Emula��o Equivalente Ao Internet Explorer Vers�o 11 Para Componentes WebBrowsers Desta Aplica��o:}
  SetarComponentesWebBrowserDestaAplicacaoComPadraoEmulacaoInternetExplorer11;

  {Prevenir Que Aplica��o Esteja Rodando em Servidor Web Ou Desktop Que N�o Esteja Configurado
   Regionalmente Para Caracteres de Separa��o de Milhares e Separa��o de Decimais no Padr�o Brasileiro:}
  ThousandSeparator := '.';
  DecimalSeparator := ',';

  {Disparar Thread Para Identificar N�meros IP e Localiza��o F�sica Aproximada Tanto da
   Esta��o Usu�ria Como Cliente Assim Como do Servidor Web, Caso Esteja Sendo Utilizado na Web:}
  IPAcessoInternet := '';
  LocalAcessoInternet := '';
  IPServidorWeb := '';
  LocalServidorWeb := '';
  TThreadIdentificarLocalizacaoEnderecosIPEmUso.Create( False );
  EsperarSegundos( 2, False );

  {Criar Diret�rio Para Processamento Tempor�rio De Arquivos:}
  NomePastaParaArquivosTemporariosDestaSessao :=
    Trim( ExtractFilePath( Application.ExeName ) ) + 'Operacao\Temporario\User_' + FormatDateTime( 'yyyymmddhhmmsszzz', Now ) + '\';
  ForceDirectories( NomePastaParaArquivosTemporariosDestaSessao );
end;

procedure TfrmPrincipal.ExecutarProvidenciasSistemicas_Saida;
begin
  {Na Destrui��o Deste Form, Restabelecer o Estado Original do Controle de Ponto Flutuante da CPU
   Conforme Estava Setado No Momento de Cria��o do Form, Antes da Carga do Controle Shape File. Isto
   Porque Houve Necessidade de Eliminar a Possibilidade de Ocorr�ncia de Divis�o Por Zero, o Que
   Eventualmente Se Observa Na Primeira Carga de Shape File, Quando Executado Em Ambiente de
   Servidor Web:}
  Set8087CW( ComoEstavaDefinicao_IntelFloatingPointUnit_8087CW );

  {Apagar Pasta e Arquivos Tempor�rios Que Possam Ter Sido Criados Durante a Execu��o Desta Sess�o:}
  ApagarPasta( NomePastaParaArquivosTemporariosDestaSessao, False );
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  Posicao: Integer;
begin
  {Preparar Destaque Para Pain�is Que Funcionam Como Bot�es Quando S�o Apontados Pelo Mouse:}
  pnlBotaoSair.PrepararDestaqueParaPanelQueFuncionaComoButtonDeSaidaQuandoForApontadoPeloMouse;

  {Linhas Estranhas Abaixo, Com Duplica��o Da Setagem Da Active Page Para o Mapa Pais Shape,
   Antes e Ao Final Do Bloco, Destina-Se a Impedir Problemas de Execu��o Que Podem Ocorrer
   Quando, Ainda Em Tempo De Desenvolvimento, o Programa � Compilado Tendo Sido Deixada Como
   P�gina Inicial Default Alguma Outra Que N�o Seja a Pr�pria De Mapa Pais Shape, Que Ocorre
   Devido a Setagem Das Abas Das Pag�nas Para Invis�veis Em Tempo de Execu��o:}
  pgcPaginasApresentacoes.ActivePage := tshApresentacaoUm;
  tshApresentacaoUm.TabVisible := False;
  pgcPaginasApresentacoes.ActivePage := tshApresentacaoUm;

  pgcPaginasControles.ActivePage := tshControleUm;
  tshControleUm.TabVisible := False;
  pgcPaginasControles.ActivePage := tshControleUm;

  {Inicializar N�mero De Vers�o Conforme Contida No Execut�vel:}
  NumeroCompletoVersao := PegarVersaoDesteExecutavel;  // Pegar Vers�o Do Pr�prio Execut�vel
  {Como a Vers�o Contida No Execut�vel Cont�m VERS�O, SUB-VERS�O, RELEASE E BUILD, Cuida De
   Separar Apenas a Parte Inicial Que Cont�m VERS�O e SUB-VERS�O:}
  Posicao := Pos( '.', NumeroCompletoVersao );   // Pegar Primeiro Ponto, Que Separa Vers�o de Sub-Vers�o
  if ( Posicao > 0 ) then
  begin
    Posicao := PosEx( '.', NumeroCompletoVersao, Posicao + 1 );   // Pegar Segundo Ponto, Que Separa Sub-Vers�o de Release
    if ( Posicao > 0 ) then
      NumeroVersao := Trim( LeftStr( NumeroCompletoVersao, Posicao - 1 ) );
  end;

  {Mostrar Nome Do Programa e a Sua Vers�o Na Tela Inicial:}
  NomeCompletoDestePrograma := NomeDestePrograma + ' ' + NumeroVersao;
  frmPrincipal.Caption := NomeDestePrograma + ' v' + NumeroCompletoVersao;
  lblLegendaVersao.AutoSize := True;
  lblLegendaVersao.Caption := frmPrincipal.Caption;
  lblLegendaVersao.AutoSize := False;
  lblLegendaVersao.Left := pnlBotaoSair.Left + pnlBotaoSair.Width - lblLegendaVersao.Width;

  {Executar Provid�ncias Sist�micas de Entrada da Aplica��o. Elas Valem Para Todos Os
   Programas Deste Tipo e Definem a Rela��o Inicial Do Aplicativo Com o Sistema Oepracional
   E Com o Equipamento Computacional Que Est� Fazendo a Sua Execu��o. S�o Setadas Na Entrada
   E Algumas Delas Precisam Ser Resetadas na Sa�da:}
  ExecutarProvidenciasSistemicas_Entrada;

  {Ler Configura��o De Funcionamento Inicial Do Programa:}
  LerConfiguracaoInicial;
end;

procedure TfrmPrincipal.MostrarMensagemImpossibilidadeAcessoServicoGoogleMaps;
begin
  AcionarFormProsseguir(
    'Neste Momento N�o Foi Poss�vel Fazer Acesso ao Servi�o Externo Google Maps.' + RetornoDeCarro( 02 ) +
    'Por Favor, Tente Novamente Mais Tarde e Verifique Se a Sua Conex�o Com a' + RetornoDeCarro( 01 ) +
    'Internet Est� Desimpedida, Est�vel e Com Desempenho Adequado.',
    '',
    '',
    'Prosseguir',
    False );
end;

procedure TfrmPrincipal.MostrarMensagemErroAusenciaDeUmaImpressoraConfigurada;
begin
  AcionarFormProsseguir(
    'N�o � Poss�vel Executar a Impress�o Porque N�o H� Nenhuma Impressora' + RetornoDeCarro( 01 ) +
    'Atualmente Instalada e Configurada.' + RetornoDeCarro( 02 ) +
    'Por Favor, Instale Uma Impressora, Ou Ao Menos Um Driver De Impressora,' + RetornoDeCarro( 01 ) +
    'Ainda Que Ela N�o Esteja Fisicamente Instalada.',
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

    {Gravar Log Hist�rico De Eventos:}
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
  {Eventualmente Alguns Arquivos Auxiliares Ao Funcionamento Deste Aplicativo Estar�o
   Gravados Em Uma Sub Pasta Denominada "Operacao" Que Estar� Gravada Na Mesma Pasta Do
   Pr�prio Execut�vel. Contudo, Como Estes Arquivos Auxiliares Tamb�m Podem Ser Necess�rios
   Para Outros Execut�veis Similares, Por Raz�es De Organiza��o e Redu��o De Espa�o De
   C�pias Em Disco, Eles Estar�o Normalmente Gravados Na Pasta Pai Daquela Que Cont�m
   Este Execut�vel. E, Al�m De Ser Na Pasta Pai, Ent�o, Em Uma Sub Pasta N�o Denominada
   Meramente "Opera��o" Mas Denominada "Operacao Shared". Este Procedimento Destina-se a
   Tratar Esta Situa��o, Convertendo a Rota de Acesso a Estes Arquivos Auxiliares. Em
   Caso Extremos Ele Buscar� a Pasta "Opera��o Shared" N�o Apenas Na Pasta Pai, Mas Em
   Toda a Cadeia de Pastas Pais a Partir Daquela Onde Est� Gravado o Execut�va, At�
   Chegar Na Pr�pria Pasta Raiz do Disco Utiilizado.}

  {Obter Toda a Cadeia de Pastas Que Comp�e a Rota De Acesso Ao Arquivo Desejado:}
  ListaPath := TStringList.Create;
  ListaPath.Clear;
  ExtractStrings( [ '\' ], [], PChar( NomeCompletoArquivoComRota ), ListaPath );
  IndiceMudar := ListaPath.IndexOf( 'Operacao' );
  ListaPath.Strings[ IndiceMudar ] := 'Operacao Shared';  // Mudar de "Operacao" Para "Operacao Shared" 
  ListaPath.Delete( IndiceMudar - 1 );                    // Eliminar o Nome da Pr�pria Sub Pasta Que Cont�m o Execut�vel

  {Montar a Nova Rota "Path" de Acesso ao Arquivo:}
  NomeCompletoArquivoComRota := MontaListaPath;

  {Verificar Se o Arquivo ou a Pasta Realmente Existem:}
  while ( ( not DirectoryExists( NomeCompletoArquivoComRota ) ) and
          ( not FileExists( NomeCompletoArquivoComRota ) ) and
          ( IndiceMudar > 0 ) ) do
  begin
    {Caso o Arquivo ou a Pasta N�o Existirem, Ir Subindo Na Cadeia De Pastas Pai At�
     Encontrar Os Arquivos Auxiliares De "Operacao Shared" Ou At� Chegar Na Pasta Raiz
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
  {Os Logotipos S�o Utilizados Para Personalizar a Tela Inicial da Aplica��o Mas Tamb�m S�o
   Eventualmente Utilizados Para "Carimbar" Telas Contendo Mapas, Por Exemplo, Na Produ��o De
   V�deos da An�lise Crono T�rmica. Neste Caso, Quando os Mapas Est�o Em Vis�o de Sat�lite, a
   Sua Cor de Fundo � Mais Escura e Isto Pode Prejudicar a Visibilidade do Logotipo Carimbado.
   Este Procedimento Informa, Para Cada Logotipo, Se Em Uma Situa��o Como Esta � Conveniente
   Aplicar Uma Imagem Com Colora��o Invertida do Logotipo Para Obter Uma Vis�o Melhor Com Outro
   Contraste. As Provid�ncias Abaixo Expressas, Para Inverter a Cor ou N�o Dos Logotipos, Foi
   Obtida Meramente Por Observa��o, De Qual Tipo Acaba Ficando Melhor e Melhorando a Vis�o:}

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
    {Calcular o Espa�o M�ximo Dispon�vel Para Os Bot�es Do Painel Superior:}
    LarguraDisponivelParaBotoes := lblLegendaVersao.Left - ( imgLogotipo.Left + LarguraMaximaLogotipo );

    {H� Apenas Um Bot�oo De Controle No Painel Superior Principal. Assim, Calcular Espa�o De Largura Que
     Os Bot�es Superiores Ocupam:}
    LarguraOcuparBotoes :=
      01 * spdCrudClientes.Width +   // Computando Espa�o De Largura Dos Pr�prios Bot�es Existentes (H� Apenas Um Bot�o Por Enquanto)
      03 * MargemMenorEntreBotoes +  // Computando As Margens Menores Entre Si
      03 * MargemMaiorEntreBotoes;   // Computando As Margens Maiores Entre Si

    {Ajustar a Posi��o Horizontal Do Bot�o Posicionado Mais a Esquerda. E, Em Seguida, Ir Ajustando Horizontalmente
     Os Demais Bot�es Em Sequencia, Cada Um a Partir Do Anterior, Considerando o Espa�o Entre Margens Desejado:}
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
   Em Sua Totalidade, O Navegador Web Deve Estar Maximizado. Contudo, Eventualmente O Usu�rio
   Poder� N�o Estar Usando O Navegador Maximizado E, Neste Caso, � Necess�rio Que Haja Um
   Mecanismo Que Permita A Rota��o Horizontal E Vertical Do Aplicativo Dentro Dos Limites
   Oferecidos Pelo Navegador, Considerando Afinal Que, Neste Caso, As Dimens�es Do Navegador
   Equivaler�o �s Que Seriam As Da Pr�pria �rea De Trabalho Completa Correspondente Caso O
   Aplicativo Rodasse Em Modo Desktop Comum.

   Esta Situa��o Afeta Os "Forms" Que Funcionam Naturalmente Maximizados E N�o Afeta Aqueles
   Outros, Normalmente Auxiliares, Que N�o Cobrem Toda A �rea Da Tela. A T�cnica Para Resolver
   Isto Conforme Implementada Abaixo Faz Uso De Diversos Detalhes Que Ser�o Explicados A Seguir.

   Para Que Isto Funcione, Cada "Form" Dever� Conter Um "Panel" Imediatamente Dentro Dele. E
   Este "Panel" � Que Conter� Todos Os Demais Componentes Visuais Daquele "Form". Durante a
   Execu��o, A Largura E Altura Deste "Panel" Ser�o Dimensionados Nos Limites Reais Maximizados
   Que Seriam Os Ideais Para A Execu��o Do Aplicativo. E, Por Sua Vez, O "Form" Que Cont�m
   Diretamente O "Panel", Este � Que Ter� Largura E Altura Dimensionados Conforme A �rea
   Efetivamente Dispon�vel Dentro Do Navegador Web. Para Completar, O "Form" Ser� Setado Com
   "Autoscrolls" Para Que As Barras De Rolagem Horizontal E Vertical Sejam Mostradas Caso o
   Dimensionamento Do Navegador Web Seja Menor Do Que O Efetivamente Necess�rio Para A Vis�o
   Completa Do "Panel".

   Menciona-se Ainda Que, Inicialmente, Em Tempo de "Design" da Aplica��o, Dentro da IDE do Delphi,
   Os "Forms" Dever�o Estar Setados Com Sua Propriedade "Windowstate" em "wsMaximized" ou "wsNormal"
   Conforme Sejam Para Serem Mostrados Maximizados Ou N�o Dentro do Navegador Web. E Quando Maximizados,
   Se o Navegador Web N�o Puder Conte-los, Ent�o Aparecer�o Com as Respectivas Barras de Rolagem.

   E Dentro de Cada Um Destes "Forms", o "Panel" Que Representar� Todo o Conte�do Deste "Form", Dever�
   Estar Inicialmente, no Tempo de "Design", Com "Align" em "alClient".

   Este Procedimento De Ajuste Deve Ser Chamado No "OnShow" De Todos Os "Forms". O "Windowstate"
   De Cada "Form" J� Estar� Setado Para Definir Quais Devem Parecem Maximizados e Quais Estar�o
   Em Estado Normal. O "Panel" Que Far� Diretamente O Fundo De Cada "Form" Ter� a Mesma Dimens�o
   Do "Form" Que � Seu Parent Direto, e Ter� "Align" Inicial Como "alClient". Por Sinal, Aqui, Dentro
   Deste Procedimento, o "Align" do "Panel" Ser� Ent�o Colocado Em "alNone". Note Que Esta Necessidade
   Do "Panel" Estar Com "Align" Inicial Em "AlClient" S� � Realmente Necess�ria Se o "Form" Que o
   Conter For Ser Maximizado. Caso Contr�rio, o "Align" Inicial do "Panel" Poder� Estar em "alNone" Ou
   Qualquer Outro Estado.}

  if ( Panel.Parent is TForm ) then
    if ( TForm( Panel.Parent ).WindowState = wsMaximized ) then
    begin
      {Foi Confirmado Que Trata-se de Um "Panel" de Fundo de Um "Form" Que � Maximizado Em
       Toda a �rea de Tela Dispon�vel. Somente Neste Caso Segue o Procedimento. Atribui-se
       Ao "Panel" Dimens�es de Largura e Altura M�nimas Para Conter Todos Os Componentes
       Visuais Necess�rios:}
      Panel.Align := alNone;
      Panel.Width := Max( 1280, Screen.Width );    // O N�mero Representa Uma Largura Minima Em Pixels de Uma Tela Adequada
      Panel.Left := 0;
      Panel.Height := Max( 644, Screen.Height );   // O N�mero Representa Uma Altura Minima Em Pixels de Uma Tela Adequada
      Panel.Top := 0;

      {Verificar Se a Largura do "Form" Que Cont�m o "Panel" � Suficiente Para Mostrar Todo o
       Seu Conte�do. O N�mero Usado no "If" Abaixo Representa o Tamanho das Margens Que As
       Pr�prias Barras de Rolagem Iriam Consumir do Espa�o de Desenho:}
      if ( ( TForm( Panel.Parent ).Width + 16 ) < Panel.Width )  then
      begin
        {As Dimens�es do "Form", Que na Pr�tica S�o As Mesmas Dimens�es da Janela do Navegador Web
         N�o S�o Suficiente Para Conter o "Panel" e Todos os Seus Componentes. Ent�o As "Scroolbars"
         No "Form" Que Cont�m o "Panel" S�o Necess�rias. Primeiro Estas Barras S�o Desligadas Para
         Provocar Um "Reset" Nos Controle e Em Seguida S�o Ligadas:}
        TForm( Panel.Parent ).AutoScroll := False;
        TForm( Panel.Parent ).AutoScroll := True;
      end
      else
      begin
        {As Dimens�es do "Form", Que na Pr�tica S�o As Mesmas Dimens�es da Janela do Navegador Web
         S�o Suficiente Para Conter o "Panel" e Todos os Seus Componentes. Ou Seja, Nestas Dimens�es
         N�o H� Necessidade De Barras de Rolagem Neste "Form":}
        TForm( Panel.Parent ).AutoScroll := False;
        Panel.Left := 0;
        Panel.Top := 0;
      end;

      {Marcar Este "Panel" Para Saber Que Ele � Um Panel de Fundo de Todos os Demais Componentes
       Visuais e Que o Seu "Parent" � o Pr�prio "Form" Que o Cont�m. Esta Marca��o Ser� �til Na Execu��o
       Do Procedimento de Redimensionamento de "Forms" do Thinfinity Virtual UI. Isto Porque, Quando Ocorre
       Um Redimensionamento do Navegador Web, N�o Apenas o "Form" Atualmente Ativo, Mas Todos Os Outros
       "Forms" Maximizados da Aplica��o, Embora N�o Vis�veis Naquele Momento, Poder�o Depois Vir a Ser
       Novamente Mostrados e Dever�o Estar Dimensionados De Acordo Com o Espa�o Dispon�vel do Navegador Web.

       Eventualmente, Embora N�o Tenha Sido Testado, Talvez N�o Houvesse Necessidade Desta Marca��o e Ent�o
       Tamb�m Poderia Ser Dispensada a Fun��o de Redimensionamento de "Forms" do Thinfinity Virtual UI. Em
       Contrapartida, Para Assegurar o Redimensionamento dos Outros "Forms" Maximizados Eventualmente Invis�veis, a
       Alternativa Poderia Ser a Chamada Deste Presente Procedimento N�o Apenas no No "OnShow" De Todos Os "Forms"
       Mas Tamb�m no "OnActivate" de Todos Eles.}
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
  {Quando Forms Desta Aplica��o Encontram-se no Estado Maximizado Para Que Aparecam Cobrindo Toda a
   �rea do Navegador Web Onde Aparecem. E Eventualmente o Pr�prio Navegador Web Dentro do Qual Roda
   Esta Aplica��o Pode Ser Redimensionado. Por Exemplo, Este Navegador Web Que Estava em Janela Menor Foi
   Maximizado Pelo Usu�rio. Nesta Situa��o, Como na Pr�tica Isto N�o � Um Resize Normal, � Necess�rio
   Percorrer Todos os Forms Existentes, Que Estejam Criados Naquele Momento, Embora Eventualmente Invis�veis e
   Que Estejam Maximizados, De Forma a Setar as Suas Novas Dimens�es Maximizadas:}

  {Percorrer Todos os Componentes da Aplica��o:}
  for ContForms := 0 to Application.ComponentCount - 1 do
  begin
    {Verificar Se Este Componente � Um "Form":}
    if ( Application.Components[ ContForms ] is TForm ) then
    begin
      {Verificar Se Este "Form" Est� Maximizado:}
      if ( TForm( Application.Components[ ContForms ] ).WindowState = wsMaximized ) then
      begin
        {Verificar Se Este "Form" Maximizado � Outro Que N�o o Pr�prio "Form" Atual. Neste
         Caso Ele N�o Precisa Ser Processado Por Que Isto J� Ocorreu No "OnResize" Dele Pr�prio.
         De Qualquer Forma o "If" a Seguir Destina-se Apenas a Esta Otimiza��o e Poderia Ser
         Dispensado.}
        Form := TForm( Application.Components[ ContForms ] );
        if ( Form <> Self ) then
        begin
          {Este � Um "Form" Maximizado e Que Precisa Ser Redimensionado Conforme Novo Tamanho
           Do Navegador Web Dentro do Qual Est� Sendo Rodada a Aplica��o. Aqui Ser� Necess�rio
           Procurar o "Panel" Contido Neste "Form" e Que Apoiar� a Eventual Necessidade de
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

          {Embora Seja Obrigat�rio Que o "Panel" de Dimensionamento Auxiliar Tenha Sido
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
  {Gravar Configura��o Inicial do Programa Para Que Possa Ser
   Lida No In�cio da Pr�xima Execu��o:}
  GravarConfiguracaoInicial;

  {Gravar Log Hist�rico De Eventos:}
  if frmLogin.UsuarioAutenticado then
    GravarLinhaNoLogHistoricoDeEventos( 'Logout')
  else
    GravarLinhaNoLogHistoricoDeEventos( 'Tentativa Login Fracassada Apos ' +
      FormatarInteiroComZerosEsquerda( frmLogin.ContadorDeTentativas, 2 ) + ' Tentativa(s)' );

  sqlConnection.Close;

  {Executar Provid�ncias Sist�micas de Sa�da da Aplica��o. Elas Valem Para Todos Os
   Programas Deste Tipo e Definem a Rela��o Inicial Do Aplicativo Com o Sistema Oepracional
   E Com o Equipamento Computacional Que o Est� Executando. S�o Setadas Na Entrada e Algumas
   Delas Precisam Ser Resetadas na Sa�da:}
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
  {Verificar e Tratar Outros Casos de Excess�es de Execu��o:}
  PrecisaDeAtencaoEspecial_SaidaDoPrograma := False;

  Mensagem01 := Trim( AnsiUpperCase( E.Message ) );
  RemoverDiacriticos( Mensagem01 );

  if      ( Pos( 'VALOR DE PARAMETRO INCORRECTO', Mensagem01 ) > 0 ) then
  begin
    {Esta Exception Eventualmente Ocorre na Biblioteca GMMap (API Espanhola De
     Acesso ao Google Maps). A Exception Foi Observada Quando H� Pontos
     Marcados Sobre o Mapa Google (Via Classe GMMaker) e Devem Ser Retirados
     Com Carga De Outros Novos. A Exception � Lan�ada No Redesenho Dos Novos
     Pontos. Ela Ocorre Sem Motivo, Provavelmente Devido "Bug" Na Biblioteca e
     Sua Ocorr�ncia N�o Traz Outras Consequ�ncias. Assim Ela Pode Ser Totalmente
     Ignorada, Inclusive Dispensando Seu Registro No Log de Eventos da Aplica��o:}
    CodigoDoErro := 0;
  end

  else if ( Pos( 'ID DO JAVASCRIPT NA', Mensagem01 ) > 0 ) then
  begin
    {Da Mesma Forma Que a Exception Descrita Acima, Esta Outra Exception
     Eventualmente Ocorre na Biblioteca GMMap (API Espanhola De
     Acesso ao Google Maps). A Exception Foi Observada Quando H� Pontos
     Marcados Sobre o Mapa Google (Via Classe GMMaker) e Devem Ser Retirados
     Com Carga De Outros Novos. A Exception � Lan�ada No Redesenho Dos Novos
     Pontos. Ela Ocorre Sem Motivo, Provavelmente Devido "Bug" Na Biblioteca e
     Sua Ocorr�ncia N�o Traz Outras Consequ�ncias. Assim Ela Pode Ser Totalmente
     Ignorada, Inclusive Dispensando Seu Registro No Log de Eventos da Aplica��o:}
    CodigoDoErro := 0;
  end

  else if ( ( Pos( 'IS NOT A VALID DATE'                 , Mensagem01 ) > 0 ) or
            ( Pos( 'COULD NOT PARSE SQL TIMESTAMP STRING', Mensagem01 ) > 0 ) ) then
  begin
    CodigoDoErro := 1;

    MensagemAoUsuario :=
      'A Data Informada � Inv�lida.';
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
        'O Campo ' + Mensagem02 + ' � Obrigat�rio.';
    end

  else if ( Pos( 'KEY VIOLATION', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 3;

    MensagemAoUsuario :=
      'Houve Viola��o de Chave Prim�ria.';
  end

  else if ( Pos( 'INPUT VALUE',  Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 4;

    MensagemAoUsuario :=
      'O Valor Informado � Inv�lido.';
  end

  else if ( Pos( 'IS NOT A VALID TIME', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 5;

    MensagemAoUsuario :=
      'A Hora Informada � Inv�lida.';
  end

  else if ( Pos( 'O ARQUIVO JA ESTA SENDO USADO', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 6;

    MensagemAoUsuario :=
      'O Banco de Dados Deste Programa J� Est� Em Uso Por Outro Aplicativo.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'O SISTEMA NAO PODE ENCONTRAR O ARQUIVO', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 7;

    MensagemAoUsuario :=
      'N�o � Poss�vel Encontrar Um Arquivo Que � Necess�rio Ao Funcionamento Deste Programa. ' +
      'Voc� Dever� Reinstalar o Aplicativo Para Que Volte a Funcionar!';

      PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'APLICATIVO JA EM EXECUCAO', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 8;

    MensagemAoUsuario :=
      'Este Programa J� Est� Em Execu��o. Utilize a C�pia Que Est� Em Funcionamento!';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'GUIA NAO ENCONTRADO', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 9;

    MensagemAoUsuario :=
      'O Arquivo Contendo o Guia Eletr�nico Do Usu�rio N�o Est� Instalado.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := False;
  end

  else if ( Pos( 'UNAVAILABLE DATABASE', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 10;

    MensagemAoUsuario :=
      'N�o � Poss�vel Fazer Acesso Ao Banco De Dados. ' +
      'Poss�vel Aus�ncia da Biblioteca DLL De Acesso.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'NO PERMISSION FOR READ-WRITE', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 11;

    MensagemAoUsuario :=
      'N�o � Poss�vel Fazer Acesso Para Escrita No Banco De Dados. ' +
      'Poss�vel Bloqueio "Read-Only" Nos Arquivos de Utiliza��o.';
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
      'N�o � Poss�vel Instalar Este Aplicativo a Menos Que Se Fa�a ' +
      'Autentica��o de Login Como Usu�rio Administrador.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'SOCKET ERROR', Mensagem01 ) > 0 ) or
          ( Pos( 'CONEXAO COM O SERVIDOR NAO PODE SER ESTABELECIDA ', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 14;

    MensagemAoUsuario :=
      'H� Algum Problema Relacionado Ao Funcionamento Da Rede, Conex�o Ou Acesso a Internet.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := False;
  end

  else if ( Pos( 'ACCESS VIOLATION AT ADDRESS', Mensagem01 ) > 0 ) then
  begin
    CodigoDoErro := 15;

    MensagemAoUsuario :=
      'Acesso a Endere�o Indevido No Mapeamento Reservado Da Mem�ria De Execu��o.';
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := True;
  end

  else if ( Pos( 'NAO FOI POSSIVEL CONCLUIR A OPERACAO. ERRO: 80020101', Mensagem01 ) > 0 ) then
  begin
    {Esta Exception Ocorre Quando H� Erro na Execu��o de C�digo JavaScript Sobre
     Um Objeto TWebBrowser. Uma Causa Comum � Falta de Conex�o ou Instabilidades de
     Conex�o Durante o Uso, Por Exemplo, da Biblioteca GMMap (API Espanhola De
     Acesso ao Google Maps).}
    CodigoDoErro := 16;

    MensagemAoUsuario :=
      'H� Falhas Na Conex�o Com a Internet Ou Instabilidades de Conex�o Que Impedem o Funcionamento.';
  end

  else
  begin
    CodigoDoErro := 10000;   // Erro Gen�rico

    MensagemAoUsuario := Mensagem01;
    PrecisaDeAtencaoEspecial_SaidaDoPrograma := False;
  end;

  if ( CodigoDoErro > 0 ) then
  begin
    {Gravar Log Hist�rico De Eventos:}
    GravarLinhaNoLogHistoricoDeEventos( 'Exception ' + QuotedStr( E.Message ) );

    {Formatar a Apresenta��o Da Mensagem Ao Usu�rio:}
    MensagemAoUsuario :=
      Trim( 'Ocorreu Excess�o De Execu��o Com a Seguinte Mensagem:' + RetornoDeCarro( 01 ) + MensagemAoUsuario );

    MensagemAoUsuario :=
      WrapText(
        MensagemAoUsuario,
        RetornoDeCarro( 01 ),
        [' ', '.', ':', ';', ',', '-'],
        60 );   // Parte a Mensagem De Erro Em Linhas Com At� 60 Caracteres

    MensagemDeTituloDoDialogo := NomeCompletoDestePrograma + '- Mensagem de Excess�o - ';
    if PrecisaDeAtencaoEspecial_SaidaDoPrograma then
    begin
      MensagemDeTituloDoDialogo := MensagemDeTituloDoDialogo + 'Impede Seguimento';
      MensagemAoUsuario := MensagemAoUsuario + RetornoDeCarro( 02 ) + 'A Execu��o Ser� Encerrada.';
    end
    else
    begin
      MensagemDeTituloDoDialogo := MensagemDeTituloDoDialogo + 'N�o Impede Seguimento';
    end;

    MessageBeep( MB_ICONHAND );

    AcionarFormProsseguir(
      MensagemAoUsuario,
      MensagemDeTituloDoDialogo,
      '',
      'Prosseguir',
      PrecisaDeAtencaoEspecial_SaidaDoPrograma );

    {Se For o Caso, Faz o Encerramento For�ado Da Execu��o:}
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

