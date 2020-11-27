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

printBoardHeader:-
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                                     B O A R D                                         |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15| 16| 17| 18| 19| 20| 21| 22|\n'),
    write('   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n').

printBoardFooter:-
    write('   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n'),
    write('   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15| 16| 17| 18| 19| 20| 21| 22|\n'),
    write('   -----------------------------------------------------------------------------------------\n').

printBoard(X) :-
    printBoardHeader,
    printBoardPlayArea(X, 1),
    printBoardFooter.

printBoardPlayArea([], 12).

printBoardPlayArea([Head|Tail], N):-
    letter(N, L),
    write(' '),
    write(L),
    write(' | '),
    printLine(Head),
    N1 is N + 1,
    printBoardPlayArea(Tail, N1).

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

displayMovesBody([[Column,Row]|T], NumberMoves, StartMove):-
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

displayMovePieceHead:-
    write('\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                              STAGE 1 : MOVE YOUR PIECE                                |\n').

displayMoveEnemyPieceHead:-
    write('\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                              STAGE 2 : MOVE ENEMY PIECE                               |\n').

displayPlacePieceHead:-
    write('\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                               STAGE 3 : PLACE A PIECE                                 |\n').

displayPlayerTurn('Green'):-
    write('\n\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                                   GREEN PLAYER TURN                                    |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('\n\n').

displayPlayerTurn('Red'):-
    write('\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                                    RED PLAYER TURN                                     |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('\n').

displayWinner('Red'):-
    write('\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |              //////             !! RED PLAYER WINS !!           //////                |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('\n').
 
displayWinner('Green'):-
    write('\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |              //////            !! GREEN PLAYER WINS !!           //////               |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('\n').

displayPlayerStats([PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]):-
    write('\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                                      PLAYER STATS                                     |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |      |       Colour       |   Pieces in Hand   |     Semaphores     |      Prize      |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |      |         ').
displayAllMoves([]).
displayAllMoves([Move| RemainingMove]):-
    displayGeneratedMoves(Move),
    displayAllMoves(RemainingMove).
displayGeneratedMoves([_,[]]).
displayGeneratedMoves([StartCoords, [Move|RemainingMove]]):-
    write(StartCoords), write(' --> '), write(Move), write('\n'),
    displayGeneratedMoves([StartCoords, RemainingMove]).