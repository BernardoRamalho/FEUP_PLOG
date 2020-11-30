:-include('movesController.pl').

:-use_module(library(random)).

test(L):-
    tested(Board),printBoard(Board),
    choose_move(Board, ['green', 8, 0, []], 1,L).

% value(Move, Player, Value)
/*
    value(GameState, Value, Player)
    Values the GAmestate according to how many semaphores where made. Returns the value in Player
*/
value([[_, FirstMove], BoardState], [PlayerColor, _, PlayerSemaphores, _], Value):-
    enemyColor(PlayerColor, EnemyColor),
    controlSemaphores(FirstMove, EnemyColor, BoardState, NrSemaphores, _),
    Value is PlayerSemaphores + NrSemaphores.

% 

/*
    choose_move(GameState, Player, Level, Move)
    This function calculates the best Move for a certain GameState.
    Since our move as three stages we choose the best for each stage.
    The way it chooses the best move depende on the Level.
    Level 1 -> random, Level 2 -> semi random, Level 3 -> chooses the best one each time
*/
choose_move(GameState, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], Level, [FirstMove, SecondMove, ThirdMove]):-
    enemyColor(PlayerColor, EnemyPlayerColor),

    % Generate Move Player Pieces
    generateMovePlayerPieces(GameState, PlayerColor, MovePieceGamestates),
    !,
    bestMove(MovePieceGamestates, [FirstMove, MovePieceBoardState], [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], Level, GameState),

    % Generate Move Enemy Pieces
    generateMovePlayerPieces(MovePieceBoardState, EnemyPlayerColor, MoveEnemyPieceGamestates),
    !,
    bestMove(MoveEnemyPieceGamestates, [SecondMove, MoveEnemyPieceBoardState], [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], Level, MovePieceBoardState),


    % Generate Place Piece
    generatePlacePlayerPieces(MoveEnemyPieceBoardState, PlayerColor, PlayerPieces, PlacePositions),
    !,
    getRandomMove(PlacePositions, ThirdMove).


/*
    bestMove(Moves, BestMove, Player Level, Board).
    Call an auxiliary function to get the best move. Checks if it needs to be a random move at Levle 3.
*/
bestMove([], [[] , Board], _, _, Board).
bestMove(Moves, BestMove, Player, 3, _):-
    getBestMovePiece(Moves, Move, _, -1, Player, 3, MoveValue),
    !,
    % If the MoveValue is 0 then there is no Best play, choose one randomly
    checkNeedForRandom(Moves, Move, MoveValue, BestMove, Player).

bestMove(Moves, BestMove, Player, Level, Board):-
    getBestMovePiece(Moves, BestMove, _, -1, Player, Level, Board).

/*
    getBestMovePiece(Moves, BestMove, CurentBestMove, CurrentBestMoveValue, Player, Level, BEstCoordValue).
    This function is an auxiliary fucntion to bestMove.
    This function calculates the best move from Moves depending on the level.
*/
% For Level 1 get a totally random Move
getBestMovePiece(Moves, [FirstMove, BoardState], _, _, _, 1, Board):-
   % Get random start piece
    getRandomMove(Moves, RandomMove, Board),
    % Get random move for that piece
    getRandomMove(RandomMove, [FirstMove, BoardState], Board).


% For Level 2 get a semi random Move
getBestMovePiece(Moves, BestCoordsMove, _, _, Player, 2, Board):-
    % Get random start piece
    getRandomMove(Moves, RandomMove, Board),
    % Get best move for that piece
    getBestCoordsMove(RandomMove, BestCoordsMove, _, -1, _, Player).    

% For Level 3 get the absolute best move
getBestMovePiece([], BestMove, BestMove, BestValue, _, 3, BestValue).

