unit uImprimirPrevisaoImpressao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  QrPrntr, StdCtrls, ComCtrls, ExtCtrls, DB, Printers, quickrpt, QRExport,
  Buttons, dbtables, Menus, StrUtils, qrpdffilt, Math, uRotinasGerais,
  QRCtrls;

type
  TfrmImprimirPrevisaoImpressao = class(TForm)
    timTimer: TTimer;
    prdConfigurarImpressora: TPrintDialog;
    svdExportarDOC: TSaveDialog;
    svdExportarXLS: TSaveDialog;
    svdExportarPDF: TSaveDialog;
    pnImprimirPrevisaoImpressao: TPanel;
    pnlInferior: TPanel;
    lblProgresso: TLabel;
    qrpPrevisao: TQRPreview;
    pnlControles: TPanel;
    spdEnquadrarLargura: TSpeedButton;
    spdEnquadrarAltura: TSpeedButton;
    spdExportarPDF: TSpeedButton;
    spdExportarDOC: TSpeedButton;
    spdExportarXLS: TSpeedButton;
    spdPaginaFinal: TSpeedButton;
    spdPaginaSeguinte: TSpeedButton;
    spdPaginaAnterior: TSpeedButton;
    spdPaginaInicial: TSpeedButton;
    edtNumeroPagina: TEdit;
    updNumeroPagina: TUpDown;
    lblPagina: TLabel;
    lblZoom: TLabel;
    trbZoom: TTrackBar;
    spdSair: TSpeedButton;
    spdImprimir: TSpeedButton;
    procedure trbZoomChange(Sender: TObject);
    procedure AtualizarNumeroDaPagina;
    procedure timTimerTimer(Sender: TObject);
    procedure updNumeroPaginaClick(Sender: TObject; Button: TUDBtnType);
    procedure edtNumeroPaginaKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    function InformarCasoAindaEstejaCarregandoPaginasNaPrevisaoDoRelatorio: Boolean;
    procedure AjustarDimensoesDasColunasConformeModoRetratoOuPaisagem;
    procedure spdEnquadrarLarguraClick(Sender: TObject);
    procedure spdEnquadrarAlturaClick(Sender: TObject);
    procedure spdSairClick(Sender: TObject);
    procedure spdExportarPDFClick(Sender: TObject);
    procedure spdExportarDOCClick(Sender: TObject);
    procedure spdExportarXLSClick(Sender: TObject);
    procedure spdPaginaInicialClick(Sender: TObject);
    procedure spdPaginaAnteriorClick(Sender: TObject);
    procedure spdPaginaSeguinteClick(Sender: TObject);
    procedure spdPaginaFinalClick(Sender: TObject);
    procedure spdImprimirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    QuickReportReferencia: TQuickRep;
    QuantidadeTotalDePaginas: Integer;
    procedure PrepararRelatorioPrevisaoEmTela(
      TituloNoMonitorDeImpressao: String;
      var qrpRelatorio: TQuickRep;
      PodeDefinirOrientacaoImpressao: Boolean;
      ComecarMostrandoAjustadoNaAltura: Boolean );
    procedure LigarTimer;
    procedure DesligarTimer;
    function DefinirOrientacaoImpressao(
      var Orientacao: TPrinterOrientation;
      PodeDefinirOrientacaoImpressao: Boolean ): Boolean;
    procedure AssegurarCargaCorretaImagemEmQRImage(
      var QRImage: TQRImage;
      NomeArquivoContemImagemCorreta: String );
  end;

var
  frmImprimirPrevisaoImpressao: TfrmImprimirPrevisaoImpressao;

implementation

uses
  uPrincipal, uImprimirDefinirOrientacaoImpressao;

{$R *.DFM}

procedure TfrmImprimirPrevisaoImpressao.trbZoomChange(Sender: TObject);
begin
  qrpPrevisao.Zoom := trbZoom.Position;
end;

