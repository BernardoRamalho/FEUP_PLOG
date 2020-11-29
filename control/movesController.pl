:-include('moveGenerator.pl').

/**
    This file is where we make all the function that move the pieces.
*/


/*
    move(Board, Player)
    Player move has 3 stages.
    First the player moves one of its pieces.
    Then it moves one of the enemy pieces.
    And it places one piece. 
*/

move(Board, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, NewBoard, UpdatedPlayer, NewEnemyPlayer):-
    % Stage 1: Move Player Piece
    displayMovePieceHead,
    printBoard(Board),
    movePlayerDisc(Board, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, BoardMoved, PlayerAfterMove, EnemyAfterMove),

    % Stage 2: Move Enemy Piece
    displayMoveEnemyPieceHead,
    printBoard(BoardMoved),
    moveEnemyDisc(BoardMoved, EnemyAfterMove, PlayerAfterMove, BoardEnemyMoved, NewEnemyPlayer, PlayerEnemyMove),

    % Stage 3: Place a New Piece
    displayPlacePieceHead,
    printBoard(BoardEnemyMoved),
    placeDisc(BoardEnemyMoved, PlayerEnemyMove, NewBoard, UpdatedPlayer).

/*
    placeDisc(Board, Player, NewBoard)
    Asks where to place the piece.
    Checks if the place is valid.
    And places a piece of the Player in the Board at the coords given.
*/
placeDisc(Board, [PieceColor, NrPieces, PlayerSemaphores, LastMove], NextTurnBoard, [PieceColor, NewNrPieces, PlayerSemaphores, Coords]):-
    NrPieces > 0,
    pieceColorLower(PieceColor, LowerColor),
    getValidPosition(Coords, Board, 'empty', LowerColor),
    setPieceAt(Coords, Board, PieceColor, NewBoard),
    NewNrPieces is NrPieces - 1,
    lastMoveToLowerCase(LastMove, NewBoard, NextTurnBoard, PieceColor).

placeDisc(Board, [PieceColor, NrPieces, PlayerSemaphores, LastMove], NextTurnBoard, [PieceColor, NrPieces, PlayerSemaphores, []]):-
    lastMoveToLowerCase(LastMove, Board, NextTurnBoard, PieceColor).


/*
    setup(Board, Player, NewBoard)
    Asks where to place the yellowpiece.
    Checks if the place is valid.
    And places a piece in the Board at the coords given. Does this until five pieces have been putted.
*/
setupPvP(5,Board,_,Board).

setupPvP(Counter,Board, PieceColor, NewTurnBoard):-
	% Display Information
    displayPlayerTurn(PieceColor),
    displayPlaceYellowPieces,
	printBoard(Board),

    % Ask for Valid position and put a piece there
    getValidYellowPosition(Coords, Board, 'empty'),
    setPieceAt(Coords, Board, 'yellow', NewBoard),
	
    % Ask the other player to put another yellow piece
    PiecesPlaced is Counter+1,
	enemyColor(PieceColor,EnemyPieceColor),
	setupPvP(PiecesPlaced,NewBoard,EnemyPieceColor,NewTurnBoard).

/*
    movePlayerDisc(Board, Player, BoardMoved)
    Asks the player for a piece to move and where to place it.
    Moves that piece to the desired place, leaving the spot empty.
*/
movePlayerDisc(Board, [PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyColor, EnemyPieces, EnemySemaphores, EnemyLastMove], BoardMoved, UpdatedPlayer, UpdatedEnemy):-
    % There must be pieces on the board that as not been put there in the last play
    PlayerPieces < 20,
    pieceColorLower(PieceColor, LowerColer),
    existsInListofLists(Board, LowerColer),

    % Ask for a piece to move
    getValidPiece(Coords, Board, LowerColer),
    
    % Generate all possible Moves
    getNumberMoves(Board, Coords, [MovesNW, MovesNE, MovesE]),
    validMoves(Coords, EndCoords, Board, MovesNW, MovesNE, MovesE),

    % Ask for a play and do it
    selectMove(EndCoords, SelectedMove),
    nth0(SelectedMove, EndCoords, MoveSelected, _),
    movePiece(Coords, MoveSelected, Board, BoardPieceMoved),

    % Check for Sempahores
    getSemaphores(MoveSelected, LowerColer, BoardPieceMoved, NrSemaphores, BoardMoved),
    updatePlayers([PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyColor, EnemyPieces, EnemySemaphores, EnemyLastMove], NrSemaphores, UpdatedPlayer, UpdatedEnemy, 'player').


