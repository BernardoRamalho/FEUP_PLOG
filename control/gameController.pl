
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
	playPvP(NewGameState, ['Red', 13, 1, []], ['Green', 13, 0, []]).

play(GameState, 2):-
    setupEvE(0, GameState, 'Red', NewGameState),
    playEvE(NewGameState, 2, ['Red', 20, 0, []], ['Green', 20, 0, []]).


play(GameState, 3):-
    setupPvE(0, GameState, 'Red', NewGameState, 'player'),
    playPvE(NewGameState, 2, ['Red', 20, 0, []], ['Green', 20, 0, []], 'player').

/*
    Group of function that run the game based on the type of game.
*/

playPvP(_, _, Player):-
    game_over(Player).

playPvP(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer):-
    displayPlayerTurn(PlayerColor),
    displayPlayerStats([PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]),

    takeTurn(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, NewBoard, NewPlayer, NewEnemyPlayer),
    playPvP(NewBoard, NewEnemyPlayer, NewPlayer).


playEvE(_, _, _, Player):-
    game_over(Player).
    
playEvE(GameState, Level, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer):-
    displayPlayerTurn(PlayerColor),
    displayPlayerStats([PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]),
    
    moveAI(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, Level, NewBoard, UpdatedPlayer, NewEnemyPlayer),
    
    playEvE(NewBoard, Level, NewEnemyPlayer, UpdatedPlayer).

playPvE(_, _, _, Player, _):-
    game_over(Player).

playPvE(GameState, Level, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay],  EnemyPlayer, 'player'):-
    displayPlayerTurn(PlayerColor),
    move(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, NewBoard, NewPlayer, NewEnemyPlayer),
    playPvE(NewBoard, Level, NewEnemyPlayer, NewPlayer, 'ai').

playPvE(GameState, Level, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, 'ai'):-
    displayPlayerTurn(PlayerColor),
    moveAI(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, Level, NewBoard, UpdatedPlayer, NewEnemyPlayer),
    playPvE(NewBoard, Level, NewEnemyPlayer, UpdatedPlayer, 'player').

/*
    Group of function that are responsible for the Game_over.
*/

game_over([PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]):-
    PlayerSemaphores > 2,
    displayWinner(PlayerColor),
    displayPlayerStats([PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]).