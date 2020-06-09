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
A Fun��o Abaixo Permite Conectar Um Arquivo Contendo Um Banco de Dados Interbase Ou Firebird a Um
Componente "TSQLConnection". Isto Para Que, Depois, Este Banco de Dados Possa Ser Lido Por Meio De
Respectivas Queries Que Far�o Uso Desta Conex�o Estabelecida:
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
Depois Que Esta Fun��o Abaixo Tenha Sido Executada Com �xito, Ser� Poss�vel Utilizar a "sqlQuery"
Com Aptid�o Para Fazer Edi��es Bidirecionais No Banco De Dados. A Possibilidade de Edi��o Somente
Existir� Quando o Conte�do da Cl�usula SQL N�o Contenha Opera��es Que Impe�am a Identifica��o
Exata do Registro a Editar. Por Exemplo, a Exist�ncia de Agrupamentos ou Combina��o do Conte�do de
Mais de Uma Tabela Impedir� a Edi��o dos Registros da "sqlQuery". Por Outro Lado, Com Cl�usulas SQL
Simples, Estar� Preservada a Posibilidade de Inser��o, Remo��o e Edi��o do Conte�do das Tabelas
Referenciadas Pela Cl�usula SQL Contida em "sqlQuery". Note Que Estas Eventuais Edi��es N�o Devem
Ser Feitas Via o Objeto "sqlQuery" Propriamente Dito, Mas Com o Objeto "cdsClientDataSet" Em Seu
Lugar. Veja Abaixo Um Exemplo Ilustrativo de Como Fazer Isto e Que Considera Que Todos Os Objetos
Utilizados J� Estavam Instanciados Diretamente No "Form" Que Os Cont�m. Este �ltimo Detalhe � Muito
Importante Porque, Caso Os Objetos Envolvidos Tenham Sido Criados Dinamicamente, Em Tempo De Execu��o,
Que � Necess�rio Que, Al�m De Se Acionarem Os Seus Respectivos M�todos "Create", Que Seus Nomes De
Objeto Sejam Setados Ap�s o "Create". Os "Names" Destes Objetos, Quando Instanciados Em Tempo De
Execu��o, Nao Poder�o Estar Em Branco:

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
    {A "sqlQuery" Est� Pronta Para Ser Tratada de Forma Edit�vel Bidirecional, Podendo Ser Editada
     Pelos M�todos Post, Insert e Delete:}

    sqlQuery.Close;
    sqlQuery.SQL.Clear;

    {Setar a Cl�usula SQL de Forma Adequada Para Que Seja Poss�vel Editar o Resultado:}
    sqlQuery.SQL.Add( 'SELECT' );
    sqlQuery.SQL.Add( '  *' );
    sqlQuery.SQL.Add( 'FROM' );
    sqlQuery.SQL.Add( '  CAND_VEREADOR' );

    {Abrir o Resultado da "sqlQuery", Mas Note Que Utilizando N�o Ela Diretamente, Mas o Seu "cdsClientDataSet":}
    cdsClientDataSet.Open;

    {Editar o Resultado da "sqlQuery", do Respectivo Registro Em Seu Resultado, No Banco de Dados Real, Mas Note
     Que Utilizando N�o Ela Diretamente, Mas o Seu "cdsClientDataSet":}
    cdsClientDataSet.First;
    cdsClientDataSet.Edit;
    cdsClientDataSet.FieldByName( 'NOME_VOTAVEL' ).AsString := 'QUALQER COISA QUE ALTERE A COLUNA NOME_VOTAVEL';
    cdsClientDataSet.Post;

    {Ao Final � Necess�rio Utilizar o M�todo "ApplyUpdates" do "cdsClientDataSet". Isto Efetivamente Gravar� as
     Edi��es Feitas no Arquivo de Banco de Dados, Coisa Que, Em Uma Query Comun, Monodirecional, N�o Edit�vel,
     N�o Seria Poss�vel:}
    cdsClientDataSet.ApplyUpdates( 0 );

    {Ou Ainda, Um Outro Exemplo, Agora de Inser��o:}
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

