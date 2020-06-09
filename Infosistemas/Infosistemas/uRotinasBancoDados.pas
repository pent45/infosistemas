unit uRotinasBancoDados;

interface

uses
  SysUtils, Classes, Forms, SqlExpr, DB, DBClient, Provider, StrUtils, Windows,
  ADODB;

  function ConectarBancoDados_IB_FB_SeJaNaoConectado(
    NomeArquivoContendoBancoDados: String;
    UsuarioBancoDados: String;
    SenhaBancoDados: String;
    var sqlConnection: TSQLConnection ): Boolean;

  function ConectarQueryParaEdicaoBidirecionalBancoDados_IB_FB(
    NomeArquivoContendoBancoDados: String;
    UsuarioBancoDados: String;
    SenhaBancoDados: String;
    var sqlConnection: TSQLConnection;
    var sqlQuery: TSQLQuery;
    var dspDataSetProvider: TDataSetProvider;
    var cdsClientDataSet: TClientDataSet;
    var dtsDataSource: TDataSource ): Boolean;

implementation

uses
  uPrincipal;

(*
A Função Abaixo Permite Conectar Um Arquivo Contendo Um Banco de Dados Interbase Ou Firebird a Um
Componente "TSQLConnection". Isto Para Que, Depois, Este Banco de Dados Possa Ser Lido Por Meio De
Respectivas Queries Que Farão Uso Desta Conexão Estabelecida:
*)
function ConectarBancoDados_IB_FB_SeJaNaoConectado(
  NomeArquivoContendoBancoDados: String;
  UsuarioBancoDados: String;
  SenhaBancoDados: String;
  var sqlConnection: TSQLConnection ): Boolean;
var
  NomePastaParaArquivosDLLParaAcessoBancoDados: String;
begin
  if ( not sqlConnection.Connected ) or ( sqlConnection.Params.Values[ 'Database' ] <> NomeArquivoContendoBancoDados ) then
  begin
    if ( Trim( UsuarioBancoDados ) = '' ) then
      UsuarioBancoDados := UsuarioBancoDados;
    if ( Trim( SenhaBancoDados ) = '' ) then
      SenhaBancoDados := SenhaBancoDados;

    NomePastaParaArquivosDLLParaAcessoBancoDados := ExtractFilePath( Application.ExeName ) + 'Operacao\Dlls_Executaveis';
    frmPrincipal.ConverterNomeCompletoArquivoOperacaoParaOperacaoShared( NomePastaParaArquivosDLLParaAcessoBancoDados );

    sqlConnection.Close;
    sqlConnection.DriverName := 'Interbase';
    sqlConnection.GetDriverFunc := 'getSQLDriverINTERBASE';
    sqlConnection.LoginPrompt := False;
    sqlConnection.LibraryName := NomePastaParaArquivosDLLParaAcessoBancoDados + '\dbexpint.dll';
    sqlConnection.VendorLib := NomePastaParaArquivosDLLParaAcessoBancoDados + '\fbclient.dll';
    sqlConnection.Params.Values[ 'User_Name' ] := UsuarioBancoDados;
    sqlConnection.Params.Values[ 'Password' ] := SenhaBancoDados;
    sqlConnection.Params.Values[ 'Database' ] := NomeArquivoContendoBancoDados;

    if FileExists( sqlConnection.LibraryName ) and
       FileExists( sqlConnection.VendorLib ) and
       FileExists( sqlConnection.Params.Values[ 'Database' ] ) then
      sqlConnection.Open;
  end;

  Result := ( sqlConnection.Connected ) and ( sqlConnection.Params.Values[ 'Database' ] = NomeArquivoContendoBancoDados );
end;