movePlayerDisc(Board, [PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], EnemyPlayer, Board, [PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], EnemyPlayer):-
    write('There are no '),
    write(PieceColor),
    write(' pieces with valid moves.\n').

/*
    moveEnemyDisc(Board, EnemyPlayer, BoardMoved)
    Asks the player for a piece to move and where to place it.
    Moves that piece to the desired place, leaving the spot empty.
*/
moveEnemyDisc(Board, [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], [PlayerColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], BoardMoved, UpdatedEnemy, UpdatedPlayer):-
    % There must be pieces on the board that as not been put there in the last play
    EnemyPieces < 20,
    pieceColorLower(EnemyPieceColor, LowerColer),
    existsInListofLists(Board, LowerColer),

    % Ask for a piece to move
    getValidPiece(Coords, Board, LowerColer),
    
    % Generate all possible Moves
    getNumberMoves(Board, Coords, [MovesNW, MovesNE, MovesE]),
    validMoves(Coords, EndCoords, Board, MovesNW, MovesNE, MovesE),

    % Ask for a play and do it
    selectMove(EndCoords, SelectedMove),
    nth0(SelectedMove, EndCoords, MoveSelected, _),
    movePiece(Coords, MoveSelected, Board, BoardPieceMoved),

    % Check for Sempahores
    getSemaphores(MoveSelected, LowerColer, BoardPieceMoved, NrSemaphores, BoardMoved),
    updatePlayers([PlayerColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], NrSemaphores, UpdatedPlayer, UpdatedEnemy, 'enemy').

moveEnemyDisc(Board, [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], Player, Board, [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], Player):-
    write('There are no '),
    write(EnemyPieceColor),
    write(' pieces with valid moves.\n').

/*
    movePiece(Coords, MoveSelected, Board, NewBoard).
    Moves the piece at Coords into MoveSelected.
    The change is saved in NewBoard.
*/
movePiece(Coords, MoveSelected, Board, NewBoard):-
    getPieceAt(Coords, Board, Piece),
    setPieceAt(Coords, Board, 'empty', IntermidiateBoard),
    setPieceAt(MoveSelected, IntermidiateBoard, Piece, NewBoard).

/*
    updatePlayers(Player, EnemyPlayer, NrSemaphores, UpdatedPlayer, UpdatedEnemy, MovedPiece)
*/ 

updatePlayers(Player, Enemy, 0, Player, Enemy, _).

updatePlayers([PlayerColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], 1, [PlayerColor, UpdatedPlayerPieces, UpdatedPlayerSemaphores, PlayerLastMove], [EnemyPieceColor, UpdatedEnemyPieces, EnemySemaphores, EnemyLastMove], _):-
    UpdatedPlayerSemaphores is PlayerSemaphores + 1,
    UpdatedPlayerPieces is PlayerPieces + 1,
    UpdatedEnemyPieces is EnemyPieces + 1.

updatePlayers([PlayerColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], NrSemaphores, [PlayerColor, UpdatedPlayerPieces, UpdatedPlayerSemaphores, PlayerLastMove], [EnemyPieceColor, UpdatedEnemyPieces, EnemySemaphores, EnemyLastMove], 'player'):-
    UpdatedPlayerSemaphores is PlayerSemaphores + NrSemaphores,
    PiecesUsed is NrSemaphores - 1,
    UpdatedPlayerPieces is PlayerPieces + PiecesUsed,
    UpdatedEnemyPieces is EnemyPieces + NrSemaphores.

updatePlayers([PlayerColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], NrSemaphores, [PlayerColor, UpdatedPlayerPieces, UpdatedPlayerSemaphores, PlayerLastMove], [EnemyPieceColor, UpdatedEnemyPieces, EnemySemaphores, EnemyLastMove], 'enemy'):-
    UpdatedPlayerSemaphores is PlayerSemaphores + NrSemaphores,
    PiecesUsed is NrSemaphores - 1,
    UpdatedPlayerPieces is PlayerPieces + NrSemaphores,
    UpdatedEnemyPieces is EnemyPieces + PiecesUsed.

