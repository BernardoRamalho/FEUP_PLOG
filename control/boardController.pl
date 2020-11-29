:-include('../display/ui.pl').

/**
    This file is where we make all the function that control the board.
    In here we have functions that interacts with the board.
*/

/*
    The board begins with all of its position empty and
    consists of a pyramid with 11 levels
*/
initial([
    [o, o, o, o, o, o, o, o, o, o, empty, o, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, o, empty, o, empty, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, empty, o, empty, o, empty, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o],
    [o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o],
    [o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o],
    [o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o],
    [o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o],
    [empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty]
]).

expe([
    [o, o, o, o, o, o, o, o, o, o, empty, o, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, o, empty, o, green, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, green, o, yellow, o, empty, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, green, o, empty, o, empty, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, green, o, empty, o, red, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, red, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o],
    [o, o, o, o, red, o, empty, o, green, o, empty, o, empty, o, yellow, o, empty, o, o, o, o],
    [o, o, o, empty, o, empty, o, empty, o, yellow, o, empty, o, empty, o, empty, o, empty, o, o, o],
    [o, o, red, o, yellow, o, empty, o, empty, o, empty, o, empty, o, 'Red', o, 'Green', o, empty, o, o],
    [o, red, o, red, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o],
    [empty, o, green, o, empty, o, empty, o, empty, o, empty, o, green, o, empty, o, red, o, empty, o, empty]
]).

/*
    checkValidCoords(Coords);
    Checks if the coords are inside the correct interval
*/
checkValidCoords([Column,Row]):-
    getStartColumn(Row, StartColumn),
    Column > (StartColumn - 1),
    getEndColumn(Row, EndColumn),
    Column < (EndColumn + 1).
	
	
	
/*
    checkValidCoordsInside(Coords);
    Checks if the coords are inside the correct interval for 
	a yellow disc
*/
checkValidCoordsInside([Column,Row]):-
    getStartColumn(Row, StartColumn1),
	StartColumn is StartColumn1 + 2,
    Column > (StartColumn - 1),
    getEndColumn(Row, EndColumn1),
	EndColumn is EndColumn1 - 2,
    Column < (EndColumn + 1).	


/*
    getValidPosition(Move, Board, PieceType)
    Uses the ui module to ask the user for a move.
    Checks if the position given as a piece equals to PieceType.
*/
getValidPosition(Coords, Board, PieceType, PieceColor):-
    askPlacePiece(Coords),
    checkValidPosition(Coords, Board, PieceType),
    \+ checkForSemaphore(Coords, Board, PieceColor, _).

getValidPosition(Coords, Board, PieceType, PieceColor):-
    invalidInputMessage,
    getValidPosition(Coords, Board, PieceType, PieceColor).
	
	
	
/*
    getValidYellowPosition(Move, Board, PieceType)
    Uses the ui module to ask the user for a move.
    Checks if the position given as a piece equals to PieceType.
*/
getValidYellowPosition(Coords, Board, PieceType):-
    askPlacePiece(Coords),
    checkValidYellowPosition(Coords, Board, PieceType).
   
getValidYellowPosition(Coords, Board, PieceType):-
    invalidInputMessage,
    getValidYellowPosition(Coords, Board, PieceType).	

/*
    getValidPiece(PieceCoords, Board, PieceType)
    Uses the ui module to ask the user for the position of a piece.
    Checks if the position given as a piece equals to PieceType.
*/
getValidPiece(Coords, Board, PieceType):-
    askPiece(Coords, PieceType),
    checkValidPosition(Coords, Board, PieceType).

getValidPiece(Coords, Board, PieceType):-
    invalidInputMessage,
    getValidPiece(Coords, Board, PieceType).


/*
    checkValidPosition(Move, Board, PieceType)
    Starts by checking if the column is in the correct range and checks if the spot has a piece of PieceType.
*/
checkValidPosition([Column,Row], Board, PieceType):-
    checkValidCoords([Column,Row]),
    !,
    checkPiece(Column, Row, Board, PieceType).
	
	