getBestMovePiece([ CoordsMove | Rest], BestCoordsMove, CurrentBestMove, CurrentBestMoveValue,  Player, 3, BestCoordValue):-
    getBestCoordsMove(CoordsMove, BestCoordMove, MoveValue, -1, _, Player),
    compareMoves(BestCoordMove, MoveValue, CurrentBestMove, CurrentBestMoveValue, BestMove, BestValue),
    getBestMovePiece(Rest, BestCoordsMove, BestMove, BestValue, Player, 3, BestCoordValue).

/*
    getBestCoordsMove(Moves, BestMove, BestValue, CurrentBestValue, CurrentBestMove, Player)
    Gets the Best move for a set of coords.
*/
getBestCoordsMove([], BestMove, BestValue, BestValue, BestMove, _).

getBestCoordsMove([ Move | RemainingGameStates], BestMove, BestValue, CurrentBestValue, CurrentBestMove, Player):-
    value(Move, Player, MoveValue),
    compareMoves(Move, MoveValue, CurrentBestMove, CurrentBestValue, BetterMove, BetterValue),
    getBestCoordsMove(RemainingGameStates, BestMove, BestValue, BetterValue, BetterMove, Player).

/*
    checkNeedForRandom(Moves, CurrentBestMove, Value, BestMove, Player).
    check if it needs to be a random move. Thi sis true when Value is 0. Else BestMove e CurrentBestMove.
*/
checkNeedForRandom(Moves, _, 0, BestMove, Player):-
   getBestMovePiece(Moves, BestMove, _, _, Player, 2, _).

checkNeedForRandom(_, Move, _, Move, _).

/*
    getRandomMove(Moves, RandomMove)
    Returns a random move from a list of moves.
*/
getRandomMove([], [[], Board], Board).
getRandomMove(Moves, RandomMove, _):-
    length(Moves, Length), 
    random(0, Length, RandomNumber), 
    nth0(RandomNumber, Moves, RandomMove).
    

/*
    generateMovePlayerPieces(Board, PlayerColor, Gamestates).
    Gets all the possible boardstates that the playe with PlayerColor can get if he moves a piece of it's color.
*/
generateMovePlayerPieces(Board, PlayerColor, Gamestates):-
    pieceColorLower(PlayerColor, LowerColor),
    getAllMovablePieces(Board, LowerColor, MovablePieces, 1),
    getAllMoves(MovablePieces, Board, Moves),
    generateAllMovePlayerPieceBoards(Board, Moves, Gamestates).


/*
    generateAllMovePlayerPieceBoards(Board, Moves, AllMoves).
    Goes through all the possible moves and creates a board state for each of them.
    Moves is a list of type [ Move1, Move2, ..., MoveX], in which each MoveX is [StartCoords, EndCoords].
    AllMoves will be  a list of type [BoardState1, Boardstate2, ..., BoardstateX], in which each BoardstateX is [[StartCoord, EndCoord], FinalBoard]
*/ 
generateAllMovePlayerPieceBoards(_, [], []).
generateAllMovePlayerPieceBoards(_, [[_, []]], []).
generateAllMovePlayerPieceBoards(Board, [[_, []] | Moves], [ [] | RemainingBoards]):-
    generateAllMovePlayerPieceBoards(Board, Moves, RemainingBoards).
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
    move(Board, [StartCoords, FirstMove], BoardState),
    generateMovePlayerPieceBoards(Board, [StartCoords, RemainingMoves], RemainingGameStates).


generateMoveEnemyPlayerPieceBoards(_, _, [], []).

generateMoveEnemyPlayerPieceBoards(Board, StartCoords, [FirstMove | RemainingMoves], [[ [StartCoords, FirstMove] , BoardState] | RemainingGameStates]):-
    move(Board, [StartCoords, FirstMove], BoardState),
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
    valid_moves(H, EndCoords, Board, MovesNW, MovesNE, MovesE),
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
    checkPiece(15, 7, Board, 'empty').

yellowAI([12, 10], Board):-
    checkPiece(12, 10, Board, 'empty').

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