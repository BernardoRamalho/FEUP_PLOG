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
letter(1, L) :- L = 'a'.
letter(2, L) :- L = 'b'.
letter(3, L) :- L = 'c'.
letter(4, L) :- L = 'd'.
letter(5, L) :- L = 'e'.
letter(6, L) :- L = 'f'.
letter(7, L) :- L = 'g'.
letter(8, L) :- L = 'h'.
letter(9, L) :- L = 'i'.
letter(10, L) :- L = 'j'.
letter(11, L) :- L = 'l'.

% Printing fuctions

printBoardHeader:-
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                                     B O A R D                                         |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15| 16| 17| 18| 19| 20| 21| 22|\n'),
    write('   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n').

printBoardFooter:-
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
    write('   |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n'),
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
	
displayPlaceYellowPieces:-
    write('\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                              STAGE 0 : PLACE YELLOW PIECES                            |\n'),
	write('   -----------------------------------------------------------------------------------------\n').

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
    write('\n').

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
    write('   -----------------------------------------------------------------------------------------\n').
 
displayWinner('Green'):-
    write('\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |              //////            !! GREEN PLAYER WINS !!           //////               |\n'),
    write('   -----------------------------------------------------------------------------------------\n').

displayPlayerStats([PlayerColor, PlayerPieces, PlayerSemaphores, _]):-
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |                                      PLAYER STATS                                     |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('   |            |       Colour       |   Pieces in Hand   |     Semaphores     |           |\n'),
    write('   -----------------------------------------------------------------------------------------\n'),
    write('                        '), write(PlayerColor), write('                   '), write(PlayerPieces), write('                   '), write(PlayerSemaphores), write('\n').

displayAIPlacePiece([Column, Row], Colour):-
    write('The AI decided to place a '), write(Colour), write(' piece at position:\n'),
    write('Column: '), write(Column), write('\n'),
    write('Row: '), write(Row), write('\n').

displayAIMovePiece([StartColumn, StartRow], [Column, Row], Colour):-
    write('The AI decided to move a '), write(Colour), write(' piece:\n'),
    write('   -----------------------------------\n'),
    write('   |          |   From   |     To    |\n'),
    write('   -----------------------------------\n'),
    write('   |  Column  |   '), write(StartColumn), write('   -->   '), write(Column), write('\n'),
    write('   ------------\n'),
    write('   |    Row   |   '), write(StartRow), write('   -->   '), write(Row), write('\n'),
    write('   ------------\n').

displayInitialScreen:-
	write('                  -------------------------------------------------------------------- \n'),
    write('                  |                                                                   |\n'),
	write('                  |                                                                   |\n'),
    write('                  |                      _    __   ______ ________                    |\n'),
	write('                  |                     / \\   | \\_/ |  _ \\| ____| |                   |\n'),
    write('                  |                    / _ \\  |  _  |  _) |  _| | |                   |\n'),
	write('                  |                   / ___ \\ | | | |  __/| |___| |___                |\n'),
    write('                  |                  /_|   |_\\|_| |_|_|   |_____|_____|               |\n'),
	write('                  |                                                                   |\n'),
	write('                  |                                                                   |\n'),
    write('                  |                                                                   |\n'),
	write('                   -------------------------------------------------------------------- \n'),
	write('\n'),
	write('\n'),
	write('\n').
	
	
displayInstructions:-
						    write(' ************************************************************************************************************'), nl,
							write('|                                                                                                            |'), nl,
                            write('|                                                                                                            |'), nl,
                            write('|                                            WELCOME TO AMPEL                                                |'), nl,
                            write('|                                                                                                            |'), nl,
                            write('|                                                                                                            |'), nl,
							write('|      THE OBJECTIVE IS TO FORM AS MANY SEMAPHORES AS YOU CAN.                                               |'), nl,
                            write('|                                                                                                            |'), nl,                                                 
							write('|      INICIALLY, YOU WILL HAVE TO PLACE YELLOW PIECES, ALONG WITH YOUR OPPONENT, ALTERNATELY, TO A          |'), nl,
							write('|      MAXIMUM OF 5 PIECES, BEING THAT ITS FORBIDDEN TO PLACE THEM IN THE EDGES OR CORNERS.                  |'), nl,
							write('|      EACH TURN IS COMPOSED BY 3 PHASES: MOVING A PIECE OF YOURS, MOVING AN ENEMY PIECE AND PLACING A       |'), nl,
							write('|      NEW ONE.                                                                                              |'), nl,
                            write('|                                                                                                            |'), nl,
                            write('|      YOU CANT FORM A SEMAPHORE ON STAGE 3, STAGE IN WHICH YOU PLACE A NEW PIECE.                           |'), nl,
                            write('|                                                                                                            |'), nl,
							write('|      EACH PLAYER CAN ONLY PLACE PIECES OF THE COLOR THAT CORRESPONDS TO HIM.PLAYER ONE IS ALWAYS RED,      |'), nl,   
							write('|      PLAYER TWO IS GREEN AND AI IS ALWAYS GREEN.                                                           |'), nl,
                            write('|                                                                                                            |'), nl,
							write('|      GOOD LUCK :)                                                                                          |'), nl,
                            write('|                                                                                                            |'), nl,
                            write('|                                                                                                            |'), nl,
							write(' ************************************************************************************************************ '), nl.
	

	



displayDifficultyMenu:-
    nl,
    nl,
	write(' ------------------------------------------------------- \n'),
	write('|                CHOOSE YOUR DIFFICULTY                 |\n'),
    write('|               _________________________               |\n'),
    write('|              |                         |              |\n'),
    write('|              |  1. EASY                |              |\n'),
    write('|              |_________________________|              |\n'),
    write('|              |                         |              |\n'),
    write('|              |  2. MEDIUM              |              |\n'),
    write('|              |_________________________|              |\n'),
    write('|              |                         |              |\n'),
    write('|              |  3. HARD                |              |\n'),
    write('|              |_________________________|              |\n'), 
    write('|                                                       |\n'),
    write('|                                                       |\n'),
	write(' ------------------------------------------------------- \n'),
    write('Enter your option (number): ').


displayGameTypeOptions:-
    nl,
    nl,
	write(' ------------------------------------------------------- \n'),
	write('|      WHICH TYPE OF GAME WOULD YOU LIKE TO PLAY?       |\n'),
	write('|               _ _ _ _ _ _ _ _ _ _ _ _ _               |\n'),
    write('|              |                         |              |\n'),
    write('|              | 1. PLAYER VS PLAYER     |              |\n'),
    write('|              |_________________________|              |\n'),
    write('|              |                         |              |\n'),
    write('|              | 2. AI VS AI             |              |\n'),
    write('|              |_________________________|              |\n'),
    write('|              |                         |              |\n'),
    write('|              | 3. PLAYER VS AI         |              |\n'),
    write('|              |_ _ _ _ _ _ _ _ _ _ _ _ _|              |\n'),
    write('|                                                       |\n'),
    write(' ------------------------------------------------------- \n'),
    write('Enter your option (number): ').