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
Esta Fun��o Rotaciona o Conte�do Da Imagem. Seu Processamento � o Mais R�pido Poss�vel.

Seus Par�metros S�o, a Saber:

  - Bitmap:
      Contendo o Bitmap a Ser Rotacionado.

  - AnguloDeRotacaoEmGraus:
      Especificando o �ngulo Em Graus a Rotacionar Considerando Rota��o Em Sentido
      Hor�rio a Medida Em Que Este �ngulo � Positivo e Aumenta e Em Sentido Anti
      Hor�rio a Medida Em Que Este �ngulo � Negativo e Diminui.

  - AjustarDimensoes:
      Se For Passado Como True o Aspecto Da Imagem Ser� Ajustado Como Forma De
      Fazer Com Que a �rea De Largura e Altura Originais Continue Sendo Suficiente
      Para Coner Toda a Imagem Rotacionada.

  - CorDeFundo:
      Que Define a Cor de Fundo do Preenchimento, Para �reas Que N�o Contiverem
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
  {Assegurar Que a Cor De Fundo Desejada Para Rota��o Seja Reconhecida No Padr�o "RGB", Evitando a
   Possibilidade De Que Ele Venha Em Padr�o "BGR":}
  CorDeFundo := ColorToRGB( CorDeFundo );

  SinCos( DegToRad( AnguloDeRotacaoEmGraus ), SenoDoAngulo, CossenoDoAngulo );

  BitmapRotacionado := TBitmap.Create;

  BitmapRotacionado.TransparentColor   := Bitmap.TransparentColor;
  BitmapRotacionado.TransparentMode    := Bitmap.TransparentMode;
  BitmapRotacionado.Transparent        := Bitmap.Transparent;
  BitmapRotacionado.Canvas.Brush.Color := CorDeFundo;

  {Conforme Seja Para Ajustar Dimens�es ou N�o, Recalcular o Tamanho Do Bitmap Rotacionado e a
   Sua Nova Posi��o:}
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

  {Preparar Pontos De Refer�ncia Para a Rota��o:}
  Pontos[ 0 ].X := Round( OffsetX );
  Pontos[ 0 ].Y := Round( OffsetY );
  Pontos[ 1 ].X := Round( OffsetX + Bitmap.Width  * CossenoDoAngulo );
  Pontos[ 1 ].Y := Round( OffsetY + Bitmap.Width  * SenoDoAngulo );
  Pontos[ 2 ].X := Round( OffsetX - Bitmap.Height * SenoDoAngulo );
  Pontos[ 2 ].Y := Round( OffsetY + Bitmap.Height * CossenoDoAngulo );

  {Fazer a Rota��o Usando a Fun��o "PlgBlt" Da API do Windows Que Funciona De Forma Muito
   R�pida. Ela Realiza Uma Transfer�ncia Em Bloco Dos Bits De Dados De Cor Do Ret�ngulo
   Especificado No Contexto Do Dispositivo De Origem Para o Paralelogramo Especificado No
   Contexto Do Dispositivo De Destino:}
  Windows.PlgBlt(

    BitmapRotacionado.Canvas.Handle,  // Identificador Manipulador Para o Contexto Do Dispositivo De Destino.

    Pontos,                           // Apontador Para Matriz De Tr�s Pontos Que Identificad Tr�s Cantos Do
                                      // Paralelogramo De Destino. O Canto Superior Esquerdo Do Ret�ngulo De
                                      // Origem � Mapeado No Primeiro Ponto Desta Matriz. O Canto Superior
                                      // Direito � Mapeado No Segundo Ponto Desta Matriz. E Canto Inferior
                                      // Esquerdo � Mapeado No Terceiro Ponto. O Canto Inferior Direito Do
                                      // Ret�ngulo De Origem � Mapeado Para o Quarto Ponto o Qual N�o � Passado
                                      // Por Ser Implic�tio No Paralelograma.

    Bitmap.Canvas.Handle,             // Identificador Manipulador Para o Contexto Do Dispositivo De Origem.

    0,                                // A Coordenada "X", Horizontal, Do Canto Superior Esquerdo Do Ret�ngulo
                                      // De Origem.

    0,                                // A Coordenada "Y", Vertical, Do Canto Superior Esquerdo Do Ret�ngulo
                                      // De Origem.

    Bitmap.Width,                     // A Largura Do Ret�ngulo De Origem.

    Bitmap.Height,                    // A Altura Do Ret�ngulo De Origem.

    0,                                // Identificador Manipulador Opcional Para Bitmap De M�scara De Cor
                                      // (Aqui, Nesta Chamada, Ele N�o � Utilizado).

    0,                                // A Coordenada "X", Horizontal, Do Canto Superior Esquerdo Do Bitmap.

    0 );                              // A Coordenada "Y", Vertical, Do Canto Superior Esquerdo Do Bitmap.

  Bitmap.Assign( BitmapRotacionado );

  BitmapRotacionado.Free;
end;

{
Esta Fun��o Areedonda Os Quatro Cantos De Um Formul�rio. Seus Par�metros S�o:

  - Formulario:
      Especificando o Formul�rio TForm a Ter Os Seus Cantos Arredondados.

  - Raio:
      Raio De Arredondamento.

Um Exemplo De Utiliza��o Seria:

  Form_ArredondarCantos(
    Form1,  // Ou "Self"
    40 );

� Conveniente Que o "Form" J� Seja Criado e Esteja Setado Com "BorderStyle := bsNone"
J� Antes Do In�cio Da Execu��o Porque Notou-se, Em Vers�es Mais Antigas Do Windows 7,
Um Poss�vel Erro De "Access Violation" Quando Esta Setagem � Feita Em Tempo De Execu��o.
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
      0,                        // Coordenada Horizontal Do Canto Esquerdo Superior Da Regi�o
      0,                        // Coordenada Vertical Do Canto Esquerdo Superior Da Regi�o
      Formulario.ClientWidth,   // Coordenada Horizontal Do Canto Direito Inferior Da Regi�o
      Formulario.ClientHeight,  // Coordenada Vertical Do Canto Direito Inferior Da Regi�o
      Raio,                     // Raio De Arredondamento Na Altura Vertical
      Raio );                   // Raio De Arredondamento Na Largura Horizontal

  SetWindowRgn( Formulario.Handle, Regiao, True );
end;

{
Esta Fun��o Areedonda Os Quatro Cantos De Um Componente Visual. Seus Par�metros S�o:

  - Componente:
      Especificando o Componente Visual a Ter Os Seus Cantos Arredondados.

  - Raio:
      Raio De Arredondamento.

Um Exemplo De Utiliza��o Seria:

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