procedure TfrmImprimirPrevisaoImpressao.AtualizarNumeroDaPagina;
begin
  lblPagina.Caption :=
    'Página ' + IntToStr( qrpPrevisao.PageNumber ) +
    ' de ' + IntToStr( QuantidadeTotalDePaginas );

  {Acertar Controles UpDown:}
  edtNumeroPagina.Text := IntToStr( qrpPrevisao.PageNumber );
  updNumeroPagina.Min := 1;
  updNumeroPagina.Max := qrpPrevisao.QRPrinter.PageCount;

  {Acertar Botoes Do Controle De Navegacao De Paginas:}
  spdPaginaInicial.Enabled := True;
  spdPaginaAnterior.Enabled := True;
  spdPaginaSeguinte.Enabled := True;
  spdPaginaFinal.Enabled := True;
  if ( qrpPrevisao.PageNumber = 1 ) then
  begin
    spdPaginaInicial.Enabled := False;
    spdPaginaAnterior.Enabled := False;
  end;
  if ( qrpPrevisao.PageNumber = qrpPrevisao.QRPrinter.PageCount ) then
  begin
    spdPaginaFinal.Enabled := False;
    spdPaginaSeguinte.Enabled := False;
  end;
end;

procedure TfrmImprimirPrevisaoImpressao.PrepararRelatorioPrevisaoEmTela(
  TituloNoMonitorDeImpressao: String;
  var qrpRelatorio: TQuickRep;
  PodeDefinirOrientacaoImpressao: Boolean;
  ComecarMostrandoAjustadoNaAltura: Boolean );
var
  Orientacao: TPrinterOrientation;
  CursorAnterior: TCursor;
  NomePadronizadoArquivoExportar: WideString;
