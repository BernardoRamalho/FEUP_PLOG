
:-include('../control/boardController.pl').

/**
    This file is where we make all the function that control the flow of the game.
    In here we have fnctions that run the game depending on the game type.
*/


initiateGame(GameState):-
    initial(GameState).