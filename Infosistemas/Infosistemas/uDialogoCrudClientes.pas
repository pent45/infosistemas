unit uDialogoCrudClientes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, DBXpress, DB, SqlExpr, VrControls, VrLabel,
  Buttons, CommCtrl, FMTBcd, DBClient, Provider, Grids, DBGrids, StdCtrls,
  ImgList, Mask, DBCtrls, uRotinasGerais, Jpeg, PngImage, GIFImage, ExtDlgs,
  OleCtrls, SHDocVw;

const
  NomeTabelaOperadaPeloCrud                                             = 'TAB_CLIENTES';

  NomeCampoLogicoOrdenacaoInicial                                       = 'NOME';
  NomeCampoLogicoChavePrimaria                                          = 'CPF';

  NomeCampoLogicoBlobContendoFoto                                       = 'FOTO';

  CorGridCrudTitulo                                                     = clYellow;
  CorGridCrudCorpo                                                      = clCream;
  CorCelulaSelecionada                                                  = clGold;

  CorFundoRotuloLabelFicha                                              = clLightSteelBlue;
  CorFonteRotuloLabelFicha                                              = clBlack;

  URLConsultaPontosDetranMG                                             =
    'https://www.detran.mg.gov.br/habilitacao/cnh-e-permissao-para-dirigir/consulta-pontuacao';

  QtdCadastosRedesenharAcompanhamentoBarraProgressoExportacaoCSV        = 10;
  QtdCadastosRedesenharAcompanhamentoBarraProgressoConsultarDetran      = 01;

type
  {O Componente TPageControl Utilizado Neste Form, Mesmo Quando Tem Suas "Tabs"
   Invis�veis, Apresenta Uma Borda de 04 Pixels Que N�o Lhe Confere Um Aspecto "Flat"
   Perfeito. Assim, Realiza a Captura do Evento de Redimensionamento da Sua Classe de
   Origem Para Corrigir o Seu Aspecto Final Quando For Necess�rio:}
  TPageControl = class( ComCtrls.TPageControl )
  private
    procedure TCMAdjustRect( var Msg: TMessage ); message TCM_ADJUSTRECT;
  end;

  TPontuacaoCNH =
  (
    pcNaoTemPontuacao,
    pcSimTemPontuacao,
    pcIncertoQuantoPontuacao
  );

  TfrmDialogoCrudClientes = class(TForm)
    pnlDialogoCrudFundo: TPanel;
    pnlDireito: TPanel;
    sqlConexaoCrud: TSQLConnection;
    pnlEsquerdo: TPanel;
    spdSair: TSpeedButton;
    qryQueryCrud: TSQLQuery;
    dspDataSetCrud: TDataSetProvider;
    cdsClientDataSetCrud: TClientDataSet;
    dtrDataSourceCrud: TDataSource;
    cdsClientDataSetCrudNOME: TStringField;
    cdsClientDataSetCrudAREA: TStringField;
    cdsClientDataSetCrudFUNCAO: TStringField;
    cdsClientDataSetCrudCNH: TStringField;
    cdsClientDataSetCrudDTANASC: TSQLTimeStampField;
    cdsClientDataSetCrudDTAPRIMEIRACNH: TSQLTimeStampField;
    cdsClientDataSetCrudCPF: TStringField;
    cdsClientDataSetCrudCATEGORIA: TStringField;
    cdsClientDataSetCrudREMUNERADA: TStringField;
    cdsClientDataSetCrudABREVIATURAS: TStringField;
    cdsClientDataSetCrudHABCOLETIVASESTSENAT: TStringField;
    cdsClientDataSetCrudDTAULTREVISAO: TSQLTimeStampField;
    cdsClientDataSetCrudDTAVECTOCNH: TSQLTimeStampField;
    cdsClientDataSetCrudDIGITALIZACAO: TStringField;
    lblVoltar: TLabel;
    lblNovo: TLabel;
    lblRemover: TLabel;
    imlImagensOrdenacao: TImageList;
    lblRelatorio: TLabel;
    lblCatalogo: TLabel;
    lblZoom: TLabel;
    cdsClientDataSetCrudSEXO: TStringField;
    cdsClientDataSetCrudFOTO: TBlobField;
    opdSelecionarFoto: TOpenPictureDialog;
    sdgExportarCSV: TSaveDialog;
    odgSelecionarFoto: TSavePictureDialog;
    cdsClientDataSetCrudPONTUACAO: TStringField;
    pgcPaginas: TPageControl;
    tshTabelaComTodos: TTabSheet;
    pnlTabelaComTodos: TPanel;
    pnlGridEsquerdo: TPanel;
    spdRegistroInicial: TSpeedButton;
    spdRegistroAnterior: TSpeedButton;
    spdRegistroSeguinte: TSpeedButton;
    spdRegistroFinal: TSpeedButton;
    pnlGridDireito: TPanel;
    pnlGridCentral: TPanel;
    pnlGridSuperior: TPanel;
    imgGridSuperior: TImage;
    pnlBusca: TPanel;
    spdBusca: TSpeedButton;
    lblTituloCrud: TVrLabel;
    cbxBusca: TComboBox;
    dbgGridCrud: TDBGrid;
    pnlGridInferior: TPanel;
    lblQuantidadeCadastros: TLabel;
    tshFichaComUm: TTabSheet;
    pnlFichaComUm: TPanel;
    scbFichaCrud: TScrollBox;
    lblNome: TLabel;
    lblArea: TLabel;
    lblFuncao: TLabel;
    lblCNH: TLabel;
    lblDataDeNascimento: TLabel;
    lblCPF: TLabel;
    lblSexo: TLabel;
    spdEscolherFoto: TSpeedButton;
    spdLimparFoto: TSpeedButton;
    spdExpandirReduzirFoto: TSpeedButton;
    spdRodar90GrausDireita: TSpeedButton;
    dbeNome: TDBEdit;
    dbeCNH: TDBEdit;
    dtpDataDeNascimento: TDateTimePicker;
    dbeDataDeNascimento: TDBEdit;
    dbeCPF: TDBEdit;
    dbcArea: TDBComboBox;
    dbcFuncao: TDBComboBox;
    dbcSexo: TDBComboBox;
    pnlFoto: TPanel;
    imgFoto: TImage;
    lblNomeClienteFichaComUm: TVrLabel;
    spdRecuperarFoto: TSpeedButton;
    pnlFichaDireito: TPanel;
    pnlFichaEsquerdo: TPanel;
    SavePictureDialog1: TSavePictureDialog;
    lblEnderecoNumero: TLabel;
    lblEnderecoLogradouro: TLabel;
    lblEnderecoBairro: TLabel;
    dbeEnderecoCEP: TDBEdit;
    lblEnderecoCEP: TLabel;
    lblEnderecoMunicipio: TLabel;
    lblEnderecoUF: TLabel;
    lblTelefoneMovel: TLabel;
    dbeTelefoneMovel: TDBEdit;
    dbeTelefoneFixo: TDBEdit;
    lblTelefoneFixo: TLabel;
    lblEnderecoComplemento: TLabel;
    lblEmail: TLabel;
    dbeEnderecoLogradouro: TDBEdit;
    dbeEnderecoNumero: TDBEdit;
    dbeEnderecoComplemento: TDBEdit;
    dbcEnderecoUF: TDBComboBox;
    dbcEnderecoMunicipio: TDBComboBox;
    dbeEmail: TDBEdit;
    spdConsultarCEP: TSpeedButton;
    cdsClientDataSetCrudENDERECOLOGRADOURO: TStringField;
    cdsClientDataSetCrudENDERECONUMERO: TStringField;
    cdsClientDataSetCrudENDERECOCOMPLEMENTO: TStringField;
    cdsClientDataSetCrudENDERECOBAIRRO: TStringField;
    cdsClientDataSetCrudENDERECOCEP: TStringField;
    cdsClientDataSetCrudENDERECOMUNICIPIO: TStringField;
    cdsClientDataSetCrudENDERECOUP: TStringField;
    cdsClientDataSetCrudTELEFONEFIXO: TStringField;
    cdsClientDataSetCrudTELEFONEMOVEL: TStringField;
    cdsClientDataSetCrudEMAIL: TStringField;
    dbcEnderecoBairro: TDBComboBox;
    dbrAnotacoes: TDBRichEdit;
    cdsClientDataSetCrudANOTACOES: TBlobField;
    lblAnotacoes: TLabel;
    lblMensagemSobreComoLimparRapidamenteUmCampo: TLabel;
    lblControles: TLabel;
    lblEmailXML: TLabel;

    function ValidarCampoCPFDigitadoEmDBEdit(
      var dbeCampoCPF: TDBEdit;
      const PermitirVazio: Boolean;
      const InformarObrigarDigitacaoCorreta: Boolean ): Boolean;
    function ValidarCampoNaoVazioDigitadoEmDBEdit(
      var dbeCampoNaoVazio: TDBEdit;
      const InformarObrigarDigitacaoCorreta: Boolean ): Boolean;
    function ValidarCampoNaoDuplicavelDigitadoEmDBEdit(
      var dbeCampoNaoDuplicavel: TDBEdit;
      const InformarObrigarDigitacaoCorreta: Boolean ): Boolean;

    function ValidarCampoCPFDigitadoEmTabela(
      NomeDoCampo: String ): Boolean;
    function ValidarCampoNaoVazioDigitadoEmTabela(
      NomeDoCampo: String ): Boolean;
    function ValidarCampoNaoDuplicavelDigitadoEmTabela(
      NomeDoCampo: String ): Boolean;
    function ValidarCampoSexoDigitadoEmTabela(
      NomeDoCampo: String ): Boolean;

    procedure ValidarDataRecemDigitadaSejaEmDBEditOuTabela_cdsClientDataSetCrudSetText(
      Sender: TField; const Text: String );
    procedure PrepararMascaraDeEdicaoValidacaoCamposContendoDataCalendario(
      var ClientDataSetCrud: TClientDataSet );

    procedure AbrirTabelaCrud(
      const OrdenacaoCampo: String;
      const OrdenacaoDescendente: Boolean );
    function CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar: Boolean;
    procedure spdSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AtualizarQuantidadeCadastrosEFotos;
    procedure AtualizarBotoesDeNavegacao;
    procedure SetarEstadoMenuDeControles(
      Opcao: TLabel );
    procedure lblPrimeiroMouseLeave(Sender: TObject);
    procedure lblPrimeiroMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure lblVoltarClick(Sender: TObject);
    procedure dbgGridCrudDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgGridCrudTitleClick(Column: TColumn);
    procedure dbgGridCrudKeyPress(Sender: TObject; var Key: Char);
    procedure dbgGridCrudKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cdsClientDataSetCrudAfterPost(DataSet: TDataSet);
    procedure lblRemoverClick(Sender: TObject);
    function TabelaPossuiAoMenosUmRegistroEInformarUsuarioSeNao(
      var ClientDataSetCrud: TClientDataSet ): Boolean;

    function VerificarExistenciaRegistrosDuplicados(
      NomeTabela: String;
      CampoIdentificador: String;
      ConteudoCampoIdentificador: String ): Boolean;
    function EliminarRegistrosComConteudoTotalmenteDuplicadoDeixandoApenasUm(
      NomeTabela: String;
      var ClientDataSetCrud: TClientDataSet ): Boolean;

    procedure AplicarAtualizacoesPostadasRemovendoDuplicacoesIdenticas;
    procedure spdBuscaClick(Sender: TObject);
    procedure cbxBuscaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lblRelatorioClick(Sender: TObject);
    procedure lblCatalogoClick(Sender: TObject);
    procedure PreverRelatorioCrudClientes;
    procedure PreverRelatorioCrudClientesComFotos;
    procedure imgGridSuperiorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblZoomClick(Sender: TObject);
    procedure ComutarPaginasEntreTabelaComTodosFichaComUm(
      PaginaDesejada: TTabSheet );
    procedure dtpDataDeNascimentoChange(Sender: TObject);
    procedure dtpDataDeNascimentoEnter(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AbrirCalendarioQueApoiaDBEditContendoData(
      dbeDBEdit: TDBEdit;
      dtpCalendario: TDateTimePicker );
    procedure MudouCalendarioQueApoiaDBEditContendoData(
      dbeDBEdit: TDBEdit;
      dtpCalendario: TDateTimePicker );
    procedure AbrirComboComOpcoesJaCadastradasEmUmaTabelaECampo(
      var dbcCombo: TDBComboBox;
      const NomeTabela: String;
      const NomeCampo: String;
      InserirBrancoComoPrimeiraOpcao: Boolean );
    procedure dbcAreaDropDown(Sender: TObject);
    procedure dbcFuncaoDropDown(Sender: TObject);
    procedure dbeNomeEnter(Sender: TObject);
    procedure dbeCPFExit(Sender: TObject);
    procedure dbgGridCrudDblClick(Sender: TObject);
    procedure scbFichaCrudDblClick(Sender: TObject);
    procedure lblNovoClick(Sender: TObject);
    procedure dbeNomeExit(Sender: TObject);
    procedure dbeCNHExit(Sender: TObject);
    procedure cdsClientDataSetCrudBeforeEdit(DataSet: TDataSet);
    procedure cdsClientDataSetCrudBeforePost(DataSet: TDataSet);
    procedure cdsClientDataSetCrudAfterCancel(DataSet: TDataSet);
    procedure spdRegistroInicialClick(Sender: TObject);
    procedure spdRegistroAnteriorClick(Sender: TObject);
    procedure spdRegistroSeguinteClick(Sender: TObject);
    procedure spdRegistroFinalClick(Sender: TObject);
    function GravarImagemGraphicContidaEmArquivoOuTImageComDestinoAUmCampoBlob(
      var ClientDataSet: TClientDataSet;
      NomeDoCampoBlob: String;
      NomeCompletoArquivoContendoImagem: String;
      const ImagemOrigem: TImage ): Boolean;
    procedure LerImagemContidaCampoBlobParaJPegComAvatarGenericoSeForNecessario(
      var ClientDataSet: TClientDataSet;
      NomeDoCampoBlob: String;
      SexoParaAvatarGenericoSePrecisar: String;
      var JPegDestino: TJPegImage );
    procedure LerImagemContidaCampoBlobParaTImageComAvatarGenericoSeForNecessario(
      var ClientDataSet: TClientDataSet;
      NomeDoCampoBlob: String;
      SexoParaAvatarGenericoSePrecisar: String;
      var ImagemDestino: TImage );
    procedure cdsClientDataSetCrudAfterScroll(DataSet: TDataSet);
    procedure dbcSexoChange(Sender: TObject);
    procedure spdEscolherFotoClick(Sender: TObject);
    procedure spdLimparFotoClick(Sender: TObject);
    procedure imgFotoClick(Sender: TObject);
    procedure ReduzirFotoSeEstiverExpandida;
    procedure spdExpandirReduzirFotoClick(Sender: TObject);
    procedure spdRodar90GrausDireitaClick(Sender: TObject);
    procedure MostarOuEsconderOpcoesDoMenuPainelEsquerdo(
      Mostrar: Boolean );
    function CalcularTempoRestante(
      TempoInicial, TempoAtual: TDateTime;
      ContadorAtual, ContadorTotal: Integer ): String;
    procedure spdCancelarExportacaoCSVClick(Sender: TObject);
    procedure spdRecuperarFotoClick(Sender: TObject);
    function ConsultaPontuacaoCondutor_DetranMG_SiteEm_21_09_2019(
      WebBrowser: TwebBrowser;
      TipoCNHNova: Boolean;
      NumeroDeRegistroCNH: String;
      DataDeNascimento: String;
      DataDaPrimeiraHabilitacao: String ): TPontuacaoCNH;
    procedure dbcEnderecoBairroDropDown(Sender: TObject);
    procedure dbcEnderecoMunicipioDropDown(Sender: TObject);
    procedure spdConsultarCEPClick(Sender: TObject);
    procedure dbeEnderecoCEPExit(Sender: TObject);
    procedure dbrAnotacoesEnter(Sender: TObject);
    procedure dbrAnotacoesExit(Sender: TObject);
    procedure ColocarEmEstadoDeEdicaoSeJaNaoEstiver;
    procedure FormActivate(Sender: TObject);
    procedure dbrAnotacoesDblClick(Sender: TObject);
    procedure lblEmailXMLClick(Sender: TObject);
  public
    { Public declarations }
    Resultado: TModalResult;
    OrdenacaoCampo: String;
    OrdenacaoDescendente: Boolean;
    OrdenacaoDesenhouMarcadorSobreColunas: Boolean;
    MarcadorPosicaoRegistroAntesInserirNovoParaVoltarCasoCancele: TBookmark;
    AbortouExportacaoCSV, AbortouConsultaDetran: Boolean;
    EstaEmProcessamentoDeTodosOsCadastros: Boolean;

    EdicaoNaPaginaTabelaComTodos_NomeCampo: String;
    EdicaoNaPaginaTabelaComTodos_MotivoCancelamento: String;
    EdicaoNaPaginaTabelaComTodos_HouveErroPrevioValidacao: Boolean;
  end;

var
  frmDialogoCrudClientes: TfrmDialogoCrudClientes;

implementation

{$R *.dfm}

uses
  Printers, uPrincipal, uRotinasFiltrosImagens, uRotinasBancoDados,
  uImprimirRelatorioCrudClientes, uImprimirPrevisaoImpressao,
  StrUtils, SqlTimSt, uAguarde, uImprimirRelatorioCrudClientesComFotos,
  uLkJSON, IdMessage, XMLDoc, XMLIntf;

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

function TfrmDialogoCrudClientes.ValidarCampoCPFDigitadoEmDBEdit(
  var dbeCampoCPF: TDBEdit;
  const PermitirVazio: Boolean;
  const InformarObrigarDigitacaoCorreta: Boolean ): Boolean;
var
  ApenasNumerosCPF: String;
begin
  Result := True;

  ApenasNumerosCPF := Trim( dbeCPF.Text );
  RemoverNaoNumericos( ApenasNumerosCPF );

  if ( ( PermitirVazio ) and
       ( Trim( ApenasNumerosCPF ) = '' ) ) then
    Exit;

  Result := Checar_Cpf( ApenasNumerosCPF );

  if Result then
  begin
    dbeCampoCPF.Text := Formatar_Cpf( ApenasNumerosCPF );
  end
  else
  begin
    if InformarObrigarDigitacaoCorreta then
    begin
      frmPrincipal.AcionarFormProsseguir(
        'O CPF Digitado' + RetornoDeCarro( 02 ) +
        dbeCPF.Text + RetornoDeCarro( 02 ) +
        'Est� Com Erro e N�o Confere Com Os Seus D�gitos De Verifica��o.' + RetornoDeCarro( 02 ) +
        'Por Favor, Verifique Este CPF e Digite Corretamente.',
        '',
        '',
        'Prosseguir',
        False );

      dbeCampoCPF.SetFocus;
    end;
  end;
end;

function TfrmDialogoCrudClientes.ValidarCampoNaoVazioDigitadoEmDBEdit(
  var dbeCampoNaoVazio: TDBEdit;
  const InformarObrigarDigitacaoCorreta: Boolean ): Boolean;
begin
  Result := ( Trim( dbeCampoNaoVazio.Text ) <> '' );

  if ( ( not Result ) and
       ( InformarObrigarDigitacaoCorreta ) ) then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'O Conte�do Do Campo' + RetornoDeCarro( 02 ) +
      '"' + dbeCampoNaoVazio.Field.DisplayName + '"' + RetornoDeCarro( 02 ) +
      'N�o Pode Ficar Vazio.' + RetornoDeCarro( 02 ) +
      'Por Favor, Verifique o Campo e Digite Corretamente.',
      '',
      '',
      'Prosseguir',
      False );

    dbeCampoNaoVazio.SetFocus;
  end;
