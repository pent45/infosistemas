unit uRotinasGerais;

interface

uses
  SysUtils, Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Jpeg, Menus, StdCtrls, Mapi, ShellApi, ShlObj,
  ActiveX, ComObj, Registry, StrUtils, WinInet, DB, DBGrids, URLMon, SHDocVw,
  MSHTML, IdHTTP, ExtActns, IBQuery, DDEMan, Printers, Math, IdMessage, IdSMTP,
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL,
  XSBuiltIns, MMSystem, WinSock, Grids, Inifiles, Quickrpt, DateUtils, Chart,
  TeEngine, Series, GraphUtil, PngImage, HTTPApp, SynPdf, Buttons, MSxml;

const
  {Definir Cores Alternativas e Adicionais:}
  clPaleGoldenRod                                         = TColor( $AAE8EE );
  clDarkGoldenRod                                         = TColor( $0B86B8 );
  clGold                                                  = TColor( $00D7FF );
  clLightSteelBlue                                        = TColor( $DEC4B0 );
  clGainsboro                                             = TColor( $DCDCDC );
  clOrange                                                = TColor( $0080FF );

  {Cores Padrão De Comportamento De Painéis Que Funcionam Como Botões:}
  CorPanelNoPapelDeButtonComumApontadoPeloMouse           = clGreen;
  CorFontPanelNoPapelDeButtonComumApontadoPeloMouse       = clWhite;
  CorPanelNoPapelDeButtonComumNaoApontadoPeloMouse        = clPaleGoldenRod;
  CorFontPanelNoPapelDeButtonComumNaoApontadoPeloMouse    = clBlack;
  CorPanelNoPapelDeButtonDeSaidaApontadoPeloMouse         = clGreen;
  CorPanelNoPapelDeButtonDeSaidaNaoApontadoPeloMouse      = clMaroon;

  {Constantes Para Verificar Se é Usuário Administrador:}
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority          = ( Value: ( 0, 0, 0, 0, 0, 5 ) );
  SECURITY_BUILTIN_DOMAIN_RID                             = $00000020;
  DOMAIN_ALIAS_RID_ADMINS                                 = $00000220;

type
  TWinVersion = ( wvUnknown,
                  wvWin95,
                  wvWin98,
                  wvWinNT,
                  wvWin2000,
                  wvWinVista,
                  wvWinSeven );

  TShortCutPlace = ( stDesktop, stStartMenu, stAutoStartUp );

  TControlClasseAlternativaParaRedimensionarTamanhoFonteCaracteres = Class( TControl );

  {
  A Classe TPanel Abaixo Será Criada Para Tratar Painéis Que Farão Papel De
  Botões, Sendo Que Serão Destacados Conforme o Mouse Se Move Sobre Eles:
  }
  TPanel  = class( ExtCtrls.TPanel )
  private
    fOnMouseEnter: TNotifyEvent;
    fOnMouseLeave: TNotifyEvent;
  protected
    procedure CMMouseEnter(var Msg : TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg : TMessage); message CM_MOUSELEAVE;
  public
    property OnMouseEnter: TNotifyEvent read fOnMouseEnter write fOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read fOnMouseLeave write fOnMouseLeave;
  published
    procedure MouseEntrouEmUmPanelNoPapelDeButtonComum(Sender: TObject);
    procedure MouseSaiuDeUmPanelNoPapelDeButtonComum(Sender: TObject);
    procedure PrepararDestaqueParaPanelQueFuncionaComoButtonComumQuandoForApontadoPeloMouse;
    procedure MouseEntrouEmUmPanelNoPapelDeButtonDeSaida(Sender: TObject);
    procedure MouseSaiuDeUmPanelNoPapelDeButtonDeSaida(Sender: TObject);
    procedure PrepararDestaqueParaPanelQueFuncionaComoButtonDeSaidaQuandoForApontadoPeloMouse;
  end;

  {
  Thread Destinada a Identificar Números IP e Localização Física Aproximada Tanto da
   Estação Usuária Como Cliente Assim Como do Servidor Web, Caso Esteja Sendo Utilizado na Web:
  }
  TThreadIdentificarLocalizacaoEnderecosIPEmUso = class(TThread)
  protected
    constructor Create(CreateSuspended: Boolean);
    procedure Execute; override;
  end;

  TColorArray = Packed Array of TColor;

  function GerarCorRandomica( Mix: TColor ): TColor;

  function AjustarCorParaMaisEscuraOuClara( Cor: TColor; PorcentualClaridade: Integer): TColor;

  function FormatarFloat(
    Valor: Double; Tamanho, Decimais: Integer ): String;

  function FormatarFloatAssegurarPontoSeparaDecimal(
    Valor: Double; Tamanho, Decimais: Integer ): String;

  function FormatarInteiroComZerosEsquerda(
    Valor: LongInt; Tamanho: Integer ): String;

  function FormatarInteiroComBrancosEsquerda(
    Valor: LongInt; Tamanho: Integer ): String;

  function FormatarStringComNumeroPadronizadoDeCaracteres(
    Palavra: String;
    Tamanho: Integer ): String;

  function FormatarCep(
    Cep: LongInt ): String;

  procedure CriarAtalhoParaAplicativoNoWindows(
    FileName, Parameters, InitialDir, ShortCutName, ShortCutFolder: PChar;
    Place: TShortCutPlace );

  procedure CriarAtalhoParaLinkInternetNosFavoritosDoWindows(
    FileName, Parameters, InitialDir, NomeDoAtalho, PastaOndeGravar: String );

  procedure PegarDadosDoRegistro(
    var Pop3_UserName, Smtp, NomeRemetente, Email: String );

  function ExtrairNomeLongoDoArquivoPassadoComoParametro: String;

  function ExtrairDiretorioWindows: String;

  function ExtrairDiretorioSystem: String;

  function ExtrairDiretorioArquivosDeProgramas: String;

  function ExtrairDiretorioMeusDocumentos: String;

  function ExtrairDiretorioDesktop: String;

  function ExtrairDiretorioMenuInicialProgramas: String;

  function EnviarArquivoParaLixeira(
    NomeDoArquivo: String ): Boolean;

  procedure InstalarEsteAplicativoAtualExecutavel(
    SubPastaDeInstalacaoSobArquivosDeProgramas, NomeCompletoDestePrograma: String );

  function CopiarOuMoverArquivoUsandoShellDoWindows(
    ArquivoOrigem, ArquivoDestino: String;
    ManterOriginal: Boolean ): Boolean;

  function  CopiarArquivo(
    Source, Dest: String ): Boolean;

  procedure CopiarArquivoViaFileStream(
    const SourceFileName, TargetFileName: String );
    
  procedure CopiarPasta(
    Handle: THandle; fromDir, toDir: String );

  procedure MoverPasta(
    Handle: THandle; fromDir, toDir: String );

  function ApagarArquivo(
    Filename: String;
    ToRecycle: Boolean ): Boolean;

  function ApagarPasta(
    DirName: String;
    ToRecycle: Boolean ): Boolean;

  function CompararDoisArquivos_VerSeSaoIdenticos(
    const NomeArquivo1, NomeArquivo2: TFileName): Boolean;

  function EstaConectadoNaInternet: Boolean;

  function EstaConectadoNaInternetAlternativa: Boolean;

  function UrlExiste(
    const Url: String ): Boolean;

  procedure AcionarBotaoIniciarDoWindows;

  function EstaStringContemUmNumeroInteiro(
    var Texto: String ): Boolean;

  function DeixarSoCaracteresIniciais(
    Entrada: String ): String;

  function UpperCase_SoCaracteresIniciais(
    Entrada: String ): String;

  procedure RemoverDiacriticos(
    var Entrada: String );

  procedure RemoverDiacriticosDeWideStringPreservandoCaixa(
    var Entrada: WideString );

  procedure RemoverNaoNumericos(
    var Entrada: String );

  procedure RemoverCRLFDeWideStringColocandoPontoVirgulaNoLugar(
    var Entrada: WideString );

  procedure RemoverDiacriticosFormatoEspecialBiCaracter(
    var Memo: TMemo );

  procedure RemoverLetrasRepetidas(
    var Entrada: String );

  procedure RemoverNaoUsuaisParaTextoSMS(
    var Entrada: WideString );

  procedure SetarBordaCtrl3DWebNavegador(
    webNavegador: TWebBrowser;
    DeixarNaFormaCtrl3D: Boolean );

  procedure CapturarImagemBitmapDaTelaInteira(
    var Bitmap: TBitmap );

  procedure CapturarImagemBitmapDaTelaSubArea(
    var Bitmap: TBitmap;
    const AreaCapturar: TRect );

  procedure CapturarImagemBitmapDeNavegadorWeb(
    Navegador: TWebBrowser;
    FormHandle: HWnd;
    var Bitmap: TBitmap );

  procedure CapturarPainelContendoNavegadorWebEmImagemJPEG(
    Painel: TPanel;
    NavegadorWeb: TWebBrowser;
    var ImagemCapturadaJPEG: TJPegImage );

  function RetornoDeCarro(
    QtdRetornosDeCarro: Integer ): String;

  procedure Formatar_CpfOuCgc(
    Numero: String;
    var NumeroFormatado: String;
    var Tipo: Integer;
    var Valido: Boolean );

  function Formatar_Cpf(
    Numero: String ): String;

  function Formatar_Cgc(
    Numero: String ): String;

  function Checar_Cpf(
    Numero: String ): Boolean;

  function Checar_Cgc(
    Numero: String ): Boolean;

  function PegarVersaoDesteExecutavel: String;

  function PegarVersaoDoWindows(
    var NumeroDaVersao: String ): TWinVersion;

  Function PegarNomeUsuarioDoWindows: String;

  function PegarNomeDoComputadorEmUso: String;

  function PegarSitesFavotitos(
    TamanhoMaximoDeLetrasDeCadaString: Integer ): TStrings;

  {As Duas Funções a Seguir Destinam-se a Oferecer o Recurso de Discagem Telefônica Por Voz Automática Do Windows.
   Para Isto é Necessário Que Haja Um Hardware Adequado No Computador Usuário: Um Modem Discador Comum.

   Para Que Possam Funcionar de Forma Correta é Necessário Que o Windows Tenha Sido Configurado De Forma Adequada
   Para Esta Finalidade, o Que Normalmente Não é a Forma Padrão Que Ele Adota Imediatamente Após a Sua
   Instalação. Para Realizar Esta Configuração Deve-se Seguir o Seguinte Roteiro:

   1. Ir Ao Painel de Controle do Windows.
   2. Selecionar o Ícone "Adicionar ou Remover Programas".
   3. Na Janela Que Aparece, Selecionar a Guia "Adicionar/Remover Componentes do Windows".
   4. Selecionar a Opção "Comunicações".
   5. Checar a Opção "Discagem Automática".
   6. Confirmar a Inclusão da Funcionalidade Discagem Automática.

   Além Disto é Necessário Também Que Sejam Definidas Corretamente As "Propriedades de Discagem" Do Modem Que Estiver
   Sendo Utilizado. Em Especial o Número a Discar Para Obter Uma Linha Externa, o Fato Da Discagem Se Por Tom ou
   Pulso e a Respeito de Aguardar Tom Antes de Discar.}

  function tapiRequestMakeCall( lpszDestAddress, ipszappname, lpszCalledParty, lpszcomment: Lpcstr ): longint; stdcall; external 'tapi32.dll';

  function ArquivoEstaEmUtilizacao(
    fName: String): Boolean;

  procedure DefinirZoomVisualParaNavegadorWeb(
    WebNavegador: TWebBrowser;
    FatorDeZoom: Real );

  procedure TrocarTodasAsImagensDeUmNavegadorWeb(
    WebNavegador: TWebBrowser;
    NomeDoArquivoDeImagem: String );

  procedure ArredondarCantosDeUmControle(
    var Controle: TWinControl );

  procedure ReiniciarEsteAplicativo;

  procedure PostKeyEx32(
    Key: Word;
    const Shift: TShiftState;
    Specialkey: Boolean );

  function PegarNumeroDaLinhaEmQueEstaPosicionadoUmMemo(
    Extracao: TMemo ): Integer;

  {
  A Função a Seguir Retorna a Pasta Padrão De Qualquer Diretório Notável do Windows.
  O Parâmetro De Consulta CSIDL, Possui Identificadores Que Exigem "Uses ShlObj" e
  Deve Ser Passado De Acordo Com a Seguinte Tabela:

  CSIDL_BITBUCKET	 : Para Lixeira
  CSIDL_CONTROLS   : Para Painel de Controle
  CSIDL_DESKTOP    : Para Windows Desktop
  CSIDL_DESKTOPDIR : Para Windows Desktop Na Árvore Física de Arquivos
  CSIDL_FONTS      : Fontes de Caracteres
  CSIDL_NETHOOD    : Para Rede Na Árvore Física de Arquivos
  CSIDL_NETWORK    : Para Rede
  CSIDL_PERSONAL	 : Meus Documentos
  CSIDL_PRINTERS   : Impressoras
  CSIDL_PROGRAMS   : Arquivos de Programas
  CSIDL_RECENT     : Último Utilizado
  CSIDL_SENDTO     : Enviar Para
  CSIDL_STARTMENU  : Menu Iniciar
  CSIDL_STARTUP    : Inicialização Automática
  CSIDL_TEMPLATES  : Templates
  }
  function ExtrairDiretorioNotavel(
    CSIDL: Integer ): String;

  function VerificarSeExisteUmFonteDeCaracteresSobWindows(
    NomeDoFonteTTF: String ): Boolean;

  function InstalarUmFonteDeCaracteresSobWindows(
    NomeDoArquivoDeFonteTTF: String ): Boolean;

  procedure CachoalharUmForm(
    Form: TForm;
    NumeroDeCachoalhos: Integer;
    AplitudeMaxima: Integer );

  function PegarConteudoPaginaHTMLComCampoIdentificadoPorName(
    webNavegador: TWebBrowser;
    NomeDoCampo: String ): String;

  function GetFormByNumber(
    document: IHTMLDocument2;
    formNumber: Integer ): IHTMLFormElement;

  function GetFieldValue(
    FromForm: IHTMLFormElement;
    const fieldName: String): String;

  function UsuarioAdministrador: Boolean;

  procedure AbrirInternetExplorerPersonalizado(
    Esquerda, Topo, Largura, Altura: Integer;
    BarraDeMenu, BarraDeEnderecos, BarraDeEstado, Redimensionavel: Boolean;
    EnderecoUrl: String );

  procedure AssociarExtensaoTipoDeArquivoComExecutavel(
    ExtensaoSemPontoInicial: String;
    NomeArquivoExecutavelAplicacao: String );

  procedure ConverterValorDeIntervaloParaEquivalenteEmOutroIntervalo(
    IntervaloDeOrigem: TPoint;
    ValorDeOrigem: Integer;
    IntervaloDeDestino: TPoint;
    var ValorDeDestino: Integer );

  procedure ConverterPontoDeAreaParaEquivalenteEmOutraArea(
    AreaDeOrigem: TRect;
    PontoDeOrigem: TPoint;
    AreaDeDestino: TRect;
    var PontoDeDestino: TPoint );

  procedure ConverterSubAreaDeAreaParaEquivalenteEmOutraArea(
    AreaDeOrigem: TRect;
    SubAreaDeOrigem: TRect;
    AreaDeDestino: TRect;
    var SubAreaDeDestino: TRect );

  procedure BitmapTrocarUmaCorPorOutra(
    Bitmap: TBitmap;
    CorAnterior: TColor;
    CorNova: TColor;
    PorcentualTolerancia: Double );

  procedure ConverterPictureParaFormatoBitmapSeJaNaoEstiver(
    Picture: TPicture );

  function ModoEventualmenteAbreviadoDeUmaString(
    const Mensagem: String;
    const TamanhoMaximo: Integer ): String;

  function PegarNomeDoComputadorEnderecoIPRedeLocalEnderecoIPInternet(
    var NomeDoComputador, EnderecoIPNaRedeLocal, EnderecoIPNaInternetGlobal, ErroEventualmenteOcorrido: String ): Boolean;

  function PegarEnderecoIPNaRedeLocal: String;

  function PegarEnderecoIPNaRedeExterna: String;

  function PegarEnderecoIPNaRedeExterna_2: String;

  function PegarDadosCoordenadasDaLocalizacaoFisicaUsandoIPExterno(
    IPExterno: String;
    var NomeDoEstado: String;
    var NomeDoMunicipio: String;
    var Latitude: Double;
    var Longitude: Double ): String;

  procedure ExecutarShellExecute(
    Comando: String );

  function EnviarEmailCompletoInclusiveComSSL(
    Nome_Exibicao_Remetente: String;
    Email_Exibicao_Remetente: String;
    Assunto: String;
    Usuario_Conta_Smtp: String;
    Usuario_Senha_Smtp: String;
    Servidor_Smtp: String;
    Porta_Smtp: Integer;
    Autenticar_Usuario: Boolean;
    Autenticar_SSL: Boolean;
    Prioridade: TIdMessagePriority;
    Corpo_Texto_Plano: String;
    Corpo_Arquivo_HTML: String;
    Destinatarios_Abertos: String;
    Destinatarios_Ocultos: String;
    Nomes_Arquivos_Anexos: TStringList;
    ConteudoXML: TStringList;
    DevePersonalizarConteudoHTML: Boolean;
    Equipamento: String;
    EmailRetorno: String ): Boolean;

  function SetDllDirectory(lpPathName:PWideChar): Bool; stdcall; external 'kernel32.dll' name 'SetDllDirectoryW';

  procedure WinInet_HttpsPost(
    const Url: String;
    Stream: TStringStream );

  procedure LerConfiguracaoInicial;

  procedure GravarConfiguracaoInicial;

  procedure GravarLinhaNoLogHistoricoDeEventos(
    LinhaDescritiva: String );

  procedure EsperarSegundos(
    Segundos: Double;
    ExecutarComutandoParaCursorDeEspera: Boolean );

  procedure ExportarQuickReportComoPdf(
    QuickRep: TQuickRep; const aFileName: TFileName; JaEstaPreparado: Boolean );

  function Criptografa(
    Entrada: String ): String;

  function Descriptografa(
    Entrada: String ): String;

  function CriptografarDescriptografarSenhaUsandoChaveSimetrica(
    Criptografar: Boolean;
    TextoOrigem, ChaveSimetrica: String;
    var TextoOuChaveComCaracteresInvalidos: Boolean ): String;

  function ChaveHashDeData(
    Data: TDate ): String;

  function CapsLockLigado: Boolean;

  function NumsLockLigado: Boolean;

  procedure SetarComponentesWebBrowserDestaAplicacaoComPadraoEmulacaoInternetExplorer11;

  {
  A Função a Seguir Retorna "True" Se o Computador Com a Aplicação Em Execução Estiver Com Seu
  Relógio Operando em Horário de Verão e "False" Se Estiver em Horário Normal ou Indefinido.
  }
  function Now_EstaComHorarioDeVeraoAtivo: Boolean;

  {
  A Função Now() Retorna a Data e a Hora do Computador Em Que o Programa Está Sendo Executado.
  Mas Eventualmente Este Computador é Um Servidor Web Cuja Data e Horário Estão Setados Para o Seu
  Próprio Fuso Horário e Que Não São Os Mesmos do Fuso Horário do Brasil em Brasília. A Função
  Abaixo Equivale a Função Now() Porém Retorna o Horário Oficial do Brasil em Brasília Independente
  Do Fuso Horário do Servidor Web Que Pode Estar Executando o Aplicativo. Além Disto Ela Também Já
  Considera e Desconta, Se For o Caso, a Possibilidade Deste Servidor Web Remoto Estar Operando Em
  Horário de Verão. Isto é, Ela Sempre Retorna, Independente do Local em Que Estiver o Computador
  Servidor Web, o Horário Padrão de Brasília. Menciona-se Apenas Que Ela Retorna o Horário Padrão
  De Brasília e Não Considera Se, Sobre Este Horário Que Ela Retorna, Que Ele Próprio Pode Estar
  Também Submisso ao Horário de Verão (Neste Caso, o Horário de Verão de Brasília).
  }
  function Now_NoFusoHorarioOficialDoBrasilEmBrasilia: TDateTime;

  function MouseEstaPosicionadoSobreUmControleVisualComBotaoEsquerdoPressionado( Controle: TControl ): Boolean;

  function LastPos( Substr: String; S: String ): Integer;

  function NomePastaPaiDeUmaRotaDeNomeArquivo( NomePasta: String ): String;

