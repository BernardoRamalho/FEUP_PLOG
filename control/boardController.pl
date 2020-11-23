:-include('../utils.pl').


% The board begins with all of its position empty and
% consists of a pyramid with 11 levels
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

% getPieceAtColumn(Column, Row, Piece), this function goes through the row until it gets to the desired column.
getPieceAtColumn(1, [H|_], H).

getPieceAtColumn(Column, [_|T], Piece):-
    NewColumn is Column - 1,
    getPieceAtColumn(NewColumn, T, Piece).

% getPieceAtRow(Coords, Board, Piece), this function goes through the rows until it gets to the desired row.
getPieceAtRow([Column | 1], [CurrentRow | _], Piece):-
    getPieceAtColumn(Column, CurrentRow, Piece).

getPieceAtRow([Column|Row], [_ | NextRows], Piece):-
    NextRow is Row - 1,
    getPieceAtRow([Column | NextRow], NextRows, Piece).

% checkValidMove(Move, Board) checks if there the move is valid

checkValidMove([Column|Row], Board):-
    getStartColumn(Row, StartColumn),
    Column > (StartColumn - 1),
    getEndColumn(Row, EndColumn),
    Column < (EndColumn + 1),
    checkValidColumnRow(Column, Row).


checkValidMove([Column|Row], Board):-
    write('Invalid Column').

/* 
    Checks if the column is valid for the row
    If the row is even, then the column must be even as well due to the triangular board.
    The same goes for if the row is odd, the column must be odd then.
*/
checkValidColumnRow(Column, Row):-
    (Row mod 2) =:= 0,
    (Column mod 2) =:= 0.

checkValidColumnRow(Column, Row):-
    (Row mod 2) =:= 1,
    (Column mod 2) =:= 1.
    