end;

function TfrmDialogoCrudClientes.ValidarCampoNaoDuplicavelDigitadoEmDBEdit(
  var dbeCampoNaoDuplicavel: TDBEdit;
  const InformarObrigarDigitacaoCorreta: Boolean ): Boolean;
var
  Query: TSQLQuery;
  Procurar, IdentificadorDoProprioRegistroAtual: String;
begin
  Result := True;

  Procurar :=
    Trim( dbeCampoNaoDuplicavel.Text );
  IdentificadorDoProprioRegistroAtual :=
    dbeCampoNaoDuplicavel.DataSource.DataSet.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString;

  if ( Procurar <> '' ) then
  begin
    Query := TSQLQuery.Create( Self );
    Query.SQLConnection := sqlConexaoCrud;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add( 'SELECT FIRST 1' );
    Query.SQL.Add( '  ' + NomeCampoLogicoOrdenacaoInicial );
    Query.SQL.Add( 'FROM' );
    Query.SQL.Add( '  ' + NomeTabelaOperadaPeloCrud );
    Query.SQL.Add( 'WHERE' );
    Query.SQL.Add( '  ( ' + dbeCampoNaoDuplicavel.Field.FieldName + ' = "'  + Procurar                            + '" ) AND' );
    Query.SQL.Add( '  ( ' + NomeCampoLogicoOrdenacaoInicial       + ' <> "' + IdentificadorDoProprioRegistroAtual + '" )' );
    Query.SQL.Add( 'ORDER BY' );
    Query.SQL.Add( '  ' + NomeCampoLogicoOrdenacaoInicial );
    Query.Open;

    Query.First;
    Result := ( Query.Eof );

    if ( ( not Result ) and
         ( InformarObrigarDigitacaoCorreta ) ) then
    begin
      frmPrincipal.AcionarFormProsseguir(
        'O Conte�do Do Campo' + RetornoDeCarro( 02 ) +
        '"' + dbeCampoNaoDuplicavel.Field.DisplayName + '"' + RetornoDeCarro( 02 ) +
        'Preenchido Com o Valor' + RetornoDeCarro( 02 ) +
        '"' + Procurar + '"' + RetornoDeCarro( 02 ) +
        'J� Existe Em Pelo Menos Um Outro Cadastro:' + RetornoDeCarro( 02 ) +
        '"' + Query.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString + '"' + RetornoDeCarro( 02 ) +
        'Por Favor, Verifique o Campo e Digite Corretamente.',
        '',
        '',
        'Prosseguir',
        False );

      dbeCampoNaoDuplicavel.SetFocus;
    end;

    Query.Close;
    Query.Free;
  end;
end;

function TfrmDialogoCrudClientes.ValidarCampoCPFDigitadoEmTabela(
  NomeDoCampo: String ): Boolean;
var
  ApenasNumerosCPF: String;
begin
  ApenasNumerosCPF := Trim( cdsClientDataSetCrud.FieldByName( NomeDoCampo ).AsString );
  RemoverNaoNumericos( ApenasNumerosCPF );

  Result := ( Trim( ApenasNumerosCPF ) = '' );

  if not Result then
  begin
    Result := Checar_Cpf( ApenasNumerosCPF );

    cdsClientDataSetCrud.FieldByName( NomeDoCampo ).AsString := Formatar_Cpf( ApenasNumerosCPF );
  end;
end;

function TfrmDialogoCrudClientes.ValidarCampoNaoVazioDigitadoEmTabela(
  NomeDoCampo: String ):  Boolean;
begin
  Result := ( Trim( cdsClientDataSetCrud.FieldByName( NomeDoCampo ).AsString ) <> '' );
end;

function TfrmDialogoCrudClientes.ValidarCampoNaoDuplicavelDigitadoEmTabela(
  NomeDoCampo: String ): Boolean;
var
  Query: TSQLQuery;
  Procurar, IdentificadorDoProprioRegistroAtual: String;
begin
  Result := True;

  Procurar :=
    cdsClientDataSetCrud.FieldByName( NomeDoCampo ).AsString;
  IdentificadorDoProprioRegistroAtual :=
    cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString;

  if ( Procurar <> '' ) then
  begin
    Query := TSQLQuery.Create( Self );
    Query.SQLConnection := sqlConexaoCrud;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.Add( 'SELECT FIRST 1' );
    Query.SQL.Add( '  ' + NomeCampoLogicoOrdenacaoInicial );
    Query.SQL.Add( 'FROM' );
    Query.SQL.Add( '  ' + NomeTabelaOperadaPeloCrud );
    Query.SQL.Add( 'WHERE' );
    Query.SQL.Add( '  ( ' + NomeDoCampo                     + ' = "'  + Procurar                            + '" ) AND' );
    Query.SQL.Add( '  ( ' + NomeCampoLogicoOrdenacaoInicial + ' <> "' + IdentificadorDoProprioRegistroAtual + '" )' );
    Query.SQL.Add( 'ORDER BY' );
    Query.SQL.Add( '  ' + NomeCampoLogicoOrdenacaoInicial );
    Query.Open;

    Query.First;
    Result := ( Query.Eof );

    Query.Close;
    Query.Free;
  end;
end;

function TfrmDialogoCrudClientes.ValidarCampoSexoDigitadoEmTabela(
  NomeDoCampo: String ): Boolean;
begin
  Result := False;

  if ( LeftStr( cdsClientDataSetCrud.FieldByName( NomeDoCampo ).AsString, 1 ) = 'M' ) then
  begin
    cdsClientDataSetCrud.FieldByName( NomeDoCampo ).AsString := 'MASCULINO';
    Result := True;
  end;

  if ( LeftStr( cdsClientDataSetCrud.FieldByName( NomeDoCampo ).AsString, 1 ) = 'F' ) then
  begin
    cdsClientDataSetCrud.FieldByName( NomeDoCampo ).AsString := 'FEMININO';
    Result := True;
  end;

  if Result then
    LerImagemContidaCampoBlobParaTImageComAvatarGenericoSeForNecessario(
      cdsClientDataSetCrud,
      NomeCampoLogicoBlobContendoFoto,
      cdsClientDataSetCrud.FieldByName( NomeDoCampo ).AsString,
      imgFoto );
end;

procedure TfrmDialogoCrudClientes.ValidarDataRecemDigitadaSejaEmDBEditOuTabela_cdsClientDataSetCrudSetText(
  Sender: TField; const Text: String);
var
  Value: SqlTimSt.TSQLTimeStamp;
begin
  {Este Procedimento � Muito �til Porque Valida a Digita��o De Um Campo Contendo Uma Data De
   Calend�rio, Independente De Que Esta Digita��o Seja Feira Diretamente Na Tabela Com Todos
   Os Registros  Ou Via Um "TDBEdit" Da Ficha Com Um �nico Cadastro. E a Valida��o � Imadiata,
   Antes De Qualquer Outra Provid�ncia.

   Acontece Que o "EditMask" Dos Campos De Data J� Assegura Que As Datas Sejam Digitadas Com
   Formato Correto, "!99/99/9999;1;_". Mas Isto N�o � Suficiente Porque o Usu�rio Pode Digitar,
   Mesmo Sob Formato Correto, Por Exemplo, Dia 40 Ou M�s 35 e Isto Ir� Provocar Uma Excess�o De
   Execu��o. O Uso Deste Proedimento Impede Este Problema e, Nestes Casos, Simplesmente Deixa o
   Campo De Data Calend�rio Com o Conte�do Vazio, Sem Provocar Excess�es De Execu��o.

   Para Seu Uso Efetivo, � Necess�rio Que Todos Os Campos Contendo Datas Calend�rio Existentes
   Na Tabela Do "Crud" Tenham Os Seus Eventos "OnSelText" Direcionados Para Este Procedimento.

   O Ideal � Que, No In�cio Da Execu��o, Os Campos Que Contiverem Datas Calend�rio Do Objeto
   "TClientDataSet", Por Exemplo, Dentro Do "cdsClientDataSetCrud" Sejam Varridos Com a Respectiva
   Setagen Da Propriedade "EditMask" Com "!99/99/9999;1;_" e Deste Presente Procedimento No Evento
   "OnSelText".}

  {Verificar Se a Data Digitada � Realmente V�lida. Neste Caso Ela Ficar� Como Digitada. Caso
   Contr�rio, Ela Retornar� Ao Valor Original Antes Da Digita��o Inv�lida:}
  if ( TryStrToSqlTimeStamp( Text, Value ) ) then
  begin
    {A Data � V�lida e Ficar� Como Digitada:}
    TSQLTimeStampField( Sender ).SetData( @Value, False )
  end;
end;

procedure TfrmDialogoCrudClientes.PrepararMascaraDeEdicaoValidacaoCamposContendoDataCalendario(
  var ClientDataSetCrud: TClientDataSet );
var
  ContadorCampos: Integer;
  CampoTipoDataCalendario: TSQLTimeStampField;
begin
  {Percorrer Todos Os Campos Da Tabela De "Crud" Preparando a M�scara De Edi��o e Valida��o
   Dos Campos Que Contenham Datas Calend�rio:}
  for ContadorCampos := 0 to ClientDataSetCrud.Fields.Count - 1 do
  begin
    if ( ( ClientDataSetCrud.Fields[ ContadorCampos ].FieldKind = fkData ) and
         ( ClientDataSetCrud.Fields[ ContadorCampos ] is TSQLTimeStampField ) ) then
    begin
      CampoTipoDataCalendario := TSQLTimeStampField( ClientDataSetCrud.Fields[ ContadorCampos ] );

      CampoTipoDataCalendario.EditMask  :=
        '!99/99/9999;1;_';
      CampoTipoDataCalendario.OnSetText :=
        ValidarDataRecemDigitadaSejaEmDBEditOuTabela_cdsClientDataSetCrudSetText;
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.AbrirTabelaCrud(
  const OrdenacaoCampo: String;
  const OrdenacaoDescendente: Boolean );
var
  ConteudoCampoChave: String;
begin
  {Preservar Refer�ncia Do Registro Atual Em Que Est�:}
  ConteudoCampoChave := cdsClientDataSetCrud.FieldByName( NomeCampoLogicoChavePrimaria ).AsString;

  {Abrir Tabela Do "Crud" Conforme Ordena��o Desejada:}

  cdsClientDataSetCrud.Close;
  qryQueryCrud.Close;

  qryQueryCrud.SQL.Clear;
  qryQueryCrud.SQL.Add( 'SELECT' );
  qryQueryCrud.SQL.Add( '  *' );
  qryQueryCrud.SQL.Add( 'FROM' );
  qryQueryCrud.SQL.Add( '  ' + NomeTabelaOperadaPeloCrud );
  qryQueryCrud.SQL.Add( 'ORDER BY' );
  if OrdenacaoDescendente then
    qryQueryCrud.SQL.Add( '  ' + OrdenacaoCampo + ' DESC' )
  else
    qryQueryCrud.SQL.Add( '  ' + OrdenacaoCampo );

  qryQueryCrud.Open;
  cdsClientDataSetCrud.Open;

  {Fazer Com Que Os Campos Cujo Conte�do Sejam Datas Calend�rio Tenham As Suas M�scaras
   De Edi��o e Valida��o Devidamente Configuradas:}
  PrepararMascaraDeEdicaoValidacaoCamposContendoDataCalendario(
    cdsClientDataSetCrud );

  {Restabelecer Refer�ncia Do Registro Em Que Estava:}
  cdsClientDataSetCrud.Locate( NomeCampoLogicoChavePrimaria, ConteudoCampoChave, [] );

  AtualizarBotoesDeNavegacao;
end;

function TfrmDialogoCrudClientes.CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar: Boolean;
begin
  Result := False;

  {Caso Esteja Em Edi��o Ou Inser��o, Fazer o Post Para Gravar:}
  if ( ( cdsClientDataSetCrud.State = dsEdit   ) or
       ( cdsClientDataSetCrud.State = dsInsert ) ) then
  begin
    cdsClientDataSetCrud.Post;
    Result := True;
  end;
end;

procedure TfrmDialogoCrudClientes.spdSairClick(Sender: TObject);
begin
  if EstaEmProcessamentoDeTodosOsCadastros then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'Para Poder Sair, Antes Ser� Necess�rio Aguardar a Completa' + RetornoDeCarro( 01 ) +
      'Execu��o Do Processo Em Andamento.' + RetornoDeCarro( 02 ) +
      'Tamb�m � Poss�vel Interromper Este Processo Para Que Se Possa' + RetornoDeCarro( 01 ) +
      'Ent�o Sair e o Deixando Para Fazer Novamente Depois.',
      '',
      '',
      'Prosseguir',
      False );
  end
  else
  begin
    {Caso Esteja Em Edi��o Ou Inser��o, Fazer o Post Para Gravar:}
    CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar;

    Resultado := mrYes;
    Close;
  end;
end;

procedure TfrmDialogoCrudClientes.FormCreate(Sender: TObject);
var
  NomeArquivoContendoBancoDeDados: String;
  ContColunas: Integer;

  procedure PintarRotulosCamposCalendariosFichaComUm;
  var
    ContadorControles: Integer;
    RotuloLabel: TLabel;
    Calendario: TDateTimePicker;
  begin
    for ContadorControles := 0 to scbFichaCrud.ControlCount - 1 do
    begin
      if ( scbFichaCrud.Controls[ ContadorControles ] is TLabel ) then
      begin
        RotuloLabel := TLabel( scbFichaCrud.Controls[ ContadorControles ] );

        if ( not RotuloLabel.ParentColor ) then
        begin
          RotuloLabel.Color := CorFundoRotuloLabelFicha;
          RotuloLabel.Font.Color := CorFonteRotuloLabelFicha;
          RotuloLabel.Font.Style := [ fsItalic, fsBold ];
        end;
      end;

      if ( scbFichaCrud.Controls[ ContadorControles ] is TDateTimePicker ) then
      begin
        Calendario := TDateTimePicker( scbFichaCrud.Controls[ ContadorControles ] );

        Calendario.CalColors.BackColor := dtpDataDeNascimento.Color;
        Calendario.CalColors.MonthBackColor := dtpDataDeNascimento.Color;
        Calendario.CalColors.TextColor := clBlack;
        Calendario.CalColors.TitleBackColor := lblDataDeNascimento.Color;
        Calendario.CalColors.TitleTextColor := clBlack;
        Calendario.CalColors.TrailingTextColor := dtpDataDeNascimento.Font.Color;
      end;
    end;
  end;

