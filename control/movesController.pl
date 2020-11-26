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
move(Board, Player, EnemyPlayer, NewBoard, UpdatedPlayer, NewEnemyPlayer):-
    % Stage 1: Move Player Piece
    printBoard(Board),
    movePlayerDisc(Board, Player, BoardMoved),

    % Stage 2: Move Enemy Piece
    printBoard(BoardMoved),
    moveEnemyDisc(BoardMoved, EnemyPlayer, BoardEnemyMoved),
    
    % Stage 3: Place a New Piece
    printBoard(BoardEnemyMoved),
    placeDisc(BoardEnemyMoved, Player, NewBoard, UpdatedPlayer),
    printBoard(NewBoard).

/*
    placeDisc(Board, Player, NewBoard)
    Asks where to place the piece.
    Checks if the place is valid.
    And places a piece of the Player in the Board at the coords given.
*/
placeDisc(Board, [PieceColor, NrPieces, _], NewBoard, [PieceColor, NewNrPieces, _]):-
    NrPieces > 0,
    getValidPosition(Coords, Board, 'empty'),
    setPieceAt(Coords, Board, PieceColor, NewBoard),
    NewNrPieces is NrPieces - 1.

placeDisc(_, Player, _, Player).

/*
    movePlayerDisc(Board, Player, BoardMoved)
    Asks the player for a piece to move and where to place it.
    Moves that piece to the desired place, leaving the spot empty.
*/
movePlayerDisc(Board, [PieceColor, PlayerPieces, _], BoardMoved):-
    % There must be pieces on the board
    PlayerPieces < 20,
    pieceColorLower(PieceColor, LowerColer),

    % Ask for a piece to move
    getValidPiece(Coords, Board, LowerColer),
    
    % Generate all possible Moves
    getNumberMoves(Board, Coords, [MovesNW, MovesNE, MovesE]),
    generateAllMoves(Coords, EndCoords, Board, MovesNW, MovesNE, MovesE),

    % Ask for a play and do it
    selectMove(EndCoords, SelectedMove),
    nth0(SelectedMove, EndCoords, MoveSelected, _),
    movePiece(Coords, MoveSelected, Board, BoardPieceMoved),

    % Check for Sempahores
    write('Checking for Semaphores!\n'),
    getSemaphores(MoveSelected, LowerColer, BoardPieceMoved, NrSemaphores, BoardMoved),
    write('SEMAPHORE!\n').


movePlayerDisc(Board, [PieceColor| _], Board):-
    write('There are no '),
    write(PieceColor),
    write(' pieces with valid moves.\n').

/*
    moveEnemyDisc(Board, EnemyPlayer, BoardMoved)
    Asks the player for a piece to move and where to place it.
    Moves that piece to the desired place, leaving the spot empty.
*/
moveEnemyDisc(Board, [PieceColor, PlayerPieces, _], BoardMoved):-
    % There must be pieces on the board
    PlayerPieces < 20,
    pieceColorLower(PieceColor, LowerColer),

    % Ask for a piece to move
    getValidPiece(Coords, Board, LowerColer),
    
    % Generate all possible Moves
    getNumberMoves(Board, Coords, [MovesNW, MovesNE, MovesE]),
    generateAllMoves(Coords, EndCoords, Board, MovesNW, MovesNE, MovesE),

    % Ask for a play and do it
    selectMove(EndCoords, SelectedMove),
    nth0(SelectedMove, EndCoords, MoveSelected, _),
    movePiece(Coords, MoveSelected, Board, BoardPieceMoved),

    % Check for Sempahores
    getSemaphores(MoveSelected, LowerColer, BoardPieceMoved, NrSemaphores, BoardMoved),
    write('SEMAPHORE!\n').


moveEnemyDisc(Board, [PieceColor| _], Board):-
    write('There are no '),
    write(PieceColor),
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

