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
   Invisíveis, Apresenta Uma Borda de 04 Pixels Que Não Lhe Confere Um Aspecto "Flat"
   Perfeito. Assim, Realiza a Captura do Evento de Redimensionamento da Sua Classe de
   Origem Para Corrigir o Seu Aspecto Final Quando For Necessário:}
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
   Invisíveis, Apresenta Uma Borda de 04 Pixels Que Não Lhe Confere Um Aspecto "Flat"
   Perfeito. Assim, Realiza a Captura do Evento de Redimensionamento da Sua Classe de
   Origem Para Corrigir o Seu Aspecto Final Quando For Necessário:}

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
        'Está Com Erro e Não Confere Com Os Seus Dígitos De Verificação.' + RetornoDeCarro( 02 ) +
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
      'O Conteúdo Do Campo' + RetornoDeCarro( 02 ) +
      '"' + dbeCampoNaoVazio.Field.DisplayName + '"' + RetornoDeCarro( 02 ) +
      'Não Pode Ficar Vazio.' + RetornoDeCarro( 02 ) +
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
        'O Conteúdo Do Campo' + RetornoDeCarro( 02 ) +
        '"' + dbeCampoNaoDuplicavel.Field.DisplayName + '"' + RetornoDeCarro( 02 ) +
        'Preenchido Com o Valor' + RetornoDeCarro( 02 ) +
        '"' + Procurar + '"' + RetornoDeCarro( 02 ) +
        'Já Existe Em Pelo Menos Um Outro Cadastro:' + RetornoDeCarro( 02 ) +
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
  {Este Procedimento é Muito Útil Porque Valida a Digitação De Um Campo Contendo Uma Data De
   Calendário, Independente De Que Esta Digitação Seja Feira Diretamente Na Tabela Com Todos
   Os Registros  Ou Via Um "TDBEdit" Da Ficha Com Um Único Cadastro. E a Validação é Imadiata,
   Antes De Qualquer Outra Providência.

   Acontece Que o "EditMask" Dos Campos De Data Já Assegura Que As Datas Sejam Digitadas Com
   Formato Correto, "!99/99/9999;1;_". Mas Isto Não é Suficiente Porque o Usuário Pode Digitar,
   Mesmo Sob Formato Correto, Por Exemplo, Dia 40 Ou Mês 35 e Isto Irá Provocar Uma Excessão De
   Execução. O Uso Deste Proedimento Impede Este Problema e, Nestes Casos, Simplesmente Deixa o
   Campo De Data Calendário Com o Conteúdo Vazio, Sem Provocar Excessões De Execução.

   Para Seu Uso Efetivo, é Necessário Que Todos Os Campos Contendo Datas Calendário Existentes
   Na Tabela Do "Crud" Tenham Os Seus Eventos "OnSelText" Direcionados Para Este Procedimento.

   O Ideal é Que, No Início Da Execução, Os Campos Que Contiverem Datas Calendário Do Objeto
   "TClientDataSet", Por Exemplo, Dentro Do "cdsClientDataSetCrud" Sejam Varridos Com a Respectiva
   Setagen Da Propriedade "EditMask" Com "!99/99/9999;1;_" e Deste Presente Procedimento No Evento
   "OnSelText".}

  {Verificar Se a Data Digitada é Realmente Válida. Neste Caso Ela Ficará Como Digitada. Caso
   Contrário, Ela Retornará Ao Valor Original Antes Da Digitação Inválida:}
  if ( TryStrToSqlTimeStamp( Text, Value ) ) then
  begin
    {A Data é Válida e Ficará Como Digitada:}
    TSQLTimeStampField( Sender ).SetData( @Value, False )
  end;
end;

procedure TfrmDialogoCrudClientes.PrepararMascaraDeEdicaoValidacaoCamposContendoDataCalendario(
  var ClientDataSetCrud: TClientDataSet );
var
  ContadorCampos: Integer;
  CampoTipoDataCalendario: TSQLTimeStampField;
begin
  {Percorrer Todos Os Campos Da Tabela De "Crud" Preparando a Máscara De Edição e Validação
   Dos Campos Que Contenham Datas Calendário:}
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
  {Preservar Referência Do Registro Atual Em Que Está:}
  ConteudoCampoChave := cdsClientDataSetCrud.FieldByName( NomeCampoLogicoChavePrimaria ).AsString;

  {Abrir Tabela Do "Crud" Conforme Ordenação Desejada:}

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

  {Fazer Com Que Os Campos Cujo Conteúdo Sejam Datas Calendário Tenham As Suas Máscaras
   De Edição e Validação Devidamente Configuradas:}
  PrepararMascaraDeEdicaoValidacaoCamposContendoDataCalendario(
    cdsClientDataSetCrud );

  {Restabelecer Referência Do Registro Em Que Estava:}
  cdsClientDataSetCrud.Locate( NomeCampoLogicoChavePrimaria, ConteudoCampoChave, [] );

  AtualizarBotoesDeNavegacao;
end;