begin
  Resultado := mrCancel;

  {Definir Cores, Posi��es e Dimens�es Dos Elementos Do "Form":}
  pnlDialogoCrudFundo.Color := CorParteSuperiorFormsDialogoComuns;
  pnlDialogoCrudFundo.Color := CorParteSuperiorFormsDialogoComuns;
  pnlDireito.Color := pnlDialogoCrudFundo.Color;
  pnlEsquerdo.Color := pnlDialogoCrudFundo.Color;
  lblTituloCrud.Color := pnlDialogoCrudFundo.Color;
  scbFichaCrud.Color :=  pnlDialogoCrudFundo.Color;
  dbgGridCrud.Color := CorGridCrudCorpo;
  dbgGridCrud.FixedColor := pnlDialogoCrudFundo.Color;
  lblNomeClienteFichaComUm.Color := pnlDialogoCrudFundo.Color;

  lblNomeClienteFichaComUm.Left := imgFoto.Left + imgFoto.Width + 8;
  lblNomeClienteFichaComUm.Caption := '';

  {Definir Cores Dos T�tulos Do Grid De Registros Do "Crud":}
  for ContColunas := 0 to dbgGridCrud.Columns.Count - 1 do
    dbgGridCrud.Columns.Items[ ContColunas ].Title.Color := CorGridCrudTitulo;

  {Linhas Estranhas Abaixo, Com Duplica��o Da Setagem Da Active Page Para o Mapa Pais Shape,
   Antes e Ao Final Do Bloco, Destina-Se a Impedir Problemas de Execu��o Que Podem Ocorrer
   Quando, Ainda Em Tempo De Desenvolvimento, o Programa � Compilado Tendo Sido Deixada Como
   P�gina Inicial Default Alguma Outra Que N�o Seja a Pr�pria De Mapa Pais Shape, Que Ocorre
   Devido a Setagem Das Abas Das Pag�nas Para Invis�veis Em Tempo de Execu��o:}
  pgcPaginas.ActivePage := tshTabelaComTodos;
  tshTabelaComTodos.TabVisible := False;
  tshFichaComUm.TabVisible := False;
  pgcPaginas.ActivePage := tshTabelaComTodos;

  {Padronizar Cores Componentes Da Ficha De Cadastro:}
  PintarRotulosCamposCalendariosFichaComUm;

  {Conferir o Nome Do Arquivo Que Conter� o Banco De Dados:}
  NomeArquivoContendoBancoDeDados :=
    Trim( ExtractFilePath( Application.ExeName ) ) +
    'Operacao\Dados_Sistema\BD_INFOSISTEMAS.GDB';
  if not FileExists( NomeArquivoContendoBancoDeDados ) then
    frmPrincipal.ConverterNomeCompletoArquivoOperacaoParaOperacaoShared( NomeArquivoContendoBancoDeDados );

  if ( ConectarQueryParaEdicaoBidirecionalBancoDados_IB_FB(
         NomeArquivoContendoBancoDeDados,
         UsuarioBancoDados,
         SenhaBancoDados,
         sqlConexaoCrud,
         qryQueryCrud,
         dspDataSetCrud,
         cdsClientDataSetCrud,
         dtrDataSourceCrud ) ) then
  begin
    {Definir Forma De Ordena��o Inicial Da Tabela Do "Crud":}
    OrdenacaoCampo := NomeCampoLogicoOrdenacaoInicial;
    OrdenacaoDescendente := False;

    {Preparar e Abrir a Query Que Ser� Usada Para o "Crud":}
    AbrirTabelaCrud(
      OrdenacaoCampo,
      OrdenacaoDescendente );

    AtualizarQuantidadeCadastrosEFotos;
  end;

  {Inicializar Mecanismo Que Permite Editar e Validar Edi��es Na Pr�pria Tabela Com
   Todos Os Registros:}
  EdicaoNaPaginaTabelaComTodos_NomeCampo                := '';
  EdicaoNaPaginaTabelaComTodos_MotivoCancelamento       := '';

  {Durante Processamentos Que Envolvem Todos Os Registros, Isto �, Durante A��es Que N�o
   S�o Instant�neas, Para Evitar a Sa�da Inesperada Do "Form", H� Um Mecanismo Que Controla
   O Acionamento Do Controle De Sa�da Deste "Form" e Que Aqui � Inicializado Abaixo:}
  EstaEmProcessamentoDeTodosOsCadastros := False;
end;

procedure TfrmDialogoCrudClientes.AtualizarQuantidadeCadastrosEFotos;
var
  Query: TSQLQuery;
  QuantidadeTotalDeCadastros, QuantidadeTotalDeCadastrosComFotos: Integer;
begin
  Query := TSQLQuery.Create( Self );
  Query.SQLConnection := sqlConexaoCrud;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add( 'SELECT' );
  Query.SQL.Add( '  COUNT( * )    AS QTD_CADASTROS,' );
  Query.SQL.Add( '  COUNT( FOTO ) AS QTD_FOTOS' );
  Query.SQL.Add( 'FROM' );
  Query.SQL.Add( '  ' + NomeTabelaOperadaPeloCrud );
  Query.Open;

  QuantidadeTotalDeCadastros         := Query.FieldByName( 'QTD_CADASTROS' ).AsInteger;
  QuantidadeTotalDeCadastrosComFotos := Query.FieldByName( 'QTD_FOTOS'     ).AsInteger;

  Query.Close;
  Query.Free;

  lblQuantidadeCadastros.Caption :=
    'Linha ' + Trim( FormatarFloat( cdsClientDataSetCrud.RecNo        , 12, 0 ) ) +
    ' De '   + Trim( FormatarFloat( QuantidadeTotalDeCadastros        , 12, 0 ) ) + ' Cadastro(s), ' +
    ' Dos Quais '  + Trim( FormatarFloat( QuantidadeTotalDeCadastrosComFotos, 12, 0 ) ) + ' Possuem Fotos(s)';
end;

procedure TfrmDialogoCrudClientes.AtualizarBotoesDeNavegacao;
begin
  spdRegistroInicial.Enabled  := ( cdsClientDataSetCrud.RecNo <> 1 );
  spdRegistroAnterior.Enabled := ( cdsClientDataSetCrud.RecNo <> 1 );
  spdRegistroSeguinte.Enabled := ( cdsClientDataSetCrud.RecNo <> cdsClientDataSetCrud.RecordCount );
  spdRegistroFinal.Enabled    := ( cdsClientDataSetCrud.RecNo <> cdsClientDataSetCrud.RecordCount );
end;

procedure TfrmDialogoCrudClientes.SetarEstadoMenuDeControles(
  Opcao: TLabel );

  procedure SetarEstadoOpcao(
    Opcao: TLabel;
    Selecionada: Boolean );
  begin
    if Selecionada then
    begin
      Opcao.Font.Color := clRed;
      Opcao.Font.Style := Opcao.Font.Style + [ fsUnderline ];
    end
    else
    begin
      Opcao.Font.Color := clMaroon;
      Opcao.Font.Style := Opcao.Font.Style - [ fsUnderline ];
    end
  end;

begin
  SetarEstadoOpcao( lblZoom           , False );
  SetarEstadoOpcao( lblNovo           , False );
  SetarEstadoOpcao( lblRemover        , False );
  SetarEstadoOpcao( lblRelatorio      , False );
  SetarEstadoOpcao( lblCatalogo       , False );
  SetarEstadoOpcao( lblEmailXML       , False );
  SetarEstadoOpcao( lblVoltar         , False );

  if ( Opcao <> Nil ) then
    SetarEstadoOpcao( Opcao, True  );
end;

procedure TfrmDialogoCrudClientes.lblPrimeiroMouseLeave(Sender: TObject);
begin
  SetarEstadoMenuDeControles( Nil );
end;

procedure TfrmDialogoCrudClientes.lblPrimeiroMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  SetarEstadoMenuDeControles( TLabel( Sender ) );
end;

procedure TfrmDialogoCrudClientes.FormShow(Sender: TObject);
begin
  dbgGridCrud.SetFocus;
end;

procedure TfrmDialogoCrudClientes.lblVoltarClick(Sender: TObject);
begin
  spdSairClick( Sender );
end;

procedure TfrmDialogoCrudClientes.dbgGridCrudDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Bitmap: TBitmap;
  ConteudoCelula: String;
  TamanhoEscrito, PosicaoAEscrever: TSize;

  procedure LimparAreadDosMarcadoresDeOrdenacaoAcimaDosTitulosDoGrid;
  begin
    imgGridSuperior.Canvas.Brush.Color := pnlDialogoCrudFundo.Color;
    imgGridSuperior.Canvas.Brush.Style := bsSolid;
    imgGridSuperior.Canvas.FillRect( imgGridSuperior.ClientRect );
  end;

begin
  TStringGrid( dbgGridCrud ).RowHeights[ 0 ] :=
    Round( 1.4 * TStringGrid( dbgGridCrud ).RowHeights[ 1 ] );

  {H� Um Mecanismo Complicado Para Assegurar o Desenho Dos Marcadores De Ordena��o
   Sobre Colunas. Os Cuidados Mais Abaixo Asseguram o Desenho Correto Dos Marcadores
   De Ordena��o Sobre Os T�tulos Das Colunas. Mas, Mesmo Com Seu Desenho Correto,
   Restaria Um Problema Que Consiste No Caso Em Que Estes Marcadores N�o Devessem
   Ser Desenhados Simplesmente Porque a Atual Coluna De Ordena��o N�o Estivesse
   Aparecendo Na �rea V�sivel Do Grid Devido a Ele Ter Sido "Scrollado" Para Esquerda
   Ou Para Direita, Ent�o Ficando Em Uma Posi��o Em Que Esta Coluna De Ordena��o N�o
   Ficasse Vis�vel. Neste Caso Nenhum Marcador Deveria Ser Desenhado. E Isto N�o �
   Simples Porque Este Procedimento De Pintura De Colunas Do Grid Sequer � Chamado Ou
   Disparado Para Colunas "Clipadas" Que N�o Estejam Vis�veis. Assim, Por Causa Disto, o
   "Scroll" Para Esquerda Ou Direita Do Grid Poderia Fazer Com Que Permanecessem
   Desenhados Os Marcadores Anteriores, De Quanto a Coluna De Ordena��o Estivesse
   Efetivamente Vis�vel. E Os Marcadores Desenhados Em Um Processamento De Desenho
   Anterior Ficaram Errados. Para Resolver � Marcado, De Forma Global, Na Vari�vel
   "OrdenacaoDesenhouMarcadorSobreColuna" Se Algum Marcador Foi Efetivamente Desenhado,
   Representando Que a Coluna De Ordena��o Est� Vis�vel. Caso Ao Final Do Desenho
   Do Grid Seja Visto Que N�o Ocorreu e N�o Passou o Desenho Da Coluna De Ordena��o,
   Ent�o a �rea De Desenho De Marcadores, Sobre o T�tulo Das Colunas, Ser� Limpa
   Para N�o Permanecer Com o Desenho Do Processamento Anterior:}
  if ( ( Rect.Left = 0 ) and
       ( Rect.Top < 30 ) ) then
    OrdenacaoDesenhouMarcadorSobreColunas := False;  // J� Na Primeira C�lula Desenhada,
                                                     // Marcar Que N�o Desenhou Marcadores De Colunas De Ordena��o

  {Verificar Se Est� Desenhando Parte Da Coluna Pela Qual o Grid Est� Sendo Ordenado:}
  if ( UpperCase( Column.Field.FieldName ) = UpperCase( OrdenacaoCampo ) ) then
  begin
    {Observando Que Esta Ponto De Processamento Somente Ser� Executado Se a Coluna
     De Ordena��o Estiver Efetivamente Vis�vel Na Tela. E N�o Estamos Nos Referindo a
     Ela Esta Com "Visible True ou False", Mas a Ela N�o Estar "Clipada" Fora Da �rea
     De foco Do Grid.}

    {Como Est� Desenhando a Coluna De Ordena��o, Ent�o Destacar a Sua Cor Das Demais:}
    dbgGridCrud.Canvas.Brush.Color :=
      AjustarCorParaMaisEscuraOuClara(
      CorGridCrudCorpo,
      80 );
    dbgGridCrud.Canvas.FillRect( Rect );

    {Realizar o Desenho Dos Marcadores De Ordena��o Sobre Colunas Somente Ao Processar a
    Linha Inicial Do Grid Para N�o Ficar Repetindo Sem Necessidade Este Processamento:}
    if ( Rect.Top < 30 ) then
    begin
      {Limpar a �rea Dos Marcadores De Ordena��o Que Fica Fora Do Grid, Em Um "TImage"
       Imediatamente Acima Dos T�tulos Deste Grid:}
      LimparAreadDosMarcadoresDeOrdenacaoAcimaDosTitulosDoGrid;

      {Aplicar o Marcador, Alinhado Com o Respectivo T�tulo Do Grid, Acima Dele:}
      Bitmap := TBitmap.Create;
      if OrdenacaoDescendente then
        imlImagensOrdenacao.GetBitmap( 1, Bitmap )
      else
        imlImagensOrdenacao.GetBitmap( 0, Bitmap );
      Bitmap.Transparent := True;
      imgGridSuperior.Canvas.Draw(
        Rect.Left + Round( ( Column.Width - Bitmap.Width ) / 2 ),
        Round( ( imgGridSuperior.Height - Bitmap.Height ) / 2 ),
        Bitmap );
      Bitmap.Free;

      {Sinalizar Que Realmente Desenhou Um Marcador De Coluna De Ordena��o:}
      OrdenacaoDesenhouMarcadorSobreColunas := True;
    end
  end;

  {Realizar Os Demais Processamentos Para o Efetivo Desenho Do Conte�do Das C�lulas Do Grid:}
  if ( gdSelected in State ) then
  begin
    {Caso Seja a C�lula Atualmente Selecionada:}
    dbgGridCrud.Canvas.Brush.Color := CorCelulaSelecionada;
    dbgGridCrud.Canvas.FillRect( Rect );

    dbgGridCrud.Canvas.Font.Color := clBlack;
    dbgGridCrud.Canvas.Font.Style := dbgGridCrud.Canvas.Font.Style + [ fsBold ];

    {Como Est� Na C�lula Efetivamente Selecionada, Aproveitar Para Atualizar o Visual Dos Bot�es
     De Nevega��o:}
    AtualizarBotoesDeNavegacao;

    {Como Est� Na C�lula Efetivamente Selecionada, Aproveitar Para Atualizar o Apresenta��o Do
     N�mero Da Linha Atual e Da Quantidade Total De Cadastros:}
    AtualizarQuantidadeCadastrosEFotos;
  end;

  {Depois De Todas As Provid�ncias Acima, Finalmente Vai Escrever Efetivamente o Conte�do Da
   C�lula Na Posi��o Correta. Mas Resta Ainda Uma Provid�ncia Que � Calcular a Posi��o Exata De
   Desenho, Dentro Da �rea De Cada C�lula, Levando Em Considera��o o Alinhamento Desejado Para Cada
   Coluna:}
  if ( Column.FieldName = 'SEXO' ) then
    ConteudoCelula := LeftStr( Trim( Column.Field.AsString ), 1 )
  else
    ConteudoCelula := Trim( Column.Field.AsString );
  TamanhoEscrito :=              // Calcular Qual Ser� o Tamanho Efetivo Da Escrita Do Conte�do Desejado, Na Horizontal e Na Vertical
    dbgGridCrud.Canvas.TextExtent( ConteudoCelula );
  PosicaoAEscrever.Cy :=         // No Alinhamento Vertical, Simplesmente Calcular a Posi��o Que Centralize o Texto Da C�lula
    Rect.Top + Round( ( ( Rect.Bottom - Rect.Top ) - TamanhoEscrito.Cy ) / 2 );
  case Column.Alignment of       // No Alinhamento Horizontal, Calcular Conforme Seja o Alinhamento Desejado Para Cada C�lula e Coluna
    taLeftJustify:               // Alinhar Conte�do Da C�lula a Esquerda No Espa�o Reservado a Ela
      PosicaoAEscrever.Cx :=
        Rect.Left;
    taCenter:                    // Alinhar Conte�do Da C�lula Ao Centro No Espa�o Reservado a Ela
      PosicaoAEscrever.Cx :=
        Rect.Left + Round( ( ( Rect.Right - Rect.Left ) - TamanhoEscrito.Cx ) / 2 );
    taRightJustify:             // Alinhar Conte�do Da C�lula a Direita No Espa�o Reservado a Ela
      PosicaoAEscrever.Cx :=
        ( Rect.Right - TamanhoEscrito.Cx );
  end;
  dbgGridCrud.Canvas.TextOut(   // Finalmente Escrever, Desenhar Conte�do Da C�lula Do Grid Na Posi��o Calculada Acima
    PosicaoAEscrever.Cx,
    PosicaoAEscrever.Cy,
    ConteudoCelula );

  {Ao Final Do Processamento, Quando Estiverem Sendo Desenhadas As �ltimas Linhas Do Grid,
   Verificar Se Ocorreu e Se Passou Acima o Desenho De Marcadores Da Coluna De Ordena��o:}
  if ( Rect.Top > dbgGridCrud.Height - 50 ) then
  begin
    {Caso a Coluna De Ordena��o Esteja "Clipada" a Esquerda Ou a Direita Da �rea Vis�vel
     Do Grid, Ent�o Limpar a �rea De Marcadores, Sobre Os T�tulos Do Grid, Para Que N�o
     Permane�am Desenhados Errados Em Uma Configura��o Anteriormente Processada:}
    if not OrdenacaoDesenhouMarcadorSobreColunas then
      LimparAreadDosMarcadoresDeOrdenacaoAcimaDosTitulosDoGrid;
  end;
