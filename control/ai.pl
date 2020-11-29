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

    % Ask the other player to put another yellow piece
    PiecesPlaced is Counter+1,
	enemyColor(PieceColor,EnemyPieceColor),
	setupPvE(PiecesPlaced,NewBoard,EnemyPieceColor,NewTurnBoard, 'player').