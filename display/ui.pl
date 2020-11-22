/**
    This file is where we make all the function that interact with the user.
    If we need to ask something or get the input, the fucntion is in this file.
*/

% Function used to let the player choose which game type he wants (Player vs Player, Ai vs Ai or Player vs Ai).
askForGameType(GameType):-
    displayGameTypeOptions,
    read(GameType).

displayGameTypeOptions:-
    write('Which type of game would you like to play?\n'),
    write('1 - Player vs Player;\n'),
    write('2 - Ai vs Ai;\n'),
    write('3 - Player vs Ai.\n'),
    write('Enter your option (number): ').