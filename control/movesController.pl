:-include('../control/boardController.pl').

/**
    This file is where we make all the function that move the pieces.
*/


test(Column, Row):-
    initial(Board),
    checkValidMove([Column|Row], Board).

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


checkValidMove(_, Board):-
    askForMoveAgain([NewColumn|NewRow]),
    checkValidMove([NewColumn|NewRow], Board).

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
    askForMove(Coords),
    checkValidMove(Coords, Board),
    setPieceAt(Coords, Board, Player, NewBoard).