end;

procedure TfrmDialogoCrudClientes.dbgGridCrudTitleClick(Column: TColumn);
begin
  if ( UpperCase( OrdenacaoCampo ) = UpperCase( Column.Field.FieldName ) ) then
  begin
    OrdenacaoDescendente := not OrdenacaoDescendente
  end
  else
  begin
    OrdenacaoCampo := Column.Field.FieldName;
    OrdenacaoDescendente := False;
  end;

  AbrirTabelaCrud(
    OrdenacaoCampo,
    OrdenacaoDescendente );
end;

procedure TfrmDialogoCrudClientes.dbgGridCrudKeyPress(Sender: TObject;
  var Key: Char);
begin
  if ( Key = Chr( 013 ) ) then
  begin
    if CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar then
      Exit;
  end;

  {Aceitar Apenas Caracateres Mai�sculos:}
  if ( Pos( Key, 'abcdefghijklmnopqrstuvwxyz' ) > 0 ) then
    Key := Chr( Ord( Key ) - Ord( 'a' ) + Ord( 'A' ) );
end;

procedure TfrmDialogoCrudClientes.dbgGridCrudKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  {As Provid�ncias Abaixo Impedem a Cria��o For�ada De Novas Linhas No Grid, Al�m Dos
   Registros J� Existentes. Isto Quando Se Pressiona a Tecla Seta Para Baixo Estando
   Posicionado Na �ltima Linha Do Grid. Al�m Disto, a Inser��o Via Pressionar Da Tecla
   "Insert" Tamb�m � Impedido:}
  if ( ( Key = VK_INSERT ) or
       ( ( Key = VK_DOWN ) and
         ( cdsClientDataSetCrud.RecNo = - 1 ) ) ) then
  begin
    cdsClientDataSetCrud.Cancel;

    frmPrincipal.AcionarFormProsseguir(
      'Caso Pretenda Criar Um Novo Cadastro, Utilize a Op��o "Novo"' + RetornoDeCarro( 01 ) +
      'Existente Ao Lado Esquerdo Da Tela',
      '',
      '',
      'Prosseguir',
      False );
  end;
end;

procedure TfrmDialogoCrudClientes.cdsClientDataSetCrudAfterPost(
  DataSet: TDataSet);
begin
  AplicarAtualizacoesPostadasRemovendoDuplicacoesIdenticas;
end;

procedure TfrmDialogoCrudClientes.lblRemoverClick(Sender: TObject);
var
  MensagemParaConfirmarRemocao: String;
  Prosseguir: Boolean;
begin
  if TabelaPossuiAoMenosUmRegistroEInformarUsuarioSeNao( cdsClientDataSetCrud ) then
  begin
    if ( VerificarExistenciaRegistrosDuplicados(
           NomeTabelaOperadaPeloCrud,
           NomeCampoLogicoOrdenacaoInicial,
           cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString ) ) then
    begin
      frmPrincipal.AcionarFormProsseguir(
        'N�o � Poss�vel Simplesmente Remover o Cadastro' + RetornoDeCarro( 02 ) +
        cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).DisplayName + ':' + RetornoDeCarro( 01 ) +
        cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString + RetornoDeCarro( 02 ) +
        'Porque H� Mais De Um Cadastro Com Conte�do Id�ntico a Ele, Em Todos Os Seus' + RetornoDeCarro( 01 ) +
        'Campos De Informa��es.' + RetornoDeCarro( 02 ) +
        'Para Que Seja Poss�vel Remover Alguma Destas Duplica��es Cadastrais, Primeiro �' + RetornoDeCarro( 01 ) +
        'Necess�rio Editar o Cadastro a Ser Eliminado, Alterando-o, De Modo Que, Em Ao' + RetornoDeCarro( 01 ) +
        'Menos Um Dos Seus Campos, Ele Fique Com Conte�do Diferente Das Suas Demais' + RetornoDeCarro( 01 ) +
        'Duplica��es, e Assim Possa Ser Identificado Individualmente Para Correta' + RetornoDeCarro( 01 ) +
        'Elimina��o.',
        '',
        '',
        'Prosseguir',
        False );
      Exit;
    end;

    {Se o Cadastro Estiver Com o Nome Identificar Em Branco, Eliminar Direto Sem Pedir Confirma��o:}
    Prosseguir := ( cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString = '' );

    if not Prosseguir then
    begin
      MensagemParaConfirmarRemocao :=
        'Foi Solicitado Remover o Cadastro' + RetornoDeCarro( 02 ) +
        cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).DisplayName + ':' + RetornoDeCarro( 01 ) +
        cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString + RetornoDeCarro( 02 );

      if ( Trim( cdsClientDataSetCrud.FieldByName( NomeCampoLogicoChavePrimaria ).AsString ) <> '' ) then
        MensagemParaConfirmarRemocao :=
          MensagemParaConfirmarRemocao +
          cdsClientDataSetCrud.FieldByName( NomeCampoLogicoChavePrimaria ).DisplayName + ':' + RetornoDeCarro( 01 ) +
          cdsClientDataSetCrud.FieldByName( NomeCampoLogicoChavePrimaria ).AsString + RetornoDeCarro( 02 );

      MensagemParaConfirmarRemocao :=
        MensagemParaConfirmarRemocao +
          'Confirma Apagar o Cadastro Acima?';

      Prosseguir :=
        ( frmPrincipal.AcionarFormProsseguir(
            MensagemParaConfirmarRemocao,
            '',
            'N�o, Preservar',
            'Sim, Remover',
            False ) = mrYes );
    end;

    if Prosseguir then
    begin
      {O Detalhe Abaixo � Importante. Caso Esteja Mostrando a P�gina Com a Ficha Cadastral
       Individual, Com Um Cadastro, e Este Cadastro For Tamb�m o �nico Existente Na Tabela,
       Ora, Com a Sua Remo��o Ent�o N�o Restar� Mais Nenhum Cadastro Na Tabela e Assim, a
       P�gina Dever� Ser Comutada Para a Forma De Tabela Com Todos Porque Depois, Logo Em
       Seguida, N�o Haver� Mais Nenhum Cadastro a Ser Mostrado Na Ficha Com Um:}
      if ( ( pgcPaginas.ActivePage <> tshTabelaComTodos ) and
           ( cdsClientDataSetCrud.RecordCount <= 1 ) ) then
        ComutarPaginasEntreTabelaComTodosFichaComUm( tshTabelaComTodos );

      {Faz a Remo��o Do Cadastro:}
      cdsClientDataSetCrud.Delete;

      {Verificar e Eliminar Eventuais Duplica��es Cadastrais}
      AplicarAtualizacoesPostadasRemovendoDuplicacoesIdenticas;

      {Recontar a Quantidade De Cadastros Existentes e a Quanidade De Fotos Neles
       Contidas. E Atualizar a Legenda Indicativa Destas Quantidades Na Parte Inferir
       Da Tabela Com Todos:}
      AtualizarQuantidadeCadastrosEFotos;
    end;
  end;
end;

function TfrmDialogoCrudClientes.TabelaPossuiAoMenosUmRegistroEInformarUsuarioSeNao(
  var ClientDataSetCrud: TClientDataSet ): Boolean;
begin
  Result := ( ClientDataSetCrud.RecordCount > 0 );

  if not Result then
  begin
    {A Tabela Est� Vazia:}
    if ( ClientDataSetCrud.State = dsInsert ) then
    begin
      {A Tabela Est� Vazia, Mas Est� Em Modo De Inser��o Do Primeiro Cadastro:}

      {Aqui N�o Faz Sentido Meramente Avisar o Usu�rio. A Tabela Est� Vazia e Se Est�
       Inserindo o Primeiro Cadastro. Ent�o, Mais F�cil Seguir Para Frente Do Que Voltar,
       Fazer o Que Segue: Completar a Cria��o Do Cadastro Em Inser��o, Mesmo Que Seja
       Necess�rio For�ar Um Nome Gen�rico Para Ele Caso Ainda N�o Tenha Sido Inserido.
       E Confirmar Esta Inser��o. Em Seguida Retornar "True" Ao Procedimento Chamador,
       Como Se N�o Houvesse Cadastro Nenhum, Mas Que Agora Efetivamente Passou a Existir o
       Primeiro Cadastro, Para Que o Chamador Siga o Seu Processamento Normal. Isto �,
       Se o Procedimento Chamador Pretendia, Por Exemplo, Remover Um Cadastro, Agora a
       Tabela N�o Est� Mais Vazia e Ele Poder� Remover Este Cadastro Como Era Desejado:}
      if ( dbeNome.Text = '' ) then
        ClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString :=
          'SEM NOME ' + FormatDateTime( 'yyyymmddhhmmsszzz', Now );  // Se Ainda N�o Tinha Nome, Atribuir Um Nome Gen�rico
      ClientDataSetCrud.Post;                                        // Confirmar a Postagem, Encerrando a Inser��o
      Result := True;                                                // Retornar "True" Para Que o Pr�prio Procedimento Chamador
                                                                     // Siga Seu Processo Notmal J� Que a Tabela Deixou De Estar Vazia
    end
    else
    begin
      {A Tabela Est� Vazia, e N�o Est� Em Modo De Inser��o Do Primeiro Cadastro:}

      {Avisar o Usu�rio De Que a Tabela Est� Vazia:}
      frmPrincipal.AcionarFormProsseguir(
        'Ainda N�o H� Nenhum Cadastro Deste G�nero No Banco De Dados!' + RetornoDeCarro( 02 ) +
        'Por Favor, Acione a Op��o "Novo" Para Inserir o Primeiro Cadastro.',
        '',
        '',
        'Prosseguir',
        False );
    end;
  end;
end;

function TfrmDialogoCrudClientes.VerificarExistenciaRegistrosDuplicados(
  NomeTabela: String;
  CampoIdentificador: String;
  ConteudoCampoIdentificador: String ): Boolean;
var
  Query: TSQLQuery;

  procedure InserirComparativoTodosCamposDaTabela;
  var
    ContadorCampos: Integer;
  begin
    for ContadorCampos := 0 to cdsClientDataSetCrud.Fields.Count - 1 do
    begin
      Query.SQL.Add(
        '      ( ( TAB1.' + cdsClientDataSetCrud.Fields[ ContadorCampos ].FieldName +
        ' = ' +
        'TAB2.' + cdsClientDataSetCrud.Fields[ ContadorCampos ].FieldName + ' ) OR' );

      Query.SQL.Add(
        '        ( ( TAB1.' + cdsClientDataSetCrud.Fields[ ContadorCampos ].FieldName +
        ' IS NULL ) AND (' +
        'TAB2.' + cdsClientDataSetCrud.Fields[ ContadorCampos ].FieldName + ' IS NULL ) ) ) AND' );
    end;
  end;

begin
  Query := TSQLQuery.Create( Self );
  Query.SQLConnection := sqlConexaoCrud;

  {Primeiro Verificar Se Existem Duplica��es Id�nticas Entre Os Cadastros:}
  Query.Close;
  Query.SQL.Clear;

  Query.SQL.Add( 'SELECT') ;
  Query.SQL.Add( '  *') ;
  Query.SQL.Add( 'FROM') ;
  Query.SQL.Add( '  ' + NomeTabela + ' AS TAB1' );
  Query.SQL.Add( 'WHERE EXISTS') ;
  Query.SQL.Add( '    (') ;
  Query.SQL.Add( '    SELECT FIRST 1') ;
  Query.SQL.Add( '      *') ;
  Query.SQL.Add( '    FROM') ;
  Query.SQL.Add( '      ' + NomeTabela + ' AS TAB2' );
  Query.SQL.Add( '    WHERE') ;
  Query.SQL.Add( '      ( ' + CampoIdentificador + ' = "' + ConteudoCampoIdentificador + '" ) AND' );

  InserirComparativoTodosCamposDaTabela;

  Query.SQL.Add( '      ( TAB1.RDB$DB_KEY <> TAB2.RDB$DB_KEY )') ;
  Query.SQL.Add( '    )') ;
  Query.Open;

  Query.First;
  Result := not Query.Eof;

  Query.Close;
  Query.Free;
end;

function TfrmDialogoCrudClientes.EliminarRegistrosComConteudoTotalmenteDuplicadoDeixandoApenasUm(
  NomeTabela: String;
  var ClientDataSetCrud: TClientDataSet ): Boolean;
var
  Query: TSQLQuery;

  procedure InserirComparativoTodosCamposDaTabela;
  var
    ContadorCampos: Integer;
  begin
    for ContadorCampos := 0 to cdsClientDataSetCrud.Fields.Count - 1 do
    begin
      Query.SQL.Add(
        '      ( ( TAB1.' + cdsClientDataSetCrud.Fields[ ContadorCampos ].FieldName +
        ' = ' +
        'TAB2.' + cdsClientDataSetCrud.Fields[ ContadorCampos ].FieldName + ' ) OR' );

      Query.SQL.Add(
        '        ( ( TAB1.' + cdsClientDataSetCrud.Fields[ ContadorCampos ].FieldName +
        ' IS NULL ) AND (' +
        'TAB2.' + cdsClientDataSetCrud.Fields[ ContadorCampos ].FieldName + ' IS NULL ) ) ) AND' );
    end;
  end;

begin
  Query := TSQLQuery.Create( Self );
  Query.SQLConnection := sqlConexaoCrud;

  {Primeiro Verificar Se Existem Duplica��es Id�nticas Entre Os Cadastros:}
  Query.Close;
  Query.SQL.Clear;

  Query.SQL.Add( 'SELECT') ;
  Query.SQL.Add( '  *') ;
  Query.SQL.Add( 'FROM') ;
  Query.SQL.Add( '  ' + NomeTabela + ' AS TAB1' );
  Query.SQL.Add( 'WHERE EXISTS') ;
  Query.SQL.Add( '    (') ;
  Query.SQL.Add( '    SELECT FIRST 1') ;
  Query.SQL.Add( '      *') ;
  Query.SQL.Add( '    FROM') ;
  Query.SQL.Add( '      ' + NomeTabela + ' AS TAB2' );
  Query.SQL.Add( '    WHERE') ;

  InserirComparativoTodosCamposDaTabela;

  Query.SQL.Add( '      ( TAB1.RDB$DB_KEY <> TAB2.RDB$DB_KEY )') ;
  Query.SQL.Add( '    )') ;
  Query.Open;

  Query.First;
  Result := not Query.Eof;

  if Result then
  begin
    {Depois, Se Tiverem Sido Encontradas Duplica��es Id�nticas Entre Os Cadastros, Ent�o
     Elimina-las Preservado Apenas Uma De Cada, Sem Repeti��es:}
    Query.Close;
    Query.SQL.Clear;

    Query.SQL.Add( 'DELETE FROM' );
    Query.SQL.Add( '  ' + NomeTabela + ' AS TAB1' );
    Query.SQL.Add( 'WHERE' );
    Query.SQL.Add( '  EXISTS' );
    Query.SQL.Add( '  (' );
    Query.SQL.Add( '  SELECT' );
    Query.SQL.Add( '    1' );
    Query.SQL.Add( '  FROM' );
    Query.SQL.Add( '    ' + NomeTabela + ' AS TAB2' );
    Query.SQL.Add( '  WHERE' );

    InserirComparativoTodosCamposDaTabela;

    Query.SQL.Add( '    ( TAB1.RDB$DB_KEY < TAB2.RDB$DB_KEY )' );
    Query.SQL.Add( ');' );
    Query.ExecSQL;

    ClientDataSetCrud.Refresh;
  end;

  Query.Close;
  Query.Free;
end;

