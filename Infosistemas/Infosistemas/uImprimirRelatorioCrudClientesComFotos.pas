unit uImprimirRelatorioCrudClientesComFotos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, Quickrpt, ExtCtrls, StrUtils, Jpeg, SqlExpr, Chart, FMTBcd, DB,
  DBClient, Provider, Printers, PngImage, uDialogoCrudClientes;

const
  AlturaPadraoBandaDetalheQuandoOcuparApenasUmaLinhaDeAltura            = 60;

type
  TfrmImprimirRelatorioCrudClientesComFotos = class(TForm)
    qrpRelatorio: TQuickRep;
    qrbTitulo: TQRBand;
    qrlTitulo01: TQRLabel;
    qrbCabecalho: TQRBand;
    qrbDetalhe: TQRBand;
    qrlNome: TQRLabel;
    qriLogotipo: TQRImage;
    qrdNome: TQRDBText;
    qrlFuncao: TQRLabel;
    qrdFuncao: TQRDBText;
    qrlArea: TQRLabel;
    qrdArea: TQRDBText;
    qrbRodape: TQRBand;
    qrsPagina: TQRSysData;
    qrsDataHora: TQRSysData;
    qrlNomeDesteAplicativo: TQRLabel;
    qryQueryCrud: TSQLQuery;
    dspDataSetCrud: TDataSetProvider;
    cdsClientDataSetCrud: TClientDataSet;
    dtrDataSourceCrud: TDataSource;
    qrlCNH: TQRLabel;
    qrdCNH: TQRDBText;
    qrlDataVencimento: TQRLabel;
    qrdDataVencimento: TQRDBText;
    qriFoto: TQRImage;
    cdsClientDataSetCrudNOME: TStringField;
    cdsClientDataSetCrudAREA: TStringField;
    cdsClientDataSetCrudFUNCAO: TStringField;
    cdsClientDataSetCrudCNH: TStringField;
    cdsClientDataSetCrudDTANASC: TSQLTimeStampField;
    cdsClientDataSetCrudDTAPRIMEIRACNH: TSQLTimeStampField;
    cdsClientDataSetCrudCPF: TStringField;
    cdsClientDataSetCrudSEXO: TStringField;
    cdsClientDataSetCrudCATEGORIA: TStringField;
    cdsClientDataSetCrudREMUNERADA: TStringField;
    cdsClientDataSetCrudABREVIATURAS: TStringField;
    cdsClientDataSetCrudHABCOLETIVASESTSENAT: TStringField;
    cdsClientDataSetCrudDTAULTREVISAO: TSQLTimeStampField;
    cdsClientDataSetCrudDTAVECTOCNH: TSQLTimeStampField;
    cdsClientDataSetCrudDIGITALIZACAO: TStringField;
    cdsClientDataSetCrudFOTO: TBlobField;
    qrlFoto: TQRLabel;
    procedure qrbDetalheBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure qrbDetalheAfterPrint(Sender: TQRCustomBand;
      BandPrinted: Boolean);
    procedure qrpRelatorioBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure qrpRelatorioEndPage(Sender: TCustomQuickRep);
    procedure PrepararRelatorio(
      FormDialogoCrudClientes: TfrmDialogoCrudClientes;
      TituloRelatorio: String );
    procedure qrsDataHoraPrint(sender: TObject; var Value: String);
    procedure qrsPaginaPrint(sender: TObject; var Value: String);
    procedure AbrirTabela(
      ClausulaSQL: String );
    procedure qrbTituloBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure qrpRelatorioPreview(Sender: TObject);
    procedure qrbCabecalhoBeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure qrdNomePrint(sender: TObject; var Value: String);
  private
    { Private declarations }
  public
    { Public declarations }
    EmCadaPaginaMostrarBandaCabecalhoComNomeColunas: Boolean;
    FormDialogoCrudClientesQueEstaPorBaixo: TfrmDialogoCrudClientes;
    NomeArquivoImagemLogotipoCabecalhoPNG, NomeArquivoImagemQRCodePNG, NomeArquivoImagemCapturadaMapaPNG: String;
  end;

var
  frmImprimirRelatorioCrudClientesComFotos: TfrmImprimirRelatorioCrudClientesComFotos;

implementation

uses
  uImprimirPrevisaoImpressao, uPrincipal, uRotinasGerais, uRotinasBancoDados;

{$R *.DFM}

procedure TfrmImprimirRelatorioCrudClientesComFotos.qrbDetalheBeforePrint(
  Sender: TQRCustomBand; var PrintBand: Boolean);
var
  Jpeg: TJPEGImage;

  function ConverterJpegParaPNG(
    Jpeg: TJPEGImage ): TPNGObject;
  var
    Bitmap: TBitmap;
  begin
    Bitmap := TBitmap.Create;
    Bitmap.Assign( JPeg );

    Application.ProcessMessages;

    Result := TPNGObject.Create;
    Result.Assign( Bitmap );

    Bitmap.Free;

    Application.ProcessMessages;
  end;

