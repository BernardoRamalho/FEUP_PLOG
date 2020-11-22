:-include('../display/display.pl').
:-include('../control/gameController.pl').
:-include('../display/ui.pl').


% For now just display the initial boardstate
ampel(GameType):-
    initiateGame(GameState),
    askForGameType(GameType).