procedure TfrmDialogoCrudClientes.AplicarAtualizacoesPostadasRemovendoDuplicacoesIdenticas;
begin
  {Aplicar Altera��es Ao Banco De Dados:}
  cdsClientDataSetCrud.ApplyUpdates( 0 );

  {Verificar Se H� Cadastros Duplicados e Elimina-los:}
  if ( EliminarRegistrosComConteudoTotalmenteDuplicadoDeixandoApenasUm(
         NomeTabelaOperadaPeloCrud,
         cdsClientDataSetCrud ) ) then
  begin
    {Quanto a Informar Ao Usu�rio Sobre a Realiza��o Da Elimina��es Das Duplica��es, Somente
     Informa-las Caso N�o Tenha Havido Imediatamente Antes Um Erro De Valida��o Do Cont�udo
     Da Digita��o Mais Recente. Se Isto Tiver Acontecido, N�o H� Necessidade De Informar Porque
     Uma Duplica��o Teria Ocorrido De Forma Natural, Sem Que Tivesse Sido Diretamente Criada
     Pelo Usu�rio. Assim, Basta Te-la Eliminado, Mas Sem a Necessidade De Informar Sobre Isto:}
    if not EdicaoNaPaginaTabelaComTodos_HouveErroPrevioValidacao then
    begin
      EsperarSegundos( 0.25, False );

      frmPrincipal.AcionarFormProsseguir(
        'Foram Automaticamente Removidos Os Cadastros Duplicados, Aqueles Que' + RetornoDeCarro( 01 ) +
        'Estavam Com Conte�do Absolutamente Id�ntico Entre Si, Com Todos Os' + RetornoDeCarro( 01 ) +
        'Seus Campos Preenchidos De Forma Igual.' + RetornoDeCarro( 02 ) +
        'Nesta Remo��o Foram Preservados Os Cadastros �nicos, Com Conte�do' + RetornoDeCarro( 01 ) +
        'In�dito, Sem Repeti��es.',
        '',
        '',
        'Prosseguir',
        False );
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.spdBuscaClick(Sender: TObject);
begin
  if ( Trim( cbxBusca.Text ) <> '' ) then
  begin
    if ( cbxBusca.Items.IndexOf( cbxBusca.Text ) = - 1 ) then
      cbxBusca.Items.Add( cbxBusca.Text );

    {Procurar Express�o Dentro Da Atual Coluna De Ordena��o:}
    if ( not cdsClientDataSetCrud.Locate( OrdenacaoCampo, cbxBusca.Text, [ loCaseInsensitive, loPartialKey ] ) ) then
    begin
      frmPrincipal.AcionarFormProsseguir(
        'A Express�o' + RetornoDeCarro( 02 ) +
        '"' + cbxBusca.Text + '"' + RetornoDeCarro( 02 ) +
        'N�o Foi Encontrada Na Coluna' + RetornoDeCarro( 02 ) +
        '"' + cdsClientDataSetCrud.FieldByName( OrdenacaoCampo ).DisplayName + '"',
        '',
        '',
        'Prosseguir',
        False );
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.cbxBuscaKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ( Key = VK_RETURN ) then
    spdBuscaClick( Sender );
end;

procedure TfrmDialogoCrudClientes.lblRelatorioClick(Sender: TObject);
begin
  if TabelaPossuiAoMenosUmRegistroEInformarUsuarioSeNao( cdsClientDataSetCrud ) then
  begin
    {Caso Esteja Em Edi��o Ou Inser��o, Fazer o Post Para Gravar:}
    CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar;

    PreverRelatorioCrudClientes;
  end;
end;

procedure TfrmDialogoCrudClientes.lblCatalogoClick(Sender: TObject);
begin
  if TabelaPossuiAoMenosUmRegistroEInformarUsuarioSeNao( cdsClientDataSetCrud ) then
  begin
    {Caso Esteja Em Edi��o Ou Inser��o, Fazer o Post Para Gravar:}
    CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar;

    PreverRelatorioCrudClientesComFotos;
  end;
end;

procedure TfrmDialogoCrudClientes.PreverRelatorioCrudClientes;
begin
  if ( Printer.Printers.Count = 0 ) then
  begin
    frmPrincipal.MostrarMensagemErroAusenciaDeUmaImpressoraConfigurada;
  end
  else
  begin
    frmImprimirRelatorioCrudClientes := TfrmImprimirRelatorioCrudClientes.Create( Self );
    frmImprimirPrevisaoImpressao := TfrmImprimirPrevisaoImpressao.Create( Self );

    {Estas Linhas Abaixo S�o Necess�rias Para Melhorar o Aspecto De Redesenho Da
     Tela, De Forma Que, Quando o Formul�rio De Previs�o De Impress�o For Mostrado
     (Que Por Enquanto Ainda Est� Invis�vel), Ele J� Entre Ocupando a Tela Inteira:}
    frmImprimirPrevisaoImpressao.Top := 0;
    frmImprimirPrevisaoImpressao.Width := Screen.Width;
    frmImprimirPrevisaoImpressao.Left := 0;
    frmImprimirPrevisaoImpressao.Height := Screen.Height;

    {Preparar o Relat�rio:}
    frmAguarde.LigarDesligarFormMensagemAguarde(
      True,
      TForm( frmDialogoCrudClientes ) );

    frmImprimirRelatorioCrudClientes.PrepararRelatorio(
      Self,
      'Relat�rio De Clientes' );

    frmAguarde.LigarDesligarFormMensagemAguarde(
      False,
      TForm( frmDialogoCrudClientes ) );

    {Mostrar o Relat�rio Em Tela de Previs�o:}
    frmImprimirPrevisaoImpressao.PrepararRelatorioPrevisaoEmTela(
      frmImprimirRelatorioCrudClientes.qrlTitulo01.Caption,
      frmImprimirRelatorioCrudClientes.qrpRelatorio,
      True,
      False );
    frmImprimirPrevisaoImpressao.Release;
    frmImprimirRelatorioCrudClientes.Release;

    Self.Show;
  end;
end;

procedure TfrmDialogoCrudClientes.PreverRelatorioCrudClientesComFotos;
begin
  if ( Printer.Printers.Count = 0 ) then
  begin
    frmPrincipal.MostrarMensagemErroAusenciaDeUmaImpressoraConfigurada;
  end
  else
  begin
    frmImprimirRelatorioCrudClientesComFotos := TfrmImprimirRelatorioCrudClientesComFotos.Create( Self );
    frmImprimirPrevisaoImpressao := TfrmImprimirPrevisaoImpressao.Create( Self );

    {Estas Linhas Abaixo S�o Necess�rias Para Melhorar o Aspecto De Redesenho Da
     Tela, De Forma Que, Quando o Formul�rio De Previs�o De Impress�o For Mostrado
     (Que Por Enquanto Ainda Est� Invis�vel), Ele J� Entre Ocupando a Tela Inteira:}
    frmImprimirPrevisaoImpressao.Top := 0;
    frmImprimirPrevisaoImpressao.Width := Screen.Width;
    frmImprimirPrevisaoImpressao.Left := 0;
    frmImprimirPrevisaoImpressao.Height := Screen.Height;

    {Preparar o Relat�rio:}
    frmAguarde.LigarDesligarFormMensagemAguarde(
      True,
      TForm( frmDialogoCrudClientes ) );

    frmImprimirRelatorioCrudClientesComFotos.PrepararRelatorio(
      Self,
      'Cat�logo De Clientes' );

    frmAguarde.LigarDesligarFormMensagemAguarde(
      False,
      TForm( frmDialogoCrudClientes ) );

    {Mostrar o Relat�rio Em Tela de Previs�o:}
    frmImprimirPrevisaoImpressao.PrepararRelatorioPrevisaoEmTela(
      frmImprimirRelatorioCrudClientesComFotos.qrlTitulo01.Caption,
      frmImprimirRelatorioCrudClientesComFotos.qrpRelatorio,
      True,
      False );
    frmImprimirPrevisaoImpressao.Release;
    frmImprimirRelatorioCrudClientesComFotos.Release;

    Self.Show;
  end;
end;

procedure TfrmDialogoCrudClientes.imgGridSuperiorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmPrincipal.AcionarFormProsseguir(
    'Clique Sobre o T�tulo Da Coluna Para Estabelecer a Forma De Ordena��o.',
    '',
    '',
    'Prosseguir',
    False );
end;

procedure TfrmDialogoCrudClientes.lblZoomClick(Sender: TObject);
var
  Prosseguir: Boolean;
begin
  Prosseguir := True;
  {Se Estiver Na P�gina Da Tabela Com Todos Os Cadastros, a Comuta��o Para a P�gina Com a
   Ficha Que Mostra Apenas Um Cadastro Somente Ser� Permitida Desde Que Haja Ao Menos Um
   Registro Cadastrado Na Tabela Do Banco De Dados. Em Outras Palavras, Se Estiver Mostrando
   Uma Tabela Vazia, Com Zero Cadastros, N�o Ir� Comutar Para a Ficha Infividual:}
  if ( pgcPaginas.ActivePage = tshTabelaComTodos ) then
    Prosseguir := TabelaPossuiAoMenosUmRegistroEInformarUsuarioSeNao( cdsClientDataSetCrud );

  if Prosseguir then
    ComutarPaginasEntreTabelaComTodosFichaComUm( Nil );
end;

procedure TfrmDialogoCrudClientes.ComutarPaginasEntreTabelaComTodosFichaComUm(
  PaginaDesejada: TTabSheet );
var
  PaginaDesejadaIndice: Integer;
  DeslocamentoVerticalEntreBotoesNavegacao: Integer;
  PontoInicialBotoesNavegacao: TPoint;
  PainelDeOrigemDosBotoesNavegacao, PainelDeDestinoDosBotoesNavegacao: TPanel;
begin
  {Posicionar Ficha Com Um No Topo:}
  scbFichaCrud.VertScrollBar.Position := 0;

  {Resetar Mecanismo Que Permite Editar e Validar Edi��es Na Pr�pria Tabela Com
   Todos Os Registros:}
  EdicaoNaPaginaTabelaComTodos_NomeCampo                := '';
  EdicaoNaPaginaTabelaComTodos_MotivoCancelamento       := '';

  {Caso Esteja Em Edi��o Ou Inser��o, Fazer o Post Para Gravar:}
  CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar;

  {Anotar Em Que "Panel" Est�o Os Bot�es De Navega��o Antes De Comutar a P�gina:}
  PainelDeOrigemDosBotoesNavegacao := TPanel( spdRegistroInicial.Parent );

  {Se o Chamador N�o Especificou a P�gina De Destino Desejada, Ent�o Considerar
   Simplesnente Que Dever� Trocar a P�gina Atual Pela Seguinte:}
  if ( PaginaDesejada = Nil ) then
  begin
    PaginaDesejadaIndice := 0;
    if      ( pgcPaginas.ActivePageIndex = 0 ) then
      PaginaDesejadaIndice := 1
    else if ( pgcPaginas.ActivePageIndex = 1 ) then
      PaginaDesejadaIndice := 0;

    PaginaDesejada := pgcPaginas.Pages[ PaginaDesejadaIndice ];
  end;

  {Somente Fazer a Comuta��o Se For Mesmo Necess�rio, Isto �, Se a Pagina Desejada For
   Diferente Da Que J� Estiver Ativa:}
  if ( pgcPaginas.ActivePage <> PaginaDesejada ) then
  begin
    {Anotar Deslocamento Vertical Entre Bot�es De Navega��o Para Que Estes Bot�es De
     Navega��o Possam Ter Os Seus Respectivos "Parents" Comutados Entre As P�ginas, Mas
     Preservando a Exata Posi��o De Tela Em Que Est�o. Anotar Posi��o Vertical Orginal
     Que Os Bot�es De Navega��o Ocupavam Antes Da Mudan�a De P�gina:}
    DeslocamentoVerticalEntreBotoesNavegacao := spdRegistroAnterior.Top - spdRegistroInicial.Top;
    PontoInicialBotoesNavegacao := Point( spdRegistroInicial.Left, spdRegistroInicial.Top );
    PontoInicialBotoesNavegacao := PainelDeOrigemDosBotoesNavegacao.ClientToScreen( PontoInicialBotoesNavegacao );

    {Fazer a Comuta��o Da P�gina Propriamente Dita, Mas Antes Reposicionando Os
     Controles e Bot�es De Navega��o Para Os Seus Novos "Parents" Conforme a P�gina
     De Destino Desejada:}
    if      ( PaginaDesejada = tshTabelaComTodos ) then
    begin
      spdRegistroInicial.Parent  := pnlGridEsquerdo;
      spdRegistroAnterior.Parent := pnlGridEsquerdo;
      spdRegistroSeguinte.Parent := pnlGridEsquerdo;
      spdRegistroFinal.Parent    := pnlGridEsquerdo;
    end
    else if ( PaginaDesejada = tshFichaComUm ) then
    begin
      spdRegistroInicial.Parent  := pnlFichaEsquerdo;
      spdRegistroAnterior.Parent := pnlFichaEsquerdo;
      spdRegistroSeguinte.Parent := pnlFichaEsquerdo;
      spdRegistroFinal.Parent    := pnlFichaEsquerdo;
    end;
    pgcPaginas.ActivePage := PaginaDesejada;

    {Anotar Em Que "Panel" Est�o Os Bot�es De Navega��o Depois De Comutar a P�gina:}
    PainelDeDestinoDosBotoesNavegacao := TPanel( spdRegistroInicial.Parent );

    {Como Os Bot�es De Navega��o Tiveram Os Seus "Parents" Comutados Entre As Diferentes
     P�ginas, Calcular a Posi��o Inicial Vertical Equivalente Que Ter�o a Partir Do Ponto
     De Origem Em Tela Que Estavam Ao Ponto De Destino, Depois Desta Comuta��o:}
    PontoInicialBotoesNavegacao := PainelDeDestinoDosBotoesNavegacao.ScreenToClient( PontoInicialBotoesNavegacao );

    {Depois Da Comuta��o De P�ginas, Reposicionar Os Bot�es De Navega��o De Forma Que Preservem
     As Mesmas Posi��es De Tela Que Estavam Na P�gina Anterior:}
    spdRegistroInicial.Top  :=
      PontoInicialBotoesNavegacao.Y;
    spdRegistroAnterior.Top :=
      spdRegistroInicial.Top  + DeslocamentoVerticalEntreBotoesNavegacao;
    spdRegistroSeguinte.Top :=
      spdRegistroAnterior.Top + DeslocamentoVerticalEntreBotoesNavegacao;
    spdRegistroFinal.Top    :=
      spdRegistroSeguinte.Top + DeslocamentoVerticalEntreBotoesNavegacao;
  end;
end;

procedure TfrmDialogoCrudClientes.dtpDataDeNascimentoChange(
  Sender: TObject);
begin
  MudouCalendarioQueApoiaDBEditContendoData(
    dbeDataDeNascimento,
    dtpDataDeNascimento );
end;

procedure TfrmDialogoCrudClientes.dtpDataDeNascimentoEnter(
  Sender: TObject);
begin
  AbrirCalendarioQueApoiaDBEditContendoData(
    dbeDataDeNascimento,
    dtpDataDeNascimento );
end;

procedure TfrmDialogoCrudClientes.FormKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ( pgcPaginas.ActivePage = tshFichaComUm ) then
  begin
    if ( not ( ActiveControl is TDBRichEdit ) ) then
    begin
      {O Uso Da Tecla [ENTER] Na P�gina De Ficha Cadastral Servir� Como o Equivalente De
       Digitar a Tecla [TAB] Para Comutar Ao Campo Seguinte. Exceto Quando o Campo Ativo
       Que Receber Este [ENTER] For Para Digita��o De Texto Continuo, Como Um "TDBRichEdit":}
      if      ( Key = VK_RETURN ) then
        FindNextControl( ActiveControl, True, True, False ).SetFocus
      else if ( Key = VK_CONTROL ) then
      begin
        ColocarEmEstadoDeEdicaoSeJaNaoEstiver;

        if      ( ActiveControl is TDBEdit ) then
          TDBEdit( ActiveControl ).Field.AsString := ''
        else if ( ActiveControl is TDBComboBox ) then
        begin
          if ( ActiveControl <> dbcSexo ) then
            TDBComboBox( ActiveControl ).Field.AsString := '';
        end;
      end;
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.AbrirCalendarioQueApoiaDBEditContendoData(
  dbeDBEdit: TDBEdit;
  dtpCalendario: TDateTimePicker );
begin
  if ( dbeDBEdit.Field.AsDateTime = 0 ) then
    dtpCalendario.Date := Date
  else
    dtpCalendario.Date := Trunc( dbeDBEdit.Field.AsDateTime );
end;

procedure TfrmDialogoCrudClientes.MudouCalendarioQueApoiaDBEditContendoData(
  dbeDBEdit: TDBEdit;
  dtpCalendario: TDateTimePicker );
begin
  dbeDBEdit.DataSource.DataSet.Edit;
  dbeDBEdit.Field.AsDateTime := Trunc( dtpCalendario.Date );
end;

procedure TfrmDialogoCrudClientes.AbrirComboComOpcoesJaCadastradasEmUmaTabelaECampo(
  var dbcCombo: TDBComboBox;
  const NomeTabela: String;
  const NomeCampo: String;
  InserirBrancoComoPrimeiraOpcao: Boolean );
var
  Query: TSQLQuery;
begin
  Query := TSQLQuery.Create( Self );
  Query.SQLConnection := sqlConexaoCrud;

  Query.Close;
  Query.SQL.Clear;
  Query.SQL.Add( 'SELECT DISTINCT' );
  Query.SQL.Add( '  ' + NomeCampo );
  Query.SQL.Add( 'FROM' );
  Query.SQL.Add( '  ' + NomeTabela );
  Query.SQL.Add( 'WHERE' );
  Query.SQL.Add( '  ' + NomeCampo + ' <> ""' );
  Query.SQL.Add( 'ORDER BY' );
  Query.SQL.Add( '  ' + NomeCampo );
  Query.Open;

  dbcCombo.Items.Clear;

  if InserirBrancoComoPrimeiraOpcao then
    dbcCombo.Items.Add( '' );

  Query.First;
  while ( not Query.Eof ) do
  begin
    dbcCombo.Items.Add( Query.FieldByName( NomeCampo ).AsString );

    Query.Next;
  end;
  Query.Close;
  Query.Free;
