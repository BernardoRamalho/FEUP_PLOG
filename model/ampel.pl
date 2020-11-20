:-include('../display/display.pl').
:-include('../control/boardController.pl').


% For now just display the initial boardstate
ampel:-
    initial(GameState),
    askForGameType(GameType),
    play(GameType).