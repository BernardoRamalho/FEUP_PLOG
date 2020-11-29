:-include('aiMoveController.pl').

setupPvE(5,Board,_,Board, _).

setupPvE(Counter,Board, PieceColor, NewTurnBoard, 'player'):-
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
	setupPvE(PiecesPlaced,NewBoard,EnemyPieceColor,NewTurnBoard, 'ai').

setupPvE(Counter,Board, PieceColor, NewTurnBoard, 'ai'):-
	% Display Information
    displayPlayerTurn(PieceColor),
    displayPlaceYellowPieces,
	printBoard(Board),
	
    % Get AI yellow piece and place it
    yellowAI(AICoords, Board),
    setPieceAt(AICoords, Board, 'yellow', NewBoard),
    displayAIPlacePiece(AICoords, 'yellow'),
    sleep(1),

    % Ask the other player to put another yellow piece
    PiecesPlaced is Counter+1,
	enemyColor(PieceColor,EnemyPieceColor),
	setupPvE(PiecesPlaced,NewBoard,EnemyPieceColor,NewTurnBoard, 'player').

setupEvE(5,Board,_,Board).

setupEvE(Counter,Board, PieceColor, NewTurnBoard):-
	% Display Information
    displayPlayerTurn(PieceColor),
    displayPlaceYellowPieces,
	printBoard(Board),
	
    % Get AI yellow piece and place it
    yellowAI(AICoords, Board),
    setPieceAt(AICoords, Board, 'yellow', NewBoard),
    displayAIPlacePiece(AICoords, 'yellow'),

    % Ask the other player to put another yellow piece
    PiecesPlaced is Counter+1,
	enemyColor(PieceColor,EnemyPieceColor),
	setupEvE(PiecesPlaced,NewBoard,EnemyPieceColor,NewTurnBoard).

moveAI(Board, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, Level, NewBoard, UpdatedPlayer, NewEnemyPlayer):-
    % Get Moves to be done
    chooseMove(Board, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], Level, [MovePlayerDisc, MoveEnemyDisc, PlaceDisc]),

    % Stage 1: Move Player Piece
    displayMovePieceHead,
    printBoard(Board),
    moveAIDisc(Board, MovePlayerDisc, [PlayerColor, PlayerPieces, PlayerSemaphores, LastPlay], EnemyPlayer, BoardMoved, PlayerAfterMove, EnemyAfterMove),
    sleep(1),

    % Stage 2: Move Enemy Piece
    displayMoveEnemyPieceHead,
    printBoard(BoardMoved),
    moveAIEnemyDisc(BoardMoved, MoveEnemyDisc, EnemyAfterMove, PlayerAfterMove, BoardEnemyMoved, NewEnemyPlayer, PlayerEnemyMove),
    sleep(1),

    % Stage 3: Place a New Piece
    displayPlacePieceHead,
    printBoard(BoardEnemyMoved),
    placeAIDisc(BoardEnemyMoved, PlaceDisc, PlayerEnemyMove, NewBoard, UpdatedPlayer),
    sleep(1).


/*
    moveAIDisc(Board, Player, BoardMoved)
    Asks the player for a piece to move and where to place it.
    Moves that piece to the desired place, leaving the spot empty.
*/

moveAIDisc(Board, [], [PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], EnemyPlayer, Board, [PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], EnemyPlayer):-
    write('There are no '),
    write(PieceColor),
    write(' pieces with valid moves.\n').

moveAIDisc(Board, [StartCoords, EndCoords], [PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], EnemyPlayer, BoardMoved, UpdatedPlayer, UpdatedEnemy):-
    movePiece(StartCoords, EndCoords, Board, BoardPieceMoved),
    displayAIMovePiece(StartCoords, EndCoords, PieceColor),

    % Check for Sempahores
    pieceColorLower(PieceColor, LowerColer),
    getSemaphores(EndCoords, LowerColer, BoardPieceMoved, NrSemaphores, BoardMoved),
    updatePlayers([PieceColor, PlayerPieces, PlayerSemaphores, PlayerLastMove], EnemyPlayer, NrSemaphores, UpdatedPlayer, UpdatedEnemy, 'player').


/*
    moveAIEnemyDisc(Board, EnemyPlayer, BoardMoved)
    Asks the player for a piece to move and where to place it.
    Moves that piece to the desired place, leaving the spot empty.
*/
moveAIEnemyDisc(Board, [], [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], Player, Board, [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], Player):-
    write('There are no '),
    write(EnemyPieceColor),
    write(' pieces with valid moves.\n').

moveAIEnemyDisc(Board, [StartCoords, EndCoords], [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], Player, BoardMoved, UpdatedEnemy, UpdatedPlayer):-
    % Move tha piece
    movePiece(StartCoords, EndCoords, Board, BoardPieceMoved),
    displayAIMovePiece(StartCoords, EndCoords, EnemyPieceColor),

    % Check for Sempahores
    pieceColorLower(EnemyPieceColor, LowerColer),
    getSemaphores(EndCoords, LowerColer, BoardPieceMoved, NrSemaphores, BoardMoved),
    updatePlayers(Player, [EnemyPieceColor, EnemyPieces, EnemySemaphores, EnemyLastMove], NrSemaphores, UpdatedPlayer, UpdatedEnemy, 'enemy').

/*
    placeAIDisc(Board, Move, Player, NewBoard)
    Asks where to place the piece.
    Checks if the place is valid.
    And places a piece of the Player in the Board at the coords given.
*/
placeAIDisc(Board, [], [PieceColor, NrPieces, PlayerSemaphores, LastMove], NextTurnBoard, [PieceColor, NrPieces, PlayerSemaphores, []]):-
    write('The AI has no more pieces to place.\n'),
    lastMoveToLowerCase(LastMove, Board, NextTurnBoard, PieceColor).

placeAIDisc(Board, Move, [PieceColor, NrPieces, PlayerSemaphores, LastMove], NextTurnBoard, [PieceColor, NewNrPieces, PlayerSemaphores, Move]):-
    setPieceAt(Move, Board, PieceColor, NewBoard),
    displayAIPlacePiece(Move, PieceColor),
    NewNrPieces is NrPieces - 1,
    lastMoveToLowerCase(LastMove, NewBoard, NextTurnBoard, PieceColor).