end;

procedure TfrmDialogoCrudClientes.dbcAreaDropDown(Sender: TObject);
begin
  AbrirComboComOpcoesJaCadastradasEmUmaTabelaECampo(
    dbcArea,
    NomeTabelaOperadaPeloCrud,
    'AREA',
    True );
end;

procedure TfrmDialogoCrudClientes.dbcFuncaoDropDown(Sender: TObject);
begin
  AbrirComboComOpcoesJaCadastradasEmUmaTabelaECampo(
    dbcFuncao,
    NomeTabelaOperadaPeloCrud,
    'FUNCAO',
    True );
end;

procedure TfrmDialogoCrudClientes.dbeNomeEnter(Sender: TObject);
begin
  {Para Evitar Que o Campo J� Entre Totalmente Selecionado Quando H� Mudan�a De P�ginas:}
  dbeNome.SelStart := Length( dbeNome.Text );
  dbeNome.SelLength := 0;
end;

procedure TfrmDialogoCrudClientes.dbeCPFExit(Sender: TObject);
begin
  ValidarCampoCPFDigitadoEmDBEdit(
    dbeCPF,
    True,
    True );

  ValidarCampoNaoDuplicavelDigitadoEmDBEdit(
    dbeCPF,
    True );
end;                                                

procedure TfrmDialogoCrudClientes.dbgGridCrudDblClick(Sender: TObject);
begin
  lblZoomClick( Sender );
end;

procedure TfrmDialogoCrudClientes.scbFichaCrudDblClick(Sender: TObject);
begin
  lblZoomClick( Sender );
end;

procedure TfrmDialogoCrudClientes.lblNovoClick(Sender: TObject);
begin
  {Verificar Se N�o � o Caso Do Usu�rio Ter Acionado Duas Vezes Seguidas a Op��o
   Para Cadastrar Um Novo Registro. Se For Isto, e J� Estiver Em Inser��o, Ent�o
   N�o Deve Incluir Pela Segunda Vez Sem Necessidade:}
  if ( cdsClientDataSetCrud.State <> dsInsert ) then
  begin
    ReduzirFotoSeEstiverExpandida;

    MarcadorPosicaoRegistroAntesInserirNovoParaVoltarCasoCancele :=
      cdsClientDataSetCrud.GetBookmark;

    ComutarPaginasEntreTabelaComTodosFichaComUm( tshFichaComUm );

    cdsClientDataSetCrud.AfterScroll := Nil;
    cdsClientDataSetCrud.Append;
    cdsClientDataSetCrud.AfterScroll := cdsClientDataSetCrudAfterScroll;

    cdsClientDataSetCrud.FieldByName( 'SEXO' ).AsString := 'MASCULINO';
    cdsClientDataSetCrudAfterScroll( cdsClientDataSetCrud );

    dbeNome.SetFocus;
  end;
end;

procedure TfrmDialogoCrudClientes.dbeNomeExit(Sender: TObject);
begin
  ValidarCampoNaoVazioDigitadoEmDBEdit(
    dbeNome,
    True );
end;

procedure TfrmDialogoCrudClientes.dbeCNHExit(Sender: TObject);
begin
  ValidarCampoNaoDuplicavelDigitadoEmDBEdit(
    dbeCNH,
    True );
end;

procedure TfrmDialogoCrudClientes.cdsClientDataSetCrudBeforeEdit(
  DataSet: TDataSet);
begin
  if ( pgcPaginas.ActivePage = tshTabelaComTodos ) then
  begin
    {Est� Iniciando Uma Edi��o Na Pr�pria P�gina Contendo a Tabela Com Todos Os Cadastros.
     Preparar Mecanismo Para Depois Conseguir Validar a Edi��o Eventualmente Feita:}
    EdicaoNaPaginaTabelaComTodos_NomeCampo                := dbgGridCrud.SelectedField.FieldName;
    EdicaoNaPaginaTabelaComTodos_MotivoCancelamento       := '';
  end;
end;

procedure TfrmDialogoCrudClientes.cdsClientDataSetCrudBeforePost(
  DataSet: TDataSet );
var
  ContadorCampos: Integer;
  AbortarCancelarPost: Boolean;
  MensagemCampoNaoVazio, MensagemCampoCPFInvalido,
    MensagemCampoDuplicado, MensagemCampoSexoInvalido: String;
begin
  AbortarCancelarPost := True;

  {Primeiro Ver Se Todos Os Campos Est�o Vazios. Neste Caso Cancelar o Post:}
  ContadorCampos := 0;
  repeat
    AbortarCancelarPost :=
      ( ( AbortarCancelarPost ) and
        ( Trim( DataSet.Fields[ ContadorCampos ].AsString ) = '' ) );
    ContadorCampos := ContadorCampos + 1;
  until ( not AbortarCancelarPost ) or ( ContadorCampos >= DataSet.FieldCount - 1 );

  {Depois, Se Nem Todos Os Campos Est�o Vazios, Fazer As Demais Valida��es:}
  if not AbortarCancelarPost then
  begin
    {Definir Posss�veis Mensagens De Erro De Valida��o:}
    MensagemCampoNaoVazio      :=
      'A Edi��o Foi Cancelada Porque Este Campo N�o Pode Ficar Em Branco.';
    MensagemCampoCPFInvalido   :=
      'A Edi��o Foi Cancelada Porque o CPF Digitado � Inv�lido.';
    MensagemCampoDuplicado     :=
      'A Edi��o Foi Cancelada Porque o Conte�do Digitado Foi Encontrado' + RetornoDeCarro( 01 ) +
      'Duplicado Em Outro Cadastro.';
    MensagemCampoSexoInvalido  :=
      'A Edi��o Foi Cancelada Porque o Conte�do Digitado � Inv�lido';

    {Estas Valida��es S�o Feitas No Caso Das Edi��es Feitas Diretamente Na Tabela Com Todos}
    if ( ( pgcPaginas.ActivePage = tshTabelaComTodos ) and
         ( EdicaoNaPaginaTabelaComTodos_NomeCampo <> '' ) ) then
    begin


      {Verificar Campo Que N�o Pode Ficar Vazio:}
      if      ( EdicaoNaPaginaTabelaComTodos_NomeCampo = 'NOME' ) then
      begin
        AbortarCancelarPost :=
          not ValidarCampoNaoVazioDigitadoEmTabela( EdicaoNaPaginaTabelaComTodos_NomeCampo );

        if AbortarCancelarPost then
          EdicaoNaPaginaTabelaComTodos_MotivoCancelamento := MensagemCampoNaoVazio;
      end


      {Verificar Campo De CPF Que N�o Pode Ficar Inv�lido e N�o Pode Ficar Duplicado:}
      else if ( EdicaoNaPaginaTabelaComTodos_NomeCampo = 'CPF' ) then
      begin
        AbortarCancelarPost :=
          not ValidarCampoCPFDigitadoEmTabela( EdicaoNaPaginaTabelaComTodos_NomeCampo );

        if AbortarCancelarPost then
          EdicaoNaPaginaTabelaComTodos_MotivoCancelamento := MensagemCampoCPFInvalido
        else
        begin
          AbortarCancelarPost :=
            not ValidarCampoNaoDuplicavelDigitadoEmTabela( EdicaoNaPaginaTabelaComTodos_NomeCampo );

          if AbortarCancelarPost then
            EdicaoNaPaginaTabelaComTodos_MotivoCancelamento := MensagemCampoDuplicado;
        end;
      end


      {Verificar Campo Cujo Conte�do N�o Pode Ficar Duplicado:}
      else if ( EdicaoNaPaginaTabelaComTodos_NomeCampo = 'CNH' ) then
      begin
        AbortarCancelarPost :=
          not ValidarCampoNaoDuplicavelDigitadoEmTabela( EdicaoNaPaginaTabelaComTodos_NomeCampo );

        if AbortarCancelarPost then
          EdicaoNaPaginaTabelaComTodos_MotivoCancelamento := MensagemCampoDuplicado;
      end


      {Verificar Campo Sexo:}
      else if ( EdicaoNaPaginaTabelaComTodos_NomeCampo = 'SEXO' ) then
      begin
        AbortarCancelarPost :=
          not ValidarCampoSexoDigitadoEmTabela( EdicaoNaPaginaTabelaComTodos_NomeCampo );

        if AbortarCancelarPost then
          EdicaoNaPaginaTabelaComTodos_MotivoCancelamento := MensagemCampoSexoInvalido;
      end;


    end;
  end;

  EdicaoNaPaginaTabelaComTodos_HouveErroPrevioValidacao := AbortarCancelarPost;

  if AbortarCancelarPost then
  begin
    EdicaoNaPaginaTabelaComTodos_NomeCampo                := '';
    EdicaoNaPaginaTabelaComTodos_HouveErroPrevioValidacao := True;

    DataSet.Cancel;

    if ( MarcadorPosicaoRegistroAntesInserirNovoParaVoltarCasoCancele <> Nil ) then
    begin
      cdsClientDataSetCrud.GotoBookmark( MarcadorPosicaoRegistroAntesInserirNovoParaVoltarCasoCancele );
      cdsClientDataSetCrud.FreeBookmark( MarcadorPosicaoRegistroAntesInserirNovoParaVoltarCasoCancele );
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.cdsClientDataSetCrudAfterCancel(
  DataSet: TDataSet);
begin
  if ( Trim( EdicaoNaPaginaTabelaComTodos_MotivoCancelamento ) <> '' ) then
  begin
    EsperarSegundos( 0.25, False );

    frmPrincipal.AcionarFormProsseguir(
      EdicaoNaPaginaTabelaComTodos_MotivoCancelamento,
      '',
      '',
      'Prosseguir',
      False );
  end;

  {Resetar Mecanismo Que Permite Editar e Validar Edi��es Na Pr�pria Tabela Com
   Todos Os Registros:}
  EdicaoNaPaginaTabelaComTodos_NomeCampo          := '';
  EdicaoNaPaginaTabelaComTodos_MotivoCancelamento := '';
end;

procedure TfrmDialogoCrudClientes.spdRegistroInicialClick(Sender: TObject);
begin
  cdsClientDataSetCrud.First;

  AtualizarBotoesDeNavegacao;
end;

procedure TfrmDialogoCrudClientes.spdRegistroAnteriorClick(Sender: TObject);
begin
  cdsClientDataSetCrud.Prior;

  AtualizarBotoesDeNavegacao;
end;

procedure TfrmDialogoCrudClientes.spdRegistroSeguinteClick(Sender: TObject);
begin
  cdsClientDataSetCrud.Next;

  AtualizarBotoesDeNavegacao;
end;

procedure TfrmDialogoCrudClientes.spdRegistroFinalClick(Sender: TObject);
begin
  cdsClientDataSetCrud.Last;

  AtualizarBotoesDeNavegacao;
end;

{
A Fun��o Abaixo Grava Uma Imagem, Que Esteja Gravada Em Arquivo Ou Contida Em Um "TImage",
Dentro De Um Campo "Blob" De Uma Tabela Do Banco De Dados. Para Imagem Em Arquivo, Deve-se
Informar o Nome Completo Do Arquivo No Par�metro "NomeCompletoArquivoContendoImagem" Com
"Nil" No Par�metro "ImagemOrigem". Por Outro Lado, Para Gravar a Partir Do Conte�do De Um
"TImagem", Passe Este "TImagem" No Par�metro "ImagemOrigem" e Deixe Vazio, Em Branco, o
Par�metro "NomeCompletoArquivoContendoImagem".

Os Formatos Permitidos Para Esta Imagem a Ser Gravada S�o JPeg, Bitmap, Gif e PNG.

A Fun��o Retornar� "True" Se Correr Tudo Bem e "False" Se Houver Algum Problema.

Para Fins De Documenta��o, Recomenda-se Que o Campo "Blob" Que Dever� Ser Criado Na
Tabela, e Que Suportar� a Grava��o Da Imagem, Seja Criado Com Os Seguintes Padr�es:

  Segment Size = 80
  SubType      = 0

Na Pr�tica o Script DDL Da Cria��o Deste Campo Ser� Simplesmente Ao Do Tipo:

  FOTO BLOB
}
function TfrmDialogoCrudClientes.GravarImagemGraphicContidaEmArquivoOuTImageComDestinoAUmCampoBlob(
  var ClientDataSet: TClientDataSet;
  NomeDoCampoBlob: String;
  NomeCompletoArquivoContendoImagem: String;
  const ImagemOrigem: TImage ): Boolean;
var
  Picture: TPicture;
  Bitmap: TBitmap;
  Jpeg: TJpegImage;
  ImagemStream: TMemoryStream;
begin
  Result := False;

  {A Origem Poss�vel Pode Ser Um Jpeg Gravado Em Arquivo, Mas Tamb�m, Quando o Nome
   Deste Arquivo � Passado Em Branco, Pode Ser, Em Qualquer Formato "Graphic", o Que
   Estiver Em Um TImage:}
  NomeCompletoArquivoContendoImagem := Trim( NomeCompletoArquivoContendoImagem );
  if ( ( FileExists( NomeCompletoArquivoContendoImagem ) ) or
       ( NomeCompletoArquivoContendoImagem = '' ) ) then
  begin
    {Todos Estes Tipos Abaixo S�o Necess�rios Porque Se Pretende Receber e Tratar Formatos
     Diversos Como JPeg, Bitmap, Gif e PNG, Todos Os Quais Dever�o Ao Final Ser Convertidos Ao
     JPeg, Sendo Este o Formato "Mais Leve" De Todos, Para Grava��o No Banco De Dados:}
    Picture := TPicture.Create;  // Picture Gen�rica Que Poder� Receber JPeg, Bitmap ou PNG
    Bitmap := TBitmap.Create;    // Bitmap Que Pode Pode Receber a Convers�o De Qualquer Picture Gen�rica
    Jpeg := TJpegImage.Create;   // Jpeg Que Receber� o Bitmap Convertido, Com Armazenamento "Mais Leve"

    ImagemStream := TMemoryStream.Create;

    try
      {Conforme Tenha Recebido a Imagem a Ser Gravada No Banco De Dados Proveniente De
       Um Arquivo Gravado Ou Contida Em Um "TImage", Como Est� Tratando Poss�veis Formatos
       Diversos De Imagem (JPeg, Bitmap, Gif ou PNG), Primeiro Ler Ou Aplicar Esta Imagem
       Em Um "TPicture" Gen�rico:}
      if ( NomeCompletoArquivoContendoImagem <> '' ) then
        Picture.LoadFromFile( NomeCompletoArquivoContendoImagem )  // Passou Uma Imagem Graphic Contida Em Arquivo
      else
        Picture.Assign( ImagemOrigem.Picture.Graphic );            // Passou Uma Imagem Graphic Contida Em "TImage"

      {Transformar Este Formato "TPicture" Gen�rico Para "TBitmap" Padronizado:}
      Bitmap.Assign( Picture.Graphic );

      {Transformar Este Formato "TBitmap" Padronizado Para "TJpegImage" Que Ser� o
       Que Ocupar� Menor Espa�o No Banco De Dados:}
      JPeg.Assign( Bitmap );

      Jpeg.SaveToStream( ImagemStream );

      TBlobField( ClientDataSet.FieldByName( NomeDoCampoBlob ) ).BlobType := ftGraphic;
      TBlobField( ClientDataSet.FieldByName( NomeDoCampoBlob ) ).LoadFromStream( ImagemStream );

      Result := True;
    finally
      ImagemStream.Free;

      Jpeg.Free;
      Bitmap.Free;
      Picture.Free;
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.LerImagemContidaCampoBlobParaJPegComAvatarGenericoSeForNecessario(
  var ClientDataSet: TClientDataSet;
  NomeDoCampoBlob: String;
  SexoParaAvatarGenericoSePrecisar: String;
  var JPegDestino: TJPegImage );
var
  ImagemStream: TMemoryStream;
  NomeCompletoPadraoArquivoImagemAvatar: String;
begin
  if ( TBlobField( ClientDataSet.FieldByName( NomeDoCampoBlob ) ).BlobSize <> 0 ) then
  begin
    ImagemStream := TMemoryStream.Create;

    TBlobField( ClientDataSet.FieldByName( NomeDoCampoBlob ) ).SaveToStream( ImagemStream );

    JpegDestino.Assign( TBlobField( ClientDataSet.FieldByName( NomeDoCampoBlob ) ) );

    ImagemStream.Free;
  end
  else
  begin
    {Como o Blob Com a Imagem Est� Vazio, Ent�o For�ar a Imagem Padr�o Avatar Conforme o
     Sexo:}

    NomeCompletoPadraoArquivoImagemAvatar :=
      ExtractFilePath( Application.ExeName ) + '\Operacao\Imagens\avatar_';

    if ( LeftStr( SexoParaAvatarGenericoSePrecisar, 1 ) = 'F' ) then
      JPegDestino.LoadFromFile( NomeCompletoPadraoArquivoImagemAvatar + 'feminino.jpg' )
    else
      JPegDestino.LoadFromFile( NomeCompletoPadraoArquivoImagemAvatar + 'masculino.jpg' )
  end;
