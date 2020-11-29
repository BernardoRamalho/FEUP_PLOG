:-include('../control/gameController.pl').


% For now just display the initial boardstate
play:-
    initiateGame(GameState),
    askForGameType(GameType),
    play(GameState, GameType).
