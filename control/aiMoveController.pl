:-include('movesController.pl').

:-use_module(library(random)).

test(Move):-
    initial(Board),
    chooseMove(Board, ['red', 18, 0, []], 2, Move).

% value(Move, Value, Player)
value([[_, FirstMove], BoardState], [PlayerColor, _, PlayerSemaphores, _], Value):-
    enemyColor(PlayerColor, EnemyColor),
    controlSemaphores(FirstMove, EnemyColor, BoardState, NrSemaphores, _),
    Value is PlayerSemaphores + NrSemaphores.

% chooseMove(GameState, Player, Level, Move)
chooseMove(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], Level, [FirstMove, SecondMove, ThirdMove]):-
    enemyColor(PlayerColor, EnemyPlayerColor),
    
    % Generate Move Player Pieces
    generateMovePlayerPieces(GameState, PlayerColor, MovePieceGamestates),
    !,
    getBestMovePiece(MovePieceGamestates, [FirstMove, MovePieceBoardState], _, -1, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], Level),

    % Generate Move Enemy Pieces
    generateMovePlayerPieces(MovePieceBoardState, EnemyPlayerColor, MoveEnemyPieceGamestates),
    !,
    getBestMovePiece(MoveEnemyPieceGamestates, [SecondMove, MoveEnemyPieceBoardState], _, -1, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], Level),

    % Generate Place Piece
    generatePlacePlayerPieces(MoveEnemyPieceBoardState, PlayerColor, PlayerPieces, PlacePositions),
    !,
    getRandomMove(PlacePositions, ThirdMove).


getBestMovePiece(Moves, [FirstMove, BoardState], _, _, _, 1):-
    getRandomMove(Moves, RandomMove),
    getRandomMove(RandomMove, [FirstMove, BoardState]). 

getBestMovePiece(Moves, BestCoordsMove, _, _, Player, 2):-
    getRandomMove(Moves, RandomMove),
    getBestCoordsMove(RandomMove, BestCoordsMove, _, -1, _, Player).    

getBestMovePiece([], BestMove, BestMove, _, _, 3).

getBestMovePiece([ CoordsMove | Rest], BestCoordsMove, CurrentBestMove, CurrentBestMoveValue,  Player, 3):-
    getBestCoordsMove(CoordsMove, BestCoordMove, MoveValue, -1, _, Player),
    compareMoves(BestCoordMove, MoveValue, CurrentBestMove, CurrentBestMoveValue, BestMove, BestValue),
    getBestMovePiece(Rest, BestCoordsMove, BestMove, BestValue, Player).


getBestCoordsMove([], BestMove, BestValue, BestValue, BestMove, _).

getBestCoordsMove([ Move | RemainingGameStates], BestMove, BestValue, CurrentBestValue, CurrentBestMove, Player):-
    value(Move, Player, MoveValue),
    compareMoves(Move, MoveValue, CurrentBestMove, CurrentBestValue, BetterMove, BetterValue),
    getBestCoordsMove(RemainingGameStates, BestMove, BestValue, BetterValue, BetterMove, Player).


getRandomMove(Moves, RandomMove):-
    length(Moves, Length), 
    random(0, Length, RandomNumber), 
    nth0(RandomNumber, Moves, RandomMove).
    

/*
    generateMovePlayerPieces(Board, PlayerColor, Gamestates).
    Gets all the possible boardstates that the playe with PlayerColor can get if he moves a piece of it's color.
*/ 
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
    getAllMovablePieces(Board, PieceColor, PiecesCoords, CurentRowNumber).
    Returns all the pieces of the Board that can be chosen to be moved.
*/

getAllMovablePieces([], _, [], _).

getAllMovablePieces([H|T], PieceColor, Pieces, Row):-   
    getAllRowMovablePieces(H, PieceColor, RowPieces, Row, 1),
    NewRow is Row + 1,
    !,
    getAllMovablePieces(T, PieceColor, RemainingPieces, NewRow),
    append([RowPieces, RemainingPieces], Pieces).
    