/*
    checkValidYellowPosition(Move, Board, PieceType)
    Starts by checking if the column is in the correct range(not outside the board and not in the edges or corners) and checks if the spot is empty
*/
checkValidYellowPosition([Column,Row], Board,PieceType):-
    checkValidCoordsInside([Column,Row]),
    checkPiece(Column, Row, Board, PieceType).

/* 
    checkPiece(Column, Row, Board, PieceType).
    Gets the piece of the board at the row and column given.
    Checks if the spot is equal to Piece.
*/    
checkPiece(Column, Row, Board, PieceType):-
    getPieceAt([Column,Row], Board, Piece),
    Piece = PieceType.

/*
    getPieceAt(Coords, Board, Piece).
    This function goes through the board until it gets to the Piece at the coordinates given.
*/ 
getPieceAt([Column,Row], Board, Piece):-
    getElementAt(Row, Board, PieceRow),
    getElementAt(Column, PieceRow, Piece).

/*
    setPieceAt(Coords, Board, Piece, NewBoard).
    This function goes through the board and changes the piece at Coords to the piece given.
    The new board state is saved in the NewBoard variable.
*/ 
setPieceAt([Column,Rows], Board, PlayerPiece, NewBoard):-
    getPieceRow(Rows, Board, FirstRows, PieceRow, BoardRemaining),
    changePieceAt(Column, PieceRow, PlayerPiece, ChangedRow),
    createNewBoard(NewBoard, FirstRows, ChangedRow, BoardRemaining).

/*
    getPieceRow(Rows, Board, FirstRows, PieceRow, BoardRemaining).
    Goes through a number (Rows) of rows of the Board, saving them in FirtRows.
    When it get to the last row, it saves it in PieceRow and the rest raws in BoardRemaining
*/
getPieceRow(1, [H | T], [], H, T).

getPieceRow(Rows, [H | T], [H | X], PieceRow, BoardRemaining):-
    NewRows is Rows - 1,
    getPieceRow(NewRows, T, X, PieceRow, BoardRemaining).

/*
    changePieceAt(Column, PieceRow, PlayerPiece, ChangedRow).
    Goes through the piece row until it gets to Column. Changes the piece there to Player piece.
    Save the changed row to ChangedRow.
*/
changePieceAt(1, [_ | T], PlayerPiece, [PlayerPiece | T]).


changePieceAt(Column, [H | T], PlayerPiece, [H | Z]):-
    NewColumn is Column - 1,
    changePieceAt(NewColumn, T, PlayerPiece, Z).

/*
    createNewBoard(NewBoard, FirstRows, ChangedRow, BoardRemaining)
*/
% Everything as been added
createNewBoard([], [], [], []).

% Add the BoardRemaining
createNewBoard([H | T], [], [], [H|Z]):-
    createNewBoard(T, [], [], Z).

% Add the ChangedRow
createNewBoard([ChangedRow|T], [], ChangedRow, BoardRemaining):-
    createNewBoard(T, [], [], BoardRemaining).

% Add the FirstRows
createNewBoard([H|T], [H|Z], ChangedRow, BoardRemaining):-
    createNewBoard(T, Z, ChangedRow, BoardRemaining).

/*
    lastMoveToLowerCase(LastMove, NewBoard, NextTurnBoard)
    Converts the last Move made to a lower case piece, representing removing the cylinder.
*/

lastMoveToLowerCase([], Board, Board, _).

lastMoveToLowerCase(LastMove, Board, NextTurnBoard, PieceColor):-
    pieceColorLower(PieceColor, LowerCaseColor),
    setPieceAt(LastMove, Board, LowerCaseColor, NextTurnBoard).


% Calculates the number of moves in each direction for a piece
getNumberMoves(Board, PieceCoords, [MovesNW, MovesNE, MovesE]):-
    getNumberMovesNWDiagonal(Board, PieceCoords, MovesNW),
    getNumberMovesNEDiagonal(Board, PieceCoords, MovesNE),
    getNumberMovesEDiagonal(Board, PieceCoords, MovesE).


