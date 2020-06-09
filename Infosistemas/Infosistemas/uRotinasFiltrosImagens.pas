unit uRotinasFiltrosImagens;

interface

uses
  Windows,
  Forms,
  SysUtils,
  Classes,
  Graphics,
  GraphUtil,
  Controls,
  Messages,
  Math,
  ComCtrls,
  Richedit;

  procedure FI_Bitmap_Rotacionado(
    Bitmap: TBitmap;
    AnguloDeRotacaoEmGraus: Double;
    AjustarDimensoes: Boolean;
    CorDeFundo: TColor = clBlack );

  procedure Form_ArredondarCantos(
    Formulario: TForm;
    const Raio: SmallInt );

  procedure Componente_ArredondarCantos(
    Componente: TWinControl;
    const Raio: SmallInt );

implementation

{
Esta Função Rotaciona o Conteúdo Da Imagem. Seu Processamento é o Mais Rápido Possível.

Seus Parâmetros São, a Saber:

  - Bitmap:
      Contendo o Bitmap a Ser Rotacionado.

  - AnguloDeRotacaoEmGraus:
      Especificando o Ângulo Em Graus a Rotacionar Considerando Rotação Em Sentido
      Horário a Medida Em Que Este Ângulo é Positivo e Aumenta e Em Sentido Anti
      Horário a Medida Em Que Este Ângulo é Negativo e Diminui.

  - AjustarDimensoes:
      Se For Passado Como True o Aspecto Da Imagem Será Ajustado Como Forma De
      Fazer Com Que a Área De Largura e Altura Originais Continue Sendo Suficiente
      Para Coner Toda a Imagem Rotacionada.

  - CorDeFundo:
      Que Define a Cor de Fundo do Preenchimento, Para Áreas Que Não Contiverem
      Partes Da Imagem Original.
}
procedure FI_Bitmap_Rotacionado(
  Bitmap: TBitmap;
  AnguloDeRotacaoEmGraus: Double;
  AjustarDimensoes: Boolean;
  CorDeFundo: TColor = clBlack );
var
  SenoDoAngulo, CossenoDoAngulo: Extended;
  BitmapRotacionado: TBitmap;
  OffsetX: Double;
  OffsetY: Double;
  Pontos: Array[ 0 .. 2 ] of TPoint;
begin
  {Assegurar Que a Cor De Fundo Desejada Para Rotação Seja Reconhecida No Padrão "RGB", Evitando a
   Possibilidade De Que Ele Venha Em Padrão "BGR":}
  CorDeFundo := ColorToRGB( CorDeFundo );

  SinCos( DegToRad( AnguloDeRotacaoEmGraus ), SenoDoAngulo, CossenoDoAngulo );

  BitmapRotacionado := TBitmap.Create;

  BitmapRotacionado.TransparentColor   := Bitmap.TransparentColor;
  BitmapRotacionado.TransparentMode    := Bitmap.TransparentMode;
  BitmapRotacionado.Transparent        := Bitmap.Transparent;
  BitmapRotacionado.Canvas.Brush.Color := CorDeFundo;

  {Conforme Seja Para Ajustar Dimensões ou Não, Recalcular o Tamanho Do Bitmap Rotacionado e a
   Sua Nova Posição:}
  if AjustarDimensoes then
  begin
    BitmapRotacionado.Width  := Round( Bitmap.Width * Abs( CossenoDoAngulo ) + Bitmap.Height * Abs( SenoDoAngulo ) );
    BitmapRotacionado.Height := Round( Bitmap.Width * Abs( SenoDoAngulo ) + Bitmap.Height * Abs( CossenoDoAngulo ) );
    OffsetX                  := ( BitmapRotacionado.Width - Bitmap.Width * CossenoDoAngulo + Bitmap.Height * SenoDoAngulo ) / 2;
    OffsetY                  := ( BitmapRotacionado.Height - Bitmap.Width * SenoDoAngulo - Bitmap.Height * CossenoDoAngulo ) / 2;
  end
  else
  begin
    BitmapRotacionado.Width  := Bitmap.Width;
    BitmapRotacionado.Height := Bitmap.Height;
    OffsetX                  := ( Bitmap.Width - Bitmap.Width * CossenoDoAngulo + Bitmap.Height * SenoDoAngulo ) / 2;
    OffsetY                  := ( Bitmap.Height - Bitmap.Width * SenoDoAngulo - Bitmap.Height * CossenoDoAngulo ) / 2;
  end;

  {Preparar Pontos De Referência Para a Rotação:}
  Pontos[ 0 ].X := Round( OffsetX );
  Pontos[ 0 ].Y := Round( OffsetY );
  Pontos[ 1 ].X := Round( OffsetX + Bitmap.Width  * CossenoDoAngulo );
  Pontos[ 1 ].Y := Round( OffsetY + Bitmap.Width  * SenoDoAngulo );
  Pontos[ 2 ].X := Round( OffsetX - Bitmap.Height * SenoDoAngulo );
  Pontos[ 2 ].Y := Round( OffsetY + Bitmap.Height * CossenoDoAngulo );

  {Fazer a Rotação Usando a Função "PlgBlt" Da API do Windows Que Funciona De Forma Muito
   Rápida. Ela Realiza Uma Transferência Em Bloco Dos Bits De Dados De Cor Do Retângulo
   Especificado No Contexto Do Dispositivo De Origem Para o Paralelogramo Especificado No
   Contexto Do Dispositivo De Destino:}
  Windows.PlgBlt(

    BitmapRotacionado.Canvas.Handle,  // Identificador Manipulador Para o Contexto Do Dispositivo De Destino.

    Pontos,                           // Apontador Para Matriz De Três Pontos Que Identificad Três Cantos Do
                                      // Paralelogramo De Destino. O Canto Superior Esquerdo Do Retângulo De
                                      // Origem é Mapeado No Primeiro Ponto Desta Matriz. O Canto Superior
                                      // Direito é Mapeado No Segundo Ponto Desta Matriz. E Canto Inferior
                                      // Esquerdo é Mapeado No Terceiro Ponto. O Canto Inferior Direito Do
                                      // Retângulo De Origem é Mapeado Para o Quarto Ponto o Qual Não é Passado
                                      // Por Ser Implicítio No Paralelograma.

    Bitmap.Canvas.Handle,             // Identificador Manipulador Para o Contexto Do Dispositivo De Origem.

    0,                                // A Coordenada "X", Horizontal, Do Canto Superior Esquerdo Do Retângulo
                                      // De Origem.

    0,                                // A Coordenada "Y", Vertical, Do Canto Superior Esquerdo Do Retângulo
                                      // De Origem.

    Bitmap.Width,                     // A Largura Do Retângulo De Origem.

    Bitmap.Height,                    // A Altura Do Retângulo De Origem.

    0,                                // Identificador Manipulador Opcional Para Bitmap De Máscara De Cor
                                      // (Aqui, Nesta Chamada, Ele Não é Utilizado).

    0,                                // A Coordenada "X", Horizontal, Do Canto Superior Esquerdo Do Bitmap.

    0 );                              // A Coordenada "Y", Vertical, Do Canto Superior Esquerdo Do Bitmap.

  Bitmap.Assign( BitmapRotacionado );

  BitmapRotacionado.Free;
