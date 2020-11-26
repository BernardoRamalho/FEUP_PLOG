:-include('moveGenerator.pl').
%choose_move(GameState, Player, Level, Move).

%value(GameState, Player, Value).

test(Moves):-
    initial(Board),
    printBoard(Board),
    getAllMovablePieces(Board, 'red', Pieces, 1),
    write(Pieces),
    getAllMoves(Pieces, Board, Moves).

getAllMovablePieces([], _, [], _).

getAllMovablePieces([H|T], Player, Pieces, Row):-   
    getAllRowMovablePieces(H, Player, RowPieces, Row, 1),
    NewRow is Row + 1,
    getAllMovablePieces(T, Player, RemainingPieces, NewRow),
    append([RowPieces, RemainingPieces], Pieces).
    
/*
    getAllRowMovablePieces(Row, Player, PiecesCoords, CurentRowNumber, ColumnNumber).
    Returns all the pieces that can be chosen to be moved.
*/
getAllRowMovablePieces([], _, [], _, _).

getAllRowMovablePieces([H|T], Player, [[Column,Row]|X], Row, Column):-
    H = Player,
    NewColumn is Column + 1,
    getAllRowMovablePieces(T, Player, X, Row, NewColumn).

getAllRowMovablePieces([_|T], Player, Pieces, Row, Column):-
    NewColumn is Column + 1,
    getAllRowMovablePieces(T, Player, Pieces, Row, NewColumn).

/*
    getAllMoves(PiecesCoords, Board, Moves).
    Returns all the pieces that can be chosen to be moved.
*/
getAllMoves([], _, []).
getAllMoves([H|T], Board, [EndCoords | X]):-
    % Generate all possible Moves
    getNumberMoves(Board, H, [MovesNW, MovesNE, MovesE]),
    validMoves(H, EndCoords, Board, MovesNW, MovesNE, MovesE),
    write('\n'),
    write(EndCoords),
    getAllMoves(T, Board, X).
