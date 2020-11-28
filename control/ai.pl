:-include('movesController.pl').
test(Move):-
    initial(Board),
    printBoard(Board),
    chooseMove(Board, ['red', 18, 0, []], 0, Move).

% value(Move, Value, Player)
value([[_, FirstMove], BoardState], [PlayerColor, _, PlayerSemaphores, _], Value):-
    enemyColor(PlayerColor, EnemyColor),
    controlSemaphores(FirstMove, EnemyColor, BoardState, NrSemaphores, _),
    Value is PlayerSemaphores + NrSemaphores.

% chooseMove(GameState, Player, Level, Move)
chooseMove(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], Level, BestPlayerMove):-
    enemyColor(PlayerColor, EnemyPlayerColor),
    
    % Generate Move Player Pieces
    generateMovePlayerPieces(GameState, PlayerColor, MovePieceGamestates),
    !,
    getBestMove(MovePieceGamestates, BestPlayerMove, _, -1, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay]).


getBestMove([], BestMove, BestMove, _, _).

getBestMove([ CoordsMove | Rest], BestCoordsMove, CurrentBestMove, CurrentBestMoveValue,  Player):-
    getBestCoordsMove(CoordsMove, BestCoordMove, MoveValue, -1, _, Player),
    compareMoves(BestCoordMove, MoveValue, CurrentBestMove, CurrentBestMoveValue, BestMove, BestValue),
    getBestMove(Rest, BestCoordsMove, BestMove, BestValue, Player).


getBestCoordsMove([], BestMove, BestValue, BestValue, BestMove, _).

getBestCoordsMove([ Move | RemainingGameStates], BestMove, BestValue, CurrentBestValue, CurrentBestMove, Player):-
    value(Move, Player, MoveValue),
    compareMoves(Move, MoveValue, CurrentBestMove, CurrentBestValue, BetterMove, BetterValue),
    getBestCoordsMove(RemainingGameStates, BestMove, BestValue, BetterValue, BetterMove, Player).


compareMoves(Move1, Value1, _, Value2, Move1, Value1):-
    Value1 > Value2.

compareMoves(_, Value1, Move2, Value2, Move2, Value2):-
    Value2 >= Value1.











generateMovePlayerPieces(Board, PlayerColor, Gamestates):-
    getAllMovablePieces(Board, PlayerColor, MovablePieces, 1),
    getAllMoves(MovablePieces, Board, Moves),
    generateAllMovePlayerPieceBoards(Board, Moves, Gamestates).


/*
    generateAllMovePlayerPieceBoards(Board, Moves, AllMoves).
    Goes through all the possible moves and creates a board state for each of them.
    Moves is a list of type [ Move1, Move2, ..., MoveX], in which each MoveX is [StartCoords, EndCoords].
    AllMoves will be  a list of type [BoardState1, Boardstate2, ..., BoardstateX], in which each BoardstateX is [[StartCoord, EndCoord], FinalBoard]
*/ 
generateAllMovePlayerPieceBoards(_, [], []).
generateAllMovePlayerPieceBoards(Board, [[StartCoords, [FirstMove|RemainingMoves]] | Moves], [ FirstMoveBoard | RemainingBoards]):-    
    generateMovePlayerPieceBoards(Board, [StartCoords, [FirstMove|RemainingMoves]], FirstMoveBoard),
    generateAllMovePlayerPieceBoards(Board, Moves, RemainingBoards).

/*
    generateMovePlayerPieceBoards(Board, PieceMoves, FinalBoardStates).
    Goes through all the possible piece moves and creates a board state for each of them.
    Moves is a list of type [StartCoords, EndCoords], in which EndCoords are the places where the piece can go.
    AllFinalBoardStatesMoves will be  a list of type  [[StartCoord, EndCoord], FinalBoard].
*/ 

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