begin
  QuickReportReferencia := qrpRelatorio;

  TituloNoMonitorDeImpressao := Trim( TituloNoMonitorDeImpressao );
  QuickReportReferencia.ReportTitle := Trim( frmPrincipal.NomeCompletoDestePrograma ) + ' / ' + Trim( TituloNoMonitorDeImpressao );

  {Definir Nome Padronizado Para Aqrquivos a Eventualmente Exportar:}
  NomePadronizadoArquivoExportar := Trim( TituloNoMonitorDeImpressao );
  RemoverDiacriticosDeWideStringPreservandoCaixa( NomePadronizadoArquivoExportar );
  NomePadronizadoArquivoExportar := StringReplace( NomePadronizadoArquivoExportar, ' ', '_', [ rfReplaceAll ] );
  NomePadronizadoArquivoExportar := NomePadronizadoArquivoExportar + '_' + FormatDateTime( 'yyyymmddhhmmsszzz', Now );
  svdExportarDOC.FileName := NomePadronizadoArquivoExportar + '.doc';
  svdExportarXLS.FileName := NomePadronizadoArquivoExportar + '.xls';
  svdExportarPDF.FileName := NomePadronizadoArquivoExportar + '.pdf';

  if DefinirOrientacaoImpressao( Orientacao, PodeDefinirOrientacaoImpressao ) then
  begin
    if ( QuickReportReferencia.Page.Orientation <> Orientacao ) then
    begin;
      QuickReportReferencia.Page.Orientation := Orientacao;
      AjustarDimensoesDasColunasConformeModoRetratoOuPaisagem;
    end;

    CursorAnterior := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    frmImprimirPrevisaoImpressao.pnlInferior.Caption := 'Preparando Previsão... Aguarde Por Favor...';
    frmImprimirPrevisaoImpressao.qrpPrevisao.Visible := False;
    lblPagina.Caption := '';

    frmImprimirPrevisaoImpressao.Show;

    LigarTimer;
    QuickReportReferencia.Prepare;
    QuantidadeTotalDePaginas := QuickReportReferencia.QRPrinter.PageCount;
    QuickReportReferencia.PreviewModal;
    QuickReportReferencia.QRPrinter.PageCount := QuantidadeTotalDePaginas;
    DesligarTimer;

    if ( QuickReportReferencia <> Nil ) then
    begin
      Application.ProcessMessages;
      try
        if ( frmImprimirPrevisaoImpressao.qrpPrevisao <> Nil ) then
          frmImprimirPrevisaoImpressao.qrpPrevisao.Free;
        frmImprimirPrevisaoImpressao.qrpPrevisao := TQRPreview.Create( Self );
        frmImprimirPrevisaoImpressao.qrpPrevisao.Parent := pnlInferior;
        frmImprimirPrevisaoImpressao.qrpPrevisao.Align := alClient;
        frmImprimirPrevisaoImpressao.qrpPrevisao.QRPrinter :=
          QuickReportReferencia.QRPrinter;
      except
        frmImprimirPrevisaoImpressao.pnlInferior.Caption := 'Problema No Processamento. Por Favor, Saia e Tente Novamente...';
      end;
    end;
    AtualizarNumeroDaPagina;
    frmImprimirPrevisaoImpressao.qrpPrevisao.Visible := True;
    Screen.Cursor := CursorAnterior;

    frmImprimirPrevisaoImpressao.qrpPrevisao.Color := frmImprimirPrevisaoImpressao.pnlControles.Color;

    {A Visão Inicial da Previsão Do Relatório Pode Comecar Com a Página Sendo Mostrada
     Ajustada Na Sua Largura Ou Na Sua Altura, Conforme o Parâmetro de Chamada a Este
     Procedimento. Abaixo, Fazer os Ajustes Para Esta Finalidade, Os Quais Também Ajustarão
     A Posição Adequada Do Controle De Zoom:}
    frmImprimirPrevisaoImpressao.qrpPrevisao.Hide;
    EsperarSegundos( 1, False );
    if ComecarMostrandoAjustadoNaAltura then
      spdEnquadrarAlturaClick( Self )
    else
      spdEnquadrarLarguraClick( Self );
    frmImprimirPrevisaoImpressao.qrpPrevisao.Show;

    try
      frmImprimirPrevisaoImpressao.Hide;
      frmImprimirPrevisaoImpressao.ShowModal;
      QuickReportReferencia.QRPrinter.Free;
    except
      on Exception: EAccessViolation do
      begin
        Exception.Free;
      end;
    end;
  end;
end;

procedure TfrmImprimirPrevisaoImpressao.timTimerTimer(Sender: TObject);
begin
  lblProgresso.AutoSize := True;
  lblProgresso.Caption := 'Quantidade de Páginas Já Geradas: ' + IntToStr( QuickReportReferencia.PageNumber );
  lblProgresso.AutoSize := False;
  lblProgresso.Left := Round( ( pnlInferior.Width - lblProgresso.Width ) / 2 );
  Application.ProcessMessages;
end;

procedure TfrmImprimirPrevisaoImpressao.LigarTimer;
begin
  {O Indicador De Progresso De Montagem Da Previsão De Imptressão Somente é Ligado
   Quando o Relatório Está Sendo Montado Com Base No Conteúdo De Uma Tabela De Dados:}
  if ( QuickReportReferencia.DataSet <> Nil ) then
  begin
    lblProgresso.Caption := '';
    timTimer.Enabled := True;
  end;
  pnlControles.Enabled := False;
  Application.ProcessMessages;
end;

procedure TfrmImprimirPrevisaoImpressao.DesligarTimer;
begin
  Application.ProcessMessages;
  timTimer.Enabled := False;
  pnlControles.Enabled := True;
end;

procedure TfrmImprimirPrevisaoImpressao.updNumeroPaginaClick(Sender: TObject;
  Button: TUDBtnType);
begin
  qrpPrevisao.PageNumber := StrToInt( edtNumeroPagina.Text );
  AtualizarNumeroDaPagina;
end;

