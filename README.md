# PLOG_RI_2020

# Ampel

Trata-se de um jogo de tabuleiro para 2 pessoas.  O seu nome deriva do alemão e significa "semáforo". Isto deve-se ao facto de o  que determina o vencedor é conseguir acumular o maior número de semáforos,sendo que cada semáforo consiste em três peças de cores diferentes e contíguas.


## Instalação e Execução

Para poder correr o programa é necessário ter o SICStus Prolog 4.6 instalado. Caso não tenha, sugerimos instalar antes de continuar a ler.

 * Em Windows, basta abrir a consola do SICStus e fazer 'Consult' (clicar no menu que diz File e aprece a aopção) do ficheiro que está dentro do model chamado 'ampel.pl'.
 * Em Linux, é preciso abrir o terminal e começar a consola do SICStus usando o comando sicstus-4.6.0. Depois disso, deve usar o comando consult([path-past-source-code]/model/ampel.pl).

Depois de ter conseguido fazer consult, basta chamar o predicado play escrevendo no SICStus 'play.'.

## Regras do jogo

O jogo começa com um tabuleiro vazio. 

Começa-se a fase de "setup" em que um dos jogadores, à sorte, joga um disco amarelo no tabuleiro, sem ser nas arestas ou vertices do "triângulo". O outro jogador faz igual e assim sucessivamente até um possível número máximo de 10 amarelos. Estes discos amarelos não se podem mover tirando quando forem removidos ao formar um semáforo.

Depois desta fase inicial pode começar o jogo em si e a primeira jogada é efetuada pelo penúltimo jogador a ter colocado um disco amarelo.

Cada jogada é constituída por:
1. Mover um dos discos do próprio jogador
1. Mover um dos discos do oponente(exceto o que acabou de ser jogado)
1. Adicionar um dos discos ao jogo mas sem poder formar diretamente um "semáforo"  
    
O jogo acaba quando um jogador acumula metade do total dos discos amarelos.    


### Regras do movimento do disco

* O disco só se pode mover em linha reta ao longo das linhas da malha triangular.
* O número de espaços que percorre é igual ao número total de discos nessa linha  
incluindo o próprio.
* O disco pode mudar de direção durante a jogada mas apenas se encontrar um  
obtáculo que impeça o movimento na mesma linha.Outros discos juntamente  
com as arestas e vertices do triângulo constituem obstáculos.O jogador decide  
a mudança de direção tendo como opções 60º ou 120º,esquerda ou direita.  


* O disco não pode acabar a jogada no mesmo ponto onde começou.



fonte:https://boardgamegeek.com/boardgame/151978/ampel
## Lógica do Jogo

### Representação interna do estado do jogo

Para representar o tabuleiro do jogo utilizamos uma lista de listas, em formato rectângular (11 linhas e 22 colunas). No entanto, para ficar o mais próximo possível do tabuleiro triangular do jogo, utilizamos um elemento para representar zona fora do tabuleiro.  

  
  As listas podem ter como elementos:
* 'o':- correspondente a uma posição da lista excluída do tabuleiro para obter a tal forma triangular.
* 'empty':- que corresponde a um ponto do tabuleiro que se encontra sem nenhuma peça.
* 'green'/'yellow'/'red':- corresponde a um ponto do tabuleiro no qual se encontra, respetivamente, uma peça verde,amarela ou vermelha.
* 'Green'/'Red':- corresponde à ultima peça posta pelo jogador verde ou vermelho (respetivamente). Esta peça não pode ser movida.