/*
    getAllRowMovablePieces(Row, Player, PiecesCoords, CurentRowNumber, ColumnNumber).
    Returns all the pieces of a row that can be chosen to be moved. 
*/
getAllRowMovablePieces([], _, [], _, _).

getAllRowMovablePieces([H|T], Player, [[Column,Row]|X], Row, Column):-
    H = Player,
    !,
    NewColumn is Column + 1,
    getAllRowMovablePieces(T, Player, X, Row, NewColumn).

getAllRowMovablePieces([_|T], Player, Pieces, Row, Column):-
    !,
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

/*
    generatePlacePlayerPieces(Board, PlayerColor, Gamestates).
    Gets all the boardstates that the playe with PlayerColor can get if he places a piece on all the empty spaces.
*/ 
generatePlacePlayerPieces(Board, PlayerColor, PlayerPieces, EmptyPieces):-
    PlayerPieces > 0,
    getAllPlaceablePieces(Board, PlayerColor, EmptyPieces, 1, Board).

/*
    getAllMovablePieces(Board, PieceColor, PiecesCoords, CurentRowNumber).
    Returns all the positions of the Board that can be chosen to be placed a piece onto.
*/

getAllPlaceablePieces([], _, [], _, _).

getAllPlaceablePieces([H|T], PieceColor, Pieces, Row, Board):-   
    getAllRowPlaceablePieces(H, PieceColor, RowPieces, Row, 1, Board),
    NewRow is Row + 1,
    !,
    getAllPlaceablePieces(T, PieceColor, RemainingPieces, NewRow, Board),
    append([RowPieces, RemainingPieces], Pieces).
    
/*
    getAllRowPlaceablePieces(Row, PieceColor, PiecesCoords, CurentRowNumber, ColumnNumber).
    Returns all the positon of the row where it is possible to place a piece. 
*/
getAllRowPlaceablePieces([], _, [], _, _, _).

getAllRowPlaceablePieces([H|T], PieceColor, [[Column,Row]|X], Row, Column, Board):-
    H = 'empty',
    \+ checkForSemaphore([Column,Row], Board, PieceColor, _),
    !,
    NewColumn is Column + 1,
    getAllRowPlaceablePieces(T, PieceColor, X, Row, NewColumn, Board).

getAllRowPlaceablePieces([_|T], PieceColor, Pieces, Row, Column, Board):-
    !,
    NewColumn is Column + 1,
    getAllRowPlaceablePieces(T, PieceColor, Pieces, Row, NewColumn, Board).

/*
    compareMoves(Move1, Value1, Move2, Value2, BetterMove, BetterValue).
    Compares the value of the two moves and returns in BetterMove the move that has the biggest value. Saves that value into BetterValue
*/
compareMoves(Move1, Value1, _, Value2, Move1, Value1):-
    Value1 > Value2.

compareMoves(_, Value1, Move2, Value2, Move2, Value2):-
    Value2 >= Value1.

/*
    Function that return a place to put a yellow piece.
*/
yellowAI([11, 3], Board):-
    checkPiece(11, 3, Board, 'empty').

yellowAI([10, 8], Board):-
    checkPiece(10, 8, Board, 'empty').

yellowAI([5,9], Board):-
    checkPiece(5, 9, Board, 'empty').

yellowAI([15,7], Board):-
    checkPiece(13, 7, Board, 'empty').

yellowAI([12, 10], Board):-
    checkPiece(12, 19, Board, 'empty').

yellowAI([11, 7], Board):-
    checkPiece(11, 7, Board, 'empty').

yellowAI([12, 6], Board):-
    checkPiece(12, 6, Board, 'empty').

yellowAI([11,7], Board):-
    checkPiece(11, 7, Board, 'empty').

yellowAI([7, 7], Board):-
    checkPiece(7, 7, Board, 'empty').

yellowAI([8, 6], Board):-
    checkPiece(8, 6, Board, 'empty').

yellowAI([14, 8], Board):-
    checkPiece(12, 8, Board, 'empty').