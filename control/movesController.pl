:-include('../control/boardController.pl').

/**
    This file is where we make all the function that move the pieces.
*/



/*
    getValidMove(Move, Board)
    Uses the ui module to ask the user for a move.
    Checks if the move given is valid.
*/
getValidMove(Coords, Board):-
    askForMove(Coords),
    checkValidMove(Coords, Board).

getValidMove(Coords, Board):-
    askForMoveAgainMessage,
    getValidMove(Coords, Board).

/*
    checkValidMove(Move, Board)
    Checks if the move is valid. 
    Starts by checking if the column is in the correct range and checks if the spot is empty.
*/
checkValidMove([Column|Row], Board):-
    getStartColumn(Row, StartColumn),
    Column > (StartColumn - 1),
    getEndColumn(Row, EndColumn),
    Column < (EndColumn + 1),
    checkValidPiece(Column, Row, Board).

/* 
    checkValidPiece(Column, Row, Board).
    Gets the piece of the board at the row and column given.
    Checks if the spot is empty.
*/    
checkValidPiece(Column, Row, Board):-
    getPieceAt([Column|Row], Board, Piece),
    Piece = 'empty'.

/*
    move(Board, Player)
    Asks the move to be done.
    Checks if the move is valid.
    And places a piece of the Player in the Board at the coords given.
*/
move(Board, Player, NewBoard):-
    printBoard(Board),
    getValidMove(Coords, Board),
    setPieceAt(Coords, Board, Player, NewBoard),
    printBoard(NewBoard).