/*

    Get number of moves in each direction

*/

getNumberMovesNWDiagonal(Board, Start, Moves):-
    getNumberNWMoves(Board, Start, MovesNW),
    getNumberSEMoves(Board, Start, MovesSE),
    MovesCalculated is MovesNW + MovesSE,
    Moves is MovesCalculated + 1.

getNumberMovesNEDiagonal(Board, Start, Moves):-
    getNumberNEMoves(Board, Start, MovesNE),
    getNumberSWMoves(Board, Start, MovesSW),
    MovesCalculated is MovesNE + MovesSW,
    Moves is MovesCalculated + 1.

getNumberMovesEDiagonal(Board, Start, Moves):-
    getNumberEMoves(Board, Start, MovesE),
    getNumberWMoves(Board, Start, MovesW),
    MovesCalculated is MovesE + MovesW,
    Moves is MovesCalculated + 1.

/*

    Get number of moves in each way

*/
% Calculates the number of moves in the North West direction
getNumberNWMoves(Board, [Column,Row], MovesNW):-
    NewColumn is Column - 1,
    NewRow is Row - 1,
    checkValidPosition([NewColumn,NewRow], Board, 'empty'),
    getNumberNWMoves(Board,[NewColumn,NewRow], MovesNW).

getNumberNWMoves(Board, [Column,Row], MovesNW):-
    NewColumn is Column - 1,
    NewRow is Row - 1,
    checkValidCoords([NewColumn,NewRow]),
    getNumberNWMoves(Board,[NewColumn,NewRow], Moves),
    MovesNW is Moves + 1.

getNumberNWMoves(_, _, 0).

% Calculates the number of moves in the North East direction
getNumberNEMoves(Board, [Column,Row], MovesNE):-
    NewColumn is Column + 1,
    NewRow is Row - 1,
    checkValidPosition([NewColumn,NewRow], Board, 'empty'),
    getNumberNEMoves(Board,[NewColumn,NewRow], MovesNE).

getNumberNEMoves(Board, [Column,Row], MovesNE):-
    NewColumn is Column + 1,
    NewRow is Row - 1,
    checkValidCoords([NewColumn,NewRow]),
    getNumberNEMoves(Board,[NewColumn,NewRow], Moves),
    MovesNE is Moves + 1.

getNumberNEMoves(_, _, 0).

% Calculates the number of moves in the South West direction
getNumberSWMoves(Board, [Column,Row], MovesSW):-
    NewColumn is Column - 1,
    NewRow is Row + 1,
    checkValidPosition([NewColumn,NewRow], Board, 'empty'),
    getNumberSWMoves(Board,[NewColumn,NewRow], MovesSW).

getNumberSWMoves(Board, [Column,Row], MovesSW):-
    NewColumn is Column - 1,
    NewRow is Row + 1,
    checkValidCoords([NewColumn,NewRow]),
    getNumberSWMoves(Board,[NewColumn,NewRow], Moves),
    MovesSW is Moves + 1.

getNumberSWMoves(_, _, 0).

% Calculates the number of moves in the South East direction
getNumberSEMoves(Board, [Column,Row], MovesSE):-
    NewColumn is Column + 1,
    NewRow is Row + 1,
    checkValidPosition([NewColumn,NewRow], Board, 'empty'),
    getNumberSEMoves(Board,[NewColumn,NewRow], MovesSE).

getNumberSEMoves(Board, [Column,Row], MovesSE):-
    NewColumn is Column + 1,
    NewRow is Row + 1,
    checkValidCoords([NewColumn,NewRow]),
    getNumberSEMoves(Board,[NewColumn,NewRow], Moves),
    MovesSE is Moves + 1.

getNumberSEMoves(_, _, 0).

% Calculates the number of moves in the West direction
getNumberWMoves(Board, [Column,Row], MovesW):-
    NewColumn is Column - 2,
    checkValidPosition([NewColumn,Row], Board, 'empty'),
    getNumberWMoves(Board,[NewColumn,Row], MovesW).