function TfrmDialogoCrudClientes.CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar: Boolean;
begin
  Result := False;

  {Caso Esteja Em Edição Ou Inserção, Fazer o Post Para Gravar:}
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
      'Para Poder Sair, Antes Será Necessário Aguardar a Completa' + RetornoDeCarro( 01 ) +
      'Execução Do Processo Em Andamento.' + RetornoDeCarro( 02 ) +
      'Também é Possível Interromper Este Processo Para Que Se Possa' + RetornoDeCarro( 01 ) +
      'Então Sair e o Deixando Para Fazer Novamente Depois.',
      '',
      '',
      'Prosseguir',
      False );
  end
  else
  begin
    {Caso Esteja Em Edição Ou Inserção, Fazer o Post Para Gravar:}
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

  {Definir Cores, Posições e Dimensões Dos Elementos Do "Form":}
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

  {Definir Cores Dos Títulos Do Grid De Registros Do "Crud":}
  for ContColunas := 0 to dbgGridCrud.Columns.Count - 1 do
    dbgGridCrud.Columns.Items[ ContColunas ].Title.Color := CorGridCrudTitulo;

  {Linhas Estranhas Abaixo, Com Duplicação Da Setagem Da Active Page Para o Mapa Pais Shape,
   Antes e Ao Final Do Bloco, Destina-Se a Impedir Problemas de Execução Que Podem Ocorrer
   Quando, Ainda Em Tempo De Desenvolvimento, o Programa é Compilado Tendo Sido Deixada Como
   Página Inicial Default Alguma Outra Que Não Seja a Própria De Mapa Pais Shape, Que Ocorre
   Devido a Setagem Das Abas Das Pagínas Para Invisíveis Em Tempo de Execução:}
  pgcPaginas.ActivePage := tshTabelaComTodos;
  tshTabelaComTodos.TabVisible := False;
  tshFichaComUm.TabVisible := False;
  pgcPaginas.ActivePage := tshTabelaComTodos;

  {Padronizar Cores Componentes Da Ficha De Cadastro:}
  PintarRotulosCamposCalendariosFichaComUm;

  {Conferir o Nome Do Arquivo Que Conterá o Banco De Dados:}
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
    {Definir Forma De Ordenação Inicial Da Tabela Do "Crud":}
    OrdenacaoCampo := NomeCampoLogicoOrdenacaoInicial;
    OrdenacaoDescendente := False;

    {Preparar e Abrir a Query Que Será Usada Para o "Crud":}
    AbrirTabelaCrud(
      OrdenacaoCampo,
      OrdenacaoDescendente );

    AtualizarQuantidadeCadastrosEFotos;
  end;

  {Inicializar Mecanismo Que Permite Editar e Validar Edições Na Própria Tabela Com
   Todos Os Registros:}
  EdicaoNaPaginaTabelaComTodos_NomeCampo                := '';
  EdicaoNaPaginaTabelaComTodos_MotivoCancelamento       := '';

  {Durante Processamentos Que Envolvem Todos Os Registros, Isto é, Durante Ações Que Não
   São Instantâneas, Para Evitar a Saída Inesperada Do "Form", Há Um Mecanismo Que Controla
   O Acionamento Do Controle De Saída Deste "Form" e Que Aqui é Inicializado Abaixo:}
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

  {Há Um Mecanismo Complicado Para Assegurar o Desenho Dos Marcadores De Ordenação
   Sobre Colunas. Os Cuidados Mais Abaixo Asseguram o Desenho Correto Dos Marcadores
   De Ordenação Sobre Os Títulos Das Colunas. Mas, Mesmo Com Seu Desenho Correto,
   Restaria Um Problema Que Consiste No Caso Em Que Estes Marcadores Não Devessem
   Ser Desenhados Simplesmente Porque a Atual Coluna De Ordenação Não Estivesse
   Aparecendo Na Área Vísivel Do Grid Devido a Ele Ter Sido "Scrollado" Para Esquerda
   Ou Para Direita, Então Ficando Em Uma Posição Em Que Esta Coluna De Ordenação Não
   Ficasse Visível. Neste Caso Nenhum Marcador Deveria Ser Desenhado. E Isto Não é
   Simples Porque Este Procedimento De Pintura De Colunas Do Grid Sequer é Chamado Ou
   Disparado Para Colunas "Clipadas" Que Não Estejam Visíveis. Assim, Por Causa Disto, o
   "Scroll" Para Esquerda Ou Direita Do Grid Poderia Fazer Com Que Permanecessem
   Desenhados Os Marcadores Anteriores, De Quanto a Coluna De Ordenação Estivesse
   Efetivamente Visível. E Os Marcadores Desenhados Em Um Processamento De Desenho
   Anterior Ficaram Errados. Para Resolver é Marcado, De Forma Global, Na Variável
   "OrdenacaoDesenhouMarcadorSobreColuna" Se Algum Marcador Foi Efetivamente Desenhado,
   Representando Que a Coluna De Ordenação Está Visível. Caso Ao Final Do Desenho
   Do Grid Seja Visto Que Não Ocorreu e Não Passou o Desenho Da Coluna De Ordenação,
   Então a Área De Desenho De Marcadores, Sobre o Título Das Colunas, Será Limpa
   Para Não Permanecer Com o Desenho Do Processamento Anterior:}
  if ( ( Rect.Left = 0 ) and
       ( Rect.Top < 30 ) ) then
    OrdenacaoDesenhouMarcadorSobreColunas := False;  // Já Na Primeira Célula Desenhada,
                                                     // Marcar Que Não Desenhou Marcadores De Colunas De Ordenação

  {Verificar Se Está Desenhando Parte Da Coluna Pela Qual o Grid Está Sendo Ordenado:}
  if ( UpperCase( Column.Field.FieldName ) = UpperCase( OrdenacaoCampo ) ) then
  begin
    {Observando Que Esta Ponto De Processamento Somente Será Executado Se a Coluna
     De Ordenação Estiver Efetivamente Visível Na Tela. E Não Estamos Nos Referindo a
     Ela Esta Com "Visible True ou False", Mas a Ela Não Estar "Clipada" Fora Da Área
     De foco Do Grid.}

    {Como Está Desenhando a Coluna De Ordenação, Então Destacar a Sua Cor Das Demais:}
    dbgGridCrud.Canvas.Brush.Color :=
      AjustarCorParaMaisEscuraOuClara(
      CorGridCrudCorpo,
      80 );
    dbgGridCrud.Canvas.FillRect( Rect );

    {Realizar o Desenho Dos Marcadores De Ordenação Sobre Colunas Somente Ao Processar a
    Linha Inicial Do Grid Para Não Ficar Repetindo Sem Necessidade Este Processamento:}
    if ( Rect.Top < 30 ) then
    begin
      {Limpar a Área Dos Marcadores De Ordenação Que Fica Fora Do Grid, Em Um "TImage"
       Imediatamente Acima Dos Títulos Deste Grid:}
      LimparAreadDosMarcadoresDeOrdenacaoAcimaDosTitulosDoGrid;

      {Aplicar o Marcador, Alinhado Com o Respectivo Título Do Grid, Acima Dele:}
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

      {Sinalizar Que Realmente Desenhou Um Marcador De Coluna De Ordenação:}
      OrdenacaoDesenhouMarcadorSobreColunas := True;
    end
  end;

  {Realizar Os Demais Processamentos Para o Efetivo Desenho Do Conteúdo Das Células Do Grid:}
  if ( gdSelected in State ) then
  begin
    {Caso Seja a Célula Atualmente Selecionada:}
    dbgGridCrud.Canvas.Brush.Color := CorCelulaSelecionada;
    dbgGridCrud.Canvas.FillRect( Rect );

    dbgGridCrud.Canvas.Font.Color := clBlack;
    dbgGridCrud.Canvas.Font.Style := dbgGridCrud.Canvas.Font.Style + [ fsBold ];

    {Como Está Na Célula Efetivamente Selecionada, Aproveitar Para Atualizar o Visual Dos Botões
     De Nevegação:}
    AtualizarBotoesDeNavegacao;

    {Como Está Na Célula Efetivamente Selecionada, Aproveitar Para Atualizar o Apresentação Do
     Número Da Linha Atual e Da Quantidade Total De Cadastros:}
    AtualizarQuantidadeCadastrosEFotos;
  end;

  {Depois De Todas As Providências Acima, Finalmente Vai Escrever Efetivamente o Conteúdo Da
   Célula Na Posição Correta. Mas Resta Ainda Uma Providência Que é Calcular a Posição Exata De
   Desenho, Dentro Da Área De Cada Célula, Levando Em Consideração o Alinhamento Desejado Para Cada
   Coluna:}
  if ( Column.FieldName = 'SEXO' ) then
    ConteudoCelula := LeftStr( Trim( Column.Field.AsString ), 1 )
  else
    ConteudoCelula := Trim( Column.Field.AsString );
  TamanhoEscrito :=              // Calcular Qual Será o Tamanho Efetivo Da Escrita Do Conteúdo Desejado, Na Horizontal e Na Vertical
    dbgGridCrud.Canvas.TextExtent( ConteudoCelula );
  PosicaoAEscrever.Cy :=         // No Alinhamento Vertical, Simplesmente Calcular a Posição Que Centralize o Texto Da Célula
    Rect.Top + Round( ( ( Rect.Bottom - Rect.Top ) - TamanhoEscrito.Cy ) / 2 );
  case Column.Alignment of       // No Alinhamento Horizontal, Calcular Conforme Seja o Alinhamento Desejado Para Cada Célula e Coluna
    taLeftJustify:               // Alinhar Conteúdo Da Célula a Esquerda No Espaço Reservado a Ela
      PosicaoAEscrever.Cx :=
        Rect.Left;
    taCenter:                    // Alinhar Conteúdo Da Célula Ao Centro No Espaço Reservado a Ela
      PosicaoAEscrever.Cx :=
        Rect.Left + Round( ( ( Rect.Right - Rect.Left ) - TamanhoEscrito.Cx ) / 2 );
    taRightJustify:             // Alinhar Conteúdo Da Célula a Direita No Espaço Reservado a Ela
      PosicaoAEscrever.Cx :=
        ( Rect.Right - TamanhoEscrito.Cx );
  end;
  dbgGridCrud.Canvas.TextOut(   // Finalmente Escrever, Desenhar Conteúdo Da Célula Do Grid Na Posição Calculada Acima
    PosicaoAEscrever.Cx,
    PosicaoAEscrever.Cy,
    ConteudoCelula );

  {Ao Final Do Processamento, Quando Estiverem Sendo Desenhadas As Últimas Linhas Do Grid,
   Verificar Se Ocorreu e Se Passou Acima o Desenho De Marcadores Da Coluna De Ordenação:}
  if ( Rect.Top > dbgGridCrud.Height - 50 ) then
  begin
    {Caso a Coluna De Ordenação Esteja "Clipada" a Esquerda Ou a Direita Da Área Visível
     Do Grid, Então Limpar a Área De Marcadores, Sobre Os Títulos Do Grid, Para Que Não
     Permaneçam Desenhados Errados Em Uma Configuração Anteriormente Processada:}
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

  {Aceitar Apenas Caracateres Maiúsculos:}
  if ( Pos( Key, 'abcdefghijklmnopqrstuvwxyz' ) > 0 ) then
    Key := Chr( Ord( Key ) - Ord( 'a' ) + Ord( 'A' ) );