end;

procedure TfrmDialogoCrudClientes.LerImagemContidaCampoBlobParaTImageComAvatarGenericoSeForNecessario(
  var ClientDataSet: TClientDataSet;
  NomeDoCampoBlob: String;
  SexoParaAvatarGenericoSePrecisar: String;
  var ImagemDestino: TImage );
var
  Jpeg: TJPEGImage;
begin
  Jpeg := TJPEGImage.Create;

  LerImagemContidaCampoBlobParaJPegComAvatarGenericoSeForNecessario(
    ClientDataSet,
    NomeDoCampoBlob,
    SexoParaAvatarGenericoSePrecisar,
    JPeg );

  ImagemDestino.Picture.Assign( JPeg );

  JPeg.Free;
end;

procedure TfrmDialogoCrudClientes.cdsClientDataSetCrudAfterScroll(
  DataSet: TDataSet);
begin
  if ( ( cdsClientDataSetCrud.State <> dsEdit   ) and
       ( cdsClientDataSetCrud.State <> dsInsert ) ) then
  begin
    {Aplicar Altera��es Ao Banco De Dados:}
    cdsClientDataSetCrud.ApplyUpdates( 0 );

    cdsClientDataSetCrud.Refresh;
  end;

  lblNomeClienteFichaComUm.Caption :=
    UpperCase_SoCaracteresIniciais( cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString );

  LerImagemContidaCampoBlobParaTImageComAvatarGenericoSeForNecessario(
    cdsClientDataSetCrud,
    NomeCampoLogicoBlobContendoFoto,
    dbcSexo.Text,
    imgFoto );
end;

procedure TfrmDialogoCrudClientes.dbcSexoChange(Sender: TObject);
begin
  LerImagemContidaCampoBlobParaTImageComAvatarGenericoSeForNecessario(
    cdsClientDataSetCrud,
    NomeCampoLogicoBlobContendoFoto,
    dbcSexo.Text,
    imgFoto );
end;

procedure TfrmDialogoCrudClientes.spdEscolherFotoClick(Sender: TObject);
begin
  if ( opdSelecionarFoto.Execute ) then
  begin
    try
      imgFoto.Picture.LoadFromFile( opdSelecionarFoto.FileName );
    except
      frmPrincipal.AcionarFormProsseguir(
        'Houve Erro Na Leitura Deste Arquivo De Imagem!' + RetornoDeCarro( 02 ) +
        'Por Favor, Verifique Se Ele Cont�m Uma Imagem V�lida Com Foto.',
        '',
        '',
        'Prosseguir',
        False );

      Exit;
    end;

    try
      ColocarEmEstadoDeEdicaoSeJaNaoEstiver;

      if ( GravarImagemGraphicContidaEmArquivoOuTImageComDestinoAUmCampoBlob(
             cdsClientDataSetCrud,
             NomeCampoLogicoBlobContendoFoto,
             opdSelecionarFoto.FileName,
             Nil ) ) then
      begin
        {A A��o Abaixo Aparentemente N�o Seria Necess�ria Porque Consiste Em Ler a
         Mesma Imagem Que Acabou De Ser Gravada Acima Com Sucesso. Mas Aqui Ela �
         Necess�ria Porque a Imagem Gravada Pode Estar Eventualmente Em Formato GIF
         Sendo Um GIF Animado. Neste Caso Somente o Primeiro Quadro Do GIF Animado
         Foi Efetivamente Gravado, e a Sua Releitura Deixar� Isto Imediatamente Claro
         Ao Usu�rio:}
        LerImagemContidaCampoBlobParaTImageComAvatarGenericoSeForNecessario(
          cdsClientDataSetCrud,
          NomeCampoLogicoBlobContendoFoto,
          dbcSexo.Text,
          imgFoto );
      end;
    except
      {Nada}
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.spdLimparFotoClick(Sender: TObject);
begin
  {Verificar Se a Foto J� N�o Est� Limpa. Neste Caso N�o Precisa Limpar De Novo:}
  if ( TBlobField( cdsClientDataSetCrud.FieldByName( NomeCampoLogicoBlobContendoFoto ) ).BlobSize = 0 ) then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'N�o H� Foto Real Para Ser Removida,' + RetornoDeCarro( 01 ) +
      'Mas Apenas Uma Imagem Ilustrativa Gen�rica.',
      '',
      '',
      'Prosseguir',
      False );
  end
  else
  begin
    if ( frmPrincipal.AcionarFormProsseguir(
           'Foi Solicitado Remover a Foto Deste Cadastro.' + RetornoDeCarro( 02 ) +
           'Com Esta Remo��o a Foto Que Passar� a Ser Exibida Ser�' + RetornoDeCarro( 01 ) +
           'Uma Imagem Ilustrativa Gen�rica Padr�o.' + RetornoDeCarro( 02 ) +
           'Confirma Remover Esta Foto?',
          '',
          'N�o, Preservar',
          'Sim, Remover',
          False ) = mrYes ) then
    begin
      ColocarEmEstadoDeEdicaoSeJaNaoEstiver;

      TBlobField( cdsClientDataSetCrud.FieldByName( NomeCampoLogicoBlobContendoFoto ) ).Clear;

      LerImagemContidaCampoBlobParaTImageComAvatarGenericoSeForNecessario(
        cdsClientDataSetCrud,
        NomeCampoLogicoBlobContendoFoto,
        dbcSexo.Text,
        imgFoto );
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.imgFotoClick(Sender: TObject);
begin
  spdExpandirReduzirFotoClick( Sender );
end;

procedure TfrmDialogoCrudClientes.ReduzirFotoSeEstiverExpandida;
begin
  if ( pnlFoto.Left = 000 ) then
    spdExpandirReduzirFotoClick( Self );
end;

procedure TfrmDialogoCrudClientes.spdExpandirReduzirFotoClick(Sender: TObject);
var
  MargemHorizontalEntreBotoes: Double;
begin
  if ( pnlFoto.Left <> 000 ) then
  begin
    {Expandir Painel Que Mostra a Foto:}

    scbFichaCrud.HorzScrollBar.Visible := False;
    scbFichaCrud.VertScrollBar.Visible := False;

    pnlFoto.Left   := 000;
    pnlFoto.Top    := 000;
    pnlFoto.Width  := scbFichaCrud.Width;
    pnlFoto.Height := scbFichaCrud.Height;

    pnlFoto.BringToFront;

    spdEscolherFoto.Parent        := pnlFoto;
    spdRodar90GrausDireita.Parent := pnlFoto;
    spdExpandirReduzirFoto.Parent := pnlFoto;
    spdLimparFoto.Parent          := pnlFoto;

    spdRecuperarFoto.Visible      := True;
  end
  else
  begin
    {Reduzir Painel Que Mostra a Foto:}

    scbFichaCrud.HorzScrollBar.Visible := True;
    scbFichaCrud.VertScrollBar.Visible := True;

    pnlFoto.Left   := 004;
    pnlFoto.Top    := 012;
    pnlFoto.Width  := 196;
    pnlFoto.Height := 264;

    pnlFoto.SendToBack;

    spdEscolherFoto.Parent        := scbFichaCrud;
    spdRodar90GrausDireita.Parent := scbFichaCrud;
    spdExpandirReduzirFoto.Parent := scbFichaCrud;
    spdLimparFoto.Parent          := scbFichaCrud;

    spdRecuperarFoto.Visible      := False;

    MargemHorizontalEntreBotoes :=
      ( pnlFoto.Width - 8 - 4 * spdEscolherFoto.Width ) / 3;

    spdEscolherFoto.Left          :=
      pnlFoto.Left + 4;
    spdRodar90GrausDireita.Left   :=
      Round( spdEscolherFoto.Left        + spdEscolherFoto.Width        + MargemHorizontalEntreBotoes );
    spdExpandirReduzirFoto.Left   :=
      Round( spdRodar90GrausDireita.Left + spdRodar90GrausDireita.Width + MargemHorizontalEntreBotoes );
    spdLimparFoto.Left            :=
      Round( spdExpandirReduzirFoto.Left + spdExpandirReduzirFoto.Width + MargemHorizontalEntreBotoes );

    spdEscolherFoto.Top        := pnlFoto.Top + pnlfoto.Height + 4;
    spdRodar90GrausDireita.Top := spdEscolherFoto.Top;
    spdExpandirReduzirFoto.Top := spdEscolherFoto.Top;
    spdLimparFoto.Top          := spdEscolherFoto.Top;
  end;

  imgFoto.Height := pnlFoto.Height;
  imgFoto.Width := Round( 3 * imgFoto.Height / 4 );

  imgFoto.Left := 0;
  imgFoto.Top  := Round( ( pnlFoto.Height - imgFoto.Height ) / 2 );

  lblNomeClienteFichaComUm.Left :=
    imgFoto.Left + imgFoto.Width + 8;
  lblNomeClienteFichaComUm.Top  :=
    Round( ( pnlFoto.Height - lblNomeClienteFichaComUm.Height - 2 * spdEscolherFoto.Height - 8  ) / 2 );

  if ( pnlFoto.Left = 000 ) then
  begin
    spdEscolherFoto.Left        :=
      imgFoto.Left                + imgFoto.Width                + 8;
    spdRodar90GrausDireita.Left :=
      spdEscolherFoto.Left        + spdEscolherFoto.Width        + 8;
    spdExpandirReduzirFoto.Left :=
      spdRodar90GrausDireita.Left + spdRodar90GrausDireita.Width + 8;
    spdLimparFoto.Left          :=
      spdExpandirReduzirFoto.Left + spdExpandirReduzirFoto.Width + 8;

    spdEscolherFoto.Top         := pnlFoto.Height - spdEscolherFoto.Height - 8;
    spdRodar90GrausDireita.Top  := spdEscolherFoto.Top;
    spdExpandirReduzirFoto.Top  := spdEscolherFoto.Top;
    spdLimparFoto.Top           := spdEscolherFoto.Top;

    spdRecuperarFoto.Left       := spdEscolherFoto.Left;
    spdRecuperarFoto.Top        := spdEscolherFoto.Top - spdRecuperarFoto.Height - 8 
  end;
end;

procedure TfrmDialogoCrudClientes.spdRodar90GrausDireitaClick(Sender: TObject);
var
  Bitmap: TBitmap;
begin
  {Somente Far� a Rota��o Da Imagem Foto Contida No Blob Se Ela Realmente Existir:}
  if ( TBlobField( cdsClientDataSetCrud.FieldByName( NomeCampoLogicoBlobContendoFoto ) ).BlobSize = 0 ) then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'N�o H� Foto Real Para Ser Rotacionada,' + RetornoDeCarro( 01 ) +
      'Mas Apenas Uma Imagem Ilustrativa Gen�rica.',
      '',
      '',
      'Prosseguir',
      False );
  end
  else
  begin
    {Pegar a Imagem Em Apresenta��o e Converter Para Bitmap. Em Seguida, Rotaciona-la
     Em Noventa Graus Decimais Para a Direita. Atribuir Resultado � Pr�pria Imagem Em
     Apresenta��o, Que Ficar� Em Formato Bitmap, Mas Apenas Nesta Camada De Apresenta��o:}
    Bitmap := TBitmap.Create;
    Bitmap.Assign( imgFoto.Picture.Graphic );
    FI_Bitmap_Rotacionado(
      Bitmap,
      90,
      True,
      clBlack );
    imgFoto.Picture.Assign( Bitmap );
    imgFoto.Repaint;
    Bitmap.Free;

    {Colocar Registro Em Edi��o Caso N�o Esteja:}
    ColocarEmEstadoDeEdicaoSeJaNaoEstiver;

    {Gravar Imagem Em Apresenta��o Para o Campo Blob Contendo a Foto. No Procedimento
     Abaixo Ela Ser� Reconvertida Para Formato JPeg e Ser� Gravada:}
    GravarImagemGraphicContidaEmArquivoOuTImageComDestinoAUmCampoBlob(
      cdsClientDataSetCrud,
      NomeCampoLogicoBlobContendoFoto,
      '',
      imgFoto );
  end;
end;

procedure TfrmDialogoCrudClientes.MostarOuEsconderOpcoesDoMenuPainelEsquerdo(
  Mostrar: Boolean );
var
  ContadorControles: Integer;
  RotuloLabel: TLabel;
begin
  for ContadorControles := 0 to pnlEsquerdo.ControlCount - 1 do
  begin
    if ( pnlEsquerdo.Controls[ ContadorControles ] is TLabel ) then
    begin
      RotuloLabel := TLabel( pnlesquerdo.Controls[ ContadorControles ] );

      RotuloLabel.Visible := Mostrar;
    end;
  end;
end;

function TfrmDialogoCrudClientes.CalcularTempoRestante(
  TempoInicial, TempoAtual: TDateTime;
  ContadorAtual, ContadorTotal: Integer ): String;
var
  TempoRestante: TDateTime;
begin
  {Calcular Produto Da Multiplica��o Da Quantidade De Cadastros De Processamento Restantes a Fazer
   Vezes a M�dia De Tempo Que Tomou Com Cada Um Dos Cadastros J� Antes Processados:}
  TempoRestante := ( ContadorTotal - ContadorAtual ) * ( ( TempoAtual - TempoInicial ) / ContadorAtual );
  Result := FormatDateTime( 'hh:mm:ss "hs"', TempoRestante );
end;

procedure TfrmDialogoCrudClientes.spdCancelarExportacaoCSVClick(
  Sender: TObject);
begin
  ComutarPaginasEntreTabelaComTodosFichaComUm( tshTabelaComTodos );
  MostarOuEsconderOpcoesDoMenuPainelEsquerdo( True );
end;

procedure TfrmDialogoCrudClientes.spdRecuperarFotoClick(Sender: TObject);
var
  Prosseguir: Boolean;
  Jpeg: TJpegImage;