begin
  Jpeg := TJPEGImage.Create;

  frmDialogoCrudClientes.LerImagemContidaCampoBlobParaJPegComAvatarGenericoSeForNecessario(
    cdsClientDataSetCrud,
    NomeCampoLogicoBlobContendoFoto,
    cdsClientDataSetCrud.FieldByName( 'SEXO' ).AsString,
    JPeg );

  qriFoto.Picture.Assign( ConverterJpegParaPNG( Jpeg ) );

  JPeg.Free;
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.qrbDetalheAfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
  if BandPrinted then
  begin
    {Se a Última Linha Foi Efetivamente Impressa, Então Comutar a Cor de Fundo Da Próxima Linha.
     Isto Para Fazer Com Que as Linhas do Relatório Fiquem "Zebradas" Facilitando a Leitura:}
    if qrbDetalhe.Color = clWhite then
      qrbDetalhe.Color := clGainsboro
    else
      qrbDetalhe.Color := clWhite;
  end;
end;

{O Relatório Possui Um Mecanismo Para Que as Linhas de Detalhe Saiam "Zebradas", Isto é, Com Cores
 Alternadas Entre Si Para Facilitar a Leitura. Mas Isto Resultaria Em Um Eventual Problema Quando
 Algum Campo Não Pudesse Ser Escrito Totalmente Em Uma Única Linha de Texto e Precisasse Então Ser
 Quebrado em Duas Linhas. E Quando Isto Ocorresse em Uma Linha Com Fundo "Zebrado" a Coloração Desta
 "Zebra" Não Cobriria o Novo Espaço Destinado a Escrever o Conteúdo Completo Do Campo Porque Ele Ficou
 Maior na Sua Altura Visto Que Passou a Ocupar Duas Linhas. As Providências Abaixo Destinam-se a
 Identificar Quando Algum Campo Não Caberá em Uma Única Linha e, Neste Caso, Aumentar Verticalmente a
 Faixa de Detalhe Para Que Ela Possa Cobrir o Novo Espaço Vertical Adicional Necessário:}
procedure TfrmImprimirRelatorioCrudClientesComFotos.qrpRelatorioBeforePrint(
  Sender: TCustomQuickRep; var PrintReport: Boolean);
begin
  EmCadaPaginaMostrarBandaCabecalhoComNomeColunas := True;

  qrbDetalhe.Color := clWhite;
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.qrpRelatorioEndPage(
  Sender: TCustomQuickRep);
begin
  qrbDetalhe.Color := clWhite;
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.PrepararRelatorio(
  FormDialogoCrudClientes: TfrmDialogoCrudClientes;
  TituloRelatorio: String );
const
  DistanciaVerticalEntreCamposTitulo              = 00;
  DistanciaVerticalReducaoBandaResumo             = 22;
var
  ImagemLogotipoBitmap: TBitmap;
  NomeArquivoImagemLogotipoOriginalBMP: String;

  function ConverterBitmapParaPNG(
    Bitmap: TBitmap ): TPNGObject;
  begin
    Result := TPNGObject.Create;
    Result.Assign( Bitmap );
  end;

