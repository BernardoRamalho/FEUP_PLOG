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
    [o, o, o, o, o, o, o, o, red, o, empty, o, empty, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o],
    [o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o],
    [o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o],
    [o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o],
    [o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o],
    [empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty]
]).

/*
    getValidPosition(Move, Board, PieceType)
    Uses the ui module to ask the user for a move.
    Checks if the position given as a piece equals to PieceType.
*/
getValidPosition(Coords, Board, PieceType):-
    askForMove(Coords),
    checkValidPosition(Coords, Board, PieceType).

getValidPosition(Coords, Board, PieceType):-
    askForMoveAgainMessage,
    getValidPosition(Coords, Board, PieceType).

/*
    checkValidPosition(Move, Board, PieceType)
    Checks if the move is valid. 
    Starts by checking if the column is in the correct range and checks if the spot has a piece of PieceType.
*/
checkValidPosition([Column|Row], Board, PieceType):-
    getStartColumn(Row, StartColumn),
    Column > (StartColumn - 1),
    getEndColumn(Row, EndColumn),
    Column < (EndColumn + 1),
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
    
