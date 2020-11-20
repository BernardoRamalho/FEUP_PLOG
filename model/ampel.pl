:-include('../display/display.pl').
:-include('../control/boardController.pl').
:-include('../display/ui.pl').


% For now just display the initial boardstate
ampel:-
    initial(GameState),
    askForGameType(GameType),
    play(GameType).