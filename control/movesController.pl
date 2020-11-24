:-include('../control/boardController.pl').

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
move(Board, Player, NewBoard, UpdatedPlayer):-
    printBoard(Board),
    moveDisc(Board, Player, BoardMoved),
    %printBoard(BoardMoved),
    %moveEnemyDisc(BoardMoved, Player, BoardEnemyMoved),
    %printBoard(BoardEnemyMoved),
    placeDisc(Board, Player, NewBoard, UpdatedPlayer),
    printBoard(NewBoard).

/*
    placeDisc(Board, Player, NewBoard)
    Asks where to place the piece.
    Checks if the place is valid.
    And places a piece of the Player in the Board at the coords given.
*/
placeDisc(Board, [PieceColor | NrPieces], NewBoard, [PieceColor | NewNrPieces]):-
    NrPieces > 0,
    getValidPosition(Coords, Board, 'empty'),
    setPieceAt(Coords, Board, PieceColor, NewBoard),
    NewNrPieces is NrPieces - 1.

placeDisc(_, Player, _, Player).

moveDisc(Board, [PieceColor| PlayerPieces], BoardMoved):-
    PlayerPieces < 20,
    pieceColorLower(PieceColor, LowerColer),
    getValidPosition(Coords, Board, LowerColer),
    write(Coords).

moveDisc(Board, _, Board).

/*
    getValidPosition(Move, Board, PieceType)
    Uses the ui module to ask the user for a move.
    Checks if the position given as a piece equals to PieceType.
*/
getValidPosition(Coords, Board, PieceType):-
    askForMove(Coords),
    checkValidPosition(Coords, Board, PieceType).

getValidPosition(Coords, Board, PieceType):-
    askForMoveAgainMessage,
    getValidPosition(Coords, Board, PieceType).

/*
    checkValidPosition(Move, Board, PieceType)
    Checks if the move is valid. 
    Starts by checking if the column is in the correct range and checks if the spot has a piece of PieceType.
*/
checkValidPosition([Column|Row], Board, PieceType):-
    getStartColumn(Row, StartColumn),
    Column > (StartColumn - 1),
    getEndColumn(Row, EndColumn),
    Column < (EndColumn + 1),
    checkPiece(Column, Row, Board, PieceType).

/* 
    checkPiece(Column, Row, Board, PieceType).
    Gets the piece of the board at the row and column given.
    Checks if the spot is equal to PieceType.
*/    
checkPiece(Column, Row, Board, PieceType):-
    getPieceAt([Column|Row], Board, Piece),
    Piece = PieceType.