(*
Depois Que Esta Função Abaixo Tenha Sido Executada Com Êxito, Será Possível Utilizar a "sqlQuery"
Com Aptidão Para Fazer Edições Bidirecionais No Banco De Dados. A Possibilidade de Edição Somente
Existirá Quando o Conteúdo da Cláusula SQL Não Contenha Operações Que Impeçam a Identificação
Exata do Registro a Editar. Por Exemplo, a Existência de Agrupamentos ou Combinação do Conteúdo de
Mais de Uma Tabela Impedirá a Edição dos Registros da "sqlQuery". Por Outro Lado, Com Cláusulas SQL
Simples, Estará Preservada a Posibilidade de Inserção, Remoção e Edição do Conteúdo das Tabelas
Referenciadas Pela Cláusula SQL Contida em "sqlQuery". Note Que Estas Eventuais Edições Não Devem
Ser Feitas Via o Objeto "sqlQuery" Propriamente Dito, Mas Com o Objeto "cdsClientDataSet" Em Seu
Lugar. Veja Abaixo Um Exemplo Ilustrativo de Como Fazer Isto e Que Considera Que Todos Os Objetos
Utilizados Já Estavam Instanciados Diretamente No "Form" Que Os Contém. Este Último Detalhe é Muito
Importante Porque, Caso Os Objetos Envolvidos Tenham Sido Criados Dinamicamente, Em Tempo De Execução,
Que é Necessário Que, Além De Se Acionarem Os Seus Respectivos Métodos "Create", Que Seus Nomes De
Objeto Sejam Setados Após o "Create". Os "Names" Destes Objetos, Quando Instanciados Em Tempo De
Execução, Nao Poderão Estar Em Branco:

  if ConectarQueryParaEdicaoBidirecionalBancoDados_IB_FB(
    'C:\Download\Conexao\TESTE_BD_E2012_T1_MUN_CAMPINAS_SP.GDB',
    '',
    '',
    sqlConnection,
    sqlQuery,
    dspDataSetProvider,
    cdsClientDataSet,
    dtsDataSource ) then
  begin
    {A "sqlQuery" Está Pronta Para Ser Tratada de Forma Editável Bidirecional, Podendo Ser Editada
     Pelos Métodos Post, Insert e Delete:}

    sqlQuery.Close;
    sqlQuery.SQL.Clear;

    {Setar a Cláusula SQL de Forma Adequada Para Que Seja Possível Editar o Resultado:}
    sqlQuery.SQL.Add( 'SELECT' );
    sqlQuery.SQL.Add( '  *' );
    sqlQuery.SQL.Add( 'FROM' );
    sqlQuery.SQL.Add( '  CAND_VEREADOR' );

    {Abrir o Resultado da "sqlQuery", Mas Note Que Utilizando Não Ela Diretamente, Mas o Seu "cdsClientDataSet":}
    cdsClientDataSet.Open;

    {Editar o Resultado da "sqlQuery", do Respectivo Registro Em Seu Resultado, No Banco de Dados Real, Mas Note
     Que Utilizando Não Ela Diretamente, Mas o Seu "cdsClientDataSet":}
    cdsClientDataSet.First;
    cdsClientDataSet.Edit;
    cdsClientDataSet.FieldByName( 'NOME_VOTAVEL' ).AsString := 'QUALQER COISA QUE ALTERE A COLUNA NOME_VOTAVEL';
    cdsClientDataSet.Post;

    {Ao Final é Necessário Utilizar o Método "ApplyUpdates" do "cdsClientDataSet". Isto Efetivamente Gravará as
     Edições Feitas no Arquivo de Banco de Dados, Coisa Que, Em Uma Query Comun, Monodirecional, Não Editável,
     Não Seria Possível:}
    cdsClientDataSet.ApplyUpdates( 0 );

    {Ou Ainda, Um Outro Exemplo, Agora de Inserção:}
    cdsClientDataSet.Append;
    cdsClientDataSet.FieldByName( 'COD_VOTAVEL' ).AsInteger := 1;
    cdsClientDataSet.FieldByName( 'NOME_VOTAVEL' ).AsString := 'MAIS UM CANDIDATO';
    cdsClientDataSet.FieldByName( 'QTD_VOTOS' ).AsInteger := 1000;
    cdsClientDataSet.Post;
    cdsClientDataSet.ApplyUpdates( 0 );
  end;
*)

function ConectarQueryParaEdicaoBidirecionalBancoDados_IB_FB(
  NomeArquivoContendoBancoDados: String;
  UsuarioBancoDados: String;
  SenhaBancoDados: String;
  var sqlConnection: TSQLConnection;
  var sqlQuery: TSQLQuery;
  var dspDataSetProvider: TDataSetProvider;
  var cdsClientDataSet: TClientDataSet;
  var dtsDataSource: TDataSource ): Boolean;
begin
  Result := ConectarBancoDados_IB_FB_SeJaNaoConectado(
    NomeArquivoContendoBancoDados,
    UsuarioBancoDados,
    SenhaBancoDados,
    sqlConnection );

  if Result then
  begin
    dspDataSetProvider.DataSet := sqlQuery;
    cdsClientDataSet.ProviderName := dspDataSetProvider.Name;
    dtsDataSource.DataSet := cdsClientDataSet;

    sqlQuery.SQLConnection := sqlConnection;
  end;
end;

end.

