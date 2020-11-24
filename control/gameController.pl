
:-include('../control/movesController.pl').

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
    playPvP(GameState, ['Red', 20]).

play(GameState, 2):-
    playEvE(GameState).

play(GameState, 3):-
    playPvE(GameState).

/*
    Group of function that run the game based on the type of game.
*/
playPvP(GameState, Player):-
    move(GameState, Player, NewBoard, NewPlayer).

playEvE(GameState):-
    write('EvE\n').

playPvE(GameState):-
    write('PvE\n').