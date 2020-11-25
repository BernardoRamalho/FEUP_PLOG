:-include('../utils.pl').
:-include('display.pl').

/**
    This file is where we make all the function that interact with the user.
    If we need to ask something or get the input, the fucntion is in this file.
*/

% Function used to let the player choose which game type he wants (Player vs Player, Ai vs Ai or Player vs Ai).
askForGameType(GameType):-
    displayGameTypeOptions,
    read(GameType),
    skip_line.

% askPlacePiece(Move), ask the player for a place to put a piece

askPlacePiece([Column|Row]):-
    write('Enter the column and row where you want to place a piece.\n'),
    write('Column: '),
    read(Column),
    skip_line,
    write('Row: '),
    read(Letter),
    skip_line,
    letterToNumber(Letter,Row).

% askPiece(Move), ask the player for a place to put a piece

askPiece([Column|Row], Color):-
    write('Enter the column and row of the '),
    write(Color),
    write(' piece you want to move.\n'),
    write('Column: '),
    read(Column),
    skip_line,
    write('Row: '),
    read(Letter),
    skip_line,
    letterToNumber(Letter,Row).
    
selectMove(PossibleMoves, SelectedMove):-
    displayMoves(PossibleMoves, NumberMoves, 0),
    askOption(SelectedMove, NumberMoves).

askOption(SelectOption, MaxOption):-
    write('Please select one of the option above by typing the number of the option you desire: '),
    read(SelectOption),
    skip_line,
    SelectOption > -1,
    SelectOption < MaxOption.

askOption(SelectOption, MaxOption):-
    write('Invalid option given.\n'),
    askOption(SelectOption, MaxOption).


invalidInputMessage:-
    write('Invalid Input. Be sure to write capital letters or numbers.\n').