end;

{
Esta Função Areedonda Os Quatro Cantos De Um Formulário. Seus Parâmetros São:

  - Formulario:
      Especificando o Formulário TForm a Ter Os Seus Cantos Arredondados.

  - Raio:
      Raio De Arredondamento.

Um Exemplo De Utilização Seria:

  Form_ArredondarCantos(
    Form1,  // Ou "Self"
    40 );

É Conveniente Que o "Form" Já Seja Criado e Esteja Setado Com "BorderStyle := bsNone"
Já Antes Do Início Da Execução Porque Notou-se, Em Versões Mais Antigas Do Windows 7,
Um Possível Erro De "Access Violation" Quando Esta Setagem é Feita Em Tempo De Execução.
}
procedure Form_ArredondarCantos(
  Formulario: TForm;
  const Raio: SmallInt );
var
  Regiao: HRGN;
begin
  if ( Formulario.BorderStyle <> bsNone ) then
    Formulario.BorderStyle := bsNone;

  Regiao :=
    CreateRoundRectRgn(
      0,                        // Coordenada Horizontal Do Canto Esquerdo Superior Da Região
      0,                        // Coordenada Vertical Do Canto Esquerdo Superior Da Região
      Formulario.ClientWidth,   // Coordenada Horizontal Do Canto Direito Inferior Da Região
      Formulario.ClientHeight,  // Coordenada Vertical Do Canto Direito Inferior Da Região
      Raio,                     // Raio De Arredondamento Na Altura Vertical
      Raio );                   // Raio De Arredondamento Na Largura Horizontal

  SetWindowRgn( Formulario.Handle, Regiao, True );
end;

{
Esta Função Areedonda Os Quatro Cantos De Um Componente Visual. Seus Parâmetros São:

  - Componente:
      Especificando o Componente Visual a Ter Os Seus Cantos Arredondados.

  - Raio:
      Raio De Arredondamento.

Um Exemplo De Utilização Seria:

  Componente_ArredondarCantos(
    Panel1,
    60 );
}
procedure Componente_ArredondarCantos(
  Componente: TWinControl;
  const Raio: SmallInt );
var
  Area: TRect;
  Regiao: HRGN;
begin
  Area := Componente.ClientRect;
  Regiao :=
    CreateRoundRectRgn(
      Area.Left,
      Area.Top,
      Area.Right,
      Area.Bottom,
      Raio,
      Raio);

  Componente.Perform( EM_GETRECT, 0, lParam( @Area ) );
  InflateRect( Area, - 5, - 5 );

  Componente.Perform( EM_SETRECTNP, 0, lParam( @Area ) );
  SetWindowRgn( Componente.Handle, Regiao, True );

  Componente.Invalidate;
end;

end.