implementation

uses
  uPrincipal, uLogin;

procedure TPanel.CMMouseEnter(var Msg: TMessage);
begin
  {
  Caso Haja Necessidade, Problemas De Retraço Podem Ser Resolvidos Habilitando a Linha Abaixo:
  SetTimer( Handle, 1, 100, nil );
  }
  if Assigned( fOnMouseEnter ) then
    fOnMouseEnter( Self );
end;

procedure TPanel.CMMouseLeave(var Msg: TMessage);
begin
  {
  Caso Haja Necessidade, Problemas De Retraço Podem Ser Resolvidos Habilitando a Linha Abaixo:
  KillTimer( Handle, 1 );
  }
  if Assigned( fOnMouseLeave ) then
    fOnMouseLeave( Self );
end;

procedure TPanel.MouseEntrouEmUmPanelNoPapelDeButtonComum(Sender: TObject);
begin
  TPanel( Sender ).Color := CorPanelNoPapelDeButtonComumApontadoPeloMouse;
  TPanel( Sender ).Font.Color := CorFontPanelNoPapelDeButtonComumApontadoPeloMouse;
end;

procedure TPanel.MouseSaiuDeUmPanelNoPapelDeButtonComum(Sender: TObject);
begin
  TPanel( Sender ).Color := CorPanelNoPapelDeButtonComumNaoApontadoPeloMouse;
  TPanel( Sender ).Font.Color := CorFontPanelNoPapelDeButtonComumNaoApontadoPeloMouse;
end;

procedure TPanel.PrepararDestaqueParaPanelQueFuncionaComoButtonComumQuandoForApontadoPeloMouse;
begin
  Self.OnMouseEnter := MouseEntrouEmUmPanelNoPapelDeButtonComum;
  Self.OnMouseLeave := MouseSaiuDeUmPanelNoPapelDeButtonComum;

  MouseSaiuDeUmPanelNoPapelDeButtonComum( Self );
end;

procedure TPanel.MouseEntrouEmUmPanelNoPapelDeButtonDeSaida(Sender: TObject);
begin
  TPanel( Sender ).Color := CorPanelNoPapelDeButtonDeSaidaApontadoPeloMouse;
  TPanel( Sender ).BevelOuter := bvLowered;
end;

procedure TPanel.MouseSaiuDeUmPanelNoPapelDeButtonDeSaida(Sender: TObject);
begin
  TPanel( Sender ).Color := CorPanelNoPapelDeButtonDeSaidaNaoApontadoPeloMouse;
  TPanel( Sender ).BevelOuter := bvNone;
end;

procedure TPanel.PrepararDestaqueParaPanelQueFuncionaComoButtonDeSaidaQuandoForApontadoPeloMouse;
begin
  Self.OnMouseEnter := MouseEntrouEmUmPanelNoPapelDeButtonDeSaida;
  Self.OnMouseLeave := MouseSaiuDeUmPanelNoPapelDeButtonDeSaida;

  MouseSaiuDeUmPanelNoPapelDeButtonDeSaida( Self );
end;

constructor TThreadIdentificarLocalizacaoEnderecosIPEmUso.Create( CreateSuspended: Boolean );
begin
  inherited Create( CreateSuspended );
  Priority := tpIdle;
  FreeOnTerminate := True;
end;

procedure TThreadIdentificarLocalizacaoEnderecosIPEmUso.Execute;

  procedure IdentificarSetarEndereco( var IPEndereco, Local: String );
  var
    NomeDoEstado, NomeDoMunicipio: String;
    Latitude, Longitude: Double;
    ContTentativas: Integer;
  begin
    ContTentativas := 0;
    repeat
      PegarDadosCoordenadasDaLocalizacaoFisicaUsandoIPExterno( IPEndereco, NomeDoEstado, NomeDoMunicipio, Latitude, Longitude );
      if (NomeDoMunicipio <> '' ) and ( NomeDoEstado <> '' ) then
        Local := NomeDoMunicipio + ', ' + NomeDoEstado;
      ContTentativas := ContTentativas + 1;
    until ( Local <> '' ) or ( ContTentativas >= 3 );
  end;

begin
  Priority := tpIdle;
  FreeOnTerminate := True;

  try
    IPServidorWeb := 'Desktop';
    LocalServidorWeb := 'VirtualUI Não Ativo';

    IPAcessoInternet := PegarEnderecoIPNaRedeExterna_2;
    IdentificarSetarEndereco( IPAcessoInternet, LocalAcessoInternet );
  except
    {Nada}
  end
end;

function GerarCorRandomica( Mix: TColor ): TColor;
var
  Red, Green, Blue: Integer;
begin
  {Gerar Uma Cor Randômica, Mas Assgurando Que Cada Um Dos Seus Três Canais,
  Vermelho, Verde e Azul, Guarde Diferença Mínima De 10% Da Cor De
  Referência Passada Como Parâmetro:}

  Randomize;

  Red := Random( 256 );
  while ( ( Abs( Red - GetRValue( ColorToRGB( Mix ) ) ) / 255 ) < 0.1 ) do
    Red := Random( 256 );

  Green := Random( 256 );
  while ( ( Abs( Green - GetGValue( ColorToRGB( Mix ) ) ) / 255 ) < 0.1 ) do
    Green := Random( 256 );

  Blue := Random( 256 );
  while ( ( Abs( Blue - GetBValue( ColorToRGB( Mix ) ) ) / 255 ) < 0.1 ) do
    Blue := Random( 256 );

  Result := RGB( Red, Green, Blue );
end;

function AjustarCorParaMaisEscuraOuClara( Cor: TColor; PorcentualClaridade: Integer): TColor;
var
  Hue, Luminance, Saturation: Word;
begin
  {Esta Função Produz Variações de Uma Mesma Cor, Podendo Fazer Com Que Ela
   Escureça ou Clareie. Quanto Menor o Porcentual de Claridade, Mais Escura
   Ela Será e Quanto Maior o Porcentual de Claridade, Mais Clara Ela Será.
   Verificou-se Que é Possível Notar as Nuances de Uma Mesma Cor Com Porcentual
   De Claridade No Intervalo Entre 10% e 90%. Abaixo de 10% Há Tendência de
   Tornar-se Muito Próxima ao Preto. Acima de 90% Há Tendência de Tornar-se
   Muito Próxima ao Branco. Em 50% Há Equilíbrio Entre Preto e Branco. As
   Funções Usadas Abaixo Necessitam Declarar a Biblioteca "Uses GraphUtil".}

  PorcentualClaridade := Max( 000, PorcentualClaridade );
  PorcentualClaridade := Min( 100, PorcentualClaridade );

  ColorRGBToHLS( Cor, Hue, Luminance, Saturation );
  Result := ColorHLSToRGB( Hue, Round( 255 * PorcentualClaridade / 100 ), Saturation );
end;

function FormatarFloat(
  Valor: Double; Tamanho, Decimais: Integer ): String;
begin
  Result := Format( '%*.*n', [ Tamanho, Decimais, Valor ] );
end;

function FormatarFloatAssegurarPontoSeparaDecimal(
  Valor: Double; Tamanho, Decimais: Integer ): String;
begin
  Result := Format( '%*.*n', [ Tamanho, Decimais, Valor ] );
  Result := StringReplace( Result, ',', '.', [ rfReplaceAll ] ) ;
end;

function FormatarInteiroComZerosEsquerda(
  Valor: LongInt; Tamanho: Integer ): String;
begin
  Result := Format( '%*d', [ Tamanho, Valor ] );
  Result := StringReplace( Result, ' ', '0', [rfReplaceAll] );
end;

function FormatarInteiroComBrancosEsquerda(
  Valor: LongInt; Tamanho: Integer ): String;
begin
  Result := Format( '%*d', [ Tamanho, Valor ] );
end;

function FormatarStringComNumeroPadronizadoDeCaracteres(
  Palavra: String;
  Tamanho: Integer ): String;
begin
  Palavra := Palavra + StringOfChar( ' ', Tamanho - Length( Palavra ) );
  Result := LeftStr( Palavra, Tamanho );
end;

function FormatarCep(
  Cep: LongInt ): String;
var
  CepString: String;
begin
  {Formatar Cep No Padrão "99.999-999" Considerando Sempre Que o Número Inteiro De
   Entrada Terá De Ter Oito Digítos. E, Se For Necessário, Insere Zeros a Esquerda
   Para Assegurar Isto:}
  CepString := IntToSTr( Cep );
  CepString := StringOfChar( '0', 08 - Length( CepString ) ) + CepString;
  Result := LeftStr( CepString, 2 ) + '.' + Copy( CepString, 3, 3 ) + '-' + RightStr( CepString, 3 );
end;

procedure CriarAtalhoParaAplicativoNoWindows(
  FileName, Parameters, InitialDir, ShortCutName, ShortCutFolder: PChar;
  Place: TShortCutPlace );
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
  Directory: String;
  WFileName: WideString;
  MyReg: TRegIniFile;
begin
  {Esta Função Exige: "uses ShlObj, ActiveX, ComObj, Registry;"}
  MyObject := CreateComObject( CLSID_ShellLink );
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;

  with MySLink do
  begin
    SetArguments( Parameters );
    SetPath( PChar( FileName ) );
    SetWorkingDirectory( PChar( InitialDir ) );
  end;

  MyReg := TRegIniFile.Create( 'Software\MicroSoft\Windows\CurrentVersion\Explorer' );

  if ( Place = stDesktop ) then
    Directory := MyReg.ReadString( 'Shell Folders', 'Desktop', '' );

  if ( Place = stStartMenu ) then
  begin
    Directory := MyReg.ReadString( 'Shell Folders', 'Start Menu', '' ) + '\' + ShortCutFolder;
    CreateDir( Directory );
  end;

  if ( Place = stAutoStartUp ) then
  begin
    Directory := MyReg.ReadString( 'Shell Folders', 'Startup', '' ) + '\' + ShortCutFolder;
    CreateDir( Directory );
  end;

  WFileName := Directory + '\' + ShortCutName + '.lnk';
  MyPFile.Save( PWChar( WFileName ), False );
  MyReg.Free;
end;

procedure CriarAtalhoParaLinkInternetNosFavoritosDoWindows(
  FileName, Parameters, InitialDir, NomeDoAtalho, PastaOndeGravar: String );
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
  WFileName: WideString;
begin
  MyObject := CreateComObject( CLSID_ShellLink );
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  with MySLink do
  begin
    SetArguments( PAnsiChar( Parameters ) );
    SetPath( PChar( FileName ) );
    SetWorkingDirectory( PChar( InitialDir ) );
  end;
  WFileName := PastaOndeGravar + '\' + NomeDoAtalho + '.lnk';
  MyPFile.Save( PWChar( WFileName ), False );
end;

function EnviarEMailUsandoDLLDoWindows(
  const De, Para, Assunto, Texto, Arquivo: String;
  Confirmar: Boolean ): Integer;
var
  Msg: TMapiMessage;
  lpSender, lpRecepient: TMapiRecipDesc;
  FileAttach: TMapiFileDesc;
  SM: TFNMapiSendMail;
  MAPIModule: HModule;
  Flags: Cardinal;