procedure TfrmImprimirPrevisaoImpressao.edtNumeroPaginaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char( 013 ) then
  begin
    qrpPrevisao.PageNumber := StrToInt( edtNumeroPagina.Text );
    AtualizarNumeroDaPagina;
  end
  else
    if Pos( Key, '0123456789' + Chr( 008 ) + Chr( 013 ) ) = 0 then
      Abort;
end;

function TfrmImprimirPrevisaoImpressao.DefinirOrientacaoImpressao(
  var Orientacao: TPrinterOrientation;
  PodeDefinirOrientacaoImpressao: Boolean ): Boolean;
var
  frmImprimirDefinirOrientacaoImpressao: TfrmImprimirDefinirOrientacaoImpressao;
begin
  Orientacao := poPortrait;
  Result := True;
  if PodeDefinirOrientacaoImpressao then
  begin
    frmImprimirDefinirOrientacaoImpressao := TfrmImprimirDefinirOrientacaoImpressao.Create( Self.Parent );
    frmImprimirDefinirOrientacaoImpressao.ShowModal;
    if frmImprimirDefinirOrientacaoImpressao.rdbRetrato.Checked then
      Orientacao := poPortrait
    else
      Orientacao := poLandscape;
    Result := ( frmImprimirDefinirOrientacaoImpressao.ModalResult = mrOK );
    frmImprimirDefinirOrientacaoImpressao.Release;
  end;
end;

procedure TfrmImprimirPrevisaoImpressao.FormKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of

    VK_PRIOR:
      spdPaginaAnteriorClick( Sender );

    VK_NEXT:
      spdPaginaSeguinteClick( Sender );

    VK_HOME:
      spdPaginaInicialClick( Sender );

    VK_END:
      spdPaginaFinalClick( Sender );

  end;
  
  Abort;
end;

procedure TfrmImprimirPrevisaoImpressao.FormShow(Sender: TObject);
begin
  qrpPrevisao.Cursor := crDefault;

  {Ajustar Janela, Caso Esteja Rodando Em Navegador Web:}
  frmPrincipal.AjustarDimensoesPanelFundoComFormParent( pnImprimirPrevisaoImpressao );

  Left := Round( ( Screen.Width - Width ) / 2 );
  Top := Round( ( Screen.Height - Height ) / 2 );

  {Providências Abaixo Destinadas a Sumir Com o Desenho Da Pequena Depressão Estética
   Que Apreceria Em Torno Da Previsão de Impressão, Em Especial Na Sua Parte Superior,
   Separando Esta Previsão Do Painel de Controles. Não Haveria Problema Em Deixar a
   Depressão, Mas Da Forma Abaixo o Aspecto Visual Fica Melhor:}
  pnImprimirPrevisaoImpressao.Realign;
  Application.ProcessMessages;

  pnlInferior.Align := alNone;
  pnlInferior.Left := 0;
  pnlInferior.Width := pnImprimirPrevisaoImpressao.Width;
  pnlInferior.Top := pnlControles.Height - 1;
  pnlInferior.Height := pnImprimirPrevisaoImpressao.Height - pnlControles.Height + 2;
end;

function TfrmImprimirPrevisaoImpressao.InformarCasoAindaEstejaCarregandoPaginasNaPrevisaoDoRelatorio: Boolean;
begin
  Result := ( qrpPrevisao.QRPrinter.PageCount < QuantidadeTotalDePaginas );

  if Result then
  begin
    frmPrincipal.AcionarFormProsseguir(
      'As Páginas Da Previsão Do Relatório Ainda Estão Sendo Carregadas.' + RetornoDeCarro( 01 ) +
      'Atualmente a Última Página Disponível é a ' +
        IntToStr( qrpPrevisao.QRPrinter.PageCount ) + ' de ' + IntToStr( QuantidadeTotalDePaginas ) + '.' + RetornoDeCarro( 01 ) +
      'Em Instantes, Todas As Páginas Da Previsão Estarão Disponíveis.',
      '',
      '',
      'Prosseguir',
      False );
  end;