Cada jogador é representado pela sua cor, pelo número de peças que ainda pode jogar, pelo número de semáforos que já fez e pelo último movimento que fez. O primeiro jogador tem a cor vermelha e o segundo a cor verde.
#### Situação inicial
```
% The board begins with all of its position empty and
% consists of a pyramid with 11 levels
initial([
    [o, o, o, o, o, o, o, o, o, o, empty, o, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, o, empty, o, empty, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, empty, o, empty, o, empty, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o],
    [o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o],
    [o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o],
    [o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o],
    [o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o],
    [empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty]
]).

```
#### Situação intermédia
```
intermediateBoard([
    [o, o, o, o, o, o, o, o, o, o, empty, o, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, o, empty, o, empty, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, empty, o, empty, o, green, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, red, o, empty, o, empty, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, empty, o, yellow, o, empty, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, green, o, empty, o, o, o, o, o],
    [o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, yellow, o, empty, o, o, o, o],
    [o, o, o, empty, o, green, o, yellow, o, empty, o, empty, o, red, o, empty, o, empty, o, o, o],
    [o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o],
    [o, empty, o, empty, o, yellow, o, green, o, empty, o, empty, o, yellow, o, empty, o, empty, o, empty, o],
    [empty, o, red, o, empty, o, empty, o, empty, o, red, o, empty, o, empty, o, red, o, empty, o, empty]
]).

```
#### Situação final
```
finalBoard([
    [o, o, o, o, o, o, o, o, o, o, empty, o, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, o, green, o, empty, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, red, o, empty, o, green, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, red, o, empty, o, empty, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, red, o, empty, o, green, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, green, o, empty, o, o, o, o, o],
    [o, o, o, o, empty, o, green, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o],
    [o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, red, o, green, o, empty, o, o, o],
    [o, o, empty, o, red, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o],
    [o, green, o, empty, o, yellow, o, green, o, empty, o, red, o, yellow, o, empty, o, empty, o, empty, o],
    [empty, o, red, o, empty, o, empty, o, red, o, red, o, empty, o, green, o, red, o, empty, o, empty]
]).
```

### Representação das peças

As peças são representadas da seguinte forma:  

```
% There 3 types of pieces
% yellow, red and green representing the colours of a 
% traffic light
pieceSymbol(empty, P) :- P = 'x'.
pieceSymbol(red, P) :- P = 'R'.
pieceSymbol(yellow, P) :- P = 'Y'.
pieceSymbol(green, P) :- P = 'G'.
pieceSymbol(o, P) :- P = ' '.
```  

## Visualização do Estado de Jogo

O predicado de visualização começa por chamar uma função que desenha o header (consite em número para o jogador facilmente visualizar a coluna que quer escolher). 

Depois chama uma função recursiva responsável por desenhar o board state. Esta função escreve a letra que designa a linha que está a desenhar. Para desenhar o conteudo da linha do board state, é utilizado um função auxiliar. Esta função auxiliar percorre a linha enquanto converte o que encontra para o simbolo desejado e desenha esse simbolo no ecrã. Quando a linha acaba de ser desenha, a função reponsável por desenhar o board state chama-se a si própria, incrementando uma variavel. Quando essa variavel fica igual ao número máximo de linhas, encontra-se a condição de paragem.
Entre cada linha é desenhada uma sepração para ser mais fácil distinguir.

No final de o board state estar desenhado, é chamada uma função para desenhar o footer (que é igual ao header mas invertido).

## Lista de Jogadas Válidas

No nosso jogo existem dois tipos de movimento: mover uma peça de um sítio para o outro e colocar uma peça nova no tabuleiro. Uma jogada é composta por dois movimentos do primeiro tipo e um do segundo. Devido a isto achamos que era mais prático ter duas funções para achar as jogadas válidas. Para o primeiro tipo de movimento criamos um predicado chamado **valid_moves(StartCoords, EndCoords, Board, NWDDiagonalMoves, NEDiagonalMoves, ElineMoves)**. Este predicado recebe as coordenadas de uma peça (**StartCoords**) e retorna na variável **EndCoords** todos os movimentos que a peça pode fazer no actual **Board**. **NWDDiagonalMoves, NEDiagonalMoves e ElineMoves** são variáveis que mostram o número de movimentos que a peça pode fazer em cada diagonal e na horizontal, respetivamente.

Isto é feito usando predicados auxiliares que calculam os movimentos para cada direção. Quando é encontrado um obstaculo, são chamados todos os predicados auxiliares relativos às outras direções. Desta forma temos a certeza que todos os movimentos são criados.

No entanto, ao chamar tantos predicaods, no final, iriamos ficar com uma Lista de Listas que podia ter mais Listas de Listas dentro dela. Para isso foi criado um predicado **formatAllCoords(OldCoords, NewCoords)** que, como o nome indica, formata as coordenadas, isto é, mete todas as cordenadas numa unica Lista de Listas e apaga todos os duplicados e todas as listas vazias.
Para conseguir converter uma Lista com N niveis de listas dentro dela, tivemos de criar um predicado **appendAllLists(Old Coords, NewCoords, PlaceHolder)** que usa o predicado append/2 para converter as listas de listas em listas.

## Execução de Jogadas



 ### Grupo Ampel_3

* Bernardo da Silva Moço de Soares Ramalho(up201704334)
* João Pedro Fontes Vilhena e Mascarenhas(up201806389)
