
:-include('../control/ai.pl').

/**
    This file is where we make all the function that control the flow of the game.
    In here we have functions that run the game depending on the game type.
*/

% Initializes the game variables
initiateGame(GameState):-
    initial(GameState).

/*  
    play(GameState, GameType)
    Function responsible to call the play fuctions for each type of game.
    1 -> the game is Player vs Player (PvP)
    2 -> the game is Ai vs AI (EvE, that comes from the Environment vs Environment used in the gaming industry)
    3 -> the game is Player vs AI (PvE)
*/
play(GameState, 1):-
	setupPvP(0, GameState,'Red',NewGameState),
	playPvP(NewGameState, ['Red', 20, 0, []], ['Green', 20, 0, []], Winner),
    gameOver(Winner).

play(GameState, 2):-
    playEvE(GameState).

play(GameState, 3):-
    setupPvE(0, GameState, 'Red', NewGameState, 'player'),
    playPvE(NewGameState).

/*
    Group of function that run the game based on the type of game.
*/

playPvP(GameState, _, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], PlayerColor):-
    PlayerSemaphores > 2.

playPvP(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, Winner):-
    displayPlayerTurn(PlayerColor),
    move(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, NewBoard, NewPlayer, NewEnemyPlayer),
    playPvP(NewBoard, NewEnemyPlayer, NewPlayer, Winner).


playEvE(GameState):-
    write('EvE\n').

playPvE(GameState):-
    write('PvE\n').

/*
    Group of function that are responsible for the GameOver.
*/

gameOver(Winner, Board):-
    displayWinner(Winner),
    printBoard(Board).