end;

procedure TfrmImprimirPrevisaoImpressao.AjustarDimensoesDasColunasConformeModoRetratoOuPaisagem;
var
  Cont: Integer;
  MaximoLimiteDireito: Integer;
  ProporcaoDeAumento: Double;
  ControleASerImpresso: TQRPrintable;
  BandaDeCabecalho, BandaDeDetalhe: TQRCustomBand;
begin
  {Este Procedimento Servirá Para Redistribuir As Colunas e o Seu Conteúdo
   Proporcionalmente De Forma Que Preencha Todo o Papel Na Dimensão Horizontal.
   Ela é Necessário Devido a Eventual Impressão Em Modo Retrato Ou Paisagem:}

  if ( QuickReportReferencia.Bands.HasColumnHeader ) and
     ( QuickReportReferencia.Bands.HasDetail ) then
  begin
    {Pode Executar Pois Confirmou Que o Relatório Possui Cabecalho e Possui Detalhe:}
    BandaDeCabecalho := QuickReportReferencia.Bands.ColumnHeaderBand;
    BandaDeDetalhe := QuickReportReferencia.Bands.DetailBand;

    {Identificar o Ponto Mais a Direita Das Colunas Do Relatório:}
    MaximoLimiteDireito := 0;
    for Cont := 0 to BandaDeCabecalho.ControlCount - 1 do
    begin
      if BandaDeCabecalho.Controls[Cont] is TQRPrintable then
      begin
        ControleASerImpresso := TQRPrintable( BandaDeCabecalho.Controls[Cont] );

        MaximoLimiteDireito :=
          Max(
            MaximoLimiteDireito,
            ControleASerImpresso.Left + ControleASerImpresso.Width );
      end;
    end;

    if ( BandaDeCabecalho.Width > ( MaximoLimiteDireito + 50 ) ) then
    begin
      {A Largura Da Folha Comporta Uma Redistriuição Das Colunas Do Relatório:}
      ProporcaoDeAumento := BandaDeCabecalho.Width / MaximoLimiteDireito;

      {Aumentar Proporcionalmente a Banda De Cabeçalho:}
      for Cont := 0 to BandaDeCabecalho.ControlCount - 1 do
      begin
        if BandaDeCabecalho.Controls[Cont] is TQRPrintable then
        begin
          ControleASerImpresso := TQRPrintable( BandaDeCabecalho.Controls[Cont] );

          ControleASerImpresso.Left := Round( ProporcaoDeAumento * ( ControleASerImpresso.Left - 3 ) ) + 3;
          ControleASerImpresso.Width := Round( ProporcaoDeAumento * ControleASerImpresso.Width );
        end;
      end;

      {Aumentar Proporcionalmente a Banda De Detalhe:}
      for Cont := 0 to BandaDeDetalhe.ControlCount - 1 do
      begin
        if BandaDeDetalhe.Controls[Cont] is TQRPrintable then
        begin
          ControleASerImpresso := TQRPrintable( BandaDeDetalhe.Controls[Cont] );

          ControleASerImpresso.Left := Round( ProporcaoDeAumento * ( ControleASerImpresso.Left - 3 ) ) + 3;
          ControleASerImpresso.Width := Round( ProporcaoDeAumento * ControleASerImpresso.Width );
        end;
      end;
    end;
  end;
end;

procedure TfrmImprimirPrevisaoImpressao.spdEnquadrarLarguraClick(
  Sender: TObject);
begin
  qrpPrevisao.ZoomToWidth;
  trbZoom.Position := qrpPrevisao.Zoom;
end;

procedure TfrmImprimirPrevisaoImpressao.spdEnquadrarAlturaClick(Sender: TObject);
begin
  qrpPrevisao.ZoomToFit;
  trbZoom.Position := qrpPrevisao.Zoom;
end;

