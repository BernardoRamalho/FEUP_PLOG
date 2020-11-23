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
    [o, o, o, o, o, o, o, o, empty, o, empty, o, empty, o, o, o, o, o, o, o, o],
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
    changePieceAt(Column, PieceRow, PlayerPiece, ChangedRow)..

/*
    getPieceRow(Rows, Board, FirstRows, PieceRow, BoardRemaining).
    Goes through a number (Rows) of rows of the Board, saving them in FirtRows.
    When it get to the last row, it saves it in PieceRow and the rest raws in BoardRemaining
*/
getPieceRow(2, [H | [T | Z] ], H, T, Z).

getPieceRow(Rows, [H | T], [H | X], PieceRow, BoardRemaining):-
    NewRows is Rows - 1,
    getPieceRow(NewRows, T, X, PieceRow, BoardRemaining).

/*
    changePieceAt(Column, PieceRow, PlayerPiece, ChangedRow)
*/
changePieceAt(1, [H | T], PlayerPiece, [PlayerPiece | T]).


changePieceAt(Column, [H | T], PlayerPiece, [H | Z]):-
    NewColumn is Column - 1,
    changePieceAt(NewColumn, T, PlayerPiece, Z).