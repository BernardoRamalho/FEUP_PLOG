
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
    % Get Level of askDifficulty of the AI
    askDifficulty(Level),

    % Play the Game
    setupEvE(0, GameState, 'Red', NewGameState),
    playEvE(NewGameState, Level, ['Red', 20, 0, []], ['Green', 20, 0, []]).


play(GameState, 3):-
    % Get Level of askDifficulty of the AI
    askDifficulty(Level),

    % Play the Game
    setupPvE(0, GameState, 'Red', NewGameState, 'player'),
    playPvE(NewGameState, Level, ['Red', 20, 0, []], ['Green', 20, 0, []], 'player').

/*
    Group of function that run the game based on the type of game.
*/

/*
    playPvP(GameState, Player, EnemyPlayer).
    This function is responsible for running the main Loop for a Player vs Player game.
    It displays the turn and Player Starts and then call the predicate takeTurn/2 to take the player turn.
    It is called recursivevly, only changing the player to enemyPlayer and vice versa.
    It succeds when the predicate game_over/1 succeds.
*/
playPvP(_, _, Player):-
    game_over(Player).

playPvP(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer):-
    displayPlayerTurn(PlayerColor),
    displayPlayerStats([PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]),

    takeTurn([GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer], [NewBoard, NewPlayer, NewEnemyPlayer]),
    playPvP(NewBoard, NewEnemyPlayer, NewPlayer).

/*
    playPvP(GameState, Player, EnemyPlayer).
    This function is responsible for running the main Loop for a AI vs AI game.
    It displays the turn and Player Starts and then call the predicate takeTurnmoveAI/3 to take the AI turn.
    It is called recursivevly, only changing the player to enemyPlayer and vice versa.
    It succeds when the predicate game_over/1 succeds.
*/
playEvE(_, _, _, Player):-
    game_over(Player).
    
playEvE(GameState, Level, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer):-
    displayPlayerTurn(PlayerColor),
    displayPlayerStats([PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]),
    
    moveAI([GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer], Level, [NewBoard, UpdatedPlayer, NewEnemyPlayer]),
    
    playEvE(NewBoard, Level, NewEnemyPlayer, UpdatedPlayer).

/*
    playPvP(GameState, Player, EnemyPlayer, PlayerType).
    This function is responsible for running the main Loop for a Player vs AI game.
    It displays the turn and Player Starts and then call the predicate takeTurn/2 or moveAI/3 depending on the PlayerType.
    It is called recursivevly, changing the player to enemyPlayer and vice versa and the PlayerType from 'player0 to 'ai' and vice versa.
    It succeds when the predicate game_over/1 succeds.
*/
playPvE(_, _, _, Player, _):-
    game_over(Player).

% Player Turn
playPvE(GameState, Level, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay],  EnemyPlayer, 'player'):-
    displayPlayerTurn(PlayerColor),
    takeTurn([GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer], [NewBoard, NewPlayer, NewEnemyPlayer]),
    playPvE(NewBoard, Level, NewEnemyPlayer, NewPlayer, 'ai').

% AI turn
playPvE(GameState, Level, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, 'ai'):-
    displayPlayerTurn(PlayerColor),
    moveAI([GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer], Level, [NewBoard, UpdatedPlayer, NewEnemyPlayer]),
    playPvE(NewBoard, Level, NewEnemyPlayer, UpdatedPlayer, 'player').

/*
    game_over(Winner).
    Succeds if the Winner is actually the winning player.
    This is confirmed if the Player passed as Winner as more then 2 semaphores.
    Display the Winner along side its stats.
*/

game_over([PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]):-
    PlayerSemaphores > 2,
    displayWinner(PlayerColor),
    displayPlayerStats([PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]).