getNumberWMoves(Board, [Column,Row], MovesW):-
    NewColumn is Column - 2,
    checkValidCoords([NewColumn,Row]),
    getNumberWMoves(Board,[NewColumn,Row], Moves),
    MovesW is Moves + 1.

getNumberWMoves(_, _, 0).

% Calculates the number of moves in the East direction
getNumberEMoves(Board, [Column,Row], MovesE):-
    NewColumn is Column + 2,
    checkValidPosition([NewColumn,Row], Board, 'empty'),
    getNumberEMoves(Board,[NewColumn,Row], MovesE).

getNumberEMoves(Board, [Column,Row], MovesE):-
    NewColumn is Column + 2,
    checkValidCoords([NewColumn,Row]),
    getNumberEMoves(Board,[NewColumn,Row], Moves),
    MovesE is Moves + 1.

getNumberEMoves(_, _, 0).

/*


                    SEMAPHORES


*/



/*
    checkForSemaphore(Coords, Board)
    Checks if a semaphore exists starting from Coords.
*/  

checkForSemaphore(Coords, Board, PlayerColor, NrSemaphores):-
    enemyColor(PlayerColor, EnemyColor),
    checkForNESemaphore(Coords, EnemyColor, Board, NrSemaphores, _).

checkForSemaphore(Coords, Board, PlayerColor, NrSemaphores):-
    enemyColor(PlayerColor, EnemyColor),
    checkForNWSemaphore(Coords, EnemyColor, Board, NrSemaphores, _).

checkForSemaphore(Coords, Board, PlayerColor, NrSemaphores):-
    enemyColor(PlayerColor, EnemyColor),
    checkForSESemaphore(Coords, EnemyColor, Board, NrSemaphores, _).

checkForSemaphore(Coords, Board, PlayerColor, NrSemaphores):-
    enemyColor(PlayerColor, EnemyColor),
    checkForSWSemaphore(Coords, EnemyColor, Board, NrSemaphores, _).

checkForSemaphore(Coords, Board, PlayerColor, NrSemaphores):-
    enemyColor(PlayerColor, EnemyColor),
    checkForESemaphore(Coords, EnemyColor, Board, NrSemaphores, _).

checkForSemaphore(Coords, Board, PlayerColor, NrSemaphores):-
    enemyColor(PlayerColor, EnemyColor),
    checkForWSemaphore(Coords, EnemyColor, Board, NrSemaphores, _).

getSemaphores(Coords, PlayerColor, Board, NrSemaphores, NewBoard):-
    enemyColor(PlayerColor, EnemyColor),
    controlSemaphores(Coords, EnemyColor, Board, NrSemaphores, NewBoard).

controlSemaphores(Coords, EnemyColor, Board, NrSemaphores, NewBoard):-
    nWSemaphore(Coords, EnemyColor, Board, NWSemaphores, NWBoard),
    nESemaphore(Coords, EnemyColor, NWBoard, NESemaphores, NEBoard),
    sWSemaphore(Coords, EnemyColor, NEBoard, SWSemaphores, SWBoard),
    sESemaphore(Coords, EnemyColor, SWBoard, SESemaphores, SEBoard),
    eSemaphore(Coords, EnemyColor, SEBoard, ESemaphores, EBoard),
    wSemaphore(Coords, EnemyColor, EBoard, WSemaphores, NewBoard),
    sumlist([NWSemaphores, NESemaphores, SWSemaphores, SESemaphores, ESemaphores, WSemaphores], NrSemaphores).


nWSemaphore(Coords, EnemyColor, Board, NWSemaphores, NWBoard):-
    checkForNWSemaphore(Coords, EnemyColor, Board, NWSemaphores, [YellowPostion, EnemyPosition]),
    deleteSemaphore(Coords, YellowPostion, EnemyPosition, Board, NWBoard).

