:-include('../display/ui.pl').

/**
    This file is where we make all the function that control the board.
    In here we have functions that interacts with the board.
*/

/*
    The board begins with all of its position empty and
    consists of a pyramid with 11 levels
*/
initial([
    [o, o, o, o, o, o, o, o, o, o, empty, o, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, o, empty, o, empty, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, empty, o, red, o, red, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, red, o, red, o, red, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, empty, o, empty, o, red, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, empty, o, empty, o, red, o, red, o, empty, o, empty, o, o, o, o, o],
    [o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o],
    [o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o],
    [o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o],
    [o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o],
    [empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty]
]).

/*
    checkValidCoords(Coords);
    Checks if the coords are inside the coorct intervel
*/
checkValidCoords([Column|Row]):-
    getStartColumn(Row, StartColumn),
    Column > (StartColumn - 1),
    getEndColumn(Row, EndColumn),
    Column < (EndColumn + 1).


/*
    getValidPosition(Move, Board, PieceType)
    Uses the ui module to ask the user for a move.
    Checks if the position given as a piece equals to PieceType.
*/
getValidPosition(Coords, Board, PieceType):-
    askPlacePiece(Coords),
    checkValidPosition(Coords, Board, PieceType).

getValidPosition(Coords, Board, PieceType):-
    invalidInputMessage,
    getValidPosition(Coords, Board, PieceType).

/*
    getValidPiece(PieceCoords, Board, PieceType)
    Uses the ui module to ask the user for the position of a piece.
    Checks if the position given as a piece equals to PieceType.
*/
getValidPiece(Coords, Board, PieceType):-
    askPiece(Coords, PieceType),
    checkValidPosition(Coords, Board, PieceType).

getValidPiece(Coords, Board, PieceType):-
    invalidInputMessage,
    getValidPiece(Coords, Board, PieceType).


/*
    checkValidPosition(Move, Board, PieceType)
    Checks if the move is valid. 
    Starts by checking if the column is in the correct range and checks if the spot has a piece of PieceType.
*/
checkValidPosition([Column|Row], Board, PieceType):-
    checkValidCoords([Column|Row]),
    checkPiece(Column, Row, Board, Piece),
    Piece = PieceType.

/* 
    checkPiece(Column, Row, Board, PieceType).
    Gets the piece of the board at the row and column given.
    Checks if the spot is equal to PieceType.
*/    
checkPiece(Column, Row, Board, Piece):-
    getPieceAt([Column|Row], Board, Piece).

/*
    getPieceAt(Coords, Board, Piece).
    This function goes through the board until it gets to the Piece at the coordinates given.
*/ 
getPieceAt([Column|Row], Board, Piece):-
    getElementAt(Row, Board, PieceRow),
    getElementAt(Column, PieceRow, Piece).

/*
    setPieceAt(Coords, Board, Piece, NewBoard).
    This function goes through the board and changes the piece at Coords to the piece given.
    The new board state is saved in the NewBoard variable.
*/ 
setPieceAt([Column|Rows], Board, PlayerPiece, NewBoard):-
    getPieceRow(Rows, Board, FirstRows, PieceRow, BoardRemaining),
    changePieceAt(Column, PieceRow, PlayerPiece, ChangedRow),
    createNewBoard(NewBoard, FirstRows, ChangedRow, BoardRemaining).

/*
    getPieceRow(Rows, Board, FirstRows, PieceRow, BoardRemaining).
    Goes through a number (Rows) of rows of the Board, saving them in FirtRows.
    When it get to the last row, it saves it in PieceRow and the rest raws in BoardRemaining
*/
getPieceRow(1, [H | T], [], H, T).

getPieceRow(Rows, [H | T], [H | X], PieceRow, BoardRemaining):-
    NewRows is Rows - 1,
    getPieceRow(NewRows, T, X, PieceRow, BoardRemaining).

/*
    changePieceAt(Column, PieceRow, PlayerPiece, ChangedRow).
    Goes through the piece row until it gets to Column. Changes the piece there to Player piece.
    Save the changed row to ChangedRow.
*/
changePieceAt(1, [_ | T], PlayerPiece, [PlayerPiece | T]).


changePieceAt(Column, [H | T], PlayerPiece, [H | Z]):-
    NewColumn is Column - 1,
    changePieceAt(NewColumn, T, PlayerPiece, Z).

/*
    createNewBoard(NewBoard, FirstRows, ChangedRow, BoardRemaining)
*/
% Everything as been added
createNewBoard([], [], [], []).

% Add the BoardRemaining
createNewBoard([H | T], [], [], [H|Z]):-
    createNewBoard(T, [], [], Z).

% Add the ChangedRow
createNewBoard([ChangedRow|T], [], ChangedRow, BoardRemaining):-
    createNewBoard(T, [], [], BoardRemaining).

% Add the FirstRows
createNewBoard([H|T], [H|Z], ChangedRow, BoardRemaining):-
    createNewBoard(T, Z, ChangedRow, BoardRemaining).





