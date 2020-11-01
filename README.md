# PLOG_RI_2020

# Ampel

Trata-se de um jogo de tabuleiro para 2 pessoas.  O seu nome deriva do alemão e significa "semáforo". Isto deve-se ao facto de o  que determina o vencedor é conseguir acumular o maior número de semáforos,sendo que cada semáforo consiste em três peças de cores diferentes e contíguas.


## Regras do jogo em geral  

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

## Representação interna do estado do jogo
### Situação inicial
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
### Situação intermédia
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
### Situação final
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

## Visualização do estado de jogo

O predicado de visualização começa por chamar uma função que desenha o header (consite em número para o jogador facilmente visualizar a coluna que quer escolher). 

Depois chama uma função recursiva responsável por desenhar o board state. Esta função escreve a letra que designa a linha que está a desenhar. Para desenhar o conteudo da linha do board state, é utilizado um função auxiliar. Esta função auxiliar percorre a linha enquanto converte o que encontra para o simbolo desejado e desenha esse simbolo no ecrã. Quando a linha acaba de ser desenha, a função reponsável por desenhar o board state chama-se a si própria, incrementando uma variavel. Quando essa variavel fica igual ao número máximo de linhas, encontra-se a condição de paragem.

No final de o board state estar desenhado, é chamada uma função para desenhar o footer (que é igual ao header mas invertido).



 ### Grupo Ampel_3

* Bernardo da Silva Moço de Soares Ramalho(up201704334)
* João Pedro Fontes Vilhena e Mascarenhas(up201806389)