begin
  {Cria Propriedades da Mensagem:}
  FillChar(Msg, SizeOf(Msg), 0);
  with Msg do
  begin
    if ( Assunto <> '' ) then
      lpszSubject := PChar(Assunto);

    if ( Texto <> '' ) then
      lpszNoteText := PChar(Texto);

  {Remetente:}
  if ( De <> '' ) then
  begin
    lpSender.ulRecipClass := MAPI_ORIG;
    lpSender.lpszName := PChar( De );
    lpSender.lpszAddress := PChar( De );
    lpSender.ulReserved := 0;
    lpSender.ulEIDSize := 0;
    lpSender.lpEntryID := nil;
    lpOriginator := @lpSender;
  end;

  {Destinatário:}
  if ( Para <> '' ) then
  begin
    lpRecepient.ulRecipClass := MAPI_TO;
    lpRecepient.lpszName := PChar(Para);
    lpRecepient.lpszAddress := PChar(Para);
    lpRecepient.ulReserved := 0;
    lpRecepient.ulEIDSize := 0;
    lpRecepient.lpEntryID := nil;
    nRecipCount := 1;
    lpRecips := @lpRecepient;
  end
  else
  lpRecips := nil;

  {Arquivo Anexo:}
  if ( Arquivo = '' ) then
  begin
    nFileCount := 0;
    lpFiles := nil;
  end
  else
  begin
    FillChar( FileAttach, SizeOf( FileAttach ), 0 );
    FileAttach.nPosition := Cardinal( $FFFFFFFF );
    FileAttach.lpszPathName := PChar( Arquivo );
    nFileCount := 1;
    lpFiles := @FileAttach;
  end;
end;

  {Carrega DLL e Método Para Envio do Email:}
  MAPIModule := LoadLibrary( PChar( MAPIDLL ) );
  if ( MAPIModule = 0 ) then
    Result := -1
  else
    try
      if Confirmar then
        Flags := MAPI_DIALOG or MAPI_LOGON_UI
      else
        Flags := 0;
      @SM := GetProcAddress( MAPIModule, 'MAPISendMail' );
      if ( @SM <> nil ) then
        Result := SM( 0, Application.Handle, Msg, Flags, 0 )
      else
        Result := 1;
    finally
      FreeLibrary( MAPIModule );
    end;
end;

procedure PegarDadosDoRegistro(
  var Pop3_UserName, Smtp, NomeRemetente, Email: String );
var
  Registro: TRegistry;
  NomeChave: String;
begin
  try
    Registro := TRegistry.Create;
    Registro.RootKey := HKEY_CURRENT_USER;
    NomeChave := 'Software\Microsoft\Internet Account Manager';
    Registro.OpenKey( NomeChave, False );
    NomeChave := NomeChave + '\Accounts\' + Registro.ReadString( 'Default Mail Account' );
    Registro.CloseKey;
    Registro.Free;

    Registro := TRegistry.Create;
    Registro.RootKey := HKEY_CURRENT_USER;
    Registro.OpenKey( NomeChave, False );
    Pop3_UserName := Registro.ReadString ( 'POP3 User Name' );
    Smtp          := Registro.ReadString ( 'SMTP Server' );
    NomeRemetente := Registro.ReadString ( 'SMTP Display Name' );
    Email         := Registro.ReadString ( 'SMTP Email Address' );
    Registro.CloseKey;
    Registro.Free;
  except
    {Nada}
  end;
end;

function ExtrairNomeLongoDoArquivoPassadoComoParametro: String;
var
  Posicao: Integer;
begin
  Result := '';

  {Verifica Os Casos Em Que Houve a Passagem De Um Parâmetro, Porém Não é o Caso Em
   Que Apenas Se Informa Que o Programa Está Sendo Instalado:}
  if ( ParamCount > 0 ) then
  begin
    {Pega a Linha De Chamada a Este Aplicativo:}
    Result := Trim( CmdLine );

    {Retira Primeira Parte Da Linha De Comando Que Contém o Nome Do Próprio
     Arquivo Que Contém o Executável Que Foi Acionado:}
    Posicao := Pos( '" ', Result );
    Result := Copy( Result, Posicao + 2, Length( Result ) - Posicao - 1 );
    Result := Trim( Result );

    {Verifica Se o Parametro Está Precedido ou Encerrado Por Aspas, Neste Caso As Retira:}
    while Copy( Result, 1, 1 ) = '"' do
      Result := Copy( Result, 2, Length( Result ) - 1 );
    while Copy( Result, Length( Result ), 1 ) = '"' do
      Result := Copy( Result, 1, Length( Result ) - 1 );
  end;
end;

function ExtrairDiretorioWindows: String;
var
  Buffer: Array[0..144] of Char;
begin
  GetWindowsDirectory( Buffer, 144 );
  Result := StrPas( Buffer );
end;

function ExtrairDiretorioSystem: String;
var
  Buffer: Array[0..144] of Char;
begin
  GetSystemDirectory( Buffer, 144 );
  Result := StrPas( Buffer );
end;

function ExtrairDiretorioArquivosDeProgramas: String;
var
  Registro: TRegistry;
