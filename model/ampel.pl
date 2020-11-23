:-include('../control/gameController.pl').
:-include('../display/ui.pl').


% For now just display the initial boardstate
ampel:-
    initiateGame(GameState),
    askForGameType(GameType),
    play(GameState, GameType).
