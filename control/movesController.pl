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
move(Board, Player, NewBoard, UpdatedPlayer):-
    printBoard(Board),
    movePlayerDisc(Board, Player, BoardMoved),
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

movePlayerDisc(Board, [PieceColor| PlayerPieces], BoardMoved):-
    % There must be pieces on the board
    PlayerPieces < 20,
    pieceColorLower(PieceColor, LowerColer),

    % Ask for a piece to move
    getValidPiece(Coords, Board, LowerColer),
    
    % Generate all possible Moves
    getNumberMoves(Board, Coords, [MovesNW, MovesNE, MovesE]),
    generateAllMoves(Coords, EndCoords, Board, MovesNW, MovesNE, MovesE),
    selectMove(EndCoords, SelectedMove),
    write(SelectedMove).


movePlayerDisc(Board, _, Board).