begin
  {Verificar Se a Foto Realmente Existe No Banco De Dados, Antes Que Possa Ser Gravada e
   Recuperada:}
  if ( TBlobField( cdsClientDataSetCrud.FieldByName( NomeCampoLogicoBlobContendoFoto ) ).BlobSize = 0 ) then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'N�o H� Foto Real Para Ser Exportada,' + RetornoDeCarro( 01 ) +
      'Mas Apenas Uma Imagem Ilustrativa Gen�rica.',
      '',
      '',
      'Prosseguir',
      False );
  end
  else
  begin
    odgSelecionarFoto.FileName := 'Foto_' + dbeNome.Text;

    if ( odgSelecionarFoto.Execute ) then
    begin
      Prosseguir := not FileExists( odgSelecionarFoto.FileName );

      {Caso o Arquivo J� Exista, Confirmar Autoriza��o Para Escrever Por Cima:}
      if not Prosseguir then
        Prosseguir := (
          frmPrincipal.AcionarFormProsseguir(
          'J� Existe Um Arquivo Gravado' + RetornoDeCarro( 01 ) +
          'Com Este Mesmo Nome!' + RetornoDeCarro( 02 ) +
          'Deseja Gravar Sobre o Existente?',
          '',
          'Cancelar',
          'Prosseguir',
          False ) = mrYes );

      if Prosseguir then
      begin
        Jpeg := TJPEGImage.Create;

        LerImagemContidaCampoBlobParaJPegComAvatarGenericoSeForNecessario(
          cdsClientDataSetCrud,
          NomeCampoLogicoBlobContendoFoto,
          dbcSexo.Text,
          JPeg );

        JPeg.SaveToFile( odgSelecionarFoto.FileName );

        JPeg.Free;

        frmPrincipal.AcionarFormProsseguir(
          'Exporta��o De Foto Conclu�da! O Resultado Est� No Arquivo:' + RetornoDeCarro( 02 ) +
          WrapText(
            odgSelecionarFoto.FileName,
            RetornoDeCarro( 01 ),
            [' ', '.', ':', ';', ',', '-', '_', '\' ],
            60 ),
          '',
          '',
          'Prosseguir',
          False );
      end;
    end;
  end;
end;

function TfrmDialogoCrudClientes.ConsultaPontuacaoCondutor_DetranMG_SiteEm_21_09_2019(
  WebBrowser: TwebBrowser;
  TipoCNHNova: Boolean;
  NumeroDeRegistroCNH: String;
  DataDeNascimento: String;
  DataDaPrimeiraHabilitacao: String ): TPontuacaoCNH;
var
  Resposta: String;

  procedure PressionarBotao( Botao: String );
  var
    BotoesDisponiveis: OleVariant;
    BotaoAtual: OleVariant;
    ContadorBotoes: Integer;
  begin
    Botao := AnsiUpperCase( Botao );

    BotoesDisponiveis := WebBrowser.OleObject.Document.getElementsByTagName( 'button' );
    for ContadorBotoes := 0 to BotoesDisponiveis.Length - 1 do
    begin
      BotaoAtual := BotoesDisponiveis.item( ContadorBotoes );

      if ( BotaoAtual.innerText = Botao ) then
      begin
        BotaoAtual.click();
        Break;
      end;
    end;
  end;

  procedure EsperarEstabilizacao;
  begin
   while ( WebBrowser.ReadyState <> READYSTATE_COMPLETE ) or
         ( WebBrowser.Busy ) do
     Application.ProcessMessages;

   EsperarSegundos( 1, False );
  end;

begin
  {Inicializar Navegador Web Que Consulta Pontua��o De Carteira Nacionak De Habilita��o:}
  WebBrowser.Navigate( URLConsultaPontosDetranMG );
  EsperarSegundos( 2, False );

  if TipoCNHNova then
    WebBrowser.OleObject.Document.All.ConsultarPontuacaoCondutorTipoCnh1.Checked := True
  else
    WebBrowser.OleObject.Document.All.ConsultarPontuacaoCondutorTipoCnh2.Checked := True;

  WebBrowser.OleObject.Document.all.Item( 'data[ConsultarPontuacaoCondutor][numero_cnh]', 0 ).value :=
    NumeroDeRegistroCNH;

  WebBrowser.OleObject.Document.all.Item( 'data[ConsultarPontuacaoCondutor][data_nascimento]', 0 ).value :=
    DataDeNascimento;

  WebBrowser.OleObject.Document.all.Item( 'data[ConsultarPontuacaoCondutor][data_primeira_habilitacao]', 0 ).value :=
    DataDaPrimeiraHabilitacao;

  PressionarBotao( 'PESQUISAR' );

  EsperarEstabilizacao;

  Resposta := Variant( WebBrowser.Document ).Body.InnerHTML;

  if      ( ( Pos( 'Nao consta pontuacao para esse condutor', Resposta ) > 0 ) or
            ( Pos( 'Total de Pontos:'                       , Resposta ) > 0 ) and
            ( Pos( '0000'                                   , Resposta ) > 0 ) ) then
    Result := pcNaoTemPontuacao

  else if ( ( Pos( 'Nome:'          , Resposta ) > 0 ) and
            ( Pos( 'CNH:'           , Resposta ) > 0 ) and
            ( Pos( 'UF:'            , Resposta ) > 0 ) and
            ( Pos( 'Total de Pontos:', Resposta ) > 0 ) ) then
    Result := pcSimTemPontuacao

  else
    Result := pcIncertoQuantoPontuacao;
end;

procedure TfrmDialogoCrudClientes.dbcEnderecoBairroDropDown(
  Sender: TObject);
begin
  AbrirComboComOpcoesJaCadastradasEmUmaTabelaECampo(
    dbcEnderecoBairro,
    NomeTabelaOperadaPeloCrud,
    'ENDERECOBAIRRO',
    True );
end;

procedure TfrmDialogoCrudClientes.dbcEnderecoMunicipioDropDown(
  Sender: TObject);
begin
  AbrirComboComOpcoesJaCadastradasEmUmaTabelaECampo(
    dbcEnderecoMunicipio,
    NomeTabelaOperadaPeloCrud,
    'ENDERECOMUNICIPIO',
    True );
end;

procedure TfrmDialogoCrudClientes.spdConsultarCEPClick(Sender: TObject);
var
  Logradouro, Bairro, Municipio, Estado, Pais: String;
  Stream: TStringStream;
  JSon: TlkJSONBase;

  function LimparCep( Cep: String ): String;
  var
    Cont: Integer;
  begin
    Result := '';
    for Cont := 1 to Length( Cep ) do
      if ( Pos( Cep[ Cont ], '0123456789' ) > 0 ) then
        Result := Result + Cep[ Cont ];
  end;

  function PegarStringJson( PalavraChave: String ): String;
  begin
    Result := '';

    JSon := TlkJSON.ParseText( Stream.DataString );
    if ( Assigned( JSon ) ) then
    begin
      JSon := JSon.Field[ PalavraChave ];
      if ( Assigned( JSon ) ) then
        Result := VarToStr( JSon.Value );
    end;
  end;

  function CepCode_CepParaEndereco_ViaCepJSon(
    Cep: String;
    var Logradouro, Bairro, Municipio, Estado, Pais: String ): String;
  const
    URLCepCodePadrao = 'https://viacep.com.br/ws/<<<CEP>>>/json/';
  var
    LinkCepCode: String;
  begin
    Result := '';

    Cep := LimparCep( Cep );

    if ( Cep <> '' ) then
    begin
      LinkCepCode := StringReplace( URLCepCodePadrao, '<<<CEP>>>', Cep, [] );
      LinkCepCode := UTF8Encode( LinkCepCode );

      Stream := TStringStream.Create( '' );

      WinInet_HttpsPost(
        LinkCepCode,
        Stream );

      EsperarSegundos( 0.5, False );

      if ( Stream.DataString <> '' ) then
      begin
        Logradouro := PegarStringJson( 'logradouro' );
        Bairro     := PegarStringJson( 'bairro' );
        Municipio  := PegarStringJson( 'localidade' );
        Estado     := PegarStringJson( 'uf' );

        Pais := 'Brasil';

        if ( Logradouro <> '' ) then
          Result := Logradouro + ', ' + Bairro + ', ' + Municipio + ', ' + Estado + ', ' + Pais + ', ' + Cep;
      end;

      Stream.Free;
    end;
  end;

begin
  if ( Pos( ' ', dbeEnderecoCEP.Text ) > 0 ) then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'Para Preenchimento Autom�tico Do Endere�o a Partir Do CEP �' + RetornoDeCarro( 01 ) +
      'Necess�rio Informar Um CEP V�lido.' + RetornoDeCarro( 02 ) +
      'Todos Os Campos De Endere�o Ser�o Automaticamente Preenchidos' + RetornoDeCarro( 01 ) +
      'Exceto o N�mero No Logradouro e o Seu Eventual Complemento.' + RetornoDeCarro( 02 ) +
      'Por Favor, Digite Um CEP V�lido.',
      '',
      '',
      'Prosseguir',
      False );
  end
  else
  begin
    if CepCode_CepParaEndereco_ViaCepJSon(
      dbeEnderecoCEP.Text,
      Logradouro, Bairro, Municipio, Estado, Pais ) = '' then
    begin
      frmPrincipal.AcionarFormProsseguir(
        'Por Favor, Verifique o CEP Digitado!',
        'Por Favor, Digite Um CEP V�lido.',
        '',
        'Prosseguir',
        False );
    end
    else
    begin
      ColocarEmEstadoDeEdicaoSeJaNaoEstiver;

      cdsClientDataSetCrud.FieldByName( 'ENDERECOLOGRADOURO' ).AsString := AnsiUpperCase( Logradouro );
      cdsClientDataSetCrud.FieldByName( 'ENDERECOBAIRRO' ).AsString     := AnsiUpperCase( Bairro );
      cdsClientDataSetCrud.FieldByName( 'ENDERECOMUNICIPIO' ).AsString  := AnsiUpperCase( Municipio );
      cdsClientDataSetCrud.FieldByName( 'ENDERECOUF' ).AsString         := AnsiUpperCase( Estado );
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.dbeEnderecoCEPExit(Sender: TObject);
begin
  if ( Trim( cdsClientDataSetCrud.FieldByName( 'ENDERECOCEP' ).AsString ) <> '' ) then
  begin
    if ( ( Trim( cdsClientDataSetCrud.FieldByName( 'ENDERECOLOGRADOURO' ).AsString ) = '' ) and
         ( Trim( cdsClientDataSetCrud.FieldByName( 'ENDERECOBAIRRO'     ).AsString ) = '' ) and
         ( Trim( cdsClientDataSetCrud.FieldByName( 'ENDERECOMUNICIPIO'  ).AsString ) = '' ) and
         ( Trim( cdsClientDataSetCrud.FieldByName( 'ENDERECOUF'         ).AsString ) = '' ) ) then
    begin
      spdConsultarCEPClick( Sender );
    end;
  end;
end;

procedure TfrmDialogoCrudClientes.dbrAnotacoesEnter(Sender: TObject);
begin
  ColocarEmEstadoDeEdicaoSeJaNaoEstiver;

  dbrAnotacoes.Width :=
    lblEnderecoComplemento.Left + lblEnderecoComplemento.Width - dbrAnotacoes.Left;

  lblAnotacoes.Width := dbrAnotacoes.Width;
  lblAnotacoes.Caption := 'Anota��es (d� duplo clique no mouse para reduzir)';
end;

procedure TfrmDialogoCrudClientes.dbrAnotacoesExit(Sender: TObject);
begin
  dbrAnotacoes.Width :=
    pnlFoto.Width;

  lblAnotacoes.Width := dbrAnotacoes.Width;

  lblAnotacoes.Caption := 'Anota��es';
end;

procedure TfrmDialogoCrudClientes.ColocarEmEstadoDeEdicaoSeJaNaoEstiver;
begin
  if ( ( cdsClientDataSetCrud.State <> dsEdit   ) or
       ( cdsClientDataSetCrud.State <> dsInsert ) ) then
    cdsClientDataSetCrud.Edit;
end;

procedure TfrmDialogoCrudClientes.FormActivate(Sender: TObject);
begin
  {Arredondar Cantos Do "Form" De "Crud":}
  Form_ArredondarCantos(
    Self,
    60 );
end;

procedure TfrmDialogoCrudClientes.dbrAnotacoesDblClick(Sender: TObject);
begin
  if ( dbrAnotacoes.Width = pnlFoto.Width ) then
    dbrAnotacoesEnter( Sender )
  else
    dbrAnotacoesExit( Sender );
end;

procedure TfrmDialogoCrudClientes.lblEmailXMLClick(Sender: TObject);
var
  Anexos: TSTringList;
  NomeArquivoXML: String;
  ConteudoXML: TStringList;

  procedure GerarXML;
  var
    XMLDocument: TXMLDocument;
    NoTabela, NoRegistro, NoTelefone, NoEndereco: IXMLNode;
  begin
    NomeArquivoXML :=
      NomePastaParaArquivosTemporariosDestaSessao +
      'Dados_XML_' + FormatDateTime( 'yyyymmddhhmmsszzz', Now ) + '.xml';

    XMLDocument := TXMLDocument.Create(Self);
    try
      XMLDocument.Active := True;
      NoTabela := XMLDocument.AddChild( 'Cliente' );

      NoRegistro := NoTabela.AddChild( 'DadosCadastrados' );
      NoRegistro.ChildValues[ 'Nome' ]           := cdsClientDataSetCrudNOME.AsString;
      NoRegistro.ChildValues[ 'CPF' ]            := cdsClientDataSetCrudCPF.AsString;
      NoRegistro.ChildValues[ 'Identidade' ]     := cdsClientDataSetCrudCNH.AsString;
      NoRegistro.ChildValues[ 'DataNascimento' ] := cdsClientDataSetCrudDTANASC.AsString;
      NoRegistro.ChildValues[ 'Area' ]           := cdsClientDataSetCrudAREA.AsString;
      NoRegistro.ChildValues[ 'Funcao' ]         := cdsClientDataSetCrudFUNCAO.AsString;
      NoRegistro.ChildValues[ 'Genero' ]         := cdsClientDataSetCrudSEXO.AsString;

      NoTelefone := NoRegistro.AddChild( 'TelefoneEmail' );
      NoTelefone.ChildValues[ 'TelefoneFixo'  ]  := cdsClientDataSetCrudTELEFONEFIXO.AsString;
      NoTelefone.ChildValues[ 'TelefoneMovel' ]  := cdsClientDataSetCrudTELEFONEMOVEL.AsString;
      NoTelefone.ChildValues[ 'Email' ]          := cdsClientDataSetCrudEMAIL.AsString;

      NoEndereco := NoRegistro.AddChild( 'Endereco' );
      NoEndereco.ChildValues[ 'Logradouro' ]     := cdsClientDataSetCrudENDERECOLOGRADOURO.AsString;
      NoEndereco.ChildValues[ 'Numero' ]         := cdsClientDataSetCrudENDERECONUMERO.AsString;
      NoEndereco.ChildValues[ 'Complemento' ]    := cdsClientDataSetCrudENDERECOCOMPLEMENTO.AsString;
      NoEndereco.ChildValues[ 'Bairro' ]         := cdsClientDataSetCrudENDERECOBAIRRO.AsString;
      NoEndereco.ChildValues[ 'Municipio' ]      := cdsClientDataSetCrudENDERECOMUNICIPIO.AsString;
      NoEndereco.ChildValues[ 'UF' ]             := cdsClientDataSetCrudENDERECOUP.AsString;
      NoEndereco.ChildValues[ 'CEP' ]            := cdsClientDataSetCrudENDERECOCEP.AsString;

      XMLDocument.SaveToFile( NomeArquivoXML );
    finally
      XMLDocument.Free;
    end;
  end;

begin
  if ( ( Trim( cdsClientDataSetCrudEMAIL.AsString ) = '' ) or
       ( Pos( '@', cdsClientDataSetCrudEMAIL.AsString ) = 0 ) ) then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'N�o � Poss�vel Enviar o Email XML Com Os Dados Cadastrais Porque o Cliente' + RetornoDeCarro( 02 ) +
      cdsClientDataSetCrudNOME.AsString + RetornoDeCarro( 02 ) +
      'N�o Possui Um Endere�o De Email Cadastrado Em Seu Registro.' + RetornoDeCarro( 02 ) +
      'Cadastre Um Endere�o De Email Para Este Cliente e Tente Novamente.',
      '',
      '',
      'Prosseguir',
      False );
  end
  else
  begin
    if ( frmPrincipal.AcionarFormProsseguir(
           'Confirma Envio Dos Dados Cadastrais do Cliente' + RetornoDeCarro( 02 ) +
           cdsClientDataSetCrudNOME.AsString + RetornoDeCarro( 02 ) +
           'Para o Email' + RetornoDeCarro( 02 ) +
           cdsClientDataSetCrudEMAIL.AsString + RetornoDeCarro( 02 ) +
           'Confirma o Envio do Email XML?',
           '',
           'Cancelar',
           'Prosseguir',
           False ) = mrYes ) then
    begin
      GerarXML;

      Anexos := TSTringList.Create;
      Anexos.Clear;
      Anexos.Add( NomeArquivoXML );

      ConteudoXML := TStringList.Create;

      ConteudoXML.Clear;
      ConteudoXML.Add( 'Nome      : ' + cdsClientDataSetCrudNOME.AsString + '   ' );
      ConteudoXML.Add( 'CPF       : ' + cdsClientDataSetCrudCPF.AsString + '   ' );
      ConteudoXML.Add( 'Identidade: ' + cdsClientDataSetCrudCNH.AsString );

      if EnviarEmailCompletoInclusiveComSSL(
        'Sistema ' + NomeDestePrograma + ' v' + frmPrincipal.NumeroCompletoVersao,
         NomeUsuarioSMTPParaEnvioDeMensagensDeEmail,
         NomeDestePrograma + ' Email XML / ' + UpperCase_SoCaracteresIniciais( cdsClientDataSetCrudNOME.AsString ),
         NomeUsuarioSMTPParaEnvioDeMensagensDeEmail,
         SenhaUsuarioSMTPParaEnvioDeMensagensDeEmail,
         NomeServidorSMTPParaEnvioDeMensagensDeEmail,
         PortaServidorSMTPParaEnvioDeMensagensDeEmail,
         ServidorSMTPExigeAutenticarUsuario,
         ServidorSMTPExigeAutenticarSSL,
         IdMessage.mpHighest,
         frmPrincipal.NomeCompletoDestePrograma + RetornoDeCarro( 01 ) +
         'Mensagem Mail XML' + RetornoDeCarro( 01 ) +
         'Se Voc� Est� Recebendo Esta Mensagem, O Teste Ocorreu Com Sucesso',
         '.\Operacao\Mensagens_HTML\Envio_Email_XML\index.html',
         Trim( cdsClientDataSetCrudEMAIL.AsString ),
         EnderecoEmailQueRecebeCopiaDasMensagensEnviadas,
         Anexos,
         ConteudoXML,
         True,
         '',
         frmPrincipal.Logo_EnderecoEmailRetornoConformeConfigurado ) then
      begin
        frmPrincipal.AcionarFormProsseguir(
          'Mensagem De Email XML Enviada Com Sucesso Para' + RetornoDeCarro( 02 ) +
          Trim( cdsClientDataSetCrudEMAIL.AsString ) + RetornoDeCarro( 02 ) +
          'Por Favor, Verifique As Caixas De Entrada De Email Certificando-se De Que,' + RetornoDeCarro( 01 ) +
          'Devido Suas Eventuais Configura��es De Recebimento, Ela N�o Tenha Sido' + RetornoDeCarro( 01 ) +
          'Direcionada Por Erro � Lixeira Eletr�nica.',
          '',
          '',
          'Prosseguir',
          False )
      end
      else
      begin
        frmPrincipal.AcionarFormProsseguir(
          'O Envio Da Mensagem De Email XML N�o Foi Realizado.' + RetornoDeCarro( 02 ) +
          'H� Algum Problema Relacionado Ao Funcionamento Da' + RetornoDeCarro( 01 ) +
          'Rede, Conex�o Ou Acesso a Internet.',
          '',
          '',
          'Prosseguir',
          False );
      end;

      ConteudoXML.Free;
      Anexos.Free;

      if ( FileExists( NomeArquivoXML ) ) then
        ApagarArquivo( NomeArquivoXML, False );
    end;
  end;
end;

end.