end;

procedure TfrmDialogoCrudClientes.dbgGridCrudKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  {As Providências Abaixo Impedem a Criação Forçada De Novas Linhas No Grid, Além Dos
   Registros Já Existentes. Isto Quando Se Pressiona a Tecla Seta Para Baixo Estando
   Posicionado Na Última Linha Do Grid. Além Disto, a Inserção Via Pressionar Da Tecla
   "Insert" Também é Impedido:}
  if ( ( Key = VK_INSERT ) or
       ( ( Key = VK_DOWN ) and
         ( cdsClientDataSetCrud.RecNo = - 1 ) ) ) then
  begin
    cdsClientDataSetCrud.Cancel;

    frmPrincipal.AcionarFormProsseguir(
      'Caso Pretenda Criar Um Novo Cadastro, Utilize a Opção "Novo"' + RetornoDeCarro( 01 ) +
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
        'Não é Possível Simplesmente Remover o Cadastro' + RetornoDeCarro( 02 ) +
        cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).DisplayName + ':' + RetornoDeCarro( 01 ) +
        cdsClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString + RetornoDeCarro( 02 ) +
        'Porque Há Mais De Um Cadastro Com Conteúdo Idêntico a Ele, Em Todos Os Seus' + RetornoDeCarro( 01 ) +
        'Campos De Informações.' + RetornoDeCarro( 02 ) +
        'Para Que Seja Possível Remover Alguma Destas Duplicações Cadastrais, Primeiro é' + RetornoDeCarro( 01 ) +
        'Necessário Editar o Cadastro a Ser Eliminado, Alterando-o, De Modo Que, Em Ao' + RetornoDeCarro( 01 ) +
        'Menos Um Dos Seus Campos, Ele Fique Com Conteúdo Diferente Das Suas Demais' + RetornoDeCarro( 01 ) +
        'Duplicações, e Assim Possa Ser Identificado Individualmente Para Correta' + RetornoDeCarro( 01 ) +
        'Eliminação.',
        '',
        '',
        'Prosseguir',
        False );
      Exit;
    end;

    {Se o Cadastro Estiver Com o Nome Identificar Em Branco, Eliminar Direto Sem Pedir Confirmação:}
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
            'Não, Preservar',
            'Sim, Remover',
            False ) = mrYes );
    end;

    if Prosseguir then
    begin
      {O Detalhe Abaixo é Importante. Caso Esteja Mostrando a Página Com a Ficha Cadastral
       Individual, Com Um Cadastro, e Este Cadastro For Também o Único Existente Na Tabela,
       Ora, Com a Sua Remoção Então Não Restará Mais Nenhum Cadastro Na Tabela e Assim, a
       Página Deverá Ser Comutada Para a Forma De Tabela Com Todos Porque Depois, Logo Em
       Seguida, Não Haverá Mais Nenhum Cadastro a Ser Mostrado Na Ficha Com Um:}
      if ( ( pgcPaginas.ActivePage <> tshTabelaComTodos ) and
           ( cdsClientDataSetCrud.RecordCount <= 1 ) ) then
        ComutarPaginasEntreTabelaComTodosFichaComUm( tshTabelaComTodos );

      {Faz a Remoção Do Cadastro:}
      cdsClientDataSetCrud.Delete;

      {Verificar e Eliminar Eventuais Duplicações Cadastrais}
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
    {A Tabela Está Vazia:}
    if ( ClientDataSetCrud.State = dsInsert ) then
    begin
      {A Tabela Está Vazia, Mas Está Em Modo De Inserção Do Primeiro Cadastro:}

      {Aqui Não Faz Sentido Meramente Avisar o Usuário. A Tabela Está Vazia e Se Está
       Inserindo o Primeiro Cadastro. Então, Mais Fácil Seguir Para Frente Do Que Voltar,
       Fazer o Que Segue: Completar a Criação Do Cadastro Em Inserção, Mesmo Que Seja
       Necessário Forçar Um Nome Genérico Para Ele Caso Ainda Não Tenha Sido Inserido.
       E Confirmar Esta Inserção. Em Seguida Retornar "True" Ao Procedimento Chamador,
       Como Se Não Houvesse Cadastro Nenhum, Mas Que Agora Efetivamente Passou a Existir o
       Primeiro Cadastro, Para Que o Chamador Siga o Seu Processamento Normal. Isto é,
       Se o Procedimento Chamador Pretendia, Por Exemplo, Remover Um Cadastro, Agora a
       Tabela Não Está Mais Vazia e Ele Poderá Remover Este Cadastro Como Era Desejado:}
      if ( dbeNome.Text = '' ) then
        ClientDataSetCrud.FieldByName( NomeCampoLogicoOrdenacaoInicial ).AsString :=
          'SEM NOME ' + FormatDateTime( 'yyyymmddhhmmsszzz', Now );  // Se Ainda Não Tinha Nome, Atribuir Um Nome Genérico
      ClientDataSetCrud.Post;                                        // Confirmar a Postagem, Encerrando a Inserção
      Result := True;                                                // Retornar "True" Para Que o Próprio Procedimento Chamador
                                                                     // Siga Seu Processo Notmal Já Que a Tabela Deixou De Estar Vazia
    end
    else
    begin
      {A Tabela Está Vazia, e Não Está Em Modo De Inserção Do Primeiro Cadastro:}

      {Avisar o Usuário De Que a Tabela Está Vazia:}
      frmPrincipal.AcionarFormProsseguir(
        'Ainda Não Há Nenhum Cadastro Deste Gênero No Banco De Dados!' + RetornoDeCarro( 02 ) +
        'Por Favor, Acione a Opção "Novo" Para Inserir o Primeiro Cadastro.',
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

  {Primeiro Verificar Se Existem Duplicações Idênticas Entre Os Cadastros:}
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

  {Primeiro Verificar Se Existem Duplicações Idênticas Entre Os Cadastros:}
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
    {Depois, Se Tiverem Sido Encontradas Duplicações Idênticas Entre Os Cadastros, Então
     Elimina-las Preservado Apenas Uma De Cada, Sem Repetições:}
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
  {Aplicar Alterações Ao Banco De Dados:}
  cdsClientDataSetCrud.ApplyUpdates( 0 );

  {Verificar Se Há Cadastros Duplicados e Elimina-los:}
  if ( EliminarRegistrosComConteudoTotalmenteDuplicadoDeixandoApenasUm(
         NomeTabelaOperadaPeloCrud,
         cdsClientDataSetCrud ) ) then
  begin
    {Quanto a Informar Ao Usuário Sobre a Realização Da Eliminações Das Duplicações, Somente
     Informa-las Caso Não Tenha Havido Imediatamente Antes Um Erro De Validação Do Contéudo
     Da Digitação Mais Recente. Se Isto Tiver Acontecido, Não Há Necessidade De Informar Porque
     Uma Duplicação Teria Ocorrido De Forma Natural, Sem Que Tivesse Sido Diretamente Criada
     Pelo Usuário. Assim, Basta Te-la Eliminado, Mas Sem a Necessidade De Informar Sobre Isto:}
    if not EdicaoNaPaginaTabelaComTodos_HouveErroPrevioValidacao then
    begin
      EsperarSegundos( 0.25, False );

      frmPrincipal.AcionarFormProsseguir(
        'Foram Automaticamente Removidos Os Cadastros Duplicados, Aqueles Que' + RetornoDeCarro( 01 ) +
        'Estavam Com Conteúdo Absolutamente Idêntico Entre Si, Com Todos Os' + RetornoDeCarro( 01 ) +
        'Seus Campos Preenchidos De Forma Igual.' + RetornoDeCarro( 02 ) +
        'Nesta Remoção Foram Preservados Os Cadastros Únicos, Com Conteúdo' + RetornoDeCarro( 01 ) +
        'Inédito, Sem Repetições.',
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

    {Procurar Expressão Dentro Da Atual Coluna De Ordenação:}
    if ( not cdsClientDataSetCrud.Locate( OrdenacaoCampo, cbxBusca.Text, [ loCaseInsensitive, loPartialKey ] ) ) then
    begin
      frmPrincipal.AcionarFormProsseguir(
        'A Expressão' + RetornoDeCarro( 02 ) +
        '"' + cbxBusca.Text + '"' + RetornoDeCarro( 02 ) +
        'Não Foi Encontrada Na Coluna' + RetornoDeCarro( 02 ) +
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
    {Caso Esteja Em Edição Ou Inserção, Fazer o Post Para Gravar:}
    CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar;

    PreverRelatorioCrudClientes;
  end;
end;

procedure TfrmDialogoCrudClientes.lblCatalogoClick(Sender: TObject);
begin
  if TabelaPossuiAoMenosUmRegistroEInformarUsuarioSeNao( cdsClientDataSetCrud ) then
  begin
    {Caso Esteja Em Edição Ou Inserção, Fazer o Post Para Gravar:}
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

    {Estas Linhas Abaixo São Necessárias Para Melhorar o Aspecto De Redesenho Da
     Tela, De Forma Que, Quando o Formulário De Previsão De Impressão For Mostrado
     (Que Por Enquanto Ainda Está Invisível), Ele Já Entre Ocupando a Tela Inteira:}
    frmImprimirPrevisaoImpressao.Top := 0;
    frmImprimirPrevisaoImpressao.Width := Screen.Width;
    frmImprimirPrevisaoImpressao.Left := 0;
    frmImprimirPrevisaoImpressao.Height := Screen.Height;

    {Preparar o Relatório:}
    frmAguarde.LigarDesligarFormMensagemAguarde(
      True,
      TForm( frmDialogoCrudClientes ) );

    frmImprimirRelatorioCrudClientes.PrepararRelatorio(
      Self,
      'Relatório De Clientes' );

    frmAguarde.LigarDesligarFormMensagemAguarde(
      False,
      TForm( frmDialogoCrudClientes ) );

    {Mostrar o Relatório Em Tela de Previsão:}
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

    {Estas Linhas Abaixo São Necessárias Para Melhorar o Aspecto De Redesenho Da
     Tela, De Forma Que, Quando o Formulário De Previsão De Impressão For Mostrado
     (Que Por Enquanto Ainda Está Invisível), Ele Já Entre Ocupando a Tela Inteira:}
    frmImprimirPrevisaoImpressao.Top := 0;
    frmImprimirPrevisaoImpressao.Width := Screen.Width;
    frmImprimirPrevisaoImpressao.Left := 0;
    frmImprimirPrevisaoImpressao.Height := Screen.Height;

    {Preparar o Relatório:}
    frmAguarde.LigarDesligarFormMensagemAguarde(
      True,
      TForm( frmDialogoCrudClientes ) );

    frmImprimirRelatorioCrudClientesComFotos.PrepararRelatorio(
      Self,
      'Catálogo De Clientes' );

    frmAguarde.LigarDesligarFormMensagemAguarde(
      False,
      TForm( frmDialogoCrudClientes ) );

    {Mostrar o Relatório Em Tela de Previsão:}
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
    'Clique Sobre o Título Da Coluna Para Estabelecer a Forma De Ordenação.',
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
  {Se Estiver Na Página Da Tabela Com Todos Os Cadastros, a Comutação Para a Página Com a
   Ficha Que Mostra Apenas Um Cadastro Somente Será Permitida Desde Que Haja Ao Menos Um
   Registro Cadastrado Na Tabela Do Banco De Dados. Em Outras Palavras, Se Estiver Mostrando
   Uma Tabela Vazia, Com Zero Cadastros, Não Irá Comutar Para a Ficha Infividual:}
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

  {Resetar Mecanismo Que Permite Editar e Validar Edições Na Própria Tabela Com
   Todos Os Registros:}
  EdicaoNaPaginaTabelaComTodos_NomeCampo                := '';
  EdicaoNaPaginaTabelaComTodos_MotivoCancelamento       := '';

  {Caso Esteja Em Edição Ou Inserção, Fazer o Post Para Gravar:}
  CasoEstejaEmEdicaoOuInsercaoFazerPostParaGravar;

  {Anotar Em Que "Panel" Estão Os Botões De Navegação Antes De Comutar a Página:}
  PainelDeOrigemDosBotoesNavegacao := TPanel( spdRegistroInicial.Parent );

  {Se o Chamador Não Especificou a Página De Destino Desejada, Então Considerar
   Simplesnente Que Deverá Trocar a Página Atual Pela Seguinte:}
  if ( PaginaDesejada = Nil ) then
  begin
    PaginaDesejadaIndice := 0;
    if      ( pgcPaginas.ActivePageIndex = 0 ) then
      PaginaDesejadaIndice := 1
    else if ( pgcPaginas.ActivePageIndex = 1 ) then
      PaginaDesejadaIndice := 0;

    PaginaDesejada := pgcPaginas.Pages[ PaginaDesejadaIndice ];
  end;

  {Somente Fazer a Comutação Se For Mesmo Necessário, Isto é, Se a Pagina Desejada For
   Diferente Da Que Já Estiver Ativa:}
  if ( pgcPaginas.ActivePage <> PaginaDesejada ) then
  begin
    {Anotar Deslocamento Vertical Entre Botões De Navegação Para Que Estes Botões De
     Navegação Possam Ter Os Seus Respectivos "Parents" Comutados Entre As Páginas, Mas
     Preservando a Exata Posição De Tela Em Que Estão. Anotar Posição Vertical Orginal
     Que Os Botões De Navegação Ocupavam Antes Da Mudança De Página:}
    DeslocamentoVerticalEntreBotoesNavegacao := spdRegistroAnterior.Top - spdRegistroInicial.Top;
    PontoInicialBotoesNavegacao := Point( spdRegistroInicial.Left, spdRegistroInicial.Top );
    PontoInicialBotoesNavegacao := PainelDeOrigemDosBotoesNavegacao.ClientToScreen( PontoInicialBotoesNavegacao );

    {Fazer a Comutação Da Página Propriamente Dita, Mas Antes Reposicionando Os
     Controles e Botões De Navegação Para Os Seus Novos "Parents" Conforme a Página
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

    {Anotar Em Que "Panel" Estão Os Botões De Navegação Depois De Comutar a Página:}
    PainelDeDestinoDosBotoesNavegacao := TPanel( spdRegistroInicial.Parent );

    {Como Os Botões De Navegação Tiveram Os Seus "Parents" Comutados Entre As Diferentes
     Páginas, Calcular a Posição Inicial Vertical Equivalente Que Terão a Partir Do Ponto
     De Origem Em Tela Que Estavam Ao Ponto De Destino, Depois Desta Comutação:}
    PontoInicialBotoesNavegacao := PainelDeDestinoDosBotoesNavegacao.ScreenToClient( PontoInicialBotoesNavegacao );

    {Depois Da Comutação De Páginas, Reposicionar Os Botões De Navegação De Forma Que Preservem
     As Mesmas Posições De Tela Que Estavam Na Página Anterior:}
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
      {O Uso Da Tecla [ENTER] Na Página De Ficha Cadastral Servirá Como o Equivalente De
       Digitar a Tecla [TAB] Para Comutar Ao Campo Seguinte. Exceto Quando o Campo Ativo
       Que Receber Este [ENTER] For Para Digitação De Texto Continuo, Como Um "TDBRichEdit":}
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
  {Para Evitar Que o Campo Já Entre Totalmente Selecionado Quando Há Mudança De Páginas:}
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
  {Verificar Se Não é o Caso Do Usuário Ter Acionado Duas Vezes Seguidas a Opção
   Para Cadastrar Um Novo Registro. Se For Isto, e Já Estiver Em Inserção, Então
   Não Deve Incluir Pela Segunda Vez Sem Necessidade:}
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
    {Está Iniciando Uma Edição Na Própria Página Contendo a Tabela Com Todos Os Cadastros.
     Preparar Mecanismo Para Depois Conseguir Validar a Edição Eventualmente Feita:}
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

  {Primeiro Ver Se Todos Os Campos Estão Vazios. Neste Caso Cancelar o Post:}
  ContadorCampos := 0;
  repeat
    AbortarCancelarPost :=
      ( ( AbortarCancelarPost ) and
        ( Trim( DataSet.Fields[ ContadorCampos ].AsString ) = '' ) );
    ContadorCampos := ContadorCampos + 1;
  until ( not AbortarCancelarPost ) or ( ContadorCampos >= DataSet.FieldCount - 1 );

  {Depois, Se Nem Todos Os Campos Estão Vazios, Fazer As Demais Validações:}
  if not AbortarCancelarPost then
  begin
    {Definir Posssíveis Mensagens De Erro De Validação:}
    MensagemCampoNaoVazio      :=
      'A Edição Foi Cancelada Porque Este Campo Não Pode Ficar Em Branco.';
    MensagemCampoCPFInvalido   :=
      'A Edição Foi Cancelada Porque o CPF Digitado é Inválido.';
    MensagemCampoDuplicado     :=
      'A Edição Foi Cancelada Porque o Conteúdo Digitado Foi Encontrado' + RetornoDeCarro( 01 ) +
      'Duplicado Em Outro Cadastro.';
    MensagemCampoSexoInvalido  :=
      'A Edição Foi Cancelada Porque o Conteúdo Digitado é Inválido';

    {Estas Validações São Feitas No Caso Das Edições Feitas Diretamente Na Tabela Com Todos}
    if ( ( pgcPaginas.ActivePage = tshTabelaComTodos ) and
         ( EdicaoNaPaginaTabelaComTodos_NomeCampo <> '' ) ) then
    begin


      {Verificar Campo Que Não Pode Ficar Vazio:}
      if      ( EdicaoNaPaginaTabelaComTodos_NomeCampo = 'NOME' ) then
      begin
        AbortarCancelarPost :=
          not ValidarCampoNaoVazioDigitadoEmTabela( EdicaoNaPaginaTabelaComTodos_NomeCampo );

        if AbortarCancelarPost then
          EdicaoNaPaginaTabelaComTodos_MotivoCancelamento := MensagemCampoNaoVazio;
      end


      {Verificar Campo De CPF Que Não Pode Ficar Inválido e Não Pode Ficar Duplicado:}
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


      {Verificar Campo Cujo Conteúdo Não Pode Ficar Duplicado:}
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

  {Resetar Mecanismo Que Permite Editar e Validar Edições Na Própria Tabela Com
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
A Função Abaixo Grava Uma Imagem, Que Esteja Gravada Em Arquivo Ou Contida Em Um "TImage",
Dentro De Um Campo "Blob" De Uma Tabela Do Banco De Dados. Para Imagem Em Arquivo, Deve-se
Informar o Nome Completo Do Arquivo No Parâmetro "NomeCompletoArquivoContendoImagem" Com
"Nil" No Parâmetro "ImagemOrigem". Por Outro Lado, Para Gravar a Partir Do Conteúdo De Um
"TImagem", Passe Este "TImagem" No Parâmetro "ImagemOrigem" e Deixe Vazio, Em Branco, o
Parâmetro "NomeCompletoArquivoContendoImagem".

Os Formatos Permitidos Para Esta Imagem a Ser Gravada São JPeg, Bitmap, Gif e PNG.

A Função Retornará "True" Se Correr Tudo Bem e "False" Se Houver Algum Problema.

Para Fins De Documentação, Recomenda-se Que o Campo "Blob" Que Deverá Ser Criado Na
Tabela, e Que Suportará a Gravação Da Imagem, Seja Criado Com Os Seguintes Padrões:

  Segment Size = 80
  SubType      = 0

Na Prática o Script DDL Da Criação Deste Campo Será Simplesmente Ao Do Tipo:

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

  {A Origem Possível Pode Ser Um Jpeg Gravado Em Arquivo, Mas Também, Quando o Nome
   Deste Arquivo é Passado Em Branco, Pode Ser, Em Qualquer Formato "Graphic", o Que
   Estiver Em Um TImage:}
  NomeCompletoArquivoContendoImagem := Trim( NomeCompletoArquivoContendoImagem );
  if ( ( FileExists( NomeCompletoArquivoContendoImagem ) ) or
       ( NomeCompletoArquivoContendoImagem = '' ) ) then
  begin
    {Todos Estes Tipos Abaixo São Necessários Porque Se Pretende Receber e Tratar Formatos
     Diversos Como JPeg, Bitmap, Gif e PNG, Todos Os Quais Deverão Ao Final Ser Convertidos Ao
     JPeg, Sendo Este o Formato "Mais Leve" De Todos, Para Gravação No Banco De Dados:}
    Picture := TPicture.Create;  // Picture Genérica Que Poderá Receber JPeg, Bitmap ou PNG
    Bitmap := TBitmap.Create;    // Bitmap Que Pode Pode Receber a Conversão De Qualquer Picture Genérica
    Jpeg := TJpegImage.Create;   // Jpeg Que Receberá o Bitmap Convertido, Com Armazenamento "Mais Leve"

    ImagemStream := TMemoryStream.Create;

    try
      {Conforme Tenha Recebido a Imagem a Ser Gravada No Banco De Dados Proveniente De
       Um Arquivo Gravado Ou Contida Em Um "TImage", Como Está Tratando Possíveis Formatos
       Diversos De Imagem (JPeg, Bitmap, Gif ou PNG), Primeiro Ler Ou Aplicar Esta Imagem
       Em Um "TPicture" Genérico:}
      if ( NomeCompletoArquivoContendoImagem <> '' ) then
        Picture.LoadFromFile( NomeCompletoArquivoContendoImagem )  // Passou Uma Imagem Graphic Contida Em Arquivo
      else
        Picture.Assign( ImagemOrigem.Picture.Graphic );            // Passou Uma Imagem Graphic Contida Em "TImage"

      {Transformar Este Formato "TPicture" Genérico Para "TBitmap" Padronizado:}
      Bitmap.Assign( Picture.Graphic );

      {Transformar Este Formato "TBitmap" Padronizado Para "TJpegImage" Que Será o
       Que Ocupará Menor Espaço No Banco De Dados:}
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
    {Como o Blob Com a Imagem Está Vazio, Então Forçar a Imagem Padrão Avatar Conforme o
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
    {Aplicar Alterações Ao Banco De Dados:}
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
        'Por Favor, Verifique Se Ele Contém Uma Imagem Válida Com Foto.',
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
        {A Ação Abaixo Aparentemente Não Seria Necessária Porque Consiste Em Ler a
         Mesma Imagem Que Acabou De Ser Gravada Acima Com Sucesso. Mas Aqui Ela é
         Necessária Porque a Imagem Gravada Pode Estar Eventualmente Em Formato GIF
         Sendo Um GIF Animado. Neste Caso Somente o Primeiro Quadro Do GIF Animado
         Foi Efetivamente Gravado, e a Sua Releitura Deixará Isto Imediatamente Claro
         Ao Usuário:}
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
  {Verificar Se a Foto Já Não Está Limpa. Neste Caso Não Precisa Limpar De Novo:}
  if ( TBlobField( cdsClientDataSetCrud.FieldByName( NomeCampoLogicoBlobContendoFoto ) ).BlobSize = 0 ) then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'Não Há Foto Real Para Ser Removida,' + RetornoDeCarro( 01 ) +
      'Mas Apenas Uma Imagem Ilustrativa Genérica.',
      '',
      '',
      'Prosseguir',
      False );
  end
  else
  begin
    if ( frmPrincipal.AcionarFormProsseguir(
           'Foi Solicitado Remover a Foto Deste Cadastro.' + RetornoDeCarro( 02 ) +
           'Com Esta Remoção a Foto Que Passará a Ser Exibida Será' + RetornoDeCarro( 01 ) +
           'Uma Imagem Ilustrativa Genérica Padrão.' + RetornoDeCarro( 02 ) +
           'Confirma Remover Esta Foto?',
          '',
          'Não, Preservar',
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
  {Somente Fará a Rotação Da Imagem Foto Contida No Blob Se Ela Realmente Existir:}
  if ( TBlobField( cdsClientDataSetCrud.FieldByName( NomeCampoLogicoBlobContendoFoto ) ).BlobSize = 0 ) then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'Não Há Foto Real Para Ser Rotacionada,' + RetornoDeCarro( 01 ) +
      'Mas Apenas Uma Imagem Ilustrativa Genérica.',
      '',
      '',
      'Prosseguir',
      False );
  end
  else
  begin
    {Pegar a Imagem Em Apresentação e Converter Para Bitmap. Em Seguida, Rotaciona-la
     Em Noventa Graus Decimais Para a Direita. Atribuir Resultado à Própria Imagem Em
     Apresentação, Que Ficará Em Formato Bitmap, Mas Apenas Nesta Camada De Apresentação:}
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

    {Colocar Registro Em Edição Caso Não Esteja:}
    ColocarEmEstadoDeEdicaoSeJaNaoEstiver;

    {Gravar Imagem Em Apresentação Para o Campo Blob Contendo a Foto. No Procedimento
     Abaixo Ela Será Reconvertida Para Formato JPeg e Será Gravada:}
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
  {Calcular Produto Da Multiplicação Da Quantidade De Cadastros De Processamento Restantes a Fazer
   Vezes a Média De Tempo Que Tomou Com Cada Um Dos Cadastros Já Antes Processados:}
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
      'Não Há Foto Real Para Ser Exportada,' + RetornoDeCarro( 01 ) +
      'Mas Apenas Uma Imagem Ilustrativa Genérica.',
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

      {Caso o Arquivo Já Exista, Confirmar Autorização Para Escrever Por Cima:}
      if not Prosseguir then
        Prosseguir := (
          frmPrincipal.AcionarFormProsseguir(
          'Já Existe Um Arquivo Gravado' + RetornoDeCarro( 01 ) +
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
          'Exportação De Foto Concluída! O Resultado Está No Arquivo:' + RetornoDeCarro( 02 ) +
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
  {Inicializar Navegador Web Que Consulta Pontuação De Carteira Nacionak De Habilitação:}
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
      'Para Preenchimento Automático Do Endereço a Partir Do CEP é' + RetornoDeCarro( 01 ) +
      'Necessário Informar Um CEP Válido.' + RetornoDeCarro( 02 ) +
      'Todos Os Campos De Endereço Serão Automaticamente Preenchidos' + RetornoDeCarro( 01 ) +
      'Exceto o Número No Logradouro e o Seu Eventual Complemento.' + RetornoDeCarro( 02 ) +
      'Por Favor, Digite Um CEP Válido.',
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
        'Por Favor, Digite Um CEP Válido.',
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
  lblAnotacoes.Caption := 'Anotações (dê duplo clique no mouse para reduzir)';
end;

procedure TfrmDialogoCrudClientes.dbrAnotacoesExit(Sender: TObject);
begin
  dbrAnotacoes.Width :=
    pnlFoto.Width;

  lblAnotacoes.Width := dbrAnotacoes.Width;

  lblAnotacoes.Caption := 'Anotações';
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
      'Não é Possível Enviar o Email XML Com Os Dados Cadastrais Porque o Cliente' + RetornoDeCarro( 02 ) +
      cdsClientDataSetCrudNOME.AsString + RetornoDeCarro( 02 ) +
      'Não Possui Um Endereço De Email Cadastrado Em Seu Registro.' + RetornoDeCarro( 02 ) +
      'Cadastre Um Endereço De Email Para Este Cliente e Tente Novamente.',
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
         'Se Você Está Recebendo Esta Mensagem, O Teste Ocorreu Com Sucesso',
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
          'Devido Suas Eventuais Configurações De Recebimento, Ela Não Tenha Sido' + RetornoDeCarro( 01 ) +
          'Direcionada Por Erro à Lixeira Eletrônica.',
          '',
          '',
          'Prosseguir',
          False )
      end
      else
      begin
        frmPrincipal.AcionarFormProsseguir(
          'O Envio Da Mensagem De Email XML Não Foi Realizado.' + RetornoDeCarro( 02 ) +
          'Há Algum Problema Relacionado Ao Funcionamento Da' + RetornoDeCarro( 01 ) +
          'Rede, Conexão Ou Acesso a Internet.',
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