begin
  {Guardar a Referência do "Form" Que Está Chamando a Preparação Do Relatório:}
  FormDialogoCrudClientesQueEstaPorBaixo := FormDialogoCrudClientes;

  {Acertar Títulos e Rodapé do Relatório:}
  qrlTitulo01.Caption := TituloRelatorio;
  qrlNomeDesteAplicativo.Caption := frmPrincipal.lblLegendaVersao.Caption;

  {Acertar Imagem Do Logotipo Do Relatório, Que Será Mostrado No Topo de Todas as
   Páginas do Relatório. Há Um "Bug" Grave No "Quick Report" No Trato Das Imagens
   Operadas Pela Classe "TQRIMage" Que Consiste No Fato Delas Aparecerem Eventualmente
   Em Branco Ou Preto Na Previsão Quando Contém Imagens Em Formatos Bitmap e Jpeg.
   Por Este Motivo, a Imagem De Logotipo de Cabeçalho Abaixo, Será Montada Em Bitmap
   Mas Convertida Para Formato PNG. Assim Ela Poderá Ser Utilizada Sem a Ocorrência
   Do Problema do "Quick Report":}

  {Ler, a Partir Do Disco, a Imagem Bitmap Com o Logotipo Que Será Utilizado Como
   Cabeçalho Conforme Esteja Configurado Como Padrão Deste Aplicativo. Mudar a Sua
   Cor de Fundo Para Branco, Que é a Cor Base do Relatório Em Papel. Converter Este
   Bitmap Para PNG e Liberar a Memória Do Objeto Bitmap Que Foi Utilizado:}
  NomeArquivoImagemLogotipoOriginalBMP := frmPrincipal.Logo_NomeBaseArquivoLogotipoConformeConfigurado;
  NomeArquivoImagemLogotipoOriginalBMP :=
    Trim( ExtractFilePath( Application.ExeName ) ) + 'Operacao\Imagens_Logotipos\Logo_' + NomeArquivoImagemLogotipoOriginalBMP + '.bmp';
  ImagemLogotipoBitmap := TBitmap.Create;
  ImagemLogotipoBitmap.LoadFromFile( NomeArquivoImagemLogotipoOriginalBMP );
  BitmapTrocarUmaCorPorOutra(
    ImagemLogotipoBitmap,
    frmPrincipal.pnlSuperior.Color,
    clWhite,
    0 );
  qriLogotipo.Picture.Assign( ConverterBitmapParaPNG( ImagemLogotipoBitmap ) );
  ImagemLogotipoBitmap.Free;

  {Salvar Em Disco, Já Em Formato PNG, a Imagem Que Contém o Logotipo De Todas As
   Páginas do Relatório. Estabelecer Dimensões e Posição da Apresentação do Logotipo
   No Topo De Cada Página do Relatório:}
  NomeArquivoImagemLogotipoCabecalhoPNG :=
    NomePastaParaArquivosTemporariosDestaSessao + 'Logotipo_Temp_' + FormatDateTime( 'yyyymmddhhmmsszzz', Now ) + '.png';
  qriLogotipo.Picture.SaveToFile( NomeArquivoImagemLogotipoCabecalhoPNG );
  qriLogotipo.Stretch := True;
  qriLogotipo.Width := Round( 0.7 * frmPrincipal.imgLogotipo.Width );
  qriLogotipo.Height := Round( 0.7 * frmPrincipal.imgLogotipo.Height );
  qrlTitulo01.Top := qriLogotipo.Top + qriLogotipo.Height + DistanciaVerticalEntreCamposTitulo;

  {Abrir Tabela de Dados Que Serão Uaados Nas Linhas do Relatório. Utilizar a Mesma Cláusula SQL Que Foi Utilizada Para
   Selecionar os Marcadores Sobre a Área Geográfica Ativa:}
  AbrirTabela( FormDialogoCrudClientes.qryQueryCrud.SQL.Text );
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.qrsDataHoraPrint(
  sender: TObject; var Value: String);
var
  Posicao: Integer;
begin
  Posicao := Length( Value );
  while ( Posicao > 0 ) and
        ( Value[Posicao] <> ':' ) do
    Posicao := Posicao - 1;
  if ( Posicao > 0 ) then
    Value := LeftStr( Value, Posicao - 1 ) + ' hs';
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.qrsPaginaPrint(
  sender: TObject; var Value: String);
begin
  Value := Value + ' de ' + IntToStr( frmImprimirPrevisaoImpressao.QuantidadeTotalDePaginas );
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.AbrirTabela(
  ClausulaSQL: String );
begin
  {Ao Preparar a Cláusula SQL Que Será Utilizada Para Selecionar Os Registros e Preencher As Linhas
   Do Relatório, Faz Uso Da Mesma Cláusula De Seleção Que Foi Usada No "Form" De "Crud" Correspondente:}
  qryQueryCrud.SQLConnection := FormDialogoCrudClientesQueEstaPorBaixo.sqlConexaoCrud;
  cdsClientDataSetCrud.Close;
  qryQueryCrud.Close;
  cdsClientDataSetCrud.ProviderName := dspDataSetCrud.Name;
  qryQueryCrud.SQL.Clear;
  qryQueryCrud.SQL.Add( ClausulaSQL );
  qryQueryCrud.Open;
  cdsClientDataSetCrud.Open;
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.qrbTituloBeforePrint(
  Sender: TQRCustomBand; var PrintBand: Boolean);
begin
  qriLogotipo.Left := Round( ( qrbTitulo.Width - qriLogotipo.Width ) / 2 );
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.qrpRelatorioPreview(
  Sender: TObject);
begin
  frmImprimirPrevisaoImpressao.qrpPrevisao.QRPrinter :=
    frmImprimirRelatorioCrudClientesComFotos.qrpRelatorio.QRPrinter;
  frmImprimirPrevisaoImpressao.Show;
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.qrbCabecalhoBeforePrint(
  Sender: TQRCustomBand; var PrintBand: Boolean);
begin
  PrintBand := EmCadaPaginaMostrarBandaCabecalhoComNomeColunas;
end;

procedure TfrmImprimirRelatorioCrudClientesComFotos.qrdNomePrint(sender: TObject;
  var Value: String);
begin
  {O Fato Deste Relatório Ser Produzido Com Linhas "Zebradas" Combinado Com a Possibilidade De Que
   Estas Linhas Possam Ter Sua Altura Diferente Entre Si Devido a Expansão Vertical De Algum Campo,
   Exige As Seguintes Providências Adicionais Abaixo. Se Não Forem Tomadas, o Resultado Seria a Falta
   Da Cobertura Completa Da Cor De Fundo Nas Linhas "Zebradas" Que Tivessem Sofrido Expansão Em Sua
   Altura:}
  qrbDetalhe.Height := AlturaPadraoBandaDetalheQuandoOcuparApenasUmaLinhaDeAltura;
end;

end.