nWSemaphore(_, _, Board, 0, Board).

nESemaphore(Coords, EnemyColor, Board, NESemaphores, NEBoard):-
    checkForNESemaphore(Coords, EnemyColor, Board, NESemaphores, [YellowPostion, EnemyPosition]),
    deleteSemaphore(Coords, YellowPostion, EnemyPosition, Board, NEBoard).

nESemaphore(_, _, Board, 0, Board).

sWSemaphore(Coords, EnemyColor, Board, SWSemaphores, SWBoard):-
    checkForSWSemaphore(Coords, EnemyColor, Board, SWSemaphores, [YellowPostion, EnemyPosition]),
    deleteSemaphore(Coords, YellowPostion, EnemyPosition, Board, SWBoard).
sWSemaphore(_, _, Board, 0, Board).

sESemaphore(Coords, EnemyColor, Board, SESemaphores, SEBoard):-
    checkForSESemaphore(Coords, EnemyColor, Board, SESemaphores, [YellowPostion, EnemyPosition]),
    deleteSemaphore(Coords, YellowPostion, EnemyPosition, Board, SEBoard).
sESemaphore(_, _, Board, 0, Board).

wSemaphore(Coords, EnemyColor, Board, WSemaphores, WBoard):-
    checkForWSemaphore(Coords, EnemyColor, Board, WSemaphores, [YellowPostion, EnemyPosition]),
    deleteSemaphore(Coords, YellowPostion, EnemyPosition, Board, WBoard).
wSemaphore(_, _, Board, 0, Board).

eSemaphore(Coords, EnemyColor, Board, ESemaphores, EBoard):-
    checkForESemaphore(Coords, EnemyColor, Board, ESemaphores, [YellowPostion, EnemyPosition]),
    deleteSemaphore(Coords, YellowPostion, EnemyPosition, Board, EBoard).
eSemaphore(_, _, Board, 0, Board).

/*
    Checks if there is a semaphore in the North West direction
*/
checkForNWSemaphore([Column, Row], EnemyColor, Board, 1, [[YellowColumn,YellowRow], [EnemyColumn,EnemyRow]]):-
    /* Check for a Yellow Piece*/
    % Get Yellow Piece Position
    YellowColumn is Column - 1,
    YellowRow is Row - 1,
    checkValidCoords([YellowColumn,YellowRow]),
    checkPiece(YellowColumn, YellowRow, Board, 'yellow'),

    /* Check for an Enemy Piece*/
    % Get Enemy piece positon
    EnemyColumn is Column - 2,
    EnemyRow is Row - 2,

    % Check if the position is valid
    checkValidCoords([EnemyColumn,EnemyRow]),

    % Check if the piece is Enemy
    getPieceAt([EnemyColumn,EnemyRow], Board, Piece),
    pieceColorLower(Piece, LowerPiece),
    LowerPiece = EnemyColor.

/*
    Checks if there is a semaphore in the North East direction
*/
checkForNESemaphore([Column, Row], EnemyColor, Board, 1, [[YellowColumn,YellowRow], [EnemyColumn,EnemyRow]]):-
    /* Check for a Yellow Piece*/
    % Get Yellow Piece Position
    YellowColumn is Column + 1,
    YellowRow is Row - 1,
    checkValidCoords([YellowColumn,YellowRow]),
    checkPiece(YellowColumn, YellowRow, Board, 'yellow'),

    /* Check for an Enemy Piece*/
    % Get Enemy piece positon
    EnemyColumn is Column + 2,
    EnemyRow is Row - 2,
    % Check if the position is valid
    checkValidCoords([EnemyColumn,EnemyRow]),
    % Check if the piece is Enemy
    getPieceAt([EnemyColumn,EnemyRow], Board, Piece),
    pieceColorLower(Piece, LowerPiece),
    LowerPiece = EnemyColor.

