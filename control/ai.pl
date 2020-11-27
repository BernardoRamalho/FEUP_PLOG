:-include('movesController.pl').

%choose_move(GameState, Player, Level, Move).

%value(GameState, Player, Value).

test:-
    initial(Board),
    printBoard(Board),
    generatePlays(Board, 'red', 'green').

generatePlays(Board, PlayerColor, EnemyPlayerColor):-
    getAllMovablePieces(Board, PlayerColor, MovablePieces, 1),
    getAllMoves(MovablePieces, Board, Moves),
    generateAllMovePlayerPieceBoards(Board, Moves, PlayerMovedBoard),
    write(PlayerMovedBoard).



% generateAllMovePlayerPieceBoards(Board, Moves, AllMoves).
generateAllMovePlayerPieceBoards(_, [], []).
generateAllMovePlayerPieceBoards(Board, [[StartCoords, [FirstMove|RemainingMoves]] | Moves], [ FirstMoveBoard | RemainingBoards]):-    
    generateMovePlayerPieceBoards(Board, [StartCoords, [FirstMove|RemainingMoves]], FirstMoveBoard),
    generateAllMovePlayerPieceBoards(Board, Moves, RemainingBoards).

% generateMovePlayerPieceBoards(Board, Moves, BoardsMoves)

generateMovePlayerPieceBoards(_, [_, []], []).

generateMovePlayerPieceBoards(Board, [StartCoords, [FirstMove | RemainingMoves]], [[ [StartCoords, FirstMove] , BoardState] | RemainingGameStates]):- 
    movePiece( StartCoords, FirstMove, Board, BoardState),
    generateMovePlayerPieceBoards(Board, [StartCoords, RemainingMoves], RemainingGameStates).


generateMoveEnemyPlayerPieceBoards(_, _, [], []).

generateMoveEnemyPlayerPieceBoards(Board, StartCoords, [FirstMove | RemainingMoves], [[ [StartCoords, FirstMove] , BoardState] | RemainingGameStates]):-
    movePiece(Board, StartCoords, FirstMove, BoardState),
    generateMoveEnemyPlayerPieceBoards(Board, StartCoords, RemainingMoves, RemainingGameStates).



/*
    getAllMovablePieces(Board, Player, PiecesCoords, CurentRowNumber).
    Returns all the pieces of the Board that can be chosen to be moved.
*/

getAllMovablePieces([], _, [], _).

getAllMovablePieces([H|T], Player, Pieces, Row):-   
    getAllRowMovablePieces(H, Player, RowPieces, Row, 1),
    NewRow is Row + 1,
    getAllMovablePieces(T, Player, RemainingPieces, NewRow),
    append([RowPieces, RemainingPieces], Pieces).
    
/*
    getAllRowMovablePieces(Row, Player, PiecesCoords, CurentRowNumber, ColumnNumber).
    Returns all the pieces of a row that can be chosen to be moved. 
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
    Returns all moves of all the Pieces in PiecesCoords.
    Moves is a list of the following type [StartCoords, [EndCoord1, EndCoord2, ..., EndCoordX]]
*/
getAllMoves([], _, []).
getAllMoves([H|T], Board, [[H, EndCoords] | X]):-
    % Generate all possible Moves
    getNumberMoves(Board, H, [MovesNW, MovesNE, MovesE]),
    validMoves(H, EndCoords, Board, MovesNW, MovesNE, MovesE),
    getAllMoves(T, Board, X).