procedure TfrmImprimirPrevisaoImpressao.spdSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImprimirPrevisaoImpressao.spdExportarPDFClick(
  Sender: TObject);
var
  Prosseguir: Boolean;
begin
  if not InformarCasoAindaEstejaCarregandoPaginasNaPrevisaoDoRelatorio then
  begin
    if svdExportarPDF.Execute then
    begin
      Prosseguir := not FileExists( svdExportarPDF.FileName );

      if not Prosseguir then
        Prosseguir := (
          frmPrincipal.AcionarFormProsseguir(
            'Já Existe Um Arquivo Gravado Com Este Mesmo Nome.' + RetornoDeCarro( 02 ) +
            'Deseja Gravar Sobre o Arquivo Já Existente?',
            '',
            'Cancelar',
            'Prosseguir',
            False ) = mrYes );

      if Prosseguir then
      begin
        ExportarQuickReportComoPdf( QuickReportReferencia, svdExportarPDF.FileName, True );

        frmPrincipal.AcionarFormProsseguir(
            'O Relatório Foi Exportado Ao Formato Adobe Acrobat Reader PDF.' + RetornoDeCarro( 02 ) +
            'O Resultado Está Gravado No Arquivo:' + RetornoDeCarro( 01 ) +
            WrapText(
              svdExportarPDF.FileName,
              RetornoDeCarro( 01 ),
              [' ', '.', ':', ';', ',', '-', '_', '\' ],
             60 ) + '.',
            '',
            '',
            'Prosseguir',
            False );
      end;
    end;
  end;
end;

procedure TfrmImprimirPrevisaoImpressao.spdExportarDOCClick(
  Sender: TObject);
var
  Prosseguir: Boolean;
begin
  if not InformarCasoAindaEstejaCarregandoPaginasNaPrevisaoDoRelatorio then
  begin
    if svdExportarDOC.Execute then
    begin
      Prosseguir := not FileExists( svdExportarDOC.FileName );

      if not Prosseguir then
        Prosseguir := (
          frmPrincipal.AcionarFormProsseguir(
            'Já Existe Um Arquivo Gravado Com Este Mesmo Nome.' + RetornoDeCarro( 02 ) +
            'Deseja Gravar Sobre o Arquivo Já Existente?',
            '',
            'Cancelar',
            'Prosseguir',
            False ) = mrYes );

      if Prosseguir then
      begin
        QuickReportReferencia.ExportToFilter( TQRRTFExportFilter.Create( svdExportarDOC.FileName ));

        frmPrincipal.AcionarFormProsseguir(
            'O Relatório Foi Exportado Ao Formato MS Word.' + RetornoDeCarro( 02 ) +
            'O Resultado Está Gravado No Arquivo:' + RetornoDeCarro( 01 ) +
            WrapText(
              svdExportarDOC.FileName,
              RetornoDeCarro( 01 ),
              [' ', '.', ':', ';', ',', '-', '_', '\' ],
              60 ) + '.',
            'Exportado Ao Word',
            '',
            'Sim',
            False );
      end;
    end;
  end;
end;

procedure TfrmImprimirPrevisaoImpressao.spdExportarXLSClick(
  Sender: TObject);
var
  Prosseguir: Boolean;
begin
  if not InformarCasoAindaEstejaCarregandoPaginasNaPrevisaoDoRelatorio then
  begin
    if svdExportarXLS.Execute then
    begin
      Prosseguir := not FileExists( svdExportarXLS.FileName );

      if not Prosseguir then
        Prosseguir := (
          frmPrincipal.AcionarFormProsseguir(
            'Já Existe Um Arquivo Gravado Com Este Mesmo Nome.' + RetornoDeCarro( 02 ) +
            'Deseja Gravar Sobre o Arquivo Já Existente?',
            '',
            'Cancelar',
            'Prosseguir',
            False ) = mrYes );

      if Prosseguir then
      begin
        QuickReportReferencia.ExportToFilter( TQRXLSFilter.Create( svdExportarXLS.FileName ) );

        frmPrincipal.AcionarFormProsseguir(
            'O Relatório Foi Exportado Ao Formato MS Excel.' + RetornoDeCarro( 02 ) +
            'O Resultado Está Gravado No Arquivo:' + RetornoDeCarro( 01 ) +
            WrapText(
              svdExportarXLS.FileName,
              RetornoDeCarro( 01 ),
              [' ', '.', ':', ';', ',', '-', '_', '\' ],
              60 ) + '.',
            'Exportado Ao Excel',
            '',
            'Sim',
            False );
      end;
    end;
  end;
end;

procedure TfrmImprimirPrevisaoImpressao.spdPaginaInicialClick(
  Sender: TObject);
begin
  qrpPrevisao.PageNumber := 1;
  AtualizarNumeroDaPagina;
end;

procedure TfrmImprimirPrevisaoImpressao.spdPaginaAnteriorClick(
  Sender: TObject);
begin
  qrpPrevisao.PageNumber := qrpPrevisao.PageNumber - 1;
  AtualizarNumeroDaPagina;
end;

procedure TfrmImprimirPrevisaoImpressao.spdPaginaSeguinteClick(
  Sender: TObject);
begin
  qrpPrevisao.PageNumber := qrpPrevisao.PageNumber + 1;
  AtualizarNumeroDaPagina;
end;

procedure TfrmImprimirPrevisaoImpressao.spdPaginaFinalClick(
  Sender: TObject);
begin
  qrpPrevisao.PageNumber := qrpPrevisao.QRPrinter.PageCount;
  AtualizarNumeroDaPagina;

  InformarCasoAindaEstejaCarregandoPaginasNaPrevisaoDoRelatorio;
end;

{Linhas Estranhas Abaixo Que, Em Tese, Seriam Desnecessárias. Contudo, Devido a Um "Bug" na Biblioteca do Quick Report,
 Eventualmente as Imagens São Mostradas Simplesmente Como Se Fossem Um Bloco Branco Ou Preto. Desta Forma, Para Assegurar
 Que Esta Situação Eventual Não Ocorra, Deve-se Utilizar o Procedimento Abaixo No "Before Print" de Todas As Bandas Do
 Relatório Que Contenham Uma Imagem. Isto Irá Assegurar Que a Imagem Seja Carregada Corretamente Dentro de Um Certo Número
 De Tentativas.

 IMPORTANTE: O Uso Deste Procedimento Pode Ajudar Bastante a Tratar a Questão do "Bug" Acima Descrito. Contudo Mencionamos
 Que Uma Solução Melhor é a Conversão De Todas As Imagens Do Relatório, Que São Apresentadas Por Meio De Objetos Da Classe
 TQRImage, As Quais Estejam Nos Formato Bitmap Ou JPeg, Para o Formato PNG. Esta Ação Resolve e Dispensa Inclusive o Uso
 Do Procedimento Abaixo:}
procedure TfrmImprimirPrevisaoImpressao.AssegurarCargaCorretaImagemEmQRImage(
  var QRImage: TQRImage;
  NomeArquivoContemImagemCorreta: String );
const
  QuaatidadeMaximaTentativasFazer = 10;
var
  NomeArquivoImagemQueCarregouNoQRImage: String;
  ContTentativas: Integer;
  DeuCerto: Boolean;
begin
  {Preparar Nome De Arquivo Temporário Para Gravar Imagem Que Realmente Acabou Sendo Carregada No QRImage, Seja Ela a
   Imagem Correta Ou, Devido Ao "Bug" do Quick Report, Um Mero Bloco Branco Ou Preto:}
  NomeArquivoImagemQueCarregouNoQRImage :=
    NomePastaParaArquivosTemporariosDestaSessao + 'QRImage_Carregou_' + FormatDateTime( 'yyyymmddhhmmsszzz', Now );

  {Verificar Se a Imagem Correta Está Carregada. Se Não Estiver Correta, Tentar Novas Recargas Dentro De Uma Certa
   Quantidade de Tentativas. Se a Quantidade de Tentativas Não For Suficiente, Aí Sai e Desiste Para Evitar Que a
   Aplicação Entre Em Loop Infinito. Faz Isto Gravando a Imagem Que Está No QRImage Em Arquivo e Conferindo Se Ela
   Bate e é Idêntica à Imagem Que Realmente Deveria Estar Lá:}
  ContTentativas := - 1;
  repeat
    {Gravar Conteúdo Atual da Imagem Contida No QRImage Em Um Arquivo Temporário Em Disco:}
    QRImage.Picture.SaveToFile( NomeArquivoImagemQueCarregouNoQRImage );

    {Conferir Se a Imagem Do Arquivo Temporário Bate Com a Imagem Que Deveria Esta Lá:}
    DeuCerto :=
      ( CompararDoisArquivos_VerSeSaoIdenticos( NomeArquivoContemImagemCorreta, NomeArquivoImagemQueCarregouNoQRImage ) );

    {Apagar Arquivo Temporário Criado Com a Imagem Que Estava Carregada no QRImage. Isto Não Precisaria Ser
     Feito Porque a Própria Aplicação Eliminará Todos Os Arquivos Temporários Ao Final da Execução. Mas é
     Feito Aqui Apenas Por Economia de Espaço Em Disco:}
    ApagarArquivo( NomeArquivoImagemQueCarregouNoQRImage, False );

    {Se a Imagem Não Confere, Neste Caso Ocorreu o "Bug" Do Quick Report e a Imagem Correta
     Deve Ser Recarregada No QRImage:}
    if not DeuCerto then
    begin
      QRImage.AutoSize := True;
      QRImage.Stretch := True;
      QRImage.Picture.LoadFromFile( NomeArquivoContemImagemCorreta );
      QRImage.Repaint;
      EsperarSegundos( 0.1, False );
    end;

    {Incrementar o Contador de Tentativas:}
    ContTentativas := ContTentativas + 1;

  until ( DeuCerto ) or
        ( ContTentativas > QuaatidadeMaximaTentativasFazer );
end;

procedure TfrmImprimirPrevisaoImpressao.spdImprimirClick(Sender: TObject);
begin
  if ( frmPrincipal.AcionarFormProsseguir(
         'Pela Economia De Papel, Tinta e Recursos Naturais, Considere Usar a Impressora' + RetornoDeCarro( 01 ) +
         'Somente Quando For Essencial. Lembre-se Da Possibilidade Mais Simples De Gravar' + RetornoDeCarro( 01 ) +
         'Os Resultados Em Arquivos Sob Formato PDF.' + RetornoDeCarro( 02 ) +
         'Por Outro Lado, Sendo Para Imprimir, Este Aplicativo Poderá Direcionar Qualquer' + RetornoDeCarro( 01 ) +
         'Impressora Conectada, Mesmo Impressoras Na Nuvem Computacional e Acessíveis.' + RetornoDeCarro( 02 ) +
         'Confirma a Impressão?',
         '',
         'Não, Cancelar',
         'Sim, Imprimir',
         False ) = mrYes ) then
  begin
    {Fazer Impressão Em Ambiente Desktop:}

    {Linhas Estranhas Abaixo, Mas é Mesmo Desta Forma Que o Método "PrintSetup" Do QuickReport
     Retorna Se o Usuário Cancelou ou Não o Diálogo de Impressão. Se Retornar "Tag" Com Zero,
     Isto Significa Que Ele Confirmou:}
    QuickReportReferencia.PrinterSetup;
    if ( QuickReportReferencia.Tag = 0 ) then
    begin
      {Usuário Confirmou a Impressão:}
      QuickReportReferencia.Prepare;
      QuickReportReferencia.Print;
    end;
  end;
end;

end.