/*
    Checks if there is a semaphore in the South West direction
*/
checkForSWSemaphore([Column, Row], EnemyColor, Board, 1, [[YellowColumn,YellowRow], [EnemyColumn,EnemyRow]]):-
    /* Check for a Yellow Piece*/
    % Get Yellow Piece Position
    YellowColumn is Column - 1,
    YellowRow is Row + 1,
    checkValidCoords([YellowColumn,YellowRow]),
    checkPiece(YellowColumn, YellowRow, Board, 'yellow'),

    /* Check for an Enemy Piece*/
    % Get Enemy piece positon
    EnemyColumn is Column - 2,
    EnemyRow is Row + 2,
    % Check if the position is valid
    checkValidCoords([EnemyColumn,EnemyRow]),
    % Check if the piece is Enemy
    getPieceAt([EnemyColumn,EnemyRow], Board, Piece),
    pieceColorLower(Piece, LowerPiece),
    LowerPiece = EnemyColor.

/*
    Checks if there is a semaphore in the South East direction
*/
checkForSESemaphore([Column, Row], EnemyColor, Board, 1, [[YellowColumn,YellowRow], [EnemyColumn,EnemyRow]]):-
    /* Check for a Yellow Piece*/
    % Get Yellow Piece Position
    YellowColumn is Column + 1,
    YellowRow is Row + 1,
    checkValidCoords([YellowColumn,YellowRow]),
    checkPiece(YellowColumn, YellowRow, Board, 'yellow'),

    /* Check for an Enemy Piece*/
    % Get Enemy piece positon
    EnemyColumn is Column + 2,
    EnemyRow is Row + 2,
    % Check if the position is valid
    checkValidCoords([EnemyColumn,EnemyRow]),
    % Check if the piece is Enemy
    getPieceAt([EnemyColumn,EnemyRow], Board, Piece),
    pieceColorLower(Piece, LowerPiece),
    LowerPiece = EnemyColor.

/*
    Checks if there is a semaphore in the East direction
*/
checkForESemaphore([Column, Row], EnemyColor, Board, 1, [[YellowColumn,Row], [EnemyColumn,Row]]):-
    /* Check for a Yellow Piece*/
    % Get Yellow Piece Position
    YellowColumn is Column + 2,
    checkValidCoords([YellowColumn,Row]),
    checkPiece(YellowColumn, Row, Board, 'yellow'),

    /* Check for an Enemy Piece*/
    % Get Enemy piece positon
    EnemyColumn is Column + 4,
    % Check if the position is valid
    checkValidCoords([EnemyColumn,Row]),
    % Check if the piece is Enemy
    getPieceAt([EnemyColumn,Row], Board, Piece),
    pieceColorLower(Piece, LowerPiece),
    LowerPiece = EnemyColor.

/*
    Checks if there is a semaphore in the West direction
*/
checkForWSemaphore([Column, Row], EnemyColor, Board, 1, [[YellowColumn,Row], [EnemyColumn,Row]]):-
    /* Check for a Yellow Piece*/
    % Get Yellow Piece Position
    YellowColumn is Column - 2,
    checkValidCoords([YellowColumn,Row]),
    checkPiece(YellowColumn, Row, Board, 'yellow'),

    /* Check for an Enemy Piece*/
    % Get Enemy piece positon
    EnemyColumn is Column - 4,

    % Check if the position is valid
    checkValidCoords([EnemyColumn,Row]),

    % Check if the piece is Enemy
    getPieceAt([EnemyColumn,Row], Board, Piece),
    pieceColorLower(Piece, LowerPiece),
    LowerPiece = EnemyColor.

/*
    deleteSemaphore(PlayerPos, YellowPos, EnemyPos, Board, NewBoard).
    Deletes a Semaphore.
*/
deleteSemaphore(PlayerPos, YellowPos, EnemyPos, Board, NewBoard):-
    setPieceAt(PlayerPos, Board, 'empty', NoPlayerBoard),
    setPieceAt(YellowPos, NoPlayerBoard, 'empty', NoEnemyBoard),
    setPieceAt(EnemyPos, NoEnemyBoard, 'empty', NewBoard).
