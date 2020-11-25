% There 3 types of pieces
% yellow, red and green representing the colours of a 
% traffic light
pieceSymbol(empty, P) :- P = 'x'.
pieceSymbol(red, P) :- P = 'r'.
pieceSymbol(yellow, P) :- P = 'y'.
pieceSymbol(green, P) :- P = 'g'.
pieceSymbol('Green', P) :- P = 'G'.
pieceSymbol('Red', P) :- P = 'R'.
pieceSymbol(o, P) :- P = ' '.

% Conversion of number to letter
letter(1, L) :- L = 'A'.
letter(2, L) :- L = 'B'.
letter(3, L) :- L = 'C'.
letter(4, L) :- L = 'D'.
letter(5, L) :- L = 'E'.
letter(6, L) :- L = 'F'.
letter(7, L) :- L = 'G'.
letter(8, L) :- L = 'H'.
letter(9, L) :- L = 'I'.
letter(10, L) :- L = 'J'.
letter(11, L) :- L = 'G'.

% Printing fuctions

printHeader:-
    write('   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15| 16| 17| 18| 19| 20| 21| 22|\n'),
    write('   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n').

printFooter:-
    write('   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n'),
    write('   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15| 16| 17| 18| 19| 20| 21| 22|\n').

printBoard(X) :-
    printHeader,
    printPlayArea(X, 1),
    printFooter.

printPlayArea([], 12).

printPlayArea([Head|Tail], N):-
    letter(N, L),
    write(' '),
    write(L),
    write(' | '),
    printLine(Head),
    N1 is N + 1,
    printPlayArea(Tail, N1).

printLine([]):-
    write('  |\n').

printLine([Head|Tail]):-
    pieceSymbol(Head, P),
    write(P),
    write(' | '),
    printLine(Tail).

% Displays the initial board
displayInitialBoard:-
    initial(InitialBoard),
    printBoard(InitialBoard).

% Displays a possible intermediate board
displayIntermediateBoard:-
    intermediateBoard(IntermediateBoard),
    printBoard(IntermediateBoard).

% Displays a possible end board (half of the yellow pieces are gone, in this case 3 of the 5 yellow)
displayFinalBoard:-
    finalBoard(FinalBoard),
    printBoard(FinalBoard).

% Displays a GameState
displayGame(GameState):-
    printBoard(GameState).

displayGameTypeOptions:-
    write('Which type of game would you like to play?\n'),
    write('1 - Player vs Player;\n'),
    write('2 - Ai vs Ai;\n'),
    write('3 - Player vs Ai.\n'),
    write('Enter your option (number): ').

displayMovesHeader:-
    write('-----------------------------------\n'),
    write('|   |     Column   |      Row     |\n'),
    write('-----------------------------------\n').

displayMoves(Coords, NumberMoves, StartMove):-
    displayMovesHeader,
    displayMovesBody(Coords, NumberMoves, StartMove).

displayMovesBody([], NumberMoves, NumberMoves).

displayMovesBody([[Column|Row]|T], NumberMoves, StartMove):-
    write('  '),
    write(StartMove),
    write(' -->'),
    write('       '),
    write(Column),
    write('             '),
    write(Row),
    write('\n'),
    NewStartMove is StartMove + 1,
    displayMovesBody(T, NumberMoves, NewStartMove).



