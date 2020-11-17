:-include('../display/display.pl').
:-include('../control/boardController.pl').


% For now just display the initial boardstate
play:-
    initial(GameState),
    displayGame(GameState).