% Calculates the number of moves in each direction for a piece
getNumberMoves(Board, PieceCoords, [MovesNW, MovesNE, MovesE]):-
    getNumberMovesNWDiagonal(Board, PieceCoords, MovesNW),
    getNumberMovesNEDiagonal(Board, PieceCoords, MovesNE),
    getNumberMovesEDiagonal(Board, PieceCoords, MovesE).


/*

    Get number of moves in each direction

*/

getNumberMovesNWDiagonal(Board, Start, Moves):-
    getNumberNWMoves(Board, Start, MovesNW),
    getNumberSEMoves(Board, Start, MovesSE),
    MovesCalculated is MovesNW + MovesSE,
    Moves is MovesCalculated + 1.

getNumberMovesNEDiagonal(Board, Start, Moves):-
    getNumberNEMoves(Board, Start, MovesNE),
    getNumberSWMoves(Board, Start, MovesSW),
    MovesCalculated is MovesNE + MovesSW,
    Moves is MovesCalculated + 1.

getNumberMovesEDiagonal(Board, Start, Moves):-
    getNumberEMoves(Board, Start, MovesE),
    getNumberWMoves(Board, Start, MovesW),
    MovesCalculated is MovesE + MovesW,
    Moves is MovesCalculated + 1.

/*

    Get number of moves in each way

*/
% Calculates the number of moves in the North West direction
getNumberNWMoves(Board, [Column|Row], MovesNW):-
    NewColumn is Column - 1,
    NewRow is Row - 1,
    checkValidPosition([NewColumn|NewRow], Board, 'empty'),
    getNumberNWMoves(Board,[NewColumn|NewRow], MovesNW).

getNumberNWMoves(Board, [Column|Row], MovesNW):-
    NewColumn is Column - 1,
    NewRow is Row - 1,
    checkValidCoords([NewColumn|NewRow]),
    getNumberNWMoves(Board,[NewColumn|NewRow], Moves),
    MovesNW is Moves + 1.

getNumberNWMoves(_, _, 0).

% Calculates the number of moves in the North East direction
getNumberNEMoves(Board, [Column|Row], MovesNE):-
    NewColumn is Column + 1,
    NewRow is Row - 1,
    checkValidPosition([NewColumn|NewRow], Board, 'empty'),
    getNumberNEMoves(Board,[NewColumn|NewRow], MovesNE).

getNumberNEMoves(Board, [Column|Row], MovesNE):-
    NewColumn is Column + 1,
    NewRow is Row - 1,
    checkValidCoords([NewColumn|NewRow]),
    getNumberNEMoves(Board,[NewColumn|NewRow], Moves),
    MovesNE is Moves + 1.

getNumberNEMoves(_, _, 0).

% Calculates the number of moves in the South West direction
getNumberSWMoves(Board, [Column|Row], MovesSW):-
    NewColumn is Column - 1,
    NewRow is Row + 1,
    checkValidPosition([NewColumn|NewRow], Board, 'empty'),
    getNumberSWMoves(Board,[NewColumn|NewRow], MovesSW).

getNumberSWMoves(Board, [Column|Row], MovesSW):-
    NewColumn is Column - 1,
    NewRow is Row + 1,
    checkValidCoords([NewColumn|NewRow]),
    getNumberSWMoves(Board,[NewColumn|NewRow], Moves),
    MovesSW is Moves + 1.

getNumberSWMoves(_, _, 0).

% Calculates the number of moves in the South East direction
getNumberSEMoves(Board, [Column|Row], MovesSE):-
    NewColumn is Column + 1,
    NewRow is Row + 1,
    checkValidPosition([NewColumn|NewRow], Board, 'empty'),
    getNumberSEMoves(Board,[NewColumn|NewRow], MovesSE).

getNumberSEMoves(Board, [Column|Row], MovesSE):-
    NewColumn is Column + 1,
    NewRow is Row + 1,
    checkValidCoords([NewColumn|NewRow]),
    getNumberSEMoves(Board,[NewColumn|NewRow], Moves),
    MovesSE is Moves + 1.

getNumberSEMoves(_, _, 0).

% Calculates the number of moves in the West direction
getNumberWMoves(Board, [Column|Row], MovesW):-
    NewColumn is Column - 2,
    checkValidPosition([NewColumn|Row], Board, 'empty'),
    getNumberWMoves(Board,[NewColumn|Row], MovesW).

getNumberWMoves(Board, [Column|Row], MovesW):-
    NewColumn is Column - 2,
    checkValidCoords([NewColumn|Row]),
    getNumberWMoves(Board,[NewColumn|Row], Moves),
    MovesW is Moves + 1.

getNumberWMoves(_, _, 0).

% Calculates the number of moves in the East direction
getNumberEMoves(Board, [Column|Row], MovesE):-
    NewColumn is Column + 2,
    checkValidPosition([NewColumn|Row], Board, 'empty'),
    getNumberEMoves(Board,[NewColumn|Row], MovesE).

getNumberEMoves(Board, [Column|Row], MovesE):-
    NewColumn is Column + 2,
    checkValidCoords([NewColumn|Row]),
    getNumberEMoves(Board,[NewColumn|Row], Moves),
    MovesE is Moves + 1.

getNumberEMoves(_, _, 0).