begin
  Result := '';
  Registro := TRegistry.Create;
  try
    Registro.RootKey := HKEY_LOCAL_MACHINE;
    if Registro.OpenKey('\Software\Microsoft\Windows\CurrentVersion\', False ) then
      Result := Registro.ReadString( 'ProgramFilesDir' );
  finally
    Registro.CloseKey;
    Registro.Free;
  end;
end;

function ExtrairDiretorioMeusDocumentos: String;
var
  RecPath: PAnsiChar;
begin
  Result := '';
  RecPath := StrAlloc( MAX_PATH );
  try
    FillChar( RecPath^, MAX_PATH, 0 );
    if SHGetSpecialFolderPath( 0, RecPath, CSIDL_PERSONAL, False ) then
     Result := RecPath;
  finally
    StrDispose( RecPath );
  end;
end;

function ExtrairDiretorioDesktop: String;
var
  RecPath: PAnsiChar;
begin
  Result := '';
  RecPath := StrAlloc( MAX_PATH );
  try
    FillChar( RecPath^, MAX_PATH, 0 );
    if SHGetSpecialFolderPath( 0, RecPath, CSIDL_DESKTOP, False ) then
     Result := RecPath;
  finally
    StrDispose( RecPath );
  end;
end;

function ExtrairDiretorioMenuInicialProgramas: String;
var
  RecPath: PAnsiChar;
begin
  Result := '';
  RecPath := StrAlloc( MAX_PATH );
  try
    FillChar( RecPath^, MAX_PATH, 0 );
    if SHGetSpecialFolderPath( 0, RecPath, CSIDL_STARTMENU, False ) then
     Result := RecPath;
  finally
    StrDispose( RecPath );
  end;
end;

function EnviarArquivoParaLixeira(
  NomeDoArquivo: String ): Boolean;
var
  Fos: TSHFileOpStruct;
Begin
  FillChar( Fos, SizeOf( Fos ), 0 );
  With Fos do
  begin
    wFunc := FO_DELETE;
    pFrom := PChar( NomeDoArquivo );
    fFlags := FOF_ALLOWUNDO or FOF_SILENT;
  end;
  Result := ( ShFileOperation( Fos ) = 0 );
  if Result then
    Result := not FileExists( NomeDoArquivo );
end;

procedure InstalarEsteAplicativoAtualExecutavel(
  SubPastaDeInstalacaoSobArquivosDeProgramas, NomeCompletoDestePrograma: String );
var
  Origem, Destino,
  DiretorioWindows, DiretorioArquivosDeProgramas, DiretorioMeusDocumentos, NomeDoLink: String;
begin
  DiretorioWindows := ExtrairDiretorioWindows + '\';
  DiretorioArquivosDeProgramas := ExtrairDiretorioArquivosDeProgramas + '\';
  DiretorioMeusDocumentos := ExtrairDiretorioMeusDocumentos + '\';

  Origem := Trim( ExtractFilePath( Application.ExeName ) );
  Origem := LeftStr( Origem, Length( Origem ) - 1 );

  NomeDoLink := Trim( ExtractFileName( Application.ExeName ) );
  NomeDoLink := LeftStr( NomeDoLink, Length( NomeDoLink ) - 4 );

  SubPastaDeInstalacaoSobArquivosDeProgramas :=
    Trim( DiretorioArquivosDeProgramas + SubPastaDeInstalacaoSobArquivosDeProgramas );

  Destino :=
    AnsiLowerCaseFileName( SubPastaDeInstalacaoSobArquivosDeProgramas + '\' + ExtractFileName( Application.ExeName ) );

  {Faz Cópia Dos Arquivos Deste Programa No Diretório "C:\Arquivos de Programas\..........\":}
  CopiarPasta( frmPrincipal.Handle, Origem, SubPastaDeInstalacaoSobArquivosDeProgramas );
end;

function CopiarOuMoverArquivoUsandoShellDoWindows(
  ArquivoOrigem, ArquivoDestino: String;
  ManterOriginal: Boolean ): Boolean;
var
  Operacao: TSHFileOpStruct;
begin
  FillChar( Operacao, SizeOf( Operacao ), 0 );

  if ManterOriginal then
    Operacao.wFunc := FO_COPY
  else
    Operacao.wFunc := FO_MOVE;

  Operacao.pFrom := PChar( ArquivoOrigem );
  Operacao.pTo := PChar( ArquivoDestino );
  Operacao.fFlags:= FOF_ALLOWUNDO;
  Result := ( SHFileOperation( Operacao ) = 0 );
end;

function CopiarArquivo(
  Source, Dest: String ): Boolean;
var
  fSrc, fDst, Len: Integer;
  Size: Longint;
  Buffer: Packed Array [ 0..2047 ] of Byte;
begin
  Result := False;
  if ( Source <> Dest ) then
  begin
    fSrc := FileOpen( Source, fmOpenRead + fmShareDenyWrite	);
    if ( fSrc >= 0 ) then
    begin
      Size := FileSeek( fSrc, 0, 2 );
      FileSeek( fSrc, 0, 0 );
      fDst := FileCreate( Dest );
      if ( fDst >= 0 ) then
      begin
        while ( Size > 0 ) do
        begin
          Len := FileRead( fSrc, Buffer, Sizeof( Buffer ) );
          FileWrite( fDst, Buffer, Len );
          Size := Size - Len;
        end;
        FileSetDate( fDst, FileGetDate( fSrc ) );
        FileClose( fDst );
        FileSetAttr( Dest, FileGetAttr( Source ) );
        Result := True;
      end;
      FileClose( fSrc );
    end;
  end;
end;

procedure CopiarArquivoViaFileStream(
  const SourceFileName, TargetFileName: String );
var
  Source, Target: TFileStream;
begin
  Source := TFileStream.Create( SourceFileName, fmOpenRead );
  try
    Target := TFileStream.Create( TargetFileName, fmOpenWrite or fmCreate );
    try
      Target.CopyFrom( Source, Source.Size ) ;
    finally
      Target.Free;
    end;
  finally
    Source.Free;
  end;
end;

procedure CopiarPasta(
  Handle: THandle; fromDir, toDir: String );
var
  SHFileOp: TSHFileOpStruct;
begin
  SHFileOp.wnd   := Handle;
  SHFileOp.wFunc := FO_COPY;
  SHFileOp.pFrom := PChar( fromDir +#0 +#0 );
  SHFileOp.pTo := PChar( toDir    +#0 +#0 );
  SHFileOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
  SHFileOp.fAnyOperationsAborted := False;
  SHFileOp.hNameMappings := Nil;
  SHFileOp.lpszProgressTitle := Nil;
  SHFileOperation( SHFileOp );
end;

procedure MoverPasta(
  Handle: THandle; fromDir, toDir: String );
var
  SHFileOp: TSHFileOpStruct;
begin
  SHFileOp.wnd   := Handle;
  SHFileOp.wFunc := FO_MOVE;
  SHFileOp.pFrom := PChar( fromDir +#0 +#0 );
  SHFileOp.pTo := PChar( toDir    +#0 +#0 );
  SHFileOp.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
  SHFileOp.fAnyOperationsAborted := False;
  SHFileOp.hNameMappings := Nil;
  SHFileOp.lpszProgressTitle := Nil;
  SHFileOperation( SHFileOp );
end;

function ApagarArquivo(
  Filename: String;
  ToRecycle: Boolean ): Boolean;
var
  tempFileOp: TSHFileOpStruct;
begin
  if FileExists( Filename ) then
  begin
    with tempFileOp do
    begin
      Wnd := 0;
      wFunc := FO_DELETE;
      pFrom := Pchar( Filename + #0 + #0 );
      pTo := #0 + #0;
      if ToRecycle then
        fFlags := FOF_FILESONLY or
                  FOF_ALLOWUNDO or
                  FOF_NOCONFIRMATION or
                  FOF_SILENT
      else
        fFlags := FOF_FILESONLY or
                  FOF_NOCONFIRMATION or
                  FOF_SILENT;
      SHFileOperation( tempFileOp );
    end;
  end;
  Result := not FileExists( Filename );
end;

function ApagarPasta(
  DirName: String;
  ToRecycle: Boolean ): Boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
  DirBuf: Array [0..255] of Char;
begin
  try
    Fillchar( SHFileOpStruct, Sizeof( SHFileOpStruct ), 0 );
    FillChar( DirBuf, SizeOf( DirBuf ), 0 );
    StrPCopy( DirBuf, DirName );
    with SHFileOpStruct do
    begin
      Wnd := 0;
      pFrom := @DirBuf;
      wFunc := FO_DELETE;
      if ToRecycle then
        fFlags := FOF_ALLOWUNDO;
      fFlags := fFlags or FOF_NOCONFIRMATION;
      fFlags := fFlags or FOF_SILENT;
    end;
    Result := ( SHFileOperation( SHFileOpStruct ) = 0 );
  except
    Result := False;
  end;
end;

function CompararDoisArquivos_VerSeSaoIdenticos(
  const NomeArquivo1, NomeArquivo2: TFileName): Boolean;
var
  StreamMemoria1, StreamMemoria2: TMemoryStream;
begin
  Result := False;
  StreamMemoria1 := TMemoryStream.Create;
  try
    StreamMemoria1.LoadFromFile( NomeArquivo1 );
    StreamMemoria2 := TMemoryStream.Create;
    try
      StreamMemoria2.LoadFromFile( NomeArquivo2 );
      if StreamMemoria1.Size = StreamMemoria2.Size then
        Result := CompareMem( StreamMemoria1.Memory, StreamMemoria2.memory, StreamMemoria1.Size );
    finally
        StreamMemoria2.Free;
    end;
  finally
      StreamMemoria1.Free;
  end;
end;

function EstaConectadoNaInternet: Boolean;
var
  Origem: Cardinal;
begin
  Result := WinInet.InternetGetConnectedState( @Origem, 0 );
end;

function EstaConectadoNaInternetAlternativa: Boolean;
var
  InetIsOffline: function( dwFlags: DWORD ): BOOL; stdcall;

  {Retorna TRUE Se o Parâmetro "_funcname" Existe Na DLL Com Nome Passado Por "_dllname":}
  function FuncAvail(
    _dllname, _funcname: String;
    var _p: pointer ): Boolean;
  var
    _lib: tHandle;
  begin
    Result := False;

    if ( LoadLibrary( PChar( _dllname ) ) = 0 ) then
      Exit;

    _lib := GetModuleHandle( PChar( _dllname ) );

    if ( _lib <> 0 ) then
    begin
      _p := GetProcAddress( _lib, PChar( _funcname ) );
      if ( _p <> NIL ) then
        Result := true;
    end;
  end;

begin
  Result := False;
  if FuncAvail(
       'URL.DLL',
       'InetIsOffline',
       @InetIsOffline ) then
    if ( InetIsOffLine( 0 ) ) then
      Result := False
    else
      Result := True;
end;

function UrlExiste(
  const Url: String ): Boolean;
var
  hInet: HINTERNET;
  hConnect: HINTERNET;
  InfoBuffer: Packed Array [ 0..7 ] of Char;
  Dummy: DWORD;
  BufLen: DWORD;
  Deu: LongBool;
  Resposta: String;
begin
  hInet := InternetOpen( PChar( Application.title ), INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY, nil, nil, 0 );
  hConnect := InternetOpenUrl( hInet, PChar( url ), nil, 0, INTERNET_FLAG_NO_UI, 0 );
  if not Assigned( hConnect ) then
    Result := False
  else
  begin
    Dummy := 0;
    BufLen := Length( InfoBuffer );
    Deu := HttpQueryInfo( hConnect, HTTP_QUERY_STATUS_CODE, @InfoBuffer[ 0 ], BufLen, Dummy );
    if not Deu then
      Result := False
    else
    begin
      Resposta := InfoBuffer;
      Result := ( Resposta = '200' );
    end;
    InternetCloseHandle( hConnect );
  end;
  InternetCloseHandle( hInet );
end;

procedure AcionarBotaoIniciarDoWindows;
begin
  SendMessage(
    Application.Handle,
    WM_SYSCOMMAND,
    SC_TASKLIST,
    0);
end;

function EstaStringContemUmNumeroInteiro(
  var Texto: String ): Boolean;
var
  Cont: Integer;
begin
  Result := True;
  Texto := Trim( Texto );
  Cont := 1;
  while ( Result ) and
        ( Cont <= Length( Texto ) ) do
  begin
    Result := ( Texto[Cont] in ['0'..'9'] );
    Cont := Cont + 1;
  end;
end;

function DeixarSoCaracteresIniciais(
  Entrada: String ): String;
var
  Posicao: Integer;
begin
  Result := '';

  {Primeiro Remover Todos Os Eventuais Espaços Em Branco Repetidos:}
  while ( Pos( StringOfChar( ' ', 02 ), Entrada ) > 0 ) do
    Entrada :=
      StringReplace(
        Entrada,
        StringOfChar( ' ', 02 ),
        StringOfChar( ' ', 01 ),
        [rfReplaceAll] );

  Entrada := ' ' + Trim( Entrada );
  Posicao := 1;
  while ( Entrada <> '' ) and
        ( Posicao > 0 ) do
  begin
    Entrada := RightStr( Entrada, Length( Entrada ) - Posicao );

    if Length( Entrada ) > 0 then
      Result := Result + Entrada[1];

    Posicao := Pos( ' ', Entrada );
  end;
end;

function UpperCase_SoCaracteresIniciais(
  Entrada: String ): String;
var
  Cont: Integer;
  ProximoUpper: Boolean;
  Caracter: String;
begin
  Result := '';
  ProximoUpper := True;
  for Cont := 1 to Length( Entrada ) do
  begin
    Caracter := AnsiLowerCase( Entrada[Cont] );
    if ( ProximoUpper ) then
      if ( ( Caracter[1] in ['a'..'z'] ) or
           ( Pos( Caracter[1], 'áàãâäéèêëíìîïóòõôöúùûüç' ) > 0 ) ) then
        Caracter := AnsiUpperCase( Caracter );
    Result := Result + Caracter;
    ProximoUpper := ( Pos( Entrada[Cont], ' @#$%&*-_=+[<({/\' ) > 0 );
  end;
end;

procedure RemoverDiacriticos(
  var Entrada: String );
var
  Cont: Integer;
begin
  Entrada := AnsiUpperCase( Entrada );

  {Elimina Repetições De Espaços Em Branco Prevenindo Seqüências Com Até 05 Espaços Seguidos:}
  for Cont := 5 downto 2 do
    Entrada := StringReplace( Entrada, StringOfChar( ' ', Cont ), ' ', [rfReplaceAll] );

  {Elimina Caracteres Diacríticos Da Língua Portuguesa:}
  for Cont := 1 to Length( Entrada ) do
    case Entrada[Cont] of

      'Á', 'À', 'Â', 'Ã', 'Ä', 'Å', Chr( 166 ), Chr( 170 ) {'ª'}:
        Entrada[Cont] := 'A';

      'É', 'È', 'Ê', 'Ë':
        Entrada[Cont] := 'E';

      'Í', 'Ì', 'Î', 'Ï':
        Entrada[Cont] := 'I';

      'Ó', 'Ò', 'Ô', 'Õ', 'Ö', Chr( 167 ), Chr( 186 ) {'º'}:
        Entrada[Cont] := 'O';

      'Ú', 'Ù', 'Û', 'Ü':
        Entrada[Cont] := 'U';

      'Ç':
        Entrada[Cont] := 'C';

      'Ð':
        Entrada[Cont] := 'D';

      'Ñ':
        Entrada[Cont] := 'N';

      'Š':
        Entrada[Cont] := 'S';

      'Ø':
        Entrada[Cont] := 'O';

      'Ž':
        Entrada[Cont] := 'Z';

    end;
end;

procedure RemoverDiacriticosDeWideStringPreservandoCaixa(
  var Entrada: WideString );
var
  Cont: Integer;
begin
  {Elimina Repetições De Espaços Em Branco Prevenindo Seqüências Com Até 05 Espaços Seguidos:}
  for Cont := 5 downto 2 do
    Entrada := StringReplace( Entrada, StringOfChar( ' ', Cont ), ' ', [rfReplaceAll] );

  {Elimina Caracteres Diacríticos Da Língua Portuguesa:}
  for Cont := 1 to Length( Entrada ) do
    case Entrada[Cont] of

      'Á', 'À', 'Â', 'Ã', 'Ä', 'Å', Chr( 166 ), Chr( 170 ) {'ª'}:
        Entrada[Cont] := 'A';

      'á', 'à', 'â', 'ã', 'ä':
        Entrada[Cont] := 'a';

      'É', 'È', 'Ê', 'Ë':
        Entrada[Cont] := 'E';

      'é', 'è', 'ê', 'ë':
        Entrada[Cont] := 'e';

      'Í', 'Ì', 'Î', 'Ï':
        Entrada[Cont] := 'I';

      'í', 'ì', 'î', 'ï':
        Entrada[Cont] := 'i';

      'Ó', 'Ò', 'Ô', 'Õ', 'Ö', Chr( 167 ), Chr( 186 ) {'º'}:
        Entrada[Cont] := 'O';

      'ó', 'ò', 'ô', 'õ', 'ö':
        Entrada[Cont] := 'o';

      'Ú', 'Ù', 'Û', 'Ü':
        Entrada[Cont] := 'U';

      'ú', 'ù', 'û', 'ü':
        Entrada[Cont] := 'u';

      'Ç':
        Entrada[Cont] := 'C';

      'ç':
        Entrada[Cont] := 'c';

      'Ð':
        Entrada[Cont] := 'D';

      'Ñ':
        Entrada[Cont] := 'N';

      'ñ':
        Entrada[Cont] := 'n';

      'Š':
        Entrada[Cont] := 'S';

      'Ø':
        Entrada[Cont] := 'O';

      'Ž':
        Entrada[Cont] := 'Z';

    end;
end;

procedure RemoverNaoNumericos(
  var Entrada: String );
var
  Cont: Integer;
begin
  Entrada := Trim( Entrada );

  Cont := 1;
  while ( Cont <= Length( Entrada ) ) do
  begin
    if ( Pos ( Entrada[Cont], '0123456789' + RetornoDeCarro( 01 ) ) = 0 ) then
      Entrada := StuffString( Entrada, Cont, 1, '' )
    else
      Cont := Cont + 1;
  end;
end;

procedure RemoverCRLFDeWideStringColocandoPontoVirgulaNoLugar(
  var Entrada: WideString );
begin
  Entrada := StringReplace( Entrada, RetornoDeCarro( 1 ), '; ', [rfReplaceAll] );
end;

procedure RemoverDiacriticosFormatoEspecialBiCaracter(
  var Memo: TMemo );
begin
  Memo.Text := StringReplace( Memo.Text, 'Ã£', 'A', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ã¡', 'A', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ã¢', 'A', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ã©', 'E', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ãª', 'E', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ã‰', 'E', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ã­', 'I', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ã', 'I', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Õ£', 'O', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ã´', 'O', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Õ¢', 'O', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ã³', 'O', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ãº', 'U', [rfReplaceAll] );
  Memo.Text := StringReplace( Memo.Text, 'Ã§', 'C', [rfReplaceAll] );
end;

procedure RemoverLetrasRepetidas(
  var Entrada: String );
var
  Cont: Integer;
begin
  {Eliminar Caracteres Repetidos Em Até 03 Vezes:}
  for Cont := Ord( 'A' ) to Ord( 'Z' ) do
  begin
    Entrada := StringReplace( Entrada, StringOfChar( Chr( Cont ), 3 ), Chr( Cont ), [ rfReplaceAll ] );
    Entrada := StringReplace( Entrada, StringOfChar( Chr( Cont ), 2 ), Chr( Cont ), [ rfReplaceAll ] );
  end;
end;

procedure RemoverNaoUsuaisParaTextoSMS(
  var Entrada: WideString );
var
  Cont: Integer;
begin
  Entrada := Trim( Entrada );

  {Eliminar Caracteres Não Permitidos:}
  Cont := 1;
  while ( Cont < Length( Entrada ) ) do
  begin
    if ( Pos ( Entrada[Cont], ' ABCDEFGHIJKLMNOPQRSTUVXYWZabcdefghijklmnopqrstuvxywz0123456789!?<>():,.;+-/=@%&' ) = 0 ) then
      Entrada := StuffString( Entrada, Cont, 1, '' )
    else
      Cont := Cont + 1;
  end;

  {Eliminar Retornos De Carro, Substituindo-os Por Espaços Em Branco:}
  Entrada := StringReplace( Entrada, RetornoDeCarro( 01 ), ' ', [ rfReplaceAll ] );

  {Eliminar Sinais de Ponto e Vírgula, Substituindo-os Por Vírgulas Comuns:}
  Entrada := StringReplace( Entrada, ';', ' ', [ rfReplaceAll ] );
end;

procedure SetarBordaCtrl3DWebNavegador(
  webNavegador: TWebBrowser;
  DeixarNaFormaCtrl3D: Boolean );
var
  Doc: IHTMLDocument2;
  Element: IHTMLElement;
begin
  Doc := IHTMLDocument2( webNavegador.Document );
  if ( Doc <> Nil ) then
  begin
    Element := Doc.body;
    if ( Element <> Nil ) then
      if DeixarNaFormaCtrl3D then
        Element.Style.BorderStyle := ''
      else
        Element.Style.BorderStyle := 'none';
  end;
end;

procedure CapturarImagemBitmapDaTelaInteira(
  var Bitmap: TBitmap );
var
  Win: HWND;
  DC: HDC;
  WinRect: TRect;
  Width: Integer;
  Height: Integer;
begin
  Win := GetForegroundWindow;
  GetWindowRect( Win, WinRect );
  DC := GetWindowDC( Win );
  try
    Width := WinRect.Right - WinRect.Left;
    Height := WinRect.Bottom - WinRect.Top;

    Bitmap.Height := Height;
    Bitmap.Width := Width;
    BitBlt( Bitmap.Canvas.Handle, 0, 0, Width, Height, DC, 0, 0, SRCCOPY );
  finally
    ReleaseDC( Win, DC );
  end;
end;

procedure CapturarImagemBitmapDaTelaSubArea(
  var Bitmap: TBitmap;
  const AreaCapturar: TRect );
var
  Win: HWND;
  DC: HDC;
  WinRect: TRect;
  Width: Integer;
  Height: Integer;
  BitmapTelaInteira: TBitmap;
begin
  {Criar Objetos Auxiliares:}
  BitmapTelaInteira := TBitmap.Create;

  {Primeiro, Capturar a Tela Inteira:}
  Win := GetForegroundWindow;
  GetWindowRect( Win, WinRect );
  DC := GetWindowDC( Win );
  try
    Width := WinRect.Right - WinRect.Left;
    Height := WinRect.Bottom - WinRect.Top;

    BitmapTelaInteira.Height := Height;
    BitmapTelaInteira.Width := Width;
    BitBlt( BitmapTelaInteira.Canvas.Handle, 0, 0, Width, Height, DC, 0, 0, SRCCOPY );
  finally
    ReleaseDC( Win, DC );
  end;

  {Depois, Separar Apenas a Área Desejada:}
  Bitmap.Width := AreaCapturar.Right - AreaCapturar.Left;
  Bitmap.Height := AreaCapturar.Bottom - AreaCapturar.Top;

  Bitmap.Canvas.CopyRect( Bitmap.Canvas.ClipRect, BitmapTelaInteira.Canvas, AreaCapturar );

  {Descartar Objetos Auxiliares:}
  BitmapTelaInteira.Free;
end;

procedure CapturarImagemBitmapDeNavegadorWeb(
  Navegador: TWebBrowser;
  FormHandle: HWnd;
  var Bitmap: TBitmap );
var
  sourceDrawRect: TRect;
  targetDrawRect: TRect;
  sourceBitmap: TBitmap;
  targetBitmap: TBitmap;
  viewObject: IViewObject;
  IDoc1: IHTMLDocument2;
  Wb: IWebBrowser2;
  srcWidth, srcHeight, tarWidth, tarHeight, tmpX, tmpY: Integer;
  pElement: IHTMLElement2;
begin
  Navegador.Document.QueryInterface( IHTMLDocument2, iDoc1 );
  pElement := iDoc1.body as IHTMLElement2;

  Wb := Navegador.ControlInterface;
  tmpX := Navegador.Height;
  tmpY := Navegador.Width;

  srcWidth := Navegador.Width;
  srcHeight := Navegador.Height;
  tarWidth := Navegador.Width;
  tarHeight := Navegador.Height;

  sourceBitmap := TBitmap.Create;
  targetBitmap := TBitmap.Create;
  try
    try
      sourceDrawRect := Rect( 0, 0, srcWidth, srcHeight );
      sourceBitmap.Width  := srcWidth;
      sourceBitmap.Height := srcHeight;

      viewObject := Wb as IViewObject;

      if viewObject = nil then
        Exit;

      OleCheck( viewObject.Draw(
        DVASPECT_CONTENT, 1, nil, nil, FormHandle,
        sourceBitmap.Canvas.Handle, @sourceDrawRect, nil, nil, 0 ) );

      targetDrawRect := Rect( 0, 0, tarWidth, tarHeight );
      targetBitmap.Height := tarHeight;
      targetBitmap.Width  := tarWidth;
      targetBitmap.Canvas.StretchDraw( targetDrawRect, sourceBitmap );

      Bitmap.Assign( targetBitmap );
    finally
      sourceBitmap.Free;
      targetBitmap.Free;
    end;
  except
    {Nada}
  end;

  Navegador.Height := tmpX;
  Navegador.Width := tmpY;
end;

procedure CapturarPainelContendoNavegadorWebEmImagemJPEG(
  Painel: TPanel;
  NavegadorWeb: TWebBrowser;
  var ImagemCapturadaJPEG: TJPegImage );
var
  ImagemCapturadaBitmapDoPanel: TBitmap;
  ImagemCapturadaBitmapDoWebBrowser: TBitmap;
begin
  ImagemCapturadaBitmapDoPanel := TBitmap.Create;
  try
    ImagemCapturadaBitmapDoPanel.Width := Painel.ClientWidth;
    ImagemCapturadaBitmapDoPanel.Height := Painel.ClientHeight;
    ImagemCapturadaBitmapDoPanel.Canvas.Brush := Painel.Brush;
    ImagemCapturadaBitmapDoPanel.Canvas.FillRect( Painel.ClientRect );
    ImagemCapturadaBitmapDoPanel.Canvas.Lock;
    Painel.PaintTo( ImagemCapturadaBitmapDoPanel.Canvas.Handle, 0, 0 );
    ImagemCapturadaBitmapDoPanel.Canvas.Unlock;

    if ( NavegadorWeb <> Nil ) then
    begin
      {O Processo de Captura Acima Funciona Muito Bem Para Capturar Imagens
       Contidas Em TPanels. Contudo, Neste Caso, Como a Captura Contém Um
       Mapa Google Inserido Dentro de Um Web Browser Que, Por Sua Vez, Está
       Contido No TPanel Que Está Sendo Capturado, o Conteúdo da Imagem Do
       Web Browser Não Seria Capturada Junto e é Necessário Tomar Algumas
       Providências Adicionais de Captura. Será Necessário Capturar a Imagem
       Do Web Browser Por Meio de Processo a Parte e Depois Carimbar Esta
       Parte da Imagem Na Posição Correta da Imagem Completa do TPanel:}
      ImagemCapturadaBitmapDoWebBrowser := TBitmap.Create;

      CapturarImagemBitmapDeNavegadorWeb(
        NavegadorWeb,
        NavegadorWeb.Handle,
        ImagemCapturadaBitmapDoWebBrowser );
      ImagemCapturadaBitmapDoPanel.Canvas.Draw(
        NavegadorWeb.ClientOrigin.X,
        NavegadorWeb.ClientOrigin.Y,
        ImagemCapturadaBitmapDoWebBrowser );

      ImagemCapturadaBitmapDoWebBrowser.Free;
    end;

    ImagemCapturadaJPEG.Assign( ImagemCapturadaBitmapDoPanel );
  finally
    ImagemCapturadaBitmapDoPanel.Free;
  end;
end;

function RetornoDeCarro(
  QtdRetornosDeCarro: Integer ): String;
begin
  Result := DupeString( Chr( 013 ) + Chr( 010 ), QtdRetornosDeCarro );
end;

procedure Formatar_CpfOuCgc(
  Numero: String;
  var NumeroFormatado: String;
  var Tipo: Integer;
  var Valido: Boolean );
begin
  if ( Length( Numero ) <= 11 ) then
  begin
    NumeroFormatado := Formatar_Cpf( Numero );
    Tipo            := 0;
    Valido          := Checar_Cpf( Numero );
  end
  else
  begin
    NumeroFormatado := Formatar_Cgc( Numero );
    Tipo            := 1;
    Valido          := Checar_Cgc( Numero );
  end;
end;

function Formatar_Cpf(
  Numero: String ): String;
begin
  while Length( Numero ) < 11 do
    Numero := '0' + Numero;
  Numero := Copy( Numero, Length( Numero ) - 10, 11 );
  Result := Copy( Numero, 01, 03) + '.' + Copy( Numero, 04, 03) + '.' + Copy( Numero, 07, 03) + '-' + Copy( Numero, 10, 2 );
end;

function Formatar_Cgc(
  Numero: String ): String;
begin
  while Length( Numero ) < 14 do
    Numero := '0' + Numero;
  Numero := Copy( Numero, Length( Numero ) - 13, 14 );
  Result := Copy( Numero, 01, 02) + '.' + Copy( Numero, 03, 03) + '.' + Copy( Numero, 06, 03) + '/' + Copy( Numero, 09, 04 ) + '-' + Copy( Numero, 13, 2 );
end;

function Checar_Cpf(
  Numero: String ): Boolean;
var
  a1, a2, a3, a4, w1, tw1, tw2: String;
  ww1, www, www1, www2, cc, wcc, acu1, wconttt: LongInt;
begin
  w1 := Numero;
  while Length( w1 ) < 11 do
    w1 := '0' + w1;
  Numero  := Formatar_Cpf( Numero );
  a1      := Copy( Numero, 01, 03);
  a2      := Copy( Numero, 05, 03);
  a3      := Copy( Numero, 09, 03);
  a4      := Copy( Numero, 13, 02);
  wcc     := 10;
  acu1    := 0;
  www1    := 0;
  www2    := 0;
  for wconttt := 1 to 2 do
  begin
    for cc := 1 to 9 do
    begin
      ww1  := StrToInt( Copy( w1, cc, 1 ) );
      acu1 := acu1 + ( ww1 * wcc );
      wcc  := wcc - 1;
    end;
    if wconttt = 2 then
      acu1 := acu1 + ( www1 * 2 );
    www := acu1 mod 11;
    if wconttt = 1 then
    begin
      if ( www = 0 ) or ( www = 1 ) then
        www1 := 0
      else
        www1 := 11 - www;
    end
    else
    begin
      if ( www = 0 ) or ( www = 1 ) then
        www2 := 0
      else
        www2 := 11 - www;
    end;
    acu1    := 0;
    wcc     := 11;
  end;
  tw1 := IntToStr( www1 );
  tw2 := IntToStr( www2 );
  Result := ( ( tw1 = Copy( w1, 10, 1 ) ) and ( tw2 = Copy( w1, 11, 1 ) ) );
end;

function Checar_Cgc(
  Numero: String ): Boolean;
var
  d1, d4, xx, nCount, Fator, Resto, Digito1, Digito2: LongInt;
begin
  while Copy( Numero, 1, 1 ) = '0' do
    Numero := Copy( Numero, 2, Length( Numero ) - 1 );
  d1 := 0;
  d4 := 0;
  xx := 1;
  for nCount := 1 to Length( Numero ) - 2 do
  begin
    if Pos( Copy( Numero, nCount, 1 ), '0123456789' ) > 0 then
    begin
      if xx < 5 then
        fator := 06 - xx
      else
        fator := 14 - xx;
      d1 := d1 + StrToInt( Copy( Numero, nCount, 1 ) ) * fator;
      if xx < 6 then
        fator := 07 - xx
      else
        fator := 15 - xx;
      d4 := d4 + StrToInt( Copy( Numero, nCount, 1 ) ) * fator;
      xx := xx + 1;
    end;
  end;
  Resto := d1 mod 11;
  if Resto < 2 then
    Digito1 := 0
  else
    Digito1 := 11 - Resto;
  d4 := d4 + 2 * Digito1;
  Resto := d4 mod 11;
  if Resto < 2 then
    Digito2 := 0
  else
    Digito2 := 11 - Resto;
  Result := ( 10 * Digito1 + Digito2 = StrToInt( Copy( Numero, Length( Numero ) - 1 , 2 ) ) );
end;

function PegarVersaoDesteExecutavel: String;
var
  Info_Versao: PChar;
  Versao: PVSFixedFileInfo;
  Versao_Maior, Versao_Menor, InfoSize, V_Handle, Tam_Versao: DWord;
begin
  Result:= 'Padrão';

  {Primeiro Verifica o Tamanho Do Arquivo De Informação De Versão:}
  InfoSize := GetFileVersionInfoSize( PChar( Application.ExeName ), V_Handle );

  if ( InfoSize <> 0 ) then
  begin
    {Reserva-Se a Quantidade de Memória Adequada Para Pegar a Informação De Versão:}
    GetMem( Info_Versao, InfoSize );
    try
      if GetFileVersionInfo( PChar( Application.ExeName ), V_Handle, InfoSize, Info_Versao ) then
        if VerQueryValue( Info_Versao, '', Pointer( Versao ), Tam_Versao ) then
        begin
          Versao_Maior := Versao.dwFileVersionMS;
          Versao_Menor := Versao.dwFileVersionLS;

          {Shr é Uma Operação De Rotação de Bit a Direita. No Caso Abaxo Está
           Dividindo a Versão _Maior Por 65536:}
          Result :=
            IntToStr( Versao_Maior Div 65536 ) + '.' +
            IntToStr( Versao_Maior Mod 65536 ) + '.' +
            IntToStr( Versao_Menor Div 65536 ) + '.' +
            IntToStr( Versao_Menor Mod 65536 );
      end;
    finally
      FreeMem(Info_Versao);
    end;
  end;
end;

function PegarVersaoDoWindows(
  var NumeroDaVersao: String ): TWinVersion;
begin
  Result := wvUnknown;
  NumeroDaVersao := '';

  if ( Win32Platform = VER_PLATFORM_WIN32_WINDOWS ) then
  begin
    if ( Win32MajorVersion > 4 ) or
       ( (Win32MajorVersion = 4 ) and ( Win32MinorVersion > 0 ) ) then
      Result := wvWin98
    else
      Result := wvWin95
  end
  else
  begin
    if ( Win32MajorVersion <= 4 ) then
      Result := wvWinNT
    else
      if ( Win32MajorVersion = 5 ) then
        Result := wvWin2000
      else
        if ( Win32MajorVersion = 6 ) then
          if ( Win32MinorVersion = 1 ) then
            Result := wvWinSeven
          else
            Result := wvWinVista;
    end;

  if ( Result <> wvUnknown ) then
    NumeroDaVersao := IntToStr( Win32MajorVersion ) + '.' + IntToStr( Win32MinorVersion );
end;

Function PegarNomeUsuarioDoWindows: String;
var
  lpBuffer: Array[0..20] of Char;
  nSize: dWord;
  mRet: Boolean;
begin
  nSize := 120;
  mRet:= GetUserName( lpBuffer, nSize );
  if mRet then
    Result := Trim( String ( lpBuffer ) )
  else
    Result := '<Usuário Desconhecido>';
end;

function PegarNomeDoComputadorEmUso: String;
var
  ipbuffer: String;
  nsize: Dword;
  Nome: String;
  Cont: Integer;
  Ch: Char;
begin
  Result := '';

  nsize := 255;
  SetLength( ipbuffer, nsize );
  if GetComputerName( PChar( ipbuffer ), nsize ) then
  begin
    Nome := ipbuffer;

    Cont := 1;
    while ( Cont <= Length( Nome ) ) and
          ( Nome[Cont] <> Chr( 000 ) ) and
          ( Nome[Cont] <> ' ' ) do
    begin
      Ch := Nome[Cont];
      if ( ( Ch >= 'A' ) and ( Ch <= 'Z' ) ) or
         ( Ch = '-' ) then
        Result := Result + Ch;
      Cont := Cont + 1;
    end;
  end;
end;

function PegarSitesFavotitos(
  TamanhoMaximoDeLetrasDeCadaString: Integer ): TStrings;
var
  Pidl: PItemIDList;
  FavPath: array[0..MAX_PATH] of Char;

  function GetIEFavoritos(
    const FavPath: String): TStrings;
  var
    SearchRec: TSearchRec;
    ListaStrings: TStrings;
    Path, Dir, FileName, StringAIncluir, NomeDoSite: String;
    Buffer: array[0..2047] of Char;
    Found: Integer;
  begin
    ListaStrings := TStringList.Create;

    //Pegar todos os nomes de arquivo no Path dos favoritos
    Path := FavPath + '\*.url';
    Dir := ExtractFilePath( Path );
    Found := FindFirst( Path, faAnyFile, SearchRec ) ;
    while ( Found = 0 ) do
    begin
      SetString(
        FileName,
        Buffer,
        GetPrivateProfileString(
          'InternetShortcut',
          PChar( 'URL' ),
          NIL,
          Buffer,
          SizeOf( Buffer ),
          PChar( Dir + SearchRec.Name ) ) );

      NomeDoSite :=
        StringReplace( SearchRec.Name, '.url', '', [] );
      StringAIncluir :=
        FileName + ' (' +
        ModoEventualmenteAbreviadoDeUmaString(
          NomeDoSite,
          TamanhoMaximoDeLetrasDeCadaString - 03 - Length( FileName ) ) + ')';

      if ( Length( StringAIncluir ) <= TamanhoMaximoDeLetrasDeCadaString ) then
        ListaStrings.Add( StringAIncluir );

      Found := FindNext( SearchRec );
    end;
    Found := FindFirst( Dir + '*.*', faAnyFile, SearchRec );
    while ( Found = 0 ) do
    begin
      if ( ( SearchRec.Attr and faDirectory ) > 0 ) and
         ( SearchRec.Name[1] <> '.' ) then
        ListaStrings.AddStrings( GetIEFavoritos( Dir + '' + SearchRec.Name ) );
      Found := FindNext( SearchRec );
    end;
    SysUtils.FindClose( SearchRec );
    Result := ListaStrings;
  end;

begin
  SHGetSpecialFolderLocation( Application.Handle, CSIDL_FAVORITES, Pidl );
  SHGetPathFromIDList( Pidl, FavPath );
  Result := GetIEFavoritos( StrPas( FavPath ) );
end;

function ArquivoEstaEmUtilizacao(
  fName: String): Boolean;
var
  HFileRes: HFILE;
begin
  Result := False;
  if not FileExists( fName ) then
    Exit;

  HFileRes :=
    CreateFile(
      Pchar( fName ),
      GENERIC_READ or GENERIC_WRITE,
      0, nil, OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL,
      0 );
  Result := ( HFileRes = INVALID_HANDLE_VALUE );
  if not Result then
    CloseHandle( HFileRes );
end;

{O Tamanho Original é Representado Pelo FatorDeZoom := 1}
procedure DefinirZoomVisualParaNavegadorWeb(
  WebNavegador: TWebBrowser;
  FatorDeZoom: Real );
begin
  while ( webNavegador.ReadyState < READYSTATE_COMPLETE ) do
    Application.ProcessMessages;

  WebNavegador.OleObject.Document.Body.Style.Zoom := FatorDeZoom;
end;

procedure TrocarTodasAsImagensDeUmNavegadorWeb(
  WebNavegador: TWebBrowser;
  NomeDoArquivoDeImagem: String );
var
  Cont: Word;
begin
  while ( webNavegador.ReadyState < READYSTATE_COMPLETE ) do
    Application.ProcessMessages;

  for Cont := 0 to WebNavegador.OleObject.Document.Images.Length - 1 do
    Webnavegador.OleObject.Document.Images.Item(Cont).Src := NomeDoArquivoDeImagem;
end;

procedure ArredondarCantosDeUmControle(
  var Controle: TWinControl );
var
  R: TRect;
  Rgn: HRGN;
begin
  with Controle do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn( R.Left, R.Top, R.Right, R.Bottom, 20, 20 );
    Perform( EM_GETRECT, 0, lParam( @r ) );
    InflateRect( r, - 1, - 1 );
    Perform( EM_SETRECTNP, 0, lParam( @r ) );
    SetWindowRgn( Handle, rgn, True );
    Invalidate;
  end;
end;

procedure ReiniciarEsteAplicativo;
var
  AppName: PChar;
begin
  AppName := PChar( Application.ExeName );
  ShellExecute( Application.Handle, 'open', AppName, nil, nil, SW_SHOWNORMAL );
  Application.Terminate;
end;

{
Função Destinada a Simular o Pressionamento De Teclas.

   Parâmetros:

      Key        : Virtual Keycode da tecla desejada. Para teclas comuns, usar o Código ANSI (Função "Ord").
      Shift      : É Padrão TShiftState.
      SpecialKey : Normalmente é FALSE. Pode ser TRUE para especificar teclas do Teclado Numérico, por exemplo.

   Exemplos De Utilização:

      PostKeyEx32( VK_LWIN, [], False );                 // Pressionando a Tela De Função Especial Do Windows Do Lado Esquerdo
      PostKeyEx32( Ord('D'), [], False );                // Pressionando a Letra "D"
      PostKeyEx32( Ord('C'), [ssCtrl, ssAlt], False );   // Pressionando Ctrl-Alt-C
}
procedure PostKeyEx32(
  Key: Word;
  const Shift: TShiftState;
  Specialkey: Boolean );
type
  TShiftKeyInfo = record
    shift: Byte;
    vkey: Byte;
  end;
  byteset = set of 0..7;
const
  shiftkeys: array [1..3] of TShiftKeyInfo = (
    ( shift: Ord( ssCtrl ); vkey: VK_CONTROL ),
    ( shift: Ord( ssShift ); vkey: VK_SHIFT ),
    ( shift: Ord( ssAlt ); vkey: VK_MENU ) );
var
  flag: DWORD;
  bShift: ByteSet absolute shift;
  i: Integer;
begin
  for i := 1 to 3 do
  begin
    if shiftkeys[i].shift in bShift then
      keybd_event( shiftkeys[i].vkey, MapVirtualKey( shiftkeys[i].vkey, 0 ), 0, 0 );
  end;
  if specialkey then
    flag := KEYEVENTF_EXTENDEDKEY
  else
    flag := 0;

  keybd_event( key, MapvirtualKey( key, 0 ), flag, 0 );
  flag := flag or KEYEVENTF_KEYUP;
  keybd_event(key, MapvirtualKey( key, 0), flag, 0 );

  for i := 3 downto 1 do
  begin
    if shiftkeys[i].shift in bShift then
      keybd_event( shiftkeys[i].vkey, MapVirtualKey( shiftkeys[i].vkey, 0 ), KEYEVENTF_KEYUP, 0 );
  end;
end;

function PegarNumeroDaLinhaEmQueEstaPosicionadoUmMemo(
  Extracao: TMemo ): Integer;
begin
  Result := Extracao.Perform( EM_LINEFROMCHAR, Extracao.SelStart, 0 );
end;

{
A Função a Seguir Retorna a Pasta Padrão De Qualquer Diretório Notável do Windows.
O Parâmetro De Consulta CSIDL, Possui Identificadores Que Exigem "Uses ShlObj" e
Deve Ser Passado De Acordo Com a Seguinte Tabela:

CSIDL_BITBUCKET	 : Para Lixeira
CSIDL_CONTROLS   : Para Painel de Controle
CSIDL_DESKTOP    : Para Windows Desktop
CSIDL_DESKTOPDIR : Para Windows Desktop Na Árvore Física de Arquivos
CSIDL_FONTS      : Fontes de Caracteres
CSIDL_NETHOOD    : Para Rede Na Árvore Física de Arquivos
CSIDL_NETWORK    : Para Rede
CSIDL_PERSONAL	 : Meus Documentos
CSIDL_PRINTERS   : Impressoras
CSIDL_PROGRAMS   : Arquivos de Programas
CSIDL_RECENT     : Último Utilizado
CSIDL_SENDTO     : Enviar Para
CSIDL_STARTMENU  : Menu Iniciar
CSIDL_STARTUP    : Inicialização Automática
CSIDL_TEMPLATES  : Templates
}
function ExtrairDiretorioNotavel(
  CSIDL: Integer ): String;
var
  RecPath: PAnsiChar;
begin
  Result := '';
  RecPath := StrAlloc( MAX_PATH );
  try
    FillChar( RecPath^, MAX_PATH, 0 );
    if SHGetSpecialFolderPath( 0, RecPath, CSIDL, False ) then
     Result := RecPath;
  finally
    StrDispose( RecPath );
  end;
  Result := Trim( Result ) + '\';
end;

function VerificarSeExisteUmFonteDeCaracteresSobWindows(
  NomeDoFonteTTF: String ): Boolean;
begin
  Result := ( Screen.Fonts.IndexOf( NomeDoFonteTTF ) >= 0 );
end;

function InstalarUmFonteDeCaracteresSobWindows(
  NomeDoArquivoDeFonteTTF: String ): Boolean;
var
  OrigemNomeDoArquivoDeFonteTTF, DestinoNomeDoArquivoDeFonteTTF: String;
begin
  Result := False;

  OrigemNomeDoArquivoDeFonteTTF := NomeDoArquivoDeFonteTTF;
  if not FileExists( OrigemNomeDoArquivoDeFonteTTF ) then
    OrigemNomeDoArquivoDeFonteTTF := Trim( ExtractFilePath( Application.ExeName ) + 'Operacao\Fontes_Caracteres\' + OrigemNomeDoArquivoDeFonteTTF );

  if FileExists( OrigemNomeDoArquivoDeFonteTTF ) then
  begin
    {Copiar Arquivo Com o Fonte de Caracteres Para a Pasta Correspondente do Windows:}
    DestinoNomeDoArquivoDeFonteTTF := ExtrairDiretorioNotavel( CSIDL_FONTS ) + NomeDoArquivoDeFonteTTF;
    CopiarArquivo( OrigemNomeDoArquivoDeFonteTTF, DestinoNomeDoArquivoDeFonteTTF );

    {Acrescentar o Fonte De Characteres Sob Windows:}
    AddFontResource( PChar( DestinoNomeDoArquivoDeFonteTTF ) );
    SendMessage( HWND_BROADCAST, WM_FONTCHANGE, 0, 0 );

    Result := True;
  end;
end;

procedure CachoalharUmForm(
  Form: TForm;
  NumeroDeCachoalhos: Integer;
  AplitudeMaxima: Integer );
var
   wHandle: THandle;
   oRect, wRect: TRect;
   Deltax: Integer;
   Deltay: Integer;
   cnt: Integer;
   Dx, Dy: Integer;
begin
  wHandle := Form.Handle;
  GetWindowRect( wHandle, wRect );
  oRect := wRect;

  Randomize;
  for cnt := 0 to NumeroDeCachoalhos do
  begin
    deltax := Round( Random( AplitudeMaxima ) );
    deltay := Round( Random( AplitudeMaxima ) );
    dx := Round( 1 + Random( 2 ) );
    if ( dx = 2 ) then
      dx := - 1;
    dy := Round( 1 + Random( 2 ) );
    if ( dy = 2 ) then
      dy := - 1;
    OffsetRect( wRect, dx * deltax, dy * deltay );
    MoveWindow( wHandle, wRect.Left, wRect.Top, wRect.Right - wRect.Left, wRect.Bottom - wRect.Top, True );
   end;
   MoveWindow( wHandle, oRect.Left, oRect.Top, oRect.Right - oRect.Left, oRect.Bottom - oRect.Top, True );
end;

function PegarConteudoPaginaHTMLComCampoIdentificadoPorName(
  webNavegador: TWebBrowser;
  NomeDoCampo: String ): String;
var
  Document: IHTMLDocument2;
  TheForm: IHTMLFormElement;
begin
  Result := '';
  Document := webNavegador.Document as IHTMLDocument2;
  TheForm := GetFormByNumber( webNavegador.Document as IHTMLDocument2, 0 );
  Result := GetFieldValue( TheForm, NomeDoCampo );
end;

function GetFormByNumber(
  document: IHTMLDocument2;
  formNumber: Integer ): IHTMLFormElement;
var
  Forms: IHTMLElementCollection;
begin
  Forms := Document.Forms as IHTMLElementCollection;
  if ( FormNumber < Forms.Length ) then
    Result := Forms.Item( FormNumber, '' ) as IHTMLFormElement
  else
    Result := nil;
end;

function GetFieldValue(
  FromForm: IHTMLFormElement;
  const fieldName: String): String;
var
  Field: IHTMLElement;
  InputField: IHTMLInputElement;
  SelectField: IHTMLSelectElement;
  TextField: IHTMLTextAreaElement;
begin
  Field := FromForm.Item( FieldName, '' ) as IHTMLElement;
  if ( not Assigned( Field ) ) then
    Result := ''
  else
  begin
    if      ( Field.tagName = 'INPUT' ) then
    begin
      InputField := Field as IHTMLInputElement;
      Result := InputField.Value
    end
    else if ( Field.tagName = 'SELECT' ) then
    begin
      SelectField := Field as IHTMLSelectElement;
      Result := SelectField.Value
    end
    else if ( Field.tagName = 'TEXTAREA' ) then
    begin
      TextField := Field as IHTMLTextAreaElement;
      Result := TextField.Value;
    end;
  end
end;

function UsuarioAdministrador: Boolean;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
  NumeroDaVersaoString: String;
  Versao: TWinVersion;
begin
  Result := True;

  Versao := PegarVersaoDoWindows( NumeroDaVersaoString );
  if ( Versao in [wvWinNT, wvWin2000 ] ) then
  begin
    Result := False;
    
    bSuccess := OpenThreadToken( GetCurrentThread, TOKEN_QUERY, True, hAccessToken );
    if not bSuccess then
    begin
      if ( GetLastError = ERROR_NO_TOKEN ) then
      bSuccess := OpenProcessToken( GetCurrentProcess, TOKEN_QUERY, hAccessToken );
    end;
    if bSuccess then
    begin
      GetMem( ptgGroups, 1024 );
      bSuccess := GetTokenInformation( hAccessToken, TokenGroups, ptgGroups, 1024, dwInfoBufferSize );
      CloseHandle( hAccessToken );
      if bSuccess then
      begin
        AllocateAndInitializeSid(
          SECURITY_NT_AUTHORITY,
          2,
          SECURITY_BUILTIN_DOMAIN_RID,
          DOMAIN_ALIAS_RID_ADMINS,
          0, 0, 0, 0, 0, 0,
          psidAdministrators);

        {$R-}
        for x := 0 to ptgGroups.GroupCount - 1 do
          if EqualSid( psidAdministrators, ptgGroups.Groups[x].Sid ) then
          begin
            Result := True;
            Break;
          end;
        {$R+}

        FreeSid( psidAdministrators );
      end;
      FreeMem( ptgGroups );
    end;
  end;
end;

procedure AbrirInternetExplorerPersonalizado(
  Esquerda, Topo, Largura, Altura: Integer;
  BarraDeMenu, BarraDeEnderecos, BarraDeEstado, Redimensionavel: Boolean;
  EnderecoUrl: String );
var
  IExplorer: IWebBrowser2;
  Url, Flags, TargetFrameName, PostData, Headers: OleVariant;
begin
  {Colocar No "Uses", ComObj e SHDocVw_TLB}
  IExplorer := CreateOleObject( 'InternetExplorer.Application' ) as IWebBrowser2;
  IExplorer.Left := Esquerda;
  IExplorer.Top := Topo;
  IExplorer.Width := Largura;
  IExplorer.Height := Altura;
  IExplorer.MenuBar := BarraDeMenu;
  IExplorer.AddressBar := BarraDeEnderecos;
  IExplorer.StatusBar := BarraDeEstado;
  IExplorer.Resizable := Redimensionavel;
  IExplorer.ToolBar := 0;
  Url := Trim( EnderecoUrl );
  IExplorer.Navigate2( Url, Flags, TargetFrameName, PostData, Headers );
  IExplorer.Visible := True;

  { Métodos Adicionais Que Podem Ser Utilizados:

    IExplorer.GoForward;
    IExplorer.Quit;
    IExplorer.Refresh;
    IExplorer.Stop;
    IExplorer.GoHome;
    IExplorer.FullScreen := True;}
end;

procedure AssociarExtensaoTipoDeArquivoComExecutavel(
  ExtensaoSemPontoInicial: String;
  NomeArquivoExecutavelAplicacao: String );
var
  Registro: TRegistry;
begin
  {Colocar No "Uses", Registroistry e shlobj}
  Registro := TRegistry.Create;
  try
    Registro.RootKey := HKEY_CLASSES_ROOT;
    Registro.OpenKey( '.' + ExtensaoSemPontoInicial, True );
    Registro.WriteString( '', ExtensaoSemPontoInicial + '_auto_file');
    Registro.CloseKey;

    Registro.CreateKey( ExtensaoSemPontoInicial + '_auto_file' );
    Registro.OpenKey( ExtensaoSemPontoInicial + '_auto_file\DefaultIcon', True);
    Registro.WriteString( '', NomeArquivoExecutavelAplicacao + ',0' );
    Registro.CloseKey;

    Registro.OpenKey( ExtensaoSemPontoInicial + '_auto_file\shell\open\command', True );
    Registro.WriteString( '', NomeArquivoExecutavelAplicacao + ' "%1"' );
    Registro.CloseKey;
  finally
    Registro.Free;
  end;
  SHChangeNotify( SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil );
end;

procedure ConverterValorDeIntervaloParaEquivalenteEmOutroIntervalo(
  IntervaloDeOrigem: TPoint;
  ValorDeOrigem: Integer;
  IntervaloDeDestino: TPoint;
  var ValorDeDestino: Integer );
begin
  ValorDeDestino := Round(
    IntervaloDeDestino.X +
    ( IntervaloDeDestino.Y - IntervaloDeDestino.X ) *
    ( ValorDeOrigem - IntervaloDeOrigem.X ) / ( IntervaloDeOrigem.Y - IntervaloDeOrigem.X ) );
end;

procedure ConverterPontoDeAreaParaEquivalenteEmOutraArea(
  AreaDeOrigem: TRect;
  PontoDeOrigem: TPoint;
  AreaDeDestino: TRect;
  var PontoDeDestino: TPoint );
begin
  ConverterValorDeIntervaloParaEquivalenteEmOutroIntervalo(
    Point( AreaDeOrigem.Left, AreaDeOrigem.Right ),
    PontoDeOrigem.X,
    Point( AreaDeDestino.Left, AreaDeDestino.Right ),
    PontoDeDestino.X );

  ConverterValorDeIntervaloParaEquivalenteEmOutroIntervalo(
    Point( AreaDeOrigem.Top, AreaDeOrigem.Bottom ),
    PontoDeOrigem.Y,
    Point( AreaDeDestino.Top, AreaDeDestino.Bottom ),
    PontoDeDestino.Y );
end;

procedure ConverterSubAreaDeAreaParaEquivalenteEmOutraArea(
  AreaDeOrigem: TRect;
  SubAreaDeOrigem: TRect;
  AreaDeDestino: TRect;
  var SubAreaDeDestino: TRect );
var
  PontoConvertido: TPoint;
begin
  ConverterPontoDeAreaParaEquivalenteEmOutraArea(
    AreaDeOrigem,
    Point( SubAreaDeOrigem.Left, SubAreaDeOrigem.Top ),
    AreaDeDestino,
    PontoConvertido );
  SubAreaDeDestino.Left := PontoConvertido.X;
  SubAreaDeDestino.Top := PontoConvertido.Y;

  ConverterPontoDeAreaParaEquivalenteEmOutraArea(
    AreaDeOrigem,
    Point( SubAreaDeOrigem.Right, SubAreaDeOrigem.Bottom ),
    AreaDeDestino,
    PontoConvertido );
  SubAreaDeDestino.Right := PontoConvertido.X;
  SubAreaDeDestino.Bottom := PontoConvertido.Y;
end;

{
A Função a Seguir Remove Uma Certa Cor do Bitmap e a Substitui Por Uma Nova Cor.
O Porcentual de Tolerância é Um Parâmetro Que Vai de 000 a 100. Se For Passado 000,
Então Substituirá a Cor de Cada Pixel Desde Que Ela Seja Estritamente Igual a Cor
Anterior. E Na Medida Em Que Este Porcentua Aumenta, Ela Passa a Ser Mais Tolerante
Quanto a Considerar Que a Cor é Igual a Que Deve Ser Substituída.
}
procedure BitmapTrocarUmaCorPorOutra(
  Bitmap: TBitmap;
  CorAnterior: TColor;
  CorNova: TColor;
  PorcentualTolerancia: Double );
type
  TCorPixel32Bits = Packed Record
    Azul, Verde, Vermelho, Alpha: Byte;
  end;
  TArrayCorPixel32Bits = Packed Array[ 0..MaxInt div SizeOf( TCorPixel32Bits ) - 1 ] of TCorPixel32Bits;
  TApontadorArrayCorPixel32Bits = ^TArrayCorPixel32Bits;
var
  i, j, Tolerancia: Integer;
  LinhaPixelsBitmap: TApontadorArrayCorPixel32Bits;
  CorAnteriorDividida, CorNovaDividida: TCorPixel32Bits;
begin
  {Por Otimização de Desempenho, Já Deixa a Cor de Fundo Dividida Em Seus Canais:}
  CorAnteriorDividida.Vermelho := ( CorAnterior Shr 00 ) mod 256;
  CorAnteriorDividida.Verde    := ( CorAnterior Shr 08 ) mod 256;
  CorAnteriorDividida.Azul     := ( CorAnterior Shr 16 ) mod 256;

  {Por Otimização de Desempenho, Já Deixa a Nova Cor de Fundo Dividida Em Seus Canais:}
  CorNovaDividida.Vermelho     := ( CorNova Shr 00 ) mod 256;
  CorNovaDividida.Verde        := ( CorNova Shr 08 ) mod 256;
  CorNovaDividida.Azul         := ( CorNova Shr 16 ) mod 256;

  {Definir o Valor Numerico da Tolerancia de Diferença no Padrão 000 a 255:}
  Tolerancia := Round( 255 * PorcentualTolerancia / 100 );

  Bitmap.PixelFormat := pf32bit;
  for j := 0 to Bitmap.Height - 1 do
  begin
    LinhaPixelsBitmap := Bitmap.Scanline[ j ];

    for i := 0 to Bitmap.Width - 1 do
    begin
      if ( Abs( LinhaPixelsBitmap[ i ].Azul     - CorAnteriorDividida.Azul     ) <= Tolerancia ) and
         ( Abs( LinhaPixelsBitmap[ i ].Verde    - CorAnteriorDividida.Verde    ) <= Tolerancia ) and
         ( Abs( LinhaPixelsBitmap[ i ].Vermelho - CorAnteriorDividida.Vermelho ) <= Tolerancia ) then
      begin
        LinhaPixelsBitmap[ i ] := CorNovaDividida;
      end;
    end;
  end;

  {É Necessário Fazer Isto Para "Resetar" o Bitmap de Forma Que Esta Mesma Função
   Possa Ser Aplicada Novamente Sobre Ele Em Uma Nova Execução:}
  Bitmap.Canvas.Draw( 0, 0, Bitmap );
end;

procedure ConverterPictureParaFormatoBitmapSeJaNaoEstiver(
  Picture: TPicture );
var
  Bitmap: TBitmap;
begin
  if ( not ( Picture.Graphic is TBitmap ) ) then
  begin
    Bitmap := TBitmap.Create;
    Bitmap.Assign( Picture.Graphic );
    Bitmap.PixelFormat := pf32bit;
    Picture.Assign( Bitmap );
    Bitmap.Free;
  end;
end;

function ModoEventualmenteAbreviadoDeUmaString(
  const Mensagem: String;
  const TamanhoMaximo: Integer ): String;
begin
  Result := Mensagem;

  if ( Length( Result ) > TamanhoMaximo ) then
    Result := LeftStr( Result, TamanhoMaximo - 3 ) + '...';
end;

function PegarNomeDoComputadorEnderecoIPRedeLocalEnderecoIPInternet(
  var NomeDoComputador, EnderecoIPNaRedeLocal, EnderecoIPNaInternetGlobal, ErroEventualmenteOcorrido: String ): Boolean;
type
  Name = array[0..100] of Char;
  PName = ^Name;
var
  HEnt: pHostEnt;
  HName: PName;
  WSAData: TWSAData;
  i: Integer;

  function PegarEnderecoIPNaInternetGlobal: String;
  var
    IP: TIdHTTP;
    Temporario: String;
    Endereco : String;
    i: Integer;
  begin
    try
      IP := TIdHTTP.Create( Nil );
      with IP do
      begin
        Host := 'checkip.dyndns.org';
        Temporario := Get( 'checkip.dyndns.org' );
        for i := 1 to Length( Temporario ) do
          if ( Temporario[i] in ['0'..'9'] ) or ( Temporario[i] = '.' ) then
            Endereco := Endereco + Temporario[i];
       end;
       Result := Trim( Endereco );
       IP.Free;
    except
       Result := 'ERRO';
    end;
  end;

begin
  Result := False;
  if ( WSAStartup( $0101, WSAData ) <> 0 ) then
  begin
    ErroEventualmenteOcorrido := 'Winsock Não Responde';
    Exit;
  end;
  EnderecoIPNaRedeLocal := '';
  New( HName );
  if ( GetHostName( HName^, SizeOf( Name ) ) = 0 ) then
  begin
    NomeDoComputador := StrPas( HName^ );
    HEnt := GetHostByName( HName^ );
    for i := 0 to HEnt^.h_Length - 1 do
      EnderecoIPNaRedeLocal :=
        Concat(
          EnderecoIPNaRedeLocal,
          IntToStr( Ord( HEnt^.h_addr_list^[i] ) )  + '.' );
    SetLength( EnderecoIPNaRedeLocal, Length( EnderecoIPNaRedeLocal ) - 1 );
    Result := True;
  end
  else
  begin
    case WSAGetLastError of
      WSANOTINITIALISED:
        ErroEventualmenteOcorrido := 'WSANotInitialised';
      WSAENETDOWN:
        ErroEventualmenteOcorrido := 'WSAENetDown';
      WSAEINPROGRESS:
        ErroEventualmenteOcorrido := 'WSAEInProgress';
    end;
  end;
  Dispose( HName );
  WSACleanup;

  EnderecoIPNaInternetGlobal := PegarEnderecoIPNaInternetGlobal;
end;

Function PegarEnderecoIPNaRedeLocal: String;
type
  pu_long = ^u_long;
var
  varTWSAData: TWSAData;
  varPHostEnt: PHostEnt;
  varTInAddr: TInAddr;
  namebuf: Array[0..255] of Char;
begin
  If ( WSAStartup( $101, varTWSAData ) <> 0 ) then
  begin
    Result := 'Não Identificado Endereço IP';
  end
  else
  begin
    GetHostName( namebuf, SizeOf( namebuf ));
    varPHostEnt := GetHostByName( namebuf );
    varTInAddr.S_addr := u_long( pu_long(varPHostEnt^.h_addr_list^ )^ );
    Result := inet_ntoa( varTInAddr );
  End;
  WSACleanup;
end;

{Em Agosto de 2017 a Função Abaixo Passou a Gerar Exception "302 Found" Devido
 Ao Site Utilizado Tentar Realizar Redirecionamento o Que Antes Ele Não Fazia.
 Foi Por Este Motivo Que Foi Escrita Uma Nova Função "PegarEnderecoIPNaRedeExterna_2"
 Conforme Está Codificada Um Pouco Mais Abaixo:}
function PegarEnderecoIPNaRedeExterna: String;
begin
  with TIdHTTP.Create( Application ) do
  begin
    try
      Result := Get( 'http://ipinfo.io/ip/' );
    finally
      Free;
    end;
  end;

  if ( RightStr( Result, 1 ) = Chr( 010 ) ) then
    Result := LeftStr( Result, Length( Result ) - 1 );
end;

function PegarEnderecoIPNaRedeExterna_2: String;
const
  StringBuscar = 'Current IP Address: ';
var
  RetornoWeb: String;
  Posicao: Integer;
begin
  with TIdHTTP.Create( Application ) do
  begin
    try
      RetornoWeb := Get( 'http://checkip.dyndns.org/' );
    finally
      Free;
    end;
  end;

  Result := '';
  Posicao := Pos( StringBuscar, RetornoWeb );
  if ( Posicao > 0 ) then
  begin
    Posicao := Posicao + Length( StringBuscar );
    while ( Pos( RetornoWeb[ Posicao ], '0123456789.' ) > 0 ) do
    begin
      Result := Result + RetornoWeb[ Posicao ];
      Posicao := Posicao + 1;
    end;
  end;
end;

function PegarDadosCoordenadasDaLocalizacaoFisicaUsandoIPExterno(
  IPExterno: String;
  var NomeDoEstado: String;
  var NomeDoMunicipio: String;
  var Latitude: Double;
  var Longitude: Double ): String;
const
  EnderecoURLPadrao = 'http://api.ipinfodb.com/v3/ip-city/?key=<<<CHAVE_IPINFODB>>>&ip=<<<ENDERECO_IP>>>';
var
  EnderecoURL, Chave_IpInfoDB: String;

  function ExtrairParametro( Origem: String; NumeroDoParametro: Integer ): String;
  var
    Posicao1, Posicao2: Integer;
  begin
    Posicao1 := 0;
    while ( NumeroDoParametro > 0 ) do
    begin
      Posicao1 := PosEx( ';', Origem, Posicao1 + 1 );
      NumeroDoParametro := NumeroDoParametro - 1;
    end;
    Posicao2 := PosEx( ';', Origem, Posicao1 + 1 );
    Result := Copy( Origem, Posicao1 + 1, Posicao2 - Posicao1 - 1 )
  end;

begin
  {A Chave de Acesso à API Abaixo é Meramente Demonstrativa. Para Obter Uma
   Chave Efetiva, Com Maior Precisão, Deve-se Obter Em: http://ipinfodb.com/register.php}
  Chave_IpInfoDB := 'a069ef201ef4c1b61231b3bdaeb797b5488ef879effb23d269bda3a572dc704c&';

  EnderecoURL := AnsiReplaceStr( EnderecoURLPadrao, '<<<CHAVE_IPINFODB>>>', Chave_IpInfoDB );
  EnderecoURL := AnsiReplaceStr( EnderecoURL      , '<<<ENDERECO_IP>>>'   , IPExterno );

  Result := '';
  with TIdHTTP.Create( Application ) do
  begin
    Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';
    ReadTimeout := 5000;
    try
      Result := Get( EnderecoURL );
    finally
      Free;
    end;
  end;

  if ( LeftStr( Result, 2 ) = 'OK' ) then
  begin
    NomeDoEstado := ExtrairParametro( Result, 05 );
    NomeDoMunicipio := ExtrairParametro( Result, 06 );
    Latitude := StrToFloat( AnsiReplaceStr( ExtrairParametro( Result, 08 ), '.', DecimalSeparator ) );;
    Longitude := StrToFloat( AnsiReplaceStr( ExtrairParametro( Result, 09 ), '.', DecimalSeparator ) );;
  end;
end;

procedure ExecutarShellExecute(
  Comando: String );
var
  CursorAnterior: TCursor;
begin
  CursorAnterior := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;

  ShellExecute(
    Application.Handle,
    'open',
    PChar( Comando ),
    '',
    '',
    0 );

  Screen.Cursor := CursorAnterior;
  Application.ProcessMessages;
end;

{
Para Que a Função Abaixo Funcione No Caso De Necessidade de Autenticação SSL
No SMTP, o Executável Deverá Estar Acompanhado Das Seguintes DLLs:

"libeay32.dll" e "ssleay32.dll"
}
function EnviarEmailCompletoInclusiveComSSL(
  Nome_Exibicao_Remetente: String;
  Email_Exibicao_Remetente: String;
  Assunto: String;
  Usuario_Conta_Smtp: String;
  Usuario_Senha_Smtp: String;
  Servidor_Smtp: String;
  Porta_Smtp: Integer;
  Autenticar_Usuario: Boolean;
  Autenticar_SSL: Boolean;
  Prioridade: TIdMessagePriority;
  Corpo_Texto_Plano: String;
  Corpo_Arquivo_HTML: String;
  Destinatarios_Abertos: String;
  Destinatarios_Ocultos: String;
  Nomes_Arquivos_Anexos: TStringList;
  ConteudoXML: TStringList;
  DevePersonalizarConteudoHTML: Boolean;
  Equipamento: String;
  EmailRetorno: String ): Boolean;
var
  Mensagem: TIdMessage;
  Texto: TIdText;
  Html: TIdText;
  ConexaoSMTP: TIdSMTP;
  AutenticarSSL: TIdSSLIOHandlerSocket;
  Contador_Anexos: Integer;
  Anexo: TIdAttachment;

  procedure PersonalizarHTML;
  begin
    Html.Body.Text :=
      StringReplace(
        Html.Body.Text,
        '_DATAHORAENVIO_',
        FormatDateTime( 'dddd", " dd "/" mm "/" yyyy " às " hh ":" mm ":" ss "horas"', Now_NoFusoHorarioOficialDoBrasilEmBrasilia ),
        [rfReplaceAll] );

    Html.Body.Text :=
      StringReplace(
        Html.Body.Text,
        '_NOMESOFTWARE_',
        NomeDestePrograma,
        [rfReplaceAll] );

    Html.Body.Text :=
      StringReplace(
        Html.Body.Text,
        '_NOMECOMPLETOSOFTWARE_',
        NomeDestePrograma + ' v' + frmPrincipal.NumeroCompletoVersao,
        [rfReplaceAll] );

    Html.Body.Text :=
      StringReplace(
        Html.Body.Text,
        '_IDENTIFICADOR_',
        Equipamento,
        [rfReplaceAll] );

    Html.Body.Text :=
      StringReplace(
        Html.Body.Text,
        '_EMAILRETORNO_',
        EmailRetorno,
        [rfReplaceAll] );

    Html.Body.Text :=
      StringReplace(
        Html.Body.Text,
        '_CONTEUDOXML_',
        ConteudoXML.Text,
        [rfReplaceAll] );
  end;

begin
  Result := True;

  Application.ProcessMessages;

  Mensagem := TIdMessage.Create( Nil );
  ConexaoSMTP  := TIdSMTP.Create( Nil );

  AutenticarSSL := TIdSSLIOHandlerSocket.Create( Nil );

  try
    try

      if Autenticar_SSL then
      begin
        ConexaoSMTP.IOHandler := AutenticarSSL;
        AutenticarSSL.SSLOptions.Method := sslvSSLv3;
        AutenticarSSL.SSLOptions.Mode := sslmClient;
      end;

      Mensagem.From.Name := Nome_Exibicao_Remetente;
      Mensagem.From.Address := Email_Exibicao_Remetente;
      Mensagem.Recipients.EMailAddresses := Destinatarios_Abertos;
      Mensagem.BccList.EMailAddresses := Destinatarios_Ocultos;
      Mensagem.Priority := Prioridade;
      Mensagem.Subject := Assunto;

      Mensagem.Body.Clear;
      Mensagem.Body.Add( Corpo_Texto_Plano );
      Mensagem.ContentType := 'multipart/mixed';

      {Mensagem Em Texto:}
      Texto := TIdText.Create( Mensagem.MessageParts );
      Texto.Body.Text := Corpo_Texto_Plano;
      Texto.ContentType := 'text/plain';

      {Mensagem Em HTML:}
      Corpo_Arquivo_HTML := Trim( Corpo_Arquivo_HTML );
      if ( Corpo_Arquivo_HTML <> '' ) then
        if FileExists( Corpo_Arquivo_HTML ) then
        begin
          Html := TIdText.Create( Mensagem.MessageParts );
          Html.Body.LoadFromFile( Corpo_Arquivo_HTML );
          Html.ContentType := 'text/html';

          if DevePersonalizarConteudoHTML then
            PersonalizarHTML;
        end;

      for Contador_Anexos := 0 to Nomes_Arquivos_Anexos.Count - 1 do
      begin
        Anexo := TIdAttachment.Create( Mensagem.MessageParts, Nomes_Arquivos_Anexos.Strings[Contador_Anexos] );
        Anexo.ContentType := 'image/jpeg';
        Anexo.ExtraHeaders.Values['Content-ID'] := '<' + Trim( ExtractFileName( Nomes_Arquivos_Anexos.Strings[Contador_Anexos] ) ) + '>';
      end;

      ConexaoSMTP.Host := Servidor_Smtp;
      ConexaoSMTP.Username := Usuario_Conta_Smtp;
      ConexaoSMTP.Password := Usuario_Senha_Smtp;
      ConexaoSMTP.Port := Porta_Smtp;
      ConexaoSMTP.MailAgent := frmPrincipal.NomeCompletoDestePrograma;

      if Autenticar_Usuario then
        ConexaoSMTP.AuthenticationType := atLogin
      else
        ConexaoSMTP.AuthenticationType := atNone;

      Application.ProcessMessages;

      try
        ConexaoSMTP.Connect;
      except
        Result := False;
      end;

      Application.ProcessMessages;

      if Result then
      begin
        try
          try
            ConexaoSMTP.Send( Mensagem );
          except
            Result := False;
          end;
        finally
          ConexaoSMTP.Disconnect;
        end;

        Application.ProcessMessages;
      end;

    except

      Result := False;

    end;

  finally

    AutenticarSSL.Free;

    ConexaoSMTP.Free;
    Mensagem.Free;

    Application.ProcessMessages;

  end;
end;

procedure WinInet_HttpsPost(
  const Url: String;
  Stream: TStringStream );
const
  BuffSize = 1024 * 1024;
var
  hInter: HINTERNET;
  UrlHandle: HINTERNET;
  BytesRead: DWORD;
  Buffer: Pointer;
begin
  hInter := InternetOpen( '', INTERNET_OPEN_TYPE_PRECONFIG, Nil, Nil, 0 );
  if Assigned( hInter ) then
  begin
    Stream.Seek( 0, 0 );
    GetMem( Buffer,BuffSize );
    try
        UrlHandle := InternetOpenUrl( hInter, PChar( Url ), Nil, 0, INTERNET_FLAG_RELOAD, 0 );
        if Assigned( UrlHandle ) then
        begin
          repeat
            InternetReadFile( UrlHandle, Buffer, BuffSize, BytesRead );
            if ( BytesRead > 0 ) then
             Stream.WriteBuffer( Buffer^, BytesRead );
          until ( BytesRead = 0 );
          InternetCloseHandle( UrlHandle );
        end;
    finally
      FreeMem( Buffer );
    end;
    InternetCloseHandle( hInter );
  end
end;

procedure LerConfiguracaoInicial;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create( ChangeFileExt( Application.ExeName, '.ini' ) );
  try
    Configuracao_Inicial_Emails_Destinatarios :=
      IniFile.ReadString ( 'Configuracoes', 'Emails_Destinatarios'       , 'rudolfo.horner@gmail.com' );
    Configuracao_Inicial_Listagem_Orientacao_Padrao :=
      IniFile.ReadInteger( 'Configuracoes', 'Listagem_Orientacao_Padrao' , 0 );
    Configuracao_Inicial_Logotipo_Sequencial_Padrao :=
      IniFile.ReadInteger( 'Configuracoes', 'Logotipo_Sequencial_Padrao' , Logo_OrdemLogotipoPadraoInicial );
  finally
    IniFile.Free;
  end;
end;

procedure GravarConfiguracaoInicial;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create( ChangeFileExt( Application.ExeName, '.ini' ) );
  try
    IniFile.WriteString (
      'Configuracoes', 'Emails_Destinatarios'      , Trim( Configuracao_Inicial_Emails_Destinatarios ) );
    IniFile.WriteInteger(
      'Configuracoes', 'Listagem_Orientacao_Padrao', Configuracao_Inicial_Listagem_Orientacao_Padrao );
    IniFile.WriteInteger(
      'Configuracoes', 'Logotipo_Sequencial_Padrao', Configuracao_Inicial_Logotipo_Sequencial_Padrao );
  finally
    IniFile.Free;
  end;
end;

procedure GravarLinhaNoLogHistoricoDeEventos(
  LinhaDescritiva: String );
var
  NomeDoArquivoLog: String;
  Arquivo: TextFile;
  DataHoraLog: TDateTime;

  function ArquivoTextFileEstaAberto: Boolean;
  const
    fmTextOpenRead = 55217;
    fmTextOpenWrite = 55218;
  begin
    Result := ( TTextRec( Arquivo ).Mode = fmTextOpenRead ) or ( TTextRec( Arquivo ).Mode = fmTextOpenWrite );
  end;

begin
  DataHoraLog := Now_NoFusoHorarioOficialDoBrasilEmBrasilia;

  NomeDoArquivoLog := ChangeFileExt( Application.Exename, '.log' );
  AssignFile( Arquivo, NomeDoArquivoLog );

  {Caso o Arquivo Log Esteja Aberto, Em Registro de Evento Por Parte de Outro Usuário, Aguarda Um Pequeno
   Instante Para Tentar Novamente a Sua Abertura:}
  while ArquivoTextFileEstaAberto do
    EsperarSegundos( 0.1, False );

  if FileExists( NomeDoArquivoLog ) then
    Append( Arquivo )
  else
  begin
    ReWrite( Arquivo );
    WriteLn(
      Arquivo,
      '"DATA";"DIA_SEMANA";"HORARIO";"USUARIO";"SISTEMA_CLIENTE";"NAVEGADOR_CLIENTE";"IP_ORIGEM";"LOCAL_ORIGEM";"DESCRICAO_EVENTO"' );
  end;

  try
    Writeln(
      Arquivo,
      '"' +
      FormatDateTime( 'dd"/"mm"/"yyyy', DataHoraLog ) + '";"' +
      FormatDateTime( 'ddd', DataHoraLog ) + '";"' +
      FormatDateTime( 'hh":"mm":"ss', DataHoraLog ) + '";"' +
      frmLogin.edtUsuario.Text + '";"' +
      'Windows Intel' + '";"' +
      'Desktop' + '";"' +
      'Ip ' + IPAcessoInternet + '";"' +
      LocalAcessoInternet + '";"' +
      LinhaDescritiva + '"' );
  finally
    CloseFile( Arquivo );
  end;
end;

procedure EsperarSegundos(
  Segundos: Double;
  ExecutarComutandoParaCursorDeEspera: Boolean );
var
  Tempo: TDateTime;
  CursorAnterior: TCursor;
begin
  CursorAnterior := Screen.Cursor;

  if ExecutarComutandoParaCursorDeEspera then
    Screen.Cursor := crHourGlass;

  Tempo := Now;
  Segundos := Segundos / SecsPerDay;
  repeat
    Application.ProcessMessages;
  until ( ( Now - Tempo ) >= Segundos );

  Screen.Cursor := CursorAnterior;
end;

procedure ExportarQuickReportComoPdf(
  QuickRep: TQuickRep; const aFileName: TFileName; JaEstaPreparado: Boolean );
var
  Pdf: TPdfDocument;
  aMeta: TMetaFile;
  Cont: integer;
begin
  Pdf := TPdfDocument.Create;
  try
    Pdf.DefaultPaperSize := psA4;

    if ( Configuracao_Inicial_Listagem_Orientacao_Padrao = 0 ) then
      Pdf.DefaultPageLandscape := False
    else
      Pdf.DefaultPageLandscape := True;

    if not JaEstaPreparado then
      QuickRep.Prepare;
      
    for Cont := 1 to QuickRep.QRPrinter.PageCount do
    begin
      Pdf.AddPage;
      aMeta := QuickRep.QRPrinter.GetPage( Cont );
      try
        // Desenhar o Conteúdo de Uma Página Do QuickReport:
        Pdf.Canvas.RenderMetaFile( aMeta, 1, 0, 0 );
      finally
        aMeta.Free;
      end;
    end;
    Pdf.SaveToFile( aFileName );
  finally
    Pdf.free;
  end;
end;

function Criptografa(
  Entrada: String ): String;
var
  Cont, Ascii: Integer;
begin
  Result := '';
  for Cont := 1 to Length( Entrada ) do
  begin
    Ascii := ( 2 * Ord( Entrada[Cont] ) ) mod 255;
    Ascii := 255 - Ascii;
    if ( Ascii < 0 ) then
      Ascii := 255 + Ascii;
    Ascii := ( Ascii + 3 * ( Cont mod 7 ) ) mod 255;
    Result := Result + Chr( Ascii );
  end;
end;

function Descriptografa(
  Entrada: String ): String;
var
  Cont, Ascii: Integer;
begin
  Result := '';
  for Cont := 1 to Length( Entrada ) do
  begin
    Ascii := Ord( Entrada[Cont] );
    Ascii := Ascii - 3 * ( Cont mod 7 );
    while ( Ascii < 0 ) do
      Ascii := 255 + Ascii;
    if ( Ascii mod 2 = 0 ) then
      Ascii := Ascii div 2
    else
      Ascii := ( Ascii + 255 ) div 2;
    Ascii := 255 - Ascii;
    if ( Ascii < 0 ) then
      Ascii := 255 + Ascii;
    Result := Result + Chr( Ascii );
  end;
end;

function CriptografarDescriptografarSenhaUsandoChaveSimetrica(
    Criptografar: Boolean;
    TextoOrigem, ChaveSimetrica: String;
    var TextoOuChaveComCaracteresInvalidos: Boolean ): String;
var
  Cont, PosicaoTexto, PosicaoChave, PosicaoFinal: Integer;
const
  CaracteresValidos = 'ABCDEFGHIJLMNOPQRSTUVXZYWKabcdefghijlmnopqrstuvxzywk0123456789!@#$%~^&*()_-+=:<>?/\|';
begin
  Result := '';
  TextoOuChaveComCaracteresInvalidos := False;
  for Cont := 1 to Length( TextoOrigem ) do
  begin
    PosicaoTexto := Pos( TextoOrigem[ Cont ], CaracteresValidos );
    if ( PosicaoTexto = 0 ) then
    begin
      TextoOuChaveComCaracteresInvalidos := True;
      Result := '';
      Break;
    end;

    PosicaoChave := ( Cont - 1 ) mod Length( ChaveSimetrica ) + 1;
    PosicaoChave := Pos( ChaveSimetrica[ PosicaoChave ], CaracteresValidos );

    if ( PosicaoChave = 0 ) then
    begin
      TextoOuChaveComCaracteresInvalidos := True;
      Result := '';
      Break;
    end;

    if Criptografar then
      PosicaoFinal := PosicaoTexto + PosicaoChave
    else
    begin
      PosicaoFinal := PosicaoTexto - PosicaoChave;
      if ( PosicaoFinal < 0 ) then
        PosicaoFinal := PosicaoFinal + Length( CaracteresValidos );
    end;
    PosicaoFinal := ( ( PosicaoFinal - 1 ) mod Length( CaracteresValidos ) ) + 1;

    Result := Result + CaracteresValidos[ PosicaoFinal ];
  end;
end;

{Função Destinada a Calcular Uma Chave Hash De Data Cujo Algoritmo Consiste Em Receber Uma Data Qualquer,
 Então Multiplicar o Número Do Dia Desta Data Pelo Número Do Mes Pelo Número Do Ano (Inclusive o Século).
 O Resultado é Formatado Com Seis Dígitos, Eventualmente Preenchido Com Zeros a Esquerda. E a Sequência
 De Dígitos Resultantes é Invertida Ao Final. Exemplo: Digamos Que a Data Recebida Seja 03/05/1996. Assim,
 03 * 05 * 1996 é Igual a 029940. Invertendo Fica 049920 Que é a Chave Hash Desta Data Que Será Retornada.
 Como Esta Função de Hash Trabalha Com Seis Dígitos, o Ano Limite Das Datas a Aplicar Vai Até 2.688
 ( Int( 999999 / 12 / 31 ) = 2.688 ). O Propósito Desta Função é Fornecer Suporte a Mecanismos Secretos,
 Por Exemplo, Destinados a Abertura de Senhas Esquecidas, Por Meio da Digitação de Um Código de Emergência,
 Mas Que Seja Dinâmico e Que Não Valha o Mesmo Para Todas as Ocasiões}
function ChaveHashDeData(
  Data: TDate ): String;
var
  HashOriginal: String;
  Cont: Integer;
begin
  Result := '';
  HashOriginal := FormatarInteiroComZerosEsquerda( DayOf( Data ) * MonthOf( Data ) * YearOf( Data ), 6 );
  for Cont := 6 downto 1 do
    Result := Result + HashOriginal[Cont];
end;

function CapsLockLigado: Boolean;
begin
  Result := ( GetKeyState( VK_CAPITAL ) = 1 );
end;

function NumsLockLigado: Boolean;
begin
  Result := ( GetKeyState( VK_NUMLOCK ) = 1 );
end;

procedure SetarComponentesWebBrowserDestaAplicacaoComPadraoEmulacaoInternetExplorer11;
const
  RotaDaChaveDeRegistro32 = 'Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION';
  RotaDaChaveDeRegistro64 = 'Software\Wow6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION';
var
  Registro: TRegistry;
  Valor: LongInt;
  NomeDoPrograma: String;
begin
  NomeDoPrograma := ExtractFileName(Application.ExeName);
  Valor := 11001;   // Valor Equivalente a Assumir Padrão de Emulação do Internet Explorer Versão 11 Ou Posterior "Edge"

  Registro := Nil;
  try
    Registro := TRegistry.Create;
    Registro.RootKey := HKEY_CURRENT_USER;
    if ( Registro.OpenKey( RotaDaChaveDeRegistro32, True ) ) then
    begin
      Registro.WriteInteger( NomeDoPrograma, Valor );
      Registro.CloseKey;
    end;
  except
    {Nada}
  end;

  if ( Assigned( Registro )) then
   FreeAndNil( Registro );

  try
    Registro := TRegistry.Create;
    Registro.RootKey := HKEY_CURRENT_USER;
    if ( Registro.OpenKey( RotaDaChaveDeRegistro64, True ) ) then
    begin
      Registro.WriteInteger( NomeDoPrograma, Valor );
      Registro.CloseKey;
    end;
  except
    {Nada}
  end;

  if ( Assigned( Registro )) then
   FreeAndNil( Registro );
end;

function Now_EstaComHorarioDeVeraoAtivo: Boolean;
const
   Time_Zone_ID_Standard = 1;
   Time_Zone_ID_DayLight = 2;
var
  TimeZoneInfo: TTimeZoneInformation;
begin
  Result := GetTimeZoneInformation( TimeZoneInfo ) = Time_Zone_ID_DayLight;
end;

function Now_NoFusoHorarioOficialDoBrasilEmBrasilia: TDateTime;
const
  DiferencaHorasBrasilBrasiliaGMT = - 3;
var
  TimeZone: TTimeZoneInformation;
  DiferencaHorasAplicar: Integer;
begin
  {Pegar Data e Hora do Computador / Servidor Que Está Executando Este Programa:}
  Result := Now;

  {Pegar o Fuso Horário Local Que Está Setado Neste Computador / Servidor:}
  GetTimeZoneInformation( TimeZone );

  {Descontar a Diferença do Fuso Horário Local Do Computador Servidor Em Relação ao
   Horário Oficial do Brasil em Brasilia e Retornar o Resultado:}
  DiferencaHorasAplicar := ( TimeZone.Bias div - 60 ) - DiferencaHorasBrasilBrasiliaGMT;
  Result := Result - DiferencaHorasAplicar / HoursPerDay;

  {Se o Computador Que Estiver Executando Esta Aplicação Estiver Em Horário de Verão,
   Então Volta Uma Hora Para Trás, Para Descontar a Hora a Mais Adiantada:}
  if Now_EstaComHorarioDeVeraoAtivo then
    Result := Result - 1 / HoursPerDay;
end;

function MouseEstaPosicionadoSobreUmControleVisualComBotaoEsquerdoPressionado( Controle: TControl ): Boolean;
begin
  Result :=
    PtInRect( Controle.ClientRect, Controle.ScreenToClient( Mouse.CursorPos ) ) and
    ( GetKeyState( VK_LBUTTON ) < 0 );
end;

function LastPos( Substr: String; S: String ): Integer;
var
  i: Integer;
begin
  Result := 0;
  i := Length( S ) - Length( Substr ) + 1;
  while ( ( Result = 0 ) and ( i > 0 ) ) do
  begin
    if Copy( S, i, Length( Substr ) ) = Substr then
      Result := i
    else
      i := i - 1;
  end;
end;

function NomePastaPaiDeUmaRotaDeNomeArquivo( NomePasta: String ): String;
var
  Posicao: Integer;
begin
  Result := '';

  NomePasta := Trim( NomePasta );
  if ( NomePasta[ Length( NomePasta ) ] <> '\' ) then
    NomePasta := ExtractFilePath( NomePasta );

  NomePasta := ExcludeTrailingPathDelimiter( NomePasta );
  Posicao := LastPos( '\', NomePasta );
  if ( Posicao > 0 ) then
    Result := LeftStr( NomePasta, Posicao );
end;

end.

